function verif_champs_invitation_defi()
{
   if(email_txt.text == "" || email_txt.text.indexOf("@") == -1)
   {
      return false;
   }
   if(prenom_txt.text == "")
   {
      return false;
   }
   return true;
}
stop();
envoyer_bt.onRelease = function()
{
   var _loc1_;
   if(verif_champs_invitation_defi())
   {
      trace("champs remplis");
      _loc1_ = new LoadVars();
      var validation = new LoadVars();
      _loc1_.envoi = "invitation";
      _loc1_.prenom_parrain = escape(prenom_env_txt.text);
      _loc1_.email = email_txt.text;
      _loc1_.prenom = escape(prenom_txt.text);
      _loc1_.toString();
      trace("envoie" + _loc1_);
      box_mc.play();
      _loc1_.sendAndLoad("acces/invitation.php",validation,"GET");
      validation.onLoad = function()
      {
         trace(validation);
         if(String(validation.checkEnvoie).indexOf("ok") != -1)
         {
            box_mc.move_mc.msg_txt.text = "Envoi reussi !";
         }
         else
         {
            trace("Error : " + validation.checkEnvoie);
            box_mc.move_mc.msg_txt.text = "Une erreur est survenue lors de l\'envoi";
         }
      };
   }
   else
   {
      trace("champs incorrects");
   }
};
