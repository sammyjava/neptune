/**
 * @fileoverview Zapatec Tree core.
 *
 * <pre>
 * Copyright (c) 2004-2009 by Zapatec, Inc.
 * http://www.zapatec.com
 * 1700 MLK Way, Berkeley, California,
 * 94709, U.S.A.
 * All rights reserved.
 * </pre>
 */

/* $Id: tree-core.js 15736 2009-02-06 15:29:25Z nikolai $ */

/**
 * Tree core.
 * <pre>
 * <strong>Input data formats:</strong>
 *
 * <strong>JSON:</strong>
 * [
 *	{
 *		label: [string], // node label. It will be clickable. Required.
 *		isExpanded: [boolean, optional], // if this branch is expanded. Default value - false. This option will be ignored if "children" section is null
 *		isSelected: [boolean, optional], // if this node is selected. Default value - false.
 *		isChecked: [boolean, optional], // if tree displays checkboxes for all items - if this is true - checkbox will be checked
 *		expandedIcon: [string, optional], // string with IMG tag. This image will be shown when branch is expanded. This option will be ignored if "children" section is null.
 *		collapsedIcon: [string, optional], // string with IMG tag. This image will be shown when branch is collapsed. This option will be ignored if "children" section is null.
 *		fetchingIcon: [string, optional], // string with IMG tag. This image will be shown when branch is fetching its content. This option will be ignored if "children" section is null.
 *		elementIcon: [string, optional], // string with IMG tag. This image will be shown for single node (without branch)
 *		source: [string, optional], // if given - on expand tree will fetch content from given source. If "children" section is null - it will be put to empty array.
 *		sourceType: [string, optional], // type of source that will be fetched. See Zapatec.Widget documentation for examples.
 *		loadAlways: [boolean, optional], // if true - node children will be reloaded on each expand. Default - false.
 *		attributes: {
 *			attributeName: atrtibuteValue [string, optional], // this value will be added to TD element that contains node content.
 *			...
 *		},
 *		children: [ // child nodes. If null - no +/- sign will be displayed.
 *			...
 *		]
 *	}
 * ]
 * <strong>HTML:</strong>
 * Common HTML list - &lt;UL&gt;&lt;LI&gt;...&lt;/LI&gt;...&lt;/UL&gt;
 * <strong>XML:</strong>
 * See demo/tree.dtd for DTD Scheme
 *	<list>
 *		<item
 *			isExpanded="true|false" // if this branch is expanded. Default value - false. This option will be ignored if "children" section is null
 *			isSelected="true|false" // if this branch is selected. Default value - false. This option will be ignored if "children" section is null
 *			expandedIcon="" // string with IMG tag. This image will be shown when branch is expanded. This option will be ignored if "children" section is null.
 *			collapsedIcon="" // string with IMG tag. This image will be shown when branch is collapsed. This option will be ignored if "children" section is null.
 *			fetchingIcon="" // string with IMG tag. This image will be shown when branch is fetching its content. This option will be ignored if "children" section is null.
 *			elementIcon="" // string with IMG tag. This image will be shown for single node (without branch)
 *			source="" // if given - on expand tree will fetch content from given source. If "children" section is null - it will be put to empty array.
 *			sourceType="" // type of source that will be fetched. See Zapatec.Widget documentation for examples.
 *			loadAlways="" // if "true" - node children will be reloaded on each expand. Default - false.
 *		>
 *			<attribute	// this value will be added to TD element that contains node content. Optional.
 *				name="attributeName" // Attribute name
 *			>attributeValue</attribute> // Attribute value.
 *			<label></label> // node label. It will be clickable. Required.
 *			<list></list> // You can define other ITEM nodes here. They will be displayed as child nodes for current node. Optional.
 *		</item>
 *	<list>
 */
Zapatec.Tree = function() {
	var objArgs = {};

	switch(arguments.length){
		case 1:
			objArgs = arguments[0];
			break;
		case 2:
			// backward compartibility for 1.x version
			objArgs = arguments[1];
			objArgs.tree = arguments[0];
			break;
	}
	
	Zapatec.Tree.SUPERconstructor.call(this, objArgs);
};

