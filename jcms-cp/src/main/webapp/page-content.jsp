<%@ include file="/WEB-INF/include/init.inc" %>
<% pageTitle = "Content Selector"; useZapatec=false; %>
<%@ include file="/WEB-INF/include/plainheader.jhtml" %>
<%
  int pid = Util.getInt(request, "pid");
  int pane = Util.getInt(request, "pane");
  int cid = Util.getInt(request, "cid");

  boolean selectcontent = request.getParameter("selectcontent")!=null;
  boolean insertcontent = request.getParameter("insertcontent")!=null;
  boolean deletecontent = request.getParameter("deletecontent")!=null;
  boolean clonecontent = request.getParameter("clonecontent")!=null;
  boolean clearcontentfilter =  request.getParameter("clearcontentfilter")!=null;

  // content search string
  String contentterm = Util.getString(request, "contentterm");
  if (clearcontentfilter || contentterm==null) contentterm = "";

  if (selectcontent) {
    if (cid==0 && pane!=0) {
      // remove content
      Page p = new Page(application, pid);
      p.removeContent(application, pane);
      message = "Content removed from pane "+pane+".";
    } else if (cid!=0 && pane!=0) {
      // check that user has permission to edit this content
      Content c = new Content(application, cid);
      if (cpuser.hasPermission(application, c)) {
        Page p = new Page(application, pid);
        p.setContent(application, pane, cid);
        message = "Pane <b>"+pane+"</b> updated to hold content <b>["+cid+"] "+c.label+"</b>.";
      } else {
        cid = 0;
        error = "You do not have permission to use the content item <b>["+c.cid+"] "+c.label+"</b>.";
      }
    }
  }

  if (insertcontent) {
    Content c = new Content();
    c.insert(request);
    Page p = new Page(application, pid);
    p.setContent(application, pane, c.cid);
    message = "Pane <b>"+pane+"</b> updated to hold new content <b>"+c.cid+"</b>.";
    cid = c.cid;
  }

  if (clonecontent) {
    Content c = new Content(application, cid);
    c = c.clone(application);
    Page p = new Page(application, pid);
    p.setContent(application, pane, c.cid);
    message = "Pane <b>"+pane+"</b> updated to hold new cloned content <b>"+c.cid+"</b>.";
    cid = c.cid;
  }

  if (deletecontent) {
    if (request.getParameter("confirmed")!=null) {
      Page p = new Page(application, pid);
      p.removeContent(application, pane);
      Content c = new Content(application, cid);
      if (c.isOrphan(application)) {
        String cText = "["+c.cid+"] "+c.label;
        c.delete(request);
        message = "Content <b>"+cText+"</b> has been deleted.";
        cid = 0;
      } else {
        Page[] pages = c.getPages(application);
        error = "Cannot delete content <b>["+c.cid+"] "+c.label+"</b> because it is currently in use on pages: <b>";
          for (int i=0; i<pages.length; i++) error += pages[i].pid+" ";
            error += "</b>";
        p.setContent(application, pane, cid);
      }
    } else {
      error = "You must check the box to confirm content deletion.";
    }
  }


  // get the content for populating select menus below
  Content[] allContent;
  if (contentterm.trim().length()==0) {
    allContent = Content.getAllMetadata(application);
  } else {
    allContent = Content.getMatchingMetadata(application, contentterm);
  }
%>

<% if (pid!=0 && pane!=0) { %>

<div class="audit">
  Pane <b><%=pane%></b>
  <hr/>
</div>

<form action="page-content.jsp" method="post">
  <input type="hidden" name="pid" value="<%=pid%>"/>
  <input type="hidden" name="pane" value="<%=pane%>"/>
  <select name="cid" onChange="top.document.getElementById('contenteditor').src='content.jsp?cid='+this.options[this.selectedIndex].value; submit();">">
    <option value="0">--- none ---</option>
    <%
      for (int j=0; j<allContent.length; j++) {
          String label = allContent[j].label;
          if (label==null) label = "";
          if (label.length()>100) label = label.substring(0,100)+"...";
          label += "["+allContent[j].cid+"] ";
          if (allContent[j].isOrphan(application)) label += "[orphan]";
      %>
      <option <% if (cid==allContent[j].cid) out.print("selected"); %> value="<%=allContent[j].cid%>"><%=label%></option>
      <%
      }
      %>
  </select>
  <input type="text" name="contentterm" size="10" value="<%=contentterm%>"/>
  <input type="submit" class="update" value="Filter"/>
  <input type="submit" class="normal" name="clearcontentfilter" value="Clear"/>
  <input type="submit" class="insert" name="insertcontent" value="Create Content"/>
</form>

<% } // pid and pane %>

<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/plainfooter.jhtml" %>

