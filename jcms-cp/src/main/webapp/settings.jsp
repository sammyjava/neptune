<%@ include file="/WEB-INF/include/init.inc" %>
<% pageTitle = "Settings"; docUrl="doc-settings.jsp"; %>
<%@ include file="/WEB-INF/include/header.jhtml" %>
<%@ include file="/WEB-INF/include/subheader.jhtml" %>
<%
  int setting_id = 0;

  try {
    
    if (request.getParameter("update")!=null) {
      setting_id = Integer.parseInt(request.getParameter("setting_id"));
      Setting s = new Setting(application, setting_id);
      s.value = request.getParameter("setting_value");
      s.update(request);
      message = "Setting <b>"+s.name+"</b> updated.";
    }

  } catch (Exception ex) {
    error = ex.getMessage();
  }

  // load array for output
  Setting[] s = Setting.getAll(application);
%>
<%@ include file="/WEB-INF/include/errormessage.jhtml" %>

<% for (int i=0; i<s.length; i++) { %>
  <a name="<%=s[i].id%>"></a>
  <form action="#<%=s[i].id%>" method="post">
    <input type="hidden" name="setting_id" value="<%=s[i].id%>"/>
    <% if (setting_id==s[i].id) { %><table class="updated"><% } else { %><table><% } %>
        <tr>
          <td width="220" class="setting"><%=s[i].name%></td>
          <td width="450">
            <% if (s[i].isPassword()) { %>
            <input type="password" name="setting_value" value="<%=s[i].value%>"/>
            <% } else if (s[i].isToggle()) { %>
            <input type="checkbox" name="setting_value" <% if (s[i].isOn()) out.print("checked"); %> value="true"/>
              <% } else { %>
              <textarea name="setting_value" rows="1" cols="80"><%=s[i].value%></textarea>
              <% } %>
          </td>
          <td><input type="submit" name="update" class="update" value="Update"/></td>
          <td><%=s[i].description%></td>
          <% if (setting_id==s[i].id) { %><td class="message">UPDATED</td><% } %>
        </tr>
      </table>
  </form>
<% } %>

<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/footer.jhtml" %>
