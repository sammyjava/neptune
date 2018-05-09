/**
 * @fileoverview Zapatec EventDriven library. Base EventDriven class. Contains
 * functions to handle events and basic methods for event-driven class.
 *
 * <pre>
 * Copyright (c) 2004-2009 by Zapatec, Inc.
 * http://www.zapatec.com
 * 1700 MLK Way, Berkeley, California,
 * 94709, U.S.A.
 * All rights reserved.
 * </pre>
 */

/* $Id: zpeventdriven.js 15736 2009-02-06 15:29:25Z nikolai $ */

if (typeof Zapatec == 'undefined') {
	/**
	 * @ignore Namespace definition.
	 */
	Zapatec = function() {};
}

/**
 * Base event-driven class.
 * @constructor
 */
Zapatec.EventDriven = function() {};

/**
 * Shortcut for faster access to {@link Zapatec#EventDriven}.
 * @private
 * @final
 */
zapatecEventDriven = Zapatec.EventDriven;

/**
 * Initializes object.
 * @private
 */
Zapatec.EventDriven.prototype.init = function() {
	// Holds events of this object
	this.events = {};
};

/**
 * Adds event listener to the end of list.
 *
 * <pre>
 * If multiple identical event listeners are registered on the same event, the
 * duplicate instances are discarded. They do not cause the event listener to be
 * called twice, and since the duplicates are discarded, they do not need to be
 * removed manually with the removeEventListener method.
 *
 * Synopsis:
 *
 * oEventDriven.addEventListener('eventName', fEventListener);
 *
 * There is also static method doing the same with global events:
 *
 * Zapatec.EventDriven.addEventListener('globalEventName', fEventListener);
 * </pre>
 *
 * @param {string} sEvent Event name
 * @param {function} fListener Event listener
 * @param {boolean} bOnetime Optional. If true, event listener is removed
 * automatically after first firing of the event
 */
Zapatec.EventDriven.prototype.addEventListener = function(sEvent, fListener, bOnetime) {
	if (typeof fListener != 'function') {
		return false;
	}
	var oEvents = this.events;
	var oEvent = oEvents[sEvent];
	if (!oEvent) {
		oEvents[sEvent] = {
			listeners: []
		};
		oEvent = oEvents[sEvent];
	} else {
		this.removeEventListener(sEvent, fListener);
	}
	if (bOnetime) {
		oEvent.listeners.push({
			listener: fListener,
			onetime: true
		});
	} else {
		oEvent.listeners.push(fListener);
	}
};

/**
 * Adds one-time event listener to global event to the end of list. Simply calls
 * {@link Zapatec.EventDriven#addEventListener}.
 *
 * @param {string} sEvent Event name
 * @param {function} fListener Event listener
 */
Zapatec.EventDriven.prototype.addOnetimeEventListener = function(sEvent, fListener) {
	return this.addEventListener(sEvent, fListener, true);
};

/**
 * Adds event listener to the beginning of list. Note that there is no guarantee
 * that it will be always first in the list. It will become second once this
 * method is called again. Never rely on that!
 *
 * <pre>
 * If multiple identical event listeners are registered on the same event, the
 * duplicate instances are discarded. They do not cause the event listener to be
 * called twice, and since the duplicates are discarded, they do not need to be
 * removed manually with the removeEventListener method.
 *
 * Synopsis:
 *
 * oEventDriven.unshiftEventListener('eventName', fEventListener);
 *
 * There is also static method doing the same with global events:
 *
 * Zapatec.EventDriven.unshiftEventListener('globalEventName', fEventListener);
 * </pre>
 *
 * @param {string} sEvent Event name
 * @param {function} fListener Event listener
 */
Zapatec.EventDriven.prototype.unshiftEventListener = function(sEvent, fListener) {
	if (typeof fListener != 'function') {
		return false;
	}
	var oEvents = this.events;
	var oEvent = oEvents[sEvent];
	if (!oEvent) {
		oEvents[sEvent] = {
			listeners: []
		};
		oEvent = oEvents[sEvent];
	} else {
		this.removeEventListener(sEvent, fListener);
	}
	oEvent.listeners.unshift(fListener);
};

