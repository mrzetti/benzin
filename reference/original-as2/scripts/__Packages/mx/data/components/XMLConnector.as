class mx.data.components.XMLConnector extends mx.data.components.connclasses.RPCCall
{
   var URL;
   var bumpCallsInProgress;
   var direction;
   var ignoreWhite;
   var needData;
   var notifyStatus;
   var params;
   var parseXML;
   var status;
   var triggerSetup;
   var xmlconnector;
   function XMLConnector()
   {
      super();
   }
   function trigger()
   {
      _global.__dataLogger.logData(this,"XMLConnector Triggered, <URL>",this);
      _global.__dataLogger.nestLevel++;
      var _loc4_;
      var _loc3_;
      if(this.triggerSetup(this.direction != "receive"))
      {
         if(this.params != null)
         {
            if(this.direction == "receive")
            {
               _global.__dataLogger.logData(this,"Warning: direction is \'receive\', but params are non-null: <params>",this,mx.data.binding.Log.WARNING);
            }
            else
            {
               if(!(this.params instanceof XML))
               {
                  this.notifyStatus("Fault",{faultcode:"XMLConnector.Not.XML",faultstring:"params is not an XML object"});
                  return undefined;
               }
               if(this.params.status != 0)
               {
                  this.notifyStatus("Fault",{faultcode:"XMLConnector.Parse.Error",faultstring:"params had XML parsing error " + this.params.status});
                  return undefined;
               }
            }
         }
         else if(this.direction != "receive")
         {
            this.notifyStatus("Fault",{faultcode:"XMLConnector.Params.Missing",faultstring:"Direction is \'send\' or \'send/receive\', but params are null"});
            return undefined;
         }
         _loc4_ = this.params;
         if(_loc4_ == null || this.direction == "receive")
         {
            _loc4_ = new XML();
         }
         _loc3_ = new XML();
         _loc3_.ignoreWhite = this.ignoreWhite;
         _loc3_.xmlconnector = this;
         _loc3_.needData = this.direction != "send";
         _loc3_.onData = function(data)
         {
            if(this.needData)
            {
               if(data == undefined)
               {
                  this.xmlconnector.notifyStatus("Fault",{faultcode:"XMLConnector.No.Data.Received",faultstring:"Was expecting data from the server, but none was received"});
               }
               else
               {
                  this.parseXML(data);
                  if(this.status != 0)
                  {
                     this.xmlconnector.notifyStatus("Fault",{faultcode:"XMLConnector.Results.Parse.Error",faultstring:"received data had an XML parsing error " + this.status});
                  }
                  else
                  {
                     this.xmlconnector.setResult(this);
                  }
               }
            }
            this.xmlconnector.bumpCallsInProgress(-1);
         };
         _global.__dataLogger.logData(this,"Invoking XMLConnector <me.URL>(<params>)",{me:this,params:_loc4_});
         _loc4_.contentType = "text/xml";
         _loc4_.sendAndLoad(this.URL,_loc3_);
         this.bumpCallsInProgress(1);
      }
      _global.__dataLogger.nestLevel--;
   }
}
