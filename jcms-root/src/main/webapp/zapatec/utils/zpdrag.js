/**
 * @fileoverview Zapatec Drag library. Used to drag elements. Requires utils.js.
 *
 * <pre>
 * Copyright (c) 2004-2009 by Zapatec, Inc.
 * http://www.zapatec.com
 * 1700 MLK Way, Berkeley, California,
 * 94709, U.S.A.
 * All rights reserved.
 * </pre>
 */

/* $Id: zpdrag.js 15736 2009-02-06 15:29:25Z nikolai $ */

if (typeof Zapatec == 'undefined') {
	/**
	 * @ignore Namespace definition.
	 */
	Zapatec = function() {};
}

/**
 * @constructor
 */
Zapatec.Drag = function() {};

/**
 * Shortcut for faster access to {@link Zapatec#Drag}.
 * @private
 * @final
 */
zapatecDrag = Zapatec.Drag;

// Emulate window.event in Mozilla for some events. Required for Zapatec.Drag.
zapatecUtils.emulateWindowEvent(['mousedown', 'mousemove', 'mouseup']);

/**
 * Holds id of an element that is currently dragged.
 * @private
 */
Zapatec.Drag.currentId = null;

/**
 * Starts dragging an element.
 *
 * <xmp>
 * To make an element draggable, just attach Zapatec.Drag.start function to its
 * mousedown event:
 *
 * <div id="myDiv"
 *  onmousedown="return Zapatec.Drag.start(window.event, this.id)">
 * </div>
 *
 * It is not mandatory to use mousedown event like shown above. You can make
 * the element draggable from any part of your code just by calling
 * Zapatec.Drag.start function, or attach it to other event.
 * </xmp>
 *
 * <pre>
 * Fires static Zapatec events:
 *
 * <b>dragStart</b> before dragging is started. Listener receives following
 * object:
 * {
 *   el: [object] element got by id passed to Zapatec.Drag.start function,
 *   event: [object] event object passed to Zapatec.Drag.start function,
 *   args: [object] additional arguments passed to {@link Zapatec.Drag#start}
 * }
 *
 * <b>dragMove</b> on every mouse move while element is dragged. Listener
 * receives following object:
 * {
 *   el: [object] element got by id passed to Zapatec.Drag.start function,
 *   startLeft: [number] initial left offset,
 *   startTop: [number] initial top offset,
 *   prevLeft: [number] previous left offset,
 *   prevTop: [number] previous top offset,
 *   left: [number] current left offset,
 *   top: [number] current top offset,
 *   realLeft: [number] can be used to determine position or size of the element
 *    if its movement was not limited by vertical or step option,
 *   realTop: [number] can be used to determine position or size of the element
 *    if its movement was not limited by horizontal or step option,
 *   startWidth: [number] initial width,
 *   startHeight: [number] initial height,
 *   prevWidth: [number] previous width,
 *   prevHeight: [number] previous height,
 *   width: [number] current width,
 *   height: [number] current height,
 *   event: [object] event object,
 *   args: [object] additional arguments passed to {@link Zapatec.Drag#start}
 * }
 *
 * <b>dragEnd</b> after element was dropped. Listener receives following object:
 * {
 *   el: [object] element got by id passed to Zapatec.Drag.start function,
 *   startLeft: [number] initial left offset,
 *   startTop: [number] initial top offset,
 *   left: [number] current left offset,
 *   top: [number] current top offset,
 *   realLeft: [number] can be used to determine position or size of the element
 *    if its movement was not limited by vertical or step option,
 *   realTop: [number] can be used to determine position or size of the element
 *    if its movement was not limited by horizontal or step option,
 *   startWidth: [number] initial width,
 *   startHeight: [number] initial height,
 *   width: [number] current width,
 *   height: [number] current height,
 *   event: [object] event object,
 *   args: [object] additional arguments passed to {@link Zapatec.Drag#start}
 * }
 *
 * Offsets are in pixels and relative to offsetParent of the element.
 *
 * Additional arguments format:
 * {
 *   vertical: [boolean] if true, element moves only vertically,
 *   horizontal: [boolean] if true, element moves only horizontally,
 *   limitTop: [number] element doesn't go beyond this limit when moved up,
 *   limitBottom: [number] element doesn't go beyond this limit when moved down,
 *   limitLeft: [number] element doesn't go beyond this limit when moved to
 *    the left,
 *   limitRight: [number] element doesn't go beyond this limit when moved to
 *    the right,
 *   stepVertical: [number] vertical step in pixels - gives ability to move or
 *    resize element incrementally vertically,
 *   stepHorizontal: [number] horizontal step in pixels - gives ability to move
 *    or resize element incrementally horizontally,
 *   step: [number] sets both stepVertical and stepHorizontal to the same value,
 *   resize: [boolean or string] true - element is resized instead of dragging;
 *    'bottom-right' - element can be resized only by dragging bottom and right;
 *    'top-left' - element can be resized only by dragging top and left margins,
 *    margins
 * }
 *
 * limitTop, limitBottom, limitLeft and limitRight values are in pixels relative
 * to offsetParent of the element.
 *
 * Use 'bottom-right' and 'top-left' values for resize property if you need to
 * limit resizing possibility by direction.
 * </pre>
 *
 * @param {object} oEv Event object from which to get mouse position. In most
 * cases this is window.event. Note that when Zapatec.Drag is used, window.event
 * exists in all browsers. When one of mousedown, mousemove or mouseup events
 * occurs, window.event contains that event object.
 * @param {object} sId Id of the element that is dragged
 * @param {object} oArg Optional. Additional arguments
 * @return Always true
 * @type boolean
 */
