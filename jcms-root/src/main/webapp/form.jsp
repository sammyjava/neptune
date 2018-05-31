<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="net.ims.jcms.*, net.ims.jcms.extras.*, java.util.*, java.io.*, com.oreilly.servlet.MultipartRequest" %>
<%
/**
 * Contact forms extra
 */

// force request encoding to be UTF-8
request.setCharacterEncoding("UTF-8");

String error = null;
String message = null;
boolean success = false;

// maximum upload size for files in bytes
int maxUploadSize = Setting.getInt(application, "site_maxuploadsize");

// directory that holds uploaded files
String uploadDir = Setting.getString(application, "site_formuploadsdir");

// instantiate form; form_id is always passed as a GET variable in the extension URL
Form form = new Form();
if (request.getParameter("form_id")!=null) {
    int form_id = Util.getInt(request, "form_id");
    form = new Form(application,form_id);
}

// abort if form_id is not set to an existing form
if (form.isDefault()) {
    out.println("<div class=\"error\">Extension URL error: form_id is not set, or is set incorrectly.</div>");
    return;
}

// only show iContact stuff if web.xml contains iContact authentication parameters and Settings contains accountId and clientFolderId
String iContactHost = application.getInitParameter("icontact.host");
String iContactUsername = application.getInitParameter("icontact.username");
String iContactPassword = application.getInitParameter("icontact.password");
int iContactAccountId = Setting.getInt(application, "icontact_accountid");
int iContactClientFolderId = Setting.getInt(application, "icontact_clientfolderid");
boolean showiContact = iContactHost!=null && iContactUsername!=null && iContactPassword!=null && iContactAccountId!=0 && iContactClientFolderId!=0;

// flag Constant Contact code with lists on this form AND we've got credentials in web.xml
boolean showConstantContact = form.constantContactlists.length>0 && application.getInitParameter("constantcontact.username")!=null && application.getInitParameter("constantcontact.password")!=null;

// flag MailChimp code if this form has lists AND we've got MailChimp credentials in web.xml
boolean showMailChimp = form.mailChimplists.length>0 && application.getInitParameter("mailchimp.apikey")!=null;

boolean posted = false;
MultipartRequest mpr = null;
try {
    
    // throws exception if not a multi-part post
    mpr = new MultipartRequest(request, uploadDir, maxUploadSize);

    // flag that we've had a post since we got this far
    posted = (mpr.getParameter("form_posted")!=null);

    if (posted) {
        
        // throw exception if captcha not valid
        Util.verifyGoogleReCaptcha(request, mpr);

        // handle post
        form.process(mpr, application, (String)session.getAttribute("Referer"));
        
        // flag success
        success = true;

    }

} catch (Exception ex) {
    
    // set error message if isn't simply because not a multipart request
    if (!ex.getMessage().equals("Posted content type isn't multipart/form-data")) error = ex.getMessage();

    // explain a bit more on oversize uploads
    if (error!=null && error.indexOf("java.io.IOException: Posted content length")>-1) error = error.substring(20)+".  A site administrator can increase the file upload size limit.";

    // delete an uploaded file if present - only keep successful submissions
    if (mpr!=null) {
        File uploadfile = mpr.getFile("uploadfile");
        if (uploadfile!=null) uploadfile.delete();
    }
    
}

