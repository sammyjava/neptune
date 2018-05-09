/**
 * Zapatec Composer object.
 */
Zapatec.Composer = function(config) {
	// Call constructor of superclass
	Zapatec.Composer.SUPERconstructor.call(this, config);
};

Zapatec.inherit(Zapatec.Composer, Zapatec.Widget);
Zapatec.implement(Zapatec.Composer, "Zapatec.CommandEvent");
Zapatec.implement(Zapatec.Composer, "Zapatec.Movable");
Zapatec.implement(Zapatec.Composer, "Zapatec.Draggable");

/**
 * Inits Composer for work.
 */
Zapatec.Composer.prototype.init = function(config) {
	// Call constructor of superclass
	Zapatec.Composer.SUPERclass.init.call(this, config);
	//document items found by itemClassName option.
	this.docItems = Zapatec.Array();
	//getting configuration
	var config = this.getConfiguration();
	this.setComponents(config.components);
	this.setDocument(config.document);
};

/**
 * Configures the Composer.
 */
Zapatec.Composer.prototype.configure = function(config) {
	//components used to built the document
	this.defineConfigOption("components", Zapatec.Array());
	//document element
	this.defineConfigOption("document", null);
	//class name to determine if element is an item
	this.defineConfigOption("itemClassName", "");

	// hooks className
	this.defineConfigOption("hookClassName", "");
	//class name to highlight element
	this.defineConfigOption("highlightClass", "");
	//class name to select element
	this.defineConfigOption("selectedClass", "");
	//callback to put itmes into the document
	this.defineConfigOption("putCallback", function(component, nextComponent) {});
	//no theme
	this.defineConfigOption("theme", null);
	// Call constructor of superclass
	Zapatec.Composer.SUPERclass.configure.call(this, config);
};

/**
 * Sets the components array and makes all
 * components draggable.
 * @param components {array} array of components.
 */
Zapatec.Composer.prototype.setComponents = function(components) {
	//getting configuration
	var config = this.getConfiguration();
	//making it a Zapatec.Array
	config.components = Zapatec.Array(components);
	//making components draggable
	config.components.each(function(index, component) {
		new Zapatec.Utils.Draggable({
			container : component,
			method : "dummy"
		});
		Zapatec.Utils.addClass(component, "zpComposerComponent");
	});
};

/**
 * Sets the document for this composer, where
 * the components can be put to.
 * @param document {HTML element} document element.
 */
Zapatec.Composer.prototype.setDocument = function(newDocument) {
	//getting configuration
	var config = this.getConfiguration();
	//setting document
	config.document = Zapatec.Widget.getElementById(newDocument) || config.document;
	//local state variable and pointer to this
	var over = false, self = this;

	//highlighting function called on global onDragMove event
	function highlight(ev, dragObj) {
		var wasOver = over;
		if (over !== false) {
			//trying to find component under
			over = self.getComponentPlace(dragObj.getMovingPoint());
			if (over != wasOver) {
				//if it's not the same making highlight
				self.highlight(over);
			}
		}
	}

	//if there is document making it drop area
	if (Zapatec.isHtmlElement(config.document)) {
		//getting document items.
		this.docItems = this.seekItems();
		if (this.dropArea) {
			this.dropArea.destroy();
			this.dropArea.discard();
		}
		this.dropArea = new Zapatec.Utils.DropArea({
			container : config.document,
			eventListeners : {
				onDrop : function(el) {
					if (Zapatec.isHtmlElement(el) && el.className.indexOf("zpComposerComponent") != -1) {
						//removing highlight
						self.highlight();
						//putting component
						config.putCallback(el, over);
					} else if (Zapatec.isHtmlElement(el) && el.className.indexOf(config.itemClassName) != -1) {
						self.highlight();
						self.restoreOfMove();
						
						var elId = parseInt(el.id.replace(/[^\d]/g, ""));
						
						if (Zapatec.isHtmlElement(over)) {
							var overId = parseInt(over.id.replace(/[^\d]/g, ""));
							wizard.moveFieldTo(elId, overId);
							
							over.parentNode.insertBefore(el, over);
						} else {
							var formCoords = Zapatec.Utils.getElementOffset(self.config.document);
//							var lastCoords = Zapatec.Utils.getElementOffset(wizard.fieldsOrder[wizard.fieldsOrder.length - 1]);
							var elCoords = Zapatec.Utils.getElementOffset(el);

							if(elCoords.top <= formCoords.top){
								wizard.moveFieldTo(elId, wizard.fieldsOrder[0]);
								config.document.insertBefore(el, wizard.fields[wizard.fieldsOrder[0]].elementRef);
							} else {
								wizard.moveFieldTo(elId);
								config.document.insertBefore(el, self.config.document.lastChild);
							}
						}

						self._movableItem = null;
					}
				},
				onDragInit : function(el) {
					//renewing doc items
					self.docItems = self.seekItems();
				},
				onDragOver : function(el) {
					//pointing that we drag over nothing :)
					over = null;
					//starting highlight
					Zapatec.GlobalEvents.addEventListener("onDragMove", highlight);
					highlight(null, self);
				},
				onDragOut : function(el) {
					//ending highlight
					Zapatec.GlobalEvents.removeEventListener("onDragMove", highlight);
					//removing highlight
					self.highlight();
					//pointing thaty we drag out of document
					over = false;
				},
				onDragEnd : function(el) {
					if (Zapatec.isHtmlElement(el) && el.className.indexOf(config.itemClassName) != -1 && !over) {
//						self.restoreOfMove();

						var elId = parseInt(el.id.replace(/[^\d]/g, ""));
						var formCoords = Zapatec.Utils.getElementOffset(self.config.document);
//							var lastCoords = Zapatec.Utils.getElementOffset(wizard.fieldsOrder[wizard.fieldsOrder.length - 1]);
						var elCoords = Zapatec.Utils.getElementOffset(el);

						self.restoreOfMove();
	
						if(elCoords.top <= formCoords.top){
							wizard.moveFieldTo(elId, wizard.fieldsOrder[0]);
							self.config.document.insertBefore(el, wizard.fields[wizard.fieldsOrder[0]].fieldConfig.elementRef);
						} else {
							wizard.moveFieldTo(elId);
							self.config.document.insertBefore(el, self.config.document.lastChild);
						}
					}
					over = false;
				}
			}
		});
		this.addEventListener("beforeDragInit", function(ev) {
			var config = this.getConfiguration();
			var el = Zapatec.Utils.getElementsByAttribute("className", config.selectedClass, config.document, true, true);
			var target = Zapatec.Utils.getTargetElement(ev);

			if (el) {
				this._movableItem = el[0];
			} else {
				this._movableItem = null;
			}

			if (!this._movableItem) {
				this.returnValue(false);
			}
		});
		//making document draggable
		this.restoreOfDrag();
		this.makeDraggable();
	}
};

