<%@ include file="/WEB-INF/include/init.inc" %>
<% int extra_id=0; useZapatec=false; pageTitle="LDAP Users"; %>
<%@ include file="/WEB-INF/include/header.jhtml" %>
<%@ include file="/WEB-INF/include/extra.inc" %>
<%@ include file="/WEB-INF/include/subheader.jhtml" %>
<%@ include file="/WEB-INF/include/errormessage.jhtml" %>
<%
  AccessUser[] users = Util.getAllAccessUsers(application);
  for (int i=0; i<users.length; i++) {
    out.print("<b>"+users[i].getUsername()+"</b>");
    AccessRole[] roles = users[i].getAccessRoles(application);
    for (int j=0; j<roles.length; j++) {
      out.print(" | "+roles[j].getRolename());
    }
    out.println("<br/>");
  }
%>
<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/footer.jhtml" %>
