class mx.data.binding.DataAccessor
{
   var component;
   var dataAccessor;
   var location;
   var property;
   var type;
   function DataAccessor()
   {
   }
   function getAnyTypedValue(suggestedTypes)
   {
      var _loc3_ = 0;
      var _loc5_;
      while(_loc3_ < suggestedTypes.length)
      {
         _loc5_ = this.getTypedValue(suggestedTypes[_loc3_]);
         if(_loc5_ != null)
         {
            return _loc5_;
         }
         _loc3_ = _loc3_ + 1;
      }
      _loc5_ = this.getTypedValue();
      _loc3_ = 0;
      var _loc2_;
      while(_loc3_ < suggestedTypes.length)
      {
         _loc2_ = suggestedTypes[_loc3_];
         if(_loc2_ == "String")
         {
            return new mx.data.binding.TypedValue(String(_loc5_.value),_loc2_);
         }
         if(_loc2_ == "Number")
         {
            return new mx.data.binding.TypedValue(Number(_loc5_.value),_loc2_);
         }
         if(_loc2_ == "Boolean")
         {
            return new mx.data.binding.TypedValue(Boolean(_loc5_.value),_loc2_);
         }
         _loc3_ = _loc3_ + 1;
      }
      return _loc5_;
   }
   function setAnyTypedValue(newValue)
   {
      var _loc7_ = this.getSettableTypes();
      if(_loc7_ == null || -1 != mx.data.binding.DataAccessor.findString(newValue.typeName,_loc7_))
      {
         return this.setTypedValue(newValue);
      }
      var _loc3_ = 0;
      var _loc2_;
      var _loc5_;
      var _loc6_;
      while(_loc3_ < _loc7_.length)
      {
         _loc2_ = _loc7_[_loc3_];
         if(_loc2_ == "String")
         {
            return this.setTypedValue(new mx.data.binding.TypedValue(String(newValue.value),_loc2_));
         }
         if(_loc2_ == "Number")
         {
            _loc5_ = Number(newValue.value);
            _loc6_ = this.setTypedValue(new mx.data.binding.TypedValue(_loc5_,_loc2_));
            if(_loc5_.toString() == "NaN")
            {
               return ["Failed to convert \'" + newValue.value + "\' to a number"];
            }
            return _loc6_;
         }
         if(_loc2_ == "Boolean")
         {
            return this.setTypedValue(new mx.data.binding.TypedValue(Boolean(newValue.value),_loc2_));
         }
         _loc3_ = _loc3_ + 1;
      }
      return this.dataAccessor.setTypedValue(newValue);
   }
   function getTypedValue(requestedType)
   {
      var _loc2_ = this.dataAccessor.getTypedValue(requestedType);
      return _loc2_;
   }
   function getGettableTypes()
   {
      return null;
   }
   function setTypedValue(newValue)
   {
      return this.dataAccessor.setTypedValue(newValue);
   }
   function getSettableTypes()
   {
      return null;
   }
   function findLastAccessor()
   {
      return this.dataAccessor != null ? this.dataAccessor.findLastAccessor() : this;
   }
   function setupDataAccessor(component, property, location)
   {
      this.component = component;
      this.property = property;
      this.location = location;
      this.type = component.findSchema(property,location);
   }
   static function findString(str, arr)
   {
      var _loc3_ = str.toLowerCase();
      var _loc1_ = 0;
      while(_loc1_ < arr.length)
      {
         if(arr[_loc1_].toLowerCase() == _loc3_)
         {
            return _loc1_;
         }
         _loc1_ = _loc1_ + 1;
      }
      return -1;
   }
   static function conversionFailed(newValue, target)
   {
      return "Failed to convert to " + target + ": \'" + newValue.value + "\'";
   }
}
