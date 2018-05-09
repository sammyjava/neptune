<?php
/* $Id: post.php 7323 2007-06-01 21:05:51Z alex $ */

require_once 'JSON.php';

$objJsonConverter = new Services_JSON();

// Pause to demonstrate "Busy" animation
sleep(1);

// Form response
$arrResponse = array(
	"success" => "Thank you! Data received successfully.",
	"first" => isset($_POST["first"]) ? $_POST["first"] : "",
	"last" => isset($_POST["last"]) ? $_POST["last"] : "",
	"org" => isset($_POST["org"]) ? $_POST["org"] : ""
);

// Send response
echo $objJsonConverter->encode($arrResponse);

?>
