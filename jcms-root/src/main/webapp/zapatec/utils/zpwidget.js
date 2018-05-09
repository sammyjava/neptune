/**
 * @fileoverview Zapatec Widget library. Base Widget class.
 *
 * <pre>
 * Copyright (c) 2004-2009 by Zapatec, Inc.
 * http://www.zapatec.com
 * 1700 MLK Way, Berkeley, California,
 * 94709, U.S.A.
 * All rights reserved.
 * </pre>
 */

/* $Id: zpwidget.js 15857 2009-02-13 14:37:28Z andrew $ */

if (typeof Zapatec == 'undefined') {
	/**
	 * @ignore Namespace definition.
	 */
	Zapatec = function() {};
}

/**
 * Base widget class.
 *
 * <pre>
 * Defines following config options:
 *
 * <b>theme</b> [string] URL of theme file, absolute or relative to the widget's
 * js file. Default: "../themes/default.css". File extension must be "css".
 *
 * Alternatively may contain only theme name. Example: "default". In this case
 * URL of the file will be formed automatically from the theme name and value of
 * the <b>themePath</b> config option.
 *
 * Special theme "auto" is used to detect theme automatically depending from OS.
 * It is replaced automatically with one of the following values:
 *
 * <i>winvista</i> for Windows Vista
 * <i>winxp</i> for Windows XP
 * <i>win2k</i> for other Windows
 * <i>macosx</i> for Mac OSX
 * <i>default</i> for other OS
 *
 * Make sure all these themes exist before using "auto" theme for the widget.
 *
 * <b>themePath</b> [string] URL of the themes directory, absolute or relative
 * to the widget's js file. Default: "../themes/". Trailing slash is mandatory.
 * Path specified in the <b>theme</b> config option overwrites this config
 * option. Use only if you pass theme name instead of the URL in the
 * <b>theme</b> config option.
 *
 * <b>asyncTheme</b> [boolean] Load theme asynchronously. This means that script
 * execution will not be suspended until theme is loaded. Theme will be applied
 * once it is loaded. Default: false.
 *
 * <b>templateFile</b> [string] URL of template file, absolute or relative to
 * the widget's js file. Default: "../templates/default.html". File extension
 * must be "html".
 *
 * Alternatively may contain only template name. Example: "default". In this
 * case URL of the file will be formed automatically from the template name and
 * value of the <b>templatePath</b> config option.
 *
 * Template file is supposed to contain a set of templates used in the widget.
 * Each template must be enclosed in &lt;textarea&gt; tag having ID, which is
 * used as template name in <b>templates</b> config option. Each
 * &lt;textarea&gt; tag must have style attribute with "display: hidden".
 * Example:
 * &lt;textarea id="zpWidgetTemplateMain" style="display: none"&gt;
 *   Template HTML Source
 * &lt;/textarea&gt;
 * Each template is HTML source passed to new Zapatec.Template.
 * See {@link Zapatec.Widget#loadTemplate}
 *
 * <b>templateFilePath</b> [string] URL of the templates directory, absolute or
 * relative to the widget's js file. Default: "../templates/". Trailing slash is
 * mandatory. Path specified in the <b>template</b> config option overwrites
 * this config option. Use only if you pass template name instead of the URL in
 * the <b>templateFile</b> config option.
 *
 * <b>templates</b> [object] associates template IDs from template file with
 * template names. Specific to each widget. Example:
 * {
 *   "main": "zpWidgetTemplateMain",
 *   ...
 * }
 * Where "main" is template name and "zpWidgetTemplateMain" is template ID in
 * the templates file.
 *
 * Templates are initialized (see {@link Zapatec.Widget#initTemplates}) and then
 * each template (Zapatec.Template) object can be accessed using its name.
 * Example: this.templates.main is reference to Zapatec.Template object, which
 * was initialized with HTML source taken from "zpWidgetTemplateMain" textarea.
 *
 * <b>source</b> Depends on "sourceType" option. Possible sources:
 * -----------------------------------------------------------------------------
 * sourceType     | source
 * ---------------|-------------------------------------------------------------
 * 1) 'html'      | [object or string] HTMLElement or its id.
 * 2) 'html/text' | [string] HTML fragment.
 * 3) 'html/url'  | [string] URL of HTML fragment.
 * 4) 'json'      | [object or string] JSON object or string (http://json.org).
 * 5) 'json/url'  | [string] URL of JSON data source.
 * 6) 'xml'       | [object or string] XMLDocument object or XML string.
 * 7) 'xml/url'   | [string] URL of XML data source.
 * -----------------------------------------------------------------------------
 *
 * <b>sourceType</b> [string] Used together with "source" option to specify how
 * source should be processed. Possible source types:
 * 'html', 'html/text', 'html/url', 'json', 'json/url', 'xml', 'xml/url'.
 * Default: 'html'.
 * JSON format is described at http://www.json.org.
 *
 * <b>sourceFetchMethod</b> [string] Source fetch method 'GET' or 'POST'.
 * Default: 'GET'.
 *
 * <b>sourceFetchContentType</b> [string] Content type when "sourceFetchMethod"
 * is 'POST'.
 *
 * <b>sourceFetchContent</b> [string or object] postable string or DOM object
 * data when "sourceFetchMethod" is 'POST'.
 *
 * <b>callbackSource</b> [function] May be used instead of "source",
 * "sourceType" and "sourceFetchMethod" config options to get source depending
 * on passed arguments. Called in scope of the widget. Receives object with
 * passed arguments. Must return following object:
 * {
 *   source: [object or string] see table above for possible sources,
 *   sourceType: [string] see table above for possible source types,
 *   method: [string, optional] method ('GET' or 'POST'),
 *   contentType: [string, optional] content type when using POST,
 *   content: [string or object, optional] postable string or DOM object data
 *    when using POST
 * }
 *
 * <b>asyncSource</b> [boolean] Load source asynchronously. This means that
 * script execution will not be suspended until source is loaded. Source will be
 * processed once it is loaded. Default: true.
 *
 * <b>reliableSource</b> [boolean] Used together with "json" or "json/url"
 * sourceType to skip JSON format verification. It saves a lot of time for large
 * data sets. Default: true.
 *
 * <b>callbackConvertSource</b> [function] May be used to convert input data
 * passed with "source" config option from custom format into internal format of
 * the widget. Must return converted source.
 *
 * <b>eventListeners</b> [object] Associative array with event listeners:
 * {
 *   [string] event name: [function or object] event listener or array of event
 *    listeners,
 *   ...
 * }
 *
 * Defines internal property <b>config</b>.
 * </pre>
 *
 * @constructor
 * @extends Zapatec.EventDriven
 * @param {object} oArg User configuration
 */
Zapatec.Widget = function(oArg) {
	// Save args
	this.arg = oArg;
	// User configuration
	this.config = {};
	// Call constructor of superclass
	zapatecWidget.SUPERconstructor.call(this);
	// Initialize object
	this.init(oArg);
};

/**
 * Shortcut for faster access.
 * @private
 * @final
 */
