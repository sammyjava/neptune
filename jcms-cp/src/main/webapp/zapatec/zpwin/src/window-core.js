// $Id: window-core.js 15736 2009-02-06 15:29:25Z nikolai $
/**
 *
 * Copyright (c) 2004-2009 by Zapatec, Inc.
 * http://www.zapatec.com
 * 1700 MLK Way, Berkeley, California,
 * 94709, U.S.A.
 * All rights reserved.
 */

/**
 * The Window object constructor.  Call it, for example, like this:
 *
 * \code
 *   var win = new Zapatec.Window({
 *    showResize : false
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
 *   showMinButton   | whether to show minimize button (default true).
 *   showMaxButton   | whether to show maximize button (default true).
 *   showCloseButton | whether to show close button (default true).
 *   showStatus      | whether to show status bar text (default true).
 *   showTitle      | whether to show the title bar text (default true)
 *   canResize       | whether to show resize icon (default true).
 *   raiseOnlyOnTitle| whether to raize when clicking on title or on the whole body of the created window (default false).
 *   canDrag         | whether you can drag the window (default true).
 *   modal           | if true modal window will be created (default false).
 *   onClose         | custom handler, will be called when window is closed. Depricated use eventListeners
 *                   | option instead. See Zapatec.Widget documentation.
 *   onRestore       | custom handler, will be called when restore button is clicked. Depricated use eventListeners
 *                   | option instead. See Zapatec.Widget documentation.
 *   onMinimize      | custom handler, will be called when min button is clicked. Depricated use eventListeners
 *                   | option instead. See Zapatec.Widget documentation.
 *   onMaximize      | custom handler, will be called when max button is clicked. Depricated use eventListeners
 *                   | option instead. See Zapatec.Widget documentation.
 *   onShow          | custom handler, will be called when show method is called. Depricated use eventListeners
 *                   | option instead. See Zapatec.Widget documentation.
 *   onHide          | custom handler, will be called when hide method is called. Depricated use eventListeners
 *                   | option instead. See Zapatec.Widget documentation.
 *   onResize        | custom handler, will be called when window is resized. Depricated use eventListeners
 *                   | option instead. See Zapatec.Widget documentation.
 *   onRaise         | custom handler, will be called when window is raized. Depricated use eventListeners
 *                   | option instead. See Zapatec.Widget documentation.
 *   onContentLoad   | custom handler, will be called when content is loaded. Depricated use eventListeners
 *                   | option instead. See Zapatec.Widget documentation.
 *   minWidth        | minimal width of the window. Depricated use "limit" option instead.
 *   minHeight       | minimal height of the window. Depricated use "limit" option instead.
 *   iframeContent   | type of the content element.
 *   hideOnClose     | whether we destroy the window or just close
 *   dragMin         | is minimized draggable or not (default false)
 *   bottomMinimize  | is the window minimized to the bottom or just stay at its position
 *   lang     | set the localization for all the messages
 *
 * \endcode
 */
