<%@ include file="/WEB-INF/include/init.inc" %>
<%@ page import="java.io.BufferedReader,java.io.FileReader" %>
<% int extra_id=7; useZapatec=false; %>
<%@ include file="/WEB-INF/include/header.jhtml" %>
<%@ include file="/WEB-INF/include/extra.inc" %>
<%@ include file="/WEB-INF/include/subheader.jhtml" %>
<%
  // XSL files that we deal with
  String xslFileName = "neptune.xsl";
  String xslBackupName = "neptune.xsl.backup";

  // POST actions
  boolean update = (request.getParameter("update")!=null);
  boolean revert = (request.getParameter("revert")!=null);

  String xslFilePath = searchbloxXslDir+File.separatorChar+xslFileName;
  File xslFile = new File(xslFilePath);

  String xslBackupPath = searchbloxXslDir+File.separatorChar+xslBackupName;
  File xslBackup = new File(xslBackupPath);

  BufferedReader br = null;
  PrintWriter pw = null;
  
  if (update) {

    // back up and update XSL file
    boolean newBackup = xslBackup.createNewFile(); // only creates the first time
    if (xslFile.canRead() && xslBackup.canWrite()) {
      // write the backup file
      br = new BufferedReader(new FileReader(xslFile));
      pw = new PrintWriter(new BufferedWriter(new FileWriter(xslBackup)));
      String s = null;
      while ((s=br.readLine())!=null) pw.println(s);
      br.close();
      pw.close();
      String xsldata = request.getParameter("xsldata").replace('~','&');
      if (xslFile.canWrite() && xsldata!=null) {
        // write the new file from the form input
        pw = new PrintWriter(new BufferedWriter(new FileWriter(xslFile)));
        pw.print(xsldata);
        pw.close();
        message = xslFileName+" updated.";
      } else {
        error="Cannot write to XSL file "+xslFile.getAbsolutePath();
      }
    } else {
      error = "Cannot read XSL file "+xslFile.getAbsolutePath()+" or cannot write backup file "+xslBackup.getAbsolutePath();
    }
  }

  if (revert) {
    // copy backup back to XSL file
    if (xslFile.canWrite() && xslBackup.canRead()) {
      br = new BufferedReader(new FileReader(xslBackup));
      pw = new PrintWriter(new BufferedWriter(new FileWriter(xslFile)));
      String s = null;
      while ((s=br.readLine())!=null) pw.println(s);
      br.close();
      pw.close();
      message = xslFileName+" reverted to backup version.";
    } else {
      error = "Cannot write to file "+xslFile.getAbsolutePath()+" or cannot read backup file "+xslBackup.getAbsolutePath();
    }
  }

  // hook file up to a BufferedReader
  if (xslFile.canRead()) {
    br = new BufferedReader(new FileReader(xslFile));
  } else {
    error = "Cannot read XSL file "+xslFile.getAbsolutePath();
  }
  
%>
<%@ include file="/WEB-INF/include/errormessage.jhtml" %>
<%
  if (br!=null) {
    String s = null;
%>
<table>
  <tr>
    <td>Note: <b>&</b> is replaced by <b>~</b> in this editor.</td>
    <td align="right"><a target="_blank" href="/searchblox/servlet/SearchServlet?query=site&xsl=neptune.xsl&action=Preview">Preview</a></td>
  </tr>
  <tr>
    <td colspan="2" align="center">
      <form method="post">
        <textarea rows="32" cols="120" name="xsldata"><% while ((s=br.readLine())!=null) out.println(s.replace('&','~')); %></textarea><br/>
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
