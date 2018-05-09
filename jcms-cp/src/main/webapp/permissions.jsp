<%@ include file="/WEB-INF/include/init.inc" %>
<% pageTitle = "Control Panel User Permissions"; docUrl="doc-permissions.jsp"; %>
<%@ include file="/WEB-INF/include/header.jhtml" %>
<%@ include file="/WEB-INF/include/subheader.jhtml" %>
<%

  User u = null;
  ControlPanelUser cpu = null;
  
  // control vars
  boolean updateroles = request.getParameter("updateroles")!=null;
  boolean updatenode = request.getParameter("nid")!=null;
  boolean updateextension = request.getParameter("extid")!=null;
  boolean updateextra = request.getParameter("extra_id")!=null;

  try {
    
    if (request.getParameter("username")!=null && request.getParameter("username").length()>0) {
      u = Util.getUser(application, request.getParameter("username"));
      cpu = new ControlPanelUser(application, u);
    }

    if (updateroles) {
      cpu.editor = request.getParameter("editor")!=null;
      cpu.designer = request.getParameter("designer")!=null;
      cpu.admin = request.getParameter("admin")!=null;
      cpu.update(request);
      message = "User <b>"+u.getUsername()+"</b> roles have been updated. ";
    }
    
    if (updatenode) {
      int nid = Integer.parseInt(request.getParameter("nid"));
      Node n = new Node(application, nid);
      if (request.getParameter("checked")!=null) {
        cpu.addNode(session, n);
        message = "User <b>"+cpu.username+"</b> has been granted edit permission on node <b>"+n.label+"</b>.";
      } else {
        cpu.removeNode(session, n);
        message = "User <b>"+cpu.username+"</b> has had edit permission revoked on node <b>"+n.label+"</b>.";
      }
    }

    if (updateextension) {
      int extid = Integer.parseInt(request.getParameter("extid"));
      Extension e = new Extension(application, extid);
      if (e.extid!=0) {
        if (request.getParameter("checked")!=null) {
          cpu.addExtension(session, e);
          message = "User <b>"+cpu.username+"</b> has been granted permission on extension <b>"+e.name+"</b>.";
        } else {
          cpu.removeExtension(session, e);
          message = "User <b>"+cpu.username+"</b> has had permission revoked on extension <b>"+e.name+"</b>.";
        }
      } else {
        error = "Selected extension does not exist.";
      }
    }

    if (updateextra) {
      int extra_id = Integer.parseInt(request.getParameter("extra_id"));
      Extra e = new Extra(application, extra_id);
      if (request.getParameter("checked")!=null) {
        cpu.addExtra(session, e);
        message = "User <b>"+cpu.username+"</b> has been granted permission on extra <b>"+e.name+"</b>.";
      } else {
        cpu.removeExtra(session, e);
        message = "User <b>"+cpu.username+"</b> has had permission revoked on extra <b>"+e.name+"</b>.";
      }
    }
    
  } catch (Exception ex) {
      
    error = ex.getMessage();
    
  }
  
  // get list of all users for selects
  User[] users = Util.getAllUsers(application);
%>
<%@ include file="/WEB-INF/include/errormessage.jhtml" %>

<table>
  <tr>
    <td valign="bottom">
      <form action="permissions.jsp" method="post">
        <table>
          <tr>
            <td>
              <select name="username" onChange="submit()">
                <option value="">--- select user ---</option>
                <%
                  for (int i=0; i<users.length; i++) {
                      String fullName = users[i].getLastname()+", "+users[i].getFirstname();
                      ControlPanelUser c = new ControlPanelUser(application, users[i]);
                      String perms = "";
                      if (c.editor) perms += "e";
                      if (c.designer) perms += "d";
                      if (c.admin) perms += "a";
                  %>
                  <option <% if (users[i].equals(u)) out.print("selected"); %> value="<%=users[i].getUsername()%>"><%=fullName%> (<%=users[i].getUsername()%>) <%=perms%></option>
                  <%
                  }
                  %>
              </select>
            </td>
          </tr>
        </table>
      </form>
    </td>
    <% if (cpu!=null) { %>
    <td valign="bottom">
      <form method="post">
        <input type="hidden" name="username" value="<%=u.getUsername()%>"/>
        <table>
          <tr>
            <td class="editor">editor</td>
            <td class="designer">designer</td>
            <td class="admin">admin</td>
          </tr>
          <tr>
            <td align="center"><input type="checkbox" name="editor" <% if (cpu.editor) out.print("checked"); %> value="true"/></td>
            <td align="center"><input type="checkbox" name="designer" <% if (cpu.designer) out.print("checked"); %> value="true"/></td>
            <td align="center"><input type="checkbox" name="admin" <% if (cpu.admin) out.print("checked"); %> value="true"/></td>
            <td><input type="submit" class="update" name="updateroles" value="Update Roles"/></td>
          </tr>
        </table>
      </form>
    </td>
    <% } %>
  </tr>
