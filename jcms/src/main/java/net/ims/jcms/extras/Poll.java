package net.ims.jcms.extras;

import net.ims.jcms.*;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.io.FileNotFoundException;
import javax.naming.NamingException;
import javax.servlet.ServletContext;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Extends Record to contain the data for a single polls record.  There are two child tables, pollchoices and pollsubmissions, that 
 * this class deals with as well.
 *
 * Provides methods for inserting, updating, deleting, validation, and implements the Comparable interface for sorting.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class Poll extends Record {

  /** the name of the database table, used by audit method */
  private static String tablename = "polls";
 
  /** polls.poll_id: the primary key for this record */
  public int poll_id = 0;

  /** polls.starttime */
  public Timestamp starttime = null;

  /** polls.endtime */
  public Timestamp endtime = null;

  /** polls.label */
  public String label = null;

  /** polls.question */
  public String question = null;

  /** poll choices, sorted by pollchoices.num */
  public Choice[] choices = null;

  /** inner class Choice holds num and choice and tally */
  public class Choice {
    public int id;
    public int num;
    public String value;
    public int tally;
  }

  /** string date format **/
  java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd hh:mm a");

  /**
   * Construct a default instance
   */
  public Poll() {
    setDefaults();
  }

  /**
   * Construct given DB connection and an int primary key
   */
  protected Poll(DB db, int key) throws SQLException {
    select(db, key);
  }

  /**
   * Construct given a ResultSet; have to fill in choices elsewhere!!!
   */
  protected Poll(ResultSet rs) throws SQLException {
    populate(rs);
  }

  /**
   * Construct given a Servlet context and primary key
   */
  public Poll(ServletContext context, int key) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      select(db, key);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Do a SELECT query and set instance variables given a DB connection and a primary key
   */
  protected void select(DB db, int key) throws SQLException {
    db.executeQuery("SELECT * FROM polls WHERE poll_id="+key);
    if (db.rs.next()) populate(db.rs);
    getChoices(db);
  }

  /**
   * Populate this instance with the values from the provided ResultSet.  Have to fill choices elsewhere!
   */
  protected void populate(ResultSet rs) throws SQLException {
    // table vars
    poll_id = rs.getInt("poll_id");
    starttime = rs.getTimestamp("starttime");
    endtime = rs.getTimestamp("endtime");
    question = rs.getString("question");
    label = rs.getString("label");
  }

  /**
   * Refresh this instance with values from the database record
   */
  protected void refresh(DB db) throws SQLException {
    select(db, poll_id);
  }

  /**
   * Load the choices for this poll with a tally of votes per choice.
   */
  void getChoices(DB db) throws SQLException {
    db.executeQuery("SELECT count(*) AS count FROM pollchoices WHERE poll_id="+poll_id);
    db.rs.next();
    int count = db.rs.getInt("count");
    choices = new Choice[count];
    db.executeQuery("SELECT * FROM pollchoices WHERE poll_id="+poll_id+" ORDER BY num");
    int i = 0;
    while (db.rs.next()) {
      choices[i] = new Choice();
      choices[i].id = db.rs.getInt("pollchoice_id");
      choices[i].num = db.rs.getInt("num");
      choices[i].value = db.rs.getString("choice");
      i++;
    }
    for (i=0; i<count; i++) {
      db.executeQuery("SELECT count(*) AS count FROM pollsubmissions WHERE pollchoice_id="+choices[i].id);
      db.rs.next();
      choices[i].tally = db.rs.getInt("count");
    }
  }

  /**
   * Throw a ValidationException of the instance variables fail validation rules.
   */
  protected void validate() throws ValidationException {
    String error = "";
    if (label==null || label.trim().length()==0) error += "Label is required. ";
    if (starttime==null) error += "Start Time is required, in format YYYY-MM-DD HH:MM. ";
    if (endtime==null) error += "End Time is required, in format YYYY-MM-DD HH:MM. ";
    if (question==null || question.trim().length()==0) error += "Poll question is required. ";
    if (error.length()>0) throw new ValidationException(error);
  }

  /**
   * Insert a new poll record into the database and retrieve/set the resulting poll_id.
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
   * Insert a new poll record into the database and retrieve/set the resulting poll_id.
   */
  protected void insert(DB db) throws SQLException, ValidationException {
    validate();
    String query = "INSERT INTO polls (" +
      "starttime,endtime,label,question" +
      ") VALUES (" +
      "'"+starttime+"'," +
      "'"+endtime+"'," +
      charsOrNull(label)+"," +
      charsOrNull(question) +
      ")";
    db.executeUpdate(query);
    db.executeQuery("SELECT max(poll_id) AS poll_id FROM polls");
    db.rs.next();
    poll_id = db.rs.getInt("poll_id");
    select(db, poll_id);
  }

  /**
   * Update the polls record.
   */
  protected void update(DB db) throws SQLException, ValidationException {
    validate();
    String query = "UPDATE polls SET " +
      "starttime='"+starttime+"', " +
      "endtime='"+endtime+"', " +
      "label="+charsOrNull(label)+", " +
      "question="+charsOrNull(question)+" " +
      "WHERE poll_id="+poll_id;
    db.executeUpdate(query);
    select(db, poll_id);
  }

  /**
   * Delete the current record, and reset to defaults.
   */
  protected void delete(DB db) throws SQLException, ValidationException {
    db.executeUpdate("DELETE FROM pollsubmissions WHERE pollchoice_id IN (SELECT pollchoice_id FROM pollchoices WHERE poll_id="+poll_id+")");
    db.executeUpdate("DELETE FROM pollchoices WHERE poll_id="+poll_id);
    db.executeUpdate("DELETE FROM polls WHERE poll_id="+poll_id);
    setDefaults();
  }

  /**
   * Set default values when instance does not correspond to a database record (such as after delete() is called
   */
  protected void setDefaults() {
    poll_id = 0;
    starttime = null;
    endtime = null;
    label = null;
    question = null;
    choices = null;
  }

  /**
   * Return true if this is a default, uninstantiated instance
   */
  public boolean isDefault() {
    return poll_id==0;
  }

  /**
   * Insert an audit record for the given action DISABLED
   */
  protected void audit(DB db, char action, String question) throws SQLException {
  }

  /**
   * Compare two records, use starttime comparison.
   */
  public int compareTo(Object o) {
    Poll that = (Poll) o;
    return this.starttime.compareTo(that.starttime);
  }

  /**
   * Return true if same primary key
   */
  public boolean equals(Object o) {
    Poll that = (Poll) o;
    return this.poll_id==that.poll_id;
  }

  /**
   * Return a standard string form of the start time
   */
  public String getStartTimeString(ServletContext context) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    return formatTimestamp(context, starttime);
  }

  /**
   * Return a standard string form of the end time
   */
  public String getEndTimeString(ServletContext context) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    return formatTimestamp(context, endtime);
  }

  /**
   * Return an array of all polls, sorted by starttime DESC.
   */
  static Poll[] getAll(DB db) throws SQLException {
    db.executeQuery("SELECT count(*) AS count FROM polls");
    db.rs.next();
    int count = db.rs.getInt("count");
    Poll[] polls = new Poll[count];
    int i = 0;
    db.executeQuery("SELECT * FROM polls ORDER BY starttime DESC");
    while (db.rs.next()) polls[i++] = new Poll(db.rs);
    for (i=0; i<polls.length; i++) polls[i].getChoices(db);
    return polls;
  }

  /**
   * Return an array of all polls sorted by name.
   */
  public static Poll[] getAll(ServletContext context) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return getAll(db);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return current poll, default if none is active
   */
  static Poll getCurrent(DB db) throws SQLException {
    Poll poll = new Poll();
    db.executeQuery("SELECT * FROM polls WHERE starttime<now() and endtime>now() ORDER BY starttime DESC");
    if (db.rs.next()) {
      poll = new Poll(db.rs);
      poll.getChoices(db);
    }
    return poll;
  }

  /**
   * Return current poll, default if none is active
   */
  public static Poll getCurrent(ServletContext context) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return getCurrent(db);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Add a choice to this poll at position num; throws SQL exception if num is already taken on this poll
   */
  void addChoice(DB db, int num, String choice) throws SQLException {
    db.executeUpdate("INSERT INTO pollchoices (poll_id,num,choice) VALUES ("+poll_id+","+intOrNull(num)+","+charsOrNull(choice)+")");
    getChoices(db);
  }

  /**
   * Add a choice to this poll at position num; throws SQL exception if num is already taken on this poll
   */
  public void addChoice(ServletContext context, int num, String choice) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      addChoice(db, num, choice);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Update a poll choice; throws an SQL exception if num is already taken on this poll
   */
  void updateChoice(DB db, int pollchoice_id, int num, String choice) throws SQLException {
    db.executeUpdate("UPDATE pollchoices SET num="+intOrNull(num)+", choice="+charsOrNull(choice)+" WHERE pollchoice_id="+intOrNull(pollchoice_id));
    getChoices(db);
  }

  /**
   * Update a poll choice; throws an SQL exception if num is already taken on this poll
   */
  public void updateChoice(ServletContext context, int pollchoice_id, int num, String choice) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      updateChoice(db, pollchoice_id, num, choice);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Remove the given poll choice from a poll, refresh choices.
   */
  void removeChoice(DB db, int pollchoice_id) throws SQLException {
    db.executeUpdate("DELETE FROM pollchoices WHERE pollchoice_id="+pollchoice_id);
    getChoices(db);
  }

  /**
   * Remove a poll choice from this poll at position num.
   */
  public void removeChoice(ServletContext context, int num) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      removeChoice(db, num);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Add a vote to this poll's results at position num.
   */
  void addVote(DB db, int pollchoice_id, String ip) throws SQLException {
    db.executeUpdate("INSERT INTO pollsubmissions (pollchoice_id,ip) VALUES ("+pollchoice_id+","+charsOrNull(ip)+")");
  }

  /**
   * Add a vote to this poll's results at position num, if the poll cookie is not already set.
   */
  public void addVote(HttpServletRequest request, HttpServletResponse response, int pollchoice_id) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    if (request.getCookies()==null || hasCookie(request)) return;
    DB db = null;
    try {
      String ip = request.getRemoteAddr();
      db = new DB(request.getSession().getServletContext());
      addVote(db, pollchoice_id, ip);
      setCookie(response);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return true if the provided request contains a cookie for this poll.
   */
  public boolean hasCookie(HttpServletRequest request) {
    boolean hasit = false;
    String name = "poll_"+poll_id;
    Cookie[] cookies = request.getCookies();
    if (cookies!=null) {
      for (int i=0; i<cookies.length; i++) {
	if (cookies[i].getName().equals(name)) hasit = true;
      }
    }
    return hasit;
  }

  /**
   * Set the cookie for this poll
   */
  public void setCookie(HttpServletResponse response) {
    String name = "poll_"+poll_id;
    String value = "true";
    Cookie cookie = new Cookie(name, value);
    // set 1-yr expiration
    int expiry = 365*24*60*60;
    cookie.setMaxAge(expiry);
    // put in the response
    response.addCookie(cookie);
  }

}
