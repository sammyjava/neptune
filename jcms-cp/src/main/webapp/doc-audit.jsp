<%@ include file="/WEB-INF/include/init.inc" %>
<% pageTitle = "Docs - Audit Log"; %>
<%@ include file="/WEB-INF/include/header.jhtml" %>

<%@ include file="/WEB-INF/include/doc-nav.jhtml" %>

<p>
  The <b>Audit Log</b> provides a history of updates made to the Neptune database.  You may view by user,
  by table, and by both user and table.  The audit tool displays 25 lines at a time, with the 25 most
  recent as the default.  To view earlier updates, press the Earlier button; to view later updates, press
  the Later button.
</p>

<p>
  Each audit line displays the time, user, database table, primary key of the affected record in that table,
  database action (U=Update, I=Insert, D=Delete), and a description of the record.  For example:
</p>

<table class="auditlog">
  <tr>
    <td class="auditlog"><b>time</b></td>
    <td class="auditlog"><b>user</b></td>
    <td class="auditlog"><b>table</b></td>
    <td class="auditlog"><b>key</b></td>
    <td class="auditlog"><b>action</b></td>
    <td class="auditlog"><b>description</b></td>
  </tr>
  <tr>
    <td class="auditlog" align="right">07 Aug 2007 15:29:15</td>
    <td class="auditlog">sam@ims.net</td>
    <td class="auditlog">content</td>
    <td class="auditlog" align="right">5</td>
    <td class="auditlog" align="center">U</td>
    <td class="auditlog">home page left</td>
  </tr>
</table>

<p>
  This audit line indicates that sam@ims.net made an update (U) to a content item at 15:29:15 on Aug 7, 2007.  The primary key of the
  record in the content table is 5; the description of the record, in this case, is the content item's label: "home page left".  No record
  is kept of what the actual update was.  As always, good labeling of pages and content items is important to make the Audit tool useful.
</p>



<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/footer.jhtml" %>

