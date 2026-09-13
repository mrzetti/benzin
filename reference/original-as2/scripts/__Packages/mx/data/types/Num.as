class mx.data.types.Num extends mx.data.binding.DataType
{
   var dataAccessor;
   var formatter;
   var maxValue;
   var minValue;
   var type;
   var validationError;
   var exceedsMaxError = "This number exceeds the maximum allowed value.";
   var lowerThanMinError = "This number is lower than the minimum allowed value.";
   var integerError = "This number must be an integer.";
   var int = false;
   function Num()
   {
      super();
   }
   function gettableTypes()
   {
      return ["Number","Integer","String"];
   }
   function getTypedValue(requestedType)
   {
      var _loc2_;
      if(requestedType == "String")
      {
         if(this.formatter != null)
         {
            if(this.formatter instanceof mx.data.formatters.NumberFormatter)
            {
               mx.data.formatters.NumberFormatter(this.formatter).isInt = this.int;
            }
            _loc2_ = this.formatter.getTypedValue(requestedType);
         }
         else
         {
            _loc2_ = this.dataAccessor.getTypedValue();
            if(_loc2_.value == null)
            {
               _loc2_.value = "";
               _loc2_.typeName = "String";
            }
         }
      }
      else
      {
         if(requestedType == "Integer")
         {
            requestedType = "Number";
         }
         _loc2_ = this.dataAccessor.getTypedValue(requestedType);
         if(_loc2_.type == null)
         {
            _loc2_.type = this.type;
         }
         if(_loc2_.typeName == null)
         {
            _loc2_.typeName = this.type.name;
         }
         if(_loc2_.typeName != requestedType && requestedType != null)
         {
            _loc2_ = null;
         }
         if(_loc2_.value != null && this.int)
         {
            _loc2_.value = Math.round(_loc2_.value);
         }
      }
      return _loc2_;
   }
   function settableTypes()
   {
      return ["Number","Integer","String","Boolean",null];
   }
   function setTypedValue(newValue)
   {
      var _loc3_;
      var _loc4_;
      if(newValue.value != null)
      {
         if(newValue.typeName == "String")
         {
            if(this.formatter != null)
            {
               return this.formatter.setTypedValue(newValue);
            }
            if(newValue.value.length == 0)
            {
               newValue.value = null;
               newValue.typeName = "Number";
               _loc3_ = this.dataAccessor.setTypedValue(newValue);
            }
            else
            {
               _loc4_ = mx.data.types.Num.convertStringToNumber(this.int,newValue);
               _loc3_ = this.dataAccessor.setTypedValue(newValue);
            }
            return _loc4_ != null ? _loc4_ : _loc3_;
         }
         if(this.int)
         {
            newValue.value = Math.round(newValue.value);
         }
      }
      return this.dataAccessor.setTypedValue(newValue);
   }
   static function convertStringToNumber(isInt, newValue)
   {
      newValue.typeName = !isInt ? "Number" : "Integer";
      if(isInt)
      {
         newValue.value = parseInt(newValue.value);
      }
      else
      {
         newValue.value = parseFloat(newValue.value);
      }
      if(isNaN(newValue.value))
      {
         newValue.value = 0;
         return [mx.data.binding.DataAccessor.conversionFailed(newValue,!isInt ? "Number" : "Integer")];
      }
      return null;
   }
   function validate(value)
   {
      var _loc2_ = Number(value);
      if(this.maxValue != null && _loc2_ > this.maxValue)
      {
         this.validationError(this.exceedsMaxError);
      }
      if(this.minValue != null && _loc2_ < this.minValue)
      {
         this.validationError(this.lowerThanMinError);
      }
      if(this.int && _loc2_ != Math.round(_loc2_))
      {
         this.validationError(this.integerError);
      }
   }
}
