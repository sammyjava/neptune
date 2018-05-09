// $Id: form-utils.js 15736 2009-02-06 15:29:25Z nikolai $
/**
 *
 * Copyright (c) 2004-2009 by Zapatec, Inc.
 * http://www.zapatec.com
 * 1700 MLK Way, Berkeley, California,
 * 94709, U.S.A.
 * All rights reserved.
 */

// various form functions
Zapatec.Form.Utils = [];

/**
 * @private
 * function for retrieving pairs of key=value from string
 * TODO: extend description
 */
Zapatec.Form.Utils.getTokens = function(className, separator){
	if(typeof(separator) != 'string' || separator.length == 0){
		// setting default value
		separator = " ";
	}

	var arr = {};

	if(className != null && className.length > 0){
		var isInQuotes = false;
		var quoteChar = null;
		var key = "";
		var value = "";
		var isInValue = false;

		for(var ii = 0; ii < className.length; ii++){
			var currChar = className.charAt(ii);

			if(currChar == "\\"){
				// if current char is \ - store next char in any case
				ii++;

				currChar = className.charAt(ii);
			} else if(!isInValue && currChar == "="){
				// if current char is = - this means that key is finished - all
				// other before next space is value

				isInValue = true;
				var nextChar = className.charAt(ii + 1);

				// supporting old behaviour - value could be putted into quotes
				if(nextChar == "'" || nextChar == '"'){
					quoteChar = nextChar;
					ii++;
				}

				continue;
			} else if(currChar == " "){
				if(key.length == 0){
					continue;
				}
				// if this is space - then current pair of key&value is
				// ready.

				if(quoteChar != null){
					// supporting old behaviour:
					//	if last character is same as quote after '=' - ignore
					//		last symbol.
					//	in other case - add quote after '=' to value
					if(quoteChar == value.charAt(value.length - 1)){
						quoteChar = null;
						value = value.substr(0, value.length - 1);
					} else {
						value = quoteChar + value;
					}
				}

				// store pair
				arr[key] = value.length == 0 ? null : value;

				//clear variables
				isInValue = false;
				key = "";
				value = "";
				quoteChar = null;

				continue;
			}

			if(ii < className.length){
				// if we are here - currChar is non-system char. Store it.
				if(isInValue){
					value += currChar;
				} else {
					key += currChar;
				}
			}
		}

		// processing last argument
		if(key.length > 0){
			if(quoteChar != null){
				// supporting old behaviour:
				//	if last character is same as quote after '=' - ignore
				//		last symbol.
				//	in other case - add quote after '=' to value
				if(quoteChar == value.charAt(value.length - 1)){
					quoteChar = null;
					value = value.substr(0, value.length - 1);
				} else {
					value = quoteChar + value;
				}
			}

			arr[key] = (value.length == 0 ? null : value);
		}
	}

	return arr;
};

/**
* Toggle visibility of given element and disable/enable all form elements
* inside given element.
* @param field [Object] reference to element - DOM or String ID
* @param show {boolean} if true - show element. Otherwise - hide.
* @param useVisibility {boolean} if true - field visibility would be changed
*	using field.style.visibility property. Otherwise - field.style.display
*/
Zapatec.Form.Utils.toggleFormElements = function(field, show, useVisibility){
	field = Zapatec.Widget.getElementById(field);

	if(field == null){
		return null;
	}

	var inputs = Zapatec.Form.Utils.getFormElements(field);

	for(var ii = 0; ii < inputs.length; ii++){
		var input = inputs[ii];
		
		if(show){
			if(typeof(input.zpOrigDisabled) != 'undefined'){
				input.disabled = input.zpOrigDisabled;
		
				var undef;
				input.zpOrigDisabled = undef;
			}
		} else {
			if(typeof(input.zpOrigDisabled) == 'undefined'){
				input.zpOrigDisabled = input.attributes["disabled"] && input.getAttribute("disabled") != "" ? input.getAttribute("disabled") : false;
				input.disabled = true;
			}
		}

		// if we are showing Zapatec.Form.Field - we must validate it.
		if(show && input.zpFormField != null){
			input.zpFormField.validate();
		}
	}

	if(useVisibility){
		field.style.visibility = (show ? 'visible' : 'hidden');
	} else {
		field.style.display = (show ? '' : 'none');
	}
};

/**
 * @private
 * Returns array of form elements inside given element.
 * @param el {Object} reference to element - DOM element or string ID.
 * @return array of form elements inside given element.
 * @type Object
 */
