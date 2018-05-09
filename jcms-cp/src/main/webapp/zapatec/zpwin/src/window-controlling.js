// $Id: window-controlling.js 15736 2009-02-06 15:29:25Z nikolai $
/**
 *
 * Copyright (c) 2004-2009 by Zapatec, Inc.
 * http://www.zapatec.com
 * 1700 MLK Way, Berkeley, California,
 * 94709, U.S.A.
 * All rights reserved.
 */

/**
 * Gets the window container.
 */
Zapatec.Window.prototype.getContainer = function() {
	return this.container;
};

/**
 * Sets default state values of the widget.
 */
Zapatec.Window.prototype.setDefaultState = function() {
	//stores the properties which describe the state of the widget
	this.state = {};
	//is window minimized, maximized or simple
	this.state.state = "simple";
	//X coordinate
	this.state.left = 0;
	//Y coordinate
	this.state.top = 0;
	//the width of the window
	this.state.width = 0;
	//the height of the window
	this.state.height = 0;
	//the content type of the window
	this.state.contentType = "";
	//the content of the window
	this.state.content = "";
};

/**
 * Updates the state object.
 */
Zapatec.Window.prototype._updateState = function() {
	//getting position
	var pos = null;
	if (!this.getConfiguration().fixed) {
		pos = this.getPosition();
	} else {
		pos = this.getScreenPosition();
	}
	//saving coordinates
	this.state.left = pos.x;
	this.state.top = pos.y;
	//saving sizes
	if (this.state.state != "min") {
		this.state.width = this.getWidth();
		this.state.height = this.getHeight();
	}
};

/** 
 * Gets the state of the window.
 * @return object with the following properties:
 * \code
 *    prop. name     | description
 *  -------------------------------------------------------------------------------------------------
 *   x       | left coordinate.
 *   y       | top coordinate.
 *   width   | width of container.
 *   height  | height of container.
 *   url     | if content is set from URL, than it contains that URL, otherwise null
 *   div     | if content is set from DIV element, than it contains it id, if it has no id its null.
 *   text    | if content is set as text string, than it contains that text, otherwise null
 * \endcode
 */
Zapatec.Window.prototype.getState = function() {
	var state = {};
	//getting coordinates
	state.x = this.state.left;
	state.y = this.state.top;
	//getting sizes
	state.width = this.state.width;
	state.height = this.state.height;
	//getting zIndex
	state.zIndex = this.getContainer().style.zIndex;
	//getting content
	switch(this.state.contentType) {
		case "html/text" : state.text = this.state.content; break;
		case "html" : state.div = this.state.content; break;
		case "html/url" : state.url = this.state.content; break;
	}
	
	return state;
};

/** 
 * Sets the state of the window.
 * @param state [object] with the following properties:
 * \code
 *    prop. name     | description
 *  -------------------------------------------------------------------------------------------------
 *   x       | left coordinate.
 *   y       | top coordinate.
 *   width   | width of container.
 *   height  | height of container.
 *   url     | URL content.
 *   div     | content is set from DIV element.
 *   text    | content is set as text string.
 * \endcode
 */
Zapatec.Window.prototype.setState = function(state) {
	if (!this.fireOnState("ready", function() {this.setState(state);})) {return;}
	//setting size and coordinates
	if (state.x || state.y || state.width || state.height) {
		this.setPosAndSize(state.x, state.y, state.width, state.height);
	}
	//setting z-index
	if (state.zIndex) {
		//for container
		this.container.style.zIndex = state.zIndex;
		//updating global variable
		if(state.zIndex > Zapatec.Window.maxNumber){
			Zapatec.Window.maxNumber = state.zIndex + 1;
		}
		//updating WCH
		if (this.WCH) {
			this.WCH.style.zIndex = state.zIndex - 1;
		}
		//updating modal
		if(this.config.modal){
			this.modal.container.style.zIndex = state.zIndex - 2;
		}
	}
	//setting content
	if(state.url || state.div || state.text){
		this.setContent("");
		if (state.url) {
			//URL content
			this.setContentUrl(state.url);
		} else if (state.div) {
			//DIV content
			this.setDivContent(state.div);
		} else if (state.text) {
			//text content
			this.setContent(state.text);
		}
	}

	return true;
};

