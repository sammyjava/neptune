<%@ include file="/WEB-INF/include/init.inc" %>
<% pageTitle = "Docs - Control Panel User Permissions"; %>
<%@ include file="/WEB-INF/include/header.jhtml" %>

<%@ include file="/WEB-INF/include/doc-nav.jhtml" %>

<p>
  The <b>CP Permissions</b> tool allows admins to manage the permissions for site editors, designers and admins.  Neptune has three
  management roles: <span class="editor">editors</span>, <span class="designer">designers</span> and <span class="admin">admins</span>.  Editors have permission to
  edit only certain nodes; those permissions are set on a per-user basis with the CP Permissions tool.
</p>

<p>
  <b>Node permissions.</b><br/>
  If you select an editor (indicated on the selector by [e] after the user's name), you will see a list of nodes with checkboxes.  You grant permission to edit a given
  node by checking the box by that node.  Note that when you do so, the nodes below that node become automatically checked: <em>permissions cascade down to lower nodes</em>.  (Simply
  check the home page node 0 to grant permission to edit the entire site.)
</p>

<p>
  If an editor has permission to edit a node, she may update and delete that node, and create, update and delete child nodes of that node, in the Nodes tool.  She may schedule those nodes, update pages scheduled on those
  nodes, and edit content items that appear on those pages.
</p>

<p>
  <b>Extension permissions.</b><br/>
  Permission to manage extensions, and tools within extensions, is also managed with the Permissions tool.  If you have extensions configured on your site, you will see them listed to the right of the list of nodes
  when you select an editor.  Check an extension to activate permission on that extension; that extension's tool checkboxes will become active, and you can check which of those tools this editor will be able to use.
</p>

<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/footer.jhtml" %>

