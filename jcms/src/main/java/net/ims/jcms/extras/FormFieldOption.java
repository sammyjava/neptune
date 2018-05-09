package net.ims.jcms.extras;

import net.ims.jcms.*;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.io.FileNotFoundException;
import javax.naming.NamingException;
import javax.servlet.ServletContext;

/**
 * Extends Record to encapsulate a formfieldoptions table record.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class FormFieldOption extends Record {

  /** the name of the database table, used by audit method */
  private static String tablename = "formfieldoptions";

  /** formfieldoptions.formfieldoption_id, primary key **/
  public int formfieldoption_id = 0;

  /** formfields.formfield_id, foreign key **/
  public int formfield_id = 0;

  /** formfieldoptions.num **/
  public int num = 0;

  /** formfieldoptions.value **/
  public String value = null;

  /** formfieldoptions.selected - indicates if pre-selected as default **/
  public boolean selected = false;

  /**
   * Constructs a default instance
   */
  public FormFieldOption() {
    setDefaults();
  }

  /**
   * Constructs given a primary key.
   */
  public FormFieldOption(ServletContext context, int key) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
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
  FormFieldOption(DB db, int key) throws SQLException {
    select(db, key);
  }

  /**
   * Constructs given a populated ResultSet.
   */
  FormFieldOption(ResultSet rs) throws SQLException {
    populate(rs);
  }

  /**
   * Populate a record given a key
   */
  protected void select(DB db, int key) throws SQLException {
    db.executeQuery("SELECT * FROM formfieldoptions WHERE formfieldoption_id="+key);
    if (db.rs.next()) populate(db.rs);
  }

  /**
   * Populate a record from a populated ResultSet
   */
  protected void populate(ResultSet rs) throws SQLException {
    formfieldoption_id = rs.getInt("formfieldoption_id");
    formfield_id = rs.getInt("formfield_id");
    num = rs.getInt("num");
    value = rs.getString("value");
    selected = rs.getBoolean("selected");
  }

  /**
   * Refresh this instance with values from the database record
   */
  protected void refresh(DB db) throws SQLException {
    select(db, formfieldoption_id);
  }

  /**
   * Insert a new formfieldoptions record with current values.
   */
  protected void insert(DB db) throws SQLException, ValidationException {
    validate();
    reorder(db);  // reorder subsequent fields if this num in use
    // if selected and radio or select menu, clear all other selected options
    if (selected) {
      FormField ff = new FormField(db, formfield_id);
      if (ff.radio || ff.selectmenu) db.executeUpdate("UPDATE formfieldoptions SET selected=false WHERE formfield_id="+formfield_id);
    }
    db.executeUpdate("INSERT INTO formfieldoptions (formfield_id,num,value,selected) VALUES ("+formfield_id+","+num+","+charsOrNull(value)+","+db.bool(selected)+")");
    // get key and reload
    db.executeQuery("SELECT max(formfieldoption_id) AS formfieldoption_id FROM formfieldoptions");
    db.rs.next();
    formfieldoption_id = db.rs.getInt("formfieldoption_id");
    select(db, formfieldoption_id);
  }

  /**
   * Updates a formfieldoptions record with current values.
   */
  protected void update(DB db) throws SQLException, ValidationException {
    validate();
    reorder(db);  // reorder subsequent fields if this num in use by another record
    // if selected and radio or select menu, clear all other selected options
    if (selected) {
      FormField ff = new FormField(db, formfield_id);
      if (ff.radio || ff.selectmenu) db.executeUpdate("UPDATE formfieldoptions SET selected=false WHERE formfield_id="+formfield_id);
    }
    db.executeUpdate("UPDATE formfieldoptions SET "+
		     "num="+intOrNull(num)+", " +
		     "value="+charsOrNull(value)+", " +
		     "selected="+db.bool(selected)+" " +
		     "WHERE formfieldoption_id="+formfieldoption_id);
  }

  /**
   * Throw a ValidationException if fields are invalid.
   */
  void validate() throws ValidationException {
    String error = "";
    if (num==0) error += "Num must be 1 or larger. ";
    if (value==null || value.trim().length()==0) error += "option/radio/checkbox Value is required. ";
    if (error.length()>0) throw new ValidationException(error);
  }

  /**
   * Reorder subsequent options if the given num value is already in use; do nothing otherwise.
   */
  void reorder(DB db) throws SQLException {
    db.executeQuery("SELECT formfieldoption_id FROM formfieldoptions WHERE formfield_id="+formfield_id+" AND num="+num);
    if (db.rs.next()) {
      int db_formfieldoption_id = db.rs.getInt("formfieldoption_id");
      if (formfieldoption_id==0) {
	// INSERT - create hole at new num
	db.executeQuery("SELECT count(*) AS count FROM formfieldoptions WHERE formfield_id="+formfield_id+" AND num>="+num);
	db.rs.next();
	int bumpCount = db.rs.getInt("count");
	if (bumpCount>0) {
	  String block = "BEGIN; ";
	  block += "DECLARE reverse_cursor CURSOR FOR SELECT * FROM formfieldoptions WHERE formfield_id="+formfield_id+" AND num>="+num+" ORDER BY num DESC FOR UPDATE; ";
	  for (int i=0; i<bumpCount; i++) block += "MOVE reverse_cursor; UPDATE formfieldoptions SET num=num+1 WHERE CURRENT OF reverse_cursor; ";
	  block += "COMMIT;";
	  db.executeUpdate(block);
	}
      } else if (db_formfieldoption_id!=formfieldoption_id) {
	// UPDATE - a different record already has the desired num; get current num of this instance
	db.executeQuery("SELECT num FROM formfieldoptions WHERE formfieldoption_id="+formfieldoption_id);
	db.rs.next();
	int current_num = db.rs.getInt("num");
	// put this instance record in a holding area first
	db.executeUpdate("UPDATE formfieldoptions SET num=0 WHERE formfieldoption_id="+formfieldoption_id);
	// fill in the hole at current_num, need to use cursor to avoid unique constraint
	db.executeQuery("SELECT count(*) AS count FROM formfieldoptions WHERE formfield_id="+formfield_id+" AND num>"+current_num);
	db.rs.next();
	int dropCount = db.rs.getInt("count");
	if (dropCount>0) {
	  String block = "BEGIN; ";
	  block += "DECLARE forward_cursor CURSOR FOR SELECT * FROM formfieldoptions WHERE formfield_id="+formfield_id+" AND num>"+current_num+" ORDER BY num FOR UPDATE; ";
	  for (int i=0; i<dropCount; i++) block += "MOVE forward_cursor; UPDATE formfieldoptions SET num=num-1 WHERE CURRENT OF forward_cursor; ";
	  block += "COMMIT;";
	  db.executeUpdate(block);
	}
	// create hole at new num
	db.executeQuery("SELECT count(*) AS count FROM formfieldoptions WHERE formfield_id="+formfield_id+" AND num>="+num);
	db.rs.next();
	int bumpCount = db.rs.getInt("count");
	if (bumpCount>0) {
	  String block = "BEGIN; ";
	  block += "DECLARE reverse_cursor CURSOR FOR SELECT * FROM formfieldoptions WHERE formfield_id="+formfield_id+" AND num>="+num+" ORDER BY num DESC FOR UPDATE; ";
	  for (int i=0; i<bumpCount; i++) block += "MOVE reverse_cursor; UPDATE formfieldoptions SET num=num+1 WHERE CURRENT OF reverse_cursor; ";
	  block += "COMMIT;";
	  db.executeUpdate(block);
	}
      }
    }
  }

  /**
   * Deletes this record.
   */
  protected void delete(DB db) throws SQLException {
    db.executeUpdate("DELETE FROM formfieldoptions WHERE formfieldoption_id="+formfieldoption_id);
    // drop the num values for the higher records
    db.executeQuery("SELECT count(*) AS count FROM formfieldoptions WHERE formfield_id="+formfield_id+" AND num>"+num);
    db.rs.next();
    int dropCount = db.rs.getInt("count");
    String block = "BEGIN; ";
    block += "DECLARE forward_cursor CURSOR FOR SELECT * FROM formfieldoptions WHERE formfield_id="+formfield_id+" AND num>"+num+" ORDER BY num FOR UPDATE; ";
    for (int i=0; i<dropCount; i++) block += "MOVE forward_cursor; UPDATE formfieldoptions SET num=num-1 WHERE CURRENT OF forward_cursor; ";
    block += "COMMIT;";
    db.executeUpdate(block);
    // return to default values
    setDefaults();
  }

  /**
   * Sets default values.
   */
  protected void setDefaults() {
    formfield_id = 0;
    formfieldoption_id = 0;
    num = 0;
    value = null;
    selected = false;
  }

  /**
   * Return true if this is a default, uninstantiated instance
   */
  public boolean isDefault() {
    return formfieldoption_id==0;
  }

  /**
   * Insert an audit record for the given action
   */
  protected void audit(DB db, char action, String username) throws SQLException {
    Audit a = new Audit();
    a.tablename = tablename;
    a.record_id = formfield_id;
    a.action = action;
    a.username = username;
    a.description = value;
    a.insert(db);
  }

  /**
   * Sort by num.
   */
  public int compareTo(Object o) {
    FormField that = (FormField) o;
    return this.num - that.num;
  }

  /**
   * Return true if same primary key
   */
  public boolean equals(Object o) {
    FormFieldOption that = (FormFieldOption) o;
    return this.formfieldoption_id==that.formfieldoption_id;
  }

}

