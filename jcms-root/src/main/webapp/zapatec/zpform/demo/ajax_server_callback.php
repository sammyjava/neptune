<?
// $Id: ajax_server_callback.php 6447 2007-02-23 15:59:41Z andrew $

require_once 'JSON.php';
$json_converter = new Services_JSON();
$response = array();
$response['success'] = false;
$response['fieldErrors'] = array();

sleep(1);

if(isset($_POST['name'])){
	$name = $_POST['name'];

	if($name == "Joe" || $name == "Jane" || $name == "George" || $name == "Judy") {
		$response['fieldErrors']['name'] = "This login is already busy";
	}
} else {
	$response['fieldErrors']['name'] = "No name were given";
}

if(!isset($_POST["password1"])){
	$response['fieldErrors']['password1'] = "Fill 'Password' field";
}

if(!isset($_POST["password2"])){
	$response['fieldErrors']['password2'] = "Fill 'Password Again' field";
}

if(isset($_POST["password1"]) && isset($_POST["password2"]) && $_POST["password1"] != $_POST["password2"]){
	$response['fieldErrors']['password1'] = "Passwords do not match";
	$response['fieldErrors']['password2'] = "Passwords do not match";
}

if(sizeof($response['fieldErrors']) == 0){
	$response['success'] = true;
}

$filesNum = 0;
$filesSize = 0;

foreach($_FILES as $file){
	if($file && $file['name']){
		$filesNum++;
		$filesSize += $file['size'];
	}
}

?><html><body><script type='text/javascript'>
<?= $_POST["callback"] ?>(<?= $json_converter->encode($response)?>);
<?if($filesNum > 0){?>
	alert('<?= $filesNum ?> file<?= ($filesNum == 1 ? "" : "s")?> (total size <?= $filesSize ?>b) was uploaded successful');
<?}?>
</script></body></html><?
?>
