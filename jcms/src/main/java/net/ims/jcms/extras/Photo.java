package net.ims.jcms.extras;

import net.ims.jcms.*;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.io.FileNotFoundException;
import javax.naming.NamingException;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

/**
 * Extends Record to contain the data for a single photos record.
 * Provides methods for inserting, updating, deleting, validation, and implements the Comparable interface for sorting.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class Photo extends Record {

  /** the name of the database table, used by audit method */
  private static String tablename = "photos";
 
  /** photos.photo_id: the primary key for this record */
  public int photo_id = 0;

  /** photos.photoset_id: the foreign key for this record */
  public int photoset_id = 0;

  /** photos.num: the set number for this photo */
  public int num = 0;

  /** photos.imagefile: the last name of this photo */
  public String imagefile = null;

  /** photos.imagewidth: the width of this photo image */
  public int imagewidth = 0;

  /** photos.imageheight: the height of this photo image */
  public int imageheight = 0;

  /** photos.title: the alt text */
  public String title = null;

  /** photos.caption: the caption of this photo */
  public String caption = null;

  /** photos.thumbnail: the thumbnail image file for this photo */
  public String thumbnail = null;

  /** photos.timeposted: timestamp of upload */
  public Timestamp timeposted = null;

  /**
   * Construct a default instance
   */
  public Photo() {
    setDefaults();
  }

  /**
   * Construct given DB connection and an int primary key
   */
  protected Photo(DB db, int key) throws SQLException {
    select(db, key);
  }

  /**
   * Construct given a ResultSet
   */
  protected Photo(ResultSet rs) throws SQLException {
    populate(rs);
  }

  /**
   * Construct given a Servlet context and primary key
   */
  public Photo(ServletContext context, int key) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    super();
    DB db = null;
    try {
      db = new DB(context);
      select(db, key);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Construct given a Servlet context, photoset_id and file name
   */
  public Photo(ServletContext context, int photoset_id, String filename) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    super();
    DB db = null;
    try {
      db = new DB(context);
      select(db, photoset_id, filename);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Do a SELECT query and set instance variables given a DB connection and a primary key.
   */
  protected void select(DB db, int key) throws SQLException {
    db.executeQuery("SELECT * FROM photos WHERE photo_id="+key);
    if (db.rs.next()) populate(db.rs);
  }

  /**
   * Do a SELECT query and set instance variables given a DB connection, photoset_id and a file name.
   */
  void select(DB db, int photoset_id, String filename) throws SQLException {
    db.executeQuery("SELECT * FROM photos WHERE photoset_id="+intOrNull(photoset_id)+" AND imagefile="+charsOrNull(filename));
    if (db.rs.next()) populate(db.rs);
  }

  /**
   * Populate this instance with the values from the provided ResultSet.
   */
  protected void populate(ResultSet rs) throws SQLException {
    photo_id = rs.getInt("photo_id");
    photoset_id = rs.getInt("photoset_id");
    num = rs.getInt("num");
    imagefile = rs.getString("imagefile");
    imagewidth = rs.getInt("imagewidth");
    imageheight = rs.getInt("imageheight");
    title = rs.getString("title");
    caption = rs.getString("caption");
    thumbnail = rs.getString("thumbnail");
    if (Util.nullOrEmpty(thumbnail)) thumbnail = imagefile;
    timeposted = rs.getTimestamp("timeposted");
  }

  /**
   * Refresh this instance with values from the database record
   */
  protected void refresh(DB db) throws SQLException {
    select(db, photo_id);
  }

  /**
   * Throw a ValidationException of the instance variables fail validation rules.
   */
  protected void validate() throws ValidationException {
    String error = "";
    if (num==0) error+= "Photo number was not provided. ";
    if (imagefile==null || imagefile.trim().equals("")) error += "Image file name was not provided. ";
    if (imagewidth==0) error += "Image width was not provided. ";
    if (imageheight==0) error += "Image height was not provided. ";
    if (error.length()>0) throw new ValidationException(error);
  }

  /**
   * Insert a new photo record into the database and retrieve/set the resulting photo_id.
   */
  public void insert(ServletContext context) throws SQLException, ValidationException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      insert(db);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Insert a new photo record into the database and retrieve/set the resulting photo_id.
   */
  protected void insert(DB db) throws SQLException, ValidationException {
    // get number if not provided
    if (num==0) {
      db.executeQuery("SELECT max(num) AS max FROM photos WHERE photoset_id="+photoset_id);
      db.rs.next();
      num = db.rs.getInt("max") + 1;
    }
    // validate afterward, since num required
    validate();
    // now insert
    String query = "INSERT INTO photos (" +
      "photoset_id,num,imagefile,imagewidth,imageheight,title,caption,thumbnail" +
      ") VALUES (" +
      intOrNull(photoset_id)+"," +
      intOrNull(num)+"," +
      charsOrNull(imagefile)+"," +
      intOrNull(imagewidth)+"," +
      intOrNull(imageheight)+"," +
      charsOrNull(title)+"," +
      charsOrNull(caption)+"," +
      charsOrNull(thumbnail) +
      ")";
    db.executeUpdate(query);
    db.executeQuery("SELECT max(photo_id) FROM photos");
    db.rs.next();
    photo_id = db.rs.getInt("max");
    refresh(db);
  }

  /**
   * Update the photos record.
   */
  protected void update(DB db) throws SQLException, ValidationException {
    validate();
    String query = "UPDATE photos SET " +
      "num="+intOrNull(num)+", " +
      "imagefile="+charsOrNull(imagefile)+", " +
      "imagewidth="+intOrNull(imagewidth)+", " +
      "imageheight="+intOrNull(imageheight)+", " +
      "title="+charsOrNull(title)+", " +
      "caption="+charsOrNull(caption)+", " +
      "thumbnail="+charsOrNull(thumbnail)+" " +
      "WHERE photo_id="+photo_id;
    db.executeUpdate(query);
    refresh(db);
  }

  /**
   * Delete the current record, and reset to defaults.
   */
  protected void delete(DB db) throws SQLException, ValidationException {
    db.executeUpdate("DELETE FROM photos WHERE photo_id="+photo_id);
    setDefaults();
  }

  /**
   * Set default values when instance does not correspond to a database record (such as after delete() is called
   */
  protected void setDefaults() {
    photo_id = 0;
    photoset_id = 0;
    num = 0;
    imagefile = null;
    imagewidth = 0;
    imageheight = 0;
    title = null;
    caption = null;
    thumbnail = null;
    timeposted = null;
  }

  /**
   * return true if this is the default photo, ie. empty
   */
  public boolean isDefault() {
    return photo_id==0;
  }

  /**
   * Insert an audit record for the given action
   */
  protected void audit(DB db, char action, String username) throws SQLException {
    Audit a = new Audit();
    a.tablename = tablename;
    a.record_id = photo_id;
    a.action = action;
    a.username = username;
    a.description = imagefile;
    a.insert(db);
  }

  /**
   * Compare two records, use num.
   */
  public int compareTo(Object o) {
    Photo that = (Photo) o;
    if (this.num!=that.num) {
      return this.num - that.num;
    } else {
      return this.imagefile.compareTo(that.imagefile);
    }
  }

  /**
   * Return true if same primary key
   */
  public boolean equals(Object o) {
    Photo that = (Photo) o;
    return this.photo_id==that.photo_id;
  }

  /**
   * Update timeposted, but nothing else.
   */
  void updateTimeposted(DB db) throws SQLException {
    db.executeUpdate("UPDATE photos SET timeposted=now() WHERE photo_id="+photo_id);
  }

  /**
   * Update timeposted, but nothing else.
   */
  public void updateTimeposted(ServletContext context) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      updateTimeposted(db);
      // audit(request.getSession(), 'U'); breaks under Tomcat 7 in jupload.jsp
    } finally {
      if (db!=null) db.close();
    }
  }

}
