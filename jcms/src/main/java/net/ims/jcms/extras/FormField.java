package net.ims.jcms.extras;

import net.ims.jcms.*;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.io.FileNotFoundException;
import javax.naming.NamingException;
import javax.servlet.ServletContext;

/**
 * Extends Record to encapsulate a formfields table record.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class FormField extends Record {

  public static int DEFAULT_TEXTINPUT_SIZE = 20;
  public static int DEFAULT_TEXTAREA_ROWS = 3;
  public static int DEFAULT_TEXTAREA_COLS = 20;
  public static int DEFAULT_COLUMNS = 1;

  /** the name of the database table, used by audit method */
  private static String tablename = "formfields";

  /** formfields.formfield_id, primary key **/
  public int formfield_id = 0;

  /** formfields.form_id, foreign key **/
  public int form_id = 0;

  /** formfields.fieldname **/
  public String fieldname = null;

  /** formfields.num **/
  public int num = 0;

  /** formfields.heading **/
  public String heading = null;

  /** formfields.required **/
  public boolean required = false;

  /** booleans flag which type of field this is */
  public boolean hidden = false;
  public boolean textinput = false;
  public boolean textarea = false;
  public boolean checkbox = false;
  public boolean radio = false;
  public boolean selectmenu = false;

  /** formfields.columns for display of checkboxes and radios in a table */
  public int columns = DEFAULT_COLUMNS;

  /** formfields.size = size of text input field */
  public int size = DEFAULT_TEXTINPUT_SIZE;

  /** formfields.rows = rows of textarea field */
  public int rows = DEFAULT_TEXTAREA_ROWS;

  /** formfields.cols = cols of textarea field */
  public int cols = DEFAULT_TEXTAREA_COLS;

  /** array of options for a selectmenu, radio or checkbox array */
  public FormFieldOption[] options = null;

  /**
   * Constructs a default instance
   */
  public FormField() {
    setDefaults();
  }

  /**
   * Constructs given a primary key.
   */
  public FormField(ServletContext context, int key) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
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
  FormField(DB db, int key) throws SQLException {
    select(db, key);
  }

  /**
   * Constructs given a populated ResultSet. NOTE: options will NOT be populated!
   */
  FormField(ResultSet rs) throws SQLException {
    populate(rs);
  }

  /**
   * Populate a record given a key
   */
  protected void select(DB db, int key) throws SQLException {
    db.executeQuery("SELECT * FROM formfields WHERE formfield_id="+key);
    if (db.rs.next()) {
      populate(db.rs);
      getOptions(db);
    }
  }

  /**
   * Populate a record from a populated ResultSet
   */
  protected void populate(ResultSet rs) throws SQLException {
    formfield_id = rs.getInt("formfield_id");
    form_id = rs.getInt("form_id");
    fieldname = rs.getString("fieldname");
    num = rs.getInt("num");
    heading = rs.getString("heading");
    required = rs.getBoolean("required");
    hidden = rs.getBoolean("hidden");
    textinput = rs.getBoolean("textinput");
    radio = rs.getBoolean("radio");
    checkbox = rs.getBoolean("checkbox");
    textarea = rs.getBoolean("textarea");
    selectmenu = rs.getBoolean("selectmenu");
    columns = rs.getInt("columns");
    size = rs.getInt("size");
    rows = rs.getInt("rows");
    cols = rs.getInt("cols");
  }

  /**
   * Refresh this instance with values from the database record
   */
  protected void refresh(DB db) throws SQLException {
    select(db, formfield_id);
  }

  /**
   * Insert a new formfields record
   */
  protected void insert(DB db) throws SQLException, ValidationException {
    validate();
    renumber(db);  // renumber subsequent fields if this num in use
    db.executeUpdate("INSERT INTO formfields (" +
		     "form_id,fieldname,num,heading,required,hidden,textinput,radio,checkbox,textarea,selectmenu,columns,size,rows,cols" +
		     ") VALUES (" +
		     form_id+","+charsOrNull(fieldname)+","+num+","+charsOrNull(heading)+","+db.bool(required)+"," +
		     db.bool(hidden)+","+db.bool(textinput)+","+db.bool(radio)+","+db.bool(checkbox)+","+db.bool(textarea)+","+db.bool(selectmenu)+"," +
		     columns+","+size+","+rows+","+cols +
		     ")"
		     );
    // get key and reload
    db.executeQuery("SELECT max(formfield_id) AS formfield_id FROM formfields");
    db.rs.next();
    formfield_id = db.rs.getInt("formfield_id");
    select(db, formfield_id);
  }

  /**
   * Updates a formfields record with current values.
   */
  protected void update(DB db) throws SQLException, ValidationException {
    validate();
    renumber(db);  // renumber subsequent fields if this num in use
    db.executeUpdate("UPDATE formfields SET "+
		     "fieldname="+charsOrNull(fieldname)+", " +
		     "num="+intOrNull(num)+", " +
		     "heading="+charsOrNull(heading)+", " +
		     "required="+db.bool(required)+", " +
		     "hidden="+db.bool(hidden)+", " +
		     "textinput="+db.bool(textinput)+", " +
		     "radio="+db.bool(radio)+", " +
		     "checkbox="+db.bool(checkbox)+", " +
		     "textarea="+db.bool(textarea)+", " +
		     "selectmenu="+db.bool(selectmenu)+", " +
		     "columns="+columns+", " +
		     "size="+size+", " +
		     "rows="+rows+", " +
		     "cols="+cols+" " +
		     "WHERE formfield_id="+formfield_id);
    // reload
    select(db, formfield_id);
  }

  /**
   * Throw a ValidationException if fields are invalid.
   */
  void validate() throws ValidationException {
    String error = "";
    if (fieldname==null || fieldname.trim().length()==0) error += "Field name is required. ";
    if (num==0) error += "Field num must be 1 or larger. ";
    if (heading==null || heading.trim().length()==0) error += "Field heading is required. ";
    if (!hidden && !textinput && !radio && !checkbox && !textarea && !selectmenu) error += "Field type was not selected. ";
    if (error.length()>0) throw new ValidationException(error);
  }

  /**
   * Renumber subsequent fields if the given num value is already in use; do nothing otherwise.
   */
  void renumber(DB db) throws SQLException {
    db.executeQuery("SELECT formfield_id FROM formfields WHERE form_id="+form_id+" AND num="+num);
    if (db.rs.next()) {
      int db_formfield_id = db.rs.getInt("formfield_id");
      if (formfield_id==0) {
	// INSERT - create hole at new num
	db.executeQuery("SELECT count(*) AS count FROM formfields WHERE form_id="+form_id+" AND num>="+num);
	db.rs.next();
	int bumpCount = db.rs.getInt("count");
	String block = "";
	block += "BEGIN;";
	block += "DECLARE reverse_cursor CURSOR FOR SELECT * FROM formfields WHERE form_id="+form_id+" AND num>="+num+" ORDER BY num DESC FOR UPDATE;";
	for (int i=0; i<bumpCount; i++) block += "MOVE FROM reverse_cursor; UPDATE formfields SET num=num+1 WHERE CURRENT OF reverse_cursor;";
	block += "COMMIT;";
	db.executeUpdate(block);
      } else if (db_formfield_id!=formfield_id) {
	// UPDATE - a different record already has the desired num; get current num of this instance
	db.executeQuery("SELECT num FROM formfields WHERE formfield_id="+formfield_id);
	db.rs.next();
	int current_num = db.rs.getInt("num");
	// put this instance record in a holding area first
	db.executeUpdate("UPDATE formfields SET num=0 WHERE formfield_id="+formfield_id);
	// fill in the hole at current_num, need to use cursor to avoid unique constraint
	db.executeQuery("SELECT count(*) AS count FROM formfields WHERE form_id="+form_id+" AND num>"+current_num);
	db.rs.next();
	int dropCount = db.rs.getInt("count");
	String block = "";
	block += "BEGIN;";
	block += "DECLARE forward_cursor CURSOR FOR SELECT * FROM formfields WHERE form_id="+form_id+" AND num>"+current_num+" ORDER BY num FOR UPDATE;";
	for (int i=0; i<dropCount; i++) block += "MOVE FROM forward_cursor; UPDATE formfields SET num=num-1 WHERE CURRENT OF forward_cursor;";
	block += "COMMIT;";

	System.out.println(block);

	db.executeUpdate(block);
	// create hole at new num
	db.executeQuery("SELECT count(*) AS count FROM formfields WHERE form_id="+form_id+" AND num>="+num);
	db.rs.next();
	int bumpCount = db.rs.getInt("count");
	block = "";
	block += "BEGIN;";
	block += "DECLARE reverse_cursor CURSOR FOR SELECT * FROM formfields WHERE form_id="+form_id+" AND num>="+num+" ORDER BY num DESC FOR UPDATE;";
	for (int i=0; i<bumpCount; i++) block += "MOVE FROM reverse_cursor; UPDATE formfields SET num=num+1 WHERE CURRENT OF reverse_cursor;";
	block += "COMMIT;";
	db.executeUpdate(block);
      }
    }
  }

  /**
   * Delete this record (and child records);
   */
  protected void delete(DB db) throws SQLException {
    db.executeUpdate("DELETE FROM formfieldoptions WHERE formfield_id="+formfield_id);
    db.executeUpdate("DELETE FROM formfields WHERE formfield_id="+formfield_id);
    // drop the num values for the higher records
    db.executeQuery("SELECT count(*) AS count FROM formfields WHERE form_id="+form_id+" AND num>"+num);
    db.rs.next();
    int dropCount = db.rs.getInt("count");
    String block = "";
    block += "BEGIN;";
    block += "DECLARE forward_cursor CURSOR FOR SELECT * FROM formfields WHERE form_id="+form_id+" AND num>"+num+" ORDER BY num FOR UPDATE;";
    for (int i=0; i<dropCount; i++) block += "MOVE FROM forward_cursor; UPDATE formfields SET num=num-1 WHERE CURRENT OF forward_cursor;";
    block += "COMMIT;";
    db.executeUpdate(block);
    // return to default values
    setDefaults();
  }

  /**
   * Sets default values.
   */
  protected void setDefaults() {
    form_id = 0;
    formfield_id = 0;
    fieldname = null;
    num = 0;
    heading = null;
    required = false;
    hidden = false;
    textinput = false;
    radio = false;
    checkbox = false;
    textarea = false;
    selectmenu = false;
    columns = DEFAULT_COLUMNS;
    size = DEFAULT_TEXTINPUT_SIZE;
    rows = DEFAULT_TEXTAREA_ROWS;
    cols = DEFAULT_TEXTAREA_COLS;
  }

  /**
   * Return true if this is a default, uninstantiated instance
   */
  public boolean isDefault() {
    return formfield_id==0;
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
    a.description = fieldname;
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
    FormField that = (FormField) o;
    return this.formfield_id==that.formfield_id;
  }

  /**
   * Populate this form field's options values, ordered by num, zero length if none.
   */
  void getOptions(DB db) throws SQLException {
    db.executeQuery("SELECT count(*) AS count FROM formfieldoptions WHERE formfield_id="+formfield_id);
    db.rs.next();
    int count = db.rs.getInt("count");
    options = new FormFieldOption[count];
    db.executeQuery("SELECT * FROM formfieldoptions WHERE formfield_id="+formfield_id+" ORDER BY num");
    int i = 0;
    while (db.rs.next()) options[i++] = new FormFieldOption(db.rs);
  }

}

