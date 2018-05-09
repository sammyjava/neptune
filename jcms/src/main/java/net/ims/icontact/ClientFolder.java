package net.ims.icontact;

import java.io.IOException; 
import java.net.MalformedURLException;
import java.net.URL;
import java.text.ParseException;

/**
 * Object which embodies a single Client Folder record.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class ClientFolder extends Resource {

  // primary key
  private int clientFolderId = 0;

  // required fields
  public String name;
  public String fromName;
  public String fromEmail;
  public String street;
  public String city;
  public String state;
  public String postalCode;
  public String country;

  // optional fields
  public int logoId = 0;
  public boolean enabled = false;
  public String footerLogoUrl;
  public boolean useLogoInFooter = false;
  public String emailRecipient;

  /**
   * Instantiate a new ClientFolder with the given required fields
   * @param name identifies the folder
   * @param fromName sender name
   * @param fromEmail sender email
   * @param street client address
   * @param city client address
   * @param state client address
   * @param postalCode client address
   * @param country client address
   */
  public ClientFolder(Credentials creds, Account account, String name, String fromName, String fromEmail, String street, String city, String state, String postalCode, String country) 
    throws ValidationException, MalformedURLException, IOException, ParseException, WarningException {
    if (name==null) throw new ValidationException("ClientFolder: name must be supplied.");
    if (fromName==null) throw new ValidationException("ClientFolder: fromName must be supplied.");
    if (!Credentials.isValidEmail(fromEmail)) throw new ValidationException("ClientFolder: Invalid fromEmail supplied: "+fromEmail);
    if (street==null) throw new ValidationException("ClientFolder: street must be supplied.");
    if (city==null) throw new ValidationException("ClientFolder: city must be supplied.");
    if (state==null) throw new ValidationException("ClientFolder: state must be supplied.");
    if (postalCode==null) throw new ValidationException("ClientFolder: postalCode must be supplied.");
    if (country==null) throw new ValidationException("ClientFolder: country must be supplied.");
    this.name = name;
    this.fromName = fromName;
    this.fromEmail = fromEmail;
    this.street = street;
    this.city = city;
    this.state = state;
    this.postalCode = postalCode;
    this.country = country;
    get(creds, account);
  }

  /**
   * Instantiate with the given client folder ID
   * @param pkey client folder ID
   */
  public ClientFolder(Credentials creds, Account account, int pkey) throws ValidationException, MalformedURLException, IOException, ParseException, WarningException {
    get(creds, account, pkey);
  }

  /**
   * Instantiate using the data contained in the provided XML
   * @param xml the XML data
   */
  public ClientFolder(XML xml) throws ParseException, WarningException {
    parseXML(xml);
  }

  /**
   * Return the resource tag
   */
  public String getTag() {
    return "clientfolders";
  }

  /**
   * Return the clientFolderId value
   * @return clientFolderId value
   */
  public int getPrimaryKey() {
    return clientFolderId;
  }

  /**
   * Parse an XML response into current instance variables.  Missing values will set those variables to null.
   */
  public void parseXML(XML xml) throws ParseException, WarningException {
    String warnings = xml.getWarnings();
    if (warnings!=null) throw new WarningException(warnings);
    clientFolderId = xml.getInt("clientFolderId");
    name = xml.getString("name");
    fromName = xml.getString("fromName");
    fromEmail = xml.getString("fromEmail");
    street = xml.getString("street");
    city = xml.getString("city");
    state = xml.getString("state");
    postalCode = xml.getString("postalCode");
    country = xml.getString("country");
    logoId = xml.getInt("logoId");
    enabled = xml.getBoolean("enabled");
    footerLogoUrl = xml.getString("footerLogoUrl");
    useLogoInFooter = xml.getBoolean("useLogoInFooter");
    emailRecipient = xml.getString("emailRecipient");
  }

  /**
   * Generate the XML for this client folder, only containing non-null fields. Throw ValidationException if email is not present.
   * @return XML block for contact
   */
  public XML getXML() {
    XML xml = new XML();
    xml.openResource("clientfolder");
    xml.appendInt("clientFolderId", clientFolderId);
    xml.appendString("name", name);
    xml.appendString("fromName", fromName);
    xml.appendString("fromEmail", fromEmail);
    xml.appendString("street", street);
    xml.appendString("city", city);
    xml.appendString("state", state);
    xml.appendString("postalCode", postalCode);
    xml.appendString("country", country);
    xml.appendInt("logoId", logoId);
    xml.appendBoolean("enabled", enabled);
    xml.appendString("footerLogoUrl", footerLogoUrl);
    xml.appendBoolean("useLogoInFooter", useLogoInFooter);
    xml.appendString("emailRecipient", emailRecipient);
    xml.closeResource("clientfolder");
    return xml;
  }

  /**
   * Create a new client folder using the supplied API Credentials and account.
   */
  public void get(Credentials creds, Account account) throws ValidationException, MalformedURLException, IOException, ParseException, WarningException {
    URL url = creds.getURL(account, "c");
    XML response = creds.doGet(url);
    parseXML(response);
  }

  /**
   * Get this client folder using the supplied API Credentials, account and client folder ID.
   */
  public void get(Credentials creds, Account account, int pkey) throws ValidationException, MalformedURLException, IOException, ParseException, WarningException {
    URL url = creds.getURL(account, "c", pkey);
    XML response = creds.doGet(url);
    parseXML(response);
  }

}

