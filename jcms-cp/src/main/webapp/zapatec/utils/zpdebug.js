/**
 * @fileoverview Zapatec Debug.
 *
 * <pre>
 * Copyright (c) 2004-2009 by Zapatec, Inc.
 * http://www.zapatec.com
 * 1700 MLK Way, Berkeley, California,
 * 94709, U.S.A.
 * All rights reserved.
 * </pre>
 */

/* $Id: zpdebug.js 15736 2009-02-06 15:29:25Z nikolai $ */

if (typeof zapatecDebug == 'undefined') {

if (typeof Zapatec == 'undefined') {
	/**
	 * @ignore Namespace definition.
	 */
	Zapatec = function() {};
}

/**
 * Zapatec Debug class.
 *
 * @constructor
 * @param {function} fLogger Optional logger callback; default
 * {@link Zapatec.Debug#popupLogger}
 */
zapatecDebug =
Zapatec.Debug = function (fLogger) {
	if (typeof fLogger == 'function') {
		this.logger = fLogger;
	} else {
		this.logger = zapatecDebug.popupLogger;
	}
};

/**
 * Displays message.
 *
 * @param {string} sMsg Message
 * @param {string} sLevel Optional message prefix
 */
Zapatec.Debug.prototype.out = function() { 
	this.logger.apply(this, arguments); 
};

/**
 * Displays "DEBUG" message.
 *
 * @param {string} sMsg Message
 */
Zapatec.Debug.prototype.debug = function(sMsg) {
	this.out(sMsg, 'DEBUG');
};

/**
 * Displays "WARN" message.
 *
 * @param {string} sMsg Message
 */
Zapatec.Debug.prototype.warn = function(sMsg) {
	this.out(sMsg, 'WARN');
};

/**
 * Displays "ERROR" message.
 *
 * @param {string} sMsg Message
 */
Zapatec.Debug.prototype.error = function(sMsg) {
	this.out(sMsg, 'ERROR');
};

/**
 * Dumps JSON object.
 *
 * @param {object} oObj JSON object
 */
Zapatec.Debug.prototype.json = function(oObj) {
	if (typeof zapatecTransport != 'undefined') {
		// Allow functions
		this.out(zapatecTransport.serializeJsonObj(oObj, true));
	}
};

/**
 * Logger callback. Writes messages to popup window. Must be called in scope of
 * {@link Zapatec#Debug} instance.
 *
 * @param {string} sMsg Message
 * @param {string} sLevel Optional message prefix
 */
Zapatec.Debug.popupLogger = function(sMsg, sLevel) {
	var oPopup = this.popup;
	if (!oPopup || !oPopup.document) {
		oPopup = this.popup = window.open('', 'zapatecDebug');
		if (!oPopup) {
			return;
		}
	}
	var oDoc = oPopup.document;
	var oTable = oDoc.getElementById('zpDebugTable');
	if (!oTable) {
		oDoc.writeln(
			'<table width="100%" id="zpDebugTable"><tr><th align="left" colspan="2">Time</th><th align="left">Message</th></tr></table>'
		);
		oDoc.close();
		oTable = oDoc.getElementById('zpDebugTable');
	}
	var oRow = oTable.insertRow(1);
	var oCell1 = oRow.insertCell(-1);
	var oCell2;
	if (sLevel) {
		oCell2 = oRow.insertCell(-1);
	} else {
		oCell1.setAttribute('colspan', 2);
	}
	var oCell3 = oRow.insertCell(-1);
	var oStyle1 = oCell1.style;
	oStyle1.fontSize = '70%';
	oStyle1.width = '1%';
	oStyle1.whiteSpace = 'nowrap';
	var oStyle2;
	if (oCell2) {
		oStyle2 = oCell2.style;
		oStyle2.fontSize = '70%';
		oStyle2.width = '1%';
		oStyle2.whiteSpace = 'nowrap';
	}
	var oStyle3 = oCell3.style;
	oStyle3.fontSize = '70%';
	if (oTable.rows.length % 2 == 0) {
		oStyle1.backgroundColor = '#EEE';
		if (oStyle2) {
			oStyle2.backgroundColor = '#EEE';
		}
		oStyle3.backgroundColor = '#EEE';
	}
	var oNow = new Date();
	var sHours = oNow.getHours();
	var sMinutes = oNow.getMinutes();
	if (sMinutes < 10) {
		sMinutes = '0' + sMinutes;
	}
	var sSeconds = oNow.getSeconds();
	if (sSeconds < 10) {
		sSeconds = '0' + sSeconds;
	}
	oCell1.innerHTML = sHours + ':' + sMinutes + ':' + sSeconds;
	if (oCell2) {
		oCell2.innerHTML = sLevel;
	}
	oCell3.innerHTML = sMsg;
};

/**
 * Logger callback. Writes messages to console or popup window. Must be called
 * in scope of {@link Zapatec#Debug} instance.
 *
 * @param {string} sMsg Message
 * @param {string} sLevel Optional message prefix
 */
Zapatec.Debug.consoleLogger = function(sMsg, sLevel) {
	if (window.console) {
		if (sLevel) {
			sLevel += ': ';
		}
		window.console.log(sLevel + sMsg);
	} else {
		zapatecDebug.popupLogger.apply(this, arguments);
	}
};

/**
 * Zapatec Debug instance. Use to output error messages.
 * @final
 */
Zapatec.Debug.log = new zapatecDebug();

/**
 * Zapatec Debug instance. Use to output error messages.
 * @private
 * @final
 */
zpLog = zapatecDebug.log;

}
