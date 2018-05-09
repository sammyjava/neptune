<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="net.ims.jcms.*, net.ims.jcms.extras.*" %>
<%
  // location of uploaded content images
  String imageFolder = Setting.getString(application, "site_imagefolder");

  ImageRotator ir = null;
  // retrieve the previous image from the session, if it's there
  if (session.getAttribute("ImageRotator")!=null) {
    ir = (ImageRotator)session.getAttribute("ImageRotator");
    // advance to next
    ir = ir.next(application);
  } else {
    // get the starting image
    ir = new ImageRotator(application);
  }
  // store current image in session
  session.setAttribute("ImageRotator", ir);
%>
<div class="imagerotator"><% if (ir.url==null) { %><img class="imagerotator" src="<%=imageFolder%>/<%=ir.filename%>" width="<%=ir.width%>" height="<%=ir.height%>" alt="<%=ir.alt%>"/><% } else { %><a href="<%=ir.url%>"><img class="imagerotator" src="<%=imageFolder%>/<%=ir.filename%>" width="<%=ir.width%>" height="<%=ir.height%>" alt="<%=ir.alt%>"/></a><% } %><% if (ir.caption!=null) { %><div class="caption"><%=ir.caption%></div><% } %></div>
