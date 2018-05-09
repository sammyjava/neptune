// $Id: button.js 15736 2009-02-06 15:29:25Z nikolai $
/*
 * <pre>
 * Copyright (c) 2004-2009 by Zapatec, Inc.
 * http://www.zapatec.com
 * 1700 MLK Way, Berkeley, California,
 * 94709, U.S.A.
 * All rights reserved.
 * </pre>
 */

/**
* Zapatec.Button constructor. creates new object with given parameters.
*
* @param config [object] - button config.
*
* Constructor recognizes the following properties of the config object
* \code
*	property name			| description
*-------------------------------------------------------------------------------------------------
*	image			| [String] Default image for button. Also this image will
*					|	be putted on mouseout. Default value – null.
*	width			| [int] Button width. Default value - null.
*	height			| [int] Button height. Default value - null.
*	className		| [string] Default class to apply to newly created
*					|	button. Default value – null.
*	style			| [string] Default style to apply to newly created button.
*					|	Default value – null.
*	text			| [string] Text title to display on button. If
*					|	“image” option was given – this text will be used as
*					|	alternative title.
*	preloadImages	| [boolean] If true – preload all images (image, overImage,
*					|	outImage, downImage) for button. Default value – true.
*	overStyle		| [string] Style to apply to button during mouseover event.
*					|	Default value – null.
*	overClass		| [string] Class to add to button during mouseover event.
*					|	Default value – null.
*	overImage		| [string] Show this image during mouseover event. This
*					|	will be done only if “image” option was specified.
*					|	Default value – null.
*	overAction		| [function] Call this function during mouseover event.
*					|	Default value – null.
*	outAction		| [function] Call this function during mouseout event.
*					|	Default value – null.
*	downStyle		| [string] Style to apply to button during mousedown event.
*					|	Default value – null.
*	downClass		| [string] Class to add to button during mousedown event.
*					|	Default value – null.
*	downImage		| [string] Show this image during mousedown event. This
*					|	will be done only if “image” option was specified.
*					|	Default value – null.
*	downAction		| [function] Call this function during mousedown event.
*					|	Default value – null.
*   downActionDelay | [number] The delay before second and other downAction's will be called 
*                   | if the mouse stay pressed, default 500.
* repeatEnabled | [boolean] If down action should be repeated after a specified interval, default true
* repeatAcceleration| [number] The acceleration of raising downAction each next time, default 0.8.
* repeatStartSpeed  | [number] The starting speed of repeats of downAction, default 55.
* repeatMaxSpeed    | [number] The maximum speed of repeats of downAction, default 5.
*	clickAction		| [function] Call this function during onclick event.
*	theme			| [string] Theme name.
*	themePath		| [string] Path to directory where theme files are located.
*   idPrefix        | [string] Prefix for HTML ID's that will be assigned to controll elements.
* \endcode
*/
Zapatec.Button = function(objArgs){
	if(arguments.length == 0){
		objArgs = {};
	}

	// Call constructor of superclass
	Zapatec.Button.SUPERconstructor.call(this, objArgs);
};

/**
 * Unique static id of the widget class. Gives ability for Zapatec#inherit to
 * determine and store path to this file correctly when it is included using
 * Zapatec#include. When this file is included using Zapatec#include or path
 * to this file is gotten using Zapatec#getPath, this value must be specified
 * as script id.
 * @private
 */
Zapatec.Button.id = "Zapatec.Button";

// Inherit SuperClass
Zapatec.inherit(Zapatec.Button, Zapatec.Widget);

