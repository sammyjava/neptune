// $Id: form-core.js 15736 2009-02-06 15:29:25Z nikolai $
/**
 *
 * Copyright (c) 2004-2009 by Zapatec, Inc.
 * http://www.zapatec.com
 * 1700 MLK Way, Berkeley, California,
 * 94709, U.S.A.
 * All rights reserved.
 */

/**
* The Zapatec.Form object constructor. Call it, for example, like this:
*
* <pre>
*	new Zapatec.Form({
*		form: 'userForm',
*		showErrors: 'afterField',
*		showErrorsOnSubmit: true,
*		submitErrorFunc: testErrOutput,
*		theme: "WinXP"
*	});
* </pre>
*
* The above creates a new Form object. During initialization constructor
* would change page layout to display special marks near each field. Also
* standard form submit and reset would be replaced with custom handlers.
* You always could retrieve reference to this object:
* <pre>
*	document.getElementById('yourForm').zpForm
* </pre>
*
*	@param formRef [string or object] - reference to <FORM> element (deprecated.
*	use 'form' config option instead)
*	@param config [object] - all parameters are passed as the properties of this object.
*
* Constructor recognizes the following properties of the config object
* <pre>
*	property name		| description
*-------------------------------------------------------------------------------------------------
*	form				| [string or object]. Reference to <FORM> object
*	statusImgPos		| [string] Where to put status icon. Possible values:
*						|	'afterField' - icon would be putted after target field
*						|	'beforeField' - before target field(default value)
*						|	null - icon would not be displayed
*	showErrors			| [string] Where to put error text. Possible values:
*						|	'tooltip' - display error text as tooltip for field
*						|	'afterField' - text would be putted after target field
*						|	'beforeField' - before target field
*						|	function - use this function to display error
*						|	null - error text would not be displayed(default value) //TODO
*	showErrorsOnSubmit	| If setted to true - function, given by submitErrorFunc parameter would be
*						|	invoked on form submit. Default value - true.
*	submitErrorFunc 	| [function] Callback function reference to call on
*						| error. Callback function receives following object:
*						| {
*						| 	serverSide: true if this is server response or false if validation
*						| 	result [boolean],
*						| 	generalError: "Human readable error description" [string],
*						| 	fieldErrors: [
*						| 		{
*						| 			field: field element object [object],
*						| 			errorMessage: "Human readable error description" [string]
*						| 		},
*						| 		...
*						| 	]
*						| }
*						| fieldErrors property may be undefined.
*						| By default Zapatec.Form.prototype.submitErrorFunc is
*						| used. It displays errors as alert message.
*	submitValidFunc		| [function] Callback function reference to call after
*						| validation is passed. Useful to remove old error
*						| messages produced by submitErrorFunc during previous
*						| validation attempt.
*						| Default value - Zapatec.Form.prototype.submitValidFunc
*	asyncSubmitFunc		| [function] Callback function reference to call after
*						| the form is sent to the server using
*						| Zapatec.Transport.fetchJsonObj and "success" response
*						| is received from the server.
*						| Server response should be a valid JSON string in the following format:
*						| {
*						| 	"success": true | false,
*						| 	"callbackArgs": object that will be passed to callback function,
*						| 	"generalError": "Human readable error description",
*						| 	"fieldErrors": {
*						| 		"fieldName1": "Human readable error description",
*						| 		"fieldName2": "Human readable error description",
*						| 		...
*						| 	}
*						| }
*						| Callback function receives callbackArgs object.
*						| callbackArgs, generalError and fieldErrors properties are optional.
*						| submitErrorFunc callback function is called on error.
*	themePath			| [string] Relative or absolute URL to the form themes directory.
*						| Trailing slash is required.
*						| You may also include path into "theme" option below instead of using
*						| themePath option. Default value: "../themes/"
*	theme				| [string] Theme name that will be used to display the form.
*						| Corresponding CSS file will be picked and added into the HTML document
*						| head element automatically.
*						| Case insensitive.
*						| May also contain relative or absolute URL to the form themes directory.
*						| E.g. ../themes/default.css or http://my.web.host/themes/default.css
*	strict				| [boolean] If true - submit buttons will be disabled until all fields
*						| will pass validation succesfully
*	ajaxDebugFunc		| [function] If given - this function will be used to
*						| display debug information about AJAX requests.
*						| Function signature consists of one argument - string
*						| message.
*	dropDownTheme		| [string] use this theme for drop-down list in fields.
*	hideUntilThemeLoaded| [boolean] Hide form until theme is fully loaded. Default: false.
*	putTabIndexesOnError| If true then on submit if form was not filled 
*						|	correctly you can iterate through invalid keys 
*						|	using TAB key.
*	startupFocusPosition| Determines which field will be focused on form init. 
*						| Possible values: 
*						|	firstField - first field in the form
*						|	firstRequiredField  - first required field in the form
*						|	firstIncorrectField  - first invalid field in the form
*						|	null - do not put focus at all.
*	displayErrorWhileTyping | Display error message while user is typing in the
*							field. Default value - true.
*	multipleCallback	| Function to generate name and ID for cloned elements. 
*						| It receives reference to original element, reference 
*						| to cloned element and list of all cloned elements.
*						| By default it just adds unique numbers to cloned elements.
*	serverCallback		| Contains name of JS function that must be called from 
*						| server after processing request.
*	disableButtonsWhenAsyncSubmit| this option determines if submit buttons 
*						| will be disabled during asynchronous submit(when 
*						| asyncSubmitFunc parameter is given). If true - user 
*						| will be unable to submit form while response from 
*						| server is not received. default value - true. 
*	conditionalEvents	| Defines on which events conditional fields will be 
*						| checked. Possible values: focus, blur, keyup, 
*						| keydown, keypress, valueChanges, booleanValueChanged.
*						| By default - conditional fields will be checked on 
*						| all form events.
*	busyConfig			| Array of values similar for Zapatec.Transport.showBusy
*	autocompleteConfig| Array of values similar for Zapatec.AutoComplete configuration
*	maskPlaceholder| Defines character that should be displayed as placeholder when mask is used. Default - underscore.
* </pre>
*/

