/**
 * Default JSON format:
 *	{
 *		label: [string], // node label. It will be clickable. Required.
 *		isExpanded: [boolean, optional], // if this branch is expanded. Default value - false. This option will be ignored if "children" section is null
 *		isSelected: [boolean, optional], // if this node is selected. Default value - false.
 *		isChecked: [boolean, optional], // if tree displays checkboxes for all items - if this is true - checkbox will be checked
 *		isEditable: [boolean, optional], // if current node is editable. Default value - true.
 *		expandedIcon: [string, optional], // string with IMG tag. This image will be shown when branch is expanded. This option will be ignored if "children" section is null.
 *		collapsedIcon: [string, optional], // string with IMG tag. This image will be shown when branch is collapsed. This option will be ignored if "children" section is null.
 *		fetchingIcon: [string, optional], // string with IMG tag. This image will be shown when branch is fetching its content. This option will be ignored if "children" section is null.
 *		elementIcon: [string, optional], // string with IMG tag. This image will be shown for a single node (without branch)
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
 * <strong>HTML:</strong>
 * Common HTML list - &lt;UL&gt;&lt;LI&gt;...&lt;/LI&gt;...&lt;/UL&gt;
 * <strong>XML:</strong>
 * TODO
*/
Zapatec.Tree.Node = function(objArgs){
	Zapatec.Tree.Node.SUPERconstructor.call(this, objArgs);
};

/**
 * Unique static id of the widget class. Gives ability for Zapatec#inherit to
 * determine and store path to this file correctly when it is included using
 * Zapatec#include. When this file is included using Zapatec#include or path
 * to this file is got using Zapatec#getPath, this value must be specified
 * as script id.
 * @private
 */
Zapatec.Tree.Node.id = "Zapatec.Tree.Node";

// Inherit SuperClass
Zapatec.inherit(Zapatec.Tree.Node, Zapatec.Widget);

/**
 * Configures tree. Gets called from parent init method.
 *
 * @private
 * @param {object} objArgs User configuration
 */
Zapatec.Tree.Node.prototype.configure = function(objArgs) {
	this.defineConfigOption('theme', null); // node has no themes
	this.defineConfigOption('tree', null); // reference to parent Zapatec.Tree object
	this.defineConfigOption('parentNode', null); // reference to parent Zapatec.Tree.Node object
	this.defineConfigOption('level'); // level of this node
	this.defineConfigOption('isRootNode', false); // is this node a tree root node (actually virtual node). Do not document this confg option

	Zapatec.Tree.Node.SUPERclass.configure.call(this, objArgs);

	if(this.config.tree == null){
		Zapatec.Log({description: "No reference to parent Zapatec.Tree instance! Aborting."});
		throw("No reference to parent Zapatec.Tree instance! Aborting.");
	}
};

/**
 * @private
 * Initializes tree.
 * @param {object} objArgs User configuration
 */
Zapatec.Tree.Node.prototype.init = function(config) {
	this.expandedIcon = null; // this icon will be displayed for expanded branch
	this.collapsedIcon = null; // this icon will be displayed for collapsed branch
	this.fetchingIcon = null; // this icon will be displayed when node is fetching its content
	this.elementIcon = null; // this icon will be displayed when node is not a branch
	this.isCreated = false; // is table structure for this node created.
	this.isChildrenCreated = false; // is table structure for childnodes created
	this.isFetching = false; // is node fetching its content at a moment
	this.data = null; // JSON data for this node
	this.children = []; // array of child nodes
	this.labelContainer = null; // reference to label container (top DIV element)
	this.iconElement = null; // reference to icon element (icons)(TD)
	this.signElement = null; // reference to sign element (plus/minus)(TD)
	this.childrenContainer = null; // reference to elements that holds children (DIV)
	this.checkboxContainer = null; // reference to checkbox element

	this.oldSource = null; // temp variable that is used for fetch logic 
	this.oldSourceType = null; // temp variable that is used for fetch logic

	Zapatec.Tree.Node.SUPERclass.init.call(this, config);

	if(!this.config.isRootNode){
		// add reference to Z.Tree#allNodes array
		this.config.tree.allNodes.push(this);
	}

	// load initial data
	this.loadData();

	// clear source (not to load data one more time)
	this.config.source = null;
	this.config.sourceType = null;

	if(!this.config.isRootNode){
		// extract source && sourceType from callName if possible. And next time node will be expanded - children nodes will be loaded from this source
		if(this.data.attributes && this.data.attributes['class']){
			var md = null;

			// Process element's className. If it has zpLoadHTML or zpLoadXML or zpLoadJSON - fill source&&sourceType

			if(md = this.data.attributes['class'].match(/zpLoad(JSON|HTML|XML)=([^ $]*)/)){
				this.data.source = md[2];

				if(md[1] == "JSON"){
					this.data.sourceType = "json/url";
				} else if(md[1] == "HTML"){
					this.data.sourceType = "html/url";
				} else if(md[1] == "XML"){
					this.data.sourceType = "xml/url";
				} else {
					this.data.source = null;
					this.data.sourceType = null;
				}
			}
		}

		if(this.data.source){
			// if node has source&&sourceType - we must to display +/- sign
			// if node has zpLoadAlways mark - no predefined children allowed
			if(
				this.data.children == null ||
				this.data.loadAlways
			){
				this.data.children = [];
			}
			
			this.config.source = this.data.source;
			this.config.sourceType = this.data.sourceType;
		}
	}
};

/**
 * Adds standard event listeners.
 */
Zapatec.Tree.Node.prototype.addStandardEventListeners = function(){
	Zapatec.Tree.Node.SUPERclass.addStandardEventListeners.call(this);

 // put fetching icon if fetching URL from remote source
	this.addEventListener('fetchSourceStart', function(){
		this.isFetching = true;

		this.putIcons();
	});

	// when source is fetched - remove "fetching icon"
	this.addEventListener("fetchSourceEnd", function(){
		this.isFetching = false;

		this.putIcons();
	});

	var tmpFunc = function(){
		if(
			this.data && 
			this.data.loadAlways
		){
			for(var ii = this.children.length - 1; ii >= 0; ii--){
				this.children[ii].destroy(true);
			}
			
			this.data.children = [];
	    
			if(this.childrenContainer){
				this.childrenContainer.innerHTML = "";
			}
		}
	};

	this.addEventListener('loadDataStart', tmpFunc);
	this.addEventListener('fetchSourceStart', tmpFunc);

	// when data is loaded - process it.
	this.addEventListener('loadDataEnd', function(){
		this.oldSource = this.config.source;
		this.oldSourceType = this.config.sourceType; 
		this.config.source = null;
		this.config.sourceType = null;

		if(!this.config.isRootNode && this.data.isExpanded){
			this.expand();
		}

		if(
			this.data && 
			this.data.loadAlways
		){
			this.config.source = this.oldSource;
			this.config.sourceType = this.oldSourceType;
		}
	});

	// if there was error retrieving source - restore source&&sourceType. So on next node expand Tree will try to fetch source one more time.
	this.addEventListener("fetchSourceError", function(objError){
		if(
			this.data && 
			this.data.loadAlways
		){
			this.config.source = this.oldSource;
			this.config.sourceType = this.oldSourceType; 
		}

		Zapatec.Log({description: "Error happend while retrieving branch content: " + objError.errorCode + " " + objError.errorDescription});
	});
};

