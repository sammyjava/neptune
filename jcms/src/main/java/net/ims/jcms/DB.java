package net.ims.jcms;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.Properties;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.ServletContext;
import javax.sql.DataSource;

/**
 * Database object for use with JDBC connection pool.
 * If instantiated by a servlet, use the servlet-related
 * constructors, which require the existence of context parameters
 * in web.xml. If instantiated by an application, use the application
 * constructors, which require a properties file in the current directory.
 * Note that a Statement is used, rather than a PreparedStatment.  Since this
 * object tends to be used for many distinct statements during its lifetime,
 * it performs better by instantiating the Statement object once in the constructor.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class DB {

    // static definitions
    private static final String PROPERTIESFILE = "db.properties";
    private static final String DSKEY = "db.datasource";
    private static final String DRIVERKEY = "db.driver";
    private static final String URLKEY = "db.url";
    private static final String USERKEY = "db.user";
    private static final String PASSWORDKEY = "db.password";
    private static final String TYPEKEY = "db.type";

    // settings are stored in a Properties object
    private Properties properties;

    // DB Connection, Statement, ResultSet
    public DataSource ds;
    public ResultSet rs;
    public PreparedStatement ps;
    private Connection conn;
    private Statement stmt;

    // database type, for database-specific methods
    public String dbtype = "pgsql";  // default

    /** servlet constructor - uses datasource name from servlet init parameters */
    public DB(ServletContext context) throws FileNotFoundException, NamingException, SQLException, ClassNotFoundException {
        getPropertiesFromServlet(context);
        makeConnection();
        if (properties.getProperty(TYPEKEY)!=null) dbtype = properties.getProperty(TYPEKEY);
    }

    /** servlet constructor - uses supplied user/password */
    public DB(ServletContext context, String user, String password) throws ClassNotFoundException, SQLException {
        getPropertiesFromServlet(context);
        makeConnection(user, password);
        if (properties.getProperty(TYPEKEY)!=null) dbtype = properties.getProperty(TYPEKEY);
    }

    /**
     * application constructor - uses datasource name and other parameters from properties file db.properties containing:
     *   db.driver
     *   db.url
     *   db.user
     *   db.password
     *   db.type [pgsql, mysql, MSSQL]
     */
    public DB() throws FileNotFoundException, IOException, ClassNotFoundException, SQLException {
        getPropertiesFromFile();
        makeConnection(properties.getProperty(USERKEY),properties.getProperty(PASSWORDKEY));
    }

    // load the properties from a properties file
    private void getPropertiesFromFile() throws FileNotFoundException, IOException {
        properties = new Properties();
        FileInputStream in = new FileInputStream(PROPERTIESFILE);
        properties.load(in);
        in.close();
    }

    // load the properties from the calling servlet's context parameters, only the datasource is required; set defaults where appropriate
    private void getPropertiesFromServlet(ServletContext context) {
        properties = new Properties();
        if (context.getInitParameter(DSKEY)!=null) properties.setProperty(DSKEY, context.getInitParameter(DSKEY));
        if (context.getInitParameter(DRIVERKEY)!=null) properties.setProperty(DRIVERKEY, context.getInitParameter(DRIVERKEY));
        if (context.getInitParameter(URLKEY)!=null) properties.setProperty(URLKEY, context.getInitParameter(URLKEY));
        if (context.getInitParameter(USERKEY)!=null) properties.setProperty(USERKEY, context.getInitParameter(USERKEY));
        if (context.getInitParameter(PASSWORDKEY)!=null) properties.setProperty(PASSWORDKEY, context.getInitParameter(PASSWORDKEY));
        if (context.getInitParameter(TYPEKEY)!=null) properties.setProperty(TYPEKEY, context.getInitParameter(TYPEKEY));
    }

    // make the db connection using servlet context JNDI resource; otherwise make it directly using driver, url, username and password
    private void makeConnection() throws NamingException, SQLException, ClassNotFoundException {
        String dsName = properties.getProperty(DSKEY);
        String driverName = properties.getProperty(DRIVERKEY);
        String url = properties.getProperty(URLKEY);
        String username = properties.getProperty(USERKEY);
        String password = properties.getProperty(PASSWORDKEY);
        if (driverName!=null && url!=null && username!=null && password!=null) {
            // get connection from explicit url, username, password values
            Class.forName(driverName);
            conn = DriverManager.getConnection(url, username, password);
            stmt = conn.createStatement();
        } else if (dsName!=null) {
            // get connection from JNDI context parameters
            InitialContext ic = new InitialContext();
            ds = (DataSource)ic.lookup(dsName);
            conn =  ds.getConnection();
            stmt = conn.createStatement();
        }
    }

    // make the db connection using the supplied user and password
    private void makeConnection(String user, String password) throws ClassNotFoundException, SQLException {
        String driverName = properties.getProperty(DRIVERKEY);
        String url = properties.getProperty(URLKEY);
        Class.forName(driverName);
        conn = DriverManager.getConnection(url, user, password);
        stmt = conn.createStatement();
    }

    // execute a query which returns a ResultSet (SELECT)
    public void executeQuery(String query) throws SQLException {
        rs = stmt.executeQuery(query);
    }

    // execute a query which does not return a ResultSet (INSERT/UPDATE/DELETE)
    public void executeUpdate(String query) throws SQLException {
        stmt.executeUpdate(query);
    }

    // get a prepared statement
    public void prepareStatement(String s) throws SQLException {
        ps = conn.prepareStatement(s);
    }

    // execute a prepared statement update query
    public void executeUpdate() throws SQLException {
        ps.executeUpdate();
    }

    // Close the connections // , and set = null so they aren't closed again
    public void close() throws SQLException {
        if (rs!=null) rs.close();
        if (ps!=null) ps.close();
        if (stmt!=null) stmt.close();
        if (conn!=null) conn.close();
    }

    // convenience routine to return an empty string if null, otherwise the string
    public String getStringOrBlank(String fieldname) throws SQLException {
        if (rs.getString(fieldname)==null) {
            return "";
        } else {
            return rs.getString(fieldname);
        }
    }

    // convenience routine to return an empty string if 0, otherwise the int
    public String getIntOrBlank(String fieldname) throws SQLException {
        if (rs.getInt(fieldname)==0) {
            return "";
        } else {
            return ""+rs.getInt(fieldname);
        }
    }

    // returns the timezone from the database
    public String getTimeZone() throws SQLException {
        String timezone = "US/Central"; // default, could be wrong
        if (dbtype.equals("pgsql")) {
            // time zones in timestamps only supported for postgresql so far
            executeQuery("SHOW TimeZone");
            if (rs.next()) timezone = rs.getString("TimeZone");
        } else if (dbtype.equals("mysql")) {
            // get system time zone, mysql doesn't store time zone with timestamps; this is in CDT format
            executeQuery("SELECT @@system_time_zone");
            if (rs.next()) timezone = rs.getString("@@system_time_zone");
        }
        return timezone;
    }

    // returns the timezone from the database, static version
    public static String getTimeZone(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
        DB db = null;
        try {
            db = new DB(context);
            return db.getTimeZone();
        } finally {
            if (db!=null) db.close();
        }
    }

    // returns the current time from the database
    public Timestamp getCurrentTimestamp() throws SQLException {
        executeQuery("SELECT "+now()+" AS now");
        rs.next();
        return rs.getTimestamp("now");
    }

    // returns the current time from the database
    public static Timestamp getCurrentTimestamp(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
        DB db = null;
        try {
            db = new DB(context);
            return db.getCurrentTimestamp();
        } finally {
            if (db!=null) db.close();
        }
    }

    // returns the database-specific current-time function
    public String now() {
        if (dbtype.equals("pgsql") || dbtype.equals("mysql")) {
            return "CURRENT_TIMESTAMP";
        } else if (dbtype.equals("MSSQL")) {
            return "getdate()";
        } else {
            return null;
        }
    }

    // returns the database-specific case-independent LIKE operator
    public String iLike() {
        if (dbtype.equals("pgsql")) {
            return "ILIKE";
        } else if (dbtype.equals("MSSQL") || dbtype.equals("mysql")) {
            return "LIKE";
        } else {
            return "LIKE";
        }
    }

    // returns the database-specific boolean value; assume mysql uses tinyint(1)=bool=boolean
    public String bool(boolean val) {
        if (dbtype.equals("pgsql")) {
            if (val) return "true"; else return "false";
        } else if (dbtype.equals("MSSQL") || dbtype.equals("mysql")) {
            if (val) return "1"; else return "0";
        } else {
            return ""+val;
        }
    }

    // returns the name of the database
    public String getDBName() throws SQLException {
        String dbName = null;
        if (dbtype.equals("pgsql")) {
            executeQuery("SELECT current_database() AS db_name");
            if (rs.next()) dbName = rs.getString("db_name");
        } else if (dbtype.equals("mysql")) {
            executeQuery("SELECT DATABASE() AS db_name");
            if (rs.next()) dbName = rs.getString("db_name");
        } else if (dbtype.equals("MSSQL")) {
            executeQuery("SELECT DB_NAME() AS db_name");
            if (rs.next()) dbName = rs.getString("db_name");
        }
        return dbName;
    }

    // returns the version of the database server
    public String getDBVersion() throws SQLException {
        String dbVersion = null;
        if (dbtype.equals("pgsql") || dbtype.equals("mysql")) {
            executeQuery("SELECT version() AS version");
            if (rs.next()) dbVersion = rs.getString("version");
        } else if (dbtype.equals("MSSQL")) {
            executeQuery("SELECT @@VERSION AS version");
            if (rs.next()) dbVersion = rs.getString("version");
        }
        return dbVersion;
    }

    // returns true if this is a jcms-bootstrap database
    // NOTE: only supported for PostgreSQL so far
    public boolean isBS() throws SQLException {
        if (dbtype.equals("pgsql")) {
            executeQuery("SELECT exists (SELECT 1 FROM information_schema.tables WHERE table_schema='public' AND table_name='bspages_content')");
            rs.next();
            return rs.getBoolean("exists");
        } else {
            return false;
        }
    }

}