/**
 * Shortcut for faster access.
 * @private
 * @final
 */
zapatecTree = Zapatec.Tree;

/**
 * Unique static id of the widget class. Gives ability for Zapatec#inherit to
 * determine and store path to this file correctly when it is included using
 * Zapatec#include. When this file is included using Zapatec#include or path
 * to this file is gotten using Zapatec#getPath, this value must be specified
 * as script id.
 * @private
 */
Zapatec.Tree.id = "Zapatec.Tree";

/**
 * Array stores references to all Zapatec.Tree instances. Array key - Zapatec.Tree#id or value of ID attribute of UL element specified by "tree" config option
 * This array is need for backward compatibility with &lt;2.0 versions. Use Zapatec.Widget.getWidgetById() instead.
 */
Zapatec.Tree.all = {};

// Inherit SuperClass
Zapatec.inherit(Zapatec.Tree, Zapatec.Widget);

/**
 * @private
 * Initializes tree.
 * @param {object} objArgs User configuration
 */
Zapatec.Tree.prototype.init = function(config) {
	this.container = null; // reference to element containing tree
	this.internalContainer = null;
	this.allNodes = []; // stores references to all nodes in a tree. You could use it to apply some function to all nodes in a tree, for example.
	this.id2Obj = {}; // Hash - node ID to Zapatec.Tree.Node instance
	this.rootNode = null; // root node for tree. It is not displayed - it doesn't have label or content - just child nodes.
	this.expandToLevelNum = 0;
	this.isClicked = false; // flag to determine if last click was done on tree element
	this.isActive = false; // flag to determine if user currently working with this tree.
	this.editInline = null; // if config.editable == true - this variable will hold reference to Zapatec.EditInline object
	this.isSaveStateDone = false; // flag to indicate if saveState feature was used.

	// <2.2 support
	if(config.tree){
		var tmp = Zapatec.Widget.getElementById(config.tree);

		if(tmp && tmp.id){
			this.id = tmp.id;
		}
	}

	Zapatec.Tree.SUPERclass.init.call(this, config);
	
	Zapatec.Tree.all[this.id] = this;

	// create tree container. apply theme to it.
	this.container = Zapatec.Utils.createElement("div", null, this.config.selectable);
	this.container.className = this.getClassName({prefix: "zpTree", suffix: "Container"});
	this.container.id = "zpTree" + this.id + "Container";

	this.internalContainer = Zapatec.Utils.createElement("div", null, this.config.selectable);
	this.internalContainer.className = "tree tree-top";
	this.container.appendChild(this.internalContainer);
	Zapatec.Utils.createProperty(this.container, "zpTree", this);

	// all newly created nodes will be expanded to this level.
	if(this.config.initLevel){
		this.expandToLevelNum = this.config.initLevel;
	}

	if(this.config.tree){
		this.config.tree.parentNode.insertBefore(this.container, this.config.tree);
		Zapatec.Utils.destroy(this.config.tree);
	} else if(this.config.parent){
		this.config.parent.appendChild(this.container);
	}

	// create root node
	this.rootNode = new Zapatec.Tree.Node({
		tree: this,
		parentNode: null,
		level: 0,
		isRootNode: true,
		eventListeners: this.config.eventListeners
	});

	this.id2Obj[this.id] = this.rootNode;

	this.rootNode.isCreated = true;
	this.rootNode.childrenContainer = this.internalContainer;

	this.prevSelected = null;

	// load data into tree
	this.loadData();

	// check if we have an initially selected node and sync.
	if (this.prevSelected){
		this.prevSelected.sync();
	}
	
	//if we're keeping track of state, and we have saved state information
	if(this.config.saveState){
		var txt = Zapatec.Utils.getCookie("Zapatec.Tree-" + this.config.saveId);
		var node = this.getNode(txt, true);

		if (node){
			this.isSaveStateDone = true;
			node.sync();
		}
	}
	
	if(this.config.editable){
		if(Zapatec.EditInline){
			var self = this;
			
			this.editInline = new Zapatec.EditInline({
				editAsText: this.config.editAsText,
				eventListeners: {
					showStart: function(){
						this.selectedNode = self.prevSelected;
					},
					saveContent: function(content){
						if(this.selectedNode){
							this.selectedNode.rename(content);
							this.selectedNode = null;
						}
					}
				}
			});
		} else {
			this.config.editable = false;
			Zapatec.Log({description: "Zapatec.EditInline class is not found. Please include 'utils/edit_inline.js' into page."});
		}
	}
	
	this.attachNavigation();
};

