<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="net.ims.jcms.*" %>
<%
// instantiate the default access user
AccessUser au = Util.getDefaultAccessUser(application); // default user (public)

// flag whether access in use at all  
boolean accessEnabled = AccessRole.nodeCount(application)>0;

// instantiate from the session, if stored
if (au.isDefault() && session.getAttribute("AccessUser")!=null) au = (AccessUser)session.getAttribute("AccessUser");

// use SSL host for SSL nodes
String sslHost = Setting.getString(application, "site_sslhost");

// get headlines settings, determine if description is shown or not
boolean showDescription = Setting.getBoolean(application, "headlines_showdescription");
String readMore = Setting.getString(application, "headlines_readmore");
boolean showPageTitle = Setting.getBoolean(application, "headlines_showpagetitle");
boolean showHidden = Setting.getBoolean(application, "headlines_showhidden");

// the parent_nid passed is the parent of the displayed node headlines; if missing, bail.
int parent_nid = Util.getInt(request, "parent_nid");
if (parent_nid==0) {
  out.println("<div class=\"error\">You must supply a parent node id value to the headlines.jsp extra, for example /headlines.jsp?parent_nid=1234</div>");
  return;
}

Node parent = new Node(application, parent_nid);
boolean hasChildren = false;
if (showHidden) {
  hasChildren = parent.hasChildren(application);
} else {
  hasChildren = parent.hasVisibleChildren(application);
}
%>
<div class="headlines">
<%@ include file="/WEB-INF/custom/headlines.jhtml" %>
<%
if (!customHeadlines) {
  if (hasChildren) {
    NodeListIterator parentIterator = parent.getNodeListIterator(application);
    while (parentIterator.hasNext()) {
      Node child = parentIterator.nextNode();
      String url = null;
      boolean showChild = false;
      if (showHidden) {
	showChild = child.active && (!accessEnabled || au.mayAccess(application, child));
      } else {
	showChild = child.isVisible() && (!accessEnabled || au.mayAccess(application, child));
      }
      if (showChild) {
	if (child.ssl) {
	  url = "https://"+sslHost+application.getContextPath()+child.url;
	} else {
	  url = child.url;
	}
	String headline = child.nodename;
	String description = null;
	if (showPageTitle || showDescription) {
	  NodeLink childNodeLink = child.getCurrentNodeLink(application);
	  if (childNodeLink.isPage()) {
	    Page p = childNodeLink.getPage(application);
	    if (showPageTitle) headline = p.title;
	    description = p.metadescription;
	  }
	}
  %>
  <div class="headline"><a class="headline" <% if (child.isExternal()) { %>target="_blank"<% } %> href="<%=url%>"><%=headline%></a></div>
<% if (showDescription && description!=null && description.length()>0) { %><div class="headline-description"><%=description%> <a class="headline-readmore" <% if (child.isExternal()) { %>target="_blank"<% } %> href="<%=url%>"><%=readMore%></a></div><% } %>
  <%
      } // showChild
    } // hasNext
  } // hasChildren
} // customHeadlines
%>
</div>