Zapatec.Drag.start = function(oEv, sId, oArg) {
	// Get dragged element
	var oEl = zapatecWidgetGetElementById(sId);
	if (!oEl || oEl.zpDragArgs) {
		return true;
	}
	// Optional arguments
	if (!oArg) {
		oArg = {};
	}
	// Get mouse position
	var oPos = zapatecUtils.getMousePos(oEv || window.event);
	// Notify all that element is dragged
	zapatecEventDriven.fireEvent('dragStart', {
		el: oEl,
		event: oEv,
		args: oArg
	});
	// Set properties
	// Flags indicating that this element is dragged or resized
	oEl.zpDragArgs = {};
	var oDragArgs = oEl.zpDragArgs;
	// Save original arguments
	oDragArgs.args = oArg;
	// true - resize instead of dragging; 'bootm-right' and 'top-left' - limits
	// resizing possibility respectively
	oDragArgs.resize = oArg.resize;
	if (oArg.resize == 'bottom-right') {
		oDragArgs.resizeBottomRight = true;
	} else if (oArg.resize == 'top-left') {
		oDragArgs.resizeTopLeft = true;
	}
	// Mousedown event position
	oDragArgs.pageX = oPos.pageX;
	oDragArgs.pageY = oPos.pageY;
	// Original dimensions of the element
	oDragArgs.width = oEl.clientWidth;
	oDragArgs.height = oEl.clientHeight;
	// Previous dimensions of the element
	oDragArgs.prevWidth = oDragArgs.width;
	oDragArgs.prevHeight = oDragArgs.height;
	// Original position of the element
	// offsetLeft doesn't work properly in IE
	var sTag;
	var oOffsetParent = oEl.offsetParent;
	if (oOffsetParent) {
		sTag = oOffsetParent.tagName.toLowerCase();
	}
	if (sTag && sTag != 'body' && sTag != 'html') {
		oPos = zapatecUtils.getElementOffset(oEl);
		var oPosParent = zapatecUtils.getElementOffset(oOffsetParent);
		oDragArgs.left = oPos.left - oPosParent.left;
		oDragArgs.top = oPos.top - oPosParent.top;
	} else {
		oDragArgs.left = oEl.offsetLeft;
		oDragArgs.top = oEl.offsetTop;
	}
	oDragArgs.right = oDragArgs.left + oDragArgs.width;
	oDragArgs.bottom = oDragArgs.top + oDragArgs.height;
	// Previous position of the element
	oDragArgs.prevLeft = oDragArgs.prevRealLeft = oDragArgs.left;
	oDragArgs.prevTop = oDragArgs.prevRealTop = oDragArgs.top;
	// Flag indicating that moving only vertically or horizontally
	oDragArgs.vertical = oArg.vertical;
	oDragArgs.horizontal = oArg.horizontal;
	// Movement limits
	oDragArgs.limitTop =
	 typeof oArg.limitTop == 'number' ? oArg.limitTop : -Infinity;
	oDragArgs.limitBottom =
	 typeof oArg.limitBottom == 'number' ? oArg.limitBottom : Infinity;
	oDragArgs.limitLeft =
	 typeof oArg.limitLeft == 'number' ? oArg.limitLeft : -Infinity;
	oDragArgs.limitRight =
	 typeof oArg.limitRight == 'number' ? oArg.limitRight : Infinity;
	// Step
	if (typeof oArg.step == 'number') {
		oDragArgs.stepVertical = oDragArgs.stepHorizontal = oArg.step;
	}
	if (typeof oArg.stepVertical == 'number') {
		oDragArgs.stepVertical = oArg.stepVertical;
	}
	if (typeof oArg.stepHorizontal == 'number') {
		oDragArgs.stepHorizontal = oArg.stepHorizontal;
	}
	// Save id of currently moved element
	zapatecDrag.currentId = sId;
	// Set event listeners
	zapatecUtils.addEvent(document, 'mousemove', zapatecDrag.move);
	zapatecUtils.addEvent(document, 'mouseup', zapatecDrag.end);
	// Continue event
	return true;
};

