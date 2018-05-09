<%@ include file="/WEB-INF/include/init.inc" %>
<% pageTitle = "Docs - Tree"; %>
<%@ include file="/WEB-INF/include/header.jhtml" %>

<%@ include file="/WEB-INF/include/doc-nav.jhtml" %>

<p>
  The <b>Tree</b> tool is really a viewer &mdash; it allows you to view all the nodes, pages and media on your site at a glance.  The layout is that of a classic site map: primary nodes
  extend across horizontally, with secondary, tertiary and quaternary nodes below them.  When you mouse over a bold node number, a window will open near the top of the browser showing information about
  the page that is currently scheduled on that node.  Nodes that have media, URLs or redirects currently scheduled are shown in normal text.  Nodes that are currently inactive are shown
  the <span class="inactive">inactive</span> color.  Click on the node link to go to the page editor for that page.
</p>

<p>
  <b>Orphaned Pages.</b><br/>
  Orphaned pages are pages that have never been scheduled to appear on a node.  Click on a page ID to be taken to the page editor. 
</p>


<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/footer.jhtml" %>

