package net.ims.jcms;

import net.ims.jcms.bootstrap.*;

import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.io.FileNotFoundException;
import java.util.Date;
import java.util.Iterator;
import java.util.LinkedHashSet;
import java.util.Vector;
import java.util.TreeSet;
import javax.naming.NamingException;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpSession;

/**
 * Extends Record to contain the data for a single content table record.
 * Provides methods for inserting, updating, deleting, validation, and implements the Comparable interface for sorting.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class Content extends Record {

	/** the name of the database table, used by audit method */
	private static String tablename = "content";

	/** content.cid: the primary key for this record */
	public int cid = 0;

	/** content.copy: the actual content */
	public String copy = null;

	/** content.label: a label to identify the content */
	public String label = null;

	/** content.modulecontext: servlet context of module code to be included using <c:import> tag */
	public String modulecontext = null;

	/** content.moduleurl: URL of module code to be included using <c:import> tag */
	public String moduleurl = null;

	/** content.moduleabove: true to place module code above copy */
	public boolean moduleabove = false;

	/** content.created: the creation timestamp */
	public Timestamp created = null;

	/** content.updated: the update timestamp */
	public Timestamp updated = null;


	/**
	 * Default constructor
	 */
	public Content() {
		setDefaults();
	}

	/**
	 * Construct given DB connection and an int primary key
	 */
	public Content(DB db, int key) throws SQLException {
		select(db, key);
	}

	/**
	 * Construct given a Servlet context and primary key
	 */
	public Content(ServletContext context, int key) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context);
			select(db, key);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Construct given a Servlet context and a label.  If the label is non-unique, it is unpredictable which content record will be used to populate the instance.
	 */
	public Content(ServletContext context, String label) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context);
			db.executeQuery("SELECT * FROM content WHERE label='"+label+"'");
			if (db.rs.next()) {
				int key = db.rs.getInt("cid");
				select(db, key);
			} else {
				setDefaults();
			}
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Construct given a ResultSet.  Useful when iterating over a query result.
	 */
	public Content(ResultSet rs) throws SQLException {
		populate(rs);
	}

	/**
	 * Do a SELECT query and set instance variables given a DB connection and a primary key
	 */
	protected void select(DB db, int key) throws SQLException {
		db.executeQuery("SELECT * FROM content WHERE cid="+key);
		if (db.rs.next()) populate(db.rs);
	}

	/**
	 * Populate an instance from a provided resultset.
	 */
	public void populate(ResultSet rs) throws SQLException {
		cid = rs.getInt("cid");
		label = rs.getString("label");
		modulecontext = rs.getString("modulecontext");
		moduleurl = rs.getString("moduleurl");
		moduleabove = rs.getBoolean("moduleabove");
		copy = rs.getString("copy");
		created = rs.getTimestamp("created");
		updated = rs.getTimestamp("updated");
	}

	/**
	 * Refresh this instance with values from the database record
	 */
	protected void refresh(DB db) throws SQLException {
		select(db, cid);
	}

	/**
	 * Insert a new content record into the database and retrieve/set the resulting cid.
	 */
	protected void insert(DB db) throws SQLException {
		String query = "INSERT INTO content (" +
			"label, modulecontext, moduleurl, moduleabove, copy" +
			") VALUES (" +
			charsOrDefault(label)+"," +
			charsOrNull(modulecontext)+"," +
			charsOrNull(moduleurl)+"," +
			db.bool(moduleabove)+"," +
			charsOrDefault(copy) +
			")";
		db.executeUpdate(query);
		db.executeQuery("SELECT max(cid) AS cid FROM content");
		db.rs.next();
		cid = db.rs.getInt("cid");
		refresh(db);
	}

	/**
	 * Update the content.  Also update the timestamp of any pages containing this content.
	 */
	protected void update(DB db) throws SQLException {
		String query = "UPDATE content SET " +
			"updated="+db.now()+", " +
			"label="+charsOrDefault(label)+", " +
			"modulecontext="+charsOrNull(modulecontext)+", " +
			"moduleurl="+charsOrNull(moduleurl)+", " +
			"moduleabove="+db.bool(moduleabove)+", " +
			"copy="+charsOrNull(copy)+" " +
			"WHERE cid="+cid;
		db.executeUpdate(query);
		refresh(db);
		if (db.isBS()) {
			db.executeUpdate("UPDATE bspages SET updated="+db.now()+" WHERE pid IN (SELECT pid FROM bspages_content WHERE cid="+cid+")");
		} else {
			db.executeUpdate("UPDATE bspages SET updated="+db.now()+" WHERE pid IN (SELECT pid FROM bspages_content WHERE cid="+cid+")");
		}
	}

	/**
	 * Delete the current record, and reset to defaults.  Will throw foreign key exception!
	 */
	protected void delete(DB db) throws SQLException, ValidationException {
		db.executeUpdate("DELETE FROM comments WHERE cid="+cid); // ok to delete comments
		db.executeUpdate("DELETE FROM content WHERE cid="+cid);
		setDefaults();
	}

	/**
	 * Set default values when instance does not correspond to a database record (such as after delete() is called
	 */
	protected void setDefaults() {
		cid = 0;
		label = null;
		modulecontext = null;
		moduleurl = null;
		moduleabove = false;
		copy = null;
	}

	/**
	 * Return true if is the default record (cid==0).  Convenience to mask definition of default.
	 */
	public boolean isDefault() {
		return (cid==0);
	}

	/**
	 * Insert an audit record for the given action; also inserts audit records for pages which contain this content item
	 */
	protected void audit(DB db, char action, String username) throws SQLException {
		Audit a = new Audit();
		a.tablename = tablename;
		a.record_id = cid;
		a.action = action;
		a.username = username;
		a.description = "";
		if (label!=null) a.description = label;
		a.insert(db);
	}

	/**
	 * Comparator for sorting on label.
	 */
	public int compareTo(Object o) {
		Content that = (Content) o;
		return this.label.compareTo(that.label);
	}

	/**
	 * Return true if same primary key
	 */
	public boolean equals(Object o) {
		Content that = (Content) o;
		return this.cid==that.cid;
	}

	/**
	 * Return the primary key (added for jcms-bootstrap style compatibility)
	 */
	public int getKey() {
		return cid;
	}

	/**
	 * Return label (added for jcms-bootstrap style compatibility)
	 */
	public String getLabel() {
		return label;
	}

	/**
	 * Return all content records meta data in a Content array; copy is omitted to reduce memory load.
	 */
	public static Content[] getAllMetadata(ServletContext context) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context);
			db.executeQuery("SELECT count(*) AS count FROM content");
			db.rs.next();
			int count = db.rs.getInt("count");
			Content[] all = new Content[count];
			int i = 0;
			db.executeQuery("SELECT cid,label,modulecontext,moduleurl,moduleabove,created,updated FROM content ORDER BY lower(label)");
			while (db.rs.next()) {
				all[i] = new Content();
				all[i].cid = db.rs.getInt("cid");
				all[i].label = db.rs.getString("label");
				all[i].modulecontext = db.rs.getString("modulecontext");
				all[i].moduleurl = db.rs.getString("moduleurl");
				all[i].moduleabove = db.rs.getBoolean("moduleabove");
				all[i].created = db.rs.getTimestamp("created");
				all[i].updated = db.rs.getTimestamp("updated");
				i++;
			}
			return all;
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Return content records metadata in an array which match a search term.  Copy is omitted to reduce memory load.
	 */
	public static Content[] getMatchingMetadata(ServletContext context, String s) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context);
			String query = "SELECT content.* FROM content WHERE copy "+db.iLike()+" '%"+s+"%' OR label "+db.iLike()+" '%"+s+"%' ";
			// append cid search if s is int
			try {
				int cid = Integer.parseInt(s);
				query += "OR cid="+cid;
			} catch (Exception ex) {
				// not an int
			}
			query += "ORDER BY lower(label),cid";
			db.executeQuery(query);
			// load into a vector so we can count
			Vector<Content> v = new Vector<Content>();
			while (db.rs.next()) v.add(new Content(db.rs));
			// covert vector to array, cast to Content
			Object[] vo = v.toArray();
			Content[] content = new Content[v.size()];
			for (int i=0; i<content.length; i++) content[i] = (Content)vo[i];
			return content;
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Return all content metadata that may be edited by the supplied user. SLOW!
	 */
	static Content[] getAllMetadata(ServletContext context, ControlPanelUser user) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
		// start with all content
		Content[] all = getAllMetadata(context);
		// now whittle it down
		DB db = null;
		try {
			db = new DB(context);
			// place content in a LinkedHashSet (to maintain order)
			LinkedHashSet<Content> contentSet = new LinkedHashSet<Content>();
			for (int i=0; i<all.length; i++) {
				if (all[i].isOrphan(db)) {
					// add in orphaned content
					contentSet.add(all[i]);
				} else {
					Page[] pages = all[i].getPages(db);
					// add in content on orphaned pages
					for (int j=0; j<pages.length; j++) {
						if (pages[j].isOrphan(db)) {
							contentSet.add(all[i]);
						} else {
							// add if user has edit permission on page
							if (user.hasPermission(db,pages[j])) contentSet.add(all[i]);
						}
					}
				}
			}
			// convert contentSet to array and return
			int num = contentSet.size();
			Content[] permitted = new Content[num];
			int i = 0;
			for (Iterator e=contentSet.iterator(); e.hasNext(); ) {
				permitted[i++] = (Content)e.next();
			}
			return permitted;
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Return all content records that may be edited by the user logged into the supplied session.  SLOW!
	 */
	public static Content[] getAllMetadata(HttpSession session) throws UserNotFoundException, SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
		ControlPanelUser user = new ControlPanelUser(session);
		ServletContext context = session.getServletContext();
		return getAllMetadata(context, user);
	}

	/**
	 * Return true if this content is not associated with a page.
	 */
	boolean isOrphan(DB db) throws SQLException {
		if (db.isBS()) {
			db.executeQuery("SELECT count(*) AS count FROM bspages_content WHERE cid="+cid);
			db.rs.next();
			return (db.rs.getInt("count")==0);
		} else {
			db.executeQuery("SELECT count(*) AS count FROM pages_content WHERE cid="+cid);
			db.rs.next();
			return (db.rs.getInt("count")==0);
		}
	}

	/**
	 * Return true if this content is not associated with a page.
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
	 * Return an array of BSPages that contain this content, regardless of pane.
	 */
	BSPage[] getBSPages(DB db) throws SQLException {
		TreeSet<BSPage> set = new TreeSet<BSPage>();
		db.executeQuery("SELECT DISTINCT bspages.* FROM bspages,bspages_content WHERE bspages.pid=bspages_content.pid AND cid="+cid);
		while (db.rs.next()) set.add(new BSPage(db.rs));
		return set.toArray(new BSPage[0]);
	}
	/**
	 * Return an array of Pages that contain this content, regardless of pane.
	 */
	public BSPage[] getBSPages(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context);
			return getBSPages(db);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Return an array of Pages that contain this content, regardless of pane.
	 */
	Page[] getPages(DB db) throws SQLException {
		TreeSet<Page> set = new TreeSet<Page>();
		db.executeQuery("SELECT DISTINCT pages.* FROM pages,pages_content WHERE pages.pid=pages_content.pid AND cid="+cid);
		while (db.rs.next()) set.add(new Page(db.rs));
		return set.toArray(new Page[0]);
	}
	/**
	 * Return an array of Pages that contain this content, regardless of pane.
	 */
	public Page[] getPages(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context);
			return getPages(db);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Clone a new content item from this content item.
	 */
	Content clone(DB db) throws SQLException {
		Content c = new Content();
		c.copy = copy;
		c.label = label+" *CLONE*";
		c.modulecontext = modulecontext;
		c.moduleurl = moduleurl;
		c.moduleabove = moduleabove;
		c.insert(db);
		return c;
	}

	/**
	 * Clone a new content item from this content item.
	 */
	public Content clone(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context);
			return clone(db);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Delete orphaned content records, those that have no corresonding record in pages_content.  Return the number deleted.
	 */
	public static int purgeOrphans(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context);
			db.executeQuery("SELECT count(*) AS count FROM content");
			db.rs.next();
			int before = db.rs.getInt("count");
			db.executeUpdate("DELETE FROM comments WHERE cid NOT IN (SELECT cid FROM pages_content)");
			db.executeUpdate("DELETE FROM content WHERE cid NOT IN (SELECT cid FROM pages_content)");
			db.executeQuery("SELECT count(*) AS count FROM content");
			db.rs.next();
			int after = db.rs.getInt("count");
			return (before - after);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Return the number of orphaned content records.
	 */
	public static int getOrphanCount(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context);
			db.executeQuery("SELECT count(*) AS count FROM content WHERE cid NOT IN (SELECT cid FROM pages_content)");
			db.rs.next();
			return db.rs.getInt("count");
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Return an array of the orphaned content
	 */
	public static Content[] getOrphanedContent(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context);
			db.executeQuery("SELECT count(*) AS count FROM content WHERE cid NOT IN (SELECT cid FROM pages_content)");
			db.rs.next();
			int count = db.rs.getInt("count");
			Content[] content = new Content[count];
			db.executeQuery("SELECT * FROM content WHERE cid NOT IN (SELECT cid FROM pages_content) ORDER BY lower(label)");
			int i = 0;
			while (db.rs.next()) content[i++] = new Content(db.rs);
			return content;
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Return updated if not null, else created
	 */
	public Timestamp lastModified() {
		if (updated==null) {
			return created;
		} else {
			return updated;
		}
	}

}
