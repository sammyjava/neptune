<%@ include file="/WEB-INF/include/init.inc" %>
<% pageTitle = "Utility Content"; docUrl="doc-utilitycontent.jsp"; %>
<%@ include file="/WEB-INF/include/header.jhtml" %>
<%@ include file="/WEB-INF/include/subheader.jhtml" %>
<%
  // utility content locations
  char[] locations = {'H', 'Z', 'S', 'T', 'B', 'F' };
  String[] locationNames = { "header", "section header", "subheader", "top sidebar", "bottom sidebar", "footer" };

  // location
  char location = '0';
  if (request.getParameter("location")!=null) location = request.getParameter("location").charAt(0);
  
  // control variables
  boolean insert = (request.getParameter("insert")!=null);
  boolean update = (request.getParameter("update")!=null);
  boolean delete = (request.getParameter("delete")!=null);

  boolean confirmed = (request.getParameter("confirmed")!=null);

  // logic for toggled regions
  boolean showHeader = Setting.getBoolean(application,"header_enable") || Setting.getBoolean(application,"root_header_enable");
  boolean showSubheader = Setting.getBoolean(application,"subheader_enable") || Setting.getBoolean(application,"root_subheader_enable");
  boolean showSectionheader = Setting.getBoolean(application,"sectionheader_enable") || Setting.getBoolean(application,"root_sectionheader_enable");
  boolean showSidebar = Setting.getBoolean(application,"sidebar_enable");
  boolean showFooter = Setting.getBoolean(application,"footer_enable") || Setting.getBoolean(application,"root_footer_enable");
  boolean showMobile = Setting.getBoolean(application,"mobile_enable") && location!='T' && location!='B';

  int utilitycontent_id = 0;
  if (request.getParameter("utilitycontent_id")!=null) utilitycontent_id = Integer.parseInt(request.getParameter("utilitycontent_id"));

  try {

    UtilityContent uc = new UtilityContent();
    if (utilitycontent_id!=0) uc = new UtilityContent(application, utilitycontent_id);
    
    if (insert || update) {
      uc.num = Integer.parseInt(request.getParameter("num"));
      uc.copy = request.getParameter("copy");
      uc.modulecontext = request.getParameter("modulecontext");
      uc.moduleurl = request.getParameter("moduleurl");
      uc.moduleabove = Util.getBoolean(request,"moduleabove");
      uc.showhome = Util.getBoolean(request,"showhome");
      uc.showinside = Util.getBoolean(request,"showinside");
      if (showMobile) uc.showmobile = Util.getBoolean(request,"showmobile");
      if (insert) {
        uc.location = request.getParameter("location").charAt(0);
        uc.insert(request);
        for (int i=0; i<locations.length; i++) if (uc.location==locations[i]) message = locationNames[i]+" ";
        message += "utility content <b>"+uc.num+"</b> inserted.";
      } else if (update) {
        uc.update(request);
        for (int i=0; i<locations.length; i++) if (uc.location==locations[i]) message = locationNames[i]+" ";
        message += "utility content <b>"+uc.num+"</b> updated.";
      }
    }

    if (delete) {
      if (confirmed) {
        int num = uc.num;
        for (int i=0; i<locations.length; i++) if (uc.location==locations[i]) message = locationNames[i]+" ";
        uc.delete(request);
        message += "utility content <b>"+num+"</b> deleted.";
      } else {
        error = "You must check the box to confirm deletion.";
      }
    }

  } catch (NumberFormatException e) {
    error = "Please supply an ordering number.";
  } catch (ValidationException e) {
    error = e.getMessage();
  } catch (org.postgresql.util.PSQLException e) {
    error = e.getMessage();
  }
