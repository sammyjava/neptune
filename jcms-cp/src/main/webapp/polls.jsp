<%@ include file="/WEB-INF/include/init.inc" %>
<% int extra_id=10; useZapatec=false; %>
<%@ include file="/WEB-INF/include/extra.inc" %>
<%@ include file="/WEB-INF/include/header.jhtml" %>
<%@ include file="/WEB-INF/include/subheader.jhtml" %>
<%
  SimpleDateFormat dateOnly = new SimpleDateFormat("yyyy-MM-dd");
  SimpleDateFormat dateTime = new SimpleDateFormat("yyyy-MM-dd HH:mm");

  int poll_id = 0;
  Poll poll = new Poll();

  try {

    if (request.getParameter("poll_id")!=null) {
      poll_id = Integer.parseInt(request.getParameter("poll_id"));
      poll = new Poll(application, poll_id);
    }

    boolean confirmed = (request.getParameter("confirmed")!=null);

    boolean insertpoll = (request.getParameter("insertpoll")!=null);
    boolean updatepoll = (request.getParameter("updatepoll")!=null);
    boolean deletepoll = (request.getParameter("deletepoll")!=null);

    boolean insertchoice = (request.getParameter("insertchoice")!=null);
    boolean updatechoice = (request.getParameter("updatechoice")!=null);
    boolean deletechoice = (request.getParameter("deletechoice")!=null);

    if (insertpoll || updatepoll) {
      poll.starttime = Util.getTimestamp(request, "starttime");
      poll.endtime = Util.getTimestamp(request, "endtime");
      poll.question = request.getParameter("question");
      poll.label = request.getParameter("label");
      if (insertpoll) {
        poll.insert(application);
        poll_id = poll.poll_id;
        message = "New poll inserted.";
      } else if (updatepoll) {
        poll.update(application);
        message = "Poll updated.";
      }
    }

    if (deletepoll) {
      if (confirmed) {
        poll.delete(application);
        message = "Poll deleted.";
        poll_id = 0;
      } else {
        error = "You must check the box to confirm deletion of a poll (and associated data).";
      }
    }

    if (insertchoice || updatechoice) {
      int num = Integer.parseInt(request.getParameter("num"));
      String choice = request.getParameter("choice");
      if (insertchoice) {
        poll.addChoice(application, num, choice);
        message = "New choice <b>"+num+": "+choice+"</b> added.";
      } else if (updatechoice) {
        int pollchoice_id = Integer.parseInt(request.getParameter("pollchoice_id"));
        poll.updateChoice(application, pollchoice_id, num, choice);
        message = "Poll choice <b>"+num+": "+choice+"</b> updated.";
      }
    }

    if (request.getParameter("deletechoice")!=null) {
      if (confirmed) {
        int pollchoice_id = Integer.parseInt(request.getParameter("pollchoice_id"));
        poll.removeChoice(application, pollchoice_id);
        message = "Choice removed.";
      } else {
        error = "You must check the box to confirm deletion of a poll choice.";
      }
    }

  } catch (Exception ex) {

    error = ex.getMessage();

  }

  // load array with all polls
  Poll polls[] = Poll.getAll(application);
%>
<%@ include file="/WEB-INF/include/errormessage.jhtml" %>

<b>/poll.jsp</b>
<hr/>

<form method="post">
  <select name="poll_id" onChange="submit()">
    <option value="0">--- add new poll ---</option>
    <% for (int i=0; i<polls.length; i++) { %>
      <option <% if (poll_id==polls[i].poll_id) out.print("selected"); %> value="<%=polls[i].poll_id%>"><%=dateOnly.format(polls[i].starttime)%>: <%=polls[i].label%></option>
      <% } %>
  </select>
</form>

<br/>

<% if (poll_id==0) { %>

<form method="post">
  <table class="borders">
    <tr>
      <td colspan="2" class="required">Label<br/><input type="text" size="32" name="label"/></td>
    </tr>
    <tr>
      <td class="required">Start Time<br/>(YYYY-MM-DD HH:MM)<br/><input type="text" size="18" name="starttime"/></td>
      <td class="required">End Time<br/>(YYYY-MM-DD HH:MM)<br/><input type="text" size="18" name="endtime"/></td>
    </tr>
    <tr>
      <td colspan="2" class="required">Question<br/><textarea name="question" rows="3" cols="64"></textarea></td>
    </tr>
    <tr>
      <td colspan="2" align="center"><input type="submit" class="insert" name="insertpoll" value="Add Poll"/></td>
    </tr>
  </table>
</form>

<% } else { %>

<form method="post">
  <input type="hidden" name="poll_id" value="<%=poll_id%>"/>
  <table class="borders">
    <tr>
      <td colspan="2" class="required">Label<br/><input type="text" size="32" name="label" value="<%=Util.blankIfNull(poll.label)%>"/></td>
    </tr>
    <tr>
      <td class="required">Start Time<br/>(YYYY-MM-DD HH:MM)<br/><input type="text" size="18" name="starttime" value="<%=dateTime.format(poll.starttime)%>"/></td>
      <td class="required">End Time<br/>(YYYY-MM-DD HH:MM)<br/><input type="text" size="18" name="endtime" value="<%=dateTime.format(poll.endtime)%>"/></td>
    </tr>
    <tr>
      <td colspan="2" class="required">Question<br/><textarea name="question" rows="3" cols="64"><%=poll.question%></textarea></td>
    </tr>
    <tr>
      <td colspan="2" align="center">
        <input type="submit" class="update" name="updatepoll" value="Update Poll"/>
        <input type="checkbox" name="confirmed" value="true"/>
        <input type="submit" class="delete" name="deletepoll" value="Delete Poll"/>
      </td>
    </tr>
  </table>
</form>

<br/>

<%
  int num = 0;
  int total = 0;
  for (int i=0; i<poll.choices.length; i++) total += poll.choices[i].tally;
    for (int i=0; i<poll.choices.length; i++) {
        num = poll.choices[i].num;
    %>
    <form method="post">
      <input type="hidden" name="poll_id" value="<%=poll_id%>"/>
      <table>
        <tr>
          <td><input type="text" size="1" name="num" value="<%=poll.choices[i].num%>"/></td>
          <td><textarea name="choice" cols="64" rows="1"><%=poll.choices[i].value%></textarea></td>
          <td align="right"><%=poll.choices[i].tally%></td>
          <% if (total==0) { %>
          <td>
            <input type="hidden" name="pollchoice_id" value="<%=poll.choices[i].id%>"/>
            <input type="submit" class="update" name="updatechoice" value="Update Choice"/>
            <input type="checkbox" name="confirmed" value="true"/>
            <input type="submit" class="delete" name="deletechoice" value="Remove Choice"/>
          </td>
          <% } %>
        </tr>
      </table>
    </form>
    <%
    }

    if (total==0) {
    %>
    <form method="post">
      <input type="hidden" name="poll_id" value="<%=poll_id%>"/>
      <table>
        <tr>
          <td><input type="text" size="1" name="num" value="<%=(num+1)%>"/></td>
          <td><textarea name="choice" cols="64" rows="1"></textarea></td>
          <td><input type="submit" class="insert" name="insertchoice" value="Add Choice"/></td>
        </tr>
      </table>
    </form>
    <%
    } else {
    %>
    <table>
      <tr>
        <td width="260" align="right"><b>total votes <%=total%></b></td>
      </tr>
    </table>
    <%
    }
  }
%>
<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/footer.jhtml" %>
