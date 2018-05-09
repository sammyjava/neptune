package net.ims.jcms;

import java.util.Timer;
import java.util.TimerTask;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

/**
 * Class that launches background processes when the servlet context is initialized,
 * and shuts them down when the servlet context is destroyed.  Tasks:
 *
 * DhtmlDeleter - deletes the DHTML cache records (so they are refreshed on next request)
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class ContextListener implements ServletContextListener {

  /** The calling Servlet Context */
  ServletContext context = null;

  /** The timer which schedules the background processes */
  Timer timer = null;

  /** Starts the background processes; called when the context is initialized.  */
  public void contextInitialized(ServletContextEvent event) {

    // database methods require the ServletContext to connect
    context = event.getServletContext();

    // instantiate a new timer
    timer = new Timer();

    // schedule the DHTML deleter at ten-minute intervals (could be set by a settings record)
    timer.schedule(new DhtmlDeleter(), 60000, 600000);

  }

  /** Ends the background processes; called when the context is destroyed. */
  public void contextDestroyed(ServletContextEvent event) {

    // database methods require the ServletContext to connect
    context = event.getServletContext();

    // cancel the timer
    if (timer!=null) timer.cancel();

  }

  /** Deletes the DHTML cache records */
  class DhtmlDeleter extends TimerTask {

    public void run() {
      try {
	DhtmlCache.deleteAll(context);
      } catch (Exception ex) {
	System.err.println("DhtmlDeleter: "+ex.toString());
      }
    }

  }

}
