/* $Id: builder.js 15736 2009-02-06 15:29:25Z nikolai $ */
/**
 * @fileoverview Zapatec form builder
 *
 *
 * <pre>
 * Copyright (c) 2004-2009 by Zapatec, Inc.
 * http://www.zapatec.com
 * 1700 MLK Way, Berkeley, California,
 * 94709, U.S.A.
 * All rights reserved.
 * </pre>
 */

/**
 * Zapatec form builder
 *
 * @constructor
 * @extends Zapatec.Widget
 * @param {object} objArgs User configuration
 */
Zapatec.FormBuilder = function(objArgs) {
  // Call constructor of superclass
  Zapatec.FormBuilder.SUPERconstructor.call(this, objArgs);
};

/**
 * Unique static id of the widget class. 
 * @private
 */
Zapatec.FormBuilder.id = 'Zapatec.FormBuilder';

// Inherit Widget
Zapatec.inherit(Zapatec.FormBuilder, Zapatec.Widget);

/**
 * Initializes object.
 *
 * @param {object} objArgs User configuration
 */
Zapatec.FormBuilder.prototype.init = function(objArgs) {
	if(!Zapatec.Window){
		Zapatec.Log({description: "Zapatec.Window module is not found. Form builder functionality will be limited."})
	}

	// Call init method of superclass
	Zapatec.FormBuilder.SUPERclass.init.call(this, objArgs);
	
	this.tabs = null;
	this.formObj = null;
	this.formPath = "/path/to/zapatec/";
	this.formConfig = {form: "zpForm"};
	this.activeField = null;
	this.fields = {};
	this.fieldsOrder = [];
	
	this.designPreviewContainer = document.getElementById("designPreview");
	
//	Zapatec.Utils.warnUnload('All your changes and form structure will be lost.');
};

/**
 * Start form builder.
 * @private
 */
Zapatec.FormBuilder.prototype.start = function(){
	var self = this;

	this.initComposer();

	this.tabs = new Zapatec.Tabs({
		tabs: 'tabs',
		tabBar: 'tab-bar',
		changeUrl: false,
		theme:'demoex',
		onBeforeTabChange: function(dataObj) {
			var currentTab = dataObj.oldTabId;
			var newTab = dataObj.newTabId;
			
			switch(currentTab){
				case "pane-prefs":
					self.updateConfig();
					break;
			}
			
			switch(newTab){
				case "pane-contents":
					self.doPreview();
					break;
				case "pane-code":
					self.makeCode();
					break;
			}
	
			// allow tab to change
			return true;
		}
	});

    if(!Zapatec.Tooltip){
		Zapatec.Log({description: "Zapatec.Tooltip is not found!"});
	} else {
		Zapatec.Tooltip.setupFromDFN();
	}

	this.doPreview();
	
	// FIXME Remove after
	this.addField("input-text");
	this.addField("input-text");
	var sel = this.addField("select");

	sel.fieldConfig.options = [
		{
			title: "first",
			value: "1"
		},
		{
			title: "second",
			value: "2"
		},
		{
			title: "third",
			value: "3"
		},
		{
			title: "fourth",
			value: "4"
		}
	];
	
	this.doPreview();
};

/**
 * Reconfigures the widget with new config options after it was initialized.
 * May be used to change look or behavior of the widget after it has loaded
 * the data. In the argument pass only values for changed config options.
 * There is no need to pass config options that were not changed.
 *
 * @param {object} objArgs Changes to user configuration
 */
Zapatec.FormBuilder.prototype.reconfigure = function(objArgs) {
	// Call parent method
	Zapatec.FormBuilder.SUPERclass.reconfigure.call(this, objArgs);
};

/**
 * Configures the widget. Gets called from init and reconfigure methods of
 * superclass.
 *
 * @private
 * @param {object} objArgs User configuration
 */
Zapatec.FormBuilder.prototype.configure = function(objArgs) {
	// Call parent method
	Zapatec.FormBuilder.SUPERclass.configure.call(this, objArgs);
};

/**
 * Inits the Zapatec.Composer with needed element and document.
 */
Zapatec.FormBuilder.prototype.initComposer = function() {
	var elements = Zapatec.Utils.getElementsByAttribute("className", "clickable", "pane-contents", true, true);
	var self = this;

	this.composer = new Zapatec.Composer({
		components : elements, 
		putCallback : function(el, nextEl) {
			var elType = el.id;
			if (elType == "input-textarea" || elType == "input-select") {
				elType = elType.replace("input-", "");
			}
			return self.addField(elType, nextEl);
		}, 
		itemClassName : "elementHolder",
		highlightClass : "elementHighlight",
		selectedClass : "highlighted",
		hookClassName: "dragHandle"
	});
};
 
