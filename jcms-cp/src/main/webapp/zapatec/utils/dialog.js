// $Id: dialog.js 15736 2009-02-06 15:29:25Z nikolai $
/*
 * <pre>
 * Copyright (c) 2004-2009 by Zapatec, Inc.
 * http://www.zapatec.com
 * 1700 MLK Way, Berkeley, California,
 * 94709, U.S.A.
 * All rights reserved.
 * </pre>
 */

// Though "Dialog" looks like an object, it isn't really an object.  Instead
// it's just namespace for protecting global symbols.

function Dialog(url, name, width, height, action, init) {
	if (typeof init == "undefined") {
		init = window;	// pass this window object by default
	}
	Dialog._geckoOpenModal(url, name, width, height, action, init);
};

Dialog._parentEvent = function(ev) {
	if (Dialog._modal && !Dialog._modal.closed) {
		Dialog._modal.focus();
		Zapatec.Utils.stopEvent(ev);
	}
};

// should be a function, the return handler of the currently opened dialog.
Dialog._return = null;

// constant, the currently opened dialog
Dialog._modal = null;

// the dialog will read it's args from this variable
Dialog._arguments = null;

Dialog._geckoOpenModal = function(url, name, width, height, action, init) {
	var dlg = Zapatec.Utils.newCenteredWindow(url, name, width, height, 'no');
	Dialog._modal = dlg;
	Dialog._arguments = init;

	// capture some window's events
	function capwin(w) {
		Zapatec.Utils.addEvent(w, "click", Dialog._parentEvent);
		Zapatec.Utils.addEvent(w, "mousedown", Dialog._parentEvent);
		Zapatec.Utils.addEvent(w, "focus", Dialog._parentEvent);
	};
	// release the captured events
	function relwin(w) {
		Zapatec.Utils.removeEvent(w, "click", Dialog._parentEvent);
		Zapatec.Utils.removeEvent(w, "mousedown", Dialog._parentEvent);
		Zapatec.Utils.removeEvent(w, "focus", Dialog._parentEvent);
	};
	capwin(window);
	// capture other frames
	for (var i = 0; i < window.frames.length; capwin(window.frames[i++]));
	// make up a function to be called when the Dialog ends.
	Dialog._return = function (val) {
		if (val && action) {
			action(val);
		}
		relwin(window);
		// capture other frames
		for (var i = 0; i < window.frames.length; relwin(window.frames[i++]));
		Dialog._modal = null;
	};
};
