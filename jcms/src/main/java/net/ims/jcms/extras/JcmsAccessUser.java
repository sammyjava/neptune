package net.ims.jcms.extras;

import net.ims.jcms.*;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.security.InvalidKeyException;
import java.security.InvalidAlgorithmParameterException;
import java.security.NoSuchAlgorithmException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Enumeration;
import java.util.Random;
import java.util.TimeZone;
import java.util.ArrayList;
import javax.crypto.NoSuchPaddingException;
import javax.naming.NamingException;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/**
 * Extends AccessUser to provide methods required for authentication, etc. against the standard jcms database.
 *
 * This is the "stock" AccessUser class that is used when AccessUsers are stored in the jcms schema database.
 * Email is used as the username.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class JcmsAccessUser extends AccessUser {

  /** accessusers.accessuser_id: the primary key for this record */
  public int accessuser_id = 0;

  /** accessusers.email: the user's email address */
  public String email = null;

  /** accessusers.password: the user's encrypted password */
  public String password = null;

  /** accessusers.created: string version of creation timestamp */
  public Timestamp created = null;

  /** accessusers.updated: string version of update timestamp */
  public Timestamp updated = null;

  /** accessusers.resetkey: authentication string for password reset */
  public String resetkey = null;

  /**
   * Construct an empty AccessUser with default values.
   */
  public JcmsAccessUser() {
  }

  /**
   * Construct given ServletContext and accessuser_id value.
   */
  public JcmsAccessUser(ServletContext context, int key) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException, UserNotFoundException, AccessUserException {
    DB db = null;
    try {
      db = new DB(context);
      select(db, key);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Construct given ServletContext and email.  Use wisely!
   */
  public JcmsAccessUser(ServletContext context, String email) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException, UserNotFoundException, AccessUserException, ValidationException {
    DB db = null;
    try {
      db = new DB(context);
      select(db, email);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Construct using a populated ResultSet.
   */
  JcmsAccessUser(ResultSet rs) throws SQLException {
    populate(rs);
  }

  /**
   * Construct given DB connection and an accessuser_id value.
   */
  JcmsAccessUser(DB db, int key) throws SQLException, AccessUserException {
    select(db, key);
  }

  /**
   * Populate this instance from a populated ResultSet.
   */
  void populate(ResultSet rs) throws SQLException {
    accessuser_id = rs.getInt("accessuser_id");
    email = rs.getString("email");
    password = rs.getString("password");
    created = rs.getTimestamp("created");
    updated = rs.getTimestamp("updated");
    resetkey = rs.getString("resetkey");
  }

  /**
   * Does a SELECT query and set instance variables given a DB connection and a primary key.
   */
  void select(DB db, int key) throws SQLException, AccessUserException {
    db.executeQuery("SELECT * FROM accessusers WHERE accessuser_id="+key);
    if (db.rs.next()) {
      populate(db.rs);
    } else {
      throw new AccessUserException("User "+key+" not found.");
    }
  }

  /**
   * Does a SELECT query and set instance variables given a DB connection and an email/password combination.
   */
  void select(DB db, String accessuser_email, String accessuser_password) throws SQLException, AccessUserException, ValidationException {
    if (accessuser_email==null) throw new ValidationException("Username (email) missing.");
    if (accessuser_password==null) throw new ValidationException("Password missing.");
    db.executeQuery("SELECT * FROM accessusers WHERE email='"+accessuser_email.trim().toLowerCase()+"' AND password='"+accessuser_password.trim()+"'");
    if (db.rs.next()) {
      populate(db.rs);
    } else {
      throw new AccessUserException("User "+accessuser_email+" not found, or supplied password is invalid.");
    }
  }

  /**
   * Does a SELECT query and set instance variables given a DB connection and ONLY an email.  Use wisely!
   */
  void select(DB db, String accessuser_email) throws SQLException, AccessUserException, ValidationException {
    if (accessuser_email==null) throw new ValidationException("Username (email) missing.");
    db.executeQuery("SELECT * FROM accessusers WHERE email='"+accessuser_email.trim().toLowerCase()+"'");
    if (db.rs.next()) {
      populate(db.rs);
    } else {
      throw new AccessUserException("User "+accessuser_email+" not found.");
    }
  }

  /**
   * Inserts a new database record with current instance values.
   * Password encryption is done before this call with setPassword(); email is checked to be valid using Authentication.isValidEmail.
   * A dhtmlcache record is created and populated after insertion.
   */
  void insert(DB db) throws SQLException, ValidationException {
    boolean requiredMissing = (email==null || email.trim().length()==0 || password==null || password.trim().length()==0);
    if (requiredMissing) {
      throw new ValidationException("Both email and password are required.");
    } else if (!Authentication.isValidEmail(email)) {
      throw new ValidationException("The supplied e-mail address is invalid.");
    } else {
      email = email.trim().toLowerCase();
      String query = "INSERT INTO accessusers (" +
	"email,password" +
	") VALUES (" +
	charsOrNull(email)+"," +
	charsOrNull(password) +
	")";
      db.executeUpdate(query);
      // get the accessuser_id and creation timestamp
      db.executeQuery("SELECT * FROM accessusers WHERE email="+charsOrNull(email));
      if (db.rs.next()) populate(db.rs);
    }
  }

  /**
   * Updates the record with the current instance values.
   * Password encryption is done before this call with setPassword(); email is checked to be valid using Authentication.isValidEmail.
   */
  void update(DB db) throws SQLException, ValidationException {
    if (!isDefault()) {
      boolean requiredMissing = (email==null || email.trim()=="" || password==null || password.trim()=="");
      if (requiredMissing) {
	throw new ValidationException("Email and password are required.");
      } else if (!Authentication.isValidEmail(email)) {
	throw new ValidationException("The supplied e-mail address is invalid.");
      } else {
	email = email.trim().toLowerCase();
	String query = "UPDATE accessusers SET updated="+db.now()+", email="+charsOrNull(email)+", "+"password="+charsOrNull(password)+" WHERE accessuser_id="+accessuser_id;
	db.executeUpdate(query);
      }
    }
  }

  /**
   * Deletes an accessusers record.  Deletes child relations first.
   */
  void delete(DB db) throws SQLException, ValidationException {
    db.executeUpdate("DELETE FROM accessroles_accessusers WHERE accessuser_id="+accessuser_id);
    db.executeUpdate("DELETE FROM accessusers WHERE accessuser_id="+accessuser_id);
    accessuser_id = 0;
    email = null;
    password = null;
    created = null;
    updated = null;
    resetkey = null;
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
      a.record_id = accessuser_id;
      a.action = action;
      a.username = user.username;
      a.description = description;
      a.insert(db);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Sets the instance variable to the provided email IF it passes email validation.
   */
  public void setEmail(String inmail) throws ValidationException {
    if (inmail==null || inmail.trim().length()==0) {
      throw new ValidationException("The supplied e-mail address is empty.");
    } else if (Authentication.isValidEmail(inmail)) {
      email = inmail.trim().toLowerCase();
    } else {
      throw new ValidationException("The supplied e-mail address is invalid.");
    }
  }

  /**
   * Encrypts the provided password and sets the instance variable. Authentication.encrypt() handles validating the password.
   */
  public void setPassword(String plainpass) throws ValidationException, NoSuchAlgorithmException, UnsupportedEncodingException {
    password = Authentication.encrypt(plainpass);
  }

  /**
   * Associate this user with a role.
   */
  void addRole(DB db, JcmsAccessRole ar) throws SQLException {
    db.executeUpdate("INSERT INTO accessroles_accessusers VALUES ("+ar.accessrole_id+","+accessuser_id+")");
  }

  /**
   * Associate this user with a role.
   */
  public void addRole(HttpSession session, JcmsAccessRole ar) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException, UserNotFoundException {
    DB db = null;
    try {
      ServletContext context = session.getServletContext();
      db = new DB(context);
      addRole(db, ar);
      audit(session, "accessusers_accessroles", 'U', "Access User "+email+" added to role "+ar.accessrole+".");
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Remove this user from the given access role.
   */
  void removeRole(DB db, JcmsAccessRole ar) throws SQLException {
    db.executeUpdate("DELETE FROM accessroles_accessusers WHERE accessrole_id="+ar.accessrole_id+" AND accessuser_id="+accessuser_id);
  }

  /**
   * Remove this user from the given access role.
   */
  public void removeRole(HttpSession session, JcmsAccessRole ar) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException, UserNotFoundException {
    DB db = null;
    try {
      ServletContext context = session.getServletContext();
      db = new DB(context);
      removeRole(db, ar);
      audit(session, "accessusers_accessroles", 'U', "Access User "+email+" removed from role "+ar.accessrole+".");
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return an array of all users, sorted by increasing email.
   */
  static JcmsAccessUser[] getAllJcmsAccessUsers(DB db) throws SQLException {
    db.executeQuery("SELECT count(*) AS count FROM accessusers");
    db.rs.next();
    int count = db.rs.getInt("count");
    JcmsAccessUser[] users = new JcmsAccessUser[count];
    int i = 0;
    db.executeQuery("SELECT * FROM accessusers ORDER BY email");
    while (db.rs.next()) users[i++] = new JcmsAccessUser(db.rs);
    return users;
  }

  /**
   * Return an array of all users, sorted by increasing email.
   */
  public static JcmsAccessUser[] getAllJcmsAccessUsers(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException, UserNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return getAllJcmsAccessUsers(db);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Create a password reset key; also clears the password, so that record may not be used to authenticate until reset process is complete.
   */
  void createResetKey(DB db) throws SQLException {
    resetkey = "";
    // generate key
    Random r = new Random();
    while (resetkey.length()<16) {
      char c = (char)(48+r.nextInt(43));
      if (Character.isLetterOrDigit(c)) resetkey += c;
    }
    db.executeUpdate("UPDATE accessusers SET updated="+db.now()+", resetkey="+charsOrNull(resetkey)+" WHERE accessuser_id="+accessuser_id);
  }

  /**
   * Create a password reset key; also clears the password, so that record may not be used to authenticate until reset process is complete.
   */
  public void createResetKey(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException, UserNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      createResetKey(db);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Reset the password, clearing the reset key.  Password must satisfy validity requirements.
   */
  void resetPassword(DB db, String plainpass) throws SQLException, ValidationException, NoSuchAlgorithmException, UnsupportedEncodingException {
    setPassword(plainpass);
    db.executeUpdate("UPDATE accessusers SET updated="+db.now()+", resetkey=NULL, password="+charsOrNull(password)+" WHERE accessuser_id="+accessuser_id);
  }

  /**
   * Reset the password, clearing the reset key.  Password must satisfy validity requirements.
   */
  public void resetPassword(ServletContext context, String plainpass) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException, UserNotFoundException, ValidationException, NoSuchAlgorithmException, UnsupportedEncodingException {
    DB db = null;
    try {
      db = new DB(context);
      resetPassword(db, plainpass);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return a JcmsAccessUser instance corresponding to the given password reset key; otherwise, throw UserNotFoundException.
   */
  static JcmsAccessUser getByResetKey(DB db, String key) throws SQLException, UserNotFoundException {
    db.executeQuery("SELECT * FROM accessusers WHERE resetkey="+charsOrNull(key));
    if (db.rs.next()) {
      return new JcmsAccessUser(db.rs);
    } else {
      throw new UserNotFoundException("No user found for the provided password reset key.");
    }
  }

  /**
   * Return a JcmsAccessUser instance corresponding to the given password reset key; otherwise, throw UserNotFoundException.
   */
  public static JcmsAccessUser getByResetKey(ServletContext context, String key) throws SQLException, UserNotFoundException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return getByResetKey(db, key);
    } finally {
      if (db!=null) db.close();
    }
  }

  /////////////////////////////////
  // AccessUser abstract classes //
  /////////////////////////////////

  /**
   * Required by Comparable interface; alpha sort by email.
   */
  public int compareTo(Object o) {
    JcmsAccessUser that = (JcmsAccessUser)o;
    return this.email.compareTo(that.email);
  }

  /**
   * Return true if this user matches the provided AccessUser.
   */
  public boolean equals(AccessUser that) {
    if (that==null) {
      return false;
    } else {
      return this.email.equals(that.getUsername());
    }
  }

  /**
   * Factory method to return a default AccessUser instance.  Static method.
   */
  public AccessUser getDefault() {
    return (AccessUser)(new JcmsAccessUser());
  }

  /**
   * Return true if this user is (default) public user.
   */
  public boolean isDefault() {
    return (accessuser_id==0);
  }

  /**
   * Factory method: return a populated instance given a ServletContext, email and plain text password.
   */
  public AccessUser getAccessUser(ServletContext context, String inputEmail, String inputPassword) throws AccessUserException {
    String error = "";
    // check that resetkey is null
    if (resetkey!=null) {
      error += "You may not log in until you reset your password.  Check your email for the password reset URL. ";
    }
    // check for valid email and password
    if (inputEmail==null || inputEmail.trim().length()==0) {
      error += "E-mail address must be supplied. ";
    } else if (!Authentication.isValidEmail(inputEmail)) {
      error += "You have supplied an invalid e-mail address. ";
    }
    if (inputPassword==null || inputPassword.trim().length()==0) {
      error += "Password must be supplied. ";
    } else if (!Authentication.isValidPassword(inputPassword)) {
      error += "You have supplied an invalid password. ";
    }
    if (error.length()>0) throw new AccessUserException(error);
    // get the user
    JcmsAccessUser jau = new JcmsAccessUser();
    DB db = null;
    try {
      db = new DB(context);
      jau.select(db, inputEmail, Authentication.encrypt(inputPassword));
    } catch (Exception ex) {
      throw new AccessUserException(ex.toString());
    } finally {
      try {
	if (db!=null) db.close();
      } catch (SQLException ex) {
	throw new AccessUserException(ex.toString());
      }
    }
    if (jau.isDefault()) {
      throw new AccessUserException("User "+inputEmail+" does not exist, or the supplied password is incorrect.");
    } else {
      return (AccessUser)jau;
    }
  }

  /**
   * Factory method: return a populated instance given a ServletContext, and email only.
   */
  public AccessUser getAccessUser(ServletContext context, String inputEmail) throws AccessUserException {
    String error = "";
    // check that resetkey is null
    if (resetkey!=null) {
      error += "You must reset your password.  Check your email for the password reset URL. ";
    }
    // check for valid email
    if (inputEmail==null || inputEmail.trim().length()==0) {
      error += "E-mail address must be supplied. ";
    } else if (!Authentication.isValidEmail(inputEmail)) {
      error += "You have supplied an invalid e-mail address. ";
    }
    if (error.length()>0) throw new AccessUserException(error);
    // get the user
    DB db = null;
    try {
      db = new DB(context);
      JcmsAccessUser jau = new JcmsAccessUser();
      jau.select(db, inputEmail);
      if (jau.isDefault()) {
	throw new AccessUserException("JcmsAccessUser "+inputEmail+" not found.");
      } else {
	return (AccessUser)jau;
      }
    } catch (Exception ex) {
      throw new AccessUserException(ex.toString());
    } finally {
      try {
	if (db!=null) db.close();
      } catch (SQLException ex) {
	throw new AccessUserException(ex.toString());
      }
    }
  }

  /**
   * Return username.
   */
  public String getUsername() {
    return email;
  }

  /**
   * Return username label.
   */
  public String getUsernameLabel() {
    return "Email";
  }
  
  /**
   * Return an array of all users, sorted by increasing email.
   */
  public AccessUser[] getAll(ServletContext context) throws AccessUserException {
    try {
      return getAllJcmsAccessUsers(context);
    } catch (Exception ex) {
      throw new AccessUserException(ex.toString());
    }
  }

  /**
   * Return an array of AccessRoles to which this user is assigned, alpha sorted by accessrole.
   */
  public AccessRole[] getAccessRoles(ServletContext context) throws AccessUserException {
    DB db = null;
    try {
      db = new DB(context);
      ArrayList<AccessRole> list = new ArrayList<AccessRole>();
      db.executeQuery("SELECT * FROM accessroles WHERE accessrole_id IN (SELECT accessrole_id FROM accessroles_accessusers WHERE accessuser_id="+accessuser_id+") ORDER BY accessrole");
      while (db.rs.next()) list.add(new JcmsAccessRole(db.rs));
      return list.toArray(new AccessRole[0]);
    } catch (Exception ex) {
      throw new AccessUserException(ex.toString());
    } finally {
      try {
	if (db!=null) db.close();
      } catch (SQLException ex) {
	throw new AccessUserException(ex.toString());
      }
    }
  }

  /**
   * Return true if this user is a member of the given AccessRole.
   */
  public boolean isMember(ServletContext context, AccessRole role) throws AccessUserException {
    DB db = null;
    try {
      db = new DB(context);
      db.executeQuery("SELECT * FROM accessroles WHERE accessrole="+charsOrNull(role.getRolename()));
      if (db.rs.next()) {
	int accessrole_id = db.rs.getInt("accessrole_id");
	db.executeQuery("SELECT count(*) AS count FROM accessroles_accessusers WHERE accessrole_id="+accessrole_id+" AND accessuser_id="+accessuser_id);
	db.rs.next();
	return (db.rs.getInt("count")>0);
      } else {
	return false;
      }
    } catch (Exception ex) {
      throw new AccessUserException(ex.toString());
    } finally {
      try {
	if (db!=null) db.close();
      } catch (SQLException ex) {
	throw new AccessUserException(ex.toString());
      }
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
    audit(request.getSession(), "accessusers", 'U', "Access user "+email+" record updated.");
  }

  /**
   * Delete a database record with current instance values, preceded by license check and auditing.
   */
  public void delete(HttpServletRequest request) throws SQLException, ValidationException, NamingException, FileNotFoundException, ClassNotFoundException, IOException, 
							NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, InvalidAlgorithmParameterException, 
							LicenseInvalidException, UserNotFoundException {
    License.check(request, 0);
    audit(request.getSession(), "accessusers", 'D', "Access user "+email+" record deleted.");
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
    insert(request.getSession().getServletContext());
    audit(request.getSession(), "accessusers", 'I', "Access user "+email+" record inserted.");
  }

  /**
   * Insert a database record with current instance values, without license check or auditing.
   */
  public void insert(ServletContext context) throws SQLException, ValidationException, NamingException, FileNotFoundException, ClassNotFoundException, IOException {
    DB db = null;
    try {
      db = new DB(context);
      insert(db);
    } finally {
      if (db!=null) db.close();
    }
  }


}
