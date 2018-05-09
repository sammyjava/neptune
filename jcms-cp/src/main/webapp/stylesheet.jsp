<%@ include file="/WEB-INF/include/init.inc" %>
<%@ page import="java.util.HashMap" %>
<% pageTitle = "Stylesheet Editor"; docUrl="doc-stylesheet.jsp"; %>
<%@ include file="/WEB-INF/include/header.jhtml" %>
<%@ include file="/WEB-INF/include/subheader.jhtml" %>
<%
// get the node level/num
int level = 0;
int level_num = Util.getInt(request, "level_num");
if (level_num!=0) level = 1;
  
// get the stylesheet category
int stylesheetcategory_id = Util.getInt(request, "stylesheetcategory_id");
  
// search term
String searchstring = Util.getString(request, "searchstring");
if (request.getParameter("clear")!=null) searchstring = "";
int maxResults = 100; // maximum allowed results to limit size of response

// requested stylesheet item
Stylesheet s = new Stylesheet(application, Util.getInt(request, "class_id"));
  
// control variables
boolean insert = (request.getParameter("insert")!=null);
boolean update = (request.getParameter("update")!=null);
boolean delete = (request.getParameter("delete")!=null);
  
// logic for toggled regions
boolean showHeader = Setting.getBoolean(application,"header_enable") || Setting.getBoolean(application,"root_header_enable");
boolean showSubheader = Setting.getBoolean(application,"subheader_enable") || Setting.getBoolean(application,"root_subheader_enable");
boolean showSectionheader = Setting.getBoolean(application,"sectionheader_enable") || Setting.getBoolean(application,"root_sectionheader_enable");
boolean showSidebar = Setting.getBoolean(application,"sidebar_enable");
boolean showFooter = Setting.getBoolean(application,"footer_enable") || Setting.getBoolean(application,"root_footer_enable");
boolean showDhtml = Setting.getBoolean(application,"navpri_dhtml_enable") && !Setting.getBoolean(application,"navpri_vertical");
boolean showNavQuat = Setting.getBoolean(application,"navquat_enable");
boolean showBlogger = Setting.getBoolean(application,"blogger_enable");
boolean showSoftslate = Setting.getBoolean(application,"softslate_enable");
boolean showMobile = Setting.getBoolean(application,"mobile_enable");
boolean showPayments = Setting.getBoolean(application,"payments_enable");
  
try {

  if (insert || update) {
    s.name = request.getParameter("class_name");
    s.value = request.getParameter("class_value");
    s.num = Integer.parseInt(request.getParameter("num"));
    if (insert) {
      s.level = level;
      s.level_num = level_num;
      s.stylesheetcategory_id = stylesheetcategory_id;
      s.insert(request);
      message = "Class <b>"+s.name+"</b> added.";
    } else if (update) {
      s.update(request);
      message = "Class <b>"+s.name+"</b> updated.";
    }
  }

  if (delete) {
    boolean confirmed = request.getParameter("confirmed")!=null;
    if (confirmed) {
      message = "Class <b>"+s.name+"</b> removed.";
      s.delete(request);
    } else {
      error = "Please check the box to confirm removal of the <b>"+s.name+"</b> class.";
    }
  }
    
  // write new stylesheet to file system
  if (insert || update || delete) {
    Stylesheet sout[] = Stylesheet.getAll(application, level, level_num);
    String cssFileName = "root.css";
    if (level_num==-1) {
      cssFileName = "printable.css";
    } else if (level_num==-2) {
      cssFileName = "sitemap.css";
    } else if (level_num==-3) {
      cssFileName = "mobile.css";
    } else if (level_num==-4) {
      cssFileName = "payment.css";
    } else if (level_num!=0) {
      cssFileName = "style"+level_num+".css";
    }
    String cssFilePath = cssDir+File.separatorChar+cssFileName;
    File cssFile = new File(cssFilePath);
    if (cssFile.canWrite()) {
      PrintWriter pw = new PrintWriter(new BufferedWriter(new FileWriter(cssFile)));
      for (int i=0; i<sout.length; i++) {
	pw.println(sout[i].name+" {");
	pw.println(sout[i].value);
	pw.println("}");
	pw.println("");
      }
      pw.close();
      message += " CSS files updated.";  
    } else {
      error="Can't write to "+cssFile.getAbsolutePath();
    }
  }
    
  // clear the DHTML cache if this is a DHTML update
  if (s.stylesheetcategory_id==10) DhtmlCache.deleteAll(application);

} catch (NumberFormatException e) {
  error = "Please supply an ordering number.";
} catch (org.postgresql.util.PSQLException e) {
  error = e.getMessage();
} catch (ValidationException e) {
  error = e.getMessage();
}

