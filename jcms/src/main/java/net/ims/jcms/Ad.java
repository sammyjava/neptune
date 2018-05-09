package net.ims.jcms;

import java.io.FileNotFoundException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Date;

import javax.naming.NamingException;
import javax.servlet.ServletContext;

/**
 * Contains an ad record for the Ads extra.
 * Version 2.0: Moved starttime/endtime from AdPlacmeent, added maxviews.  Ad is active if startime!=null, endtime==null or startime<now<endtime, maxviews==null or views<maxviews.
 *
 * @author Sam Hokin <sam@ims.net>
 * @version 2.00
 */
public class Ad extends Record {

  /** the name of the database table, used by audit method */
  private static String tablename = "ads";

  /** ads.ad_id, primary key **/
  public int ad_id = 0;

  /** Sponsor from ads.sponsor_id, foreign key **/
  public Sponsor sponsor = null;

  /** ads.created **/
  public Timestamp created = null;

  /** ads.url **/
  public String url = null;

  /** ads.imagefile **/
  public String imagefile = null;

  /** ads.imagewidth **/
  public int imagewidth = 0;

  /** ads.imageheight **/
  public int imageheight = 0;

  /** ads.views **/
  public int views = 0;

  /** ads.clicks **/
  public int clicks = 0;

  /** ads.cleared **/
  public Timestamp cleared = null;

  /** ads.starttime; null means inactive **/
  public Timestamp starttime = null;

  /** ads.endtime; default null means unlimited **/
  public Timestamp endtime = null;

  /** ads.maxviews; default 0 means unlimited (ads.maxviews is null) */
  public int maxviews = 0;

  /**
   * Default constructor.
   */
  public Ad() {
    setDefaults();
  }

  /**
   * Constructs given a primary key.
   */
  Ad(DB db, int key) throws SQLException {
    select(db, key);
  }

  /**
   * Constructs given a primary key.
   */
  public Ad(ServletContext context, int key) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      select(db, key);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Select a record given a key
   */
  protected void select(DB db, int key) throws SQLException {
    db.executeQuery("SELECT * FROM ads WHERE ad_id="+key);
    if (db.rs.next()) populate(db.rs);
    // use DB to get sponsor
    int sponsor_id = db.rs.getInt("sponsor_id");
    sponsor = new Sponsor(db, sponsor_id);
  }

  /**
   * Populate given a populated ResultSet. Does NOT set sponsor!
   */
  protected void populate(ResultSet rs) throws SQLException {
    ad_id = rs.getInt("ad_id");
    created = rs.getTimestamp("created");
    url = rs.getString("url");
    imagefile = rs.getString("imagefile");
    imagewidth = rs.getInt("imagewidth");
    imageheight = rs.getInt("imageheight");
    views = rs.getInt("views");
    clicks = rs.getInt("clicks");
    cleared = rs.getTimestamp("cleared");
    starttime = rs.getTimestamp("starttime");
    endtime = rs.getTimestamp("endtime");
    maxviews = rs.getInt("maxviews");
  }

  /**
   * Refresh instance vars from database
   */
  protected void refresh(DB db) throws SQLException {
    select(db, ad_id);
  }

  /**
   * Validate against missing fields
   */
  protected void validate() throws ValidationException {
    // check all fields not null or empty
    if (url==null || url.trim().length()==0) throw new ValidationException("URL was not supplied.");
    if (sponsor==null) throw new ValidationException("Sponsor is not set.");
    if (imagefile==null || imagefile.trim().length()==0 || imagewidth==0 || imageheight==0) throw new ValidationException("Some image data was not supplied.");
  }

  /**
   * Insert a record with current values; use max(ad_id) to get id of inserted record.
   */
  protected void insert(DB db) throws SQLException, ValidationException {
    validate();
    db.executeUpdate("INSERT INTO ads (" +
		     "sponsor_id,url,imagefile,imagewidth,imageheight,starttime,endtime,maxviews" +
		     ") VALUES (" +
		     sponsor.sponsor_id+","+charsOrNull(url)+","+charsOrNull(imagefile)+","+imagewidth+","+imageheight+","+charsOrNull(starttime)+","+charsOrNull(endtime)+","+intOrNull(maxviews) +
		     ")");
    db.executeQuery("SELECT max(ad_id) FROM ads");
    if (db.rs.next()) ad_id = db.rs.getInt("max");
  }

  /**
   * Update a record with current values; cleared timestamp is not updated, use clearCounters() for that.
   */
  protected void update(DB db) throws SQLException, ValidationException {
    validate();
    db.executeUpdate("UPDATE ads SET "+
		     "sponsor_id="+sponsor.sponsor_id+"," +
		     "url="+charsOrNull(url)+"," +
		     "imagefile="+charsOrNull(imagefile)+"," +
		     "imagewidth="+imagewidth+", " +
		     "imageheight="+imageheight+", " +
		     "starttime="+charsOrNull(starttime)+"," +
		     "endtime="+charsOrNull(endtime)+", " +
		     "maxviews="+intOrNull(maxviews)+", " +
		     "views="+views+", " +
		     "clicks="+clicks+" " +
		     "WHERE ad_id="+ad_id);
  }