zapatecWidget = Zapatec.Widget;

// Inherit EventDriven
Zapatec.inherit(zapatecWidget, zapatecEventDriven);

/**
 * Unique static id of the class.
 * @private
 * @final
 */
Zapatec.Widget.id = 'Zapatec.Widget';

/**
 * Holds path to this file.
 * @private
 */
Zapatec.Widget.path = Zapatec.getPath('Zapatec.Widget');


/**
 * Initializes object.
 *
 * <pre>
 * Important: Before calling this method, define config options for the widget.
 * Initially "this.config" object should contain all config options with their
 * default values. Then values of config options will be changed with user
 * configuration in this method. Config options provided by user that were not
 * found in "this.config" object will be ignored.
 *
 * Defines internal property <b>id</b>.
 * </pre>
 *
 * @param {object} oArg User configuration
 */
Zapatec.Widget.prototype.init = function(oArg) {
	// Call parent method
	zapatecWidget.SUPERclass.init.call(this);
	// Add this widget to the list
	if (typeof this.id == 'undefined') {
		// Find id
		var iId = 0;
		while (zapatecWidgetAll[iId]) {
			iId++;
		}
		this.id = iId;
		zapatecWidgetAll[iId] = this;
	}
	// Configure
	this.configure(oArg);
	// Add custom event listeners
	this.addUserEventListeners();
	// Add standard event listeners
	this.addStandardEventListeners();
	// init language variables
	this.initLang();
	// Load theme
	this.loadTheme();
	// Load template
	this.loadTemplate();
};

/**
 * Reconfigures the widget with new config options after it was initialized.
 * May be used to change look or behavior of the widget after it has loaded
 * the data. In the argument pass only values for changed config options.
 * There is no need to pass config options that were not changed.
 *
 * <pre>
 * Note: "eventListeners" config option is ignored by this method because it is
 * useful only on initialization. To add event listener after the widget was
 * initialized, use addEventListener method instead.
 * </pre>
 *
 * @param {object} oArg Optional. Changes to user configuration
 */
Zapatec.Widget.prototype.reconfigure = function(oArg) {
	// Configure
	this.configure(oArg);
	// Load theme
	this.loadTheme();
	// Load template
	this.loadTemplate();
	// reinit language variables
	if(oArg && (oArg.lang || oArg.langCountryCode || oArg.langEncoding)){
		this.langStr = this.config.lang;

		if(this.config.langCountryCode && this.config.langCountryCode.length > 0){
			this.langStr += "_" + this.config.langCountryCode; 
		}

		if(this.config.langEncoding && this.config.langEncoding.length > 0){
			this.langStr += "-" + this.config.langEncoding; 
		}
	}

	if(
		this.config.lang && 
		this.config.lang.length > 0 &&
		!(
			Zapatec.Langs[this.config.langId] &&
			Zapatec.Langs[this.config.langId][this.langStr]
		)
	){
		this.debug(
			this.config.lang + (
				this.config.langCountryCode ? 
				" and country code " + this.config.langCountryCode : ""
			) + (
				this.config.langEncoding ? 
				" and encoding " + this.config.langEncoding : ""
			)
		);
		this.config.lang = null;
		this.config.langEncoding = null;
		this.langStr = null;
	}
};

/**
 * Reconfigures the widget with original config options. May be used to reset
 * configuration to defaults if the widget provides means to configure it by end
 * user.
 */
Zapatec.Widget.prototype.reset = function() {
	this.config = {};
	this.reconfigure(this.arg);
};

/**
 * Configures widget.
 *
 * <pre>
 * After processing of argument, tries to get <b>Zapatec.Config</b> cookie,
 * parses it and overwrites config options with respective values from result
 * object. This can be useful if some widget provides means to configure it by
 * end user.
 *
 * If Zapatec.Config cookie exists, it is supposed to be following JSON string:
 * {
 *   "Zapatec.Widget": {
 *     "configOptionName": "configOptionValue",
 *     ...
 *   },
 *   ...
 * }
 * Where "Zapatec.Widget" is a widget class name.
 * </pre>
 *
 * @param {object} oArg User configuration
 */
Zapatec.Widget.prototype.configure = function(oArg) {
	// Default configuration
	this.defineConfigOption('theme', 'default');
	this.defineConfigOption('templateFile', 'default');
	var sPath = this.constructor.path;
	if (typeof sPath != 'undefined') {
		this.defineConfigOption('themePath', zapatecTransport.translateUrl({
			url: '../themes/',
			relativeTo: sPath
		}));
		this.defineConfigOption('templateFilePath', zapatecTransport.translateUrl({
			url: '../templates/',
			relativeTo: sPath
		}));
	} else {
		this.defineConfigOption('templateFilePath', '../templates/');
	}
	this.defineConfigOption('templates');
	this.defineConfigOption('asyncTheme', false);
	this.defineConfigOption('source');
	this.defineConfigOption('sourceType', 'html');
	this.defineConfigOption('sourceFetchMethod', 'GET');
	this.defineConfigOption('sourceFetchContentType');
	this.defineConfigOption('sourceFetchContent');
	this.defineConfigOption('callbackSource');
	this.defineConfigOption('asyncSource', true);
	this.defineConfigOption('reliableSource', true);
	this.defineConfigOption('callbackConvertSource');
	this.defineConfigOption('eventListeners', {});
	this.defineConfigOption('langId');
	this.defineConfigOption('lang');
	this.defineConfigOption('langCountryCode');
	this.defineConfigOption('langEncoding');
	// Get user configuration
	var oConfig = this.config;
	var sOption;
	if (oArg) {
		for (sOption in oArg) {
			if (typeof oConfig[sOption] != 'undefined') {
				oConfig[sOption] = oArg[sOption];
			} else {
				this.debug('Unknown config option: ' + sOption + '.', 'warn');
			}
		}
	}
	// Overwrite some config options with values from cookies
	var sConstructorId = this.constructor.id;
	if (sConstructorId) {
		var oCookie = zapatecTransport.parseJson({
			strJson: zapatecUtils.getCookie('Zapatec.Config')
		});
		if (oCookie) {
			oCookie = oCookie[sConstructorId];
			if (oCookie) {
				for (sOption in oCookie) {
					if (typeof oConfig[sOption] != 'undefined') {
						oConfig[sOption] = oCookie[sOption];
					}
				}
			}
		}
	}
};

/**
 * Returns current configuration of the widget.
 *
 * @return Current configuration
 * @type object
 */
Zapatec.Widget.prototype.getConfiguration = function() {
	return this.config;
};

/**
 * Array to access any widget on the page by its id number.
 * @private
 */
Zapatec.Widget.all = [];

/**
 * Shortcut for faster access.
 * @private
 * @final
 */
zapatecWidgetAll = zapatecWidget.all;

/**
 * Finds a widget by id.
 *
 * @param {number} Widget id
 * @return Widget or undefined if not found
 * @type object
 */
Zapatec.Widget.getWidgetById = function(iId) {
	return zapatecWidgetAll[iId];
};