/**
 * 
 * Change config option for form. Depending on field name different config 
 * option will be set and dependant options will be shown/hided.
 * @private
 * @param {Object} optionName Option name
 * @param {Object} optionValue Option value
 */
Zapatec.FormBuilder.prototype.configOptionChanged = function(optionName, optionValue){
	// do different actions depending on field name.
	switch(optionName){
		case "form_path":
			if(!optionValue || optionValue == ""){
				optionValue = "/path/to/zapatec/";
			}
			
			// adding slash to the end if missing
			if(optionValue.charAt(optionValue.length - 1) != "/"){
				optionValue += "/";
			}
			
			this.formPath = optionValue;
			
			break;                      0
		case "language":
			// parsing "rus_ru-ko8r" string 
			var md = optionValue.match(/^([a-zA-Z\d]+)(?:_([a-zA-Z\d]+))?(?:-([a-zA-Z\d]+))?$/);

			if(md){
				this.formConfig["lang"] = md[1];
				this.formConfig["langCountryCode"] = md[2];
				this.formConfig["langEncoding"] = md[3];
			}

			break;
		case "startupFocusPosition":
		case "statusImgPos":
		case "showErrors":
			if(optionValue == ""){
				optionValue = null;
			}
		case "theme":
		case "strict":
		case "showErrorsOnSubmit":
		case "putTabIndexesOnError":
		case "displayErrorWhileTyping":
			this.formConfig[optionName] = optionValue;
			break;
		default:
			Zapatec.Log({description: "Unknown config option: " + optionName});
	}
};

/**
 * Refresh config hash.
 * @private
 */
Zapatec.FormBuilder.prototype.updateConfig = function(){
	// Iterate through all INPUT and SELECT elements and call their onchange handlers.
	// TODO do this in a nice way.
	var parent = document.getElementById("pane-prefs");
	var inputs = parent.getElementsByTagName("input"); 
	var selects = parent.getElementsByTagName("select"); 

	for(var ii = 0; ii < inputs.length; ii++){
		if(inputs[ii].onblur){
			inputs[ii].onblur();
		}
		
		if(inputs[ii].onchange){
			inputs[ii].onchange();
		}
	}

	for(var ii = 0; ii < selects.length; ii++){
		if(selects[ii].onchange){
			selects[ii].onchange();
		}
	}
};

/**
 * Add new field into form.
 * @param {String} fieldType Field type - "input-text", "input-radio", 
 * "input-checkbox", "select" or "textarea"
 * @param {Object} insertBeforeEl Optional. DOM element before which new field will be inserted. 
 */
Zapatec.FormBuilder.prototype.addField = function(fieldType, insertBeforeEl){
	var field = new Zapatec.FormBuilder.Field({
		builder: this,
		fieldType: fieldType,
		insertBeforeEl: insertBeforeEl
	});
	
	this.doPreview();
	
	return field;
}

Zapatec.FormBuilder.prototype.moveFieldTo = function(fieldId, insertBeforeId){
	this.fieldsOrder = Zapatec.Array.without(this.fieldsOrder, fieldId);

	if(insertBeforeId){
		this.fieldsOrder.splice(Zapatec.Array.indexOf(this.fieldsOrder, insertBeforeId), 0, fieldId);
	} else {
		this.fieldsOrder.push(fieldId);
	}
}

/**
 * Returns content for FORM element
 * @private
 * @param {boolean} addControls If true - some control elements will be added. 
 * To get code for resulting form - set this option to false.
 * @return Text content for FORM element.
 * @type String
 */
Zapatec.FormBuilder.prototype.constructFormHTML = function(addControls){
	var formContent = [];

	for(var ii = 0; ii < this.fieldsOrder.length; ii++){
		formContent.push(this.fields[this.fieldsOrder[ii]].getFieldFromConfig(addControls));
	}

	formContent.push('\t<div class="zpFormButtons">\n');
	formContent.push('\t\t<input value="Submit" name="submit" onclick="" type="submit" class="button">\n');
	formContent.push('\t\t<input value="Reset" name="reset" onclick="" type="reset" class="button">\n');
	formContent.push('\t</div>');
	
	return formContent.join("");
};

/**
 * Refresh form preview.
 * @private
 */
