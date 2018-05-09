<%@ include file="/WEB-INF/include/init.inc" %>
<% pageTitle = "Layouts"; useZapatec=true; docUrl="doc-layout.jsp"; %>
<%@ include file="/WEB-INF/include/header.jhtml" %>
<%@ include file="/WEB-INF/include/subheader.jhtml" %>
<script type="text/javascript">
    function openDiagramWindow(layout_id, mobile, num, title) {
      // create the diagram window, Zapatec
      var swin = new Zapatec.Window({
        theme: 'plain',
        showMaxButton: false,
        showMinButton: false
      });
      swin.setPosition(325, 0);
      swin.setSize(640, 480);
      swin.create();
      // load layout-specific data
      var wintitle = 'Layout '+num+': '+title;
      if (mobile) wintitle += ' [MOBILE VERSION]'; else wintitle += ' [DESKTOP VERSION]';
      swin.setTitle(wintitle);
      swin.setContentUrl('layout-diagram.jsp?layout_id='+layout_id+'&mobile='+mobile);
      swin.show();
    }
</script>
<%
boolean showMobile = Setting.getBoolean(application,"mobile_enable");

// posted vars
int layout_id = Util.getInt(request, "layout_id");
int layoutpane_id = Util.getInt(request, "layoutpane_id");
boolean mobile = Util.getBoolean(request, "mobile");

// logic
boolean layoutinsert = (request.getParameter("layoutinsert")!=null);
boolean layoutupdate = (request.getParameter("layoutupdate")!=null);
boolean layoutdelete = (request.getParameter("layoutdelete")!=null);
boolean layoutclone = (request.getParameter("layoutclone")!=null);
  
boolean layoutpaneinsert = (request.getParameter("layoutpaneinsert")!=null);
boolean layoutpaneupdate = (request.getParameter("layoutpaneupdate")!=null);
boolean layoutpanedelete = (request.getParameter("layoutpanedelete")!=null);
  
try {
    
  if (layoutinsert) {
    Layout l = new Layout();
    l.layout = Util.getString(request, "layout");
    l.num = Util.getInt(request, "num");
    l.insert(request);
    // insert the stylesheet layout table classes
    Stylesheet.addLayout(application, l);
    message = "Layout <b>"+l.num+"</b> inserted along with corresponding stylesheet class. ";
  }

  if (layoutupdate) {
    Layout l = new Layout(application, layout_id);
    l.layout = Util.getString(request, "layout");
    l.update(request);
    message = "Layout <b>"+l.num+"</b> updated. ";
    // try inserting stylesheet classes, may be missing (shouldn't throw exception)
    Stylesheet.addLayout(application, l);
  }

  if (layoutclone) {
    Layout source = new Layout(application, layout_id);
    Layout l = source.clone(application);
    // insert a corresponding table class
    Stylesheet.addLayout(application, l);
    // insert the pane stylesheet classes
    LayoutPane[] panes = l.getLayoutPanes(application, false);
    for (int i=0; i<panes.length; i++) Stylesheet.addLayoutPane(application, panes[i]);
    message = "Layout <b>"+source.num+"</b> cloned to layout <b>"+l.num+"</b>. ";
  }

  if (layoutdelete) {
    if (Util.getBoolean(request,"confirmed")) {
      Layout l = new Layout(application, layout_id);
      // delete the corresponding stylesheet classes
      Stylesheet.removeLayout(application, l);
      // delete the layout
      int num = l.num;
      l.delete(request);
      message = "Layout <b>"+num+"</b> deleted, along with corresponding stylesheet classes. ";
    } else {
      error = "You must check the box to confirm layout deletion.";
    }
  }

  if (layoutpaneinsert) {
    LayoutPane lp = new LayoutPane();
    lp.layout_id = layout_id;
    lp.pane = Util.getInt(request, "pane");
    lp.vposition = Util.getInt(request, "vposition");
    lp.hposition = Util.getInt(request, "hposition");
    lp.colspan = Util.getInt(request, "colspan");
    lp.rowspan = Util.getInt(request, "rowspan");
    // default
    lp.mobile = false;
    lp.insert(request);
    // mobile
    lp.mobile = true;
    lp.insert(request);
    // add stylesheet classes
    Stylesheet.addLayoutPane(application, lp);
    message = "Layout Pane <b>"+lp.label+"</b> inserted along with corresponding stylesheet classes. ";
  }
      
  if (layoutpaneupdate) {
    LayoutPane lp = new LayoutPane(application, layoutpane_id);
    lp.vposition = Util.getInt(request, "vposition");
    lp.hposition = Util.getInt(request, "hposition");
    lp.colspan = Util.getInt(request, "colspan");
    lp.rowspan = Util.getInt(request, "rowspan");
    lp.update(request);
    message = "Layout Pane <b>"+lp.label+"</b> updated. ";
    if (mobile) message = "Mobile "+message;
    // try to add stylesheet classes
    Stylesheet.addLayoutPane(application, lp);
  }

  if (layoutpanedelete) {
    if (Util.getBoolean(request,"confirmed")) {
      LayoutPane lp = new LayoutPane(application, layoutpane_id);
      LayoutPane lpMobile = new LayoutPane(application, lp.layout_id, lp.pane, true);
      // remove the stylesheet classes
      Stylesheet.removeLayoutPane(application, lp);
      // delete the pane records
      int pane = lp.pane;
      lp.delete(request);
      lpMobile.delete(request);
      message = "Layout Pane <b>"+pane+"</b> deleted, along with corresponding stylesheet classes. ";
    } else {
      error = "You must check the box to confirm layout pane deletion.";
    }
  }
      
} catch (NumberFormatException e) {
  error = "A required number is missing.";
} catch (Exception e) {
  error = e.getMessage();
}
    
