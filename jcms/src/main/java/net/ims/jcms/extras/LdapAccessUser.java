package net.ims.jcms.extras;

import net.ims.jcms.*;

import java.util.Vector;
import java.util.TreeMap;
import javax.naming.AuthenticationException;
import javax.naming.Context;
import javax.naming.NameNotFoundException;
import javax.naming.NamingEnumeration;
import javax.naming.NamingException;
import javax.naming.directory.Attribute;
import javax.naming.directory.Attributes;
import javax.naming.directory.BasicAttribute;
import javax.naming.directory.BasicAttributes;
import javax.naming.directory.InitialDirContext;
import javax.naming.directory.SearchResult;
import javax.naming.directory.SearchControls;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpSession;

/**
 * Implementation of AccessUser for users authenticated from an LDAP store.
 *
 * LDAP parameters are provided in web.xml; since this class is used on both the 
 * site root and control panel, you must duplicate the LDAP parameters in both web.xml files.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class LdapAccessUser extends AccessUser {

  /** the users's LDAP username (cn) */
  public String username = null;

  /** the user's last name (sn) */
  public String lastname = null;

  /** the user's first name (givenname) */
  public String firstname = null;

  /** the user's email address (mail) */
  public String email = null;

  // access user-specific web.xml context parameters
  public static String USERS_DN = "ldap.accessusersdn"; // DN of site access users for authentication

  /**
   * Construct a default instance; needed to be able to access User methods, since none are static.
   */
  public LdapAccessUser() {
  }

  /**
   * Construct given a populated set of LDAP attributes
   */
  LdapAccessUser(Attributes attribs) throws NamingException {
    populate(attribs);
  }


  /**
   * Populate the instance variables from the attributes of a SearchResult.
   */
  void populate(Attributes attribs) throws NamingException {
    username = (String)attribs.get("cn").get();
    firstname = (String)attribs.get("givenname").get();
    lastname = (String)attribs.get("sn").get();
    email = (String)attribs.get("mail").get();
  }

  /**
   * Comparator required by Comparable interface.
   */
  public int compareTo(Object o) {
    LdapAccessUser that = (LdapAccessUser)o;
    return this.username.compareTo(that.username);
  }

  /**
   * Return true if this role equals the provided one.
   */
  public boolean equals(AccessUser that) {
    return this.username.equals(that.getUsername());
  }

  /**
   * Return true if this user is (default) public user.
   */
  public boolean isDefault() {
    return username==null;
  }

  /**
   * Factory method to return a default AccessUser instance.  Static method.
   */
  public AccessUser getDefault() {
    return new LdapAccessUser();
  }

  /**
   * Return the username associated with this access user; null if this is the default user.  Username should be stored as an instance variable in implementing classes,
   * so ServletContext is not needed.
   */
  public String getUsername() {
    return username;
  }

  /**
   * Return the username field label.
   */
  public String getUsernameLabel() {
    return "Username";
  }

  /**
   * Factory method to return an AccessUser instance given ONLY a username.  Static method.
   * This method should ONLY be used after authentication has been checked.  Throws an AccessUserException if user is not found or cannot be found without a password.
   */
  public AccessUser getAccessUser(ServletContext context, String username) throws AccessUserException {

    try {

      // validate
      if (username==null || username.length()==0) throw new ValidationException("Username was not supplied.");

      // check for Users DN
      String usersDN = context.getInitParameter(USERS_DN);
      if (usersDN==null) throw new MissingParameterException("LDAP "+USERS_DN+" parameter is missing in web.xml.");

      InitialDirContext dctx = Util.getDirContext(context);

      // set attribute for search and return attributes
      Attributes personAttrs = new BasicAttributes(true); // case-insensitive
      personAttrs.put(new BasicAttribute("cn", username)); // match cn to provided username
      String[] attrIDs = {"cn", "givenname", "sn", "mail"}; // return attributes
      
      // search, return user or throw exception
      NamingEnumeration users = dctx.search(usersDN, personAttrs, attrIDs);
      if (users.hasMore()) {
	SearchResult person = (SearchResult)users.next();
	return new LdapAccessUser(person.getAttributes());
      } else {
	throw new UserNotFoundException("User <b>"+username+"</b> not found in LDAP directory.");
      }

    } catch (Exception ex) {

      throw new AccessUserException(ex.toString());

    }

  }

  /**
   * Factory method to return an AccessUser instance given a username and password.  Static method.
   * This method is used to instantiate an AccessUser in the app.
   */
  public AccessUser getAccessUser(ServletContext context, String username, String password) throws AccessUserException {

    try {

      // validate
      String error = "";
      if (username==null) error += "Username was not supplied. ";
      if (password==null) error += "Password was not supplied. ";
      if (error.length()>0) throw new ValidationException(error);

      // check for control panel users DN
      String usersDN = context.getInitParameter(USERS_DN);
      if (usersDN==null) throw new MissingParameterException("LDAP "+USERS_DN+" parameter is missing in web.xml.");

      // initialize the directory context
      InitialDirContext dctx = Util.getDirContext(context);

      // first, query the Users DN for the given cn
      Attributes personAttrs = new BasicAttributes(true); // case-insensitive
      personAttrs.put(new BasicAttribute("cn", username)); // match cn to provided value

      // search
      NamingEnumeration users = dctx.search(usersDN, personAttrs);
      if (users.hasMore()) {
	SearchResult person = (SearchResult)users.next();
	String personDN = person.getNameInNamespace(); // use for authentication
	// authenticate against provided password, populate if successful
	// update security principal and credentials on context for authentication
	dctx.removeFromEnvironment(Context.SECURITY_PRINCIPAL);
	dctx.removeFromEnvironment(Context.SECURITY_CREDENTIALS);
	dctx.addToEnvironment(Context.SECURITY_PRINCIPAL, personDN);
	dctx.addToEnvironment(Context.SECURITY_CREDENTIALS, password);
	// now query and instantiate record using new authentication, throws AuthenticationException if invalid authentication
	String[] attrIDs = {"cn", "givenname", "sn", "mail"};
	users = dctx.search(usersDN, personAttrs, attrIDs);
	if (users.hasMore()) {
	  person = (SearchResult)users.next();
	  return new LdapAccessUser(person.getAttributes());
	} else {
	  throw new UserNotFoundException("Incorrect password supplied for user <b>"+username+"</b>.");
	}
      } else {
	throw new UserNotFoundException("User <b>"+username+"</b> not found in LDAP directory.");
      }

    } catch (Exception ex) {

      throw new AccessUserException(ex.toString());

    }

  }

  /**
   * Return an array of all AccessUsers, sorted by lastname.  Static method.
   */
  public AccessUser[] getAll(ServletContext context) throws AccessUserException {

    try {

      // check for control panel users DN
      String usersDN = context.getInitParameter(USERS_DN);
      if (usersDN==null) throw new MissingParameterException("LDAP "+USERS_DN+" parameter is missing in web.xml.");
      
      InitialDirContext dctx = Util.getDirContext(context);
      
      // search usersDN for all people with surnames
      SearchControls searchCtls = new SearchControls();

      // return attributes
      String[] attrIDs = {"cn", "givenname", "sn", "mail", "createtimestamp"};
      searchCtls.setReturningAttributes(attrIDs);
      
      // search scope
      searchCtls.setSearchScope(SearchControls.SUBTREE_SCOPE);

      // search on non-null surnames
      String searchFilter = "(sn=*)";

      // use a TreeMap to store the users, so that sorting is maintained
      NamingEnumeration usersEnum = dctx.search(usersDN, searchFilter, searchCtls);
      TreeMap<String,LdapAccessUser> userMap = new TreeMap<String,LdapAccessUser>();
      while (usersEnum.hasMore()) {
	SearchResult person = (SearchResult)usersEnum.next();
	LdapAccessUser lau = new LdapAccessUser(person.getAttributes());
	userMap.put(lau.lastname,lau);
      }

      // dump the Map values into an array
      Object[] temp = userMap.values().toArray();
      LdapAccessUser[] users = new LdapAccessUser[temp.length];
      for (int i=0; i<users.length; i++) users[i] = (LdapAccessUser)temp[i];
      
      return users;

    } catch (Exception ex) {
      
      throw new AccessUserException(ex.toString());

    }

  }

  /**
   * Return an array of AccessRoles to which this AccessUser is assigned.
   */
  public AccessRole[] getAccessRoles(ServletContext context) throws AccessUserException {

    try {

      // get all of the access roles
      LdapAccessRole publicRole = new LdapAccessRole();
      AccessRole ar[] = publicRole.getAll(context);

      // load roles that this user is a member of into a TreeMap to maintain sorting
      TreeMap<String,AccessRole> roleMap = new TreeMap<String,AccessRole>();
      for (int i=0; i<ar.length; i++) {
	if (isMember(context, ar[i])) roleMap.put(ar[i].getRolename(), ar[i]);
      }

      // dump the Map values into an array
      Object[] temp = roleMap.values().toArray();
      AccessRole[] roles = new AccessRole[temp.length];
      for (int i=0; i<roles.length; i++) roles[i] = (AccessRole)temp[i];

      return roles;

    } catch (Exception ex) {

      throw new AccessUserException(ex.toString());

    }

  }

  /**
   * Return true if this user is a member of the provided AccessRole.
   */
  public boolean isMember(ServletContext context, AccessRole role) throws AccessUserException {

    try {

      // web.xml validation
      String rolesDN = context.getInitParameter(LdapAccessRole.ROLES_DN);
      String usersDN = context.getInitParameter(USERS_DN);
      String error = "";
      if (rolesDN==null) error += "LDAP "+LdapAccessRole.ROLES_DN+" parameter is missing in web.xml.";
      if (usersDN==null) error += "LDAP "+USERS_DN+" parameter is missing in web.xml.";
      if (error.length()>0) throw new MissingParameterException(error);

      // initialize the directory context
      InitialDirContext dctx = Util.getDirContext(context);

      // set attribute for search and return attributes
      Attributes memberAttrs = new BasicAttributes(true); // case-insensitive
      memberAttrs.put(new BasicAttribute("cn", role.getRolename())); // match group to requested name
      String[] attrIDs = {"member"}; // return attributes, not really used
      
      // match DN of this user
      String userDN = "CN="+username+","+usersDN;
      
      // search, return true if found, false if not
      NamingEnumeration members = dctx.search(rolesDN, memberAttrs, attrIDs);
      while (members.hasMore()) {
	SearchResult member = (SearchResult)members.next();
	Attributes attribs = member.getAttributes();
	Attribute attrib = attribs.get("member");
	if (attrib!=null) {
	  NamingEnumeration values = attrib.getAll();
	  while (values.hasMore()) {
	    String value = (String)values.next();
	    if (value!=null && value.equals(userDN)) return true;
	  }
	}
      }

      return false;

    } catch (Exception ex) {
      
      throw new AccessUserException(ex.toString());
      
    }

  }



}
