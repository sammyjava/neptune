/* $Id: colorpicker.js 16950 2009-04-09 09:53:02Z roman $ */
/**
 * @fileoverview Color Picker widget class derived from Widget. See description
 * of base Widget class at http://trac.zapatec.com:8000/trac/wiki/Widget.
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
* Zapatec ColorPicker object. Creates the element for selecting color
* Displays 216 predefined colors palette, three Sliders and three input fields
* for red, green and blue channels and input field for hex color value.
* @param config [object] - color picker config.
*
* Constructor recognizes the following properties of the config object
* \code
*	property name			| description
*------------------------------------------------------------------------------
*	button						| [string or object] Reference to DOM element.  Optional
*										| Click on this element will popup color picker.
*	inputField				| [string or object] Reference to DOM element. Optional
*										| If option is given - value will be written into this
*										| element.
*	color							| [string] Initial color, format: '#FFCCFF', Optional,
*										| default '#000000'
*	title 						| [string] Title of color picker. Optional, default 'Color Picker'
*	offset  					| [number] offset between button and picker. Optional,
*										| default 10 pixels
* singleClick 			| [boolean] This defines how to handle color selecting. 
*             			| If true, color is selected on single click on palette. 
*             			| If false, on click color is set active, and selecting is attached to double click.
* lang							| Set language for color picker. Use three letters short form of the language name as a parameter.
* handleButtonClick | Set to true if you want to handle button clicks by yourself, especially for use in another widgets.
* 
* \endcode
*/


/**
 * ColorPicker class.
 *
 * @constructor
 * @extends Zapatec.Widget
 * @param {object} objArgs User configuration
 */
Zapatec.ColorPicker = function(objArgs) {
	if (arguments.length == 0) {
		objArgs = {};
	}
	Zapatec.ColorPicker.SUPERconstructor.call(this, objArgs);
};

/**
 * Unique static id of the widget class. Gives ability for Zapatec#inherit to
 * determine and store path to this file correctly when it is included using
 * Zapatec#include. When this file is included using Zapatec#include or path
 * to this file is gotten using Zapatec#getPath, this value must be specified
 * as script id.
 * @private
 */
Zapatec.ColorPicker.id = 'Zapatec.ColorPicker';
// Inherit Widget
Zapatec.inherit(Zapatec.ColorPicker, Zapatec.Widget);

// Include Zapatec.SliderWidget
Zapatec.include(Zapatec.zapatecPath+'../zpslider/src/slider.js',
		'Zapatec.SliderWidget');
Zapatec.Transport.include(Zapatec.zapatecPath + '../zpextra/lang/colorpicker/eng.js');

/**
 * Converts decimal value of channel color to hexadecimal value
 *
 * @private
 * @param {number} dec Decimal color channel value
 * @type string
 * @return Hexadecimal value of channel color
 */
Zapatec.ColorPicker.convertChannelColorToHex = function (dec) {
	var hexChars = "0123456789ABCDEF";
	if (dec > 255) {
		return null;
	}
	var i = dec % 16;
	var j = (dec - i) / 16;
	var result = hexChars.charAt(j);
	result += hexChars.charAt(i);
	return result;
}

/**
 * Converts hexadecimal value of color to object with properties:
 * red, green, blue for color channels
 *
 * @private
 * @param {string} hec Hexadecimal color value
 * @type object
 * @return Object that contains values for color channels
 */
