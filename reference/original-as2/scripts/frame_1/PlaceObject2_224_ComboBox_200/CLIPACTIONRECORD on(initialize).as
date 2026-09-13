on(initialize){
   __schema = {name:"Object",elements:[{name:"value",type:{name:"String",readonly:true,validation:{cls:mx.data.types.Str,className:"mx.data.types.Str",settings:{}}}},{name:"dataProvider",type:{name:"DataProvider",writeonly:true,validation:{cls:mx.data.types.DataProvider,className:"mx.data.types.DataProvider",settings:{}},category:"array"}},{name:"selectedIndex",type:{name:"Number",validation:{cls:mx.data.types.Num,className:"mx.data.types.Num",settings:{}},value:"0"}},{name:"selectedItem",type:{name:"Object",readonly:true,validation:{cls:mx.data.types.Obj,className:"mx.data.types.Obj",settings:{}},category:"complex"}}],validation:{cls:mx.data.types.Obj,className:"mx.data.types.Obj"},original:false};
   __acceptedTypes = {dataProvider:{label:"String"}};
}
