package net.ims.jcms;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.Serializable;
import java.sql.SQLException;
import java.util.Vector;
import javax.naming.NamingException;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpSession;

/**
 * This abstract class defines the AccessUser methods: authentication, retrieving AccessRoles associated with this user, and determining whether a Node or Media instance may be accessed.
 * Since the AccessUser may be stored externally with read-only access, this interface does NOT contain any methods for updating users or role-user relationships.  Any
 * such methods may be added to a class which extends AccessUser.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public abstract class AccessUser implements Comparable, Serializable {

  static final long serialVersionUID = 5346647184660231557L;

  ///////////////////////////////////////////
  // abstract methods, must be implemented //
  ///////////////////////////////////////////

  /**
   * Return true if this user is (default) public user.
   */
  public abstract boolean isDefault();

  /**
   * Return true if this Access User is the same as the provided one.
   */
  public abstract boolean equals(AccessUser user);

  /**
   * Comparison method for sorting users, required by Comparable interface.
   */
  public abstract int compareTo(Object o);

  /**
   * Factory method to return a default AccessUser instance.  Static method.
   */
  public abstract AccessUser getDefault();

  /**
   * Return an array of all AccessUsers, sorted by comparator.  Static method.
   */
  public abstract AccessUser[] getAll(ServletContext context) throws AccessUserException;

  /**
   * Factory method to return an AccessUser instance given a username and password.  Static method.
   * This method is used to instantiate an AccessUser in the app.
   */
  public abstract AccessUser getAccessUser(ServletContext context, String username, String password) throws AccessUserException;

  /**
   * Factory method to return an AccessUser instance given ONLY a username.  Static method.
   * This method should ONLY be used after authentication has been checked.  Throws an AccessUserException if user is not found or cannot be found without a password.
   */
  public abstract AccessUser getAccessUser(ServletContext context, String username) throws AccessUserException;

  /**
   * Return the username associated with this access user; null if this is the default user.  Username should be stored as an instance variable in implementing classes,
   * so ServletContext is not needed.
   */
  public abstract String getUsername();

  /**
   * Return the label associated with username.  This could be "Username" or "Email" or whatever.
   */
  public abstract String getUsernameLabel();

  /**
   * Return the roles associated with this access user; empty array if none.
   */
  public abstract AccessRole[] getAccessRoles(ServletContext context) throws AccessUserException;

  /**
   * Return true if this user is a member of the given AccessRole.
   */
  public abstract boolean isMember(ServletContext context, AccessRole role) throws AccessUserException;

  ////////////////////
  // common methods //
  ////////////////////

  /**
   * Return a Vector of Nodes on which this user has explicit access permission (via role assignment).
   */
  public Vector getNodes(ServletContext context) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      Vector<Node> nodes = new Vector<Node>();
      String query = "SELECT DISTINCT nodes.* FROM accessroles_nodes,accessroles_accessusers " +
	"WHERE accessroles_nodes.rolename=accessroles_accessusers.rolename AND accessroles_accessusers.username="+charsOrNull(getUsername());
      db.executeQuery(query);
      while (db.rs.next()) nodes.add(new Node(db.rs));
      return nodes;
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return a Vector of Media on which this user has explicit access permission (via role assignment).
   */
  public Vector getMedia(ServletContext context) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context);
      Vector<Media> media = new Vector<Media>();
      String query = "SELECT DISTINCT media.* FROM accessroles_media,accessroles_accessusers " +
	"WHERE accessroles_media.rolename=accessroles_accessusers.rolename AND accessroles_accessusers.username="+charsOrNull(getUsername());
      db.executeQuery(query);
      while (db.rs.next()) media.add(new Media(db.rs));
      return media;
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return true if user may access the given Node, through role assignment or because the Node is not restricted.  Recursive! Time consuming!
   */
  public boolean mayAccess(ServletContext context, Node n) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException, AccessUserException {
    DB db = null;
    try {
      db = new DB(context);
      boolean debug = Setting.isOn(db,"site_debug");
      if (debug) System.out.print("mayAccess("+n.nodename+")...");
      // bail if NO nodes are restricted
      if (AccessRole.nodeCount(db)==0) {
	if (debug) System.out.println("true");
	return true;
      }
      // check if node is explicitly restricted
      if (debug) System.out.print("check if node is explicitly restricted...");
      db.executeQuery("SELECT count(*) AS count FROM accessroles_nodes WHERE nid="+n.nid);
      db.rs.next();
      int count = db.rs.getInt("count");
      if (count==0) {
	// this node isn't restricted
	if (debug) System.out.print("no...");
	if (n.isDefault()) {
	  // we've reached the top, done
	  if (debug) System.out.println("true");
	  return true;
	}
	// inherit restriction from node above
	return mayAccess(context, n.getParent(db));
      } else {
	// node has restrictions, check through this user's roles
	if (debug) System.out.print("yes...");
	AccessRole roles[] = getAccessRoles(context);
	if (debug) System.out.print("got "+roles.length+" roles...");
	for (int i=0; i<roles.length; i++) {
	  if (roles[i]==null) {
	    System.out.println("*************************** ["+i+"] is null!...false");
	    return false;
	  }
	  if (debug) System.out.print("["+i+"]"+roles[i].getRolename()+":");
	  if (roles[i].mayAccess(db,n)) {
	    // role is explicitly assigned to this node, done
	    if (debug) System.out.println("yes...true");
	    return true;
	  } else {
	    // role not assigned to this node
	    if (debug) System.out.print("no");
	  }
	}
	// node is restricted and no assigned roles are granted access to it
	if (debug) System.out.println("false");
	return false;
      }
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return true if user has permission on the given Media, through role assignment or because the Media is not restricted.
   */
  public boolean mayAccess(ServletContext context, Media m) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException, AccessUserException {
    DB db = null;
    try {
      db = new DB(context);
      // check if media is unrestricted
      db.executeQuery("SELECT count(*) AS count FROM accessroles_media WHERE mid="+m.mid);
      db.rs.next();
      if (db.rs.getInt("count")==0) return true; // unrestricted
      // check through this user's roles
      AccessRole roles[] = getAccessRoles(context);
      for (int i=0; i<roles.length; i++) {
	if (roles[i].mayAccess(db,m)) return true;  // explicit access
      }
      return false; // restricted and no assigned roles are granted access to media
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Convenience wrapper for Util.charsOrNull.
   */
  public static String charsOrNull(String str) {
    return Util.charsOrNull(str);
  }

}
