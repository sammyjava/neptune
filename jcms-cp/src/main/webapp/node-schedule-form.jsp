<%@ include file="/WEB-INF/include/init.inc" %>
<%
  /**
  * Displays the node scheduling form
  */
  
  // get the requested Node
  int nid = Integer.parseInt(request.getParameter("nid"));
  Node n = new Node(application, nid);
  if (n.isDefault() && n.label==null) return;
  
  // get this node's pages
  NodeLink[] nodelinks = n.getNodeLinks(application);

  // get an array of pages for selector
  Page[] pages = Page.getAll(application);

  // get an array of media for selector
  Media[] media = Media.getAll(application);

  // get the node's children, we can only redirect down to the direct children
  NodeListIterator childIterator =   n.getChildren(application).getNodeListIterator();

  // current time for comparisons
  java.sql.Timestamp currentTimestamp = DB.getCurrentTimestamp(application);
%>

<h3><%=n.label%> <%=n.nodename%></h3>

<table class="tight">
  <tr>
    <td width="50"><b>link</b></td>
    <td width="20" align="right"><b>id</b></td>
    <td width="450"><b>label</b></td>
    <td width="150"><b>start</b></td>
    <td width="50"></td>
  </tr>
  <tr>
    <td colspan="5"><hr/></td>
  </tr>
  <%
    if (nodelinks!=null) {
      for (int i=0; i<nodelinks.length; i++) {
          String linktype = "";
          String linkid = "";
          String linklabel = "NONE";
          if (nodelinks[i].isPage()) {
            Page p = nodelinks[i].getPage(application);
            linktype = "Page";
            linkid = "<b>"+p.pid+"</b>";
            linklabel = p.label;
          } else if (nodelinks[i].isMedia()) {
            Media m = nodelinks[i].getMedia(application);
            linktype = "Media";
            linkid = "<b>"+m.mid+"</b>";
            linklabel = m.filename;
          } else if (nodelinks[i].isRedirect()) {
            Node r = nodelinks[i].getRedirectNode(application);
            linktype = "Redirect";
            linkid = "<b>"+r.nid+"</b>";
            linklabel = r.label+" "+r.nodename;
          } else if (nodelinks[i].isUrl()) {
            linktype = "URL";
            linklabel = nodelinks[i].url;
          }
          String status = null;
          if (nodelinks[i].expired(application)) {
            status = "expired";
          } else if (nodelinks[i].active(application)) {
            status = "active";
          } else {
            status = "future";
          }
    %>
    <tr>
      <td class="<%=status%>"><%=linktype%></td>
      <td class="<%=status%>" align="right"><%=linkid%></td>
      <td class="<%=status%>"><%=linklabel%></td>
      <td class="<%=status%>"><%=nodelinks[i].getStartTimeString(application)%></td>
      <td>
        <% if (nodelinks[i].starttime.after(currentTimestamp)) { %>
        <a href="node-schedule.jsp?scheduledelete&nid=<%=nid%>&nlid=<%=nodelinks[i].nlid%>">delete</a>
        <% } %>
      </td>
    </tr>
    <%
    } // end for
  } // end if
    %>
    <tr>
      <td colspan="5"><hr/></td>
    </tr>
</table>

<form action="node-schedule.jsp" class="zpForm" id="userForm" method="get">
  <input type="hidden" name="nid" value="<%=nid%>"/>
  <input type="hidden" name="scheduleinsert" value="true"/>
  <table class="tight">
    <tr>
      <td width="50">Page</td>
      <td width="450">
        <select name="pid">
          <option value="0">--- no page ---</option>
          <% for (int i=0; pages!=null && i<pages.length; i++) { %>
            <option value="<%=pages[i].pid%>"><%=pages[i].label%> <%=pages[i].pid%> <% if (pages[i].isOrphan(application)) out.print("[orphan]"); %></option>
          <% } %>
        </select>
      </td>
      <td><input type="text" size="20" name="starttime"/></td>
      <td><input type="submit" class="insert" value="Insert"/></td>
    </tr>
    <tr>
      <td>Media</td>
      <td>
        <select name="mid">
          <option value="0">--- no media ---</option>
          <% for (int i=0; media!=null && i<media.length; i++) { %>
            <option value="<%=media[i].mid%>"><%=media[i].filename%> (<%=media[i].mid%>) <% if (media[i].isOrphan(application)) out.print("[orphan]"); %></option>
            <% } %>
        </select>
      </td>
    </tr>
    <tr>
      <td>URL</td>
      <td><input type="text" name="url" size="48" /></td>
    </tr>
    <tr>
      <td>Redirect</td>
      <td>
        <select name="redirectnid">
          <option value="0">--- no redirect ---</option>
          <%
            while (childIterator.hasNext()) {
              Node child = (Node)(childIterator.next());
          %>
          <option value="<%=child.nid%>"><%=child.label%> <%=child.nodename%></option>
          <%
          }
          %>
        </select>
      </td>
    </tr>
  </table>
</form>
<script type="text/javascript">
    // Run this to auto-activate all "zpForm" class forms in the document.
    Zapatec.Form.setupAll({
      showErrors: 'afterField',
      showErrorsOnSubmit: true,
      asyncSubmitFunc: onSuccess,
      submitErrorFunc: onError,
      <% if (debug) { %>ajaxDebugFunc: showDebug,<% } %>
      busyConfig: {
        busyContainer: "userForm"
      }
    });
</script>
<%@ include file="/WEB-INF/include/close.inc" %>