Zapatec.Form = function() {
	var objArgs = {};
	switch(arguments.length){
		case 1:
			objArgs = arguments[0];
			break;
		case 2:
			objArgs = arguments[1];
			objArgs.form = arguments[0];
			break;
	}

	// Call constructor of superclass
	Zapatec.Form.SUPERconstructor.call(this, objArgs);
};

/**
 * Unique static id of the widget class. Gives ability for Zapatec#inherit to
 * determine and store path to this file correctly when it is included using
 * Zapatec#include. When this file is included using Zapatec#include or path
 * to this file is gotten using Zapatec#getPath, this value must be specified
 * as script id.
 * @private
 */
Zapatec.Form.id = "Zapatec.Form";

// Inherit SuperClass
Zapatec.inherit(Zapatec.Form, Zapatec.Widget);

Zapatec.Form.prototype.init = function(objArgs){
	this.container = null; // reference to widget's FORM tag
	
	// processing Widget functionality
	Zapatec.Form.SUPERclass.init.call(this, objArgs);
	if(this.config.form.zpForm != null){
		Zapatec.Log({description: this.getMessage('initializeError')});
		return null;
	}
	
	this.container = this.config.form;

	// setting backlink to Zapatec.Form object
	this.createProperty(this.container, "zpForm", this);
	this.addCircularRef("container");

	this.container.className = this.container.className.replace(/\bzpForm.*?\b/, "") + " " + this.getClassName({prefix: "zpForm"});

	var self = this;

	// storing reference to previous onsubmit function
	var oldOnSubmit = this.container.onsubmit || function(){return true;};

	if (typeof(this.config.asyncSubmitFunc) == 'function'){
		if(this.config.serverCallback){
			// we need to create some hidden fields in this case, hidden iframe
			// and point form to submit into that iframe
			var targetName = "form-iframe-" + this.id; 
			var tmp = document.createElement("span");
			tmp.innerHTML = '<iframe name="'+targetName+'" style="display: none"></iframe>';
			var iframe= tmp.firstChild;

			this.container.parentNode.insertBefore(iframe, this.container);
			this.container.setAttribute("target", targetName);

			var hidden = document.createElement("input");
			hidden.setAttribute("type", "hidden");
			hidden.setAttribute("name", this.config.serverCallback);
			hidden.setAttribute("value", 
				"window.parent.Zapatec.Widget.getWidgetById(" + this.id + ").processAsyncResponse");
			this.container.appendChild(hidden);
		} 

		this.container.onsubmit = function(ev){var retVal = oldOnSubmit(ev); return self.asyncSubmit(ev) && retVal;};
	} else {
		this.container.onsubmit = function(ev){return self.submit(ev) && oldOnSubmit(ev);};
	}
	
	this.addCircularRef(this.container, "onsubmit");

	this.container.onreset = function(ev){setTimeout(function(ev){self.reset(ev);}, 1);};
	this.addCircularRef(this.container, "onreset");

	var focusedFlag = false;
	var els = []; // copy FORM.elements array here because it changes while creating field

	for(var ii = 0; ii < this.container.elements.length; ii++){
		els.push(this.container.elements[ii]);
	}

	// process all form elements
	for (var ii = 0; ii < els.length; ii++) {
		var el = els[ii];

		// if this is field
		if(!Zapatec.Form.Utils.ignoreField(el)) {
		    // trying to init form field
			var zpField = new Zapatec.Form.Field({
				form:this, 
				field: el,
				langId: this.config.langId,
				lang: this.config.lang,
				langCountryCode: this.config.langCountryCode,
				langEncoding: this.config.langEncoding,
				formConfig: this.config
			});

			if(this.config.startupFocusPosition){
				// if field was initialized (zpFormField variable assigned) - focus on 
				// first visible field in form
				if(
					el.zpFormField != null &&
					focusedFlag == false &&
					typeof(el.focus) != 'undefined' &&
					(
						typeof(el.type) == 'undefined' ||
						typeof(el.type) != 'undefined' &&
						el.type.toLowerCase() != 'hidden'
					) &&
					!el.disabled && // Internet Explorer can't focus
					!el.readOnly    // on disabled or readonly field
				){
					if(
						this.config.startupFocusPosition == "firstField" ||
						(
							this.config.startupFocusPosition == "firstRequiredField" && 
							zpField.hasFeature("zpFormRequired")
						) ||
						(
							this.config.startupFocusPosition == "firstIncorrectField" && 
							zpField.validate(true) != null &&
							zpField.validate(true).length > 0
						) 
					){
						
					// https://bugzilla.mozilla.org/show_bug.cgi?id=236791
					var tmp = el.getAttribute("autocomplete");

					// if element is not visible - IE throws an exception. Catch it.
					try{
						el.setAttribute('autocomplete','off');
						el.focus();
						focusedFlag = true;
					} catch(e){}

					el.setAttribute('autocomplete',tmp);
					}
				}
			}
		}
	}

	// process all elements inside form
	var childElements = this.container.all ? this.container.all : this.container.getElementsByTagName("*");

	for(var ii = childElements.length - 1; ii >= 0 ; ii--){
		var el = childElements[ii];

	    // initialize multiple elements
		Zapatec.Form.Utils.initMultipleField(el, true, this);

		// initialize conditional fields
		this.initConditionalField(el);
	}

	if(Zapatec.windowLoaded){
		this.formLoaded();
	} else {
		// otherwise - schedule on window load
		Zapatec.Utils.addEvent(window, "load", new Function("Zapatec.Widget.callMethod(" + this.id + ", 'formLoaded')"));
	}
};

