<%@ include file="/WEB-INF/include/init.inc" %>
<% int extra_id=4; useZapatec=false; %>
<%@ include file="/WEB-INF/include/extra.inc" %>
<%@ include file="/WEB-INF/include/header.jhtml" %>
<%@ include file="/WEB-INF/include/subheader.jhtml" %>
<%
  // Settings
  int maxChunkSize = Setting.getInt(application, "photos_max_chunk");
  int maxHeight = Setting.getInt(application, "photos_max_height");
  int maxWidth = Setting.getInt(application, "photos_max_width");
  String photosFolder = Setting.getString(application, "photos_folder");
  String photosDir = Setting.getString(application, "photos_dir");
  int thumbWidth = Setting.getInt(application, "photos_thumbnail_width");

  // instantiate requested photoset
  PhotoSet photoset = new PhotoSet(application, Util.getInt(request, "photoset_id"));
  if (!photoset.isDefault()) {
    File dirCheck = new File(photosDir+photoset.photoset_id+File.separator);
    if (dirCheck.exists()) { // back compatibility
      photosDir += photoset.photoset_id+File.separator;
      photosFolder += "/"+photoset.photoset_id;
    }
  }

  int photo_id = 0;
  if (request.getParameter("photo_id")!=null) {
    photo_id = Integer.parseInt(request.getParameter("photo_id"));
  }
  
  // delete confirmation
  boolean confirmed = (request.getParameter("confirmed")!=null);

  // logic booleans
  boolean photosetinsert = (request.getParameter("photosetinsert")!=null);
  boolean photosetupdate = (request.getParameter("photosetupdate")!=null);
  boolean photosetdelete = (request.getParameter("photosetdelete")!=null);
  boolean photoupdate = (request.getParameter("photoupdate")!=null);
  boolean photodelete = (request.getParameter("photodelete")!=null);
  boolean photosuploaded = (request.getParameter("uploaded")!=null);
  
  try {

    if (photosetinsert || photosetupdate) {
      photoset.title = request.getParameter("title");
      photoset.shootdate = request.getParameter("shootdate");
      photoset.credit = request.getParameter("credit");
      photoset.description = request.getParameter("description");
      photoset.thumbnailindex = request.getParameter("thumbnailindex")!=null;
      photoset.thumbnailcolumns = Util.zeroIfNull(request.getParameter("thumbnailcolumns"));
      if (photosetinsert) {
        photoset.insert(request);
        photosDir += photoset.photoset_id+File.separator;
        photosFolder += "/"+photoset.photoset_id;
        message = "New photo set <b>"+photoset.photoset_id+": "+photoset.title+"</b> added; dir="+photosDir;
        File dirCheck = new File(photosDir);
        if (dirCheck.mkdir()) {
          dirCheck = new File(photosDir+"thumbs");
          if (!dirCheck.mkdir()) error = "Error creating thumbnail directory: "+dirCheck.getName();
        } else {
          error = "Error creating photos directory: "+dirCheck.getName();
        }
      } else if (photosetupdate) {
        photoset.update(request);
        message = "Photo set <b>"+photoset.photoset_id+": "+photoset.title+"</b> updated.";
      }
    }

    if (photosetdelete) {
      if (confirmed) {
        // delete all the photo files
        for (int i=0; i<photoset.photos.length; i++) {
	  File imageFile = new File(photosDir+photoset.photos[i].imagefile);
	  imageFile.delete();
	  File thumbFile = new File(photosDir+"thumbs/"+photoset.photos[i].thumbnail);
	  thumbFile.delete();
	}
	message = "Photo set <b>"+photoset.title+"</b> deleted.";
	photoset.delete(request);
      } else {
	error = "You must check the box to confirm deletion of a photo set.";
      }
    }

    if (photoupdate) {
      Photo photo = new Photo(application, photo_id);
      photo.num = Integer.parseInt(request.getParameter("num"));
      photo.caption = request.getParameter("caption");
      photo.title = request.getParameter("title");
      photo.update(request);
      message = "Photo <b>"+photo.imagefile+"</b> updated.";
      // refresh photoset
      photoset.update(application);
    }

    if (photodelete) {
      if (confirmed) {
        Photo photo = new Photo(application, photo_id);
	String imagefile = photo.imagefile;
	String thumbnail = photo.thumbnail;
        photo.delete(request);
        // remove files from filesystem
        File imageFile = new File(photosDir+imagefile);
        imageFile.delete();
        File thumbFile = new File(photosDir+"thumbs/"+thumbnail);
        thumbFile.delete();
        // refresh photoset
        photoset.update(application);
        message = "Photo <b>"+imagefile+"</b> deleted.";
      } else {
        error = "You must check the box to confirm deletion of a photo.";
      }
    }

    if (photosuploaded) message = "Photos uploaded to photo set.";

  } catch (Exception ex) {

    error = ex.getMessage();

  }

  // load all photosets for selector
  PhotoSet[] photosets = PhotoSet.getAll(application);
%>
<%@ include file="/WEB-INF/include/errormessage.jhtml" %>

