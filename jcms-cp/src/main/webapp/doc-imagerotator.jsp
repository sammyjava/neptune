<%@ include file="/WEB-INF/include/init.inc" %>
<% pageTitle = "Docs - Image Rotator"; %>
<%@ include file="/WEB-INF/include/header.jhtml" %>
<%@ include file="/WEB-INF/include/doc-nav.jhtml" %>

<p>
  The <b>Image Rotator</b> is a handy extra that displays a new image upon each page load.  It is commonly used on the home page to give a site a bit of visual variation.
  The Image Rotator extra is loaded as an extension in a content pane: the extension context is <b>/</b>, the extension URL is <b>/imagerotator.jsp</b>.
</p>

<p>
  You build the list of images by uploading them one by one.  Enter an optional <b>caption</b>, optional <b>alt text</b>, optional <b>URL</b> (in which case the image will be linked), then
  browse for the image file on your computer, and hit Upload Image.  You can number the images if the rotation order is important to you.
</p>

<p>
  A site has only one Image Rotator.
</p>

<p>
  Note that this is <b>not</b> the <a href="doc-flashimagerotator.jsp">Flash Image Rotator</a>, which is a client-side Flash player that runs a slideshow of images that you list in an XML file.  There is no control panel
  tool for the Flash Image Rotator.
</p>

<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/footer.jhtml" %>

