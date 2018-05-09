<%@ include file="/WEB-INF/include/init.inc" %>
<% int extra_id=1; useZapatec=false; %>
<%@ include file="/WEB-INF/include/extra.inc" %>
<%@ include file="/WEB-INF/include/header.jhtml" %>
<%@ include file="/WEB-INF/include/subheader.jhtml" %>
<%
  Content c = new Content(application, Util.getInt(request,"cid"));
  
  // delete a post
  if (request.getParameter("delete")!=null) {
    if (request.getParameter("confirmed")!=null) {
      Comment comment = new Comment(application, Util.getInt(request,"comment_id"));
      message = "Deleted comment "+comment.comment_id+" posted by <b>"+comment.name+"</b> ("+comment.email+") on "+sdf.format(comment.timeposted)+".";
      comment.delete(request);
    } else {
      error = "You must check the box to confirm deletion.";
    }
  }

  if (!c.isDefault() && message==null && error==null) message = "Comments for content item <b>["+c.cid+"] "+c.label+"</b> selected.";

  // get content items with comments for selector
  Content[] content = Comment.getContent(application);
%>
<form method="post">
  <select name="cid" onChange="submit()">
    <option value="0">--- select content ---</option>
    <% for (int i=0; i<content.length; i++) { %><option <% if (c.cid==content[i].cid) out.print("selected"); %> value="<%=content[i].cid%>">[<%=content[i].cid%>] <%=content[i].label%></option><% } %>
  </select>
</form>

<%@ include file="/WEB-INF/include/errormessage.jhtml" %>

<%
  if (!c.isDefault()) {
    // get all the comments
    Comment comments[] = Comment.getAll(application, c.cid);
%>
<table cellspacing="0" cellpadding="3">
  <tr>
    <td width="40" align="right">ID</td>
    <td width="160">Posted</td>
    <td width="250"><b>Name</b></td>
    <td width="250">Email</td>
  </tr>
</table>

<% for (int i=comments.length-1; i>=0; i--) { %>
  <table cellspacing="0" class="borders" bgcolor="#EEEEEE" width="100%">
    <tr>
      <td class="borders" width="40" align="right"><%=comments[i].comment_id%></td>
      <td class="borders" width="160"><%=sdf.format(comments[i].timeposted)%></td>
      <td class="borders" width="250"><b><%=comments[i].name%></b></td>
      <td class="borders" width="250"><%=comments[i].email%></td>
      <td class="borders">
        <form method="post">
          <input type="hidden" name="cid" value="<%=c.cid%>"/>
          <input type="hidden" name="comment_id" value="<%=comments[i].comment_id%>"/>
          <input type="checkbox" name="confirmed" value="true"/>
          <input type="submit" class="delete" name="delete" value="Delete"/>
        </form>
      </td>
    </tr>
    <tr>
      <td colspan="5" bgcolor="#FFFFFF"><%=comments[i].comment%></td>
    </tr>
  </table>
  <% } %>
  <%
  }
  %>
<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/footer.jhtml" %>
