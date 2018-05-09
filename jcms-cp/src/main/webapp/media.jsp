<%@ include file="/WEB-INF/include/init.inc" %>
<% pageTitle="Media Uploader"; useZapatec=true; docUrl="doc-media.jsp"; %>
<%@ include file="/WEB-INF/include/header.jhtml" %>
<%@ include file="/WEB-INF/include/subheader.jhtml" %>
<script type="text/javascript">

    /**
    * open the access window, Zapatec
    */
    function openAccessWindow(mid) {
      var swin = Zapatec.Window.setup({
        theme: 'plain',
        left: 200,
        top: 0,
        width: 400,
        height: 500,
        showMaxButton: false,
        showMinButton: false,
        onClose : function() {swin = null;},
        urlContent : 'access-media.jsp?mid='+mid
      });
      swin.show();
    }

</script>
<%

  // get selected media id
  int mid = 0;
  if (request.getParameter("mid")!=null) mid = Integer.parseInt(request.getParameter("mid"));
    
  // get default access role
  AccessRole defaultRole = Util.getDefaultAccessRole(application);

  try {

    // this will throw exception if not media upload
    MultipartRequest mpr = new MultipartRequest(request, mediaDir, maxUploadSize);
    
    // get the uploaded file
    File file = mpr.getFile("mediafile");

    // get the mid if it exists
    if (mpr.getParameter("mid")!=null) mid = Integer.parseInt(mpr.getParameter("mid"));
    
    // get file info
    if (file==null) {
      error = "You have not selected a media file.  Browse for a file on your computer and upload again.";
    } else {
      long filesize = file.length();
      // remove blanks from file name
      String filename = file.getName();
      filename = filename.replace(' ', '_');
      File mediafile = new File(mediaDir+filename);
      if (!file.renameTo(mediafile)) {
        error = "Error renaming "+file.getAbsolutePath()+" to "+mediafile.getAbsolutePath();
      } else {
        if (mid==0) {
          // insert new record
          Media media = new Media();
          media.filename = filename;
          media.filesize = filesize;
          media.insert(request);
          mid = media.mid;
          message = "Media file <b>"+filename+"</b> uploaded.";
        } else {
          // update existing media record
          Media media = new Media(application, mid);
          media.filename = filename;
          media.filesize = filesize;
          media.update(request);
          message = "Media file <b>"+filename+"</b> updated.";
        }
      }
    }
    
  } catch (Exception ex) {
    
    // set error message if isn't simply because not a multipart request
    if (!ex.getMessage().equals("Posted content type isn't multipart/form-data")) error = ex.getMessage();
    
  }

  try {
  
    // delete a media file
    if (request.getParameter("delete")!=null) {
      mid = Integer.parseInt(request.getParameter("mid"));
      boolean confirmed = (request.getParameter("confirmed")!=null);
      if (confirmed) {
        Media media = new Media(application, mid);
        String filename = media.filename;
        // delete media record
        media.delete(request);
        // delete actual file
        File mediafile = new File(mediaDir+filename);
        boolean deleted = mediafile.delete();
        if (deleted) {
          message = "Media file <b>"+filename+"</b> deleted.";
          mid = 0;
        } else {
          message = "Media record for <b>"+filename+"</b> removed; error deleting actual file, it may already be gone.";
          mid = 0;
        }
      } else {
        error = "You must check the box to confirm file deletion.";
      }
    }
    
    // update access
    if (request.getParameter("accessupdate")!=null) {
      mid = Integer.parseInt(request.getParameter("mid"));
      Media media = new Media(application, mid);
      String[] accessroles = request.getParameterValues("accessrole");
      // first, make media public
      defaultRole.grantAccess(session, media);
      if (accessroles==null) {
        message = "Media <b>"+media.filename+"</b> is available to the public.";
      } else {
        // grant access to desired roles
        for (int i=0; i<accessroles.length; i++) {
          AccessRole ar = defaultRole.getAccessRole(application, accessroles[i]);
          ar.grantAccess(session, media);
        }
        message = "Access to media <b>"+media.filename+"</b> is restricted to the selected access roles.";
      }
    }

  } catch (Exception ex) {

    error = ex.getMessage();

  }

    // load the media selector array
    Media[] media = null;
    String searchterm = Util.blankIfNull(request.getParameter("searchterm"));
    if (request.getParameter("clear")!=null) searchterm = "";
    if (searchterm.length()>0) {
      media = Media.getMatching(application, searchterm);
    } else {
      media = Media.getAll(application);
    }
