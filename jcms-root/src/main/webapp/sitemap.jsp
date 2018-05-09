<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/WEB-INF/include/init.inc" %>
<%
  // override page
  p.pid = 0; // site map isn't a page
  p.title = Setting.getString(application,"sitemap_pagetitle");
  p.headtitle = Setting.getString(application,"sitemap_headtitle");
  showPageTitle = pageTitleEnable;
%>
<% if (request.getParameter("printable")!=null) { %>
<%@ include file="/WEB-INF/include/head-printable.jhtml" %>
<% if (showHeader) { %><%@ include file="/WEB-INF/include/header-printable.jhtml" %><% } %>
<% if (showSectionheader) { %><%@ include file="/WEB-INF/include/sectionheader.jhtml" %><% } %>
<% if (showSubheader) { %><%@ include file="/WEB-INF/include/subheader-printable.jhtml" %><% } %>
<!-- main region, printable -->
<table id="main" cellspacing="0" width="100%">
  <tr>
    <td id="main-right" valign="top">
      <% if (showPageTitle) { %><%@ include file="/WEB-INF/include/pagetitle.jhtml" %><% } %>
      <%@ include file="/WEB-INF/include/sitemap.jhtml" %>
    </td>
  </tr>
</table>
<% if (showFooter) { %><%@ include file="/WEB-INF/include/footer-printable.jhtml" %><% } %>
<% } else { %>
<%@ include file="/WEB-INF/include/head-sitemap.jhtml" %>
<% if (showHeader) { %><%@ include file="/WEB-INF/include/header.jhtml" %><% } %>
<% if (showNavPrimary) { %><%@ include file="/WEB-INF/include/nav-primary.jhtml" %><% } %>
<% if (showSectionheader) { %><%@ include file="/WEB-INF/include/sectionheader.jhtml" %><% } %>
<% if (showSubheader) { %><%@ include file="/WEB-INF/include/subheader.jhtml" %><% } %>
<!-- main region -->
<table id="main" cellspacing="0" width="100%">
  <tr>
    <td id="main-right" valign="top">
      <% if (showPageTitle) { %><%@ include file="/WEB-INF/include/pagetitle.jhtml" %><% } %>
      <%@ include file="/WEB-INF/include/sitemap.jhtml" %>
    </td>
  </tr>
</table>
<% if (showFooter) { %><%@ include file="/WEB-INF/include/footer.jhtml" %><% } %>
<% } %>
<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/foot.jhtml" %>
