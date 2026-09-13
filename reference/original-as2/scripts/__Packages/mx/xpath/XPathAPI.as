class mx.xpath.XPathAPI
{
   function XPathAPI()
   {
   }
   static function getEvalString(node, path)
   {
      var _loc7_ = "";
      var _loc4_ = null;
      var _loc9_ = mx.xpath.XPathAPI.getPathSet(path);
      var _loc3_ = _loc9_[0].nodeName;
      var _loc8_;
      var _loc2_ = node;
      var _loc5_ = false;
      var _loc6_;
      var _loc1_;
      if(_loc3_ != undefined && (_loc3_ == "*" || node.nodeName == _loc3_))
      {
         _loc6_ = 1;
         while(_loc6_ < _loc9_.length)
         {
            _loc3_ = _loc9_[_loc6_].nodeName;
            _loc8_ = _loc3_.indexOf("@");
            if(_loc8_ >= 0)
            {
               _loc3_ = _loc3_.substring(_loc8_ + 1);
               _loc5_ = _loc2_.attributes[_loc3_] != undefined;
               _loc7_ += ".attributes." + _loc3_;
            }
            else
            {
               _loc5_ = false;
               _loc1_ = 0;
               while(_loc1_ < _loc2_.childNodes.length)
               {
                  _loc4_ = _loc2_.childNodes[_loc1_];
                  if(_loc4_.nodeName == _loc3_)
                  {
                     _loc7_ += ".childNodes." + _loc1_;
                     _loc1_ = _loc2_.childNodes.length;
                     _loc2_ = _loc4_;
                     _loc5_ = true;
                  }
                  _loc1_ = _loc1_ + 1;
               }
            }
            if(!_loc5_)
            {
               return "";
            }
            _loc6_ = _loc6_ + 1;
         }
         if(!_loc5_)
         {
            _loc7_ = "";
         }
         else if(_loc8_ == -1)
         {
            _loc7_ += ".firstChild.nodeValue";
         }
      }
      else
      {
         _loc7_ = "";
      }
      return _loc7_;
   }
   static function selectNodeList(node, path)
   {
      var _loc2_ = new Array(node);
      var _loc5_ = mx.xpath.XPathAPI.getPathSet(path);
      var _loc4_ = _loc5_[0];
      var _loc6_ = _loc4_.nodeName;
      var _loc1_ = null;
      var _loc3_;
      if(_loc6_ != undefined && (_loc6_ == "*" || node.nodeName == _loc6_))
      {
         if(_loc4_.filter.length > 0)
         {
            _loc1_ = new mx.xpath.FilterStack(_loc4_.filter);
            _loc2_ = mx.xpath.XPathAPI.filterNodes(_loc2_,_loc1_);
         }
         if(_loc2_.length > 0)
         {
            _loc3_ = 1;
            while(_loc3_ < _loc5_.length)
            {
               _loc4_ = _loc5_[_loc3_];
               _loc2_ = mx.xpath.XPathAPI.getAllChildNodesByName(_loc2_,_loc4_.nodeName);
               if(_loc4_.filter.length > 0)
               {
                  _loc1_ = new mx.xpath.FilterStack(_loc4_.filter);
               }
               else
               {
                  _loc1_ = null;
               }
               if(_loc1_ != null && _loc1_.exprs.length > 0)
               {
                  _loc2_ = mx.xpath.XPathAPI.filterNodes(_loc2_,_loc1_);
               }
               _loc3_ = _loc3_ + 1;
            }
         }
      }
      else
      {
         _loc2_ = new Array();
      }
      return _loc2_;
   }
   static function selectSingleNode(node, path)
   {
      var _loc1_ = mx.xpath.XPathAPI.selectNodeList(node,path);
      if(_loc1_.length > 0)
      {
         return _loc1_[0];
      }
      return null;
   }
   static function setNodeValue(node, path, newValue)
   {
      var _loc1_ = new Array(node);
      var _loc9_ = mx.xpath.XPathAPI.getPathSet(path);
      var _loc7_ = _loc9_[_loc9_.length - 1].nodeName;
      if(_loc7_.charAt(0) == "@")
      {
         _loc7_ = _loc7_.substring(1,_loc7_.length);
         _loc9_.pop();
      }
      else
      {
         _loc7_ = null;
      }
      var _loc5_ = _loc9_[0];
      var _loc11_ = _loc5_.nodeName;
      var _loc3_ = null;
      var _loc2_;
      if(_loc11_ != undefined && (_loc11_ == "*" || node.nodeName == _loc11_))
      {
         if(_loc5_.filter.length > 0)
         {
            _loc3_ = new mx.xpath.FilterStack(_loc5_.filter);
            _loc1_ = mx.xpath.XPathAPI.filterNodes(_loc1_,_loc3_);
         }
         if(_loc1_.length > 0)
         {
            _loc2_ = 1;
            while(_loc2_ < _loc9_.length)
            {
               _loc5_ = _loc9_[_loc2_];
               _loc1_ = mx.xpath.XPathAPI.getAllChildNodesByName(_loc1_,_loc5_.nodeName);
               if(_loc5_.filter.length > 0)
               {
                  _loc3_ = new mx.xpath.FilterStack(_loc5_.filter);
               }
               else
               {
                  _loc3_ = null;
               }
               if(_loc3_ != null && _loc3_.exprs.length > 0)
               {
                  _loc1_ = mx.xpath.XPathAPI.filterNodes(_loc1_,_loc3_);
               }
               _loc2_ = _loc2_ + 1;
            }
         }
      }
      else
      {
         _loc1_ = new Array();
      }
      var _loc4_ = null;
      var _loc6_ = null;
      var _loc10_ = new XML();
      _loc2_ = 0;
      while(_loc2_ < _loc1_.length)
      {
         if(_loc7_ != null)
         {
            _loc1_[_loc2_].attributes[_loc7_] = newValue;
         }
         else
         {
            _loc4_ = _loc1_[_loc2_];
            if(_loc4_.firstChild == null || _loc4_.firstChild.nodeType != 3)
            {
               _loc6_ = _loc10_.createTextNode(newValue);
               _loc4_.appendChild(_loc6_);
            }
            else
            {
               _loc6_ = _loc4_.firstChild;
               _loc6_.nodeValue = newValue;
            }
         }
         _loc2_ = _loc2_ + 1;
      }
      return _loc1_.length;
   }
   static function copyStack(toStk, fromStk)
   {
      var _loc1_ = 0;
      while(_loc1_ < fromStk.length)
      {
         toStk.splice(_loc1_,0,fromStk[_loc1_]);
         _loc1_ = _loc1_ + 1;
      }
   }
   static function evalExpr(expr, node)
   {
      var _loc2_ = true;
      var _loc3_;
      if(expr.attr)
      {
         _loc2_ = expr.value == null ? node.attributes[expr.name] != null : node.attributes[expr.name] == expr.value;
      }
      else
      {
         _loc3_ = mx.xpath.XPathAPI.getChildNodeByName(node,expr.name);
         if(_loc3_ != null)
         {
            _loc2_ = expr.value == null ? true : _loc3_.firstChild.nodeValue == expr.value;
         }
         else
         {
            _loc2_ = false;
         }
      }
      return _loc2_;
   }
   static function filterNodes(nodeList, stack)
   {
      var _loc13_ = new Array();
      var _loc2_;
      var _loc3_;
      var _loc9_;
      var _loc6_;
      var _loc10_;
      var _loc1_ = true;
      var _loc4_;
      var _loc5_;
      var _loc8_ = 0;
      var _loc7_;
      while(_loc8_ < nodeList.length)
      {
         _loc5_ = true;
         _loc2_ = new Array();
         _loc3_ = new Array();
         mx.xpath.XPathAPI.copyStack(_loc2_,stack.exprs);
         mx.xpath.XPathAPI.copyStack(_loc3_,stack.ops);
         _loc4_ = nodeList[_loc8_];
         while(_loc2_.length > 0 && _loc5_)
         {
            if(typeof _loc2_[_loc2_.length - 1] == "object")
            {
               _loc9_ = _loc2_.pop();
               _loc1_ = mx.xpath.XPathAPI.evalExpr(_loc9_,_loc4_);
            }
            else
            {
               _loc10_ = Boolean(_loc2_.pop());
               _loc1_ = _loc10_;
            }
            if(_loc3_.length > 0)
            {
               _loc7_ = _loc2_.pop();
               _loc6_ = _loc7_;
               switch(_loc3_[_loc3_.length - 1])
               {
                  case "and":
                     _loc1_ = _loc1_ && mx.xpath.XPathAPI.evalExpr(_loc6_,_loc4_);
                     _loc5_ = _loc1_;
                     break;
                  case "or":
                     _loc1_ = _loc1_ || mx.xpath.XPathAPI.evalExpr(_loc6_,_loc4_);
                     _loc5_ = !_loc1_;
               }
               _loc3_.pop();
               _loc2_.push(_loc1_);
            }
         }
         if(_loc1_)
         {
            _loc13_.push(_loc4_);
         }
         _loc8_ = _loc8_ + 1;
      }
      return _loc13_;
   }
   static function getAllChildNodesByName(nodeList, name)
   {
      var _loc5_ = new Array();
      var _loc2_;
      var _loc3_ = 0;
      var _loc1_;
      while(_loc3_ < nodeList.length)
      {
         _loc2_ = nodeList[_loc3_].childNodes;
         if(_loc2_ != null)
         {
            _loc1_ = 0;
            while(_loc1_ < _loc2_.length)
            {
               if(name == "*" || _loc2_[_loc1_].nodeName == name)
               {
                  _loc5_.push(_loc2_[_loc1_]);
               }
               _loc1_ = _loc1_ + 1;
            }
         }
         _loc3_ = _loc3_ + 1;
      }
      return _loc5_;
   }
   static function getChildNodeByName(node, nodeName)
   {
      var _loc2_;
      var _loc3_ = node.childNodes;
      var _loc1_ = 0;
      while(_loc1_ < _loc3_.length)
      {
         _loc2_ = _loc3_[_loc1_];
         if(_loc2_.nodeName == nodeName)
         {
            return _loc2_;
         }
         _loc1_ = _loc1_ + 1;
      }
      return null;
   }
   static function getKeyValues(node, keySpec)
   {
      var _loc5_ = "";
      var _loc3_ = new mx.utils.StringTokenParser(keySpec);
      var _loc2_ = _loc3_.nextToken();
      var _loc1_;
      var _loc6_;
      while(_loc2_ != mx.utils.StringTokenParser.tkEOF)
      {
         _loc1_ = _loc3_.token;
         _loc5_ += " " + _loc1_;
         if(_loc2_ == mx.utils.StringTokenParser.tkSymbol)
         {
            if(_loc1_ == "@")
            {
               _loc2_ = _loc3_.nextToken();
               _loc1_ = _loc3_.token;
               if(_loc2_ == mx.utils.StringTokenParser.tkSymbol)
               {
                  _loc5_ += _loc1_ + "=\'" + node.attributes[_loc1_] + "\'";
               }
            }
            else if(_loc1_ == "/")
            {
               _loc2_ = _loc3_.nextToken();
               if(_loc2_ == mx.utils.StringTokenParser.tkSymbol)
               {
                  _loc1_ = _loc3_.token;
                  node = mx.xpath.XPathAPI.getChildNodeByName(node,_loc1_);
                  if(node != null)
                  {
                     _loc5_ += _loc1_;
                  }
               }
            }
            else if(_loc1_ != "and" && _loc1_ != "or" && _loc1_ != "[" && _loc1_ != "]")
            {
               _loc6_ = mx.xpath.XPathAPI.getChildNodeByName(node,_loc1_);
               if(_loc6_ != null)
               {
                  _loc5_ += "=\'" + _loc6_.firstChild.nodeValue + "\'";
               }
            }
         }
         if(node == null)
         {
            trace("Invalid keySpec specified. \'" + keySpec + "\' Error.");
            return "ERR";
         }
         _loc2_ = _loc3_.nextToken();
      }
      return _loc5_.slice(1);
   }
   static function getPath(node, keySpecs)
   {
      var _loc2_ = "";
      var _loc5_ = keySpecs[node.nodeName];
      var _loc8_;
      var _loc10_;
      var _loc7_;
      var _loc1_;
      var _loc6_;
      var _loc4_;
      if(_loc5_ == undefined)
      {
         _loc8_ = "";
         for(_loc10_ in node.attributes)
         {
            _loc8_ += "@" + _loc10_ + "=\'" + node.attributes[_loc10_] + "\' and ";
         }
         _loc7_ = "";
         _loc4_ = 0;
         while(_loc4_ < node.childNodes.length)
         {
            _loc1_ = node.childNodes[_loc4_];
            _loc6_ = _loc1_.firstChild.nodeValue;
            if(_loc6_ != undefined)
            {
               _loc7_ += _loc1_.nodeName + "=\'" + _loc6_ + "\' and ";
            }
            _loc4_ = _loc4_ + 1;
         }
         if(_loc8_.length > 0)
         {
            if(_loc7_.length > 0)
            {
               _loc2_ = "/" + node.nodeName + "[" + _loc8_ + _loc7_.substring(0,_loc7_.length - 4) + "]";
            }
            else
            {
               _loc2_ = "/" + node.nodeName + "[" + _loc8_.substring(0,_loc8_.length - 4) + "]";
            }
         }
         else
         {
            _loc2_ = "/" + node.nodeName + "[" + _loc7_.substring(0,_loc7_.length - 4) + "]";
         }
      }
      else
      {
         _loc2_ += "/" + node.nodeName + mx.xpath.XPathAPI.getKeyValues(node,_loc5_);
      }
      _loc1_ = node.parentNode;
      while(_loc1_.parentNode != null)
      {
         _loc5_ = keySpecs[_loc1_.nodeName];
         if(_loc5_ != undefined)
         {
            _loc2_ = "/" + _loc1_.nodeName + mx.xpath.XPathAPI.getKeyValues(_loc1_,_loc5_) + _loc2_;
         }
         else
         {
            _loc2_ = "/" + _loc1_.nodeName + _loc2_;
         }
         _loc1_ = _loc1_.parentNode;
      }
      return _loc2_;
   }
   static function getPathSet(path)
   {
      var _loc6_ = new Array();
      var _loc4_;
      var _loc1_;
      var _loc2_;
      var _loc5_;
      while(path.length > 0)
      {
         _loc4_ = path.lastIndexOf("/");
         _loc1_ = path.substring(_loc4_ + 1);
         _loc2_ = _loc1_.indexOf("[",0);
         _loc5_ = _loc2_ < 0 ? "" : _loc1_.substring(_loc2_ + 1,_loc1_.length - 1);
         _loc1_ = _loc2_ < 0 ? _loc1_ : _loc1_.substring(0,_loc2_);
         _loc6_.splice(0,0,new mx.xpath.NodePathInfo(_loc1_,_loc5_));
         path = path.substring(0,_loc4_);
      }
      return _loc6_;
   }
}
