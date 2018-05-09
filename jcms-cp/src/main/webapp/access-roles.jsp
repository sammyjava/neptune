<%@ include file="/WEB-INF/include/init.inc" %>
<% int extra_id=9; useZapatec=false; %>
<%@ include file="/WEB-INF/include/extra.inc" %>
<%@ include file="/WEB-INF/include/header.jhtml" %>
<%@ include file="/WEB-INF/include/subheader.jhtml" %>
<%

  // logic vars
  boolean insertrole = request.getParameter("insertrole")!=null;
  boolean updaterole = request.getParameter("updaterole")!=null;
  boolean deleterole = request.getParameter("deleterole")!=null;
  
  try {

    // instantiate requested role
    JcmsAccessRole r = new JcmsAccessRole();
    if (request.getParameter("accessrole_id")!=null) r = new JcmsAccessRole(application, Integer.parseInt(request.getParameter("accessrole_id")));

    if (insertrole) {
      if (request.getParameter("accessrole")!=null && request.getParameter("accessrole").length()>0) {
        r.accessrole = request.getParameter("accessrole");
        r.insert(request);
        message = "New access role <b>"+r.accessrole+"</b> created.";
      } else {
        error = "You must supply a name for the new role.";
      }
    }

    if (updaterole) {
      if (request.getParameter("accessrole")!=null && request.getParameter("accessrole").length()>0) {
        String accessroleOld = r.accessrole;
        r.accessrole = request.getParameter("accessrole");
        r.update(request);
        message = "Access role <b>"+accessroleOld+"</b> renamed to <b>"+r.accessrole+"</b>.";
      } else {
        error = "You must supply a name for the role.";
      }
    }

    if (deleterole) {
      if (request.getParameter("confirmed")==null) {
        error  = "You much check the box to confirm deletion of a role (this is permanent).";
      } else {
        message = "Access role <b>"+r.accessrole+"</b> deleted.";
        r.delete(request);
      }
    }

  } catch (Exception e) {

    error = e.getMessage();

  }   

  // load the roles for display (if any)
  JcmsAccessRole[] roles = JcmsAccessRole.getAllJcmsAccessRoles(application);
%>
<%@ include file="/WEB-INF/include/errormessage.jhtml" %>

<% for (int i=0; i<roles.length; i++) { %>
  <form action="access-roles.jsp" method="post">
    <input type="hidden" name="accessrole_id" value="<%=roles[i].accessrole_id%>"/>
    <table>
      <tr>
        <td><input type="text" name="accessrole" value="<%=roles[i].accessrole%>" size="32" /></td>
        <td>
          <input type="submit" class="update" name="updaterole" value="Change Role Name" />
          <input type="checkbox" name="confirmed" value="true" />
          <input type="submit" class="delete" name="deleterole" value="Delete Role" />
        </td>
      </tr>
    </table>
  </form>
<% } %>
  <form action="access-roles.jsp" method="post">
    <table>
      <tr>
        <td><input type="text" name="accessrole" size="32" /></td>
        <td><input type="submit" class="insert" name="insertrole" value="Add New Role" /></td>
      </tr>
    </table>
  </form>

<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/footer.jhtml" %>

