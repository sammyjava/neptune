<%@ include file="/WEB-INF/include/init.inc" %>
<% pageTitle = "Docs - Blogger"; %>
<%@ include file="/WEB-INF/include/header.jhtml" %>
<%@ include file="/WEB-INF/include/doc-nav.jhtml" %>

<p>
  The <b>Blogger Extra</b> allows you to display content from a Blogger or Blogspot blog within a content item on your Neptune site.  It doesn't integrate the functionality of
  posting new articles or comments; those links take the user over to the original Blogger site.  You are currently allowed only one blog displayed per Neptune site.
</p>

<p>
  The main configuration of the Blogger Extra is done in several Settings, which vary between Blogger, Blogspot and Wordpress:
</p>

<table>
  <tr><td><b>Setting</b></td><td><b>default</b></td><td><b>description</b></td></tr>
  <tr><td>blogger_enable</td><td>false</td><td>Enable blogger extra: true/false.</td></tr>
  <tr><td>blogger_service_name</td><td>blogger</td><td>Google Service name</td></tr>
  <tr><td>blogger_application_name</td><td>exampleCo-exampleApp-1</td><td>Google Service application name</td></tr>
  <tr><td>blogger_feed_uri_base</td><td>http://www.blogger.com/feeds</td><td>base portion of Blogger feed URI</td></tr>
  <tr><td>blogger_posts_feed_uri_suffix</td><td>/posts/default</td><td>URI suffix for Blogger posts</td></tr>
  <tr><td>blogger_comments_feed_uri_suffix</td><td>/comments/default</td><td>URI suffix for Blogger comments</td></tr>
  <tr><td>blogger_comment_post_uri</td><td>https://www.blogger.com/comment.g</td><td>The URI used for posting comments</td></tr>
  <tr><td>blogger_metafeed_url</td><td>http://www.blogger.com/feeds/default/blogs</td><td>Blogger metafeed URL</td></tr>
  <tr><td>blogger_dateformat</td><td>yyyy-MM-dd HH:mm</td><td>java.text.SimpleDateFormat for the blog dates</td></tr>
  <tr><td>blogger_username</td><td>bloggeradmin@gmail.com</td><td>Blogger username</td></tr>
  <tr><td>blogger_password</td><td>*************</td><td>Blogger password</td></tr>
</table>

<p>
  Of these items, the critical ones are <b>blogger_username</b> and <b>blogger_password</b> for a Blogger blog.  That uniquely identifies your blog and allows Neptune to access
  the posts and comments.  If you have a Blogger blog, the other parameters can probably be left with their default values.  If you're running Blogspot or Wordpress, you'll need
  to modify them accordingly.
</p>

<p>
  Styling of your embedded blog and comments is set with the <b>blogger</b> stylesheet, which should become visible in the Stylesheet tool after you've toggled the <b>blogger_enable</b> setting.
</p>

<p>
  Finally, to place the Blogger Extra into a content item, simply enter extension context <b>/</b> and extension URL <b>/blogger.jsp</b>.  All of the other information is drawn from the settings.
</p>

<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/footer.jhtml" %>
