package net.ims.jcms.extras;

import net.ims.jcms.*;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.io.FileNotFoundException;
import javax.naming.NamingException;
import javax.servlet.ServletContext;

/**
 * Extends Record to encapsulate a postedformfields table record.
 * Note: this table does NOT have a primary key.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class PostedFormField extends Record {

  /** the name of the database table, used by audit method */
  private static String tablename = "postedformfields";

  /** postedforms.postedform_id, foreign key **/
  public int postedform_id = 0;

  /** postedformfields.fieldname **/
  public String fieldname = null;

  /** postedformfields.num **/
  public int num = 0;
  
  /** postedformfields.value **/
  public String value = null;

  /**
   * Constructs a default instance
   */
  public PostedFormField() {
    setDefaults();
  }

  /**
   * Constructs given a populated ResultSet.
   */
  PostedFormField(ResultSet rs) throws SQLException {
    populate(rs);
  }

  /**
   * Select is not implemented.
   */
  protected void select(DB db, int key) throws SQLException {
    throw new SQLException("PostedFormField.select() is not implemented.");
  }

  /**
   * Populate a record from a populated ResultSet
   */
  protected void populate(ResultSet rs) throws SQLException {
    postedform_id = rs.getInt("postedform_id");
    fieldname = rs.getString("fieldname");
    num = rs.getInt("num");
    value = rs.getString("value");
  }

  /**
   * Refresh this instance with values from the database record; not implemented
   */
  protected void refresh(DB db) throws SQLException {
  }

  /**
   * Insert a new postedformfields record
   */
  protected void insert(DB db) throws SQLException, ValidationException {
    db.executeUpdate("INSERT INTO postedformfields (postedform_id,fieldname,num,value) VALUES ("+postedform_id+","+nullOrChars(fieldname)+","+num+","+nullOrChars(value)+")");
  }

  /**
   * Records may not be updated.
   */
  protected void update(DB db) throws SQLException, ValidationException {
    throw new SQLException("PostedFormField.update() is not implemented.");
  }

  /**
   * Records may not be deleted.
   */
  protected void delete(DB db) throws SQLException {
    throw new SQLException("PostedFormField.delete() is not implemented.");
  }

  /**
   * Sets default values.
   */
  protected void setDefaults() {
    postedform_id = 0;
    fieldname = null;
    num = 0;
    value = null;
  }

  /**
   * Return true if this is a default, uninstantiated instance
   */
  public boolean isDefault() {
    return fieldname==null;
  }

  /**
   * Auditing is not implemented, since these records are created by front-end users.
   */
  protected void audit(DB db, char action, String email) throws SQLException {
  }

  /**
   * Sort by num.
   */
  public int compareTo(Object o) {
    PostedFormField that = (PostedFormField) o;
    return this.num - that.num;
  }

  /**
   * Return true if same posted form and field
   */
  public boolean equals(Object o) {
    PostedFormField that = (PostedFormField) o;
    return this.postedform_id==that.postedform_id && this.fieldname.equals(that.fieldname);
  }

  /**
   * Return NULL in the case of empty or null strings, quoted string otherwise; does NOT escape HTML entities!
   */
  static String nullOrChars(String str) {
    if (str==null || str.trim().length()==0 || str.trim().equals("null")) {
      return "NULL";
    } else {
      return "'"+escapeQuotes(str.trim())+"'";
    }
  }


}