Zapatec.Window = function (config) {
  //the reference to the root HTML element of the window
  this.container = null;
  //reference to the element which holds the title bar
  this.titleArea = null;
  //reference to the element which holds the title text
  this.titleText = null;
  //reference to the Zapatec.Button object representing minimize button
  this.minButton = null;
  //reference to the Zapatec.Button object representing maximize button
  this.maxButton = null;
  //reference to the Zapatec.Button object representing close button
  this.closeButton = null;
  //reference to the Zapatec.Pane object representing content of the window
  this.content = null;
  //reference to the element holding status area element
  this.statusText = null;
  //reference to the Modal object of this window
  this.modal = null;
  //flag which determines if the window is resizing
  this.resizing = false;
  //type of the widget - window in our case :)
  this.widgetType = "window";
  //widget privillage modes
  this.widgetModes = {};
  //high priority events
  this.highPriorityEvents = [];
  //delayed events
  this.delayedEvents = [];
  //this variable points the state of the widget in general.
  //The widget has a set of states 4 of them should go one after another ('created' -> 'inited' -> 'loaded' -> 'ready')
  //and point to the stage of creation of widget. Last one should be 'ready',
  //which means a fully ready for work widget. Each of the methods can require
  //the state to be not lower than it needs. So we will also define a method
  //to work with this variable - stateReached(state) - to get true if state reached or passed.
  this.widgetState = "created";
  //array of priorities for states, in other words its the number which points the order
  // of states to be passed.
  this.priorities = {
    //the number of states supported
    count : 7,
    //states priorities
    destroyed : 0,
    created : 1,
    inited : 2,
    loaded : 3,
    ready : 4,
    hidden : 5,
    shown : 6
  };
  this.setDefaultState();
  //for backward compability
  if (!config.eventListeners) {
    config.eventListeners = {};
  }
  if (config.onClose) {config.eventListeners.onClose = config.onClose;}
  if (config.onRestore) {config.eventListeners.onRestore = config.onRestore;}
  if (config.onMaximize) {config.eventListeners.onMaximize = config.onMaximize;}
  if (config.onMinimize) {config.eventListeners.onMinimize = config.onMinimize;}
  if (config.onShow) {config.eventListeners.onShow = config.onShow;}
  if (config.onHide) {config.eventListeners.onHide = config.onHide;}
  if (config.onResize) {config.eventListeners.onResize = config.onResize;}
  if (config.onRaise) {config.eventListeners.onRaise = config.onRaise;}
  if (config.onContentLoad) {config.eventListeners.onContentLoad = config.onContentLoad;}
  config = Zapatec.Hash.remove(config,
    "onClose", "onRestore", "onMaximize", "onMinimize",
    "onShow", "onHide", "onResize", "onRaise", "onContentLoad"
  );
  //calling super constructor
  Zapatec.Window.SUPERconstructor.call(this, config);
  //creating SRProp object for manipulating with our object
  this.restorer = new Zapatec.SRProp(this);
};

Zapatec.Window.id = "Zapatec.Window";
//Inheriting Zapatec.Widget class
Zapatec.inherit(Zapatec.Window, Zapatec.Widget);
//Implementing Zapatec.CommandEvent interface
Zapatec.implement(Zapatec.Window, "Zapatec.CommandEvent");
//Implementing Zapatec.Movable interface
Zapatec.implement(Zapatec.Window, "Zapatec.Movable");
//Implementing Zapatec.Draggable interface
Zapatec.implement(Zapatec.Window, "Zapatec.Draggable");
//Implementing Zapatec.Sizable interface
Zapatec.implement(Zapatec.Window, "Zapatec.Sizable");
//Implementing Zapatec.Resizable interface
Zapatec.implement(Zapatec.Window, "Zapatec.Resizable");

/**
 * This function inits the config object and loads HTML structure
 * of the window, not to waste time :)
 * @param config [object] - object which holds the configuration, same as for constructor
 */
Zapatec.Window.prototype.init = function(config) {
  // processing Widget functionality
  Zapatec.Window.SUPERclass.init.call(this, config);
  //action to be fired when privileged execution is on
  this.addEventListener("privileged_execution_on", function() {
    //array of high priority events
    this.highPriorityEvents = [];
  });
  //action to be fired when privileged execution is off
  this.addEventListener("privileged_execution_off", function() {
    //putting high priority events into the begining of array
    for (var ii = this.highPriorityEvents.length - 1; ii >= 0; --ii) {
      //if there is listener and it was not executed moving it to events array
      if (this.highPriorityEvents[ii] && !this.highPriorityEvents[ii].executed) {
        this.addEventListener(this.highPriorityEvents[ii].state, this.highPriorityEvents[ii].listener, true);
      }
    }
    //clearing array
    this.highPriorityEvents = [];
  });
  //action to be fired when delayed execution is on
  this.addEventListener("delayed_execution_on", function() {
    //array of delayed events
    this.delayedEvents = [];
  });
  //action to be fired when delayed execution is off
  this.addEventListener("delayed_execution_off", function() {
    //trying to execute or schedule delayed events
    for (var ii = this.delayedEvents.length - 1; ii >= 0; --ii) {
      //trying to schedule delayed event
      if (!this.fireOnState(this.delayedEvents[ii].state, this.delayedEvents[ii].listener)) {
        continue;
      }
      //otherwise executing it
      this.delayedEvents[ii].listener();
    }
  });
  //listener to activate Window on drag start
  //also sets the status message for dragging
  this.addEventListener("beforeDragInit", function() {
    this.activate();
    if (this.getConfiguration().method == "cut") {
      this.setStatus(this.getMessage('windowOnBeforeDragStatusMessage'), 'temp');
    }
  });
  //tries to remember dummy position
  var pos = null;
  this.addEventListener("beforeDragEnd", function() {
    if (this.getConfiguration().method != "cut") {
      pos = this.getPosition();
    }
  });
  //resets status on drag end
  this.addEventListener("onDragEnd", function() {
    if (this.getConfiguration().method == "cut") {
      this.setStatus('', 'restore');
    } else {
      this.setPosition(pos.x, pos.y);
    }
  });
  //listener to activate Window on resize start
  //also sets the status message for resizing
  this.addEventListener("onResizeInit", function() {
    this.activate();
    this.setStatus(this.getMessage('windowOnResizeStatusMessage'), 'temp');
  });
  //resets status on resize end
  this.addEventListener("onResizeEnd", function() {
    this.setStatus('', 'restore');
  });
  //changing state to "inited"
  this.changeState("inited");
  //loading template for Window
  this.loadData({object : this, action : "loadTemplate"});
};

