class mx.data.binding.ObjectDumper
{
   var inProgress;
   function ObjectDumper()
   {
      this.inProgress = new Array();
   }
   static function toString(obj, showFunctions, showUndefined, showXMLstructures, maxLineLength, indent)
   {
      var _loc3_ = new mx.data.binding.ObjectDumper();
      if(maxLineLength == undefined)
      {
         maxLineLength = 100;
      }
      if(indent == undefined)
      {
         indent = 0;
      }
      return _loc3_.realToString(obj,showFunctions,showUndefined,showXMLstructures,maxLineLength,indent);
   }
   function realToString(obj, showFunctions, showUndefined, showXMLstructures, maxLineLength, indent)
   {
      var _loc8_ = 0;
      while(_loc8_ < this.inProgress.length)
      {
         if(this.inProgress[_loc8_] == obj)
         {
            return "***";
         }
         _loc8_ = _loc8_ + 1;
      }
      this.inProgress.push(obj);
      indent = indent + 1;
      var _loc16_ = typeof obj;
      var _loc5_;
      var _loc4_;
      var _loc15_;
      var _loc9_;
      var _loc3_;
      var _loc6_;
      var _loc7_;
      if(obj instanceof XMLNode && showXMLstructures != true)
      {
         _loc5_ = obj.toString();
      }
      else if(obj instanceof Date)
      {
         _loc5_ = obj.toString();
      }
      else if(_loc16_ == "object")
      {
         _loc4_ = new Array();
         if(obj instanceof Array)
         {
            _loc5_ = "[";
            _loc15_ = 0;
            while(_loc15_ < obj.length)
            {
               _loc4_.push(_loc15_);
               _loc15_ = _loc15_ + 1;
            }
         }
         else
         {
            _loc5_ = "{";
            for(_loc15_ in obj)
            {
               _loc4_.push(_loc15_);
            }
            _loc4_.sort();
         }
         _loc9_ = "";
         _loc3_ = 0;
         while(_loc3_ < _loc4_.length)
         {
            _loc6_ = obj[_loc4_[_loc3_]];
            _loc7_ = true;
            if(typeof _loc6_ == "function")
            {
               _loc7_ = showFunctions == true;
            }
            if(typeof _loc6_ == "undefined")
            {
               _loc7_ = showUndefined == true;
            }
            if(_loc7_)
            {
               _loc5_ += _loc9_;
               if(!(obj instanceof Array))
               {
                  _loc5_ += _loc4_[_loc3_] + ": ";
               }
               _loc5_ += this.realToString(_loc6_,showFunctions,showUndefined,showXMLstructures,maxLineLength,indent);
               _loc9_ = ", `";
            }
            _loc3_ = _loc3_ + 1;
         }
         if(obj instanceof Array)
         {
            _loc5_ += "]";
         }
         else
         {
            _loc5_ += "}";
         }
      }
      else if(_loc16_ == "function")
      {
         _loc5_ = "function";
      }
      else if(_loc16_ == "string")
      {
         _loc5_ = "\"" + obj + "\"";
      }
      else
      {
         _loc5_ = String(obj);
      }
      if(_loc5_ == "undefined")
      {
         _loc5_ = "-";
      }
      this.inProgress.pop();
      return mx.data.binding.ObjectDumper.replaceAll(_loc5_,"`",_loc5_.length >= maxLineLength ? "\n" + this.doIndent(indent) : "");
   }
   static function replaceAll(str, from, to)
   {
      var _loc3_ = str.split(from);
      var _loc4_ = "";
      var _loc2_ = "";
      var _loc1_ = 0;
      while(_loc1_ < _loc3_.length)
      {
         _loc4_ += _loc2_ + _loc3_[_loc1_];
         _loc2_ = to;
         _loc1_ = _loc1_ + 1;
      }
      return _loc4_;
   }
   function doIndent(indent)
   {
      var _loc2_ = "";
      var _loc1_ = 0;
      while(_loc1_ < indent)
      {
         _loc2_ += "     ";
         _loc1_ = _loc1_ + 1;
      }
      return _loc2_;
   }
}
