// $Id: form-field.js 16937 2009-04-09 08:28:43Z vasyl $
/**
 *
 * Copyright (c) 2004-2009 by Zapatec, Inc.
 * http://www.zapatec.com
 * 1700 MLK Way, Berkeley, California,
 * 94709, U.S.A.
 * All rights reserved.
 */

/**
 * @private
 * The Zapatec.Form object constructor.
 *  It would put special marks near field(basing on form config).
 *
 * You always could retrieve reference to this object:
 * <pre>
 *	document.getElementById('yourField').zpFormField
 * </pre>
 * @param form {Object} reference to Zapatec.Form instance. @see Zapatec.Form
 * @param field {Object} reference to HTML form element.
 */
Zapatec.Form.Field = function(objArgs){
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
Zapatec.Form.Field.id = "Zapatec.Form.Field";

// Inherit SuperClass
Zapatec.inherit(Zapatec.Form.Field, Zapatec.Widget);

/**
 * Configures form field. Gets called from parent init method.
 *
 * @private
 * @param {object} objArgs User configuration
 */
Zapatec.Form.Field.prototype.configure = function(objArgs){
	// Set defaults config options

	this.defineConfigOption('theme', 
		objArgs.formConfig && objArgs.formConfig.theme ? 
		objArgs.formConfig.theme : ""
	);

	this.defineConfigOption('themePath', 
		objArgs.formConfig && objArgs.formConfig.themePath ? 
		objArgs.formConfig.themePath : Zapatec.Form.path + "../themes/"
	);
	
	if(!objArgs.lang && objArgs.formConfig.lang){
		objArgs.lang = objArgs.formConfig.lang;
	}

	if(!objArgs.langCountryCode && objArgs.formConfig.langCountryCode){
		objArgs.langCountryCode = objArgs.formConfig.langCountryCode;
	}

	if(!objArgs.langEncoding && objArgs.formConfig.langEncoding){
		objArgs.langEncoding = objArgs.formConfig.langEncoding;
	}

	this.defineConfigOption('form');
	this.defineConfigOption('formConfig', {});
	this.defineConfigOption('field');
	this.defineConfigOption('langId', "Zapatec.Form");
	this.defineConfigOption('inheritFrom', {});

	// Call parent method
	Zapatec.Form.SUPERclass.configure.call(this, objArgs);

	if(!this.config.inheritFrom){
		this.config.inheritFrom = {};
	}

	this.config.form = Zapatec.Widget.getElementById(this.config.form);
	this.config.field = Zapatec.Widget.getElementById(this.config.field);
};

/**
 * Reconfigures the widget with new config options after it was initialized.
 * May be used to change look or behavior of the widget after it has loaded
 * the data. In the argument pass only values for changed config options.
 * There is no need to pass config options that were not changed.
 *
 * @param {object} objArgs Changes to user configuration
 */
Zapatec.Form.Field.prototype.reconfigure = function(objArgs) {
	// Call parent method
	Zapatec.Form.SUPERclass.reconfigure.call(this, objArgs);
};


Zapatec.Form.Field.prototype.init = function(objArgs){
	if (Zapatec.Form.Utils.ignoreField(objArgs.field) || objArgs.field.zpFormField) {
		return null;
	}
	
	this.form = null; // storing params in internal variables.
	this.state = {}; // variable for storing internal variables
	this.features = {}; // setup array of features
	this.keyPressCounter = 0; // this variable indicates how many key was pressed 
							  // during last Zapatec.Form.Field.DELAYED_INTERVAL 
							  // period.
	
	this.firstRun = true; // default value
	this.chars = null;        // if field has zpFormMask - 
	this.enteredValue = null; // it will use this arrays
	this.dropDown = null; // if needed - this variable will be used
	this.isBooleanField = false; // if this is boolean (boolean field can be 
								 //only in two stated - checked on unchecked)
	
	this.isEditing = false; // Determines if field is editing in a moment
		
	// processing Widget functionality
	Zapatec.Form.SUPERclass.init.call(this, objArgs);
	
	this.autoCompleteOptions = this.config.inheritFrom.autoCompleteOptions ? 
		this.config.inheritFrom.autoCompleteOptions : []; // stores values for autocompletion

	this.field = this.config.field;
	this.features = this.config.inheritFrom.features ? // if field is cloned one - inherit original field features.
		this.config.inheritFrom.features : 
		Zapatec.Form.Utils.getTokens(this.field.className, " ");

	if(this.hasFeature("zpFormRequired")){
		this.setFeature("zpFormRequired", true);
	}

	this.isBooleanField = (
		this.field.nodeName.toLowerCase() == 'input' &&
		(
			this.field.type.toLowerCase() == 'radio' || 
			this.field.type.toLowerCase() == 'checkbox'
		)
	);

	var md = null;

	// use new "zpFormAllowedChars" instead of deprecated "zpFormAllowed-"
	if(md = this.field.className.match(/zpFormAllowed-(\S+)/)){
		if(!this.features['zpFormAllowedChars']){
			this.features['zpFormAllowedChars'] = "";
		}

		this.features['zpFormAllowedChars'] += '\\' + md[1].split('').join('\\');
	}

	if(
		typeof(this.features['zpFormAllowedChars']) != 'undefined' &&
		this.getFeature('zpFormAllowedChars') == null
	){
		var undef;
		this.features['zpFormAllowedChars'] = undef;
	}

	// if this field has zpFormAutoComplete or zpFormAutoCompleteStrict - 
	// extract autocomplete options
	if(
		(
			this.hasFeature("zpFormAutoComplete") ||
			this.hasFeature("zpFormAutoCompleteStrict")
		) &&
		this.field.nodeName.toUpperCase() == "SELECT"
	){
		var input = document.createElement('input');

		for(var ii = 0; ii < this.field.attributes.length; ii++){
			var attr = this.field.attributes[ii];

			if(attr.name == 'class'){
				input.className = this.field.getAttribute(attr.name);
			} else {
				input.setAttribute(attr.name, this.field.getAttribute(attr.name));
			}
		}

		for(var ii = 0; ii < this.field.options.length; ii++){
			this.autoCompleteOptions.push(this.field.options[ii].innerHTML);
		}

		if(this.field.selectedIndex != null){
			var val = null;

			if(
				this.field.options[this.field.selectedIndex].value != null &&
				this.field.options[this.field.selectedIndex].value != ""
			){
				val = this.field.options[this.field.selectedIndex].value;
			} else {
				val = this.field.options[this.field.selectedIndex].innerHTML;
			}
			
			input.value = val;
			input.setAttribute("value", val);
		}

		Zapatec.Utils.insertAfter(this.field, input);
		Zapatec.Utils.destroy(this.field);

		input.type = 'text';

		this.field = input;
	}

	if(
		this.hasFeature("zpFormAutoComplete") ||
		this.hasFeature("zpFormAutoCompleteStrict") ||
		this.hasFeature("zpFormSuggest")
	){
		// disable browser tips
		this.field.setAttribute("autocomplete", "off");
		this.field.autoComplete = "off";
	}

	var self = this;

	this.form = this.config.form;

	if(!this.form){
		// Form widget stub
		this.form = {
			container: {elements:[this.field]},
			fireEvent: function(){},
			validate: function(){return self.validate()},
			toggleSubmits: function(){},
			container: this.field.parentNode
		};

		if(this.field.parentNode){
			Zapatec.Utils.addClass(this.field.parentNode, this.getClassName({prefix: "zpForm"}));
		}
	}
	
	// initializing internal arrays for zpFormMask validation type
	if(this.hasFeature("zpFormMask")){
		// remove maxlength attribute if present.
		// It makes no sense together with mask and avoids mask to work correctly
		if(this.field.hasAttribute && this.field.hasAttribute("maxlength")){
			this.field.setAttribute("maxlength", null);
		}

		var mask = this.getFeature("zpFormMask");

		var maskChars = mask.split('');
		this.chars = [];
		this.enteredValue = [];

		for(var ii = 0; ii < maskChars.length; ii++){
			var tmp = null;

			switch(maskChars[ii]){
				case "0":
					tmp = "[0-9]";
					break;
				case "L":
					tmp = "[a-zA-Z]";
					break;
				case "A":
					tmp = "[0-9a-zA-Z]";
					break;
				case "&":
					tmp = ".";
					break;
				case '\\':
					ii++;
					if(ii >= maskChars.length)
						break;
					// fall through
				default:
					this.chars.push(maskChars[ii]);
					this.enteredValue.push(maskChars[ii]);
			}

			if(tmp != null){
				var re = new RegExp("^" + tmp + "$");
				this.chars.push(re);

				this.enteredValue.push(null);
			}
		}
	}

	// creating back reference
	this.createProperty(this.field, "zpFormField", this);

	// setting up special handlers for all events.
	// Note: we need to get reference to Zapatec.Form.Field from field object, 
	//	because this can be cloned field. In that case in IE cloned object 
	//	will have eventlisteners from original object.
	var oldOnKeyDown = this.field.onkeydown || function(){return true;};
	Zapatec.Utils.createProperty(this.field, "onkeydown", function(ev){
		var zpField = Zapatec.Utils.getTargetElement(ev).zpFormField;
		var res = oldOnKeyDown();
		return zpField.keydown(ev) && res;
	});

	var oldOnKeyPress = this.field.onkeypress || function(){return true;};
	Zapatec.Utils.createProperty(this.field, "onkeypress", function(ev){
		var zpField = Zapatec.Utils.getTargetElement(ev).zpFormField;
		var res = oldOnKeyPress();
		return zpField.keypress(ev) && res;
	});

	Zapatec.Utils.addEvent(this.field, 'keyup', function(ev){
		var zpField = Zapatec.Utils.getTargetElement(ev).zpFormField;
		return zpField.keyup(ev);
	}, false, false);

	Zapatec.Utils.addEvent(this.field, 'focus', function(ev){
		var zpField = Zapatec.Utils.getTargetElement(ev).zpFormField;
		return zpField.focus(ev);
	}, false, false);

	Zapatec.Utils.addEvent(this.field, 'blur', function(ev){
		var zpField = Zapatec.Utils.getTargetElement(ev).zpFormField;
		return zpField.blur(ev);
	});

	if(this.field.nodeName.toLowerCase() == 'select'){
		Zapatec.Utils.addEvent(this.field, 'change', function(ev){
			var zpField = Zapatec.Utils.getTargetElement(ev).zpFormField;
			return zpField.valueChanged(ev);
		}, false, false);
	}

	// validate field when field value changes
	var onChangeFunc = function(ev){
		var zpField = Zapatec.Utils.getTargetElement(ev).zpFormField;
    
		return zpField.valueChanged(ev);
	};

	Zapatec.Utils.addEvent(this.field, 'keyup', onChangeFunc);

	if(Zapatec.is_ie){
		Zapatec.Utils.addEvent(this.field, 'paste', onChangeFunc, false, false);
	} else if(Zapatec.is_gecko) {
		Zapatec.Utils.addEvent(this.field, 'input', onChangeFunc, false, false);
	} else {
		Zapatec.Utils.addEvent(this.field, 'change', onChangeFunc, false, false);
	}

	if(this.isBooleanField){
		this.otherFields = [];
	
		if(this.field.name){
			this.otherFields = this.config.form.container[this.field.name];

			if(!this.otherFields instanceof Array){
				this.otherFields = [this.otherFields];
			}
		}
		onChangeFunc = function(ev){
			var zpField = Zapatec.Utils.getTargetElement(ev).zpFormField;

			return zpField.booleanChanged();
		};

		Zapatec.Utils.addEvent(this.field, 'change', onChangeFunc, false, false);

		// IE doesn't fire onchange on first change
		Zapatec.Utils.addEvent(this.field, 'click', onChangeFunc, false, false);
	}

	// Next some <span> elements, as IE doens't support multi-class selectors.
	this.requiredMark = Zapatec.Utils.createElement('span');
	this.requiredMark.className = Zapatec.Form.IGNORE_CLASSNAME;
	this.requiredMark.id = "zpFormField" + this.id + "StatusImg1";

	this.editingMark = this.requiredMark.appendChild(Zapatec.Utils.createElement('span'));
	this.editingMark.className = Zapatec.Form.IGNORE_CLASSNAME;
	this.editingMark.id = "zpFormField" + this.id + "StatusImg2";

	this.emptyMark = this.editingMark.appendChild(Zapatec.Utils.createElement('span'));
	this.emptyMark.className = Zapatec.Form.IGNORE_CLASSNAME;
	this.emptyMark.id = "zpFormField" + this.id + "StatusImg3";

	this.validMark = this.emptyMark.appendChild(Zapatec.Utils.createElement('span'));
	this.validMark.className = Zapatec.Form.IGNORE_CLASSNAME;
	this.validMark.id = "zpFormField" + this.id + "StatusImg4";

	this.fetchingMark = this.validMark.appendChild(Zapatec.Utils.createElement('span'));
	this.fetchingMark.className = Zapatec.Form.IGNORE_CLASSNAME;
	this.fetchingMark.id = "zpFormField" + this.id + "StatusImg5";

	// The innermost is the one we actually style.
	this.statusImg = this.fetchingMark.appendChild(Zapatec.Utils.createElement('span'));
	this.statusImg.className = Zapatec.Form.IGNORE_CLASSNAME + ' zpStatusImg';
	this.statusImg.id = "zpFormField" + this.id + "StatusImg";

	this.addCircularRef(this, "statusImg");
	this.addCircularRef(this, "fetchingMark");
	this.addCircularRef(this, "validMark");
	this.addCircularRef(this, "emptyMark");
	this.addCircularRef(this, "editingMark");
	this.addCircularRef(this, "requiredMark");

	// An error container.
	this.errorText = Zapatec.Utils.createElement('span');
	this.errorText.id = "zpFormField" + this.id + "ErrorText";
	this.errorText.className = Zapatec.Form.IGNORE_CLASSNAME + ' zpFormError';
	
	if(this.field.type && (this.field.type.toLowerCase() == "hidden" ||
	                       this.field.getAttribute('type') == "hidden")){
		// if this is hidden field - hide dependant elements
		this.errorText.style.display = 'none';
		this.requiredMark.style.display = 'none';
	}

	// Radio buttons and checkboxes needs some more functionality
	if(this.isBooleanField){
		// add custom CSS classes to checkboxes and radiobuttons
		if(this.field.type.toLowerCase() == "checkbox"){
			this.field.className += " zpFormCheckbox";
			this.statusImg.className += " zpCheckboxStatusImg";
		} else if(this.field.type.toLowerCase() == "radio"){
			this.field.className += " zpFormRadio";
			this.statusImg.className += " zpRadioStatusImg";
		} else {
			this.statusImg.className += " zpCommonStatusImg";
		}
	} else {
		this.statusImg.className += " zpCommonStatusImg";
	}

	var lastNode = this.field;

	// Attach the outermost <span> near the input field.
	if(this.config.formConfig.statusImgPos == 'afterField'){
		Zapatec.Utils.insertAfter(this.field, this.requiredMark);
		lastNode = this.requiredMark;
	} else if(this.config.formConfig.statusImgPos == 'beforeField'){
		this.field.parentNode.insertBefore(this.requiredMark, this.field);
	} else if(this.config.formConfig.statusImgPos == 'last'){
		this.field.parentNode.appendChild(this.requiredMark);
	}

	// Position it by the field if configured that way.
	if(this.config.formConfig.showErrors == 'afterField'){
		Zapatec.Utils.insertAfter(this.field, this.errorText);
		lastNode = this.errorText;
	} else if (this.config.formConfig.showErrors == 'beforeField'){
		this.field.parentNode.insertBefore(this.errorText, this.field);
	} else if (this.config.formConfig.showErrors == 'last'){
		this.field.parentNode.appendChild(this.errorText);
	}

	if(this.hasFeature("zpFormMultiple")){
		this.createProperty(this.field, "zpLastNode", lastNode);
	}

	if(
		this.hasFeature("zpFormSuggest") ||
		this.hasFeature("zpFormAutoComplete") ||
		this.hasFeature("zpFormAutoCompleteStrict")
	){
		if(typeof(Zapatec.AutoComplete) == 'undefined'){
			Zapatec.Transport.loadJS({
				url: Zapatec.zapatecPath + '../zpautocomplete/src/zpautocomplete-core.js',
				async: true,
				onLoad: function(){
					self.initDropDown();
				}
			});
		} else {
			this.initDropDown();
		}
	}

	var value = this.getValue();
	if(value && value.length > 0){
		// if field has predefined value
		this.ajaxValidate();
		this.suggestValue();
		this.ajaxFill();
	}

	this.setValueFromField(true);
};

// interval before last keystroke and sending request to server.
Zapatec.Form.Field.DELAYED_INTERVAL = 1000;

/**
 * @private
 * Create Zapatec.DropDown object
 */
Zapatec.Form.Field.prototype.initDropDown = function(){
	var self = this;

	var arrow = Zapatec.Utils.createElement("span");
	arrow.className = Zapatec.Form.IGNORE_CLASSNAME + " dropDownArrow";
	arrow.id = "zpFormField" + this.id + "DropDownArrow";

	this.createProperty(arrow, "onclick", function(ev){
		self.field.focus(ev);
		self.autoCompleteValue(self.getAutoCompleteOptions(true));

		self.suggestValue(true);
	});

	Zapatec.Utils.insertAfter(this.field, arrow);
	
	var tmpConfig = Zapatec.Utils.clone (this.config.formConfig.autoCompleteConfig);
	if (!tmpConfig) {
		tmpConfig = {};
	}
	tmpConfig.fields = [this.field];
	tmpConfig.width = "auto";
	tmpConfig.dataOnDemand = false;
	tmpConfig.convertTip = function(tipObj){
			return tipObj.title;
	}
	tmpConfig.selectTip = function(tipObj){
			self.setValue(tipObj.title)
			self.valueChanged();
			if (self.field.onchange) {
				self.field.onchange();
			}
		}
	
	this.dropDown = new Zapatec.AutoComplete(tmpConfig);

	this.dropDown.field = this.field;
};

/**
 * @private
 * This function is called when field value is changed using copy-paste.
 * For IE it is called when pasting clipboard into field, for FF on each field 
 * value change(including keystrokes), for other browser - on "onchange" event.
 */
Zapatec.Form.Field.prototype.valueChanged = function(ev){
	if(this.hasFeature("zpFormAllowedChars") || this.hasFeature("zpFormMask")){
		this.setValueFromField();
	} else {
		this.validate();
	}

	if(!ev){
		ev = window.event;
	}
	
	this.fireEvent("valueChanged", ev);
	this.fireEvent("all", ev, "valueChanged");
	this.form.fireEvent("valueChanged", ev);
	this.form.fireEvent("all", ev, "valueChanged");
	
	return true;
};

/**
 * @private
 * This function is called when checkbox or radio button is checked/unchecked.
 */
Zapatec.Form.Field.prototype.booleanChanged = function(ev){
	if(!this.isBooleanField){
		return;
	}

	for(var ii = 0; ii < this.otherFields.length; ii++){
		var el = this.otherFields[ii];

		if(!el || !el.zpFormField){
			continue;
		}
		
		if(!this.firstRun){
			el.zpFormField.firstRun = false;
		}

		el.zpFormField.validate();
	}

	if(!ev){
		ev = window.event;
	}

	this.fireEvent("valueChanged", ev);
	this.fireEvent("booleanValueChanged", ev);
	this.fireEvent("all", ev, "booleanValueChanged");
	this.form.fireEvent("valueChanged", ev);
	this.form.fireEvent("booleanValueChanged", ev);
	this.form.fireEvent("all", ev, "booleanValueChanged");

	return true;
};

/**
 * @private
 * Handler for keydown event.
 */
Zapatec.Form.Field.prototype.keydown = function(evt){
	if(!this.isEditing){
		return false;
	}

	if(!evt){
		evt = window.event;
	}

	this.fireEvent("keydown", evt);
	this.fireEvent("all", evt, "keydown");
	this.form.fireEvent("keydown", evt);
	this.form.fireEvent("all", evt, "keydown");

	this.state.lastSelectionStart = this.getSelectionStart();
	this.state.lastSelectionEnd = this.getSelectionEnd();

	// this is IE workaround - IE catches nonalphanumeric keys only on keydown.
	if(
		Zapatec.is_ie &&
		(
			this.hasFeature('zpFormAllowedChars') || 
			this.hasFeature("zpFormMask")
		)
	){
		var tmpArr = Zapatec.Utils.getCharFromEvent(evt);
		var charCode = tmpArr.charCode;
		var newChar = tmpArr.chr;

		if(
			Zapatec.Form.Utils.isSpecialKey(charCode, newChar) ||
			this.processFunctionalKeys(evt) == true
		){
			return true;
		}

		if(this.hasFeature("zpFormMask")){
			if(this.processCustomKeys(charCode) == true){
				return true;
			}

			return false;
		}

		if(this.hasFeature('zpFormAllowedChars')){
			this.setValueFromField();
		}
	}

	if(this.dropDown){
		this.dropDown.hide();
	}

	return true;
};

/**
 * @private
 * Handler for keypress event.
 * @param {Event} event object
 */
Zapatec.Form.Field.prototype.keypress = function(evt) {
	if(!this.isEditing){
		return false;
	}

	if(!evt){
		evt = window.event;
	}

	this.fireEvent("keypress", evt);
	this.fireEvent("all", evt, "keypress");
	this.form.fireEvent("keypress", evt);
	this.form.fireEvent("all", evt, "keypress");

	if (this.hasFeature('zpFormAllowedChars')){
		if(this.processFunctionalKeys(evt) == true){
			return true;
		}

		//the key that was pressed
		var tmpArr = Zapatec.Utils.getCharFromEvent(evt)
		var charCode = tmpArr.charCode;
		var newChar = tmpArr.chr;

		if(
			(
				Zapatec.Form.Utils.isSpecialKey(charCode, newChar) ||
				charCode == 8 ||
				charCode == 46
			)
		){
			return true;
		}

		var allowed = new RegExp('[' + this.getFeature('zpFormAllowedChars') + ']');

		this.setValueFromField();

		if (!(allowed.test(newChar))) {
			Zapatec.Utils.addClass(this.field, "zpWrongValue");
			this.field.readonly = true;

			var self = this;
			setTimeout(function(){
				Zapatec.Utils.removeClass(self.field, "zpWrongValue");
				self.field.readonly = false;
			}, 100);

			return false;
		}

		return true;
	}

	if(this.hasFeature("zpFormMask")){
		var self = this;

		var tmpArr = Zapatec.Utils.getCharFromEvent(evt)

		var charCode = tmpArr.charCode;
		var newChar = tmpArr.chr;

		if(this.processFunctionalKeys(evt) == true){
			return true;
		}

		this.setValueFromField();

		var pos = this.getSelectionStart();

		if(charCode == null && newChar == null){
			return false;
		}

		if(!Zapatec.is_ie){
			if(Zapatec.Form.Utils.isSpecialKey(charCode, newChar)){
				return true;
			}

			if(this.processCustomKeys(charCode) == false){
				return false;
			}
		}

		// if char under cursor is strict - search for next mask char.
		// If no such char founded - leave at current position and exit
		if(typeof(this.chars[pos]) == 'string'){
			var newPos = this.getNextAvailablePosition(pos);

			if(newPos == null || newPos == pos)
				return false;

			this.setCaretPosition(newPos);
			pos = newPos;
		}

		// check if entered char could be applied to current mask element.
		if(
			pos >= this.chars.length ||
			typeof(this.chars[pos]) != 'string' && !newChar.match(this.chars[pos]) ||
			typeof(this.chars[pos]) == 'string' && newChar != this.chars[pos]
		){
			Zapatec.Utils.addClass(this.field, "zpWrongValue");
			this.field.readonly = true;

			setTimeout(function(){
				Zapatec.Utils.removeClass(self.field, "zpWrongValue");
				self.field.readonly = false;
			}, 100);

			this.setValue();
			this.setCaretPosition(pos);
		} else {
			// all is ok. store and display entered char.
			this.enteredValue[pos] = newChar;
			this.setValue();

			var newPos = this.getNextAvailablePosition(pos);

			if(newPos == null){
				newPos = pos + 1;
			}

			this.setCaretPosition(newPos);
		}

		if(evt && evt.preventDefault){
			evt.preventDefault();
		}

		return false;
	}
	
	return true;
};

/**
 * @private
 * Handler for keyup event.
 * @param {Event} event object
 */
Zapatec.Form.Field.prototype.keyup = function(evt) {
	if(!this.isEditing){
		return false;
	}

	if(!evt){
		evt = window.event;
	}

	this.fireEvent("keyUp", evt);
	this.fireEvent("all", evt, "keyup");
	this.form.fireEvent("keyUp", evt);
	this.form.fireEvent("all", evt, "keyup");

	if(evt){
		var tmp = Zapatec.Utils.getCharFromEvent(evt);
	    
		if(
			Zapatec.Form.Utils.isSpecialKey(tmp.charCode, tmp.chr) ||
			(
				(
					tmp.charCode == 8 ||
					tmp.charCode == 46
				) &&
				this.state.lastSelectionStart != this.state.lastSelectionEnd
			)
		){
			return true;
		}
	}
	    
	this.validate();

	if(this.hasFeature("zpFormAutoComplete") || this.hasFeature("zpFormAutoCompleteStrict")){
		this.autoCompleteValue(this.getAutoCompleteOptions());
	}

	this.keyPressCounter++;
	var self = this;
	setTimeout(function(){self.runDelayedActions()}, Zapatec.Form.Field.DELAYED_INTERVAL);

	return true;
};

/**
 * @private
 * handler for focus event.
 * @param {Event} event object
 */
Zapatec.Form.Field.prototype.focus = function(evt) {
	if(!evt){
		evt = window.event;
	}
	
	if(this.field.readOnly){
		return;
	}
	
	this.isEditing = true;
	this.firstRun = false;

	if(this.hasFeature("zpFormMask")){
		if(this.isEmpty()){
			this.setValue();
			this.setCaretPosition(0);
		}
	}

	if(this.isBooleanField){
		this.booleanChanged(evt);
	}

	this.fireEvent("focus", evt);
	this.fireEvent("all", evt, "focus");
	this.form.fireEvent("focus", evt);
	this.form.fireEvent("all", evt, "focus");

	this.validate();
};

/**
 * @private
 * handler for blur event.
 * @param {Event} event object
 */
Zapatec.Form.Field.prototype.blur = function(evt) {
	if(!evt){
		evt = window.event;
	}
	
	// clean mask layout from field if no value was entered
	if(this.hasFeature("zpFormMask") && !this.isFilled()){
		Zapatec.Form.Utils.setValue(this.field, "");
	}

    if(!this.isEditing){
    	return;
    }

	this.isEditing = false;

	if(this.hasFeature("zpFormAllowedChars")){
		this.setValueFromField(true);
	}

	this.fireEvent("blur", evt);
	this.fireEvent("all", evt, "blur");
	this.form.fireEvent("blur", evt);
	this.form.fireEvent("all", evt, "blur");

	this.validate();
};

/**
 * @private
 * function to validate current field.
 * @param onlyValidate {boolean} If true - only validate field. Else - also 
 *	display error message.
 * @return array of error in format 
 * [
 *	{
 *		'field': [string], // field name
 *		'errorMessage': [string], // error message
 *		'validator': [string] // validator name
 *	},
 *	...
 * ]
 * @type Object
 */
Zapatec.Form.Field.prototype.validate = function(onlyValidate) {
	if (
		!this.field.className || 
		this.field.disabled
	){
		return null;
	}

	var message = null;
	var errors = [];

	var isRequired = this.isRequired();
	
	// performance optimizations
	var isEmpty = this.isEmpty();

	if(this.isBooleanField && !isRequired){
		isEmpty = this.field.checked;
	}

	if(this.firstRun && !isEmpty || this.field.disabled){
		this.firstRun = false;
	}

	var validatorUsed = isRequired;
	var validatorName = null;
	var l10nMessage = null;
	var messageArgument = null;

	function addError(self, errors, validatorName, l10nMessage, messageArgument){
		if(!validatorName){
			return null
		}

	 	var message = self.hasFeature(validatorName + "Error") ? 
	 		self.getFeature(validatorName + "Error") : 
	 		self.getMessage(l10nMessage, messageArgument);

	 	if(!message){
	 		message = self.getMessage(l10nMessage, messageArgument);
	 	}

	 	message = message.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/\>/g, '&gt;');
		
		errors.push({
			field: self.field, 
			errorMessage: message, 
			validator: validatorName
		});

		return message;
	}

	// If field is empty - do not run any validations. Only display error if
	// field is required.
	if(isEmpty){
		validatorUsed = true;

		if(isRequired){
			validatorName = "zpFormRequired";
			l10nMessage = "isRequiredError";
		}
	} else {
		for(var vName in this.features){
			if(vName == 'zpFormMask'){
				validatorUsed = true;
		
				if(!this.isMaskFullyFilled()){
					validatorName = "zpFormMask";
					l10nMessage = 'maskNotFilledError';
					messageArgument = this.getFeature("zpFormMask");

					// do not run any other validators until mask is filled.
					break;
				}
			}

			if(vName == 'zpFormAutoCompleteStrict'){
				validatorUsed = true;
				
				var found = false;
				var currVal = this.getValue();

				for(var ii = this.autoCompleteOptions.length - 1; ii >= 0 ; ii--){
					if(currVal == this.autoCompleteOptions[ii]){
						found = true;
						break;
					}
				}

				if(!found){
					validatorName = "zpFormAutoCompleteStrict";
					l10nMessage = "noSuchAutoCompleteValueError";
				}
			}

			if(typeof(Zapatec.Form.dataTypes[vName]) != 'undefined'){
				validatorUsed = true;
		
				var validator = Zapatec.Form.dataTypes[vName];
				var validatorPassed = true;
				messageArgument = this.getFeature(vName);

				if(validator.regex){
					// Regex validation.
					validatorPassed = validator.regex.test(this.getValue());
				} else if (validator.func){
					// Javascript function validation.
					validatorPassed = validator.func(this.getValue(), this.getFeature(vName));
				}

				if(!validatorPassed){
					validatorName = vName;
					l10nMessage = validator.error;
				}
			}

			if(validatorName){
				message = addError(this, errors, validatorName, l10nMessage, messageArgument) || message;
				validatorName = null;
			}
		}

		if(this.ajaxError != null){
			validatorUsed = true;
	
			validatorName = "zpFormValidate";
			l10nMessage = this.ajaxError;
		}
	}

	message = addError(this, errors, validatorName, l10nMessage, messageArgument) || message;

	if(!onlyValidate && validatorUsed){
		this.setImageStatus(message, isEmpty);
	}

	return errors;
};

