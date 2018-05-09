<%@ include file="/WEB-INF/include/init.inc" %>
<% pageTitle = "Audit Log"; docUrl="doc-audit.jsp"; %>
<%@ include file="/WEB-INF/include/header.jhtml" %>
<%@ include file="/WEB-INF/include/subheader.jhtml" %>
<%

  // format for audit timestamps
  java.text.SimpleDateFormat asdf = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

  // filters
  String tablename = request.getParameter("tablename");
  if (tablename!=null && tablename.length()==0) tablename = null;
  String username = request.getParameter("username");
  if (username!=null && username.length()==0) username = null;

  Audit[] audits = null;
  if (tablename!=null && username!=null) {
    audits = Audit.getAllByTableAndUsername(application, tablename, username);
  } else if (tablename!=null) {
    audits = Audit.getAllByTable(application, tablename);
  } else if (username!=null) {
    audits = Audit.getAllByUsername(application, username);
  }

  // paging
  int num = 25;
  int start = 0;
  int end = 0;
  if (audits!=null) {
    if (request.getParameter("start")!=null) start = Integer.parseInt(request.getParameter("start"));
    end = audits.length;
    if (end>start+num) end = start + num;
  }

%>
<%@ include file="/WEB-INF/include/errormessage.jhtml" %>

<table>
  <tr>
    <td>
      User<br/>
      <form action="audit.jsp" method="post">
        <% if (tablename!=null) { %><input type="hidden" name="tablename" value="<%=tablename%>"/><% } %>
        <select name="username" onChange="submit()">
          <option value="">--- all ---</option>
          <%
            String[] usernames = Audit.getUsernames(application);
            for (int i=0; i<usernames.length; i++) {
                boolean selected = (username!=null && username.equals(usernames[i]));
            %>
            <option <% if (selected) out.print("selected"); %> value="<%=usernames[i]%>"><%=usernames[i]%></option>
            <%
            }
            %>
        </select>
      </form>
    </td>
    <td>
      Table<br/>
      <form action="audit.jsp" method="post">
        <% if (username!=null) { %><input type="hidden" name="username" value="<%=username%>"/><% } %>
        <select name="tablename" onChange="submit()">
          <option value="">--- all ---</option>
          <%
            String[] tableNames = Audit.getTableNames(application);
            for (int i=0; i<tableNames.length; i++) {
                boolean selected = (tablename!=null && tablename.equals(tableNames[i]));
            %>
            <option <% if (selected) out.print("selected"); %> value="<%=tableNames[i]%>"><%=tableNames[i]%></option>
            <%
            }
            %>
        </select>
      </form>
    </td>
    <td width="100" valign="bottom" align="right">
      <% if (audits!=null && end<audits.length) { %>
        <form action="audit.jsp" method="post">
          <% if (username!=null) { %><input type="hidden" name="username" value="<%=username%>"/><% } %>
          <% if (tablename!=null) { %><input type="hidden" name="tablename" value="<%=tablename%>"/><% } %>
          <input type="hidden" name="start" value="<%=end%>"/>
          <input type="submit" class="next" value="&lt; Earlier"/>
        </form>
        <% } %> 
    </td>
    <td width="100" valign="bottom" align="left">
      <% if (start>0) { %>
      <form action="audit.jsp" method="post">
        <% if (username!=null) { %><input type="hidden" name="username" value="<%=username%>"/><% } %>
        <% if (tablename!=null) { %><input type="hidden" name="tablename" value="<%=tablename%>"/><% } %>
        <input type="hidden" name="start" value="<%=(start-num)%>"/>
        <input type="submit" class="prev" value="Later &gt;"/>
      </form>
      <% } %>
    </td>
  </tr>
</table>
  
<%
  if (audits!=null) {
%>

<table class="auditlog">
  <tr>
    <td class="auditlog"><b>time</b></td>
    <td class="auditlog"><b>user</b></td>
    <td class="auditlog"><b>table</b></td>
    <td class="auditlog"><b>id</b></td>
    <td class="auditlog"><b>action</b></td>
    <td class="auditlog"><b>description</b></td>
  </tr>
  <% for (int i=start; i<end; i++) { %>
    <tr>
      <td class="auditlog" align="right"><%=asdf.format(audits[i].timestamp)%></td>
      <td class="auditlog"><%=audits[i].username%></td>
      <td class="auditlog"><%=audits[i].tablename%></td>
      <td class="auditlog" align="right"><%=audits[i].record_id%></td>
      <td class="auditlog" align="center"><%=audits[i].action%></td>
      <td class="auditlog"><%=audits[i].description%></td>
    </tr>
    <% } %>
</table>

<%
}
%>
    
<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/footer.jhtml" %>