<table>
  <tr>
    <td valign="top">

      <form action="photosets.jsp" method="post">
        <select name="photoset_id" onChange="submit()">
          <option value="0">--- insert new photo set ---</option>
          <% for (int i=0; i<photosets.length; i++) { %>
            <option <% if (photoset.photoset_id==photosets[i].photoset_id) out.print("selected"); %> value="<%=photosets[i].photoset_id%>"><%=photosets[i].title%> [<%=photosets[i].photoset_id%>]</option>
            <% } %>
        </select>
      </form>
      
      <!-- photosets update/insert -->
      <form action="photosets.jsp" method="post">
        <input type="hidden" name="photoset_id" value="<%=photoset.photoset_id%>"/>
        <table>
          <% if (photoset.photoset_id>0) { %>
          <tr>
            <td>
              <b>/photoset.jsp?photoset_id=<%=photoset.photoset_id%></b><br/>
              created <%=sdf.format(photoset.created)%> <a class="preview" target="preview" href="photoset-preview.jsp?photoset_id=<%=photoset.photoset_id%>">PREVIEW</a>
            </td>
          </tr>
          <% } %>
            <tr>
              <td>
                <input type="checkbox" name="thumbnailindex" <% if (photoset.thumbnailindex) out.print("checked"); %> value="true"/>
                  Show thumbnail index, with
                  <input type="text" name="thumbnailcolumns" size="1" value="<%=photoset.thumbnailcolumns%>"/>
                  columns
              </td>
            </tr>
            <tr>
              <td class="required">Title<br/><input type="text" size="50" name="title" value="<%=Util.blankIfNull(photoset.title)%>"/></td>
            </tr>
            <tr>
              <td>Shoot Date<br/><input type="text" size="20" name="shootdate" value="<%=Util.blankIfNull(photoset.shootdate)%>"/></td>
            </tr>
            <tr>
              <td>Credit<br/><input type="text" size="50" name="credit" value="<%=Util.blankIfNull(photoset.credit)%>"/></td>
            </tr>
            <tr>
              <td>Description<br/><textarea cols="50" rows="10" name="description"><%=Util.blankIfNull(photoset.description)%></textarea></td>
            </tr>
            <tr>
              <td align="center">
                  <% if (photoset.photoset_id>0) { %>
                <input type="submit" name="photosetupdate" class="update" value="Update"/>
                <input type="checkbox" name="confirmed" value="true"/>
                <input type="submit" name="photosetdelete" class="delete" value="Delete Photo Set"/>
                <% } else { %>
                <input type="submit" name="photosetinsert" class="insert" value="Insert New Photo Set"/>
                <% } %>
              </td>
            </tr>
          </table>
        </form>
      
    </td>
    <% if (photoset.photoset_id>0) { %>
    <td valign="top">
      <%@ include file="jupload-applet.jhtml" %>
    </td>
    <% } // end if photoset_id %>
  </tr>
</table>

<!-- photos -->
<%
  if (photoset.photoset_id>0) { 
    for (int i=0; i<photoset.photos.length; i++) {
  %>
  <a name="<%=photoset.photos[i].photo_id%>"></a>
  <form action="photosets.jsp#<%=photoset.photos[i].photo_id%>" method="post">
    <input type="hidden" name="photoset_id" value="<%=photoset.photoset_id%>"/>
    <input type="hidden" name="photo_id" value="<%=photoset.photos[i].photo_id%>"/>
    <table style="border-top: 1px solid gray;">
      <% if (photoupdate && photo_id==photoset.photos[i].photo_id) { %>
      <tr>
        <td colspan="5">
          <% if (error!=null) { %><span class="error"><%=error%></span><% } %>
          <% if (message!=null) { %><span class="message"><%=message%></span><% } %>
        </td>
      </tr>
      <% } %>
      <tr>
        <td rowspan="2"><input type="text" size="2" name="num" value="<%=photoset.photos[i].num%>"/></td>
        <td rowspan="2" valign="bottom" width="<%=thumbWidth%>"><a href="<%=photosFolder%>/<%=photoset.photos[i].imagefile%>"><img src="<%=(photosFolder+"/thumbs/"+photoset.photos[i].thumbnail)%>" width="<%=thumbWidth%>" border="0"/></a></td>
        <td colspan="3"><b><%=photoset.photos[i].imagefile%></b> <%=photoset.photos[i].imagewidth%>&times;<%=photoset.photos[i].imageheight%> (uploaded <%=sdf.format(photoset.photos[i].timeposted)%>)</td>
      </tr>
      <tr>
        <td>title<br/><textarea name="title" rows="2" cols="24"><%=Util.blankIfNull(photoset.photos[i].title)%></textarea></td>
        <td>caption<br/><textarea name="caption" rows="2" cols="48"><%=Util.blankIfNull(photoset.photos[i].caption)%></textarea></td>
        <td>
          <input type="submit" class="update" name="photoupdate" value="Update"/>
          <input type="checkbox" name="confirmed" value="true"/>
          <input type="submit" class="delete" name="photodelete" value="Delete"/>
        </td>
      </tr>
    </table>
  </form>
  <%
  }
}
  %>
<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/footer.jhtml" %>