/**
 * Configures form. Gets called from parent init method.
 *
 * @private
 * @param {object} objArgs User configuration
 */
Zapatec.Form.prototype.configure = function(objArgs){
	// Set defaults config options 
	this.defineConfigOption('langId', Zapatec.Form.id);
	this.defineConfigOption('lang', "en");
	this.defineConfigOption('form', null);
	this.defineConfigOption('statusImgPos', 'beforeField');
	this.defineConfigOption('showErrors', null);
	this.defineConfigOption('showErrorsOnSubmit', true);
	this.defineConfigOption('submitErrorFunc', Zapatec.Form.submitErrorFunc);
	this.defineConfigOption('submitValidFunc', null);
	this.defineConfigOption('asyncSubmitFunc', null);
	this.defineConfigOption('strict', false);
	this.defineConfigOption('asyncTheme', true);
	this.defineConfigOption('theme', "alternate");
	this.defineConfigOption('ajaxDebugFunc', null);
	this.defineConfigOption('dropDownTheme', "default");
	this.defineConfigOption('hideUntilThemeLoaded',	false);
	this.defineConfigOption('putTabIndexesOnError',	true);
	this.defineConfigOption('startupFocusPosition', "firstField");
	this.defineConfigOption('displayErrorWhileTyping', true);
	this.defineConfigOption('multipleCallback', Zapatec.Form.Utils.generateMultipleId);
	this.defineConfigOption('serverCallback');
	this.defineConfigOption('disableButtonsWhenAsyncSubmit', true);
	this.defineConfigOption('conditionalEvents');
	this.defineConfigOption('busyConfig');
	this.defineConfigOption('autoCompleteConfig');
	this.defineConfigOption('maskPlaceholder', '_');
	
	// Call parent method
	Zapatec.Form.SUPERclass.configure.call(this, objArgs);

	this.config.form = Zapatec.Widget.getElementById(this.config.form);

	if(
		this.config.form == null || 
		!this.config.form.nodeName ||
		this.config.form.nodeName.toLowerCase() != "form"
	){
		// no form found for given ID or it is not <FORM> element
		Zapatec.Log({description: this.getMessage('noFormError')});
		throw this.getMessage('noFormError');
	}
	
	// if conditionalEvents is a string - convert it to array
	if(typeof(this.config.conditionalEvents) == 'string'){
		this.config.conditionalEvents = [this.config.conditionalEvents];
	}
};

