class mx.utils.ClassFinder
{
   function ClassFinder()
   {
   }
   static function findClass(fullClassName)
   {
      if(fullClassName == null)
      {
         return null;
      }
      var _loc3_ = _global;
      var _loc4_ = fullClassName.split(".");
      var _loc2_ = 0;
      while(_loc2_ < _loc4_.length)
      {
         _loc3_ = _loc3_[_loc4_[_loc2_]];
         _loc2_ = _loc2_ + 1;
      }
      if(_loc3_ == null)
      {
         _global.__dataLogger.logData(null,"Could not find class \'<classname>\'",{classname:fullClassName},mx.data.binding.Log.BRIEF);
      }
      return _loc3_;
   }
}
