package net.ims.jcms.extras;

import net.ims.jcms.*;

import java.io.FileNotFoundException;
import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;

import javax.naming.NamingException;
import javax.servlet.ServletContext;

/**
 * Extends Record to contain the data for a single events
 * Provides methods for inserting, updating, deleting, validation, and implements the Comparable interface for sorting.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class Event extends Record {

  /** the name of the database table, used by audit method */
  private static String tablename = "events";
 
 /** events.event_id: the primary key for this record */
  public int event_id = 0;

  /** events.num: used for sorting events on the same day */
  public int num = 0;

  /** events.title: the event title */
  public String title = null;

  /** events.description */
  public String description = null;

  /** events.date */
  public Date date = null;

  /** used for date input for updates and inserts */
  public String dateStr = null;

  /** events.time */
  public String time = null;

  /** events.url */
  public String url = null;

  /** the max number of events to show in the RSS feed */
  private static int RSSMAX = 20;

  /**
   * Construct a default events object
   */
  public Event() {
    setDefaults();
  }

  /**
   * Construct given DB connection and an int primary key
   */
  public Event(DB db, int key) throws SQLException {
    select(db, key);
  }

  /**
   * Construct given a Servlet context and primary key
   */
  public Event(ServletContext context, int key) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      select(db, key);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Construct from a populated ResultSet
   */
  public Event(ResultSet rs) throws SQLException {
    populate(rs);
  }

  /**
   * Populate this instance from the given ResultSet
   */
  protected void populate(ResultSet rs) throws SQLException {
    event_id = rs.getInt("event_id");
    num = rs.getInt("num");
    title = rs.getString("title");
    description = rs.getString("description");
    date = rs.getDate("date");
    dateStr = rs.getString("date");
    time = rs.getString("time");
    url = rs.getString("url");
  }

  /**
   * Refresh this instance with values from the database record
   */
  protected void refresh(DB db) throws SQLException {
    select(db, event_id);
  }

  /**
   * Throw a ValidationException of the instance variables fail validation rules.
   */
  protected void validate() throws ValidationException {
    String error = "";
    if (dateStr==null || dateStr.trim().equals("")) error += "Date is required. ";
    if (title==null || title.trim().equals("")) error += "Title is required. ";
    if (error.length()>0) throw new ValidationException(error);
  }

  /**
   * Do a SELECT query and set instance variables given a DB connection and a primary key
   */
  protected void select(DB db, int key) throws SQLException {
    db.executeQuery("SELECT * FROM events WHERE event_id="+key);
    if (db.rs.next()) populate(db.rs);
  }

  /**
   * Insert a new event record into the database and retrieve/set the resulting event_id.
   */
  protected void insert(DB db) throws SQLException, ValidationException {
    validate();
    description = Util.replaceLineBreaks(description);
    String query = "INSERT INTO events (" +
      "num,title,description,date,time,url" +
      ") VALUES (" +
      intOrNull(num)+"," +
      charsOrNull(title)+"," +
      charsOrNull(description)+"," +
      charsOrNull(dateStr)+"," +
      charsOrNull(time)+"," +
      charsOrNull(url) +
      ")";
    db.executeUpdate(query);
    db.executeQuery("SELECT max(event_id) AS event_id FROM events");
    db.rs.next();
    event_id = db.rs.getInt("event_id");
    // refresh record to reflect current state
    select(db, event_id);
  }

  /**
   * Update the events record.
   */
  protected void update(DB db) throws SQLException, ValidationException {
    validate();
    description = Util.replaceLineBreaks(description);
    String query = "UPDATE events SET " +
      "num="+intOrNull(num)+"," +
      "title="+charsOrNull(title)+"," +
      "description="+charsOrNull(description)+"," +
      "date="+charsOrNull(dateStr)+"," +
      "time="+charsOrNull(time)+"," +
      "url="+charsOrNull(url)+" " +
      "WHERE event_id="+event_id;
    db.executeUpdate(query);
    // refresh record to reflect current state
    select(db, event_id);
  }

  /**
   * Delete the current record, and reset to defaults.
   */
  protected void delete(DB db) throws SQLException, ValidationException {
    db.executeUpdate("DELETE FROM events WHERE event_id="+event_id);
    setDefaults();
  }

  /**
   * Set default values when instance does not correspond to a database record (such as after delete() is called
   */
  protected void setDefaults() {
    event_id = 0;
    num = 0;
    title = null;
    description = null;
    date = null;
    dateStr = null;
    time = null;
    url = null;
  }

  /**
   * Return true if this is a default, uninstantiated instance
   */
  public boolean isDefault() {
    return event_id==0;
  }

  /**
   * Insert an audit record for the given action
   */
  protected void audit(DB db, char action, String username) throws SQLException {
    Audit a = new Audit();
    a.tablename = tablename;
    a.record_id = event_id;
    a.action = action;
    a.username = username;
    a.description = dateStr+": "+title;
    a.insert(db);
  }

  /**
   * Compare two records based on date, num, title
   */
  public int compareTo(Object o) {
    Event that = (Event)o;
    if (this.date.equals(that.date)) {
      if (this.num==that.num) {
	return this.title.compareTo(that.title);
      } else {
	return this.num - that.num;
      }
    } else {
      return this.date.compareTo(that.date);
    }
  }

  /**
   * Return true if same primary key
   */
  public boolean equals(Object o) {
    Event that = (Event) o;
    return this.event_id==that.event_id;
  }

  /**
   * Return events records in an array which titles match a search term.
   */
  public static Event[] getMatching(ServletContext context, String searchterm) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      db.executeQuery("SELECT count(*) AS count FROM events WHERE title "+db.iLike()+" '%"+searchterm+"%'");
      db.rs.next();
      int count = db.rs.getInt("count");
      Event[] all = new Event[count];
      int i = 0;
      db.executeQuery("SELECT * FROM events WHERE title "+db.iLike()+" '%"+searchterm+"%' ORDER BY title");
      while (db.rs.next()) all[i++] = new Event(db.rs);
      return all;
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return an array of all events sorted by date DESC, num, title
   */
  public static Event[] getAll(ServletContext context) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      db.executeQuery("SELECT count(*) AS count FROM events");
      db.rs.next();
      int count = db.rs.getInt("count");
      Event[] events = new Event[count];
      int i = 0;
      db.executeQuery("SELECT * FROM events ORDER BY date DESC,num DESC,time DESC,title");
      while (db.rs.next()) events[i++] = new Event(db.rs);
      return events;
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return an array of all upcoming events, including today, sorted by date, num, title, all ascending
   */
  public static Event[] getUpcoming(ServletContext context) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      db.executeQuery("SELECT count(*) AS count FROM events WHERE date>=date_trunc('day',now())");
      db.rs.next();
      int count = db.rs.getInt("count");
      Event[] events = new Event[count];
      int i = 0;
      db.executeQuery("SELECT * FROM events WHERE date>=date_trunc('day',now()) ORDER BY date,num,title");
      while (db.rs.next()) events[i++] = new Event(db.rs);
      return events;
    } finally {
      if (db!=null) db.close();
    }
  }
  

  /**
   * Return an array of all events with date in the given year, month (0-11)
   */
  public static Event[] getForMonth(ServletContext context, int year, int month) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      db.executeQuery("SELECT count(*) AS count FROM events WHERE extract(year from date)="+year+" AND extract(month from date)="+(month+1));
      db.rs.next();
      int count = db.rs.getInt("count");
      Event[] events = new Event[count];
      int i = 0;
      db.executeQuery("SELECT * FROM events WHERE extract(year from date)="+year+" AND extract(month from date)="+(month+1)+" ORDER BY date,num,time,title");
      while (db.rs.next()) events[i++] = new Event(db.rs);
      return events;
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return an array of events for the given date (yyyy-mm-dd)
   */
  public static Event[] getForDate(DB db, String dateStr) throws SQLException {
    db.executeQuery("SELECT count(*) AS count FROM events WHERE date='"+dateStr+"'");
    db.rs.next();
    int count = db.rs.getInt("count");
    Event[] events = new Event[count];
    int i = 0;
    db.executeQuery("SELECT * FROM events WHERE date='"+dateStr+"' ORDER BY num,time,title");
    while (db.rs.next()) events[i++] = new Event(db.rs);
    return events;
  }

  /**
   * Return an array of events for the given date (yyyy-mm-dd)
   */
  public static Event[] getForDate(ServletContext context, String dateStr) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return getForDate(db, dateStr);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return an array of events for the RSS feed (from input date out to future, plus past events if less than RSSMAX)
   */
  public static Event[] getForRSS(ServletContext context, String dateStr) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      db.executeQuery("SELECT count(*) AS count FROM events WHERE date>='"+dateStr+"'");
      db.rs.next();
      int count = db.rs.getInt("count");
      if (count>=RSSMAX) {
	// show current and future events by increasing date
	Event[] events = new Event[RSSMAX];
	db.executeQuery("SELECT * FROM events WHERE date>='"+dateStr+"' ORDER BY date,num,time");
	int i = 0;
	while (db.rs.next() && i<RSSMAX) events[i++] = new Event(db.rs);
	return events;
      } else {
	// show latest events, including past events, by decreasing date
	db.executeQuery("SELECT count(*) AS count FROM events");
	db.rs.next();
	count = db.rs.getInt("count");
	if (count>RSSMAX) count = RSSMAX;
	Event[] events = new Event[count];
	db.executeQuery("SELECT * FROM events ORDER BY date DESC,num DESC,time DESC");
	int i = 0;
	while (db.rs.next() && i<count) events[i++] = new Event(db.rs);
	return events;
      }
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return the HTML content for a day's events.  This is here for convenience, it's clumsy in the calling JSP.
   */
  public static String getWindowContent(ServletContext context, Date date, SimpleDateFormat dateFormat) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      // get the events for the requested date
      Event[] events = Event.getForDate(db, date.toString());
      String content = "";
      for (int i=0; i<events.length; i++) {
	content += "<div class=\"event\">";
	content += "<div class=\"event-title\">";
	if (events[i].url==null) {
	  content += events[i].title;
	} else {
	  content += "<a class=\"event\" href=\""+events[i].url+"\">"+events[i].title+"</a>";
	}
	content += "</div>";
	content += "<div class=\"event-time\">"+dateFormat.format(events[i].date)+": "+events[i].time+"</div>";
	content += "<div class=\"event-description\">"+events[i].description+"</div>";
	content += "</div>";
      }
      return content;
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return the minimum year in the database
   */
  public static int getYearMin(ServletContext context) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      db.executeQuery("SELECT extract(year FROM min(date)) AS year FROM events");
      if (db.rs.next()) {
	return db.rs.getInt("year");
      } else {
	return 0; // no events
      }
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return the maximum year in the database
   */
  public static int getYearMax(ServletContext context) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      db.executeQuery("SELECT extract(year FROM max(date)) AS year FROM events");
      if (db.rs.next()) {
	return db.rs.getInt("year");
      } else {
	return 0; // no events
      }
    } finally {
      if (db!=null) db.close();
    }
  }

}