/**
 * Reconfigures the widget with new config options after it was initialized.
 * May be used to change look or behavior of the widget after it has loaded
 * the data. In the argument pass only values for changed config options.
 * There is no need to pass config options that were not changed.
 *
 * @param {object} objArgs Changes to user configuration
 */
Zapatec.Form.prototype.reconfigure = function(objArgs) {
	if(objArgs.theme){
		Zapatec.Utils.removeClass(this.container, this.getClassName({prefix: "zpForm"}));
	}
	
	// Call parent method
	Zapatec.Form.SUPERclass.reconfigure.call(this, objArgs);

	Zapatec.Utils.addClass(this.container, this.getClassName({prefix: "zpForm"}));

	// TODO support other options
};

Zapatec.Form.prototype.addStandardEventListeners = function(){
	if(this.config.multipleCallback == Zapatec.Form.Utils.generateMultipleId){
		// if standard multiple generator mechanism is used - add event on deleting field
		this.addEventListener("beforeDeleteMultiple", Zapatec.Form.Utils.beforeDeleteMultiple);
	}
}

/**
 * Handler for async form submit.
 * @private
 */
Zapatec.Form.prototype.asyncSubmit = function(){
	var self = this;

	// check if form is already submitted and result not received
	if(this.processing == true){
		return false;
	}

	// Validate if needed
	if (
		this.config.showErrorsOnSubmit &&
		typeof(this.config.submitErrorFunc) == 'function' &&
		!this.submit()
	){
		return false;
	}

	// submit form where its action attribute points
	var strUrl = this.container.getAttribute("action");

	if(Zapatec.is_ie){
		// IE return reference to <input name="action" ..> element if it is present in the form
		strUrl = this.container.attributes["action"];

		if(strUrl){
			strUrl = strUrl.nodeValue;
		}
	}
	
	if(!strUrl){
		return false;
	}


	if(this.config.disableButtonsWhenAsyncSubmit){
		// disabling all <input type="submit"> element in the form
		this.toggleSubmits(true);
		this.processing = true;
	}

	if(this.config.busyConfig){
		Zapatec.Transport.showBusy(this.config.busyConfig);
	}

	if(this.config.serverCallback){
		return true;
	}
	
	// Get urlencoded content
	var arrContent = [];
	var objFormElements = this.container.elements;

	for (var iElm = 0; iElm < objFormElements.length; iElm++) {
		var formEl = objFormElements[iElm];

		// skip field that has no name or is disabled
		if (!formEl.name || formEl.disabled){
			continue;
		}

		// skip not checked radiobuttons and checkboxes
		if(
			formEl.nodeName.toLowerCase() == 'input' &&
			(
				formEl.type.toLowerCase() == 'radio' ||
				formEl.type.toLowerCase() == 'checkbox'
			) &&
			!formEl.checked
		){
			continue;
		}

		var val = Zapatec.Form.Utils.getValue(formEl);
		
		if(val && val instanceof Array){
			for(var ii = 0; ii < val.length; ii++){
				arrContent.push(formEl.name + '=' + encodeURIComponent(val[ii]));
			}
		} else {
			arrContent.push(formEl.name + '=' + encodeURIComponent(val));
		}

	}

	var strMethod = this.container.getAttribute("method");

	if(Zapatec.is_ie){
		// IE return reference to <input name="action" ..> element if it is present in the form
		strMethod = this.container.attributes["method"];

		if(strMethod){
			strMethod = strMethod.nodeValue;
		}
	}
	
	if(strMethod){
		strMethod = strMethod.toUpperCase();
	}

	var strContent = arrContent.join('&');

	if(strMethod != 'POST'){
		if(strMethod === ''){
			strMethod = "GET";
		}

		strUrl += '?' + strContent;
		strContent = null;
	}

	// show debug information
	if(this.config.ajaxDebugFunc){
		this.config.ajaxDebugFunc(this.getMessage('ajaxDebugSeparator'));
		this.config.ajaxDebugFunc(this.getMessage('ajaxDebugSubmitTitle'));
		this.config.ajaxDebugFunc(strMethod + " " + strUrl);
		this.config.ajaxDebugFunc(this.getMessage('ajaxDebugQuery', strContent));
	}
	
	var strEncoding = this.container.getAttribute("encoding");

	if(Zapatec.is_ie){
		// IE return reference to <input name="encoding" ..> element if it is present in the form
		strEncoding= this.container.attributes["encoding"];

		if(strEncoding){
			strEncoding = strEncoding.nodeValue;
		}
	}

	// Submit form
	Zapatec.Transport.fetch({
		url: strUrl,
		method: strMethod,
		contentType: strEncoding,
		content: strContent,
		onLoad: function(objText){
			if(self.config.ajaxDebugFunc){
				self.config.ajaxDebugFunc(self.getMessage('ajaxDebugResponse', objText.responseText));
			}

			if(self.config.disableButtonsWhenAsyncSubmit){
				self.processing = false;

				// enabling all <input type="submit"> element in the form
				self.toggleSubmits(false);
			}

			if (objText.responseText == null) {
				Zapatec.Log({description: self.getMessage('ajaxSubmitNoResponseError', objText.responseText)});
				return null;
			}

			var objResponse = Zapatec.Transport.parseJson({strJson: objText.responseText});

			if(objResponse == null){
				Zapatec.Log({description: self.getMessage('ajaxSubmitCantParseError', objText.responseText)});
				return null;
			}

			return self.processAsyncResponse(objResponse);
		},
		onError: function(objError) {
			if(self.config.disableButtonsWhenAsyncSubmit){
				self.processing = false;

				// enabling all <input type="submit"> element in the form
				self.toggleSubmits(false);
			}

			var strError = '';

			if (objError.errorCode) {
				strError = objError.errorCode + ' ';
			}

			strError += objError.errorDescription;

			if(self.config.ajaxDebugFunc){
				self.config.ajaxDebugFunc(self.getMessage('ajaxDebugResponseError', strError));
			}

			if(
				self.config.showErrorsOnSubmit &&
				typeof(self.config.submitErrorFunc) == 'function'
			){
				self.config.submitErrorFunc({
					serverSide: true,
					generalError: strError
				});
			}
		}
	});

	return false;
};

