<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="net.ims.jcms.*,java.sql.Timestamp,java.text.SimpleDateFormat,java.util.TimeZone" %>
<%
  // last update comes from content, if we've got it, else from page, else nothing
  int cid = Util.getInt(request, "cid");
  int pid = Util.getInt(request, "pid");

  String divClass = "";
  Timestamp lastModified = null;
  if (cid!=0) {
    Content c = new Content(application, cid);
    lastModified = c.lastModified();
    divClass = "content-lastmodified";
  } else if (pid!=0) {
    Page p = new Page(application, pid);
    lastModified = p.lastModified(application);
    divClass = "page-lastmodified";
  }

  if (lastModified!=null) {
    String timezone = DB.getTimeZone(application);
    TimeZone tz = TimeZone.getTimeZone(timezone);
    SimpleDateFormat dateFormat = new SimpleDateFormat(Setting.getString(application,"lastmodified_dateformat"));
    dateFormat.setTimeZone(tz);
%>
<div class="<%=divClass%>"><%=Setting.getString(application,"lastmodified_prefix")%>&nbsp;<%=dateFormat.format(lastModified)%></div>
<%
}
%>