/**
 * Removes event listener.
 *
 * <pre>
 * Synopsis:
 *
 * oEventDriven.removeEventListener('eventName', fEventListener);
 *
 * There is also static method doing the same with global events:
 *
 * Zapatec.EventDriven.removeEventListener('globalEventName', fEventListener);
 * </pre>
 *
 * @param {string} sEvent Event name
 * @param {function} fListener Event listener
 * @return Number of listeners removed
 * @type number
 */
Zapatec.EventDriven.prototype.removeEventListener = function(sEvent, fListener) {
	var oEvents = this.events;
	if (!oEvents[sEvent]) {
		return 0;
	}
	var aListeners = oEvents[sEvent].listeners;
	var iRemoved = 0;
	var oListener;
	for (var iListener = aListeners.length - 1; iListener >= 0; iListener--) {
		oListener = aListeners[iListener];
		if (oListener == fListener || oListener.listener == fListener) {
			aListeners.splice(iListener, 1);
			iRemoved++;
		}
	}
	return iRemoved;
};

/**
 * Removes all one-time event listeners of the specified event.
 *
 * <pre>
 * Synopsis:
 *
 * oEventDriven.removeOnetimeEventListeners('eventName');
 *
 * There is also static method doing the same with global events:
 *
 * Zapatec.EventDriven.removeOnetimeEventListeners('globalEventName');
 * </pre>
 *
 * @param {string} sEvent Event name
 * @return Number of listeners removed
 * @type number
 */
Zapatec.EventDriven.prototype.removeOnetimeEventListeners = function(sEvent) {
	var oEvents = this.events;
	if (!oEvents[sEvent]) {
		return 0;
	}
	var aListeners = oEvents[sEvent].listeners;
	var iRemoved = 0;
	for (var iListener = aListeners.length - 1; iListener >= 0; iListener--) {
		if (aListeners[iListener].onetime) {
			aListeners.splice(iListener, 1);
			iRemoved++;
		}
	}
	return iRemoved;
};

/**
 * Returns array of listeners for the specified event.
 *
 * <pre>
 * Synopsis:
 *
 * oEventDriven.getEventListeners('eventName');
 *
 * There is also static method doing the same with global events:
 *
 * Zapatec.EventDriven.getEventListeners('globalEventName');
 *
 * One-time event listeners appear in the result array as objects in following
 * format:
 * {
 *   listener: [function] event listener,
 *   onetime: [boolean] always true
 * }
 * </pre>
 *
 * @param {string} sEvent Event name
 * @return Array of function references
 * @type object
 */
Zapatec.EventDriven.prototype.getEventListeners = function(sEvent) {
	var oEvents = this.events;
	if (!oEvents[sEvent]) {
		return [];
	}
	return oEvents[sEvent].listeners;
};

/**
 * Checks if the event listener is attached to the event.
 *
 * <pre>
 * Synopsis:
 *
 * oEventDriven.isEventListener('eventName', fEventListener);
 *
 * There is also static method doing the same with global events:
 *
 * Zapatec.EventDriven.isEventListener('globalEventName', fEventListener);
 * </pre>
 *
 * @param {string} sEvent Event name
 * @param {function} fListener Event listener
 * @return True if event listener is attached to the event
 * @type boolean
 */
Zapatec.EventDriven.prototype.isEventListener = function(sEvent, fListener) {
	var oEvents = this.events;
	if (!oEvents[sEvent]) {
		return false;
	}
	var aListeners = oEvents[sEvent].listeners;
	var oListener;
	for (var iListener = aListeners.length - 1; iListener >= 0; iListener--) {
		oListener = aListeners[iListener];
		if (oListener == fListener || oListener.listener == fListener) {
			return true;
		}
	}
	return false;
};

/**
 * Checks if the event exists.
 *
 * <pre>
 * Synopsis:
 *
 * oEventDriven.isEvent('eventName');
 *
 * There is also static method doing the same with global events:
 *
 * Zapatec.EventDriven.isEvent('globalEventName');
 * </pre>
 *
 * @param {string} sEvent Event name
 * @return Exists
 * @type boolean
 */
Zapatec.EventDriven.prototype.isEvent = function(sEvent) {
	if (this.events[sEvent]) {
		return true;
	}
	return false;
};

/**
 * Removes all listeners for the event.
 *
 * <pre>
 * Synopsis:
 *
 * oEventDriven.removeEvent('eventName');
 *
 * There is also static method doing the same with global events:
 *
 * Zapatec.EventDriven.removeEvent('globalEventName');
 * </pre>
 *
 * @param {string} sEvent Event name
 */