/**
 * @private
 * Sets the CLASS of the status indicator next to a form field, and its title
 * tooltip popup.
 * @param status - [string] error message
 * @param isEmpty - [boolean] Optional. Optimization tip. Do not use it.
 */
Zapatec.Form.Field.prototype.setImageStatus = function(status, isEmpty) {
	var isRequired = this.isRequired();
	
	if(typeof(isEmpty) == 'undefined'){
		isEmpty = this.isEmpty();
	}	

	// clear all marks from status fields.
	this.requiredMark.className = Zapatec.Form.IGNORE_CLASSNAME + (isRequired ? ' zpIsRequired' : ' zpNotRequired');
	this.editingMark.className = Zapatec.Form.IGNORE_CLASSNAME;
	this.emptyMark.className = Zapatec.Form.IGNORE_CLASSNAME;
	this.validMark.className = Zapatec.Form.IGNORE_CLASSNAME;
	this.errorText.innerHTML = "";

	if(this.config.formConfig.strict){
		if(status == null){
			this.form.toggleSubmits(this.form.validate() != null);
		} else {
			this.form.toggleSubmits(true);
		}
	}

	// process field only if this is not first round mark
	if(
		!this.firstRun && 
		(
			isRequired && 
			isEmpty || 
			!isEmpty
		)
	){
		this.editingMark.className = Zapatec.Form.IGNORE_CLASSNAME + (this.isEditing ? ' zpIsEditing' : ' zpNotEditing');
		this.emptyMark.className = Zapatec.Form.IGNORE_CLASSNAME + (isEmpty ? ' zpIsEmpty' : ' zpNotEmpty');
		this.validMark.className = Zapatec.Form.IGNORE_CLASSNAME + (!status ? ' zpIsValid' : ' zpNotValid');

		// if field is empty but it is editing in this time - do not display
		// "this field is required" message.
		if(
			( // do not display error if field is required and it is empty during editing.
				isRequired && 
				isEmpty && 
				this.isEditing 
			) ||
			( // do not display error while typing if displayErrorWhileTyping is false
				this.isEditing && 
				!this.config.formConfig.displayErrorWhileTyping
			)
		){
			if(
				!(
					this.config.formConfig.showErrors == 'tooltip' && 
					Zapatec.Tooltip
				) && 
				!this.isBooleanField
			){
				status = null;
			}
		}

		// Error status text handling.
		if(!status){
			if(typeof(this.config.formConfig.showErrors) == 'function'){
				this.config.formConfig.showErrors(this.field);
			} else if(this.tooltip){
				this.tooltip.hide();
			} else if(this.errorText){
				this.errorText.style.display = "none";
			}
		} else if(status) {
			if (
				this.config.formConfig.showErrors == 'beforeField' ||
				this.config.formConfig.showErrors == 'afterField' ||
				this.config.formConfig.showErrors == 'last'
			){
				this.errorText.style.display = "";
				this.errorText.innerHTML = status;
			} else if(typeof(this.config.formConfig.showErrors) == 'function'){
				this.config.formConfig.showErrors(this.field, status);
			} else if(this.config.formConfig.showErrors == 'tooltip' && Zapatec.Tooltip){
				// Create a tooltip on the img.
				if (!this.tooltip) {
					this.tooltip = new Zapatec.Tooltip({
						target: this.requiredMark, 
						content: status,
						parent: this.form.container
					});
				}
				
				this.tooltip.setContent(status);
				
				if(this.isEditing){
					var offs = Zapatec.Utils.getElementOffset(this.requiredMark);
					this.tooltip.show(offs.left, offs.top + offs.height);
				} else {
					this.tooltip.hide();
				}
			} else {
				// Use default browser tooltip
				this.statusImg.title = status;
			}
		}
	}
};

