class mx.data.binding.DateBase extends mx.data.binding.DataAccessor
{
   var dataAccessor;
   function DateBase()
   {
      super();
   }
   function internalToExternal(rawValue)
   {
      return null;
   }
   function externalToInternal(value)
   {
      return null;
   }
   function externalTypeName()
   {
      return null;
   }
   function internalTypeName()
   {
      return null;
   }
   function getTypedValue(requestedType)
   {
      var _loc3_;
      var _loc4_;
      var _loc2_;
      if(requestedType == this.externalTypeName() || requestedType == null)
      {
         _loc4_ = this.dataAccessor.getTypedValue();
         _loc2_ = this.internalToExternal(_loc4_.value);
         _loc3_ = new mx.data.binding.TypedValue(_loc2_,this.externalTypeName());
      }
      return _loc3_;
   }
   function getGettableTypes()
   {
      return [this.externalTypeName()];
   }
   function setTypedValue(newValue)
   {
      var _loc4_;
      var _loc3_;
      var _loc5_;
      if(newValue.typeName == this.externalTypeName() || newValue.typeName == null)
      {
         _loc4_ = this.externalToInternal(newValue.value);
         if(!_loc4_)
         {
            _loc3_ = [mx.data.binding.DataAccessor.conversionFailed(newValue,this.internalTypeName())];
         }
         _loc5_ = this.dataAccessor.setTypedValue(new mx.data.binding.TypedValue(_loc4_,this.internalTypeName()));
         if(_loc3_)
         {
            return _loc3_;
         }
         return _loc5_;
      }
      return [mx.data.binding.DataAccessor.conversionFailed(newValue,this.internalTypeName())];
   }
   function getSettableTypes()
   {
      return [this.externalTypeName()];
   }
   static function extractTokenDate(value, tokenInfo)
   {
      var _loc1_ = "";
      var _loc5_;
      var _loc6_;
      var _loc3_;
      var _loc8_;
      var _loc7_;
      var _loc4_;
      if(value != null)
      {
         switch(tokenInfo.token)
         {
            case "M":
               _loc5_ = value.getMonth() + 1;
               if(_loc5_ < 10)
               {
                  _loc1_ += "0";
               }
               _loc1_ += _loc5_.toString();
               break;
            case "Y":
               _loc6_ = value.getFullYear().toString();
               if(tokenInfo.end - tokenInfo.begin < 3)
               {
                  _loc1_ = _loc6_.substr(2);
               }
               else
               {
                  _loc1_ = _loc6_;
               }
               break;
            case "D":
               _loc3_ = value.getDate();
               if(_loc3_ < 10)
               {
                  _loc1_ += "0";
               }
               _loc1_ += _loc3_.toString();
               break;
            case "H":
               _loc8_ = value.getHours();
               if(_loc8_ < 10)
               {
                  _loc1_ += "0";
               }
               _loc1_ += _loc8_.toString();
               break;
            case "N":
               _loc7_ = value.getMinutes();
               if(_loc7_ < 10)
               {
                  _loc1_ += "0";
               }
               _loc1_ += _loc7_.toString();
               break;
            case "S":
               _loc4_ = value.getSeconds();
               if(_loc4_ < 10)
               {
                  _loc1_ += "0";
               }
               _loc1_ += _loc4_.toString();
         }
      }
      return _loc1_;
   }
   static function infuseTokenDate(tkData, tk, value)
   {
      if(tkData.length > 0)
      {
         switch(tk.token)
         {
            case "M":
               value.setMonth(Number(tkData) - 1);
               break;
            case "D":
               value.setDate(Number(tkData));
               break;
            case "Y":
               value.setYear(Number(tkData));
               break;
            case "H":
               value.setHours(Number(tkData));
               break;
            case "N":
               value.setMinutes(Number(tkData));
               break;
            case "S":
               value.setSeconds(Number(tkData));
            default:
               return;
         }
      }
   }
}
