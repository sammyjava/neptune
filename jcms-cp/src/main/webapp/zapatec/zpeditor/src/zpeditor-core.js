/**
 *$Id: zpeditor-core.js 17449 2009-05-08 11:54:43Z nmaxim $
 * @fileoverview Basic Rich Text editor (see Midas specification)
 * This file provides functionality to create a new editor out of a given
 * container id and adjust various styles and actual behavior in design mode
 *
 * @link http://www.mozilla.org/editor/midas-spec.html
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
 * Zapatec.MinimalEditor constructor. Creates a new editor object with given
 * parameters.
 *
 * @constructor
 * @extends Zapatec.Widget
 * @param {object} objArgs Editor configuration
 *
 * Constructor recognizes the following properties of the config object
 * \code
 *	property name			| description
 *-------------------------------------------------------------------------------------------------
 *	field    | [string or object] Reference to DOM element to be used as
 *           | prototype for the editor. The editor pane will be created right
 *           | after this element and will take its size.
 * toolbarElements | [array] Array of strings representing toolbar buttons to
 *           | be added to the editor toolbar. The buttons will be added to
 *           | the toolbar in the order they are specified in this array.
 * maximizedBorder | [number] A margin between the editor and the browser window
 *           | border when in maximized mode (pixels)
 * enableTooltips | [boolean] Specifies if toolbar button tooltips are to appear
 * dumpHtml | [boolean] Specifies the way html source is obtained from iframe.
 *          | If set to false innerHtml will be used to get html from design mode.
 *          | If set to true. the html is achieved by manually dumping the root DOM element.
 *          | Default is false.
 * generateXhtml | [boolean] If this option is true the editor will produce
 *          | valid xhtml 1.0 strict
 * customUndo | [boolean] Specifies the way undo works. If this option is true
 *          | a custom JavaScript undo stack will be maintained. Otherwise execCommand
 *          | will be used. Default is true.
 * preserveImgSrc | [boolean] Under IE relative image paths are
 *          | automatically converted to absolute paths. Set this
 *          | option to true in order to pre-process the html every time the
 *          | user switches from HTML to WYSIWYG mode and vice versa. Default is
 *          | true for IE and false otherwise.
 * preserveAnchorHref | [boolean] Under IE relative anchor hrefs are
 *          | automatically converted to absolute href URLs. Set this
 *          | option to true in order to pre-process the html every time the
 *          | user switches from HTML to WYSIWYG mode and vice versa. Default is
 *          | true for IE and false otherwise.
 * externalBrowserNoScript | [boolean] Setting this option to true will remove all
 *          | script tags from html being previewed when "View in external browser window"
 *          | is pressed. Default is false.
 * win      | Existing Zapatec.Win object can be provided to show dialogs.
 *          | Otherwise new window is created.
 * \endcode
 *
 * Constructor recognizes the following strings as elements of toolbarElements
 * array
 * \code
 *	toolbar element name		| description
 *-------------------------------------------------------------------------------------------------
 *	maximize          | A toggle button for maximizing/restoring the editor to full page boundaries
 *	fontName					| A font name select field
 *	fontSize     			| A font size select field
 *	foreColor					| A font color picker button
 *	backColor				  | A background color picker button
 *	insertLink			  | A button for inserting hyperlinks
 *	insertImage			  | A button for inserting images
 *	insertTable			  | A button for inserting tables
 *	insertHorizontalRule | A button for inserting horizontal rules
 *	insertSpecialChar | A button for showing a character map window for selecting a special character to insert
 *	bold		      	  | A button for toggling bold style on selected text
 *	italic			      | A button for toggling italic style on selected text
 *	underline			    | A button for toggling underline style on selected text
 *	justifyLeft		    | A button for making paragraphs left justified
 *	justifyCenter	    | A button for making paragraphs centered
 *	justifyRight	    | A button for making paragraphs right justified
 *	justifyFull  	    | A button for making paragraphs full justified
 *	insertOrderedList | A button for inserting ordered numbered lists
 *	insertUnorderedList | A button for inserting unordered bulleted lists
 *	selectAll         | A button for selecting all editor content
 *	copy              | A copy button
 *	cut               | A cut button
 *	paste             | A paste button
 *	outdent           | A button for decreasing indentation
 *	indent            | A button for increasing indentation
 *	undo              | An undo button
 *	redo              | A redo button
 *	about             | About this editor button
 *	browser           | A button for previewing editor html content in a new browser window
 *	switcher          | A toggle button to switch between HTML and WYSIWYG mode
 *	fetch             | A button for loading editor html content from a remote location
 *	save              | A button for sending editor html content to a remote location
 *	newPanel          | This element will make the next button appear in
 *                    | a new toolbar panel
 *	newRow            | This element will make the next button appear in
 *                    | a new row
 * \endcode
 *
 */
Zapatec.MinimalEditor = function(objArgs) {
	if (arguments.length == 0) {
		objArgs = {};
	}

	// Call constructor of superclass
	Zapatec.MinimalEditor.SUPERconstructor.call(this, objArgs);
}

/**
 * Unique static id of the widget class. Gives ability for Zapatec#inherit to
 * determine and store path to this file correctly when it is included using
 * Zapatec#include. When this file is included using Zapatec#include or path
 * to this file is gotten using Zapatec#getPath, this value must be specified
 * as script id.
 * @private
 */
Zapatec.MinimalEditor.id = 'Zapatec.MinimalEditor';

/**
 * Shortcut for faster access to {@link Zapatec#MinimalEditor}.
 * @private
 * @final
 */
zapatecEditor = Zapatec.MinimalEditor;

// Inherit Zapatec.Widget
Zapatec.inherit(Zapatec.MinimalEditor, Zapatec.Widget);

/**
 * Initializes object.
 *
 * @param {object} objArgs User configuration
 */
Zapatec.MinimalEditor.prototype.init = function(objArgs) {

	// processing Widget functionality
	Zapatec.MinimalEditor.SUPERclass.init.call(this, objArgs);

	this.createEditor();

	this.initEditor();
}

/**
 * Creates editor DOM elements
 * @private
 */
Zapatec.MinimalEditor.prototype.createEditor = function() {
	this.createProperty(this, 'container', null);
	this.createProperty(this, 'editorPanel', null);
	// Holds all created toolbar buttons
	this.buttons = [];
	// Stores created tooltips for buttons
	this.tooltips = [];
	// Stores created color pickers for the 2 color buttons
	this.colorPickers = [];
	// Hides native controls that are under the editor when it is maximized
	this.createProperty(this, 'wch', null);

	this.createProperty(this, 'undo', new Zapatec.MinimalEditor.Undo(this));

	this.doctype = "";
	this.isDefaultFullHtml = true;

	if (Zapatec.is_webkit) {
		this.fillWebKitMap();
	}
	// Get original textarea field dimensions
	var fieldWidth = this.config.field.clientWidth;
	var fieldHeight = this.config.field.clientHeight;

	// Creare a container element
	this.container = Zapatec.Utils.createElement("div");
	this.container.id = 'zpEditor' + this.id + 'Container';

	// Add container element after the original textarea
	Zapatec.Utils.insertAfter(this.config.field, this.container);
	// Copy styles from textarea to our main container
	if (!Zapatec.is_opera) {
		this.container.style.cssText = this.config.field.style.cssText;
	}
	else {
		for (var i in this.config.field.style) {
			try {
				this.container.style[i] = this.config.field.style[i];
			} catch (e) {
			}
		}
	}
	this.config.field.style.position = "static";
	this.config.field.style.left = "";
	this.config.field.style.top = "";
	this.config.field.style.margin = "0";

	// Creare an editor panel element
	this.editorPanel = document.createElement("div");
	this.editorPanel.id = 'zpEditor' + this.id + 'EditorPanel';

	// Add editor panel to the container
	this.container.appendChild(this.editorPanel);
	// Set editor panel style class
	this.editorPanel.className = this.getClassName({prefix: "zpEditor",
		suffix: "EditorPanel"
	});

	// Remove textarea
	this.config.field.parentNode.removeChild(this.config.field);
	// Add textarea inside our container
	this.editorPanel.appendChild(this.config.field);

	// Set textfield style class
	this.config.field.className = this.getClassName({prefix: "zpEditor",
		suffix: "Textarea"
	});

	// Create WCH
	this.wch = Zapatec.Utils.createWCH(this.editorPanel);
	// Put WCH under container
	if (this.wch) {
		this.wch.style.zIndex = -1;
	}

	// Add toolbar buttons
	this.addButtons();

	// Get iframe pane dimensions
	var paneSize = this.getPaneSize(fieldWidth, fieldHeight);

	// Create editor pane
	this.pane = new Zapatec.Pane({
		parent: this.editorPanel,
		containerType: 'iframe',
		width: paneSize.width,
		height: paneSize.height,
		showLoadingIndicator: false
	})
	// Remove iframe border
	this.pane.removeBorder();
	// Set editor pane style class
	this.pane.getContainer().className = this.getClassName({prefix: "zpEditor",
		suffix: "Pane"
	});

	// Set editor dimenisons
	this.setSize(fieldWidth, fieldHeight);

	// Hide html text area
	this.config.field.style.display = "none";

	// set current mode to WYSIWYG(visual formatting)
	this.mode = "WYSIWYG";

	// Disable toolbar buttons
	this.toggleButtons(false);
}

/**
 * Configures the widget. Gets called from init and reconfigure methods of
 * superclass.
 *
 * @private
 * @param {object} objArgs User configuration
 */
Zapatec.MinimalEditor.prototype.configure = function(objArgs) {
	this.defineConfigOption('field');
	this.defineConfigOption('asyncTheme', true);
	this.defineConfigOption('maximizedBorder', 6);
	this.defineConfigOption('toolbarElements', [
					'fontName',
					'fontSize',
					'newPanel',

					'bold',
					'italic',
					'underline',
					'newPanel',

					'foreColor',
					'backColor',
					'insertLink',
					'insertImage',
					'insertTable',
					'insertHorizontalRule',

					'newRow',

					'justifyLeft',
					'justifyCenter',
					'justifyRight',
					'newPanel',

					'insertOrderedList',
					'insertUnorderedList',
					'newPanel',

					'selectall',
					'copy',
					'cut',
					'paste',
					'newPanel',

					'outdent',
					'indent',
					'newPanel',

					'undo',
					'redo',
					'newPanel',

					'switcher',
					'newPanel',

					'about'
					]);

	this.defineConfigOption('langId', Zapatec.MinimalEditor.id);
	this.defineConfigOption('lang', "eng");
	
	this.defineConfigOption('persistKey', null);
	this.defineConfigOption('persistPath', null);

	this.defineConfigOption('externalBrowserWidth', 450);
	this.defineConfigOption('externalBrowserHeight', 350);
	this.defineConfigOption('externalBrowserNoScript', false);

	this.defineConfigOption('enableTooltips', false);

	this.defineConfigOption('fullPage', false);
	this.defineConfigOption('dumpHtml', false);
	this.defineConfigOption('generateXhtml', false);

	this.defineConfigOption('customUndo', true);

	// Maximum key strikes before an undo step is stored
	this.defineConfigOption('maxUndoTypes', 25);
	this.defineConfigOption('maxUndoLevels', 100);

	// Foreground and background colors
	this.defineConfigOption('foreColor', "");
	this.defineConfigOption('backColor', "");

	this.defineConfigOption('preserveImgSrc', Zapatec.is_ie);
	this.defineConfigOption('preserveAnchorHref', Zapatec.is_ie);

	// If set to true toolbar dimensions won't be taken into account
	// when  calculating editor size
	this.defineConfigOption('excludeToolbar', false);

	this.defineConfigOption('documentBodyMargin');
	this.defineConfigOption('documentBodyPadding');
	this.defineConfigOption('disableMultiLine', false);

	this.defineConfigOption('paneSize');

	this.defineConfigOption('linksTarget',  false);
	                                             
	// Zapatec.Win object can be provided to show dialogs
	this.defineConfigOption('win');

	// Call parent method
	Zapatec.MinimalEditor.SUPERclass.configure.call(this, objArgs);

	// Change all toobar element names to lower case
	for (var ii = 0; ii < this.config.toolbarElements.length; ii++) {
		this.config.toolbarElements[ii] = this.config.toolbarElements[ii].toLowerCase();
	}

	// Check if required param "field" is defined
	if (typeof(this.config.field) == "undefined") {
		Zapatec.Log({description: this.getMessage('noTextareaError')});
		return false;
	}

	// Get textarea
	var oTextarea = zapatecWidget.getElementById(this.config.field);
	if (!oTextarea) {
		this.debug(this.getMessage('noTextareaError'));
		return false;
	}
	// Save changed properties to be able to restore them later
	var oTextareaStyle = oTextarea.style;
	this.textareaStyle = {
		position: oTextareaStyle.position,
		left: oTextareaStyle.left,
		top: oTextareaStyle.top,
		margin: oTextareaStyle.margin,
		width: oTextareaStyle.width,
		height: oTextareaStyle.height,
		display: ''
	};
	this.config.field = oTextarea;

	// Check if a DOM element was found for "field" and it's text area
	if (this.config.field == null ||
	    this.config.field.nodeType != 1 ||
	    this.config.field.nodeName.toLowerCase() != "textarea") {
		Zapatec.Log({description: this.getMessage('fieldIsNotTextareaError')})
		return false;
	}

	// Disable tooltips if they are not defined
	if (typeof Zapatec.Tooltip == 'undefined') {
		this.config.enableTooltips = false;
	}
};

