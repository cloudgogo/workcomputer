for (var y = 0; y < allResultArray.length; y++) {
    var loopMap = allResultArray[y];
    console.log(loopMap);
       for (var j = 0; j < allResultArray.length; j++) {
        var compareMap = allResultArray[j];
        console.log(["comp",compareMap]);
        console.log("y="+y+"  j="+j);
        if(j===y){
        continue;
        }else{
        if(loopMap.company === compareMap.company && loopMap.deptment === compareMap.deptment){
                         var f_f = Number(String(loopMap.periodstart.substr(0, 4)) + String(loopMap.periodstart.substr(5, 2)));
                var f_s = Number(String(loopMap.periodend.substr(0, 4)) + St ring(loopMap.periodend.substr(5, 2)));
                var s_f = Number(String(compareMap.periodstart.substr(0, 4)) + String(compareMap.periodstart.substr(5, 2)));
                var s_s = Number(String(compareMap.periodend.substr(0, 4)) + String(compareMap.periodend.substr(5, 2)));

        console.log(f_f);
        console.log(f_s);
             console.log(s_f);
        console.log(s_s);

        }
        }

        }
    }