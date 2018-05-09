package net.ims.icontact;

import java.io.IOException; 
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;

import java.net.URL;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;

import javax.servlet.ServletContext;

/**
 * Simple container for iContact API credentials as well as general HTTP methods using those credentials.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class Credentials {

  // API version presumably matters here
  static final String API_VERSION = "2.2";

  private static final String APPID = "41KuIpqOGmJNP8e8OVNpi3el693nL4nG"; // production
  // private static final String APPID = "JWeydRUFcyebpnYDea99cem2Jdu2Lovk"; // sandbox

  // web.xml context initialization parameters
  static final String HOSTKEY = "icontact.host";
  static final String USERNAMEKEY = "icontact.username";
  static final String PASSWORDKEY = "icontact.password";

  // authentication parameters
  String host;
  String username;
  String password;

  /**
   * Servlet constructor: instantiate the authentication parameters from web.xml.
   */
  public Credentials(ServletContext context) throws ValidationException {
    this.host = context.getInitParameter(HOSTKEY);
    if (host==null) throw new ValidationException("IContact connection parameter "+HOSTKEY+" is missing in web.xml.");
    this.username = context.getInitParameter(USERNAMEKEY);
    if (username==null) throw new ValidationException("IContact connection parameter "+USERNAMEKEY+" is missing in web.xml.");
    this.password = context.getInitParameter(PASSWORDKEY);
    if (password==null) throw new ValidationException("IContact connection parameter "+PASSWORDKEY+" is missing in web.xml.");
  }

  /**
   * Manual constructor: instantiate the authorization parameters with arguments.
   */
  public Credentials(String host, String username, String password) throws ValidationException {
    if (host==null) throw new ValidationException("IContact connection parameter "+HOSTKEY+" is missing in web.xml.");
    if (username==null) throw new ValidationException("IContact connection parameter "+USERNAMEKEY+" is missing in web.xml.");
    if (password==null) throw new ValidationException("IContact connection parameter "+PASSWORDKEY+" is missing in web.xml.");
    this.host = host;
    this.username = username;
    this.password = password;
  }

  /**
   * Return a bare URL instance, used to create an account.
   */
  public URL getURL() throws MalformedURLException {
    return new URL("https", host, 443, "/icp/a/");
  }

  /**
   * Return a URL instance for the given account and account ID, used to get it.
   */
  public URL getURL(int pkey) throws MalformedURLException {
    return new URL("https", host, 443, "/icp/a/"+pkey);
  }

  /**
   * Return a URL instance for the given account, used to update or delete it.
   */
  public URL getURL(Account account) throws MalformedURLException {
    return new URL("https", host, 443, "/icp/a/"+account.getPrimaryKey());
  }

  /**
   * Return a bare URL instance for the given account and tag, used to create a client folder.
   */
  public URL getURL(Account account, String tag) throws MalformedURLException {
    return new URL("https", host, 443, "/icp/a/"+account.getPrimaryKey()+"/"+tag+"/");
  }

  /**
   * Return a bare URL instance for the given account, tag and primary key used to get a client folder.
   */
  public URL getURL(Account account, String tag, int pkey) throws MalformedURLException {
    return new URL("https", host, 443, "/icp/a/"+account.getPrimaryKey()+"/"+tag+"/"+pkey);
  }

  /**
   * Return a URL instance for the given account and client folder, used to update or delete the client folder.
   */
  public URL getURL(Account account, ClientFolder clientFolder) throws MalformedURLException {
    return new URL("https", host, 443, "/icp/a/"+account.getPrimaryKey()+"/c/"+clientFolder.getPrimaryKey());
  }

  /**
   * Return a bare URL instance for the given account, client folder and resource tag, used to create a new resource instance.
   */
  public URL getURL(Account account, ClientFolder clientFolder, String tag) throws MalformedURLException {
    return new URL("https", host, 443, "/icp/a/"+account.getPrimaryKey()+"/c/"+clientFolder.getPrimaryKey()+"/"+tag+"/");
  }

  /**
   * Return a URL instance for the given account, client folder, resource tag and primary key, used to get a resource instance.
   */
  public URL getURL(Account account, ClientFolder clientFolder, String tag, int pkey) throws MalformedURLException {
    return new URL("https", host, 443, "/icp/a/"+account.getPrimaryKey()+"/c/"+clientFolder.getPrimaryKey()+"/"+tag+"/"+pkey);
  }

  /**
   * Return a URL instance for the given account, client folder and resource, used to update or delete the resource.
   */
  public URL getURL(Account account, ClientFolder clientFolder, Resource resource) throws MalformedURLException {
    return new URL("https", host, 443, "/icp/a/"+account.getPrimaryKey()+"/c/"+clientFolder.getPrimaryKey()+"/"+resource.getTag()+"/"+resource.getPrimaryKey());
  }

  /**
   * Return a URL instance for the given account, client folder and subscription, special since subscriptions have string primary key
   */
  public URL getURL(Account account, ClientFolder clientFolder, Subscription subscription) throws MalformedURLException {
    return new URL("https", host, 443, "/icp/a/"+account.getPrimaryKey()+"/c/"+clientFolder.getPrimaryKey()+"/"+subscription.getTag()+"/"+subscription.getPrimaryKey());
  }

  /**
   * Set the authentication request properties on the supplied HttpURLConnection.
   */
  void setURLConnectionAuthentication(HttpURLConnection connection) {
    connection.setRequestProperty("Accept", "text/xml");
    connection.setRequestProperty("Content-Type", "text/xml");
    connection.setRequestProperty("API-Version", API_VERSION);
    connection.setRequestProperty("API-AppId", APPID);
    connection.setRequestProperty("API-Username", username);
    connection.setRequestProperty("API=Password", password);
  }

  /**
   * POST the supplied XML to the supplied URL, returning the response as an XML object
   */
  public XML doPost(URL url, XML request) throws MalformedURLException, IOException {

    HttpURLConnection connection = (HttpURLConnection)url.openConnection();
    connection.setDoOutput(true);
    connection.setRequestMethod("POST");
    setURLConnectionAuthentication(connection);
    
    OutputStreamWriter out = new OutputStreamWriter(connection.getOutputStream());
    out.write(request.toString());
    out.close();

    BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream()));
    XML response = new XML();
    String returnString;
    while ((returnString = in.readLine()) != null) {
      response.append(returnString);
    }
    in.close();

    return response;

  }

  /**
   * GET a response from the supplied URL as an XML object
   */
  public XML doGet(URL url) throws MalformedURLException, IOException {

    HttpURLConnection connection = (HttpURLConnection)url.openConnection();
    connection.setDoOutput(false);
    connection.setRequestMethod("GET");
    setURLConnectionAuthentication(connection);
    
    BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream()));
    XML response = new XML();
    String returnString;
    while ((returnString = in.readLine()) != null) {
      response.append(returnString);
    }
    in.close();

    return response;

  }

  /**
   * Peform an HTTP DELETE request on the supplied URL
   */
  public void doDelete(URL url) throws MalformedURLException, IOException {

    HttpURLConnection connection = (HttpURLConnection)url.openConnection();
    connection.setDoOutput(false);
    connection.setRequestMethod("DELETE");
    setURLConnectionAuthentication(connection);
    
    BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream()));
    StringBuffer response = new StringBuffer();
    String returnString;
    while ((returnString = in.readLine()) != null) {
      response.append(returnString);
    }
    in.close();

  }

  /**
   * Return true if supplied email is valid (valid chars, @ symbol, dots, etc.)
   * @param email the email address
   * @return true if the email is determined to be valid based on syntax
   */
  public static boolean isValidEmail(String email) {
    if (email==null) return false;
    boolean ok = true;
    // must be letters and numbers plus @, ., _, - characters
    for (int i=0; i<email.length(); i++) {
      ok = ok & (Character.isLetterOrDigit(email.charAt(i)) || email.charAt(i)=='@' || email.charAt(i)=='.' || email.charAt(i)=='_' || email.charAt(i)=='-');
    }
    // at least one char to left of @ symbol
    ok = ok && (email.indexOf('@')>0);
    // must have only one @ symbol
    ok = ok && (email.indexOf('@')==email.lastIndexOf('@'));
    // at least two dot-delimited atoms to right of @ symbol
    ok = ok && (email.indexOf('@')<(email.lastIndexOf('.')-1));
    ok = ok && (email.lastIndexOf('.')<(email.length()-1));
    // can't have consecutive ..
    ok = ok && (email.indexOf("..")==-1);
    return ok;
  }

}

