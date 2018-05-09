<%@ page contentType="text/html; charset=UTF-8" language="java" %><%@ page import="net.ims.jcms.*, net.ims.jcms.extras.*, lmapi.ListStruct, java.util.*"%><%
  
  // spits out a single Lyris message, given by the messageid query string.
  try {
    
    if (request.getParameter("messageid")!=null) {

      // instantiate Lyris object so we can get at the SOAP service
      Lyris lyris = new Lyris(application);

      // get the requested message
      int messageid = Util.getInt(request, "messageid");
      Message message = lyris.getMessage(messageid);

      // output HTML if available, else plain text
      if (message.htmlBody!=null) {
        if (message.htmlCharset!=null) response.setCharacterEncoding(message.htmlCharset);
        out.print(message.htmlBody);
      } else if (message.textBody!=null) {
        if (message.textCharset!=null) response.setCharacterEncoding(message.textCharset);
        out.print(message.textBody);
      } else {
        if (message.body.indexOf("ISO-8859-1")>0 || message.body.indexOf("iso-8859-1")>0) {
          response.setCharacterEncoding("ISO-8859-1");
        } else {
          response.setCharacterEncoding("UTF-8");
        }
        out.print(javax.mail.internet.MimeUtility.decodeText(message.body));
      }

    }

  } catch (Exception ex) {
    
    out.print(ex.toString());
    
  }
%>
      
