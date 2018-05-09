/**
 * @fileoverview 
 *
 * <pre>
 * Copyright (c) 2004-2009 by Zapatec, Inc.
 * http://www.zapatec.com
 * 1700 MLK Way, Berkeley, California,
 * 94709, U.S.A.
 * All rights reserved.
 * </pre>
 */

/* $Id: demo.js 15736 2009-02-06 15:29:25Z nikolai $ */

/**
 * Demo explorer widget class.
 *
 * @constructor
 * @extends Zapatec.Widget
 * @param {object} oArg User configuration
 */
Zapatec.DemoExplorer = function(oArg) {
	// Call constructor of superclass
	Zapatec.DemoExplorer.SUPERconstructor.call(this, oArg);
};

/**
 * Unique static id of the widget class. Gives ability for
 * {@link Zapatec#inherit} to determine and store path to this file correctly
 * when it is included using {@link Zapatec#include}. When this file is included
 * using {@link Zapatec#include} or path to this file is obtained using
 * {@link Zapatec#getPath}, this value must be specified as script id.
 * @private
 */
Zapatec.DemoExplorer.id = 'Zapatec.DemoExplorer';
Zapatec.DemoExplorer.demoData = {};

// Inherit Widget
Zapatec.inherit(Zapatec.DemoExplorer, Zapatec.Widget);

/**
 * Configures the widget. Gets called from init and reconfigure methods of
 * superclass.
 *
 * @private
 * @param {object} oArg User configuration
 */
Zapatec.DemoExplorer.prototype.configure = function(oArg) {
    this.defineConfigOption("currentWidget");
    this.defineConfigOption("showFirstDemo", false);
	// Call parent method
	Zapatec.DemoExplorer.SUPERclass.configure.call(this, oArg);
};

/**
 * Initializes object.
 *
 * @param {object} oArg User configuration
 */
Zapatec.DemoExplorer.prototype.init = function(oArg) {
	this.currentDemo = {};
	this.tabsObj = null;
	this.treeObj = null;
    this.htmlTab = null;
    this.cssTab = null;

	// Call init method of superclass
	Zapatec.DemoExplorer.SUPERclass.init.call(this, oArg);

	var self = this;

	// HTML elements for displaying CSS and HTML sources
    this.htmlTab = document.getElementById("html_source");
    this.cssTab = document.getElementById("css_source");

    // Create a new demo|css|html tabs widget instance
    this.objTabs = new Zapatec.Tabs({
        tabBar : "tabBar",
        tabs : "tabs",
        source: {
			tabs : [
				{
					id : "demo",
					linkInnerHTML : "Demo",
					title : "demo",
					tabType : "iframe"
				},
				{
					id : "html",
					linkInnerHTML : "HTML",
					title : "HTML part of the demo.",
					content : document.getElementById("html_source"),
					tabType : "div"
				},
				{
					id : "css",
					linkInnerHTML : "CSS",
					title : "CSS part of the demo.",
					content : document.getElementById("css_source"),
					tabType : "div"
				}
			]
		},
        sourceType : "json",
        themePath : Zapatec.zapatecPath + '/dhelp/themes/',
        changeUrl : false,
        theme: 'default',
        ignoreUrl: true,
        onTabChange: function(oCfg){
        	if(oCfg.newTabId == 'demo'){
        		self.setDemoPaneHeight();
        	}
        }
    });
    
    // get information about demo from URL
	var tmp = Zapatec.DemoExplorer.extractDataFromURL();

	if(tmp){
	    // backward compatibility - if no data about widget in URL - use this.config.currentWidget
		if(!tmp.widget){
			tmp.widget = this.config.currentWidget;
		}

		this.changeDemo(tmp.demo, tmp.widget);
	}

	// create navigation tree
	this.navTree = new Zapatec.Tree({
        'tree': "tree",
        'expandOnLabelClick': true,
        'expandOnLabel': true,
        'theme': 'demos',
        'highlightSelectedNode': true,
        'eventListeners': {
            'select': function() {
                if (
                	this.data && 
                	this.data.attributes && 
                	this.data.attributes.demo && 
                	(
						this.data.attributes.demo != self.currentDemo.demo ||
						this.data.attributes.demo == self.currentDemo.demo &&
	    	            this.data.attributes.widget != self.currentDemo.widget
                	)
                ){
                	// show corresponding demo on screen when clicking on tree nodes
                    self.changeDemo(this.data.attributes.demo, this.data.attributes.widget);
                }
            },
            "loadDataEnd": function(){
           		if(
           		    // if we need to show some demo on start and current node is demo node - show this demo.
           		    self.config.showFirstDemo &&
           			!self.currentDemo.demo &&
           			!self.currentDemo.widget &&
           			this.data && 
           			this.data.attributes && 
           			this.data.attributes.demo ||
           			// or if this node is node that is shown - show it.
           			this.data && 
           			this.data.attributes && 
           			this.data.attributes.demo &&
           			self.currentDemo.widget &&
           			self.currentDemo.demo &&
           			this.data.attributes.widget == self.currentDemo.widget &&
           			this.data.attributes.demo == self.currentDemo.demo &&
           			!(
           				this.config.tree.prevSelected &&
           				this.config.tree.prevSelected.data &&
           				this.config.tree.prevSelected.data.attributes &&
           				this.config.tree.prevSelected.data.attributes.widget == self.currentDemo.widget &&
           				this.config.tree.prevSelected.data.attributes.demo == self.currentDemo.demo
           			)
           		){
           			// select current node if it is shown on screen
           			this.sync();
				}
            }
        }
	});

	// for each entry in demoData array display data in navigation tree
	for(var widgetName in Zapatec.DemoExplorer.demoData){
		var demoBranch = this.navTree.getNode(widgetName);

		if(!demoBranch){
			continue;
		}

		Zapatec.DemoExplorer.assignWidget(Zapatec.DemoExplorer.demoData[widgetName].data, widgetName);

		for(var ii = 0; ii < Zapatec.DemoExplorer.demoData[widgetName].data.children.length; ii++){
			demoBranch.appendChild(Zapatec.DemoExplorer.demoData[widgetName].data.children[ii]);
		}
	}
};

