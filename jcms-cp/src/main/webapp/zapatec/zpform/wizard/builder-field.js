/* $Id: builder-field.js 15736 2009-02-06 15:29:25Z nikolai $ */
/**
 * @fileoverview Zapatec form builder
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
Zapatec.FormBuilder.Field = function(objArgs) {
  // Call constructor of superclass
  Zapatec.FormBuilder.Field.SUPERconstructor.call(this, objArgs);
};

/**
 * Unique static id of the widget class. 
 * @private
 */
Zapatec.FormBuilder.Field.id = 'Zapatec.FormBuilder.Field';

// Inherit Widget
Zapatec.inherit(Zapatec.FormBuilder.Field, Zapatec.Widget);

/**
 * Initialize object.
 *
 * @param {object} objArgs User configuration
 */
Zapatec.FormBuilder.Field.prototype.init = function(objArgs) {
	// Call init method of superclass
	Zapatec.FormBuilder.Field.SUPERclass.init.call(this, objArgs);
	
	this.fieldConfig = {
		id: this.id,
		elementRef: null,
		inputElement: null,
		labelElement: null,
		type: this.config.fieldType,
		label:	"Double-click to edit label",
		name: "",
		attributes: {},
		features: {}
	};

	if(this.config.fieldType == 'select'){
		this.fieldConfig.options = [];
	}
	
	var containerEl = Zapatec.Utils.convertHTML2DOM(this.getFieldFromConfig(true));
	
	if(this.config.insertBeforeEl){
		var insertBeforeIndex = Zapatec.Array.indexOf(this.config.builder.fieldsOrder, this.config.insertBeforeEl.id.replace(/[^\d]*/g, "")); // TODO check this
		this.config.builder.fieldsOrder.splice(insertBeforeIndex, 0, this.id);
		this.config.insertBeforeEl.parentNode.insertBefore(containerEl, this.config.insertBeforeEl);
	} else {
		// add at form start
		this.config.builder.fieldsOrder.splice(0, 0, this.id);
		this.config.builder.readyForm.container.insertBefore(containerEl, this.config.builder.readyForm.container.firstChild);
	}

	this.config.builder.fields[this.id] = this;

	var self = this;
	
	this.editButton = new Zapatec.Button({
		image: "misc.gif",
		className: "editButton",
		clickAction: function(){
			self.showEditWindow();
		}
	});
	
	this.editButtonStatusContainer = this.editButton.statusContainer;
	this.editButtonInternalContainer = this.editButton.internalContainer;
	this.editButtonContent = this.editButton.internalContainer.firstChild;
	
	this.editInline = new Zapatec.EditInline({
		editAsText: true,
		eventListeners: {
			showStart: function(){
				this.activeField = self;
			},
			saveContent: function(content){
				if(this.activeField){
					this.activeField.fieldConfig.label = content;
				}
			}
		}
	});
	
	this.updateLinks();
	
	this.showControls();
};

/**
 * Reconfigures the widget with new config options after it was initialized.
 * May be used to change look or behavior of the widget after it has loaded
 * the data. In the argument pass only values for changed config options.
 * There is no need to pass config options that were not changed.
 *
 * @param {object} objArgs Changes to user configuration
 */
Zapatec.FormBuilder.Field.prototype.reconfigure = function(objArgs) {
	// Call parent method
	Zapatec.FormBuilder.Field.SUPERclass.reconfigure.call(this, objArgs);
};

/**
 * Configures the widget. Gets called from init and reconfigure methods of
 * superclass.
 *
 * @private
 * @param {object} objArgs User configuration
 */
Zapatec.FormBuilder.Field.prototype.configure = function(objArgs) {
	this.defineConfigOption('builder', null);
	this.defineConfigOption('fieldType', null);
	this.defineConfigOption('insertBeforeEl', null);
	// Call parent method
	Zapatec.FormBuilder.Field.SUPERclass.configure.call(this, objArgs);
};

/**
 * Update references inside internal config. This is needed before form is 
 * created using innerHTML and references to old elements are lost. 
 * @private
 */
