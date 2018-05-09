<%@ include file="/WEB-INF/include/init.inc" %>
<%@ page import="java.sql.Timestamp" %>
<%
/**
 * Update a node name, return JSON result
 */

JSONObject json = new JSONObject();

try {

  int nid = Integer.parseInt(request.getParameter("nid"));
  Node n = new Node(application, nid);

  boolean scheduleinsert = request.getParameter("scheduleinsert")!=null;
  boolean scheduledelete = request.getParameter("scheduledelete")!=null;

  if (scheduleinsert) {
    // the four options
    int pid = Integer.parseInt(request.getParameter("pid"));
    int mid = Integer.parseInt(request.getParameter("mid"));
    int redirectnid = Integer.parseInt(request.getParameter("redirectnid"));
    String url = request.getParameter("url").trim();
    if (url!=null && url.equals("")) url = null;
    // validation: only one of pid, mid, url may not be null OR all 0/null to deactivate
    boolean valid = (pid==0 && mid==0 && redirectnid==0 && url==null)
      || (pid!=0 && mid==0 && redirectnid==0 && url==null)
      || (pid==0 && mid!=0 && redirectnid==0 && url==null)
      || (pid==0 && mid==0 && redirectnid!=0 && url==null)
      || (pid==0 && mid==0 && redirectnid==0 && url!=null);
    if (valid) {
      Timestamp starttime = Util.getTimestamp(request,"starttime");
      if (url==null) {
	NodeLink nl = new NodeLink(application, n.nid, pid, mid, redirectnid, null, starttime);
	if (nl.isEmpty()) {
	  message = "Node <b>"+n.label+"</b> will become inactive starting at "+nl.getStartTimeString(application)+". ";
	} else if (nl.pid!=0) {
	  message = "Node <b>"+n.label+"</b> will link page <b>"+nl.pid+"</b> starting at "+nl.getStartTimeString(application)+". ";
	} else if (nl.mid!=0) {
	  message = "Node <b>"+n.label+"</b> will link media file <b>"+nl.mid+"</b> starting at "+nl.getStartTimeString(application)+". ";
	} else if (nl.redirectnid!=0) {
	  message = "Node <b>"+n.label+"</b> will redirect to node <b>"+(new Node(application,nl.redirectnid)).label+"</b> starting at "+nl.getStartTimeString(application)+". ";
	}
      } else {
	// url validation - must have protocol
	NodeLink nl = new NodeLink(application, n.nid, 0, 0, 0, url, starttime);
	message = "Node <b>"+n.label+"</b> will link <b>"+nl.url+"</b> starting at "+nl.getStartTimeString(application)+". ";
      }
    } else {
      error = "At most one of Page, Media or URL may be nonempty.";
    }
  }
    
  if (scheduledelete) {
    int nlid = Integer.parseInt(request.getParameter("nlid"));
    NodeLink nl = new NodeLink(application, nlid);
    if (nl.pid==0) {
      message = "Node <b>"+n.label+"</b> will no longer become inactive at "+nl.getStartTimeString(application)+". ";
    } else {
      message = "Node <b>"+n.label+"</b> will no longer display page <b>"+nl.pid+"</b> at "+nl.getStartTimeString(application)+". ";
    }
    nl.delete(request);
  }

  if (error==null) {
    json.put("success", true);
    // pass back the node nid
    JSONObject jsonNid = new JSONObject();
    jsonNid.put("nid", nid);
    json.append("callbackArgs", jsonNid);
    // pass back the success message
    JSONObject jsonMessage = new JSONObject();
    jsonMessage.put("message", message);
    json.append("callbackArgs", jsonMessage);
  } else {
    json.put("success", false);
    json.put("generalError", error);
    JSONObject fieldError = new JSONObject();
  }

} catch (Exception ex) {
    
  json.put("success", false);
  json.put("generalError", ex.toString());
    
}

out.print(json.toString());
%>
<%@ include file="/WEB-INF/include/close.inc" %>
