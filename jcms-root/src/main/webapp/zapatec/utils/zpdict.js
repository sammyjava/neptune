/**
 * @fileoverview Zapatec Dictionary library. Used to translate various phrases
 * from English to current language.
 *
 * <pre>
 * Copyright (c) 2004-2009 by Zapatec, Inc.
 * http://www.zapatec.com
 * 1700 MLK Way, Berkeley, California,
 * 94709, U.S.A.
 * All rights reserved.
 * </pre>
 */

// $Id: zpdict.js 15736 2009-02-06 15:29:25Z nikolai $

if (typeof zapatecDict != 'function') {

if (typeof Zapatec == 'undefined') {
	/**
	 * @ignore Namespace definition.
	 */
	Zapatec = function() {};
}

/**
 * @constructor
 */
zapatecDict =
Zapatec.Dict = function() {};

/**
 * Dictionary. Contains key-value pairs. Key is English phrase, value is phrase
 * in current language.
 * @private
 */
Zapatec.Dict.phrases = {};

/**
 * Adds phrases to the dictionary.
 * Messages can be grouped like:
 * {
 *	firstGroup:{
 *		message1: "This is message 1 in first group",
 *		message2: "This is message 2 in first group"
 *	},
 *	secondGroup:{
 *		message1: "This is message 1 in second group",
 *		message2: "This is message 2 in second group"
 *	}
 * }
 * Messages can be accessed using zapatecTranslate("firstGroup.message1");
 * It will return "This is message 1 in first group"
 *
 * @param {object} oDict Key-value pairs. Key is English phrase, value is phrase
 * in current language.
 */
Zapatec.Dict.set = function(oDict) {
	var aPhrases = zapatecDict.phrases;

	// convert nested messages into dot-separated string
	function fFlatten(prefix, values){
		if(typeof values == "string"){
			aPhrases[prefix] = values;
			return;
		}

		if(prefix != ""){
			prefix += ".";
		}

		for (var sKey in values) {
			fFlatten(prefix + sKey, values[sKey]);
		}
	}

	fFlatten("", oDict);
};

/**
 * Returns translation of English phrase. If there is no translation, returns
 * phrase itself.
 *
 * <pre>
 * This function overwrites {@link Zapatec#translate}.
 * </pre>
 *
 * @param {string} sPhrase English phrase
 * @return Translation into current language or undefined in case of invalid
 * arguments
 * @type string
 */
zapatecTranslate =
Zapatec.translate =
Zapatec.Dict.translate = function(sPhrase) {
	// Translate
	var oPhrases = zapatecDict.phrases;

	if (oPhrases[sPhrase]) {
		sPhrase = oPhrases[sPhrase];
	}

	// make substitutions if more then one argument is passed.
	// replace %1, %2..., %N with corresponding argument
	if(arguments.length > 1 && typeof(sPhrase) == "string"){
		for(var ii = 1; ii < arguments.length; ii++){
			var re = new RegExp("(^|([^\\\\]))\%"+ii);

			sPhrase = sPhrase.replace(re, "$2" + arguments[ii]);
		}
	}
	
	return sPhrase;
};

/**
 * Translates an array. Calls {@link Zapatec.Dict#translate} for each element of
 * the array.
 *
 * <pre>
 * This function overwrites {@link Zapatec#translateArray}.
 * </pre>
 *
 * @param {object} aArray Array to translate
 * @return Translated array
 * @type object
 */
zapatecTranslateArray =
Zapatec.translateArray =
Zapatec.Dict.translateArray = function(aArray) {
	var iLen = aArray.length;
	for (var iItem = 0; iItem < iLen; iItem++) {
		// Translate item
		aArray[iItem] = zapatecTranslate(aArray[iItem]);
	}
	return aArray;
};

}