/**
* Init function. Actually this function does the creation of element
* itself, not the constructor.
*/
Zapatec.Button.prototype.init = function(objArgs){
	this.config.image = null;
	this.config.width = null;
	this.config.height = null;
	this.config.className = null;
	this.config.style = null;
	this.config.text = "";
	this.config.preloadImages = true;
	this.config.overStyle = null;
	this.config.overClass = null;
	this.config.overImage = null;
	this.config.overAction = null;
	this.config.outAction = null;
	this.config.downStyle = null;
	this.config.downClass = null;
	this.config.downImage = null;
	this.config.downAction = null;
	this.config.downActionDelay = 500;
	this.config.repeatEnabled = true;
	this.config.repeatAcceleration = 0.8;
	this.config.repeatStartSpeed = 55;
	this.config.repeatMaxSpeed = 5;
	this.config.clickAction = null;
	this.config.idPrefix = null;
	this.config.themePath = Zapatec.zapatecPath + "../zpextra/themes/button/";

	// processing Widget functionality
	Zapatec.Button.SUPERclass.init.call(this, objArgs);
	if (!this.config.idPrefix) {
		this.config.idPrefix = "zpButton" + this.id;
	}

	// store reference to root DOM object
	this.container = null;

	// using this container we could define current button state
	this.statusContainer = null;

	// where content actually located
	this.internalContainer = null;

	// reference to button's image
	this.img = null;

	// indicates current button state
	this.enabled = true;

	this.isPressed = false;

	this.createButton();
};

/**
* \internal creates button object
*/
Zapatec.Button.prototype.createButton = function(){
    this.container = Zapatec.Utils.createElement("span");
    this.addCircularRef(this, 'container');
	this.container.id = this.config.idPrefix + "Container";
    this.statusContainer = Zapatec.Utils.createElement("span");
    this.addCircularRef(this, 'statusContainer');
	this.statusContainer.className = "mouseOut";
	this.statusContainer.id = this.config.idPrefix + "Status";
	this.container.appendChild(this.statusContainer);
    this.internalContainer = Zapatec.Utils.createElement("span");
    this.addCircularRef(this, 'container');
	this.internalContainer.className = "internalContainer";
	this.internalContainer.id = this.config.idPrefix + "Internal";
	this.statusContainer.appendChild(this.internalContainer);

	Zapatec.Utils.addClass(this.container, this.getClassName({
		prefix: "zpButton" + (this.config.image != null ? "Image" : ""),
		suffix: "Container"
	}));

	// process config options

	if(this.config.width != null){
		this.internalContainer.style.width = this.config.width + "px";
	}

	if(this.config.height != null){
		this.internalContainer.style.width = this.config.height + "px";
	}

	if(this.config.className != null){
		Zapatec.Utils.addClass(this.internalContainer, this.config.className);
	}

	if(this.config.style != null){
		this.applyStyle(this.config.style);
	}

	var self = this;

	// attach handlers for mouse events
    this.container.onmouseover = function(ev){return self.onmouseover(ev, false);};
    this.addCircularRef(this.container, 'onmouseover');
    this.container.onmouseout = function(ev){return self.onmouseout(ev);};
    this.addCircularRef(this.container, 'onmouseout');
    this.container.onmousedown = function(ev){return self.onmousedown(ev);};
    this.addCircularRef(this.container, 'onmousedown');
    this.container.onmouseup = function(ev){return self.onmouseover(ev, true);};
    this.addCircularRef(this.container, 'onmouseup');

	this.setEventHandlers();
	var func = function(ev){self._mousedown = false;};
    Zapatec.Utils.addEvent(document, 'mouseup', func, null, false);
	this.eventHandlers.documentMouseup = {
		element: document,
		event: "mouseup",
		handler: func
	};
    
    this.container.onclick = function(ev){return self.onclick(ev);};
    this.addCircularRef(this.container, 'onclick');

	if(this.config.image != null){
		// create image if needed
        this.img = document.createElement("img");
        this.addCircularRef(this, 'img');
		this.img.src = this.config.image;
		this.img.alt = this.config.text;
		this.img.title = this.config.text;
		this.internalContainer.appendChild(this.img);
	} else {
		this.internalContainer.innerHTML = this.config.text;
		this.internalContainer.style.whiteSpace = "nowrap";
	}

	if(this.config.preloadImages == true){
		this.preloadImages();
	}
};

