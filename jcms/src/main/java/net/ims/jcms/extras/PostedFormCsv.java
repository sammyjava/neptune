package net.ims.jcms.extras;

import net.ims.jcms.*;
import com.csvreader.CsvWriter;

import java.io.*;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.*;
import javax.servlet.http.*;

/**
 * Servlet to dump a CSV file with the given form's posted data.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class PostedFormCsv extends HttpServlet {

  /**
   * @see javax.servlet.GenericServlet#init(javax.servlet.ServletConfig)
   */
  public void init(ServletConfig config) throws ServletException {
    super.init(config);
  }

  /**
   * @see javax.servlet.http.HttpServlet#doGet(javax.servlet.http.HttpServletRequest,
   *      javax.servlet.http.HttpServletResponse)
   */
  public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    try {
      makeCsv(request, response);
    } catch (SQLException ex) {
      // only thrown from db.close(), not a worry
    }
  }
  
  /**
   * @see javax.servlet.http.HttpServlet#doPost(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
   */
  protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    try {
      makeCsv(request, response);
    } catch (SQLException ex) {
      // only thrown from db.close(), not a worry
    }
  }


  /**
   * Output a CSV file from a GET or POST request.
   * 
   * @param request             the Servlet's request object
   * @param response            the Servlet's request object
   * @throws ServletException
   * @throws IOException
   * @throws SQLException
   */
  public void makeCsv(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
    
    DB db = null;

    try {

      HttpSession session = request.getSession();
      ServletContext context = session.getServletContext();

      // instantiate the DB object
      db = new DB(context);

      // get the form ID from the request
      int form_id = 0;
      if (request.getParameter("form_id")!=null) form_id = Integer.parseInt(request.getParameter("form_id"));

      // instantiate the Form
      Form form = new Form(db, form_id);

      // bail if form doesn't exist
      if (form.form_id==0) {
	db.close();
	return;
      }

      // get an array of distinct form fields, for column headings, which are alphabetically sorted
      String[] headings = getHeadings(db,form_id);

      // form filename from form_id and current date
      SimpleDateFormat filenameDate = new SimpleDateFormat("yyyyMMddHHmm");
      String filename = "form_"+form_id+"_"+filenameDate.format(new Date())+".csv";

      // response headers
      response.setHeader("Content-Disposition", "attachment; filename="+filename);
      response.setHeader("Expires", "0");
      response.setHeader("Cache-Control", "must-revalidate, post-check=0, pre-check=0");
      response.setHeader("Pragma", "public");
      response.setContentType("text/csv");
      
      // instantiate the CsvWriter
      CsvWriter csv = new CsvWriter(response.getWriter(), ',');

      // output the column headings
      csv.writeRecord(headings);

      // output the data, hopefully organized by heading
      SimpleDateFormat timepostedFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
      PostedForm[] postedforms = PostedForm.getAll(db, form_id);
      for (int i=0; i<postedforms.length; i++) {
	String[] values = new String[headings.length];
	values[0] = timepostedFormat.format(postedforms[i].timeposted);
	for (int j=1; j<headings.length; j++) {
	  values[j] = "";
	  for (int k=0; k<postedforms[i].postedformfields.length; k++) {
	    if (postedforms[i].postedformfields[k].value!=null && headings[j].equals(postedforms[i].postedformfields[k].fieldname)) {
	      if (values[j].length()>0) values[j] += "|"; // use pipe symbol to separate multi-valued fields
	      values[j] += postedforms[i].postedformfields[k].value;
	    }
	  }
	}
	csv.writeRecord(values);
      }

      // wrap up
      csv.flush();

    } catch (Exception ex) {
      
      System.err.println("Error in "+getClass().getName()+": "+ex.toString());
      
    } finally {
      
      if (db!=null) db.close();
      
    }

  }

  /**
   * Return an array of ALL distinct form field names posted for the given form, plus timeposted in front.
   */
  static String[] getHeadings(DB db, int form_id) throws SQLException {
    db.executeQuery("SELECT count(DISTINCT fieldname) AS count FROM postedformfields WHERE postedform_id IN (SELECT postedform_id FROM postedforms WHERE form_id="+form_id+")");
    db.rs.next();
    int count = db.rs.getInt("count");
    String[] headings = new String[count+1];
    headings[0] = "timeposted";
    db.executeQuery("SELECT DISTINCT fieldname FROM postedformfields WHERE postedform_id IN (SELECT postedform_id FROM postedforms WHERE form_id="+form_id+") ORDER BY fieldname");
    int i = 1;
    while (db.rs.next()) headings[i++] = db.rs.getString("fieldname");
    return headings;
  }

}
