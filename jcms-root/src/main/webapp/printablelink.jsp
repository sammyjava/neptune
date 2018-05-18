<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="net.ims.jcms.*" %>
<%
String url = pageContext.getErrorData().getRequestURI();
if (url==null) url = request.getRequestURI();
url += "?printable";
if (request.getQueryString()!=null) url += "&" + request.getQueryString();

// set style for a tag
char location = Util.getString(request, "location").charAt(0);
String aClass = UtilityContent.getLinkClass(location);
%>
<a class="<%=aClass%>" target="_blank" href="<%=url%>"><%=Setting.getString(application,"printable_linktext")%></a>
