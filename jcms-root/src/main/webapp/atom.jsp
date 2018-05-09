<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="net.ims.jcms.*,net.ims.jcms.extras.*,java.util.*,java.text.*,java.net.URI,java.io.InputStream" %>
<%@ page import="org.apache.abdera.Abdera,org.apache.abdera.model.Document,org.apache.abdera.model.Entry,org.apache.abdera.model.Feed,org.apache.abdera.parser.Parser,org.apache.abdera.model.Link" %>
<%
  // standard message vars
  String error = null;
  String message = null;
  
  // the Atom feed URI
  String atomURI = Setting.getString(application, "atom_uri");

  // format for dates
  SimpleDateFormat sdf = new SimpleDateFormat(Setting.getString(application,"atom_dateformat"));

  // listing limit, 0 means no limit
  int maxListed = Setting.getInt(application,"atom_maxlisted");

  try {

    // instantiate an Abdera Atom parser
    Parser parser = Abdera.getNewParser();
    
    // open the feed
    URI uri = new URI(atomURI);
    InputStream in = uri.toURL().openStream();
    Document<Feed> doc = parser.parse(in, atomURI);
    Feed feed = doc.getRoot();

    // loop through the entries
    List entries = feed.getEntries();
    for (int i=0; i<entries.size() && (maxListed==0 || i<maxListed); i++) {
      Entry entry = feed.getEntries().get(i);
      String postDate = sdf.format(entry.getUpdated());
      String content = entry.getSummary();
      if (content==null) content = entry.getContent();
      // get all media links
      Object links[] = entry.getLinks().toArray();
    %>
    <div class="blogpost">
      <div class="blogposttitle"><a href="<%=entry.getAlternateLink().getResolvedHref()%>"><%=entry.getTitle()%></a></div>
      <div class="blogpostauthor"><%=entry.getAuthor().getName()%></div>
      <div class="blogpostdate"><%=postDate%></div>
      <div class="blogpostcontent">
       <%=content%>
       <%
       for (int j=0; j<links.length; j++) {
	 Link l = (Link)links[j];
	 String rel = l.getRel();
	 if (rel!=null && rel.equals("enclosure")) {
	   String title = l.getTitle();
	   if (title==null) title = l.getHref().toString();
           %>
            <p><%=l.getMimeType()%>: <a href="<%=l.getHref()%>"><%=title%></a></p>
           <%
         }
       }
       %>
       </div>
    </div>
    <%
    }
    
  } catch (Exception ex) {
%>
    <div class="error"><%=ex.toString()%></div>
<%
  }
%>