Zapatec.FormBuilder.prototype.doPreview = function(){
	if(this.readyForm){
		this.readyForm.destroy();
	}
	
	this.updateConfig();
	
	this.designPreviewContainer.innerHTML = "<form action='' method='GET' id='zpForm' onsubmit='return false;'></form>";
	
	var form = document.getElementById("zpForm");
	form.innerHTML = this.constructFormHTML(true);
	
	for(var fieldId in this.fields){
		this.fields[fieldId].updateLinks();
	}

	this.readyForm = new Zapatec.Form(this.formConfig);
	
	if(this.activeField){
		this.activeField.showControls();
	}

	this.composer.setDocument(this.readyForm.container);
};

/**
 * Set result code into "Get your code" textarea.
 * @private
 */
Zapatec.FormBuilder.prototype.makeCode = function(){
	document.getElementById("userCode").value = this.generateCode(true);
}

/**
 * Generate HTML page with form content, code and headers.
 * @param {Object} insertPathes If true - user path will be added to all form pathes.
 * @return HTML page with form content, code and headers.
 * @type String
 */
Zapatec.FormBuilder.prototype.generateCode = function(insertPathes){
	var self = this;
	
	if(!this.readyForm){
		this.doPreview();
	}
	
	var formConfig = "";

	var formConfigObj = Zapatec.Utils.clone(this.formConfig);
	
	if(insertPathes){
		formConfigObj.themePath = this.formPath + "zpform/themes/";
	}

	for(var opt in this.formConfig){
		if(!this.formConfig[opt]){
			continue;
		}
		
		formConfig += "\t" + opt + ": '" + this.formConfig[opt] + "',\n"; 
	}
	
	formConfig = formConfig.substring(0, formConfig.length - 2);

	var formContent = "<form action='your_script.html' method='GET' id='zpForm'>\n";
	formContent += this.constructFormHTML();
	formContent = formContent.substring(0, formContent.length - 1);
	formContent += "\n</form>";
	
	var langHeader = "";

	if(this.formConfig['lang'] != 'eng'){
		var langStr = this.formConfig['lang'];


		if(this.formConfig['langCountryCode'] && this.formConfig['langCountryCode'].length > 0){
			langStr += "_" + this.formConfig['langCountryCode']; 
		}

		if(this.formConfig['langEncoding'] && this.formConfig['langEncoding'].length > 0){
			langStr += "-" + this.formConfig['langEncoding']; 
		}
		
		
		langHeader = "\n\t<!-- Language file -->\n";
		langHeader += '\t<script src="'+ (insertPathes ? this.formPath : "") + 'zpform/lang/'+ langStr +'.js" type="text/javascript"></script>';

	}

	return Zapatec.FormBuilder.Utils.substitute(Zapatec.FormBuilder.TEMPLATE, {
		formPath: this.formPath,
		formText: formContent,
		formConfig: formConfig,
		formLang: langHeader
	});
};

Zapatec.FormBuilder.prototype.previewFormNewWindow = function(){
	Zapatec.Utils.newCenteredWindow("../wizard/popup.html", "FORMBUILDER", 500, 500, true);
};

Zapatec.FormBuilder.Utils = {};

/**
 * @private
 * Substiture parameters in template with real values
 * @param {Object} txt Template
 * @param {Object} args Hash with values
 * @return Template with substitutions
 * @type Object
 */
Zapatec.FormBuilder.Utils.substitute = function(txt, args){
	if(!txt){
		return null;
	}

	for(var opt in args){
		var escapedOpt = opt.replace(/\[/g, "\\[").replace(/\]/g, "\\]").replace(/\./g, "\\.");
		txt = txt.replace(new RegExp("\\$"+escapedOpt+"\\$", 'g'), args[opt]);
	}
	
	return txt;
};

Zapatec.FormBuilder.TEMPLATE = [
'<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/1999/REC-html401-19991224/loose.dtd">',
'<html>',
'<head>',
'	<title>AJAX forms by Zapatec</title>',
'	<!-- Adjust the paths to the form location on your server if necessary-->',
'',
'	<!-- Javascript utilities file-->',
'	<script src="$formPath$utils/zapatec.js" type="text/javascript"></script>',
'',
'	<!-- basic Javascript file for the form-->',
'	<script src="$formPath$zpform/src/form.js" type="text/javascript"></script>',
'$formLang$',
'</head>',
'<body>',
'<!-- The HTML for the form -->',
'$formText$',
'',
'<!-- The Javascript code to initiate the form -->',
'<script type="text/javascript">',
'new Zapatec.Form({',
'$formConfig$',
'},',
'</script>',
'<a href="http://www.zapatec.com/">AJAX forms</a> by Zapatec',
'</body>',
'</html>'
];
Zapatec.FormBuilder.TEMPLATE = Zapatec.FormBuilder.TEMPLATE.join('');
