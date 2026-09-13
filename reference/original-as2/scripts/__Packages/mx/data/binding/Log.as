class mx.data.binding.Log
{
   var level;
   var name;
   static var NONE = -1;
   static var BRIEF = 0;
   static var VERBOSE = 1;
   static var DEBUG = 2;
   static var INFO = 2;
   static var WARNING = 1;
   static var ERROR = 0;
   var showDetails = false;
   var nestLevel = 0;
   function Log(logLevel, logName)
   {
      this.level = logLevel != undefined ? logLevel : mx.data.binding.Log.BRIEF;
      this.name = this.name != undefined ? this.name : "";
   }
   function logInfo(msg, level)
   {
      if(level == undefined)
      {
         level = mx.data.binding.Log.BRIEF;
      }
      this.onLog(this.getDateString() + " " + this.name + ": " + mx.data.binding.ObjectDumper.toString(msg));
   }
   function logData(target, message, info, level)
   {
      if(level == undefined)
      {
         level = mx.data.binding.Log.VERBOSE;
      }
      var _loc6_ = this.name.length <= 0 ? " " : " " + this.name + ": ";
      var _loc4_ = target != null ? target + ": " : "";
      if(_loc4_.indexOf("_level0.") == 0)
      {
         _loc4_ = _loc4_.substr(8);
      }
      var _loc3_ = this.getDateString() + _loc6_ + _loc4_ + mx.data.binding.Log.substituteIntoString(message,info,50);
      var _loc2_;
      if(this.showDetails && info != null)
      {
         _loc3_ += "\n    " + mx.data.binding.ObjectDumper.toString(info);
      }
      else
      {
         _loc2_ = 0;
         while(_loc2_ < this.nestLevel)
         {
            _loc3_ = "    " + _loc3_;
            _loc2_ = _loc2_ + 1;
         }
      }
      this.onLog(_loc3_);
   }
   function onLog(message)
   {
      trace(message);
   }
   function getDateString()
   {
      var _loc1_ = new Date();
      return _loc1_.getMonth() + 1 + "/" + _loc1_.getDate() + " " + _loc1_.getHours() + ":" + _loc1_.getMinutes() + ":" + _loc1_.getSeconds();
   }
   static function substituteIntoString(message, info, maxlen, rawDataType)
   {
      var _loc9_ = "";
      if(info == null)
      {
         return message;
      }
      var _loc11_ = message.split("<");
      if(_loc11_ == null)
      {
         return message;
      }
      _loc9_ += _loc11_[0];
      var _loc7_ = 1;
      var _loc8_;
      var _loc5_;
      var _loc1_;
      var _loc4_;
      var _loc3_;
      var _loc2_;
      var _loc6_;
      while(_loc7_ < _loc11_.length)
      {
         _loc8_ = _loc11_[_loc7_].split(">");
         _loc5_ = _loc8_[0].split(".");
         _loc1_ = info;
         _loc4_ = rawDataType;
         _loc3_ = 0;
         while(_loc3_ < _loc5_.length)
         {
            _loc2_ = _loc5_[_loc3_];
            if(_loc2_ != "")
            {
               _loc4_ = mx.data.binding.FieldAccessor.findElementType(_loc4_,_loc2_);
               _loc6_ = new mx.data.binding.FieldAccessor(null,null,_loc1_,_loc2_,_loc4_,null,null);
               _loc1_ = _loc6_.getValue();
            }
            _loc3_ = _loc3_ + 1;
         }
         if(typeof _loc1_ != "string")
         {
            _loc1_ = mx.data.binding.ObjectDumper.toString(_loc1_);
         }
         if(_loc1_.indexOf("_level0.") == 0)
         {
            _loc1_ = _loc1_.substr(8);
         }
         if(maxlen != null && _loc1_.length > maxlen)
         {
            _loc1_ = _loc1_.substr(0,maxlen) + "...";
         }
         _loc9_ += _loc1_;
         _loc9_ += _loc8_[1];
         _loc7_ = _loc7_ + 1;
      }
      var _loc14_ = _loc9_.split("&gt;");
      _loc9_ = _loc14_.join(">");
      _loc14_ = _loc9_.split("&lt;");
      _loc9_ = _loc14_.join("<");
      return _loc9_;
   }
}
