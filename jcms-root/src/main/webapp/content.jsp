<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="net.ims.jcms.*,java.sql.Timestamp,java.text.SimpleDateFormat,java.util.TimeZone" %>
<%
  String designFolder = Setting.getString(application, "site_designfolder");
  String cssFolder = Setting.getString(application, "site_cssfolder");
  AccessUser au = Util.getDefaultAccessUser(application); // default user (public)
  if (session.getAttribute("AccessUser")!=null) au = (AccessUser)session.getAttribute("AccessUser");
  Content content = new Content(application, Util.getInt(request, "cid"));
%>
<!DOCTYPE HTML>
<html>
  <head>
    <!--stopindex-->
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=8" />
    <meta name="generator" content="<%=Util.APPVERSION%>" />
    <link rel="shortcut icon" href="<%=designFolder%>/favicon.ico" />
    <link rel="stylesheet" type="text/css" href="<%=cssFolder%>/root.css" />
    <!--startindex-->
  </head>
  <body class="content-only">
    <%
      if (!content.isDefault()) {
        if (content.copy!=null && !content.moduleabove) out.println(content.copy);
        if (content.modulecontext!=null && content.moduleurl!=null) {
    %>
    <c:import context="<%=content.modulecontext%>" url="<%=content.moduleurl%>">
      <c:param name="cid" value="<%=Integer.toString(content.cid)%>"/>
      <c:param name="accessuser" value="<%=au.getUsername()%>"/>
      <%@ include file="/WEB-INF/custom/params.jhtml" %>
    </c:import>
    <%
        }
        if (content.copy!=null && content.moduleabove) out.println(content.copy);
      }
    %>
  </body>
</html>