Zapatec.Form.prototype.processAsyncResponse = function(objResponse){
	if(this.config.disableButtonsWhenAsyncSubmit){
		this.processing = false;

		// enabling all <input type="submit"> element in the form
		this.toggleSubmits(false);
	}

	if(this.config.busyConfig){
		Zapatec.Transport.removeBusy(this.config.busyConfig);
	}

	if (objResponse){
		if (objResponse.success) {
			// Success
			this.config.asyncSubmitFunc(objResponse.callbackArgs);
		} else if (this.config.showErrorsOnSubmit) {
			// Error
			// Array with error messages
			var arrFieldErrors = [];

			// Flag to indicate that focus is already set
			var boolFocusSet = false;

			// Go through errors received from the server
			if (objResponse.fieldErrors){
				for (var strFieldName in objResponse.fieldErrors) {
					// Find corresponding form field
					for (var iElm = 0; iElm < this.container.elements.length; iElm++) {
						var objField = this.container.elements[iElm];

						if (objField.name && objField.name == strFieldName) {
							// Add error message to the array
							arrFieldErrors.push({
								field: objField,
								errorMessage: objResponse.fieldErrors[strFieldName],
								validator: ''
							});

							// Set icon and status
							if(objField.zpFormField != null){
								objField.zpFormField.setImageStatus(objResponse.fieldErrors[strFieldName]);
							}

							// Field is found
							break;
						}
					}
				}
			}

			if (typeof(this.config.submitErrorFunc) == 'function') {
				this.config.submitErrorFunc({
					serverSide: true,
					generalError: objResponse.generalError || '',
					fieldErrors: arrFieldErrors
				});
			}
		}
	} else if(
		this.config.showErrorsOnSubmit &&
		typeof(this.config.submitErrorFunc) == 'function'
	){
		// No response
		this.config.submitErrorFunc({
			serverSide: true,
			generalError: this.getMessage('ajaxSubmitNoResponseError')
		});
	}
};

