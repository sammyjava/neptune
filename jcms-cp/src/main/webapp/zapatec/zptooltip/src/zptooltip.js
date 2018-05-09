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
Zapatec.tooltipPath = Zapatec.getPath("Zapatec.TooltipWidget");

Zapatec.Tooltip=function(objArgs){if(arguments.length==0){objArgs={};}
Zapatec.Tooltip.SUPERconstructor.call(this,objArgs);};Zapatec.Tooltip.id='Zapatec.Tooltip';Zapatec.inherit(Zapatec.Tooltip,Zapatec.Widget);Zapatec.Tooltip.prototype.init=function(objArgs)
{Zapatec.Tooltip.SUPERclass.init.call(this,objArgs);this.isCreate=false;this.setEvents();};Zapatec.Tooltip.prototype.configure=function(objArgs){this.defineConfigOption('target',null);this.defineConfigOption('tooltip',null);this.defineConfigOption('parent',null);this.defineConfigOption('movable',false);this.defineConfigOption('content',null);this.defineConfigOption('source',null);this.defineConfigOption('sourceType','html');this.defineConfigOption('isCashed',false);this.defineConfigOption('offsetX',2);this.defineConfigOption('offsetY',20);Zapatec.Tooltip.SUPERclass.configure.call(this,objArgs);if(typeof this.config.target=="string"){this.config.target=Zapatec.Widget.getElementById(this.config.target);}
if(!this.config.target){Zapatec.Log({description:"Can't find tooltip target (\"target\" config option)"});return false;}
if(typeof this.config.source=="string"){this.config.source=Zapatec.Widget.getElementById(this.config.source);}
if(this.config.tooltip!=null&&this.config.source==null){this.config.source=this.config.tooltip;this.config.sourceType='html';if(typeof this.config.source=="string"){this.config.source=Zapatec.Widget.getElementById(this.config.source);}
if(!this.config.source){if(this.config.content){this.tooltip=Zapatec.Utils.createElement("div");}
else{Zapatec.Log({description:"Can't find \"source\" config option"});return false;}}
if(this.config.content){this.setContent(this.config.content);}}
if(this.config.source&&this.config.source.style)
this.config.source.style.display='none';if(typeof this.config.parent=="string"){this.config.parent=Zapatec.Widget.getElementById(this.config.parent);}};Zapatec.Tooltip.prototype.reconfigure=function(oArg){Zapatec.Tooltip.SUPERclass.reconfigure.call(this,oArg);this.init();};Zapatec.Tooltip.prototype.createTooltip=function(){var self=this;this.loadCookie();this.tooltip=Zapatec.Utils.createElement("div");this.visible=false;this.tooltip.style.position='absolute';this.inTooltip=false;this.timeout=null;var parentNotDefined=!this.config.parent;if(parentNotDefined){this.config.parent=this.config.target;}
var parent=this.config.parent;if(parentNotDefined&&parent.tagName&&parent.tagName.toLowerCase()=="input"){document.body.appendChild(this.tooltip);}
else{parent.appendChild(this.tooltip);}
Zapatec.Utils.addClass(this.tooltip,this.getClassName({prefix:"zpTooltip",suffix:""}));Zapatec.Transport.showBusy({busyContainer:this.tooltip});this.loadData();this.saveCookie();Zapatec.Transport.removeBusy({busyContainer:this.tooltip});if(this.tooltip.title){var title=Zapatec.Utils.createElement("div");this.tooltip.insertBefore(title,this.tooltip.firstChild);title.className=this.getClassName({prefix:"zpTooltip",suffix:"Title"});title.innerHTML=unescape(this.tooltip.title);this.tooltip.title="";}
this.wch=Zapatec.Utils.createWCH(this.tooltip);if(this.wch){this.wch.style.zIndex=-1;}
this.createProperty(this,'_tooltipMouseOverListener',function(ev){self.inTooltip=true;return true;});Zapatec.Utils.addEvent(this.tooltip,"mouseover",this._tooltipMouseOverListener);this.createProperty(this,'_tooltipMouseOutListener',function(ev){ev||(ev=window.event);if(!Zapatec.Utils.isRelated(self.tooltip,ev)){self.inTooltip=false;self.hide();}
return true;});Zapatec.Utils.addEvent(this.tooltip,"mouseout",this._tooltipMouseOutListener);this.isCreate=true;}
Zapatec.Tooltip.prototype.setEvents=function(){var self=this;this.createProperty(this,'_targetMouseOverListener',function(ev){return self._onMouseMove(ev);});Zapatec.Utils.addEvent(this.config.target,"mouseover",this._targetMouseOverListener);if(this.config.movable){this.createProperty(this,'_targetMouseMoveListener',function(ev){return self._onMouseMove(ev);});Zapatec.Utils.addEvent(this.config.target,"mousemove",this._targetMouseMoveListener);}
this.createProperty(this,'_targetMouseOutListener',function(ev){return self._onMouseOut(ev);});Zapatec.Utils.addEvent(this.config.target,"mouseout",this._targetMouseOutListener);}
Zapatec.Tooltip.prototype.destroy=function(){this.hide();Zapatec.Utils.removeEvent(this.config.target,"mouseover",this._targetMouseOverListener);Zapatec.Utils.removeEvent(this.config.target,"mousemove",this._targetMouseMoveListener);Zapatec.Utils.removeEvent(this.config.target,"mouseout",this._targetMouseOutListener);Zapatec.Utils.removeEvent(this.tooltip,"mouseover",this._tooltipMouseOverListener);Zapatec.Utils.removeEvent(this.tooltip,"mouseout",this._tooltipMouseOutListener);if(this.wch){this.wch.parentNode.removeChild(this.wch);}}
Zapatec.Tooltip.setupFromDFN=function(class_re){var dfns=document.getElementsByTagName("dfn");if(typeof class_re=="string")
class_re=new RegExp("(^|\\s)"+class_re+"(\\s|$)","i");var dfn,div,oTooltip,dfnClass;for(var i=dfns.length-1;i>=0;i--){dfn=dfns[i];if(!class_re||class_re.test(dfn.className)){div=document.createElement("div");if(dfn.title){div.title=dfn.title;dfn.title="";}
div.className=dfn.className;if(dfn.style.width){div.style.width=dfn.style.width;}
if(dfn.style.height){div.style.height=dfn.style.height;}
while(dfn.firstChild)
div.appendChild(dfn.firstChild);dfn.innerHTML="?";oTooltip=new Zapatec.Tooltip({target:dfn,parent:document.body,source:div});dfnClass=oTooltip.getClassName({prefix:"zpTooltip",suffix:"Dfn"});Zapatec.Utils.addClass(dfn,dfnClass);}}};Zapatec.Tooltip._currentTooltip=null;Zapatec.Tooltip.prototype._onMouseMove=function(ev){ev||(ev=window.event);if(!this.isCreate)
this.createTooltip();if(!this.isCreate)
this.createTooltip();if(this.timeout){clearTimeout(this.timeout);this.timeout=null;}
if((!this.visible||this.config.movable)&&!Zapatec.Utils.isRelated(this.config.target,ev)){var oPos=Zapatec.Utils.getMousePos(ev);this.show(oPos.pageX+this.config.offsetX,oPos.pageY+this.config.offsetY);}
return true;};Zapatec.Tooltip.prototype._onMouseOut=function(ev){ev||(ev=window.event);if(!this.isCreate)
this.createTooltip();var self=this;if(!Zapatec.Utils.isRelated(this.config.target,ev)){if(this.timeout){clearTimeout(this.timeout);this.timeout=null;}
this.timeout=setTimeout(function(){self.hide();},150);}
return true;};Zapatec.Tooltip.prototype.show=function(x,y){if(Zapatec.Tooltip._currentTooltip){if(Zapatec.Tooltip._currentTooltip.timeout){clearTimeout(Zapatec.Tooltip._currentTooltip.timeout);Zapatec.Tooltip._currentTooltip.timeout=null;}
Zapatec.Tooltip._currentTooltip.hide();}
this.tooltip.style.display='block';if(null==x&&null==y){var targetOffset=Zapatec.Utils.getElementOffset(this.config.target);x=targetOffset.left;y=targetOffset.top;}
this.tooltip.style.left=x+'px';this.tooltip.style.top=y+'px';var oOffset=Zapatec.Utils.getElementOffset(this.tooltip);var iDiffLeft=x-oOffset.left;if(iDiffLeft){x+=iDiffLeft;this.tooltip.style.left=x+'px';}
var iDiffTop=y-oOffset.top;if(iDiffTop){y+=iDiffTop;this.tooltip.style.top=y+'px';}
oOffset=Zapatec.Utils.getElementOffset(this.tooltip);var iRight=oOffset.left+oOffset.width;var iBottom=oOffset.top+oOffset.height;var oWindowSize=Zapatec.Utils.getWindowSize();var iWinW=Zapatec.Utils.getPageScrollX()+oWindowSize.width;var iWinH=Zapatec.Utils.getPageScrollY()+oWindowSize.height;if(iRight>iWinW){x+=iWinW-iRight;this.tooltip.style.left=x+'px';}
if(iBottom>iWinH){y+=iWinH-iBottom;this.tooltip.style.top=y+'px';}
Zapatec.Utils.setupWCH(this.wch,0,0,oOffset.width,oOffset.height);Zapatec.Utils.addClass(this.config.target,this.getClassName({prefix:"zpTooltip",suffix:"Hover"}));this.visible=true;Zapatec.Tooltip._currentTooltip=this;};Zapatec.Tooltip.prototype.hide=function(){if(!this.inTooltip){this.tooltip.style.display="none";Zapatec.Utils.hideWCH(this.wch);Zapatec.Utils.removeClass(this.config.target,this.getClassName({prefix:"zpTooltip",suffix:"Hover"}));this.visible=false;}};Zapatec.Tooltip.prototype.setContent=function(html){this.tooltip.innerHTML=html;};Zapatec.Tooltip.prototype.loadCookie=function(){if(this.config.isCashed){var cookieName=window.location.href+"--"+this.config.target.id;var text=Zapatec.Utils.getCookie(cookieName);if(text){tmp=Zapatec.Utils.loadPref(text);if(tmp)
Zapatec.Utils.mergeObjects(this.tooltip,tmp);}}};Zapatec.Tooltip.prototype.saveCookie=function(){if(this.config.isCashed){var cookieName=window.location.href+"--"+this.config.target.id;Zapatec.Utils.writeCookie(cookieName,Zapatec.Utils.makePref(this.tooltip),null,'/',30);}};Zapatec.Tooltip.prototype.loadDataJson=function(objResponse){if(objResponse==null){return null;}
if(!objResponse["Tooltip"])
return null;if(objResponse["Tooltip"][0]["title"])
this.tooltip.title=objResponse["Tooltip"][0]["title"];this.setContent(objResponse["Tooltip"][0]["label"]||"");};Zapatec.Tooltip.prototype.loadDataXml=function(objSource){if(objSource==null||objSource.documentElement==null){return null;}
var tooltip=objSource.documentElement;for(var ii=0;ii<tooltip.childNodes.length;ii++){var el=tooltip.childNodes[ii];if(el.nodeName.toLowerCase()=="title")
this.tooltip.title=el.childNodes[0].nodeValue;if(el.nodeName.toLowerCase()=="label")
this.setContent(el.childNodes[0].nodeValue);}};Zapatec.Tooltip.prototype.loadDataHtml=function(objSource){if(objSource==null){return null;}
if(objSource.title)
this.tooltip.title=objSource.title;if(objSource.style)
for(var attr in objSource.style)
this.tooltip.style.attr=objSource.style[objSource.style[attr]];this.setContent(objSource.innerHTML||'');};