/**
 * @private
 * Check if field is empty
 * @return true, if field is empty(for zpFormMask fields field is empty -
 * only if user don't enter any symbol to it)
 * @type boolean
 */
Zapatec.Form.Field.prototype.isEmpty = function(){
	if(!this.hasFeature("zpFormMask")){
		if(this.isBooleanField){
			if(this.field.checked){
				return false;
			}

			for(var ii = this.otherFields.length - 1; ii >= 0; ii--){
				var element = this.otherFields[ii];
				 
				if(element.checked){
					return false;
				}
			}

			return true;
		} else {
			var currVal = this.getValue();
			return (currVal == null || currVal.length == 0);
		}
	} else {
		for(ii = 0; ii < this.enteredValue.length; ii++){
			if(typeof(this.chars[ii]) != 'string' && this.enteredValue[ii] != null){
				return false;
			}
		}

		return true;
	}
};

/**
 * @private
 * Check if at least one character is entered
 * @return true, if at least one character is entered
 * @type boolean
 */
Zapatec.Form.Field.prototype.isFilled = function(){
	if(this.hasFeature("zpFormMask")){
		for(ii = 0; ii < this.enteredValue.length; ii++){
			if(typeof(this.chars[ii]) != 'string' && this.enteredValue[ii] != null){
				return true;
			}
		}

		return false;
	} else {
		var currVal = this.getValue();
		return (currVal != null && currVal.length > 0);
	}
};

