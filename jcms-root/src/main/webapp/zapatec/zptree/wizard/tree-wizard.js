// $Id: tree-wizard.js 15736 2009-02-06 15:29:25Z nikolai $
/**
 * The Zapatec DHTML Calendar
 *
 * Copyright (c) 2004-2009 by Zapatec, Inc.
 * http://www.zapatec.com
 * 1700 MLK Way, Berkeley, California,
 * 94709, U.S.A.
 * All rights reserved.
 *
 *
 * Tree Wizard
 */


var wizard = null;
var Utils = Zapatec.Utils;
var zpTree = null;

function initWizard() {
	wizard = new Zapatec.Wizard({
		tabsID: 'tabs',
		tabBarID: 'tab-bar'
	});

	wizard.onInit = initPage;
	
	wizard.addCustomValidator("initLevel", function(value) {
		// allow the empty string or a pozitive integer
		if (/^\+?[0-9]*$/.test(value)){
			return true;
		}

		return "You can write a positive integer or leave this field blank.";
	});
	
	wizard.onBeforeTabChange = function(currentTab, newTab) {
		if (newTab == "pane-contents"){
			clearIcons();
		}

		// allow tab to change
		return true;
	};

	wizard.setupNav();
	wizard.init();
};

function initPage() {
	Zapatec.Tooltip.setupFromDFN();

	var dul = document.getElementById("designtree");
	
	var lis = dul.getElementsByTagName("li");
	
	for (var i = lis.length; --i >= 0;) {
		var li = lis[i];
		_designInitLI(li);
	}
	
	var designlabel = document.getElementById("f_design_label");

	designlabel.onkeyup = function() {
		var self = this;

		setTimeout(function() {
			var li = _g_design_currentLI;

			if (li) {
				while (li.firstChild && !/^[uo]l$/i.test(li.firstChild.tagName)){
					li.removeChild(li.firstChild);
				}

				var div = document.createElement("div");
				div.innerHTML = self.value;
				
				var p = li.firstChild;
				
				while (div.firstChild){
					li.insertBefore(div.firstChild, p);
				}
			}
		}, 25);
	};

	designlabel.onkeypress = function(ev) {
		ev || (ev = window.event);
		
		if (ev.keyCode == 13){
			designInsert(true);
		}
	};
};

var _g_design_currentLI = null;

function _designInitLI(li) {
	if (!Zapatec.is_ie5){
		li.style.cursor = "pointer";
	}

	li.onclick = function(ev) {
		ev || (ev = window.event);

		if (_g_design_currentLI){
			Utils.removeClass(_g_design_currentLI, "active");
		}
		
		// var li = ev ? (ev.currentTarget || ev.srcElement) : this;
		
		var li = this;
		
		if (li) {
			Utils.addClass(li, "active");
		
			if (ev){
				Utils.stopEvent(ev);
			}

			_g_design_currentLI = li;
			
			var input = document.getElementById("f_design_label");
			input.disabled = false;
			
			var txt = "", tmp = li.firstChild;
			
			while (tmp && tmp.nodeType == 3) {
				txt += tmp.data;
				tmp = tmp.nextSibling;
			}
			
			txt = txt.replace(/^\s+/, '').replace(/\s+$/, '');
			
			input.value = txt;
			input.select();
			input.focus();
		}

		return false;
	};
};

function alertDesignNoSelectedNode() {
	alert("You need to click a node in the tree first");
};

function designInsert(after) {
	var li = _g_design_currentLI;

	if (!li) {
		alertDesignNoSelectedNode();
		return;
	}
	
	var newli = document.createElement("li");
	
	newli.innerHTML = "New Item";
	li.parentNode.insertBefore(newli, after ? li.nextSibling : li);
	_designInitLI(newli);
	
	newli.onclick();
	
	return false;
};