/**
 * Moves element to the current mouse position. Gets called on document
 * mousemove event.
 *
 * @private
 * @param {object} oEv Event object
 * @return Always false
 * @type boolean
 */
Zapatec.Drag.move = function(oEv) {
	// Get event
	oEv || (oEv = window.event);
	// Make sure we are dragging anything
	if (!zapatecDrag.currentId) {
		return zapatecUtils.stopEvent(oEv);
	}
	var oEl = document.getElementById(zapatecDrag.currentId);
	if (!(oEl && oEl.zpDragArgs)) {
		return zapatecUtils.stopEvent(oEv);
	}
	var oDragArgs = oEl.zpDragArgs;
	var oStyle = oEl.style;
	// Get mouse position
	var oPos = zapatecUtils.getMousePos(oEv);
	// Calculate element position
	var oParam = {
		el: oEl,
		startLeft: oDragArgs.left,
		startTop: oDragArgs.top,
		prevLeft: oDragArgs.prevLeft,
		prevTop: oDragArgs.prevTop,
		left: oDragArgs.prevLeft,
		top: oDragArgs.prevTop,
		realLeft: oDragArgs.prevRealLeft,
		realTop: oDragArgs.prevRealTop,
		startWidth: oDragArgs.width,
		startHeight: oDragArgs.height,
		prevWidth: oDragArgs.prevWidth,
		prevHeight: oDragArgs.prevHeight,
		width: oDragArgs.prevWidth,
		height: oDragArgs.prevHeight,
		event: oEv,
		args: oDragArgs.args
	};
	var iOffset, iPos, iStep, iSize;
	// Horizontal offset
	iOffset = oPos.pageX - oDragArgs.pageX;
	oParam.realLeft = oDragArgs.prevRealLeft = oDragArgs.left + iOffset;
	iStep = oDragArgs.stepHorizontal;
	if (iStep) {
		// Step may be float
		iOffset = Math.round(Math.round(iOffset / iStep) * iStep);
	}
	iPos = oDragArgs.left + iOffset;
	// If it is not vertical
	if (!oDragArgs.vertical) {
		// Check limits
		if (oDragArgs.limitLeft <= iPos && oDragArgs.limitRight >= iPos) {
			// Inside limits
			if (oStyle.right) {
				// left and right can't exist together
				oStyle.right = '';
			}
			if (oDragArgs.resize) {
				// Resizing
				// By default element's position is not changed
				iPos = oDragArgs.left;
				if (oDragArgs.resizeBottomRight) {
					// Resizing in bottom and right directions only
					iSize = oDragArgs.width + iOffset;
				} else if (oDragArgs.resizeTopLeft) {
					// Resizing in top and left directions only
					iSize = oDragArgs.width - iOffset;
					if (iSize > 0) {
						// Zero and negative widths are not acceptable
						iPos = oDragArgs.right - iSize;
					}
				} else {
					// Resizing in all directions
					if (iOffset > 0) {
						iSize = oDragArgs.width + iOffset;
					} else {
						iSize = oDragArgs.width - iOffset;
						iPos = oDragArgs.right - iSize;
					}
				}
				if (iSize > 0) {
					// Zero and negative widths are not acceptable
					oStyle.width = iSize + 'px';
					oParam.width = oDragArgs.prevWidth = iSize;
				}
			}
			oStyle.left = iPos + 'px';
			oParam.left = oDragArgs.prevLeft = iPos;
		}
	}
	// Vertical offset
	iOffset = oPos.pageY - oDragArgs.pageY;
	oParam.realTop = oDragArgs.prevRealTop = oDragArgs.top + iOffset;
	iStep = oDragArgs.stepVertical;
	if (iStep) {
		// Step may be float
		iOffset = Math.round(Math.floor(iOffset / iStep) * iStep);
	}
	iPos = oDragArgs.top + iOffset;
	// If it is not horizontal
	if (!oDragArgs.horizontal) {
		// Check limits
		if (oDragArgs.limitTop <= iPos && oDragArgs.limitBottom >= iPos) {
			// Inside limits
			if (oStyle.bottom) {
				// top and bottom can't exist together
				oStyle.bottom = '';
			}
			if (oDragArgs.resize) {
				// Resizing
				// By default element's position is not changed
				iPos = oDragArgs.top;
				if (oDragArgs.resizeBottomRight) {
					// Resizing in bottom and right directions only
					iSize = oDragArgs.height + iOffset;
				} else if (oDragArgs.resizeTopLeft) {
					// Resizing in top and left directions only
					iSize = oDragArgs.height - iOffset;
					if (iSize > 0) {
						// Zero and negative heights are not acceptable
						iPos = oDragArgs.bottom - iSize;
					}
				} else {
					// Resizing in all directions
					if (iOffset > 0) {
						iSize = oDragArgs.height + iOffset;
					} else {
						iSize = oDragArgs.height - iOffset;
						iPos = oDragArgs.bottom - iSize;
					}
				}
				if (iSize > 0) {
					// Zero and negative heights are not acceptable
					oStyle.height = iSize + 'px';
					oParam.height = oDragArgs.prevHeight = iSize;
				}
			}
			oStyle.top = iPos + 'px';
			oParam.top = oDragArgs.prevTop = iPos;
		}
	}
	// Notify all that element was moved or resized
	zapatecEventDriven.fireEvent('dragMove', oParam);
	// Stop event
	return zapatecUtils.stopEvent(oEv);
};