/**
 * @private
 * Checks if mask is fully entered
 * @return true if mask is fully filled 
 * @type boolean
 */
Zapatec.Form.Field.prototype.isMaskFullyFilled = function(){
	if(this.hasFeature("zpFormMask")){
		for(ii = 0; ii < this.enteredValue.length; ii++){
			if(typeof(this.chars[ii]) != 'string' && this.enteredValue[ii] == null){
				return false;
			}
		}

		return true;
	} else {
		return this.isFilled();
	}
};

/**
 * @private
 * Checks if field has given feature.
 * @param feature - [string] feature name
 * @return true if field has given feature
 * @type boolean
 */
Zapatec.Form.Field.prototype.hasFeature = function(feature){
	if(
		!feature ||
		typeof(this.features[feature]) == 'undefined'
	){
		return false;
	}

	return true;
};

/**
 * @private
 * Returns value for given feature name
 * @param feature - [string] feature name
 * @return value for given feature name
 * @type String
 */
Zapatec.Form.Field.prototype.getFeature = function(feature){
	return this.features[feature];
};

/**
 * @private
 * Set value for given feature name
 * @param feature - [string] feature name
 * @param value {Object} Value to set
 */
Zapatec.Form.Field.prototype.setFeature = function(feature, value){
	this.features[feature] = value;
};

