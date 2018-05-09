package net.ims.jcms;

import java.io.FileInputStream;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Calendar;
import java.util.Hashtable;
import java.util.TimeZone;
import java.text.SimpleDateFormat;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet to enforce access control on media requests, and return the media if allowed.
 *   Returns a 403 error if user is not authorized to view this media.
 *   Returns a 404 error if the media does not exist.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class MediaServlet extends HttpServlet {

  // timestamps are supposed to be in GMT
  TimeZone tz = TimeZone.getTimeZone("GMT");
  SimpleDateFormat httpDate = new SimpleDateFormat();

  Hashtable<String,String> mimeTypes = new Hashtable<String,String>();

  /**
   * Process a media GET request.
   */
  public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    HttpSession session = request.getSession();
    ServletContext context = session.getServletContext();

    try {
      
      // instantiate the default access user
      AccessUser au = Util.getDefaultAccessUser(context);
      // retrieve access user from the session, if stored
      if (session.getAttribute("AccessUser")!=null) au = (AccessUser)session.getAttribute("AccessUser");

      // check whether media exists
      String mediaFolder = (new Setting(context, "site_mediafolder")).value;
      String mediaDir = (new Setting(context, "site_mediadir")).value;
      String fileName = request.getRequestURI().substring(mediaFolder.length()+1);
      Media m = new Media(context, fileName);
      
      if (!m.isDefault()) {
	
	// check permission
	boolean allowed = au.mayAccess(context, m);
	
	// send file
	if (allowed) {
	  
	  // absolute path, app.mediadir is relative to web app root
	  String filePath = mediaDir+fileName;
	  
	  // create the reader
	  FileInputStream fis = new FileInputStream(filePath);
	  
	  // get the writer
	  ServletOutputStream sos = response.getOutputStream();
	  
	  // set the actual file name in the response, for the save-file dialog
	  response.setHeader("Content-Disposition", "filename="+fileName);
	  
	  // set the size of the file
	  response.setHeader("Content-Length", ""+m.filesize);

	  // set the last-modified header so it's cached
	  httpDate.setTimeZone(tz);
	  httpDate.applyPattern("EEE, dd MMM yyyy HH:mm:ss zzz");
	  if (m.updated!=null) {
	    response.setHeader("Last-Modified", httpDate.format(m.updated));
	  } else {
	    response.setHeader("Last-Modified", httpDate.format(m.created));
	  }
	  
	  // set the response content type, based on the file extension
	  int i = fileName.lastIndexOf(".");
	  String extension = fileName.substring(i+1).toLowerCase();
	  String mime = (String)mimeTypes.get(extension);
	  if (mime==null) mime = "text/plain";
	  response.setContentType(mime);
	  
	  try {
	    
	    // pipe the bytes from the reader to the writer using a 1 kB buffer
	    byte[] b = new byte[1024];
	    int l = 0;
	    while ((l=fis.read(b))!=-1) sos.write(b, 0, l);
	    
	  } catch (Exception ex) {
	    
	  } finally {
	    
	    // flush and close
	    sos.flush();
	    sos.close();
	    fis.close();
	    
	  }
	  
	} else {
	  
	  response.sendError(403, fileName);
	  
	}

      } else {
	
	response.sendError(404, fileName);
	
      }

    } catch (Exception ex) {

      // can't send error after response output has already been accessed

    }

  }
  
  /**
   * Initialize mimeTypes with all the ones we care about.
   */
  public void init() {
    mimeTypes.put("exe", "application/x-msdownload");
    mimeTypes.put("bin", "application/x-msdownload");
    mimeTypes.put("doc", "application/msword");
    mimeTypes.put("docx", "application/msword");
    mimeTypes.put("xls", "application/vnd.ms-excel");
    mimeTypes.put("ppt", "application/vnd.ms-powerpoint");
    mimeTypes.put("pdf", "application/pdf");
    mimeTypes.put("ps",  "application/postscript");
    mimeTypes.put("eps", "application/postscript");
    mimeTypes.put("rtf", "application/rtf");
    mimeTypes.put("tar", "application/x-tar");
    mimeTypes.put("xml", "application/xml");
    mimeTypes.put("zip", "application/zip");
    mimeTypes.put("wav", "audio/x-wav");
    mimeTypes.put("m3u", "audio/x-mpegurl");
    mimeTypes.put("m4u", "video/x-mpegurl");
    mimeTypes.put("mp3", "audio/mpeg");
    mimeTypes.put("wma", "audio/x-ms-wma");
    mimeTypes.put("wax", "audio/x-ms-wax");
    mimeTypes.put("wmv", "audio/x-ms-wmv");
    mimeTypes.put("gif", "image/gif");
    mimeTypes.put("jpeg","image/jpeg");
    mimeTypes.put("jpg", "image/jpeg");
    mimeTypes.put("jpe", "image/jpeg");
    mimeTypes.put("png", "image/png");
    mimeTypes.put("tif", "image/tiff");
    mimeTypes.put("tiff","image/tiff");
    mimeTypes.put("html","text/html");
    mimeTypes.put("htm", "text/html");
    mimeTypes.put("asc", "text/plain");
    mimeTypes.put("txt", "text/plain");
    mimeTypes.put("mpg", "video/mpeg");
    mimeTypes.put("mpeg","video/mpeg");
    mimeTypes.put("mpe", "video/mpeg");
    mimeTypes.put("qt",  "video/quicktime");
    mimeTypes.put("mov", "video/quicktime");
    mimeTypes.put("avi", "video/x-msvideo");
    mimeTypes.put("asf", "video/x-ms-asf");
    mimeTypes.put("asx", "video/x-ms-asf");
    mimeTypes.put("wvx", "video/x-ms-wvx");
    mimeTypes.put("wm",  "video/x-ms-wm");
    mimeTypes.put("wmx", "video/x-ms-wmx");
  }

}