/**
* \internal Handler for mouseover event
*/
Zapatec.Button.prototype.onmouseover = function(ev, mouseup){
	if(!this.isEnabled()){
		return false;
	}

	if(typeof(ev) == 'undefined'){
		ev = window.event;
	}
	if (mouseup) {
		this._mousedown = false;
	}

	this.toggleClass("mouseOver");

	if(this.config.image != null && this.config.overImage != null){
		this.img.src = this.config.overImage;
	}

	if(this.config.overClass != null){
		Zapatec.Utils.addClass(this.internalContainer, this.config.overClass);
	}

	if(this.config.overStyle != null){
		this.applyStyle(this.config.overStyle);
	}
	
	if (this._timeoutId) {
		clearTimeout(this._timeoutId);
	}
	
	if (this._mousedown && this.config.repeatEnabled) {
		this._repeatDownAction();
	}

	if(this.config.overAction != null){
		return this.config.overAction(ev, this);
	}

	return true;
};

/**
* \internal Handler for mouseout event
*/
Zapatec.Button.prototype.onmouseout = function(ev){
	if(!this.isEnabled()){
		return false;
	}

	if(typeof(ev) == 'undefined'){
		ev = window.event;
	}

  if (!this.isPressed) {
    this.toggleClass("mouseOut");

    if(this.config.image != null){
      this.img.src = this.config.image;
    }

    if(this.config.outClass != null){
      Zapatec.Utils.addClass(this.internalContainer, this.config.outClass);
    }
  }
  else {
    this.toggleClass("mouseDown");

    if(this.config.image != null && this.config.downImage != null){
      this.img.src = this.config.downImage;
    }

    if(this.config.downClass != null){
      Zapatec.Utils.addClass(this.internalContainer, this.config.downClass);
    }
  }

  if(this.config.style != null){
		this.applyStyle(this.config.style);
	}

	if (this._mousedown) {
		this._pauseRepeat();
	}
	
	if(this.config.outAction != null){
		return this.config.outAction(ev, this);
	}

	return true;
};

/**
* \internal Handler for mousedown event
*/
Zapatec.Button.prototype.onmousedown = function(ev){
	if(!this.isEnabled()){
		return false;
	}

	var self = this;
	if(typeof(ev) == 'undefined'){
		ev = window.event;
	}
	this._mousedown = true;
	this.toggleClass("mouseDown");

	if(this.config.image != null && this.config.downImage != null){
		this.img.src = this.config.downImage;
	}

	if(this.config.downClass != null){
		Zapatec.Utils.addClass(this.internalContainer, this.config.downClass);
	}

	if(this.config.downStyle != null){
		this.applyStyle(this.config.downStyle);
	}

	if(this.config.downAction != null){
		this._timeoutId = setTimeout(function() {
			self._repeatSpeed = self.config.repeatStartSpeed;
			self._repeatDownAction(ev);
		}, this.config.downActionDelay);
		return this.config.downAction(ev, this);
	}

	return true;
};

/**
* \internal Handler for click event
*/
Zapatec.Button.prototype.onclick = function(ev){
	if(!this.isEnabled()){
		return false;
	}

	if(typeof(ev) == 'undefined'){
		ev = window.event;
	}
	
	if (this._timeoutId) {
		clearTimeout(this._timeoutId);
	}
	this._timeoutId = null;
	this._mousedown = false;

	if(this.config.clickAction != null){
		return this.config.clickAction(ev, this);
	}

	return true;
};

/**
 * Executes down action, and schedules another one.
 */
Zapatec.Button.prototype._repeatDownAction = function(ev) {
  if (this.config.downAction != null) {
    this.config.downAction(ev, this);
  }
	if (this.config.repeatEnabled) {
		if (this._repeatSpeed > this.config.repeatMaxSpeed) {
			this._repeatSpeed = Math.round(this.config.repeatAcceleration * this._repeatSpeed);
		}
		var self = this;
		this._timeoutId = setTimeout(function() {
			self._repeatDownAction();
		}, this._repeatSpeed);
	}
};

