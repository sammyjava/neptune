package net.ims.icontact;

/**
 * Extends Exception to encapsulate validation errors; should be caught by calling code to display the error message.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class ValidationException extends Exception {

  // this class is serializable, therefore need this, but it's arbitrary
  private static final long serialVersionUID = 03L;

  public ValidationException(String message) {
    super(message);
  }

}


