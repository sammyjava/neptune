// $Id: lite-window.js 15736 2009-02-06 15:29:25Z nikolai $
/**
 * The Zapatec DHTML Menu
 *
 * Copyright (c) 2004-2009 by Zapatec, Inc.
 * http://www.zapatec.com
 * 1700 MLK Way, Berkeley, California,
 * 94709, U.S.A.
 * All rights reserved.
 *
 * Windows Widget
 * $$
 *
 */

/**
 * The Window object constructor.  Call it, for example, like this:
 *
 * \code
 *   var win = new Zapatec.Window({
 *   	showResize : false
 *   });
 * \endcode
 *
 * The above creates a new Window object.  The Window isn't displayed
 * instantly; using the "win" variable, the programmer can now set certain
 * configuration variables, hook his own event handlers and then display the
 * window using Zapatec.Window.create() and Zapatec.Window.show().
 *
 * @param config [object] - all parameters are passed as the properties of this object.
 * 
 * Constructor recognizes the following properties of the config object
 * \code
 *    prop. name     | description
 *  -------------------------------------------------------------------------------------------------
 *   showCloseButton | whether to show close button (default true).
 *   raiseOnlyOnTitle| whether to raize when clicking on title or on the whole body of the created window (default true).
 *   canDrag         | whether you can drag the window (default true).
 *   modal           | if true modal window will be created (default false).
 *   onClose         | custom handler, will be called when window is closed.
 *   onShow          | custom handler, will be called when show method is called.
 *   onHide          | custom handler, will be called when hide method is called.
 *   onRaize         | custom handler, will be called when window is raized.
 *   onContentLoad   | custom handler, will be called when content is loaded.
 *   
 * \endcode
 */
Zapatec.Window = function (config) {
	this.winDiv = null;
	this.titleArea = null;
	this.titleText = null;
	this.closeButton = null;
	this.contentArea = null;	
	this.winNumber = 0;
	this.config = {};
	this.config.showTitle = true;
	this.config.titleWidth = 0;
	this.config.contentWidth = 0;
	this.config.heightDiff = 0;
	this.config.left = 0;
	this.config.top = 0;
	this.config.width = 0;
	this.config.height = 0;
	this.config.minWidth = 180;
	this.config.minHeight = 70;
	this.setConfig(config);
};

/**
 * \internal This function is called from the constructor, only once, to 
 * store only needed properties of the config object passed to the constructor.
 */
Zapatec.Window.prototype.setConfig = function (config) {
	this.config.showCloseButton = (typeof config.showCloseButton != "undefined") ? config.showCloseButton : true;
	this.config.raiseOnlyOnTitle = (typeof config.raiseOnlyOnTitle != "undefined") ? config.raiseOnlyOnTitle : true;
	this.config.canDrag = (typeof config.canDrag != "undefined") ? config.canDrag : true;
	this.config.modal = (typeof config.modal != "undefined") ? config.modal : false;
	this.config.onClose = (typeof config.onClose != "undefined") ? config.onClose : null;
	this.config.onShow = (typeof config.onShow != "undefined") ? config.onShow : null;
	this.config.onHide = (typeof config.onHide != "undefined") ? config.onHide : null;
	this.config.onRaise = (typeof config.onRaise != "undefined") ? config.onRaise : null;
	this.onContentLoad = (typeof config.onLoad != "undefined") ? config.onLoad : function () {};
};

