class mx.xpath.FilterExpr
{
   var __attr = false;
   var __value = null;
   var __name = null;
   function FilterExpr(attrInit, nameInit, valueInit)
   {
      this.__attr = attrInit;
      this.__name = nameInit;
      this.__value = valueInit;
   }
   function get attr()
   {
      return this.__attr;
   }
   function set attr(newVal)
   {
      this.__attr = newVal;
   }
   function get name()
   {
      return this.__name;
   }
   function set name(newVal)
   {
      this.__name = newVal;
   }
   function get value()
   {
      return this.__value;
   }
   function set value(newVal)
   {
      this.__value = newVal;
   }
}
