<%@ include file="/WEB-INF/include/init.inc" %>
<%
/**
 * Output the nid of the parent of the given node
 */

  try {
  
    int nid = Util.getInt(request, "nid");
    Node n = new Node(application, nid);
    if (n.nid!=0) out.print(n.parent_nid);

  } catch (Exception ex) {
    
    out.print("ERROR: "+ex.getMessage());
    
  }
%>
<%@ include file="/WEB-INF/include/close.inc" %>
