<?xml version="1.0" encoding="UTF-8"?>
<Form xmlVersion="20170715" releaseVersion="8.0.0">
<TableDataMap>
<TableData name="ds1" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="TREE_ID_R"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=VALUE("TREE_ID_R",1)]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="proe"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=SQL("HXXF_HR","SELECT RLOE FROM HR_AUTHORITY WHERE  RLOE_TYPE='1'AND NAME_ID LIKE '"+$username+"%'",1,1)]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="username"/>
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
<![CDATA[with QXSD AS (
select
*
from
ODM_HR_DW 
WHERE back_ANA='1'
${if(len(TREE_ID_R)==0,"AND 1=2"," AND PARENT_NODES LIKE '%"+TREE_ID_R+"%'")}
--AND (PARENT_NODES like ${TREE_ID_R} )
),
GFGS_QXPZ AS (
SELECT TREE_ID FROM HR_AUTHORITY 
WHERE RLOE_TYPE='1'
${if(len(username)==0,"and 1=0","AND NAME_ID LIKE '%"+username+"%'")}
)
SELECT 
DISTINCT
a.SETID,
a.TREE_NODE,
a.PARENT_NODE,
a.TREE_NODE_NUM,
a.HX_PARENT_SETID,
a.DESCR,
a.BACK,
a.BACK_ANA,
a.PARENT_NODES,
a.PARENT_NAME
FROM QXSD a,
GFGS_QXPZ b
WHERE 1=1
${if(proe='GFZBZN',"and INSTR(b.TREE_ID,a.TREE_NODE,1)>0 "," ")}
ORDER BY a.TREE_NODE_NUM asc]]></Query>
</TableData>
<TableData name="Tree1" class="com.fr.data.impl.RecursionTableData">
<markFields>
<![CDATA[1]]></markFields>
<parentmarkFields>
<![CDATA[2]]></parentmarkFields>
<markFieldsName>
<![CDATA[TREE_NODE]]></markFieldsName>
<parentmarkFieldsName>
<![CDATA[PARENT_NODE]]></parentmarkFieldsName>
<originalTableDataName>
<![CDATA[ds1]]></originalTableDataName>
</TableData>
<TableData name="beifen" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="TREE_ID_R"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="proe"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="username"/>
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
select
*
from
ODM_HR_DW 
WHERE back_ANA='1'
AND (PARENT_NODES like ${TREE_ID_R} )
]]></Query>
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
<NorthAttr size="0"/>
<North class="com.fr.form.ui.container.WParameterLayout">
<Listener event="afterinit">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[setTimeout(function(){  
$('.parameter-container-collapseimg-up').trigger("click");  
$('.parameter-container-collapseimg-up').remove();  
});  
]]></Content>
</JavaScript>
</Listener>
<WidgetName name="para"/>
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
<Background name="ColorBackground" color="-1118482"/>
<LCAttr vgap="0" hgap="0" compInterval="0"/>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TextEditor">
<WidgetName name="USERNAME"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<TextAttr/>
<widgetValue>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$username]]></Attributes>
</O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="145" y="0" width="80" height="0"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TextEditor">
<WidgetName name="url1"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<TextAttr/>
<widgetValue/>
</InnerWidget>
<BoundsAttr x="422" y="0" width="229" height="0"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TextEditor">
<WidgetName name="GSID1"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<TextAttr/>
<widgetValue/>
</InnerWidget>
<BoundsAttr x="257" y="0" width="117" height="0"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="USERNAME"/>
<Widget widgetName="GSID1"/>
<Widget widgetName="url1"/>
</MobileWidgetList>
<Display display="true"/>
<DelayDisplayContent delay="false"/>
<Position position="0"/>
<Design_Width design_width="960"/>
<NameTagModified/>
<WidgetNameTagMap/>
</North>
<Center class="com.fr.form.ui.container.WFitLayout">
<WidgetName name="body"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Margin top="0" left="1" bottom="1" right="1"/>
<Border>
<border style="0" color="-723724" borderRadius="0" type="0" borderStyle="0"/>
<WidgetTitle>
<O>
<![CDATA[新建标题]]></O>
<FRFont name="宋体" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Background name="ColorBackground" color="-1"/>
<Alpha alpha="1.0"/>
</Border>
<Background name="ColorBackground" color="-1"/>
<LCAttr vgap="0" hgap="0" compInterval="8"/>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WAbsoluteLayout">
<WidgetName name="absolute0"/>
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
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="GSID_NAME"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O>
<![CDATA[]]></O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="2" autoline="true"/>
<FRFont name="微软雅黑" style="0" size="72" foreground="-4259840"/>
<border style="0" color="-723724"/>
</InnerWidget>
<BoundsAttr x="45" y="1" width="177" height="18"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="label0"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O>
<![CDATA[所选组织：]]></O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="4" autoline="true"/>
<FRFont name="微软雅黑" style="0" size="72"/>
<border style="0" color="-723724"/>
</InnerWidget>
<BoundsAttr x="2" y="1" width="42" height="18"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="label0"/>
<Widget widgetName="GSID_NAME"/>
</MobileWidgetList>
<WidgetScalingAttr compState="0"/>
<DesignResolution absoluteResolutionScaleW="1366" absoluteResolutionScaleH="768"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="261" height="30"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.plugin.form.widget.core.RHIframe">
<WidgetName name="REPORT33"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Attr scrollX="true" scrollY="true"/>
<RHIframeAttr class="com.fr.plugin.form.widget.core.RHIframeAttr">
<RHIframeSource class="com.fr.plugin.form.widget.core.TemplateSource">
<Attr path="/HXXF_HR/HRanalysis/HRAnalysis1.frm"/>
</RHIframeSource>
<Parameters>
<Parameter>
<Attributes name="GSID"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="username"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$username]]></Attributes>
</O>
</Parameter>
</Parameters>
</RHIframeAttr>
</InnerWidget>
<BoundsAttr x="131" y="30" width="130" height="497"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.plugin.form.widget.core.RHIframe">
<WidgetName name="REPORT3"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Attr scrollX="true" scrollY="true"/>
<RHIframeAttr class="com.fr.plugin.form.widget.core.RHIframeAttr">
<RHIframeSource class="com.fr.plugin.form.widget.core.URLSource">
<Attr url="=serverURL+&quot;/WebReport/&quot;+VALUE(&quot;TARGET_URL&quot;,1,1)"/>
</RHIframeSource>
<Parameters>
<Parameter>
<Attributes name="DWMC"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="username"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$username]]></Attributes>
</O>
</Parameter>
</Parameters>
</RHIframeAttr>
</InnerWidget>
<BoundsAttr x="261" y="0" width="680" height="527"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TreeEditor">
<Listener event="afterinit">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[ setTimeout(function() {    
 $('.fr-tree-elbow-end-plus', $('.fr-tree-node-collapsed')).trigger('click');
 $('#TREEEDITOR0_1').trigger('click');
}, 50);
//点击
setTimeout(function() {    
 $('#TREEEDITOR0_1').trigger('click');

}, 60);

//fr-tree-node-collapsed]]></Content>
</JavaScript>
</Listener>
<Listener event="click">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="username"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$username]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[var GSID = this.getValue();
var sql="SELECT REPLACE(PARENT_NAME,'<','>')  as PARENT_NAME FROM  ODM_HR_DW  WHERE back_ANA='1'AND tree_node='"+GSID+"' "
var res=FR.remoteEvaluate("=sql(\"HXXF_HR\",\""+sql+"\",1)");
var self1 =this.options.form.getWidgetByName("GSID_NAME");   
self1.setValue(res);
var b=$("input[name=GSID1]A").val()
$("input[name=GSID1]A").val(GSID);
var url1=document.getElementById("REPORT3").contentWindow.location.href;
//alert(url1)
var url2="ReportServer?formlet=HXXF_HR/HRanalysis/CurrentEmployee.frm";
var a=url1.indexOf("EmploymentChange")

$("input[name=URL1]A").val(url1)

 if (a>0 && GSID!="HX_HEAD"){
 	var length=url1.length;
 	var url33="/WebReport/ReportServer?formlet=HXXF_HR/HRanalysis/HRAnalysis1.frm"	
FR.doHyperlinkByPost(url33,{DWMC:GSID,username:username},'REPORT33');
FR.doHyperlinkByPost(url2,{DWMC:GSID,username:username},'REPORT3');
if(length<20){
	$("input[name=GSID1]A").val(GSID);
	}
	else {
		
		$("input[name=GSID1]A").val(GSID);
		setTimeout(function() {    
		"FR.doHyperlinkByPost(url1,{DWMC:GSID,username:username},'REPORT3')";
		}, 50);
	
	}

}
else {var length=url1.length;
var url33="/WebReport/ReportServer?formlet=HXXF_HR/HRanalysis/HRAnalysis1.frm"	
FR.doHyperlinkByPost(url33,{DWMC:GSID,username:username},'REPORT33');
if(length<20){
	$("input[name=GSID1]A").val(GSID);
	}
	else {
		
		$("input[name=GSID1]A").val(GSID);
		setTimeout(function() {    
		FR.doHyperlinkByPost(url1,{DWMC:GSID,username:username},'REPORT3');
		}, 50);
	
	}
}
		]]></Content>
