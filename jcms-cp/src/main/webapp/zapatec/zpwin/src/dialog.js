// $Id: dialog.js 15736 2009-02-06 15:29:25Z nikolai $
/**
 *
 * Copyright (c) 2004-2009 by Zapatec, Inc.
 * http://www.zapatec.com
 * 1700 MLK Way, Berkeley, California,
 * 94709, U.S.A.
 * All rights reserved.
 */
Zapatec.dialogsPath = Zapatec.getPath("Zapatec.DialogsWidget");

// Include required scripts
Zapatec.Transport.include(Zapatec.windowPath + '../lang/eng.js');
Zapatec.Transport.include(Zapatec.dialogsPath + 'alert.js', "Zapatec.AlertWindow");
Zapatec.Transport.include(Zapatec.dialogsPath + 'confirm.js', "Zapatec.ConfirmWindow");
Zapatec.Transport.include(Zapatec.dialogsPath + 'generic-dialog.js', "Zapatec.DialogWindow");

