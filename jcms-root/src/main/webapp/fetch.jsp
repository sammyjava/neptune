<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="net.ims.jcms.*, net.ims.jcms.extras.*,java.io.InputStream,java.io.ByteArrayOutputStream,java.net.URL,java.net.URLConnection" %>
<%
  try {

    String location = request.getParameter("url");

    if (location==null || location.length()==0) {
      out.print("<div class=\"error\">Fetch ERROR: no URL supplied to Fetch extra.  Usage: /fetch.jsp?url=http://somedomain.com/somepage</div>");
      return;
    }
    
    URL url = new URL(location);
    URLConnection urlConnection = url.openConnection();
    String contentType = urlConnection.getContentType();

    if (contentType!=null && contentType.startsWith("text/html")) {

      InputStream is = urlConnection.getInputStream();
      ByteArrayOutputStream baos = new ByteArrayOutputStream();
      
      // pipe the bytes from the reader to the writer using a 1 kB buffer
      byte[] b = new byte[1024];
      int l = 0;
      while ((l=is.read(b))!=-1) baos.write(b, 0, l);
      String output = baos.toString();
      
      // strip everything between body tags, if needed
      String outputLC = output.toLowerCase();
      if (outputLC.contains("<body")) {
	int i = outputLC.indexOf("<body") + 2;
	int j = outputLC.indexOf(">",i) + 1; // find the next closing >
	int k = outputLC.indexOf("</body>");
	output = output.substring(j, k);
      }

      out.print("<div class=\"fetch\">"+output+"</div>");

    } else {

      out.print("<div class=\"error\">Fetch ERROR: URL <b>"+location+"</b> is content of type <b>"+contentType+"</b>, not <b>text/html</b> as required.</div>");

    }

  } catch (Exception ex) {

    out.print("<div class=\"error\">Fetch ERROR: "+ex.toString()+"</div>");

  }
%>
