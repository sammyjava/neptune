/*!
 *
 * Copyright (c) 2004-2009 by Zapatec, Inc.
 * http://www.zapatec.com
 * 1700 MLK Way, Berkeley, California,
 * 94709, U.S.A.
 * All rights reserved.
 *
 *
 */
zapatecDoNotInclude=1;zapatecDoNotLoadThemes=1;zapatecStandalone=true;
if(typeof Zapatec == 'undefined'){
	Zapatec = {};
}
Zapatec.zapatecPath = function() {
	if (document.documentElement) {
		var pageText = document.documentElement.innerHTML;
		// Value from innerHTML doesn't contain redundant spaces and is always
		// inside double quotes
		var aTokens = pageText.match(/<script[^>]+src="([^"]*(?:6zap|cake|signup)-one\.js[^"]*)"/i);

		if (aTokens && aTokens.length >= 2) {
			var url = aTokens[1];
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
			var relativePath = '/';

			if(/<script[^>]+src="([^"]*6zap-one\.js[^"]*)"/i.test(pageText)){
				// relative path the same
				relativePath = "/../../";
			} else if(/<script[^>]+src="([^"]*cake-one\.js[^"]*)"/i.test(pageText)){
				relativePath = "/../../";
			} else if(/<script[^>]+src="([^"]*signup-one\.js[^"]*)"/i.test(pageText)){
				// no need to add anything
			}
			return aTokens.length ? aTokens.join('/') + relativePath + '../zapatec/utils/': '';
		}
	}
	// Not found
	return '';
} ();
