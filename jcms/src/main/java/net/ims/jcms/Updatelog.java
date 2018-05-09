package net.ims.jcms;

import java.util.ArrayList;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.io.FileNotFoundException;

import javax.naming.NamingException;
import javax.servlet.ServletContext;

/**
 * Contains static methods for retrieving updatelog records.
 * Updates to database, etc., should be logged by inserting records into updatelog.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class Updatelog {

  public Timestamp updated;
  public String name;
  public String value;

  /** Empty constructor */
  Updatelog() {
  }

  /** ResultSet constructor */
  Updatelog(ResultSet rs) throws SQLException {
    populate(rs);
  }

  /**
   * Populate fields from a ResultSet
   */
  void populate(ResultSet rs) throws SQLException {
    updated = rs.getTimestamp("updated");
    name = rs.getString("name");
    value = rs.getString("value");
  }

  /**
   * Return the most recent record for the given name.
   */
  static Updatelog getLast(DB db, String name) throws SQLException {
    db.executeQuery("SELECT * FROM updatelog WHERE name='"+name+"' ORDER BY updated DESC");
    if (db.rs.next()) {
      return new Updatelog(db.rs);
    } else {
      return new Updatelog();
    }
  }

  /**
   * Return the most recent record for the given name.
   */
  public static Updatelog getLast(ServletContext context, String name) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return getLast(db, name);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return the current DB version.
   */
  public static String getDBVersion(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      db.executeQuery("SELECT max(value) AS version FROM updatelog WHERE name='db_version'");
      db.rs.next();
      return db.rs.getString("version");
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return an array of instances for the given name, most recent first.
   */
  static Updatelog[] getAll(DB db, String name) throws SQLException {
    ArrayList<Updatelog> list = new ArrayList<Updatelog>();
    db.executeQuery("SELECT * FROM updatelog WHERE name='"+name+"' ORDER BY updated DESC");
    while (db.rs.next()) list.add(new Updatelog(db.rs));
    return list.toArray(new Updatelog[0]);
  }

  /**
   * Return an array of instances for the given name, most recent first.
   */
  public static Updatelog[] getAll(ServletContext context, String name) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return getAll(db, name);
    } finally {
      if (db!=null) db.close();
    }
  }

}
