package net.ims.jcms.extras;

import net.ims.jcms.*;

import java.util.Hashtable;
import java.util.Vector;
import java.util.TreeMap;
import javax.naming.Context;
import javax.naming.NamingEnumeration;
import javax.naming.NamingException;
import javax.naming.directory.Attributes;
import javax.naming.directory.BasicAttribute;
import javax.naming.directory.BasicAttributes;
import javax.naming.directory.InitialDirContext;
import javax.naming.directory.SearchResult;
import javax.naming.directory.SearchControls;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpSession;

/**
 * Implementation of AccssRole for roles associated with groups drawn from an LDAP store.
 *
 * LDAP parameters are provided in web.xml; since this class is used on both the 
 * site root and control panel, you must duplicate the LDAP parameters in both web.xml files.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class LdapAccessRole extends AccessRole {

  // access role-specific web.xml context parameters
  public static String ROLES_DN = "ldap.rolesdn"; // DN of roles from which roles are selected

  /** the name of the LDAP group, role (cn) */
  public String rolename = null;

  /** the group description */
  public String description = null;

  /**
   * Default constructer, needed to get access to methods, since none are static
   */
  public LdapAccessRole() {
  }

  /**
   * Construct given a populated set of LDAP attributes
   */
  LdapAccessRole(Attributes attribs) throws NamingException {
    populate(attribs);
  }


  /**
   * Populate the instance variables from the attributes of a SearchResult.
   */
  void populate(Attributes attribs) throws NamingException {
    rolename = (String)attribs.get("cn").get();
    if (attribs.get("description")!=null) description = (String)attribs.get("description").get();
  }

  /**
   * Comparator required by Comparable interface.
   */
  public int compareTo(Object o) {
    LdapAccessRole that = (LdapAccessRole)o;
    return this.rolename.compareTo(that.rolename);
  }

  /**
   * Return true if this role equals the provided one.
   */
  public boolean equals(AccessRole role) {
    if (rolename==null || role==null) {
      return false;
    } else {
      return this.rolename.equals(role.getRolename());
    }
  }

  /**
   * Return true if this role is (default) public role.
   */
  public boolean isDefault() {
    return rolename==null;
  }

  /**
   * Factory method to return a default AccessRole instance.  Static method.
   */
  public AccessRole getDefault() {
    return new LdapAccessRole();
  }

  /**
   * Return an array of all AccessRole instances.  Static method.
   */
  public AccessRole[] getAll(ServletContext context) throws AccessRoleException {

    try {

      // web.xml validation
      String error = "";
      String rolesDN = context.getInitParameter(ROLES_DN);
      if (rolesDN==null) error += "LDAP "+ROLES_DN+" parameter is missing in web.xml. ";
      if (error.length()>0) throw new MissingParameterException(error);
      
      // initialize the directory context
      InitialDirContext dctx = Util.getDirContext(context);
      
      // search rolesDN for all people with surnames
      SearchControls searchCtls = new SearchControls();

      // return attributes
      String[] attrIDs = {"cn", "description"};
      searchCtls.setReturningAttributes(attrIDs);
      
      // search scope
      searchCtls.setSearchScope(SearchControls.SUBTREE_SCOPE);

      // search on groups with members
      String searchFilter = "(member=*)";

      // use a TreeMap to store the roles, so that sorting is maintained
      TreeMap<String,LdapAccessRole> rolesMap = new TreeMap<String,LdapAccessRole>();

      // populate map
      NamingEnumeration roles = dctx.search(rolesDN, searchFilter, searchCtls);
      if (roles==null) throw new AccessRoleException("NamingEnumeration roles is null.  Aborting.");
      while (roles.hasMore()) {
	SearchResult record = (SearchResult)roles.next();
	Attributes attribs = record.getAttributes();
	if (attribs==null) throw new AccessRoleException("Attributes are null for SearchResult.");
	LdapAccessRole lar = new LdapAccessRole(attribs);
	rolesMap.put(lar.rolename,lar);
      }

      // dump the Map values into an array, now sorted
      Object[] temp = rolesMap.values().toArray();
      LdapAccessRole[] lars = new LdapAccessRole[temp.length];
      for (int i=0; i<lars.length; i++) lars[i] = (LdapAccessRole)temp[i];
      
      return lars;
      
    } catch (Exception ex) {
      
      throw new AccessRoleException(ex.toString());
      
    }
    
  }

  /**
   * Factory method to return an AccessRole instance given a role name.  Static method.
   */
  public AccessRole getAccessRole(ServletContext context, String rolename) throws AccessRoleException {

    try {

      // validate
      if (rolename==null || rolename.length()==0) throw new ValidationException("Rolename was not supplied.");

      // check for Roles DN
      String rolesDN = context.getInitParameter(ROLES_DN);
      if (rolesDN==null) throw new MissingParameterException("LDAP "+ROLES_DN+" parameter is missing in web.xml.  Please see LDAP usage doc for required context parameters.");

      // initialize the directory context
      InitialDirContext dctx = Util.getDirContext(context);

      // set attribute for search and return attributes
      Attributes roleAttrs = new BasicAttributes(true); // case-insensitive
      roleAttrs.put(new BasicAttribute("cn", rolename)); // match cn to provided rolename
      String[] attrIDs = {"cn", "description"}; // return attributes
      
      // search, return role or throw exception
      NamingEnumeration roles = dctx.search(rolesDN, roleAttrs, attrIDs);
      if (roles.hasMore()) {
	SearchResult role = (SearchResult)roles.next();
	return new LdapAccessRole(role.getAttributes());
      } else {
	throw new AccessRoleException("Role <b>"+rolename+"</b> not found in LDAP directory.");
      }

    } catch (Exception ex) {

      throw new AccessRoleException(ex.toString());

    }

  }

  /**
   * Return the role name.
   */
  public String getRolename() {
    return rolename;
  }

  /**
   * Return the description.
   */
  public String getDescription() {
    return description;
  }

}