/**
 * Depricated. Only for backward compability.
 *
 * @param left [integer] - X coordinate.
 * @param top [integer] - Y coordinate.
 */
Zapatec.Window.prototype.setPos = function(left, top) {
	this.setScreenPosition(left, top);
};

/**
 * We overwrite implemented method to make it more 
 * friendly to states. So actually this method sets
 * the coordinates of Window.
 * @param left [integer] - X coordinate.
 * @param top [integer] - Y coordinate.
 */
Zapatec.Window.prototype.setPosition = function(left, top) {
	if (!this.fireOnState("shown", function() {this.setPosition(left, top);})) {return;}
	//calling interface method in scope of this object
	Zapatec.Movable.setPosition.call(this, left, top);
	//updating state object
	this._updateState();
};

/**
 * We overwrite implemented method to make it more 
 * friendly to states. This method sets the coordinates
 * of Window on the screen.
 * @param left [integer] - X coordinate.
 * @param top [integer] - Y coordinate.
 */
Zapatec.Window.prototype.setScreenPosition = function(left, top) {
	if (!this.fireOnState("shown", function() {this.setScreenPosition(left, top);})) {return;}
	//calling interface method in scope of this object
	Zapatec.Movable.setScreenPosition.call(this, left, top);
};

/**
 * We overwrite implemented method to make it more 
 * friendly to states. This method sets the coordinates
 * of Window on the whole page (document.body).
 * @param left [integer] - X coordinate.
 * @param top [integer] - Y coordinate.
 */
Zapatec.Window.prototype.setPagePosition = function(left, top) {
	if (!this.fireOnState("shown", function() {this.setPagePosition(left, top);})) {return;}
	//calling interface method in scope of this object
	Zapatec.Movable.setPagePosition.call(this, left, top);
};

/**
 * Sets the width of the window. 
 * We overwrite interface method to make
 * it friendly for states.
 *
 * @param width [integer] - width of the window.
 */
Zapatec.Window.prototype.setWidth = function(width) {
	if (!this.fireOnState("shown", function() {this.setWidth(width);})) {return;}
	//we can only call this in case if Window is not minimized or maximized
	if (this.state.state != "simple") {return false;}
	//calling interface method in scope of this object
	Zapatec.Sizable.setWidth.call(this, width);
	//updating state object
	this._updateState();
};

/**
 * Sets the height of the window.
 * We overwrite interface method to make
 * it friendly for states.
 *
 * @param height [integer] - height of the window.
 */
Zapatec.Window.prototype.setHeight = function(height) {
	if (!this.fireOnState("shown", function() {this.setHeight(height);})) {return;}
	//we can only call this in case if Window is not minimized or maximized
	if (this.state.state != "simple") {return false;}
	//calling interface method in scope of this object
	Zapatec.Sizable.setHeight.call(this, height);
	//updating state object
	this._updateState();
};

/**
 * Sets the sizes of the window. 
 *
 * @param width [integer] - width of the window.
 * @param height [integer] - height of the window.
 */
Zapatec.Window.prototype.setSize = function(width, height) {
	this.setWidth(width);
	this.setHeight(height);
};


/**
 * Sets the sizes and position of the window. 
 *
 * @param left [integer] - X coordinate.
 * @param top [integer] - Y coordinate.
 * @param width [integer] - width of the window.
 * @param height [integer] - height of the window.
 */
Zapatec.Window.prototype.setPosAndSize = function(left, top, width, height) {
	this.setSize(width, height);
	this.setPos(left, top);
};

/*
 * Set the title of the window
 * @param type [string] the title to set to
 */ 
Zapatec.Window.prototype.setTitle = function(text) {
	if (!this.fireOnState("ready", function() {this.setTitle(text);})) {return;}
	//putting text into title element
	if (text !== '') {
		this.titleText.innerHTML = text;
	}
	//returning success
	return true;
};

/**
 * Sets the status text of the window. 
 *
 * @param mesage [string] - text to be shown.
 * @param mode [string] - currently mode forces to do some additional action when seting the text.
 *                        For example, "temp" means to store the previous value.
 */
