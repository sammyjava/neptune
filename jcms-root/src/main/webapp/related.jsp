<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="net.ims.jcms.*,java.net.URLEncoder" %>
<%
  if (request.getParameter("pid")==null) return;
    
  // instantiate the default access user for node permission check
  AccessUser au = Util.getDefaultAccessUser(application); // default user (public)

  // flag whether access control in use at all
  boolean accessEnabled = AccessRole.nodeCount(application)>0;

  // instantiate from the session, if stored
  if (au.isDefault() && session.getAttribute("AccessUser")!=null) au = (AccessUser)session.getAttribute("AccessUser");
  
  int pid = Util.getInt(request, "pid");
  Page p = new Page(application, pid);
  Page[] related = p.getRelated(application);
  if (related.length==0) return;
%>
<div class="related">
  <%
    for (int i=0; i<related.length; i++) {
        // get current nodes for this page
        Node[] nodes = related[i].getCurrentNodes(application);
        for (int j=0; j<nodes.length; j++) {
            if (!accessEnabled || au.mayAccess(application, nodes[j])) {
      %>
      <div class="related-link"><a class="related-link" href="<%=nodes[j].url%>"><%=nodes[j].nodename%></a></div>
      <%
      }
    }
  }
      %>
</div>

  