/**
 * Turn on design mode for the editor iframe pane
 * @private
 */
Zapatec.MinimalEditor.prototype.initEditor = function(counter) {
	var self = this;
	counter = counter || 0;

	if (this.pane == null || !this.pane.isReady()) {
	    if(counter < 1000){
		    // if less then 10 seconds since editor init and pane is not loaded
		    // yet - try one more time
			setTimeout(function() {
				self.initEditor(++counter)
			}, 100);
		}
		return null;
	}

	// Revalidate editor size
	this.setSize();

	// Install mouse and key listeners
	this.installListeners();

	// Enable design mode
	this.toggleDesignMode(true);

	// copy value from field to editor pane
	this.loadContentFromField();

	// Store an undo step
	this.undo.saveUndo();

	// Enable all toolbar buttons
	this.toggleButtons(true);

	this.fireEvent("onInit");
}

/**
 * Installs key and mouse listeners to the document inside the WYSIWYG editor
 * @private
 */
Zapatec.MinimalEditor.prototype.installListeners = function() {
	var self = this;

	// Handly Enter key manually in IE to write <br> instead of <p>
	if (Zapatec.is_ie) {
		this.pane.getContentElement().onbeforedeactivate = function() {
			self.fireEvent('onBlur', self);

			var sel = self.pane.getContainer().contentWindow.document.selection;
			if (sel) {

				try {
					// Focus editor
					var range = sel.createRange();

					self.oldSelectionRange = range;
				}
				catch(e) {
				}
			}
		}

		// Add focus listener
		Zapatec.Utils.addEvent(this.pane.getIframeDocument().body, 'focus', function() {
			self.fireEvent('focus', self);
		});

		Zapatec.Utils.addEvent(this.pane.getContainer(), 'focus', function() {
		    self.pane.getIframeDocument().body.focus();
		});
	}
	else {
		// Add onBlur listener
		Zapatec.Utils.addEvent(this.pane.getIframeDocument(), 'blur', function() {
			self.fireEvent('onBlur', self);
		});

		// Add focus listener
		Zapatec.Utils.addEvent(this.pane.getIframeDocument(), 'focus', function() {
			self.fireEvent('focus', self);
		});
	}

	// on each keydown event write value to original field
	Zapatec.Utils.addEvent(this.pane.getIframeDocument(), "keydown",
					function(e) {
						var isPrevent = false;

						if (!e) {
							e = self.pane.getIframeDocument().event;
						}

						// Notify undo manager that a key is pressed
						self.undo.onKeyDown();

						switch (e.keyCode) {
							case 13:
								if (self.config.disableMultiLine) {
									// Prevent default handling
									isPrevent = true;
								}

								if (!(e.ctrlKey || e.altKey || e.shiftKey)) {
									// Handle enter key
									var isHandled = self.onEnterPressed();
									if (isHandled) {

										// Prevent default handling
										isPrevent = true;
									}
								};
								break;

						}

						if (isPrevent) {
							// Prevent default handling
							Zapatec.Utils.stopEvent(e);

							return false;
						}

					});

	// on each keyup event write value to original field
	Zapatec.Utils.addEvent(this.pane.getIframeDocument(), "keyup",
					function() {
						self.saveContentToField();
						self.invokeUpdateToolbar();
					});

	// on each click event update toolbar icon states
	Zapatec.Utils.addEvent(this.pane.getIframeDocument(), "click",
					function() {
						self.invokeUpdateToolbar();
					});

	// on each contextmenu event update toolbar icon states
	Zapatec.Utils.addEvent(this.pane.getIframeDocument(), "contextmenu",
					function() {
						self.invokeUpdateToolbar();
					});

}

/**
 * Sets widget size in pixels
 *
 * @public
 * @param {number} width Editor container width
 * @param {number} height Editor container height
 */
Zapatec.MinimalEditor.prototype.setSize = function(width, height) {
	if (!width) {
		width = parseInt(this.container.style.width);
	}
	if (!height) {
		height = parseInt(this.container.style.height);
	}

	// Set container dimensions
	this.container.style.width = width + 'px';
	this.container.style.height = height + 'px';

	if (!this.config.excludeToolbar && this.toolbar) {
		// Set toolbar width
		this.toolbar.style.width = width + 'px';
	}

	// Get iframe pane size
	var paneSize = this.getPaneSize(width, height);
	var paneWidth = paneSize.width;
	var paneHeight = paneSize.height;

	var iframeWidth = paneWidth;
	var iframeHeight = paneHeight;

	if (!Zapatec.is_ie && !Zapatec.is_khtml) {
		iframeHeight -= 4;

		if (!this.isMaximize) {
			iframeWidth -= 4;
		}
	}

	if (Zapatec.is_ie7) {
		iframeWidth -= 1;
		iframeHeight -= 3;
	}

	// Set iframe dimensions
	this.pane.getContainer().style.width = iframeWidth + 'px';
	this.pane.getContainer().style.height = iframeHeight + 'px';

	var editorPanelHeight = paneHeight;
	var editorPanelWidth = width - 2;
	if (!Zapatec.is_ie && !Zapatec.is_khtml) {
		editorPanelHeight -= 4;
	}
	if (Zapatec.is_ie7) {
		editorPanelHeight -= 1;
	}

	// Set editor panel dimensions
	this.editorPanel.style.width = editorPanelWidth + 'px';
	this.editorPanel.style.height = editorPanelHeight + 'px';

	// Setup WCH
	Zapatec.Utils.setupWCH(this.wch, 0, 0, width, paneHeight);

	if (Zapatec.is_ie) {
		paneWidth -= 2;
		paneHeight -= 2;
		if (Zapatec.is_ie7) {
			paneWidth -= 5;
			paneHeight -= 6;
		}
	}
	else {
		if (!Zapatec.is_khtml) {
			if (this.isMaximize) {
				paneHeight -= 5;
			}
			else {
				paneHeight -= 5;
				paneWidth -= 4;
			}
		}
	}
	// Set textarea field dimensions
	this.config.field.style.width = paneWidth + 'px';
	this.config.field.style.height = paneHeight + 'px';
}

/**
 * Gets iframe size in pixels. Extracts toolbar dimensions from whole size
 *
 * @private
 * @param {number} width Editor container width
 * @param {number} height Editor container height
 */
Zapatec.MinimalEditor.prototype.getPaneSize = function(width, height) {

	var paneWidth = width;
	var paneHeight = height;

	// If there are toolbar buttons
	if (!this.config.excludeToolbar && 0 < this.config.toolbarElements.length) {
		paneHeight -= this.toolbar.offsetHeight;

		if (paneHeight < 50) {
			paneHeight = 50;
		}
	}

	if (this.config.paneSize) {
		if (this.config.paneSize.width) paneWidth = this.config.paneSize.width;
		if (this.config.paneSize.height) paneHeight = this.config.paneSize.height;
	}

	if (Zapatec.is_ie) {
		paneWidth -= 2;
	}
	else {
		if (Zapatec.is_khtml) {
			paneWidth -= 2;
		}
		else {
			if (this.isMaximize) {
				paneWidth -= 2;
			}
			else {
				paneWidth += 2;
			}
		}
	}

	return {width: paneWidth, height: paneHeight};
}

/**
 * Loads content from TEXTAREA to editor area
 * @private
 */
Zapatec.MinimalEditor.prototype.loadContentFromField = function() {
	this.setHTML(this.config.field.value);
	// Fix: FF bug for BackSpace
	if (Zapatec.is_gecko && this.pane.getIframeDocument().execCommand) {
		this.pane.getIframeDocument().execCommand("inserthtml", false, "-");
		this.pane.getIframeDocument().execCommand("undo", false, null); 
	}
}

/**
 * Saves value from editor designer area to original TEXTAREA element 
 * @private
 */
Zapatec.MinimalEditor.prototype.saveContentToField = function() {
	if (this.mode == "WYSIWYG") {
		var sVal = this.getHTML()
		var oTextarea = this.config.field;
		if (oTextarea.tagName.toLowerCase() == 'textarea') {
			// For Safari
			// IE raises exception
			try {
				oTextarea.innerHTML = sVal;
			} catch (oException) {};
		}
		oTextarea.value = sVal;
	}
}

/**
 * Toggles design mode for editor
 * @private
 * @param {boolean} enable enable/disable design mode
 */
Zapatec.MinimalEditor.prototype.toggleDesignMode = function(enable) {
	try {
		if (Zapatec.is_ie) {
			this.pane.getContentElement().contentEditable = enable;
		}
		else {
			this.pane.getContainer().contentWindow.document.designMode = enable ? "on" : "off";
		}
	} catch (oException) {};
}

/**
 * Invokes execCommand in a browser compatible way
 * @private
 * @param {string} command command to execute
 * @param {object} arg1 command argument 1
 * @param {object} arg2 command argument 2
 */
Zapatec.MinimalEditor.prototype.execCommand = function(command, arg1, arg2) {
	var object = null;

	if (Zapatec.is_ie) {
		object = this.pane.getIframeDocument();
	}
	else {
		object = this.pane.getContainer().contentWindow.document;
	}

	return object.execCommand(command, arg1, arg2);
}

/**
 * Invokes queryCommandValue in a browser compatible way
 * @private
 * @param {string} command command to query
 */
Zapatec.MinimalEditor.prototype.queryCommandValue = function(command) {
	var object = this.pane.getIframeDocument();
	return object.queryCommandValue(command);
}

/**
 * Invokes queryCommandState in a browser compatible way
 * @private
 * @param {string} command command to query
 */
Zapatec.MinimalEditor.prototype.queryCommandState = function(command) {
	var object = this.pane.getIframeDocument();
	return object.queryCommandState(command);
}

/**
 * Invokes queryCommandEnabled in a browser compatible way
 * @private
 * @param {string} command command to query
 */
Zapatec.MinimalEditor.prototype.queryCommandEnabled = function(command) {
	var object = this.pane.getIframeDocument();
	return object.queryCommandEnabled(command);
}

/**
 * Make the WYSIWYG editor focused
 * @public
 */
Zapatec.MinimalEditor.prototype.focus = function() {
	if (Zapatec.is_khtml || Zapatec.is_opera) {
		// Call focus on the iframe
		this.pane.getContainer().focus();
	}
	else {
		if (Zapatec.is_gecko) {
			// Focus some other element before focusing the editor
			// otherwise focusing might not work
			document.body.focus();
		}
		this.pane.getContainer().contentWindow.focus();
	}
}

/**
 * Make the HTML text area focused
 * @private
 */
Zapatec.MinimalEditor.prototype.focusHtml = function() {
	if (Zapatec.is_ie7) {
		// Store page vertical scroll position
		var scrollTop = Zapatec.Utils.getPageScrollY();
	}
	this.config.field.focus();
	if (Zapatec.is_ie7) {
		// Restore page vertical scroll position
		window.scroll(0, scrollTop);
	}
}

/**
 * Creates toolbar with buttons under editor
 * @private
 */
