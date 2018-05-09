package net.ims.jcms.tools;

import net.ims.jcms.Util;
import java.sql.*;

/**
 * Import jcms data from one database to another.  This is particularly useful when the source or target database is on a different RDBMS.
 * Application 1: SQL Server to PostgreSQL.
 *
 * Requires:
 * - files source.properties and target.properties to establish the database connections to the source and target databases.
 *
 * @author Sam Hokin <sam@ims.net>
 * @version 0.1
 */
public class DataImporter {

  // source database connection
  static DB sourceDB = null;

  // target database connection
  static DB targetDB = null;

  // primary tables - these have no foreign keys and must be imported first
  static String primaryTables[] = {"accessroles", "accessusers", "content", "extensions", "extras", "forms", "imagerotator",
			    "layouts", "media", "nodes", "photosets", "settings", "stylesheetcategories", "updatelog", "users", "utilitylinks" };

  // secondary tables - these contain a foreign key to a primary table and must be imported second
  static String secondaryTables[] = {"accessroles_accessusers", "accessroles_media", "accessroles_nodes", "comments",
			      "formfields", "formlyrislists", "postedforms", "layoutpanes", "pages", "photos", "stylesheet", 
			      "users_extensions", "users_extras", "users_nodes"};

  // tertiary tables -  these contain a foreign key to a secondary table and must be imported third
  static String tertiaryTables[] = {"formfieldoptions", "postedformfields", "nodelinks", "pages_content"};

  // tables and primary keys for resetting sequences
  static String sequenceTables[] = {"accessroles", "accessusers", "comments", "content", "extensions",
				    "formfieldoptions", "formfields", "formlyrislists", "forms",
				    "imagerotator", "layoutpanes", "layouts", "media", "nodelinks", "nodes",
				    "pages", "photos", "photosets", "postedforms", "stylesheet", "users", "utilitylinks"};
  static String sequenceKeys[] = {"accessrole_id", "accessuser_id", "comment_id", "cid", "extid",
				  "formfieldoption_id", "formfield_id", "formlyrislist_id", "form_id",
				  "id", "layoutpane_id", "layout_id", "mid", "nlid", "nid",
				  "pid", "photo_id", "photoset_id", "postedform_id", "class_id", "uid", "utilitylink_id"};

  public static void main(String args[]) {

    try {

      // instantiate connections
      sourceDB = new DB("source.properties");
      targetDB = new DB("target.properties");

      // query the primary tables and insert data
      for (int i=0; i<primaryTables.length; i++) {
	System.out.println("-----------------------------------------------------------------------------------");
	System.out.println(primaryTables[i]);
	copyTable(primaryTables[i]);
      }

      // query the secondary tables and insert data
      for (int i=0; i<secondaryTables.length; i++) {
	System.out.println("-----------------------------------------------------------------------------------");
	System.out.println("+ "+secondaryTables[i]);
	copyTable(secondaryTables[i]);
      }

      // query the tertiary tables and insert data
      for (int i=0; i<tertiaryTables.length; i++) {
	System.out.println("-----------------------------------------------------------------------------------");
	System.out.println("++ "+tertiaryTables[i]);
	copyTable(tertiaryTables[i]);
      }

      // reset sequences
      for (int i=0; i<sequenceTables.length; i++) {
	System.out.println("-----------------------------------------------------------------------------------");
	System.out.println("SEQUENCE "+sequenceTables[i]+"_"+sequenceKeys[i]+"_seq");
	targetDB.executeQuery("SELECT max("+sequenceKeys[i]+") AS max FROM "+sequenceTables[i]);
	targetDB.rs.next();
	int max = targetDB.rs.getInt("max");
	if (max>0) {
	  String query = "SELECT setval('"+sequenceTables[i]+"_"+sequenceKeys[i]+"_seq',"+max+",true)";
	  try {
	    targetDB.executeQuery(query);
	  } catch (Exception ex) {
	    System.out.println(ex.toString());
	    System.out.println(query);
	  }
	}
      }

      // close connections
      sourceDB.close();
      targetDB.close();

    } catch (Exception ex) {

      System.err.println(ex.toString());

    }

  }

  /**
   * Copy the input table from the source database to the target database.
   */
  static void copyTable(String table) throws SQLException {

    // query the table
    sourceDB.executeQuery("SELECT * FROM "+table);

    // get the metadata
    ResultSetMetaData sourceMD = sourceDB.rs.getMetaData();
    int sourceColumns = sourceMD.getColumnCount();

    // loop over the records
    while (sourceDB.rs.next()) {

      // build the INSERT query for this record
      String query = "INSERT INTO "+table+" VALUES (";
      for (int col=1; col<=sourceColumns; col++) {
	if (col>1) query += ",";
	if (sourceMD.getColumnName(col).equals("refid")) {
	  query += "DEFAULT";
	} else if (isInteger(sourceMD.getColumnType(col))) {
	  int val = sourceDB.rs.getInt(col);
	  if (sourceDB.rs.wasNull()) {
	    query += "NULL";
	  } else {
	    query += val;
	  }
	} else if (isString(sourceMD.getColumnType(col))) {
	  String val = sourceDB.rs.getString(col);
	  if (sourceDB.rs.wasNull()) {
	    query += "NULL";
	  } else {
	    query += "'"+Util.escapeQuotes(val)+"'";
	  }
	} else if (isBoolean(sourceMD.getColumnType(col))) {
	  boolean val = sourceDB.rs.getBoolean(col);
	  if (sourceDB.rs.wasNull()) {
	    query += "NULL";
	  } else {
	    query += val;
	  }
	} else if (isTimestamp(sourceMD.getColumnType(col))) {
	  Timestamp val = sourceDB.rs.getTimestamp(col);
	  if (sourceDB.rs.wasNull()) {
	    query += "NULL";
	  } else {
	    query += "'"+val+"'";
	  }
	} else {
	  throw new SQLException("Data type "+sourceMD.getColumnType(col)+" ("+sourceMD.getColumnTypeName(col)+") is not supported.");
	}
      }
      query += ")";

      // run the INSERT query against the target database; continue past errors
      try {
	targetDB.executeUpdate(query);
      } catch (Exception ex) {
	System.out.println(ex.toString());
	System.out.println(query);
      }

    }

  }

  /**
   * Return true if provided JDBC type is an integer
   */
  static boolean isInteger(int type) {
    return (type==Types.INTEGER || type==Types.BIGINT);
  }

  /**
   * Return true if provided JDBC type is some sort of string
   */
  static boolean isString(int type) {
    return (type==Types.VARCHAR || type==Types.CHAR || type==Types.CLOB);
  }

  /**
   * Return true if provided JDBC type is some sort of boolean
   */
  static boolean isBoolean(int type) {
    return (type==Types.BIT || type==Types.BOOLEAN);
  }

  /**
   * Return true if provided JDBC type is some sort of timestamp
   */
  static boolean isTimestamp(int type) {
    return (type==Types.TIMESTAMP);
  }

}



