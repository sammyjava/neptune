<%@ include file="/WEB-INF/include/init.inc" %>
<%
  /**
   * Toggle the SSL state of the given node
   */
  try {
    int nid = Integer.parseInt(request.getParameter("nid"));
    Node n = new Node(application, nid);
    n.ssl = !n.ssl;
    n.update(request);
    if (n.ssl) {
      out.print("Node <b>"+n.label+"</b> set to be served via SSL.");
    } else {
      out.print("Node <b>"+n.label+"</b> set to be served without SSL.");
    }
  } catch (java.sql.SQLException e) {
    out.print("ERROR: "+e.getMessage());
  }
%>
<%@ include file="/WEB-INF/include/close.inc" %>