</JavaScript>
</Listener>
<WidgetName name="treeEditor0"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<TreeAttr selectLeafOnly="false"/>
<isLayerBuild isLayerBuild="false"/>
<isAutoBuild autoBuild="false"/>
<isPerformanceFirst performanceFirst="false"/>
<Dictionary class="com.fr.data.impl.TableDataDictionary">
<FormulaDictAttr kiName="TREE_NODE" viName="DESCR"/>
<TableDataDictAttr>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[Tree1]]></Name>
</TableData>
</TableDataDictAttr>
</Dictionary>
<widgetValue>
<O>
<![CDATA[]]></O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="0" y="30" width="131" height="497"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="absolute0"/>
<Widget widgetName="REPORT3"/>
<Widget widgetName="treeEditor0"/>
<Widget widgetName="REPORT33"/>
</MobileWidgetList>
<WidgetZoomAttr compState="0"/>
<AppRelayout appRelayout="true"/>
<Size width="941" height="527"/>
<ResolutionScalingAttr percent="0.9"/>
<BodyLayoutType type="0"/>
</Center>
</Layout>
<DesignerVersion DesignerVersion="IAA"/>
<PreviewType PreviewType="0"/>
<TemplateID TemplateID="cacf7a90-3796-4037-a65c-d25d2afc25a5"/>
</Form>
