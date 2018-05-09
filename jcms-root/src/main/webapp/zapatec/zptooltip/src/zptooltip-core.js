/**
 * @fileoverview Zapatec Tooltip widget.
 *
 * <pre>
 * Copyright (c) 2004-2008 by Zapatec, Inc.
 * http://www.zapatec.com
 * 1700 MLK Way, Berkeley, California,
 * 94709, U.S.A.
 * All rights reserved.
 * </pre>
 */

/* $Id$ */

/**
 * Zapatec.Tooltip constructor. Creates a new tooltip object with
 * given parameters.
 *
 * @constructor
 * @extends Zapatec.Widget
 * @param {object} objArgs Tooltip configuration
 *
 * Constructor recognizes the following properties of the config object
 * \code
 *  property name     | description
 *-------------------------------------------------------------------------------------------------
 * target   | [string or object] Reference to DOM element that is being described
 *          | by the tooltip. Tooltip appears when mouse hovers over this element.
 * source   | [string or object] Reference to DOM element of the actual tooltip.
 * sourceType | type of source that will be fetched. See Zapatec.Widget documentation for examples.
 * parent   | [string or object] Reference to DOM element that is going to be used
 *          | for tooltip parent
 * movable  | [boolean] Makes the tooltip move with the mouse.
 * content  | [string] Tooltip html content
 * \endcode
 *
 */
Zapatec.Tooltip = function(objArgs) {
  if (arguments.length == 0) {
    objArgs = {};
  }

  // Call constructor of superclass
  Zapatec.Tooltip.SUPERconstructor.call(this, objArgs);
};

/**
 * Unique static id of the widget class. Gives ability for Zapatec#inherit to
 * determine and store path to this file correctly when it is included using
 * Zapatec#include. When this file is included using Zapatec#include or path
 * to this file is gotten using Zapatec#getPath, this value must be specified
 * as script id.
 * @private
 */
Zapatec.Tooltip.id = 'Zapatec.Tooltip';

// Inherit Widget
Zapatec.inherit(Zapatec.Tooltip, Zapatec.Widget);

/**
 * Initializes object.
 *
 * @param {object} objArgs User configuration
 */
Zapatec.Tooltip.prototype.init = function(objArgs)
{
  // Call parent init
  Zapatec.Tooltip.SUPERclass.init.call(this, objArgs);

  //. Flag for tooltip createtion
  this.isCreate = false;

 
  this.setEvents();
};

/**
 * Configures the widget. Gets called from init and reconfigure methods of
 * superclass.
 *
 * @private
 * @param {object} objArgs User configuration
 */
Zapatec.Tooltip.prototype.configure = function(objArgs) {
  // Target element
  this.defineConfigOption('target', null);
  // Tooltip element
  this.defineConfigOption('tooltip', null); // Deprecated param. Use "tooltip" option instead. If given - Zapatec.Tooltip will replace "tooltip" element
  // Tooltip parent element
  this.defineConfigOption('parent', null);
  // Tooltip moves with mouse parameter
  this.defineConfigOption('movable', false);
  // Tooltip html content parameter
  this.defineConfigOption('content', null);
  // Tooltip source option
  this.defineConfigOption('source', null);
  // Tooltip sourceType option
  this.defineConfigOption('sourceType', 'html');
  // If set - save/load cookie
  this.defineConfigOption('isCashed', false);
  	
  // Offsets from mouse cursor to tooltip
  this.defineConfigOption('offsetX', 2);
  this.defineConfigOption('offsetY', 20);

  // Call parent method
  Zapatec.Tooltip.SUPERclass.configure.call(this, objArgs);

  // Check target config option
  if (typeof this.config.target == "string") {
  	this.config.target = Zapatec.Widget.getElementById(this.config.target);
  }
  if (!this.config.target) {
    Zapatec.Log({description: "Can't find tooltip target (\"target\" config option)"});
    return false;
  }
  
  // Check tooltip config option
  if (typeof this.config.source == "string") {
  	this.config.source = Zapatec.Widget.getElementById(this.config.source);
  }

  // Old engine
  if (this.config.tooltip != null && this.config.source == null) {
  	this.config.source = this.config.tooltip;
	this.config.sourceType = 'html';
	// Check tooltip config option
  	if (typeof this.config.source == "string") {
  		this.config.source = Zapatec.Widget.getElementById(this.config.source);
  	}
	
	// If tooltip config option is not provided
  	if (!this.config.source) {
    	// If tooltip html content config option is provided
    	if (this.config.content) {
      		this.tooltip = Zapatec.Utils.createElement("div");
    	}
    	else {
      		Zapatec.Log({description: "Can't find \"source\" config option"});
      		return false;
    	}
  	}
   	// If tooltip html content config option is provided
  	if (this.config.content) {
 	   this.setContent(this.config.content);
  	}
   }	
  
  // Hide tooltip data
  if (this.config.source && this.config.source.style)
  	this.config.source.style.display = 'none';		
  
  // Check parent config option
  if (typeof this.config.parent == "string") {
    this.config.parent = Zapatec.Widget.getElementById(this.config.parent);
  }
};

