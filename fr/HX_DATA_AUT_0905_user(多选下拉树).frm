<?xml version="1.0" encoding="UTF-8"?>
<Form xmlVersion="20170720" releaseVersion="9.0.0">
<TableDataMap>
<TableData name="role" class="com.fr.data.impl.DBTableData">
<Parameters/>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[oracle_test]]></DatabaseName>
</Connection>
<Query>
<![CDATA[select distinct  rolename,id  from FR_T_CUSTOMROLE_V ]]></Query>
</TableData>
<TableData name="Tree1" class="com.fr.data.impl.RecursionTableData">
<markFields>
<![CDATA[0]]></markFields>
<markFieldsName>
<![CDATA[rolename]]></markFieldsName>
<originalTableDataName>
<![CDATA[role]]></originalTableDataName>
</TableData>
<TableData name="mk" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="p_type"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="p_role"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(len($p_source)=0,"",$p_role)]]></Attributes>
</O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[oracle_test]]></DatabaseName>
</Connection>
<Query>
<![CDATA[with asd as
 (
 select distinct id, rolename, fid, aname from (
 --父级
select distinct c.id, c.rolename, f.id fid, f.name aname
  from FR_T_CUSTOMROLE_V   c,
       FR_T_CUREP_V        d,
       FR_REPORTLETENTRY_V e,
       FR_FOLDERENTRY_V    f
 where 1 = 1
     -- and c.id = 7
   and c.id = d.roleid
   and d.view1<>0
   and d.entryid = e.id
   and e.parent = f.id
   and f.id in ('102', '103', '105', '106')
union all
select distinct c.id, c.rolename, f.id fid, f.name aname
  from FR_T_CUSTOMROLE_V   c,
       FR_T_CUREP_V        d,
       FR_REPORTLETENTRY_V e,
       FR_FOLDERENTRY_V    f
 where 1 = 1
     -- and c.id = 7
   and c.id = d.roleid
   and d.view1=1
   and d.entryid = e.parent
   and e.parent = f.id
   and f.id in ('102', '103', '105', '106')   
 union all  
--子级
select distinct c.id, c.rolename, e.id fid, e.name aname
  from FR_T_CUSTOMROLE_V   c,
       FR_T_CUREP_V        d,
       FR_REPORTLETENTRY_V e,
       FR_FOLDERENTRY_V    f
 where 1 = 1
    --  and c.id = 7
   and c.id = d.roleid
   and d.view1<>0
   and d.entryid = e.id
   and e.parent = f.id
   and f.id in ('102', '103', '105', '106')
union all
select distinct c.id, c.rolename, e.id fid, e.name aname
  from FR_T_CUSTOMROLE_V   c,
       FR_T_CUREP_V        d,
       FR_REPORTLETENTRY_V e,
       FR_FOLDERENTRY_V    f
 where 1 = 1
     -- and c.id = 7
   and c.id = d.roleid
   and d.view1=1
   and d.entryid = e.parent
   and e.parent = f.id
   and f.id in ('102', '103', '105', '106')
 ) 
  ),

b as
 (select *
    from (select id as id, parent as parent, name as name
            from FR_REPORTLETENTRY_V
           where parent in ('102', '103', '105', '106')
          union all
          select id as id, null as parent, name as name
            from FR_FOLDERENTRY_V
           where id in ('102', '103', '105', '106')
          
          ) t
   order by t.id),

c as
 (SELECT DISTINCT *
    FROM (select distinct a.aname, a.fid, u.username, u.realname
            from fr_t_user_v u, fr_t_customrole_user_v f, asd a
           where 1 = 1
             and u.id = f.Userid
             and f.CustomRoleid = a.id
             --and u.username = 'vchenqiong'
             
          union all
          select distinct b.name aname, b.id fid, u.username, u.realname
            from FR_T_USER_V         u,
                 FR_T_UEP_V          A,
                 FR_REPORTLETENTRY_V B,
                 FR_FOLDERENTRY_V    C
           where 1 = 1
             AND U.ID = A.userid
             AND A.entryid = B.id
             AND B.parent = C.id
             --and u.username = 'vchenqiong'
          union all
          select distinct c.name aname, c.id fid, u.username, u.realname
            from FR_T_USER_V         u,
                 FR_T_UEP_V          A,
                 FR_REPORTLETENTRY_V B,
                 FR_FOLDERENTRY_V    C
           where 1 = 1
             AND U.ID = A.userid
             AND A.entryid = B.id
             AND B.parent = C.id
             --and u.username = 'vchenqiong'
          
          ))
   
${if(p_type='user', " select b.* from c, b where 1=1 and c.fid=b.id and c.username='"+p_role+"' ", " select b.* from b, asd where b.id = asd.fid   and asd.id='"+p_role+"'") }
 order by b.id

]]></Query>
</TableData>
<TableData name="Tree2" class="com.fr.data.impl.RecursionTableData">
<markFields>
<![CDATA[0]]></markFields>
<parentmarkFields>
<![CDATA[1]]></parentmarkFields>
<markFieldsName>
<![CDATA[ID]]></markFieldsName>
<parentmarkFieldsName>
<![CDATA[PARENT]]></parentmarkFieldsName>
<originalTableDataName>
<![CDATA[mk]]></originalTableDataName>
</TableData>
<TableData name="org" class="com.fr.data.impl.DBTableData">
<Parameters/>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[oracle_test]]></DatabaseName>
</Connection>
<Query>
<![CDATA[select distinct * from dim_org order by order_key]]></Query>
</TableData>
<TableData name="Tree3" class="com.fr.data.impl.RecursionTableData">
<markFields>
<![CDATA[0]]></markFields>
<parentmarkFields>
<![CDATA[1]]></parentmarkFields>
<markFieldsName>
<![CDATA[ORG_ID]]></markFieldsName>
<parentmarkFieldsName>
<![CDATA[FATHER_ID]]></parentmarkFieldsName>
<originalTableDataName>
<![CDATA[org]]></originalTableDataName>
</TableData>
<TableData name="ds1" class="com.fr.data.impl.DBTableData">
<Parameters/>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[oracle_test]]></DatabaseName>
</Connection>
<Query>
<![CDATA[select reportid from dm_hx_data_aut ]]></Query>
</TableData>
<TableData name="dim_user" class="com.fr.data.impl.DBTableData">
<Parameters/>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[finedb]]></DatabaseName>
</Connection>
<Query>
<![CDATA[ select  distinct u.username username,u.realname||'('||u.username||')' as username1,u.realname
--,c.rolename 
 from FR_T_CUSTOMROLE_USER f
 left join  
  FR_T_USER  u  on  f.userid=u.id
  left join FR_T_CUSTOMROLE c
  on f.customroleid=c.id]]></Query>
