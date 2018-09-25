
//获取当前的x坐标值  
function pageX(elem) {
    return elem.offsetParent ? (elem.offsetLeft + pageX(elem.offsetParent)) : elem.offsetLeft;
}
//获取当前的Y坐标值  
function pageY(elem) {
    return elem.offsetParent ? (elem.offsetTop + pageY(elem.offsetParent)) : elem.offsetTop;
}

function split_str(string, words_per_line) {
    var output_string = string.substring(0, 1);  //取出i=0时的字，避免for循环里换行时多次判断i是否为0   
    for (var i = 1; i < string.length; i++) {
        if (i % words_per_line == 0) {
            output_string += "<br/>";
        }
        output_string += string.substring(i, i + 1);
    }
    return output_string;
}



var title_value = '';
function title_show(pSpan) {
    var divObj = document.createElement("div");
    divObj.innerHTML = "<span id='title_show' style='position:absolute;display:none;background-color:#f0f0f0;z-index:999;opacity:1;font-size:12px;color:#999999;width:300px;padding:10px;border:1px solid #f5f5f5;border-radius:3px;line-height:18px'></span>";
    var first = document.body.firstChild;//得到页面的第一个元素 
    document.body.insertBefore(divObj, first);//在得到的第一个元素之前插入 
    var span = document.getElementById(pSpan);
    var div = document.getElementById("title_show");
    title_value = span.title;
    div.style.left = pageX(span) + 'px';
    div.style.top = pageY(span) + 20 + 'px';
    var words_per_line = 40;     //每行字数   
    var title = split_str(span.title, words_per_line);  //按每行25个字显示标题内容。      
    div.innerHTML = title;
    div.style.display = '';
    span.title = '';        //去掉原有title显示。  
}
function title_back(pSpan) {
    var span = document.getElementById(pSpan)
    var div = document.getElementById("title_show");
    span.title = title_value;
    div.style.display = "none";
}


