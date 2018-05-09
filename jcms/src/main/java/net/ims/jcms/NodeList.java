package net.ims.jcms;

import java.sql.SQLException;
import java.io.FileNotFoundException;
import java.util.LinkedList;
import javax.naming.NamingException;
import javax.servlet.ServletContext;


/**
 * A LinkedList implementation which contains a list of node locations under the given node, which may be empty.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class NodeList extends LinkedList<Node> {

	// this class is serializable, therefore need this, but it's arbitrary
	private static final long serialVersionUID = 01L;

	/** the parent node of this list */
	public Node parent;

	/** the count of nodes in this list */
	public int count;

	/**
	 * Construct with the provided DB object and parent Node.
	 * NOTE: this constructor is used heavily, so explicit queries are used here to create the Nodes,
	 * rather than calls to the Node constructor.
	 * 
	 * IF THE Node CLASS IS UPDATED, THIS MUST BE UPDATED AS WELL!
	 */
	NodeList(DB db, Node parent) throws SQLException {
		this.parent = parent;
		populate(db);
	}

	/**
	 * Construct with the provided ServletContext and parent node.
	 */
	public NodeList(ServletContext context, Node parent) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
		this.parent = parent;
		DB db = null;
		try {
			db = new DB(context);
			populate(db);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Populate this instance given a DB object.
	 */
	void populate(DB db) throws SQLException {
		// get all child nodes
		db.executeQuery("SELECT * FROM nodes WHERE parent_nid="+parent.nid+" ORDER BY num,nid"); // query 1
		while (db.rs.next()) {
			Node n = new Node(db.rs);
			// label has to be cooked
			if (parent.nid==0) {
				n.label = ""+n.num;
			} else {
				n.label = parent.label+"."+n.num;
			}
			// add to the NodeList
			add(n);
		}
		// We're not done yet - have to determine active status and URL
		NodeListIterator li = getNodeListIterator();
		while (li.hasNext()) {
			Node n = li.nextNode();
			NodeLink nl = n.getCurrentNodeLink(db); // query 2
			// get active status and url
			if (nl==null || nl.isEmpty()) {
				n.active = false;
			} else {
				n.url = nl.getUrl(db); // query 3
				if (nl.isRedirect()) {
					NodeLink rnl = new NodeLink(db, nl.redirectnid, true); // query 4
					if (rnl==null || rnl.isEmpty()) {
						n.active = false;
					} else {
						n.active = parent.active;
					}
				} else {
					n.active = parent.active;
				}
			}
		}
	}

	/**
	 * Return a NodeListIterator for iterating through the nodes of this list
	 */
	public NodeListIterator getNodeListIterator() {
		return new NodeListIterator(listIterator());
	}
  
}