%>
<% if (success) { %>

    <div id="thankyou"><%=form.thankyou%></div>

    <% if (form.redirecturl!=null) { %><script>window.location="<%=form.redirecturl%>"</script><% } %>

<% } else { %>

    <div id="form">
        
        <% if (error!=null) { %>
            <div class="error"><%=error%></div>
            <% if (form.alertonerror) { %>
                <script>
                 alert("<%=error.replace("<ul>","\\n").replace("<li>","\\n- ").replace("</li>","\\n").replace("</ul>","\\n")%>");
                </script>
            <% } %>
        <% } %>

        <div id="forminstructions"><%=form.instructions%></div>

        <form id="contact" enctype="multipart/form-data" method="post">
            <input type="hidden" name="form_id" value="<%=form.form_id%>"/>
            <%
            for (int i=0; i<form.fields.length; i++) {
                String headingClass = "optional";
                if (form.fields[i].required) headingClass = "required";
            %>
            <% if (form.fields[i].hidden) { %>
                <input type="hidden" name="<%=form.fields[i].fieldname%>" value="<%=Form.prefill(mpr,request,form.fields[i].fieldname)%>"/>
            <% } else { %>
                <div class="formfield">
                    <span class="<%=headingClass%>"><%=form.fields[i].heading%></span><br/>
                    <% if (form.fields[i].textinput) { %>
                        <input type="text" size="<%=form.fields[i].size%>" name="<%=form.fields[i].fieldname%>" value="<%=Form.prefill(mpr,request,form.fields[i].fieldname)%>"/>
                    <% } else if (form.fields[i].textarea) { %>
                        <textarea rows="<%=form.fields[i].rows%>" cols="<%=form.fields[i].cols%>" name="<%=form.fields[i].fieldname%>"><%=Form.prefill(mpr,request,form.fields[i].fieldname)%></textarea>
                    <% } else if (form.fields[i].checkbox) { %>
                        <table class="checkboxes" cellspacing="0">
                            <%
                            int col = 0;
                            // load posted values into a Vector to determine if checked
                            String[] values = null;
                            if (mpr!=null) values = mpr.getParameterValues(form.fields[i].fieldname);
                            Vector postedValues = new Vector();
                            if (values!=null) {
                                for (int k=0; k<values.length; k++) postedValues.add(values[k]);
                            }
                            for (int j=0; j<form.fields[i].options.length; j++) {
                                boolean checked = ((!posted && form.fields[i].options[j].selected) || postedValues.contains(form.fields[i].options[j].value));
                                col++;
                                if (col==1) out.println("<tr>");
                            %>
                            <td class="checkbox"><input type="checkbox" <% if (checked) out.print("checked"); %> name="<%=form.fields[i].fieldname%>" value="<%=form.fields[i].options[j].value%>"/></td>
                            <td><%=form.fields[i].options[j].value%></td>
                            <%
                            if (col==form.fields[i].columns) {
                                out.println("</tr>");
                                col = 0;
                            }
                            }
                            if (col>0) out.println("</tr>");
                            %>
                        </table>
                    <% } else if (form.fields[i].radio) { %>
                        <table class="radios" cellspacing="0">
                            <%
                            int col = 0;
                            for (int j=0; j<form.fields[i].options.length; j++) {
                                boolean checked = ((!posted && form.fields[i].options[j].selected) || (mpr!=null && mpr.getParameter(form.fields[i].fieldname)!=null && mpr.getParameter(form.fields[i].fieldname).equals(form.fields[i].options[j].value)));
                                col++;
                                if (col==1) out.println("<tr>");
                            %>
                            <td class="radio"><input type="radio" <% if (checked) out.print("checked"); %> name="<%=form.fields[i].fieldname%>" value="<%=form.fields[i].options[j].value%>"/></td>
                            <td><%=form.fields[i].options[j].value%></td>
                            <%
                            if (col==form.fields[i].columns) {
                                out.println("</tr>");
                                col = 0;
                            }
                            }
                            if (col>0) out.println("</tr>");
                            %>
                        </table>
                    <% } else if (form.fields[i].selectmenu) { %>
                        <select name="<%=form.fields[i].fieldname%>">
                            <option value="">--- select one ---</option>
                            <%
                            for (int j=0; j<form.fields[i].options.length; j++) {
                                boolean selected = ((!posted && form.fields[i].options[j].selected) || (mpr!=null && mpr.getParameter(form.fields[i].fieldname)!=null && mpr.getParameter(form.fields[i].fieldname).equals(form.fields[i].options[j].value)));
                            %>
                            <option <% if (selected) out.print("selected"); %> value="<%=form.fields[i].options[j].value%>"><%=form.fields[i].options[j].value%></option>
                    <%
                    }
                    %>
                        </select>
            <% } // end field types %>
                </div>
<%
} // if hidden
} // end loop over fields
%>

<%
// Lyris signup
if (form.lyrislists.length>0) {
    // load posted listnames into a Vector to determine if checked
    Vector postedListNames = new Vector();
    if (mpr!=null) {
        String[] listnames = mpr.getParameterValues("listname");
        if (listnames!=null) {
            for (int k=0; k<listnames.length; k++) postedListNames.add(listnames[k]);
        }
    }
%>
<div class="formfield">
    <% if (form.signupinstructions!=null) { %><span class="optional"><%=form.signupinstructions%></span><br/><% } %>
    <table cellspacing="0">
        <%
        for (int i=0; i<form.lyrislists.length; i++) {
            boolean checked = postedListNames.contains(form.lyrislists[i].listname);
        %>
        <tr>
            <td class="checkbox"><input type="checkbox" name="listname" <% if (checked) out.print("checked"); %> value="<%=form.lyrislists[i].listname%>"/></td>
            <td><%=form.lyrislists[i].description%></td>
        </tr>
              <% } %>
    </table>
</div>
        <%
        } // lyris signup
        %>
        
        <%
        // iContact signup
        if (showiContact && form.iContactlists.length>0) {
            // load posted listids into a Vector to determine if checked
            Vector postedListIds = new Vector();
            if (mpr!=null) {
                String[] listIds = mpr.getParameterValues("listId");
                if (listIds!=null) {
                    for (int k=0; k<listIds.length; k++) postedListIds.add(listIds[k]);
                }
            }
        %>
        <div class="formfield">
            <% if (form.signupinstructions!=null) { %><span class="optional"><%=form.signupinstructions%></span><br/><% } %>
            <table cellspacing="0">
                <%
                for (int i=0; i<form.iContactlists.length; i++) {
                    boolean selected = (postedListIds.contains(Integer.toString(form.iContactlists[i].listid)) || Util.getInt(request,"listId")==form.iContactlists[i].listid);
                %>
                <tr>
                    <td class="checkbox"><input type="checkbox" name="listId" <% if (selected) out.print("checked"); %> value="<%=form.iContactlists[i].listid%>"/></td>
                    <td><b><%=form.iContactlists[i].name%></b><% if (form.iContactlists[i].description!=null) out.print(" - "+form.iContactlists[i].description); %></td>
                </tr>
                <% } %>
            </table>
        </div>
          <%
          } // iContact signup
          %>
          
          <%
          // Constant Contact signup
          if (showConstantContact && form.constantContactlists.length>0) {
              // load posted links into a Vector to determine if checked
              Vector postedLinks = new Vector();
              if (mpr!=null) {
                  String[] links = mpr.getParameterValues("link");
                  if (links!=null) {
                      for (int k=0; k<links.length; k++) postedLinks.add(links[k]);
                  }
              }
          %>
          <div class="formfield">
              <% if (form.signupinstructions!=null) { %><span class="optional"><%=form.signupinstructions%></span><br/><% } %>
              <table cellspacing="0">
                  <%
                  for (int i=0; i<form.constantContactlists.length; i++) {
                      boolean selected = postedLinks.contains(form.constantContactlists[i].link);
                  %>
                  <tr>
                      <td class="checkbox"><input type="checkbox" name="link" <% if (selected) out.print("checked"); %> value="<%=form.constantContactlists[i].link%>"/></td>
                      <td><b><%=form.constantContactlists[i].name%></b></td>
                  </tr>
                  <% } %>
              </table>
          </div>
            <%
            } // Constant Contact signup
            %>
            
            <%
            // MailChimp signup
            if (showMailChimp && form.mailChimplists.length>0) {
                // load posted listids into a Vector to determine if checked
                Vector postedListids = new Vector();
                if (mpr!=null) {
                    String[] listids = mpr.getParameterValues("listid");
                    if (listids!=null) {
                        for (int k=0; k<listids.length; k++) postedListids.add(listids[k]);
                    }
                }
            %>
            <div class="formfield">
                <% if (form.signupinstructions!=null) { %><span class="optional"><%=form.signupinstructions%></span><br/><% } %>
                <table cellspacing="0">
                    <%
                    for (int i=0; i<form.mailChimplists.length; i++) {
                        boolean selected = postedListids.contains(form.mailChimplists[i].listid);
                    %>
                    <tr>
                        <td class="checkbox"><input type="checkbox" name="listid" <% if (selected) out.print("checked"); %> value="<%=form.mailChimplists[i].listid%>"/></td>
                        <td><b><%=form.mailChimplists[i].listname%></b></td>
                    </tr>
                    <%
                    }
                    %>
                </table>
            </div>
              <%
              } // MailChimp signup
              %>

              <%
              // file upload
              if (form.filetitle!=null && form.filetitle.trim().length()>0) {
                  String headingClass = "optional";
                  if (form.filerequired) headingClass = "required";
              %>
              <div class="formfield">
                  <span class="<%=headingClass%>"><%=form.filetitle%></span><br/>
                  <%=form.fileinstructions%><br/>
                  <input type="file" name="uploadfile" size="<%=form.filefieldsize%>"/>
              </div>
              <%
              } // file upload
              %>
              <% if (form.usecaptcha) { %><%@ include file="/WEB-INF/include/recaptcha.jhtml" %><% } %>
              <div class="formfield submit"><input class="submit" type="submit" name="form_posted" value="<%=form.submitvalue%>"/></div>
        </form>
        
    </div>

<% } // end if success %>

