package net.ims.jcms;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.io.FileNotFoundException;
import javax.naming.NamingException;
import javax.servlet.ServletContext;

/**
 * Extends Record to contain the data for a single extensions record.
 * Provides methods for inserting, updating, deleting, validation, and implements the Comparable interface for sorting.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class Extension extends Record {

  /** the name of the database table, used by audit method */
  private static String tablename = "extensions";
 
  /** extensions.extid: the primary key for this record */
  public int extid = 0;

  /** extensions.num: the number used for sorting */
  public int num = 0;

  /** extensions.name: the name of this extension */
  public String name = null;

  /** extensions.cpcontext: the control panel context */
  public String cpcontext = null;

  /** extensions.cpurl: the control panel url */
  public String cpurl = null;

  /** extensions.parent_extid: the primary key of the parent, if this is a subsidiary module */
  public int parent_extid = 0;

  /**
   * Construct a default instance
   */
  public Extension() {
    setDefaults();
  }

  /**
   * Construct given DB connection and an int primary key
   */
  public Extension(DB db, int key) throws SQLException {
    select(db, key);
  }

  /**
   * Construct given a Servlet context and primary key
   */
  public Extension(ServletContext context, int key) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
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
  Extension(ResultSet rs) throws SQLException {
    populate(rs);
  }

  /**
   * Do a SELECT query and set instance variables given a DB connection and a primary key
   */
  protected void select(DB db, int key) throws SQLException {
    db.executeQuery("SELECT * FROM extensions WHERE extid="+key);
    if (db.rs.next()) populate(db.rs);
  }

  /**
   * Populate this instance from a populated ResultSet.
   */
  protected void populate(ResultSet rs) throws SQLException {
    extid = rs.getInt("extid");
    num = rs.getInt("num");
    name = rs.getString("name");
    cpcontext = rs.getString("cpcontext");
    cpurl = rs.getString("cpurl");
    parent_extid = rs.getInt("parent_extid");
  }

  /**
   * Refresh this instance with values from the database record
   */
  protected void refresh(DB db) throws SQLException {
    select(db, extid);
  }

  /**
   * Insert a new extensions record into the database and retrieve/set the resulting extid.
   */
  protected void insert(DB db) throws SQLException, ValidationException {
    if (num==0) throw new ValidationException("Num must be a positive number.");
    if (name==null || name.trim().equals("")) throw new ValidationException("You must supply a extension name.");
    if (cpcontext==null || cpurl.trim().equals("")) throw new ValidationException("You must supply a control panel context for this module.");
    if (cpurl==null || cpurl.trim().equals("")) throw new ValidationException("You must supply a control panel URL for this module.");
    String query = "INSERT INTO extensions (" +
      "num, name, cpcontext, cpurl, parent_extid" +
      ") VALUES (" +
      intOrNull(num)+"," +
      charsOrNull(name)+"," +
      charsOrNull(cpcontext)+"," +
      charsOrNull(cpurl)+"," +
      intOrNull(parent_extid) +
      ")";
    db.executeUpdate(query);
    db.executeQuery("SELECT max(extid) AS extid FROM extensions");
    db.rs.next();
    extid = db.rs.getInt("extid");
  }

  /**
   * Update the extensions record.
   */
  protected void update(DB db) throws SQLException, ValidationException {
    if (num==0) throw new ValidationException("Num must be a positive number.");
    if (name==null || name.trim().equals("")) throw new ValidationException("You must supply a extension name.");
    if (cpcontext==null || cpurl.trim().equals("")) throw new ValidationException("You must supply a control panel context for this module.");
    if (cpurl==null || cpurl.trim().equals("")) throw new ValidationException("You must supply a control panel URL for this module.");
    String query = "UPDATE extensions SET " +
      "name="+charsOrNull(name)+", " +
      "num="+intOrNull(num)+", " +
      "cpcontext="+charsOrNull(cpcontext)+", " +
      "cpurl="+charsOrNull(cpurl)+", " +
      "parent_extid="+intOrNull(parent_extid)+" " + 
      "WHERE extid="+extid;
    db.executeUpdate(query);
    select(db, extid);
  }

  /**
   * Delete the current record, and child records, and reset to defaults.
   */
  protected void delete(DB db) throws SQLException, ValidationException {
    // child records
    db.executeUpdate("DELETE FROM extensions WHERE parent_extid="+extid);
    // parent record
    db.executeUpdate("DELETE FROM extensions WHERE extid="+extid);
    setDefaults();
  }

  /**
   * Set default values when instance does not correspond to a database record (such as after delete() is called
   */
  protected void setDefaults() {
    extid = 0;
    num = 0;
    name = null;
    cpcontext = null;
    cpurl = null;
    parent_extid = 0;
  }

  /**
   * Return true if this is a default, uninstantiated instance
   */
  public boolean isDefault() {
    return extid==0;
  }

  /**
   * Insert an audit record for the given action.
   */
  protected void audit(DB db, char action, String username) throws SQLException {
    Audit a = new Audit();
    a.tablename = tablename;
    a.record_id = extid;
    a.action = action;
    a.username = username;
    a.description = name;
    a.insert(db);
  }

  /**
   * Comparator for sorting; uses num if same parent_extid, else uses parent_extid.
   */
  public int compareTo(Object o) {
    Extension that = (Extension)o;
    if (this.parent_extid==that.parent_extid) {
      return (this.num - that.num);
    } else {
      return (this.parent_extid - that.parent_extid);
    }
  }

  /**
   * Return true if same primary key
   */
  public boolean equals(Object o) {
    Extension that = (Extension) o;
    return this.extid==that.extid;
  }

  /**
   * Return all primary extensions records (parent_extid is null), ordered by num.
   */
  static Extension[] getPrimary(DB db) throws SQLException {
    db.executeQuery("SELECT count(*) AS count FROM extensions WHERE parent_extid IS NULL");
    db.rs.next();
    int count = db.rs.getInt("count");
    Extension[] all = new Extension[count];
    int i = 0;
    db.executeQuery("SELECT * FROM extensions WHERE parent_extid IS NULL ORDER BY num");
    while (db.rs.next()) all[i++] = new Extension(db.rs);
    return all;
  }

  /**
   * Return all primary extensions records (parent_extid is null), ordered by num.
   */
  public static Extension[] getPrimary(ServletContext context) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return getPrimary(db);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return all secondary extensions records associated with the given parent record, ordered by num.
   */
  static Extension[] getSecondary(DB db, int parent_key) throws SQLException {
    db.executeQuery("SELECT count(*) AS count FROM extensions WHERE parent_extid="+parent_key);
    db.rs.next();
    int count = db.rs.getInt("count");
    Extension[] all = new Extension[count];
    int i = 0;
    db.executeQuery("SELECT * FROM extensions WHERE parent_extid="+parent_key+" ORDER BY num");
    while (db.rs.next()) all[i++] = new Extension(db.rs);
    return all;
  }

  /**
   * Return all secondary extensions records associated with the given parent record, ordered by num.
   */
  public static Extension[] getSecondary(ServletContext context, int parent_key) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return getSecondary(db, parent_key);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return true if this is a primary extension.
   */
  public boolean isPrimary() {
    return (parent_extid==0);
  }

  /**
   * Return an extension that matches the provided control panel URL, else null.
   */
  static Extension getByURL(DB db, String url) throws SQLException {
    db.executeQuery("SELECT extid FROM extensions WHERE cpurl='"+url+"'");
    if (db.rs.next()) {
      int extid = db.rs.getInt("extid");
      return new Extension(db, extid);
    } else {
      return null;
    }
  }

  /**
   * Return an extension that matches the provided control panel URL, else null.
   */
  public static Extension getByURL(ServletContext context, String url) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return getByURL(db, url);
    } finally {
      if (db!=null) db.close();
    }
  }

    
  

}
