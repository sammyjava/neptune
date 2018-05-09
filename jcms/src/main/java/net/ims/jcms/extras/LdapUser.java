package net.ims.jcms.extras;

import net.ims.jcms.*;

import java.sql.Timestamp;
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
 * User implementation which contains the data for a single user record drawn from an LDAP Users directory.
 * Variable names mirror those in the JcmsUser class.
 *
 * Note: LDAP Users must be created, edited, deleted by the LDAP administrator, outside of this app.
 * We access the LDAP store on a read-only basis here.
 *
 * Essential LDAP DNs are pulled from init parameters in web.xml: ldap.*.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class LdapUser implements User {

  /** the users's LDAP username (cn) */
  public String username = null;

  /** the user's last name (sn) */
  public String lastname = null;

  /** the user's first name (givenname) */
  public String firstname = null;

  /** the user's email address (mail) */
  public String email = null;

  // user-specific web.xml context parameters
  private static String USERS_DN = "ldap.cpusersdn"; // DN of control panel users

  /**
   * Construct a default instance; needed to be able to access User methods, since none are static.
   */
  public LdapUser() {
  }

  /**
   * Construct given a populated set of LDAP attributes
   */
  LdapUser(Attributes attribs) throws NamingException {
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
   * Compare this to another LdapUser passed as an object; order alphabetically by username.
   */
  public int compareTo(Object o) {
    LdapUser that = (LdapUser)o;
    return this.lastname.compareTo(that.lastname);
  }

  /**
   * Return true if this LdapUser matches the User provided.
   */
  public boolean equals(User u) {
    if (username==null || u==null) {
      return false;
    } else {
      return username.equals(u.getUsername());
    }
  }

  /**
   * Return a User instance; actually a static method.
   */
  public User getUser(ServletContext context, String username) throws UserException {

    try {

      // validate
      if (username==null || username.length()==0) throw new ValidationException("Username was not supplied.");

      // check for Users DN
      String usersDN = context.getInitParameter(USERS_DN);
      if (usersDN==null) throw new MissingParameterException("LDAP "+USERS_DN+" parameter is missing in web.xml.  Please see LDAP usage doc for required context parameters.");

      InitialDirContext dctx = Util.getDirContext(context);

      // set attribute for search and return attributes
      Attributes personAttrs = new BasicAttributes(true); // case-insensitive
      personAttrs.put(new BasicAttribute("cn", username)); // match cn to provided username
      String[] attrIDs = {"cn", "givenname", "sn", "mail"}; // return attributes
      
      // search, return user or throw exception
      NamingEnumeration users = dctx.search(usersDN, personAttrs, attrIDs);
      if (users.hasMore()) {
	SearchResult person = (SearchResult)users.next();
	return new LdapUser(person.getAttributes());
      } else {
	throw new UserNotFoundException("User <b>"+username+"</b> not found in LDAP directory.");
      }

    } catch (Exception ex) {

      throw new UserException(ex.toString());

    }

  }

  /**
   * Return an authenticated User instance; actually a static method.
   */
  public User getUser(ServletContext context, String username, String password) throws UserException {

    try {

      // validate
      String error = "";
      if (username==null) error += "Username was not supplied. ";
      if (password==null) error += "Password was not supplied. ";
      if (error.length()>0) throw new ValidationException(error);

      // check for control panel users DN
      String usersDN = context.getInitParameter(USERS_DN);
      if (usersDN==null) throw new MissingParameterException("LDAP "+USERS_DN+" parameter is missing in web.xml.  Please see LDAP usage doc for required context parameters.");

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
	  return new LdapUser(person.getAttributes());
	} else {
	  throw new UserNotFoundException("Incorrect password supplied for user <b>"+username+"</b>.");
	}
      } else {
	throw new UserNotFoundException("User <b>"+username+"</b> not found in LDAP directory.");
      }

    } catch (Exception ex) {

      throw new UserException(ex.toString());

    }

  }

  /**
   * Returns an array of all users, sorted by last name; actually a static method.
   */
  public User[] getAllUsers(ServletContext context) throws UserException {

    try {

      // check for control panel users DN
      String usersDN = context.getInitParameter(USERS_DN);
      if (usersDN==null) throw new MissingParameterException("LDAP "+USERS_DN+" parameter is missing in web.xml.  Please see LDAP usage doc for required context parameters.");
      
      InitialDirContext dctx = Util.getDirContext(context);
      
      // use a TreeMap to store the users, so that sorting is maintained
      TreeMap<String,LdapUser> luserMap = new TreeMap<String,LdapUser>();

      // search usersDN for all people with surnames
      SearchControls searchCtls = new SearchControls();

      // return attributes
      String[] attrIDs = {"cn", "givenname", "sn", "mail", "createtimestamp"};
      searchCtls.setReturningAttributes(attrIDs);
      
      // search scope
      searchCtls.setSearchScope(SearchControls.SUBTREE_SCOPE);

      // search on non-null surnames
      String searchFilter = "(sn=*)";

      NamingEnumeration users = dctx.search(usersDN, searchFilter, searchCtls);
      while (users.hasMore()) {
	SearchResult person = (SearchResult)users.next();
	LdapUser lu = new LdapUser(person.getAttributes());
	luserMap.put(lu.lastname,lu);
      }

      // dump the Map values into an array
      Object[] temp = luserMap.values().toArray();
      LdapUser[] lusers = new LdapUser[temp.length];
      for (int i=0; i<lusers.length; i++) lusers[i] = (LdapUser)temp[i];
      
      return lusers;

    } catch (Exception ex) {
      
      throw new UserException(ex.toString());

    }

  }

  /**
   * Return the username.
   */
  public String getUsername() {
    return username;
  }

  /**
   * Return the last name.
   */
  public String getLastname() {
    return lastname;
  }

  /**
   * Return the first name.
   */
  public String getFirstname() {
    return firstname;
  }

  /**
   * Return the email address (may be null).
   */
  public String getEmail() {
    return email;
  }

}
