<%@ include file="/WEB-INF/include/init.inc" %>
<% pageTitle = "Nodes"; useZapatec=true; docUrl="doc-nodes.jsp"; %>
<%@ include file="/WEB-INF/include/header.jhtml" %>
<%@ include file="/WEB-INF/include/subheader.jhtml" %>
<script type="text/javascript">

// global Javascript vars
var tree = null;
var swin = null;

/**
 * create/open the schedule window, Zapatec
 */
function openScheduleWindow(nid) {
  swin = new Zapatec.Window({
      theme: 'plain',
	showMaxButton: false,
	showMinButton: false
	});
  swin.setPosition(225, 0);
  swin.setSize(800, 500);
  swin.create();
  swin.setContentUrl('node-schedule-form.jsp?nid='+nid);
  swin.show();
}
    
/**
 * rename window is persistent, Zapatec
 */
var rwin = new Zapatec.Window({
    theme: 'dialog'
      });
rwin.setPosition(325, 0);
rwin.setSize(350, 80);
rwin.create();

// show rename window for node
function openRenameWindow(nid) {
  rwin.setContentUrl('node-rename-form.jsp?nid='+nid);
  rwin.show();
}

/**
 * alias window is persistent, Zapatec
 */
var awin = new Zapatec.Window({
    theme: 'dialog'
      });
awin.setPosition(325, 0);
awin.setSize(350, 80);
awin.create();

// show alias window for node
function openAliasWindow(nid) {
  awin.setContentUrl('node-alias-form.jsp?nid='+nid);
  awin.show();
}

/**
 * Update a node label using a back-end call to node-label.jsp
 */
function updateNodeLabel(nid) {
  Zapatec.Transport.fetch({
    async: false,
    url: 'node-label.jsp?nid='+nid,
    onLoad: function(objRequest) {
	var node = tree.getNode('n'+nid, false);
	node.rename(objRequest.responseText.trim());
      }
    });
}

/**
 * delete a node from the DB as well as the tree
 */
function deleteNode(nid) {
  Zapatec.Transport.fetch({
    async: false,
	url: 'node-parent.jsp?nid='+nid,
	onLoad: function(objRequest) {
	var parent_nid = objRequest.responseText.trim();
	if (parent_nid!='') {
	  fetchUrl('node-delete.jsp?nid='+nid);
	  refreshNode(parent_nid);
	  updateNodeLabel(parent_nid);
	}
      }
    });
}

/**
 * toggle the parent node to refresh branch from database
 */
function refreshParent(nid) {
  Zapatec.Transport.fetch({
    async: false,
	url: 'node-parent.jsp?nid='+nid,
	onLoad: function(objRequest) {
	var parent_nid = objRequest.responseText.trim();
	if (parent_nid!='') refreshNode(parent_nid);
      }
    });
}

/**
 * Refresh a node cycling closed and open
 */
function refreshNode(nid) {
  tree.toggleItem('n'+nid, false);
  tree.toggleItem('n'+nid, true);
}

/**
 * Add a sibling node
 */
function addSibling(nid) {
  fetchUrl('node-add-sibling.jsp?nid='+nid);
  refreshNode(nid);
  refreshParent(nid);
}

/**
 * Add a child node
 */
function addChild(nid) {
  fetchUrl('node-add-child.jsp?nid='+nid);
  refreshParent(nid);
}

/**
 * decrement a node's number and redraw siblings
 */
function decrementNode(nid) {
  fetchUrl('node-decrement.jsp?nid='+nid);
  refreshParent(nid);
}

/**
 * called by submitErrorFunc in Zapatec.Form.setupAll
 */
function onError(objErrors) {
  var message = objErrors.generalError + '<br/>';
  if (objErrors.fieldErrors) {
    for (var i=0; i<objErrors.fieldErrors.length; i++) message += (i+1)+': Field "'+objErrors.fieldErrors[i].field.name+'" '+objErrors.fieldErrors[i].errorMessage+"<br/>";
  }
  var messageDiv = document.getElementById('message');
  messageDiv.innerHTML = '';
  var errorDiv = document.getElementById('error');
  errorDiv.innerHTML = message;
}
    
/**
 * called by asyncSubmitFunc in Zapatec.Form.setupAll
 */
function onSuccess(callbackArgs) {
  var message = "";
  var nid = 0;
  if (callbackArgs) {
    for (var i=0; i<callbackArgs.length; i++) {
      if (callbackArgs[i].message) message += callbackArgs[i].message;
      if (callbackArgs[i].nid) nid = callbackArgs[i].nid;
    }
  }
  var errorDiv = document.getElementById('error');
  errorDiv.innerHTML = '';
  var messageDiv = document.getElementById('message');
  messageDiv.innerHTML = message;
  updateNodeLabel(nid);
  if (rwin!=null) rwin.hide();
  if (awin!=null) awin.hide();
  if (swin!=null) swin.close();
};

/**
 * called by ajaxDebugFunc in Zapatec.Form.setupAll
 */
function showDebug(message) {
  var debugContainer = document.getElementById("debugContainer");
  if (debugContainer == null) {
    debugContainer = document.createElement("div");
    debugContainer.id = "debugContainer";
    var st = debugContainer.style;
    st.position = "absolute";
    st.top = "0";
    st.right = "0";
    st.width = "500px";
    st.height = "100px";
    st.overflow = "scroll";
    st.backgroundColor = "#EEEEEE";
    st.fontSize = "small";
    document.body.appendChild(debugContainer);
    Zapatec.ScrollWithWindow.register(debugContainer);
  }
  debugContainer.innerHTML += message.replace(/&/g, '&amp;').replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/\n/g, "<br />") + "<br />";
}
    
</script>
<%@ include file="/WEB-INF/include/errormessage.jhtml" %>
<%
  // root
  Node parent = new Node(); // the null node
  boolean parentPerms = true; // doesn't matter
  Node node = new Node(application, 0);
  boolean nodePerms = cpuser.hasPermission(application, node);
  boolean nodeHasChildren = node.hasChildren(application);
%>
<ul id="tree">
  <li id="n0" class="zpLoadHTML=node-children.jsp?nid=0 zpLoadAlways=true"><%@ include file="node-label.jhtml" %></li>
</ul>

<!-- The Javascript code to initiate the tree and sync to the selected node -->
<script type="text/javascript">
    tree = new Zapatec.Tree({
      tree: "tree",
      highlightSelectedNode: true,
      initLevel: 2
    });
    tree.sync('n0');
</script>

<%@ include file="/WEB-INF/include/close.inc" %>
<%@ include file="/WEB-INF/include/footer.jhtml" %>
