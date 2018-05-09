package net.ims.jcms.extras;

import net.ims.jcms.*;

import net.ims.icontact.ResourceNotFoundException;
import net.ims.icontact.WarningException;
import net.ims.icontact.Credentials;
import net.ims.icontact.Account;
import net.ims.icontact.ClientFolder;
import net.ims.icontact.Contact;
import net.ims.icontact.List;
import net.ims.icontact.Subscription;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.InputStreamReader;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.rmi.RemoteException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Vector;

import javax.mail.MessagingException;
import javax.naming.NamingException;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.xml.rpc.ServiceException;

import com.ctctlabs.ctctwsjavalib.CTCTConnection;
import com.ctctlabs.ctctwsjavalib.ContactList;

import com.oreilly.servlet.MultipartRequest;

import org.apache.http.HttpResponse;
import org.apache.http.auth.InvalidCredentialsException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.HttpClientBuilder;


import org.json.JSONObject;

/**
 * Extends Record to encapsulate a forms table record.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class Form extends Record {

  /** the name of the database table, used by audit method */
  private static String tablename = "forms";

  /** forms.form_id, primary key **/
  public int form_id = 0;

  /** forms.recipientname **/
  public String recipientname;

  /** forms.recipientemail **/
  public String recipientemail;

  /** forms.sendername **/
  public String sendername;

  /** forms.senderemail **/
  public String senderemail;

  /** forms.title **/
  public String title;

  /** forms.submitvalue **/
  public String submitvalue;

  /** forms.instructions **/
  public String instructions;

  /** forms.thankyou **/
  public String thankyou;

  /** forms.confirmationsubject **/
  public String confirmationsubject;

  /** forms.confirmationmessage **/
  public String confirmationmessage;

  /** forms.signupinstructions **/
  public String signupinstructions;

  /** forms.redirecturl **/
  public String redirecturl;

  /** forms.filetitle **/
  public String filetitle;

  /** forms.fileinstructions **/
  public String fileinstructions;

  /** forms.filerequired **/
  public boolean filerequired = false;

  /** forms.filefieldsize **/
  public int filefieldsize = 30;

  /** forms.usecaptcha **/
  public boolean usecaptcha = true;

  /** forms.alertonerror **/
  public boolean alertonerror = false;

  /** array of this Form's FormFields **/
  public FormField[] fields;

  /** array of this Form's FormLyrisLists **/
  public FormLyrisList[] lyrislists;

  /** array of this Form's iContact lists **/
  public FormiContactList[] iContactlists;

  /** array of this Form's Constant Contact lists **/
  public FormConstantContactList[] constantContactlists;

  /** array of this Form's MailChimp lists **/
  public FormMailChimpList[] mailChimplists;

  /**
   * Constructs a default instance
   */
  public Form() {
    setDefaults();
  }

  /**
   * Constructs given a primary key.
   */
  public Form(ServletContext context, int key) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      select(db, key);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Constructs given a primary key.
   */
  Form(DB db, int key) throws SQLException {
    setDefaults();
    select(db, key);
  }

  /**
   * Constructs given a populated ResultSet.  NOTE: fields, lyrislists and iContactlists will NOT be populated!
   */
  Form(ResultSet rs) throws SQLException {
    populate(rs);
  }

  /**
   * Populate a record given a key
   */
  protected void select(DB db, int key) throws SQLException {
    db.executeQuery("SELECT * FROM forms WHERE form_id="+key);
    if (db.rs.next()) {
      populate(db.rs);
      getFields(db);
      getLyrisLists(db);
      getiContactLists(db);
      getConstantContactLists(db);
      getMailChimpLists(db);
    }
  }

  /**
   * Populate a record from a populated ResultSet
   */
  protected void populate(ResultSet rs) throws SQLException {
    form_id = rs.getInt("form_id");
    recipientname = rs.getString("recipientname");
    recipientemail = rs.getString("recipientemail");
    sendername = rs.getString("sendername");
    senderemail = rs.getString("senderemail");
    title = rs.getString("title");
    submitvalue = rs.getString("submitvalue");
    instructions = rs.getString("instructions");
    thankyou = rs.getString("thankyou");
    signupinstructions = rs.getString("signupinstructions");
    confirmationsubject = rs.getString("confirmationsubject");
    confirmationmessage = rs.getString("confirmationmessage");
    redirecturl = rs.getString("redirecturl");
    filetitle = rs.getString("filetitle");
    fileinstructions = rs.getString("fileinstructions");
    filerequired = rs.getBoolean("filerequired");
    filefieldsize = rs.getInt("filefieldsize");
    usecaptcha = rs.getBoolean("usecaptcha");
    alertonerror = rs.getBoolean("alertonerror");
  }

  /**
   * Refresh this instance with values from the database record
   */
  protected void refresh(DB db) throws SQLException {
    select(db, form_id);
  }

  /**
   * Insert a new form record along with two required fields: email and name.
   */
  protected void insert(DB db) throws SQLException, ValidationException {
    validate();
    db.executeUpdate("INSERT INTO forms (" +
		     "recipientname,recipientemail,sendername,senderemail," +
		     "title,submitvalue,instructions," +
		     "filetitle,fileinstructions,filerequired,filefieldsize," +
                     "thankyou,signupinstructions,redirecturl,confirmationsubject,confirmationmessage" +
		     ") VALUES (" +
		     charsOrNull(recipientname)+","+charsOrNull(recipientemail)+","+charsOrNull(sendername)+","+charsOrNull(senderemail)+"," +
		     charsOrNull(title)+","+charsOrNull(submitvalue)+","+charsOrNull(instructions)+","+
		     charsOrNull(filetitle)+","+charsOrNull(fileinstructions)+","+filerequired+","+intOrNull(filefieldsize)+", " +
		     charsOrNull(thankyou)+","+charsOrNull(signupinstructions)+","+charsOrNull(redirecturl)+"," +
		     charsOrNull(confirmationsubject)+","+charsOrNull(confirmationmessage) +
		     ")"
		     );
    db.executeQuery("SELECT max(form_id) AS form_id FROM forms");
    db.rs.next();
    // get key and reload
    form_id = db.rs.getInt("form_id");
    // insert email and name fields
    FormField email = new FormField();
    email.form_id = form_id;
    email.num = 1;
    email.fieldname = "email";
    email.heading = "E-mail address";
    email.textinput = true;
    email.required = true;
    email.insert(db);
    FormField fullname = new FormField();
    fullname.form_id = form_id;
    fullname.num = 2;
    fullname.fieldname = "fullname";
    fullname.heading = "Full name";
    fullname.textinput = true;
    fullname.required = true;
    fullname.insert(db);
    // reload this form
    select(db, form_id);
  }

  /**
   * Updates a forms record with current values.
   */
  protected void update(DB db) throws SQLException, ValidationException {
    validate();
    db.executeUpdate("UPDATE forms SET "+
		     "recipientname="+charsOrNull(recipientname)+", " +
		     "recipientemail="+charsOrNull(recipientemail)+", " +
		     "sendername="+charsOrNull(sendername)+", " +
		     "senderemail="+charsOrNull(senderemail)+", " +
		     "title="+charsOrNull(title)+", " +
		     "submitvalue="+charsOrNull(submitvalue)+", " +
		     "instructions="+charsOrNull(instructions)+", " +
		     "thankyou="+charsOrNull(thankyou)+", " +
		     "redirecturl="+charsOrNull(redirecturl)+", " +
		     "filetitle="+charsOrNull(filetitle)+", " +
		     "fileinstructions="+charsOrNull(fileinstructions)+", " +
		     "filerequired="+filerequired+", " +
		     "filefieldsize="+intOrNull(filefieldsize)+", " +
		     "usecaptcha="+db.bool(usecaptcha)+", " +
		     "alertonerror="+db.bool(alertonerror)+", " +
		     "confirmationsubject="+charsOrNull(confirmationsubject)+", " +
		     "confirmationmessage="+charsOrNull(confirmationmessage)+", " +
		     "signupinstructions="+charsOrNull(signupinstructions)+" " +
		     "WHERE form_id="+form_id);
    // reload
    select(db, form_id);
  }

  /**
   * Throw a ValidationException if fields are invalid.
   */
  void validate() throws ValidationException {
    String error = "";
    if (nullOrEmpty(title)) error += "Label is required. ";
    if (nullOrEmpty(submitvalue)) error += "Submit button text is required. ";
    if (nullOrEmpty(recipientname)) error += "Recipient name is required. ";
    if (nullOrEmpty(recipientemail)) error += "Recipient email is required. ";
    if (!nullOrEmpty(confirmationmessage) && nullOrEmpty(sendername)) error += "Confirmation sender name is required. ";
    if (!nullOrEmpty(confirmationmessage) && nullOrEmpty(senderemail)) error += "Confirmation sender email is required. ";
    if (nullOrEmpty(instructions)) error += "Instructions are required. ";
    if (nullOrEmpty(thankyou)) error += "Thank-you message is required. ";
    if (error.length()>0) throw new ValidationException(error);
  }

  /**
   * Delete this record (and child records, including posted form data!).
   */
  protected void delete(DB db) throws SQLException {
    db.executeUpdate("DELETE FROM postedformfields WHERE postedform_id IN (SELECT postedform_id FROM postedforms WHERE form_id="+form_id+")");
    db.executeUpdate("DELETE FROM postedforms WHERE form_id="+form_id);
    db.executeUpdate("DELETE FROM formlyrislists WHERE form_id="+form_id);
    db.executeUpdate("DELETE FROM formicontactlists WHERE form_id="+form_id);
    db.executeUpdate("DELETE FROM formconstantcontactlists WHERE form_id="+form_id);
    db.executeUpdate("DELETE FROM formmailchimplists WHERE form_id="+form_id);
    db.executeUpdate("DELETE FROM formfieldoptions WHERE formfield_id IN (SELECT formfield_id FROM formfields WHERE form_id="+form_id+")");
    db.executeUpdate("DELETE FROM formfields WHERE form_id="+form_id);
    db.executeUpdate("DELETE FROM forms WHERE form_id="+form_id);
    setDefaults();
  }

  /**
   * Set default values.
   */
  protected void setDefaults() {
    form_id = 0;
    recipientname = null;
    recipientemail = null;
    sendername = null;
    senderemail = null;
    title = null;
    submitvalue = "SEND";
    instructions = null;
    thankyou = null;
    signupinstructions = null;
    confirmationsubject = null;
    confirmationmessage = null;
    redirecturl = null;
    filetitle = null;
    fileinstructions = null;
    filerequired = false;
    filefieldsize = 30;
    usecaptcha = true;
    alertonerror = false;
    fields = null;
    lyrislists = null;
    iContactlists = null;
  }

  /**
   * Return true if this is a default (uninstantiated) instance 
   */
  public boolean isDefault() {
    return form_id==0;
  }

  /**
   * Insert an audit record for the given action
   */
  protected void audit(DB db, char action, String username) throws SQLException {
    Audit a = new Audit();
    a.tablename = tablename;
    a.record_id = form_id;
    a.action = action;
    a.username = username;
    a.description = title;
    a.insert(db);
  }

  /**
   * Return an array of all forms records, ordered by title, zero length if no form records.
   */
  static Form[] getAll(DB db) throws SQLException {
    db.executeQuery("SELECT count(*) AS count FROM forms");
    db.rs.next();
    int count = db.rs.getInt("count");
    Form[] forms = new Form[count];
    db.executeQuery("SELECT * FROM forms ORDER BY title");
    int i = 0;
    while (db.rs.next()) forms[i++] = new Form(db.rs);
    return forms;
  }

  /**
   * Return an array of all forms records, ordered by name alphabetically.
   */
  public static Form[] getAll(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return getAll(db);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return a new Form which is a clone of this form, except for an altered title.  Does all required database inserts.
   */
  Form clone(DB db) throws SQLException, ValidationException {
    Form f = new Form();
    if (form_id==0) return f;
    // insert forms record
    f.title = title+" (CLONE)";
    f.submitvalue = submitvalue;
    f.recipientname = recipientname;
    f.recipientemail = recipientemail;
    f.sendername = sendername;
    f.senderemail = senderemail;
    f.instructions = instructions;
    f.thankyou = thankyou;
    f.signupinstructions = signupinstructions;
    f.confirmationsubject = confirmationsubject;
    f.confirmationmessage = confirmationmessage;
    f.redirecturl = redirecturl;
    f.filetitle = filetitle;
    f.fileinstructions = fileinstructions;
    f.filerequired = filerequired;
    f.filefieldsize = filefieldsize;
    f.usecaptcha = usecaptcha;
    f.alertonerror = alertonerror;
    f.insert(db);
    // remove default email and fullname fields
    FormField ff0 = f.fields[0];
    FormField ff1 = f.fields[1];
    ff0.delete(db);
    ff1.delete(db);
    // insert fields
    for (int i=0; i<fields.length; i++) {
      FormField ff = fields[i];
      FormFieldOption[] ffoptions = fields[i].options;
      ff.form_id = f.form_id;
      ff.insert(db);
      // insert options
      for (int j=0; j<ffoptions.length; j++) {
	FormFieldOption ffo = ffoptions[j];
	ffo.formfield_id = ff.formfield_id;
	ffo.insert(db);
      }
    }
    // insert lyris lists
    for (int i=0; i<lyrislists.length; i++) {
      FormLyrisList fll = lyrislists[i];
      fll.form_id = f.form_id;
      fll.insert(db);
    }
    // insert iContact lists
    for (int i=0; i<iContactlists.length; i++) {
      FormiContactList fil = iContactlists[i];
      fil.form_id = f.form_id;
      fil.insert(db);
    }
    // reload this form
    select(db, form_id);
    // reload cloned form and return
    f.select(db, f.form_id);
    return f;
  }

  /**
   * Return a new Form instance which is a clone of this form, except for an altered title.  Does all required database inserts.
   */
  public Form clone(ServletContext context) throws SQLException, ValidationException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return clone(db);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Sorts alphabetically by title.
   */
  public int compareTo(Object o) {
    Form that = (Form) o;
    return this.title.compareTo(that.title);
  }

  /**
   * Return true if same primary key
   */
  public boolean equals(Object o) {
    Form that = (Form) o;
    return this.form_id==that.form_id;
  }

  /**
   * Populate this form's formfields records, ordered by num, zero length if no form records.
   */
  void getFields(DB db) throws SQLException {
    db.executeQuery("SELECT count(*) AS count FROM formfields WHERE form_id="+form_id);
    db.rs.next();
    int count = db.rs.getInt("count");
    fields = new FormField[count];
    db.executeQuery("SELECT * FROM formfields WHERE form_id="+form_id+" ORDER BY num");
    int i = 0;
    while (db.rs.next()) fields[i++] = new FormField(db.rs);
    // populate FormFieldOptions manually, since db.rs constructor doesn't do it
    for (i=0; i<fields.length; i++) fields[i].getOptions(db);
  }

  /**
   * Populate this form's array of lyris lists, zero length if none.  Sorted by num.
   */
  void getLyrisLists(DB db) throws SQLException {
    db.executeQuery("SELECT count(*) AS count FROM formlyrislists WHERE form_id="+form_id);
    db.rs.next();
    int count = db.rs.getInt("count");
    lyrislists = new FormLyrisList[count];
    db.executeQuery("SELECT * FROM formlyrislists WHERE form_id="+form_id+" ORDER BY num");
    int i = 0;
    while (db.rs.next()) lyrislists[i++] = new FormLyrisList(db.rs);
  }

  /**
   * Populate this form's array of iContact lists, zero length if none.  Sorted by name.
   */
  void getiContactLists(DB db) throws SQLException {
    db.executeQuery("SELECT count(*) AS count FROM formicontactlists WHERE form_id="+form_id);
    db.rs.next();
    int count = db.rs.getInt("count");
    iContactlists = new FormiContactList[count];
    db.executeQuery("SELECT * FROM formicontactlists WHERE form_id="+form_id+" ORDER BY name");
    int i = 0;
    while (db.rs.next()) iContactlists[i++] = new FormiContactList(db.rs);
  }

  /**
   * Populate this form's array of Constant Contact lists, zero length if none.  Sorted by name.
   */
  void getConstantContactLists(DB db) throws SQLException {
    db.executeQuery("SELECT count(*) AS count FROM formconstantcontactlists WHERE form_id="+form_id);
    db.rs.next();
    int count = db.rs.getInt("count");
    constantContactlists = new FormConstantContactList[count];
    db.executeQuery("SELECT * FROM formconstantcontactlists WHERE form_id="+form_id+" ORDER BY name");
    int i = 0;
    while (db.rs.next()) constantContactlists[i++] = new FormConstantContactList(db.rs);
  }

  /**
   * Populate this form's array of MailChimp lists, zero length if none.  Sorted by name.
   */
  void getMailChimpLists(DB db) throws SQLException {
    db.executeQuery("SELECT count(*) AS count FROM formmailchimplists WHERE form_id="+form_id);
    db.rs.next();
    int count = db.rs.getInt("count");
    mailChimplists = new FormMailChimpList[count];
    db.executeQuery("SELECT * FROM formmailchimplists WHERE form_id="+form_id+" ORDER BY listname");
    int i = 0;
    while (db.rs.next()) mailChimplists[i++] = new FormMailChimpList(db.rs);
  }

  /**
   * Return true if this form has a textinput field "email".
   */
  public boolean hasEmail() {
    if (fields!=null) {
      for (int i=0; i<fields.length; i++) if (fields[i].fieldname.equals("email")) return true;
    }
    return false;
  }

  /**
   * Process a multipart form post, throwing a ValidationException if required fields are not supplied.
   */
  public void process(MultipartRequest mpr,
		      ServletContext context,
		      String referer) throws ValidationException, MessagingException, UnsupportedEncodingException, NamingException, ServiceException, RemoteException, 
					     SQLException, FileNotFoundException, ClassNotFoundException, IOException, 
					     ResourceNotFoundException, WarningException, ParseException, InvalidCredentialsException, net.ims.icontact.ValidationException {
    // get the uploaded file (if there is one)
    File uploadfile = mpr.getFile("uploadfile");

    // validation - check for missing required fields
    Vector<String> missing = new Vector<String>();
    for (int i=0; i<fields.length; i++) {
      if (fields[i].required) {
	if (nullOrEmpty(mpr.getParameter(fields[i].fieldname))) missing.add(fields[i].heading);
      }
    }
    // validation - check for file upload
    if (filerequired && uploadfile==null) missing.add(filetitle);
    // construct and throw validation error with some English grammar variations
    if (!missing.isEmpty()) {
      String error = "The following required fields are missing:<ul>";
      if (missing.size()==1) error = "The following required field is missing:<ul>";
      for (int j=0; j<missing.size(); j++) error += "<li>"+missing.get(j)+"</li>";
      if (missing.size()==1) {
	error += "</ul> Please complete this field and submit the form again.";
      } else {
	error += "</ul> Please complete these fields and submit the form again.";
      }
      throw new ValidationException(error);
    }

    // load email and fullname, null if not posted
    String email = mpr.getParameter("email");
    String fullname = mpr.getParameter("fullname");
    // validate email if supplied in "email" field
    if (!nullOrEmpty(email) && !Mailer.isValidEmail(email)) throw new ValidationException("You have supplied an invalid e-mail address.");

    // create Mailer from default InitialContext
    Mailer mailer = new Mailer();

    // construct mail to form recipient
    String fromAddress = Setting.getString(context, "site_email");
    String fromName = Setting.getString(context, "site_name")+" website";
    // use submitter as sender if email supplied
    if (!nullOrEmpty(email)) {
      fromAddress = email;
      if (!nullOrEmpty(fullname)) {
	fromName = fullname;
      } else {
	fromName = null;
      }
    }
    String subject = title+" form submission";
    if (!nullOrEmpty(fullname)) subject += " from "+fullname;
    // load message with data
    String message  = "The "+title+" form has been submitted with the following data.\n\n";
    message += "Referrer: "+referer+"\n\n";
    for (int i=0; i<fields.length; i++) {
      message += "["+fields[i].fieldname+"]\n";
      if (fields[i].hidden || fields[i].textinput || fields[i].textarea || fields[i].radio || fields[i].selectmenu) {
	String value = mpr.getParameter(fields[i].fieldname);
	if (!nullOrEmpty(value)) message += value+"\n";
	message += "\n";
      } else if (fields[i].checkbox) {
	String[] values = mpr.getParameterValues(fields[i].fieldname);
	if (values!=null) {
	  for (int j=0; j<values.length; j++) if (!nullOrEmpty(values[j])) message += values[j]+"\n";
	}
	message += "\n";
      }
    }

    // process lyris signup
    String[] listnames = mpr.getParameterValues("listname");
    if (listnames!=null && !nullOrEmpty(email)) {
      Lyris lyris = new Lyris(context);
      for (int i=0; i<listnames.length; i++) {
	try {
	  // throws RemoteException when member already exists on list
	  int memberID = lyris.createSingleMember(email, fullname, listnames[i]);
	  message += "Member "+email+" added to "+listnames[i]+"; member ID = "+memberID+".\n";
	} catch (RemoteException ex) {
	  if (ex.getMessage().indexOf("already exists")>0) {
	    message += email+" is already a member of "+listnames[i]+".\n";
	  } else {
	    throw ex;
	  }
	}
      }
      message += "\n";
    }

    // process iContact signup
    String[] listIds = mpr.getParameterValues("listId");
    if (listIds!=null && !nullOrEmpty(email)) {
      int accountId = Setting.getInt(context, "icontact_accountid");
      int clientFolderId = Setting.getInt(context, "icontact_clientfolderid");
      if (accountId==0 || clientFolderId==0) throw new ValidationException("Missing icontact_accountid and/or icontact_clientfolderid in Settings.");
      Credentials creds = new Credentials(context);
      Account account = new Account(creds, accountId);
      ClientFolder clientFolder = new ClientFolder(creds, account, clientFolderId);
      Contact contact = new Contact(creds, account, clientFolder, email);
      for (int i=0; i<listIds.length; i++) {
	int listId = Integer.parseInt(listIds[i]);
	List list = new List(creds, account, clientFolder, listId);
	boolean subscribe = false;
	try {
	  // see if subscription already exists
	  String subscriptionId = list.getPrimaryKey()+"_"+contact.getPrimaryKey();
	  Subscription subscription = new Subscription(creds, account, clientFolder, subscriptionId);
	  message += "Contact "+email+" is already on list "+list.name+" with status: "+subscription.status+"; subscription ID="+subscription.getPrimaryKey()+".\n";
	} catch (ResourceNotFoundException ex) {
	  // subscription does not exist
	  subscribe = true;
	}
	if (subscribe) {
	  try {
	    Subscription subscription = new Subscription(creds, account, clientFolder, contact.getPrimaryKey(), list.getPrimaryKey(), "normal");
	    if (subscription.getPrimaryKey()!=null) message += "Contact "+email+" added to "+list.name+" with status: "+subscription.status+"; subscription ID="+subscription.getPrimaryKey()+".\n";
	  } catch (WarningException ex) {
	    message += "Warning when subscribing "+email+" to "+list.name+": \n";
	    message += ex.getMessage()+"\n";
	  }
	}
      }
    }

    // process Constant Contact signup
    String links[] = mpr.getParameterValues("link");
    if (links!=null && !nullOrEmpty(email)) {
      String ccUsername = context.getInitParameter("constantcontact.username");
      String ccPassword = context.getInitParameter("constantcontact.password");
      // connect to Constant Contact
      CTCTConnection conn = new CTCTConnection();
      boolean success = conn.authenticate(Util.CC_API_KEY, ccUsername, ccPassword);
      if (success) {
	// create list of lists to be added to
	ArrayList<ContactList> contactLists = new ArrayList<ContactList>();
	for (int i=0; i<links.length; i++) contactLists.add(conn.getContactList(links[i]));
	// load user info
	HashMap<String,Object> hashMap = new HashMap<String,Object>();
	hashMap.put("ContactLists", contactLists);
	hashMap.put("EmailAddress", email);
	hashMap.put("Name", fullname);
	// split fullname into firstname and lastname, using Name field seems broken
	String[] names = fullname.split(" ");
	hashMap.put("FirstName", names[0]);
	if (names.length>1) hashMap.put("LastName", names[1]);
	hashMap.put("OptInSource", "ACTION_BY_CONTACT"); // doesn't seem to work
	// create contact, adding to lists
	com.ctctlabs.ctctwsjavalib.Contact contact = conn.createContact(hashMap);
	contact.commit();
      }
    }

    // process MailChimp signup
    String[] listid = Util.getStringValues(mpr, "listid");
    if (listid.length>0 && !nullOrEmpty(email)) {
      String apiKey = context.getInitParameter("mailchimp.apikey");
      String[] pieces = apiKey.split("-");
      String dc = pieces[1];
      String apiURL = "https://"+dc+".api.mailchimp.com/2.0/lists/subscribe.json";
      JSONObject jsonEmail = new JSONObject();
      jsonEmail.put("email", email);
      HttpPost p = new HttpPost(apiURL);
      HttpClient c = HttpClientBuilder.create().build();
      for (int i=0; i<listid.length; i++) {
	JSONObject json = new JSONObject();
	json.put("apikey", apiKey);
	json.put("email", jsonEmail);
	json.put("id", listid[i]); 
	json.put("update_existing", true);
	json.put("send_welcome", true);
	// post it
	p.setEntity(new StringEntity(json.toString(), "UTF-8"));
	HttpResponse r = c.execute(p);
	BufferedReader rd = new BufferedReader(new InputStreamReader(r.getEntity().getContent()));
	String line = "";
	while ((line=rd.readLine())!=null) {
	  if (line.trim().length()>0) {
	    JSONObject o = new JSONObject(line);
	    // check for error, indicated by presence "status" field
	    try {
	      String status = (String) o.get("status");
	      // error if we reach this
	      int code = (Integer) o.get("code");
	      String name = (String) o.get("name");
	      String error = (String) o.get("error");
	      message += "MailChimp "+status+" code="+code+": "+name+" "+error;
	    } catch (Exception ex) {
	      // no error
	      String mcEmail = (String) o.get("email");
	      String euid = (String) o.get("euid");
	      String leid = (String) o.get("leid");
	      message += "MailChimp subscription successful: list ID="+listid[i]+" euid="+euid+" leid="+leid+"\n\n";
	    }
	  }
	}
      }
    }

    // send notification email
    if (uploadfile==null) {
      // no uploaded file, send single part message
      mailer.send(fromAddress, fromName, recipientemail, recipientname, subject, message);
    } else {
      // uploaded file, add name to message body and file as attachment, then send
      message += "[uploaded_filename] ("+filetitle+")\n";
      message += uploadfile.getName()+"\n";
      message += "\n";
      mailer.setText(fromAddress, fromName, recipientemail, recipientname, subject, message);
      mailer.addAttachment(uploadfile);
      mailer.sendMultipart();
    }

    // (optionally) send confirmation to submitter
    if (!nullOrEmpty(confirmationmessage) && !nullOrEmpty(email) && !nullOrEmpty(senderemail)) {
      subject = confirmationsubject;
      if (subject==null || subject.length()==0) subject = title+" form submission received.";
      mailer.send(senderemail, sendername, email, fullname, subject, confirmationmessage);
    }

    // insert posted data into storage table
    PostedForm.process(mpr, context, referer);

  }

  /**
   * Return a blank if mpr is null or field value is null, else return field value
   */
  public static String prefill(MultipartRequest mpr, HttpServletRequest request, String field) {
    if (mpr==null) {
      String val = request.getParameter(field);
      if (val==null) {
	return "";
      } else {
	return val;
      }
    } else if (mpr.getParameter(field)==null) {
      return "";
    } else {
      return mpr.getParameter(field);
    }
  }

}
