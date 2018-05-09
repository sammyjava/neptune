// $Id: generic-dialog.js 6650 2007-03-19 10:14:14Z slip $
/**
 * Dialog window constructor. Creates and shows the DHTML "dialog".
 *
 * @param message [string] - message to be shown.
 * @param config [object] - config options for Window.
 */ 
Zapatec.DialogWindow = function(message, config) {
	//for backward compability we create this refference
	//to this window object
	this.win = this;
	//confirm action
	this.onChoose = function() {};
	//simple close action
	this.onCloseAction = function() {};
	//saving message
	this.message = message;
	var self = this;
	//calling super constructor
	Zapatec.DialogWindow.SUPERconstructor.call(this, config);
	//adding close event listener
	this.addEventListener("onClose", function() {
		if (self.result === null) {
			self.onCloseAction();
		} else {
			self.onChoose(self.result);
		}
	});
};

Zapatec.DialogWindow.id = "Zapatec.DialogWindow";

//Inheriting Zapatec.Window class
Zapatec.inherit(Zapatec.DialogWindow, Zapatec.Window);

/**
 * Inits the object with config.
 */
Zapatec.DialogWindow.prototype.init = function(config) {
	//width of the Window
	this.defineConfigOption("width", "auto");
	//height of the Window
	this.defineConfigOption("height", "auto");
	//left coordinate
	this.defineConfigOption("left", "center");
	//top coordinate
	this.defineConfigOption("top", "center");
	//title of the Window
	this.defineConfigOption("title", "");
	//array of buttons
	this.defineConfigOption("buttons", []);
	//disabling needed buttons
	config.showMaxButton = false;
	config.showMinButton = false;
	config.canResize = false;
	config.showStatus = false;
	//setting hideOnClose true as default
	config.hideOnClose = (config.hideOnClose === false) ? config.hideOnClose : true;
	// processing Widget functionality
	Zapatec.DialogWindow.SUPERclass.init.call(this, config);
};

/**
 * Creates the content of dialog window.
 * @return [HTML element] - content element.
 */
Zapatec.DialogWindow.prototype.createContent = function() {
	var self = this, button = null;
	var content = document.createElement("div");
	Zapatec.Utils.addClass(content, "zpWinDialogInnerContent");
	if (this.content && this.content.getContentElement) {
		Zapatec.Utils.addClass(this.content.getContentElement(), 'zpWinDialogContent');
	} else if (this.content) {
		Zapatec.Utils.addClass(this.content, 'zpWinDialogContent');
	} else {
		this.fireOnState("ready", function() {
			Zapatec.Utils.addClass(self.content.getContentElement(), 'zpWinDialogContent');
		});
	}
	this.messageArea = document.createElement("div");
	this.messageArea.className = "zpWinDialogMessage";
	content.appendChild(this.messageArea);
	for(var i in this.config.buttons) {
		if (typeof this.config.buttons[i] == "string") {
			button = new Zapatec.Button({
				theme : "default",
				clickAction : function (ev, button) {
					self.result = button.config.text;
					self.close();
				},
				text : this.config.buttons[i]
			});
			content.appendChild(button.getContainer());
			content.appendChild(document.createTextNode(" "));
		}
	}
	return content;
};

/**
 * This methods actually gets the response,
 * which means show window and add onChoose and closeAction action.
 * onChoose action is called onClose.
 * @param action [function] - custom choose action.
 * @param closeAction [function] - custom close action, optional.
 * @param message [string] - message for confirm, optional.
 */
Zapatec.DialogWindow.prototype.getResponse = function(action, closeAction, message) {
	this.result = null;
	if (!this.getContainer() || !this.getContainer().parentNode != document.body) {
		this.create(null, null, this.config.width, this.config.height);
	}
	this.setScreenPosition(this.config.left, this.config.top);
	this.setTitle(this.config.title);
	if (typeof action == "function") {
		this.onChoose = action;
	}
	if (typeof closeAction == "function") {
		this.onCloseAction = closeAction;
	}
	this.show();
	if (!this.messageArea) {
		this.setDivContent(this.createContent());
	}
	this.messageArea.innerHTML = message || this.message;
};
