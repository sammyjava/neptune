<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="net.ims.jcms.*,java.util.Calendar,java.util.Locale,java.util.TimeZone" %>
<%
  // copyright is wrapped in a JSP because of the generated current year
  String copyrightText = Setting.getString(application, "site_copyrighttext");

  // get time zone and locale from web.xml parameters
  String timezone = DB.getTimeZone(application);
  String siteLanguage = application.getInitParameter("site.language");
  String siteCountry = application.getInitParameter("site.country");

  // site time zone, for formatting, etc.
  TimeZone tz = TimeZone.getTimeZone(timezone);

  // site locale, for language and other stuff
  Locale locale = null;
  if (siteLanguage==null) {
    locale = Locale.getDefault();
  } else if (siteCountry==null) {
    locale = new Locale(siteLanguage);
  } else {
    locale = new Locale(siteLanguage, siteCountry);
  }

  Calendar calendar = Calendar.getInstance(tz, locale); // dates
%>
&copy;&nbsp;<%=calendar.get(Calendar.YEAR)%>&nbsp;<%=Util.blankIfNull(copyrightText)%>