%>
      <%@ include file="/WEB-INF/include/errormessage.jhtml" %>
      <form method="post">
        <select name="location" onChange="submit()">
          <option value="0">--- select location ---</option>
          <%
            for (int l=0; l<locations.length; l++) {
                boolean show = false;
                if (locationNames[l].equals("header")) show = showHeader;
                if (locationNames[l].equals("section header")) show = showSectionheader;
                if (locationNames[l].equals("subheader")) show = showSubheader;
                if (locationNames[l].equals("top sidebar") || locationNames[l].equals("bottom sidebar")) show = showSidebar;
                if (locationNames[l].equals("footer")) show = showFooter;
                if (show) {
            %>
            <option <% if (locations[l]==location) out.print("selected"); %> value="<%=locations[l]%>"><%=locationNames[l]%></option>
            <%
            } // show
            } // for
            %>
        </select>
      </form>

      <%
        if (location!='0') {
          // get the utility content for this location
          UtilityContent[] uc = UtilityContent.getByLocation(application, location);
          int num = 0;
          for (int i=0; i<uc.length; i++) {
              num = uc[i].num;
        %>
        <hr/>
        <a name="<%=uc[i].utilitycontent_id%>"></a>
        <% if (uc[i].utilitycontent_id==utilitycontent_id) { %><%@ include file="/WEB-INF/include/errormessage.jhtml" %><% } %>
        <form method="post" action="#<%=uc[i].utilitycontent_id%>">
          <input type="hidden" name="location" value="<%=location%>" />
          <input type="hidden" name="utilitycontent_id" value="<%=uc[i].utilitycontent_id%>" />
          <table>
            <tr>
              <td><input type="text" name="num" size="1" value="<%=uc[i].num%>" /></td>
              <td><input type="checkbox" name="showhome" <% if (uc[i].showhome) out.print("checked"); %> value="true"/></td><td>home page</td>
              <td><input type="checkbox" name="showinside" <% if (uc[i].showinside) out.print("checked"); %> value="true"/></td><td>inside pages</td>
              <% if (showMobile) { %><td><input type="checkbox" name="showmobile" <% if (uc[i].showmobile) out.print("checked"); %> value="true"/></td><td>mobile</td><% } %>
            </tr>
          </table>
          <textarea name="copy" rows="15" cols="120"><%=Util.blankIfNull(uc[i].copy)%></textarea>
          <table>
            <tr>
              <td>extension context<br/><input type="text" name="modulecontext" size="40" value="<%=Util.blankIfNull(uc[i].modulecontext)%>" /></td>
              <td>extension URL<br/><input type="text" name="moduleurl" size="40" value="<%=Util.blankIfNull(uc[i].moduleurl)%>" /></td>
              <td>
                <input type="radio" name="moduleabove" <% if (uc[i].moduleabove) out.print("checked"); %> value="true"/>extension above copy<br/>
                  <input type="radio" name="moduleabove" <% if (!uc[i].moduleabove) out.print("checked"); %> value="false"/>extension below copy<br/>
              </td>
            </tr>
            <tr>
              <td colspan="3" align="center">
                <input type="submit" class="update" name="update" value="Update" />
                <input type="checkbox" name="confirmed" value="true" />
                <input type="submit" class="delete" name="delete" value="Delete" />
              </td>
            </tr>
          </table>
        </form>
        <%
        }
        %>
        <hr/>
        <form method="post">
          <input type="hidden" name="location" value="<%=location%>"/>
          <table>
            <tr>
              <td><input type="text" name="num" size="1" value="<%=(num+1)%>" /></td>
              <td><input type="checkbox" name="showhome" value="true"/></td><td>home page</td>
              <td><input type="checkbox" name="showinside" value="true"/></td><td>inside pages</td>
              <% if (showMobile) { %><td><input type="checkbox" name="showmobile" value="true"/></td><td>mobile</td><% } %>
            </tr>
          </table>
          <textarea name="copy" rows="15" cols="120"></textarea>
          <table>
            <tr>
              <td>extension context<br/><input type="text" name="modulecontext" size="40" /></td>
              <td>extension URL<br/><input type="text" name="moduleurl" size="40" /></td>
              <td>
                <input type="radio" name="moduleabove" value="true"/>extension above copy<br/>
                  <input type="radio" name="moduleabove" checked value="false"/>extension below copy<br/>
              </td>
            </tr>
            <tr>
              <td colspan="3" align="center">
                <input type="submit" class="insert" name="insert" value="Insert" />
              </td>
            </tr>
          </table>
        </form>
        <%
        }
        %>
<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/footer.jhtml" %>
