// $Id: zpeditor-src.js
/**
 * @fileoverview Zapatec Editor widget. Include this file in your HTML page.
 * Includes base Zapatec Editor modules and required auxiliary modules.
 * To extend Editor with other features like Color or Character chooser
 * include respective modules manually in your HTML page.
 *
 * <pre>
 * Copyright (c) 2004-2008 by Zapatec, Inc.
 * http://www.zapatec.com
 * 1700 MLK Way, Berkeley, California,
 * 94709, U.S.A.
 * All rights reserved.
 * </pre>
 */

/**
 * Path to Zapatec Editor scripts.
 * @private
 */
Zapatec.editorPath = Zapatec.getPath('Zapatec.EditorWidget');

// Include required scripts
Zapatec.Transport.include(Zapatec.zapatecPath + "button.js", "Zapatec.Button");
Zapatec.Transport.include(Zapatec.zapatecPath + "pane.js", "Zapatec.Pane");

Zapatec.Transport.include(Zapatec.editorPath + '../lang/eng.js');
Zapatec.Transport.include(Zapatec.editorPath + "zpeditor-core.js", "Zapatec.MinimalEditor");
