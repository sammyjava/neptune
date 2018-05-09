/**
 * @fileoverview Loads generic modules required for all widgets.
 *
 * <pre>
 * Copyright (c) 2004-2009 by Zapatec, Inc.
 * http://www.zapatec.com
 * 1700 MLK Way, Berkeley, California,
 * 94709, U.S.A.
 * All rights reserved.
 * </pre>
 */

/* $Id: zapatec.js 15736 2009-02-06 15:29:25Z nikolai $ */

if (typeof Zapatec == 'undefined') {
	/**
	 * @ignore Namespace definition.
	 */
	Zapatec = function() {};
}

/**
 * Zapatec Suite version.
 */
Zapatec.version = '07-02';

// Init flags
if (typeof zapatecDoNotInclude == 'undefined') {
	zapatecDoNotInclude = 0;
}
if (typeof zapatecDoNotLoadThemes == 'undefined') {
	zapatecDoNotLoadThemes = 0;
}

// For backward compatibility
if (Zapatec.doNotInclude) {
	zapatecDoNotInclude = 1;
}

// Stubs
if (typeof zapatecDict != 'function') {

	/**
	 * See {@link Zapatec.Dict#translate}. This function does nothing unless
	 * zpdict.js is included.
	 *
	 * @param {string} sPhrase English phrase
	 * @return Translation into current language or undefined in case of invalid
	 * arguments
	 * @type string
	 */
	zapatecTranslate =
	Zapatec.translate = function(sPhrase) {
		return sPhrase;
	};

	/**
	 * See {@link Zapatec.Dict#translateArray}. This function does nothing unless
	 * zpdict.js is included.
	 *
	 * @param {object} aArray Array to translate
	 * @return Translated array
	 * @type object
	 */
	zapatecTranslateArray =
	Zapatec.translateArray = function(aArray) {
		return aArray;
	};

}

// Get path to main Zapatec script
if (typeof Zapatec.zapatecPath == 'undefined') {

	/**
	 * Path to main Zapatec script.
	 */
	Zapatec.zapatecPath = function() {
		if (document.documentElement) {
			// Value from innerHTML doesn't contain redundant spaces and is always
			// inside double quotes
			var aTokens = document.documentElement.innerHTML.match(
			 /<script[^>]+src="([^"]*zapatec(-src)?\.js[^"]*)"/i);
			if (aTokens && aTokens.length >= 2) {
				// Get path
				aTokens = aTokens[1].split('?');
				aTokens = aTokens[0].split('/');
				// Remove last token
				if (Array.prototype.pop) {
					aTokens.pop();
				} else {
					// IE 5
					aTokens.length -= 1;
				}
				return aTokens.length ? aTokens.join('/') + '/' : '';
			}
		}
		// Not found
		return '';
	} ();

}

/**
 * Simply writes script tag to the document.
 *
 * <pre>
 * If special zapatecDoNotInclude flag is set, this function does nothing.
 *
 * If transport.js is included, this function is overwritten by
 * {@link Zapatec.Transport#include}.
 * </pre>
 *
 * @param {string} sSrc Src attribute value of the script element
 * @param {string} sId Optional. Id of the script element
 */
Zapatec.include = function(sSrc, sId) {
	// Check flag
	if (zapatecDoNotInclude) {
		return;
	}
	// Include file
	document.write('<script type="text/javascript" src="' + 
	 sSrc + (typeof sId == 'string' ? '" id="' + sId : '') + '"></script>');
};

/*
 * Include required scripts
 */
Zapatec.include(Zapatec.zapatecPath + 'utils.js', 'Zapatec.Utils');
Zapatec.include(Zapatec.zapatecPath + 'zpeventdriven.js', 'Zapatec.EventDriven');
Zapatec.include(Zapatec.zapatecPath + 'preloadimages.js', 'Zapatec.PreloadImages');
Zapatec.include(Zapatec.zapatecPath + 'stylesheet.js', 'Zapatec.StyleSheet');
Zapatec.include(Zapatec.zapatecPath + 'transport.js', 'Zapatec.Transport');
Zapatec.include(Zapatec.zapatecPath + 'zpdrag.js', 'Zapatec.Drag');
Zapatec.include(Zapatec.zapatecPath + 'zpwidget.js', 'Zapatec.Widget');
