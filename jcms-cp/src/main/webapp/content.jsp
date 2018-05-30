<%@ include file="/WEB-INF/include/init.inc" %>
<% pageTitle = "Content Editor"; useZapatec=false; %>
<%@ include file="/WEB-INF/include/plainheader.jhtml" %>
<script type="text/javascript">
    function setPageLabel(plabel) {
    update.label.value = plabel;
  }
</script>
<%
// constants
int playerControlHeight = 19; // height of video player controls to add to total SWF height
  
// initialize, since there are two types of posts to deal with
Content content = new Content();
Page p = new Page();
  
// upload updates
MultipartRequest mpr = null;
try {
    
  // this will throw exception if not multipart request
  mpr = new MultipartRequest(request, imageDir, maxUploadSize);

  // get the content
  content = new Content(application, Util.getInt(mpr,"cid"));

  // PDF, image or video or Flash?
  boolean pdfFile = Util.getString(mpr,"mediatype").equals("pdf");
  boolean imageFile = Util.getString(mpr,"mediatype").equals("image");
  boolean videoFile = Util.getString(mpr,"mediatype").equals("video");
  boolean audioFile = Util.getString(mpr,"mediatype").equals("audio");
  boolean flashFile = Util.getString(mpr,"mediatype").equals("flash");
  boolean htmlAudioFile = Util.getString(mpr,"mediatype").equals("htmlaudio");
  boolean htmlVideoFile = Util.getString(mpr,"mediatype").equals("htmlvideo");

  // upload/add logic
  boolean addFile = mpr.getParameter("addfile")!=null;
  boolean uploadFile = mpr.getParameter("uploadfile")!=null;
    
  boolean success = false;
  String verb = "";
  File savedFile = null;
  if (addFile) {
    String addfilename = Util.getString(mpr, "addfilename");
    if (addfilename.length()>0) {
      savedFile = new File(imageDir+addfilename);
      verb = " added ";
      success = true; // found existing file
    } else {
      error = "Please select an existing file to add to this content.";
    }
  } else if (uploadFile) {
    File uploadedFile = mpr.getFile("uploadfilename");
    if (uploadedFile==null) {
      error = "You have not selected a file to upload.  Browse for an image, audio, video or Flash file on your computer and upload again.";
    } else {
      String fileName = uploadedFile.getName();
      fileName = fileName.replace('#','-');  // # character causes problems with JW Player, URI encoded or not
      savedFile = new File(imageDir+fileName);
      if (!uploadedFile.renameTo(savedFile)) {
	error = "Error renaming "+uploadedFile.getAbsolutePath()+" to "+savedFile.getAbsolutePath();
      } else {
	verb = " uploaded ";
	success = true; // upload successful
      }
    }
  }

  if (success) {

    // form RFC 2396 URI from filename, used for links
    java.net.URI fileURI = new java.net.URI(null, savedFile.getName(), null);

    if (imageFile) {
      // get image size using Marco Schmidt's ImageInfo
      ImageInfo ii = new ImageInfo();
      ii.setInput(new FileInputStream(savedFile));
      if (ii.check() && (ii.getFormat()==ii.FORMAT_JPEG || ii.getFormat()==ii.FORMAT_GIF || ii.getFormat()==ii.FORMAT_PNG || ii.getFormat()==ii.FORMAT_BMP)) {
	int imagewidth = ii.getWidth();
	int imageheight = ii.getHeight();
	// update the content record
	if (content.copy==null) content.copy = "";
	content.copy += "\n\n";
	content.copy += "<!-- image file "+savedFile.getName()+verb+sdf.format(new java.util.Date())+" -->\n";
	content.copy += "<img src=\""+imageFolder+"/"+fileURI.toString()+"\" width=\""+imagewidth+"\" height=\""+imageheight+"\" border=\"0\" alt=\"\"/>\n";
	content.update(request);
	message = "Image <b>"+savedFile.getName()+"</b> uploaded to content item <b>["+content.cid+"]</b>.";
	error = "  ";
      } else {
	error = "File types for images must be JPEG, GIF, BMP or PNG.";
      }
    } else if (videoFile) {
      // valid width and height must be supplied
      try {
	// get the width, height - throws NumberFormatException if not kosher
	int width = Util.getInt(mpr,"width");
	int height = Util.getInt(mpr,"height") + playerControlHeight; // add height for controls
	// generate a unique div label
	String divId = "v"+(new Date()).getTime();
	// update the content record
	if (content.copy==null) content.copy = "";
	content.copy += "\n\n";
	content.copy += "<!-- video file "+savedFile.getName()+verb+sdf.format(new java.util.Date())+" -->\n";
	content.copy += "<!-- "+playerControlHeight+"px added to height for video player controls -->\n";
	content.copy += "<div id=\""+divId+"\"><a href=\"http://www.macromedia.com/go/getflashplayer\">Get the Flash Player</a> to see this player.</div>\n";
	content.copy += "<script type=\"text/javascript\">\n";
	content.copy += "  var flashvars = {\n";
	content.copy += "    file: \""+imageFolder+"/"+fileURI.toString()+"\"\n";
	content.copy += "  }\n";
	content.copy += "  var params = {\n";
	content.copy += "    allowfullscreen: \"true\",\n";
	content.copy += "    allowscriptaccess: \"always\",\n";
	content.copy += "    wmode: \"opaque\"\n";
	content.copy += "  }\n";
	content.copy += "  swfobject.embedSWF(\"/player.swf\", \""+divId+"\", \""+width+"\", \""+height+"\", \"9.0.98\", \"/expressInstall.swf\", flashvars, params);\n";
	content.copy += "</script>\n";
	content.copy += "<!-- end generated video embedding code -->\n";
	content.update(request);
	message = "Video <b>"+savedFile.getName()+"</b> uploaded and embedded at the bottom of content item <b>["+content.cid+"]</b>.";
	error = "  ";
      } catch (NumberFormatException nex) {
	error = "Valid video width and height must be supplied.  Please upload your video again, supplying the width and height.";
      }
    } else if (audioFile) {
      // generate a unique div label
      String divId = "a"+(new Date()).getTime();
      // update the content record
      if (content.copy==null) content.copy = "";
      content.copy += "\n\n";
      content.copy += "<!-- audio file "+savedFile.getName()+verb+sdf.format(new java.util.Date())+" -->\n";
      content.copy += "<div id=\""+divId+"\"><a href=\"http://www.macromedia.com/go/getflashplayer\">Get the Flash Player</a> to see this player.</div>\n";
      content.copy += "<script type=\"text/javascript\">\n";
      content.copy += "  var flashvars = {\n";
      content.copy += "    file: \""+imageFolder+"/"+fileURI.toString()+"\",\n";
      content.copy += "    icons:\"false\"\n";
      content.copy += "  }\n";
      content.copy += "  var params = {\n";
      content.copy += "    allowfullscreen: \"false\",\n";
      content.copy += "    allowscriptaccess: \"always\",\n";
      content.copy += "    wmode: \"opaque\"\n";
      content.copy += "  }\n";
      content.copy += "  swfobject.embedSWF(\"/player.swf\", \""+divId+"\", \"300\", \"20\", \"9.0.98\", \"/expressInstall.swf\", flashvars, params);\n";
      content.copy += "</script>\n";
      content.copy += "<!-- end generated audio embedding code -->\n";
      content.update(request);
      message = "Audio <b>"+savedFile.getName()+"</b> uploaded and embedded at the bottom of content item <b>["+content.cid+"]</b>.";
      error = "  ";
    } else if (flashFile) {
      try {
	// get the width, height - throws NumberFormatException if not kosher
	int width = Util.getInt(mpr,"width");
	int height = Util.getInt(mpr,"height");
	// generate a unique div label
	String divId = "f"+(new Date()).getTime();
	// update the content record
	if (content.copy==null) content.copy = "";
	content.copy += "\n\n";
	content.copy += "<!-- Flash file "+savedFile.getName()+verb+sdf.format(new java.util.Date())+" -->\n";
	content.copy += "<div id=\""+divId+"\"><a href=\"http://www.macromedia.com/go/getflashplayer\">Get the Flash Player</a> to see this movie.</div>\n";
	content.copy += "<script type=\"text/javascript\">\n";
	content.copy += "  var flashvars = {}\n";
	content.copy += "  var params = {}\n";
	content.copy += "  swfobject.embedSWF(\""+imageFolder+"/"+fileURI.toString()+"\", \""+divId+"\", \""+width+"\", \""+height+"\", \"9.0.98\", \"/expressInstall.swf\", flashvars, params);\n";
	content.copy += "</script>\n";
	content.copy += "<!-- end generated Flash embedding code -->\n";
	content.update(request);
	message = "Flash file <b>"+savedFile.getName()+"</b> uploaded and embedded at the bottom of content item <b>["+content.cid+"]</b>.";
	error = "  ";
      } catch (NumberFormatException nex) {
	error = "Valid Flash width and height must be supplied.  Please upload your Flash file again, supplying the width and height.";
      }
    } else if (htmlAudioFile) {
      // update the content record
      if (content.copy==null) content.copy = "";
      content.copy += "\n\n";
      content.copy += "<!-- audio file "+savedFile.getName()+verb+sdf.format(new java.util.Date())+" -->\n";
      content.copy += "<audio src=\""+imageFolder+"/"+fileURI.toString()+"\" controls>\n";
      content.copy += "  Your browser does not support the <code>audio</code> element.\n";
      content.copy += "</audio>\n";
      content.update(request);
      message = "Audio file <b>"+savedFile.getName()+"</b> uploaded and placed in an &lt;audio&gt; tag at the bottom of content item <b>["+content.cid+"]</b>.";
      error = "  ";
    } else if (htmlVideoFile) {
      // update the content record
      if (content.copy==null) content.copy = "";
      content.copy += "\n\n";
      content.copy += "<!-- video file "+savedFile.getName()+verb+sdf.format(new java.util.Date())+" -->\n";
      content.copy += "<video src=\""+imageFolder+"/"+fileURI.toString()+"\" controls>\n";
      content.copy += "  Your browser does not support the <code>video</code> element.\n";
      content.copy += "</video>\n";
      content.update(request);
      message = "Video file <b>"+savedFile.getName()+"</b> uploaded and placed in a &lt;video&gt; tag at the bottom of content item <b>["+content.cid+"]</b>.";
      error = "  ";
    } else if (pdfFile) {
      // update the content record
      if (content.copy==null) content.copy = "";
      content.copy += "\n\n";
      content.copy += "<!-- PDF file "+savedFile.getName()+verb+sdf.format(new java.util.Date())+" -->\n";
      content.copy += "<a href=\""+imageFolder+"/"+fileURI.toString()+"\">"+savedFile.getName()+"</a>\n";
      content.update(request);
      message = "PDF file <b>"+savedFile.getName()+"</b> uploaded and linked at the bottom of content item <b>["+content.cid+"]</b>.";
      error = "  ";
    } else {
      error = "Please indicate which type of file is being uploaded: PDF, image, audio, etc.";
    }
  }
  
} catch (Exception ex) {
  
  // set error message if isn't simply because not a multipart request
  if (!ex.getMessage().equals("Posted content type isn't multipart/form-data")) error = ex.toString();
  // explain a bit more on oversize uploads
  if (error!=null && error.indexOf("java.io.IOException: Posted content length")>-1) error = error.substring(20)+".  An admin can increase the file upload size limit setting: <b>site_maxuploadsize</b>.";
  
}

