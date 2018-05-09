package net.ims.jcms;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.io.FileNotFoundException;
import javax.naming.NamingException;
import javax.servlet.ServletContext;

/**
 * Contains a sponsor record for the Ads extra.
 *
 * @author Sam Hokin <sam@ims.net>
 * @version 1.00
 */
public class Sponsor extends Record {

  /** the name of the database table, used by audit method */
  private static String tablename = "sponsors";

  /** sponsors.sponsor_id, primary key **/
  public int sponsor_id = 0;

  /** sponsors.created **/
  public Timestamp created = null;

  /** sponsors.company **/
  public String company = null;

  /**
   * Default constructor
   */
  public Sponsor() {
    setDefaults();
  }

  /**
   * Constructs given a primary key.
   */
  Sponsor(DB db, int key) throws SQLException {
    select(db, key);
  }

  /**
   * Constructs given a primary key.
   */
  public Sponsor(ServletContext context, int key) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      select(db, key);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Selects a record given a key
   */
  protected void select(DB db, int key) throws SQLException {
    db.executeQuery("SELECT * FROM sponsors WHERE sponsor_id="+key);
    if (db.rs.next()) populate(db.rs);
  }

  /**
   * Populate instance from a populated ResultSet.
   */
  protected void populate(ResultSet rs) throws SQLException {
    sponsor_id = rs.getInt("sponsor_id");
    created = rs.getTimestamp("created");
    company = rs.getString("company");
  }

  /**
   * Refresh instance vars from database
   */
  protected void refresh(DB db) throws SQLException {
    select(db, sponsor_id);
  }

  /**
   * Validates against missing fields
   */
  protected void validate() throws ValidationException {
    // check all fields not null or empty
    if (company==null) throw new ValidationException("Sponsor company must be supplied.");
    if (company.trim().length()==0) throw new ValidationException("Sponsor company must be supplied.");
  }

  /**
   * Inserts a sponsors record with current values; use max(sponsor_id) to get id of inserted record.
   */
  protected void insert(DB db) throws SQLException, ValidationException {
    validate();
    db.executeUpdate("INSERT INTO sponsors (company) VALUES ("+charsOrNull(company)+")");
    db.executeQuery("SELECT max(sponsor_id) FROM sponsors");
    if (db.rs.next()) sponsor_id = db.rs.getInt("max");
  }

  /**
   * Updates a sponsors record with current values.
   */
  protected void update(DB db) throws SQLException, ValidationException {
    validate();
    db.executeUpdate("UPDATE sponsors SET "+
		     "company="+charsOrNull(company)+" " +
		     "WHERE sponsor_id="+sponsor_id);
  }

  /**
   * Deletes this record.
   */
  protected void delete(DB db) throws SQLException {
    db.executeUpdate("DELETE FROM sponsors WHERE sponsor_id="+sponsor_id);
    setDefaults();
  }

  /**
   * Return true if this is an uninstantiated (default) instance.
   */
  public boolean isDefault() {
    return sponsor_id==0;
  }

  /**
   * Sets default values.
   */
  protected void setDefaults() {
    sponsor_id = 0;
    company = null;
    created = null;
  }

  /**
   * AUDITING DISABLED FOR EXTENSIONS
   */
  protected void audit(DB db, char action, String acompany) throws SQLException {
  }

  /**
   * Return order based on company
   */
  public int compareTo(Sponsor c) {
    return this.company.compareTo(c.company);
  }

  /**
   * Return order based on company
   */
  public int compareTo(Object o) {
    Sponsor that = (Sponsor) o;
    return this.compareTo(that);
  }

  /**
   * Return true if same primary key
   */
  public boolean equals(Object o) {
    Sponsor that = (Sponsor) o;
    return this.sponsor_id==that.sponsor_id;
  }

  /**
   * Return array of all sponsors, alpha sorted by company
   */
  public static Sponsor[] getAll(DB db) throws SQLException {
    db.executeQuery("SELECT count(*) FROM sponsors");
    db.rs.next();
    int count = db.rs.getInt("count");
    int sponsor_ids[] = new int[count];
    Sponsor sponsors[] = new Sponsor[count];
    db.executeQuery("SELECT * FROM sponsors ORDER BY company");
    int i = 0;
    while (db.rs.next()) sponsor_ids[i++] = db.rs.getInt("sponsor_id");
    for (i=0; i<sponsor_ids.length; i++) sponsors[i] = new Sponsor(db,sponsor_ids[i]);
    return sponsors;
  }

  /**
   * Return array of all sponsors, alpha sorted by company
   */
  public static Sponsor[] getAll(ServletContext context) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return getAll(db);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return array of all Ads for this Sponsor, sorted by imagefile.
   */
  public Ad[] getAds(DB db) throws SQLException {
    db.executeQuery("SELECT count(*) FROM ads WHERE sponsor_id="+sponsor_id);
    db.rs.next();
    int count = db.rs.getInt("count");
    int ad_ids[] = new int[count];
    Ad ads[] = new Ad[count];
    db.executeQuery("SELECT * FROM ads WHERE sponsor_id="+sponsor_id+" ORDER BY imagefile");
    int i = 0;
    while (db.rs.next()) ad_ids[i++] = db.rs.getInt("ad_id");
    for (i=0; i<ad_ids.length; i++) ads[i] = new Ad(db,ad_ids[i]);
    return ads;
  }

  /**
   * Return array of all Ads for this Sponsor, sorted by imagefile.
   */
  public Ad[] getAds(ServletContext context) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return getAds(db);
    } finally {
      if (db!=null) db.close();
    }
  }


}
