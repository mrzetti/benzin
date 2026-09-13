class mx.utils.StringTokenParser
{
   var _skipChars;
   var _source;
   static var tkEOF = -1;
   static var tkSymbol = 0;
   static var tkString = 1;
   static var tkInteger = 2;
   static var tkFloat = 3;
   var _index = 0;
   var _token = "";
   function StringTokenParser(source, skipChars)
   {
      this._source = source;
      this._skipChars = skipChars != undefined ? skipChars : null;
   }
   function get token()
   {
      return this._token;
   }
   function getPos()
   {
      return this._index;
   }
   function nextToken()
   {
      var _loc4_;
      var _loc2_;
      var _loc3_ = this._source.length;
      this.skipBlanks();
      if(this._index >= _loc3_)
      {
         return mx.utils.StringTokenParser.tkEOF;
      }
      _loc2_ = this._source.charCodeAt(this._index);
      if(_loc2_ >= 65 && _loc2_ <= 90 || _loc2_ >= 97 && _loc2_ <= 122 || _loc2_ >= 192 && _loc2_ <= Infinity || _loc2_ == 95)
      {
         _loc4_ = this._index;
         this._index = this._index + 1;
         _loc2_ = this._source.charCodeAt(this._index);
         while((_loc2_ >= 65 && _loc2_ <= 90 || _loc2_ >= 97 && _loc2_ <= 122 || _loc2_ >= 48 && _loc2_ <= 57 || _loc2_ >= 192 && _loc2_ <= Infinity || _loc2_ == 95) && this._index < _loc3_)
         {
            this._index = this._index + 1;
            _loc2_ = this._source.charCodeAt(this._index);
         }
         this._token = this._source.substring(_loc4_,this._index);
         return mx.utils.StringTokenParser.tkSymbol;
      }
      if(_loc2_ == 34 || _loc2_ == 39)
      {
         this._index = this._index + 1;
         _loc4_ = this._index;
         _loc2_ = this._source.charCodeAt(_loc4_);
         while(_loc2_ != 34 && _loc2_ != 39 && this._index < _loc3_)
         {
            this._index = this._index + 1;
            _loc2_ = this._source.charCodeAt(this._index);
         }
         this._token = this._source.substring(_loc4_,this._index);
         this._index = this._index + 1;
         return mx.utils.StringTokenParser.tkString;
      }
      var _loc5_;
      if(_loc2_ == 45 || _loc2_ >= 48 && _loc2_ <= 57)
      {
         _loc5_ = mx.utils.StringTokenParser.tkInteger;
         _loc4_ = this._index;
         this._index = this._index + 1;
         _loc2_ = this._source.charCodeAt(this._index);
         while(_loc2_ >= 48 && _loc2_ <= 57 && this._index < _loc3_)
         {
            this._index = this._index + 1;
            _loc2_ = this._source.charCodeAt(this._index);
         }
         if(this._index < _loc3_)
         {
            if(_loc2_ >= 48 && _loc2_ <= 57 || _loc2_ == 46 || _loc2_ == 43 || _loc2_ == 45 || _loc2_ == 101 || _loc2_ == 69)
            {
               _loc5_ = mx.utils.StringTokenParser.tkFloat;
            }
            while((_loc2_ >= 48 && _loc2_ <= 57 || _loc2_ == 46 || _loc2_ == 43 || _loc2_ == 45 || _loc2_ == 101 || _loc2_ == 69) && this._index < _loc3_)
            {
               this._index = this._index + 1;
               _loc2_ = this._source.charCodeAt(this._index);
            }
         }
         this._token = this._source.substring(_loc4_,this._index);
         return _loc5_;
      }
      this._token = this._source.charAt(this._index);
      this._index = this._index + 1;
      return mx.utils.StringTokenParser.tkSymbol;
   }
   function skipBlanks()
   {
      var _loc2_;
      if(this._index < this._source.length)
      {
         _loc2_ = this._source.charAt(this._index);
         while(_loc2_ == " " || this._skipChars != null && this.skipChar(_loc2_))
         {
            this._index = this._index + 1;
            _loc2_ = this._source.charAt(this._index);
         }
      }
   }
   function skipChar(ch)
   {
      var _loc2_ = 0;
      while(_loc2_ < this._skipChars.length)
      {
         if(ch == this._skipChars[_loc2_])
         {
            return true;
         }
         _loc2_ = _loc2_ + 1;
      }
      return false;
   }
}
