onClipEvent(enterFrame){
   if(Key.isDown(38))
   {
      angle = _root.voiture._rotation;
      angleradians = _root.voiture._rotation * 0.017453292519943295;
      xSpeed -= _root.poussee * Math.sin(angleradians);
      ySpeed -= _root.poussee * Math.cos(angleradians);
   }
   else
   {
      xSpeed *= 0.9999999999;
      ySpeed *= 0.9999999999;
   }
   if(Key.isDown(40))
   {
      _root.voiture.car.gotoAndStop("frein");
      angle = _root.voiture._rotation;
      angleradians = _root.voiture._rotation * 0.017453292519943295;
      xSpeed += _root.poussee_arriere * Math.sin(angleradians);
      ySpeed += _root.poussee_arriere * Math.cos(angleradians);
   }
   else
   {
      xSpeed *= _root.inertie;
      ySpeed *= _root.inertie;
   }
   if(_root.bighit != true)
   {
      _root.speed = Math.sqrt(xSpeed * xSpeed + ySpeed * ySpeed);
      _root.inertie = _root.inertieinit;
   }
   else
   {
      _Y = _Y - (- ySpeed) * 5;
      _X = _X + (- xSpeed) * 5;
   }
   if(_root.hit != true)
   {
      _root.speed = Math.sqrt(xSpeed * xSpeed + ySpeed * ySpeed);
      _root.inertie = _root.inertieinit;
   }
   else
   {
      _root.speed = Math.sqrt(xSpeed * xSpeed + ySpeed * ySpeed) / 2;
      _root.inertie = 0.8;
   }
   if(_root.speed >= _root.maxSpeed)
   {
      _root.speed = _root.maxSpeed;
   }
   _Y = _Y - ySpeed;
   _X = _X + xSpeed;
}
