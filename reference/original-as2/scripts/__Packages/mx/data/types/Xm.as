class mx.data.types.Xm extends mx.data.binding.DataType
{
   var dataAccessor;
   var ignoreWhite;
   function Xm()
   {
      super();
   }
   function gettableTypes()
   {
      return ["XML"];
   }
   function settableTypes()
   {
      return ["XML","String"];
   }
   function setTypedValue(newValue)
   {
      var _loc4_ = null;
      var _loc2_ = new mx.data.binding.TypedValue();
      _loc2_.typeName = "XML";
      var _loc5_;
      if(newValue.typeName == "XML")
      {
         _loc2_.value = newValue.value;
         _loc2_.type = newValue.type;
      }
      else if(newValue.typeName == "String")
      {
         _loc5_ = new XML();
         _loc5_.ignoreWhite = this.ignoreWhite == "true";
         _loc5_.parseXML(newValue.value);
         _loc2_.value = _loc5_;
      }
      else
      {
         _loc4_ = [mx.data.binding.DataAccessor.conversionFailed(newValue,"XML")];
      }
      var _loc6_ = this.dataAccessor.setTypedValue(_loc2_);
      if(_loc4_ != null)
      {
         return _loc4_;
      }
      return _loc6_;
   }
   function validate()
   {
   }
}