// get other posted variables
if (mpr==null) {
  content = new Content(application, Util.getInt(request,"cid"));
} else {
  content = new Content(application, Util.getInt(mpr,"cid"));
}

// page label import is handy, show if pid supplied
p = new Page(application, Util.getInt(request,"pid"));

// non-upload updates
try {
  
  if (request.getParameter("update")!=null) {
    content.label = Util.getString(request,"label");
    content.moduleurl = Util.getString(request,"moduleurl");
    if (content.moduleurl==null || content.moduleurl.trim().length()==0) {
      content.moduleurl = null;
      content.modulecontext = null;
    } else {
      content.modulecontext = Util.getString(request,"modulecontext");
      if (content.modulecontext==null || content.modulecontext.trim().length()==0) content.modulecontext = "/"; // default extra
    }
    content.moduleabove = Util.getBoolean(request,"moduleabove");
    content.copy = Util.getString(request,"copy");
    debugMessage = content.copy;
    content.update(request);
  message = "Content <b>["+content.cid+"]</b> updated.";
  error = "  ";
  }
  
  if (request.getParameter("clear")!=null) {
    boolean confirmed = Util.getBoolean(request,"confirmed");
    if (confirmed) {
      content.copy = null;
      debugMessage = content.copy;
      content.update(request);
      message = "Content <b>["+content.cid+"]</b> cleared.";
      error = "  ";
    } else {
      error = "You must check the box to confirm clearing content <b>"+content.cid+"</b>.  Please try again.";
    }
  }
  
} catch (org.postgresql.util.PSQLException e) {
  error = e.getMessage();
}

