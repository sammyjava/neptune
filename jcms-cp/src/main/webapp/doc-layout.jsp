<%@ include file="/WEB-INF/include/init.inc" %>
<% pageTitle = "Docs - Layouts"; %>
<%@ include file="/WEB-INF/include/header.jhtml" %>

<%@ include file="/WEB-INF/include/doc-nav.jhtml" %>

<p>
  The <b>Layouts</b> tool allows you to create and edit page layouts.  Layouts are one of Neptune's most powerful features: you can create specific looks for the pages
  of your site, depending on their purpose, and give them descriptive labels by which content editors will choose them.  For example, you may have a particular
  choice of fonts and margins for your press releases.  You can create a layout specifically for press releases and then edit the stylesheet for the regular and printable
  versions of the press release layout.  Most of what determines the look of a layout is in the stylesheet, but you must create a layout in the Layouts tool first to create the stylesheet classes
  as well as the row and column structure of the table that encloses it.
</p>

<p>
  Layouts are numbered, and the default layout which is assigned to a new page upon creation is Layout 1.  Layouts are enclosed by a single table, and you set the number of table rows, columns,
  and individual attributes (vertical position <em>vpos</em>, horizontal position <em>hpos</em>, column span <em>colspan</em>, and row span <em>rowspan</em>) for each pane.  The enclosing
  layout table has a stylesheet class name like <b>l3</b> (for the third layout); each pane in a layout has its own stylesheet class like <b>l3_p2</b> (for the second pane of the third
  layout).  The class names of each pane are displayed on the Layouts tool for convenience.
</p>

<p>
  If you are familiar with HTML table design (and you should be if you're using the Layouts tool), or Java Swing, the use of rows, columns and the pane attributes will be familiar.  Here is an example of
  a layout 3 which demonstrates them:
</p>

<div align="center">
  <img src="layout-example.gif" width="640" height="480" border="1"/>
</div>

<p>
  The underlying table is a 2&times;2 table, and therefore you would set rows=2 and cols=2 for this layout.  Then, you would add each pane: pane 1 starts in the upper left, so vpos=1 and hpos=1, and
  extends from top to bottom, spanning two rows, so rowspan=2.  Pane 2 starts at the top (vpos=1) but is to the right of pane 1, so, hpos=2.  Pane 3 is below pane 2, and to the right of
  pane 1, so, vpos=2, hpos=2.  Both pane 2 and pane 3 occupy single table cells, so they have rowspan=1 and colspan=1.
</p>

<p>
  IMPORTANT: you must enter the panes in column/row order.  That is, you MUST enter panes from left to right along the top row, then go left to right along the second row, etc.  In
  the end, you should see increasing vpos numbers as you read down the panes, and for a given vpos value, you should see increasing hpos numbers as you read down the panes.
</p>

<p>
  Once you have entered the structure of a layout, such as above, you are done with the Layouts tool for that layout.  Go to the Stylesheet editor, select content, and edit the classes for this layout: the
  enclosing table (table.l3 in our example), and the pane td and div tag classes (td.l3_p1, div.l3_p1, etc.).  NOTE: You set the height and width of the individual panes by setting the
  width and height attributes in the table and td classes in the content stylesheet.
</p>


<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/footer.jhtml" %>

