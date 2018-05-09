package net.ims.jcms;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Vector;
import javax.naming.NamingException;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpSession;

/**
 * This abstract class defines the AccessRole methods: retrieving AccessUsers associated with this role, and determining whether a Node or Media instance may be accessed.
 * Since the AccessRole may be stored externally with read-only access, this interface does NOT contain any methods for updating roles or role-user relationships.  Any
 * such methods may be added to the class which extends AccessRole.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public abstract class AccessRole implements Comparable {

  /**
   * Return true if this role is (default) public role.
   */
  public abstract boolean isDefault();

  /**
   * Return true if this Access Role is the same as the provided one.
   */
  public abstract boolean equals(AccessRole role);

  /**
   * Comparison method for sorting roles, required by Comparable interface.
   */
  public abstract int compareTo(Object o);

  /**
   * Factory method to return a default AccessRole instance.  Static method.
   */
  public abstract AccessRole getDefault();

  /**
   * Return an array of all AccessRole instances.  Static method.
   */
  public abstract AccessRole[] getAll(ServletContext context) throws AccessRoleException;

  /**
   * Factory method to return an AccessRole instance given a role name.  Static method.
   * This method is used to instantiate an AccessRole in the app.
   */
  public abstract AccessRole getAccessRole(ServletContext context, String rolename) throws AccessRoleException;

  /**
   * Return the role name associated with this access role.  Role name should be stored as an instance variable in implementing classes,
   * so ServletContext is not needed.
   */
  public abstract String getRolename();

  /**
   * Return the description associated with this access role, or null if not supported.  Should be stored as an instance variable in implementing classes.
   */
  public abstract String getDescription();

  ////////////////////
  // common methods //
  ////////////////////

  /**
   * Insert an audit record for the given action with a comment.
   */
  void audit(HttpSession session, String tablename, char action, String description) throws SQLException, UserNotFoundException, ValidationException, FileNotFoundException, NamingException, ClassNotFoundException, IOException {
    ControlPanelUser user = new ControlPanelUser(session);
    ServletContext context = session.getServletContext();
    Audit a = new Audit();
    a.tablename = tablename;
    a.action = action;
    a.username = user.username;
    a.description = description;
    a.insert(context);
  }

  /**
   * Return a Vector of Nodes on which this role has explicit permission (not inherited permission).  Nodes are in arbitrary order.
   */
  public Vector getNodes(ServletContext context) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      Vector<Node> nodes = new Vector<Node>();
      db.executeQuery("SELECT nodes.* FROM nodes,accessroles_nodes WHERE nodes.nid=accessroles_nodes.nid AND rolename="+charsOrNull(getRolename()));
      while (db.rs.next()) nodes.add(new Node(db.rs));
      return nodes;
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return true if this role may access the given Node.  Recursive, so SLOW.
   */
  boolean mayAccess(DB db, Node n) throws SQLException {
    // bail if NO access control in place
    if (nodeCount(db)==0) return true;
    // check the given node
    db.executeQuery("SELECT count(*) AS count FROM accessroles_nodes WHERE nid="+n.nid);
    db.rs.next();
    boolean accessAssigned = (db.rs.getInt("count")>0);
    if (accessAssigned) {
      if (isDefault()) {
	return false; // node is restricted from public view
      } else {
	db.executeQuery("SELECT count(*) AS count FROM accessroles_nodes WHERE rolename="+charsOrNull(getRolename())+" AND nid="+n.nid);
	db.rs.next();
	return (db.rs.getInt("count")>0); // access only if explicitly assigned
      }
    } else if (n.nid>0) {
      return mayAccess(db, n.getParent(db)); // check parent
    } else {
      return true; // root node, public access
    }
  }

  /**
   * Return true if this role may access the given Node.  Recursive.
   */
  public boolean mayAccess(ServletContext context, Node n) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return mayAccess(db, n);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return a Vector of Media on which this role has explicit permission (not inherited permission).  Media are in arbitrary order.
   */
  public Vector getMedia(ServletContext context) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      Vector<Media> media = new Vector<Media>();
      db.executeQuery("SELECT media.* FROM media,accessroles_media WHERE media.mid=accessroles_media.mid AND rolename="+charsOrNull(getRolename()));
      while (db.rs.next()) media.add(new Media(db.rs));
      return media;
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return true if this role may access the given media.
   */
  boolean mayAccess(DB db, Media m) throws SQLException {
    db.executeQuery("SELECT count(*) AS count FROM accessroles_media WHERE mid="+m.mid);
    db.rs.next();
    if (db.rs.getInt("count")==0) {
      return true; // public access
    } else {
      if (isDefault()) {
	return false; // access restricted from public
      } else {
	db.executeQuery("SELECT count(*) AS count FROM accessroles_media WHERE rolename="+charsOrNull(getRolename())+" AND mid="+m.mid);
	db.rs.next();
	return (db.rs.getInt("count")>0);
      }
    }
  }

  /**
   * Return true if this role may access the given media.
   */
  public boolean mayAccess(ServletContext context, Media m) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      return mayAccess(db, m);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Grant this role explicit access to the given node.  Doesn't write audit record.
   */
  public void grantAccess(ServletContext context, Node n) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      if (isDefault()) {
	db.executeUpdate("DELETE FROM accessroles_nodes WHERE nid="+n.nid);
      } else {
	db.executeUpdate("INSERT INTO accessroles_nodes (rolename,nid) VALUES ("+charsOrNull(getRolename())+","+n.nid+")");
      }
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Grant this role explicit access to the given node.  Write audit record.
   */
  public void grantAccess(HttpSession session, Node n) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException, UserNotFoundException, ValidationException, IOException {
    ServletContext context = session.getServletContext();
    grantAccess(context, n);
    audit(session, "accessroles_nodes", 'U', "AccessRole "+getRolename()+" granted access to Node "+n.label+" ("+n.nid+").");
  }

  /**
   * Revoke this role's access to the given node. Does not write audit record.
   */
  public void revokeAccess(ServletContext context, Node n) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException, UserNotFoundException, ValidationException, IOException {
    DB db = null;
    try {
      db = new DB(context);
      db.executeUpdate("DELETE FROM accessroles_nodes WHERE rolename="+charsOrNull(getRolename())+" AND nid="+n.nid);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Revoke this role's access to the given node.  Write audit record.
   */
  public void revokeAccess(HttpSession session, Node n) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException, UserNotFoundException, ValidationException, IOException {
    ServletContext context = session.getServletContext();
    revokeAccess(context, n);
    audit(session, "accessroles_nodes", 'U', "AccessRole "+getRolename()+" access to Node "+n.label+" ("+n.nid+") revoked.");
  }

  /**
   * Grant this role explicit access to the given media.  Does not write audit record.
   */
  public void grantAccess(ServletContext context, Media m) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException, UserNotFoundException, ValidationException, IOException {
    DB db = null;
    try {
      db = new DB(context);
      if (isDefault()) {
	db.executeUpdate("DELETE FROM accessroles_media WHERE mid="+m.mid);
      } else {
	db.executeUpdate("INSERT INTO accessroles_media (rolename,mid) VALUES ("+charsOrNull(getRolename())+","+m.mid+")");
      }
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Grant this role explicit access to the given media.  Write audit record.
   */
  public void grantAccess(HttpSession session, Media m) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException, UserNotFoundException, ValidationException, IOException {
    ServletContext context = session.getServletContext();
    grantAccess(context, m);
    audit(session, "accessroles_media", 'U', "AccessRole "+getRolename()+" granted access to Media "+m.filename+" ("+m.mid+").");
  }

  /**
   * Revoke this role's access to the given media.  Does not write audit record.
   */
  public void revokeAccess(ServletContext context, Media m) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException, UserNotFoundException, ValidationException, IOException {
    DB db = null;
    try {
      db = new DB(context);
      db.executeUpdate("DELETE FROM accessroles_media WHERE rolename="+charsOrNull(getRolename())+" AND mid="+m.mid);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Revoke this role's access to the given media.  Writes audit record.
   */
  public void revokeAccess(HttpSession session, Media m) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException, UserNotFoundException, ValidationException, IOException {
    ServletContext context = session.getServletContext();
    revokeAccess(context, m);
    audit(session, "accessroles_media", 'U', "AccessRole "+getRolename()+" access to Media "+m.filename+" ("+m.mid+") revoked.");
  }

  /**
   * Convenience wrapper for Util.charsOrNull.
   */
  public static String charsOrNull(String str) {
    return Util.charsOrNull(str);
  }

  /**
   * Return the count of distinct nodes with access control
   */
  static int nodeCount(DB db) throws SQLException {
    db.executeQuery("SELECT count(DISTINCT nid) AS count FROM accessroles_nodes");
    db.rs.next();
    return db.rs.getInt("count");
  }

  /**
   * Return the count of distinct nodes with access control
   */
  public static int nodeCount(ServletContext context) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException, AccessUserException {
    DB db = null;
    try {
      db = new DB(context);
      return nodeCount(db);
    } finally {
      if (db!=null) db.close();
    }
  }

}

