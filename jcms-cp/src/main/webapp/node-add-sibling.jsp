<%@ include file="/WEB-INF/include/init.inc" %>
<%
/**
 * Add a sibling node
 */

  try {

    Node n = new Node(application, Util.getInt(request,"nid"));
    Node sibling = n.addSibling(session);
    out.print("New sibling node <b>"+sibling.label+"</b> created.");

  } catch (Exception ex) {

    out.print("ERROR: "+ex.toString());

  }
%>
<%@ include file="/WEB-INF/include/close.inc" %>