Zapatec.FormBuilder.Field.prototype.updateLinks = function(){
	var containerEl = document.getElementById("fieldId-" + this.id);

	if(
		this.fieldConfig.type == "input-text" || 
		this.fieldConfig.type == "input-checkbox" || 
		this.fieldConfig.type == "input-radio"
	){
		this.fieldConfig.inputElement = containerEl.getElementsByTagName("input")[0];
	} else if(this.fieldConfig.type == "textarea"){
		this.fieldConfig.inputElement = containerEl.getElementsByTagName("textarea")[0];
	} else if(this.fieldConfig.type == "select"){
		this.fieldConfig.inputElement = containerEl.getElementsByTagName("select")[0];
	} else {
		alert("impossible");
	}
	
	this.fieldConfig.elementRef = containerEl;
	this.fieldConfig.labelElement = containerEl.getElementsByTagName("label")[0];

	if(this.editButton.container.childNodes.length == 0){
		this.editButtonInternalContainer.appendChild(this.editButtonContent);
		this.editButtonStatusContainer.appendChild(this.editButtonInternalContainer);
		this.editButton.container.appendChild(this.editButtonStatusContainer);
	}
	
	containerEl.appendChild(this.editButton.container);
}

Zapatec.FormBuilder.Field.prototype.confirmRemoveField = function(){
	var win1 = new Zapatec.ConfirmWindow(
		{
			message: "Are you sure you want to delete this field?", 
			title:"Confirm delete", 
			modal: true, 
			width :180, 
			theme : "winxp", 
			themePath: "../../zpwin/themes/", 
			top: "center", 
			left: "center"
		}
	);
	
	var self = this;
	
	win1.getResponse(function (res) {
		if (res == true){ 
			self.removeField();
		}
	}); 
}

/**
 * Destroy field with given ID 
 */
Zapatec.FormBuilder.Field.prototype.removeField = function(){
	Zapatec.Utils.destroy(this.fieldConfig.elementRef);
	this.config.builder.fieldsOrder = Zapatec.Array.without(this.config.builder.fieldsOrder, this.id);

	if(this.config.builder.activeField == this){
		this.config.builder.activeField = null;
	}
	
	if(this.editWindow){
		this.editWindow.close();
	}

	this.discard();
}


/**
 * Get HTML code to create new field from given config.
 * @private
 * @param {boolean} addControls If true - some control elements will be added. 
 * To get code for resulting form - set this option to false.
 * @return HTML code to create new form field from given config.
 * @type String
 */
