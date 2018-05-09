/**
 * @fileoverview Plug in for Zapatec Date library to enable Russian language.
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

/* $Id: zpdate-ru.js 17416 2009-05-06 08:08:48Z nmaxim $ */

/*
 * Populate dictionary.
 */
zapatecDict.set({
	date: {
		day: {
			sun: "Воскресенье",
			mon: "Понедельник",
			tue: "Вторник",
			wed: "Среда",
			thu: "Четверг",
			fri: "Пятница",
			sat: "Суббота"
		},
		shortDay: {
			sun: "Вс",
			mon: "Пн",
			tue: "Вт",
			wed: "Ср",
			thu: "Чт",
			fri: "Пт",
			sat: "Сб"
		},
		month: {
			jan: "Январь",
			feb: "Февраль",
			mar: "Март",
			apr: "Апрель",
			may: "Май",
			jun: "Июнь",
			jul: "Июль",
			aug: "Август",
			sep: "Сентябрь",
			oct: "Октябрь",
			nov: "Ноябрь",
			dec: "Декабрь"
		},
		shortMonth: {
			jan: "Янв",
			feb: "Фев",
			mar: "Мар",
			apr: "Апр",
			may: "Май",
			jun: "Июн",
			jul: "Июл",
			aug: "Авг",
			sep: "Сен",
			oct: "Окт",
			nov: "Ноя",
			dec: "Дек"
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
