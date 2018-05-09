package net.ims.jcms;

import java.io.FileNotFoundException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Date;
import javax.naming.NamingException;
import javax.servlet.ServletContext;

/**
 * Extends Record to contain the data for a single media record.
 * Provides methods for inserting, updating, deleting, validation, and implements the Comparable interface for sorting.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class Media extends Record {

  /** the name of the database table, used by audit method */
  private static String tablename = "media";
 
 /** media.mid: the primary key for this record */
  public int mid = 0;

  /** media.filename: the media file name*/
  public String filename = null;

  /** media.filesize: the size of the media file, in bytes */
  public long filesize = 0;

  /** media.created: the creation timestamp */
  public Timestamp created = null;

  /** media.updated: the update timestamp */
  public Timestamp updated = null;

  /**
   * Construct a default media object
   */
  public Media() {
    setDefaults();
  }

  /**
   * Construct given DB connection and an int primary key
   */
  public Media(DB db, int key) throws SQLException {
    select(db, key);
  }

  /**
   * Construct given a Servlet context and primary key
   */
  public Media(ServletContext context, int key) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      select(db, key);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Construct given DB connection and a filename
   */
  public Media(DB db, String filesearch) throws SQLException {
    select(db, filesearch);
  }

  /**
   * Construct given a Servlet context and a filename
   */
  public Media(ServletContext context, String filesearch) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      select(db, filesearch);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Construct from a populated ResultSet
   */
  public Media(ResultSet rs) throws SQLException {
    populate(rs);
  }

  /**
   * Populate this instance from the given ResultSet
   */
  protected void populate(ResultSet rs) throws SQLException {
    mid = rs.getInt("mid");
    filename = rs.getString("filename");
    filesize = rs.getInt("filesize");
    created = rs.getTimestamp("created");
    updated = rs.getTimestamp("updated");
  }

  /**
   * Refresh this instance with values from the database record
   */
  protected void refresh(DB db) throws SQLException {
    select(db, mid);
  }

  /**
   * Do a SELECT query and set instance variables given a DB connection and a primary key
   */
  protected void select(DB db, int key) throws SQLException {
    db.executeQuery("SELECT * FROM media WHERE mid="+key);
    if (db.rs.next()) populate(db.rs);
  }

  /**
   * Do a SELECT query and set instance variables given a DB connection and a filename
   */
  void select(DB db, String filesearch) throws SQLException {
    db.executeQuery("SELECT * FROM media WHERE filename='"+filesearch+"'");
    if (db.rs.next()) populate(db.rs);
  }

  /**
   * Insert a new media record into the database and retrieve/set the resulting mid.
   */
  protected void insert(DB db) throws SQLException, ValidationException {
    // check for existing media of same filename
    db.executeQuery("SELECT count(*) AS count FROM media WHERE filename="+charsOrNull(filename));
    db.rs.next();
    if (db.rs.getInt("count")>0) throw new ValidationException("ERROR: the uploaded file already exists on the server.  Upload aborted.");
    // insert
    String query = "INSERT INTO media (" +
      "filename, filesize" +
      ") VALUES (" +
      charsOrNull(filename)+"," +
      filesize +
      ")";
    db.executeUpdate(query);
	// refresh
    db.executeQuery("SELECT max(mid) AS mid FROM media");
    db.rs.next();
	mid = db.rs.getInt("mid");
	refresh(db);
  }

  /**
   * Update the media record.  Enforces that new media have same name as previous for this record.
   */
  protected void update(DB db) throws SQLException, ValidationException {
    // check filename is same
    db.executeQuery("SELECT count(*) AS count FROM media WHERE filename="+charsOrNull(filename)+" AND mid="+mid);
    db.rs.next();
    if (db.rs.getInt("count")!=1) throw new ValidationException("ERROR: the uploaded file has a different name from the file on the server.  You must update a file with a file of the same name.  Update aborted.");
    // update
    db.executeUpdate("UPDATE media SET updated="+db.now()+", filename="+charsOrNull(filename)+", filesize="+filesize+" WHERE mid="+mid);
    refresh(db);
  }

  /**
   * Delete the current record, and reset to defaults.  Deletes nodelinks and accessroles_media records due to FK constraint.
   */
  protected void delete(DB db) throws SQLException {
    // delete access role records
    db.executeUpdate("DELETE FROM accessroles_media WHERE mid="+mid);
    // delete nodelinks records
    db.executeUpdate("DELETE FROM nodelinks WHERE mid="+mid);
    // delete media record
    db.executeUpdate("DELETE FROM media WHERE mid="+mid);
    setDefaults();
  }

  /**
   * Set default values when instance does not correspond to a database record (such as after delete() is called
   */
  protected void setDefaults() {
    mid = 0;
    filename = null;
    filesize = 0;
    created = null;
    updated = null;
  }

  /**
   * Return true if this is a default (unpopulated) instance
   */
  public boolean isDefault() {
    return mid==0;
  }

  /**
   * Insert an audit record for the given action
   */
  protected void audit(DB db, char action, String username) throws SQLException {
    Audit a = new Audit();
    a.tablename = tablename;
    a.record_id = mid;
    a.action = action;
    a.username = username;
    a.description = filename;
    a.insert(db);
  }

  /**
   * Comparator for sorting; not implemented since media isn't really comparable.
   */
  public int compareTo(Object o) {
    return 0;
  }

  /**
   * Return true if same primary key
   */
  public boolean equals(Object o) {
    Media that = (Media) o;
    return this.mid==that.mid;
  }

  /**
   * Return media records in an array which match a search term.
   */
  static Media[] getMatching(DB db, String searchterm) throws SQLException {
    db.executeQuery("SELECT count(*) AS count FROM media WHERE filename "+db.iLike()+" '%"+searchterm+"%'");
    db.rs.next();
    int count = db.rs.getInt("count");
    Media[] all = new Media[count];
    int i = 0;
    db.executeQuery("SELECT * FROM media WHERE filename "+db.iLike()+" '%"+searchterm+"%' ORDER BY filename");
    while (db.rs.next()) all[i++] = new Media(db.rs);
    return all;
  }
  
  /**
   * Return media records in an array which match a search term.
   */
  public static Media[] getMatching(ServletContext context, String searchterm) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return getMatching(db, searchterm);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return all media records, ordered alphabetically by filename.
   */
  static Media[] getAll(DB db) throws SQLException {
    db.executeQuery("SELECT count(*) AS count FROM media");
    db.rs.next();
    int count = db.rs.getInt("count");
    Media[] all = new Media[count];
    int i = 0;
    db.executeQuery("SELECT * FROM media ORDER BY filename");
    while (db.rs.next()) all[i++] = new Media(db.rs);
    return all;
  }

  /**
   * Return all media records, ordered alphabetically by filename.
   */
  public static Media[] getAll(ServletContext context) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return getAll(db);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Returns true if this media is not associated with a node.
   */
  boolean isOrphan(DB db) throws SQLException {
    db.executeQuery("SELECT count(*) AS count FROM nodelinks WHERE mid="+mid);
    db.rs.next();
    return (db.rs.getInt("count")==0);
  }

  /**
   * Returns true if this media is not associated with a node.
   */
  public boolean isOrphan(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return isOrphan(db);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Returns an array of orphaned Media mids (media not linked to a node)
   */
  static int[] getOrphanMids(DB db) throws SQLException {
    db.executeQuery("SELECT count(*) AS count FROM media WHERE mid NOT IN (SELECT mid FROM nodelinks WHERE mid IS NOT NULL)");
    db.rs.next();
    int count = db.rs.getInt("count");
    int[] mids = new int[count];
    int i = 0;
    db.executeQuery("SELECT mid FROM media WHERE mid NOT IN (SELECT mid FROM nodelinks WHERE mid IS NOT NULL) ORDER BY mid");
    while (db.rs.next()) {
      mids[i++] = db.rs.getInt("mid");
    }
    return mids;
  }

  /**
   * Returns an array of orphaned Media mids (media not linked to a node)
   */
  public static int[] getOrphanMids(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return getOrphanMids(db);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return an array of Nodes that this Media item is linked to, past, present and future.
   */
  Node[] getNodes(DB db) throws SQLException {
    // get the nid values first, since we only have one db connection
    db.executeQuery("SELECT count(DISTINCT nid) AS count FROM nodelinks WHERE mid="+mid);
    db.rs.next();
    int count = db.rs.getInt("count");
    Node[] nodes = new Node[count];
    if (count>0) {
      int i = 0;
      int[] nids = new int[count];
      db.executeQuery("SELECT DISTINCT nid FROM nodelinks WHERE mid="+mid+" ORDER BY nid");
      while (db.rs.next()) nids[i++] = db.rs.getInt("nid");
      for (i=0; i<nodes.length; i++) nodes[i] = new Node(db, nids[i]);
    }
    return nodes;
  }

  /**
   * Return an array of Nodes that this Media is currently linked to.
   */
  Node[] getCurrentNodes(DB db) throws SQLException {
    // get the nid values first, since we only have one db connection
    db.executeQuery("SELECT count(*) AS count FROM nodelinks_current WHERE mid="+mid);
    db.rs.next();
    int count = db.rs.getInt("count");
    Node[] nodes = new Node[count];
    if (count>0) {
      int[] nids = new int[count];
      db.executeQuery("SELECT nid FROM nodelinks_current WHERE mid="+mid+" ORDER BY nid");
      int i = 0;
      while (db.rs.next()) nids[i++] = db.rs.getInt("nid");
      for (i=0; i<count; i++) nodes[i] = new Node(db, nids[i]); 
    }
    return nodes;
  }

  /**
   * Return an array of Nodes that this Media is currently linked to.
   */
  public Node[] getCurrentNodes(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return getCurrentNodes(db);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return an array of Nodes that this Media is linked to in the future.
   */
  Node[] getFutureNodes(DB db) throws SQLException {
    // get the nid values first, since we only have one db connection
    db.executeQuery("SELECT count(*) AS count FROM nodelinks_future WHERE mid="+mid);
    db.rs.next();
    int count = db.rs.getInt("count");
    Node[] nodes = new Node[count];
    if (count>0) {
      int[] nids = new int[count];
      db.executeQuery("SELECT nid FROM nodelinks_future WHERE mid="+mid+" ORDER BY nid");
      int i = 0;
      while (db.rs.next()) nids[i++] = db.rs.getInt("nid");
      for (i=0; i<count; i++) nodes[i] = new Node(db, nids[i]); 
    }
    return nodes;
  }

  /**
   * Return an array of Nodes that this Media is linked to in the future
   */
  public Node[] getFutureNodes(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return getFutureNodes(db);
    } finally {
      if (db!=null) db.close();
    }
  }



}
