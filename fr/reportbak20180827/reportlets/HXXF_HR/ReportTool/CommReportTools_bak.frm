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
<![CDATA[WITH SJ AS (
SELECT * FROM ODM_HR_DW
START WITH TREE_NODE IN ('10001106406','10001100076','10001100095','10001100072')
CONNECT BY NOCYCLE PRIOR TREE_NODE=PARENT_NODE
),
ALL_SJ AS (
select
*
from 
ODM_HR_DW 
where 1=1
${if(len(TREE_ID_R)==0," AND 1=2 "," AND PARENT_NODES LIKE '%"+TREE_ID_R+"%'")}
--AND (PARENT_NODES like ${TREE_ID_R} )
),
true_date as (
select * from ALL_SJ
WHERE TREE_NODE NOT IN (SELECT TREE_NODE FROM SJ)
${if(username='wangxiong',""," AND 1=2")}
UNION ALL
SELECT * FROM ALL_SJ
WHERE 1=1
${if(username='wangxiong'," AND 1=2"," ")}
)
SELECT * FROM true_date
ORDER BY TREE_NODE_NUM asc
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
<TableData name="beifen" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="TREE_ID_R"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="'%"+replace(VALUE("TREE_ID_R",1),",","%' OR PARENT_NODES like '%")+"%'"]]></Attributes>
</O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[HXXF_HR]]></DatabaseName>
</Connection>
<Query>
<![CDATA[select
*
from 
ODM_HR_DW 
where 1=1
AND (PARENT_NODES like ${TREE_ID_R} )
ORDER BY TREE_NODE_NUM asc]]></Query>
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
<FRFont name="SimSun" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Alpha alpha="1.0"/>
</Border>
<LCAttr vgap="0" hgap="0" compInterval="5"/>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.plugin.form.widget.core.RHIframe">
<WidgetName name="REPORT1"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Attr scrollX="true" scrollY="true"/>
<RHIframeAttr class="com.fr.plugin.form.widget.core.RHIframeAttr">
<RHIframeSource class="com.fr.plugin.form.widget.core.TemplateSource">
<Attr path=""/>
</RHIframeSource>
<Parameters>
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
<BoundsAttr x="131" y="0" width="815" height="531"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TreeEditor">
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
/*获取网页框URL*/
//var url=parent.document.getElementById("REPORT1").contentWindow.location.href;
var url=document.getElementById("REPORT1").contentWindow.location.href;

FR.doHyperlinkByPost(url,{DWMC:GSID},'REPORT1');
]]></Content>
</JavaScript>
</Listener>
<Listener event="afterinit">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[ setTimeout(function() {   
   $('.fr-tree-elbow-end-plus', $('.fr-tree-node-collapsed')).trigger('click');

}, 50);
setTimeout(function() {    
$('#TREEEDITOR0_1').trigger('click');
}, 500);]]></Content>
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
<BoundsAttr x="0" y="0" width="131" height="531"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="treeEditor0"/>
<Widget widgetName="REPORT1"/>
</MobileWidgetList>
<WidgetZoomAttr compState="0"/>
<AppRelayout appRelayout="true"/>
<Size width="946" height="531"/>
<ResolutionScalingAttr percent="0.9"/>
<BodyLayoutType type="0"/>
</Center>
</Layout>
<DesignerVersion DesignerVersion="IAA"/>
<PreviewType PreviewType="0"/>
<TemplateID TemplateID="bb232313-5532-4249-a2fb-4c689d4237df"/>
</Form>
