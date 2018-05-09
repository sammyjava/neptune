	  <form method="post">
	    <select name="scid" onChange="submit()">
	      <option value="0">--- select subcategory ---</option>
<%  
NodeListIterator subcategoryIterator = new Node(application,0,n.cid,0).getNodeListIterator(application);
while (subcategoryIterator.hasNext()) {
  Node sc = subcategoryIterator.nextNode();
%>
	      <option <% if (n.scid==sc.scid) out.print("selected"); %> value="<%=sc.scid%>"><%=sc.scnum%> <%=sc.title%></option>
<%
}
%>
	    </select>
	 </form>
