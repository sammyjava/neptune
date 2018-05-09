<%@ include file="/WEB-INF/include/init.inc" %>
<% pageTitle = "Docs - Photo Sets"; %>
<%@ include file="/WEB-INF/include/header.jhtml" %>
<%@ include file="/WEB-INF/include/doc-nav.jhtml" %>

<p>
  The <b>Photo Sets</b> extra allows you to upload photo sets, which are displayed on the site with previous/next photo navigation similar to Flickr and other photo sites.  A photo set consists of data describing the set
  (title, shoot date, credit, description) and data associated with each photo (the photo itself, alt text and caption).  We use the JUpload Java applet to allow you to upload several photos at at time, and to rotate
  photos before uploading them.
</p>

<p>
  Create a photo set by first inserting a new photo set with its descriptive data.  The only required field is <b>Title</b>.  However, we recommend that you provide the other descriptive elements: Shoot Date, Credit, and Description.  Note that Shoot Date is a free text field; you can use that for something else if you like, or enter a range of dates, or whatever you like.
</p>

<p>
  Once your photo set has been created, you will see the JUpload applet appear.  You must have Java installed on your computer.  Note that this applet can be a bit slow, please be patient.
</p>
<p>
  <em>
    The first time you use the JUpload applet on a given computer, you will see a dialog asking you for permission to run it.
    This is a Java security dialog, required because the applet needs to access your files.  Give the applet permission to run on your machine.
  </em>
</p>

<p>
  To upload photos with the JUpload applet:
</p>
<ol>
  <li>
    Click <b>Browse...</b>  Navigate to the desired photos on your computer.  Select one or more the usual way - e.g. using shift-click or ctrl-click on a Windows computer.  After some or all of your photos for this set have been
    selected, click <b>Open</b>.
  </li>
  <li>
    Preview your photo in the JUpload applet by clicking on its filename in the list.  When your photo is shown in the preview window, you may rotate it using the buttons.  You may also remove a photo from the list if you've added
    it by mistake.  THERE IS NO RESIZE FUNCTION.  If you need to resize your photos, do it first with a high-quality image editor like Photoshop before uploading them.
  </li>
  <li>
    When your photos are ready for upload, click <b>Upload</b>.  The applet will upload the files to the server, and let you know when it's done.  Square thumbnails, with width given by the Settings parameter
    <span class="setting">photos_thumbnail_width</span>,
    are created automatically.  After your photos are uploaded, click <b>Refresh Photos</b> to refresh the list of thumbnails and photos shown below the photoset parameters and applet.
  </li>
</ol>

<p>
  Once your photos are uploaded, you can number them to control the order in which they are displayed (default is alphabetical), and add alt text and captions.  If you click on the photo file name, you will see the full-size photo.
  Hit the Back button on your browser to go back to the photoset.
</p>

<p>
  You may also use the PREVIEW link to view a preview of your photoset presentation.
</p>

<p>
  To add a photo set to a content pane, use the extension context <b>/</b> and extension URL <b>/photoset.jsp?photoset_id=#</b>, where # is the photoset_id shown near the top of the control panel tool.
</p>

<p>
  The <b>photosets</b> stylesheet controls the appearance of the photo sets presentation.
</p>
  
<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/footer.jhtml" %>

