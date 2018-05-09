<%@ include file="/WEB-INF/include/init.inc" %>
<% pageTitle = "Docs - Atom Feed"; %>
<%@ include file="/WEB-INF/include/header.jhtml" %>
<%@ include file="/WEB-INF/include/doc-nav.jhtml" %>

<p>
  The <b>Atom Feed Extra</b> allows you to display entries from an Atom feed, such as from Wordpress, other blogs and other apps.
  It doesn't integrate the functionality of posting new articles or comments; it simply shows the title, date, author and summary of an entry with a link over to the
  external source to read more.  You can display one Atom feed per Neptune site.
</p>

<p>
  The configuration of the Atom Feed Extra is done in three simple Settings:
</p>

<table>
  <tr><td><b>Setting</b></td><td><b>default</b></td><td><b>description</b></td></tr>
  <tr><td>atom_uri</td><td>http://wordpress.org/news/feed/atom</td><td>The Atom feed URI</td></tr>
  <tr><td>atom_dateformat</td><td>yyyy-MM-dd HH:mm</td><td>java.text.SimpleDateFormat for the entry dates</td></tr>
  <tr><td>atom_maxlisted</td><td>0</td><td>Maximum number of entries listed, if not 0</td></tr>
</table>

<p>
  Styling of the feed list is set with the <b>blogger</b> stylesheet, which should become visible in the Stylesheet tool after you've toggled the <b>blogger_enable</b> setting.  (It didn't seem worthwhile
  to duplicate the blogger extra stylesheet for the Atom feed extra, but we could, if desired.)
</p>

<p>
  Finally, to place the Atom Feed Extra into a content item, simply enter extension context <b>/</b> and extension URL <b>/atom.jsp</b>.  All of the other information is drawn from the settings.
</p>

<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/footer.jhtml" %>
