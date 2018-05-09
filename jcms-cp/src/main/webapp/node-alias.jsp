<%@ include file="/WEB-INF/include/init.inc" %>
<%
/**
 * Update a node alias, return JSON result
 */

JSONObject json = new JSONObject();

try {

  int nid = Integer.parseInt(request.getParameter("nid"));
  Node n = new Node(application, nid);

  n.alias = request.getParameter("alias");

  if (n.alias.startsWith("/")) n.alias = n.alias.substring(1);
  // check against reserved folders
  boolean valid = true;
  String reserved[] = new String[5];
  reserved[0] = Setting.getString(application,"site_cssfolder");
  reserved[1] = Setting.getString(application,"site_designfolder");
  reserved[2] = Setting.getString(application,"site_imagefolder");
  reserved[3] = Setting.getString(application,"site_mediafolder");
  reserved[4] = Setting.getString(application,"photos_folder");
  for (int i=0; i<reserved.length; i++) {
    if (reserved[i].equals("/"+n.alias)) {
      error = "The alias <b>"+n.alias+"</b> is reserved and may not be used.";
      valid = false;
    }
  }
  if (valid) {
    try {
      n.update(request);
      if (n.alias==null) {
	message = "Node <b>"+n.label+"</b> alias removed. ";
      } else {
	message = "Node <b>"+n.label+"</b> alias updated to <b>"+n.alias+"</b>. ";
      }
    } catch (Exception ex) {
      if (ex.getMessage().contains("nodes_alias_unique")) {
	error = "The alias <b>"+n.alias+"</b> is already in use.";
      } else {
	error = ex.getMessage();
      }
    }
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