Zapatec.EventDriven.prototype.removeEvent = function(sEvent) {
	var oEvents = this.events;
	if (oEvents[sEvent]) {
		var undef;
		oEvents[sEvent] = undef;
	}
};

/**
 * Fires event. Takes in one mandatory argument sEvent and optionally any number
 * of other arguments that should be passed to the listeners.
 *
 * <pre>
 * Synopsis:
 *
 * oEventDriven.fireEvent('eventName');
 *
 * There is also static method doing the same with global events:
 *
 * Zapatec.EventDriven.fireEvent('globalEventName');
 * </pre>
 *
 * @param {string} sEvent Event name
 */
Zapatec.EventDriven.prototype.fireEvent = function(sEvent) {
	var oEvents = this.events;
	if (!oEvents[sEvent]) {
		return;
	}
	// Duplicate array because it may be modified from within the listeners
	var aListeners = oEvents[sEvent].listeners.slice();
	var iListeners = aListeners.length;
	var aArgs, oListener;
	for (var iListener = 0; iListener < iListeners; iListener++) {
		// Remove first argument
		aArgs = [].slice.call(arguments, 1);
		// Call event listener in scope of this object
		oListener = aListeners[iListener];
		if (typeof oListener == 'function') {
			oListener.apply(this, aArgs);
		} else {
			oListener.listener.apply(this, aArgs);
		}
	}
	// Remove one-time event listeners
	this.removeOnetimeEventListeners(sEvent);
};

/**
 * Holds global events.
 * @private
 */
Zapatec.EventDriven.events = {};

/**
 * Adds event listener to global event to the end of list.
 *
 * <pre>
 * If multiple identical event listeners are registered on the same event, the
 * duplicate instances are discarded. They do not cause the event listener to be
 * called twice, and since the duplicates are discarded, they do not need to be
 * removed manually with the removeEventListener method.
 * </pre>
 *
 * @param {string} sEvent Event name
 * @param {function} fListener Event listener
 * @param {boolean} bOnetime Optional. If true, event listener is removed
 * automatically after first firing of the event
 */
Zapatec.EventDriven.addEventListener = function(sEvent, fListener, bOnetime) {
	if (typeof fListener != 'function') {
		return false;
	}
	var oEvents = zapatecEventDriven.events;
	var oEvent = oEvents[sEvent];
	if (!oEvent) {
		oEvents[sEvent] = {
			listeners: []
		};
		oEvent = oEvents[sEvent];
	} else {
		zapatecEventDriven.removeEventListener(sEvent, fListener);
	}
	if (bOnetime) {
		oEvent.listeners.push({
			listener: fListener,
			onetime: true
		});
	} else {
		oEvent.listeners.push(fListener);
	}
};

/**
 * Adds one-time event listener to global event to the end of list. Simply calls
 * {@link Zapatec.EventDriven#addEventListener}.
 *
 * @param {string} sEvent Event name
 * @param {function} fListener Event listener
 */
Zapatec.EventDriven.addOnetimeEventListener = function(sEvent, fListener) {
	return zapatecEventDriven.addEventListener(sEvent, fListener, true);
};

/**
 * Adds event listener to global event to the beginning of list. Note that there
 * is no guarantee that it will be always first in the list. It will become
 * second once this method is called again. Never rely on that!
 *
 * <pre>
 * If multiple identical event listeners are registered on the same event, the
 * duplicate instances are discarded. They do not cause the event listener to be
 * called twice, and since the duplicates are discarded, they do not need to be
 * removed manually with the removeEventListener method.
 * </pre>
 *
 * @param {string} sEvent Event name
 * @param {function} fListener Event listener
 */
Zapatec.EventDriven.unshiftEventListener = function(sEvent, fListener) {
	if (typeof fListener != 'function') {
		return false;
	}
	var oEvents = zapatecEventDriven.events;
	var oEvent = oEvents[sEvent];
	if (!oEvent) {
		oEvents[sEvent] = {
			listeners: []
		};
		oEvent = oEvents[sEvent];
	} else {
		zapatecEventDriven.removeEventListener(sEvent, fListener);
	}
	oEvent.listeners.unshift(fListener);
};

