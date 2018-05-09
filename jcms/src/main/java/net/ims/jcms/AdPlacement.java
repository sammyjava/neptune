package net.ims.jcms;

import java.io.FileNotFoundException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import javax.naming.NamingException;
import javax.servlet.ServletContext;

/**
 * Associates an ad with a layout pane.
 * Version 1.1: Use new position field to place the ad within that pane.
 * Version 2.0: Moved starttime/endtime to Ad, which also has maxviews now.
 *
 * @author Sam Hokin <sam@ims.net>
 * @version 2.0
 */
public class AdPlacement extends Record {

  /** the name of the database table, used by audit method */
  private static String tablename = "adplacement";

  /** primary key adplacement.adplacement_id **/
  public int adplacement_id = 0;
  
  /** foreign key adplacement.ad_id **/
  public int ad_id = 0;

  /** adplacement.layoutpane_id = layoutpanes.layoutpane_id **/
  public int layoutpane_id = 0;

  /** adplacement.position **/
  public int position = 0;

  /** adplacement.created **/
  public Timestamp created = null;

  /**
   * Default constructor.
   */
  public AdPlacement() {
    setDefaults();
  }

  /**
   * Construct given a primary key.
   */
  AdPlacement(DB db, int key) throws SQLException {
    select(db, key);
  }

  /**
   * Construct given a primary key.
   */
  public AdPlacement(ServletContext context, int key) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
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
   * Construct given a populated ResultSet
   */
  public AdPlacement(ResultSet rs) throws SQLException {
    populate(rs);
  }

  /**
   * Select a record given a key
   */
  protected void select(DB db, int key) throws SQLException {
    db.executeQuery("SELECT * FROM adplacement WHERE adplacement_id="+key);
    if (db.rs.next()) populate(db.rs);
  }

  /**
   * Populate given a populated ResultSet
   */
  protected void populate(ResultSet rs) throws SQLException {
    adplacement_id = rs.getInt("adplacement_id");
    ad_id = rs.getInt("ad_id");
    layoutpane_id = rs.getInt("layoutpane_id");
    position = rs.getInt("position");
    created = rs.getTimestamp("created");
  }

  /**
   * Refresh instance vars from database
   */
  protected void refresh(DB db) throws SQLException {
    select(db, adplacement_id);
  }

  /**
   * Validate against missing fields
   */
  protected void validate() throws ValidationException {
    // check all fields not null or empty
    if (ad_id==0) throw new ValidationException("Ad is not supplied for ad placement.");
    if (layoutpane_id==0) throw new ValidationException("Ad placement layout is not specified.");
    if (position==0) throw new ValidationException("You must select a nonzero position for placement of this ad.");
  }

  /**
   * Insert a record with current values; use max(adplacement_id) to get id of inserted record.
   */
  protected void insert(DB db) throws SQLException, ValidationException {
    validate();
    db.executeUpdate("INSERT INTO adplacement (ad_id,layoutpane_id,position) VALUES ("+ad_id+","+layoutpane_id+","+position+")");
    db.executeQuery("SELECT max(adplacement_id) FROM adplacement");
    if (db.rs.next()) adplacement_id = db.rs.getInt("max");
  }

  /**
   * Update a record with current values.
   */
  protected void update(DB db) throws SQLException, ValidationException {
    validate();
    db.executeUpdate("UPDATE adplacement SET "+
		     "ad_id="+ad_id+"," +
		     "layoutpane_id="+layoutpane_id+"," +
		     "position="+position+" " +
		     "WHERE adplacement_id="+adplacement_id);
  }

  /**
   * Delete this record and set instance vars to defaults.
   */
  protected void delete(DB db) throws SQLException {
    db.executeUpdate("DELETE FROM adplacement WHERE adplacement_id="+adplacement_id);
    setDefaults();
  }

  /**
   * Return true if this is an uninstantiated (default) instance.
   */
  public boolean isDefault() {
    return adplacement_id==0;
  }

  /**
   * Set instance vars to default values.
   */
  protected void setDefaults() {
    adplacement_id = 0;
    ad_id = 0;
    layoutpane_id = 0;
    position = 0;
    created = null;
  }

  /**
   * AUDITING DISABLED FOR EXTENSIONS
   */
  protected void audit(DB db, char action, String acompany) throws SQLException {
  }

  /**
   * Return order based on position
   */
  public int compareTo(AdPlacement ap) {
    return this.position - ap.position;
  }

  /**
   * Return order based on position
   */
  public int compareTo(Object o) {
    AdPlacement that = (AdPlacement) o;
    return this.compareTo(that);
  }