/**
 * Configures tree. Gets called from parent init method.
 *
 * @private
 * @param {object} objArgs User configuration
 */
Zapatec.Tree.prototype.configure = function(objArgs) {
	this.defineConfigOption('tree'); // Deprecated param. Use "source" option and "parent" instead. If given - Zapatec.Tree will replace "tree" element
	this.defineConfigOption('parent'); // if given - tree will be added to this element
	this.defineConfigOption('hiliteSelectedNode'); // Deprecated. Use "highlightSelectedNode" instead
	this.defineConfigOption('highlightSelectedNode', true); // Highlight selected node or not
	this.defineConfigOption('defaultIcons'); // if given - additional cell will be added before 
	this.defineConfigOption('compact', false); // if true - only one branch may be expanded at a time
	this.defineConfigOption('dynamic', false); // deprecated. Do nothing now.
	this.defineConfigOption('initLevel', 1); // tree will be expanded to this level on load.

	this.defineConfigOption('deselectSelected', false); // If option is true - then after clicking on selected node - that node will be deselected.
	
	this.defineConfigOption('saveState', false); // if true - tree will store ID of currently selected node into cookie. After page reload tree will be opened to that node.
	this.defineConfigOption('saveId'); // if "saveState" is true - this option is required. Cookie name.

	this.defineConfigOption('expandOnSignClick', true); // should branch expand on sign click
	this.defineConfigOption('expandOnSignDblclick', false); // should branch expand on sign double click

	this.defineConfigOption('expandOnIconClick', true); // should branch expand on icon click
	this.defineConfigOption('expandOnIconDblclick', false); // should branch expand on icon double click
	
	this.defineConfigOption('expandOnLabel');// deprecated. Use expandOnLabelClick. Backward compartibility for 2.1 version
	this.defineConfigOption('expandOnLabelClick', false); // should branch expand on label click

	this.defineConfigOption('labelDblClick'); // deprecated. Use expandOnLabelDblclick. Backward compartibility for 2.1 version
	this.defineConfigOption('expandOnLabelDblclick', false); // should branch expand on label double click

	this.defineConfigOption('selectMultiple', false); // if option is true - clicking on unselected node won't unselect currently selected nodes.
	
	this.defineConfigOption('selectOnSignClick', true); // should node become selected when clicking at +/- sign
	this.defineConfigOption('selectOnSignDblclick', true); // should node become selected when double clicking at +/- sign
	this.defineConfigOption('selectOnIconClick', true); // should node become selected when clicking at icon
	this.defineConfigOption('selectOnIconDblclick', true); // should node become selected when double clicking at icon
	this.defineConfigOption('selectOnLabelClick', true); // should node become selected when clicking at label
	this.defineConfigOption('selectOnLabelDblclick', true); // should node become selected when double clicking at label

	this.defineConfigOption('prevCompatible', false); // turn on compatibility mode with <=2.1 versions
	this.defineConfigOption('quick', false); // if true - tree will work faster but some feature (sync, expandAll and other operations that hurts uninitialized nodes) will be unavailable
	this.defineConfigOption('putBackReferences', false); // if true - TD element with content will have property zpTreeNode which will be reference to Zapatec.Tree.Node instance
	this.defineConfigOption('createWholeDOM', false); // if true - all DOM elements will be created when tree will be created.

	this.defineConfigOption('jsonLoadCallback'); // deprecated. Using this config option you can define fnction that will convert JSON object from your format to Zapatec.Tree format.

	this.defineConfigOption('keyboardNavigation', false); // Activate keyboard navigation for tree.
	this.defineConfigOption('deselectOnLeave'); // Deselect currently active node when leaving tree (clicking somewhere on the page outside tree or pressing ESC button).

	this.defineConfigOption('putCheckboxes', false); // if true - checkbox will be displayed for each node
	this.defineConfigOption('dependantCheckboxes', true); // if true - triggering checkbox will affect parent and child nodes.
	this.defineConfigOption('selectable', false); // If tree content can be selected by mouse
	this.defineConfigOption('editable', false); // If tree nodes can be renamed inline
	this.defineConfigOption('editAsText', true); // edit node content as plain text (no HTML is allowed) 
	this.defineConfigOption('editOnClick', false); // If tree node can be renamed when clicking at node
	this.defineConfigOption('editOnDblclick', true); // If tree node can be renamed when double clicking at node
	this.defineConfigOption('disableContextMenu', false); // If true - no browser context menu will be displayed while clicking on node labels.

	// super call
	Zapatec.Tree.SUPERclass.configure.call(this, objArgs);

	this.config.parent = Zapatec.Widget.getElementById(this.config.parent);
	this.config.tree = Zapatec.Widget.getElementById(this.config.tree);

	// processing deprecated 'tree' option.
	if(
		this.config.tree != null
	){
		if(this.config.source == null){
			this.config.source = this.config.tree;
		} else {
//			Zapatec.Log({description: "'tree' config option is deprecated. Please use 'source' instead. Option ignored."})
		}
	}
	
	if(typeof(this.config.hiliteSelectedNode) != 'undefined' && this.config.hiliteSelectedNode != null){
		this.config.highlightSelectedNode = this.config.hiliteSelectedNode;
	}

	if(this.config.parent == null && this.config.tree == null){
		Zapatec.Log({description: "No 'parent' or 'tree' config options given. Unable to add tree."});
		throw("No 'parent' or 'tree' config options given. Unable to add tree.");
	}

	if(this.config.labelDblClick != null){
//		Zapatec.Log({description: "'labelDblClick' config option is deprecated. Please use 'expandOnLabelDblclick' instead."})
		this.config.expandOnLabelDblclick = this.config.labelDblClick;
	}

	if(this.config.expandOnLabel != null){
//		Zapatec.Log({description: "'expandOnLabel' config option is deprecated. Please use 'expandOnLabelClick' instead."})
		this.config.expandOnLabelClick = this.config.expandOnLabel;
	}

	if(this.config.initLevel == false){
		//backward compartibility
		this.config.initLevel = 1;
	}

	if(this.config.initLevel < 1){
		this.config.initLevel = 1;
	}

	if(
		this.config.saveState &&
		(
			!this.config.saveId ||
			typeof(this.config.saveId) != 'string' ||
			this.config.saveId.length == 0
		)
	){
		Zapatec.Log({description: "No 'saveId' is given. 'saveState' feature disabled."});
		this.config.saveState = false;
	}

	if(this.config.createWholeDOM && this.config.quick){
		this.config.quick = false;
		Zapatec.Log({description: "Config option 'createWholeDOM' overrides 'quick' config option"});
	}
	
	if(this.config.selectMultiple){
		// disable keyboard navigation if selectMultiple feature is used.
		this.config.keyboardNavigation = false;
	}

	if(this.config.keyboardNavigation && typeof(this.config.deselectOnLeave) == 'undefined'){
		this.config.deselectOnLeave = true;
	}

	if(!this.config.putCheckboxes){
		this.config.dependantCheckboxes = false;
	}
};

