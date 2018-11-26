<?xml version="1.0" encoding="UTF-8"?>
<Form xmlVersion="20170720" releaseVersion="9.0.0">
<TableDataMap>
<TableData name="饼图" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="date"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=sql("oracle_test", "select to_char(to_date(max(data_date), 'YYYY-MM-DD'), 'YYYYMMDD') from dm_mcl_stock ", 1)]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="ch"/>
<O>
<![CDATA[新城集团]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[oracle_test]]></DatabaseName>
</Connection>
<Query>
<![CDATA[with mcl_stock as(
SELECT * FROM dm_mcl_stock WHERE data_date='${date}'
)
select * from (
select '新城集团' class1, type,actual
from  mcl_stock
where orgid='E0A3D386-D5C8-FB22-18DE-4424D49363B3' 
union all
select CLASS1,TYPE,round(SUM(ACTUAL),2) from (
select '环京' class1, t.type,t.actual
from 
(select * from dim_org where org_classify='环京' and org_type_id='产业新城（国内）' and  org_type='区域') t2 
inner join mcl_stock t 
on t.orgid=t2.org_id  ) T
group by class1,type
union all 
select CLASS1,TYPE,round(SUM(ACTUAL),2) from (
select '外埠' class1, t.type,t.actual
from 
(select * from dim_org where org_classify='外埠' and org_type_id='产业新城（国内）' and  org_type='区域') t2 
inner join mcl_stock t 
on t.orgid=t2.org_id  
UNION ALL
SELECT '外埠' as class1,TYPE,actual FROM mcl_stock WHERE  orgname='职能及其他'
) T
group by class1,type

) t
where class1='${ch}'
and type not in ('合计','开发成本（住宅）','完工开发产品（住宅）')


/*
select * from (
select '新城集团' class1, type,actual
from  dm_mcl_stock
where orgid='E0A3D386-D5C8-FB22-18DE-4424D49363B3' 
union all
select CLASS1,TYPE,SUM(ACTUAL) from (
select '环京' class1, t.type,t.actual
from 
(select * from dim_org where org_classify='环京' and org_type_id='产业新城（国内）' and  org_type='区域') t2 
inner join dm_mcl_stock t 
on t.orgid=t2.org_id  ) T
group by class1,type
union all 
select CLASS1,TYPE,SUM(ACTUAL) from (
select '外埠' class1, t.type,t.actual
from 
(select * from dim_org where org_classify='外埠' and org_type_id='产业新城（国内）' and  org_type='区域') t2 
inner join dm_mcl_stock t 
on t.orgid=t2.org_id  ) T
group by class1,type) t
where class1='${ch}'
and type not in ('合计','开发成本（住宅）','完工开发产品（住宅）')
order by actual desc
*/

]]></Query>
</TableData>
<TableData name="inventory" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="date"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=sql("oracle_test", "select to_char(to_date(max(data_date), 'YYYY-MM-DD'), 'YYYYMMDD') from dm_mcl_stock", 1)]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="ch"/>
<O>
<![CDATA[外埠]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[oracle_test]]></DatabaseName>
</Connection>
<Query>
<![CDATA[with mcl_stock as(
SELECT * FROM dm_mcl_stock WHERE data_date='${date}'
)

select * from (
select '新城集团' class1, type,actual
from  mcl_stock
where orgid='E0A3D386-D5C8-FB22-18DE-4424D49363B3' 
union all
select CLASS1,TYPE,round(SUM(ACTUAL),2) from (
select '环京' class1, t.type,t.actual
from 
(select * from dim_org where org_classify='环京' and org_type_id='产业新城（国内）' and  org_type='区域') t2 
inner join mcl_stock t 
on t.orgid=t2.org_id  ) T
group by class1,type
union all 
select CLASS1,TYPE,round(SUM(ACTUAL),2) from (
select '外埠' class1, t.type,t.actual
from 
(select * from dim_org where org_classify='外埠' and org_type_id='产业新城（国内）' and  org_type='区域') t2 
inner join mcl_stock t 
on t.orgid=t2.org_id  
UNION ALL
SELECT '外埠' as class1,TYPE,actual FROM mcl_stock WHERE  orgname='职能及其他'
) T
group by class1,type

) t
where class1='${ch}'

/*
select * from (
select '新城集团' class1, type,actual
from  dm_mcl_stock
where orgid='E0A3D386-D5C8-FB22-18DE-4424D49363B3' 
union all
select CLASS1,TYPE,SUM(ACTUAL) from (
select '环京' class1, t.type,t.actual
from 
(select * from dim_org where org_classify='环京' and org_type_id='产业新城（国内）' and  org_type='区域') t2 
inner join dm_mcl_stock t 
on t.orgid=t2.org_id  ) T
group by class1,type
union all 
select CLASS1,TYPE,SUM(ACTUAL) from (
select '外埠' class1, t.type,t.actual
from 
(select * from dim_org where org_classify='外埠' and org_type_id='产业新城（国内）' and  org_type='区域') t2 
inner join dm_mcl_stock t 
on t.orgid=t2.org_id  ) T
group by class1,type) t
where class1='外埠'
/*and type not in ('合计','开发成本（住宅）','完工开发产品（住宅）')*/
--order by actual desc
--*/]]></Query>
</TableData>
<TableData name="area" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="date"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=sql("oracle_test", "select to_char(to_date(max(data_date), 'YYYY-MM-DD'), 'YYYYMMDD') from dm_mcl_stock ", 1)]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="ch"/>
<O>
<![CDATA[环京]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[oracle_test]]></DatabaseName>
</Connection>
<Query>
<![CDATA[with mcl_stock as(
SELECT * FROM dm_mcl_stock WHERE data_date='${date}'
)

select org_classify, org_id, org_sname, round(actual, 1) actual   from (
select  t.*
  from (
        --新城集团
        select '新城集团' org_classify,
                b.org_id,
                b.org_sname,
                sum(nvl(actual, 0)) actual
          from mcl_stock a
         inner join dim_org b
            on a.orgid = b.org_id
         where typegroup <> '合计'
           and b.org_type = '区域'
           and '${ch}'='新城集团'
           
         group by b.org_id, b.org_sname
         --order by actual desc
        
        union all
        
        --环京外埠
        select b.org_classify type,
                b.org_id,
                b.org_sname,
                sum(nvl(actual, 0)) actual
          from mcl_stock a
         inner join dim_org b
            on a.orgid = b.org_id
         where typegroup <> '合计'
              and b.org_type = '区域'
           and b.org_classify in ('环京', '外埠')
           and b.org_type_id = '产业新城（国内）'
           and org_classify='${ch}'
         group by b.org_classify, b.org_id, b.org_sname
        -- order by actual desc
        
        ) t
 where 1=1
 order by actual desc
 ) t2
 where 1=1
 and  round(actual,1)<>0
 and rownum<=20]]></Query>