Zapatec.MinimalEditor.prototype.addButtons = function() {
	if (this.config.toolbarElements.length == 0) {
		return false;
	}

	this.toolbar = document.createElement("table");
	this.toolbar.id = 'zpEditor' + this.id + 'ToolbarTable';
	// Add toolbar before original html textarea field
	this.container.insertBefore(this.toolbar, this.editorPanel);

	this.toolbar.border = 0;
	this.toolbar.className = this.getClassName({prefix: "zpEditor", suffix: "Toolbar"});
	this.toolbar.style.width = this.config.field.clientWidth + 'px';

	var tbody = document.createElement("tbody");
	this.toolbar.appendChild(tbody);

	var tr = document.createElement("tr");
	tbody.appendChild(tr)

	var td = document.createElement("td");
	td.setAttribute("nowrap", "true");
	tr.appendChild(td);

	var span = document.createElement("span");
	span.className = "toolbarPanel";
	td.appendChild(span)

	var self = this;

	// For each element in toolbar config
	for (var ii = 0; ii < this.config.toolbarElements.length; ii++) {
		var element = this.config.toolbarElements[ii];

		// Skip button if not supported in current WebKit version
		if (Zapatec.is_webkit &&
		    Zapatec.webkitVersion && this.webKitMap[element] &&
		    Zapatec.webkitVersion < this.webKitMap[element]) {
			continue;
		}

		switch (element) {
			case "maximize":
				var tooltip = this.getMessage('maximizeTooltip');
				var button = this.createButton("maximize", tooltip, null, function() {
					self.resizeEditor();
					// Focus editor
					self.focus();
				});
				button.id = 'zpEditor' + this.id + 'Maximize';
				span.appendChild(button);
				break;
			case "fontname":
				var fontNameSelect = this.createSelect(
								["Font", "Arial", "Courier", "Times New Roman"],
								["Font", "Arial", "Courier", "Times New Roman"],
								function() {
									self.execCommand("fontname", false, this.options[this.options.selectedIndex].value);
									self.saveContentToField();

									// Focus editor
									self.focus();

									// Store an undo step
									self.undo.saveUndo();

									// Update toolbar icon states
									self.updateToolbar();
								}
								);
				fontNameSelect.id = 'zpEditor' + this.id + 'FontName';
				span.appendChild(fontNameSelect);
				break;
			case "fontsize":
				var fontSizeSelect = this.createSelect(
								["Size", "1", "2", "3", "4", "5", "6", "7"],
								["Size", "1", "2", "3", "4", "5", "6", "7"],
								function() {
									self.execCommand("fontsize", false,
													this.options[this.options.selectedIndex].value);
									self.saveContentToField();

									// Focus editor
									self.focus();

									// Store an undo step
									self.undo.saveUndo();

									// Update toolbar icon states
									self.updateToolbar();
								}
								);
				fontSizeSelect.id = 'zpEditor' + this.id + 'FontSize';
				span.appendChild(fontSizeSelect);
				break;
			case "forecolor":
			// Fall through
			case "backcolor":
				var button = this.createColorButton(element == "forecolor");
				span.appendChild(button);

				break;
			case "insertlink":
				var tooltip = this.getMessage('insertLinkTooltip');
				var button = this.createButton("link", tooltip, function() {
					// Show a insert link window
					self.showInsertLinkWindow();

					// Focus editor
					self.focus();
				});
				button.id = 'zpEditor' + this.id + 'InsertLink';
				span.appendChild(button);
				break;
			case "insertimage":
				var tooltip = this.getMessage('insertImageTooltip');
				var button = this.createButton("image", tooltip, null, function() {
					var text = self.getMessage('insertImagePrompt');
					var imgUrl = prompt(text, "http://");

					if (imgUrl != null && imgUrl != "") {
						self.execCommand("insertimage", false, imgUrl);
						self.saveContentToField();

						// Focus editor
						self.focus();

						// Store an undo step
						self.undo.saveUndo();

						// Update toolbar icon states
						self.updateToolbar();
					}
				});
				button.id = 'zpEditor' + this.id + 'InsertImage';
				span.appendChild(button);
				break;
			case "inserttable":
				var tooltip = this.getMessage('insertTableTooltip');
				var button = this.createButton("table", tooltip, null, function() {

					if (Zapatec.is_khtml) {
						self.storeSelection();
					}

					// Ask for number of rows in table
					var rowsText = self.getMessage('insertTableRowsPrompt');
					var rowsAnswer = prompt(rowsText, 2);
					if (null == rowsAnswer || '' == rowsAnswer) {
						return;
					}
					var rows = parseInt(rowsAnswer);

					// Ask for number of cols in table
					var colsText = self.getMessage('insertTableColsPrompt');
					var colsAnswer = prompt(colsText, 2);
					if (null == colsAnswer || '' == colsAnswer) {
						return;
					}
					var cols = parseInt(colsAnswer);

					// Ask for table border in pixels
					var borderWidthText = self.getMessage('insertTableBorderWidthPrompt');
					var borderAnswer = prompt(borderWidthText, 2);
					if (null == borderAnswer || '' == borderAnswer) {
						return;
					}
					var borderWidth = parseInt(borderAnswer);

					if (isNaN(borderWidth)) {
						borderWidth = 1;
					}

					if (!isNaN(rows) && rows > 0 && !isNaN(cols) && cols > 0) {
						var tbl = self.pane.getIframeDocument().createElement("table");
						tbl.setAttribute("border", borderWidth);
						tbl.setAttribute("cellpadding", "1");
						tbl.setAttribute("cellspacing", "1");

						var tbltbody = self.pane.getIframeDocument().createElement("tbody");

						for (var kk = 0; kk < rows; kk++) {
							var tbltr = self.pane.getIframeDocument().createElement("tr");

							for (var jj = 0; jj < cols; jj++) {
								var tbltd = self.pane.getIframeDocument().createElement("td");
								tbltd.setAttribute("width", 10);

								var tblbr = self.pane.getIframeDocument().createElement("br");
								tbltd.appendChild(tblbr);
								tbltr.appendChild(tbltd);
							}

							tbltbody.appendChild(tbltr);
						}

						tbl.appendChild(tbltbody);

						if (Zapatec.is_khtml) {
							self.restoreSelection();
						}

						self.insertNodeAtSelection(tbl);
					}

					self.saveContentToField();

					// Focus editor
					self.focus();

					// Store an undo step
					self.undo.saveUndo();

					// Update toolbar icon states
					self.updateToolbar();
				});
				button.id = 'zpEditor' + this.id + 'InsertTable';
				span.appendChild(button);
				break;
			case "inserthorizontalrule":
				var tooltip = this.getMessage('insertHorizontalRule');
				var button = this.createButton("hr", tooltip, function() {

					var hr = self.pane.getIframeDocument().createElement("hr");
					self.insertNodeAtSelection(hr);

					self.saveContentToField();

					// Focus editor
					self.focus();

					// Store an undo step
					self.undo.saveUndo();

					// Update toolbar icon states
					self.updateToolbar();
				});
				button.id = 'zpEditor' + this.id + 'InsertHorizontalRule';
				span.appendChild(button);
				break;
			case "insertspecialchar":
				var tooltip = this.getMessage('insertSpecialCharacter');
				var button = this.createButton("insertspecial", tooltip,
					function() {
						if (Zapatec.is_khtml) {
							self.storeSelection();
						}
					},
					function() {
						// Show a character map window
						self.showCharMapWindow();
						// Focus editor
						self.focus();
					});
				button.id = 'zpEditor' + this.id + 'InsertSpecialChar';
				span.appendChild(button);
				break;
			case "selectall":
				var tooltip = this.getMessage('selectAllTooltip');
				var button = this.createButton("selectall", tooltip, function() {
					self.execCommand("selectall");

					self.focus();

					// Update toolbar icon states
					self.updateToolbar();
				});
				button.id = 'zpEditor' + this.id + 'SelectAll';
				span.appendChild(button);
				break;
			case "bold":
				var button = this.createButton("bold", "Bold", function() {
					self.execCommand("bold", false, null);
					self.saveContentToField();

					// Focus editor
					self.focus();

					// Store an undo step
					self.undo.saveUndo();

					// Update toolbar icon states
					self.updateToolbar();
				});
				button.id = 'zpEditor' + this.id + 'Bold';
				span.appendChild(button);
				break;
			case "italic":
				var button = this.createButton("italic", "Italic", function() {
					self.execCommand("italic", false, null);
					self.saveContentToField();

					// Focus editor
					self.focus();

					// Store an undo step
					self.undo.saveUndo();

					// Update toolbar icon states
					self.updateToolbar();
				});
				button.id = 'zpEditor' + this.id + 'Italic';
				span.appendChild(button);
				break;
			case "underline":
				var tooltip = this.getMessage('underlineTooltip');
				var button = this.createButton("underline", tooltip, function() {
				self.execCommand("underline", false, null);
				self.saveContentToField();

				// Focus editor
				self.focus();

				// Store an undo step
				self.undo.saveUndo();

				// Update toolbar icon states
				self.updateToolbar();
			});
				button.id = 'zpEditor' + this.id + 'Underline';
				span.appendChild(button);
				break;
			case "justifyleft":
				var tooltip = this.getMessage('justifyLeftTooltip');
				var button = this.createButton("justifyleft", tooltip, function() {
					self.execCommand("justifyleft", false, null);
					self.saveContentToField();

					// Focus editor
					self.focus();

					// Store an undo step
					self.undo.saveUndo();

					// Update toolbar icon states
					self.updateToolbar();
				});
				button.id = 'zpEditor' + this.id + 'JustifyLeft';
				span.appendChild(button);
				break;
			case "justifycenter":
				var tooltip = this.getMessage('justifyCenterTooltip');
				var button = this.createButton("justifycenter", tooltip, function() {
					self.execCommand("justifycenter", false, null);
					self.saveContentToField();

					// Focus editor
					self.focus();

					// Store an undo step
					self.undo.saveUndo();

					// Update toolbar icon states
					self.updateToolbar();
				});
				button.id = 'zpEditor' + this.id + 'JustifyCenter';
				span.appendChild(button);
				break;
			case "justifyright":
				var tooltip = this.getMessage('justifyRightTooltip');
				var button = this.createButton("justifyright", tooltip, function() {
					self.execCommand("justifyright", false, null);
					self.saveContentToField();

					// Focus editor
					self.focus();

					// Store an undo step
					self.undo.saveUndo();

					// Update toolbar icon states
					self.updateToolbar();
				});
				button.id = 'zpEditor' + this.id + 'JustifyRight';
				span.appendChild(button);
				break;
			case "justifyfull":
				var tooltip = this.getMessage('justifyFullTooltip');
				var button = this.createButton("justifyfull", tooltip, function() {
					self.execCommand("justifyfull", false, null);
					self.saveContentToField();

					// Focus editor
					self.focus();

					// Store an undo step
					self.undo.saveUndo();

					// Update toolbar icon states
					self.updateToolbar();
				});
				button.id = 'zpEditor' + this.id + 'JustifyFull';
				span.appendChild(button);
				break;
			case "insertorderedlist":
				var tooltip = this.getMessage('orderedListTooltip');
				var button = this.createButton("orderedlist", tooltip, function() {
					self.execCommand("insertorderedlist", false, null);
					self.saveContentToField();

					// Focus editor
					self.focus();

					// Store an undo step
					self.undo.saveUndo();

					// Update toolbar icon states
					self.updateToolbar();
				});
				button.id = 'zpEditor' + this.id + 'InsertOrderedList';
				span.appendChild(button);
				break;
			case "insertunorderedlist":
				var tooltip = this.getMessage('unorderedListTooltip');
				var button = this.createButton("unorderedlist", tooltip, function() {
					self.execCommand("insertunorderedlist", false, null);
					self.saveContentToField();

					// Focus editor
					self.focus();

					// Store an undo step
					self.undo.saveUndo();

					// Update toolbar icon states
					self.updateToolbar();
				});
				button.id = 'zpEditor' + this.id + 'InsertUnorderedList';
				span.appendChild(button);
				break;
			case "copy":
				var tooltip = this.getMessage('copyTooltip');
				var button = this.createButton("copy", tooltip, function() {
					self.execCommand("copy", false, null);
					self.saveContentToField();

					// Focus editor
					self.focus();
				});
				button.id = 'zpEditor' + this.id + 'Copy';
				span.appendChild(button);
				break;
			case "cut":
				var tooltip = this.getMessage('cutTooltip');
				var button = this.createButton("cut", tooltip, function() {
					self.execCommand("cut", false, null);
					self.saveContentToField();

					// Focus editor
					self.focus();

					// Store an undo step
					self.undo.saveUndo();

					// Update toolbar icon states
					self.updateToolbar();
				});
				button.id = 'zpEditor' + this.id + 'Cut';
				span.appendChild(button);
				break;
			case "paste":
				var tooltip = this.getMessage('pasteTooltip');
				var button = this.createButton("paste", tooltip, function() {
					self.execCommand("paste", false, null);
					self.saveContentToField();

					// Focus editor
					self.focus();

					// Store an undo step
					self.undo.saveUndo();

					// Update toolbar icon states
					self.updateToolbar();
				});
				button.id = 'zpEditor' + this.id + 'Paste';
				span.appendChild(button);
				break;
			case "outdent":
				var tooltip = this.getMessage('outdentTooltip');
				var button = this.createButton("outdent", tooltip, function() {
					self.execCommand("outdent", false, null);
					self.saveContentToField();

					// Focus editor
					self.focus();

					// Store an undo step
					self.undo.saveUndo();

					// Update toolbar icon states
					self.updateToolbar();
				});
				button.id = 'zpEditor' + this.id + 'Outdent';
				span.appendChild(button);
				break;
			case "indent":
				var tooltip = this.getMessage('indentTooltip');
				var button = this.createButton("indent", tooltip, function() {
					self.execCommand("indent", false, null);
					self.saveContentToField();

					// Focus editor
					self.focus();

					// Store an undo step
					self.undo.saveUndo();

					// Update toolbar icon states
					self.updateToolbar();
				});
				button.id = 'zpEditor' + this.id + 'Indent';
				span.appendChild(button);
				break;
			case "undo":
				var tooltip = this.getMessage('undoTooltip');
				var button = this.createButton("undo", tooltip, function() {
					// Restore to previous undo step
					self.undo.undo();

					self.saveContentToField();

					// Focus editor
					self.focus();

					// Update toolbar icon states
					self.updateToolbar();
				});
				button.id = 'zpEditor' + this.id + 'Undo';
				span.appendChild(button);
				break;
			case "redo":
				var tooltip = this.getMessage('redoTooltip');
				var button = this.createButton("redo", tooltip, function() {
					// Restore to next redo step
					self.undo.redo();

					self.saveContentToField();

					// Focus editor
					self.focus();

					// Update toolbar icon states
					self.updateToolbar();
				});
				button.id = 'zpEditor' + this.id + 'Redo';
				span.appendChild(button);
				break;
			case "about":
				var tooltip = this.getMessage('aboutTooltip');
				var button = this.createButton("about", tooltip, null, function() {
					var aboutText = self.getMessage('aboutText');

					alert(aboutText);
				}, "?");
				button.id = 'zpEditor' + this.id + 'About';
				span.appendChild(button);
				break;
			case "fetch":
				var tooltip = this.getMessage('fetchTooltip');
				var button = this.createButton("fetch", tooltip, function() {
					// Store an undo step
					self.undo.saveUndo();

					self.fetch();

					// Store an undo step
					self.undo.saveUndo();

					// Update toolbar icon states
					self.updateToolbar();
				});
				button.id = 'zpEditor' + this.id + 'Fetch';
				span.appendChild(button);
				break;
			case "save":
				var tooltip = this.getMessage('saveTooltip');
				var button = this.createButton("save", tooltip, function() {
					// Store an undo step
					self.undo.saveUndo();

					self.save();

					// Update toolbar icon states
					self.updateToolbar();
				});
				button.id = 'zpEditor' + this.id + 'Save';
				span.appendChild(button);
				break;
			case "browser":
				var tooltip = this.getMessage('browserTooltip');
				var button = this.createButton("browser", tooltip, null, function() {

					var attributes = "status=1, width=" + self.config.externalBrowserWidth +
					                 ", height=" + self.config.externalBrowserHeight +
					                 ", resizable=yes";
					var win = window.open("", "previewWindow", attributes);
					var html = self.getHTML();
					if (!self.config.fullPage) {
						html = '<html><body>' + html + '</body></html>';
					}
					if (self.config.externalBrowserNoScript) {
						html = html.replace(/<script[\s\S]+?<\/script>/gi, '');
					}
					win.document.write(html);
					win.document.close();
				});
				button.id = 'zpEditor' + this.id + 'Browser';
				span.appendChild(button);
				break;
			case "switcher":
				var tooltip = this.getMessage('htmlTooltip');
				var htmlButton = this.createButton("html", tooltip, null, function() {
					if (self.mode == "WYSIWYG") {
						self.switchToHTML();
						var button = this;
						setTimeout(function() {
							htmlButton.style.display = 'none';
							htmlButton.zpEditorWYSIWYGButton.style.display = 'block';
						}, 10);

						// Focus html editor
						self.focusHtml();
					}
				});

				tooltip = this.getMessage('wysiwygTooltip');
				var wysiwygButton = this.createButton("wysiwyg", tooltip, null, function() {
					if (self.mode == "HTML") {
						self.switchToWYSIWYG();

						setTimeout(function() {
							wysiwygButton.style.display = 'none';
							wysiwygButton.zpEditorHTMLButton.style.display = 'block';
						}, 10);

						// Focus editor
						self.focus();
					}
				});

				htmlButton.id = 'zpEditor' + this.id + 'Html';
				wysiwygButton.id = 'zpEditor' + this.id + 'Wysiwyg';

				htmlButton.zpEditorWYSIWYGButton = wysiwygButton;
				wysiwygButton.zpEditorHTMLButton = htmlButton;
				wysiwygButton.style.display = 'none';

				htmlButton.className += " switch";
				wysiwygButton.className += " switch";

				span.appendChild(htmlButton);
				span.appendChild(wysiwygButton);

				break;
			case "newpanel":
				if (span.childNodes.length == 0) {
					// if last created panel is empty - do not add new panel
					continue;
				}

				span = document.createElement("span");
				span.className = "toolbarPanel"
				td.appendChild(span);
				break;
			case "newrow":
				if (td.childNodes.length == 1 && span.childNodes.length == 0) {
					// if last created row is empty - do not add new row
					continue;
				}

				tr = document.createElement("tr");
				tbody.appendChild(tr);
				td = document.createElement("td");
				tr.appendChild(td);
				span = document.createElement("span");
				span.className = "toolbarPanel";
				td.appendChild(span);
				break;
			default:
				Zapatec.Log({description: this.getMessage('unknownToolbarElementError', element)})
		}
	}
}