/**
 * Reconfigures the tree with new config options after it was initialized.
 * May be used to change look or behavior of the tree after it has loaded
 * the data. In the argument pass only values for changed config options.
 * There is no need to pass config options that were not changed.
 *
 * @param {object} objArgs Changes to user configuration
 */
Zapatec.Tree.prototype.reconfigure = function(objArgs){
	if(objArgs.theme){
		Zapatec.Utils.removeClass(this.container, 
			this.getClassName({prefix: "zpTree", suffix: "Container"}));
	}

	// Call parent method
	Zapatec.Tree.SUPERclass.reconfigure.call(this, objArgs);

	Zapatec.Utils.addClass(this.container, 
		this.getClassName({prefix: "zpTree", suffix: "Container"}));
};

/**
 * Extends parent method.
 * @private
 */
Zapatec.Tree.prototype.addStandardEventListeners = function() {
  // Call parent method
  Zapatec.Tree.SUPERclass.addStandardEventListeners.call(this);
  // Add tree specific event listeners
  this.addEventListener('fetchSourceError', this.displayErrorSource);
};

/**
 * Displays error when external source is malformed.
 * @private
 */
Zapatec.Tree.prototype.displayErrorSource = function(oError) {
  alert("The tree's data source, " + this.config.source +
   " does not contain valid data.\n" + oError.errorDescription);
};


