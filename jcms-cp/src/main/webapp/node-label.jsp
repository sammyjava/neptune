<%@ include file="/WEB-INF/include/init.inc" %>
<%
/**
 * Display a node tree label for the node identified by query string parameter nid
 */

int nid = Integer.parseInt(request.getParameter("nid"));
Node node = new Node(application, nid);
Node parent = new Node(application, node.parent_nid);

boolean nodeHasChildren = node.hasChildren(application);
NodeLink nodeLink = node.getCurrentNodeLink(application);
boolean nodeHasLink = nodeLink!=null && !nodeLink.isEmpty();
String newSiblingLabel = parent.label+"."+(node.num+1);
if (parent.isDefault()) newSiblingLabel = ""+(node.num+1);
String newChildLabel = node.label+".1";
  
boolean nodePerms = cpuser.hasPermission(application, node);
boolean parentPerms = cpuser.hasPermission(application, parent);

// table cell width parameters
int w0 = 25;
int w1 = 20;
int w2 = 200;
int w3 = 150;
int w4 = 120;
int w5 = 70;
int w6 = 70;
int w7 = 50;
int w8 = 50;
int w9 = 50;
int w10 = 50;
%>
<table cellspacing="0">
  <tr>
    <td class="tight" width="<%=w0%>"><% if (node.active) { %><b><%=node.label%></b><% } else { %><b class="inactive"><%=node.label%></b><% } %></td>
    <td class="tight" width="<%=w1%>" align="center"><% if (nodePerms && node.num>1) { %><a class="nodeadd" href="javascript:decrementNode(<%=node.nid%>)"><b>&uarr;</b></a><% } %></td>
    <td class="tight" width="<%=w2%>"><%=node.nodename%></td>
    <td class="tight" width="<%=w3%>"><% if (node.alias!=null) out.print("/"+node.alias); %></td>
    <td class="tight" width="<%=w4%>" align="center"><% if (parentPerms) { %><a class="nodeadd" href="javascript:addSibling(<%=node.nid%>)">[<%=newSiblingLabel%>]</a><% } %> <% if (!node.isDefault() && node.getDepth()<4 && nodePerms && (node.active || (node.getDepth()==1 && !navPrimaryLevel1Enable))) { %><a class="nodeadd" href="javascript:addChild(<%=node.nid%>)">[<%=newChildLabel%>]</a><% } %></td>
    <td class="tight" width="<%=w5%>"><% if (nodeHasLink) { if (nodeLink.isPage()) { %><a class="editpage" href="page.jsp?pid=<%=nodeLink.pid%>">page <%=nodeLink.pid%></a><% } else if (nodeLink.isMedia()) { %><a class="editpage" href="media.jsp?mid=<%=nodeLink.mid%>">media <%=nodeLink.mid%></a><% } else if (nodeLink.isRedirect()) { %>node <%=(new Node(application,nodeLink.redirectnid)).label%><% } else if (nodeLink.isUrl()) { %><a class="editpage" target="_blank" href="<%=nodeLink.url%>">url</a><% } } else { %><span class="inactive">inactive</span><% } %></td>
    <td class="tight" width="<%=w6%>" align="center"><% if (nodePerms) { %><a class="editpage" href="javascript:openScheduleWindow(<%=node.nid%>)">schedule</a><% } %></td>
    <td class="tight" width="<%=w7%>" align="center"><% if (nodePerms) { %><a class="editpage" href="javascript:openRenameWindow(<%=node.nid%>)">rename</a><% } %></td>
<% if (!node.isDefault()) { %>
    <td class="tight" width="<%=w8%>" align="center"><% if (nodePerms) { %><a class="editpage" href="javascript:openAliasWindow(<%=node.nid%>)">alias</a><% } %></td>
    <td class="tight" width="<%=w9%>" align="center"><input class="checkbox" type="checkbox" <% if (node.hidden) out.print("checked"); %> <% if (nodePerms) { %>onClick="fetchUrl('node-hide.jsp?nid=<%=node.nid%>')"<% } else { out.print("disabled"); } %> />&nbsp;hide</td>
    <% if (sslHostEnable) { %><td class="tight" width="<%=w9%>" align="center"><input class="checkbox" type="checkbox" <% if (node.ssl) out.print("checked"); %> <% if (nodePerms) { %>onClick="fetchUrl('node-ssl.jsp?nid=<%=node.nid%>')"<% } else { out.print("disabled"); } %> />&nbsp;ssl</td><% } %>
    <td class="tight" width="<%=w10%>" align="center"><% if (nodePerms && !nodeHasChildren) { %><a class="deletenode" href="javascript:deleteNode(<%=node.nid%>)">delete</a><% } %></td>
<% } %>
  </tr>
</table>
<%@ include file="/WEB-INF/include/close.inc" %>
