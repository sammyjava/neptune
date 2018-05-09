<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="net.ims.jcms.*, net.ims.jcms.extras.*, java.io.File" %>
<%
 /**
  * Photosets extra
  */
  
  String error = null;
  String message = null;
  boolean printable = request.getParameter("printable")!=null;

  String photosFolder = Setting.getString(application,"photos_folder");
  String thumbsFolder = photosFolder+"/thumbs";
  int thumbWidth = Setting.getInt(application, "photos_thumbnail_width");
  String indexLabel = Setting.getString(application, "photos_index_label");

  PhotoSet photoset = new PhotoSet();
  Photo photo = new Photo();
  Photo previous = new Photo();
  Photo next = new Photo();
  String prevLabel = null;
  String nextLabel = null;

  try {

    int photo_id = Util.getInt(request, "photo_id");
    if (photo_id!=0) {
      photo = new Photo(application, photo_id);
      if (photo.isDefault()) {
        error = "No photo with photo_id="+photo_id+" exists.";
      } else {
        photoset = new PhotoSet(application, photo.photoset_id);
      }
    }

    if (photo.isDefault() && request.getParameter("photoset_id")!=null) {
      int photoset_id = Util.getInt(request, "photoset_id");
      photoset = new PhotoSet(application, photoset_id);
      if (photoset.isDefault()) {
        error = "No photo set with photoset_id="+photoset_id+" exists.";
      } else if (!photoset.thumbnailindex) {
        // show first photo as default
        photo = photoset.photos[0];
      }
    }

    if (!photoset.isDefault()) {
      String photosDir = Setting.getString(application,"photos_dir");
      File dirCheck = new File(photosDir+photoset.photoset_id+File.separator);
      if (dirCheck.exists()) { // back compatibility
        photosFolder += "/"+photoset.photoset_id;
        thumbsFolder = photosFolder+"/thumbs";
      }
      for (int i=0; i<photoset.photos.length; i++) {
	if (photoset.photos[i].photo_id==photo.photo_id) {
	  if (i==0) {
	    // previous = photoset.photos[photoset.photos.length-1];
	    // prevLabel = "prev ("+photoset.photos.length+" of "+photoset.photos.length+")";
	  } else {
	    previous = photoset.photos[i-1];
	    prevLabel = "&lt; Prev";
	  }
	  if (i==photoset.photos.length-1) {
	    // next = photoset.photos[0];
	    // nextLabel = "next (1 of "+photoset.photos.length+")";
	  } else {
	    next = photoset.photos[i+1];
	    nextLabel = "Next &gt;";
	  }
	}
      }
    }

  } catch (Exception ex) {
    error = ex.toString();
  }
%>
<% if (error!=null) { %><div class="error"><%=error%></div><% } %>


  <% if (!photoset.isDefault() && photoset.thumbnailindex && photo.isDefault()) { %>

  <!-- thumbnail index -->
  <div class="photoset-title"><%=photoset.title%></div>
  <div class="photoset-description"><%=Util.blankIfNull(photoset.description)%></div>
  <div class="photoset-shootdate"><%=Util.blankIfNull(photoset.shootdate)%></div>
  <div class="photoset-credit"><%=Util.blankIfNull(photoset.credit)%></div>
  <table class="thumbnails" cellspacing="0">
    <%
      for (int i=0; i<photoset.photos.length; i++) {
          if (i%photoset.thumbnailcolumns==0) out.println("<tr>");
        %>
        <td width="<%=thumbWidth%>" valign="bottom" class="thumbnail"><a href="?photo_id=<%=photoset.photos[i].photo_id%>#photoset"><img class="thumbnail" src="<%=thumbsFolder+"/"+photoset.photos[i].thumbnail%>" width="<%=Util.blankIfZero(thumbWidth)%>" height="<%=Util.blankIfZero(thumbWidth)%>"/></a></td>
        <%
          if ((i+1)%photoset.thumbnailcolumns==0) out.println("</tr>");
      }
      %>
      <% if (photoset.photos.length%photoset.thumbnailcolumns!=0) out.println("</tr>"); %>
  </table>
  
  <% } else if (!photo.isDefault()) { %>

  <!-- single photo browser -->
  <a name="photoset"></a>
  <table class="photoset" cellspacing="0">
    <tr>
      <% if (!printable) { %>
      <td width="<%=thumbWidth%>" valign="bottom" class="thumbnail">
        <% if (previous.photo_id!=0) { %>
        <a href="?photo_id=<%=previous.photo_id%>#photoset"><img class="thumbnail" src="<%=thumbsFolder+"/"+previous.thumbnail%>" width="<%=Util.blankIfZero(thumbWidth)%>" height="<%=Util.blankIfZero(thumbWidth)%>"/></a><br/>
        <%=prevLabel%>
        <% } %>
      </td>
      <% } %>
      <td valign="top" class="photoset-header">
        <div class="photoset-title"><%=photoset.title%></div>
        <div class="photoset-description"><%=Util.blankIfNull(photoset.description)%></div>
        <div class="photoset-shootdate"><%=Util.blankIfNull(photoset.shootdate)%></div>
        <div class="photoset-credit"><%=Util.blankIfNull(photoset.credit)%></div>
        <%
          if (!printable && request.getParameter("nid")!=null && photo.photo_id!=0 && photoset.thumbnailindex) {
            Node n = new Node(application,Util.getInt(request, "nid"));
        %>
        <div class="photoset-indexlink"><a class="photoset-indexlink" href="<%=n.url%>"><%=indexLabel%></a></div>
        <% } %>
      </td>
      <% if (!printable) { %>
      <td width="<%=thumbWidth%>" valign="bottom" class="thumbnail">
          <% if (next.photo_id!=0) { %>
        <a href="?photo_id=<%=next.photo_id%>#photoset"><img class="thumbnail" src="<%=thumbsFolder+"/"+next.thumbnail%>" width="<%=Util.blankIfZero(thumbWidth)%>" height="<%=Util.blankIfZero(thumbWidth)%>"/></a><br/>
        <%=nextLabel%>
        <% } %>
      </td>
      <% } %>
    </tr>
  </table>
  <div class="photo">
    <div class="photo-title"><%=Util.blankIfNull(photo.title)%></div>
    <img class="photo" src="<%=photosFolder+"/"+photo.imagefile%>" alt="<%=Util.blankIfNull(photo.title)%>" width="<%=Util.blankIfZero(photo.imagewidth)%>" height="<%=Util.blankIfZero(photo.imageheight)%>"/>
      <div class="photo-caption"><%=Util.blankIfNull(photo.caption)%></div>
  </div>
  
  <% } %>  
