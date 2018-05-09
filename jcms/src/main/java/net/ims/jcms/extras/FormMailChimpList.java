package net.ims.jcms.extras;

import net.ims.jcms.*;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.io.FileNotFoundException;
import javax.naming.NamingException;
import javax.servlet.ServletContext;

/**
 * Extends Record to encapsulate a formmailchimplists table record.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class FormMailChimpList extends Record {

  /** the name of the database table, used by audit method */
  private static String tablename = "formmailchimplists";

  /** forms.form_id, foreign key **/
  public int form_id;

  /** formmailchimplists.list_id **/
  public String listid;

  /** formmailchimplists.name, duplicate storage from MailChimp **/
  public String listname;

  /**
   * Constructs a default instance
   */
  public FormMailChimpList() {
    setDefaults();
  }

  /**
   * Constructs given a form_id and link
   */
  public FormMailChimpList(ServletContext context, int form_id, String listid) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
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
  FormMailChimpList(ResultSet rs) throws SQLException {
    populate(rs);
  }

  /**
   * Populate a record given a form_id and listid
   */
  void select(DB db, int form_id, String listid) throws SQLException {
    db.executeQuery("SELECT * FROM formmailchimplists WHERE form_id="+form_id+" AND listid='"+listid+"'");
    if (db.rs.next()) populate(db.rs);
  }

  /**
   * Stub for required Record.select method, throws exception message if used
   */
  protected void select(DB db, int key) throws SQLException {
    throw new SQLException("FormMailChimpList requires both form_id and listid.");
  }

  /**
   * Populate a record from a populated ResultSet
   */
  protected void populate(ResultSet rs) throws SQLException {
    form_id = rs.getInt("form_id");
    listid = rs.getString("listid");
    listname = rs.getString("listname");
  }

  /**
   * Refresh this instance with values from the database record
   */
  protected void refresh(DB db) throws SQLException {
    select(db, form_id, listid);
  }

  /**
   * Insert a new formmailchimplists record
   */
  protected void insert(DB db) throws SQLException, ValidationException {
    validate();
    db.executeUpdate("INSERT INTO formmailchimplists (form_id,listid,listname) VALUES ("+form_id+","+charsOrNull(listid)+","+charsOrNull(listname)+")");
  }

  /**
   * Updates a formmailchimplists record listname
   */
  protected void update(DB db) throws SQLException, ValidationException {
    validate();
    db.executeUpdate("UPDATE formmailchimplists SET listname="+charsOrNull(listname)+" WHERE form_id="+form_id+" AND listid="+charsOrNull(listid));
  }

  /**
   * Throw a ValidationException if fields are invalid.
   */
  void validate() throws ValidationException {
    String error = "";
    if (listid==null || listid.trim().length()==0) error += "MailChimp list id is required. ";
    if (listname==null || listname.trim().length()==0) error += "MailChimp list name is required. ";
    if (error.length()>0) throw new ValidationException(error);
  }

  /**
   * Deletes this record.
   */
  protected void delete(DB db) throws SQLException {
    db.executeUpdate("DELETE FROM formmailchimplists WHERE form_id="+form_id+" AND listid="+charsOrNull(listid));
    setDefaults();
  }

  /**
   * Sets defaults.
   */
  protected void setDefaults() {
    form_id = 0;
    listid = null;
    listname = null;
  }

  /**
   * Return true if this is a default, uninstantiated instance
   */
  public boolean isDefault() {
    return listid==null;
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
    a.description = listname;
    a.insert(db);
  }

  /**
   * Sort alphabetically.
   */
  public int compareTo(Object o) {
    FormMailChimpList that = (FormMailChimpList) o;
    return this.listname.compareTo(that.listname);
  }

  /**
   * Return true if same primary key
   */
  public boolean equals(Object o) {
    FormMailChimpList that = (FormMailChimpList) o;
    return this.listid.equals(that.listid);
  }

  /**
   * Delete all records for the given form id
   */
  public static void deleteAll(ServletContext context, int form_id) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      db.executeUpdate("DELETE FROM formmailchimplists WHERE form_id="+form_id);
    } finally {
      if (db!=null) db.close();
    }
  }

}
