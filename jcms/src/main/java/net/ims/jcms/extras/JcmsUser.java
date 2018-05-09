package net.ims.jcms.extras;

import net.ims.jcms.*;

import java.io.FileNotFoundException;
import java.io.UnsupportedEncodingException;
import java.security.NoSuchAlgorithmException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Enumeration;
import java.util.TimeZone;
import java.util.Vector;
import javax.naming.NamingException;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

/**
 * Implements the User interface to provide default methods for control panel user authentication.
 * Extends Record to contain the data for a single users record.
 * Provides methods for inserting, updating, deleting, validation, and implements the Comparable interface for sorting.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class JcmsUser extends Record implements User {

  /** DB table name used for audit method */
  private static String tablename = "users";

  /** audit comment used when adding/removing nodes to user */
  private String auditComment;

  /** users.uid: the primary key for this record */
  public int uid = 0;

  /** users.lastname: the user's last name */
  public String lastname = null;

  /** users.firstname: the user's first name */
  public String firstname = null;

  /** users.email: the user's email address - private to enforce usage of setEmail() and getEmail() */
  private String email = null;

  /** users.password: the user's encrypted password */
  public String password = null;

  /** users.created: creation timestamp */
  public Timestamp created = null;

  /** users.updated: update timestamp */
  public Timestamp updated = null;

  /** old email stored for update of tables that use email as key */
  private String oldEmail = null;

  /**
   * Construct a default instance, used to reach the getUser methods or as a placeholder.
   */
  public JcmsUser() {
    setDefaults();
  }

  /**
   * Construct given a ServletContext to get DB connection and an email/password combination.
   */
  public JcmsUser(ServletContext context, String user_email, String plain_password) throws UserNotFoundException, SQLException, FileNotFoundException, NamingException, ClassNotFoundException, ValidationException, NoSuchAlgorithmException, UnsupportedEncodingException {
    DB db = null;
    try {
      db = new DB(context);
      select(db, user_email, Authentication.encrypt(plain_password));
    } finally {
      if (db!=null) db.close();
    }
    if (uid==0) throw new UserNotFoundException("No user associated with provided email and/or password.");
  }

  /**
   * Construct given a ServletContext to get DB connection and an email - use wisely!
   */
  public JcmsUser(ServletContext context, String user_email) throws UserNotFoundException, SQLException, FileNotFoundException, NamingException, ClassNotFoundException, ValidationException, NoSuchAlgorithmException, UnsupportedEncodingException {
    DB db = null;
    try {
      db = new DB(context);
      select(db, user_email);
    } finally {
      if (db!=null) db.close();
    }
    if (uid==0) throw new UserNotFoundException("No user associated with provided email address.");
  }

  /**
   * Construct given a ServletContext to get DB connection and a primary key.
   */
  public JcmsUser(ServletContext context, int uid) throws UserNotFoundException, SQLException, FileNotFoundException, NamingException, ClassNotFoundException, ValidationException, NoSuchAlgorithmException, UnsupportedEncodingException {
    DB db = null;
    try {
      db = new DB(context);
      select(db, uid);
    } finally {
      if (db!=null) db.close();
    }
    if (uid==0) throw new UserNotFoundException("No user associated with provided key.");
  }

  /**
   * Construct given a filled ResultSet
   */
  JcmsUser(ResultSet rs) throws SQLException {
    populate(rs);
  }

  /**
   * Set instance variables given a filled ResultSet.
   */
  protected void populate(ResultSet rs) throws SQLException {
    uid = rs.getInt("uid");
    firstname = rs.getString("firstname");
    lastname = rs.getString("lastname");
    email = rs.getString("email");
    password = rs.getString("password");
    created = rs.getTimestamp("created");
    updated = rs.getTimestamp("updated");
  }

  /**
   * Refresh this instance with values from the database record
   */
  protected void refresh(DB db) throws SQLException {
    select(db, uid);
  }

  /**
   * Set instance variables given a primary key uid.
   */
  protected void select(DB db, int uid) throws SQLException {
    db.executeQuery("SELECT * FROM users WHERE uid="+uid);
    if (db.rs.next()) populate(db.rs);
  }

  /**
   * Set instance variables given a DB connection and an email/password combination.
   */
  void select(DB db, String user_email, String user_password) throws SQLException {
    db.executeQuery("SELECT * FROM users WHERE email='"+user_email.trim()+"' AND password='"+user_password.trim()+"'");
    if (db.rs.next()) populate(db.rs);
  }

  /**
   * Set instance variables given a DB connection and just an email - use wisely!
   */
  void select(DB db, String user_email) throws SQLException {
    db.executeQuery("SELECT * FROM users WHERE email='"+user_email.trim()+"'");
    if (db.rs.next()) populate(db.rs);
  }

  /**
   * Inserts a new database record with current instance values.
   * Password encryption is done before this call with setPassword(); email is checked to be valid using Authentication.isValidEmail.
   */
  protected void insert(DB db) throws SQLException, ValidationException {
    boolean requiredMissing = (firstname==null || firstname.trim().length()==0 
			       || lastname==null || lastname.trim().length()==0
			       || email==null || email.trim().length()==0);
    // password is required
    requiredMissing = requiredMissing  || password==null || password.trim().length()==0;
    if (requiredMissing) {
      throw new ValidationException("First name, last name, email and password are all required.");
    } else if (!Authentication.isValidEmail(email)) {
      throw new ValidationException("The supplied email address is invalid.");
    } else {
      String query = "INSERT INTO users (" +
	"firstname,lastname,email,password" +
	") VALUES (" +
	charsOrNull(firstname)+"," +
	charsOrNull(lastname)+"," +
	charsOrNull(email)+"," +
	charsOrNull(password) +
	")";
      db.executeUpdate(query);
      // get the uid and creation timestamp
      db.executeQuery("SELECT * FROM users WHERE email="+charsOrNull(email));
      if (db.rs.next()) {
	uid = db.rs.getInt("uid");
	created = db.rs.getTimestamp("created");
      }
    }
  }

  /**
   * Updates the record with the current instance values.
   * Password encryption must be done before this call with setPassword(); email is checked to be valid using Authentication.isValidEmail.
   */
  protected void update(DB db) throws SQLException, ValidationException {
    if (uid!=0) {
      boolean requiredMissing = (firstname==null || firstname.trim().length()==0 ||
				 lastname==null || lastname.trim().length()==0 ||
				 email==null || email.trim().length()==0);
      // password is required
      requiredMissing = requiredMissing || password==null || password.trim().length()==0;
      if (requiredMissing) {
	throw new ValidationException("First name, last name, email and password are all required.");
      } else if (!Authentication.isValidEmail(email)) {
	throw new ValidationException("The supplied email address is invalid.");
      } else {
	String query = "UPDATE users SET " +
	  "updated="+db.now()+", " +
	  "firstname="+charsOrNull(firstname)+", " +
	  "lastname="+charsOrNull(lastname)+", " +
	  "email="+charsOrNull(email)+", " +
	  "password="+charsOrNull(password)+" " +
	  "WHERE uid="+uid;
	db.executeUpdate(query);
	db.executeQuery("SELECT updated FROM users WHERE uid="+uid);
	db.rs.next();
	updated = db.rs.getTimestamp("updated");
	// update associated records if email has been updated
	if (oldEmail!=null) {
	  db.executeUpdate("UPDATE users_extras SET username="+charsOrNull(email)+" WHERE username="+charsOrNull(oldEmail));
	  db.executeUpdate("UPDATE users_extensions SET username="+charsOrNull(email)+" WHERE username="+charsOrNull(oldEmail));
	  db.executeUpdate("UPDATE users_nodes SET username="+charsOrNull(email)+" WHERE username="+charsOrNull(oldEmail));
	  db.executeUpdate("UPDATE cproles SET username="+charsOrNull(email)+" WHERE username="+charsOrNull(oldEmail));
	}
      }
    }
  }

  /**
   * Delete a user record.
   */
  protected void delete(DB db) throws SQLException, ValidationException {
    // delete child records (but not records in audit, which stores past activity)
    db.executeUpdate("DELETE FROM users_nodes WHERE username='"+email+"'");
    db.executeUpdate("DELETE FROM users_extras WHERE username='"+email+"'");
    db.executeUpdate("DELETE FROM users_extensions WHERE username='"+email+"'");
    db.executeUpdate("DELETE FROM cproles WHERE username='"+email+"'");
    // delete parent record
    db.executeUpdate("DELETE FROM users WHERE uid="+uid);
    setDefaults();
  }

  /**
   * Sets default values when instance does not correspond to a database record (such as after delete() is called
   */
  protected void setDefaults() {
    uid = 0;
    firstname = null;
    lastname = null;
    email = null;
    password = null;
  }

  /**
   * Sets the instance variable to the provided email IF it passes email validation.
   */
  public void setEmail(String inmail) throws ValidationException {
    if (inmail==null || inmail.trim().length()==0) {
      throw new ValidationException("The supplied email address is empty.");
    } else if (Authentication.isValidEmail(inmail)) {
      oldEmail = email;
      email = inmail;
    } else {
      throw new ValidationException("The supplied email address is invalid.");
    }
  }

  /**
   * Encrypts the provided password and sets the instance variable.
   */
  public void setPassword(String plainpass) throws ValidationException, NoSuchAlgorithmException, UnsupportedEncodingException {
    password = Authentication.encrypt(plainpass);
  }

  /**
   * Inserts an audit record for the given action
   */
  protected void audit(DB db, char action, String username) throws SQLException {
    Audit a = new Audit();
    a.tablename = tablename;
    a.record_id = uid;
    a.action = action;
    a.username = username;
    a.description = "";
    if (email!=null) a.description = email;
    if (auditComment!=null) a.description += " "+auditComment;
    a.insert(db);
  }

  /**
   * Return true if this is the default user (not associated with a record in users).
   */
  public boolean isDefault() {
    return uid==0;
  }

  /**
   * Return alpha comparison of last name.
   */
  public int compareTo(Object o) {
    JcmsUser that = (JcmsUser)o;
    return this.lastname.compareTo(that.lastname);
  }

  /**
   * Return true if this JcmsUser matches the provided JcmsUser.
   */
  public boolean equals(JcmsUser u) {
    if (isDefault() || u.isDefault()) {
      return false;
    } else {
      return this.uid==u.uid;
    }
  }

  /**
   * Return true if this JcmsUser matches the provided User.
   */
  public boolean equals(User u) {
    if (isDefault() || u==null || u.getUsername()==null) {
      return false;
    } else {
      return this.getUsername().equals(u.getUsername());
    }
  }

  /**
   * Return true if same user
   */
  public boolean equals(Object o) {
    User that = (User) o;
    return this.equals(that);
  }

  /**
   * Return an array of all users, sorted by increasing lastname.
   */
  static public JcmsUser[] getAll(ServletContext context) throws UserException {
    DB db = null;
    try {
      db = new DB(context);
      db.executeQuery("SELECT count(*) AS count FROM users");
      db.rs.next();
      int count = db.rs.getInt("count");
      JcmsUser[] users = new JcmsUser[count];
      db.executeQuery("SELECT * FROM users ORDER BY lastname");
      int i = 0;
      while (db.rs.next()) users[i++] = new JcmsUser(db.rs);
      return users;
    } catch (Exception ex) {
      throw new UserException(ex.toString());
    } finally {
      if (db!=null) {
	try { db.close(); } catch (SQLException ex) { throw new UserException(ex.toString()); }
      }
    }
  }

  /**
   * Return a User for the provided username/email and password.
   */
  public User getUser(ServletContext context, String username, String password) throws UserException {
    try {
      return new JcmsUser(context, username, password);
    } catch (Exception ex) {
      throw new UserException(ex.toString());
    }
  }

  /**
   * Return a User for the provided username.
   */
  public User getUser(ServletContext context, String username) throws UserException {
    try {
      return new JcmsUser(context, username);
    } catch (Exception ex) {
      throw new UserException(ex.toString());
    }
  }

  /**
   * Return an array of all users, sorted by increasing lastname.
   */
  public User[] getAllUsers(ServletContext context) throws UserException {
    DB db = null;
    try {
      db = new DB(context);
      db.executeQuery("SELECT count(*) AS count FROM users");
      db.rs.next();
      int count = db.rs.getInt("count");
      JcmsUser[] users = new JcmsUser[count];
      db.executeQuery("SELECT * FROM users ORDER BY lastname");
      int i = 0;
      while (db.rs.next()) users[i++] = new JcmsUser(db.rs);
      return users;
    } catch (Exception ex) {
      throw new UserException(ex.toString());
    } finally {
      if (db!=null) {
	try { db.close(); } catch (SQLException ex) { throw new UserException(ex.toString()); }
      }
    }
  }

  /**
   * Return this user's username.
   */
  public String getUsername() {
    return email;
  }

  /**
   * Return this user's first name.
   */
  public String getFirstname() {
    return firstname;
  }

  /**
   * Return this user's last name.
   */
  public String getLastname() {
    return lastname;
  }

  /**
   * Return this user's email address.
   */
  public String getEmail() {
    return email;
  }

}
