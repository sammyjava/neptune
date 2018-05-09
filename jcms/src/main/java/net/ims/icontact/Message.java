package net.ims.icontact;

import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.text.ParseException;
import java.util.Date;

/**
 * Object which embodies a single Message record, and static methods to retrieve multiple messages.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class Message extends Resource {

  // primary key
  private int messageId = 0;

  // required fields
  public int campaignId;
  public String messageType;
  public String subject;

  // optional fields
  public String htmlBody;
  public String textBody;

  // receive-only fields
  public Date createDate;

  // receive-only SpamCheck fields
  public double rawScore;
  public double spamDetailScore;
  public String spamDetailName;
  public String spamDetailDescription;
  
  /**
   * Instantiate a new Message in the given account and client folder with the given campaignId, messageType and subject
   * @param creds
   * @param account
   * @param clientFolder
   * @param campaignId
   * @param messageType
   * @param subject
   */
  public Message(Credentials creds, Account account, ClientFolder clientFolder, int campaignId, String messageType, String subject)
    throws ValidationException, ResourceNotFoundException, MalformedURLException, ParseException, WarningException {
    if (campaignId==0) throw new ValidationException("Supplied message campaign ID is zero.");
    if (messageType==null) throw new ValidationException("Supplied message type is null.");
    if (subject==null) throw new ValidationException("Supplied message subject is null.");
    this.campaignId = campaignId;
    this.messageType = messageType;
    this.subject = subject;
    create(creds, account, clientFolder);
  }

  /**
   * Retrieve a single Message with the given messageId
   * @param creds the Credentials
   * @param account the Account
   * @param clientFolder the ClientFolder
   * @param pkey the Message primary key (messageId)
   */
  public Message(Credentials creds, Account account, ClientFolder clientFolder, int pkey) throws ValidationException, ResourceNotFoundException, MalformedURLException, ParseException, WarningException {
    if (pkey==0) throw new ValidationException("Supplied message ID is zero.");
    get(creds, account, clientFolder, pkey);
  }

  /**
   * Instantiate this Message using the data contained in the provided XML
   * @param xml the XML data
   */
  public Message(XML xml) throws ParseException, WarningException {
    parseXML(xml);
  }

  /**
   * Return the resource tag
   */
  public String getTag() {
    return "messages";
  }

  /**
   * Return the primary key messageId value
   * @return messageId value
   */
  public int getPrimaryKey() {
    return messageId;
  }

  /**
   * Parse an XML response into current instance variables.  Missing values will set those variables to null.
   */
  public void parseXML(XML xml) throws ParseException, WarningException {
    String warnings = xml.getWarnings();
    if (warnings!=null) throw new WarningException(warnings);
    messageId = xml.getInt("messageId");
    campaignId = xml.getInt("campaignId");
    messageType = xml.getString("messageType");
    subject = xml.getString("subject");
    htmlBody = xml.getString("htmlBody");
    textBody = xml.getString("textBody");
    createDate = xml.getISODate("createDate");
    rawScore = xml.getDouble("rawScore");
    spamDetailScore = xml.getDouble("spamDetailScore");
    spamDetailName = xml.getString("spamDetailName");
    spamDetailDescription = xml.getString("spamDetailDescription");
  }

  /**
   * Generate the XML for this message, only containing non-null fields. Throw ValidationException if email is not present.
   * @return XML block for message
   */
  public XML getXML() {
    XML xml = new XML();
    xml.openResource("message");
    xml.appendInt("messageId", messageId);
    xml.appendInt("campaignId", campaignId);
    xml.appendString("messageType", messageType);
    xml.appendString("subject", subject);
    xml.appendString("htmlBody", htmlBody);
    xml.appendString("textBody", textBody);
    xml.appendISODate("createDate", createDate);
    xml.closeResource("message");
    return xml;
  }

  /**
   * Return an array of all messages in the given account and client folder.
   */
  public static Message[] getAll(Credentials creds, Account account, ClientFolder clientFolder) throws ResourceNotFoundException, MalformedURLException, ParseException, WarningException {
    URL url = creds.getURL(account, clientFolder, "messages");
    try {
      XML response = creds.doGet(url);
      XML[] chunks = XML.getChunks(response, "messages", "message");
      Message[] messages = new Message[chunks.length];
      for (int i=0; i<chunks.length; i++) messages[i] = new Message(chunks[i]);
      return messages;
    } catch (IOException ex) {
      throw new ResourceNotFoundException("Resource not found: "+ex.getMessage());
    }
  }

}
