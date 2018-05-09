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
 * Extends Record to contain the data for a single Layout pane.
 * Provides methods for inserting, updating, deleting, validation, and implements the Comparable interface for sorting.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class LayoutPane extends Record {

  /** the name of the database table, used by audit method */
  private static String tablename = "layoutpanes";

  /** layoutpanes.layoutpane_id: the primary key for this record */
  public int layoutpane_id;

  /** layouts.layout_id: the primary key for the related layout record */
  public int layout_id = 0;

  /** layoutpanes.pane: the number of this pane */
  public int pane = 0;

  /** layoutpanes.vposition: the vertical position of this pane */
  public int vposition = 0;

  /** layoutpanes.hposition: the horizontal position of this pane */
  public int hposition = 0;

  /** layoutpanes.colspan: the columns spanned by this pane */
  public int colspan = 1;

  /** layoutpanes.rowspan: the rows spanned by this pane */
  public int rowspan = 1;

  /** layoutpanes.mobile: the flag indicating if this pane is used for the mobile version of the site */
  public boolean mobile = false;

  /** labels a pane for use as class in stylesheet */
  public String label;

  /**
   * Construct a default instance
   */
  public LayoutPane() {
    setDefaults();
  }

  /**
   * Construct given DB connection and an int primary key
   */
  public LayoutPane(DB db, int key) throws SQLException {
    select(db, key);
  }

  /**
   * Construct given a ServletContext to get DB connection and an int primary key
   */
  public LayoutPane(ServletContext context, int key) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      select(db, key);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Construct given a layout_id, the pane number and the mobile flag
   */
  public LayoutPane(ServletContext context, int layout_id, int pane, boolean mobile) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      select(db, layout_id, pane, mobile);
    } finally {
      if (db!=null) db.close();
    }
  }
    

  /**
   * Construct given a filled ResultSet.  Does NOT set label.
   */
  protected LayoutPane(ResultSet rs) throws SQLException {
    populate(rs);
  }

  /**
   * Set instance variables given a DB connection and a primary key; sets label.
   */
  protected void select(DB db, int key) throws SQLException {
    db.executeQuery("SELECT * FROM layoutpanes WHERE layoutpane_id="+key);
    if (db.rs.next()) {
      populate(db.rs);
      setLabel(db);
    }
  }

  /**
   * Set instance variables given a DB connection and a layout_id, a pane number and the mobile flag
   */
  protected void select(DB db, int layout_id, int pane, boolean mobile) throws SQLException {
    db.executeQuery("SELECT * FROM layoutpanes WHERE layout_id="+layout_id+" AND pane="+pane+" AND mobile="+db.bool(mobile));
    if (db.rs.next()) {
      populate(db.rs);
      setLabel(db);
    }
  }

  /**
   * Set instance variables given a filled ResultSet; does NOT set label!
   */
  protected void populate(ResultSet rs) throws SQLException {
    layoutpane_id = rs.getInt("layoutpane_id");
    layout_id = rs.getInt("layout_id");
    pane = rs.getInt("pane");
    vposition = rs.getInt("vposition");
    hposition = rs.getInt("hposition");
    colspan = rs.getInt("colspan");
    rowspan = rs.getInt("rowspan");
    mobile = rs.getBoolean("mobile");
  }

  /**
   * Refresh this instance with values from the database record
   */
  protected void refresh(DB db) throws SQLException {
    select(db, layoutpane_id);
  }

  /**
   * Throw a ValidationException if validation fails
   */
  public void validate() throws ValidationException {
    String message = "";
    if (pane<1) message += "You must provide a positive number for this layout pane. ";
    if (vposition<1) message += "The vposition (vpos) value must be a positive number. ";
    if (hposition<1) message += "The hposition (hpos) value must be a positive number. ";
    if (colspan<1) message += "The colspan value must be a positive number. ";
    if (rowspan<1) message += "The rowspan value must be a positive number. ";
    if (message.length()>0) throw new ValidationException(message);
  }

  /**
   * Insert a new layoutpanes record with the current instance values.
   */
  protected void insert(DB db) throws SQLException, ValidationException {
    validate();
    String query = "INSERT INTO layoutpanes (" +
      "layout_id, pane, vposition, hposition, colspan, rowspan, mobile" +
      ") VALUES (" +
      intOrNull(layout_id)+", " +
      intOrNull(pane)+", " +
      intOrNull(vposition)+", " +
      intOrNull(hposition)+", " +
      intOrNull(colspan)+", " +
      intOrNull(rowspan)+", " +
      db.bool(mobile) +
      ")";
    db.executeUpdate(query);
    db.executeQuery("SELECT max(layoutpane_id) AS layoutpane_id FROM layoutpanes");
    db.rs.next();
    layoutpane_id = db.rs.getInt("layoutpane_id");
    select(db, layoutpane_id);
  }

  /**
   * Update the database record with the current instance values.
   */
  protected void update(DB db) throws SQLException, ValidationException {
    validate();
    String query = "UPDATE layoutpanes SET " +
      "layout_id="+layout_id+", " +
      "pane="+pane+", " +
      "vposition="+vposition+", " +
      "hposition="+hposition+", " +
      "colspan="+colspan+", " +
      "rowspan="+rowspan+" " +
      "WHERE layoutpane_id="+layoutpane_id;
    db.executeUpdate(query);
  }

  /**
   * Delete this record.
   */
  protected void delete(DB db) throws SQLException, ValidationException {
    // check that no pages are currently using this layout pane
    db.executeQuery("SELECT count(*) AS count FROM pages_content WHERE pane="+pane+" AND pid IN (SELECT pid FROM pages WHERE layout_id="+layout_id+")");
    db.rs.next();
    if (db.rs.getInt("count")>0) throw new ValidationException("The selected pane is in use on one or more pages.  You may not delete a pane that is in use.");
    db.executeUpdate("DELETE FROM layoutpanes WHERE layoutpane_id="+layoutpane_id);
    setDefaults();
  }

  /**
   * Set default values when instance does not correspond to a database record (such as after delete() is called
   */
  protected void setDefaults() {
    layoutpane_id = 0;
    layout_id = 0;
    pane = 0;
    vposition = 0;
    hposition = 0;
    colspan = 1;
    rowspan = 1;
    mobile = false;
    label = null;
  }

  /**
   * Return true if this is a default, uninstantiated instance
   */
  public boolean isDefault() {
    return layoutpane_id==0;
  }

  /**
   * Insert an audit record for the given action
   */
  protected void audit(DB db, char action, String username) throws SQLException {
    Audit a = new Audit();
    a.tablename = tablename;
    a.record_id = layoutpane_id;
    a.action = action;
    a.username = username;
    a.description = "Pane "+pane;
    a.insert(db);
  }

  /**
   * Comparator for sorting, orders by pane
   */
  public int compareTo(Object o) {
    LayoutPane that = (LayoutPane)o;
    return this.pane - that.pane;
  }

  /**
   * Return true if same primary key
   */
  public boolean equals(Object o) {
    LayoutPane that = (LayoutPane) o;
    return this.layoutpane_id==that.layoutpane_id;
  }

  /**
   * Set the stylesheet class label for this pane
   */
  void setLabel(DB db) throws SQLException {
    Layout layout = new Layout(db, layout_id);
    label = "l"+layout.num+"_p"+pane;
  }

}