/**
 * Shortcut for faster access.
 * @private
 * @final
 */
zapatecWidgetGetWidgetById = zapatecWidget.getWidgetById;

/**
 * Saves a property that must be set to null on window unload event. Should be
 * used for properties that can't be deleted by garbage collector in IE 6 due to
 * circular references.
 *
 * <pre>
 * Defines internal property <b>widgetCircularRefs</b>.
 * </pre>
 *
 * @param {object} oElement DOM object
 * @param {string} sProperty Property name
 */
Zapatec.Widget.prototype.addCircularRef = function(oElement, sProperty) {
	if (!this.widgetCircularRefs) {
		// Holds properties of DOM objects that must be set to null on window unload
		// event to prevent memory leaks in IE 6
		this.widgetCircularRefs = [];
	}
	this.widgetCircularRefs.push([oElement, sProperty]);
};

/**
 * Assigns a value to a custom property of DOM object. This property will be
 * set to null on window unload event. Use this function to create properties
 * that can't be deleted by garbage collector in IE 6 due to circular
 * references.
 *
 * @param {object} oElement DOM object
 * @param {string} sProperty Property name
 * @param {any} val Property value
 */
Zapatec.Widget.prototype.createProperty = function(oElement, sProperty, val) {
	oElement[sProperty] = val;
	this.addCircularRef(oElement, sProperty);
};

/**
 * Removes circular references previously defined with method
 * {@link Zapatec.Widget#addCircularRef} or
 * {@link Zapatec.Widget#createProperty} to prevent memory leaks in IE 6.
 * @private
 */
Zapatec.Widget.prototype.removeCircularRefs = function() {
	if (!this.widgetCircularRefs) {
		return;
	}
	for (var iRef = this.widgetCircularRefs.length - 1; iRef >= 0; iRef--) {
		var oRef = this.widgetCircularRefs[iRef];
		try{
			oRef[0][oRef[1]] = null;
		} catch (e){};
		oRef[0] = null;
	}
};

/**
 * Deletes event handlers, control widgets, templates and references to the
 * object to let JavaScript garbage collector to delete the object.
 *
 * <pre>
 * Calls {@link Zapatec.Widget#discardEventHandlers},
 * {@link Zapatec.Widget#discardControls},
 * {@link Zapatec.Widget#discardTemplates}.
 * Deletes a reference to the object from the internal list.
 * Calls {@link Zapatec.Widget#removeCircularRefs}.
 * This lets JavaScript garbage collector to delete an object unless there are
 * any external references to it.
 *
 * Id of discarded object is reused. When you create a new instance of the
 * Widget, it obtains id of previously discarded object.
 * </pre>
 */
Zapatec.Widget.prototype.discard = function() {
	// Delete event handlers
	this.discardEventHandlers();
	// Delete controls
	this.discardControls();
	// Delete templates
	this.discardTemplates();
	// Delete configuration
	this.arg = null;
	this.config = null;
	// Delete references to this object
	zapatecWidgetAll[this.id] = null;
	this.removeCircularRefs();
};

/**
 * Calls method {@link Zapatec.Widget#removeCircularRefs} for each instance of
 * Widget on the page. Should be called only on window unload event.
 * @private
 */
Zapatec.Widget.removeCircularRefs = function() {
	var oWidget;
	for (var iWidget = zapatecWidgetAll.length - 1; iWidget >= 0; iWidget--) {
		oWidget = zapatecWidgetAll[iWidget];
		if (oWidget && typeof oWidget.discard == 'function') {
			oWidget.discard();
		}
	}
};

// Remove circular references on window uload event to prevent memory leaks in
// IE 6
zapatecUtils.addEvent(window, 'unload', zapatecWidget.removeCircularRefs);

/**
 * Defines config option if it is not defined yet. Sets default value of new
 * config option. If default value is not specified, it is set to null.
 *
 * @param {string} sOption Config option name
 * @param {any} val Optional. Config option default value
 */
Zapatec.Widget.prototype.defineConfigOption = function(sOption, val) {
	if (typeof this.config[sOption] == 'undefined') {
		if (typeof val == 'undefined') {
			this.config[sOption] = null;
		} else {
			this.config[sOption] = val;
		}
	}
};

/**
 * Adds custom event listeners.
 */
Zapatec.Widget.prototype.addUserEventListeners = function() {
	var oListeners = this.config.eventListeners;
	var fListener, iListeners, iListener;
	for (var sEvent in oListeners) {
		if (oListeners.hasOwnProperty(sEvent)) {
			vListener = oListeners[sEvent];
			if (vListener instanceof Array) {
				iListeners = vListener.length;
				for (iListener = 0; iListener < iListeners; iListener++) {
					this.addEventListener(sEvent, vListener[iListener]);
				}
			} else {
				this.addEventListener(sEvent, vListener);
			}
		}
	}
};

/**
 * Adds standard event listeners.
 */
Zapatec.Widget.prototype.addStandardEventListeners = function() {
	this.addEventListener('fetchSourceError', zapatecWidget.loadSourceError);
	this.addEventListener('loadThemeError', zapatecWidget.loadThemeError);
	this.addEventListener('loadTemplateError', zapatecWidget.loadTemplateError);
};

/**
 * Displays the reason why the theme was not loaded.
 *
 * @private
 * @param {object} oError Error received from Zapatec.Transport.loadCss
 */
Zapatec.Widget.loadThemeError = function(oError) {
	this.debug('Cannot load theme: ' + 
		(oError && oError.errorDescription ? oError.errorDescription : '') + '.');
};

/**
 * Displays the reason why the template was not loaded.
 *
 * @private
 * @param {object} oError Error received from Zapatec.Transport.fetch
 */
Zapatec.Widget.loadTemplateError = function(oError) {
	this.debug('Cannot load template: ' + 
		(oError && oError.errorDescription ? oError.errorDescription : '') + '.');
};

/**
 * Displays the reason why the source was not loaded.
 *
 * @private
 * @param {object} oError Error received from Zapatec.Transport.fetch
 */
Zapatec.Widget.loadSourceError = function(oError) {
	this.debug('Cannot load source: ' + 
		(oError && oError.errorDescription ? oError.errorDescription : '') + '.');
};

/**
 * Loads specified theme.
 *
 * <pre>
 * Fires events:
 * <ul>
 * <li><i>loadThemeStart</i> before theme loading starts</li>
 * <li><i>loadThemeEnd</i> after theme was loaded or theme loading has failed</li>
 * <li><i>loadThemeError</i> after theme loading has failed. Passes one argument
 * to the listener: error object received from
 * {@link Zapatec.Transport#loadCss}.</li>
 * </ul>
 *
 * If special zapatecDoNotLoadThemes flag is set, this function does not load
 * theme CSS file. Theme CSS file must be included manually.
 *
 * Defines internal property <b>themeLoaded</b>.
 * </pre>
 */