/**
 * Sets the default configuration of the object and
 * inits it with user defined values.
 * @param config {object} configuration parameters.
 */
Zapatec.Window.prototype.configure = function(config) {
  //wether title is visible
  this.defineConfigOption("showTitle", true);
  //wethter min button is visible
  this.defineConfigOption("showMinButton", true);
  //wethter max button is visible
  this.defineConfigOption("showMaxButton", true);
  //wethter close button is visible
  this.defineConfigOption("showCloseButton", true);
  //wethter status bar is visible
  this.defineConfigOption("showStatus", true);
  //wethter window is resizable
  this.defineConfigOption("canResize", true);
  //resizing directions
  this.defineConfigOption("resizeDirection", "all");
  //wether to raise only on clicking the title
  this.defineConfigOption("raiseOnlyOnTitle", false);
  //wether window is draggable
  this.defineConfigOption("canDrag", true);
  //dragging method
  this.defineConfigOption("dragMethod", "cut");
  //dragging class name (applied only when dragging)
  this.defineConfigOption("addDragCSS", null);
  //dragging class name (applied only when dragging, overwrites all others)
  this.defineConfigOption("newDragCSS", null);
  //wether window is modal
  this.defineConfigOption("modal", false);
  //limitations on the window
  this.defineConfigOption("limit", {
    minWidth : 120,
    maxWidth : null,
    minHeight : 120,
    maxHeight : null,
    minX : null,
    maxX : null,
    minY : null,
    maxY : null
  });
  //should we show content in IFRAME Pane or just simple div Pane
  this.defineConfigOption("iframeContent", false);
  //do we hide on close or destroy
  this.defineConfigOption("hideOnClose", false);
  //is minimized window draggable
  this.defineConfigOption("dragMin", false);
  //do we minimize to the bottom
  this.defineConfigOption("bottomMinimize", true);
  //is Window position fixed on the page
  this.defineConfigOption("fixed", false);
  //default theme winxp
  this.defineConfigOption("theme", "winxp");
  // we do not need load structure from js file, when use 'template' config paramiter
  var template = "";
  if (config.template) {
     template = true;
  }
  //we need the HTML part of our window to be loaded, so defining the source and sourceType
  this.defineConfigOption("template", Zapatec.Window.path + "struc.html");
  //callback source function
  this.defineConfigOption("callbackSource", function(args) {
    //getting window object that requested the load
    var win = args.object;
    //not a Zapatec.Window - no load
    if (!win || win.widgetType != "window") {
      return null;
    }
    switch (args.action) {
      //action is loading template
      case "loadTemplate" : {
        if (Zapatec.Window.DEFAULT_STRUCT && !template) {
          return  { source : Zapatec.Window.DEFAULT_STRUCT, sourceType : "html/text" };
        } else {
          return { source : win.getConfiguration().template, sourceType : "html/url" };
        }
      }
    }
    return null;
  });
  this.defineConfigOption('langId', Zapatec.Window.id);
  this.defineConfigOption('lang', "eng");
  // processing Widget functionality
  Zapatec.Window.SUPERclass.configure.call(this, config);
  config = this.getConfiguration();
  if (config.dragMethod == "copy" || config.dragMethod == "dummy") {
    config.dragMethod = "dummy";
    config.newDragCSS = "zpWinDummy";
  }
};