// get all the layouts to display in a table
Layout[] layouts = Layout.getAll(application);
%>
<%@ include file="/WEB-INF/include/errormessage.jhtml" %>
  
  <% if (showMobile) { %>
  <form method="post">
    <table style="background-color:#ddd; border:1px solid black;">
      <tr>
        <td><input type="radio" onClick="submit()" name="mobile" <% if (!mobile) out.print("checked"); %> value="false"/></td><td><b>Desktop</b></td>
        <td><input type="radio" onClick="submit()" name="mobile" <% if (mobile) out.print("checked"); %> value="true"/></td><td><b>Mobile</b></td>
      </tr>
    </table>
  </form>
  <% } %>
  
  <% for (int i=0; i<layouts.length; i++) { %>
    <table style="border-bottom:1px solid gray">
      <tr>
        <td width="450">
          <form method="post">
            <input type="hidden" name="mobile" value="<%=mobile%>"/>
            <input type="hidden" name="layout_id" value="<%=layouts[i].layout_id%>" />
            <table>
              <tr>
                <td valign="bottom" width="15"><b><%=layouts[i].num%></b></td>
                <td valign="bottom">
                  label (<a class="editpage" href="javascript:openDiagramWindow(<%=layouts[i].layout_id%>,<%=mobile%>,<%=layouts[i].num%>,'<%=layouts[i].layout%>')">view diagram</a>)<br/>
                  <input type="text" name="layout" size="32" value="<%=layouts[i].layout%>" />
                </td>
                <td nowrap valign="bottom">
                  <input type="submit" class="update" name="layoutupdate" value="Update" />
                  <% if (!mobile) { %>
                  <input type="submit" class="clone" name="layoutclone" value="Clone" />
                  <% if (layouts[i].num!=1) { %>
                  <input type="checkbox" name="confirmed" value="true" />
                  <input type="submit" class="delete" name="layoutdelete" value="Delete" />
                  <% } } %>
                </td>
              </tr>
            </table>
          </form>
        </td>
        <td>
          <table class="tight">
            <tr>
              <td width="35" align="center">pane</td>
              <td width="40" align="center">class</td>
              <td width="35" align="center">vpos</td>
              <td width="35" align="center">hpos</td>
              <td width="50" align="center">colspan</td>
              <td width="50" align="center">rowspan</td>
            </tr>
          </table>
          <%
            LayoutPane[] layoutPanes = layouts[i].getLayoutPanes(application, mobile);
            for (int j=0; j<layoutPanes.length; j++) {
            %>
            <form method="post">
              <input type="hidden" name="mobile" value="<%=mobile%>"/>
              <input type="hidden" name="layoutpane_id" value="<%=layoutPanes[j].layoutpane_id%>" />
              <input type="hidden" name="layout_num" value="<%=layouts[i].num%>" />
              <table class="tight">
                <tr>
                  <td width="35" align="center"><%=layoutPanes[j].pane%></td>
                  <td width="40" align="center"><b><%=layoutPanes[j].label%></b></td>
                  <td width="35" align="center"><input type="text" name="vposition" size="1" value="<%=layoutPanes[j].vposition%>" /></td>
                  <td width="35" align="center"><input type="text" name="hposition" size="1" value="<%=layoutPanes[j].hposition%>" /></td>
                  <td width="50" align="center"><input type="text" name="colspan" size="1" value="<%=layoutPanes[j].colspan%>" /></td>
                  <td width="50" align="center"><input type="text" name="rowspan" size="1" value="<%=layoutPanes[j].rowspan%>" /></td>
                  <td nowrap>
                    <input type="submit" class="update" name="layoutpaneupdate" value="Update" />
                    <% if (!mobile && !(layouts[i].num==1 && layoutPanes[j].pane==1)) { %>
                    <input type="checkbox" name="confirmed" value="true" />
                    <input type="submit" class="delete" name="layoutpanedelete" value="Delete" />
                    <% } %>
                  </td>
                </tr>
              </table>
            </form>
            <%
            } // panes
            %>
            <% if (!mobile) { %>
            <form method="post">
              <input type="hidden" name="mobile" value="<%=mobile%>"/>
              <input type="hidden" name="layout_id" value="<%=layouts[i].layout_id%>" />
              <input type="hidden" name="layout_num" value="<%=layouts[i].num%>" />
              <table class="tight">
                <tr>
                  <td width="35" align="center"><input type="text" name="pane" size="1" /></td>
                  <td width="40" align="center"></td>
                  <td width="35" align="center"><input type="text" name="vposition" size="1" /></td>
                  <td width="35" align="center"><input type="text" name="hposition" size="1" /></td>
                  <td width="50" align="center"><input type="text" name="colspan" size="1" /></td>
                  <td width="50" align="center"><input type="text" name="rowspan" size="1" /></td>
                  <td><input type="submit" class="insert" name="layoutpaneinsert" value="Insert" />
                </tr>
              </table>
            </form>
            <% } %>
        </td>
      </tr>
    </table>

    <% } // layouts %>

    <% if (!mobile) { %>
    <form method="post">
      <input type="hidden" name="mobile" value="<%=mobile%>"/>
      <table>
        <tr>
          <td width="15" valign="bottom"><input type="text" name="num" size="1" /></td>
          <td valign="bottom">label<br/><input type="text" name="layout" size="32" /></td>
          <td valign="bottom"><input type="submit" class="insert" name="layoutinsert" value="Insert" /></td>
        </tr>
      </table>
    </form>
    <% } %>

<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/footer.jhtml" %>
