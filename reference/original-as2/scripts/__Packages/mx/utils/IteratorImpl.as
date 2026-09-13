class mx.utils.IteratorImpl
{
   var _collection;
   var _cursor;
   function IteratorImpl(coll)
   {
      this._collection = coll;
      this._cursor = 0;
   }
   function hasNext()
   {
      return this._cursor < this._collection.getLength();
   }
   function next()
   {
      return this._collection.getItemAt(this._cursor++);
   }
}