/**
 * This is a setup function for Window object.
 *
 * It gathers some mostly common routines when seting up the Window object on your page.
 * For example it creates the simple window and shows it, or creates the popup window.
 * Mostly in all cases (except popup window) it will be initialy shown. Possible enhancement
 * is to add a property to control the initial state of the window (including minimized, maximized, etc)
 *
 * @param config [object] - all parameters are passed as the properties of this object. Many of them are 
 * the same as for the constructor.
 * 
 * Function recognizes the following properties of the config object (duplicated properties are listed in 
 * the constructor description so are not included here):
 * \code
 *    prop. name   | description
 *  -------------------------------------------------------------------------------------------------
 *   popup         | if it is set than window will be a popup window, triggered by the element you passed in this variable.
 *   triggerEvent  | if popup is set than this defines which event of the trigger element will force the window to popup. 
 *                 | Possible values: click, mousemove, mouseover, or any DOM event name.
 *   align         | align of the popup window relational to the trigger object. For information on values see the Zapatec.Window.prototype.showAtElement function description
 *   width         | initial width of the window in pixels.
 *   height        | initial height of the window in pixels.
 *   left          | initial X coordinate of the window.
 *   top           | initial Y coordinate of the window.
 *   title         | title of the window.
 *   content       | content of the window.
 *   divContent    | id of or "pointer" to the HTML element containing the content for the window.
 *   urlContent    | URL to load the content from.
 *   
 * \endcode
 */
Zapatec.Window.setup = function (config) {
	if (!config) {config = {};}
	var win = new Zapatec.Window(config);
	win.create(config.left || 0, config.top || 0, config.width || win.config.minWidth, config.height || win.config.minHeight);
	if (config.title) {
		win.setTitle(config.title);
	}
	if (config.content) {
		win.setContent(config.content);
	}
	if (config.divContent) {
     // Save divContent config option for later use
     win.config.divContent = config.divContent;
		win.setDivContent(config.divContent);
	}
	if (config.urlContent) {
		win.setContentUrl(config.urlContent);
	}
	win.show();
	
	return win;
}; 

/**
 * A function that is called to handle mousedown event for our window.
 *
 * This function handles the routines that should be done on mousedown. Target parameter determines
 * whether something was "pushed" and holds that "pushed" element. "pushed" means that mouse was down
 * on that element and was not released. buttonType property of the target element determines the action that will be made.
 * There is one usefull possibility: if the target element has the customMouseDown property and it holds 
 * function, this function will be called except the default action.
 *
 * @param ev [object] - event object.
 * @param win [object] - our window object.
 * @param target [object] - "pushed" element.
 */
Zapatec.Window.mouseDown = function (ev, win, target) {
	if (!win.config.raiseOnlyOnTitle) {
		win.raise();
	} else {
		if (target && ((target.buttonType == "move") || (target.buttonType == "min") || (target.buttonType == "max") || (target.buttonType == "close") || (target.buttonType == "restore"))) {
			win.raise();		
		}
	}
	if (target) {
		switch (target.buttonType) {
			case "move" : {
				if (!target.customMouseDown) {
					if (win.config.canDrag && win.config.state != "min" && win.config.state != "max") {
						var posX = ev.pageX || ev.clientX + window.document.body.scrollLeft || 0;
						var posY = ev.pageY || ev.clientY + window.document.body.scrollTop || 0;
						var L = parseInt(win.winDiv.style.left) || 0;
						var T = parseInt(win.winDiv.style.top) || 0;
						win.winDiv.xOffs = (posX - L);
						win.winDiv.yOffs = (posY - T);
						win.titleArea.style.cursor = "move";
					}
				} else {
					target.customMouseDown(ev, win, target);
				}
				break;
			}

			case "close" : {
				if (!target.customMouseDown) {
				} else {
					target.customMouseDown(ev, win, target);
				}
				break;
			}
		}
	}
}

/**
 * A function that is called to handle mousemove event for our window.
 *
 * This function handles the routines that should be done on mousedown. Target parameter determines
 * whether something was "pushed" and holds that "pushed" element. "pushed" means that mouse was down
 * on that element and was not released. buttonType property of the target element determines the action that will be made.
 * There is one usefull possibility: if the target element has the customMouseMove property and it holds 
 * function, this function will be called except the default action.
 *
 * @param ev [object] - event object.
 * @param win [object] - our window object.
 * @param target [object] - "pushed" element.
 */
