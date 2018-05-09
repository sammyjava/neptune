<%@ include file="/WEB-INF/include/init.inc" %>
<%
  pageTitle = "Page Editor";
  pageHeading = "<a href=\"page.jsp\">Page Editor</a> | Orphaned Pages";
  docUrl="doc-content.jsp";
%>
<%@ include file="/WEB-INF/include/header.jhtml" %>
<%@ include file="/WEB-INF/include/subheader.jhtml" %>
<%
  boolean purge = request.getParameter("purge")!=null;

  try {
  
    if (purge) {
      boolean confirmed = (request.getParameter("confirmed")!=null);
      if (confirmed) {
        int deleted = Page.purgeOrphans(application);
        message = "<b>"+deleted+"</b> orphaned pages purged.";
      } else {
        error = "You must check the box to confirm purging orphaned pages.";
      }
    }

  } catch (Exception ex) {

    error = ex.toString();

  }

  // load the orphaned pages for the display
  Page[] orphanedPages = Page.getOrphanPages(application);
%>
<%@ include file="/WEB-INF/include/errormessage.jhtml" %>

<h2>Orphaned Pages: <% if (orphanedPages.length==0) out.print("NONE"); %></h2>
<table>
  <% for (int i=0; i<orphanedPages.length; i++) { %>
    <tr>
      <td>[<%=orphanedPages[i].pid%>]</td>
      <td><%=orphanedPages[i].label%></td>
    </tr>
    <% } %>
</table>

<% if (orphanedPages.length>0) { %>
<p>
  <form method="post">
    <input type="checkbox" name="confirmed" value="true"/>
    <input type="submit" class="delete" name="purge" value="Purge Orphaned Pages"/>
  </form>
</p>
<% } %>


<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/footer.jhtml" %>
