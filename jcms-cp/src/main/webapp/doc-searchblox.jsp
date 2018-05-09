<%@ include file="/WEB-INF/include/init.inc" %>
<% pageTitle = "Docs - SearchBlox"; %>
<%@ include file="/WEB-INF/include/header.jhtml" %>
<%@ include file="/WEB-INF/include/doc-nav.jhtml" %>

<p>
  Neptune uses <a target="_blank" href="http://searchblox.com/"><b>SearchBlox</b></a> for its site indexing and search functionality.  This is an excellent Java-based search engine which runs
  under the same servlet engine that runs your Neptune site.  SearchBlox has its own administrative interface, which is shown within an IFRAME on the SearchBlox tool.
</p>

<p>
  In addition to the main SearchBlox admin utility, we provide two tools to manipulate the search results design: the <b>CSS Editor</b> and the <b>XSL Editor</b>.  These tools provide you with a large
  text input field to update the CSS and XSL files used to format the search results.  Both include a Revert button to restore the previous version of the file if you're not happy with your most recent edit.
</p>

<p>
  For information on configuring SearchBlox, please refer to the <a href="SearchBloxUserGuideV4.pdf">SearchBlox User Guide</a>, which is also linked on the SearchBlox admin tool.  NOTE: if you are
  configuring SearchBlox for the first time, the administrative username and password are admin and admin.
</p>


<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/footer.jhtml" %>

