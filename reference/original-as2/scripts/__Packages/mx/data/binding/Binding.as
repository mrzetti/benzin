class mx.data.binding.Binding
{
   var binding;
   var dest;
   var format;
   var immediate;
   var is2way;
   var source;
   var value;
   var value2;
   var queued = false;
   var reverse = false;
   static var counter = 0;
   static var screenRegistry = new Object();
   static var bindingRegistry = new Array();
   function Binding(source, dest, format, is2way)
   {
      mx.events.EventDispatcher.initialize(this);
      var _loc5_ = this;
      _loc5_.source = source;
      _loc5_.dest = dest;
      _loc5_.format = format;
      _loc5_.is2way = is2way;
      mx.data.binding.Binding.registerBinding(this);
      this.calcShortLoc(source);
      this.calcShortLoc(dest);
      _global.__dataLogger.logData(null,"Creating binding " + this.summaryString() + (!is2way ? "" : ", 2-way"),{binding:this});
      _global.__dataLogger.nestLevel++;
      mx.data.binding.ComponentMixins.initComponent(dest.component);
      if(source.component != undefined)
      {
         mx.data.binding.ComponentMixins.initComponent(source.component);
      }
      dest.component.addBinding(this);
      if(source.component != undefined)
      {
         source.component.addBinding(this);
         this.setUpListener(source,false);
         if(this.is2way)
         {
            this.setUpListener(dest,true);
            this.setUpIndexListeners(source,false);
            this.setUpIndexListeners(dest,true);
         }
         else
         {
            this.setUpIndexListeners(source,false);
            this.setUpIndexListeners(dest,false);
         }
      }
      else
      {
         this.execute();
      }
      _global.__dataLogger.nestLevel--;
   }
   function execute(reverse)
   {
      var _loc3_;
      var _loc4_;
      if(reverse)
      {
         if(!this.is2way)
         {
            _global.__dataLogger.logData(null,"Warning: Can\'t execute binding " + this.summaryString(false) + " in reverse, because it\'s not a 2 way binding",{binding:this},mx.data.binding.Log.BRIEF);
            return ["error"];
         }
         _loc3_ = this.dest;
         _loc4_ = this.source;
      }
      else
      {
         _loc3_ = this.source;
         _loc4_ = this.dest;
      }
      _global.__dataLogger.logData(null,"Executing binding " + this.summaryString(reverse),{binding:this});
      _global.__dataLogger.nestLevel++;
      var _loc10_;
      if(_loc3_.constant != undefined)
      {
         _loc10_ = {value:new mx.data.binding.TypedValue(_loc3_.constant,"String"),getAnyTypedValue:function()
         {
            return this.value;
         },getTypedValue:function()
         {
            return this.value;
         },getGettableTypes:function()
         {
            return ["String"];
         }};
      }
      else
      {
         _loc10_ = _loc3_.component.getField(_loc3_.property,_loc3_.location,true);
      }
      var _loc20_;
      var _loc16_;
      var _loc13_ = "";
      var _loc6_ = _loc4_.component.getField(_loc4_.property,_loc4_.location);
      var _loc5_;
      if(this.format != null)
      {
         _loc5_ = mx.data.binding.Binding.getRuntimeObject(this.format);
         if(_loc5_ != null)
         {
            if(reverse)
            {
               _loc5_.setupDataAccessor(_loc4_.component,_loc4_.property,_loc4_.location);
               _loc5_.dataAccessor = _loc6_;
               _loc6_ = _loc5_;
            }
            else
            {
               _loc5_.setupDataAccessor(_loc3_.component,_loc3_.property,_loc3_.location);
               _loc5_.dataAccessor = _loc10_;
               _loc10_ = _loc5_;
            }
         }
      }
      var _loc15_ = this.format != null ? null : _loc6_.getSettableTypes();
      var _loc11_ = _loc10_.getAnyTypedValue(_loc15_);
      var _loc7_ = new Object();
      var _loc8_;
      var _loc14_;
      if(_loc6_.type.readonly == true)
      {
         _global.__dataLogger.logData(null,"Not executing binding because the destination is read-only",null,mx.data.binding.Log.BRIEF);
         _loc8_ = new Object();
         _loc8_.type = "invalid";
         _loc8_.property = _loc4_.property;
         _loc8_.location = _loc4_.location;
         _loc8_.messages = [{message:"Cannot assign to a read-only data field."}];
         _loc4_.component.dispatchEvent(_loc8_);
         _loc7_.event = _loc8_;
      }
      else
      {
         _global.__dataLogger.logData(null,"Assigning new value \'<value>\' (<typeName>) " + _loc13_,{value:_loc11_.value,typeName:_loc11_.typeName,unformattedValue:_loc20_,formatterFrom:_loc16_});
         _loc14_ = _loc6_.setAnyTypedValue(_loc11_);
         _loc6_.validateAndNotify(_loc7_,false,_loc14_);
         _loc4_.component.dispatchEvent({type:"bindingExecuted",binding:this});
      }
      var _loc9_;
      if(_loc7_.event != null)
      {
         if(_loc3_.component != null)
         {
            _loc9_ = new Object();
            _loc9_.type = _loc7_.event.type;
            _loc9_.property = _loc3_.property;
            _loc9_.location = _loc3_.location;
            _loc9_.messages = _loc7_.event.messages;
            _loc9_.to = _loc4_.component;
            _loc3_.component.dispatchEvent(_loc9_);
         }
      }
      _global.__dataLogger.nestLevel--;
      return _loc7_.event.messages;
   }
   function queueForExecute(reverse)
   {
      if(!this.queued)
      {
         if(_global.__databind_executeQueue == null)
         {
            _global.__databind_executeQueue = new Array();
         }
         if(_root.__databind_dispatch == undefined)
         {
            _root.createEmptyMovieClip("__databind_dispatch",-8888);
         }
         _global.__databind_executeQueue.push(this);
         this.queued = true;
         this.reverse = reverse;
         _root.__databind_dispatch.onEnterFrame = mx.data.binding.Binding.dispatchEnterFrame;
      }
   }
   static function dispatchEnterFrame()
   {
      _root.__databind_dispatch.onEnterFrame = null;
      var _loc4_ = 0;
      var _loc3_;
      while(_loc4_ < _global.__databind_executeQueue.length)
      {
         _loc3_ = _global.__databind_executeQueue[_loc4_];
         _loc3_.execute(_loc3_.reverse);
         _loc4_ = _loc4_ + 1;
      }
      var _loc5_;
      while((_loc5_ = _global.__databind_executeQueue.pop()) != null)
      {
         _loc5_.queued = false;
         _loc5_.reverse = false;
      }
   }
   function calcShortLoc(endpoint)
   {
      var _loc1_ = endpoint.location;
      if(_loc1_.path != null)
      {
         _loc1_ = _loc1_.path;
      }
      endpoint.loc = !(_loc1_ instanceof Array) ? _loc1_ : _loc1_.join(".");
   }
   function summaryString(reverse)
   {
      var _loc2_ = "<binding.dest.component>:<binding.dest.property>:<binding.dest.loc>";
      var _loc3_ = "<binding.source.component>:<binding.source.property>:<binding.source.loc>";
      if(this.source.constant == null)
      {
         if(reverse == true)
         {
            return "from " + _loc2_ + " to " + _loc3_;
         }
         return "from " + _loc3_ + " to " + _loc2_;
      }
      return "from constant \'<binding.source.constant>\' to " + _loc2_;
   }
   static function getRuntimeObject(info, constructorParameter)
   {
      if(info.cls == undefined)
      {
         info.cls = mx.utils.ClassFinder.findClass(info.className);
      }
      var _loc3_ = new info.cls(constructorParameter);
      if(_loc3_ == null)
      {
         _global.__dataLogger.logData(null,"Could not construct a formatter or validator - new <info.className>(<params>)",{info:info,params:constructorParameter},mx.data.binding.Log.BRIEF);
      }
      for(var _loc4_ in info.settings)
      {
         _loc3_[_loc4_] = info.settings[_loc4_];
      }
      return _loc3_;
   }
   static function refreshFromSources(component, property, bindings)
   {
      var _loc5_ = null;
      var _loc3_;
      _loc3_ = 0;
      var _loc1_;
      var _loc2_;
      while(_loc3_ < bindings.length)
      {
         _loc1_ = bindings[_loc3_];
         _loc2_ = null;
         if(_loc1_.dest.component == component && (property == null || property == _loc1_.dest.property))
         {
            _loc2_ = _loc1_.execute();
         }
         else if(_loc1_.is2way && _loc1_.source.component == component && (property == null || property == _loc1_.source.property))
         {
            _loc2_ = _loc1_.execute(true);
         }
         if(_loc2_ != null)
         {
            _loc5_ = _loc5_ != null ? _loc5_.concat(_loc2_) : _loc2_;
         }
         _loc3_ = _loc3_ + 1;
      }
      return _loc5_;
   }
   static function refreshDestinations(component, bindings)
   {
      var _loc1_;
      _loc1_ = 0;
      var _loc2_;
      while(_loc1_ < bindings.length)
      {
         _loc2_ = bindings[_loc1_];
         if(_loc2_.source.component == component)
         {
            _loc2_.execute();
         }
         else if(_loc2_.is2way && _loc2_.dest.component == component)
         {
            _loc2_.execute(true);
         }
         _loc1_ = _loc1_ + 1;
      }
      _loc1_ = 0;
      var _loc3_;
      while(_loc1_ < component.__indexBindings.length)
      {
         _loc3_ = component.__indexBindings[_loc1_];
         _loc3_.binding.execute(_loc3_.reverse);
         _loc1_ = _loc1_ + 1;
      }
   }
   static function okToCallGetterFromSetter()
   {
      function setter(val)
      {
         this.value2 = this.value;
      }
      function getter()
      {
         return 5;
      }
      var _loc2_ = new Object();
      _loc2_.addProperty("value",getter,setter);
      _loc2_.value = 0;
      var _loc3_ = _loc2_.value2 == _loc2_.value;
      return _loc3_;
   }
   function setUpListener(endpoint, reverse)
   {
      var _loc4_ = new Object();
      _loc4_.binding = this;
      _loc4_.property = endpoint.property;
      _loc4_.reverse = reverse;
      _loc4_.immediate = mx.data.binding.Binding.okToCallGetterFromSetter();
      _loc4_.handleEvent = function(event)
      {
         _global.__dataLogger.logData(event.target,"Data of property \'<property>\' has changed. <immediate>.",this);
         if(this.immediate)
         {
            if(this.binding.executing != true)
            {
               this.binding.executing = true;
               this.binding.execute(this.reverse);
               this.binding.executing = false;
            }
         }
         else
         {
            this.binding.queueForExecute(this.reverse);
         }
      };
      if(endpoint.event instanceof Array)
      {
         for(var _loc5_ in endpoint.event)
         {
            endpoint.component.__addHighPrioEventListener(endpoint.event[_loc5_],_loc4_);
         }
      }
      else
      {
         endpoint.component.__addHighPrioEventListener(endpoint.event,_loc4_);
      }
      mx.data.binding.ComponentMixins.initComponent(endpoint.component);
   }
   function setUpIndexListeners(endpoint, reverse)
   {
      var _loc3_;
      var _loc2_;
      if(endpoint.location.indices != undefined)
      {
         _loc3_ = 0;
         while(_loc3_ < endpoint.location.indices.length)
         {
            _loc2_ = endpoint.location.indices[_loc3_];
            if(_loc2_.component != undefined)
            {
               this.setUpListener(_loc2_,reverse);
               if(_loc2_.component.__indexBindings == undefined)
               {
                  _loc2_.component.__indexBindings = new Array();
               }
               _loc2_.component.__indexBindings.push({binding:this,reverse:reverse});
            }
            _loc3_ = _loc3_ + 1;
         }
      }
   }
   static function copyBinding(b)
   {
      var _loc1_ = new Object();
      _loc1_.source = mx.data.binding.Binding.copyEndPoint(b.source);
      _loc1_.dest = mx.data.binding.Binding.copyEndPoint(b.dest);
      _loc1_.format = b.format;
      _loc1_.is2way = b.is2way;
      return _loc1_;
   }
   static function copyEndPoint(e)
   {
      var _loc1_ = new Object();
      _loc1_.constant = e.constant;
      _loc1_.component = String(e.component);
      _loc1_.event = e.event;
      _loc1_.location = e.location;
      _loc1_.property = e.property;
      return _loc1_;
   }
   static function registerScreen(screen, id)
   {
      var symbol = mx.data.binding.Binding.screenRegistry[id];
      if(symbol == null)
      {
         mx.data.binding.Binding.screenRegistry[id] = {symbolPath:String(screen),bindings:[],id:id};
         return undefined;
      }
      if(symbol.symbolPath == String(screen))
      {
         return undefined;
      }
      var instancePath = String(screen);
      var i = 0;
      while(i < mx.data.binding.Binding.bindingRegistry.length)
      {
         var b = mx.data.binding.Binding.bindingRegistry[i];
         var src = mx.data.binding.Binding.copyEndPoint(b.source);
         var dst = mx.data.binding.Binding.copyEndPoint(b.dest);
         var prefix = symbol.symbolPath + ".";
         var symbolContainsSource = prefix == b.source.component.substr(0,prefix.length);
         var symbolContainsDest = prefix == b.dest.component.substr(0,prefix.length);
         if(symbolContainsSource)
         {
            if(symbolContainsDest)
            {
               src.component = eval(instancePath + src.component.substr(symbol.symbolPath.length));
               dst.component = eval(instancePath + dst.component.substr(symbol.symbolPath.length));
               new mx.data.binding.Binding(src,dst,b.format,b.is2way);
            }
            else
            {
               src.component = eval(instancePath + src.component.substr(symbol.symbolPath.length));
               dst.component = eval(dst.component);
               new mx.data.binding.Binding(src,dst,b.format,b.is2way);
            }
         }
         else if(symbolContainsDest)
         {
            src.component = eval(src.component);
            dst.component = eval(instancePath + dst.component.substr(symbol.symbolPath.length));
            new mx.data.binding.Binding(src,dst,b.format,b.is2way);
         }
         i++;
      }
   }
   static function registerBinding(binding)
   {
      var _loc1_ = mx.data.binding.Binding.copyBinding(binding);
      mx.data.binding.Binding.bindingRegistry.push(_loc1_);
   }
   static function getLocalRoot(clip)
   {
      var _loc2_;
      var _loc3_ = clip._url;
      while(clip != null)
      {
         if(clip._url != _loc3_)
         {
            break;
         }
         _loc2_ = clip;
         clip = clip._parent;
      }
      return _loc2_;
   }
}
