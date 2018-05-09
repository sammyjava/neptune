package net.ims.jcms.extras;

import net.ims.jcms.*;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.io.FileNotFoundException;
import javax.naming.NamingException;
import javax.servlet.ServletContext;

/**
 * Extends Record to encapsulate a formconstantcontactlists table record.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class FormConstantContactList extends Record {

  /** the name of the database table, used by audit method */
  private static String tablename = "formconstantcontactlists";

  /** forms.form_id, foreign key **/
  public int form_id;

  /** formconstantcontactlists.list **/
  public String link;

  /** formconstantcontactlists.name, duplicate storage from ConstantContact **/
  public String name;

  /**
   * Constructs a default instance
   */
  public FormConstantContactList() {
    setDefaults();
  }

  /**
   * Constructs given a form_id and link
   */
  public FormConstantContactList(ServletContext context, int form_id, String link) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      select(db, form_id, link);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Constructs given a populated ResultSet.
   */
  FormConstantContactList(ResultSet rs) throws SQLException {
    populate(rs);
  }

  /**
   * Populate a record given a form_id and link
   */
  void select(DB db, int form_id, String link) throws SQLException {
    db.executeQuery("SELECT * FROM formconstantcontactlists WHERE form_id="+form_id+" AND link='"+link+"'");
    if (db.rs.next()) populate(db.rs);
  }

  /**
   * Stub for required Record.select method, throws exception message if used
   */
  protected void select(DB db, int key) throws SQLException {
    throw new SQLException("FormConstantContactList requires both form_id and link.");
  }

  /**
   * Populate a record from a populated ResultSet
   */
  protected void populate(ResultSet rs) throws SQLException {
    form_id = rs.getInt("form_id");
    link = rs.getString("link");
    name = rs.getString("name");
  }

  /**
   * Refresh this instance with values from the database record
   */
  protected void refresh(DB db) throws SQLException {
    select(db, form_id, link);
  }

  /**
   * Insert a new formconstantcontactlists record
   */
  protected void insert(DB db) throws SQLException, ValidationException {
    validate();
    db.executeUpdate("INSERT INTO formconstantcontactlists (" +
		     "form_id,link,name" +
		     ") VALUES (" +
		     form_id+","+charsOrNull(link)+","+charsOrNull(name) +
		     ")"
		     );
  }

  /**
   * Updates a formconstantcontactlists record with current values.
   */
  protected void update(DB db) throws SQLException, ValidationException {
    validate();
    db.executeUpdate("UPDATE formconstantcontactlists SET "+
		     "name="+charsOrNull(name)+", " +
		     "WHERE form_id="+form_id+" AND link="+charsOrNull(link));
  }

  /**
   * Throw a ValidationException if fields are invalid.
   */
  void validate() throws ValidationException {
    String error = "";
    if (link==null || link.trim().length()==0) error += "List link is required. ";
    if (name==null || name.trim().length()==0) error += "List name is required. ";
    if (error.length()>0) throw new ValidationException(error);
  }

  /**
   * Deletes this record.
   */
  protected void delete(DB db) throws SQLException {
    db.executeUpdate("DELETE FROM formconstantcontactlists WHERE form_id="+form_id+" AND link="+charsOrNull(link));
    setDefaults();
  }

  /**
   * Sets defaults.
   */
  protected void setDefaults() {
    form_id = 0;
    link = null;
    name = null;
  }

  /**
   * Return true if this is a default, uninstantiated instance
   */
  public boolean isDefault() {
    return link==null;
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
    FormConstantContactList that = (FormConstantContactList) o;
    return this.name.compareTo(that.name);
  }

  /**
   * Return true if same primary key
   */
  public boolean equals(Object o) {
    FormConstantContactList that = (FormConstantContactList) o;
    return this.link.equals(that.link);
  }

  /**
   * Delete all records for the given form id
   */
  public static void deleteAll(ServletContext context, int form_id) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      db.executeUpdate("DELETE FROM formconstantcontactlists WHERE form_id="+form_id);
    } finally {
      if (db!=null) db.close();
    }
  }

}
