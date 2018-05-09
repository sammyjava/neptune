<%@ include file="/WEB-INF/include/init.inc" %>
<%        
  // get the requested Page
  int pid = Integer.parseInt(request.getParameter("pid"));
  Page p = new Page(application, pid);
%>
<form action="page.jsp" method="post">
  <input type="hidden" name="pid" value="<%=p.pid%>"/> 
  &nbsp;&nbsp;<b><%=p.pid%> <%=p.label%></b><br/>
  <table class="zapwindow" align="center">
    <tr>
      <td>
        META Keywords<br/>
        <textarea name="metakeywords" rows="1" cols="48"><%=Util.blankIfNull(p.metakeywords)%></textarea>
      </td>
    </tr>
    <tr>
      <td>
        META/RSS Description<br/>
        <textarea name="metadescription" rows="2" cols="48"><%=Util.blankIfNull(p.metadescription)%></textarea>
      </td>
    </tr>
    <tr>
      <td>
        Other HEAD tags<br/>
        <textarea name="othermeta" rows="2" cols="48"><%=Util.blankIfNull(p.othermeta)%></textarea>
      </td>
    </tr>
    <tr>
      <td align="right"><input type="submit" class="update" name="updatemetadata" value="Update META Data"></td>
    </tr>
  </table>
</form>
<%@ include file="/WEB-INF/include/close.inc" %>
