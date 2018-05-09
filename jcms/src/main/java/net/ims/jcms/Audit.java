package net.ims.jcms;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.io.FileNotFoundException;
import javax.naming.NamingException;
import javax.servlet.ServletContext;

/**
 * Extends Record to contain the data for a single audit record.
 * Provides methods for inserting, and implements the Comparable interface for sorting.
 * One may not update or delete an audit record.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class Audit extends Record {

  /** audit.audit_id: the primary key for this record */
  public int audit_id;

  /** audit.timestamp: the time that the audit record was inserted */
  public Timestamp timestamp;

  /** audit.tablename: the name of the table that was updated */
  public String tablename;

  /** audit.record_id: the primary record_id of the record in the table that was updated */
  public int record_id;

  /** audit.action: the SQL action that was done on the record in the table: I=insert, U=update, D=delete */
  public char action;

  /** audit.username: the username address identifying the person that did the update, from their Users record */
  public String username;

  /** audit.description: a user-friendly description of the record that was updated */
  public String description;

  /**
   * Construct empty Audit instance with default values
   */
  public Audit() {
    setDefaults();
  }

  /**
   * Construct given a Servlet context and primary record_id
   */
  public Audit(ServletContext context, int audit_id) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      select(db, audit_id);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Construct given a populated ResultSet
   */
  Audit(ResultSet rs) throws SQLException {
    populate(rs);
  }

  /**
   * Set default values.
   */
  protected void setDefaults() {
    audit_id = 0;
    timestamp = null;
    tablename = null;
    record_id = 0;
    action = '\0';
    username = null;
    description = null;
  }

  /**
   * Return true if this is a default, uninstantiated instance
   */
  public boolean isDefault() {
    return audit_id==0;
  }

  /**
   * No auditing done for this class! (That would be weird.)
   */
  protected void audit(DB db, char action, String username) {
  }

  /**
   * Populate an instance given a populated ResultSet.
   */
  protected void populate(ResultSet rs) throws SQLException {
    audit_id = rs.getInt("audit_id");
    timestamp = rs.getTimestamp("timestamp");
    tablename = rs.getString("tablename");
    record_id = rs.getInt("record_id");
    action = rs.getString("action").charAt(0);
    username = rs.getString("username");
    description = rs.getString("description");
  }

  /**
   * Refresh this instance with values from the database record
   */
  protected void refresh(DB db) throws SQLException {
    select(db, audit_id);
  }

  /**
   * Do a SELECT query and set instance variables given a DB connection and a primary record_id
   */
  protected void select(DB db, int audit_id) throws SQLException {
    db.executeQuery("SELECT * FROM audit WHERE audit_id="+audit_id);
    if (db.rs.next()) populate(db.rs);
  }

  /**
   * Insert a new audit record into the database. Does NOT retrieve audit_id after insert!
   */
  public void insert(DB db) throws SQLException {
    String query = "INSERT INTO audit (" +
      "tablename, record_id, action, username, description" +
      ") VALUES (" +
      charsOrNull(tablename)+"," +
      record_id+"," +
      charOrNull(action)+"," +
      charsOrNull(username)+"," +
      charsOrNull(description) +
      ")";
    db.executeUpdate(query);
  }

  /**
   * Does nothing; update of audit records is not allowed.
   */
  protected void update(DB db) throws SQLException {
  }

  /**
   * Does nothing; deletion of audit records is not allowed.
   */
  protected void delete(DB db) throws SQLException, ValidationException {
  }

  /**
   * Comparator for sorting by increasing audit_id (time);
   */
  public int compareTo(Object o) {
    Audit that = (Audit)o;
    return (this.audit_id - that.audit_id);
  }

  /**
   * Return true if same primary key
   */
  public boolean equals(Object o) {
    Audit that = (Audit) o;
    return this.audit_id==that.audit_id;
  }

  /**
   * Returns all audit records, ordered by increasing audit_id (time).
   */
  static Audit[] getAll(DB db) throws SQLException {
    db.executeQuery("SELECT count(*) AS count FROM audit");
    db.rs.next();
    int count = db.rs.getInt("count");
    Audit[] all = new Audit[count];
    int i = 0;
    db.executeQuery("SELECT * FROM audit ORDER BY audit_id");
    while (db.rs.next()) all[i++] = new Audit(db.rs);
    return all;
  }

  /**
   * Returns all audit records, ordered by increasing audit_id (time).
   */
  public static Audit[] getAll(ServletContext context) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return getAll(db);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Returns all audit records for a given tablename, ordered by increasing audit_id (time).
   */
  static Audit[] getAllByTable(DB db, String tablename) throws SQLException {
    db.executeQuery("SELECT count(*) AS count FROM audit WHERE tablename='"+tablename+"'");
    db.rs.next();
    int count = db.rs.getInt("count");
    Audit[] all = new Audit[count];
    int i = 0;
    db.executeQuery("SELECT * FROM audit WHERE tablename='"+tablename+"' ORDER BY audit_id DESC");
    while (db.rs.next()) all[i++] = new Audit(db.rs);
    return all;
  }

  /**
   * Returns all audit records for a given tablename, ordered by increasing audit_id (time).
   */
  public static Audit[] getAllByTable(ServletContext context, String tablename) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return getAllByTable(db, tablename);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Returns all audit records for a given username, ordered by increasing audit_id (time).
   */
  static Audit[] getAllByUsername(DB db, String username) throws SQLException {
    db.executeQuery("SELECT count(*) AS count FROM audit WHERE username='"+username+"'");
    db.rs.next();
    int count = db.rs.getInt("count");
    Audit[] all = new Audit[count];
    int i = 0;
    db.executeQuery("SELECT * FROM audit WHERE username='"+username+"' ORDER BY audit_id DESC");
    while (db.rs.next()) all[i++] = new Audit(db.rs);
    return all;
  }

  /**
   * Returns all audit records for a given username, ordered by increasing audit_id (time).
   */
  public static Audit[] getAllByUsername(ServletContext context, String username) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return getAllByUsername(db, username);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Returns all audit records for a given tablename and username, ordered by decreasing audit_id (time).
   */
  static Audit[] getAllByTableAndUsername(DB db, String tablename, String username) throws SQLException {
    db.executeQuery("SELECT count(*) AS count FROM audit WHERE tablename='"+tablename+"' AND username='"+username+"'");
    db.rs.next();
    int count = db.rs.getInt("count");
    Audit[] all = new Audit[count];
    int i = 0;
    db.executeQuery("SELECT * FROM audit WHERE tablename='"+tablename+"' AND username='"+username+"' ORDER BY audit_id DESC");
    while (db.rs.next()) all[i++] = new Audit(db.rs);
    return all;
  }

  /**
   * Returns all audit records for a given username, ordered by increasing audit_id (time).
   */
  public static Audit[] getAllByTableAndUsername(ServletContext context, String tablename, String username) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return getAllByTableAndUsername(db, tablename, username);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return an array of table names, alpha sorted.
   */
  static String[] getTableNames(DB db) throws SQLException {
    db.executeQuery("SELECT count(DISTINCT tablename) AS count FROM audit");
    db.rs.next();
    int count = db.rs.getInt("count");
    String[] tableNames = new String[count];
    int i = 0;
    db.executeQuery("SELECT DISTINCT tablename FROM audit ORDER BY tablename");
    while (db.rs.next()) tableNames[i++] = db.rs.getString("tablename");
    return tableNames;
  }

  /**
   * Return an array of table names, alpha sorted.
   */
  public static String[] getTableNames(ServletContext context) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return getTableNames(db);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return an array of usernames, alpha sorted.
   */
  static String[] getUsernames(DB db) throws SQLException {
    db.executeQuery("SELECT count(DISTINCT username) AS count FROM audit");
    db.rs.next();
    int count = db.rs.getInt("count");
    String[] usernames = new String[count];
    int i = 0;
    db.executeQuery("SELECT DISTINCT username FROM audit ORDER BY username");
    while (db.rs.next()) usernames[i++] = db.rs.getString("username");
    return usernames;
  }

  /**
   * Return an array of usernames, alpha sorted.
   */
  public static String[] getUsernames(ServletContext context) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return getUsernames(db);
    } finally {
      if (db!=null) db.close();
    }
  }

    


}

