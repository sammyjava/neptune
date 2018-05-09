<%@ include file="/WEB-INF/include/init.inc" %>
<% pageTitle = "Docs - Stylesheet"; %>
<%@ include file="/WEB-INF/include/header.jhtml" %>

<%@ include file="/WEB-INF/include/doc-nav.jhtml" %>

<p>
  Like everything in Neptune, your site's stylesheet is completely managed here on the control panel, with the Stylesheet tool.  The stylesheet is broken up into design areas, for convenience.
  <a target="_blank" href="stylesheet-classes.png"><b>Click here</b></a> for a diagram of the stylesheet classes, described below.
</p>

<p>
  Your site consists of up to six stacked regions, surrounded by a single div#container, located in the body section, which contains all of the core HTML tags.  All of the regions are tables, given by
  classes like table#header and cells like td.header.  <a target="_blank" href="utility-classes.png"><b>Click here</b></a> for a diagram of the styling classes used in the utility regions.
</p>

<ol>
  <li><b>header</b> (table#header)</li>
  <li><b>primary nav</b> (table#navpri)</li>
  <li><b>section header</b> (table#sectionheader)</li>
  <li><b>subheader</b> (table#subheader)</li>
  <li>
    <b>main</b> (table#main)<br/>
    <table>
      <tr>
        <td>
          td#main-left<br/>
          <b>top sidebar</b><br/>
          <b>secondary navigation</b><br/>
          <b>bottom sidebar</b>
        </td>
        <td>
          td#main-right<br/>
          <b>breadcrumbs</b><br/>
          <b>page title</b><br/>
          <b>layout</b>
        </td>
      </tr>
    </table>
  </li>
  <li><b>footer</b> (table#footer)</li>
</ol>

<p>
  The <b>main</b> table is divided into two columns.  The left column (td#main-left) encloses the <b>top sidebar</b> (div#sidebar-top), the <b>secondary navigation</b> (div#navsec-box) and the
  <b>bottom sidebar</b> (div#sidebar-bottom).  The right column (td#main-right) encloses the <b>breadcrumbs</b> (div#breadcrumbs), <b>page title</b> (div#pagetitle) and <b>layout</b> (table#l1, table#l2, etc).
</p>

<p>
  In addition, there is an optional <b>quaternary nav</b> div box, which contains fourth-level navigation.  This is a standalone div container which should be
  positioned on the page with absolute left and top coordinates.
</p>

<p>
  To edit the stylesheet, you use the selector in the Stylesheet tool to select the area of interest.  Core classes (like p, b, a, etc.) are set with the <b>body</b> selection, as well as div#container.
  There are a few more selections, like <b>search</b>, to set the style of the search form, if
  you're using site search; and <b>access</b>, to set the style of the access login form, if you use that.
</p>

<p>
  You'll notice that the Stylesheet tool has an additional selector to the right of the
  area selector &mdash; this allows you to apply styles to specific level 1 nodes.  Most of your classes will be defined for the <b>default</b>.  However, you can use the level 1 selector to
  override classes on each level 1 node.  You also use this selector to edit the style of the printable pages and the site map.
</p>

<p>
  A lot of your work will be spent on the <b>layouts</b>.  These are demarked by the layout labels, shown on the Layouts tool.  Each layout has an overall table with a class name like
  "l2", within which there are td entries corresponding to each layout pane, with names like "l2_p1" and "l2_p2".  Use these classes to define the margins, borders and fonts
  for your site's content, for each layout.
</p>

<p>
  Note that ALL of your site's dynamic content resides inside the layout.  You can place site-wide content in the header, section header, subheader, sidebars and footer using the Utility Content tool.
</p>

<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/footer.jhtml" %>