// load the stylesheet categories into an array and HashMap
StylesheetCategory[] sc = StylesheetCategory.getStylesheetCategories(application);
HashMap scMap = new HashMap();
for (int i=0; i<sc.length; i++) scMap.put(new Integer(sc[i].stylesheetcategory_id), sc[i].stylesheetcategory);    

// stylesheet records to be shown for editing
Stylesheet[] styles = new Stylesheet[0];
boolean search = false;
if (searchstring.length()>0) {
  // get the matching stylesheet records
  styles = Stylesheet.getMatching(application, searchstring);
  if (styles.length==0) {
    error = "No classes matched the search term <b>"+searchstring+"</b>.";
  } else if (styles.length>maxResults) {
    error = "There are too many classes matching the search term <b>"+searchstring+"</b>.  Please make your search term more specific.";
  } else {
    search = true;
  }
}
if (!search) {
  // get the stylesheet records for the selected category
  styles = Stylesheet.getAll(application, level, level_num, stylesheetcategory_id);
}
%>
    <%@ include file="/WEB-INF/include/errormessage.jhtml" %>

    <table>
      <tr>
        <td>
          <form action="stylesheet.jsp" method="post">
            <input type="hidden" name="level_num" value="<%=level_num%>" />
            <select name="stylesheetcategory_id" onChange="submit()">
              <%
                for (int i=0; i<sc.length; i++) {
                    // suppress categories that belong to disabled elements
                    boolean show = true;
                    if (sc[i].stylesheetcategory.equals("header")) show = showHeader;
                    if (sc[i].stylesheetcategory.equals("subheader")) show = showSubheader;
                    if (sc[i].stylesheetcategory.equals("sectionheader")) show = showSectionheader;
                    if (sc[i].stylesheetcategory.equals("sidebar")) show = showSidebar;
                    if (sc[i].stylesheetcategory.equals("footer")) show = showFooter;
                    if (sc[i].stylesheetcategory.equals("dhtml")) show = showDhtml;
                    if (sc[i].stylesheetcategory.equals("quaternary nav")) show = showNavQuat;
                    if (sc[i].stylesheetcategory.equals("blogger")) show = showBlogger;
                    if (sc[i].stylesheetcategory.equals("softslate")) show = showSoftslate;
                    if (sc[i].stylesheetcategory.equals("payments")) show = showPayments;
                    if (show) {
                      boolean selected = stylesheetcategory_id==sc[i].stylesheetcategory_id;
                %>
                <option <% if (selected) out.print("selected"); %> value="<%=sc[i].stylesheetcategory_id%>"><%=sc[i].stylesheetcategory%></option>
                <%
                }
              }
                %>
            </select>
          </form>
        </td>
        <td>
          <form action="stylesheet.jsp" method="post">
            <input type="hidden" name="stylesheetcategory_id" value="<%=stylesheetcategory_id%>" />
            <select name="level_num" onChange="submit()">
              <option value="0">&nbsp;&nbsp;&nbsp;default</option>
              <%
                Node root = new Node(application, 0);
                NodeListIterator rootIterator = root.getNodeListIterator(application);
                HashMap levelMap = new HashMap();
                levelMap.put(new Integer(-1), "printable");
                levelMap.put(new Integer(-2), "site map");
                levelMap.put(new Integer(-3), "mobile");
                levelMap.put(new Integer(-4), "payments");
                while (rootIterator.hasNext()) {
                  Node n1 = rootIterator.nextNode();
                  levelMap.put(new Integer(n1.num), n1.nodename);
                  boolean selected = level_num==n1.num;
              %>
              <option <% if (selected) out.print("selected"); %> value="<%=n1.num%>"><%=n1.num%>&nbsp;<%=n1.nodename%></option>
              <%
              }
              %>
              <option <% if (level_num==-1) out.print("selected"); %> value="-1">&nbsp;&nbsp;&nbsp;printable</option>
              <option <% if (level_num==-2) out.print("selected"); %> value="-2">&nbsp;&nbsp;&nbsp;site map</option>
              <% if (showMobile) { %><option <% if (level_num==-3) out.print("selected"); %> value="-3">&nbsp;&nbsp;&nbsp;mobile</option><% } %>
              <% if (showPayments) { %><option <% if (level_num==-4) out.print("selected"); %> value="-4">&nbsp;&nbsp;&nbsp;payments</option><% } %>
            </select>
          </form>
        </td>
        <td>
          <form action="stylesheet.jsp" method="post">
            <input type="text" size="20" name="searchstring" value="<%=searchstring%>"/>
            <input type="submit" class="update" size="16" value="Search"/>
            <input type="submit" class="normal" name="clear" value="Clear"/>
          </form>
        </td>
      </tr>
    </table>

    <hr/>

    <%
      // loop over displayed stylesheet classes
      for (int i=0; i<styles.length; i++) {
      %>
      <% if (insert && styles[i].id==s.id) { %>
      <a name="insert"></a>
      <% } else { %>
      <a name="<%=styles[i].id%>"></a>
      <% } %>
      <% if (styles[i].id==s.id) { %>
      <%@ include file="/WEB-INF/include/errormessage.jhtml" %>
      <% } %>
      <form action="stylesheet.jsp#<%=styles[i].id%>" method="post">
        <input type="hidden" name="class_id" value="<%=styles[i].id%>"/>
        <input type="hidden" name="level_num" value="<%=level_num%>"/>
        <input type="hidden" name="stylesheetcategory_id" value="<%=stylesheetcategory_id%>" />
        <input type="hidden" name="searchstring" value="<%=searchstring%>"/>
        <table>
          <tr>
            <td valign="top" width="210" class="classname">
              <input type="text" size="2" name="num" value="<%=styles[i].num%>"/>
              <%
                if (search) {
                  String stylesheetcategory = scMap.get(new Integer(styles[i].stylesheetcategory_id)).toString();
                  String levelname = "default";
                  if (styles[i].level==1) levelname = levelMap.get(new Integer(styles[i].level_num)).toString();
              %>
              <%=stylesheetcategory%>:<%=levelname%>
              <%
              }
              %>
              <br/>
              <% if (styles[i].required) { %>
              <input type="hidden" name="class_name" value="<%=styles[i].name%>"/><%=styles[i].name%>
              <% } else { %>
              <input class="classname" type="text" size="32" name="class_name" value="<%=styles[i].name%>"/>
              <% } %>
            </td>
            <td valign="top"><textarea name="class_value" rows="3" cols="80"><%=styles[i].value%></textarea></td>
            <td align="center">
              <input type="submit" class="update" name="update" value="Update"/>
              <% if (!styles[i].required) { %>
              <input type="checkbox" name="confirmed" value="true"/>
              <input type="submit" class="delete" name="delete" value="Remove"/>
              <% } %>
            </td>
          </tr>
        </table>
      </form>
      <%
      }
      int num = 1;
      if (styles.length>0) num = styles[styles.length-1].num+1;
      %>
      <form action="stylesheet.jsp#insert" method="post">
        <input type="hidden" name="level_num" value="<%=level_num%>"/>
        <input type="hidden" name="stylesheetcategory_id" value="<%=stylesheetcategory_id%>" />
        <table>
          <tr>
            <td valign="top" width="210">
              <input type="text" size="2" name="num" value="<%=num%>"/><br/>
              <input class="classname" type="text" size="32" name="class_name"/>
            </td>
            <td valign="top"><textarea name="class_value" rows="3" cols="80"></textarea></td>
            <td><input type="submit" class="insert" name="insert" value="Add"/></td>
          </tr>
        </table>
      </form>

      <%@ include file="/WEB-INF/include/close.inc" %>
      <%@ include file="/WEB-INF/include/footer.jhtml" %>
