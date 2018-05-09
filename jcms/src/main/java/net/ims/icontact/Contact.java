package net.ims.icontact;

import java.net.MalformedURLException;
import java.text.ParseException;
import java.util.Date;

/**
 * Object which embodies a single Contact record.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class Contact extends Resource {

  // primary key
  private int contactId = 0;

  // required fields
  public String email;

  // optional fields
  public String prefix;
  public String firstName;
  public String lastName;
  public String suffix;
  public String street;
  public String street2;
  public String city;
  public String state;
  public String postalCode;
  public String phone;
  public String fax;
  public String business;
  
  // subscription status: normal/bounced/donotcontact/pending/invitable/deleted
  public String status;

  // receive-only fields
  public Date createDate;
  public int bounceCount;

  /**
   * Instantiate a new Contact with the given email address
   * @param email the email address
   */
  public Contact(Credentials creds, Account account, ClientFolder clientFolder, String email) throws ValidationException, ResourceNotFoundException, MalformedURLException, ParseException, WarningException {
    if (!Credentials.isValidEmail(email)) throw new ValidationException("Invalid email supplied: "+email);
    this.email = email;
    create(creds, account, clientFolder);
  }

  /**
   * Retrieve a single Contact with the given primary key
   */
  public Contact(Credentials creds, Account account, ClientFolder clientFolder, int pkey) throws ValidationException, ResourceNotFoundException, MalformedURLException, ParseException, WarningException {
    if (pkey==0) throw new ValidationException("Supplied contact ID is zero.");
    get(creds, account, clientFolder, pkey);
  }

  /**
   * Instantiate using the data contained in the provided XML
   * @param xml the XML data
   */
  public Contact(XML xml) throws ParseException, WarningException {
    parseXML(xml);
  }

  /**
   * Return the resource tag
   */
  public String getTag() {
    return "contacts";
  }

  /**
   * Return the primary key contactId value
   * @return contactId value
   */
  public int getPrimaryKey() {
    return contactId;
  }

  /**
   * Parse an XML response into current instance variables.  Missing values will set those variables to null.
   */
  public void parseXML(XML xml) throws ParseException, WarningException {
    String warnings = xml.getWarnings();
    if (warnings!=null) throw new WarningException(warnings);
    contactId = xml.getInt("contactId");
    email = xml.getString("email");
    prefix = xml.getString("prefix");
    firstName = xml.getString("firstName");
    lastName = xml.getString("lastName");
    suffix = xml.getString("suffix");
    street = xml.getString("street");
    street2 = xml.getString("street2");
    city = xml.getString("city");
    state = xml.getString("state");
    postalCode = xml.getString("postalCode");
    phone = xml.getString("phone");
    fax = xml.getString("fax");
    business = xml.getString("business");
    status = xml.getString("status");
    createDate = xml.getDate("createDate");
    bounceCount = xml.getInt("bounceCount");
  }

  /**
   * Generate the XML for this contact, only containing non-null fields. Throw ValidationException if email is not present.
   * @return XML block for contact
   */
  public XML getXML() {
    XML xml = new XML();
    xml.openResource("contact");
    xml.appendInt("contactId", contactId);
    xml.appendString("email", email);
    xml.appendString("prefix", prefix);
    xml.appendString("firstName", firstName);
    xml.appendString("lastName", lastName);
    xml.appendString("suffix", suffix);
    xml.appendString("street", street);
    xml.appendString("street2", street2);
    xml.appendString("city", city);
    xml.appendString("state", state);
    xml.appendString("postalCode", postalCode);
    xml.appendString("phone", phone);
    xml.appendString("fax", fax);
    xml.appendString("business", business);
    xml.appendString("status", status);
    xml.closeResource("contact");
    return xml;
  }

  /**
   * Subscribe this contact to the given list; return true if new subscription successful, false otherwise (including if subscription already exists)
   */
  public boolean subscribe(Credentials creds, Account account, ClientFolder clientFolder, List list) throws ValidationException, MalformedURLException, ParseException, ResourceNotFoundException, WarningException {
    boolean success = false;
    boolean subscriptionExists = false;
    try {
      // see if subscription already exists
      String subscriptionId = list.getPrimaryKey()+"_"+contactId;
      Subscription subscription = new Subscription(creds, account, clientFolder, subscriptionId);
      subscriptionExists = true;
    } catch (ResourceNotFoundException ex) {
      // subscription does not exist
      subscriptionExists = false;
    }
    if (!subscriptionExists) {
      try {
	Subscription subscription = new Subscription(creds, account, clientFolder, contactId, list.getPrimaryKey(), "normal");
	success = true;
      } catch (WarningException ex) {
	success = false;
      }
    }
    return success;
  }


}

