class mx.utils.StringFormatter
{
   var __extractToken;
   var __format;
   var __infuseToken;
   var __tokenInfo;
   function StringFormatter(format, tokens, extractTokenFunc, infuseTokenFunc)
   {
      this.setFormat(format,tokens);
      this.__extractToken = extractTokenFunc;
      this.__infuseToken = infuseTokenFunc;
   }
   function extractValue(formattedData, result)
   {
      var _loc3_;
      var _loc2_;
      if(result != null)
      {
         _loc3_ = null;
         _loc2_ = 0;
         while(_loc2_ < this.__tokenInfo.length)
         {
            _loc3_ = this.__tokenInfo[_loc2_];
            this.__infuseToken(formattedData.substring(_loc3_.begin,_loc3_.end),_loc3_,result);
            _loc2_ = _loc2_ + 1;
         }
      }
   }
   function formatValue(value)
   {
      var _loc5_ = "";
      var _loc3_;
      var _loc4_;
      var _loc2_;
      if(value != null)
      {
         _loc3_ = this.__tokenInfo[0];
         _loc5_ = this.__format.substring(0,_loc3_.begin) + this.__extractToken(value,_loc3_);
         _loc4_ = _loc3_;
         _loc2_ = 1;
         while(_loc2_ < this.__tokenInfo.length)
         {
            _loc3_ = this.__tokenInfo[_loc2_];
            _loc5_ += this.__format.substring(_loc4_.end,_loc3_.begin) + this.__extractToken(value,_loc3_);
            _loc4_ = _loc3_;
            _loc2_ = _loc2_ + 1;
         }
      }
      return _loc5_;
   }
   function getFormat()
   {
      return this.__format;
   }
   function setFormat(format, tokens)
   {
      function compareValues(a, b)
      {
         if(a.begin < b.begin)
         {
            return -1;
         }
         if(a.begin > b.begin)
         {
            return 1;
         }
         return 0;
      }
      var _loc5_;
      var _loc4_;
      var _loc3_;
      var _loc7_;
      var _loc2_;
      if(format != this.__format)
      {
         this.__format = format;
         _loc5_ = tokens.split(",");
         this.__tokenInfo = new Array();
         _loc4_ = 0;
         _loc3_ = 0;
         _loc7_ = 0;
         _loc2_ = 0;
         while(_loc2_ < _loc5_.length)
         {
            _loc4_ = format.indexOf(_loc5_[_loc2_]);
            if(_loc4_ >= 0 && _loc4_ < format.length)
            {
               _loc3_ = format.lastIndexOf(_loc5_[_loc2_]);
               _loc3_ = _loc3_ < 0 ? _loc4_ + 1 : _loc3_ + 1;
               this.__tokenInfo.splice(_loc7_,0,{token:_loc5_[_loc2_],begin:_loc4_,end:_loc3_});
               _loc7_ = _loc7_ + 1;
            }
            _loc2_ = _loc2_ + 1;
         }
         this.__tokenInfo.sort(compareValues);
      }
   }
}
