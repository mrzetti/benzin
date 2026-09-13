_quality = "HIGH";
pays_cb.visible = false;
path = "benzin1.flv";
var dejalu = 0;
var boucle = 1;
var buffer = 8;
var statut = "on";
var netConn = new NetConnection();
netConn.connect(null);
var netStream = new NetStream(netConn);
ma_video.attachVideo(netStream);
netStream.setBufferTime(buffer);
_global.lecture = function()
{
   foreground_mc.gotoAndStop(1);
   logo_mc.gotoAndPlay(1);
   txt_mc._x = 28;
   statut = "on";
   netStream.play(path);
};
_global.arret = function()
{
   arret_btn._x = -100;
   netStream.close();
   foreground_mc.gotoAndPlay("arret");
   logo_mc.gotoAndPlay("arret");
   txt_mc._x = -1000;
};
arret_btn.onPress = function()
{
   if(statut == "on")
   {
      effet_mc.gotoAndPlay("arret");
      this._x = -100;
      statut = "off";
   }
};
lire_btn.onPress = function()
{
   if(statut == "off")
   {
      effet_mc.gotoAndPlay("lire");
      this._x = -100;
   }
};
lecture();
stop();
