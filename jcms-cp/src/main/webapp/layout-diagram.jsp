<%@ include file="/WEB-INF/include/init.inc" %>
<%
  int layout_id = Util.getInt(request, "layout_id");
  boolean mobile = Util.getBoolean(request, "mobile");
%>
<table class="layout" width="100%" height="100%">
  <tr>
    <%
      // get layout panes for this layout; can't assume that page has content associated with it
      Layout layout = new Layout(application, layout_id);
      LayoutPane[] panes = layout.getLayoutPanes(application, mobile);
      // iterate over the panes
      int vposition = 1;
      int hposition = 1;
      for (int i=0; i<panes.length; i++) {
          if (panes[i].vposition!=vposition) {
            vposition = panes[i].vposition;
            out.println("  </tr>");
        out.println("  <tr>");
        }
    %>
    <td class="layout" colspan="<%=panes[i].colspan%>" rowspan="<%=panes[i].rowspan%>" align="center" valign="center">
      <div class="layout">
        <%=panes[i].pane%>
      </div>
    </td>
    <%
    }
    %>
  </tr>
</table>
<%@ include file="/WEB-INF/include/close.inc" %>
