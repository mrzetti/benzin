class mx.data.binding.FieldAccessor
{
   var component;
   var data;
   var fieldName;
   var index;
   var m_location;
   var parentObj;
   var property;
   var type;
   var xpath;
   static var xmlNodeFactory = new XML();
   function FieldAccessor(component, property, parentObj, fieldName, type, index, parentField)
   {
      this.component = component;
      this.property = property;
      this.parentObj = parentObj;
      this.fieldName = fieldName;
      if(component == parentObj)
      {
         this.m_location = undefined;
      }
      else if(parentField.m_location == undefined)
      {
         this.m_location = fieldName;
      }
      else
      {
         this.m_location = parentField.m_location + "." + fieldName;
      }
      this.type = type;
      this.index = index;
   }
   function getValue()
   {
      var _loc2_ = this.getFieldData();
      var _loc3_;
      if(_loc2_ == null && this.type.value != undefined)
      {
         _loc3_ = new mx.data.binding.TypedValue(this.type.value,"String");
         _loc3_.getDefault = true;
         this.component.getField(this.fieldName).setAnyTypedValue(_loc3_);
         _loc2_ = _loc3_.value;
      }
      if(this.isXML(_loc2_) && _loc2_.childNodes.length == 1 && _loc2_.firstChild.nodeType == 3)
      {
         return _loc2_.firstChild.nodeValue;
      }
      return _loc2_;
   }
   function setValue(newValue, newTypedValue)
   {
      var _loc5_;
      if(newTypedValue.getDefault)
      {
         newTypedValue.value = newValue;
      }
      else
      {
         if(this.xpath != null)
         {
            _loc5_ = this.getFieldData();
            if(_loc5_ != null)
            {
               mx.data.binding.FieldAccessor.setXMLData(_loc5_,newValue);
            }
            else
            {
               _global.__dataLogger.logData(this.component,"Can\'t assign to \'<property>:<xpath>\' because there is no element at the given path",this);
            }
         }
         else if(this.isXML(this.parentObj))
         {
            if(this.type.category == "attribute")
            {
               this.parentObj.attributes[this.fieldName] = newValue;
            }
            else if(this.type.category != "array")
            {
               _loc5_ = this.getOrCreateFieldData();
               mx.data.binding.FieldAccessor.setXMLData(_loc5_,newValue);
            }
         }
         else
         {
            if(this.parentObj == null)
            {
               _global.__dataLogger.logData(this.component,"Can\'t set field \'<property>/<location>\' because the field doesn\'t exist",this);
            }
            this.parentObj[this.fieldName] = newValue;
         }
         this.component.propertyModified(this.property,this.xpath == null && this.parentObj == this.component,newTypedValue.type);
      }
   }
   static function isActionScriptPath(str)
   {
      var _loc2_ = str.toLowerCase();
      var _loc3_ = "0123456789abcdefghijklmnopqrstuvwxyz_.";
      var _loc1_ = 0;
      while(_loc1_ < _loc2_.length)
      {
         if(-1 == _loc3_.indexOf(_loc2_.charAt(_loc1_)))
         {
            return false;
         }
         _loc1_ = _loc1_ + 1;
      }
      return true;
   }
   static function createFieldAccessor(component, property, location, type, mustExist)
   {
      if(mustExist && component[property] == null)
      {
         _global.__dataLogger.logData(component,"Warning: property \'<property>\' does not exist",{property:property});
         return null;
      }
      var _loc5_ = new mx.data.binding.FieldAccessor(component,property,component,property,type,null,null);
      if(location == null)
      {
         return _loc5_;
      }
      var _loc7_ = null;
      if(location.indices != null)
      {
         _loc7_ = location.indices;
         location = location.path;
      }
      if(typeof location == "string")
      {
         if(_loc7_ != null)
         {
            _global.__dataLogger.logData(component,"Warning: ignoring index values for property \'<property>\', path \'<location>\'",{property:property,location:location});
         }
         if(!mx.data.binding.FieldAccessor.isActionScriptPath(String(location)))
         {
            _loc5_.xpath = location;
            return _loc5_;
         }
         location = location.split(".");
      }
      var _loc3_;
      var _loc11_;
      var _loc2_;
      var _loc4_;
      if(location instanceof Array)
      {
         _loc11_ = 0;
         _loc3_ = 0;
         while(_loc3_ < location.length)
         {
            _loc2_ = null;
            _loc4_ = location[_loc3_];
            if(_loc4_ == "[n]")
            {
               if(_loc7_ == null)
               {
                  _global.__dataLogger.logData(component,"Error: indices for <property>:<location> are null, but [n] appears in the location.",{property:property,location:location});
                  return null;
               }
               _loc2_ = _loc7_[_loc11_++];
               if(_loc2_ == null)
               {
                  _global.__dataLogger.logData(component,"Error: not enough index values for <property>:<location>",{property:property,location:location});
                  return null;
               }
            }
            _loc5_ = _loc5_.getChild(_loc4_,_loc2_,mustExist);
            _loc3_ = _loc3_ + 1;
         }
         if(mustExist && _loc5_.getValue() == null)
         {
            _global.__dataLogger.logData(component,"Warning: field <property>:<m_location> does not exist, or is null",_loc5_);
         }
         return _loc5_;
      }
      trace("unrecognized location: " + mx.data.binding.ObjectDumper.toString(location));
      return null;
   }
   function getFieldAccessor()
   {
      return this;
   }
   function getChild(childName, index, mustExist)
   {
      if(childName == ".")
      {
         return this;
      }
      var _loc2_ = this.getOrCreateFieldData(mustExist);
      if(_loc2_ == null)
      {
         return null;
      }
      var _loc4_ = mx.data.binding.FieldAccessor.findElementType(this.type,childName);
      return new mx.data.binding.FieldAccessor(this.component,this.property,_loc2_,childName,_loc4_,index,this);
   }
   function getOrCreateFieldData(mustExist)
   {
      var _loc3_ = this.getFieldData();
      if(_loc3_ == null)
      {
         if(mustExist)
         {
            _global.__dataLogger.logData(this.component,"Warning: field <property>:<m_location> does not exist",this);
         }
         else
         {
            this.setupComplexField();
            _loc3_ = this.getFieldData();
         }
      }
      return _loc3_;
   }
   function evaluateSubPath(obj, type)
   {
      var path = type.path;
      if(mx.data.binding.FieldAccessor.isActionScriptPath(path))
      {
         var tokens = path.split(".");
         var i = 0;
         while(i < tokens.length)
         {
            var token = tokens[i];
            if(this.isXML(obj))
            {
               obj = obj.firstChild;
               while(obj != null)
               {
                  if(mx.data.binding.FieldAccessor.toLocalName(obj.nodeName) == token)
                  {
                     break;
                  }
                  obj = obj.nextSibling;
               }
            }
            else
            {
               obj = obj[token];
            }
            if(obj == null)
            {
               _global.__dataLogger.logData(this.component,"Warning: path \'<path>\' evaluates to null, at \'<token>\' in <t.property>:<t.m_location>",{path:path,token:token,t:this});
               break;
            }
            i++;
         }
      }
      else if(this.isXML(obj))
      {
         if(path.charAt(0) != "/")
         {
            path = "/" + path;
         }
         if(obj.nodeName == null)
         {
            obj = obj.firstChild;
         }
         else
         {
            path = mx.data.binding.FieldAccessor.toLocalName(obj.nodeName) + path;
         }
         var category = type.category == null ? (type.elements.length <= 0 ? "simple" : "complex") : type.category;
         if(category == "simple" || category == "attribute")
         {
            obj = eval("obj" + mx.xpath.XPathAPI.getEvalString(obj,path));
         }
         else if(category == "complex")
         {
            obj = mx.xpath.XPathAPI.selectSingleNode(obj,path);
         }
         else if(category == "array")
         {
            obj = mx.xpath.XPathAPI.selectNodeList(obj,path);
         }
      }
      else
      {
         _global.__dataLogger.logData(this.component,"Error: path \'<path>\' is an XPath. It cannot be applied to non-XML data <t.property>:<t.m_location>",{path:path,t:this});
      }
      return obj;
   }
   function getFieldData()
   {
      var _loc4_;
      var _loc10_;
      if(this.xpath != null)
      {
         _loc4_ = this.parentObj[this.fieldName].firstChild;
         while(_loc4_ != null && _loc4_.nodeType != 1)
         {
            _loc4_ = _loc4_.nextSibling;
         }
         _loc10_ = mx.xpath.XPathAPI.selectSingleNode(_loc4_,this.xpath);
         return _loc10_;
      }
      var _loc5_;
      var _loc3_;
      var _loc6_;
      if(this.isXML(this.parentObj))
      {
         if(this.type.path != null)
         {
            return this.evaluateSubPath(this.parentObj,this.type);
         }
         if(this.type.category == "attribute")
         {
            _loc5_ = this.parentObj.attributes;
            for(var _loc8_ in _loc5_)
            {
               if(mx.data.binding.FieldAccessor.toLocalName(_loc8_) == this.fieldName)
               {
                  return _loc5_[_loc8_];
               }
            }
            return undefined;
         }
         _loc3_ = this.parentObj.firstChild;
         if(this.type.category == "array")
         {
            _loc6_ = new Array();
            while(_loc3_ != null)
            {
               if(mx.data.binding.FieldAccessor.toLocalName(_loc3_.nodeName) == this.fieldName)
               {
                  _loc6_.push(_loc3_);
               }
               _loc3_ = _loc3_.nextSibling;
            }
            return _loc6_;
         }
         while(_loc3_ != null)
         {
            if(mx.data.binding.FieldAccessor.toLocalName(_loc3_.nodeName) == this.fieldName)
            {
               return _loc3_;
            }
            _loc3_ = _loc3_.nextSibling;
         }
         return null;
      }
      var _loc7_;
      var _loc9_;
      var _loc11_;
      if(this.fieldName == "[n]")
      {
         if(this.index.component != null)
         {
            _loc9_ = this.index.component.getField(this.index.property,this.index.location);
            _loc7_ = _loc9_.getAnyTypedValue(["Number"]);
            _loc7_ = _loc7_.value;
         }
         else
         {
            _loc7_ = this.index.constant;
         }
         _loc11_ = Number(_loc7_);
         if(typeof _loc7_ == "undefined")
         {
            _global.__dataLogger.logData(this.component,"Error: index specification \'<index>\' was not supplied, or incorrect, for <t.property>:<t.m_location>",{index:_loc11_,t:this});
            return null;
         }
         if(_loc11_.toString() == "NaN")
         {
            _global.__dataLogger.logData(this.component,"Error: index value \'<index>\' for <t.property>:<t.m_location> is not a number",{index:_loc11_,t:this});
            return null;
         }
         if(!(this.parentObj instanceof Array))
         {
            _global.__dataLogger.logData(this.component,"Error: indexed field <property>:<m_location> is not an array",this);
            return null;
         }
         if(_loc11_ < 0 || _loc11_ >= this.parentObj.length)
         {
            _global.__dataLogger.logData(this.component,"Error: index \'<index>\' for <t.property>:<t.m_location> is out of bounds",{index:_loc11_,t:this});
            return null;
         }
         _global.__dataLogger.logData(this.component,"Accessing item [<index>] of <t.property>:<t.m_location>",{index:_loc11_,t:this});
         return this.parentObj[_loc11_];
      }
      if(this.type.path != null)
      {
         return this.evaluateSubPath(this.parentObj,this.type);
      }
      return this.parentObj[this.fieldName];
   }
   static function setXMLData(obj, newValue)
   {
      while(obj.hasChildNodes())
      {
         obj.firstChild.removeNode();
      }
      var _loc2_ = mx.data.binding.FieldAccessor.xmlNodeFactory.createTextNode(newValue);
      obj.appendChild(_loc2_);
   }
   function setupComplexField()
   {
      var _loc2_;
      if(this.isXML(this.parentObj))
      {
         _loc2_ = mx.data.binding.FieldAccessor.xmlNodeFactory.createElement(this.fieldName);
         this.parentObj.appendChild(_loc2_);
      }
      else if(this.dataIsXML())
      {
         this.parentObj[this.fieldName] = new XML();
      }
      else
      {
         this.parentObj[this.fieldName] = new Object();
      }
   }
   static function findElementType(type, name)
   {
      var _loc1_ = 0;
      while(_loc1_ < type.elements.length)
      {
         if(type.elements[_loc1_].name == name)
         {
            return type.elements[_loc1_].type;
         }
         _loc1_ = _loc1_ + 1;
      }
      return null;
   }
   function isXML(obj)
   {
      return obj instanceof XMLNode;
   }
   function dataIsXML()
   {
      return this.type.name == "XML";
   }
   static function accessField(component, fieldName, desiredTypes)
   {
      var _loc1_;
      _loc1_ = desiredTypes[fieldName];
      if(_loc1_ == null)
      {
         _loc1_ = desiredTypes.dflt;
      }
      if(_loc1_ == null)
      {
         _loc1_ = desiredTypes;
      }
      var _loc4_ = component.createField("data",[fieldName]);
      var _loc2_ = _loc4_.getAnyTypedValue([_loc1_]);
      return _loc2_.value;
   }
   static function ExpandRecord(obj, objectType, desiredTypes)
   {
      var _loc4_ = new Object();
      mx.data.binding.ComponentMixins.initComponent(_loc4_);
      _loc4_.data = obj;
      _loc4_.__schema = {elements:[{name:"data",type:objectType}]};
      var _loc2_ = new Object();
      var _loc3_;
      var _loc10_;
      var _loc5_;
      if(objectType.elements.length > 0)
      {
         _loc3_ = 0;
         while(_loc3_ < objectType.elements.length)
         {
            _loc10_ = objectType.elements[_loc3_].name;
            _loc2_[_loc10_] = mx.data.binding.FieldAccessor.accessField(_loc4_,_loc10_,desiredTypes);
            _loc3_ = _loc3_ + 1;
         }
      }
      else if(obj instanceof XML || obj instanceof XMLNode)
      {
         if(obj.childNodes.length == 1 && obj.firstChild.nodeType == 3)
         {
            return obj.firstChild.nodeValue;
         }
         _loc5_ = obj.lastChild;
         while(_loc5_ != null)
         {
            _loc10_ = mx.data.binding.FieldAccessor.toLocalName(_loc5_.nodeName);
            if(_loc10_ != null && _loc2_[_loc10_] == null)
            {
               _loc2_[_loc10_] = mx.data.binding.FieldAccessor.accessField(_loc4_,_loc10_,desiredTypes);
            }
            _loc5_ = _loc5_.previousSibling;
         }
         for(_loc10_ in obj.attributes)
         {
            if(_loc2_[_loc10_] != null)
            {
               _global.__dataLogger.logData(null,"Warning: attribute \'<name>\' has same name as an element, in XML object <obj>",{name:_loc10_,obj:obj});
            }
            _loc2_[_loc10_] = mx.data.binding.FieldAccessor.accessField(_loc4_,_loc10_,desiredTypes);
         }
      }
      else
      {
         if(typeof obj != "object")
         {
            return obj;
         }
         for(_loc10_ in obj)
         {
            _loc2_[_loc10_] = mx.data.binding.FieldAccessor.accessField(_loc4_,_loc10_,desiredTypes);
         }
      }
      return _loc2_;
   }
   static function wrapArray(theArray, itemType, desiredTypes)
   {
      var _loc4_ = {getItemAt:function(index)
      {
         if(index < 0 || index >= this.data.length)
         {
            return undefined;
         }
         var _loc2_ = this.data[index];
         if(_loc2_ == undefined)
         {
            return undefined;
         }
         var _loc3_ = mx.data.binding.FieldAccessor.ExpandRecord(_loc2_,this.type,desiredTypes);
         return _loc3_;
      },getItemID:function(index)
      {
         return index;
      },data:theArray,type:itemType,length:theArray.length};
      return _loc4_;
   }
   static function toLocalName(nodeName)
   {
      var _loc1_ = nodeName.split(":");
      var _loc2_ = _loc1_[_loc1_.length - 1];
      return _loc2_;
   }
}
