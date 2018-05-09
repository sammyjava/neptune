<%@ include file="/WEB-INF/include/init.inc" %>
<%@ page import="net.ims.icontact.*" %>
<%@ page import="java.io.BufferedReader,java.io.IOException,java.io.InputStreamReader" %>
<%@ page import="com.ctctlabs.ctctwsjavalib.*" %>
<%@ page import="org.apache.http.HttpResponse,org.apache.http.client.HttpClient,org.apache.http.client.methods.HttpPost,org.apache.http.impl.client.DefaultHttpClient" %>
<%@ page import="org.apache.http.entity.StringEntity" %>
<%@ page import="org.json.JSONObject" %>
<% int extra_id=2; useZapatec=false; %>
<%@ include file="/WEB-INF/include/extra.inc" %>
<%@ include file="/WEB-INF/include/header.jhtml" %>
<%@ include file="/WEB-INF/include/subheader.jhtml" %>
<%
  // default Form
  Form form = new Form(application, Util.getInt(request,"form_id"));

  // posted if editing a form field
  int formfield_id = Util.getInt(request, "formfield_id");

  // posted if editing a form field option
  int formfieldoption_id = Util.getInt(request, "formfieldoption_id");

  ServletContext root = application.getContext("/");
  // show Lyris stuff if ROOT web.xml contains lyris authentication parameters
  boolean showLyris = root.getInitParameter("lyris.username")!=null && root.getInitParameter("lyris.password")!=null;

  // show iContact stuff if Settings contains accountId and clientFolderId
  int iContactAccountId = Setting.getInt(application, "icontact_accountid");
  int iContactClientFolderId = Setting.getInt(application, "icontact_clientfolderid");
  boolean showiContact = iContactAccountId!=0 && iContactClientFolderId!=0;

  // show Constant Contact stuff if web.xml contains username and password
  String ccUsername = application.getInitParameter("constantcontact.username");
  String ccPassword = application.getInitParameter("constantcontact.password");
  boolean showConstantContact = ccUsername!=null && ccPassword!=null;

  // show MailChimp stuff if web.xml contains API key
  String mailChimpAPIKey = application.getInitParameter("mailchimp.apikey");
  boolean showMailChimp = mailChimpAPIKey!=null;
  
  // logic vars
  boolean forminsert = request.getParameter("forminsert")!=null;
  boolean formupdate = request.getParameter("formupdate")!=null;
  boolean formdelete = request.getParameter("formdelete")!=null;
  boolean formclone = request.getParameter("formclone")!=null;

  boolean fieldinsert = request.getParameter("fieldinsert")!=null;
  boolean fieldupdate = request.getParameter("fieldupdate")!=null;
  boolean fielddelete = request.getParameter("fielddelete")!=null;

  boolean optioninsert = request.getParameter("optioninsert")!=null;
  boolean optionupdate = request.getParameter("optionupdate")!=null;
  boolean optiondelete = request.getParameter("optiondelete")!=null;

  boolean lyrisupdate = request.getParameter("lyrisupdate")!=null;
  boolean listinsert = request.getParameter("listinsert")!=null;
  boolean listupdate = request.getParameter("listupdate")!=null;
  boolean listdelete = request.getParameter("listdelete")!=null;

  boolean icontactupdate = request.getParameter("icontactupdate")!=null;
  boolean constantcontactupdate = request.getParameter("constantcontactupdate")!=null;
  boolean mailchimpupdate = request.getParameter("mailchimpupdate")!=null;

  boolean fileupdate = request.getParameter("fileupdate")!=null;

  // confirmation of deletes
  boolean confirmed = request.getParameter("confirmed")!=null;

  try {

    if (forminsert || formupdate) {
      form.title = Util.getString(request, "title");
      form.submitvalue = Util.getString(request, "submitvalue");
      form.recipientname = Util.getString(request, "recipientname");
      form.recipientemail = Util.getString(request, "recipientemail");
      form.sendername = Util.getString(request, "sendername");
      form.senderemail = Util.getString(request, "senderemail");
      form.instructions = Util.getString(request, "instructions");
      form.thankyou = Util.getString(request, "thankyou");
      form.redirecturl = Util.getString(request, "redirecturl");
      form.confirmationsubject = Util.getString(request, "confirmationsubject");
      form.confirmationmessage = Util.getString(request, "confirmationmessage");
      form.usecaptcha = Util.getBoolean(request, "usecaptcha");
      form.alertonerror = Util.getBoolean(request, "alertonerror");
      if (forminsert) {
        form.insert(request);
        message = "New form <b>"+form.title+"</b> created.";
      } else if (formupdate) {
        form.update(request);
        message = "Form <b>"+form.title+"</b> updated.";
      }
    }
    
    if (fileupdate) {
      form.filetitle = Util.getString(request, "filetitle");
      form.fileinstructions = Util.getString(request, "fileinstructions");
      form.filerequired = Util.getBoolean(request, "filerequired");
      form.filefieldsize = Util.getInt(request, "filefieldsize");
      form.update(request);
      message = "Form <b>"+form.title+"</b> updated with file upload title and instructions.";
    }      
    
    if (formclone) {
      form = form.clone(application);
      message = "Form cloned to <b>"+form.title+"</b>.";
    }
    
    if (formdelete) {
      if (confirmed) {
        String formTitle = form.title;
        form.delete(request);
        message = "Form <b>"+formTitle+"</b> deleted.";
      } else {
        error = "You must check the box to confirm deletion of a form.";
      }
    }

    if (fieldinsert || fieldupdate) {
      FormField formfield = new FormField();
      formfield.form_id = form.form_id;
      if (fieldupdate) formfield = new FormField(application, formfield_id);
      formfield.fieldname = Util.getString(request, "fieldname");
      formfield.num = Util.getInt(request, "num");
      formfield.heading = Util.getString(request, "heading");
      formfield.required = Util.getBoolean(request, "required");
      if (request.getParameter("columns")!=null) formfield.columns = Util.getInt(request, "columns");
      if (request.getParameter("size")!=null) formfield.size = Util.getInt(request, "size");
      if (request.getParameter("rows")!=null) formfield.rows = Util.getInt(request, "rows");
      if (request.getParameter("cols")!=null) formfield.cols = Util.getInt(request, "cols");
      if (fieldinsert) {
        formfield.hidden = Util.getString(request, "fieldtype").equals("hidden");
        formfield.textinput = Util.getString(request, "fieldtype").equals("textinput");
        formfield.textarea = Util.getString(request, "fieldtype").equals("textarea");
        formfield.checkbox = Util.getString(request, "fieldtype").equals("checkbox");
        formfield.radio = Util.getString(request, "fieldtype").equals("radio");
        formfield.selectmenu = Util.getString(request, "fieldtype").equals("selectmenu");
        formfield.insert(request);
        formfield_id = formfield.formfield_id;
        message = "New form field <b>"+formfield.fieldname+"</b> added.";
      } else if (fieldupdate) {
        formfield.update(request);
        message = "Form field <b>"+formfield.fieldname+"</b> updated.";
      }
      // update Form since it now contains another field
      form.update(application);
    }

    if (fielddelete) {
      if (confirmed) {
        FormField formfield = new FormField(application, formfield_id);
        message = "Form field <b>"+formfield.fieldname+"</b> deleted.";
        formfield.delete(request);
        formfield_id = 0;
        form.update(application);
      } else {
        error = "You must check the box to confirm deletion of a form field.";
      }
    }

    if (optioninsert || optionupdate) {
      FormFieldOption formfieldoption = new FormFieldOption();
      formfieldoption.formfield_id = formfield_id;
      if (optionupdate) formfieldoption = new FormFieldOption(application, formfieldoption_id);
      formfieldoption.num = Util.getInt(request, "num");
      formfieldoption.value = Util.getString(request, "value");
      formfieldoption.selected = Util.getBoolean(request, "selected");
      if (optioninsert) {
        formfieldoption.insert(request);
        message = "New form field option <b>"+formfieldoption.value+"</b> added.";
      } else if (optionupdate) {
        formfieldoption.update(request);
        message = "Form field option <b>"+formfieldoption.value+"</b> updated.";
      }
      // update form since it has a new option in a form field
      form.update(application);
    }

    if (optiondelete) {
      if (confirmed) {
        FormFieldOption formfieldoption = new FormFieldOption(application, formfieldoption_id);
        message = "Form field option <b>"+formfieldoption.num+"</b> with value <b>"+formfieldoption.value+"</b> deleted.";
        formfieldoption.delete(request);
        formfieldoption_id = 0;
        // update form
        form.update(application);
      } else {
        error = "You must check the box to confirm deletion of a form field option.";
      }
    }

    if (lyrisupdate) {
      form.signupinstructions = Util.getString(request, "signupinstructions");
      form.update(request);
      message = "Sign-up instructions updated for <b>"+form.title+"</b>.";
    }

    if (listinsert || listupdate) {
      FormLyrisList lyrislist = new FormLyrisList();
      lyrislist.form_id = form.form_id;
      if (listupdate) {
        int formlyrislist_id = Util.getInt(request, "formlyrislist_id");
        lyrislist = new FormLyrisList(application, formlyrislist_id);
      }
      lyrislist.num = Util.getInt(request, "num");
      lyrislist.listname = Util.getString(request, "listname");
      lyrislist.description = Util.getString(request, "description");
      if (listinsert) {
        lyrislist.insert(request);
        message = "New sign-up checkbox inserted for list <b>"+lyrislist.listname+"</b>.";
      } else if (listupdate) {
        lyrislist.update(request);
        message = "Sign-up checkbox updated for list <b>"+lyrislist.listname+"</b>.";
      }
      // update form since lyrislists have changed
      form.update(application);
    }

    if (listdelete) {
      if (confirmed) {
        int formlyrislist_id = Util.getInt(request, "formlyrislist_id");
        FormLyrisList lyrislist = new FormLyrisList(application, formlyrislist_id);
        message = "Sign-up removed for list <b>"+lyrislist.listname+"</b>.";
        lyrislist.delete(application);
        // update form since lyrislists have changed
        form.update(application);
      } else {
        error = "You must check the box to confirm removal of a Lyris ListManager sign-up checkbox.";
      }
    }

    if (icontactupdate) {
      // set up iContact requests
      Credentials creds = new Credentials(root);
      Account account = new Account(creds, iContactAccountId);
      ClientFolder clientFolder = new ClientFolder(creds, account, iContactClientFolderId);
      // clear out all existing relations
      FormiContactList.deleteAll(application, form.form_id);
      // insert each list
      String[] listIds = request.getParameterValues("listId");
      if (listIds!=null) {
        for (int i=0; i<listIds.length; i++) {
	  FormiContactList formlist = new FormiContactList();
	  formlist.form_id = form.form_id;
	  formlist.listid = Integer.parseInt(listIds[i]);
	  // get name and description from iContact
	  List list = new List(creds, account, clientFolder, formlist.listid);
	  formlist.name = list.name;
	  formlist.description = list.description;
	  // insert it
	  formlist.insert(request);
	}
      }
      // update form since icontactlists have changed
      form.signupinstructions = Util.getString(request, "signupinstructions");
      form.update(application);
      message = "iContact signup updated.";
    }

    if (constantcontactupdate) {
      // clear out all existing relations
      FormConstantContactList.deleteAll(application, form.form_id);
      // connect to query name
      CTCTConnection conn = new CTCTConnection();
      conn.authenticate(Util.CC_API_KEY, ccUsername, ccPassword);
      // insert each list
      String[] links = request.getParameterValues("link");
      if (links!=null) {
	for (int i=0; i<links.length; i++) {
	  FormConstantContactList formlist = new FormConstantContactList();
	  formlist.form_id = form.form_id;
	  formlist.link = links[i];
	  // get name from Constant Contact
	  ContactList list = conn.getContactList(formlist.link);
	  formlist.name = (String)list.getAttribute("Name");
	  // insert it
	  formlist.insert(request);
	}
      }
      // update form since constantcontactlists have changed
      form.signupinstructions = Util.getString(request, "signupinstructions");
      form.update(application);
      message = "Constant Contact signup updated.";
    }

    if (mailchimpupdate) {
      // clear out all existing relations
      FormMailChimpList.deleteAll(application, form.form_id);
      // insert each list
      String[] listIDandName = Util.getStringValues(request, "listIDandName");
      if (listIDandName.length>0) {
	for (int i=0; i<listIDandName.length; i++) {
	  FormMailChimpList formlist = new FormMailChimpList();
	  formlist.form_id = form.form_id;
	  String[] pieces = listIDandName[i].split("\\|");
	  if (pieces.length==2) {
	    formlist.listid = pieces[0];
	    formlist.listname = pieces[1];
	    formlist.insert(request);
	  }
	}
      }
      // update form with new mailchimp signup instructions
      form.signupinstructions = Util.getString(request, "signupinstructions");
      form.update(application);
      message = "MailChimp signup updated.";
    }

  } catch (Exception ex) {

    error = ex.toString();

  }

  // load all forms for selector
  Form[] forms = Form.getAll(application);

  // refresh form since things may have changed
  form.refresh(application);    

  if (!form.isDefault() && message==null) message = "<b>"+form.title+" ["+form.form_id+"] </b> selected.";
