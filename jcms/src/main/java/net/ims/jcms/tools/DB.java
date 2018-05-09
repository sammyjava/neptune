package net.ims.jcms.tools;

import java.sql.*;
import java.util.*;
import java.io.*;
import javax.sql.*;
import javax.naming.*;

/**
 * Database object for use with jcms tools routines - uses properties file constructor.
 *
 * @author Sam Hokin <sam@ims.net>
 * @version 0.01
 */
public class DB {

  // static definitions
  private static final String DSKEY = "db.datasource";
  private static final String DRIVERKEY = "db.driver";
  private static final String URLKEY = "db.url";
  private static final String USERKEY = "db.user";
  private static final String PASSWORDKEY = "db.password";

  // settings are stored in a Properties object
  private Properties properties;

  // DB Connection, Statement, ResultSet
  public DataSource ds;
  public ResultSet rs;
  public PreparedStatement ps;
  private Connection conn;
  private Statement stmt;

  // application constructor - uses datasource name from properties file
  public DB(String propertiesFile) throws FileNotFoundException, IOException, ClassNotFoundException, SQLException {
    getPropertiesFromFile(propertiesFile);
    makeConnection(properties.getProperty(USERKEY),properties.getProperty(PASSWORDKEY));
  }

  // load the properties from a properties file
  private void getPropertiesFromFile(String propertiesFile) throws FileNotFoundException, IOException {
    properties = new Properties();
    FileInputStream in = new FileInputStream(propertiesFile);
    properties.load(in);
    in.close();
  }

  // make the db connection using servlet context JNDI resource; otherwise make it directly using driver, url, username and password
  private void makeConnection() throws NamingException, SQLException, ClassNotFoundException {
    String dsName = properties.getProperty(DSKEY);
    String driverName = properties.getProperty(DRIVERKEY);
    String url = properties.getProperty(URLKEY);
    String username = properties.getProperty(USERKEY);
    String password = properties.getProperty(PASSWORDKEY);
    if (dsName!=null) {
      InitialContext ic = new InitialContext();
      ds = (DataSource)ic.lookup(dsName);
      conn =  ds.getConnection();
      stmt = conn.createStatement();
    } else if (driverName!=null && url!=null && username!=null && password!=null) {
      Class.forName(driverName);
      conn = DriverManager.getConnection(url, username, password);
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

  // Close the connections
  public void close() throws SQLException {
    if (rs!=null) rs.close();
    if (ps!=null) ps.close();
    if (stmt!=null) stmt.close();
    if (conn!=null) conn.close();
  }

}
