package net.ims.jcms;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.security.NoSuchAlgorithmException;
import java.security.InvalidKeyException;
import java.security.InvalidAlgorithmParameterException;
import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.TimeZone;
import javax.crypto.NoSuchPaddingException;
import javax.naming.NamingException;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;;

/**
 * Abstract class which defines standard methods for an object which contains a single database record.
 * Provides methods for inserting, updating, deleting, validation, and implements the Comparable interface for sorting.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public abstract class Record implements Comparable {

  /**
   * Populate an instance given a populated ResultSet.
   */
  protected abstract void populate(ResultSet rs) throws SQLException;

  /**
   * Do a SELECT query and set instance variables given a DB connection and a primary key
   */
  protected abstract void select(DB db, int key) throws SQLException;

  /**
   * Refresh this record from the database, without needing to know the key
   */
  protected abstract void refresh(DB db) throws SQLException;

  /**
   * Insert a new record into the database using the current instance variables and a DB connection
   */
  protected abstract void insert(DB db) throws SQLException, ValidationException;

  /**
   * Update database record with current instance values given DB object
   */
  protected abstract void update(DB db) throws SQLException, ValidationException;

  /**
   * Delete this record from the database.
   */
  protected abstract void delete(DB db) throws SQLException, ValidationException;

  /**
   * Set default values when instance does not correspond to a database record (such as after delete() is called
   */
  protected abstract void setDefaults();

  /**
   * Log a database action in the audit table
   */
  protected abstract void audit(DB db, char action, String username) throws SQLException;

  /**
   * Return true if record is a default, unpopulated instance
   */
  public abstract boolean isDefault();

  /**
   * Comparator for sorting
   */
  public abstract int compareTo(Object o);

  /**
   * Equality check for comparison
   */
  public abstract boolean equals(Object o);

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
    audit(request.getSession(), 'U');
  }

  /**
   * Delete a database record with current instance values, preceded by license check and auditing.
   */
  public void delete(HttpServletRequest request) throws SQLException, ValidationException, NamingException, FileNotFoundException, ClassNotFoundException, IOException, 
							NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, InvalidAlgorithmParameterException, 
							LicenseInvalidException, UserNotFoundException {
    License.check(request, 0);
    audit(request.getSession(), 'D');
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
    audit(request.getSession(), 'I');
  }

  /**
   * Update a database record with current instance values, preceded by license check, followed by auditing with username explicitly provided.
   */
  public void update(HttpServletRequest request, String username) throws SQLException, ValidationException, NamingException, FileNotFoundException, ClassNotFoundException, IOException, 
								      NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, InvalidAlgorithmParameterException, 
								      LicenseInvalidException, UserNotFoundException {
    License.check(request, 0);
    DB db = null;
    try {
      db = new DB(request.getSession().getServletContext());
      update(db);
      audit(db, 'U', username);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Delete a database record with current instance values, preceded by license check and auditing with username explicitly provided.
   */
  public void delete(HttpServletRequest request, String username) throws SQLException, ValidationException, NamingException, FileNotFoundException, ClassNotFoundException, IOException, 
								      NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, InvalidAlgorithmParameterException, 
								      LicenseInvalidException, UserNotFoundException {
    License.check(request, 0);
    DB db = null;
    try {
      db = new DB(request.getSession().getServletContext());
      audit(db, 'D', username);
      delete(db);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Insert a database record with current instance values, preceded by license check, followed by auditing with username explicitly provided.
   */
  public void insert(HttpServletRequest request, String username) throws SQLException, ValidationException, NamingException, FileNotFoundException, ClassNotFoundException, IOException, 
								      NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, InvalidAlgorithmParameterException, 
								      LicenseInvalidException, UserNotFoundException {
    License.check(request, 0);
    DB db = null;
    try {
      db = new DB(request.getSession().getServletContext());
      insert(db);
      audit(db, 'I', username);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Insert a database record with current instance values, without license check or auditing.  Useful for front-end tasks and extensions.
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

  /**
   * Update a database record with current instance values, without license check or auditing.  Useful for front-end tasks and extensions.
   */
  public void update(ServletContext context) throws SQLException, ValidationException, NamingException, FileNotFoundException, ClassNotFoundException, IOException {
    DB db = null;
    try {
      db = new DB(context);
      update(db);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Delete a database record, without license check or auditing.  Useful for front-end tasks and extensions.
   */
  public void delete(ServletContext context) throws SQLException, ValidationException, NamingException, FileNotFoundException, ClassNotFoundException, IOException {
    DB db = null;
    try {
      db = new DB(context);
      delete(db);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Refresh the current instance values from the database record
   */
  public void refresh(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException, IOException {
    DB db = null;
    try {
      db = new DB(context);
      refresh(db);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Audit a database action performed by the user associated with an HTTP session
   */
  public void audit(HttpSession session, char action) throws UserNotFoundException, SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    ControlPanelUser user = new ControlPanelUser(session);
    DB db = null;
    try {
      ServletContext context = session.getServletContext();
      db = new DB(context);
      audit(db, action, user.username);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Escape quotes for use in SQL statements
   */
  public static String escapeQuotes(String str) {
    return str.replaceAll("'", "''");
  }

  /**
   * Return NULL in the case of empty or null strings, quoted string otherwise
   */
  public static String charsOrNull(String str) {
    return Util.charsOrNull(str);
  }

  /**
   * Return quoted empty string in case of empty or null string; quoted string otherwise
   */
  public static String charsOrEmpty(String str) {
    return Util.charsOrEmpty(str);
  }

  /**
   * Return NULL in the case of empty char
   */
  public static String charOrNull(char c) {
    if (c=='\0') {
      return "NULL";
    } else {
      return "'"+c+"'";
    }
  }

  /**
   * Return a quoted fixed-quotes string or DEFAULT if it's empty or "null".
   */
  public static String charsOrDefault(String str) {
    return Util.charsOrDefault(str);
  }

  /**
   * Return a quoted fixed-quotes timestamp string or DEFAULT if it's null
   */
  public static String charsOrDefault(Timestamp t) {
    if (t==null) {
      return "DEFAULT";
    } else {
      return "'"+t.toString()+"'";
    }
  }

  /**
   * Return a quoted fixed-quotes timestamp string or NULL if it's null
   */
  public static String charsOrNull(Timestamp t) {
    if (t==null) {
      return "NULL";
    } else {
      return "'"+t.toString()+"'";
    }
  }

  /**
   * Return a quoted fixed-quotes date string or NULL if it's null
   */
  public static String charsOrNull(Date d) {
    if (d==null) {
      return "NULL";
    } else {
      return "'"+d.toString()+"'";
    }
  }

  /**
   * Return NULL in the case of zero, argument otherwise
   */
  public static String intOrNull(int i) {
    return Util.intOrNull(i);
  }

  /**
   * Return DEFAULT in the case of zero, argument otherwise
   */
  public static String intOrDefault(int i) {
    return Util.intOrDefault(i);
  }

  /**
   * Return NULL in case of zero, argument otherwise
   */
  public static String doubleOrNull(double d) {
    return Util.doubleOrNull(d);
  }

  /**
   * Return DEFAULT in case of zero, argument otherwise
   */
  public static String doubleOrDefault(double d) {
    return Util.doubleOrDefault(d);
  }

  /**
   * Return true if string is null or empty (can be just spaces)
   */
  public static boolean nullOrEmpty(String s) {
    return (s==null || s.trim().length()==0);
  }

  /**
   * Format a timestamp into a string with the desired look and timezone, given a ServletContext
   */
  public static String formatTimestamp(ServletContext context, Timestamp t) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    if (t==null) {
      return null;
    } else {
      DB db = null;
      try {
	db = new DB(context);
	return formatTimestamp(db, t);
      } finally {
	if (db!=null) db.close();
      }
    }
  }

  /**
   * Format a timestamp into a string with the desired look and timezone, given a DB instance
   */
  public static String formatTimestamp(DB db, Timestamp t) throws SQLException {
    if (t==null) {
      return null;
    } else {
      SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy HH:mm:ss zzz");
      sdf.setTimeZone(TimeZone.getTimeZone(db.getTimeZone()));
      return sdf.format(t);
    }
  }

  /**
   * Format a timestamp using the default time zone
   */
  public static String formatTimestamp(Timestamp t) {
    SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy HH:mm:ss");
    return sdf.format(t);
  }

}
