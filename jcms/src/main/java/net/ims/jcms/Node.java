package net.ims.jcms;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;
import javax.naming.NamingException;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpSession;

/**
 * Extends Record to encapsulate a single node in the navigation heirarchy from the nodes table.
 *
 * NOTE: Be sure to update NodeLink with any new instance parameters; NodeLink instantiates a Node with its own query.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class Node extends Record {

	/** the name of the database table, used by audit method */
	static String tablename = "nodes";

	/** nodes.nid: the primary key for this nodes record */
	public int nid;

	/** nodes.parent_nid: the key of the parent of this node, or 0 if null */
	public int parent_nid;

	/** nodes.num: a sorting number, which can be any integer */
	public int num;

	/** nodes.nodename: the name of this node */
	public String nodename;

	/** nodes.alias: alternative name for node, for easy-to-remember URLs and such */
	public String alias;

	/** nodes.hidden: flag to force a node to be hidden from navigation; node can be hidden for other reasons */
	public boolean hidden;

	/** nodes.ssl: flag to indicate page should be served via SSL on SSL host */
	public boolean ssl;

	/** nodes.created: creation timestamp */
	public Timestamp created;

	/** nodes.updated: update timestamp */
	public Timestamp updated;

	/** user-friendly label which identifies this node in the heirarchy */
	public String label;

	/** cache current URL of this node, null if inactive */
	public String url;

	/** flag to indicate whether this node is currently active */
	public boolean active;

	/**
	 * Constructs simply setting instance variables to defaults
	 */
	public Node() {
		setDefaults();
	}

	/**
	 * Construct from a populated ResultSet.  ONLY DB VARS ARE POPULATED.
	 */
	public Node(ResultSet rs) throws SQLException {
		populate(rs);
	}
  
	/**
	 * Constructs given DB connection and an int primary key.
	 */
	public Node(DB db, int key) throws SQLException {
		select(db, key);
	}

	/**
	 * Constructs given ServletContext to get DB connection and an int primary key
	 */
	public Node(ServletContext context, int key) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context);
			select(db, key);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Constructs given a parent_nid and a num value to match.
	 */
	public Node(ServletContext context, int parentNidIn, int numIn) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context);
			select(db, parentNidIn, numIn);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Constructs given an alias (URI) to match.
	 */
	public Node(ServletContext context, String uri) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context);
			select(db, uri);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Do a SELECT query and set instance variables given a DB connection and a primary key.
	 * Used only by constructor here, do not use publicly.
	 */
	protected void select(DB db, int key) throws SQLException {
		db.executeQuery("SELECT * FROM nodes WHERE nid="+key);
		if (db.rs.next()) {
			populate(db.rs);
			updateLabel(db);
			active = isActive(db);
			url = getUrl(db);
		} else {
			setDefaults();
		}
	}
  
	/**
	 * Select the node that matches the given alias (URI).  Resets to defaults if alias not found.
	 */
	void select(DB db, String uri) throws SQLException {
		db.executeQuery("SELECT * FROM nodes WHERE alias='"+uri+"'");
		if (db.rs.next()) {
			int key = db.rs.getInt("nid");
			select(db, key);
		} else {
			setDefaults();
		}
	}

	/**
	 * Select the node that matches the given parent_nid and num value.  Node with lowest nid is set in case of more than one with given num value.
	 */
	void select(DB db, int parentNidIn, int numIn) throws SQLException {
		db.executeQuery("SELECT * FROM nodes WHERE parent_nid="+parentNidIn+" AND num="+numIn+" ORDER BY nid");
		if (db.rs.next()) {
			int key = db.rs.getInt("nid");
			select(db, key);
		} else {
			setDefaults();
		}
	}

	/**
	 * Populate the instance with values from a ResultSet.  label, active and url have to be set elsewhere.
	 */
	protected void populate(ResultSet rs) throws SQLException {
		nid = rs.getInt("nid");
		created = rs.getTimestamp("created");
		num = rs.getInt("num");
		nodename = rs.getString("nodename");
		parent_nid = rs.getInt("parent_nid");
		hidden = rs.getBoolean("hidden");
		ssl = rs.getBoolean("ssl");
		alias = rs.getString("alias");
	}

	/**
	 * Refresh this instance with values from the database record
	 */
	protected void refresh(DB db) throws SQLException {
		select(db, nid);
	}

	/**
	 * Validate an insert or update
	 */
	void validate() throws ValidationException {
		// drop leading alias slash if provided; replace spaces with dash
		if (alias!=null) {
			alias = alias.trim();
			if (alias.length()>0 && alias.charAt(0)=='/') alias = alias.substring(1);
			alias = alias.trim();
			alias = alias.replace(' ','-');
			if (alias.length()==0) alias = null;
		}
		// validation
		if (alias!=null) {
			for (int i=0; i<alias.length(); i++) {
				char c = alias.charAt(i);
				if (c!='-' && c!='/' && !Character.isLetterOrDigit(c)) throw new ValidationException("Aliases may consist only of letters, numbers, - and /.");
			}
		}
	}

	/**
	 * Updates database record with current field values, except parent_nid is left alone
	 */
	protected void update(DB db) throws ValidationException, SQLException {
		validate();
		String query = "UPDATE nodes SET "+
			"updated="+db.now()+", " +
			"num="+num+", " +
			"nodename="+charsOrNull(nodename)+", " +
			"alias="+charsOrNull(alias)+", " +
			"hidden="+db.bool(hidden)+", " +
			"ssl="+db.bool(ssl)+" " +
			"WHERE nid="+nid;
		db.executeUpdate(query);
		// refresh
		refresh(db);
		// renumber all siblings
		renumberSiblings(db);
	}

	/**
	 * Inserts a new node record into the database and retrieve/set nid.
	 */
	protected void insert(DB db) throws ValidationException, SQLException {
		validate();
		String query = "INSERT INTO nodes (" +
			"parent_nid, num, hidden, ssl, alias, nodename" +
			") VALUES (" +
			parent_nid+"," +
			intOrDefault(num)+"," +
			db.bool(hidden)+"," +
			db.bool(ssl)+"," +
			charsOrDefault(alias)+"," +
			charsOrDefault(nodename) +
			")";
		db.executeUpdate(query);
		// refresh
		db.executeQuery("SELECT max(nid) AS nid FROM nodes");
		db.rs.next();
		nid = db.rs.getInt("nid");
		refresh(db);
		// renumber all siblings
		renumberSiblings(db);
	}

	/**
	 * Deletes this node record, if it has no children.
	 */
	protected void delete(DB db) throws SQLException, ValidationException {
		if (nid==0) {
			throw new ValidationException("ERROR: you have attempted to delete a nonexistent node, or the root node.");
		} else if (hasChildren(db)) {
			throw new ValidationException("ERROR: you may not delete a node that has children.");
		} else {
			// delete relations
			db.executeUpdate("DELETE FROM accessroles_nodes WHERE nid="+nid);
			db.executeUpdate("DELETE FROM users_nodes WHERE nid="+nid);
			db.executeUpdate("DELETE FROM nodelinks WHERE nid="+nid);
			db.executeUpdate("DELETE FROM nodelinks WHERE redirectnid="+nid);
			// delete node
			db.executeUpdate("DELETE FROM nodes WHERE nid="+nid);
			// renumber siblings
			renumberSiblings(db);
			// clear this node
			setDefaults();
		}
	}

	/**
	 * Sets default values. Called typically after the database record has been deleted.
	 */
	protected void setDefaults() {
		nid = 0;
		parent_nid = 0;
		num = 0;
		nodename = null;
		alias = null;
		label = null;
		hidden = false;
		ssl = false;
		active = false;
		url = null;
	}

	/**
	 * Inserts an audit record for the given action
	 */
	protected void audit(DB db, char action, String username) throws SQLException {
		Audit a = new Audit();
		a.tablename = tablename;
		a.record_id = nid;
		a.action = action;
		a.username = username;
		a.description = "";
		if (label!=null) a.description = label;
		if (nodename!=null) a.description += " "+nodename;
		a.insert(db);
	}

	/**
	 * Required by the Comparable interface, returns a node comparison based on depth and num.
	 * REQUIRES that both node labels be set!
	 */ 
	public int compareTo(Object o) {
		if (o==null) return 1;
		Node that = (Node) o;
		if (this.parent_nid==that.parent_nid) {
			return (this.num - that.num);
		} else {
			if (this.label==null || that.label==null) return 0;
			String[] thisNums = this.label.split("\\.");
			String[] thatNums = that.label.split("\\.");
			for (int i=0; (i<thisNums.length && i<thatNums.length); i++) {
				int thisNum = Integer.parseInt(thisNums[i]);
				int thatNum = Integer.parseInt(thatNums[i]);
				if (thisNum!=thatNum) return (thisNum - thatNum); // this isn't working!!
			}
			return (thisNums.length - thatNums.length); // always hits this!
		}
	}

	/**
	 * Return true if both nodes have the same nid.
	 */
	public boolean equals(Node that) {
		return (this.nid==that.nid);
	}

	/**
	 * Return true if both nodes have the same nid; overrides Object.equals.
	 */
	public boolean equals(Object o) {
		Node that = (Node) o;
		return this.equals(that);
	}

	/**
	 * Return the primary key.
	 */
	public int getKey() {
		return nid;
	}

	/**
	 * Return the label.
	 */
	public String getLabel() {
		return label;
	}

	/**
	 * Return true if node is active and is not hidden.  Convenience method.
	 */
	public boolean isVisible() {
		return (active && !hidden);
	}

	/**
	 * Renumber the siblings of the current node so there are no gaps
	 */
	void renumberSiblings(DB db) throws ValidationException, SQLException {
		// store nids in an array to avoid needing two DB connections
		db.executeQuery("SELECT count(*) AS count FROM nodes WHERE parent_nid="+parent_nid);
		db.rs.next();
		int count = db.rs.getInt("count");
		int nids[] = new int[count];
		int i = 0;
		db.executeQuery("SELECT nid FROM nodes WHERE parent_nid="+parent_nid+" ORDER BY num");
		while (db.rs.next()) nids[i++] = db.rs.getInt("nid");
		// now renumber them
		for (i=0; i<nids.length; i++) db.executeUpdate("UPDATE nodes SET num="+(i+1)+" WHERE nid="+nids[i]);
		// update this node's label, since it may have changed
		updateLabel(db);
	}


	/**
	 * Increments the num value of this node, followed by reordering
	 */
	void incrementNum(DB db) throws ValidationException, SQLException {
		db.executeUpdate("UPDATE nodes SET num=num-1 WHERE parent_nid="+parent_nid+" AND num="+(num+1));
		num++;
		update(db);
		renumberSiblings(db);
	}

	/**
	 * Increments the num value of this node, making sure to increment the sibling with that num value if needed.
	 * This method is recursive and cascades down the list of siblings.
	 */
	public void incrementNum(ServletContext context) throws ValidationException, SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context);
			incrementNum(db);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Decrements the num value of this node, followed by reordering
	 */
	void decrementNum(DB db) throws SQLException, ValidationException {
		if (num==1) {
			throw new ValidationException("There is no room to decrement the number of the selected node.");
		} else {
			db.executeUpdate("UPDATE nodes SET num=num+1 WHERE parent_nid="+parent_nid+" AND num="+(num-1));
			num--;
			update(db);
			renumberSiblings(db);
		}
	}

	/**
	 * Decrements the num value of this node, making sure to decrement the sibling with that num value if needed.
	 * This method is recursive and cascades up the list of siblings.
	 */
	public void decrementNum(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException, ValidationException {
		DB db = null;
		try {
			db = new DB(context);
			decrementNum(db);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Adds a child node of this node to the database and return it.
	 */
	Node addChild(DB db, int cnum, String cnodename) throws SQLException, ValidationException {
		Node child = new Node();
		child.parent_nid = nid;
		child.num = cnum;
		child.nodename = cnodename;
		child.insert(db);
		return child;
	}

	/**
	 * Adds a child node of this node to the database.
	 */
	public Node addChild(HttpSession session, int cnum, String cnodename) throws ValidationException, SQLException, NamingException, FileNotFoundException, ClassNotFoundException, UserNotFoundException {
		DB db = null;
		try {
			ServletContext context = session.getServletContext();
			db = new DB(context);
			Node child = addChild(db, cnum, cnodename);
			child.audit(session, 'I');
			return child;
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Adds a child node of this node to database using default values.
	 */
	Node addChild(DB db) throws ValidationException, SQLException {
		return addChild(db, 0, null);
	}

	/**
	 * Adds a child node of this node to database using default values.
	 */
	public Node addChild(HttpSession session) throws ValidationException, SQLException, FileNotFoundException, NamingException, ClassNotFoundException, UserNotFoundException {
		DB db = null;
		try {
			ServletContext context = session.getServletContext();
			db = new DB(context);
			Node child = addChild(db);
			child.audit(session, 'I');
			return child;
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Adds a sibling node of this node to the database and return it.
	 */
	Node addSibling(DB db, String snodename) throws ValidationException, SQLException {
		// make room in numbers
		db.executeUpdate("UPDATE nodes SET num=num+1 WHERE parent_nid="+parent_nid+" AND num>"+num);
		// now insert the sibling in next slot
		Node sibling = new Node();
		sibling.parent_nid = parent_nid;
		sibling.num = num + 1;
		sibling.nodename = snodename;
		sibling.insert(db);
		return sibling;
	}

	/**
	 * Adds a sibling node of this node to the database.
	 */
	public Node addSibling(HttpSession session, String snodename) throws ValidationException, SQLException, NamingException, FileNotFoundException, ClassNotFoundException, UserNotFoundException {
		DB db = null;
		try {
			ServletContext context = session.getServletContext();
			db = new DB(context);
			Node sibling = addSibling(db, snodename);
			sibling.audit(session, 'I');
			return sibling;
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Adds a sibling node of this node to database using default values.
	 */
	Node addSibling(DB db) throws ValidationException, SQLException {
		return addSibling(db, null);
	}

	/**
	 * Adds a sibling node of this node to database using default values.
	 */
	public Node addSibling(HttpSession session) throws ValidationException, SQLException, FileNotFoundException, NamingException, ClassNotFoundException, UserNotFoundException {
		DB db = null;
		try {
			ServletContext context = session.getServletContext();
			db = new DB(context);
			Node sibling = addSibling(db);
			sibling.audit(session, 'I');
			return sibling;
		} finally {
			if (db!=null) db.close();
		}
	}


	/**
	 * Return a count of this node's siblings
	 */
	int numSiblings(DB db) throws SQLException {
		db.executeQuery("SELECT count(*) AS count FROM nodes WHERE parent_nid="+parent_nid);
		db.rs.next();
		return db.rs.getInt("count");
	}

	/**
	 * Return a count of this node's siblings.
	 */
	public int numSiblings(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context);
			return numSiblings(db);
		} finally {
			if (db!=null) db.close();
		}
	}


	/**
	 * Return a count of this node's children.
	 */
	int numChildren(DB db) throws SQLException {
		db.executeQuery("SELECT count(*) AS count FROM nodes WHERE parent_nid="+nid);
		db.rs.next();
		return db.rs.getInt("count");
	}

	/**
	 * Return a count of this node's children.
	 */
	public int numChildren(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context);
			return numChildren(db);
		} finally {
			if (db!=null) db.close();
		}
	}


	/**
	 * Return true if this Node has children.
	 */
	boolean hasChildren(DB db) throws SQLException {
		return (numChildren(db)>0);
	}

	/**
	 * Return true if this Node has children.
	 */
	public boolean hasChildren(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context);
			return hasChildren(db);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Return true if this Node has visible children.  Actually, it's children that aren't hidden, to avoid active test.
	 */
	public boolean hasVisibleChildren(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context);
			db.executeQuery("SELECT count(*) AS count FROM nodes WHERE hidden=false AND parent_nid="+nid);
			db.rs.next();
			return (db.rs.getInt("count")>0);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Return this node's parent node or null if this is the top root node.
	 */
	public Node getParent(DB db) throws SQLException {
		if (nid==0) {
			return null;
		} else {
			return new Node(db, parent_nid);
		}
	}

	/**
	 * Return this node's parent node or null if this is the top root node.
	 */
	public Node getParent(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context);
			return getParent(db);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Return true if this node is a descendent (child or deeper) of the parameter
	 * REQUIRES that label be set!
	 */
	boolean isDescendentOf(DB db, Node n) throws SQLException {
		if (getDepth()==0) {
			return false;
		} else if (getDepth()<=n.getDepth()) {
			return false;
		} else if (parent_nid==n.nid) {
			return true;
		} else {
			return getParent(db).isDescendentOf(db, n);
		}
	}

	/** 
	 * Return true if this node is a descendent (child or deeper) of the parameter
	 */
	public boolean isDescendentOf(ServletContext context, Node n) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context);
			return isDescendentOf(db, n);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Return a NodeList of this node's children.
	 */
	NodeList getChildren(DB db) throws SQLException {
		return new NodeList(db, this);
	}

	/** 
	 * Return a NodeList of this node's children.
	 */
	public NodeList getChildren(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context);
			return new NodeList(db, this);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Return true if a link is currently associated with this node or it's a redirect to an active node; and parent is active. RECURSIVE.
	 */
	boolean isActive(DB db) throws SQLException {
		NodeLink nl = getCurrentNodeLink(db);
		if (nl==null || nl.isEmpty()) return false;
		if (nl.isRedirect()) {
			NodeLink rnl = new NodeLink(db, nl.redirectnid, true);
			if (rnl==null || rnl.isEmpty()) return false;
		}
		if (hasParent()) return getParent(db).active;
		return true;
	}
  
	/**
	 * Convenience method: return the NodeLink currently associated with this node; null, if there isn't one.
	 */
	NodeLink getCurrentNodeLink(DB db) throws SQLException {
		return new NodeLink(db, nid, true);
	}

	/**
	 * Convenience method: return the NodeLink currently associated with this node; null, if there isn't one.
	 */
	public NodeLink getCurrentNodeLink(ServletContext context) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context);
			NodeLink nl = new NodeLink(db, nid, true);
			if (nl.nlid==0) {
				return null;
			} else {
				return nl;
			}
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Return an array of NodeLink objects, sorted in increasing start time.
	 */
	NodeLink[] getNodeLinks(DB db) throws SQLException {
		db.executeQuery("SELECT count(*) AS count FROM nodelinks WHERE nid="+nid);
		db.rs.next();
		int count = db.rs.getInt("count");
		if (count==0) {
			return null;
		} else {
			NodeLink[] nodelinks = new NodeLink[count];
			int i = 0;
			db.executeQuery("SELECT * FROM nodelinks WHERE nid="+nid+" ORDER BY starttime");
			while (db.rs.next()) nodelinks[i++] = new NodeLink(db.rs);
			return nodelinks;
		}
	}

	/**
	 * Return an array of NodeLink objects, sorted in increasing start time.
	 */
	public NodeLink[] getNodeLinks(ServletContext context) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context);
			return getNodeLinks(db);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Update this node's label, querying num from DB in case it has changed
	 */
	void updateLabel(DB db) throws SQLException {
		db.executeQuery("SELECT num FROM nodes WHERE nid="+nid);
		if (db.rs.next()) {
			num = db.rs.getInt("num");
			if (parent_nid==0) {
				label = ""+num;
			} else {
				label = getParent(db).label+"."+num;
			}
		}
	}

	/**
	 * Return an integer indicating the depth of this node, starting with 0 for the top root, by parsing the label.
	 * REQUIRES that label be set!
	 */
	public int getDepth() {
		if (nid==0) {
			return 0;
		} else {
			return label.split("\\.").length;
		}
	}

	/**
	 * Return a NodeListIterator over this node's children.
	 */
	NodeListIterator getNodeListIterator(DB db) throws SQLException {
		return getChildren(db).getNodeListIterator();
	}

	/**
	 * Return a NodeListIterator over this node's children.
	 */
	public NodeListIterator getNodeListIterator(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context);
			return getNodeListIterator(db);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Return the current URL of this node, or null if it is inactive.
	 */
	String getUrl(DB db) throws SQLException {
		if (!active) {
			return null;
		} else {
			NodeLink nl = getCurrentNodeLink(db);
			if (nl!=null && !nl.isEmpty()) {
				return nl.getUrl(db);
			} else {
				return null;
			}
		}
	}

	/**
	 * Return true if this node is the default node (nid==0).  Convenience to mask definition of default.
	 */
	public boolean isDefault() {
		return (nid==0);
	}

	/**
	 * Return true if this node has a parent, ie. is not the top node.
	 */
	public boolean hasParent() {
		return (nid!=0);
	}

	/**
	 * Return true if this node is the root node. Opposite of hasParent().
	 */
	public boolean isRoot() {
		return (nid==0);
	}

	/**
	 * Return true if this node is currently linked to an external URL.
	 */
	public boolean isExternal() {
		if (url==null) {
			return false;
		} else {
			return url.startsWith("http");
		}
	}

	/**
	 * Return an array of all nodes, ordered by parent/child/grandchild num (ie. 0, 1, 1.1, 1.1.1, 1.2, etc.)
	 */
	static Node[] getAll(DB db) throws SQLException {
		db.executeQuery("SELECT count(*) AS count FROM nodes");
		db.rs.next();
		int count = db.rs.getInt("count");
		Node[] nodes = new Node[count];
		nodes[0] = new Node(db, 0); // root
		NodeListIterator level1 = nodes[0].getNodeListIterator(db);
		int i = 1;
		while (level1.hasNext()) {
			nodes[i] = level1.nextNode();
			NodeListIterator level2 = nodes[i].getNodeListIterator(db);
			i++;
			while (level2.hasNext()) {
				nodes[i] = level2.nextNode();
				NodeListIterator level3 = nodes[i].getNodeListIterator(db);
				i++;
				while (level3.hasNext()) {
					nodes[i] = level3.nextNode();
					NodeListIterator level4 = nodes[i].getNodeListIterator(db);
					i++;
					while (level4.hasNext()) {
						nodes[i] = level4.nextNode();
						i++;
					}
				}
			}
		}
		return nodes;
	}

	/**
	 * Return an array of all nodes, ordered by parent/child/grandchild num (ie. 0, 1, 1.1, 1.1.1, 1.2, etc.)
	 */
	public static Node[] getAll(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context);
			return getAll(db);
		} finally {
			if (db!=null) db.close();
		}
	}
  
}