Zapatec.Window.mouseMove = function (ev, win, target) {
	if (target) {
		switch (target.buttonType) {
			case "move" : {
				if (!target.customMouseMove) {
					if (win.config.canDrag && win.config.state != "min" && win.config.state != "max") {
						var posX = ev.pageX || ev.clientX + window.document.body.scrollLeft || 0;
						var posY = ev.pageY || ev.clientY + window.document.body.scrollTop || 0;
						var L = posX - win.winDiv.xOffs, T = posY - win.winDiv.yOffs;
						win.setPos(L, T);
					}
				} else {
					target.customMouseMove(ev, win, target);
				}
				break;
			}
		}
	}
}

/**
 * A function that is called to handle mouseup event for our window.
 *
 * This function handles the routines that should be done on mousedown. Target parameter determines
 * whether something was "pushed" and holds that "pushed" element. "pushed" means that mouse was down
 * on that element and was not released. buttonType property of the target element determines the action that will be made.
 * There is one usefull possibility: if the target element has the customMouseUp property and it holds 
 * function, this function will be called except the default action.
 *
 * @param ev [object] - event object.
 * @param win [object] - our window object.
 * @param target [object] - "pushed" element.
 */
Zapatec.Window.mouseUp = function (ev, win, target, hi) {
	if (target) {
		switch (target.buttonType) {
			case "move" : {
				if (!target.customMouseUp) {
					if (win.config.canDrag) {
						win.titleArea.style.cursor = "default";
					}
				} else {
					target.customMouseUp(ev, win, target);
				}
				break;
			}

			case "close" : {
				if (!target.customMouseUp) {
					if (target == (ev.srcElement || ev.target)) {
						win.close();
					}
				} else {
					target.customMouseUp(ev, win, target);
				}
				break;
			}
		}
	}
}

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
	Zapatec.Utils.addEvent(this.winDiv, "mousedown", function (ev) {
		ev = ev || window.event; 
		target = Zapatec.Utils.getTargetElement(ev);
		while(!target.buttonType && (target != self.winDiv)) {
			target = target.parentNode;
		}
		if (!target.buttonType) target = null;
		Zapatec.Window.mouseDown(ev, self, target);
		if (target) return Zapatec.Utils.stopEvent(ev);
	});
	Zapatec.Utils.addEvent(window.document, "mousemove", function (ev) {
		ev = ev || window.event; 
		Zapatec.Window.mouseMove(ev, self, target);
		if (target) return Zapatec.Utils.stopEvent(ev);
	});
	Zapatec.Utils.addEvent(window.document, "mouseup", function (ev) {
		ev = ev || window.event; 
		Zapatec.Window.mouseUp(ev, self, target);
		target = null;
		if (target) return Zapatec.Utils.stopEvent(ev);
	});
}

/*
 * \internal
 * For internal use only. Calculates some sizes needed to implement title and status text cutting and content scrolling.
 */
Zapatec.Window.prototype.calculateSizes = function () {
	this.winDiv.style.display = "block";
	if (this.titleArea) {
		//Safari Fix
		this.config.titleWidth = this.config.width - (this.winDiv.offsetWidth - (Zapatec.is_khtml ? this.titleText.firstChild.offsetWidth : this.titleText.offsetWidth));
		//Safari Fix
		if (Zapatec.is_khtml) this.titleText.removeChild(this.titleText.firstChild);
	}
	
	if (this.contentArea) {
		//Safari Fix
		this.config.contentWidthDiff = this.winDiv.offsetWidth - (Zapatec.is_khtml ? this.contentArea.firstChild.offsetWidth : this.contentArea.offsetWidth);
		this.config.contentWidth = this.config.width - this.config.contentWidthDiff;
		//Safari Fix
		if (Zapatec.is_khtml) this.contentArea.removeChild(this.contentArea.firstChild);
	}
	
	this.config.heightDiff = this.winDiv.offsetHeight - this.config.height;
	this.winDiv.style.display = "none";
}

