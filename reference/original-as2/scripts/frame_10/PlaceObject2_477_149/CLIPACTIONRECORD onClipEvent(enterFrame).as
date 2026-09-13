onClipEvent(enterFrame){
   if(Key.isDown(39))
   {
      if(Math.abs(_root.speed) > 0.1)
      {
         if(_root.right == false)
         {
            _root.voiture.car.gotoAndPlay("right");
         }
         _rotation = _rotation + _root.rotation * Math.sqrt(_root.speed);
         _root.anglecar = _rotation;
         _root.ombre._rotation += _root.rotation * Math.sqrt(_root.speed);
      }
   }
   else
   {
      _root.right = false;
   }
   if(Key.isDown(37))
   {
      if(Math.abs(_root.speed) > 0.1)
      {
         if(_root.left == false)
         {
            _root.voiture.car.gotoAndPlay("left");
         }
         _rotation = _rotation - _root.rotation * Math.sqrt(_root.speed);
         _root.anglecar = _rotation;
         _root.ombre._rotation -= _root.rotation * Math.sqrt(_root.speed);
      }
   }
   else
   {
      _root.left = false;
   }
   collision();
}
