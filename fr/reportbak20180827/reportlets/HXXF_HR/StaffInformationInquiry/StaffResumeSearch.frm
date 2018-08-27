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
<![CDATA[wangxiong]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[HXXF_HR]]></DatabaseName>
</Connection>
<Query>
<![CDATA[WITH QXSD AS (
select
*
from
ODM_HR_DW
WHERE 1=1
AND back='1'
${if(proe='GFZBZN',"and PARENT_NODES like '%10001100001,%' ",if(len(TREE_ID_R)==0,"AND 1=2"," AND PARENT_NODES LIKE '%"+TREE_ID_R+"%'"))}
--AND (PARENT_NODES like ${TREE_ID_R} )
),
QXPZ AS (
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
QXPZ b
WHERE 1=1
${if(proe='GFZBZN',"and INSTR(b.TREE_ID,a.TREE_NODE,1)>0 "," ")}
ORDER BY a.TREE_NODE_NUM asc
]]></Query>
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
<LCAttr vgap="0" hgap="0" compInterval="1"/>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.plugin.form.widget.core.RHIframe">
<WidgetName name="REPORT5"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Attr scrollX="true" scrollY="true"/>
<RHIframeAttr class="com.fr.plugin.form.widget.core.RHIframeAttr">
<Parameters/>
</RHIframeAttr>
</InnerWidget>
<BoundsAttr x="135" y="0" width="128" height="528"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.plugin.form.widget.core.RHIframe">
<WidgetName name="REPORT4"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Attr scrollX="true" scrollY="true"/>
<RHIframeAttr class="com.fr.plugin.form.widget.core.RHIframeAttr">
<Parameters/>
</RHIframeAttr>
</InnerWidget>
<BoundsAttr x="263" y="0" width="678" height="528"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TreeEditor">
<Listener event="afterinit">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[setTimeout(function() {    
   $('.fr-tree-elbow-end-plus', $('.fr-tree-node-collapsed')).trigger('click');
}, 50);
 setTimeout(function() {    
  $('#TREEEDITOR0_1').trigger('click');
}, 50);]]></Content>
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

if(GSID=="1000000")
{
	var Widget = this.options.form.getWidgetByName('REPORT5');
	Widget.invisible();
	url="ReportServer?reportlet=HXXF_HR/StaffInformationInquiry/AdvancedFilter.cpt&__cutpage__=v"
url1="ReportServer?formlet=HXXF_HR/StaffInformationInquiry/StaffResumeSearch2.frm";

FR.doHyperlinkByPost(url1,{DWMC:GSID,username:username},'REPORT5');
FR.doHyperlinkByPost(url,{DWMC:GSID,username:username},'REPORT4');
	}
else {
		
var Widget = this.options.form.getWidgetByName('REPORT5');
Widget.visible();
url="ReportServer?reportlet=HXXF_HR/StaffInformationInquiry/AdvancedFilter.cpt&__cutpage__=v"
url1="ReportServer?formlet=HXXF_HR/StaffInformationInquiry/StaffResumeSearch2.frm";

FR.doHyperlinkByPost(url1,{DWMC:GSID,username:username},'REPORT5');
FR.doHyperlinkByPost(url,{DWMC:GSID,username:username},'REPORT4');
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
<widgetValue/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="135" height="528"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="treeEditor0"/>
<Widget widgetName="REPORT5"/>
<Widget widgetName="REPORT4"/>
</MobileWidgetList>
<WidgetZoomAttr compState="0"/>
<AppRelayout appRelayout="true"/>
<Size width="941" height="528"/>
<ResolutionScalingAttr percent="0.9"/>
<BodyLayoutType type="0"/>
</Center>
</Layout>
<DesignerVersion DesignerVersion="IAA"/>
<PreviewType PreviewType="0"/>
<TemplateID TemplateID="276a46c2-72d2-4819-bdf8-e472c05c5369"/>
</Form>
