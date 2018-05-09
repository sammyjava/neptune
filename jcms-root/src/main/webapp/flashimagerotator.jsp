<%
  // convenience extra to generate embed code for the Flash image rotator
  String file = request.getParameter("file");
  String width = request.getParameter("width");
  String height = request.getParameter("height");
  String rotatetime = request.getParameter("rotatetime");
  if (rotatetime==null) rotatetime = "3";
  if (file==null || width==null || height==null) {
    out.println("<p><b>file</b>, <b>width</b> and <b>height</b> must be passed as query strings.");
  } else {
%>
<!-- start Flash Image Rotator -->
<!--stopindex-->
<div id="imagerotator"><a href="http://www.macromedia.com/go/getflashplayer">Get the Flash Player</a> to see this movie.</div>
<script type="text/javascript">
  var flashvars = {
    file: "<%=file%>",
    width: "<%=width%>",
    height: "<%=height%>",
    rotatetime: "<%=rotatetime%>",
    shuffle: "false",
    showicons: "false",
    shownavigation: "false",
    usefullscreen: "false",
    linkfromdisplay: "true",
    transition: "slowfade"
  }
  var params = {
    allowfullscreen: "false",
    wmode: "transparent"
  }
  swfobject.embedSWF("/imagerotator.swf", "imagerotator", "<%=width%>", "<%=height%>", "9.0.98", "/expressInstall.swf", flashvars, params);
</script>
<!--startindex-->
<!-- end Flash Image Rotator -->
<%
  }
%>
