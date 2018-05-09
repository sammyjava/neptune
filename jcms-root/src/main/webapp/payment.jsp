<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/WEB-INF/include/init.inc" %>
<%@ page import="net.ims.jcms.extras.PayPal, java.text.NumberFormat, java.util.Calendar, java.util.HashMap, java.util.Vector, java.util.Date" %>
<%
/**
 * PayPal payments extra
 */
  
// redirect if SSL enabled and this isn't an SSL request
if (sslHostEnable && request.getServerPort()!=443) response.sendRedirect("https://"+sslHost+"/payment.jsp?payment_id="+Util.getInt(request,"payment_id"));

// Setting payments_enable has to be true for this form to be displayed
boolean paymentsEnabled = Setting.getBoolean(application, "payments_enable");
  
// money format
NumberFormat mf = NumberFormat.getCurrencyInstance();

// date format
SimpleDateFormat df = new SimpleDateFormat("yyyy.MM.dd 'at' HH:mm:ss z");

// the payment object for this specific payment
Payment payment = new Payment(application, Util.getInt(request,"payment_id"));

// override page parameters
p.pid = 0; // payment extra isn't a page
if (payment.isDefault()) {
  p.title = "No Payment Specified.";
} else {
  p.title = payment.title;
}
p.headtitle = p.title;
showSectionheader = sectionHeaderEnable;
showSubheader = subheaderEnable;
showPageTitle = pageTitleEnable;
showSidebar = sidebarEnable & !showMobile;
showFooter = footerEnable;

boolean showNetSolSeal = Setting.getBoolean(application,"payments_netsol");

// our object for doing PayPal stuff
PayPal paypal = null;

// array of payment options
PaymentOption[] paymentOptions = payment.getOptions(application);

// error message can be sent back as query string
String error = Util.getString(request, "error"); // empty string if none supplied

// load missing field names into a Vector for highlighting
Vector missing = new Vector();

// processing logic
boolean doExpressCheckout = Util.getBoolean(request,"expresscheckout") || request.getParameter("expresscheckout.x")!=null;
boolean doDirectPayment = Util.getBoolean(request,"directpayment") || request.getParameter("directpayment.x")!=null;
boolean getECDetails = request.getParameter("return")!=null;
boolean cancelEC = request.getParameter("cancel")!=null;
boolean finishExpressCheckout = request.getParameter("finishExpressCheckout")!=null || request.getParameter("finishExpressCheckout.x")!=null;

// return values from PayPal, source differs for EC and DP
String paypalAmount = null;
String paypalTimestamp = null;
String paypalTransactionId = null;

/* load session variables */

PaymentOption paymentOption = (PaymentOption)session.getAttribute("paymentOption");
if (paymentOption==null) paymentOption = new PaymentOption();
double amount = Util.getDouble(session, "amount");

String firstname = Util.getString(session, "firstname");
String lastname =Util.getString(session, "lastname");
String street = Util.getString(session, "street");
String city = Util.getString(session, "city");
String state = Util.getString(session, "state");
String zip = Util.getString(session, "zip");
String phone = Util.getString(session, "phone");
String email = Util.getString(session, "email");

String comments = Util.getString(session, "comments");
    
String cardtype = Util.getString(session, "cardtype");
String cardname = Util.getString(session, "cardname");
String cardaccount = Util.getString(session, "cardaccount");
String cardexpmonth = Util.getString(session, "cardexpmonth");
String cardexpyear = Util.getString(session, "cardexpyear");
String cardcvv2 = Util.getString(session, "cardcvv2");