/**
 * Creates all HTML elements of the window. This function takes in account
 * this.config object, trough its properties you can disable the following elements:
 *  - The whole title (currently don't work) - this.showTitle property;
 *  - Any of 3 buttons (min, max, close) - this.show(Min|Max|Close)Button property;
 *  - The status area - this.showStatus property;
 *  - The resize icon - this.canResize property;
 * Also calls this.addEvents to assign event handlers to the main div and creates WCH 
 * (http://www.aplus.co.yu/WCH/).
 * This function defines the following properties for HTML elements, needed for event handlers:
 *  - buttonType - one of three buttons or resize icon;
 *
 * @param x [integer] x coordinate.
 * @param y [integer] y coordinate.
 * @param width [integer] width of the window.
 * @param height [integer] height of the window.v
 *
 * @return [object] { x, y } containing the position.
 */
Zapatec.Window.prototype.create = function (x, y, width, height)  {
	if (width == "auto") {
		this.config.autoContentWidth = true;
	}
	if (height == "auto") {
		this.config.autoContentHeight = true;
	}
	var noButtons = !(this.config.showCloseButton);
	var config = this.config;
	//creating of the top level div to control the width and position of the window
	var div = this.winDiv = Zapatec.Utils.createElement("div", null, true);
	div.style.position = "absolute";
	div.style.width = (this.config.width = parseInt(width, 10) || this.config.minWidth) + "px";
	div.style.display = "none";
	this.config.visible = false;
	this.addEvents();
	
	//creating of another div with zpWin class
	div = Zapatec.Utils.createElement("div", div, true);
	div.className = "zpWin";
	
	//table with all the elements
	var table = Zapatec.Utils.createElement("table", div, true);
	table.border = 0;
	table.cellPadding = "0";
	table.cellSpacing = "0";
	
	var tbody = Zapatec.Utils.createElement("tbody", table, true);
	
	//title area of the window
	if (config.showTitle == true) {
		var tr = this.titleArea = Zapatec.Utils.createElement("tr", tbody);
		tr.buttonType = "move";
		tr.className = "zpWinTitleArea";
		
		//additional cell for ronded borders in title
		var td = Zapatec.Utils.createElement("td", tr);
		div = Zapatec.Utils.createElement("div", td);
		div.innerHTML = "&nbsp;";

		//cell with title text
		td = Zapatec.Utils.createElement("td", tr);
		td.style.width = "100%";
		
		div = this.titleText = Zapatec.Utils.createElement("div", td);
		div.className = "zpWinTitleText";
		div.style.overflow = "hidden";
		div.style.height = "100%";
		//Safari Fix
		if (Zapatec.is_khtml) div = Zapatec.Utils.createElement("div", div);
		div.appendChild(document.createTextNode(""));
			
		//cell with close button
		td = Zapatec.Utils.createElement("td", tr);
		
		if (config.showCloseButton == true) {		
			div = this.closeButton = Zapatec.Utils.createElement("div", td);
			div.style.overflow = "hidden";
			div.buttonType = "close";
			div.className = "zpWinCloseButton";
		} else if (!Zapatec.is_ie && noButtons) {
			//a workaround for Gecko's behaviour(we need to create at least one button cell for the window to be shown correctly).
			div = Zapatec.Utils.createElement("div", td);
			div.innerHTML = "&nbsp;";
		}
		tr.firstChild.id = "titleFirstCell";
		tr.lastChild.id = "titleLastCell";
	}
	
	//creating content area
	tr = Zapatec.Utils.createElement("tr", tbody, true);
		
	td = Zapatec.Utils.createElement("td", tr, true);
	td.colSpan = 5;
	td.id = "contentCell";
		
	div = this.contentArea = document.createElement("div");
	td.appendChild(div);
	div.style.height = (this.config.height = parseInt(height, 10) || this.config.minHeight) + "px";
	div.style.overflow = "auto";
	div.className = "zpWinContent";
	//Safari Fix
	if (Zapatec.is_khtml) div = Zapatec.Utils.createElement("div", div);
	div.appendChild(document.createTextNode(""));
		
	window.document.body.appendChild(this.winDiv);
	//Seting widths of title, content and status elements for IE to proceed overflows.
	this.calculateSizes();
	var size = Zapatec.Utils.getWindowSize(); 
	var br = {};
	if (Zapatec.is_ie) {
		br.y = window.document.body.scrollTop;
		br.x = window.document.body.scrollLeft;
	} else {
		br.y = window.scrollY || 0;
		br.x = window.scrollX || 0;
	}
 	if (x == 'center') { 
 		if (screen.width) { 
 			x = (size.width -  this.config.width)/2 + br.x; 
 		} 
 	} 
 	if (y == 'center') { 
 		if (screen.height) { 
			y = (size.height - (this.config.height + this.config.heightDiff))/2 + br.y; 
 		} 
 	}
	this.winDiv.style.left = (this.config.left = x) + "px";
	this.winDiv.style.top = (this.config.top = y) + "px";
	if (this.titleText) this.titleText.style.width = this.config.titleWidth + "px";
	if (this.contentArea) this.contentArea.style.width = this.config.contentWidth + "px";
	
	//Creating WCH
	this.WCH = Zapatec.Utils.createWCH();
	
	//Activating window.
	if (this.config.modal == true) {
		this.modalLayer = Zapatec.Utils.createElement("DIV", document.body);
		var st = this.modalLayer.style;
		st.display = "none";
		st.position = "absolute";
		st.top = br.y + "px";
		st.left = br.x + "px";
		var dim = Zapatec.Utils.getWindowSize();
		st.width = dim.width + "px";
		st.height = dim.height + "px";
		st.zIndex = Zapatec.Window.maxNumber++;
		this.modalLayer.className = "zpWinModal";
		Zapatec.ScrollWithWindow.register(this.modalLayer);
	}
	this.setNumber();
	this.winDiv.style.zIndex = Zapatec.Window.maxNumber;
	Zapatec.Window.winArray.push(this);
	this.setCurrent();
	//alert(document.getElementById("1").innerHTML);
	return true;
}	

