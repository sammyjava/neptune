<%@ include file="/WEB-INF/include/init.inc" %>
<%
/**
 * Add a child node
 */

  try {
    
    Node n = new Node(application, Util.getInt(request,"nid"));
    Node child = n.addChild(session);
    out.print("New child node <b>"+child.label+"</b> created.");

  } catch (Exception ex) {

    out.print("ERROR: "+ex.getMessage());

  }
%>
<%@ include file="/WEB-INF/include/close.inc" %>
