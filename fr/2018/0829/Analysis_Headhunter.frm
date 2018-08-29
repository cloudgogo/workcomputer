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
<![CDATA[SELECT 
T1.TREE_NODE,T1.PARENT_NODE,T1.DESCR,T1.TREE_NODE_NUM FROM ODM_HR_DW T1
WHERE BACK_ANA='1'
--WHERE  INSTR(T1.PARENT_NODES,'${TREE_ID_R}',1)>0 
ORDER BY T1.TREE_NODE_NUM ]]></Query>
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
<Attr path="/HXXF_HR/Recruitment_analysis/Recruit_Headhunter.frm"/>
</RHIframeSource>
<Parameters>
<Parameter>
<Attributes name="DWMC"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$DWMC]]></Attributes>
</O>
</Parameter>
</Parameters>
</RHIframeAttr>
</InnerWidget>
<BoundsAttr x="181" y="0" width="774" height="535"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TreeEditor">
<Listener event="click">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[var DWMC=this.getValue();

var url=document.getElementById("REPORT1").contentWindow.location.href;
 
/*url="/WebReport/ReportServer?reportlet=TEST/Recruit_YuSuan.frm&__cutpage__=v";*/

FR.doHyperlinkByPost(url,{DWMC:DWMC},'REPORT1');


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
}, 150);]]></Content>
</JavaScript>
</Listener>
<WidgetName name="treeEditor0"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<fontSize>
<![CDATA[28]]></fontSize>
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
<BoundsAttr x="0" y="0" width="181" height="535"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="treeEditor0"/>
<Widget widgetName="REPORT1"/>
</MobileWidgetList>
<WidgetZoomAttr compState="0"/>
<AppRelayout appRelayout="true"/>
<Size width="955" height="535"/>
<ResolutionScalingAttr percent="0.9"/>
<BodyLayoutType type="0"/>
</Center>
</Layout>
<DesignerVersion DesignerVersion="IAA"/>
<PreviewType PreviewType="0"/>
<TemplateID TemplateID="90c24055-d2e0-491e-a9c8-d996d3eff4ad"/>
</Form>
