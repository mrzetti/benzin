class mx.data.kinds.Data extends mx.data.binding.DataAccessor
{
   var component;
   var location;
   var property;
   function Data()
   {
      super();
   }
   function getTypedValue(requestedType)
   {
      var _loc5_;
      var _loc2_ = this.getFieldAccessor().getValue();
      var _loc3_ = null;
      var _loc4_;
      if(_loc2_ != null)
      {
         if(_loc2_ instanceof Array)
         {
            _loc3_ = "Array";
         }
         else if(_loc2_ instanceof XMLNode || _loc2_ instanceof XMLNode)
         {
            _loc3_ = "XML";
         }
         else
         {
            _loc4_ = typeof _loc2_;
            _loc3_ = _loc4_.charAt(0).toUpperCase() + _loc4_.slice(1);
         }
      }
      else
      {
         _loc2_ = null;
      }
      _loc5_ = new mx.data.binding.TypedValue(_loc2_,_loc3_,null);
      return _loc5_;
   }
   function getGettableTypes()
   {
      return null;
   }
   function setTypedValue(newValue)
   {
      this.getFieldAccessor().setValue(newValue.value,newValue);
      return null;
   }
   function getSettableTypes()
   {
      return null;
   }
   function getFieldAccessor()
   {
      return this.component.createFieldAccessor(this.property,this.location,false);
   }
}
