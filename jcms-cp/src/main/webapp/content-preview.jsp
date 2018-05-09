<%@ include file="/WEB-INF/include/init.inc" %>
<% pageTitle = "Content Preview"; %>
<%@ include file="/WEB-INF/include/previewheader.jhtml" %>
<%
  // get the requested content record
  int cid = Integer.parseInt(request.getParameter("cid"));
  Content content = new Content(application, cid);

  // get the layout, pane and associated div class
  int layout_id = Integer.parseInt(request.getParameter("layout_id"));
  int pane = Integer.parseInt(request.getParameter("pane"));
  String layoutClass = "l"+layout_id;
  String paneClass = "l"+layout_id+"_p"+pane;
%>

<% if (content.moduleurl!=null && content.moduleabove) { %>
<div align="center"><b><%=content.modulecontext%><%=content.moduleurl%></b></div>
<hr/>
<% } %>

<table id="main" cellspacing="0">
  <tr>
    <td id="main-right" valign="top">
      <table id="<%=layoutClass%>" cellspacing="0">
        <tr>
          <td id="<%=paneClass%>"><%=Util.blankIfNull(content.copy)%></td>
        </tr>
      </table>
    </td>
  </tr>
</table>

<% if (content.moduleurl!=null && !content.moduleabove) { %>
<hr/>
<div align="center"><b><%=content.modulecontext%><%=content.moduleurl%></b></div>
<% } %>

<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/plainfooter.jhtml" %>

