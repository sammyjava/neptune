<%@ include file="/WEB-INF/include/init.inc" %>
<%
/**
 * Decrement a node label, increment the previous node's label
 */

  try {

    Node n = new Node(application, Util.getInt(request,"nid"));
    n.decrementNum(application);
    out.print("Node <b>"+n.nodename+"</b> moved to position <b>"+n.label+"</b>.");
    
  } catch (Exception ex) {
    
    out.print("ERROR: "+ex.getMessage());
    
  }
%>
<%@ include file="/WEB-INF/include/close.inc" %>
