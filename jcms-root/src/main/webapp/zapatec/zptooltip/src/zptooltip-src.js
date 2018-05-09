/**
 * @fileoverview Zapatec Tooltip widget. Include this file in your HTML page.
 * Includes base Zapatec Tooltip modules: zptooltip-core.js.
 *
 * <pre>
 * Copyright (c) 2004-2009 by Zapatec, Inc.
 * http://www.zapatec.com
 * 1700 MLK Way, Berkeley, California,
 * 94709, U.S.A.
 * All rights reserved.
 * </pre>
 */

/* $Id: zptooltip.js 15736 2009-02-06 15:29:25Z nikolai $ */

/**
 * Path to Zapatec Tooltip scripts.
 * @private
 */
Zapatec.tooltipPath = Zapatec.getPath('Zapatec.TooltipWidget');

// Include required scripts
Zapatec.include(Zapatec.tooltipPath + 'zptooltip-core.js', 'Zapatec.Tooltip');
