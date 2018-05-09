/**
 * Utils class with some commonly used small methods
 */
Zapatec.Tree.Utils = {};

/**
 * @private
 * This method is used to convert HTML &lt;LI&gt; element into JSON structure for Zapatec.Tree.Node
 * @param [Object] liNode DOM node
 * @param [boolean] compatibility with Zapatec.Tree version less the 2.2
 * @return JSON array with data
 * @type Object
 */
Zapatec.Tree.Utils.convertLi2Json = function(liNode, compat){
	if(
		liNode == null || 
		liNode.nodeType != 1 ||
		liNode.nodeName.toLowerCase() != 'li'
	){
		return null;
	}

	var struct = {attributes: {}};
	var ul = null;
	var expandedIcon = null;
	var collapsedIcon = null;
	var fetchingIcon = null;
	var icon = null;
	var labelEl = document.createElement("span");
	var cNodes = [];
	
	for(var ii = 0;  ii < liNode.childNodes.length; ii++){
		cNodes.push(liNode.childNodes[ii]);
	}
	
	for(var ii = 0; ii < cNodes.length; ii++){
		var node = cNodes[ii];

		if(node.nodeType == 1){
			if(node.nodeName.toLowerCase() == 'img'){
				if(compat){
					if(icon == null){
						icon = node;
					}

					// if this is 2.0 compatible mode - take first two images as +- buttons
					if(expandedIcon == null){
						expandedIcon = node;
						Zapatec.Utils.addClass(expandedIcon, "expandedIcon");
						continue;
					} else if(collapsedIcon == null){
						collapsedIcon = node;
						Zapatec.Utils.addClass(collapsedIcon, "collapsedIcon");
						continue;
					}

					if(icon == node){
						continue;
					}
				} else {
					// if not compatible - search using classname
					if(/\belementIcon\b/.test(node.className)){
						icon = node;
						continue;
					} else if(/\bexpandedIcon\b/.test(node.className)){
						expandedIcon = node;
						continue;
					} else if(/\bcollapsedIcon\b/.test(node.className)){
						collapsedIcon = node;
						continue;
					} else if(/\bfetchingIcon\b/.test(node.className)){
						fetchingIcon = node;
						continue;
					}
				}
			}

			if(node.nodeName.toLowerCase() == 'ul'){
				ul = node;
				continue;
			}
		}

		var appendNode = node;

		// For IE it is not possible to clone <SCRIPT> node and preserve its content.
		if(Zapatec.is_ie && node.nodeType == 1 && node.nodeName.toLowerCase() == "script"){
			appendNode = node;
		} else	{
			appendNode = node.cloneNode(true);
		}

		labelEl.appendChild(appendNode);
	}

	if(Zapatec.is_khtml){
		var allChildren = labelEl.all ? labelEl.all : labelEl.getElementsByTagName("*");
		
		for(var ii = 0; ii < allChildren.length; ii++){
			var child = allChildren[ii];

			for(var jj = 0; jj < child.attributes.length; jj++){
				var attr = child.attributes[jj];
				child.setAttribute(attr.nodeName, attr.nodeValue.replace(/"/g, "'"));
			}
		}
	}

	struct['label'] = labelEl.innerHTML;
	if(Zapatec.is_opera){
		// Opera bug: http://my.opera.com/community/forums/topic.dml?id=99268&t=1164901696&page=1
		// Opera do some strange things with quotes when getting innerHTML
		// So we need to replace all \" with single quotes '
		// this may cause some errors in javascript :(
		struct['label'] = struct['label'].replace(/\\"/g, "'"); 
	}

	struct['isChecked'] = /\bchecked\b/.test(liNode.className);
	struct['isSelected'] = /\bselected\b/.test(liNode.className);
	struct['isExpanded'] = /\bexpanded\b/.test(liNode.className);
	struct['loadAlways'] = /\bzpLoadAlways\b/.test(liNode.className);

	for(var ii = 0; ii < liNode.attributes.length; ii++){
		var attr = liNode.attributes[ii];

		if(
			Zapatec.is_ie && 
			liNode.getAttributeNode(attr.nodeName) && 
			!liNode.getAttributeNode(attr.nodeName).specified
		){
			// skip attributes that are not defined in original element
			continue;
		}
		
		struct['attributes'][attr.nodeName.toLowerCase()] = attr.nodeValue;
	}

	// if node has <UL> element inside - append its <LI>s as child nodes.
	if(ul == null){
		if(icon){
			Zapatec.Utils.addClass(icon, "elementIcon");
			var tmpIcon = document.createElement("SPAN");
			tmpIcon.appendChild(icon);
			struct['elementIcon'] = tmpIcon.innerHTML;
		}
	} else {
		if(expandedIcon){
			var tmpIcon = document.createElement("SPAN");
			tmpIcon.appendChild(expandedIcon);
			struct['expandedIcon'] = tmpIcon.innerHTML;
		}
	    
		if(collapsedIcon){
			var tmpIcon = document.createElement("SPAN");
			tmpIcon.appendChild(collapsedIcon);
			struct['collapsedIcon'] = tmpIcon.innerHTML;
		}
	    
		if(fetchingIcon){
			var tmpIcon = document.createElement("SPAN");
			tmpIcon.appendChild(fetchingIcon);
			struct['fetchingIcon'] = tmpIcon.innerHTML;
		}

		struct['children'] = [];

		for(var ii = 0; ii < ul.childNodes.length; ii++){
			var tmp = Zapatec.Tree.Utils.convertLi2Json(ul.childNodes[ii], compat);
			
			if(tmp != null){
				struct['children'].push(tmp);
			}
		}
	}

	return struct;
};

/**
 * @private
 * This function transforms XML node to DOM node.
 * @param [Object] XML node
 * @return DOM node
 * @type Object
 */
Zapatec.Tree.Utils.xml2dom = function(node){
	if(node.nodeType == 3){
		return document.createTextNode(node.nodeValue);
	}

	if(node.nodeType != 1){
		return null;
	}
	
	var el = Zapatec.Utils.createElement(node.nodeName);

	for (var ii = 0; ii < node.attributes.length; ii++){
		var attr = node.attributes[ii];
	
		if(attr.name.toLowerCase() == "class"){
			el.className = node.getAttribute(attr.name);
		} else {      
			el.setAttribute(attr.name, node.getAttribute(attr.name));
		}
	}

	if(node.hasChildNodes()){
		for(var ii = 0; ii < node.childNodes.length; ii++){
			var childNode = Zapatec.Tree.Utils.xml2dom(node.childNodes[ii]);
		
			if(childNode != null){
				el.appendChild(childNode);
			}
		}
	}

	return el;
};

/**
 * @private
 * This method is used to convert XML tree into JSON structure for Zapatec.Tree.Node
 * @param [Object] XML node
 * @return JSON array with data
 * @type Object
 */
Zapatec.Tree.Utils.convertXml2Json = function(itemNode){
	if(
		itemNode == null || 
		itemNode.nodeType != 1 ||
		itemNode.nodeName.toLowerCase() != 'item'
	){
		return null;
	}

	var struct = {content: null, attributes: {}};
	var list = null;

	var labelEl = document.createElement("span");

	for(var ii = 0; ii < itemNode.childNodes.length; ii++){
		var node = itemNode.childNodes[ii];

		if(node.nodeType != 1){
			continue;
		}
		if(
			node.nodeName.toLowerCase() == "attribute" && 
			node.getAttribute("name")
		){
			struct.attributes[node.getAttribute("name")] = Zapatec.is_ie ? node.childNodes[0].nodeValue : node.textContent;
			continue;
		}

		if(node.nodeName.toLowerCase() == 'list'){
			list = node;
			continue;
		}

		if(node.nodeName.toLowerCase() == 'label'){
			for(var jj = 0; jj < node.childNodes.length; jj++){
				labelEl.insertBefore(Zapatec.Tree.Utils.xml2dom(node.childNodes[jj]), labelEl.firstChild);
			}
		
			continue;
		}
	}

	struct['label'] = labelEl.innerHTML;
	struct['isChecked'] = itemNode.getAttribute("isChecked") == "true";
	struct['isSelected'] = itemNode.getAttribute("isSelected") == "true";
	struct['isExpanded'] = itemNode.getAttribute("isExpanded") == "true";
	struct['loadAlways'] = itemNode.getAttribute("loadAlways") == "true";

	struct['source'] = itemNode.getAttribute("source");
	struct['sourceType'] = itemNode.getAttribute("sourceType");

	if(list == null){
		struct['elementIcon'] = itemNode.getAttribute("elementIcon"); 
	} else {
		struct['collapsedIcon'] = itemNode.getAttribute("collapsedIcon"); 
		struct['expandedIcon'] = itemNode.getAttribute("expandedIcon"); 
		struct['fetchingIcon'] = itemNode.getAttribute("fetchingIcon"); 

		struct['children'] = [];

		for(var ii = 0; ii < list.childNodes.length; ii++){
			var tmp = Zapatec.Tree.Utils.convertXml2Json(list.childNodes[ii]);
			
			if(tmp != null){
				struct['children'].push(tmp);
			}
		}
	}

	return struct;
};

Zapatec.Tree.Utils.getNodeIndex = function(node){
	if(!node || !node.config || !node.config.parentNode || !node.config.parentNode.children){
		return null;
	}
	
	for(var ii = 0; ii < node.config.parentNode.children.length; ii++){
		if(node.config.parentNode.children[ii] == node){
			return ii;
		}
	}
};

/**
 * This is helper function to find "previous" node for currently selected. "Previous" means:
 * - if currently selected node has another child in same branch above current 
 *	and it is not branch - return it.
 * - if currently selected node has another child in same branch above current 
 *	and it is branch - return deepest child from that branch.
 * - if this is first child in branch - return parent node
 * @param prevSelected {object} Currently selected node
 */
Zapatec.Tree.Utils.getPrevNode = function(prevSelected){
	var index = Zapatec.Tree.Utils.getNodeIndex(prevSelected);

	if(index == null){
		return;
	}
	
	var prevNode = null;
	
	if(index > 0){
		// if there is other child nodes before element - choose previous node
		prevNode = prevSelected.config.parentNode.children[index - 1];

		while(prevNode.hasSubtree() && prevNode.data.isExpanded){
			// get last visible child
			prevNode = prevNode.children[prevNode.children.length - 1];
		}
	} else if(!prevSelected.config.parentNode.config.isRootNode){
		// otherwise select parent node
		prevNode = prevSelected.config.parentNode;
	}

	return prevNode;
};

/**
 * This is helper function to find "next" node for currently selected. "Next" means:
 * - if currently selected node has another child in same branch below current 
 *	and it is not branch - return it.
 * - if currently selected node is last child in a branch - return next visible node.
 * - if currently selected node is a branch - return first child
 * @param prevSelected {object} Currently selected node
 */
Zapatec.Tree.Utils.getNextNode = function(prevSelected){
	var index = Zapatec.Tree.Utils.getNodeIndex(prevSelected);

	if(index == null){
		return;
	}
	
	var nextNode = null;

	if(
		prevSelected.hasSubtree() && 
		prevSelected.data.isExpanded &&
		prevSelected.children.length > 0
	){
		// if node has expanded subtree - choose first node
		nextNode = prevSelected.children[0]; 
	} else if(index < prevSelected.config.parentNode.children.length - 1){
		//if there is other child nodes on same level - choose next node
		nextNode = prevSelected.config.parentNode.children[index + 1];
	} else if(!prevSelected.config.parentNode.config.isRootNode){
		nextNode = prevSelected.config.parentNode;
		index = Zapatec.Tree.Utils.getNodeIndex(nextNode);

		while(index == nextNode.config.parentNode.children.length - 1){
			nextNode = nextNode.config.parentNode;

			if(nextNode.config.isRootNode){
				return;
			}

			index = Zapatec.Tree.Utils.getNodeIndex(nextNode);
		}

		nextNode = nextNode.config.parentNode.children[index+1];
	}

	return nextNode;
};

/**
 * @private
 * Add given className to given string with <img> tag. Updates class attribute 
 * if it is present in the string or adds new attribute.  
 * @param {Object} str String with <img> tag
 * @param {Object} className CSS class to add
 * @return Modified string with added className
 * @type String 
 */
Zapatec.Tree.Utils.addIconClass = function(str, className){
	if(!str || !className){
		return str;
	}
	
	var md = str.match(/( class=['"])/i);
	if(md){
		return str.replace(/( class=['"])/i, "$1" + className + " ");
	} else {
		return str.replace(/^<img/, "<img class='" + className + "'");
	}
};

/**
 * @private
 * Helper function to determine if right mouse button was clicked. For Opera 
 * returns true if left button was clicked. For Safari return true if Meta key 
 * is pressed and left button is clicked.
 * @param {Object} ev Click event
 * @return True if right button was clicked. Otherwise - false.
 * @type boolean
 */
Zapatec.Tree.Utils.isRightClick = function(ev){
	if(!ev){
		ev = window.event;
	}
	
	if(!ev){
		return false;
	}

	var button = ev.button ? ev.button : ev.which
	
	return (
		button > 1 || // right click
		button == 1 && // left click but...
		(
			Zapatec.is_opera || // Button 1 is used in Opera because Opera doesn't allow to disable context menu 
			Zapatec.is_khtml && ev.ctrlKey // In Safari Ctrl Key + left click is used 
		)
	);
};