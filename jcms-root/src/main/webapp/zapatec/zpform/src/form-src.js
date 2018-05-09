// $Id: form.js 15736 2009-02-06 15:29:25Z nikolai $
/**
 * @fileoverview Zapatec Form widget. Include this file in your HTML page.
 * Includes Zapatec Form modules: zpform.js, field.js, validator.js, utils.js.
 *
 * <pre>
 * Copyright (c) 2004-2009 by Zapatec, Inc.
 * http://www.zapatec.com
 * 1700 MLK Way, Berkeley, California,
 * 94709, U.S.A.
 * All rights reserved.
 * </pre>
 */

/**
 * Get path to this script
 * @private
 */

Zapatec.formPath = Zapatec.getPath("Zapatec.FormWidget");

// Include required scripts
Zapatec.Transport.include(Zapatec.formPath + '../lang/en.js');
Zapatec.Transport.include(Zapatec.formPath + 'form-core.js', "Zapatec.Form");
Zapatec.Transport.include(Zapatec.formPath + 'form-field.js', "Zapatec.Form.Field");
Zapatec.Transport.include(Zapatec.formPath + 'form-validator.js');
Zapatec.Transport.include(Zapatec.formPath + 'form-utils.js');
