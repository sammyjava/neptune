// $Id: confirm.js 11535 2008-05-15 15:45:38Z andrew $
/**
 * Confirm window constructor. Creates and shows the DHTML "confirm".
 *
 * @param config [object] - config options for Window.
 */ 
Zapatec.ConfirmWindow = function(config) {
	//for backward compatibility we create this reference
	//to this window object
	this.win = this;
	//calling super constructor
	Zapatec.ConfirmWindow.SUPERconstructor.call(this, config);
	//adding close event listener
	var self = this;
	this.addEventListener("onClose", function() {
		self.config.onConfirm(self.result);
	});
};

Zapatec.ConfirmWindow.id = "Zapatec.ConfirmWindow";

//Inheriting Zapatec.Window class
Zapatec.inherit(Zapatec.ConfirmWindow, Zapatec.Window);

/**
 * Inits the object with config.
 */
Zapatec.ConfirmWindow.prototype.init = function(config) {
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
	//content of the Window
	this.defineConfigOption("message", "");
	//function that will be called on confirm
	this.defineConfigOption("onConfirm", function() {});
	this.defineConfigOption("lang", "eng");
	//theme for "OK" and "Cancel" buttons
	this.defineConfigOption("buttonTheme", "default");
	//disabling needed buttons
	config.showMaxButton = false;
	config.showMinButton = false;
	config.canResize = false;
	config.showStatus = false;
	//setting hideOnClose true as default
	config.hideOnClose = (config.hideOnClose === false) ? config.hideOnClose : true;
	// processing Widget functionality
	Zapatec.ConfirmWindow.SUPERclass.init.call(this, config);
};

/**
 * Creates the content of confirm window.
 * @return [HTML element] - content element.
 */
Zapatec.ConfirmWindow.prototype.createContent = function() {
	var self = this;
	var content = document.createElement("div");
	Zapatec.Utils.addClass(content, "zpWinConfirmInnerContent");
	if (this.content && this.content.getContentElement) {
		Zapatec.Utils.addClass(this.content.getContentElement(), 'zpWinConfirmContent');
	} else if (this.content) {
		Zapatec.Utils.addClass(this.content, 'zpWinConfirmContent');
	} else {
		this.fireOnState("ready", function() {
			Zapatec.Utils.addClass(self.content.getContentElement(), 'zpWinConfirmContent');
		});
	}
	this.messageArea = document.createElement("div");
	this.messageArea.className = "zpWinConfirmMessage";
	content.appendChild(this.messageArea);
	this.okButton = new Zapatec.Button({
		theme : this.config.buttonTheme,
		clickAction : function () {
			self.result = true;
			self.close();
		},
		text : this.getMessage("confirmOkButtonLabel")
	});
	content.appendChild(this.okButton.getContainer());
	content.appendChild(document.createTextNode(" "));
	this.cancelButton = new Zapatec.Button({
		theme : this.config.buttonTheme,
		clickAction : function () {
			self.result = false;
			self.close();
		},
		text : this.getMessage("confirmCancelButtonLabel")
	});
	content.appendChild(this.cancelButton.getContainer());
	return content;
};

/**
 * This method actually gets the response,
 * which means show window and add onConfirm action.
 * onConfirm action is called onClose.
 * @param action [function] - custom confirm action.
 * @param message [string] - message for confirm, optional.
 */
Zapatec.ConfirmWindow.prototype.getResponse = function(action, message) {
	this.result = false;
	if (!this.getContainer() || this.getContainer().parentNode != document.body) {
		this.create(null, null, this.config.width, this.config.height);
	}
	this.setScreenPosition(this.config.left, this.config.top);
	this.setTitle(this.config.title);
	if (typeof action == "function") {
		this.config.onConfirm = action;
	}
	this.show();
	if (!this.messageArea) {
		this.setDivContent(this.createContent());
	}
	this.messageArea.innerHTML = message || this.config.message;
};
