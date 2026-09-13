class mx.data.formatters.NumberFormatter extends mx.data.binding.Formatter
{
   var dataAccessor;
   var isInt;
   var precision;
   function NumberFormatter()
   {
      super();
   }
   function getTypedValue(requestedType)
   {
      var _loc3_;
      var _loc2_;
      var _loc6_;
      var _loc5_;
      var _loc4_;
      if(requestedType == "String" || requestedType == null)
      {
         _loc3_ = this.dataAccessor.getTypedValue();
         if(_loc3_.value != null)
         {
            if(this.precision > 0)
            {
               _loc6_ = !this.isInt ? Math.pow(10,this.precision) : 1;
               _loc2_ = (Math.round(_loc3_.value * _loc6_) / _loc6_).toString();
               if(_loc2_.length > 0)
               {
                  _loc5_ = _loc2_.lastIndexOf(".");
                  _loc4_ = 0;
                  if(_loc5_ < 0)
                  {
                     _loc2_ += ".";
                     _loc4_ = this.precision;
                  }
                  else
                  {
                     _loc4_ = this.precision - (_loc2_.length - (_loc5_ + 1));
                  }
                  _loc2_ += "0000000000000000000000000000".substring(0,_loc4_);
               }
            }
            else
            {
               _loc2_ = Math.round(_loc3_.value).toString();
            }
            return new mx.data.binding.TypedValue(_loc2_,"String");
         }
         return new mx.data.binding.TypedValue("","String");
      }
   }
   function getGettableTypes()
   {
      return ["String"];
   }
   function setTypedValue(newValue)
   {
      var _loc3_;
      var _loc4_;
      if(newValue.typeName == "String")
      {
         if(newValue.value.length == 0)
         {
            return this.dataAccessor.setTypedValue(new mx.data.binding.TypedValue(null,"Number"));
         }
         _loc3_ = mx.data.types.Num.convertStringToNumber(this.isInt,newValue);
         _loc4_ = this.dataAccessor.setTypedValue(newValue);
         return _loc3_ != null ? _loc3_ : _loc4_;
      }
      return [mx.data.binding.DataAccessor.conversionFailed(newValue,"Number")];
   }
   function getSettableTypes()
   {
      return ["String"];
   }
}
