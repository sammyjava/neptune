package net.ims.jcms.extras;

import net.ims.jcms.*;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.io.FileNotFoundException;
import java.io.Serializable;
import javax.naming.NamingException;
import javax.servlet.ServletContext;

/**
 * Stock extension that rotates an image upon successive page loads.  Stores image info in imagerotator table.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class ImageRotator extends Record implements Serializable {

  static final long serialVersionUID = -7394231393240056578L;

  /** the name of the database table, used by audit method */
  private static String tablename = "imagerotator";

  /** imagerotator.id, primary key **/
  public int id = 0;

  /** imagerotator.filename **/
  public String filename = null;

  /** imagerotator.num **/
  public int num = 0;

  /** imagerotator.width **/
  public int width = 0;

  /** imagerotator.height **/
  public int height = 0;

  /** imagerotator.caption **/
  public String caption = null;

  /** imagerotator.alt **/
  public String alt = null;

  /** imagerotator.url **/
  public String url = null;

  /**
   * Constructs an empty record
   */
  public ImageRotator() {
  }

  /**
   * Constructs with the first image in the sequence, filename used in case of tie.
   */
  public ImageRotator(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      db.executeQuery("SELECT id,num,filename FROM imagerotator ORDER BY num,filename");
      if (db.rs.next()) {
	int key = db.rs.getInt("id");
	select(db, key);
      }
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Constructs given a primary key.
   */
  ImageRotator(DB db, int key) throws SQLException {
    select(db, key);
  }

  /**
   * Constructs given a primary key.
   */
  public ImageRotator(ServletContext context, int key) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      select(db, key);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Populate this instance from a populated ResultSet.
   */
  protected void populate(ResultSet rs) throws SQLException {
    id = rs.getInt("id");
    filename = rs.getString("filename");
    num = rs.getInt("num");
    width = rs.getInt("width");
    height = rs.getInt("height");
    caption = rs.getString("caption");
    alt = rs.getString("alt");
    if (alt==null) alt = "";
    url = rs.getString("url");
  }

  /**
   * Refresh this instance with values from the database record
   */
  protected void refresh(DB db) throws SQLException {
    select(db, id);
  }

  /**
   * Selects a record given a key
   */
  protected void select(DB db, int key) throws SQLException {
    db.executeQuery("SELECT * FROM imagerotator WHERE id="+key);
    if (db.rs.next()) populate(db.rs);
  }

  /**
   * Inserts a imagerotator record with current values. Since name is unique, we can use that as reference.
   */
  protected void insert(DB db) throws SQLException {
    db.executeUpdate("INSERT INTO imagerotator ("+
		     "filename,num,width,height,caption,url,alt"+
		     ") VALUES ("+
		     charsOrNull(filename)+","+intOrNull(num)+","+intOrNull(width)+","+intOrNull(height)+","+charsOrNull(caption)+","+charsOrNull(url)+","+charsOrNull(alt) +
		     ")");
    db.executeQuery("SELECT id FROM imagerotator WHERE filename="+charsOrNull(filename));
    if (db.rs.next()) id = db.rs.getInt("id");
  }

  /**
   * Updates a imagerotator record with current values.
   */
  protected void update(DB db) throws SQLException {
    db.executeUpdate("UPDATE imagerotator SET "+
		     "filename="+charsOrNull(filename)+", "+
		     "num="+intOrNull(num)+", " +
		     "width="+intOrNull(width)+", " +
		     "height="+intOrNull(height)+", " +
		     "caption="+charsOrNull(caption)+", " +
		     "url="+charsOrNull(url)+", " +
		     "alt="+charsOrNull(alt)+" " +
		     "WHERE id="+id);
  }

  /**
   * Deletes this record.
   */
  protected void delete(DB db) throws SQLException {
    db.executeUpdate("DELETE FROM imagerotator WHERE id="+id);
    setDefaults();
  }

  /**
   * Sets default values.
   */
  protected void setDefaults() {
    id = 0;
    filename = null;
    num = 0;
    width = 0;
    height = 0;
    caption = null;
    url = null;
    alt = "";
  }

  /**
   * Return true if this is a default, uninstantiated instance
   */
  public boolean isDefault() {
    return id==0;
  }

  /**
   * Insert an audit record for the given action
   */
  protected void audit(DB db, char action, String username) throws SQLException {
    Audit a = new Audit();
    a.tablename = tablename;
    a.record_id = id;
    a.action = action;
    a.username = username;
    a.description = filename;
    a.insert(db);
  }

  /**
   * Return order based on num
   */
  public int compareTo(Object o) {
    ImageRotator that = (ImageRotator) o;
    return this.num - that.num;
  }

  /**
   * Return true if same primary key
   */
  public boolean equals(Object o) {
    ImageRotator that = (ImageRotator) o;
    return this.id==that.id;
  }

  /**
   * Return an array of all imagerotator records, ordered by num.
   */
  static ImageRotator[] getAll(DB db) throws SQLException {
    db.executeQuery("SELECT count(*) AS count FROM imagerotator");
    db.rs.next();
    int count = db.rs.getInt("count");
    ImageRotator[] ir = new ImageRotator[count];
    if (count>0) {
      db.executeQuery("SELECT * FROM imagerotator ORDER BY num");
      int i = 0;
      while (db.rs.next()) {
	ir[i] = new ImageRotator();
	ir[i].id = db.rs.getInt("id");
	ir[i].filename = db.rs.getString("filename");
	ir[i].num = db.rs.getInt("num");
	ir[i].width = db.rs.getInt("width");
	ir[i].height = db.rs.getInt("height");
	ir[i].caption = db.rs.getString("caption");
	ir[i].url = db.rs.getString("url");
	ir[i].alt = db.rs.getString("alt");
	if (ir[i].alt==null) ir[i].alt = "";
	i++;
      }
    }
    return ir;
  }

  /**
   * Return an array of all imagerotator records, ordered by num.
   */
  public static ImageRotator[] getAll(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return getAll(db);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return the next image in the sequence.
   */
  ImageRotator next(DB db) throws SQLException {
    db.executeQuery("SELECT * FROM imagerotator WHERE id<>"+id+" AND num>="+num+" ORDER BY num");
    if (db.rs.next()) {
      int idNext = db.rs.getInt("id");
      return new ImageRotator(db, idNext);
    } else {
      // go back to the start
      db.executeQuery("SELECT * FROM imagerotator ORDER BY num");
      if (db.rs.next()) {
	int idNext = db.rs.getInt("id");
	return new ImageRotator(db, idNext);
      } else {
	return null;
      }
    }
  }

  /**
   * Return the next image in the sequence.
   */
  public ImageRotator next(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return next(db);
    } finally {
      if (db!=null) db.close();
    }
  }

}

