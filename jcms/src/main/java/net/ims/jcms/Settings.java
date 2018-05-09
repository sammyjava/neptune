package net.ims.jcms;

import java.io.FileNotFoundException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Hashtable;
import javax.naming.NamingException;
import javax.servlet.ServletContext;

/**
 * Extents Hashtable to contain all Settings table records with methods to draw String, int and boolean values. 
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class Settings extends Hashtable<String,String> {

  public Settings(ServletContext context) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    super();
    DB db = null;
    try {
      db = new DB(context);
      db.executeQuery("SELECT setting_name,setting_value FROM settings ORDER BY setting_name");
      while (db.rs.next()) {
	this.put(db.rs.getString("setting_name"), db.rs.getString("setting_value").trim());
      }
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return a String value
   */
  public String getString(String name) {
    return (String)get(name).trim();
  }

  /**
   * Return an int value
   */
  public int getInt(String name) {
    String s = getString(name);
    if (s!=null && s.length()>0) {
      return Integer.parseInt(s);
    } else {
      return 0;
    }
  }

  /**
   * Return a boolean value
   */
  public boolean getBoolean(String name) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
    String s = getString(name);
    if (s!=null && s.length()>0) {
      return s.equals("true");
    } else {
      return false;
    }
  }

}

