package net.ims.jcms;

import java.io.FileNotFoundException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Date;
import javax.naming.NamingException;
import javax.servlet.ServletContext;

/**
 * DHTML Cache records.  Each AccessUser has a record in dhtmlcache.  These are updated when the user makes a request and no cache record is present.  Cache records are
 * deleted on a scheduled basis.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class DhtmlCache extends Record {

  /** generated from dhtmlcache.accessuser = AccessUser.getUsername() **/
  public AccessUser accessUser = null;

  /** dhtmlcache.dhtml **/
  public String dhtml = null;

  /** dhtmlcache.updated **/
  public Timestamp updated = null;

  /**
   * Constructs an empty record
   */
  public DhtmlCache() {
  }

  /**
   * Constructs given a ServletContext and AccessUser instance
   */
  public DhtmlCache(ServletContext context, AccessUser au) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException, AccessUserException {
    DB db = null;
    try {
      db = new DB(context);
      select(db, au);
      // generate and insert dhtml string if not present
      if (dhtml==null) {
	accessUser = au;
	generate(db, context); // save calls by passing both db and context (needed only by AccessUser methods)
      }
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Populate this instance given a populated ResultSet
   * NOTE: DOES NOT instantiate accessUser!
   */
  protected void populate(ResultSet rs) throws SQLException {
    dhtml = rs.getString("dhtml");
    updated = rs.getTimestamp("updated");
  }

  /**
   * Refresh this instance with values from the database record; not used
   */
  protected void refresh(DB db) throws SQLException {
  }

  /**
   * Select a record given a primary key; not used.
   */
  protected void select(DB db, int key) throws SQLException {
  }

  /**
   * Selects a record given an AccessUser instance if exists; if not, set defaults.
   */
  void select(DB db, AccessUser au) throws SQLException {
    if (au.isDefault()) {
      db.executeQuery("SELECT * FROM dhtmlcache WHERE accessuser IS NULL");
    } else {
      db.executeQuery("SELECT * FROM dhtmlcache WHERE accessuser='"+au.getUsername()+"'");
    }
    if (db.rs.next()) {
      populate(db.rs);
      accessUser = au;
    }
  }

  /**
   * Inserts a new dhtmlcache record with the current instance variable values.
   */
  protected void insert(DB db) throws SQLException {
    db.executeUpdate("INSERT INTO dhtmlcache (accessuser,dhtml,updated) VALUES ("+charsOrNull(accessUser.getUsername())+","+charsOrNull(dhtml)+","+db.now()+")");
  }
    
  /**
   * Update a record; not used.
   */
  protected void update(DB db) throws SQLException {
  }

  /**
   * Delete the current dhtmlcache record and sets instance vars to defaults.
   */
  protected void delete(DB db) throws SQLException {
    db.executeUpdate("DELETE FROM dhtmlcache WHERE accessuser="+charsOrNull(accessUser.getUsername()));
    setDefaults();
  }

  /**
   * Delete the dhtmlcache record for the provided Access User; static method, avoids using the constructor.
   */
  public static void delete(ServletContext context, AccessUser au) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      if (au.isDefault()) {
	db.executeUpdate("DELETE FROM dhtmlcache WHERE accessuser IS NULL");
      } else {
	db.executeUpdate("DELETE FROM dhtmlcache WHERE accessuser='"+au.getUsername()+"'");
      }
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Delete all dhtmlcache records.
   */
  public static void deleteAll(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      db.executeUpdate("DELETE FROM dhtmlcache");
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Sets default values.
   */
  protected void setDefaults() {
    accessUser = null;
    dhtml = null;
    updated = null;
  }

  /**
   * Return true if this is a default, uninstantiated instance
   */
  public boolean isDefault() {
    return dhtml==null;
  }

  /**
   * Does nothing - no auditing is done for this class.
   */
  protected void audit(DB db, char action, String email) {
  }

  /**
   * Returns zero for all records.
   */
  public int compareTo(Object o) {
    return 0;
  }

  /**
   * Return true if same dhtml content and access user
   */
  public boolean equals(Object o) {
    DhtmlCache that = (DhtmlCache) o;
    return this.dhtml.equals(that.dhtml) && this.accessUser.equals(that.accessUser);
  }

  /**
   * Generate the DHTML string for this instance's AccessUser, and insert it into the dhtmlcache table.
   * ServletContext must be supplied since AccessUser methods all take ServletContext as parameter.
   * NOTE: this method contains DHTML class names and such, and is therefore tied to the stylesheet.
   */
  synchronized void generate(DB db, ServletContext context) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException, AccessUserException {

    // timing diagnostic
    boolean debug = Setting.isOn(db,"site_debug");
    long startTime = 0;
    if (debug) {
      Date startDate = new java.util.Date();
      startTime = startDate.getTime();
      System.out.print(startDate+": "+Setting.getString(db,"site_name")+" generating DHTML for AccessUser "+accessUser.getUsername()+"...");
    }

    // load a StringBuffer with the DHTML divs
    StringBuffer sb = new StringBuffer();

    Node root = new Node(db, 0);
    NodeListIterator rootIterator = root.getNodeListIterator(db);
    while (rootIterator.hasNext()) {
      Node l1 = rootIterator.nextNode();
      if (l1.isVisible() && accessUser.mayAccess(context, l1)) {
	String layerId = "layer"+l1.num;
	sb.append("<div id=\""+layerId+"\">\n");
	sb.append("  <table class=\"dhtml\" cellspacing=\"0\">\n");
	// level 2
	NodeListIterator l1Iterator = l1.getNodeListIterator(db);
	while (l1Iterator.hasNext()) {
	  Node l2 = l1Iterator.nextNode();
	  if (l2.isVisible() && accessUser.mayAccess(context, l2)) {
	    String url = l2.url;	    
	    sb.append("    <tr>\n");
	    sb.append("      <td class=\"dhtml-off\" ");
	    sb.append("onMouseOver=\"this.className='dhtml-on'; showLayer('"+layerId+"');\" ");
	    sb.append("onMouseOut=\"this.className='dhtml-off'; hideLayer('"+layerId+"');\" ");
	    /* this causes problems with double requests
	       if (l2.isExternal()) {
	       sb.append("onClick=\"open('"+url+"')\" ");
	       } else {
	       sb.append("onClick=\"location.href='"+url+"'\" ");
	       }
	    */
	    sb.append(">");
	    if (l2.isExternal()) {
	      sb.append("<a class=\"dhtml\" target=\"_blank\" onMouseOver=\"showLayer('"+layerId+"');\" href=\""+url+"\">"+l2.nodename+"</a>");
	    } else {
	      sb.append("<a class=\"dhtml\" onMouseOver=\"showLayer('"+layerId+"');\" href=\""+url+"\">"+l2.nodename+"</a>");
	    }
	    sb.append("</td>\n");
	    sb.append("    </tr>\n");
	  } // end if l2.isVisible
	} // end while
	sb.append("  </table>\n");
	sb.append("</div>\n");
	sb.append("\n");
      } // end if l1isVisible
    } // end while

    // write the StringBuffer to the dhtml string
    dhtml = sb.toString();

    // insert the new record; protect against simultaneous inserts from simultaneous requests
    try {
      insert(db);
    } catch (SQLException ex) {
      if (debug) System.out.print(ex.getMessage());
    }

    // output generation time diagnostic
    if (debug) {
      long endTime = new java.util.Date().getTime();
      System.out.println((endTime-startTime)+" ms.");
    }

  }

}