Zapatec.Form.Utils.getFormElements = function(el){
	el = Zapatec.Widget.getElementById(el);

	if(el == null){
		return null;
	}

	var inputs = [];
	var children = el.all ? el.all : el.getElementsByTagName("*");

	for(var ii = 0; ii < children.length; ii++){
		if(Zapatec.Form.Utils.isInputField(children[ii])){
			inputs.push(children[ii]);
		}
	}

	return inputs;
};

/**
 * Returns value of given element
 * @param element {Object} reference to element. DOM reference or string ID.
 * @return Field value
 * @type String
 */
Zapatec.Form.Utils.getValue = function(element) {
	element = Zapatec.Widget.getElementById(element);

	if(element == null || typeof(element.tagName) == 'undefined'){
		return null;
	}

	switch (element.tagName.toLowerCase()) {
		case "select":
			if(
				!Zapatec.is_ie &&
				element.hasAttribute("multiple") ||
				Zapatec.is_ie &&
				element.attributes['multiple'] && element.attributes['multiple'].nodeValue
			){
				var res = [];
				for(var ii = 0; ii < element.options.length; ii++){
					var oOption = element.options[ii];
					if(oOption.selected){
						res.push(oOption.value)
					}
				}

				return res;
			} else {
				if(element.selectedIndex < 0){
					// IE weird. Sometimes selectedIndex is -1
					return "";
				}
				
				var option = element.options[element.selectedIndex];
	    
				if(option != null){
					return option.value;
				} else {
					return "";
				}
			}
		case "input":
			return element.value;
		case "textarea":
			return element.value;
	}

	return null;
};

/**
 * Sets given value for given element
 * @param element {Object} reference to element. DOM reference or string ID
 * @param value - [string] value
 */
Zapatec.Form.Utils.setValue = function(element, value) {
	element = Zapatec.Widget.getElementById(element);

	if(element == null || typeof(element.tagName) == 'undefined'){
		return null;
	}

	switch (element.tagName.toLowerCase()) {
		case "input":
			var elType = element.type.toLowerCase();
			if(elType != "file" && elType != "button"){
				element.value = value;
			}

			break;
		case "textarea":
			element.value = value;

			break;
		case "select":
			if(
				(
					!Zapatec.is_ie &&
					element.hasAttribute("multiple") ||
					element.attributes['multiple']
				) &&
				value.length
			){
				for(var ii = element.options.length - 1; ii >= 0 ; ii--){
					var oOption = element.options[ii];

					for(var jj = value.length; jj >= 0; jj--){
						if(oOption.value == value[jj]){
							oOption.selected = true;
							break;
						}
					}
				}
			} else {
				for(var i = 0; i < element.options.length; i++){
					if (element.options[i].value == value){
						element.selectedIndex = i;
						break;
					}
				}
			}
	}

	return value;
};

/**
 * @private
 * Check if given element is form field.
 * @return true, if current field is input-able field.
 * @type boolean
 */
Zapatec.Form.Utils.isInputField = function(el){
	if(el.nodeType != 1){
		return false;
	}
	
	var nodeName = el.nodeName.toLowerCase();
	
	return (
		nodeName == 'input' ||
		nodeName == 'textarea' ||
		nodeName == 'select'
	);
};	

/**
 * @private
 * Should we ignore this field.
 * @param field {Object} reference to element. DOM element or string ID.
 * @return true if Zapatec.Form shouldn't process this field.
 * @type boolean
 */
Zapatec.Form.Utils.ignoreField = function(field) {
	field = Zapatec.Widget.getElementById(field);

	if(
		!field ||
		field.nodeType != 1 ||
		( // if field className has "zpIgnoreField" - do not process this field.
			field.className &&
			/\bzpIgnoreField\b/.test(field.className)
		) ||
		!Zapatec.Form.Utils.isInputField(field) ||
		( // IE bug - it thinks that <FIELDSET> is form element
			field.nodeType == 1 &&
			field.nodeName.toLowerCase() == 'fieldset'
		)
	){
		return true;
	}

	var type = field.type.toLowerCase();
	var ignoreList = ['submit', 'reset', 'button'];

	for (var ii = 0; ii < ignoreList.length; ii++) {
		if (type.toLowerCase() == ignoreList[ii]) {
			return true; //ignore
		}
	}

	return false; //not in the list; don't ignore
};

/**
 * @private
 * zpFormMask related function.
 * Checks if key that was pressed is not alphanumeric key.
 * @param charCode {int} data, retrieved from this.getInputData()[0]
 * @param newChar {char} data, retrieved from this.getInputData()[1]
 * @return true if key that was pressed is not alphanumeric key.
 * @type boolean
 */