// Global that holds the array of all the windows on the page
Zapatec.Window.winArray = [];
// Global that keeps track of max number of windows
Zapatec.Window.maxNumber = 0;
// Global that holds the pointer to the current window
Zapatec.Window.currentWindow = null;
// Global that keeps last active window
Zapatec.Window.lastActive = null;

/*
 * \internal
 * For internal use only.
 * Increment the max number of windows
 */
Zapatec.Window.prototype.setNumber = function() {
	this.winNumber = ++Zapatec.Window.maxNumber;
};

/*
 * \internal
 * For internal use only.
 * Sets the current window
 */

Zapatec.Window.prototype.setCurrent = function(deb) {
	var win = this;
	if (!win.winDiv) {
		return false;
	}
	if (Zapatec.Window.currentWindow && //if it is not the first one
			win != Zapatec.Window.currentWindow) { //and it is not the same one as before
		//Show the previous window as not being the current window anymore
		if (Zapatec.Window.currentWindow.winDiv) {
			Zapatec.Utils.removeClass(Zapatec.Window.currentWindow.winDiv, 'zpWinFront');
			Zapatec.Utils.addClass(Zapatec.Window.currentWindow.winDiv, 'zpWinBack');
		}
		if (Zapatec.Window.currentWindow.winDiv) {
			Zapatec.Window.lastActive = Zapatec.Window.currentWindow;
		} 
	}
	//And set the current window
	Zapatec.Window.currentWindow = win;
	Zapatec.Utils.removeClass(win.winDiv, 'zpWinBack');
	Zapatec.Utils.addClass(win.winDiv, 'zpWinFront');
	return true;
}

