	  <form method="post">
	    <select name="cid" onChange="submit()">
	      <option value="0">--- select category ---</option>
<%  
NodeListIterator categoryIterator = new Node(application,n.sid,0,0).getNodeListIterator(application);
while (categoryIterator.hasNext()) {
  Node c = categoryIterator.nextNode();
%>
              <option <% if (n.cid==c.cid) out.print("selected"); %> value="<%=c.cid%>"><%=c.cnum%> <%=c.title%></option>
<%
}
%>
	    </select>
          </form>
