<%@ include file="/WEB-INF/include/init.inc" %>
<% pageTitle = "Docs - Settings"; %>
<%@ include file="/WEB-INF/include/header.jhtml" %>

<%@ include file="/WEB-INF/include/doc-nav.jhtml" %>

<p>
  The <b>Settings</b> tool allows your site administrator to set site-wide settings for your Neptune site.  There are many options for a Neptune site, ranging from centering the site in
  visitors' browsers to enabling a Search form in the header.  There are important server parameters, such as directory paths, set here as well.  The following provides a description of
  each setting, along with the value currently set on this site.
</p>

<table class="borders">
  <tr>
    <td><b>Setting</b></td>
    <td><b>Current Value</b></td>
    <td><b>Description</b></td>
  </tr>
  <%
    // load a TreeMap of settings
    TreeMap t = Setting.getTreeMap(application);
    for (Iterator i=t.keySet().iterator(); i.hasNext(); ) {
      String key = (String) i.next();
      Setting s = new Setting(application, key);
  %>
  <tr>
    <td class="borders"><%=s.name%></td>
    <td class="borders"><%=s.value%></td>
    <td class="borders"><%=s.description%></td>
  </tr>
  <%
  }
  %>
</table>

<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/footer.jhtml" %>