/**
 * Finds first node in a tree where findFunc returns true
 * @param {function} search criterion
 * @return Founded node or null if nothing founded
 * @type Object
 */
Zapatec.Tree.prototype.find = function(findFunc){
	for(var ii = 0; ii < this.allNodes.length; ii++){
		if(this.allNodes[ii] != null && findFunc(this.allNodes[ii])){
			return this.allNodes[ii];
		}
	}
};

/**
 * Finds all nodes in a tree where findFunc returns true
 * @param {function} search criterion
 * @return Founded Zapatec.Tree.Node instance or null if nothing founded
 * @type Object
 */
Zapatec.Tree.prototype.findAll = function(findFunc){
	var result = [];

	for(var ii = 0; ii < this.allNodes.length; ii++){
		if(findFunc(this.allNodes[ii])){
			result.push(this.allNodes[ii]);
		}
	}
	return result;
};

/**
 * Call this function to toggle all items in the tree.
 */
Zapatec.Tree.prototype.toggleAll = function() {
	for(var ii = 0; ii < this.allNodes.length; ii++){
		this.allNodes[ii].toggle();
	}
};

/**
 * Get node by its ID
 * @param {string} ID
 * @param {boolean} omitWarning If true - do not show error message
 * @return Founded node or null if nothing founded
 * @type Object
*/
Zapatec.Tree.prototype.getNode = function(id, omitWarning){
	var node = this.id2Obj[id];

	if(node == null){
		if(!omitWarning){
			Zapatec.Log({description: "No node found for id '" + id + "'"});
		}
		return;
	}

	return node;
};

/**
 * Synchronize tree to given node. Tree will be expanded to that node and that 
 *	node will be selected.
 * @param {string} node ID
 */
Zapatec.Tree.prototype.sync = function(itemId) {
	var node = this.getNode(itemId);

	if(node){
		node.sync();
	}
};

/**
 * You can expand, collapse or toggle a specific item
 * @param nodeId {string} node ID.
 * @param state {boolean} If true - expand node, false - collapse, null - toggle
 */
Zapatec.Tree.prototype.toggleItem = function(nodeId, state){
	var node = this.getNode(nodeId);

	if(!node){
		return;
	}

	if(state == true){
		node.expand();
	} else if(state == false){
		node.collapse();
	} else if(state == null){
		node.toggle();
	}
};

/**
 * Append a child to the start or end of the given parent. 
 * 
 * @param newChild {object} reference to an HTML element created of type LI or 
 *	JSON object with data.
 * @param parent {object} ID of parent node where new child will be added. If 
 *	null - add to top level.
 * @param atStart {boolean} optional. If true if the child going to be added 
 *	at the start of the parent.
 * @return newly created node
 * @type Object
 */
Zapatec.Tree.prototype.appendChild = function(newChild, parent, atStart) { 
	if(this.config.prevCompatible){
		// backward compartibility. Before 2.1 method signature was parent, newChild, atStart
		var tmp = parent;
		parent = newChild;
		newChild = tmp;
	}

	if(parent == null){
		parent = this.rootNode;
	} else {
		parent = this.getNode(parent);
	}

	if(parent == null){
		return null;
	}

	return parent.appendChild(newChild, atStart);
};
 
