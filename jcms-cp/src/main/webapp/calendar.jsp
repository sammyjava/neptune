<%@ include file="/WEB-INF/include/init.inc" %>
<% int extra_id=13; useZapatec=false; %>
<%@ include file="/WEB-INF/include/extra.inc" %>
<%@ include file="/WEB-INF/include/header.jhtml" %>
<%@ include file="/WEB-INF/include/subheader.jhtml" %>
<%
  // our beloved Calendar object (default locale)
  Calendar cal = Calendar.getInstance(tz);

  // current year, month
  int yearToday = cal.get(Calendar.YEAR);
  int monthToday = cal.get(Calendar.MONTH);

  // format to extract the day of month from the date
  SimpleDateFormat domFormat = new SimpleDateFormat("dd");

  // default to current year, month
  int year = yearToday;
  int month = monthToday;
  
  // user-selected year, month
  if (request.getParameter("year")!=null && request.getParameter("year").trim().length()>0) year = Integer.parseInt(request.getParameter("year"));
  if (request.getParameter("month")!=null && request.getParameter("month").trim().length()>0) month = Integer.parseInt(request.getParameter("month"));

  // set the calendar for day 1 of the selected year, month
  cal.set(year, month, 1);

  // get the number of days in this month
  int domMax = cal.getActualMaximum(Calendar.DAY_OF_MONTH);

  // actions
  boolean insert = request.getParameter("insert")!=null;
  boolean update = request.getParameter("update")!=null;
  boolean delete = request.getParameter("delete")!=null;

  try {
    if (insert || update) {
      Event event = new Event();
      if (update) event = new Event(application, Integer.parseInt(request.getParameter("event_id")));
      if (request.getParameter("dom").trim().length()>0) event.dateStr = year+"-"+(month+1)+"-"+request.getParameter("dom");
      event.title = request.getParameter("title");
      event.description = request.getParameter("description");
      event.time = request.getParameter("time");
      event.url = request.getParameter("url");
      event.num = Integer.parseInt(request.getParameter("num"));
      if (insert) {
        event.insert(application);
        message = "New event inserted for "+event.date+": <b>"+event.title+"</b>.";
      } else if (update) {
        event.update(application);
        message = "Event for "+event.date+" updated: <b>"+event.title+"</b>.";
      }
    }

    if (delete) {
      if (request.getParameter("confirmed")==null) {
        error = "You must check the box to confirm deletion of an event.";
      } else {
        Event event = new Event(application, Integer.parseInt(request.getParameter("event_id")));
        message = "Event for "+event.date+" deleted: <b>"+event.title+"</b>.";
        event.delete(application);
      }
    }
  } catch (Exception ex) {
    error = ex.getMessage();
  }

  // month names
  String[] months = new DateFormatSymbols().getMonths();
  
  // get the events for the selected year, month
  Event[] events = Event.getForMonth(application, year, month);

%>
<%@ include file="/WEB-INF/include/errormessage.jhtml" %>

<!-- month selector -->
<form method="post">
  <table>
    <tr>
      <td><b>Year:</b></td>
      <td>
        <select name="year" onChange="submit()">
          <% for (int y=(yearToday-1); y<(yearToday+3); y++) { %>
          <option <% if (y==year) out.print("selected"); %> value="<%=y%>"><%=y%></option>
          <% } %>
        </select>
      </td>
      <td><b>Month:</b></td>
      <td>
        <select name="month" onChange="submit()">
          <% for (int m=0; m<12; m++) { %>
          <option <% if (m==month) out.print("selected"); %> value="<%=m%>"><%=months[m]%></option>
          <% } %>
        </select>
      </td>
      <td>
        <b>/calendar.jsp</b>
      </td>
    </tr>
  </table>
</form>

<% for (int i=0; i<events.length; i++) { int dom = Integer.parseInt(domFormat.format(events[i].date)); %>
  <form method="post">
    <input type="hidden" name="year" value="<%=year%>"/>
    <input type="hidden" name="month" value="<%=month%>"/>
    <input type="hidden" name="event_id" value="<%=events[i].event_id%>"/>
    <hr/>
    <table>
      <tr>
        <td>
          <b>Date:</b>
          <select name="dom">
            <% for (int d=1; d<=domMax; d++) { %><option <% if (d==dom) out.print("selected"); %> value="<%=d%>"><%=d%></option><% } %>
          </select>
          Time: <input type="text" name="time" size="32" value="<%=Util.blankIfNull(events[i].time)%>"/>
          Sort order: <input type="text" name="num" size="2" value="<%=events[i].num%>"/>
          <br/>
          <b>Title</b><br/><textarea name="title" rows="1"cols="80"><%=events[i].title%></textarea><br/>
          Description<br/><textarea name="description" rows="3"cols="80"><%=Util.blankIfNull(events[i].description)%></textarea><br/>
          URL<br/><input type="text" name="url" size="80" value="<%=Util.blankIfNull(events[i].url)%>"/>
        </td>
        <td>
          <input type="submit" class="update" name="update" value="Update"/>
          <input type="checkbox" name="confirmed" value="true"/>
          <input type="submit" class="delete" name="delete" value="Delete"/>
        </td>
      </tr>
    </table>
  </form>
  <% } %>
  <form method="post">
    <input type="hidden" name="year" value="<%=year%>"/>
    <input type="hidden" name="month" value="<%=month%>"/>
    <hr/>
    <table>
      <tr>
        <td>
          <b>Date:</b>
          <select name="dom">
            <% for (int d=1; d<=domMax; d++) { %><option value="<%=d%>"><%=d%></option><% } %>
          </select>
          Time: <input type="text" name="time" size="32""/>
          Sort order: <input type="text" name="num" size="2" value="1"/>
          <br/>
          <b>Title</b><br/><textarea name="title" rows="1"cols="80"></textarea><br/>
          Description<br/><textarea name="description" rows="3"cols="80"></textarea><br/>
          URL<br/><input type="text" name="url" size="80"/>
        </td>
        <td>
          <input type="submit" class="insert" name="insert" value="Insert"/>
        </td>
      </tr>
    </table>
  </form>
    
<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/footer.jhtml" %>