Zapatec.Form.Field.prototype.isRequired = function(){
	var isRequired = this.getFeature("zpFormRequired");

	// TODO provide zpFormRequiredWhen functionality here
	return isRequired;
}

/*
 * @private
 * zpFormMask related function.
 * Get position of next unfilled character in a mask..
 * @return position of next unfilled mask char into mask. Returns null if such
 *	character not found.
 * @type int
 */
Zapatec.Form.Field.prototype.getNextAvailablePosition = function(pos){
	if(pos + 1 >= this.enteredValue.length){
		return null;
	}

	if(typeof(this.chars[pos + 1]) == 'string'){
		return this.getNextAvailablePosition(pos + 1);
	}

	return pos + 1;
};

/**
 * @private
 * zpFormMask related function.
 * Get position of next unfilled character in a mask.
 * @return position of previous unfilled mask char into mask. Returns null if 
 *	such character not found.
 */
Zapatec.Form.Field.prototype.getPrevAvailablePosition = function(pos){
	if(pos - 1 < 0){
		return null;
	}

	if(typeof(this.chars[pos - 1]) == 'string'){
		return this.getPrevAvailablePosition(pos - 1);
	}

	return pos - 1;
};

/**
 * @private
 * zpFormMask related function.
 * Set selection inside INPUT element
 * @param startPos {int} start of selection(required).
 * @param endPos {int} end of selection(nonrequired. equal to startPos by default)
 */
Zapatec.Form.Field.prototype.setCaretPosition = function(startPos, endPos){
	var valLength = this.getValue().length;

	if(!this.isSelectionAppliable() || !this.isEditing){
		return null;
	}

	if(isNaN(parseInt(startPos))){
		return false;
	} else {
		startPos = parseInt(startPos);

		if(startPos < 0){
			startPos = 0;
		} else if(startPos > valLength){
			startPos = valLength;
		}
	}

	if(endPos == null || isNaN(parseInt(endPos)) || parseInt(endPos) < startPos){
		endPos = startPos;
	} else {
		endPos = parseInt(endPos);

		if(endPos < 0){
			endPos = 0;
		} else if(endPos > valLength){
			endPos = valLength;
		}
	}
	try{
		if(typeof(this.field.createTextRange) == "object"){
			var range = this.field.createTextRange();
			range.moveEnd("character", endPos - this.getValue().length);
			range.moveStart("character", startPos);
			range.select();
	        
			return true;
		} else if (typeof(this.field.setSelectionRange) == 'function'){
			// mozilla, opera, safari
			this.field.setSelectionRange(startPos, endPos);
	        
			return true;
		}
	} catch(e){}
	return false;
};

