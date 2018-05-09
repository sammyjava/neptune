// $Id: de-ansi.js 8863 2007-11-12 14:18:33Z andrew $
// German using ansi
// Deutsch mittels ansi
Zapatec.Utils.createNestedHash(Zapatec, ["Langs", "Zapatec.Form", "de-ansi"], {
    'initializeError': 'Formular ist bereits initialisiert!',
	'loadingForm': 'Formular wird geladen',
	'noFormError': "Formular konnte nicht gefunden werden",

	'submitOneError': 'Es trat ein Fehler auf.',
	'submitManyErrors': 'Es traten %1 Fehler auf.',

	'isRequiredError': 'Dieses Feld, muss ausgefüllt werden.',
	'maskNotFilledError': 'Der Feldwert stimmt nicht mit der Maske %1 überein.',
	'noSuchAutoCompleteValueError': 'Wert nicht vorhanden.',
	'invalidURLError': 'Ungültige URL',
	'invalidEmailError': 'Ungültige Email Adresse',
	'invalidCreditCardError': 'Ungültige Kreditkartennummer',
	'invalidUSPhoneError': 'Ungültige US Telefonnummer',
	'invalidInternationalPhoneError': 'Ungültige internationale Telefonnummer',
	'invalidUSZipError': 'Ungültige US Postleitzahl',
	'invalidDateError': 'Ungültiges Datum',
	'invalidIntError': 'Es wurde keine Ganzzahl angegeben',
	'invalidFloatError': 'Es wurde keine Zahl angegeben',

	'ajaxDebugSeparator': '-----------------------',
	'ajaxDebugSubmitTitle': 'Sende Anfrage für AJAX Formular.',
	'ajaxDebugValidateTitle': 'Sende Anfrage für Validierung des Feldes %1, durch AJAX.',
	'ajaxDebugFillTitle': 'Sende Anfrage für AJAX Wertangabe für das Feld %1.',
	'ajaxDebugQuery': 'Abfrage: %1',
	'ajaxDebugResponse': 'Erhaltene Antwort: %1',
	'ajaxDebugResponseError': 'Ein Fehler wurde zurückgegeben: %1',

	'ajaxSubmitCantParseError': "Kann erhaltenen JSON nicht parsen: %1",
	'ajaxSubmitNoResponseError': 'Keine Antwort erhalten',

	'ajaxValidateCantParseError': "Kann erhaltenen JSON nicht parsen: %1",
	'ajaxValidateNoResponseError': 'Keine Antwort erhalten',
	'ajaxValidateValidationError': 'Die Angabe in dem Feld ist ungültig',

	'ajaxFillCantParseError': "Kann erhaltenen JSON nicht parsen: %1",
	'ajaxFillNoResponseError': 'Keine Antwort erhalten',
	'ajaxFillGeneralError': "Werte konnten nicht abgerufen werden.",

	'ajaxSuggestCantParseError': "Kann erhaltenen JSON nicht parsen: %1",
	'ajaxSuggestNoResponseError': 'Keine Antwort erhalten',
	'ajaxSuggestGeneralError': "Wert kann nicht Abgerufen werden"
});