/** 
 * A new child can be inserted before some node.
 * @param newChild {object} New child node to be inserted into the tree. HTML 
 *	element or JSON object.
 * @param refChild {object} ID of the child node which the new child node will 
 *	be inserted before
 * @return newly created node
 * @type Object
 */
Zapatec.Tree.prototype.insertBefore = function(newChild, refChild) { 
	refChild = this.getNode(refChild);

	if(refChild == null){
		return null;
	}

	return refChild.insertBefore(newChild);
};

/**
 * A new child can be inserted after some nodes.
 * @param newChild {object} New child node to be inserted into the tree. HTML 
 *	element or JSON object.
 * @param refChild {object} ID of the child node which the new child node will 
 *	be inserted after.
 * @return newly created node
 * @type Object
 */
Zapatec.Tree.prototype.insertAfter = function(newChild, refChild) { 
	refChild = this.getNode(refChild);

	if(refChild == null){
		return null;
	}

	return refChild.insertAfter(newChild);
};
 
/** 
 * Remove child in the tree.
 * @param {object} ID of node.
 */
Zapatec.Tree.prototype.removeChild = function(oldChild) { 
	oldChild = this.getNode(oldChild);

	if(oldChild == null){
		return null;
	}

	oldChild.destroy();
};

/**
 * Call this function to collapse all items in the tree.
 */
Zapatec.Tree.prototype.collapseAll = function() {
	for(var ii = 0; ii < this.allNodes.length; ii++){
		this.allNodes[ii].collapse();
	}
};

/**
 * Collapses the tree up to the given level.
 * @param level {int} level to collapse.
 */
Zapatec.Tree.prototype.collapseToLevel = function(level) {
	for(var ii = 0; ii < this.allNodes.length; ii++){
		if(this.allNodes[ii].config.level > level){
			this.allNodes[ii].collapse();
		}
	}
};

/**
 * Call this function to expand all items in the tree.
 */
Zapatec.Tree.prototype.expandAll = function() {
	for(var ii = 0; ii < this.allNodes.length; ii++){
		this.allNodes[ii].expand();
	}
};

/**
 * Expands tree up to given level.
 * @param level {int} level to expand.
 */
Zapatec.Tree.prototype.expandToLevel = function(level) {
	this.expandToLevelNum = level;
	for(var ii = 0; ii < this.allNodes.length; ii++){
		if(this.allNodes[ii].config.level <= level){
			this.allNodes[ii].expand();
		}
	}
};

/**
* @private Function to load tree content on tree load from JSON source.
* @param objResponse {Object} Server response
*/
Zapatec.Tree.prototype.loadDataJson = function(objResponse){
	if(objResponse == null){
		return null;
	}

	// remove in next releases
	if(this.config.jsonLoadCallback){
		objResponse = this.config.jsonLoadCallback(objResponse);
	}

	this.rootNode.data = {};
	this.rootNode.data.children = objResponse;
	this.rootNode.createChildren();	

	for(var ii = 0; ii < this.rootNode.children.length; ii++){
		this.rootNode.children[ii].afterCreate();
	}

	// try to use saveState for loaded subtree
	if(this.config.saveState && !this.isSaveStateDone){
		var txt = Zapatec.Utils.getCookie("Zapatec.Tree-" + this.config.saveId);
		var node = this.getNode(txt, true);

		if (node){
			this.isSaveStateDone = true;
			node.sync();
		}
	}

};

/**
* @private Function to load tree content on tree load
* @param objResponse {Object} Server response
* TODO add format description
*/
Zapatec.Tree.prototype.loadDataXml = function(objSource){
	if(objSource == null || objSource.documentElement == null){
		return null;
	}

	var result = [];

	for(var jj = 0; jj < objSource.documentElement.childNodes.length; jj++){
		var tmp = Zapatec.Tree.Utils.convertXml2Json(objSource.documentElement.childNodes[jj]);

		if(tmp != null){
			result.push(tmp);
		}
	}

	return this.loadDataJson(result);
};

