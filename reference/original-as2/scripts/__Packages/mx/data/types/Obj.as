class mx.data.types.Obj extends mx.data.binding.DataType
{
   var component;
   var location;
   var property;
   var type;
   var validationError;
   function Obj()
   {
      super();
   }
   function gettableTypes()
   {
      return ["Object"];
   }
   function settableTypes()
   {
      return [null];
   }
   function validate(value)
   {
      var _loc7_ = new Array();
      if(this.location instanceof Array)
      {
         _loc7_ = _loc7_.concat(this.location);
      }
      else if(this.location != null)
      {
         return undefined;
      }
      var _loc4_ = 0;
      var _loc2_;
      var _loc5_;
      var _loc3_;
      while(_loc4_ < this.type.elements.length)
      {
         _loc2_ = this.type.elements[_loc4_];
         if(_loc2_.name != "[n]")
         {
            _loc5_ = this.component.getField(this.property,_loc7_.concat(_loc2_.name));
            _loc3_ = _loc5_.validateAndNotify(null,true);
            for(var _loc6_ in _loc3_)
            {
               this.validationError(_loc2_.name + ":" + _loc3_[_loc6_]);
            }
         }
         _loc4_ = _loc4_ + 1;
      }
   }
}
