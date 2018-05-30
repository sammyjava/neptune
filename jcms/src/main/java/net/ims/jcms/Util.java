package net.ims.jcms;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.StringReader;
import java.net.URL;
import java.sql.Date;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.Random;
import java.util.TreeSet;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import javax.json.Json;
import javax.json.JsonObject;
import javax.json.JsonReader;
import javax.naming.Context;
import javax.naming.NamingException;
import javax.naming.directory.InitialDirContext;
import javax.net.ssl.HttpsURLConnection;
import javax.servlet.ServletContext;
import javax.servlet.ServletRequest;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.commons.lang.time.DateUtils;

import com.oreilly.servlet.MultipartRequest;

import nl.captcha.Captcha; // SimpleCaptcha

import net.tanesha.recaptcha.ReCaptcha;
import net.tanesha.recaptcha.ReCaptchaFactory;
import net.tanesha.recaptcha.ReCaptchaImpl;
import net.tanesha.recaptcha.ReCaptchaResponse;

/**
 * Collection of static utility variables and methods for text handling, etc.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class Util {

    // this string appears in the meta generator tag
    public static final String APPVERSION = "IMS Neptune CMS v1.0";

    // the API key for Constant Contact
    public static final String CC_API_KEY = "eacbe6a9-9357-4461-96fe-36088598b5e1";

    // default AccessUser, AccessRole classes
    public static String DEFAULTACCESSUSERCLASS = "net.ims.jcms.extras.JcmsAccessUser";
    public static String DEFAULTACCESSROLECLASS = "net.ims.jcms.extras.JcmsAccessRole";

    // default control panel User class
    public static String DEFAULTUSERCLASS = "net.ims.jcms.extras.JcmsUser";

    // context parameters for LDAP authentication
    private static String INITIAL_CONTEXT_FACTORY = "ldap.initialcontextfactory";
    private static String PROVIDER_URL = "ldap.providerurl";
    private static String SECURITY_AUTHENTICATION = "ldap.securityauthentication";
    private static String SECURITY_PROTOCOL = "ldap.securityprotocol";
    private static String SECURITY_PRINCIPAL = "ldap.securityprincipal";
    private static String SECURITY_CREDENTIALS = "ldap.securitycredentials";

    // Google Recaptcha stuff
    public static final String GOOGLE_RECAPTCHA_URL = "https://www.google.com/recaptcha/api/siteverify";
    private final static String USER_AGENT = "Mozilla/5.0";


    /**
     * Return blank if the input string is null, otherwise return the input string.
     * @param s a string
     * @return an empty string if s is null, otherwise return s
     */
    public static String blankIfNull(String s) {
        if (s==null) {
            return "";
        } else {
            return s;
        }
    }

    /**
     * Return blank string if the input object is null, otherwise return the string version
     * @param o an object
     * @return an empty string if o is null, otherwise return o.toString()
     */
    public static String blankIfNull(Object o) {
        if (o==null) {
            return "";
        } else {
            return o.toString();
        }
    }

    /**
     * Return blank if the posted variable is null, otherwise return the posted string.
     * @param request a ServletRequest
     * @param s a string
     * @return an empty string if s is null, otherwise return s
     */
    public static String blankIfNull(ServletRequest request, String s) {
        if (request.getParameter(s)==null) {
            return "";
        } else {
            return request.getParameter(s);
        }
    }

    /**
     * Return 0 if the input string is null; otherwise return the int value.  Throws NumberFormatException if not a number.
     * @param s is a String
     * @return 0 if s is null or doesn't parse to an integer, else the int value of s
     */
    public static int zeroIfNull(String s) throws NumberFormatException {
        if (s==null) {
            return 0;
        } else {
            int i = Integer.parseInt(s);
            return i;
        }
    }

    /**
     * Return blank if the input int is zero, otherwise return the input int as a string.
     * @param i an int
     * @return an empty string if i is zero, otherwise return i as a string
     */
    public static String blankIfZero(int i) {
        if (i==0) {
            return "";
        } else {
            return ""+i;
        }
    }

    /**
     * Return blank if the input double is zero, otherwise return the input int as a string.
     * @param d a double
     * @return an empty string if d is zero, otherwise return d as a string
     */
    public static String blankIfZero(double d) {
        if (d==0.00) {
            return "";
        } else {
            return ""+d;
        }
    }

    /**
     * Convert a byte to a two-char hex string
     * @param b a byte
     * @return a two-character hex string
     */
    public static String byteToHex(byte b) {
        String hex = Integer.toHexString(b & 0xFF).toUpperCase();
        if (hex.length()==1) hex = "0"+hex;
        return hex;
    }

    /**
     * Convert a hex string to a byte
     * @param hex a one- or two-character hex string
     * @return a byte value
     */
    public static byte hexToByte(String hex) {
        return (byte)Integer.parseInt(hex,16);
    }

    /**
     * Escape quotes for use in SQL statements, as well as backslashes
     */
    public static String escapeQuotes(String str) {
        String fixed = str;
        fixed = fixed.replace("'", "''");
        fixed = fixed.replace("\\", "\\\\");
        return fixed;
    }

    /**
     * Return NULL in the case of empty or null strings, quoted string otherwise
     */
    public static String charsOrNull(String str) {
        if (str==null || str.trim().length()==0 || str.trim().equals("null")) {
            return "NULL";
        } else {
            return "'"+escapeQuotes(utfToHtml(str.trim()))+"'";
        }
    }

    /**
     * Return quoted empty string if empty or null string, quoted string otherwise
     */
    public static String charsOrEmpty(String str) {
        if (str==null || str.trim().length()==0 || str.trim().equals("null")) {
            return "''";
        } else {
            return "'"+escapeQuotes(utfToHtml(str.trim()))+"'";
        }
    }

    /**
     * Return NULL in the case of empty char
     */
    public static String charOrNull(char c) {
        if (c=='\0') {
            return "NULL";
        } else {
            return "'"+c+"'";
        }
    }

    /**
     * Return a quoted fixed-quotes string or DEFAULT if it's empty or "null".
     */
    public static String charsOrDefault(String str) {
        if (str==null || str.trim().length()==0 || str.trim().equals("null")) {
            return "DEFAULT";
        } else {
            return "'"+escapeQuotes(utfToHtml(str.trim()))+"'";
        }
    }

    /**
     * Return a quoted fixed-quotes timestamp string or DEFAULT if it's null
     */
    public static String charsOrDefault(Timestamp t) {
        if (t==null) {
            return "DEFAULT";
        } else {
            return "'"+t.toString()+"'";
        }
    }

    /**
     * Return a quoted fixed-quotes timestamp string or NULL if it's null
     */
    public static String charsOrNull(Timestamp t) {
        if (t==null) {
            return "NULL";
        } else {
            return "'"+t.toString()+"'";
        }
    }

    /**
     * Return a quoted fixed-quotes date string or NULL if it's null
     */
    public static String charsOrNull(Date d) {
        if (d==null) {
            return "NULL";
        } else {
            return "'"+d.toString()+"'";
        }
    }

    /**
     * Return NULL in the case of zero, argument otherwise
     */
    public static String intOrNull(int i) {
        if (i==0) {
            return "NULL";
        } else {
            return ""+i;
        }
    }

    /**
     * Return DEFAULT in the case of zero, argument otherwise
     */
    public static String intOrDefault(int i) {
        if (i==0) {
            return "DEFAULT";
        } else {
            return ""+i;
        }
    }

    /**
     * Return NULL in the case of zero, argument otherwise
     */
    public static String longOrNull(long i) {
        if (i==0) {
            return "NULL";
        } else {
            return ""+i;
        }
    }

    /**
     * Return DEFAULT in the case of zero, argument otherwise
     */
    public static String longOrDefault(long i) {
        if (i==0) {
            return "DEFAULT";
        } else {
            return ""+i;
        }
    }

    /**
     * Return NULL in the case of zero, argument otherwise
     */
    public static String doubleOrNull(double d) {
        if (d==0.00) {
            return "NULL";
        } else {
            return ""+d;
        }
    }

    /**
     * Return DEFAULT in the case of zero, argument otherwise
     */
    public static String doubleOrDefault(double d) {
        if (d==0.00) {
            return "DEFAULT";
        } else {
            return ""+d;
        }
    }

    /**
     * Return true if "true" or "t", false otherwise
     */
    public static String toBoolean(String str) {
        if (str!=null && (str.equals("true") || str.equals("t"))) {
            return "true";
        } else {
            return "false";
        }
    }

    /**
     * Return true if string is null or empty (can be just spaces)
     */
    public static boolean nullOrEmpty(String s) {
        return (s==null || s.trim().length()==0);
    }

    /**
     * Format a double into a money string for the US.
     * Easily tweaked to support localization when we get into that.
     */
    public static String formatMoney(double amount) {
        DecimalFormat money = new DecimalFormat("$###,##0.00");
        return money.format(amount);
    }

    /**
     * Format a double into a currency string for the US, without the $ sign or comma.
     * Easily tweaked to support localization when we get into that.
     */
    public static String formatCents(double amount) {
        DecimalFormat money = new DecimalFormat("#####0.00");
        return money.format(amount);
    }

    /**
     * Substitute HTML entities for high UTF-8 (Windows ASCII 128-159) characters.
     * This should be used for text input from HTTP POST.
     */
    public static String utfToHtml(String utf) {
        if (utf==null) {
            return null;
        } else {
            String html = "";
            for (int i=0; i<utf.length(); i++) {
                int cp1 = utf.codePointAt(i);
                int cp2 = 0;
                int cp3 = 0;
                if (cp1==226) {
                    cp2 = utf.codePointAt(++i);
                    cp3 = utf.codePointAt(++i);
                }
                // Windows 128-159 replacements
                if (cp3==147) {
                    html += "&ndash;";
                } else if (cp3==148) {
                    html += "&mdash;";
                } else if (cp3==152) {
                    html += "&lsquo;";
                } else if (cp3==153) {
                    html += "&rsquo;";
                } else if (cp3==156) {
                    html += "&ldquo;";
                } else if (cp3==157) {
                    html += "&rdquo;";
                } else {
                    html += utf.charAt(i);
                }
            }
            return html;
        }
    }

    /**
     * Substitute HTML entities for Unicode coming from database tranlation.
     * This should be used for text output from a LATIN1 database like SQL Server, translated to unicode by the JDBC driver.
     */
    public static String unicodeToHtml(String unicode) {
        if (unicode==null) {
            return null;
        } else {
            String html = unicode;
            html = html.replaceAll("\u2013", "&ndash;");
            html = html.replaceAll("\u2014", "&mdash;");
            html = html.replaceAll("\u2018", "&lsquo;");
            html = html.replaceAll("\u2019", "&rsquo;");
            html = html.replaceAll("\u201c", "&ldquo;");
            html = html.replaceAll("\u201d", "&rdquo;");
            return html;
        }
    }

    /**
     * Determine whether a string is a valid CSS identifier. From the CSS spec:
     * In CSS, identifiers (including element names, classes, and IDs in selectors) can contain only the characters [a-zA-Z0-9]
     * and ISO 10646 characters U+00A0 and higher, plus the hyphen (-) and the underscore (_); they cannot start with a digit,
     * two hyphens, or a hyphen followed by a digit. Identifiers can also contain escaped characters and any ISO 10646 character
     * as a numeric code (see next item). For instance, the identifier "B&W?" may be written as "B\&W\?" or "B\26 W\3F".
     * But to simplify things, this validator only allows [a-zA-Z0-9] plus hyphen and underscore; must start with a letter.
     */
    public static boolean isValidCSSIdentifier(String s) {
        // doh
        if (s==null || s.length()==0) return false;
        // leading or trailing spaces are fine
        s = s.trim();
        // starts with a letter?
        if (!Character.isLetter(s.charAt(0))) return false;
        // contains non-letter or hyphen or underscore?
        for (int i=0; i<s.length(); i++) {
            if (!Character.isLetter(s.charAt(i)) && !Character.isDigit(s.charAt(i)) && s.charAt(i)!='-' && s.charAt(i)!='_') return false;
        }
        // we're good!
        return true;
    }

    /** 
     * Return a default AccessRole instance according to context parameter access.role.class, or the default class if parameter is not present.
     */
    public static AccessRole getDefaultAccessRole(ServletContext context) throws ClassNotFoundException, InstantiationException, IllegalAccessException {
        String accessRoleClassName = context.getInitParameter("access.role.class");
        if (accessRoleClassName==null) accessRoleClassName = DEFAULTACCESSROLECLASS;
        Class accessRoleClass = Class.forName(accessRoleClassName);
        return (AccessRole)accessRoleClass.newInstance();
    }

    /**
     * Return an array of all AccessRoles.
     */
    public static AccessRole[] getAllAccessRoles(ServletContext context) throws ClassNotFoundException, InstantiationException, IllegalAccessException, AccessRoleException {
        AccessRole ar = getDefaultAccessRole(context);
        return ar.getAll(context);
    }

    /** 
     * Return a default AccessUser instance according to context parameter access.role.class, or the default class if parameter is not present.
     */
    public static AccessUser getDefaultAccessUser(ServletContext context) throws ClassNotFoundException, InstantiationException, IllegalAccessException {
        String accessUserClassName = context.getInitParameter("access.user.class");
        if (accessUserClassName==null) accessUserClassName = DEFAULTACCESSUSERCLASS;
        Class accessUserClass = Class.forName(accessUserClassName);
        return (AccessUser)accessUserClass.newInstance();
    }

    /**
     * Return a specific AccessUser without a supplied password.
     */
    public static AccessUser getAccessUser(ServletContext context, String username) throws ClassNotFoundException, InstantiationException, IllegalAccessException, AccessUserException {
        return getDefaultAccessUser(context).getAccessUser(context, username);
    }

    /**
     * Return a specific AccessUser with a supplied password.
     */
    public static AccessUser getAccessUser(ServletContext context, String username, String password) throws ClassNotFoundException, InstantiationException, IllegalAccessException, AccessUserException {
        return getDefaultAccessUser(context).getAccessUser(context, username, password);
    }

    /**
     * Return an array of all AccessUsers.
     */
    public static AccessUser[] getAllAccessUsers(ServletContext context) throws ClassNotFoundException, InstantiationException, IllegalAccessException, AccessUserException {
        AccessUser au = getDefaultAccessUser(context);
        return au.getAll(context);
    }

    /**
     * Return an empty User instance according to context parameter user.class, or the default class if parameter is not present.
     */
    public static User getDefaultUser(ServletContext context) throws ClassNotFoundException, InstantiationException, IllegalAccessException, UserException {
        String userClassName = context.getInitParameter("user.class");
        if (userClassName==null) userClassName = DEFAULTUSERCLASS;
        Class userClass = Class.forName(userClassName);
        return (User)userClass.newInstance();
    }

    /** 
     * Return a User instance according to context parameter user.class, or the default class if parameter is not present.
     */
    public static User getUser(ServletContext context, String username, String password) throws ClassNotFoundException, InstantiationException, IllegalAccessException, UserException {
        return getDefaultUser(context).getUser(context, username, password);
    }

    /** 
     * Return a User instance according to context parameter user.class, or the default class if parameter is not present.
     */
    public static User getUser(ServletContext context, String username) throws ClassNotFoundException, InstantiationException, IllegalAccessException, UserException {
        return getDefaultUser(context).getUser(context, username);
    }

    /**
     * Return an array of all users using the user.class or default class.
     */
    public static User[] getAllUsers(ServletContext context) throws ClassNotFoundException, InstantiationException, IllegalAccessException, UserException {
        return getDefaultUser(context).getAllUsers(context);
    }

    /**
     * Load the appropriate LDAP parameters from the servlet context and initialize the LDAP directory context.
     */
    public static InitialDirContext getDirContext(ServletContext context) throws MissingParameterException, NamingException {

        String contextFactory = context.getInitParameter(INITIAL_CONTEXT_FACTORY);
        String providerUrl = context.getInitParameter(PROVIDER_URL);
        String securityAuthentication = context.getInitParameter(SECURITY_AUTHENTICATION);
        String securityProtocol = context.getInitParameter(SECURITY_PROTOCOL);
        String securityPrincipal = context.getInitParameter(SECURITY_PRINCIPAL);
        String securityCredentials = context.getInitParameter(SECURITY_CREDENTIALS);

        if (contextFactory==null || providerUrl==null || securityAuthentication==null || securityProtocol==null || securityPrincipal==null || securityCredentials==null) {
            throw new MissingParameterException("Some LDAP authentication parameters are missing in web.xml.  Please see LDAP usage doc for required context parameters.");
        }

        // initialize the directory context
        Hashtable<String,String> env = new Hashtable<String,String>();
        env.put(Context.INITIAL_CONTEXT_FACTORY, contextFactory);
        env.put(Context.PROVIDER_URL, providerUrl);
        env.put(Context.SECURITY_AUTHENTICATION, securityAuthentication);
        env.put(Context.SECURITY_PROTOCOL, securityProtocol);
        env.put(Context.SECURITY_PRINCIPAL, securityPrincipal);
        env.put(Context.SECURITY_CREDENTIALS, securityCredentials);
        return new InitialDirContext(env);

    }

    /**
     * Unescape HTML entities into Unicode.  Used for RSS feed or PDF generators.  NOTE: uses Apache Commons Lang package!
     */
    public static String unescapeHtml(String input) {
        if (input==null) {
            return null;
        } else {
            return StringEscapeUtils.unescapeHtml(input);
        }
    }

    /**
     * Strip out HTML tags.  Needed for legit RSS feeds.
     */
    public static String stripHtmlTags(String input) {
        if (input==null) {
            return null;
        } else {
            return input.replaceAll("\\<.*?\\>", "");
        }
    }

    /**
     * Escape all ampersand characters with the HTML equivalent.  This will break HTML escapes, but keeps RSS feeds valid.
     */
    public static String escapeAmp(String input) {
        if (input==null) {
            return null;
        } else {
            String output = input.replaceAll("&", "&amp;");
            output = output.replaceAll("<", "&lt;");
            output = output.replaceAll(">", "&gt;");
            return output;
        }
    }

    /**
     * Clean up string for RSS compliance, using the above methods.
     */
    public static String rssClean(String input) {
        if (input==null) {
            return null;
        } else {
            return Util.escapeAmp(Util.unescapeHtml(Util.stripHtmlTags(input)));
        }
    }

    /**
     * Form a valid href from the string; if it starts with 'http', leave it alone, otherwise prepend 'http://'.
     */
    public static String href(String url) {
        if (url==null) return null;
        if (url.toLowerCase().substring(0,4).equals("http")) return url;
        return "http://"+url;
    }

    // --------------------------------------------------------------------------------------------

    /**
     * Return an empty string if the parameter is null, otherwise the trimmed value of the parameter
     */
    static String getString(String value) {
        if (value==null) return "";
        return value.trim();
    }    
    public static String getString(HttpServletRequest request, String str) { return getString(request.getParameter(str)); }
    public static String getString(MultipartRequest request, String str) { return getString(request.getParameter(str)); }
    public static String getString(HttpSession session, String str) { return getString((String)session.getAttribute(str)); }

    /**
     * Parse the given string into an integer, else return 0 if null or not an int
     */
    static int getInt(String str) {
        if (str==null) return 0;
        try {
            return Integer.parseInt(str);
        } catch (NumberFormatException ex) {
            return 0;
        }
    }
    public static int getInt(HttpServletRequest request, String str) { return getInt(request.getParameter(str)); }
    public static int getInt(MultipartRequest request, String str) { return getInt(request.getParameter(str)); }
    public static int getInt(HttpSession session, String str) { return getInt((String)session.getAttribute(str)); }

    /**
     * Return the given string as a long, 0 if null or not parseable
     */
    static long getLong(String str) {
        if (str==null) return 0;
        try {
            return Long.parseLong(str);
        } catch (NumberFormatException ex) {
            return 0;
        }
    }
    public static long getLong(HttpServletRequest request, String str) { return getLong(request.getParameter(str)); }
    public static long getLong(MultipartRequest request, String str) { return getLong(request.getParameter(str)); }
    public static long getLong(HttpSession session, String str) { return getLong((String)session.getAttribute(str)); }

    /**
     * Parse the given string into an double, else return 0.00 if null or not a double
     */
    static double getDouble(String str) {
        if (str==null) return 0.00;
        try {
            return Double.parseDouble(str);
        } catch (NumberFormatException ex) {
            return 0.00;
        }
    }
    public static double getDouble(HttpServletRequest request, String str) { return getDouble(request.getParameter(str)); }
    public static double getDouble(MultipartRequest request, String str) { return getDouble(request.getParameter(str)); }
    public static double getDouble(HttpSession session, String str) { return getDouble((String)session.getAttribute(str)); }

    /**
     * Return the given string as a boolean, false if null or not equal to "true."
     */
    static boolean getBoolean(String str) {
        if (str==null) return false;
        return str.equals("true");
    }
    public static boolean getBoolean(HttpServletRequest request, String str) { return getBoolean(request.getParameter(str)); }
    public static boolean getBoolean(MultipartRequest request, String str) { return getBoolean(request.getParameter(str)); }
    public static boolean getBoolean(HttpSession session, String str) { return getBoolean((String)session.getAttribute(str)); }

    /**
     * Return the given string parameter as a Date, null if not present or not a JDBC date string
     */
    static Date getDate(String str) {
        if (str==null) return null;
        try {
            return Date.valueOf(str);
        } catch (Exception ex) {
            return null;
        }
    }
    public static Date getDate(HttpServletRequest request, String str) { return getDate(request.getParameter(str)); }
    public static Date getDate(MultipartRequest request, String str) { return getDate(request.getParameter(str)); }
    public static Date getDate(HttpSession session, String str) { return getDate((String)session.getAttribute(str)); }

    /**
     * Return the given string parameter as a Timestamp, null if not present; throw exception if not a parseable string.
     * Uses Apache DateUtils, which returns a java.util.Date, so then have to convert to java.sql.Timestamp.
     */
    static Timestamp getTimestamp(String str) throws ParseException {
        if (nullOrEmpty(str)) return null;
        String[] parsePatterns = {"yyyy-MM-dd", "yyyy-MM-dd HH:mm", "yyyy-MM-dd HH:mm:ss", "dd MMM yyyy HH:mm:ss", "dd MMM yyyy", "M/d/yy"};
        java.util.Date d = DateUtils.parseDate(str, parsePatterns);
        SimpleDateFormat jdbc = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String s = jdbc.format(d);
        return Timestamp.valueOf(s);
    }
    public static Timestamp getTimestamp(HttpServletRequest request, String str) throws ParseException { return getTimestamp(request.getParameter(str)); }
    public static Timestamp getTimestamp(MultipartRequest request, String str) throws ParseException { return getTimestamp(request.getParameter(str)); }
    public static Timestamp getTimestamp(HttpSession session, String str) throws ParseException { return getTimestamp((String)session.getAttribute(str)); }

    /**
     * Return the given string array as an array of ints; each is 0 if null or not an int
     */
    static int[] getIntValues(String[] str) throws NumberFormatException {
        if (str==null) return new int[0];
        int[] v = new int[str.length];
        for (int i=0; i<v.length; i++) {
            if (str[i]==null) {
                v[i] = 0;
            } else {
                try {
                    v[i] = Integer.parseInt(str[i]);
                } catch (NumberFormatException ex) {
                    v[i] = 0;
                }
            }
        }
        return v;
    }
    public static int[] getIntValues(HttpServletRequest request, String str) { return getIntValues(request.getParameterValues(str)); }
    public static int[] getIntValues(MultipartRequest request, String str) { return getIntValues(request.getParameterValues(str)); }

    /**
     * Return the given string array as an array of Integers; each is 0 if null or not an int
     */
    static Integer[] getIntegerValues(String[] str) throws NumberFormatException {
        if (str==null) return new Integer[0];
        Integer[] v = new Integer[str.length];
        for (int i=0; i<v.length; i++) {
            if (str[i]==null) {
                v[i] = 0;
            } else {
                try {
                    v[i] = Integer.parseInt(str[i]);
                } catch (NumberFormatException ex) {
                    v[i] = 0;
                }
            }
        }
        return v;
    }
    public static Integer[] getIntegerValues(HttpServletRequest request, String str) { return getIntegerValues(request.getParameterValues(str)); }
    public static Integer[] getIntegerValues(MultipartRequest request, String str) { return getIntegerValues(request.getParameterValues(str)); }

    /**
     * Return an array of trimmed, values or null strings from the input array of strings
     */
    static String[] getStringValues(String[] str) {
        if (str==null) return new String[0];
        String[] v = new String[str.length];
        for (int i=0; i<v.length; i++) {
            if (str[i]==null || str[i].length()==0) {
                v[i] = null;
            } else {
                v[i] = str[i].trim();
            }
        }
        return v;
    }    
    public static String[] getStringValues(HttpServletRequest request, String str) { return getStringValues(request.getParameterValues(str)); }
    public static String[] getStringValues(MultipartRequest request, String str) { return getStringValues(request.getParameterValues(str)); }

    /**
     * Return the given string array as an array of doubles; each is 0.00 if null or not a double
     */
    static double[] getDoubleValues(String[] str) throws NumberFormatException {
        if (str==null) return new double[0];
        double[] v = new double[str.length];
        for (int i=0; i<v.length; i++) {
            if (str[i]==null) {
                v[i] = 0.00;
            } else {
                try {
                    v[i] = Double.parseDouble(str[i]);
                } catch (NumberFormatException ex) {
                    v[i] = 0.00;
                }
            }
        }
        return v;
    }
    public static double[] getDoubleValues(HttpServletRequest request, String str) { return getDoubleValues(request.getParameterValues(str)); }
    public static double[] getDoubleValues(MultipartRequest request, String str) { return getDoubleValues(request.getParameterValues(str)); }

    /**
     * Return the given string array as an array of booleans; default is false, only "true" returns true
     */
    static boolean[] getBooleanValues(String[] str) {
        if (str==null) return new boolean[0];
        boolean[] v = new boolean[str.length];
        for (int i=0; i<v.length; i++) {
            if (str[i]!=null && str[i].equals("true")) {
                v[i] = true;
            } else {
                v[i] = false;
            }
        }
        return v;
    }
    public static boolean[] getBooleanValues(HttpServletRequest request, String str) { return getBooleanValues(request.getParameterValues(str)); }
    public static boolean[] getBooleanValues(MultipartRequest request, String str) { return getBooleanValues(request.getParameterValues(str)); }


    // --------------------------------------------------------------------------------------------

    /**
     * Return a string with the first character capitalized, the rest lower case
     */
    public static String initCap(String s) {
        return (s!=null) ? s.substring(0,1).toUpperCase()+s.substring(1).toLowerCase() : null;
    }

    /**
     * Generate a random string consisting of lower-case alphanumeric characters with the input length
     */
    public static String randomString(int length) {
        String charset = "0123456789abcdefghijklmnopqrstuvwxyz";
        Random rand = new Random(System.currentTimeMillis());
        StringBuffer sb = new StringBuffer();
        for (int i=0; i<length; i++) {
            int pos = rand.nextInt(charset.length());
            sb.append(charset.charAt(pos));
        }
        return sb.toString();
    }

    /**
     * Generate a random string consisting of the given characters and the input length
     */
    public static String randomString(String charset, int length) {
        Random rand = new Random(System.currentTimeMillis());
        StringBuffer sb = new StringBuffer();
        for (int i=0; i<length; i++) {
            int pos = rand.nextInt(charset.length());
            sb.append(charset.charAt(pos));
        }
        return sb.toString();
    }

    /**
     * Return true if input string is alphanumeric [a-z],[A-Z],[0-9] and not null
     */
    public static boolean isAlphanumeric(String s) {
        if (s==null) return false;
        char[] chars = s.toCharArray();
        for (int i=0; i<chars.length; i++) {
            if (!Character.isLetterOrDigit(chars[i])) return false;
        }
        return true;
    }

    /**
     * Return true if input string is alphanumeric [a-z],[A-Z],[0-9] or dash and not null
     */
    public static boolean isAlphanumericOrDash(String s) {
        if (s==null) return false;
        char[] chars = s.toCharArray();
        for (int i=0; i<chars.length; i++) {
            if (!Character.isLetterOrDigit(chars[i]) && chars[i]!='-') return false;
        }
        return true;
    }

    /**
     * Replace line breaks with br tags
     */
    public static String replaceLineBreaks(String s) {
        String fixed = s;
        fixed = fixed.replaceAll("\r","");
        fixed = fixed.replaceAll("<br/>\n","\n"); // prevent duplicating existing <br/> tags
        fixed = fixed.replaceAll("\n","<br/>\n");
        fixed = fixed.replaceAll("><br/>\n",">\n"); // leave ending tags alone
        return fixed;
    }

    /**
     * Output the ReCaptcha HTML
     */
    public static String generateReCaptcha(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
        return ReCaptchaFactory.newReCaptcha(Setting.getString(context,"recaptcha_site_key"), Setting.getString(context,"recaptcha_secret_key"), false).createRecaptchaHtml(null, null);
    }

    /**
     * Validate the input ReCaptcha response for a normal request; throw ValidationException if invalid or missing
     */
    public static void validateReCaptcha(HttpServletRequest request) throws ValidationException, SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
        String remoteAddr = request.getRemoteAddr();
        ReCaptchaImpl reCaptcha = new ReCaptchaImpl();
        reCaptcha.setPrivateKey(Setting.getString(request.getServletContext(), "recaptcha_secret_key"));
        String challenge = Util.getString(request, "recaptcha_challenge_field");
        String uresponse = Util.getString(request, "recaptcha_response_field");
        if (uresponse.length()==0) {
            throw new ValidationException("Please enter the security code shown in the image.");
        } else {
            ReCaptchaResponse reCaptchaResponse = reCaptcha.checkAnswer(remoteAddr, challenge, uresponse);
            if (!reCaptchaResponse.isValid()) throw new ValidationException("The security code that you entered is incorrect.");
        }
    }

    /**
     * Validate the input ReCaptcha response for a multipart request; throw ValidationException if invalid or missing
     */
    public static void validateReCaptcha(HttpServletRequest request, MultipartRequest mpr) throws ValidationException, SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
        String remoteAddr = request.getRemoteAddr();
        ReCaptchaImpl reCaptcha = new ReCaptchaImpl();
        reCaptcha.setPrivateKey(Setting.getString(request.getServletContext(), "recaptcha_secret_key"));
        String challenge = Util.getString(mpr, "recaptcha_challenge_field");
        String uresponse = Util.getString(mpr, "recaptcha_response_field");
        if (uresponse.length()==0) {
            throw new ValidationException("Please enter the security code shown in the image.");
        } else {
            ReCaptchaResponse reCaptchaResponse = reCaptcha.checkAnswer(remoteAddr, challenge, uresponse);
            if (!reCaptchaResponse.isValid()) throw new ValidationException("The security code that you entered is incorrect.");
        }
    }

    /**
     * Validate the input SimpleCaptcha response for a normal request; throw ValidationException if invalid or missing
     */
    public static void validateSimpleCaptcha(HttpSession session, HttpServletRequest request) throws ValidationException {
        Captcha captcha = (Captcha) session.getAttribute(Captcha.NAME);
        if (captcha==null) throw new ValidationException("CAPTCHA value is not supplied in session.");
        String answer = request.getParameter("captchafield");
        if (answer==null || answer.trim().length()==0) throw new ValidationException("Please enter the security code (CAPTCHA) shown in the image.");
        if (!captcha.isCorrect(answer)) throw new ValidationException("The security code (CAPTCHA) that you entered is incorrect.");
    }

    /**
     * Validate the input SimpleCaptcha response for a multipart request; throw ValidationException if invalid or missing
     */
    public static void validateSimpleCaptcha(HttpSession session, MultipartRequest mpr) throws ValidationException {
        Captcha captcha = (Captcha) session.getAttribute(Captcha.NAME);
        if (captcha==null) throw new ValidationException("CAPTCHA value is not supplied in session.");
        String answer = mpr.getParameter("captchafield");
        if (answer==null || answer.trim().length()==0) throw new ValidationException("Please enter the security code (CAPTCHA) shown in the image.");
        if (!captcha.isCorrect(answer)) throw new ValidationException("The security code (CAPTCHA) that you entered is incorrect.");
    }

    /**
     * Return an array of uploaded files, alpha sorted
     */
    public static File[] getUploadedFiles(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException {
        String imageDir = Setting.getString(context, "site_imagedir");
        // get directory listing
        File dir = new File(imageDir);
        File[] files = dir.listFiles();
        // sort alphabetically
        File[] sortedFiles = new File[files.length];
        TreeSet<File> sortedList = new TreeSet<File>();
        for (int i=0; i<files.length; i++) sortedList.add(files[i]);
        Iterator listIterator = sortedList.iterator();
        int count = 0;
        while (listIterator.hasNext()) {
            sortedFiles[count++] = (File)listIterator.next();
        }
        return sortedFiles;
    }

    /**
     * Return the MD5 digest of a string
     */
    public static String md5(String cleartxt) throws NoSuchAlgorithmException {
        MessageDigest md = MessageDigest.getInstance("MD5");
        md.update(cleartxt.getBytes());
        byte[] digest = md.digest();
        StringBuffer sb = new StringBuffer();
        for (byte b : digest) {
            sb.append(String.format("%02x", b & 0xff));
        }
        return sb.toString();
    }

    /**
     * Verify a Google reCaptcha response for an HttpServletRequest
     */
    public static void verifyGoogleReCaptcha(HttpServletRequest request) throws ValidationException, IOException, SQLException, NamingException, ClassNotFoundException {
        String gRecaptchaResponse = getString(request, "g-recaptcha-response");
        String remoteAddr = request.getRemoteAddr();
        String secret = Setting.getString(request.getServletContext(), "recaptcha_secret_key");
        verifyGoogleReCaptcha(gRecaptchaResponse, remoteAddr, secret);
    }

    /**
     * Verify a Google reCaptcha response for a MultiPartRequest
     */
    public static void verifyGoogleReCaptcha(HttpServletRequest request, MultipartRequest mpr) throws ValidationException, IOException, SQLException, NamingException, ClassNotFoundException {
        String gRecaptchaResponse = getString(mpr, "g-recaptcha-response");
        String remoteAddr = request.getRemoteAddr();
        String secret = Setting.getString(request.getServletContext(), "recaptcha_secret_key");
        verifyGoogleReCaptcha(gRecaptchaResponse, remoteAddr, secret);
    }

    /**
     * Verify a Google reCaptcha response
     */
    static void verifyGoogleReCaptcha(String gRecaptchaResponse, String remoteAddr, String secret) throws ValidationException {

        if (gRecaptchaResponse == null || gRecaptchaResponse.length()==0) {
            throw new ValidationException("Google ReCaptcha response is empty: check the box to prove that you are not a robot.");
        }
	
        try {

            // initialize connection
            URL obj = new URL(GOOGLE_RECAPTCHA_URL);
            HttpsURLConnection con = (HttpsURLConnection) obj.openConnection();

            // add request header
            con.setRequestMethod("POST");
            con.setRequestProperty("User-Agent", USER_AGENT);
            con.setRequestProperty("Accept-Language", "en-US,en;q=0.5");

            String postParams = "secret="+secret+"&response="+gRecaptchaResponse+"&remoteip="+remoteAddr;

            // Send post request
            con.setDoOutput(true);
            DataOutputStream wr = new DataOutputStream(con.getOutputStream());
            wr.writeBytes(postParams);
            wr.flush();
            wr.close();

            int responseCode = con.getResponseCode();
            System.out.println("\nSending 'POST' request to URL : " + GOOGLE_RECAPTCHA_URL);
            System.out.println("Post parameters : " + postParams);
            System.out.println("Response Code : " + responseCode);

            BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
            String inputLine;
            StringBuffer response = new StringBuffer();

            while ((inputLine = in.readLine()) != null) {
                response.append(inputLine);
            }
            in.close();

            // print result
            System.out.println(response.toString());
		
            // parse JSON response and throw exception if not 'success'
            JsonReader jsonReader = Json.createReader(new StringReader(response.toString()));
            JsonObject jsonObject = jsonReader.readObject();
            jsonReader.close();

            boolean success = jsonObject.getBoolean("success");
            if (!success) {
                throw new ValidationException("Google ReCaptcha failed.");
            }
		
            return;
            
        } catch(Exception e){
            e.printStackTrace();
            return;
        }
    }


}
