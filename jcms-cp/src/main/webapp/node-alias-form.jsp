<%@ include file="/WEB-INF/include/init.inc" %>
<%
  /**
  * Display the node alias form
  */
  
  // get the requested Node
  int nid = Integer.parseInt(request.getParameter("nid"));
  Node n = new Node(application, nid);
  String alias = n.alias;
  if (alias==null) alias = "/"; else alias = "/"+alias;
%>
<div style="width:350px;">
  <form action="node-alias.jsp" class="zpForm" id="userForm" method="get">
    <input type="hidden" name="nid" value="<%=n.nid%>"/>
    <table cellspacing="0" cellpadding="0" border="0">
      <tr>
        <td><b><%=n.label%></b></td>
        <td><input type="text" name="alias" size="32" value="<%=alias%>"></td>
      </tr>
      <tr>
        <td colspan="2" align="right"><input type="submit" class="update" onClick="" value="Update Alias"></td>
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
