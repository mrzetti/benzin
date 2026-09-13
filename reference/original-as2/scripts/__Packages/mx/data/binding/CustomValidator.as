class mx.data.binding.CustomValidator
{
   var field;
   function CustomValidator()
   {
   }
   function validate(value)
   {
   }
   function validationError(message)
   {
      this.field.validationError(message);
   }
}
