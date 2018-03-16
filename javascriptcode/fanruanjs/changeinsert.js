var location = this.options.location;     
var cr = FR.cellStr2ColumnRow(location);//获取控件的位置   
var col = cr.col; //单元格列号   
var ro = cr.row; //单元格行号 
var qylb=this.getValue();//获取该控件的值
var zcdm = contentPane.getWidgetByCell(FR.columnRow2CellStr({col: col+1, row: ro}));
var zcmc = contentPane.getWidgetByCell(FR.columnRow2CellStr({col: col+2, row: ro}));
var gszjcy = contentPane.getWidgetByCell(FR.columnRow2CellStr({col: col+3, row: ro}));
var cjfl = contentPane.getWidgetByCell(FR.columnRow2CellStr({col: col+4, row: ro}));
var tzdx = contentPane.getWidgetByCell(FR.columnRow2CellStr({col: col+5, row: ro}));
var zmjz = contentPane.getWidgetByCell(FR.columnRow2CellStr({col: col+6, row: ro}));
var is_fengu = contentPane.getWidgetByCell(FR.columnRow2CellStr({col: col+7, row: ro}));
var cccb = contentPane.getWidgetByCell(FR.columnRow2CellStr({col: col+8, row: ro}));
var gyjz = contentPane.getWidgetByCell(FR.columnRow2CellStr({col: col+9, row: ro}));
var kthyj = contentPane.getWidgetByCell(FR.columnRow2CellStr({col: col+10, row: ro}));
var tqyxx= contentPane.getWidgetByCell(FR.columnRow2CellStr({col: col+11, row: ro}));
var tzrq = contentPane.getWidgetByCell(FR.columnRow2CellStr({col: col+12, row: ro}));

if(qylb=='1010'||qylb=='1210'||qylb=='2410'){
    zcdm.setEnable(true);
    $('td[id^=F'+(ro+1)+'-0-0]').css({'background-color':'#FFFFFF'});
 
}else {
	zcdm.setEnable(false);
   contentPane.curLGP.setCellValue({col: col+1, row: ro},'');
$('td[id^=F'+(ro+1)+'-0-0]').css({'background-color':'#F0F0F0'});
	
	};

if(qylb=='1010' || qylb=='1210'){
    gszjcy.setEnable(true);
    $('td[id^=H'+(ro+1)+'-0-0]').css({'background-color':'#FFFFFF'});
 
}else {
	gszjcy.setEnable(false);
   contentPane.curLGP.setCellValue({col: col+3, row: ro},'');
$('td[id^=H'+(ro+1)+'-0-0]').css({'background-color':'#F0F0F0'});
	
	};

if(qylb=='2410' || qylb=='1210'){
    cjfl.setEnable(false);
    contentPane.curLGP.setCellValue({col: col+4, row: ro},'');
$('td[id^=I'+(ro+1)+'-0-0]').css({'background-color':'#F0F0F0'});
    
 
}else {
	cjfl.setEnable(true);
  $('td[id^=I'+(ro+1)+'-0-0]').css({'background-color':'#FFFFFF'});
	
	};

if(qylb=='1110'){
    tzdx.setEnable(true);
    $('td[id^=J'+(ro+1)+'-0-0]').css({'background-color':'#FFFFFF'});
 
}else {
	tzdx.setEnable(false);
   contentPane.curLGP.setCellValue({col: col+5, row: ro},'');
$('td[id^=J'+(ro+1)+'-0-0]').css({'background-color':'#F0F0F0'});
	
	};

if(qylb=='1010'){
    zmjz.setEnable(false);
    contentPane.curLGP.setCellValue({col: col+6, row: ro},'');
$('td[id^=K'+(ro+1)+'-0-0]').css({'background-color':'#F0F0F0'});
   ;
 
}else {
    zmjz.setEnable(true);
    $('td[id^=K'+(ro+1)+'-0-0]').css({'background-color':'#FFFFFF'})
	
	};

if(qylb=='1010'){
    is_fengu.setEnable(true);
    $('td[id^=L'+(ro+1)+'-0-0]').css({'background-color':'#FFFFFF'});
    cccb.setEnable(true);
    $('td[id^=M'+(ro+1)+'-0-0]').css({'background-color':'#FFFFFF'});
    gyjz.setEnable(true);
    $('td[id^=N'+(ro+1)+'-0-0]').css({'background-color':'#FFFFFF'});
 
}else {
	is_fengu.setEnable(false);
   contentPane.curLGP.setCellValue({col: col+7, row: ro},'');
$('td[id^=L'+(ro+1)+'-0-0]').css({'background-color':'#F0F0F0'});
    cccb.setEnable(false);
   contentPane.curLGP.setCellValue({col: col+8, row: ro},'');
$('td[id^=M'+(ro+1)+'-0-0]').css({'background-color':'#F0F0F0'});
   gyjz.setEnable(false);
   contentPane.curLGP.setCellValue({col: col+9, row: ro},'');
$('td[id^=N'+(ro+1)+'-0-0]').css({'background-color':'#F0F0F0'});
	
	};

if(qylb=='1110' || qylb=='1210'){
    tzrq.setEnable(true);
    $('td[id^=Q'+(ro+1)+'-0-0]').css({'background-color':'#FFFFFF'});
 
}else {
	tzrq.setEnable(false);
   contentPane.curLGP.setCellValue({col: col+12, row: ro},'');
$('td[id^=Q'+(ro+1)+'-0-0]').css({'background-color':'#F0F0F0'});
	
	};

if(qylb=='1110' || qylb=='1210'||qylb=='1010' || qylb=='1020'||qylb=='2410' || qylb=='2420'){
    kthyj.setEnable(false);
      contentPane.curLGP.setCellValue({col: col+10, row: ro},'');
$('td[id^=O'+(ro+1)+'-0-0]').css({'background-color':'#F0F0F0'});

 
}else {
	kthyj.setEnable(true);
     $('td[id^=O'+(ro+1)+'-0-0]').css({'background-color':'#FFFFFF'});
	
	};

if(qylb=='1110' || qylb=='1210'||qylb=='1010' || qylb=='1020'||qylb=='2410' || qylb=='2420'){
    tqyxx.setEnable(false);
      contentPane.curLGP.setCellValue({col: col+11, row: ro},'');
$('td[id^=P'+(ro+1)+'-0-0]').css({'background-color':'#F0F0F0'});

 
}else {
	tqyxx.setEnable(true);
     $('td[id^=P'+(ro+1)+'-0-0]').css({'background-color':'#FFFFFF'});
	
	};