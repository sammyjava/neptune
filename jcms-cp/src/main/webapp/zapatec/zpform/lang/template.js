// $Id: template.js 7350 2007-06-05 10:03:57Z andrew $
Zapatec.Utils.createNestedHash(Zapatec, ["Langs", "Zapatec.Form", "en"], {
    'initializeError': 'Form already initialized!', // message to display if user tries to call Zapatec.Form constructor for already created Zapatec.Form
	'loadingForm': 'loading form', // message to display until form theme is not loaded
	'noFormError': "Couldn't find form", // message to display when no reference to FORM element is given

	'submitOneError': 'There is 1 error.', // general error on submit if there was one error
	'submitManyErrors': 'There are %1 errors.', // general error on submit if there was many errors

	'isRequiredError': 'This field is required', // error message for required fields
	'maskNotFilledError': 'Does not conform to mask %1', // error message for masked fields that are not filled
	'noSuchAutoCompleteValueError': 'No such value', // error when user typed value that is not present in AutoCompleteStrict
	'invalidURLError': 'Invalid URL', // error when user has typed invalid URL
	'invalidEmailError': 'Invalid email address', // error when user has typed invalid email
	'invalidCreditCardError': 'Invalid credit card number', // error when user has typed invalid credit card number
	'invalidUSPhoneError': 'Invalid US phone number', // error when user has typed invalid US phone number
	'invalidInternationalPhoneError': 'Invalid international phone number', // error when user has typed invalid internation phone number
	'invalidUSZipError': 'Invalid US zip code', // error when user has typed invalid US zip
	'invalidDateError': 'Invalid date', // error when user has typed invalid date
	'invalidIntError': 'Not an integer', // error when user has typed not an integer
	'invalidFloatError': 'Not a float', // error when user has typed not a float
	'maxLengthError': 'Please enter less then %1 symbols', // error when user has typed more characters then allowed
	'minLengthError': 'Please enter more then %1 symbols', // error when user has typed too few characters

	// technical messages. Usually seen only by web-developers
	'ajaxDebugSeparator': '-----------------------', // separator for debug message
	'ajaxDebugSubmitTitle': 'Sending request for AJAX submit form.', // info message for ajax debug
	'ajaxDebugValidateTitle': 'Sending request for AJAX validate field %1.', // info message for ajax debug
	'ajaxDebugFillTitle': 'Sending request for AJAX fill for field %1.', // info message for ajax debug
	'ajaxDebugQuery': 'Query: %1', // prefix for query when sending AJAX request
	'ajaxDebugResponse': 'Response received: %1', // prefix for received response text
	'ajaxDebugResponseError': 'Error response received: %1', // error happend while retrieving data

	'ajaxSubmitCantParseError': "Can't parse received JSON: %1", // error when invalid JSON retrieved in asyncSubmit
	'ajaxSubmitNoResponseError': 'No response', // when null response was retrieved in asyncSubmit

	'ajaxValidateCantParseError': "Can't parse received JSON: %1", // error when invalid JSON retrieved in asyncSubmit
	'ajaxValidateNoResponseError': 'No response', // when null response was retrieved in asyncSubmit
	'ajaxValidateValidationError': 'This field is not valid', // displayed if AJAX validation fails and no generalError given

	'ajaxFillCantParseError': "Can't parse received JSON: %1", // error when invalid JSON retrieved in ajaxFill
	'ajaxFillNoResponseError': 'No response', // when null response was retrieved in ajaxFill
	'ajaxFillGeneralError': "Can't retrieve fill values", // displayed if AJAX fill fails and no generalError given

	'ajaxSuggestCantParseError': "Can't parse received JSON: %1", // error when invalid JSON retrieved in ajaxSuggest
	'ajaxSuggestNoResponseError': 'No response', // when null response was retrieved in ajaxSuggest
	'ajaxSuggestGeneralError': "Can't retrieve value" // displayed if AJAX suggest fails and no generalError given
});
