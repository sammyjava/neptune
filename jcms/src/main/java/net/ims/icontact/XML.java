package net.ims.icontact;

import java.util.Date;
import java.util.Enumeration;
import java.util.Vector;
import java.text.SimpleDateFormat;
import java.text.ParseException;

/**
 * A class containing a StringBuffer which embodies an iContact XML block containing a single resource, with handy methods for adding and extracting data.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class XML {
  
  private StringBuffer xml;

  // ISO 8601 date (with time zone)
  public static SimpleDateFormat ISO8601FORMAT = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ssZ");

  // plain datetime (without time zone)
  public static SimpleDateFormat DATEFORMAT = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

  /**
   * Instantiate a new, empty XML block
   */
  public XML() {
    xml = new StringBuffer();
  }

  /**
   * Instantate a populated XML instance with the given data
   */
  public XML(StringBuffer data) {
    xml = new StringBuffer(data);
  }

  /**
   * Instantate a populated XML instance with the given data
   */
  public XML(String data) {
    xml = new StringBuffer(data);
  }

  /**
   * Return the xml StringBuffer data as a String
   */
  public String toString() {
    return new String(xml);
  }

  /**
   * Append the given string
   */
  public void append(String data) {
    xml.append(data);
  }

  /**
   * Prepend the given string
   */
  public void prepend(String data) {
    xml.insert(0, data);
  }

  /**
   * Append the opening resource tag
   */
  public void openResource(String resource) {
    append("<");
    append(resource);
    append(">");
    append("\n");
  }

  /**
   * Append the closing resource tag
   */
  public void closeResource(String resource) {
    append("</");
    append(resource);
    append(">");
    append("\n");
  }

  /**
   * Append the given entity and string value, if value is not null.
   */
  public void appendString(String entity, String value) {
    if (value!=null) {
      append("  ");
      append("<"+entity+">");
      append(value);
      append("</"+entity+">");
      append("\n");
    }
  }

  /**
   * Append the given entity and int value, if value is not 0.
   */
  public void appendInt(String entity, int value) {
    if (value!=0) appendString(entity, String.valueOf(value));
  }

  /**
   * Append the given entity and boolean value
   */
  public void appendBoolean(String entity, boolean value) {
    if (value) {
      appendInt(entity, 1);
    } else {
      appendInt(entity, 0);
    }
  }

  /**
   * Append the given entity and Date value in plain date format, if value is not null.
   */
  public void appendDate(String entity, Date value) {
    if (value!=null) {
      append("  ");
      append("<"+entity+">");
      append(DATEFORMAT.format(value));
      append("</"+entity+">");
      append("\n");
    }
  }

  /**
   * Append the given entity and Date value in ISO8601 format, if value is not null.
   */
  public void appendISODate(String entity, Date value) {
    if (value!=null) {
      append("  ");
      append("<"+entity+">");
      String s = ISO8601FORMAT.format(value);
      s = s.replace("-0400", "-04:00");
      s = s.replace("-0500", "-05:00");
      append(s);
      append("</"+entity+">");
      append("\n");
    }
  }

  /**
   * Parse out the given entity, returning a string, or null if not present.
   */
  public String getString(String entity) {
    String xmlString = new String(xml);
    if (xmlString.contains("<"+entity+">")) {
      int i = xml.indexOf("<"+entity+">");
      int j = xml.indexOf("</"+entity+">");
      int offset = entity.length() + 2;
      return xml.substring(i+offset,j);
    } else {
      return  null;
    }
  }

  /**
   * Parse out the given entity, returning an int, or 0 if not present.
   */
  public int getInt(String entity) {
    String s = getString(entity);
    if (s==null) {
      return 0;
    } else {
      return Integer.parseInt(s);
    }
  }

  /**
   * Parse out the given entity, returning a double, or 0.0 if not present.
   */
  public double getDouble(String entity) {
    String s = getString(entity);
    if (s==null) {
      return 0.0;
    } else {
      return Double.parseDouble(s);
    }
  }

  /**
   * Parse out the given entity, returning a boolean, or false if not present.
   */
  public boolean getBoolean(String entity) {
    int i = getInt(entity);
    return (i==1);
  }

  /**
   * Parse out the given entity, returning a Date, or null if not present.
   */
  public Date getDate(String entity) throws ParseException {
    String s = getString(entity);
    if (s==null) {
      return null;
    } else {
      return DATEFORMAT.parse(s);
    }
  }

  /**
   * Parse out the given entity, returning a Date, or null if not present.
   */
  public Date getISODate(String entity) throws ParseException {
    String s = getString(entity);
    if (s==null) {
      return null;
    } else {
      // deal with colon in EST or EDT time
      s = s.replace("-04:00","-0400");
      s = s.replace("-05:00","-0500");
      return ISO8601FORMAT.parse(s);
    }
  }

  /**
   * Parse and concatenate warnings contained in a <warnings> block
   */
  public String getWarnings() throws ParseException {
    String xmlString = new String(xml);
    if (xmlString.contains("<warnings>")) {
      StringBuffer warnings = new StringBuffer();
      int offset = 9;
      int i = 0;
      int j = 0;
      while (i!=-1) {
	i = xml.indexOf("<warning>", j);
	j = xml.indexOf("</warning>", i);
	if (i>0 && j>0 && j>i) warnings.append(xml.substring(i+offset,j)+"\n");
      }
      return warnings.toString();
    } else {
      return null;
    }
  }

  /**
   * Parse out XML chunks for individual resources within an XML container
   */
  public static XML[] getChunks(XML response, String pluralTag, String singleTag) throws ParseException {
    String responseString = response.toString();
    if (responseString.contains("<"+pluralTag+">")) {
      String openTag = "<"+singleTag+">";
      String closeTag = "</"+singleTag+">";
      Vector<String> chunkVector = new Vector<String>();
      int offset = openTag.length();
      int i = 0;
      int j = 0;
      while (i!=-1) {
	i = responseString.indexOf(openTag, j);
	j = responseString.indexOf(closeTag, i);
	if (i>0 && j>0 && j>i) chunkVector.add(responseString.substring(i+offset,j));
      }
      int n = chunkVector.size();
      XML[] chunks = new XML[n];
      int l = 0;
      for (Enumeration e = chunkVector.elements(); e.hasMoreElements();) {
	chunks[l++] = new XML((String)(e.nextElement()));
      }
      return chunks;
    } else {
      return new XML[0];
    }
  }

}
