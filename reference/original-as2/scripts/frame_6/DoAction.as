function init()
{
   html_rb.selected = true;
}
function verifier_champs()
{
   if(pseudo_txt.text == "")
   {
      return false;
   }
   if(email_txt.text == "" || email_txt.text.indexOf("@") == -1)
   {
      return false;
   }
   if(prenom_txt.text == "")
   {
      return false;
   }
   trace("jour : " + Number(jour_txt.text));
   if(jour_txt.text == "" || isNaN(jour_txt.text))
   {
      return false;
   }
   if(Number(jour_txt.text) < 1 || Number(jour_txt.text) > 31)
   {
      return false;
   }
   if(mois_txt.text == "" || isNaN(mois_txt.text))
   {
      return false;
   }
   if(Number(mois_txt.text) < 1 || Number(mois_txt.text) > 12)
   {
      return false;
   }
   if(annee_txt.text == "" || isNaN(annee_txt.text))
   {
      return false;
   }
   if(Number(annee_txt.text) < 1930 || Number(annee_txt.text) > 2004)
   {
      return false;
   }
   return true;
}
function save_user()
{
   envoyer2_bt.enabled = false;
   var _loc2_ = new LoadVars();
   var validation_news = new LoadVars();
   _loc2_.pseudo = escape(pseudo_txt.text);
   _loc2_.email = email_txt.text;
   _loc2_.prenom = escape(prenom_txt.text);
   _loc2_.date_naissance = annee_txt.text + "-" + mois_txt.text + "-" + jour_txt.text;
   _loc2_.pays = escape(pays_cb.value);
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
   trace(_loc2_);
   box_mc.play();
   ramm_so.data.pseudo = pseudo_txt.text;
   ramm_so.data.email = email_txt.text;
   ramm_so.flush();
   _loc2_.sendAndLoad("acces/save_user_.php",validation_news,"GET");
   validation_news.onLoad = function()
   {
      trace(validation_news);
      if(validation_news.checkInsertion == "")
      {
         _root.id_user = validation_news.id;
         _root.pseudo_user = validation_news.pseudo;
         _root.abonne_ml = validation_news.abonne_ml;
         _root.format_mail = validation_news.format_mail;
         _root.prenom_user = validation_news.prenom;
         _root.score_max = validation_news.score_max;
         box_mc.gotoAndStop(1);
         pays_cb.visible = false;
         gotoAndStop("menu");
      }
      else
      {
         trace("Error : " + validation_news.checkInsertion);
         msg_mc._x = 270;
         if(validation_news.doublon == "pseudo")
         {
            msg_mc.message_txt.text = "Pseudo déjà existant!";
         }
         else if(validation_news.doublon == "email")
         {
            msg_mc.message_txt.text = "Adresse mail déjà existante!";
         }
         msg_mc.ok_bt.onRelease = function()
         {
            msg_mc.message_txt.text = "";
            msg_mc._x = -400;
         };
      }
      envoyer2_bt.enabled = true;
   };
}
init();
ramm_so = SharedObject.getLocal("connect");
if(ramm_so.data.pseudo != undefined)
{
   pseudo_txt.text = ramm_so.data.pseudo;
}
if(ramm_so.data.email != undefined)
{
   email_txt.text = ramm_so.data.email;
}
envoyer2_bt.onRelease = function()
{
   if(verifier_champs())
   {
      trace("champs corrects");
      msg_txt.text = "";
      save_user();
   }
   else
   {
      trace("champs incorrects");
      msg_txt.text = "Tous les champs ne sont pas remplis correctement!";
   }
};
pays_cb.visible = true;
stop();