Zapatec.FormBuilder.Field.prototype.getFieldFromConfig = function(addControls){
	var code = [];

	code.push("\t<div");

	if(addControls){
		code.push(" id='fieldId-");
		code.push(this.id);
		code.push("'");
		

		code.push(" class='elementHolder'");
		code.push(" onmouseover='Zapatec.Widget.callMethod(");
		code.push(this.id);
		code.push(", \"showControls\", this, ");
		code.push(this.id);
		code.push(");'");
	}

	code.push(">\n");

	if(addControls){
		code.push("<div class='dragHandle' title='Drag and drop me to put this field to the other place'></div>");
	}

	if(this.fieldConfig.type != "input-checkbox" && this.fieldConfig.type != "input-radio"){
		code.push("\t\t<label class=''");
		
		if(addControls){
			code.push(" ondblclick='Zapatec.Widget.getWidgetById(");
			code.push(this.id);
			code.push(").editInline.show(this)'");
		}
		
		code.push(">"+ this.fieldConfig.label +"</label>\n"); // TODO add zpFormLabel
	}
	
	code.push("\t\t<");
	
	switch(this.fieldConfig.type){
		case "input-text":
			code.push("input type='text'");
			break;
		case "input-checkbox":
			code.push("input type='checkbox'");
			break;
		case "input-radio":
			code.push("input type='radio'");
			break;
		case "textarea":
			code.push("textarea");
			break;
		case "select":
			code.push("select");
			break;
	}
	
	for(var attr in this.fieldConfig.attributes){
		if(
			!this.fieldConfig.attributes[attr] ||
			attr == "name" ||
			attr == "class"
		){
			continue;
		}
		
		code.push(" ");
		code.push(attr);
		code.push("='");
		code.push(this.fieldConfig.attributes[attr]);
		code.push("'");
	}
	
	var classContent = [];
	
	if(this.fieldConfig.attributes["class"]){
		classContent.push(this.fieldConfig.attributes["class"]);
	}

	for(var feature in this.fieldConfig.features){
		if(!this.fieldConfig.features[feature]){
			continue;
		}
		
		if(classContent.length != 0){
			classContent.push(" ");
		}
		
		classContent.push(feature);
		
		if(typeof(this.fieldConfig.features[feature]) == "string"){
			classContent.push("=");
			classContent.push(this.fieldConfig.features[feature].replace(/ /, "\\ "));
		}
	}

	if(classContent.length > 0){
		code.push(" class='");
		code.push(classContent.join(""));
		code.push("'");
	}
	
	code.push(" name='");
	code.push(this.fieldConfig.name);
	code.push("'");
	
	code.push(">");

	if(this.fieldConfig.type == "select" && this.fieldConfig.options){
		for(var ii = 0; ii < this.fieldConfig.options.length; ii++){
			var option = this.fieldConfig.options[ii];
			
			code.push("\n\t\t\t<option");
			
			if(option.value){
				code.push(" value='");
				code.push(option.value);
				code.push("'");
			}
			
			if(option.selected){
				code.push(" selected='selected'")
			}
			
			code.push(">");
			code.push(option.title);
			code.push("</option>");
		}
	}
	
	if(this.fieldConfig.type == "textarea"){
		code.push("</textarea>");
	} else if(this.fieldConfig.type == "select"){
		code.push("\n\t\t</select>");
	}
	code.push("\n")

	if(this.fieldConfig.type == "input-checkbox" || this.fieldConfig.type == "input-radio"){
		code.push("\t\t<label class=''");
		
		if(addControls){
			code.push(" ondblclick='Zapatec.Widget.getWidgetById(");
			code.push(this.id);
			code.push(").editInline.show(this)'");
		}
		
		code.push(">"+ this.fieldConfig.label +"</label>\n"); // TODO add zpFormLabel
	}
	
	code.push("\t</div>\n\n");

	return code.join("");
}

/**
 * Show controls for given field.
 */
Zapatec.FormBuilder.Field.prototype.showControls = function(){
	// hide existing controls
	if(this.config.builder.activeField && this.activeField != this){
		this.config.builder.activeField.hideControls();
	}

	if(this.fieldConfig.elementRef.className.indexOf("highlighted") == -1){
		var className = this.fieldConfig.elementRef.className;
		
		if(!className){
			className = "";
		}
		
		this.fieldConfig.elementRef.className = className + " highlighted";
	}
	
	this.config.builder.activeField = this;

//	this.editButton.container.style.display = "block";
}

Zapatec.FormBuilder.Field.prototype.hideControls = function(){
	this.fieldConfig.elementRef.className = this.fieldConfig.elementRef.className.replace(/ ?\bhighlighted\b/, "");

//	this.editButton.container.style.display = "none";
	
	if(this.config.builder.activeField == this){
		this.config.builder.activeField = null;
	}
}