/**
 * Reconfigures the object with new parameters.
 * @param config {object} new configuration parameters.
 */
Zapatec.Window.prototype.reconfigure = function(config) {
  // Call parent method
  Zapatec.Window.SUPERclass.reconfigure.call(this, config);
};

/**
 * We overwrite the zpwidgets loadDataHtml method to parse
 * needed values from given HTML source.
 * @param el [HTML element] - DOM representation of or HTML part.
 */
Zapatec.Window.prototype.loadDataHtml = function(el) {
  //el is an DOM element created from the struct.html file, which contains HTML part of this widget.
  if (this.parseDom(el)) {
    this.changeState("loaded");
  }
};

/**
 * This function appends the loaded structure to the documents BODY,
 * makes Window draggable, sets all the parameters of the visual elements.
 * All its actions are closely connected with config options.
 * @param x [integer] x coordinate.
 * @param y [integer] y coordinate.
 * @param width [integer] width of the window.
 * @param height [integer] height of the window.
 */
Zapatec.Window.prototype.create = function (x, y, width, height)  {
  //parsing numbers for coordinates and sizes
  if (x != "center") {
    x = parseInt(x, 10) || 0;
  }
  if (y != "center") {
    y = parseInt(y, 10) || 0;
  }
  if (width != "auto") {
    width = parseInt(width, 10) || 0;
  }
  if (height != "auto") {
    height = parseInt(height, 10) || 0;
  }
  //If not everything is ready for creating the widget we should wait a little and try again.
  //some kind of imitation of "threaded widget", if you know what I mean :)
  if (!this.fireOnState("body_loaded", function() {this.create(x, y, width, height);}) || !this.fireOnState("loaded", function() {this.create(x, y, width, height);})) {
    return;
  }
  //appending the loaded element
  document.body.appendChild(this.getContainer());
  //adding a class name for using specified theme
  Zapatec.Utils.addClass(this.getContainer(), this.getClassName({prefix : "zpWin", suffix : "Container"}));
  //adding buttons
  function replaceButton(but, idPrefix, func) {
    //creating Zapatec.Button
    var button = new Zapatec.Button({
      className : but.className,
      style : but.style.cssText,
      theme : null,
      idPrefix : idPrefix,
      clickAction : func
    });
    //replaceing old one
    var nxtSbl = but.nextSibling;
    var par = but.parentNode;
    if (but.outerHTML) {
      //but.outerHTML = "";
      but.style.display = "none";
    } else {
      par.removeChild(but);
    }
    //putting new button
    par.insertBefore(button.getContainer(), nxtSbl);
    //returning new object
    return button;
  }
  var self = this;
  //min button
  this.minButton = replaceButton(this.minButton, "zpWin" + self.id + "MinButton", function() {self.minimize();});
  //max button
  this.maxButton = replaceButton(this.maxButton, "zpWin" + self.id + "MaxButton", function() {self.maximize();});
  //close button
  this.closeButton = replaceButton(this.closeButton, "zpWin" + self.id + "CloseButton", function() {self.close();});
  //restore button
  this.restoreButton = replaceButton(this.restoreButton, "zpWin" + self.id + "RestoreButton", function() {self.restore();});
  //customizing the structure to the options of config
  this.setModeOn("immediate_execution");
  this.reconfig();
  this.setModeOff("immediate_execution");
  //saving width of the old content
  var contentWidth = Zapatec.Utils.getWidth(this.content);
  //Creating a Pane object
  var pane = new Zapatec.Pane({
    containerType : (this.config.iframeContent ? "iframe" : "div")
  });
  this.content.getContainer = function() {return this;};
  //Currently we will not set width auto, we'll do it
  //on content load
  if (width == "auto") {
    width = 0;
    this.addEventListener("onContentLoad", function() {
      this.setWidth("auto");
      this.removeEventListener("onContentLoad", arguments.callee);
    });
  }
  if (height == "auto") {
    height = 0;
    this.addEventListener("onContentLoad", function() {
      this.setHeight("auto");
      this.removeEventListener("onContentLoad", arguments.callee);
    });
  }
  //copying class name
  pane.getContainer().className = this.content.className;
  //FIXME : these are also some tricks
  pane.fireWhenReady(function() {
    //removing margin and padding
    if (this.getContentElement()) {
      if (this.config.containerType.toLowerCase() == "iframe") {
        this.getContentElement().style.padding = "0px";
      }
      this.getContentElement().style.margin = "0px";
    }
    //removing border
    var width = Zapatec.Utils.getWidth(this.getContainer());
    this.removeBorder();
    Zapatec.Utils.setWidth(this.getContainer(), width);
  });
  //Creating WCH
  this.createProperty(this, "WCH", Zapatec.Utils.createWCH());
  if (this.WCH) {
    //puting WCH to right place
    this.WCH.style.zIndex = Zapatec.Window.maxNumber++;
    Zapatec.Utils.setWidth(this.WCH, Zapatec.Utils.getWidth(this.getContainer()));
    Zapatec.Utils.setHeight(this.WCH, Zapatec.Utils.getHeight(this.getContainer()));
    var pos = Zapatec.Utils.getElementOffset(this.getContainer());
    Zapatec.Utils.moveTo(this.WCH, pos.x, pos.y);
  }
  //manipulating with container
  this.container.style.zIndex = Zapatec.Window.maxNumber++;
  //making Window movable
  this.makeMovable();
  //making Window sizable
  this.makeSizable();
  //making Window draggable
  this.makeDraggable();
  //making Window resizable
  this.makeResizable();
  //replacing content with pane
  var content = this.content;
  this.content = pane;
  this.replaceWithSizable(content, this.content.getContainer());
  //adding "onContentLoad" event listener launch
  this.content.addEventListener("contentLoaded", function() {
    self.fireEvent('onContentLoad');
  });
  //adding a button type for titleArea to react on dbl click
  this.titleArea.buttonType = "title";
  //adding a button type for content not to cancel selection
  this.content.getContainer().buttonType = "content";
  //adding a button type for container to limit seeking of target element
  this.getContainer().buttonType = "container";
  //adding event listeners
  this.addEvents();
  //turning on immediate execution
  this.setModeOn("immediate_execution");
  //trying to set sizes and pos by our methods
  this.setSize(
    width > this.getConfiguration().limit.minWidth ? width : this.getConfiguration().limit.minWidth,
    height > this.getConfiguration().limit.minHeight ? height : this.getConfiguration().limit.minHeight
  );
  if (this.getConfiguration().fixed) {
    Zapatec.FixateOnScreen.register(this.getContainer());
    Zapatec.FixateOnScreen.register(this.WCH);
  }
  this.setScreenPosition(x, y);
  //hiding new window
  this.hide();
  //turning off immediate execution
  this.setModeOff("immediate_execution");
  //setting the state to ready
  this.changeState("ready");
};

