class mx.data.binding.DataType extends mx.data.binding.DataAccessor
{
   var component;
   var dataAccessor;
   var encoder;
   var errorArray;
   var formatter;
   var kind;
   var location;
   var property;
   var type;
   function DataType()
   {
      super();
      this.errorArray = null;
   }
   function setupDataAccessor(component, property, location)
   {
      super.setupDataAccessor(component,property,location);
      this.type = component.findSchema(property,location);
      if(this.type.kind != undefined)
      {
         this.kind = mx.data.binding.Binding.getRuntimeObject(this.type.kind);
      }
      else
      {
         this.kind = new mx.data.kinds.Data();
      }
      this.kind.setupDataAccessor(component,property,location);
      this.dataAccessor = this.kind;
      if(this.type.encoder != undefined)
      {
         this.encoder = mx.data.binding.Binding.getRuntimeObject(this.type.encoder);
         this.encoder.setupDataAccessor(component,property,location);
         this.encoder.dataAccessor = this.dataAccessor;
         this.dataAccessor = this.encoder;
      }
      if(this.type.formatter != undefined)
      {
         this.formatter = mx.data.binding.Binding.getRuntimeObject(this.type.formatter);
         this.formatter.setupDataAccessor(component,property,location);
         this.formatter.dataAccessor = this.dataAccessor;
      }
   }
   function getAsBoolean()
   {
      var _loc2_ = this.getAnyTypedValue(["Boolean"]);
      return _loc2_.value;
   }
   function getAsNumber()
   {
      var _loc2_ = this.getAnyTypedValue(["Number"]);
      return _loc2_.value;
   }
   function getAsString()
   {
      var _loc2_ = this.getAnyTypedValue(["String"]);
      return _loc2_.value;
   }
   function setAsBoolean(newValue)
   {
      this.setAnyTypedValue(new mx.data.binding.TypedValue(newValue,"Boolean"));
   }
   function setAsNumber(newValue)
   {
      this.setAnyTypedValue(new mx.data.binding.TypedValue(newValue,"Number"));
   }
   function setAsString(newValue)
   {
      this.setAnyTypedValue(new mx.data.binding.TypedValue(newValue,"String"));
   }
   function validationError(errorMessage)
   {
      if(this.errorArray == null)
      {
         this.errorArray = new Array();
      }
      this.errorArray.push(errorMessage);
   }
   function validate(value)
   {
   }
   function getTypedValue(requestedType)
   {
      var _loc2_;
      if(requestedType == "String" && this.formatter != null)
      {
         _loc2_ = this.formatter.getTypedValue(requestedType);
      }
      else
      {
         _loc2_ = this.dataAccessor.getTypedValue(requestedType);
         if(_loc2_.type == null)
         {
            _loc2_.type = this.type;
         }
         if(_loc2_.typeName == null)
         {
            _loc2_.typeName = this.type.name;
         }
      }
      if(_loc2_.typeName != requestedType && requestedType != null)
      {
         _loc2_ = null;
      }
      return _loc2_;
   }
   function getGettableTypes()
   {
      var _loc2_ = new Array();
      var _loc3_ = this.gettableTypes();
      if(_loc3_ != null)
      {
         _loc2_ = _loc2_.concat(_loc3_);
      }
      if(this.type.name != null)
      {
         _loc2_ = _loc2_.concat(this.type.name);
      }
      if(this.formatter != null)
      {
         _loc2_ = _loc2_.concat(this.formatter.getGettableTypes());
      }
      if(_loc2_.length == 0)
      {
         return null;
      }
      return _loc2_;
   }
   function setTypedValue(newValue)
   {
      if(newValue.typeName == "String" && this.formatter != null)
      {
         return this.formatter.setTypedValue(newValue);
      }
      var _loc3_ = this.dataAccessor.getSettableTypes();
      if(_loc3_ == null || -1 != mx.data.binding.DataAccessor.findString(newValue.typeName,_loc3_))
      {
         return this.dataAccessor.setTypedValue(newValue);
      }
      return ["Can\'t set a value of type " + newValue.typeName];
   }
   function getSettableTypes()
   {
      var _loc2_ = new Array();
      var _loc3_ = this.settableTypes();
      if(_loc3_ != null)
      {
         _loc2_ = _loc2_.concat(_loc3_);
      }
      if(this.type.name != null)
      {
         _loc2_ = _loc2_.concat(this.type.name);
      }
      if(this.formatter != null)
      {
         _loc2_ = _loc2_.concat(this.formatter.getSettableTypes());
      }
      if(_loc2_.length == 0)
      {
         return null;
      }
      return _loc2_;
   }
   function gettableTypes()
   {
      return this.dataAccessor.getGettableTypes();
   }
   function settableTypes()
   {
      return this.dataAccessor.getSettableTypes();
   }
   function validateAndNotify(returnData, noEvent, initialMessages)
   {
      var _loc4_ = false;
      this.errorArray = null;
      for(var _loc6_ in initialMessages)
      {
         this.validationError(initialMessages[_loc6_]);
         _loc4_ = true;
      }
      var _loc7_ = this.getTypedValue();
      var _loc8_;
      if(_loc7_.value == null || _loc7_.value == "")
      {
         if(this.type.required == false)
         {
            _global.__dataLogger.logData(this.component,"Validation of null value succeeded because field \'<property>/<m_location>\' is not required",this);
         }
         else
         {
            _loc8_ = this.location != null ? ":" + String(this.location) : "";
            this.validationError("Required item \'" + this.property + _loc8_ + "\' is missing");
            _loc4_ = true;
         }
      }
      else
      {
         this.validate(_loc7_.value);
         _loc4_ = true;
      }
      var _loc5_;
      if(_loc4_ && noEvent != true)
      {
         _loc5_ = new Object();
         _loc5_.type = this.errorArray != null ? "invalid" : "valid";
         _loc5_.property = this.property;
         _loc5_.location = this.location;
         _loc5_.messages = this.errorArray;
         this.component.dispatchEvent(_loc5_);
         returnData.event = _loc5_;
      }
      return this.errorArray;
   }
}
