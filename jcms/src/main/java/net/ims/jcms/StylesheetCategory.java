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
 * Extends Record to contain the data for a single stylesheetcategories record.
 * Provides methods for inserting, updating, deleting, validation, and implements the Comparable interface for sorting.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class StylesheetCategory extends Record {

  /** stylesheetcategories.stylesheetcategory_id: the primary key for this record */
  public int stylesheetcategory_id = 0;

  /** stylesheetcategories.stylesheetcategory: the name of this category */
  public String stylesheetcategory = null;

  /** stylesheetcategories.num: ordering number */
  public int num = 0;

  /**
   * Construct given DB connection and an int primary key
   */
  public StylesheetCategory(DB db, int key) throws SQLException {
    select(db, key);
  }

  /**
   * Construct given a filled ResultSet
   */
  protected StylesheetCategory(ResultSet rs) throws SQLException {
    populate(rs);
  }

  /**
   * Set instance variables given a DB connection and a primary key
   */
  protected void select(DB db, int key) throws SQLException {
    db.executeQuery("SELECT * FROM stylesheetcategories WHERE stylesheetcategory_id="+key);
    if (db.rs.next()) populate(db.rs);
  }

  /**
   * Set instance variables given a filled ResultSet
   */
  protected void populate(ResultSet rs) throws SQLException {
    stylesheetcategory_id = rs.getInt("stylesheetcategory_id");
    stylesheetcategory = rs.getString("stylesheetcategory");
    num = rs.getInt("num");
  }

  /**
   * Refresh this instance with values from the database record
   */
  protected void refresh(DB db) throws SQLException {
    select(db, stylesheetcategory_id);
  }

  /**
   * Does nothing.
   */
  protected void insert(DB db) {
  }

  /**
   * Does nothing.
   */
  protected void update(DB db) throws SQLException {
  }

  /**
   * Does nothing.
   */
  protected void delete(DB db) throws SQLException, ValidationException {
  }

  /**
   * Set default values when instance does not correspond to a database record (such as after delete() is called
   */
  protected void setDefaults() {
    stylesheetcategory_id = 0;
    stylesheetcategory = null;
    num = 0;
  }

  /**
   * Return true if this is a default, uninstantiated instance
   */
  public boolean isDefault() {
    return stylesheetcategory_id==0;
  }

  /**
   * No auditing done for this class
   */
  protected void audit(DB db, char action, String email) {
  }

  /**
   * Comparator for sorting, based on stylesheetcategory_id
   */
  public int compareTo(Object o) {
    StylesheetCategory that = (StylesheetCategory)o;
    return this.num - that.num;
  }

  /**
   * Return true if same primary key
   */
  public boolean equals(Object o) {
    StylesheetCategory that = (StylesheetCategory) o;
    return this.stylesheetcategory_id==that.stylesheetcategory_id;
  }

  /**
   * Return an array of all stylesheetcategories, sorted by increasing num.
   */
  public static StylesheetCategory[] getStylesheetCategories(DB db) throws SQLException {
    db.executeQuery("SELECT count(*) AS count FROM stylesheetcategories");
    db.rs.next();
    int count = db.rs.getInt("count");
    StylesheetCategory[] stylesheetcategories = new StylesheetCategory[count];
    db.executeQuery("SELECT * FROM stylesheetcategories ORDER BY num");
    int i = 0;
    while (db.rs.next()) stylesheetcategories[i++] = new StylesheetCategory(db.rs);
    return stylesheetcategories;
  }

  /**
   * Return an array of all stylesheetcategories, sorted by increasing stylesheetcategory_id.
   */
  public static StylesheetCategory[] getStylesheetCategories(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return getStylesheetCategories(db);
    } finally {
      if (db!=null) db.close();
    }
  }

}

