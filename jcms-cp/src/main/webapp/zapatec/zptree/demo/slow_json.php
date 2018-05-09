<? sleep(5) ?>
<? header("Cache-Control: no-cache")?>
{
	"children": [
		{"label": "dynamically retrieved subchild1"},
		{"label": "dynamically retrieved subchild2"},
		{
			"label": "dynamically retrieved subchild3 with subtree",
			"children": [
				{"label" : "subsubchild1"},
				{"label" : "subsubchild2"},
				{"label" : "subsubchild3"},
				{"label" : "subsubchild4"}
			]
		},
		{
			"label": "recursive branch",
			"sourceType": "json/url",
			"source": "slow_json.php"
		}
	]
}