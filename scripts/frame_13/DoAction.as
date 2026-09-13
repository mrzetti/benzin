stop();
// Cover the obsolete promotion form with a nickname-only community form.
var panel = _root.createEmptyMovieClip("communityPanel", 20000);
panel.beginFill(1184274, 100);
panel.moveTo(0, 0);
panel.lineTo(600, 0);
panel.lineTo(600, 450);
panel.lineTo(0, 450);
panel.endFill();
function communityText(name, value, xx, yy, width, height, size)
{
   panel.createTextField(name, panel.getNextHighestDepth(), xx, yy, width, height);
   var field = panel[name];
   var style = new TextFormat("_sans", size, 15658734);
   field.setNewTextFormat(style);
   field.text = value;
   field.wordWrap = true;
   field.selectable = false;
   return field;
}
communityText("title", "BENZIN / COMMUNITY HISCORES", 35, 28, 530, 42, 24);
communityText("scoreLabel", "Your score: " + _root.score, 35, 85, 530, 40, 25);
communityText("nameLabel", "Nickname (3-20 characters)", 35, 150, 530, 30, 18);
var nickname = communityText("nickname", "", 35, 190, 360, 34, 20);
nickname.type = "input";
nickname.selectable = true;
nickname.maxChars = 20;
nickname.restrict = "A-Za-z0-9 _ .\\-";
nickname.background = true;
nickname.backgroundColor = 3355443;
nickname.border = true;
nickname.borderColor = 7829367;
var communitySave = SharedObject.getLocal("benzinCommunity");
if(communitySave.data.nickname != undefined)
{
   nickname.text = communitySave.data.nickname;
}
communityText("note", "One personal best per browser profile. No email needed.\nUse the same browser to keep improving your entry.", 35, 235, 530, 55, 15);
var message = communityText("message", "", 35, 300, 530, 60, 16);
function communityButton(name, label, xx, callback)
{
   var button = panel.createEmptyMovieClip(name, panel.getNextHighestDepth());
   button._x = xx;
   button._y = 380;
   button.beginFill(12335400, 100);
   button.moveTo(0,0);
   button.lineTo(245,0);
   button.lineTo(245,42);
   button.lineTo(0,42);
   button.endFill();
   button.createTextField("label",1,8,9,229,28);
   var text = button.label;
   var style = new TextFormat("_sans",18,16777215,true);
   style.align = "center";
   text.setNewTextFormat(style);
   text.text = label;
   text.selectable = false;
   button.onRelease = callback;
}
communityButton("save", "SAVE SCORE", 35, function()
{
   if(panel.busy) { return; }
   if(nickname.text.length < 3)
   {
      message.text = "Please enter a nickname of at least 3 characters.";
      return;
   }
   panel.busy = true;
   message.text = "Saving...";
   communitySave.data.nickname = nickname.text;
   communitySave.flush();
   var submission = new LoadVars();
   submission.pseudo = nickname.text;
   submission.score_max = _root.score;
   submission.round_token = _root.communityRound.round_token;
   submission.c = _root.c;
   submission.l = _root.l;
   submission.r = _root.r;
   submission.v = _root.v;
   submission.k = _root.k;
   submission.x = _root.x;
   submission.o = _root.o;
   submission.w = _root.w;
   submission.y = _root.y;
   var response = new LoadVars();
   response.onLoad = function(ok)
   {
      panel.busy = false;
      message.text = ok && this.message != undefined ? this.message : "Could not save. Please try again.";
      if(this.checkInsertion == "insertion" || this.verifScore == "inf")
      {
         panel.save.enabled = false;
         panel.save._alpha = 50;
      }
   };
   submission.sendAndLoad("acces/enregistrement_score.php", response, "POST");
});
communityButton("scores", "VIEW HISCORES", 310, function()
{
   panel.removeMovieClip();
   _root.gotoAndStop("hiscores");
});
