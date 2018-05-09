package net.ims.jcms;

/**
 * Extends Exception to report when a context is missing an initialization parameter.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class MissingParameterException extends Exception {

  // this class is serializable, therefore need this, but it's arbitrary
  private static final long serialVersionUID = 04L;

  public MissingParameterException() {
  }

  public MissingParameterException(String message) {
    super(message);
  }

}