Zapatec.Window.prototype.setStatus = function(message, mode) {
	if (!this.fireOnState("ready", function() {this.setStatus(message, mode);})) {return;}

	//to be able to use different mods of setting status text we use mode var
	if (this.config.showStatus && Zapatec.isHtmlElement(this.statusText)) {
		switch (mode) {
			//if mode "temp" current value is saved and overwritten by new one
			case "temp" : {
				this.prevStText = this.statusText.innerHTML;
				break;
			}
			
			//in case of "restore" we just restore old value saved before
			case "restore" : {
				message = this.prevStText || message;
				delete this.prevStText;
				break;
			}
			
		}
		//putting message into the status element
		this.statusText.innerHTML = message;
	}
	//returning success
	return true;
}

/* 
 * Set the content of a window.
 * @param type [string] the HTML data to set the content to.
 */

Zapatec.Window.prototype.setContent = function(text) {
	if (!this.fireOnState("shown", function() {this.setContent(text);})) return;
	//setting content
	this.content.setPaneContent(text, "html/text");
	//updating state object
	this.state.contentType = "html/text";
	this.state.content = text;
}

/* 
 * Set the content of a window from HTML element(DIV).
 * @param div [string]or [object] the HTML data to set the content to.
 */

Zapatec.Window.prototype.setDivContent = function(div) {
	if (!this.fireOnState("shown", function() {this.setDivContent(div);})) return;
	//setting content
	this.content.setPaneContent(div, "html");
	//updating state object
	this.state.contentType = "html";
	if (typeof div == "string") {
		this.state.content = div;
	} else {
		this.state.content = null;
	}
}

/* 
 * Set the content of a window from url.
 * @param div [string]or [object] the HTML data to set the content to.
 */

Zapatec.Window.prototype.setContentUrl = function(url) {
	if (!this.fireOnState("shown", function() {this.setContentUrl(url);})) return;
	//setting content
	this.content.setPaneContent(url, "html/url");
	//updating state object
	this.state.contentType = "html/url";
	this.state.content = url;
}

/**
 * Activates the window.
 */
Zapatec.Window.prototype.activate = function() {
	if (!this.fireOnState("shown", function() {this.activate();})) {return;}
	//if it is already active then do nothing
	if (this.face.className.indexOf("zpWinFront") != -1) {
		return true;
	}
	Zapatec.Window.activating = this;
	//set the current window
	if (Zapatec.Window.currentWindow) {
		Zapatec.Window.currentWindow.deactivate();
	}
	Zapatec.Window.currentWindow = this;
	Zapatec.Utils.removeClass(this.face, 'zpWinBack');
	Zapatec.Utils.addClass(this.face, 'zpWinFront');
	if (this.WCH) this.WCH.style.zIndex = Zapatec.Window.maxNumber++;
	if (this.modal) this.modal.container.style.zIndex = Zapatec.Window.maxNumber++;
	this.getContainer().style.zIndex = Zapatec.Window.maxNumber++;
	//if it is not the first one and it is not the same one as before
	
	this.fireEvent("onRaise", this);
	Zapatec.Window.activating = null;
};

/**
 * Deactivates the window.
 */
Zapatec.Window.prototype.deactivate = function() {
	if (!this.fireOnState("shown", function() {this.deactivate();})) {return;}
	//if window is already unactive - do nothing
	if (this.face.className.indexOf("zpWinBack") != -1) {
		return true;
	}
	var prevWin = Zapatec.Window.currentWindow;
	Zapatec.Utils.removeClass(this.face, 'zpWinFront');
	Zapatec.Utils.addClass(this.face, 'zpWinBack');
	Zapatec.Window.activateFreeWindow(this);
	Zapatec.Window.lastActive = this;
};

/**
 * If this window can be activated.
 * @return {Object} true if can be,
 * false if can not, "min" if minimized.
 */
Zapatec.Window.prototype.canActivate = function() {
	if (!this.stateReached("ready")) {
		return false;
	}
	if (this.state.state == "min") {
		return "min";
	}
	return true;
};

/**
 * Returns the visibility of the vindow.
 */
Zapatec.Window.prototype.isVisible = function() {
	return this.widgetState == "shown" ? true : false;
};

/**
 * Shows the window.
 */ 
