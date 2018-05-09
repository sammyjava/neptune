<%@ include file="/WEB-INF/include/init.inc" %>
<% pageTitle = "Docs - Flash Image Rotator"; %>
<%@ include file="/WEB-INF/include/header.jhtml" %>
<%@ include file="/WEB-INF/include/doc-nav.jhtml" %>

<p>
  The <b>Flash Image Rotator</b> is a front-end only extra that displays a series of images using the LongTail Video JW Image Rotator (which is no longer being offered by LongTail because they've moved on to HTML5).
  We provide this player installed on the root of your site at /imagerotator.swf.
</p>

<p>
  The images themselves should be uploaded with the Design Media tool, or, if you don't have permission to use that, into an unused content item using the Content tool's media loader.  In the example below, we'll assume
  the images are located under /design; if you've loaded them with the Content tool, they'll typically be located under /images.
</p>

<p>
  <b>Step 1: Upload the images.</b>
</p>
<p>
  Use the Design Media tool or the Content tool to upload all the images you want to show in the Flash image rotator.<br/>
  For my example, let's suppose I uploaded the following five 640x480 image files with the Design Media tool:
  <b>image1.jpg</b>, <b>image2.jpg</b>, <b>image3.jpg</b>, <b>image4.jpg</b> and <b>image5.jpg</b>.
</p>

<p>
  <b>Step 2: Create and upload the XML playlist file.</b>
</p>
<p>
  The JW Image Rotator uses an XML Playlist file to determine which images to display.
  You can name the XML file as you like, but it should have the following format, using my five example images.  Use Notepad or a similar simple text editor to create it.  I'll name it <b>flashimages.xml</b>.
</p>

<pre>
&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;playlist version="1" xmlns="http://xspf.org/ns/0/"&gt;
	&lt;trackList&gt;
		&lt;track&gt;
			&lt;title&gt;This is Image 1&lt;/title&gt;
			&lt;creator&gt;Bob Smiley&lt;/creator&gt;
			&lt;location&gt;/design/image1.jpg&lt;/location&gt;
			&lt;info&gt;http://www.ims.net/&lt;/info&gt;
		&lt;/track&gt;
		&lt;track&gt;
			&lt;title&gt;Another Image Title&lt;/title&gt;
			&lt;creator&gt;Jane Smiley&lt;/creator&gt;
			&lt;location&gt;/design/image2.jpg&lt;/location&gt;
			&lt;info&gt;http://www.google.com/&lt;/info&gt;
		&lt;/track&gt;
		&lt;track&gt;
			&lt;title&gt;A Third Image Title&lt;/title&gt;
			&lt;creator&gt;Jack Smiley&lt;/creator&gt;
			&lt;location&gt;/design/image3.jpg&lt;/location&gt;
		&lt;/track&gt;
		&lt;track&gt;
			&lt;title&gt;A Fourth Image La Di Dah&lt;/title&gt;
			&lt;creator&gt;Bonnie Smiley&lt;/creator&gt;
			&lt;location&gt;/design/image4.jpg&lt;/location&gt;
			&lt;info&gt;http://dogoodhq.com/&lt;/info&gt;
		&lt;/track&gt;
		&lt;track&gt;
			&lt;title&gt;A Fifth and Final Image&lt;/title&gt;
			&lt;creator&gt;Billy Smiley&lt;/creator&gt;
			&lt;location&gt;/design/image5.jpg&lt;/location&gt;
		&lt;/track&gt;
	&lt;/trackList&gt;
&lt;/playlist&gt
</pre>

<p>
  The only required element is <b>&lt;location&gt;</b>, since you have to tell the player which image to show.  The other elements are informational, and if you supply an
  <b>&lt;info&gt;</b> tag with a URL, that particular image will link that URL.
</p>

<p>
  Once you have your image files uploaded, upload the XML playlist file using the Design Media tool or the Media tool.  In my example I'll assume the Design Media tool was used, so the
  location of the XML file is <b>/design/flashimages.xml</b>.
</p>

<p>
  <b>Step 3: Embed the JW Image Rotator in your content.</b>
</p>
<p>
  The third and final step is to place the embed code in your content to display the rotating images.  There are a lot of
  <a target="_blank" href="jw-image-rotator-flashvars.html">flash variables</a> that you can
  use to control the playback of the image sequence.  You can control the style of transitions, add a logo, and many other options.
  Here's a basic example, which creates a player that doesn't have navigation controls (shownavigation=false) and links the images (linkfromdisplay=true), which is the most popular configuration.
</p>

<pre>
&lt;!-- start Flash Image Rotator --&gt;
&lt;div id="imagerotator"&gt;&lt;a href="http://www.macromedia.com/go/getflashplayer"&gt;Get the Flash Player&lt;/a&gt; to see this movie.&lt;/div&gt;
&lt;script type="text/javascript"&gt;
  var flashvars = {
    file: "/design/flashimages.xml",
    width: "640",
    height: "480",
    shownavigation: false,
    linkfromdisplay: true
  }
  var params = {
    allowfullscreen: "true"
  }
  swfobject.embedSWF("/imagerotator.swf", "imagerotator", "640", "480", "9.0.98", "/expressInstall.swf", flashvars, params);
&lt;/script&gt;
&lt;!-- end Flash Image Rotator --&gt;
</pre>

<p>
  <b>OR Step 3: Use the front-end Flash Image Rotator extra.</b>
</p>
<p>
  For convenience, we provide a front-end extra which generates the embed code so you can use the Flash Image Rotator as an extension.  The extension context is <b>/</b> and the extension URL is <b>/flashimagerotator.jsp</b> plus
  query string parameters to provide the file, width and height and, optionally, rotatetime values.  So, a complete extension URL would be, for the above example:
  <b>/flashimagerotator.jsp?file=/design/flashimages.xml&width=640&height=480&rotatetime=3</b>.  The default rotatetime is 3 seconds if omitted.
</p>


<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/footer.jhtml" %>

