<%@ include file="/WEB-INF/include/init.inc" %>
<% pageTitle = "Extensions"; docUrl="doc-extensions.jsp"; %>
<%@ include file="/WEB-INF/include/header.jhtml" %>
<%@ include file="/WEB-INF/include/subheader.jhtml" %>
<%

  // control variables
  boolean insert = (request.getParameter("insert")!=null);
  boolean update = (request.getParameter("update")!=null);
  boolean delete = (request.getParameter("delete")!=null);
  
  try {

    if (insert) {
      Extension e = new Extension();
      e.num = Integer.parseInt(request.getParameter("num"));
      e.name = request.getParameter("name");
      e.cpcontext = request.getParameter("cpcontext");
      e.cpurl = request.getParameter("cpurl");
      e.parent_extid = Integer.parseInt(request.getParameter("parent_extid"));
      e.insert(request);
      message = "New extension <b>"+e.name+"</b> added.";
    }
    
    if (update) {
      int extid = Integer.parseInt(request.getParameter("extid"));
      Extension e = new Extension(application, extid);
      e.num = Integer.parseInt(request.getParameter("num"));
      e.name = request.getParameter("name");
      e.cpcontext = request.getParameter("cpcontext");
      e.cpurl = request.getParameter("cpurl");
      e.parent_extid = Integer.parseInt(request.getParameter("parent_extid"));
      e.update(request);
      message = "Extension <b>"+e.name+"</b> updated.";
    }

    if (delete) {
      if (request.getParameter("confirmed")!=null) {
        int extid = Integer.parseInt(request.getParameter("extid"));
        Extension e = new Extension(application, extid);
        message = "Extension <b>"+e.name+"</b> removed.";
        e.delete(request);
      } else {
        error = "You must check the box to confirm deletion.";
      }
    }

  } catch (ValidationException e) {
    error = e.getMessage();
  } catch (NumberFormatException e) {
    error = "Please supply an ordering number.";
  } catch (org.postgresql.util.PSQLException e) {
    error = e.getMessage();
  }

%>

<%@ include file="/WEB-INF/include/errormessage.jhtml" %>

<%
  // get the primary extensions
  Extension[] primary = Extension.getPrimary(application);
%>

  <form method="post">
    <table>
      <tr>
        <td valign="bottom">Num<br/><input type="text" name="num" size="3"/></td>
        <td valign="bottom">Name<br/><input type="text" name="name" size="24"/></td>
        <td valign="bottom">CP Context<br/><input type="text" name="cpcontext" size="32"/></td>
        <td valign="bottom">CP URL<br/><input type="text" name="cpurl" size="32"/></td>
        <td valign="bottom" align="center">
          Parent<br/>
          <select name="parent_extid">
            <option value="0">--- primary module ---</option>
              <% for (int j=0; j<primary.length; j++) { %>
              <option value="<%=primary[j].extid%>"><%=primary[j].name%></option>
              <% } %>
          </select>
        </td>
        <td valign="bottom"><input type="submit" class="insert" name="insert" value="Insert"/></td>
      </tr>
    </table>
  </form>

<% for (int i=0; i<primary.length; i++) { %>
  
  <form method="post">
    <input type="hidden" name="extid" value="<%=primary[i].extid%>" />
    <table>
      <tr>
        <td colspan="6"><hr/></td>
      </tr>
      <tr>
        <td valign="bottom"><input type="text" name="num" size="3" value="<%=primary[i].num%>" /></td>
        <td valign="bottom"><input type="text" name="name" size="24" value="<%=primary[i].name%>" /></td>
        <td valign="bottom"><input type="text" name="cpcontext" size="32" value="<%=primary[i].cpcontext%>" /></td>
        <td valign="bottom"><input type="text" name="cpurl" size="32" value="<%=primary[i].cpurl%>" /></td>
        <td valign="bottom" align="center">
          <select name="parent_extid">
            <option value="0">--- primary module ---</option>
            <%
              for (int j=0; j<primary.length; j++) { 
                  if (primary[i].extid!=primary[j].extid) {
              %>
              <option <% if (primary[i].parent_extid==primary[j].extid) out.print("selected"); %> value="<%=primary[j].extid%>"><%=primary[j].name%></option>
              <%
              }
            }
              %>
          </select>
        </td>
        <td valign="bottom">
          <input type="submit" class="update" name="update" value="Update" />
          <input type="checkbox" name="confirmed" value="true" />
          <input type="submit" class="delete" name="delete" value="Delete" />
        </td>
      </tr>
    </table>
  </form>
  <%
    // get the secondary extensions for this primary module
    Extension[] secondary = Extension.getSecondary(application, primary[i].extid);
    for (int k=0; k<secondary.length; k++) {
    %>
    <form method="post">
      <input type="hidden" name="extid" value="<%=secondary[k].extid%>" />
    <table>
      <tr>
        <td valign="bottom"><input type="text" name="num" size="3" value="<%=secondary[k].num%>" /></td>
        <td valign="bottom"><input type="text" name="name" size="24" value="<%=secondary[k].name%>" /></td>
        <td valign="bottom"><input type="text" name="cpcontext" size="32" value="<%=secondary[k].cpcontext%>" /></td>
        <td valign="bottom"><input type="text" name="cpurl" size="32" value="<%=secondary[k].cpurl%>" /></td>
        <td valign="bottom" align="center">
          <select name="parent_extid">
            <option value="0">--- primary module ---</option>
                <% for (int j=0; j<primary.length; j++) { %>
                <option <% if (secondary[k].parent_extid==primary[j].extid) out.print("selected"); %> value="<%=primary[j].extid%>"><%=primary[j].name%></option>
                <% } %>
            </select>
          </td>
          <td valign="bottom">
            <input type="submit" class="update" name="update" value="Update" />
            <input type="checkbox" name="confirmed" value="true" />
            <input type="submit" class="delete" name="delete" value="Delete" />
          </td>
        </tr>
      </table>
    </form>
    <%
    }
    %>

  <% } %>

  
<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/footer.jhtml" %>
