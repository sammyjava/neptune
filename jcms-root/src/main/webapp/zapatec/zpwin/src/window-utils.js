// $Id: window-utils.js 15736 2009-02-06 15:29:25Z nikolai $
/**
 *
 * Copyright (c) 2004-2009 by Zapatec, Inc.
 * http://www.zapatec.com
 * 1700 MLK Way, Berkeley, California,
 * 94709, U.S.A.
 * All rights reserved.
 */

/**
 * Parses given DOM element to save references into objects properties.
 * All the elements to be saved as a reference had to have a word starting
 * with 'area' in there class name. So for example an element with class name
 * areaTitle will be parsed into this.title property and those className will 
 * be removed.
 * @param el [HTML element] - element to parse;
 * @return - true if success, otherwise false;
 */
Zapatec.Window.prototype.parseDom = function(el) {
	var classes = "";
	//the el needs to be a DOM HTML element
	if (!el || typeof el != "object" || !el.nodeType) {
		return false;
	}
	//seeks the elements with the className starting with word 'area',
	//extracts the rest part of this class name, creates the reference 
	//(a property of the object) with such name, removes this class.
	//I didn't knew which way to mark the elements which needed to have reference
	//in our object, and decided (by advise) to use className starting with 'area'.
	//Example: 'areaContent', 'areaTitle', etc. will create this.content, this.title, etc.
	if (el.className) {
		classes = el.className.match(/area(\w+)/);
		//this way we mark all the elements which belong to the widget with a reference to it.
		el.win = true;
		if (classes) {
			el.id = "zpWin" + this.id + classes[1];
			classes[1] = classes[1].charAt(0).toLowerCase() + classes[1].substring(1);
			this.createProperty(this, classes[1], el);
			Zapatec.Utils.removeClass(el, classes[0]);
		}
	}
	//to go through all the childs we use recursive calls of this function for every child.
	var child = el.firstChild;
	while(child) {
		this.parseDom(child);
		child = child.nextSibling;
	}
	
	return true;
};

/**
 * Shows the specified button of the window.
 * @param button {string} string pointing to button name.
 */
Zapatec.Window.prototype.showButton = function(button) {
	this.restorer.restoreProp(button + ".getContainer().parentNode.style.display");
};

/**
 * Hides the specified button of the window.
 * @param button {string} string pointing to button name.
 */
Zapatec.Window.prototype.hideButton = function(button) {
	this.restorer.saveProp(button + ".getContainer().parentNode.style.display");
	this[button].getContainer().parentNode.style.display = "none";
};

/**
 * Reconfigurating the object due to the config options.
 */
Zapatec.Window.prototype.reconfig = function() {
	if (!this.fireOnState("ready", function() {this.reconfig();})) {return;}
	var config = this.getConfiguration();
	//Hiding title if needed
	if (!config.showTitle) {
		this.restorer.saveProp("titleArea.style.display");
		this.titleArea.style.display = "none";
	} else {
		this.restorer.restoreProp("titleArea.style.display");
		//hiding buttons if needed
		if (!config.showMinButton || this.state.state == "min") {
			this.hideButton("minButton");
		} else {
			this.showButton("minButton");
		}
		if (!config.showMaxButton || this.state.state == "max") {
			this.hideButton("maxButton");
		} else {
			this.showButton("maxButton");
		}
		if (this.state.state != "max" && this.state.state != "min") {
			this.hideButton("restoreButton");
		} else {
			this.showButton("restoreButton");
		}
		if (!config.showCloseButton) {
			this.hideButton("closeButton");
		} else {
			this.showButton("closeButton");
		}
	}
	//Hiding status if needed
	if (!config.showStatus) {
		this.restorer.saveProp("statusText.style.display");
		this.statusText.style.display = "none";
	} else {
		this.restorer.restoreProp("statusText.style.display");
	}
	//making the modal cover
	if (config.modal && !this.modal) {
		this.modal = new Zapatec.Modal({
			themePath : Zapatec.zapatecPath + "../zpextra/themes/indicator/"
		});
		this.modal.create();
	}
};


/**
 * This function assigns event handlers and implements "pushed" element finding.
 *
 * "Pushed" element finding is implemented the following way: all the event handlers see one
 * global variable target. When mouse is down on some element we try to get its buttonType property
 * or seek this property in elements parents. If the element with the buttonType is found it is put
 * into target variable. 
 */
Zapatec.Window.prototype.addEvents = function () {
	var self = this, target = null;
	Zapatec.Utils.addEvent(this.container, "mousedown", function (ev) {
		ev = ev || window.event; 
		target = Zapatec.Utils.getTargetElement(ev);
		while(!target.buttonType && (target != self.container)) {
			target = target.parentNode;
		}
		if (!target.buttonType) {target = null;}
		var result = Zapatec.Window.mouseDown(ev, self, target);
		target = null;
		return result;
	});
	if (Zapatec.is_gecko) {
		Zapatec.Utils.addEvent(this.container, "click", function (ev) {
			var result = null;
			ev = ev || window.event; 
			if (ev.detail > 1) {
				target = Zapatec.Utils.getTargetElement(ev);
				while(!target.buttonType && (target != self.container)) {
					target = target.parentNode;
				}
				if (!target.buttonType) {target = null;}
				result = Zapatec.Window.dblClick(ev, self, target);
			}
			target = null;
			return result;
		});
	} else {
		Zapatec.Utils.addEvent(this.container, "dblclick", function (ev) {
			ev = ev || window.event; 
			target = Zapatec.Utils.getTargetElement(ev);
			while(!target.buttonType && (target != self.container)) {
				target = target.parentNode;
			}
			if (!target.buttonType) {target = null;}
			var result = Zapatec.Window.dblClick(ev, self, target);
			target = null;
			return result;
		});
	}
};

