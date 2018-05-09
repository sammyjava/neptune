// $Id: alert.js 11535 2008-05-15 15:45:38Z andrew $
/**
 * Alert window constructor. Creates and shows the DHTML "alert".
 *
 * @param config [object] - config options for Window.
 */ 
Zapatec.AlertWindow = function(config) {
	//for backward compatibility we create this reference
	//to this window object
	this.win = this;
	//calling super constructor
	Zapatec.AlertWindow.SUPERconstructor.call(this, config);
	this.alert();
};

Zapatec.AlertWindow.id = "Zapatec.AlertWindow";

//Inheriting Zapatec.Window class
Zapatec.inherit(Zapatec.AlertWindow, Zapatec.Window);

/**
 * Inits the object with config.
 */
Zapatec.AlertWindow.prototype.init = function(config) {
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
	this.defineConfigOption("lang", "eng");
	//theme for the "OK" and "Cancel" buttons
	this.defineConfigOption("buttonTheme", "default");
	//disabling needed buttons
	config.showMaxButton = false;
	config.showMinButton = false;
	config.canResize = false;
	config.showStatus = false;
	// processing Widget functionality
	Zapatec.AlertWindow.SUPERclass.init.call(this, config);
};

/**
 * Creates the content of alert window.
 * @return [HTML element] - content element.
 */
Zapatec.AlertWindow.prototype.createContent = function() {
	var self = this;
	var content = document.createElement("div");
	Zapatec.Utils.addClass(content, "zpWinAlertInnerContent");
	if (this.content && this.content.getContentElement) {
		Zapatec.Utils.addClass(this.content.getContentElement(), 'zpWinAlertContent');
	} else if (this.content) {
		Zapatec.Utils.addClass(this.content, 'zpWinAlertContent');
	} else {
		this.fireOnState("ready", function() {
			Zapatec.Utils.addClass(self.content.getContentElement(), 'zpWinAlertContent');
		});
	}
	this.messageArea = document.createElement("div");
	this.messageArea.className = "zpWinAlertMessage";
	content.appendChild(this.messageArea);
	this.okButton = new Zapatec.Button({
		theme : this.config.buttonTheme,
		clickAction : function () {
			self.close();
		},
		text : this.getMessage('alertOkButtonLabel')
	});
	content.appendChild(this.okButton.getContainer());
	return content;
};

/**
 * This methods actually shows the alert.
 * It is called from constructor.
 * @param message [string] - message for alert.
 */
Zapatec.AlertWindow.prototype.alert = function(message) {
	if (!this.getContainer() || this.getContainer().parentNode != document.body) {
		this.create(null, null, this.config.width, this.config.height);
	}
	this.setScreenPosition(this.config.left, this.config.top);
	this.setTitle(this.config.title);
	this.show();
	if (!this.messageArea) {
		this.setDivContent(this.createContent());
	}
	this.messageArea.innerHTML = message || this.config.message;
};