Zapatec.FormBuilder.Field.prototype.showEditWindow = function(){
	var tabsConfig = {tabs:[
		{
			id: "properties",
			content: this.getPropertiesText(),
			contentType: "html/text",
			linkInnerHTML: "HTML properties",
			tabType: "div"
		},
		{
			id: "features",
			content: this.getFeaturesText(),
			contentType: "html/text",
			linkInnerHTML: "Zapatec.Form properties",
			tabType: "div"
		}
	]};

	var additionalPane = this.getAdditionalText();
	
	if(additionalPane){
		tabsConfig.tabs.push({
			id: "additional",
			content: additionalPane,
			contentType: "html/text",
			linkInnerHTML: "Additional",
			tabType: "div"
		});
	}
	
	var winContent = [];
	
	winContent.push('<form id="editForm">');
	winContent.push('<div id="editTabBar" style="width: 500px"></div>');
	winContent.push('<div id="editTabs" style="height: 300px"></div>');
	winContent.push('</form>');
	winContent.push("<input type='button' value='Save & close' onclick='");
	winContent.push("Zapatec.Widget.getWidgetById(" + this.id + ").saveState();");
	winContent.push("Zapatec.Widget.getWidgetById(" + this.id + ").editWindow.close();");
	winContent.push("' />");
	winContent.push("<input type='button' value='Delete field...' onclick='");
	winContent.push("Zapatec.Widget.getWidgetById(" + this.id + ").confirmRemoveField();");
	winContent.push("' />");
	
	var self = this;
	
	this.editWindow = Zapatec.Window.setup({
		modal: true,
		left: "center",
		top: "center",
		width: "550",
		height: "450",
		content: winContent.join(""),
		eventListeners: {
			onContentLoad: function(){
				new Zapatec.Tabs({
					tabBar: "editTabBar",
					tabs: "editTabs",
					theme: "default",
					sourceType: "json",
					source: tabsConfig,
					changeUrl: false,
					overflow: "auto"
				});
				
//				new Zapatec.Form({
//					form: "editForm",
//					theme: "default"
//				});
//				
				var fieldConfig = self.fieldConfig;

				if(fieldConfig.options){
					function populateValues(element, option){
						if(!option){
							return;
						}
						
						var inputs = element.getElementsByTagName("input");
						
						inputs[0].value = option.title;
						inputs[1].value = option.value;
					}

					var parent = document.getElementById("option_parent");
					populateValues(parent, self.fieldConfig.options[0]);
					Zapatec.Form.Utils.initMultipleField(parent, true);
					
					for(var ii = 1; ii < self.fieldConfig.options.length; ii++){
						var clone = Zapatec.Form.Utils.cloneElement(parent);
						populateValues(clone, self.fieldConfig.options[ii]);
					}
					
					var element = document.getElementById("options_list");

					for(var ii = 0; ii < fieldConfig.options.length; ii++){
						if(fieldConfig.options[ii].selected){
							element.childNodes[ii].getElementsByTagName("input")[2].checked = true;
						}
					}
				}
			},
			onClose: function(){
				self.saveState();
			}
		}
	});
}

Zapatec.FormBuilder.Field.prototype.saveState = function(){
	if(this.fieldConfig.type == 'select'){
		var optionsList = document.getElementById("options_list");
	
		this.fieldConfig.options = [];
		
		for(var ii = 0; ii < optionsList.childNodes.length; ii++){
			var inputs = optionsList.childNodes[ii].getElementsByTagName("input");
			
			this.fieldConfig.options.push({
				title: inputs[0].value,
				value: inputs[1].value,
				selected: inputs[2].checked
			});
		}

		this.config.builder.doPreview();
	}
}

Zapatec.FormBuilder.Field.prototype.getAdditionalText = function(){
	if(this.fieldConfig.type != "select"){
		return null;
	}
	
	var paneContent = [];
	paneContent.push("<div id='options_list'>")
	paneContent.push("<div id='option_parent' class='option_parent zpFormMultipleInside'>")
	paneContent.push("<div><label>Name</label><input type='text' name='option_name' /></div>");
	paneContent.push("<div><label>Value</label><input type='text' name='option_value' /></div>");
	paneContent.push("<div><label>Selected</label><input type='radio' name='option_selected' /></div>");
	paneContent.push("</div>")
	paneContent.push("</div>")
	
	return paneContent.join("");
}

