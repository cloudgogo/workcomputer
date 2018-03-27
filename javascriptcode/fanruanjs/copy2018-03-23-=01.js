var location = this.options.location;     
var cr = FR.cellStr2ColumnRow(location);//获取控件的位置   
var col = cr.col; //单元格列号   
var ro = cr.row; //单元格行号 
var zqzt=this.getValue();//获取该控件的值
var zqxz = contentPane.curLGP.getCellValue({col: col-1, row: ro});
var tzxs = contentPane.getWidgetByCell(FR.columnRow2CellStr({col: col+1, row: ro}));
var cjfl = contentPane.getWidgetByCell(FR.columnRow2CellStr({col: col+2, row: ro}));
var yqrq = contentPane.getWidgetByCell(FR.columnRow2CellStr({col: col+4, row: ro}));
var dbzz = contentPane.getWidgetByCell(FR.columnRow2CellStr({col: col+5, row: ro}));
var kydbzj = contentPane.getWidgetByCell(FR.columnRow2CellStr({col: col+6, row: ro}));
var kydbsz = contentPane.getWidgetByCell(FR.columnRow2CellStr({col: col+7, row: ro}));
var fzhj = contentPane.getWidgetByCell(FR.columnRow2CellStr({col: col+8, row: ro}));
var csjyjr = contentPane.getWidgetByCell(FR.columnRow2CellStr({col: col+9, row: ro}));
var zqsz = contentPane.getWidgetByCell(FR.columnRow2CellStr({col: col+10, row: ro}));

if(zqzt=='01'||zqzt=='02'||zqzt=='03'
    ||zqzt=='06'){
    tzxs.setEnable(false);
    contentPane.setCellValue( col+1, ro,'');
$('td[id^=I'+(ro+1)+'-]').css({'background-color':'#F0F0F0'});


}else {
	
tzxs.setEnable(true);
$('td[id^=I'+(ro+1)+'-]').css({'background-color':'#FFFFFF'});
	
	};
if(zqzt=='01'||zqzt=='02'||zqzt=='03'
    ||zqzt=='06'||zqzt=='05'||zqzt=='04'){
cjfl.setEnable(false);
contentPane.setCellValue( col+2,  ro,'');
$('td[id^=J'+(ro+1)+'-]').css({'background-color':'#F0F0F0'});


}else {
	
cjfl.setEnable(true);
$('td[id^=J'+(ro+1)+'-]').css({'background-color':'#FFFFFF'});
	
	};


if(zqxz=='2950' || zqxz=='2960' || zqxz=='2990'){
  if(zqzt=='08'){
        yqrq.setEnable(true);
        dbzz.setEnable(true);
        kydbzj.setEnable(true);
        kydbsz.setEnable(true);
        fzhj.setEnable(true);
        
        $('td[id^=L'+(ro+1)+'-]').css({'background-color':'#FFFFFF'});
        $('td[id^=M'+(ro+1)+'-]').css({'background-color':'#FFFFFF'});
        $('td[id^=N'+(ro+1)+'-]').css({'background-color':'#FFFFFF'});
        $('td[id^=O'+(ro+1)+'-]').css({'background-color':'#FFFFFF'});
        $('td[id^=P'+(ro+1)+'-]').css({'background-color':'#FFFFFF'});
    	 }
    	 else{
yqrq.setEnable(false);
contentPane.setCellValue(col+4, ro,'');
dbzz.setEnable(false);
contentPane.setCellValue(col+5, ro,'');
kydbzj.setEnable(false);
contentPane.setCellValue(col+6, ro,'');
kydbsz.setEnable(false);
contentPane.setCellValue(col+7, ro,'');
        fzhj.setEnable(false);
        contentPane.setCellValue(col+8,ro,'');
        $('td[id^=L'+(ro+1)+'-]').css({'background-color':'#F0F0F0'});
        $('td[id^=M'+(ro+1)+'-]').css({'background-color':'#F0F0F0'});
        $('td[id^=N'+(ro+1)+'-]').css({'background-color':'#F0F0F0'});
        $('td[id^=O'+(ro+1)+'-]').css({'background-color':'#F0F0F0'});
        $('td[id^=P'+(ro+1)+'-]').css({'background-color':'#F0F0F0'});
    }
}
else {
	
yqrq.setEnable(false);
contentPane.setCellValue(col+4, ro,'');
dbzz.setEnable(false);
contentPane.setCellValue(col+5, ro,'');
kydbzj.setEnable(false);
contentPane.setCellValue(col+6, ro,'');
kydbsz.setEnable(false);
contentPane.setCellValue(col+7, ro,'');
        fzhj.setEnable(false);
        contentPane.setCellValue(col+8, ro,'');
        $('td[id^=L'+(ro+1)+'-]').css({'background-color':'#F0F0F0'});
        $('td[id^=M'+(ro+1)+'-]').css({'background-color':'#F0F0F0'});
        $('td[id^=N'+(ro+1)+'-]').css({'background-color':'#F0F0F0'});
        $('td[id^=O'+(ro+1)+'-]').css({'background-color':'#F0F0F0'});
        $('td[id^=P'+(ro+1)+'-]').css({'background-color':'#F0F0F0'});
	
	};

if(zqxz=='2970' || zqxz=='2980' || zqxz=='2990'){
  if(zqzt=='08'){
        csjyjr.setEnable(true);
        zqsz.setEnable(true);

        $('td[id^=Q'+(ro+1)+'-]').css({'background-color':'#FFFFFF'});
        $('td[id^=R'+(ro+1)+'-]').css({'background-color':'#FFFFFF'});
    	 }
    	 else{
csjyjr.setEnable(false);
contentPane.setCellValue(col+9, ro,'');
zqsz.setEnable(false);
contentPane.setCellValue(col+10,ro,'');
        $('td[id^=Q'+(ro+1)+'-]').css({'background-color':'#F0F0F0'});
        $('td[id^=R'+(ro+1)+'-]').css({'background-color':'#F0F0F0'});
    }
}
else {
	
csjyjr.setEnable(false);
contentPane.setCellValue(col+9, ro,'');
zqsz.setEnable(false);
contentPane.setCellValue(col+10, ro,'');

        $('td[id^=Q'+(ro+1)+'-]').css({'background-color':'#F0F0F0'});
        $('td[id^=R'+(ro+1)+'-]').css({'background-color':'#F0F0F0'});
	
	};