/**
 * Turn on/off submit buttons into form. 
 * @private
 * @param disable {boolean} If true - disable all submits in a form. Otherwise - enable
 */
Zapatec.Form.prototype.toggleSubmits = function(disable){
	var inputs = this.container.getElementsByTagName("input");

	for(var ii = 0; ii < inputs.length; ii++){
		if(inputs[ii].type == "submit"){
			inputs[ii].disabled = disable == true;
		}
	}
};

/**
 * Reset handler for form. It is called _after_ resetting form.
 * @private
 */
Zapatec.Form.prototype.reset = function(ev){
	for(var ii = 0; ii < this.container.elements.length; ii++){
		var field = this.container.elements[ii].zpFormField;

		if(field != null){
			field.setValueFromField();

			field.firstRun = true;

			field.blur();
		}
	}

	if(!ev){
		ev = window.event;
	}

	this.fireEvent("reset", ev);
	this.fireEvent("all", ev, "reset");
};

/**
 * @private
 * This function is called on form submit. If config.showErrorsOnSubmit
 * is true and config.submitErrorFunc is defined - then they would be called
 * after validation.
 * If there was no errors and config.submitValidFunc was defined - it would be called.
 */
Zapatec.Form.prototype.submit = function(ev){
	var errors = this.validate(false);

	if(
		errors != null &&
		errors.length > 0 &&
		this.config.showErrorsOnSubmit &&
		typeof(this.config.submitErrorFunc) == 'function'
	){
		this.config.submitErrorFunc({
			serverSide: false,
			generalError: errors.length == 1 ? this.getMessage('submitOneError') : this.getMessage('submitManyErrors', errors.length),
			fieldErrors: errors
		});

		try{
			errors[0].field.focus();
		} catch(e){}

		return false;
	}

	// call submitValidFunc callback is validation passed
	if (typeof(this.config.submitValidFunc) == 'function') {
		this.config.submitValidFunc();
	}

	if(!ev){
		ev = window.event;
	}

	this.fireEvent("submit", ev);
	this.fireEvent("all", ev, "submit");

	return true;
};

