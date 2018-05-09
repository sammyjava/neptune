<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="net.ims.jcms.*, net.ims.jcms.extras.*, java.sql.Date, java.util.*, java.text.*" %>
<%
  /**
   * Calendar extra
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

    boolean weekStartsMonday = Setting.getBoolean(application, "calendar_weekstartsmonday");
    boolean shortDayNames = Setting.getBoolean(application, "calendar_shortdaynames");

    // this should return localized day names
    String weekdays[] = new String[8];
    if (shortDayNames) {
      weekdays = dateFormatSymbols.getShortWeekdays();
    } else {
      weekdays = dateFormatSymbols.getWeekdays();
    }

    String dayNames[] = new String[7];
    if (weekStartsMonday) {
      dayNames[0] = weekdays[Calendar.MONDAY];
      dayNames[1] = weekdays[Calendar.TUESDAY];
      dayNames[2] = weekdays[Calendar.WEDNESDAY];
      dayNames[3] = weekdays[Calendar.THURSDAY];
      dayNames[4] = weekdays[Calendar.FRIDAY];
      dayNames[5] = weekdays[Calendar.SATURDAY];
      dayNames[6] = weekdays[Calendar.SUNDAY];
    } else {
      dayNames[0] = weekdays[Calendar.SUNDAY];
      dayNames[1] = weekdays[Calendar.MONDAY];
      dayNames[2] = weekdays[Calendar.TUESDAY];
      dayNames[3] = weekdays[Calendar.WEDNESDAY];
      dayNames[4] = weekdays[Calendar.THURSDAY];
      dayNames[5] = weekdays[Calendar.FRIDAY];
      dayNames[6] = weekdays[Calendar.SATURDAY];
    }

    // our beloved Calendar object
    Calendar cal = Calendar.getInstance(tz, locale);
    int yearToday = cal.get(Calendar.YEAR);
    int monthToday = cal.get(Calendar.MONTH); // Calendar months are 0-11
    int domToday = cal.get(Calendar.DAY_OF_MONTH);

    // get the number of days in the current month; first day of week is an i8n issue
    if (weekStartsMonday) cal.setFirstDayOfWeek(Calendar.MONDAY); else cal.setFirstDayOfWeek(Calendar.SUNDAY);
    
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

    // set calendar to the first day of the desired month
    cal.set(year, month, 1);

    // get the month parameters
    int dom = cal.get(Calendar.DATE); // it's just 1
    int domMax = cal.getActualMaximum(Calendar.DAY_OF_MONTH);
    int dowStart = cal.get(Calendar.DAY_OF_WEEK);
    int dowFirst = cal.getFirstDayOfWeek();
    int dowLast = dowFirst - 1;
    if (dowLast<1) dowLast = dowFirst + 6;
    int skipDays = dowStart - dowFirst;
    if (skipDays<0) skipDays = skipDays + 7;
    int dow = dowStart;

    // get the events for this month
    Event[] events = Event.getForMonth(application, year, month);

    // fill a vector with dates that contain events
    Vector eventDates = new Vector();
    for (int i=0; i<events.length; i++) {
      if (eventDates.contains(events[i].date)) {
	// do nothing
      } else {
	eventDates.add(events[i].date);
      }
    }

    // get the positioning parameters for the event window
    String theme = Setting.getString(application,"calendar_eventwindow_theme");
    int left = Setting.getInt(application,"calendar_eventwindow_left");
    int top = Setting.getInt(application,"calendar_eventwindow_top");
    int width = Setting.getInt(application,"calendar_eventwindow_width");
    int height = Setting.getInt(application,"calendar_eventwindow_height");

    // allow position override with query string params
    if (request.getParameter("left")!=null) left = Util.getInt(request, "left");
    if (request.getParameter("top")!=null) top = Util.getInt(request, "top");
%>
  <!-- Javascript Zapatec utilities file, includes transport support -->  
  <script src="zapatec/utils/zapatec.js" type="text/javascript"></script>
  <!-- basic Javascript file for the window -->
  <script src="zapatec/zpwin/src/window.js" type="text/javascript"></script>
  <script type="text/javascript">
      var eventwin = Zapatec.Window.setup({
        theme: "<%=theme%>",
        width: <%=width%>,
        height: <%=height%>,
        hideOnClose: true,
        showMaxButton: false,
        showMinButton: false,
        initialState: "hidden"
      });

      function showEventWindow(title,divId) {
        // determine the position of the calendar for active positioning of the event window
        var calwin = document.getElementById("calwin");
        var calpos = getPos(calwin);
        // create and show the event window
        eventwin.setTitle(title);
        var event = document.getElementById(divId).cloneNode(true);
        event.style.display = "block";
        eventwin.setDivContent(event);
        eventwin.setPosition(calpos.x+<%=left%>, calpos.y+<%=top%>);
        eventwin.show();
      }

      function getPos(el) {
        for (var lx=0, ly=0; el!=null; lx+=el.offsetLeft, ly+=el.offsetTop, el=el.offsetParent);
        return {x: lx,y: ly};
      }
  </script>

  <!-- Neptune Calendar extra, by IMS -->
  <div id="calwin" class="cal">
    <table cellspacing="0" class="cal">
      <tr>
        <td class="cal-prev" onClick="location.href='?year=<%=year%>&month=<%=month%>&previousmonth'"></td>
        <td colspan="5" class="cal-month"><%=monthyearFormat.format(cal.getTime()).replaceAll(" ", "&nbsp;")%></td>
        <td class="cal-next" onClick="location.href='?year=<%=year%>&month=<%=month%>&nextmonth'"></td>
      </tr>
      <tr>
          <% for (int i=0; i<dayNames.length; i++) { %>
          <td width="14%" class="cal-day"><%=dayNames[i]%></td>
          <% } %>
      </tr>
      <tr>
        <% for (int i=0; i<skipDays; i++) { %>
          <td width="14%" class="cal-emptydate"></td>
          <% } %>
          <%
            while ((dom=cal.get(Calendar.DATE))<domMax) {
                dow = cal.get(Calendar.DAY_OF_WEEK);
                boolean today = (year==yearToday && month==monthToday && dom==domToday);
                boolean weekend = (dow==Calendar.SATURDAY || dow==Calendar.SUNDAY);
                String datestr = year+"-";
                if (month<9) datestr += "0";
                datestr += (month+1)+"-";
                if (dom<10) datestr += "0";
                datestr += dom;
                Date date = null;
                try {
                  date = Date.valueOf(datestr);
                } catch (IllegalArgumentException ex) {
                  System.err.println(ex.toString()+"; datestr="+datestr);
                }
                boolean eventdate = eventDates.contains(date);
                if (dow==dowFirst) out.println("<tr>");
              %>
              <td valign="top"
                class="cal-date <% if (today) out.print("cal-today "); if (eventdate) out.print("cal-eventdate "); if (weekend) out.print("cal-weekend"); %>"
                <% if (eventdate) { %>onMouseOver="showEventWindow('<%=dateFormat.format(date)%>','<%=date%>')"<% } %>
                ><%=cal.get(Calendar.DATE)%></td>
              <%
                if (dow==dowLast) out.println("</tr>");
                cal.roll(Calendar.DATE, true);
            }  // end while
            // fill out last week
            dom = cal.get(Calendar.DATE);
            dow = cal.get(Calendar.DAY_OF_WEEK);
            boolean today = (year==yearToday && month==monthToday && dom==domToday);
            boolean weekend = (dow==Calendar.SATURDAY || dow==Calendar.SUNDAY);
            String datestr = year+"-";
            if (month<9) datestr += "0";
            datestr += (month+1)+"-";
            if (dom<10) datestr += "0";
            datestr += dom;
            Date date = null;
            try {
              date = Date.valueOf(datestr);
            } catch (IllegalArgumentException ex) {
              System.err.println(ex.toString()+"; datestr="+datestr);
            }
            boolean eventdate = eventDates.contains(date);
            if (dow==dowFirst) out.println("<tr>");
              %>
              <td valign="top"
                class="cal-date <% if (today) out.print("cal-today "); if (weekend) out.print("cal-weekend "); if (eventdate) out.print("cal-eventdate"); %>"
                <% if (eventdate) { %>onMouseOver="showEventWindow('<%=dateFormat.format(date)%>','<%=date%>')"<% } %>
                ><%=cal.get(Calendar.DATE)%></td>
              <%
                dow = (dow+1)%8;
                if (dow==0) dow++;
                while (dow!=dowFirst) {
              %>
              <td width="14%" class="cal-emptydate" valign="top"></td>
              <%
                dow = (dow+1)%8;
                if (dow==0) dow++;
            }
              %>
            </tr>
    </table>
  </div>

  <!-- daily events divs, shown in Zapatec window -->
  <%
    // generate the divs that hold the event content by cycling through the events
    Date prevDate = Date.valueOf("1970-01-01");
    boolean empty = true;
    for (int i=0; i<events.length; i++) {
        boolean newDate = !(prevDate.equals(events[i].date));
        if (newDate) {
          if (empty) {
            empty = false;
          } else {
            out.println("</div>");
          }
    %>
    <div id="<%=events[i].date.toString()%>" style="display:none">
      <div class="event-rss" onClick="location.href='/calendar-rss.jsp'"></div>
      <div class="event-ics" onClick="location.href='/calendar-ics.jsp'"></div>
      <%
      }
      %>
      <div class="event">
        <div class="event-title"><% if (events[i].url==null) { %><%=events[i].title%><% } else { %><a class="event" href="<%=events[i].url%>"><%=events[i].title%></a><% } %></div>
        <div class="event-time"><%=Util.blankIfNull(events[i].time)%></div>
        <div class="event-description"><%=Util.blankIfNull(events[i].description)%></div>
      </div>
      <%
        prevDate = events[i].date;
      }
      if (!empty) {
      %>
    </div>
    <%
    }

  } catch (NumberFormatException ex) {

    // do nothing, thrown if junk passed in query string by hackers

  }
%>
    
