package net.ims.icontact;

import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.text.ParseException;

/**
 * Abstract class which embodies all common methods for iContact resources.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public abstract class Resource {

  /**
   * Return the tag for this resource (e.g. "contacts")
   * @return resource tag value (e.g. "contacts")
   */
  public abstract String getTag();

  /**
   * Return the primary key for this resource (e.g. contactId)
   * @return primary key value (a private int in the implementing class)
   */
  public abstract int getPrimaryKey();

  /**
   * Parse an XML response into current instance variables.  Missing values will set those variables to null.
   */
  public abstract void parseXML(XML xml) throws ParseException, WarningException;

  /**
   * Generate the XML for this instance, only containing non-null fields.
   * @return XML block for contact
   */
  public abstract XML getXML();

  /**
   * Create a new resource using the supplied API Credentials, Account, Client Folder and the current instance values.  Sets instance vars if successful.
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
      throw new ResourceNotFoundException("Resource not created: "+ex.getMessage());
    }
  }

  /**
   * Get resource data using the supplied API Credentials, Account, Client Folder and primary key.  Sets instance vars if successful.
   */
  public void get(Credentials creds, Account account, ClientFolder clientFolder, int pkey) throws ValidationException, ResourceNotFoundException, MalformedURLException, ParseException, WarningException {
    if (pkey==0) throw new ValidationException("Cannot get resource: given primary key is zero.");
    URL url = creds.getURL(account, clientFolder, getTag(), pkey);
    try {
      XML response = creds.doGet(url);
      parseXML(response);
    } catch (IOException ex) {
      throw new ResourceNotFoundException("Resource not found: "+ex.getMessage());
    }
  }

  /**
   * Update resource data using the supplied API Credentials, Account, Client Folder, refreshing instance values afterward.
   */
  public void update(Credentials creds, Account account, ClientFolder clientFolder) throws ValidationException, ResourceNotFoundException, MalformedURLException, ParseException, WarningException {
    if (getPrimaryKey()==0) throw new ValidationException("Cannot update resource: primary key is not set.");
    URL url = creds.getURL(account, clientFolder, this);
    XML request = getXML();
    try {
      XML response = creds.doPost(url, request);
      parseXML(response);
    } catch (IOException ex) {
      throw new ResourceNotFoundException("Resource not found: "+ex.getMessage());
    }
  }

  /**
   * Delete this resource.  Leaves instance vars in former state.
   */
  public void delete(Credentials creds, Account account, ClientFolder clientFolder) throws ValidationException, ResourceNotFoundException, MalformedURLException, ParseException {
    if (getPrimaryKey()==0) throw new ValidationException("Cannot delete resource: primary key is not set.");
    URL url = creds.getURL(account, clientFolder, this);
    try {
      creds.doDelete(url);
    } catch (IOException ex) {
      throw new ResourceNotFoundException("Resource not found: "+ex.getMessage());
    }
  }

}