/* 
 * Set the content of a window.
 * @param type [string] the HTML data to set the content to.
 */

Zapatec.Window.prototype.setContent = function(text) {
	if (!this.winDiv) {
		return false;
	}
	if (this.config.autoContentWidth) {
		if (this.titleText) this.titleText.style.width = "auto";
		if (this.contentArea) {
			this.contentArea.style.width = "auto";
		}
		if (this.statusArea) this.statusArea.style.width = "auto";
		this.contentArea.style.overflow = "visible";
	}
	if (this.config.autoContentHeight) {
		if (this.contentArea) {
			this.contentArea.style.height = "auto";
		}
	}

	this.contentArea.innerHTML = text;

	if (this.config.autoContentWidth || this.config.autoContentHeight) {
		var shown = false;
		if (this.winDiv.style.display != "block") {
			this.show();
			shown = true;
		}
		if (this.config.autoContentWidth) this.setWidth(this.contentArea.offsetWidth + this.config.contentWidthDiff);
		if (this.config.autoContentHeight) this.setHeight(this.contentArea.offsetHeight + (Zapatec.is_opera ? 4 : 0));
		this.contentArea.style.overflow = "auto";
		if (shown) this.hide();
	}
	return true;
}

/* 
 * Set the content of a window from HTML element(DIV).
 * @param div [string]or [object] the HTML data to set the content to.
 */

Zapatec.Window.prototype.setDivContent = function(div) {
	if (!this.winDiv) {
		return false;
	}
	if (typeof div == "string") {
		div = document.getElementById(div);
	}
	if (div && this.contentArea) {
		if (this.config.autoContentWidth) {
			if (this.titleText) this.titleText.style.width = "auto";
			if (this.contentArea) {
				this.contentArea.style.width = "auto";
			}
			if (this.statusArea) this.statusArea.style.width = "auto";
			this.contentArea.style.overflow = "visible";
		}
		if (this.config.autoContentHeight) {
			if (this.contentArea) {
				this.contentArea.style.height = "auto";
			}
		}

		var objChild = null;
	    // Remove all previous window content
	    objChild = this.contentArea.firstChild;
	    while (objChild) {
	      this.contentArea.removeChild(objChild);
	      objChild = this.contentArea.firstChild;
	    }
	    // Move all children to the window
	    objChild = div.firstChild;
	    while (objChild) {
	      this.contentArea.appendChild(objChild);
	      objChild = div.firstChild;
	    }

		if (this.config.autoContentWidth || this.config.autoContentHeight) {
			var shown = false;
			if (this.winDiv.style.display != "block") {
				this.show();
				shown = true;
			}
			if (this.config.autoContentWidth) this.setWidth(this.contentArea.offsetWidth + this.config.contentWidthDiff);
			if (this.config.autoContentHeight) this.setHeight(this.contentArea.offsetHeight + (Zapatec.is_opera ? 4 : 0));
			this.contentArea.style.overflow = "auto";
			if (shown) this.hide();
		}
	}
	return true;
}

/* 
 * Set the content of a window from url.
 * @param div [string]or [object] the HTML data to set the content to.
 */

Zapatec.Window.prototype.setContentUrl = function(url) {
	if (!this.winDiv) {
		return false;
	}
	var self = this;
	Zapatec.Transport.fetch({
		url : url, 
		onLoad : function (result) {
			//FIXED: <script>s didn't actually were executed on loaded piece of HTML, which I think was a problem
			var text = result.responseText, script, scripts = [], attrs;
			while (script = text.match(/<script([^>]*)>([^<]*)<\/script>/)) {
				text = text.replace(/<script[^>]*>[^<]*<\/script>/, "");
				scripts.push(script);
			}
			self.setContent(text);
			for(i in scripts) {
				// Evaluate code in global scope
				setTimeout(scripts[i][2], 0);
			}
			self.onContentLoad();
		},
		onError : function () {
			alert('Error while fetching data from the server');
		}
	});
	return true;
}

