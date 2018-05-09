package net.ims.jcms;

import net.ims.jcms.bootstrap.*;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Enumeration;
import java.util.Vector;
import javax.naming.NamingException;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/**
 * This class contains the methods for retrieving control panel user permissions on nodes, extras, extensions and, by inference, on pages, content and media,
 * as well as the role assignments (editor, designer, admin) for each user.
 *
 * Note: a user is referenced by username, provided by getUsername() in the class which implements User.  It must be unique in the underlying data store, 
 * and is used to identify users in the users_nodes, users_extras and users_extensions tables.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class ControlPanelUser {

	/** User.getUsername() */
	public String username;
	/** cproles.editor */
	public boolean editor = false;
	/** cproles.designer */
	public boolean designer = false;
	/** cproles.admin */
	public boolean admin = false;

	/**
	 * Construct from the username stored in the HttpSession
	 */
	public ControlPanelUser(HttpSession session) throws UserNotFoundException, SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
		if (session.getAttribute("cpusername")!=null) {
			this.username = (String)(session.getAttribute("cpusername"));
			select(session.getServletContext());
		} else {
			throw new UserNotFoundException("No control panel user associated with current session.");
		}
	}

	/**
	 * Construct given a User.
	 */
	public ControlPanelUser(ServletContext context, User user) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
		// set username
		this.username = user.getUsername();
		// set role assignments
		select(context);
	}

	/**
	 * Select this user's role assignments.
	 */
	void select(ServletContext context) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context);
			db.executeQuery("SELECT * FROM cproles WHERE username='"+username+"'");
			if (db.rs.next()) {
				editor = db.rs.getBoolean("editor");
				designer = db.rs.getBoolean("designer");
				admin = db.rs.getBoolean("admin");
			}
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Update this user's role assignments.
	 */
	public void update(HttpServletRequest request) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException, IOException, UserNotFoundException, ValidationException {
		HttpSession session = request.getSession();
		ServletContext context = session.getServletContext();
		DB db = null;
		try {
			db = new DB(context);
			db.executeUpdate("DELETE FROM cproles WHERE username='"+username+"'");
			db.executeUpdate("INSERT INTO cproles (username,editor,designer,admin) VALUES ('"+username+"',"+db.bool(editor)+","+db.bool(designer)+","+db.bool(admin)+")");
		} finally {
			if (db!=null) db.close();
		}
		String comment = "roles updated to [";
		if (editor) comment += "E";
		if (designer) comment += "D";
		if (admin) comment += "A";
		comment += "]";
		audit(session, 'U', "cproles", 0, comment);
	}

	/**
	 * Inserts an audit record for the given action
	 */
	void audit(HttpSession session, char action, String tablename, int record_id, String comment) throws SQLException, NamingException, ClassNotFoundException, FileNotFoundException, IOException, UserNotFoundException, ValidationException {
		Audit a = new Audit();
		a.action = action;
		a.tablename = tablename;
		a.record_id = record_id;
		ControlPanelUser cpu = new ControlPanelUser(session);
		a.username = cpu.username;
		a.description = username;
		if (comment!=null) a.description += " "+comment;
		ServletContext context = session.getServletContext();
		a.insert(context);
	}

	/**
	 * Return a Vector of Nodes on which this user has Edit permission.
	 */
	Vector getNodes(DB db) throws SQLException {
		Vector<Integer> nids = new Vector<Integer>();
		db.executeQuery("SELECT nid FROM users_nodes WHERE username='"+username+"' ORDER BY nid");
		while (db.rs.next()) nids.add(new Integer(db.rs.getInt("nid")));
		Vector<Node> nodes = new Vector<Node>();
		Enumeration e = nids.elements();
		while (e.hasMoreElements()) {
			int nid = ((Integer)e.nextElement()).intValue();
			nodes.add(new Node(db, nid));
		}
		return nodes;
	}

	/**
	 * Return a Vector of Nodes on which this user has Edit permission.
	 */
	public Vector getNodes(ServletContext context) throws SQLException, NamingException, ClassNotFoundException, FileNotFoundException, IOException, UserNotFoundException, ValidationException {
		DB db = null;
		try {
			db = new DB(context);
			return getNodes(db);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Grant this user permission on the given node.
	 */
	void addNode(DB db, Node n) throws SQLException {
		db.executeUpdate("INSERT INTO users_nodes (username,nid) VALUES ('"+username+"',"+n.nid+")");
	}

	/**
	 * Grant this user permission on the given node.
	 */
	public void addNode(HttpSession session, Node n) throws SQLException, NamingException, ClassNotFoundException, FileNotFoundException, IOException, UserNotFoundException, ValidationException {
		DB db = null;
		try {
			ServletContext context = session.getServletContext();
			db = new DB(context);
			addNode(db, n);
			String comment = "node "+n.label+" ("+n.nid+") added";
			audit(session, 'U', "users_nodes", n.nid, comment);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Remove this user's permission from the given node.
	 */
	void removeNode(DB db, Node n) throws SQLException {
		db.executeUpdate("DELETE FROM users_nodes WHERE username='"+username+"' AND nid="+n.nid);
	}

	/**
	 * Remove this user's permission from the given node.
	 */
	public void removeNode(HttpSession session, Node n) throws SQLException, NamingException, ClassNotFoundException, FileNotFoundException, IOException, UserNotFoundException, ValidationException {
		DB db = null;
		try {
			ServletContext context = session.getServletContext();
			db = new DB(context);
			removeNode(db, n);
			String comment = "node "+n.label+" ("+n.nid+") removed";
			audit(session, 'U', "users_nodes", n.nid, comment);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Return true if user has permission on the given node.  Recursive.
	 */
	boolean hasPermission(DB db, Node n) throws SQLException {
		if (n==null) {
			return false;
		} else {
			db.executeQuery("SELECT count(*) AS count FROM users_nodes WHERE username='"+username+"' AND nid="+n.nid);
			db.rs.next();
			int count = db.rs.getInt("count");
			if (count==1) {
				return true;
			} else if (n.nid==0) {
				return false;
			} else {
				Node p = n.getParent(db);
				return hasPermission(db, p);
			}
		}
	}
	/**
	 * Return true if user has permission on the given Node.
	 */
	public boolean hasPermission(ServletContext context, Node n) throws SQLException, NamingException, ClassNotFoundException, FileNotFoundException, IOException, UserNotFoundException, ValidationException {
		DB db = null;
		try {
			db = new DB(context);
			return hasPermission(db, n);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Return true if user has edit permission on EVERY node that schedules the given Page.
	 */
	boolean hasPermission(DB db, Page p) throws SQLException {
		if (p.isOrphan(db)) return true;
		Node[] nodes = p.getNodes(db);
		for (int i=0; i<nodes.length; i++) if (!hasPermission(db, nodes[i])) return false;
		return true;
	}
	/**
	 * Return true if user has edit permission on EVERY node that schedules the given Page.
	 */
	public boolean hasPermission(ServletContext context, Page p) throws SQLException, NamingException, ClassNotFoundException, FileNotFoundException, IOException, UserNotFoundException, ValidationException {
		DB db = null;
		try {
			db = new DB(context);
			return hasPermission(db, p);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Return true if user has edit permission on EVERY node that schedules the given BSPage.
	 */
	boolean hasPermission(DB db, BSPage p) throws SQLException {
		if (p.isOrphan(db)) return true;
		Node[] nodes = p.getNodes(db);
		for (int i=0; i<nodes.length; i++) if (!hasPermission(db, nodes[i])) return false;
		return true;
	}
	/**
	 * Return true if user has edit permission on EVERY node that schedules the given BSPage.
	 */
	public boolean hasPermission(ServletContext context, BSPage p) throws SQLException, NamingException, ClassNotFoundException, FileNotFoundException, IOException, UserNotFoundException, ValidationException {
		DB db = null;
		try {
			db = new DB(context);
			return hasPermission(db, p);
		} finally {
			if (db!=null) db.close();
		}
	}


	/**
	 * Return true if user has edit permission on EVERY node that schedules the given Media.
	 */
	boolean hasPermission(DB db, Media m) throws SQLException {
		if (m.isOrphan(db)) return true;
		Node[] nodes = m.getNodes(db);
		boolean permission = true;
		for (int i=0; i<nodes.length; i++) if (!hasPermission(db, nodes[i])) return false;
		return true;
	}
	/**
	 * Return true if user has edit permission on EVERY node that schedules the given Media.
	 */
	public boolean hasPermission(ServletContext context, Media m) throws SQLException, NamingException, ClassNotFoundException, FileNotFoundException, IOException, UserNotFoundException, ValidationException {
		DB db = null;
		try {
			db = new DB(context);
			return hasPermission(db, m);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Return true if user has edit permission on the given Extension.
	 */
	boolean hasPermission(DB db, Extension e) throws SQLException {
		db.executeQuery("SELECT count(*) AS count FROM users_extensions WHERE username='"+username+"' AND extid="+e.extid);
		db.rs.next();
		return (db.rs.getInt("count")>0);
	}
	/**
	 * Return true if user has edit permission on the given Extension.
	 */
	public boolean hasPermission(ServletContext context, Extension e) throws SQLException, NamingException, ClassNotFoundException, FileNotFoundException, IOException, UserNotFoundException, ValidationException {
		DB db = null;
		try {
			db = new DB(context);
			return hasPermission(db, e);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Return true if user has edit permission on the given Extra.
	 */
	boolean hasPermission(DB db, Extra e) throws SQLException {
		db.executeQuery("SELECT count(*) AS count FROM users_extras WHERE username='"+username+"' AND extra_id="+e.extra_id);
		db.rs.next();
		return (db.rs.getInt("count")>0);
	}
	/**
	 * Return true if user has edit permission on the given Extra.
	 */
	public boolean hasPermission(ServletContext context, Extra e) throws SQLException, NamingException, ClassNotFoundException, FileNotFoundException, IOException, UserNotFoundException, ValidationException {
		DB db = null;
		try {
			db = new DB(context);
			return hasPermission(db, e);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Return true if user has permission to edit the given content: it's orphaned, or the user may edit EVERY page that it is on
	 */
	boolean hasPermission(DB db, Content c) throws SQLException {
		if (c.isDefault()) return false;
		if (c.isOrphan(db)) return true;
		if (db.isBS()) {
			BSPage[] pages = c.getBSPages(db);
			for (int i=0; i<pages.length; i++) if (!hasPermission(db, pages[i])) return false;
			return true;
		} else {
			Page[] pages = c.getPages(db);
			for (int i=0; i<pages.length; i++) if (!hasPermission(db, pages[i])) return false;
			return true;
		}
	}
	/**
	 * Return true if user has permission to edit the given content: it's orphaned, or the user may edit EVERY page that it is on
	 */
	public boolean hasPermission(ServletContext context, Content c) throws SQLException, NamingException, ClassNotFoundException, FileNotFoundException, IOException, UserNotFoundException, ValidationException {
		DB db = null;
		try {
			db = new DB(context);
			return hasPermission(db, c);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Return a Vector of Extensions to which this user is assigned.
	 */
	Vector getExtensions(DB db) throws SQLException {
		Vector<Integer> extids = new Vector<Integer>();
		db.executeQuery("SELECT extid FROM users_extensions WHERE username='"+username+"' ORDER BY extid");
		while (db.rs.next()) extids.add(new Integer(db.rs.getInt("extid")));
		Vector<Extension> extensions = new Vector<Extension>();
		Enumeration e = extids.elements();
		while (e.hasMoreElements()) {
			int extid = ((Integer)e.nextElement()).intValue();
			extensions.add(new Extension(db, extid));
		}
		return extensions;
	}

	/**
	 * Return a Vector of Extensions to which this user is assigned.
	 */
	public Vector getExtensions(ServletContext context) throws SQLException, NamingException, ClassNotFoundException, FileNotFoundException, IOException, UserNotFoundException, ValidationException {
		DB db = null;
		try {
			db = new DB(context);
			return getExtensions(db);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Grant this user permission on the given extension.
	 */
	void addExtension(DB db, Extension e) throws SQLException {
		db.executeUpdate("INSERT INTO users_extensions (username,extid) VALUES ('"+username+"',"+e.extid+")");
	}

	/**
	 * Grant this user permission on the given extension.
	 */
	public void addExtension(HttpSession session, Extension e) throws SQLException, NamingException, ClassNotFoundException, FileNotFoundException, IOException, UserNotFoundException, ValidationException {
		DB db = null;
		try {
			ServletContext context = session.getServletContext();
			db = new DB(context);
			addExtension(db, e);
			String comment = "granted permission on extension "+e.name;
			audit(session, 'U', "users_extensions", e.extid, comment);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Remove this user's permission from the given extension, and any child extensions.
	 */
	void removeExtension(DB db, Extension e) throws SQLException {
		// children
		db.executeUpdate("DELETE FROM users_extensions WHERE username='"+username+"' AND extid IN (SELECT extid FROM extensions WHERE parent_extid="+e.extid+")");
		// parent
		db.executeUpdate("DELETE FROM users_extensions WHERE username='"+username+"' AND extid="+e.extid);
	}

	/**
	 * Remove this user's permission on the given extension.
	 */
	public void removeExtension(HttpSession session, Extension e) throws SQLException, NamingException, ClassNotFoundException, FileNotFoundException, IOException, UserNotFoundException, ValidationException {
		DB db = null;
		try {
			ServletContext context = session.getServletContext();
			db = new DB(context);
			removeExtension(db, e);
			String comment = "revoked permission on extension "+e.name;
			audit(session, 'U', "users_extensions", e.extid, comment);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Grant this user permission on the given extra.
	 */
	void addExtra(DB db, Extra e) throws SQLException {
		db.executeUpdate("INSERT INTO users_extras (username,extra_id) VALUES ('"+username+"',"+e.extra_id+")");
	}

	/**
	 * Grant this user permission on the given extra.
	 */
	public void addExtra(HttpSession session, Extra e) throws SQLException, NamingException, ClassNotFoundException, FileNotFoundException, IOException, UserNotFoundException, ValidationException {
		DB db = null;
		try {
			ServletContext context = session.getServletContext();
			db = new DB(context);
			addExtra(db, e);
			String comment = "granted permission on extra "+e.name;
			audit(session, 'U', "users_extras", e.extra_id, comment);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Remove this user's permission on the given extra, and any child extras.
	 */
	void removeExtra(DB db, Extra e) throws SQLException {
		// children
		db.executeUpdate("DELETE FROM users_extras WHERE username='"+username+"' AND extra_id IN (SELECT extra_id FROM extras WHERE parent_extra_id="+e.extra_id+")");
		// parent
		db.executeUpdate("DELETE FROM users_extras WHERE username='"+username+"' AND extra_id="+e.extra_id);
	}

	/**
	 * Remove this user's permission on the given extra.
	 */
	public void removeExtra(HttpSession session, Extra e) throws SQLException, NamingException, ClassNotFoundException, FileNotFoundException, IOException, UserNotFoundException, ValidationException {
		DB db = null;
		try {
			ServletContext context = session.getServletContext();
			db = new DB(context);
			removeExtra(db, e);
			String comment = "revoked permission on extra "+e.name;
			audit(session, 'U', "users_extras", e.extra_id, comment);
		} finally {
			if (db!=null) db.close();
		}
	}

}
