<?xml version="1.0" encoding="UTF-8"?>
<Form xmlVersion="20170715" releaseVersion="8.0.0">
<TableDataMap>
<TableData name="ds1" class="com.fr.data.impl.DBTableData">
<Parameters/>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[HXXF_HR]]></DatabaseName>
</Connection>
<Query>
<![CDATA[select
*
from
ODM_HR_DW ORDER BY TREE_NODE_NUM asc]]></Query>
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
<TableData name="指标体系表" class="com.fr.data.impl.DBTableData">
<Parameters/>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[HXXF_HR]]></DatabaseName>
</Connection>
<Query>
<![CDATA[select *
from
ODM_HR_HR
order by paix ASC]]></Query>
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
<NorthAttr/>
<North class="com.fr.form.ui.container.WParameterLayout">
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
<Background name="ColorBackground"/>
<LCAttr vgap="0" hgap="0" compInterval="0"/>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TextEditor">
<WidgetName name="test1"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<TextAttr/>
<widgetValue>
<O>
<![CDATA[]]></O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="342" y="18" width="80" height="21"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="test1"/>
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
<Attr path="/GettingStarted.cpt"/>
</RHIframeSource>
<Parameters/>
</RHIframeAttr>
</InnerWidget>
<BoundsAttr x="438" y="0" width="519" height="538"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TreeEditor">
<Listener event="click">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[var url = ""; 

 	url="http://10.2.95.62:8080/WebReport/ReportServer?reportlet=HXXF_HR%2FHRanalysis%2FEmploymentChange.cpt&&op=write";

FR.doHyperlinkByPost(url,{},'REPORT1');
alert(url)]]></Content>
</JavaScript>
</Listener>
<WidgetName name="treeEditor1"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
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
<BoundsAttr x="213" y="0" width="225" height="538"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TreeEditor">
<Listener event="afterinit">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[setTimeout(function(){
      $('.fr-tree-node-collapsed').trigger('click');      
        } , 100);]]></Content>
</JavaScript>
</Listener>
<Listener event="click">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[var GSID = this.getValue();
var temp= contentPane.parameterEl.getWidgetByName("REPORTURL1");
var url = ""; 
 url=temp.getValue();
 if(url==null || url==""){
 	url="http://10.2.95.62:8080/WebReport/ReportServer?reportlet=HXXF_HR%2FHRanalysis%2FEmploymentChange.cpt&&op=write";
 } 
 $("input[name='test1']A").val(GSID);
FR.doHyperlinkByPost(url,{DWMC:GSID},'REPORT1');
]]></Content>
</JavaScript>
</Listener>
<Listener event="click">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[
 	url="http://10.2.95.62:8080/WebReport/ReportServer?reportlet=HXXF_HR%2FHRanalysis%2FEmploymentChange.cpt&&op=write";

 $("input[name='TEST1']A").val('testt');
FR.doHyperlinkByPost(url,{},'REPORT1');]]></Content>
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
<BoundsAttr x="0" y="0" width="213" height="538"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="treeEditor0"/>
<Widget widgetName="treeEditor1"/>
</MobileWidgetList>
<WidgetZoomAttr compState="0"/>
<AppRelayout appRelayout="true"/>
<Size width="957" height="538"/>
<ResolutionScalingAttr percent="0.9"/>
<BodyLayoutType type="0"/>
</Center>
</Layout>
<DesignerVersion DesignerVersion="IAA"/>
<PreviewType PreviewType="0"/>
<TemplateID TemplateID="9636923b-c8d3-42b7-9b89-c726e0c2ae2e"/>
</Form>
