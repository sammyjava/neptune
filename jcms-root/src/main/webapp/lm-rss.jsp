<?xml version="1.0" encoding="ISO-8859-1"?>
<%@ page contentType="text/xml; charset=ISO-8859-1" language="java" %>
<%@ page import="net.ims.jcms.*, net.ims.jcms.extras.*, lmapi.ListStruct, java.util.*" %>
<%

  try {
    
    // overall site settings
    String siteName = Setting.getString(application, "site_name");
    
    // stuff that comes from settings
    String listname = Setting.getString(application, "lyris_list");
    if (listname.length()==0) throw new ValidationException("lyris_list is not set in Settings.");
    
    // instantiate Lyris object so we can get at the SOAP service
    Lyris lyris = new Lyris(application);
    
    // list params
    ListStruct listStruct = lyris.selectList(listname);
    
    // get all the mailings from this list
    Message[] messages = lyris.getMessageHeaders(listname);
%>
<!-- RSS generated by <%=siteName%> on <%=new Date()%> -->
<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
  <channel>
    <title><%=listStruct.getShortDescription()%></title>
    <description><%=siteName%> <%=listStruct.getShortDescription()%></description>
    <link>http://<%=request.getServerName()%><%=application.getContextPath()%>/</link>
    <atom:link href="http://<%=request.getServerName()%><%=application.getContextPath()%>/lm-rss.jsp" rel="self" type="application/rss+xml" />
    <language>en-us</language>
    <generator>IMS Neptune + Lyris ListManager</generator>
      <% for (int i=0; i<messages.length; i++) { %>
      <item>
        <title><%=Util.escapeAmp(messages[i].hdrsubject)%> [<%=messages[i].creatstamp.substring(0,10)%>]</title>
        <link>http://<%=request.getServerName()%>/lm.jsp?messageid=<%=messages[i].messageid%></link>
        <pubDate><%=messages[i].hdrdate%></pubDate>
        <guid isPermaLink="true">http://<%=request.getServerName()%>/lm.jsp?messageid=<%=messages[i].messageid%></guid>
      </item>
      <% } %>
  </channel>
</rss>
<%
} catch (Exception ex) {

  out.print(ex.toString());

}
%>
