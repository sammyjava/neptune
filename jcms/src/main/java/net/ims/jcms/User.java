package net.ims.jcms;

import java.util.Vector;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

/**
 * This interface defines the user authentication method which must be implemented by any class used to authenticate control panel users.
 * This interface does NOT contain methods for updating user credentials, since they may be stored externally with read-only access.  Any implementing class is free to add such methods.
 *
 * Implementing classes must provide a default constructor, which is used by Util.getUser() to reach the methods (since they cannot be declared as static).
 *
 * Implementing classes must throw a UserException in most methods, which is a wrapper for whatever exceptions those classes would otherwise throw, such as SQLException, etc.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public interface User extends Comparable {

  /**
   * Return a single user instance based on username/password credentials, or throw UserException.
   */
  public User getUser(ServletContext context, String username, String password) throws UserException;

  /**
   * Return a single user instance based on username only; use wisely!
   */
  public User getUser(ServletContext context, String username) throws UserException;

  /**
   * Return an array of all users.
   */
  public User[] getAllUsers(ServletContext context) throws UserException;

  /**
   * Return this user's username.
   */
  public String getUsername();

  /**
   * Return this user's first name, if available, null otherwise.
   */
  public String getFirstname();

  /**
   * Return this user's last name, if available, null otherwise.
   */
  public String getLastname();

  /**
   * Return this users's email address, if available, null otherwise.
   */
  public String getEmail();

  /**
   * Return true if this user is the same as the provided user.
   */
  public boolean equals(User user);

}
