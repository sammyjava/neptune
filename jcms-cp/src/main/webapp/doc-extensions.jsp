<%@ include file="/WEB-INF/include/init.inc" %>
<% pageTitle = "Docs - Extensions"; %>
<%@ include file="/WEB-INF/include/header.jhtml" %>
<%@ include file="/WEB-INF/include/doc-nav.jhtml" %>

<p>
  <b>Extensions</b> are custom functionality added to your specific Neptune site.  They may be written by Java programmers at your company, or
  developed and installed by IMS.  The Extensions tool allows admins to add extension administrative functionality to the control panel.
</p>

<p>
  Extensions are deployed in servlet contexts separate from the main Neptune context.  You configure those servlet contexts in your servlet engine
  or application server configuration (in the case of Tomcat, in server.xml).  Typically, the control panel tools for your extensions will reside
  in a separate context from the front end extension code, just as the Neptune front end resides in a different context from the control panel.
</p>

<p>
  After extensions are deployed, you may add their tools to the control panel using the Extensions tool.  Extension control panel tools are broken up into primary modules and
  tools belonging to those modules.  This is an organizational construct that is used by the Permissions tool as well.
</p>

<p>
  <b>Extras</b> are extensions provided by IMS in the main Neptune context.  They're things that aren't core functionality, but that you may like to use on your site.
  Ask IMS to enable extras that interest you.
</p>

<ul>
  <li><b>Image Rotator.</b> Allows you to place images in content items which cycle upon successive page loads.  Currently only supports a single set of images.</li>
  <li><b>Lyris API.</b> We've written a Lyris class which provides methods to access Lyris API calls. See the Javadoc.</li>
  <li><b>Comments.</b> Allows you to place a form below your content for users to enter comments, which are then displayed above the form, most recent at the top.  The Control Panel tool allows you to delete unwelcome comments.</li>
  <li><b>Contact Forms.</b> Allows you to create basic contact forms.</li>
  <li><b>SearchBlox.</b> The control panel for the site search engine supported by Neptune.</li>
</ul>

<p>
  <b>An example: MLS extension.</b><br/>
  Suppose you've written an extension that manages a Major League Soccer database.  Your extension has three control panel tools: Teams, which manages
  overall team information; Staff, which manages staff information; and Rosters, which manages rosters for each team.
  First, you'd enter the primary module: MLS.  Give it a number and name, enter the control panel context and url,
  indicate that it is a primary module, and click the Insert button.  The page will return showing your MLS primary module in the table.  Next, you'd enter each
  module tool, selecting MLS as the Parent.  When you are all done, the table would look like this:
</p>

<img src="extensions-screenshot.gif" width="892" height="178" border="1"/>
					
<p>
  After an extension has been added, and users have been granted permission to use it, those users will find the extension's primary module linked on the 
  control panel navigation.  When the user selects the primary module, the secondary modules will appear as secondary navigation on the control panel.  The primary module
  can be used to provide instructions or general functionality available to all users of this extension.
</p>


<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/footer.jhtml" %>

