package net.ims.icontact;

/**
 * Exception thrown in the case of a resource call failing due to resource nonexistence.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class ResourceNotFoundException extends Exception {

  // this class is serializable, therefore need this, but it's arbitrary
  private static final long serialVersionUID = 05L;

  public ResourceNotFoundException(String message) {
    super(message);
  }

}


