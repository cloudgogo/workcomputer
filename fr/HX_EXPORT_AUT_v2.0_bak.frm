<?xml version="1.0" encoding="UTF-8"?>
<Form xmlVersion="20170720" releaseVersion="9.0.0">
<TableDataMap>
<TableData name="user" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="p_user"/>
<O>
<![CDATA[]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[finedb]]></DatabaseName>
</Connection>
<Query>
<![CDATA[--select user_id,user_name from  HX_AUTHORITY 
select  distinct u.username user_id,u.realname user_name
 from FR_T_CUSTOMROLE_USER f
 left join FR_T_USER  u  on  f.userid=u.id 
 --${if(len(p_user)=0, "", " and u.username ='"+p_user+" ' ")}
 left join FR_T_CUSTOMROLE c
  on f.customroleid=c.id
where 1=1
]]></Query>
</TableData>
<TableData name="mokuai_tab" class="com.fr.data.impl.DBTableData">
<Parameters/>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[oracle_test]]></DatabaseName>
</Connection>
<Query>
<![CDATA[
select *
  from (select distinct a.level1module levelmodule,
                        a.level1code levelcode,
                        
                        null           father_id
          from DM_EXPORT_PRIVILEGE a
         where classify = 'tab'
        
        union all
        
        select distinct a.level2module levelmodule,
                        a.level2code levelcode,
                        
                        a.level1code   father_id
          from DM_EXPORT_PRIVILEGE a
         where classify = 'tab'
        
        union all
        
        select distinct a.tab_code levelmodule,
                        
                        a.codes levelcode,
                        a.level2code father_id
          from DM_EXPORT_PRIVILEGE a
         where classify = 'tab')
    
order by levelcode
]]></Query>
</TableData>
<TableData name="Tree1" class="com.fr.data.impl.RecursionTableData">
<markFields>
<![CDATA[1]]></markFields>
<parentmarkFields>
<![CDATA[3]]></parentmarkFields>
<markFieldsName>
<![CDATA[LEVELCODE]]></markFieldsName>
<parentmarkFieldsName>
<![CDATA[FATHER_ID]]></parentmarkFieldsName>
<originalTableDataName>
<![CDATA[mokuai_tab]]></originalTableDataName>
</TableData>
<TableData name="mokuai_export" class="com.fr.data.impl.DBTableData">
<Parameters/>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[oracle_test]]></DatabaseName>
</Connection>
<Query>
<![CDATA[select *
  from (select distinct a.level1module levelmodule,
                        a.level1code   levelcode,
                        null           codes,
                        null           father_id
          from DM_EXPORT_PRIVILEGE a
         where 1 = 1
         and a.classify = 'export'
           --and a.tab_code like '%大项目%'
        union all
        
        select distinct a.level3module levelmodule,
                        a.codes        levelcode,
                        a.order_code   codes,
                        a.level1code     father_id
          from DM_EXPORT_PRIVILEGE a
         where 1 = 1
           --and a.tab_code like '%大项目%'
           and a.classify = 'export')
order by codes]]></Query>
</TableData>
<TableData name="Tree2" class="com.fr.data.impl.RecursionTableData">
<markFields>
<![CDATA[1]]></markFields>
<parentmarkFields>
<![CDATA[3]]></parentmarkFields>
<markFieldsName>
<![CDATA[LEVELCODE]]></markFieldsName>
<parentmarkFieldsName>
<![CDATA[FATHER_ID]]></parentmarkFieldsName>
<originalTableDataName>
<![CDATA[mokuai_export]]></originalTableDataName>
</TableData>
<TableData name="ds1" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="p_user"/>
<O>
<![CDATA[fengzhihong]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[oracle_test]]></DatabaseName>
</Connection>
<Query>
<![CDATA[select tab_id from hx_authority where user_id='${p_user}']]></Query>
</TableData>
</TableDataMap>
<FormMobileAttr>
<FormMobileAttr refresh="false" isUseHTML="false" isMobileOnly="false" isAdaptivePropertyAutoMatch="false"/>
</FormMobileAttr>
<Parameters>
<Parameter>
<Attributes name="p_tab"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="p_user"/>
<O>
<![CDATA[fengzhihong]]></O>
</Parameter>
<Parameter>
<Attributes name="p_export"/>
<O>
<![CDATA[]]></O>
</Parameter>
</Parameters>
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
<InnerWidget class="com.fr.form.ui.TextEditor">
<WidgetName name="textEditor0"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<TextAttr/>
<Reg class="com.fr.form.ui.reg.NoneReg"/>
<widgetValue>
<databinding>
<![CDATA[{Name:ds1,Key:TAB_ID}]]></databinding>
</widgetValue>
</InnerWidget>
<BoundsAttr x="389" y="15" width="80" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TextEditor">
<WidgetName name="p_export_name"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<TextAttr/>
<Reg class="com.fr.form.ui.reg.NoneReg"/>
<widgetValue>
<O>
<![CDATA[]]></O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="563" y="18" width="80" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TextEditor">
<WidgetName name="p_tab_name"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<TextAttr/>
<Reg class="com.fr.form.ui.reg.NoneReg"/>
<widgetValue>
<O>
<![CDATA[]]></O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="297" y="18" width="80" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TextEditor">
<WidgetName name="p_user_name"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<TextAttr/>
<Reg class="com.fr.form.ui.reg.NoneReg"/>
<widgetValue/>
</InnerWidget>
<BoundsAttr x="100" y="18" width="80" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.cardlayout.WCardMainBorderLayout">
<WidgetName name="tablayout2"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="1" color="-723724" borderRadius="0" type="1" borderStyle="0"/>
<WidgetTitle>
<O>
<![CDATA[新建标题]]></O>
<FRFont name="微软雅黑" style="0" size="72"/>
<Position pos="0"/>
<Background name="ColorBackground" color="-13400848"/>
</WidgetTitle>
<Alpha alpha="1.0"/>
</Border>
<LCAttr vgap="0" hgap="0" compInterval="0"/>
<NorthAttr size="36"/>
<North class="com.fr.form.ui.container.cardlayout.WCardTitleLayout">
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
<EastAttr size="25"/>
<East class="com.fr.form.ui.CardAddButton">
<WidgetName name="Add"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<AddTagAttr layoutName="cardlayout2"/>
</East>
<Center class="com.fr.form.ui.container.cardlayout.WCardTagLayout">
<WidgetName name="tabpane2"/>
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
<LCAttr vgap="0" hgap="1" compInterval="0"/>
<Widget class="com.fr.form.ui.CardSwitchButton">
<WidgetName name="f84d2629-556f-4595-8570-7ea2d0c4ef21"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Text>
<![CDATA[导出权限]]></Text>
<SwitchTagAttr layoutName="cardlayout2"/>
</Widget>
<DisplayPosition type="0"/>
<FLAttr alignment="0"/>
<ColumnWidth defaultValue="80">
<![CDATA[80,80,80,80,80,80,80,80,80,80,80]]></ColumnWidth>
<TextDirection type="0"/>
<TemplateStyle class="com.fr.general.cardtag.DefaultTemplateStyle"/>
</Center>
<CardTitleLayout layoutName="cardlayout2"/>
</North>
<Center class="com.fr.form.ui.container.WCardLayout">
<WidgetName name="cardlayout2"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="1" color="-723724" borderRadius="0" type="1" borderStyle="0"/>
<WidgetTitle>
<O>
<![CDATA[新建标题]]></O>
<FRFont name="微软雅黑" style="0" size="72"/>
<Position pos="0"/>
<Background name="ColorBackground" color="-13400848"/>
</WidgetTitle>
<Alpha alpha="1.0"/>
</Border>
<LCAttr vgap="0" hgap="0" compInterval="0"/>
<Widget class="com.fr.form.ui.container.cardlayout.WTabFitLayout">
<WidgetName name="Tab0"/>
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
<InnerWidget class="com.fr.form.ui.TreeEditor">
<Listener event="click">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[//获取树节点
var v_export= this.options.form.getWidgetByName("treeEditor3").getValue();  //alert(v_export);

//设置文本控件的值
var p_export= this.options.form.getWidgetByName("p_export");  
p_export.setValue(v_export);  

//查询树节点对应的名称
var sql1="select replace('"+v_export+"', ',', ''',''') from dual";
var rs1=FR.remoteEvaluate('sql("oracle_test"," '+sql1+' ",1)'); 
//alert(rs1);

var sql2=" select a.level3module from dm_export_privilege a where 1=1 and a.classify='export' and a.codes in ('"+rs1+"') ";
var rs2=FR.remoteEvaluate('sql("oracle_test","'+sql2+'",1)'); 
//alert(rs2);

//设置文本控件的值
var p_export_name= this.options.form.getWidgetByName("p_export_name");  
p_export_name.setValue(rs2);  

]]></Content>
</JavaScript>
</Listener>
<WidgetName name="treeEditor3"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<TreeAttr mutiSelect="true" selectLeafOnly="true"/>
<isLayerBuild isLayerBuild="false"/>
<isAutoBuild autoBuild="false"/>
<isPerformanceFirst performanceFirst="false"/>
<Dictionary class="com.fr.data.impl.TableDataDictionary">
<FormulaDictAttr kiName="LEVELCODE" viName="LEVELMODULE"/>
<TableDataDictAttr>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[Tree2]]></Name>
</TableData>
</TableDataDictAttr>
</Dictionary>
<widgetValue>
<O>
<![CDATA[]]></O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="0" y="0" width="260" height="382"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="treeEditor3"/>
</MobileWidgetList>
<WidgetZoomAttr compState="0"/>
<AppRelayout appRelayout="true"/>
<Size width="260" height="382"/>
<ResolutionScalingAttr percent="0.9"/>
<tabFitAttr index="0" tabNameIndex="0"/>
</Widget>
<carouselAttr isCarousel="false" carouselInterval="1.8"/>
</Center>
</InnerWidget>
<BoundsAttr x="483" y="50" width="234" height="380"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TextEditor">
<WidgetName name="p_export"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<TextAttr/>
<Reg class="com.fr.form.ui.reg.NoneReg"/>
<widgetValue>
<O>
<![CDATA[]]></O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="483" y="18" width="80" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TextEditor">
<WidgetName name="p_tab"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<TextAttr/>
<Reg class="com.fr.form.ui.reg.NoneReg"/>
<widgetValue>
<O>
<![CDATA[]]></O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="217" y="18" width="80" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TextEditor">
<WidgetName name="p_user"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<TextAttr/>
<Reg class="com.fr.form.ui.reg.NoneReg"/>
<widgetValue>
<O>
<![CDATA[]]></O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="10" y="18" width="80" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.FreeButton">
<Listener event="click">
<JavaScript class="com.fr.js.Commit2DBJavaScript">
<Parameters/>
<Attributes dsName="oracle_test" name="提交1"/>
<DMLConfig class="com.fr.write.config.IntelliDMLConfig">
<Table schema="BASS_DW" name="HX_AUTHORITY"/>
<ColumnConfig name="ID" isKey="false" skipUnmodified="false">
<O>
<![CDATA[]]></O>
</ColumnConfig>
<ColumnConfig name="USER_ID" isKey="false" skipUnmodified="false">
<O t="WidgetName" class="WidgetName">
<WidetName name="p_user"/>
</O>
</ColumnConfig>
<ColumnConfig name="USER_NAME" isKey="false" skipUnmodified="false">
<O t="WidgetName" class="WidgetName">
<WidetName name="p_user_name"/>
</O>
</ColumnConfig>
<ColumnConfig name="TAB_ID" isKey="false" skipUnmodified="false">
<O t="WidgetName" class="WidgetName">
<WidetName name="p_tab"/>
</O>
</ColumnConfig>
<ColumnConfig name="TAB_NAME" isKey="false" skipUnmodified="false">
<O t="WidgetName" class="WidgetName">
<WidetName name="p_tab_name"/>
</O>
</ColumnConfig>
<ColumnConfig name="EXPORT_ID" isKey="false" skipUnmodified="false">
<O t="WidgetName" class="WidgetName">
<WidetName name="p_export"/>
</O>
</ColumnConfig>
<ColumnConfig name="EXPORT_NAME" isKey="false" skipUnmodified="false">
<O t="WidgetName" class="WidgetName">
<WidetName name="p_export_name"/>
</O>
</ColumnConfig>
<ColumnConfig name="CREATE_TIME" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=NOW()]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="CREATER" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$fr_username]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="UPDATE_TIME" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=NOW()]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="UPDATE_PERSON" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$fr_username]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="ORG_ID" isKey="false" skipUnmodified="false">
<O>
<![CDATA[]]></O>
</ColumnConfig>
<ColumnConfig name="MOKUAI_NAME" isKey="false" skipUnmodified="false">
<O>
<![CDATA[]]></O>
</ColumnConfig>
<ColumnConfig name="ISMOKUAI" isKey="false" skipUnmodified="false">
<O>
<![CDATA[]]></O>
</ColumnConfig>
<Condition class="com.fr.data.condition.ListCondition"/>
</DMLConfig>
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[if (fr_submitinfo.success) {  
    FR.Msg.toast('提交成功');  
    location.reload();  
} else {  
    FR.Msg.toast('提交失败');  
}  ]]></Content>
</JavaScript>
</JavaScript>
</Listener>
<WidgetName name="button0"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Text>
<![CDATA[提交]]></Text>
</InnerWidget>
<BoundsAttr x="10" y="440" width="80" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.cardlayout.WCardMainBorderLayout">
<WidgetName name="tablayout1"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="1" color="-723724" borderRadius="0" type="1" borderStyle="0"/>
<WidgetTitle>
<O>
<![CDATA[新建标题]]></O>
<FRFont name="微软雅黑" style="0" size="72"/>
<Position pos="0"/>
<Background name="ColorBackground" color="-13400848"/>
</WidgetTitle>
<Alpha alpha="1.0"/>
</Border>
<LCAttr vgap="0" hgap="0" compInterval="0"/>
<NorthAttr size="36"/>
<North class="com.fr.form.ui.container.cardlayout.WCardTitleLayout">
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
<EastAttr size="25"/>
<East class="com.fr.form.ui.CardAddButton">
<WidgetName name="Add"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<AddTagAttr layoutName="cardlayout1"/>
</East>
<Center class="com.fr.form.ui.container.cardlayout.WCardTagLayout">
<WidgetName name="tabpane1"/>
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
<LCAttr vgap="0" hgap="1" compInterval="0"/>
<Widget class="com.fr.form.ui.CardSwitchButton">
<WidgetName name="fcefde2c-8189-49b4-8800-51eec16e12d7"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Text>
<![CDATA[tab权限]]></Text>
<SwitchTagAttr layoutName="cardlayout1"/>
</Widget>
<DisplayPosition type="0"/>
<FLAttr alignment="0"/>
<ColumnWidth defaultValue="80">
<![CDATA[80,80,80,80,80,80,80,80,80,80,80]]></ColumnWidth>
<TextDirection type="0"/>
<TemplateStyle class="com.fr.general.cardtag.DefaultTemplateStyle"/>
</Center>
<CardTitleLayout layoutName="cardlayout1"/>
</North>
<Center class="com.fr.form.ui.container.WCardLayout">
<WidgetName name="cardlayout1"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="1" color="-723724" borderRadius="0" type="1" borderStyle="0"/>
<WidgetTitle>
<O>
<![CDATA[新建标题]]></O>
<FRFont name="微软雅黑" style="0" size="72"/>
<Position pos="0"/>
<Background name="ColorBackground" color="-13400848"/>
</WidgetTitle>
<Alpha alpha="1.0"/>
</Border>
<LCAttr vgap="0" hgap="0" compInterval="0"/>
<Widget class="com.fr.form.ui.container.cardlayout.WTabFitLayout">
<Listener event="click">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[null]]></Content>
</JavaScript>
</Listener>
<WidgetName name="Tab0"/>
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
<InnerWidget class="com.fr.form.ui.TreeEditor">
<Listener event="click">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[//获取选择的树节点
var v_tab= this.options.form.getWidgetByName("treeEditor1").getValue();  

//设置文本控件的值
var p_tab= this.options.form.getWidgetByName("p_tab");  
p_tab.setValue(v_tab); 

var sql1="select replace('"+v_tab+"', ',', ''',''') from dual";
var rs1=FR.remoteEvaluate('sql("oracle_test"," '+sql1+' ",1)'); 

var sql2=" select tab_code from dm_export_privilege a where 1=1 and a.classify='tab' and a.codes in ('"+rs1+"') ";
var rs2=FR.remoteEvaluate('sql("oracle_test","'+sql2+'",1)'); 

//设置文本控件的值
var p_tab_name= this.options.form.getWidgetByName("p_tab_name");  
p_tab_name.setValue(rs2); 

 ]]></Content>