Zapatec.Widget.prototype.loadTheme = function() {
	var oConfig = this.config;
	// Correct theme config option
	if (typeof oConfig.theme == 'string' && oConfig.theme.length) {
		// Remove path
		var iPos = oConfig.theme.lastIndexOf('/');
		if (iPos >= 0) {
			iPos++; // Go to first char of theme name
			oConfig.themePath = oConfig.theme.substring(0, iPos);
			oConfig.theme = oConfig.theme.substring(iPos);
		}
		// Remove file extension
		iPos = oConfig.theme.lastIndexOf('.');
		if (iPos >= 0) {
			oConfig.theme = oConfig.theme.substring(0, iPos);
		}
		// Make lower case
		oConfig.theme = oConfig.theme.toLowerCase();
		// Auto theme
		if (oConfig.theme == 'auto') {
			var sUserAgent = navigator.userAgent;
			if (sUserAgent.indexOf('Windows NT 6') != -1) {
				oConfig.theme = 'winvista';
			} else if (sUserAgent.indexOf('Windows NT 5') != -1) {
				oConfig.theme = 'winxp';
			} else if (sUserAgent.indexOf('Win') != -1) {
				oConfig.theme = 'win2k';
			} else if (sUserAgent.indexOf('Mac') != -1) {
				oConfig.theme = 'macosx';
			} else {
				oConfig.theme = 'default';
			}
		}
	} else {
		oConfig.theme = '';
	}
	// Load theme
	if (oConfig.theme) {
		this.fireEvent('loadThemeStart');
		if (zapatecDoNotLoadThemes) {
			this.themeLoaded = true;
			this.fireEvent('loadThemeEnd');
		} else {
			this.themeLoaded = false;
			var oWidget = this;
			zapatecTransport.loadCss({
				// URL of theme file
				url: oConfig.themePath + oConfig.theme + '.css',
				// Suspend script execution until theme is loaded or error received
				async: oConfig.asyncTheme,
				// Load handler
				onLoad: function() {
					if (!oWidget) {
						return;
					}
					oWidget.themeLoaded = true;
					oWidget.fireEvent('loadThemeEnd');
					// Clean up
					oWidget = null;
				},
				// Error handler
				onError: function(oError) {
					if (!oWidget) {
						return;
					}
					oWidget.themeLoaded = true;
					oWidget.fireEvent('loadThemeEnd');
					oWidget.fireEvent('loadThemeError', oError);
					// Clean up
					oWidget = null;
				}
			});
		}
	}
};

/**
 * Loads specified template file.
 *
 * <pre>
 * Fires events:
 * <ul>
 * <li><i>loadTemplateStart</i> before template loading starts</li>
 * <li><i>loadTemplateEnd</i> after template file was loaded or template loading
 * has failed</li>
 * <li><i>loadTemplateError</i> after template loading has failed. Passes one
 * argument to the listener: error object received from
 * {@link Zapatec.Transport#fetch}.</li>
 * </ul>
 *
 * Once template file is loaded, converts templates into DOM objects, calls
 * {@link Zapatec.Widget#initTemplates} and then {@link Zapatec.Widget#display}.
 *
 * Defines internal property <b>templateLoaded</b>.
 * </pre>
 */
Zapatec.Widget.prototype.loadTemplate = function() {
	var oConfig = this.config;
	// Correct template config option
	if (typeof oConfig.templateFile == 'string' && oConfig.templateFile.length) {
		// Remove path
		var iPos = oConfig.templateFile.lastIndexOf('/');
		if (iPos >= 0) {
			// Go to first char of template file name
			iPos++;
			oConfig.templateFilePath = oConfig.templateFile.substring(0, iPos);
			oConfig.templateFile = oConfig.templateFile.substring(iPos);
		}
		// Remove file extension
		iPos = oConfig.templateFile.lastIndexOf('.');
		if (iPos >= 0) {
			oConfig.templateFile = oConfig.templateFile.substring(0, iPos);
		}
		// Make lower case
		oConfig.templateFile = oConfig.templateFile.toLowerCase();
	} else {
		oConfig.templateFile = '';
	}
	// Load template
	if (oConfig.templateFile && oConfig.templates) {
		this.fireEvent('loadTemplateStart');
		this.templateLoaded = false;
		// See if it was preloaded
		var sTemplateFile = this.constructor.templateFiles;
		if (sTemplateFile) {
			sTemplateFile = sTemplateFile[oConfig.templateFile];
		}
		if (sTemplateFile) {
			// File was preloaded
			this.parseTemplate(sTemplateFile);
		} else {
			// Fetch file
			var oWidget = this;
			zapatecTransport.fetch({
				// URL of template file
				url: oConfig.templateFilePath + oConfig.templateFile + '.html' +
					(typeof zapatecDebug == 'function' ? '?' + Math.random() : ''),
				// Load handler
				onLoad: function(oRequest) {
					if (!oWidget) {
						return;
					}
					// Init templates and compile main template
					oWidget.parseTemplate(oRequest.responseText);
					// Clean up
					oWidget = null;
				},
				// Error handler
				onError: function(oError) {
					if (!oWidget) {
						return;
					}
					oWidget.templateLoaded = true;
					oWidget.fireEvent('loadTemplateEnd');
					oWidget.fireEvent('loadTemplateError', oError);
					// Clean up
					oWidget = null;
				}
			});
		}
	}
};

/**
 * Parses just loaded template file.
 *
 * @private
 * @param {string} sHtml Template file contents
 */
Zapatec.Widget.prototype.parseTemplate = function(sHtml) {
	// Insert template sources into the page
	var oContainer = zapatecTransport.parseHtml(sHtml);
	oContainer.style.display = 'none';
	document.body.insertBefore(oContainer, document.body.firstChild);
	// Init templates
	this.initTemplates();
	// Template sources are not needed anymore
	document.body.removeChild(oContainer);
	oContainer = null;
	// Fire event
	this.templateLoaded = true;
	this.fireEvent('loadTemplateEnd');
	// Compile main template
	this.display();
};

/**
 * Initializes templates. Requires Zapatec.Template. Deletes all existing
 * templates and creates new Zapatec.Template objects from the
 * <b>templates</b> config option.
 *
 * <pre>
 * Defines internal property <b>templates</b>, which gives ability to access
 * each template object using its name. Example: this.templates.main.
 *
 * All template objects containing in the <b>templates</b> property are deleted
 * automatically in {@link Zapatec.Widget#discardTemplates} and
 * {@link Zapatec.Widget#discard} methods.
 * </pre>
 *
 * @requires Zapatec.Template Requires zptemplate/src/zptemplate.js
*/
Zapatec.Widget.prototype.initTemplates = function() {
	// Delete old controls
	this.discardControls();
	// Delete old templates
	this.discardTemplates();
	// Keeps template instances
	this.templates = {};
	var oTemplates = this.templates;
	// Load templates
	var oTemplateContainers = this.config.templates;
	if (!oTemplateContainers) {
		this.debug('Missing config option "templates".');
		return;
	}
	if (!zapatecTemplate) {
		this.debug('Cannot find Zapatec.Template class.');
		return;
	}
	var sTplContainer, sTplContainerId;
	for (sTplContainer in oTemplateContainers) {
		sTplContainerId = oTemplateContainers[sTplContainer];
		if (typeof sTplContainerId == 'string' && sTplContainerId.length) {
			oTemplates[sTplContainer] = new zapatecTemplate({
				// Use div as data source
				source: sTplContainerId,
				sourceType: 'html'
			});
		}
	}
};

