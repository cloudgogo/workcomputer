<?xml version="1.0" encoding="UTF-8"?>
<Form xmlVersion="20170720" releaseVersion="9.0.0">
<TableDataMap>
<TableData name="user" class="com.fr.data.impl.DBTableData">
<Parameters/>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[findb]]></DatabaseName>
</Connection>
<Query>
<![CDATA[
select  distinct u."username" user_id, u."username"||'('||u."realname"||')' user_name
 from "MCANALYSIS"."FR_T_CustomRole_User" f
 left join "MCANALYSIS"."FR_T_USER"  u  on  f."Userid"=u."id"
 left join "MCANALYSIS"."FR_T_CUSTOMROLE" c
  on f."CustomRoleid"=c."id"
where 1=1 
order by u."username"

]]></Query>
</TableData>
<TableData name="mokuai_tab" class="com.fr.data.impl.DBTableData">
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
<![CDATA[oracle_test]]></DatabaseName>
</Connection>
<Query>
<![CDATA[WITH ASD AS
 (select distinct a.level1code, a.level2code
    from DM_EXPORT_PRIVILEGE a
   where classify = 'tab'
     and a.codes in
         (select regexp_substr(a.TAB_ID, '[^,]A+', 1, level, 'i') as id_arr
            from (select TAB_ID
                    from hx_authority a
                   where a.user_id = '${p_user}') a
          connect by level <= length(a.TAB_ID) -
                     length(regexp_replace(a.TAB_ID, ',', '')) + 1))
select *
  from (select distinct a.level1module levelmodule,
                        a.level1code   levelcode,
                        
                        null father_id
          from DM_EXPORT_PRIVILEGE a
         where classify = 'tab'
        
        union all
        
        select distinct a.level2module levelmodule,
                        a.level2code   levelcode,
                        
                        a.level1code father_id
          from DM_EXPORT_PRIVILEGE a
         where classify = 'tab'
        
        union all
        
        select distinct a.tab_code levelmodule,
                        
                        a.codes      levelcode,
                        a.level2code father_id
          from DM_EXPORT_PRIVILEGE a
         where classify = 'tab'),
       ASD
 where 1 = 1
   and (levelcode like ASD.level2code || '%' or
       (levelcode like ASD.level1code || '%' and father_id is null))

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
<![CDATA[oracle_test]]></DatabaseName>
</Connection>
<Query>
<![CDATA[WITH ASD AS
 (select distinct a.level1code, a.level2code
    from DM_EXPORT_PRIVILEGE a
   where classify = 'export'
     and a.codes in
         (select regexp_substr(a.export_id, '[^,]A+', 1, level, 'i') as id_arr
            from (select export_id
                    from hx_authority a
                   where a.user_id = '${p_user}') a
          connect by level <= length(a.export_id) -
                     length(regexp_replace(a.export_id, ',', '')) + 1))

select *
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
                        a.level1code   father_id
          from DM_EXPORT_PRIVILEGE a
         where 1 = 1
              --and a.tab_code like '%大项目%'
           and a.classify = 'export'), asd
   where 1=1       
   and levelcode like ASD.level1code || '%'
           
 order by codes
]]></Query>
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
<Parameters/>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[findb]]></DatabaseName>
</Connection>
<Query>
<![CDATA[SELECT * FROM "MCANALYSIS"."FR_T_CustomRole_User"]]></Query>
</TableData>
</TableDataMap>
<FormMobileAttr>
<FormMobileAttr refresh="false" isUseHTML="false" isMobileOnly="false" isAdaptivePropertyAutoMatch="false"/>
</FormMobileAttr>
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
<Listener event="afterinit">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[//var t = 2;     
//for(var m = 1; m <= t; m++) {    
//    //循环执行“+”号展开    
//    $('.fr-tree-elbow-plus').trigger('click');    
//}    
//$('.fr-tree-elbow-end-plus').trigger('click'); 

$(".fr-tree-node").css("color","blue");
//alert("1111111111111:"+$(".fr-tree-node"));]]></Content>
</JavaScript>
</Listener>
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
<WidgetName name="p_export_name"/>
<WidgetAttr invisible="true" description="">
<PrivilegeControl/>
</WidgetAttr>
<TextAttr/>
<Reg class="com.fr.form.ui.reg.NoneReg"/>
<widgetValue>
<O>
<![CDATA[]]></O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="609" y="421" width="79" height="20"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TextEditor">
<WidgetName name="p_tab_name"/>
<WidgetAttr invisible="true" description="">
<PrivilegeControl/>
</WidgetAttr>
<TextAttr/>
<Reg class="com.fr.form.ui.reg.NoneReg"/>
<widgetValue>
<O>
<![CDATA[]]></O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="372" y="421" width="79" height="20"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TextEditor">
<WidgetName name="p_user_name"/>
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
<BoundsAttr x="139" y="421" width="79" height="20"/>
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
<NorthAttr size="30"/>
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
<![CDATA[导出权限    ]]></Text>
<initial>
<Background name="ColorBackground" color="-1512721"/>
</initial>
<click>
<Background name="ColorBackground" color="-4259840"/>
</click>
<isCustomType isCustomType="true"/>
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
<FRFont name="微软雅黑" style="1" size="80" foreground="-1"/>
<Position pos="0"/>
<Background name="ColorBackground" color="-986120"/>
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
<BoundsAttr x="0" y="0" width="255" height="388"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="treeEditor3"/>
</MobileWidgetList>
<WidgetZoomAttr compState="0"/>
<AppRelayout appRelayout="true"/>
<Size width="255" height="388"/>
<ResolutionScalingAttr percent="0.9"/>
<tabFitAttr index="0" tabNameIndex="0">
<initial>
<Background name="ColorBackground" color="-1512721"/>
</initial>
<click>
<Background name="ColorBackground" color="-4259840"/>
</click>
<isCustomStyle isCustomStyle="true"/>
</tabFitAttr>
</Widget>
<carouselAttr isCarousel="false" carouselInterval="1.8"/>
</Center>
</InnerWidget>
<BoundsAttr x="529" y="31" width="229" height="379"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TextEditor">
<WidgetName name="p_export"/>
<WidgetAttr invisible="true" description="">
<PrivilegeControl/>
</WidgetAttr>
<TextAttr/>
<Reg class="com.fr.form.ui.reg.NoneReg"/>
<widgetValue>
<O>
<![CDATA[]]></O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="529" y="421" width="79" height="20"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TextEditor">
<WidgetName name="p_tab"/>
<WidgetAttr invisible="true" description="">
<PrivilegeControl/>
</WidgetAttr>
<TextAttr/>
<Reg class="com.fr.form.ui.reg.NoneReg"/>
<widgetValue>
<O>
<![CDATA[]]></O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="292" y="421" width="79" height="20"/>
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
<BoundsAttr x="49" y="421" width="79" height="20"/>
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
<ColumnConfig name="USER_ID" isKey="true" skipUnmodified="false">
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
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[len(p_user)<>0]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="0">
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[len(p_tab)<>0]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[len(p_export)<>0]]></Formula>
</Condition>
</JoinCondition>
</Condition>
</JoinCondition>
</Condition>
</DMLConfig>
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[var v_user=this.options.form.getWidgetByName("p_user").getValue(); 
var v_tab=this.options.form.getWidgetByName("p_tab").getValue(); 
var v_export=this.options.form.getWidgetByName("p_export").getValue(); 

if (v_user!="" && (v_tab!="" || v_export!="")   ) {
	if (fr_submitinfo.success) { 
		FR.Msg.toast('提交成功');  
	    //location.reload(); 
//	    setTimeout(function() { 
//	    	   location.reload(); 
//	    }, 2000);
	     
	} else {  
	    FR.Msg.toast('提交失败');  
	}  
}else{
	FR.Msg.toast('提交失败，请检查后重新提交'); 
}

]]></Content>
</JavaScript>
</JavaScript>
</Listener>
<WidgetName name="button0"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Text>
<![CDATA[提交]]></Text>
<initial>
<Background name="ColorBackground" color="-4259840"/>
</initial>
<over>
<Background name="ColorBackground" color="-5701632"/>
</over>
<click>
<Background name="ColorBackground" color="-6815744"/>
</click>
<FRFont name="微软雅黑" style="0" size="72" foreground="-1"/>
<isCustomType isCustomType="true"/>
</InnerWidget>
<BoundsAttr x="49" y="442" width="79" height="20"/>
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
<NorthAttr size="30"/>
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
<![CDATA[tab权限    ]]></Text>
<initial>
<Background name="ColorBackground" color="-1512721"/>
</initial>
<click>
<Background name="ColorBackground" color="-4259840"/>
</click>
<isCustomType isCustomType="true"/>
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
<FRFont name="微软雅黑" style="1" size="80" foreground="-1"/>
<Position pos="0"/>
<Background name="ColorBackground" color="-986120"/>
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
<O>
<![CDATA[]]></O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="0" y="0" width="255" height="388"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="treeEditor1"/>
</MobileWidgetList>
<WidgetZoomAttr compState="0"/>
<AppRelayout appRelayout="true"/>
<Size width="255" height="388"/>
<ResolutionScalingAttr percent="0.9"/>
<tabFitAttr index="0" tabNameIndex="0">
<initial>
<Background name="ColorBackground" color="-1512721"/>
</initial>
<click>
<Background name="ColorBackground" color="-4259840"/>
</click>
<isCustomStyle isCustomStyle="true"/>
</tabFitAttr>
</Widget>
<carouselAttr isCarousel="false" carouselInterval="1.8"/>
</Center>
</InnerWidget>
<BoundsAttr x="292" y="31" width="229" height="379"/>
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
<NorthAttr size="30"/>
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
<![CDATA[用户      ]]></Text>
<initial>
<Background name="ColorBackground" color="-1512721"/>
</initial>
<click>
<Background name="ColorBackground" color="-4259840"/>
</click>
<isCustomType isCustomType="true"/>
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
<FRFont name="微软雅黑" style="1" size="80" foreground="-1"/>
<Position pos="0"/>
<Background name="ColorBackground" color="-986120"/>
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
<InnerWidget class="com.fr.form.ui.FreeButton">
<Listener event="click">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[var v_user= this.options.form.getWidgetByName("textEditor0").getValue();

if (v_user != null) {
	var sql="  select distinct username from FR_T_CUSTOMROLE_USER f left join FR_T_USER  u  on  f.userid=u.id  left join FR_T_CUSTOMROLE c on f.customroleid=c.id  where	1=1 and u.username='"+v_user+"'";
var rs=FR.remoteEvaluate('sql("finedb","'+sql+'",1)'); 

if(rs==""){
	alert("该用户不存在");
	return false;
}
this.options.form.getWidgetByName("treeEditor0").setValue(rs);
//设置文本框值
var p_user= this.options.form.getWidgetByName("p_user");  
p_user.setValue(rs);  
this.options.form.getWidgetByName("p_user_name").setValue(v_user);	

//查询user tab 权限
var sql21 = "select tab_id from HX_AUTHORITY where user_id='" + rs + "'";
var rs21 = FR.remoteEvaluate('sql("oracle_test","' + sql21 + '", 1)');
this.options.form.getWidgetByName("p_tab").setValue(rs21);
var reg=new RegExp(",","g");
var s = "'"+rs21.replace(reg,"','")+"'";
//alert(s);

var sql22 = " select ' [ ''' || substr(levelcode, 1, 2) || ''''|| ',' || '''' || father_id || '''' || ',' || '''' || levelcode || '''' || ']A' from (select * from (select distinct a.level1module levelmodule, a.level1code  levelcode, null father_id from DM_EXPORT_PRIVILEGE a  where classify = 'tab' union all select distinct a.level2module levelmodule, a.level2code   levelcode, a.level1code father_id  from DM_EXPORT_PRIVILEGE a  where classify = 'tab' union all  select distinct a.tab_code levelmodule,  a.codes      levelcode, a.level2code father_id from DM_EXPORT_PRIVILEGE a where classify = 'tab')) a where 1 = 1  and a.levelcode in (" + s + ") "
//alert(sql22);
var rs22 = FR.remoteEvaluate('sql("oracle_test","' + sql22 + '", 1)');
//alert(rs22);

var tab = FR.remoteEvaluate('eval("[" + JOINARRAY("' + rs22 + '", ",") + "]A")');
//alert(tab);
//alert(tab.length);
if(tab.length != 0) {
    this.options.form.getWidgetByName("treeEditor1").setValue(tab);
} else {
    this.options.form.getWidgetByName("treeEditor1").setValue("[]A");
}

/*------------------------------------------------------------------*/
//查询user export 权限
var sql31 = "select export_id from HX_AUTHORITY where user_id='" + rs + "'";
var rs31 = FR.remoteEvaluate('sql("oracle_test","' + sql31 + '", 1)');
this.options.form.getWidgetByName("p_export").setValue(rs31);

var reg31=new RegExp(",","g");
var s31 = "'"+rs31.replace(reg31,"','")+"'";
//alert(s31);

var sql32 = " select ' [ ''' || substr(levelcode, 1, 2) || ''''|| ','  || '''' || levelcode || '''' || ']A' from (select distinct a.level1module levelmodule,  a.level1code   levelcode, null  codes, null  father_id from DM_EXPORT_PRIVILEGE a where 1 = 1 and a.classify = 'export' union all select distinct a.level3module levelmodule, a.codes        levelcode, a.order_code   codes, a.level1code father_id from DM_EXPORT_PRIVILEGE a where 1 = 1 and a.classify = 'export') where 1=1 and levelcode in (" + s31 + ") ";
var rs32 = FR.remoteEvaluate('sql("oracle_test","' + sql32 + '", 1)');
//alert(rs32);
var export1 = FR.remoteEvaluate('eval("[" + JOINARRAY("' + rs32 + '", ",") + "]A")');
//alert(export1);
//alert(export1.length);
if(export1.length != 0) {
    this.options.form.getWidgetByName("treeEditor3").setValue(export1);
} else {
    this.options.form.getWidgetByName("treeEditor3").setValue("[]A");
}



}
]]></Content>
</JavaScript>
</Listener>
<WidgetName name="button1"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Text>
<![CDATA[搜索]]></Text>
</InnerWidget>
<BoundsAttr x="176" y="0" width="78" height="20"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WScaleLayout">
<WidgetName name="textEditor0"/>
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
<watermark>
<![CDATA[请输入用户名称拼音，如zhangsan]]></watermark>
<widgetValue>
<O>
<![CDATA[]]></O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="0" y="0" width="176" height="21"/>
</Widget>
</InnerWidget>
<BoundsAttr x="0" y="0" width="176" height="20"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TreeEditor">
<Listener event="click">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[//获取树节点
var v_user= this.options.form.getWidgetByName("treeEditor0").getValue();  
//设置文本框值
var p_user= this.options.form.getWidgetByName("p_user");  
p_user.setValue(v_user);  

//获取用户名
var sql1=" select realname from  FR_T_USER  u  where 1=1 and u.username='"+v_user+"' ";
var rs1=FR.remoteEvaluate('sql("finedb","'+sql1+'",1)'); 
var p_user_name= this.options.form.getWidgetByName("p_user_name");  
p_user_name.setValue(rs1);

//当点击用户时tab权限和导出权限置空
this.options.form.getWidgetByName("p_tab").setValue();
this.options.form.getWidgetByName("p_tab_name").setValue();

this.options.form.getWidgetByName("p_export").setValue();
this.options.form.getWidgetByName("p_export_name").setValue();

//查询user tab 权限
var sql21 = "select tab_id from HX_AUTHORITY where user_id='" + v_user + "'";
var rs21 = FR.remoteEvaluate('sql("oracle_test","' + sql21 + '", 1)');
this.options.form.getWidgetByName("p_tab").setValue(rs21);
var reg=new RegExp(",","g");
var s = "'"+rs21.replace(reg,"','")+"'";
//alert(s);

var sql22 = " select ' [ ''' || substr(levelcode, 1, 2) || ''''|| ',' || '''' || father_id || '''' || ',' || '''' || levelcode || '''' || ']A' from (select * from (select distinct a.level1module levelmodule, a.level1code  levelcode, null father_id from DM_EXPORT_PRIVILEGE a  where classify = 'tab' union all select distinct a.level2module levelmodule, a.level2code   levelcode, a.level1code father_id  from DM_EXPORT_PRIVILEGE a  where classify = 'tab' union all  select distinct a.tab_code levelmodule,  a.codes      levelcode, a.level2code father_id from DM_EXPORT_PRIVILEGE a where classify = 'tab')) a where 1 = 1  and a.levelcode in (" + s + ") "
//alert(sql22);
var rs22 = FR.remoteEvaluate('sql("oracle_test","' + sql22 + '", 1)');
//alert(rs22);

var tab = FR.remoteEvaluate('eval("[" + JOINARRAY("' + rs22 + '", ",") + "]A")');
//alert(tab);
//alert(tab.length);
if(tab.length != 0) {
    this.options.form.getWidgetByName("treeEditor1").setValue(tab);
} else {
    this.options.form.getWidgetByName("treeEditor1").setValue("[]A");
}

/*------------------------------------------------------------------*/
//查询user export 权限
var sql31 = "select export_id from HX_AUTHORITY where user_id='" + v_user + "'";
var rs31 = FR.remoteEvaluate('sql("oracle_test","' + sql31 + '", 1)');
this.options.form.getWidgetByName("p_export").setValue(rs31);

var reg31=new RegExp(",","g");
var s31 = "'"+rs31.replace(reg31,"','")+"'";
//alert(s31);

var sql32 = " select ' [ ''' || substr(levelcode, 1, 2) || ''''|| ','  || '''' || levelcode || '''' || ']A' from (select distinct a.level1module levelmodule,  a.level1code   levelcode, null  codes, null  father_id from DM_EXPORT_PRIVILEGE a where 1 = 1 and a.classify = 'export' union all select distinct a.level3module levelmodule, a.codes        levelcode, a.order_code   codes, a.level1code father_id from DM_EXPORT_PRIVILEGE a where 1 = 1 and a.classify = 'export') where 1=1 and levelcode in (" + s31 + ") ";
var rs32 = FR.remoteEvaluate('sql("oracle_test","' + sql32 + '", 1)');
//alert(rs32);
var export1 = FR.remoteEvaluate('eval("[" + JOINARRAY("' + rs32 + '", ",") + "]A")');
//alert(export1);
//alert(export1.length);
if(export1.length != 0) {
    this.options.form.getWidgetByName("treeEditor3").setValue(export1);
} else {
    this.options.form.getWidgetByName("treeEditor3").setValue("[]A");
}

window.parent.parent.FS.tabPane.addItem({title:"用户权限配置v2.0",src:"${servletURL}?formlet=cpt_test%2Fauthority%2FHX_EXPORT_AUT_v2.0_0827.frm&p_user="+v_user})
]]></Content>
</JavaScript>
</Listener>
<Listener event="afterinit">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[var v_user= this.options.form.getWidgetByName("treeEditor0").getValue();  

//获取用户名
var sql1=" select realname from  FR_T_USER  u  where 1=1 and u.username='"+v_user+"' ";
var rs1=FR.remoteEvaluate('sql("finedb","'+sql1+'",1)'); 
var p_user_name= this.options.form.getWidgetByName("p_user_name");  
p_user_name.setValue(rs1);

//当点击用户时tab权限和导出权限置空
this.options.form.getWidgetByName("p_tab").setValue();
this.options.form.getWidgetByName("p_tab_name").setValue();

this.options.form.getWidgetByName("p_export").setValue();
this.options.form.getWidgetByName("p_export_name").setValue();

//查询user tab 权限
var sql21 = "select tab_id from HX_AUTHORITY where user_id='" + v_user + "'";
var rs21 = FR.remoteEvaluate('sql("oracle_test","' + sql21 + '", 1)');
this.options.form.getWidgetByName("p_tab").setValue(rs21);
var reg=new RegExp(",","g");
var s = "'"+rs21.replace(reg,"','")+"'";
//alert(s);

var sql22 = " select ' [ ''' || substr(levelcode, 1, 2) || ''''|| ',' || '''' || father_id || '''' || ',' || '''' || levelcode || '''' || ']A' from (select * from (select distinct a.level1module levelmodule, a.level1code  levelcode, null father_id from DM_EXPORT_PRIVILEGE a  where classify = 'tab' union all select distinct a.level2module levelmodule, a.level2code   levelcode, a.level1code father_id  from DM_EXPORT_PRIVILEGE a  where classify = 'tab' union all  select distinct a.tab_code levelmodule,  a.codes      levelcode, a.level2code father_id from DM_EXPORT_PRIVILEGE a where classify = 'tab')) a where 1 = 1  and a.levelcode in (" + s + ") "
//alert(sql22);
var rs22 = FR.remoteEvaluate('sql("oracle_test","' + sql22 + '", 1)');
//alert(rs22);

var tab = FR.remoteEvaluate('eval("[" + JOINARRAY("' + rs22 + '", ",") + "]A")');
//alert(tab);
//alert(tab.length);
if(tab.length != 0) {
    this.options.form.getWidgetByName("treeEditor1").setValue(tab);
} else {
    this.options.form.getWidgetByName("treeEditor1").setValue("[]A");
}

/*------------------------------------------------------------------*/
//查询user export 权限
var sql31 = "select export_id from HX_AUTHORITY where user_id='" + v_user + "'";
var rs31 = FR.remoteEvaluate('sql("oracle_test","' + sql31 + '", 1)');
this.options.form.getWidgetByName("p_export").setValue(rs31);

var reg31=new RegExp(",","g");
var s31 = "'"+rs31.replace(reg31,"','")+"'";
//alert(s31);

var sql32 = " select ' [ ''' || substr(levelcode, 1, 2) || ''''|| ','  || '''' || levelcode || '''' || ']A' from (select distinct a.level1module levelmodule,  a.level1code   levelcode, null  codes, null  father_id from DM_EXPORT_PRIVILEGE a where 1 = 1 and a.classify = 'export' union all select distinct a.level3module levelmodule, a.codes        levelcode, a.order_code   codes, a.level1code father_id from DM_EXPORT_PRIVILEGE a where 1 = 1 and a.classify = 'export') where 1=1 and levelcode in (" + s31 + ") ";
var rs32 = FR.remoteEvaluate('sql("oracle_test","' + sql32 + '", 1)');
//alert(rs32);
var export1 = FR.remoteEvaluate('eval("[" + JOINARRAY("' + rs32 + '", ",") + "]A")');
//alert(export1);
//alert(export1.length);
if(export1.length != 0) {
    this.options.form.getWidgetByName("treeEditor3").setValue(export1);
} else {
    this.options.form.getWidgetByName("treeEditor3").setValue("[]A");
}]]></Content>
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
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$p_user]]></Attributes>
</O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="0" y="20" width="254" height="367"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="textEditor0"/>
<Widget widgetName="button1"/>
<Widget widgetName="treeEditor0"/>
</MobileWidgetList>
<WidgetZoomAttr compState="0"/>
<AppRelayout appRelayout="true"/>
<Size width="254" height="387"/>
<ResolutionScalingAttr percent="0.9"/>
<tabFitAttr index="0" tabNameIndex="0">
<initial>
<Background name="ColorBackground" color="-1512721"/>
</initial>
<click>
<Background name="ColorBackground" color="-4259840"/>
</click>
<isCustomStyle isCustomStyle="true"/>
</tabFitAttr>
</Widget>
<carouselAttr isCarousel="false" carouselInterval="1.8"/>
</Center>
</InnerWidget>
<BoundsAttr x="49" y="30" width="229" height="379"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="tablayout0"/>
<Widget widgetName="tablayout1"/>
<Widget widgetName="tablayout2"/>
<Widget widgetName="p_user"/>
<Widget widgetName="p_user_name"/>
<Widget widgetName="p_tab"/>
<Widget widgetName="p_tab_name"/>
<Widget widgetName="p_export"/>
<Widget widgetName="p_export_name"/>
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
<TemplateID TemplateID="3cc85ce7-b178-4f63-8022-f9d1e32f0006"/>
<TemplateIdAttMark class="com.fr.base.iofileattr.TemplateIdAttrMark">
<TemplateIdAttMark TemplateId="57a9ce13-1b3c-4240-8da9-5456aa6e2f3b"/>
</TemplateIdAttMark>
</Form>
