// $Id: bg-ansi.js 8863 2007-11-12 14:18:33Z andrew $
// Bulgarian using ANSI encoding
// Български с ANSI encoding
Zapatec.Utils.createNestedHash(Zapatec, ["Langs", "Zapatec.Form", "bg-ansi"], {
    'initializeError': 'Формата е вече инициализирана!',
	'loadingForm': 'Формата зарежда',
	'noFormError': "Формата не може да бъде намерена.",

	'submitOneError': 'Има 1 грешка.',
	'submitManyErrors': 'Има %1 грешки.',

	'isRequiredError': 'Полето е задължително',
	'maskNotFilledError': 'Не отговаря на маската %1',
	'noSuchAutoCompleteValueError': 'Няма такава стойност',
	'invalidURLError': 'Невалиден URL',
	'invalidEmailError': 'Невалиден e-mail адрес',
	'invalidCreditCardError': 'Невалиден номер на кредитна карта.',
	'invalidUSPhoneError': 'Невалиден телефонен номер',
	'invalidInternationalPhoneError': 'Невалиден вътрешен телефонен номер.',
	'invalidUSZipError': 'Невалиден пощенски код',
	'invalidDateError': 'Невалидна дата',
	'invalidIntError': 'Не е цяло число',
	'invalidFloatError': 'Не е дробно число',

	'ajaxDebugSeparator': '-----------------------',
	'ajaxDebugSubmitTitle': 'Изпраща AJAX заявка за изпращане на форма.',
	'ajaxDebugValidateTitle': 'Изпраща AJAX заявка за валидиране на поле %1.',
	'ajaxDebugFillTitle': 'Изпраща AJAX заявка за попълване на поле %1.',
	'ajaxDebugQuery': 'Заявка: %1',
	'ajaxDebugResponse': 'Получен отговор: %1',
	'ajaxDebugResponseError': 'Получен грешен отговор: %1',

	'ajaxSubmitCantParseError': "Не може да обработи получения JSON: %1",
	'ajaxSubmitNoResponseError': 'Няма отговор',

	'ajaxValidateCantParseError': "Не може да обработи получения JSON: %1",
	'ajaxValidateNoResponseError': 'Няма отговор',
	'ajaxValidateValidationError': 'Полето не е валидно',

	'ajaxFillCantParseError': "Не може да обработи получения JSON: %1",
	'ajaxFillNoResponseError': 'Няма отговор',
	'ajaxFillGeneralError': "Не може да извлече стойностите за попълване",

	'ajaxSuggestCantParseError': "Не може да обработи получения JSON: %1",
	'ajaxSuggestNoResponseError': 'Няма отговор',
	'ajaxSuggestGeneralError': "Не може да извлече стойността"
});
