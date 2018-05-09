// $Id: zpselenium.js 15736 2009-02-06 15:29:25Z nikolai $
/**
 *
 * Copyright (c) 2004-2009 by Zapatec, Inc.
 * http://www.zapatec.com
 * 1700 MLK Way, Berkeley, California,
 * 94709, U.S.A.
 * All rights reserved.
 */

/* ErrorHandler */
ErrorHandler = {};

ErrorHandler.setup = function(target_frame) {
	work_frame = target_frame;

	ErrorHandler.resetErrStack();

	work_frame.window.onerror = ErrorHandler.handleError;
}

ErrorHandler.handleError = function(desc, path, line) {
	ErrorHandler.err_stack.push([desc, path, line]);

	return false;
}

ErrorHandler.resetErrStack = function() {
	ErrorHandler.err_stack = [];
}

ErrorHandler.getErrStack = function() {
	return ErrorHandler.err_stack;
}

ErrorHandler.setup(self);

/* Capturing alerts */
if (window.parent != undefined && window.parent.selenium != undefined) 
	window.parent.selenium.browserbot.modifyWindowToRecordPopUpDialogs(self, window.parent.selenium.browserbot);