if (doExpressCheckout || doDirectPayment) {

  /* load posted form data */

  paymentOption = new PaymentOption(application, Util.getInt(request, "paymentoption_id"));
  if (paymentOption.amount==0.00) {
    try {
      String input = Util.getString(request, "amount_"+paymentOption.paymentoption_id);
      amount = Double.parseDouble(input.replace("$",""));
    } catch (Exception ex) {
    }
  } else {
    amount = paymentOption.amount;
  }

  firstname = Util.getString(request,"firstname");
  lastname = Util.getString(request,"lastname");
  street = Util.getString(request,"street");
  city = Util.getString(request,"city");
  state = Util.getString(request,"state");
  zip = Util.getString(request,"zip");
  phone = Util.getString(request,"phone");
  email = Util.getString(request,"email");

  comments = Util.getString(request, "comments");
    
  cardtype = Util.getString(request,"cardtype");
  cardname = Util.getString(request,"cardname");
  cardaccount = Util.getString(request,"cardaccount");
  cardexpmonth = Util.getString(request,"cardexpmonth");
  cardexpyear = Util.getString(request,"cardexpyear");
  cardcvv2 = Util.getString(request,"cardcvv2");
  
  /* store posted data in session attributes */

  session.setAttribute("paymentOption", paymentOption);
  session.setAttribute("amount", ""+amount);

  session.setAttribute("firstname", firstname);
  session.setAttribute("lastname", lastname);
  session.setAttribute("street", street);
  session.setAttribute("city", city);
  session.setAttribute("state", state);
  session.setAttribute("zip", zip);
  session.setAttribute("phone", phone);
  session.setAttribute("email", email);

  session.setAttribute("comments", comments);
    
  session.setAttribute("cardtype", cardtype);
  session.setAttribute("cardname", cardname);
  session.setAttribute("cardaccount", cardaccount);
  session.setAttribute("cardexpmonth", cardexpmonth);
  session.setAttribute("cardexpyear", cardexpyear);
  session.setAttribute("cardcvv2", cardcvv2);

  /* payment choice validation */
  if (amount==0.00) missing.add("paymentoption_id");

  /* contact info validation */
  if (firstname.equals("")) missing.add("firstname");
  if (lastname.equals("")) missing.add("lastname");
  if (street.equals("")) missing.add("street");
  if (city.equals("")) missing.add("city");
  if (state.equals("")) missing.add("state");
  if (zip.equals("")) missing.add("zip");
  if (phone.equals("")) missing.add("phone");
  if (email.equals("")) missing.add("email");
  
  /* direct payment validation */
  if (doDirectPayment) {
    if (cardtype.equals("")) missing.add("cardtype");
    if (cardname.equals("")) missing.add("cardname");
    if (cardaccount.equals("")) missing.add("cardaccount");
    if (cardexpmonth.equals("")) missing.add("cardexpmonth");
    if (cardexpyear.equals("")) missing.add("cardexpyear");
    if (cardcvv2.equals("")) missing.add("cardcvv2");
  }

  if (missing.size()>0) error = "Some required fields are missing.  Please update the <span class=\"error\">highlighted</span> fields.";

  /* Direct Payment */
  if (doDirectPayment && missing.size()==0) {

    // split name into first and last
    String[] cardnames = cardname.split(" ");
    String cardfirstname = cardnames[0];
    String cardlastname = "";
    if (cardnames.length>1) cardlastname = cardnames[1];
        
    // combine expiration month and year
    String cardexpdate = cardexpmonth+cardexpyear;
        
    // borrow address parameters
    String cardstreet = street;
    String cardcity = city;
    String cardstate = state;
    String cardzip = zip;
        
    // name/value pairs
    HashMap parameters = new HashMap();
    parameters.put("PAYMENTACTION", "Sale");
    parameters.put("AMT", ""+amount);
    parameters.put("DESC", paymentOption.name);
    parameters.put("IPADDRESS", request.getRemoteAddr());
    parameters.put("CREDITCARDTYPE", cardtype);
    parameters.put("ACCT", cardaccount);
    parameters.put("EXPDATE", cardexpdate);
    parameters.put("CVV2", cardcvv2);
    parameters.put("FIRSTNAME", cardfirstname);
    parameters.put("LASTNAME", cardlastname);
    parameters.put("STREET", cardstreet);
    parameters.put("CITY", cardcity);
    parameters.put("STATE", cardstate);
    parameters.put("COUNTRYCODE", "US");
    parameters.put("ZIP", cardzip);
    
    try {
      // do direct payment
      paypal = new PayPal(application);
      paypal.doDirectPayment(parameters);
      if (paypal.success) {
	paypalTransactionId = (String)paypal.responseMap.get("TRANSACTIONID");
	paypalAmount = (String)paypal.responseMap.get("AMT");
	paypalTimestamp = (String)paypal.responseMap.get("TIMESTAMP");
      } else {
	error = (String)paypal.responseMap.get("L_LONGMESSAGE0");
	if (paypal.responseMap.get("L_LONGMESSAGE1")!=null) error += " "+(String)paypal.responseMap.get("L_LONGMESSAGE1");
	if (paypal.responseMap.get("L_LONGMESSAGE2")!=null) error += " "+(String)paypal.responseMap.get("L_LONGMESSAGE2");
      }
    } catch (Exception ex) {
      error = ex.getMessage();
    }

  }

  /* Express Checkout */
      
  if (doExpressCheckout && missing.size()==0) {
        
    // form URLs, using "return" and "cancel" as return flags because error.jsp is the actual script
    String url = "http";
    if (request.getServerPort()==443) url += "s";
    url += "://"+request.getServerName();
    String returnURL = url + "/payment.jsp?payment_id="+payment.payment_id+"&return";
    String cancelURL = url + "/payment.jsp?payment_id="+payment.payment_id+"&cancel";

    // name/value pairs
    HashMap parameters = new HashMap();
    parameters.put("RETURNURL", returnURL);
    parameters.put("CANCELURL", cancelURL);
    parameters.put("PAYMENTREQUEST_0_AMT", ""+amount);
    parameters.put("PAYMENTREQUEST_0_PAYMENTACTION", "Sale");
    parameters.put("NOSHIPPING", "1");
    parameters.put("ALLOWNOTE", "1");
    parameters.put("PAYMENTREQUEST_0_CURRENCYCODE", "USD");
    parameters.put("PAYMENTREQUEST_0_DESC", paymentOption.name);
    
    try {
      paypal = new PayPal(application);
      paypal.setExpressCheckout(parameters);
      if (paypal.success) {
	// redirect to PayPal site
	response.sendRedirect(paypal.expressCheckoutURL);
	return;
      }
    } catch (Exception ex) {
      error = ex.getMessage();
    }
    
  }
  
}

