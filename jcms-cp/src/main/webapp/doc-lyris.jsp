<%@ include file="/WEB-INF/include/init.inc" %>
<% pageTitle = "Docs - Lyris ListManager Feed"; %>
<%@ include file="/WEB-INF/include/header.jhtml" %>
<%@ include file="/WEB-INF/include/doc-nav.jhtml" %>

<p>
  If you have a Lyris ListManager email list, you can display an RSS feed of the messages.  This is useful if you use Lyris to send newsletters, weekly updates, etc.
</p>

<p>
  <b>Settings.</b> There are two settings that must be set to enable Lyris ListManager integration: <b>lyris_host</b>, the host of your Lyris server (e.g. lists.ims.net),
  and <b>lyris_list</b>, the name of your Lyris list (e.g. ims-newsletter).
</p>

<p>
  Other than that, simply use the URL <b>/lm-rss.jsp</b> to see the RSS feed from your list.  Each message subject links <b>/lm.jsp</b>, which displays that message.
</p>

<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/footer.jhtml" %>
