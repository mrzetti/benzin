onClipEvent(load){
   function collision()
   {
      x0 = 430;
      y0 = 370;
      xx = _root.voiture.car.hit._x + x0;
      yy = _root.voiture.car.hit._y + y0;
      choc = _root.circuit.boue_mc.hitTest(xx,yy,true);
      bigchoc = _root.circuit.bighit.hitTest(xx,yy,true);
      carCrash = _root.circuit.animCar_mc.car_mc.hitTest(_root.voiture.car.hit);
      if(_root.circuit.batiment_mc.hitTest(_root.voiture.car.hit) && _root.batimentExplose == false)
      {
         _root.circuit.batiment_mc.play();
      }
      tubeCrash = _root.circuit.animTube_mc.tube_mc.hitTest(_root.voiture.car.hit);
      monospaceCrash = _root.circuit.animMonospace.monospace_mc.hitTest(_root.voiture.car.hit);
      locoCrash = _root.circuit.animTrain.train.loco.hitTest(_root.voiture.car.hit);
      wag01Crash = _root.circuit.animTrain.train.wag01.hitTest(_root.voiture.car.hit);
      wag02Crash = _root.circuit.animTrain.train.wag02.hitTest(_root.voiture.car.hit);
      wag03Crash = _root.circuit.animTrain.train.wag03.hitTest(_root.voiture.car.hit);
      wag04Crash = _root.circuit.animTrain.train.wag04.hitTest(_root.voiture.car.hit);
      if(locoCrash == true || wag01Crash == true || wag02Crash == true || wag03Crash == true || wag04Crash == true)
      {
         _root.circuit.animTrain.train.loco.play();
         _root.circuit.animTrain.train.wag01.play();
         _root.circuit.animTrain.train.wag02.play();
         _root.circuit.animTrain.train.wag03.play();
         _root.circuit.animTrain.train.wag04.play();
         _root.circuit.animTrain.stop();
         _root.speed /= 2;
      }
      if(_root.circuit.pylone1_mc.hitTest(_root.voiture.car.hit))
      {
         _root.circuit.pylone1_mc.play();
      }
      if(_root.circuit.pylone2_mc.hitTest(_root.voiture.car.hit))
      {
         _root.circuit.pylone2_mc.play();
      }
      if(_root.circuit.pylone3_mc.hitTest(_root.voiture.car.hit))
      {
         _root.circuit.pylone3_mc.play();
      }
      if(_root.circuit.pylone4_mc.hitTest(_root.voiture.car.hit))
      {
         _root.circuit.pylone4_mc.play();
      }
      if(_root.circuit.pylone5_mc.hitTest(_root.voiture.car.hit))
      {
         _root.circuit.pylone5_mc.play();
      }
      if(_root.circuit.pylone6_mc.hitTest(_root.voiture.car.hit))
      {
         _root.circuit.pylone6_mc.play();
      }
      if(_root.circuit.pylone7_mc.hitTest(_root.voiture.car.hit))
      {
         _root.circuit.pylone7_mc.play();
      }
      if(_root.circuit.pylone8_mc.hitTest(_root.voiture.car.hit))
      {
         _root.circuit.pylone8_mc.play();
      }
      if(_root.circuit.pylone9_mc.hitTest(_root.voiture.car.hit))
      {
         _root.circuit.pylone9_mc.play();
      }
      if(_root.circuit.vache1_mc.hitTest(_root.voiture.car.hit))
      {
         _root.circuit.vache1_mc.play();
      }
      if(_root.circuit.vache2_mc.hitTest(_root.voiture.car.hit))
      {
         _root.circuit.vache2_mc.play();
      }
      if(_root.circuit.vache3_mc.hitTest(_root.voiture.car.hit))
      {
         _root.circuit.vache3_mc.play();
      }
      if(_root.circuit.vache4_mc.hitTest(_root.voiture.car.hit))
      {
         _root.circuit.vache4_mc.play();
      }
      if(_root.circuit.vache5_mc.hitTest(_root.voiture.car.hit))
      {
         _root.circuit.vache5_mc.play();
      }
      if(_root.circuit.vache6_mc.hitTest(_root.voiture.car.hit))
      {
         _root.circuit.vache6_mc.play();
      }
      if(_root.circuit.vache7_mc.hitTest(_root.voiture.car.hit))
      {
         _root.circuit.vache7_mc.play();
      }
      if(_root.circuit.vache8_mc.hitTest(_root.voiture.car.hit))
      {
         _root.circuit.vache8_mc.play();
      }
      if(_root.circuit.vache9_mc.hitTest(_root.voiture.car.hit))
      {
         _root.circuit.vache9_mc.play();
      }
      if(_root.circuit.vache10_mc.hitTest(_root.voiture.car.hit))
      {
         _root.circuit.vache10_mc.play();
      }
      if(_root.circuit.vache11_mc.hitTest(_root.voiture.car.hit))
      {
         _root.circuit.vache11_mc.play();
      }
      if(_root.circuit.vache12_mc.hitTest(_root.voiture.car.hit))
      {
         _root.circuit.vache12_mc.play();
      }
      if(_root.circuit.vache13_mc.hitTest(_root.voiture.car.hit))
      {
         _root.circuit.vache13_mc.play();
      }
      if(_root.circuit.vache14_mc.hitTest(_root.voiture.car.hit))
      {
         _root.circuit.vache14_mc.play();
      }
      if(_root.circuit.vache15_mc.hitTest(_root.voiture.car.hit))
      {
         _root.circuit.vache15_mc.play();
      }
      if(_root.circuit.vache16_mc.hitTest(_root.voiture.car.hit))
      {
         _root.circuit.vache16_mc.play();
      }
      if(_root.circuit.vache17_mc.hitTest(_root.voiture.car.hit))
      {
         _root.circuit.vache17_mc.play();
      }
      if(_root.circuit.vache18_mc.hitTest(_root.voiture.car.hit))
      {
         _root.circuit.vache18_mc.play();
      }
      if(_root.circuit.vache19_mc.hitTest(_root.voiture.car.hit))
      {
         _root.circuit.vache19_mc.play();
      }
      if(_root.circuit.mouton1_mc.hitTest(_root.voiture.car.hit))
      {
         _root.circuit.mouton1_mc.play();
      }
      if(_root.circuit.mouton2_mc.hitTest(_root.voiture.car.hit))
      {
         _root.circuit.mouton2_mc.play();
      }
      if(_root.circuit.mouton3_mc.hitTest(_root.voiture.car.hit))
      {
         _root.circuit.mouton3_mc.play();
      }
      if(_root.circuit.mouton4_mc.hitTest(_root.voiture.car.hit))
      {
         _root.circuit.mouton4_mc.play();
      }
      if(_root.circuit.mouton5_mc.hitTest(_root.voiture.car.hit))
      {
         _root.circuit.mouton5_mc.play();
      }
      if(_root.circuit.mouton6_mc.hitTest(_root.voiture.car.hit))
      {
         _root.circuit.mouton6_mc.play();
      }
      if(_root.circuit.mouton7_mc.hitTest(_root.voiture.car.hit))
      {
         _root.circuit.mouton7_mc.play();
      }
      if(_root.circuit.mouton8_mc.hitTest(_root.voiture.car.hit))
      {
         _root.circuit.mouton8_mc.play();
      }
      if(_root.circuit.mouton9_mc.hitTest(_root.voiture.car.hit))
      {
         _root.circuit.mouton9_mc.play();
      }
      if(_root.circuit.mouton10_mc.hitTest(_root.voiture.car.hit))
      {
         _root.circuit.mouton10_mc.play();
      }
      if(_root.circuit.mouton11_mc.hitTest(_root.voiture.car.hit))
      {
         _root.circuit.mouton11_mc.play();
      }
      if(_root.circuit.mouton12_mc.hitTest(_root.voiture.car.hit))
      {
         _root.circuit.mouton12_mc.play();
      }
      if(_root.circuit.mouton13_mc.hitTest(_root.voiture.car.hit))
      {
         _root.circuit.mouton13_mc.play();
      }
      if(_root.circuit.mouton14_mc.hitTest(_root.voiture.car.hit))
      {
         _root.circuit.mouton14_mc.play();
      }
      if(_root.circuit.mouton15_mc.hitTest(_root.voiture.car.hit))
      {
         _root.circuit.mouton15_mc.play();
      }
      if(_root.circuit.mouton16_mc.hitTest(_root.voiture.car.hit))
      {
         _root.circuit.mouton16_mc.play();
      }
      if(_root.circuit.mouton17_mc.hitTest(_root.voiture.car.hit))
      {
         _root.circuit.mouton17_mc.play();
      }
      if(_root.circuit.mouton18_mc.hitTest(_root.voiture.car.hit))
      {
         _root.circuit.mouton18_mc.play();
      }
      if(_root.circuit.mouton19_mc.hitTest(_root.voiture.car.hit))
      {
         _root.circuit.mouton19_mc.play();
      }
      if(_root.circuit.mouton20_mc.hitTest(_root.voiture.car.hit))
      {
         _root.circuit.mouton20_mc.play();
      }
      if(_root.circuit.mouton21_mc.hitTest(_root.voiture.car.hit))
      {
         _root.circuit.mouton21_mc.play();
      }
      if(_root.circuit.mouton22_mc.hitTest(_root.voiture.car.hit))
      {
         _root.circuit.mouton22_mc.play();
      }
      if(_root.circuit.maison_mc.hitTest(_root.voiture.car.hit))
      {
         _root.circuit.maison_mc.play();
      }
      if(_root.circuit.maison1_mc.hitTest(_root.voiture.car.hit))
      {
         _root.circuit.maison1_mc.play();
      }
      if(bigchoc == true)
      {
         _root.bighit = true;
      }
      else
      {
         _root.bighit = false;
      }
      if(choc == true)
      {
         _root.hit = true;
      }
      else
      {
         _root.hit = false;
      }
      if(carCrash == true)
      {
         _root.circuit.animCar_mc.car_mc.play();
         _root.circuit._x += 2;
         _root.circuit._y -= 2;
         _root.circuit.animCar_mc.stop();
         _root.speed /= 2;
      }
      if(tubeCrash == true && _root.tubeBoom == false)
      {
         _root.tubeBoom = true;
         _root.circuit.animTube_mc.tube_mc.gotoAndPlay("boom");
         _root.circuit._y -= 2;
         _root.circuit.animTube_mc.stop();
         _root.speed /= 2;
      }
      if(monospaceCrash == true)
      {
         _root.tubeBoom = true;
         _root.circuit.animMonospace.monospace_mc.play();
         _root.circuit._x -= 2;
         _root.circuit._y += 2;
         _root.circuit.animMonospace.stop();
         _root.speed /= 2;
      }
   }
}
