<%@ include file="/WEB-INF/include/init.inc" %>
<% pageTitle = "Role Access"; docUrl="doc-access.jsp"; %>
<%@ include file="/WEB-INF/include/header.jhtml" %>
<%@ include file="/WEB-INF/include/subheader.jhtml" %>
<%
  // get default AccessRole instance for this context
  AccessRole ar = Util.getDefaultAccessRole(application);

  // display access role class with page title
  pageTitle += " ("+ar.getClass().getName()+")";

  // control variables
  boolean updateperms = request.getParameter("nid")!=null;

  try {
    
    // get requested access role
    if (request.getParameter("rolename")!=null && request.getParameter("rolename").trim().length()>0) ar = ar.getAccessRole(application, request.getParameter("rolename"));

    if (updateperms) {
      int nid = Integer.parseInt(request.getParameter("nid"));
      Node n = new Node(application, nid);
      boolean checked = (request.getParameter("checked")!=null);
      if (checked) {
        ar.grantAccess(session, n);
        message = "Role <b>"+ar.getRolename()+"</b> has been granted restricted access to node <b>"+n.label+"</b>.";
      } else {
        ar.revokeAccess(session, n);
        message = "Role <b>"+ar.getRolename()+"</b> has had access to node <b>"+n.label+"</b> revoked.";
      }
      // COMMENTED OUT!!!!  DO SOMETHING HERE!!!!!!
      // DhtmlCache.updateAllAccessUsers(application);
    }

  } catch (Exception ex) {

    error = ex.toString();

  }

  // load the roles for display (if any)
  AccessRole[] roles = Util.getAllAccessRoles(application);
%>
<%@ include file="/WEB-INF/include/errormessage.jhtml" %>

<form method="post">
  <table>
    <tr>
      <td>
        <select name="rolename" onChange="submit()">
          <option value="">--- public ---</option>
            <% for (int i=0; i<roles.length; i++) { %>
            <option <% if (roles[i].equals(ar)) out.print("selected"); %> value="<%=roles[i].getRolename()%>"><%=roles[i].getRolename()%></option>
            <% } %>
        </select>
      </td>
    </tr>
  </table>
</form>

<%
  // load this role's nodes into a Vector for checking permission
  Vector vNodes = ar.getNodes(application);
  // root
  Node root = new Node(application, 0);
  boolean rootPerms = vNodes.contains(root);
  String nodeClass;
  // default role to check unrestricted access
  AccessRole publicRole = ar.getDefault();
  if (publicRole.mayAccess(application, root)) {
    nodeClass = "unrestricted";
  } else if (ar.mayAccess(application, root)) {
    nodeClass = "grantedaccess";
  } else {
    nodeClass = "restricted";
  }