/**
 * Deletes templates created in {@link Zapatec.Widget#initTemplates}.
 */
Zapatec.Widget.prototype.discardTemplates = function() {
	var oTemplates = this.templates;
	if (oTemplates) {
		var sTpl, oTpl;
		for (sTpl in oTemplates) {
			oTpl = oTemplates[sTpl];
			if (oTpl && typeof oTpl.discard == 'function') {
				oTpl.discard();
				oTemplates[sTpl] = null;
			}
		}
	}
};

/**
 * Must compile main template and display result. Called during initialization.
 * Extend this in child class unless your widget must not be displayed during
 * initialization.
 */
Zapatec.Widget.prototype.display = function() {
	if (!this.templates) {
		this.debug('Templates are not loaded.');
	}
};

/**
 * Must initialize control widgets. Control widget is a widget initialized and
 * used inside current widget for different purposes, e.g. to display dialog.
 * Deletes all existing control widgets and creates new control widgets.
 * Extend this in child class.
 *
 * <pre>
 * Defines internal property <b>controls</b>, which gives ability to access
 * each control widget object using its name. Example: this.controls.dialog.
 *
 * All widget objects containing in the <b>controls</b> property are deleted
 * automatically in {@link Zapatec.Widget#discardControls} and
 * {@link Zapatec.Widget#discard} methods.
 * </pre>
 */
Zapatec.Widget.prototype.initControls = function() {
	// Delete old controls
	this.discardControls();
	// Keeps control widget instances
	this.controls = {};
};

/**
 * Deletes widgets created in {@link Zapatec.Widget#initControls}.
 */
Zapatec.Widget.prototype.discardControls = function() {
	var oControls = this.controls;
	if (oControls) {
		var sControl, oControl;
		for (sControl in oControls) {
			oControl = oControls[sControl];
			if (oControl && typeof oControl.discard == 'function') {
				oControl.discard();
				oControls[sControl] = null;
			}
		}
	}
};

/**
 * Must set event handlers. Deletes all existing event handlers and sets new
 * event handlers. Extend this in child class.
 *
 * <pre>
 * Defines internal property <b>eventHandlers</b>, which gives ability to access
 * each event handler function. Example: this.eventHandlers.onclick.
 *
 * All event handlers containing in the <b>eventHandlers</b> property are
 * deleted automatically in {@link Zapatec.Widget#discardEventHandlers} and
 * {@link Zapatec.Widget#discard} methods.
 * </pre>
 */
Zapatec.Widget.prototype.setEventHandlers = function() {
	// Delete old event handlers
	this.discardEventHandlers();
	// Keeps event handlers
	this.eventHandlers = {};
};

/**
 * Adds new DOM event. Stores reference to event to internal array to remove it
 * on widget discard.
 * @param {string} sHandlerName Unique handler name
 * @param {object} oElement Element object
 * @param {string} sEvent Event name
 * @param {function} fListener Event listener
 * @param {boolean} bUseCapture Optional. Default: false. For details see
 *	http://www.w3.org/TR/2000/REC-DOM-Level-2-Events-20001113/events.html#Events-EventTarget-addEventListener
 * @param {boolean} bRemoveOnUnload Optional. Default: true. remove eventlistener
 *	on page unload.
 */
Zapatec.Widget.prototype.addEventHandler = function(sHandlerName, oElement, sEvent, fListener, bUseCapture, bRemoveOnUnload){
        // if internal array is not initialized - initialize it first
	if(!this.eventHandlers){
		this.setEventHandlers();
	}
	
	// if there is already event with such name - remove it first
	this.removeEventHandler(sHandlerName);

	// add DOM event
	zapatecUtils.addEvent(oElement, sEvent, fListener);

	// store reference
	this.eventHandlers[sHandlerName] = {
		element: oElement,
		event: sEvent,
		handler: fListener
	};
};
/**
 * Removes existing DOM event. 
 * @param {string} sHandlerName Unique handler name
 */
Zapatec.Widget.prototype.removeEventHandler = function(sHandlerName){
        // if internal array is not initialized - initialize it first
	if(!this.eventHandlers || !this.eventHandlers[sHandlerName]){
		return;
	}

	var oHandler = this.eventHandlers[sHandlerName];

	var oEl = oHandler.element;
	var sEvent = oHandler.event;
	var fHandler = oHandler.handler;

	if (oEl && typeof sEvent == 'string' && typeof fHandler == 'function') {
		zapatecUtils.removeEvent(oEl, sEvent, fHandler);
		oHandler.element = null;
		oHandler.handler = null;
		this.eventHandlers[sHandlerName] == null;
	}
};

/**
 * Deletes event handlers set in {@link Zapatec.Widget#setEventHandlers}.
 */
Zapatec.Widget.prototype.discardEventHandlers = function() {
	var oHandlers = this.eventHandlers;

	if (oHandlers) {
		var sHandler;
		for (sHandler in oHandlers) {
			this.removeEventHandler(sHandler);
		}
	}
};

/**
 * Forms class name from theme name and provided prefix and suffix.
 *
 * <pre>
 * Arguments object format:
 * {
 *   prefix: [string, optional] prefix,
 *   suffix: [string, optional] suffix
 * }
 * E.g. if this.config.theme == 'default' and following object provided
 * {
 *   prefix: 'zpWidget',
 *   suffix: 'Container'
 * },
 * class name will be 'zpWidgetDefaultContainer'.
 * </pre>
 *
 * @param oArg [object] Arguments object
 * @return Class name
 * @type string
 */
Zapatec.Widget.prototype.getClassName = function(oArg) {
	var aClassName = [];
	if (oArg && oArg.prefix) {
		aClassName.push(oArg.prefix);
	}
	var sTheme = this.config.theme;
	if (sTheme != '') {
		aClassName.push(sTheme.charAt(0).toUpperCase());
		aClassName.push(sTheme.substr(1));
	}
	if (oArg && oArg.suffix) {
		aClassName.push(oArg.suffix);
	}
	return aClassName.join('');
};

/**
 * Forms unique element id from widget id, unique counter and provided prefix
 * and suffix.
 *
 * <pre>
 * Arguments object format:
 * {
 *   prefix: [string, optional] prefix, default: 'zpWidget',
 *   suffix: [string, optional] suffix, default: '-'
 * }
 * E.g. if widget id is 0, unique counter is 1 and following object provided
 * {
 *   prefix: 'zpWidget',
 *   suffix: 'Item'
 * },
 * id will be 'zpWidget0Item1'.
 *
 * Defines internal property <b>widgetUniqueIdCounter</b>.
 * </pre>
 *
 * @param oArg [object] Arguments object
 * @return Element id
 * @type string
 */
