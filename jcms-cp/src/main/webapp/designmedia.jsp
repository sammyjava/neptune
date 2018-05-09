<%@ include file="/WEB-INF/include/init.inc" %>
<% pageTitle = "Design Media Uploader"; docUrl="doc-designmedia.jsp"; %>
<%@ include file="/WEB-INF/include/header.jhtml" %>
<%@ include file="/WEB-INF/include/subheader.jhtml" %>
<%

try {
    
  // this will throw exception if not design upload
  MultipartRequest mpr = new MultipartRequest(request, designDir, maxUploadSize);
  
  // get the uploaded file
  File file = mpr.getFile("designfile");
  
  // get file info
  if (file==null) {
    error = "You have not selected a design file.  Browse for a file on your computer and upload again.";
  } else {
    // remove blanks from file name
    String filename = file.getName();
    filename = filename.replace(' ', '_');
    File designfile = new File(designDir+File.separatorChar+filename);
    if (file.renameTo(designfile)) {
      message = "File <b>"+designFolder+"/"+filename+"</b> uploaded.";
    } else {
      error = "Error renaming <b>"+file.getAbsolutePath()+"</b> to <b>"+designfile.getAbsolutePath()+"</b>.";
    }
  }
  
} catch (Exception ex) {
  
  // set error message if isn't simply because not a multipart request
  if (!ex.getMessage().equals("Posted content type isn't multipart/form-data")) error = ex.getMessage();
  
}

// delete a file
if (request.getParameter("delete")!=null) {
  if (request.getParameter("confirmed")!=null) {
    String filename = request.getParameter("filename");
    File file = new File(designDir+File.separatorChar+filename);
    if (file.delete()) {
      message = "File <b>"+filename+"</b> deleted from filesystem.";
    } else {
      error = "Error deleting <b>"+filename+"</b>.";
    }
  } else {
    error = "You must check the box to confirm file deletion.";
  }
}

// get directory listing
File dir = new File(designDir);
File[] files = dir.listFiles();

// sort files alphabetically
TreeSet sortedList = new TreeSet();
for (int i=0; i<files.length; i++) sortedList.add(files[i]);
Iterator listIterator = sortedList.iterator();

%>
<%@ include file="/WEB-INF/include/errormessage.jhtml" %>

<form action="designmedia.jsp" method="post" enctype="multipart/form-data">
  <input type="file" size="80" name="designfile" />
  <input type="submit" class="insert" name="upload" value="Upload" />
</form>

<br/>

  <table cellspacing="0">
    <tr>
      <td width="500">file</td>
      <td>updated</td>
      <td align="right">size (bytes)</td>
    </tr>
    <%
      String bgcolor = "white";
      while (listIterator.hasNext()) {
        File file = (File) listIterator.next();
        String url = designFolder+"/"+file.getName();
        if (bgcolor.equals("white")) {
          bgcolor = "#E0E0E0";
        } else {
          bgcolor = "white";
        }
    %>
    <tr>
      <td bgcolor="<%=bgcolor%>"><a target="_blank" href="<%=url%>"><%=url%></a></td>
      <td bgcolor="<%=bgcolor%>"><%=new Date(file.lastModified())%></td>
      <td bgcolor="<%=bgcolor%>" align="right"><%=file.length()%></td>
      <td bgcolor="<%=bgcolor%>">
        <form action="designmedia.jsp" method="post">
          <input type="hidden" name="filename" value="<%=file.getName()%>" />
          <input type="checkbox" name="confirmed" value="true" />
          <input type="submit" class="delete" name="delete" value="Delete" />
        </form>
      </td>
    </tr>
    <%
    }
    %>
  </table>
    
<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/footer.jhtml" %>