Zapatec.Tooltip.prototype.reconfigure = function(oArg) {
  // Call parent method
  Zapatec.Tooltip.SUPERclass.reconfigure.call(this, oArg);

  this.init();
};

/**
 * Creates elements needed by the tooltip. This function links a
 * tooltip element which can be anywhere in the DOM tree to some target
 * element.  Then, when the end-user hovers the target element, the tooltip
 * will appear near the mouse position.
 */
Zapatec.Tooltip.prototype.createTooltip = function () {
  var self = this;
  // Prevent tooltip from showing on the page
  this.loadCookie();
  
  this.tooltip = Zapatec.Utils.createElement("div");		
  this.visible = false;
  this.tooltip.style.position = 'absolute';
  this.inTooltip = false;
  this.timeout = null;
  var parentNotDefined = !this.config.parent;
  if (parentNotDefined) {
    this.config.parent = this.config.target;
  }
  var parent = this.config.parent;
  if (parentNotDefined && parent.tagName && parent.tagName.toLowerCase() == "input") {
    document.body.appendChild(this.tooltip);
  }
  else {
    parent.appendChild(this.tooltip);
  }
  Zapatec.Utils.addClass(this.tooltip,
          this.getClassName({prefix: "zpTooltip", suffix: ""}));
  
  // Load tooltip data
  Zapatec.Transport.showBusy({busyContainer: this.tooltip});
  this.loadData();
  this.saveCookie();
  Zapatec.Transport.removeBusy({busyContainer: this.tooltip});
     
  if (this.tooltip.title) {
    var title = Zapatec.Utils.createElement("div");
    this.tooltip.insertBefore(title, this.tooltip.firstChild);

    title.className = this.getClassName({prefix: "zpTooltip", suffix: "Title"});
    title.innerHTML = unescape(this.tooltip.title);
    // Remove browser tooltip
    this.tooltip.title = "";
  }

  // Create WCH
  this.wch = Zapatec.Utils.createWCH(this.tooltip);
  // Put WCH under container
  if (this.wch) {
    this.wch.style.zIndex = -1;
  }

  // Create mouse over listener for the tooltip element
  this.createProperty(this, '_tooltipMouseOverListener', function(ev) {
    self.inTooltip = true;
    return true;
  });
  Zapatec.Utils.addEvent(this.tooltip, "mouseover",
          this._tooltipMouseOverListener);

  // Create mouse out listener for the tooltip element
  this.createProperty(this, '_tooltipMouseOutListener', function(ev) {
    ev || (ev = window.event);
    if (!Zapatec.Utils.isRelated(self.tooltip, ev)) {
      self.inTooltip = false;
      self.hide();
    }
    return true;
  });
  Zapatec.Utils.addEvent(this.tooltip, "mouseout",
          this._tooltipMouseOutListener);
		  
  this.isCreate = true;	
}