Zapatec.Widget.prototype.formElementId = function(oArg) {
	var aId = [];
	if (oArg && oArg.prefix) {
		aId.push(oArg.prefix);
	} else {
		aId.push('zpWidget');
	}
	aId.push(this.id);
	if (oArg && oArg.suffix) {
		aId.push(oArg.suffix);
	} else {
		aId.push('-');
	}
	if (typeof this.widgetUniqueIdCounter == 'undefined') {
		this.widgetUniqueIdCounter = 0;
	} else {
		this.widgetUniqueIdCounter++;
	}
	aId.push(this.widgetUniqueIdCounter);
	return aId.join('');
};

/**
 * Shows widget using given effects and animation speed. You need to define
 * this.container to use this method.
 * @param {object} effects list of effects to apply
 * @param {number} animSpeed possible values - 1..100. Bigger value - more fast animation.
 * @param {function} onFinish Function to call on effect end.
 */
Zapatec.Widget.prototype.showContainer = function(effects, animSpeed, onFinish){
	return this.showHideContainer(effects, animSpeed, onFinish, true);
}

/**
 * Hides widget using given effects and animation speed. You need to define
 * this.container to use this method.
 * @param {object} effects list of effects to apply
 * @param {number} animSpeed possible values - 1..100. Bigger value - more fast animation.
 */
Zapatec.Widget.prototype.hideContainer = function(effects, animSpeed, onFinish){
	return this.showHideContainer(effects, animSpeed, onFinish, false);
}

/**
 * Show/hides widget using given effects and animation speed. You need to define
 * this.container to use this method.
 * @param {object} effects list of effects to apply
 * @param {number} animSpeed possible values - 1..100. Bigger value - more fast animation.
 * @param {boolean} show if true - show widget. Otherwise - hide.
 */
Zapatec.Widget.prototype.showHideContainer = function(effects, animSpeed, onFinish, show){
	if(this.container == null){
		return null;
	}

	if(effects && effects.length > 0 && typeof(Zapatec.Effects) == 'undefined'){
		var self = this;

		zapatecTransport.loadJS({
			url: Zapatec.zapatecPath + '../zpeffects/src/effects.js',
			onLoad: function() {
				self.showHideContainer(effects, animSpeed, onFinish, show);
			}
		});

		return false;
	}

	if(animSpeed == null && isNaN(parseInt(animSpeed))){
		animSpeed = 5;
	}

	if(!effects || effects.length == 0){
		if(show){
			this.container.style.display = "";
		} else {
			this.container.style.display = 'none';
		}

		if (onFinish) {
			onFinish();
		}
	} else {
		if(show){
			Zapatec.Effects.show(this.container, animSpeed, effects, onFinish);
		} else {
			Zapatec.Effects.hide(this.container, animSpeed, effects, onFinish);
		}
	}

	return true;
}

/**
 * Loads data from the specified source.
 *
 * <pre>
 * If source is URL, fires events:
 * <ul>
 * <li><i>fetchSourceStart</i> before fetching of source</li>
 * <li><i>fetchSourceError</i> if fetch failed. Passes one argument to the
 * listener: error object received from {@link Zapatec.Transport#fetch}.</li>
 * <li><i>fetchSourceEnd</i> after source is fetched or fetch failed</li>
 * </ul>
 *
 * Fires events:
 * <ul>
 * <li><i>loadDataStart</i> before parsing of data</li>
 * <li><i>loadDataEnd</i> after data are parsed or error occured during
 * fetch</li>
 * </ul>
 *
 * <i>fetchSourceError</i> is fired before <i>fetchSourceEnd</i> and
 * <i>loadDataEnd</i>.
 * </pre>
 *
 * @param {object} oArg Arguments object passed to callbackSource function
 */
