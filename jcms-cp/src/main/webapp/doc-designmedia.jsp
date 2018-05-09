<%@ include file="/WEB-INF/include/init.inc" %>
<% pageTitle = "Docs - Design Media"; %>
<%@ include file="/WEB-INF/include/header.jhtml" %>

<%@ include file="/WEB-INF/include/doc-nav.jhtml" %>

<p>
  <b>Design Media</b> are files, usually images or Flash movies, that are uploaded by site designers to be used in the site design.  Design media are not considered to be content,
  and therefore we created a separate tool to upload design media.  The tool is extremely simple: simply Browse for a file on your local filesystem and press the Upload link to
  upload it to the Neptune server.  The file's URL, which you will use in the Stylesheet or Settings tools, is then shown in the alphabetized list.
</p>

<p>
  Most site designs use background images for primary navigation, the entire body, and perhaps layout panes.  These images are all uploaded using the Design Media tool, and then
  enabled using the background attribute of the given tag in the stylesheet.
</p>

<p>
  In addition, you may upload Flash movies to be placed in the header or subheader; those must be
  referenced in the Settings tool (the header_flash_* and subheader_flash_* entries).
</p>


<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/footer.jhtml" %>

