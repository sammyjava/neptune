package net.ims.jcms;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.io.FileNotFoundException;
import javax.naming.NamingException;
import javax.servlet.ServletContext;

/**
 * Extends Record to contain the data for a single extras record.
 * Provides methods for inserting, updating, deleting, validation, and implements the Comparable interface for sorting.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class Extra extends Record {

  /** the name of the database table, used by audit method */
  private static String tablename = "extras";
 
  /** extras.extra_id: the primary key for this record */
  public int extra_id = 0;

  /** extras.parent_extra_id: the primary key of the parent, if this is a subsidiary module */
  public int parent_extra_id = 0;

  /** extras.name: the name of this extra */
  public String name = null;

  /** extras.cpurl: the control panel url */
  public String cpurl = null;

  /** extras.cpurl: the control panel doc */
  public String docurl = null;

  /**
   * Construct a default instance
   */
  public Extra() {
    setDefaults();
  }

  /**
   * Construct given DB connection and an int primary key
   */
  public Extra(DB db, int key) throws SQLException {
    select(db, key);
  }

  /**
   * Construct given a Servlet context and primary key
   */
  public Extra(ServletContext context, int key) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
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
  Extra(ResultSet rs) throws SQLException {
    populate(rs);
  }

  /**
   * Do a SELECT query and set instance variables given a DB connection and a primary key
   */
  protected void select(DB db, int key) throws SQLException {
    db.executeQuery("SELECT * FROM extras WHERE extra_id="+key);
    if (db.rs.next()) populate(db.rs);
  }

  /**
   * Populate this instance from a populated ResultSet
   */
  protected void populate(ResultSet rs) throws SQLException {
    extra_id = rs.getInt("extra_id");
    parent_extra_id = rs.getInt("parent_extra_id");
    name = rs.getString("name");
    cpurl = rs.getString("cpurl");
    docurl = rs.getString("docurl");
  }

  /**
   * Refresh this instance with values from the database record
   */
  protected void refresh(DB db) throws SQLException {
    select(db, extra_id);
  }

  /**
   * Extras are inserted manually by the DBA.
   */
  protected void insert(DB db) throws SQLException, ValidationException {
  }

  /**
   * Extras records are updated manually by the DBA.
   */
  protected void update(DB db) throws SQLException, ValidationException {
  }

  /**
   * Extras records are deleted manually by the DBA.
   */
  protected void delete(DB db) throws SQLException, ValidationException {
  }

  /**
   * Set default values when instance does not correspond to a database record (such as after delete() is called
   */
  protected void setDefaults() {
    extra_id = 0;
    parent_extra_id = 0;
    name = null;
    cpurl = null;
    docurl = null;
  }

  /**
   * Return true if this is a default, uninstantiated instance
   */
  public boolean isDefault() {
    return extra_id==0;
  }

  /**
   * Insert an audit record for the given action.  Disabled, nothing to audit.
   */
  protected void audit(DB db, char action, String email) throws SQLException {
  }

  /**
   * Comparator for sorting; alphabetically by name.
   */
  public int compareTo(Object o) {
    Extra that = (Extra)o;
    return this.name.compareTo(that.name);
  }

  /**
   * Return true if same primary key
   */
  public boolean equals(Object o) {
    Extra that = (Extra) o;
    return this.extra_id==that.extra_id;
  }

  /**
   * Return all primary extras records (parent_extra_id is null), ordered by name.
   */
  static Extra[] getPrimary(DB db) throws SQLException {
    db.executeQuery("SELECT count(*) AS count FROM extras WHERE parent_extra_id IS NULL");
    db.rs.next();
    int count = db.rs.getInt("count");
    Extra[] all = new Extra[count];
    db.executeQuery("SELECT * FROM extras WHERE parent_extra_id IS NULL ORDER BY name");
    int i = 0;
    while (db.rs.next()) all[i++] = new Extra(db.rs);
    return all;
  }

  /**
   * Return all primary extras records (parent_extra_id is null), ordered by name.
   */
  public static Extra[] getPrimary(ServletContext context) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return getPrimary(db);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return all secondary extras records associated with the given parent record, ordered by name.
   */
  static Extra[] getSecondary(DB db, int parent_key) throws SQLException {
    db.executeQuery("SELECT count(*) AS count FROM extras WHERE parent_extra_id="+parent_key);
    db.rs.next();
    int count = db.rs.getInt("count");
    Extra[] all = new Extra[count];
    int i = 0;
    db.executeQuery("SELECT * FROM extras WHERE parent_extra_id="+parent_key+" ORDER BY name");
    while (db.rs.next()) all[i++] = new Extra(db.rs);
    return all;
  }

  /**
   * Return all secondary extras records associated with the given parent record, ordered by name.
   */
  public static Extra[] getSecondary(ServletContext context, int parent_key) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return getSecondary(db, parent_key);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return true if this is a primary extra.
   */
  public boolean isPrimary() {
    return (parent_extra_id==0);
  }

  /**
   * Return an extra that matches the provided control panel URL, else null.
   */
  static Extra getByURL(DB db, String url) throws SQLException {
    db.executeQuery("SELECT * FROM extras WHERE cpurl='"+url+"'");
    if (db.rs.next()) {
      return new Extra(db.rs);
    } else {
      return null;
    }
  }

  /**
   * Return an extra that matches the provided control panel URL, else null.
   */
  public static Extra getByURL(ServletContext context, String url) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return getByURL(db, url);
    } finally {
      if (db!=null) db.close();
    }
  }

    
  

}
