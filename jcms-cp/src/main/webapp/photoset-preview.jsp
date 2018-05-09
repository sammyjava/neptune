<%@ include file="/WEB-INF/include/init.inc" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
  int photoset_id = 0;
  int photo_id = 0;
  if (request.getParameter("photoset_id")!=null) photoset_id = Integer.parseInt(request.getParameter("photoset_id"));
  if (request.getParameter("photo_id")!=null) photo_id = Integer.parseInt(request.getParameter("photo_id"));
  if (photoset_id==0 && photo_id!=0) {
    Photo photo = new Photo(application, photo_id);
    photoset_id = photo.photoset_id;
  }
  String photosetId = Integer.toString(photoset_id);
  String photoId = Integer.toString(photo_id);
%>
<html>
  <head>
    <title>Photo Set <%=photoset_id%> Preview</title>
    <link rel="stylesheet" type="text/css" href="<%=cssFolder%>/root.css">
  </head>
  <body>
    <!-- main region -->
    <table id="main" cellspacing="0">
      <tr>
        <td id="main-right" valign="top">
          <div id="pagetitle">Photo Set <%=photoset_id%> Preview</div>
          <table id="l1" cellspacing="0">
            <tr>
              <td valign="top" id="l1p1">
                <c:import context="/" url="/photoset.jsp">
                  <c:param name="photoset_id" value="<%=photosetId%>"/>
                  <c:param name="photo_id" value="<%=photoId%>"/>
                </c:import>
              </td>
            </tr>
          </table>
        </td>
      </tr>
    </table>
  </body>
</html>

<%@ include file="/WEB-INF/include/close.inc" %>