Zapatec.Window.prototype.show = function() {
	if (!this.fireOnState("ready", function() {this.show();})) {return;}

	this.getContainer().style.display = "block";
	if (this.content) {
		this.content.show();
	}
	if (this.config.modal == true && this.modal) {
		var zIndex = null;
		if (this.WCH) {
			zIndex = this.WCH.style.zIndex;
		} else {
			zIndex = this.getContainer().style.zIndex;
		}
		this.modal.show(zIndex - 1);
	}
	if (this.WCH) {
		this.WCH.style.visibility = "";
	}
	this.activate();
	if (this.getConfiguration().fixed) {
		this._updateState();
	}
	if (this.stateReached("ready")) {
		this.changeState("shown");
	}
	this.fireEvent("onShow", this);
	return true;
}

/**
 * Hides the window.
 */ 
Zapatec.Window.prototype.hide = function() {
	if (!this.fireOnState("ready", function() {this.hide();})) return;

	if(this.content){
		this.content.hide();
	}

	this.getContainer().style.display = "none";
	if (this.config.modal == true && this.modal) {
		this.modal.hide();
	}
	Zapatec.Utils.hideWCH(this.WCH);
	this.deactivate();
	if (this.stateReached("ready")) {
		this.changeState("hidden");
	}
	this.fireEvent("onHide", this);
	return true;
}

/**
 * This function displays the calendar near a given "anchor" element, according
 * to some rules passed in \em opts.  The \em opts argument is a string
 * containing one or 2 letters.  The first letter decides the vertical
 * alignment, and the second letter decides the horizontal alignment relative
 * to the anchor element.  Following we will describe these options; in parens
 * we will use simple descriptions like "top to bottom" which means that the
 * top margin of the calendar is aligned with the bottom margin of the object.
 *
 * \b Vertical align:
 *
 * - T -- the calendar is completely above the element (bottom to top)
 * - t -- the calendar is above the element but might overlap it (bottom to bottom)
 * - C -- the calendar is vertically centered to the element
 * - b -- the calendar is below the element but might overlap it (top to top)
 * - B -- the calendar is completely below the element (top to bottom)
 *
 * \b Horizontal align (defaults to 'l' if no letter passed):
 *
 * - L -- the calendar is completely to the left of the element (right to left)
 * - l -- the calendar is to the left of the element but might overlap it (right to right)
 * - C -- the calendar is horizontally centered to the element
 * - r -- the calendar is to the right of the element but might overlap it (left to left)
 * - R -- the calendar is completely to the right of the element (left to right)
 *
 * @param el [HTMLElement] the anchor element
 * @param opts [string, optional] the align options, as described above.  Defaults to "Bl" if nothing passed.
 */
Zapatec.Window.prototype.showAtElement = function (el, opts) {
	if (!this.fireOnState("ready", function() {this.showAtElement(el, opts);})) {return;}

	var p = Zapatec.Utils.getElementOffset(el);
	if (!opts || typeof opts != "string") {
		this.showAt(p.x, p.y + el.offsetHeight);
		return true;
	}
	this.getContainer().style.display = "block";
	var w = this.getWidth();
	var h = this.getHeight();
	this.getContainer().style.display = "none";
	var valign = opts.substr(0, 1);
	var halign = "l";
	if (opts.length > 1) {
		halign = opts.substr(1, 1);
	}
	// vertical alignment
	switch (valign) {
	    case "T": p.y -= h; break;
	    case "B": p.y += el.offsetHeight; break;
	    case "C": p.y += (el.offsetHeight - h) / 2; break;
	    case "t": p.y += el.offsetHeight - h; break;
	    case "b": break; // already there
	}
	// horizontal alignment
	switch (halign) {
	    case "L": p.x -= w; break;
	    case "R": p.x += el.offsetWidth; break;
	    case "C": p.x += (el.offsetWidth - w) / 2; break;
	    case "l": p.x += el.offsetWidth - w; break;
	    case "r": break; // already there
	}
	p.width = w;
	p.height = h;
	//Zapatec.Utils.fixBoxPosition(p);
	this.showAt(p.x, p.y);
	return true;
}

/**
 * Shows the calendar at a given absolute position (beware that, depending on
 * the calendar element style -- position property -- this might be relative to
 * the parent's containing rectangle).
 *
 * @param x [int] the X position
 * @param y [int] the Y position
 */