Zapatec.Form.Utils.isSpecialKey = function(charCode, newChar){
	return (
		(
			newChar == null &&
			charCode != 8 &&
			charCode != 46
		) ||
		charCode == 9	|| // tab
		charCode == 13	|| // enter
		charCode == 16	|| // shift
		charCode == 17	|| // ctrl
		charCode == 18	|| // alt
		charCode == 20	|| // caps lock
		charCode == 27	|| // escape
		charCode == 33	|| // page up
		charCode == 34	|| // page down
		charCode == 35	|| // home
		charCode == 36	|| // end
		charCode == 37	|| // left arrow
		charCode == 38	|| // up arrow
		charCode == 39	|| // right arrow
		charCode == 40	|| // down arrow
		charCode == 45	|| // insert
		charCode == 144	|| // num lock
		charCode > 256 // Safari strange bug
	);
};

/**
 * @private
 * Function for initializing multiple elements in form.
 * @param currEl {Object} link to DOM element, that is processed.
 * @param firstRun {boolean} Should be setted to true, if this function is
 * called at first time.(in other case you would get problems with table layout)
 * @param form {Object} reference to Zapatec.Form instance
 */
Zapatec.Form.Utils.initMultipleField = function(currEl, firstRun, form){
	var md = null;

	// check if this element can be copied
	if(
		!currEl ||
		!currEl.className ||
		!(md = currEl.className.match(/zpFormMultiple(Inside|Outside)?/)) ||
	    currEl.zpRelatedElements != null
	){
		return null;
	}
	
	var outside = true;
	
	if(
		md[1] == "Inside" ||
		currEl.nodeName.toLowerCase() == "td" ||
		currEl.nodeName.toLowerCase() == "th" ||
		currEl.nodeName.toLowerCase() == "tr"
	){
		// for table elements button could be added only inside element
		outside = false;
	}

	if(
		currEl.nodeName.toLowerCase() == "input" ||
		currEl.nodeName.toLowerCase() == "textarea" ||
		currEl.nodeName.toLowerCase() == "select" ||
		currEl.nodeName.toLowerCase() == "image"
	){
		// for this elements button could be added only outside element
		outside = true;
	}

	var appendEl = currEl;

	// if marker sticked to TR - we should create TD element at the end to add
	// button to it. To save table structure - we also should add empty cells to
	// all other rows.
	// but we should do this only on form init
	if(currEl.nodeName.toLowerCase() == "tr"){
		function findParentTable(el){
			if (
				el.parentNode != null &&
				el.parentNode.nodeType == 1 &&
				el.parentNode.tagName.toLowerCase() != "table"
			){
				return findParentTable(el.parentNode);
			}

			return el.parentNode;
		}

		var table = findParentTable(currEl);
		
		for(var jj = table.rows.length - 1; jj >=0 ; jj--){
			var td = document.createElement('td');
			td.className = Zapatec.Form.IGNORE_CLASSNAME;
			td.innerHTML = "&nbsp;";
			
			if(
				jj == currEl.rowIndex ||
				table.rows[jj] == currEl // Opera 9 has some problems with rowIndex property
			){
				appendEl = td;
			}

			if(firstRun || jj == currEl.rowIndex){
				table.rows[jj].appendChild(td);
			}
		}
	}

	var button = Zapatec.Utils.createElement('input');
	button.type = "button";
	button.className = Zapatec.Form.IGNORE_CLASSNAME + " multipleButton";
	Zapatec.Utils.createProperty(button, "zpMultipleElement", currEl);

	// if this is root element (where "+" mark is placed)
	if(currEl.zpOriginalNode == null){
		// variable to store references to cloned elements
		Zapatec.Utils.createProperty(currEl, "zpMultipleChildren", []);
		Zapatec.Utils.createProperty(currEl, "zpMultipleChilds", []);

		button.value = "+";

		// on button click - clone element
		button.onclick = function(){
			if(!this.disabled){
				Zapatec.Form.Utils.cloneElement(currEl, form);
			}
		}
	} else {
		// if this is cloned element
		button.value = "-";

		var parent = currEl.zpOriginalNode;
		// add reference to newly created element to parent's zpMultipleChildren array
		parent.zpMultipleChilds.push(currEl);
		parent.zpMultipleChildren.push(currEl);

		button.onclick = function(){
			if(!this.disabled){
				Zapatec.Form.Utils.removeClonedElement(currEl, form);
			}
		}
	}

	// append button to DOM tree
	if(outside){
		Zapatec.Utils.insertAfter(appendEl, button);
	} else {
		if (form.config.showErrors == 'last') {
			// Add + button before errors text
			var childrenCount = appendEl.childNodes.length;
			appendEl = appendEl.childNodes[childrenCount -1];
			while (appendEl.nodeType != 1 || (appendEl.id && appendEl.id.match(/ErrorText$/))) {
				appendEl = appendEl.previousSibling;
			}
			appendEl = appendEl.nextSibling;
			appendEl.parentNode.insertBefore(button, appendEl);
		}
		else {
			appendEl.appendChild(button);
		}
	}

	// in this array stored elements, that should be deleted when element would be deleted.
	Zapatec.Utils.createProperty(currEl, "zpRelatedElements", [button, currEl]);

	// store reference to button
	Zapatec.Utils.createProperty(currEl, "zpMultipleButton", button);

	// get configuration for this field
	var tokens = Zapatec.Form.Utils.getTokens(currEl.className);

	// if element has "zpFormMultipleLimit" property - save it.
	if(typeof(tokens['zpFormMultipleLimit']) != 'undefined' && !isNaN(parseInt(tokens['zpFormMultipleLimit']))){
		Zapatec.Utils.createProperty(currEl, "zpFormMultipleLimit", parseInt(tokens['zpFormMultipleLimit']) - 2);

		if(isNaN(currEl.zpFormMultipleLimit)){
			currEl.zpFormMultipleLimit = -1;
		}
	} else {
		Zapatec.Utils.createProperty(currEl, "zpFormMultipleLimit", -1);
	}

	// check if this is input field
	if(currEl.zpFormField != null){
		// store reference to elements that must be destroyed together with this.
		currEl.zpRelatedElements = [
			currEl.zpFormField.statusImg1,
			currEl.zpFormField.statusImg2,
			currEl.zpFormField.statusImg3,
			currEl.zpFormField.statusImg4,
			currEl.zpFormField.statusImg,
			currEl.zpFormField.errorText
		].concat(currEl.zpRelatedElements);
	} else {
		Zapatec.Utils.createProperty(currEl, "zpLastNode", (outside ? button : currEl));
	}
};

