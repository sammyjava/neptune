<?
/* $Id: validate_ajax.php 6264 2007-02-13 09:48:47Z andrew $ */

require_once 'JSON.php';
$json_converter = new Services_JSON();
$response = array();
$response['success'] = false;
$response['fieldErrors'] = array();

sleep(1);

if(isset($_GET['name'])){
	$name = $_GET['name'];

	if($name == "Joe" || $name == "Jane" || $name == "George" || $name == "Judy") {
		$response['fieldErrors']['name'] = "This login is already busy";
	}
} else {
	$response['fieldErrors']['name'] = "No name were given";
}

if(!isset($_GET["password1"])){
	$response['fieldErrors']['password1'] = "Fill 'Password' field";
}

if(!isset($_GET["password2"])){
	$response['fieldErrors']['password2'] = "Fill 'Password Again' field";
}

if(isset($_GET["password1"]) && isset($_GET["password2"]) && $_GET["password1"] != $_GET["password2"]){
	$response['fieldErrors']['password1'] = "Passwords do not match";
	$response['fieldErrors']['password2'] = "Passwords do not match";
}

if(sizeof($response['fieldErrors']) == 0){
	$response['success'] = true;

	header('Content-type: text/plain');
	echo $json_converter->encode($response);
} else {
	if(isset($_GET["callback"])){
		echo ("<html><body><script type='text/javascript'>" . $_GET["callback"] . "(" . $json_converter->encode($response) . ")</script></body></html>");
	} else {
		header('Content-type: text/plain');
		echo $json_converter->encode($response);
	}
}
?>
