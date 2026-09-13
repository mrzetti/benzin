class mx.xpath.FilterStack
{
   var __expr;
   var __ops;
   function FilterStack(filterVal)
   {
      this.__expr = new Array();
      this.__ops = new Array();
      var _loc2_ = new mx.utils.StringTokenParser(filterVal);
      var _loc5_ = _loc2_.nextToken();
      var _loc4_;
      var _loc3_ = _loc2_.token;
      while(_loc5_ != mx.utils.StringTokenParser.tkEOF)
      {
         if(_loc3_ == "@")
         {
            _loc5_ = _loc2_.nextToken();
            _loc3_ = _loc2_.token;
            _loc4_ = new mx.xpath.FilterExpr(true,_loc3_,null);
            this.__expr.splice(0,0,_loc4_);
            if(_loc2_.nextToken() == mx.utils.StringTokenParser.tkSymbol)
            {
               if(_loc2_.token == "=")
               {
                  _loc5_ = _loc2_.nextToken();
                  _loc4_.value = _loc2_.token;
               }
            }
         }
         else if(_loc3_ == "and" || _loc3_ == "or")
         {
            this.__ops.splice(0,0,_loc3_);
         }
         else if(_loc3_ != ")" && _loc3_ != "(")
         {
            _loc4_ = new mx.xpath.FilterExpr(false,_loc3_,null);
            this.__expr.splice(0,0,_loc4_);
            if(_loc2_.nextToken() == mx.utils.StringTokenParser.tkSymbol)
            {
               if(_loc2_.token == "=")
               {
                  _loc5_ = _loc2_.nextToken();
                  _loc4_.value = _loc2_.token;
               }
            }
         }
         _loc5_ = _loc2_.nextToken();
         _loc3_ = _loc2_.token;
      }
   }
   function get exprs()
   {
      return this.__expr;
   }
   function get ops()
   {
      return this.__ops;
   }
}