%>
<%@ include file="/WEB-INF/include/errormessage.jhtml" %>

<!-- form selector -->
<table>
  <tr>
    <td>
      <form action="#0" method="post">
        <select name="form_id" onChange="submit()">
          <option value="0">--- insert new form ---</option>
          <% for (int i=0; i<forms.length; i++) { %>
            <option <% if (form.form_id==forms[i].form_id) out.print("selected"); %> value="<%=forms[i].form_id%>"><%=forms[i].title%> [<%=forms[i].form_id%>]</option>
          <% } %>
        </select>
      </form>
    </td>
    <% if (!form.isDefault()) { %>
      <td><b>/form.jsp?form_id=<%=form.form_id%></b></td>
      <td><a class="preview" target="preview" href="form-preview.jsp?form_id=<%=form.form_id%>">PREVIEW</a></td>
      <td>
	<form action="postedformcsv" method="post">
          <input type="hidden" name="form_id" value="<%=form.form_id%>"/>
          <input class="download" type="submit" value="Download CSV File"/>
	</form>
      </td>
    <% } %>
  </tr>
</table>

<!-- form update/insert -->
<form action="#0" method="post">
  <input type="hidden" name="form_id" value="<%=form.form_id%>"/>
  <table>
    <tr>
      <td class="required">Label<br/><input type="text" size="50" name="title" value="<%=Util.blankIfNull(form.title)%>"/></td>
      <td class="required">Submit button text<br/><input type="text" size="20" name="submitvalue" value="<%=Util.blankIfNull(form.submitvalue)%>"/></td>
    </tr>
    <tr>
      <td nowrap class="required">Form recipient name<br/><input type="text" size="50" name="recipientname" value="<%=Util.blankIfNull(form.recipientname)%>"/></td>
      <td nowrap class="required">Form recipient email<br/><input type="text" size="50" name="recipientemail" value="<%=Util.blankIfNull(form.recipientemail)%>"/></td>
    </tr>
    <tr>
      <td nowrap class="required">Instructions<br/><textarea cols="50" rows="5" name="instructions"><%=Util.blankIfNull(form.instructions)%></textarea></td>
      <td nowrap class="required">Thank-you message<br/><textarea cols="50" rows="5" name="thankyou"><%=Util.blankIfNull(form.thankyou)%></textarea></td>
    </tr>
    <% if (form.hasEmail()) { %>
      <tr>
        <td nowrap>Confirmation sender name<br/><input type="text" size="50" name="sendername" value="<%=Util.blankIfNull(form.sendername)%>"/></td>
        <td nowrap>Confirmation sender email<br/><input type="text" size="50" name="senderemail" value="<%=Util.blankIfNull(form.senderemail)%>"/></td>
      </tr>
      <tr>
        <td colspan="2">
	  Confirmation message subject<br/>
	  <textarea cols="100" rows="1" name="confirmationsubject"><%=Util.blankIfNull(form.confirmationsubject)%></textarea>
	</td>
      </tr>
      <tr>
        <td nowrap colspan="2">
	  Confirmation message body (confirmation sent to submitter if not empty)<br/>
	  <textarea cols="100" rows="5" name="confirmationmessage"><%=Util.blankIfNull(form.confirmationmessage)%></textarea>
	</td>
      </tr>
    <% } %>
      <tr>
	<td colspan="2">Post-submission redirect URL<br/><input type="text" size="100" name="redirecturl" value="<%=Util.blankIfNull(form.redirecturl)%>"/></td>
      </tr>
      <tr>
        <td align="center"><input type="checkbox" name="usecaptcha" <% if (form.usecaptcha) out.print("checked"); %> value="true"/> Use CAPTCHA (anti-spam)</td>
          <td align="center"><input type="checkbox" name="alertonerror" <% if (form.alertonerror) out.print("checked"); %> value="true"/> Alert with popup on invalid submission</td>
      </tr>
      <tr>
        <td align="center" colspan="2">
          <% if (form.isDefault()) { %>
            <input type="submit" name="forminsert" class="insert" value="Insert"/>
          <% } else { %>
            <input type="submit" name="formupdate" class="update" value="Update"/>
            <input type="submit" name="formclone" class="clone" value="Clone"/>
            <input type="checkbox" name="confirmed" value="true"/>
            <input type="submit" name="formdelete" class="delete" value="Delete Form"/>
            <br/>
            (WARNING: deleting a form deletes all of its posted data!)
          <% } %>
        </td>
      </tr>
  </table>
