<%@ include file="/WEB-INF/include/init.inc" %>
<% pageTitle = "Docs - Media"; %>
<%@ include file="/WEB-INF/include/header.jhtml" %>

<%@ include file="/WEB-INF/include/doc-nav.jhtml" %>

<p>
  The <b>Media</b> tool allows you to upload media, typically PDFs, to your site, and restrict access to it.  To upload a media file, use the Browse button to find it on your local
  filesystem, then press the Upload button to upload it to the Neptune server.
</p>

<p>
  To view a media file, or delete it, or update it, select it from the list shown in the selector.  You may narrow that list by entering some text to match the filename and pressing the Filter button.  The Clear
  button will remove the filter and display all media in the list again.
</p>

<p>
  <b>Media Access</b><br/>
  By default, uploaded media files may be downloaded by any site visitor.  However, you may restrict access to a given media file so that only visitors that are members of selected access roles
  may download it.  To do so, click the "N" link ("N" means "No, it's not restricted"), check the desired roles, and click the Update button.  Now, the media file may
  only be downloaded by members of the selected roles.  If you wish to make the file unrestricted, simply click the "Y" link ("Yes, it's restricted"), uncheck any checked roles, and click Update.  The file is now
  unrestricted, ie. downloadable by the public.
</p>


<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/footer.jhtml" %>

