package net.ims.jcms;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import org.apache.commons.codec.binary.Base64;

/**
 * Collection of static methods to provide encryption, email and password validation, etc.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class Authentication {

  /** Minimum length for passwords. */
  public static final int PASSWORD_MIN_LENGTH = 6;
  
  /** Minimum number of character types for passwords; valid values are 1-4. */
  public static final int PASSWORD_MIN_TYPES = 2;

  /** Invalid password message */
  public static String PASSWORD_INVALID = "The supplied password is invalid. Passwords must have at least "+PASSWORD_MIN_LENGTH+" characters " +
    "and characters of at least "+PASSWORD_MIN_TYPES+" types, where the types are [a-z], [A-Z] and [0-9].";

  /** Invalid email message */
  public static String EMAIL_INVALID = "The supplied email address is invalid.";

  /** Missing password message */
  public static String PASSWORD_MISSING = "No password was supplied. Passwords must have at least "+PASSWORD_MIN_LENGTH+" characters.";

  /**
   * Checks that an email is valid (valid chars, @ symbol, dots, etc.)
   * @param email the email address
   * @return true if the email is determined to be valid based on syntax
   */
  public static boolean isValidEmail(String email) {
    if (email==null) return false;
    boolean ok = true;
    // must be letters and numbers plus @, ., _, - characters
    for (int i=0; i<email.length(); i++) {
      ok = ok & (Character.isLetterOrDigit(email.charAt(i)) || email.charAt(i)=='@' || email.charAt(i)=='.' || email.charAt(i)=='_' || email.charAt(i)=='-');
    }
    // at least one char to left of @ symbol
    ok = ok && (email.indexOf('@')>0);
    // must have only one @ symbol
    ok = ok && (email.indexOf('@')==email.lastIndexOf('@'));
    // at least two dot-delimited atoms to right of @ symbol
    ok = ok && (email.indexOf('@')<(email.lastIndexOf('.')-1));
    ok = ok && (email.lastIndexOf('.')<(email.length()-1));
    // can't have consecutive ..
    ok = ok && (email.indexOf("..")==-1);
    return ok;
  }

  /**
   * Encrypts a string with SHA-1 encryption; used for passwords. Enforces password validation.  Removes \n and \r since they crept in 07/16/10!
   */
  public static String encrypt(String plainpass) throws NoSuchAlgorithmException, UnsupportedEncodingException, ValidationException {
    if (plainpass==null || plainpass.trim().length()==0) {
      throw new ValidationException(PASSWORD_MISSING);
    } else if (!isValidPassword(plainpass)) {
      throw new ValidationException(PASSWORD_INVALID);
    } else {
      MessageDigest md = MessageDigest.getInstance("SHA");
      md.update(plainpass.getBytes("UTF-8"));
      byte raw[] = md.digest();
      byte hashBytes[] = (new Base64()).encode(raw);
      String encrypted = new String(hashBytes);
      return encrypted.replace("\n","").replace("\r","");
    }
  }

  /**
   * Returns true if the supplied string meets minimum-length and composition requirements for valid passwords.
   */
  public static boolean isValidPassword(String plainpass) {
    // check length
    if (plainpass.length() < PASSWORD_MIN_LENGTH) {
      return false;
    }
    // check for whitespace
    if (contains(plainpass, whites)) {
      return false;
    }
    // check character mix
    int charSets = 0;
    if (contains(plainpass, uppers)) {
      charSets++;
    }
    if (contains(plainpass, lowers)) {
      charSets++;
    }
    if (contains(plainpass, digits)) {
      charSets++;
    }
    /*
      if (contains(plainpass, others)) {
      charSets++;
      }
    */
    if (charSets < PASSWORD_MIN_TYPES) {
      return false;
    }
    // we've made it this far, must be strong password
    return true;
  }
    
  /**
   * Returns true if a string contains a character in the supplied CharSet.
   * @param  s   the string
   * @param  set the CharSet
   * @return true if s contains a character in set
   */
  private static boolean contains(String s, CharSet set) {
    for (int i = 0; i < s.length(); i++) {
      if (set.contains(s.charAt(i)))
	return true;
    }
    return false;
  }

  /**
   * The CharSet interface is used to group character types.
   */
  private static interface CharSet {
    public boolean contains(char c);
  }
  private static CharSet whites = new CharSet() {
      public boolean contains(char c) {
	return Character.isWhitespace(c);
      }
    };
  private static CharSet uppers = new CharSet() {
      public boolean contains(char c) {
	return (Character.isLetter(c)
		&& Character.isUpperCase(c));
      }
    };
  private static CharSet lowers = new CharSet() {
      public boolean contains(char c) {
	return (Character.isLetter(c)
		&& Character.isLowerCase(c));
      }
    };
  private static CharSet digits = new CharSet() {
      public boolean contains(char c) {
	return Character.isDigit(c);
      }
    };
  private static CharSet others = new CharSet() {
      public boolean contains(char c) {
	return !(Character.isLetterOrDigit(c)
		 || Character.isISOControl(c)
		 || Character.isWhitespace(c));
      }
    };
  
}
