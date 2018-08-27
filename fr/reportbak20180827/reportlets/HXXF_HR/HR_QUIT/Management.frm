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
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[HXXF_HR]]></DatabaseName>
</Connection>
<Query>
<![CDATA[SELECT * FROM (
SELECT   T1.TREE_NODE,
         T1.DESCR,
         t2.parent_node,
         T2.TREE_NODE     AS TREE_NODE2,
         T2.DESCR         AS DESCR2,
         T2.TREE_NODE_NUM,
		 T2.PARENT_NODES
		 
    FROM ODM_HR_DW T1, ODM_HR_DW T2
   WHERE T2.PARENT_NODE = T1.TREE_NODE
     AND T1.TREE_NODE IN ('HX_HEAD',
                         '10001100001',
                        '100000',
                        '10041105853',
                        '10004100730',
                        '10003100439',
                        '10046109037',
                        '10039105618') --ORDER BY TREE_NODE_NUM
  UNION ALL
  SELECT 'HX_HEAD' AS TREE_NODE,
         '华夏幸福' AS DESCR,
         '' AS PARENT_NODE,
         'HX_HEAD' AS TREE_NODE2,
         '华夏幸福' AS DESCR2,
         1 AS TREE_NODE_NUM,
		 'HX_HEAD' AS PARENT_NODES
  FROM DUAL
 ) 
WHERE 1=1
and TREE_NODE2 NOT IN (SELECT T2.TREE_NODE     AS TREE_NODE2
    FROM ODM_HR_DW T1, ODM_HR_DW T2
   WHERE T2.PARENT_NODE = T1.TREE_NODE
     AND T1.TREE_NODE IN ('10039105618','10046109037'))
     ${if(len(TREE_ID_R)==0," AND 1=2"," AND PARENT_NODES LIKE '%"+TREE_ID_R+"%'")}
     --AND (PARENT_NODES like ${TREE_ID_R} )
ORDER BY TREE_NODE_NUM asc

]]></Query>
</TableData>
<TableData name="Tree1" class="com.fr.data.impl.RecursionTableData">
<markFields>
<![CDATA[3]]></markFields>
<parentmarkFields>
<![CDATA[2]]></parentmarkFields>
<markFieldsName>
<![CDATA[TREE_NODE2]]></markFieldsName>
<parentmarkFieldsName>
<![CDATA[PARENT_NODE]]></parentmarkFieldsName>
<originalTableDataName>
<![CDATA[ds1]]></originalTableDataName>
</TableData>
<TableData name="备份" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="TREE_ID_R"/>
<O>
<![CDATA[\"\'%\"+replace(VALUE(\"TREE_ID_R\",1),\",\",\"%\' OR PARENT_NODES like \'%\")+\"%\'\"]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[HXXF_HR]]></DatabaseName>
</Connection>
<Query>
<![CDATA[SELECT * FROM (
SELECT   T1.TREE_NODE,
         T1.DESCR,
         t2.parent_node,
         T2.TREE_NODE     AS TREE_NODE2,
         T2.DESCR         AS DESCR2,
         T2.TREE_NODE_NUM,
		 T2.PARENT_NODES
		 
    FROM ODM_HR_DW T1, ODM_HR_DW T2
   WHERE T2.PARENT_NODE = T1.TREE_NODE
     AND T1.TREE_NODE IN ('HX_HEAD',
                         '10001100001',
                        '100000',
                        '10041105853',
                        '10004100730',
                        '10003100439',
                        '10046109037',
                        '10039105618') --ORDER BY TREE_NODE_NUM
  UNION ALL
  SELECT 'HX_HEAD' AS TREE_NODE,
         '华夏幸福' AS DESCR,
         '' AS PARENT_NODE,
         'HX_HEAD' AS TREE_NODE2,
         '华夏幸福' AS DESCR2,
         1 AS TREE_NODE_NUM,
		 'HX_HEAD' AS PARENT_NODES
  FROM DUAL
 ) 
WHERE 1=1
and TREE_NODE2 NOT IN (SELECT T2.TREE_NODE     AS TREE_NODE2
    FROM ODM_HR_DW T1, ODM_HR_DW T2
   WHERE T2.PARENT_NODE = T1.TREE_NODE
     AND T1.TREE_NODE IN ('10039105618','10046109037'))
     --${if(len(TREE_ID_R)==0," AND 1=2"," AND PARENT_NODES LIKE '%"+TREE_ID_R+"%'")}
     AND (PARENT_NODES like ${TREE_ID_R} )
ORDER BY TREE_NODE_NUM asc

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
<LCAttr vgap="0" hgap="0" compInterval="0"/>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.plugin.form.widget.core.RHIframe">
<WidgetName name="REPORT1"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Attr scrollX="true" scrollY="true"/>
<RHIframeAttr class="com.fr.plugin.form.widget.core.RHIframeAttr">
<RHIframeSource class="com.fr.plugin.form.widget.core.TemplateSource">
<Attr path="/HXXF_HR/HR_QUIT/Management_monitoring.frm"/>
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
<BoundsAttr x="153" y="0" width="802" height="537"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TreeEditor">
<Listener event="afterinit">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="user"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$username]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[
 var username=user
  
 setTimeout(function() {    
   $('.fr-tree-elbow-end-plus', $('.fr-tree-node-collapsed')).trigger('click');

}, 50);
setTimeout(function() {    
$('#TREEEDITOR0_1').trigger('click');
}, 500);]]></Content>
</JavaScript>
</Listener>
<Listener event="click">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[//var GSID = this.getValue();
/*获取网页框URL*/
// url=parent.document.getElementById("REPORT1").contentWindow.location.href;
//alert(parent.document.getElementById("REPORT1").contentWindow.location.href)
/*var url="/WebReport/ReportServer?formlet=HXXF_HR/HR_QUIT/Management_monitoring.frm";

//contentWindow
//console(url);

FR.doHyperlinkByPost(url,{DWMC:GSID},'REPORT1');*/
var GSID = this.getValue();
/*获取网页框URL*/
//var url=parent.document.getElementById("REPORT1").contentWindow.location.href;
var url=document.getElementById("REPORT1").contentWindow.location.href;

FR.doHyperlinkByPost(url,{DWMC:GSID},'REPORT1');
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
<FormulaDictAttr kiName="TREE_NODE2" viName="DESCR2"/>
<TableDataDictAttr>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[Tree1]]></Name>
</TableData>
</TableDataDictAttr>
</Dictionary>
<widgetValue/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="153" height="537"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="treeEditor0"/>
<Widget widgetName="REPORT1"/>
</MobileWidgetList>
<WidgetZoomAttr compState="0"/>
<AppRelayout appRelayout="true"/>
<Size width="955" height="537"/>
<ResolutionScalingAttr percent="0.9"/>
<BodyLayoutType type="0"/>
</Center>
</Layout>
<DesignerVersion DesignerVersion="IAA"/>
<PreviewType PreviewType="0"/>
<TemplateID TemplateID="19ebcdec-1fdd-4a2a-95ec-0c1801054c61"/>
</Form>