/**
 * @private
 * Handles click on "+" button near zpFormMultiple element
 * @param field {Object} DOM reference to element that must be cloned
 * @param form {Object} reference to Zapatec.Form instance. Optional.
 */
Zapatec.Form.Utils.cloneElement = function(field, form){
	// if zpFormMultipleLimit exceeded - do nothing
	if(
		field.zpFormMultipleLimit >= 0 && field.zpMultipleChildren != null && 
		field.zpMultipleChildren.length > field.zpFormMultipleLimit
	){
		return false;
	}

	// determine where to insert new element
	var insertAfterNode = field.zpLastNode;

	if(field.zpMultipleChildren != null && field.zpMultipleChildren.length > 0){
		insertAfterNode = field.zpMultipleChildren[field.zpMultipleChildren.length - 1].zpLastNode;
	}

	// clone node
	var clone = field.cloneNode(true);

	// store reference to parent node
	Zapatec.Utils.createProperty(clone, "zpOriginalNode", field);

	Zapatec.Utils.insertAfter(insertAfterNode, clone);

	// init all nodes in created subtree if needed (included newly created node)
	var childElements = [clone];
	var originalElements = [field];

	var tmpArr = clone.all ? clone.all : clone.getElementsByTagName("*");
	var originalArr = field.all ? field.all : field.getElementsByTagName("*");
	
	for(var ii = 0; ii < tmpArr.length; ii++){
		childElements.push(tmpArr[ii]);
		originalElements.push(originalArr[ii]);
	}

	// check all child elements for this element.
	for(var ii = 0; ii < childElements.length; ii++){
		var currEl = childElements[ii];
		
		// if field has "ignore" mark - delete it.
		if(currEl.className.indexOf(Zapatec.Form.IGNORE_CLASSNAME) >= 0){
			Zapatec.Utils.destroy(currEl);
			continue;
		}

		// If element is input field - clear its value and create
		// corresponding Zapatec.Form.Field object.
		if(Zapatec.Form.Utils.isInputField(currEl)){
			Zapatec.Form.Utils.setValue(currEl, "");

			if(currEl.form && currEl.form.zpForm){
				var zpForm = currEl.form.zpForm;

				var zpField = originalElements[ii].zpFormField;
				currEl.zpFormField = null;

				new Zapatec.Form.Field({
					form: zpForm, 
					field: currEl,
					langId: zpForm.config.langId,
					lang: zpForm.config.lang,
					langCountryCode: zpForm.config.langCountryCode,
					langEncoding: zpForm.config.langEncoding,
					formConfig: (zpForm ? zpForm.config : {}),
					inheritFrom: zpField
				});
			}
		}

		// clear internal properties
		currEl.zpMultipleElement = null;
		currEl.zpMultipleChilds = null;
		currEl.zpMultipleChildren = null;
		currEl.zpRelatedElements = null;
		currEl.zpMultipleButton = null;
		currEl.zpFormMultipleLimit = null;

		// init this field if it is multiple
		Zapatec.Form.Utils.initMultipleField(currEl, false, form);

		if(form && typeof(form.config.multipleCallback) == 'function'){
			form.config.multipleCallback(field, clone, currEl, field.zpMultipleChildren);
		}
	}

	// if zpFormMultipleLimit clones were created - hide button and disable it
	if(
		field.zpFormMultipleLimit >= 0 && 
		field.zpMultipleChildren != null && 
		field.zpMultipleChildren.length > field.zpFormMultipleLimit
	){
		field.zpMultipleButton.style.visibility = 'hidden';
		field.zpMultipleButton.disabled = true;
	}

	if(form){
		form.fireEvent("afterCloneMultiple", field, clone);
	}

	return clone;
};

