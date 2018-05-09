<%@ include file="/WEB-INF/include/init.inc" %>
<% pageTitle = "Docs - Content"; %>
<%@ include file="/WEB-INF/include/header.jhtml" %>

<%@ include file="/WEB-INF/include/doc-nav.jhtml" %>

<p>
  The <b>Content</b> editor allows you to edit content items independently from the pages they are associated with.  A primary use of the
  tool is to search for occurrences of given text (like a bad link), using the filter, and to quickly replace it.  If the content item is
  associated with pages, links to those pages are shown above the editor.
</p>

<p>
  The tool uses the same content editor used on the <a href="doc-page.jsp">Pages tool</a>.  It has no extra functionality; it is just handy to be able to find and edit content without
  going through the Pages tool.
</p>

<p>
  Note that you may only edit content items on which you have edit permission (displayed on a page on which you have edit permission, or orphaned).
</p>

<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/footer.jhtml" %>

