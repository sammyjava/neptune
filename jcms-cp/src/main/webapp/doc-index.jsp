<%@ include file="/WEB-INF/include/init.inc" %>
<% pageTitle = "Docs - Overview"; %>
<%@ include file="/WEB-INF/include/header.jhtml" %>
<%@ include file="/WEB-INF/include/doc-nav.jhtml" %>

<p>
  <b>Welcome to Neptune, <%=user.getFirstname()%>!</b>
</p>

<p>
  This control panel area provides documentation of the tools that are available to you, linked above.
  This overview page explains some of Neptune's general concepts.  If there is anything wrong, missing or simply poorly
  explained in this documentation, please <a href="mailto:support@neptune.ims.net">contact Neptune support</a> and let us know.
</p>

<p>
  <b>Neptune has an administrative permission system.</b><br/>
  Neptune is managed by people in three roles; an individual may be a member of one, two or all three roles.  The roles are:
</p>
<div class="list">
  <b class="editor"><em>Editor</em></b> edits content; most people will be in the editor role only.  Editors can use the Pages, Content, Nodes, Tree and Media tools.  However, editors
  can only manage content which appears on nodes on which they have permission; editor permissions are set by admins with the CP Users tool.
</div>
<div class="list">
  <b class="designer"><em>Designer</em></b> does site design tasks, like edit the stylesheets, create layouts, upload design media and set up utility links.  You'll typically want
  to add your designers to the editor role as well, so that they can enter content and see how it looks.
</div>
<div class="list">
  <b class="admin"><em>Admin</em></b> performs site-wide management tasks, such as managing permissions, controlling access the site, and configuring extensions.  You
  must have at least one member of the admin role.
</div>
<p>
  You will only see the tools for the roles to which you belong.  The tools are color coded to distinguish the roles that use them.
</p>

<p>
  <b>Neptune separates content from presentation.</b><br/>
  The core design concept of Neptune is separation of content from presentation.  You should never have to enter the same content twice,
  even if that content appears in multiple places on your site.  In order to achieve that, content is stored in what we
  call <em>content items</em>, distinct from <em>pages</em>, which are what your browser displays, and <em>nodes</em>, which organize your pages.  Neptune therefore has
  a three-tier heirarchy of nodes, pages and content items, and you can associate any page with any node and any content item with any page.
</p>

<p>
  <b>Pages use layouts to display content items.</b><br/>
  In order to display your content items on a given page, Neptune uses <em>page layouts</em> which consist of one or more <em>content panes</em>. A content pane may hold
  one, and only one, content item.  The simplest layout
  is a single pane on a page, which means you can display only one content item on that page.  However, there are other layouts: narrow left pane
  plus wide right pane; two equal panes over a full-width pane; etc.  These layouts are defined with the Layouts and Stylesheets tools, which are
  available to designers.  (If you are designated as a designer, you will see those tools linked above.)  A common use of multi-pane page layouts is
  to have a narrow column with "callouts" consisting of the same content throughout a section of your site - perhaps some linked logos, or some
  explanatory text.  You only enter that content item once, and then you associate that content item with the given pane on all those pages.
</p>

<p>
  <b>Nodes are used to organize and schedule your pages.</b><br/>
  You build your site navigation using the Nodes tool.  The Nodes tool allows you to create top-level nodes (if you have permission to do so) which appear on the site's
  primary navigation; secondary and tertiary nodes that appear on the site's secondary navigation; and even fourth-level nodes which do not appear on the navigation,
  but can be linked manually.  Pages appear on nodes via <em>scheduling</em>.  You schedule a page to appear on a given node, and you can schedule a different
  page, or perhaps no page, to appear at a later time.  If no page is currently scheduled on a node, that node is currently <em>inactive</em>.
  You can give nodes names, using the <em>rename</em> tool, and those node names appear in the navigation and site map.
  You can create simple URLs for your nodes via <em>aliases</em>.  Nodes can also be <em>hidden</em>: they're still active, ie.
  they have a page associated with them, but they are suppressed from the navigation and site map.  (Fourth-level nodes are hidden due to the fact that they do not
  appear on the site navigation and site map, but we may change that in the future, so do not rely on that to hide pages &mdash; mark them as hidden.)
</p>

<p>
  <b>Use consistent page and content labels.</b><br/>
  The flexibility of a Neptune site makes it imperitive that you label your pages and content items with unique, recognizable labels.  We recommend that you use a naming
  system which takes advantage of the alphabetic ordering of labels within their selectors.  For example, let's say you have an area of your site dedicated
  to Film Noire.  You create a top-level node called "Film Noire" and a secondary node called "Directors".
  We recommend that you use page labels like "Directors - Huston", "Directors - Hitchcock", "Directors - Preminger."
  Perhaps your Film Noire director pages use
  a two-column layout: the left content pane gives a biography of the director, and the right content pane lists the director's films.  Use good labels for the content items
  to keep them straight, such as "Huston - bio" and "Huston - films".  Alphabetic ordering will put those two content items next to each other in the content selector.
  Note that we didn't include the "Directors" prefix.  After all, you may have another area of your site devoted to British knights.  You'll want
  to include Sir Alfred Hitchcock's bio on that area as well! It's up to you, but decide ahead of time on a labeling scheme and be consistent.
</p>

<p>
  <b>Access to nodes may be restricted to certain visitors.</b><br/>
  Neptune has a security system and Access tool which allows admins to create site access roles, associate visitor email/password combinations with those roles, and restrict access to nodes to certain roles.
  The default is that a node has unrestricted, or <em>public</em> access.  If access to a node becomes restricted, it is no longer public, and it disappears from the
  navigation for the general public.  If a visitor logs in with an email/password combination, and belongs to a role that has access to that node,
  it will appear on the navigation and site map, and may be viewed.
</p>

<p>
  <b>Access to media may also be restricted to certain visitors.</b><br/>
  You can use the Media tool to upload media, typically PDF files, to your site.  In addition, you may restrict access to media by role, just as for nodes.  Again, the default for
  uploaded media is public access.  Once you restrict access to one or more roles, the media is no longer accessible by the public.
</p>

<p>
  <b>Extensions are special-purpose code that is place at the top or bottom of a content item.</b><br/>
  Neptune is extended by writing Java classes and JSP that is loaded into content panes.  IMS will likely do that for you, or show one of your developers how to do it.  Extensions provided
  in the core version of Neptune are called "extras."
</p>

<p>
  That's the overview of core Neptune functionality.  For help with each control panel tool, click on the tool name above.
</p>
  


<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/footer.jhtml" %>

