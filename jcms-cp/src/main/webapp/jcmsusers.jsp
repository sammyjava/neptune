<%@ include file="/WEB-INF/include/init.inc" %>
<% int extra_id=11; useZapatec=false; %>
<%@ include file="/WEB-INF/include/extra.inc" %>
<%@ include file="/WEB-INF/include/header.jhtml" %>
<%@ include file="/WEB-INF/include/subheader.jhtml" %>
<%
  // initialize user
  JcmsUser u = new JcmsUser();
  if (request.getParameter("uid")!=null) {
    int uid = Integer.parseInt(request.getParameter("uid"));
    if (uid>0) u = new JcmsUser(application, uid);
  }

  // control flags
  boolean insertuser = request.getParameter("insertuser")!=null;
  boolean updateuser = request.getParameter("updateuser")!=null;
  boolean deleteuser = request.getParameter("deleteuser")!=null;

  try {
    
    // input validation
    String firstname = request.getParameter("firstname");
    String lastname = request.getParameter("lastname");
    String email = request.getParameter("email");
    boolean fieldsComplete = (firstname!=null && firstname.trim().length()>0 &&
    lastname!=null && lastname.trim().length()>0 &&
    email!=null && email.trim().length()>0);
    
    // validate password confirmation against password
    String password = request.getParameter("password");
    String password_confirm = request.getParameter("password_confirm");
    boolean passwordConfirmed = false;
    if (password!=null && password.trim().length()>0 && password_confirm!=null && password_confirm.trim().length()>0) passwordConfirmed = password.equals(password_confirm);
    
    if (insertuser) {
      if (fieldsComplete) {
        if (passwordConfirmed) {
          u.firstname = firstname;
          u.lastname = lastname;
          u.setEmail(email);
          u.setPassword(password);
          u.insert(request);
          message = "New control panel user <b>"+u.firstname+" "+u.lastname+" ("+u.getEmail()+") </b> has been added.";
        } else {
          error = "The password and confirmation password are empty or do not match.";
        }
      } else {
        error = "All fields are required.";
      }
    }
    
    if (updateuser) {
      if (fieldsComplete) {
        u.firstname = firstname;
        u.lastname = lastname;
        u.setEmail(email);
        boolean passwordUpdated = false;
        if (passwordConfirmed) {
          u.setPassword(password);
          passwordUpdated = true;
        } else if (password!=null && password.trim().length()>0) {
          error = "The password and confirmation password are empty or do not match.  Password has NOT been updated.";
        }
        u.update(request);
        message = "Control panel user <b>"+u.firstname+" "+u.lastname+" ("+u.getEmail()+") </b> has been updated. ";
        if (passwordUpdated) message += "<b>Password updated.</b>";
      } else {
        error = "All fields (except password) are required.";
      }
    }
    
    if (deleteuser) {
      if (request.getParameter("confirmed")!=null) {
        message = "Control panel user <b>"+u.firstname+" "+u.lastname+" ("+u.getEmail()+") </b> has been removed. ";
        u.delete(request);
      } else {
        error = "You must check the box to confirm deletion of a control panel user.";
      }
    }
    
  } catch (Exception ex) {
    
    error = ex.getMessage();
    
  }

// get list of all users for selects
JcmsUser[] users = JcmsUser.getAll(application);
%>
<%@ include file="/WEB-INF/include/errormessage.jhtml" %>

    <form method="post">
      <table>
	<tr>
	  <td>
	    <select name="uid" onChange="submit()">
	      <option value="0">--- create user ---</option>
	    <%
	    for (int i=0; i<users.length; i++) {
	      String fullName = users[i].getLastname()+", "+users[i].getFirstname();
	      %>
	      <option <% if (u.equals(users[i])) out.print("selected"); %> value="<%=users[i].uid%>"><%=fullName%> (<%=users[i].getUsername()%>)</option>
	      <%
	      }
	      %>
	    </select>
	  </td>
	</tr>
      </table>
	
      <table>
	<tr>
	  <td valign="bottom">First name<br/><input type="text" name="firstname" <% if (!u.isDefault()) { %>value="<%=u.firstname%>"<% } %> size="16"/></td>
	  <td valign="bottom">Last name<br/><input type="text" name="lastname" <% if (!u.isDefault()) { %>value="<%=u.lastname%>"<% } %> size="16"/></td>
	  <td valign="bottom">Email<br/><input type="text" name="email" <% if (!u.isDefault()) { %>value="<%=u.getEmail()%>"<% } %> size="32"/></td>
	  <td valign="bottom">Password<br/><% if (u!=null) { %>(blank = no change)<br/><% } %><input type="password" name="password" size="16"/></td>
	  <td valign="bottom">Confirm<br/>Password<br/><input type="password" name="password_confirm" size="16"/></td>
	  <% if (u.isDefault()) { %>
	  <td valign="bottom"><input type="submit" class="insert" name="insertuser" value="Create User"/></td>
	  <% } else { %>
	  <td valign="bottom">
	    <input type="submit" class="update" name="updateuser" value="Update User"/>
	    <input type="checkbox" name="confirmed" value="true"/>
	    <input type="submit" class="delete" name="deleteuser" value="Delete User"/>
	  </td>
	  <% } %>
	</tr>
      </table>
    </form>

<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/footer.jhtml" %>
