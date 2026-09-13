centiemes = (getTimer() - _root.t0) / 10;
secondes = (getTimer() - _root.t0) / 1000;
if(centiemes <= 99)
{
   cent = Math.floor(centiemes);
   sec = "00";
   min = "00";
}
else
{
   min = Math.floor(secondes / 60);
   sec = Math.floor(secondes - min * 60);
   cent = Math.floor(centiemes - sec * 100 - min * 6000);
}
x = 0;
while(x <= 9)
{
   if(sec == x)
   {
      sec = _root.double[x];
   }
   if(min == x)
   {
      min = _root.double[x];
   }
   x++;
}
if(min == 1 && sec > 30)
{
   _root.play();
}
horloge = min + ":" + sec + ":" + cent;