/**
 * @private
 * zpFormMask related function.
 * Get start position of selection in INPUT element.
 * @return start position of selection in INPUT element.
 * @type int
 */
Zapatec.Form.Field.prototype.getSelectionStart = function(){
	if(this.field.disabled || !this.isSelectionAppliable() || !this.isEditing){
		return 0;
	}

	try{
		if (document.selection) {
			// IE black magic
			return Math.abs(
				document.selection.createRange().moveStart("character", -1000000)
			);
		} else if (typeof(this.field.selectionStart) != "undefined"){
			// mozilla and opera
			var selStart = this.field.selectionStart;
		
			// Safari bug when field is focused for first time
			if(selStart == 2147483647){
				selStart = 0;
			}
	        
			return selStart;
		}
	} catch(e){}
	
	return 0;
};

/**
 * @private
 * zpFormMask related function.
 * Get end position of selection in INPUT element.
 * @return end position of selection in INPUT element.
 * @type int
 */
Zapatec.Form.Field.prototype.getSelectionEnd = function(){
	if(this.field.disabled || !this.isSelectionAppliable() || !this.isEditing){
		return 0;
	}

	try{
		if (document.selection) {
			// IE black magic
			return this.field.value.length - Math.abs(
				document.selection.createRange().moveEnd("character", 1000000)
			);
		} else if (typeof(this.field.selectionEnd) != "undefined") {
			// mozilla and opera
			return this.field.selectionEnd;
		}
	} catch(e){} 

	return 0;
};

/**
 * @private
 * zpFormMask related function.
 * Processes backspace and delete keys.
 * @param charCode {int} code of the key that was pressed.
 */
Zapatec.Form.Field.prototype.processCustomKeys = function(charCode){
	var selStart = this.getSelectionStart();
	var selEnd = this.getSelectionEnd();

	if(selStart == selEnd){
		if(charCode == 8){ // backspace
			var newPos = this.getPrevAvailablePosition(selStart);

			if(newPos == null || newPos == selStart){
				return false;
			}

			this.enteredValue[newPos] = null;
			this.setValue();

			this.setCaretPosition(newPos + (Zapatec.is_opera ? 1 : 0));

			return false;
		}

		if(charCode == 46){ // delete
			if(typeof(this.chars[selStart]) == 'string'){
				return false;
			}

			this.enteredValue[selStart] = null;
			this.setValue();
			this.setCaretPosition(selStart)

			return false;
		}
	} else {
		if(charCode == 8 || charCode == 46){ // backspace
			for(var ii = selStart; ii < selEnd; ii++){
				if(typeof(this.chars[ii]) != 'string'){
					this.enteredValue[ii] = null;
				}
			}

			this.setValue();
			this.setCaretPosition(selStart + (Zapatec.is_opera ? 1 : 0));

			return false;
		}
	}

	return true;
};

/**
 * @private
 * zpFormMask related function.
 * Custom processing for alt, ctrl and shift keys
 * @param {Event} event object
 */
Zapatec.Form.Field.prototype.processFunctionalKeys = function(evt){
	var tmpArr = Zapatec.Utils.getCharFromEvent(evt)

	var charCode = tmpArr.charCode;
	var newChar = tmpArr.chr;

	if(evt.ctrlKey || (typeof(evt.metaKey) != 'undefined' && evt.metaKey)){
		// custom processing of ctrl+backspace and ctrl+delete shortcuts
		if(charCode == 8){
			// backspace
			this.setCaretPosition(0, this.getSelectionStart());

			return false;
		} else if(charCode == 46){
			// delete
			this.setCaretPosition(this.getSelectionStart(), this.getValue().length);

			return false;
		} else if(newChar == 'v' || newChar == 'V'){
			this.setValueFromField();

			return true;
		}

		return true;
	} else if(evt.shiftKey){
		if(charCode == 37 || charCode == 39){ // left/right arrow
			return true;
		} else if(charCode == 45){ // insert
			this.setValueFromField();
			return true;
		}
	} else if(evt.altKey){
		return true;
	}

	return false;
};

/**
 * @private
 * zpFormMask related function.
 * Sets field value and value of INPUT element(this captures paste into field).
 * @param runImmediately {boolean} If false - wait 1ms before execution. 
 *	Sometimes this is needed when you want to be sure that last keystrokes are
 *	recorded into field value.
 */
Zapatec.Form.Field.prototype.setValueFromField = function(runImmediately){
	if(!runImmediately){
		var self = this;
	
		setTimeout(
			function(){
				self.setValueFromField(true);
			},
		1);

		return;
	}

	var selStart = this.getSelectionStart();
	var selEnd = this.getSelectionEnd();

	var editMode = this.isEditing;
	this.isEditing = true;
	this.setValue(Zapatec.Form.Utils.getValue(this.field));

	if(this.isBooleanField){
		this.booleanChanged();
	}

	this.isEditing = editMode;

	this.validate();

	if(!this.isEditing){
		this.blur();
	} else {
		this.setCaretPosition(selStart, selEnd);
	}
};

/**
 * @private
 * Get value of current field.
 * @return value of current field.
 * @type String
 */
Zapatec.Form.Field.prototype.getValue = function(){
	return Zapatec.Form.Utils.getValue(this.field);
}

/**
 * @private
 * Sets value of current field
 * @param value [String] value to set
 * @return Value that was written into field.
 * @type String
 */
Zapatec.Form.Field.prototype.setValue = function(value){
	if(value == null){
		value = "";
	}

	// remove invalid characters from the value
	if (this.hasFeature('zpFormAllowedChars')){
		var notallowed = new RegExp('[^' + this.getFeature('zpFormAllowedChars') + ']', 'g');
		value = value.replace(notallowed, "");
	}

	// if field has zpFormMask mark - this is special case
	if(this.hasFeature('zpFormMask')){
		var val = "";

		if(this.isEditing || this.isFilled()){
			for(ii = 0; ii < this.chars.length; ii++){
				if(ii < value.length){
					// if value is given - fill this.enteredValue with it.
					if(typeof(this.chars[ii]) != "string"){
						if(this.chars[ii].test(value.charAt(ii))){
							this.enteredValue[ii] = value.charAt(ii);
							val += value.charAt(ii);
						} else {
							this.enteredValue[ii] = null;
							if (this.config.formConfig.maskPlaceholder) {
								val += this.config.formConfig.maskPlaceholder;
							}
						}
					} else {
						this.enteredValue[ii] = this.chars[ii];
						val += this.chars[ii];
					}
				} else if(arguments.length > 0){
					// if value were given - clear rest of the characters
					if(typeof(this.chars[ii]) == 'string'){
						val += this.chars[ii];
					} else {
						this.enteredValue[ii] = null;
						if (this.config.formConfig.maskPlaceholder) {
							val += this.config.formConfig.maskPlaceholder;
						}
					}
				} else {
					// if no value were given - then form masked value from internal arrays
					if(typeof(this.chars[ii]) == 'string'){
						val += this.chars[ii];
					} else {
						var tempHolderString;
						if (this.config.formConfig.maskPlaceholder) {
							tempHolderString = this.config.formConfig.maskPlaceholder;
						} else {
							tempHolderString = "";
						}
						val += this.enteredValue[ii] == null ? tempHolderString : this.enteredValue[ii];
					}
				}
			}
		}

		value = val;
	}

	// For textarea - we must restore scrolling position in textarea.
	var oldScrollTop = null;
	var oldScrollLeft = null;

	if(
		this.field.nodeName.toLowerCase() == 'textarea' &&
		typeof(this.field.scrollTop) != 'undefined'
	){
		oldScrollTop = this.field.scrollTop;
		oldScrollLeft = this.field.scrollLeft;
	}

	var retVal = Zapatec.Form.Utils.setValue(this.field, value);

	if(this.field.nodeName.toLowerCase() == 'textarea' && oldScrollTop != null){
		this.field.scrollTop = oldScrollTop;
		this.field.scrollLeft = oldScrollLeft;
	}

	return retVal;
};