Zapatec.ColorPicker.convertHexToColorObject = function (hex) {
	var hexChars = "0123456789ABCDEF";
	var red, green, blue;
	if (hex.match(/#[0123456789ABCDEF]{6}/i)) {
		red = hexChars.indexOf(hex.charAt(1))*16+
			  hexChars.indexOf(hex.charAt(2));
		green = hexChars.indexOf(hex.charAt(3))*16+
				hexChars.indexOf(hex.charAt(4));
		blue = hexChars.indexOf(hex.charAt(5))*16+
			   hexChars.indexOf(hex.charAt(6));
	} else if (hex.match(/[0123456789ABCDEF]{6}/i)) {
		red = hexChars.indexOf(hex.charAt(0))*16+
			  hexChars.indexOf(hex.charAt(1));
		green = hexChars.indexOf(hex.charAt(2))*16+
				hexChars.indexOf(hex.charAt(3));
		blue = hexChars.indexOf(hex.charAt(4))*16+
			   hexChars.indexOf(hex.charAt(5));
	} else {
		red = 0; green = 0; blue = 0;
	}

	return {red:red,green:green,blue:blue};
}


/**
 * Initializes object.
 *
 * @param {object} objArgs User configuration
 */
Zapatec.ColorPicker.prototype.init = function(objArgs) {
	var self = this;
	// Call init method of superclass
	Zapatec.ColorPicker.SUPERclass.init.call(this, objArgs);
	// Generates HTML for ColorPicker
	if (Zapatec.windowLoaded) {
		this.create();
	} else {
		Zapatec.Utils.addEvent(window, "load", function() {
			self.create();
		});
	};
};

/**
 * Configures the widget. Gets called from init and reconfigure methods of
 * superclass.
 *
 * @private
 * @param {object} objArgs User configuration
 */
Zapatec.ColorPicker.prototype.configure = function(objArgs) {
	this.defineConfigOption('button', null);
	this.defineConfigOption('handleButtonClick', true);
	this.defineConfigOption('inputField', null);
	this.defineConfigOption('color','#000000');
	this.defineConfigOption('title');
	this.defineConfigOption('offset',10);
	this.defineConfigOption('singleClick',false);
	this.defineConfigOption('themePath', Zapatec.zapatecPath +
										 '../zpextra/themes/colorpicker/');
	this.defineConfigOption('closeOnDocumentClick', true);

	this.defineConfigOption('langId', Zapatec.ColorPicker.id);
	this.defineConfigOption('lang', "eng");

	Zapatec.ColorPicker.SUPERclass.configure.call(this, objArgs);

	// defines field to protect configuration value from changes
	this.currentColor = this.config.color;

	// Gets button and inputField if they are string ID values
	this.config.button = Zapatec.Widget.getElementById(this.config.button);
	this.config.inputField = Zapatec.Widget.getElementById(this.config.inputField);

	// Predefined colors
	this.allColors = [
			['000000', '003300', '006600', '009900', '00CC00', '00FF00',
			'330000', '333300', '336600', '339900', '33CC00', '33FF00',
			'660000', '663300', '666600', '669900', '66CC00', '66FF00'],
			['000033', '003333', '006633', '009933', '00CC33', '00FF33',
			'330033', '333333', '336633', '339933', '33CC33', '33FF33',
			'660033', '663333', '666633', '669933', '66CC33', '66FF33'],
			['000066', '003366', '006666', '009966', '00CC66', '00FF66',
			'330066', '333366', '336666', '339966', '33CC66', '33FF66',
			'660066', '663366', '666666', '669966', '66CC66', '66FF66'],
			['000099', '003399', '006699', '009999', '00CC99', '00FF99',
			'330099', '333399', '336699', '339999', '33CC99', '33FF99',
			'660099', '663399', '666699', '669999', '66CC99', '66FF99'],
			['0000CC', '0033CC', '0066CC', '0099CC', '00CCCC', '00FFCC',
			'3300CC', '3333CC', '3366CC', '3399CC', '33CCCC', '33FFCC',
			'6600CC', '6633CC', '6666CC', '6699CC', '66CCCC', '66FFCC'],
			['0000FF', '0033FF', '0066FF', '0099FF', '00CCFF', '00FFFF',
			'3300FF', '3333FF', '3366FF', '3399FF', '33CCFF', '33FFFF',
			'6600FF', '6633FF', '6666FF', '6699FF', '66CCFF', '66FFFF'],
			['990000', '993300', '996600', '999900', '99CC00', '99FF00',
			'CC0000', 'CC3300', 'CC6600', 'CC9900', 'CCCC00', 'CCFF00',
			'FF0000', 'FF3300', 'FF6600', 'FF9900', 'FFCC00', 'FFFF00'],
			['990033', '993333', '996633', '999933', '99CC33', '99FF33',
			'CC0033', 'CC3333', 'CC6633', 'CC9933', 'CCCC33', 'CCFF33',
			'FF0033', 'FF3333', 'FF6633', 'FF9933', 'FFCC33', 'FFFF33'],
			['990066', '993366', '996666', '999966', '99CC66', '99FF66',
			'CC0066', 'CC3366', 'CC6666', 'CC9966', 'CCCC66', 'CCFF66',
			'FF0066', 'FF3366', 'FF6666', 'FF9966', 'FFCC66', 'FFFF66'],
			['990099', '993399', '996699', '999999', '99CC99', '99FF99',
			'CC0099', 'CC3399', 'CC6699', 'CC9999', 'CCCC99', 'CCFF99',
			'FF0099', 'FF3399', 'FF6699', 'FF9999', 'FFCC99', 'FFFF99'],
			['9900CC', '9933CC', '9966CC', '9999CC', '99CCCC', '99FFCC',
			'CC00CC', 'CC33CC', 'CC66CC', 'CC99CC', 'CCCCCC', 'CCFFCC',
			'FF00CC', 'FF33CC', 'FF66CC', 'FF99CC', 'FFCCCC', 'FFFFCC'],
			['9900FF', '9933FF', '9966FF', '9999FF', '99CCFF', '99FFFF',
			'CC00FF', 'CC33FF', 'CC66FF', 'CC99FF', 'CCCCFF', 'CCFFFF',
			'FF00FF', 'FF33FF', 'FF66FF', 'FF99FF', 'FFCCFF', 'FFFFFF']
			];

};

Zapatec.ColorPicker.prototype.DEFAULT_SLIDER_WIDTH = 362;


/**
 * Creates HTML for Color Picker
 * @private
 */
Zapatec.ColorPicker.prototype.create = function() {
	var self = this;
	
	// is used to process document onClick
	this.isShown = false;
	this.sizeCalculated = false;

	this.container = Zapatec.Utils.createElement("div");
	document.body.appendChild(this.container);
	this.container.className = this.getClassName({prefix: "zpColorPicker", suffix: "Container"});
	this.container.id = "zpColorPicker" + this.id + "Container";

	// Header DIV
	this.container.header = Zapatec.Utils.createElement("div", this.container);
	this.container.header.className = "header";


	var titleDiv = Zapatec.Utils.createElement("div", this.container.header);
	titleDiv.className = 'title';
	titleDiv.innerHTML = this.config.title?this.config.title:this.getMessage('windowTitle');
	titleDiv.id = "zpColorPicker"+this.id+"Title";

	// make picker window draggable
	if (typeof Zapatec.Utils.Draggable == 'function') {
		new Zapatec.Utils.Draggable(this.container,{
			handler: titleDiv,
			dragCSS:'dragging', 
			onDragInit : function () {
				self.isShown = true;
			},
			onDragMove: function () {
				if (self.WCH) {
					self.WCH.style.left = self.container.style.left;
					self.WCH.style.top = self.container.style.top;
				}
			}
		});
	}

	var closeDiv = Zapatec.Utils.createElement("div", this.container.header);
	closeDiv.className = 'close';
	closeDiv.id = "zpColorPicker"+this.id+"Close";
	closeDiv.onclick = function (){
		self.hide();
	}

	// Palette container
	this.container.fullPalette = Zapatec.Utils.createElement("div", this.container,true);
	this.container.fullPalette.className = "fullPalette";

	// RGB input fields container
	this.container.rgbFields = Zapatec.Utils.createElement("div", this.container,true);
	this.container.rgbFields.className = "rgbFields";

	// RGB input fields
	var inputRedContainer =	Zapatec.Utils.createElement("div", this.container.rgbFields, true);
	inputRedContainer.appendChild(document.createTextNode(this.getMessage('redFieldLabel')));
	this.container.rgbFields.inputRed =	Zapatec.Utils.createElement("input", inputRedContainer, true);
	this.container.rgbFields.inputRed.size = 3;
	this.container.rgbFields.inputRed.maxLength = 3;
	this.container.rgbFields.inputRed.id = "zpColorPicker"+this.id+"InputRedField";

	var inputGreenContainer = Zapatec.Utils.createElement("div", this.container.rgbFields, true);
	inputGreenContainer.appendChild(document.createTextNode(this.getMessage('greenFieldLabel')));
	this.container.rgbFields.inputGreen = Zapatec.Utils.createElement("input", inputGreenContainer, true);
	this.container.rgbFields.inputGreen.size = 3;
	this.container.rgbFields.inputGreen.maxLength = 3;
	this.container.rgbFields.inputGreen.id = "zpColorPicker"+this.id+"InputGreenField";

	var inputBlueContainer = Zapatec.Utils.createElement("div", this.container.rgbFields, true);
	inputBlueContainer.appendChild(document.createTextNode(this.getMessage('blueFieldLabel')));
	
	this.container.rgbFields.inputBlue = Zapatec.Utils.createElement("input", inputBlueContainer, true);
	this.container.rgbFields.inputBlue.size = 3;
	this.container.rgbFields.inputBlue.maxLength = 3;
	this.container.rgbFields.inputBlue.id = "zpColorPicker"+this.id+"InputBlueField";
	
	// Table that contains palette
	
	var imgSrc = Zapatec.ColorPicker.path+'../zpextra/themes/colorpicker/px.gif';
	var paletteTableHTML = [];
	paletteTableHTML.push ('<table class="paletteTable" cellspacing="0" cellpadding="0">');
	paletteTableHTML.push ('<tbody>');
	for (var ii = 0; ii < this.allColors.length; ii++) {
		paletteTableHTML.push ('<tr>');
		for (var jj = 0; jj < this.allColors[ii].length; jj++) {
			if (this.config.singleClick) {
				paletteTableHTML.push ('<td id="zpColorPicker'+this.id+'Palette_'+ii+'_'+jj+'" style="background-color: #'+this.allColors[ii][jj]+'" onclick="Zapatec.Widget.callMethod(\''+this.id+'\',\'cellOnDoubleClick\',\''+this.allColors[ii][jj]+'\');" onmouseover="Zapatec.Widget.callMethod(\''+this.id+'\',\'cellOnMouseOver\',this);" onmouseout="Zapatec.Widget.callMethod(\''+this.id+'\',\'cellOnMouseOut\',this);">' );
			} else {
				paletteTableHTML.push ('<td id="zpColorPicker'+this.id+'Palette_'+ii+'_'+jj+'" style="background-color: #'+this.allColors[ii][jj]+'" onclick="Zapatec.Widget.callMethod(\''+this.id+'\',\'cellOnClick\',\''+this.allColors[ii][jj]+'\');" ondblclick="Zapatec.Widget.callMethod(\''+this.id+'\',\'cellOnDoubleClick\',\''+this.allColors[ii][jj]+'\');" onmouseover="Zapatec.Widget.callMethod(\''+this.id+'\',\'cellOnMouseOver\',this);" onmouseout="Zapatec.Widget.callMethod(\''+this.id+'\',\'cellOnMouseOut\',this);">' );
			}
			paletteTableHTML.push ('<img src="'+ imgSrc +'" id="'+'zpColorPicker'+this.id+'Palette_'+ii+'_'+jj+'image'+'" height="13" width="12">');
			paletteTableHTML.push ('</td>');
		}
		paletteTableHTML.push ('</tr>');
	}
	paletteTableHTML.push ('</tbody>');
	paletteTableHTML.push ('</table>');
	
	this.container.fullPalette.innerHTML = paletteTableHTML.join(""); 

	this.container.colorPreview = Zapatec.Utils.createElement("div", this.container);
	this.container.colorPreview.className = "colorPreview";
	this.container.colorPreview.id = "zpColorPicker"+this.id+"ColorPreview";

	this.container.buttonsContainer = Zapatec.Utils.createElement("div", this.container);
	this.container.buttonsContainer.className = "buttons";
	
	var okButton = Zapatec.Utils.createElement("button", this.container.buttonsContainer);
	okButton.appendChild(document.createTextNode(this.getMessage('okButtonCaption')));
	okButton.id = "zpColorPicker"+this.id+"OkButton";
	okButton.onclick = function () {
		self.setColor(self.container.hexFields.inputHex.value);
		if (self.config.inputField) {
			self.sendValueToinputField();
		}
		self.select();
	}
	var cancelButton = Zapatec.Utils.createElement("button", this.container.buttonsContainer);
	cancelButton.id = "zpColorPicker"+this.id+"CancelButton";
	cancelButton.appendChild(document.createTextNode(this.getMessage('cancelButtonCaption')));
	cancelButton.onclick = function () {
		self.hide();
	}

	this.container.hexFields = Zapatec.Utils.createElement("div", this.container, true);
	this.container.hexFields.className = "hexFields";
	this.container.hexFields.inputHex = Zapatec.Utils.createElement("input", this.container.hexFields, true);
	this.container.hexFields.inputHex.id = "zpColorPicker"+this.id+"InputHexField";
	this.container.hexFields.inputHex.size = 7;
	this.container.hexFields.inputHex.maxLength = 7;

	// Slider containers
	this.container.slidersContainer = Zapatec.Utils.createElement("div", this.container, true);
	this.container.slidersContainer.className = "slidersContainer";
	var slidersTable = Zapatec.Utils.createElement("table", this.container.slidersContainer, true);
	slidersTable.cellPadding = 1;
	slidersTable.cellSpacing = 0;
	var slidersTableBody = Zapatec.Utils.createElement("tbody", slidersTable, true);

	var redSliderRow = Zapatec.Utils.createElement("tr", slidersTableBody, true);
	this.container.slidersContainer.redSliderLabelCol = Zapatec.Utils.createElement("td", redSliderRow);
	this.container.slidersContainer.redSliderLabelCol.appendChild(document.createTextNode(this.getMessage('redFieldLabel')));
	this.container.slidersContainer.redSliderSliderCol = Zapatec.Utils.createElement("td", redSliderRow);

	var greenSliderRow = Zapatec.Utils.createElement("tr", slidersTableBody, true);
	this.container.slidersContainer.greenSliderLabelCol = Zapatec.Utils.createElement("td", greenSliderRow);
	this.container.slidersContainer.greenSliderLabelCol.appendChild(document.createTextNode(this.getMessage('greenFieldLabel')));
	this.container.slidersContainer.greenSliderSliderCol = Zapatec.Utils.createElement("td", greenSliderRow);

	var blueSliderRow = Zapatec.Utils.createElement("tr", slidersTableBody, true);
	this.container.slidersContainer.blueSliderLabelCol = Zapatec.Utils.createElement("td", blueSliderRow);
	this.container.slidersContainer.blueSliderSliderCol = Zapatec.Utils.createElement("td", blueSliderRow);
	this.container.slidersContainer.blueSliderLabelCol.appendChild(document.createTextNode(this.getMessage('blueFieldLabel')));
	
	// Creating sliders (must be here because sliders needs parent elements
	// to be already created)
	this.createSliders();

	// Input fields event handlers
	this.container.rgbFields.inputRed.onkeyup = function(){
		var value = parseInt(this.value);
		if (isNaN(value)) {
			value = 0;
		} else {
			this.value = value;
		}
		if (this.value < 0 ) {
			this.value=0;
		}
		if (this.value > 255 ) {
			this.value=255;
		}
		self.sliders.red.setPos(this.value);
	};
	this.container.rgbFields.inputGreen.onkeyup = function(){
		var value = parseInt(this.value);
		if (isNaN(value)) {
			value = 0;
		}
		if (this.value < 0 ) {
			this.value=0;
		}
		if (this.value > 255 ) {
			this.value=255;
		}
		self.sliders.green.setPos(this.value);
	};
	this.container.rgbFields.inputBlue.onkeyup = function(){
		var value = parseInt(this.value);
		if (isNaN(value)) {
			value = 0;
		}
		if (this.value < 0 ) {
			this.value=0;
		}
		if (this.value > 255 ) {
			this.value=255;
		}
		self.sliders.blue.setPos(this.value);
	};

	this.container.hexFields.inputHex.onchange = function(){
		self.setColor(this.value);
	};

	// Select color handler
	this.container.colorPreview.onclick = function(){
		if (self.config.inputField) {
			self.sendValueToinputField();
		}
		self.select();
	};

  if (this.config.handleButtonClick) {
    // Show/hide picker event
    this.config.button.onclick = function(){
      self.show();
    };
  }

	// Hide picker on Esc key and on click at other document element
	Zapatec.Utils.addEvent(document, 'keypress', function(e) {
		if (!e) {
			e = window.event;
		}
		if (e.keyCode == 27) {
			self.hide();
		}
	});
	if (this.config.closeOnDocumentClick) {
		Zapatec.Utils.addEvent(document, 'click', function() {
			if (!self.isShown) {
				self.hide();
			}
		});
	}

}
/**
 * onClick handler for palette cell
 * @param {Object} color
 */
Zapatec.ColorPicker.prototype.cellOnClick = function (color){
	this.setColor(color);
}

/**
 * onDblClick handler for palette cell
 */
Zapatec.ColorPicker.prototype.cellOnDoubleClick = function (color){
	if (this.config.singleClick) {
		this.setColor(color);
	}
	if (this.config.inputField) {
		this.sendValueToinputField();
	}
	this.select();
}
/**
 * onMouseOver handler for palette cell
 * @param {Object} cell
 * @private
 */
Zapatec.ColorPicker.prototype.cellOnMouseOver = function (cell){
	Zapatec.Utils.removeClass(this.highlightedCell, 'under');
	Zapatec.Utils.addClass(cell,'under');
}
/**
 * onMouseOut handler for palette cell
 * @param {Object} cell
 * @private
 */
Zapatec.ColorPicker.prototype.cellOnMouseOut = function (cell){
		Zapatec.Utils.removeClass(cell,'under');
}

/**
 * Creates sliders and attaches handlers to them
 * @private
 */
Zapatec.ColorPicker.prototype.createSliders = function() {
	var self = this;
	this.sliders = {};
	
	this.sliders.red = new Zapatec.Slider({
		div : this.container.slidersContainer.redSliderSliderCol,
		length : 255,
		start: Zapatec.ColorPicker.convertHexToColorObject(this.currentColor).red,
		step: 1,
		orientation : 'H',
		onChange : function (pos) {
			self.container.rgbFields.inputRed.value = pos;
			self.previewColor();
		},
		newPosition: function(){
			self.isShown = true;
		}
	});
	

	this.sliders.green = new Zapatec.Slider({
		div : this.container.slidersContainer.greenSliderSliderCol,
		length : 255,
		step: 1,
		start: Zapatec.ColorPicker.convertHexToColorObject(this.currentColor).green,
		orientation : 'H',
		onChange : function (pos) {
			self.container.rgbFields.inputGreen.value = pos;
			self.previewColor();
		},
		newPosition: function(){
			self.isShown = true;
		}
	});

	this.sliders.blue = new Zapatec.Slider({
		div : this.container.slidersContainer.blueSliderSliderCol,
		length : 255,
		start: Zapatec.ColorPicker.convertHexToColorObject(this.currentColor).blue,
		step: 1,
		orientation : 'H',
		onChange : function (pos) {
			self.container.rgbFields.inputBlue.value = pos;
			self.previewColor();
		},
		newPosition: function(){
			self.isShown = true;
		}
	});
}



/**
 * Calculates top position for picker container based on position of button.
 * @private
 * @type number
 * @return Top position in pixels
 */
Zapatec.ColorPicker.prototype.calculateTopPos = function() {
	var elementOffset = Zapatec.Utils.getElementOffset(this.config.button);
	var top = elementOffset.top - this.container.clientHeight -
			  this.config.offset;
	if (top <= 0) {
		top = elementOffset.top + this.config.button.clientHeight +
			  this.config.offset;
	}
	return top;
}

/**
 * Calculates left position for picker container based on position of button.
 * @private
 * @type number
 * @return Left position in pixels
 */
Zapatec.ColorPicker.prototype.calculateLeftPos = function() {
	var elementOffset = Zapatec.Utils.getElementOffset(this.config.button);
	var left = elementOffset.left + this.config.button.clientWidth +
			   this.config.offset;
	if ((left + this.container.clientWidth) >= document.body.clientWidth) {
		left =
		elementOffset.left - this.container.clientWidth - this.config.offset;
	}
	if (left <= 0) {
		left = elementOffset.left + this.config.button.clientWidth +
			   this.config.offset;
	}

	return left;
}


Zapatec.ColorPicker.prototype.calculateSize = function () {
	
	var containerWidth;
	
	if (this.sliders.red.container) {
		containerWidth= this.sliders.red.container.offsetWidth;
	} else {
		containerWidth = this.DEFAULT_SLIDER_WIDTH;
//		containerWidth = this.container.slidersContainer.redSliderSliderCol.offsetWidth;
	}

	this.container.slidersContainer.style.width = (containerWidth+this.container.slidersContainer.redSliderLabelCol.offsetWidth) +'px';
	var basicWidth = this.container.slidersContainer.offsetWidth;
	this.container.style.width = (basicWidth + 2)+ 'px';
	
	this.container.header.style.width = (basicWidth - 4)+'px';
	
	this.container.buttonsContainer.style.width = (basicWidth-this.container.fullPalette.offsetWidth-this.container.colorPreview.offsetWidth-4)+'px';
	
	this.container.rgbFields.style.width = (basicWidth-this.container.fullPalette.offsetWidth - 13)+'px';
	this.container.hexFields.style.width = (basicWidth-this.container.fullPalette.offsetWidth - 9)+'px';
	
	
	this.sizeCalculated = true;
}

/**
 * Shows Color Picker
 */
Zapatec.ColorPicker.prototype.show = function () {
	var self = this;
	
	if (!this.sizeCalculated) {
		this.calculateSize();
	}
	
	this.container.style.zIndex = 5000;
	this.container.style.visibility = 'visible';
	this.container.style.left = this.calculateLeftPos() + "px";
	this.container.style.top =  this.calculateTopPos() + "px";
	this.isShown = true;
	// Windowed controls hider
	this.WCH = Zapatec.Utils.createWCH();
	if (this.WCH) {
		this.WCH.style.zIndex = this.container.style.zIndex;
		Zapatec.Utils.setupWCH_el(this.WCH,this.container);
	}
  if (this.config.handleButtonClick) {
    // Attaches hide method to button
    this.config.button.onclick = function(){
      self.hide();
    };
  }
  this.highlightCell();
}


/**
 * Hides ColorPicker
 */
Zapatec.ColorPicker.prototype.hide = function () {
	var self = this;
	this.container.style.visibility = 'hidden';
	this.container.style.left = '-1000px';
	this.container.style.top = '-1000px';
	this.isShown = false;
	if (this.WCH){
		Zapatec.ScrollWithWindow.unregister(this.WCH);
		if (this.WCH.outerHTML) {
			this.WCH.outerHTML = "";
		} else {
			Zapatec.Utils.destroy(this.WCH);
		}
	}
//	Zapatec.Utils.hideWCH(this.WCH);
  if (this.config.handleButtonClick) {
    // Attaches show method to button
    this.config.button.onclick = function() {
      self.show();
    };
  }
}

/**
 * Returns current color from picker.
 * @type string
 * @return Current color, format '#FFFFFF'
 */

Zapatec.ColorPicker.prototype.getColor = function () {
	return this.currentColor;
}

/**
 * Sets current color. Used to handle changes in Hex input field
 * Sets color channels values to sliders positions
 * @private
 * @param [string] Color, format '#FFFFFF' or 'FFFFFF'
 */
Zapatec.ColorPicker.prototype.setColor = function (hexcolor) {
	var color = Zapatec.ColorPicker.convertHexToColorObject(hexcolor);
	this.sliders.red.setPos(color.red);
	this.sliders.green.setPos(color.green);
	this.sliders.blue.setPos(color.blue);
}

/**
 * Displays color preview based on RGB input fields value
 * Sets hex field value and current color
 * @private
 * @param [string] Color, format '#FFFFFF' or 'FFFFFF'
 */
Zapatec.ColorPicker.prototype.previewColor = function () {
	var hexColor = '#' +
		   Zapatec.ColorPicker.convertChannelColorToHex(this.container.rgbFields.inputRed.value) +
		   Zapatec.ColorPicker.convertChannelColorToHex(this.container.rgbFields.inputGreen.value) +
		   Zapatec.ColorPicker.convertChannelColorToHex(this.container.rgbFields.inputBlue.value);
	this.container.colorPreview.style.backgroundColor = hexColor;
	this.container.hexFields.inputHex.value = hexColor;
	this.currentColor = hexColor;
}

/**
 * Highlights palette cell if current color is in predefined colors collection
 * @private
 */
Zapatec.ColorPicker.prototype.highlightCell = function () {
	for (var ii = 0; ii < this.allColors.length; ii++) {
		for (var jj = 0; jj < this.allColors[ii].length; jj++) {
			var cell = document.getElementById('zpColorPicker'+this.id+'Palette_'+ii+'_'+jj);
			if (((this.currentColor.charAt(0) == '#') &&
				(this.currentColor == '#' + this.allColors[ii][jj])) ||
				(this.currentColor == this.allColors[ii][jj])) {
				Zapatec.Utils.addClass(cell,'under');
					this.highlightedCell = cell;
			} else {
				Zapatec.Utils.removeClass(cell,'under');
			}
		}
	}
}

/**
 * Sends selected color value to inputField element
 * If inputField is an INPUT or TEXTAREA - current color is set as its value
 * If inputField is a SELECT - options that corresponds to current color is
 * selected (if present)
 * Otherwise - current color is put into element's innerHtml
 * @private
 */
Zapatec.ColorPicker.prototype.sendValueToinputField = function () {
	if (this.config.inputField != null) {
		var tagName = this.config.inputField.tagName.toUpperCase();
		switch (tagName) {
			case "TEXTAREA":
			case "INPUT":
				this.config.inputField.value = this.currentColor;
				break;
			case "SELECT":
				for(var i = 0; i < this.config.inputField.options.length; i++){
					if (this.config.inputField.options[i].value == this.currentColor){
						this.config.inputField.selectedIndex = i;
						break;
					}
				}

				break;
			default:
				this.config.inputField.innerHTML = this.currentColor;
				break;
		}
	}
}

/**
 * Fires select event
 * Sends current color value to inputField element
 * Hides color picker
 * @private
 */
Zapatec.ColorPicker.prototype.select = function () {
	this.fireEvent('select', this.currentColor);
	this.hide();
}


