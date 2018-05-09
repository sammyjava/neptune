<%@ include file="/WEB-INF/include/init.inc" %>
<% pageTitle = "Docs - Utility Content"; %>
<%@ include file="/WEB-INF/include/header.jhtml" %>

<%@ include file="/WEB-INF/include/doc-nav.jhtml" %>

<p>
  <b>Utility Content</b> is persistent content displayed throughout your site in the header, section header, subheader, top and bottom sidebars, and footer.
  Typical examples are links to the home page, site map, a contact form or a privacy policy page.
</p>

<p>
  Utility content consists of HTML copy along with an extension which can be placed above or below the copy.  You may place utility content
  on the home page, inside pages, or both.  Utility Content items are displayed left to right according to their number, except in the sidebars, where they are
  displayed top to bottom according to their number.
</p>

<p>
  The following extras that are commonly used in utility content:
</p>

<table>
  <tr>
    <td><b>/copyright.jsp</b></td>
    <td>displays the site copyright with the current year, using setting <span class="setting">site_copyrighttext</td>
  </tr>
  <tr>
    <td><b>/printablelink.jsp</b></td>
    <td>displays the "printer-friendly" link for the current page, using setting <span class="setting">printable_linktext</span></td>
  </tr>
  <tr>
    <td><b>/accesslink.jsp</b></td>
    <td>displays the access control login and logout links, using settings <span class="setting">access_login_linktext</span> and <span class="setting">access_logout_linktext</span> </td>
  </tr>
  <tr>
    <td><b>/currentdate.jsp</b></td>
    <td>displays the current date/time using the format given by setting <span class="setting">site_dateformat</span></td>
  </tr>
  <tr>
    <td><b>/lastupdate.jsp</b></td>
    <td>displays the page's last update timestamp using the format given by setting <span class="setting">site_dateformat</span></td>
  </tr>
</table>

<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/footer.jhtml" %>