if (cancelEC) {
  
  // do any cancellation processing, which there is none
  
}

if (getECDetails) {
  
  String token = request.getParameter("token");
  
  try {
    // get EC details
    paypal = new PayPal(application);
    paypal.getExpressCheckoutDetails(token);
  } catch (Exception ex) {
    error = ex.getMessage();
  }
  
}

if (finishExpressCheckout) {

  // required stuff
  paypalAmount = Util.getString(request,"amount");
  String token = Util.getString(request,"token");
  String payerID = Util.getString(request,"payerid");
  String description = Util.getString(request,"description");
  String currencycode = Util.getString(request,"currencycode");

  // name/value pairs
  HashMap parameters = new HashMap();
  parameters.put("TOKEN", token);
  parameters.put("PAYERID", payerID);
  parameters.put("CURRENCYCODE", "USD");
  parameters.put("PAYMENTREQUEST_0_AMT", paypalAmount);
  parameters.put("PAYMENTREQUEST_0_CURRENCYCODE", currencycode);
  parameters.put("PAYMENTREQUEST_0_DESC", description);
  parameters.put("PAYMENTREQUEST_0_PAYMENTACTION", "Sale");

  try {
    // do EC transaction
    paypal = new PayPal(application);
    paypal.doExpressCheckoutPayment(parameters);
    if (paypal.success) {
      paypalTransactionId = (String)paypal.responseMap.get("PAYMENTINFO_0_TRANSACTIONID");
      paypalAmount = (String)paypal.responseMap.get("PAYMENTINFO_0_AMT");
      paypalTimestamp = (String)paypal.responseMap.get("TIMESTAMP");
    } else {
      error = (String)paypal.responseMap.get("L_LONGMESSAGE0");
      if (paypal.responseMap.get("L_LONGMESSAGE1")!=null) error += " "+(String)paypal.responseMap.get("L_LONGMESSAGE1");
      if (paypal.responseMap.get("L_LONGMESSAGE2")!=null) error += " "+(String)paypal.responseMap.get("L_LONGMESSAGE2");
    }
  } catch (Exception ex) {
    error = ex.getMessage();
  }

}

