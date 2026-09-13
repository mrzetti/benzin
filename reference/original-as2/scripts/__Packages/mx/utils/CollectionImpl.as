class mx.utils.CollectionImpl extends Object
{
   var _items;
   function CollectionImpl()
   {
      super();
      this._items = new Array();
   }
   function addItem(item)
   {
      var _loc2_ = false;
      if(item != null)
      {
         this._items.push(item);
         _loc2_ = true;
      }
      return _loc2_;
   }
   function clear()
   {
      this._items = new Array();
   }
   function contains(item)
   {
      return this.internalGetItem(item) > -1;
   }
   function getItemAt(index)
   {
      return this._items[index];
   }
   function getIterator()
   {
      return new mx.utils.IteratorImpl(this);
   }
   function getLength()
   {
      return this._items.length;
   }
   function isEmpty()
   {
      return this._items.length == 0;
   }
   function removeItem(item)
   {
      var _loc2_ = false;
      var _loc3_ = this.internalGetItem(item);
      if(_loc3_ > -1)
      {
         this._items.splice(_loc3_,1);
         _loc2_ = true;
      }
      return _loc2_;
   }
   function internalGetItem(item)
   {
      var _loc3_ = -1;
      var _loc2_ = 0;
      while(_loc2_ < this._items.length)
      {
         if(this._items[_loc2_] == item)
         {
            _loc3_ = _loc2_;
            break;
         }
         _loc2_ = _loc2_ + 1;
      }
      return _loc3_;
   }
}
