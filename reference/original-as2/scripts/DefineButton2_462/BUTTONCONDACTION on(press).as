on(press){
   if(_root.Volume == 100)
   {
      _root.Volume = 50;
      _root.introZic.setVolume(50);
      _root.sound_mc.gotoAndStop(2);
   }
   else if(_root.Volume == 50)
   {
      _root.Volume = 0;
      _root.introZic.setVolume(0);
      _root.sound_mc.gotoAndStop(3);
   }
   else if(_root.Volume == 0)
   {
      _root.Volume = 100;
      _root.introZic.setVolume(100);
      _root.sound_mc.gotoAndStop(1);
   }
}
