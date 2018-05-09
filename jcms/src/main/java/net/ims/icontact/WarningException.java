package net.ims.icontact;

/**
 * Extends Exception to display warnings embedded in the response
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class WarningException extends Exception {

  // this class is serializable, therefore need this, but it's arbitrary
  private static final long serialVersionUID = 02L;

  public WarningException(String message) {
    super(message);
  }

}


