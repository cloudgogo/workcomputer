var i = 1;//这是初始行标,我们将从初始行标开始循环取出所有的数据
var allResultArray = new Array();//这是最终存所有数据的Array
while (String(contentPane.getCellValue(1, i)).length > 0){
    var lineMap=new Map();//这是单行的map,包含4个键值对
    lineMap.set("name",contentPane.getCellValue(1, i));
    lineMap.set("seq",contentPane.getCellValue(1, i));
    allResultArray.push(lineMap); 
    i = i + 1;
}

