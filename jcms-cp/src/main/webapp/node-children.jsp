<%@ include file="/WEB-INF/include/init.inc" %>
<%
  // load this user's nodes into a Vector for checking permission for a bit of extra speed
  Vector vNodes = cpuser.getNodes(application);
  
  // parent nid sent in as nid
  Node parent = new Node(application, Util.getInt(request,"nid"));
  boolean parentPerms = cpuser.hasPermission(application, parent);
  NodeLink parentLink = parent.getCurrentNodeLink(application);
  boolean parentHasLink = parentLink!=null;
%>
<ul>
  <%
    NodeListIterator childIterator = parent.getNodeListIterator(application);
    while (childIterator.hasNext()) {
      Node node = childIterator.nextNode();
      boolean nodePerms = parentPerms || vNodes.contains(node);
      boolean nodeHasChildren = node.hasChildren(application);
  %>
  <li <% if (nodeHasChildren) out.print("class=\"zpLoadHTML=node-children.jsp?nid="+node.nid+" zpLoadAlways=true\""); %> id="n<%=node.nid%>"><%@ include file="node-label.jhtml" %></li>
  <%
  } // while
  %>
</ul>
<%@ include file="/WEB-INF/include/close.inc" %>
