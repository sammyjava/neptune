package net.ims.jcms;

/**
 * Extends Exception to wrap an exception that a User implementing class method throws.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class UserException extends Exception {

  // this class is serializable, therefore need this, but it's arbitrary
  private static final long serialVersionUID = 05L;

  public UserException() {
  }

  public UserException(String message) {
    super(message);
  }

}


