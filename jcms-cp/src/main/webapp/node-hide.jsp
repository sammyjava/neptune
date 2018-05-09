<%@ include file="/WEB-INF/include/init.inc" %>
<%
  /**
   * Toggle the hidden state of the given node
   */
  try {
    int nid = Integer.parseInt(request.getParameter("nid"));
    Node n = new Node(application, nid);
    n.hidden = !n.hidden;
    n.update(request);
    if (n.hidden) {
      out.print("Node <b>"+n.label+"</b> set to be hidden.");
    } else {
      out.print("Node <b>"+n.label+"</b> set to be visible.");
    }
  } catch (java.sql.SQLException e) {
    out.print("ERROR: "+e.getMessage());
  }
%>
<%@ include file="/WEB-INF/include/close.inc" %>
