class mx.controls.RadioButtonGroup
{
   var __groupName;
   var radioList;
   var selectedRadio;
   static var symbolName = "RadioButtonGroup";
   static var symbolOwner = mx.controls.RadioButtonGroup;
   static var version = "2.0.1.78";
   var className = "RadioButtonGroup";
   var indexNumber = 0;
   function RadioButtonGroup()
   {
      this.init();
      mx.events.UIEventDispatcher.initialize(this);
   }
   function init(Void)
   {
      this.radioList = new Array();
   }
   function setGroupName(groupName)
   {
      if(groupName == undefined || groupName == "")
      {
         return undefined;
      }
      var _loc6_ = this.__groupName;
      _parent[groupName] = this;
      var _loc3_;
      for(var _loc5_ in this.radioList)
      {
         this.radioList[_loc5_].groupName = groupName;
         _loc3_ = this.radioList[_loc5_];
      }
      _loc3_.deleteGroupObj(_loc6_);
   }
   function getGroupName()
   {
      return this.__groupName;
   }
   function addInstance(instance)
   {
      instance.indexNumber = this.indexNumber++;
      this.radioList.push(instance);
   }
   function getValue()
   {
      if(this.selectedRadio.data == "")
      {
         return this.selectedRadio.label;
      }
      return this.selectedRadio.__data;
   }
   function getLabelPlacement()
   {
      var _loc2_;
      for(var _loc3_ in this.radioList)
      {
         _loc2_ = this.radioList[_loc3_].getLabelPlacement();
      }
      return _loc2_;
   }
   function setLabelPlacement(pos)
   {
      for(var _loc3_ in this.radioList)
      {
         this.radioList[_loc3_].setLabelPlacement(pos);
      }
   }
   function setEnabled(val)
   {
      for(var _loc3_ in this.radioList)
      {
         this.radioList[_loc3_].enabled = val;
      }
   }
   function setSize(val, val1)
   {
      for(var _loc3_ in this.radioList)
      {
         this.radioList[_loc3_].setSize(val,val1);
      }
   }
   function getEnabled()
   {
      var _loc2_;
      var _loc3_;
      for(var _loc4_ in this.radioList)
      {
         _loc2_ = this.radioList[_loc4_].enabled;
         _loc3_ = t + (_loc2_ + 0);
      }
      if(_loc3_ == this.radioList.length)
      {
         return true;
      }
      if(_loc3_ == 0)
      {
         return false;
      }
   }
   function setStyle(name, val)
   {
      for(var _loc4_ in this.radioList)
      {
         this.radioList[_loc4_].setStyle(name,val);
      }
   }
   function setInstance(val)
   {
      for(var _loc3_ in this.radioList)
      {
         if(this.radioList[_loc3_] == val)
         {
            this.radioList[_loc3_].selected = true;
         }
      }
   }
   function getInstance()
   {
      return this.selectedRadio;
   }
   function setValue(val)
   {
      var _loc2_;
      for(var _loc4_ in this.radioList)
      {
         if(this.radioList[_loc4_].__data == val || this.radioList[_loc4_].label == val)
         {
            _loc2_ = _loc4_;
            break;
         }
      }
      if(_loc2_ != undefined)
      {
         this.selectedRadio.setState(false);
         this.selectedRadio.hitArea_mc._height = this.selectedRadio.__height;
         this.selectedRadio.hitArea_mc._width = this.selectedRadio.__width;
         this.selectedRadio = this.radioList[_loc2_];
         this.selectedRadio.setState(true);
         this.selectedRadio.hitArea_mc._height = this.selectedRadio.hitArea_mc._width = 0;
      }
   }
   function set groupName(groupName)
   {
      if(groupName == undefined || groupName == "")
      {
         return;
      }
      var _loc6_ = this.__groupName;
      _parent[groupName] = this;
      var _loc3_;
      for(var _loc5_ in this.radioList)
      {
         this.radioList[_loc5_].groupName = groupName;
         _loc3_ = this.radioList[_loc5_];
      }
      _loc3_.deleteGroupObj(_loc6_);
   }
   function get groupName()
   {
      return this.__groupName;
   }
   function set selectedData(val)
   {
      var _loc2_;
      for(var _loc4_ in this.radioList)
      {
         if(this.radioList[_loc4_].__data == val || this.radioList[_loc4_].label == val)
         {
            _loc2_ = _loc4_;
            break;
         }
      }
      if(_loc2_ != undefined)
      {
         this.selectedRadio.setState(false);
         this.selectedRadio = this.radioList[_loc2_];
         this.selectedRadio.setState(true);
      }
   }
   function get selectedData()
   {
      if(this.selectedRadio.data == "" || this.selectedRadio.data == undefined)
      {
         return this.selectedRadio.label;
      }
      return this.selectedRadio.__data;
   }
   function get selection()
   {
      return this.selectedRadio;
   }
   function set selection(val)
   {
      for(var _loc3_ in this.radioList)
      {
         if(this.radioList[_loc3_] == val)
         {
            this.radioList[_loc3_].selected = true;
         }
      }
   }
   function set labelPlacement(pos)
   {
      for(var _loc3_ in this.radioList)
      {
         this.radioList[_loc3_].setLabelPlacement(pos);
      }
   }
   function get labelPlacement()
   {
      var _loc2_;
      for(var _loc3_ in this.radioList)
      {
         _loc2_ = this.radioList[_loc3_].getLabelPlacement();
      }
      return _loc2_;
   }
   function set enabled(val)
   {
      for(var _loc3_ in this.radioList)
      {
         this.radioList[_loc3_].enabled = val;
      }
   }
   function get enabled()
   {
      var _loc2_ = 0;
      for(var _loc3_ in this.radioList)
      {
         _loc2_ += this.radioList[_loc3_].enabled;
      }
      if(_loc2_ == 0)
      {
         return false;
      }
      if(_loc2_ == this.radioList.length)
      {
         return true;
      }
   }
}
