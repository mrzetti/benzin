mx.controls.RadioButton.prototype.adjustFocusRect = function()
{
   var _loc4_ = this._parent.focus_mc;
   var _loc2_ = this.iconName;
   var _loc3_ = this.getStyle("themeColor");
   if(_loc3_ == undefined)
   {
      _loc3_ = 8453965;
   }
   var _loc5_ = _loc2_._width + 4;
   var _loc6_ = _loc2_._height + 4;
   _loc4_.setSize(_loc5_,_loc6_,8,100,_loc3_);
   var _loc8_ = _loc2_._x;
   var _loc7_ = _loc2_._y;
   _loc4_.move(this.x - 2 + _loc8_,this.y + _loc7_ - 2);
};
