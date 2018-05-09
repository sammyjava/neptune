package net.ims.jcms.bootstrap;

import net.ims.jcms.*;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.io.FileNotFoundException;
import java.io.IOException;
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
 * This is the jcms-bootstrap version of Page, using BSGrid and BSPane instead of Layout and Pane. Also, uses getKey() instead of public primary key field.
 * Metakeywords has been removed, since they're ignored by search engines and not used anywhere else.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class BSPage extends Record {

	/** the name of the database table, used by audit method */
	private static String tablename = "bspages";
	
	/** bspages.pid: the primary key for this record, obtained with getKey() */
	private int pid;
	
	/** bspages.bsgrid_id: identifies the root grid/layout for this page, obtained with getBSGridId() */
	private int bsgrid_id;

	/** bspages.label: identifies the page with a user-friendly label, obtained with getLabel() */
	private String label;

	/** bspages.metadescription: the text for the META description tag in the HTML header */
	public String metadescription;
	
	/** bspages.headtitle: the text for the TITLE tag in the HTML header */
	public String headtitle;

	/** bspages.title: the title of this page shown at the top of the content of this page */
	public String title;

	/** bspages.othermeta: other meta tags to be placed in the HTML header */
	public String othermeta;

	/** bspages.created: the creation timestamp */
	public Timestamp created;

	/** bspages.updated: the update timestamp */
	public Timestamp updated;

	/** tags for this page, drawn from pagetags table */
	public String[] tags;

	/**
	 * Construct an instance simply setting instance variables to defaults.  Does not insert a page.
	 */
	public BSPage() {
		setDefaults();
	}

	/**
	 * Construct given a ResultSet. Public for use in net.ims.jcms.Content.
	 */
	public BSPage(ResultSet rs) throws SQLException {
		populate(rs);
	}

	/**
	 * Construct given DB connection and an int primary key.
	 */
	BSPage(DB db, int key) throws SQLException {
		select(db, key);
	}

	/**
	 * Construct given ServletContext to get DB connection and an int primary key
	 */
	public BSPage(ServletContext context, int key) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context);
			select(db, key);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Do a SELECT query and set instance variables given a DB connection and a primary key
	 */
	protected void select(DB db, int key) throws SQLException {
		db.executeQuery("SELECT * FROM bspages WHERE pid="+key);
		if (db.rs.next()) populate(db.rs);
		getTags(db);
	}
	
	/**
	 * Populate this instance from a ResultSet.
	 */
	protected void populate(ResultSet rs) throws SQLException {
		pid = rs.getInt("pid");
		bsgrid_id = rs.getInt("bsgrid_id");
		label = rs.getString("label");
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
	 * Inserts a new page record into the database and retrieve/set the resulting pid. Uses table default bsgrid_id and label if not supplied.
	 */
	protected void insert(DB db) throws SQLException {
		String query = "INSERT INTO bspages (" +
			"bsgrid_id,label, metadescription, othermeta, headtitle, title" +
			") VALUES (" +
			intOrDefault(bsgrid_id)+"," +
			charsOrDefault(label)+"," +
			charsOrDefault(metadescription)+"," +
			charsOrDefault(othermeta)+"," +
			charsOrDefault(headtitle)+"," +
			charsOrDefault(title) +
			")";
		db.executeUpdate(query);
		// get primary key
		db.executeQuery("SELECT max(pid) AS pid FROM bspages");
		db.rs.next();
		pid = db.rs.getInt("pid");
		refresh(db); // updates created instance var
	}

	/**
	 * Updates a database record with current instance values given DB object
	 */
	protected void update(DB db) throws SQLException {
		String query = "UPDATE bspages SET " +
			"updated="+db.now()+", " +
			"bsgrid_id="+bsgrid_id+", " +
			"label="+charsOrNull(label)+", " +
			"metadescription="+charsOrNull(metadescription)+", " +
			"othermeta="+charsOrNull(othermeta)+", " +
			"headtitle="+charsOrNull(headtitle)+", " +
			"title="+charsOrNull(title)+" " +
			"WHERE pid="+pid;
		db.executeUpdate(query);
		refresh(db); // updates updated instance var
	}

	/**
	 * Deletes this BSPage record (and associated relationships.)
	 */
	protected void delete(DB db) throws SQLException {
		db.executeUpdate("DELETE FROM nodelinks WHERE pid="+pid);
		db.executeUpdate("DELETE FROM bspages_content WHERE pid="+pid);
		db.executeUpdate("DELETE FROM pagetags WHERE pid="+pid);
		db.executeUpdate("DELETE FROM bspages WHERE pid="+pid);
		setDefaults();
	}

	/**
	 * Sets default values.
	 */
	protected void setDefaults() {
		pid = 0;
		bsgrid_id = 0;
		label = null;
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
	 * Alpha on label; assumes label cannot be null (enforced by DB constraint).
	 */
	public int compareTo(Object o) {
		BSPage that = (BSPage) o;
		return this.getLabel().compareTo(that.getLabel());
	}

	/**
	 * Two pages are equal if they have the same primary key
	 */
	public boolean equals(Object o) {
		BSPage that = (BSPage) o;
		return this.getKey()==that.getKey();
	}

	/**
	 * Return true if default page, not an actual pages record, hides details of default
	 */
	public boolean isDefault() {
		return pid==0;
	}


	// ----------------------------------------- getters and setters -------------------------------------------------

	public int getKey() {
		return pid;
	}

	public int getBSGridId() {
		return bsgrid_id;
	}
	public void setBSGridId(int id) {
		bsgrid_id = id;
	}

	public String getLabel() {
		return label;
	}
	public void setLabel(String l) {
		label = l;
	}

	// -------------------------------------- other methods ----------------------------------------------

	/**
	 * Set this page's root BSGrid
	 */
	public void setBSGrid(DB db, BSGrid bsgrid) throws SQLException {
		setBSGridId(bsgrid.getKey());
		update(db);
	}
	/**
	 * Set this page's root BSGrid
	 */
	public void setBSGrid(ServletContext context, BSGrid bsgrid) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context);
			setBSGrid(db, bsgrid);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Associates this record with the given node by inserting a record in nodelinks effective immediately.
	 */
	void linkToNode(DB db, Node n) throws SQLException {
		db.executeUpdate("INSERT INTO nodelinks VALUES ("+n.getKey()+","+pid+")");
	}    
	/**
	 * Associates this record with the given node by inserting a record in nodelinks.
	 */
	public void linkToNode(ServletContext context, Node n) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context);
			linkToNode(db, n);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Return an array of Nodes that this BSPage is linked to, past, present and future. Order is Node natural ordering. Public so can be reached from net.ims.jcms.
	 */
	public Node[] getNodes(DB db) throws SQLException {
		TreeSet<Node> set = new TreeSet<Node>();
		db.executeQuery("SELECT DISTINCT nodes.* FROM nodes,nodelinks WHERE nodes.nid=nodelinks.nid AND pid="+pid);
		while (db.rs.next()) set.add(new Node(db.rs));
		return set.toArray(new Node[0]);
	}
	/**
	 * Return an array of Nodes that this BSPage is linked to, past, present and future.
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
	 * Return an array of Nodes that this BSPage is currently linked to, ordered by Node natural ordering.
	 */
	Node[] getCurrentNodes(DB db) throws SQLException {
		TreeSet<Node> set = new TreeSet<Node>();
		db.executeQuery("SELECT DISTINCT nodes.* FROM nodes,nodelinks_current WHERE nodes.nid=nodelinks_current.nid AND pid="+pid);
		while (db.rs.next()) set.add(new Node(db.rs));
		return set.toArray(new Node[0]);
	}
	/**
	 * Return an array of Nodes that this BSPage is currently linked to.
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
	 * Return an array of Nodes that this BSPage is linked to in the future, ordered by Node natural ordering.
	 */
	Node[] getFutureNodes(DB db) throws SQLException {
		TreeSet<Node> set = new TreeSet<Node>();
		db.executeQuery("SELECT nodes.* FROM nodes,nodelinks_future WHERE nodes.nid=nodelinks_future.nid AND pid="+pid);
		while (db.rs.next()) set.add(new Node(db.rs));
		return set.toArray(new Node[0]);
	}
	/**
	 * Return an array of Nodes that this BSPage is linked to in the future
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
	 * Return an array of all BSPage, sorted by natural ordering.
	 */
	static BSPage[] getAll(DB db) throws SQLException {
		TreeSet<BSPage> set = new TreeSet<BSPage>();
		db.executeQuery("SELECT * FROM bspages");
		while (db.rs.next()) set.add(new BSPage(db.rs));
		return set.toArray(new BSPage[0]);
	}
	/**
	 * Return an array of all BSPages
	 */
	public static BSPage[] getAll(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context);
			return getAll(db);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Return an array of BSPages matching a search term, ordered by natural ordering.
	 */
	public static BSPage[] getMatching(ServletContext context, String s) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
		DB db = null;
		try {
			TreeSet<BSPage> set = new TreeSet<BSPage>();
			db = new DB(context);
			String query = 
				"SELECT bspages.* FROM bspages " +
				"WHERE label "+db.iLike()+" '%"+s+"%' " +
				"OR metadescription "+db.iLike()+" '%"+s+"%' " +
				"OR headtitle "+db.iLike()+" '%"+s+"%' " +
				"OR title "+db.iLike()+" '%"+s+"%' " +
				"UNION " +
				"SELECT bspages.* FROM bspages,pagetags WHERE bspages.pid=pagetags.pid AND tag "+db.iLike()+" '%"+s+"%' ";
			// check to see if searchterm is an int; if so, append search for matching pid
			try {
				int pid = Integer.parseInt(s);
				query += "UNION SELECT bspages.* FROM bspages WHERE pid="+pid+" ";
			} catch (Exception ex) {
				// not an int
			}
			db.executeQuery(query);
			while (db.rs.next()) set.add(new BSPage(db.rs));
			return set.toArray(new BSPage[0]);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Return an array of all BSPage pids in the database
	 */
	// static int[] getAllPids(DB db) throws SQLException {
	// 	db.executeQuery("SELECT count(*) AS count FROM bspages");
	// 	db.rs.next();
	// 	int count = db.rs.getInt("count");
	// 	int[] pids = new int[count];
	// 	int i = 0;
	// 	db.executeQuery("SELECT pid,label FROM bspages ORDER BY label,pid");
	// 	while (db.rs.next()) pids[i++] = db.rs.getInt("pid");
	// 	return pids;
	// }

	/**
	 * Return an array of all BSPage pids in the database 
	 */
	// public static int[] getAllPids(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
	// 	DB db = null;
	// 	try {
	// 		db = new DB(context);
	// 		return getAllPids(db);
	// 	} finally {
	// 		if (db!=null) db.close();
	// 	}
	// }

	/**
	 * Return an array of orphaned BSPages (pages never linked to a node) ordered by label
	 */
	static BSPage[] getOrphans(DB db) throws SQLException {
		TreeSet<BSPage> set = new TreeSet<BSPage>();
		db.executeQuery("SELECT * FROM bspages WHERE pid NOT IN (SELECT DISTINCT pid FROM nodelinks WHERE pid IS NOT NULL)");
		while (db.rs.next()) set.add(new BSPage(db.rs));
		return set.toArray(new BSPage[0]);
	}
	/**
	 * Return an array of orphan BSPage pids (pages never linked to a node)
	 */
	public static BSPage[] getOrphans(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context);
			return getOrphans(db);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Return true if this page has never been associated with a node. Public so can be reached from jcms.ims.net.
	 */
	public boolean isOrphan(DB db) throws SQLException {
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
	 * Delete orphaned pages records, those that have no corresonding record in nodelinks, along with related records.  Return the number deleted.
	 */
	public static int purgeOrphans(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context);
			db.executeQuery("SELECT count(*) AS count FROM bspages");
			db.rs.next();
			int before = db.rs.getInt("count");
			db.executeUpdate("DELETE FROM pagetags WHERE pid NOT IN (SELECT DISTINCT pid FROM nodelinks WHERE pid IS NOT NULL)");
			db.executeUpdate("DELETE FROM bspages_content WHERE pid NOT IN (SELECT DISTINCT pid FROM nodelinks WHERE pid IS NOT NULL)");
			db.executeUpdate("DELETE FROM bspages WHERE pid NOT IN (SELECT DISTINCT pid FROM nodelinks WHERE pid IS NOT NULL)");
			db.executeQuery("SELECT count(*) AS count FROM bspages");
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
			db.executeQuery("SELECT count(*) AS count FROM bspages WHERE pid NOT IN (SELECT DISTINCT pid FROM nodelinks WHERE pid IS NOT NULL)");
			db.rs.next();
			return db.rs.getInt("count");
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Return true if this page is currently the active link to a node.
	 */
	public boolean active(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
		Node[] nodes = getNodes(context);
		for (int i=0; i<nodes.length; i++) {
			NodeLink nl = nodes[i].getCurrentNodeLink(context);
			if (pid==nl.pid) return true;
		}
		return false;
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
	 * Return the root BSGrid currently associated with this page
	 */
	BSGrid getRootBSGrid(DB db) throws SQLException {
		if (isDefault()) {
			return new BSGrid();
		} else {
			return new BSGrid(db, bsgrid_id);
		}
	}
	/**
	 * Return the root BSGrid currently associated with this page
	 */
	public BSGrid getRootBSGrid(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context);
			return getRootBSGrid(db);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Set the associated content for the given BSPane on this page
	 */
	void setContent(DB db, BSPane pane, Content content) throws SQLException {
		removeContent(db, pane);
		db.executeUpdate("INSERT INTO bspages_content (pid,bspane_id,cid) VALUES ("+pid+","+pane.getKey()+","+content.getKey()+")");
	}
	/**
	 * Set the associated content for the given pane on this page
	 */
	public void setContent(ServletContext context, BSPane pane, Content content) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context);
			setContent(db, pane, content);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Removes the associated content for the given BSPane on this page
	 */
	void removeContent(DB db, BSPane pane) throws SQLException {
		db.executeUpdate("DELETE FROM bspages_content WHERE pid="+pid+" AND bspane_id="+pane.getKey());
	}
	/**
	 * Removes the associated content for the given pane on this page
	 */
	public void removeContent(ServletContext context, BSPane pane) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
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
	Content getContent(DB db, BSPane pane) throws SQLException {
		db.executeQuery("SELECT * FROM bspages_content WHERE pid="+pid+" AND bspane_id="+pane.getKey());
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
	public Content getContent(ServletContext context, BSPane pane) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context);
			return getContent(db, pane);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Return an array of Content for this page, sorted by Content natural ordering. (Is this used? Should it be BSPane ordering?)
	 */
	Content[] getContent(DB db) throws SQLException {
		TreeSet<Content> set = new TreeSet<Content>();
		db.executeQuery("SELECT content.* FROM content,bspages_content WHERE content.cid=bspages_content.cid AND bspages_content.pid="+pid);
		while (db.rs.next()) set.add(new Content(db.rs));
		return set.toArray(new Content[0]);
	}
	/**
	 * Return an array of Content for this page, sorted by Content natural ordering.
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
	 * Return a timestamp indicating the last time this page, or its content, were created or updated.
	 */
	public Timestamp lastModified(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
		Timestamp t = null;
		DB db = null;
		try {
			db = new DB(context);
			db.executeQuery("SELECT created,updated FROM bspages WHERE pid="+pid);
			if (db.rs.next()) {
				Timestamp c = db.rs.getTimestamp("created");
				Timestamp u = db.rs.getTimestamp("updated");
				if (u==null) {
					t = c;
				} else {
					t = u;
				}
				db.executeQuery("SELECT created,updated FROM bspages_content,content WHERE bspages_content.pid="+pid+" AND bspages_content.cid=content.cid");
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
	public BSPage clone(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context);
			BSPage p = new BSPage();
			// clone metadata
			p.label = label+" *CLONE*";
			p.metadescription = metadescription;
			p.othermeta = othermeta;
			p.headtitle = headtitle;
			p.title = title;
			p.bsgrid_id = bsgrid_id;
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
		TreeSet<String> set = new TreeSet<String>();
		db.executeQuery("SELECT tag FROM pagetags WHERE pid="+pid);
		while (db.rs.next()) set.add(db.rs.getString("tag"));
		tags = set.toArray(new String[0]);
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
	public BSPage[] getRelated(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
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
			BSPage[] pages = new BSPage[pcTree.size()];
			Iterator<PidCount> treeIterator = pcTree.iterator();
			int i = 0;
			while (treeIterator.hasNext()) {
				PidCount pc = treeIterator.next();
				pages[i++] = new BSPage(db, pc.p);
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

	/**
	 * Return true if user has edit permission on EVERY node that schedules the given Page. This was in ControlPanelUser in jcms.
	 */
	public boolean hasPermission(ServletContext context, ControlPanelUser user) throws SQLException, NamingException, ClassNotFoundException, FileNotFoundException, IOException, UserNotFoundException, ValidationException {
		if (isOrphan(context)) return true;
		Node[] nodes = getNodes(context);
		for (int i=0; i<nodes.length; i++) if (!user.hasPermission(context, nodes[i])) return false;
		return true;
	}
	
}
