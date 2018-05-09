<%@ include file="/WEB-INF/include/init.inc" %>
<%@ page import="java.io.BufferedReader,java.io.FileReader" %>
<% int extra_id=6; useZapatec=false; %>
<%@ include file="/WEB-INF/include/header.jhtml" %>
<%@ include file="/WEB-INF/include/extra.inc" %>
<%@ include file="/WEB-INF/include/subheader.jhtml" %>
<%
  // CSS files that we deal with
  String cssFileName = "neptune.css";
  String cssBackupName = "neptune.css.backup";

  // POST actions
  boolean update = (request.getParameter("update")!=null);
  boolean revert = (request.getParameter("revert")!=null);

  String cssFilePath = searchbloxCssDir+File.separatorChar+cssFileName;
  File cssFile = new File(cssFilePath);

  String cssBackupPath = searchbloxCssDir+File.separatorChar+cssBackupName;
  File cssBackup = new File(cssBackupPath);

  BufferedReader br = null;
  PrintWriter pw = null;
  
  if (update) {

    // back up and update CSS file
    boolean newBackup = cssBackup.createNewFile(); // only creates the first time
    if (cssFile.canRead() && cssBackup.canWrite()) {
      // write the backup file
      br = new BufferedReader(new FileReader(cssFile));
      pw = new PrintWriter(new BufferedWriter(new FileWriter(cssBackup)));
      String s = null;
      while ((s=br.readLine())!=null) pw.println(s);
      br.close();
      pw.close();
      String cssdata = request.getParameter("cssdata").replace('~','&');
      if (cssFile.canWrite() && cssdata!=null) {
        // write the new file from the form input
        pw = new PrintWriter(new BufferedWriter(new FileWriter(cssFile)));
        pw.print(cssdata);
        pw.close();
        message = cssFileName+" updated.";
      } else {
        error="Cannot write to CSS file "+cssFile.getAbsolutePath();
      }
    } else {
      error = "Cannot read CSS file "+cssFile.getAbsolutePath()+" or cannot write backup file "+cssBackup.getAbsolutePath();
    }
  }

  if (revert) {
    // copy backup back to CSS file
    if (cssFile.canWrite() && cssBackup.canRead()) {
      br = new BufferedReader(new FileReader(cssBackup));
      pw = new PrintWriter(new BufferedWriter(new FileWriter(cssFile)));
      String s = null;
      while ((s=br.readLine())!=null) pw.println(s);
      br.close();
      pw.close();
      message = cssFileName+" reverted to backup version.";
    } else {
      error = "Cannot write to file "+cssFile.getAbsolutePath()+" or cannot read backup file "+cssBackup.getAbsolutePath();
    }
  }

  // hook file up to a BufferedReader
  if (cssFile.canRead()) {
    br = new BufferedReader(new FileReader(cssFile));
  } else {
    error = "Cannot read CSS file "+cssFile.getAbsolutePath();
  }
  
%>
<%@ include file="/WEB-INF/include/errormessage.jhtml" %>
<%
  if (br!=null) {
    String s = null;
%>
<table>
  <tr>
    <td align="right"><a target="_blank" href="/searchblox/servlet/SearchServlet?query=site&xsl=neptune.xsl&action=Preview">Preview</a></td>
  </tr>
  <tr>
    <td align="center">
      <form method="post">
        <textarea rows="32" cols="120" name="cssdata"><% while ((s=br.readLine())!=null) out.println(s.replace('&','~')); %></textarea><br/>
        <input type="submit" class="update" name="update" value="Update"/>
        <input type="submit" class="delete" name="revert" value="Revert"/>
      </form>
    </td>
  </tr>
</table>
<%
  br.close();
}
%>
<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/footer.jhtml" %>
