<%@ include file="/WEB-INF/include/init.inc" %>
<% pageTitle = "Docs - Comments"; %>
<%@ include file="/WEB-INF/include/header.jhtml" %>
<%@ include file="/WEB-INF/include/doc-nav.jhtml" %>

<p>
  The <b>Comments</b> extra allows you to add a form for readers to enter comments below your content.  The first comment is displayed on top, and the input form is at the bottom below the last comment.
</p>

<p>
  Comments are tied to content, and may be viewed (and deleted) with the <b>Comments</b> control panel tool.
</p>

<p>
  To add the Comments extra to a content pane, enter the extension context <b>/</b> and extension URL <b>/comments.jsp</b>.
</p>

<p>
  The <b>Blacklisted Words</b> tool allows you to block comments which contain a blacklisted word.  Matches are case-insensitive, so your word entries will be converted to lower case.  Although it's
  called "words", it's actually phrases.  So you can enter a phrase like "health insurance quotes."  Comments with the words "health", "insurance" or "quotes" will be accepted, but a comment that
  contains "health insurance quotes" will be blocked.
</p>


<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/footer.jhtml" %>

