class mx.data.components.connclasses.RPCCall extends MovieClip
{
   var dispatchEvent;
   var multipleSimultaneousAllowed;
   var refreshAndValidate;
   var results;
   var suppressInvalidCalls;
   var callsInProgress = 0;
   function RPCCall()
   {
      super();
      mx.events.EventDispatcher.initialize(this);
      mx.data.binding.ComponentMixins.initComponent(this);
      this._visible = false;
   }
   function bumpCallsInProgress(amount)
   {
      this.callsInProgress += amount;
      this.notifyStatus("StatusChange",{callsInProgress:this.callsInProgress});
   }
   function notifyStatus(code, data)
   {
      var _loc2_ = new Object();
      _loc2_.type = "status";
      _loc2_.code = code;
      _loc2_.data = data;
      this.dispatchEvent(_loc2_);
   }
   function setResult(r)
   {
      this.results = r;
      this.dispatchEvent({type:"result"});
   }
   function triggerSetup(needsParams)
   {
      if(!this.multipleSimultaneousAllowed && this.callsInProgress > 0)
      {
         this.notifyStatus("CallAlreadyInProgress",this.callsInProgress);
         return false;
      }
      this.dispatchEvent({type:"send"});
      if(needsParams && !this.refreshAndValidate("params") && this.suppressInvalidCalls)
      {
         this.notifyStatus("InvalidParams");
         return false;
      }
      return true;
   }
   function onUpdate()
   {
      this._visible = true;
   }
}
