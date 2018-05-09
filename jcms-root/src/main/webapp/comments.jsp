<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="net.ims.jcms.*, net.ims.jcms.extras.*, java.util.*, java.io.*" %>
<%
 /**
  * Comments extra.
  */

  // force request encoding to be UTF-8
  request.setCharacterEncoding("UTF-8");
  
  String error = null;

  // comments are linked to a content item
  int cid = Util.getInt(request, "cid");

  if (cid==0) return;

  // date format for posted date/time
  java.text.SimpleDateFormat commentsDateFormat = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm");
  if (Setting.getString(application,"comments_dateformat").length()>0) commentsDateFormat = new java.text.SimpleDateFormat(Setting.getString(application,"comments_dateformat"));

  // size of text input
  int commentsInputSize = 32;
  if (Setting.getInt(application,"comments_inputsize")>0) commentsInputSize = Setting.getInt(application,"comments_inputsize");

  // comment textarea columns
  int commentsTextCols = 32;
  if (Setting.getInt(application,"comments_textcols")>0) commentsTextCols = Setting.getInt(application,"comments_textcols");

  // comment textarea rows
  int commentsTextRows = 5;
  if (Setting.getInt(application,"comments_textrows")>0) commentsTextRows = Setting.getInt(application,"comments_textrows");
  
  // text on submit button
  String commentsButtonText = "POST";
  if (Setting.getString(application,"comments_buttontext").length()>0) commentsButtonText = Setting.getString(application,"comments_buttontext");

  // number shown by default
  int commentsNumShown = Setting.getInt(application, "comments_numshown");
  String commentsViewMore = Setting.getString(application, "comments_viewmore");

  // posted variables
  String commentName = Util.getString(request, "comment_name");
  String commentLocation = Util.getString(request, "comment_location");
  String commentEmail = Util.getString(request, "comment_email");
  String commentText = Util.getString(request, "comment_text");
  
  int viewmore = Util.getInt(request, "viewmore");
  
  // handle a post
  if (request.getParameter("comment_post")!=null) {
    
    try {

      // throw exception if captcha not valid
      Util.verifyGoogleReCaptcha(request);

      // captcha checks out, insert comment
      Comment comment = new Comment();
      comment.cid = cid;
      comment.name = commentName;
      comment.email = commentEmail;
      comment.location = commentLocation;
      comment.comment = commentText;
      comment.insert(application);
      // clear vars
      commentName = "";
      commentEmail = "";
      commentLocation = "";
      commentText = "";

    } catch (Exception e) {
      
      error = e.getMessage();
      
    }
    
  }

  // get all the comments
  boolean partialShown = false;
  Comment comments[];
  if (commentsNumShown==0) {
    comments = Comment.getAll(application, cid);
  } else {
    comments = Comment.getTop(application, cid, commentsNumShown*(viewmore+1));
    partialShown = comments.length<Comment.getCount(application,cid);
  }
%>
<% if (comments.length>0) { %>
<div class="comments">
  <% if (partialShown) { %><div id="comments-viewmore"><a class="comments-viewmore" href="?viewmore=<%=(viewmore+1)%>"><%=commentsViewMore%></a></div><% } %>
  <div id="comments-rss" onClick="location.href='/comments-rss.jsp?cid=<%=cid%>&pid=<%=request.getParameter("pid")%>&nid=<%=request.getParameter("nid")%>'"></div>
  <% for (int i=0; i<comments.length; i++) { %>
    <a name="<%=comments[i].comment_id%>"></a>
    <div class="comment">
      <%=comments[i].comment.replaceAll("\r\n\r\n","<br/><br/>").replaceAll("\n\n","<br/><br/>")%>  &ndash;&nbsp;<span class="commentname"><%=comments[i].name%></span><% if (comments[i].location!=null) { %>,&nbsp;<span class="commentlocation"><%=comments[i].location%></span><% } %>&nbsp;<span class="commenttime">(<%=commentsDateFormat.format(comments[i].timeposted)%>)</span>
    </div>
    <% } %>
</div>
<% } %>
<% if (request.getParameter("printable")==null) { %>
<div id="commentform">
  <% if (error!=null) { %><div class="error"><%=error%></div><% } %>
    <form id="commentform" method="post">
      <table cellspacing="0">
        <tr>
          <td class="commentform">Name<br/><input class="commentfield" type="text" name="comment_name" size="<%=commentsInputSize%>" value="<%=commentName%>"/></td>
          <td class="commentform">Location<br/><input class="commentfield" type="text" name="comment_location" size="<%=commentsInputSize%>" value="<%=commentLocation%>"/></td>
          <td class="commentform">Email<br/><input class="commentfield" type="text" name="comment_email" size="<%=commentsInputSize%>" value="<%=commentEmail%>"/></td>
        </tr>
      </table>
      Comment<br/><textarea class="commentfield" name="comment_text" cols="<%=commentsTextCols%>" rows="<%=commentsTextRows%>"><%=commentText%></textarea>
      <table cellspacing="0">
        <tr>
          <td><%@ include file="/WEB-INF/include/recaptcha.jhtml" %></td>
          <td><div class="formfield submit"><input class="commentbutton" type="submit" name="comment_post" value="<%=commentsButtonText%>"/></div></td>
        </tr>
      </table>
  </form>
</div>
<% } %>


  


