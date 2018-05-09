<%@ include file="/WEB-INF/include/init.inc" %>
<% pageTitle = "Page Layout Editor and Content Selector"; useZapatec=false; %>
<%@ include file="/WEB-INF/include/plainheader.jhtml" %>
<%
  int pid = Util.getInt(request, "pid");
  int cid = Util.getInt(request, "cid");
  int pane = Util.getInt(request, "pane");

  Page p = new Page(application, pid);

  boolean userCanEdit = cpuser.hasPermission(application, p);  // can't edit the content if you can't edit the page

  boolean selectlayout = request.getParameter("selectlayout")!=null;

  if (selectlayout) {
    p.layout_id = Integer.parseInt(request.getParameter("layout_id"));
    p.update(request);
    message = "Page <b>"+p.pid+"</b> set to use layout <b>"+p.layout_id+"</b>.";
    error = "  ";
  }

  // get available Layouts
  Layout[] layouts = Layout.getAll(application);

  // get the current page layout
  Layout layout = p.getLayout(application);

  boolean selectpane = Util.getBoolean(request, "selectpane");

  boolean selectcontent = Util.getBoolean(request, "selectcontent");
  boolean insertcontent = (request.getParameter("insertcontent")!=null);
  boolean deletecontent = (request.getParameter("deletecontent")!=null);
  boolean clonecontent = (request.getParameter("clonecontent")!=null);

  boolean clearcontentfilter =  (request.getParameter("clearcontentfilter")!=null);

  // content search string
  String contentterm = Util.getString(request, "contentterm");
  if (clearcontentfilter || contentterm==null) contentterm = "";

  if (selectpane) {
    Content c = p.getContent(application, pane);
    cid = c.cid;
  }

  if (selectcontent) {
    if (cid==0 && pane!=0) {
      // remove content
      p.removeContent(application, pane);
      message = "Content removed from pane "+pane+".";
      error = "  ";
    } else if (cid!=0 && pane!=0) {
      // check that user has permission to edit this content
      Content c = new Content(application, cid);
      if (cpuser.hasPermission(application, c)) {
        p.setContent(application, pane, cid);
        message = "Pane <b>"+pane+"</b> updated to hold content <b>["+cid+"] "+c.label+"</b>.";
        error = "  ";
      } else {
        cid = 0;
        error = "You do not have permission to use the content item <b>["+c.cid+"] "+c.label+"</b>.";
      }
    }
  }

  if (insertcontent) {
    Content c = new Content();
    c.insert(request);
    p.setContent(application, pane, c.cid);
    message = "Pane <b>"+pane+"</b> updated to hold new content <b>"+c.cid+"</b>.";
    error = "  ";
    cid = c.cid;
  }

  if (clonecontent) {
    Content c = new Content(application, cid);
    c = c.clone(application);
    p.setContent(application, pane, c.cid);
    message = "Pane <b>"+pane+"</b> updated to hold new cloned content <b>"+c.cid+"</b>.";
    error = "  ";
    cid = c.cid;
  }

  if (deletecontent) {
    if (request.getParameter("confirmed")!=null) {
      p.removeContent(application, pane);
      Content c = new Content(application, cid);
      if (c.isOrphan(application)) {
        String cText = "["+c.cid+"] "+c.label;
        c.delete(request);
        message = "Content <b>"+cText+"</b> has been deleted.";
        error = "  ";
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
<%@ include file="/WEB-INF/include/errormessage-js.jhtml" %>
<%
  if (!p.isDefault()) {
    
    // get layout panes for this layout; can't assume that page has content associated with it
    LayoutPane[] panes = layout.getLayoutPanes(application, false);

    // get the content for this page (includes content not in current layout)
    Content[] pageContent = p.getContent(application);
%>

<!-- layout selection -->
<div style="float:left; padding:0 10px 0 0;">
  <% if (userCanEdit) { %>
  Page Layout<br/>
  <form action="page-layout.jsp" method="post">
    <input type="hidden" name="pid" value="<%=p.pid%>"/>
    <input type="hidden" name="pane" value="1"/>
    <input type="hidden" name="selectlayout" value="true"/>
<!--    <select name="layout_id" onChange="top.document.getElementById('contenteditor').src='content.jsp'; submit();"> -->
    <select name="layout_id" onChange="submit();">
        <% for (int i=0; i<layouts.length; i++) { %>
          <option <% if (p.layout_id==layouts[i].layout_id) out.print("selected"); %> value="<%=layouts[i].layout_id%>"><%=layouts[i].label%> <%=layouts[i].layout%></option>
        <% } %>
    </select>
  </form>
  <% } else { %>
  <!-- non-editable layout display -->
  <b>Page Layout</b><br/>
    <% for (int i=0; i<layouts.length; i++) if (p.layout_id==layouts[i].layout_id) out.print(layouts[i].layout); %>
    <% } // userCanEdit %>
</div>

<!-- pane selection -->
Content: <% for (int i=0; i<pageContent.length; i++) out.print("["+pageContent[i].cid+"] "); %>
  <form action="page-layout.jsp" method="post">
    <input type="hidden" name="pid" value="<%=pid%>"/>
    <input type="hidden" name="selectpane" value="true"/>
    <table class="layout" cellspacing="0">
      <tr>
        <%
          // iterate over the panes
          int vposition = 1;
          int hposition = 1;
          for (int i=0; i<panes.length; i++) {
              if (panes[i].vposition!=vposition) {
                vposition = panes[i].vposition;
                out.println("  </tr>");
            out.println("  <tr>");
            }
            Content content = p.getContent(application, panes[i].pane);
            if (cid==0 && pane==1 && panes[i].pane==1) cid = content.cid;
        %>
        <td class="layout" colspan="<%=panes[i].colspan%>" rowspan="<%=panes[i].rowspan%>" align="center" valign="center">
          <div class="layout">
            <input type="radio" name="pane" <% if (panes[i].pane==pane) out.print("checked"); %> value="<%=panes[i].pane%>"
              onClick="
              top.document.getElementById('message').innerHTML='Pane <b><%=panes[i].pane%></b> selected.';
              top.document.getElementById('error').innerHTML='';
              document.getElementById('panelabel').innerHTML='Pane <%=panes[i].pane%>';
              submit();
              " />
              <%=panes[i].pane%>
          </div>
          <% if (!content.isDefault()) { %><span class="audit">[<%=content.cid%>]</span><% } %>
        </td>
        <%
        } // panes
        %>
      </tr>
    </table>
  </form>
    
  <div id="panelabel" class="audit">
    <% if (pane==0) out.print("Select a content pane above"); else out.print("Pane <b>"+pane+"</b>"); %>
  </div>

  <% if (userCanEdit) { %>
    
  <!-- content selection -->
  <form action="page-layout.jsp" method="post">
    <input type="hidden" name="pid" value="<%=pid%>"/>
    <input type="hidden" name="pane" value="<%=pane%>"/>
    <input type="hidden" name="selectcontent" value="true"/>
<!--    <select id="cidselector" name="cid" onChange="top.document.getElementById('contenteditor').src='content.jsp?cid='+this.options[this.selectedIndex].value; submit();">"> -->
    <select id="cidselector" name="cid" onChange="submit();">">
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
    <input type="text" name="contentterm" size="16" value="<%=contentterm%>"/>
    <input type="submit" class="update" value="Filter"/>
    <input type="submit" class="normal" name="clearcontentfilter" value="Clear"/>
    <input type="submit" class="insert" name="insertcontent" value="Create Content"/>
    <!--    <input type="submit" class="clone" name="clonecontent" value="Clone"/> -->
    <input type="checkbox" name="confirmed" value="true"/>
    <input type="submit" class="delete" name="deletecontent" value="Delete Content"/>
  </form>
  
  <% } // user can edit %>

  <!-- the all-important content editor iframe! -->
  <iframe name="contenteditor" id="contenteditor" src="content.jsp?cid=<%=cid%>"></iframe>

  <% } // page is not default %>

<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/plainfooter.jhtml" %>