</TableData>
<TableData name="Tree4" class="com.fr.data.impl.RecursionTableData">
<markFields>
<![CDATA[0]]></markFields>
<markFieldsName>
<![CDATA[USERNAME]]></markFieldsName>
<originalTableDataName>
<![CDATA[dim_user]]></originalTableDataName>
</TableData>
</TableDataMap>
<FormMobileAttr>
<FormMobileAttr refresh="false" isUseHTML="false" isMobileOnly="false" isAdaptivePropertyAutoMatch="false"/>
</FormMobileAttr>
<Parameters>
<Parameter>
<Attributes name="p_source"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="p_role"/>
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
<WidgetName name="v_tree1_id"/>
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
<BoundsAttr x="87" y="12" width="80" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TextEditor">
<WidgetName name="role_user"/>
<WidgetAttr invisible="true" description="">
<PrivilegeControl/>
</WidgetAttr>
<TextAttr/>
<Reg class="com.fr.form.ui.reg.NoneReg"/>
<widgetValue>
<O>
<![CDATA[1]]></O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="44" y="417" width="27" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TextEditor">
<WidgetName name="v_tree3_n"/>
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
<BoundsAttr x="625" y="12" width="107" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TextEditor">
<WidgetName name="v_tree2_n"/>
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
<BoundsAttr x="391" y="12" width="80" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TextEditor">
<WidgetName name="v_user"/>
<WidgetAttr invisible="true" description="">
<PrivilegeControl/>
</WidgetAttr>
<TextAttr/>
<Reg class="com.fr.form.ui.reg.NoneReg"/>
<widgetValue>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(len($p_source)=0,"",$p_role)]]></Attributes>
</O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="187" y="12" width="80" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.FreeButton">
<Listener event="click">
<JavaScript class="com.fr.js.Commit2DBJavaScript">
<Parameters/>
<Attributes dsName="oracle_test" name="提交1"/>
<DMLConfig class="com.fr.write.config.IntelliDMLConfig">
<Table schema="BASS_DW" name="DM_HX_DATA_AUT"/>
<ColumnConfig name="ROLENAME" isKey="true" skipUnmodified="false">
<O t="WidgetName" class="WidgetName">
<WidetName name="v_tree1_n"/>
</O>
</ColumnConfig>
<ColumnConfig name="ROLEID" isKey="true" skipUnmodified="false">
<O t="WidgetName" class="WidgetName">
<WidetName name="v_tree1_id"/>
</O>
</ColumnConfig>
<ColumnConfig name="USERNAME" isKey="false" skipUnmodified="false">
<O>
<![CDATA[]]></O>
</ColumnConfig>
<ColumnConfig name="USERID" isKey="false" skipUnmodified="false">
<O>
<![CDATA[]]></O>
</ColumnConfig>
<ColumnConfig name="DEPTNAME" isKey="false" skipUnmodified="false">
<O>
<![CDATA[]]></O>
</ColumnConfig>
<ColumnConfig name="DEPTID" isKey="false" skipUnmodified="false">
<O>
<![CDATA[]]></O>
</ColumnConfig>
<ColumnConfig name="MOKUAINAME" isKey="false" skipUnmodified="false">
<O>
<![CDATA[]]></O>
</ColumnConfig>
<ColumnConfig name="MOKUAIID" isKey="false" skipUnmodified="false">
<O>
<![CDATA[]]></O>
</ColumnConfig>
<ColumnConfig name="REPORTNAME" isKey="false" skipUnmodified="false">
<O t="WidgetName" class="WidgetName">
<WidetName name="v_tree2_n"/>
</O>
</ColumnConfig>
<ColumnConfig name="REPORTID" isKey="false" skipUnmodified="false">
<O t="WidgetName" class="WidgetName">
<WidetName name="v_tree2_id"/>
</O>
</ColumnConfig>
<ColumnConfig name="ORGNAME" isKey="false" skipUnmodified="false">
<O>
<![CDATA[]]></O>
</ColumnConfig>
<ColumnConfig name="ORGID" isKey="false" skipUnmodified="false">
<O t="WidgetName" class="WidgetName">
<WidetName name="v_tree3_id"/>
</O>
</ColumnConfig>
<ColumnConfig name="CREATER" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$fr_username]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="CREATETIME" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=now()]]></Attributes>
</O>
</ColumnConfig>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$p_role=0]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[len($v_tree1_n)<>0]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[len($v_tree2_n)<>0]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[len($v_tree3_n)<>0]]></Formula>
</Condition>
</JoinCondition>
</Condition>
</DMLConfig>
<Attributes dsName="oracle_test" name="提交2"/>
<DMLConfig class="com.fr.write.config.IntelliDMLConfig">
<Table schema="BASS_DW" name="DM_HX_DATA_AUT"/>
<ColumnConfig name="ROLENAME" isKey="false" skipUnmodified="false">
<O>
<![CDATA[]]></O>
</ColumnConfig>
<ColumnConfig name="ROLEID" isKey="false" skipUnmodified="false">
<O>
<![CDATA[]]></O>
</ColumnConfig>
<ColumnConfig name="USERNAME" isKey="false" skipUnmodified="false">
<O>
<![CDATA[]]></O>
</ColumnConfig>
<ColumnConfig name="USERID" isKey="true" skipUnmodified="false">
<O t="WidgetName" class="WidgetName">
<WidetName name="v_user"/>
</O>
</ColumnConfig>
<ColumnConfig name="DEPTNAME" isKey="false" skipUnmodified="false">
<O>
<![CDATA[]]></O>
</ColumnConfig>
<ColumnConfig name="DEPTID" isKey="false" skipUnmodified="false">
<O>
<![CDATA[]]></O>
</ColumnConfig>
<ColumnConfig name="MOKUAINAME" isKey="false" skipUnmodified="false">
<O>
<![CDATA[]]></O>
</ColumnConfig>
<ColumnConfig name="MOKUAIID" isKey="false" skipUnmodified="false">
<O>
<![CDATA[]]></O>
</ColumnConfig>
<ColumnConfig name="REPORTNAME" isKey="false" skipUnmodified="false">
<O t="WidgetName" class="WidgetName">
<WidetName name="v_tree2_n"/>
</O>
</ColumnConfig>
<ColumnConfig name="REPORTID" isKey="false" skipUnmodified="false">
<O t="WidgetName" class="WidgetName">
<WidetName name="v_tree2_id"/>
</O>
</ColumnConfig>
<ColumnConfig name="ORGNAME" isKey="false" skipUnmodified="false">
<O>
<![CDATA[]]></O>
</ColumnConfig>
<ColumnConfig name="ORGID" isKey="false" skipUnmodified="false">
<O t="WidgetName" class="WidgetName">
<WidetName name="v_tree3_id"/>
</O>
</ColumnConfig>
<ColumnConfig name="CREATER" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$fr_username]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="CREATETIME" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=now()]]></Attributes>
</O>
</ColumnConfig>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$role_user=1]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[len($v_user)<>0]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[len($v_tree2_id)<>0]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[len($v_tree3_id)<>0]]></Formula>
</Condition>
</JoinCondition>
</Condition>
</DMLConfig>
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[var mk = this.options.form.getWidgetByName("v_tree2_id").getValue();
var org = this.options.form.getWidgetByName("v_tree3_id").getValue();
var role = this.options.form.getWidgetByName("v_tree1_id").getValue();
var user = this.options.form.getWidgetByName("v_user").getValue();
//alert('mk--'+mk+'  org:'+org+'  role:'+role+'  user:'+user);

if((role != "" || user != "") && (mk != "" && org != "")) {
    if(fr_submitinfo.success) {
        FR.Msg.toast('填报成功');

    } else {
        FR.Msg.toast('填报失败');

    }


} else {

    FR.Msg.toast('填报失败,用户，模块，组织都不能为空，请检查后提交!');

}]]></Content>
</JavaScript>
</JavaScript>
</Listener>
<WidgetName name="button"/>
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
<FRFont name="微软雅黑" style="0" size="80" foreground="-1"/>
<isCustomType isCustomType="true"/>
</InnerWidget>
<BoundsAttr x="44" y="438" width="55" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TextEditor">
<WidgetName name="v_tree3_id"/>
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
<BoundsAttr x="505" y="12" width="114" height="21"/>
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
<FRFont name="SimSun" style="0" size="72"/>
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
<WidgetName name="14cb88b0-e566-43cb-9673-c60363ca2f35"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Text>
<![CDATA[组 织  ]]></Text>
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
<border style="1" color="-2171170" borderRadius="0" type="1" borderStyle="0"/>
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
<![CDATA[var val=this.getValue();
var self1 =this.options.form.getWidgetByName("v_tree3_id");   
self1.setValue(val);
]]></Content>
</JavaScript>
</Listener>
<WidgetName name="tree3"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<fontSize>
<![CDATA[20]]></fontSize>
<TreeAttr mutiSelect="true" selectLeafOnly="true"/>
<isLayerBuild isLayerBuild="false"/>
<isAutoBuild autoBuild="false"/>
<isPerformanceFirst performanceFirst="false"/>
<Dictionary class="com.fr.data.impl.TableDataDictionary">
<FormulaDictAttr kiName="ORG_CODE" viName="ORG_NAME"/>
<TableDataDictAttr>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[Tree3]]></Name>
</TableData>
</TableDataDictAttr>
</Dictionary>
<widgetValue>
<O>
<![CDATA[HXCYXCGN01]]></O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="0" y="0" width="222" height="400"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="tree3"/>
</MobileWidgetList>
<WidgetZoomAttr compState="0"/>
<AppRelayout appRelayout="true"/>
<Size width="222" height="400"/>
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
<BoundsAttr x="505" y="33" width="200" height="390"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TextEditor">
<WidgetName name="v_tree2_id"/>
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
<BoundsAttr x="271" y="12" width="110" height="21"/>
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
<FRFont name="SimSun" style="0" size="72"/>
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
<WidgetName name="92e1e401-4256-46f9-b9ec-f24786600c16"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Text>
<![CDATA[模 块 ]]></Text>
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
<border style="1" color="-2171170" borderRadius="0" type="1" borderStyle="0"/>
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
<![CDATA[var val=this.getValue();
//alert(val);
var self1 =this.options.form.getWidgetByName("v_tree2_id");   
self1.setValue(val);
//根据模块id 获取模块名称
var sql1="SELECT REPLACE('"+val+"',',',''',''')  as PARENT_NAME FROM  dual ";
var s=FR.remoteEvaluate("=joinarray(sql(\"oracle_test\",\""+sql1+"\",1,1)',')");

var sql41="select name from(select id as id,parent as parent,name as name from  FR_REPORTLETENTRY_V  where parent in ('102','103','105','106') union all select id as id,null as parent,name as name from  FR_FOLDERENTRY_V where id in ('102','103','105','106'))t  where id in ('" + s + "')"
var rs41 = FR.remoteEvaluate('sql("oracle_test", "'+sql41+'", 1)');
//给模块赋值

this.options.form.getWidgetByName("v_tree2_n").setValue(rs41);]]></Content>
</JavaScript>
</Listener>
<WidgetName name="tree2"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<fontSize>
<![CDATA[20]]></fontSize>
<TreeAttr mutiSelect="true" selectLeafOnly="true"/>
<isLayerBuild isLayerBuild="false"/>
<isAutoBuild autoBuild="false"/>
<isPerformanceFirst performanceFirst="false"/>
<Dictionary class="com.fr.data.impl.TableDataDictionary">
<FormulaDictAttr kiName="ID" viName="NAME"/>
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
<BoundsAttr x="0" y="0" width="222" height="393"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="tree2"/>
</MobileWidgetList>
<WidgetZoomAttr compState="0"/>
<AppRelayout appRelayout="true"/>
<Size width="222" height="393"/>
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
<BoundsAttr x="271" y="33" width="200" height="384"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TextEditor">
<WidgetName name="v_tree1_n"/>
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
<BoundsAttr x="7" y="12" width="80" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.cardlayout.WCardMainBorderLayout">
<Listener event="click">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[var aa = _g().getWidgetByName("tabpane0").getShowIndex();
 
if(aa==1){
var option =this.options.form.getWidgetByName("role_user"); 
option.setValue('1');	
	}
else if(aa==0){
var option =this.options.form.getWidgetByName("role_user"); 
option.setValue('0');
}
this.options.form.getWidgetByName("tree3").setValue("[]A");
this.options.form.getWidgetByName("tree2").setValue("[]A");]]></Content>
</JavaScript>
</Listener>
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
<FRFont name="SimSun" style="0" size="72"/>
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
<WidgetName name="49ff571b-15d7-4696-bab7-51f679859688"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Text>
<![CDATA[用 户 ]]></Text>
<initial>
<Background name="ColorBackground" color="-8355712"/>
</initial>
<click>
<Background name="ColorBackground" color="-4259840"/>
</click>
<FRFont name="SimSun" style="0" size="72"/>
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
<border style="1" color="-2171170" borderRadius="0" type="1" borderStyle="0"/>
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
<![CDATA[//获得数节点值
var val=this.getValue();

//获取role文本框并赋值(id name)
var v_tree1_n =this.options.form.getWidgetByName("v_tree1_n"); 
v_tree1_n.setValue(val);
var v_tree1_id =this.options.form.getWidgetByName("v_tree1_id"); 
var sqlr1="select id  from FR_T_CUSTOMROLE_V where rolename='"+val+"' ";
var r1 = FR.remoteEvaluate('sql("oracle_test","' + sqlr1 + '", 1)');
v_tree1_id.setValue(r1);

//当点击用户时tab权限和导出权限置空
//模块
this.options.form.getWidgetByName("v_tree2_id").setValue();
this.options.form.getWidgetByName("v_tree2_n").setValue();
//组织
this.options.form.getWidgetByName("v_tree3_id").setValue();
this.options.form.getWidgetByName("v_tree3_n").setValue();

//根据角色获取模块id
var sql21 = "select reportid from dm_hx_data_aut where rolename='" + val + "'";
var rs21 = FR.remoteEvaluate('sql("oracle_test","' + sql21 + '", 1)');
//alert("rs21====="+rs21);
var reg=new RegExp(",","g");
var s = "'"+rs21.replace(reg,"','")+"'";

var sql22 = "select '['''||parent||''''||','||''''||id||''''||']A' from (select * from(select id as id,parent as parent,name as name from  FR_REPORTLETENTRY_V  where parent in ('102','103','105','106') union all select id as id,null as parent,name as name from  FR_FOLDERENTRY_V where id in ('102','103','105','106'))t order by t.id) where id in (" + s + ")";

var rs22 = FR.remoteEvaluate('sql("oracle_test", "'+sql22+'", 1)');

var tab = FR.remoteEvaluate('eval("[" + JOINARRAY("' + rs22 + '", ",") + "]A")');

if(tab.length != 0) {
    this.options.form.getWidgetByName("tree2").setValue(tab);
} else {
    this.options.form.getWidgetByName("tree2").setValue("[]A");
}


var sql41="select name from(select id as id,parent as parent,name as name from  FR_REPORTLETENTRY_V  where parent in ('102','103','105','106') union all select id as id,null as parent,name as name from  FR_FOLDERENTRY_V where id in ('102','103','105','106'))t  where id in (" + s + ")"
var rs41 = FR.remoteEvaluate('sql("oracle_test", "'+sql41+'", 1)');
//给模块赋值
this.options.form.getWidgetByName("v_tree2_id").setValue(rs21);
this.options.form.getWidgetByName("v_tree2_n").setValue(rs41);

//----------------------组织------------------------
//根据角色获取组织code
var sql31="select orgid from dm_hx_data_aut where rolename='" + val + "'";
var rs31 = FR.remoteEvaluate('sql("oracle_test","' + sql31 + '", 1)');
//alert(rs31);


var reg=new RegExp(",","g");
var orgcode = "'"+rs31.replace(reg,"','")+"'";
//alert(orgcode);
var sql61=" select case when lev='lev1' then '[''' || org_code ||''''||']A'   when lev='lev2' then '[''' || father_id||''''||','||''''|| org_code ||''''||']A'  when lev='lev3' then '[''' || 'HX' || '''' || ',' || '''' || father_id||''''||','||''''|| org_code ||''''||']A'  when lev='lev4' then '[''' || 'HX' || '''' || ',' || '''' || substr(father_id, 1, length(father_id)-2) || '''' || ',' || '''' || father_id||''''||','||''''|| org_code ||''''||']A' when lev='lev5' then '[''' || 'HX' || '''' || ',' || '''' || substr(father_id, 1, length(father_id)-4) || '''' || ',' || '''' || substr(father_id, 1, length(father_id)-2) || '''' || ',' || '''' || father_id||''''||','||''''|| org_code ||''''||']A'  when lev='lev6' then '[''' || 'HX' || '''' || ',' || '''' || substr(father_id, 1, length(father_id)-4) || '''' || ',' || '''' || substr(father_id, 1, length(father_id)-2) || '''' || ',' || '''' || father_id||''''||','||''''|| org_code ||''''||']A'  end from ( select 'lev1' lev, o.org_id, null father_id, o.org_name,  o.org_code from dim_org o where length(o.org_code)=2  union all select 'lev2' lev, o.org_id, substr(o.org_code, 1, 2) father_id, o.org_name,  o.org_code from dim_org o where length(o.org_code) in (4, 6, 7) union all select 'lev3' lev, o.org_id, substr(o.org_code, 1, length(o.org_code)-2) father_id, o.org_name,  o.org_code from dim_org o where length(o.org_code) in (8, 9) union all select 'lev4' lev, o.org_id, case when o.org_code='HXCYXCGNTOD' then 'HXCYXCGN' else substr(o.org_code, 1, length(o.org_code)-2) end father_id, o.org_name,  o.org_code from dim_org o where length(o.org_code) in (10, 11) union all select 'lev5' lev, o.org_id, substr(o.org_code, 1, length(o.org_code)-2) father_id, o.org_name,  o.org_code from dim_org o where length(o.org_code) in (12) ) where 1=1 and org_code in ("+orgcode+")  ";

//给组织赋值
this.options.form.getWidgetByName("v_tree3_id").setValue(rs31);

var rs61 = FR.remoteEvaluate('sql("oracle_test", "'+sql61+'", 1)');
//alert(rs61);

var org61 = FR.remoteEvaluate('=eval("[" + JOINARRAY("' + rs61 + '", ",") + "]A")');

if(org61.length != 0) {
    this.options.form.getWidgetByName("tree3").setValue(org61);
} else {
    this.options.form.getWidgetByName("tree3").setValue("[]A");
}

]]></Content>
</JavaScript>
</Listener>
<WidgetName name="Tab1"/>
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
<![CDATA[//获得数节点值
var val=this.options.form.getWidgetByName("textEditor1").getValue();

//当点击用户时模块和组织权限置空
//模块
//this.options.form.getWidgetByName("v_tree2_id").setValue();
//this.options.form.getWidgetByName("v_tree2_n").setValue();
//组织
//this.options.form.getWidgetByName("v_tree3_id").setValue();
//this.options.form.getWidgetByName("v_tree3_n").setValue();

//给获取的值, 换成','
//var sql1="SELECT REPLACE('"+val+"',',',''',''')  as PARENT_NAME FROM  dual ";
//var userid=FR.remoteEvaluate("=joinarray(sql(\"oracle_test\",\""+sql1+"\",1,1),',')");

//根据用户获取模块id
//var sql21 = "select reportid from dm_hx_data_aut where userid in ('" + userid + "')";
//var rs21 = FR.remoteEvaluate('sql("oracle_test","' + sql21 + '", 1)');

//var reg="SELECT REPLACE('"+rs21+"',',',''',''')  as PARENT_NAME FROM  dual ";
//var s=FR.remoteEvaluate("=joinarray(sql(\"oracle_test\",\""+reg+"\",1,1),',')");

//var sql22 = "select '['''||parent||''''||','||''''||id||''''||']A' from (select * from(select id as id,parent as parent,name as name from  FR_REPORTLETENTRY_V  where parent in ('102','103','105','106') union all select id as id,null as parent,name as name from  FR_FOLDERENTRY_V where id in ('102','103','105','106'))t order by t.id) where id in (" + s + ")";

//var rs22 = FR.remoteEvaluate('sql("oracle_test", "'+sql22+'", 1)');

//var tab = FR.remoteEvaluate('eval("[" + JOINARRAY("' + rs22 + '", ",") + "]A")');

//if(tab.length != 0) {
//    this.options.form.getWidgetByName("tree2").setValue(tab);
//} else {
//    this.options.form.getWidgetByName("tree2").setValue("[]A");
//}

//var sql41="select name from(select id as id,parent as parent,name as name from  FR_REPORTLETENTRY_V  where parent in ('102','103','105','106') union all select id as id,null as parent,name as name from  FR_FOLDERENTRY_V where id in ('102','103','105','106'))t  where id in (" + s + ")"
//var rs41 = FR.remoteEvaluate('sql("oracle_test", "'+sql41+'", 1)');
//给模块赋值
//this.options.form.getWidgetByName("v_tree2_id").setValue(rs21);
//this.options.form.getWidgetByName("v_tree2_n").setValue(rs41);

//----------------------组织------------------------
//根据用户获取组织code
//var sql31="select orgid from dm_hx_data_aut where userid in ('" + userid + "')";
//var rs31 = FR.remoteEvaluate('sql("oracle_test","' + sql31 + '", 1)');

//var reg11="SELECT REPLACE('"+rs31+"',',',''',''')  as PARENT_NAME FROM  dual ";
//var orgcode=FR.remoteEvaluate("=joinarray(sql(\"oracle_test\",\""+reg11+"\",1,1),',')");

//var sql61=" select case when lev='lev1' then '[''' || org_code ||''''||']A'   when lev='lev2' then '[''' || father_id||''''||','||''''|| org_code ||''''||']A'  when lev='lev3' then '[''' || 'HX' || '''' || ',' || '''' || father_id||''''||','||''''|| org_code ||''''||']A'  when lev='lev4' then '[''' || 'HX' || '''' || ',' || '''' || substr(father_id, 1, length(father_id)-2) || '''' || ',' || '''' || father_id||''''||','||''''|| org_code ||''''||']A' when lev='lev5' then '[''' || 'HX' || '''' || ',' || '''' || substr(father_id, 1, length(father_id)-4) || '''' || ',' || '''' || substr(father_id, 1, length(father_id)-2) || '''' || ',' || '''' || father_id||''''||','||''''|| org_code ||''''||']A'  when lev='lev6' then '[''' || 'HX' || '''' || ',' || '''' || substr(father_id, 1, length(father_id)-4) || '''' || ',' || '''' || substr(father_id, 1, length(father_id)-2) || '''' || ',' || '''' || father_id||''''||','||''''|| org_code ||''''||']A'  end from ( select 'lev1' lev, o.org_id, null father_id, o.org_name,  o.org_code from dim_org o where length(o.org_code)=2  union all select 'lev2' lev, o.org_id, substr(o.org_code, 1, 2) father_id, o.org_name,  o.org_code from dim_org o where length(o.org_code) in (4, 6, 7) union all select 'lev3' lev, o.org_id, substr(o.org_code, 1, length(o.org_code)-2) father_id, o.org_name,  o.org_code from dim_org o where length(o.org_code) in (8, 9) union all select 'lev4' lev, o.org_id, case when o.org_code='HXCYXCGNTOD' then 'HXCYXCGN' else substr(o.org_code, 1, length(o.org_code)-2) end father_id, o.org_name,  o.org_code from dim_org o where length(o.org_code) in (10, 11) union all select 'lev5' lev, o.org_id, substr(o.org_code, 1, length(o.org_code)-2) father_id, o.org_name,  o.org_code from dim_org o where length(o.org_code) in (12) ) where 1=1 and org_code in ('"+orgcode+"')  ";

////给组织赋值
//this.options.form.getWidgetByName("v_tree3_id").setValue(rs31);

//var rs61 = FR.remoteEvaluate('sql("oracle_test", "'+sql61+'", 1)');


//var org61 = FR.remoteEvaluate('=eval("[" + JOINARRAY("' + rs61 + '", ",") + "]A")');

//if(org61.length != 0) {
//    this.options.form.getWidgetByName("tree3").setValue(org61);
//} else {
//    this.options.form.getWidgetByName("tree3").setValue("[]A");
//}


window.parent.FS.tabPane.addItem({title:"数据权限v2.0_user",src:"${servletURL}?formlet=cpt_test%2FHX_DATA_AUT_0905_user.frm&p_role="+val+"&p_type=user&p_source=form"}) 


]]></Content>
</JavaScript>
</Listener>
<Listener event="afterinit">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="val2"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(len($p_source)=0,"",$p_role)]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[//获得数节点值
this.options.form.getWidgetByName("textEditor1").setValue(val2);
var val=this.options.form.getWidgetByName("textEditor1").getValue();
this.options.form.getWidgetByName("user_tree").setValue(val2);

//当点击用户时模块和组织权限置空
//模块
this.options.form.getWidgetByName("v_tree2_id").setValue();
this.options.form.getWidgetByName("v_tree2_n").setValue();
//组织
this.options.form.getWidgetByName("v_tree3_id").setValue();
this.options.form.getWidgetByName("v_tree3_n").setValue();

//给获取的值, 换成','
var sql1="SELECT REPLACE('"+val+"',',',''',''')  as PARENT_NAME FROM  dual ";
var userid=FR.remoteEvaluate("=joinarray(sql(\"oracle_test\",\""+sql1+"\",1,1),',')");
//alert(userid);

//根据用户获取模块id
var sql21 = "select reportid from dm_hx_data_aut where userid in ('" + userid + "')";
var rs21 = FR.remoteEvaluate('sql("oracle_test","' + sql21 + '", 1)');

var reg="SELECT REPLACE('"+rs21+"',',',''',''')  as PARENT_NAME FROM  dual ";
var s=FR.remoteEvaluate("=joinarray(sql(\"oracle_test\",\""+reg+"\",1,1),',')");
//var reg=new RegExp(",","g");
//var s = "'"+rs21.replace(reg,"','")+"'";
////alert("s==============="+s);
var sql22 = "select '['''||parent||''''||','||''''||id||''''||']A' from (select * from(select id as id,parent as parent,name as name from  FR_REPORTLETENTRY_V  where parent in ('102','103','105','106') union all select id as id,null as parent,name as name from  FR_FOLDERENTRY_V where id in ('102','103','105','106'))t order by t.id) where id in (" + s + ")";

var rs22 = FR.remoteEvaluate('sql("oracle_test", "'+sql22+'", 1)');

var tab = FR.remoteEvaluate('eval("[" + JOINARRAY("' + rs22 + '", ",") + "]A")');

if(tab.length != 0) {
    this.options.form.getWidgetByName("tree2").setValue(tab);
} else {
    this.options.form.getWidgetByName("tree2").setValue("[]A");
}

var sql41="select name from(select id as id,parent as parent,name as name from  FR_REPORTLETENTRY_V  where parent in ('102','103','105','106') union all select id as id,null as parent,name as name from  FR_FOLDERENTRY_V where id in ('102','103','105','106'))t  where id in (" + s + ")"
var rs41 = FR.remoteEvaluate('sql("oracle_test", "'+sql41+'", 1)');
//给模块赋值
this.options.form.getWidgetByName("v_tree2_id").setValue(rs21);
this.options.form.getWidgetByName("v_tree2_n").setValue(rs41);

//----------------------组织------------------------
//根据用户获取组织code
var sql31="select orgid from dm_hx_data_aut where userid in ('" + userid + "')";
var rs31 = FR.remoteEvaluate('sql("oracle_test","' + sql31 + '", 1)');
//alert("1==="+rs31);
var reg11="SELECT REPLACE('"+rs31+"',',',''',''')  as PARENT_NAME FROM  dual ";
var orgcode=FR.remoteEvaluate("=joinarray(sql(\"oracle_test\",\""+reg11+"\",1,1),',')");
//var reg=new RegExp(",","g");
//var orgcode = "'"+rs31.replace(reg,"','")+"'";
//alert("2==="+orgcode);
var sql61=" select case when lev='lev1' then '[''' || org_code ||''''||']A'   when lev='lev2' then '[''' || father_id||''''||','||''''|| org_code ||''''||']A'  when lev='lev3' then '[''' || 'HX' || '''' || ',' || '''' || father_id||''''||','||''''|| org_code ||''''||']A'  when lev='lev4' then '[''' || 'HX' || '''' || ',' || '''' || substr(father_id, 1, length(father_id)-2) || '''' || ',' || '''' || father_id||''''||','||''''|| org_code ||''''||']A' when lev='lev5' then '[''' || 'HX' || '''' || ',' || '''' || substr(father_id, 1, length(father_id)-4) || '''' || ',' || '''' || substr(father_id, 1, length(father_id)-2) || '''' || ',' || '''' || father_id||''''||','||''''|| org_code ||''''||']A'  when lev='lev6' then '[''' || 'HX' || '''' || ',' || '''' || substr(father_id, 1, length(father_id)-4) || '''' || ',' || '''' || substr(father_id, 1, length(father_id)-2) || '''' || ',' || '''' || father_id||''''||','||''''|| org_code ||''''||']A'  end from ( select 'lev1' lev, o.org_id, null father_id, o.org_name,  o.org_code from dim_org o where length(o.org_code)=2  union all select 'lev2' lev, o.org_id, substr(o.org_code, 1, 2) father_id, o.org_name,  o.org_code from dim_org o where length(o.org_code) in (4, 6, 7) union all select 'lev3' lev, o.org_id, substr(o.org_code, 1, length(o.org_code)-2) father_id, o.org_name,  o.org_code from dim_org o where length(o.org_code) in (8, 9) union all select 'lev4' lev, o.org_id, case when o.org_code='HXCYXCGNTOD' then 'HXCYXCGN' else substr(o.org_code, 1, length(o.org_code)-2) end father_id, o.org_name,  o.org_code from dim_org o where length(o.org_code) in (10, 11) union all select 'lev5' lev, o.org_id, substr(o.org_code, 1, length(o.org_code)-2) father_id, o.org_name,  o.org_code from dim_org o where length(o.org_code) in (12) ) where 1=1 and org_code in ('"+orgcode+"')  ";

////给组织赋值
this.options.form.getWidgetByName("v_tree3_id").setValue(rs31);

var rs61 = FR.remoteEvaluate('sql("oracle_test", "'+sql61+'", 1)');
//alert(rs61);

var org61 = FR.remoteEvaluate('=eval("[" + JOINARRAY("' + rs61 + '", ",") + "]A")');
//alert("3==="+org61);
if(org61.length != 0) {
    this.options.form.getWidgetByName("tree3").setValue(org61);
} else {
    this.options.form.getWidgetByName("tree3").setValue("[]A");
}


//window.parent.FS.tabPane.addItem({title:"数据权限v2.0_user",src:"${servletURL}?formlet=cpt_test%2FHX_DATA_AUT_0905_user.frm&p_role="+val+"&p_type=user"}) 


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
<BoundsAttr x="154" y="0" width="68" height="25"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WScaleLayout">
<WidgetName name="textEditor1"/>
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
<WidgetName name="textEditor1"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<TextAttr/>
<Reg class="com.fr.form.ui.reg.NoneReg"/>
<widgetValue>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(len($p_source)=0,"",$p_role)]]></Attributes>
</O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="0" y="0" width="154" height="21"/>
</Widget>
</InnerWidget>
<BoundsAttr x="0" y="0" width="154" height="25"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TreeEditor">
<Listener event="click">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[//获得数节点值
var val=this.getValue();


//当点击用户时模块和组织权限置空
//模块
//this.options.form.getWidgetByName("v_tree2_id").setValue();
//this.options.form.getWidgetByName("v_tree2_n").setValue();
//组织
//this.options.form.getWidgetByName("v_tree3_id").setValue();
//this.options.form.getWidgetByName("v_tree3_n").setValue();

//给获取的值, 换成','
//var sql1="SELECT REPLACE('"+val+"',',',''',''')  as PARENT_NAME FROM  dual ";
//var userid=FR.remoteEvaluate("=joinarray(sql(\"oracle_test\",\""+sql1+"\",1,1),',')");


//根据用户获取模块id
//var sql21 = "select reportid from dm_hx_data_aut where userid in ('" + userid + "')";
//var rs21 = FR.remoteEvaluate('sql("oracle_test","' + sql21 + '", 1)');

//var reg="SELECT REPLACE('"+rs21+"',',',''',''')  as PARENT_NAME FROM  dual ";
//var s=FR.remoteEvaluate("=joinarray(sql(\"oracle_test\",\""+reg+"\",1,1),',')");

//var sql22 = "select '['''||parent||''''||','||''''||id||''''||']A' from (select * from(select id as id,parent as parent,name as name from  FR_REPORTLETENTRY_V  where parent in ('102','103','105','106') union all select id as id,null as parent,name as name from  FR_FOLDERENTRY_V where id in ('102','103','105','106'))t order by t.id) where id in ('" + s + "')";

//var rs22 = FR.remoteEvaluate('sql("oracle_test", "'+sql22+'", 1)');
//
//var tab = FR.remoteEvaluate('eval("[" + JOINARRAY("' + rs22 + '", ",") + "]A")');

//if(tab.length != 0) {
//    this.options.form.getWidgetByName("tree2").setValue(tab);
//} else {
//    this.options.form.getWidgetByName("tree2").setValue("[]A");
//}

//var sql41="select name from(select id as id,parent as parent,name as name from  FR_REPORTLETENTRY_V  where parent in ('102','103','105','106') union all select id as id,null as parent,name as name from  FR_FOLDERENTRY_V where id in ('102','103','105','106'))t  where id in ('" + s + "')"
//var rs41 = FR.remoteEvaluate('sql("oracle_test", "'+sql41+'", 1)');
//给模块赋值
//this.options.form.getWidgetByName("v_tree2_id").setValue(rs21);
//this.options.form.getWidgetByName("v_tree2_n").setValue(rs41);

//----------------------组织------------------------
//根据用户获取组织code
//var sql31="select orgid from dm_hx_data_aut where userid in ('" + userid + "')";
//var rs31 = FR.remoteEvaluate('sql("oracle_test","' + sql31 + '", 1)');

//var reg11="SELECT REPLACE('"+rs31+"',',',''',''')  as PARENT_NAME FROM  dual ";
//var orgcode=FR.remoteEvaluate("=joinarray(sql(\"oracle_test\",\""+reg11+"\",1,1),',')");

//var sql61=" select case when lev='lev1' then '[''' || org_code ||''''||']A'   when lev='lev2' then '[''' || father_id||''''||','||''''|| org_code ||''''||']A'  when lev='lev3' then '[''' || 'HX' || '''' || ',' || '''' || father_id||''''||','||''''|| org_code ||''''||']A'  when lev='lev4' then '[''' || 'HX' || '''' || ',' || '''' || substr(father_id, 1, length(father_id)-2) || '''' || ',' || '''' || father_id||''''||','||''''|| org_code ||''''||']A' when lev='lev5' then '[''' || 'HX' || '''' || ',' || '''' || substr(father_id, 1, length(father_id)-4) || '''' || ',' || '''' || substr(father_id, 1, length(father_id)-2) || '''' || ',' || '''' || father_id||''''||','||''''|| org_code ||''''||']A'  when lev='lev6' then '[''' || 'HX' || '''' || ',' || '''' || substr(father_id, 1, length(father_id)-4) || '''' || ',' || '''' || substr(father_id, 1, length(father_id)-2) || '''' || ',' || '''' || father_id||''''||','||''''|| org_code ||''''||']A'  end from ( select 'lev1' lev, o.org_id, null father_id, o.org_name,  o.org_code from dim_org o where length(o.org_code)=2  union all select 'lev2' lev, o.org_id, substr(o.org_code, 1, 2) father_id, o.org_name,  o.org_code from dim_org o where length(o.org_code) in (4, 6, 7) union all select 'lev3' lev, o.org_id, substr(o.org_code, 1, length(o.org_code)-2) father_id, o.org_name,  o.org_code from dim_org o where length(o.org_code) in (8, 9) union all select 'lev4' lev, o.org_id, case when o.org_code='HXCYXCGNTOD' then 'HXCYXCGN' else substr(o.org_code, 1, length(o.org_code)-2) end father_id, o.org_name,  o.org_code from dim_org o where length(o.org_code) in (10, 11) union all select 'lev5' lev, o.org_id, substr(o.org_code, 1, length(o.org_code)-2) father_id, o.org_name,  o.org_code from dim_org o where length(o.org_code) in (12) ) where 1=1 and org_code in ('"+orgcode+"')  ";

////给组织赋值
//this.options.form.getWidgetByName("v_tree3_id").setValue(rs31);

//var rs61 = FR.remoteEvaluate('sql("oracle_test", "'+sql61+'", 1)');

//var org61 = FR.remoteEvaluate('=eval("[" + JOINARRAY("' + rs61 + '", ",") + "]A")');

//if(org61.length != 0) {
//    this.options.form.getWidgetByName("tree3").setValue(org61);
//} else {
//    this.options.form.getWidgetByName("tree3").setValue("[]A");
//}


window.parent.FS.tabPane.addItem({title:"数据权限v2.0_user",src:"${servletURL}?formlet=cpt_test%2FHX_DATA_AUT_0905_user.frm&p_role="+val+"&p_type=user&p_source=form"}) 


]]></Content>
</JavaScript>
</Listener>
<Listener event="afterinit">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="val"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$p_role]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[//当点击用户时模块和组织权限置空
//模块
this.options.form.getWidgetByName("v_tree2_id").setValue();
this.options.form.getWidgetByName("v_tree2_n").setValue();
//组织
this.options.form.getWidgetByName("v_tree3_id").setValue();
this.options.form.getWidgetByName("v_tree3_n").setValue();


//给获取的值, 换成','
var sql1="SELECT REPLACE('"+val+"',',',''',''')  as PARENT_NAME FROM  dual ";
var userid=FR.remoteEvaluate("=joinarray(sql(\"oracle_test\",\""+sql1+"\",1,1),',')");
//alert(userid);

//根据用户获取模块id
var sql21 = "select reportid from dm_hx_data_aut where userid in ('" + userid + "')";
var rs21 = FR.remoteEvaluate('sql("oracle_test","' + sql21 + '", 1)');
if(rs21.length == 0){
	//alert('if--');
	var sql21=" select reportid from dm_hx_data_aut da where exists (select 1 from fr_t_user_v u, fr_t_customrole_user_v cu, fr_t_customrole_v c where u.id = cu.Userid  and cu.CustomRoleid = c.id and u.username = '"+userid+"' and c.id=da.roleid) ";
	var rs21 = FR.remoteEvaluate('sql("oracle_test","' + sql21 + '", 1)');			
}
//alert(rs21);

var reg="SELECT REPLACE('"+rs21+"',',',''',''')  as PARENT_NAME FROM  dual ";
var s=FR.remoteEvaluate("=joinarray(sql(\"oracle_test\",\""+reg+"\",1,1),',')");

////alert("s==============="+s);
var sql22 = "select '['''||parent||''''||','||''''||id||''''||']A' from (select * from(select id as id,parent as parent,name as name from  FR_REPORTLETENTRY_V  where parent in ('102','103','105','106') union all select id as id,null as parent,name as name from  FR_FOLDERENTRY_V where id in ('102','103','105','106'))t order by t.id) where id in ('" + s + "')";

var rs22 = FR.remoteEvaluate('sql("oracle_test", "'+sql22+'", 1)');
//alert(rs22);
var tab = FR.remoteEvaluate('eval("[" + JOINARRAY("' + rs22 + '", ",") + "]A")');
//alert(tab);

if(tab.length != 0) {
    this.options.form.getWidgetByName("tree2").setValue(tab);
} else {
    this.options.form.getWidgetByName("tree2").setValue("[]A");
}

//alert(s);
var sql41="select name from(select id as id,parent as parent,name as name from  FR_REPORTLETENTRY_V  where parent in ('102','103','105','106') union all select id as id,null as parent,name as name from  FR_FOLDERENTRY_V where id in ('102','103','105','106'))t  where id in ('" + s + "')"
var rs41 = FR.remoteEvaluate('sql("oracle_test", "'+sql41+'", 1)');
//给模块赋值

//alert(rs41);
this.options.form.getWidgetByName("v_tree2_id").setValue(rs21);
this.options.form.getWidgetByName("v_tree2_n").setValue(rs41);

//----------------------组织------------------------
//根据用户获取组织code
//先查询用户是否有设置组织
var sql31="select orgid from dm_hx_data_aut where userid in ('" + userid + "')";
var rs31 = FR.remoteEvaluate('sql("oracle_test","' + sql31 + '", 1)');
//alert("1==="+rs31);
//如果用户设置了组织，显示用户组织，否则显示用户对应的角色的组织
if(rs31.length != 0 ){
	this.options.form.getWidgetByName("v_tree3_id").setValue(rs31);
}else{
  var sql31="select orgid from dm_hx_data_aut da where exists (select 1  from fr_t_user_v u, fr_t_customrole_user_v cu, fr_t_customrole_v c where u.id = cu.Userid and cu.CustomRoleid = c.id and u.username = '"+userid+"' and c.id=da.roleid) ";
  var rs31 = FR.remoteEvaluate('sql("oracle_test","' + sql31 + '", 1)');
	
}
//alert(rs31);

var reg11="SELECT REPLACE('"+rs31+"',',',''',''')  as PARENT_NAME FROM  dual ";
var orgcode=FR.remoteEvaluate("=joinarray(sql(\"oracle_test\",\""+reg11+"\",1,1),',')");
//alert("2==="+orgcode);
var sql61=" select case when lev='lev1' then '[''' || org_code ||''''||']A'   when lev='lev2' then '[''' || father_id||''''||','||''''|| org_code ||''''||']A'  when lev='lev3' then '[''' || 'HX' || '''' || ',' || '''' || father_id||''''||','||''''|| org_code ||''''||']A'  when lev='lev4' then '[''' || 'HX' || '''' || ',' || '''' || substr(father_id, 1, length(father_id)-2) || '''' || ',' || '''' || father_id||''''||','||''''|| org_code ||''''||']A' when lev='lev5' then '[''' || 'HX' || '''' || ',' || '''' || substr(father_id, 1, length(father_id)-4) || '''' || ',' || '''' || substr(father_id, 1, length(father_id)-2) || '''' || ',' || '''' || father_id||''''||','||''''|| org_code ||''''||']A'  when lev='lev6' then '[''' || 'HX' || '''' || ',' || '''' || substr(father_id, 1, length(father_id)-4) || '''' || ',' || '''' || substr(father_id, 1, length(father_id)-2) || '''' || ',' || '''' || father_id||''''||','||''''|| org_code ||''''||']A'  end from ( select 'lev1' lev, o.org_id, null father_id, o.org_name,  o.org_code from dim_org o where length(o.org_code)=2  union all select 'lev2' lev, o.org_id, substr(o.org_code, 1, 2) father_id, o.org_name,  o.org_code from dim_org o where length(o.org_code) in (4, 6, 7) union all select 'lev3' lev, o.org_id, substr(o.org_code, 1, length(o.org_code)-2) father_id, o.org_name,  o.org_code from dim_org o where length(o.org_code) in (8, 9) union all select 'lev4' lev, o.org_id, case when o.org_code='HXCYXCGNTOD' then 'HXCYXCGN' else substr(o.org_code, 1, length(o.org_code)-2) end father_id, o.org_name,  o.org_code from dim_org o where length(o.org_code) in (10, 11) union all select 'lev5' lev, o.org_id, substr(o.org_code, 1, length(o.org_code)-2) father_id, o.org_name,  o.org_code from dim_org o where length(o.org_code) in (12) ) where 1=1 and org_code in ('"+orgcode+"')  ";

var rs61 = FR.remoteEvaluate('sql("oracle_test", "'+sql61+'", 1)');

var org61 = FR.remoteEvaluate('=eval("[" + JOINARRAY("' + rs61 + '", ",") + "]A")');
//alert("3==="+org61);
if(org61.length != 0) {
    this.options.form.getWidgetByName("tree3").setValue(org61);
} else {
    this.options.form.getWidgetByName("tree3").setValue("[]A");
}




]]></Content>
</JavaScript>
</Listener>
<WidgetName name="user_tree"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<TreeAttr selectLeafOnly="true"/>
<isLayerBuild isLayerBuild="false"/>
<isAutoBuild autoBuild="false"/>
<isPerformanceFirst performanceFirst="false"/>
<Dictionary class="com.fr.data.impl.TableDataDictionary">
<FormulaDictAttr kiName="USERNAME" viName="USERNAME1"/>
<TableDataDictAttr>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[Tree4]]></Name>
</TableData>
</TableDataDictAttr>
</Dictionary>
<widgetValue>
<O>
<![CDATA[]]></O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="0" y="25" width="222" height="368"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="textEditor1"/>
<Widget widgetName="button1"/>
<Widget widgetName="user_tree"/>
</MobileWidgetList>
<WidgetZoomAttr compState="0"/>
<AppRelayout appRelayout="true"/>
<Size width="222" height="393"/>
<ResolutionScalingAttr percent="0.9"/>
<tabFitAttr index="0" tabNameIndex="1">
<initial>
<Background name="ColorBackground" color="-8355712"/>
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
<BoundsAttr x="44" y="33" width="200" height="384"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="v_tree1_n"/>
<Widget widgetName="v_tree1_id"/>
<Widget widgetName="v_user"/>
<Widget widgetName="v_tree2_id"/>
<Widget widgetName="v_tree2_n"/>
<Widget widgetName="v_tree3_id"/>
<Widget widgetName="v_tree3_n"/>
<Widget widgetName="tablayout0"/>
<Widget widgetName="tablayout1"/>
<Widget widgetName="tablayout2"/>
<Widget widgetName="role_user"/>
<Widget widgetName="button"/>
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
<TemplateID TemplateID="c387ea34-08f6-40d9-9ea0-12f0c510afed"/>
<TemplateIdAttMark class="com.fr.base.iofileattr.TemplateIdAttrMark">
<TemplateIdAttMark TemplateId="d318b6f8-fbc0-4c5a-9bb7-d4753553b141"/>
</TemplateIdAttMark>
</Form>