boolean confirmEC = getECDetails && paypal!=null && paypal.responseMap!=null;
boolean paymentFinished = (doDirectPayment || finishExpressCheckout) && paypal!=null && paypal.responseMap!=null && paypal.success;

if (paymentFinished) {

  // add PayPal numbers to session for printable version
  session.setAttribute("paypalTransactionId", paypalTransactionId); 
  session.setAttribute("paypalAmount", paypalAmount); 
  session.setAttribute("paypalTimestamp", paypalTimestamp); 

  System.out.println("paypalTransactionId="+paypalTransactionId);
  System.out.println("paypalAmount="+paypalAmount); 
  System.out.println("paypalTimestamp="+paypalTimestamp); 

  SimpleDateFormat todayFormat = new SimpleDateFormat("MMMM d, yyyy");
  String today = todayFormat.format(new Date());
  Mailer mailer = new Mailer();

  // send notification email
  String subject = "Online payment submitted by "+firstname+" "+lastname;
  String msg = firstname+" "+lastname+" has submitted the following online payment:\n";
  msg += "\n";
  msg += "Payment Option: "+paymentOption.name+"\n";
  msg += paymentOption.description+"\n";
  msg += "\n";
  msg += "Date: "+today+"\n";
  msg += "Amount: $"+paypalAmount+"\n";
  msg += "\n";
  if (comments.length()>0) msg += "Comments: "+comments+"\n";
  msg += "\n";
  msg += firstname+" "+lastname+"\n";
  msg += street+"\n";
  msg += city+", "+state+" "+zip+"\n";
  msg += "\n";
  msg += "phone: "+phone+"\n";
  msg += "email: "+email+"\n";
  msg += "\n";
  // add diagnostic PayPal dump
  msg += "PayPal data:\n";
  Iterator keyIterator = paypal.responseMap.keySet().iterator();
  while (keyIterator.hasNext()) {
    String key = (String)keyIterator.next();
    String value = (String)paypal.responseMap.get(key);
    msg += key+"="+value+"\n";
  }
  // send it
  mailer.send(email, firstname+" "+lastname, payment.recipientemail, payment.recipientname, subject, msg);

  // send confirmation email to payer
  subject = "Thank you for your online payment to "+Setting.getString(application, "site_name");
  msg = "Dear "+firstname+", \n";
  msg += "\n";
  msg += payment.thankyou+"\n";
  msg += "\n";
  msg += "Payment Option: "+paymentOption.name+"\n";
  msg += paymentOption.description+"\n";
  msg += "\n";
  msg += "Date: "+today+"\n";
  msg += "Amount: $"+paypalAmount+"\n";
  msg += "\n";
  if (comments.length()>0) msg += "Comments: "+comments+"\n";
  msg += "\n";
  msg += "Received from:\n";
  msg += "\n";
  msg += firstname+" "+lastname+"\n";
  msg += street+"\n";
  msg += city+", "+state+" "+zip+"\n";
  msg += "\n";
  msg += "phone: "+phone+"\n";
  msg += "email: "+email+"\n";
  msg += "\n";
  msg += "PayPal transaction ID: "+paypalTransactionId+"\n";
  msg += "PayPal timestamp: "+paypalTimestamp+"\n";

  // send it from the first of the notification recipients
  mailer.send(payment.recipientemail, payment.recipientname, email, firstname+" "+lastname, subject, msg);

  // clear session vars
  /*
    session.removeAttribute("paymentOption");
    session.removeAttribute("amount");
    session.removeAttribute("firstname");
    session.removeAttribute("lastname");
    session.removeAttribute("street");
    session.removeAttribute("city");
    session.removeAttribute("state");
    session.removeAttribute("zip");
    session.removeAttribute("phone");
    session.removeAttribute("email");
    session.removeAttribute("comments");
    session.removeAttribute("cardtype");
    session.removeAttribute("cardname");
    session.removeAttribute("cardaccount");
    session.removeAttribute("cardexpmonth");
    session.removeAttribute("cardexpyear");
    session.removeAttribute("cardcvv2");
  */
    
}
%>
<% if (request.getParameter("printable")!=null) { %>
<%@ include file="/WEB-INF/include/head-payment-printable.jhtml" %>
<% if (showNetSolSeal) { %><script language="JavaScript" src="https://seal.networksolutions.com/siteseal/javascript/siteseal.js" type="text/javascript"></script><% } %>
<% if (showHeader) { %><%@ include file="/WEB-INF/include/header-printable.jhtml" %><% } %>
<% if (showSectionheader) { %><%@ include file="/WEB-INF/include/sectionheader.jhtml" %><% } %>
<% if (showSubheader) { %><%@ include file="/WEB-INF/include/subheader-printable.jhtml" %><% } %>
<!-- main region, printable -->
<table id="main" cellspacing="0" width="100%">
  <tr>
    <td id="main-right" valign="top">
      <% if (showPageTitle) { %><%@ include file="/WEB-INF/include/pagetitle.jhtml" %><% } %>
      <% if (!paymentsEnabled) { %>
      <div class="error">Payments have not been enabled on this site.  Check Settings.</div>
      <% } else if (payment.isDefault()) { %>
      <div class="error">payment_id has not been supplied.</div>
      <% } else { %>
      <%@ include file="/WEB-INF/include/payment.jhtml" %>
      <% } %>
    </td>
  </tr>
</table>
<% if (showFooter) { %><%@ include file="/WEB-INF/include/footer-printable.jhtml" %><% } %>
<% } else { %>
<%@ include file="/WEB-INF/include/head-payment.jhtml" %>
<% if (showNetSolSeal) { %><script language="JavaScript" src="https://seal.networksolutions.com/siteseal/javascript/siteseal.js" type="text/javascript"></script><% } %>
<% if (showHeader) { %><%@ include file="/WEB-INF/include/header.jhtml" %><% } %>
<% if (showNavPrimary) { %><%@ include file="/WEB-INF/include/nav-primary.jhtml" %><% } %>
<% if (showNavPrimaryDhtml) { %><%@ include file="/WEB-INF/include/dhtml.jhtml" %><% } %>
<% if (showSectionheader) { %><%@ include file="/WEB-INF/include/sectionheader.jhtml" %><% } %>
<% if (showSubheader) { %><%@ include file="/WEB-INF/include/subheader.jhtml" %><% } %>
<!-- main region -->
<table id="main" cellspacing="0" width="100%">
  <tr>
    <% if (showSidebar) { %><td id="main-left" valign="top"><% } %>
      <% if (showSidebar) { %><%@ include file="/WEB-INF/include/sidebar-top.jhtml" %><% } %>
      <% if (showSidebar && showNavVertical) { %><%@ include file="/WEB-INF/include/nav-vertical.jhtml" %><% } %>
      <% if (showSidebar) { %><%@ include file="/WEB-INF/include/sidebar-bottom.jhtml" %><% } %>
      <% if (showSidebar) { %></td><% } %>
    <td id="main-right" valign="top">
      <% if (showPageTitle) { %><%@ include file="/WEB-INF/include/pagetitle.jhtml" %><% } %>
      <% if (!paymentsEnabled) { %>
      <div class="error">Payments have not been enabled on this site.  Check Settings.</div>
      <% } else if (payment.isDefault()) { %>
      <div class="error">payment_id has not been supplied.</div>
      <% } else { %>
      <%@ include file="/WEB-INF/include/payment.jhtml" %>
      <% } %>
    </td>
  </tr>
</table>
<% if (showFooter) { %><%@ include file="/WEB-INF/include/footer.jhtml" %><% } %>
<% } %>
<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/foot.jhtml" %>
