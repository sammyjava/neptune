<%@ page import="net.ims.jcms.*,net.ims.jcms.extras.*,org.devlib.schmidt.imageinfo.ImageInfo,com.oreilly.servlet.*,org.json.*" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.io.File,java.io.FileInputStream,java.io.PrintWriter,java.io.BufferedWriter,java.io.FileWriter" %>
<%@ page import="java.text.DateFormatSymbols,java.text.SimpleDateFormat,java.text.NumberFormat" %>
<%@ page import="java.util.Calendar,java.util.Date,java.util.TimeZone,java.util.TreeSet,java.util.TreeMap,java.util.Iterator,java.util.Vector" %>
<%
/**
 * This file is for Web app-specific initialization.
 * Any general processing should be coded as methods in the classes.
 * Settings are all in the database, so that web.xml can be static with the app.
  */

// force request encoding to be UTF-8
request.setCharacterEncoding("UTF-8");

// error message and confirmation message used by all scripts
String error=null;
String message=null;

// timing variables
long startTime = new Date().getTime();

// debug
String debugMessage = "";
boolean debug = true;

/**
 * Entire page is wrapped in a try/catch/finally block.
 */
try {

  /**
   * Check login status, get User if logged in, else redirect
   */
  User user = null;
  ControlPanelUser cpuser = null;
  boolean userLoggedIn = false;
  try {
    cpuser = new ControlPanelUser(session);
    user = Util.getUser(application, cpuser.username);
    userLoggedIn = true;
  } catch (Exception ex) {
    response.sendRedirect("/cp/index.jsp");
    return;
  }

  // time format for site timezone, used to display timestamps
  String timezone = DB.getTimeZone(application);
  TimeZone tz = TimeZone.getTimeZone(timezone);
  TimeZone.setDefault(tz);  
  SimpleDateFormat sdf = new SimpleDateFormat();
  sdf.setTimeZone(tz);
  sdf.applyPattern("dd MMM yyyy HH:mm:ss zzz");

  /**
   * Set configuration settings
   */
  Settings settings = new Settings(application);

  debug = settings.getBoolean("site_debug");

  String siteName = settings.getString("site_name");

  // root context; needed since we're in cp context here
  String rootFolder = settings.getString("site_rootfolder");

  // location of public uploaded images
  String imageFolder = settings.getString("site_imagefolder");
  String imageDir = settings.getString("site_imagedir");

  // location of uploaded design file directory
  String designFolder = settings.getString("site_designfolder");
  String designDir = settings.getString("site_designdir");

  // location of generated CSS files
  String cssFolder = settings.getString("site_cssfolder");
  String cssDir = settings.getString("site_cssdir");

  // location of uploaded media
  String mediaFolder = settings.getString("site_mediafolder");
  String mediaDir = settings.getString("site_mediadir");

  // location of SearchBlox xsl files
  String searchbloxCssDir = settings.getString("searchblox_cssdir");
  String searchbloxXslDir = settings.getString("searchblox_xsldir");

  // maximum upload size for files in bytes
  int maxUploadSize = settings.getInt("site_maxuploadsize");

  // enable primary nav links; if disabled, child creation allowed on empty level 1 nodes
  boolean navPrimaryLevel1Enable = settings.getBoolean("navpri_level1_enable");

  // SSL host; if set, triggers SSL checkbox on Nodes tool
  boolean sslHostEnable = settings.getString("site_sslhost").length()>0;

  // WYSIWYG toggle
  boolean enableWysiwyg = settings.getBoolean("cp_enable_wysiwyg");

  /**
   * Content variables, etc.
   */
  boolean useZapatec = false; // set true on tools that use Zapatec
  String pageTitle = "SET pageTitle!";
  String pageHeading = null;
  String docUrl = null;
%>
