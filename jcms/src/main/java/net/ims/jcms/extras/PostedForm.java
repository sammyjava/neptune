package net.ims.jcms.extras;

import net.ims.jcms.*;

import com.oreilly.servlet.MultipartRequest;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import javax.naming.NamingException;
import javax.servlet.ServletContext;

/**
 * Extends Record to encapsulate a postedforms table record.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class PostedForm extends Record {

  /** the name of the database table, used by audit method */
  private static String tablename = "postedforms";

  /** postedforms.postedform_id, primary key **/
  public int postedform_id = 0;

  /** postedforms.form_id, foreign key **/
  public int form_id = 0;

  /** postedforms.timeposted **/
  public Timestamp timeposted = null;

  /** array of this posted form's posted form fields **/
  public PostedFormField[] postedformfields = null;

  /**
   * Constructs a default instance
   */
  public PostedForm() {
    setDefaults();
  }

  /**
   * Constructs given a primary key.
   */
  public PostedForm(ServletContext context, int key) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
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
  PostedForm(DB db, int key) throws SQLException {
    select(db, key);
  }

  /**
   * Constructs given a populated ResultSet.
   */
  PostedForm(ResultSet rs) throws SQLException {
    populate(rs);
  }

  /**
   * Populate a record given a key
   */
  protected void select(DB db, int key) throws SQLException {
    db.executeQuery("SELECT * FROM postedforms WHERE form_id="+key);
    if (db.rs.next()) {
      populate(db.rs);
      if (postedform_id>0) {
	getPostedFormFields(db);
      }
    }
  }

  /**
   * Populate a record from a populated ResultSet
   */
  protected void populate(ResultSet rs) throws SQLException {
    postedform_id = rs.getInt("postedform_id");
    form_id = rs.getInt("form_id");
    timeposted = rs.getTimestamp("timeposted");
  }

  /**
   * Refresh this instance with values from the database record
   */
  protected void refresh(DB db) throws SQLException {
    select(db, postedform_id);
  }

  /**
   * Insert a new postedforms record
   */
  protected void insert(DB db) throws SQLException, ValidationException {
    if (form_id==0) throw new ValidationException("form_id=0");
    db.executeUpdate("INSERT INTO postedforms (form_id) VALUES ("+form_id+")");
    db.executeQuery("SELECT max(postedform_id) AS postedform_id FROM postedforms");
    db.rs.next();
    // get key and reload
    postedform_id = db.rs.getInt("postedform_id");
    // reload to get timeposted
    select(db, postedform_id);
  }

  /**
   * There is no update for posted forms.
   */
  protected void update(DB db) throws SQLException, ValidationException {
    throw new SQLException("PostedForm.update() is not implemented.");
  }

  /**
   * There is no delete for posted forms.
   */
  protected void delete(DB db) throws SQLException {
    throw new SQLException("PostedForm.delete() is not implemented.");
  }

  /**
   * Sets default values.
   */
  protected void setDefaults() {
    postedform_id = 0;
    form_id = 0;
    timeposted = null;
  }

  /**
   * Return true if this is a default, uninstantiated instance
   */
  public boolean isDefault() {
    return postedform_id==0;
  }

  /**
   * Audit is not implemented.
   */
  protected void audit(DB db, char action, String email) throws SQLException {
  }

  /**
   * Returns an array of all postedforms records for a given form, ordered by timeposted.   Zero length if none exist.
   */
  static PostedForm[] getAll(DB db, int form_id) throws SQLException {
    db.executeQuery("SELECT count(*) AS count FROM postedforms WHERE form_id="+form_id);
    db.rs.next();
    int count = db.rs.getInt("count");
    PostedForm[] postedforms = new PostedForm[count];
    db.executeQuery("SELECT * FROM postedforms WHERE form_id="+form_id+" ORDER BY timeposted");
    int i = 0;
    while (db.rs.next()) postedforms[i++] = new PostedForm(db.rs);
    for (i=0; i<count; i++) postedforms[i].getPostedFormFields(db);
    return postedforms;
  }

  /**
   * Returns an array of all postedforms records for a given form, ordered by timeposted.   Zero length if none exist.
   */
  public static PostedForm[] getAll(ServletContext context, int form_id) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return getAll(db, form_id);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Compares by time posted, if same form_id.
   */
  public int compareTo(Object o) {
    PostedForm that = (PostedForm) o;
    if (this.form_id==that.form_id) {
      return this.timeposted.compareTo(that.timeposted);
    } else {
      return 0;
    }
  }

  /**
   * Return true if same primary key
   */
  public boolean equals(Object o) {
    PostedForm that = (PostedForm) o;
    return this.postedform_id==that.postedform_id;
  }

  /**
   * Populate this posted form's fields records, ordered by num, zero length if none exist.
   */
  void getPostedFormFields(DB db) throws SQLException {
    db.executeQuery("SELECT count(*) AS count FROM postedformfields WHERE postedform_id="+postedform_id);
    db.rs.next();
    int count = db.rs.getInt("count");
    postedformfields = new PostedFormField[count];
    db.executeQuery("SELECT * FROM postedformfields WHERE postedform_id="+postedform_id+" ORDER BY num");
    int i = 0;
    while (db.rs.next()) postedformfields[i++] = new PostedFormField(db.rs);
  }

  /**
   * Process a request containing posted data, inserting data into the database.
   */
  static void process(MultipartRequest mpr, ServletContext context, String referer) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException, ValidationException {
    int form_id = Integer.parseInt(mpr.getParameter("form_id"));
    if (form_id==0) throw new ValidationException("form_id=0");
    DB db = null;
    try {
      db = new DB(context);
      PostedForm pf = new PostedForm();
      pf.form_id = form_id;
      pf.insert(db);
      Form form = new Form(db, form_id);
      // posted fields
      for (int i=0; i<form.fields.length; i++) {
	String[] values = mpr.getParameterValues(form.fields[i].fieldname);
	if (values!=null) {
	  for (int j=0; j<values.length; j++) {
	    PostedFormField pff = new PostedFormField();
	    pff.postedform_id = pf.postedform_id;
	    pff.fieldname = form.fields[i].fieldname;
	    pff.num = form.fields[i].num;
	    pff.value = values[j];
	    pff.insert(db);
	  }
	}
      }
      // uploaded file
      File uploadfile = mpr.getFile("uploadfile");
      if (form.filetitle!=null && uploadfile!=null) {
	PostedFormField pff = new PostedFormField();
	pff.postedform_id = pf.postedform_id;
	pff.fieldname = "uploaded_filename";
	pff.num = 0;
	pff.value = uploadfile.getName();
	pff.insert(db);
      }
      // referrer
      PostedFormField pff = new PostedFormField();
      pff.postedform_id = pf.postedform_id;
      pff.fieldname = "Referrer";
      pff.num = 0;
      pff.value = referer;
      pff.insert(db);

    } finally {
      if (db!=null) db.close();
    }
  }

}