/**
 * Creates a color drop-down button
 * @private
 * @param {boolean} isForeground If true a foreground color button will be created,
 * otherwise a background color button will be created
 */
Zapatec.MinimalEditor.prototype.createColorButton = function(isForeground) {
	var colorButton = [];
	var self = this;

	// Generate color accessors and button id, name, class, tooltip
	var getter, setter, command, id, strClass, tooltip;
	if (isForeground) {
		getter = function() {
			return self.config.foreColor;
		};
		setter = function(color) {
			self.config.foreColor = color;
		};
		command = "forecolor";
		strClass = "forecolor";
		tooltip = this.getMessage('fontColorTooltip');
		id = 'zpEditor' + this.id + 'ForeColor';
	}
	else {
		getter = function() {
			return self.config.backColor;
		};
		setter = function(color) {
			self.config.backColor = color;
		};

		if (Zapatec.is_ie || Zapatec.is_khtml) {
			command = "backcolor";
		}
		else {
			command = "hilitecolor";
		}
		strClass = "backcolor";
		tooltip = this.getMessage('bgColorTooltip');
		id = 'zpEditor' + this.id + 'BackColor';
	}

	var setColor = function(color) {
		// Change button icon color
		colorButton[0].colorDiv.style.background = color;
		// Store selected foreground color
		setter(color);

		if (Zapatec.is_khtml) {
			self.restoreSelection();
		}

		self.execCommand(command, false, color);
		self.saveContentToField();

		// Focus editor
		self.focus();

		// Store an undo step
		self.undo.saveUndo();

		// Update toolbar icon states
		self.updateToolbar();
	};

	colorButton[0] = this.createButton(strClass, tooltip,
					function(ev) {
						if (Zapatec.is_khtml) {
							self.storeSelection();
						}

						var target = Zapatec.Utils.getTargetElement(ev);
						var isDropAction = target.isDropArrow;
						// Get current color
						var color = getter();
						// A picker is to be shown if arrow is clicked or color is not set yet
						var isShowPicker = isDropAction || null == color || "" == color;
						if (isShowPicker) {
							// Will show color picker on mouse release
							return;
						}
						setColor(color);
					},
					function(ev) {
						var target = Zapatec.Utils.getTargetElement(ev);
						var isDropAction = target.isDropArrow;
						// Get current color
						var color = getter();
						// A picker is to be shown if arrow is clicked or color is not set yet
						var isShowPicker = isDropAction || null == color || "" == color;
						if (isShowPicker) {

							var iColorPicker = isForeground?0:1;
							// Iterate all created color pickers
							for (var i = 0; i <= 1; ++i) {
								var livePicker = self.colorPickers[i];
								// If color picker is already visible
								if (livePicker && livePicker.isShown) {
									// If color picker is for current color button
									if (i == iColorPicker) {
										return;
									}
									livePicker.hide();
								}
							}

							var show = function() {
								// Create new color picker
								var colorPicker = new Zapatec.ColorPicker({
									button: colorButton[0],
									color: color,
									handleButtonClick: false,
									closeOnDocumentClick: false,
									eventListeners:{select: setColor}
								});
								// Show color picker
								colorPicker.show();
								// Store shown color picker for current color button
								self.colorPickers[iColorPicker] = colorPicker;
							};
							// Invoke color picker show later
							setTimeout(show, 100);
						}
					},
					null, true, getter());
	colorButton[0].id = id;
	return colorButton[0];
}


/**
 * Insert DOM element in place of the current selection
 * @private
 * @param {object} insertNode A html DOM reference to insert
 */
Zapatec.MinimalEditor.prototype.insertNodeAtSelection = function(insertNode) {
	if (Zapatec.is_ie) {
		var self = this;
		setTimeout(function() {
			var sel = self.pane.getContainer().contentWindow.document.selection;
			var range = sel.createRange();
			range.pasteHTML(insertNode.outerHTML);
		}, 10);
	}
	else {
		if (Zapatec.is_khtml) {
			var sel;
			if (this.oldSelection) {
				sel = this.oldSelection;
			}
			else {
				sel = this.pane.getContainer().contentWindow.getSelection();
			}
			var range = this.pane.getContainer().contentWindow.document.createRange();

			var isRangeSet = false;
			if (sel.baseNode == sel.extentNode && sel.baseOffset == sel.extentOffset) {
				if (sel.type == "Range") {
					range.setStartBefore(sel.baseNode);
					range.setEndAfter(sel.extentNode);
					isRangeSet = true;
				}
			}
			if (!isRangeSet) {
				range.setStart(sel.baseNode, sel.baseOffset);
				range.setEnd(sel.extentNode, sel.extentOffset);
			}
		}
		else {
			var sel = this.pane.getContainer().contentWindow.getSelection();
			var range = sel.getRangeAt(0);
			sel.removeAllRanges();
		}

		range.deleteContents();

		var container = range.startContainer;
		var pos = range.startOffset;
		var doc = this.pane.getIframeDocument();
		range = doc.createRange();

		if (container.nodeType == 3 && insertNode.nodeType == 3) {
			container.insertData(pos, insertNode.nodeValue);
			range.setEnd(container, pos + insertNode.length);
			range.setStart(container, pos + insertNode.length);
		}
		else {
			var afterNode;
			if (container.nodeType == 3) {
				var textNode = container;
				container = textNode.parentNode;
				var text = textNode.nodeValue;

				var textBefore = text.substr(0, pos);
				var textAfter = text.substr(pos);

				var beforeNode = doc.createTextNode(textBefore);
				afterNode = doc.createTextNode(textAfter);

				container.insertBefore(afterNode, textNode);
				container.insertBefore(insertNode, afterNode);
				container.insertBefore(beforeNode, insertNode);

				container.removeChild(textNode);
			}
			else {
				afterNode = container.childNodes[pos];
				container.insertBefore(insertNode, afterNode);

				if (!afterNode) {
					// Move carret after currently inserted node
					range.setEnd(insertNode, 1);
					range.setStart(insertNode, 1);
				}
			}

			if (afterNode) {
				// Move carret at the node after currently inserted node
				range.setEnd(afterNode, 0);
				range.setStart(afterNode, 0);
			}
		}

		if (sel.addRange) {
			sel.addRange(range);
		}
	}
}

/**
 * Set a given html inside the editor
 * @public
 * @param {string} html A html content to set inside the editor
 */
Zapatec.MinimalEditor.prototype.setHTML = function(html) {
	if (this.mode == "WYSIWYG") {
	    if(!this.pane.ready){
			var self = this;
			this.pane.addEventListener("onReady", function(){self.setHTML(html)}, true);
			return;
		}

		if (this.config.fullPage) {
			this.setFullHTML(html);
		}
		else {
			this.setBodyHTML(html);
		}

		// If editor is configured to maintain a body margin
		if (this.config.documentBodyMargin) {
			this.pane.getIframeDocument().body.style.margin = this.config.documentBodyMargin;
		}
		// If editor is configured to maintain a body padding
		if (this.config.documentBodyPadding) {
			this.pane.getIframeDocument().body.style.padding = this.config.documentBodyPadding;
		}
	}
	else {
		// Set html inside the HTML textfield
		var oTextarea = this.config.field;
		if (oTextarea.tagName.toLowerCase() == 'textarea') {
			// For Safari
			// IE raises exception
			try {
				oTextarea.innerHTML = html;
			} catch (oException) {};
		}
		oTextarea.value = html;
	}
}

/**
 * Gets html content inside the editor
 * @public
 */
Zapatec.MinimalEditor.prototype.getHTML = function() {
	var html;
	if (this.mode == "WYSIWYG") {
		if (this.config.fullPage) {
			html = this.getFullHTML();
		}
		else {
			html = this.getBodyHTML();
		}
	}
	else {
		html = this.config.field.value;
	}
	return	html;
}

/**
 * Set a given html inside the body tag of the WYSIWYG editor
 * @private
 * @param {string} html content to set inside the body tag
 */
Zapatec.MinimalEditor.prototype.setBodyHTML = function(html) {
    if(!this.pane.isReady){
		var self = this;
    	this.pane.addEventListener("onReady", function(){self.setBodyHTML(html)}, true);
    	return;
    }

	html = this.massageHTML(html);
	this.pane.getIframeDocument().body.innerHTML = html;
}

/**
 * Set a full html (including <html> tags) inside the WYSIWYG editor
 * @private
 * @param {string} html Full html content to set inside the editor
 */
Zapatec.MinimalEditor.prototype.setFullHTML = function(html) {
	html = this.massageHTML(html);

	var doctypeRegExp = /(<!doctype((.|\n|\r)*?)>)\n?/i;
	// If html starts with a doctype
	if (html.match(doctypeRegExp)) {
		this.doctype = RegExp.$1;
		// Remove doctype from full html
		html = html.replace(doctypeRegExp, "");
	}
	else {
		this.doctype = "";
	}

	var doc = this.pane.getIframeDocument();
	if (Zapatec.is_ie) {
		doc.open();
		doc.write(html);
		doc.close();
		doc.body.contentEditable = true;

		// Install mouse and key listeners
		this.installListeners();
	}
	else {
		var headRegExp = /<head[^>]*>((.|\n|\r)*?)<\/head>/i;
		// If html contains a head tag
		if (html.match(headRegExp)) {
			var elHead = doc.getElementsByTagName("head")[0];
			if (Zapatec.is_khtml) {
				// Can't set head in Safari
				/*var par = elHead.parentNode;
				par.removeChild(elHead);
				var newHead = doc.createElement('head');
				alert(RegExp.$1);
				newHead.outerHtml = RegExp.$0;
				par.insertBefore(newHead, doc.body);*/
			}
			else {
				elHead.innerHTML = RegExp.$1;
			}
		}
		// If html contains a body tag
		var bodyRegExp = /(<body[^>]*>)((.|\n|\r)*?)<\/body>/i;
		var res = html.match(bodyRegExp);
		var body = RegExp.$1;
		var inBodyHtml = RegExp.$2;
		if (res) {
			this.setBodyHTML(inBodyHtml);
		}
		else {
			// No body tag
			// Assume plain html is provided and use it instead
			this.setBodyHTML(html);
			return;
		}

	  body = body.replace(/>$/, "/>");

		// Parse body html tag to extract attributes
		Zapatec.Transport.parseXml({
			strXml: body,
			onLoad: function(oDoc) {
				var htmlBody = oDoc.documentElement;
				var htmlBodyAttrs = htmlBody.attributes;

				// Apply body attributes from html to our document body
				for (var i = 0; i < htmlBodyAttrs.length; ++i) {
					var attr = htmlBodyAttrs.item(i);
					if (!attr.specified) {
						continue;
					}
					var name = attr.nodeName;
					var value = attr.nodeValue;
					// Apply current attirubte to document body
					doc.body.setAttribute(name, value);
				}

				// Remove document body attributes not found in html body
				var docBodyAttrs = doc.body.attributes;
				for (var i = 0; i < docBodyAttrs.length; ++i) {
					var attr = docBodyAttrs.item(i);
					if (!attr.specified) {
						continue;
					}
					var name = attr.nodeName;
					var value = attr.nodeValue;
					// If current document body attribute is not found in html body
					if (!htmlBody.getAttribute(name)) {
						doc.body.removeAttribute(name);
					}
				}
			}
		});
	}

	this.isDefaultFullHtml = false;
}

