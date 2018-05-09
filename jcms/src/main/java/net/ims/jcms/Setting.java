package net.ims.jcms;

import java.io.FileNotFoundException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.TreeMap;
import javax.naming.NamingException;
import javax.servlet.ServletContext;

/**
 * Settings table records.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class Setting extends Record {

  /** the name of the database table, used by audit method */
  private static String tablename = "settings";

  /** settings.setting_id, primary key **/
  public int id = 0;

  /** settings.setting_name **/
  public String name = null;

  /** settings.setting_value **/
  public String value = null;

  /** settings.description **/
  public String description = null;

  /** settings.password - flags whether this setting is a password **/
  boolean password = false;

  /** settings.toggle - flags whether this setting is a true/false toggle **/
  boolean toggle = false;

  /**
   * Constructs an empty record
   */
  public Setting() {
  }

  /**
   * Constructs given a primary key.
   */
  Setting(DB db, int key) throws SQLException {
    select(db, key);
  }

  /**
   * Constructs given a primary key.
   */
  public Setting(ServletContext context, int key) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      select(db, key);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Constructs given a DB instance and setting name.
   */
  Setting(DB db, String settingName) throws SQLException {
    select(db, settingName);
  }

  /**
   * Constructs given a ServletContext and setting name.
   */
  public Setting(ServletContext context, String settingName) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      select(db, settingName);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Construct given a populated ResultSet.
   */
  Setting(ResultSet rs) throws SQLException {
    populate(rs);
  }

  /**
   * Populate this instance given a populated ResultSet.
   */
  protected void populate(ResultSet rs) throws SQLException {
    id = rs.getInt("setting_id");
    name = rs.getString("setting_name");
    value = rs.getString("setting_value");
    description = rs.getString("description");
    password = rs.getBoolean("password");
    toggle = rs.getBoolean("toggle");
  }

  /**
   * Refresh this instance with values from the database record
   */
  protected void refresh(DB db) throws SQLException {
    select(db, id);
  }

  /**
   * Selects a record given a key
   */
  protected void select(DB db, int key) throws SQLException {
    db.executeQuery("SELECT * FROM settings WHERE setting_id="+key);
    if (db.rs.next()) populate(db.rs);
  }

  /**
   * Selects a record given a setting name
   */
  void select(DB db, String settingName) throws SQLException {
    db.executeQuery("SELECT * FROM settings WHERE setting_name="+charsOrNull(settingName));
    if (db.rs.next()) {
      id = db.rs.getInt("setting_id");
      name = db.rs.getString("setting_name");
      value = db.rs.getString("setting_value");
      description = db.rs.getString("description");
      password = db.rs.getBoolean("password");
      toggle = db.rs.getBoolean("toggle");
    }
  }

  /**
   * Can't use API to insert a setting
   */
  protected void insert(DB db) throws SQLException {
  }

  /**
   * Updates a settings record with current values; empty string is acceptable value.
   */
  protected void update(DB db) throws SQLException {
    // handle toggles from empty checkboxes
    if (isToggle() && value==null) value = "false";
    db.executeUpdate("UPDATE settings SET "+
		     "setting_name="+charsOrNull(name)+", "+
		     "setting_value="+charsOrEmpty(value)+" "+
		     "WHERE setting_id="+id);
  }

  /**
   * Deletes this record.
   */
  protected void delete(DB db) throws SQLException {
    db.executeUpdate("DELETE FROM settings WHERE setting_id="+id);
    setDefaults();
  }

  /**
   * Sets default values.
   */
  protected void setDefaults() {
    id = 0;
    name = null;
    value = null;
    description = null;
    password = false;
    toggle = false;
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
    a.description = name;
    a.insert(db);
  }

  /**
   * Return order based on name alpha sorting.
   */
  public int compareTo(Object o) {
    Setting that = (Setting) o;
    return this.name.compareTo(that.name);
  }

  /**
   * Return true if same primary key
   */
  public boolean equals(Object o) {
    Setting that = (Setting) o;
    return this.id==that.id;
  }

  /**
   * Return true if this setting is a password.
   */
  public boolean isPassword() {
    return password;
  }

  /**
   * Return true if this setting is a toggle.
   */
  public boolean isToggle() {
    return toggle;
  }

  /**
   * Return true if this setting is a toggle, and is toggled "on".  Otherwise, false.
   */
  public boolean isOn() {
    return (isToggle() && value.equals("true"));
  }

  /**
   * Return true if this setting is a toggle, and is toggled "on".  Otherwise, false.
   */
  static boolean isOn(DB db, String name) throws SQLException {
    db.executeQuery("SELECT * FROM settings WHERE setting_name='"+name+"'");
    if (db.rs.next()) {
      return db.rs.getBoolean("setting_value");
    } else {
      return false;
    }
  }

  /**
   * Return true if this setting is a toggle, and is toggled "on".  Otherwise, false.
   */
  public static boolean isOn(ServletContext context, String name) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return isOn(db, name);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return a setting String value for a given setting name.  Deprecated, use getString().
   * @deprecated
   */
  public static String getValue(DB db, String name) throws SQLException {
    db.executeQuery("SELECT * FROM settings WHERE setting_name='"+name+"'");
    if (db.rs.next()) {
      return db.rs.getString("setting_value").trim();
    } else {
      return null;
    }
  }

  /**
   * Return a setting String value for a given setting name.  Deprecated, use getString().
   * @deprecated
   */
  public static String getValue(ServletContext context, String name) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return getString(db, name);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return a setting String value for a given setting name
   */
  public static String getString(DB db, String name) throws SQLException {
    db.executeQuery("SELECT * FROM settings WHERE setting_name='"+name+"'");
    if (db.rs.next()) {
      return db.rs.getString("setting_value").trim();
    } else {
      return null;
    }
  }

  /**
   * Return a setting String value for a given setting name.
   */
  public static String getString(ServletContext context, String name) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return getString(db, name);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return a setting int value for a given setting name, or zero if empty
   */
  public static int getInt(ServletContext context, String name) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    String s = getString(context, name);
    if (s!=null && s.length()>0) {
      return Integer.parseInt(s);
    } else {
      return 0;
    }
  }

  /**
   * Return a setting boolean value for a given setting name, true iff setting="true", false otherwise
   */
  public static boolean getBoolean(ServletContext context, String name) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    String s = getString(context, name);
    if (s!=null && s.length()>0) {
      return s.equals("true");
    } else {
      return false;
    }
  }

  /**
   * Return an array of all settings records, ordered by name alphabetically.
   */
  static Setting[] getAll(DB db) throws SQLException {
    db.executeQuery("SELECT count(*) AS count FROM settings");
    db.rs.next();
    int count = db.rs.getInt("count");
    if (count==0) {
      return null;
    } else {
      Setting[] s = new Setting[count];
      db.executeQuery("SELECT * FROM settings ORDER BY setting_name");
      int i = 0;
      while (db.rs.next()) s[i++] = new Setting(db.rs);
      return s;
    }
  }

  /**
   * Return an array of all settings records, ordered by name alphabetically.
   */
  public static Setting[] getAll(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return getAll(db);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return a TreeMap of name/value pairs.
   */
  static TreeMap getTreeMap(DB db) throws SQLException {
    TreeMap<String,String> tm = new TreeMap<String,String>();
    db.executeQuery("SELECT setting_name,setting_value FROM settings ORDER BY setting_name");
    while (db.rs.next()) {
      tm.put(db.rs.getString("setting_name"), db.rs.getString("setting_value").trim());
    }
    return tm;
  }

  /**
   * Return a TreeMap of name/value pairs.
   */
  public static TreeMap getTreeMap(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return getTreeMap(db);
    } finally {
      if (db!=null) db.close();
    }
  }

}

