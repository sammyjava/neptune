<%@ include file="/WEB-INF/include/init.inc" %>
<%
/**
 * Update a node name, return JSON result
 */

JSONObject json = new JSONObject();

try {

  int nid = Integer.parseInt(request.getParameter("nid"));
  Node n = new Node(application, nid);

  n.nodename = request.getParameter("nodename");

  if (n.nodename!=null && n.nodename.trim().length()>0) {
    n.update(request);
    message = "Node <b>"+n.label+"</b> name updated to <b>"+n.nodename+"</b>.";
  } else {
    error = "You must supply a node name.";
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
