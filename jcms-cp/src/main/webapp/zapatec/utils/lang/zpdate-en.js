/**
 * @fileoverview Plug in for Zapatec Date library to enable English language.
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

/* $Id: zpdate-en.js 16419 2009-03-17 19:02:38Z alex $ */

/*
 * Populate dictionary.
 */
zapatecDict.set({
	date: {
		day: {
			sun: "Sunday",
			mon: "Monday",
			tue: "Tuesday",
			wed: "Wednesday",
			thu: "Thursday",
			fri: "Friday",
			sat: "Saturday"
		},
		shortDay: {
			sun: "Sun",
			mon: "Mon",
			tue: "Tue",
			wed: "Wed",
			thu: "Thu",
			fri: "Fri",
			sat: "Sat"
		},
		month: {
			jan: "January",
			feb: "February",
			mar: "March",
			apr: "April",
			may: "May",
			jun: "June",
			jul: "July",
			aug: "August",
			sep: "September",
			oct: "October",
			nov: "November",
			dec: "December"
		},
		shortMonth: {
			jan: "Jan",
			feb: "Feb",
			mar: "Mar",
			apr: "Apr",
			may: "May",
			jun: "Jun",
			jul: "Jul",
			aug: "Aug",
			sep: "Sep",
			oct: "Oct",
			nov: "Nov",
			dec: "Dec"
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
