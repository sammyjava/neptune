package net.ims.jcms;

/**
 * Extends Exception to report when an application license is invalid.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class LicenseInvalidException extends Exception {

  // this class is serializable, therefore need this, but it's arbitrary
  private static final long serialVersionUID = 03L;

  public LicenseInvalidException() {
  }

  public LicenseInvalidException(String message) {
    super(message);
  }

}


