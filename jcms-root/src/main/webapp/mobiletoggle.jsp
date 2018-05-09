<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="net.ims.jcms.*" %>
<%
  // mobile stuff
  com.handinteractive.mobile.UAgentInfo agentInfo = new com.handinteractive.mobile.UAgentInfo(request.getHeader("user-agent"), request.getHeader("accept"));
  boolean mobileDetected = (agentInfo.getIsTierTablet() || agentInfo.getIsTierIphone());
  boolean forceDesktop = false;
  if (request.getParameter("force-desktop")!=null) {
    if (request.getParameter("force-desktop").equals("true")) {
      forceDesktop = true;
    } else {
      session.removeAttribute("force-desktop");
    }
  } else if (session.getAttribute("force-desktop")!=null && session.getAttribute("force-desktop").equals("true")) {
    forceDesktop = true;
  }
%>
<% if (mobileDetected) { %>
<div id="mobiletoggle">
  <% if (forceDesktop) { %>
  <a class="mobiletoggle" href="?force-desktop=false"><%=Setting.getString(application,"mobile_toggle_mobile")%></a>
  <% } else { %>
  <a class="mobiletoggle" href="?force-desktop=true"><%=Setting.getString(application,"mobile_toggle_desktop")%></a>
  <% } %>
</div>
<% } %>
