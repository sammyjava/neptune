package net.ims.jcms;

import net.ims.jcms.bootstrap.*;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.io.FileNotFoundException;
import java.util.Date;
import javax.naming.NamingException;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

/**
 * Extends record to encapsulate an association of a node with a page, media file, external URL or child node.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class NodeLink extends Record {

    /** nodelinks.nlid: primary key of nodelinks record */
    public int nlid;

    /** nodelinks.nid: the nodes.nid record which is linked by this record */
    public int nid;

    /** nodelinks.pid: the primary key of the related pages record */
    public int pid;

    /** nodelinks.mid: the primary key of the related media record */
    public int mid;

    /** nodelinks.redirectnid: the nid of the node redirected to */
    public int redirectnid;

    /** nodelinks.url: the URL that this node links */
    public String url;

    /** nodelinks.starttime: the start time of this linkage */
    public Timestamp starttime;

    /**
     * Constructs simply setting instance variables to defaults
     */
    public NodeLink() {
        setDefaults();
    }

    /**
     * Constructs given a db connection and primary key
     */
    NodeLink(DB db, int key) throws SQLException {
        select(db, key);
    }

    /**
     * Constructs given the ServletContext, and a key
     */
    public NodeLink(ServletContext context, int nlid) throws SQLException, ValidationException, FileNotFoundException, NamingException, ClassNotFoundException {
        DB db = null;
        try {
            db = new DB(context);
            select(db, nlid);
        } finally {
            if (db!=null) db.close();
        }
    }

    /**
     * Constructs given the instance var values
     */
    public NodeLink(int nlid, int nid, int pid, int mid, int redirectnid, String url, Timestamp starttime) {
        this.nlid = nlid;
        this.nid = nid;
        this.pid = pid;
        this.mid = mid;
        this.redirectnid = redirectnid;
        this.url = url;
        this.starttime = starttime;
    }

    /**
     * Constructs and inserts given the Servlet context, and instance var values, with a string starttime value
     */
    public NodeLink(ServletContext context, int nid, int pid, int mid, int redirectnid, String url, Timestamp starttime) throws SQLException, ValidationException, FileNotFoundException, NamingException, ClassNotFoundException {
        DB db = null;
        try {
            this.nid = nid;
            this.pid = pid;
            this.mid = mid;
            this.redirectnid = redirectnid;
            this.url = url;
            this.starttime = starttime;
            db = new DB(context);
            insert(db);
        } finally {
            if (db!=null) db.close();
        }
    }

    /**
     * Constructs the current NodeLink from a given Node nid, without instanting the Node. Set current=true to return current active link, 
     * false to return latest nodelink for this node.
     */
    public NodeLink(DB db, int nid, boolean current) throws SQLException {
        String query = "SELECT * FROM nodelinks WHERE nid="+nid;
        if (current) query += " AND starttime<"+db.now();
        query += " ORDER BY starttime DESC";
        db.executeQuery(query);
        if (db.rs.next()) {
            nlid = db.rs.getInt("nlid");
            select(db, nlid);
        } else {
            setDefaults();
        }
    }

    /**
     * Constructs a NodeLink from a populated resultset
     */
    public NodeLink(ResultSet rs) throws SQLException {
        populate(rs);
    }

    /**
     * Populate instance given a populated ResultSet.
     */
    protected void populate(ResultSet rs) throws SQLException {
        nlid = rs.getInt("nlid");
        nid = rs.getInt("nid");
        pid = rs.getInt("pid");
        mid = rs.getInt("mid");
        redirectnid = rs.getInt("redirectnid");
        url = rs.getString("url");
        starttime = rs.getTimestamp("starttime");
    }

    /**
     * Refresh this instance with values from the database record
     */
    protected void refresh(DB db) throws SQLException {
        select(db, nlid);
    }
    
    /**
     * Does a SELECT query and sets instance variables given a DB connection and a primary key
     */
    protected void select(DB db, int key) throws SQLException {
        db.executeQuery("SELECT * FROM nodelinks WHERE nlid="+key);
        if (db.rs.next()) {
            populate(db.rs);
        } else {
            setDefaults();
        }
    }

    /**
     * Inserts a new record into the database using the current instance variables and a DB connection. Enforces a number of validation rules.
     */
    protected void insert(DB db) throws SQLException, ValidationException {
        if (starttime==null) {
            starttime = db.getCurrentTimestamp();
        } else {
            // disallow inserts for times in the past
            if (starttime.before(db.getCurrentTimestamp())) throw new ValidationException("You may not schedule links to appear in the past (starttime="+starttime+", now="+db.getCurrentTimestamp()+").");
        }
        // do insert
        db.executeUpdate("INSERT INTO nodelinks (nid, pid, mid, redirectnid, url, starttime) VALUES (" +
                         nid+","+intOrNull(pid)+","+intOrNull(mid)+","+intOrNull(redirectnid)+","+charsOrNull(url)+",'"+starttime+"')");
        db.executeQuery("SELECT max(nlid) AS nlid FROM nodelinks");
        db.rs.next();
        nlid = db.rs.getInt("nlid");
        refresh(db);
        // disallow inserting a link that matches the link before it
        String query = "SELECT * FROM nodelinks WHERE nid="+nid+" AND nlid<>"+nlid+" AND starttime<'"+starttime+"' ORDER BY starttime DESC";
        db.executeQuery(query);
        if (db.rs.next()) {
            int nlidPrev = db.rs.getInt("nlid");
            NodeLink nlPrev = new NodeLink(db, nlidPrev);
            if (this.equals(nlPrev)) {
                String errorMessage = "Node "+nid+" is already scheduled with that link at "+nlPrev.getStartTimeString(db)+".";
                if (pid==0 && mid==0 && redirectnid==0 && url==null) errorMessage = "Node "+nid+" is already scheduled to be inactive at "+getStartTimeString(db)+".";
                // delete record
                delete(db);
                // throw validation exception
                throw (new ValidationException(errorMessage));
            }
        }
    }

    /**
     * Updates a database record with current instance values given DB object
     */
    protected void update(DB db) throws SQLException {
        db.executeUpdate("UPDATE nodelinks SET " +
                         "nid="+nid+", " +
                         "pid="+intOrNull(pid)+", " +
                         "mid="+intOrNull(mid)+", " +
                         "redirectnid="+intOrNull(redirectnid)+", " +
                         "url="+charsOrNull(url)+", " +
                         "starttime='"+starttime+"' " +
                         "WHERE nlid="+nlid);
    }

    /**
     * Deletes this record from the database.
     */
    protected void delete(DB db) throws SQLException {
        db.executeUpdate("DELETE FROM nodelinks WHERE nlid="+nlid);
        setDefaults();
    }

    /**
     * Sets default values
     */
    protected void setDefaults() {
        nlid = 0;
        nid = 0;
        pid = 0;
        mid = 0;
        redirectnid = 0;
        url = null;
        starttime = null;
    }

    /**
     * Return true if this is a default (unpopulated) instance
     */
    public boolean isDefault() {
        return nlid==0;
    }

    /**
     * No auditing is done for this class.
     */
    protected void audit(DB db, char action, String email) {
    }

    /**
     * Return a comparison of start times; required by Comparable interface.
     */
    public int compareTo(Object o) {
        NodeLink that = (NodeLink) o;
        return this.starttime.compareTo(that.starttime);
    }

    /**
     * Return true if this node matches another with same pid and mid and redirectnid and url.
     */
    public boolean equals(NodeLink that) {
        return (this.pid==that.pid && this.mid==that.mid && this.redirectnid==that.redirectnid && (this.url==null && that.url==null || (this.url!=null && that.url!=null && this.url.equals(that.url))));
    }

    /**
     * Return true if this node matches another with same pid and mid and redirectnid and url.  Overrides object.equals().
     */
    public boolean equals(Object o) {
        NodeLink that = (NodeLink) o;
        return this.equals(that);
    }

    /**
     * Sets the string form of this record's starttime according to the current value of timezone
     */
    public String getStartTimeString(DB db) throws SQLException {
        return formatTimestamp(db, starttime);
    }

    /**
     * Sets the string form of this record's starttime according to the current value of timezone
     */
    public String getStartTimeString(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
        return formatTimestamp(context, starttime);
    }

    /**
     * Return true if this link has expired, ie. a different one exists at a later time than this that is in the past.
     */
    boolean expired(DB db) throws SQLException {
        db.executeQuery("SELECT count(*) AS count FROM nodelinks WHERE nlid<>"+nlid+" AND nid="+nid+" AND starttime>'"+starttime+"' AND starttime<"+db.now());
        db.rs.next();
        return (db.rs.getInt("count")>0);
    }

    /**
     * Return true if this link has expired, ie. a different one exists at a later time than this that is in the past.
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
     * Return true if this link is the currently active one, meaning it is the most recent record.
     */
    boolean active(DB db) throws SQLException {
        db.executeQuery("SELECT * FROM nodelinks WHERE nid="+nid+" AND starttime<"+db.now()+" ORDER BY starttime DESC");
        if (db.rs.next()) {
            return (nlid==db.rs.getInt("nlid"));
        } else {
            return false;
        }
    }

    /**
     * Return true if this link is the currently active one.
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
     * Return the URL for this link.  Recursive!
     */
    public String getUrl(DB db) throws SQLException {
        if (isUrl()) return url;
        if (isMedia()) {
            Media m = new Media(db, mid);
            return Setting.getString(db,"site_mediafolder")+"/"+m.filename;
        } else if (isPage() || isRedirect()) {
            db.executeQuery("SELECT alias FROM nodes WHERE nid="+nid);
            if (db.rs.next()) {
                String alias = db.rs.getString("alias");
                if (alias==null) {
                    if (isPage()) {
                        if (nid==0) {
                            return Setting.getString(db,"site_rootfolder")+"/";
                        } else {
                            return Setting.getString(db,"site_rootfolder")+"/index.jsp?nid="+nid;
                        }
                    } else {
                        // RECURSIVE HERE!
                        NodeLink redirectNodeLink = new NodeLink(db, redirectnid, true);
                        return redirectNodeLink.getUrl(db);
                    }
                } else {
                    return Setting.getString(db,"site_rootfolder")+"/"+alias;
                }
            } else {
                return null;
            }
        } else {
            return null;
        }
    }

    /**
     * Return the URL for this link.
     */
    public String getUrl(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
        DB db = null;
        try {
            db = new DB(context);
            return getUrl(db);
        } finally {
            if (db!=null) db.close();
        }      
    }

    /**
     * Return the page on this link, if it's a page, null otherwise.
     */
    public Page getPage(DB db) throws SQLException {
        if (isPage()) {
            return new Page(db, pid);
        } else {
            return null;
        }
    }
    /**
     * Return the page on this link, if it's a page, null otherwise.
     */
    public Page getPage(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
        DB db = null;
        try {
            db = new DB(context);
            return getPage(db);
        } finally {
            if (db!=null) db.close();
        }      
    }

    /**
     * Return the page on this link, if it's a page, null otherwise.
     */
    public BSPage getBSPage(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
        if (isPage()) {
            return new BSPage(context, pid);
        } else {
            return null;
        }
    }

    /**
     * Return the media on this link, if it's a media file, null otherwise.
     */
    public Media getMedia(DB db) throws SQLException {
        if (isMedia()) {
            return new Media(db, mid);
        } else {
            return null;
        }
    }
    /**
     * Return the media on this link, if it's a media file, null otherwise.
     */
    public Media getMedia(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
        DB db = null;
        try {
            db = new DB(context);
            return getMedia(db);
        } finally {
            if (db!=null) db.close();
        }      
    }

    /**
     * Return the redirect node on this link, if it's a redirect, null otherwise.
     */
    public Node getRedirectNode(DB db) throws SQLException {
        if (isRedirect()) {
            return new Node(db, redirectnid);
        } else {
            return null;
        }
    }
    /**
     * Return the redirect node on this link, if it's a redirect, null otherwise.
     */
    public Node getRedirectNode(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
        DB db = null;
        try {
            db = new DB(context);
            return getRedirectNode(db);
        } finally {
            if (db!=null) db.close();
        }      
    }

    /**
     * Return true if link is to a Page.
     */
    public boolean isPage() {
        return (pid!=0);
    }

    /**
     * Return true if link is to a media file.
     */
    public boolean isMedia() {
        return (mid!=0);
    }

    /**
     * Return true if link is a redirect.
     */
    public boolean isRedirect() {
        return (redirectnid!=0);
    }

    /**
     * Return true if link is to an external URL.
     */
    public boolean isUrl() {
        return (url!=null);
    }

    /**
     * Return true if link is empty.
     */
    public boolean isEmpty() {
        return (!isPage() && !isMedia() && !isRedirect() && !isUrl());
    }

}