/**
 * Makes a pause in down action repeats.
 */
Zapatec.Button.prototype._pauseRepeat = function() {
	if (this._timeoutId) {
		clearTimeout(this._timeoutId);
		this._timeoutId = null;
	}
};

/**
* \internal Preload button images
*/
Zapatec.Button.prototype.preloadImages = function(){
	if(this.config.image != null){
		var images = [this.config.image];

		if(this.config.overImage != null){
			images.push(this.config.overImage);
		}

		if(this.config.downImage != null){
			images.push(this.config.downImage);
		}

		Zapatec.Transport.preloadImages({urls: images});
	}
};

/**
 * Sets the button in a pressed state
 *
 * @param isPressed [boolean] if button is to be pressed or not
 */
Zapatec.Button.prototype.setPressed = function(isPressed){
	this.isPressed = isPressed;

	if (isPressed) {
		this.toggleClass('mouseDown');
	} else {
		this.toggleClass('mouseOut');
	}
};

/**
* \internal Removes all classes from buttons and adds given class.
*/
Zapatec.Button.prototype.toggleClass = function(className){
	Zapatec.Utils.removeClass(this.statusContainer, "mouseOver");
	Zapatec.Utils.removeClass(this.statusContainer, "mouseOut");
	Zapatec.Utils.removeClass(this.statusContainer, "mouseDown");
	Zapatec.Utils.removeClass(this.statusContainer, "disabled");
	Zapatec.Utils.removeClass(this.internalContainer, this.config.overClass);
	Zapatec.Utils.removeClass(this.internalContainer, this.config.downClass);

	if(className != null){
		Zapatec.Utils.addClass(this.statusContainer, className);
	}
};

/**
* Get reference to button main DOM object
*/
Zapatec.Button.prototype.getContainer = function(){
	return this.container;
};

/**
* \internal apply given style to button
*	\param style - [string] string value
*/
Zapatec.Button.prototype.applyStyle = function(style){
	Zapatec.Utils.applyStyle(this.internalContainer, style);
};

/**
* Returns true if button is currently enabled
*/
Zapatec.Button.prototype.isEnabled = function(){
	return this.enabled;
};

/**
* Enable button
*/
Zapatec.Button.prototype.enable = function(){
	this.enabled = true;

	this.toggleClass("mouseOut");
};

/**
* Disable button
*/
Zapatec.Button.prototype.disable = function(){
	this.enabled = false;

	this.toggleClass("disabled");
};

/**
 * Sets the button text.
 * @param text {string} text to be set.
 */
Zapatec.Button.prototype.setText = function(text) {
	this.internalContainer.innerHTML = text;
};

/**
 * Gets the button text.
 * @return {string} button text.
 */
Zapatec.Button.prototype.getText = function() {
	return this.internalContainer.innerHTML;
};