/**
 * Validate all elements in form.
 * @param onlyValidate {boolean} if true - then no visual marks will be added 
 * to fields. Default value - true. 
 * @return null if validation passed succesfully or return array of errors in 
 * other case.
 * @type object
 */
Zapatec.Form.prototype.validate = function(onlyValidate){
	if(typeof(onlyValidate) == "undefined"){
		onlyValidate = true;
	}

	var valid = true;
	var tabIndex = 1;
	var errors = [];
	
	for (var ii = 0; ii < this.container.elements.length; ii++){
		var el = this.container.elements[ii];

		if(el.zpFormField == null){
			continue;
		}
		
		if(!onlyValidate){
			el.zpFormField.firstRun = false;
		}

		var validate = el.zpFormField.validate(onlyValidate);
		var fieldValid = (validate == null || validate.length == 0);

		if(this.config.putTabIndexesOnError){
			if(fieldValid){
				el.tabIndex = 100 + tabIndex++;
				
				if(!Zapatec.is_ie){
					delete(el.tabIndex);
				}
			} else {
				el.tabIndex = tabIndex;
			}
		}

		if(!fieldValid)	{
			for(var jj = 0; jj < validate.length; jj++){
				errors.push(validate[jj]);
			}
		}

		valid = valid && fieldValid;
	}

	if(errors.length == 0){
		errors = null;
	}

	return errors;
};

/**
 * @private
 * This method is used to process conditional elements into form.
 * @param field {object} reference to element.
 */
Zapatec.Form.prototype.initConditionalField = function(field){
	var md = null;

	if(
		field.className &&
		(md = field.className.match(/zpForm(Display|Visible)When=([^\s]+)/))
	){
		var func = eval(md[2]);

		if(typeof(func) != "function"){
			return null;
		}

		var handler = null;

		var self = this;
		
		if(md[1] == 'Display'){
			handler = function(){
				var tmp = func();

				Zapatec.Form.Utils.toggleFormElements(field, tmp, false);

				if(field.zpFormField){
					Zapatec.Form.Utils.toggleFormElements(field.zpFormField.errorText, tmp, false);
					Zapatec.Form.Utils.toggleFormElements(field.zpFormField.requiredMark, tmp, false);
				}

				if(field.zpMultipleButton){
					Zapatec.Form.Utils.toggleFormElements(field.zpFormField.requiredMark, tmp, false);
				}

				if(self.config.strict){
					self.toggleSubmits(self.validate() != null);
				}
			};
		} else if(md[1] == 'Visible'){
			handler = function(){
				var tmp = func();

				Zapatec.Form.Utils.toggleFormElements(field, tmp, true);

				if(field.zpFormField){
					Zapatec.Form.Utils.toggleFormElements(field.zpFormField.errorText, tmp, true);
					Zapatec.Form.Utils.toggleFormElements(field.zpFormField.requiredMark, tmp, true);
				}

				if(field.zpMultipleButton){
					Zapatec.Form.Utils.toggleFormElements(field.zpFormField.requiredMark, tmp, true);
				}
				
				if(self.config.strict){
					self.toggleSubmits(self.validate() != null);
				}
			};
		}

		handler();

		var eventTypes = this.config.conditionalEvents;

		if(
			!eventTypes || 
			eventTypes.length == 0
		){
			eventTypes = ["all"];
		}

		for(var ii = 0; ii < eventTypes.length; ii++){
			this.addEventListener(eventTypes[ii], handler);
		}
	}
};

/**
 * Allows to add function, that would be called when any form element changes its value.
 * This method is deprecated - use form eventListeners instead of.
 * @deprecated
 * @param func {function} reference to function
 * @param eventType {string or array} When to call this conditional handler. Can be single string or 
 */
