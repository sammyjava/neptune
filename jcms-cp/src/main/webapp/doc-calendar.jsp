<%@ include file="/WEB-INF/include/init.inc" %>
<% pageTitle = "Docs - Calendar"; %>
<%@ include file="/WEB-INF/include/header.jhtml" %>
<%@ include file="/WEB-INF/include/doc-nav.jhtml" %>

<p>
  The <b>Calendar</b> extra allows you to display a monthly calendar that launches an AJAX popup window with a list of events when you mouse over a date with events.  The extension context is <b>/</b>, and
  the extension URL is <b>/calendar.jsp</b>.
</p>


<p>
  Data entry with the <b>Calendar</b> tool is month-based: select a year and month, and then insert, update and delete events for the selected month.  The fields for an event are:
</p>

<table>
  <tr>
    <td><b>Date</b></td>
    <td>Day of month (required).</td>
  </tr>
  <tr>
    <td>Time</td>
    <td>Time of the event, free text.</td>
  </tr>
  <tr>
    <td>Sort order</td>
    <td>A sorting number, in case you have multiple events on the same day (since we can't use free-text time to sort them).
  </tr>
  <tr>
    <td><b>Title<b></td>
    <td>The title of the event (required). This will be a link the URL, if given.
  </tr>
  <tr>
    <td>Description</td>
    <td>The description of the event.  Free text.
  </tr>
  <tr>
    <td>URL</td>
    <td>The URL pointing to a page with more about the event.
  </tr>
</table>

<p>
  <b>Calendar Settings.</b> There are several Settings that control how the calendar looks.  They are:
</p>
<table>
  <tr>
    <td>calendar_weekstartsmonday</td>
    <td>Check this if you want weeks to start on Monday, as in Europe.</td>
  </tr>
  <tr>
    <td>calendar_date_format</td>
    <td>The java.text.SimpleDateFormat the display of dates on the event list.</td>
  </tr>
  <tr>
    <td>calendar_shortdaynames</td>
    <td>Check this to have the calendar display short day names (Sun, Mon, etc.) rather than long day names (Sunday, Monday, etc.)</td>
  </tr>
  <tr>
    <td>calendar_monthyear_format</td>
    <td>The java.text.SimpleDateFormat for the display of the month and year on the calendar.</td>
  </tr>
  <tr>
    <td>calendar_eventwindow_theme</td>
    <td>The theme of the event window, either a stock Zapatec theme (default, minimal, osx, outlook, plain, silverxp, winxp) or the location of a custom theme CSS (e.g. /design/events.css).</td>
  </tr>
  <tr>
    <td>calendar_eventwindow_width<br/>calendar_eventwindow_height</td>
    <td valign="top">The width and height of the event window</td>
  </tr>
  <tr>
    <td>calendar_eventwindow_left<br/>calendar_eventwindow_top</td>
    <td valign="top">The left and top offsets for positioning the window, relative to the full browser window.  NOTE: if you display the calendar in more than one place on your site, you need to put
      it in the same place, so that the site-wide event window position is correct.
    </td>
  </tr>
</table>

<p>
  The calendar is styled with the <b>calendar</b> stylesheet.  Most of the classes are self-explanatory; don't hesitate to ask IMS for help if you need it.
</p>

<p>
  <b>RSS Feed.</b> There is an RSS feed of your calendar events provided at <b>/calendar-rss.jsp</b>.  Use the <b>div.event-rss</b> stylesheet class
  to display an RSS icon at the top of the event window.  If this class is left empty, no RSS icon is visible; if you upload an RSS icon to Design Media, set it
  as the background for this class to make the RSS link visible.
</p>

<p>
  <b>iCalendar File Export.</b>  You can download an iCalendar file to import your calendar into Google Calendar, iPhone, and other apps.
  The URL for the iCalendar file is <b>/calendar-ics.jsp</b>.  It downloads as the file <b>calendar.ics</b>.
  You can also use <b>/calendar-ics.jsp</b> to import events directly into Google Calendar using Google Calendar's "Add by URL" function.
  Use the <b>div.event-ics</b> stylesheet class to display a calendar icon at the top of the event window.  If this class is left empty, no calendar icon is visible; if you
  upload an icon to Design Media, set it as the background for this class to make the calendar link visible.
</p>
  
  
<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/footer.jhtml" %>

