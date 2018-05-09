<%@ page import="net.ims.jcms.*, java.util.*, java.io.*" contentType="text/html; charset=UTF-8" %>
<%
 /**
  * Standalone index page, processes login.  Redirect here if cpusername session variable is not set.
  */

  // redirect to SSL host if listed in Settings
  // COMMENTED OUT FOR MSO LOAD BALANCING
  /**
  String sslHost = Setting.getString(application, "site_sslhost");
  if (sslHost.length()>0 && request.getServerPort()!=443) {
    response.sendRedirect("https://"+sslHost+"/cp");
    return;
  }
  **/
  
  // needed since we don't include init.inc
  String siteName = Setting.getString(application, "site_name");
  java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("d MMM yyyy");

  // global vars outside of try/catch block
  String pageTitle = "Login";
  int extra_id = 0;
  User user = null;
  ControlPanelUser cpuser = null;
  boolean userLoggedIn = (session.getAttribute("cpusername")!=null);

  // error message and confirmation message used by all scripts
  String error=null;
  String message=null;

  // timing variables
  long startTime = new java.util.Date().getTime();

  // need designFolder for favicon.ico
  String designFolder = Setting.getString(application, "site_designfolder");

  // debug
  String debugMessage = "";
  boolean debug = Setting.getBoolean(application, "site_debug");

  // use DB to get DB info
  DB db = null;
  String dbName = null;
  String dbVersion = null;
  String dbTimeZone = null;

  try {
    
    // get DB info from DB object
    db = new DB(application);
    dbName = db.getDBName();
    dbVersion = db.getDBVersion();
    dbTimeZone = db.getTimeZone();
    
    // process login using site's User class
    if (request.getParameter("login")!=null) {
      String user_username = request.getParameter("user_username");
      String user_password = request.getParameter("user_password");
      if (user_username.length()==0 || user_password.length()==0) {
        userLoggedIn = false;
        error = "Username and Password are required.  Please try again.";
        session.removeAttribute("cpusername");
      } else {
        // check license for core feature 0, throws LicenseInvalidException if invalid
        License license = new License(request);
        license.check(request, 0);
        // instantiate user, set session var, throws UserNotFoundException if invalid
        try {
          user = Util.getUser(application, user_username, user_password);
          userLoggedIn = true;
          session.setAttribute("cpusername", user.getUsername());
        } catch (UserException ex) {
          userLoggedIn = false;
          session.removeAttribute("cpusername");
          error = "You have entered an incorrect Username and/or Password.";
          debugMessage = ex.toString();
        }

      }
    }

    // process logout
    if (request.getParameter("logout")!=null) {
      userLoggedIn = false;
      session.removeAttribute("cpusername");
      message = "You have been logged out.";
    }

  } catch (Exception e) {

    error = e.toString();
    
  } finally {
    
    if (db!=null) db.close();
    
  } // end try/catch/finally

  if (userLoggedIn) {
    try {
      pageTitle = "Home";
      String cpusername = (String)session.getAttribute("cpusername");
      user = Util.getUser(application, cpusername);
      cpuser = new ControlPanelUser(application, user);
    } catch (Exception ex) {
      userLoggedIn = false;
    }
  }

  boolean useZapatec = false;
  String docUrl = null;
%>
<%@ include file="/WEB-INF/include/header.jhtml" %>
<%
if (user!=null && userLoggedIn) {
    License license = new License(request);
    // show warning if license expires in less than a month
    Calendar expiration = Calendar.getInstance();
    expiration.setTime(license.expiration);
    Calendar plusMonth = Calendar.getInstance();
    plusMonth.add(Calendar.MONTH, 1);
    if (expiration.before(plusMonth)) error = "WARNING: your license expires in less than one month!";
    // welcome message
    message = "Welcome to the Neptune control panel! Please choose a tool above.";
%>
<%@ include file="/WEB-INF/include/errormessage.jhtml" %>
<%@ include file="updates.jhtml" %>
<%@ include file="serverstats.jhtml" %>
<%
} else {
%>
<%@ include file="/WEB-INF/include/errormessage.jhtml" %>
<%@ include file="login.jhtml" %>
<%
}

// clean-up tasks
long endTime = new java.util.Date().getTime();
%>
<%@ include file="/WEB-INF/include/footer.jhtml" %>
