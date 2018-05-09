package net.ims.jcms.extras;

import net.ims.jcms.ValidationException;

import java.net.URLEncoder;
import java.util.Iterator;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletContext;

import com.paypal.sdk.core.nvp.NVPDecoder;
import com.paypal.sdk.core.nvp.NVPEncoder;
import com.paypal.sdk.exceptions.PayPalException;
import com.paypal.sdk.profiles.APIProfile;
import com.paypal.sdk.profiles.ProfileFactory;
import com.paypal.sdk.services.NVPCallerServices;

/**
 * Collection of methods for PayPal Express Checkout Name-Value Pair calls, along with a Map to store the returned results.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class PayPal {

  // list of US states
  public final static String[] states = { "AK", "AL", "AR", "AZ", "CA", "CO", "CT", "DC", "DE", "FL", "GA", "HI", "IA", "ID", "IL", "IN", "KS", "KY", "LA", "MA", "MD", "ME", "MI", "MN", "MO", "MS", "MT", 
					  "NC", "ND", "NE", "NH", "NJ", "NM", "NV", "NY", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VA", "VT", "WA", "WI", "WV", "WY" };

  // list of Canadian provinces
  public final static String[] provinces = { "AB", "BC", "MB", "NB", "NL", "NT", "NS", "NU", "ON", "PE", "QC", "SK", "YT" };

  // the API profile
  APIProfile profile = null;

  // some constants
  final static String liveURL = "https://www.paypal.com/cgi-bin/webscr";
  final static String sandboxURL = "https://www.sandbox.paypal.com/cgi-bin/webscr";

  // the PayPal URL we'll use, live or sandbox
  String paypalURL = null;

  // Map used for validation of required Name/Value pairs; instance var so that we can use a method to update it
  HashMap<String,Boolean> requiredMap = null;

  /** the Map resulting from the current response (so calling program doesn't have to include NVPDecoder) */
  public Map responseMap = null;

  /** the Express Checkout URL to which we should redirect, live or sandbox */
  public String expressCheckoutURL = null;

  /** boolean to record if transaction returns ACK=Success (whatever that means) */
  public boolean success = false;


  /**
   * Initialize this instance, using parameters in web.xml: paypal.live (true/false), paypal.api.username, paypal.api.password, paypal.api.signature.
   */
  public PayPal(ServletContext context) throws ValidationException, PayPalException {

    // get the profile parameters, throw ValidationException if missing
    // NOTE THAT THIS IS INSECURE, PASSWORD SHOULD BE ENCRYPTED!!!
    String live = context.getInitParameter("paypal.live");
    String apiUsername = context.getInitParameter("paypal.api.username");
    String apiPassword = context.getInitParameter("paypal.api.password");
    String apiSignature = context.getInitParameter("paypal.api.signature");
    if (live==null || apiUsername==null || apiPassword==null || apiSignature==null) {
      throw new ValidationException("PayPal parameters are missing in web.xml: paypal.live, paypal.api.username, paypal.api.password and paypal.api.signature are all required.");
    }

    // Set up your API credentials, PayPal end point, API operation and version.
    profile = ProfileFactory.createSignatureAPIProfile();
    profile.setAPIUsername(apiUsername);
    profile.setAPIPassword(apiPassword);
    profile.setSignature(apiSignature);

    // set live/sandbox
    if (live.equals("true")) {
      profile.setEnvironment("live");
      paypalURL = liveURL;
    } else {
      profile.setEnvironment("sandbox");
      paypalURL = sandboxURL;
    }

  }

  /**
   * Return the current API version.
   */
  public static String getAPIVersion() throws PayPalException {
    NVPCallerServices caller = new NVPCallerServices();
    return caller.getAPIVersion();
  }

  /**
   * Initiate an Express Checkout transaction
   */
  public void setExpressCheckout(Map parameters) throws PayPalException, ValidationException {

    // required parameters
    String[] requiredNames = { "RETURNURL", "CANCELURL" };

    // load names and flags into HashMap
    requiredMap = new HashMap<String,Boolean>();
    for (int i=0; i<requiredNames.length; i++) requiredMap.put(requiredNames[i], new Boolean(false));

    // add parameters, toggle flags for required ones
    NVPEncoder encoder = new NVPEncoder();
    encoder.add("VERSION", "65.1");			
    encoder.add("METHOD", "SetExpressCheckout");
    Iterator keyIterator = parameters.keySet().iterator();
    while (keyIterator.hasNext()) {
      String key = (String)keyIterator.next();
      String value = (String)parameters.get(key);
      validate(key, value);
      encoder.add(key, value);
    }

    // throw exception if a required parameter is missing
    if (requiredMap.containsValue(new Boolean(false))) {
      String message = "PayPal.setExpressCheckout Error: ";
      for (int i=0; i<requiredNames.length; i++) {
	boolean set = (Boolean)requiredMap.get(requiredNames[i]).booleanValue();
	if (!set) message += requiredNames[i]+" is required. ";
      }
      throw new ValidationException(message);
    }

    // continue with caller
    NVPCallerServices caller = new NVPCallerServices();
    caller.setAPIProfile(profile);
	
    // execute the API operation and obtain the response.
    String nvpRequest = encoder.encode();
    String nvpResponse = caller.call(nvpRequest);

    // decode the response
    NVPDecoder decoder = new NVPDecoder();
    decoder.decode(nvpResponse);

    // set PayPal Express Checkout URL with token; redirect to this to continue checkout
    expressCheckoutURL = paypalURL + "?cmd=_express-checkout&token="+decoder.get("TOKEN");

    // set success flag
    success = decoder.get("ACK").equals("Success");

    // set response map
    responseMap = decoder.getMap();

  }

  /**
   * Get the Express Checkout details for the given transaction, identified by token
   */
  public void getExpressCheckoutDetails(String token) throws PayPalException {

    NVPEncoder encoder = new NVPEncoder();
    NVPDecoder decoder = new NVPDecoder();
    NVPCallerServices caller = new NVPCallerServices();

    caller.setAPIProfile(profile);

    // Add request-specific fields to the request string.
    encoder.add("VERSION", "65.1");			
    encoder.add("METHOD", "GetExpressCheckoutDetails");
    encoder.add("TOKEN", token);

    // Execute the API operation and obtain the response.
    String nvpRequest = encoder.encode();
    String nvpResponse = caller.call(nvpRequest);
    decoder.decode(nvpResponse);

    // set response map
    responseMap = decoder.getMap();

    // set success flag
    success = decoder.get("ACK").equals("Success");

  }

  /**
   * Complete an Express Checkout transaction
   */
  public void doExpressCheckoutPayment(Map parameters) throws PayPalException, ValidationException {

    // required parameters
    String[] requiredNames = { "TOKEN", "PAYERID", "PAYMENTREQUEST_0_AMT", "PAYMENTREQUEST_0_PAYMENTACTION" };

    // load names and flags into HashMap
    requiredMap = new HashMap<String,Boolean>();
    for (int i=0; i<requiredNames.length; i++) requiredMap.put(requiredNames[i], new Boolean(false));

    // add parameters, toggle flags for required ones
    NVPEncoder encoder = new NVPEncoder();
    encoder.add("VERSION", "65.1");			
    encoder.add("METHOD", "DoExpressCheckoutPayment");
    Iterator keyIterator = parameters.keySet().iterator();
    while (keyIterator.hasNext()) {
      String key = (String)keyIterator.next();
      String value = (String)parameters.get(key);
      validate(key, value);
      encoder.add(key, value);
    }

    // throw exception if a required parameter is missing
    if (requiredMap.containsValue(new Boolean(false))) {
      String message = "PayPal.doExpressCheckoutPayment Error: ";
      for (int i=0; i<requiredNames.length; i++) {
	boolean set = (Boolean)requiredMap.get(requiredNames[i]).booleanValue();
	if (!set) message += requiredNames[i]+" is required. ";
      }
      throw new ValidationException(message);
    }

    // continue with caller
    NVPCallerServices caller = new NVPCallerServices();
    caller.setAPIProfile(profile);

    // Execute the API operation and obtain the response.
    String NVPRequest = encoder.encode();
    String NVPResponse =caller.call(NVPRequest);

    // decode the response
    NVPDecoder decoder = new NVPDecoder();
    decoder.decode(NVPResponse);
			
    // set response map
    responseMap = decoder.getMap();

    // set success flag if ACK Success returned
    success = decoder.get("ACK").equals("Success");

  }

  /**
   * Submit a DoDirectPayment request.
   */
  public void doDirectPayment(Map parameters) throws PayPalException, ValidationException {

    // required parameters; CVV2 is not required by PayPal, but it is by us
    String[] requiredNames = { "PAYMENTACTION", "AMT", "IPADDRESS", "CREDITCARDTYPE", "ACCT", "EXPDATE", "CVV2", "FIRSTNAME", "LASTNAME", "STREET", "CITY", "STATE", "COUNTRYCODE", "ZIP" };

    // load names and flags into HashMap
    requiredMap = new HashMap<String,Boolean>();
    for (int i=0; i<requiredNames.length; i++) requiredMap.put(requiredNames[i], new Boolean(false));

    // add parameters, toggle flags for required ones
    NVPEncoder encoder = new NVPEncoder();
    encoder.add("VERSION", "65.1");			
    encoder.add("METHOD", "DoDirectPayment");
    Iterator keyIterator = parameters.keySet().iterator();
    while (keyIterator.hasNext()) {
      String key = (String)keyIterator.next();
      String value = (String)parameters.get(key);
      validate(key, value);
      encoder.add(key, value);
    }

    // throw exception if a required parameter is missing
    if (requiredMap.containsValue(new Boolean(false))) {
      String message = "PayPal.doDirectPayment Error: ";
      for (int i=0; i<requiredNames.length; i++) {
	boolean set = (Boolean)requiredMap.get(requiredNames[i]).booleanValue();
	if (!set) message += requiredNames[i]+" is required. ";
      }
      throw new ValidationException(message);
    }

    // continue with call
    NVPCallerServices caller = new NVPCallerServices();
    caller.setAPIProfile(profile);

    // Execute the API operation and obtain the response.
    String NVPRequest = encoder.encode();
    String NVPResponse =caller.call(NVPRequest);

    // decode the response
    NVPDecoder decoder = new NVPDecoder();
    decoder.decode(NVPResponse);
			
    // set response map
    responseMap = decoder.getMap();

    // set success flag
    success = decoder.get("ACK").equals("Success");

  }

  /**
   * Submit a Direct Payment CreateRecurringPaymentsProfile request.
   */
  public void createDPRecurringPaymentsProfile(Map parameters) throws PayPalException, ValidationException {

    String[] requiredNames = { "AMT", "PROFILESTARTDATE", "DESC", "BILLINGPERIOD", "BILLINGFREQUENCY", "CURRENCYCODE", "EMAIL",
			       "CREDITCARDTYPE", "ACCT", "EXPDATE", "CVV2", "FIRSTNAME", "LASTNAME", "STREET", "CITY", "STATE", "COUNTRYCODE", "ZIP" };

    // load names and flags into HashMap
    requiredMap = new HashMap<String,Boolean>();
    for (int i=0; i<requiredNames.length; i++) requiredMap.put(requiredNames[i], new Boolean(false));

    // add encoded parameters, toggle flags for required ones
    NVPEncoder encoder = new NVPEncoder();
    encoder.add("VERSION", "65.1");			
    encoder.add("METHOD", "CreateRecurringPaymentsProfile");
    Iterator keyIterator = parameters.keySet().iterator();
    while (keyIterator.hasNext()) {
      String key = (String)keyIterator.next();
      String value = (String)parameters.get(key);
      validate(key, value);
      encoder.add(key, value);
    }

    // throw exception if a required parameter is missing
    if (requiredMap.containsValue(new Boolean(false))) {
      String message = "PayPal.createDPRecurringPayments Error: ";
      for (int i=0; i<requiredNames.length; i++) {
	boolean set = (Boolean)requiredMap.get(requiredNames[i]).booleanValue();
	if (!set) message += requiredNames[i]+" is required. ";
      }
      throw new ValidationException(message);
    }

    // continue with call
    NVPCallerServices caller = new NVPCallerServices();
    caller.setAPIProfile(profile);

    // Execute the API operation and obtain the response.
    String NVPRequest = encoder.encode();
    String NVPResponse =caller.call(NVPRequest);

    // decode the response
    NVPDecoder decoder = new NVPDecoder();
    decoder.decode(NVPResponse);
			
    // set response map
    responseMap = decoder.getMap();

    // set success flag
    success = decoder.get("ACK").equals("Success");

  }

  /**
   * Submit an Express Checkout CreateRecurringPaymentsProfile request.
   */
  public void createECRecurringPaymentsProfile(Map parameters) throws PayPalException, ValidationException {

    String[] requiredNames = { "TOKEN", "AMT", "PROFILESTARTDATE", "DESC", "BILLINGPERIOD", "BILLINGFREQUENCY", "CURRENCYCODE" };

    // load names and flags into HashMap
    requiredMap = new HashMap<String,Boolean>();
    for (int i=0; i<requiredNames.length; i++) requiredMap.put(requiredNames[i], new Boolean(false));

    // add encoded parameters, toggle flags for required ones
    NVPEncoder encoder = new NVPEncoder();
    encoder.add("VERSION", "65.1");			
    encoder.add("METHOD", "CreateRecurringPaymentsProfile");
    Iterator keyIterator = parameters.keySet().iterator();
    while (keyIterator.hasNext()) {
      String key = (String)keyIterator.next();
      String value = (String)parameters.get(key);
      validate(key, value);
      encoder.add(key, value);
    }

    // throw exception if a required parameter is missing
    if (requiredMap.containsValue(new Boolean(false))) {
      String message = "PayPal.createECRecurringPayments Error: ";
      for (int i=0; i<requiredNames.length; i++) {
	boolean set = (Boolean)requiredMap.get(requiredNames[i]).booleanValue();
	if (!set) message += requiredNames[i]+" is required. ";
      }
      throw new ValidationException(message);
    }

    // continue with call
    NVPCallerServices caller = new NVPCallerServices();
    caller.setAPIProfile(profile);

    // Execute the API operation and obtain the response.
    String NVPRequest = encoder.encode();
    String NVPResponse =caller.call(NVPRequest);

    // decode the response
    NVPDecoder decoder = new NVPDecoder();
    decoder.decode(NVPResponse);
			
    // set response map
    responseMap = decoder.getMap();

    // set success flag
    success = decoder.get("ACK").equals("Success");

  }

  /**
   * Validates a given key/value pair, comparing it to requiredMap and setting its flag=true if it matches a name
   */
  void validate(String key, String value) {
    if (requiredMap.containsKey(key) && value!=null && value.trim().length()>0) {
      requiredMap.remove(key);
      requiredMap.put(key, new Boolean(true));
    }
  }

  /**
   * Returns a string containing all the (key,value) pairs in the responseMap
   */
  public String dumpResponseMap() {
    String output = "";
    Object[] entries = responseMap.entrySet().toArray();
    for (int i=0; i<entries.length; i++) {
      Map.Entry entry = (Map.Entry)entries[i];
      output += (String)entry.getKey()+"="+(String)entry.getValue()+"\n";
    }
    return output;
  }

}
