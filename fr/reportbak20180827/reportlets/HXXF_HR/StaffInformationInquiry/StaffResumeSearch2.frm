<?xml version="1.0" encoding="UTF-8"?>
<Form xmlVersion="20170715" releaseVersion="8.0.0">
<TableDataMap>
<TableData name="指标体系表" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="TREE_ID_R"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="'%"+replace(VALUE("TREE_ID_R",1),",","%' OR PARENT_NODES like '%")+"%'"]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="DWMC"/>
<O>
<![CDATA[100000]]></O>
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
<![CDATA[WITH YYQXSZ AS (
SELECT * FROM ODM_HR_DW
where 1=1
${if(proe ='GFZBZN',"AND ( PARENT_NODES like "+TREE_ID_R+")","and 1=1")}
  start with ${if(len(DWMC)=0,"TREE_NODE='10001100001'",if(DWMC="HX_HEAD","TREE_NODE='10001100001'",if(DWMC="100000","TREE_NODE='10040105798'",if(DWMC="10041105853","TREE_NODE='22222'",if(DWMC="10003100439","TREE_NODE='55555'","TREE_NODE ='"+DWMC+"'")))))} connect by  PARENT_NODE   =  prior TREE_NODE 
),
ALL_GS AS (
select * from ODM_HR_DW
),
QXPZ AS (
SELECT TREE_ID FROM HR_AUTHORITY 
WHERE RLOE_TYPE='1'
${if(len(username)==0,"and 1=0","AND NAME_ID LIKE '%"+username+"%'")}
),
GFGS_QX AS  (
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
FROM ALL_GS a,QXPZ b
WHERE 1=1
${if(proe='GFZBZN',"and INSTR(b.TREE_ID,a.TREE_NODE,1)>0 "," ")}
),
GFGS_QX_TRUE AS (
SELECT  
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
FROM ODM_HR_DW a
LEFT JOIN GFGS_QX b
ON a.TREE_NODE=b.TREE_NODE
START WITH b.PARENT_NODE='10001100001'
connect by nocycle prior a.TREE_NODE=a.PARENT_NODE
UNION ALL
SELECT *  FROM ODM_HR_DW WHERE TREE_NODE='10001100001'
),
TT AS 
(SELECT * FROM YYQXSZ WHERE 1=1
${if(proe='GFZBZN'," AND 1=2","")}
UNION ALL
SELECT * FROM GFGS_QX_TRUE 
WHERE 1=1
${if(proe='GFZBZN',"","AND 1=2")}
)
SELECT * FROM TT
ORDER BY TREE_NODE_NUM ASC
]]></Query>
</TableData>
<TableData name="指标体系" class="com.fr.data.impl.RecursionTableData">
<markFields>
<![CDATA[1]]></markFields>
<parentmarkFields>
<![CDATA[2]]></parentmarkFields>
<markFieldsName>
<![CDATA[TREE_NODE]]></markFieldsName>
<parentmarkFieldsName>
<![CDATA[PARENT_NODE]]></parentmarkFieldsName>
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
<InnerWidget class="com.fr.form.ui.TreeEditor">
<Listener event="afterinit">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[ setTimeout(function() {    
   $('.fr-tree-elbow-end-plus', $('.fr-tree-node-collapsed')).trigger('click');
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
/*员工查询报表*/
//alert(GSID)
url="ReportServer?reportlet=HXXF_HR/StaffInformationInquiry/AdvancedFilter.cpt&__cutpage__=v"

FR.doHyperlinkByPost(url,{DWMC:GSID,username:username},'REPORT4');]]></Content>
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
<![CDATA[指标体系]]></Name>
</TableData>
</TableDataDictAttr>
</Dictionary>
<widgetValue/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="941" height="528"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="treeEditor0"/>
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
<TemplateID TemplateID="a2374a58-8729-45b5-8c9c-435a25bc7b62"/>
</Form>
