package net.ims.jcms;

import java.io.FileNotFoundException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.TimeZone;
import javax.naming.NamingException;
import javax.servlet.ServletContext;

/**
 * Extends Record to contain the data for a single sidebarextensions record.
 * Provides methods for inserting, updating, deleting, validation, and implements the Comparable interface for sorting.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class SidebarExtension extends Record {

  /** the name of the database table, used by audit method */
  private static String tablename = "sidebarextensions";

  /** sidebarextensions.sidebarextension_id: the primary key for this record */
  public int sidebarextension_id;

  /** sidebarextensions.num: number which gives order of display **/
  public int num;

  /** sidebarextensions.location: char indicating the location (T=top, S=standard, below) of the link **/
  public char location;

  /** sidebarextensions.extensioncontext: the text which is linked */
  public String extensioncontext;

  /** sidebarextensions.extensionurl: the link url */
  public String extensionurl;

  /**
   * Construct a default instance, usually preceding an insert
   */
  public SidebarExtension() {
    setDefaults();
  }

  /**
   * Construct given DB connection and an int primary key
   */
  SidebarExtension(DB db, int key) throws SQLException {
    select(db, key);
  }

  /**
   * Construct given DB connection and an int primary key
   */
  public SidebarExtension(ServletContext context, int key) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      select(db, key);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Construct given a populated ResultSet.
   */
  SidebarExtension(ResultSet rs) throws SQLException {
    populate(rs);
  }


  /**
   * Populate instance fields given a populated ResultSet.
   */
  protected void populate(ResultSet rs) throws SQLException {
    sidebarextension_id = rs.getInt("sidebarextension_id");
    num = rs.getInt("num");
    location = rs.getString("location").charAt(0);
    extensioncontext = rs.getString("extensioncontext");
    extensionurl = rs.getString("extensionurl");
  }

  /**
   * Refresh this instance with values from the database record
   */
  protected void refresh(DB db) throws SQLException {
    select(db, sidebarextension_id);
  }

  /**
   * Do a SELECT query and set instance variables given a DB connection and a primary key
   */
  protected void select(DB db, int key) throws SQLException {
    db.executeQuery("SELECT * FROM sidebarextensions WHERE sidebarextension_id="+key);
    if (db.rs.next()) populate(db.rs);
  }

  /**
   * Insert a new db record using the current instance values.
   */
  protected void insert(DB db) throws SQLException, ValidationException {
    if (extensioncontext==null || extensioncontext.trim().length()==0) throw new ValidationException("Extension Context is required.");
    if (extensionurl==null || extensionurl.trim().length()==0) throw new ValidationException("Extension URL is required.");
    String query = "INSERT INTO sidebarextensions (" +
      "num, location, extensioncontext, extensionurl" +
      ") VALUES (" +
      num+",'"+location+"',"+charsOrNull(extensioncontext)+","+charsOrNull(extensionurl) +
      ")";
    db.executeUpdate(query);
    db.executeQuery("SELECT * FROM sidebarextensions WHERE extensionurl="+charsOrNull(extensionurl));
    if (db.rs.next()) populate(db.rs);
  }

  /**
   * Update the db record using the current instance values.
   */
  protected void update(DB db) throws SQLException, ValidationException {
    if (extensioncontext==null || extensioncontext.trim().length()==0) throw new ValidationException("Extension Context is required.");
    if (extensionurl==null || extensionurl.trim().length()==0) throw new ValidationException("Extension URL is required.");
    String query = "UPDATE sidebarextensions SET " +
      "num="+num+", " +
      "location='"+location+"', " +
      "extensioncontext="+charsOrNull(extensioncontext)+", " +
      "extensionurl="+charsOrNull(extensionurl)+" " +
      "WHERE sidebarextension_id="+sidebarextension_id;
    db.executeUpdate(query);
  }

  /**
   * Delete the current db record and reset instance values to defaults.
   */
  protected void delete(DB db) throws SQLException {
    db.executeUpdate("DELETE FROM sidebarextensions WHERE sidebarextension_id="+sidebarextension_id);
    setDefaults();
  }

  /**
   * Set default values when instance does not correspond to a database record (such as after delete() is called
   */
  protected void setDefaults() {
    sidebarextension_id = 0;
    num = 0;
    location = '\0';
    extensioncontext = null;
    extensionurl = null;
  }

  /**
   * Return true if this is a default, uninstantiated instance
   */
  public boolean isDefault() {
    return sidebarextension_id==0;
  }

  /**
   * Insert an audit record for the given action
   */
  protected void audit(DB db, char action, String username) throws SQLException {
    Audit a = new Audit();
    a.tablename = tablename;
    a.record_id = sidebarextension_id;
    a.action = action;
    a.username = username;
    a.description = extensioncontext+"/"+extensionurl;
    a.insert(db);
  }

  /**
   * Comparator for sorting, based on num
   */
  public int compareTo(Object o) {
    SidebarExtension that = (SidebarExtension)o;
    return this.num - that.num;
  }

  /**
   * Return true if same primary key
   */
  public boolean equals(Object o) {
    SidebarExtension that = (SidebarExtension) o;
    return this.sidebarextension_id==that.sidebarextension_id;
  }

  /**
   * Return an array of all sidebar extensions at location
   */
  static SidebarExtension[] getByLocation(DB db, char location) throws SQLException {
    db.executeQuery("SELECT count(*) AS count FROM sidebarextensions WHERE location='"+location+"'");
    db.rs.next();
    int count = db.rs.getInt("count");
    SidebarExtension[] sidebarextensions = new SidebarExtension[count];
    db.executeQuery("SELECT * FROM sidebarextensions WHERE location='"+location+"' ORDER BY num");
    int i = 0;
    while (db.rs.next()) sidebarextensions[i++] = new SidebarExtension(db.rs);
    return sidebarextensions;
  }

  /**
   * Return an array of all sidebar extensions at location
   */
  public static SidebarExtension[] getByLocation(ServletContext context, char location) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return getByLocation(db, location);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return an array of all sidebar extensions
   */
  static SidebarExtension[] getAll(DB db) throws SQLException {
    db.executeQuery("SELECT count(*) AS count FROM sidebarextensions");
    db.rs.next();
    int count = db.rs.getInt("count");
    SidebarExtension[] sidebarextensions = new SidebarExtension[count];
    db.executeQuery("SELECT * FROM sidebarextensions ORDER BY location,num");
    int i = 0;
    while (db.rs.next()) sidebarextensions[i++] = new SidebarExtension(db.rs);
    return sidebarextensions;
  }

}

