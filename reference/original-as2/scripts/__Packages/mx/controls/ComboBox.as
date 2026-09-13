class mx.controls.ComboBox extends mx.controls.ComboBase
{
   var __dataProvider;
   var __dropdown;
   var __dropdownWidth;
   var __labelFunction;
   var __labels;
   var __selectedIndexOnDropdown;
   var __width;
   var _parent;
   var _y;
   var border_mc;
   var createObject;
   var data;
   var dataProvider;
   var dispatchEvent;
   var dispatchValueChangedEvent;
   var getStyle;
   var getValue;
   var height;
   var isPressed;
   var length;
   var localToGlobal;
   var mask;
   var owner;
   var selected;
   var selectedIndex;
   var selectedItem;
   var text_mc;
   var visible;
   var width;
   static var symbolName = "ComboBox";
   static var symbolOwner = mx.controls.ComboBox;
   static var version = "2.0.1.78";
   var clipParameters = {labels:1,data:1,editable:1,rowCount:1,dropdownWidth:1};
   static var mergedClipParameters = mx.core.UIObject.mergeClipParameters(mx.controls.ComboBox.prototype.clipParameters,mx.controls.ComboBase.prototype.clipParameters);
   var className = "ComboBox";
   var _showingDropdown = false;
   var __rowCount = 5;
   var dropdownBorderStyle = undefined;
   var initializing = true;
   var __labelField = "label";
   var bInKeyDown = false;
   function ComboBox()
   {
      super();
   }
   function init()
   {
      super.init();
   }
   function createChildren()
   {
      super.createChildren();
      this.editable = this.editable;
      var _loc6_;
      var _loc3_;
      if(this.__labels.length > 0)
      {
         _loc6_ = new Array();
         _loc3_ = 0;
         while(_loc3_ < this.labels.length)
         {
            _loc6_.addItem({label:this.labels[_loc3_],data:this.data[_loc3_]});
            _loc3_ = _loc3_ + 1;
         }
         this.setDataProvider(_loc6_);
      }
      this.dropdownWidth = typeof this.__dropdownWidth != "number" ? this.__width : this.__dropdownWidth;
      if(!this._editable)
      {
         this.selectedIndex = 0;
      }
      this.initializing = false;
   }
   function onKillFocus(n)
   {
      if(this._showingDropdown && n != null)
      {
         this.displayDropdown(false);
      }
      super.onKillFocus();
   }
   function getDropdown()
   {
      if(this.initializing)
      {
         return undefined;
      }
      var _loc3_;
      if(!this.hasDropdown())
      {
         _loc3_ = new Object();
         _loc3_.styleName = this;
         if(this.dropdownBorderStyle != undefined)
         {
            _loc3_.borderStyle = this.dropdownBorderStyle;
         }
         _loc3_._visible = false;
         this.__dropdown = mx.managers.PopUpManager.createPopUp(this,mx.controls.List,false,_loc3_,true);
         this.__dropdown.scroller.mask.removeMovieClip();
         if(this.dataProvider == undefined)
         {
            this.dataProvider = new Array();
         }
         this.__dropdown.setDataProvider(this.dataProvider);
         this.__dropdown.selectMultiple = false;
         this.__dropdown.rowCount = this.__rowCount;
         this.__dropdown.selectedIndex = this.selectedIndex;
         this.__dropdown.vScrollPolicy = "auto";
         this.__dropdown.labelField = this.__labelField;
         this.__dropdown.labelFunction = this.__labelFunction;
         this.__dropdown.owner = this;
         this.__dropdown.changeHandler = this._changeHandler;
         this.__dropdown.scrollHandler = this._scrollHandler;
         this.__dropdown.itemRollOverHandler = this._itemRollOverHandler;
         this.__dropdown.itemRollOutHandler = this._itemRollOutHandler;
         this.__dropdown.resizeHandler = this._resizeHandler;
         this.__dropdown.mouseDownOutsideHandler = function(eventObj)
         {
            var _loc3_ = this.owner;
            var _loc4_ = new Object();
            _loc4_.x = _loc3_._root._xmouse;
            _loc4_.y = _loc3_._root._ymouse;
            _loc3_._root.localToGlobal(_loc4_);
            if(!_loc3_.hitTest(_loc4_.x,_loc4_.y,false))
            {
               if(!(!this.wrapDownArrowButton && this.owner.downArrow_mc.hitTest(_root._xmouse,_root._ymouse,false)))
               {
                  _loc3_.displayDropdown(false);
               }
            }
         };
         this.__dropdown.onTweenUpdate = function(v)
         {
            this._y = v;
         };
         this.__dropdown.setSize(this.__dropdownWidth,this.__dropdown.height);
         this.createObject("BoundingBox","mask",20);
         this.mask._y = this.border_mc.height;
         this.mask._width = this.__dropdownWidth;
         this.mask._height = this.__dropdown.height;
         this.mask._visible = false;
         this.__dropdown.setMask(this.mask);
      }
      return this.__dropdown;
   }
   function setSize(w, h, noEvent)
   {
      super.setSize(w,h,noEvent);
      this.__dropdownWidth = w;
      this.__dropdown.rowHeight = h;
      this.__dropdown.setSize(this.__dropdownWidth,this.__dropdown.height);
   }
   function setEditable(e)
   {
      super.setEditable(e);
      if(e)
      {
         this.text_mc.setText("");
      }
      else
      {
         this.text_mc.setText(this.selectedLabel);
      }
   }
   function get labels()
   {
      return this.__labels;
   }
   function set labels(lbls)
   {
      this.__labels = lbls;
      this.setDataProvider(lbls);
   }
   function getLabelField()
   {
      return this.__labelField;
   }
   function get labelField()
   {
      return this.getLabelField();
   }
   function setLabelField(s)
   {
      this.__dropdown.labelField = this.__labelField = s;
      this.text_mc.setText(this.selectedLabel);
   }
   function set labelField(s)
   {
      this.setLabelField(s);
   }
   function getLabelFunction()
   {
      return this.__labelFunction;
   }
   function get labelFunction()
   {
      return this.getLabelFunction();
   }
   function set labelFunction(f)
   {
      this.__dropdown.labelFunction = this.__labelFunction = f;
      this.text_mc.setText(this.selectedLabel);
   }
   function setSelectedItem(v)
   {
      super.setSelectedItem(v);
      this.__dropdown.selectedItem = v;
      this.text_mc.setText(this.selectedLabel);
   }
   function setSelectedIndex(v)
   {
      super.setSelectedIndex(v);
      this.__dropdown.selectedIndex = v;
      if(v != undefined)
      {
         this.text_mc.setText(this.selectedLabel);
      }
      this.dispatchValueChangedEvent(this.getValue());
   }
   function setRowCount(count)
   {
      if(isNaN(count))
      {
         return undefined;
      }
      this.__rowCount = count;
      this.__dropdown.setRowCount(count);
   }
   function get rowCount()
   {
      return Math.max(1,Math.min(this.length,this.__rowCount));
   }
   function set rowCount(v)
   {
      this.setRowCount(v);
   }
   function setDropdownWidth(w)
   {
      this.__dropdownWidth = w;
      this.__dropdown.setSize(w,this.__dropdown.height);
   }
   function get dropdownWidth()
   {
      return this.__dropdownWidth;
   }
   function set dropdownWidth(v)
   {
      this.setDropdownWidth(v);
   }
   function get dropdown()
   {
      return this.getDropdown();
   }
   function setDataProvider(dp)
   {
      super.setDataProvider(dp);
      this.__dropdown.setDataProvider(dp);
      if(!this._editable)
      {
         this.selectedIndex = 0;
      }
   }
   function open()
   {
      this.displayDropdown(true);
   }
   function close()
   {
      this.displayDropdown(false);
   }
   function get selectedLabel()
   {
      var _loc2_ = this.selectedItem;
      if(_loc2_ == undefined)
      {
         return "";
      }
      if(this.labelFunction != undefined)
      {
         return this.labelFunction(_loc2_);
      }
      if(typeof _loc2_ != "object")
      {
         return _loc2_;
      }
      if(_loc2_[this.labelField] != undefined)
      {
         return _loc2_[this.labelField];
      }
      if(_loc2_.label != undefined)
      {
         return _loc2_.label;
      }
      var _loc3_ = " ";
      for(var _loc4_ in _loc2_)
      {
         if(_loc4_ != "__ID__")
         {
            _loc3_ = _loc2_[_loc4_] + ", " + _loc3_;
         }
      }
      _loc3_ = _loc3_.substring(0,_loc3_.length - 3);
      return _loc3_;
   }
   function hasDropdown()
   {
      return this.__dropdown != undefined && this.__dropdown.valueOf() != undefined;
   }
   function tweenEndShow(value)
   {
      this._y = value;
      this.isPressed = true;
      this.owner.dispatchEvent({type:"open",target:this.owner});
   }
   function tweenEndHide(value)
   {
      this._y = value;
      this.visible = false;
      this.owner.dispatchEvent({type:"close",target:this.owner});
   }
   function displayDropdown(show)
   {
      if(show == this._showingDropdown)
      {
         return undefined;
      }
      var _loc3_ = new Object();
      _loc3_.x = 0;
      _loc3_.y = this.height;
      this.localToGlobal(_loc3_);
      var _loc2_;
      var _loc5_;
      var _loc8_;
      var _loc6_;
      var _loc4_;
      if(show)
      {
         this.__selectedIndexOnDropdown = this.selectedIndex;
         this.getDropdown();
         _loc2_ = this.__dropdown;
         _loc2_.isPressed = true;
         _loc2_.rowCount = this.rowCount;
         _loc2_.visible = show;
         _loc2_._parent.globalToLocal(_loc3_);
         _loc2_.onTweenEnd = this.tweenEndShow;
         if(_loc3_.y + _loc2_.height > Stage.height)
         {
            _loc5_ = _loc3_.y - this.height;
            _loc8_ = _loc5_ - _loc2_.height;
            this.mask._y = - _loc2_.height;
         }
         else
         {
            _loc5_ = _loc3_.y - _loc2_.height;
            _loc8_ = _loc3_.y;
            this.mask._y = this.border_mc.height;
         }
         _loc6_ = _loc2_.selectedIndex;
         if(_loc6_ == undefined)
         {
            _loc6_ = 0;
         }
         _loc4_ = _loc2_.vPosition;
         _loc4_ = _loc6_ - 1;
         _loc4_ = Math.min(Math.max(_loc4_,0),_loc2_.length - _loc2_.rowCount);
         _loc2_.vPosition = _loc4_;
         _loc2_.move(_loc3_.x,_loc5_);
         _loc2_.tween = new mx.effects.Tween(this.__dropdown,_loc5_,_loc8_,this.getStyle("openDuration"));
      }
      else
      {
         this.__dropdown._parent.globalToLocal(_loc3_);
         delete this.__dropdown.dragScrolling;
         this.__dropdown.onTweenEnd = this.tweenEndHide;
         this.__dropdown.tween = new mx.effects.Tween(this.__dropdown,this.__dropdown._y,_loc3_.y - this.__dropdown.height,this.getStyle("openDuration"));
      }
      var _loc9_ = this.getStyle("openEasing");
      if(_loc9_ != undefined)
      {
         this.__dropdown.tween.easingEquation = _loc9_;
      }
      this._showingDropdown = show;
   }
   function onDownArrow()
   {
      this._parent.displayDropdown(!this._parent._showingDropdown);
   }
   function keyDown(e)
   {
      var _loc3_;
      if(e.ctrlKey && e.code == 40)
      {
         this.displayDropdown(true);
      }
      else if(e.ctrlKey && e.code == 38)
      {
         this.displayDropdown(false);
         this.dispatchChangeEvent(undefined,this.__selectedIndexOnDropdown,this.selectedIndex);
      }
      else if(e.code == 27)
      {
         this.displayDropdown(false);
      }
      else if(e.code == 13)
      {
         if(this._showingDropdown)
         {
            this.selectedIndex = this.__dropdown.selectedIndex;
            this.displayDropdown(false);
            this.dispatchChangeEvent(undefined,this.__selectedIndexOnDropdown,this.selectedIndex);
         }
      }
      else if(!this._editable || e.code == 38 || e.code == 40 || e.code == 33 || e.code == 34)
      {
         this.selectedIndex = 0 + this.selectedIndex;
         this.bInKeyDown = true;
         _loc3_ = this.dropdown;
         _loc3_.keyDown(e);
         this.bInKeyDown = false;
         this.selectedIndex = this.__dropdown.selectedIndex;
      }
   }
   function invalidateStyle(styleProp)
   {
      this.__dropdown.invalidateStyle(styleProp);
      super.invalidateStyle(styleProp);
   }
   function changeTextStyleInChildren(styleProp)
   {
      if(this.dropdown.stylecache != undefined)
      {
         delete this.dropdown.stylecache[styleProp];
         delete this.dropdown.stylecache.tf;
      }
      this.__dropdown.changeTextStyleInChildren(styleProp);
      super.changeTextStyleInChildren(styleProp);
   }
   function changeColorStyleInChildren(sheetName, styleProp, newValue)
   {
      if(this.dropdown.stylecache != undefined)
      {
         delete this.dropdown.stylecache[styleProp];
         delete this.dropdown.stylecache.tf;
      }
      this.__dropdown.changeColorStyleInChildren(sheetName,styleProp,newValue);
      super.changeColorStyleInChildren(sheetName,styleProp,newValue);
   }
   function notifyStyleChangeInChildren(sheetName, styleProp, newValue)
   {
      if(this.dropdown.stylecache != undefined)
      {
         delete this.dropdown.stylecache[styleProp];
         delete this.dropdown.stylecache.tf;
      }
      this.__dropdown.notifyStyleChangeInChildren(sheetName,styleProp,newValue);
      super.notifyStyleChangeInChildren(sheetName,styleProp,newValue);
   }
   function onUnload()
   {
      this.__dropdown.removeMovieClip();
   }
   function _resizeHandler()
   {
      var _loc2_ = this.owner;
      _loc2_.mask._width = this.width;
      _loc2_.mask._height = this.height;
   }
   function _changeHandler(obj)
   {
      var _loc2_ = this.owner;
      var _loc3_ = _loc2_.selectedIndex;
      obj.target = _loc2_;
      if(this == this.owner.text_mc)
      {
         _loc2_.selectedIndex = undefined;
         _loc2_.dispatchChangeEvent(obj,-1,-2);
      }
      else
      {
         _loc2_.selectedIndex = this.selectedIndex;
         if(!_loc2_._showingDropdown)
         {
            _loc2_.dispatchChangeEvent(obj,_loc3_,_loc2_.selectedIndex);
         }
         else if(!_loc2_.bInKeyDown)
         {
            _loc2_.displayDropdown(false);
            _loc2_.dispatchChangeEvent(obj,_loc3_,_loc2_.selectedIndex);
         }
      }
   }
   function _scrollHandler(obj)
   {
      var _loc2_ = this.owner;
      obj.target = _loc2_;
      _loc2_.dispatchEvent(obj);
   }
   function _itemRollOverHandler(obj)
   {
      var _loc2_ = this.owner;
      obj.target = _loc2_;
      _loc2_.dispatchEvent(obj);
   }
   function _itemRollOutHandler(obj)
   {
      var _loc2_ = this.owner;
      obj.target = _loc2_;
      _loc2_.dispatchEvent(obj);
   }
   function modelChanged(eventObj)
   {
      super.modelChanged(eventObj);
      if(0 == this.__dataProvider.length)
      {
         this.text_mc.setText("");
         delete this.selected;
      }
      else if(this.__dataProvider.length == eventObj.lastItem - eventObj.firstItem + 1 && eventObj.eventName == "addItems")
      {
         this.selectedIndex = 0;
      }
   }
   function dispatchChangeEvent(obj, prevValue, newValue)
   {
      var _loc2_;
      if(prevValue != newValue)
      {
         if(obj != undefined && obj.type == "change")
         {
            _loc2_ = obj;
         }
         else
         {
            _loc2_ = {type:"change"};
         }
         this.dispatchEvent(_loc2_);
      }
   }
}