/*
 * Set the title of the window
 * @param type [string] the title to set to
 */ 
Zapatec.Window.prototype.setTitle = function(text) {
	if (!this.winDiv) {
		return false;
	}
	if (text === '') {
		this.titleText.innerHTML = 'Window ' + this.winNumber;
	} else {
		this.titleText.innerHTML = text;
	}
	return true;
}

/**
 * Updates the window "WCH" (windowed controls hider).  A WCH is an
 * "invention" (read: "miserable hack") that works around one of the most
 * common and old bug in Internet Explorer: the SELECT boxes or IFRAMES show on
 * top of any other HTML element.  This function makes sure that the WCH covers
 * correctly the window element and another element if passed.
 */
Zapatec.Window.prototype.updateWCH = function() {
	if (this.WCH && this.WCH.style.bottom != "") {
		this.WCH.style.bottom = "";
	}
	Zapatec.Utils.setupWCH(this.WCH, this.config.left, this.config.top, this.config.width, this.config.height + this.config.heightDiff - 2);
	return true;
}

/**
 * Sets the X coordinate of the window. Needed to synchronize some variables in
 * one place. Also updates the WCH for IE.
 *
 * @param left [integer] - X coordinate.
 */
Zapatec.Window.prototype.setLeft = function(left) {
	if (!this.winDiv) {
		return false;
	}
	(left < 0) && (left = 0);
	this.winDiv.style.left = (this.config.left = left) + "px";
	this.updateWCH();
	return true;
}

/**
 * Sets the Y coordinate of the window. Needed to synchronize some variables in
 * one place. Also updates the WCH for IE.
 *
 * @param top [integer] - Y coordinate.
 */
Zapatec.Window.prototype.setTop = function(top) {
	if (!this.winDiv) {
		return false;
	}
	(top < 0) && (top = 0);
	this.winDiv.style.top = (this.config.top = top) + "px";
	this.updateWCH();
	return true;
}

/**
 * Sets the width of the window. Needed to synchronize some variables in
 * one place. Also updates the WCH for IE.
 *
 * @param width [integer] - width of the window.
 */
Zapatec.Window.prototype.setWidth = function(width) {
	if (!this.winDiv) {
		return false;
	}
	var diff = this.config.width - width;
	if (Zapatec.is_gecko) {
	}
	this.winDiv.style.width = (this.config.width = width) + "px";
	if (this.titleText) this.titleText.style.width = (this.config.titleWidth -= diff) + "px";
	if (this.contentArea) this.contentArea.style.width = (this.config.contentWidth -= diff) + "px";
	this.updateWCH();
	return true;
}

/**
 * Sets the height of the window. Needed to synchronize some variables in
 * one place. Also updates the WCH for IE.
 *
 * @param height [integer] - height of the window.
 */
Zapatec.Window.prototype.setHeight = function(height) {
	if (!this.winDiv) {
		return false;
	}
	this.contentArea.style.height = (this.config.height = height) + "px";
	this.updateWCH();
	return true;
}

/**
 * Sets the position of the window. 
 *
 * @param left [integer] - X coordinate.
 * @param top [integer] - Y coordinate.
 */
Zapatec.Window.prototype.setPos = function(left, top) {
	if (!this.winDiv) {
		return false;
	}
	this.setLeft(left);
	this.setTop(top);
	return true;
}

/**
 * Sets the sizes of the window. 
 *
 * @param width [integer] - width of the window.
 * @param height [integer] - height of the window.
 */
Zapatec.Window.prototype.setSize = function(width, height) {
	if (!this.winDiv) {
		return false;
	}
	this.setWidth(width);
	this.setHeight(height);
	return true;
}