function designAddSubtree() {
	var li = _g_design_currentLI;
	
	if (!li) {
		alertDesignNoSelectedNode();
		return;
	}
	
	// assume the subtree already exists (it can happen)
	var newul = li.getElementsByTagName("ul")[0];
	
	if (!newul) {
		// only if not existent, create one
		newul = document.createElement("ul");
		li.appendChild(newul);
	}
	
	var newli = document.createElement("li");
	newul.appendChild(newli);
	newli.innerHTML = "New Item";
	_designInitLI(newli);
	newli.onclick();
	
	return false;
};

function designRemove() {
	var li = _g_design_currentLI;
	
	if (!li) {
		alertDesignNoSelectedNode();
		return;
	}
	
	if (confirm("Remove selected node and any subtrees it might have?")) {
		var p = li.parentNode, p2 = p;
	
		li.parentNode.removeChild(li);
		
		if (!/\S/.test(p.innerHTML)) {
			p2 = p.parentNode;
			p2.removeChild(p);
			p = p2;
		}
		
		_g_design_currentLI = null;
		document.getElementById("f_design_label").disabled = true;
	}

	return false;
};

function doPreview() {
	var config = getConfig();
	var div = document.getElementById("designpreview");
	
	if(zpTree){
		zpTree.destroy();
	}

	config.source = "designtree";
	config.parent = "designpreview";
	
	zpTree = new Zapatec.Tree("tree-preview", config);
};

function generateCode() {
	var html = getHeaders();
	html += makeIndent(1) + "<body>\n";
	html += makeIndent(2) + ('<!-- The HTML for the tree-->\n');
	html += getHTML(2, document.getElementById("designtree"));
	html += makeIndent(2) + ('<!-- The Javascript code to initiate the tree-->\n');
	html += makeIndent(2) + '<script type="text/javascript">\n';
	html += makeIndent(3) + 'new Zapatec.Tree({\n';
	html += makeIndent(4) + 'tree: "designtree"';
	
	var config = getConfig();
	
	for (var prop in config) {
		html += ",";

		var val = config[prop];
		
		if (typeof val == "string"){
			val = '"' + val + '"';
		}

		html += "\n" + makeIndent(4) + prop + ' : ' + val;
	}

	html += "\n" + makeIndent(3) + '});\n';
	html += makeIndent(2) + "</script>\n";
	html += makeIndent(2) + "<noscript>\n <br/>\n";
	html += makeIndent(2) + 'This page uses a <a href="http://www.zapatec.com/website/main/products/prod3/"> Javascript Tree </a>,';
	html += makeIndent(2) + 'but your browser does not support Javascript.\n';
	html += makeIndent(2) + '<br/>\n Either enable Javascript in your Browser or upgrade to a newer version.\n </noscript>\n';
	html += makeIndent(2) + '<a href="http://www.zapatec.com/website/main/products/prod3/">Zapatec Javascript Tree</a>\n';
	html += makeIndent(1) + "</body>\n</html>";
	
	return html;
};


function clearIcons() {
	var ul = document.getElementById("designtree");
	var img;
	
	while (img = ul.getElementsByTagName("img")[0]){
		img.parentNode.removeChild(img);
	}
};

function makeCode() {
	var ta = document.getElementById("f_code");
	ta.value = generateCode();
};

