package net.ims.jcms.extras;

import net.ims.jcms.*;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.io.FileNotFoundException;
import javax.naming.NamingException;
import javax.servlet.ServletContext;

/**
 * Extends Record to encapsulate a formicontactlists table record.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class FormiContactList extends Record {

  /** the name of the database table, used by audit method */
  private static String tablename = "formicontactlists";

  /** forms.form_id, foreign key **/
  public int form_id;

  /** formicontactlists.listid **/
  public int listid;

  /** formicontactlists.name, duplicate storage from iContact **/
  public String name;

  /** formicontactlists.description, duplicate storage from iContact **/
  public String description;

  /**
   * Constructs a default instance
   */
  public FormiContactList() {
    setDefaults();
  }

  /**
   * Constructs given a form_id and listid
   */
  public FormiContactList(ServletContext context, int form_id, int listid) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      select(db, form_id, listid);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Constructs given a populated ResultSet.
   */
  FormiContactList(ResultSet rs) throws SQLException {
    populate(rs);
  }

  /**
   * Populate a record given a form_id and listid
   */
  void select(DB db, int form_id, int listid) throws SQLException {
    db.executeQuery("SELECT * FROM formicontactlists WHERE form_id="+form_id+" AND listid="+listid);
    if (db.rs.next()) populate(db.rs);
  }

  /**
   * Stub for required Record.select method, throws exception message if used
   */
  protected void select(DB db, int key) throws SQLException {
    throw new SQLException("FormiContactList requires both form_id and listid.");
  }

  /**

  /**
   * Populate a record from a populated ResultSet
   */
  protected void populate(ResultSet rs) throws SQLException {
    form_id = rs.getInt("form_id");
    listid = rs.getInt("listid");
    name = rs.getString("name");
    description = rs.getString("description");
  }

  /**
   * Refresh this instance with values from the database record
   */
  protected void refresh(DB db) throws SQLException {
    select(db, form_id, listid);
  }

  /**
   * Insert a new formicontactlists record
   */
  protected void insert(DB db) throws SQLException, ValidationException {
    validate();
    db.executeUpdate("INSERT INTO formicontactlists (" +
		     "form_id,listid,name,description" +
		     ") VALUES (" +
		     form_id+","+listid+","+charsOrNull(name)+","+charsOrNull(description) +
		     ")"
		     );
  }

  /**
   * Updates a formicontactlists record with current values.
   */
  protected void update(DB db) throws SQLException, ValidationException {
    validate();
    db.executeUpdate("UPDATE formicontactlists SET "+
		     "name="+charsOrNull(name)+", " +
		     "description="+charsOrNull(description)+" " +
		     "WHERE form_id="+form_id+" AND listid="+listid);
  }

  /**
   * Throw a ValidationException if fields are invalid.
   */
  void validate() throws ValidationException {
    String error = "";
    if (name==null || name.trim().length()==0) error += "List name is required. ";
    if (description==null || description.trim().length()==0) error += "List description is required. ";
    if (error.length()>0) throw new ValidationException(error);
  }

  /**
   * Deletes this record.
   */
  protected void delete(DB db) throws SQLException {
    db.executeUpdate("DELETE FROM formicontactlists WHERE form_id="+form_id+" AND listid="+listid);
    setDefaults();
  }

  /**
   * Sets defaults.
   */
  protected void setDefaults() {
    form_id = 0;
    listid = 0;
    name = null;
    description = null;
  }

  /**
   * Return true if this is a default, uninstantiated instance
   */
  public boolean isDefault() {
    return listid==0;
  }

  /**
   * Insert an audit record for the given action
   */
  protected void audit(DB db, char action, String username) throws SQLException {
    Audit a = new Audit();
    a.tablename = tablename;
    a.record_id = form_id;
    a.action = action;
    a.username = username;
    a.description = name;
    a.insert(db);
  }

  /**
   * Sort alphabetically.
   */
  public int compareTo(Object o) {
    FormiContactList that = (FormiContactList) o;
    return this.name.compareTo(that.name);
  }

  /**
   * Return true if same primary key
   */
  public boolean equals(Object o) {
    FormiContactList that = (FormiContactList) o;
    return this.listid==that.listid;
  }

  /**
   * Delete all records for the given form id
   */
  public static void deleteAll(ServletContext context, int form_id) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      db.executeUpdate("DELETE FROM formicontactlists WHERE form_id="+form_id);
    } finally {
      if (db!=null) db.close();
    }
  }

}

