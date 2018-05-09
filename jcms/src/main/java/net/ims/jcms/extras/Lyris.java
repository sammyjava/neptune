package net.ims.jcms.extras;

import net.ims.jcms.ValidationException;

import lmapi.*;
import org.apache.axis.client.Stub;

import java.io.IOException;
import java.rmi.RemoteException;

import javax.mail.MessagingException;
import javax.servlet.ServletContext;
import javax.xml.rpc.*;

/**
 * Collection of methods for Lyris operations over SOAP interface.  Requires Apache Axis and JWSDP.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class Lyris {

  public final static String API_VERSION = "1.5.2a";

  // lm is used to make the calls througout; public so can be used outside of here as well
  public LmapiSoap_PortType lm;

  // web.xml context initialization parameters
  private static final String USERKEY = "lyris.username";
  private static final String PASSWORDKEY = "lyris.password";

  /**
   * Construct by initializing the service and get a stub for operations
   */
  public Lyris(ServletContext context) throws ServiceException, ValidationException {

    // Get Lyris username and password from web.xml initialization params
    String username = context.getInitParameter(USERKEY);
    String password = context.getInitParameter(PASSWORDKEY);
    if (username==null || password==null) throw new ValidationException("Lyris connection parameters "+USERKEY+" and/or "+PASSWORDKEY+" are missing in web.xml.");

    // Make a service
    Lmapi service = null;
    try {
      service = new LmapiLocator();
    } catch (Exception ex) {
      throw new ServiceException("LmapyLocator() threw "+ex.toString());
    }
    
    // Get a stub that implements the service operations
    try {
      lm = service.getlmapiSoap();
    } catch (Exception ex) {
      throw new ServiceException("service.getlmapiSoap() threw "+ex.toString());
    }

    // Lyris API authentication
    ((Stub)lm).setUsername(username);
    ((Stub)lm).setPassword(password);

  }

  /**
   * Create a single member and return the member ID.  If member already exists and has "unsub" or "confirm" status, send confirm doc.  Throws an exception otherwise.
   */
  public int createSingleMember(String email, String fullname, String listname) throws RemoteException, ServiceException {

    int memberid = 0;

    // create the member - trap exception if member already on list!
    try {
      Integer memberID = new Integer(lm.createSingleMember(email, fullname, listname));
      if (memberID!=null) {
	updateMemberStatus(email, listname, "confirm");
	sendMemberDoc(email, listname, "confirm");
	return memberID.intValue();
      } else {
	return 0;
      }
    } catch (RemoteException ex) {
      if (ex.getMessage().contains("already exists")) {
	// member exists, switch to "confirm" status
	MemberStruct member = selectSingleMember(email, listname);
	if (member!=null) {
	  String status = member.getMemberStatus().toString();
	  if (status.equals("unsub")) updateMemberStatus(email, listname, "confirm");
	  if (status.equals("unsub") || status.equals("confirm")) sendMemberDoc(email, listname, "confirm");
	}
	return member.getMemberID().intValue();
      } else {
	throw new RemoteException(ex.getMessage());
      }
    }

  }

  /**
   * Delete a single member and return true if it worked.
   */
  public boolean deleteSingleMember(String email, String listname) throws RemoteException, ServiceException {
    
    // delete the member
    String[] memberDeleteArray = {"ListName="+listname, "EmailAddress LIKE "+email};
    int numDeleted = lm.deleteMembers(memberDeleteArray);

    return (numDeleted==1);
    
  }

  /**
   * Update member status: normal member confirm private expired held unsub referred needs-confirm needs-hello; return true if successful.
   */
  public boolean updateMemberStatus(String email, String listname, String status) throws RemoteException, ServiceException {
    
    // validation
    if (email==null || listname==null || status==null) return false;
 
    // member
    SimpleMemberStruct simpleMember = new SimpleMemberStruct();
    simpleMember.setEmailAddress(email);
    simpleMember.setListName(listname);

    // Enumeration constructors are protected, so use fromString method
    MemberStatusEnum memberStatus = MemberStatusEnum.fromString(status);

    // update
    return lm.updateMemberStatus(simpleMember, memberStatus);

  }

  /**
   * Update member demographics from a matching set of name/value arrays; return true if successful.
   */
  public boolean updateMemberDemographics(String email, String listname, String names[], String values[]) throws RemoteException, ServiceException {

    // validation
    if (email==null || listname==null || names==null || values==null || names.length==0 || values.length==0 || names.length!=values.length) return false;

    // member
    SimpleMemberStruct simpleMember = new SimpleMemberStruct();
    simpleMember.setEmailAddress(email);
    simpleMember.setListName(listname);

    // demographics key/values
    KeyValueType[] keyValues = new KeyValueType[names.length];
    for (int i=0; i<keyValues.length; i++) {
      keyValues[i] = new KeyValueType();
      keyValues[i].setName(names[i]);
      keyValues[i].setValue(values[i]);
    }

    return lm.updateMemberDemographics(simpleMember, keyValues);

  }	

  /**
   * Select members based on filter criteria (array of string criteria, like "ListName=mylist"); return array of SimpleMemberStruct.
   */
  public SimpleMemberStruct[] selectSimpleMembers(String[] filterCriteriaArray) throws RemoteException, ServiceException {

    // validation
    if (filterCriteriaArray==null) return null;

    return lm.selectSimpleMembers(filterCriteriaArray);

  }

  /**
   * Return a MemberStruct for a single member, given email and listname.  Utility method that calls SelectMembers.  Returns null if none found.
   */
  public MemberStruct selectSingleMember(String email, String listname) throws RemoteException, ServiceException {
    String[] fca = {"EmailAddress="+email, "ListName="+listname};
    MemberStruct[] memberstructs = lm.selectMembers(fca);
    if (memberstructs.length>0) {
      return memberstructs[0];
    } else {
      return null;
    }
  }

  /**
   * Select a single list using selectLists; return the single ListStruct.
   */
  public ListStruct selectList(String listname) throws RemoteException, ServiceException {
    ListStruct[] listStructs = lm.selectLists(listname, null);
    return listStructs[0];
  }

  /**
   * Send the named member doc to the member identified by email and list name, if they exist.
   */
  public void sendMemberDoc(String email, String listname, String messagetype) throws RemoteException, ServiceException {
    // get the member in a SimpleMemberStruct
    String [] fca = {"EmailAddress="+email, "ListName="+listname};
    SimpleMemberStruct[] simpleMembers = selectSimpleMembers(fca);
    if (simpleMembers.length>0) {
      int messageID = lm.sendMemberDoc(simpleMembers[0], MessageTypeEnum.fromString(messagetype));
    }
  }

  /**
   * Query all the messages from a given list and return the results as an array of Message instances without the body data, most recent first.
   * This is faster than pulling the full messages, since the message body is so huge.
   */
  public Message[] getMessageHeaders(String list) throws RemoteException, ServiceException, IOException, MessagingException {
    String query = "SELECT NULL,creatstamp_,digested_,hdrall_,hdrdate_,hdrfrom_,hdrfromspc_,hdrto_,list_,memberid_,messageid_,parentid_,subsetid_,title_,hdrsubject_ FROM messages_ WHERE list_='"+list+"' ORDER BY creatstamp_ DESC";
    String result[][] = lm.sqlSelect(query);
    int num = result.length - 1; // result[0] hold field names
    Message[] messages = new Message[num];
    for (int i=0; i<num; i++) {
      int j = i + 1; // result index
      messages[i] = new Message(result[j]);
    }
    return messages;
  }

  /**
   * Return a single message, identified by message ID.
   */
  public Message getMessage(int messageid) throws RemoteException, ServiceException, IOException, MessagingException {
    String query = "SELECT * FROM messages_ WHERE messageid_="+messageid;
    String result[][] = lm.sqlSelect(query);
    return new Message(result[1]);
  }

}

