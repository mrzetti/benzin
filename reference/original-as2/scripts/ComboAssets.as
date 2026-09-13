mx.controls.ComboBox.prototype.downArrowUpName = "ComboDownArrowUp";
mx.controls.ComboBox.prototype.downArrowDownName = "ComboDownArrowDown";
mx.controls.ComboBox.prototype.downArrowOverName = "ComboDownArrowOver";
mx.controls.ComboBox.prototype.downArrowDisabledName = "ComboDownArrowDisabled";
mx.controls.ComboBox.prototype.wrapDownArrowButton = false;
mx.controls.ComboBox.prototype.dropDownBorderStyle = "solid";
mx.controls.ComboBox.prototype.adjustFocusRect = function()
{
   var _loc2_ = this.getStyle("themeColor");
   if(_loc2_ == undefined)
   {
      _loc2_ = 8453965;
   }
   var _loc3_ = this._parent.focus_mc;
   _loc3_.setSize(this.width + 4,this.height + 4,{bl:0,tl:0,tr:5,br:5},100,_loc2_);
   _loc3_.move(this.x - 2,this.y - 2);
};