/**
 * Overwriting interface method.
 */
Zapatec.Window.prototype._getDraggableHooks = function() {
	return this.titleText;
};

/**
 * Overwriting interface method.
 */
Zapatec.Window.prototype.canDrag = function() {
	return this.getConfiguration().canDrag;
};

/**
 * Overwriting interface method.
 * @param on {boolean} turning on or off.
 */
Zapatec.Window.prototype._setCanDrag = function(on) {
	if (!on) {
		if (typeof this.restorer.getProp("getConfiguration().canDrag") == "undefined") {
			this.restorer.saveProp("getConfiguration().canDrag");
		}
		this.getConfiguration().canDrag = on;
	} else {
		if (typeof this.restorer.getProp("getConfiguration().canDrag") != "undefined") {
			this.restorer.restoreProp("getConfiguration().canDrag");
		}
	}
};

/**
 * Overwriting interface method.
 */
Zapatec.Window.prototype.getDragConfig = function() {
	var config = this.getConfiguration();
	return {
		method : config.dragMethod,
		dragCSS : config.addDragCSS,
		overwriteCSS : config.newDragCSS,
		copyChilds : false,
		stopEvent : false,
		eventCapture : true
	};
};

/**
 * Overwriting interface method.
 * @param config {object} new set of configuration.
 */
Zapatec.Window.prototype.setDragConfig = function(config) {};

/**
 * Overwriting interface method.
 * @param dim {string} dimension of sizing.
 */
Zapatec.Window.prototype.getSizableElements = function(dim) {
	if (dim == "width") {
		return [
			this.titleText, 
			this.content ? this.content.getContainer() : null, 
			this.getConfiguration().showStatus ? this.statusText : null, 
			this.getContainer(), 
			this.WCH
		];
	} else if (dim == "height") {
		return [
			this.content ? this.content.getContainer() : null, 
			this.getContainer(), 
			this.WCH
		];
	} else {
		return [
			this.titleText, 
			this.content ? this.content.getContainer() : null, 
			this.getConfiguration().showStatus ? this.statusText : null, 
			this.getContainer(), 
			this.WCH
		];
	}
};

/**
 * Overwriting interface method.
 */
Zapatec.Window.prototype._getAutoSizableElement = function() {
	return this.content.getContainer();
};

/**
 * Overwriting interface method.
 */
Zapatec.Window.prototype.getSizingConfig = function() {
	return {
		limit : this.getConfiguration().limit,
		direction : "both"
	};
};

/**
 * Overwriting interface method.
 * @param config {object} new set of configuration.
 */
Zapatec.Window.prototype.setSizingConfig = function(config) {
	if (typeof config.limit == "object") {
		this.getConfiguration().limit.minWidth = config.limit.minWidth;
		this.getConfiguration().limit.maxWidth = config.limit.maxWidth;
		this.getConfiguration().limit.minHeight = config.limit.minHeight;
		this.getConfiguration().limit.maxHeight = config.limit.maxHeight;
	}
};

/**
 * Overwriting interface method.
 */
Zapatec.Window.prototype.getMovableElements = function() {
	return [this.getContainer(), this.WCH];
};

/**
 * Overwriting interface method.
 */
Zapatec.Window.prototype.getMoveConfig = function() {
	return {
		limit : this.getConfiguration().limit,
		moveLayer : document.body,
		direction : "both",
		preserveSizes : true,
		followShape : false
	};
};

/**
 * Overwriting interface method.
 * @param config {object} new set of configuration.
 */
Zapatec.Window.prototype.setMoveConfig = function(config) {
	if (typeof config.limit == "object") {
		this.getConfiguration().limit.minX = config.limit.minX;
		this.getConfiguration().limit.maxX = config.limit.maxX;
		this.getConfiguration().limit.minY = config.limit.minY;
		this.getConfiguration().limit.maxY = config.limit.maxY;
	}
};

/**
 * Overwriting interface method.
 */
Zapatec.Window.prototype._getResizableHooks = function() {
	return null;
};

/**
 * Overwriting interface method.
 */
Zapatec.Window.prototype.canResize = function() {
	return this.getConfiguration().canResize;
};

/**
 * Overwriting interface method.
 * @param on {boolean} turning on or off.
 */
Zapatec.Window.prototype._setCanResize = function(on) {
	if (!on) {
		if (typeof this.restorer.getProp("getConfiguration().canResize") == "undefined") {
			this.restorer.saveProp("getConfiguration().canResize");
		}
		this.getConfiguration().canResize = on;
	} else {
		if (typeof this.restorer.getProp("getConfiguration().canResize") != "undefined") {
			this.restorer.restoreProp("getConfiguration().canResize");
		}
	}
};

/**
 * Overwriting interface method.
 */
Zapatec.Window.prototype.getResizeConfig = function() {
	return {
		stopEvent : false,
		eventCapture : true,
		direction : this.getConfiguration().resizeDirection,
		borderThickness : 10,
		cornerThickness : 10
	};
};

/**
 * Overwriting interface method.
 * @param config {object} new set of configuration.
 */
Zapatec.Window.prototype.setResizeConfig = function(config) {
	if (typeof config.direction == "string" && config.direction.length > 2) {
		this.getConfiguration().resizeDirection = config.direction;
	}
};