/**
* Takes given element (input type=”image|button|submit|reset”, button, image,
* div or span) and replaces it with Zapatec.Button with given config. Original
* element will be hided.
*/
Zapatec.Button.setup = function(elRef, config){
	elRef = Zapatec.Widget.getElementById(elRef);

	if(elRef == null){
		return null;
	}

	elRef.zpHasButton = true;

	if(config == null){
		config = {};
	}

	var nodeName = elRef.nodeName.toLowerCase();

	var oldOverAction = config.overAction != null ? config.overAction : function(){return true;};
	config.overAction = function(ev){return (
		(elRef.onmouseover != null ? elRef.onmouseover.call(ev) : true) &&
		oldOverAction(ev)
	);};

	var oldOutAction = config.outAction != null ? config.outAction : function(){return true;};
	config.outAction = function(ev){return (
		(elRef.onmouseout != null ? elRef.onmouseout.call(ev) : true) &&
		oldOutAction(ev)
	);};

	var oldDownAction = config.downAction != null ? config.downAction : function(){return true;};
	config.downAction = function(ev){return (
		(elRef.onmousedown != null ? elRef.onmousedown.call(ev) : true) &&
		oldDownAction(ev)
	);};

	var oldClickAction = config.clickAction != null ?
		config.clickAction : function(){return true;};

	config.clickAction = function(ev){return (
		(elRef.onclick != null ? elRef.onclick.call(ev) : true) &&
		oldClickAction(ev)
	);};

	var submitAction = function(ev){
		if(elRef.form != null && elRef.zpHidden == null){
			var hidden = document.createElement("input");
			hidden.type = 'hidden';
			hidden.name = elRef.name;
			hidden.value = elRef.value;
			hidden.style.display = 'none';
			Zapatec.Utils.insertAfter(elRef, hidden);
			elRef.zpHidden = hidden;
		}

		if(elRef.form && elRef.form.onSubmit != null){
			elRef.form.onSubmit();
		}

		return (
			(elRef.onclick != null ? elRef.onclick.call(ev) : true) &&
			oldClickAction(ev) &&
			(elRef.form != null ? elRef.form.submit() : true)
		);
	};

	if(nodeName == 'button'){
		config.text = elRef.value;
	} else if(nodeName == 'img'){
		config.image = elRef.src;
		config.text = elRef.title || elRef.title;
	} else if(
		nodeName == 'div' ||
		nodeName == 'span'
	){
		config.text = elRef.innerHTML;
	} else if(nodeName == 'input'){
		config.text = elRef.value;
		if(elRef.type.toLowerCase() == 'image'){
			config.image = elRef.src;
			config.clickAction = submitAction;
		} else if(elRef.type.toLowerCase() == 'button'){
		} else if(elRef.type.toLowerCase() == 'submit'){
			config.clickAction = submitAction;
		} else if(elRef.type.toLowerCase() == 'reset'){
			config.clickAction = function(ev){
				(elRef.onclick != null ? elRef.onclick.call(ev) : true) &&
				oldClickAction(ev) &&
				(elRef.form != null ? elRef.form.reset() : true)
			};
		} else {
			return null;
		}
	} else {
		return null;
	}

	var button = new Zapatec.Button(config);
	Zapatec.Utils.insertAfter(elRef, button.getContainer());
	elRef.disabled = true;
	elRef.style.display = 'none';

	return button;
};

/**
* Takes all suitable elements (input type=”image|button|submit|reset” or
* button) from elRef childs and makes Zapatec.Button.setup() for each of them.
*/
Zapatec.Button.setupAll = function(elRef, config){
	if(typeof(elRef) == 'string'){
		elRef = document.getElementById(elRef);
	}

	if(elRef == null){
		return null;
	}

	var childs = elRef.all ? elRef.all : elRef.getElementsByTagName("*");

	function cloneConfig(){
		var cfg = {};

		for(var option in config){
			cfg[option] = config[option];
		}

		return cfg;
	}

	for(var ii = 0; ii < childs.length; ii++){
		var child = childs[ii];
		if(
			child.nodeType == 1 &&
			(
				child.nodeName.toLowerCase() == 'button' ||
				child.nodeName.toLowerCase() == 'input' &&
				(
					child.type.toLowerCase() == 'image' ||
					child.type.toLowerCase() == 'button' ||
					child.type.toLowerCase() == 'submit' ||
					child.type.toLowerCase() == 'reset'
				)
			) &&
			!child.zpHasButton
		){
			Zapatec.Button.setup(child, cloneConfig());
		}
	}
};

Zapatec.Button.prototype.destroy = function(){
    if(!this.container){
    	// already destroyed
    	return;
    }

    this.container.onmouseover = null;
    this.container.onmouseout = null;
    this.container.onmousedown = null;
    this.container.onmouseup = null;
    this.container.onclick = null;

        
        //Zapatec.Utils.destroy(this.internalContainer)
        //Zapatec.Utils.destroy(this.statusContainer)
        //Zapatec.Utils.destroy(this.container)
	this.internalContainer = null;
	this.statusContainer = null;
	this.container = null;

	return null;
};
