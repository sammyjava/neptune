/**
 * @fileoverview Zapatec Widget language file.
 * Requires utils/zpdict.js. To translate the widget, simply include this
 * file into your HTML page after zpdict.js.
 * Author: Ricardo Vega
 *
 * <pre>
 * Copyright (c) 2004-2009 by Zapatec, Inc.
 * http://www.zapatec.com
 * 1700 MLK Way, Berkeley, California,
 * 94709, U.S.A.
 * All rights reserved.
 * </pre>
 */

/* $Id: translation.php 16582 2009-03-24 11:14:18Z roman $ */

/*
 * Populate dictionary.
 */
Zapatec.Dict.set({
	"date":{
		"day":{
			"sun":"Domingo",
			"mon":"Lunes",
			"tue":"Martes",
			"wed":"Miércoles",
			"thu":"Jueves",
			"fri":"Viernes",
			"sat":"Sábado"
		},
		"shortDay":{
			"sun":"Dom",
			"mon":"Lun",
			"tue":"Mar",
			"wed":"Mie",
			"thu":"Jue",
			"fri":"Vie",
			"sat":"Sab"
		},
		"month":{
			"jan":"Enero",
			"feb":"Febrero",
			"mar":"Marzo",
			"apr":"Abril",
			"may":"Mayo",
			"jun":"Junio",
			"jul":"Julio",
			"aug":"Agosto",
			"sep":"Septiembre",
			"oct":"Octubre",
			"nov":"Noviembre",
			"dec":"Diciembre"
		},
		"shortMonth":{
			"jan":"Ene",
			"feb":"Feb",
			"mar":"Mar",
			"apr":"Abr",
			"may":"May",
			"jun":"Jun",
			"jul":"Jul",
			"aug":"Ago",
			"sep":"Sep",
			"oct":"Oct",
			"nov":"Nov",
			"dec":"Dic"
		},
		"misc":{
			"am":"am",
			"AM":"AM",
			"pm":"pm",
			"PM":"PM"
		}
	}
});

// Translate constants if this file was loaded after zpdate.js
if (typeof zapatecDate == 'function') {
	zapatecDate.translate();
}