/**
 * Set an event listeners tio the target element
 */
Zapatec.Tooltip.prototype.setEvents = function () {
	var self = this;
		
	// Create mouse over listener for the target element
	this.createProperty(this, '_targetMouseOverListener', function(ev) {
    	return self._onMouseMove(ev);
  	});
  	Zapatec.Utils.addEvent(this.config.target, "mouseover",
    	this._targetMouseOverListener);

	// If tooltip is to move with mouse
  	if (this.config.movable) {
    	// Create mouse movement listener for the target element
    		this.createProperty(this, '_targetMouseMoveListener', function(ev) {
      			return self._onMouseMove(ev);
    		});
    	Zapatec.Utils.addEvent(this.config.target, "mousemove",
        	this._targetMouseMoveListener);
  	}

  	// Create mouse out listener for the target element
  	this.createProperty(this, '_targetMouseOutListener', function(ev) {
    	return self._onMouseOut(ev);
  	});
  	Zapatec.Utils.addEvent(this.config.target, "mouseout",
    	this._targetMouseOutListener);
}

/**
 * Destroys elements needed by the tooltip and removes events.
 */
Zapatec.Tooltip.prototype.destroy = function () {
  // Hide tooltip if needed
  this.hide();

  // Remove events associated with the target element
  Zapatec.Utils.removeEvent(this.config.target, "mouseover",
          this._targetMouseOverListener);
  Zapatec.Utils.removeEvent(this.config.target, "mousemove",
          this._targetMouseMoveListener);
  Zapatec.Utils.removeEvent(this.config.target, "mouseout",
          this._targetMouseOutListener);

  // Remove events associated with the tooltip element
  Zapatec.Utils.removeEvent(this.tooltip, "mouseover",
          this._tooltipMouseOverListener);
  Zapatec.Utils.removeEvent(this.tooltip, "mouseout",
          this._tooltipMouseOutListener);

  if (this.wch) {
    // Destroy WCH
    this.wch.parentNode.removeChild(this.wch);
  }
}

/**
 * Automagically create tooltips from DFN tags.  The HTML syntax is simple:
 *
 * \code
 *   <dfn title="Tooltip title">
 *      Tooltip contents
 *   </dfn>
 * \endcode
 *
 * Calling this function once when the document has finished loading
 * (body.onload) will turn all DFN tags into tooltips.  Nice, eh?
 *
 * The optional "class_re" parameter allows one to filter elements by some
 * class name.  It can be a RegExp object or a string; if it's a string, only
 * DFN-s containing that string in the value of the "class" attribute will be
 * considered.  If it's a RegExp, only those DFN-s where the value of the class
 * attribute matches the RegExp will be considered.
 *
 * The DFN tag is a standard HTML element.  It's purpose is to markup a
 * \em definition, which seems fairly close to the purpose of a tooltip.
 *
 * @param class_re [string or RegExp, optional] -- filter the DFN elements that display tooltip
 */
Zapatec.Tooltip.setupFromDFN = function(class_re) {
  // init tooltips
  var dfns = document.getElementsByTagName("dfn");
  if (typeof class_re == "string")
    class_re = new RegExp("(^|\\s)" + class_re + "(\\s|$)", "i");
  
  var dfn, div, oTooltip, dfnClass;
  for (var i = dfns.length-1; i >= 0; i--) {
    dfn = dfns[i];
    if (!class_re || class_re.test(dfn.className)) {
      div = document.createElement("div");
	  if (dfn.title) {
        div.title = dfn.title;
        dfn.title = "";
      }
      div.className = dfn.className;
      if (dfn.style.width) {
		 div.style.width = dfn.style.width;
	  }
      if (dfn.style.height) {
		div.style.height = dfn.style.height;
	  }
      
      while (dfn.firstChild)
        div.appendChild(dfn.firstChild);
      dfn.innerHTML = "?";
      oTooltip = new Zapatec.Tooltip({
        target: dfn,
		parent: document.body,
        source: div
      });
      dfnClass = oTooltip.getClassName({
        prefix: "zpTooltip",
        suffix: "Dfn"
      });
	  
      Zapatec.Utils.addClass(dfn, dfnClass);
    }
  }
  // nice isn't it? :D
};