/**
 * @private
 * Handles click on "-" button near cloned zpFormMultiple element
 * @param field {Object} DOM reference to element that must be removed
 */
Zapatec.Form.Utils.removeClonedElement = function(field, form){
	// Do nothing if this is not cloned field.
	if(field == null || field.zpOriginalNode == null){
		return false;
	}

	// remove current element from array of cloned elements in parent node.
	var children = field.zpOriginalNode.zpMultipleChildren;

	if(form){
		form.fireEvent("beforeDeleteMultiple", field, field.zpOriginalNode);
	}
	
	for(var ii = 0; ii < children.length; ii++){
		if(children[ii] == field){
			var original = field.zpOriginalNode;
			
			original.zpMultipleChilds = children.slice(0, ii).concat(children.slice(ii + 1));
			original.zpMultipleChildren = children.slice(0, ii).concat(children.slice(ii + 1));
	    
			// show "+" button
			if(
				original.zpFormMultipleLimit >= 0 &&
				original.zpMultipleChildren.length <= original.zpFormMultipleLimit
			){
				original.zpMultipleButton.style.visibility = 'visible';
				original.zpMultipleButton.disabled = false;
			}

			break;
		}
	}

	// destroy all related elements for this element.
	if(field.zpRelatedElements != null && field.zpRelatedElements.length > 0){
		for(var ii = 0; ii < field.zpRelatedElements.length; ii++){
			if(
				typeof(field.zpRelatedElements[ii]) != 'undefined' &&
				field.zpRelatedElements[ii] != null
			){
				Zapatec.Utils.destroy(field.zpRelatedElements[ii]);
			}
		}
	}
};

/**
 * This is default function for processing cloned elements.
 * @param original {Object} Reference to original DOM element
 * @param cloneParent {Object} Reference to cloned container
 * @param cloned {Object} cloned element inside 
 * @param children {Array} Array of all cloned elements for original node
 */
Zapatec.Form.Utils.generateMultipleId = function(original, cloneParent, cloned, children){
	if(!cloneParent.zpIsCloned){
		cloneParent.zpIsCloned = true;
	}
	
	// if element has 'id' attribute - make it unique.
	if(
		typeof(cloned.id) != 'undefined' && 
		cloned.id != null && 
		cloned.id != ""
	){
		cloned.id += "-" + original.zpMultipleChildren.length;
	}

	// if element has 'name' attribute - make it unique.
	if(
		typeof(cloned.name) != 'undefined' && 
		cloned.name != null && 
		cloned.name != ""
	){
		cloned.name += "-" + original.zpMultipleChildren.length;
	}
};

/**
 * This is default handler for removing cloned element.
 */
Zapatec.Form.Utils.beforeDeleteMultiple = function(el, original){
	if(!el || !original || !original.zpMultipleChildren){
		return;
	}

	var cc = 1;

	for(var ii = 0; ii < original.zpMultipleChildren.length; ii++){
		var node = original.zpMultipleChildren[ii];

		if(node === el){
			continue;
		}

		var childElements = [node];
		var tmpArr = node.all ? node.all : node.getElementsByTagName("*");
	    
		for(var jj = 0; jj < tmpArr.length; jj++){
			childElements.push(tmpArr[jj]);
		}
	    
		// check all child elements for this element.
		for(var jj = 0; jj < childElements.length; jj++){
			var currEl = childElements[jj];

			if(currEl.id){
				currEl.id = currEl.id.replace(/-\d+$/, "-" + cc);
			}

			if(currEl.name){
				currEl.name = currEl.name.replace(/-\d+$/, "-" + cc);
			}
		}
	
		cc++;
	}
}