%>
<table>
  <tr>
    <td valign="top">
      <table>
        <tr>
          <td class="tight">
            <% if (!ar.isDefault()) { %>
            <form method="post">
              <input type="hidden" name="rolename" value="<%=ar.getRolename()%>"/>
              <input type="hidden" name="nid" value="<%=root.nid%>"/>
              <input type="checkbox" onClick="submit()" name="checked" <% if (rootPerms) out.print("checked"); %> value="true"/>
            </form>
            <% } %>
          </td>
          <td class="l0 <%=nodeClass%>"><b><%=root.label%> <%=root.nodename%></b></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <%
      // level 1
      NodeListIterator rootIterator = root.getNodeListIterator(application);
      while (rootIterator.hasNext()) {
        Node l1 = rootIterator.nextNode();
        boolean level1Perms = vNodes.contains(l1);
        boolean disable = (rootPerms);
        if (publicRole.mayAccess(application, l1)) {
          nodeClass = "unrestricted";
        } else if (ar.mayAccess(application, l1)) {
          nodeClass = "grantedaccess";
        } else {
          nodeClass = "restricted";
        }
    %>
    <td valign="top">
      <table>
        <tr>
          <td class="tight">
            <% if (!ar.isDefault()) { %>
            <form method="post">
              <input type="hidden" name="rolename" value="<%=ar.getRolename()%>"/>
              <input type="hidden" name="nid" value="<%=l1.nid%>"/>
              <input type="checkbox" onClick="submit()" name="checked" <% if (level1Perms) out.print("checked"); if (disable) out.print(" disabled"); %> value="true"/>
            </form>
            <% } %>
          </td>
          <td class="l1 <%=nodeClass%>"><b><%=l1.label%> <%=l1.nodename%></b></td>
        </tr>
        <%
          // level 2
          NodeListIterator l1Iterator = l1.getNodeListIterator(application);
          while (l1Iterator.hasNext()) {
            Node l2 = l1Iterator.nextNode();
            boolean level2Perms = vNodes.contains(l2);
            disable = (rootPerms || level1Perms);
            if (publicRole.mayAccess(application, l2)) {
              nodeClass = "unrestricted";
            } else if (ar.mayAccess(application, l2)) {
              nodeClass = "grantedaccess";
            } else {
              nodeClass = "restricted";
            }
        %>
        <tr>
          <td class="tight">
              <% if (!ar.isDefault()) { %>
            <form method="post">
              <input type="hidden" name="rolename" value="<%=ar.getRolename()%>"/>
              <input type="hidden" name="nid" value="<%=l2.nid%>"/>
              <input type="checkbox" onClick="submit()" name="checked" <% if (level2Perms) out.print("checked"); if (disable) out.print(" disabled"); %> value="true"/>
            </form>
            <% } %>
          </td>
          <td class="l2 <%=nodeClass%>"><%=l2.label%> <%=l2.nodename%></td>
        </tr>
        <%
          // level 3
          NodeListIterator l2Iterator = l2.getNodeListIterator(application);
          while (l2Iterator.hasNext()) {
            Node l3 = l2Iterator.nextNode();
            boolean level3Perms = vNodes.contains(l3);
            disable = (rootPerms || level1Perms || level2Perms);
            if (publicRole.mayAccess(application, l3)) {
              nodeClass = "unrestricted";
            } else if (ar.mayAccess(application, l3)) {
              nodeClass = "grantedaccess";
            } else {
              nodeClass = "restricted";
            }
        %>
        <tr>
          <td class="tight">
              <% if (!ar.isDefault()) { %>
            <form method="post">
              <input type="hidden" name="rolename" value="<%=ar.getRolename()%>"/>
              <input type="hidden" name="nid" value="<%=l3.nid%>"/>
              <input type="checkbox" onClick="submit()" name="checked" <% if (level3Perms) out.print("checked"); if (disable) out.print(" disabled"); %> value="true"/>
            </form>
            <% } %>
          </td>
          <td class="l3 <%=nodeClass%>"><%=l3.label%> <%=l3.nodename%></td>
        </tr>
        <%
          // level 4
          NodeListIterator l3Iterator = l3.getNodeListIterator(application);
          while (l3Iterator.hasNext()) {
            Node l4 = l3Iterator.nextNode();
            boolean level4Perms = vNodes.contains(l4);
            disable = (rootPerms || level1Perms || level2Perms || level3Perms);
            if (publicRole.mayAccess(application, l4)) {
              nodeClass = "unrestricted";
            } else if (ar.mayAccess(application, l4)) {
              nodeClass = "grantedaccess";
            } else {
              nodeClass = "restricted";
            }
        %>
        <tr>
          <td class="tight">
            <% if (!ar.isDefault()) { %>
            <form method="post">
              <input type="hidden" name="rolename" value="<%=ar.getRolename()%>"/>
              <input type="hidden" name="nid" value="<%=l4.nid%>"/>
              <input type="checkbox" onClick="submit()" name="checked" <% if (level4Perms) out.print("checked"); if (disable) out.print(" disabled"); %> value="true"/>
            </form>
            <% } %>
          </td>
          <td class="l4 <%=nodeClass%>"><%=l4.label%> <%=l4.nodename%></td>
        </tr>
        <%
        } // level 4
      } // level 3
    } // level 2
        %>
      </table>
    </td>
    <%
    } // level 1
    %>
  </tr>
</table>

<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/footer.jhtml" %>