Zapatec.FormBuilder.Field.prototype.getPropertiesText = function(){
	var winContent = ["<div>"];
	var self = this;
	var fieldAttrs = this.fieldConfig.attributes;
	
	function generateTextField(name, label, value){
		if(!value){
			value = "";
		}
		
		return "<div><label for='property_" + name + "'>" + label + "</label>"+
			"<input type='text' class='zpIgnoreField' id='property_" + name + "' name='" + name + "' value=\""+ value + "\"" + 
			"onchange='Zapatec.Widget.callMethod("+ self.id +", \"editFieldProperty\", "+
			"this.name, this.value)' /></div>";
	}
	
	function generateCheckbox(name, label, checked){
		return "<div><input type='checkbox' class='zpIgnoreField' id='property_" + name + "' name='" + name + "' "+ (checked ? "checked='checked'" : "") + 
			"onchange='Zapatec.Widget.callMethod("+ self.id +", \"editFieldProperty\", "+
			"this.name, this.checked)' /><label for='property_" + name + "'>" + label + "</label></div>";
	}

	switch(this.fieldConfig.type){
		case "input-text":
			winContent.push(generateTextField("name", "Name", fieldAttrs.name));
			winContent.push(generateTextField("class", "CSS class name", fieldAttrs['class']));
			winContent.push(generateTextField("size", "Size", fieldAttrs.size));
			winContent.push(generateTextField("value", "Predefined value", fieldAttrs.value));
			winContent.push(generateTextField("maxlength", "Max length", fieldAttrs.maxlength));
			winContent.push(generateTextField("id", "ID", fieldAttrs.id));
			winContent.push(generateCheckbox("readonly", "Readonly", fieldAttrs.readonly));
			winContent.push(generateCheckbox("disabled", "Disabled", fieldAttrs.disabled));
			break;
		case "input-checkbox":
			winContent.push(generateTextField("name", "Name", fieldAttrs.name));
			winContent.push(generateTextField("class", "CSS class name", fieldAttrs['class']));
			winContent.push(generateTextField("value", "Predefined value", fieldAttrs.value));
			winContent.push(generateTextField("id", "ID", fieldAttrs.id));
			winContent.push(generateCheckbox("checked", "Checked", fieldAttrs.checked));
			winContent.push(generateCheckbox("readonly", "Readonly", fieldAttrs.readonly));
			winContent.push(generateCheckbox("disabled", "Disabled", fieldAttrs.disabled));
			break;
		case "input-radio":
			winContent.push(generateTextField("name", "Name", fieldAttrs.name));
			winContent.push(generateTextField("class", "CSS class name", fieldAttrs['class']));
			winContent.push(generateTextField("value", "Predefined value", fieldAttrs.value));
			winContent.push(generateTextField("id", "ID", fieldAttrs.id));
			winContent.push(generateCheckbox("checked", "Checked", fieldAttrs.checked));
			winContent.push(generateCheckbox("readonly", "Readonly", fieldAttrs.readonly));
			winContent.push(generateCheckbox("disabled", "Disabled", fieldAttrs.disabled));
			break;
		case "textarea":
			winContent.push(generateTextField("name", "Name", fieldAttrs.name));
			winContent.push(generateTextField("class", "CSS class name", fieldAttrs['class']));
			winContent.push(generateTextField("value", "Predefined value", fieldAttrs.value));
			winContent.push(generateTextField("id", "ID", fieldAttrs.id));
			winContent.push(generateTextField("cols", "Columns", fieldAttrs.cols));
			winContent.push(generateTextField("rows", "Rows", fieldAttrs.rows));
			winContent.push(generateCheckbox("readonly", "Readonly", fieldAttrs.readonly));
			winContent.push(generateCheckbox("disabled", "Disabled", fieldAttrs.disabled));
			break;
		case "select":
			winContent.push(generateTextField("name", "Name", fieldAttrs.name));
			winContent.push(generateTextField("class", "CSS class name", fieldAttrs['class']));
			winContent.push(generateTextField("id", "ID", fieldAttrs.id));
			winContent.push(generateTextField("size", "Size", fieldAttrs.size));
			winContent.push(generateCheckbox("multiple", "Multiple selection", fieldAttrs.multiple));
			winContent.push(generateCheckbox("readonly", "Readonly", fieldAttrs.readonly));
			winContent.push(generateCheckbox("disabled", "Disabled", fieldAttrs.disabled));

			//TODO edit options here
			break;
	}
	
	winContent.push("</div>");
	
	return winContent.join("");
}

