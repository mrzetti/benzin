class mx.data.types.DataProvider extends mx.data.binding.DataType
{
   var component;
   var dataAccessor;
   var property;
   function DataProvider()
   {
      super();
   }
   function gettableTypes()
   {
      return ["DataProvider"];
   }
   function settableTypes()
   {
      return ["DataProvider","Array","String","Object"];
   }
   function setTypedValue(newValue)
   {
      var _loc4_ = null;
      var _loc3_ = new mx.data.binding.TypedValue();
      _loc3_.typeName = "DataProvider";
      if(newValue.typeName == "DataProvider")
      {
         _loc3_.value = newValue.value;
         _loc3_.type = newValue.type;
      }
      else if(newValue.typeName == "Array")
      {
         _loc3_.value = mx.data.binding.FieldAccessor.wrapArray(newValue.value,newValue.type.elements[0].type,this.component.getBindingMetaData("acceptedTypes")[this.property]);
         _loc3_.type = newValue.type;
      }
      else if(newValue.typeName == "String")
      {
         _loc3_.value = newValue.value.split(",");
      }
      else if(newValue.typeName == "Object")
      {
         _loc3_.value = newValue.value;
         _loc3_.type = newValue.type;
      }
      else
      {
         _loc4_ = [mx.data.binding.DataAccessor.conversionFailed(newValue,"DataProvider")];
      }
      if(typeof _loc3_.value.editField != "function")
      {
         this.component.__setReadOnly(true);
      }
      var _loc5_ = this.dataAccessor.setTypedValue(_loc3_);
      if(_loc4_ != null)
      {
         return _loc4_;
      }
      return _loc5_;
   }
   function validate()
   {
   }
}
