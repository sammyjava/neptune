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
 * Extends Record to contain the data for a single Layout.
 * Provides methods for inserting, updating, deleting, validation, and implements the Comparable interface for sorting.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class Layout extends Record {

  /** the name of the database table, used by audit method */
  private static String tablename = "layouts";

  /** layouts.layout_id: the primary key for this record */
  public int layout_id = 0;

  /** layouts.num: the unique number of this layout, for identification */
  public int num = 0;

  /** layouts.layout: the description of this layout */
  public String layout = null;

  /** labels a layout for use as class in stylesheet */
  public String label;

  /**
   * Construct a default instance
   */
  public Layout() {
    setDefaults();
  }

  /**
   * Construct given DB connection and an int primary key
   */
  public Layout(DB db, int key) throws SQLException {
    select(db, key);
  }

  /**
   * Construct given servlet context and an int primary key
   */
  public Layout(ServletContext context, int key) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      select(db, key);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Construct given a loaded ResultSet
   */
  protected Layout(ResultSet rs) throws SQLException {
    populate(rs);
  }

  /**
   * Load instance vars from a ResultSet
   */
  protected void populate(ResultSet rs) throws SQLException {
    layout_id = rs.getInt("layout_id");
    layout = rs.getString("layout");
    num = rs.getInt("num");
    label = "l"+num;
  }

  /**
   * Refresh this instance with values from the database record
   */
  protected void refresh(DB db) throws SQLException {
    select(db, layout_id);
  }

  /**
   * Do a SELECT query and set instance variables given a DB connection and a primary key
   */
  protected void select(DB db, int key) throws SQLException {
    db.executeQuery("SELECT * FROM layouts WHERE layout_id="+key);
    if (db.rs.next()) populate(db.rs);
  }

  /**
   * Throw a ValidationException if validation fails
   */
  public void validate() throws ValidationException {
    String message = "";
    if (num<1) message += "You must provide a positive number for this layout. ";
    if (layout==null || layout.trim().length()==0) message += "You must provide a label for this layout. ";
    if (message.length()>0) throw new ValidationException(message);
  }

  /**
   * Insert a new layout.
   */
  protected void insert(DB db) throws SQLException, ValidationException {
    validate();
    db.executeUpdate("INSERT INTO layouts (layout, num) VALUES ("+charsOrNull(layout)+","+intOrNull(num)+")");
    db.executeQuery("SELECT max(layout_id) AS layout_id FROM layouts");
    db.rs.next();
    layout_id = db.rs.getInt("layout_id");
    select(db, layout_id);
  }

  /**
   * Update from instance vars.
   */
  protected void update(DB db) throws SQLException, ValidationException {
    validate();
    db.executeUpdate("Update layouts SET layout="+charsOrNull(layout)+", num="+intOrNull(num)+" WHERE layout_id="+layout_id);
    select(db, layout_id);
  }

  /**
   * Delete a layout.
   */
  protected void delete(DB db) throws SQLException, ValidationException {
    // be sure no pages use this layout
    db.executeQuery("SELECT count(*) AS count FROM pages WHERE layout_id="+layout_id);
    db.rs.next();
    if (db.rs.getInt("count")==0) {
      // child records
      db.executeUpdate("DELETE FROM layoutpanes WHERE layout_id="+layout_id);
      // parent record
      db.executeUpdate("DELETE FROM layouts WHERE layout_id="+layout_id);
      setDefaults();
    } else {
      // get list of pages that use this layout
      String message = "The selected layout is in use on the following pages:";
      db.executeQuery("SELECT pid FROM pages WHERE layout_id="+layout_id+" ORDER BY pid");
      while (db.rs.next()) message += " "+db.rs.getInt("pid");
      message += ". You may not delete a layout that is in use.";
      throw new ValidationException(message);
    }
  }

  /**
   * Set default values when instance does not correspond to a database record (such as after delete() is called
   */
  protected void setDefaults() {
    layout_id = 0;
    layout = null;
    num = 0;
    label = null;
  }

  /**
   * Return true if this is a default, uninstantiated instance
   */
  public boolean isDefault() {
    return layout_id==0;
  }

  /**
   * Insert an audit record for the given action
   */
  protected void audit(DB db, char action, String username) throws SQLException {
    Audit a = new Audit();
    a.tablename = tablename;
    a.record_id = layout_id;
    a.action = action;
    a.username = username;
    a.description = label+": "+layout;
    a.insert(db);
  }

  /**
   * Comparator for sorting, uses num
   */
  public int compareTo(Object o) {
    Layout that = (Layout)o;
    return this.num - that.num;
  }

  /**
   * Return true if same primary key
   */
  public boolean equals(Object o) {
    Layout that = (Layout) o;
    return this.layout_id==that.layout_id;
  }

  // -----------------------------------------------------------------------------------------------------------------------------------------

  /**
   * Return an array of all layouts, sorted by increasing layout_id.
   */
  public static Layout[] getAll(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      db.executeQuery("SELECT count(*) AS count FROM layouts");
      db.rs.next();
      int count = db.rs.getInt("count");
      Layout[] layouts = new Layout[count];
      db.executeQuery("SELECT * FROM layouts ORDER BY num");
      int i = 0;
      while (db.rs.next()) layouts[i++] = new Layout(db.rs);
      return layouts;
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return an array of LayoutPanes for this Layout and the given mobile flag
   */
  public LayoutPane[] getLayoutPanes(DB db, boolean mobile) throws SQLException {
    db.executeQuery("SELECT count(*) AS count FROM layoutpanes WHERE layout_id="+layout_id+" AND mobile="+db.bool(mobile));
    db.rs.next();
    int count = db.rs.getInt("count");
    LayoutPane[] layoutpanes = new LayoutPane[count];
    db.executeQuery("SELECT * FROM layoutpanes WHERE layout_id="+layout_id+" AND mobile="+db.bool(mobile)+" ORDER BY pane");
    int i = 0;
    while (db.rs.next()) layoutpanes[i++] = new LayoutPane(db.rs);
    // labels have to be set with db call
    for (i=0; i<layoutpanes.length; i++) layoutpanes[i].setLabel(db);
    return layoutpanes;
  }

  /**
   * Return an array of LayoutPanes for this Layout and the given mobile flag
   */
  public LayoutPane[] getLayoutPanes(ServletContext context, boolean mobile) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return getLayoutPanes(db, mobile);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Clone a new layout from this layout, changing the number and title.
   */
  public Layout clone(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException, ValidationException {
    DB db = null;
    try {
      db = new DB(context);
      // clone the layout itself
      Layout l = new Layout();
      l.layout = "CLONE OF "+this.layout;
      l.label = this.label;
      db.executeQuery("SELECT max(num) AS num FROM layouts");
      db.rs.next();
      l.num = db.rs.getInt("num") + 1;
      l.insert(db);
      // add the new layout panes
      LayoutPane[] panes = getLayoutPanes(db, false); // original default panes
      for (int i=0; i<panes.length; i++) {
	panes[i].layout_id = l.layout_id;
	// default
	panes[i].mobile = false;
	panes[i].insert(db);
	// mobile
	panes[i].mobile = true;
	panes[i].insert(db);
      }
      // return the cloned layout
      return l;
    } finally {
      if (db!=null) db.close();
    }
  }


}
