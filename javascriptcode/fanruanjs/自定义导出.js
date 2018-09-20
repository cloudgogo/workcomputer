fangwenlujing=FR.remoteEvaluate('=$reportName'); 
FR.Msg.toast('文件路径为:'+fangwenlujing);
var REPORT_URL = '/WebReport/ReportServer?reportlet='+fangwenlujing+'&format=excel'; 
if (export1=='true'){ 
window.location = (FR.cjkEncode(REPORT_URL));
}
else {
      contentPane.toolbar.getWidgetByName("CustomToolBarButton").setVisible(false);
      FR.Msg.toast('您不具有导出权限');	
	}


