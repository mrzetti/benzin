function verif_champs_save()
{
   if(email_txt.text == "" || email_txt.text.indexOf("@") == -1)
   {
      return false;
   }
   if(pseudo_txt.text == "")
   {
      return false;
   }
   return true;
}
stop();
html_rb.selected = true;
mailling_liste_cb.selected = ramm_so.data.newsletter;
score_txt.text = _root.score;
ramm_so = SharedObject.getLocal("connect");
if(ramm_so.data.pseudo != undefined)
{
   pseudo_txt.text = ramm_so.data.pseudo;
}
if(ramm_so.data.email != undefined)
{
   email_txt.text = ramm_so.data.email;
}
envoyer_bt.onRelease = function()
{
   var _loc2_;
   if(verif_champs_save())
   {
      trace("champs remplis");
      _loc2_ = new LoadVars();
      var validation = new LoadVars();
      _loc2_.envoi = "score";
      _loc2_.email = email_txt.text;
      _loc2_.pseudo = escape(pseudo_txt.text);
      _loc2_.score_max = _root.score;
      _loc2_.c = c;
      _loc2_.l = l;
      _loc2_.r = r;
      _loc2_.v = v;
      _loc2_.k = k;
      _loc2_.x = x;
      _loc2_.o = o;
      _loc2_.w = w;
      _loc2_.y = y;
      if(html_rb.selected)
      {
         _loc2_.format_mail = "HTML";
      }
      else
      {
         _loc2_.format_mail = "TEXT";
      }
      if(mailling_liste_cb.selected)
      {
         _loc2_.abonne_ml = 1;
      }
      else
      {
         _loc2_.abonne_ml = 0;
      }
      _loc2_.toString();
      trace("envoie" + _loc2_);
      ramm_so.data.pseudo = pseudo_txt.text;
      ramm_so.data.email = email_txt.text;
      ramm_so.data.newsletter = mailling_liste_cb.selected;
      ramm_so.flush();
      box_mc.play();
      _loc2_.sendAndLoad("acces/enregistrement_score.php",validation,"GET");
      validation.onLoad = function()
      {
         trace(validation);
         if(String(validation.checkInsertion).indexOf("insertion") != -1)
         {
            box_mc.move_mc.msg_txt.text = "Enregistrement réussi !";
         }
         else if(String(validation.verifScore).indexOf("triche") != -1)
         {
            box_mc.move_mc.msg_txt.text = "Score Impossible!";
         }
         else if(String(validation.verifScore).indexOf("inf") != -1)
         {
            box_mc.move_mc.msg_txt.text = "Tu n\'as pas battu ton score";
         }
         else
         {
            trace("Error : " + validation.checkEnvoie);
            box_mc.move_mc.msg_txt.text = "Une erreur est survenu lors de l\'envoi";
         }
      };
   }
   else
   {
      box_mc.play();
      box_mc.move_mc.msg_txt.text = "Les champs ne sont pas remplis correctement";
   }
};
