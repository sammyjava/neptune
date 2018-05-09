<%@ page import="java.io.*, java.util.*, net.ims.jcms.*, net.ims.jcms.extras.*, org.devlib.schmidt.imageinfo.ImageInfo" %>
<%@ page import="org.apache.commons.fileupload.*, org.apache.commons.fileupload.disk.*, org.apache.commons.fileupload.servlet.*" %>
<%@ page import="java.awt.Color, java.awt.Image, java.awt.Graphics2D, java.awt.RenderingHints, java.awt.Toolkit, java.awt.geom.AffineTransform, java.awt.image.BufferedImage, javax.imageio.ImageIO, javax.swing.ImageIcon" %>
<%@ page import="com.sun.image.codec.jpeg.JPEGEncodeParam, com.sun.image.codec.jpeg.JPEGCodec, com.sun.image.codec.jpeg.JPEGImageEncoder" %>
<%
 /**
  * Handle uploads from jupload applet.  Uses jakarta-commons fileupload package.
  *
  * Note: putting error=true as a parameter on the applet URL will generate an error. Allows test of upload error management in the applet. 
  * 
  */

  boolean DEBUG = false; // sends debug output to System.out
  
  byte[] cr = {13};
  byte[] lf = {10};
  
  String CR = new String(cr);
  String LF = new String(lf);
  String CRLF = CR + LF;
  
  // Initialization for chunk management.
  boolean bLastChunk = false;
  int numChunk = 0;
  
  // CAN BE OVERRIDEN BY THE postURL PARAMETER: if error=true is passed as a parameter on the URL
  boolean generateError = false;

  response.setContentType("text/plain");
  
  try {

    if (request.getContentType()!=null && request.getContentType().startsWith("multipart/form-data")) {

      // back compatibility
      String photosDir = Setting.getString(application,"photos_dir");
      int photoset_id = Util.getInt(request,"photoset_id");
      File dirCheck = new File(photosDir+photoset_id+File.separator);
      if (dirCheck.exists()) photosDir += photoset_id+File.separator;
      
      int maxMemorySize  = Setting.getInt(application,"photos_max_memory");
      int maxRequestSize = Setting.getInt(application,"photos_max_request");

      ImageInfo ii = new ImageInfo();

      // Get URL Parameters.
      Enumeration paraNames = request.getParameterNames();
      String pname;
      String pvalue;
      while (paraNames.hasMoreElements()) {
        
        pname = (String)paraNames.nextElement();
        pvalue = request.getParameter(pname);
        if (pname.equals("jufinal")) {
          bLastChunk = pvalue.equals("1");
        } else if (pname.equals("jupart")) {
          numChunk = Integer.parseInt(pvalue);
        }
        //For debug convenience, putting error=true as a URL parameter, will generate an error
        //in this class.
        if (pname.equals("error") && pvalue.equals("true")) {
          generateError = true;
        }
        
      }

      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      // The code below is directly taken from the jakarta fileupload common classes
      // All informations, and download, available here : http://jakarta.apache.org/commons/fileupload/
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      
      // Create a factory for disk-based file items
      DiskFileItemFactory factory = new DiskFileItemFactory();
      
      // Set factory constraints
      factory.setSizeThreshold(maxMemorySize);
      factory.setRepository(new File(photosDir));
      
      // Create a new file upload handler
      ServletFileUpload upload = new ServletFileUpload(factory);
      
      // Set overall request size constraint
      upload.setSizeMax(maxRequestSize);
      
      List /* FileItem */ items = upload.parseRequest(request);

      // Process the uploaded items
      Iterator iter = items.iterator();
      FileItem fileItem;
      File fout;
      while (iter.hasNext()) {
        
        fileItem = (FileItem) iter.next();
        
        if (fileItem.isFormField()) {

          if (fileItem.getFieldName().equals("md5sum[]")) {
            // If we receive the md5sum parameter, we've read finished to read the current file. It's not
            // a very good (end of file) signal. Will be better in the future ... probably !
            // Let's put a separator, to make output easier to read.
            out.println("File uploads complete.");
          } else {
            out.println("[parseRequest.jsp] (form field) " + fileItem.getFieldName() + " = " + fileItem.getString());
          }
          
        } else {

          if (DEBUG) {
            System.out.println("[jupload.jsp] FieldName: " + fileItem.getFieldName());
            System.out.println("[jupload.jsp] File Name: " + fileItem.getName());
            System.out.println("[jupload.jsp] ContentType: " + fileItem.getContentType());
            System.out.println("[jupload.jsp] Size (Bytes): " + fileItem.getSize());
          }
          
          // If we are in chunk mode, we add ".partN" at the end of the file, where N is the chunk number.
          String uploadedFilename = fileItem.getName() + ( numChunk>0 ? ".part"+numChunk : "") ;
          fout = new File(photosDir+(new File(uploadedFilename)).getName());

          // write the file
          fileItem.write(fout);
          
          //////////////////////////////////////////////////////////////////////////////////////
          // Chunk management: if it was the last chunk, let's recover the complete file
          // by concatenating all chunk parts.
          //
          if (bLastChunk) {	        
            // First: construct the final filename.
            FileInputStream fis;
            FileOutputStream fos = new FileOutputStream(photosDir+fileItem.getName());
            int nbBytes;
            byte[] byteBuff = new byte[1024];
            String filename;
            for (int i=1; i<=numChunk; i+=1) {
              filename = fileItem.getName() + ".part" + i;
              out.println("[parseRequest.jsp] " + "  Concatenating " + filename);
              fis = new FileInputStream(photosDir + filename);
              while ((nbBytes=fis.read(byteBuff))>=0) fos.write(byteBuff, 0, nbBytes);
              fis.close();
            }
            fos.close();
          }
          // End of chunk management
          //////////////////////////////////////////////////////////////////////////////////////

          // get image size
          ii.setInput(new FileInputStream(photosDir+fileItem.getName()));
          int imagewidth = 0;
          int imageheight = 0;
          if (ii.check() && (ii.getFormat()==ii.FORMAT_JPEG || ii.getFormat()==ii.FORMAT_GIF || ii.getFormat()==ii.FORMAT_PNG || ii.getFormat()==ii.FORMAT_BMP)) {
            imagewidth = ii.getWidth();
            imageheight = ii.getHeight();
          }
          
          if (DEBUG) {
            System.out.println("[jupload.jsp] imagewidth: " + imagewidth);
            System.out.println("[jupload.jsp] imageheight: " + imageheight);
          }

	  // insert the photos record if it's new; update dims if a photo with this name already exists
          Photo photo = new Photo(application, photoset_id, fileItem.getName());
          if (DEBUG) System.out.println("[jupload.jsp] photo.photo_id: " + photo.photo_id);
	  if (photo.isDefault()) {
	    photo.photoset_id = photoset_id;
	    photo.imagefile = fileItem.getName();
	    photo.imagewidth = imagewidth;
	    photo.imageheight = imageheight;
            if (DEBUG) System.out.print("[jupload.jsp] photo insert...");
	    photo.insert(application);
            if (DEBUG) System.out.println("done");
	  } else {
	    photo.imagewidth = imagewidth;
	    photo.imageheight = imageheight;
            if (DEBUG) System.out.print("[jupload.jsp] photo update...");	
            photo.update(application);
	    photo.updateTimeposted(application);
            if (DEBUG) System.out.println("done");
	  }

          // crop image to square for thumbnail, using center square portion
          Image inImage = Toolkit.getDefaultToolkit().createImage(photosDir+fileItem.getName());
	  int squareWidth = imagewidth; // portrait
	  int x = 0; // portrait
	  int y = (imageheight - squareWidth)/2; // portrait
	  if (imagewidth>imageheight) {
	    squareWidth = imageheight;
	    x = (imagewidth - squareWidth)/2;
	    y = 0;
	  }
	  BufferedImage originalBI = new BufferedImage(imagewidth, imageheight, BufferedImage.TYPE_INT_RGB);
	  Graphics2D g2d = originalBI.createGraphics();
	  boolean done = g2d.drawImage(inImage, 0, 0, null);
          while (!done) done = g2d.drawImage(inImage, 0, 0, null);
	  BufferedImage squareBI = originalBI.getSubimage(x, y, squareWidth, squareWidth);
          inImage = new ImageIcon(squareBI).getImage();

          if (DEBUG) System.out.println("[jupload.jsp] squareWidth: " + squareWidth);

	  // create and write the thumbnail image file
	  int thumbWidth = Setting.getInt(application, "photos_thumbnail_width");
	  int thumbHeight = thumbWidth; // square thumbnails
	  double scale = (double)thumbWidth/(double)squareWidth;
	  int sizeDifference = squareWidth - thumbWidth;

	  BufferedImage outImage = new BufferedImage(thumbWidth, thumbHeight, BufferedImage.TYPE_INT_RGB);  
	  g2d = outImage.createGraphics();
	  AffineTransform tx;

	  // fancy reduction method from Phil Reeve
          int numSteps = sizeDifference / 100;
          if (numSteps==0) numSteps = 1;
          if (DEBUG) System.out.println("[jupload.jsp] numSteps: " + numSteps);
	  int stepSize = sizeDifference / numSteps;
	  int stepWeight = stepSize/2;
	  int heavierStepSize = stepSize + stepWeight;
	  int lighterStepSize = stepSize - stepWeight;
	  int currentStepSize, centerStep;
	  double scaledW = inImage.getWidth(null);
	  double scaledH = inImage.getHeight(null);
	  if (numSteps % 2 == 1) // if there's an odd number of steps
	    centerStep = (int)Math.ceil((double)numSteps / 2d); // find the center step
	  else
	    centerStep = -1; // set it to -1 so it's ignored later
	  int intermediateSize = squareWidth;
	  int previousIntermediateSize = squareWidth;
	  int calculatedDim = 0;
	  for (int i=0; i<numSteps; i++) {
	    if (i+1!=centerStep) {
	      if (i==numSteps-1) {
		// fix the stepsize to account for decimal place errors previously
		currentStepSize = previousIntermediateSize - thumbWidth;
	      } else {
		if (numSteps-i > numSteps/2)
		  currentStepSize = heavierStepSize;
		else
		  currentStepSize = lighterStepSize;
	      }
	    } else {                        
	      currentStepSize = stepSize;
	    }
	    intermediateSize = previousIntermediateSize - currentStepSize;
	    scale = (double)intermediateSize/(double)previousIntermediateSize;
	    scaledW = (int)scaledW*scale;
	    scaledH = (int)scaledH*scale;
	    outImage = new BufferedImage((int)scaledW, (int)scaledH, BufferedImage.TYPE_INT_RGB);
	    g2d = outImage.createGraphics();
	    g2d.setBackground(Color.WHITE);
	    g2d.clearRect(0, 0, outImage.getWidth(), outImage.getHeight());
	    g2d.setRenderingHint(RenderingHints.KEY_RENDERING, RenderingHints.VALUE_RENDER_QUALITY);
	    tx = new AffineTransform();
	    tx.scale(scale, scale);
            done = g2d.drawImage(inImage, tx, null);
	    while (!done) done = g2d.drawImage(inImage, tx, null);
	    g2d.dispose();
	    inImage = new ImageIcon(outImage).getImage();
	    previousIntermediateSize = intermediateSize;
	  }                
	  // JPEG-encode the image and write to file.
	  File thumbFile = new File(photosDir+"thumbs/"+fileItem.getName());
	  OutputStream os = new FileOutputStream(thumbFile);
	  JPEGImageEncoder encoder = JPEGCodec.createJPEGEncoder(os);
	  encoder.encode(outImage);
	  os.close();
          
          fileItem.delete();
        }	    
      } // while

    }

    // Do you want to test a successful upload, or the way the applet reacts to an error ?
    if (generateError) {
      out.println("ERROR: this is a test error (forced in jupload.jsp)");
    } else {
      out.println("SUCCESS");
    }
    out.println("[parseRequest.jsp] " + "End of server treatment ");
    
  } catch (Exception e) {
    
    out.println("Error thrown in jupload.jsp: "+e.toString());
    System.out.println("Error thrown in jupload.jsp: "+e.toString());
    
  }
%>