  /**
   * Update a record with starttime and endtime supplied as strings.
   */
  protected void update(DB db, String starttimeStr, String endtimeStr) throws SQLException, ValidationException {
    validate();
    db.executeUpdate("UPDATE ads SET "+
		     "sponsor_id="+sponsor.sponsor_id+"," +
		     "url="+charsOrNull(url)+"," +
		     "imagefile="+charsOrNull(imagefile)+"," +
		     "imagewidth="+imagewidth+", " +
		     "imageheight="+imageheight+", " +
		     "starttime="+charsOrNull(starttimeStr)+", " +
		     "endtime="+charsOrNull(endtimeStr)+", " +
		     "maxviews="+intOrNull(maxviews)+", " +
		     "views="+views+", " +
		     "clicks="+clicks+" " +
		     "WHERE ad_id="+ad_id);
  }

  /**
   * Update a record with starttime and endtime supplied as strings.
   */
  public void update(ServletContext context, String starttimeStr, String endtimeStr) throws SQLException, ValidationException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      update(db, starttimeStr, endtimeStr);
    } finally {
      if (db!=null) db.close();
    }
  }


  /**
   * Delete this record (and child records) and set instance vars to defaults.
   */
  protected void delete(DB db) throws SQLException {
    db.executeUpdate("DELETE FROM adplacement WHERE ad_id="+ad_id);
    db.executeUpdate("DELETE FROM ads WHERE ad_id="+ad_id);
    setDefaults();
  }

  /**
   * Return true if this is an uninstantiated (default) instance.
   */
  public boolean isDefault() {
    return ad_id==0;
  }

  /**
   * Set instance vars to default values.
   */
  protected void setDefaults() {
    ad_id = 0;
    sponsor = null;
    url = null;
    imagefile = null;
    imagewidth = 0;
    imageheight = 0;
    starttime = null;
    endtime = null;
    maxviews = 0;
  }

  /**
   * AUDITING DISABLED FOR EXTENSIONS
   */
  protected void audit(DB db, char action, String acompany) throws SQLException {
  }

  /**
   * Return order based on sponsor
   */
  public int compareTo(Ad c) {
    return this.sponsor.compareTo(c.sponsor);
  }
  /**
   * Return order based on company
   */
  public int compareTo(Object o) {
    Ad that = (Ad) o;
    return this.compareTo(that);
  }

  /**
   * Return true if same primary key
   */
  public boolean equals(Object o) {
    Ad that = (Ad) o;
    return this.ad_id==that.ad_id;
  }

  /**
   * Increment the view counter.
   */
  protected void incrementViews(DB db) throws SQLException {
    db.executeUpdate("UPDATE ads SET views=views+1 WHERE ad_id="+ad_id);
  }

  /**
   * Increment the view counter.
   */
  public void incrementViews(ServletContext context) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      incrementViews(db);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Increment the click counter.
   */
  protected void incrementClicks(DB db) throws SQLException {
    db.executeUpdate("UPDATE ads SET clicks=clicks+1 WHERE ad_id="+ad_id);
  }

  /**
   * Increment the click counter.
   */
  public void incrementClicks(ServletContext context) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      incrementClicks(db);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Clear the view and click counters.
   */
  protected void clearCounters(DB db) throws SQLException {
    db.executeUpdate("UPDATE ads SET clicks=0, views=0, cleared=now() WHERE ad_id="+ad_id);
  }

  /**
   * Clear the view and click counters.
   */
  public void clearCounters(ServletContext context) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      clearCounters(db);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return the AdPlacements associated with this ad; order by position
   */
  public AdPlacement[] getAdPlacement(DB db) throws SQLException {
    db.executeQuery("SELECT count(*) FROM adplacement WHERE ad_id="+ad_id);
    db.rs.next();
    int count = db.rs.getInt("count");
    AdPlacement[] ap = new AdPlacement[count];
    db.executeQuery("SELECT * FROM adplacement WHERE ad_id="+ad_id+" ORDER BY position,created");
    int i = 0;
    while (db.rs.next()) ap[i++] = new AdPlacement(db.rs);
    return ap;
  }

  /**
   * Return the AdPlacements associated with this ad; order by startime
   */
  public AdPlacement[] getAdPlacement(ServletContext context) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return getAdPlacement(db);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return true if this AdPlacement is currently active.
   */
  public boolean isActive() {
    if (starttime==null) {
      return false;
    } else if (maxviews>0 && views>=maxviews) {
      return false;
    } else {
      // use Date, since it's trickier getting the current time as a Timestamp
      Date now = new Date();
      Date startDate = (Date)starttime;
      if (endtime==null) {
	return (startDate.before(now));
      } else {
	Date endDate = (Date)endtime;
	return (startDate.before(now) && endDate.after(now));
      }
    }
  }

}