/**
 * Sets the sizes and position of the window. 
 *
 * @param left [integer] - X coordinate.
 * @param top [integer] - Y coordinate.
 * @param width [integer] - width of the window.
 * @param height [integer] - height of the window.
 */
Zapatec.Window.prototype.setPosAndSize = function(left, top, width, height) {
	if (!this.winDiv) {
		return false;
	}
	this.setPos(left, top);
	this.setSize(width, height);
	return true;
}

/**
 * Raise this window so that it's above all other.
 * Bring it to the front.
 */ 
Zapatec.Window.prototype.raise = function() {
	if (!this.winDiv) {
		return false;
	}
	Zapatec.Window.maxNumber++; //increment so it's more than all the others
	this.winDiv.style.zIndex = Zapatec.Window.maxNumber;
	this.setCurrent(this);
	if (this.config.onRaise) {
		this.config.onRaise(this);
	}
	
	return true;
}

/**
 * Shows the window.
 */ 
Zapatec.Window.prototype.show = function() {
	if (!this.winDiv) {
		return false;
	}
	this.winDiv.style.display = "block";
	if (this.config.modal == true && this.modalLayer) {
		this.modalLayer.style.display = "block";
	}
	this.updateWCH();
	this.config.visible = true;	
	if (this.config.onHide) {
		this.config.onHide(this);
	}
	return true;
}

/**
 * Hides the window.
 */ 
Zapatec.Window.prototype.hide = function() {
	if (!this.winDiv) {
		return false;
	}
	this.winDiv.style.display = "none";
	if (this.config.modal == true && this.modalLayer) {
		this.modalLayer.style.display = "none";
	}
	Zapatec.Utils.hideWCH(this.WCH);
	this.config.visible = false;	
	if (this.config.onHide) {
		this.config.onHide(this);
	}
	return true;
}

/**
 * Closes the window. Currently does not destroys the window object, just the HTML part of it
 */ 
Zapatec.Window.prototype.close = function() {
  	if (!this.winDiv) {
		return false;
	}
	// Return content back to the place it was taken from
  if (this.config.divContent && this.contentArea) {
    var objContent = null;
    if (typeof this.config.divContent == 'string') {
      objContent = document.getElementById(this.config.divContent);
    } else if (typeof this.config.divContent == 'object') {
      objContent = this.config.divContent;
    }
    if (objContent) {
      var objChild = this.contentArea.firstChild;
      while (objChild) {
        objContent.appendChild(objChild);
        objChild = this.contentArea.firstChild;
      }
    }
  }
  // Destroy window
	Zapatec.Utils.destroy(this.winDiv);
	Zapatec.Utils.destroy(this.WCH);
	if (this.config.modal == true && this.modalLayer) {
		Zapatec.Utils.destroy(this.modalLayer);
	}
	delete this.winDiv;
	for (i in Zapatec.Window.winArray) {
		if (Zapatec.Window.winArray[i] == this) {
			Zapatec.Window.winArray[i] = null;
		}
	}
	if (Zapatec.Window.lastActive) {
		Zapatec.Window.lastActive.setCurrent();
	}
	if (this.config.onClose) {
		this.config.onClose(this);
	}
	return true;
}

/**
 * Destroy the window.
 */ 
Zapatec.Window.prototype.destroy = function() {
	this.close();
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
	if (!this.winDiv) {
		return false;
	}
	var self = this;
	var p = Zapatec.Utils.getAbsolutePos(el);
	if (!opts || typeof opts != "string") {
		this.showAt(p.x, p.y + el.offsetHeight);
		return true;
	}
	this.winDiv.style.display = "block";
	var w = self.winDiv.offsetWidth;
	var h = self.winDiv.offsetHeight;
	self.winDiv.style.display = "none";
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
	Zapatec.Utils.fixBoxPosition(p);
	self.showAt(p.x, p.y);
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
	if (!this.winDiv) {
		return false;
	}
	this.setPos(x, y);
	this.show();
	return true;
}

