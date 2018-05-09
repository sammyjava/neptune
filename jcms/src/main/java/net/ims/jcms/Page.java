package net.ims.jcms;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.io.FileNotFoundException;
import java.util.Arrays;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;
import java.util.Vector;
import javax.naming.NamingException;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpSession;

import org.apache.commons.collections.bag.HashBag;

/**
 * Extends Record to encapsulate a single page, which is a container of content which may or may not be associated with
 * a node in the heirarchy.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class Page extends Record {

  /** the name of the database table, used by audit method */
  private static String tablename = "pages";

  /** pages.pid: the primary key for this record */
  public int pid = 0;

  /** pages.metakeywords: the text for the META keywords tag in the HTML header */
  public String metakeywords = null;

  /** pages.metadescription: the text for the META description tag in the HTML header */
  public String metadescription = null;

  /** pages.headtitle: the text for the TITLE tag in the HTML header */
  public String headtitle = null;

  /** pages.title: the title of this page shown at the top of the content of this page */
  public String title = null;

  /** pages.othermeta: other meta tags to be placed in the HTML header */
  public String othermeta = null;

  /** pages.created: the creation timestamp */
  public Timestamp created = null;

  /** pages.updated: the update timestamp */
  public Timestamp updated = null;

  /** pages.layout_id: layouts.layout_id identifies the layout for this page */
  public int layout_id = 0;

  /** pages.label: identifies the page with a user-friendly label */
  public String label = null;

  /** tags for this page, drawn from pagetags table */
  public String[] tags = null;

  /**
   * Constructs simply setting instance variables to defaults.  Does not insert a page.
   */
  public Page() {
    setDefaults();
  }

  /**
   * Construct given a ResultSet
   */
  Page(ResultSet rs) throws SQLException {
    populate(rs);
  }

  /**
   * Constructs a default page and insert it into the database.
   */
  Page(DB db) throws SQLException {
    setDefaults();
    insert(db);
  }

  /**
   * Constructs given DB connection and an int primary key
   */
  Page(DB db, int key) throws SQLException {
    select(db, key);
  }

  /**
   * Constructs given ServletContext to get DB connection and an int primary key
   */
  public Page(ServletContext context, int key) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      select(db, key);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Does a SELECT query and set instance variables given a DB connection and a primary key
   */
  protected void select(DB db, int key) throws SQLException {
    db.executeQuery("SELECT * FROM pages WHERE pid="+key);
    if (db.rs.next()) populate(db.rs);
    getTags(db);
  }

  /**
   * Populate this instance from a ResultSet.
   */
  protected void populate(ResultSet rs) throws SQLException {
    pid = rs.getInt("pid");
    label = rs.getString("label");
    layout_id = rs.getInt("layout_id");
    metakeywords = rs.getString("metakeywords");
    metadescription = rs.getString("metadescription");
    othermeta = rs.getString("othermeta");
    headtitle = rs.getString("headtitle");
    title = rs.getString("title");
    created = rs.getTimestamp("created");
    updated = rs.getTimestamp("updated");
  }

  /**
   * Refresh this instance with values from the database record
   */
  protected void refresh(DB db) throws SQLException {
    select(db, pid);
  }

  /**
   * Inserts a new page record into the database and retrieve/set the resulting pid.
   */
  protected void insert(DB db) throws SQLException {
    long refid = new Date().getTime();
    String query = "INSERT INTO pages (" +
      "refid, layout_id, label, metakeywords, metadescription, othermeta, headtitle, title" +
      ") VALUES (" +
      refid+"," +
      layout_id+"," +
      charsOrDefault(label)+"," +
      charsOrDefault(metakeywords)+"," +
      charsOrDefault(metadescription)+"," +
      charsOrDefault(othermeta)+"," +
      charsOrDefault(headtitle)+"," +
      charsOrDefault(title) +
      ")";
    db.executeUpdate(query);
    db.executeQuery("SELECT * FROM pages WHERE refid="+refid);
    db.rs.next();
    pid = db.rs.getInt("pid");
    created = db.rs.getTimestamp("created");
  }

  /**
   * Updates a database record with current instance values given DB object
   */
  protected void update(DB db) throws SQLException {
    String query = "UPDATE pages SET " +
      "updated="+db.now()+", " +
      "layout_id="+layout_id+", " +
      "label="+charsOrNull(label)+", " +
      "metakeywords="+charsOrNull(metakeywords)+", " +
      "metadescription="+charsOrNull(metadescription)+", " +
      "othermeta="+charsOrNull(othermeta)+", " +
      "headtitle="+charsOrNull(headtitle)+", " +
      "title="+charsOrNull(title)+" " +
      "WHERE pid="+pid;
    db.executeUpdate(query);
    db.executeQuery("SELECT updated FROM pages WHERE pid="+pid);
    db.rs.next();
    updated = db.rs.getTimestamp("updated");
  }

  /**
   * Deletes this Page record (and associated relationships.)
   */
  protected void delete(DB db) throws SQLException {
    db.executeUpdate("DELETE FROM nodelinks WHERE pid="+pid);
    db.executeUpdate("DELETE FROM pages_content WHERE pid="+pid);
    db.executeUpdate("DELETE FROM pagetags WHERE pid="+pid);
    db.executeUpdate("DELETE FROM pages WHERE pid="+pid);
    setDefaults();
  }

  /**
   * Sets default values.  Assume that layout_id=1 exists.
   */
  protected void setDefaults() {
    pid = 0;
    layout_id = 1;
    label = null;
    metakeywords = null;
    metadescription = null;
    othermeta = null;
    headtitle = null;
    title = null;
    created = null;
    updated = null;
    tags = new String[0];
  }

  /**
   * Inserts an audit record for the given action
   */
  protected void audit(DB db, char action, String username) throws SQLException {
    Audit a = new Audit();
    a.tablename = tablename;
    a.record_id = pid;
    a.action = action;
    a.username = username;
    a.description = "";
    if (label!=null) a.description = label;
    if (title!=null) a.description += " ("+title+")";
    a.insert(db);
  }

  /**
   * Required by Comparable interface; returns zero since doesn't make sense for Pages.
   */
  public int compareTo(Object o) {
    return 0;
  }

  /**
   * Required to load Pages into a set; pages are equal iff they have the same pid.
   */
  public boolean equals(Object o) {
    Page that = (Page)o;
    return (this.pid==that.pid);
  }

  /**
   * Return true if default page, not an actual pages record, hides details of default
   */
  public boolean isDefault() {
    return pid==0;
  }

  /**
   * Associates this record with the given node by inserting a record in nodelinks effective immediately.
   */
  void linkToNode(DB db, int nid) throws SQLException {
    db.executeUpdate("INSERT INTO nodelinks VALUES ("+nid+","+pid+")");
  }    

  /**
   * Associates this record with the given node by inserting a record in nodelinks.
   */
  public void linkToNode(ServletContext context, int nid) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      linkToNode(db, nid);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return an array of Nodes that this Page is linked to, past, present and future.
   */
  Node[] getNodes(DB db) throws SQLException {
    // get the nid values first, since we only have one db connection
    db.executeQuery("SELECT count(DISTINCT nid) AS count FROM nodelinks WHERE pid="+pid);
    db.rs.next();
    int count = db.rs.getInt("count");
    int[] nids = new int[count];
    db.executeQuery("SELECT DISTINCT nid FROM nodelinks WHERE pid="+pid+" ORDER BY nid");
    int i = 0;
    while (db.rs.next()) {
      nids[i++] = db.rs.getInt("nid");
    }
    Node[] nodes = new Node[count];
    for (i=0; i<nodes.length; i++) {
      nodes[i] = new Node(db, nids[i]); 
    }
    Arrays.sort(nodes);
    return nodes;
  }

  /**
   * Return an array of Nodes that this Page is linked to, past, present and future.
   */
  public Node[] getNodes(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return getNodes(db);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return an array of Nodes that this Page is currently linked to, ordered by label
   */
  Node[] getCurrentNodes(DB db) throws SQLException {
    db.executeQuery("SELECT count(*) AS count FROM nodelinks_current WHERE pid="+pid);
    db.rs.next();
    int count = db.rs.getInt("count");
    Node[] nodes = new Node[count];
    db.executeQuery("SELECT nodes.* FROM nodes,nodelinks_current WHERE nodes.nid=nodelinks_current.nid AND pid="+pid);
    int i = 0;
    while (db.rs.next()) nodes[i++] = new Node(db.rs);
    for (i=0; i<nodes.length; i++) nodes[i].updateLabel(db);
    Arrays.sort(nodes);
    return nodes;
  }


  /**
   * Return an array of Nodes that this Page is currently linked to.
   */
  public Node[] getCurrentNodes(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return getCurrentNodes(db);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return an array of Nodes that this Page is linked to in the future, ordered by label
   */
  Node[] getFutureNodes(DB db) throws SQLException {
    db.executeQuery("SELECT count(*) AS count FROM nodelinks_future WHERE pid="+pid);
    db.rs.next();
    int count = db.rs.getInt("count");
    Node[] nodes = new Node[count];
    db.executeQuery("SELECT nodes.* FROM nodes,nodelinks_future WHERE nodes.nid=nodelinks_future.nid AND pid="+pid);
    int i = 0;
    while (db.rs.next()) nodes[i++] = new Node(db.rs);
    for (i=0; i<nodes.length; i++) nodes[i].updateLabel(db);
    Arrays.sort(nodes);
    return nodes;
  }

  /**
   * Return an array of Nodes that this Page is linked to in the future
   */
  public Node[] getFutureNodes(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return getFutureNodes(db);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return an array of all Pages
   */
  static Page[] getAll(DB db) throws SQLException {
    int[] pids = getAllPids(db);
    Page[] pages = new Page[pids.length];
    for (int i=0; i<pids.length; i++) {
      pages[i] = new Page(db, pids[i]);
    }
    return pages;
  }

  /**
   * Return an array of all Pages
   */
  public static Page[] getAll(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return getAll(db);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return an array of Pages matching a search term.
   */
  public static Page[] getMatching(ServletContext context, String s) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      String query = 
	"SELECT pages.* FROM pages " +
	"WHERE label "+db.iLike()+" '%"+s+"%' " +
	"OR metakeywords "+db.iLike()+" '%"+s+"%' " +
	"OR metadescription "+db.iLike()+" '%"+s+"%' " +
	"OR headtitle "+db.iLike()+" '%"+s+"%' " +
	"OR title "+db.iLike()+" '%"+s+"%' " +
	"UNION " +
	"SELECT pages.* FROM pages,pagetags WHERE pages.pid=pagetags.pid AND tag "+db.iLike()+" '%"+s+"%' ";
      // check to see if searchterm is an int; if so, append search for matching pid
      try {
	int pid = Integer.parseInt(s);
	query += "UNION SELECT pages.* FROM pages WHERE pid="+pid+" ";
      } catch (Exception ex) {
	// not an int
      }
      query += "ORDER BY label,pid";
      db.executeQuery(query);
      // load into a vector so we can count
      Vector<Page> v = new Vector<Page>();
      while (db.rs.next()) v.add(new Page(db.rs));
      // covert vector to array, cast to Page
      Object[] vo = v.toArray();
      Page[] pages = new Page[v.size()];
      for (int i=0; i<pages.length; i++) pages[i] = (Page)vo[i];
      return pages;
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return an array of all Page pids in the database
   */
  static int[] getAllPids(DB db) throws SQLException {
    db.executeQuery("SELECT count(*) AS count FROM pages");
    db.rs.next();
    int count = db.rs.getInt("count");
    int[] pids = new int[count];
    int i = 0;
    db.executeQuery("SELECT pid,label FROM pages ORDER BY label,pid");
    while (db.rs.next()) pids[i++] = db.rs.getInt("pid");
    return pids;
  }

  /**
   * Return an array of all Page pids in the database 
   */
  public static int[] getAllPids(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return getAllPids(db);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return an array of orphan Page pids (pages never linked to a node) ordered by label
   */
  static int[] getOrphanPids(DB db) throws SQLException {
    db.executeQuery("SELECT count(*) AS count FROM pages WHERE pid NOT IN (SELECT DISTINCT pid FROM nodelinks WHERE pid IS NOT NULL)");
    db.rs.next();
    int count = db.rs.getInt("count");
    int[] pids = new int[count];
    int i = 0;
    db.executeQuery("SELECT pid FROM pages WHERE pid NOT IN (SELECT DISTINCT pid FROM nodelinks WHERE pid IS NOT NULL) ORDER BY label,pid");
    while (db.rs.next()) pids[i++] = db.rs.getInt("pid");
    return pids;
  }

  /**
   * Return an array of orphan Page pids (pages never linked to a node)
   */
  public static int[] getOrphanPids(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return getOrphanPids(db);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return true if this page has never been associated with a node.
   */
  boolean isOrphan(DB db) throws SQLException {
    db.executeQuery("SELECT count(*) AS count FROM nodelinks WHERE pid="+pid);
    db.rs.next();
    return (db.rs.getInt("count")==0);
  }

  /**
   * Return true if this page is not associated with a node (at any point in time).
   */
  public boolean isOrphan(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return isOrphan(db);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return an array of orphan Pages (pages never linked to a node) ordered by label
   */
  public static Page[] getOrphanPages(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      db.executeQuery("SELECT count(*) AS count FROM pages WHERE pid NOT IN (SELECT DISTINCT pid FROM nodelinks WHERE pid IS NOT NULL)");
      db.rs.next();
      int count = db.rs.getInt("count");
      Page[] pages = new Page[count];
      int i = 0;
      db.executeQuery("SELECT * FROM pages WHERE pid NOT IN (SELECT DISTINCT pid FROM nodelinks WHERE pid IS NOT NULL) ORDER BY label,pid");
      while (db.rs.next()) pages[i++] = new Page(db.rs);
      return pages;
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Delete orphaned pages records, those that have no corresonding record in nodelinks, along with related records.  Return the number deleted.
   */
  public static int purgeOrphans(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      db.executeQuery("SELECT count(*) AS count FROM pages");
      db.rs.next();
      int before = db.rs.getInt("count");
      db.executeUpdate("DELETE FROM pagetags WHERE pid NOT IN (SELECT DISTINCT pid FROM nodelinks WHERE pid IS NOT NULL)");
      db.executeUpdate("DELETE FROM pages_content WHERE pid NOT IN (SELECT DISTINCT pid FROM nodelinks WHERE pid IS NOT NULL)");
      db.executeUpdate("DELETE FROM pages WHERE pid NOT IN (SELECT DISTINCT pid FROM nodelinks WHERE pid IS NOT NULL)");
      db.executeQuery("SELECT count(*) AS count FROM pages");
      db.rs.next();
      int after = db.rs.getInt("count");
      return (before - after);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return the number of orphaned pages records.
   */
  public static int getOrphanCount(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      db.executeQuery("SELECT count(*) AS count FROM pages WHERE pid NOT IN (SELECT DISTINCT pid FROM nodelinks WHERE pid IS NOT NULL)");
      db.rs.next();
      return db.rs.getInt("count");
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return true if this page is currently the active link to a node.
   */
  boolean active(DB db) throws SQLException {
    Node[] nodes = getNodes(db);
    for (int i=0; i<nodes.length; i++) {
      NodeLink nl = nodes[i].getCurrentNodeLink(db);
      if (pid==nl.pid) return true;
    }
    return false;
  }

  /**
   * Return true if this page is currently the active link to a node.
   */
  public boolean active(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return active(db);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return true if this page was associated with a node in the past, but is not, currently.
   */
  boolean expired(DB db) throws SQLException {
    db.executeQuery("SELECT count(*) AS past FROM nodelinks WHERE pid="+pid+" AND starttime<"+db.now());
    db.rs.next();
    int past = db.rs.getInt("past");
    db.executeQuery("SELECT count(*) AS present FROM nodelinks_current WHERE pid="+pid);
    db.rs.next();
    int present = db.rs.getInt("present");
    return (past>0 && present==0);
  }

  /**
   * Return true if this page was associated with a node in the past, but is not, currently.
   */
  public boolean expired(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return expired(db);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return true if this page is pending, ie. is linked to a node to start in the future (and is not currently linked to a node).
   */
  boolean pending(DB db) throws SQLException {
    db.executeQuery("SELECT count(*) AS present FROM nodelinks_current WHERE pid="+pid);
    db.rs.next();
    int present = db.rs.getInt("present");
    db.executeQuery("SELECT count(*) AS future FROM nodelinks_future WHERE pid="+pid);
    db.rs.next();
    int future = db.rs.getInt("future");
    return (present==0 && future>0);
  }

  /**
   * Return true if this page is pending, ie. is linked to a node to start in the future (and not with any in the past).
   */
  public boolean pending(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return pending(db);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return the Layout currently associated with this page
   */
  Layout getLayout(DB db) throws SQLException {
    if (isDefault()) {
      return new Layout();
    } else {
      return new Layout(db, layout_id);
    }
  }

  /**
   * Return the Layout currently associated with this page
   */
  public Layout getLayout(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return getLayout(db);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Set the associated content for the given pane on this page
   */
  void setContent(DB db, int pane, int cid) throws SQLException {
    removeContent(db, pane);
    db.executeUpdate("INSERT INTO pages_content (pid,pane,cid) VALUES ("+pid+","+pane+","+cid+")");
  }

  /**
   * Set the associated content for the given pane on this page
   */
  public void setContent(ServletContext context, int pane, int cid) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      setContent(db, pane, cid);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Removes the associated content for the given pane on this page
   */
  void removeContent(DB db, int pane) throws SQLException {
    db.executeUpdate("DELETE FROM pages_content WHERE pid="+pid+" AND pane="+pane);
  }

  /**
   * Removes the associated content for the given pane on this page
   */
  public void removeContent(ServletContext context, int pane) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      removeContent(db, pane);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return the content for a given pane on this page
   */
  Content getContent(DB db, int pane) throws SQLException {
    db.executeQuery("SELECT * FROM pages_content WHERE pid="+pid+" AND pane="+pane);
    if (db.rs.next()) {
      int cid = db.rs.getInt("cid");
      return new Content(db, cid);
    } else {
      return new Content();
    }
  }

  /**
   * Return the content for a given pane on this page
   */
  public Content getContent(ServletContext context, int pane) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return getContent(db, pane);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return an array of Content for this page, sorted by increasing pane.
   */
  Content[] getContent(DB db) throws SQLException {
    db.executeQuery("SELECT count(*) AS count FROM pages_content WHERE pid="+pid);
    db.rs.next();
    int count = db.rs.getInt("count");
    Content[] content = new Content[count];
    int i = 0;
    db.executeQuery("SELECT content.* FROM content,pages_content WHERE content.cid=pages_content.cid AND pages_content.pid="+pid+" ORDER BY pane");
    while (db.rs.next()) content[i++] = new Content(db.rs);
    return content;
  }

  /**
   * Return an array of Content for this page, sorted by increasing pane.
   */
  public Content[] getContent(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return getContent(db);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return a timestamp indicating the last time this page, or its content items, were created or updated.
   */
  public Timestamp lastModified(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    Timestamp t = null;
    DB db = null;
    try {
      db = new DB(context);
      db.executeQuery("SELECT created,updated FROM pages WHERE pid="+pid);
      if (db.rs.next()) {
	Timestamp c = db.rs.getTimestamp("created");
	Timestamp u = db.rs.getTimestamp("updated");
	if (u==null) {
	  t = c;
	} else {
	  t = u;
	}
	db.executeQuery("SELECT created,updated FROM pages_content,content WHERE pages_content.pid="+pid+" AND pages_content.cid=content.cid");
	while (db.rs.next()) {
	  c = db.rs.getTimestamp("created");
	  u = db.rs.getTimestamp("updated");
	  if (u==null) {
	    if (t.compareTo(c)>0) t = c;
	  } else {
	    if (t.compareTo(u)>0) t = u;
	  }
	}
      }
    } finally {
      if (db!=null) db.close();
    }
    return t;
  }

  /**
   * Clone a new page using metadata from this page, copying the layout.
   */
  public Page clone(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      Page p = new Page();
      // clone metadata
      p.label = label+" *CLONE*";
      p.metakeywords = metakeywords;
      p.metadescription = metadescription;
      p.othermeta = othermeta;
      p.headtitle = headtitle;
      p.title = title;
      p.layout_id = layout_id;
      p.insert(db);
      // insert tags and refresh
      db.executeUpdate("INSERT INTO pagetags (pid,tag) SELECT "+p.pid+", tag  FROM pagetags WHERE pid="+pid);
      p.getTags(db);
      return p;
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Retrieve the tags for this page.  Called internally to populate tags[].  Tags are alpha ordered.  Zero-length array is returned if no tags.
   */
  void getTags(DB db) throws SQLException {
    db.executeQuery("SELECT count(*) AS count FROM pagetags WHERE pid="+pid);
    db.rs.next();
    int count = db.rs.getInt("count");
    tags = new String[count];
    db.executeQuery("SELECT tag FROM pagetags WHERE pid="+pid+" ORDER BY tag");
    int i = 0;
    while (db.rs.next()) tags[i++] = db.rs.getString("tag");
  }

  /**
   * Replace the tags for this page from a single input string.  Populates tags[] and writes pagetags records.  Does the fancy parsing.
   */
  public void setTags(ServletContext context, String s) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    // bail if null string given
    if (s==null) return;
    // tags are all lower-case
    s = s.toLowerCase();
    // blow away invalid characters
    s = s.replace('\'', ' ');
    s = s.replace(',', ' ');
    s = s.replace(';', ' ');
    // handle quoted strings by substituting '|' for space within
    int m = s.indexOf("\"");
    int n = 0;
    int c = 0;
    while ((n=s.indexOf("\"",m+1))>-1) {
      s = s.substring(0,m)+s.substring(m+1,n).replace(' ','|')+s.substring(n+1);
      m = s.indexOf("\"");
    }
    // clear any remaining mismatched double quote
    s = s.replace('\"', ' ');
    // parse out space-delimited tags
    tags = s.split(" ");
    DB db = null;
    try {
      db = new DB(context);
      // blow away former tags
      db.executeUpdate("DELETE FROM pagetags WHERE pid="+pid);
      for (int i=0; i<tags.length; i++) {
	try {
	  if (tags[i]!=null && tags[i].trim().length()>0) {
	    String tag = tags[i].replace('|',' '); // substitute back
	    db.executeUpdate("INSERT INTO pagetags (pid,tag) VALUES ("+pid+","+charsOrNull(tag)+")");
	  }
	} catch (SQLException ex) {
	  // skip if just duplicate tag
	  if (!ex.getMessage().contains("pagetags_unique")) throw new SQLException(ex);
	}
      }
      // refresh tags so alpha sorted and correct length
      getTags(db);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return all current pages "related" to this one because they have matching tags.
   */
  public Page[] getRelated(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    HashBag pidBag = new HashBag(); // HashBag keeps a count of elements
    DB db = null;
    try {
      db = new DB(context);
      // iterate over tags
      for (int i=0; i<tags.length; i++) {
	db.executeQuery("SELECT * FROM pagetags WHERE pid<>"+pid+" AND tag='"+tags[i]+"' ORDER BY pid");
	while (db.rs.next()) pidBag.add(new Integer(db.rs.getInt("pid")));
      }
      // get the unique pids
      Set uniqueSet = pidBag.uniqueSet();
      Iterator uniqueIterator = uniqueSet.iterator();
      // load pid,count pairs into a TreeSet, which orders them by count
      TreeSet<PidCount> pcTree = new TreeSet<PidCount>();
      while (uniqueIterator.hasNext()) {
	Integer pidInteger = (Integer)uniqueIterator.next();
	int p = pidInteger.intValue();
	int c = pidBag.getCount(pidInteger);
	PidCount pc = new PidCount(p,c);
	pcTree.add(pc);
      }
      // load an array with the resulting pages
      Page[] pages = new Page[pcTree.size()];
      Iterator<PidCount> treeIterator = pcTree.iterator();
      int i = 0;
      while (treeIterator.hasNext()) {
	PidCount pc = treeIterator.next();
	pages[i++] = new Page(db, pc.p);
      }
      return pages;
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Utility class encapsulates a pid and count, with a comparator for ordering by count.
   */
  class PidCount implements Comparable {
    int p;
    int c;
    PidCount(int p, int c) {
      this.p = p;
      this.c = c;
    }
    // comparator allows sorting by count
    public int compareTo(Object o) {
      PidCount that = (PidCount)o;
      if (this.p==that.p) {
	return 0;
      } else if (this.c==that.c) {
	return 1; // equal counts, but not equal objects
      } else {
	return that.c - this.c;
      }
    }
    // equal only if pid is the same
    public boolean equals(Object o) {
      PidCount that = (PidCount)o;
      return this.p==that.p;
    }
  }

}
