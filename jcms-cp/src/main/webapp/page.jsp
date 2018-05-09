<%@ include file="/WEB-INF/include/init.inc" %>
<% pageTitle = "Page Editor"; pageHeading = "Page Editor | <a href=\"page-purge.jsp\">Orphaned Pages</a>"; %>
<% useZapatec=true; docUrl="doc-page.jsp"; %>
<%@ include file="/WEB-INF/include/header.jhtml" %>
<%@ include file="/WEB-INF/include/subheader.jhtml" %>
<%
  NumberFormat pf = NumberFormat.getPercentInstance();

  // get Page id
  int pid = Util.getInt(request, "pid");
  Page p = new Page(application, pid);

  // control variables
  boolean delete = request.getParameter("delete")!=null;
  boolean clone = request.getParameter("clone")!=null;
  boolean createpage = request.getParameter("createpage")!=null;
  boolean updatemetadata = request.getParameter("updatemetadata")!=null;
  boolean clear = request.getParameter("clear")!=null;
  
  // page search string
  String pageterm = Util.getString(request, "pageterm");
  if (clear || pageterm==null) pageterm = "";
  
  try {
    
    if (createpage) {
      // create a new default page
      p = new Page();
      p.insert(request);
      pid = p.pid;
      message = "New default page created.";
    }

    if (clone) {
      int oldpid = p.pid;
      p = p.clone(application);
      pid = p.pid;
      message = "Page <b>"+p.pid+"</b> created by cloning page <b>"+oldpid+"</b>.";
    }
    
    if (delete) {
      boolean confirmed = request.getParameter("confirmed")!=null;
      if (confirmed) {
        p.delete(request);
        p = new Page();
        message = "Page <b>"+pid+"</b> deleted.";
        pid = 0;
      } else {
        error = "You must check the box to confirm deletion of this page.";
      }
    }

    if (updatemetadata) {
      p.metakeywords = request.getParameter("metakeywords");
      p.metadescription = request.getParameter("metadescription");
      p.othermeta = request.getParameter("othermeta");
      p.update(request);
      message = "Page <b>"+p.pid+"</b> META data updated.";
    }
    
  } catch (org.postgresql.util.PSQLException e) {
    error = e.getMessage();
  }
  
  // show page loading message if no update
  if (p.isDefault() && message==null) message = "Loading pages...";
%>
<%@ include file="/WEB-INF/include/errormessage.jhtml" %>
<%
  // load the pids for the selector
  Page[] pages;
  if (pageterm.length()==0) {
    pages = Page.getAll(application);
  } else {
    pages = Page.getMatching(application, pageterm);
  }
%>

<!-- top controls -->
<form action="page.jsp" method="post">
  <select name="pid" onChange="
    top.document.getElementById('error').innerHTML='';
    top.document.getElementById('message').innerHTML='&nbsp;';
    top.document.getElementById('metaeditor').src = 'page-meta.jsp?pid='+this.options[this.selectedIndex].value;
    top.document.getElementById('layouteditor').src = 'page-layout.jsp?pane=1&pid='+this.options[this.selectedIndex].value;
    top.document.getElementById('contenteditor').src = 'content.jsp';
    ">
    <option value="0">--- select page ---</option>
    <%
      for (int i=0; i<pages.length; i++) {
          String notation = "";
          if (pages[i].isOrphan(application)) {
            notation = "[orphan]";
          } else if (pages[i].pending(application)) {
            notation = "[pending]";
          } else if (pages[i].expired(application)) {
            notation = "[expired]";
          }
          String label = pages[i].label;
          if (label==null) label = "";
          if (label.length()>100) label = label.substring(0,100)+"...";
      %>
      <option <% if (p.equals(pages[i])) out.print("selected"); %>  value="<%=pages[i].pid%>"><%=label%> <%=pages[i].pid%> <%=notation%></option>
      <%
      }
      %>
  </select>
  <input type="text" size="16" name="pageterm" value="<%=pageterm%>"/>
  <input type="submit" class="update" size="16" value="Filter"/>
  <input type="submit" class="normal" name="clear" value="Clear"/>
  <input type="submit" class="insert" name="createpage" value="Create Page"/>
</form>

<iframe name="metaeditor" id="metaeditor" src="page-meta.jsp?pid=<%=p.pid%>"></iframe>
<br/>
<iframe name="layouteditor" id="layouteditor" src="page-layout.jsp?pid=<%=p.pid%>&pane=1"></iframe>

<%
  if (message!=null && message.substring(0,13).equals("Loading pages")) {
    message = "Loading pages...done.";
%>
<%@ include file="/WEB-INF/include/errormessage-js.jhtml" %>
<%
}
%>
  
<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/footer.jhtml" %>
