<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/WEB-INF/include/init.inc" %>
<%
  // override page
  p.pid = 0; // access page isn't a page
  p.title = Setting.getString(application,"access_login_title");
  p.headtitle = siteName + " : " + p.title;
  String pageTitle = Setting.getString(application,"access_login_linktext");
  if (accessLogoutSuccessful) pageTitle = Setting.getString(application,"access_logout_linktext");
%>
<%@ include file="/WEB-INF/include/head.jhtml" %>
<% if (showHeader) { %><%@ include file="/WEB-INF/include/header.jhtml" %><% } %>
<% if (showNavPrimary) { %><%@ include file="/WEB-INF/include/nav-primary.jhtml" %><% } %>
<% if (navPrimaryDhtmlEnable) { %><%@ include file="/WEB-INF/include/dhtml.jhtml" %><% } %>
<% if (showSectionheader) { %><%@ include file="/WEB-INF/include/sectionheader.jhtml" %><% } %>
<% if (showSubheader) { %><%@ include file="/WEB-INF/include/subheader.jhtml" %><% } %>
<!-- main region -->
<table id="main" cellspacing="0" width="100%">
  <tr>
    <% if (showSidebar) { %><td id="main-left" valign="top"><% } %>
      <% if (showSidebar) { %><%@ include file="/WEB-INF/include/sidebar-top.jhtml" %><% } %>
      <% if (showSidebar && showNavSecondary && !showNavVertical) { %><%@ include file="/WEB-INF/include/nav-secondary.jhtml" %><% } %>
      <% if (showSidebar && showNavVertical) { %><%@ include file="/WEB-INF/include/nav-vertical.jhtml" %><% } %>
      <% if (showSidebar) { %><%@ include file="/WEB-INF/include/sidebar-bottom.jhtml" %><% } %>
    <% if (showSidebar) { %></td><% } %>
    <td id="main-right" valign="top">
      <% if (pageTitleEnable) { %><div id="pagetitle"><%=pageTitle%></div><% } %>
      <table id="l1" cellspacing="0" width="100%">
        <tr>
          <td valign="top" id="l1_p1">
            <%@ include file="/WEB-INF/include/access.jhtml" %>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
<% if (showFooter) { %><%@ include file="/WEB-INF/include/footer.jhtml" %><% } %>
<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/foot.jhtml" %>