/**
* Create table structure for this node
**/
Zapatec.Tree.Node.prototype.create = function(){
	// if node is created or no data for this node or this is root node of the tree
	if(this.data == null || this.config.isRootNode){
		return null;
	}

	this.fireEvent("beforeCreate");

	var content = [];

	// main container for this node
	content.push("<div class='tree-item");
	content.push(this.hasSubtree() ? " tree-item-more " : "" );
	content.push("'");
	
	this.labelContainerId = "zpTree"+this.config.tree.id+"Node"+this.id+"LabelContainer";
	
	content.push(" id='");
	content.push(this.labelContainerId);
	content.push("'>");

	content.push("<table class='tree-table' cellpadding='0' cellspacing='0'><tbody><tr>");
	
	if(
		this.hasSubtree()
	){
		// display +/- element
		content.push("<td id='");
		content.push("zpTree");
		content.push(this.config.tree.id);
		content.push("Node");
		content.push(this.id);
		content.push("SignElement");
		content.push("'");
		content.push(" onclick='Zapatec.Widget.callMethod(");
		content.push(this.id);
		content.push(", \"onSignClick\")'");
		content.push(" ondblclick='Zapatec.Widget.callMethod(");
		content.push(this.id);
		content.push(", \"onSignDblclick\")'");

		content.push(" class='tgb ");
		content.push(this.data.isExpanded ? "minus" : "plus");
		content.push("'>");

		content.push("<img src='");
		content.push(Zapatec.zapatecPath);
		content.push("zpempty.gif' class='tgb' alt=''/>");

		content.push("</td>");
	}

	if(
		this.config.tree.config.defaultIcons ||
		(
			this.hasSubtree() && 
			(
				this.data.collapsedIcon || 
				this.data.expandedIcon ||
				this.data.fetchingIcon
			) ||
			!this.hasSubtree() &&
			(
				this.data.elementIcon ||
				this.data.fetchingIcon
	    	)
		)
	){
		content.push("<td");
		content.push(" id='zpTree");
		content.push(this.config.tree.id);
		content.push("Node");
		content.push(this.id);
		content.push("IconElement'");
		content.push(" onclick='Zapatec.Widget.callMethod(");
		content.push(this.id);
		content.push(", \"onIconClick\")'");
		content.push(" ondblclick='Zapatec.Widget.callMethod(");
		content.push(this.id);
		content.push(", \"onIconDblclick\")'");
		content.push(" oncontextmenu='return Zapatec.Widget.callMethod(");
		content.push(this.id);
		content.push(", \"onIconContextMenu\", event)'");
		content.push(" onmouseup='return Zapatec.Widget.callMethod(");
		content.push(this.id);
		content.push(", \"onIconMouseup\", event)'");
		content.push(" class='icon ");
		
		if(this.config.tree.config.defaultIcons){
			content.push(this.config.tree.config.defaultIcons);
		}
		
		content.push("'>");
		
		// if there are icons defined for this node - use them instead of +/-
		if(
			this.data.collapsedIcon || 
			this.data.expandedIcon ||
			this.data.fetchingIcon ||
			this.data.elementIcon
		){
			if(this.hasSubtree()){
				if(this.data.expandedIcon){
					content.push(this.data.expandedIcon);
				}
	    
				if(this.data.collapsedIcon){
					content.push(this.data.collapsedIcon);
				}
	    
				if(this.data.fetchingIcon){
					content.push(this.data.fetchingIcon);
				}
			} else {
				content.push(this.data.elementIcon);
	    
				if(this.data.fetchingIcon){
					content.push(this.data.fetchingIcon);
				}
			}
		} else {
			// spacer
			content.push("<img src='");
			content.push(Zapatec.zapatecPath);
			content.push("zpempty.gif' class='icon' alt=''/>");
		}
			
		content.push("</td>");
	}

	if(this.config.tree.config.putCheckboxes){
		content.push("<td");
		content.push(" id='zpTree");
		content.push(this.config.tree.id);
		content.push("Node");
		content.push(this.id);
		content.push("CheckboxElement'");
		content.push(" onclick='Zapatec.Widget.callMethod(");
		content.push(this.id);
		content.push(", \"checkboxChanged\")'");
		content.push(" class='checkboxContainer ");
		content.push(this.data.isChecked ? "checkboxChecked" : "checkboxUnchecked")
		content.push("'>");

		// spacer
		content.push("<img src='");
		content.push(Zapatec.zapatecPath);
		content.push("zpempty.gif' class='checkboxContainer' alt=''/>");

		content.push("</td>");
	}

	var attributes = Zapatec.Utils.clone(this.data.attributes);

	// restore attributes.
	if(!attributes){
		attributes = {
			"id" : "zpTree" + this.config.tree.id + "Node" + this.id + "LabelElement",
			"onclick" : "Zapatec.Widget.callMethod("+ this.id +", \"onLabelClick\")",
			"ondblclick" : "Zapatec.Widget.callMethod("+ this.id +", \"onLabelDblclick\")",
			"oncontextmenu" : "return Zapatec.Widget.callMethod("+ this.id +", \"onLabelContextMenu\", event)",
			"onmouseup" : "Zapatec.Widget.callMethod("+ this.id +", \"onLabelMouseup\", event)",
			"class" : "label " + (this.data.children ? "menutitle" : "submenu")
		};
	} else {
		if(attributes.id == null){
			attributes.id = "zpTree" + this.config.tree.id + "Node" + this.id + "LabelElement";
		}

		if(attributes['class'] != null){
			attributes['class'] += " label " + (this.data.children ? "menutitle" : "submenu");
		} else {
			attributes['class'] = "label " + (this.data.children ? "menutitle" : "submenu");
		}

		if(attributes.onclick != null){
			attributes.onclick = "Zapatec.Widget.callMethod("+ this.id +", \"onLabelClick\");" + this.data.attributes.onclick;
		} else {
			attributes.onclick = "Zapatec.Widget.callMethod("+ this.id +", \"onLabelClick\");";
		}

		if(attributes.ondblclick != null){
			attributes.ondblclick = "Zapatec.Widget.callMethod("+ this.id +", \"onLabelDblclick\");" + this.data.attributes.ondblclick;
		} else {
			attributes.ondblclick = "Zapatec.Widget.callMethod("+ this.id +", \"onLabelDblclick\");";
		}

		if(attributes.oncontextmenu != null){
			attributes.oncontextmenu = "return Zapatec.Widget.callMethod("+ this.id +", \"onLabelContextMenu\", event);" + this.data.attributes.oncontextmenu;
		} else {
			attributes.oncontextmenu = "return Zapatec.Widget.callMethod("+ this.id +", \"onLabelContextMenu\", event);";
		}

		if(attributes.onmouseup != null){
			attributes.onmouseup = "Zapatec.Widget.callMethod("+ this.id +", \"onLabelMouseup\", event);" + this.data.attributes.onmouseup;
		} else {
			attributes.onmouseup = "Zapatec.Widget.callMethod("+ this.id +", \"onLabelMouseup\", event);";
		}
	}

	// create label node
	content.push("<td");

	
	if(Zapatec.is_ie){
		content.push(" unselectable='on'");
	}
	
	for(var attrName in attributes){
		var tmp = attributes[attrName];

		if(
			typeof(tmp) != 'string'
		){
			tmp += ""; // convert to string
		}
		
		if(tmp){
			var attrVal = tmp.replace(/'/g, "\\'");
			// FIXME javascript code is broken here
			content.push(" " + attrName + "='" + attrVal + "'");
		}
	}

	content.push(">");

	// for backward compatibility - put node content inside <span class="label"></span>
	if(this.config.tree.config.prevCompatible){
		content.push("<span class='label'>");
	}

	if(this.data.label){
		content.push(this.data.label);
	}

	if(this.config.tree.config.prevCompatible){
		content.push("</span>");
	}
	
	content.push("</td></tr></tbody></table></div>");

	if(this.data.isSelected){
		this.select();
	}

	if(this.hasSubtree()){
		content.push("<div class='tree' id='");
		content.push("zpTree");
		content.push(this.config.tree.id);
		content.push("Node");
		content.push(this.id);
		content.push("ChildrenContainer");
		content.push("'");
		content.push("></div>"); // class='tree tree-lined'
	}

	this.fireEvent("afterCreate");

	return content.join("");
};

/**
 * Determine if this node has subtree.
 * @return true if node has subtree, false - otherwise
 * @type boolean
 */
Zapatec.Tree.Node.prototype.hasSubtree = function(){
	if(!this.data){
		return;
	}

	return this.data.children != null;
};

/**
 * @private
 * Actually some hard work on creating element - getting references to its elements, putting icons etc.
 * This method is called only when node is shown.
 */
Zapatec.Tree.Node.prototype.afterCreate = function(){
	if(this.isCreated){
		return false;
	}

	var hasSubtree = this.hasSubtree();
	this.labelContainer = document.getElementById(this.labelContainerId);
	if(
		this.data.collapsedIcon || 
		this.data.expandedIcon ||
		this.data.fetchingIcon ||
		this.data.elementIcon
	){
		this.iconElement = this.labelContainer.childNodes[0].childNodes[0].childNodes[0].childNodes[hasSubtree ? 1 : 0];
	}
	
	if(hasSubtree){
		this.signElement = this.iconElement ? 
			this.iconElement.previousSibling : 
			this.labelContainer.childNodes[0].childNodes[0].childNodes[0].childNodes[0];

		this.childrenContainer = this.labelContainer.nextSibling;
	}

	if(this.config.tree.config.putBackReferences && this.getLinkToLabelElement()){
		Zapatec.Utils.createProperty(this.labelElement, "zpTreeNode", this);
	}

	if(
		this.data.collapsedIcon || 
		this.data.expandedIcon ||
		this.data.fetchingIcon ||
		this.data.elementIcon
	){
		if(this.iconElement && this.iconElement.childNodes.length != 0){
			var tmp = [
				this.iconElement.childNodes[0],
				this.iconElement.childNodes[1],
				this.iconElement.childNodes[2]
			];

			for(var ii = 0; ii <= 2; ii++){
				var tmpIcon = tmp[ii];

				if(!tmpIcon || tmpIcon.nodeType != 1 || tmpIcon.tagName.toLowerCase() != "img"){
					continue;
				}

				if(tmpIcon.className.indexOf("collapsedIcon") >= 0){
					this.collapsedIcon = tmpIcon;
				} else if(tmpIcon.className.indexOf("expandedIcon") >= 0){
					this.expandedIcon = tmpIcon;
				} else if(tmpIcon.className.indexOf("fetchingIcon") >= 0){
					this.fetchingIcon = tmpIcon;
				} else if(tmpIcon.className.indexOf("elementIcon") >= 0 || !hasSubtree){
					this.elementIcon = tmpIcon;
				}
			}
		}
	}

	this.isCreated = true;

	this.putIcons();
	this.putLines();

	if(this.data.isExpanded || this.config.tree.expandToLevelNum > this.config.level){
		this.expand();
	} else {
		this.collapse();
	}

	if(this.config.tree.config.putCheckboxes){
		var tmp = this.labelContainer.childNodes[0].childNodes[0].childNodes[0];
		this.checkboxContainer = tmp.childNodes[tmp.childNodes.length - 2];
	}

	if(this.data.isSelected){
		this.select();
	}

	if(this.config.tree.config.createWholeDOM){
		this.createChildren();
	}

	if(this.data.isChecked){
		this.checkboxChanged(this.data.isChecked);
	} else {
		this.updateCheckbox();
	}

	if(!this.config.isRootNode){
		this.fireEvent("nodeCreated");
	}
};

Zapatec.Tree.Node.prototype.getLinkToLabelElement = function(){
	if(this.config.isRootNode){
		return null;
	}

	if(this.labelElement){
		return this.labelElement;
	}
	
	this.labelElement = this.labelContainer.childNodes[0].childNodes[0].childNodes[0].lastChild;

	return this.labelElement;
};

/**
 * @private
 * Create childnodes for this branch
 */
Zapatec.Tree.Node.prototype.createChildren = function(){
	if(
		!this.hasSubtree() || 
		this.hasSubtree() && this.isChildrenCreated == true
	){
		return null;
	}

	// if this tree has "quick" option or this is root node - then child nodes are not created yet
	if(this.config.tree.config.quick || this.config.isRootNode){
		this.initChildren();
	}

	var content = [];

	// create all nodes
	for(var ii = 0; ii < this.children.length; ii++){
		content.push(this.children[ii].create());
	}

	// add HTML to child container
	if(this.config.tree.config.quick){
		this.childrenContainer.innerHTML = content.join("");
	} else {
		Zapatec.Transport.setInnerHtml({html: content.join(""), container: this.childrenContainer});
	}

	// put flag
	this.isChildrenCreated = true;

	if(this.config.tree.config.createWholeDOM){
		for(var ii = 0; ii < this.children.length; ii++){
			this.children[ii].afterCreate();
		}
	}
};

/**
 * @private init child nodes - create Zapatec.Tree.Node instances for each record
 *	in this.data.children and store this instances into this.children
 */
Zapatec.Tree.Node.prototype.initChildren = function(){
	if(!this.data.children){
		return null;
	}
	
	for(var ii = 0; ii < this.data.children.length; ii++){
		this.children.push(new Zapatec.Tree.Node({
			tree: this.config.tree,
			parentNode: this,
			level: this.config.level + 1,
			source: this.data.children[ii],
			sourceType: "json",
			eventListeners: this.config.eventListeners
		}));
	}
};

/**
 * Determine if this is first node in parent branch
 * @return true is this node is first node in parent branch, false otherwise
 * @type boolean
 */
Zapatec.Tree.Node.prototype.isFirstNodeInBranch = function(){
	return this.config.isRootNode || 
		this.labelContainer.parentNode.firstChild == this.labelContainer;
};

/**
 * Determine if this is LAST node in parent branch
 * @return true is this node is last node in parent branch, false otherwise
 * @type boolean
 */
Zapatec.Tree.Node.prototype.isLastNodeInBranch = function(){
	return this.config.isRootNode ||
		this.labelContainer.parentNode.lastChild == this.labelContainer ||
		this.labelContainer.parentNode.lastChild == this.childrenContainer;
};

/**
 * Function to control checkbox state.
 * @param value [boolean] if true - turn checkbox on. false - turn checkbox off.
 */
Zapatec.Tree.Node.prototype.checkboxChanged = function(value){
    if(!this.config.tree.config.putCheckboxes){
    	return;
    }

	if(typeof(value) == 'undefined'){
		value = !this.data.isChecked;
	}

	this.data.isChecked = value;

	if(this.isCreated){
		this.checkboxContainer.className = "checkboxContainer " +
			(this.data.isChecked ? "checkboxChecked" : "checkboxUnchecked");
	}

	this.fireEvent ("checkboxChanged", this.data.isChecked);

	if(!this.config.tree.config.dependantCheckboxes){
		return;
	}

	if(this.hasSubtree()){
		// turn on/off all child nodes
		var toCheck = this.data.isChecked;

		for(var ii = 0; ii < this.children.length; ii++){
			this.children[ii].checkboxChanged(toCheck);
		}
	}

	if(this.config.parentNode){
		this.config.parentNode.updateCheckbox();
	}
};

/**
 * @private
 * helper function to mark dependant checkboxes.
 */
Zapatec.Tree.Node.prototype.updateCheckbox = function(){
	if(this.config.isRootNode){
		return;
	}

	if(!this.config.tree.config.dependantCheckboxes){
		return;
	}

	var stats = this.getChildrenStats();

	if(stats.hasChecked && !stats.hasUnchecked){
		// if all child nodes are checked
		this.data.isChecked = true;

		if(this.isCreated){
			this.checkboxContainer.className = "checkboxContainer checkboxChecked";
		}
	} else if(stats.hasChecked && stats.hasUnchecked){
		// has either checked or unchecked
		this.data.isChecked = null;
    
		if(this.isCreated){
			this.checkboxContainer.className = "checkboxContainer checkboxHalfChecked";
		}
	} else if(!stats.hasChecked && stats.hasUnchecked){
		// if all children are unchecked
		this.data.isChecked = false;

		if(this.isCreated){
			this.checkboxContainer.className = "checkboxContainer checkboxUnchecked";
		}
	}
	
	if(this.config.parentNode){
		this.config.parentNode.updateCheckbox();
	}
};

/**
 * @private
 * Helper function to determine node checked state.
 * @return returns object with 2 keys:
 *	hasChecked: if true - node has at least one checked subnode or it is 
 *	checked itself (if it has no subchildren)
 *	hasUnchecked: if true - node has at least one unchecked subnode or it is 
 *	unchecked itself (if it has no subchildren)
 * @type Object
 */
Zapatec.Tree.Node.prototype.getChildrenStats = function(){
	var res = {
		hasChecked: this.data.isChecked == true,
		hasUnchecked: false
	};

	if(this.hasSubtree() && this.children.length > 0){
		for(var ii = 0; ii < this.children.length; ii++){
			var stats = this.children[ii].getChildrenStats();

			res.hasChecked = res.hasChecked || stats.hasChecked;
			res.hasUnchecked = res.hasUnchecked || stats.hasUnchecked;

			if(res.hasChecked && res.hasUnchecked){
				break;
			}
		}
	} else {
		res.hasChecked = this.data.isChecked;
		res.hasUnchecked = !this.data.isChecked;
	}

	return res;
};

/**
 * @private
 * Put classes to node to display tree lines correctly
 */
Zapatec.Tree.Node.prototype.putLines = function(){
	if(this.config.isRootNode){
		return null;
	}

	// remove all tree lines
	this.labelContainer.className = this.labelContainer.className.replace(/tree-lines-./, "");
	
	if(this.isFirstNodeInBranch()){
		if(this.isLastNodeInBranch()){
			// this is single node in branch
			if(this.config.level == 1){
				// single node in root node
				this.labelContainer.className += " tree-lines-s";
			} else {
				// single node in non-root node
				this.labelContainer.className += " tree-lines-b";
			}
		} else {
			// there is other nodes in branch
			if(this.config.level == 1){
				// top node in root node
				this.labelContainer.className += " tree-lines-t";
			} else {
				// top node in non-root node
				this.labelContainer.className += " tree-lines-c";
			}
		}
	} else if(this.isLastNodeInBranch()){
		// last node always (except when it is single node) has tree-lines-b
		this.labelContainer.className += " tree-lines-b";
	} else {
		// all other nodes in the middle
		this.labelContainer.className += " tree-lines-c";
	}

	if(this.hasSubtree()){
		// if tree has subtree

		if(this.isLastNodeInBranch()){
			// and this is last node - do not display left line
			this.childrenContainer.className = this.childrenContainer.className.replace(/\btree-lined\b/, "");
		} else {
			// otherwise - display left line
			this.childrenContainer.className += " tree-lined";
		}
	}
};

/**
 * @private
 * Put icons for node depending on its state
 */
Zapatec.Tree.Node.prototype.putIcons = function(){
	if(!this.isCreated){
		return null;
	}

	if(this.expandedIcon || this.collapsedIcon || this.fetchingIcon || this.elementIcon){
		if(this.elementIcon){
			this.elementIcon.style.display = this.isFetching && this.fetchingIcon ? "none" : "block";
		}

		if(this.fetchingIcon){
			this.fetchingIcon.style.display = this.isFetching ? "block" : "none";
		}

		if(this.expandedIcon){
			this.expandedIcon.style.display = !this.data.isExpanded || this.isFetching && this.fetchingIcon ? "none" : "block";
		}

		if(this.collapsedIcon){
			this.collapsedIcon.style.display = this.data.isExpanded || this.isFetching && this.fetchingIcon ? "none" : "block";
		}
	}
	
	if(this.signElement){
		if(this.isFetching){
			this.signElement.className = this.signElement.className.replace(/\b(plus|minus)\b/, "fetching");
		} else if(this.data.isExpanded){
			this.signElement.className = this.signElement.className.replace(/\b(plus|fetching)\b/, "minus");
		} else {
			this.signElement.className = this.signElement.className.replace(/\b(minus|fetching)\b/, "plus");
		}
	}
};

/**
 * @private
 * This method is invoked when icon is clicked
 */
Zapatec.Tree.Node.prototype.onIconClick = function(){
	this.fireEvent("iconClick");

	if(this.config.tree.config.selectOnIconClick){
		if(this.config.tree.config.deselectSelected && this.data.isSelected){
			this.deselect();
		} else {
			this.select();
		}
	}

	if(!this.config.tree.config.expandOnIconClick){
		return null;
	}

	this.toggle();
};

/**
 * @private
 * This method is invoked when icon is double clicked
 */
Zapatec.Tree.Node.prototype.onIconDblclick = function(){
	this.fireEvent("iconDblclick");

	if(this.config.tree.config.selectOnIconDblclick){
		if(this.config.tree.config.deselectSelected && this.data.isSelected){
			this.deselect();
		} else {
			this.select();
		}
	}

	if(!this.config.tree.config.expandOnIconDblclick){
		return null;
	}

	this.toggle();
};

/**
 * @private
 * When user right-clicks icon
 */
Zapatec.Tree.Node.prototype.onIconContextMenu = function(){
	return !this.config.tree.config.disableContextMenu;
}

/**
 * Fires when user clicks icon(actually mouseup). If this is right-click - event will be fired
 * @param {Object} ev
 */
Zapatec.Tree.Node.prototype.onIconMouseup = function(ev){
	if(!ev){
		ev = window.event;
	}
	
	if(Zapatec.Tree.Utils.isRightClick(ev)){
		this.fireEvent("iconRightClick", ev);
		
		Zapatec.Utils.stopEvent(ev);
		
		// Safari bug workaround
		ev.returnValue = true;
		
		return false;
	}
};

/**
 * @private
 * This method is invoked when +/- is clicked
 */
Zapatec.Tree.Node.prototype.onSignClick = function(){
	this.fireEvent("signClick");

	if(this.config.tree.config.selectOnSignClick){
		if(this.config.tree.config.deselectSelected && this.data.isSelected){
			this.deselect();
		} else {
			this.select();
		}
	}

	if(!this.config.tree.config.expandOnSignClick){
		return null;
	}

	this.toggle();
};

/**
 * @private
 * This method is invoked when +/- sign is double clicked
 */
Zapatec.Tree.Node.prototype.onSignDblclick = function(){
	this.fireEvent("signDblclick");

	if(this.config.tree.config.selectOnSignDblclick){
		if(this.config.tree.config.deselectSelected && this.data.isSelected){
			this.deselect();
		} else {
			this.select();
		}
	}

	if(!this.config.tree.config.expandOnSignDblclick){
		return null;
	}

	this.toggle();
};

/**
 * @private
 * This method is invoked when label is clicked 
 */
Zapatec.Tree.Node.prototype.onLabelClick = function(){
	this.fireEvent("labelClick");

	if(this.config.tree.config.selectOnLabelClick){
		if(this.config.tree.config.deselectSelected && this.data.isSelected){
			this.deselect();
		} else {
			this.select();
		}
	}

	if(this.config.tree.config.editable && this.config.tree.config.editOnClick && this.data.isEditable != false){
		this.config.tree.editInline.show(this.getLinkToLabelElement());
	}

	if(!this.config.tree.config.expandOnLabelClick){
		return null;
	}

	this.toggle();
};

/**
 * @private
 * This method is invoked when label is double clicked 
 */
Zapatec.Tree.Node.prototype.onLabelDblclick = function(){
	this.fireEvent("labelDblclick");

	if(this.config.tree.config.selectOnLabelDblclick){
		if(this.config.tree.config.deselectSelected && this.data.isSelected){
			this.deselect();
		} else {
			this.select();
		}
	}

	if(this.config.tree.config.editable && this.config.tree.config.editOnDblclick && this.data.isEditable != false){
		this.config.tree.editInline.show(this.getLinkToLabelElement());
	}

	if(!this.config.tree.config.expandOnLabelDblclick){
		return null;
	}

	this.toggle();
};

/**
 * @private
 * When user right-clicks node label
 */
Zapatec.Tree.Node.prototype.onLabelContextMenu = function(ev){
	if(!ev){
		ev = window.event;
	}
	
	if(Zapatec.is_khtml && Zapatec.Tree.Utils.isRightClick(ev)){
		// Safari fires only this event for right-clicks
		this.fireEvent("labelRightClick", ev);
		
		Zapatec.Utils.stopEvent(ev);
		
		// Safari bug workaround
		ev.returnValue = true;
	}

	return !this.config.tree.config.disableContextMenu;
}

/**
 * Fires when user clicks label (actually during mouseup). If this is right-click - event will be fired
 * @param {Object} ev
 */
Zapatec.Tree.Node.prototype.onLabelMouseup = function(ev){
	if(!ev){
		ev = window.event;
	}
	
	if(Zapatec.Tree.Utils.isRightClick(ev)){
		this.fireEvent("labelRightClick", ev);
		
		Zapatec.Utils.stopEvent(ev);
		
		// Safari bug workaround
		ev.returnValue = true;
		
		return false;
	}
};

/**
 * Select this node
 */
Zapatec.Tree.Node.prototype.select = function(){
	if(this.config.isRootNode){
		return null;
	}

	if(!this.config.tree.config.selectMultiple){
		if(this.config.tree.prevSelected){
			this.config.tree.prevSelected.deselect();
		}
	}

	this.data.isSelected = true;
	this.config.tree.prevSelected = this;

	if(this.config.tree.config.saveState){
		Zapatec.Utils.writeCookie("Zapatec.Tree-" + this.config.tree.config.saveId, this.data.attributes && this.data.attributes.id ? this.data.attributes.id : this.id, null, '/', 7);
	}
	
	if(this.isCreated && this.config.tree.config.highlightSelectedNode){
		Zapatec.Utils.addClass(this.labelContainer, "tree-item-selected");
	}

	this.fireEvent("select");

	if(this.config.tree.onItemSelect){
		this.config.tree.onItemSelect(this.data && this.data.attributes && this.data.attributes.id ? this.data.attributes.id : this.id);
	}
};

/**
 * Deselect this node
 */
Zapatec.Tree.Node.prototype.deselect = function(){
	if(this.config.isRootNode || !this.data.isSelected){
		return null;
	}

	if(this.isCreated){
		this.labelContainer.className = this.labelContainer.className.replace(/\btree-item-selected\b/, "");
	}

	this.data.isSelected = false;

	this.config.tree.prevSelected = null;

	this.fireEvent("deselect");
};

/**
 * Collapse branch at this node. (branches at child nodes won't be collapsed)
 */
Zapatec.Tree.Node.prototype.collapse = function(){
	this.data.isExpanded = false;
	
	if(!this.isCreated || !this.hasSubtree()){
		return null;
	}

	this.childrenContainer.style.display = 'none';

	if(!this.config.isRootNode){
		this.labelContainer.className = this.labelContainer.className.replace(/\btree-item-expanded\b/, "");
		this.labelContainer.className += " tree-item-collapsed";
		this.putIcons();
	}

	this.fireEvent("collapse");
};

/**
 * Collapse whole branch at this node (all child nodes also will be collapsed)
 */
Zapatec.Tree.Node.prototype.collapseBranch = function(){
	if(!this.children){
		return null;
	}

	for(var ii = 0; ii < this.children.length; ii++){
		this.children[ii].collapseBranch();
	}

	this.collapse();

	this.fireEvent("collapseBranch");
};

/**
 * Expand branch at this node. (branches at child nodes won't be expanded)
 */
Zapatec.Tree.Node.prototype.expand = function(){
	this.data.isExpanded = true;
	
	if(this.config.tree.config.compact){
		// we need to collapse all other expanded nodes
		var parentNodes = [];

		var parentNode = this;
		
		while(parentNode != null && !parentNode.config.isRootNode){
			parentNodes.push(parentNode);
			parentNode = parentNode.config.parentNode;
		}

		for(var ii = this.config.tree.allNodes.length - 1; ii >= 0 ; ii--){
			var node = this.config.tree.allNodes[ii];

			if(node.data && node.data.isExpanded){
				var isParent = false;

				for(var jj = parentNodes.length - 1; jj >= 0 ; jj--){
					if(node == parentNodes[jj]){
						isParent = true;
						break;
					}
				}

				if(!isParent){
					node.collapse();
				}
			}
		}
	}

	if(!this.isCreated || !this.hasSubtree()){
		return null;
	}

	if(!this.config.isRootNode){
		this.labelContainer.className = this.labelContainer.className.replace(/\btree-item-collapsed\b/, "");
		this.labelContainer.className += " tree-item-expanded";
		this.putIcons();
	}

	if(this.config.quick || this.children.length == 0){
		// If quick mode is chosen or node has no children - then all nodes 
		// (either predefined and loaded) will be displayed simultaneously
		if(this.config.source){
			if(!this.isFetching){
				this.loadData();
			}
		} else {
			this.childrenContainer.style.display = 'block';
			this.createChildren();

			for(var ii = 0; ii < this.children.length; ii++){
				if(!this.children[ii].isCreated){
					this.children[ii].afterCreate();
				}
			}
		}
	} else {
		// display predefined childnodes first and load other nodes after that.
		// If a lot of nodes will be loaded - use quick mode
		this.childrenContainer.style.display = 'block';
		this.createChildren();

		for(var ii = 0; ii < this.children.length; ii++){
			if(!this.children[ii].isCreated){
				this.children[ii].afterCreate();
			}
		}
		
		if(this.config.source){
			if(!this.isFetching){
				this.loadData();
			}
		}
	}

	this.fireEvent("expand");
};

/**
 * Expand whole branch at this node (all child nodes also will be expanded)
 */
Zapatec.Tree.Node.prototype.expandBranch = function(){
	if(!this.children){
		return null;
	}

	for(var ii = 0; ii < this.children.length; ii++){
		this.children[ii].expandBranch();
	}

	this.expand();

	this.fireEvent("expandBranch");
};

/**
 * Toggle branch at this node.
 */
Zapatec.Tree.Node.prototype.toggle = function(){
	this.fireEvent("toggle");

	if(this.data.isExpanded){
		return this.collapse();
	} else {
		return this.expand();
	}
};

/**
 * @private
 * Function to load tree content on tree load from JSON source.
 * @param objResponse {Object} Server response
 */
Zapatec.Tree.Node.prototype.loadDataJson = function(objResponse){
	if(objResponse == null){
		return null;
	}

	if(objResponse.expandedIcon){
		objResponse.expandedIcon = Zapatec.Tree.Utils.addIconClass(objResponse.expandedIcon, "expandedIcon");
	}

	if(objResponse.collapsedIcon){
		objResponse.collapsedIcon = Zapatec.Tree.Utils.addIconClass(objResponse.collapsedIcon, "collapsedIcon");
	}

	if(objResponse.fetchingIcon){
		objResponse.fetchingIcon = Zapatec.Tree.Utils.addIconClass(objResponse.fetchingIcon, "fetchingIcon");
	}

	if(objResponse.elementIcon){
		objResponse.elementIcon = Zapatec.Tree.Utils.addIconClass(objResponse.elementIcon, "elementIcon");
	}

	if(
		this.isCreated && 
		(
			!this.config.tree.config.quick || 
			this.config.tree.config.quick &&
			this.isChildrenCreated
		)
	){
		if(objResponse.children){
			for(var ii = 0; ii < objResponse.children.length; ii++){
				this.appendChild(objResponse.children[ii]);
			}
		}
	} else {
		if(this.data == null){
			// if loadData called for the first time.
			this.data = objResponse;
		} else {
			// or data is loaded dynamically
			if(objResponse.children){
				this.data.children = this.data.children.concat(objResponse.children);
			} else {
				this.data.children = objResponse.children;
			}


			this.updateCheckbox();
			// TODO change label, attributes, icons if needed
		}

		// if tree.config.quick option is false - create all childnodes
		if(!this.config.tree.config.quick || this.config.isRootNode){
			this.initChildren();
		}

		if(this.data.attributes && this.data.attributes.id){
			this.config.tree.id2Obj[this.data.attributes.id] = this;
		} else {
			this.config.tree.id2Obj[this.id] = this;
		}

		if(this.config.tree.config.dependantCheckboxes && this.config.parentNode.data.isChecked){
			this.data.isChecked = true;
		}
	}
};

/**
 * @private
 * Function to load tree content on tree load from XML source.
 * @param objResponse {Object} Server response
 */
Zapatec.Tree.Node.prototype.loadDataXml = function(objSource){
	if(objSource == null || objSource.documentElement == null){
		return null;
	}

	if(objSource.documentElement.tagName.toLowerCase() == "list"){
		var arr = [];
	
		for(var jj = 0; jj < objSource.documentElement.childNodes.length; jj++){
			try{
				var tmp = Zapatec.Tree.Utils.convertXml2Json(objSource.documentElement.childNodes[jj]);
			} catch(e){}
	    
			if(tmp != null){
				arr.push(tmp);
			}
		}

		this.loadDataJson({children: arr});
	} else {
		this.loadDataJson(Zapatec.Tree.Utils.convertXml2Json(objSource.documentElement));
	}
};

/**
 * @private
 * Function to load tree content on tree load from HTML source
 * @param objResponse {Object} Server response
 */
Zapatec.Tree.Node.prototype.loadDataHtml = function(objSource){
	if(objSource == null || !objSource.nodeName){
		return null;
	}

	if(objSource.nodeName.toLowerCase() == 'ul'){
		var arr = [];

		for(var ii = 0; ii < objSource.childNodes.length; ii++){
			var tmp = Zapatec.Tree.Utils.convertLi2Json(objSource.childNodes[ii], this.config.tree.config.prevCompatible);
			if(tmp != null){
				arr.push(tmp);
			}
		}

		this.loadDataJson({children: arr});
	} else {
		this.loadDataJson(Zapatec.Tree.Utils.convertLi2Json(objSource, this.config.tree.config.prevCompatible));
	}
};

/**
 * @private
 * Zapatec.Widget's method showContainer is unavailable for this class
 */
Zapatec.Tree.Node.prototype.showContainer = function(){};

/**
 * @private
 * Zapatec.Widget's method hideLoader is unavailable for this class
 */
Zapatec.Tree.Node.prototype.hideContainer = function(){};

/**
 * Expands all parent nodes for this node.
 */
Zapatec.Tree.Node.prototype.expandHere = function(){
	if(this.config.isRootNode){
		return null;
	}

	var parentNodes = [];
	var parentNode = this.config.parentNode;
	
	while(parentNode != null){
		parentNodes.push(parentNode);
		parentNode = parentNode.config.parentNode;
	}

	for(var ii = parentNodes.length - 1; ii >= 0; ii--){
		parentNodes[ii].expand();
	}
};

/**
 * Sync tree to this node. Tree will be expanded to this node and this node will be selected
 */
Zapatec.Tree.Node.prototype.sync = function(){
	if(this.config.isRootNode){
		return null;
	}

	this.expandHere();

	this.select();
};

/**
 * Destroy this node.
 * @param quick {boolean} If true - do not remove dependant DOM elements
 */
Zapatec.Tree.Node.prototype.destroy = Zapatec.Tree.Node.prototype.discard = function(quick){
	if(!this.config){
		return;
	}

	if(this.isCreated && !quick){
		Zapatec.Utils.destroy(this.labelContainer);
	
		if(this.hasSubtree()){
			Zapatec.Utils.destroy(this.childrenContainer);
		}
	}

	// remove children
	if(this.children){
		for(var ii = this.children.length - 1; ii >= 0; ii--){
			this.children[ii].destroy(true);
		}
	}
	
	if(this.config.isRootNode){
		return;
	}

	// clean internal arrays
	var childIndex = null;
	var childrenArray = this.config.parentNode.children;

	for(var ii = 0; ii < childrenArray.length; ii++){
		if(childrenArray[ii] == this){
			childIndex = ii;
			break;
		}
	}

	if(childIndex == null){
		// child is not found. impossible
	} else {
		if(childIndex != 0 && childrenArray[childIndex - 1].isCreated){
			// if that was not first child - redraw lines for previous node
			childrenArray[childIndex - 1].putLines();
		}

		if(childIndex != childrenArray.length - 1 && childrenArray[childIndex + 1].isCreated){
			// if that was not last child - redraw lines for next node
			childrenArray[childIndex + 1].putLines();
		}

		// removing current node from children array
		childrenArray = childrenArray.slice(0, childIndex).concat(childrenArray.slice(childIndex + 1));

		this.config.parentNode.children = childrenArray;
	}

	// removing this node from Zapatec.Tree#allNodes array
	for(var ii = 0; ii < this.config.tree.allNodes.length; ii++){
		if(this.config.tree.allNodes[ii] == this){
			childIndex = ii;
			break;
		}
	}

	if(childIndex == null){
		// impossible
	} else {
		this.config.tree.allNodes = this.config.tree.allNodes.slice(0, childIndex).concat(this.config.tree.allNodes.slice(childIndex + 1));
	}

	// clean id2Obj hash
	if(this.data.attributes && this.data.attributes.id){
		this.config.tree.id2Obj[this.data.attributes.id] = null;
	} else {
		this.config.tree.id2Obj[this.id] = null;
	}
	
	if(this.config.tree.prevSelected == this){
		this.config.tree.prevSelected = null;
	}

	if(this.config.parentNode){
		this.config.parentNode.updateCheckbox();
	}
	
	Zapatec.Tree.Node.SUPERclass.discard.call(this);
};

/**
 * Adds node to this node children.
 * @param newChild {Object} JSON array with data. If this is &lt;LI&gt; node - it will be converted to JSON. @see Zapatec.Tree.Utils.convertLi2Json
 * @param insertPosition {int} Where to insert node in this branch
 * @return reference to newly created Zapatec.Tree.Node instance
 * @type Object
 */
Zapatec.Tree.Node.prototype.addNode = function(newChild, insertPosition){
	if(
		newChild != null &&
		newChild.nodeType &&
		newChild.nodeType == 1 &&
		newChild.nodeName.toLowerCase() == "li"
	){
		newChild = Zapatec.Tree.Utils.convertLi2Json(newChild, this.config.tree.config.prevCompatible); 
	}

	if(newChild == null){
		Zapatec.Log({description: "No data given!"});
		return null;
	}

	this.convertToBranch();

	var resultNode = newChild;

	this.data.children.splice(insertPosition, 0, newChild);

	if(this.isCreated || !this.config.tree.quick){
		 resultNode = new Zapatec.Tree.Node({
			tree: this.config.tree,
			parentNode: this,
			level: this.config.level + 1,
			source: newChild,
			sourceType: "json",
			eventListeners: this.config.eventListeners
		});

		if(this.isChildrenCreated){
			var prevNode = null;
			var nextNode = null;
			var insertBeforeElement = null;

			if(insertPosition != 0){
				prevNode = this.children[insertPosition - 1];
			}

			if(insertPosition != this.children.length){
				nextNode = this.children[insertPosition];
				insertBeforeElement = nextNode.labelContainer;
			}

			var tmp = document.createElement("SPAN");
			if(this.config.tree.config.quick){
				tmp = resultNode.create();
			} else {
				Zapatec.Transport.setInnerHtml({html: resultNode.create(), container: tmp});
			}

			var nodes = [];

			for(var ii = 0; ii < tmp.childNodes.length; ii++){
				nodes.push(tmp.childNodes[ii]);
			}

			if(insertBeforeElement){
				for(var ii = 0; ii < nodes.length; ii++){
					this.childrenContainer.insertBefore(nodes[ii], 
						insertBeforeElement);
				}
			} else {
				for(var ii = 0; ii < nodes.length; ii++){
					this.childrenContainer.appendChild(nodes[ii]);
				}
			}

			resultNode.afterCreate();

			if(prevNode){
				prevNode.putLines();
			}

			if(nextNode){
				nextNode.putLines();
			}
		}

		this.children.splice(insertPosition, 0, resultNode);
	}

	this.updateCheckbox();

	if(this.config.parentNode){
		this.config.parentNode.updateCheckbox();
    }

	return resultNode;
};

/**
 * Appends child to the end or to the start of this node branch.
 * @param newChild {Object} JSON array with data. If this is &lt;LI&gt; node - it will be converted to JSON. @see Zapatec.Tree.Utils.convertLi2Json
 * @param atStart {boolean} If true - node will be added to the start of the branch. Otherwise - to the end.
 * @return reference to newly created Zapatec.Tree.Node instance
 * @type Object
 */
Zapatec.Tree.Node.prototype.appendChild = function(newChild, atStart){
	if(atStart){
		return this.addNode(newChild, 0);
	} else {
		return this.addNode(newChild, this.children.length);
	}
};

/**
 * Appends new node before current node.
 * @param newChild {Object} JSON array with data. If this is &lt;LI&gt; node - it will be converted to JSON. @see Zapatec.Tree.Utils.convertLi2Json
 * @return reference to newly created Zapatec.Tree.Node instance
 * @type Object
 */
Zapatec.Tree.Node.prototype.insertBefore = function(newChild){
	for(var ii = this.config.parentNode.children.length - 1; ii >= 0; ii--){
		if(this == this.config.parentNode.children[ii]){
			return this.config.parentNode.addNode(newChild, ii);
		}
	}
};

/**
 * Appends new node after current node.
 * @param newChild {Object} JSON array with data. If this is &lt;LI&gt; node - it will be converted to JSON. @see Zapatec.Tree.Utils.convertLi2Json
 * @return reference to newly created Zapatec.Tree.Node instance
 * @type Object
 */
Zapatec.Tree.Node.prototype.insertAfter = function(newChild){
	for(var ii = this.config.parentNode.children.length - 1; ii >= 0; ii--){
		if(this == this.config.parentNode.children[ii]){
			return this.config.parentNode.addNode(newChild, ii + 1);
		}
	}
};

/**
 * Returns JSON with current node state. This object can be stored and used to
 *	create node with completely same structure.
 * @return JSON with tree data.
 * @type Object
 */
Zapatec.Tree.Node.prototype.getState = function(){
	var result = {
		label: this.data.label,
		isSelected: this.data.isSelected, 
		attributes: Zapatec.Utils.clone(this.data.attributes),
		isChecked: this.data.isChecked
	};

	if(this.isCreated && !this.config.isRootNode){
		result.label = this.getLinkToLabelElement().innerHTML;
	}

	if(this.hasSubtree()){
		result.isExpanded = this.data.isExpanded;

		result.source = this.config.source;
		result.sourceType = this.config.sourceType;

		result.expandedIcon = this.data.expandedIcon;
		result.collapsedIcon = this.data.collapsedIcon;
		result.fetchingIcon = this.data.fetchingIcon;

		result.children = [];

		for(var ii = 0; ii < this.children.length; ii++){
			result.children.push(this.children[ii].getState());
		}
	} else {
		result.elementIcon = this.data.elementIcon;
	}
	
	return result;
};

/**
 * Rename current node.
 * @param {Object} newLabel New node content. May contain HTML.
 */
Zapatec.Tree.Node.prototype.rename = function(newLabel){
	this.fireEvent("rename", this.data.label, newLabel);
	this.data.label = newLabel;

	var labelElement = this.getLinkToLabelElement();

	if(this.config.tree.config.quick){
		labelElement.innerHTML = newLabel;
	} else {
		Zapatec.Transport.setInnerHtml({html: newLabel, container: labelElement});
	}
};

/**
 * Converts current branch to single node - all references to DOM elements will be changed.
 */
Zapatec.Tree.Node.prototype.convertToSingle = function(){
	if(!this.hasSubtree()){
		return;
	}

	// remove children
	for(var ii = this.children.length - 1; ii >= 0 ; ii--){
		this.children[ii].destroy(true);
	}

	this.data.children = null;
	var newContainer = Zapatec.Utils.convertHTML2DOM(this.create());
	var parent = this.labelContainer.parentNode;
	parent.insertBefore(newContainer, this.labelContainer);
	parent.removeChild(this.labelContainer);
	parent.removeChild(this.childrenContainer);
	this.labelElement = null;
	this.isCreated = false;
	this.afterCreate();
};

/**
 * Converts current single node to branch - all references to DOM elements will be changed.
 */
Zapatec.Tree.Node.prototype.convertToBranch = function(){
	if(this.hasSubtree()){
		return;
	}

	this.data.children = [];
	var elsArr = Zapatec.Utils.convertHTML2DOM("<div>" + this.create() + "</div>").childNodes;
	var parent = this.labelContainer.parentNode;
	
	parent.insertBefore(elsArr[0], this.labelContainer);
	parent.insertBefore(elsArr[0], this.labelContainer);
	
	parent.removeChild(this.labelContainer);
	
	this.labelElement = null;
	this.isCreated = false;
	this.afterCreate();
};
