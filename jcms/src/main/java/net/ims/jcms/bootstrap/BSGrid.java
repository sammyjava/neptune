package net.ims.jcms.bootstrap;

import net.ims.jcms.*;

import java.sql.SQLException;
import java.io.FileNotFoundException;
import javax.naming.NamingException;
import javax.servlet.ServletContext;

import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.TreeSet;

/**
 * Extends Record to contain the data for a single BSGrid.
 * Provides methods for inserting, updating, deleting, validation, and implements the Comparable interface for sorting.
 *
 * A BSGrid represents a single Bootstrap grid, which contains one or more BSPanes. The BSPanes are numbered; pane 1 is always created
 * when a BSGrid is created and represents a full lg-12 row.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class BSGrid extends Record {

    /** the name of the database table, used by audit method */
    private static String tablename = "bsgrids";
    
    /** bsgrids.bsgrid_id: the primary key for this record */
    private int bsgrid_id;
    
    /** bsgrids.bspane_id: the id of the parent BSPane holding this grid; null/zero for a root grid */
    private int bspane_id;

    /** bsgrids.label: the unique stylesheet class for this grid; can be null */
    private String label;

    /** bsgrids.nrows: the number of rows */
    private int nrows;

    /** the parent BSPane; null if this is a root grid */
    public BSPane parentBSPane;

    /** the BSPanes belonging to this grid; there is always at least one */
    public TreeSet<BSPane> bspanes;

    /**
     * Construct a default instance
     */
    public BSGrid() {
    }

    /**
     * Construct given DB connection and an int primary key
     */
    public BSGrid(DB db, int key) throws SQLException {
		select(db, key);
    }

    /**
     * Construct given servlet context and an int primary key
     */
    public BSGrid(ServletContext context, int key) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context);
			select(db, key);
		} finally {
			if (db!=null) db.close();
		}
    }

    /**
     * Construct given a loaded ResultSet; does NOT setParentBSPane or setBSPanes!
     */
    protected BSGrid(ResultSet rs) throws SQLException {
		populate(rs);
    }

    /**
     * Load instance vars from a ResultSet; does NOT setBSPanes or setParentBSPane
     */
    protected void populate(ResultSet rs) throws SQLException {
		bsgrid_id = rs.getInt("bsgrid_id");
		bspane_id = rs.getInt("bspane_id");
		label = rs.getString("label");
		nrows = rs.getInt("nrows");
    }

    /**
     * Refresh this instance with values from the database record
     */
    protected void refresh(DB db) throws SQLException {
		select(db, bsgrid_id);
    }
    
    /**
     * Do a SELECT query and set instance variables given a DB connection and a primary key; instantiates parentBSPane and bspanes
     */
    protected void select(DB db, int key) throws SQLException {
		db.executeQuery("SELECT * FROM bsgrids WHERE bsgrid_id="+key);
		if (db.rs.next()) {
			populate(db.rs);
			setBSPanes(db);
			setParentBSPane(db);
		}
    }

    /**
     * Throw a ValidationException if validation fails
     */
    public void validate() throws ValidationException {
		String message = "";
		if (label==null || label.trim().length()==0) {
			message += "You must supply a label for this grid. ";
		} else if (!Util.isValidCSSIdentifier(label)) {
			message += "The grid label must be a valid CSS identifier: starts with a letter, contains letters and numbers, hyphen and underscore; no spaces. ";
		}
		if (message.length()>0) throw new ValidationException(message);
    }

    /**
     * Insert a new grid, creating a single contained pane as well. bspane_id is null/zero if this is a root grid.
     */
    protected void insert(DB db) throws SQLException, ValidationException {
		validate();
		// first create the new grid
		db.executeUpdate("INSERT INTO bsgrids (bspane_id,label) VALUES ("+intOrNull(bspane_id)+","+charsOrNull(label)+")");
		db.executeQuery("SELECT max(bsgrid_id) AS bsgrid_id FROM bsgrids");
		db.rs.next();
		bsgrid_id = db.rs.getInt("bsgrid_id");
		refresh(db);
		// add a single contained full-span pane
		addBSPane(db, 1, label+"-"+1, 12);
    }

    /**
     * Update label from instance vars. No change to bspanes.
     */
    protected void update(DB db) throws SQLException, ValidationException {
		validate();
		db.executeUpdate("UPDATE bsgrids SET label="+charsOrNull(label)+" WHERE bsgrid_id="+bsgrid_id);
		refresh(db);
    }
    
    /**
     * Delete a grid.
     */
    protected void delete(DB db) throws SQLException, ValidationException {
		// can't delete if it's used by a page
		if (inUse(db)) throw new ValidationException("This layout is currently in use on a page and cannot be deleted.");
		// contained bsgrids must be deleted manually
		if (containsBSGrid()) throw new ValidationException("This layout/grid contains at least one pane which contains a grid. You must delete that grid first.");
		// update bspanes that contain this grid; no foul if bsgrid_id==0
		db.executeUpdate("UPDATE bspanes SET contained_bsgrid_id=NULL WHERE contained_bsgrid_id="+bsgrid_id);
		// delete bspanes contained by this grid
		db.executeUpdate("DELETE FROM bspanes WHERE bsgrid_id="+bsgrid_id);
		// delete this grid
		db.executeUpdate("DELETE FROM bsgrids WHERE bsgrid_id="+bsgrid_id);
		setDefaults();
    }

    /**
     * Insert an audit record for the given action
     */
    protected void audit(DB db, char action, String username) throws SQLException {
		Audit a = new Audit();
		a.tablename = tablename;
		a.record_id = bsgrid_id;
		a.action = action;
		a.username = username;
		a.description = "grid:"+bsgrid_id+" "+label;
		a.insert(db);
    }

    /**
     * Return true if this instance is not instantiated
     */
    public boolean isDefault() {
		return bsgrid_id==0;
    }

    /**
     * Set default values.
     */
    public void setDefaults() {
		bsgrid_id = 0;
		bspane_id = 0;
		label  = null;
    }

    /**
     * Comparator for sorting, uses bspane_id, then label
     */
    public int compareTo(Object o) {
		BSGrid that = (BSGrid)o;
		if (this.bspane_id!=that.bspane_id) {
			return this.bspane_id - that.bspane_id;
		} else {
			return this.label.compareTo(that.label);
		}
    }

    /**
     * Return true if same primary key
     */
    public boolean equals(Object o) {
		BSGrid that = (BSGrid) o;
		return this.bsgrid_id==that.bsgrid_id;
    }
    
    // -----------------------------------------------------------------------------------------------------------------------------------------
    // Setters and Getters
    // -----------------------------------------------------------------------------------------------------------------------------------------

    /**
     * Set this intance's primary key
     */
    public void setKey(int key) {
		bsgrid_id = key;
    }
    /**
     * Return this instance's primary key
     */
    public int getKey() {
		return bsgrid_id;
    }

    /**
     * Return true if this is a root pane
     */
    public boolean isRoot() {
		return bspane_id == 0;
    }

    /**
     * Set this instance's label
     */
    public void setLabel(String l) {
		label = l;
    }
    /**
     * Get this instance's label
     */
    public String getLabel() {
		return label;
    }

    /**
     * Get this instance's parent pane id
     */
    public int getParentBSPaneId() {
		return bspane_id;
    }
    /**
     * Set this instance's parent pane id (before creating this grid, typically)
     */
    public void setParentBSPaneId(int p) {
		bspane_id = p;
    }
    /**
     * Return true if this grid has a parent pane
     */
    public boolean hasParentBSPane() {
		return bspane_id!=0;
    }

    /**
     * Get this instance's nrows
     */
    public int getNRows() {
		return nrows;
    }

    // -----------------------------------------------------------------------------------------------------------------------------------------
    // Custom DB methods
    // -----------------------------------------------------------------------------------------------------------------------------------------

    /**
     * Instantiate the parent pane of this grid; do not use BSPane(db,key) constructor to avoid pane-constructing infinite loop!
     */
    void setParentBSPane(DB db) throws SQLException {
		parentBSPane = null;
		if (hasParentBSPane()) {
			db.executeQuery("SELECT * FROM bspanes WHERE bspane_id="+bspane_id);
			if (db.rs.next()) {
				parentBSPane = new BSPane(db.rs);
				parentBSPane.containedBSGrid = this;
			}
		}
    }

    /**
     * Fill the TreeSet with contained bspanes of this grid
     */
    void setBSPanes(DB db) throws SQLException {
		bspanes = new TreeSet<BSPane>();
		db.executeQuery("SELECT * FROM bspanes WHERE bsgrid_id="+bsgrid_id+" ORDER BY num");
		while (db.rs.next()) bspanes.add(new BSPane(db.rs));
		// refresh the contained bspanes (some contain bsgrids)
		for (BSPane pane : bspanes) {
			pane.refresh(db);
		}
    }

    /**
     * Add a new pane
     */
    public void addBSPane(DB db, int num, String label, int span) throws SQLException, ValidationException {
		BSPane pane = new BSPane();
		pane.setBSGridId(bsgrid_id);
		pane.setNum(num);
		pane.setLabel(label);
		pane.setSpan(span);
		pane.insert(db);
		refresh(db);
    }
    /**
     * Add a new pane
     */
    public void addBSPane(ServletContext context, int num, String label, int span) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException, ValidationException {
		DB db = null;
		try {
			db = new DB(context);
			addBSPane(db, num, label, span);
		} finally {
			if (db!=null) db.close();
		}
    }

    /**
     * Remove the pane with the given num value
     */
    public void removeBSPane(DB db, int num) throws SQLException, ValidationException {
		db.executeUpdate("DELETE FROM bspanes WHERE bsgrid_id="+bsgrid_id+" AND num="+num);
		refresh(db);
    }


    /**
     * Add a row, along with corresponding bspanes
     */
    public void addRow(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException, ValidationException {
		DB db = null;
		try {
			BSPane[] bspanesArray = bspanes.toArray(new BSPane[0]);
			int nBSPanes = bspanes.size();
			int nBSPanesToAdd = nBSPanes/nrows;
			db = new DB(context);
			db.executeUpdate("UPDATE bsgrids SET nrows=nrows+1 WHERE bsgrid_id="+bsgrid_id);
			for (int i=0; i<nBSPanesToAdd; i++) {
				int num = nBSPanes + i + 1;
				addBSPane(db, num, label+"-"+num, bspanesArray[i].getSpan());
			}
			refresh(db);
		} finally {
			if (db!=null) db.close();
		}
    }
    /**
     * Remove a row, along with corresponding bspanes
     */
    public void removeRow(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException, ValidationException {
		if (nrows==1) throw new ValidationException("BSGrid <b>"+label+"</b> has only one row; you may not remove the last row.");
		DB db = null;
		try {
			BSPane[] bspanesArray = bspanes.toArray(new BSPane[0]);
			int nBSPanes = bspanes.size();
			int nBSPanesToRemove = nBSPanes/nrows;
			db = new DB(context);
			db.executeUpdate("UPDATE bsgrids SET nrows=nrows-1 WHERE bsgrid_id="+bsgrid_id);
			for (int i=0; i<nBSPanesToRemove; i++) {
				int num = nBSPanes - i;
				removeBSPane(db, num);
			}
			refresh(db);
		} finally {
			if (db!=null) db.close();
		}
    }

    /**
     * Return an array of root bsgrids (for selectors, etc.)
     */
    public static BSGrid[] getRoots(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context);
			ArrayList<BSGrid> list = new ArrayList<BSGrid>();
			db.executeQuery("SELECT * FROM bsgrids WHERE bspane_id IS NULL ORDER BY label");
			while (db.rs.next()) list.add(new BSGrid(db.rs));
			// need to refresh bsgrids with bspanes, etc.
			BSGrid[] bsgrids = list.toArray(new BSGrid[0]);
			for (int i=0; i<bsgrids.length; i++) bsgrids[i].refresh(db);
			return bsgrids;
		} finally {
			if (db!=null) db.close();
		}
    }

    /**
     * Return true if this grid contains a pane which contains a grid.
     */
    public boolean containsBSGrid() {
		for (BSPane pane : bspanes) {
			if (pane.containsBSGrid()) return true;
		}
		return false;
    }

	/**
	 * Return true if this grid is in use on a page.
	 */
	boolean inUse(DB db) throws SQLException {
		db.executeQuery("SELECT count(*) AS count FROM bspages WHERE bsgrid_id="+bsgrid_id);
		db.rs.next();
		return db.rs.getInt("count")>0;
	}
	/**
	 * Return true if this grid is in use on a page.
	 */
	public boolean inUse(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context);
			return inUse(db);
		} finally {
			if (db!=null) db.close();
		}
	}
		
}