Zapatec.Window.prototype.showAt = function (x, y) {
	if (!this.fireOnState("ready", function() {this.showAt(x, y);})) {return;}

	this.setPagePosition(x, y);
	this.show();
	return true;
}

/**
 * Minimizes the window.
 */ 
Zapatec.Window.prototype.minimize = function() {
	if (!this.config.showMinButton) {
		return false;
	}
	if (!this.fireOnState("ready", function() {this.minimize();})) return;

	//Do we really need to minimize
	if (this.state.state != "min" && this.titleArea) {
		var self = this;
		//this function recursively hides all the elements in the Window except title and its parents
		function hideExcept(el, exc) {
			if (el != self.container) {
				var first = el.firstChild;
				while(first) {
					if (first && first.style && first != exc) {
						if (!first.restorer) {
							first.restorer = new Zapatec.SRProp(first);
						}
						first.restorer.saveProp("style.display");
						first.style.display = "none";
					}
					first = first.nextSibling;
				}
				hideExcept(el.parentNode, el);
			}
		}
		if (this.state.state != "simple") {
			this.restore();
		}
		hideExcept(this.titleArea.parentNode, this.titleArea);
		this.content.hide();
		this.restorer.saveProps(
			"_updateState", "content", "statusText", 
			"getConfiguration().limit.minHeight"
		);
		this.content = this.statusText = this.getConfiguration().limit.minHeight = null;
		this._updateState = function() {};
		this.setHeight(Zapatec.Utils.getHeight(this.face));
		if (this.config.bottomMinimize) {
			this.setWidth(Zapatec.Window.minWinWidth);
			//Putting it to the left bottom corner in the appropriate order
			this.setScreenPosition(Zapatec.Window.minimizeLeft, "bottom");
			Zapatec.Window.minimizeLeft += Zapatec.Window.minWinWidth + 5;
		}
		//lets disable dragging
		if (!this.config.dragMin) {
			this._setCanDrag(false);
		} else {
			this._setCanDrag(true);
			this.restorer.restoreProp("_updateState");
		}
		this._setCanResize(false);
		//Need to hide some buttons and show restore one
		if (this.state.state == "max") {
			this.showButton("maxButton");
		} else {
			this.showButton("restoreButton");
		}
		this.hideButton("minButton");
		//storing old state for restore
		this.state.prevState = this.state.state;
		//setting new state
		this.state.state = "min";
		//if the window is not fixed need to fixate it on the screen
		if (!this.getConfiguration().fixed) {
			Zapatec.FixateOnScreen.register(this.getContainer());
			Zapatec.FixateOnScreen.register(this.WCH);
		}
		//deactivateing window
		this.deactivate();
	} else {
		return false;
	}
	//calling handler
	this.fireEvent("onMinimize", this);

	return true;
}

/**
 * Maximizes the window.
 */ 
Zapatec.Window.prototype.maximize = function() {
	if (!this.config.showMaxButton) {
		return false;
	}
	var self = this;
	if (!this.fireOnState("ready", function() {self.maximize();})) return;

	if (this.state.state != "max") {
		var sizes = Zapatec.Utils.getWindowSize();
		//Need to hide some buttons and show restore one, restore some properties of the window, etc.
		if (this.state.state == "min") {
			this.restore();
		}
		this.showButton("restoreButton");
		this.hideButton("maxButton");
		//lets disable dragging
		this._setCanDrag(false);
		this._setCanResize(false);
		this.restorer.saveProp("_updateState");
		this._updateState = function() {};
		this.setHeight(this.getHeight());
		this.setScreenPosition(0, 0);
		this.setSize(sizes.width, sizes.height);
		//setting previous state to be restored correctly
		this.state.prevState = "simple";
		//setting new state
		this.state.state = "max";
		//if the window is not fixed need to fixate it on the screen
		if (!this.getConfiguration().fixed) {
			Zapatec.FixateOnScreen.register(this.getContainer());
			Zapatec.FixateOnScreen.register(this.WCH);
		}
		this.activate();
	} else {
		return false;
	}
	this.fireEvent("onMaximize", this);
	
	return true;
}

/**
 * Restores the window.
 */ 
