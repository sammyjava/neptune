<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="net.ims.jcms.*, net.ims.jcms.extras.*, java.util.*, java.text.*, com.google.gdata.data.*" %>
<%
  // standard message vars
  String error = null;
  String message = null;
  
  // format for dates
  SimpleDateFormat sdf = new SimpleDateFormat(Setting.getString(application,"blogger_dateformat"));

  try {

    // comment URI
    String commentPostUri = Setting.getString(application, "blogger_comment_post_uri");
    
    // instantiate a BloggerClient
    BloggerClient bc = new BloggerClient(application);
    
    // get the posts in the default blog
    Entry[] posts = bc.getAllPosts();
    
    for (int i=0; i<posts.length; i++) {
        String postId = posts[i].getId().split("post-")[1]; // getId() returns a bunch of extra stuff
        String postTitle = posts[i].getTitle().getPlainText();
        String postDate = sdf.format(new Date(posts[i].getPublished().getValue()));
        String postContent = ((HtmlTextConstruct)posts[i].getTextContent().getContent()).getHtml();
        String postAuthors = "";
        Iterator authorsIterator = posts[i].getAuthors().iterator();
        while (authorsIterator.hasNext()) {
          Person author = (Person)authorsIterator.next();
          postAuthors += author.getName()+" ";
        }
  %>
  <div class="blogpost">
    <div class="blogposttitle"><%=postTitle%></div>
    <div class="blogpostauthor"><%=postAuthors%></div>
    <div class="blogpostdate"><%=postDate%></div>
    <div class="blogpostcontent"><%=postContent%></div>
    <%
      // get comments, display in reverse order (oldest at top)
      Entry[] comments = bc.getAllComments(postId);
      for (int j=comments.length-1; j>=0; j--) {
          String commentTitle = comments[j].getTitle().getPlainText();
          String commentDate = sdf.format(new Date(comments[j].getPublished().getValue()));
          String commentContent = ((HtmlTextConstruct)comments[j].getTextContent().getContent()).getHtml();
          String commentAuthors = "";
          authorsIterator = comments[j].getAuthors().iterator();
          while (authorsIterator.hasNext()) {
            Person author = (Person)authorsIterator.next();
            commentAuthors += author.getName()+" ";
          }
      %>
      <div class="blogcomment">
        <div class="blogcommentauthor"><%=commentAuthors%></div>
        <div class="blogcommentdate"><%=commentDate%></div>
        <div class="blogcommentcontent"><%=commentContent%></div>
      </div>
      <%
      }
      %>
      <% if (request.getParameter("printable")==null) { %><a class="blogcommentpost" href="<%=commentPostUri%>?blogID=<%=bc.blogId%>&postID=<%=postId%>" target="_blank">post comment</a><% } %>
  </div>
<%
    }

  } catch (Exception ex) {
%>
  <div class="error"><%=ex.toString()%></div>
<%
  }
%>
