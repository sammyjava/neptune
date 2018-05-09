<%@ include file="/WEB-INF/include/init.inc" %>
<%
  /**
  * Display the node rename form
  */
  int nid = Integer.parseInt(request.getParameter("nid"));
  Node n = new Node(application, nid);
%>
<div style="width:350px;">
  <form action="node-rename.jsp" class="zpForm" id="userForm" method="get">
    <input type="hidden" name="nid" value="<%=n.nid%>"/>
    <table cellspacing="0" cellpadding="0" border="0">
      <tr>
        <td><b><%=n.label%></b></td>
        <td><input class="zpFormRequired" type="text" name="nodename" size="32" value="<%=Util.blankIfNull(n.nodename)%>"></td>
      </tr>
      <tr>
        <td colspan="2" align="right"><input type="submit" class="update" onClick="" value="Rename Node"></td>
      </tr>
    </table>
  </form>
</div>
<script type="text/javascript">
    // Run this to auto-activate all "zpForm" class forms in the document.
    Zapatec.Form.setupAll({
      showErrors: 'afterField',
      showErrorsOnSubmit: true,
      asyncSubmitFunc: onSuccess,
      submitErrorFunc: onError,
      <% if (debug) { %>ajaxDebugFunc: showDebug,<% } %>
      busyConfig: {
        busyContainer: "userForm"
      }
    });
</script>
<%@ include file="/WEB-INF/include/close.inc" %>
