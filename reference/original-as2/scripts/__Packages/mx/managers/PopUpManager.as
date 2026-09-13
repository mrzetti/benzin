class mx.managers.PopUpManager
{
   var _name;
   var _parent;
   var _visible;
   var modalWindow;
   var move;
   var owner;
   var popUp;
   var setSize;
   static var version = "2.0.1.78";
   static var mixins = undefined;
   function PopUpManager()
   {
   }
   static function createModalWindow(parent, o, broadcastOutsideEvents)
   {
      var _loc2_ = parent.createChildAtDepth("Modal",mx.managers.DepthManager.kTopmost);
      _loc2_.setDepthBelow(o);
      o.modalID = _loc2_._name;
      _loc2_._alpha = _global.style.modalTransparency;
      _loc2_.tabEnabled = false;
      if(broadcastOutsideEvents)
      {
         _loc2_.onPress = mx.managers.PopUpManager.mixins.onPress;
      }
      else
      {
         _loc2_.onPress = mx.managers.PopUpManager.mixins.nullFunction;
      }
      _loc2_.onRelease = mx.managers.PopUpManager.mixins.nullFunction;
      _loc2_.resize = mx.managers.PopUpManager.mixins.resize;
      mx.managers.SystemManager.init();
      mx.managers.SystemManager.addEventListener("resize",_loc2_);
      _loc2_.resize();
      _loc2_.useHandCursor = false;
      _loc2_.popUp = o;
      o.modalWindow = _loc2_;
      o.deletePopUp = mx.managers.PopUpManager.mixins.deletePopUp;
      o.setVisible = mx.managers.PopUpManager.mixins.setVisible;
      o.getVisible = mx.managers.PopUpManager.mixins.getVisible;
      o.addProperty("visible",o.getVisible,o.setVisible);
   }
   static function createPopUp(parent, className, modal, initobj, broadcastOutsideEvents)
   {
      if(mx.managers.PopUpManager.mixins == undefined)
      {
         mx.managers.PopUpManager.mixins = new mx.managers.PopUpManager();
      }
      if(broadcastOutsideEvents == undefined)
      {
         broadcastOutsideEvents = false;
      }
      var _loc5_ = parent._root;
      if(_loc5_ == undefined)
      {
         _loc5_ = _root;
      }
      while(parent != _loc5_)
      {
         parent = parent._parent;
      }
      initobj.popUp = true;
      var _loc4_ = parent.createClassChildAtDepth(className,!(broadcastOutsideEvents || modal) ? mx.managers.DepthManager.kTop : mx.managers.DepthManager.kTopmost,initobj);
      var _loc2_ = _root;
      var _loc6_ = _loc2_.focusManager != undefined;
      while(_loc2_._parent != undefined)
      {
         _loc2_ = _loc2_._parent._root;
         if(_loc2_.focusManager != undefined)
         {
            _loc6_ = true;
            break;
         }
      }
      if(_loc6_)
      {
         _loc4_.createObject("FocusManager","focusManager",-1);
         if(_loc4_._visible == false)
         {
            mx.managers.SystemManager.deactivate(_loc4_);
         }
      }
      if(modal)
      {
         mx.managers.PopUpManager.createModalWindow(parent,_loc4_,broadcastOutsideEvents);
      }
      else
      {
         if(broadcastOutsideEvents)
         {
            _loc4_.mouseListener = new Object();
            _loc4_.mouseListener.owner = _loc4_;
            _loc4_.mouseListener.onMouseDown = mx.managers.PopUpManager.mixins.onMouseDown;
            Mouse.addListener(_loc4_.mouseListener);
         }
         _loc4_.deletePopUp = mx.managers.PopUpManager.mixins.deletePopUp;
      }
      return _loc4_;
   }
   function onPress(Void)
   {
      var _loc3_ = this.popUp._root;
      if(_loc3_ == undefined)
      {
         _loc3_ = _root;
      }
      if(this.popUp.hitTest(_loc3_._xmouse,_loc3_._ymouse,false))
      {
         return undefined;
      }
      this.popUp.dispatchEvent({type:"mouseDownOutside"});
   }
   function nullFunction(Void)
   {
   }
   function resize(Void)
   {
      var _loc2_ = mx.managers.SystemManager.screen;
      this.setSize(_loc2_.width,_loc2_.height);
      this.move(_loc2_.x,_loc2_.y);
   }
   function deletePopUp(Void)
   {
      if(this.modalWindow != undefined)
      {
         this._parent.destroyObject(this.modalWindow._name);
      }
      this._parent.destroyObject(this._name);
   }
   function setVisible(v, noEvent)
   {
      super.setVisible(v,noEvent);
      this.modalWindow._visible = v;
   }
   function getVisible(Void)
   {
      return this._visible;
   }
   function onMouseDown(Void)
   {
      var _loc3_ = this.owner._root;
      if(_loc3_ == undefined)
      {
         _loc3_ = _root;
      }
      var _loc4_ = new Object();
      _loc4_.x = _loc3_._xmouse;
      _loc4_.y = _loc3_._ymouse;
      _loc3_.localToGlobal(_loc4_);
      if(!this.owner.hitTest(_loc4_.x,_loc4_.y,false))
      {
         this.owner.mouseDownOutsideHandler(this.owner);
      }
   }
}
