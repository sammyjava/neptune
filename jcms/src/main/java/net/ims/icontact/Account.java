package net.ims.icontact;

import java.io.IOException; 
import java.net.MalformedURLException;
import java.net.URL;
import java.text.ParseException;

/**
 * Object which embodies a single Account record.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class Account extends Resource {

  // primary key
  private int accountId;

  // required fields
  public String email;
  public String firstName;
  public String lastName;

  // optional fields
  public String companyName;
  public String title;
  public String street;
  public String city;
  public String postalCode;
  public String billingStreet;
  public String billingCity;
  public String billingState;
  public String billingCountry;
  public String billingPostalCode;
  public String phone;
  public String fax;

  // partner fields
  public int accountType;
  public boolean enabled;
  public boolean multiClientFolder;
  public boolean multiUser;
  public int subscriberLimit;

  /**
   * Instantiate a new Account with the given email address, first name and last name
   * @param email the email address
   * @param firstName the account holder's first name
   * @param lastName the account holder's last name
   */
  public Account(Credentials creds, String email, String firstName, String lastName) throws ValidationException, MalformedURLException, IOException, ParseException, WarningException {
    if (!Credentials.isValidEmail(email)) throw new ValidationException("Invalid email supplied: "+email);
    if (firstName==null) throw new ValidationException("First Name must be supplied.");
    if (lastName==null) throw new ValidationException("Last Name must be supplied.");
    this.email = email;
    this.firstName = firstName;
    this.lastName = lastName;
    create(creds);
  }

  /**
   * Instantiate a new Account with the given Account ID
   * @param pkey the account ID
   */
  public Account(Credentials creds, int pkey) throws ValidationException, MalformedURLException, IOException, ParseException, WarningException {
    get(creds, pkey);
  }

  /**
   * Instantiate this Account using the data contained in the provided XML
   * @param xml the XML data
   */
  public Account(XML xml) throws ParseException, WarningException {
    parseXML(xml);
  }

  /**
   * Return the resource tag
   */
  public String getTag() {
    return "accounts";
  }

  /**
   * Return the primary key accountId value
   * @return accountId value
   */
  public int getPrimaryKey() {
    return accountId;
  }

  /**
   * Parse an XML response into current instance variables.  Missing values will set those variables to null.
   */
  public void parseXML(XML xml) throws ParseException, WarningException {
    String warnings = xml.getWarnings();
    if (warnings!=null) throw new WarningException(warnings);
    accountId = xml.getInt("accountId");
    email = xml.getString("email");
    firstName = xml.getString("firstName");
    lastName = xml.getString("lastName");
    companyName = xml.getString("companyName");
    title = xml.getString("title");
    street = xml.getString("street");
    city = xml.getString("city");
    postalCode = xml.getString("postalCode");
    billingStreet = xml.getString("billingStreet");
    billingCity = xml.getString("billingCity");
    billingState = xml.getString("billingState");
    billingCountry = xml.getString("billingCountry");
    billingPostalCode = xml.getString("billingPostalCode");
    phone = xml.getString("phone");
    fax = xml.getString("fax");
    accountType = xml.getInt("accountType");
    enabled = xml.getBoolean("enabled");
    multiClientFolder = xml.getBoolean("multiClientFolder");
    multiUser = xml.getBoolean("multiUser");
    subscriberLimit = xml.getInt("subscriberLimit");
  }

  /**
   * Generate the XML for this account, only containing non-null fields. Throw ValidationException if email is not present.
   * @return XML block for contact
   */
  public XML getXML() {
    XML xml = new XML();
    xml.openResource("account");
    xml.appendInt("accountId", accountId);
    xml.appendString("email", email);
    xml.appendString("firstName", firstName);
    xml.appendString("lastName", lastName);
    xml.appendString("companyName", companyName);
    xml.appendString("title", title);
    xml.appendString("street", street);
    xml.appendString("city", city);
    xml.appendString("postalCode", postalCode);
    xml.appendString("billingStreet", billingStreet);
    xml.appendString("billingState", billingState);
    xml.appendString("billingCountry", billingCountry);
    xml.appendString("billingPostalCode", billingPostalCode);
    xml.appendString("phone", phone);
    xml.appendString("fax", fax);
    xml.appendInt("accountType", accountType);
    xml.appendBoolean("enabled", enabled);
    xml.appendBoolean("multiClientFolder", multiClientFolder);
    xml.appendBoolean("multiUser", multiUser);
    xml.appendInt("subscriberLimit", subscriberLimit);
    xml.closeResource("account");
    return xml;
  }

  /**
   * Get a new account using the supplied API Credentials.  Sets instance vars if successful.
   */
  public void create(Credentials creds) throws MalformedURLException, IOException, ParseException, WarningException {
    URL url = creds.getURL();
    XML response = creds.doGet(url);
    parseXML(response);
  }

  /**
   * Populate this account using the supplied API Credentials and account ID.
   */
  public void get(Credentials creds, int pkey) throws ValidationException, MalformedURLException, IOException, ParseException, WarningException {
    if (pkey==0) throw new ValidationException("Cannot get account, ID is zero.");
    URL url = creds.getURL(pkey);
    XML response = creds.doGet(url);
    parseXML(response);
  }

}

