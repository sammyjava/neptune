package net.ims.jcms.extras;

import net.ims.jcms.*;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.io.FileNotFoundException;
import javax.naming.NamingException;
import javax.servlet.ServletContext;

/**
 * Stock extra that contains posted comments on a given content item.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class Comment extends Record {

  /** the name of the database table, used by audit method */
  private static String tablename = "comments";

  /** comments.comment_id, primary key **/
  public int comment_id = 0;

  /** comments.cid, references content **/
  public int cid = 0;

  /** comments.timeposted **/
  public Timestamp timeposted = null;

  /** comments.name **/
  public String name = null;

  /** comments.email **/
  public String email = null;

  /** comments.comment **/
  public String comment = null;

  /** comments.location **/
  public String location = null;

  /**
   * Constructs an empty record
   */
  public Comment() {
  }

  /**
   * Constructs given a primary key.
   */
  Comment(DB db, int key) throws SQLException {
    select(db, key);
  }

  /**
   * Constructs given a primary key.
   */
  public Comment(ServletContext context, int key) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      select(db, key);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Construct given a ResultSet
   */
  Comment(ResultSet rs) throws SQLException {
    populate(rs);
  }

  /**
   * Populate this instance from a ResultSet
   */
  protected void populate(ResultSet rs) throws SQLException {
    comment_id = rs.getInt("comment_id");
    cid = rs.getInt("cid");
    timeposted = rs.getTimestamp("timeposted");
    name = rs.getString("name");
    email = rs.getString("email");
    comment = rs.getString("comment");
    location = rs.getString("location");
  }

  /**
   * Refresh this instance with values from the database record
   */
  protected void refresh(DB db) throws SQLException {
    select(db, comment_id);
  }

  /**
   * Selects a record given a key
   */
  protected void select(DB db, int key) throws SQLException {
    db.executeQuery("SELECT * FROM comments WHERE comment_id="+key);
    if (db.rs.next()) populate(db.rs);
  }

  /**
   * Validates against missing fields or invalid email.
   */
  void validate() throws ValidationException {
    // check all fields not null or empty
    if (name==null || email==null || comment==null) throw new ValidationException("Name, Email and Comment must all be supplied.");
    if (name.trim().length()==0 || email.trim().length()==0 || comment.trim().length()==0) throw new ValidationException("Name, Email and Comment must all be supplied.");
    // validate email
    if (!Authentication.isValidEmail(email)) throw new ValidationException("The supplied email: "+email+" is invalid.");
  }

  /**
   * Inserts a comments record with current values; use max(comment_id) to get id of inserted record.
   */
  protected void insert(DB db) throws SQLException, ValidationException {
    validate();
    // check that no blacklisted words are included, return quietly if so
    String[] words = getBlacklist(db);
    String c = comment.toLowerCase();
    String n = name.toLowerCase();
    for (int i=0; i<words.length; i++) {
        if (c.contains(words[i])) return;
        if (n.contains(words[i])) return;
    }
    // do the insert
    db.executeUpdate("INSERT INTO comments ("+
		     "cid,name,email,location,comment"+
		     ") VALUES ("+
		     intOrNull(cid)+","+charsOrNull(name)+","+charsOrNull(email)+","+charsOrNull(location)+","+charsOrNull(comment) +
		     ")");
    db.executeQuery("SELECT max(comment_id) AS comment_id FROM comments");
    db.rs.next(); 
    comment_id = db.rs.getInt("comment_id");
    select(db, comment_id);
    try {
      // send email notification
      String recipient = Setting.getString(db, "comments_notify");
      if (Mailer.isValidEmail(recipient)) {
	Mailer mailer = new Mailer();
	String siteName = Setting.getString(db, "site_name");
	Content content = new Content(db, cid);
	String message = "The following comment has been posted to "+siteName+".\n\n";
	message += "Name: "+name+"\n";
	message += "Email: "+email+"\n";
	message += "Location: "+location+"\n";
	message += "re: content item "+content.cid+" - "+content.label+"\n\n";
	message += comment;
	mailer.send(email, name, recipient, "", "Comment posted to "+siteName, message);
      }
    } catch (Exception ex) {
      // cast exception into a ValidationException to satisy Record.insert(DB) definition.
      throw new ValidationException(ex.toString());
    }
  }

  /**
   * Updates a comments record with current values.
   */
  protected void update(DB db) throws SQLException, ValidationException {
    validate();
    db.executeUpdate("UPDATE comments SET "+
		     "name="+charsOrNull(name)+", "+
		     "email="+charsOrNull(email)+", " +
		     "location="+charsOrNull(location)+", " +
		     "comment="+charsOrNull(comment)+" " +
		     "WHERE comment_id="+comment_id);
  }

  /**
   * Deletes this record.
   */
  protected void delete(DB db) throws SQLException {
    db.executeUpdate("DELETE FROM comments WHERE comment_id="+comment_id);
    setDefaults();
  }

  /**
   * Sets default values.
   */
  protected void setDefaults() {
    comment_id = 0;
    name = null;
    email = null;
    comment = null;
    location = null;
  }

  /**
   * Return true if this is a default, uninstantiated instance
   */
  public boolean isDefault() {
    return comment_id==0;
  }

  /**
   * Auditing is enabled only for admin deletion of comments
   */
  protected void audit(DB db, char action, String username) throws SQLException {
    if (action=='D') {
      Audit a = new Audit();
      a.tablename = tablename;
      a.record_id = comment_id;
      a.action = action;
      a.username = username;
      a.description = name+" ("+email+")";
      a.insert(db);
    }
  }

  /**
   * Return order based on time posted.
   */
  public int compareTo(Object o) {
    Comment that = (Comment) o;
    return this.timeposted.compareTo(that.timeposted);
  }

  /**
   * Return true if same primary key
   */
  public boolean equals(Object o) {
    Comment that = (Comment) o;
    return this.comment_id==that.comment_id;
  }

  /**
   * Return an array of all comments records for a given cid, ordered by timeposted.
   */
  public static Comment[] getAll(ServletContext context, int cidMatch) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      db.executeQuery("SELECT count(*) AS count FROM comments WHERE cid="+cidMatch);
      db.rs.next();
      int count = db.rs.getInt("count");
      Comment[] c = new Comment[count];
      int i = 0;
      db.executeQuery("SELECT * FROM comments WHERE cid="+cidMatch+" ORDER BY timeposted");
      while (db.rs.next()) c[i++] = new Comment(db.rs);
      return c;
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return an array of all comments records for a given cid, ordered by DESCENDING timeposted.
   */
  public static Comment[] getAllReversed(ServletContext context, int cidMatch) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      db.executeQuery("SELECT count(*) AS count FROM comments WHERE cid="+cidMatch);
      db.rs.next();
      int count = db.rs.getInt("count");
      Comment[] c = new Comment[count];
      int i = 0;
      db.executeQuery("SELECT * FROM comments WHERE cid="+cidMatch+" ORDER BY timeposted DESC");
      while (db.rs.next()) c[i++] = new Comment(db.rs);
      return c;
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return an array of the most recent num comments for a given cid, ordered by ASCENDING timeposted.
   */
  public static Comment[] getTop(ServletContext context, int cidMatch, int num) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      db.executeQuery("SELECT count(*) AS count FROM comments WHERE cid="+cidMatch);
      db.rs.next();
      int count = db.rs.getInt("count");
      if (count>num) count = num;
      Comment[] c = new Comment[count];
      db.executeQuery("SELECT * FROM comments WHERE cid="+cidMatch+" ORDER BY timeposted DESC LIMIT "+num);
      int i = count;
      while (db.rs.next()) c[--i] = new Comment(db.rs);
      return c;
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return the number of comments for this cid.
   */
  public static int getCount(ServletContext context, int cidMatch) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      db.executeQuery("SELECT count(*) AS count FROM comments WHERE cid="+cidMatch);
      db.rs.next();
      return db.rs.getInt("count");
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return an array of unique Content which has comments associated with it; ordered by comment label
   */
  public static Content[] getContent(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      db.executeQuery("SELECT count(*) AS count FROM (SELECT DISTINCT cid FROM comments) AS foo");
      db.rs.next();
      int count = db.rs.getInt("count");
      Content[] c = new Content[count];
      int i = 0;
      db.executeQuery("SELECT DISTINCT content.* FROM content,comments WHERE content.cid=comments.cid ORDER BY label");
      while (db.rs.next()) c[i++] = new Content(db.rs);
      return c;
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return an array of blacklisted words, sorted alphabetically
   */
  public static String[] getBlacklist(DB db) throws SQLException {
    db.executeQuery("SELECT count(*) AS count FROM commentblacklist");
    db.rs.next();
    String[] words = new String[db.rs.getInt("count")];
    db.executeQuery("SELECT * FROM commentblacklist ORDER BY word");
    int i = 0;
    while (db.rs.next()) words[i++] = db.rs.getString("word");
    return words;
  }

  /**
   * Return an array of blacklisted words, sorted alphabetically
   */
  public static String[] getBlacklist(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return getBlacklist(db);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Add a word to the blacklist
   */
  public static void addToBlacklist(ServletContext context, String word) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      db.executeUpdate("INSERT INTO commentblacklist (word) VALUES ("+charsOrNull(word).toLowerCase()+")");
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Remove a word from the blacklist
   */
  public static void removeFromBlacklist(ServletContext context, String word) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      db.executeUpdate("DELETE FROM commentblacklist WHERE word="+charsOrNull(word));
    } finally {
      if (db!=null) db.close();
    }
  }

}