Zapatec.Widget.prototype.loadData = function(oArg) {
	var oConfig = this.config;
	// Get source using callback function
	if (typeof oConfig.callbackSource == 'function') {
		var oSource = oConfig.callbackSource.call(this, oArg);
		if (oSource) {
			if (typeof oSource.source != 'undefined') {
				oConfig.source = oSource.source;
			}
			if (typeof oSource.sourceType != 'undefined') {
				oConfig.sourceType = oSource.sourceType;
			}
			if (typeof oSource.method != 'undefined') {
				oConfig.sourceFetchMethod = oSource.method;
			}
			if (typeof oSource.contentType != 'undefined') {
				oConfig.sourceFetchContentType = oSource.contentType;
			}
			if (typeof oSource.content != 'undefined') {
				oConfig.sourceFetchContent = oSource.content;
			}
		}
	}
	// Process source
	var vSource = oConfig.source;
	var sSourceType = oConfig.sourceType;

	var fConvert = oConfig.callbackConvertSource;

	if (typeof fConvert != 'function') {
		fConvert = function(obj){return obj;};
	}

	if (vSource && typeof sSourceType == 'string') {
		sSourceType = sSourceType.toLowerCase();
		if (sSourceType == 'html') {
			this.fireEvent('loadDataStart');
			vSource = fConvert(vSource);
			this.loadDataHtml(zapatecWidget.getElementById(vSource));
			this.fireEvent('loadDataEnd');
		} else if (sSourceType == 'html/text') {
			this.fireEvent('loadDataStart');
			vSource = fConvert(vSource);
			this.loadDataHtmlText(vSource);
			this.fireEvent('loadDataEnd');
		} else if (sSourceType == 'html/url') {
			this.fireEvent('fetchSourceStart');
			// Fetch source
			var oWidget = this;
			this.dataRequest = zapatecTransport.fetch({
				// URL of the source
				url: vSource,
				// Method GET or POST
				method: oConfig.sourceFetchMethod,
				// Suspend script execution until source is loaded or error received
				async: oConfig.asyncSource,
				// Content type when method is POST
				contentType: oConfig.sourceFetchContentType,
				// Content when method is POST
				content: oConfig.sourceFetchContent,
				// Onload event handler
				onLoad: function(oRequest) {
					oWidget.dataRequest = null;
					oWidget.fireEvent('fetchSourceEnd');
					oWidget.fireEvent('loadDataStart');
					oWidget.loadDataHtmlText(fConvert(oRequest.responseText));
					oWidget.fireEvent('loadDataEnd');
					oWidget = null;
				},
				// Onerror event handler
				onError: function(oError) {
					oWidget.dataRequest = null;
					oWidget.fireEvent('fetchSourceError', oError);
					oWidget.fireEvent('fetchSourceEnd');
					oWidget.fireEvent('loadDataEnd');
					oWidget = null;
				}
			});
		} else if (sSourceType == 'json') {
			this.fireEvent('loadDataStart');
			
			if(typeof vSource == 'string'){
				if (oConfig.reliableSource) {
					vSource = eval(['(', vSource, ')'].join(''));
				} else {
					vSource = zapatecTransport.parseJson({strJson: vSource});
				}
			}

			vSource = fConvert(vSource);

			this.loadDataJson(vSource);
			this.fireEvent('loadDataEnd');
		} else if (sSourceType == 'json/url') {
			this.fireEvent('fetchSourceStart');
			// Fetch source
			var oWidget = this;
			this.dataRequest = zapatecTransport.fetchJsonObj({
				// URL of the source
				url: vSource,
				// Method GET or POST
				method: oConfig.sourceFetchMethod,
				// Suspend script execution until source is loaded or error received
				async: oConfig.asyncSource,
				// Content type when method is POST
				contentType: oConfig.sourceFetchContentType,
				// Content when method is POST
				content: oConfig.sourceFetchContent,
				// Skip JSON format verification
				reliable: oConfig.reliableSource,
				// Onload event handler
				onLoad: function(oResult) {
					oWidget.dataRequest = null;
					oWidget.fireEvent('fetchSourceEnd');
					oWidget.fireEvent('loadDataStart');
					oResult = fConvert(oResult);
					oWidget.loadDataJson(oResult);
					oWidget.fireEvent('loadDataEnd');
					oWidget = null;
				},
				// Onerror event handler
				onError: function(oError) {
					oWidget.dataRequest = null;
					oWidget.fireEvent('fetchSourceError', oError);
					oWidget.fireEvent('fetchSourceEnd');
					oWidget.fireEvent('loadDataEnd');
					oWidget = null;
				}
			});
		} else if (sSourceType == 'xml') {
			this.fireEvent('loadDataStart');
			
			if (typeof vSource != 'object') {
			    vSource = zapatecTransport.parseXml({
					strXml: vSource
				});
			}

			vSource = fConvert(vSource);
			
			this.loadDataXml(vSource);
			this.fireEvent('loadDataEnd');
		} else if (sSourceType == 'xml/url') {
			this.fireEvent('fetchSourceStart');
			// Fetch source
			var oWidget = this;
			this.dataRequest = zapatecTransport.fetchXmlDoc({
				// URL of the source
				url: vSource,
				// Method GET or POST
				method: oConfig.sourceFetchMethod,
				// Suspend script execution until source is loaded or error received
				async: oConfig.asyncSource,
				// Content type when method is POST
				contentType: oConfig.sourceFetchContentType,
				// Content when method is POST
				content: oConfig.sourceFetchContent,
				// Onload event handler
				onLoad: function(oResult) {
					oWidget.dataRequest = null;
					oWidget.fireEvent('fetchSourceEnd');
					oWidget.fireEvent('loadDataStart');
					oResult = fConvert(oResult);
					oWidget.loadDataXml(oResult);
					oWidget.fireEvent('loadDataEnd');
					oWidget = null;
				},
				// Onerror event handler
				onError: function(oError) {
					oWidget.dataRequest = null;
					oWidget.fireEvent('fetchSourceError', oError);
					oWidget.fireEvent('fetchSourceEnd');
					oWidget.fireEvent('loadDataEnd');
					oWidget = null;
				}
			});
		}
	} else {
		this.fireEvent('loadDataStart');
		vSource = fConvert(zapatecWidget.getElementById(vSource));
		this.loadDataHtml(vSource);
		this.fireEvent('loadDataEnd');
	}
};

/**
 * Loads data from the HTML source. Override this in child class.
 *
 * @param {object} oSource Source HTMLElement object
 */
Zapatec.Widget.prototype.loadDataHtml = function(oSource) {};

/**
 * Loads data from the HTML fragment source.
 *
 * @param {string} sSource Source HTML fragment
 */
Zapatec.Widget.prototype.loadDataHtmlText = function(sSource) {
	// Parse HTML fragment
	var oTempContainer = zapatecTransport.parseHtml(sSource);
	// Load data
	this.loadDataHtml(oTempContainer.firstChild);
};

/**
 * Loads data from the JSON source. Override this in child class.
 *
 * @param {object} oSource Source JSON object
 */
Zapatec.Widget.prototype.loadDataJson = function(oSource) {};

/**
 * Loads data from the XML source. Override this in child class.
 *
 * @param {object} oSource Source XMLDocument object
 */
Zapatec.Widget.prototype.loadDataXml = function(oSource) {};

/**
 * Aborts data load from server.
 */
Zapatec.Widget.prototype.loadDataAbort = function() {
	var oRequest = this.dataRequest;
	if (oRequest) {
		this.dataRequest = null;
		oRequest.onreadystatechange = function() {};
		oRequest.abort();
	}
};

/**
 * Loads data passed from other widget for example to view or edit them. Extend
 * this in child class.
 *
 * <pre>
 * Argument object format:
 * {
 *   widget: [object] Optional. Sender widget instance,
 *   data: [any] Data in format specific for each widget
 * }
 *
 * Saves passed widget in private property <i>dataSender</i> for later use in
 * {@link Zapatec.Widget#replyDataReturn}.
 *
 * Fires event:
 * <ul>
 * <li><i>receiveData</i>. Listener receives argument object passed to this
 * method.</li>
 * </ul>
 * </pre>
 *
 * @param {object} oArg Argument object
 */
Zapatec.Widget.prototype.receiveData = function(oArg) {
	if (!oArg) {
		oArg = {};
	}
	// Save reference
	this.dataSender = oArg.widget;
	this.fireEvent('receiveData', oArg);
};

/**
 * Prepares processed data to return them back to the sender in the same format
 * as they were received in {@link Zapatec.Widget#receiveData}. Extend this in
 * child class.
 *
 * @return Processed data in format specific for each widget.
 * @type any
 */
Zapatec.Widget.prototype.replyData = function() {
	return null;
};

/**
 * Cancels processing of the data received from the sender in
 * {@link Zapatec.Widget#receiveData}. Ususally just hides the widget (calls
 * hide method of the widget if it is defined).
 *
 * <pre>
 * Removes private property <i>dataSender</i>.
 *
 * Fires event:
 * <ul>
 * <li><i>replyDataCancel</i> before the widget is hidden</li>
 * </ul>
 * </pre>
 */
Zapatec.Widget.prototype.replyDataCancel = function() {
	this.fireEvent('replyDataCancel');
	if (typeof this.hide == 'function') {
		this.hide();
	}
	// Remove reference
	this.dataSender = null;
};

/**
 * Returns processed data back to the specified widget (not necessarily to the
 * same widget from which they were received in
 * {@link Zapatec.Widget#receiveData}). Passes data to
 * {@link Zapatec.Widget#acceptData} method of that widget. Then calls
 * {@link Zapatec.Widget#replyDataCancel} to hide this widget.
 *
 * <pre>
 * Argument object format:
 * {
 *   widget: [object] Optional. Receiver widget instance
 * }
 *
 * If receiver widget was not specified, uses widget passed to
 * {@link Zapatec.Widget#receiveData} and saved in private property
 * <i>dataSender</i>.
 *
 * Fires event:
 * <ul>
 * <li><i>replyDataReturn</i> before passing data to the specified widget.
 * Listener receives argument object passed to this method.</li>
 * </ul>
 * </pre>
 *
 * @param {object} oArg Argument object
 */
