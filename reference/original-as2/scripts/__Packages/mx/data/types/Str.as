class mx.data.types.Str extends mx.data.binding.DataType
{
   var maxLength;
   var minLength;
   var validationError;
   var tooLongError = "This string is longer than the maximum allowed length.";
   var tooShortError = "This string is shorter than the minimum allowed length.";
   function Str()
   {
      super();
   }
   function getTypedValue(requestedType)
   {
      var _loc2_ = super.getTypedValue(requestedType);
      if(_loc2_.value == null && requestedType == "String")
      {
         _loc2_.value = "";
      }
      return _loc2_;
   }
   function gettableTypes()
   {
      return ["String"];
   }
   function settableTypes()
   {
      return ["String"];
   }
   function validate(value)
   {
      var _loc2_ = String(value);
      if(this.maxLength != null && _loc2_.length > this.maxLength)
      {
         this.validationError(this.tooLongError);
      }
      if(this.minLength != null && _loc2_.length < this.minLength)
      {
         this.validationError(this.tooShortError);
      }
   }
}
