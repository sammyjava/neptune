<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="net.ims.jcms.*,net.ims.jcms.extras.*" %>
<%@ page import="java.io.File,java.io.FileInputStream,java.io.PrintWriter,java.io.BufferedWriter,java.io.FileWriter" %>
<%@ page import="java.text.DateFormatSymbols,java.text.SimpleDateFormat,java.sql.Timestamp" %>
<%@ page import="java.util.Calendar,java.util.Date,java.util.Locale,java.util.TreeSet,java.util.Iterator,java.util.Vector" %>
<%
/**
 * This file is for Web app-specific initialization.
 * Any general processing should be coded as methods in the classes.
 * Site settings should be stored in the settings table; web.xml is static.
 *
 * Try to initialize all global variables here, so we can keep track of them.
 */

// force request encoding to be UTF-8
request.setCharacterEncoding("UTF-8");

// timing variables
long startTime = new Date().getTime();

// debug
boolean debug = true;
String debugMessage = "";

/**
 * Entire page is wrapped in a try/catch/finally block between init.inc and close.inc
 */
try {

  /**
   * Set configuration settings from settings table
   */
  Settings settings = new Settings(application);
  
  // overall site settings
  debug = settings.getBoolean("site_debug");
  String siteName = settings.getString("site_name");
  boolean siteShowRssIcon = settings.getBoolean("site_showrssicon");
  String siteHead = settings.getString("site_head");
  String errorHeadTitle = settings.getString("site_404_headtitle");
  String errorPageTitle = settings.getString("site_404_pagetitle");
  String errorContent = settings.getString("site_404_content");

  // mobile stuff
  com.handinteractive.mobile.UAgentInfo agentInfo = new com.handinteractive.mobile.UAgentInfo(request.getHeader("user-agent"), request.getHeader("accept"));
  boolean mobileEnable = settings.getBoolean("mobile_enable");
  boolean mobileDetected = (agentInfo.getIsTierTablet() || agentInfo.getIsTierIphone());
  boolean forceDesktop = false;
  if (request.getParameter("force-desktop")!=null) {
    if (request.getParameter("force-desktop").equals("true")) {
      forceDesktop = true;
      session.setAttribute("force-desktop", "true");
    } else {
      session.removeAttribute("force-desktop");
    }
  } else if (session.getAttribute("force-desktop")!=null && session.getAttribute("force-desktop").equals("true")) {
    forceDesktop = true;
  }

  // uploaded and generated file folders
  String rootFolder = settings.getString("site_rootfolder");
  String imageFolder = rootFolder+settings.getString("site_imagefolder");
  String designFolder = rootFolder+settings.getString("site_designfolder");
  String cssFolder = rootFolder+settings.getString("site_cssfolder");
  String mediaFolder = rootFolder+settings.getString("site_mediafolder");

  // enable/disable regions on root node
  boolean rootHeaderEnable = settings.getBoolean("root_header_enable");
  boolean rootNavPrimaryEnable = settings.getBoolean("root_nav_primary_enable");
  boolean rootSectionheaderEnable = settings.getBoolean("root_sectionheader_enable");
  boolean rootSubheaderEnable = settings.getBoolean("root_subheader_enable");
  boolean rootFooterEnable = settings.getBoolean("root_footer_enable");

  // enable/disable regions on rest of site
  boolean headerEnable = settings.getBoolean("header_enable");
  boolean subheaderEnable = settings.getBoolean("subheader_enable");
  boolean sectionHeaderEnable = settings.getBoolean("sectionheader_enable");
  boolean sidebarEnable = settings.getBoolean("sidebar_enable");
  boolean footerEnable = settings.getBoolean("footer_enable");

  // toggle DHTML primary navigation
  boolean navPrimaryDhtmlEnable = settings.getBoolean("navpri_dhtml_enable");
  // toggle rollover images on primary navigation links
  boolean navPrimaryImages = settings.getBoolean("navpri_images");
  // enable primary nav links, so only DHTML links exist (must have navPrimaryDhtmlEnable=true!)
  boolean navPrimaryLevel1Enable = settings.getBoolean("navpri_level1_enable");
  // display primary nav vertically along with secondary nav; disables DHTML
  boolean navPrimaryVertical = settings.getBoolean("navpri_vertical");
  if (navPrimaryVertical) navPrimaryDhtmlEnable = false;
  
  // enable quaternary navigation
  boolean navQuaternaryEnable = settings.getBoolean("navquat_enable");

  // enable breadcrumbs, get separator
  boolean breadCrumbsEnable = settings.getBoolean("breadcrumbs_enable");
  String breadCrumbsSeparator = settings.getString("breadcrumbs_separator");

  // enable pagetitle, set level 1 visibility
  boolean pageTitleEnable = settings.getBoolean("pagetitle_enable");
  boolean pageTitleLevel1 = settings.getBoolean("pagetitle_level1");


  // SSL option
  String httpHost = settings.getString("site_host");
  String sslHost = settings.getString("site_sslhost");
  boolean sslHostEnable = (sslHost.length()>0);

  // Google analytics 
  String googleTrackerId = settings.getString("google_tracker_id");
  boolean googleTrackerEnable = (googleTrackerId.length()>0);

  // SoftSlate
  String softslateContext = settings.getString("softslate_context");
  boolean softslateSitemap = settings.getBoolean("softslate_sitemap");

  // store initial referrer for use in forms later on
  if (session.getAttribute("Referer")==null) session.setAttribute("Referer", request.getHeader("Referer"));

  /**
   * Access User
   */
  // set flag to enable access calls if access control not in use
  boolean accessEnabled = AccessRole.nodeCount(application)>0;
  // instantiate the default access user
  AccessUser au = Util.getDefaultAccessUser(application); // default user (public)
  // control variables
  boolean logIn = request.getParameter("access-login")!=null;
  boolean logOut = request.getParameter("access-logout")!=null;
  // validation flags, used by access.jsp
  boolean accessLoginUsernameInvalid = false;
  boolean accessLoginPasswordInvalid = false;
  // result flags, used by access.jsp
  boolean accessLoginSuccessful = false;
  boolean accessLoginFailed = false;
  boolean accessLogoutSuccessful = false;
  String accessLoginError = null;
  if (logIn) {
    // process an access login
    String accessLoginUsername = request.getParameter("accessloginusername");
    String accessLoginPassword = request.getParameter("accessloginpassword");
    // attempt to get a local (to this module) AccessUser with these credentials
    try {
      au = au.getAccessUser(application, accessLoginUsername, accessLoginPassword);
      // success; store session object
      session.setAttribute("AccessUser", au);
      accessLoginSuccessful = true;
    } catch (AccessUserException ex) {
      // failure; remove session object just in case
      session.removeAttribute("AccessUser");
      accessLoginFailed = true;
      accessLoginError = ex.getMessage();
    }
  } else if (logOut) {
    // process a logout
    session.removeAttribute("AccessUser");
    accessLogoutSuccessful = true;
  } else {
    // instantiate from the session, if stored
    if (au.isDefault() && session.getAttribute("AccessUser")!=null) au = (AccessUser)session.getAttribute("AccessUser");
  }

  /**
   * Other variables
   */
  boolean searchResults = false; // toggles an extra stylesheet
  String contextPath = request.getContextPath(); // used by error.jsp
  String requestURI = request.getRequestURI();   // used by error.jsp
  boolean noCopy = request.getParameter("nocopy")!=null && request.getParameter("nocopy").equals("true"); // disable content copy so only extensions shown
  boolean isError = false; // error page flag
%>
<%@ include file="/WEB-INF/custom/init.inc" %>
<%
  /**
   * Instantiate the current node and any other nodes we keep track of
   */
  
  // always need the root node
  Node root = new Node(application, 0);
  
  // default node
  Node n = new Node();
  
  // set node if nid passed in query string
  if (request.getParameter("nid")!=null) {
    int nid = Integer.parseInt(request.getParameter("nid"));
    n = new Node(application, nid);
    // redirect to error page if requested node doesn't exist
    if (n.isDefault() && nid!=0) {
      response.sendRedirect("error.jsp");
      return;
    }
  }

  // if node is still not set, may be error page called from alias
  if (n.isDefault()) {
    try {
      // find node with alias that matches this requestURI (minus contextPath and /)
      String errorRequestURI = pageContext.getErrorData().getRequestURI();
      debugMessage = requestURI+": "+errorRequestURI;
      String alias = errorRequestURI.substring(contextPath.length()+1);
      if (alias.startsWith("/")) alias = alias.substring(1);
      n = new Node(application, alias);
%>
<%@ include file="/WEB-INF/custom/node.inc" %>
<%
      // SSL/non-SSL redirect if needed
      if (!n.isDefault() && sslHostEnable) {
	if (n.ssl && request.getServerPort()!=443) {
	  String url = "https://"+sslHost+errorRequestURI;
	  if (request.getQueryString()!=null) url += "?"+request.getQueryString();
	  response.sendRedirect(url);
	  return;
	}
	if (!n.ssl && request.getServerPort()==443) {
	  String url = "http://"+httpHost+errorRequestURI;
	  if (request.getQueryString()!=null) url += "?"+request.getQueryString();
	  response.sendRedirect(url);
	  return;
	}
      }

      // set status=SC_OK=200 if node found, otherwise status will already be 404 if this is error page
      if (!n.isDefault()) response.setStatus(HttpServletResponse.SC_OK);

    } catch (Exception e) {
      // trap when this isn't actually thrown as an error, it's normal behavior for a non-error page
    }
  }

  // get level 1 node for display purposes
  Node level1 = null;
  if (n.getDepth()==1) {
    level1 = n;
  } else if (n.getDepth()>1) {
    // iterate up to level 1
    level1 = n;
    while (level1.getDepth()>1) level1 = level1.getParent(application);
  }

  // get this node's link
  NodeLink nl = n.getCurrentNodeLink(application);

  // redirect to error page if requested node is not linked
  if (nl==null) {
    response.sendRedirect("error.jsp");
    return;
  }

  // redirect if it's a URL or Media file
  if (nl.isUrl() || nl.isMedia()) {
    response.sendRedirect(nl.getUrl(application));
    return;
  }

  // if it's a redirect, switch the node, get the new nodelink, recursively
  while (nl.isRedirect()) {
    n = nl.getRedirectNode(application);
    nl = n.getCurrentNodeLink(application);
  }

  // redirect to SSL host if SSL node and not currently on SSL, and vice versa
  if (sslHostEnable && !n.isDefault()) {
    if (n.ssl && request.getServerPort()!=443) {
      String url = "https://"+sslHost+request.getRequestURI();
      if (request.getQueryString()!=null) url += "?"+request.getQueryString();
      response.sendRedirect(url);
      return;
    }
    if (!n.ssl && request.getServerPort()==443) {
      String url = "http://"+httpHost+request.getRequestURI();
      if (request.getQueryString()!=null) url += "?"+request.getQueryString();
      response.sendRedirect(url);
      return;
    }
  }

  // get node parent, grandparent and greatgrandparent
  Node parent = n.getParent(application);
  Node grandparent = null;
  if (parent!=null) grandparent = parent.getParent(application);
  Node greatgrandparent = null;
  if (grandparent!=null) greatgrandparent = grandparent.getParent(application);

  // node access
  boolean accessAllowed = !accessEnabled || au.mayAccess(application, n);

  /**
   * Display logic
   */
  boolean showMobile = mobileEnable && mobileDetected && !forceDesktop;
  boolean showHeader = (!n.isDefault() && headerEnable) || (n.isDefault() && rootHeaderEnable);
  boolean showNavPrimaryDhtml = navPrimaryDhtmlEnable && !showMobile;
  boolean showSubheader = (!n.isDefault() && subheaderEnable) || (n.isDefault() && rootSubheaderEnable);
  boolean showSectionheader = (!n.isDefault() && sectionHeaderEnable) || (n.isDefault() && rootSectionheaderEnable);
  boolean showFooter = (!n.isDefault() && footerEnable) || (n.isDefault() && rootFooterEnable);
  boolean showNavPrimary = !navPrimaryVertical && (!n.isDefault() || rootNavPrimaryEnable);
  boolean showNavVertical = navPrimaryVertical;
  boolean showSidebar = sidebarEnable && (showNavVertical || !n.isDefault() || isError);
  showSidebar = showSidebar && !showMobile;
  boolean showNavSecondary = level1!=null && level1.hasVisibleChildren(application);
  boolean showNavQuaternary = navQuaternaryEnable && (n.getDepth()==4 || (n.getDepth()==3 && n.hasChildren(application)));
  boolean showBreadCrumbs = breadCrumbsEnable && !n.isDefault();
  boolean showPageTitle = pageTitleEnable && !n.isDefault() && (parent.nid!=0 || pageTitleLevel1);
  // these can be toggled off in extensions, etc.
  boolean showPrintableLink = true;

  navPrimaryImages = navPrimaryImages && !showMobile;

  /**
   * Instantiate the current page and get the layout
   */

  Page p = new Page(); // default page
  if (nl!=null && nl.isPage()) p = nl.getPage(application);
  Layout layout = p.getLayout(application);
  LayoutPane[] panes = layout.getLayoutPanes(application, showMobile);
%>
<%@ include file="/WEB-INF/custom/page.inc" %>
