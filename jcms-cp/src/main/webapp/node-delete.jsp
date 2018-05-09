<%@ include file="/WEB-INF/include/init.inc" %>
<%
  /**
   * Delete the given node
   */
  try {
    
    int nid = Integer.parseInt(request.getParameter("nid"));
    Node n = new Node(application, nid);
    String label = n.label;
    n.delete(request);
    out.print("Node <b>"+label+"</b> deleted.");

  } catch (Exception ex) {
    
    out.print("ERROR: "+ex.getMessage());
    
  }
%>
<%@ include file="/WEB-INF/include/close.inc" %>