</table>

<% if (u!=null && cpu.editor) { %>

<table>
  <tr>
    <td valign="top" width="400">

      <b>Nodes:</b><br/>
      <table>
        <%
          // load this user's nodes into a Vector for checking permission
          Vector vNodes = cpu.getNodes(application);
          // root
          Node root = new Node(application, 0);
          boolean rootPerms = vNodes.contains(root);
        %>
        <tr>
          <td>
            <form action="permissions.jsp" method="post">
              <input type="hidden" name="username" value="<%=u.getUsername()%>"/>
              <input type="hidden" name="nid" value="<%=root.nid%>"/>
              <input type="checkbox" onClick="submit()" name="checked" <% if (rootPerms) out.print("checked"); %> value="true"/>
            </form>
          </td>
          <td class="l0"><%=root.label%> <%=root.nodename%></td>
        </tr>
        <%
          // level 1
          NodeListIterator rootIterator = root.getNodeListIterator(application);
          while (rootIterator.hasNext()) {
            Node l1 = rootIterator.nextNode();
            boolean level1Perms = vNodes.contains(l1);
            boolean disable = (rootPerms);
        %>
        <tr>
          <td>
            <form action="permissions.jsp" method="post">
              <input type="hidden" name="username" value="<%=u.getUsername()%>"/>
              <input type="hidden" name="nid" value="<%=l1.nid%>"/>
              <input type="checkbox" onClick="submit()" name="checked" <% if (level1Perms) out.print("checked"); if (disable) out.print(" disabled checked"); %> value="true"/>
            </form>
          </td>
          <td class="l1"><%=l1.label%> <%=l1.nodename%></td>
        </tr>
        <%
          // level 2
          NodeListIterator l1Iterator = l1.getNodeListIterator(application);
          while (l1Iterator.hasNext()) {
            Node l2 = l1Iterator.nextNode();
            boolean level2Perms = vNodes.contains(l2);
            disable = (rootPerms || level1Perms);
        %>
        <tr>
          <td>
            <form action="permissions.jsp" method="post">
              <input type="hidden" name="username" value="<%=u.getUsername()%>"/>
              <input type="hidden" name="nid" value="<%=l2.nid%>"/>
              <input type="checkbox" onClick="submit()" name="checked" <% if (level2Perms) out.print("checked"); if (disable) out.print(" disabled checked"); %> value="true"/>
            </form>
          </td>
          <td class="l2"><%=l2.label%> <%=l2.nodename%></td>
        </tr>
        <%
          // level 3
          NodeListIterator l2Iterator = l2.getNodeListIterator(application);
          while (l2Iterator.hasNext()) {
            Node l3 = l2Iterator.nextNode();
            boolean level3Perms = vNodes.contains(l3);
            disable = (rootPerms || level1Perms || level2Perms);
        %>
        <tr>
          <td>
            <form action="permissions.jsp" method="post">
              <input type="hidden" name="username" value="<%=u.getUsername()%>"/>
              <input type="hidden" name="nid" value="<%=l3.nid%>"/>
              <input type="checkbox" onClick="submit()" name="checked" <% if (level3Perms) out.print("checked"); if (disable) out.print(" disabled checked"); %> value="true"/>
            </form>
          </td>
          <td class="l3"><%=l3.label%> <%=l3.nodename%></td>
        </tr>
        <%
          // level 4
          NodeListIterator l3Iterator = l3.getNodeListIterator(application);
          while (l3Iterator.hasNext()) {
            Node l4 = l3Iterator.nextNode();
            boolean level4Perms = vNodes.contains(l4);
            disable = (rootPerms || level1Perms || level2Perms || level3Perms);
        %>
        <tr>
          <td>
            <form action="permissions.jsp" method="post">
              <input type="hidden" name="username" value="<%=u.getUsername()%>"/>
              <input type="hidden" name="nid" value="<%=l4.nid%>"/>
              <input type="checkbox" onClick="submit()" name="checked" <% if (level4Perms) out.print("checked"); if (disable) out.print(" disabled checked"); %> value="true"/>
            </form>
          </td>
          <td class="l4"><%=l4.label%> <%=l4.nodename%></td>
        </tr>
        <%
        } // level 4
      } // level 3
    } // level 2
  } // level 1
        %>
        
      </table>
    </td>
    <td valign="top" width="200">
      
<%
  // get the primary extras
  Extra[] extras = Extra.getPrimary(application);
%>
      <b>Extras:</b><br/>
      <table>
        <%
          for (int i=0; i<extras.length; i++) {
              boolean assigned = cpu.hasPermission(application, extras[i]);
          %>
          <tr>
            <td>
              <form action="permissions.jsp" method="post">
                <input type="hidden" name="username" value="<%=u.getUsername()%>" />
                <input type="hidden" name="extra_id" value="<%=extras[i].extra_id%>" />
                <input type="checkbox" onClick="submit()" name="checked" <% if (assigned) out.print("checked"); %> value="true" />
              </form>
            </td>
            <td colspan="2"><%=extras[i].name%></td>
          </tr>
          <%
            // get the secondary extras for this extras module
            Extra[] children = Extra.getSecondary(application, extras[i].extra_id);
            for (int k=0; k<children.length; k++) {
            %>
            <tr>
              <td></td>
              <td>
                <form action="permissions.jsp" method="post">
                  <input type="hidden" name="username" value="<%=u.getUsername()%>" />
                  <input type="hidden" name="extra_id" value="<%=children[k].extra_id%>" />
                  <input type="checkbox" onClick="submit()" name="checked" <% if (cpu.hasPermission(application, children[k])) out.print("checked"); if (!assigned) out.print(" disabled"); %> value="true" />
                </form>
              </td>
              <td><%=children[k].name%></td>
            </tr>
            <%
            }
          }
            %>
      </table>
    </td>
    <td valign="top">
<%
  // get the primary extensions
  Extension[] primary = Extension.getPrimary(application);
%>
      <b>Extensions:</b><br/>
      <table>
        <%
          for (int i=0; i<primary.length; i++) {
              boolean assigned = cpu.hasPermission(application, primary[i]);
          %>
          <tr>
            <td>
              <form action="permissions.jsp" method="post">
                <input type="hidden" name="username" value="<%=u.getUsername()%>" />
                <input type="hidden" name="extid" value="<%=primary[i].extid%>" />
                <input type="checkbox" onClick="submit()" name="checked" <% if (assigned) out.print("checked"); %> value="true" />
              </form>
            </td>
            <td colspan="2"><%=primary[i].name%></td>
          </tr>
          <%
            // get the secondary extensions for this primary module
            Extension[] secondary = Extension.getSecondary(application, primary[i].extid);
            for (int k=0; k<secondary.length; k++) {
            %>
            <tr>
              <td></td>
              <td>
                <form action="permissions.jsp" method="post">
                  <input type="hidden" name="username" value="<%=u.getUsername()%>" />
                  <input type="hidden" name="extid" value="<%=secondary[k].extid%>" />
                  <input type="checkbox" onClick="submit()" name="checked" <% if (cpu.hasPermission(application, secondary[k])) out.print("checked"); if (!assigned) out.print(" disabled"); %> value="true" />
                </form>
              </td>
              <td><%=secondary[k].name%></td>
            </tr>
            <%
            }
          }
            %>
      </table>
      
    </td>
  </tr>
</table>

<% } %>
    
<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/footer.jhtml" %>

