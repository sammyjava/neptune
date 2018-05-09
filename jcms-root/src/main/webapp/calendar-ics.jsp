<%@ page contentType="text/html; charset=UTF-8" language="java" %><%@ page import="net.ims.jcms.*,net.ims.jcms.extras.*,java.sql.Date,java.util.*,java.text.*" %><% response.setContentType("text/calendar"); response.setHeader("Content-Disposition", "attachment; filename=calendar.ics"); %><%

// overall site settings
String siteName = Setting.getString(application, "site_name");
String copyrightText = Setting.getString(application, "site_copyrighttext");
String siteHost = request.getServerName();

// get time zone and locale from web.xml parameters
String timezone = DB.getTimeZone(application);
String siteLanguage = application.getInitParameter("site.language");
String siteCountry = application.getInitParameter("site.country");

// site time zone, for formatting, etc.
TimeZone tz = TimeZone.getTimeZone(timezone);

// site locale, used various places, set in web.xml
Locale locale = null;
if (siteLanguage==null) {
  locale = Locale.getDefault();
} else if (siteCountry==null) {
  locale = new Locale(siteLanguage);
} else {
  locale = new Locale(siteLanguage, siteCountry);
}

// format for displaying dates alone
SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");

// format for passing today's date
SimpleDateFormat timestampFormat = new SimpleDateFormat("yyyyMMdd'T'hhmmss'Z'");

// get today
Calendar calendar = Calendar.getInstance(tz, locale); // dates
String today = timestampFormat.format(calendar.getTime());

// API revision
long svnRevision = 0;
try {
  svnRevision = Util.getSVNRevisionNumber(application.getRealPath("/")+"WEB-INF/lib/jcms.jar");
} catch (Exception ex) {
}

// get all of the events
Event[] events = Event.getAll(application);

out.print("BEGIN:VCALENDAR\r\n");
out.print("PRODID:-//IMS.net//Neptune Calendar "+svnRevision+"//EN\r\n");
out.print("VERSION:2.0\r\n");
out.print("CALSCALE:GREGORIAN\r\n");
out.print("X-WR-CALNAME:"+siteName+"\r\n");
out.print("X-WR-TIMEZONE:"+timezone+"\r\n");
for (int i=0; i<events.length; i++) {
  out.print("BEGIN:VEVENT\r\n");
  out.print("DTSTART;VALUE=DATE:"+dateFormat.format(events[i].date)+"\r\n");
  out.print("DTEND;VALUE=DATE:"+dateFormat.format(events[i].date)+"\r\n");
  out.print("DTSTAMP:"+today+"\r\n");
  out.print("UID:"+"cal"+events[i].event_id+"@"+siteHost+"\r\n");
  String summary = events[i].title+" - "+events[i].time;
  summary = summary.replace("<br/>"," ");
  summary = summary.replace("<br>"," ");
  summary = summary.replace("\r","");
  summary = summary.replace("\n","");
  out.print("SUMMARY:"+summary+"\r\n");
  String description = events[i].description;
  if (description!=null) {
    description = description.replace("<br/>"," ");
    description = description.replace("<br>"," ");
    description = description.replace("\r","");
    description = description.replace("\n","");
  }
  out.print("DESCRIPTION:"+description+"\r\n");
  out.print("END:VEVENT\r\n");
}
out.print("END:VCALENDAR\r\n");
%>
