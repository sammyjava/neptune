<%@ include file="/WEB-INF/include/init.inc" %>
<% int extra_id=3; useZapatec=false; %>
<%@ include file="/WEB-INF/include/extra.inc" %>
<%@ include file="/WEB-INF/include/header.jhtml" %>
<%
  // warn if Image Rotator is being used for header background
  if (Setting.getBoolean(application, "header_image_rotator")) pageTitle += " - USED IN HEADER";
%>
<%@ include file="/WEB-INF/include/subheader.jhtml" %>
<%
  try {
    
    // this will throw exception if not image upload
    MultipartRequest mpr = new MultipartRequest(request, imageDir, maxUploadSize);
    
    // get the uploaded file
    File file = mpr.getFile("imagefile");
    if (file==null) {
      error = "You have not selected an image.  Browse for an image on your computer and upload again.";
    } else {
      // get the num and caption
      int num = 0;
      if (mpr.getParameter("num")!=null && mpr.getParameter("num").length()>0) num = Integer.parseInt(mpr.getParameter("num"));
      String caption = mpr.getParameter("caption");
      String alt = mpr.getParameter("alt");
      String url = mpr.getParameter("url");
      if (num==0) {
        error = "You must enter a sequence number for the image.";
      } else {
        // remove blanks from file name
        String filename = file.getName();
        filename = filename.replace(' ', '_');
        File imageFile = new File(imageDir+filename);
        if (!file.renameTo(imageFile)) {
          error = "Error renaming "+file.getAbsolutePath()+" to "+imageFile.getAbsolutePath();
        } else {
          // get image size using Marco Schmidt's ImageInfo
          ImageInfo ii = new ImageInfo();
          ii.setInput(new FileInputStream(imageFile));
          if (ii.check() && (ii.getFormat()==ii.FORMAT_JPEG || ii.getFormat()==ii.FORMAT_GIF || ii.getFormat()==ii.FORMAT_PNG || ii.getFormat()==ii.FORMAT_BMP)) {
            int width = ii.getWidth();
            int height = ii.getHeight();
            ImageRotator ir = new ImageRotator();
            ir.filename = filename;
            ir.num = num;
            ir.width = width;
            ir.height = height;
            ir.caption = caption;
            ir.alt = alt;
            ir.url = url;
            ir.insert(request);
            message = "Image <b>"+filename+"</b> added to rotation sequence at number <b>"+num+"</b>.";
          } else {
            error = "File types for images must be JPEG, GIF, BMP or PNG.";
          }
        }
      }
    }
    
  } catch (Exception ex) {
    
    // set error message if isn't simply because not a multipart request
    if (!ex.getMessage().equals("Posted content type isn't multipart/form-data")) error = ex.getMessage();
    
    // get the id for a remove
    if (request.getParameter("id")!=null) {
      int id = Integer.parseInt(request.getParameter("id"));
      ImageRotator ir = new ImageRotator(application,id);
      if (request.getParameter("update")!=null) {
        ir.num = Integer.parseInt(request.getParameter("num"));
        ir.caption = request.getParameter("caption");
        ir.alt = request.getParameter("alt");
        ir.url = request.getParameter("url");
        ir.update(request);
        message = "Sequence number, caption, alt text and URL updated for <b>"+ir.filename+"</b>.";
      } else if (request.getParameter("remove")!=null) {
        if (request.getParameter("confirmed")!=null) {
          String filename = ir.filename;
          ir.delete(request);
          message = "Image <b>"+filename+"</b> deleted from rotation sequence.";
        } else {
          error = "You must check the box to confirm image removal.";
        }
      }
    }
    
  }

  // get array of all images
  ImageRotator images[] = ImageRotator.getAll(application);
%>
<%@ include file="/WEB-INF/include/errormessage.jhtml" %>
<b>/imagerotator.jsp</b>
<hr/>
<%
  int num = 0;
  for (int i=0; i<images.length; i++) {
      num = images[i].num;
  %>
  <form method="post">
    <input type="hidden" name="id" value="<%=images[i].id%>"/>
    <table>
      <tr>
        <td valign="top">
          <table>
            <tr>
              <td><input type="text" size="2" name="num" value="<%=num%>"/></td>
            </tr>
            <tr>
              <td>caption<br/><textarea name="caption" rows="1" cols="48"><%=Util.blankIfNull(images[i].caption)%></textarea></td>
            </tr>
            <tr>
              <td>alt text<br/><textarea name="alt" rows="1" cols="48"><%=Util.blankIfNull(images[i].alt)%></textarea></td>
            </tr>
            <tr>
              <td>URL<br/><input type="text"  name="url" size="48" value="<%=Util.blankIfNull(images[i].url)%>"/></td>
            </tr>
            <tr>
              <td align="center">
                <input type="submit" class="update" name="update" value="Update"/>
                <input type="checkbox" name="confirmed" value="true"/>
                <input type="submit" class="delete" name="remove" value="Remove"/>
              </td>
            </tr>
          </table>
        </td>
        <td valign="top" align="center">
          <img src="<%=imageFolder%>/<%=images[i].filename%>" width="<%=images[i].width%>" height="<%=images[i].height%>" border="1"/><br/>
          <%=images[i].filename%> (<%=images[i].width%>&times;<%=images[i].height%>)
        </td>
      </tr>
    </table>
  </form>
  <hr/>
  <%
  }
  %>
  <form method="post" enctype="multipart/form-data">
    <table>
      <tr>
        <td><input type="text" size="2" name="num" value="<%=num+1%>"/></td>
      </tr>
      <tr>
        <td>caption<br/><textarea name="caption" rows="1" cols="48"></textarea></td>
      </tr>
      <tr>
        <td>alt text<br/><textarea name="alt" rows="1" cols="48"></textarea></td>
      </tr>
      <tr>
        <td>URL<br/><input type="text" name="url" size="48"/></td>
      </tr>
      <tr>
        <td>image file<br/><input type="file" size="40" name="imagefile"/></td>
      </tr>
      <tr>
        <td align="center"><input type="submit" class="uploadimage" name="upload" value="Upload Image"/></td>
      </tr>
    </table>
  </form>
<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/footer.jhtml" %>
