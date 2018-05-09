package net.ims.jcms.extras;

import net.ims.jcms.*;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.io.FileNotFoundException;
import javax.naming.NamingException;
import javax.servlet.ServletContext;

/**
 * Extends Record to encapsulate a formlyrislists table record.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class FormLyrisList extends Record {

  /** the name of the database table, used by audit method */
  private static String tablename = "formlyrislists";

  /** formlyrislists.formlyrislist_id, primary key **/
  public int formlyrislist_id = 0;

  /** forms.form_id, foreign key **/
  public int form_id = 0;

  /** formlyrislists.listname **/
  public String listname = null;

  /** formlyrislists.num **/
  public int num = 0;

  /** formlyrislists.description **/
  public String description = null;

  /**
   * Constructs a default instance
   */
  public FormLyrisList() {
    setDefaults();
  }

  /**
   * Constructs given a primary key.
   */
  public FormLyrisList(ServletContext context, int key) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      select(db, key);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Constructs given a primary key.
   */
  FormLyrisList(DB db, int key) throws SQLException {
    select(db, key);
  }

  /**
   * Constructs given a populated ResultSet.
   */
  FormLyrisList(ResultSet rs) throws SQLException {
    populate(rs);
  }

  /**
   * Populate a record given a key
   */
  protected void select(DB db, int key) throws SQLException {
    db.executeQuery("SELECT * FROM formlyrislists WHERE formlyrislist_id="+key);
    if (db.rs.next()) populate(db.rs);
  }

  /**
   * Populate a record from a populated ResultSet
   */
  protected void populate(ResultSet rs) throws SQLException {
    formlyrislist_id = rs.getInt("formlyrislist_id");
    form_id = rs.getInt("form_id");
    num = rs.getInt("num");
    listname = rs.getString("listname");
    description = rs.getString("description");
  }

  /**
   * Refresh this instance with values from the database record
   */
  protected void refresh(DB db) throws SQLException {
    select(db, formlyrislist_id);
  }

  /**
   * Insert a new formlyrislists record
   */
  protected void insert(DB db) throws SQLException, ValidationException {
    validate();
    db.executeUpdate("INSERT INTO formlyrislists (" +
		     "form_id,num,listname,description" +
		     ") VALUES (" +
		     form_id+","+num+","+charsOrNull(listname)+","+charsOrNull(description) +
		     ")"
		     );
  }

  /**
   * Updates a formlyrislists record with current values.
   */
  protected void update(DB db) throws SQLException, ValidationException {
    validate();
    db.executeUpdate("UPDATE formlyrislists SET "+
		     "num="+intOrNull(num)+", " +
		     "listname="+charsOrNull(listname)+", " +
		     "description="+charsOrNull(description)+" " +
		     "WHERE formlyrislist_id="+formlyrislist_id);
  }

  /**
   * Throw a ValidationException if fields are invalid.
   */
  void validate() throws ValidationException {
    String error = "";
    if (num==0) error += "Num must be 1 or larger. ";
    if (listname==null || listname.trim().length()==0) error += "List name is required. ";
    if (description==null || description.trim().length()==0) error += "List description is required. ";
    if (error.length()>0) throw new ValidationException(error);
  }

  /**
   * Deletes this record.
   */
  protected void delete(DB db) throws SQLException {
    db.executeUpdate("DELETE FROM formlyrislists WHERE formlyrislist_id="+formlyrislist_id);
    setDefaults();
  }

  /**
   * Sets defaults.
   */
  protected void setDefaults() {
    form_id = 0;
    formlyrislist_id = 0;
    num = 1;
    listname = null;
    description = null;
  }

  /**
   * Return true if this is a default, uninstantiated instance
   */
  public boolean isDefault() {
    return formlyrislist_id==0;
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
    FormLyrisList that = (FormLyrisList) o;
    return this.listname.compareTo(that.listname);
  }

  /**
   * Return true if same primary key
   */
  public boolean equals(Object o) {
    FormLyrisList that = (FormLyrisList) o;
    return this.formlyrislist_id==that.formlyrislist_id;
  }

}

