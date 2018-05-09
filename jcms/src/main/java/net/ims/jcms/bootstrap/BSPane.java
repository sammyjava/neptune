package net.ims.jcms.bootstrap;

import net.ims.jcms.*;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.TimeZone;
import java.util.ArrayList;
import javax.naming.NamingException;
import javax.servlet.ServletContext;

/**
 * Extends Record to contain the data for a single BSPane.
 * Provides methods for inserting, updating, deleting, validation, and implements the Comparable interface for sorting.
 *
 * A BSPane holds either a Content item or a BSGrid.
 * All BSPanes belong to a BSGrid. When a BSGrid is created, a single BSPane is automatically created and associated with it.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class BSPane extends Record {

    /** the name of the database table, used by audit method */
    private static String tablename = "bspanes";
    
    /** bspanes.bspane_id: the primary key for this record */
    private int bspane_id;

    /** bspanes.bsgrid_id: the primary key of the BSGrid that contains this pane */
    private int bsgrid_id;

    /** bspanes.contained_bsgrid_id: the primary key of the BSGrid contained BY this pane; zero if none, in which case the pane contains Content */
    private int contained_bsgrid_id;
    
    /** bspanes.label: the label of this pane, for stylesheet use */
    private String label;
    
    /** bspanes.num: the unique positive number of this pane, for ordering within the containing grid, starting with 1 */
    private int num;

    /** bspanes.span: the number of Bootstrap columns this pane spans - from 1 to 12 */
    private int span;

    /** the BSGrid contained within this pane (null if pane doesn't contain a grid) */
    public BSGrid containedBSGrid;
    
    /**
     * Construct a default instance
     */
    public BSPane() {
	setDefaults();
    }

    /**
     * Construct given DB connection and an int primary key
     */
    public BSPane(DB db, int key) throws SQLException {
	select(db, key);
    }

    /**
     * Construct given servlet context and an int primary key
     */
    public BSPane(ServletContext context, int key) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
	DB db = null;
	try {
	    db = new DB(context);
	    select(db, key);
	} finally {
	    if (db!=null) db.close();
	}
    }

    /**
     * Construct given a loaded ResultSet
     */
    protected BSPane(ResultSet rs) throws SQLException {
	populate(rs);
    }

    /**
     * Load instance vars from a ResultSet
     */
    protected void populate(ResultSet rs) throws SQLException {
	bspane_id = rs.getInt("bspane_id");
	bsgrid_id = rs.getInt("bsgrid_id");
	contained_bsgrid_id = rs.getInt("contained_bsgrid_id");
	label = rs.getString("label");
	num = rs.getInt("num");
	span = rs.getInt("span");
    }

    /**
     * Refresh this instance with values from the database record
     */
    protected void refresh(DB db) throws SQLException {
	select(db, bspane_id);
    }
    
    /**
     * Do a SELECT query and set instance variables given a DB connection and a primary key
     */
    protected void select(DB db, int key) throws SQLException {
	db.executeQuery("SELECT * FROM bspanes WHERE bspane_id="+key);
	if (db.rs.next()) populate(db.rs);
	setContainedBSGrid(db);
    }

    /**
     * Throw a ValidationException if validation fails
     */
    public void validate() throws ValidationException {
	String message = "";
	if (num<1) message += "You must provide a positive number for this pane, unique within the containing grid. ";
	if (label!=null && !Util.isValidCSSIdentifier(label)) message += "The pane label must be a valid CSS identifier: starts with a letter, contains letters and numbers, hyphen and underscore; no spaces. ";
	if (message.length()>0) throw new ValidationException(message);
    }

    /**
     * Insert a new pane.
     */
    protected void insert(DB db) throws SQLException, ValidationException {
	validate();
	db.executeUpdate("INSERT INTO bspanes (bsgrid_id,label,num,span) VALUES ("+intOrNull(bsgrid_id)+","+charsOrNull(label)+","+intOrNull(num)+","+intOrNull(span)+")");
	// get this pane's primary key
	db.executeQuery("SELECT max(bspane_id) AS bspane_id FROM bspanes");
	db.rs.next();
	bspane_id = db.rs.getInt("bspane_id");
	refresh(db);
    }

    /**
     * Update from instance vars. Can't change containing grid.
     */
    protected void update(DB db) throws SQLException, ValidationException {
	validate();
	db.executeUpdate("UPDATE bspanes SET num="+intOrNull(num)+",contained_bsgrid_id="+intOrNull(contained_bsgrid_id)+",span="+intOrNull(span)+",label="+charsOrNull(label)+"  WHERE bspane_id="+bspane_id);
	refresh(db);
    }
    
    /**
     * Delete a pane.
     */
    protected void delete(DB db) throws SQLException, ValidationException {
	if (containsBSGrid()) {
	    throw new ValidationException("Pane <b>"+label+"</b> contains a grid. You must delete the contained grid before you can delete the pane.");
	} else {
	    db.executeUpdate("DELETE FROM bspanes WHERE bspane_id="+bspane_id);
	    setDefaults();
	}
    }

    /**
     * Insert an audit record for the given action
     */
    protected void audit(DB db, char action, String username) throws SQLException {
	Audit a = new Audit();
	a.tablename = tablename;
	a.record_id = bspane_id;
	a.action = action;
	a.username = username;
	a.description = "pane:"+bspane_id+" "+label;
	a.insert(db);
    }

    /**
     * Return true if this instance is not instantiated
     */
    public boolean isDefault() {
	return bspane_id==0;
    }

    /**
     * Set default values.
     */
    public void setDefaults() {
	bspane_id = 0;
	bsgrid_id = 0;
	contained_bsgrid_id = 0;
	num = 0;
	label = null;
	containedBSGrid = null;
    }

    /**
     * Comparator for sorting, uses num
     */
    public int compareTo(Object o) {
	BSPane that = (BSPane)o;
	return this.num - that.num;
    }

    /**
     * Return true if same primary key
     */
    public boolean equals(Object o) {
	BSPane that = (BSPane) o;
	return this.bspane_id==that.bspane_id;
    }

    // -----------------------------------------------------------------------------------------------------------------------------------------
    // Setters and Getters
    // -----------------------------------------------------------------------------------------------------------------------------------------

    /**
     * Set this intance's primary key
     */
    public void setKey(int key) {
	bspane_id = key;
    }
    /**
     * Return this instance's primary key
     */
    public int getKey() {
	return bspane_id;
    }

    /**
     * Set this instance's containing grid ID
     */
    public void setBSGridId(int id) {
	bsgrid_id = id;
    }
    /**
     * Return this instance's containing grid ID
     */
    public int getBSGridId() {
	return bsgrid_id;
    }

    /**
     * Return this instance's contained grid ID
     */
    public int getContainedBSGridId() {
	return contained_bsgrid_id;
    }
    /**
     * Return true if this pane contains a grid
     */
    public boolean containsBSGrid() {
	return contained_bsgrid_id!=0;
    }

    /**
     * Set this instance's label
     */
    public void setLabel(String l) {
	label = l;
    }
    /**
     * Return this instance's label
     */
    public String getLabel() {
	return label;
    }

    /**
     * Set this instance's num
     */
    public void setNum(int n) {
	num = n;
    }
    /**
     * Return this instance's num
     */
    public int getNum() {
	return num;
    }

    /**
     * Set this instance's span
     */
    public void setSpan(int n) {
	span = n;
    }
    /**
     * Return this instance's span
     */
    public int getSpan() {
	return span;
    }

    // -----------------------------------------------------------------------------------------------------------------------------------------
    // Custom DB methods
    // -----------------------------------------------------------------------------------------------------------------------------------------

    /**
     * Set this instance's contained BSGrid; don't use BSGrid(db,key) constructer because it calls setParentBSPane here, causing an infinite loop!
     */
    void setContainedBSGrid(DB db) throws SQLException {
	containedBSGrid = null;
	if (containsBSGrid()) {
	    db.executeQuery("SELECT * FROM bsgrids WHERE bsgrid_id="+contained_bsgrid_id);
	    if (db.rs.next()) {
		containedBSGrid = new BSGrid(db.rs);
		containedBSGrid.parentBSPane = this;
	    }
	    // set the contained grid's bspanes (if this doesn't send us into a spiral)
	    containedBSGrid.setBSPanes(db);
	}
    }

    /**
     * Create the grid contained by this pane. Abort if this pane already contains a grid.
     */
    public void createContainedBSGrid(ServletContext context) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException, IOException, ValidationException {
	if (containsBSGrid()) throw new ValidationException("BSPane "+getLabel()+" already contains a grid. BSGrid not created.");
	DB db = null;
	try {
	    db = new DB(context);
	    // create the contained grid
	    containedBSGrid = new BSGrid();
	    containedBSGrid.setParentBSPaneId(getKey());
	    containedBSGrid.setLabel(label+"-grid");
	    containedBSGrid.insert(context);
	    // update this pane with the contained grid's id
	    contained_bsgrid_id = containedBSGrid.getKey();
	    update(db);
	} finally {
	    if (db!=null) db.close();
	}
    }

    /**
     * Remove the grid contained by this pane, if it contains a grid.
     */
    public void removeContainedBSGrid(ServletContext context) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException, IOException, ValidationException {
	if (containsBSGrid()) {
	    DB db = null;
	    try {
		db = new DB(context);
		containedBSGrid.delete(db);
		refresh(db);
	    } finally {
		if (db!=null) db.close();
	    }
	}
    }

}