</form>

<% if (!form.isDefault()) { %>

<hr/>
<p>
  <b>FORM FIELDS</b><br/>
  We recommend that you use a required text input field with Field Name <b>email</b>; this will place the email address of the form submitter
  in the From: address of the email sent to the recipient.<br/>
  We also recommend a text input field with Field Name <b>fullname</b> to display the name of the form submitter in the From:
  address.<br/>
  If <b>email</b> is present, you may enter a confirmation message above, to be sent to the submitter from the confirmation sender.
</p>

<table>
  <tr>
    <td width="40" valign="bottom" align="center" class="required">Num</td>
    <td width="50" valign="bottom">Required</td>
    <td width="120" valign="bottom" valign="bottom" class="required">Field Type</td>
    <td width="220" valign="bottom" nowrap class="required">Field Name (data column name)</td>
    <td width="220" valign="bottom" nowrap class="required">Field Heading (shown on form)</td>
  </tr>
</table>
<%
  int num = 0;
  for (int i=0; i<form.fields.length; i++) {
      num = form.fields[i].num;
%>
  <!-- form field update -->
  <% if (fieldinsert && formfield_id==form.fields[i].formfield_id) { %>
  <a name="insert"></a>
  <% } else { %>
  <a name="<%=form.fields[i].formfield_id%>"></a>
  <% } %>
  <% if (formfield_id==form.fields[i].formfield_id) { %>
  <%@ include file="/WEB-INF/include/errormessage.jhtml" %>
  <% } %>
  <form action="#<%=form.fields[i].formfield_id%>" method="post">
    <input type="hidden" name="form_id" value="<%=form.form_id%>"/>
    <input type="hidden" name="formfield_id" value="<%=form.fields[i].formfield_id%>"/>
    <table>
      <tr>
        <td width="40" align="center" valign="bottom"><input type="text" size="2" name="num" value="<%=num%>"/></td>
        <td width="50" align="center" valign="bottom"><% if (!form.fields[i].hidden) { %><input type="checkbox" name="required" <% if (form.fields[i].required) out.print("checked"); %> value="true"/><% } %></td>
        <td width="120" valign="bottom" nowrap>
              <b>
                <%
                  if (form.fields[i].hidden) out.print("hidden");
                  if (form.fields[i].textinput) out.print("text input");
                  if (form.fields[i].textarea) out.print("textarea");
                  if (form.fields[i].checkbox) out.print("checkboxes");
                  if (form.fields[i].radio) out.print("radios");
                  if (form.fields[i].selectmenu) out.print("select");
                %>
          </b>
        </td>
        <td width="220" valign="bottom"><input type="text" size="32" name="fieldname" value="<%=form.fields[i].fieldname%>"/></td>
        <td width="220" valign="bottom"><textarea rows="1" cols="32" name="heading" wrap><%=form.fields[i].heading%></textarea></td>
        <td width="100" align="center" valign="bottom">
          <% if (form.fields[i].checkbox || form.fields[i].radio) { %>
          columns<br/><input type="text" size="2" name="columns" value="<%=form.fields[i].columns%>"/>
          <% } else if (form.fields[i].textinput) { %>
          size<br/><input type="text" size="2" name="size" value="<%=form.fields[i].size%>"/>
          <% } else if (form.fields[i].textarea) { %>
          rows&nbsp;cols<br/><input type="text" size="2" name="rows" value="<%=form.fields[i].rows%>"/>&nbsp;<input type="text" size="2" name="cols" value="<%=form.fields[i].cols%>"/>
          <% } %>
        </td>
        <td width="180" align="left" valign="bottom" nowrap>
          <input type="submit" name="fieldupdate" class="update" value="Update"/>
          <input type="checkbox" name="confirmed" value="true"/>
          <input type="submit" name="fielddelete" class="delete" value="Delete"/>
        </td>
      </tr>
    </table>
  </form>
<%
if (form.fields[i].checkbox || form.fields[i].radio || form.fields[i].selectmenu) {
  int optionnum = 0;
  for (int j=0; j<form.fields[i].options.length; j++) {
    optionnum = form.fields[i].options[j].num;
%>
  <!-- checkbox/radio/option update/delete -->
  <form action="#<%=form.fields[i].formfield_id%>" method="post">
    <input type="hidden" name="form_id" value="<%=form.form_id%>"/>
    <input type="hidden" name="formfield_id" value="<%=form.fields[i].formfield_id%>"/>
    <input type="hidden" name="formfieldoption_id" value="<%=form.fields[i].options[j].formfieldoption_id%>"/>
    <table>
      <tr>
        <td width="100">&nbsp;</td>
        <td align="center"><input type="text" size="2" name="num" value="<%=optionnum%>"/></td>
        <td><input type="checkbox" name="selected" <% if (form.fields[i].options[j].selected) out.print("checked");%> value="true"/> default</td>
          <td><input type="text" size="48" name="value" value="<%=form.fields[i].options[j].value%>"/></td>
          <td width="150">
            <input type="submit" name="optionupdate" class="update" value="Update"/>
            <input type="checkbox" name="confirmed" value="true"/>
            <input type="submit" name="optiondelete" class="delete" value="Delete"/>
          </td>
      </tr>
    </table>
  </form>
<%
} // form field options
%>
  <!-- checkbox/radio/option insert -->
  <form action="#<%=form.fields[i].formfield_id%>" method="post">
    <input type="hidden" name="form_id" value="<%=form.form_id%>"/>
    <input type="hidden" name="formfield_id" value="<%=form.fields[i].formfield_id%>"/>
    <table>
      <tr>
        <td width="100">&nbsp;</td>
        <td align="center"><input type="text" size="2" name="num" value="<%=(optionnum+1)%>"/></td>
        <td><input type="checkbox" name="selected" value="true"/> default</td>
        <td><input type="text" size="48" name="value"/></td>
        <td width="150"><input type="submit" name="optioninsert" class="insert" value="Insert"/></td>
      </tr>
    </table>
  </form>
  <%
  } // end if checkbox or radio or option
  } // end formfields loop
  %>
  <!-- form field insert -->
  <form action="#insert" method="post">
    <input type="hidden" name="form_id" value="<%=form.form_id%>"/>
    <table>
      <tr>
	<td width="40" align="center"><input type="text" size="2" name="num" value="<%=num+1%>"/></td>
	<td width="50" align="center"><input type="checkbox" name="required" value="true"/></td>
	<td width="120">
	  <select name="fieldtype">
	    <option value="textinput">text input</option>
	    <option value="textarea">textarea</option>
	    <option value="checkbox">checkboxes</option>
	    <option value="radio">radio buttons</option>
	    <option value="selectmenu">select menu</option>
            <option value="hidden">hidden</option>
	  </select>
	</td>
	<td width="220"><input type="text" size="32" name="fieldname"/></td>
	<td width="220"><textarea cols="32" rows="1" name="heading" wrap></textarea></td>
	<td width="100">&nbsp;</td>
        <td width="180" align="left"><input type="submit" name="fieldinsert" class="insert" value="Insert"/></td>
      </tr>
    </table>
  </form>
  
  <% if (showLyris) { %><%@ include file="forms-lyris.jhtml" %><% } %>
    <% if (showiContact) { %><%@ include file="forms-icontact.jhtml" %><% } %>
      <% if (showConstantContact) { %><%@ include file="forms-constantcontact.jhtml" %><% } %>
        <% if (showMailChimp) { %><%@ include file="forms-mailchimp.jhtml" %><% } %>
	  
          <hr/>
	  <p>
            <b>File Upload.</b><br/>
            If you wish to allow users to upload a file, enter the title and upload instructions below. (The file will be attached to the email sent to the form recipient; the uploaded file name will be included in the CSV summary.)
	  </p>
	  <form method="post">
            <input type="hidden" name="form_id" value="<%=form.form_id%>"/>
            <table>
              <tr>
		<td align="center" valign="top">Required<br/><input type="checkbox" name="filerequired" <% if (form.filerequired) out.print("checked"); %> value="true"/></td>
		  <td align="center" valign="top">Size<br/><input type="text" size="2" name="filefieldsize" value="<%=form.filefieldsize%>"/></td>
		  <td valign="top">File upload title<br/><textarea name="filetitle" rows="1" cols="32"><%=Util.blankIfNull(form.filetitle)%></textarea></td>
		  <td valign="top">File upload instructions<br/><textarea name="fileinstructions" rows="5" cols="50"><%=Util.blankIfNull(form.fileinstructions)%></textarea></td>
		  <td><input type="submit" name="fileupdate" class="update" value="Update"/></td>
              </tr>
            </table>
	  </form>
	  
<% } // end if form selected %>

<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/footer.jhtml" %>
	  