/**
 * Removes event listener from global event.
 *
 * @param {string} sEvent Event name
 * @param {function} fListener Event listener
 * @return number of listeners removed
 * @type number
 */
Zapatec.EventDriven.removeEventListener = function(sEvent, fListener) {
	var oEvents = zapatecEventDriven.events;
	if (!oEvents[sEvent]) {
		return 0;
	}
	var iRemoved = 0;
	var aListeners = oEvents[sEvent].listeners;
	var oListener;
	for (var iListener = aListeners.length - 1; iListener >= 0; iListener--) {
		oListener = aListeners[iListener];
		if (oListener == fListener || oListener.listener == fListener) {
			aListeners.splice(iListener, 1);
			iRemoved++;
		}
	}
	return iRemoved;
};

/**
 * Removes all one-time event listeners of the specified global event.
 *
 * @param {string} sEvent Event name
 * @return Number of listeners removed
 * @type number
 */
Zapatec.EventDriven.removeOnetimeEventListeners = function(sEvent) {
	var oEvents = zapatecEventDriven.events;
	if (!oEvents[sEvent]) {
		return 0;
	}
	var aListeners = oEvents[sEvent].listeners;
	var iRemoved = 0;
	for (var iListener = aListeners.length - 1; iListener >= 0; iListener--) {
		if (aListeners[iListener].onetime) {
			aListeners.splice(iListener, 1);
			iRemoved++;
		}
	}
	return iRemoved;
};

/**
 * Returns array of listeners for the specified global event.
 *
 * <pre>
 * One-time event listeners appear in the result array as objects in following
 * format:
 * {
 *   listener: [function] event listener,
 *   onetime: [boolean] always true
 * }
 * </pre>
 *
 * @param {string} sEvent Event name
 * @return Array of function references
 * @type object
 */
Zapatec.EventDriven.getEventListeners = function(sEvent) {
	var oEvents = zapatecEventDriven.events;
	if (!oEvents[sEvent]) {
		return [];
	}
	return oEvents[sEvent].listeners;
};

/**
 * Checks if the event listener is attached to the global event.
 *
 * @param {string} sEvent Event name
 * @param {function} fListener Event listener
 * @return True if event listener is attached to the event
 * @type boolean
 */
Zapatec.EventDriven.isEventListener = function(sEvent, fListener) {
	var oEvents = zapatecEventDriven.events;
	if (!oEvents[sEvent]) {
		return false;
	}
	var aListeners = oEvents[sEvent].listeners;
	var oListener;
	for (var iListener = aListeners.length - 1; iListener >= 0; iListener--) {
		oListener = aListeners[iListener];
		if (oListener == fListener || oListener.listener == fListener) {
			return true;
		}
	}
	return false;
};

/**
 * Checks if the global event exists.
 *
 * @param {string} sEvent Event name
 * @return Exists
 * @type boolean
 */
Zapatec.EventDriven.isEvent = function(sEvent) {
	if (zapatecEventDriven.events[sEvent]) {
		return true;
	}
	return false;
};

/**
 * Removes all listeners for the global event.
 *
 * @param {string} sEvent Event name
 */
Zapatec.EventDriven.removeEvent = function(sEvent) {
	var oEvents = zapatecEventDriven.events;
	if (oEvents[sEvent]) {
		var undef;
		oEvents[sEvent] = undef;
	}
};

/**
 * Fires global event. Takes in one mandatory argument sEvent and optionally any
 * number of other arguments that should be passed to the listeners.
 *
 * @param {string} sEvent Event name
 */
Zapatec.EventDriven.fireEvent = function(sEvent) {
	var oEvents = zapatecEventDriven.events;
	var oEvent = oEvents[sEvent];
	if (!oEvent) {
		return;
	}
	// Duplicate array because it may be modified from within the listeners
	var aListeners = oEvent.listeners.slice();
	var iListeners = aListeners.length;
	var oListener, aArgs;
	for (var iListener = 0; iListeners--; iListener++) {
		// Remove first argument
		aArgs = [].slice.call(arguments, 1);
		// Call event listener
		oListener = aListeners[iListener];
		if (typeof oListener == 'function') {
			oListener.apply(oListener, aArgs);
		} else {
			oListener.listener.apply(oListener, aArgs);
		}
	}
	// Remove one-time event listeners
	Zapatec.EventDriven.removeOnetimeEventListeners(sEvent);
};