/**
 * Gets full html content (including <html> tags) that is currently in the WYSIWYG editor
 * @private
 */
Zapatec.MinimalEditor.prototype.getFullHTML = function() {
	var html = "";
	if ("" != this.doctype) {
		html += this.doctype + "\n";
	}

	var root = this.pane.getIframeDocument().documentElement;
	if (this.config.dumpHtml) {
		html += dump.getHTML(root, true, 0);
	}
	else {
		html += root.innerHTML;

		// Opera doesn't close the body tag
		if (Zapatec.is_opera) {
			// If closing body tag is missing
			var bodyExp = /<\/body>/i;
			if (!html.match(bodyExp)) {
				// Add a closing body tag
				html += "</BODY>";
			}
		}
		if (Zapatec.is_ie) {
			var contentEditableExp = /(<body[^>]*)( contentEditable=true)([^>]*>)/gi;
			html = html.replace(contentEditableExp, "$1$3");
		}

		// Surround html with openning and closing <html> tags
		html = "<html>" + html + "</html>";
	}

	if (this.isDefaultFullHtml || Zapatec.is_khtml) {
		var headRegExp = /<head[^>]*>((.|\n|\r)*?)<\/head>/i;
		// Remove default html header from full html
		html = html.replace(headRegExp, "<head></head>");
	}

	if (this.isDefaultFullHtml) {
		var onLoadRegExp = /(<body[^>]*)( onload=\"?init\(\);\"?)([^>]*>)/gi;
		html = html.replace(onLoadRegExp, "$1$3");
	}

	html = this.unmassageHTML(html);

	return html;
}

/**
 * Gets html inside the body tag of the WYSIWYG editor
 * @private
 */
Zapatec.MinimalEditor.prototype.getBodyHTML = function() {
	var html;
	if (this.config.dumpHtml) {
		html = dump.getHTML(this.pane.getIframeDocument().body, false, 0);
	}
	else {
		html = this.pane.getContentElement().innerHTML;
	}

	html = this.unmassageHTML(html);

	return html;
}

/**
 * Removes custom html attributes from html and prepare it to be passed to the user
 * @private
 * @param {string} html html to process
 */
Zapatec.MinimalEditor.prototype.unmassageHTML = function(html) {
	if (this.config.preserveImgSrc) {
		// Replace src attribute with the value of the respective _zpSrc attribute
		// in every img. Remove _zpSrc attribute
		html = html.replace(/(<img[^>]+)(src=("|')[^"']*\3)([^>]*)(_zpSrc=("|')([^"']*)\6)([^>]*>)/gi,
						"$1src=$3$7$3$4$8");
		html = html.replace(/(<img[^>]+)(_zpSrc=("|')([^"']*)\3)([^>]*)(src=("|')[^"']*\7)([^>]*>)/gi,
						"$1src=$3$4$3$5$8");
	}
	if (this.config.preserveAnchorHref) {
		// Replace href attribute with the value of the respective _zpHref attribute
		// in every img. Remove _zpHref attribute
		html = html.replace(/(<a[^>]+)(href=("|')[^"']*\3)([^>]*)(_zpHref=("|')([^"']*)\6)([^>]*>)/gi,
						"$1href=$3$7$3$4$8");
		html = html.replace(/(<a[^>]+)(_zpHref=("|')([^"']*)\3)([^>]*)(href=("|')[^"']*\7)([^>]*>)/gi,
						"$1href=$3$4$3$5$8");
	}
	// If we need xhtml output
	if (this.config.generateXhtml) {
		html = html2Xhtml.convert(html);
	}
	return html;
}

/**
 * Adds custom html attributes to html to preserve relative links and images
 * @private
 * @param {string} html html to process
 */
Zapatec.MinimalEditor.prototype.massageHTML = function(html) {
	if (this.config.preserveImgSrc) {
		// Add additional _zpSrc attribute to every <img> element using the same
		// value as the src attribute
		html = html.replace(/(<img[^>]+)(src=("|')([^"']*)\3)([^>]*>)/gi,
						"$1$2 _zpSrc=$3$4$3 $5");
	}
	if (this.config.preserveAnchorHref) {
		// Add additional _zpHref attribute to every <a> element using the same
		// value as the href attribute
		html = html.replace(/(<a[^>]+)(href=("|')([^"']*)\3)([^>]*>)/gi,
						"$1$2 _zpHref=$3$4$3 $5");
	}
	return html;
}

/**
 * Switch editor to HTML mode
 * @private
 */
Zapatec.MinimalEditor.prototype.switchToHTML = function() {
	if (this.mode != "WYSIWYG") {
		return false;
	}

	var html = this.getHTML();

	this.mode = "HTML";
	this.toggleButtons(false);

	this.setHTML(html);

	// show original field
	this.config.field.style.display = '';

	// hide editable iframe
	if (Zapatec.is_khtml) {
		this.pane.getContainer().style.visibility = "hidden";
		// Store pane height
		this.pane.getContainer().hiddenHeight = this.pane.getContainer().style.height;
		// Make pane with 0 height
		this.pane.getContainer().style.height = "0";
	}
	else {
		this.pane.getContainer().style.display = "none";
	}
}

/**
 * Switch editor to WYSIWYG mode
 * @private
 */
Zapatec.MinimalEditor.prototype.switchToWYSIWYG = function() {
	if (this.mode != "HTML") {
		return false;
	}

	var html = this.getHTML();

	this.mode = "WYSIWYG";

	// Enable all toolbar buttons
	this.toggleButtons(true);
	this.setHTML(html);

	// hide original field
	this.config.field.style.display = "none";

	// show editable iframe
	if (Zapatec.is_khtml) {
		this.pane.getContainer().style.visibility = "";
		// Restore pane height
		this.pane.getContainer().style.height = this.pane.getContainer().hiddenHeight;
	}
	else {
		this.pane.getContainer().style.display = "block";
	}
}

/**
 * Creates a new toolbar button after the last one
 * @private
 * @param buttonClass - [string] A css class to apply to the button
 * @param tooltip - [string] Tooltip text
 * @param func - [function] An action handler function the be attached
 * @param isOnMouseDown - [boolean] If true the action will be triggered on
 * mouse down, otherwise it will trigger on click. Default is true.
 * @param buttonTitle - [string] Button text
 */
Zapatec.MinimalEditor.prototype.createButton = function(buttonClass,
                                                        tooltip, downAction, clickAction, text,
                                                        isDropDown, color) {
	// If text param is not specified
	if (null == text) {
		text = "";
	}

	var params = {
		theme: this.config.theme,
		themePath: this.config.themePath,
		text: text,
	//		image: this.config.themePath + "px.gif",
		className: "zpEditorButton " + buttonClass,
		repeatEnabled: false
	};

	if (isDropDown) {
		var img = Zapatec.zapatecPath + "../zpeditor/themes/" + this.config.theme + '/dropdown.gif';
		params.image = img;
	}

	// Attach downAction if any
	if (downAction) {
		params.downAction = downAction;
	}
	// Attach clickAction if any
	if (clickAction) {
		params.clickAction = clickAction;
	}

	// Create a new button
	var button = new Zapatec.Button(params);
	this.createProperty(button.getContainer(), "button", button);
	if (isDropDown) {
		button.img.isDropArrow = true;
		// Create a div that represents current color
		var colorDiv = document.createElement("img");
		// Set color div style
		Zapatec.Utils.addClass(colorDiv, this.getClassName({
			prefix: "zpEditor",
			suffix: "ColorMark"
		}));
		button.internalContainer.insertBefore(colorDiv, button.img);

		// Attach color marker element to its respective button
		this.createProperty(button.getContainer(), "colorDiv", colorDiv);
		// Set initial color of color marker
		if (color) {
			colorDiv.background = color;
		}

		// Set correct style of drop down button
		Zapatec.Utils.addClass(button.getContainer(), this.getClassName({
			prefix: "zpButton",
			suffix: "Container"
		}));
		Zapatec.Utils.removeClass(button.getContainer(), this.getClassName({
			prefix: "zpButtonImage",
			suffix: "Container"
		}));

		// Set correct style of drop down arrow image
		Zapatec.Utils.addClass(button.img, this.getClassName({
			prefix: "zpEditor",
			suffix: "DropDown"
		}));
	}

	// Create tooltip
	if (tooltip && this.config.enableTooltips) {
		var div = document.createElement("div");
		div.innerHTML = tooltip;
		var objTooltip = new Zapatec.Tooltip({
			target: button.container,
			tooltip: div,
			parent: this.container
		});

		this.tooltips.push(objTooltip);
	}

	this.buttons.push(button);

	return button.getContainer();
}

/**
 * Help function for creating selects
 * @private
 * @param {array} options Array of string options to appear inside the select
 * @param {array} values Array of values to be associated with each option
 * @param {function} func A select onChange handler function to be attached
 */
Zapatec.MinimalEditor.prototype.createSelect = function(options, values, func) {
	if (options.length != values.length) {
		Zapatec.Log({description: this.getMessage('optionsNotEqualValuesError')});
		return null;
	}

	var select = document.createElement("select");
	select.tabindex = 0;
	select.className = "zpEditorSelect";
	for (var ii = 0; ii < options.length; ii++) {
		select.options[ii] = new Option(options[ii], values[ii])
	}

	select.onchange = func;

	return select;
}

/**
 * Enable/disable all buttons in the toolbar except the HTML/WYSIWYG switcher
 *
 * @private
 * @param {boolean} enable true to enable, false to disable
 */
Zapatec.MinimalEditor.prototype.toggleButtons = function(enable) {
	for (var ii = 0; ii < this.buttons.length; ii++) {
		var button = this.buttons[ii];

		var className = button.getContainer().className;
		// Skip HTML/WYSIWYG toggle buttons
		if (/switch/.test(className)) {
			continue;
		}

		if (enable) {
			button.enable();
		}
		else {
			button.disable();
		}
	}
}

/**
 * Gets a toolbar button given its id
 *
 * @private
 * @param {string} id button id
 */
Zapatec.MinimalEditor.prototype.getButton = function(id) {
	for (var ii = 0; ii < this.buttons.length; ii++) {
		var button = this.buttons[ii];

		var currentId = button.getContainer().id;
		if (currentId == id) {
			return button;
		}

	}
	return null;
}

/**
 * Handles Enter key pressed event. Deletes currently selected text and inserts
 * a &lt;br&gt; tag. This handler is attached only in IE where Enter produces
 * a &lt;p&gt; rather than &lt;br&gt; tag
 * @private
 */
Zapatec.MinimalEditor.prototype.onEnterPressed = function() {
    if(!Zapatec.is_ie){
    	return false;
    }

	var iframeDocument = this.pane.getIframeDocument();
	if (typeof iframeDocument.selection != 'undefined') {
		var selection = iframeDocument.selection;

		if (selection.type.toLowerCase() == 'control') {
			// Delete selection
			selection.clear();
		}

		var range = selection.createRange();

		// If we are inside an ordered/bulleted list
		if (iframeDocument.queryCommandState('InsertOrderedList') ||
		    iframeDocument.queryCommandState('InsertUnorderedList')) {
			return false;
		}

		// Insert <br>
		range.pasteHTML('<br>');

		// Move cursor after <br>
		range.collapse(false);
		range.select();

		return true;
	}

	return false;
}

/**
 * Maximizes and Restores the editor frame.  The icon is updated as
 * needed.
 *
 * @param {boolean} isMaximize if true the editor iframe is to be maximized,
 * otherwise it is to be restored to its original state. If omitted the function
 * will act as a toggle inverting the maximize state in each call.
 * @private
 */
Zapatec.MinimalEditor.prototype.resizeEditor = function() {

	var isMaximize;
	if (!this.maximizer) {
		this.maximizer = new Zapatec.Utils.Maximizable({
			container: this.container,
			maximizedBorder: this.config.maximizedBorder
		});
		var self = this;
		// Attach to onBeforeMaximize events
		this.maximizer.addEventListener('onBeforeMaximize', function(restoreState) {

			// Store editor panel size
			restoreState.editorPanelRestorer = new Zapatec.SRProp(self.editorPanel);
			restoreState.editorPanelRestorer.saveProps("style.width", "style.height");

			// Store pane size
			restoreState.paneRestorer = new Zapatec.SRProp(self.pane.getContainer());
			restoreState.paneRestorer.saveProps("style.width", "style.height");

			// Store field size
			restoreState.fieldRestorer = new Zapatec.SRProp(self.config.field);
			restoreState.fieldRestorer.saveProps("style.width", "style.height");

			// Store toolbar width
			restoreState.toolbarRestorer = new Zapatec.SRProp(self.toolbar);
			restoreState.toolbarRestorer.saveProps("style.width");
		});

		// Attach to onAfterRestore events
		this.maximizer.addEventListener('onAfterRestore', function(restoreState) {

			// Restore editor panel size
			restoreState.editorPanelRestorer.restoreProps("style.width", "style.height");

			// Restore iframe size
			restoreState.paneRestorer.restoreProps("style.width", "style.height");

			// Restore text area size
			restoreState.fieldRestorer.restoreProps("style.width", "style.height");

			// Restore toolbar width
			restoreState.toolbarRestorer.restoreProps("style.width");
		});

		// Attach to onAfterSize events
		this.maximizer.addEventListener('onAfterSize', function(width, height) {
			self.setSize(width, height);
		});

		isMaximize = true;
	}
	else {
		isMaximize = !this.maximizer.isMaximized;
	}

	this.maximizer.setMaximized(isMaximize);

	// Enumerate all toolbar buttons
	for (var ii = 0; ii < this.buttons.length; ii++) {
		var button = this.buttons[ii];

		var buttonClass = button.config.className;

		if (-1 != buttonClass.indexOf('maximize')) {
			if (isMaximize) {
				Zapatec.Utils.removeClass(button.internalContainer, 'maximize');
				Zapatec.Utils.addClass(button.internalContainer, 'restore');
			}
			else {
				Zapatec.Utils.removeClass(button.internalContainer, 'restore');
				Zapatec.Utils.addClass(button.internalContainer, 'maximize');
			}
			break;
		}
	}
}

/**
 * Gets the key under which the html content is to be saved/fetched server-side
 *
 * @public
 */
Zapatec.MinimalEditor.prototype.getPersistKey = function() {
	// If persist key is assigned by user
	if (null != this.config.persistKey) {
		// Return it
		return this.config.persistKey;
	}

	var persistKeyInput = document.getElementById("persistKey");
	if (null != persistKeyInput) {
		return persistKeyInput.value;
	}

	return null;
}

/**
 * Sets the key under which the html content is to be saved/fetched server-side
 *
 * @public
 * @param {string} persistKey A key under which the html content is to be
 * saved/fetched server-side
 */
Zapatec.MinimalEditor.prototype.setPersistKey = function(persistKey) {
	this.config.persistKey = persistKey;
}

/**
 * Saves the editor content to a remote server.
 *
 * @public
 */
Zapatec.MinimalEditor.prototype.save = function() {
	var key = this.getPersistKey();

	if (null == key || 0 == key.length) {
		return false;
	}

	var url = this.config.persistPath + "?key=" + escape(key) + '&r=' + Math.random();
	var self = this;

	Zapatec.Transport.fetch({
		url: url,
		method: "POST",
		content: "content=" + escape(self.getHTML()),
		onLoad: function(result) {
		},
		onError: function(error) {
			switch (error.errorCode) {
				case 404:
					alert(self.getMessage('noSuchFileError'));
					break;
				case 403:
					alert(self.getMessage('writeAccessForbiddenError'));
					break;
				default:
					alert(self.getMessage('fetchError', error.errorCode, 
									error.errorDescription));
			}
		}
	});

	return true;
};

/**
 * Loads editor content from a remove server
 *
 * @public
 */
Zapatec.MinimalEditor.prototype.fetch = function() {
	var key = this.getPersistKey();

	if (null == key || 0 == key.length) {
		return false;
	}

	var url = this.config.persistPath + "?key=" + escape(key) + '&r=' + Math.random();

	var self = this;
	Zapatec.Transport.fetch({
		url: url,
		method: "GET",
		onLoad: function(result) {
			// Unescape unicode characters
			var html = self.unicodeToText(result.responseText);
			self.setHTML(html);
		},
		onError: function(error) {
			switch (error.errorCode) {
				case 404:
					alert(self.getMessage('noSuchFileError'));
					break;
				case 403:
					alert(self.getMessage('readAccessForbiddenError'));
					break;
				default:
					alert(self.getMessage('fetchError', error.errorCode,
									error.errorDescription));
			}
		}
	});

	return true;
};

/**
 * Converts text in for of %u0075%u006e%u0069%u0063%u006f%u0064%u0065
 * to its text un-escaped equivalent
 *
 * @param {string} escapedUnicodeText text to convert
 * @private
 */
Zapatec.MinimalEditor.prototype.unicodeToText = function(escapedUnicodeText) {
	if (-1 == escapedUnicodeText.indexOf("%u")) {
		// Nothing to un-escape
		return escapedUnicodeText;
	}
	escapedUnicodeText = escapedUnicodeText.replace(/%u/g, "\\u");

	// If there are quotes in string
	if (-1 != escapedUnicodeText.indexOf("\"")) {
		// Escape quotes before passing to eval to avoid JS error
		escapedUnicodeText = escapedUnicodeText.replace(/\"/g, "&quot;");
	}
	var text = eval("\"" + escapedUnicodeText + "\"");
	return text;
}

/**
 * Shows a special character input window
 *
 * @public
 */
Zapatec.MinimalEditor.prototype.showCharMapWindow = function() {
	// If character map windows is not yet closed
	if (this.characterMapWindow) {
		return;
	}

	var characters =
					[
									'&Yuml;', '&scaron;', '&#064;', '&quot;', '&iexcl;', '&cent;', '&pound;', '&curren;', '&yen;', '&brvbar;',
									'&sect;', '&uml;', '&copy;', '&ordf;', '&laquo;', '&not;', '&macr;', '&deg;', '&plusmn;', '&sup2;',
									'&sup3;', '&acute;', '&micro;', '&para;', '&middot;', '&cedil;', '&sup1;', '&ordm;', '&raquo;', '&frac14;',
									'&frac12;', '&frac34;', '&iquest;', '&times;', '&Oslash;', '&divide;', '&oslash;', '&fnof;', '&circ;',
									'&tilde;', '&ndash;', '&mdash;', '&lsquo;', '&rsquo;', '&sbquo;', '&ldquo;', '&rdquo;', '&bdquo;',
									'&dagger;', '&Dagger;', '&bull;', '&hellip;', '&permil;', '&lsaquo;', '&rsaquo;', '&euro;', '&trade;',
									'&Agrave;', '&Aacute;', '&Acirc;', '&Atilde;', '&Auml;', '&Aring;', '&AElig;', '&Ccedil;', '&Egrave;',
									'&Eacute;', '&Ecirc;', '&Euml;', '&Igrave;', '&Iacute;', '&Icirc;', '&Iuml;', '&ETH;', '&Ntilde;',
									'&Ograve;', '&Oacute;', '&Ocirc;', '&Otilde;', '&Ouml;', '&reg;', '&times;', '&Ugrave;', '&Uacute;',
									'&Ucirc;', '&Uuml;', '&Yacute;', '&THORN;', '&szlig;', '&agrave;', '&aacute;', '&acirc;', '&atilde;',
									'&auml;', '&aring;', '&aelig;', '&ccedil;', '&egrave;', '&eacute;', '&ecirc;', '&euml;', '&igrave;',
									'&iacute;', '&icirc;', '&iuml;', '&eth;', '&ntilde;', '&ograve;', '&oacute;', '&ocirc;', '&otilde;',
									'&ouml;', '&divide;', '&oslash;', '&ugrave;', '&uacute;', '&ucirc;', '&uuml;', '&yacute;', '&thorn;',
									'&yuml;', '&OElig;', '&oelig;', '&Scaron;'
									];

	var html = '<table class="charmap" border="0" cellspacing="1" cellpadding="0" width="100%">';
	for (var charIndex = 0; charIndex < characters.length; ++charIndex) {
		var charStr = characters[charIndex];
		if (charIndex % 16 == 0) {
			if (0 != charIndex) {
				html += '</tr>';
			}
			html += '<tr>';
		}

		html += '<td class="character" onmouseover="';
		html += 'Zapatec.MinimalEditor.OnMouseOverChar(' + this.id + ', this)" ';
		html += 'onclick="return Zapatec.MinimalEditor.InsertChar(' + this.id + ', \'' +
		        charStr + '\')">' + charStr + '</td>';
	}
	html += '<td class="character" colspan="4">&nbsp;</td>';
	html += '</tr>';
	html += '</table>';

	// Try to use provided Zapatec.Win object
	var oWin = this.config.win;
	if (oWin) {
		// Open dialog
		oWin.open({
			headline: zapatecTranslate(this.getMessage('characterMapTitle')),
			source: html
		});
	} else {
		var self = this;
		var onClose = function(win) {
			self.characterMapWindow = null;
			// Hide modal
			self.setIsModal(false);
		}
		var title = this.getMessage('characterMapTitle');
		this.characterMapWindow = this.createWindow(420, 245, title, html, onClose);
	}
}

/**
 * Called internally when the mouse goes over a character cell in character map
 *
 * @private
 * @param {string} id editor id
 * @param {object} cell reference to character cell
 */
Zapatec.MinimalEditor.OnMouseOverChar = function(id, cell) {
	// Get editor by id
	var objEditor = Zapatec.Widget.getWidgetById(id);

	if (objEditor.oldHiliteCell) {
		objEditor.oldHiliteCell.className = "character";
	}

	var cellClass = cell.className;
	if (-1 == cellClass.indexOf("character-hilite")) {
		cell.className = "character character-hilite";
		objEditor.oldHiliteCell = cell;
	}
}

/**
 * Called internally when a character cell is clicked
 *
 * @private
 * @param {string} id editor id
 * @param {string} character selected character
 */
Zapatec.MinimalEditor.prototype.insertText = function(text) {

	if (Zapatec.is_ie) {
		var range = this.oldSelectionRange;
		if (!range) {
			var sel = this.pane.getContainer().contentWindow.document.selection;

			range = sel.createRange();
		}

		var self = this;
		setTimeout(function() {
			range.pasteHTML(text);

			range.select();

			// Store an undo step
			self.undo.saveUndo();

			// Update toolbar icon states
			self.updateToolbar();
		}, 500);

	}
	else {
		if (Zapatec.is_khtml) {
			this.restoreSelection();
		}

		var charElement = this.pane.getIframeDocument().createTextNode(text);
		this.insertNodeAtSelection(charElement);

		this.focus();

		// Store an undo step
		this.undo.saveUndo();

		// Update toolbar icon states
		this.updateToolbar();
	}
}

/**
 * Called internally when a character cell is clicked
 *
 * @private
 * @param {string} id editor id
 * @param {string} character selected character
 */
Zapatec.MinimalEditor.InsertChar = function(id, character) {

	// Get editor by id
	var objEditor = Zapatec.Widget.getWidgetById(id);

	// Close window
	var oWin = objEditor.config.win;
	if (oWin) {
		oWin.hide();
	} else {
		objEditor.characterMapWindow.close();
	}

	// Change selection text into our text field value
	objEditor.insertText(character);
	objEditor.saveContentToField();
}

/**
 * Stores current selection state and its range. Safari specific.
 *
 * @private
 */
Zapatec.MinimalEditor.prototype.storeSelection = function() {
	var sel = this.pane.getContainer().contentWindow.getSelection();

	var range = this.pane.getContainer().contentWindow.document.createRange();

	var isRangeSet = false;
	if (sel.baseNode == sel.extentNode && sel.baseOffset == sel.extentOffset) {
		if (sel.type == "Range") {
			range.setStartBefore(sel.baseNode);
			range.setEndAfter(sel.extentNode);
			isRangeSet = true;
		}
	}
	if (!isRangeSet && sel.baseNode) {
		range.setStart(sel.baseNode, sel.baseOffset);
		range.setEnd(sel.extentNode, sel.extentOffset);
	}


	this.oldSelection = sel;
	this.oldRange = range;
}

/**
 * Restores a previously stored selection state and its range. Safari specific.
 *
 * @private
 */
Zapatec.MinimalEditor.prototype.restoreSelection = function() {
	var sel = this.oldSelection;

	var newSelection = this.pane.getContainer().contentWindow.getSelection();
	newSelection.setBaseAndExtent(this.oldRange.startContainer,
					this.oldRange.startOffset, this.oldRange.endContainer,
					this.oldRange.endOffset);
}

/**
 * Checks if some selection exists in the editor
 *
 * @private
 */
Zapatec.MinimalEditor.prototype.isSelectionExists = function() {

	var range = null;
	var sel = null;
	if (Zapatec.is_ie) {
		sel = this.pane.getContainer().contentWindow.document.selection;

		range = sel.createRange();
	}
	else {
		sel = this.pane.getContainer().contentWindow.getSelection();

		if (!Zapatec.is_khtml) {
			range = sel.getRangeAt(0);
		}
	}

	var compare = 0;
	if (Zapatec.is_ie)
	{

		if (sel.type == "Control")
		{
			compare = range.length;
		}
		else
		{
			compare = range.compareEndPoints("StartToEnd", range);
		}
	}
	else {
		if (Zapatec.is_khtml) {
			var selectionType = '' + sel.type;
			if (selectionType == "Range") {
				return true;
			}
			if (selectionType == "Caret") {
				return false;
			}
		}
		else {
			compare = range.compareBoundaryPoints(range.START_TO_END, range);
		}
	}

	if (compare === 0)
	{
		return false;
	}

	return true;
}

/**
 * Gets currently selected text
 *
 * @public
 */
Zapatec.MinimalEditor.prototype.getSelectionText = function() {
	var range = null;
	var sel = null;
	if (Zapatec.is_ie) {
		sel = this.pane.getContainer().contentWindow.document.selection;
		range = sel.createRange();
		return range.text;
	}
	else {
		sel = this.pane.getContainer().contentWindow.getSelection();
		return sel;
	}
}

/**
 * Gets current selection parent element
 *
 * @public
 */
Zapatec.MinimalEditor.prototype.getSelectionParent = function() {
	var result = null;
	var range = null;
	var sel = null;
	if (Zapatec.is_ie) {
		sel = this.pane.getContainer().contentWindow.document.selection;
		range = sel.createRange();

		if (sel.type == "Control") {
			result = range(0);
		}
		else {
			result = range.parentElement();
		}
	}
	else {
		sel = this.pane.getContainer().contentWindow.getSelection();
		if (sel && sel.rangeCount > 0) {
			range = sel.getRangeAt(0);

			var container = range.commonAncestorContainer;
			result = container;

			// text node
			if (container.nodeType == 3) {
				result = container.parentNode;
			}
			else if (range.startContainer.nodeType == 1 &&
			         range.startContainer == range.endContainer &&
			         (range.endOffset - range.startOffset) <= 1)
			{
				// single object selected
				result = range.startContainer.childNodes[range.startOffset];
			}

		}
		else {
			result = this.pane.getIframeDocument().body;
		}
	}

	return result;
}

/**
 * Gets html from document start to caret position
 *
 * @public
 * @return size html text from document beginning to caret position
 * @type size string
 */
Zapatec.MinimalEditor.prototype.getHtmlFromBeginToCaret = function() {
	var result = null;
	var range = null;
	var sel = null;
	if (Zapatec.is_ie) {
		// Get current selection
		sel = this.pane.getContainer().contentWindow.document.selection;
		range = sel.createRange();

		// Move selection start to document start
		range.moveStart('textedit', -1);
		// Get range html
		result = range.htmlText;
	}
	else {
		// Get current selection
		sel = this.pane.getContainer().contentWindow.getSelection();
		if (sel && sel.rangeCount > 0) {
			// Get first range
			range = sel.getRangeAt(0);
			// Clone range
			var newRange = range.cloneRange();
			// Move range start to document start
			var body = this.pane.getIframeDocument().body;
			newRange.setStart(body, 0);
			var clonedSelection = newRange.cloneContents();
			// Get range html
			var div = document.createElement('div');
			div.appendChild(clonedSelection);
			result = div.innerHTML;
		}
		else {
			result = this.pane.getIframeDocument().body;
		}
	}

	return result;
}

/**
 * Gets html from caret position to document end
 *
 * @public
 * @return size html text from caret position to document end
 * @type size string
 */
Zapatec.MinimalEditor.prototype.getHtmlFromCaretToEnd = function() {
	var result = null;
	var range = null;
	var sel = null;
	if (Zapatec.is_ie) {
		// Get current selection
		sel = this.pane.getContainer().contentWindow.document.selection;
		range = sel.createRange();

		// Move selection start to document start
		range.moveEnd('textedit');
		// Get range html
		result = range.htmlText;
	}
	else {
		// Get current selection
		sel = this.pane.getContainer().contentWindow.getSelection();
		if (sel && sel.rangeCount > 0) {
			// Get first range
			range = sel.getRangeAt(0);
			// Clone range
			var newRange = range.cloneRange();
			// Move range start to document start
			var body = this.pane.getIframeDocument().body;
			newRange.setEnd(body, body.childNodes.length);
			var clonedSelection = newRange.cloneContents();
			// Get range html
			var div = document.createElement('div');
			div.appendChild(clonedSelection);
			result = div.innerHTML;
		}
		else {
			result = this.pane.getIframeDocument().body;
		}
	}

	return result;
}

/**
 * Gets size in pixels of document inside the editor
 *
 * @public
 * @return size Document width and height
 * @type size object
 */
Zapatec.MinimalEditor.prototype.getDocumentSize = function() {
	var iframeDoc = this.pane.getIframeDocument();
	var size = {};
	if (Zapatec.is_ie) {
		size.width = iframeDoc.body.scrollWidth;
		size.height = iframeDoc.body.scrollHeight;
	}
	else {
		size.width = iframeDoc.body.parentNode.clientWidth;
		size.height = iframeDoc.body.parentNode.clientHeight;
	}
	return size;
}

/**
 * Gets the element of specified type that encloses the selection
 *
 * @public
 * @param {string} tagName Selection enclosing element tag name
 */
Zapatec.MinimalEditor.prototype.getSelectedElementByTagName = function(tagName) {
	var selParent = this.getSelectionParent();
	tagName = tagName.toLowerCase();

	while (selParent) {
		var tag = selParent.tagName;
		if (tag) {
			tag = tag.toLowerCase();
		}
		if (tagName == tag || tag == 'body') {
			break;
		}

		selParent = selParent.parentNode;
	}

	return selParent;
}

/**
 * Deletes currently selected text
 *
 * @private
 */
Zapatec.MinimalEditor.prototype.deleteSelection = function() {
	var range = null;
	var sel = null;
	if (Zapatec.is_ie) {
		var iframeDocument = this.pane.getIframeDocument();
		if (typeof iframeDocument.selection != 'undefined') {
			var selection = iframeDocument.selection;

			if (selection.type.toLowerCase() == 'control') {
				// Delete selection
				selection.clear();
			}
		}
	}
	else {
		sel = this.pane.getContainer().contentWindow.getSelection();
		sel.deleteFromDocument();
	}
}

/**
 * Updates the state of a toolbar select option box.
 *
 * @private
 * @param {object} select Reference to select element
 * @param {object} value Select value to make currently selected
 */
Zapatec.MinimalEditor.prototype.updateToolbarSelect = function(select, value) {
	value = value.toLowerCase();

	var isSelected = false;
	var optionCount = select.options.length;
	for (var i = 0; i < optionCount; ++i) {
		var currentValue = select.options[i].value;
		if (currentValue.toLowerCase() == value) {
			select.selectedIndex = i;
			isSelected = true;
			break;
		}
	}

	if (!isSelected) {
		select.selectedIndex = 0;
	}
}

/**
 * Updates toolbar icon states.
 *
 * @private
 */
Zapatec.MinimalEditor.prototype.updateToolbar = function() {
	var fontNameSelect = document.getElementById(
					'zpEditor' + this.id + 'FontName');
	if (fontNameSelect) {
		var fontName = '' + this.queryCommandValue('fontname');
		this.updateToolbarSelect(fontNameSelect, fontName);
	}

	var fontSizeSelect = document.getElementById(
					'zpEditor' + this.id + 'FontSize');
	if (fontSizeSelect) {
		var fontSize = '' + this.queryCommandValue('fontsize');
		this.updateToolbarSelect(fontSizeSelect, fontSize);
	}

	var boldButton = this.getButton('zpEditor' + this.id + 'Bold');
	if (boldButton) {
		var boldState = this.queryCommandState('bold');
		boldButton.setPressed(boldState);
	}

	var italicButton = this.getButton('zpEditor' + this.id + 'Italic');
	if (italicButton) {
		var italicState = this.queryCommandState('italic');
		italicButton.setPressed(italicState);
	}

	var underlineButton = this.getButton('zpEditor' + this.id + 'Underline');
	if (underlineButton) {
		var underlineState = this.queryCommandState('underline');
		underlineButton.setPressed(underlineState);
	}

	var justifyLeftButton = this.getButton('zpEditor' + this.id + 'JustifyLeft');
	if (justifyLeftButton) {
		var justifyLeftState = this.queryCommandState('justifyleft');
		justifyLeftButton.setPressed(justifyLeftState);
	}

	var justifyCenterButton = this.getButton('zpEditor' + this.id + 'JustifyCenter');
	if (justifyCenterButton) {
		var justifyCenterState = this.queryCommandState('justifycenter');
		justifyCenterButton.setPressed(justifyCenterState);
	}

	var justifyRightButton = this.getButton('zpEditor' + this.id + 'JustifyRight');
	if (justifyRightButton) {
		var justifyRightState = this.queryCommandState('justifyright');
		justifyRightButton.setPressed(justifyRightState);
	}

	var justifyFullButton = this.getButton('zpEditor' + this.id + 'JustifyFull');
	if (justifyFullButton) {
		var justifyFullState = this.queryCommandState('justifyfull');
		justifyFullButton.setPressed(justifyFullState);
	}

	// Check if undo button is to be enabled
	var undoButton = this.getButton('zpEditor' + this.id + 'Undo');
	if (undoButton) {
		var undoState = this.undo.checkUndoState();
		if (undoState) {
			undoButton.enable();
		}
		else {
			undoButton.disable();
		}
	}

	// Check if redo button is to be enabled
	var redoButton = this.getButton('zpEditor' + this.id + 'Redo');
	if (redoButton) {
		var redoState = this.undo.checkRedoState();
		if (redoState) {
			redoButton.enable();
		}
		else {
			redoButton.disable();
		}
	}
}

/**
 * Queues an update toolbar call for later.
 *
 * @private
 */
Zapatec.MinimalEditor.prototype.invokeUpdateToolbar = function() {
	var self = this;
	setTimeout(function() {
		self.updateToolbar();
	}, 250);
}


Zapatec.MinimalEditor.Undo = function(editor) {
	this.editor = editor;
	this.undoStack = new Array();
	this.undoStackIndex = -1;
	this.typesCount = this.editor.config.maxUndoTypes;
	this.isTyping = false;
	this.lastTypeTime = -1;
}

Zapatec.MinimalEditor.Undo.prototype.saveUndo = function() {
	if (!this.editor.config.customUndo) {
		return;
	}

	// Get editor html content
	var html = this.editor.pane.getContentElement().innerHTML;

	// If undo is available and current html is the same as last undo state
	if (0 <= this.undoStackIndex &&
	    html == this.undoStack[this.undoStackIndex][0]) {
		return;
	}
	// Ignore forward stack
	this.undoStack = this.undoStack.slice(0, this.undoStackIndex + 1);

	if (this.undoStackIndex + 1 >= this.editor.config.maxUndoLevels) {
		this.undoStack.shift();
	}
	else {
		++this.undoStackIndex;
	}

	var bookmark = null;
	if (Zapatec.is_ie) {
		var sel = this.editor.pane.getContainer().contentWindow.document.selection;
		var range = sel.createRange();
		try {
			bookmark = range.getBookmark();
		}
		catch (e) {
		}
	}
	this.undoStack[this.undoStackIndex] = [html, bookmark];
}

Zapatec.MinimalEditor.Undo.prototype.onKeyDown = function() {
	if (!this.editor.config.customUndo) {
		return;
	}

	// Get time since last keystroke
	var now = (new Date()).getTime();
	this.lastTypeTime = now;

	this.processKeyDown();
}

Zapatec.MinimalEditor.Undo.prototype.processKeyDown = function() {
	if (this.isProcessPending) {
		return;
	}

	// Get time since last keystroke
	var now = (new Date()).getTime();
	var timeSinceLastType = now - this.lastTypeTime;

	if (timeSinceLastType < 2000) {
		var self = this;
		if (!self.isProcessPending) {
			self.isProcessPending = true;
			setTimeout(function() {
				self.isProcessPending = false;

				self.processKeyDown();
			}, 200);
		}
		return;
	}

	// If this is the first key stroke or the first in 2 seconds
	if (!this.isTyping || 2000 <= timeSinceLastType) {
		// Save undo step
		this.saveUndo();
		this.isTyping = true;
	}

	++this.typesCount;
	if (this.typesCount > this.editor.config.maxUndoTypes) {
		this.typesCount = 0;
		this.saveUndo();
	}
}

Zapatec.MinimalEditor.Undo.prototype.checkUndoState = function() {
	if (this.editor.config.customUndo) {
		return (this.isTyping || this.undoStackIndex > 0);
	}
	else {
		return this.editor.queryCommandEnabled('Undo');
	}
}

Zapatec.MinimalEditor.Undo.prototype.checkRedoState = function() {
	if (this.editor.config.customUndo) {
		return (!this.isTyping && this.undoStackIndex < (this.undoStack.length - 1));
	}
	else {
		return this.editor.queryCommandEnabled('Redo');
	}
}

Zapatec.MinimalEditor.Undo.prototype.undo = function() {
	if (this.editor.config.customUndo) {
		if (this.checkUndoState()) {
			if (this.undoStackIndex == (this.undoStack.length - 1)) {
				this.saveUndo();
			}
			this.restoreUndo(--this.undoStackIndex);
		}
	}
	else {
		this.editor.execCommand("undo", false, null);
	}
}

Zapatec.MinimalEditor.Undo.prototype.redo = function() {
	if (this.editor.config.customUndo) {
		if (this.checkRedoState()) {
			this.restoreUndo(++this.undoStackIndex);
		}
	}
	else {
		this.editor.execCommand("redo", false, null);
	}
}

Zapatec.MinimalEditor.Undo.prototype.restoreUndo = function(undoIndex) {
	var pair = this.undoStack[undoIndex];
	if (!pair) {
		return;
	}
	this.editor.setHTML(pair[0]);
	if (pair[1]) {
		if (Zapatec.is_ie) {
			var range = this.editor.pane.getIframeDocument().selection.createRange();
			range.moveToBookmark(pair[1]);
			range.select();
		}
	}
	this.typesCount = 0;
	this.isTyping = false;
}

/**
 * Shows a insert link input window
 *
 * @public
 */
Zapatec.MinimalEditor.prototype.showInsertLinkWindow = function() {
	// If insert link window is not yet closed
	if (this.insertLinkWindow) {
		return;
	}

	var text = "";
	var url = "http://";

	var isSelection = this.isSelectionExists();
	if (!isSelection) {
	}
	else {
		text = this.getSelectionText();
	}

	if (Zapatec.is_khtml) {
		this.storeSelection();
	}
	else if (Zapatec.is_ie) {
		// Store selection before showing the window
		this.oldSelection = this.pane.getContainer().contentWindow.document.selection;
		this.oldRange = this.oldSelection.createRange();
		this.oldBookmark = this.oldRange.getBookmark();
	}
	else if (Zapatec.is_opera) {
		this.oldSelection = this.pane.getContainer().contentWindow.getSelection();
		this.oldRange = this.oldSelection.getRangeAt(0);
	}

	// Gets if some anchor is currently selected
	var selAnchor = this.getSelectedElementByTagName('a');
	if (selAnchor && selAnchor.tagName && selAnchor.tagName.toLowerCase() == 'a') {
		text = selAnchor.innerHTML;
		url = null;
		if (this.config.preserveAnchorHref) {
			url = selAnchor.getAttribute('_zpHref');
		}
		if (null == url) {
			url = selAnchor.getAttribute('href');
		}
		// Store anchor we are about to modify
		this.insertLinkAnchor = selAnchor;
	}

	var linkLabelClass = this.getClassName({prefix: "zpEditor",
		suffix: "LinkLabel"
	});
	var linkInputClass = this.getClassName({prefix: "zpEditor",
		suffix: "LinkInput"
	});
	var buttonPaneClass = this.getClassName({prefix: "zpEditor",
		suffix: "LinkButtonPane"
	});
	var inputPaneClass = this.getClassName({prefix: "zpEditor",
		suffix: "LinkInputPane"
	});
	var okClass = this.getClassName({prefix: "zpEditor",
		suffix: "LinkOk"
	});

	var textId = "zpInsertLink" + this.id + "Text";
	var urlId = "zpInsertLink" + this.id + "Url";

	var linkTextLabel = this.getMessage('insertLinkTextLabel');
	// Write text and address input fields
	var html = '<div class="' + inputPaneClass + '">';
	html += '<span class="' + linkLabelClass + '">' + linkTextLabel + '</span>';
	html += '<input class="' + linkInputClass + '" type="text" id="' + textId +
	        '" value="' + text + '" originalValue="' + text + '" />';
	html += '<br />';

	var linkAddressLabel = this.getMessage('insertLinkAddressLabel');
	html += '<span class="' + linkLabelClass + '">' + linkAddressLabel + '</span>';
	html += '<input class="' + linkInputClass + '" type="text" id="' + urlId +
	        '" value="' + url + '" />';
	html += '</div>';

	// Try to use provided Zapatec.Win object
	var oWin = this.config.win;
	if (oWin) {
		// OK and Cancel buttons
		html += '<div class="' + buttonPaneClass + '">';
		html += '<input class="' + okClass + '" type="button" value="OK"';
		html += 'onclick="return Zapatec.MinimalEditor.InsertLink(\'' + this.id +
		        '\', \'' + textId + '\', \'' + urlId + '\')" />';
		html += '<input type="button" value="' + zapatecTranslate('Cancel') + '"';
		html += ' onclick="zapatecWidgetCallMethod(' + this.id + ',\'hideWin\')"/>';
		html += '</div>';
		// Open dialog
		oWin.open({
			headline: zapatecTranslate(this.getMessage('insertLinkTitle')),
			source: html
		});
	} else {
		// OK and Cancel buttons
		html += '<div class="' + buttonPaneClass + '">';
		html += '<input class="' + okClass + '" type="button" value="OK"';
		html += 'onclick="return Zapatec.MinimalEditor.InsertLink(\'' + this.id +
		        '\', \'' + textId + '\', \'' + urlId + '\')" />';
		html += '<input type="button" value="Cancel"';
		html += ' onclick="return Zapatec.MinimalEditor.HideInsertLink(\'' + this.id +
		        '\')"/>';
		html += '</div>';
		var self = this;
		var onClose = function(win) {
			self.insertLinkWindow = null;
			// Hide modal
			self.setIsModal(false);
		}
		var title = this.getMessage('insertLinkTitle');
		this.insertLinkWindow = this.createWindow(320, 130, title, html, onClose);
	}
}

/**
 * Hides miscellaneous dialogs.
 * @private
 */
Zapatec.MinimalEditor.prototype.hideWin = function() {
	var oWin = this.config.win;
	if (oWin) {
		oWin.hide();
	}
};

/**
 * Called internally when a OK is pressed in the Insert Link window
 *
 * @private
 * @param {object} id editor widget id
 * @param {string} textId text to display in link
 * @param {string} url link url
 */
Zapatec.MinimalEditor.InsertLink = function(id, textId, urlId) {

	// Get editor by id
	var objEditor = Zapatec.Widget.getWidgetById(id);

	var elText = document.getElementById(textId);
	var originalText = elText.getAttribute("originalValue");
	var text = elText.value;
	var elUrl = document.getElementById(urlId);
	var url = elUrl.value;

	// Close window
	var oWin = objEditor.config.win;
	if (oWin) {
		oWin.hide();
	} else {
		objEditor.insertLinkWindow.close();
	}

	// If we are modifying some anchor
	if (objEditor.insertLinkAnchor) {
		objEditor.insertLinkAnchor.setAttribute('href', url);
		if (objEditor.config.preserveAnchorHref) {
			objEditor.insertLinkAnchor.setAttribute('_zpHref', url);
		}

		objEditor.insertLinkAnchor.innerHTML = text;
		objEditor.insertLinkAnchor = null;
		return;
	}

	var beginNode = null;
	var beginOffset = null;

	// Store selection before changing it
	var range = null;
	var sel = null;
	if (Zapatec.is_ie) {
		sel = objEditor.oldSelection;
		range = objEditor.oldRange;
	}
	else if (Zapatec.is_opera) {
		sel = objEditor.oldSelection;
		sel = objEditor.pane.getContainer().contentWindow.getSelection();
		sel.addRange(objEditor.oldRange);
	}
	else {
		sel = objEditor.pane.getContainer().contentWindow.getSelection();
	}

	beginNode = sel.anchorNode;
	beginOffset = sel.anchorOffset;

	// If link text has been changed
	if (originalText != text) {
		if (!Zapatec.is_opera) {
			objEditor.focus();
		}

		// Change currently selected text to value in Text field
		var charEl = objEditor.insertText(text);

		if (Zapatec.is_ie) {

			var completeFunc = function() {
				sel = objEditor.pane.getContainer().contentWindow.document.selection;
				var newRange = sel.createRange();

				// Select text
				newRange.findText(text, -text.length, 0);
				newRange.select();

				// Create new link from current text selection
				objEditor.createLink(url);
			}
			setTimeout(completeFunc, 50);

			return;
		}
		else {
			sel = objEditor.pane.getContainer().contentWindow.getSelection();
			var doc = objEditor.pane.getIframeDocument();

			var endNode = sel.anchorNode;
			var endOffset = sel.anchorOffset;

			range = doc.createRange();

			range.setStart(beginNode, beginOffset);
			range.setEnd(endNode, endOffset);

			sel.addRange(range);
		}
	}
	else {
		if (Zapatec.is_ie) {
			range.select();
		}
	}


	// Create new link from current selection
	objEditor.createLink(url);
}

/**
 * Shows a insert link input window
 *
 * @public
 * @param {string} url URL to set on new link href
 */
Zapatec.MinimalEditor.prototype.createLink = function(url) {
	if (url == null || url == "") {
		return;
	}

	if (Zapatec.is_khtml) {
		this.restoreSelection();
	}

	this.execCommand("createlink", false, url);
	
	if (this.config.linksTarget && object.links) {
		if (Zapatec.is_ie) {
			object = this.pane.getIframeDocument();
		}	else {
			object = this.pane.getContainer().contentWindow.document;
		}
		for (var iLink = 0; iLink < object.links.length; iLink++) {
			if (!object.links[iLink].getAttribute("target")) {
				object.links[iLink].setAttribute("target", this.config.linksTarget);
			}
		}
	}
	
	this.saveContentToField();

	// Focus editor
	this.focus();

	// Store an undo step
	this.undo.saveUndo();

	// Update toolbar icon states
	this.updateToolbar();
}

/**
 * Called internally when a Cancel is pressed in the Insert Link window
 *
 * @private
 */
Zapatec.MinimalEditor.HideInsertLink = function(id) {
	// Get editor by id
	var objEditor = Zapatec.Widget.getWidgetById(id);

	// Close character map widow
	objEditor.insertLinkWindow.close();
}

/**
 * Creates a new zapatec window
 *
 * @private
 * @param {number} width window width
 * @param {number} height window height
 * @param {string} title window title
 * @param {string} html window html content
 * @param {function} onClose callback on window close
 */
Zapatec.MinimalEditor.prototype.createWindow = function(width, height, title, html, onClose) {
	var oOffset = Zapatec.Utils.getElementOffset(this.container);

	var top = oOffset.y - 100;

	var pageScrollY = Zapatec.Utils.getPageScrollY();
	if (0 < pageScrollY) {
		top -= pageScrollY;
	}

	// Limit window location to page top
	if (top < 0) {
		top = 0;
		if (this.isMaximize) {
			top += this.config.maximizedBorder;
		}
	}

	// Show modal (Make editor panel gray)
	this.setIsModal(true);

	return Zapatec.Window.setup({
		left : oOffset.x + 100,
		top : top,
		width : width,
		height : height,
		raiseOnlyOnTitle : false,
		showStatus : false,
		canResize : false,
		showMaxButton : false,
		showMinButton : false,
		theme : 'winxp',
		content : html,
		title : title,
		onClose : onClose
	});
}

/**
 * Fill WebKit supported fetures matrix
 *
 * @private
 */
Zapatec.MinimalEditor.prototype.fillWebKitMap = function() {
	this.webKitMap = [];
	this.webKitMap['fontname'] = 420;
	this.webKitMap['fontsize'] = 420;
	this.webKitMap['bold'] = 312;
	this.webKitMap['italic'] = 312;
	this.webKitMap['underline'] = 312;
	this.webKitMap['justifyleft'] = 312;
	this.webKitMap['justifycenter'] = 312;
	this.webKitMap['justifyright'] = 312;
	this.webKitMap['justifyfull'] = 420;
	this.webKitMap['inserthorizontalrule'] = 420;
	this.webKitMap['insertorderedlist'] = 420;
	this.webKitMap['insertunorderedlist'] = 420;
	this.webKitMap['indent'] = 420;
	this.webKitMap['outdent'] = 420;
	this.webKitMap['forecolor'] = 312;
	this.webKitMap['backcolor'] = 312;
	this.webKitMap['insertlink'] = 420;
	this.webKitMap['insertimage'] = 420;
	this.webKitMap['cut'] = 312;
	this.webKitMap['copy'] = 312;
	this.webKitMap['paste'] = 1000;  // not supported
	this.webKitMap['undo'] = 312;
	this.webKitMap['redo'] = 312;
}

/**
 * Shows/hides modality
 *
 * @private
 * @param {boolean} isModal if true shows a gray panel over the editor, false
 * hides the gray box.
 */
Zapatec.MinimalEditor.prototype.setIsModal = function(isModal) {
	if (!this.modal) {
		this.modal = new Zapatec.Modal({
			themePath : Zapatec.zapatecPath + "../zpextra/themes/indicator/",
			container: this.container
		});
		this.modal.create();
	}

	if (isModal) {
		this.modal.show(2);
	}
	else {
		this.modal.hide();
	}
}

/**
 * Loads passed data into already initialized editor to view or edit it.
 *
 * <pre>
 * Arguments object format:
 * {
 *   data: [object] html string data
 * }
 * </pre>
 *
 * @param {object} oArg Arguments
 */
Zapatec.MinimalEditor.prototype.receiveData = function(oArg) {
	// Call parent method
	Zapatec.MinimalEditor.SUPERclass.receiveData.call(this, oArg);
	// Check arguments
	if (!oArg.data) {
		return;
	}
	this.setHTML(oArg.data);
}

/**
 * Prepares processed data to return them back to the sender in the same format
 * as they were received in {@link Zapatec.MinimalEditor#receiveData}.
 *
 * @return html currently in editor
 * @type html string
 */
Zapatec.MinimalEditor.prototype.replyData = function() {
	return this.getHTML();
};

/**
 * Prepares object for garbage collector.
 */
Zapatec.MinimalEditor.prototype.discard = function() {
	var oContainer = this.container;
	
	if (oContainer && oContainer.parentNode) {
		var oTextarea = this.config.field;
		if (oTextarea) {
			oContainer.parentNode.replaceChild(oTextarea, oContainer);
			// Restore textarea style
			var oTextareaStyle = oTextarea.style;
			var oOrigTextareaStyle = this.textareaStyle;
			for (var sProp in oOrigTextareaStyle) {
				oTextareaStyle[sProp] = oOrigTextareaStyle[sProp];
			}
		} else {
			oContainer.parentNode.removeChild(oContainer);
		}
	}
	
	for(var ii = 0; ii < this.tooltips.length; ii++){
		this.tooltips[ii].discard();	
	}
	
	for(var ii = 0; ii < this.buttons.length; ii++){
		this.buttons[ii].discard();	
	}

	this.container = null;
	this.editorPanel = null;
	this.wch = null;

	if (this.pane) {
		this.pane.destroy();
		this.pane = null;
	}
	
	this.config = null;
	
	// Call parent method
	zapatecEditor.SUPERclass.discard.call(this);
};
