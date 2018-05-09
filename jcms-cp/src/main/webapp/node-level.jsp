<%@ include file="/WEB-INF/include/init.inc" %>
<%
/**
 * Output the level of the given node
 */

  try {
  
    int nid = Util.getInt(request, "nid");
    Node n = new Node(application, nid);
    if (n.isDefault()) {
      out.print("");
    } else {
      out.print(n.getDepth());
    }

  } catch (Exception ex) {
    
    out.print("ERROR: "+ex.getMessage());
    
  }
%>
<%@ include file="/WEB-INF/include/close.inc" %>
