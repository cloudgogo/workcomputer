<?xml version="1.0" encoding="UTF-8"?>
<Form xmlVersion="20170715" releaseVersion="8.0.0">
<TableDataMap>
<TableData name="指标体系表" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="TARGET"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=REPLACE(VALUE("TARGET",1),',',"','")]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="DWMC"/>
<O>
<![CDATA[]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[HXXF_HR]]></DatabaseName>
</Connection>
<Query>
<![CDATA[
select *
from
ODM_HR_HR
where 1=1
${if(DWMC='HX_HEAD',"AND 1=1 ","AND paix<>2")}
${if(OR(DWMC='10001100001',DWMC='HX_HEAD')," AND paix<>28 ","and 1=1  ")}
AND( BUMID IN ('${TARGET}')
OR BUMID IN ( select SHANGJID from ODM_HR_HR WHERE BUMID IN ('${TARGET}'))
)
ORDER BY TREE_NODE_ID]]></Query>
</TableData>
<TableData name="指标体系" class="com.fr.data.impl.RecursionTableData">
<markFields>
<![CDATA[1]]></markFields>
<parentmarkFields>
<![CDATA[2]]></parentmarkFields>
<markFieldsName>
<![CDATA[BUMID]]></markFieldsName>
<parentmarkFieldsName>
<![CDATA[SHANGJID]]></parentmarkFieldsName>
<originalTableDataName>
<![CDATA[指标体系表]]></originalTableDataName>
</TableData>
</TableDataMap>
<Parameters/>
<Layout class="com.fr.form.ui.container.WBorderLayout">
<WidgetName name="form"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="0" color="-723724" borderRadius="0" type="0" borderStyle="0"/>
<WidgetTitle>
<O>
<![CDATA[新建标题]]></O>
<FRFont name="SimSun" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Alpha alpha="1.0"/>
</Border>
<LCAttr vgap="0" hgap="0" compInterval="0"/>
<Center class="com.fr.form.ui.container.WFitLayout">
<Listener event="click">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[null]]></Content>
</JavaScript>
</Listener>
<WidgetName name="body"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Margin top="1" left="1" bottom="1" right="1"/>
<Border>
<border style="0" color="-723724" borderRadius="0" type="0" borderStyle="0"/>
<WidgetTitle>
<O>
<![CDATA[新建标题]]></O>
<FRFont name="宋体" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Alpha alpha="1.0"/>
</Border>
<LCAttr vgap="0" hgap="0" compInterval="8"/>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TreeEditor">
<Listener event="afterinit">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[ var a="";
 setTimeout(function() {    
$('.fr-tree-node-collapsed').trigger('click');
}, 10);

var arr,reg=new RegExp("(^| )"+"the_cookie"+"=([^;]A*)(;|$)");
if(arr=document.cookie.match(reg))
a = unescape(arr[2]A);

var GSID=window.parent.$("input[name=GSID1]A").val();
if((GSID=='10001100001'|| GSID=='10004100730')&&a=="64" ){
setTimeout(function() {   
$('#TREEEDITOR1_1-1').trigger('click');
}, 10);}else 
if((GSID=='HX_HEAD')&&a=="64"){
	setTimeout(function() {  
	$('#TREEEDITOR1_1-2').trigger('click');
}, 10);
}
console.log("GSID="+GSID+"&a="+a);
if(GSID!='HX_HEAD'&&a=="11"){
	setTimeout(function() {
		console.log(123);  
	$('#TREEEDITOR1_1-1').trigger('click');
}, 500);
}
]]></Content>
</JavaScript>
</Listener>
<Listener event="click">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[var value = this.getValue();
var GSID=window.parent.$("input[name=GSID1]A").val()
var username=window.parent.$("input[name=USERNAME]A").val()
//alert(GSID)
/*var url=window.document.getElementById("REPORT3").contentWindow.location.href;
alert(url)*/

        switch(value){
        	case "11" :
        	url = "ReportServer?formlet=HXXF_HR/HRanalysis/EmploymentChange.frm";
        	break;
        	case "12" :
        		url = "ReportServer?formlet=HXXF_HR/HRanalysis/CurrentEmployee.frm";
        	break;
        	case "13" :
        		url = "ReportServer?formlet=HXXF_HR/HRanalysis/Employment_labor.frm";
        	break;
        	case "21" :
        		url = "ReportServer?formlet=HXXF_HR/HRanalysis/EmployeeBasic_Gender.frm";
        		break;
        	case "22" :
        		url = "ReportServer?formlet=HXXF_HR/HRanalysis/EmployeeBasic_School.frm";
        		break;
        	case "23" :
        		url = "ReportServer?formlet=HXXF_HR/HRanalysis/EmployeeBasic_Rank.frm";
        		break;
        	case "24" :
        		url = "ReportServer?formlet=HXXF_HR/HRanalysis/EmployeeBasic_NianLing.frm";
        		break;
        	case "25" :
        		url = "ReportServer?formlet=HXXF_HR/HRanalysis/EmployeeBasic_GongLing.frm";
        		break;
        	case "26" :
        		url = "ReportServer?formlet=HXXF_HR/HRanalysis/EmployeeBasic_OurAge.frm";
        		break;
        	case "31" :
        		url = "ReportServer?formlet=HXXF_HR/HRanalysis/RuZhiFenBu_ZhengTi.frm";
        		break;
        	case "32" :
        		url =     "ReportServer?formlet=HXXF_HR/HRanalysis/RuZhiFenBu_YuanGongShuXing.frm";
        		break;
        	case "33" :
        		url = "ReportServer?formlet=HXXF_HR/HRanalysis/RuZhiFenBu_GanBu.frm";
        		break;
        	case "34" :
        		url = "ReportServer?formlet=HXXF_HR/HRanalysis/Entry_Lvy.frm";
        		break;
        	case "35" :
        		url = "ReportServer?formlet=HXXF_HR/HRanalysis/Entry_Lvy.frm";
        		break;
        	case "41" :
        		url = "ReportServer?formlet=HXXF_HR/HRanalysis/Leave_Whole.frm";
        		break;
        	case "42" :
        		url ="ReportServer?formlet=HXXF_HR/HRanalysis/Leave_EmployeeBasic.frm";
        		break;
        	case "43" :
        		url = "ReportServer?formlet=HXXF_HR/HRanalysis/Cadre_Leave.frm";
        		break;
        	case "44" :
        		url = "ReportServer?formlet=HXXF_HR/HRanalysis/Lvy_Leave.frm";
        		break;
        	case "51" :
        		url = "ReportServer?formlet=HXXF_HR/HRanalysis/Lvy_Basic.frm";
        		break;
        	case "53" :
        		url = "ReportServer?formlet=HXXF_HR/HRanalysis/Lvy_Leave.frm";
        		break;
        	case "61" :
        		url = "ReportServer?formlet=HXXF_HR/HRanalysis/Cadre_Basic.frm";
        		break;
        	case "62" :
        		url = "ReportServer?formlet=HXXF_HR/HRanalysis/RuZhiFenBu_GanBu.frm";
        		break;
        	case "63" :   	
        		url = "ReportServer?formlet=HXXF_HR/HRanalysis/Cadre_Leave.frm";
        		break;
		case "64" :
        		url = "ReportServer?formlet=HXXF_HR/HRanalysis/Cadre_Basic1.frm";
   		     break;
        }

		var Days = 1;
	   var exp = new Date();
       exp.setTime(exp.getTime() + Days*24*60*60*1000);
       document.cookie = 'the_cookie' + "="+ escape (value) + ";expires=" + exp.toGMTString();
         FR.doHyperlinkByPost(url,{DWMC:GSID,username:username,value:value},"REPORT3");    
           
]]></Content>
</JavaScript>
</Listener>
<WidgetName name="treeEditor1"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<fontSize>
<![CDATA[10]]></fontSize>
<TreeAttr selectLeafOnly="true"/>
<isLayerBuild isLayerBuild="false"/>
<isAutoBuild autoBuild="false"/>
<isPerformanceFirst performanceFirst="false"/>
<Dictionary class="com.fr.data.impl.TableDataDictionary">
<FormulaDictAttr kiName="BUMID" viName="BMMC"/>
<TableDataDictAttr>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[指标体系]]></Name>
</TableData>
</TableDataDictAttr>
</Dictionary>
<widgetValue/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="943" height="530"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="treeEditor1"/>
</MobileWidgetList>
<WidgetZoomAttr compState="0"/>
<AppRelayout appRelayout="true"/>
<Size width="943" height="530"/>
<ResolutionScalingAttr percent="0.9"/>
<BodyLayoutType type="0"/>
</Center>
</Layout>
<DesignerVersion DesignerVersion="IAA"/>
<PreviewType PreviewType="0"/>
<TemplateID TemplateID="a2b74ea4-395e-4837-9fb4-7f70449159f1"/>
</Form>
