<%@ include file="/WEB-INF/include/init.inc" %>
<% pageTitle = "Docs - Polls"; %>
<%@ include file="/WEB-INF/include/header.jhtml" %>
<%@ include file="/WEB-INF/include/doc-nav.jhtml" %>

<p>
  The <b>Polls</b> extra allows you to build a poll with a question and multiple choices, schedule it to start and end at given times, and display the vote tallies.
  The Polls extra is an extension, but needs to reside in an IFRAME so that it may write a cookie to the user's browser, enforcing one vote per poll per browser.
  Set the IFRAME <b>src="/poll.jsp"</b>.
</p>

<p>
  Add a new poll by entering a Start Time, End Time and Question.
</p>

<p>
  Once the new poll has been added, you add numbered choices.  Before anyone has voted on the poll, you can update and delete choices.  However, once voting has begun, the poll becomes
  "frozen" and cannot be changed.
</p>

<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/footer.jhtml" %>