function propChange(field, value) {
	switch (field.id) {
	    case "f_theme":
	        if(
	        	value == "lightgreen" ||
				value == "purple" ||
				value == "wood" ||
				value == "zapatec"
			){
				document.getElementById("display-icons_css").style.visibility = "hidden";
			} else {
				document.getElementById("display-icons_css").style.visibility = "visible";
			}
			break;
	    case "f_collapsed":
	    	if(document.getElementById("f_compact").checked){
	    		field.checked = true;
	    		value = true;
	    	}

			document.getElementById("display-initLevel").style.visibility = value ? "hidden" : "visible";
	
			if (!value) {
				document.getElementById("f_initLevel").select();
				document.getElementById("f_initLevel").focus();
			}
			break;
	    case "f_compact":
			var cc = document.getElementById("f_collapsed");
			document.getElementById("display-collapsed").style.visibility = value ? "hidden" : "visible";
	
			if (value) {
				cc.checked = true;
				cc.onclick();
			}
			break;
	    case "f_saveState":
			document.getElementById("display-saveId").style.visibility = value ? "visible" : "hidden";
	
			if (value) {
				document.getElementById("f_saveId").select();
				document.getElementById("f_saveId").focus();
			} else {
				document.getElementById("f_saveId").blur();
			}
			break;
	    case "f_expandOnSignClick":
			document.getElementById("display-expandOnSignDblclick").style.visibility = value ? "hidden" : "visible";
	
			if (value) {
				document.getElementById("display-expandOnSignDblclick").checked = false;
			}
			break;
	    case "f_expandOnSignDblclick":
			document.getElementById("display-expandOnSignClick").style.visibility = value ? "hidden" : "visible";
	
			if (value) {
				document.getElementById("display-expandOnSignClick").checked = false;
			}
			break;
	    case "f_expandOnIconClick":
			document.getElementById("display-expandOnIconDblclick").style.visibility = value ? "hidden" : "visible";
	
			if (value) {
				document.getElementById("display-expandOnIconDblclick").checked = false;
			}
			break;
	    case "f_expandOnIconDblclick":
			document.getElementById("display-expandOnIconClick").style.visibility = value ? "hidden" : "visible";
	
			if (value) {
				document.getElementById("display-expandOnIconClick").checked = false;
			}
			break;
	    case "f_expandOnLabelClick":
			document.getElementById("display-expandOnLabelDblclick").style.visibility = value ? "hidden" : "visible";
	
			if (value) {
				document.getElementById("display-expandOnLabelDblclick").checked = false;
			}
			break;
	    case "f_expandOnLabelDblclick":
			document.getElementById("display-expandOnLabelClick").style.visibility = value ? "hidden" : "visible";
	
			if (value) {
				document.getElementById("display-expandOnLabelClick").checked = false;
			}
			break;
	    case "f_icons_css":
			break;
	}
};

function getConfig() {
	var config = {};
	
	function setConfigParam(param, id, elDefault) { 
		var element =  document.getElementById(id);
	
		if (element && element.checked != elDefault){
			//this works as long as params are boolean checkboxes
			config[param] = element.checked;
		}
	};

	setConfigParam("compact", "f_compact", false);
	setConfigParam("quick", "f_quick", false);
	setConfigParam("highlightSelectedNode", "f_highlightSelectedNode", true);
	setConfigParam("expandOnSignClick", "f_expandOnSignClick", true);
	setConfigParam("expandOnSignDblclick", "f_expandOnSignDblclick", false);
	setConfigParam("expandOnIconClick", "f_expandOnIconClick", true);
	setConfigParam("expandOnIconDblclick", "f_expandOnIconDblclick", false);
	setConfigParam("expandOnLabelClick", "f_expandOnLabelClick", false);
	setConfigParam("expandOnLabelDblclick", "f_expandOnLabelDblclick", false);

	var level = document.getElementById("f_initLevel").value;

	if (document.getElementById("f_collapsed").checked){
		config.initLevel = 0;
	} else if (level != "") {
		level = parseInt(level);
	
		if (!isNaN(level)){
			config.initLevel = level;
		}
	}

	var saveId = document.getElementById("f_saveId").value;

	if (document.getElementById("f_saveState").checked && saveId != ""){
		config.saveState = true;
		config.saveId = saveId;
	}

	var themeSel = document.getElementById("f_theme");
	config.theme = themeSel.options[themeSel.selectedIndex].value;

	if(
		document.getElementById("f_icons_css").value != 'none' ||
		config.theme == "lightgreen" ||
		config.theme == "purple" ||
		config.theme == "wood" ||
		config.theme == "zapatec"
	){
		config.defaultIcons = "customIcon";
	}
	
	return config;
};

/* functions that return the HTML code */

function makeIndent(indent) {
	var str = "";
	while (indent-- > 0)
		str += "    ";
	return str;
};

