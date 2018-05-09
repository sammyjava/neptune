package net.ims.jcms.extras;

import net.ims.jcms.*;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.io.FileNotFoundException;
import javax.naming.NamingException;
import javax.servlet.ServletContext;

/**
 * Extends Record to encapsulate a photosets table record.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class PhotoSet extends Record {

  /** the name of the database table, used by audit method */
  private static String tablename = "photosets";

  /** photosets.photo_id, primary key **/
  public int photoset_id = 0;

  /** photosets.shootdate **/
  public String shootdate = null;

  /** photosets.credit **/
  public String credit = null;

  /** photosets.title **/
  public String title = null;

  /** photosets.description **/
  public String description = null;

  /** photosets.created - timestamp of photoset creation */
  public Timestamp created = null;

  /** photosets.thumbnailindex **/
  public boolean thumbnailindex = false;

  /** photosets.thumbnailcolumns **/
  public int thumbnailcolumns = 4;

  /** array of this photo set's photos **/
  public Photo[] photos = null;

  /**
   * Constructs a default instance
   */
  public PhotoSet() {
    setDefaults();
  }

  /**
   * Constructs given a primary key.
   */
  public PhotoSet(ServletContext context, int key) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
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
  PhotoSet(DB db, int key) throws SQLException {
    select(db, key);
  }

  /**
   * Constructs given a populated ResultSet.  NOTE: photos will NOT be populated!
   */
  PhotoSet(ResultSet rs) throws SQLException {
    populate(rs);
  }

  /**
   * Populate a record given a key
   */
  protected void select(DB db, int key) throws SQLException {
    db.executeQuery("SELECT * FROM photosets WHERE photoset_id="+key);
    if (db.rs.next()) {
      populate(db.rs);
      getPhotos(db);
    }
  }

  /**
   * Populate a record from a populated ResultSet
   */
  protected void populate(ResultSet rs) throws SQLException {
    photoset_id = rs.getInt("photoset_id");
    shootdate = rs.getString("shootdate");
    credit = rs.getString("credit");
    title = rs.getString("title");
    description = rs.getString("description");
    created = rs.getTimestamp("created");
    thumbnailindex = rs.getBoolean("thumbnailindex");
    thumbnailcolumns = rs.getInt("thumbnailcolumns");
  }

  /**
   * Refresh this instance with values from the database record
   */
  protected void refresh(DB db) throws SQLException {
    select(db, photoset_id);
  }

  /**
   * Insert a new photosets record.
   */
  protected void insert(DB db) throws SQLException, ValidationException {
    validate();
    db.executeUpdate("INSERT INTO photosets (thumbnailindex,thumbnailcolumns,shootdate,credit,title,description) VALUES (" +
		     thumbnailindex+","+thumbnailcolumns+","+charsOrNull(shootdate)+","+charsOrNull(credit)+","+charsOrNull(title)+","+charsOrNull(description)+")");
    db.executeQuery("SELECT max(photoset_id) AS photoset_id FROM photosets");
    db.rs.next();
    // get key and reload
    photoset_id = db.rs.getInt("photoset_id");
    // reload this photo set
    select(db, photoset_id);
  }

  /**
   * Updates a photosets record with current values.
   */
  protected void update(DB db) throws SQLException, ValidationException {
    validate();
    db.executeUpdate("UPDATE photosets SET "+
		     "shootdate="+charsOrNull(shootdate)+", " +
		     "credit="+charsOrNull(credit)+", " +
		     "thumbnailindex="+thumbnailindex+", " +
		     "thumbnailcolumns="+thumbnailcolumns+", " +
		     "title="+charsOrNull(title)+", " +
		     "description="+charsOrNull(description)+" " +
		     "WHERE photoset_id="+photoset_id);
    // reload
    select(db, photoset_id);
  }

  /**
   * Throw a ValidationException if photos are invalid.
   */
  void validate() throws ValidationException {
    String error = "";
    if (title==null || title.trim().length()==0) error += "Title is required. ";
    if (error.length()>0) throw new ValidationException(error);
  }

  /**
   * Deletes this record (and child photos records).
   */
  protected void delete(DB db) throws SQLException {
    db.executeUpdate("DELETE FROM photos WHERE photoset_id="+photoset_id);
    db.executeUpdate("DELETE FROM photosets WHERE photoset_id="+photoset_id);
    setDefaults();
  }

  /**
   * Sets default values.
   */
  protected void setDefaults() {
    photoset_id = 0;
    shootdate = null;
    credit = null;
    title = null;
    description = null;
    created = null;
    thumbnailindex = false;
    thumbnailcolumns = 4;
  }

  /**
   * return true if this is default photoset (not populated)
   */
  public boolean isDefault() {
    return photoset_id==0;
  }

  /**
   * Insert an audit record for the given action
   */
  protected void audit(DB db, char action, String username) throws SQLException {
    Audit a = new Audit();
    a.tablename = tablename;
    a.record_id = photoset_id;
    a.action = action;
    a.username = username;
    a.description = title;
    a.insert(db);
  }

  /**
   * Return an array of all photosets records, ordered by title, zero length if no photo records.  Does NOT populate photos within the sets!
   */
  static PhotoSet[] getAll(DB db) throws SQLException {
    db.executeQuery("SELECT count(*) AS count FROM photosets");
    db.rs.next();
    int count = db.rs.getInt("count");
    PhotoSet[] photosets = new PhotoSet[count];
    db.executeQuery("SELECT * FROM photosets ORDER BY title");
    int i = 0;
    while (db.rs.next()) photosets[i++] = new PhotoSet(db.rs);
    return photosets;
  }

  /**
   * Return an array of all photosets records, ordered by title.
   */
  public static PhotoSet[] getAll(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return getAll(db);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Sorts alphabetically by title.
   */
  public int compareTo(Object o) {
    PhotoSet that = (PhotoSet) o;
    return this.title.compareTo(that.title);
  }

  /**
   * Return true if same primary key
   */
  public boolean equals(Object o) {
    PhotoSet that = (PhotoSet) o;
    return this.photoset_id==that.photoset_id;
  }

  /**
   * Populate this photo set's photos records, ordered by num, then imagefile; zero length if no photo records.
   */
  void getPhotos(DB db) throws SQLException {
    db.executeQuery("SELECT count(*) AS count FROM photos WHERE photoset_id="+photoset_id);
    db.rs.next();
    int count = db.rs.getInt("count");
    photos = new Photo[count];
    db.executeQuery("SELECT * FROM photos WHERE photoset_id="+photoset_id+" ORDER BY num,imagefile");
    int i = 0;
    while (db.rs.next()) photos[i++] = new Photo(db.rs);
  }

}
