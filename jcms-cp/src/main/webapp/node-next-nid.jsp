<%@ include file="/WEB-INF/include/init.inc" %>
<%
/**
 * Output the nid of the next sibling node, null if none
 */

try {
  
  int nid = Util.getInt(request, "nid");
  Node n = new Node(application, nid);
  
  // get the next node, if it exists
  Node next = new Node(application, n.parent_nid, n.num+1);
  if (next.isDefault()) {
    out.print("");
  } else {
    out.print(next.nid);
  }

} catch (Exception ex) {

  out.print("ERROR: "+ex.getMessage());

}
%>
<%@ include file="/WEB-INF/include/close.inc" %>
