package net.ims.jcms.extras;

import net.ims.jcms.*;

import java.io.FileNotFoundException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;

import javax.naming.NamingException;
import javax.servlet.ServletContext;

/**
 * Extends Record to contain the data for a single paymentoptions record.
 * Provides methods for inserting, updating, deleting, validation, and implements the Comparable interface for sorting.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class PaymentOption extends Record {

  /** the name of the database table, used by audit method */
  private static String tablename = "paymentoptions";
 
  /** paymentoptions.paymentoption_id: the primary key for this record */
  public int paymentoption_id = 0;

  /** paymentoptions.payment_id: primary key of parent payments record */
  public int payment_id = 0;

  /** paymentoptions.num: used for sorting paymentoptions on the same day */
  public int num = 0;

  /** paymentoptions.amount */
  public double amount = 0.00;

  /** paymentoptions.name: the paymentoption name */
  public String name = null;

  /** paymentoptions.description */
  public String description = null;

  /**
   * Construct a default paymentoptions object
   */
  public PaymentOption() {
    setDefaults();
  }

  /**
   * Construct given DB connection and an int primary key
   */
  public PaymentOption(DB db, int key) throws SQLException {
    select(db, key);
  }

  /**
   * Construct given a Servlet context and primary key
   */
  public PaymentOption(ServletContext context, int key) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
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
  public PaymentOption(ResultSet rs) throws SQLException {
    populate(rs);
  }

  /**
   * Populate this instance from the given ResultSet
   */
  protected void populate(ResultSet rs) throws SQLException {
    paymentoption_id = rs.getInt("paymentoption_id");
    num = rs.getInt("num");
    amount = rs.getDouble("amount");
    name = rs.getString("name");
    description = rs.getString("description");
  }

  /**
   * Refresh this instance with values from the database record
   */
  protected void refresh(DB db) throws SQLException {
    select(db, paymentoption_id);
  }

  /**
   * Throw a ValidationException of the instance variables fail validation rules.
   */
  protected void validate() throws ValidationException {
    String error = "";
    if (num<=0) error += "Payment option num must be a positive number. ";
    if (Util.nullOrEmpty(name)) error += "Payment option name is required. ";
    if (error.length()>0) throw new ValidationException(error);
  }

  /**
   * Do a SELECT query and set instance variables given a DB connection and a primary key
   */
  protected void select(DB db, int key) throws SQLException {
    db.executeQuery("SELECT * FROM paymentoptions WHERE paymentoption_id="+key);
    if (db.rs.next()) populate(db.rs);
  }

  /**
   * Insert a new paymentoption record into the database and retrieve/set the resulting paymentoption_id.
   */
  protected void insert(DB db) throws SQLException, ValidationException {
    validate();
    description = Util.replaceLineBreaks(description);
    String query = "INSERT INTO paymentoptions (" +
      "payment_id,num,amount,name,description" +
      ") VALUES (" +
      intOrNull(payment_id)+"," +
      intOrNull(num)+"," +
      amount+"," +
      charsOrNull(name)+"," +
      charsOrNull(description) +
      ")";
    db.executeUpdate(query);
    db.executeQuery("SELECT max(paymentoption_id) AS paymentoption_id FROM paymentoptions");
    db.rs.next();
    paymentoption_id = db.rs.getInt("paymentoption_id");
    // refresh record to reflect current state
    select(db, paymentoption_id);
  }

  /**
   * Update the paymentoptions record.
   */
  protected void update(DB db) throws SQLException, ValidationException {
    validate();
    description = Util.replaceLineBreaks(description);
    String query = "UPDATE paymentoptions SET " +
      "num="+intOrNull(num)+"," +
      "amount="+amount+"," +
      "name="+charsOrNull(name)+"," +
      "description="+charsOrNull(description)+" " +
      "WHERE paymentoption_id="+paymentoption_id;
    db.executeUpdate(query);
    // refresh record to reflect current state
    select(db, paymentoption_id);
  }

  /**
   * Delete the current record, and reset to defaults.
   */
  protected void delete(DB db) throws SQLException, ValidationException {
    db.executeUpdate("DELETE FROM paymentoptions WHERE paymentoption_id="+paymentoption_id);
    setDefaults();
  }

  /**
   * Set default values when instance does not correspond to a database record (such as after delete() is called
   */
  protected void setDefaults() {
    paymentoption_id = 0;
    num = 0;
    amount = 0.00;
    name = null;
    description = null;
  }

  /**
   * Return true if this is a default, uninstantiated instance
   */
  public boolean isDefault() {
    return paymentoption_id==0;
  }

  /**
   * Insert an audit record for the given action
   */
  protected void audit(DB db, char action, String username) throws SQLException {
    Audit a = new Audit();
    a.tablename = tablename;
    a.record_id = paymentoption_id;
    a.action = action;
    a.username = username;
    a.description = name;
    a.insert(db);
  }

  /**
   * Compare two records based on date, num, name
   */
  public int compareTo(Object o) {
    PaymentOption that = (PaymentOption)o;
    if (this.num==that.num) {
      return this.name.compareTo(that.name);
    } else {
      return this.num - that.num;
    }
  }

  /**
   * Return true if same primary key
   */
  public boolean equals(Object o) {
    PaymentOption that = (PaymentOption) o;
    return this.paymentoption_id==that.paymentoption_id;
  }


}
