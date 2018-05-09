<%@ include file="/WEB-INF/include/init.inc" %>
<%        
  // get the requested Media
  int mid = Integer.parseInt(request.getParameter("mid"));
  Media m = new Media(application, mid);
  
  // get default access role
  AccessRole defaultRole = Util.getDefaultAccessRole(application);

  // load the access roles
  AccessRole[] roles = defaultRole.getAll(application);
%>
<div align="center">
  
  <h3><%=m.filename%></h3>

  <form action="media.jsp" method="post">
    <input type="hidden" name="mid" value="<%=mid%>" />
    <table>
      <tr>
        <td colspan="2" align="center"><b>Access Roles</b></td>
      </tr>
        <% for (int i=0; i<roles.length; i++) { %>
        <tr>
          <td align="center"><input type="checkbox" name="accessrole" <% if (!defaultRole.mayAccess(application,m) && roles[i].mayAccess(application,m)) out.print("checked"); %> value="<%=roles[i].getRolename()%>" /></td>
          <td><%=roles[i].getRolename()%></td>
        </tr>
        <% } %>
        <tr>
          <td colspan="2" align="center"><input type="submit" class="update" name="accessupdate" value="Update" /></td>
        </tr>
    </table>
  </form>

</div>
<%@ include file="/WEB-INF/include/close.inc" %>
