<%@ include file="/WEB-INF/include/init.inc" %>
<% pageTitle = "Docs - Headlines"; %>
<%@ include file="/WEB-INF/include/header.jhtml" %>
<%@ include file="/WEB-INF/include/doc-nav.jhtml" %>

<p>
  The <b>Headlines Extra</b> allows you to display navigation to a set of nodes within a content item with custom styling, as if you'd pulled a section out of the secondary navigation and placed it on the content
  area of the page.  The main intent of the Headlines Extra is to display nodes that happen to be related articles under a parent "landing" page.  For example, suppose you had 20 articles under
  a node entitled "Water Conservation."  You can link those articles, along with descriptions, on the Water Conservation page using the Headlines Extra.
</p>

<p>
  There are a few settings which control how the Headlines Extra behaves:
</p>

<table>
  <tr><td><b>setting</b></td><td><b>default</b></td><td><b>description</b></td></tr>
  <tr><td>headlines_showdescription</td><td>false</td><td>Show page meta description under headline (true/false)</td></tr>
  <tr><td>headlines_readmore</td><td>read more...</td><td>Text for the "Read more" link at the end of the description</td></tr>
  <tr><td>headlines_showhidden</td><td>false</td><td>Include hidden node headlines (true/false)</td></tr>
  <tr><td>headlines_showpagetitle</td><td>false</td><td>Show page title rather than node name as headline (true/false)</td></tr>
</table>

<p>
  If you choose to display page meta descriptions under the headlines by toggling on <b>headlines_showdescription</b>, you must be sure to enter meta descriptions on all of the relevant pages.  (Of course, it's
  a good practice to enter meta descriptions for ALL of your pages.)  If you want to use the Headlines extra to exclusively link some nodes, you should toggle on <b>headlines_showhidden</b> and toggle those nodes
  to be hidden in the Nodes tool.  You can also opt to display the page title as the headline rather than the node name by toggling on <b>headlines_showpagetitle</b>.
</p>

<p>
  To display the children of a particular node as headlines using the Headlines extra, first go to the Tree tool and find the node ID, shown in brackets, of the parent node.  Let's say our parent node entitled Water Conservation has
  [123].  Then, to display this node's children as headlines in a content item, you enter <b>/</b> as the extension context and, in this example, <b>/headlines.jsp?nid=123</b> as the extension URL.  That content item will
  now list the child node headlines formatted according to your headlines_* settings, and styled according to the headlines stylesheet.
</p>

<p>
  There is also a <b>Headlines RSS feed</b> which displays the given headlines in an RSS XML file.  That is given, in this example, by the URL <b>/headlines-rss.jsp?nid=123</b>.  Feel free to link the Headlines RSS feed with an
  RSS icon on your parent page.
</p>

<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/footer.jhtml" %>