function htmlEncode(str) {
	str = str.replace(/&/ig, "&amp;");
	str = str.replace(/</ig, "&lt;");
	str = str.replace(/\>/ig, "&gt;");
	str = str.replace(/\x22/ig, "&quot;");
	
	return str;
};

function checkOutputNode(node) {
	if (!node.tagName || node.tagName == '!' /* IE anomaly */){
		throw "Node has no tag";
	}
	
	if (node.className) {
		if (/(^|\s)not-in-output(\s|$)/i.test(node.className)){
			throw "class: not-in-output";
		}
	}
};

function getHTML(indent, node, compact, noRoot) {
	var html = "";
	
	if (node.nodeType == 3) {
		var str = node.data;
		str = str.replace(/(^\s+|\s+$)/g, "");
	
		if (str) {
			if (!compact){
				html += makeIndent(indent);
			}
			
			html += htmlEncode(str);
			
			if (!compact){
				html += "\n";
			}
		}

		return html;
	} else try {
		checkOutputNode(node); // throws an exception if node shouldn't be displayed
		var tag = node.tagName.toLowerCase();
		
		if (!noRoot) {
			html += makeIndent(indent) + "<" + tag;
			var a = ["href", "src", "rel", "type", "http-equiv", "content", "alt"];
		
			for (var i = 0; i < a.length; ++i) {
				var val = node.getAttribute(a[i]);
				
				if (val){
					html += ' ' + a[i] + '="' + val + '"';
				}
			}
			
			if (node.id == "designtree"){
				html += ' id="' + node.id + '"';
			}
			
			var enter = true;
			
			if (!node.firstChild && /^(link|meta|img|br|hr)$/i.test(tag)) {
				html += " />\n";
				noRoot = true;
				enter = false;
			} else {
				html += ">";
			}
			
			if (enter && !compact){
				html += "\n";
			}
		}

		for (var i = node.firstChild; i; i = i.nextSibling){
			html += getHTML(indent + 1, i, compact);
		}

		if (!noRoot) {
			if (!compact){
				html += makeIndent(indent);
			}
		
			html += "</" + tag + ">";
			html += "\n";
		}

		return html;
	} catch(e) {
		return "";
	}
};

function getHeaders() {
	var headers = '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/1999/REC-html401-19991224/loose.dtd">\n';
	headers += "<html>\n";
	headers += makeIndent(1) + "<head>\n";
	headers += makeIndent(2) + '<title>Javascript Tree Wizard By Zapatec</title>\n';
	headers += makeIndent(2) + ('<!-- Adjust the paths to the tree location on your server if necessary-->\n\n');

	headers += makeIndent(2) + ('<!-- Javascript utilities file for the tree-->\n');
	headers += makeIndent(2) + '<script src="utils/zapatec.js" type="text/javascript"></script>\n';

	headers += makeIndent(2) + ('<!-- basic Javascript file for the tree-->\n');
	headers += makeIndent(2) + '<script src="zptree/src/tree.js" type="text/javascript"></script>\n';

	var iconsStyle = document.getElementById("f_icons_css").value;

	if (iconsStyle != 'none') {
		headers += makeIndent(2) + ('<!-- CSS file for icons for folders and files ' + iconsStyle + ' style in the tree-->\n');
		headers += makeIndent(2) + '<link href="zptree/themes/' + iconsStyle + '.css" rel="stylesheet" />\n';
	}

	headers += makeIndent(1) + "</head>\n";
	return(headers);
}

/*
 * Set the active theme for the 
 */

function setActiveIcons(sel) {
	var i = 0, o, a = sel.options, theme;
	
	// First disable all the themes
	while (o = a[i++]) {
		theme = document.getElementById("theme-" + o.value);
		
		if (theme){
			theme.disabled = true;
		}
	}

	//and now enable the selected one
	theme = document.getElementById("theme-" + sel.value);
	
	if (theme){
		theme.disabled = false;
	}
};

