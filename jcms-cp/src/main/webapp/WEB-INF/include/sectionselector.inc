	  <form method="post">
	    <select name="sid" onChange="submit()">
	      <option value="0">--- select section ---</option>
<%
NodeListIterator sectionIterator = new Node().getNodeListIterator(application);
while (sectionIterator.hasNext()) {
  Node s = sectionIterator.nextNode();
%>
              <option <% if (n.sid==s.sid) out.print("selected"); %> value="<%=s.sid%>"><%=s.snum%> <%=s.title%></option>
<%
}
%>
	    </select>
	  </form>
