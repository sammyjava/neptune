<%@ include file="/WEB-INF/include/init.inc" %>
<%
  pageTitle = "Content Editor";
  pageHeading = "<a href=\"contenteditor.jsp\">Content Editor</a> | <a href=\"uploadlist.jsp\">Uploaded Files</a> | Orphaned Content";
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
        int deleted = Content.purgeOrphans(application);
        message = "<b>"+deleted+"</b> orphaned content items purged.";
      } else {
        error = "You must check the box to confirm purging orphaned content.";
      }
    }

  } catch (Exception ex) {

    error = ex.toString();

  }

  // load the orphaned content for the display
  Content[] orphanedContent = Content.getOrphanedContent(application);
%>
<%@ include file="/WEB-INF/include/errormessage.jhtml" %>

<h2>Orphaned Content: <% if (orphanedContent.length==0) out.print("NONE"); %></h2>
<table>
  <% for (int i=0; i<orphanedContent.length; i++) { %>
    <tr>
      <td>[<%=orphanedContent[i].cid%>]</td>
      <td><%=orphanedContent[i].label%></td>
    </tr>
    <% } %>
</table>

<% if (orphanedContent.length>0) { %>
<p>
  <form method="post">
    <input type="checkbox" name="confirmed" value="true"/>
    <input type="submit" class="delete" name="purge" value="Purge Orphaned Content"/>
  </form>
</p>
<% } %>


<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/footer.jhtml" %>
