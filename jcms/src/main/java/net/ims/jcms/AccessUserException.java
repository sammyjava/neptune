package net.ims.jcms;

/**
 * Extends Exception to wrap an exception that an AccessUser implementing class method throws.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class AccessUserException extends Exception {

  // this class is serializable, therefore need this, but it's arbitrary
  private static final long serialVersionUID = 03L;

  public AccessUserException() {
  }

  public AccessUserException(String message) {
    super(message);
  }

}


