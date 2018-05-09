<%@ include file="/WEB-INF/include/init.inc" %>
<% pageTitle = "Docs - Pages"; %>
<%@ include file="/WEB-INF/include/header.jhtml" %>

<%@ include file="/WEB-INF/include/doc-nav.jhtml" %>

<p>
  The <b>Pages</b> tool allows you to create pages, which are collections of content items that are displayed together in a single browser window.   Pages are linked on the navigation
  via scheduling  in the Nodes tool.  When you create a new page, it is <em>orphaned</em> &mdash; not scheduled on a node, and therefore not visible on your site (but you may
  use the PREVIEW link to see how your page will look).  Since a page consists of content items, and content items are placed in the panes of a layout, every
  page has a layout associated with it.
</p>

<p>
  Here is a step-by-step guide to creating a page; see the <a href="doc-nodes.jsp">Nodes doc</a> to find out how to schedule a page to appear on your site's navigation.
</p>

<ol>
  <li>
    Click the <b>Create New Page</b> button.  Your browser will return with a new, blank page.  Note that some information is displayed at the top: the ID of
    the page (used in other tools); the layout number of the page (layout 1 is the default); the nodes on which this page is scheduled (NONE, since it's a new page);
    and a label indicating that this page is an ORPHAN.
  </li>
  <li>
    Update the page meta information and layout: Page Label, used to identify the page in the page selector; Page Title, which appears at the top of the page; Browser Title Bar,
    which is the text shown at the top of the browser window (the HTML &lt;title&gt; tag); META keywords and META description, which are used by search engines; other
    tags you'd like placed in the HEAD of the document; and, importantly, the page layout.
  </li>
  <li>
    Use the <b>Clone</b> button to copy this page into a new one.  The new page will have the same content items as the original page.  If you wish to clone content as well, you must
    use the <b>Clone</b> button in the content panes after cloning the page.
  </li>
  <li>
    Below the page meta information, you'll see a diagram of the page layout, where you can select the content for each pane.  If you've already entered the content that you'd
    like to display in a pane, simply select it.  More likely, you'll want to create a new content item &mdash; click the <b>Create</b> button in the pane for which you'd like to place
    a new content item, and you will see a new, empty content item displayed in the content editor to the right.  Or, you can copy a content item to a new content item with the <b>Clone</b> button.
  </li>
  <li>
    Update the content item label and enter content into the large text window.  (Click the <b>use page label</b> link to use the page label as this content item's label.)
    If you'd like to upload an image, use the Browse button and find it on your local filesystem, then click Upload Image to
    upload it to the server.  After the image is uploaded, an HTML &lt;img&gt; tag will appear in the content window at the end of your copy.  Remember to click <b>Update Content</b> after you have
    made any changes to a content item (and before uploading an image!).
  </li>
  <li>
    If your page layout has more than one content pane, click the large number in the layout diagram to display another content pane in the content editor.
  </li>
</ol>

<p>
  You can edit HTML directly by clicking in the content area to reveal the buttons, and then click the HTML view toggle button on
  the toolbar, which looks like this: <img style="width:16px; height:16px; background:url('xinha/images/ed_buttons_main.png') -145px -18px;" src="http://www.ims.net/design/spacer.gif"/>.
</p>

<p>
  If you wish to remove an image from a content item, simply delete the &lt;img&gt; HTML tag that displays it.  The image file itself will remain on the server, in case it is used elsewhere.
</p>

<p>
  Observe that the page and content item selectors have <b>Filter</b> functions.  Since your site may have a lot of pages and content items, these allow you to filter the pages and content
  items that appear in the selectors.  For example, suppose you have a bunch of pages about directors, and you know that the page labels all start with "directors -".  Simply enter "directors"
  in the filter field and press the Filter button to retrieve just those pages in the selector.  The same idea applies to the content item selectors.  This is another reason why it is
  important to use consistent labeling of your pages and content items!
</p>

<p>
  If you have extensions on your site, each has a <em>context</em> and URL.  Extensions are placed inside content items, and you can choose whether to have the content item's copy placed above or below
  the extension.  For example, your extension may be a contact form, with context "/forms" and URL "/contact.jsp".  You may enter copy into the content item with introductory text, explaining
  how to use the form, and display it above the form.
</p>


<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/footer.jhtml" %>