/**
* \internal Function to load tree content on tree load from HTML element
* @param objResponse {Object} Server response
* Format description: Common HTML list - &lt;UL&gt;&lt;LI&gt;...&lt;/LI&gt;...&lt;/UL&gt;
*/
Zapatec.Tree.prototype.loadDataHtml = function(objSource){
	if(objSource == null){
		return null;
	}

	var result = [];

	for(var jj = 0; jj < objSource.childNodes.length; jj++){
		var tmp = Zapatec.Tree.Utils.convertLi2Json(objSource.childNodes[jj], this.config.prevCompatible);

		if(tmp != null){
			result.push(tmp);
		}
	}

	return this.loadDataJson(result);
};

/**
* @deprecated
 * Call this function to create a html element with the optional element type specified.
 * By default, it is a &lt;LI&gt; element.
 * @param html {String} html of the node; may include &lt;UL&gt;, &lt;LI&gt;
 *	elements; user is responsible for the content of the html. 
 * @param type {String} type of the node to be created
*/
Zapatec.Tree.prototype.makeNode = function(html, type){
	if (!type) { 
		 type = "li"; //Make it a <LI> node if the type is not specified.
	}

	var node = Zapatec.Utils.createElement(type);

	if (html) {
	    if(this.config.quick){
			node.innerHTML = html;
		} else {
			Zapatec.Transport.setInnerHtml({html: html, container: node}); //Assign the inner html of the node if it is specified.
		}
	}
	
	return node;
};

/**
 * Destroy this instance.
 *
 * @param leaveDOM {boolean} If true - DOM tree will be preserved
 */
Zapatec.Tree.prototype.discard = function(leaveDOM){
    if(this.rootNode){
		this.rootNode.destroy(true);
	}

	if(this.container){
		this.container.zpTree = null;
	}

	zapatecTree.all[this.id] = null;
	
	this.allNodes = null;
	this.rootNode = null;
	
	if(!leaveDOM){
		zapatecUtils.destroy(this.container);
	}
	
	this.container = null;
	this.id2Obj = null;
	
	// Call parent method
	zapatecTree.SUPERclass.discard.call(this);
};

/**
 * Simply calls {@link Zapatec.Tree#discard}.
 *
 * @deprecated
 * @private
 * @param leaveDOM {boolean} If true - DOM tree will be preserved
 */
Zapatec.Tree.prototype.destroy = function(leaveDOM){
	this.discard(leaveDOM);
};

/**
 * @deprecated
 * Third party code can override this member in order to add an event handler
 * that gets called each time a tree item is selected. It receives a single
 * string parameter containing the item ID.
 */
Zapatec.Tree.prototype.onItemSelect = function() {};

/**
 * Returns JSON with current tree state. This object can be stored and used to
 *	create tree with completely same structure.
 * @return JSON with tree data.
 * @type Object
 */
Zapatec.Tree.prototype.getState = function(){
	var result = [];
	
	for(var ii = 0; ii < this.rootNode.children.length; ii++){
		result.push(this.rootNode.children[ii].getState());
	}

	return result;
};

/** 
 * Call to get the parent to append, insert or remove a child either at start 
 * or end position or in between two nodes of the (sub-)tree. 
 * 
 * @deprecated
 * @param id {String} -- id of the parent the new child will be added to or inserted before/at. 
 * @param mode {String} -- "I" is for inserting a child node. "R" is for removing a child node.  
 */ 
Zapatec.Tree.prototype.getParent = function(id, mode) { 
	return id;	
};

/**
 * @private
 * Create and attach events for keyboard navigation
 */
