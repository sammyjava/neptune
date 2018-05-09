<%@ include file="/WEB-INF/include/init.inc" %>
<% pageTitle = "Docs - Contact Forms"; %>
<%@ include file="/WEB-INF/include/header.jhtml" %>
<%@ include file="/WEB-INF/include/doc-nav.jhtml" %>

<p>
  The <b>Contact Forms</b> extra allows you to build simple contact forms with all of the HTML form elements: text input, textarea, radios, checkboxes and select menus.  You can specify which fields are
  required, and you can lay out radios and checkboxes in columns.  If you have Lyris ListManager lists, you may add checkboxes to allow folks to sign up.  You can configure a confirmation message to be
  sent to the submitter via email in addition to the required thank-you message shown in the browser after they submit the contact form.  You can download a CSV file which contains all of the data posted to date.
</p>

<p>
  You may preview a form design by clicking the PREVIEW link at the top of the tool.  Note, however, that you cannot post a form in the control panel; the PREVIEW link is purely for viewing a form's layout.  You should
  test the form after you have placed it in a content pane on the site.
</p>

<p>
  A form is placed in a content pane by placing its form_id value in the extension URL.  The extension context is <b>/</b>, and the extension URL is <b>/form.jsp?form_id=#</b>, where <b>#</b> is the form_id value shown at the top
  of the tool.
</p>
<hr/>
<p>
  <b>Core Form Elements</b><br/>
  At the top of the Contact Forms tool, you see the core form elements.  These are all required, and are:
</p>
<table class="borders">
  <tr><td class="borders"><b>Title</b></td><td class="borders">The unique title of this form, for internal use.</td></tr>
  <tr><td class="borders"><b>Form recipient name</b></td><td class="borders">The name of the person that will receive a notification email when site users submit this form.</td></tr>
  <tr><td class="borders"><b>Form recipient email</b></td><td class="borders">The email address of the person that will receive the notification email.</td></tr>
  <tr><td class="borders"><b>Confirmation sender name</b></td><td class="borders">The name of the person that "sends" the confirmation email to the submitter.  Shown in the From: address.</td></tr>
  <tr><td class="borders"><b>Confirmation sender email</b></td><td class="borders">The email address of the person that "sends" the confirmation email to the submitter.  Shown in the From: address.</td></tr>
  <tr><td class="borders"><b>Instructions</b></td><td class="borders">Instructions for filling out the form.</td></tr>
  <tr><td class="borders"><b>Thank-you message</b></td><td class="borders">The response shown in the submitter's browser after a successful form submission.</td></tr>
  <tr><td>Confirmation message</td><td>Optional.  If not empty, a confirmation email is sent to the submitter after a successful form submission, containing this message.  NOTE: this field only appears if you have a form field named <b>email</b>.</td></tr>
</table>
<hr/>
<p>
  <b>Form Fields</b><br/>
  A form consists of form fields, which are stacked vertically on the form in accordance with the sorting number.  The required elements of a form field are:
</p>
<table class="borders">
  <tr><td class="borders"><b>Num</b></td><td class="borders">The sorting number.</td></tr>
  <tr><td class="borders"><b>Required</b></td><td class="borders">Check to make this a required form field.</td></tr>
  <tr><td class="borders"><b>Field Type</b></td><td class="borders">The type of HTML form element for this field: text input, textarea, checkboxes, radio buttons or select menue.  Checkboxes allow multiple choices; all others post a single value.</td></tr>
  <tr><td class="borders"><b>Field Name</b></td><td class="borders">The unique name used to identify this field in the recipient email and the CSV data file.  Not seen by end users.</td></tr>
  <tr><td><b>Heading</b></td><td>The unique heading shown on the form above this field.  This is how the field is presented to end users.</td></tr>
</table>
<p>
  In addition, certain field types have additional parameters, shown after you first insert the field into the form:
</p>
<table class="borders">
  <tr><td class="borders" align="right">text input:</td><td class="borders"><b>size</b></td><td class="borders">The size of the text field, in characters.  Default: <%=FormField.DEFAULT_TEXTINPUT_SIZE%>.</td></tr>
  <tr><td class="borders" align="right">textarea:</td><td class="borders"><b>rows, cols</b></td><td class="borders">The number of rows and columns in the textarea.  Default: <%=FormField.DEFAULT_TEXTAREA_ROWS%> rows, <%=FormField.DEFAULT_TEXTAREA_COLS%> columns.</tr>
  <tr><td align="right">checkboxes, radios:</td><td><b>columns</b></td><td>The number of columns in the layout of the checkboxes or radios.  They are displayed left to right, then down.  Default: <%=FormField.DEFAULT_COLUMNS%>.</td></tr>
</table>
<hr/>
<p>
  <b>Field Options</b><br/>
  Checkboxes, radio buttons and select menus allow the user to select pre-determined field options, which are displayed in the sort order that you specify in the field option area:
</p>
<table class="borders">
  <tr><td class="borders"><b>Num</b></td><td class="borders">The sorting number.</td></tr>
  <tr><td class="borders"><b>Default</b></td><td class="borders">Check to make this the default choice. Checkboxes may have more than one default choice, since more than one checkbox may be selected by the user.  Radios and select menus allow only one default,
  since these allow only one choice by the user.</td></tr>
  <tr><td><b>Value</b></td><td>The value of this option.</td></tr>
</table>
<hr/>
<p>
  <b>Lyris ListManager e-mail list signup.</b><br/>
  If you have Lyris ListManager e-mail lists hosted by IMS, you may add checkboxes to your form to enable users to join your lists.  Enter <b>sign-up instructions</b> to tell them about your lists and what to expect as members.
  Then, enter the parameters for each list:
</p>
<table class="borders">
  <tr><td class="borders"><b>Num</b></td><td class="borders">The sorting number.</td></tr>
  <tr><td class="borders"><b>List name</b></td><td class="borders">The name of the ListManager list.</td></tr>
  <tr><td><b>Description</b></td><td>The description of the list, visible to end users.</td></tr>
</table>
<p>
  In order to enforce an "opt-in" policy for e-mail lists, signup checkboxes cannot be checked by default.
</p>
<hr/>
<p>
  <b>CSV File Download</b><br/>
  You may download the data posted to a given form by using the <b>Download CSV File</b> button on the control panel tool.  The top row of the CSV file will contain the field names.  If a field allows multiple values (ie. it
  is a set of checkboxes), the individual values are separated by a <b>|</b> character in that field's cell.  It's up to you to separate them out.  CSV files can be read by many spreadsheet programs, such as Excel.
</p>
  
<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/footer.jhtml" %>