Zapatec.FormBuilder.Field.prototype.getFeaturesText = function(){
	var winContent = ["<div>"];
	var self = this;
	var fieldFeatures = this.fieldConfig.features;
	
	function generateTextField(name, label, value){
		if(!value){
			value = "";
		}
		var txt = "<div><input type='checkbox' class='zpIgnoreField' id='feature_" + name + "'"+ 
			(value ? "checked='checked'" : "") +
			" onclick='var valEl = document.getElementById(\"feature_value_" + name + "\"); "+
			"valEl.style.visibility = this.checked ? \"visible\" : \"hidden\"; "+
			"Zapatec.Widget.callMethod("+ self.id +", \"editFieldFeature\", \""+
			name + "\", this.checked ? valEl.value : null)' />\n" +
			"<label for='feature_" + name + "'>" + label + "</label>\n: <input type='text' id='feature_value_" + name + "' name='" + name + "' value=\""+ value + "\"" + 
			" onchange='Zapatec.Widget.callMethod("+ self.id +", \"editFieldFeature\", "+
			"this.name, this.value)' style='" + (value ? "" : "visibility: hidden") + "'/>\n</div>";
		return txt;
	}
	
	function generateCheckbox(name, label, checked){
		return "<div><input type='checkbox' class='zpIgnoreField' id='feature_"+ name +"' name='" + name + "' "+ (checked ? "checked='checked'" : "") + 
			"onchange='Zapatec.Widget.callMethod("+ self.id +", \"editFieldFeature\", "+
			"this.name, this.checked)' /> <label for='feature_" + name + "'>" + label + "</label></div>";
	}

	switch(this.fieldConfig.type){
		case "input-text":
			winContent.push(generateCheckbox("zpFormRequired", "Is required", fieldFeatures.zpFormRequired));
			winContent.push(generateTextField("zpFormMask", "Masked input", fieldFeatures.zpFormMask));
			winContent.push(generateTextField("zpFormDate", "Must be valid date (US format)", fieldFeatures.zpFormDate));
			winContent.push(generateCheckbox("zpFormUrl", "Must be an URL", fieldFeatures.zpFormUrl));
			winContent.push(generateCheckbox("zpFormEmail", "Must be an email", fieldFeatures.zpFormEmail));
			winContent.push(generateCheckbox("zpFormCreditCard", "Must be valid credit card number", fieldFeatures.zpFormCreditCard));
			winContent.push(generateCheckbox("zpFormUSPhone", "Must be valid US phone number", fieldFeatures.zpFormUSPhone));
			winContent.push(generateCheckbox("zpFormInternationalPhone", "Must be valid international phone number", fieldFeatures.zpFormInternationalPhone));
			winContent.push(generateCheckbox("zpFormUSZip", "Must be valid US zip code", fieldFeatures.zpFormUSZip));
			winContent.push(generateCheckbox("zpFormInt", "Must be an integer number", fieldFeatures.zpFormInt));
			winContent.push(generateCheckbox("zpFormFloat", "Must be a float number", fieldFeatures.zpFormFloat));
			break;
		case "input-checkbox":
			winContent.push(generateCheckbox("zpFormRequired", "Is required", fieldFeatures.zpFormRequired));
			break;
		case "input-radio":
			winContent.push(generateCheckbox("zpFormRequired", "Is required", fieldFeatures.zpFormRequired));
			break;
		case "textarea":
			winContent.push(generateCheckbox("zpFormRequired", "Is required", fieldFeatures.zpFormRequired));
			break;
		case "select":
			winContent.push(generateCheckbox("zpFormRequired", "Is required", fieldFeatures.zpFormRequired));
			break;
	}
	
	winContent.push("</div>");
	
	return winContent.join("");
}

Zapatec.FormBuilder.Field.prototype.editFieldProperty = function(property, value){
	if(value == false){
		this.fieldConfig.inputElement.removeAttribute(property);
	} else {
		this.fieldConfig.inputElement.setAttribute(property, value);
	}

	this.fieldConfig.attributes[property] = value;

	if(property == "value"){
		this.fieldConfig.inputElement.value = value;		
	}

	if(property == "name"){
		this.fieldConfig.name = value;		
	}

	if(property == "class"){
		for(var feature in this.fieldConfig.features){
			if(!this.fieldConfig.features[feature]){
				continue;
			}
			
			value += " " + feature;
			
			if(typeof(this.fieldConfig.features[feature]) == "string"){
				value += "=" + fieldConfig.features[feature].replace(/ /, "\\ ");
			}
		}

		this.fieldConfig.inputElement.className = value;
				
	}
}

Zapatec.FormBuilder.Field.prototype.editFieldFeature = function(feature, value){
	this.fieldConfig.features[feature] = value;
	
	// Refresh whole form
	// TODO refresh only this field
	this.config.builder.doPreview();
}
