// $Id: window-globals.js 15736 2009-02-06 15:29:25Z nikolai $
/**
 *
 * Copyright (c) 2004-2009 by Zapatec, Inc.
 * http://www.zapatec.com
 * 1700 MLK Way, Berkeley, California,
 * 94709, U.S.A.
 * All rights reserved.
 */

// Global that keeps track of z-index of windows
Zapatec.Window.maxNumber = 5;
// Global that holds the pointer to the current window
Zapatec.Window.currentWindow = null;
// Global that holds the current position to minimize to
Zapatec.Window.minimizeLeft = 0;
// Global that determines the minimal width of the window
Zapatec.Window.minWinWidth = 120;
// Global that keeps last active window
Zapatec.Window.lastActive = null;

/**
 * \internal
 * Sorts all the minimized windows at the bottom when one of them was restored to the simple state.
 */
Zapatec.Window.sortMin = function (raised) {
  //getting the place where raised Window was
  var place = raised.getScreenPosition().x, win = null, left = 0;
  //iterating through asll widgets
  for (var i = 0; i < Zapatec.Widget.all.length; ++i) {
    //we work only with Window widget
    if (Zapatec.Widget.all[i] && Zapatec.Widget.all[i].widgetType == "window") {
      //taking window
      win = Zapatec.Widget.all[i];
      //if it is there and minimized lets move it
      if (win && win.state.state == "min") {
        //taking its position
        left = win.getScreenPosition().x;
        //if it is after the raised one lets move it for Zapatec.Window.minWinWidth
        if (left > place) {
          left -= Zapatec.Window.minWinWidth + 5;
          win.setScreenPosition(left - (Zapatec.Utils.bodyOffset ? Zapatec.Utils.bodyOffset.left : 0), "bottom");
        }
      }
    }
  }
  //clearing the reference
  win = null;
  //decrementing Zapatec.Window.minimizeLeft
  Zapatec.Window.minimizeLeft -= Zapatec.Window.minWinWidth + 5;
};

/**
 * Activates the window which is free.
 * @param me {object} window that requested this(can not be activated).
 * @return {boolean} true if success, otherwise false.
 */
Zapatec.Window.activateFreeWindow = function(me) {
  if (Zapatec.Window.activating) {
    return false;
  }
  //trying to activate last active window
  var win = Zapatec.Window.lastActive;
  Zapatec.Window.lastActive = me;
  if (win && win != me && win.canActivate() === true) {
    win.activate();
    return true;
  }
  //otherwise we seek possible one in array of all widgets
  var allW = Zapatec.Widget.all;
  var minimized = null;
  for(var iWidget = 0; iWidget < allW.length; ++iWidget) {
    win = allW[iWidget];
    //if it is window and can be activated - then lets do it!
    if (win && win.widgetType == "window" && win != me) {
      if (win.canActivate() === true) {
        win.activate();
        return true;
      } else if (win.canActivate() == "min" && !minimized) {
        minimized = win;
      }
    }
  }
  if (minimized) {
    minimized.activate();
    return true;
  } else {
    Zapatec.Window.currentWindow = null;
    return false;
  }
};

//who is activating currently :)
Zapatec.Window.activating = null;

/**
 * A function that is called to handle mousedown event for our window.
 * @param ev [object] - event object.
 * @param win [object] - our window object.
 * @param target [object] - "pushed" element.
 */
Zapatec.Window.mouseDown = function (ev, win, target) {
  //trying to activate the Window
  if (!win.config.raiseOnlyOnTitle) {
    win.activate();
  } else if (target && target.buttonType == "title") {
    win.activate();
  }
  //if it content we should not stop events as it disables selection
  if (target && target.buttonType != "content") {
    return Zapatec.Utils.stopEvent(ev);
  }
};

/**
 * A function that is called to handle mousemove event for our window.
 * @param ev [object] - event object.
 * @param win [object] - our window object.
 * @param target [object] - "pushed" element.
 */
Zapatec.Window.mouseMove = function (ev, win, target) {
};

/**
 * A function that is called to handle mouseup event for our window.
 * @param ev [object] - event object.
 * @param win [object] - our window object.
 * @param target [object] - "pushed" element.
 */
Zapatec.Window.mouseUp = function (ev, win, target) {
};

/**
 * A function that is called to handle doubleclick event for our window.
 * @param ev [object] - event object.
 * @param win [object] - our window object.
 * @param target [object] - "pushed" element.
 */
Zapatec.Window.dblClick = function (ev, win, target) {
  //proceeding double click
  if (target) {
    switch (target.buttonType) {
      case "title" : {
        switch (win.state.state) {
          case "min" : {
            //restore from minimized on double click
            win.restore();

            break;
          }
          case "max" : {
            //restore from maximize on double click
            win.restore();

            break;
          }
          case "simple" : {
            //maximize on double click if it is simple
            win.maximize();

            break;
          }
        }

        break;
      }
    }
    //we need to do drag end cause in reality dragging was started
    win.dragEnd(ev);
    //if it content we should not stop events as it disables selection
    if (target.buttonType != "content") {
      return Zapatec.Utils.stopEvent(ev);
    }
  }
}
