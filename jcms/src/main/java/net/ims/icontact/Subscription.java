package net.ims.icontact;

import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.text.ParseException;
import java.util.Date;

/**
 * Object which embodies a single Subscription record, which links a Contact to a List.  Does NOT extend Resource, as the primary key
 * for a subscription is a string {listId}_{contactId} rather than an int.  But has the same methods.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class Subscription {

  // primary key
  private String subscriptionId;

  // required fields
  public String status; // normal, pending, unsubscribed
  public int contactId; // supply ONLY when creating a new subscription
  public int listId;    // supply ONLY when creating or moving a subscription to a new list

  // optional fields
  public int confirmationMessageId; // confirmation-request message

  // receive-only fields
  Date addDate;  // datetime subscription was created
  
  /**
   * Create a new Subscription in the given account and client folder for the given contact, list, status and no confirmation message
   * @param creds
   * @param account
   * @param clientFolder
   * @param contactId
   * @param listId
   * @param status (normal, pending, unsubscribed)
   */
  public Subscription(Credentials creds, Account account, ClientFolder clientFolder, int contactId, int listId, String status)
    throws ValidationException, ResourceNotFoundException, MalformedURLException, ParseException, WarningException {
    if (contactId==0) throw new ValidationException("Supplied contact ID is zero.");
    if (listId==0) throw new ValidationException("Supplied list ID is zero.");
    if (status==null || status.trim().length()==0) throw new ValidationException("Supplied status is empty (must be normal, pending or unsubscribed).");
    this.contactId = contactId;
    this.listId = listId;
    this.status = status;
    create(creds, account, clientFolder);
  }

  /**
   * Create a new Subscription in the given account and client folder for the given contact, list, status and confirmation message
   * @param creds
   * @param account
   * @param clientFolder
   * @param contactId
   * @param listId
   * @param status (normal, pending, unsubscribed)
   * @param confirmationMessageId
   */
  public Subscription(Credentials creds, Account account, ClientFolder clientFolder, int contactId, int listId, String status, int confirmationMessageId)
    throws ValidationException, ResourceNotFoundException, MalformedURLException, ParseException, WarningException {
    if (contactId==0) throw new ValidationException("Supplied contact ID is zero.");
    if (listId==0) throw new ValidationException("Supplied list ID is zero.");
    if (status==null || status.trim().length()==0) throw new ValidationException("Supplied status is empty (must be normal, pending or unsubscribed).");
    if (confirmationMessageId==0) throw new ValidationException("Supplied confirmation message ID is zero (must be ID of a confirmation message).");
    // check that given confirmation message is, in fact, a confirmation message
    if (confirmationMessageId!=0) {
      Message message = new Message(creds, account, clientFolder, confirmationMessageId);
      if (!message.messageType.equals("confirmation")) throw new ValidationException("Supplied message ID "+confirmationMessageId+" is for a message of type "+message.messageType+", not confirmation, as required.");
    }
    this.contactId = contactId;
    this.listId = listId;
    this.status = status;
    if (confirmationMessageId!=0) this.confirmationMessageId = confirmationMessageId;
    create(creds, account, clientFolder);
  }

  /**
   * Retrieve a single Subscription with the given subscriptionId
   * @param creds the Credentials
   * @param account the Account
   * @param clientFolder the ClientFolder
   * @param pkey the Subscription primary key (subscriptionId)
   */
  public Subscription(Credentials creds, Account account, ClientFolder clientFolder, String pkey) throws ValidationException, ResourceNotFoundException, MalformedURLException, ParseException, WarningException {
    if (pkey==null) throw new ValidationException("Supplied subscription ID is null.");
    get(creds, account, clientFolder, pkey);
  }

  /**
   * Instantiate using the data contained in the provided XML
   * @param xml the XML data
   */
  public Subscription(XML xml) throws ParseException, WarningException {
    parseXML(xml);
  }

  /**
   * Return the resource tag
   */
  public String getTag() {
    return "subscriptions";
  }

  /**
   * Return the primary key subscriptionId value
   * @return subscriptionId value
   */
  public String getPrimaryKey() {
    return subscriptionId;
  }

  /**
   * Parse an XML response into current instance variables.  Missing values will set those variables to null or zero or false.
   */
  public void parseXML(XML xml) throws ParseException, WarningException {
    String warnings = xml.getWarnings();
    if (warnings!=null) throw new WarningException(warnings);
    subscriptionId = xml.getString("subscriptionId");
    listId = xml.getInt("listId");
    contactId = xml.getInt("contactId");
    status = xml.getString("status");
    confirmationMessageId = xml.getInt("confirmationMessageId");
  }

  /**
   * Generate the XML for this subscription, only containing non-null fields. Throw ValidationException if email is not present.
   * @return XML block for subscription
   */
  public XML getXML() {
    XML xml = new XML();
    xml.openResource("subscription");
    xml.appendString("subscriptionId", subscriptionId);
    xml.appendInt("listId", listId);
    xml.appendInt("contactId", contactId);
    xml.appendString("status", status);
    xml.appendInt("confirmationMessageId", confirmationMessageId);
    xml.closeResource("subscription");
    return xml;
  }


  /**
   * Create a new subscription using the supplied API Credentials, Account, Client Folder and the current instance values.  Sets instance vars if successful.
   */
  public void create(Credentials creds, Account account, ClientFolder clientFolder) throws ValidationException, ResourceNotFoundException, MalformedURLException, ParseException, WarningException {
    URL url = creds.getURL(account, clientFolder, getTag());
    XML request = getXML();
    request.prepend("<"+getTag()+">");
    request.append("</"+getTag()+">");
    try {
      XML response = creds.doPost(url, request);
      parseXML(response);
    } catch (IOException ex) {
      throw new ResourceNotFoundException("Subscription not created: "+ex.getMessage());
    }
  }

  /**
   * Get subscription data using the supplied API Credentials, Account, Client Folder and primary key.  Sets instance vars if successful.
   */
  public void get(Credentials creds, Account account, ClientFolder clientFolder, String pkey) throws ValidationException, ResourceNotFoundException, MalformedURLException, ParseException, WarningException {
    if (pkey==null) throw new ValidationException("Cannot get subscription: given primary key is null.");
    this.subscriptionId = pkey;
    URL url = creds.getURL(account, clientFolder, this);
    try {
      XML response = creds.doGet(url);
      parseXML(response);
    } catch (IOException ex) {
      this.subscriptionId = null;
      throw new ResourceNotFoundException("Subscription not found: "+ex.getMessage());
    }
  }

  /**
   * Update subscription data using the supplied API Credentials, Account, Client Folder, and current status.
   */
  public void update(Credentials creds, Account account, ClientFolder clientFolder) throws ValidationException, ResourceNotFoundException, MalformedURLException, ParseException, WarningException {
    if (subscriptionId==null) throw new ValidationException("Cannot update subscription: primary key is not set.");
    URL url = creds.getURL(account, clientFolder, this);
    // customerId and listId cannot be supplied on an update
    contactId = 0;
    listId = 0;
    XML request = getXML();
    try {
      XML response = creds.doPost(url, request);
      parseXML(response);
    } catch (IOException ex) {
      throw new ResourceNotFoundException("Subscription not found: "+ex.getMessage());
    }
  }

  /**
   * Delete this subscription.  Leaves instance vars in former state.
   */
  public void delete(Credentials creds, Account account, ClientFolder clientFolder) throws ValidationException, ResourceNotFoundException, MalformedURLException, ParseException {
    if (subscriptionId==null) throw new ValidationException("Cannot delete subscription: primary key is not set.");
    URL url = creds.getURL(account, clientFolder, this);
    try {
      creds.doDelete(url);
    } catch (IOException ex) {
      throw new ResourceNotFoundException("Subscription not found: "+ex.getMessage());
    }
  }

}

