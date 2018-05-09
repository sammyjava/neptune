<%@ include file="/WEB-INF/include/init.inc" %>
<% int extra_id=14; useZapatec=false; %>
<%@ include file="/WEB-INF/include/extra.inc" %>
<%@ include file="/WEB-INF/include/header.jhtml" %>
<%@ include file="/WEB-INF/include/subheader.jhtml" %>
<%
  if (request.getParameter("insertword")!=null) {
    String word = Util.getString(request, "word").trim().toLowerCase();
    if (word.length()>0) {
      try {
        Comment.addToBlacklist(application, word);
        message = "Word <b>"+word+"</b> added to blacklist.";
      } catch (Exception ex) {
        if (ex.getMessage().contains("commentblacklist_word_key")) {
          error = "The word <b>"+word+"</b> is already in the blacklist.";
        } else {
          error = ex.getMessage();
        }
      }
    } else {
      error = "No word was entered.";
    }
  }

  if (request.getParameter("deleteword")!=null) {
    String word = Util.getString(request, "word");
    Comment.removeFromBlacklist(application, word);
    message = "Word <b>"+word+"</b> removed from blacklist.";
  }
  
  String[] words = Comment.getBlacklist(application);
%>

<%@ include file="/WEB-INF/include/errormessage.jhtml" %>

<form method="post">
  <input type="text" name="word" size="32"/>
  <input type="submit" class="insert" name="insertword" value="Add"/>
</form>

<table>
  <% for (int i=0; i<words.length; i++) { %>
    <tr>
      <td><%=words[i]%></td>
      <td>
        <form method="post">
          <input type="hidden" name="word" value="<%=words[i]%>"/>
          <input type="submit" class="delete" name="deleteword" value="Remove"/>
        </form>
      </td>
    </tr>
    <% } %>
</table>

<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/footer.jhtml" %>
