// $Id: window-states-modes.js 15736 2009-02-06 15:29:25Z nikolai $
/**
 *
 * Copyright (c) 2004-2009 by Zapatec, Inc.
 * http://www.zapatec.com
 * 1700 MLK Way, Berkeley, California,
 * 94709, U.S.A.
 * All rights reserved.
 */

/**
 * Sets the widgets privillage mode to on.
 * @param mode [string] - mode to set.
 */
Zapatec.Window.prototype.setModeOn = function(mode) {
	//nothing to turn on
	if (typeof mode != "string") {
		return false;
	}
	//no mode object - let's create it
	if (!this.widgetModes[mode]) {
		this.widgetModes[mode] = {};
	}
	//setting it to be on
	this.widgetModes[mode].on = true;
	//saving the caller method, which turned the mode on
	this.widgetModes[mode].caller = this.setModeOn.caller;
	//firing event of turning specified mode on
	this.fireEvent(mode + "_on", this);
	//returning success
	return true;
};

/**
 * Sets the widgets privillage mode to off.
 * @param mode [string] - mode to set.
 */
Zapatec.Window.prototype.setModeOff = function(mode) {
	//no mode specified or non existing mode - returning false
	if (typeof mode != "string" || !this.widgetModes[mode]) {
		return false;
	}
	//setting mode to be off
	this.widgetModes[mode].on = false;
	//clearing caller
	this.widgetModes[mode].caller = null;
	//firing event of turning specified mode off
	this.fireEvent(mode + "_off", this);
	//returning success
	return true;
};

/** 
 * Returns true if the mode is on, otherwise false
 * @param mode [string] - mode to check
 * @return true if the mode is on, otherwise false
 */
Zapatec.Window.prototype.modeOn = function(mode) {
	//checking if mode is on
	if (this.widgetModes[mode] && this.widgetModes[mode].on === true) {
		return true;
	}
	//mode is off
	return false;
};

/**
 * Returns true if called function was called from the method that set the mode.
 * @param mode [string] - mode to check
 * @param caller [function] - called function.
 * @return returns true if called function was called from the method that set the mode.
 */
Zapatec.Window.prototype.modeSameCaller = function(mode, caller) {
	//walking up in caller chain to determine if there is a function we seek
	while(caller) {
		//same caller
		if (caller.caller == this.widgetModes[mode].caller) {
			//returning success
			return true;
		}
		//going up if not
		caller = caller.caller;
	}
	//returning failure
	return false;
};

/**
 * Checks if needed state was reached and tryes to fire function exactly when it needs.
 * @param state [string] - required state;
 * @param func [function] - function needed to be fired
 * @param first [boolean] - should it go first
 * @return true if the state was already reached
 */
Zapatec.Window.prototype.fireOnState = function(state, func) {
	var self = this;
	//if immediate execution mode is on we don't need to schedule
	if (this.modeOn("immediate_execution") && this.modeSameCaller("immediate_execution", this.fireOnState)) {
		return true;
	}
	//special way for BODY load
	if (state == "body_loaded") {
		//Object was destroyed!
		if (!this.stateReached("created")) {
			return false;
		}
		//not loaded? - let's try again in 50 msecs
		if (!Zapatec.windowLoaded) {
			setTimeout(function() {func.call(self);}, 50);
			return false;
		}
		
		return true;
	}
	//was state reached?
	if (!this.stateReached(state)) {
		//Object was destroyed!
		if (!this.stateReached("created")) {
			return false;
		}
		//if priveleged execution mode turned on put listener to
		//high priority events array
		if (this.modeOn("privileged_execution") && this.modeSameCaller("privileged_execution", this.fireOnState)) {
			this.highPriorityEvents.push({"state" : state, "listener" : func, "executed" : false});
			return false;
		}	
		//if delayed execution mode turned on put listener to
		//delayed events array
		if (this.modeOn("delayed_execution")) {
			this.delayedEvents.push({"state" : state, "listener" : func});
			return false;
		}
		//or lets just add listener to the state
		this.addEventListener(state, func);
		//returning false, as function can not be executed
		//and was scheduled
		return false;
	} else {
		//state was reached we can execute function
		return true;
	}
};

/**
 * Changes the state of the widget, firing all the events planned
 * @param state [string] - state to set.
 * @return true if succeeds, otherwise false
 */
Zapatec.Window.prototype.changeState = function(state) {
	//if delayed execution was on lets schedule changing state
	//on turning this mode off
	if (this.modeOn("delayed_execution")) {
		this.addEventListener("delayed_execution_off", function() {this.changeState(state);});
	}
	//if priveleged execution was on lets turn it off
	if (this.modeOn("privileged_execution")) {
		this.setModeOff("privileged_execution");
	}
	//changing state
	this.widgetState = state;
	//no execution scheduled - no action
	if (!this.isEvent(state)) {
		return;
	}
	//executing listeners
	var listeners = this.getEventListeners(state);
	for(var ii = 0; ii < listeners.length; ++ii) {
		//if delayed execution wasn't on lets execute the function,
		//otherwise lets schedule changing state on turning this mode off
		if (!this.modeOn("delayed_execution")) {
			listeners[ii].apply(this);
		} else {
			this.addEventListener("delayed_execution_off", listeners[ii]);
		}
	}
	//clearing events
	this.removeEvent(state);
	//returning success
	return true;
};

/**
 * This method tells you wether the state you need was reached or maybe already passed.
 * Right now we have following states:
 * 'destroyed' - the object was destroyed;
 * 'created' - the instance of the object was created;
 * 'inited' - the object was inited (this include initing all variables, calling parent
 *            init and starting loading structure);
 * 'loaded' - the structure is loaded and parsed;
 * 'ready' - object has all the parts ready for work;
 * 'hidden' - object is visually hidden;
 * 'shown' - object is visible;
 * @param state [string] - the name of the state you need to check;
 * @return - true if the state was reached or already passed, otherwise false
 */
Zapatec.Window.prototype.stateReached = function(state) {
	//getting current state priority.
	//if there is no such in our priority array we give it the highest priority, 
	//which means count of states avaliable in the array.
	var currentState = this.priorities[this.widgetState] || (this.priorities[this.widgetState] !== 0 ? this.priorities.count : 0);
	//getting passed state priority.
	//if there is no such in our priority array we give it the highest priority, 
	//which means count of states avaliable in the array.
	state = this.priorities[state] || (this.priorities[state] !== 0 ? this.priorities.count : 0);
	//and now compareing them
	if (state > currentState) {return false;}
	return true;
};
