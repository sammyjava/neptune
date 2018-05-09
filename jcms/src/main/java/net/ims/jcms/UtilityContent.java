package net.ims.jcms;

import java.io.FileNotFoundException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.TimeZone;
import java.util.TreeSet;
import javax.naming.NamingException;
import javax.servlet.ServletContext;

/**
 * Extends Record to contain the data for a single utilitycontent record.
 * UtilityContent replaces UtilityLink and SidebarExtension.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class UtilityContent extends Record {

	/** the name of the database table, used by audit method */
	private static String tablename = "utilitycontent";

	/** reserved JSPs that may not be added as root extensions */
	private static String[] reservedJSP = { "/access.jsp","/error.jsp","/index.jsp","/printable.jsp","/resetpassword.jsp","/sitemap.jsp" };

	/** location codes */
	public static char HEADER='H';
	public static char SUBHEADER='S';
	public static char TOP_SIDEBAR='T';
	public static char BOTTOM_SIDEBAR='B';
	public static char FOOTER='F';

	/** utilitycontent.utilitycontent_id: the primary key for this record */
	public int utilitycontent_id;

	/** utilitycontent.location: char code indicating the location of the link */
	public char location;

	/** utilitycontent.num: number which gives order of link in given location */
	public int num;

	/** utilitycontent.copy: the HTML copy */
	public String copy;

	/** utilitycontent.created: the creation timestamp */
	public Timestamp created;

	/** utilitycontent.updated: the update timestamp */
	public Timestamp updated;

	/** utilitycontent.modulecontext: servlet context of module code to be included using <c:import> tag */
	public String modulecontext;

	/** utilitycontent.moduleurl: URL of module code to be included using <c:import> tag */
	public String moduleurl;

	/** utilitycontent.moduleabove: true to place module code above copy */
	public boolean moduleabove;

	/** utilitycontent.showhome: show this item on the home page */
	public boolean showhome;

	/** utilitycontent.showhome: show this item on inside pages */
	public boolean showinside;

	/** utilitycontent.showmobile: show this item on mobile devices */
	public boolean showmobile;

	/** valid location values */
	char[] locations = {'H', 'S', 'Z', 'T', 'B', 'F'}; // header, subheader, sectionheader, top sidebar, bottom sidebar, footer

	/**
	 * Construct a default instance, usually preceding an insert
	 */
	public UtilityContent() {
		setDefaults();
	}

	/**
	 * Construct given DB connection and an int primary key
	 */
	UtilityContent(DB db, int key) throws SQLException {
		select(db, key);
	}

	/**
	 * Construct given DB connection and an int primary key
	 */
	public UtilityContent(ServletContext context, int key) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context);
			select(db, key);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Construct given a populated ResultSet.
	 */
	UtilityContent(ResultSet rs) throws SQLException {
		populate(rs);
	}

	/**
	 * Populate instance fields given a populated ResultSet.
	 */
	protected void populate(ResultSet rs) throws SQLException {
		utilitycontent_id = rs.getInt("utilitycontent_id");
		location = rs.getString("location").charAt(0);
		num = rs.getInt("num");
		copy = rs.getString("copy");
		created = rs.getTimestamp("created");
		updated = rs.getTimestamp("updated");
		modulecontext = rs.getString("modulecontext");
		moduleurl = rs.getString("moduleurl");
		moduleabove = rs.getBoolean("moduleabove");
		showhome = rs.getBoolean("showhome");
		showinside = rs.getBoolean("showinside");
		showmobile = rs.getBoolean("showmobile");
	}

	/**
	 * Refresh this instance with values from the database record
	 */
	protected void refresh(DB db) throws SQLException {
		select(db, utilitycontent_id);
	}

	/**
	 * Do a SELECT query and set instance variables given a DB connection and a primary key
	 */
	protected void select(DB db, int key) throws SQLException {
		db.executeQuery("SELECT * FROM utilitycontent WHERE utilitycontent_id="+key);
		if (db.rs.next()) populate(db.rs);
	}

	/**
	 * Validate against non-null fields, etc.
	 */
	void validate() throws ValidationException {
		boolean copyEmpty = (copy==null || copy.trim().length()==0);
		boolean moduleEmpty = (moduleurl==null || moduleurl.trim().length()==0 || modulecontext==null || modulecontext.trim().length()==0);
		if (copyEmpty && moduleEmpty) throw new ValidationException("Copy and/or extension must be supplied.");
		boolean locationValid = false;
		for (int i=0; i<locations.length; i++) if (location==locations[i]) locationValid = true;
		if (!locationValid) throw new ValidationException("Invalid location.");
		if (num==0) throw new ValidationException("Number must be non-zero.");
		if (moduleEmpty) {
			// clean up
			moduleurl = null;
			modulecontext = null;
		} else {
			// check that not a reserved JSP
			if (modulecontext.equals("/")) {
				for (int i=0; i<reservedJSP.length; i++) {
					if (moduleurl.equals(reservedJSP[i])) throw new ValidationException(moduleurl+" is not a Neptune extra.");
				}
			}
		}
	}

	/**
	 * Insert a new db record using the current instance values.
	 */
	protected void insert(DB db) throws SQLException, ValidationException {
		validate();
		String query = "INSERT INTO utilitycontent (" +
			"location,num,copy,modulecontext,moduleurl,moduleabove,showhome,showinside,showmobile" +
			") VALUES (" +
			charOrNull(location)+","+num+","+charsOrNull(copy)+","+
			charsOrNull(modulecontext)+","+charsOrNull(moduleurl)+","+db.bool(moduleabove)+","+
			db.bool(showhome)+","+db.bool(showinside)+","+db.bool(showmobile) +
			")";
		db.executeUpdate(query);
		// refresh this instance
		db.executeQuery("SELECT * FROM utilitycontent WHERE location='"+location+"' AND num="+num);
		if (db.rs.next()) {
			populate(db.rs);
		} else {
			setDefaults();
		}
	}

	/**
	 * Update the db record using the current instance values.
	 */
	protected void update(DB db) throws SQLException, ValidationException {
		validate();
		String query = "UPDATE utilitycontent SET " +
			"location="+charOrNull(location)+", " +
			"num="+num+", " +
			"copy="+charsOrNull(copy)+", " +
			"modulecontext="+charsOrNull(modulecontext)+", " +
			"moduleurl="+charsOrNull(moduleurl)+", " +
			"moduleabove="+db.bool(moduleabove)+", " +
			"showhome="+db.bool(showhome)+", " +
			"showinside="+db.bool(showinside)+", " +
			"showmobile="+db.bool(showmobile)+" " +
			"WHERE utilitycontent_id="+utilitycontent_id;
		db.executeUpdate(query);
		// refresh this instance
		db.executeQuery("SELECT * FROM utilitycontent WHERE location='"+location+"' AND num="+num);
		if (db.rs.next()) {
			populate(db.rs);
		} else {
			setDefaults();
		}
	}

	/**
	 * Delete the current db record and reset instance values to defaults.
	 */
	protected void delete(DB db) throws SQLException {
		db.executeUpdate("DELETE FROM utilitycontent WHERE utilitycontent_id="+utilitycontent_id);
		setDefaults();
	}

	/**
	 * Set default values when instance does not correspond to a database record (such as after delete() is called
	 */
	protected void setDefaults() {
		utilitycontent_id = 0;
		location = '\0';
		num = 0;
		copy = null;
		created = null;
		updated = null;
		modulecontext = null;
		moduleurl = null;
		moduleabove = false;
		showhome = false;
		showinside = false;
		showmobile = false;
	}

	/**
	 * Return true if this is a default, uninstantiated instance
	 */
	public boolean isDefault() {
		return utilitycontent_id==0;
	}

	/**
	 * Insert an audit record for the given action
	 */
	protected void audit(DB db, char action, String username) throws SQLException {
		Audit a = new Audit();
		a.tablename = tablename;
		a.record_id = utilitycontent_id;
		a.action = action;
		a.username = username;
		a.description = location+":"+num;
		a.insert(db);
	}

	/**
	 * Comparator for sorting, based on num if same location
	 */
	public int compareTo(Object o) {
		UtilityContent that = (UtilityContent)o;
		if (this.location==that.location) {
			return this.num - that.num;
		} else {
			return 0;
		}
	}

	/**
	 * Return true if same primary key
	 */
	public boolean equals(Object o) {
		UtilityContent that = (UtilityContent) o;
		return this.utilitycontent_id==that.utilitycontent_id;
	}

	/**
	 * Return an array of utilitycontent in a given location, sorted by increasing num
	 */
	static UtilityContent[] getByLocation(DB db, char location) throws SQLException {
		TreeSet<UtilityContent> set = new TreeSet<UtilityContent>();
		db.executeQuery("SELECT * FROM utilitycontent WHERE location='"+location+"'");
		while (db.rs.next()) set.add(new UtilityContent(db.rs));
		return set.toArray(new UtilityContent[0]);
	}
	/**
	 * Return an array of utilitycontent in a given location, sorted by increasing num
	 */
	public static UtilityContent[] getByLocation(ServletContext context, char location) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context);
			return getByLocation(db, location);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Return an array of utilitycontent for the home page, in the given location, sorted by increasing num
	 */
	static UtilityContent[] getHome(DB db, char location) throws SQLException {
		TreeSet<UtilityContent> set = new TreeSet<UtilityContent>();
		db.executeQuery("SELECT * FROM utilitycontent WHERE location='"+location+"' AND showhome");
		while (db.rs.next()) set.add(new UtilityContent(db.rs));
		return set.toArray(new UtilityContent[0]);
	}
	/**
	 * Return an array of utilitycontent for the home page, in the given location, sorted by increasing num
	 */
	public static UtilityContent[] getHome(ServletContext context, char location) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context);
			return getHome(db, location);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Return an array of utilitycontent for the inside page, in the given location, sorted by increasing num
	 */
	static UtilityContent[] getInside(DB db, char location) throws SQLException {
		TreeSet<UtilityContent> set = new TreeSet<UtilityContent>();
		db.executeQuery("SELECT * FROM utilitycontent WHERE location='"+location+"' AND showinside");
		while (db.rs.next()) set.add(new UtilityContent(db.rs));
		return set.toArray(new UtilityContent[0]);
	}
	/**
	 * Return an array of utilitycontent for the inside page, in the given location, sorted by increasing num
	 */
	public static UtilityContent[] getInside(ServletContext context, char location) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
		DB db = null;
		try {
			db = new DB(context);
			return getInside(db, location);
		} finally {
			if (db!=null) db.close();
		}
	}

	/**
	 * Increment num for all records with given location; used when you want to insert a new record with num=1
	 */
	static void incrementByLocation(DB db, char location) throws SQLException, ValidationException {
		UtilityContent[] uc = getByLocation(db, location);
		// have to go in reverse order to avoid num collisions
		for (int i=uc.length-1; i>=0; i--) {
			uc[i].num++;
			uc[i].update(db);
		}
	}

	/**
	 * Return max value of num for given location.
	 */
	static int numMax(DB db, char location) throws SQLException {
		db.executeQuery("SELECT max(num) AS num FROM utilitycontent WHERE location='"+location+"'");
		db.rs.next();
		return db.rs.getInt("num");
	}

	/**
	 * Return the anchor style class for the given location.
	 */
	public static String getLinkClass(char location) {
		if (location=='H') {
			return "header";
		} else if (location=='Z') {
			return "sectionheader";
		} else if (location=='S') {
			return"subheader";
		} else if (location=='T' || location=='B') {
			return "sidebar";
		} else if (location=='F') {
			return "footer";
		} else {
			return "";
		}
	}

}
