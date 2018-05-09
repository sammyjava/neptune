<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="net.ims.jcms.*, net.ims.jcms.extras.*, java.sql.Date, java.util.*, java.text.*" %>
<%
  /**
   * Calendar - events extra - displays a month's events in a stack, no AJAX calendar display
   *
   * Wrapped in try/catch block to deal with bad query strings and NumberFormatException.
   */

  try {

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

    // formatting stuff from settings and locale
    SimpleDateFormat dateFormat = new SimpleDateFormat(Setting.getString(application,"calendar_date_format"), locale);
    SimpleDateFormat monthyearFormat = new SimpleDateFormat(Setting.getString(application,"calendar_monthyear_format"), locale);
    DateFormatSymbols dateFormatSymbols = new DateFormatSymbols(locale);

    // our beloved Calendar object
    Calendar cal = Calendar.getInstance(tz, locale);
    int yearToday = cal.get(Calendar.YEAR);
    int monthToday = cal.get(Calendar.MONTH); // Calendar months are 0-11
    int domToday = cal.get(Calendar.DAY_OF_MONTH);

    // default to this month
    int year = yearToday;
    int month = monthToday;

    // set date from posted vars
    if (request.getParameter("year")!=null) year = Util.getInt(request, "year");
    if (request.getParameter("month")!=null) month = Util.getInt(request, "month");

    // handle month browser
    if (request.getParameter("previousmonth")!=null) {
      month--;
    } else if (request.getParameter("nextmonth")!=null) {
      month++;
    }

    // handle year boundaries
    if (month<0) {
      month = 11;
      year--;;
    } else if (month>11) {
      month = 0;
      year++;
    }

    String[] months = dateFormatSymbols.getMonths();

    Event[] events = Event.getForMonth(application, year, month);
%>
<!-- Neptune Calendar extra, by IMS, events listing display -->
<form method="post">
  <table id="event-selector" cellspacing="0">
    <tr>
      <td class="event-month-selector">
        <select name="month" onChange="submit()">
          <% for (int m=0; m<12; m++) { %>
            <option <% if (m==month) out.print("selected"); %> value="<%=m%>"><%=months[m]%></option>
          <% } %>
        </select>
      </td>
      <td class="event-year-selector">
        <select name="year" onChange="submit()">
            <% for (int y=Event.getYearMin(application); y<=Event.getYearMax(application); y++) { %>
            <option <% if (y==year) out.print("selected"); %>  value="<%=y%>"><%=y%></option>
          <% } %>
        </select>
      </td>
    </tr>
  </table>
</form>
<table id="events" cellspacing="0">
  <tr>
    <td class="event-date-heading">Date</td>
    <td class="event-time-heading">Time</td>
    <td class="event-copy-heading">Event</td>
  </tr>
    <% for (int i=0; i<events.length; i++) { %>
    <tr class="event">
      <td class="event-date" valign="top" nowrap><%=dateFormat.format(events[i].date)%></td>
      <td class="event-time" valign="top" nowrap><%=events[i].time%></td>
      <td class="event-copy"><span class="event-title"><%=events[i].title%></span><br/><span class="event-description"><%=events[i].description%></span></td>
    </tr>
    <% } %>
</table>
<%
} catch (NumberFormatException ex) {

    // do nothing, thrown if junk passed in query string by hackers

  }
%>
    