</JavaScript>
</Listener>
<WidgetName name="treeEditor1"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<TreeAttr mutiSelect="true" selectLeafOnly="true"/>
<isLayerBuild isLayerBuild="false"/>
<isAutoBuild autoBuild="false"/>
<isPerformanceFirst performanceFirst="false"/>
<Dictionary class="com.fr.data.impl.TableDataDictionary">
<FormulaDictAttr kiName="LEVELCODE" viName="LEVELMODULE"/>
<TableDataDictAttr>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[Tree1]]></Name>
</TableData>
</TableDataDictAttr>
</Dictionary>
<widgetValue>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=sql("oracle_test", " select tab_id from hx_authority where user_id='"+$p_user+"' ", 1)]]></Attributes>
</O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="0" y="0" width="260" height="382"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="treeEditor1"/>
</MobileWidgetList>
<WidgetZoomAttr compState="0"/>
<AppRelayout appRelayout="true"/>
<Size width="260" height="382"/>
<ResolutionScalingAttr percent="0.9"/>
<tabFitAttr index="0" tabNameIndex="0"/>
</Widget>
<carouselAttr isCarousel="false" carouselInterval="1.8"/>
</Center>
</InnerWidget>
<BoundsAttr x="215" y="50" width="234" height="380"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.cardlayout.WCardMainBorderLayout">
<WidgetName name="tablayout0"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="1" color="-723724" borderRadius="0" type="1" borderStyle="0"/>
<WidgetTitle>
<O>
<![CDATA[新建标题]]></O>
<FRFont name="微软雅黑" style="0" size="72"/>
<Position pos="0"/>
<Background name="ColorBackground" color="-13400848"/>
</WidgetTitle>
<Alpha alpha="1.0"/>
</Border>
<LCAttr vgap="0" hgap="0" compInterval="0"/>
<NorthAttr size="36"/>
<North class="com.fr.form.ui.container.cardlayout.WCardTitleLayout">
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
<EastAttr size="25"/>
<East class="com.fr.form.ui.CardAddButton">
<WidgetName name="Add"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<AddTagAttr layoutName="cardlayout0"/>
</East>
<Center class="com.fr.form.ui.container.cardlayout.WCardTagLayout">
<WidgetName name="tabpane0"/>
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
<LCAttr vgap="0" hgap="1" compInterval="0"/>
<Widget class="com.fr.form.ui.CardSwitchButton">
<WidgetName name="5130168f-c143-42eb-ab86-65d0241e2396"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Text>
<![CDATA[用户]]></Text>
<SwitchTagAttr layoutName="cardlayout0"/>
</Widget>
<DisplayPosition type="0"/>
<FLAttr alignment="0"/>
<ColumnWidth defaultValue="80">
<![CDATA[80,80,80,80,80,80,80,80,80,80,80]]></ColumnWidth>
<TextDirection type="0"/>
<TemplateStyle class="com.fr.general.cardtag.DefaultTemplateStyle"/>
</Center>
<CardTitleLayout layoutName="cardlayout0"/>
</North>
<Center class="com.fr.form.ui.container.WCardLayout">
<WidgetName name="cardlayout0"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="1" color="-723724" borderRadius="0" type="1" borderStyle="0"/>
<WidgetTitle>
<O>
<![CDATA[新建标题]]></O>
<FRFont name="微软雅黑" style="0" size="72"/>
<Position pos="0"/>
<Background name="ColorBackground" color="-13400848"/>
</WidgetTitle>
<Alpha alpha="1.0"/>
</Border>
<LCAttr vgap="0" hgap="0" compInterval="0"/>
<Widget class="com.fr.form.ui.container.cardlayout.WTabFitLayout">
<WidgetName name="Tab0"/>
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
<InnerWidget class="com.fr.form.ui.TreeEditor">
<Listener event="click">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[var v_user= this.options.form.getWidgetByName("treeEditor0").getValue();  

var p_user= this.options.form.getWidgetByName("p_user");  
p_user.setValue(v_user);  

var sql1=" select realname from  FR_T_USER  u  where 1=1 and u.username='"+v_user+"' ";

var rs1=FR.remoteEvaluate('sql("finedb","'+sql1+'",1)'); 

var p_user_name= this.options.form.getWidgetByName("p_user_name");  
p_user_name.setValue(rs1);

//this.options.form.getWidgetByName("treeEditor1").setValue('zzpd001');
var sql2="select tab_id from hx_authority where user_id='"+v_user+"'";
var rs2=FR.remoteEvaluate('sql("oracle_test","'+sql2+'",1)');
var a= this.options.form.getWidgetByName("treeEditor1").getValue();  
alert(a);
//_g().getWidgetByName("treeEditor1").setValue(rs2);

]]></Content>
</JavaScript>
</Listener>
<WidgetName name="treeEditor0"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<TreeAttr selectLeafOnly="true"/>
<isLayerBuild isLayerBuild="false"/>
<TreeNodeAttr>
<Dictionary class="com.fr.data.impl.TableDataDictionary">
<FormulaDictAttr kiName="USER_ID" viName="USER_NAME"/>
<TableDataDictAttr>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[user]]></Name>
</TableData>
</TableDataDictAttr>
</Dictionary>
</TreeNodeAttr>
<isAutoBuild autoBuild="false"/>
<isPerformanceFirst performanceFirst="false"/>
<widgetValue>
<O>
<![CDATA[]]></O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="0" y="0" width="200" height="382"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="treeEditor0"/>
</MobileWidgetList>
<WidgetZoomAttr compState="0"/>
<AppRelayout appRelayout="true"/>
<Size width="200" height="382"/>
<ResolutionScalingAttr percent="0.9"/>
<tabFitAttr index="0" tabNameIndex="0"/>
</Widget>
<carouselAttr isCarousel="false" carouselInterval="1.8"/>
</Center>
</InnerWidget>
<BoundsAttr x="10" y="50" width="180" height="380"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="textEditor0"/>
<Widget widgetName="p_user"/>
<Widget widgetName="p_user_name"/>
<Widget widgetName="p_tab"/>
<Widget widgetName="p_tab_name"/>
<Widget widgetName="p_export"/>
<Widget widgetName="p_export_name"/>
<Widget widgetName="tablayout0"/>
<Widget widgetName="tablayout1"/>
<Widget widgetName="tablayout2"/>
<Widget widgetName="button0"/>
</MobileWidgetList>
<WidgetScalingAttr compState="0"/>
<DesignResolution absoluteResolutionScaleW="1366" absoluteResolutionScaleH="768"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="960" height="540"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="absolute0"/>
</MobileWidgetList>
<WidgetZoomAttr compState="0"/>
<AppRelayout appRelayout="true"/>
<Size width="960" height="540"/>
<ResolutionScalingAttr percent="0.9"/>
<BodyLayoutType type="0"/>
</Center>
</Layout>
<DesignerVersion DesignerVersion="JAA"/>
<PreviewType PreviewType="0"/>
<TemplateID TemplateID="6f0077fd-2759-466d-a18d-3cd4a008d0af"/>
<TemplateIdAttMark class="com.fr.base.iofileattr.TemplateIdAttrMark">
<TemplateIdAttMark TemplateId="57a9ce13-1b3c-4240-8da9-5456aa6e2f3b"/>
</TemplateIdAttMark>
</Form>