/**
 * @private
 * This method processes delayed actions - usually this actions are
 * executed when user finished typing in the field.
 */
Zapatec.Form.Field.prototype.runDelayedActions = function(){
	this.keyPressCounter--;

	if(this.keyPressCounter != 0){
		return null;
	}

	this.ajaxValidate();
	this.suggestValue();
	this.ajaxFill();
};

/**
 * @private
 * Validate field value using AJAX. Response must be in format:
 * {
 *	"success": true | false,
 *	"generalError": "Human readable error description"
 * }
 */
Zapatec.Form.Field.prototype.ajaxValidate = function(){
	// processing zpFormValidate feature
	if(!this.hasFeature("zpFormValidate")){
		return null;
	}

	var valid = this.validate();

	if(!(
			valid == null || // if field has no client-side errors
			valid != null &&
			(
				valid.length == 0 ||
				valid.length == 1 && // or has only one error, but it is error from this validator
				valid[0].validator == "zpFormValidate"
			)
		)
	){
		return null;
	}

	var submitUrl = this.getFeature("zpFormValidate");
	var submitMethod = this.getFeature("zpFormValidateMethod");
	var submitParam = this.getFeature("zpFormValidateParam");
	var submitQuery = this.getFeature("zpFormValidateQuery");

	// method by default is GET
	if(typeof(submitMethod) != 'string'){
		submitMethod = "GET"
	}

	// URL param name by default is equal to the field name
	if(typeof(submitParam) != 'string'){
		submitParam = this.field.name;
	}

	if(typeof(submitQuery) != 'string'){
		submitQuery = "";
	}

	submitQuery += "&" + encodeURIComponent(submitParam) + "=" + encodeURIComponent(this.getValue());

	if(submitUrl.indexOf("?") < 0){
		submitUrl += "?";
	}

	submitUrl += "&" + Math.random();

	if(submitMethod == 'GET'){
		submitUrl += "&" + submitQuery;
	}

	this.fetchingMark.className = "zpIsFetching " + Zapatec.Form.IGNORE_CLASSNAME;

	var self = this;

	if(this.config.formConfig.ajaxDebugFunc){
		this.config.formConfig.ajaxDebugFunc(this.getMessage('ajaxDebugSeparator'));
		this.config.formConfig.ajaxDebugFunc(this.getMessage('ajaxDebugValidateTitle', this.field.name));
		this.config.formConfig.ajaxDebugFunc(submitMethod + " " + submitUrl);
		this.config.formConfig.ajaxDebugFunc(this.getMessage('ajaxDebugQuery', ("GET" ? "" : submitQuery)));
	}

	Zapatec.Transport.fetch({
		url: submitUrl,
		content: submitMethod == "GET" ? null : submitQuery,
		method: submitMethod,
		onLoad: function(objText){
			if(self.config.formConfig.ajaxDebugFunc){
				self.config.formConfig.ajaxDebugFunc(self.getMessage('ajaxDebugResponse', objText.responseText));
			}

			self.fetchingMark.className = Zapatec.Form.IGNORE_CLASSNAME + "zpNotFetching";

			if (objText.responseText == null) {
				Zapatec.Log({description: self.getMessage('ajaxValidateNoResponseError', objText.responseText)});
				return null;
			}

			var objResponse = Zapatec.Transport.parseJson({strJson: objText.responseText});

			if(objResponse == null){
				Zapatec.Log({description: self.getMessage('ajaxValidateCantParseError', objText.responseText)});
				return null;
			}

			if(!objResponse.success){
				self.ajaxError = typeof(objResponse.generalError) != 'string' ||
					objResponse.generalError.length == 0 ?
						self.getMessage('ajaxValidateValidationError') : 
						objResponse.generalError;
			} else {
				self.ajaxError = null;
			}

			self.validate();
		},
		onError : function(objError){
			var strError = '';

			if (objError.errorCode) {
				strError += objError.errorCode + ' ';
			}

			strError += objError.errorDescription;

			self.fetchingMark.className = Zapatec.Form.IGNORE_CLASSNAME + " zpNotFetching";
			alert(strError);
			self.ajaxError = null;

			if(self.config.formConfig.ajaxDebugFunc){
				self.config.formConfig.ajaxDebugFunc(self.getMessage('ajaxDebugResponseError', strError));
			}
		}
	});
};

/**
 * @private
 * Fill this field (and any other) using AJAX. Response must be in format:
 * {
 *	TODO
 * }
 */
Zapatec.Form.Field.prototype.ajaxFill = function(){
	// processing zpFormValidate feature
	if(!this.hasFeature("zpFormFillUrl")){
		return null;
	}

	var submitUrl = this.getFeature("zpFormFillUrl");
	var submitMethod = this.getFeature("zpFormFillMethod");
	var submitParam = this.getFeature("zpFormFillParam");
	var submitQuery = this.getFeature("zpFormFillQuery");

	// method by default is GET
	if(typeof(submitMethod) != 'string'){
		submitMethod = "GET";
	}

	// URL param name by default is equal to the field name
	if(typeof(submitParam) != 'string'){
		submitParam = this.field.name;
	}

	if(typeof(submitQuery) != 'string'){
		submitQuery = "";
	}

	submitQuery += "&" + encodeURIComponent(submitParam) + "=" + encodeURIComponent(this.getValue());

	if(submitUrl.indexOf("?") < 0){
		submitUrl += "?";
	}

	submitUrl += "&" + Math.random();

	if(submitMethod == 'GET'){
		submitUrl += "&" + submitQuery;
	}

	this.fetchingMark.className = "zpIsFetching " + Zapatec.Form.IGNORE_CLASSNAME;

	var self = this;

	if(this.config.formConfig.ajaxDebugFunc){
		this.config.formConfig.ajaxDebugFunc(this.getMessage('ajaxDebugSeparator'));
		this.config.formConfig.ajaxDebugFunc(this.getMessage('ajaxDebugFillTitle', this.field.name));
		this.config.formConfig.ajaxDebugFunc(submitMethod + " " + submitUrl);
		this.config.formConfig.ajaxDebugFunc(this.getMessage('ajaxDebugQuery', ("GET" ? "" : submitQuery)));
	}
	
	Zapatec.Transport.fetch({
		url: submitUrl,
		content: submitMethod == "GET" ? null : submitQuery,
		method: submitMethod,
		onLoad: function(objText){
			if(self.config.formConfig.ajaxDebugFunc){
				self.config.formConfig.ajaxDebugFunc(self.getMessage('ajaxDebugResponse', objText.responseText));
			}

			self.fetchingMark.className = Zapatec.Form.IGNORE_CLASSNAME + " zpNotFetching";

			if (objText.responseText == null) {
				Zapatec.Log({description: self.getMessage('ajaxFillNoResponseError', objText.responseText)});
				return null;
			}

			var objResponse = Zapatec.Transport.parseJson({strJson: objText.responseText});

			if(objResponse == null){
				Zapatec.Log({description: self.getMessage('ajaxFillCantParseError', objText.responseText)});
				return null;
			}

			if(!objResponse.success){
				self.ajaxError = typeof(objResponse.generalError) != 'string' ||
					objResponse.generalError.length == 0 ?
						self.getMessage('ajaxFillGeneralError') : 
						objResponse.generalError
				;
			} else {
				self.ajaxError = null;

				var formObject = self.form;
				var fillData = objResponse.fillData;
	    
				if (fillData.length == 0) {
					return null;
				} else {
					var fields = fillData[0];
					
					for (var ii = 0; ii < fields.length; ii++) {
						var field = formObject.container.elements[fields[ii]['fieldName']];
						
						if(!field){
							continue;
						}

						Zapatec.Form.Utils.setValue(field, fields[ii]['fieldValue']);
	    
						if(field.zpFormField){
							field.zpFormField.setValueFromField(true);
						}
					}
				}
			}

			self.validate();
		},
		onError : function(objError){
			var strError = '';

			if (objError.errorCode) {
				strError += objError.errorCode + ' ';
			}

			strError += objError.errorDescription;

			self.fetchingMark.className = Zapatec.Form.IGNORE_CLASSNAME + " zpNotFetching";
			alert(strError);
			self.ajaxError = null;

			if(self.config.formConfig.ajaxDebugFunc){
				self.config.formConfig.ajaxDebugFunc(self.getMessage('ajaxDebugResponseError', strError));
			}
		}
	});
};

