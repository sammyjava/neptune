<%
} catch (Exception e) {
%>

    <hr/>

    <p class="debug">
    <b><%=e.toString()%></b><br/>
    <%
    StackTraceElement[] ste = e.getStackTrace();
    for (int i=0; i<ste.length; i++) {
      out.print(ste[i]);
      out.println("<br>");
    }
    %>
    </p>
  
<%
} // end try/catch

// clean-up tasks
long endTime = new java.util.Date().getTime();

%>
