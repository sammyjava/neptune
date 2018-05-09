<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="net.ims.jcms.*,java.util.TimeZone,java.text.SimpleDateFormat,java.util.Date" %>
<%
  // get time zone and locale from web.xml parameters
  String timezone = DB.getTimeZone(application);
  
  // site time zone, for formatting, etc.
  TimeZone tz = TimeZone.getTimeZone(timezone);

  // date format from settings
  SimpleDateFormat dateFormat = new SimpleDateFormat(Setting.getString(application,"site_dateformat"));
  dateFormat.setTimeZone(tz);

  // print the date
  out.println(dateFormat.format(new Date()));
%>