/**
 * @private
 * Set correct height for content pane
 */
Zapatec.DemoExplorer.prototype.setDemoPaneHeight = function(){
	if(!this.objTabs){
		return;
	}

	var demoTab = this.objTabs.tabs["demo"];

	demoTab.container.fireWhenReady(function(pane) {
		var height = 0;
		
		var doc = this.iframeDocument;
		
		if (!doc) {
			return null;
		}
		try{
			if (doc.compatMode && doc.compatMode == 'CSS1Compat') {
				height = doc.documentElement.scrollHeight || doc.documentElement.offsetHeight;
			} else {
				height = doc.body.scrollHeight || doc.documentElement.scrollHeight;
			}
    	} catch(e){}

		if(height < 700){
			height = 700;
		}

		this.getContainer().style.height = (height + 30) + "px";
	});

	demoTab.container.getContainer().style.overflow = 'auto';
}

/**
 * @private
 * Get demo details. Return object of following structure:
 *	widgetLiteralName - widget name
 *	title - demo title
 *	baseUrl - link to widget directory
 *	demoUrl - link to demo file
 *	themes - array of theme
 *		url - theme url
 *		theme - theme name
 */
Zapatec.DemoExplorer.prototype.getDemoData = function(demo, widget){
	var allDemos = Zapatec.DemoExplorer.demoData[widget];
	if(!allDemos){
		return null;
	}
				
	var demoData = Zapatec.DemoExplorer.findDemo(demo, allDemos.data.children);

	if(!demoData){
		return null;
	}

	var res = {
		widgetLiteralName: Zapatec.DemoExplorer.demoData[widget].name,
		title: demoData.label,
		baseUrl: Zapatec.zapatecPath + "../" + widget + "/",
		demoUrl: Zapatec.zapatecPath + "../" + widget + "/demo/" + demo,
		themes: []
	};

	if(demoData.attributes.themes){
		for(var ii = 0; ii < demoData.attributes.themes.length; ii++){
			res.themes.push({
				url: Zapatec.zapatecPath + "../" + widget + "/themes/" + demoData.attributes.themes[ii] + ".css",
				theme: demoData.attributes.themes[ii]
			});
		}
	}
	return res;
}

/**
 * Show demo for given widget and demo name.
 */