Zapatec.Window.prototype.restore = function() {
	if (!this.config.showMaxButton && !this.config.showMinButton) {
		return false;
	}
	var self = this;
	if (!this.fireOnState("ready", function() {self.restore();})) return;
	
	if (this.state.prevState == "max") {
		return this.maximize();
	}
	if (this.state.state != "simple") {
		var self = this;
		//this function recursively hides all the elements in the Window except title and its parents
		function showAll(el) {
			if (el != self.container) {
				var first = el.firstChild;
				while(first) {
					if (first && first.restorer) {
						first.restorer.restoreProp("style.display");
						first.restorer = null;
					}
					first = first.nextSibling;
				}
				showAll(el.parentNode);
			}
		}
		//Need to hide some buttons and show restore one
		if (this.config.showMaxButton) {
			this.showButton("maxButton"); 
		}
		if (this.config.showMinButton) {
			this.showButton("minButton");
		}
		this.hideButton("restoreButton");
		//setting new state
		var wasState = this.state.state;
		this.state.state = "simple";
		//if the window is not fixed need to unregister 
		//it from being fixated on the screen
		if (wasState == "min" && this.config.bottomMinimize) {
			Zapatec.Window.sortMin(this);
		}
		if (!this.getConfiguration().fixed) {
			Zapatec.FixateOnScreen.unregister(this.getContainer());
			Zapatec.FixateOnScreen.unregister(this.WCH);
			this.setPosition(this.state.left, this.state.top);
		} else {
			this.setScreenPosition(this.state.left, this.state.top);
		}
		//seting the initial pos and sizes
		this.setSize(this.state.width, this.state.height);
		//enable dragging
		this._setCanDrag(true);
		//enable resizing
		this._setCanResize(true);
		if (wasState == "min") {
			showAll(this.titleArea);
		}
		this.restorer.restoreProps(
			"_updateState", "content", "statusText",
			"getConfiguration().limit.minHeight"
		);
		if (wasState == "min") {
			this.content.show();
		}
		//activateing this window
		this.activate();
	}

	this.fireEvent("onRestore", this);

	return true;
}

/**
 * Closes the window. Currently does not destroys the window object, just the HTML part of it
 */ 
Zapatec.Window.prototype.close = function() {
	var self = this;
	if (!this.fireOnState("ready", function() {self.close();})) return;
	
	this.restore();
	this.deactivate();
	// Return content back to the place it was taken from
	// Destroy window
	this.fireEvent("onClose", this);
	if (!this.config.hideOnClose) {
		this.discard();
	} else {
		this.hide();
	}
	return true;
};

/**
 * Deletes the widget.
 */ 
Zapatec.Window.prototype.discard = function() {
	if (null == this.content) {
		return;
	}
	if (this.content.destroy) this.content.destroy();
	this.content = null;
	this.restoreOfDrag();
	this.restoreOfResize();
	if (this.minButton.destroy) this.minButton = this.minButton.destroy();
	if (this.maxButton.destroy) this.maxButton = this.maxButton.destroy();
	if (this.closeButton.destroy) this.closeButton = this.closeButton.destroy();
	if (this.restoreButton.destroy) this.restoreButton = this.restoreButton.destroy();
	for(var iEl in this) {
		if (this[iEl] && typeof this[iEl] == "object" && this[iEl].nodeType && iEl != "container" && iEl != "WCH") {
			this[iEl] = null;
		}
	}
	if (this.config.modal == true && this.modal) {
		this.modal.hide(true);
		delete this.modal;
	}
	this.config = null;
	this.restorer = this.restorer.destroy();
	if (this.container.outerHTML) {
		this.container.outerHTML = "";
	} else {
		Zapatec.Utils.destroy(this.container);
	}
	if (this.WCH && this.WCH.outerHTML) {
		this.WCH.outerHTML = "";
	} else if (this.WCH) {
		Zapatec.Utils.destroy(this.WCH);
	}
	delete this.container;
	delete this.WCH;
	this.changeState("destroyed");
	this.removeEvent("onRestore");
	this.removeEvent("onMinimize");
	this.removeEvent("onMaximize");
	this.removeEvent("onShow");
	this.removeEvent("onHide");
	this.removeEvent("onRaise");
	this.removeEvent("onContentLoad");
	this.removeEvent("privileged_execution_on");
	this.removeEvent("privileged_execution_off");
	this.removeEvent("delayed_execution_on");
	this.removeEvent("delayed_execution_off");
};
