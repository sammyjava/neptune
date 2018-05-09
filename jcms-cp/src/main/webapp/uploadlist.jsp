<%@ include file="/WEB-INF/include/init.inc" %>
<%
  pageTitle = "Uploaded Files"; pageHeading = "<a href=\"contenteditor.jsp\">Content Editor</a> | Uploaded Files | <a href=\"content-purge.jsp\">Orphaned Content</a>";
  docUrl="doc-uploadlist.jsp";
%>
<%@ include file="/WEB-INF/include/header.jhtml" %>
<%@ include file="/WEB-INF/include/subheader.jhtml" %>
<%
  // delete a file
  if (request.getParameter("delete")!=null) {
    if (request.getParameter("confirmed")!=null) {
      String filename = request.getParameter("filename");
      File file = new File(imageDir+File.separatorChar+filename);
      if (file.delete()) {
        message = "File <b>"+filename+"</b> deleted from filesystem.";
      } else {
        error = "Error deleting <b>"+filename+"</b>.";
      }
    } else {
      error = "You must check the box to confirm file deletion.";
    }
  }
%>
<%@ include file="/WEB-INF/include/errormessage.jhtml" %>
<table cellspacing="0">
  <tr>
    <td width="500"><b>Filename</b></td>
    <td width="50" align="right"><b>Size</b></td>
    <td width="200" align="right"><b>Last Uploaded</b></td>
  </tr>
</table>
<%
  // get directory listing
  File[] files = Util.getUploadedFiles(application);
  String bgcolor = "";
  for (int i=0; i<files.length; i++) {
      String url = "";
      boolean goodURI = false;
      try {
        java.net.URI fileURI = new java.net.URI(null, files[i].getName(), null);
        url = imageFolder+"/"+fileURI.toString();
        if (bgcolor.equals("white")) {
          bgcolor = "#E0E0E0";
        } else {
          bgcolor = "white";
        }
        goodURI = true;
      } catch (java.net.URISyntaxException ex) {
        url = imageFolder+"/"+files[i].getName();
      }
    %>
    <form action="uploadlist.jsp" method="post">
      <input type="hidden" name="filename" value="<%=files[i].getName()%>" />
      <table cellspacing="0" bgcolor="<%=bgcolor%>">
        <tr>
          <td width="500"><a target="_blank" href="<%=url%>"><%=imageFolder%>/<%=files[i].getName()%></a><% if (!goodURI) out.print(" <-- contains bad chars"); %></td>
          <td width="50" align="right"><%=files[i].length()%></td>
          <td width="200" align="right"><%=new Date(files[i].lastModified())%></td>
          <td><input type="checkbox" name="confirmed" value="true" /></td>
          <td><input type="submit" class="delete" name="delete" value="Delete"/></td>
        </tr>
      </table>
  </form>
  <%
  }
  %>
<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/footer.jhtml" %>

