<%@ include file="/WEB-INF/include/init.inc" %>
<%
  Page p = new Page(application, Util.getInt(request,"pid"));
  Node[] nodes = p.getNodes(application);
  Layout layout = p.getLayout(application);
%>
<div style="padding:3px;">
  <b><%=p.pid%> <%=p.label%></b>
  Layout <b><%=layout.num%></b>
  Nodes:
  <% if (nodes.length==0) out.print("NONE"); %>
  <% for (int i=0; i<nodes.length; i++) out.print(nodes[i].label+"&nbsp; "); %>
    <br/>
    Head Title: <%=Util.blankIfNull(p.headtitle)%><br/>
    Page Title: <%=Util.blankIfNull(p.title)%><br/>
    created: <%=sdf.format(p.created)%>  <% if (p.updated!=null) { %>updated: <%=sdf.format(p.updated)%><% } %>
</div>
<%@ include file="/WEB-INF/include/close.inc" %>
