/*
 *
 * Copyright (c) 2004-2009 by Zapatec, Inc.
 * http://www.zapatec.com
 * 1700 MLK Way, Berkeley, California,
 * 94709, U.S.A.
 * All rights reserved.
 *
 *
 */
Zapatec.editorPath = Zapatec.getPath("Zapatec.EditorWidget");

Zapatec.Utils.createNestedHash(Zapatec,["Langs","Zapatec.MinimalEditor","eng"],{'maximizeTooltip':'Maximize/Minimize Editor','insertLinkTooltip':'Insert Web Link','insertLinkTextLabel':'Text to display: ','insertLinkAddressLabel':'Address: ','insertLinkTitle':'Insert Link','insertImageTooltip':'Insert Image','insertImagePrompt':'Enter a URL:','insertTableTooltip':'Insert Table','insertTableRowsPrompt':'Enter number of rows','insertTableColsPrompt':'Enter number of cols','insertTableBorderWidthPrompt':'Enter border width','insertHorizontalRule':'Horizontal Rule','insertSpecialCharacter':'Insert special character','selectAllTooltip':'Select All','underlineTooltip':'Underline','justifyLeftTooltip':'Justify Left','justifyCenterTooltip':'Justify Center','justifyRightTooltip':'Justify Right','justifyFullTooltip':'Justify Full','orderedListTooltip':'Ordered List','unorderedListTooltip':'Bulleted List','copyTooltip':'Copy','cutTooltip':'Cut','pasteTooltip':'Paste','outdentTooltip':'Decrease Indent','indentTooltip':'Increase Indent','undoTooltip':'Undo','redoTooltip':'Redo','aboutTooltip':'About Zapatec Editor','aboutText':'DHTML Minimal Editor \n(c) zapatec.com 2002-2008\n\
   For latest version visit: http://www.zapatec.com/','fetchTooltip':'Load from server','saveTooltip':'Save to server','browserTooltip':'View in external browser window','htmlTooltip':'Switch to HTML','wysiwygTooltip':'Switch to WYSIWYG','bgColorTooltip':'Background Color','fontColorTooltip':'Font Color','characterMapTitle':'Character Map','noTextareaError':'No reference to field textarea!','fieldIsNotTextareaError':'Field is not a textarea!','unknownToolbarElementError':'Unknown toolbar element name: %1. Ignored','optionsNotEqualValuesError':'Sizes of options and values differs!','noSuchFileError':'No such file','readAccessForbiddenError':'Read access forbidden for this file','writeAccessForbiddenError':'Write access forbidden for this file','fetchError':'Error fetching file: %1 %2','saveError':'Error saving file: %1 %2'});Zapatec.Button=function(objArgs){if(arguments.length==0){objArgs={};}
Zapatec.Button.SUPERconstructor.call(this,objArgs);};Zapatec.Button.id="Zapatec.Button";Zapatec.inherit(Zapatec.Button,Zapatec.Widget);Zapatec.Button.prototype.init=function(objArgs){this.config.image=null;this.config.width=null;this.config.height=null;this.config.className=null;this.config.style=null;this.config.text="";this.config.preloadImages=true;this.config.overStyle=null;this.config.overClass=null;this.config.overImage=null;this.config.overAction=null;this.config.outAction=null;this.config.downStyle=null;this.config.downClass=null;this.config.downImage=null;this.config.downAction=null;this.config.downActionDelay=500;this.config.repeatEnabled=true;this.config.repeatAcceleration=0.8;this.config.repeatStartSpeed=55;this.config.repeatMaxSpeed=5;this.config.clickAction=null;this.config.idPrefix=null;this.config.themePath=Zapatec.zapatecPath+"../zpextra/themes/button/";Zapatec.Button.SUPERclass.init.call(this,objArgs);if(!this.config.idPrefix){this.config.idPrefix="zpButton"+this.id;}
this.container=null;this.statusContainer=null;this.internalContainer=null;this.img=null;this.enabled=true;this.isPressed=false;this.createButton();};Zapatec.Button.prototype.createButton=function(){this.container=Zapatec.Utils.createElement("span");this.addCircularRef(this,'container');this.container.id=this.config.idPrefix+"Container";this.statusContainer=Zapatec.Utils.createElement("span");this.addCircularRef(this,'statusContainer');this.statusContainer.className="mouseOut";this.statusContainer.id=this.config.idPrefix+"Status";this.container.appendChild(this.statusContainer);this.internalContainer=Zapatec.Utils.createElement("span");this.addCircularRef(this,'container');this.internalContainer.className="internalContainer";this.internalContainer.id=this.config.idPrefix+"Internal";this.statusContainer.appendChild(this.internalContainer);Zapatec.Utils.addClass(this.container,this.getClassName({prefix:"zpButton"+(this.config.image!=null?"Image":""),suffix:"Container"}));if(this.config.width!=null){this.internalContainer.style.width=this.config.width+"px";}
if(this.config.height!=null){this.internalContainer.style.width=this.config.height+"px";}
if(this.config.className!=null){Zapatec.Utils.addClass(this.internalContainer,this.config.className);}
if(this.config.style!=null){this.applyStyle(this.config.style);}
var self=this;this.container.onmouseover=function(ev){return self.onmouseover(ev,false);};this.addCircularRef(this.container,'onmouseover');this.container.onmouseout=function(ev){return self.onmouseout(ev);};this.addCircularRef(this.container,'onmouseout');this.container.onmousedown=function(ev){return self.onmousedown(ev);};this.addCircularRef(this.container,'onmousedown');this.container.onmouseup=function(ev){return self.onmouseover(ev,true);};this.addCircularRef(this.container,'onmouseup');this.setEventHandlers();var func=function(ev){self._mousedown=false;};Zapatec.Utils.addEvent(document,'mouseup',func,null,false);this.eventHandlers.documentMouseup={element:document,event:"mouseup",handler:func};this.container.onclick=function(ev){return self.onclick(ev);};this.addCircularRef(this.container,'onclick');if(this.config.image!=null){this.img=document.createElement("img");this.addCircularRef(this,'img');this.img.src=this.config.image;this.img.alt=this.config.text;this.img.title=this.config.text;this.internalContainer.appendChild(this.img);}else{this.internalContainer.innerHTML=this.config.text;this.internalContainer.style.whiteSpace="nowrap";}
if(this.config.preloadImages==true){this.preloadImages();}};Zapatec.Button.prototype.onmouseover=function(ev,mouseup){if(!this.isEnabled()){return false;}
if(typeof(ev)=='undefined'){ev=window.event;}
if(mouseup){this._mousedown=false;}
this.toggleClass("mouseOver");if(this.config.image!=null&&this.config.overImage!=null){this.img.src=this.config.overImage;}
if(this.config.overClass!=null){Zapatec.Utils.addClass(this.internalContainer,this.config.overClass);}
if(this.config.overStyle!=null){this.applyStyle(this.config.overStyle);}
if(this._timeoutId){clearTimeout(this._timeoutId);}
if(this._mousedown&&this.config.repeatEnabled){this._repeatDownAction();}
if(this.config.overAction!=null){return this.config.overAction(ev,this);}
return true;};Zapatec.Button.prototype.onmouseout=function(ev){if(!this.isEnabled()){return false;}
if(typeof(ev)=='undefined'){ev=window.event;}
if(!this.isPressed){this.toggleClass("mouseOut");if(this.config.image!=null){this.img.src=this.config.image;}
if(this.config.outClass!=null){Zapatec.Utils.addClass(this.internalContainer,this.config.outClass);}}
else{this.toggleClass("mouseDown");if(this.config.image!=null&&this.config.downImage!=null){this.img.src=this.config.downImage;}
if(this.config.downClass!=null){Zapatec.Utils.addClass(this.internalContainer,this.config.downClass);}}
if(this.config.style!=null){this.applyStyle(this.config.style);}
if(this._mousedown){this._pauseRepeat();}
if(this.config.outAction!=null){return this.config.outAction(ev,this);}
return true;};Zapatec.Button.prototype.onmousedown=function(ev){if(!this.isEnabled()){return false;}
var self=this;if(typeof(ev)=='undefined'){ev=window.event;}
this._mousedown=true;this.toggleClass("mouseDown");if(this.config.image!=null&&this.config.downImage!=null){this.img.src=this.config.downImage;}
if(this.config.downClass!=null){Zapatec.Utils.addClass(this.internalContainer,this.config.downClass);}
if(this.config.downStyle!=null){this.applyStyle(this.config.downStyle);}
if(this.config.downAction!=null){this._timeoutId=setTimeout(function(){self._repeatSpeed=self.config.repeatStartSpeed;self._repeatDownAction(ev);},this.config.downActionDelay);return this.config.downAction(ev,this);}
return true;};Zapatec.Button.prototype.onclick=function(ev){if(!this.isEnabled()){return false;}
if(typeof(ev)=='undefined'){ev=window.event;}
if(this._timeoutId){clearTimeout(this._timeoutId);}
this._timeoutId=null;this._mousedown=false;if(this.config.clickAction!=null){return this.config.clickAction(ev,this);}
return true;};Zapatec.Button.prototype._repeatDownAction=function(ev){if(this.config.downAction!=null){this.config.downAction(ev,this);}
if(this.config.repeatEnabled){if(this._repeatSpeed>this.config.repeatMaxSpeed){this._repeatSpeed=Math.round(this.config.repeatAcceleration*this._repeatSpeed);}
var self=this;this._timeoutId=setTimeout(function(){self._repeatDownAction();},this._repeatSpeed);}};Zapatec.Button.prototype._pauseRepeat=function(){if(this._timeoutId){clearTimeout(this._timeoutId);this._timeoutId=null;}};Zapatec.Button.prototype.preloadImages=function(){if(this.config.image!=null){var images=[this.config.image];if(this.config.overImage!=null){images.push(this.config.overImage);}
if(this.config.downImage!=null){images.push(this.config.downImage);}
Zapatec.Transport.preloadImages({urls:images});}};Zapatec.Button.prototype.setPressed=function(isPressed){this.isPressed=isPressed;if(isPressed){this.toggleClass('mouseDown');}else{this.toggleClass('mouseOut');}};Zapatec.Button.prototype.toggleClass=function(className){Zapatec.Utils.removeClass(this.statusContainer,"mouseOver");Zapatec.Utils.removeClass(this.statusContainer,"mouseOut");Zapatec.Utils.removeClass(this.statusContainer,"mouseDown");Zapatec.Utils.removeClass(this.statusContainer,"disabled");Zapatec.Utils.removeClass(this.internalContainer,this.config.overClass);Zapatec.Utils.removeClass(this.internalContainer,this.config.downClass);if(className!=null){Zapatec.Utils.addClass(this.statusContainer,className);}};Zapatec.Button.prototype.getContainer=function(){return this.container;};Zapatec.Button.prototype.applyStyle=function(style){Zapatec.Utils.applyStyle(this.internalContainer,style);};Zapatec.Button.prototype.isEnabled=function(){return this.enabled;};Zapatec.Button.prototype.enable=function(){this.enabled=true;this.toggleClass("mouseOut");};Zapatec.Button.prototype.disable=function(){this.enabled=false;this.toggleClass("disabled");};Zapatec.Button.prototype.setText=function(text){this.internalContainer.innerHTML=text;};Zapatec.Button.prototype.getText=function(){return this.internalContainer.innerHTML;};Zapatec.Button.setup=function(elRef,config){elRef=Zapatec.Widget.getElementById(elRef);if(elRef==null){return null;}
elRef.zpHasButton=true;if(config==null){config={};}
var nodeName=elRef.nodeName.toLowerCase();var oldOverAction=config.overAction!=null?config.overAction:function(){return true;};config.overAction=function(ev){return((elRef.onmouseover!=null?elRef.onmouseover.call(ev):true)&&oldOverAction(ev));};var oldOutAction=config.outAction!=null?config.outAction:function(){return true;};config.outAction=function(ev){return((elRef.onmouseout!=null?elRef.onmouseout.call(ev):true)&&oldOutAction(ev));};var oldDownAction=config.downAction!=null?config.downAction:function(){return true;};config.downAction=function(ev){return((elRef.onmousedown!=null?elRef.onmousedown.call(ev):true)&&oldDownAction(ev));};var oldClickAction=config.clickAction!=null?config.clickAction:function(){return true;};config.clickAction=function(ev){return((elRef.onclick!=null?elRef.onclick.call(ev):true)&&oldClickAction(ev));};var submitAction=function(ev){if(elRef.form!=null&&elRef.zpHidden==null){var hidden=document.createElement("input");hidden.type='hidden';hidden.name=elRef.name;hidden.value=elRef.value;hidden.style.display='none';Zapatec.Utils.insertAfter(elRef,hidden);elRef.zpHidden=hidden;}
if(elRef.form&&elRef.form.onSubmit!=null){elRef.form.onSubmit();}
return((elRef.onclick!=null?elRef.onclick.call(ev):true)&&oldClickAction(ev)&&(elRef.form!=null?elRef.form.submit():true));};if(nodeName=='button'){config.text=elRef.value;}else if(nodeName=='img'){config.image=elRef.src;config.text=elRef.title||elRef.title;}else if(nodeName=='div'||nodeName=='span'){config.text=elRef.innerHTML;}else if(nodeName=='input'){config.text=elRef.value;if(elRef.type.toLowerCase()=='image'){config.image=elRef.src;config.clickAction=submitAction;}else if(elRef.type.toLowerCase()=='button'){}else if(elRef.type.toLowerCase()=='submit'){config.clickAction=submitAction;}else if(elRef.type.toLowerCase()=='reset'){config.clickAction=function(ev){(elRef.onclick!=null?elRef.onclick.call(ev):true)&&oldClickAction(ev)&&(elRef.form!=null?elRef.form.reset():true)};}else{return null;}}else{return null;}
var button=new Zapatec.Button(config);Zapatec.Utils.insertAfter(elRef,button.getContainer());elRef.disabled=true;elRef.style.display='none';return button;};Zapatec.Button.setupAll=function(elRef,config){if(typeof(elRef)=='string'){elRef=document.getElementById(elRef);}
if(elRef==null){return null;}
var childs=elRef.all?elRef.all:elRef.getElementsByTagName("*");function cloneConfig(){var cfg={};for(var option in config){cfg[option]=config[option];}
return cfg;}
for(var ii=0;ii<childs.length;ii++){var child=childs[ii];if(child.nodeType==1&&(child.nodeName.toLowerCase()=='button'||child.nodeName.toLowerCase()=='input'&&(child.type.toLowerCase()=='image'||child.type.toLowerCase()=='button'||child.type.toLowerCase()=='submit'||child.type.toLowerCase()=='reset'))&&!child.zpHasButton){Zapatec.Button.setup(child,cloneConfig());}}};Zapatec.Button.prototype.destroy=function(){if(!this.container){return;}
this.container.onmouseover=null;this.container.onmouseout=null;this.container.onmousedown=null;this.container.onmouseup=null;this.container.onclick=null;this.internalContainer=null;this.statusContainer=null;this.container=null;return null;};Zapatec.Modal=function(config){if(arguments.length==0){config={};}
this.visible=false;Zapatec.Modal.SUPERconstructor.call(this,config);}
Zapatec.Modal.id="Zapatec.Indicator";Zapatec.inherit(Zapatec.Modal,Zapatec.Widget);Zapatec.Modal.prototype.init=function(config){Zapatec.Modal.SUPERclass.init.call(this,config);};Zapatec.Modal.prototype.configure=function(config){this.defineConfigOption("zIndex",1000);this.defineConfigOption("x",null);this.defineConfigOption("y",null);this.defineConfigOption("width",null);this.defineConfigOption("height",null);this.defineConfigOption("container",window);this.defineConfigOption("fixed",false);this.defineConfigOption("themePath",Zapatec.zapatecPath+"../zpextra/themes/indicator/");Zapatec.Modal.SUPERclass.configure.call(this,config);config=this.getConfiguration();if(config.container!=window){config.x=null;config.y=null;config.width=null;config.height=null;config.fixed=false;}};Zapatec.Modal.prototype.create=function(){var config=this.getConfiguration();config.container=Zapatec.Widget.getElementById(config.container)||window;this.WCH=Zapatec.Utils.createWCH();if(Zapatec.is_ie&&!Zapatec.Utils.isWindowLoaded()&&document.readyState!='interactive'){document.write('<div id="zpModalContainer"></div>');this.container=document.getElementById('zpModalContainer');}else{this.container=Zapatec.Utils.createElement("div",document.body);}
this.container.className=this.getClassName({prefix:"zpModal"+(Zapatec.is_opera?"Opera":"")})
var st=this.container.style;st.display="none";st.position="absolute";st.zIndex=config.zIndex;};Zapatec.Modal.prototype.show=function(zIndex){if(!this.container){this.create();}
zIndex=zIndex||this.config.zIndex;this.container.style.zIndex=zIndex;if(this.WCH){this.WCH.style.visibility="";this.WCH.style.zIndex=zIndex-1;}
this.container.style.display="block";this.visible=true;var config=this.getConfiguration();if(config.container!=window){var self=this;var update=function(){self.update();}
if(!this.interval){this.interval=setInterval(update,100);}
this.update();}else{var dim=Zapatec.Utils.getWindowSize();var width=config.width||dim.width;var height=config.height||dim.height;var x=config.x||Zapatec.Utils.getPageScrollX();var y=config.y||Zapatec.Utils.getPageScrollY();this.setWidth(width);this.setHeight(height);this.setPosition(x,y);}
if(this.config.fixed==true){Zapatec.FixateOnScreen.register(this.container);if(this.WCH){Zapatec.FixateOnScreen.register(this.WCH);}}};Zapatec.Modal.prototype.update=function(){var config=this.getConfiguration();if(config.container!=window&&this.visible){var offs=Zapatec.Utils.getElementOffset(config.container);this.setWidth(offs.width);this.setHeight(offs.height);this.setPosition(offs.x,offs.y);}};Zapatec.Modal.prototype.hide=function(destroy){var config=this.getConfiguration();if(!config){return;}
if(config.fixed==true){Zapatec.FixateOnScreen.unregister(this.container);if(this.WCH){Zapatec.FixateOnScreen.unregister(this.WCH);}}
if(config.container!=window){clearInterval(this.interval);this.interval=null;}
if(this.container)this.container.style.display="none";Zapatec.Utils.hideWCH(this.WCH);if(destroy){if(this.WCH){if(this.WCH.outerHTML){this.WCH.outerHTML="";}else{Zapatec.Utils.destroy(this.WCH);}}
if(this.container.outerHTML){this.container.outerHTML="";}else{Zapatec.Utils.destroy(this.container);}
this.WCH=null;this.container=null;}
this.visible=false;};Zapatec.Modal.prototype.setWidth=function(width){if(!this.container){return;}
if(Zapatec.Utils.setWidth){Zapatec.Utils.setWidth(this.container,width);Zapatec.Utils.setWidth(this.WCH,width);}else{this.container.style.width=width+"px";if(this.WCH){this.WCH.style.width=width+"px";}}};Zapatec.Modal.prototype.setHeight=function(height){if(!this.container){return;}
if(Zapatec.Utils.setHeight){Zapatec.Utils.setHeight(this.container,height);Zapatec.Utils.setHeight(this.WCH,height);}else{this.container.style.height=height+"px";if(this.WCH){this.WCH.style.height=height+"px";}}};Zapatec.Modal.prototype.setPosition=function(x,y){if(!this.container){return;}
if(Zapatec.Utils.moveTo){Zapatec.Utils.moveTo(this.container,x,y);Zapatec.Utils.moveTo(this.WCH,x,y);}else{this.container.style.left=x+"px";this.container.style.top=y+"px";if(this.WCH){this.WCH.style.left=x+"px";this.WCH.style.top=y+"px";}}};Zapatec.Indicator=function(config){if(arguments.length==0){config={};}
this.active=false;Zapatec.Indicator.SUPERconstructor.call(this,config);}
Zapatec.Indicator.id="Zapatec.Indicator";Zapatec.inherit(Zapatec.Indicator,Zapatec.Modal);Zapatec.Indicator.prototype.init=function(config){Zapatec.Indicator.SUPERclass.init.call(this,config);};Zapatec.Indicator.prototype.configure=function(config){this.defineConfigOption("themePath",Zapatec.zapatecPath+"../zpextra/themes/indicator/");Zapatec.Indicator.SUPERclass.configure.call(this,config);};Zapatec.Indicator.prototype.create=function(){Zapatec.Indicator.SUPERclass.create.call(this);this.indicator=Zapatec.Utils.createElement("div",this.container);this.indicator.className="zpIndicator";var st=this.indicator.style;st.position="absolute";st.zIndex=this.getConfiguration().zIndex;st.backgroundColor="#aaaaaa";};Zapatec.Indicator.prototype.setWidth=function(width){if(!this.container){return;}
Zapatec.Indicator.SUPERclass.setWidth.call(this,width);var left=Math.round((this.container.offsetWidth-this.indicator.offsetWidth)/2);this.indicator.style.left=left+"px";};Zapatec.Indicator.prototype.setHeight=function(height){if(!this.container){return;}
Zapatec.Indicator.SUPERclass.setHeight.call(this,height);var top=Math.round((this.container.offsetHeight-this.indicator.offsetHeight)/2);this.indicator.style.top=top+"px";};Zapatec.Indicator.prototype.hide=function(destroy){if(destroy){this.indicator=null;}
Zapatec.Indicator.SUPERclass.hide.call(this,destroy);};Zapatec.Indicator.prototype.start=function(message){this.active=true;if(!this.indicator){this.create();}
this.indicator.innerHTML=message;this.show();};Zapatec.Indicator.prototype.stop=function(){this.active=false;this.hide(true);};Zapatec.Indicator.prototype.isActive=function(){return this.active;};Zapatec.Pane=function(objArgs){this.config={};if(arguments.length==0){objArgs={};}
this.widgetType="pane";this.ready=false;this.loading=false;this.prepared=false;Zapatec.Utils.createProperty(this,"container",null);Zapatec.Utils.createProperty(this,"contentElement",null);Zapatec.Utils.createProperty(this,"iframeDocument",null);Zapatec.Pane.SUPERconstructor.call(this,objArgs);}
Zapatec.Pane.id="Zapatec.Pane";Zapatec.inherit(Zapatec.Pane,Zapatec.Widget);Zapatec.Pane.prototype.init=function(objArgs){Zapatec.Utils.createProperty(this.config,"parent",document.body);this.config.theme=null;this.config.width=null;this.config.height=null;this.config.containerType="div";this.config.sourceType=null;this.config.source=null;this.config.autoContentWidth=false;this.config.autoContentHeight=false;this.config.onlyInit=false;this.config.showLoadingIndicator=true;this.config.overflow="auto";this.config.iframeScrolling=null;this.config.removeBorder=false;this.config.id=null;Zapatec.Pane.SUPERclass.init.call(this,objArgs);if(this.config.containerType==null){this.config.containerType="div";}
if(!this.config.onlyInit){this.create(this.config.width,this.config.height);}
var self=this;function update(){if(self.loader){self.loader.update();}}
this.addEventListener("fetchSourceStart",update);this.addEventListener("fetchSourceEnd",update);}
Zapatec.Pane.prototype.prepareHtml=function(){if(this.config.containerType.toLowerCase()=='iframe'){var iframe=document.createElement("iframe");if(this.config.iframeScrolling){iframe.scrolling=this.config.iframeScrolling;}
iframe.src=Zapatec.zapatecPath+"pane_files/blank.html#"+this.id;this.container=iframe;iframe=null;}else if(this.config.containerType.toLowerCase()=='div'){this.container=document.createElement("div");if(this.config.id){this.container.id=this.config.id;}
this.contentElement=this.container;}else if(this.config.parent&&this.config.parent.nodeType==1){this.container=this.config.parent;this.contentElement=this.container;}
this.prepared=true;if(this.config.removeBorder){this.removeBorder();}};Zapatec.Pane.prototype.create=function(width,height){if(!this.prepared){this.prepareHtml();}
if(!(this.config.parent=Zapatec.Widget.getElementById(this.config.parent))){Zapatec.Log({description:"No reference to parent element."});return null;}
if(this.config.parent.requestParentFor&&!(this.config.parent=this.config.parent.requestParentFor(this))){Zapatec.Log({description:"No reference to parent element after request to the Parent Widget!"});return null;}
if(this.config.containerType.toLowerCase()=='div'||this.config.containerType.toLowerCase()=='iframe'){this.ready=false;this.config.parent.appendChild(this.container);if(this.config.containerType.toLowerCase()!='iframe'){this.initPane();}}else if(this.config.containerType.toLowerCase()=='current'){this.container=this.config.parent;this.contentElement=this.container;this.initPane();}else{Zapatec.Log({description:"Unknown container type: "+this.config.containerType+". Possible values: iframe|div"})}
Zapatec.Utils.addClass(this.container,this.getClassName({prefix:"zpPane"}));if(width||this.config.width){this.setWidth(width||this.config.width);}
if(height||this.config.height){this.setHeight(height||this.config.height);}
this.getContainer().style.display="block";this.setPaneContent();};Zapatec.Pane.prototype.initPane=function(){if(this.config.containerType.toLowerCase()=='iframe'){var doc=null;var sameDomain=true;var url=this.container.src;var anchorEl=document.createElement("a");var protocolSeparatorPos=url.indexOf("://");if(protocolSeparatorPos!=-1){var domainSeparatorPos=url.indexOf("/",protocolSeparatorPos+3);var domain=url.substring((protocolSeparatorPos>0?protocolSeparatorPos+3:0),(domainSeparatorPos>0?domainSeparatorPos:url.length));if(domain!=window.location.host){sameDomain=false;}}
if(sameDomain){if(this.container.contentDocument!=null){doc=this.container.contentDocument;}else if(this.container.contentWindow&&this.container.contentWindow.document!=null){doc=this.container.contentWindow.document;}
var self=this;anchorEl.href=url;url=anchorEl.href;if(doc==null||doc.body==null||(Zapatec.is_gecko&&url!=this.container.contentWindow.location.href)){setTimeout(function(){self.initPane()},50);return false;}
this.iframeDocument=doc;this.contentElement=doc.body;if(typeof this.container.contentWindow.Zapatec!="object"&&typeof this.container.contentWindow.Zapatec!="function"){this.container.contentWindow.Zapatec={};this.container.contentWindow.Zapatec.windowLoaded=typeof(doc.readyState)!='undefined'?(doc.readyState=='loaded'||doc.readyState=='complete'):doc.getElementsByTagName!=null&&typeof(doc.getElementsByTagName('body')[0])!='undefined';Zapatec.Utils.addEvent(this.container.contentWindow,"load",function(){self.container.contentWindow.Zapatec.windowLoaded=true;},false,false);}
if(!this.container.contentWindow.Zapatec||!this.container.contentWindow.Zapatec.windowLoaded){setTimeout(function(){self.initPane()},50);return false;}
doc=null;}}
if(this.config.overflow){this.getContainer().style.overflow=this.config.overflow;}
this.ready=true;this.fireEvent("onReady",this);this.hideIndicator();this.loading=false;this.removeEvent("onReady");}
Zapatec.Pane.prototype.getContainer=function(){return this.container;}
Zapatec.Pane.prototype.getIframeDocument=function(){return this.iframeDocument;}
Zapatec.Pane.prototype.getContentElement=function(){return this.contentElement;}
Zapatec.Pane.prototype.isReady=function(){return this.ready;}
Zapatec.Pane.prototype.loadDataJson=function(objSource){return objSource!=null?this.setContent(objSource.content):null;}
Zapatec.Pane.prototype.setContent=function(content){if(!this.isReady()){var self=this;setTimeout(function(){self.setContent(content)},50);return null;}
this.loading=false;if(!this.getContentElement()){this.hideIndicator();return false;}
if(content===null){this.hideIndicator();return null;}else{if(this.config.containerType.toLowerCase()!="iframe"){var oldOverflow=this.getContainer().style.overflow;if(this.config.autoContentWidth){this.getContainer().style.overflow="visible";this.getContainer().style.width="auto";}
if(this.config.autoContentHeight){this.getContainer().style.overflow="visible";this.getContainer().style.height="auto";}}
if(typeof(content)=='string'){Zapatec.Transport.setInnerHtml({container:this.getContentElement(),html:content});}else{try{if((Zapatec.is_ie||Zapatec.is_opera)&&this.config.containerType.toLowerCase()=="iframe"){Zapatec.Transport.setInnerHtml({container:this.getContentElement(),html:content.outerHTML});}else{if(content.parentNode!=this.getContentElement()){this.getContentElement().innerHTML="";this.getContentElement().appendChild(content);}}}catch(ex){this.hideIndicator();return null;}}
if(this.config.containerType.toLowerCase()!="iframe"){var newWidth=this.getWidth();var newHeight=this.getHeight();}else{var newWidth=this.getContentElement().scrollWidth+5;var newHeight=this.getContentElement().scrollHeight+5;}
if(typeof oldOverflow!="undefined")this.getContainer().style.overflow=oldOverflow;if(this.config.autoContentWidth){this.setWidth(newWidth);}
if(this.config.autoContentHeight){this.setHeight(newHeight);}}
this.fireEvent("contentLoaded",this);this.hideIndicator();return true;}
Zapatec.Pane.prototype.loadDataHtml=Zapatec.Pane.prototype.loadDataXml=Zapatec.Pane.prototype.setContent;Zapatec.Pane.prototype.loadDataHtmlText=function(content){this.setContent(content);};Zapatec.Pane.prototype.setWidth=function(width){var self=this;this.fireWhenReady(function(){if(width>=0){self.getContainer().style.width=width+"px";}
if(self.getContainer().offsetWidth!=width){var newWidth=width-(self.getContainer().offsetWidth-width);if(newWidth<0)newWidth=0;self.getContainer().style.width=newWidth+"px";}});}
Zapatec.Pane.prototype.getWidth=function(){return this.getContainer().offsetWidth;}
Zapatec.Pane.prototype.setHeight=function(height){var self=this;this.fireWhenReady(function(){if(height>=0){self.getContainer().style.height=height+"px";}
if(self.getContainer().offsetHeight!=height){var newHeight=height-(self.getContainer().offsetHeight-height);if(newHeight<0)newHeight=0;self.getContainer().style.height=newHeight+"px";}});}
Zapatec.Pane.prototype.getHeight=function(){return this.getContainer().offsetHeight;}
Zapatec.Pane.prototype.removeBorder=function(){if(this.config.containerType.toLowerCase()!="iframe"){return false;}
var self=this;this.fireWhenReady(function(){if(!Zapatec.is_ie){self.getContainer().style.border="none";}else{if(self.getContentElement()){self.getContentElement().style.border="none";}}});};Zapatec.Pane.prototype.setPaneContent=function(content,type){if(!content&&content!==""){content=this.config.source;}
if(!type){type=this.config.sourceType;}
this.config.source=content;this.config.sourceType=type;var self=this;if(this.config.showLoadingIndicator){this.showIndicator();this.loading=true;}
if(this.config.containerType.toLowerCase()=="iframe"&&type=="html/url"){this.ready=false;this.fireWhenReady(function(){if(self.getContentElement()){try{var newWidth=self.getContentElement().scrollWidth;var newHeight=self.getContentElement().scrollHeight;if(self.config.autoContentWidth){self.setWidth(newWidth);}
if(self.config.autoContentHeight){self.setHeight(newHeight);}}catch(e){}}
self.fireEvent("contentLoaded",self);if(self.events["contentLoaded"]){self.events["contentLoaded"].listeners=[];}});this.getContainer().src=content;setTimeout(function(){self.initPane()},50);return true;}
if(this.config.containerType.toLowerCase()=="iframe"&&this.getContainer().src.indexOf((Zapatec.zapatecPath+"pane_files/blank.html#"+this.id).replace(/\.\.\//g,""))<0){this.ready=false;this.getContainer().src=Zapatec.zapatecPath+"pane_files/blank.html#"+this.id;}
this.loadData();return true;};Zapatec.Pane.prototype.show=function(){this.getContainer().style.display="";if(this.loading){this.showIndicator();}};Zapatec.Pane.prototype.hide=function(){this.getContainer().style.display="none";if(this.loading){this.hideIndicator();}};Zapatec.Pane.prototype.showIndicator=function(message){if(Zapatec.Indicator){this.hideIndicator();if(!this.loader){this.loader=new Zapatec.Indicator({container:this.container,themePath:Zapatec.zapatecPath+"../zpextra/themes/indicator/"});}
this.loader.start(message||'loading');}};Zapatec.Pane.prototype.hideIndicator=function(){if(this.loader&&this.loader.isActive()){this.loader.stop();}};Zapatec.Pane.prototype.fireWhenReady=function(func){if(!this.isReady()){this.addEventListener("onReady",func);}else{func.call(this,this);}}
Zapatec.Pane.prototype.destroy=function(){if(!this.config){return;}
this.hideIndicator();this.contentElement=null;this.iframeDocument=null;if(Zapatec.is_ie&&this.config.containerType.toLowerCase()=='iframe'){this.container.src="javascript:void(0)";}
if(this.container.outerHTML){this.container.outerHTML="";}else{Zapatec.Utils.destroy(this.container);}
this.container=null;this.ready=false;this.prepared=false;}
Zapatec.MinimalEditor=function(objArgs){if(arguments.length==0){objArgs={};}
Zapatec.MinimalEditor.SUPERconstructor.call(this,objArgs);}
Zapatec.MinimalEditor.id='Zapatec.MinimalEditor';zapatecEditor=Zapatec.MinimalEditor;Zapatec.inherit(Zapatec.MinimalEditor,Zapatec.Widget);Zapatec.MinimalEditor.prototype.init=function(objArgs){Zapatec.MinimalEditor.SUPERclass.init.call(this,objArgs);this.createEditor();this.initEditor();}
Zapatec.MinimalEditor.prototype.createEditor=function(){this.createProperty(this,'container',null);this.createProperty(this,'editorPanel',null);this.buttons=[];this.tooltips=[];this.colorPickers=[];this.createProperty(this,'wch',null);this.createProperty(this,'undo',new Zapatec.MinimalEditor.Undo(this));this.doctype="";this.isDefaultFullHtml=true;if(Zapatec.is_webkit){this.fillWebKitMap();}
var fieldWidth=this.config.field.clientWidth;var fieldHeight=this.config.field.clientHeight;this.container=Zapatec.Utils.createElement("div");this.container.id='zpEditor'+this.id+'Container';Zapatec.Utils.insertAfter(this.config.field,this.container);if(!Zapatec.is_opera){this.container.style.cssText=this.config.field.style.cssText;}
else{for(var i in this.config.field.style){try{this.container.style[i]=this.config.field.style[i];}catch(e){}}}
this.config.field.style.position="static";this.config.field.style.left="";this.config.field.style.top="";this.config.field.style.margin="0";this.editorPanel=document.createElement("div");this.editorPanel.id='zpEditor'+this.id+'EditorPanel';this.container.appendChild(this.editorPanel);this.editorPanel.className=this.getClassName({prefix:"zpEditor",suffix:"EditorPanel"});this.config.field.parentNode.removeChild(this.config.field);this.editorPanel.appendChild(this.config.field);this.config.field.className=this.getClassName({prefix:"zpEditor",suffix:"Textarea"});this.wch=Zapatec.Utils.createWCH(this.editorPanel);if(this.wch){this.wch.style.zIndex=-1;}
this.addButtons();var paneSize=this.getPaneSize(fieldWidth,fieldHeight);this.pane=new Zapatec.Pane({parent:this.editorPanel,containerType:'iframe',width:paneSize.width,height:paneSize.height,showLoadingIndicator:false})
this.pane.removeBorder();this.pane.getContainer().className=this.getClassName({prefix:"zpEditor",suffix:"Pane"});this.setSize(fieldWidth,fieldHeight);this.config.field.style.display="none";this.mode="WYSIWYG";this.toggleButtons(false);}
Zapatec.MinimalEditor.prototype.configure=function(objArgs){this.defineConfigOption('field');this.defineConfigOption('asyncTheme',true);this.defineConfigOption('maximizedBorder',6);this.defineConfigOption('toolbarElements',['fontName','fontSize','newPanel','bold','italic','underline','newPanel','foreColor','backColor','insertLink','insertImage','insertTable','insertHorizontalRule','newRow','justifyLeft','justifyCenter','justifyRight','newPanel','insertOrderedList','insertUnorderedList','newPanel','selectall','copy','cut','paste','newPanel','outdent','indent','newPanel','undo','redo','newPanel','switcher','newPanel','about']);this.defineConfigOption('langId',Zapatec.MinimalEditor.id);this.defineConfigOption('lang',"eng");this.defineConfigOption('persistKey',null);this.defineConfigOption('persistPath',null);this.defineConfigOption('externalBrowserWidth',450);this.defineConfigOption('externalBrowserHeight',350);this.defineConfigOption('externalBrowserNoScript',false);this.defineConfigOption('enableTooltips',false);this.defineConfigOption('fullPage',false);this.defineConfigOption('dumpHtml',false);this.defineConfigOption('generateXhtml',false);this.defineConfigOption('customUndo',true);this.defineConfigOption('maxUndoTypes',25);this.defineConfigOption('maxUndoLevels',100);this.defineConfigOption('foreColor',"");this.defineConfigOption('backColor',"");this.defineConfigOption('preserveImgSrc',Zapatec.is_ie);this.defineConfigOption('preserveAnchorHref',Zapatec.is_ie);this.defineConfigOption('excludeToolbar',false);this.defineConfigOption('documentBodyMargin');this.defineConfigOption('documentBodyPadding');this.defineConfigOption('disableMultiLine',false);this.defineConfigOption('paneSize');this.defineConfigOption('linksTarget',false);this.defineConfigOption('win');Zapatec.MinimalEditor.SUPERclass.configure.call(this,objArgs);for(var ii=0;ii<this.config.toolbarElements.length;ii++){this.config.toolbarElements[ii]=this.config.toolbarElements[ii].toLowerCase();}
if(typeof(this.config.field)=="undefined"){Zapatec.Log({description:this.getMessage('noTextareaError')});return false;}
var oTextarea=zapatecWidget.getElementById(this.config.field);if(!oTextarea){this.debug(this.getMessage('noTextareaError'));return false;}
var oTextareaStyle=oTextarea.style;this.textareaStyle={position:oTextareaStyle.position,left:oTextareaStyle.left,top:oTextareaStyle.top,margin:oTextareaStyle.margin,width:oTextareaStyle.width,height:oTextareaStyle.height,display:''};this.config.field=oTextarea;if(this.config.field==null||this.config.field.nodeType!=1||this.config.field.nodeName.toLowerCase()!="textarea"){Zapatec.Log({description:this.getMessage('fieldIsNotTextareaError')})
return false;}
if(typeof Zapatec.Tooltip=='undefined'){this.config.enableTooltips=false;}};Zapatec.MinimalEditor.prototype.initEditor=function(counter){var self=this;counter=counter||0;if(this.pane==null||!this.pane.isReady()){if(counter<1000){setTimeout(function(){self.initEditor(++counter)},100);}
return null;}
this.setSize();this.installListeners();this.toggleDesignMode(true);this.loadContentFromField();this.undo.saveUndo();this.toggleButtons(true);this.fireEvent("onInit");}
Zapatec.MinimalEditor.prototype.installListeners=function(){var self=this;if(Zapatec.is_ie){this.pane.getContentElement().onbeforedeactivate=function(){self.fireEvent('onBlur',self);var sel=self.pane.getContainer().contentWindow.document.selection;if(sel){try{var range=sel.createRange();self.oldSelectionRange=range;}
catch(e){}}}
Zapatec.Utils.addEvent(this.pane.getIframeDocument().body,'focus',function(){self.fireEvent('focus',self);});Zapatec.Utils.addEvent(this.pane.getContainer(),'focus',function(){self.pane.getIframeDocument().body.focus();});}
else{Zapatec.Utils.addEvent(this.pane.getIframeDocument(),'blur',function(){self.fireEvent('onBlur',self);});Zapatec.Utils.addEvent(this.pane.getIframeDocument(),'focus',function(){self.fireEvent('focus',self);});}
Zapatec.Utils.addEvent(this.pane.getIframeDocument(),"keydown",function(e){var isPrevent=false;if(!e){e=self.pane.getIframeDocument().event;}
self.undo.onKeyDown();switch(e.keyCode){case 13:if(self.config.disableMultiLine){isPrevent=true;}
if(!(e.ctrlKey||e.altKey||e.shiftKey)){var isHandled=self.onEnterPressed();if(isHandled){isPrevent=true;}};break;}
if(isPrevent){Zapatec.Utils.stopEvent(e);return false;}});Zapatec.Utils.addEvent(this.pane.getIframeDocument(),"keyup",function(){self.saveContentToField();self.invokeUpdateToolbar();});Zapatec.Utils.addEvent(this.pane.getIframeDocument(),"click",function(){self.invokeUpdateToolbar();});Zapatec.Utils.addEvent(this.pane.getIframeDocument(),"contextmenu",function(){self.invokeUpdateToolbar();});}
Zapatec.MinimalEditor.prototype.setSize=function(width,height){if(!width){width=parseInt(this.container.style.width);}
if(!height){height=parseInt(this.container.style.height);}
this.container.style.width=width+'px';this.container.style.height=height+'px';if(!this.config.excludeToolbar&&this.toolbar){this.toolbar.style.width=width+'px';}
var paneSize=this.getPaneSize(width,height);var paneWidth=paneSize.width;var paneHeight=paneSize.height;var iframeWidth=paneWidth;var iframeHeight=paneHeight;if(!Zapatec.is_ie&&!Zapatec.is_khtml){iframeHeight-=4;if(!this.isMaximize){iframeWidth-=4;}}
if(Zapatec.is_ie7){iframeWidth-=1;iframeHeight-=3;}
this.pane.getContainer().style.width=iframeWidth+'px';this.pane.getContainer().style.height=iframeHeight+'px';var editorPanelHeight=paneHeight;var editorPanelWidth=width-2;if(!Zapatec.is_ie&&!Zapatec.is_khtml){editorPanelHeight-=4;}
if(Zapatec.is_ie7){editorPanelHeight-=1;}
this.editorPanel.style.width=editorPanelWidth+'px';this.editorPanel.style.height=editorPanelHeight+'px';Zapatec.Utils.setupWCH(this.wch,0,0,width,paneHeight);if(Zapatec.is_ie){paneWidth-=2;paneHeight-=2;if(Zapatec.is_ie7){paneWidth-=5;paneHeight-=6;}}
else{if(!Zapatec.is_khtml){if(this.isMaximize){paneHeight-=5;}
else{paneHeight-=5;paneWidth-=4;}}}
this.config.field.style.width=paneWidth+'px';this.config.field.style.height=paneHeight+'px';}
Zapatec.MinimalEditor.prototype.getPaneSize=function(width,height){var paneWidth=width;var paneHeight=height;if(!this.config.excludeToolbar&&0<this.config.toolbarElements.length){paneHeight-=this.toolbar.offsetHeight;if(paneHeight<50){paneHeight=50;}}
if(this.config.paneSize){if(this.config.paneSize.width)paneWidth=this.config.paneSize.width;if(this.config.paneSize.height)paneHeight=this.config.paneSize.height;}
if(Zapatec.is_ie){paneWidth-=2;}
else{if(Zapatec.is_khtml){paneWidth-=2;}
else{if(this.isMaximize){paneWidth-=2;}
else{paneWidth+=2;}}}
return{width:paneWidth,height:paneHeight};}
Zapatec.MinimalEditor.prototype.loadContentFromField=function(){this.setHTML(this.config.field.value);if(Zapatec.is_gecko&&this.pane.getIframeDocument().execCommand){this.pane.getIframeDocument().execCommand("inserthtml",false,"-");this.pane.getIframeDocument().execCommand("undo",false,null);}}
Zapatec.MinimalEditor.prototype.saveContentToField=function(){if(this.mode=="WYSIWYG"){var sVal=this.getHTML()
var oTextarea=this.config.field;if(oTextarea.tagName.toLowerCase()=='textarea'){try{oTextarea.innerHTML=sVal;}catch(oException){};}
oTextarea.value=sVal;}}
Zapatec.MinimalEditor.prototype.toggleDesignMode=function(enable){try{if(Zapatec.is_ie){this.pane.getContentElement().contentEditable=enable;}
else{this.pane.getContainer().contentWindow.document.designMode=enable?"on":"off";}}catch(oException){};}
Zapatec.MinimalEditor.prototype.execCommand=function(command,arg1,arg2){var object=null;if(Zapatec.is_ie){object=this.pane.getIframeDocument();}
else{object=this.pane.getContainer().contentWindow.document;}
return object.execCommand(command,arg1,arg2);}
Zapatec.MinimalEditor.prototype.queryCommandValue=function(command){var object=this.pane.getIframeDocument();return object.queryCommandValue(command);}
Zapatec.MinimalEditor.prototype.queryCommandState=function(command){var object=this.pane.getIframeDocument();return object.queryCommandState(command);}
Zapatec.MinimalEditor.prototype.queryCommandEnabled=function(command){var object=this.pane.getIframeDocument();return object.queryCommandEnabled(command);}
Zapatec.MinimalEditor.prototype.focus=function(){if(Zapatec.is_khtml||Zapatec.is_opera){this.pane.getContainer().focus();}
else{if(Zapatec.is_gecko){document.body.focus();}
this.pane.getContainer().contentWindow.focus();}}
Zapatec.MinimalEditor.prototype.focusHtml=function(){if(Zapatec.is_ie7){var scrollTop=Zapatec.Utils.getPageScrollY();}
this.config.field.focus();if(Zapatec.is_ie7){window.scroll(0,scrollTop);}}
Zapatec.MinimalEditor.prototype.addButtons=function(){if(this.config.toolbarElements.length==0){return false;}
this.toolbar=document.createElement("table");this.toolbar.id='zpEditor'+this.id+'ToolbarTable';this.container.insertBefore(this.toolbar,this.editorPanel);this.toolbar.border=0;this.toolbar.className=this.getClassName({prefix:"zpEditor",suffix:"Toolbar"});this.toolbar.style.width=this.config.field.clientWidth+'px';var tbody=document.createElement("tbody");this.toolbar.appendChild(tbody);var tr=document.createElement("tr");tbody.appendChild(tr)
var td=document.createElement("td");td.setAttribute("nowrap","true");tr.appendChild(td);var span=document.createElement("span");span.className="toolbarPanel";td.appendChild(span)
var self=this;for(var ii=0;ii<this.config.toolbarElements.length;ii++){var element=this.config.toolbarElements[ii];if(Zapatec.is_webkit&&Zapatec.webkitVersion&&this.webKitMap[element]&&Zapatec.webkitVersion<this.webKitMap[element]){continue;}
switch(element){case"maximize":var tooltip=this.getMessage('maximizeTooltip');var button=this.createButton("maximize",tooltip,null,function(){self.resizeEditor();self.focus();});button.id='zpEditor'+this.id+'Maximize';span.appendChild(button);break;case"fontname":var fontNameSelect=this.createSelect(["Font","Arial","Courier","Times New Roman"],["Font","Arial","Courier","Times New Roman"],function(){self.execCommand("fontname",false,this.options[this.options.selectedIndex].value);self.saveContentToField();self.focus();self.undo.saveUndo();self.updateToolbar();});fontNameSelect.id='zpEditor'+this.id+'FontName';span.appendChild(fontNameSelect);break;case"fontsize":var fontSizeSelect=this.createSelect(["Size","1","2","3","4","5","6","7"],["Size","1","2","3","4","5","6","7"],function(){self.execCommand("fontsize",false,this.options[this.options.selectedIndex].value);self.saveContentToField();self.focus();self.undo.saveUndo();self.updateToolbar();});fontSizeSelect.id='zpEditor'+this.id+'FontSize';span.appendChild(fontSizeSelect);break;case"forecolor":case"backcolor":var button=this.createColorButton(element=="forecolor");span.appendChild(button);break;case"insertlink":var tooltip=this.getMessage('insertLinkTooltip');var button=this.createButton("link",tooltip,function(){self.showInsertLinkWindow();self.focus();});button.id='zpEditor'+this.id+'InsertLink';span.appendChild(button);break;case"insertimage":var tooltip=this.getMessage('insertImageTooltip');var button=this.createButton("image",tooltip,null,function(){var text=self.getMessage('insertImagePrompt');var imgUrl=prompt(text,"http://");if(imgUrl!=null&&imgUrl!=""){self.execCommand("insertimage",false,imgUrl);self.saveContentToField();self.focus();self.undo.saveUndo();self.updateToolbar();}});button.id='zpEditor'+this.id+'InsertImage';span.appendChild(button);break;case"inserttable":var tooltip=this.getMessage('insertTableTooltip');var button=this.createButton("table",tooltip,null,function(){if(Zapatec.is_khtml){self.storeSelection();}
var rowsText=self.getMessage('insertTableRowsPrompt');var rowsAnswer=prompt(rowsText,2);if(null==rowsAnswer||''==rowsAnswer){return;}
var rows=parseInt(rowsAnswer);var colsText=self.getMessage('insertTableColsPrompt');var colsAnswer=prompt(colsText,2);if(null==colsAnswer||''==colsAnswer){return;}
var cols=parseInt(colsAnswer);var borderWidthText=self.getMessage('insertTableBorderWidthPrompt');var borderAnswer=prompt(borderWidthText,2);if(null==borderAnswer||''==borderAnswer){return;}
var borderWidth=parseInt(borderAnswer);if(isNaN(borderWidth)){borderWidth=1;}
if(!isNaN(rows)&&rows>0&&!isNaN(cols)&&cols>0){var tbl=self.pane.getIframeDocument().createElement("table");tbl.setAttribute("border",borderWidth);tbl.setAttribute("cellpadding","1");tbl.setAttribute("cellspacing","1");var tbltbody=self.pane.getIframeDocument().createElement("tbody");for(var kk=0;kk<rows;kk++){var tbltr=self.pane.getIframeDocument().createElement("tr");for(var jj=0;jj<cols;jj++){var tbltd=self.pane.getIframeDocument().createElement("td");tbltd.setAttribute("width",10);var tblbr=self.pane.getIframeDocument().createElement("br");tbltd.appendChild(tblbr);tbltr.appendChild(tbltd);}
tbltbody.appendChild(tbltr);}
tbl.appendChild(tbltbody);if(Zapatec.is_khtml){self.restoreSelection();}
self.insertNodeAtSelection(tbl);}
self.saveContentToField();self.focus();self.undo.saveUndo();self.updateToolbar();});button.id='zpEditor'+this.id+'InsertTable';span.appendChild(button);break;case"inserthorizontalrule":var tooltip=this.getMessage('insertHorizontalRule');var button=this.createButton("hr",tooltip,function(){var hr=self.pane.getIframeDocument().createElement("hr");self.insertNodeAtSelection(hr);self.saveContentToField();self.focus();self.undo.saveUndo();self.updateToolbar();});button.id='zpEditor'+this.id+'InsertHorizontalRule';span.appendChild(button);break;case"insertspecialchar":var tooltip=this.getMessage('insertSpecialCharacter');var button=this.createButton("insertspecial",tooltip,function(){if(Zapatec.is_khtml){self.storeSelection();}},function(){self.showCharMapWindow();self.focus();});button.id='zpEditor'+this.id+'InsertSpecialChar';span.appendChild(button);break;case"selectall":var tooltip=this.getMessage('selectAllTooltip');var button=this.createButton("selectall",tooltip,function(){self.execCommand("selectall");self.focus();self.updateToolbar();});button.id='zpEditor'+this.id+'SelectAll';span.appendChild(button);break;case"bold":var button=this.createButton("bold","Bold",function(){self.execCommand("bold",false,null);self.saveContentToField();self.focus();self.undo.saveUndo();self.updateToolbar();});button.id='zpEditor'+this.id+'Bold';span.appendChild(button);break;case"italic":var button=this.createButton("italic","Italic",function(){self.execCommand("italic",false,null);self.saveContentToField();self.focus();self.undo.saveUndo();self.updateToolbar();});button.id='zpEditor'+this.id+'Italic';span.appendChild(button);break;case"underline":var tooltip=this.getMessage('underlineTooltip');var button=this.createButton("underline",tooltip,function(){self.execCommand("underline",false,null);self.saveContentToField();self.focus();self.undo.saveUndo();self.updateToolbar();});button.id='zpEditor'+this.id+'Underline';span.appendChild(button);break;case"justifyleft":var tooltip=this.getMessage('justifyLeftTooltip');var button=this.createButton("justifyleft",tooltip,function(){self.execCommand("justifyleft",false,null);self.saveContentToField();self.focus();self.undo.saveUndo();self.updateToolbar();});button.id='zpEditor'+this.id+'JustifyLeft';span.appendChild(button);break;case"justifycenter":var tooltip=this.getMessage('justifyCenterTooltip');var button=this.createButton("justifycenter",tooltip,function(){self.execCommand("justifycenter",false,null);self.saveContentToField();self.focus();self.undo.saveUndo();self.updateToolbar();});button.id='zpEditor'+this.id+'JustifyCenter';span.appendChild(button);break;case"justifyright":var tooltip=this.getMessage('justifyRightTooltip');var button=this.createButton("justifyright",tooltip,function(){self.execCommand("justifyright",false,null);self.saveContentToField();self.focus();self.undo.saveUndo();self.updateToolbar();});button.id='zpEditor'+this.id+'JustifyRight';span.appendChild(button);break;case"justifyfull":var tooltip=this.getMessage('justifyFullTooltip');var button=this.createButton("justifyfull",tooltip,function(){self.execCommand("justifyfull",false,null);self.saveContentToField();self.focus();self.undo.saveUndo();self.updateToolbar();});button.id='zpEditor'+this.id+'JustifyFull';span.appendChild(button);break;case"insertorderedlist":var tooltip=this.getMessage('orderedListTooltip');var button=this.createButton("orderedlist",tooltip,function(){self.execCommand("insertorderedlist",false,null);self.saveContentToField();self.focus();self.undo.saveUndo();self.updateToolbar();});button.id='zpEditor'+this.id+'InsertOrderedList';span.appendChild(button);break;case"insertunorderedlist":var tooltip=this.getMessage('unorderedListTooltip');var button=this.createButton("unorderedlist",tooltip,function(){self.execCommand("insertunorderedlist",false,null);self.saveContentToField();self.focus();self.undo.saveUndo();self.updateToolbar();});button.id='zpEditor'+this.id+'InsertUnorderedList';span.appendChild(button);break;case"copy":var tooltip=this.getMessage('copyTooltip');var button=this.createButton("copy",tooltip,function(){self.execCommand("copy",false,null);self.saveContentToField();self.focus();});button.id='zpEditor'+this.id+'Copy';span.appendChild(button);break;case"cut":var tooltip=this.getMessage('cutTooltip');var button=this.createButton("cut",tooltip,function(){self.execCommand("cut",false,null);self.saveContentToField();self.focus();self.undo.saveUndo();self.updateToolbar();});button.id='zpEditor'+this.id+'Cut';span.appendChild(button);break;case"paste":var tooltip=this.getMessage('pasteTooltip');var button=this.createButton("paste",tooltip,function(){self.execCommand("paste",false,null);self.saveContentToField();self.focus();self.undo.saveUndo();self.updateToolbar();});button.id='zpEditor'+this.id+'Paste';span.appendChild(button);break;case"outdent":var tooltip=this.getMessage('outdentTooltip');var button=this.createButton("outdent",tooltip,function(){self.execCommand("outdent",false,null);self.saveContentToField();self.focus();self.undo.saveUndo();self.updateToolbar();});button.id='zpEditor'+this.id+'Outdent';span.appendChild(button);break;case"indent":var tooltip=this.getMessage('indentTooltip');var button=this.createButton("indent",tooltip,function(){self.execCommand("indent",false,null);self.saveContentToField();self.focus();self.undo.saveUndo();self.updateToolbar();});button.id='zpEditor'+this.id+'Indent';span.appendChild(button);break;case"undo":var tooltip=this.getMessage('undoTooltip');var button=this.createButton("undo",tooltip,function(){self.undo.undo();self.saveContentToField();self.focus();self.updateToolbar();});button.id='zpEditor'+this.id+'Undo';span.appendChild(button);break;case"redo":var tooltip=this.getMessage('redoTooltip');var button=this.createButton("redo",tooltip,function(){self.undo.redo();self.saveContentToField();self.focus();self.updateToolbar();});button.id='zpEditor'+this.id+'Redo';span.appendChild(button);break;case"about":var tooltip=this.getMessage('aboutTooltip');var button=this.createButton("about",tooltip,null,function(){var aboutText=self.getMessage('aboutText');alert(aboutText);},"?");button.id='zpEditor'+this.id+'About';span.appendChild(button);break;case"fetch":var tooltip=this.getMessage('fetchTooltip');var button=this.createButton("fetch",tooltip,function(){self.undo.saveUndo();self.fetch();self.undo.saveUndo();self.updateToolbar();});button.id='zpEditor'+this.id+'Fetch';span.appendChild(button);break;case"save":var tooltip=this.getMessage('saveTooltip');var button=this.createButton("save",tooltip,function(){self.undo.saveUndo();self.save();self.updateToolbar();});button.id='zpEditor'+this.id+'Save';span.appendChild(button);break;case"browser":var tooltip=this.getMessage('browserTooltip');var button=this.createButton("browser",tooltip,null,function(){var attributes="status=1, width="+self.config.externalBrowserWidth+", height="+self.config.externalBrowserHeight+", resizable=yes";var win=window.open("","previewWindow",attributes);var html=self.getHTML();if(!self.config.fullPage){html='<html><body>'+html+'</body></html>';}
if(self.config.externalBrowserNoScript){html=html.replace(/<script[\s\S]+?<\/script>/gi,'');}
win.document.write(html);win.document.close();});button.id='zpEditor'+this.id+'Browser';span.appendChild(button);break;case"switcher":var tooltip=this.getMessage('htmlTooltip');var htmlButton=this.createButton("html",tooltip,null,function(){if(self.mode=="WYSIWYG"){self.switchToHTML();var button=this;setTimeout(function(){htmlButton.style.display='none';htmlButton.zpEditorWYSIWYGButton.style.display='block';},10);self.focusHtml();}});tooltip=this.getMessage('wysiwygTooltip');var wysiwygButton=this.createButton("wysiwyg",tooltip,null,function(){if(self.mode=="HTML"){self.switchToWYSIWYG();setTimeout(function(){wysiwygButton.style.display='none';wysiwygButton.zpEditorHTMLButton.style.display='block';},10);self.focus();}});htmlButton.id='zpEditor'+this.id+'Html';wysiwygButton.id='zpEditor'+this.id+'Wysiwyg';htmlButton.zpEditorWYSIWYGButton=wysiwygButton;wysiwygButton.zpEditorHTMLButton=htmlButton;wysiwygButton.style.display='none';htmlButton.className+=" switch";wysiwygButton.className+=" switch";span.appendChild(htmlButton);span.appendChild(wysiwygButton);break;case"newpanel":if(span.childNodes.length==0){continue;}
span=document.createElement("span");span.className="toolbarPanel"
td.appendChild(span);break;case"newrow":if(td.childNodes.length==1&&span.childNodes.length==0){continue;}
tr=document.createElement("tr");tbody.appendChild(tr);td=document.createElement("td");tr.appendChild(td);span=document.createElement("span");span.className="toolbarPanel";td.appendChild(span);break;default:Zapatec.Log({description:this.getMessage('unknownToolbarElementError',element)})}}}
Zapatec.MinimalEditor.prototype.createColorButton=function(isForeground){var colorButton=[];var self=this;var getter,setter,command,id,strClass,tooltip;if(isForeground){getter=function(){return self.config.foreColor;};setter=function(color){self.config.foreColor=color;};command="forecolor";strClass="forecolor";tooltip=this.getMessage('fontColorTooltip');id='zpEditor'+this.id+'ForeColor';}
else{getter=function(){return self.config.backColor;};setter=function(color){self.config.backColor=color;};if(Zapatec.is_ie||Zapatec.is_khtml){command="backcolor";}
else{command="hilitecolor";}
strClass="backcolor";tooltip=this.getMessage('bgColorTooltip');id='zpEditor'+this.id+'BackColor';}
var setColor=function(color){colorButton[0].colorDiv.style.background=color;setter(color);if(Zapatec.is_khtml){self.restoreSelection();}
self.execCommand(command,false,color);self.saveContentToField();self.focus();self.undo.saveUndo();self.updateToolbar();};colorButton[0]=this.createButton(strClass,tooltip,function(ev){if(Zapatec.is_khtml){self.storeSelection();}
var target=Zapatec.Utils.getTargetElement(ev);var isDropAction=target.isDropArrow;var color=getter();var isShowPicker=isDropAction||null==color||""==color;if(isShowPicker){return;}
setColor(color);},function(ev){var target=Zapatec.Utils.getTargetElement(ev);var isDropAction=target.isDropArrow;var color=getter();var isShowPicker=isDropAction||null==color||""==color;if(isShowPicker){var iColorPicker=isForeground?0:1;for(var i=0;i<=1;++i){var livePicker=self.colorPickers[i];if(livePicker&&livePicker.isShown){if(i==iColorPicker){return;}
livePicker.hide();}}
var show=function(){var colorPicker=new Zapatec.ColorPicker({button:colorButton[0],color:color,handleButtonClick:false,closeOnDocumentClick:false,eventListeners:{select:setColor}});colorPicker.show();self.colorPickers[iColorPicker]=colorPicker;};setTimeout(show,100);}},null,true,getter());colorButton[0].id=id;return colorButton[0];}
Zapatec.MinimalEditor.prototype.insertNodeAtSelection=function(insertNode){if(Zapatec.is_ie){var self=this;setTimeout(function(){var sel=self.pane.getContainer().contentWindow.document.selection;var range=sel.createRange();range.pasteHTML(insertNode.outerHTML);},10);}
else{if(Zapatec.is_khtml){var sel;if(this.oldSelection){sel=this.oldSelection;}
else{sel=this.pane.getContainer().contentWindow.getSelection();}
var range=this.pane.getContainer().contentWindow.document.createRange();var isRangeSet=false;if(sel.baseNode==sel.extentNode&&sel.baseOffset==sel.extentOffset){if(sel.type=="Range"){range.setStartBefore(sel.baseNode);range.setEndAfter(sel.extentNode);isRangeSet=true;}}
if(!isRangeSet){range.setStart(sel.baseNode,sel.baseOffset);range.setEnd(sel.extentNode,sel.extentOffset);}}
else{var sel=this.pane.getContainer().contentWindow.getSelection();var range=sel.getRangeAt(0);sel.removeAllRanges();}
range.deleteContents();var container=range.startContainer;var pos=range.startOffset;var doc=this.pane.getIframeDocument();range=doc.createRange();if(container.nodeType==3&&insertNode.nodeType==3){container.insertData(pos,insertNode.nodeValue);range.setEnd(container,pos+insertNode.length);range.setStart(container,pos+insertNode.length);}
else{var afterNode;if(container.nodeType==3){var textNode=container;container=textNode.parentNode;var text=textNode.nodeValue;var textBefore=text.substr(0,pos);var textAfter=text.substr(pos);var beforeNode=doc.createTextNode(textBefore);afterNode=doc.createTextNode(textAfter);container.insertBefore(afterNode,textNode);container.insertBefore(insertNode,afterNode);container.insertBefore(beforeNode,insertNode);container.removeChild(textNode);}
else{afterNode=container.childNodes[pos];container.insertBefore(insertNode,afterNode);if(!afterNode){range.setEnd(insertNode,1);range.setStart(insertNode,1);}}
if(afterNode){range.setEnd(afterNode,0);range.setStart(afterNode,0);}}
if(sel.addRange){sel.addRange(range);}}}
Zapatec.MinimalEditor.prototype.setHTML=function(html){if(this.mode=="WYSIWYG"){if(!this.pane.ready){var self=this;this.pane.addEventListener("onReady",function(){self.setHTML(html)},true);return;}
if(this.config.fullPage){this.setFullHTML(html);}
else{this.setBodyHTML(html);}
if(this.config.documentBodyMargin){this.pane.getIframeDocument().body.style.margin=this.config.documentBodyMargin;}
if(this.config.documentBodyPadding){this.pane.getIframeDocument().body.style.padding=this.config.documentBodyPadding;}}
else{var oTextarea=this.config.field;if(oTextarea.tagName.toLowerCase()=='textarea'){try{oTextarea.innerHTML=html;}catch(oException){};}
oTextarea.value=html;}}
Zapatec.MinimalEditor.prototype.getHTML=function(){var html;if(this.mode=="WYSIWYG"){if(this.config.fullPage){html=this.getFullHTML();}
else{html=this.getBodyHTML();}}
else{html=this.config.field.value;}
return html;}
Zapatec.MinimalEditor.prototype.setBodyHTML=function(html){if(!this.pane.isReady){var self=this;this.pane.addEventListener("onReady",function(){self.setBodyHTML(html)},true);return;}
html=this.massageHTML(html);this.pane.getIframeDocument().body.innerHTML=html;}
Zapatec.MinimalEditor.prototype.setFullHTML=function(html){html=this.massageHTML(html);var doctypeRegExp=/(<!doctype((.|\n|\r)*?)>)\n?/i;if(html.match(doctypeRegExp)){this.doctype=RegExp.$1;html=html.replace(doctypeRegExp,"");}
else{this.doctype="";}
var doc=this.pane.getIframeDocument();if(Zapatec.is_ie){doc.open();doc.write(html);doc.close();doc.body.contentEditable=true;this.installListeners();}
else{var headRegExp=/<head[^>]*>((.|\n|\r)*?)<\/head>/i;if(html.match(headRegExp)){var elHead=doc.getElementsByTagName("head")[0];if(Zapatec.is_khtml){}
else{elHead.innerHTML=RegExp.$1;}}
var bodyRegExp=/(<body[^>]*>)((.|\n|\r)*?)<\/body>/i;var res=html.match(bodyRegExp);var body=RegExp.$1;var inBodyHtml=RegExp.$2;if(res){this.setBodyHTML(inBodyHtml);}
else{this.setBodyHTML(html);return;}
body=body.replace(/>$/,"/>");Zapatec.Transport.parseXml({strXml:body,onLoad:function(oDoc){var htmlBody=oDoc.documentElement;var htmlBodyAttrs=htmlBody.attributes;for(var i=0;i<htmlBodyAttrs.length;++i){var attr=htmlBodyAttrs.item(i);if(!attr.specified){continue;}
var name=attr.nodeName;var value=attr.nodeValue;doc.body.setAttribute(name,value);}
var docBodyAttrs=doc.body.attributes;for(var i=0;i<docBodyAttrs.length;++i){var attr=docBodyAttrs.item(i);if(!attr.specified){continue;}
var name=attr.nodeName;var value=attr.nodeValue;if(!htmlBody.getAttribute(name)){doc.body.removeAttribute(name);}}}});}
this.isDefaultFullHtml=false;}
Zapatec.MinimalEditor.prototype.getFullHTML=function(){var html="";if(""!=this.doctype){html+=this.doctype+"\n";}
var root=this.pane.getIframeDocument().documentElement;if(this.config.dumpHtml){html+=dump.getHTML(root,true,0);}
else{html+=root.innerHTML;if(Zapatec.is_opera){var bodyExp=/<\/body>/i;if(!html.match(bodyExp)){html+="</BODY>";}}
if(Zapatec.is_ie){var contentEditableExp=/(<body[^>]*)( contentEditable=true)([^>]*>)/gi;html=html.replace(contentEditableExp,"$1$3");}
html="<html>"+html+"</html>";}
if(this.isDefaultFullHtml||Zapatec.is_khtml){var headRegExp=/<head[^>]*>((.|\n|\r)*?)<\/head>/i;html=html.replace(headRegExp,"<head></head>");}
if(this.isDefaultFullHtml){var onLoadRegExp=/(<body[^>]*)( onload=\"?init\(\);\"?)([^>]*>)/gi;html=html.replace(onLoadRegExp,"$1$3");}
html=this.unmassageHTML(html);return html;}
Zapatec.MinimalEditor.prototype.getBodyHTML=function(){var html;if(this.config.dumpHtml){html=dump.getHTML(this.pane.getIframeDocument().body,false,0);}
else{html=this.pane.getContentElement().innerHTML;}
html=this.unmassageHTML(html);return html;}
Zapatec.MinimalEditor.prototype.unmassageHTML=function(html){if(this.config.preserveImgSrc){html=html.replace(/(<img[^>]+)(src=("|')[^"']*\3)([^>]*)(_zpSrc=("|')([^"']*)\6)([^>]*>)/gi,"$1src=$3$7$3$4$8");html=html.replace(/(<img[^>]+)(_zpSrc=("|')([^"']*)\3)([^>]*)(src=("|')[^"']*\7)([^>]*>)/gi,"$1src=$3$4$3$5$8");}
if(this.config.preserveAnchorHref){html=html.replace(/(<a[^>]+)(href=("|')[^"']*\3)([^>]*)(_zpHref=("|')([^"']*)\6)([^>]*>)/gi,"$1href=$3$7$3$4$8");html=html.replace(/(<a[^>]+)(_zpHref=("|')([^"']*)\3)([^>]*)(href=("|')[^"']*\7)([^>]*>)/gi,"$1href=$3$4$3$5$8");}
if(this.config.generateXhtml){html=html2Xhtml.convert(html);}
return html;}
Zapatec.MinimalEditor.prototype.massageHTML=function(html){if(this.config.preserveImgSrc){html=html.replace(/(<img[^>]+)(src=("|')([^"']*)\3)([^>]*>)/gi,"$1$2 _zpSrc=$3$4$3 $5");}
if(this.config.preserveAnchorHref){html=html.replace(/(<a[^>]+)(href=("|')([^"']*)\3)([^>]*>)/gi,"$1$2 _zpHref=$3$4$3 $5");}
return html;}
Zapatec.MinimalEditor.prototype.switchToHTML=function(){if(this.mode!="WYSIWYG"){return false;}
var html=this.getHTML();this.mode="HTML";this.toggleButtons(false);this.setHTML(html);this.config.field.style.display='';if(Zapatec.is_khtml){this.pane.getContainer().style.visibility="hidden";this.pane.getContainer().hiddenHeight=this.pane.getContainer().style.height;this.pane.getContainer().style.height="0";}
else{this.pane.getContainer().style.display="none";}}
Zapatec.MinimalEditor.prototype.switchToWYSIWYG=function(){if(this.mode!="HTML"){return false;}
var html=this.getHTML();this.mode="WYSIWYG";this.toggleButtons(true);this.setHTML(html);this.config.field.style.display="none";if(Zapatec.is_khtml){this.pane.getContainer().style.visibility="";this.pane.getContainer().style.height=this.pane.getContainer().hiddenHeight;}
else{this.pane.getContainer().style.display="block";}}
Zapatec.MinimalEditor.prototype.createButton=function(buttonClass,tooltip,downAction,clickAction,text,isDropDown,color){if(null==text){text="";}
var params={theme:this.config.theme,themePath:this.config.themePath,text:text,className:"zpEditorButton "+buttonClass,repeatEnabled:false};if(isDropDown){var img=Zapatec.zapatecPath+"../zpeditor/themes/"+this.config.theme+'/dropdown.gif';params.image=img;}
if(downAction){params.downAction=downAction;}
if(clickAction){params.clickAction=clickAction;}
var button=new Zapatec.Button(params);this.createProperty(button.getContainer(),"button",button);if(isDropDown){button.img.isDropArrow=true;var colorDiv=document.createElement("img");Zapatec.Utils.addClass(colorDiv,this.getClassName({prefix:"zpEditor",suffix:"ColorMark"}));button.internalContainer.insertBefore(colorDiv,button.img);this.createProperty(button.getContainer(),"colorDiv",colorDiv);if(color){colorDiv.background=color;}
Zapatec.Utils.addClass(button.getContainer(),this.getClassName({prefix:"zpButton",suffix:"Container"}));Zapatec.Utils.removeClass(button.getContainer(),this.getClassName({prefix:"zpButtonImage",suffix:"Container"}));Zapatec.Utils.addClass(button.img,this.getClassName({prefix:"zpEditor",suffix:"DropDown"}));}
if(tooltip&&this.config.enableTooltips){var div=document.createElement("div");div.innerHTML=tooltip;var objTooltip=new Zapatec.Tooltip({target:button.container,tooltip:div,parent:this.container});this.tooltips.push(objTooltip);}
this.buttons.push(button);return button.getContainer();}
Zapatec.MinimalEditor.prototype.createSelect=function(options,values,func){if(options.length!=values.length){Zapatec.Log({description:this.getMessage('optionsNotEqualValuesError')});return null;}
var select=document.createElement("select");select.tabindex=0;select.className="zpEditorSelect";for(var ii=0;ii<options.length;ii++){select.options[ii]=new Option(options[ii],values[ii])}
select.onchange=func;return select;}
Zapatec.MinimalEditor.prototype.toggleButtons=function(enable){for(var ii=0;ii<this.buttons.length;ii++){var button=this.buttons[ii];var className=button.getContainer().className;if(/switch/.test(className)){continue;}
if(enable){button.enable();}
else{button.disable();}}}
Zapatec.MinimalEditor.prototype.getButton=function(id){for(var ii=0;ii<this.buttons.length;ii++){var button=this.buttons[ii];var currentId=button.getContainer().id;if(currentId==id){return button;}}
return null;}
Zapatec.MinimalEditor.prototype.onEnterPressed=function(){if(!Zapatec.is_ie){return false;}
var iframeDocument=this.pane.getIframeDocument();if(typeof iframeDocument.selection!='undefined'){var selection=iframeDocument.selection;if(selection.type.toLowerCase()=='control'){selection.clear();}
var range=selection.createRange();if(iframeDocument.queryCommandState('InsertOrderedList')||iframeDocument.queryCommandState('InsertUnorderedList')){return false;}
range.pasteHTML('<br>');range.collapse(false);range.select();return true;}
return false;}
Zapatec.MinimalEditor.prototype.resizeEditor=function(){var isMaximize;if(!this.maximizer){this.maximizer=new Zapatec.Utils.Maximizable({container:this.container,maximizedBorder:this.config.maximizedBorder});var self=this;this.maximizer.addEventListener('onBeforeMaximize',function(restoreState){restoreState.editorPanelRestorer=new Zapatec.SRProp(self.editorPanel);restoreState.editorPanelRestorer.saveProps("style.width","style.height");restoreState.paneRestorer=new Zapatec.SRProp(self.pane.getContainer());restoreState.paneRestorer.saveProps("style.width","style.height");restoreState.fieldRestorer=new Zapatec.SRProp(self.config.field);restoreState.fieldRestorer.saveProps("style.width","style.height");restoreState.toolbarRestorer=new Zapatec.SRProp(self.toolbar);restoreState.toolbarRestorer.saveProps("style.width");});this.maximizer.addEventListener('onAfterRestore',function(restoreState){restoreState.editorPanelRestorer.restoreProps("style.width","style.height");restoreState.paneRestorer.restoreProps("style.width","style.height");restoreState.fieldRestorer.restoreProps("style.width","style.height");restoreState.toolbarRestorer.restoreProps("style.width");});this.maximizer.addEventListener('onAfterSize',function(width,height){self.setSize(width,height);});isMaximize=true;}
else{isMaximize=!this.maximizer.isMaximized;}
this.maximizer.setMaximized(isMaximize);for(var ii=0;ii<this.buttons.length;ii++){var button=this.buttons[ii];var buttonClass=button.config.className;if(-1!=buttonClass.indexOf('maximize')){if(isMaximize){Zapatec.Utils.removeClass(button.internalContainer,'maximize');Zapatec.Utils.addClass(button.internalContainer,'restore');}
else{Zapatec.Utils.removeClass(button.internalContainer,'restore');Zapatec.Utils.addClass(button.internalContainer,'maximize');}
break;}}}
Zapatec.MinimalEditor.prototype.getPersistKey=function(){if(null!=this.config.persistKey){return this.config.persistKey;}
var persistKeyInput=document.getElementById("persistKey");if(null!=persistKeyInput){return persistKeyInput.value;}
return null;}
Zapatec.MinimalEditor.prototype.setPersistKey=function(persistKey){this.config.persistKey=persistKey;}
Zapatec.MinimalEditor.prototype.save=function(){var key=this.getPersistKey();if(null==key||0==key.length){return false;}
var url=this.config.persistPath+"?key="+escape(key)+'&r='+Math.random();var self=this;Zapatec.Transport.fetch({url:url,method:"POST",content:"content="+escape(self.getHTML()),onLoad:function(result){},onError:function(error){switch(error.errorCode){case 404:alert(self.getMessage('noSuchFileError'));break;case 403:alert(self.getMessage('writeAccessForbiddenError'));break;default:alert(self.getMessage('fetchError',error.errorCode,error.errorDescription));}}});return true;};Zapatec.MinimalEditor.prototype.fetch=function(){var key=this.getPersistKey();if(null==key||0==key.length){return false;}
var url=this.config.persistPath+"?key="+escape(key)+'&r='+Math.random();var self=this;Zapatec.Transport.fetch({url:url,method:"GET",onLoad:function(result){var html=self.unicodeToText(result.responseText);self.setHTML(html);},onError:function(error){switch(error.errorCode){case 404:alert(self.getMessage('noSuchFileError'));break;case 403:alert(self.getMessage('readAccessForbiddenError'));break;default:alert(self.getMessage('fetchError',error.errorCode,error.errorDescription));}}});return true;};Zapatec.MinimalEditor.prototype.unicodeToText=function(escapedUnicodeText){if(-1==escapedUnicodeText.indexOf("%u")){return escapedUnicodeText;}
escapedUnicodeText=escapedUnicodeText.replace(/%u/g,"\\u");if(-1!=escapedUnicodeText.indexOf("\"")){escapedUnicodeText=escapedUnicodeText.replace(/\"/g,"&quot;");}
var text=eval("\""+escapedUnicodeText+"\"");return text;}
Zapatec.MinimalEditor.prototype.showCharMapWindow=function(){if(this.characterMapWindow){return;}
var characters=['&Yuml;','&scaron;','&#064;','&quot;','&iexcl;','&cent;','&pound;','&curren;','&yen;','&brvbar;','&sect;','&uml;','&copy;','&ordf;','&laquo;','&not;','&macr;','&deg;','&plusmn;','&sup2;','&sup3;','&acute;','&micro;','&para;','&middot;','&cedil;','&sup1;','&ordm;','&raquo;','&frac14;','&frac12;','&frac34;','&iquest;','&times;','&Oslash;','&divide;','&oslash;','&fnof;','&circ;','&tilde;','&ndash;','&mdash;','&lsquo;','&rsquo;','&sbquo;','&ldquo;','&rdquo;','&bdquo;','&dagger;','&Dagger;','&bull;','&hellip;','&permil;','&lsaquo;','&rsaquo;','&euro;','&trade;','&Agrave;','&Aacute;','&Acirc;','&Atilde;','&Auml;','&Aring;','&AElig;','&Ccedil;','&Egrave;','&Eacute;','&Ecirc;','&Euml;','&Igrave;','&Iacute;','&Icirc;','&Iuml;','&ETH;','&Ntilde;','&Ograve;','&Oacute;','&Ocirc;','&Otilde;','&Ouml;','&reg;','&times;','&Ugrave;','&Uacute;','&Ucirc;','&Uuml;','&Yacute;','&THORN;','&szlig;','&agrave;','&aacute;','&acirc;','&atilde;','&auml;','&aring;','&aelig;','&ccedil;','&egrave;','&eacute;','&ecirc;','&euml;','&igrave;','&iacute;','&icirc;','&iuml;','&eth;','&ntilde;','&ograve;','&oacute;','&ocirc;','&otilde;','&ouml;','&divide;','&oslash;','&ugrave;','&uacute;','&ucirc;','&uuml;','&yacute;','&thorn;','&yuml;','&OElig;','&oelig;','&Scaron;'];var html='<table class="charmap" border="0" cellspacing="1" cellpadding="0" width="100%">';for(var charIndex=0;charIndex<characters.length;++charIndex){var charStr=characters[charIndex];if(charIndex%16==0){if(0!=charIndex){html+='</tr>';}
html+='<tr>';}
html+='<td class="character" onmouseover="';html+='Zapatec.MinimalEditor.OnMouseOverChar('+this.id+', this)" ';html+='onclick="return Zapatec.MinimalEditor.InsertChar('+this.id+', \''+
charStr+'\')">'+charStr+'</td>';}
html+='<td class="character" colspan="4">&nbsp;</td>';html+='</tr>';html+='</table>';var oWin=this.config.win;if(oWin){oWin.open({headline:zapatecTranslate(this.getMessage('characterMapTitle')),source:html});}else{var self=this;var onClose=function(win){self.characterMapWindow=null;self.setIsModal(false);}
var title=this.getMessage('characterMapTitle');this.characterMapWindow=this.createWindow(420,245,title,html,onClose);}}
Zapatec.MinimalEditor.OnMouseOverChar=function(id,cell){var objEditor=Zapatec.Widget.getWidgetById(id);if(objEditor.oldHiliteCell){objEditor.oldHiliteCell.className="character";}
var cellClass=cell.className;if(-1==cellClass.indexOf("character-hilite")){cell.className="character character-hilite";objEditor.oldHiliteCell=cell;}}
Zapatec.MinimalEditor.prototype.insertText=function(text){if(Zapatec.is_ie){var range=this.oldSelectionRange;if(!range){var sel=this.pane.getContainer().contentWindow.document.selection;range=sel.createRange();}
var self=this;setTimeout(function(){range.pasteHTML(text);range.select();self.undo.saveUndo();self.updateToolbar();},500);}
else{if(Zapatec.is_khtml){this.restoreSelection();}
var charElement=this.pane.getIframeDocument().createTextNode(text);this.insertNodeAtSelection(charElement);this.focus();this.undo.saveUndo();this.updateToolbar();}}
Zapatec.MinimalEditor.InsertChar=function(id,character){var objEditor=Zapatec.Widget.getWidgetById(id);var oWin=objEditor.config.win;if(oWin){oWin.hide();}else{objEditor.characterMapWindow.close();}
objEditor.insertText(character);objEditor.saveContentToField();}
Zapatec.MinimalEditor.prototype.storeSelection=function(){var sel=this.pane.getContainer().contentWindow.getSelection();var range=this.pane.getContainer().contentWindow.document.createRange();var isRangeSet=false;if(sel.baseNode==sel.extentNode&&sel.baseOffset==sel.extentOffset){if(sel.type=="Range"){range.setStartBefore(sel.baseNode);range.setEndAfter(sel.extentNode);isRangeSet=true;}}
if(!isRangeSet&&sel.baseNode){range.setStart(sel.baseNode,sel.baseOffset);range.setEnd(sel.extentNode,sel.extentOffset);}
this.oldSelection=sel;this.oldRange=range;}
Zapatec.MinimalEditor.prototype.restoreSelection=function(){var sel=this.oldSelection;var newSelection=this.pane.getContainer().contentWindow.getSelection();newSelection.setBaseAndExtent(this.oldRange.startContainer,this.oldRange.startOffset,this.oldRange.endContainer,this.oldRange.endOffset);}
Zapatec.MinimalEditor.prototype.isSelectionExists=function(){var range=null;var sel=null;if(Zapatec.is_ie){sel=this.pane.getContainer().contentWindow.document.selection;range=sel.createRange();}
else{sel=this.pane.getContainer().contentWindow.getSelection();if(!Zapatec.is_khtml){range=sel.getRangeAt(0);}}
var compare=0;if(Zapatec.is_ie)
{if(sel.type=="Control")
{compare=range.length;}
else
{compare=range.compareEndPoints("StartToEnd",range);}}
else{if(Zapatec.is_khtml){var selectionType=''+sel.type;if(selectionType=="Range"){return true;}
if(selectionType=="Caret"){return false;}}
else{compare=range.compareBoundaryPoints(range.START_TO_END,range);}}
if(compare===0)
{return false;}
return true;}
Zapatec.MinimalEditor.prototype.getSelectionText=function(){var range=null;var sel=null;if(Zapatec.is_ie){sel=this.pane.getContainer().contentWindow.document.selection;range=sel.createRange();return range.text;}
else{sel=this.pane.getContainer().contentWindow.getSelection();return sel;}}
Zapatec.MinimalEditor.prototype.getSelectionParent=function(){var result=null;var range=null;var sel=null;if(Zapatec.is_ie){sel=this.pane.getContainer().contentWindow.document.selection;range=sel.createRange();if(sel.type=="Control"){result=range(0);}
else{result=range.parentElement();}}
else{sel=this.pane.getContainer().contentWindow.getSelection();if(sel&&sel.rangeCount>0){range=sel.getRangeAt(0);var container=range.commonAncestorContainer;result=container;if(container.nodeType==3){result=container.parentNode;}
else if(range.startContainer.nodeType==1&&range.startContainer==range.endContainer&&(range.endOffset-range.startOffset)<=1)
{result=range.startContainer.childNodes[range.startOffset];}}
else{result=this.pane.getIframeDocument().body;}}
return result;}
Zapatec.MinimalEditor.prototype.getHtmlFromBeginToCaret=function(){var result=null;var range=null;var sel=null;if(Zapatec.is_ie){sel=this.pane.getContainer().contentWindow.document.selection;range=sel.createRange();range.moveStart('textedit',-1);result=range.htmlText;}
else{sel=this.pane.getContainer().contentWindow.getSelection();if(sel&&sel.rangeCount>0){range=sel.getRangeAt(0);var newRange=range.cloneRange();var body=this.pane.getIframeDocument().body;newRange.setStart(body,0);var clonedSelection=newRange.cloneContents();var div=document.createElement('div');div.appendChild(clonedSelection);result=div.innerHTML;}
else{result=this.pane.getIframeDocument().body;}}
return result;}
Zapatec.MinimalEditor.prototype.getHtmlFromCaretToEnd=function(){var result=null;var range=null;var sel=null;if(Zapatec.is_ie){sel=this.pane.getContainer().contentWindow.document.selection;range=sel.createRange();range.moveEnd('textedit');result=range.htmlText;}
else{sel=this.pane.getContainer().contentWindow.getSelection();if(sel&&sel.rangeCount>0){range=sel.getRangeAt(0);var newRange=range.cloneRange();var body=this.pane.getIframeDocument().body;newRange.setEnd(body,body.childNodes.length);var clonedSelection=newRange.cloneContents();var div=document.createElement('div');div.appendChild(clonedSelection);result=div.innerHTML;}
else{result=this.pane.getIframeDocument().body;}}
return result;}
Zapatec.MinimalEditor.prototype.getDocumentSize=function(){var iframeDoc=this.pane.getIframeDocument();var size={};if(Zapatec.is_ie){size.width=iframeDoc.body.scrollWidth;size.height=iframeDoc.body.scrollHeight;}
else{size.width=iframeDoc.body.parentNode.clientWidth;size.height=iframeDoc.body.parentNode.clientHeight;}
return size;}
Zapatec.MinimalEditor.prototype.getSelectedElementByTagName=function(tagName){var selParent=this.getSelectionParent();tagName=tagName.toLowerCase();while(selParent){var tag=selParent.tagName;if(tag){tag=tag.toLowerCase();}
if(tagName==tag||tag=='body'){break;}
selParent=selParent.parentNode;}
return selParent;}
Zapatec.MinimalEditor.prototype.deleteSelection=function(){var range=null;var sel=null;if(Zapatec.is_ie){var iframeDocument=this.pane.getIframeDocument();if(typeof iframeDocument.selection!='undefined'){var selection=iframeDocument.selection;if(selection.type.toLowerCase()=='control'){selection.clear();}}}
else{sel=this.pane.getContainer().contentWindow.getSelection();sel.deleteFromDocument();}}
Zapatec.MinimalEditor.prototype.updateToolbarSelect=function(select,value){value=value.toLowerCase();var isSelected=false;var optionCount=select.options.length;for(var i=0;i<optionCount;++i){var currentValue=select.options[i].value;if(currentValue.toLowerCase()==value){select.selectedIndex=i;isSelected=true;break;}}
if(!isSelected){select.selectedIndex=0;}}
Zapatec.MinimalEditor.prototype.updateToolbar=function(){var fontNameSelect=document.getElementById('zpEditor'+this.id+'FontName');if(fontNameSelect){var fontName=''+this.queryCommandValue('fontname');this.updateToolbarSelect(fontNameSelect,fontName);}
var fontSizeSelect=document.getElementById('zpEditor'+this.id+'FontSize');if(fontSizeSelect){var fontSize=''+this.queryCommandValue('fontsize');this.updateToolbarSelect(fontSizeSelect,fontSize);}
var boldButton=this.getButton('zpEditor'+this.id+'Bold');if(boldButton){var boldState=this.queryCommandState('bold');boldButton.setPressed(boldState);}
var italicButton=this.getButton('zpEditor'+this.id+'Italic');if(italicButton){var italicState=this.queryCommandState('italic');italicButton.setPressed(italicState);}
var underlineButton=this.getButton('zpEditor'+this.id+'Underline');if(underlineButton){var underlineState=this.queryCommandState('underline');underlineButton.setPressed(underlineState);}
var justifyLeftButton=this.getButton('zpEditor'+this.id+'JustifyLeft');if(justifyLeftButton){var justifyLeftState=this.queryCommandState('justifyleft');justifyLeftButton.setPressed(justifyLeftState);}
var justifyCenterButton=this.getButton('zpEditor'+this.id+'JustifyCenter');if(justifyCenterButton){var justifyCenterState=this.queryCommandState('justifycenter');justifyCenterButton.setPressed(justifyCenterState);}
var justifyRightButton=this.getButton('zpEditor'+this.id+'JustifyRight');if(justifyRightButton){var justifyRightState=this.queryCommandState('justifyright');justifyRightButton.setPressed(justifyRightState);}
var justifyFullButton=this.getButton('zpEditor'+this.id+'JustifyFull');if(justifyFullButton){var justifyFullState=this.queryCommandState('justifyfull');justifyFullButton.setPressed(justifyFullState);}
var undoButton=this.getButton('zpEditor'+this.id+'Undo');if(undoButton){var undoState=this.undo.checkUndoState();if(undoState){undoButton.enable();}
else{undoButton.disable();}}
var redoButton=this.getButton('zpEditor'+this.id+'Redo');if(redoButton){var redoState=this.undo.checkRedoState();if(redoState){redoButton.enable();}
else{redoButton.disable();}}}
Zapatec.MinimalEditor.prototype.invokeUpdateToolbar=function(){var self=this;setTimeout(function(){self.updateToolbar();},250);}
Zapatec.MinimalEditor.Undo=function(editor){this.editor=editor;this.undoStack=new Array();this.undoStackIndex=-1;this.typesCount=this.editor.config.maxUndoTypes;this.isTyping=false;this.lastTypeTime=-1;}
Zapatec.MinimalEditor.Undo.prototype.saveUndo=function(){if(!this.editor.config.customUndo){return;}
var html=this.editor.pane.getContentElement().innerHTML;if(0<=this.undoStackIndex&&html==this.undoStack[this.undoStackIndex][0]){return;}
this.undoStack=this.undoStack.slice(0,this.undoStackIndex+1);if(this.undoStackIndex+1>=this.editor.config.maxUndoLevels){this.undoStack.shift();}
else{++this.undoStackIndex;}
var bookmark=null;if(Zapatec.is_ie){var sel=this.editor.pane.getContainer().contentWindow.document.selection;var range=sel.createRange();try{bookmark=range.getBookmark();}
catch(e){}}
this.undoStack[this.undoStackIndex]=[html,bookmark];}
Zapatec.MinimalEditor.Undo.prototype.onKeyDown=function(){if(!this.editor.config.customUndo){return;}
var now=(new Date()).getTime();this.lastTypeTime=now;this.processKeyDown();}
Zapatec.MinimalEditor.Undo.prototype.processKeyDown=function(){if(this.isProcessPending){return;}
var now=(new Date()).getTime();var timeSinceLastType=now-this.lastTypeTime;if(timeSinceLastType<2000){var self=this;if(!self.isProcessPending){self.isProcessPending=true;setTimeout(function(){self.isProcessPending=false;self.processKeyDown();},200);}
return;}
if(!this.isTyping||2000<=timeSinceLastType){this.saveUndo();this.isTyping=true;}
++this.typesCount;if(this.typesCount>this.editor.config.maxUndoTypes){this.typesCount=0;this.saveUndo();}}
Zapatec.MinimalEditor.Undo.prototype.checkUndoState=function(){if(this.editor.config.customUndo){return(this.isTyping||this.undoStackIndex>0);}
else{return this.editor.queryCommandEnabled('Undo');}}
Zapatec.MinimalEditor.Undo.prototype.checkRedoState=function(){if(this.editor.config.customUndo){return(!this.isTyping&&this.undoStackIndex<(this.undoStack.length-1));}
else{return this.editor.queryCommandEnabled('Redo');}}
Zapatec.MinimalEditor.Undo.prototype.undo=function(){if(this.editor.config.customUndo){if(this.checkUndoState()){if(this.undoStackIndex==(this.undoStack.length-1)){this.saveUndo();}
this.restoreUndo(--this.undoStackIndex);}}
else{this.editor.execCommand("undo",false,null);}}
Zapatec.MinimalEditor.Undo.prototype.redo=function(){if(this.editor.config.customUndo){if(this.checkRedoState()){this.restoreUndo(++this.undoStackIndex);}}
else{this.editor.execCommand("redo",false,null);}}
Zapatec.MinimalEditor.Undo.prototype.restoreUndo=function(undoIndex){var pair=this.undoStack[undoIndex];if(!pair){return;}
this.editor.setHTML(pair[0]);if(pair[1]){if(Zapatec.is_ie){var range=this.editor.pane.getIframeDocument().selection.createRange();range.moveToBookmark(pair[1]);range.select();}}
this.typesCount=0;this.isTyping=false;}
Zapatec.MinimalEditor.prototype.showInsertLinkWindow=function(){if(this.insertLinkWindow){return;}
var text="";var url="http://";var isSelection=this.isSelectionExists();if(!isSelection){}
else{text=this.getSelectionText();}
if(Zapatec.is_khtml){this.storeSelection();}
else if(Zapatec.is_ie){this.oldSelection=this.pane.getContainer().contentWindow.document.selection;this.oldRange=this.oldSelection.createRange();this.oldBookmark=this.oldRange.getBookmark();}
else if(Zapatec.is_opera){this.oldSelection=this.pane.getContainer().contentWindow.getSelection();this.oldRange=this.oldSelection.getRangeAt(0);}
var selAnchor=this.getSelectedElementByTagName('a');if(selAnchor&&selAnchor.tagName&&selAnchor.tagName.toLowerCase()=='a'){text=selAnchor.innerHTML;url=null;if(this.config.preserveAnchorHref){url=selAnchor.getAttribute('_zpHref');}
if(null==url){url=selAnchor.getAttribute('href');}
this.insertLinkAnchor=selAnchor;}
var linkLabelClass=this.getClassName({prefix:"zpEditor",suffix:"LinkLabel"});var linkInputClass=this.getClassName({prefix:"zpEditor",suffix:"LinkInput"});var buttonPaneClass=this.getClassName({prefix:"zpEditor",suffix:"LinkButtonPane"});var inputPaneClass=this.getClassName({prefix:"zpEditor",suffix:"LinkInputPane"});var okClass=this.getClassName({prefix:"zpEditor",suffix:"LinkOk"});var textId="zpInsertLink"+this.id+"Text";var urlId="zpInsertLink"+this.id+"Url";var linkTextLabel=this.getMessage('insertLinkTextLabel');var html='<div class="'+inputPaneClass+'">';html+='<span class="'+linkLabelClass+'">'+linkTextLabel+'</span>';html+='<input class="'+linkInputClass+'" type="text" id="'+textId+'" value="'+text+'" originalValue="'+text+'" />';html+='<br />';var linkAddressLabel=this.getMessage('insertLinkAddressLabel');html+='<span class="'+linkLabelClass+'">'+linkAddressLabel+'</span>';html+='<input class="'+linkInputClass+'" type="text" id="'+urlId+'" value="'+url+'" />';html+='</div>';var oWin=this.config.win;if(oWin){html+='<div class="'+buttonPaneClass+'">';html+='<input class="'+okClass+'" type="button" value="OK"';html+='onclick="return Zapatec.MinimalEditor.InsertLink(\''+this.id+'\', \''+textId+'\', \''+urlId+'\')" />';html+='<input type="button" value="'+zapatecTranslate('Cancel')+'"';html+=' onclick="zapatecWidgetCallMethod('+this.id+',\'hideWin\')"/>';html+='</div>';oWin.open({headline:zapatecTranslate(this.getMessage('insertLinkTitle')),source:html});}else{html+='<div class="'+buttonPaneClass+'">';html+='<input class="'+okClass+'" type="button" value="OK"';html+='onclick="return Zapatec.MinimalEditor.InsertLink(\''+this.id+'\', \''+textId+'\', \''+urlId+'\')" />';html+='<input type="button" value="Cancel"';html+=' onclick="return Zapatec.MinimalEditor.HideInsertLink(\''+this.id+'\')"/>';html+='</div>';var self=this;var onClose=function(win){self.insertLinkWindow=null;self.setIsModal(false);}
var title=this.getMessage('insertLinkTitle');this.insertLinkWindow=this.createWindow(320,130,title,html,onClose);}}
Zapatec.MinimalEditor.prototype.hideWin=function(){var oWin=this.config.win;if(oWin){oWin.hide();}};Zapatec.MinimalEditor.InsertLink=function(id,textId,urlId){var objEditor=Zapatec.Widget.getWidgetById(id);var elText=document.getElementById(textId);var originalText=elText.getAttribute("originalValue");var text=elText.value;var elUrl=document.getElementById(urlId);var url=elUrl.value;var oWin=objEditor.config.win;if(oWin){oWin.hide();}else{objEditor.insertLinkWindow.close();}
if(objEditor.insertLinkAnchor){objEditor.insertLinkAnchor.setAttribute('href',url);if(objEditor.config.preserveAnchorHref){objEditor.insertLinkAnchor.setAttribute('_zpHref',url);}
objEditor.insertLinkAnchor.innerHTML=text;objEditor.insertLinkAnchor=null;return;}
var beginNode=null;var beginOffset=null;var range=null;var sel=null;if(Zapatec.is_ie){sel=objEditor.oldSelection;range=objEditor.oldRange;}
else if(Zapatec.is_opera){sel=objEditor.oldSelection;sel=objEditor.pane.getContainer().contentWindow.getSelection();sel.addRange(objEditor.oldRange);}
else{sel=objEditor.pane.getContainer().contentWindow.getSelection();}
beginNode=sel.anchorNode;beginOffset=sel.anchorOffset;if(originalText!=text){if(!Zapatec.is_opera){objEditor.focus();}
var charEl=objEditor.insertText(text);if(Zapatec.is_ie){var completeFunc=function(){sel=objEditor.pane.getContainer().contentWindow.document.selection;var newRange=sel.createRange();newRange.findText(text,-text.length,0);newRange.select();objEditor.createLink(url);}
setTimeout(completeFunc,50);return;}
else{sel=objEditor.pane.getContainer().contentWindow.getSelection();var doc=objEditor.pane.getIframeDocument();var endNode=sel.anchorNode;var endOffset=sel.anchorOffset;range=doc.createRange();range.setStart(beginNode,beginOffset);range.setEnd(endNode,endOffset);sel.addRange(range);}}
else{if(Zapatec.is_ie){range.select();}}
objEditor.createLink(url);}
Zapatec.MinimalEditor.prototype.createLink=function(url){if(url==null||url==""){return;}
if(Zapatec.is_khtml){this.restoreSelection();}
this.execCommand("createlink",false,url);if(this.config.linksTarget&&object.links){if(Zapatec.is_ie){object=this.pane.getIframeDocument();}else{object=this.pane.getContainer().contentWindow.document;}
for(var iLink=0;iLink<object.links.length;iLink++){if(!object.links[iLink].getAttribute("target")){object.links[iLink].setAttribute("target",this.config.linksTarget);}}}
this.saveContentToField();this.focus();this.undo.saveUndo();this.updateToolbar();}
Zapatec.MinimalEditor.HideInsertLink=function(id){var objEditor=Zapatec.Widget.getWidgetById(id);objEditor.insertLinkWindow.close();}
Zapatec.MinimalEditor.prototype.createWindow=function(width,height,title,html,onClose){var oOffset=Zapatec.Utils.getElementOffset(this.container);var top=oOffset.y-100;var pageScrollY=Zapatec.Utils.getPageScrollY();if(0<pageScrollY){top-=pageScrollY;}
if(top<0){top=0;if(this.isMaximize){top+=this.config.maximizedBorder;}}
this.setIsModal(true);return Zapatec.Window.setup({left:oOffset.x+100,top:top,width:width,height:height,raiseOnlyOnTitle:false,showStatus:false,canResize:false,showMaxButton:false,showMinButton:false,theme:'winxp',content:html,title:title,onClose:onClose});}
Zapatec.MinimalEditor.prototype.fillWebKitMap=function(){this.webKitMap=[];this.webKitMap['fontname']=420;this.webKitMap['fontsize']=420;this.webKitMap['bold']=312;this.webKitMap['italic']=312;this.webKitMap['underline']=312;this.webKitMap['justifyleft']=312;this.webKitMap['justifycenter']=312;this.webKitMap['justifyright']=312;this.webKitMap['justifyfull']=420;this.webKitMap['inserthorizontalrule']=420;this.webKitMap['insertorderedlist']=420;this.webKitMap['insertunorderedlist']=420;this.webKitMap['indent']=420;this.webKitMap['outdent']=420;this.webKitMap['forecolor']=312;this.webKitMap['backcolor']=312;this.webKitMap['insertlink']=420;this.webKitMap['insertimage']=420;this.webKitMap['cut']=312;this.webKitMap['copy']=312;this.webKitMap['paste']=1000;this.webKitMap['undo']=312;this.webKitMap['redo']=312;}
Zapatec.MinimalEditor.prototype.setIsModal=function(isModal){if(!this.modal){this.modal=new Zapatec.Modal({themePath:Zapatec.zapatecPath+"../zpextra/themes/indicator/",container:this.container});this.modal.create();}
if(isModal){this.modal.show(2);}
else{this.modal.hide();}}
Zapatec.MinimalEditor.prototype.receiveData=function(oArg){Zapatec.MinimalEditor.SUPERclass.receiveData.call(this,oArg);if(!oArg.data){return;}
this.setHTML(oArg.data);}
Zapatec.MinimalEditor.prototype.replyData=function(){return this.getHTML();};Zapatec.MinimalEditor.prototype.discard=function(){var oContainer=this.container;if(oContainer&&oContainer.parentNode){var oTextarea=this.config.field;if(oTextarea){oContainer.parentNode.replaceChild(oTextarea,oContainer);var oTextareaStyle=oTextarea.style;var oOrigTextareaStyle=this.textareaStyle;for(var sProp in oOrigTextareaStyle){oTextareaStyle[sProp]=oOrigTextareaStyle[sProp];}}else{oContainer.parentNode.removeChild(oContainer);}}
for(var ii=0;ii<this.tooltips.length;ii++){this.tooltips[ii].discard();}
for(var ii=0;ii<this.buttons.length;ii++){this.buttons[ii].discard();}
this.container=null;this.editorPanel=null;this.wch=null;if(this.pane){this.pane.destroy();this.pane=null;}
this.config=null;zapatecEditor.SUPERclass.discard.call(this);};