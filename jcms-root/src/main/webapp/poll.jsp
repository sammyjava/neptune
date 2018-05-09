<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="net.ims.jcms.*, net.ims.jcms.extras.*, java.text.DecimalFormat" %>
<%
  // administrative stuff
  String siteName = Setting.getString(application, "site_name");
  String cssFolder = Setting.getString(application, "site_cssfolder");
  String designFolder = Setting.getString(application, "site_designfolder");

  // instantiate the current poll
  Poll poll = Poll.getCurrent(application);
  boolean voted= false;
  if (poll.poll_id!=0) {
    if (request.getParameter("pollchoice_id")!=null) {
      int pollchoice_id = Util.getInt(request, "pollchoice_id");
      poll.addVote(request, response, pollchoice_id);
      voted = true;
      // get again to update tallies
      poll = Poll.getCurrent(application);
    }
    // add up the total votes for the percentages
    int votes= 0;
    for (int i=0; i<poll.choices.length; i++) votes += poll.choices[i].tally;
%>
  <html>
    <head>
      <title><%=siteName%> Poll</title>
      <link rel="stylesheet" type="text/css" href="<%=cssFolder%>/root.css"/>
    </head>
    <body class="poll">
      
      <div class="poll">
        
        <div class="poll-topic">
          <%=poll.question%>
        </div>
      
          <% if (voted || request.getCookies()==null || poll.hasCookie(request)) { %>
        
        <table class="poll-choices" cellspacing="0">
          <%
            DecimalFormat df = new DecimalFormat("##.#%");
            for (int i=0; i<poll.choices.length; i++) {
                String tallyPercent = df.format((double)poll.choices[i].tally/(double)votes);
            %>
            <tr>
              <td class="poll-choice"><%=poll.choices[i].value%></td>
              <td align="right" class="poll-tally"><%=tallyPercent%></td>
            </tr>
            <% } %>
        </table>
        
        <% } else { %>
        
        <table class="poll-choices" cellspacing="0">
          <% for (int i=0; i<poll.choices.length; i++) { %>
            <tr>
              <td class="poll-button">
                <form class="poll-choice" method="post">
                  <input type="hidden" name="pollchoice_id" value="<%=poll.choices[i].id%>"/>
                  <input type="image" class="poll-button" src="<%=designFolder%>/poll-button.gif" alt="poll choice" name="pollchoice_image" value="<%=poll.choices[i].id%>"/>
                </form>
              </td>
              <td class="poll-choice"><%=poll.choices[i].value%></td>
            </tr>
            <% } %>
        </table>
        
        <% } %>

      </div>
      
    </body>
  </html>
  <%
  }
  %>