Zapatec.DemoExplorer.prototype.changeDemo = function(demo, widget){
    if(!widget){
    	widget = this.config.currentWidget;
    }

	if(!widget || !demo){
		alert("No widget!");
	}

	var demoData = this.getDemoData(demo, widget);

	if(!demoData){
		return null;
	}

	this.currentDemo = {
		demo: demo,
		widget: widget
	};

	var rightSide = document.getElementById("rightSide");
	
	if(rightSide){
		rightSide.style.display = "none";
	}

	document.getElementById("tabs_content").style.display = "block";
	
	// put reference to demo into URL
	Zapatec.DemoExplorer.writeDataIntoURL(demo, widget);

	if(this.navTree){
		var treeNode = this.navTree.find(function(node){return node.data && node.data.attributes && node.data.attributes.demo == demo;});

		if(treeNode){
			treeNode.sync();
		}
	}

	// fix pane height
	this.setDemoPaneHeight();

	// set document title
	document.title = "AJAX " + demoData.widgetLiteralName + " - " + demoData.title;

	var res = [];

	var self = this;
	this.cssTab.value = "";
	this.htmlTab.value = "";
	
	// load themes
	for(var ii = 0; ii < demoData.themes.length; ii++){
		if (demoData.themes[ii].theme == 'none') {
			this.cssTab.value = "There is no theme for this demo";
			break;
		}

		Zapatec.DemoExplorer.loadTheme(this.cssTab, demoData.themes[ii].theme, demoData.themes[ii].url);
	}

	// load HTML source
	Zapatec.Transport.fetch({
		url : demoData.demoUrl + (Zapatec.is_opera ? "?" : ""),
		onLoad : function(response) {
			self.htmlTab.value = response.responseText;
		},
		onError : function(error) {
			alert(error.errorDescription);
		}
	});

	// show demo inside content pane
	this.objTabs.tabs["demo"].container.setPaneContent(demoData.demoUrl, "html/url");
}

/**
 * Extract demo details from URL.
 * url must be following: demo.jsp#widget/demo.html or just demo.jsp#demo.html - in this case this.config.currentWidget will be used.
 */
Zapatec.DemoExplorer.extractDataFromURL = function(){
    var hash = document.location.hash.slice(1);

    if(!hash || hash.length == 0){
    	return null;
    }

    var tmp = hash.split("/", 2);

	if(tmp.length == 2){
		return {
			widget: tmp[0],
			demo: tmp[1]
		}
	} else {
		return {
			widget: null,
			demo: hash
		}
	}
}

/**
 * Save information about widget and demo into URL.
 */
Zapatec.DemoExplorer.writeDataIntoURL = function(demo, widget){
    var hash;
    
	if (widget) {
		hash = widget + "/";
	} 
	
	hash += demo;
		
	document.location.href = document.location.href.substring(0, document.location.href.length - document.location.hash.length) + '#' + hash;
}

/**
 * @private
 * find demo with given name in given array
 */
Zapatec.DemoExplorer.findDemo = function(demo, children){
	if(!demo || !children){
		return null;
	}

	for(var ii = 0; ii < children.length; ii++){
		var currDemo = children[ii];

		if(currDemo.attributes && currDemo.attributes.demo && currDemo.attributes.demo == demo){
			return currDemo;
		}

		if(currDemo.children){
			var newDemo = Zapatec.DemoExplorer.findDemo(demo, currDemo.children);

			if(newDemo){
				return newDemo;
			}
		}
	}

	return null;
}

/**
 * @private
 * Fetch given theme and put its content to textarea
 */
Zapatec.DemoExplorer.loadTheme = function(textarea, theme, url){
	Zapatec.Transport.fetch({
		url : url,
		onLoad : function(response) {
			textarea.value += "/* " + theme + " */\n" + response.responseText + "\n";
		},
		onError : function(error) {
			alert(error.errorDescription);
		}
	});
}

/**
 * @private
 * add "widget" property to every demo
 */
Zapatec.DemoExplorer.assignWidget = function(node, widget){
	if(node){
		if(!node.attributes){
			node.attributes = {};
		}
		
		node.attributes.widget = widget;
	}

	if(node.children){
		for(var ii = 0; ii < node.children.length; ii++){
		 	Zapatec.DemoExplorer.assignWidget(node.children[ii], widget);
		}
	}
}
