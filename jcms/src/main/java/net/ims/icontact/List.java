package net.ims.icontact;

import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.text.ParseException;
import java.util.Date;

/**
 * Object which embodies a single List record.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class List extends Resource {

  // primary key
  private int listId = 0;

  // required fields
  public String name;
  public boolean emailOwnerOnChange;
  public boolean welcomeOnManualAdd;
  public boolean welcomeOnSignupAdd;
  public int welcomeMessageId;

  // optional fields
  public String description;
  
  /**
   * Create a new List in the given account and client folder with the given name
   * @param creds
   * @param account
   * @param clientFolder
   * @param name
   * @param emailOwnerOnChange
   * @param welcomeOnManualAdd
   * @param welcomeOnSignupAdd
   * @param welcomeMessageId
   */
  public List(Credentials creds, Account account, ClientFolder clientFolder, String name, boolean emailOwnerOnChange, boolean welcomeOnManualAdd, boolean welcomeOnSignupAdd, int welcomeMessageId)
    throws ValidationException, ResourceNotFoundException, MalformedURLException, ParseException, WarningException {
    if (name==null) throw new ValidationException("Supplied list name is null.");
    if (welcomeMessageId==0) throw new ValidationException("Supplied list welcome message ID is zero.");
    // check that given message is, in fact, a welcome message
    Message message = new Message(creds, account, clientFolder, welcomeMessageId);
    if (!message.messageType.equals("welcome")) throw new ValidationException("Supplied message ID "+welcomeMessageId+" is for a message of type "+message.messageType+", not welcome, as required.");
    this.name = name;
    this.emailOwnerOnChange = emailOwnerOnChange;
    this.welcomeOnManualAdd = welcomeOnManualAdd;
    this.welcomeOnSignupAdd = welcomeOnSignupAdd;
    this.welcomeMessageId = welcomeMessageId;
    create(creds, account, clientFolder);
  }

  /**
   * Retrieve a single List with the given listId
   * @param creds the Credentials
   * @param account the Account
   * @param clientFolder the ClientFolder
   * @param pkey the List primary key (listId)
   */
  public List(Credentials creds, Account account, ClientFolder clientFolder, int pkey) throws ValidationException, ResourceNotFoundException, MalformedURLException, ParseException, WarningException {
    if (pkey==0) throw new ValidationException("Supplied list ID is zero.");
    get(creds, account, clientFolder, pkey);
  }

  /**
   * Instantiate this List using the data contained in the provided XML
   * @param xml the XML data
   */
  public List(XML xml) throws ParseException, WarningException {
    parseXML(xml);
  }

  /**
   * Return the resource tag
   */
  public String getTag() {
    return "lists";
  }

  /**
   * Return the primary key listId value
   * @return listId value
   */
  public int getPrimaryKey() {
    return listId;
  }

  /**
   * Parse an XML response into current instance variables.  Missing values will set those variables to null.
   */
  public void parseXML(XML xml) throws ParseException, WarningException {
    String warnings = xml.getWarnings();
    if (warnings!=null) throw new WarningException(warnings);
    listId = xml.getInt("listId");
    name = xml.getString("name");
    emailOwnerOnChange = xml.getBoolean("emailOwnerOnChange");
    welcomeOnManualAdd = xml.getBoolean("welcomeOnManualAdd");
    welcomeOnSignupAdd = xml.getBoolean("welcomeOnSignupAdd");
    welcomeMessageId = xml.getInt("welcomeMessageId");
    description = xml.getString("description");
  }

  /**
   * Generate the XML for this list, only containing non-null fields. Throw ValidationException if email is not present.
   * @return XML block for list
   */
  public XML getXML() {
    XML xml = new XML();
    xml.openResource("list");
    xml.appendInt("listId", listId);
    xml.appendString("name", name);
    xml.appendBoolean("emailOwnerOnChange", emailOwnerOnChange);
    xml.appendBoolean("welcomeOnManualAdd", welcomeOnManualAdd);
    xml.appendBoolean("welcomeOnSignupAdd", welcomeOnSignupAdd);
    xml.appendInt("welcomeMessageId", welcomeMessageId);
    xml.appendString("description", description);
    xml.closeResource("list");
    return xml;
  }

  /**
   * Return an array of all lists in the given account and client folder.
   */
  public static List[] getAll(Credentials creds, Account account, ClientFolder clientFolder) throws ResourceNotFoundException, MalformedURLException, ParseException, WarningException {
    URL url = creds.getURL(account, clientFolder, "lists");
    try {
      XML response = creds.doGet(url);
      XML[] chunks = XML.getChunks(response, "lists", "list");
      List[] lists = new List[chunks.length];
      for (int i=0; i<chunks.length; i++) lists[i] = new List(chunks[i]);
      return lists;
    } catch (IOException ex) {
      throw new ResourceNotFoundException("Resource not found: "+ex.getMessage());
    }
  }

}