Zapatec.Form.prototype.addEvent = Zapatec.Form.prototype.addChangeHandler = function(func, eventTypes){
	if(typeof(func) == 'string'){
		func = eval(func);
	}

	if(typeof(func) != 'function'){
		return false;
	}

	if(!eventTypes || eventTypes.length == 0){
		eventTypes = ["all"];
	}

	if(typeof(eventTypes) == 'string'){
		eventTypes = [eventTypes];
	}

	for(var ii = 0; ii < eventTypes.length; ii++){
		this.addEventListener(eventTypes[ii], func);
	}
	
	func(null, "addEvent");

	if(this.config.strict){
		this.toggleSubmits(this.validate() != null);
	}

	return true;
};

/**
 * @private
 * @deprecated
 * Runs all changeHandlers for this form. This is stub for all changeHandlers functionality
 */
Zapatec.Form.prototype.runChangeHandlers = function(){
	this.fireEvent("all", null, "runChangeHandlers");
};

/**
 * @private
 * When window is loaded - validate all fields in the form and run change 
 *	handlers
 */
Zapatec.Form.prototype.formLoaded = function(){
	// if window loaded - run immediatly
	for(var ii = 0; ii<this.container.elements.length; ii++){
		var zpField = this.container.elements[ii].zpFormField;

		if(zpField != null){
			zpField.setValueFromField(true);
		}
	}

	this.fireEvent("formLoaded");
	this.fireEvent("all", null, "formLoaded");
};

Zapatec.Form.prototype.destroy = function(){
	for(var ii = 0; ii < this.container.elements.length; ii++){
		var field = this.container.elements[ii];
	
		if(field.zpFormField){
			field.zpFormField.destroy();
		}
	}
	
	this.discard();
};

/**
* Setup function that auto-activates all forms, which has classNames, that
* starts from "zpForm".
* Accepts same params as Zapatec.Form constructor(except 'form' parameter).
* If no 'theme' parameter was given - it would retrieve it from form className.
*/
Zapatec.Form.setupAll = function(params) {
	var forms = document.getElementsByTagName('form');

	if(!params){
		params = {};
	}
	
	if(!params.startupFocusPosition){
		params.startupFocusPosition = null;
	}

	if(forms && forms.length){
		for(var ff = forms.length - 1; ff >= 0; ff--){
			if(forms[ff].zpForm){
				// if form is already initialized - do nothing
				continue;
			}
			
			var arrMatch = forms[ff].className.match(/zpForm(\S*)/);

			if(arrMatch){
				// Get theme name
				var strThemeName = arrMatch[1];

				// Duplicate configuration object
				var objConfig = Zapatec.Utils.clone(params);

				// Modify configuration
				if (
					(objConfig.theme == null || objConfig.theme == "") &&
					strThemeName
				){
					objConfig.theme = strThemeName;
				}

				objConfig.form = forms[ff];

				new Zapatec.Form(objConfig);
			}
		}
	}
};

/**
 * @private
 * Default function for displaying validation errors.
 * @param objErrors {object} Errors object of following structure:
 *	{
 *		serverSide: true if this is server response or false if validation
 *		result [boolean],
 *		generalError: "Human readable error description" [string],
 *		fieldErrors: [
 *			{
 *				field: field element object [object],
 *				errorMessage: "Human readable error description" [string]
 *			},
 *			...
 *		]
 *	}
 *	fieldErrors property may be undefined.
 */
Zapatec.Form.submitErrorFunc = function(objErrors){
	var message = objErrors.generalError + '\n';

	if (objErrors.fieldErrors && objErrors.fieldErrors.length) {
		for (var ii = 0; ii < objErrors.fieldErrors.length; ii++) {
			message += (ii + 1) + ': Field ' + objErrors.fieldErrors[ii].field.name +
				' ' + objErrors.fieldErrors[ii].errorMessage + "\n";
		}

		message = message.substr(0 ,message.length - 1);
	}

	alert(message);
};

// class to mark element as interal element of Zapatec.Form(needed for cloning elements)
Zapatec.Form.IGNORE_CLASSNAME = "zpFormInternalEl";
