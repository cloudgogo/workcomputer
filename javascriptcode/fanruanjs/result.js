//console.log(fr_verifyinfo);
//fr_verifyinfo.info = [1, ":"];
//fr_verifyinfo.success = "false";

//console.log(fr_verifyinfo);

var i = 4;//这是初始行标,我们将从初始行标开始循环取出所有的数据
var allResultArray = new Array();//这是最终存所有数据的Array
var message = new Array();
while (String(contentPane.getCellValue(2, i)).length > 0) {
    var lineMap = new Map();//这是单行的map,包含4个键值对
    lineMap.set("company", contentPane.getCellValue(2, i));//取公司
    lineMap.set("deptment", contentPane.getCellValue(3, i));//取部门
    lineMap.set("periodstart", contentPane.getCellValue(5, i));//取期间起
    lineMap.set("periodend", contentPane.getCellValue(6, i));//取期间至
    allResultArray.push(lineMap);
    i = i + 1;
}
console.log(allResultArray);
for (var y = 0; y < allResultArray.length; y++) {
    var loopMap = allResultArray[y];
    console.log(loopMap);
    for (var j = 0; j < allResultArray.length; j++) {
        var compareMap = allResultArray[j];
        if (loopMap.company === compareMap.company && loopMap.deptment === compareMap.deptment) {
            if (y === j) {
                continue;
            } else {
                var f_f = Number(String(loopMap.periodstart.substr(0, 4)) + String(loopMap.periodstart.substr(5, 2)));
                var f_s = Number(String(loopMap.periodend.substr(0, 4)) + String(loopMap.periodend.substr(5, 2)));
                var s_f = Number(String(compareMap.periodstart.substr(0, 4)) + String(compareMap.periodstart.substr(5, 2)));
                var s_s = Number(String(compareMap.periodend.substr(0, 4)) + String(compareMap.periodend.substr(5, 2)));

                if ((f_f > s_f && f_f < s_s) && (s_f > f_f && s_f < f_s) && (s_f > s_f && s_f < s_s) && (s_s > f_f && s_s < f_s)) {
                    alert("出错在第" + i + "列");
                    fr_verifyinfo.info = [1, ":"];
                    fr_verifyinfo.success = "false";
                }
            }
        }
    }
}