%>

  <%@ include file="/WEB-INF/include/errormessage.jhtml" %>
  
  <form action="media.jsp" method="post" enctype="multipart/form-data">
    <table>
      <tr>
        <td><input type="file" size="120" name="mediafile" /></td>
        <td><input type="submit" class="insert" name="upload" value="Upload New Media" /></td>
      </tr>
    </table>
  </form>

  <form action="media.jsp" method="post">
    <table>
      <tr>
        <td>
          <select name="mid" onChange="submit()">
            <option value="0">--- select media ---</option>
              <% for (int i=0; i<media.length; i++) { %>
                <option <% if (mid==media[i].mid) out.print("selected"); %> value="<%=media[i].mid%>"><%=media[i].filename%> [<%=sdf.format(media[i].created)%>]</option>
              <% } %>
          </select>
        </td>
        <td>
          <input type="text" size="32" name="searchterm" value="<%=searchterm%>"/>
          <input type="submit" class="update" name="filter" value="Filter"/>
          <input type="submit" name="clear" value="Clear"/>
        </td>
      </tr>
    </table>
  </form>
  
  <%
    if (mid!=0) {
      Media m = new Media(application, mid);
      Node[] currentNodes = m.getCurrentNodes(application);
      Node[] futureNodes = m.getFutureNodes(application);
  %>
  <table>
    <tr>
      <td colspan="6">
        Nodes (<span class="active">current;</span> future):
          <% if (currentNodes.length==0 && futureNodes.length==0) { %>
        NONE
        <% } else { %>
        <span class="active"><% for (int i=0; i<currentNodes.length; i++) out.print(" "+currentNodes[i].label); %>;</span>
          <% for (int i=0; i<futureNodes.length; i++) out.print(" "+futureNodes[i].label); %>
          <% } %>
      </td>
    </tr>
    <tr>
      <td align="right" class="borders"><b>ID</b></td>
      <td class="borders"><b>File URL</b></td>
      <td align="right" class="borders"><b>Size (bytes)</b></td>
      <td class="borders"><b>Created</b></td>
      <td class="borders"><b>Updated</b></td>
      <td class="borders"><b>Restricted</b></td>
      <td class="borders"></td>
    </tr>
    <tr>
      <td align="right"><b><%=m.mid%></b></td>
      <td><a target="_blank" href="<%=mediaFolder%>/<%=m.filename%>"><b><%=mediaFolder%>/<%=m.filename%></b></a></td>
      <td align="right"><%=m.filesize%></td>
      <td><%=sdf.format(m.created)%></td>
      <td><% if (m.updated!=null) out.print(sdf.format(m.updated)); %></td>
      <td align="center"><a class="editpage" href="javascript:openAccessWindow(<%=m.mid%>)"><% if (defaultRole.mayAccess(application, m)) out.print("N"); else out.print("Y"); %></a></td>
    </tr>
    <tr>
      <td colspan="6" align="right" class="borders">
        <form action="media.jsp" method="post" enctype="multipart/form-data">
          <input type="hidden" name="mid" value="<%=m.mid%>" />
          <input type="file" size="80" name="mediafile" />
          <input type="submit" class="update" name="update" value="Update" />
        </form>
      </td>
      <td class="borders">
        <form action="media.jsp" method="post">
          <input type="hidden" name="mid" value="<%=m.mid%>" />
          <% if (cpuser.hasPermission(application,m)) { %>
          <input type="checkbox" name="confirmed" value="true" />
          <input type="submit" class="delete" name="delete" value="Delete" />
          <% } %>
        </form>
      </td>
    </tr>
  </table>
  <%
  }
  %>
    <%@ include file="/WEB-INF/include/close.inc" %>
    <%@ include file="/WEB-INF/include/footer.jhtml" %>

