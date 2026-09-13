Stage.showMenu = false;
pays_xc.trigger();
pays_cb.visible = false;
barre_mc.onEnterFrame = function()
{
   var _loc3_ = _level0.getBytesTotal();
   var _loc2_ = _level0.getBytesLoaded();
   var _loc4_ = 100 * (_loc2_ / _loc3_);
   var _loc1_ = Math.round(_loc4_);
   pourcent.text = _loc1_ + " %";
   if(_loc1_ < 100)
   {
      barre_mc._xscale = _loc1_;
   }
   else if(_loc1_ >= 100)
   {
      play();
   }
};
stop();