/** < [internal] keeps a reference to the currently displayed tooltip */
Zapatec.Tooltip._currentTooltip = null;

/**
 * Called automatically when "onmouseover" or "onmousemove" occurs on the
 * target element.  This function takes care to display the tooltip, if not
 * already visible, and to clear the timeout if the tooltip was set to hide.
 *
 * @param ev [Event] the event object
 */
Zapatec.Tooltip.prototype._onMouseMove = function(ev) {
  	ev || (ev = window.event);
	if (!this.isCreate)
  		this.createTooltip();
  	if (!this.isCreate) 
  		this.createTooltip();
	if (this.timeout) {
    	clearTimeout(this.timeout);
    	this.timeout = null;
  	}
  	if ((!this.visible || this.config.movable) &&
    	  !Zapatec.Utils.isRelated(this.config.target, ev)) {
    	var oPos = Zapatec.Utils.getMousePos(ev);
    	this.show(oPos.pageX + this.config.offsetX, oPos.pageY + this.config.offsetY);
  	}

  	return true;
};

/**
 * Called automatically when "onmouseout" occurs on the target element.  This
 * function sets a timeout that will hide the tooltip in 150 milliseconds.
 * This timeout can be cancelled if during this time the mouse returns to the
 * target element or enters the tooltip element.
 *
 * @param ev [Event] the event object.
 */
Zapatec.Tooltip.prototype._onMouseOut = function(ev) {
  ev || (ev = window.event);
  if (!this.isCreate)
  	this.createTooltip();
  var self = this;
  if (!Zapatec.Utils.isRelated(this.config.target, ev)) {
    if (this.timeout) {
      clearTimeout(this.timeout);
      this.timeout = null;
    }
    this.timeout = setTimeout(function() {
      self.hide();
    }, 150);
  }
  return true;
};

/**
 * Show the tooltip at a specified position.
 *
 * @param x [number] the X coordinate
 * @param y [number] the Y coordinate
 */
Zapatec.Tooltip.prototype.show = function(x, y) {
  if (Zapatec.Tooltip._currentTooltip) {
    if (Zapatec.Tooltip._currentTooltip.timeout) {
      clearTimeout(Zapatec.Tooltip._currentTooltip.timeout);
      Zapatec.Tooltip._currentTooltip.timeout = null;
    }
    Zapatec.Tooltip._currentTooltip.hide();
  }

  // Display tooltip
  this.tooltip.style.display = 'block';
  // If tooltip position is not specified
  if (null == x && null == y) {
    var targetOffset = Zapatec.Utils.getElementOffset(this.config.target);
    x = targetOffset.left;
    y = targetOffset.top;
  }

  this.tooltip.style.left = x + 'px';
  this.tooltip.style.top = y + 'px';

  // Adjust tooltip position because it may be inside relatively positioned element
  var oOffset = Zapatec.Utils.getElementOffset(this.tooltip);
  var iDiffLeft = x - oOffset.left;
  if (iDiffLeft) {
    x += iDiffLeft;
    this.tooltip.style.left = x + 'px';
  }
  var iDiffTop = y - oOffset.top;
  if (iDiffTop) {
    y += iDiffTop;
    this.tooltip.style.top = y + 'px';
  }
  // Adjust tooltip position if it is displayed outside of visible area
  oOffset = Zapatec.Utils.getElementOffset(this.tooltip);
  var iRight = oOffset.left + oOffset.width;
  var iBottom = oOffset.top + oOffset.height;
  var oWindowSize = Zapatec.Utils.getWindowSize();
  var iWinW = Zapatec.Utils.getPageScrollX() + oWindowSize.width;
  var iWinH = Zapatec.Utils.getPageScrollY() + oWindowSize.height;
  if (iRight > iWinW) {
    x += iWinW - iRight;
    this.tooltip.style.left = x + 'px';
  }
  if (iBottom > iWinH) {
    y += iWinH - iBottom;
    this.tooltip.style.top = y + 'px';
  }
  // Setup WCH
  Zapatec.Utils.setupWCH(this.wch, 0, 0, oOffset.width, oOffset.height);

  Zapatec.Utils.addClass(this.config.target,
          this.getClassName({prefix: "zpTooltip", suffix: "Hover"}));
  this.visible = true;
  Zapatec.Tooltip._currentTooltip = this;
};

