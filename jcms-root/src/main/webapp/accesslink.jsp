<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="net.ims.jcms.*" %>
<%
  AccessUser au = Util.getDefaultAccessUser(application); // default user (public)
  String accessuser = request.getParameter("accessuser");
  if (accessuser!=null && accessuser.length()>0) au = au.getAccessUser(application, accessuser);

  // set style for a tag
  char location = request.getParameter("location").charAt(0);
  String aClass = UtilityContent.getLinkClass(location);
%>
<% if (au.isDefault()) { %>
<a class="<%=aClass%>" href="/access.jsp"><%=Setting.getString(application,"access_login_linktext")%></a>
<% } else { %>
<a class="<%=aClass%>" href="/access.jsp?access-logout"><%=Setting.getString(application,"access_logout_linktext")%></a>
<% } %>