// cache permission in a boolean var
boolean userCanEdit = cpuser.hasPermission(application, content);

if (!content.isDefault() && message==null) message = "Content <b>["+content.cid+"]</b> selected.";

if (!content.isDefault() && !userCanEdit && error==null) error = "You do not have permission to edit this content item.";
%>
  
  <%@ include file="/WEB-INF/include/errormessage-js.jhtml" %>

  <% if (!content.isDefault()) { %>
  
  <div class="audit">
    <div style="float:right;"><% if (content.updated!=null) { %>updated <%=sdf.format(content.updated)%><% } %> created <%=sdf.format(content.created)%></div>
    Content <b>[<%=content.cid%>]</b>
    <br/>
    Pages: 
    <%
      if (content.isOrphan(application)) {
        out.print("ORPHAN");
      } else {
        Page[] pages = content.getPages(application);
        for (int i=0; i<pages.length; i++) {
      %>
      <a class="editpage" target="_top" href="page.jsp?pid=<%=pages[i].pid%>"><%=pages[i].pid%></a>
      <%
      } // for
    } // pages
      %>
      <hr/>
  </div>
  
  <%
    if (userCanEdit) {


      if (enableWysiwyg) {
        Stylesheet[] rootClasses = Stylesheet.getAll(application,0,0,0);
        String bodyClass = rootClasses[0].value;
        String fontFamily = "";
        String fontSize = "";
        try {
          // extract font-family and font-size;
          int i = bodyClass.indexOf("font-family:");
          int j = bodyClass.indexOf(";", i);
          fontFamily = bodyClass.substring(i,j);
          i = bodyClass.indexOf("font-size:");
          j = bodyClass.indexOf(";", i);
          fontSize = bodyClass.substring(i,j);
        } catch (Exception ex) {
          // apply defaults
          fontFamily = "sans-serif";
          fontSize = "12px";
        }
  %>
  <script type="text/javascript">
      _editor_url = "xinha/";
      _editor_lang = "en";
  </script>
  <script type="text/javascript" src="xinha/XinhaCore.js"></script>
  <script type="text/javascript">
      var editor = null;
      function initXinha() {
        var config = new Xinha.Config();
        config.pageStyle = 'body { <%=fontFamily%>; <%=fontSize%>; }';
        config.stripScripts = false;
        config.browserQuirksMode = false;
        config.toolbar =
        [
        ["undo","redo"], (Xinha.is_gecko ? [] : ["cut","copy","paste","overwrite"]),
        ["separator","bold","italic","underline","strikethrough"],
        ["separator","subscript","superscript"],
        ["linebreak","separator","justifyleft","justifycenter","justifyright","justifyfull"],
        ["separator","insertorderedlist","insertunorderedlist","outdent","indent"],
        ["separator","inserthorizontalrule","createlink","insertimage"],
        ["separator","inserttable","toggleborders","lefttoright", "righttoleft"],
        ["separator","killword","clearfonts","removeformat"],
        ["separator","htmlmode","showhelp","about"]
        ];
        editor = Xinha.makeEditors(['content'], config);
        Xinha.startEditors(editor);
      }
      window.onload = initXinha;
  </script>
  <%
  } // enableWysiwyg
  %>

  <form name="update" action="content.jsp" method="post">
    <input type="hidden" name="cid" value="<%=content.cid%>"/>
    <input type="hidden" name="pid" value="<%=p.pid%>"/>
    Content Label  &nbsp;&nbsp;&nbsp;&nbsp; <% if (!p.isDefault()) { %><a href="javascript:setPageLabel('<%=p.label%>')">use page label</a><% } %><br/>
    <input type="text" size="80" name="label" value="<%=Util.blankIfNull(content.label)%>"/>
    <!-- the all-important textarea! -->
    <textarea id="content" name="copy"><%=Util.blankIfNull(content.copy)%></textarea>
    <table align="center"> 
      <tr>
        <td>extension context:<br/><input type="text" size="24" name="modulecontext" value="<%=Util.blankIfNull(content.modulecontext)%>" /></td>
        <td>extension URL:<br/><input type="text" size="48" name="moduleurl" value="<%=Util.blankIfNull(content.moduleurl)%>" /></td>
        <td valign="bottom">
          <input class="radio" type="radio" name="moduleabove" <% if (content.moduleabove) out.print("checked"); %> value="true"/>extension at top<br/>
            <input class="radio" type="radio" name="moduleabove" <% if (!content.moduleabove) out.print("checked"); %>  value="false"/>extension at bottom
        </td>
      </tr>
      <tr>
        <td colspan="3" align="center">
          <input type="submit" class="update" name="update" value="Update Content"/>
          <input class="checkbox" type="checkbox" name="confirmed" value="true"/>
          <input type="submit" class="delete" name="clear" value="Clear Content"/>
        </td>
      </tr>
    </table>
  </form>

  <form class="upload" name="upload" action="content.jsp" method="post" enctype="multipart/form-data" align="center" onSubmit="return checkupload()">
    <input type="hidden" name="cid" value="<%=content.cid%>"/>
    <input type="hidden" name="pid" value="<%=p.pid%>"/>
    <div align="center">
      <input type="radio" class="radio" name="mediatype" value="pdf"/> PDF
      <input type="radio" class="radio" name="mediatype" value="image" checked/> image (jpg/png/gif)
      <input type="radio" class="radio" name="mediatype" value="audio"/> audio (mp3)
      <input type="radio" class="radio" name="mediatype" value="htmlaudio"/> &lt;audio&gt;
      <input type="radio" class="radio" name="mediatype" value="htmlvideo"/> &lt;video&gt;
      &nbsp;&nbsp; | &nbsp;&nbsp;
      <input type="radio" class="radio" name="mediatype" value="video"/> video (flv/mp4)
      <input type="radio" class="radio" name="mediatype" value="flash"/> Flash (swf)
      video/Flash: width <input type="text" size="3" name="width"/> height <input type="text" size="3" name="height"/>
      <br/>
      <input type="file" size="120" name="uploadfilename"/>
      <input type="submit" class="uploadimage" name="uploadfile" value="Upload File"/>
      |
      <select name="addfilename">
        <option value="">--- select existing file ---</option>
        <%
          File[] files = Util.getUploadedFiles(application);
          for (int i=0; i<files.length; i++) { %>
          <option value="<%=files[i].getName()%>"><%=files[i].getName()%></option>
          <% } %>
      </select>
      <input type="submit" class="uploadimage" name="addfile" value="Add Existing File"/>
    </div>
  </form>

  <%
  } else {

    // preview content using layout 1, pane 1 styling
    int layout_id = 1;
    int pane = 1;
  %>
    <%@ include file="/WEB-INF/include/content-preview.jhtml" %>
  <%
  } // userCanEdit
  
  } // content.isDefault
  %>
    
<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/plainfooter.jhtml" %>
