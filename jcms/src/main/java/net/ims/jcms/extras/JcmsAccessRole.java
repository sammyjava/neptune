package net.ims.jcms.extras;

import net.ims.jcms.*;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.security.InvalidKeyException;
import java.security.InvalidAlgorithmParameterException;
import java.security.NoSuchAlgorithmException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Vector;
import javax.crypto.NoSuchPaddingException;
import javax.naming.NamingException;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/**
 * This class implements the AccessRole interface for the case of AccessRole information being contained in the jcms accessroles table.
 * It also contains methods for adding, updating and deleting roles.
 *
 * This is the "stock" AccessRole class that is used when there is no site-specific external store containing AccessRole data.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class JcmsAccessRole extends AccessRole {

  /** accessroles.accessrole_id: the primary key for this record */
  public int accessrole_id = 0;

  /** accessroles.accessrole: the name of the role */
  public String accessrole = null;

  /** accessroles.created: the creation timestamp */
  public Timestamp created = null;

  /** accessroles.updated: the update timestamp */
  public Timestamp updated = null;

  /**
   * Construct a default object
   */
  public JcmsAccessRole() {
  }

  /**
   * Construct given a populated ResultSet.
   */
  JcmsAccessRole(ResultSet rs) throws SQLException {
    populate(rs);
  }

  /**
   * Construct given DB connection and an int primary key
   */
  JcmsAccessRole(DB db, int key) throws SQLException, AccessRoleException {
    select(db, key);
  }

  /**
   * Construct given a Servlet context and primary key
   */
  public JcmsAccessRole(ServletContext context, int key) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException, AccessRoleException {
    DB db = null;
    try {
      db = new DB(context);
      select(db, key);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Populate this instance given a populated ResultSet.
   */
  void populate(ResultSet rs) throws SQLException {
    accessrole_id = rs.getInt("accessrole_id");
    accessrole = rs.getString("accessrole");
    created = rs.getTimestamp("created");
    updated = rs.getTimestamp("updated");
  }

  /**
   * Do a SELECT query and set instance variables given a DB connection and a primary key
   */
  void select(DB db, int key) throws SQLException, AccessRoleException {
    db.executeQuery("SELECT * FROM accessroles WHERE accessrole_id="+key);
    if (db.rs.next()) {
      populate(db.rs);
    } else {
      throw new AccessRoleException("Role "+key+" not found.");
    }
  }

  /**
   * Insert a new record into the database and retrieve/set the resulting accessrole_id.
   */
  void insert(DB db) throws SQLException {
    String query = "INSERT INTO accessroles (" +
      "accessrole" +
      ") VALUES (" +
      charsOrNull(accessrole) +
      ")";
    db.executeUpdate(query);
    db.executeQuery("SELECT max(accessrole_id) AS accessrole_id FROM accessroles");
    db.rs.next();
    accessrole_id = db.rs.getInt("accessrole_id");
    db.executeQuery("SELECT * FROM accessroles WHERE accessrole_id="+accessrole_id);
    db.rs.next();
    populate(db.rs);
  }

  /**
   * Update the record.
   */
  void update(DB db) throws SQLException {
    db.executeUpdate("UPDATE accessroles SET updated="+db.now()+", accessrole="+charsOrNull(accessrole)+" WHERE accessrole_id="+accessrole_id);
    db.executeQuery("SELECT * FROM accessroles WHERE accessrole_id="+accessrole_id);
    db.rs.next();
    populate(db.rs);
  }

  /**
   * Delete the current record, and reset to defaults.  Must delete child records first.
   */
  void delete(DB db) throws SQLException, ValidationException {
    db.executeUpdate("DELETE FROM accessroles_nodes WHERE rolename="+charsOrNull(accessrole));
    db.executeUpdate("DELETE FROM accessroles_accessusers WHERE accessrole_id="+accessrole_id);
    db.executeUpdate("DELETE FROM accessroles WHERE accessrole_id="+accessrole_id);
    accessrole_id = 0;
    accessrole = "Public";
    created = null;
    updated = null;
  }

  /**
   * Audit a database action performed by the user associated with an HTTP session
   */
  void audit(HttpSession session, String tablename, char action, String description) throws UserNotFoundException, SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    ControlPanelUser user = new ControlPanelUser(session);
    DB db = null;
    try {
      ServletContext context = session.getServletContext();
      db = new DB(context);
      Audit a = new Audit();
      a.tablename = tablename;
      a.record_id = accessrole_id;
      a.action = action;
      a.username = user.username;
      a.description = description;
      a.insert(db);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return all records, alpha sorted by accessrole.
   */
  static JcmsAccessRole[] getAllJcmsAccessRoles(DB db) throws SQLException {
    db.executeQuery("SELECT count(*) AS count FROM accessroles");
    db.rs.next();
    int count = db.rs.getInt("count");
    JcmsAccessRole[] roles = new JcmsAccessRole[count];
    int i = 0;
    db.executeQuery("SELECT * FROM accessroles ORDER BY accessrole");
    while (db.rs.next()) roles[i++] = new JcmsAccessRole(db.rs);
    return roles;
  }

  /**
   * Return all records, alpha sorted by accessrole.
   */
  public static JcmsAccessRole[] getAllJcmsAccessRoles(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException, UserNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return getAllJcmsAccessRoles(db);
    } finally {
      if (db!=null) db.close();
    }
  }


  /////////////////////////////////
  // AccessRole abstract classes //
  /////////////////////////////////

  /**
   * Comparator for sorting; alpha sort by AccessRole name.
   */
  public int compareTo(Object o) {
    JcmsAccessRole that = (JcmsAccessRole)o;
    return this.accessrole.compareTo(that.accessrole);
  }

  /**
   * Return true if this role equals the provided one.
   */
  public boolean equals(AccessRole that) {
    return this.accessrole.equals(that.getRolename());
  }

  /**
   * Return true if this is the default (public) role.
   */
  public boolean isDefault() {
    return (accessrole_id==0);
  }

  /**
   * Return the access role name.
   */
  public String getRolename() {
    return accessrole;
  }

  /**
   * Description is not currently supported by the accessroles table.
   */
  public String getDescription() {
    return null;
  }

  /**
   * Factory method for default (public) role.
   */
  public AccessRole getDefault() {
    return new JcmsAccessRole();
  }

  /**
   * Factory method to return an access role given a role name.
   */
  public AccessRole getAccessRole(ServletContext context, String rolename) throws AccessRoleException {
    DB db = null;
    try {
      db = new DB(context);
      db.executeQuery("SELECT * FROM accessroles WHERE accessrole="+charsOrNull(rolename));
      if (db.rs.next()) {
	return new JcmsAccessRole(db.rs);
      } else {
	throw new AccessRoleException("Access Role "+rolename+" does not exist.");
      }
    } catch (Exception ex) {
      throw new AccessRoleException(ex.toString());
    } finally {
      try {
	if (db!=null) db.close();
      } catch (SQLException ex) {
	throw new AccessRoleException(ex.toString());
      }
    }
  }

  /**
   * Return all records, alpha sorted by accessrole.
   */
  public AccessRole[] getAll(ServletContext context) throws AccessRoleException {
    try {
      return getAllJcmsAccessRoles(context);
    } catch (Exception ex) {
      throw new AccessRoleException(ex.toString());
    }
  }

  ///////////////////////////////
  // methods from Record class //
  ///////////////////////////////

  /**
   * Update a database record with current instance values, preceded by license check, followed by auditing.
   */
  public void update(HttpServletRequest request) throws SQLException, ValidationException, NamingException, FileNotFoundException, ClassNotFoundException, IOException, 
							NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, InvalidAlgorithmParameterException, 
							LicenseInvalidException, UserNotFoundException {
    License.check(request, 0);
    DB db = null;
    try {
      db = new DB(request.getSession().getServletContext());
      update(db);
    } finally {
      if (db!=null) db.close();
    }
    audit(request.getSession(), "accessroles", 'U', "Access role "+accessrole+" record updated.");
  }

  /**
   * Delete a database record with current instance values, preceded by license check and auditing.
   */
  public void delete(HttpServletRequest request) throws SQLException, ValidationException, NamingException, FileNotFoundException, ClassNotFoundException, IOException, 
							NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, InvalidAlgorithmParameterException, 
							LicenseInvalidException, UserNotFoundException {
    License.check(request, 0);
    audit(request.getSession(), "accessroles", 'D', "Access role "+accessrole+" record deleted.");
    DB db = null;
    try {
      db = new DB(request.getSession().getServletContext());
      delete(db);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Insert a database record with current instance values, preceded by license check, followed by auditing.
   */
  public void insert(HttpServletRequest request) throws SQLException, ValidationException, NamingException, FileNotFoundException, ClassNotFoundException, IOException, 
							NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, InvalidAlgorithmParameterException, 
							LicenseInvalidException, UserNotFoundException {
    License.check(request, 0);
    DB db = null;
    try {
      db = new DB(request.getSession().getServletContext());
      insert(db);
    } finally {
      if (db!=null) db.close();
    }
    audit(request.getSession(), "accessroles", 'I', "Access role "+accessrole+" record inserted.");
  }

}
