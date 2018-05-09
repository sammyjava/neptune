<%@ include file="/WEB-INF/include/init.inc" %>
<% pageTitle = "Docs - Nodes"; %>
<%@ include file="/WEB-INF/include/header.jhtml" %>

<%@ include file="/WEB-INF/include/doc-nav.jhtml" %>

<p>
  The <b>Nodes</b> tool is where you build the structure of your site, by creating <em>nodes</em> and <em>scheduling</em> pages to appear on them.  A node is <em>active</em> if there is a
  page currently scheduled on it.  Active nodes appear in your site's navigation, unless they are marked as <em>hidden</em>.  In addition, nodes may be restricted to be viewed only by certain users via the
  Access tool.
</p>

<p>
  Nodes have four levels of depth (not including the home page, which is always node 0).  The primary level, labeled with single numbers like 1, 2, etc., is linked on the site's primary navigation.
  You should restrict the number of primary nodes to less than ten, preferably five or six.  (Visitors will be confused by a large number of nodes in your site's primary navigation.)
  The secondary level, labeled with numbers like 1.1 or 3.2, is linked on the site's secondary
  navigation, as are tertiary nodes, which are labeled like 1.1.3 or 3.2.4.  The quaternary node level, labeled like 1.1.3.1 or 3.2.4.3, is not currently linked on the site's navigation, but we may change that in the future.
  You may link quaternary pages manually, and they are shown on the Site Map.
</p>

<p>
  <b>Node creation.</b><br/>
  Nodes are created by clicking a node creation link, shown in brackets.  For example, if you click the [2] link on the node 1 row, you will create a new node 2.  The former node 2 will become node 3, and so on.
  This is an example of creating a <em>sibling</em> node (nodes 1 and 2 are siblings, since they are at the same level, primary in this case).  You can also create a <em>child</em> node: for example, if you click the [1.1]
  link on the node 1 row, you will create a new secondary node 1.1.  The former node 1.1 will become node 1.2, and so on.
</p>

<p>
  <b>Moving nodes.</b><br/>
  Nodes may be moved <em>within the same level</em> by clicking the up (<b>&uarr;</b>) and down (<b>&darr;</b>) arrows.  Note that you cannot move a node to higher or deeper level, since it wouldn't be clear what to do with that node's
  sibling and child nodes.  (If you want a page to appear on a node higher or deeper in the node hierarchy, simply create a new node and schedule that page to appear on it.)
</p>

<p>
  <b>Renaming nodes.</b><br/>
  Nodes can, and should, be <em>renamed</em>.  After clicking the rename link, enter the new node name in the rename window and click the Rename Node button.  Note that you can give two nodes the same name.  You should
  never give two primary nodes the same name; there may be good reasons to give deeper nodes the same name, like "archive" or "contact".
</p>

<p>
  <b>Deleting nodes.</b><br/>
  Nodes may be deleted only if they have no children.  In this case, a delete link appears at the end of the node entry.  If you wish to delete a node that has children, you must delete each child before you may delete the parent node.
</p>

<p>
  <b>Aliases.</b><br/>
  Node URLs can have user-friendly <em>aliases</em>.  If you plan to link a node in some external document, like a newsletter or email, you should use an alias.  Aliases are generally a good idea, since they provide
  consistent, search engine-friendly URLs.  Say, for example, you have a primary node called "Company"; you might assign that node the alias "company", so that people can load that node by typing "http://yourdomain.com/company"
  into their browser.  You might also assign aliases to secondary nodes under Company like "company/history", "company/staff", "company/directors" and so on.
</p>

<p>
  <b>Scheduling.</b><br/>
  Nodes are active when they have pages or other content currently associated with them through <em>scheduling</em>.  Scheduling is an important core concept of Neptune: the structure and content of your site changes with the passage
  of time.  Click the schedule link to pull up the schedule window for a particular node.  You will see several columns: link, id, label and start.  The link column identifies which type of content is scheduled on the
  node.  Most of the time, it will be a page; but you may also schedule an uploaded media file to be linked by a node, enter a URL to be linked by a node, or redirect node requests to a child of this node.  Your pages,
  identified by their label, appear in the page selector &mdash; to schedule one on this node, simply select it, enter a date/time in the date field (or leave it blank to schedule it to appear immediately), and click
  the Insert button.  You will be returned to the Nodes tool.  If you wish to make a node inactive at some time, simply leave the content selectors alone ("no page", etc.) in the schedule window,
  enter the date/time you'd like the node to go inactive (or blank to make it inactive immediately) and press Insert.  The schedule window shows a color-coded list of entries which have <span class="expired">expired</span>,
  that which is <span class="active">currently active</span>, and those which <span class="future">will appear</span> on a given node.  You may remove an entry that starts in the future by clicking on the delete link.
</p>

<p>
  The nodes tool shows which page, or other schedule entry, is currently active on each node.  The page is linked to take you to the page editor for that page.  This is a handy way, in addition to the Tree view, to find
  a given page via your site's navigational structure.
</p>

<p>
  <b>Hidden nodes.</b><br/>
  You may suppress active nodes from appearing on your site's navigation, and site map, by checking the "hide" checkbox.  This simply removes the node from navigation; visitors will still be able to view it (unless it has
  restricted access via the Access tool).  This is handy if you want to use "security by obscurity" to allow folks to view a page that you link, say, in an email, or if you'd like to link some nodes manually in your
  content rather than in the site-generated navigation.
</p>


<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/footer.jhtml" %>

