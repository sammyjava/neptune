package net.ims.jcms;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.io.FileNotFoundException;
import java.io.IOException;
import javax.naming.NamingException;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpSession;

/**
 * Stylesheet records.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class Stylesheet extends Record {

  /** the name of the database table, used by audit method */
  private static String tablename = "stylesheet";

  /** stylesheet.class_id, primary key **/
  public int id = 0;

  /** stylesheet.num **/
  public int num = 0;

  /** stylesheet.class_name **/
  public String name = null;

  /** stylesheet.class_value **/
  public String value = null;

  /** stylesheet.required **/
  public boolean required = false;

  /** stylesheet.level = node level to which this class corresponds **/
  public int level = 0;

  /** stylesheet.level_num = num of the node record to which this class corresponds **/
  public int level_num = 0;

  /** stylesheet.stylesheetcategory_id = reference to stylesheetcategories primary key **/
  public int stylesheetcategory_id = 0;

  /**
   * Construct an empty record
   */
  public Stylesheet() {
  }

  /**
   * Construct given a populated ResultSet.
   */
  Stylesheet(ResultSet rs) throws SQLException {
    populate(rs);
  }

  /**
   * Construct given a primary key.
   */
  Stylesheet(DB db, int key) throws SQLException {
    select(db, key);
  }

  /**
   * Construct given a primary key.
   */
  public Stylesheet(ServletContext context, int key) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      select(db, key);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Construct given a class name, node level and level number
   */
  public Stylesheet(ServletContext context, String name, int level, int level_num) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      select(db, name, level, level_num);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Populate this instance from a populated ResultSet.
   */
  protected void populate(ResultSet rs) throws SQLException {
    id = rs.getInt("class_id");
    name = rs.getString("class_name");
    value = rs.getString("class_value");
    num = rs.getInt("num");
    level = rs.getInt("level");
    level_num = rs.getInt("level_num");
    stylesheetcategory_id = rs.getInt("stylesheetcategory_id");
    required = rs.getBoolean("required");
  }

  /**
   * Refresh this instance with values from the database record
   */
  protected void refresh(DB db) throws SQLException {
    select(db, id);
  }

  /**
   * Select a record given a key
   */
  protected void select(DB db, int key) throws SQLException {
    db.executeQuery("SELECT * FROM stylesheet WHERE class_id="+key);
    if (db.rs.next()) populate(db.rs);
  }

  /**
   * Select a record given a class name, node level and level number
   */
  void select(DB db, String name, int level, int level_num) throws SQLException {
    db.executeQuery("SELECT * FROM stylesheet WHERE class_name='"+name+"' AND level="+level+" AND level_num="+level_num);
    if (db.rs.next()) id = db.rs.getInt("class_id");
    select(db, id);
  }

  /**
   * Insert a stylesheet record with current values.  Get id by querying back matching data.
   */
  protected void insert(DB db) throws SQLException, ValidationException {
    // validation
    if (name==null || name.trim().equals("")) throw new ValidationException("You must supply a class name.");
    if (value==null) throw new ValidationException("Class value cannot be null.");
    // insert
    String query = "INSERT INTO stylesheet ("+
      "class_name,class_value,num,level,level_num,stylesheetcategory_id,required"+
      ") VALUES ("+
      charsOrNull(name)+"," +
      charsOrEmpty(value)+", " +
      num+", " +
      level+", " +
      level_num+", " +
      stylesheetcategory_id+", " +
      db.bool(required) +
      ")";
    db.executeUpdate(query);
    // get id
    query = "SELECT class_id FROM stylesheet WHERE " +
      "class_name="+charsOrNull(name)+" AND " +
      "class_value="+charsOrEmpty(value)+" AND " +
      "num="+num+" AND " +
      "level="+level+" AND " +
      "level_num="+level_num+" AND " +
      "stylesheetcategory_id="+stylesheetcategory_id+" AND " +
      "required="+db.bool(required);
    db.executeQuery(query);
    if (db.rs.next()) {
      id = db.rs.getInt("class_id");
    }
  }

  /**
   * Update a stylesheet record with current values.
   */
  protected void update(DB db) throws SQLException {
    String query = "UPDATE stylesheet SET "+
      "class_name="+charsOrNull(name)+", "+
      "class_value="+charsOrEmpty(value)+", "+
      "num="+num+", "+
      "level="+level+","+
      "level_num="+level_num+"," +
      "stylesheetcategory_id="+stylesheetcategory_id+"," +
      "required="+db.bool(required)+" "+
      "WHERE class_id="+id;
    db.executeUpdate(query);
  }

  /**
   * Delete this record.
   */
  protected void delete(DB db) throws SQLException {
    db.executeUpdate("DELETE FROM stylesheet WHERE class_id="+id);
    setDefaults();
  }

  /**
   * Set default values.
   */
  protected void setDefaults() {
    id = 0;
    num = 0;
    level = 0;
    level_num = 0;
    stylesheetcategory_id = 0;
    name = null;
    value = null;
    required = false;
  }

  /**
   * Return true if this is a default, uninstantiated instance
   */
  public boolean isDefault() {
    return id==0;
  }

  /**
   * Insert an audit record for the given action
   */
  protected void audit(DB db, char action, String username) throws SQLException {
    Audit a = new Audit();
    a.tablename = tablename;
    a.record_id = id;
    a.action = action;
    a.username = username;
    a.description = level_num+" "+name;
    a.insert(db);
  }

  /**
   * Order is based on num value (ignoring level and level_num)
   */
  public int compareTo(Object o) {
    Stylesheet that = (Stylesheet)o;
    return (this.num - that.num);
  }

  /**
   * Return true if same primary key
   */
  public boolean equals(Object o) {
    Stylesheet that = (Stylesheet) o;
    return this.id==that.id;
  }

  ////////////////////////////////////////////////////////////////////////////////////////////

  /**
   * Return an array of all stylesheet records for a given level and level_num, ordered by num.
   */
  public static Stylesheet[] getAll(ServletContext context, int level, int level_num) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      db.executeQuery("SELECT count(*) AS count FROM stylesheet WHERE level="+level+" AND level_num="+level_num);
      db.rs.next();
      int count = db.rs.getInt("count");
      Stylesheet[] s = new Stylesheet[count];
      db.executeQuery("SELECT * FROM stylesheet WHERE level="+level+" AND level_num="+level_num+" ORDER BY stylesheetcategory_id, num, class_name");
      int i = 0;
      while (db.rs.next()) s[i++] = new Stylesheet(db.rs);
      return s;
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return an array of all stylesheet records for a given level, level_num and stylesheetcategory_id, ordered by num, then alpha.
   */
  public static Stylesheet[] getAll(ServletContext context, int level, int level_num, int stylesheetcategory_id) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      db.executeQuery("SELECT count(*) AS count FROM stylesheet WHERE level="+level+" AND level_num="+level_num+" AND stylesheetcategory_id="+stylesheetcategory_id);
      db.rs.next();
      int count = db.rs.getInt("count");
      Stylesheet[] s = new Stylesheet[count];
      db.executeQuery("SELECT * FROM stylesheet WHERE level="+level+" AND level_num="+level_num+" AND stylesheetcategory_id="+stylesheetcategory_id+" ORDER BY num, class_name");
      int i = 0;
      while (db.rs.next()) s[i++] = new Stylesheet(db.rs);
      return s;
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return an array of stylesheet records for which class name matches the provided string.
   */
  public static Stylesheet[] getMatching(ServletContext context, String search) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      db.executeQuery("SELECT count(*) AS count FROM stylesheet WHERE class_name ILIKE '%"+search+"%'");
      db.rs.next();
      int count = db.rs.getInt("count");
      Stylesheet[] s = new Stylesheet[count];
      db.executeQuery("SELECT * FROM stylesheet WHERE class_name ILIKE '%"+search+"%' ORDER BY class_name, stylesheetcategory_id, level, level_num");
      int i = 0;
      while (db.rs.next()) s[i++] = new Stylesheet(db.rs);
      return s;
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Remove all of the classes associated with the given layout
   */
  public static void removeLayout(ServletContext context, Layout layout) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      db.executeUpdate("DELETE FROM stylesheet WHERE class_name='table#"+layout.label+"'");
      db.executeUpdate("DELETE FROM stylesheet WHERE class_name LIKE 'td#"+layout.label+"_%'");
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Remove all of the classes associated with the given layout pane
   */
  public static void removeLayoutPane(ServletContext context, LayoutPane pane) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      db.executeUpdate("DELETE FROM stylesheet WHERE class_name='td#"+pane.label+"'");
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Add layout table classes to the stylesheets, don't throw exception if SQL error, may simply be duplicate records
   */
  public static void addLayout(ServletContext context, Layout layout) throws ValidationException, IOException, SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    Stylesheet s = new Stylesheet();
    s.name = "table#"+layout.label;
    s.value = "";
    s.num = layout.num*10;
    s.required = true;
    s.stylesheetcategory_id = 9; // layouts
    // default
    s.level = 0;
    s.level_num = 0;
    try {
      s.insert(context);
    } catch (SQLException ex) {
    }
    // printable
    s.level = 1;
    s.level_num = -1;
    try {
      s.insert(context);
    } catch (SQLException ex) {
    }
    // mobile
    s.level = 1;
    s.level_num = -3;
    try {
      s.insert(context);
    } catch (SQLException ex) {
    }
  }

  /**
   * Add layout pane classes to the stylesheets; don't throw exception if SQL error, may simply be duplicate records
   */
  public static void addLayoutPane(ServletContext context, LayoutPane pane) throws ValidationException, IOException, SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    Layout layout = new Layout(context, pane.layout_id);
    Stylesheet s = new Stylesheet();
    s.name = "td#"+pane.label;
    s.value = "";
    s.num = layout.num*10 + pane.pane;
    s.required = true;
    s.stylesheetcategory_id = 9; // layouts
    // default
    s.level = 0;
    s.level_num = 0;
    try {
      s.insert(context);
    } catch (SQLException ex) {
    }
    // printable
    s.level = 1;
    s.level_num = -1;
    try {
      s.insert(context);
    } catch (SQLException ex) {
    }
    // mobile
    s.level = 1;
    s.level_num = -3;
    try {
      s.insert(context);
    } catch (SQLException ex) {
    }
  }

}

