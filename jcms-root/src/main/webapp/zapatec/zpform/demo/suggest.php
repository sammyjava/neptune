<?php /* $Id: suggest.php 4433 2006-09-14 07:53:49Z shacka $ */ ?>
{
    "success": true,
	"header": [
		{
			"name": "State name",
			"style": "background-color: #6699CC; color: #FFFFFF"
		}
	],
	"body": [
<?
    $states = array(
		"Alabama",
		"Alaska",
		"Arizona",
		"Arkansas",
		"California",
		"Colorado",
		"Connecticut",
		"Delaware",
		"Florida",
		"Georgia",
		"Hawaii",
		"Idaho",
		"Illinois",
		"Indiana",
		"Iowa",
		"Kansas",
		"Kentucky",
		"Louisiana",
		"Maine",
		"Maryland",
		"Massachusetts",
		"Michigan",
		"Minnesota",
		"Mississippi",
		"Missouri",
		"Montana",
		"Nebraska",
		"Nevada",
		"New Hampshire",
		"New Mexico",
		"New York",
		"North Carolina",
		"North Dakota",
		"Ohio",
		"Oklahoma",
		"Oregon",
		"Pennsylvania",
		"Rhode Island",
		"South Carolina",
		"South Dakota",
		"Tennessee",
		"Texas",
		"Utah",
		"Vermont",
		"Virginia",
		"Washington",
		"West Virginia",
		"Wisconsin",
		"Wyoming"
    );
    
    $suggest = "";

	if(isset($_GET['suggest_state'])){
		$suggest = $_GET['suggest_state'];
	}

	$suggested = array();

	foreach($states as $state){
		if(strtolower(substr($state, 0, strlen($suggest))) == strtolower($suggest)){
			array_push($suggested, "[\"$state\"]");
		}
	}

	sort($suggested);
?>
		<?= implode(",\n\t\t", $suggested) ?>

	]
}
