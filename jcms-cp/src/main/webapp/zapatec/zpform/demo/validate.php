<?php /* $Id: validate.php 4433 2006-09-14 07:53:49Z shacka $ */ ?>
{
<?
sleep(1);

if(isset($_GET['name'])){
	$name = $_GET['name'];

	if($name == "Joe" || $name == "Jane" || $name == "George" || $name == "Judy") {
?>
	"success": false,
	"generalError": "This login is already busy"
<?
	} else {
?>
	"success": true
<?
	}

} else {
?>
	"success": false,
	"generalError": "No name were given"
<?
}
?>
}