// Handle all the onScroll events, if theres a modal layer present, it will be updated
Zapatec.Utils.addEvent(window,'scroll',function(){
	if(Zapatec.Window && Zapatec.Window.currentWindow && Zapatec.Window.currentWindow.modal){
		var scroll = {'x':Zapatec.Utils.getPageScrollX(),'y':Zapatec.Utils.getPageScrollY()};
		Zapatec.Window.currentWindow.modal.container.style.left = scroll.x+'px';
		Zapatec.Window.currentWindow.modal.container.style.top = scroll.y+'px';
	}
},false,true);

// Handle all the onResize events, if theres a modal layer present, it will be updated
Zapatec.Utils.addEvent(window,'resize',function(){
	if(Zapatec.Window && Zapatec.Window.currentWindow && Zapatec.Window.currentWindow.modal){
		var scroll = {'x':Zapatec.Utils.getPageScrollX(),'y':Zapatec.Utils.getPageScrollY()};
		var offset = Zapatec.Utils.getElementOffsetScrollable(Zapatec.Window.currentWindow.modal.container);
		var size = Zapatec.Utils.getWindowSize();
		Zapatec.Window.currentWindow.modal.container.style.width = size.width + 'px';
		Zapatec.Window.currentWindow.modal.container.style.height = size.height + 'px';
	}
},false,true);
