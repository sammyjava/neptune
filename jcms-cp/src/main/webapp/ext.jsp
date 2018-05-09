<%@ include file="/WEB-INF/include/init.inc" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
  Extension extension = null;
  try {
    // form the extension navigation
    int extid = Integer.parseInt(request.getParameter("extid"));
    extension = new Extension(application, extid);
    Extension[] secondary;
    if (extension.isPrimary()) {
      pageTitle = extension.name;
      secondary = Extension.getSecondary(application, extension.extid);
    } else {
      Extension parent = new Extension(application, extension.parent_extid);
      secondary = Extension.getSecondary(application, extension.parent_extid);
      pageTitle = "<a href=\"ext.jsp?extid="+parent.extid+"\">"+parent.name+"</a>";
    }
    if (secondary.length>0) {
      for (int i=0; i<secondary.length; i++) {
          if (cpuser.hasPermission(application, secondary[i])) {
            if (extension.extid==secondary[i].extid) {
              pageTitle += " | "+secondary[i].name;
            } else {
              pageTitle += " | <a href=\"ext.jsp?extid="+secondary[i].extid+"\">"+secondary[i].name+"</a>";
            }
          }
      }
    }
  } catch (NumberFormatException ex) {
    error = "No extension was specified.";
  }
%>
<%@ include file="/WEB-INF/include/header.jhtml" %>
<%@ include file="/WEB-INF/include/subheader.jhtml" %>
  <% if (error!=null) out.print(error); %>
  <% if (cpuser.hasPermission(application, extension)) { %>
  <c:import context="<%=extension.cpcontext%>" url="<%=extension.cpurl%>">
    <c:param name="username" value="<%=cpuser.username%>" />
  </c:import>
  <% } else { %>
  <p>
    You do not have permission to use the <b><%=extension.name%></b> tool.  Please select a tool from the extension navigation above.
  </p>
  <% } %>
<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/footer.jhtml" %>