Zapatec.Widget.prototype.replyDataReturn = function(oArg) {
	if (!oArg) {
		oArg = {};
	}
	this.fireEvent('replyDataReturn', oArg);
	var oWidget = oArg.widget;
	if (!oWidget) {
		oWidget = this.dataSender;
	}
	if (!oWidget || typeof oWidget.acceptData != 'function') {
		return;
	}
	oWidget.acceptData({
		widget: this,
		data: this.replyData()
	});
	this.replyDataCancel();
};

/**
 * Receives data back from other widget previously passed to it using its
 * {@link Zapatec.Widget#receiveData} method. Extend this in child class.
 *
 * <pre>
 * Argument object format:
 * {
 *   widget: [object] Caller widget instance,
 *   data: [any] Data in format specific for each widget
 * }
 *
 * Fires event:
 * <ul>
 * <li><i>acceptData</i>. Listener receives argument object passed to this
 * method.</li>
 * </ul>
 * </pre>
 *
 * @param {object} oArg Argument object
 */
Zapatec.Widget.prototype.acceptData = function(oArg) {
	this.fireEvent('acceptData', oArg);
};

/**
 * Internal function to process language realted config options.
 * @private
 */
Zapatec.Widget.prototype.initLang = function(){
	// calculate hash key only once
	this.langStr = this.config.lang;

	if(this.config.langCountryCode && this.config.langCountryCode.length > 0){
		this.langStr += "_" + this.config.langCountryCode; 
	}

	if(this.config.langEncoding && this.config.langEncoding.length > 0){
		this.langStr += "-" + this.config.langEncoding; 
	}

	if(
		this.config.lang && 
		this.config.lang.length > 0 &&
		!(
			Zapatec.Langs[this.config.langId] &&
			Zapatec.Langs[this.config.langId][this.langStr]
		)
	){
		this.debug(
			"No language data found for language " + 
			this.config.lang + (
				this.config.langCountryCode ? 
				" and country code " + this.config.langCountryCode : ""
			) + (
				this.config.langEncoding ? 
				" and encoding " + this.config.langEncoding : ""
			)
		);

		this.config.lang = null;
		this.config.langCountryCode = null;
		this.config.langEncoding = null;
		this.langStr = null;
	}
};

/**
 * Get message for given key, make substitutions and return.
 * If more then 1 argument given - method will replace %1, .. %N with corresponding argument value
 * @param key {Object} String, object or anything else that can be treated as array key in Javascript. Required.
 * @param substitution1 {String} First substitution to the string. Optional.
 * ...
 * @param substitutionN {String} Last substitution to the string. Optional.
 */
Zapatec.Widget.prototype.getMessage = function(key){
	if(arguments.length == 0){
		return null;
	}

	if(
		!Zapatec.Langs[this.config.langId] || 
		!Zapatec.Langs[this.config.langId][this.langStr] ||
		!Zapatec.Langs[this.config.langId][this.langStr][key]
	){
		return key;
	}

	var res = Zapatec.Langs[this.config.langId][this.langStr][key];

	if(arguments.length > 1 && typeof(res) == "string"){
		for(var ii = 1; ii < arguments.length; ii++){
			var re = new RegExp("(^|([^\\\\]))\%"+ii);

			res = res.replace(re, "$2" + arguments[ii]);
		}
	}

	return res;
};

/**
 * Finds a widget by id and calls specified method with specified arguments and
 * returns value from that method.
 *
 * @param {number} iWidgetId Widget id
 * @param {string} sMethod Method name
 * @param {any} any Any number of arguments
 * @return Value returned from the method
 * @type any
 */
Zapatec.Widget.callMethod = function(iWidgetId, sMethod) {
	// Get Widget object
	var oWidget = zapatecWidgetGetWidgetById(iWidgetId);
	if (oWidget && typeof oWidget[sMethod] == 'function') {
		// Remove first two arguments
		var aArgs = [].slice.call(arguments, 2);
		// Call method
		return oWidget[sMethod].apply(oWidget, aArgs);
	}
};

/**
 * Shortcut for faster access to {@link Zapatec.Widget#callMethod}.
 * @private
 * @final
 */
zapatecWidgetCallMethod = zapatecWidget.callMethod;

/**
 * Converts element id to reference.
 *
 * @param {string} element Element id
 * @return Reference to element
 * @type object
 */
Zapatec.Widget.getElementById = function(element) {
	if (typeof element == 'string') {
		return document.getElementById(element);
	}
	return element;
};

/**
 * Shortcut for faster access to {@link Zapatec.Widget#getElementById}.
 * @private
 * @final
 */
zapatecWidgetGetElementById = zapatecWidget.getElementById;

/**
 * Returns style attribute of the specified element.
 *
 * @param {object} element Element
 * @return Style attribute value
 * @type string
 */
Zapatec.Widget.getStyle = function(element) {
	var style = element.getAttribute('style') || '';
	if (typeof style == 'string') {
		return style;
	}
	return style.cssText;
};

/**
 * Keeps last window dimensions to make sure window was really resized.
 * @private
 */
Zapatec.Widget.windowDimensions = null;

/**
 * Window onresize event listener. Checks that browser's window was really
 * resized because in IE resize event occurs also after applying style sheet.
 * If window was resized, fires global "windowResized" event.
 * @private
 */
Zapatec.Widget.onWindowResize = function() {
	var oWindowDimensions = zapatecWidget.windowDimensions;
	if (!oWindowDimensions) {
		// Widget was not initialized yet
		return;
	}
	// Get window dimensions without scroll bars
	var oNewDimensions = zapatecUtils.getWindowDimensions();
	// Check that dimensions have changed
	if (oWindowDimensions.width == oNewDimensions.width &&
	 oWindowDimensions.height == oNewDimensions.height) {
		return;
	}
	// Save new dimensions
	zapatecWidget.windowDimensions = oNewDimensions;
	// Fire event
	zapatecEventDriven.fireEvent('windowResized');
};

// Get window dimensions
zapatecWidget.windowDimensions = zapatecUtils.getWindowDimensions();

// Set window onresize event listener
zapatecUtils.addEvent(window, 'resize', zapatecWidget.onWindowResize, false, true);

/**
 * Displays debug information.
 *
 * @param {string} sMsg Debug message
 * @param {string} sType Optional. 'error' (default) or 'warn'
 */
Zapatec.Widget.debug = function(sMsg, sType) {
	if (typeof zapatecDebug == 'function') {
		zapatecDebug.log[sType || 'error'](sMsg);
	}
};

/**
 * Displays debug information preceded with current widget constructor name.
 *
 * @param {string} sMsg Debug message
 * @param {string} sType Optional. 'error' (default) or 'warn'
 */
Zapatec.Widget.prototype.debug = function(sMsg, sType) {
	zapatecWidget.debug(this.constructor.id + '[' + this.id + ']: ' + sMsg, sType);
};
