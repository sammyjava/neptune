package net.ims.jcms;

/**
 * Extends Exception to report when a control panel user is not found.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class UserNotFoundException extends Exception {

  // this class is serializable, therefore need this, but it's arbitrary
  private static final long serialVersionUID = 03L;

  public UserNotFoundException() {
  }

  public UserNotFoundException(String message) {
    super(message);
  }

}