/**
 * Gets the element collapsing the passed coordinate.
 * @param position {object} object with x and y properties.
 * @return {HTML element or null} collapsing element.
 */
Zapatec.Composer.prototype.getComponentPlace = function(position) {
	var result = null;
	var self = this;
	this.docItems.each(function(index, item) {
		if (item == self.getContainer()) {
			return false;
		}
		var pos = Zapatec.Utils.getElementOffset(item);
		if (pos.x < position.x && pos.x + pos.width > position.x && pos.y < position.y && pos.y + pos.height > position.y) {
			result = item;
			return "break";
		}
	});
	return result;
};

/**
 * Highlights elements if passed, and dehighlights previous.
 * @param el {HTML element} element to highlight.
 */
Zapatec.Composer.prototype.highlight = function(el) {
	var config = this.getConfiguration();
	if (Zapatec.isHtmlElement(this._activeItem)) {
		Zapatec.Utils.removeClass(this._activeItem, config.highlightClass);
		this._activeItem = null;
	}
	if (Zapatec.isHtmlElement(el)) {
		Zapatec.Utils.addClass(el, config.highlightClass);
		this._activeItem = el;
	}
};

/**
 * Seeks items in the document and returns array of them.
 * @return {Zapatec.Array} array of elements representing items in form.
 */
Zapatec.Composer.prototype.seekItems = function() {
	var config = this.getConfiguration();
	return Zapatec.Utils.getElementsByAttribute("className", config.itemClassName, config.document, true, true);
};

/**
 * Overwriting getContainer method of Zapatec.Movable
 * interface so most of the rest methods work correctly.
 * @return {HTML element or null} element representing 
 * the active item.
 */
Zapatec.Composer.prototype.getContainer = function() {
	return this._movableItem;
};

/**
 * Should return the dragging configuration.
 * @return {object} configuration object.
 */
Zapatec.Composer.prototype.getDragConfig = function() {
	return {
		method : "cut",
		dragCSS : "",
		overwriteCSS : "",
		stopEvent : false,
		eventCapture : false
	};
};

/**
 * Sets the dragging configuration.
 * @param config {object} a set of new configuration.
 */
Zapatec.Composer.prototype.setDragConfig = function(config) {
};

/**
 * Overwriting draggable method for returning hook for dragging
 */
Zapatec.Composer.prototype._getDraggableHooks = function() {
	return Zapatec.Utils.getElementsByAttribute("className", this.config.hookClassName, this.config.document, true, true);
};

/**
 * Overwriting interface method.
 */
Zapatec.Composer.prototype.getMoveConfig = function() {
	return {
		limit : {
			minY: 0
		},
		moveLayer : this.getConfiguration().document,
		direction : "vertical",
		preserveSizes : true,
		followShape : true
	};
};

/**
 * Sets the moving configuration.
 * @param config {object} a set of new configuration.
 */
Zapatec.Composer.prototype.setMoveConfig = function(config) {
};