/**
 * @private
 * Provide suggestions for current field value.
 * @param showAll {boolean} if true - no current field value will be sent to 
 *	server so it must send all possible values.
 *	{
 *		"success" : true, //true/false - if request processed successfully.
 *		"generalError": "Human readable error description" // if success == false
 *		"header": [ // table header description. Optional.
 *			{
 *				name: "Col name1", // text to display in column header
 *				style: "color: blue", // apply this style to this header
 *				colStyle: "color: blue" // apply this style to each cell in this row
 *			},
 *			{
 *				name: "Col name2", // text to display in column header
 *				className: "custom", // add this class to this header
 *				colClassName: "customCol" // add this class to each cell in this row
 *			}
 *		],
 *		"body": [ // array of data to display in rows
 *			["str1, col1", "str1, col2"],
 *			...
 *		]
 *	}
 */
Zapatec.Form.Field.prototype.suggestValue = function(showAll){
	if(
		!this.hasFeature("zpFormSuggest") ||
		!showAll &&
		this.isEmpty()
	){
		return null;
	}

	var suggestUrl = this.getFeature("zpFormSuggest");
	var suggestMethod = this.getFeature("zpFormSuggestMethod");
	var suggestParam = this.getFeature("zpFormSuggestParam");
	var suggestQuery = this.getFeature("zpFormSuggestQuery");

	// method by default is GET
	if(typeof(suggestMethod) != 'string'){
		suggestMethod = "GET";
	}

	// URL param name by default is equal to the field name
	if(typeof(suggestParam) != 'string'){
		suggestParam = this.field.name;
	}

	if(typeof(suggestQuery) != 'string'){
		suggestQuery = "";
	}

	suggestQuery += "&" + encodeURIComponent(suggestParam) + "=" + (showAll ? "" : encodeURIComponent(this.getValue()));

	if(suggestUrl.indexOf("?") < 0){
		suggestUrl += "?";
	}

	suggestUrl += "&" + Math.random();

	if(suggestMethod == 'GET'){
		suggestUrl += "&" + suggestQuery;
	}

	this.fetchingMark.className = "zpIsFetching " + Zapatec.Form.IGNORE_CLASSNAME;

	var self = this;


	if(this.config.formConfig.ajaxDebugFunc){
		this.config.formConfig.ajaxDebugFunc(this.getMessage('ajaxDebugSeparator'));
		this.config.formConfig.ajaxDebugFunc(this.getMessage('ajaxDebugSuggestTitle', this.field.name));
		this.config.formConfig.ajaxDebugFunc(suggestMethod + " " + suggestUrl);
		this.config.formConfig.ajaxDebugFunc(this.getMessage('ajaxDebugQuery', ("GET" ? "" : suggestQuery)));
	}

	Zapatec.Transport.fetch({
		url: suggestUrl,
		content: suggestMethod == "GET" ? null : suggestQuery,
		method: suggestMethod,
		onLoad: function(objText){
			if(self.config.formConfig.ajaxDebugFunc){
				self.config.formConfig.ajaxDebugFunc(self.getMessage('ajaxDebugResponse', objText.responseText));
			}

			self.fetchingMark.className = Zapatec.Form.IGNORE_CLASSNAME + " zpNotFetching";

			if (objText.responseText == null) {
				Zapatec.Log({description: self.getMessage('ajaxSuggestNoResponseError', objText.responseText)});
				return null;
			}

			var objResponse = Zapatec.Transport.parseJson({strJson: objText.responseText});

			if(objResponse == null){
				Zapatec.Log({description: self.getMessage('ajaxSuggestCantParseError', objText.responseText)});
				return null;
			}

			if(!objResponse.success){
				alert(typeof(objResponse.generalError) != 'string' ||
					objResponse.generalError.length == 0 ?
						self.getMessage('ajaxSuggestGeneralError') : 
						objResponse.generalError
				);
			} else {
				self.autoCompleteValue(objResponse);
			}

			self.validate();
		},
		onError : function(objError){
			var strError = '';

			if (objError.errorCode) {
				strError += objError.errorCode + ' ';
			}

			strError += objError.errorDescription;

			self.fetchingMark.className = Zapatec.Form.IGNORE_CLASSNAME + " zpNotFetching";
			Zapatec.Log({description: strError});

			if(self.config.formConfig.ajaxDebugFunc){
				self.config.formConfig.ajaxDebugFunc(self.getMessage('ajaxDebugResponseError', strError));
			}
		}
	});
};

/**
 * @private
 * Returns array of values to autocomplete current field value
 * @param showAll {boolean} if true - no current field value will be
 * used to filter available options.
 * @return array of values to autocomplete current field value;
 * @type Array
 */
Zapatec.Form.Field.prototype.getAutoCompleteOptions = function(showAll){
	var opts = {body: []};
	var currVal = this.getValue();

	if(
		this.hasFeature("zpFormAutoComplete") ||
		this.hasFeature("zpFormAutoCompleteStrict")
	){
		for(var ii = 0; ii < this.autoCompleteOptions.length; ii++){
			if(
				(this.hasFeature("zpFormAutoCompleteStrict") ? 
					this.autoCompleteOptions[ii].substring(0, currVal.length) : 
					this.autoCompleteOptions[ii].substring(0, currVal.length).toLowerCase()) ==
					(this.hasFeature("zpFormAutoCompleteStrict") ? 
						currVal : currVal.toLowerCase()
					) ||
				showAll
			){
				opts.body.push([this.autoCompleteOptions[ii]]);
			}
		}
	}

	return opts;
};

/**
 * @private
 * Autocomplete field value with given value and display dropdown list of 
 * other available values.
 * @param opts {Object} array of values to display.
 */
Zapatec.Form.Field.prototype.autoCompleteValue = function(opts){
	if(
		typeof(opts) == 'undefined' ||
		opts.body == null ||
		opts.body.length == 0 ||
		(
			opts.body.length == 1 &&
			opts.body[0][0] == ""
		)
	){
	    if(this.dropDown){
			this.dropDown.config.source = {tips: []};
			this.dropDown.loadData();
			this.dropDown.hide();
	    }
		
		return;
	}

	var currValue = this.getValue();
	var retrValue = null;

	var firstValue = opts.body[0][0];

	if(firstValue.substring(0, currValue.length).toLowerCase() == currValue.toLowerCase()){
		retrValue = firstValue.substring(currValue.length);
		this.setValue(currValue + retrValue);
		this.setCaretPosition(currValue.length, this.getValue().length);
	}

	this.validate();


	if(this.dropDown){
		if(opts.body.length == 1){
			this.dropDown.config.source = {tips: []};
			this.dropDown.loadData();
			this.dropDown.hide();
		} else {
			this.dropDown.config.sourceType = "json";
            
			var tips = [];
	    
			for(var ii = 0; ii < opts.body.length; ii++){
				var option = opts.body[ii];
				var tmp = {};
				
				tmp.title = option.join(" ");
				
				tips.push(tmp);
			}
        
			this.dropDown.config.source = {tips: tips};
			this.dropDown.loadData();
			this.dropDown.show();
		}
	}
};

Zapatec.Form.Field.prototype.isSelectionAppliable = function(){
	var nodeName = this.field.nodeName.toLowerCase();
	var inputType = nodeName == 'input' ? this.field.type.toLowerCase() : null;

	return (
		nodeName == "body" || 
		nodeName == "button" ||
		nodeName === "textarea" ||
		nodeName == "input" && (
			inputType == "button" ||
			inputType == "hidden" ||
			inputType == "password" ||
			inputType == "reset" ||
			inputType == "submit" ||
			inputType == "text"
		)
 	)
};

Zapatec.Form.Field.prototype.destroy = function(){
	this.discard();
};
