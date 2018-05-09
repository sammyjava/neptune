<%@ include file="/WEB-INF/include/init.inc" %>
<% pageTitle = "Tree"; useZapatec=true; docUrl="doc-tree.jsp"; %>
<%@ include file="/WEB-INF/include/header.jhtml" %>
<%@ include file="/WEB-INF/include/subheader.jhtml" %>
<script type="text/javascript">
    // the page info window
    var pwin = new Zapatec.Window({
      theme: 'plain',
      showMaxButton: false,
      showMinButton: false
    });
    pwin.setPosition(100, 0);
    pwin.setSize(500, 50);
    pwin.create();
      
    // show the window with the page info
    function openPageWindow(pid) {
      pwin.setContentUrl('pageinfo.jsp?pid='+pid);
      pwin.show();
    }
</script>
<%@ include file="/WEB-INF/include/errormessage.jhtml" %>

<table class="tree" align="center">
  <%
    // root
    Node root = new Node(application, 0);
    NodeListIterator rootIterator = root.getNodeListIterator(application);
    String label0 = root.num+"/";
    if (root.alias!=null) label0 += root.alias;
    int cols = root.numChildren(application);
    int width = 100/cols;
    NodeLink rootLink = root.getCurrentNodeLink(application);
    String linkClass = "tree";
    if (rootLink.isPage()) {
      Page p = new Page(application, rootLink.pid);
      if (cpuser.hasPermission(application, p)) linkClass += " permission";
    } else {
      if (cpuser.hasPermission(application, root)) linkClass += " permission";
    }
  %>
  <tr>
    <td class="tree" colspan="<%=cols%>">
      <% if (rootLink==null) { %>
      <b><%=label0%></b>
      <% } else if (rootLink.isPage()) { %>
      <a class="<%=linkClass%>" href="page.jsp?pid=<%=rootLink.pid%>" onMouseOver="openPageWindow(<%=rootLink.pid%>)" onMouseOut="pwin.hide()"><b><%=label0%></b></a> [n<%=root.nid%>] [p<%=rootLink.pid%>]
      <% } else { %>
      <a class="<%=linkClass%>" href="<%=rootLink.getUrl(application)%>"><%=label0%></a> [n<%=root.nid%>]
      <% } %>
      <%=root.nodename%>
    </td>
  </tr>
  <tr>
    <%
      // level 1
      while (rootIterator.hasNext()) {
        Node level1 = rootIterator.nextNode();
        NodeListIterator level1Iterator = level1.getNodeListIterator(application);
        String label1 = level1.num+"";
        if (level1.alias!=null) label1 += "/"+level1.alias;
        NodeLink level1Link = level1.getCurrentNodeLink(application);
        linkClass = "tree";
        if (level1Link!=null) {
          if (level1Link.isPage()) {
            Page p = new Page(application, level1Link.pid);
            if (cpuser.hasPermission(application, p)) linkClass += " permission";
          } else {
            if (cpuser.hasPermission(application, level1)) linkClass += " permission";
          }
        }
    %>
    <td class="tree" valign="top" width="<%=width%>%">
      <% if (level1Link==null) { %>
      <b class="inactive"><%=label1%></b>
      <% } else if (level1Link.isPage()) { %>
      <a class="<%=linkClass%>" href="page.jsp?pid=<%=level1Link.pid%>" onMouseOver="openPageWindow(<%=level1Link.pid%>)" onMouseOut="pwin.hide()"><b><%=label1%></b></a> [n<%=level1.nid%>][p<%=level1Link.pid%>]
      <% } else if (level1Link.isRedirect()) { Node rnode = level1Link.getRedirectNode(application); %>
      <%=label1%> - redirect to Node <%=rnode.label%> -
      <% } else { %>
      <a class="<%=linkClass%>" href="<%=level1Link.getUrl(application)%>"><%=label1%></a> [n<%=level1.nid%>]
      <% if (level1Link.isMedia()) out.print("- media file -"); %>
      <% if (level1Link.isUrl()) out.print("- URL -"); %>
      <% } %>
      <%=level1.nodename%>
      <hr/>
      <%
        // level 2
        while (level1Iterator.hasNext()) {
          Node level2 = level1Iterator.nextNode();
          NodeListIterator level2Iterator = level2.getNodeListIterator(application);
          String label2 = level1.num+"."+level2.num;
          if (level2.alias!=null) label2 += "/"+level2.alias;
          NodeLink level2Link = level2.getCurrentNodeLink(application);
          linkClass = "tree";
          if (level2Link!=null) {
            if (level2Link.isPage()) {
              Page p = new Page(application, level2Link.pid);
              if (cpuser.hasPermission(application, p)) linkClass += " permission";
            } else {
              if (cpuser.hasPermission(application, level2)) linkClass += " permission";
            }
          }
      %>
      <% if (level2Link==null) { %>
      <span class="inactive"><%=label2%></span>
      <% } else if (level2Link.isPage()) { %>
      <a class="<%=linkClass%>" href="page.jsp?pid=<%=level2Link.pid%>" onMouseOver="openPageWindow(<%=level2Link.pid%>)" onMouseOut="pwin.hide()"><b><%=label2%></b></a> [n<%=level2.nid%>][p<%=level2Link.pid%>]
      <% } else if (level2Link.isRedirect()) { Node rnode = level2Link.getRedirectNode(application); %>
      <%=label2%> - redirect to Node <%=rnode.label%> -
      <% } else { %>
      <a class="<%=linkClass%>" href="<%=level2Link.getUrl(application)%>"><%=label2%></a> [n<%=level2.nid%>]
      <% if (level2Link.isMedia()) out.print("- media file -"); %>
      <% if (level2Link.isUrl()) out.print("- URL -"); %>
      <% } %>
      <%=level2.nodename%><br/>
      <table>
        <tr>
          <%
            // level 3
            while (level2Iterator.hasNext()) {
              Node level3 = level2Iterator.nextNode();
              NodeListIterator level3Iterator = level3.getNodeListIterator(application);
              String label3 = level1.num+"."+level2.num+"."+level3.num;
              if (level3.alias!=null) label3 += "/"+level3.alias;
              NodeLink level3Link = level3.getCurrentNodeLink(application);
              linkClass = "tree";
              if (level3Link!=null) {
                if (level3Link.isPage()) {
                  Page p = new Page(application, level3Link.pid);
                  if (cpuser.hasPermission(application, p)) linkClass += " permission";
                } else {
                  if (cpuser.hasPermission(application, level3)) linkClass += " permission";
                }
              }
          %>
          <td class="tree" valign="top">
            <% if (level3Link==null) { %>
            <span class="inactive"><%=label3%></span>
            <% } else if (level3Link.isPage()) { %>
            <a class="<%=linkClass%>" href="page.jsp?pid=<%=level3Link.pid%>" onMouseOver="openPageWindow(<%=level3Link.pid%>)" onMouseOut="pwin.hide()"><b><%=label3%></b></a> [n<%=level3.nid%>][p<%=level3Link.pid%>]
            <% } else if (level3Link.isRedirect()) { Node rnode = level3Link.getRedirectNode(application); %>
            <%=label3%> - redirect to Node <%=rnode.label%> -
            <% } else { %>
            <a class="<%=linkClass%>" href="<%=level3Link.getUrl(application)%>"><%=label3%></a> [n<%=level3.nid%>]
            <% if (level3Link.isMedia()) out.print("- media file -"); %>
            <% if (level3Link.isUrl()) out.print("- URL -"); %>
            <% } %>
            <%=level3.nodename%>
            <%
              // level 4
              while (level3Iterator.hasNext()) {
                Node level4 = level3Iterator.nextNode();
                String label4 = level1.num+"."+level2.num+"."+level3.num+"."+level4.num;
                if (level4.alias!=null) label4 += "/"+level4.alias;
                NodeLink level4Link = level4.getCurrentNodeLink(application);
                linkClass = "tree";
                if (level4Link!=null) {
                  if (level4Link.isPage()) {
                    Page p = new Page(application, level4Link.pid);
                    if (cpuser.hasPermission(application, p)) linkClass += " permission";
                  } else {
                    if (cpuser.hasPermission(application, level4)) linkClass += " permission";
                  }
                }
            %>
            <br/><% if (level4Link==null) { %>
            <span class="inactive"><%=label4%></span>
            <% } else if (level4Link.isPage()) { %>
            <a class="<%=linkClass%>" href="page.jsp?pid=<%=level4Link.pid%>" onMouseOver="openPageWindow(<%=level4Link.pid%>)" onMouseOut="pwin.hide()"><b><%=label4%></b></a> [n<%=level4.nid%>][p<%=level4Link.pid%>]
            <% } else if (level4Link.isRedirect()) { Node rnode = level4Link.getRedirectNode(application); %>
            <%=label4%> - redirect to Node <%=rnode.label%> -
            <% } else { %>
            <a class="<%=linkClass%>" href="<%=level4Link.getUrl(application)%>"><%=label4%></a> [n<%=level4.nid%>]
            <% if (level4Link.isMedia()) out.print("- media file -"); %>
            <% if (level4Link.isUrl()) out.print("- URL -"); %>
            <% } %>
            <%=level4.nodename%>
            <%
            } // level 4
            %>
          </td>
          <%
          } // level 3
          %>
        </tr>
      </table>
      <hr/>
      <%
      } // level 2
    } // level 1
      %>
    </td>
  </tr>
</table>

<b>Orphaned Pages</b><br/>
<%
  int[] orphanPids = Page.getOrphanPids(application);
  for (int i=0; i<orphanPids.length; i++) {
  %>
  <a class="tree" href="page.jsp?pid=<%=orphanPids[i]%>" onMouseOver="openPageWindow(<%=orphanPids[i]%>)" onMouseOut="pwin.hide()"><%=orphanPids[i]%></a>
  <%
  }
  %>

<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/footer.jhtml" %>
