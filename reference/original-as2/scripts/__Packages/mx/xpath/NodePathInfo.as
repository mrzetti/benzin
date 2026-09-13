class mx.xpath.NodePathInfo
{
   var __nodeName = null;
   var __filter = null;
   function NodePathInfo(nodeName, filter)
   {
      this.__nodeName = nodeName;
      this.__filter = filter;
   }
   function get nodeName()
   {
      return this.__nodeName;
   }
   function get filter()
   {
      return this.__filter;
   }
}
