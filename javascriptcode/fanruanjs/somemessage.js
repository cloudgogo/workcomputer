var company = contentPane.curLGP.getCellValue(col-4,row-1);
var dept = contentPane.curLGP.getCellValue(col-3,row-1);
var period_from = this.getValue();
var period_to=contentPane.curLGP.getCellValue(col,row-1);


if(company!='' && dept!='' && period_from!='' && period_to!=''){
	
	var sql=
	"SELECT 1 FROM HRS_CORE_ASSET_APPORTION p WHERE p.Company = '"+company+"' AND p.department = '"+dept+"'AND ((p.period_from between '"+period_from+"' and '"+period_to+"') or (p.period_to between '"+period_from+"'  and '"+period_to+"')) "; 
	var des=FR.remoteEvaluate('sql("HRS","'+sql+'",1,1)'); 
	//alert("user_name="+company+";ledger_id="+dept+";company_from="+period_from+";comopany_to="+period_to+";des="+des);
	if(des==1){
		alert("该数据已经存在！请重新确定后插入");
		return false;
	}
	return true;
	
}




去除填报/校验成功/失败后的提示框-http://help.finereport.com/doc-view-1250.html

Msg-http://help.finereport.com/doc-view-603.html










var company = contentPane.curLGP.getCellValue(col-5,row-1);
var dept = contentPane.curLGP.getCellValue(col-4,row-1);
var period_from = contentPane.curLGP.getCellValue(col-2,row-1);
var period_to=this.getValue();


if(company!='' && dept!='' && period_from!='' && period_to!=''){
	
	var sql=
	"SELECT 1 FROM HRS_CORE_ASSET_APPORTION p WHERE p.Company = '"+company+"' AND p.department = '"+dept+"' AND ((p.period_from between '"+period_from+"' and '"+period_to+"') or (p.period_to between '"+period_from+"'  and '"+period_to+"')) "
	var des=FR.remoteEvaluate('sql("HRS","'+sql+'",1,1)'); 
	、//alert("user_name="+company+";ledger_id="+dept+";company_from="+period_from+";comopany_to="+period_to+";des="+des);
	if(des==1){
		alert("该数据已经存在！请重新确定后插入");
		return false;
	}
	return true;
	
}