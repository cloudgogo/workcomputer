var i = 4;//这是初始行标,我们将从初始行标开始循环取出所有的数据
var allResultArray = new Array();//这是最终存所有数据的Array
console.log(allResultArray.length);
var message = new Array();
var flag="Y" ;//这是正确标识符,若为Y则是正确,为N是错误
while (String(contentPane.curLGP.getCellValue(2, i)).length > 0) {
    var lineMap = new Map();//这是单行的map,包含4个键值对
    lineMap.set("company", contentPane.curLGP.getCellValue(2, i));//取公司
    lineMap.set("deptment", contentPane.curLGP.getCellValue(3, i));//取部门
    lineMap.set("periodstart", contentPane.curLGP.getCellValue(5, i));//取期间起
    lineMap.set("periodend", contentPane.curLGP.getCellValue(6, i));//取期间至
    allResultArray.push(lineMap);
    i = i + 1;
}


console.log(allResultArray);
for (var y = 0; y < allResultArray.length; y++) {
    var loopMap = allResultArray[y];
    console.log(loopMap);
    for (var j = 0; j < allResultArray.length; j++) {
        var compareMap = allResultArray[j];
        console.log(["comp", compareMap]);
        console.log("y=" + y + "  j=" + j);
        if (j === y) {
           // continue;
           console.log("同一数据,不进行比较");
        } else {
            console.log("enter else block");
            //console.log(loopMap.get("periodstart"));
            console.log(compareMap);
            console.log(loopMap.get("company") === compareMap.get("company") && loopMap.get("deptment") === compareMap.get("deptment"));
           // console.log(loopMap.get("periodstart"));
            //console.log(loopMap.get("periodstart").substr(0, 4));
            //console.log(Number(String(loopMap.get("periodstart").substr(0, 4)) + String(loopMap.get("periodstart").substr(5, 2))));
            if (loopMap.get("company") === compareMap.get("company") && loopMap.get("deptment") === compareMap.get("deptment")) {
                var f_f = Number(String(loopMap.get("periodstart").substr(0, 4)) + String(loopMap.get("periodstart").substr(5, 2)));
                var f_s = Number(String(loopMap.get("periodend").substr(0, 4)) + String(loopMap.get("periodend").substr(5, 2)));
                var s_f = Number(String(compareMap.get("periodstart").substr(0, 4)) + String(compareMap.get("periodstart").substr(5, 2)));
                var s_s = Number(String(compareMap.get("periodend").substr(0, 4)) + String(compareMap.get("periodend").substr(5, 2)));

                console.log(f_f);
                console.log(f_s);
                console.log(s_f);
                console.log(s_s);
                if ((f_f > s_f && f_f < s_s) || (s_f > f_f && s_f < f_s) || (s_f > s_f && s_f < s_s) || (s_s > f_f && s_s < f_s)) {
                    var logmessage="第"+(j+1)+"行的数据与第"+(y+1)+"行的数据重叠";
                    console.log(logmessage);
                    //fr_verifyinfo.info = [1, ":"];
                    //fr_verifyinfo.success = "false";
                    message.push(logmessage);
                    flag="N";
                }

            } 
        }

    }
}
console.log(flag);
if(flag==="Y"){
    console.log("进入成功方法体")
    //fr_verifyinfo.info="Verify Successfully!";
    //fr_verifyinfo.success="true";
    //contentPane.writeReport();  
    _g('${sessionID}').writeReport();
    FR.Msg.toast("填报成功");              
    location.reload(); 
}else if(flag==="N"){
    console.log("进入未成功方法体");
    //fr_verifyinfo.info=message;
    //fr_verifyinfo.success="false";
    console.log(message[0]);
    FR.Msg.alert("警告",message[0]);
}



FIN_REPORT /FIN_REPORT_FOR_USERS/FIN_PROJECT_INCOME_EXPENSE_REPORT.cpt