/**
 * Finishes dragging. Gets called on document mouseup event.
 *
 * @private
 * @param {object} oEv Event object
 * @return Always false
 * @type boolean
 */
Zapatec.Drag.end = function(oEv) {
	// Get event
	oEv || (oEv = window.event);
	// Make sure we are dragging anything
	if (!zapatecDrag.currentId) {
		return zapatecUtils.stopEvent(oEv);
	}
	var oEl = document.getElementById(zapatecDrag.currentId);
	if (!(oEl && oEl.zpDragArgs)) {
		return zapatecUtils.stopEvent(oEv);
	}
	var oDragArgs = oEl.zpDragArgs;
	// Remove event listeners
	zapatecUtils.removeEvent(document, 'mousemove', zapatecDrag.move);
	zapatecUtils.removeEvent(document, 'mouseup', zapatecDrag.end);
	// Get element position
	var oParam = {
		el: oEl,
		startLeft: oDragArgs.left,
		startTop: oDragArgs.top,
		left: oDragArgs.prevLeft,
		top: oDragArgs.prevTop,
		realLeft: oDragArgs.prevRealLeft,
		realTop: oDragArgs.prevRealTop,
		startWidth: oDragArgs.width,
		startHeight: oDragArgs.height,
		width: oDragArgs.prevWidth,
		height: oDragArgs.prevHeight,
		event: oEv,
		args: oDragArgs.args
	};
	// Remove properties
	zapatecDrag.currentId = null;
	oEl.zpDragArgs = null;
	// Notify all that element was dropped
	zapatecEventDriven.fireEvent('dragEnd', oParam);
	// Stop event
	return zapatecUtils.stopEvent(oEv);
};
