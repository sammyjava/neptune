<%
} catch (Exception e) {
%>
<hr/>
<div class="debug">
  <b><%=e.toString()%></b><br/>
  <%
    StackTraceElement[] ste = e.getStackTrace();
    for (int i=0; i<ste.length; i++) out.println(ste[i]+"<br/>");
  %>
</div>
<%
} // end try/catch
%>
