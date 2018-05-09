<%@ include file="/WEB-INF/include/init.inc" %>
<% pageTitle = "Docs - Site Map and Site RSS Feed"; %>
<%@ include file="/WEB-INF/include/header.jhtml" %>
<%@ include file="/WEB-INF/include/doc-nav.jhtml" %>

<p>
  A common Utility Link is the front-end site map for your site.  The site map will only show nodes that the user may access.  If the user is authenticated to view access-restricted nodes,
  those will appear on the site map.
</p>

<p>
  The URL for the site map is simply <b>/sitemap.jsp</b>.  It is styled using the <b>sitemap</b> stylesheet.
</p>

<p>
  A similar function is the site-wide RSS feed, at <b>/rss.jsp</b>.  Ths RSS feed displays page titles and page META/RSS descriptions.  Therefore, for it to be useful, you should populate the
  page title and META/RSS descriptions on all of your pages!  This is a good idea in general, of course.
</p>

<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/footer.jhtml" %>