  /**
   * Return true if same primary key
   */
  public boolean equals(Object o) {
    AdPlacement that = (AdPlacement) o;
    return this.adplacement_id==that.adplacement_id;
  }

  /**
   * Return the count of active ads on this AdPlacement.
   */
  protected int getAdCount(DB db) throws SQLException {
    return getAdCount(db, layoutpane_id, position);
  }

  /**
   * Return the count of active ads on this AdPlacement.
   */
  public int getAdCount(ServletContext context) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return getAdCount(db);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Static version; returns count of active ads place on supplied layout pane and position.
   */
  protected static int getAdCount(DB db, int layoutpane_id, int position) throws SQLException {
    // first get all the ads in this layoutpane/position
    db.executeQuery("SELECT count(*) AS count FROM ads,adplacement WHERE starttime IS NOT NULL AND starttime<now() AND (endtime IS NULL OR endtime>now()) AND (maxviews IS NULL OR views<maxviews) AND ads.ad_id=adplacement.ad_id AND layoutpane_id="+layoutpane_id+" AND position="+position);
    db.rs.next();
    return db.rs.getInt("count");
  }

  /**
   * Static version; returns count of active ads placed on supplied layout pane and position.
   */
  public static int getAdCount(ServletContext context, int layoutpane_id, int position) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return getAdCount(db, layoutpane_id, position);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return the next AdPlacement for the supplied layout pane and position; null if none scheduled.  Automatically updates the "shown" field.  NEEDS WORK!!!
   */
  protected static AdPlacement next(DB db, int layoutpane_id, int position) throws SQLException {
    int adplacement_id = 0;
    db.executeQuery("SELECT adplacement_id FROM ads,adplacement WHERE shown IS NULL AND starttime IS NOT NULL AND starttime<now() AND (endtime IS NULL OR endtime>now()) AND (maxviews IS NULL OR views<maxviews) AND ads.ad_id=adplacement.ad_id AND layoutpane_id="+layoutpane_id+" AND position="+position);
    if (db.rs.next()) {
      // unshown ad goes first
      adplacement_id = db.rs.getInt("adplacement_id");
    } else {
      // get ad shown longest ago
      db.executeQuery("SELECT adplacement_id FROM ads,adplacement WHERE starttime IS NOT NULL AND starttime<now() AND (endtime IS NULL OR endtime>now()) AND (maxviews IS NULL OR views<maxviews) AND ads.ad_id=adplacement.ad_id AND layoutpane_id="+layoutpane_id+" AND position="+position+" ORDER BY shown");
      if (db.rs.next()) adplacement_id = db.rs.getInt("adplacement_id");
    }
    if (adplacement_id>0) {
      db.executeUpdate("UPDATE adplacement SET shown=now() WHERE adplacement_id="+adplacement_id);
      return new AdPlacement(db, adplacement_id);
    } else {
      return null;
    }
  }

  /**
   * Return the next AdPlacement on the supplied layout pane and position; null if none scheduled.  Automatically updates the "shown" field.
   */
  public static AdPlacement next(ServletContext context, int layoutpane_id, int position) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return next(db, layoutpane_id, position);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return an array of all active AdPlacements on the given layout pane.
   */
  protected static AdPlacement[] getAll(DB db, int layoutpane_id) throws SQLException {
    db.executeQuery("SELECT count(*) AS count FROM ads,adplacement WHERE starttime IS NOT NULL AND starttime<now() AND (endtime IS NULL OR endtime>now()) AND (maxviews IS NULL OR views<maxviews) AND ads.ad_id=adplacement.ad_id AND layoutpane_id="+layoutpane_id);
    db.rs.next();
    int count = db.rs.getInt("count");
    AdPlacement[] adplacements = new AdPlacement[count];
    db.executeQuery("SELECT adplacement.* FROM ads,adplacement WHERE starttime IS NOT NULL AND starttime<now() AND (endtime IS NULL OR endtime>now()) AND (maxviews IS NULL OR views<maxviews) AND ads.ad_id=adplacement.ad_id AND layoutpane_id="+layoutpane_id+" ORDER BY created");
    int i = 0;
    while (db.rs.next()) adplacements[i++] = new AdPlacement(db.rs);
    return adplacements;
  }

  /**
   * Return an array of all active AdPlacements on the given layout pane.
   */
  public static AdPlacement[] getAll(ServletContext context, int layoutpane_id) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return getAll(db, layoutpane_id);
    } finally {
      if (db!=null) db.close();
    }
  }


}
