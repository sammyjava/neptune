package net.ims.jcms.extras;

import net.ims.jcms.*;

import java.io.FileNotFoundException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;

import javax.naming.NamingException;
import javax.servlet.ServletContext;

/**
 * Extends Record to contain the data for a single payments record.
 * Provides methods for inserting, updating, deleting, validation, and implements the Comparable interface for sorting.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class Payment extends Record {

  /** the name of the database table, used by audit method */
  private static String tablename = "payments";
 
  /** payments.payment_id: primary key */
  public int payment_id = 0;

  /** payments.title */
  public String title = null;

  /** payments.instructions */
  public String instructions = null;

  /** payments.thankyou - thank-you message */
  public String thankyou = null;

  /** payments.recipientemail - email notification recipient email */
  public String recipientemail = null;

  /** payments.recipientname - email notification recipient name */
  public String recipientname = null;

  /**
   * Construct a default payments object
   */
  public Payment() {
    setDefaults();
  }

  /**
   * Construct given DB connection and an int primary key
   */
  public Payment(DB db, int key) throws SQLException {
    select(db, key);
  }

  /**
   * Construct given a Servlet context and primary key
   */
  public Payment(ServletContext context, int key) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
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
  public Payment(ResultSet rs) throws SQLException {
    populate(rs);
  }

  /**
   * Populate this instance from the given ResultSet
   */
  protected void populate(ResultSet rs) throws SQLException {
    payment_id = rs.getInt("payment_id");
    title = rs.getString("title");
    instructions = rs.getString("instructions");
    thankyou = rs.getString("thankyou");
    recipientemail = rs.getString("recipientemail");
    recipientname = rs.getString("recipientname");
  }

  /**
   * Refresh this instance with values from the database record
   */
  protected void refresh(DB db) throws SQLException {
    select(db, payment_id);
  }

  /**
   * Throw a ValidationException of the instance variables fail validation rules.
   */
  protected void validate() throws ValidationException {
    String error = "";
    if (Util.nullOrEmpty(title)) error += "Payment title is required. ";
    if (Util.nullOrEmpty(instructions)) error += "Payment instructions text is required. ";
    if (Util.nullOrEmpty(thankyou)) error += "Payment thank-you text is required. ";
    if (Util.nullOrEmpty(recipientname)) error += "Notification recipient name is required. ";
    if (!Mailer.isValidEmail(recipientemail)) error += "Notification recipient email is required. ";
    if (error.length()>0) throw new ValidationException(error);
  }

  /**
   * Do a SELECT query and set instance variables given a DB connection and a primary key
   */
  protected void select(DB db, int key) throws SQLException {
    db.executeQuery("SELECT * FROM payments WHERE payment_id="+key);
    if (db.rs.next()) populate(db.rs);
  }

  /**
   * Insert a new payment record into the database and retrieve/set the resulting payment_id.
   */
  protected void insert(DB db) throws SQLException, ValidationException {
    validate();
    instructions = Util.replaceLineBreaks(instructions);
    thankyou = Util.replaceLineBreaks(thankyou);
    String query = "INSERT INTO payments (" +
      "title,instructions,thankyou,recipientname,recipientemail" +
      ") VALUES (" +
      charsOrNull(title)+"," +
      charsOrNull(instructions)+"," +
      charsOrNull(thankyou)+"," +
      charsOrNull(recipientname)+"," +
      charsOrNull(recipientemail) +
      ")";
    db.executeUpdate(query);
    db.executeQuery("SELECT max(payment_id) AS payment_id FROM payments");
    db.rs.next();
    payment_id = db.rs.getInt("payment_id");
    // refresh record to reflect current state
    select(db, payment_id);
  }

  /**
   * Update the payments record.
   */
  protected void update(DB db) throws SQLException, ValidationException {
    validate();
    instructions = Util.replaceLineBreaks(instructions);
    thankyou = Util.replaceLineBreaks(thankyou);
    String query = "UPDATE payments SET " +
      "title="+charsOrNull(title)+"," +
      "instructions="+charsOrNull(instructions)+", " +
      "thankyou="+charsOrNull(thankyou)+", " +
      "recipientname="+charsOrNull(recipientname)+", " +
      "recipientemail="+charsOrNull(recipientemail)+ " " +
      "WHERE payment_id="+payment_id;
    db.executeUpdate(query);
    // refresh record to reflect current state
    select(db, payment_id);
  }

  /**
   * Delete the current record, and reset to defaults.
   */
  protected void delete(DB db) throws SQLException, ValidationException {
    db.executeUpdate("DELETE FROM payments WHERE payment_id="+payment_id);
    setDefaults();
  }

  /**
   * Set default values when instance does not correspond to a database record (such as after delete() is called
   */
  protected void setDefaults() {
    payment_id = 0;
    title = null;
    instructions = null;
    thankyou = null;
    recipientname = null;
    recipientemail = null;
  }

  /**
   * Return true if this is a default (unpopulated) payment
   */
  public boolean isDefault() {
    return payment_id==0;
  }

  /**
   * Insert an audit record for the given action
   */
  protected void audit(DB db, char action, String username) throws SQLException {
    Audit a = new Audit();
    a.tablename = tablename;
    a.record_id = payment_id;
    a.action = action;
    a.username = username;
    a.description = title;
    a.insert(db);
  }

  /**
   * Compare two records based on title
   */
  public int compareTo(Object o) {
    Payment that = (Payment)o;
    return this.title.compareTo(that.title);
  }

  /**
   * Return true if same primary key
   */
  public boolean equals(Object o) {
    Payment that = (Payment) o;
    return this.payment_id==that.payment_id;
  }

  /**
   * Return an array of all payments sorted by title
   */
  public static Payment[] getAll(ServletContext context) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      db.executeQuery("SELECT count(*) AS count FROM payments");
      db.rs.next();
      int count = db.rs.getInt("count");
      Payment[] payments = new Payment[count];
      int i = 0;
      db.executeQuery("SELECT * FROM payments ORDER BY title");
      while (db.rs.next()) payments[i++] = new Payment(db.rs);
      return payments;
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return an array of all paymentoptions associated with this payment, sorted by date DESC, num.
   */
  public PaymentOption[] getOptions(ServletContext context) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      db.executeQuery("SELECT count(*) AS count FROM paymentoptions WHERE payment_id="+payment_id);
      db.rs.next();
      int count = db.rs.getInt("count");
      PaymentOption[] paymentoptions = new PaymentOption[count];
      int i = 0;
      db.executeQuery("SELECT * FROM paymentoptions WHERE payment_id="+payment_id+" ORDER BY num,name");
      while (db.rs.next()) paymentoptions[i++] = new PaymentOption(db.rs);
      return paymentoptions;
    } finally {
      if (db!=null) db.close();
    }
  }

}
