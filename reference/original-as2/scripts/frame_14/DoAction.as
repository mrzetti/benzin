function decoupage_tab2D(chaine, separateur_ligne, separateur_colonne)
{
   var _loc3_ = [[]];
   var _loc2_ = chaine.split(separateur_ligne);
   var _loc1_ = 0;
   while(_loc1_ < _loc2_.length)
   {
      _loc3_[_loc1_] = _loc2_[_loc1_].split(separateur_colonne);
      _loc1_ = _loc1_ + 1;
   }
   return _loc3_;
}
function decoupage_tab1D(chaine, separateur)
{
   var _loc1_ = chaine.split(separateur);
   return _loc1_;
}
function affichage_classement()
{
   var i = ind_premiere_ligne;
   while(i < ind_premiere_ligne + nb_lignes_affichees)
   {
      position = i - ind_premiere_ligne;
      if(eval("line" + position + "_mc")._visible)
      {
         eval("line" + position + "_mc").rank_txt.text = ind_premiere_ligne + 1 + position;
         eval("line" + position + "_mc").pseudo_txt.text = liste[i][0];
         eval("line" + position + "_mc").score_txt.text = liste[i][1];
      }
      i++;
   }
}
function init_barre_defilement(longueur_liste)
{
   if(longueur_liste < 0)
   {
      longueur_liste = 0;
   }
   if(longueur_liste > nb_lignes_affichees)
   {
      barre_defilement._visible = true;
   }
   else
   {
      barre_defilement._visible = false;
   }
   barre_defilement.scrollPosition = 0;
   var i = 0;
   while(i < nb_lignes_affichees)
   {
      if(i >= longueur_liste)
      {
         eval("line" + i + "_mc")._visible = false;
      }
      i++;
   }
}
function charger_partie_liste(num_appel, nb_appel, longueur_liste)
{
   var scores = new LoadVars();
   var limite_scores = new LoadVars();
   if(num_appel * nb_scores_a_chercher < nb_max_scores_a_chercher)
   {
      limite_scores.limite_debut = num_appel * nb_scores_a_chercher;
      limite_scores.limite_fin = nb_scores_a_chercher;
      limite_scores.toString();
      limite_scores.sendAndLoad("acces/classement_scores.php",scores,"GET");
      scores.onLoad = function()
      {
         var _loc1_ = [[]];
         _loc1_ = decoupage_tab2D(scores.classement,"|","#");
         if(num_appel == 0)
         {
            liste = _loc1_;
         }
         else
         {
            liste = liste.concat(_loc1_);
         }
         barre_defilement.setScrollProperties(nb_lignes_affichees,0,liste.length - nb_lignes_affichees);
         affichage_classement();
         num_appel++;
         if(num_appel < nb_appel)
         {
            charger_partie_liste(num_appel,nb_appel,longueur_liste);
         }
         else
         {
            scores.sendAndLoad("acces/fermeture_base.php",limite_scores,"GET");
         }
      };
   }
   else
   {
      scores.sendAndLoad("acces/fermeture_base.php",limite_scores,"GET");
   }
}
function charger_liste()
{
   var nb_scores = new LoadVars();
   nb_scores.load("acces/nb_scores.php");
   nb_scores.onLoad = function()
   {
      init_barre_defilement(nb_scores.nb_scores);
      var _loc1_;
      if(nb_scores.nb_scores > 0)
      {
         _loc1_ = nb_scores.nb_scores / nb_scores_a_chercher;
         if(_loc1_ - Math.floor(_loc1_) > 0)
         {
            _loc1_ = Math.floor(_loc1_) + 1;
         }
         charger_partie_liste(0,_loc1_,nb_scores.nb_scores);
      }
   };
}
var nb_lignes_affichees = 7;
var ind_premiere_ligne = 0;
var liste = [[]];
var nb_scores_a_chercher = 100;
var nb_max_scores_a_chercher = 2000;
barre_defilement.setStyle("themeColor",5658753);
barre_defilement.setStyle("scrollTrackColor",5658753);
barre_defilement.setStyle("symbolColor",5658753);
listener_barre_defilement = new Object();
listener_barre_defilement.scroll = function(eventObject)
{
   ind_premiere_ligne = barre_defilement.scrollPosition;
   affichage_classement();
};
barre_defilement.addEventListener("scroll",listener_barre_defilement);
charger_liste();
stop();
