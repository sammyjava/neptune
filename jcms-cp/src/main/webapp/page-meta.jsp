<%@ include file="/WEB-INF/include/init.inc" %>
<% pageTitle = "Page Metadata Editor"; useZapatec=false; %>
<%@ include file="/WEB-INF/include/plainheader.jhtml" %>
<%
  int pid = Util.getInt(request, "pid");
  Page p = new Page(application, pid);
  
  boolean update = request.getParameter("update")!=null;
  
  if (update) {
    p.label = request.getParameter("label");
    p.headtitle = request.getParameter("headtitle");
    p.title = request.getParameter("title");
    p.metakeywords = request.getParameter("metakeywords");
    p.metadescription = request.getParameter("metadescription");
    p.othermeta = request.getParameter("othermeta");
    p.update(request);
    p.setTags(application, request.getParameter("tags"));
    message = "Page <b>"+p.pid+"</b> label, titles and metadata updated.";
    error = "  ";
  }

  if (!p.isDefault() && message==null) {
    message = "Page <b>["+p.pid+"] "+p.label+"</b> selected.";
    error = "";
  }
%>
<%@ include file="/WEB-INF/include/errormessage-js.jhtml" %>
<%
  if (!p.isDefault()) {
    
  // get current and future nodes
  Node[] currentNodes = p.getCurrentNodes(application);
  Node[] futureNodes = p.getFutureNodes(application);
    
  // handle permission
  boolean userCanEdit = cpuser.hasPermission(application, p);
%>

    <!-- page info -->
    <div class="audit">
      <div style="float:right"><% if (p.updated!=null) { %>updated <%=sdf.format(p.updated)%><% } %> created <%=sdf.format(p.created)%></div>
      Page <b><%=p.pid%></b> <a class="preview" target="preview" href="page-preview.jsp?pid=<%=pid%>"><b>PREVIEW</b></a>
      <br/>
      Nodes (<span class="active">current</span> | <span class="future">future</span>):
      <% if (currentNodes.length==0 && futureNodes.length==0) { %>
      NONE
      <% } else { %>
      <% if (currentNodes.length>0) { for (int i=0; i<currentNodes.length; i++)  { %><span class="active" style="padding:0 3px 0 3px"><%=currentNodes[i].label%></span><% } } %>
      <% if (futureNodes.length>0) { out.print("|"); for (int i=0; i<futureNodes.length; i++) { %><span class="future" style="padding:0 3px 0 3px"><%=futureNodes[i].label%></span><% } } %>
      <% } %>
      <br/>
      <% if (p.isOrphan(application)) { %><b>ORPHAN</b><br/><% } else if (p.pending(application)) { %><b>PENDING</b><br/><% } else if (p.expired(application)) { %><b>EXPIRED</b><br/><% } %>
      <hr/>
    </div>
    
    <% if (userCanEdit) { %>

    <!-- page data editor -->
    <form action="page-meta.jsp" method="post">
      <input type="hidden" name="pid" value="<%=p.pid%>"/>
      <table cellspacing="0" width="100%">
        <tr>
          <td valign="top">
            Page Label (unique internal label)<br/>
            <input type="text" name="label" size="60" value="<%=Util.blankIfNull(p.label)%>"/><br/>
            Page Title (shown on page, if enabled)<br/>
            <textarea name="title" rows="1" cols="64"><%=Util.blankIfNull(p.title)%></textarea><br/>
            Browser Title Bar (shown at top of browser window)<br/>
            <textarea name="headtitle" rows="1" cols="64"><%=Util.blankIfNull(p.headtitle)%></textarea><br/>
            Related Page Tags (ex: brewing beer ale "pale ale")<br/>
            <textarea name="tags" rows="1" cols="64"><% for (int i=0; i<p.tags.length; i++) { String tag=p.tags[i]; if (tag.contains(" ")) tag = "\""+tag+"\""; out.print(tag+" "); } %></textarea>
          </td>
          <td valign="top">
            META Keywords<br/><textarea name="metakeywords" rows="1" cols="64"><%=Util.blankIfNull(p.metakeywords)%></textarea><br/>
            META/RSS Description (used by RSS feed and search indexing)<br/><textarea name="metadescription" rows="2" cols="64"><%=Util.blankIfNull(p.metadescription)%></textarea><br/>
            Other HEAD tags<br/><textarea name="othermeta" rows="2" cols="64"><%=Util.blankIfNull(p.othermeta)%></textarea>
          </td>
        </tr>
        <tr>
          <td colspan="2" align="center">
            <input type="submit" name="update" class="update" value="Update Page Info"/>
          </td>
        </tr>
      </table>
    </form>

<% if (!p.isDefault()) { %>
<!-- updates that require top reload -->
<div align="center">
  <form action="page.jsp" target="_top" method="post">
    <input type="hidden" name="pid" value="<%=p.pid%>"/>
    <input type="submit" name="clone" class="clone" value="Clone Page Info"/>
    <% if (p.expired(application) || p.isOrphan(application)) { %>
    <input class="checkbox" type="checkbox" name="confirmed" value="true"/>
    <input type="submit" name="delete" class="delete" value="Delete Page"/>
    <% } %>
  </form>
</div>
<% } %>
    
    <% } else { %>
    
    <!-- non-editable page data display -->
    <table width="250" cellspacing="0">
      <tr>
        <td>
          <b>Page Label</b><br/>
          <%=Util.blankIfNull(p.label)%>
        </td>
      </tr>
      <tr>
        <td>
          <b>Page Title</b><br/>
          <%=Util.blankIfNull(p.title)%>
        </td>
      </tr>
      <tr>
        <td>
          <b>Browser Title Bar</b><br/>
          <%=Util.blankIfNull(p.headtitle)%>
        </td>
      </tr>
      <tr>
        <td>
          <b>META Keywords</b><br/>
          <%=Util.blankIfNull(p.metakeywords)%>
        </td>
      </tr>
      <tr>
        <td>
          <b>META Description</b><br/>
          <%=Util.blankIfNull(p.metadescription)%>
        </td>
      </tr>
      <tr>
        <td>
          <b>Other HEAD tags</b><br/>
          <%=Util.blankIfNull(p.othermeta)%>
        </td>
      </tr>
    </table>
    
    <% } // userCanEdit %>
    
    <% } // isDefault %>

<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/plainfooter.jhtml" %>
