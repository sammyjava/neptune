// $Id: window-setup.js 15736 2009-02-06 15:29:25Z nikolai $
/**
 *
 * Copyright (c) 2004-2009 by Zapatec, Inc.
 * http://www.zapatec.com
 * 1700 MLK Way, Berkeley, California,
 * 94709, U.S.A.
 * All rights reserved.
 */

/**
 * This is a setup function for Window object.
 *
 * It gathers some mostly common routines when seting up the Window object on your page.
 * For example it creates the simple window and shows it, or creates the popup window.
 * Mostly in all cases (except popup window) it will be initialy shown. Possible enhancement
 * is to add a property to control the initial state of the window (including minimized, maximized, etc)
 *
 * @param config [object] - all parameters are passed as the properties of this object. Many of them are 
 * the same as for the constructor.
 * 
 * Function recognizes the following properties of the config object (duplicated properties are listed in 
 * the constructor description so are not included here):
 * \code
 *    prop. name   | description
 *  -------------------------------------------------------------------------------------------------
 *   popup         | if it is set than window will be a popup window, triggered by the element you passed in this variable.
 *   triggerEvent  | if popup is set than this defines which event of the trigger element will force the window to popup. 
 *                 | Possible values: click, mousemove, mouseover, or any DOM event name.
 *   align         | align of the popup window relational to the trigger object. For information on values see the Zapatec.Window.prototype.showAtElement function description
 *   width         | initial width of the window in pixels.
 *   height        | initial height of the window in pixels.
 *   left          | initial X coordinate of the window.
 *   top           | initial Y coordinate of the window.
 *   title         | title of the window.
 *   content       | content of the window.
 *   divContent    | id of or "pointer" to the HTML element containing the content for the window.
 *   urlContent    | URL to load the content from.
 *   initialState  | initial state of the window: "hidden", "visible"
 *   
 * \endcode
 */
Zapatec.Window.setup = function (config) {
	var winConfig = Zapatec.Hash.remove(config, 
		"popup", "triggerEvent", "align", "width",
		"height", "left", "top", "title", "content",
		"divContent", "urlContent", "initialState"
	) || {}, 
	win = null;
	if (config.popup) {
		winConfig.hideOnClose = true;
		win = new Zapatec.Window(winConfig);
		win.create(0, 0, config.width || win.config.minWidth, config.height || win.config.minHeight);
		if (typeof config.popup == "string") {
			config.popup = document.getElementById(config.popup);
		}
		if (!config.popup) {
			alert(win.getMessage('setupWrongTriggerError'));
			win.close();
			return;
		}
		if (!config.triggerEvent) {
			config.triggerEvent = "click";
		}
		if (!config.align) {
			config.align = null;
		}
		el = config.popup;
		el["on" + config.triggerEvent] = function (ev) {
			win.show();
			win.restore();
			win.setWidth(config.width || win.config.minWidth);
			win.setHeight(config.height || win.config.minHeight);
			win.hide();
			if (!win.config.visible) {
				win.showAtElement(this, config.align);
			}
			if (config.title) {
				win.setTitle(config.title);
			}
			if (config.content) {
				win.setContent(config.content);
			}
			if (config.divContent) {
				win.setDivContent(config.divContent);
			}
			if (config.urlContent) {
				win.setContentUrl(config.urlContent);
			}
			
			return false;
		};
		
	} else {
		win = new Zapatec.Window(winConfig);
		win.create(config.left || 0, config.top || 0, config.width || win.config.minWidth, config.height || win.config.minHeight);
		if (config.initialState != "hidden") {
			win.show();
		}
		if (config.title) {
			win.setTitle(config.title);
		}
		if (config.content) {
			win.setContent(config.content);
		}
		if (config.divContent) {
			win.setDivContent(config.divContent);
		}
		if (config.urlContent) {
			win.setContentUrl(config.urlContent);
		}
	}
	
	return win;
};
