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

/* $Id: zapatec-core.js 15736 2009-02-06 15:29:25Z nikolai $ */

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
