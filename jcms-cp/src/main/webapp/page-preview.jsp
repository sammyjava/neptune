<%@ include file="/WEB-INF/include/init.inc" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
  // get Page
  int pid = 0;
  if (request.getParameter("pid")!=null && request.getParameter("pid").length()>0) {
    pid = Integer.parseInt(request.getParameter("pid"));
  }
  Page p = new Page(application, pid);
  
  // get Layout and panes
  Layout layout = p.getLayout(application);
  LayoutPane[] panes = layout.getLayoutPanes(application, false);

  boolean showPageTitle = true;
%>
<html>
  <head>
    <title>Page <%=pid%> Preview</title>
    <meta http-equiv="content-type" content="text/html;charset=UTF-8" />
    <link rel="stylesheet" type="text/css" href="<%=cssFolder%>/root.css" />
    <script src="swfobject.js" type="text/javascript"></script>
  </head>
  <body>
    <div id="container">
      <!-- main region -->
      <table id="main" cellspacing="0">
        <tr>
          <td id="main-right" valign="top">
            <!-- content panes -->
              <% if (showPageTitle && p.title!=null) { %>
            <div id="pagetitle"><%=p.title%></div>
            <% } %>
            <table id="<%=layout.label%>" cellspacing="0" width="100%">
              <tr>
                <%
                  // loop over the panes
                  int vposition = 1;
                  int hposition = 1;
                  for (int i=0; i<panes.length; i++) {
                      // get the content for this pane, if it exists
                      Content content = p.getContent(application, panes[i].pane);
                      if (panes[i].vposition!=vposition) {
                        vposition = panes[i].vposition;
                        out.println("  </tr>");
                    out.println("  <tr>");
                    }
                %>
                <td valign="top" id="<%=panes[i].label%>" colspan="<%=panes[i].colspan%>" rowspan="<%=panes[i].rowspan%>">
                    <% if (content!=null && content.copy!=null && !content.moduleabove) out.println(content.copy); %>
                    <% if (content!=null && content.moduleurl!=null) { %>
                  <c:import context="<%=content.modulecontext%>" url="<%=content.moduleurl%>">
                    <c:param name="pid" value="<%=Integer.toString(p.pid)%>"/>
                    <c:param name="layoutpane_id" value="<%=Integer.toString(panes[i].layoutpane_id)%>"/>
                    <c:param name="cid" value="<%=Integer.toString(content.cid)%>"/>
                  </c:import>
                  <% } %>
                    <% if (content!=null && content.copy!=null && content.moduleabove) out.println(content.copy); %>
                </td>
                <%
                } // end pane loop
                %>
              </tr>
            </table>
          </td>
        </tr>
      </table>
    </div>
  </body>
</html>
<%@ include file="/WEB-INF/include/close.inc" %>