</TableData>
</TableDataMap>
<FormMobileAttr>
<FormMobileAttr refresh="false" isUseHTML="false" isMobileOnly="false" isAdaptivePropertyAutoMatch="false"/>
</FormMobileAttr>
<Parameters>
<Parameter>
<Attributes name="ch"/>
<O>
<![CDATA[新城集团]]></O>
</Parameter>
<Parameter>
<Attributes name="date"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=sql("oracle_test", "SELECT * FROM(select to_char(to_date(data_date, 'YYYY-MM-DD'), 'YYYYMMDD') from dm_mcl_stock ORDER BY DATA_DATE DESC ) where rownum=1", 1)]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="info"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="valuetype"/>
<O>
<![CDATA[实际]]></O>
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
<Listener event="click">
<JavaScript class="com.fr.js.Commit2DBJavaScript">
<Parameters/>
<Attributes dsName="oracle_test" name="提交1"/>
<DMLConfig class="com.fr.write.config.IntelliDMLConfig">
<Table schema="BASS_DW" name="JYGK_LOG_RECORD"/>
<ColumnConfig name="ID" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=UUID()]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="NAME_ID" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=value("loguser",4,1)]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="SYS_NAME" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$fr_username]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="NAME" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=value("loguser",3,1)]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="SUOSHUBUMEN" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=value("loguser",7,1)]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="ZHIWU" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=value("loguser",9,1)]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="BAOBIAOMOKUAI" isKey="false" skipUnmodified="false">
<O>
<![CDATA[经营管控]]></O>
</ColumnConfig>
<ColumnConfig name="FANGWENLUJING" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=formletName]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="FANGWENWENJIAN" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=RIGHT(formletName,INARRAY("/",REVERSEARRAY(SPLIT(formletName,"")))-1)]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="WENJIANMINGCHENG" isKey="false" skipUnmodified="false">
<O>
<![CDATA[财务类-存货（产新）]]></O>
</ColumnConfig>
<ColumnConfig name="CANSHUMING" isKey="false" skipUnmodified="false">
<O>
<![CDATA[ch]]></O>
</ColumnConfig>
<ColumnConfig name="CANSHU" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(len($ch)=0 ,"",$ch+";")]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="CANSHUMINGYUCANSHU" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(len($ch)=0,"","ch:"+$ch)+"; "]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="TIME" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=NOW()]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="DAOCHU" isKey="false" skipUnmodified="false">
<O>
<![CDATA[否]]></O>
</ColumnConfig>
<ColumnConfig name="SHIFOUDIANJILIANJIE" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(or(len($info)=0, $info = $info99 ), "否", "是" )]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="LIANJIECANSHUMING" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(or(len($info)=0, $info = $info99 ), "", "info" )]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="LIANJIECANSHU" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(len($info)=0,"",$info+";")]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="LIANJIEMINGYUCANSHU" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(len($info)=0,"", $info+":/ThreeLevelPage/OPE_FIN_INVENTORY_s.cpt")]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="DATA_DATE" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=TODAY()]]></Attributes>
</O>
</ColumnConfig>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[if( $ch = $ch99  , 1<0 , 0<1 )]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[if( $info = $info99  , 1<0 , 0<1 )]]></Formula>
</Condition>
</JoinCondition>
</Condition>
</DMLConfig>
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="ch"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$ch]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="info"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$info]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[this.options.form.getWidgetByName("ch99").setValue(ch);
this.options.form.getWidgetByName("info99").setValue(info);]]></Content>
</JavaScript>
</JavaScript>
</Listener>
<Listener event="afterinit">
<JavaScript class="com.fr.js.Commit2DBJavaScript">
<Parameters/>
<Attributes dsName="oracle_test" name="提交1"/>
<DMLConfig class="com.fr.write.config.IntelliDMLConfig">
<Table schema="BASS_DW" name="JYGK_LOG_RECORD"/>
<ColumnConfig name="ID" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=UUID()]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="NAME_ID" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=value("loguser",4,1)]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="SYS_NAME" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$fr_username]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="NAME" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=value("loguser",3,1)]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="SUOSHUBUMEN" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=value("loguser",7,1)]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="ZHIWU" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=value("loguser",9,1)]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="BAOBIAOMOKUAI" isKey="false" skipUnmodified="false">
<O>
<![CDATA[经营管控]]></O>
</ColumnConfig>
<ColumnConfig name="FANGWENLUJING" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=formletName]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="FANGWENWENJIAN" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=RIGHT(formletName,INARRAY("/",REVERSEARRAY(SPLIT(formletName,"")))-1)]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="WENJIANMINGCHENG" isKey="false" skipUnmodified="false">
<O>
<![CDATA[财务类-存货（产新）]]></O>
</ColumnConfig>
<ColumnConfig name="CANSHUMING" isKey="false" skipUnmodified="false">
<O>
<![CDATA[ch]]></O>
</ColumnConfig>
<ColumnConfig name="CANSHU" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(len($ch)=0 ,"",$ch+";")]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="CANSHUMINGYUCANSHU" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(len($ch)=0,"","ch:"+$ch)+"; "]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="TIME" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=NOW()]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="DAOCHU" isKey="false" skipUnmodified="false">
<O>
<![CDATA[否]]></O>
</ColumnConfig>
<ColumnConfig name="SHIFOUDIANJILIANJIE" isKey="false" skipUnmodified="false">
<O>
<![CDATA[否]]></O>
</ColumnConfig>
<ColumnConfig name="LIANJIECANSHUMING" isKey="false" skipUnmodified="false">
<O>
<![CDATA[]]></O>
</ColumnConfig>
<ColumnConfig name="LIANJIECANSHU" isKey="false" skipUnmodified="false">
<O>
<![CDATA[]]></O>
</ColumnConfig>
<ColumnConfig name="LIANJIEMINGYUCANSHU" isKey="false" skipUnmodified="false">
<O>
<![CDATA[]]></O>
</ColumnConfig>
<ColumnConfig name="DATA_DATE" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=TODAY()]]></Attributes>
</O>
</ColumnConfig>
<Condition class="com.fr.data.condition.ListCondition"/>
</DMLConfig>
</JavaScript>
</Listener>
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
<Background name="ColorBackground" color="-16378570"/>
<Alpha alpha="1.0"/>
</Border>
<Background name="ColorBackground" color="-16378570"/>
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
<WidgetName name="type99"/>
<WidgetAttr invisible="true" description="">
<PrivilegeControl/>
</WidgetAttr>
<TextAttr/>
<Reg class="com.fr.form.ui.reg.NoneReg"/>
<widgetValue>
<O>
<![CDATA[财务类-存货（产新）]]></O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="387" y="35" width="80" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TextEditor">
<WidgetName name="info99"/>
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
<BoundsAttr x="352" y="35" width="35" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TextEditor">
<WidgetName name="YW99_c"/>
<WidgetAttr invisible="true" description="">
<PrivilegeControl/>
</WidgetAttr>
<TextAttr/>
<Reg class="com.fr.form.ui.reg.NoneReg"/>
<widgetValue>
<O>
<![CDATA[产业新城（国内）]]></O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="318" y="35" width="34" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TextEditor">
<WidgetName name="ch99"/>
<WidgetAttr invisible="true" description="">
<PrivilegeControl/>
</WidgetAttr>
<TextAttr/>
<Reg class="com.fr.form.ui.reg.NoneReg"/>
<widgetValue>
<O>
<![CDATA[新城集团]]></O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="284" y="35" width="34" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TextEditor">
<WidgetName name="date99"/>
<WidgetAttr invisible="true" description="">
<PrivilegeControl/>
</WidgetAttr>
<TextAttr/>
<Reg class="com.fr.form.ui.reg.NoneReg"/>
<widgetValue>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=sql("oracle_test", "SELECT * FROM(select to_char(to_date(data_date, 'YYYY-MM-DD'), 'YYYYMMDD') from dm_mcl_stock ORDER BY DATA_DATE DESC ) where rownum=1", 1)]]></Attributes>
</O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="250" y="35" width="34" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report2_c"/>
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
<InnerWidget class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="report2_c"/>
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
<FormElementCase>
<ReportPageAttr>
<HR/>
<FR/>
<HC/>
<FC/>
</ReportPageAttr>
<ColumnPrivilegeControl/>
<RowPrivilegeControl/>
<RowHeight defaultValue="723900">
<![CDATA[648000,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[1008000,2880000,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O t="Image">
<IM>
<![CDATA[!D`a#reXHH7h#eD$31&+%7s)Y;?-[s%KHJ/&I8R@!!)E-SY#l^!>\6p5u`*!Q-m?>!b!(hnV
]AkhK5>LG8.#U<BFu4&R\K?K%iPgDEY0ZjTcp=q,/M7#TY[MB.0j'l<,cPb&7&Kk)rc0.n3&`
ATBBs6EVKFgo6GeUA[U;&4MqWuK/RP4dc.*Y#mrXKW8JV]A?;SmiUl$jbCLQE;3f%5!^r?Q7K
>H#u1HN,*3d(t`FMWD$TTdq1:K5eN%lrFj"oiVDF#WGiZ%NXm,M/R(UTF7Oon1)^CfcH<M,3
b`NWEbE12`@`*@!tJ?GRK1rntVEi!h_u?3_!In-cW-6$;<=;GsEgY'RpqXSRgWfYf8rAE"DN
Wc:`aWSfQ&\AQ!Na=:&Oe\B!>MA!Z"f>!NkNm[V*Hc&,PEY^ucz8OZBBY!QNJ~
]]></IM>
</O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="JavaScript脚本1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[window.parent.parent.FS.tabPane.addItem({title:"存货详情",src:"${servletURL}?reportlet=/ThreeLevelPage/OPE_FIN_INVENTORY_s.cpt&op=view"})]]></Content>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="当前决策报表对象2">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="info"/>
<O>
<![CDATA[存货（产新）详情]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report2_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<Expand/>
</C>
<C c="1" r="0" s="1">
<O>
<![CDATA[查看详情]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="JavaScript脚本1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[window.parent.parent.FS.tabPane.addItem({title:"存货(产新)详情",src:"${servletURL}?reportlet=/ThreeLevelPage/OPE_FIN_INVENTORY_s.cpt&op=view&is_show=Y"})]]></Content>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="当前决策报表对象2">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="info"/>
<O>
<![CDATA[存货（产新）详情]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report2_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<Expand/>
</C>
</CellElementList>
<ReportAttrSet>
<ReportSettings headerHeight="0" footerHeight="0">
<PaperSetting/>
</ReportSettings>
</ReportAttrSet>
</FormElementCase>
<StyleList>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72" foreground="-16776961" underline="1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="2" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72" foreground="-16735489"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="250" height="150"/>
</Widget>
<body class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="report2"/>
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
<FormElementCase>
<ReportPageAttr>
<HR/>
<FR/>
<HC/>
<FC/>
</ReportPageAttr>
<ColumnPrivilegeControl/>
<RowPrivilegeControl/>
<RowHeight defaultValue="723900">
<![CDATA[648000,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[1008000,5067300,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O t="Image">
<IM>
<![CDATA[!D`a#reXHH7h#eD$31&+%7s)Y;?-[s%KHJ/&I8R@!!)E-SY#l^!>\6p5u`*!Q-m?>!b!(hnV
]AkhK5>LG8.#U<BFu4&R\K?K%iPgDEY0ZjTcp=q,/M7#TY[MB.0j'l<,cPb&7&Kk)rc0.n3&`
ATBBs6EVKFgo6GeUA[U;&4MqWuK/RP4dc.*Y#mrXKW8JV]A?;SmiUl$jbCLQE;3f%5!^r?Q7K
>H#u1HN,*3d(t`FMWD$TTdq1:K5eN%lrFj"oiVDF#WGiZ%NXm,M/R(UTF7Oon1)^CfcH<M,3
b`NWEbE12`@`*@!tJ?GRK1rntVEi!h_u?3_!In-cW-6$;<=;GsEgY'RpqXSRgWfYf8rAE"DN
Wc:`aWSfQ&\AQ!Na=:&Oe\B!>MA!Z"f>!NkNm[V*Hc&,PEY^ucz8OZBBY!QNJ~
]]></IM>
</O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="JavaScript脚本1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[window.parent.FS.tabPane.addItem({title:"查看详情",src:"${servletURL}?reportlet=/ThreeLevelPage/OPE_FIN_CASH_FLOW_2.cpt&op=view"})]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<Expand/>
</C>
<C c="1" r="0" s="1">
<O>
<![CDATA[查看详情]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="JavaScript脚本2">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[window.parent.FS.tabPane.addItem({title:"查看详情",src:"${servletURL}?reportlet=/ThreeLevelPage/OPE_FIN_CASH_FLOW_2.cpt&op=view"})]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<Expand/>
</C>
</CellElementList>
<ReportAttrSet>
<ReportSettings headerHeight="0" footerHeight="0">
<PaperSetting/>
</ReportSettings>
</ReportAttrSet>
</FormElementCase>
<StyleList>
<Style imageLayout="4">
<FRFont name="SimSun" style="0" size="72" foreground="-16776961" underline="1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="2" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72" foreground="-16735489"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</body>
</InnerWidget>
<BoundsAttr x="784" y="30" width="61" height="26"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report6_c"/>
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
<InnerWidget class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="report6_c"/>
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
<FormElementCase>
<ReportPageAttr>
<HR/>
<FR/>
<HC/>
<FC/>
</ReportPageAttr>
<ColumnPrivilegeControl/>
<RowPrivilegeControl/>
<RowHeight defaultValue="723900">
<![CDATA[723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" cs="4" s="0">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="数据截止日期："+sql("oracle_test", "select to_char(to_date(max(data_date), 'YYYY-MM-DD'), 'YYYY-MM-DD') from dm_mcl_stock ", 1)]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
</CellElementList>
<ReportAttrSet>
<ReportSettings headerHeight="0" footerHeight="0">
<PaperSetting/>
</ReportSettings>
</ReportAttrSet>
</FormElementCase>
<StyleList>
<Style horizontal_alignment="4" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="250" height="150"/>
</Widget>
<body class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="report0"/>
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
<FormElementCase>
<ReportPageAttr>
<HR/>
<FR/>
<HC/>
<FC/>
</ReportPageAttr>
<ColumnPrivilegeControl/>
<RowPrivilegeControl/>
<RowHeight defaultValue="723900">
<![CDATA[723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" cs="4" s="0">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="数据截止日期："+FORMAT(now(),'yyyy-MM-dd')]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
</CellElementList>
<ReportAttrSet>
<ReportSettings headerHeight="0" footerHeight="0">
<PaperSetting/>
</ReportSettings>
</ReportAttrSet>
</FormElementCase>
<StyleList>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="80" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</body>
</InnerWidget>
<BoundsAttr x="650" y="4" width="200" height="24"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report1_c_c"/>
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
<InnerWidget class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="report1_c_c"/>
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
<FormElementCase>
<ReportPageAttr>
<HR/>
<FR/>
<HC/>
<FC/>
</ReportPageAttr>
<ColumnPrivilegeControl/>
<RowPrivilegeControl/>
<RowHeight defaultValue="723900">
<![CDATA[1440000,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[1440000,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O t="Image">
<IM>
<![CDATA[!O`&$rJ=?G7h#eD$31&+%7s)Y;?-[s*WQ0?*XDrM!!#)7Y+bmr!e!X.5u`*!`L"hB'i>g'?h
0AVdYECs5htIu:!i9G#ddSCf>rXu$UemZ._=#_/s@Ch'NtXJdNEKB]A'1OFFt;Aq8>,\T77k>
fq`4+bN[&bnR;p<e"*<q$F.PB6mlTuoe,o05&Y&lG_&R\1r[>F^Je?AK[QtI\$^^>g\-9Ts5
ktRiK,Nb[pheje#V)K)X1/snd_Su"9lL.jf^1R$W<EH%"@HQsqf!iRBuGA7\9@iU#/L4a&%H
JlY\b8*f.fbj?nO11O0o)anu-@(lcuFEFF\WWCFUrt%s2.t;VpJUn.PK#(,UXkB'/d)IG3VI
YLFl,jC[PN\@;uq#%)eE2iZHnG4,/2F5"k=_tlb;*MPpZJV52TcW@4=Z9#--EKd!NANa9iiZ
<s9Q*K,46Hmp(Y[j7_nrL+<co$l\]AjQ[k1?hRX+4>Vor%Y39Nb8nB*eM9Nifi)FKKif.;X`:
iQn3ee%Pb:2e*EO&oS)HW:(ic*i!Lio+C>\W;sc90PLr]A,&C1X>C:bqO[ABJ@l#=<>7E=@:k
i&Q('i#G#TLUsV`<muV5UmYi5=&Y2"O^jZ)412j\5R"]AP.h"<;Pm,g-^uQKgt':o3Q)0<R-a
/c;>K+Q`?/J^@]Ar5K.oFEPB-GVG;'BmroDdH.it<Z&4A$\f:$H_;bIuOn4C!rSiH*A;<@h@4
]Ah-S4,W>3JM9=R=8RL=\Q8$fHAf@#e'-#4i=<j5cSgU0!dm@:j;*dE_oi\Wq1l[ml'BY%&Z"
N'_.;r)#A3[-HldgKAYDT)/n-p=cZuo%:@91q3XQr7CqC/oV:33I`6L5eUPBr0fUF)B/!!!!
j78?7R6=>B~
]]></IM>
</O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="网络报表1">
<JavaScript class="com.fr.js.ReportletHyperlink">
<JavaScript class="com.fr.js.ReportletHyperlink">
<Parameters/>
<TargetFrame>
<![CDATA[_dialog]]></TargetFrame>
<Features width="800" height="600"/>
<ReportletName showPI="true">
<![CDATA[/HX_OPERATING_CONTROL/FINANCE/OPE_FIN_INCOME_DETAIL.cpt]]></ReportletName>
</JavaScript>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition"/>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
</CellElementList>
<ReportAttrSet>
<ReportSettings headerHeight="0" footerHeight="0">
<PaperSetting/>
</ReportSettings>
</ReportAttrSet>
</FormElementCase>
<StyleList>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72" foreground="-16776961" underline="1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="250" height="150"/>
</Widget>
<body class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="report1"/>
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
<FormElementCase>
<ReportPageAttr>
<HR/>
<FR/>
<HC/>
<FC/>
</ReportPageAttr>
<ColumnPrivilegeControl/>
<RowPrivilegeControl/>
<RowHeight defaultValue="723900">
<![CDATA[1440000,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[1440000,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<O t="Image">
<IM>
<![CDATA[!O`&$rJ=?G7h#eD$31&+%7s)Y;?-[s*WQ0?*XDrM!!#)7Y+bmr!e!X.5u`*!`L"hB'i>g'?h
0AVdYECs5htIu:!i9G#ddSCf>rXu$UemZ._=#_/s@Ch'NtXJdNEKB]A'1OFFt;Aq8>,\T77k>
fq`4+bN[&bnR;p<e"*<q$F.PB6mlTuoe,o05&Y&lG_&R\1r[>F^Je?AK[QtI\$^^>g\-9Ts5
ktRiK,Nb[pheje#V)K)X1/snd_Su"9lL.jf^1R$W<EH%"@HQsqf!iRBuGA7\9@iU#/L4a&%H
JlY\b8*f.fbj?nO11O0o)anu-@(lcuFEFF\WWCFUrt%s2.t;VpJUn.PK#(,UXkB'/d)IG3VI
YLFl,jC[PN\@;uq#%)eE2iZHnG4,/2F5"k=_tlb;*MPpZJV52TcW@4=Z9#--EKd!NANa9iiZ
<s9Q*K,46Hmp(Y[j7_nrL+<co$l\]AjQ[k1?hRX+4>Vor%Y39Nb8nB*eM9Nifi)FKKif.;X`:
iQn3ee%Pb:2e*EO&oS)HW:(ic*i!Lio+C>\W;sc90PLr]A,&C1X>C:bqO[ABJ@l#=<>7E=@:k
i&Q('i#G#TLUsV`<muV5UmYi5=&Y2"O^jZ)412j\5R"]AP.h"<;Pm,g-^uQKgt':o3Q)0<R-a
/c;>K+Q`?/J^@]Ar5K.oFEPB-GVG;'BmroDdH.it<Z&4A$\f:$H_;bIuOn4C!rSiH*A;<@h@4
]Ah-S4,W>3JM9=R=8RL=\Q8$fHAf@#e'-#4i=<j5cSgU0!dm@:j;*dE_oi\Wq1l[ml'BY%&Z"
N'_.;r)#A3[-HldgKAYDT)/n-p=cZuo%:@91q3XQr7CqC/oV:33I`6L5eUPBr0fUF)B/!!!!
j78?7R6=>B~
]]></IM>
</O>
<PrivilegeControl/>
<Expand/>
</C>
</CellElementList>
<ReportAttrSet>
<ReportSettings headerHeight="0" footerHeight="0">
<PaperSetting/>
</ReportSettings>
</ReportAttrSet>
</FormElementCase>
<StyleList/>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</body>
</InnerWidget>
<BoundsAttr x="820" y="260" width="30" height="30"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report7_c_c_c_c"/>
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
<InnerWidget class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="report7_c_c_c_c"/>
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
<FormElementCase>
<ReportPageAttr>
<HR/>
<FR/>
<HC/>
<FC/>
</ReportPageAttr>
<ColumnPrivilegeControl/>
<RowPrivilegeControl/>
<RowHeight defaultValue="723900">
<![CDATA[838200,838200,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[1872000,576000,5143500,1872000,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" cs="3" rs="2" s="0">
<O>
<![CDATA[存货区域分布]]></O>
<PrivilegeControl/>
<Expand/>
</C>
</CellElementList>
<ReportAttrSet>
<ReportSettings headerHeight="0" footerHeight="0">
<PaperSetting/>
</ReportSettings>
</ReportAttrSet>
</FormElementCase>
<StyleList>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="96" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="250" height="150"/>
</Widget>
<body class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="report7"/>
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
<FormElementCase>
<ReportPageAttr>
<HR/>
<FR/>
<HC/>
<FC/>
</ReportPageAttr>
<ColumnPrivilegeControl/>
<RowPrivilegeControl/>
<RowHeight defaultValue="723900">
<![CDATA[1440000,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[1333500,4000500,190500,1872000,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" cs="4" s="0">
<O>
<![CDATA[  签约完成情况]]></O>
<PrivilegeControl/>
<Expand/>
</C>
</CellElementList>
<ReportAttrSet>
<ReportSettings headerHeight="0" footerHeight="0">
<PaperSetting/>
</ReportSettings>
</ReportAttrSet>
</FormElementCase>
<StyleList>
<Style vertical_alignment="1" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="96" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</body>
</InnerWidget>
<BoundsAttr x="14" y="260" width="180" height="28"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report1"/>
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
<InnerWidget class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="report1"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="1" color="-15388336" borderRadius="0" type="0" borderStyle="0"/>
<WidgetTitle>
<O>
<![CDATA[新建标题]]></O>
<FRFont name="宋体" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Background name="ColorBackground" color="-16377030"/>
<Alpha alpha="1.0"/>
</Border>
<Background name="ColorBackground" color="-16377030"/>
<FormElementCase>
<ReportPageAttr>
<HR/>
<FR/>
<HC/>
<FC/>
</ReportPageAttr>
<ColumnPrivilegeControl/>
<RowPrivilegeControl/>
<RowHeight defaultValue="723900">
<![CDATA[723900,4343400,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[288000,11811000,432000,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1" cs="4">
<O t="CC">
<LayoutAttr selectedIndex="0"/>
<ChangeAttr enable="false" changeType="button" timeInterval="5" buttonColor="-8421505" carouselColor="-8421505" showArrow="true">
<TextAttr>
<Attr alignText="0"/>
</TextAttr>
</ChangeAttr>
<Chart name="默认" chartClass="com.fr.plugin.chart.vanchart.VanChart">
<Chart class="com.fr.plugin.chart.vanchart.VanChart">
<GI>
<AttrBackground>
<Background name="NullBackground"/>
<Attr shadow="false"/>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
<newColor borderColor="-1118482"/>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<ChartAttr isJSDraw="true" isStyleGlobal="false"/>
<Title4VanChart>
<Title>
<GI>
<AttrBackground>
<Background name="NullBackground"/>
<Attr shadow="false"/>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
<newColor borderColor="-6908266"/>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<O>
<![CDATA[新建图表标题]]></O>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="128" foreground="-13421773"/>
</Attr>
</TextAttr>
<TitleVisible value="false" position="0"/>
</Title>
<Attr4VanChart useHtml="false" floating="false" x="0.0" y="0.0" limitSize="false" maxHeight="15.0"/>
</Title4VanChart>
<Plot class="com.fr.plugin.chart.column.VanChartColumnPlot">
<VanChartPlotVersion version="20170715"/>
<GI>
<AttrBackground>
<Background name="NullBackground"/>
<Attr shadow="false"/>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
<newColor/>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<Attr isNullValueBreak="true" autoRefreshPerSecond="6" seriesDragEnable="false" plotStyle="4" combinedSize="50.0"/>
<newHotTooltipStyle>
<AttrContents>
<Attr showLine="false" position="1" isWhiteBackground="true" isShowMutiSeries="false" seriesLabel="${VALUE}"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#.##]]></Format>
<PercentFormat>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0.##%]]></Format>
</PercentFormat>
</AttrContents>
</newHotTooltipStyle>
<ConditionCollection>
<DefaultAttr class="com.fr.chart.chartglyph.ConditionAttr">
<ConditionAttr name="">
<AttrList>
<Attr class="com.fr.chart.base.AttrBorder">
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
<newColor borderColor="-1"/>
</AttrBorder>
</Attr>
<Attr class="com.fr.chart.base.AttrAlpha">
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</Attr>
<Attr class="com.fr.plugin.chart.base.VanChartAttrTrendLine">
<TrendLine>
<Attr trendLineName="" trendLineType="exponential" prePeriod="0" afterPeriod="0"/>
<LineStyleInfo>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
<AttrColor>
<Attr/>
</AttrColor>
<AttrLineStyle>
<newAttr lineStyle="0"/>
</AttrLineStyle>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
<newColor borderColor="-16777216"/>
</AttrBorder>
</LineStyleInfo>
</TrendLine>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrTooltip">
<AttrTooltip>
<Attr enable="false" duration="4" followMouse="false" showMutiSeries="false" isCustom="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="宋体" style="0" size="72"/>
</Attr>
</TextAttr>
<AttrToolTipContent>
<Attr isCommon="true"/>
<value class="com.fr.plugin.chart.base.format.AttrTooltipValueFormat">
<AttrTooltipValueFormat>
<Attr enable="true"/>
</AttrTooltipValueFormat>
</value>
<percent class="com.fr.plugin.chart.base.format.AttrTooltipPercentFormat">
<AttrTooltipPercentFormat>
<Attr enable="false"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#.##%]]></Format>
</AttrTooltipPercentFormat>
</percent>
<category class="com.fr.plugin.chart.base.format.AttrTooltipCategoryFormat">
<AttrToolTipCategoryFormat>
<Attr enable="true"/>
</AttrToolTipCategoryFormat>
</category>
<series class="com.fr.plugin.chart.base.format.AttrTooltipSeriesFormat">
<AttrTooltipSeriesFormat>
<Attr enable="true"/>
</AttrTooltipSeriesFormat>
</series>
<changedPercent class="com.fr.plugin.chart.base.format.AttrTooltipChangedPercentFormat">
<AttrTooltipChangedPercentFormat>
<Attr enable="false"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#.##%]]></Format>
</AttrTooltipChangedPercentFormat>
</changedPercent>
<changedValue class="com.fr.plugin.chart.base.format.AttrTooltipChangedValueFormat">
<AttrTooltipChangedValueFormat>
<Attr enable="false"/>
</AttrTooltipChangedValueFormat>
</changedValue>
<HtmlLabel customText="" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
</AttrToolTipContent>
<GI>
<AttrBackground>
<Background name="ColorBackground" color="-16777216"/>
<Attr shadow="true"/>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="2"/>
<newColor borderColor="-16777216"/>
</AttrBorder>
<AttrAlpha>
<Attr alpha="0.5"/>
</AttrAlpha>
</GI>
</AttrTooltip>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrLabel">
<AttrLabel>
<labelAttr enable="true"/>
<labelDetail class="com.fr.plugin.chart.base.AttrLabelDetail">
<Attr showLine="false" autoAdjust="false" position="6" isCustom="true"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="72" foreground="-1"/>
</Attr>
</TextAttr>
<AttrToolTipContent>
<Attr isCommon="true"/>
<value class="com.fr.plugin.chart.base.format.AttrTooltipValueFormat">
<AttrTooltipValueFormat>
<Attr enable="true"/>
</AttrTooltipValueFormat>
</value>
<percent class="com.fr.plugin.chart.base.format.AttrTooltipPercentFormat">
<AttrTooltipPercentFormat>
<Attr enable="false"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#.##%]]></Format>
</AttrTooltipPercentFormat>
</percent>
<category class="com.fr.plugin.chart.base.format.AttrTooltipCategoryFormat">
<AttrToolTipCategoryFormat>
<Attr enable="false"/>
</AttrToolTipCategoryFormat>
</category>
<series class="com.fr.plugin.chart.base.format.AttrTooltipSeriesFormat">
<AttrTooltipSeriesFormat>
<Attr enable="false"/>
</AttrTooltipSeriesFormat>
</series>
<changedPercent class="com.fr.plugin.chart.base.format.AttrTooltipChangedPercentFormat">
<AttrTooltipChangedPercentFormat>
<Attr enable="false"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#.##%]]></Format>
</AttrTooltipChangedPercentFormat>
</changedPercent>
<changedValue class="com.fr.plugin.chart.base.format.AttrTooltipChangedValueFormat">
<AttrTooltipChangedValueFormat>
<Attr enable="false"/>
</AttrTooltipChangedValueFormat>
</changedValue>
<HtmlLabel customText="function(){ return this.value;}" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
</AttrToolTipContent>
</labelDetail>
</AttrLabel>
</Attr>
</AttrList>
</ConditionAttr>
</DefaultAttr>
</ConditionCollection>
<Legend4VanChart>
<Legend>
<GI>
<AttrBackground>
<Background name="NullBackground"/>
<Attr shadow="false"/>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
<newColor borderColor="-3355444"/>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<Attr position="4" visible="false"/>
<FRFont name="微软雅黑" style="0" size="88" foreground="-10066330"/>
</Legend>
<Attr4VanChart floating="false" x="0.0" y="0.0" limitSize="false" maxHeight="15.0" isHighlight="true"/>
</Legend4VanChart>
<DataSheet>
<GI>
<AttrBackground>
<Background name="NullBackground"/>
<Attr shadow="false"/>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="1" isRoundBorder="false" roundRadius="0"/>
<newColor borderColor="-16777216"/>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<Attr isVisible="false"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#.##]]></Format>
</DataSheet>
<DataProcessor class="com.fr.base.chart.chartdata.model.NormalDataModel"/>
<newPlotFillStyle>
<AttrFillStyle>
<AFStyle colorStyle="1"/>
<FillStyleName fillStyleName="目标实际完成率"/>
<isCustomFillStyle isCustomFillStyle="false"/>
<ColorList>
<OColor colvalue="-12475905"/>
<OColor colvalue="-16713985"/>
<OColor colvalue="-16720253"/>
<OColor colvalue="-16750485"/>
<OColor colvalue="-3658447"/>
<OColor colvalue="-10331231"/>
<OColor colvalue="-7763575"/>
<OColor colvalue="-6514688"/>
<OColor colvalue="-16744620"/>
<OColor colvalue="-6187579"/>
<OColor colvalue="-15714713"/>
<OColor colvalue="-945550"/>
<OColor colvalue="-4092928"/>
<OColor colvalue="-13224394"/>
<OColor colvalue="-12423245"/>
<OColor colvalue="-10043521"/>
<OColor colvalue="-406154"/>
<OColor colvalue="-13031292"/>
<OColor colvalue="-16732559"/>
<OColor colvalue="-7099690"/>
<OColor colvalue="-11991199"/>
<OColor colvalue="-331445"/>
<OColor colvalue="-6991099"/>
<OColor colvalue="-16686527"/>
<OColor colvalue="-9205567"/>
<OColor colvalue="-7397856"/>
<OColor colvalue="-406154"/>
<OColor colvalue="-2712831"/>
<OColor colvalue="-4737097"/>
<OColor colvalue="-11460720"/>
<OColor colvalue="-6696775"/>
<OColor colvalue="-3685632"/>
</ColorList>
</AttrFillStyle>
</newPlotFillStyle>
<VanChartPlotAttr isAxisRotation="false" categoryNum="1"/>
<VanChartRectanglePlotAttr vanChartPlotType="normal" isDefaultIntervalBackground="true"/>
<XAxisList>
<VanChartAxis class="com.fr.plugin.chart.attr.axis.VanChartAxis">
<Title>
<GI>
<AttrBackground>
<Background name="NullBackground"/>
<Attr shadow="false"/>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
<newColor borderColor="-16777216"/>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<O>
<![CDATA[]]></O>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="2"/>
</Title>
<newAxisAttr isShowAxisLabel="true"/>
<AxisLineStyle AxisStyle="0" MainGridStyle="1"/>
<newLineColor lineColor=""/>
<AxisPosition value="3"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr rotation="-45" alignText="0">
<FRFont name="微软雅黑" style="0" size="72" foreground="-1"/>
</Attr>
</TextAttr>
<AxisLabelCount value="=1"/>
<AxisRange/>
<AxisUnit201106 isCustomMainUnit="false" isCustomSecUnit="false" mainUnit="=0" secUnit="=0"/>
<ZoomAxisAttr isZoom="false"/>
<axisReversed axisReversed="false"/>
<VanChartAxisAttr mainTickLine="2" secTickLine="0" axisName="X轴" titleUseHtml="false" autoLabelGap="true" limitSize="false" maxHeight="15.0" commonValueFormat="true" isRotation="false"/>
<HtmlLabel customText="function(){ return this; }" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
<alertList/>
<customBackgroundList/>
</VanChartAxis>
</XAxisList>
<YAxisList>
<VanChartAxis class="com.fr.plugin.chart.attr.axis.VanChartValueAxis">
<Title>
<GI>
<AttrBackground>
<Background name="NullBackground"/>
<Attr shadow="false"/>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
<newColor borderColor="-16777216"/>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<O>
<![CDATA[]]></O>
<TextAttr>
<Attr rotation="-90" alignText="0">
<FRFont name="Verdana" style="0" size="88" foreground="-10066330"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="false"/>
<AxisLineStyle AxisStyle="0" MainGridStyle="1"/>
<newLineColor lineColor="-5197648"/>
<AxisPosition value="2"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
</Attr>
</TextAttr>
<AxisLabelCount value="=1"/>
<AxisRange maxValue="=if(len(max(area.group(actual)))=0, 0, max(area.group(actual))*1.2 )"/>
<AxisUnit201106 isCustomMainUnit="false" isCustomSecUnit="false" mainUnit="=0" secUnit="=0"/>
<ZoomAxisAttr isZoom="false"/>
<axisReversed axisReversed="false"/>
<VanChartAxisAttr mainTickLine="0" secTickLine="0" axisName="Y轴" titleUseHtml="false" autoLabelGap="true" limitSize="false" maxHeight="15.0" commonValueFormat="true" isRotation="false"/>
<HtmlLabel customText="function(){ return this; }" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
<alertList/>
<customBackgroundList/>
<VanChartValueAxisAttr isLog="false" valueStyle="false" baseLog="=10"/>
<ds>
<RadarYAxisTableDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<attr/>
</RadarYAxisTableDefinition>
</ds>
</VanChartAxis>
</YAxisList>
<stackAndAxisCondition>
<ConditionCollection>
<DefaultAttr class="com.fr.chart.chartglyph.ConditionAttr">
<ConditionAttr name=""/>
</DefaultAttr>
</ConditionCollection>
</stackAndAxisCondition>
<VanChartColumnPlotAttr seriesOverlapPercent="20.0" categoryIntervalPercent="20.0" fixedWidth="false" columnWidth="0" filledWithImage="false" isBar="false"/>
</Plot>
<ChartDefinition>
<MoreNameCDDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[area]]></Name>
</TableData>
<CategoryName value="ORG_SNAME"/>
<ChartSummaryColumn name="ACTUAL" function="com.fr.data.util.function.NoneFunction" customName="实际值"/>
</MoreNameCDDefinition>
</ChartDefinition>
</Chart>
<tools hidden="true" sort="false" export="false" fullScreen="false"/>
<VanChartZoom>
<zoomAttr zoomVisible="false" zoomGesture="true" zoomResize="true" zoomType="none"/>
<from>
<![CDATA[]]></from>
<to>
<![CDATA[]]></to>
</VanChartZoom>
<refreshMoreLabel>
<attr moreLabel="false" autoTooltip="true"/>
<AttrTooltip>
<Attr enable="true" duration="4" followMouse="false" showMutiSeries="false" isCustom="false"/>
<TextAttr>
<Attr alignText="0"/>
</TextAttr>
<AttrToolTipContent>
<Attr isCommon="true"/>
<value class="com.fr.plugin.chart.base.format.AttrTooltipValueFormat">
<AttrTooltipValueFormat>
<Attr enable="true"/>
</AttrTooltipValueFormat>
</value>
<percent class="com.fr.plugin.chart.base.format.AttrTooltipPercentFormat">
<AttrTooltipPercentFormat>
<Attr enable="false"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#.##%]]></Format>
</AttrTooltipPercentFormat>
</percent>
<category class="com.fr.plugin.chart.base.format.AttrTooltipCategoryFormat">
<AttrToolTipCategoryFormat>
<Attr enable="true"/>
</AttrToolTipCategoryFormat>
</category>
<series class="com.fr.plugin.chart.base.format.AttrTooltipSeriesFormat">
<AttrTooltipSeriesFormat>
<Attr enable="true"/>
</AttrTooltipSeriesFormat>
</series>
<changedPercent class="com.fr.plugin.chart.base.format.AttrTooltipChangedPercentFormat">
<AttrTooltipChangedPercentFormat>
<Attr enable="false"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#.##%]]></Format>
</AttrTooltipChangedPercentFormat>
</changedPercent>
<changedValue class="com.fr.plugin.chart.base.format.AttrTooltipChangedValueFormat">
<AttrTooltipChangedValueFormat>
<Attr enable="true"/>
</AttrTooltipChangedValueFormat>
</changedValue>
<HtmlLabel customText="" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
</AttrToolTipContent>
<GI>
<AttrBackground>
<Background name="ColorBackground" color="-1"/>
<Attr shadow="false"/>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="1" isRoundBorder="false" roundRadius="4"/>
<newColor borderColor="-15395563"/>
</AttrBorder>
<AttrAlpha>
<Attr alpha="0.8"/>
</AttrAlpha>
</GI>
</AttrTooltip>
</refreshMoreLabel>
</Chart>
</O>
<PrivilegeControl/>
<Expand/>
</C>
</CellElementList>
<ReportAttrSet>
<ReportSettings headerHeight="0" footerHeight="0">
<PaperSetting/>
</ReportSettings>
</ReportAttrSet>
</FormElementCase>
<StyleList/>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="250" height="150"/>
</Widget>
<body class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="report1"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="0" color="-723724" borderRadius="0" type="0" borderStyle="0"/>
<WidgetTitle>
<O>
<![CDATA[新建标题]]></O>
<FRFont name="宋体" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320@UNRS@pi\LbJ=As=mA4GMLe&Yg=+"qUghX(gDb4%*!I<7qJ*Aq-t
s[^^!J4AF5Mik3]A`FoP$]AP?lY_U[&165&p3=:;j'CuFX^^Z7)8KY5c%V.'afcMh5Q8b5&P8@
%CH%g1;$=a_@%JbR@4?/sL+jGa,?Q)tN^Ht]AL4_`.e@_Xf>S)WT9.5J@TWj.W_IB3m;)U"-D
]A;_-65>`cdaYR"UIL4]A2/:X>;56U?)Du9ZW)9<ZN>aZhe>Q6>L8%NUjhd%Er\[&b*^<s@CkZ
R;+.OC1CV.1O9Uu6<pRseFY!("J&'j(^?DG!#)etnXDZ&9S*KDJ+h]AIBYT!!Mpl^STV!!~
]]></IM>
</Background>
<Alpha alpha="1.0"/>
</Border>
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320@UNRS@pi\LbJ=As=mA4GMLe&Yg=+"qUghX(gDb4%*!I<7qJ*Aq-t
s[^^!J4AF5Mik3]A`FoP$]AP?lY_U[&165&p3=:;j'CuFX^^Z7)8KY5c%V.'afcMh5Q8b5&P8@
%CH%g1;$=a_@%JbR@4?/sL+jGa,?Q)tN^Ht]AL4_`.e@_Xf>S)WT9.5J@TWj.W_IB3m;)U"-D
]A;_-65>`cdaYR"UIL4]A2/:X>;56U?)Du9ZW)9<ZN>aZhe>Q6>L8%NUjhd%Er\[&b*^<s@CkZ
R;+.OC1CV.1O9Uu6<pRseFY!("J&'j(^?DG!#)etnXDZ&9S*KDJ+h]AIBYT!!Mpl^STV!!~
]]></IM>
</Background>
<FormElementCase>
<ReportPageAttr>
<HR/>
<FR/>
<HC/>
<FC/>
</ReportPageAttr>
<ColumnPrivilegeControl/>
<RowPrivilegeControl/>
<RowHeight defaultValue="723900">
<![CDATA[723900,4343400,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[288000,11811000,432000,1295400,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="0">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition"/>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="1" r="1">
<O t="CC">
<LayoutAttr selectedIndex="0"/>
<ChangeAttr enable="false" changeType="button" timeInterval="5" buttonColor="-8421505" carouselColor="-8421505" showArrow="true">
<TextAttr>
<Attr alignText="0"/>
</TextAttr>
</ChangeAttr>
<Chart name="默认" chartClass="com.fr.plugin.chart.vanchart.VanChart">
<Chart class="com.fr.plugin.chart.vanchart.VanChart">
<GI>
<AttrBackground>
<Background name="NullBackground"/>
<Attr shadow="false"/>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
<newColor borderColor="-1118482"/>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<ChartAttr isJSDraw="true" isStyleGlobal="false"/>
<Title4VanChart>
<Title>
<GI>
<AttrBackground>
<Background name="NullBackground"/>
<Attr shadow="false"/>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
<newColor borderColor="-6908266"/>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<O>
<![CDATA[新建图表标题]]></O>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="128" foreground="-13421773"/>
</Attr>
</TextAttr>
<TitleVisible value="false" position="0"/>
</Title>
<Attr4VanChart useHtml="false" floating="false" x="0.0" y="0.0" limitSize="false" maxHeight="15.0"/>
</Title4VanChart>
<Plot class="com.fr.plugin.chart.custom.VanChartCustomPlot">
<VanChartPlotVersion version="20170715"/>
<GI>
<AttrBackground>
<Background name="NullBackground"/>
<Attr shadow="false"/>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
<newColor/>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<Attr isNullValueBreak="true" autoRefreshPerSecond="6" seriesDragEnable="false" plotStyle="4" combinedSize="50.0"/>
<newHotTooltipStyle>
<AttrContents>
<Attr showLine="false" position="1" isWhiteBackground="true" isShowMutiSeries="false" seriesLabel="${VALUE}"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#.##]]></Format>
<PercentFormat>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0.##%]]></Format>
</PercentFormat>
</AttrContents>
</newHotTooltipStyle>
<ConditionCollection>
<DefaultAttr class="com.fr.chart.chartglyph.ConditionAttr">
<ConditionAttr name=""/>
</DefaultAttr>
</ConditionCollection>
<Legend4VanChart>
<Legend>
<GI>
<AttrBackground>
<Background name="NullBackground"/>
<Attr shadow="false"/>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
<newColor borderColor="-3355444"/>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<Attr position="3" visible="true"/>
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
</Legend>
<Attr4VanChart floating="false" x="0.0" y="0.0" limitSize="false" maxHeight="15.0" isHighlight="true"/>
</Legend4VanChart>
<DataSheet>
<GI>
<AttrBackground>
<Background name="NullBackground"/>
<Attr shadow="false"/>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="1" isRoundBorder="false" roundRadius="0"/>
<newColor borderColor="-16777216"/>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<Attr isVisible="false"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#.##]]></Format>
</DataSheet>
<DataProcessor class="com.fr.base.chart.chartdata.model.NormalDataModel"/>
<newPlotFillStyle>
<AttrFillStyle>
<AFStyle colorStyle="1"/>
<FillStyleName fillStyleName=""/>
<isCustomFillStyle isCustomFillStyle="true"/>
<ColorList>
<OColor colvalue="-13385995"/>
<OColor colvalue="-12654700"/>
<OColor colvalue="-9857"/>
<OColor colvalue="-27006"/>
<OColor colvalue="-6974038"/>
<OColor colvalue="-10331231"/>
<OColor colvalue="-7763575"/>
<OColor colvalue="-6514688"/>
<OColor colvalue="-16744620"/>
<OColor colvalue="-6187579"/>
<OColor colvalue="-15714713"/>
<OColor colvalue="-945550"/>
<OColor colvalue="-4092928"/>
<OColor colvalue="-13224394"/>
<OColor colvalue="-12423245"/>
<OColor colvalue="-10043521"/>
<OColor colvalue="-406154"/>
<OColor colvalue="-13031292"/>
<OColor colvalue="-16732559"/>
<OColor colvalue="-7099690"/>
<OColor colvalue="-11991199"/>
<OColor colvalue="-331445"/>
<OColor colvalue="-6991099"/>
<OColor colvalue="-16686527"/>
<OColor colvalue="-9205567"/>
<OColor colvalue="-7397856"/>
<OColor colvalue="-406154"/>
<OColor colvalue="-2712831"/>
<OColor colvalue="-4737097"/>
<OColor colvalue="-11460720"/>
<OColor colvalue="-6696775"/>
<OColor colvalue="-3685632"/>
</ColorList>
</AttrFillStyle>
</newPlotFillStyle>
<VanChartPlotAttr isAxisRotation="false" categoryNum="1"/>
<VanChartRectanglePlotAttr vanChartPlotType="normal" isDefaultIntervalBackground="true"/>
<XAxisList>
<VanChartAxis class="com.fr.plugin.chart.attr.axis.VanChartAxis">
<Title>
<GI>
<AttrBackground>
<Background name="NullBackground"/>
<Attr shadow="false"/>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
<newColor borderColor="-16777216"/>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<O>
<![CDATA[]]></O>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="true"/>
<AxisLineStyle AxisStyle="1" MainGridStyle="1"/>
<newLineColor lineColor="-5197648"/>
<AxisPosition value="3"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
</Attr>
</TextAttr>
<AxisLabelCount value="=1"/>
<AxisRange/>
<AxisUnit201106 isCustomMainUnit="false" isCustomSecUnit="false" mainUnit="=0" secUnit="=0"/>
<ZoomAxisAttr isZoom="false"/>
<axisReversed axisReversed="false"/>
<VanChartAxisAttr mainTickLine="2" secTickLine="0" axisName="X轴" titleUseHtml="false" autoLabelGap="true" limitSize="false" maxHeight="15.0" commonValueFormat="true" isRotation="false"/>
<HtmlLabel customText="function(){ return this; }" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
<alertList/>
<customBackgroundList/>
</VanChartAxis>
</XAxisList>
<YAxisList>
<VanChartAxis class="com.fr.plugin.chart.attr.axis.VanChartValueAxis">
<Title>
<GI>
<AttrBackground>
<Background name="NullBackground"/>
<Attr shadow="false"/>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
<newColor borderColor="-16777216"/>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<O>
<![CDATA[]]></O>
<TextAttr>
<Attr rotation="-90" alignText="0">
<FRFont name="微软雅黑" style="0" size="48" foreground="-10066330"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="false"/>
<AxisLineStyle AxisStyle="0" MainGridStyle="1"/>
<newLineColor lineColor="-5197648"/>
<AxisPosition value="2"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="Verdana" style="0" size="88" foreground="-10066330"/>
</Attr>
</TextAttr>
<AxisLabelCount value="=1"/>
<AxisRange/>
<AxisUnit201106 isCustomMainUnit="false" isCustomSecUnit="false" mainUnit="=0" secUnit="=0"/>
<ZoomAxisAttr isZoom="false"/>
<axisReversed axisReversed="false"/>
<VanChartAxisAttr mainTickLine="0" secTickLine="0" axisName="Y轴" titleUseHtml="false" autoLabelGap="true" limitSize="false" maxHeight="15.0" commonValueFormat="true" isRotation="false"/>
<HtmlLabel customText="function(){ return this; }" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
<alertList/>
<customBackgroundList/>
<VanChartValueAxisAttr isLog="false" valueStyle="false" baseLog="=10"/>
<ds>
<RadarYAxisTableDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<attr/>
</RadarYAxisTableDefinition>
</ds>
</VanChartAxis>
<VanChartAxis class="com.fr.plugin.chart.attr.axis.VanChartValueAxis">
<Title>
<GI>
<AttrBackground>
<Background name="NullBackground"/>
<Attr shadow="false"/>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
<newColor borderColor="-16777216"/>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<O>
<![CDATA[]]></O>
<TextAttr>
<Attr rotation="-90" alignText="0">
<FRFont name="微软雅黑" style="0" size="48" foreground="-10066330"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="false"/>
<AxisLineStyle AxisStyle="0" MainGridStyle="1"/>
<newLineColor lineColor="-5197648"/>
<AxisPosition value="4"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="Verdana" style="0" size="88" foreground="-10066330"/>
</Attr>
</TextAttr>
<AxisLabelCount value="=1"/>
<AxisRange/>
<AxisUnit201106 isCustomMainUnit="false" isCustomSecUnit="false" mainUnit="=0" secUnit="=0"/>
<ZoomAxisAttr isZoom="false"/>
<axisReversed axisReversed="false"/>
<VanChartAxisAttr mainTickLine="0" secTickLine="0" axisName="Y轴2" titleUseHtml="false" autoLabelGap="true" limitSize="false" maxHeight="15.0" commonValueFormat="true" isRotation="false"/>
<HtmlLabel customText="function(){ return this; }" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
<alertList/>
<customBackgroundList/>
<VanChartValueAxisAttr isLog="false" valueStyle="false" baseLog="=10"/>
<ds>
<RadarYAxisTableDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<attr/>
</RadarYAxisTableDefinition>
</ds>
</VanChartAxis>
</YAxisList>
<stackAndAxisCondition>
<ConditionCollection>
<DefaultAttr class="com.fr.chart.chartglyph.ConditionAttr">
<ConditionAttr name=""/>
</DefaultAttr>
</ConditionCollection>
</stackAndAxisCondition>
<VanChartCustomPlotAttr customStyle="stack_column_line"/>
<CustomPlotList>
<VanChartPlot class="com.fr.plugin.chart.column.VanChartColumnPlot">
<VanChartPlotVersion version="20170715"/>
<GI>
<AttrBackground>
<Background name="NullBackground"/>
<Attr shadow="false"/>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
<newColor/>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<Attr isNullValueBreak="true" autoRefreshPerSecond="6" seriesDragEnable="false" plotStyle="4" combinedSize="50.0"/>
<newHotTooltipStyle>
<AttrContents>
<Attr showLine="false" position="1" isWhiteBackground="true" isShowMutiSeries="false" seriesLabel="${VALUE}"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#.##]]></Format>
<PercentFormat>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0.##%]]></Format>
</PercentFormat>
</AttrContents>
</newHotTooltipStyle>
<ConditionCollection>
<DefaultAttr class="com.fr.chart.chartglyph.ConditionAttr">
<ConditionAttr name="">
<AttrList>
<Attr class="com.fr.chart.base.AttrBorder">
<AttrBorder>
<Attr lineStyle="1" isRoundBorder="false" roundRadius="0"/>
<newColor borderColor="-1"/>
</AttrBorder>
</Attr>
<Attr class="com.fr.chart.base.AttrAlpha">
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</Attr>
<Attr class="com.fr.plugin.chart.base.VanChartAttrTrendLine">
<TrendLine>
<Attr trendLineName="" trendLineType="exponential" prePeriod="0" afterPeriod="0"/>
<LineStyleInfo>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
<AttrColor>
<Attr/>
</AttrColor>
<AttrLineStyle>
<newAttr lineStyle="0"/>
</AttrLineStyle>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
<newColor borderColor="-16777216"/>
</AttrBorder>
</LineStyleInfo>
</TrendLine>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrLabel">
<AttrLabel>
<labelAttr enable="false"/>
<labelDetail class="com.fr.plugin.chart.base.AttrLabelDetail">
<Attr showLine="false" autoAdjust="false" position="5" isCustom="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="宋体" style="0" size="72"/>
</Attr>
</TextAttr>
<AttrToolTipContent>
<Attr isCommon="true"/>
<value class="com.fr.plugin.chart.base.format.AttrTooltipValueFormat">
<AttrTooltipValueFormat>
<Attr enable="true"/>
</AttrTooltipValueFormat>
</value>
<percent class="com.fr.plugin.chart.base.format.AttrTooltipPercentFormat">
<AttrTooltipPercentFormat>
<Attr enable="false"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#.##%]]></Format>
</AttrTooltipPercentFormat>
</percent>
<category class="com.fr.plugin.chart.base.format.AttrTooltipCategoryFormat">
<AttrToolTipCategoryFormat>
<Attr enable="false"/>
</AttrToolTipCategoryFormat>
</category>
<series class="com.fr.plugin.chart.base.format.AttrTooltipSeriesFormat">
<AttrTooltipSeriesFormat>
<Attr enable="false"/>
</AttrTooltipSeriesFormat>
</series>
<changedPercent class="com.fr.plugin.chart.base.format.AttrTooltipChangedPercentFormat">
<AttrTooltipChangedPercentFormat>
<Attr enable="false"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#.##%]]></Format>
</AttrTooltipChangedPercentFormat>
</changedPercent>
<changedValue class="com.fr.plugin.chart.base.format.AttrTooltipChangedValueFormat">
<AttrTooltipChangedValueFormat>
<Attr enable="false"/>
</AttrTooltipChangedValueFormat>
</changedValue>
<HtmlLabel customText="" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
</AttrToolTipContent>
</labelDetail>
</AttrLabel>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrTooltip">
<AttrTooltip>
<Attr enable="true" duration="4" followMouse="false" showMutiSeries="true" isCustom="true"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
</Attr>
</TextAttr>
<AttrToolTipContent>
<Attr isCommon="true"/>
<value class="com.fr.plugin.chart.base.format.AttrTooltipValueFormat">
<AttrTooltipValueFormat>
<Attr enable="true"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0.##]]></Format>
</AttrTooltipValueFormat>
</value>
<percent class="com.fr.plugin.chart.base.format.AttrTooltipPercentFormat">
<AttrTooltipPercentFormat>
<Attr enable="false"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#.##%]]></Format>
</AttrTooltipPercentFormat>
</percent>
<category class="com.fr.plugin.chart.base.format.AttrTooltipCategoryFormat">
<AttrToolTipCategoryFormat>
<Attr enable="true"/>
</AttrToolTipCategoryFormat>
</category>
<series class="com.fr.plugin.chart.base.format.AttrTooltipSeriesFormat">
<AttrTooltipSeriesFormat>
<Attr enable="true"/>
</AttrTooltipSeriesFormat>
</series>
<changedPercent class="com.fr.plugin.chart.base.format.AttrTooltipChangedPercentFormat">
<AttrTooltipChangedPercentFormat>
<Attr enable="false"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#.##%]]></Format>
</AttrTooltipChangedPercentFormat>
</changedPercent>
<changedValue class="com.fr.plugin.chart.base.format.AttrTooltipChangedValueFormat">
<AttrTooltipChangedValueFormat>
<Attr enable="false"/>
</AttrTooltipChangedValueFormat>
</changedValue>
<HtmlLabel customText="" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
</AttrToolTipContent>
<GI>
<AttrBackground>
<Background name="ColorBackground" color="-16777216"/>
<Attr shadow="true"/>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="2"/>
<newColor borderColor="-16777216"/>
</AttrBorder>
<AttrAlpha>
<Attr alpha="0.5"/>
</AttrAlpha>
</GI>
</AttrTooltip>
</Attr>
</AttrList>
</ConditionAttr>
</DefaultAttr>
</ConditionCollection>
<Legend4VanChart>
<Legend>
<GI>
<AttrBackground>
<Background name="NullBackground"/>
<Attr shadow="false"/>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
<newColor borderColor="-3355444"/>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<Attr position="4" visible="true"/>
<FRFont name="Microsoft YaHei" style="0" size="88" foreground="-10066330"/>
</Legend>
<Attr4VanChart floating="false" x="0.0" y="0.0" limitSize="false" maxHeight="15.0" isHighlight="true"/>
</Legend4VanChart>
<DataSheet>
<GI>
<AttrBackground>
<Background name="NullBackground"/>
<Attr shadow="false"/>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="1" isRoundBorder="false" roundRadius="0"/>
<newColor borderColor="-16777216"/>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<Attr isVisible="false"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#.##]]></Format>
</DataSheet>
<DataProcessor class="com.fr.base.chart.chartdata.model.NormalDataModel"/>
<newPlotFillStyle>
<AttrFillStyle>
<AFStyle colorStyle="1"/>
<FillStyleName fillStyleName="新特性"/>
<isCustomFillStyle isCustomFillStyle="false"/>
<ColorList>
<OColor colvalue="-10243346"/>
<OColor colvalue="-8988015"/>
<OColor colvalue="-472193"/>
<OColor colvalue="-486008"/>
<OColor colvalue="-8595761"/>
<OColor colvalue="-7236949"/>
<OColor colvalue="-8873759"/>
<OColor colvalue="-1071514"/>
<OColor colvalue="-1188474"/>
<OColor colvalue="-6715442"/>
<OColor colvalue="-10243346"/>
<OColor colvalue="-8988015"/>
<OColor colvalue="-472193"/>
<OColor colvalue="-486008"/>
<OColor colvalue="-8595761"/>
<OColor colvalue="-7236949"/>
<OColor colvalue="-8873759"/>
<OColor colvalue="-1071514"/>
<OColor colvalue="-1188474"/>
<OColor colvalue="-6715442"/>
<OColor colvalue="-10243346"/>
<OColor colvalue="-8988015"/>
<OColor colvalue="-472193"/>
<OColor colvalue="-486008"/>
<OColor colvalue="-8595761"/>
<OColor colvalue="-7236949"/>
<OColor colvalue="-8873759"/>
<OColor colvalue="-1071514"/>
<OColor colvalue="-1188474"/>
<OColor colvalue="-6715442"/>
<OColor colvalue="-10243346"/>
<OColor colvalue="-8988015"/>
</ColorList>
</AttrFillStyle>
</newPlotFillStyle>
<VanChartPlotAttr isAxisRotation="false" categoryNum="1"/>
<VanChartRectanglePlotAttr vanChartPlotType="custom" isDefaultIntervalBackground="true"/>
<XAxisList>
<VanChartAxis class="com.fr.plugin.chart.attr.axis.VanChartAxis">
<Title>
<GI>
<AttrBackground>
<Background name="NullBackground"/>
<Attr shadow="false"/>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
<newColor borderColor="-16777216"/>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<O>
<![CDATA[]]></O>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="true"/>
<AxisLineStyle AxisStyle="1" MainGridStyle="1"/>
<newLineColor lineColor="-5197648"/>
<AxisPosition value="3"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
</Attr>
</TextAttr>
<AxisLabelCount value="=1"/>
<AxisRange/>
<AxisUnit201106 isCustomMainUnit="false" isCustomSecUnit="false" mainUnit="=0" secUnit="=0"/>
<ZoomAxisAttr isZoom="false"/>
<axisReversed axisReversed="false"/>
<VanChartAxisAttr mainTickLine="2" secTickLine="0" axisName="X轴" titleUseHtml="false" autoLabelGap="true" limitSize="false" maxHeight="15.0" commonValueFormat="true" isRotation="false"/>
<HtmlLabel customText="function(){ return this; }" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
<alertList/>
<customBackgroundList/>
</VanChartAxis>
</XAxisList>
<YAxisList>
<VanChartAxis class="com.fr.plugin.chart.attr.axis.VanChartValueAxis">
<Title>
<GI>
<AttrBackground>
<Background name="NullBackground"/>
<Attr shadow="false"/>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
<newColor borderColor="-16777216"/>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<O>
<![CDATA[]]></O>
<TextAttr>
<Attr rotation="-90" alignText="0">
<FRFont name="微软雅黑" style="0" size="48" foreground="-10066330"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="false"/>
<AxisLineStyle AxisStyle="0" MainGridStyle="1"/>
<newLineColor lineColor="-5197648"/>
<AxisPosition value="2"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="Verdana" style="0" size="88" foreground="-10066330"/>
</Attr>
</TextAttr>
<AxisLabelCount value="=1"/>
<AxisRange/>
<AxisUnit201106 isCustomMainUnit="false" isCustomSecUnit="false" mainUnit="=0" secUnit="=0"/>
<ZoomAxisAttr isZoom="false"/>
<axisReversed axisReversed="false"/>
<VanChartAxisAttr mainTickLine="0" secTickLine="0" axisName="Y轴" titleUseHtml="false" autoLabelGap="true" limitSize="false" maxHeight="15.0" commonValueFormat="true" isRotation="false"/>
<HtmlLabel customText="function(){ return this; }" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
<alertList/>
<customBackgroundList/>
<VanChartValueAxisAttr isLog="false" valueStyle="false" baseLog="=10"/>
<ds>
<RadarYAxisTableDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<attr/>
</RadarYAxisTableDefinition>
</ds>
</VanChartAxis>
<VanChartAxis class="com.fr.plugin.chart.attr.axis.VanChartValueAxis">
<Title>
<GI>
<AttrBackground>
<Background name="NullBackground"/>
<Attr shadow="false"/>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
<newColor borderColor="-16777216"/>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<O>
<![CDATA[]]></O>
<TextAttr>
<Attr rotation="-90" alignText="0">
<FRFont name="微软雅黑" style="0" size="48" foreground="-10066330"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="false"/>
<AxisLineStyle AxisStyle="0" MainGridStyle="1"/>
<newLineColor lineColor="-5197648"/>
<AxisPosition value="4"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="Verdana" style="0" size="88" foreground="-10066330"/>
</Attr>
</TextAttr>
<AxisLabelCount value="=1"/>
<AxisRange/>
<AxisUnit201106 isCustomMainUnit="false" isCustomSecUnit="false" mainUnit="=0" secUnit="=0"/>
<ZoomAxisAttr isZoom="false"/>
<axisReversed axisReversed="false"/>
<VanChartAxisAttr mainTickLine="0" secTickLine="0" axisName="Y轴2" titleUseHtml="false" autoLabelGap="true" limitSize="false" maxHeight="15.0" commonValueFormat="true" isRotation="false"/>
<HtmlLabel customText="function(){ return this; }" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
<alertList/>
<customBackgroundList/>
<VanChartValueAxisAttr isLog="false" valueStyle="false" baseLog="=10"/>
<ds>
<RadarYAxisTableDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<attr/>
</RadarYAxisTableDefinition>
</ds>
</VanChartAxis>
</YAxisList>
<stackAndAxisCondition>
<ConditionCollection>
<DefaultAttr class="com.fr.chart.chartglyph.ConditionAttr">
<ConditionAttr name=""/>
</DefaultAttr>
<ConditionAttrList>
<List index="0">
<ConditionAttr name="堆积和坐标轴1">
<AttrList>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="true" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
</AttrList>
<Condition class="com.fr.data.condition.ListCondition"/>
</ConditionAttr>
</List>
</ConditionAttrList>
</ConditionCollection>
</stackAndAxisCondition>
<VanChartColumnPlotAttr seriesOverlapPercent="20.0" categoryIntervalPercent="20.0" fixedWidth="false" columnWidth="0" filledWithImage="false" isBar="false"/>
</VanChartPlot>
<VanChartPlot class="com.fr.plugin.chart.line.VanChartLinePlot">
<VanChartPlotVersion version="20170715"/>
<GI>
<AttrBackground>
<Background name="NullBackground"/>
<Attr shadow="false"/>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
<newColor/>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<Attr isNullValueBreak="true" autoRefreshPerSecond="6" seriesDragEnable="false" plotStyle="4" combinedSize="50.0"/>
<newHotTooltipStyle>
<AttrContents>
<Attr showLine="false" position="1" isWhiteBackground="true" isShowMutiSeries="false" seriesLabel="${VALUE}"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#.##]]></Format>
<PercentFormat>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0.##%]]></Format>
</PercentFormat>
</AttrContents>
</newHotTooltipStyle>
<ConditionCollection>
<DefaultAttr class="com.fr.chart.chartglyph.ConditionAttr">
<ConditionAttr name="">
<AttrList>
<Attr class="com.fr.plugin.chart.base.VanChartAttrTrendLine">
<TrendLine>
<Attr trendLineName="" trendLineType="exponential" prePeriod="0" afterPeriod="0"/>
<LineStyleInfo>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
<AttrColor>
<Attr/>
</AttrColor>
<AttrLineStyle>
<newAttr lineStyle="0"/>
</AttrLineStyle>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
<newColor borderColor="-16777216"/>
</AttrBorder>
</LineStyleInfo>
</TrendLine>
</Attr>
<Attr class="com.fr.plugin.chart.base.VanChartAttrLine">
<VanAttrLine>
<Attr lineWidth="2" lineStyle="0" nullValueBreak="true"/>
</VanAttrLine>
</Attr>
<Attr class="com.fr.plugin.chart.base.VanChartAttrMarker">
<VanAttrMarker>
<Attr isCommon="true" markerType="NullMarker" radius="4.5" width="30.0" height="30.0"/>
<Background name="NullBackground"/>
</VanAttrMarker>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrLabel">
<AttrLabel>
<labelAttr enable="false"/>
<labelDetail class="com.fr.plugin.chart.base.AttrLabelDetail">
<Attr showLine="false" autoAdjust="false" position="1" isCustom="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="宋体" style="0" size="72"/>
</Attr>
</TextAttr>
<AttrToolTipContent>
<Attr isCommon="true"/>
<value class="com.fr.plugin.chart.base.format.AttrTooltipValueFormat">
<AttrTooltipValueFormat>
<Attr enable="true"/>
</AttrTooltipValueFormat>
</value>
<percent class="com.fr.plugin.chart.base.format.AttrTooltipPercentFormat">
<AttrTooltipPercentFormat>
<Attr enable="false"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#.##%]]></Format>
</AttrTooltipPercentFormat>
</percent>
<category class="com.fr.plugin.chart.base.format.AttrTooltipCategoryFormat">
<AttrToolTipCategoryFormat>
<Attr enable="false"/>
</AttrToolTipCategoryFormat>
</category>
<series class="com.fr.plugin.chart.base.format.AttrTooltipSeriesFormat">
<AttrTooltipSeriesFormat>
<Attr enable="false"/>
</AttrTooltipSeriesFormat>
</series>
<changedPercent class="com.fr.plugin.chart.base.format.AttrTooltipChangedPercentFormat">
<AttrTooltipChangedPercentFormat>
<Attr enable="false"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#.##%]]></Format>
</AttrTooltipChangedPercentFormat>
</changedPercent>
<changedValue class="com.fr.plugin.chart.base.format.AttrTooltipChangedValueFormat">
<AttrTooltipChangedValueFormat>
<Attr enable="false"/>
</AttrTooltipChangedValueFormat>
</changedValue>
<HtmlLabel customText="" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
</AttrToolTipContent>
</labelDetail>
</AttrLabel>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrTooltip">
<AttrTooltip>
<Attr enable="true" duration="4" followMouse="false" showMutiSeries="true" isCustom="true"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
</Attr>
</TextAttr>
<AttrToolTipContent>
<Attr isCommon="true"/>
<value class="com.fr.plugin.chart.base.format.AttrTooltipValueFormat">
<AttrTooltipValueFormat>
<Attr enable="true"/>
</AttrTooltipValueFormat>
</value>
<percent class="com.fr.plugin.chart.base.format.AttrTooltipPercentFormat">
<AttrTooltipPercentFormat>
<Attr enable="false"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#.##%]]></Format>
</AttrTooltipPercentFormat>
</percent>
<category class="com.fr.plugin.chart.base.format.AttrTooltipCategoryFormat">
<AttrToolTipCategoryFormat>
<Attr enable="true"/>
</AttrToolTipCategoryFormat>
</category>
<series class="com.fr.plugin.chart.base.format.AttrTooltipSeriesFormat">
<AttrTooltipSeriesFormat>
<Attr enable="true"/>
</AttrTooltipSeriesFormat>
</series>
<changedPercent class="com.fr.plugin.chart.base.format.AttrTooltipChangedPercentFormat">
<AttrTooltipChangedPercentFormat>
<Attr enable="false"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#.##%]]></Format>
</AttrTooltipChangedPercentFormat>
</changedPercent>
<changedValue class="com.fr.plugin.chart.base.format.AttrTooltipChangedValueFormat">
<AttrTooltipChangedValueFormat>
<Attr enable="false"/>
</AttrTooltipChangedValueFormat>
</changedValue>
<HtmlLabel customText="" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
</AttrToolTipContent>
<GI>
<AttrBackground>
<Background name="ColorBackground" color="-16777216"/>
<Attr shadow="true"/>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="2"/>
<newColor borderColor="-16777216"/>
</AttrBorder>
<AttrAlpha>
<Attr alpha="0.5"/>
</AttrAlpha>
</GI>
</AttrTooltip>
</Attr>
</AttrList>
</ConditionAttr>
</DefaultAttr>
</ConditionCollection>
<Legend4VanChart>
<Legend>
<GI>
<AttrBackground>
<Background name="NullBackground"/>
<Attr shadow="false"/>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
<newColor borderColor="-3355444"/>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<Attr position="4" visible="true"/>
<FRFont name="Microsoft YaHei" style="0" size="88" foreground="-10066330"/>
</Legend>
<Attr4VanChart floating="false" x="0.0" y="0.0" limitSize="false" maxHeight="15.0" isHighlight="true"/>
</Legend4VanChart>
<DataSheet>
<GI>
<AttrBackground>
<Background name="NullBackground"/>
<Attr shadow="false"/>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="1" isRoundBorder="false" roundRadius="0"/>
<newColor borderColor="-16777216"/>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<Attr isVisible="false"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#.##]]></Format>
</DataSheet>
<DataProcessor class="com.fr.base.chart.chartdata.model.NormalDataModel"/>
<newPlotFillStyle>
<AttrFillStyle>
<AFStyle colorStyle="1"/>
<FillStyleName fillStyleName="新特性"/>
<isCustomFillStyle isCustomFillStyle="false"/>
<ColorList>
<OColor colvalue="-10243346"/>
<OColor colvalue="-8988015"/>
<OColor colvalue="-472193"/>
<OColor colvalue="-486008"/>
<OColor colvalue="-8595761"/>
<OColor colvalue="-7236949"/>
<OColor colvalue="-8873759"/>
<OColor colvalue="-1071514"/>
<OColor colvalue="-1188474"/>
<OColor colvalue="-6715442"/>
<OColor colvalue="-10243346"/>
<OColor colvalue="-8988015"/>
<OColor colvalue="-472193"/>
<OColor colvalue="-486008"/>
<OColor colvalue="-8595761"/>
<OColor colvalue="-7236949"/>
<OColor colvalue="-8873759"/>
<OColor colvalue="-1071514"/>
<OColor colvalue="-1188474"/>
<OColor colvalue="-6715442"/>
<OColor colvalue="-10243346"/>
<OColor colvalue="-8988015"/>
<OColor colvalue="-472193"/>
<OColor colvalue="-486008"/>
<OColor colvalue="-8595761"/>
<OColor colvalue="-7236949"/>
<OColor colvalue="-8873759"/>
<OColor colvalue="-1071514"/>
<OColor colvalue="-1188474"/>
<OColor colvalue="-6715442"/>
<OColor colvalue="-10243346"/>
<OColor colvalue="-8988015"/>
</ColorList>
</AttrFillStyle>
</newPlotFillStyle>
<VanChartPlotAttr isAxisRotation="false" categoryNum="1"/>
<VanChartRectanglePlotAttr vanChartPlotType="custom" isDefaultIntervalBackground="true"/>
<XAxisList>
<VanChartAxis class="com.fr.plugin.chart.attr.axis.VanChartAxis">
<Title>
<GI>
<AttrBackground>
<Background name="NullBackground"/>
<Attr shadow="false"/>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
<newColor borderColor="-16777216"/>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<O>
<![CDATA[]]></O>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="true"/>
<AxisLineStyle AxisStyle="1" MainGridStyle="1"/>
<newLineColor lineColor="-5197648"/>
<AxisPosition value="3"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
</Attr>
</TextAttr>
<AxisLabelCount value="=1"/>
<AxisRange/>
<AxisUnit201106 isCustomMainUnit="false" isCustomSecUnit="false" mainUnit="=0" secUnit="=0"/>
<ZoomAxisAttr isZoom="false"/>
<axisReversed axisReversed="false"/>
<VanChartAxisAttr mainTickLine="2" secTickLine="0" axisName="X轴" titleUseHtml="false" autoLabelGap="true" limitSize="false" maxHeight="15.0" commonValueFormat="true" isRotation="false"/>
<HtmlLabel customText="function(){ return this; }" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
<alertList/>
<customBackgroundList/>
</VanChartAxis>
</XAxisList>
<YAxisList>
<VanChartAxis class="com.fr.plugin.chart.attr.axis.VanChartValueAxis">
<Title>
<GI>
<AttrBackground>
<Background name="NullBackground"/>
<Attr shadow="false"/>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
<newColor borderColor="-16777216"/>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<O>
<![CDATA[]]></O>
<TextAttr>
<Attr rotation="-90" alignText="0">
<FRFont name="微软雅黑" style="0" size="48" foreground="-10066330"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="false"/>
<AxisLineStyle AxisStyle="0" MainGridStyle="1"/>
<newLineColor lineColor="-5197648"/>
<AxisPosition value="2"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="Verdana" style="0" size="88" foreground="-10066330"/>
</Attr>
</TextAttr>
<AxisLabelCount value="=1"/>
<AxisRange/>
<AxisUnit201106 isCustomMainUnit="false" isCustomSecUnit="false" mainUnit="=0" secUnit="=0"/>
<ZoomAxisAttr isZoom="false"/>
<axisReversed axisReversed="false"/>
<VanChartAxisAttr mainTickLine="0" secTickLine="0" axisName="Y轴" titleUseHtml="false" autoLabelGap="true" limitSize="false" maxHeight="15.0" commonValueFormat="true" isRotation="false"/>
<HtmlLabel customText="function(){ return this; }" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
<alertList/>
<customBackgroundList/>
<VanChartValueAxisAttr isLog="false" valueStyle="false" baseLog="=10"/>
<ds>
<RadarYAxisTableDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<attr/>
</RadarYAxisTableDefinition>
</ds>
</VanChartAxis>
<VanChartAxis class="com.fr.plugin.chart.attr.axis.VanChartValueAxis">
<Title>
<GI>
<AttrBackground>
<Background name="NullBackground"/>
<Attr shadow="false"/>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
<newColor borderColor="-16777216"/>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<O>
<![CDATA[]]></O>
<TextAttr>
<Attr rotation="-90" alignText="0">
<FRFont name="微软雅黑" style="0" size="48" foreground="-10066330"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="false"/>
<AxisLineStyle AxisStyle="0" MainGridStyle="1"/>
<newLineColor lineColor="-5197648"/>
<AxisPosition value="4"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="Verdana" style="0" size="88" foreground="-10066330"/>
</Attr>
</TextAttr>
<AxisLabelCount value="=1"/>
<AxisRange/>
<AxisUnit201106 isCustomMainUnit="false" isCustomSecUnit="false" mainUnit="=0" secUnit="=0"/>
<ZoomAxisAttr isZoom="false"/>
<axisReversed axisReversed="false"/>
<VanChartAxisAttr mainTickLine="0" secTickLine="0" axisName="Y轴2" titleUseHtml="false" autoLabelGap="true" limitSize="false" maxHeight="15.0" commonValueFormat="true" isRotation="false"/>
<HtmlLabel customText="function(){ return this; }" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
<alertList/>
<customBackgroundList/>
<VanChartValueAxisAttr isLog="false" valueStyle="false" baseLog="=10"/>
<ds>
<RadarYAxisTableDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<attr/>
</RadarYAxisTableDefinition>
</ds>
</VanChartAxis>
</YAxisList>
<stackAndAxisCondition>
<ConditionCollection>
<DefaultAttr class="com.fr.chart.chartglyph.ConditionAttr">
<ConditionAttr name=""/>
</DefaultAttr>
<ConditionAttrList>
<List index="0">
<ConditionAttr name="堆积和坐标轴1">
<AttrList>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="1" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
</AttrList>
<Condition class="com.fr.data.condition.ListCondition"/>
</ConditionAttr>
</List>
</ConditionAttrList>
</ConditionCollection>
</stackAndAxisCondition>
</VanChartPlot>
</CustomPlotList>
</Plot>
<ChartDefinition>
<CustomDefinition>
<DefinitionMapList>
<DefinitionMap key="line">
<OneValueCDDefinition function="com.fr.data.util.function.NoneFunction">
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
</OneValueCDDefinition>
</DefinitionMap>
<DefinitionMap key="column">
<MoreNameCDDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[存货区域与结构]]></Name>
</TableData>
<CategoryName value="区域"/>
<ChartSummaryColumn name="其他" function="com.fr.data.util.function.NoneFunction" customName="其他"/>
<ChartSummaryColumn name="住宅" function="com.fr.data.util.function.NoneFunction" customName="住宅"/>
<ChartSummaryColumn name="产业新城" function="com.fr.data.util.function.NoneFunction" customName="产业新城"/>
</MoreNameCDDefinition>
</DefinitionMap>
</DefinitionMapList>
</CustomDefinition>
</ChartDefinition>
</Chart>
<tools hidden="true" sort="false" export="false" fullScreen="false"/>
<VanChartZoom>
<zoomAttr zoomVisible="false" zoomGesture="true" zoomResize="true" zoomType="xy"/>
<from>
<![CDATA[]]></from>
<to>
<![CDATA[]]></to>
</VanChartZoom>
<refreshMoreLabel>
<attr moreLabel="false" autoTooltip="true"/>
<AttrTooltip>
<Attr enable="true" duration="4" followMouse="false" showMutiSeries="false" isCustom="false"/>
<TextAttr>
<Attr alignText="0"/>
</TextAttr>
<AttrToolTipContent>
<Attr isCommon="true"/>
<value class="com.fr.plugin.chart.base.format.AttrTooltipValueFormat">
<AttrTooltipValueFormat>
<Attr enable="true"/>
</AttrTooltipValueFormat>
</value>
<percent class="com.fr.plugin.chart.base.format.AttrTooltipPercentFormat">
<AttrTooltipPercentFormat>
<Attr enable="false"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#.##%]]></Format>
</AttrTooltipPercentFormat>
</percent>
<category class="com.fr.plugin.chart.base.format.AttrTooltipCategoryFormat">
<AttrToolTipCategoryFormat>
<Attr enable="true"/>
</AttrToolTipCategoryFormat>
</category>
<series class="com.fr.plugin.chart.base.format.AttrTooltipSeriesFormat">
<AttrTooltipSeriesFormat>
<Attr enable="true"/>
</AttrTooltipSeriesFormat>
</series>
<changedPercent class="com.fr.plugin.chart.base.format.AttrTooltipChangedPercentFormat">
<AttrTooltipChangedPercentFormat>
<Attr enable="false"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#.##%]]></Format>
</AttrTooltipChangedPercentFormat>
</changedPercent>
<changedValue class="com.fr.plugin.chart.base.format.AttrTooltipChangedValueFormat">
<AttrTooltipChangedValueFormat>
<Attr enable="true"/>
</AttrTooltipChangedValueFormat>
</changedValue>
<HtmlLabel customText="" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
</AttrToolTipContent>
<GI>
<AttrBackground>
<Background name="ColorBackground" color="-1"/>
<Attr shadow="false"/>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="1" isRoundBorder="false" roundRadius="4"/>
<newColor borderColor="-15395563"/>
</AttrBorder>
<AttrAlpha>
<Attr alpha="0.8"/>
</AttrAlpha>
</GI>
</AttrTooltip>
</refreshMoreLabel>
</Chart>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="1">
<PrivilegeControl/>
<Expand/>
</C>
</CellElementList>
<ReportAttrSet>
<ReportSettings headerHeight="0" footerHeight="0">
<PaperSetting/>
</ReportSettings>
</ReportAttrSet>
</FormElementCase>
<StyleList/>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</body>
</InnerWidget>
<BoundsAttr x="8" y="254" width="840" height="205"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report7_c_c_c"/>
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
<InnerWidget class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="report7_c_c_c"/>
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
<FormElementCase>
<ReportPageAttr>
<HR/>
<FR/>
<HC/>
<FC/>
</ReportPageAttr>
<ColumnPrivilegeControl/>
<RowPrivilegeControl/>
<RowHeight defaultValue="723900">
<![CDATA[838200,838200,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[1872000,576000,5143500,1872000,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" cs="3" rs="2" s="0">
<O>
<![CDATA[存货结构]]></O>
<PrivilegeControl/>
<Expand/>
</C>
</CellElementList>
<ReportAttrSet>
<ReportSettings headerHeight="0" footerHeight="0">
<PaperSetting/>
</ReportSettings>
</ReportAttrSet>
</FormElementCase>
<StyleList>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="96" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="250" height="150"/>
</Widget>
<body class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="report7"/>
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
<FormElementCase>
<ReportPageAttr>
<HR/>
<FR/>
<HC/>
<FC/>
</ReportPageAttr>
<ColumnPrivilegeControl/>
<RowPrivilegeControl/>
<RowHeight defaultValue="723900">
<![CDATA[1440000,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[1333500,4000500,190500,1872000,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" cs="4" s="0">
<O>
<![CDATA[  签约完成情况]]></O>
<PrivilegeControl/>
<Expand/>
</C>
</CellElementList>
<ReportAttrSet>
<ReportSettings headerHeight="0" footerHeight="0">
<PaperSetting/>
</ReportSettings>
</ReportAttrSet>
</FormElementCase>
<StyleList>
<Style vertical_alignment="1" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="96" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</body>
</InnerWidget>
<BoundsAttr x="14" y="30" width="180" height="28"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report3"/>
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
<InnerWidget class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="report3"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="1" color="-15388336" borderRadius="0" type="0" borderStyle="0"/>
<WidgetTitle>
<O>
<![CDATA[新建标题]]></O>
<FRFont name="宋体" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Background name="ColorBackground" color="-16377030"/>
<Alpha alpha="1.0"/>
</Border>
<Background name="ColorBackground" color="-16377030"/>
<FormElementCase>
<ReportPageAttr>
<HR/>
<FR/>
<HC/>
<FC/>
</ReportPageAttr>
<ColumnPrivilegeControl/>
<RowPrivilegeControl/>
<RowHeight defaultValue="723900">
<![CDATA[1728000,936000,457200,1440000,720000,1152000,720000,1152000,723900,1104900,720000,342900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[1219200,2592000,381000,2592000,0,2304000,0,2880000,144000,1152000,1152000,9105900,1152000,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="1">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="1" r="1" s="0">
<O>
<![CDATA[产业新城]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="当前决策报表对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="ch"/>
<O>
<![CDATA[新城集团]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report3"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="当前决策报表对象2">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="ch"/>
<O>
<![CDATA[新城集团]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report1"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$ch = "新城集团"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320!n)oj/B>R2,]A/DG[KEKA:D_'5ME,Tn*9:pTi*eUTqCG_9;5H.R=W
HhJ$FnD.J)YgM/c"$c^&)^<I-L&/!<oA*%Rq`[&EA<5_i7Y(m=c5p=r7C1>W;j?(a!".d08o
t96nQg98&p8mk9e'g<\^AlK>Iu.A7%J~
]]></IM>
</Background>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="2" r="1" s="1">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="3" r="1" s="0">
<O>
<![CDATA[环京]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="当前决策报表对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="ch"/>
<O>
<![CDATA[环京]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report3"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="当前决策报表对象2">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="ch"/>
<O>
<![CDATA[环京]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report1"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$ch = "环京"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320!n'7t/B>R2,hjsN\.5;I4C&po.d"CWZ'"d2JcL^=embQEO-E[aH[
D^!Z09G'd'*'>Z#n=Gm)=_Yl_?Eb$k`UZRFu[_EIKG<^#2Nc,I<c96,J1A9Pcg'+U8o&]A2*9
VP1Zu?.c,V^b8kc4Mana3NqR&cm:,R,olF:!PgBO5~
]]></IM>
</Background>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="4" r="1" s="1">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="5" r="1" s="0">
<O>
<![CDATA[外埠]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="当前决策报表对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="ch"/>
<O>
<![CDATA[外埠]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report3"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="当前决策报表对象2">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="ch"/>
<O>
<![CDATA[外埠]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report1"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$ch = "外埠"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320!n'7t/B>R2,hjsN\.5;I4C&po.d"CWZ'"d2JcL^=embQEO-E[aH[
D^!Z09G'd'*'>Z#n=Gm)=_Yl_?Eb$k`UZRFu[_EIKG<^#2Nc,I<c96,J1A9Pcg'+U8o&]A2*9
VP1Zu?.c,V^b8kc4Mana3NqR&cm:,R,olF:!PgBO5~
]]></IM>
</Background>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="6" r="1">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="7" r="1">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="8" r="1">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="9" r="1">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="10" r="1">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="11" r="1" cs="4" rs="10">
<O t="CC">
<LayoutAttr selectedIndex="0"/>
<ChangeAttr enable="false" changeType="button" timeInterval="5" buttonColor="-8421505" carouselColor="-8421505" showArrow="true">
<TextAttr>
<Attr alignText="0"/>
</TextAttr>
</ChangeAttr>
<Chart name="默认" chartClass="com.fr.plugin.chart.vanchart.VanChart">
<Chart class="com.fr.plugin.chart.vanchart.VanChart">
<GI>
<AttrBackground>
<Background name="NullBackground"/>
<Attr shadow="false"/>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
<newColor borderColor="-1118482"/>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<ChartAttr isJSDraw="true" isStyleGlobal="false"/>
<Title4VanChart>
<Title>
<GI>
<AttrBackground>
<Background name="NullBackground"/>
<Attr shadow="false"/>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
<newColor borderColor="-6908266"/>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<O>
<![CDATA[新建图表标题]]></O>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="128" foreground="-13421773"/>
</Attr>
</TextAttr>
<TitleVisible value="false" position="0"/>
</Title>
<Attr4VanChart useHtml="false" floating="false" x="0.0" y="0.0" limitSize="false" maxHeight="15.0"/>
</Title4VanChart>
<Plot class="com.fr.plugin.chart.PiePlot4VanChart">
<VanChartPlotVersion version="20170715"/>
<GI>
<AttrBackground>
<Background name="NullBackground"/>
<Attr shadow="false"/>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
<newColor borderColor="-1118482"/>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<Attr isNullValueBreak="true" autoRefreshPerSecond="6" seriesDragEnable="false" plotStyle="4" combinedSize="50.0"/>
<newHotTooltipStyle>
<AttrContents>
<Attr showLine="false" position="1" isWhiteBackground="true" isShowMutiSeries="false" seriesLabel="${VALUE}"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#.##]]></Format>
<PercentFormat>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0.##%]]></Format>
</PercentFormat>
</AttrContents>
</newHotTooltipStyle>
<ConditionCollection>
<DefaultAttr class="com.fr.chart.chartglyph.ConditionAttr">
<ConditionAttr name="">
<AttrList>
<Attr class="com.fr.chart.base.AttrBorder">
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
<newColor borderColor="-1"/>
</AttrBorder>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrLabel">
<AttrLabel>
<labelAttr enable="true"/>
<labelDetail class="com.fr.plugin.chart.base.AttrLabelDetail">
<Attr showLine="true" autoAdjust="false" position="6" isCustom="true"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
</Attr>
</TextAttr>
<AttrToolTipContent>
<Attr isCommon="true"/>
<value class="com.fr.plugin.chart.base.format.AttrTooltipValueFormat">
<AttrTooltipValueFormat>
<Attr enable="false"/>
</AttrTooltipValueFormat>
</value>
<percent class="com.fr.plugin.chart.base.format.AttrTooltipPercentFormat">
<AttrTooltipPercentFormat>
<Attr enable="true"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0%]]></Format>
</AttrTooltipPercentFormat>
</percent>
<category class="com.fr.plugin.chart.base.format.AttrTooltipCategoryFormat">
<AttrToolTipCategoryFormat>
<Attr enable="false"/>
</AttrToolTipCategoryFormat>
</category>
<series class="com.fr.plugin.chart.base.format.AttrTooltipSeriesFormat">
<AttrTooltipSeriesFormat>
<Attr enable="true"/>
</AttrTooltipSeriesFormat>
</series>
<changedPercent class="com.fr.plugin.chart.base.format.AttrTooltipChangedPercentFormat">
<AttrTooltipChangedPercentFormat>
<Attr enable="false"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#.##%]]></Format>
</AttrTooltipChangedPercentFormat>
</changedPercent>
<changedValue class="com.fr.plugin.chart.base.format.AttrTooltipChangedValueFormat">
<AttrTooltipChangedValueFormat>
<Attr enable="false"/>
</AttrTooltipChangedValueFormat>
</changedValue>
<HtmlLabel customText="" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
</AttrToolTipContent>
</labelDetail>
</AttrLabel>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrTooltip">
<AttrTooltip>
<Attr enable="true" duration="4" followMouse="false" showMutiSeries="false" isCustom="true"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="96" foreground="-1"/>
</Attr>
</TextAttr>
<AttrToolTipContent>
<Attr isCommon="true"/>
<value class="com.fr.plugin.chart.base.format.AttrTooltipValueFormat">
<AttrTooltipValueFormat>
<Attr enable="true"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0.0亿]]></Format>
</AttrTooltipValueFormat>
</value>
<percent class="com.fr.plugin.chart.base.format.AttrTooltipPercentFormat">
<AttrTooltipPercentFormat>
<Attr enable="false"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#.##%]]></Format>
</AttrTooltipPercentFormat>
</percent>
<category class="com.fr.plugin.chart.base.format.AttrTooltipCategoryFormat">
<AttrToolTipCategoryFormat>
<Attr enable="false"/>
</AttrToolTipCategoryFormat>
</category>
<series class="com.fr.plugin.chart.base.format.AttrTooltipSeriesFormat">
<AttrTooltipSeriesFormat>
<Attr enable="true"/>
</AttrTooltipSeriesFormat>
</series>
<changedPercent class="com.fr.plugin.chart.base.format.AttrTooltipChangedPercentFormat">
<AttrTooltipChangedPercentFormat>
<Attr enable="false"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#.##%]]></Format>
</AttrTooltipChangedPercentFormat>
</changedPercent>
<changedValue class="com.fr.plugin.chart.base.format.AttrTooltipChangedValueFormat">
<AttrTooltipChangedValueFormat>
<Attr enable="false"/>
</AttrTooltipChangedValueFormat>
</changedValue>
<HtmlLabel customText="" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
</AttrToolTipContent>
<GI>
<AttrBackground>
<Background name="ColorBackground" color="-16777216"/>
<Attr shadow="true"/>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="4"/>
<newColor borderColor="-16777216"/>
</AttrBorder>
<AttrAlpha>
<Attr alpha="0.8"/>
</AttrAlpha>
</GI>
</AttrTooltip>
</Attr>
</AttrList>
</ConditionAttr>
</DefaultAttr>
</ConditionCollection>
<Legend4VanChart>
<Legend>
<GI>
<AttrBackground>
<Background name="NullBackground"/>
<Attr shadow="false"/>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
<newColor borderColor="-3355444"/>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<Attr position="4" visible="false"/>
<FRFont name="微软雅黑" style="0" size="88" foreground="-10066330"/>
</Legend>
<Attr4VanChart floating="false" x="0.0" y="0.0" limitSize="false" maxHeight="15.0" isHighlight="true"/>
</Legend4VanChart>
<DataSheet>
<GI>
<AttrBackground>
<Background name="NullBackground"/>
<Attr shadow="false"/>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="1" isRoundBorder="false" roundRadius="0"/>
<newColor borderColor="-16777216"/>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<Attr isVisible="false"/>
</DataSheet>
<DataProcessor class="com.fr.base.chart.chartdata.model.NormalDataModel"/>
<newPlotFillStyle>
<AttrFillStyle>
<AFStyle colorStyle="1"/>
<FillStyleName fillStyleName="饼图"/>
<isCustomFillStyle isCustomFillStyle="false"/>
<ColorList>
<OColor colvalue="-16713985"/>
<OColor colvalue="-12475905"/>
<OColor colvalue="-9022774"/>
<OColor colvalue="-10657305"/>
<OColor colvalue="-3627556"/>
<OColor colvalue="-4098877"/>
<OColor colvalue="-13465455"/>
<OColor colvalue="-13605474"/>
<OColor colvalue="-12770431"/>
<OColor colvalue="-6922087"/>
<OColor colvalue="-15223641"/>
<OColor colvalue="-14837288"/>
<OColor colvalue="-15417965"/>
<OColor colvalue="-13224394"/>
<OColor colvalue="-12423245"/>
<OColor colvalue="-10043521"/>
<OColor colvalue="-406154"/>
<OColor colvalue="-13031292"/>
<OColor colvalue="-16732559"/>
<OColor colvalue="-7099690"/>
<OColor colvalue="-11991199"/>
<OColor colvalue="-331445"/>
<OColor colvalue="-6991099"/>
<OColor colvalue="-16686527"/>
<OColor colvalue="-9205567"/>
<OColor colvalue="-7397856"/>
<OColor colvalue="-406154"/>
<OColor colvalue="-2712831"/>
<OColor colvalue="-4737097"/>
<OColor colvalue="-11460720"/>
<OColor colvalue="-6696775"/>
<OColor colvalue="-3685632"/>
</ColorList>
</AttrFillStyle>
</newPlotFillStyle>
<VanChartPlotAttr isAxisRotation="false" categoryNum="1"/>
<PieAttr4VanChart roseType="normal" startAngle="0.0" endAngle="360.0" innerRadius="0.0" supportRotation="true"/>
<VanChartRadius radiusType="auto" radius="100"/>
</Plot>
<ChartDefinition>
<OneValueCDDefinition seriesName="TYPE" valueName="ACTUAL" function="com.fr.data.util.function.NoneFunction">
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[饼图]]></Name>
</TableData>
<CategoryName value="无"/>
</OneValueCDDefinition>
</ChartDefinition>
</Chart>
<tools hidden="true" sort="false" export="false" fullScreen="false"/>
<VanChartZoom>
<zoomAttr zoomVisible="false" zoomGesture="true" zoomResize="true" zoomType="xy"/>
<from>
<![CDATA[]]></from>
<to>
<![CDATA[]]></to>
</VanChartZoom>
<refreshMoreLabel>
<attr moreLabel="false" autoTooltip="true"/>
<AttrTooltip>
<Attr enable="true" duration="4" followMouse="false" showMutiSeries="false" isCustom="false"/>
<TextAttr>
<Attr alignText="0"/>
</TextAttr>
<AttrToolTipContent>
<Attr isCommon="true"/>
<value class="com.fr.plugin.chart.base.format.AttrTooltipValueFormat">
<AttrTooltipValueFormat>
<Attr enable="true"/>
</AttrTooltipValueFormat>
</value>
<percent class="com.fr.plugin.chart.base.format.AttrTooltipPercentFormat">
<AttrTooltipPercentFormat>
<Attr enable="false"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#.##%]]></Format>
</AttrTooltipPercentFormat>
</percent>
<category class="com.fr.plugin.chart.base.format.AttrTooltipCategoryFormat">
<AttrToolTipCategoryFormat>
<Attr enable="true"/>
</AttrToolTipCategoryFormat>
</category>
<series class="com.fr.plugin.chart.base.format.AttrTooltipSeriesFormat">
<AttrTooltipSeriesFormat>
<Attr enable="true"/>
</AttrTooltipSeriesFormat>
</series>
<changedPercent class="com.fr.plugin.chart.base.format.AttrTooltipChangedPercentFormat">
<AttrTooltipChangedPercentFormat>
<Attr enable="false"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#.##%]]></Format>
</AttrTooltipChangedPercentFormat>
</changedPercent>
<changedValue class="com.fr.plugin.chart.base.format.AttrTooltipChangedValueFormat">
<AttrTooltipChangedValueFormat>
<Attr enable="true"/>
</AttrTooltipChangedValueFormat>
</changedValue>
<HtmlLabel customText="" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
</AttrToolTipContent>
<GI>
<AttrBackground>
<Background name="ColorBackground" color="-1"/>
<Attr shadow="false"/>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="1" isRoundBorder="false" roundRadius="4"/>
<newColor borderColor="-15395563"/>
</AttrBorder>
<AttrAlpha>
<Attr alpha="0.8"/>
</AttrAlpha>
</GI>
</AttrTooltip>
</refreshMoreLabel>
</Chart>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="1" r="3" cs="5" s="2">
<O t="RichText">
<RichText>
<RichChar styleIndex="3">
<text>
<![CDATA[整体存货   ]]></text>
</RichChar>
<RichChar styleIndex="4">
<text>
<![CDATA[${=if(len(round(sum(d15:d18),1))=0, "", round(sum(d15:d18),1) )}]]></text>
</RichChar>
<RichChar styleIndex="3">
<text>
<![CDATA[亿]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="6" r="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="5">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="5" cs="3" s="5">
<O t="RichText">
<RichText>
<RichChar styleIndex="3">
<text>
<![CDATA[土地整理]]></text>
</RichChar>
<RichChar styleIndex="6">
<text>
<![CDATA[  ]]></text>
</RichChar>
<RichChar styleIndex="6">
<text>
<![CDATA[${=if(len(d15)=0, "", round(d15,1) )}]]></text>
</RichChar>
<RichChar styleIndex="3">
<text>
<![CDATA[亿]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="4" r="5" s="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="5" cs="6" s="5">
<O t="RichText">
<RichText>
<RichChar styleIndex="3">
<text>
<![CDATA[        产业服务成本]]></text>
</RichChar>
<RichChar styleIndex="8">
<text>
<![CDATA[  ]]></text>
</RichChar>
<RichChar styleIndex="6">
<text>
<![CDATA[${=if(len(d17)=0, "", round(d17,1) )}]]></text>
</RichChar>
<RichChar styleIndex="3">
<text>
<![CDATA[亿]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="18" r="5">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="6" s="9">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="6" s="10">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="6" s="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="6" s="9">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="6" s="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="7" cs="3" s="5">
<O t="RichText">
<RichText>
<RichChar styleIndex="3">
<text>
<![CDATA[公基建]]></text>
</RichChar>
<RichChar styleIndex="11">
<text>
<![CDATA[    ]]></text>
</RichChar>
<RichChar styleIndex="6">
<text>
<![CDATA[${=if(len(d16)=0, "" , round(d16,1))}]]></text>
</RichChar>
<RichChar styleIndex="3">
<text>
<![CDATA[亿]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="4" r="7" s="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="7" cs="6" s="5">
<O t="RichText">
<RichText>
<RichChar styleIndex="3">
<text>
<![CDATA[        其他]]></text>
</RichChar>
<RichChar styleIndex="8">
<text>
<![CDATA[  ]]></text>
</RichChar>
<RichChar styleIndex="6">
<text>
<![CDATA[${=if(len(d18)=0, "",round(d18,1))}]]></text>
</RichChar>
<RichChar styleIndex="3">
<text>
<![CDATA[亿]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="1" r="8" s="9">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="8" s="10">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="8" s="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="8" s="9">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="8" s="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="9" s="9">
<O>
<![CDATA[]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="9" s="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="12" r="11">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="12" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="12" s="12">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition"/>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="2" r="12" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="12" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="12" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="12" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="12" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="12" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="12" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="12" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="12" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="12" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="12" r="12" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="13" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="13" s="12">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition"/>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="2" r="13" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="13" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="13" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="13" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="13" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="13" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="13" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="13" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="13" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="13" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="12" r="13" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="14" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="14" s="12">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition"/>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="2" r="14" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="14" s="12">
<O t="DSColumn">
<Attributes dsName="inventory" columnName="ACTUAL"/>
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[TYPE]]></CNAME>
<Compare op="6">
<O>
<![CDATA[土地整理]]></O>
</Compare>
</Condition>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="4" r="14" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="14" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="14" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="14" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="14" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="14" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="14" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="14" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="12" r="14" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="15" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="15" s="12">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition"/>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="2" r="15" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="15" s="12">
<O t="DSColumn">
<Attributes dsName="inventory" columnName="ACTUAL"/>
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[TYPE]]></CNAME>
<Compare op="6">
<O>
<![CDATA[公基建]]></O>
</Compare>
</Condition>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="4" r="15" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="15" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="15" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="15" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="15" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="15" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="15" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="15" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="12" r="15" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="16" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="16" s="12">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition"/>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="2" r="16" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="16" s="12">
<O t="DSColumn">
<Attributes dsName="inventory" columnName="ACTUAL"/>
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[TYPE]]></CNAME>
<Compare op="6">
<O>
<![CDATA[产业服务成本]]></O>
</Compare>
</Condition>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="4" r="16" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="16" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="16" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="16" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="16" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="16" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="16" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="16" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="12" r="16" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="17" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="17" s="12">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition"/>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="2" r="17" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="17" s="12">
<O t="DSColumn">
<Attributes dsName="inventory" columnName="ACTUAL"/>
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[TYPE]]></CNAME>
<Compare op="6">
<O>
<![CDATA[其他]]></O>
</Compare>
</Condition>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="4" r="17" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="17" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="17" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="17" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="17" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="17" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="17" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="17" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="12" r="17" s="12">
<PrivilegeControl/>
<Expand/>
</C>
</CellElementList>
<ReportAttrSet>
<ReportSettings headerHeight="0" footerHeight="0">
<PaperSetting/>
</ReportSettings>
</ReportAttrSet>
</FormElementCase>
<StyleList>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="2" imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="104" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="168" foreground="-16713985"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="2" textStyle="1" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="80" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="152" foreground="-16713985"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style textStyle="1" imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="152" foreground="-7448421"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style textStyle="1" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="80" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="4" textStyle="1" imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="152" foreground="-13663015"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72" foreground="-16713985"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<IM>
<![CDATA[m(@%3;d$RfMIfqhW2PLd+p8';5en/"/h"E3TL]AU5&eLmtW1d!rO+?j(.RK@hKE..]AKJl\l?:
]AX#(qN6K+V6u(5a%[c_5_g^7,N@:4m1[KmeFd\#(JIVmks95ch#@@f3Wem=J%>&\:2JE&J:.
b(?WX"6puL`MMSA!>l0HKJ$K^-p5=a:N`d2@59KNFWb,P,,3e>"ks#%ah5VB![kcd_n5G9El
tJN:#=Br8Ybp=#Q$N*eo./ATo\(%h_npf!P2`W=rmX!LLRFXP%G/akhqFSEEd$9s^>"B(f@4
ZEIHk]As<YS$2I@BdbBrOaT[mJ.4pT\4ei")NM!lfS?lG8+tI8go3^_n,#a@.Jicci.>Bn^cc
G4uANSPG0;r8&nA4P:XEp"WdV._F1M6D$E@85G@T>BR2fjq+Z>8tl7m*uKTf\Pk5;XOapF.`
re)c=V=&>a=0CF^1cN[2MgNnM[n0-m8+]An[SQPoB(iAAlh)A^Hj*qW"uZ+c5X%9%H,bN1R@5
b_r1Z6:r;n]A^=BGr[E5//Tt!%C47`#*a5.I==n0;pD4CR=.<0<NV#2.krfFZrs"tJFjKZd%V
mVR&YpU,XLs5S#:9:-4Ws=i@(/i`N9]A:EM)c`.NQrT-TXg"b4gK(QRO7ljH`s'0?C#']AOnYq
`jh69jh"TSJ>o6<YV"(3QclN]A"G'tC<5&662m`b<#P03V?9i^\FWNqquc;!uj&Yjl9hV]A:(o
gu9e!EpXp&e2GN6H4<nk6%j,pN-,SZXd's3CDV1\b*l3B-T&M!%W:`I`^5abH!;VTs%<fsQ8
-;,;kSuZ'*`^2T&[]At4\7ol0N"(OB%e1]A+r71;3jDr%U1:G:*G#aii-]AXXFCI#=r$HW<%tOZ
s;&DJ."d9n7Co=p-+f+"HOs:c'S$_ZF+CD2./.@qBQY?5*'F>,/;bZ:Jflo4;lbZMb'1_#q6
Pc%tTpaXo@j1]Aq_@W$]A,OLYU`oaH*U;t/-$NDponqPFA_*Y1P)3lkl'";TQIY9,%[F3qjU,L
,@JRl=(Yj@VH&=@@,;i$'Y"hn2aE@4:cW?f"2Y,;guP6OtEoF;:QV/ED*VoDbIi+nl4Qq>Y"
^D`$U/JH/g2r'47XXoE:(N59(KTcOjp&rdoK@W!EX9<OW$uB2^)C8[8@e4NQgj"@\9ip8U<f
s$A8enfp(9c8lZg@IC^\MNej-p/-4Wj0Xk;Ml?f0??C(c=?u-7]AuN'BYu1&A3'7bB!2;fDV;
!dZ"H5E847$Tf#J_O!Uq='du>#djGr\&(paMDc.[R&Z-+`!fC]Aa1,ZZ_!DGg*IQkJKpil3"Q
2+7;^=$HFC8VU#Go__3R]AB)$=r3\BQEEI&[HG98+B!RTfR#,P)tC$lF\O)IZOnkH0tYW<\kJ
^M.;&?O3:o6_A<f5Bb+6-&O'CZ&Zo.Eo6H&mt_2)Ku@T_iHOt^qpN-_88_G?YF$Z3FA[hk_l
eki`5S.)]AtakPWK+fj13&Q7OH9C3LcI>=E*9-)MZmk':%WY)eN<Yup(Y,!3koJim//m8,;;!
Aljc39=DbD*t:lfGZ7o%_FN/`A#"mQ5M09p&_hcNf[R&SpBV$ZYZ'=X-Dl6,(BB\Pfmps40(
QiD014IqL\aCadZJ3uS]A<IdjR"GOTdc4#lR3O0e_U1jQ6]AH!V-B:=]A9Y9a9e.5Q)\VrVsruh
:p4js2YY.`H>DMK$5R+iV2AWV#\\q*>Pd-#K.Ui#U]ANs5EE#CFI+s>*-,a]ACf'.irf%&;n4]A
#0g7'EIh*.G>ghb.P4)JjHL\"[j>iZZ4hNd10-s3Nj:D>+m?^eH[cJ!,?NethN;Qq(kpDI%I
pD"^(-N(iaOnT7"1-:d(.IooEefAe<*iljClI%P7s+=[EK-df?\W7q\La)-ac2[1,K^\/bDY
V6TM7g6?D`#!"Xf!@O-I+01BN+"Pi7d^d^K@d*h1:qE\dB.cKF%(V^R6=/`V!?X%Gr9n3.NK
Jri'3jl^L]AY]AfhtfjCQ9X\Y@s]A6g.=/`pX)2S45X3gZ]AEg?g92&V2'u2]AY5>Cg>i`-p!"J7L
d20'9(2^kb_q,R[W8$&FKsBRTMf;idN.oE8e:!n[4;?gL*H<69)H>gJuC7&"[aG24u.ef.ek
q5aKLk%o$G*8L/%H1daD@IXhB+mOBMH^\oO<`J#+NTAT[;[d:_ON"*[fFP"a2)6\q83ig[Ve
i5<<N,Z@@]A*UL(PLg3Ad$1jb`9&&t;F-3tU]AC7nW#J*gJ$Vtrnoq:maLB`l*YIu1\E(O*k`O
eY'51t>So("edRf:gJV`q"7H+X2,J?G>J@rU6&a$G%!3W/\tBja_^2a.5l?%+4K"M1COAG5&
TKs&WkOr>9\(;jLD?0Ie$9LL4*.G6f<ntZR)F\'V8:pepXfU/'NqNtd&XhdUE2Y-WJ+R$Ji;
TZI!=7L-O<`;D)aW6)th%o!85,r>).&h&.Qc($P^6Z.%g1sTeSFhs!Wn*i0ZJ[.?&d`6T6%6
D]Ad*ok,_0+)gp(9j;)X0\0VY3eGVonjcXsRW/]AF]A&fM1g8Uc<[=*>MeSuIZ%*9R]AG&7G3UmU
4E50hr+rc*q23iVnj\%Ild7b/<q.:e;d0BiAkf=-ahE:OV7q-&OL=A-BNsb'RJ;#?[nVA&e1
E%#/RY:LG:3%jj8mrLRgm[0Jn]A9/fGuLn\6N<#.nDP\jg^=B4Q#PC1@#o"Otm]A(++)@[VuFu
O?j`uW>ee5W:L,YZr:ogB@HSSQ2/c0'GYrY0B@;,i/V1QVLZF4MjAL<FkXTB<$.o>2NSGBpY
i!\nm`+fta:Sr#.laaIMKJ$`9908l7qGc>S^3'4"$)+LG1qG5SMN9*PQTMVBfK48YtWGb45*
4,pWRhlf<N1"VKu/prYe2M(C\hG,kh.R."odtP_^NK;LZ!Sf+Qm9qAR4"HHJc!EGTSdah-1-
]ATmd52\j%k5qincLrgd.D)gJTh@?9K&89<3Z>*&:Y:EZgR5l2qJBN[7%M-"_2KF78Xf2HfK9
c<RHX?$.TpDCH-g.iH0,)(NNW#m@Z8f^5*(lOVm=#@YYQR>i,bX-#2T556(]A3CJ97\c(An%N
D(`W-scf:,-I"$%9+bacQ6L7<Q)p=&Fd4R3N[2KY>PN*n:7%MSSoPc8hUtNIe9"=uPBXJE8(
LmG_%VZQeF75kN$gj&605jLpbHIgs9YFpXZtEFA+h12^BAqC<T1@j*:7-/%abms1*Zh5a:_e
Oh(Isg\Ia0H%&[d'oju4h`;pS!NlYPe[V'F<i#TWPZCQ'MElQ>i1@!`U"0k:U_4MjdiiTYMt
`RqMOG*erP8?a$_/U:8&eQpSU-iq\ukTT8i)lK8K$T4n[$\mj#=/s@-iu_cr.8)k;k#k1[Q0
ACWo>cmdirL5<'^k'<o(P(^(2RZ0hLWT;P17g3Km:?e_q;#V/t$V,YI9$9H)Hh\E0uq!F[V'
?fa<rh-fp(eFGT[V)U=Ql1!kU=::93j4Q\XN2?i)5GF%[bVo1K1Xidjo3N>Is@4gf''m5of"
\G7&jMs>Fair]A^K@3E^f+W9eb^f,T8.^fPp_c@9RV;8^D*9*aN3SOeDBibS*M&+>YtA:ros,
W\6gC@V>8pC(fXcMRJeWLSpW>6KcF_UaYCf\-VVkE(T$0>R\K8s4^#3?pYEZKHcndL2#r=!;
%T3!=e+@<!Y]AR*LBsQ/h:f2VV3bQnJf#A4%Wsj%K2@G't'mX9gg7OiHVihk>llRORFU"JUS5
X23^>kSd?jcS*L(F(KA8Y0j;6%#mO1<EpOtJ'Q)'fJo2(RC-1aF]Ap8>X-c>k20#8]Ae^#rI0F
sImG`+NXfpiN2BKE.DE`]AHP\_-\^?-dcj=dm==g<?;.aWO('<>h))LV^0^-%W&cW_m+2@OOn
mYeD1gR-PdMFIq/5H6K9c@#k:Pd3,`*u("P,/4UBprle[:c2bqXc"K+Q=?Hdtphq[`$KQSC'
_^DS(<Yo?kg)N40%#'87E:E5MdPeEqRM\mM`",'r.#hN5[F=(o#&J1CHm3>49)JM/JZ#[(d#
rh8)@m(=f;TC\ioeQFh8"7P8d2Og("NIaD%XX@bUlM12`-P&uLeY1ZM[R:gKao5rdYeEIi!*
Rd&rOP8kY'Y[Pg[Q>0HB]A.goPM^A[[ihHH+9^^4VYUD'16tA+]AjW4ocnR$YPK_"KX#q9=PD.
8$+K[+%8Fo0B=mX(jET=NVN@76[o*A,jGo!;A2&q>:&QdiPL4#5Ta'>hPFSPn#`1NaFViP1m
k`si^U.POQl1p%B>s>Z>DDtKR.deBp#A8s=X%tX6+f>g+,OOZ8OUdhYm@kgGfsKc(hD3TFX1
0&R(::8"F.P%40pK+bVjmO)YRFi]AXmK"KU]ABY*u??&;-C&Oo&F0]A.4XgEq#^=8NsuE-l2mT(
gmXd!IH78bcHIhHWp7-t82-Zm)W?n.*I8nsSVhYI(pm83@on>CrNs?%P%;"O&:7h\&^<CdRm
)"uCf'TCC^>6O"kJkkS*!Go:G>%?ECSq)SEc)@lbCe)"";l[n?RDBWZJjLh,fS2(rj,"9>S:
_@lQJmB-cJ'W!WoKpBL)`nppj,$7Nn7*"m%n6ggb#R<Wa%j!f5TC("LCog*e`TuM.jdW1RYL
C[O9cDh[&QQD`4bi3T;CS\[LY%q*QLGi7#qicp_+aY!VS3TZOb6D0L_b!^8eXc#R.=k.,]AGN
9N[sHNIcqe[0e2TnF=+>o&R4tb^\ZF7nM)2gtMpLh2]AC^kVqp.Ot&]A<<ijm"\01=W14g8Uts
&uE8)ELj\#"%s$M=6Qi<SQFESO.6OB1M)EC#aB(Kp1O:BjA>6c5hW@C=(Dg5BB&5n#\BOOS(
$Rr?E2B`bt/'rgK$Ljls>:2In7KQ9ZDje^I';epZ3#061SmB(f#Ke$KrO,b$:UPkAe!1(T1:
0EU[1N,D]A(i%??NAr.DO]A?gHm/fi^2[:)KBR*o]A+YW<17!m>383`XP*1<0j#j3-c,Ks!:)BO
@aMd8gpnOCc'V@W[6Rp!5\fj"CIm8'f>-?\:[cskA7l0fo#MCn!Q1[[dZM%FFt_GIjKaa#W[
,HJMZ7h:cata6-d1fm7gO+&[:AuY!:5B-LgDj[:aBY1Q[@BqboitV@s_YflP8dQfPDN9dXif
?Z7\3"hNrmpUa"?'&\47RCe*2`.Z4E0B=H]AiSCR@:l0)X.bE3NF4"Ya17%3ZP-DZm0+$]Al5K
+r^4nM&!IjkrlrHu^I[bs2g$GGNT,T-0!%e#GrNC7$23chnLGMbYel`f.A5W!=gm_ZmIE]AAE
0*G[EuJ&dk97e\pEj#h]Ad`I-H]AD'(+[MqYHYDA?gu<h4hiQ7ou'Z>Z[Rkr2,jf5RDeV:<X)A
^in6.ndfskl`0;<<"V*mNd7/F:MOXa#tI;5)D6ILNi>jH:LZkDG1F9;m=_(CD*OQCcGnu"MG
Qh]AaLkT.,oe!"QMi!Jn_Nb2a#LDB"$Ri@"6Nu\79_jdMRS?mSNCX4-q03$B-Ho7'YE.OK-&^
IUQ%c?jL'Io9X:\kAD[\A>NP9`Kmicepu#BX0VMJT#8G)j\d/G??a2=,q9Ej,4;/3&@f+fl[
n2Gl42C9!=;B]AK8Ga;X'tKd;K#m'2q:9$[Vj7;-t3I.Zi>l/6++/2WOfokp<f2>+VJeaI8_a
XK_%KIf^nnsr25Di-/oR3FI>TI/S@B3QB=RS3Z;:`ZKqo:@o5GDkM4rFfQd=qmMW0ORW+_Nr
^slT+<-e;1hUQqj'GJYkZj?,nspQ_UQ;!23E`MAET*Hg'E#]A8KYBtC6Z/\Ck>&E>6<D)Qe(k
_&2.]AG#r7G2(B.!4LV8g5nCD24G]A8dm)CgD6INJltHH$=O,TY.iPSF7^^[Pn*XFP)W5g!9",
3fV<\"N-:^@baSKUh7r-lOlQ`bsmo!%<pBZWQq9>)K57D-5&u51ae%$!<#)(f`s9f4!e]A5Ri
"^)FALeK^DbLRrPsq0(=r8K_:imiGl]AP6,AkbDH"$.YnJor<TesoqE1c-OOZR*EZ[96:rBJV
4/:t@SEm#h[P).mhYtE[1guYS<F3oJ^'WUK8D0:^`;U=iYDG=%_D9IDQ22rQ14WErDCp]AhE+
8BsE&NLDbq0R2/eth@\)%%&pQ014]An3:B'YuoLBi,&7L5AT"XqTNmhf>.,)`aGQE?"WdE9q1
N+m96EuQ+%nQ'c$,YS5r0,Tr"ddf-sN]AO*U*PMaO2^)k#sZ'[0]A<C7h?Q\0T>V$a>9Z]A3ZBn
.36p[g)_)@AYkj\X6f.HpE?cqF@P'MRbF]AJ[EcAo'T<)JR+pn"_-!s/HSQdF.M]A$Erj*>A_U
r3fXudK^&*9GVO2V@rS>db'b(^l5IC<"RrTm$S&J`!tPCVfJ,nj9W\`p_J[LJ9Jc[uX<o\C9
d@nX.dPZA`LHH4TC1RJP3(0GaF>qD7+HY6@43a^O%'2q"OI8$)s&u/`dXLU[-iHq@[=ISAD7
*#RJI"p?n2">KpdMcC>(rU,e>tbMaEOZ17^*luB,L7B9VWMOkZ+a%p)Fk+Ie?ESi>bVWi`op
!m\q<mm?S*Hk-<Y*FOu:*3-$#aEBR:LrM17oeE5Jg?R'h8S6Gl3nD\)\;a+9,dNPU&s6T:H%
AOqQOBus*$gP@Lm@oR@f%JMX_.kNWD:K1=sXo[;+5eU<DgHVL2&G1IK@%976g\EU/ppY1jNE
V*gjAh=:<SK<ZQ$K?3l)QpiqT,seI1.$mA+Cl6VCcG^T"iC3L2^gq(1mU18gUM1FO'tN)(5W
3Xp-VBgA:,&3`uVGZ<k=#p"/!?>J9;D?(H+Al/\o$n+tkj3MlPH`05TKM"6\U^5<&Ll@NSk;
2)HN;g*ZdGerM)r+Q`RC?`Co=ohO(m\!o=2)#Lm14K,H]AKuCQK0#h4F="\[5W!cVrM>oRM#h
m4d-#J8GJMAfRS2Rl/X^"e+eaK7n=SMM&2V<-YLWFT>PZ$\\T%qOcEsg?fPl9\Aj<3:*(aot
+&]A6k>skilKm+5B9;!090D_`iV_0(b5b9L^D*3@]AZGtgnC^=Yo(2S8^EPld&+tYW%[CU,j2F
1++)r+=qpD4o3]Al6GjY5qn**Re;+UU\f=XB3MPS:g*nB=lC?>S?fPY7;86/r\B@;VRJH*X@M
q"\ou.VdqR<$0IdU)Ktq_0EXi#jdg%Z@Mq%E-ehQE<Ddt1E-1uGh^(6/VL@VfL?7%eP-#N0\
nZS8k7T<+"#jkcE6l=79,>B:!fgc(CuOb46GD#.olTerIkX]A<T5f*h5*.q\_Nu?6>1]AKlE<Z
4`4X[0:Ymbi\76f/G@W:]Al^$J%(#pZSPLA8V\MjEe`2HdZSFA"i?1K8e2hrXcZJAN=!60e5e
_.U<fTFEe,#?TMorI?@f$Z9;jq,c!m?;r0ZUIfOb*2a392AgJp#XJo\[7p11o.(hD^@@bZ"Y
aiTI)lanE1W!n&.o&?!Pt]A(V1SNRcBt@@,59@*q&:!+#t.t__]A:g^=R_pQ"84nHgZhmmL"tH
tgCnuk"u=2U$0c0d5,M`0Cb]A[`RA[h42juBJs-K7bM-gJUZ:A+rDjh4]Aa&C1o]A%`441MKj_8
d%qQJJ(TqC5Y9#l$[#:B9*bh9)V0?OX<J'#K(jBp;o2Dgpu)6k(0iai^:PJ)5V5Z\<VVPe27
`FM4A*#gJE'76G(]A?#%UALW'#H[)E_OOqf3\=Z*[TPr^,Aa)su'@^(=KoZQ8o.864Kh<7!'P
]AZ4>tilL'qPWVH>`+0s1j;%fN+,/$^GB6`PTFG\4VTpYn@dRc27M)Bi4dD@aN[\.8PeGYpUI
l&K+#?`UB@MhbfR50@>FK8YL'qNm/8r7I=;1P2o;^tmY8&>'ML'a.Ou#%0N'(to#/c-'p@mq
c11L?E9TkZ4mlqq*]Ad8H7cBH6TTUB<V$B<p#T3&2@bm&Y0A`R%7_JNTW#9M7M*$$$0;\Esn1
j6g/Y.fmn<rm/_G1jp-!Nr[Y.!I>2?6'QCWeJ*`nYHm,eH5QU<\.V6p*n/ifmA>?VpZ>ic\>
_T=ujt,gHm@/\'pi3YJOGo,WN7p]A`OUbr2&?looWC5)t6F#<0I\G(YlST?tTVuYF=eTBr.*I
-)TaMg..r7$fA8?@Bm\@1hbQR99?V)@m)mda\V0j+-_DcQ?!Kc&SesT8o-ujV=umZUh39KBE
%SaT.bLem5UiRD0)@Dhr!s#nWf.GO[f*M.WR?J,5@1s0ZUQ77jGC`:\K'hXJi>EGak4CH^E;
c-*VKL>VE)=%RcF"4$=VcZSKKD-d3+/3Cl'u+008tW'qa/Q$I1Nq=)P)l02iUXPfMCH%Mo''
QB<u2dFg\bh2rdk62eSrap^V^q8!+WSuoe=G,R[Z/&ZGJ#uN!=:[>Y&Ss=!^AO\1+lN$D-.V
`UZ7o_W7<e9bVt:+=6=Qtm]A3d%-*H<.?XS4r/1Bi4DJo4aqER.n!,q*af+7%<2RKW;b'FO#Z
J`iP;-Te\eG=b+0Y$s_FYLpVdin4HV2foiVg'ZIq\kqE$m@ofrFuUPAXJ9M@&0:TQnKbVJM2
/<P?!?pGioQ/j^ZrPa=;k/^7WU+/@($LkG:k6+1jj,$h3gUFHG!A2.9&&u!ag\G!*9CMnR$<
#(oZ+2a7PEtGMJ!cSE#ESDNd=pVopH'2uU=.dISUSK>($8h#^HkJL#WQ3X**$OE86%.L'VL$
>8e+@AW4U&2#")X)K19K-+o3H%CcL[,oMk&O&"q$a/1e/A`4#4j^Q(TJDEd6ipm=qR#Qq7uL
9`^O:ao[.F+"ZRKq?AU16!_##ir6*L)HdCW_><is_e:";a'lV)H(cN("c9-Y#rB+t6SlJ+c#
1KAQ'qZ*4K%FUfOBnCb^;6W!tmj%2-BOq"/b5%;qkirt96_*str.,G:VtF_X&pFc&HrW0k*n
\"X`OF<W>-nIKP'CW2QXHVS;0YV@GC6uc#01jQY;AfB'f#4^?LtM!G^:pqN&>d&`\W*Jo.l9
9G%JJ_*]A]AJ<\^;)ZJQqidXu]AeIk\S)#.PrU,'3`b@G>mQN,uA)*`r6BU]Ab"G7e(T+:<RSa6]A
R&fMUqiNK!nFj0[0"[JhE^APRHa4+CY73EXcYL;C_ETI:%b8b6m=0b<5895UshuOC-#bZd20
p6hs+QEiKBciYhdq%T7>E5C7>,aqtWo7/b7!=Gdtuuq^,"@bD1&@>E(^?-]A3ENGZpMZ^Uh`V
P;A'Z7C=P>iB.7N$Il-LK8Fc^C)Yp3W-C6)N\l&2m:\3Ed"?&C8P.e!?77s7hlETkeS@I6O]A
uX7L'9G[>C?o"^cD#nNb\;s2Lt@_^*0;/N\9aYnHnK(^a!(I94]A18?2cfoEC-t=I/K0Hl#[7
RF%.N:g^]A#k*1tFs`@2C0a"H_.eYSn@bRSbF.a]Aj.?a_FfVP94IQph[\@8c/f&$$(FZ\%s!3
oYRQL$lCjMR+-fauH?ZOr__Pb<qA"-&tIT92<&&;X=Bag("bs3[0A-jgM=KZ(6)B\nHt!j40
Sqb/$D`Mo+b$4.7[#@?'$Qnsr4u#H?)Y+fG17Zs)i42"s%oTIp(FieIURpqV(sYgKB<D*Y!8
inQX>V"mUDiiN.]A?R#7T!@LJ&7r&_&=_"P2/I9r<Woa<F/IfPNjh-C.phkn)(S7GJ?*/>tUj
"oZMVYp$Z`nIH/<a+QiiGsEp7\L&L8U/Y%^V!cqH^SE4/b.,9ckX4&-?^P1hVY0BgKg`J=:2
.qYQQ;f3]A;.XaEc?Z*2$>J:G>nfN1UpEHtr'NkYtjkuei:*1b,p?@#j^&*_3[6bKHMcd"d%n
0C,OAF-(ff(5)H=Ki2KY'lW\=/uE[6fYYf]ALHg=j,33-2A96)L1jQW)lT.;7m<iRV^"'V:T)
dT]Au`Y<mhBjj!1*P`8X8oeBMrVF=e::HQOgK;)^&Q8$a$lPO)AfdT:AJ(R]A6A#VNN8RPCV\/
$"dkR+>S&mq_!<i'gpYS_s`q8V//Q+]AZXp,Hi6/(fEqgIjRMQq`uuIa8@4%D41*5"$^efRRl
SUN@gh=g&c;q!$rFinp<L[ugk)Mu9$&,b'r7MfqH]AXA576.S;=sVF3I8g.+o)Sal?D9(Kj.t
U_8EU=ZBOQK5rY^h&.`"70$[UdONqL'+=l@X[X^:9aa6*gD\tFoIC>Ttq"a_%m1BKLhBt0!7
XaK\4:Q=d`6FtI-TE'rY'($fY,8=d#ITCi\:i/M8.$H<nZ`(/$Wc5`R.sIZRj?t$:[RbK*nU
[)8r"`^4&9Xa^1kD:F6?i[cuL9D.<.T68J^.f)c?g#:#uS[CIKYG^YdK8WA/eGBTKLn,A5fU
Gb<leU-+YQ<sd,39bGaa.1S@ephN_fK'3!,%h[u:Hi,t.MKUmM\ER?J!8;=n72)F"I9;`p>3
&[@U8l$uoX;N:I&_Ch,hGXoDb4\CK3g<ShN<JS!*W9Y0"Ad^^FTBK!0^&T26Ksa2$V#1g2/X
0aulMt74lta!$X$m0Ld%b&hcCt)FE6#[M8E9LL7uUbRX.%RUiBZO"AGSJ(gKc@1/TrZ3AD7&
:VS"/X#=5:"AnhY2g&CPXb-oMZ%6b-+mDCQnc:5nOVeR+$lG%S:XDn#Og[[)V'mto2&Y&I!Q
k=)'l<9I0V7qn)DniNBSkc2/J+9W:^Pi'ES>p2lG%EJ(j'"f^7R5X?9bpa')74'[9MAkeD;q
\?^LgW.>')Nraf=n&!O,i'r?'^N=?J1jBM!rO#/IUE'I(Y-f_#UF*kZ>JOZ2'e?5=p1b\uc@
`!&9j@edqONS]A0qX7tcSN@U_l9;Z1IC;#(=gd'ZT!+?W3qRE)T%`]AhnrlZrPRuV)0FCuc9db
HGtZ9XSAe3K*abh)=&8X^<VU73+bapm1TcCXEo&9/>*P.uE\2c@WEK_<lk8'-4693p??@cdA
lg7'Nk^rD<"&XDZFn"a[;]A"pVD4BpHt0/uet]ARud8AiPf4Y/rQsZhemn\>8PCa*TC!@4X39W
F8X@]Aq*ltK*hkL_!j2\+f5OpYm+d-RZ-r/&ACU[20LdY4S20jg1$fYq_Z/CeK#r,n1cbBG:u
Tc$/.R]A0>Wb,3:4d_,iGnXs/!R2>/DB[]AY37K`7o?a9E5ZTgE/,p\`'f)(OO(p7;?FeK;uIR
aocS]A\TQQNCXZEVLkqSU`W\/-13rGXjG-f3P.)OGNIK4R=gWfUIDA7uMT<.`AD^`N30er9cm
UTZ,>s+Vfp*hnBYMfuFk5I3lo_B]A)JQ39p<?+@%SFE8GUrot\`N0KE$<o+>,VCO;[-9nJ;8$
Sp?#`Zn/u)_uWSeTMMk1PYtJ&em="N!V4+1;Kcl?kC[tda"/:\NY6-\DFY3W;+sJ:SBT4'2`
FEcqh,iqhYi>Ki8V^h]A]AD9!o2T6Z#p-7d"SOq/W3npcm.%IpAoDAYI[k<Y<<1PQ8-5/QE7gr
8c.fOll3KE2i?u<@]A,E@UYA';=((qD>_kqojcooIk?I7G;U4@GY%rVY,.;JE4;4_"<fY$fRG
i<J-RJiOaRlDPekeWCg+0(n"N[-8ec>n6kW4/\]A0@Jr:Pg`GDdh$W);ZBE\6H;DIuL^:V##O
Z!.QM:0jhA]Am'@Bgh?BYh68;f#Mr'QYBG_B'"$!L6ogj666fk[p?Ws&`LE]Ag0JF6%QCT1Bpi
2_*o3\iOcA97Sfj25+a>nc>KKMY@oDhegq4L(Q6qRo]A]A1[Ztn/EtjCi(^S\W+rYiYF^+SM&Q
]A7V>%pWUPMsDYCqTde5_G-SD_26-LZL4r;OK-q/g:S1>pe+4%.Pn>Ecu&_`:F:DWasEOd<3I
<2[DYc]Arb/1]Aa,iC9-MZYfNT!ptYZpV`sg4Up6bsABtL6.kUOsC9`uDT3W;,;:3leJV^t_W2
&Ced-JQ+,\Xk\gQ>&_"->22=>_o&ng&=+[.gWD!-Ld6nmniu$Li#_.WqEgSU3#C$sti\BB/a
LZ>'m3[]A(VUM"Lh_7%e;fF=or8e5oF*o55\PGb!Dkr]A[k"2n3ea@!gF$>T3acs!hEj2_kO1P
K+i=*kA_F_qG^,G=sl0;(<P]A3M6.GWnunAT%'fR7ED=cq@nl<mj2lFf4P#Y]A=P?2X+]AIa'_'
-3@(YfW@5gfs!s`n&#()&_<4t=H;6aIIBo>*k$:K6]A;@;mnWJ2`lQ>:Rc6),"&rBZ&PbubDk
dQ:@b.CC:>.R/,K4*IYaY5d\BDe[>L$580OJ$)gMKn;F!_[9t&aP=`lPo@8no^]AUZ5`iFPUN
NikRQP-H!Hea#ogHQ;Z)REsX=eikQl?,6U"3.5J(;WPX[`Jk*olMY>7_A/@*W(r\7c_8LNjp
/[Hboh23f@Yqh`RMPo.A:FY9aSi/g!D#O#/G'a%=oP+7.;1'ie6C0JgVQ<]AT<Ph#(q`+_dCK
0%HT-pHf/a[)'Lf!6`CXrm"LRPhXH+0<Nmhg#Z[Gu4u#raM/>MoK_qb;b\>!Pk*UJg-K/S#+
-;fTVo'1N]A);^dJ7^2Y9#-:cEp?)*$bJ9;RYA!_3jomjDG$2u*"=r.]AoM;@t9Z6fQ@7I$QWE
:AS!n1>X34Fk`R6Vp<p^<aCCl()dqrm%]AYXK[kf21(0;;"Z46+'.MLcT[%C;MDtdd]A.IF>_0
oEr2s$6)?h#Ks?M7CO]A<2GY(8Jm]A45CPubX,_[(FTBSJ#/$Cr6A#L>3CIeV0'JPWr`3K,Qtn
e#$u*u<)0HeSAQ/?hU?#G;iU]AFPs\j*0_kiZ0$kFC)C^qh`$`q9E`giC#f(nL'-@V>3G?rG0
XeR"5L59gl;o9jF+r+G12Bbp2j<>(NgYjVI=VY@H!EA"nFRG9(#8hfHa`ZGj[Ja\kB&S*.a-
tOk=u]AsJ*68m.3)ZZo?i3[ATd7=#9bFY/q/C`UTW4Aj<64a@:?s-'6(Ch">(K@kHeIp%oe+n
Rsn%$n*hI,iSbnK.;B[.2bmN<n+,BR]Aj%PnN5?]AqH>U=1qLn!m6.?$&-3iR1mjeQ&:PKk3Cn
kO]A!BWE*R%@+BSc;Pa]At*)Rm*uB?o[N0*=1@F(@8E&]Al-sL$O#d0u3M[?t#6eo*DrLm?r(!o
;T.ZV#:JYigY7p:3,j8kW_J_K3<Lh33J=NN/&Ck0Zqlu5&3n0C:kasg(p#kS'NVpVdL<dU%<
dBmLcg8ZOpLbDc7K?hf<ohopTqu:G"*<g*,Jk0g=@FBFrG0`>Ms)bc5:V3L^Q/-S<<Ne3r75
1\3IUcWNAl$ko5+=0,k(!So]AQg5MIX7u1ZBC0I=<,_\iruN)ohKrb,:.8rFjktpar!n2I27U
AdK*/I3q`@rTRHaPVN1IebD0_`cKX80P!HmDWYT#W^[n7;(>h%1p6l=b+2SF,Ncd_$&r!#"/
E]A+,]A1PBCFT3,"Ykf5;d%]A3B2L\7n]AG,8>#YPFS7]Aq7oao'm]A:u+s.sH<YIukAV@-^C"j:B%
p&^H;k=G!ObMi'^DE\>]A`VrMW!"+/0@K-lVr>SO)%cHdQG*Z!qU0Qa:GC!ZGRT:KQ'bO([+#
^A-o+Qa0">1!IC.2HqaWNK?6EY=q)[#:u.dR.tFJHDYlDR^!gU$]A&fMk3Z\\/V1DpGo2o'Oh
EA?UouQ<iCO,F<%%]A*0TR/pB=?:%M7[q`0g5fE7ssHnr.p2o$Da)b&(r$jV,%b'WdsA`)UQ(
e]AaX2Gn@u)oP1U$M\@YdWCD?Gn;0?G*3_8om_r_CnlcSpZLP9a("oiA$h8QQ3'k/0hZqoB@.
nE+>#``CN('Ku]A6#&,A9np(@<&R(jnf)A*nUf'<lKe^4:i#nLJA#]A+?7"19H&<)P7cZ]Ab-7a
i3_XRA06fu#TQ!s#fg>u[8D(l!^@FNqXf(,fAu$ITbZH,ZNWs,^57SecE%A(BIm,R#DWU:M$
U)ejJi\T_TjWSPO7dc+e&%ng>@.c3r.=6oWD0TC5d[l>WpTKVh*lp`pLebX)UGVhEuZ4"BZW
RW:?UC;>B(qd4&s6oW8pddB-Vn#@Nf^nZ99)HDeMNAII!1$CUe.-"in;Y&4RgE.1hb@cC'A]A
-)]A9D"'sgboBLpPr(#h5]Aoh8KmG!0\Wr%J@XC=9"g3Q*=4;cn29I2RNR*<JH"t#5l!r@i:WD
^\ijgi.^rTCmXo1S\WqFBI^P"0&8A"9h4/)?,SDN5lJS4lcmfQ=0E/T+afR(u]AOc2\qek(+)
Im9/B1aZtSdH9MYV<gqGE7e;Wp?NR:;!l95o/NL,8?fc)T=D/jd(nbdjaJ(nsF%*c4>dLHMX
#JIqHe>la5j@IK_1sfU((D#3K]AgaW@tR6P#HTW.p/aa`SGOGT'R7YZ:lf(,n9hg6;%lQ#?1.
g0+\:*+E&m[7/%7eo*ft%RYK]A`a#@RU=e4iXkTO0aOgde-SZri]A?Bg0eGU"s8nlW<70Z]AL3f
=mC1sW:&RTV\&2XK)B"A3g'P]A7tkFVT"T#pbps*B(a&NJ(LF70m%JPIg7d'pqK(ELf1s,h''
9L#g6%JXVY`=g'U0l85]Al;?^,j^'e;*:%.kWP]A<-p$d7L/DEX=Be"km%]Aur4GolU:JVY2D)5
NgXGn0D!rlu9a_Z:K$>Z60Alo^(3&W'$l+dI(5[?&-^Rf,HJ1,una:Td2ObFTA<'_OOVl&Z<
3rgW>.IY^gl3Lt3H2K;jp@%nWU41S7b)o%'7A%2aO+!9,'[ltgJP2Rc2;u(9Q.73BcnZ+$-i
jT)KQ#`db4Q-V;p@fg;I9%nA#pTq_Kmr^(#0b&aXpkQV$9UP(+CYFG,2\@ru3i68(A#;oBrA
ePu>RXUZmaNJFkoWJ"e0jj7ZHaT5q,iF3/[,gqWq,6N0[OCm8gkMl*+T/!!nB@=;p]A8W$(RC
*3]A(!;b5cJbuMG%1f<,`ImCfm,fDDQDQN["cnCau5V9VNb^c<a_'`CFGWHIH7FRmB1luD>[R
AIeM249$448[[2&>)#.UXI/TVs2QGMM66?h1>.@mOHGS;CW^uj4WTT?c$\6sc'e/!T+;;C-+
t'9r:2)""B?&]A5[s8J3WO0%u+oXYG)'="=o"1h2&!3&Ji<i?aP:4oGTSA'X");(OU,(='c%Y
+gh1]AV"pG>BMJ=(j@@L<5E"a[?b+L^mB+2^)H/Q_Ofb1QiW(.#"haKN:1&8`BgC?!8;`^VMK
>0,R^7hE\tdh$/6@nUIS/<KTB5O)?/0lk8u@6iT<s03!mL86'pKJUmNJg7eYH%-YJQe#QW.$
d;`eOcDXI"b=7*uY-L,IdYl%u?;Y#95Cd4n%+&]Ao=-2GV)g-68M.VNr;Z0).o6:H;3#h_WNo
#s1Of\&JQ-hTI6_lg$7?_XCC)iFKOgRq(;c:h>Cd,V[F"IB>o[`T*gFap)F!:"^(J5^k_S!8
nX1la4\=2m=;EiOWT/]A(A#iaUb]As/%9\:r+Yhh4(B/;L/+,b'k@V3MQ\En-2HPU1e,ci4=Uo
?;ZV*eV+i&7/lL"^BVkB3&'H=0\d7ORgAPt?Hf03Z?""lfT3Tb>ZR)R24<T_hc5[\Esn"NP9
@CG*]AYq#qD^\kcmULb*g'0^[']Aq(Z2RVPu_;$2gf6B2K.V,MH+B3.GkJmtUJR.U1@J&Q:?fY
oN%V4T9,HXCNn98TRs!AWOTiqGfN?_<nNWc.qC&hskE^,hAQo=lbI;4g$K"P67F8<9K%AbNL
fN`t]AWkI-o`N-L",'=/Pk6J0c*2ORWj%dLgq8D*e5'$02S9fC=nBMSM%F3a#R\^k4(!(Sp)e
LZSVL#NiKDSi>m<]AcEH1\W4lMMqL?+[-<X/$?KkC!3H,FLBeD&VPkELTc/G#@n?P11Md+mZg
W0Yle%HeEaOEIuTKm)ud;<_hU'?0ff(X)T$Vh0=_ju#il2?$5s_kiQrSu`jrkEKdqW^^*Rs_
o^BnPBkI6'G>M>fHl]A1_I+;Ha-_;tq1&\CrBaDajA"foQc6.4M3#F4(`"''f.#15<DfNXg[e
!I6)'%!Q1,jUF>ni`5@IUT/oXFJi=q[Pf\:L3g1dhrufKFblL+HM?;bd(Cb3#KL$hRap+Weu
6rpr4L31#t_RGT)]A?Tn<^:WrmVH1m8QB[<C>.%C+H*gpQ^5<0#*K'M_WCLTBL&!^L:L3\H1q
<Eh'n;6,-^?+t)F&u;%U.72n\#9qndH7l=W72J1c6L71rba&88O2et_$)J]A_%V'L."!pYnCr
>o*;R>8rajZo&Jqm9pOfr!kijB-=$ge&iJ@SUd<rJ#!2d%>V(@91C2&aA68RN&)A)[f'Fj@h
O9cH,E4)kY&U_,XgsnIckZe33lOJQO0D-L>,L8Ek(<h+a,G4\l$qWF*-%phC^d]AlkmZ:.Rh!
/IPrm=p;MG!,'$/*?^n!Y)TT"tZ%mLai0KJ`u#"6%(*-h`i\iINSbC\k0f7X\]AmY2.Y_2#(/
mf0G1Xae)<WSQ"UTdCh2ueTnUZ+gY;SF5CGZi6`7R@WT.HKMB=b0fUgu\D",u?(<msBN9"87
<2[peODVYH7b;cVX!Gs^uY2_O#cdq,'bu.2$ASdp"WFh:c!dlM(h;tKfSt.0@,OR+d&ULn3e
kq`j*[k(<nIphcR$Dn%QC41LL*<!rZbae4jgL<bi9P@tK;N,qobjLDFO/-C`K"Iqd.DNqEXi
q=`J+S.iJ7d8G);>%CN6]A';%o@:gegV#EXI3;IdrgfXGYW2nFThG=.qoBPH\R#U+<LX]Al*!l
Mb3U:/EI]A-YWO0Wl`-22`pc@f7.__r<'+Dn$1r-&g.BJ&?a5g5tEK.6Xe:aNI]A&q8KlqL`$`
S^\3%nI6;,u@ck$1@8AsEJsFpc\*AdjmLe@5)bTT=+P0jCTB@3j5X!5E>mfe`Jci1I]Aq@.D?
s5m!6\^+g5=@'9?29OC>tkE\45eu3!rR^faE;0S@qe5(jS[XtA-st;dr=qX4DlX)!9uau1^<
!ND21_#o5"?fp?UEhW)qVa]A-c2Bc>Hs"#BVW6eCY.<<^#_%HeK<Q`mT58c[l(tgkLuY00e#j
fV1U'=_VD8nN@*://Db0:@V(4qq$lk,]A5/PC\N>MRL7oF(2d^l<oBI\Ko(1@nV>oQ;PYnCB*
l>6;_^1gke^IOF(F7(I?G^+^6F_f8WdE7/eDrnX)aIDedG9*s#*&e[i2.52*kCeKP9-Xo:gD
c4aEfFYkn=jS'?ainUB#*#al"i(??k1<BGN>);I^K?hQ&lM<#<k?E/?/H1JLRARY*%d3;rMJ
^_51GVBM9r1`a9KY-d*AOTj=^S`crBndr*mYG.Efm2'>p-HS2$2W5XfU,_[p>e,\*h)9E!EJ
5'KDnhZ'\Ln&+*Q$QV*qiK*]Al3Z6;CDo?25]A7Z[W@/@3(Mu(37Q8aef/<faT[p9g7p^a+g9t
'<%YmK'o^]A2]A3PmI<X_;.&nPd?&F^)c?P[.I/Za+Kft/L5YPQ_nA=W7/tVf944l2PQa'u>G;
i/;CSufe]A&]A2LMS1A_[h)X'r5j^.pn$+]A9H[E#@qGd"^[_]A,f8ZV53NR:Kj_NG$rC72U4fi1
[FV*Lo6/3[2=MdaLI&g&R:6fX.mUVW?-:$WPW(4iU/\&6no5U3bY9eR%d\CQ,e,I"?SWFV1q
gO:--j9SdJXf9E*I?AU^hb?[q%BF55h),'@Z<1Z"-meR^:SCf6qB`0,1OU"pgTIWmu\lE22Q
gEW?&A"g6R1Y6)RNj(ou#Z\J\5rh#[q*[B<e<<uD&]AC'BITPP5@-WeBa7Yt.2)O";g;i;_a]A
;@smiW8^mafV9!Yr/0s_?6FRq45>bp(0q;f>ZO9)<9,<_AFN2rs$\;&r8arHYoka,4T6-VFF
U-G3#8=[:$h%AEk:rs`1sX,&[DaaZmIW=$<1X]ADC+YI0KfHIJ!E%Rp:0&U2P]A-p%;MmHF9V*
J2nbKM^_,b"lR)B&F'%An#VJ^4YuT&K2o,i@r=?INR7#b)F3kglQL@pl-A-8p)A@@4o(9Dnm
J^JYEt0.B=aDD\loC9!"UHp<'8(&[>j>kpE6:P^W:K!:%h4.7lW1aE?1Wsl4d"ZcgI^dVlKE
7e"^VXi+)6_tE+<D?ibIm.nu/gGcVu_b/4cstgP0fAk9QU$\S,4HNbfla\?a'_$$uC@<7se%
JuWg.bF:3*b/q1?'*,>821$C7m`I(uL6uqu4qK:@>i:r%0g6=Q%;$+lF4(Il,'K\YXhA0kIh
GUcfti/0[b"D_=Q4WQ$e)4i]AHCKa`%bSLl$0WFP<[!^Z51Yr"c=J*Bt_7'HiGB`\)c/tGsYg
0j]AReX+Va@5/)Ho2CK^U8q9P]AX?L-$o*lbDtd?@-ajRtY!`;J$P[;+LNY@!E]AIRRhR45OPUN
J,WCRYfZ6+.^]A!BN$5P=UF[!5Z_^.oR;[)4VLR4#SA7SI&AjHGIg1OhoaQe1Jsbr;[Vo*2M#
E7jm#<8nETAJSPsFRZ!:f]A<-\e\ULq+,DF)p3o'^)tI"@aDq5U<bk9aZF5I(BcaKM+fc<Ylr
)j#:b'k<N$X0FW1hGEH\1)F8QHtY,*rQo(,("b'L'VGBKNYW^=X?!4cm?&&,'L]Ag>bcOF5[a
HqKrB[N?pb*(MW'V0V5Q]A7r&?I\%qYOns,k!=ujNO"gFJs_TmY5hJ#Kd5oZ^2,D:U(Q2Ws*S
BlV.G(Hlr$mF`,ZF6.X$"ht[@HG:;\![ZVn@hNPbL,aW3R8!!:(n9k+%5!N`P2e`gkYd%u05
Bus4N)iF4?>Y=D#6aR9C-cJM^qmrU6H;ujd"(F)7SNl`g%)]Aeo>/0m(3n;)W?aasYkMm^Hu?
6AB"-_\8+'FNT;,DoHkc(j2eDl?WJ%q!Arg;@DF(/=mpbU$M&sO<<#2bkZI;`BgN9lQLLnhf
9?s:2:k9o[%0k%IKFdPmR@8-=OG)T%1k,.6p]A&UEU^b''MOOWEP+;#SF4YDL)R#C;<UAT5;n
9J=)R1j_&PduHb'ST_9N]AZ(["!AOiru^s$Z5W-aJ?e$5OO9@!!hE8s.(1UA^R>LcsJ7.M^Q5
46EFmlAres16j]Ag553gj=leo@DW\R5H$tJKY3E]AQ>5d(!=4R1_mGO&%]AV5l')@c++Mn+DN5n
R7gN3.XH=&4s*"[[Dp6E7K6)[R=+4-hF.8i5I^_rliZ,-o&dkD@83Ropf0'60FeY7bU3)\Z#
/,Zj+b2"a$CnBNl>_HqBj8pG&o@V'^BkKe;o`84D-/cU"'*3IBp2JpY21pWccUg04nKQ.sH(
g4Ig5aR21):QApEOp#t6qg:2<f,@Tok@g[?Ks<kUrGG@"b6)LQ%BW^b"gmD-FX?H^+9n$n(C
LbB0UK;1ST$_"nNSUS\)3.A4C&cH\=P)PW\V_6OM1-cD"IKFI.5ir.:\Y@ji1isrfu@_h\RY
WrU('Js4f!.s8.3Aqd9(Ckpn`Wd`kn00.VN56&E9n?qHhlr_[cK"RQ-FNou\ABOu<e0N!DE^
UnNZn+,anCS\jkRptt#VS$#nj-tN^5ZfT^_RoR2.V-FEq`P`IqNejbKYNNln?5,U%=`I@6"G
7*!W'\9#u&&`kl,]AK5p;^@o>?b,[ZJ&dNB]AO/iSc&trT3p_(!]Ah,k?^4JEB(e\#JbQ`,7!7Q
EMJMt7e/b`4l1l:[JksE2^mCaf%g44?maml"$^tDdN'#,2d50gip@LLAp\#iU$TB\K>To5iS
bSQY2]AfoX#'u10)L:ZC"du:FoHAfFZf/f46XZKn')r5VAE`.HiEKPqa1Pc`biK:5Oe!_FFBn
3i]AKAOh=h$%L3qU&q!M)Y^J;?Wr9bDUs"_#T>PN^7(DhQFXNHk/*ki<dGNIDXrQAWQS5V+Na
b79]A)u^\:'j/^t5K',g/%X@d5BNhkJQr#h,<@#e2AsSW+0;hqFUDNFq:iPG_]AAC9#>VBr!ZX
\mmbu2RqjUWX<:S!;4&DU.E-f%X%h\YV!q3>/D8O3n1I$-@o+hHE!m-!k(W8CbHo(?sbAlW5
h*:DVe/.1%h)N=bV>YX>B3mXtIj,aG;cpmYYAIA0q#^q=0?q.F`p^Z&(E_40HXD^>48M^d+Q
bmTKF=4D,(AXt(Xg:.,O%060T]AfB_[D.EGXZC;ls$!;HSh]AHGPL'/6[@Y;EJ9ZUUHoJ\VZU_
E8NUT;B:!)B]A7#=To$J^No#05qXHsM2oW%b,D/"V7\'<f(r'>**0k'<S"oB;*V9q.O\=iG),
QI-iL44q^Y'sVNH%7QX6F3ttJDN@"du5M":m<1%de"f#W3!Q2"4;1l:)bhO+A2HUmUart9aj
1%VHg&-q\ZgU&2<:?34Rn+,DG?H'7k2\T>X$#5@T/i/*q)J:J/SU&*ksf7K_5JH73F=\>P7d
_YT.b4""J,G%TXAG;KKEUBUe#@7$'7LXX4*o]A2TL.EH6hQ7:dDB;<]Ak#6o9-<mJDiH3#I.V#
+fDRRpe=.K2THU5q5VEa&4%7`o-X4e'TXkuOq_O:j+%S=YP3@IBHF,cjg#ql,-2#C]A%8&07L
I$rWrMM(U,O_Ra*f,M6r""*D'!)F'jnoH_'L+VfcaDDL>h^-_$*[(<E2Sq2ZPYhj##l!WfO;
#?".2%S'("!'5iQ)>dRKruj?<'I'k%fGnkk9%=@d>]A@<ZKSnU:4LFHRfrMu>0RdOr$eY\WH1
kjLH*CZXN6<e5@3g6MR]ANk_ofUrGPNIV)@+"h(,UGJM@eRNJQd`nRJl8]A"X-6uSnb-%gaIj`
"*I3QW2s]A>@iS=[Mm@-)OT/jYhNa@9-`D#\jR21,2H^>c[f#Ur(%.XJ8h<LATrU.P)'^'5P3
jF\OJ>-;(JY25^/E7^/6VH44McEam[*^>8V6CZeF_=Ed!isiJ/iW-.&TiZn_R\?M$#X?^YE-
EWr$+++_2\BNP`H?,Frk7idohkhk"DE"IFNa/-Y@bZ\D!YVC*m@M!@dUq%r1ZMTe/H8+D%9^
Qq\;Vs[JhO+j2E&Cqol?n9bf_&to8q3:9eL+orPjr<RqI]AXnTI^'`J,+Xhrj"@>a!5i,O]AHE
QrGR@SPcDiUDE9ZE42EJ!#Xco#r$+3n".?dDrgq@07KhOk#ba.j=<sl?UhM;nq:epq1M-\.5
\7[<,EVbCp4J.U;jVWoIf#A8_m]A<0(%@L'DYqAM^FEII1dKfJD(aYCt]ACmDiV1$eQ"<b0_/B
Wu1f6q/[%Y2Os)qb+u#Z>Le-R;7FruoJ`*'r`)dUM;;,D&%c6FcIBoJ[]AD>^M3jPGGOE!]Ap1
[=@4KI5Rtt6IY@r6$FS3&oHF.h)7/#BLp895"p`d7Y.o&X&6UepU]A8P\kD?IBZ9sZhq\/+[V
ac%fQOH?+^Nj"E!`s%15cjJ+AqZ`CBjU8!geN#:R`QQ?cSiHF+U%&s)N,FoKX5qkD$r>T"-%
sE:8[o#?,3P[pRb`B.G,ZOGDQ(,Z+#l[^K@$e76YPFeI[=sM-DC++m(ahZcfT\E4sCYB(<K"
AA_!)Y-1m/m<k"PJRs8/447nj.3f.tAj*?+7ET5)idXq&jG0rLfaT5?ZalSnp?b#iTB_sOp%
+*ig@0G!Q6f:)1rgP#9h4=AFFf^P54=J3[\UqGqfDLOM;"Jm_fn7]A&*+lTXmk_L3%8e!\HhY
H;%9,L3Pqfpa&aDYc_BmA")G:Y_YN(,l4/(qA,0W\*Eqs`"">bqe>^:_A'*3XipP[Ca1u!tO
OPB.eQKFIG.'8jeQp>T5f+g*r4us&d2%dWQ`3q-XsJb2cIE(?F=6jQ#H[llUAZ,[/&#NTfYb
sYlb#]A?oB[jcaU^VI^qCV80s?\qE/2$(l%d6A*(=V+YR:A<c'88FW`CZ1,2fl+fa.@7l5[J1
kH^AiYE\N>Ha&GLTRQXSa0E\H^L<1s#M=(0"jd%[W2l5Q%BptWs$nI\XG5e_JmR72mkR43h$
@4J/KbOJq5D,#U*+0!O]A_;X#PmH?#atmD%D.Ac\?1r'cr9n1H04ni+3WdG5c33.0#nWQ9!s@
;(Mt;HHI;7lGogY\FTY+0WaF:]AOaC;+E2O@!EpDQ7Z9K4OH_7nJhkUiAMUXiHat30tK@,D'4
MR8sJk?"+2V2[coDl'B2jet=`::l[e<I"$C$!Mpr8Esf^Wp<emUOj5oh4*'ht4jrVgdD+J`$
BE($*[?g)Ka&=?B`'HG=g_hKqJ5IOhYi[JUBu@jn!FK[?nslRtVp)qYWE%KA?Vmfl9[H?87I
p]A$eJGCL]A0CEKsu$3,i`>(+-V\&1mA3jlaKZc9.+Dm(Fp;%<>$U,R$"687<:dIBoG1$jQ<Jr
g>]A-Kk^<Rlmir^B:)6[(uQZXNm_.`7\S^nbKV]AAcI[\2DP4P@S,p>G>=b(GKC#"[&'A`DX?U
8Ep,:^@%X>Z&:ZFZ[f&o^/!e7`PA^E71<!Q)diFVk:XrTbg)#c24WeFb@blcKm,>`=lm%S^,
UOD7L7g5tD=H:WqY^/=p='=_$:R-.2)5/_VlQH53i@WX!!~
]]></IM>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="250" height="150"/>
</Widget>
<body class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="report3"/>
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
<FormElementCase>
<ReportPageAttr>
<HR/>
<FR/>
<HC/>
<FC/>
</ReportPageAttr>
<ColumnPrivilegeControl/>
<RowPrivilegeControl/>
<RowHeight defaultValue="723900">
<![CDATA[723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" cs="4" rs="15">
<O t="CC">
<LayoutAttr selectedIndex="0"/>
<ChangeAttr enable="false" changeType="button" timeInterval="5" buttonColor="-8421505" carouselColor="-8421505" showArrow="true">
<TextAttr>
<Attr alignText="0"/>
</TextAttr>
</ChangeAttr>
<Chart name="默认" chartClass="com.fr.plugin.chart.vanchart.VanChart">
<Chart class="com.fr.plugin.chart.vanchart.VanChart">
<GI>
<AttrBackground>
<Background name="NullBackground"/>
<Attr shadow="false"/>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
<newColor borderColor="-1118482"/>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<ChartAttr isJSDraw="true" isStyleGlobal="false"/>
<Title4VanChart>
<Title>
<GI>
<AttrBackground>
<Background name="NullBackground"/>
<Attr shadow="false"/>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
<newColor borderColor="-6908266"/>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<O>
<![CDATA[新建图表标题]]></O>
<TextAttr>
<Attr alignText="0">
<FRFont name="Microsoft YaHei" style="0" size="128" foreground="-13421773"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<Attr4VanChart useHtml="false" floating="false" x="0.0" y="0.0" limitSize="false" maxHeight="15.0"/>
</Title4VanChart>
<Plot class="com.fr.plugin.chart.column.VanChartColumnPlot">
<VanChartPlotVersion version="20170715"/>
<GI>
<AttrBackground>
<Background name="NullBackground"/>
<Attr shadow="false"/>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
<newColor/>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<Attr isNullValueBreak="true" autoRefreshPerSecond="6" seriesDragEnable="false" plotStyle="4" combinedSize="50.0"/>
<newHotTooltipStyle>
<AttrContents>
<Attr showLine="false" position="1" isWhiteBackground="true" isShowMutiSeries="false" seriesLabel="${VALUE}"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#.##]]></Format>
<PercentFormat>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0.##%]]></Format>
</PercentFormat>
</AttrContents>
</newHotTooltipStyle>
<ConditionCollection>
<DefaultAttr class="com.fr.chart.chartglyph.ConditionAttr">
<ConditionAttr name="">
<AttrList>
<Attr class="com.fr.plugin.chart.base.AttrTooltip">
<AttrTooltip>
<Attr enable="true" duration="4" followMouse="false" showMutiSeries="false" isCustom="false"/>
<TextAttr>
<Attr alignText="0"/>
</TextAttr>
<AttrToolTipContent>
<Attr isCommon="true"/>
<value class="com.fr.plugin.chart.base.format.AttrTooltipValueFormat">
<AttrTooltipValueFormat>
<Attr enable="true"/>
</AttrTooltipValueFormat>
</value>
<percent class="com.fr.plugin.chart.base.format.AttrTooltipPercentFormat">
<AttrTooltipPercentFormat>
<Attr enable="false"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#.##%]]></Format>
</AttrTooltipPercentFormat>
</percent>
<category class="com.fr.plugin.chart.base.format.AttrTooltipCategoryFormat">
<AttrToolTipCategoryFormat>
<Attr enable="true"/>
</AttrToolTipCategoryFormat>
</category>
<series class="com.fr.plugin.chart.base.format.AttrTooltipSeriesFormat">
<AttrTooltipSeriesFormat>
<Attr enable="true"/>
</AttrTooltipSeriesFormat>
</series>
<changedPercent class="com.fr.plugin.chart.base.format.AttrTooltipChangedPercentFormat">
<AttrTooltipChangedPercentFormat>
<Attr enable="false"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#.##%]]></Format>
</AttrTooltipChangedPercentFormat>
</changedPercent>
<changedValue class="com.fr.plugin.chart.base.format.AttrTooltipChangedValueFormat">
<AttrTooltipChangedValueFormat>
<Attr enable="false"/>
</AttrTooltipChangedValueFormat>
</changedValue>
<HtmlLabel customText="" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
</AttrToolTipContent>
<GI>
<AttrBackground>
<Background name="ColorBackground" color="-16777216"/>
<Attr shadow="true"/>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="2"/>
<newColor borderColor="-16777216"/>
</AttrBorder>
<AttrAlpha>
<Attr alpha="0.5"/>
</AttrAlpha>
</GI>
</AttrTooltip>
</Attr>
<Attr class="com.fr.chart.base.AttrBorder">
<AttrBorder>
<Attr lineStyle="1" isRoundBorder="false" roundRadius="0"/>
<newColor borderColor="-1"/>
</AttrBorder>
</Attr>
</AttrList>
</ConditionAttr>
</DefaultAttr>
</ConditionCollection>
<Legend4VanChart>
<Legend>
<GI>
<AttrBackground>
<Background name="NullBackground"/>
<Attr shadow="false"/>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
<newColor borderColor="-3355444"/>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<Attr position="4" visible="true"/>
<FRFont name="Microsoft YaHei" style="0" size="88" foreground="-10066330"/>
</Legend>
<Attr4VanChart floating="false" x="0.0" y="0.0" limitSize="false" maxHeight="15.0" isHighlight="true"/>
</Legend4VanChart>
<DataSheet>
<GI>
<AttrBackground>
<Background name="NullBackground"/>
<Attr shadow="false"/>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="1" isRoundBorder="false" roundRadius="0"/>
<newColor borderColor="-16777216"/>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<Attr isVisible="false"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#.##]]></Format>
</DataSheet>
<DataProcessor class="com.fr.base.chart.chartdata.model.NormalDataModel"/>
<newPlotFillStyle>
<AttrFillStyle>
<AFStyle colorStyle="1"/>
<FillStyleName fillStyleName="新特性"/>
<isCustomFillStyle isCustomFillStyle="false"/>
<ColorList>
<OColor colvalue="-10243346"/>
<OColor colvalue="-8988015"/>
<OColor colvalue="-472193"/>
<OColor colvalue="-486008"/>
<OColor colvalue="-8595761"/>
<OColor colvalue="-7236949"/>
<OColor colvalue="-8873759"/>
<OColor colvalue="-1071514"/>
<OColor colvalue="-1188474"/>
<OColor colvalue="-6715442"/>
<OColor colvalue="-10243346"/>
<OColor colvalue="-8988015"/>
<OColor colvalue="-472193"/>
<OColor colvalue="-486008"/>
<OColor colvalue="-8595761"/>
<OColor colvalue="-7236949"/>
<OColor colvalue="-8873759"/>
<OColor colvalue="-1071514"/>
<OColor colvalue="-1188474"/>
<OColor colvalue="-6715442"/>
<OColor colvalue="-10243346"/>
<OColor colvalue="-8988015"/>
<OColor colvalue="-472193"/>
<OColor colvalue="-486008"/>
<OColor colvalue="-8595761"/>
<OColor colvalue="-7236949"/>
<OColor colvalue="-8873759"/>
<OColor colvalue="-1071514"/>
<OColor colvalue="-1188474"/>
<OColor colvalue="-6715442"/>
<OColor colvalue="-10243346"/>
<OColor colvalue="-8988015"/>
</ColorList>
</AttrFillStyle>
</newPlotFillStyle>
<VanChartPlotAttr isAxisRotation="false" categoryNum="1"/>
<VanChartRectanglePlotAttr vanChartPlotType="normal" isDefaultIntervalBackground="true"/>
<XAxisList>
<VanChartAxis class="com.fr.plugin.chart.attr.axis.VanChartValueAxis">
<Title>
<GI>
<AttrBackground>
<Background name="NullBackground"/>
<Attr shadow="false"/>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
<newColor borderColor="-16777216"/>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<O>
<![CDATA[]]></O>
<TextAttr>
<Attr alignText="0">
<FRFont name="verdana" style="0" size="88" foreground="-10066330"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="true"/>
<AxisLineStyle AxisStyle="0" MainGridStyle="1"/>
<newLineColor mainGridColor="-3881788" lineColor="-5197648"/>
<AxisPosition value="3"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="verdana" style="0" size="88" foreground="-10066330"/>
</Attr>
</TextAttr>
<AxisLabelCount value="=1"/>
<AxisRange/>
<AxisUnit201106 isCustomMainUnit="false" isCustomSecUnit="false" mainUnit="=0" secUnit="=0"/>
<ZoomAxisAttr isZoom="false"/>
<axisReversed axisReversed="false"/>
<VanChartAxisAttr mainTickLine="0" secTickLine="0" axisName="X轴" titleUseHtml="false" autoLabelGap="true" limitSize="false" maxHeight="15.0" commonValueFormat="true" isRotation="false"/>
<HtmlLabel customText="function(){ return this; }" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
<alertList/>
<customBackgroundList/>
<VanChartValueAxisAttr isLog="false" valueStyle="false" baseLog="=10"/>
<ds>
<RadarYAxisTableDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<attr/>
</RadarYAxisTableDefinition>
</ds>
</VanChartAxis>
</XAxisList>
<YAxisList>
<VanChartAxis class="com.fr.plugin.chart.attr.axis.VanChartAxis">
<Title>
<GI>
<AttrBackground>
<Background name="NullBackground"/>
<Attr shadow="false"/>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
<newColor borderColor="-16777216"/>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<O>
<![CDATA[]]></O>
<TextAttr>
<Attr rotation="-90" alignText="0">
<FRFont name="verdana" style="0" size="88" foreground="-10066330"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="true"/>
<AxisLineStyle AxisStyle="1" MainGridStyle="1"/>
<newLineColor lineColor="-5197648"/>
<AxisPosition value="2"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="verdana" style="0" size="88" foreground="-10066330"/>
</Attr>
</TextAttr>
<AxisLabelCount value="=1"/>
<AxisRange/>
<AxisUnit201106 isCustomMainUnit="false" isCustomSecUnit="false" mainUnit="=0" secUnit="=0"/>
<ZoomAxisAttr isZoom="false"/>
<axisReversed axisReversed="false"/>
<VanChartAxisAttr mainTickLine="2" secTickLine="0" axisName="Y轴" titleUseHtml="false" autoLabelGap="true" limitSize="false" maxHeight="15.0" commonValueFormat="true" isRotation="false"/>
<HtmlLabel customText="function(){ return this; }" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
<alertList/>
<customBackgroundList/>
</VanChartAxis>
</YAxisList>
<stackAndAxisCondition>
<ConditionCollection>
<DefaultAttr class="com.fr.chart.chartglyph.ConditionAttr">
<ConditionAttr name=""/>
</DefaultAttr>
</ConditionCollection>
</stackAndAxisCondition>
<VanChartColumnPlotAttr seriesOverlapPercent="20.0" categoryIntervalPercent="20.0" fixedWidth="false" columnWidth="0" filledWithImage="false" isBar="true"/>
</Plot>
</Chart>
<tools hidden="true" sort="true" export="true" fullScreen="true"/>
<VanChartZoom>
<zoomAttr zoomVisible="false" zoomGesture="true" zoomResize="true" zoomType="xy"/>
<from>
<![CDATA[]]></from>
<to>
<![CDATA[]]></to>
</VanChartZoom>
<refreshMoreLabel>
<attr moreLabel="false" autoTooltip="true"/>
<AttrTooltip>
<Attr enable="true" duration="4" followMouse="false" showMutiSeries="false" isCustom="false"/>
<TextAttr>
<Attr alignText="0"/>
</TextAttr>
<AttrToolTipContent>
<Attr isCommon="true"/>
<value class="com.fr.plugin.chart.base.format.AttrTooltipValueFormat">
<AttrTooltipValueFormat>
<Attr enable="true"/>
</AttrTooltipValueFormat>
</value>
<percent class="com.fr.plugin.chart.base.format.AttrTooltipPercentFormat">
<AttrTooltipPercentFormat>
<Attr enable="false"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#.##%]]></Format>
</AttrTooltipPercentFormat>
</percent>
<category class="com.fr.plugin.chart.base.format.AttrTooltipCategoryFormat">
<AttrToolTipCategoryFormat>
<Attr enable="true"/>
</AttrToolTipCategoryFormat>
</category>
<series class="com.fr.plugin.chart.base.format.AttrTooltipSeriesFormat">
<AttrTooltipSeriesFormat>
<Attr enable="true"/>
</AttrTooltipSeriesFormat>
</series>
<changedPercent class="com.fr.plugin.chart.base.format.AttrTooltipChangedPercentFormat">
<AttrTooltipChangedPercentFormat>
<Attr enable="false"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#.##%]]></Format>
</AttrTooltipChangedPercentFormat>
</changedPercent>
<changedValue class="com.fr.plugin.chart.base.format.AttrTooltipChangedValueFormat">
<AttrTooltipChangedValueFormat>
<Attr enable="true"/>
</AttrTooltipChangedValueFormat>
</changedValue>
<HtmlLabel customText="" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
</AttrToolTipContent>
<GI>
<AttrBackground>
<Background name="ColorBackground" color="-1"/>
<Attr shadow="false"/>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="1" isRoundBorder="false" roundRadius="4"/>
<newColor borderColor="-15395563"/>
</AttrBorder>
<AttrAlpha>
<Attr alpha="0.8"/>
</AttrAlpha>
</GI>
</AttrTooltip>
</refreshMoreLabel>
</Chart>
</O>
<PrivilegeControl/>
<Expand/>
</C>
</CellElementList>
<ReportAttrSet>
<ReportSettings headerHeight="0" footerHeight="0">
<PaperSetting/>
</ReportSettings>
</ReportAttrSet>
</FormElementCase>
<StyleList/>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</body>
</InnerWidget>
<BoundsAttr x="7" y="30" width="840" height="214"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="report6_c"/>
<Widget widgetName="report3"/>
<Widget widgetName="report7_c_c_c"/>
<Widget widgetName="report2_c"/>
<Widget widgetName="date99"/>
<Widget widgetName="ch99"/>
<Widget widgetName="YW99_c"/>
<Widget widgetName="info99"/>
<Widget widgetName="type99"/>
<Widget widgetName="report1"/>
<Widget widgetName="report7_c_c_c_c"/>
<Widget widgetName="report1_c_c"/>
</MobileWidgetList>
<WidgetScalingAttr compState="0"/>
<DesignResolution absoluteResolutionScaleW="1366" absoluteResolutionScaleH="768"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="958" height="521"/>
</Widget>
<Sorted sorted="true"/>
<MobileWidgetList>
<Widget widgetName="absolute0"/>
</MobileWidgetList>
<WidgetZoomAttr compState="0"/>
<AppRelayout appRelayout="true"/>
<Size width="958" height="521"/>
<ResolutionScalingAttr percent="0.9"/>
<BodyLayoutType type="0"/>
</Center>
</Layout>
<DesignerVersion DesignerVersion="JAA"/>
<PreviewType PreviewType="0"/>
<TemplateID TemplateID="acf9008a-a532-4957-92df-9181384bf4d1"/>
<TemplateIdAttMark class="com.fr.base.iofileattr.TemplateIdAttrMark">
<TemplateIdAttMark TemplateId="c25c5864-3a1c-4e3e-ab97-58c34c70b87d"/>
</TemplateIdAttMark>
</Form>