Zapatec.Tree.prototype.attachNavigation = function(){
	var self = this;
	
	// process clicks at tree container
	Zapatec.Utils.addEvent(this.container, "click", 
		function(){
			self.isActive = true; 
			self.isClicked = true;
		}
	);
	
	this.setEventHandlers();
	
	var func = function(evt){return self.keyEvent(evt);};

	// process all document key hits
	// For IE we must use "keydown" instead of "keypress"
	Zapatec.Utils.addEvent(document, (Zapatec.is_ie ? "keydown" : "keypress"), func);

	this.eventHandlers["key"] = {
	    element: document,
	    event: Zapatec.is_ie ? "keydown" : "keypress",
	    handler: func
	};
	
	func = function(){
		if(!self.isClicked){
			self.leave();
		}
		
		self.isClicked = false;
	};

	// process al document clicks
	Zapatec.Utils.addEvent(document, 'click', func);

	this.eventHandlers["click"] = {
	    element: document,
	    event: "click",
	    handler: func
	};

};

/**
 * @private
 * Process key events in the document.
 * @param event {Object} Event object.
 */
Zapatec.Tree.prototype.keyEvent = function(evt){
	if(!this.prevSelected || !this.isActive){
		// if no node is selected or this tree is not active at a moment - do nothing.
		return true;
	}

	if(!evt){
		evt = window.event;
	}

	if(!this.config.keyboardNavigation && !this.config.editable){
		return;
	}

	var res = Zapatec.Utils.getCharFromEvent(evt);

	this.fireEvent("keypressed", res.charCode, res.chr);

	if(res.charCode == 27){
		// ESC key
		this.leave();
	}
	
	if(res.chr == " "){
		res.charCode = 32;
	}

	if(
		this.config.keyboardNavigation && 
		(
			!this.config.editable ||
			this.config.editable &&
			this.editInline && !this.editInline.selectedNode
		)
	){
		switch(res.charCode){
			case 32: // space bar
				if(this.config.putCheckboxes){
					this.prevSelected.checkboxChanged();
				}
				// fall through
			case 13: // enter key
				this.prevSelected.toggle();
				Zapatec.Utils.stopEvent(evt);
				break;
			case 63234: //left arrow in Safari
			case 37: // left arrow
				if(this.prevSelected.data.isExpanded){
					this.prevSelected.collapse();
				} else {
					if(!this.prevSelected.config.parentNode.isRootNode){
						this.prevSelected.config.parentNode.select();
					}
				}
	    
				break;
			case 63235: //right arrow in Safari
			case 39: // right arrow
				if(!this.prevSelected.data.isExpanded){
					this.prevSelected.expand();
				} else {
					if(this.prevSelected.children != null && this.prevSelected.children.length > 0){
						this.prevSelected.children[0].select();
					}
				}
				break;
			case 63232: //up arrow in Safari
			case 38: // up arrow
				var prevNode = Zapatec.Tree.Utils.getPrevNode(this.prevSelected);
	    
				if(prevNode){
					prevNode.select();
					Zapatec.Utils.stopEvent(evt);
				}
	    
				break;
			case 63233: //down arrow in Safari
			case 40: // down arrow
				var nextNode = Zapatec.Tree.Utils.getNextNode(this.prevSelected);
	    
				if(nextNode){
					nextNode.select();
					Zapatec.Utils.stopEvent(evt);
				}
	    
				break;
		}
	}

	if(this.config.editable && this.editInline.selectedNode){
		if(res.charCode == 9){ // tab key
			var otherNode = null;
    
			// if tree is editable and currently some node is editing
			if(evt.shiftKey){
				otherNode = Zapatec.Tree.Utils.getPrevNode(this.editInline.selectedNode);
			} else {
				otherNode = Zapatec.Tree.Utils.getNextNode(this.editInline.selectedNode);
			}
			
			if(otherNode){
				this.editInline.saveAndHide();
				otherNode.select();
				this.editInline.show(otherNode.getLinkToLabelElement());
        
				Zapatec.Utils.stopEvent(evt);
			}
		}
	}
};

/**
 * @private
 * Leave tree.
 */
Zapatec.Tree.prototype.leave = function(){
	if(this.prevSelected && this.config.deselectOnLeave){
		this.prevSelected.deselect();
	}
	
	this.isActive = false;

	this.fireEvent("leave");
};
