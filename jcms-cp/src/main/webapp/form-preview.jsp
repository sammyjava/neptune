<%@ include file="/WEB-INF/include/init.inc" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
  String form_id = request.getParameter("form_id");
%>
<html>
  <head>
    <title>Form <%=form_id%> Preview</title>
    <link rel="stylesheet" type="text/css" href="<%=cssFolder%>/root.css">
  </head>
  <body>
    <!-- main region -->
    <table id="main" cellspacing="0">
      <tr>
        <td id="main-right" valign="top">
          <div id="pagetitle">Form <%=form_id%> Preview</div>
          <table id="l1" cellspacing="0">
            <tr>
              <td valign="top" id="l1p1">
                <c:import context="/" url="/form.jsp">
                  <c:param name="form_id" value="<%=form_id%>"/>
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
