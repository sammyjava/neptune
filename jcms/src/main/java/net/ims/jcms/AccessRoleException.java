package net.ims.jcms;

/**
 * Extends Exception to report an exception thrown by an AccessRole implementing class method.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class AccessRoleException extends Exception {

  // this class is serializable, therefore need this, but it's arbitrary
  private static final long serialVersionUID = 03L;

  public AccessRoleException() {
  }

  public AccessRoleException(String message) {
    super(message);
  }

}


