<%@ include file="/WEB-INF/include/init.inc" %>
<% pageTitle = "Docs - Access"; %>
<%@ include file="/WEB-INF/include/header.jhtml" %>

<%@ include file="/WEB-INF/include/doc-nav.jhtml" %>

<p>
  The <b>Access</b> tool allows admins to restrict certain nodes to be viewable only by chosen visitor <em>roles</em>.  Visitors authenticate by entering
  their email address and password on the access login form, which appears if they visit a restricted page and are not authenticated.  The Access tool has
  two parts: the Roles tool and the Users tool.
</p>

<p>
  <b>Creating a role.</b><br/>
  In order to restrict access to a node, you must first create a role.  This is done in the Roles tool.  Enter a name for the role in the text field,
  and click the Add Role button.  Once an access role is created, you will see a list of nodes, along with checkboxes.  You may also update an access role
  name, or delete an access role.  (Note that deleting an access role does not remove users that are members of that role; the only way to remove an access
  user is to remove them directly on the Users tool.)
</p>

<p>
  <b>Restricting access.</b><br/>
  In the Roles tool, select an access role.  You will see a list of nodes, along with checkboxes.  When you click a checkbox, you restrict access to that node to
  members of the currently selected role.  If a node has no restrictions, it is publicly viewable.  Color coding is used to denote nodes that are:
  <span class="unrestricted">public</span>,
  <span class="grantedaccess">restricted to the currently selected role</span>, and <span class="restricted">restricted to other roles</span>.  You may restrict
  a node to more than one role: if you check the box next to a node restricted to other roles, the page will return with that node checked, indicating that the
  currently selected role now has access to it.
</p>

<p>
  <b>Creating access users and assigning roles.</b><br/>
  You create access users in the Users tool.  The default form allows you to enter a new user's email address and password.  Do so, and click the Add User button.  (Passwords
  must have at least six characters and at least one number and letter.)  After the user is added, you will see the list of nodes on the left, and the list of roles on the right.
  The node list shows which nodes the current user has access to, either public or <span class="grantedaccess">restricted to the user's roles</span>; as well as nodes that
  are <span class="restricted">restricted to other roles</span>.  Click on a role to
  add the current user to that role, and thereby allow the user to access nodes which are restricted to that role.
</p>

<p>
  You may update a user's email address and password without affecting his or her role membership.  Note that removing a user has no effect on roles.
</p>
  
  


<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/footer.jhtml" %>

