/**
 * @fileoverview Plug in for Zapatec Date library to enable French language.
 * Requires utils/zpdict.js. To translate Zapatec Date, simply include this file
 * into your HTML page after zpdict.js.
 *
 * <pre>
 * Copyright (c) 2004-2009 by Zapatec, Inc.
 * http://www.zapatec.com
 * 1700 MLK Way, Berkeley, California,
 * 94709, U.S.A.
 * All rights reserved.
 * </pre>
 */

/* $Id: zpdate-fr.js 17416 2009-05-06 08:08:48Z nmaxim $ */

/*
 * Populate dictionary.
 */
zapatecDict.set({
	date: {
		day: {
			sun: "Dimanche",
			mon: "Lundi",
			tue: "Mardi",
			wed: "Mercredi",
			thu: "Jeudi",
			fri: "Vendredi",
			sat: "Samedi"
		},
		shortDay: {
			sun: "Dim",
			mon: "Lun",
			tue: "Mar",
			wed: "Mer",
			thu: "Jeu",
			fri: "Ven",
			sat: "Sam"
		},
		month: {
			jan: "Janvier",
			feb: "Février",
			mar: "Mars",
			apr: "Avril",
			may: "Mai",
			jun: "Juin",
			jul: "Juillet",
			aug: "Août",
			sep: "Septembre",
			oct: "Octobre",
			nov: "Novembre",
			dec: "Décembre"
		},
		shortMonth: {
			jan: "Jan",
			feb: "Fév",
			mar: "Mar",
			apr: "Avr",
			may: "Mai",
			jun: "Juin",
			jul: "Juil",
			aug: "Août",
			sep: "Sep",
			oct: "Oct",
			nov: "Nov",
			dec: "Déc"
		},
		misc: {
			am: 'am',
			AM: 'AM',
			pm: 'pm',
			PM: 'PM'
		}
	}
});

// Translate constants if this file was loaded after zpdate.js
if (typeof zapatecDate == 'function') {
	zapatecDate.translate();
}
