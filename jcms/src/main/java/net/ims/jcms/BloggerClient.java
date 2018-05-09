package net.ims.jcms;

import com.google.gdata.client.GoogleService;
import com.google.gdata.client.Query;
import com.google.gdata.data.DateTime;
import com.google.gdata.data.Entry;
import com.google.gdata.data.Feed;
import com.google.gdata.data.Person;
import com.google.gdata.data.PlainTextConstruct;
import com.google.gdata.data.TextContent;
import com.google.gdata.util.ServiceException;
import com.google.gdata.util.AuthenticationException;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.net.URL;

import javax.naming.NamingException;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpSession;

/**
 * Uses the Google Data API's Java client library to interface with the Blogger service.
 *
 * Based on sample BloggerClient provided with Google gdata samples.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class BloggerClient {

  // parameters pulled from Settings
  private String metafeedUrl;
  private String feedUriBase;
  private String postsFeedUriSuffix;
  private String commentsFeedUriSuffix;
  private String userName;
  private String userPassword;
  private String serviceName;
  private String applicationName;

  public String blogId;
  public String feedUri;

  private GoogleService myService;

  /**
   * Instantiate using values from Settings to make connection
   */
  public BloggerClient(ServletContext context) throws SQLException, NamingException, FileNotFoundException, ClassNotFoundException, IOException, AuthenticationException, ServiceException {

    // get Blogger settings
    metafeedUrl = Setting.getString(context, "blogger_metafeed_url");
    feedUriBase = Setting.getString(context, "blogger_feed_uri_base");
    postsFeedUriSuffix = Setting.getString(context, "blogger_posts_feed_uri_suffix");
    commentsFeedUriSuffix = Setting.getString(context, "blogger_comments_feed_uri_suffix");
    userName = Setting.getString(context, "blogger_username");
    userPassword = Setting.getString(context, "blogger_password");
    serviceName = Setting.getString(context, "blogger_service_name");
    applicationName = Setting.getString(context, "blogger_application_name");
    
    // create service object
    myService = new GoogleService(serviceName, applicationName);

    // authenticate using ClientLogin
    myService.setUserCredentials(userName, userPassword);

    // get the blog ID from the metafeed.
    blogId = getBlogId();
    feedUri = feedUriBase + "/" + blogId;

  }

  /**
   * Parses the metafeed to get the blog ID for the authenticated user's default blog.
   * 
   * @return A String representation of the blog's ID.
   * @throws ServiceException If the service is unable to handle the request.
   * @throws IOException If the URL is malformed.
   */
  private String getBlogId() throws ServiceException, IOException {
    // Get the metafeed
    final URL feedUrl = new URL(metafeedUrl);
    Feed resultFeed = myService.getFeed(feedUrl, Feed.class);

    // If the user has a blog then return the id (which comes after 'blog-')
    if (resultFeed.getEntries().size() > 0) {
      Entry entry = resultFeed.getEntries().get(0);
      return entry.getId().split("blog-")[1];
    } else {
      throw new IOException("User has no blogs!");
    }
  }

  /**
   * Returns an array of all the user's blogs.
   * 
   * @throws ServiceException If the service is unable to handle the request.
   * @throws IOException If the URL is malformed.
   */
  public String[] getUserBlogs() throws ServiceException, IOException {

    // Request the feed
    final URL feedUrl = new URL(metafeedUrl);
    Feed resultFeed = myService.getFeed(feedUrl, Feed.class);

    // return the results
    String[] userBlogs = new String[resultFeed.getEntries().size()];
    for (int i=0; i<resultFeed.getEntries().size(); i++) {
      Entry entry = resultFeed.getEntries().get(i);
      userBlogs[i] = entry.getTitle().getPlainText();
    }
    return userBlogs;
  }

  /**
   * Creates a new post on a blog. The new post can be stored as a draft or
   * published based on the value of the isDraft parameter. The method creates an
   * Entry for the new post using the title, content, authorName and isDraft
   * parameters. Then it uses the given GoogleService to insert the new post. If
   * the insertion is successful, the added post will be returned.
   * 
   * @param title Text for the title of the post to create.
   * @param content Text for the content of the post to create.
   * @param authorName Display name of the author of the post.
   * @param userName username of the author of the post.
   * @param isDraft True to save the post as a draft, False to publish the post.
   * @return An Entry containing the newly-created post.
   * @throws ServiceException If the service is unable to handle the request.
   * @throws IOException If the URL is malformed.
   */
  public Entry createPost(String title, String content, String authorName, String userName, Boolean isDraft) throws ServiceException, IOException {
    // Create the entry to insert
    Entry myEntry = new Entry();
    myEntry.setTitle(new PlainTextConstruct(title));
    myEntry.setContent(new PlainTextConstruct(content));
    Person author = new Person(authorName, null, userName);
    myEntry.getAuthors().add(author);
    myEntry.setDraft(isDraft);

    // Ask the service to insert the new entry
    URL postUrl = new URL(feedUri + postsFeedUriSuffix);
    return myService.insert(postUrl, myEntry);
  }

  /**
   * Returns an array of titles of all the posts in a blog.
   * 
   * @throws ServiceException If the service is unable to handle the request.
   * @throws IOException If the URL is malformed.
   */
  public String[] getAllTitles() throws ServiceException, IOException {
    // Request the feed
    URL feedUrl = new URL(feedUri + postsFeedUriSuffix);
    Feed resultFeed = myService.getFeed(feedUrl, Feed.class);

    // return the titles
    String[] titles = new String[resultFeed.getEntries().size()];
    for (int i=0; i<resultFeed.getEntries().size(); i++) {
      Entry entry = resultFeed.getEntries().get(i);
      titles[i] = entry.getTitle().getPlainText();
    }
    return titles;
  }

  /**
   * Returns an array of all the posts in a blog.
   * 
   * @throws ServiceException If the service is unable to handle the request.
   * @throws IOException If the URL is malformed.
   */
  public Entry[] getAllPosts() throws ServiceException, IOException {
    // Request the feed
    URL feedUrl = new URL(feedUri + postsFeedUriSuffix);
    Feed resultFeed = myService.getFeed(feedUrl, Feed.class);

    // return the posts
    Entry[] posts = new Entry[resultFeed.getEntries().size()];
    for (int i=0; i<resultFeed.getEntries().size(); i++) {
      posts[i] = resultFeed.getEntries().get(i);
    }
    return posts;
  }

  /**
   * Returns the title for any posts that have been
   * created or updated in the period between the startTime and endTime
   * parameters. The method creates the query, submits it to the GoogleService,
   * then displays the results.
   * 
   * Note that while the startTime is inclusive, the endTime is exclusive, so
   * specifying an endTime of '2007-7-1' will include those posts up until
   * 2007-6-30 11:59:59PM.
   * 
   * @param startTime DateTime object specifying the beginning of the search
   *        period (inclusive).
   * @param endTime DateTime object specifying the end of the search period
   *        (exclusive).
   * @throws ServiceException If the service is unable to handle the request.
   * @throws IOException If the URL is malformed.
   */
  public String[] getTitlesInDateRange(DateTime startTime, DateTime endTime) throws ServiceException, IOException {
    // Create query and submit a request
    URL feedUrl = new URL(feedUri+postsFeedUriSuffix);
    Query myQuery = new Query(feedUrl);
    myQuery.setUpdatedMin(startTime);
    myQuery.setUpdatedMax(endTime);
    Feed resultFeed = myService.query(myQuery, Feed.class);

    // get the titles
    String[] titles = new String[resultFeed.getEntries().size()];
    for (int i=0; i<resultFeed.getEntries().size(); i++) {
      Entry entry = resultFeed.getEntries().get(i);
      titles[i] = entry.getTitle().getPlainText();
      // modification time is entry.getUpdated().toStringRfc822()
    }

    return titles;
  }

  /**
   * Updates the title of the given post. The Entry object is updated with the
   * new title, then a request is sent to the GoogleService. If the insertion is
   * successful, the updated post will be returned.
   * 
   * Note that other characteristics of the post can also be modified by
   * updating the values of the entry object before submitting the request.
   * 
   * @param entryToUpdate An Entry containing the post to update.
   * @param newTitle Text to use for the post's new title.
   * @return An Entry containing the newly-updated post.
   * @throws ServiceException If the service is unable to handle the request.
   * @throws IOException If the URL is malformed.
   */
  public Entry updatePostTitle(Entry entryToUpdate, String newTitle) throws ServiceException, IOException {
    entryToUpdate.setTitle(new PlainTextConstruct(newTitle));
    URL editUrl = new URL(entryToUpdate.getEditLink().getHref());
    return myService.update(editUrl, entryToUpdate);
  }

  /**
   * Adds a comment to the specified pos from the authorized user. First the comment feed's URI is built
   * using the given post ID. Then an Entry is created for the comment and
   * submitted to the GoogleService.
   * 
   * NOTE: This functionality is not officially supported yet.
   * 
   * @param postId The ID of the post to comment on.
   * @param commentText Text to store in the comment.
   * @return An entry containing the newly-created comment.
   * @throws ServiceException If the service is unable to handle the request.
   * @throws IOException If the URL is malformed.
   */
  public Entry createComment(String postId, String commentText) throws ServiceException, IOException {
    // Build the comment feed URI
    String commentsFeedUri = feedUri+"/"+postId+commentsFeedUriSuffix;
    URL feedUrl = new URL(commentsFeedUri);

    // Create a new entry for the comment and submit it to the GoogleService
    Entry myEntry = new Entry();
    myEntry.setContent(new PlainTextConstruct(commentText));
    return myService.insert(feedUrl, myEntry);
  }

  /**
   * Returns all the comments for the given post. First the comment feed's URI
   * is built using the given post ID. Then the method requests the comments
   * feed and displays the results.
   * 
   * @param postId The ID of the post to view comments on.
   * @throws ServiceException If the service is unable to handle the request.
   * @throws IOException If there is an error communicating with the server.
   */
  public Entry[] getAllComments(String postId) throws ServiceException, IOException {
    // Build comment feed URI and request comments on the specified post
    String commentsFeedUri = feedUri+"/"+postId+commentsFeedUriSuffix;
    URL feedUrl = new URL(commentsFeedUri);
    Feed resultFeed = myService.getFeed(feedUrl, Feed.class);

    // get the comments
    Entry[] comments = new Entry[resultFeed.getEntries().size()];
    for (int i=0; i<resultFeed.getEntries().size(); i++) {
      comments[i] = resultFeed.getEntries().get(i);
    }

    return comments;
  }

  /**
   * Removes the comment specified by the given editLinkHref.
   * 
   * @param editLinkHref The URI given for editing the comment.
   * @throws ServiceException If the service is unable to handle the request.
   * @throws IOException If there is an error communicating with the server.
   */
  public void deleteComment(String editLinkHref) throws ServiceException, IOException {
    URL deleteUrl = new URL(editLinkHref);
    myService.delete(deleteUrl);
  }

  /**
   * Removes the post specified by the given editLinkHref.
   * 
   * @param editLinkHref The URI given for editing the post.
   * @throws ServiceException If the service is unable to handle the request.
   * @throws IOException If there is an error communicating with the server.
   */
  public void deletePost(String editLinkHref) throws ServiceException, IOException {
    URL deleteUrl = new URL(editLinkHref);
    myService.delete(deleteUrl);
  }

}