/**
 * Hides the tooltip.
 */
Zapatec.Tooltip.prototype.hide = function() {
  if (!this.inTooltip) {
    this.tooltip.style.display = "none";
    Zapatec.Utils.hideWCH(this.wch);
    Zapatec.Utils.removeClass(this.config.target,
            this.getClassName({prefix: "zpTooltip", suffix: "Hover"}));
    this.visible = false;
  }
};

/**
 * Set tooltip html content
 */
Zapatec.Tooltip.prototype.setContent = function(html) {
  this.tooltip.innerHTML = html;
};

/**
 * Load cookie, if it was saved.
 * no paramiters
 */
Zapatec.Tooltip.prototype.loadCookie = function() {
  if (this.config.isCashed) { //If saveDate is on We're saving the date in a cookie
    //fetch the cookie
    var cookieName = window.location.href + "--" + this.config.target.id;
    var text = Zapatec.Utils.getCookie(cookieName);
	if (text) {
    	tmp = Zapatec.Utils.loadPref(text);
    	if (tmp)
      	Zapatec.Utils.mergeObjects(this.tooltip, tmp);
  	}
  }	
};

/**
 * Set cookie.
 * no paramiters
 */
Zapatec.Tooltip.prototype.saveCookie = function (){
	if (this.config.isCashed) {
		var cookieName = window.location.href + "--" + this.config.target.id;
		Zapatec.Utils.writeCookie(cookieName, Zapatec.Utils.makePref(this.tooltip), null, '/', 30);
	}
}; 

/**
* @private Function to load tree content on tree load from JSON source.
* @param objResponse {Object} Server response
*/
Zapatec.Tooltip.prototype.loadDataJson = function(objResponse){
  if(objResponse == null){
    return null;
  }
  
  if (!objResponse["Tooltip"]) 
	return null;
  
  if (objResponse["Tooltip"][0]["title"])
  	this.tooltip.title = objResponse["Tooltip"][0]["title"]; 
  this.setContent(objResponse["Tooltip"][0]["label"] || "");
};

/**
* @private Function to load tree content on tree load
* @param objResponse {Object} Server response
* TODO add format description
*/
Zapatec.Tooltip.prototype.loadDataXml = function(objSource){
  if(objSource == null || objSource.documentElement == null){
    return null;
  }
 
  var tooltip = objSource.documentElement; 
	
  for(var ii = 0; ii < tooltip.childNodes.length; ii++) {
	var el = tooltip.childNodes[ii];
	if (el.nodeName.toLowerCase() == "title")	
  		this.tooltip.title = el.childNodes[0].nodeValue;
	if (el.nodeName.toLowerCase() == "label")	 
  		this.setContent(el.childNodes[0].nodeValue);
 } 
};

/**
* \internal Function to load tree content on tree load from HTML element
* @param objResponse {Object} Server response
* Format description: Common HTML list - &lt;UL&gt;&lt;LI&gt;...&lt;/LI&gt;...&lt;/UL&gt;
*/
Zapatec.Tooltip.prototype.loadDataHtml = function(objSource) {
  if(objSource == null){
    return null;
  }

  if (objSource.title)	
  	this.tooltip.title = objSource.title; 	
  if (objSource.style)
  	for (var attr in objSource.style)	
  		this.tooltip.style.attr = objSource.style[objSource.style[attr]];
    
  this.setContent(objSource.innerHTML || '');
};
