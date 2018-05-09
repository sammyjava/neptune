<%@ include file="/WEB-INF/include/init.inc" %>
<%
  pageTitle = "Content Editor"; pageHeading = "Content Editor | <a href=\"uploadlist.jsp\">Uploaded Files</a> | <a href=\"content-purge.jsp\">Orphaned Content</a>";
  docUrl="doc-content.jsp";
%>
<%@ include file="/WEB-INF/include/header.jhtml" %>
<%@ include file="/WEB-INF/include/subheader.jhtml" %>
<%
  NumberFormat pf = NumberFormat.getPercentInstance();
  
  Content content = new Content(application, Util.getInt(request,"cid"));

  // cache permission in a boolean var
  boolean userCanEdit = cpuser.hasPermission(application, content);

  boolean insert = request.getParameter("insert")!=null;
  boolean delete = request.getParameter("delete")!=null;
  boolean clone = request.getParameter("clone")!=null;

  try {
  
    if (insert) {
      content = new Content();
      content.insert(request);
      message = "New content item <b>"+content.cid+"</b> created.";
    }
    
    if (clone) {
      int oldcid = content.cid;
      content = content.clone(application);
      message = "New content item <b>["+content.cid+"]</b> created by cloning content item <b>["+oldcid+"[</b>.";
    }
    
    if (delete && userCanEdit) {
      boolean confirmed = (request.getParameter("confirmed")!=null);
      if (confirmed) {
        int oldcid = content.cid;
        try {
          content.delete(request);
          message = "Content item <b>"+oldcid+"</b> deleted.";
        } catch (Exception ex) {
          if (ex.getMessage().contains("pages_content_cid_fkey")) {
            error = "You may not delete this content item - it is in use on a page.  Remove this content item from that page first.";
          } else {
            error = ex.getMessage();
          }
        }
      } else {
        error = "You must check the box to confirm deletion of content item <b>"+content.cid+"</b>.  Please try again.";
      }
    }

  } catch (Exception ex) {

    error = ex.toString();

  }

  String contentterm = request.getParameter("contentterm");
  if (contentterm==null || request.getParameter("clear")!=null) contentterm = "";

  // show loading status if initial page load
  if (message==null) message = "Loading content...";
%>
<%@ include file="/WEB-INF/include/errormessage.jhtml" %>
<%
  // load the content for the selector
  Content[] allContent;
  if (contentterm==null || contentterm.trim().length()==0) {
    allContent = Content.getAllMetadata(application);
  } else {
    allContent = Content.getMatchingMetadata(application, contentterm);
  }
%>
<form action="contenteditor.jsp" method="post">
  <select name="cid"
    onChange="
    top.document.getElementById('error').innerHTML='';
    top.document.getElementById('message').innerHTML='&nbsp;';
    top.document.getElementById('contenteditor').src='content.jsp?cid='+this.options[this.selectedIndex].value;
    ">
    <option value="0">--- select content ---</option>
    <%
      for (int j=0; j<allContent.length; j++) {
          String label = allContent[j].label;
          if (label==null) label = "";
          if (label.length()>100) label = label.substring(0,100)+"...";
      %>
      <option <% if (content.equals(allContent[j])) out.print("selected"); %> value="<%=allContent[j].cid%>">[<%=allContent[j].cid%>] <%=label%> <% if (allContent[j].isOrphan(application)) { %>[orphan]<% } %></option>
      <%
      }
      %>
  </select>
  <input name="contentterm" size="16" value="<%=contentterm%>"/>
  <input type="submit" class="update" value="Filter"/>
  <input type="submit" class="normal" name="clear" value="Clear"/>
  <input type="submit" class="insert" name="insert" value="Create"/>
  <input type="submit" class="clone" name="clone" value="Clone"/>
  <input type="checkbox" name="confirmed" value="true"/>
  <input type="submit" class="delete" name="delete" value="Delete Content"/>
</form>

<!-- the all-important content editor iframe! -->
<iframe name="contenteditor" id="contenteditor" src="content.jsp?cid=<%=content.cid%>"></iframe>

<%
  if (message!=null && message.substring(0,15).equals("Loading content")) {
    message = "Loading content...done.";
%>
<%@ include file="/WEB-INF/include/errormessage-js.jhtml" %>
<%
}
%>

<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/footer.jhtml" %>
