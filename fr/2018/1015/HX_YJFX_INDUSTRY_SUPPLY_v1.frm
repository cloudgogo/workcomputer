<?xml version="1.0" encoding="UTF-8"?>
<Form xmlVersion="20170720" releaseVersion="9.0.0">
<TableDataMap>
<TableData name="ds1" class="com.fr.data.impl.DBTableData">
<Parameters/>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[oracle_test]]></DatabaseName>
</Connection>
<Query>
<![CDATA[select 0.23 lv from dual]]></Query>
</TableData>
<TableData name="org" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="fr_authority"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="fr_username"/>
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
<![CDATA[
with role as
 (select regexp_substr(role, '[^,]A+', 1, level, 'i') as role
    from (select '${fr_authority}' role from dual)
  connect by level <=
             length(role) - length(regexp_replace(role, ',', '')) + 1),
             
du as
 ( --查询用户组织权限
  select orgid
    from dm_hx_data_aut du
   where 1 = 1
     and du.userid = '${fr_username}'
     and du.orgid is not null
  
  union all
  
  --如果用户组织权限为空，则组织权限为对应的角色的权限
  select orgid
    from dm_hx_data_aut du
   where 1 = 1
     and du.rolename in (select * from role)
     and 1 = nvl((select case
                       when orgid is null then
                        1
                       else
                        0
                     end flag
                from dm_hx_data_aut
               where userid = '${fr_username}'
                 ), 1) ),
du2 as (
select regexp_substr(orgid, '[^,]A+', 1, level, 'i') as orgid
    from (select orgid  from du)
  connect by level <=
             length(orgid) - length(regexp_replace(orgid, ',', '')) + 1


),

ORG_JG AS(
select ORG_ID,
       PARENTID as FATHER_ID,
       ORG_NAME,
       ORG_SHORTNAME as ORG_SNAME,
       ORG_NUM as ORDER_KEY,
       org_level,
       ORG_CODE
  from dim_org_jxjl where isshow=1 
   start with ORG_ID in(select orgid from du2)
connect by prior org_id =PARENTID
--where   ORG_ID in (select orgid from du2)
 --or FATHER_ID in (select orgid from du2)
 )

SELECT 
    ORG_ID,
    null  FATHER_ID,
    ORG_NAME,
    ORG_SNAME,
    ORDER_KEY,
    org_level,
    ORG_CODE
FROM ORG_JG where ORG_ID in(select ORG_ID from dim_org_jxjl where org_level=(select min(org_level) from  ORG_JG ))
UNION ALL
SELECT * FROM ORG_JG where ORG_ID not in(select ORG_ID from dim_org_jxjl where org_level=(select min(org_level) from  ORG_JG ))
order by order_key]]></Query>
</TableData>
<TableData name="Tree1_org" class="com.fr.data.impl.RecursionTableData">
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
<TableData name="tree2" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="org"/>
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
<![CDATA[select org_id, org_name, parentid father_id, org_num order_key , org_code
from dim_org_jxjl o
where 1=1
and org_code like ( select org_code|| '%' from dim_org_jxjl where org_id='${org}'  )
and isshow=1
order by to_number(org_num)]]></Query>
</TableData>
<TableData name="Tree2" class="com.fr.data.impl.RecursionTableData">
<markFields>
<![CDATA[0]]></markFields>
<parentmarkFields>
<![CDATA[2]]></parentmarkFields>
<markFieldsName>
<![CDATA[ORG_ID]]></markFieldsName>
<parentmarkFieldsName>
<![CDATA[FATHER_ID]]></parentmarkFieldsName>
<originalTableDataName>
<![CDATA[tree2]]></originalTableDataName>
</TableData>
<TableData name="1left" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="dim_cal"/>
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
<![CDATA[WITH date1 as(
select data_date date1 from dm_mcl_acct where rownum = 1
)

select round(nvl(a.target_value, 0)) target_value,
       round(nvl(a.actual_value, 0)) actual_value,
       case
         when nvl(a.target_value, 0) = 0 then
          0
         else
          round(nvl(a.actual_value, 0) / nvl(a.target_value, 0), 2)
       end rate_value
       
  from dm_mcl_acct a, dim_org b, dim_index c, date1
 where 1 = 1
   and a.org_id = b.org_id
   and a.index_id = c.index_id
   and c.index_id = 'b104c15725554e21a985eb28a31eaf61'
   and b.org_id = 'E0A3D386-D5C8-FB22-18DE-4424D49363B2'
   
   and a.period_type_id = case '${dim_cal}'
         when '1' then
          substr(date1.date1, 1, 4)
         when '2' then
          substr(date1.date1, 1, 4) || 'Q0' || to_char(to_date(date1.date1, 'YYYYMMDD'), 'Q')
         when '3' then
          substr(date1.date1, 1, 4) || 'M' || to_char(to_date(date1.date1, 'YYYYMMDD'), 'MM')
       end
]]></Query>
</TableData>
<TableData name="ZBPF_KJ" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="org"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="dim_cal"/>
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
<![CDATA[WITH date1 as(
select data_date date1 from dm_mcl_acct where rownum = 1
),
DIM_DATEKJ AS (
SELECT 
		CASE WHEN '1'='${dim_cal}' THEN PERIOD_YEAR
				 WHEN '2'='${dim_cal}' THEN PERIOD_QUARTER
				 WHEN '3'='${dim_cal}' THEN PERIOD_MONTH END AS CALIBER ,--找到我当前时间参数口径（当年、当季、当月）
		'1' as ORDER_CALIBER
		FROM DIM_PERIOD , date1 --时间维度
WHERE PERIOD_KEY=date1.date1
),--当前时间口径 年、季度、月份

DIM_DATEMX AS ( 
SELECT
		DISTINCT 
		CASE WHEN '1'='${dim_cal}' THEN PERIOD_YEAR
				 WHEN '2'='${dim_cal}' THEN PERIOD_QUARTER
				 WHEN '3'='${dim_cal}' THEN PERIOD_MONTH END AS DIM_CALIBER,--口径
		CASE WHEN '1'='${dim_cal}' THEN PERIOD_QUARTER
				 WHEN '2'='${dim_cal}' THEN PERIOD_MONTH
				 WHEN '3'='${dim_cal}' THEN WEEK_NBR_IN_MONTH END AS DIM_CALIBER_S --口径2
FROM DIM_PERIOD --时间维度
),--时间口径维度

DIM_DATES AS(
/*SELECT 
		CALIBER ,
		CASE WHEN '1'='${dim_cal}' THEN substr(CALIBER,1,4) 
				 WHEN '2'='${dim_cal}' THEN substr(date1.date1,1,4) ||'Q0'||substr(CALIBER,1,1) 
				 WHEN '3'='${dim_cal}' THEN substr(date1.date1,1,4) ||'M'||substr(CALIBER,1,2) 
		END as Statistical_time ,ORDER_CALIBER
FROM DIM_DATEKJ, date1
UNION ALL
*/
SELECT 
		b.DIM_CALIBER_S as CALIBER,
		CASE WHEN '1'='${dim_cal}' THEN substr(date1,1,4) ||'Q0'||substr(b.DIM_CALIBER_S,1,1) 
				 WHEN '2'='${dim_cal}' THEN substr(date1,1,4) ||'M'||substr(b.DIM_CALIBER_S,1,2) 
				 WHEN '3'='${dim_cal}' THEN substr(date1,1,4) ||'M'||substr(date1,5,2)||'W'||substr(b.DIM_CALIBER_S,2,1) 
		END as Statistical_time , 
		CASE WHEN '1'='${dim_cal}' THEN substr(date1,1,4) ||'Q0'||substr(b.DIM_CALIBER_S,1,1) 
				 WHEN '2'='${dim_cal}' THEN substr(date1,1,4) ||'M'||substr(b.DIM_CALIBER_S,1,2) 
				 WHEN '3'='${dim_cal}' THEN substr(date1,1,4) ||'M'||substr(date1,5,2)||'W'||substr(b.DIM_CALIBER_S,2,1) 
		END as ORDER_CALIBER
FROM DIM_DATEKJ a
LEFT JOIN DIM_DATEMX b
ON a.CALIBER=b.DIM_CALIBER
left join date1
on 1=1
), --整理时间维度

DATE_INDEX AS (
SELECT INDEX_ID,INDEX_NAME,ORDER_KEY FROM DIM_INDEX 
WHERE INDEX_id='b104c15725554e21a985eb28a31eaf61'
),--指标维度

DIM_ORF_HX AS(
SELECT ORG_ID,ORG_NAME FROM DIM_ORG 
where org_id = '${org}'
)--产业新城维度



SELECT a.CALIBER, --时间口径 
A.ORDER_CALIBER,
		a.STATISTICAL_TIME, --时间口径
		--c.ORG_NAME, --组织机构名称
		--c.ORG_ID, --组织机构id
		d.INDEX_NAME, --指标名称
		d.INDEX_ID, --指标id
		d.ORDER_KEY, --指标排序
		round(sum(NVL(e.TARGET_VALUE, 0))) TARGET_VALUE,
		round(sum(NVL(e.ACTUAL_VALUE, 0))) ACTUAL_VALUE,
		CASE WHEN sum(nvl(e.TARGET_VALUE,0))=0 THEN 0 ELSE sum(nvl(e.ACTUAL_VALUE,0))/sum(NVL(e.TARGET_VALUE, 0)) END as VALUE_lv
FROM DIM_DATES a --时间维度
LEFT JOIN DIM_ORF_HX c --组织维度
ON 1=1
LEFT JOIN DATE_INDEX d --指标维度
ON 1=1
LEFT JOIN DM_MCL_ACCT e --经营指标结果表
ON a.Statistical_time=e.PERIOD_TYPE_ID
AND c.ORG_ID=e.ORG_ID
AND d.INDEX_ID=e.INDEX_ID
group by a.CALIBER, --时间口径
A.ORDER_CALIBER,
		a.STATISTICAL_TIME, --时间口径
		--c.ORG_NAME, --组织机构名称
		--c.ORG_ID, --组织机构id
		d.INDEX_NAME, --指标名称
		d.INDEX_ID, --指标id
		d.ORDER_KEY
ORDER BY A.ORDER_CALIBER, d.ORDER_KEY]]></Query>
</TableData>
<TableData name="JDYG" class="com.fr.data.impl.DBTableData">
<Parameters/>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[oracle_test]]></DatabaseName>
</Connection>
<Query>
<![CDATA[--季度预估
WITH DATE1 AS
 (select data_date date1 from dm_mcl_acct where rownum = 1)

select '目标' type1, sum(nvl(a.target_value, 0)) value1

  from dm_mcl_acct a, dim_index ind, dim_org org, date1
 where 1 = 1
   and a.index_id = ind.index_id
   and a.org_id = org.org_id
   and ind.index_id = 'b104c15725554e21a985eb28a31eaf61'
   and org.org_id = 'E0A3D386-D5C8-FB22-18DE-4424D49363B2'
   and a.period_type_id = substr(date1.date1, 1, 4) || 'Q0' ||
       to_char(to_date(date1.date1, 'YYYYMMDD'), 'Q')

union all

select '实际' type1, sum(nvl(a.actual_value, 0)) value1

  from dm_mcl_acct a, dim_index ind, dim_org org, date1
 where 1 = 1 and a.index_id = ind.index_id and a.org_id = org.org_id and
 ind.index_id = 'b104c15725554e21a985eb28a31eaf61' 
 and org.org_id = 'E0A3D386-D5C8-FB22-18DE-4424D49363B2' and
 a.period_type_id = substr(date1.date1, 1, 4) || 'Q0' ||
 to_char(to_date(date1.date1, 'YYYYMMDD'), 'Q')

union all

select '预估完成' type1,
       decode(sum(nvl(a.forecate_value, 0)),
              0,
              sum(nvl(a.target_value, 0)),
              sum(nvl(a.forecate_value, 0))) value1

  from dm_mcl_acct a, dim_index ind, dim_org org, date1
 where 1 = 1 and a.index_id = ind.index_id and a.org_id = org.org_id and
 ind.index_id = 'b104c15725554e21a985eb28a31eaf61' 
 and org.org_id = 'E0A3D386-D5C8-FB22-18DE-4424D49363B2' and
 a.period_type_id = substr(date1.date1, 1, 4) || 'Q0' ||
 to_char(to_date(date1.date1, 'YYYYMMDD'), 'Q')
]]></Query>
</TableData>
<TableData name="ds2" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="org"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="dim_cal"/>
<O>
<![CDATA[1]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[oracle_test]]></DatabaseName>
</Connection>
<Query>
<![CDATA[with factdate as
 (select substr(data_date, 1, 6)
    from dm_mcl_acct
   where data_date is not null
     and rownum = 1),
RESULT as (
--当年
select *
  from (select a.org_id,
               a.org_name,
               a.order_key,
               a.targetid,
               a.target_name,
               a.factdate,
               '1' type1,
               substr(a.factdate, 1, 4)||'年' type2,
               a.year_target_val target_val,
               a.year_val val,
               a.year_target_rate target_rate,
               a.lst_year_val lst_val,
               a.year_rate rate
          from DM_MCL_RESIDENTIAL a
         where 1 = 1
           and targetid in( '81a24bfbfa9a45ebaf35ed9466b0e553','d3b49d2f94bc4fa8896ba93d9a4abec6')
           and father_id is not null
           and a.factdate = (select * from factdate)
        
        union all
        
        select a.org_id,
               a.org_name,
               a.order_key,
               a.targetid,
               a.target_name,
               a.factdate,
               '1' type1,
               case
                 when to_number(substr(a.factdate, 5, 2)) = 1 then
                  '1季度'
                 when to_number(substr(a.factdate, 5, 2)) = 4 then
                  '2季度'
                 when to_number(substr(a.factdate, 5, 2)) = 7 then
                  '3季度'
                 when to_number(substr(a.factdate, 5, 2)) = 10 then
                  '4季度'
               end type2,
               
               a.quarter_target_val  target_val,
               a.quarter_val         val,
               a.quarter_target_rate target_rate,
               a.lst_quarter_val     lst_val,
               a.quarter_rate        rate
        
          from DM_MCL_RESIDENTIAL a
         where 1 = 1
           and targetid in( '81a24bfbfa9a45ebaf35ed9466b0e553','d3b49d2f94bc4fa8896ba93d9a4abec6')
           and father_id is not null
           and to_number(substr(a.factdate, 5, 2)) in (1, 4, 7, 10))
 where 1 = 1
   and type1 = '${dim_cal}'

union all
--当季
select *
  from (select a.org_id,
               a.org_name,
               a.order_key,
               a.targetid,
               a.target_name,
               a.factdate,
               '2' type1,
               substr(a.factdate, 1, 4)||'年' type2,
               a.year_target_val target_val,
               a.year_val val,
               a.year_target_rate target_rate,
               a.lst_year_val lst_val,
               a.year_rate rate
          from DM_MCL_RESIDENTIAL a
         where 1 = 1
           and targetid in( '81a24bfbfa9a45ebaf35ed9466b0e553','d3b49d2f94bc4fa8896ba93d9a4abec6')
           and father_id is not null
           and a.factdate = (select * from factdate)
        union all
        select a.org_id,
               a.org_name,
               a.order_key,
               a.targetid,
               a.target_name,
               a.factdate,
               '2' type1,
               ceil(to_number(substr(a.factdate, 5, 2)) / 3) || '季度' type2,
               a.quarter_target_val target_val,
               a.quarter_val val,
               a.quarter_target_rate target_rate,
               a.lst_quarter_val lst_val,
               a.quarter_rate rate
          from DM_MCL_RESIDENTIAL a
         where 1 = 1
           and targetid in( '81a24bfbfa9a45ebaf35ed9466b0e553','d3b49d2f94bc4fa8896ba93d9a4abec6')
           and father_id is not null
           and a.factdate = (select * from factdate)
        
        union all
        
        select a.org_id,
               a.org_name,
               a.order_key,
               a.targetid,
               a.target_name,
               a.factdate,
               '2' type1,
               to_number(substr(a.factdate, 5, 2)) || '月' type2,
               a.month_target_val target_val,
               a.month_val val,
               a.month_target_rate target_rate,
               a.lst_month_val lst_val,
               a.month_rate rate
          from DM_MCL_RESIDENTIAL a
         where 1 = 1
           and targetid in( '81a24bfbfa9a45ebaf35ed9466b0e553','d3b49d2f94bc4fa8896ba93d9a4abec6')
           and father_id is not null
           and to_char(to_date((select * from factdate), 'YYYYMM'), 'yyyyq') =
               to_char(to_date(factdate, 'yyyymm'), 'yyyyq'))
 where 1 = 1 and type1 = '${dim_cal}'

union all
--当月
select *
  from (select a.org_id,
               a.org_name,
               a.order_key,
               a.targetid,
               a.target_name,
               a.factdate,
               '3' type1,
               substr(a.factdate, 1, 4)||'年' type2,
               a.year_target_val target_val,
               a.year_val val,
               a.year_target_rate target_rate,
               a.lst_year_val lst_val,
               a.year_rate rate
          from DM_MCL_RESIDENTIAL a
         where 1 = 1
           and targetid in( '81a24bfbfa9a45ebaf35ed9466b0e553','d3b49d2f94bc4fa8896ba93d9a4abec6')
           and father_id is not null
           and a.factdate = (select * from factdate)
        
        union all
        
        select a.org_id,
               a.org_name,
               a.order_key,
               a.targetid,
               a.target_name,
               a.factdate,
               '3' type1,
               ceil(to_number(substr(a.factdate, 5, 2)) / 3) || '季度' type2,
               a.quarter_target_val target_val,
               a.quarter_val val,
               a.quarter_target_rate target_rate,
               a.lst_quarter_val lst_val,
               a.quarter_rate rate
          from DM_MCL_RESIDENTIAL a
         where 1 = 1
           and targetid in( '81a24bfbfa9a45ebaf35ed9466b0e553','d3b49d2f94bc4fa8896ba93d9a4abec6')
           and father_id is not null
           and a.factdate = (select * from factdate)
        
        union all
        
        select a.org_id,
               a.org_name,
               a.order_key,
               a.targetid,
               a.target_name,
               a.factdate,
               '3' type1,
               to_number(substr(a.factdate, 5, 2)) || '月' type2,
               a.month_target_val target_val,
               a.month_val val,
               a.month_target_rate target_rate,
               a.lst_month_val lst_val,
               a.month_rate rate
          from DM_MCL_RESIDENTIAL a
         where 1 = 1
           and targetid in( '81a24bfbfa9a45ebaf35ed9466b0e553','d3b49d2f94bc4fa8896ba93d9a4abec6')
           and father_id is not null
           and a.factdate = (select * from factdate))
 where 1 = 1 and type1 = '${dim_cal}'
) 
,org as  (select org_id, org_name,/*lpad(org_name,length(org_name)+2*org_level)*/ case when org_level=2 then ' '||org_name  when org_level=3 then '  '||org_name else  org_name  end orgshowname,  parentid father_id, org_num order_key , org_code
from dim_org_jxjl o
where 1=1
and org_code like ( select org_code|| '%' from dim_org_jxjl where org_id='${org}'  )
and isshow=1
order by to_number(org_num))


select *
  from (select r.*,
               o.orgshowname,
               o.order_key deptorderkey,
               case
                 when type2 like '%年' then
                  TO_CHAR(to_date(factdate, 'yyyyMM'), 'yyyy')
                 when type2 like '%季度' then
                  TO_CHAR(to_date(factdate, 'yyyyMM'), 'yyyyQ')
                 when type2 like '%月' then
                  TO_CHAR(to_date(factdate, 'yyyyMM'), 'yyyyQMM')
               END periodorderkey,
               case
                 when target_name like '%亩%' then
                  '亩'
                 else
                  '万平'
               end targetunit,
               case
                 when target_name like '%亩%' then
                  1
                 else
                  2
               end targetorder
          from result r, org o
         where r.org_id = o.org_id) res
 order by res.deptorderkey,res.periodorderkey,res.order_key,res.targetorder
]]></Query>
</TableData>
</TableDataMap>
<FormMobileAttr>
<FormMobileAttr refresh="false" isUseHTML="false" isMobileOnly="false" isAdaptivePropertyAutoMatch="false"/>
</FormMobileAttr>
<Parameters>
<Parameter>
<Attributes name="dim_cal"/>
<O>
<![CDATA[1]]></O>
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
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
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
<LCAttr vgap="0" hgap="0" compInterval="0"/>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ElementCaseEditor">
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
<![CDATA[1440000,0,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" cs="4" s="0">
<O t="RichText">
<RichText>
<RichChar styleIndex="1">
<text>
<![CDATA[目标 ]]></text>
</RichChar>
<RichChar styleIndex="2">
<text>
<![CDATA[${=A2}]]></text>
</RichChar>
<RichChar styleIndex="2">
<text>
<![CDATA[ ]]></text>
</RichChar>
<RichChar styleIndex="1">
<text>
<![CDATA[亩]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="0" r="1">
<O t="DSColumn">
<Attributes dsName="1left" columnName="TARGET_VALUE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
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
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Top color="-16777216"/>
<Bottom color="-16777216"/>
<Left color="-16777216"/>
<Right color="-16777216"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="104" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="1" size="104" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<IM>
<![CDATA[m94j=;cgC<:dc7V>jXro,ahiD%j"UjJ3lT#[ap@uEU7>c5_=#*;M9RN&FqULKqgNSdP3.@Zm
_oK&/F7PE"o#a9&U%Q,-QZT0nor7Oq@1H'=>GQ4IND.%fPg>g\c?j3GYh3IV\o5A*<'J_Dfb
eFn)L<"Cg5bO#HnRJT*jt&9a+Hca#_P.,K@gJI)$mdt[T\cHIBq$/W9nIe)jN-h573_m:=IH
"R_?Tc,oTs.SnlT!pr2#8>]AB)+]A*cj'Mu]AB>72fA+l2!XnU<ao%t>@L`,jab26d\HQH:dhOp
"0d?#.<C!6mp7?)rp*H#sn<J=)4-JktqIMs0F?!@^1ANE+H!0Z46_Qhr]A7:k(4BO"-V<(W)q
rpWYp5#3B0hoTmH2EX_\UWXCH+$NKE66d"%ma=3M"Dd64MXVhHe"nf'h$`>5h-.n>lGe&14d
@_3<2@,E&qTk?NAYg%r>aeO@n6W.mK1U7.`o!827oRNM@$mT&p#6H4AKZ%`$$>hkiMfAn&Bd
A-c]AOSUC1m`btp<R?D'jVT]ABqc@_$Y]A?^gami>d/:?Hklm<RZC[Au#mo(Kd;++,di]Ad[o_]A+
lZgVAr$h&lZjRk\Mir!qsOLD(A%@;rFMJ74OKgA-`_7nOfYDBhM^(+<I^C"'kX!/"?PinMX)
`rc<IFX]AG;.EJ$Gtp'E(>HRaZ+n8u#SdBWaVV+3f+^7HA++q9Ea&il3aTgoAh;c+M9/Mkb9U
RMN"3>]AUBk'f=lF'PRVEhii2Qa)2SC%TAU,dplN^6B48lU,Mas]AVb?a0rN<WCIrr>hK]A[U.8
b*>ir@)*)M]Ac`qrt^ld@tH#jrBL)s5l3g)C_mMgq9iFq.KCuHAd.&i0kh`Ok#Zm'$]A5%ZeH6
44LW#oot^L"S-ugm7q7i-9'TYD2p_kbnatqbqaJ]A1H<pd$D_mWk76e%>S[.r5fNS"-<^X>#1
WV0ZalfPaVRc,p\*MRgS@YnfRjO+05V=kBD-!epX5g@`YrNTtB03Wnb;GNl='H2Ej\a4M:Z%
)r(O(7dj]AL`=^I8[RObkE[<&VMTii511o%8jQ[D9",no@%Kj/r>&^QL4nf&\\2*Rk%K>Kh*%
41)a,f')T/2Yr\P7k+'%$\AuSP:G@K%lEf#@g$DY99YD5]AXQ5X5lk*Z(n8GtOt:)MKtIEhbU
RD@L"!7`kCqb]A9F'SK,3BLlN:d2U"cl/_9GA6PYUo(0S8RI`8El$?2ObD.Ak="<8$0[c<D>S
.A>2e33BV2(_2+';b[Zq=()k\n8S;9t/&p6W>1".[!ZkDj'kcaSY'gZAr_J!iCc/n)K0A.]A4
n.<FNNB>>J\0=i9s[-\&Fige28\scgsuupOe$6,k,Z<UVMdp/;Zl75a[mCaa3!!P7UbX#YD;
2X2KYPAkY"2Nq<"O:D>4@3^h%HVQkB@p1kq:KJ1m*Mgi<UiZ<j%XT\4B^DmYI`%60D&Dfu-g
0>R[IKPW@ta^QYr"PE6OYalT1bK5df^]ApC<$q2\8)DCmF+FUeV>OT[]AS#W+\V-GCm(eM-20[
9K6TZ]A$ReYCP%FN(u>,6K0>5ZGp53W9THpK1g?H+\H.-fO3@*j;UrmYml*V+hid9S:<[RkV3
T%L=cUqm9^r=C\',)T*F^Fr,*N:77^Ef"F.CUQWs.R".#g3B`@Q@j;4(`[^6&"5=t&Xc`eLj
C3oXU@%,LiMi1[Q*8C*L'YL]ArgfISh:`[F@ZKVb$2dn;b'K.P1'$7"q)M`2el":pam.,aDDu
S^'jgs2A%449XSd7BL<%1fQX$X#pf"<:n.$\P$]AnYs+(D60!--Y]AX"B[u<-m4U*PHVP1ooba
[p4#,`$9#&5c,i6VQd\grln!fGg:9uJTcXk>Fi>/-Fo=)Rb;Tr>B/E=Ghl?[,TEmE`I`9\hF
)NeUf)R)>VK>amkDiWr)QF(Ch9L^1J%1MEg=2Nb)g4U^k2)3m2F5oW:;1Kh17!tRbuJ2a;^J
U40?$oL32n_;iN[=,[*$^-X%"t:mW5?b#\KD%u-IkgW2FdR*94">ElhK$alQ3UouTarL&T(r
&&,$'8`]ATZ#;.<V+rO[UqqJ-g@QoX_B-m^b;YA,WDN^`:$>Q]A\@$si+;BthQr7qQ<'7Tnn_c
I1,.6p$>5!qha&[TLbFbW_bOD9g%#p#Nr@9i10aXe#E(B6*SFco!>DUYY-^T[@KumId&">R0
CJF**JDBR]AEcZRo?cA&(FdR%NZqt#RouQlLM)P4D_Xn*X#/.5.*kErR2r^kgLk,'eh1o9tHJ
F9!#o`G'Bsi<\C?Tst#p=3EO!?7#,Pd3Wh,>Opm@&GPakSkL9*SlA@B7obS^QRp#L4VfNN0f
u1;J,TqR2W=(/@"7H4R&s4D.WYW*E"+5D,NWs%"'%GsEBc_1+SPV-s#\5d"[)jr4)WD@raD+
7M`CN-^EGq;`TO'TDU9Y-WI6p)3DHCNX,q[_)q8Kt>C/J!%tG=dUL3Mm(fYJYT7J-#AI5]AVP
A2SDbgZWMr;\+H:pQZsY<3gtp!09@lo-Th!sQj`S-+Q#qZU3<n:^6Z\XE2M*GLN<@GG=q2E+
6og5i#rfXPM97eek"T7u,mgL<@AJLqU_V5hAuY!Blu4-s9Kj6WUu>E(()?!XCZCR@5jZ%]AL\
egZ6u7TSoZ0dW]ArS('UE94J3Fa'F\78[(6P]A5mQ='IEkl!4EgUQ:QBa9]AjQONLi9S'AW=.LL
RYNpgHaujg/Mo:Q?#.Q3Hh45O1j/VCG=j4d))8UX05**W5l+%QBAGPNZ`SfW;!0:C6?_<F!7
H@H\pQ<dn90$uNm8MGDd>p*PNqr/uSnY-OlHdun-RO-9DB]A&qKHBeh&k"YD[*galNdqi-.!#
Pdet)-UV">]A9eRY9+F)An0b-XYFp$-<MCSqH)5EaTq.HdU"m767Y8',aD/aE\;C67,n_>3^t
W3si?c</[Me"Kd"q+6Z[0=Omcm;iMP>CrP@Z&ecC?mr(6<0<d&d>et`Astp7n[Lb[hk_j;Df
4b'phW*Y:ZgRKd@0qK4p$.4el)[HlItOTrpF%27j!tm7N9<?WcHd)WmCWYf`4iDh^#3m!pIn
9%TA["^!2=0QUibPeM3cX7Qk#\`_Nr?iLhj9s5m->@&L#,.`XQac!ZRg?IL&[n96;n;M4ri]A
-@cM/"GUHPG![5'(^\[`J5M22.g;"ek7ur/r!gn<ApG"S_+2(1:FM3mu#VlAXb?\KR@(lfUp
6A8<gF%4r1JJ^;Zb0C#rV_[8(JfV[od"[48D.C.R@PfRN.m:`eei<96f=Z:t#G`j;@o/aLo]A
69G9(.#+)"AcnX*Br8n4JkMo85_g$WE)E.Xo:\+#9%IGHke#'9rbHO.9mnM'1j5eeQ3bE7`L
.NDNbeA=k'",TodZp5&sf1h)nWXZ;2fj<T<`CshB8lG'n;F9k6asDp5=/gd)M9M:i$2f8=JF
"mch`Fr%%?I<2SbSI1rq\gU!A/Z[/ohos\r$Q0H<Ip3(`=76DWah&(+o?Fmu>#IG2"XMX9sO
2WO/.UOCf#`MRKiEh_X1+DuqYA&bYlC<O0Q,d8>UoLj(QZ17q=,e>FT=Zc:\rs/gKea+sB#j
mo+jkC=X,X-Q7@0pIBL=_P[`!Njr_cV/WZ44ecn]A]ANJEiSo^hi8?"?j!InluMQ0eCMX/pUg!
[#*+kqaVN;2bXnn=:9MO"c[i]A)&4Q&[`dUdHiJAGg@*\/ND,1XdN6#^l-Jm&ePRrK2o#(=/M
$eHnj?ClcrlPS;ah0q?IblR:n#m?h<L(Vh2'V!i#%YYrcs)ke1jEgE+jYcCnG$7b?6i)jh_L
$D:MM!0"s=W@)nIYV3#8':=\6BS\<oSKAp5d+RNhSFjTF:=>knf^j>s<,-dq"bP<i2JAc$_K
beC#AlLKgW#l29)W0^,gMUH.cr.fEbJPf(VE%\Z]A#g&6%FV0o(CVX"Fa';8q%N<4no$9p)lq
3knVhM90tDde3H.B,Cd^iU@iPl8)@o:U$=>h&b;GdI6M!l2X&4b!GbDjJp<76-IT#D</C@QV
_XWaChXG('Fgk,SrCVbmZ[s'JZ,Gs-%D`ZK1"^OnIJm1tZ[>QqXaW^Pf(cD<Jgn;.>Q>cF8T
e&=$M(d]Am,U`\WK`>m)"OT[Zg1nc,k"FNa6r;=\H2o`/6t=48VS[Z-JXIkWc40@2s#lF!%Dl
un5F6$+0t4k0$_PlJ,d'75?ZT\b3RB8M:h`)-Mu3*fT*TA?MOHO!F2sL_[(]AX`.Tq9(#DAS&
Rd>N!_X/QC%7In7rphgf>,HQ=!)7c*t=S]AFcuTaG$lN[246-Kq9r3pF$jdsG)Bb[*ZV\R%ek
._7nGrFjO5h4fVdm$nZ"hti`Z/CbP#]AXnLAi&6D=?X3.6p@>qhT6662Q$s0LASq1?/&$aUfK
b+\iipR:NUGodqQU`]AkRRuZ3J6,(XIftt1iD$6mqUr?[I#s&Bj84uL&$W5u(),>DHc5glpnm
#hJ@6?Kc35^WW#f"loiSdM%0ZfP'C5^tu^SaUdME/E9(SgJ<J2^5>T+^'JCpmcg31^$32B0Y
iG7=MMqQs`>]A595[:`!t;H9/i2/\K4?;%1GP`@chmCO***9(i2P&3e(S$=R63^S"KZdBbNr&
E\#p1u+8[CsL2]A!go5oUk%ABF*bFA%"G/%KZJj$`Z@,9E/#"OZXI]A:lJ1U`:N=mr%Et@dQCJ
`#*S3Y@S<&%q.b5^p_9updUd5f5"(Q,-]AcH,N$F:ArFgJTWTbUntN#cMP_ql7dShh1UdBgX(
=Y"t=-lu0P[;0B;mr[k5k9CEN<OZh\GC<f3n%9"2s-O:aU,aa;iEfj_bE"!'7q+cZpWPTb+O
)[=<<UM$DE^M6:$m.;dB<oh]A\l[;/&9&*qT.2VrY)J0Y$9_1D8TsfP+7gEChGPL(i[Ps3P3S
j]A1Vmsi5q;TKbA9QC\L%\ARC)FQc,/bT!3R]ASUTdir0]Al`>*+4h=cR68G`[#5@X+i]Ah$>+k3
FX2`5PXARE/)@nlss[RrL-@9?m%lS0&5Had-&9IMZ*:Q&,YHp#7n"c7,K9Pl1/<q:STZ,H_F
[!Y8_^E9)\XIrQ1<O*s*Ns"/iiR!1u7kf0dMdd_#!er5p&eQ:U>jlFci?>/#SAH[gC=9NAL.
Pi58H'@lZR:Z4CRLU30(2cYm!<PdE@<P<'(I/?GH/_`saN:2<6>=2g^-k5aO;:>=$ZEs<a2U
o]AR8o1`uA=P.'Oq#sX^j#&4qe!QK2+&YZ_t_9iiE>#r_;5K;pf1OH)hL_1:e)Fg)1cqJ'O,a
]AZA[Km^SI0]AA-4@$>_+i%CSQk3:6'>LIVF'(qk?23Qm6"Wlnc6hKn^W[L'/NO3A^YoMVK'q?
:YGh9i#d7<rD&^+r/4H^lZalQ-bi79ddI6pUi<f_HE,I!_MZ8F>!2t6`^RG^MW6d)$EWFZ[G
H,`qSiuQTaaYs1XcJoZ<PYS<`9i^CD\`LX?:oK+^659\AuS`HKK#eW<=O1NN4.)#2WR09jc%
\i"Z6_67t4K]ALbP@9'TRql:I-O@rMHg`2(U(YXqQFj3r&1$sj*Rc,9Err]Apf:T5<Zn(PCg`e
GWa\bt0'osLs`=lrtAA+^AL61"$F7)QmRT@kW[gK7r`q?cS*"TG`W:jb=d+ecWbSULa3;I2N
73L]AP^i_,:JJb_"Gi`J+h:F1*`Y%RBV+pD("Es?Bs91V?UEi+"Rs"upXk%o]A1Xp5W%%99jV6
`X#u2Wh[jV#%H1ps,ms_Q))q9l!4@")Y15.bQL+;8Al`Sk^^m[efB6[?4>;Y#_XX9C#GFY-L
od3E2<XnMD;tE)S#9jN7,7iO0B)0?Rp?(0pN*hLS7u3Z`3L]AM+r]Aj4KFkq4eZV+h-5SB$;j]A
#j4H?T=eHVCW6Q(s/2Q-\ASDn2B&G8"&O`oYG3CA!c6*Wr4/m6`pu+afTS6="U23Gh(s5XoX
'%(]Ak'Fnp3R00__&)'lob^QQ]AJm/$!5O*f'A*#T7_,,_lRAiI'WO\Hhq)l:H"*Y@A1)@(l"S
T+oaujNciu@`iXf9VPj)ERlZ]ADM>mI>`[Z5PA9a+[Nn;o%'9l8#98a%_"S`SD/J@\t8?%%_!
e0imhm'r&4rV/`\`E<Uh70k?Vo-cb)05uK8oKrs'rHjU$M9H`?#+9$9+QENnq6[ms2Wo!20j
=3:/rQ;D(on7G;&?s!'2Fb@\o&7o9so)V.T(i%Gs]AA-I38A@Gj[N7m>SqRMS)7%NbCG3``uF
f%"XH-AcUk[8F%*9:13UpB3L?c-=11.ZrCtj+:o!\^&YB]AVj;:7'Tl*G0H#K:W("[FT;<hP=
GssE4knXHPO!2`9;sh'7j7)l,,[gCKo9FZ(35Mnjc`P24hpr0g2m!FSmJ$pr5FNbOp%@K_bG
P.6>Yg2>[U%LE1!9ls_[M2JHAoNOh_\SmWe*r)Qa7\V/@H'AjSNJP]A^S3I1*OO;`XVM\F-=b
"p;K$I!H0<Y&Y%s6,q1SAn1H'h%2G>ru`[:>]A6>eS+4:Mg->.\7Kf56OF=Sj#59;^U^Y\dBP
nrJ<h"o?dJ(BAg?E:+%%m"9SU9f4um=<I;*DIqmW90[cZ@GSk]ARi>Stluo8bX<Er*]AM`t)$Y
gan-O\*8P7%4-L_rqrA~
]]></IM>
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
<![CDATA[1440000,0,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" cs="4" s="0">
<O t="RichText">
<RichText>
<RichChar styleIndex="1">
<text>
<![CDATA[目标 ]]></text>
</RichChar>
<RichChar styleIndex="2">
<text>
<![CDATA[${=A2}]]></text>
</RichChar>
<RichChar styleIndex="2">
<text>
<![CDATA[ ]]></text>
</RichChar>
<RichChar styleIndex="1">
<text>
<![CDATA[亩]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="0" r="1">
<O t="DSColumn">
<Attributes dsName="1left" columnName="TARGET_VALUE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
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
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Top color="-16777216"/>
<Bottom color="-16777216"/>
<Left color="-16777216"/>
<Right color="-16777216"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="104" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="1" size="104" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<IM>
<![CDATA[m94j=;cgC<:dc7V>jXro,ahiD%j"UjJ3lT#[ap@uEU7>c5_=#*;M9RN&FqULKqgNSdP3.@Zm
_oK&/F7PE"o#a9&U%Q,-QZT0nor7Oq@1H'=>GQ4IND.%fPg>g\c?j3GYh3IV\o5A*<'J_Dfb
eFn)L<"Cg5bO#HnRJT*jt&9a+Hca#_P.,K@gJI)$mdt[T\cHIBq$/W9nIe)jN-h573_m:=IH
"R_?Tc,oTs.SnlT!pr2#8>]AB)+]A*cj'Mu]AB>72fA+l2!XnU<ao%t>@L`,jab26d\HQH:dhOp
"0d?#.<C!6mp7?)rp*H#sn<J=)4-JktqIMs0F?!@^1ANE+H!0Z46_Qhr]A7:k(4BO"-V<(W)q
rpWYp5#3B0hoTmH2EX_\UWXCH+$NKE66d"%ma=3M"Dd64MXVhHe"nf'h$`>5h-.n>lGe&14d
@_3<2@,E&qTk?NAYg%r>aeO@n6W.mK1U7.`o!827oRNM@$mT&p#6H4AKZ%`$$>hkiMfAn&Bd
A-c]AOSUC1m`btp<R?D'jVT]ABqc@_$Y]A?^gami>d/:?Hklm<RZC[Au#mo(Kd;++,di]Ad[o_]A+
lZgVAr$h&lZjRk\Mir!qsOLD(A%@;rFMJ74OKgA-`_7nOfYDBhM^(+<I^C"'kX!/"?PinMX)
`rc<IFX]AG;.EJ$Gtp'E(>HRaZ+n8u#SdBWaVV+3f+^7HA++q9Ea&il3aTgoAh;c+M9/Mkb9U
RMN"3>]AUBk'f=lF'PRVEhii2Qa)2SC%TAU,dplN^6B48lU,Mas]AVb?a0rN<WCIrr>hK]A[U.8
b*>ir@)*)M]Ac`qrt^ld@tH#jrBL)s5l3g)C_mMgq9iFq.KCuHAd.&i0kh`Ok#Zm'$]A5%ZeH6
44LW#oot^L"S-ugm7q7i-9'TYD2p_kbnatqbqaJ]A1H<pd$D_mWk76e%>S[.r5fNS"-<^X>#1
WV0ZalfPaVRc,p\*MRgS@YnfRjO+05V=kBD-!epX5g@`YrNTtB03Wnb;GNl='H2Ej\a4M:Z%
)r(O(7dj]AL`=^I8[RObkE[<&VMTii511o%8jQ[D9",no@%Kj/r>&^QL4nf&\\2*Rk%K>Kh*%
41)a,f')T/2Yr\P7k+'%$\AuSP:G@K%lEf#@g$DY99YD5]AXQ5X5lk*Z(n8GtOt:)MKtIEhbU
RD@L"!7`kCqb]A9F'SK,3BLlN:d2U"cl/_9GA6PYUo(0S8RI`8El$?2ObD.Ak="<8$0[c<D>S
.A>2e33BV2(_2+';b[Zq=()k\n8S;9t/&p6W>1".[!ZkDj'kcaSY'gZAr_J!iCc/n)K0A.]A4
n.<FNNB>>J\0=i9s[-\&Fige28\scgsuupOe$6,k,Z<UVMdp/;Zl75a[mCaa3!!P7UbX#YD;
2X2KYPAkY"2Nq<"O:D>4@3^h%HVQkB@p1kq:KJ1m*Mgi<UiZ<j%XT\4B^DmYI`%60D&Dfu-g
0>R[IKPW@ta^QYr"PE6OYalT1bK5df^]ApC<$q2\8)DCmF+FUeV>OT[]AS#W+\V-GCm(eM-20[
9K6TZ]A$ReYCP%FN(u>,6K0>5ZGp53W9THpK1g?H+\H.-fO3@*j;UrmYml*V+hid9S:<[RkV3
T%L=cUqm9^r=C\',)T*F^Fr,*N:77^Ef"F.CUQWs.R".#g3B`@Q@j;4(`[^6&"5=t&Xc`eLj
C3oXU@%,LiMi1[Q*8C*L'YL]ArgfISh:`[F@ZKVb$2dn;b'K.P1'$7"q)M`2el":pam.,aDDu
S^'jgs2A%449XSd7BL<%1fQX$X#pf"<:n.$\P$]AnYs+(D60!--Y]AX"B[u<-m4U*PHVP1ooba
[p4#,`$9#&5c,i6VQd\grln!fGg:9uJTcXk>Fi>/-Fo=)Rb;Tr>B/E=Ghl?[,TEmE`I`9\hF
)NeUf)R)>VK>amkDiWr)QF(Ch9L^1J%1MEg=2Nb)g4U^k2)3m2F5oW:;1Kh17!tRbuJ2a;^J
U40?$oL32n_;iN[=,[*$^-X%"t:mW5?b#\KD%u-IkgW2FdR*94">ElhK$alQ3UouTarL&T(r
&&,$'8`]ATZ#;.<V+rO[UqqJ-g@QoX_B-m^b;YA,WDN^`:$>Q]A\@$si+;BthQr7qQ<'7Tnn_c
I1,.6p$>5!qha&[TLbFbW_bOD9g%#p#Nr@9i10aXe#E(B6*SFco!>DUYY-^T[@KumId&">R0
CJF**JDBR]AEcZRo?cA&(FdR%NZqt#RouQlLM)P4D_Xn*X#/.5.*kErR2r^kgLk,'eh1o9tHJ
F9!#o`G'Bsi<\C?Tst#p=3EO!?7#,Pd3Wh,>Opm@&GPakSkL9*SlA@B7obS^QRp#L4VfNN0f
u1;J,TqR2W=(/@"7H4R&s4D.WYW*E"+5D,NWs%"'%GsEBc_1+SPV-s#\5d"[)jr4)WD@raD+
7M`CN-^EGq;`TO'TDU9Y-WI6p)3DHCNX,q[_)q8Kt>C/J!%tG=dUL3Mm(fYJYT7J-#AI5]AVP
A2SDbgZWMr;\+H:pQZsY<3gtp!09@lo-Th!sQj`S-+Q#qZU3<n:^6Z\XE2M*GLN<@GG=q2E+
6og5i#rfXPM97eek"T7u,mgL<@AJLqU_V5hAuY!Blu4-s9Kj6WUu>E(()?!XCZCR@5jZ%]AL\
egZ6u7TSoZ0dW]ArS('UE94J3Fa'F\78[(6P]A5mQ='IEkl!4EgUQ:QBa9]AjQONLi9S'AW=.LL
RYNpgHaujg/Mo:Q?#.Q3Hh45O1j/VCG=j4d))8UX05**W5l+%QBAGPNZ`SfW;!0:C6?_<F!7
H@H\pQ<dn90$uNm8MGDd>p*PNqr/uSnY-OlHdun-RO-9DB]A&qKHBeh&k"YD[*galNdqi-.!#
Pdet)-UV">]A9eRY9+F)An0b-XYFp$-<MCSqH)5EaTq.HdU"m767Y8',aD/aE\;C67,n_>3^t
W3si?c</[Me"Kd"q+6Z[0=Omcm;iMP>CrP@Z&ecC?mr(6<0<d&d>et`Astp7n[Lb[hk_j;Df
4b'phW*Y:ZgRKd@0qK4p$.4el)[HlItOTrpF%27j!tm7N9<?WcHd)WmCWYf`4iDh^#3m!pIn
9%TA["^!2=0QUibPeM3cX7Qk#\`_Nr?iLhj9s5m->@&L#,.`XQac!ZRg?IL&[n96;n;M4ri]A
-@cM/"GUHPG![5'(^\[`J5M22.g;"ek7ur/r!gn<ApG"S_+2(1:FM3mu#VlAXb?\KR@(lfUp
6A8<gF%4r1JJ^;Zb0C#rV_[8(JfV[od"[48D.C.R@PfRN.m:`eei<96f=Z:t#G`j;@o/aLo]A
69G9(.#+)"AcnX*Br8n4JkMo85_g$WE)E.Xo:\+#9%IGHke#'9rbHO.9mnM'1j5eeQ3bE7`L
.NDNbeA=k'",TodZp5&sf1h)nWXZ;2fj<T<`CshB8lG'n;F9k6asDp5=/gd)M9M:i$2f8=JF
"mch`Fr%%?I<2SbSI1rq\gU!A/Z[/ohos\r$Q0H<Ip3(`=76DWah&(+o?Fmu>#IG2"XMX9sO
2WO/.UOCf#`MRKiEh_X1+DuqYA&bYlC<O0Q,d8>UoLj(QZ17q=,e>FT=Zc:\rs/gKea+sB#j
mo+jkC=X,X-Q7@0pIBL=_P[`!Njr_cV/WZ44ecn]A]ANJEiSo^hi8?"?j!InluMQ0eCMX/pUg!
[#*+kqaVN;2bXnn=:9MO"c[i]A)&4Q&[`dUdHiJAGg@*\/ND,1XdN6#^l-Jm&ePRrK2o#(=/M
$eHnj?ClcrlPS;ah0q?IblR:n#m?h<L(Vh2'V!i#%YYrcs)ke1jEgE+jYcCnG$7b?6i)jh_L
$D:MM!0"s=W@)nIYV3#8':=\6BS\<oSKAp5d+RNhSFjTF:=>knf^j>s<,-dq"bP<i2JAc$_K
beC#AlLKgW#l29)W0^,gMUH.cr.fEbJPf(VE%\Z]A#g&6%FV0o(CVX"Fa';8q%N<4no$9p)lq
3knVhM90tDde3H.B,Cd^iU@iPl8)@o:U$=>h&b;GdI6M!l2X&4b!GbDjJp<76-IT#D</C@QV
_XWaChXG('Fgk,SrCVbmZ[s'JZ,Gs-%D`ZK1"^OnIJm1tZ[>QqXaW^Pf(cD<Jgn;.>Q>cF8T
e&=$M(d]Am,U`\WK`>m)"OT[Zg1nc,k"FNa6r;=\H2o`/6t=48VS[Z-JXIkWc40@2s#lF!%Dl
un5F6$+0t4k0$_PlJ,d'75?ZT\b3RB8M:h`)-Mu3*fT*TA?MOHO!F2sL_[(]AX`.Tq9(#DAS&
Rd>N!_X/QC%7In7rphgf>,HQ=!)7c*t=S]AFcuTaG$lN[246-Kq9r3pF$jdsG)Bb[*ZV\R%ek
._7nGrFjO5h4fVdm$nZ"hti`Z/CbP#]AXnLAi&6D=?X3.6p@>qhT6662Q$s0LASq1?/&$aUfK
b+\iipR:NUGodqQU`]AkRRuZ3J6,(XIftt1iD$6mqUr?[I#s&Bj84uL&$W5u(),>DHc5glpnm
#hJ@6?Kc35^WW#f"loiSdM%0ZfP'C5^tu^SaUdME/E9(SgJ<J2^5>T+^'JCpmcg31^$32B0Y
iG7=MMqQs`>]A595[:`!t;H9/i2/\K4?;%1GP`@chmCO***9(i2P&3e(S$=R63^S"KZdBbNr&
E\#p1u+8[CsL2]A!go5oUk%ABF*bFA%"G/%KZJj$`Z@,9E/#"OZXI]A:lJ1U`:N=mr%Et@dQCJ
`#*S3Y@S<&%q.b5^p_9updUd5f5"(Q,-]AcH,N$F:ArFgJTWTbUntN#cMP_ql7dShh1UdBgX(
=Y"t=-lu0P[;0B;mr[k5k9CEN<OZh\GC<f3n%9"2s-O:aU,aa;iEfj_bE"!'7q+cZpWPTb+O
)[=<<UM$DE^M6:$m.;dB<oh]A\l[;/&9&*qT.2VrY)J0Y$9_1D8TsfP+7gEChGPL(i[Ps3P3S
j]A1Vmsi5q;TKbA9QC\L%\ARC)FQc,/bT!3R]ASUTdir0]Al`>*+4h=cR68G`[#5@X+i]Ah$>+k3
FX2`5PXARE/)@nlss[RrL-@9?m%lS0&5Had-&9IMZ*:Q&,YHp#7n"c7,K9Pl1/<q:STZ,H_F
[!Y8_^E9)\XIrQ1<O*s*Ns"/iiR!1u7kf0dMdd_#!er5p&eQ:U>jlFci?>/#SAH[gC=9NAL.
Pi58H'@lZR:Z4CRLU30(2cYm!<PdE@<P<'(I/?GH/_`saN:2<6>=2g^-k5aO;:>=$ZEs<a2U
o]AR8o1`uA=P.'Oq#sX^j#&4qe!QK2+&YZ_t_9iiE>#r_;5K;pf1OH)hL_1:e)Fg)1cqJ'O,a
]AZA[Km^SI0]AA-4@$>_+i%CSQk3:6'>LIVF'(qk?23Qm6"Wlnc6hKn^W[L'/NO3A^YoMVK'q?
:YGh9i#d7<rD&^+r/4H^lZalQ-bi79ddI6pUi<f_HE,I!_MZ8F>!2t6`^RG^MW6d)$EWFZ[G
H,`qSiuQTaaYs1XcJoZ<PYS<`9i^CD\`LX?:oK+^659\AuS`HKK#eW<=O1NN4.)#2WR09jc%
\i"Z6_67t4K]ALbP@9'TRql:I-O@rMHg`2(U(YXqQFj3r&1$sj*Rc,9Err]Apf:T5<Zn(PCg`e
GWa\bt0'osLs`=lrtAA+^AL61"$F7)QmRT@kW[gK7r`q?cS*"TG`W:jb=d+ecWbSULa3;I2N
73L]AP^i_,:JJb_"Gi`J+h:F1*`Y%RBV+pD("Es?Bs91V?UEi+"Rs"upXk%o]A1Xp5W%%99jV6
`X#u2Wh[jV#%H1ps,ms_Q))q9l!4@")Y15.bQL+;8Al`Sk^^m[efB6[?4>;Y#_XX9C#GFY-L
od3E2<XnMD;tE)S#9jN7,7iO0B)0?Rp?(0pN*hLS7u3Z`3L]AM+r]Aj4KFkq4eZV+h-5SB$;j]A
#j4H?T=eHVCW6Q(s/2Q-\ASDn2B&G8"&O`oYG3CA!c6*Wr4/m6`pu+afTS6="U23Gh(s5XoX
'%(]Ak'Fnp3R00__&)'lob^QQ]AJm/$!5O*f'A*#T7_,,_lRAiI'WO\Hhq)l:H"*Y@A1)@(l"S
T+oaujNciu@`iXf9VPj)ERlZ]ADM>mI>`[Z5PA9a+[Nn;o%'9l8#98a%_"S`SD/J@\t8?%%_!
e0imhm'r&4rV/`\`E<Uh70k?Vo-cb)05uK8oKrs'rHjU$M9H`?#+9$9+QENnq6[ms2Wo!20j
=3:/rQ;D(on7G;&?s!'2Fb@\o&7o9so)V.T(i%Gs]AA-I38A@Gj[N7m>SqRMS)7%NbCG3``uF
f%"XH-AcUk[8F%*9:13UpB3L?c-=11.ZrCtj+:o!\^&YB]AVj;:7'Tl*G0H#K:W("[FT;<hP=
GssE4knXHPO!2`9;sh'7j7)l,,[gCKo9FZ(35Mnjc`P24hpr0g2m!FSmJ$pr5FNbOp%@K_bG
P.6>Yg2>[U%LE1!9ls_[M2JHAoNOh_\SmWe*r)Qa7\V/@H'AjSNJP]A^S3I1*OO;`XVM\F-=b
"p;K$I!H0<Y&Y%s6,q1SAn1H'h%2G>ru`[:>]A6>eS+4:Mg->.\7Kf56OF=Sj#59;^U^Y\dBP
nrJ<h"o?dJ(BAg?E:+%%m"9SU9f4um=<I;*DIqmW90[cZ@GSk]ARi>Stluo8bX<Er*]AM`t)$Y
gan-O\*8P7%4-L_rqrA~
]]></IM>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</body>
</InnerWidget>
<BoundsAttr x="52" y="207" width="100" height="28"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="tiaozhuan1"/>
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
<WidgetName name="tiaozhuan1"/>
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
<![CDATA[720000,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
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
<Parameters>
<Parameter>
<Attributes name="org1"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$org]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[window.parent.FS.tabPane.addItem({title:"支出详情",src:"${servletURL}?reportlet=ThreeLevelPage/jxjl_zc.cpt&op=view&org="+org1})
]]></Content>
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
<Parameters>
<Parameter>
<Attributes name="org1"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$org]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[window.parent.FS.tabPane.addItem({title:"支出详情",src:"${servletURL}?reportlet=ThreeLevelPage/jxjl_zc.cpt&op=view&org="+org1})
]]></Content>
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
<BoundsAttr x="785" y="245" width="69" height="25"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<Listener event="change">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="org_code"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$org]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[
    var baobiaomokuai = "业绩分析";
    var fangwenlujing = FR.remoteEvaluate('=formletName');
    
    var fangwenwenjian = FR.remoteEvaluate('=INDEXOFARRAY(SPLIT(formletName,"/"),count(SPLIT(formletName,"/")))');
    var wenjianmingcheng ="住宅供地分析";

    var org_name =this.getValue();

    var canshuming = "org"; //参数en
    var canshu=org_code;

    if (org_code.length==0){
    	 var canshumingyucanshu="";
    }else{
    	 var canshumingyucanshu="org:"+org_name;
    }
        
    var shifoudianjilianjie = "否";
    var lianjiecanshuming = "";
    var lianjiecanshu = "";
    var lianjiemingyucanshu = "";
    var daochu="否";
    
    
    FR.ajax({
        url: "${servletURL}" + "?reportlet=HX_JurisdictionAndLog/loginsert.cpt&op=write&format=submit",
        data: {
            "baobiaomokuai": baobiaomokuai,
            "fangwenlujing": fangwenlujing,
            "fangwenwenjian": fangwenwenjian,
            "wenjianmingcheng": wenjianmingcheng,
            "canshuming": canshuming,
            "canshu": canshu,
            "canshumingyucanshu": canshumingyucanshu,
            "shifoudianjilianjie": shifoudianjilianjie,
            "lianjiecanshuming": lianjiecanshuming,
            "lianjiecanshu": lianjiecanshu,
            "lianjiemingyucanshu": lianjiemingyucanshu,
            "daochu":daochu
        }

    }
    );
]]></Content>
</JavaScript>
</Listener>
<WidgetName name="org_name"/>
<WidgetAttr invisible="true" description="">
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=sql("oracle_test", " select org_name from dim_org where org_id='"+$org+"' ", 1)]]></Attributes>
</O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="0" autoline="true"/>
<FRFont name="SimSun" style="0" size="72" foreground="-13312"/>
<border style="0" color="-723724"/>
</InnerWidget>
<BoundsAttr x="186" y="5" width="80" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TreeComboBoxEditor">
<WidgetName name="org"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<allowBlank>
<![CDATA[false]]></allowBlank>
<CustomData>
<![CDATA[false]]></CustomData>
<TreeAttr selectLeafOnly="false"/>
<isLayerBuild isLayerBuild="false"/>
<isAutoBuild autoBuild="false"/>
<isPerformanceFirst performanceFirst="false"/>
<widgetValue>
<O>
<![CDATA[]]></O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="46" y="5" width="106" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="label1"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O>
<![CDATA[组织：]]></O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="0" autoline="true"/>
<FRFont name="微软雅黑" style="1" size="72" foreground="-1"/>
<border style="0" color="-723724"/>
</InnerWidget>
<BoundsAttr x="16" y="5" width="30" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report6"/>
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
<WidgetName name="report6"/>
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
<![CDATA[1008000,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" cs="2" s="0">
<O>
<![CDATA[住宅供地完成情况]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="0">
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
<WidgetName name="report6"/>
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
<![CDATA[1008000,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" cs="2" s="0">
<O>
<![CDATA[住宅供地完成情况]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="0">
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
</body>
</InnerWidget>
<BoundsAttr x="16" y="245" width="250" height="25"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report5"/>
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
<WidgetName name="report5"/>
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
<![CDATA[1008000,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[4800600,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O>
<![CDATA[当季预估]]></O>
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
<WidgetName name="report5"/>
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
<![CDATA[1008000,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[4800600,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O>
<![CDATA[当季预估]]></O>
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
</body>
</InnerWidget>
<BoundsAttr x="556" y="35" width="139" height="25"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report4"/>
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
<WidgetName name="report4"/>
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
<![CDATA[720000,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[1440000,1440000,1440000,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O>
<![CDATA[当年]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="当前决策报表对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="dim_cal"/>
<O>
<![CDATA[1]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report0"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="当前决策报表对象2">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="dim_cal"/>
<O>
<![CDATA[1]]></O>
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
<NameJavaScript name="当前决策报表对象3">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="dim_cal"/>
<O>
<![CDATA[1]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report2"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="当前决策报表对象4">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="dim_cal"/>
<O>
<![CDATA[1]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report4"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$dim_cal="1"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="4">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320!n,pj/B>R2,ZAq0Y6.\mSh?$H'm&6gfZ8D)6%Hp/X13;q,Gc5s%h
H'K(>4<keK;+.ks,,.b=jtlp0uV_#m\)p\]A*-!#f"ro]Al<[Q'<AR3:;hlWE5k\S"&5Nf@QG)
C'+S4=/7!%fm*\h'h;>"6[#2]AKe^%ft;aM,t~
]]></IM>
</Background>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="1" r="0" s="0">
<O>
<![CDATA[当季]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="当前决策报表对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="dim_cal"/>
<O>
<![CDATA[2]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report0"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="当前决策报表对象2">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="dim_cal"/>
<O>
<![CDATA[2]]></O>
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
<NameJavaScript name="当前决策报表对象3">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="dim_cal"/>
<O>
<![CDATA[2]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report2"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="当前决策报表对象4">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="dim_cal"/>
<O>
<![CDATA[2]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report4"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$dim_cal="2"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="4">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320!n,pj/B>R2,ZAq0Y6.\mSh?$H'm&6gfZ8D)6%Hp/X13;q,Gc5s%h
H'K(>4<keK;+.ks,,.b=jtlp0uV_#m\)p\]A*-!#f"ro]Al<[Q'<AR3:;hlWE5k\S"&5Nf@QG)
C'+S4=/7!%fm*\h'h;>"6[#2]AKe^%ft;aM,t~
]]></IM>
</Background>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="2" r="0" s="0">
<O>
<![CDATA[当月]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="当前决策报表对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="dim_cal"/>
<O>
<![CDATA[3]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report0"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="当前决策报表对象2">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="dim_cal"/>
<O>
<![CDATA[3]]></O>
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
<NameJavaScript name="当前决策报表对象3">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="dim_cal"/>
<O>
<![CDATA[3]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report2"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="当前决策报表对象4">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="dim_cal"/>
<O>
<![CDATA[3]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report4"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$dim_cal="3"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="4">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320!n,pj/B>R2,ZAq0Y6.\mSh?$H'm&6gfZ8D)6%Hp/X13;q,Gc5s%h
H'K(>4<keK;+.ks,,.b=jtlp0uV_#m\)p\]A*-!#f"ro]Al<[Q'<AR3:;hlWE5k\S"&5Nf@QG)
C'+S4=/7!%fm*\h'h;>"6[#2]AKe^%ft;aM,t~
]]></IM>
</Background>
</HighlightAction>
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
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<IM>
<![CDATA[m94p7;ca_>1E*:qW?"2'%;B[]Ah%lc[=Hn2TYuS9+h:A^:-ra$*'#]AZ:0SG+FC0X3I3f8_>CM
cr#d0R6)P)fr)ln7K8it>fH&PtfQ,X`7Xo(D\WF[U:h#6o<oC\`aRHh6[;pRLjPS_lI%mJ^e
P@\5@UA%]AIeI$QBfoWa`!No9$\h)9Qn2UZn`j#&JCEq@^Jn#]At=m:_C2F>W6o_tCJKi73=H?
XKdZ_n9Hsg_=;>p!+YmrF<Np+.;7*7_73b("5:!FSit:e%Xp>:J"ZniT'JC%EFmamF613R_P
)9FeXLG]A@-,KiOEq,A_,u6'0<Zad6<nFKNbCETTu/[P`d"YSY<b?mhQoR,>B?NO$3?e#%-6a
V<R%M^8(5HK_C037e-(iEV0b5SpXe.\&nZ:Z(g@NKJr7u\HUQo2XY1'`m4RghPKe\8/&26%=
WS6!F@6qW?eWkU<BFP90:Rr/TfT=X[60b-r!W_illR&[Xdm#.E5Q=[bZ17a(:i3-3i1Xf<iY
O!lgSi:ZWMjb(^G2O\J%_1fZK2$esmdL$ZE2Mr;>Fc)H@Y"ZePONt5Q#qm*2PL)NaghRB*fB
$W$<-u?Pi/NHaZLmfd,=Yu\^O84sO!A3:j]AM/W"ToDh<@?$3+;B0$o2k;aE)pP*VjgBd*"0o
u8WCj(N*uqjD^%`;I55KLXgZbY-eo1?m*@IufVBlI#/ZY1_RokUQUbYe:U<:+#P^(r<>rJnL
5<Gii3Fl:s6^OgcEVFJc2(ptfbcL/+[D[L1:S'n/mJN\-KRa:%nf2nR!7`,gG.U@h/8`K`,[
+U*>Yg=:f=#Zq7e*J34]A1R6WdnVcWs2.UcE"A9c(aEs0(g--V)"%U.*0f_$5i/9(U"O$)JEI
uME2CD7'2;Sge1X*D#>sm^IZmoG=u3ITn%ACV5^o]A,UXD_G#<WlWth$Dk[8f6drNu]AD97=[B
MU!;am#E%&Hr#K[_F3&)G5GT_$$&ph=7r(hGbhFgIdpFbbc:s'2k-1>TIQS0.sEb8JP2[m[Z
RraS;UJCpdR7;eGI&3&\j[f?1#qRBd#g[a)WPE`JUn%&/L-+%aTAV7QCX8V)%S&Q7dt]AJ7o\
\^%gTCE*"%r_DZD;X*Wi\\af+8q30qNHc:iM>"M0KKU9c@^(?r4QP2r$ui'TOJ<fFb*aoP*5
?^+bkZ!'X.."9]A662g/n;G8IS\3DoNhHEb?5GK^nZ_RMdD7&CWh!bF]A$WmR+$(m=(M)Q&uFE
*'"-cZZK;C_,bN7*X+)+F8M'Q]Ah:u!^.=O5H<_4X7>TYq*K\TpeQWhOEAD4PomdQ&\aX)K#X
0J=XX`bf(`T?86>]AYDLoLIKsZ\3ZH6@T6HmN0d+-Q^6'rA*^9V$"2QKGoH/^=L!UaV/'toir
B@EMG_g&KUL0?fWW--*m([-Z`IX:%DE"P]AJ/Ep$t/spG7Tr%ZF_O(&<pWe/&FVCkoW&)l!:H
$KbC5[lkmOh=ntH[JMC3J9E^'Eru)d7:Vi1A=s;bP3hW/ri39GIDcK!af_sQMT+,IICpQKI)
FOOY%k2h0rF4;GX*@d1n$<Q+`H*fg23Gt.aqXa?]AI^&1>X46=j1-l2HVjiPEL8+]APIjds/jn
EK26&%_fH$JZ(rG]A`lNim3-:DQo&H]A1\eW(#R4WCT7F.N$[e^9/!UA0'N4fi8k*3JeWpXho^
&YoA-,`cN=*rZ*0Pf$>T)WFYi5gc`1BF93n"PSI#r$i)`CS`u;bit"AohM,;9sc'L&aC>XsK
((5nCha=tsse<'O`]A()63<bciNu^5*k9'\u!>FB`b_P.)mqo4Z,aUKSAr2]AtE8'-%<<,eKW%
3DQ"Mq"^LC:I!X"*@bh9N?>Sa,JF\(Fo9o[#eXf48LRg-[l0LEXrN4Z<AUc]A2?uDiL-7=IYV
kO.%M1&/:.uA]A>J^TT3HdIfP8;knJ>a@C8`XSY4XR`er@@[-o9$'.8B[g+T!e77RDZE,E8:&
*&.jOtQFP;KM0"@S,JXT(c[s-ni*+PlhkF`3KaJ)T7!`b6p`aP]Ak_6J=g;D9r7UE]A\*klEO(
6Q\H!K<P,me@*\$pN!V/\=S!7Vt;2'eP"8\9%*rNI,!m#b`u30e6PO`.-!S"*L&>&0]A$C"dK
WnI0S$jFF<3'/1]A+$D^ZfBR-=<NPRL<OJ;m'*q`/%c_`]AIQ=>UisCtrY:)#o56/Yau&[8C<;
_K:I-^9_c^>eC_Pd1&9=*S4C=9Yd_5A315oL/Muf#+DD'!rgC`4lGfq4'n)V(bZ4^)R+P5ji
UlRBB?HB5(&.0/`2o>$BgW>ltFT_<<Z?ZcU7nC93Jko^TfS/[A;._+KhuY%h(lrrBHVNBi[o
uW85q`g/o)c4r0/<40A<P`*0c/)J58t7eb%2agX<(nLV+1(a`H+jeMY7+@5^j96?GDBh,Xt[
Y8R#Dh.L>KO3pIisfhf9ph#aplEEf]A0MPYNQBn6Nm!OIfJYAR%eBb/Y1G4FSV3dmLRCS_mWV
ap=LhgZ[=HT7Za+$RA9CE$Z54lS2Gm"IIRNqr;ou!E`#EnjFuJ^ECi!*:F[&2/C@s:11ukT"
4=p1O_u,1]AF;Ck`:@`0#q--d/DQ(<E+iGRrPO=R(9-LqDc..E2/55;M"e?9^)PLP%Md*f$r4
O?^Up!ncLZsp+@<ecGAFL$M7IF,ACosW&WtDpa_0Up;E_\.e*0t7KNo]Aq&77(7FL;&qd*7b`
C/e#[7eC9bUHMQN"Kn$0'o?oU+VJ,7q$p.W-T>4u5O@um=FDKjr(tGh"'AA&cjiqOl#u;e2U
iojpe03FHl0jeRqg_iBPT'Q:N*A]AiQ%*3A%%/*<GjOj;jRSG.Di=K-;&_8.Gnu\6i+((u,a>
>dkW^X6GngVsCciQNe1\(0idido=[NJ*;gdL/%dInI><Gu`DT+#MIH7S"6Q!mmO;\s/UZOSc
NEN^9!Q!eUpnsc$8gU;o<&K7@&@(dDe]AuRkD3e4'9f7k>eZNo?j0>[pLs^gQ,[qU1jtk.j^!
;S>q&7kZ=*g1YBd5F6IL#$Li4NGT-,G+B80EJ%1#;n94/<Cn6L2m`.8tZE3"l;_L0-,.q;86
<VbjLGq`X)uISVL[P=FK,/?p#rk0-[eLu"t;=(L^[ZU>Q`?6Z]AUi7K=FU*^A^;$AT'*Smk:,
iS"k9qVEQgm,*&iH[Eo*:W4kS\+iV"@eldZ+&%!5=VIuLS>+R7/.P:2"8cKG!@#Urscu$!.i
4?`?IX!3Ds!sbW8ETEbu1LLCb5eMpl)!LLQj(%r$DW,jf6Xr7W;bf-f[s8ef_k-Ca)'S$oI2
_OTI5A1XU#OBLS^&]A/?iCc.lJ3+:Cf0tob9!h`=(FX*jJV>tr8Br)3>H880KqsbA+%14NJe.
d@>bC3="$$Z9]A^0+,u%mc3qf\<L`Bm6^!$B7p,7%S9fkP-7;H@Y`Zf]AqC%i)HTOOGRX.-*[8
($,/j1I1qdg&)jA]A;oiu]A@'H!4RIS.Y/e@f^R]A#[9[?)Wr9_pbqE<JA0"C>(H>SYU4dP2/Bg
KnO,,Zg33RN(+m(6/pGRC3-,Nd/%hJDts%jESK'?n>1fZ4Ot.(`NdgB*?R"fMAm/*qINZofW
Pe*#B]Afj*0&;jr`s_23laR@=+3q^R#28Y9GJ%4GVVnBMVF[_dM)5Vp1k\g(r+GT+&AOqBl*p
V`t"d]AQJOZ7knMOF)RH[1W9I3NH&COV<B&Gi.j^%ms&c5TBPP8nhFQP97orJrf=/&`jI(#\q
`hFcT]A2^4JpAE_d@-?g&`sDir9n8Dpt;,%-1l5gHF+sl,1m?=Fce'Q`[5BB7M$6-Q+?'g]A"i
lG4@Q@0;"DPN;$g"5+I1M,!V$n5uLb@SilLn7oHpY+.bf%&rOsblY/\tk4B:tp@6HY0n4\K=
n#"U4+H29qC,A&aKdbchs<b$)=sGq#OMHo`;9,eIr/P2C0h8%?r<k2E,Rn".X#*tXg.`j<"/
$7Ta1g-PcZHh,`mI)&E5u"c,CRZ2e1+gZ0O`hYeR%'03`PlO'd;5?N~
]]></IM>
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
<![CDATA[720000,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[1440000,1440000,1440000,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O>
<![CDATA[当年]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="当前决策报表对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="dim_cal"/>
<O>
<![CDATA[1]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report1_c"/>
<linkType type="0"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="当前决策报表对象2">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="p_time"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report2"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="当前决策报表对象4">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="p_time"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report4"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="当前决策报表对象5">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters/>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report1_c"/>
<linkType type="0"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$dim_cal="1"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="4">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320!n,pj/B>R2,ZAq0Y6.\mSh?$H'm&6gfZ8D)6%Hp/X13;q,Gc5s%h
H'K(>4<keK;+.ks,,.b=jtlp0uV_#m\)p\]A*-!#f"ro]Al<[Q'<AR3:;hlWE5k\S"&5Nf@QG)
C'+S4=/7!%fm*\h'h;>"6[#2]AKe^%ft;aM,t~
]]></IM>
</Background>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="1" r="0" s="1">
<O>
<![CDATA[当季]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="当前决策报表对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="dim_cal"/>
<O>
<![CDATA[2]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report1_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="当前决策报表对象2">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="p_time"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report2"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="当前决策报表对象4">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="p_time"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report4"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$dim_cal="2"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="4">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320!n,pj/B>R2,ZAq0Y6.\mSh?$H'm&6gfZ8D)6%Hp/X13;q,Gc5s%h
H'K(>4<keK;+.ks,,.b=jtlp0uV_#m\)p\]A*-!#f"ro]Al<[Q'<AR3:;hlWE5k\S"&5Nf@QG)
C'+S4=/7!%fm*\h'h;>"6[#2]AKe^%ft;aM,t~
]]></IM>
</Background>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="2" r="0" s="1">
<O>
<![CDATA[当月]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="当前决策报表对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="p_time"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
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
<NameJavaScript name="当前决策报表对象2">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="p_time"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report2"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="当前决策报表对象4">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="p_time"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report4"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$dim_cal="3"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="4">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320!n,pj/B>R2,ZAq0Y6.\mSh?$H'm&6gfZ8D)6%Hp/X13;q,Gc5s%h
H'K(>4<keK;+.ks,,.b=jtlp0uV_#m\)p\]A*-!#f"ro]Al<[Q'<AR3:;hlWE5k\S"&5Nf@QG)
C'+S4=/7!%fm*\h'h;>"6[#2]AKe^%ft;aM,t~
]]></IM>
</Background>
</HighlightAction>
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
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="64" foreground="-16776961" underline="1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</body>
</InnerWidget>
<BoundsAttr x="405" y="47" width="128" height="20"/>
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
<![CDATA[1008000,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[5753100,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O>
<![CDATA[产业供地完成情况]]></O>
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
<![CDATA[1143000,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[5753100,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O>
<![CDATA[配套取地完成情况]]></O>
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
</body>
</InnerWidget>
<BoundsAttr x="16" y="35" width="250" height="25"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
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
<LCAttr vgap="0" hgap="0" compInterval="0"/>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="report2"/>
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
<![CDATA[1296000,1152000,1152000,864000,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,2743200,576000,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
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
<C c="1" r="0">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition"/>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
</C>
<C c="0" r="1" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="1" rs="2" s="1">
<O>
<![CDATA[组织机构]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="1" rs="2" s="1">
<O>
<![CDATA[单位]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="1" cs="5" s="1">
<O>
<![CDATA[2018年]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="1" cs="5" s="1">
<O>
<![CDATA[3季度]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="15" r="1" cs="5" s="1">
<O>
<![CDATA[9月]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="20" r="1" cs="4" s="1">
<O>
<![CDATA[3季度业绩预估]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="2" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="2" s="1">
<O>
<![CDATA[目标]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="2" s="1">
<O>
<![CDATA[累计完成]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="2" s="1">
<O>
<![CDATA[完成率]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="2" s="1">
<O>
<![CDATA[同比增长]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="2" s="1">
<O>
<![CDATA[2017年]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="2" s="1">
<O>
<![CDATA[目标]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="2" s="1">
<O>
<![CDATA[累计完成]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="12" r="2" s="1">
<O>
<![CDATA[完成率]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="13" r="2" s="1">
<O>
<![CDATA[同比增长]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="14" r="2" s="1">
<O>
<![CDATA[17年3季度]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="15" r="2" s="1">
<O>
<![CDATA[目标]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="16" r="2" s="1">
<O>
<![CDATA[累计完成]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="17" r="2" s="1">
<O>
<![CDATA[完成率]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="18" r="2" s="1">
<O>
<![CDATA[同比增长]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="19" r="2" s="1">
<O>
<![CDATA[17年7月]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="20" r="2" s="1">
<O>
<![CDATA[预告完成]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="21" r="2" s="1">
<O>
<![CDATA[预估完成率]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="22" r="2" s="1">
<O>
<![CDATA[差异]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="23" r="2" s="1">
<O>
<![CDATA[差异原因]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="3" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="3" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="3" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="3" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="3" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="3" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="3" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="3" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="3" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="3" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="12" r="3" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="13" r="3" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="14" r="3" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="15" r="3" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="16" r="3" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="17" r="3" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="18" r="3" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="19" r="3" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="20" r="3" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="21" r="3" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="22" r="3" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="23" r="3" s="2">
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
<FRFont name="微软雅黑" style="0" size="72" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72" foreground="-1"/>
<Background name="ColorBackground" color="-15704203"/>
<Border>
<Top style="1" color="-16174771"/>
<Bottom style="1" color="-16174771"/>
<Left style="1" color="-16174771"/>
<Right style="1" color="-16174771"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ReportFitAttr fitStateInPC="1" fitFont="false"/>
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
<border style="1" color="-15388336" borderRadius="0" type="0" borderStyle="0"/>
<WidgetTitle>
<O>
<![CDATA[新建标题]]></O>
<FRFont name="宋体" style="0" size="72"/>
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
<CellElementList/>
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
<BoundsAttr x="10" y="245" width="844" height="228"/>
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
<![CDATA[288000,723900,1440000,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[288000,3162300,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="2" cs="5" s="0">
<O t="RichText">
<RichText>
<RichChar styleIndex="1">
<text>
<![CDATA[预估完成率]]></text>
</RichChar>
<RichChar styleIndex="2">
<text>
<![CDATA[ ]]></text>
</RichChar>
<RichChar styleIndex="3">
<text>
<![CDATA[70]]></text>
</RichChar>
<RichChar styleIndex="2">
<text>
<![CDATA[ ]]></text>
</RichChar>
<RichChar styleIndex="1">
<text>
<![CDATA[%]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="1" r="3" cs="5" rs="13">
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
<Attr position="4" visible="false"/>
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
<FillStyleName fillStyleName="季度预估完成率"/>
<isCustomFillStyle isCustomFillStyle="false"/>
<ColorList>
<OColor colvalue="-12475905"/>
<OColor colvalue="-16713985"/>
<OColor colvalue="-16740460"/>
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
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="true"/>
<AxisLineStyle AxisStyle="1" MainGridStyle="1"/>
<newLineColor lineColor=""/>
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
<VanChartAxisAttr mainTickLine="0" secTickLine="0" axisName="X轴" titleUseHtml="false" autoLabelGap="true" limitSize="false" maxHeight="15.0" commonValueFormat="true" isRotation="false"/>
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
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="false"/>
<AxisLineStyle AxisStyle="0" MainGridStyle="1"/>
<newLineColor lineColor=""/>
<AxisPosition value="2"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
</Attr>
</TextAttr>
<AxisLabelCount value="=1"/>
<AxisRange maxValue="=if(or(max(JDYG.GROUP(VALUE1))=0, len(max(JDYG.GROUP(VALUE1)))=0), 0, max(JDYG.GROUP(VALUE1)))*1.3"/>
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
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="true"/>
<AxisLineStyle AxisStyle="0" MainGridStyle="1"/>
<newLineColor lineColor="-5197648"/>
<AxisPosition value="4"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
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
<VanChartCustomPlotAttr customStyle="column_line"/>
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
<Attr class="com.fr.plugin.chart.base.AttrLabel">
<AttrLabel>
<labelAttr enable="true"/>
<labelDetail class="com.fr.plugin.chart.base.AttrLabelDetail">
<Attr showLine="false" autoAdjust="false" position="6" isCustom="true"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
</Attr>
</TextAttr>
<AttrToolTipContent>
<Attr isCommon="true"/>
<value class="com.fr.plugin.chart.base.format.AttrTooltipValueFormat">
<AttrTooltipValueFormat>
<Attr enable="true"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0亩]]></Format>
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
<Attr enable="false" duration="4" followMouse="false" showMutiSeries="true" isCustom="true"/>
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
<![CDATA[#0亩]]></Format>
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
<ConditionAttrList>
<List index="0">
<ConditionAttr name="条件属性1">
<AttrList>
<Attr class="com.fr.chart.base.AttrBackground">
<AttrBackground>
<Background name="ColorBackground" color="-12475905"/>
<Attr shadow="false"/>
</AttrBackground>
</Attr>
</AttrList>
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[分类名]]></CNAME>
<Compare op="0">
<O>
<![CDATA[目标]]></O>
</Compare>
</Condition>
</ConditionAttr>
</List>
<List index="1">
<ConditionAttr name="条件属性2">
<AttrList>
<Attr class="com.fr.chart.base.AttrBackground">
<AttrBackground>
<Background name="ColorBackground" color="-16713985"/>
<Attr shadow="false"/>
</AttrBackground>
</Attr>
</AttrList>
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[分类名]]></CNAME>
<Compare op="0">
<O>
<![CDATA[实际]]></O>
</Compare>
</Condition>
</ConditionAttr>
</List>
<List index="2">
<ConditionAttr name="条件属性3">
<AttrList>
<Attr class="com.fr.chart.base.AttrBackground">
<AttrBackground>
<Background name="ColorBackground" color="-16740460"/>
<Attr shadow="false"/>
</AttrBackground>
</Attr>
</AttrList>
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[分类名]]></CNAME>
<Compare op="0">
<O>
<![CDATA[预估完成]]></O>
</Compare>
</Condition>
</ConditionAttr>
</List>
</ConditionAttrList>
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
<newLineColor lineColor=""/>
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
<VanChartAxisAttr mainTickLine="0" secTickLine="0" axisName="X轴" titleUseHtml="false" autoLabelGap="true" limitSize="false" maxHeight="15.0" commonValueFormat="true" isRotation="false"/>
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
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="false"/>
<AxisLineStyle AxisStyle="0" MainGridStyle="1"/>
<newLineColor lineColor=""/>
<AxisPosition value="2"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
</Attr>
</TextAttr>
<AxisLabelCount value="=1"/>
<AxisRange maxValue="=if(or(max(JDYG.GROUP(VALUE1))=0, len(max(JDYG.GROUP(VALUE1)))=0), 0, max(JDYG.GROUP(VALUE1)))*1.3"/>
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
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="true"/>
<AxisLineStyle AxisStyle="0" MainGridStyle="1"/>
<newLineColor lineColor="-5197648"/>
<AxisPosition value="4"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
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
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
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
<Attr lineWidth="0" lineStyle="0" nullValueBreak="true"/>
</VanAttrLine>
</Attr>
<Attr class="com.fr.plugin.chart.base.VanChartAttrMarker">
<VanAttrMarker>
<Attr isCommon="true" markerType="RoundFilledMarker" radius="3.5" width="30.0" height="30.0"/>
<Background name="NullBackground"/>
</VanAttrMarker>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrLabel">
<AttrLabel>
<labelAttr enable="false"/>
<labelDetail class="com.fr.plugin.chart.base.AttrLabelDetail">
<Attr showLine="false" autoAdjust="false" position="3" isCustom="true"/>
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
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[预估完成率#0%]]></Format>
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
<Attr enable="false" duration="4" followMouse="false" showMutiSeries="true" isCustom="false"/>
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
<newLineColor lineColor=""/>
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
<VanChartAxisAttr mainTickLine="0" secTickLine="0" axisName="X轴" titleUseHtml="false" autoLabelGap="true" limitSize="false" maxHeight="15.0" commonValueFormat="true" isRotation="false"/>
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
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="false"/>
<AxisLineStyle AxisStyle="0" MainGridStyle="1"/>
<newLineColor lineColor=""/>
<AxisPosition value="2"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
</Attr>
</TextAttr>
<AxisLabelCount value="=1"/>
<AxisRange maxValue="=if(or(max(JDYG.GROUP(VALUE1))=0, len(max(JDYG.GROUP(VALUE1)))=0), 0, max(JDYG.GROUP(VALUE1)))*1.3"/>
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
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="true"/>
<AxisLineStyle AxisStyle="0" MainGridStyle="1"/>
<newLineColor lineColor="-5197648"/>
<AxisPosition value="4"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
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
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="1" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="1" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="1" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="1" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="1" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="1" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="1" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="1" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="1" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="1" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="1" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="1" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
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
<DefinitionMap key="column">
<MoreNameCDDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[JDYG]]></Name>
</TableData>
<CategoryName value="TYPE1"/>
<ChartSummaryColumn name="VALUE1" function="com.fr.data.util.function.NoneFunction" customName="VALUE1"/>
</MoreNameCDDefinition>
</DefinitionMap>
<DefinitionMap key="line">
<NormalReportDataDefinition>
<Category>
<O>
<![CDATA[]]></O>
</Category>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
</NormalReportDataDefinition>
</DefinitionMap>
</DefinitionMapList>
</CustomDefinition>
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
<C c="1" r="16">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(or(C17=0, len(C17)=0 ), "--", round(D17/C17*100, 0) )]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="16">
<O t="DSColumn">
<Attributes dsName="JDYG" columnName="VALUE1"/>
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[TYPE1]]></CNAME>
<Compare op="0">
<O>
<![CDATA[目标]]></O>
</Compare>
</Condition>
<Complex reselect="true"/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="3" r="16">
<O t="DSColumn">
<Attributes dsName="JDYG" columnName="VALUE1"/>
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[TYPE1]]></CNAME>
<Compare op="0">
<O>
<![CDATA[预估完成]]></O>
</Compare>
</Condition>
<Complex reselect="true"/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
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
<FRFont name="微软雅黑" style="0" size="104"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="104" foreground="-16711681"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<IM>
<![CDATA[m<f4B;s2_LBR1)hP/M+3aqUds@T63%+J]A&R9,58DPt=5/KRh9V6Du:EMC9l=AIohX;%Sj-&n
P%;"9]A,Y5QhL(NXR'B1Aj4Y/.&-8SH&T%pHJ=sDYNb0Fmkmi>MiWQHIoe&hObSpm,+T-m@%r
Z+HXHH$Sr_5#RgrhjSIr(!,$U"T5Fd_IX/<Pm,p_ZW?[tt5M"+>[#M2?7t85H:;uY_4pMS!4
D"df4Gc4_G]A'6s[F^V-RRJ"0(#?uh%83lKe?>;UC%TnW+2)@]ANN_Wte=HS]Aa:&JC.E2A&F]Ar
^1Odk=+Dmki!&D']A.\d`8L<%H+pjc5:+*uo[l@iO2q)R:(aZ$/TSh[Y!;EJ*`A$rR`GRL:H!
34q3<8:&BnPM*Bs3ul%>K>Y>lQsnU*)GEd+o$,s`FZAD`BGJL"_WrWae.#ULgg6&3g.U<Z10
jeR:e'))iPr+.F\(."!bSsQ3.]AX%oD.$q.T&ZgWIFUEUT1"LgQq6%<`fA!I/)aImR0bf4^U?
fAEGk:DoFu5EE>4ZGP$HtrG__/\?/]A'p^4eRik.!ajJnT?V?r@]An,tif0Ea1Y57Nf3GI7;W_
=+<BfGApg8h"*O05,jrS%Wqo.[[r,iY*/i_;<puC+0DeqiKn'RLsT_SMbPpjX$'RCM#`8_E8
aY=a+G:q-Yl1Wr.=Y`oMam4"h_ME4ZMQH_Q1V/EID%/6=_!1'[IR#,Un7%[`nA<?\c!c*4aR
UNqQ;2/?F_4'#Rg'-pi^@'fPU-p/1J^N'Gop6R:<k!LX?`+-qLX6o>R"?Ajpn%'E$Dr3AN]AB
h5[l.RC,,R^0Vj1JVsN8=j6lj@+kre!Bb+5#F92Q<RcAp@hN<hZi?^<a1?fMcY[X#9@G7c:P
0/_MWr>@0fWjk=H9iBJg-pPICIbmg7O$p&?(jIe>Fe=pJ;q#+^'456Y;hRe.%940,0h3u]AXr
QuHW2]AmGDh#j^;a)>n3<'W9HR&86YVcc94I:%S)o-pQ%eor+#c^GlHC@?3;ihQb68ILAErWL
&u85'DFJ&@;XcN^?k``3Th.`5kK`@bo3P63<tbiqu(;5Dg.Za?G!6%WI+W"sR7IB703mQSO0
bLFc/.Zh&GjqkqTMiHC7kp>nh/f>Gp=e+$K(&FGY)Xg?+7t>O]A?YnD/PAqKVWG+QC4=OHO2K
2JhH#_8/Iiq4aBtsO!Qu.<u)P$YeN!,eAq[B<$R8u0ucMY%2j5o0Yd,Y1s7;:@i(UqUpLHoJ
JQ.kF#p0NZPI?;"W__gpjB3XA^n\6&f#CAa<^9QEJX!`<\jOO:uP>=r*UNLng!M_j5<i3cpH
5Wi5rL\B+jZ*)J#iPA'5CH]A&r3G9Ws6c(C(gP5<;i5*G%FrG[>!qel`[>:VJA!%^:/3fB+&M
b#`@#Sn7!iHd^Q@bAlh0NN%=L6[08#TY@8M3-X5tcfl!ldcPY_,I!T\%#Gf\*N0L0L^Mqlh5
%lV>l7+Jfg(sOl@8=f/J)rapTclRMPn!\S.o1Kdcq%]A"IM(N^h^G"%`5>2&IYC3'Gb^B"03U
TXIR5f[d+%UhK\$+.?k<m]Afk4I"'e36aqh5$XYiB]AXV-_\8/&JI.SW7MWhohVXXBl@FHEpYg
JmM#<O2epS3^;)Em,U_Srg;`9V-`GQ?9a$Lr-rUe.IXs;]AB*H>(R6=d2,ca$Q%#p;eGDuju*
=qQNN'GK+2D@e3+2Kub=W5HskZ9ag\p9#6n\T4=#N&'JG89[s;bW,P/E28tJMP9q<;X=ai?-
qps.Ie*k+<K>m1OT,e1,/,R5TjN+4(Ou9Pl[%N8pdbASI;<:`io'9[G^N1s\u?JuNJ03jm1r
,OWAik.QpXYYdDlA[lbO5c&mR7ogoZEu3&E(Oc>N0V:]A6[LQ2P'GU@i2Q=5"%Mj.3WJ%K=.9
IqG_G@H!frfA"q`GM?T!8C!EfWKSZQPS%fBa4CF@;2,1qbloh[[Jg*tnpm%@K=r-.Wkm"Q9u
`b5IG`Wl,!kM$r[sZ*VR:`CGreXZC-S3+FM\AS(aQNn.fEQYT*SVEUgc5%`tgo_+7n/-"STY
r*W8B#oXP0/$H-@^FBgo@141%>W"=bQP,,,heSZU#+qVBL1p(=oP!?IaGYl+nMR+c>[NFQRH
92Y(9j]A_mAq7BKAUGQe=tW5Rr&T<uhl]A"X5G_9h;s/UcWk!UZ?C9!1W8%N5<UXp<5-;ZYut,
Yh^BmSLA/$#^]AIZO3Yg>02Bfsm!V!h2uH3X?cL7]AKKYAY+Ydo+(bT$u8`[p_je@d)H+Fj@H9
qGdpj9CpcR9blnr-VZ,C^R?$R8L>Ebp@;NiLp,&5'uI?UadQGA*$%JS,>IRZA_T(7fg@TPDq
2ZARP.FH^NR:\EC#)J$s3[!H".QSUDbXjf,f;)lGEn(cX6%,YZ]AM&hH\UVnSL)jh$mM1.^e<
3i8g]AW&@L,N"3RcoB-P1om:9=]Ao.fc?-/1ho2a"0p"qX_]Au5)4;Gb(PLIm[E(&'u%GnG06Aj
=m1JU,FSB?uW+o$-A#*%RTPWfju4LmIn2!P;^>lQ0HdCJ\T(nOdPjk!S$*)Gk"F1*'C2QW$]A
S@H<tlCaiD1W-;W6E(r67o"#Y",n<_gl)%u0q1Sih!L[bSFW++2QAKdRg*tG84G!lJ[p9qOY
EW(AdVh=VF6sN/p;j,^fAUb05!Hh)5DMhhdXkl7O4,^pZ/01BGT<!M^t*ul<LC##>-L/+\@_
.9"R'PC$<SrTHQ.SOQP9!$/*@XqVEL[K^YhI&D5`mF;h!mcdS4U[Ia2CrUk]AD<SeSe*o5JR1
NIRZQ-dP_m;p>pTh2,86fp`U2`e:.?bdi[U.*!D9%o9_SU5"6n`ma='M0*Eo]AQIbg%U5+$PK
NERn(=W$9"NR\!Z6`A6Te`KE\[=Df0b0:Y`i+.q[qi=5%6BFR<Dd[#BIBe)oG,Po$Dure]A+o
hti--=Q?t4*U\,no_EV9f&b]A8:&l,*s6Frbo4jE26L#)"0f)'tfQ;6]AIt?+5-?dmAguYruI-
hgtl2WTn_o/\8T#c[g0uOpe);j6<8WV-%MG_-f&BM3"^#WcqeGV-(*$!3l%Hh12d&-@=(sam
rJh[$/'>[BOOa=32Zf.!EBO@.qLp53+iJ_2sI`:B`'?]A!opN`Ka*<GO0Ds=njU=*I&pX7o1G
3Rp2B=k=60,4V+Q;gC,Ad#GroNCs.ec>-kJ?(pLCu"7!F/1IGF'*Hm>n6Vfd7?m2b>=EV+j,
G!f0gWeF&pHhQ#e`o>-G[&(A&"3d,;?<:Hje'[&PIUYo.#sV"ni-R<%33$T4=G>)H<\f7?IC
>c'imBibl6=0?SZl;_C-O,!pk%1S,cC%[V0GNP.Wcj6c4+=$g]AWBrB.*L"6*6n`"+?%GbQ_<
MS6lZo,p>0=%TJ&bGrc6V!\.nRa7M`M!9\JRUh31#4q^r\XV/iu,'FA9"F(p+tjrF`m#kJdU
B)W/oHUn\9PjKS9-&\mA4WRt@:VasWFiOJ/rAX%JHZ1eS-**NM=!uT^olW>HW^aFV`q(%n%A
jTG2!%&bD)D6NK%*hEX180!+?X2VrT@I\K\'<I,S7roNTQsm3@o#%]A`MD6-7:]Al_l2&Tq<C2
:(%BQPS3+>sNlELceh-/5tfS<5a37Np+rd0a#DTa8UqE@=`lZHX^U[dnOc5@t\4)e+\M:G5(
1+B/m$!2"P3E*"k`@R#iU2nW1qIFUX$WkF\a,Cq/AdH)uOb"UqXT?(pChtMf;4,NV:m7t</u
Hm6]A/cIbkO/,IDkB)dZKU(lm;0ephC%DS=r3jEijA[Vb2qj.i&:Z+XA6#lUS',5j"_u9h`t!
(_#![.T++4$VqB`K.9;(`U^8rWBZPL=U7""\A<<MGE)VQ%%(Reoc!-h/ZVqEr7&pHmD@C.Sg
QX='qAo@iC%^pmbi2=JrZf^k6c[5A`<B<UZ,J<EncWAsk-,rOXI5<@=.$EaXY%Vu'Di\qFTf
]A&gkF2N(nq0PA?cNi+oQjRYH.M+*1K[F[Op(7Kh^!gDrTao'7K&RpV7fk$r1*j3mN]A)]A1EE:
KULr_UH]A_ER1%'BMl.q73j@PR.Hmk\Tr6ie!$etDU6<VroWM*J!T)T4o$*dD$-DEW('h)B&p
?3\'WHI"%D,VC5%Qg\G8i#>7Wjku`fHq$8XZ)ZhSZ-1Re`0.F)N"TVi+RCH\Yq>9,kr11"f&
AqM\)n-./YMEtc]A_*LL^(W8aN/)B/4+0KkD>LgnVsfrg]AZE\cc!;K5UupcZ\Fr/Di/e#D>@+
KeGCq;pEn6@`-a<-,J)%:R3ULe'H'I^TWShl0P%H2QhkSa,C+9B=:iS::%G1K89>m]Afc<Y43
)i&,VJ[-WeZ"a-[]AS%l&EXeC_G&*g7s<PGe6&6op#=7\%e'K6S<"R[7EK954q9FUHm\J>>Th
K"`OU*[G8udf$T!&;gjrF1HOt&kTXm4?Sng]A^#kK;"$6EK$<oGKm3@rWf=`BmBGZa%YS,ZMA
/J,=m%i]A^<RVO@r:QG3bbKpg%oVlVctVH`QT1N5G><lXJfI5!,5W5;uF#41T;hE#Efk_4BgH
N6udb*L.%!9'==D[N'^H0T$M5(o<Z_t7`kB**gj?8Nq#Au@?gdo@:!8eraSgj4QgWRFiYEfj
HMtNM!jmA<"Sd$g:`cJg(LIaer?j..q^`6s$J&?I<+h9j38O'UKfP*lJtYtJ)]Al?]A$BMnV,D
20Vi[D6Di*-0k3!8T!S?t+nQhjfG@&%',6UM\O_LD/[848:0!jf+^Ds>`:X7MH8"[)4e/DIb
[O_\fXVJ5>oSl@H#>atm,)`+$^"$ts#of<d%Yl77h:lblT+R;7"CQLBj$Y1K.5[,BHQY0*U.
UC)4EQ<0+Sb"<%^Zer4"Cbqa2;?"[gIntDjXuNR133YBUIf;"FU0NGg'i6s)sX?mf*0q[`J3
;P*+\C,OX=D4`34&TNFmQ&gu'A9GTA)JpS]AW5^0oDmZNUID@`FLJ-\d$0Mf/JT??h#%Tcbs^
>@T*DELsp'LuhU4C0acEW$=YrrmP1DV0J;G[uO2abSEZOhuW\Df+I5$r56)fMGQ!,WEam:D?
CH5gKXU+rQT0jT'(cRgdSin8p_`ju^:9'SH>RnKBBUQB<EG^Pq.JA>B^">nBQ!WB"&GkqngY
;[>bQo0kJo3R6$tkQa;\<nr`-55N&`=X7VTc^.fSN\:rg:6/rD/J<:)c/54R=M%X?.dW"90$
i-fTF]AalA)U/]AF589c=V3He^tEq:o?gn+Jid.m/H`R*O4nm'!PRSl"fQ[]A9n1t+D'&m`X/ln
;EEHZcHoU+/=`3uGbGW/0.d7Rio0D-On3e3[>`-i)Qs)(_B.j8Lj</$6$^D#rJ$9W=+-9g6g
KQ\)1?h4Ko9U@.0[o0t1?'@#IQ<_K;5reoMApD"lTFmp]AE1PN6F.Y^*q1(j>ZH6V\cM(T_La
-(%U=;c+:GAj>AOa0-p6U/[Jta*6pPe'CqkhX!j7n_qnm2IXstErp?kF"J#!)<4PD5qjBUGF
9`V$uA4laerd*m5AROGGlP1^sqJX_L&b2:u7moV;mp'.;1BuGH$m9Mnl@6YM17X]A0!7,h$RD
1qUmX%(d&7@gWRN=NAPSXBq\W-MA"o++fT%b-P@SK2+`WemjYV_\>^uhj>0X:Jp/Z=Q[0Pg[
G6$$BFf\Dg?;_`pT+?aY:r=ZapdXGc3n_)@B'RuEJ5.s._"0NfJ*`k_M^-ohqGT^d<]A&A8&q
5m,2GAW3H(A>;/h-cD90tVV5=!BDhDnaan#1ms@E81"9@s+e::#)tP$S]AQRGhp#k;kqm?'(i
=@Lq=0tJAPf`TM3t^jkJW#]A&JKYSjKHKn\(CegQl_G9uHF"qr&Ib?b52)l@s1KjmXYjhdT]A.
nX%ORCB>b0iAM*.Mu;V#>a?;pFF_s%LiV&?6/dD*DSOiJ)Gi?tXXf7>ROdF.?g8Fqgo6<D&W
40eg+<IiTXh!EP%@DLO#+";D<sJ:SRm3lh`F<:Re"cW!)JZ7_'LLV^ZBFdSsX"G!R$hN"*M#
b-nVsY?H:WZ*00fB-larR/)&50cal/clX;1N3&.&Jk>HbX"%,,Pbi&0d":1oXX<[T!pY9)#7
G;NRpn#=)i"8j'(?<#]A?$:%\;n/m4R[?<f'WY`X!bbed0fceI]Aom>3IXm)f-I#<ZkR2_Eijt
ZgM$*.Z\k+J2$aKs9@k.r7(T4=A^R*Ak<"-CNV\a[f"*Hp#gM8tIBe1_:5d/;.>N-*+pAs=_
TPQ]A?1?ZcMpmM'QEENk_PDUp=bXKM'T%OOM#l_Fo`F$r==;W?jAs"8%%[Dt;@pgcE&FIB'5<
7]As/sg1:<IJ=kLtPi#i_9J.%Uh;u6#%Q.B31:$I1C'/q:C1ghR\?9F@YbTRNl<7g/f5%Vm#5
2p-E:^h">XnG7tfSZ$F'nPdSpnkaZL/:1!`G0=#DHj4"+q%M$XMs.%scK<1U*=`p]Aui]Acmi'
Gho_\[!k_m!m%W^5=$O>dIHTY3J[LQt3FhM/)(*4UdJQ&D1eGFPm0"mo\fc1$.En-EXKn(u0
3kRBT.ocAl(AS9QAj6%h,q->Z\!K!;8q'c;gA#DF8t\8\DJ>$)SGpBrttjhCff)t4c23;!Xj
#i=0khGA*n6dX%e)T,q'a91tmAJsZ0^gEG4o::r0WA`TtZb8*eV)VQic%5e(%VY4*Sn7+gS:
qP)"@J66ltPPY<"Yn!-WBFO)5-Dr+=`0l;NGud:q188nkt9+"HT/soLT]A!hsM5D?_m`uJ/2e
u4E22FLVfCEcAV)E:cKiOR@mkD`sRUa??BJ8RTLG9FDL'>KtfuEIq+!962:U>U5[IgKD_.S'
p,U_?T;%*F)2>ks1rAFp]AiN^/FT+=jIA@3!H]AVu%QG)L$O[,iaMUb[14Kh;+iGA<!<,QW+';
c]Aft1RB`c=<@pU+7kS;)c/g[g\HCR#JkE&9s)T[1CJ!HE!*`;C@PG*$WEOQ.@.k3D;M?]A/dl
S(c+$0t','%>^SLVJ)blr:4:oGSaHlC_e$Bi8FGu0[iOnq+UOm*_gQ),kg9qSfuM7O)dD%q?
t=FGJ`:]AMgjBY:oI+!-A`n=6PuVsh\6AY9'dG4Nh.E%9k*^"Hl&.\2S2@.g1#.]ALL2bRcn2[
l)EFQ0QCd9#%B,eME)kFe*auoa,H>u$:r.Kb!D@25?0UOSEjeV7>S&8oK\n&'!\>H:SQ7L0%
JTMkked*i``)jB<L$Lb4&H3\O09kCAUm[=g[Q%+,k\h5F!%[lWr^7P29^^FcW;8iEk?\q%1N
_B5T1#&(.6L2*S:e0A&Jn%i#9,F%"\`3'<b"Sap4$s7rV2A=>45P/;\"X*Ke<ei="-RI(5Wf
.CB%sE>JI1TAR.X#[YoskfrGEi.dU,_%[_m`#HH,9:RETVcY$r_EB%:6e#RjWEGf4TL>?iS]A
0Qo,(-*i62=r7dIuaQ5hK&AA&SqmpE]AgSW$-=?^d-V"rjX&:7Kf2HY0$@$=$hG66Pca5#&ha
cVh'4E5?:"+2inF,6/f]A^?//L;A[Cc,-([Z&e:/TJY5)?c]AU;/4KU:.),aY#V7TEjYP(0S`i
]A@C"L6n`r"H3@;VAoSuTQ:bdrD4i\_);%0lZp$k25"pAf`02<-YBFRS%mX8\eEZo;=VLXMud
ZqJoi:2\jCUen?RZ54^YZ-(]Alr^,Y!RB1UJ<0r.;04Laj2uLQ?B9puqi3RIs`]A,Ha=[V>SEZ
(hL)?c)u0m2le#DPn?qZ+MO"Fj1erU`Y@@e#XKHS4+5WPlaGk9+/'<(O*_#G(Fp25pu0rT^h
,`M=nR?`kqg!D$u]A[Sa=fYE?"9',+)m]A5qnQmg)d8*M$8mL@2,AFGDZit=K,\5>+Xi.>@$0'
1L]Ahh8KJ0CsH7!MM[UIR;i`Jl/62BX5@'cb9L[3E^YubC?iFB746u@^>/PqOZ,j[PfkG,dD.
"-efkX[Qi>Y%CXiUV:TN<b6kVc1&kn0R"]AG\6c.8@2UB"tI%PBS9bYnsAN4+lYbuCk0CGrGd
'L<2u$ZlOgB,aE@4(0!I4=lBPV8_7Vipi`H1,C3_LNqKdb=rncBC6[Yft0En@Nf<MU8AG#Hr
Shg;RRkuDkg=<8lY,A=&Yr5D-c1Euca()$b@$,(cUA+X:nN7Tb[5^ha!7C[1n?)172%sG4RF
CF7$YdVCs632A!4Y6%JA!ffh+\FQCb`j_hqu&4WW%o_Z4$=SX><Gp@(PSgf4?Q.dUhp\nAo?
'Ipg-[=2,U1ZPEUa065G6UV[o8:n%:9m+Gtt;s=GJaooePiEH2Y9V.K%M2;NS*17WT:-K_Oi
/,tCeq\7;r%28IJP-e@qq4AR`jq=)Tk@X%FN7GR0ja&dM>OTVQUQ9[c-,nui"0J<%B:&H`$!
p:;^^/I#[knKJ2OZsg$e_IDi,]A!P:m6q[mMZ$S5SZH_Q3ajoUO%Hk@tT_RXflH]Aip$>Kba+R
\"Y'mQ3,NXdDCCuW/SfUFt+L5kl$C-,S`4;U`WOk5l@QD"Kp]Aa\rC\<fmhBI3EH28dBAns4U
<sh%e^;DqrSD,]A#IZTC^=rAc'L"kJ(@dfMG9I"Ws/R[cBF0D(`HJp-\T9M:."$\h4G#Xq"#R
=]A]A`LO0on$u#cpM5<Rms&@loi^B\qD:M8u^6hQB!XN\(L!H86c7RYZG*JDu>/ee,TGm`slh7
kllf$)[G_n.22]Aq/6XkQJS\Q>Z9m^)4M0t3r[A#&6,&[m^-gNFCe;-Q%h77O*%fqn:V-M61B
-S[:Ti:cQ1(ucc@6*kJ3nX((*9Wn*[?>/6*KVNWHjXgIE*+@3oLiQl\MfcR_*B64X.OSqEHP
BX\Y\qZa8E&>5>)%&@W4@rOu[rU(?n-83_mfonuWN;s%_q2CG5Aru@$ApI,]AWHIWWOQsK#[>
5*oIp><p6i%MM7ne`V3\6rZ.dbjlr;T?FdQ+iVE?q6LQtJ7(^LGY2b@HE`eZuNmAno/X^m)_
fd$<\&.X6c\"+n;dVr48*4,Y4&Y@S$s4ZSQ]A*iPWB.9[78mO:D;jJX<3An&]A('&Le(gm9.MX
/<LuD`(:02F?@R1A.fKO#HV_Eah.M^gte/\3Jc#UT+SJn3_J0I:B!hr8J!*'F;#J0.Mm!i,L
h;`TB/mFYGU]A)"A11`HB0j`Q<>]A&!t]AT>5j)</=kh6AT6JPOq#L#o<e[%l`26t_T23pKejqP
^m/<a/*L\cK`[j5/WQ-DM/C!+F?W?J3W1WU5%5.!.L#TW`JJCh@$^K[h5HVCl9]AkS^bdnGr&
qmb(>n`+Z/#-MIZkp8N@(Jio<W8+(72E^SZ=`mLd?moDs_ZG!E/5$VGk^<ML\*Ad+,b,;!pj
WM_/g-BaiM4Qa`cTJMI9186&T]Aers1+^fbV/S6QP'PQ74B+D0jOmCf\='sK$)M1"A\,X^u"/
A:MGD2R5&asU2?J_h[RHp_.$D2_Qbpdtt?6==E;`-2iGFEn",\gup[0dQf9)B0iE%k.?UY)h
@Iobk=L^7++AVff-o:a?%M>AQfXD=BRJZ(DH.&$(inM$5X`Q>&:e"TQS?/<-c7P3$qkrg]AQ1
o]A\uG38L6T[>!]AYE7X)IT"I$>mrdu9)0QW-VX64M`bW16T6=hE=;#&U;[Rs-PnAkf!WZPe?!
j7^Y]A4&u`UAm<+fc26/juHj`"F@]Ah!*l)[>P:Iiq@"TXXXhn+8?EeA($E</)la4(t*Vu_R6q
.(pnk6)ZNqSSq:m2ngrJ"7e=XmD_Vkpp$tZrMsZLVJTKEb'""8IXo1hcUM'Zc"bqgh!:`\3d
\LkX3P154rJ.b33PQIEZs"3U%J>k`0()AQ9D9c>/[iq8TaIoIJY=$"+o$0;"rFFIc]Aha2_FY
S5$m0a$pe8VUS5WCo\^K/s"KoR5pS2%Sq6Nln5-O<'rr.'!%Ftu=1ma(%J;0D!\.Gs;BCAc?
5Tk7tMG$otp.9#h,!]AD)G^SJViS)W2GJp^XRjX)(0:[TuTrq,Xp`Ib2$Ed6[kf]AqPV0V#l[_
2]A(B4GbR=iET#0V#>*=D*RB!?1I$OCYW!r!f$be#P1c$l9,Y&!Tl2/7Ooo@1g]A6HLZ]Aei#3o
*""Pgkp*O_B`Gn&qMH.UCX9,&bn-'8$c'SQ;oYK28f+Y]Ag6;J&A'df?0?/THBZ(]Ae\:(8]Auk
@VjJc_S&fZMe9?GJLFk^2$-sYHgcTU<&+pNaWO0E:ko?U=@LG/mUD$&:CYo,2FsZ1LLR>E(`
O&=(LG(Tt!m:hoc!-0[3*4<!:08SAaV4E"1QtdNIDt\,qMuRR,S%-AN9hk('lMaGY)u!Y!%d
8%go_:m^qO#b\PNm1fIu&Nh;>0[2b`3J8#[>qt`L#h8BlTTSm:&SK4)K:IjV7+,oPRl+Q%1?
&h\7mZX+R"(P),Mq:-jM'jb5amM+]A1n;TBF26o6Dj^@@t5UKkSV++T/fB8iQiJIg8gPf!._K
KLp<0a<UJFlLf4rf,\LAkH54NTO]AWq@Ba9<Q44*;CN5.u!ZDBWZb-e)q5gR6)5U?l7oW(5O]A
e_-3T"EOQ>/D0FViLC3gBp(e!3mGB!/Ap]Ah-"]AVFU*0%\4ZNcJ85em<BUDcfA+dcWm@^!679
C$M@$$:7'eS8[:bLeUf.&]A.ep[eSIfkD;TCC5k#A15X-c%nOAmM'p)oQAGL'NnYN_1l>7KZ4
?1"*6F5;s6"#SRa*o,pZa=RF7:q1q,YXk8k=qY_eT3'R;YAY0\2/=nabeXB1W3,`kGWM\$Qt
K3rYFV0Dle_G/Aq'8;YQ,7e<XPi0<rPp#Zbc<*Ib,(c$Sg\TjTHsYof3>I0-ua2T4$Q/boVJ
+0#HPXOX1s&B3fq0Aakkg65XNUA24cr^-Thi8P4TORl_Co;lRSq`^GBf^*QR*Q?Vd:&*q@U%
p%/<'a[Li2@Jg2*2=QoJW+.hMg5=GA!u^(c&I)P[t38D%n7.tP!P\(mZ@2f0_N-SAPX_SG><
N#JP6&(jPe1aTh.@O(<=F,)'!A`>V7P.r@<5Lc'gG3l'br`4+n4':fm)X5kQpAZe`^O]AEN&h
YA:oodr(q4(X'2EnFeG%ia(f&T/=L%:>ae4nF5%>nm^K%amoo!11eC&m"9p%r*Jgq.n@j<oc
b*QH86JH1oO]A[81>]AW'sp%lp48P$EHV<B1_)R/TImt]A?<?6oPi8tW?h4U)-)V^MBpoAa'X0q
P`&,-uT8"RtmLR/c4Y&DdmS7^b:]A/Wd6/Z2md9XfakTW'h$oTgPmPeR*f<?9CEUpq$er58uc
3o'/+hbP<+O*KFQ8S')Af%.P]AN%Znps*6Sn[D@\OLa.#.@)>ppC9dG#Or0r?7><HqFfIX>5T
5)@]A]AaV5'MD6*SomVGr'0uXgf*ukQ<B@;sgB-7(]A)`gd(QqUdXp;)r^\12/:i[AWu/n\H#a&
OR%7$52iHBV-n'=#f7)?AHf`51K)V*FU!U3Jsg2K#i&"t%,sj1,*#nD^hr0uC^f9R3/^r>U!
6AZX!=E\I/@<3*[gTXHbb"Q,G7?/'2eP6:@0mLW^`jf_PZ;X+F"9GFqk1ZXbg#V$HKB$::<*
DH:H-!-HCTkN9m)h+);hZE?.U><igH?@:jH$::8*&r9.1S%\+48B7\\ET&Q1uXs?`K!5419N
o9eX#.G(=Wi^1")2'/k]A]AqlR(?nGq/AF6o\(U=O(om>sb)rSq^>XU3AQ\gRYR(M8Pg;P)/=$
As84bn6MZ1]AgO^qsPB>o3AR%#K.O4?Hq1fJW!Ljkg):RXDcdD#M@>JK\@Ldj&5)$Fdl\1(G0
Y(;hEg8X<$_C%D>%u(qWRtS935!W;ICmS*$qZ/Oc9frjg.b)/@o5EsKpBEfa2t5n3?]A:n5UX
sCJGeX4R&IUY:d0U.U%&f84lX@I0Io"@XrqljhI;cg;lggm'Yil7/d$JW;"^n2@J[8%-e6BR
o*X`hYlAiW.Y:^TBS=Rh>ga*_D=fe6nQ0%c.ns1udBC5PFo=;rWrb=\B5h^SB4[VlTJOmH6.
'\"O`N@s#=n3YaE3R]AmMnU:#CGaY)MN3Vngp+Z@lC#:_?iZ%K/bOme&Md\nUKi\=n<UQYj_*
Qn8I(j'[5"5%>Mqb3$g3^JDZG^JkjpHZ&%MF/p^]Ar\W6:@-Negb7s5dG`h+'Ok.3\C`)WIp^
)"jVYk`OmED1=KolgSJX"4D6?5MLP87ba>ZZp-7Rdce>]AT:;Z)"LDj[m>>)$[ms>N$fWJ)hl
hJkpu:Nfg(J\u[Q@*t#QD(;WAQ38>G//"c\iJGm6TJ"hNk2DDKdKlk9B`pJ#0hrDJ(4uaOlT
f[A"CHNR`XZdAsA8j8$FAUH"FD#&sc/>gOVf]A@>1#(nji/g1mo<.Z`<'e__W]A3Ho(9juRD(<
B/amA=SsMK4Y6rT*I*spcb6XT4(I,/cqB!l^%o>cgsD3AQ6JHe)K'5feq^u72:9qfB0bdAFW
1XDO.ujh$Po\dJ:g&*XGWHRsiFW<JWig$oA1_KX(t0hZo.3hsmBq#0ODP4o&23Kh;[bHosE?
)#?55HdP=<PjL,s?-<SU#kC=fSh8e&J!<]Ard6!9+4>.j5LEE?!q1paKPXRp5%Q-4.VDD@KDQ
2O=jk;H@r'DGQ#J>gQlKW[^4@_52]Aa[hT*lW&n,!\CMjEoR3c!DQ3.O.h"2b<:5TRj2Vb)V<
.L_kTUO6pq5f+ZEr`:oJ`GA/_A\fPH"KYjb4MC+qcH9KBp*p)g6Z+LAU[G)9X#^X>0%_<D;9
*<]A9a;Ljb!`C^#8qpVPU+F8=3ZIDeEC\h@'#@rP6Ybe.?\k2p-..>rqLt=%%WIWGf5ji(86c
$M=qmUTG2TRlCsI5l4ZCJm-oE^s5-rn<i<jOaM5H><L6I]A=DHhj(NtQd;Nm]A+dhWi#aS+luM
pU&F'#d<i5<'S\l"s\VZrk_,YFNr*jlJ:No>#ErFcD2'5lcTL9p;OH0Jj#,(L$a8YYcmh_ij
??B[UBp7MQb`c0V)93PV%O,KZbH:$;#NRht2UDb^!8=%3%5\%<F_N.rXsg3>H7`9TSPr9:CU
5h.)67a67@RF@Pa.:jS:D*gU/b7o-6V`6q]AQ*Dj_9MPD`lKU`sd3\_90@o6RBhE!V_@i,NTW
E\>2Zb^eH8QqhTO0ieI6aYBfhBgc-]AbLQ(`,OeVZ65.+NQR&$?V/"=$Gi8c^IoP%rT-^mIk_
Sq6>1gEnRf#N[>2KRPA6G4e$6&PT`6'b03\DGrUJ[gf*X(Q9UhtZ9r$Y=qoOFFJ'Dq-`3rG3
]A4oJ!/!=I"#=u9g./]A(Ib5#=(L-9Q0nsudR!_Sn_$YQI*W;Au#bpB!1H;Dn+bLA_9#4n-1Jn
lL0f^I0)$\,4q3Lk-M_KcXqps'ECcghe.jDu[hN[l9-$XP@i*^EM\FeJ/pa)Alu2L$j).mQi
]A#,mX,&Xg?u:AnZgY]Acc%YGIB-I;BooKP&[#(g/h5cY>VsB!!L"#_;@b+&T7pi."-uN9[1&J
WSp*4+?$;CP,=bqCk=/MTqjVLHQNPfsdPoU\87.4e/9.*U9&b8-=SDFm(mIFG"XC@*:0onPr
7[^;S#<EEhhYPOnSCqpMDH)iBYAiPNSO5[L@N4=,s`CuELt"fM>=-g,5.SZg/2*q<3]Ai2[Z4
iDO^6SR1nn&]ATqZF%_e)\Eh)J=u<J7)c/`e#0]A*9<n=*bA,,3[7JkehM#<#Uj*@,CgLkhm&q
s[Tr0n^`/,o6:B+iMo^Jlj,>?.=\g>]AbY0A"uHpN;BQP:7`Ns7VXtXj((5%2N5OjGPfr-=]AQ
9=Aq3.=[8.h/@K]AhnJjaS5Feij)*B9"&>KRhREg`"-(\Ir#b(:M#pMVL*[1XPf=Ak)il$iPA
-KoNDVM21>M9o0qu8&-Q?cBfCP1OugD]AHH[JoX`CNQ%mR@cjDhD@JH?WcZo(D-MXbU?q%SQq
64IgQ\pe1As5AqGmr?``I&`T4C+<nGhZ#lY&H,=Y#EkYr:MMbL"XT6JV70&+*r+*Xab+5>VM
Z!oFd4TLB+af<)p9sRppWjn75G]A_8BW(NpCTL`#i"Ah!i;tC`RPq`'%^PF]AXe7aA7.C):/Kg
#K)]A2lqJp"&I9pVSaX?ou[V&L<b=ric+ss$p'=W]AEm=4Ygdr6k+.r_@g1Blp<0`krCiaB[bj
iE)t-j-freX5FJn8P\sOtQV>e&M/&O>CmQ1/f-"k,ahP@<VtB8Ds%-L^GuC@Ar),Q^RL)6O/
V@0E)G!nrAa\@Q+.g+sreheO>lnZUAETWE1oNuQ^QD-Tl"'=nqK,2e^[.\a!OO@mVr@B1at2
47$K#rVs,)'=^4O5P(K]A45Tea>1cOa)t6?Yoo72Ekc/B]Aiaq#10*Rt#`^6N3.CY?aM(Z?20&
$Y1-_2$FtJq<pN#[R'fuZhu44Oso'&.M92f0Z^s:^lL7hcl(V9!=<S>/-@Cn8/=5iTN9`[8i
C!^,FbaO^C-i9MiD(se]APTI$*>@?f#te9)H##;r4s6<qu:n;!>QnYgQmu,ALhC<"9eY/f6k>
9md:b'rtb~
]]></IM>
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
<border style="1" color="-15388336" borderRadius="0" type="0" borderStyle="0"/>
<WidgetTitle>
<O>
<![CDATA[新建标题]]></O>
<FRFont name="宋体" style="0" size="72"/>
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
<CellElementList/>
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
<BoundsAttr x="550" y="35" width="304" height="200"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
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
<LCAttr vgap="0" hgap="0" compInterval="0"/>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="report0"/>
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
<![CDATA[288000,1257300,1440000,1440000,864000,864000,864000,864000,864000,864000,1008000,720000,723900,0,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[288000,2743200,2743200,2743200,2743200,432000,2160000,2160000,2160000,2160000,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="2" cs="4" s="0">
<O t="RichText">
<RichText>
<RichChar styleIndex="1">
<text>
<![CDATA[累计完成 ]]></text>
</RichChar>
<RichChar styleIndex="2">
<text>
<![CDATA[${=C15}]]></text>
</RichChar>
<RichChar styleIndex="1">
<text>
<![CDATA[亩]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="6" r="2" cs="9" rs="11">
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
<![CDATA[]]></O>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
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
<Attr position="1" visible="true"/>
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
<FillStyleName fillStyleName="目标实际完成率"/>
<isCustomFillStyle isCustomFillStyle="false"/>
<ColorList>
<OColor colvalue="-12475905"/>
<OColor colvalue="-16713985"/>
<OColor colvalue="-12491265"/>
<OColor colvalue="-2575873"/>
<OColor colvalue="-5160449"/>
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
<FRFont name="微软雅黑" style="0" size="64" foreground="-10066330"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="true"/>
<AxisLineStyle AxisStyle="1" MainGridStyle="1"/>
<newLineColor lineColor=""/>
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
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="false"/>
<AxisLineStyle AxisStyle="0" MainGridStyle="1"/>
<newLineColor lineColor=""/>
<AxisPosition value="2"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
</Attr>
</TextAttr>
<AxisLabelCount value="=1"/>
<AxisRange maxValue="=if(or(max(ZBPF_KJ.GROUP(ACTUAL_VALUE),ZBPF_KJ.GROUP(TARGET_VALUE))=0, len(max(ZBPF_KJ.GROUP(ACTUAL_VALUE),ZBPF_KJ.GROUP(TARGET_VALUE)))=0) , 0, max(ZBPF_KJ.GROUP(ACTUAL_VALUE),ZBPF_KJ.GROUP(TARGET_VALUE)) )*1.5"/>
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
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="false"/>
<AxisLineStyle AxisStyle="0" MainGridStyle="1"/>
<newLineColor lineColor=""/>
<AxisPosition value="4"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
</Attr>
</TextAttr>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0%]]></Format>
<AxisLabelCount value="=1"/>
<AxisRange minValue="=0" maxValue="=if(or(MAX(ZBPF_KJ.GROUP(VALUE_LV))=0, len(MAX(ZBPF_KJ.GROUP(VALUE_LV)))=0), 1, MAX(ZBPF_KJ.GROUP(VALUE_LV))*1.3 )"/>
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
<VanChartCustomPlotAttr customStyle="column_line"/>
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
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
<newColor borderColor="-1"/>
</AttrBorder>
</Attr>
<Attr class="com.fr.chart.base.AttrAlpha">
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrLabel">
<AttrLabel>
<labelAttr enable="false"/>
<labelDetail class="com.fr.plugin.chart.base.AttrLabelDetail">
<Attr showLine="false" autoAdjust="false" position="6" isCustom="true"/>
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
<![CDATA[#0亩]]></Format>
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
<FRFont name="微软雅黑" style="0" size="104" foreground="-1"/>
</Attr>
</TextAttr>
<AttrToolTipContent>
<Attr isCommon="true"/>
<value class="com.fr.plugin.chart.base.format.AttrTooltipValueFormat">
<AttrTooltipValueFormat>
<Attr enable="true"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0亩]]></Format>
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
<HtmlLabel customText="function(){ return this.category+this.seriesName+this.value+&quot;亩&quot;;}" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
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
</AttrList>
</ConditionAttr>
</DefaultAttr>
<ConditionAttrList>
<List index="0">
<ConditionAttr name="条件属性1">
<AttrList>
<Attr class="com.fr.plugin.chart.base.AttrLabel">
<AttrLabel>
<labelAttr enable="true"/>
<labelDetail class="com.fr.plugin.chart.base.AttrLabelDetail">
<Attr showLine="false" autoAdjust="false" position="6" isCustom="true"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
</Attr>
</TextAttr>
<AttrToolTipContent>
<Attr isCommon="true"/>
<value class="com.fr.plugin.chart.base.format.AttrTooltipValueFormat">
<AttrTooltipValueFormat>
<Attr enable="true"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0]]></Format>
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
</AttrList>
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[值]]></CNAME>
<Compare op="1">
<O>
<![CDATA[0]]></O>
</Compare>
</Condition>
</ConditionAttr>
</List>
</ConditionAttrList>
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
<FRFont name="微软雅黑" style="0" size="64" foreground="-10066330"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="true"/>
<AxisLineStyle AxisStyle="1" MainGridStyle="1"/>
<newLineColor lineColor=""/>
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
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="false"/>
<AxisLineStyle AxisStyle="0" MainGridStyle="1"/>
<newLineColor lineColor=""/>
<AxisPosition value="2"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
</Attr>
</TextAttr>
<AxisLabelCount value="=1"/>
<AxisRange maxValue="=if(or(max(ZBPF_KJ.GROUP(ACTUAL_VALUE),ZBPF_KJ.GROUP(TARGET_VALUE))=0, len(max(ZBPF_KJ.GROUP(ACTUAL_VALUE),ZBPF_KJ.GROUP(TARGET_VALUE)))=0) , 0, max(ZBPF_KJ.GROUP(ACTUAL_VALUE),ZBPF_KJ.GROUP(TARGET_VALUE)) )*1.5"/>
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
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="false"/>
<AxisLineStyle AxisStyle="0" MainGridStyle="1"/>
<newLineColor lineColor=""/>
<AxisPosition value="4"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
</Attr>
</TextAttr>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0%]]></Format>
<AxisLabelCount value="=1"/>
<AxisRange minValue="=0" maxValue="=if(or(MAX(ZBPF_KJ.GROUP(VALUE_LV))=0, len(MAX(ZBPF_KJ.GROUP(VALUE_LV)))=0), 1, MAX(ZBPF_KJ.GROUP(VALUE_LV))*1.3 )"/>
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
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
</AttrList>
<Condition class="com.fr.data.condition.ListCondition"/>
</ConditionAttr>
</List>
</ConditionAttrList>
</ConditionCollection>
</stackAndAxisCondition>
<VanChartColumnPlotAttr seriesOverlapPercent="20.0" categoryIntervalPercent="20.0" fixedWidth="true" columnWidth="25" filledWithImage="false" isBar="false"/>
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
<Attr class="com.fr.plugin.chart.base.AttrLabel">
<AttrLabel>
<labelAttr enable="false"/>
<labelDetail class="com.fr.plugin.chart.base.AttrLabelDetail">
<Attr showLine="false" autoAdjust="false" position="1" isCustom="true"/>
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
<![CDATA[#0%]]></Format>
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
<Attr enable="false" duration="4" followMouse="false" showMutiSeries="true" isCustom="true"/>
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
<![CDATA[#0%]]></Format>
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
<HtmlLabel customText="function(){ return this.category+this.seriesName+this.value+&quot;%&quot;;}" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
</AttrToolTipContent>
<GI>
<AttrBackground>
<Background name="ColorBackground" color="-16777216"/>
<Attr shadow="true"/>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="5"/>
<newColor borderColor="-16777216"/>
</AttrBorder>
<AttrAlpha>
<Attr alpha="0.5"/>
</AttrAlpha>
</GI>
</AttrTooltip>
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
<Attr class="com.fr.plugin.chart.base.VanChartAttrLine">
<VanAttrLine>
<Attr lineWidth="2" lineStyle="2" nullValueBreak="true"/>
</VanAttrLine>
</Attr>
<Attr class="com.fr.plugin.chart.base.VanChartAttrMarker">
<VanAttrMarker>
<Attr isCommon="true" markerType="RoundFilledMarker" radius="4.5" width="30.0" height="30.0"/>
<Background name="NullBackground"/>
</VanAttrMarker>
</Attr>
</AttrList>
</ConditionAttr>
</DefaultAttr>
<ConditionAttrList>
<List index="0">
<ConditionAttr name="条件属性1">
<AttrList>
<Attr class="com.fr.chart.base.AttrBackground">
<AttrBackground>
<Background name="ColorBackground" color="-12491265"/>
<Attr shadow="false"/>
</AttrBackground>
</Attr>
</AttrList>
<Condition class="com.fr.data.condition.ListCondition"/>
</ConditionAttr>
</List>
<List index="1">
<ConditionAttr name="条件属性2">
<AttrList>
<Attr class="com.fr.plugin.chart.base.AttrLabel">
<AttrLabel>
<labelAttr enable="true"/>
<labelDetail class="com.fr.plugin.chart.base.AttrLabelDetail">
<Attr showLine="false" autoAdjust="false" position="1" isCustom="true"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
</Attr>
</TextAttr>
<AttrToolTipContent>
<Attr isCommon="true"/>
<value class="com.fr.plugin.chart.base.format.AttrTooltipValueFormat">
<AttrTooltipValueFormat>
<Attr enable="true"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0%]]></Format>
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
</AttrList>
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[值]]></CNAME>
<Compare op="1">
<O>
<![CDATA[0]]></O>
</Compare>
</Condition>
</ConditionAttr>
</List>
</ConditionAttrList>
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
<FRFont name="微软雅黑" style="0" size="64" foreground="-10066330"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="true"/>
<AxisLineStyle AxisStyle="1" MainGridStyle="1"/>
<newLineColor lineColor=""/>
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
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="false"/>
<AxisLineStyle AxisStyle="0" MainGridStyle="1"/>
<newLineColor lineColor=""/>
<AxisPosition value="2"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
</Attr>
</TextAttr>
<AxisLabelCount value="=1"/>
<AxisRange maxValue="=if(or(max(ZBPF_KJ.GROUP(ACTUAL_VALUE),ZBPF_KJ.GROUP(TARGET_VALUE))=0, len(max(ZBPF_KJ.GROUP(ACTUAL_VALUE),ZBPF_KJ.GROUP(TARGET_VALUE)))=0) , 0, max(ZBPF_KJ.GROUP(ACTUAL_VALUE),ZBPF_KJ.GROUP(TARGET_VALUE)) )*1.5"/>
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
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="false"/>
<AxisLineStyle AxisStyle="0" MainGridStyle="1"/>
<newLineColor lineColor=""/>
<AxisPosition value="4"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
</Attr>
</TextAttr>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0%]]></Format>
<AxisLabelCount value="=1"/>
<AxisRange minValue="=0" maxValue="=if(or(MAX(ZBPF_KJ.GROUP(VALUE_LV))=0, len(MAX(ZBPF_KJ.GROUP(VALUE_LV)))=0), 1, MAX(ZBPF_KJ.GROUP(VALUE_LV))*1.3 )"/>
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
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="1" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="1" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="1" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="1" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="1" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="1" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="1" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="1" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="1" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="1" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="1" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="1" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="1" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="1" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="1" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="1" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="1" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="1" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="1" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="1" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
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
<DefinitionMap key="column">
<MoreNameCDDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[ZBPF_KJ]]></Name>
</TableData>
<CategoryName value="CALIBER"/>
<ChartSummaryColumn name="TARGET_VALUE" function="com.fr.data.util.function.NoneFunction" customName="目标"/>
<ChartSummaryColumn name="ACTUAL_VALUE" function="com.fr.data.util.function.NoneFunction" customName="实际"/>
</MoreNameCDDefinition>
</DefinitionMap>
<DefinitionMap key="line">
<MoreNameCDDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[ZBPF_KJ]]></Name>
</TableData>
<CategoryName value="CALIBER"/>
<ChartSummaryColumn name="VALUE_LV" function="com.fr.data.util.function.NoneFunction" customName="完成率"/>
</MoreNameCDDefinition>
</DefinitionMap>
</DefinitionMapList>
</CustomDefinition>
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
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="1" r="3" cs="4" rs="10">
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
<Plot class="com.fr.plugin.chart.gauge.VanChartGaugePlot">
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
<Attr enable="false" duration="4" followMouse="false" showMutiSeries="true" isCustom="false"/>
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
<Attr showLine="false" autoAdjust="false" position="5" isCustom="true"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="1" size="120" foreground="-16711681"/>
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
<gaugeValueLabel class="com.fr.plugin.chart.base.AttrLabelDetail">
<Attr showLine="false" autoAdjust="false" position="5" isCustom="true"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="80" foreground="-1"/>
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
</gaugeValueLabel>
</AttrLabel>
</Attr>
</AttrList>
</ConditionAttr>
</DefaultAttr>
</ConditionCollection>
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
<FillStyleName fillStyleName="仪表盘颜色"/>
<isCustomFillStyle isCustomFillStyle="false"/>
<ColorList>
<OColor colvalue="-16713985"/>
<OColor colvalue="-16713985"/>
<OColor colvalue="-16713985"/>
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
<VanChartGaugePlotAttr gaugeStyle="slot"/>
<GaugeDetailStyle>
<GaugeDetailStyleAttr horizontalLayout="true" needleColor="-1" slotBackgroundColor="-1118482" antiClockWise="true"/>
<MapHotAreaColor>
<MC_Attr minValue="0.0" maxValue="100.0" useType="0" areaNumber="5" mainColor="-14374913"/>
<ColorList>
<AreaColor>
<AC_Attr minValue="=80" maxValue="=100" color="-14374913"/>
</AreaColor>
<AreaColor>
<AC_Attr minValue="=60" maxValue="=80" color="-11486721"/>
</AreaColor>
<AreaColor>
<AC_Attr minValue="=40" maxValue="=60" color="-8598785"/>
</AreaColor>
<AreaColor>
<AC_Attr minValue="=20" maxValue="=40" color="-5776129"/>
</AreaColor>
<AreaColor>
<AC_Attr minValue="=0" maxValue="=20" color="-2888193"/>
</AreaColor>
</ColorList>
</MapHotAreaColor>
</GaugeDetailStyle>
<gaugeAxis>
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
<AxisPosition value="3"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="Verdana" style="0" size="64" foreground="-10066330"/>
</Attr>
</TextAttr>
<AxisLabelCount value="=1"/>
<AxisRange maxValue="=B15"/>
<AxisUnit201106 isCustomMainUnit="false" isCustomSecUnit="false" mainUnit="=0" secUnit="=0"/>
<ZoomAxisAttr isZoom="false"/>
<axisReversed axisReversed="false"/>
<VanChartAxisAttr mainTickLine="2" secTickLine="0" axisName="X轴" titleUseHtml="false" autoLabelGap="true" limitSize="false" maxHeight="15.0" commonValueFormat="true" isRotation="false"/>
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
<VanChartGaugeAxisAttr mainTickColor="-4539718" secTickColor="-1907998"/>
</gaugeAxis>
<VanChartRadius radiusType="auto" radius="100"/>
</Plot>
<ChartDefinition>
<MeterReportDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<MeterDefinition201109 meterType="0"/>
<meterDefinitionName>
<O>
<![CDATA[完成率]]></O>
</meterDefinitionName>
<meterDefinitionValue>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=C15]]></Attributes>
</O>
</meterDefinitionValue>
</MeterReportDefinition>
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
<C c="1" r="13" cs="4" s="0">
<O t="RichText">
<RichText>
<RichChar styleIndex="1">
<text>
<![CDATA[目标 ]]></text>
</RichChar>
<RichChar styleIndex="3">
<text>
<![CDATA[${=C15}]]></text>
</RichChar>
<RichChar styleIndex="3">
<text>
<![CDATA[ ]]></text>
</RichChar>
<RichChar styleIndex="1">
<text>
<![CDATA[亩]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="1" r="14">
<O t="DSColumn">
<Attributes dsName="1left" columnName="TARGET_VALUE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition"/>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="2" r="14">
<O t="DSColumn">
<Attributes dsName="1left" columnName="ACTUAL_VALUE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="3" r="14">
<O t="DSColumn">
<Attributes dsName="1left" columnName="RATE_VALUE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
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
<FRFont name="微软雅黑" style="1" size="104" foreground="-6684775"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="1" size="104" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<IM>
<![CDATA[m(?t1;d]A8O\e7>"#TuPs;PgBMB`SB'7%+H2>nK@`,/#7RoF<&n<D]AnC8FJuD6pu@iTd8.7#n
Y/an*g4ikK?$g474!HNc@7Q0?IhV\`S:j1S;)L%T.uWg1P(YBE/$FFDbdK#(VYS$!F'u+FUY
[/R8Cm;d)]A_l<W;keL^!30&oo?`c[)\q\d<FVYI\PJ*CElMpaDEo@(^<7u$/5%M]AOJJ:2?`&
S0/Yl@fe>.cpa`jLZWMN6XO?Lg!r:cCB_%:8MINFPO+VKJ=PIr$clplLV<<fAsgJEM3;sPu#
</;PBRoeoV"+b5?_!mfaIC\#+o'6]A\f_i4NokS%V.EPAdgCfWlY.#O0AULH=KtHmG9o;,fkL
R;]AM\nV7X>EhYom-2qbGct<-[8aZ%XcQCl:Y"up;!XImZ##[%=Od?D's7,5og$`P3A`R\YA>
+P7IcEq[C@eh8q7u:7nY#GE2:Fh85^8:q3t1d<S2=be!mg"M:t"XAhs4"DfOWdM)JJgE%QOH
s-=dhr;Dn'f=*5#UQlq,*n!4X^nFb[5p("=.]ANM]A31]Aj;g`I6S/]Aq@6@QW<H3Tg`hnN<k,Ig
[SkNhOD0K%bjF*^M+(0Y/:tn34k\;;U^Y=d0@YIP%kECjQacC9*7(YOTn*$E*g:]A33VM8!,2
u_P^B$,"q[n8/Q]AM5<Mqd9(&@.%pd88]AT-%K2M`Q>$or,^SNjJ7Wa2@h6-$[]AYqpJX38TaqP
B/KIl5;gSOQiI@[g\k;D$Tq]A%^?EY=BGHSVXOO-7"A.CH;U:\iVWZLJPP#Wt/Al`\+6Jsr0&
++P;u\C0JU1LGeF+;8gX"o]Acbg8o2npY5f37l4M_Q'fj>rEn/pkCCgoXeZopN2\k_T#YNsSD
SRsgG*V'!QPLtXgbm`u!B5kP)ojFrS/%ROPr$K=$!QetDL`#G)_;++3#*fnaq6A1ZQ&)DCkp
/.e5Ll6K1V#lPtr?r$W9%p[[P:W)M(6dZ[TFk;O$EhF#!Td+Q!Kd.MEb=+j:n?aFLG//]AS@m
W2oa+Iq6bT(gV?-dLcAP\PLZQ$;Sr%k2R32UVD&cS$e4K2E\01NMWU7U'B<NSt6#GknSjSZ7
9Y&T]A_cL(ZBm'M>g*\[pA@AQ2Ml[u2GAR;i^I#+2O7cfu(.*6WWsC1$N9Q?%Ks_[J)t3DV`2
cO&j!MEbE[43?3<&B`mD$R581kJ@>Hbpff]AaeN>APptdhP7g8"6^rK]A<\F.H*:Jq%-?\]AS]AM
3F4V[Lo++=AH07L,`(g\]A!#:=%)E@am"#r!'q*1f]AJrJiaePLoK5%9<>Yd\>qUBN&)P>[&G;
Jf*`2[O7IQ_a*mTVmLn..BG?O?qgcs0qk)s6:O95V2SPi`/fMn_^_ud9atPm!/Tm;iXQ0qPP
X(O![\hGPp+E@`+$"["oSbE\IAMeVX:ti$QU*nmA_VidX)rO\jo;G&JQd>Mrf.BbB\P'6o[l
U]APQ^4T.&K9`6O!!E"-l?9OKJF'9j+2^gXahOt-@EVt$%4eW*7FXQk^2)nHMd+g'6&H.YA,S
[9]Ac0#Ck[WTYn>/Vf<Bb?Rt"[E%O:R[.J-+_JCke*PGdA"m+>%Bm-U]A4Qss1)=hXr%'9mQ6J
m#8dEbG3M-JMu]AMKhUS.?R#qKt/BgVI55J(]Al*K(<Is"J0(?deq9r7c$ij4cI0HP"F3[%*Yh
h.,2hOoF^=od#E[m9$Pj#3nrc@OiS;>t!5T`s*qd]AZY;`YL"ZBgIPd4Jn`YYuj"GesbA;qs[
\*9hG0d9i0iDXKTU:Q#Hi"BdiQ6GoKiV/PjL4+fbE=Vk\]AhQj@<\WUJ06\Y,.oo?(Ajrj?8t
ZmO,IJhpuXgb@4N*CZ8)#@)YibIgY7Ht0#"YIOJ']A-^]Abf4nJECWsTcF:Fm(RNL7Rf_2P&Xb
mIKpf:U]Ag$a]A*_XNaPNnN:E6ed@[D;Cd>J]AE!+JR["&a)PYYYN(_nIPYFI<2cDrRl)g:?ec;
oNmW))i)5.%hN0fBc=-ZjQ8_=NmiujV8-<ot-^-=E9Qn&,lg+=uoR/>H8u'qd1MNgAS3f4SK
DW*V;mCGE+u,B4F">#-^GeiY@'8"GlQf8rM5/P,(-&C0=3ZI-=K+k8icn@-1<JK&,*:CICMN
1I$e+p,gQ,OdG#V?^rsf/Oh!07Y'3Y>BIbk$=C\ofJ9CL&Oc(!7*@>s1^;u(Q`D>%.Y`C//D
jtSp[Gb;PjG\m6sCUZBO-s!B3U:[?-__dr.aXEbAlmpV/k47CKH0:!tbcuW;Z42R^CAW6\b]A
:Mfm-WgWC"(re6-oT$6T>el?=-spB+8J`d>C7!m`I$7<9ern0=Z%F?NfsW_7mQYrdKH?J^4.
khqH2(m[%Qn)V"Ct,eXu3Z,lFd5KPFe=)-L!,+]A!l%OR-C-tH_-P,RCNpMU]ATb($UQ$-7Q-H
+IQHeAHJr7g5>0r6]A)RdAs6.bC&4!!p>d)-D-s<]AKq7glXb5e^MVljJGdgqK"gnIQ^.#sh-j
oCqo?B[^*DC'_apJ58=CjEcf13X`no[;#fQ^M,,LHYhnQRoqJ#h`W0TnmcLK;sEW(Y!gladD
hnkgbje^,m!*K6Y=dNHq*LFG@CJB;)c9YcRrS3\`qM(qs%^-$&1otb*4tk7&?P_"p]A*cZ%nm
Bu?c"X(D9g#@+kN2msB&:f\1E61]ABh0KHLeks9_uq^,c!Jml&E-1I4kOm,AfGsMH:,\reC[e
jS/".GOa#=ERZ7]AHAuiHSp5bsbWDNifem>tOMcC<<mo]A<s4a=n04MlDlTB5jPP\7=/.r?"d8
M*f3mg4V*]A=4fsBZ^57]AB)\h^<GTIV4&$kn>=E)5ZnutcYubBl;t.^S!'r)0E8?nDOuV#k3N
d;6K"ZS\GmT+f/HR)[0:(dVbkLfo(U.n$7d7#f^uG-e<\fakN8@sPELVJ"F@W4V<sXc5G6=\
\^>lC8ZqFXNMFM'^B.%5$g2&T:FCQV)H,i\,=nWdeZm:FcCG[Aib$q*KmIm/Z)\C>X]A%[SQ$
SkTeGBep,485UFP5sCBdMe$U,LO+J(f@7NCU^N4#Q+#+$f(rMh5n^]A9-"O8*?G#X5$Y2>"gA
=NY.jNlAElX'GD4X?G!oI-*2u[iJVHADW7io+HsG!]A?T;Y6]AC0PYmX>5s%U@)Xnjl6Xgn)&\
K>H()UV5(Y2Z4/!I*g0@>MdVYJWn^qK5*Jm`OJNHMoSdB/(/oQ^`Soh[$'FAn(s*Js4rQ)hU
f@q+u9HeHtXdO8E/%c)_$br),6kW1mm8*FjcR)L=@-Z<*=kjZ:hF`V3t+oaF.3bd1q8_\2D`
VjQS;c*FQ`'PpJt\/igV/2N.%fca(HqtE2>[eMiqA8rL5h?h-2ku`dQi8Va<AuI8PA14h(3=
@iiP<sr6#RAU@F;%V\HI"Fj.p\D$JB+s]A=86n`RH>@k9RL/tGPM/or*D/&OOcG-XgZ+ZS7$\
k,VNKu&a;(9g#<^sR9`&)\['D$l29/>@]Ao=kP+#PUk^PXA+FN[g4XfhpmnS7fm-?LY.4j)f#
HFM$A4?U>H84C-4WS)\joc"d38K\c.FUNo2?a.ka@`C/<T0&&8'Z5=b8gN]A\2"8C,!Ig_T[9
T`ScTcg5j-gET#]A*t.J]AQO^pN&9ZeocKOk>\f49@gYGNE5`1Ff/)/7;Yk361usI339mfOXV2
iuP#"GNC4HpbF'd$R[CMAEA=!ABtHtL$g[V,Nd;WiV,K_"1$16J`sca;YF"T5D@.6#^Fsp):
T]A!B'f"aP]A-SNf>i/FG/"K9mEhhM'q"j:V::$n.<g3sSV'<OEK8bm=_S.ojMnACXWm3pVoi>
Xl1!mtH5-+WDEI&X#')'VSa6PsZqc*t4Pa>g=J@[DhkK6=-dH2H;>t4-ZnV0pY&%s*p1H6Q5
SM\aT<+!>LAk:/0*9#>mWN^Eok.<?X0'RA]AV8M)UOcVk-82<`mJO5%ACCj.^"M\qo2nVGLZV
VcmM_P$eEMA>cNHQ-RZRR'3"OG'Uil(d=uqH:2b/X5&!Kul83Wk?+Y?#ZA&M8RbT]AA5cMJT*
8)sdKV)`3cjdll(eb!T@(/n$[ba[-"]A*5UjH2/1)FjIeS5I/iNqa?aSRXHh-Hae.)oJtpH]A6
J,5RM4#uNi)/TT#8d;Rp10eg;K'&HX&th2^u$[HCEcAD@i2H=m<'=QYBdV)Prd7EWk8-lS'D
\:T)\]A9R(X^1i+7.o^A&hr`/:>I"He\,Ucb^73hZ)VM@L/[$^<XO0k'sTIk^0osekc<C'if_
r(uNHRbSV)!'gXqL_m&=Th2\or*!#NR5f]AFQ,XL5S*:=l5roi?mU6oYlCHu:5R\ql2U/)7Nu
a6aQL*qX<2=dr9Pg63f3dLWd6:9=d&fhc;tB+3Z6(3;"?RYP.aaC=b"]A[GUk:^?QjH\/]Af>K
mald\ma2J<CSZDM&.;"A%K_i(1\^]Ark0T?7h3i;a?e8&.F(_0JG(%5*IY(2'%dOcpDi)Is:L
O)P23I@?1`rQR$?F]A+nh>mt$LMM/D-6KR`)MIG*Qopjl"5))'(5A1hPg/aD_`1$,&fHY9<F%
iT9:n4G[Ka?H!@?\s78h8A3a48q=Oo.fqkZu'Q,0knB`RoY$l3.+=*f*!537-M^\/@H<fffC
DcIG2Kul]AAEi@0g8)VtI52BcHXX5bhdfQ%s)<,"ITNXuRlA\Sjr!t"L.NB*A="@D\bI0Rr]A6
U4Z^KmEAt;*nUjE\&S(KEeg*-%UAFP)g[CYc;4^CircuF>K?(1*5lJ'UgXMJ5&G1qnH.6U;g
ERPMi;l/7&V;V-%=ka$;]A\@uW^&fqmg%`l!\[!RZ$pDYo'm%<VGKE%Jm\K4>N-uVncM=bikC
"c'V-oWtL1'7RK4$V@-%]Augoq,=l<IbU(8\Or\E7(nb=+>L[l5MLc@ci`[ab:8na)smpa)rb
Pmoi1I5Q?)-O"_\C,^#dJ4?Ql[SYV,&B3Ibcj2=r5\fImj0n0c]Ad]A:S<PlJNRq&[=AWPLi1^
@"PSht<;`2j0dKKaD%i6+4G$_d?&(l!L1aCB8f<CLgu%1eaa,lPh#Z-JY>qMJa0d\quT$)"r
")ODc3*s+4d]A-Bp0)7fu`V-'X@#WUAP5_RlOZqPJaJ@HCsYf/"9*A\%p>8#,Ck6/hB6TZ["-
?.rWT?;CTWrmY?-'eQT7@B)V:88!)/5ODXme8tGraiHeIXK*=\P,]AVc#HrAnC&DE*@JKRPFF
Xh%g!sVgJ^3pU`=pC`JQnId=D$!r2YZ<mJU_i_#pVMnqHsYMBG\JB&ik.+4kB<tS8f#Pi88f
XSON@8MBORf?V<)f0':tGeMBm[9OhqO/g2[Hji[Rt<bPm><gDW`L$GRKR#"PURU+;r1YpDuf
)OIY1OS2;LJNdJ)2a<T6KtqLaW:S$E^<af-SGFs^W%(-p0:fJJ#pG@c/BgnRA*9Ges`-2/*2
9Y9]A*MRf4&c",H$7Uj<m%;A2placA@.,nfM4$#:5ei)hMTn)[^dqaFE!(Y;J7!_R9tY.95Q/
'g17:9=8Tgd=-UN>0:K)TiSh4g]A-mH/pc("MqFQ3fhGjUCN&,*7Sk4,&NC&.KK"Q=iADR>Rt
9EN(Y*Qbs0;.n1Krn[r!<*^g!Rnp[Perteag^:d\6o+Xcc:=U!qCODZ9cRpQFX&i^SoK_,;L
(iES8_U2um5mAJ<\L'^cr>ha[mQ;ns>(,HdiVBIqQY8"55SlP"DafHl$QOM8Z*T_R:pK6X>H
0'M4GFhooH1LtdPKHL7EQ:p"kXMKcZ0V6%ToQi(L62j$Xdo'kk8d.[P(UXXUY5PN>>KfG$m\
tbT/L"6)B9FI1t69uhlSruY<^5NQf-e%8U4<&A)5`C1LbqH?&tIe?D+7un*#Qn(Llr%i),[_
0"9L$k8UgopZ\3Y,\1e7Lk4ZtPS4oD[I.44?[;^D6(uQMa$+i'?R9U'(n80e/^Vt%f.3+JP4
a03C%lAXrKQLJR3nK?4[)W(*?o<]ANH`*T(%NH<9&j/r32#IO?d7D2^Ra/>]A6f50o[V)X+kKa
)kqpTO0%"pAYFa=1XMKq&7@g4u%!\F'6Y!Z[_F>A#0)[[m!2@\:5i_jjYefrFS;U`gNDi:"H
Fr<)pk6`+1+2IS0MiKr8'tTc8k&trng/hK[Voj#<_dcZ.0r(6^[lp<I_7DU=nkMCTCplTcXY
)@`7h[:X]AdE^XT[*qB('Tn]AZ+)l#]An>]A/YNojWq40`jnnIaDXSLW/d`2rVG[8Bbd><u"osc/
N1dTTCRLO<Of-B"[:AsTU)>%#QZE#j:W^L=eLhULIZPrjNGfZ=!/hMYQ)Pg/2!2LQ9WcF8'F
B:5!t<0;rr2[;GL??mHdr?%5!+2-K*V*)jR$1Kk6k<?*+W\mHVHDa3_1fV\-Z.O4;<H+#:E^
f,B?2aj@Jm+6^rXF#fc71Oj6O^j]A[,FdIJ=OKY<r5+iuYUok=mkl!+ngV_1et-FT$^R0Xmr/
MnP((lL+.;-7>S?*\8`Z2$fU*ih8b;/*?nP[b=k3=]A]A"-cPtI33+K9W1W/[F?L^4;M_qnE@]A
]A9qaToM:T'R5nVTPI$>qkB;sp;e/2=4o8"/L<?+Z`&!dY+:K$NDXom]ABXN`<lek4HoAc]A"'c
OU%;?^R'R?(eFa>+Q9k6Nb$@l'VZO>3al665erKU.gt<"QP:Y*]AEgBXp,jFRk;Gd?.a_m"=?
E-sb4r)\cs69!g@^*_0=IhPAhC'gb>i[K)_tku"i5dO%gcj%WR,8:U$A4Amq\?4pt%H9kIgC
+m1gS^^kCW)cqL:M\acW!Q[FU>C`:b<0.CSgP@2Suh5?O27a$QW[?1/GG>J:(iIj3\[E@[0S
f]AWCLa;e5"U03[;NM9H'ti4\r3+dH^R^tY_Nu]A/Q;pk5Y?+>$&[FFQCDcX[KcI)$NBX*ED[8
it"X&9t\s]Aidja),+,/6%T34/<n(/'H7s5ZHI<9CBr:`(HT>33E9J.aSLKg#/qo\^AJaXY0W
:^:='Qko;k'`$bLc04,s'P+&BoM3'Vc2f!8*\3n:PqWbL.80]Afm`!$CIbcL#Bhg$KPeOl?;.
j-r0W!HbYdn2'NsiK9inJ?\H4$5f3&##LD&E8ccU!I=qaq\)H5lMU;3$m@I?)9qe-t8tWHWO
$"@^_=7QBbr6m:ud=qLa:KKor!b:(EpSG8VN(,-'m7X63:,C0H(0t^IN7A=B^R*\D>4KdhLi
-L&`a3gg$WM;>CT,[A^3Cj5IJ_q6po*AAD96]Af1/!5BBqH+o;p%,Zq/%S(rGk98K8;%+hq/+
obK/B4NpdseGGIf$bg]AoRL23bqh7Ke%KI`;kl^5V2k2?"OXqcA69+%5laZ1R%N>!2+O0m[s<
SY$`CfDS4`FW:Ss/M"lBL3ZQ/i0)Zph(f#`9D!o=:U"DShce:DA?B)/opfTTd>k=c@<B[Ve#
.)lZMMnVVjBrq9lWKm1Z<XK,5h2hRH#!&4t%+I&[V2+?IdBed653:iGtR9]AqZse>t^YUs0[=
OZho*ejC!XE*\%Y6A-a_S<LamW]A*I+D']A6,*HjJEVng.23/Y48Fd@C'j6!?"3aELA9]AC0SXN
M8?fnkr:=iRci,F<cLAAlHe^*mS/-,H^BneSYJ>4TeW\jr0W0E^KfU]Arpg,*^=OD^f#1\gTn
8:2W6+c]AF.cYQ+R8gIQV\'24J=]ASaVL"(tqtB1[gm&Z3HU2!3CYd8;75ga52;EJe]AI%NLfNj
c/F^X9M`sg<!k`uJc`T`hH#pZdu$XaEX#YcY(&&i11bqPDL"5E90#M^hn2Zl'i6fn%0^BYMs
5_/5GqSA^qS9WjRMUFaCIAj!Y5.>!Ctd&`T!`hCh0jP`38``CVDFq4Y7LbD"mN]A@r6Nu".O5
2Lac3X[GNl$PtEO4YVc8]AhF5qUlmjOjNd:Lh07t;J<;eB9BKb@6[E%R"hpaR+k)_pY?j04UO
dXt(Q!72WP!.jFUmLA.JT(_uBhqWglO1?uqZStLi1(sBgTqG'\ssnTP%$ZaS[/#gp3BYm%*\
`RW+s4!PkJI(RtX\4=?ZTDVJD#0nMi@"T"Fg%!3]AXq:Ysp*U&kpl66+P"f0?Tga=HLY:mQK6
'JEmors\q53QM!I`ZFCBRa0j22r`26FXjBi^SLl5)7EIDL3P`A:TS32?Y_(M;k4I02X)t>jU
00C>IOupAPO\HLW.qgP+*?'Xrn2*-u'WGdli3).>Y2_-uEJ'HfKS=VmAFR;1OSK4:=o9!.P^
'L^KP=$qP\:*7&X1?b/hPdGc@sboKuo2Prm'@K\IgH;iFZeIK,Per!?eA!Lq#56'E1G%QTfN
U5nLQ=es'$/OS,M.Y;&mQeXR0Sl9,8di>f<3geuL(:*;P*n;m^LeP;jr3tus&(XqF^1Si2PY
W?qtKBRFSVSs(cR_M*NGe$+i(4K<:=r\F,NCL9OV*q#sH+KIq8SIZQKED8&Barga;Q6*==;`
8\muqImnp:1),NkOu-7NOoB^8;u0DM*rj=P-t<*5k,Fb=o_?FO>#TIiR2POsK.)KbpN'^==d
+J&/rfg'ISL`aYM1.:kA/XgUCYlPH1R=9aH]AoM^s3>3`eN\VEIr^D_b`U7;g5,g;h^9E65U9
1=terbI:nD1GT/As2KLdPRs;S'-=Co(/h#g75<s@X(^CjFX]A./XWhg=,gsnR8@g34:YpeQ`.
P7s>/(*!fQqi;o;!5tH*7Z3R]AS)6dJsE<3+k=HsB:@h"D-GM<SF$^7.Te]AKD_E;KVrc]AI+L^
gbEX+b`9BP>hTbrNPLq$)Z/bEf_`\$C>/nKWlGV[[JOPK4Wm@>+21`$Qhs$@K[jllF**]Arr,
`UQ,!)umOJfL:Ysim>GPVu0FXM$@PU.Qu>K:6Dj")6(Tm12rJN.%SgF9`\sW[d1O<mAUA0a0
no%FkoiXkTud";H_K/2T2\K\%:m#KTGf0J[<Uf'_M_Wm>6.S^WnA+h8Q'PF-2F)WHZb]A2#Xp
SFd"h/&5UZ6rPK=/&dq4EMg%YX.1<AP\`-<3qg8?%6JR;(%[L^jla'.L#$1T"T2M@<n+.nC-
-T`OoML%pPIo+%h_q`'eKY$B9WH+/\4#p7M8g;?)#RDE)2=/rq3-#([L>o9QiN\u\U$tIBpN
>pF%U9E&9UGle2*B7]A^!Xj=)/7$[6)i3D:%(m+6h(ee8=qD/bU802$^Io9l_[-0E^nCN`EMc
!/;ELfji/3E,dS&mZ7"CeJ[WJOWIT]A&<6)I$t8%&$H:P"n(icSR=th#`9tgt0^\a_2:Y8!X*
YheUE3?`SC,JNJ4el>%c[Bn$5M!J9cG\9"E#6BqmF!dO":4'*)RgJA<ihdoH$sJq3"H(b>W"
+9r]A0=/,;8Q6oB*Q;6t+\hOD.P(16<B2'iqpT(3L!kUS/5&XjM>T$:-fbdk_'fskCWN)ar!9
/^H_3qAE7!:&'g[_ZH\VcnR;d3#KTDb?[Sh8b"\]ANZIu4eZ>9Te\O;4M/Y.jdVKtZ,N9]A,]AB
phKNliL,sbZDp\=ncgfLJM0.<@l>*PWqM:?sENelN);a.6,["I5YqEht/3fn7JJ,&Zr2kK!k
NCZDC>NLDmMM93f!`m0KO;XX-$/n7B,##(/koo5A3g^FX;m7.rCq4iA#P"N),gnOZ['q!E<!
cEQE!>l=<m<q$h"nA5\-"']Ae/(4>Y>hGl:[Be_eSGTET#u/`1E\>giL<qFpDI:X'QBu#f0%W
2WaFLm51E(/jg1NcN53`'L%_83$^lk^F'$PX[<KnbEhj`53qjeMmG^Q$[Huqsot>'6r&N5TD
m'm0nPPuJ]AD"ne<bpo(jY=3;:ODdi!U>--GFKcWWXc$PqZpsJVo2[fn'2B6-WDM2/Go(g":*
6t57_5DF%mb,fNupgm[i$$MF'a,g'\s;F=rrsr@-ogi]A4'Z/'t`Bl*dg%$O;P.T=OlVISY[:
LfZge<*"=m1P[+?2FLF4:`IW'ZpG[s[;5[$;MA]A/rhaYn:Qgt$&te/bRebFmcqHWt!8<h5#L
Zo]AqcJFVhl?Xsg%X?;`IDi5hrm7o(I+^;d.lQgo\5f(\4%O,>jUQU/92iAIc)p&!CKS!^^op
3=!\CG8BW/YTt0ot.CTZp>"Z]At+2S]ATD.LJ@c'06`Z]A_pA2)'dq:/-<0[f&Y2@LW?j'#sS8b
[Ydp!Ck.`W2<h9i3_&O1BM29f`8D4ass(aEshZ.1t=P;?"&`3ckRaoF#,1XlTW#'dEMO5g<t
ea(G$#<<aF"&qM47hmbU#5#;jcj4r=u-]AMh_KE=@[f=8fGIRiBDB>p<X_GK4e^rfOcE`8,/!
Z*H[UI*qV)C>f:<pf`7^d\Bc)S0RUgBI/)=D=q-Ko/W'eWd,FT?+hEcX3_nASMV]A?p:-V&Wr
?7)H-hE#rh/*$nFG@5G4OoOrUo#h&0"p`J^0.:_#F-ai]AE,g3%0Xi)h!l=Se&qJ<?Vj=G14+
"L7p"aNnQ)<"/YJ6SV=jU;"KRj6Md3/!UgmULq+;OB3]ALH60!AR2gZJn&2;#4\<@NqBPYf(I
lI<UGhHuh*PbghM>:<E(XjZR2%/q%6/Q0+e&HLScAcZ_!=.fc5++><n!G$6qE\-OG/aukd]A8
^V@Hq7]AC2nB4[f7".rT*^68b'&^W[$c`\+6:`JapZ$=Kb3gb93#(6$3/l[X5e+c5U"KZ6'-s
rAl[ih9)uUfja/j&XFg?W=hQf-Z1"50(Q/P5WD:2Zk>o$et=I5c&3,!bUa/mmNE:t3u%XXjP
a\2;dgP<T:=:)elblp(Y':$H$DN!>(V`hjFQ*-Q,qcToQ9X''G8QqZ4S:::P-0#H2G5a5JM5
#*^M`4^'dj5XH)-8\U.6o@ef#ph<_D:k#(:3UkFe4XM[qMXL';o..rU95F]AmE1d<41c@;sfO
JWL<RMuuV_<R(4Wk_X7H:(:cf9ki03t1U_=_MeNcejY,%hSg)d^*-?ViT,ZVh%!,l\*0J2@A
VXc`mk.NZKFLnMHZt=meZ*I/!339^I.ji,EYfP-`8dU$+Jnc!67'?KLUK\`^UCIYX5KYm^@?
HV!^?r=inmXAtonUK90krD__)lt]An^Lc5QNNUWiSUji>VhJiF4LAM\L/.b<>`-+IaT"3',c*
s@2Jn/8f9#=jEbVY@YaoeO+(9/I?c]AO5NJ",CBF7auNE0`kVRDEQZ5NrlF2HAs:o(J!+TWb%
:]A,k&NHtQbiE<8XSB@ETghi"XRBiQ8$\)b&KX[6c*\-9._%GMP<VKRIKk+mk5\2d:/#$_1:^
LOulYK`^&h'a8I`;hX*\:umpMaH#JR<lOm:guLa/KIc]AX.=1i1tJVEQCe=\BAK0Ol2X^;1M-
EcTY#*SqWA/&%2EQD/^;PU">k3(UORF;DhYg&e$lNY/m*gLII>nSqeU%e`j(G#BX*S!.UK[/
4>bgbnJa^8?:tK7eZCL%IB>h".U/1'PIfu*g=dsO2P8EPeq!Us=3Fj"hLm,jWZfZKa(+.U]A6
l\]AOE(6k@fpt;6^Aa7VK0+c]A>=oW<ZTjKJ@FpXa2&!u57N#XdY<44`D=b>Skq_]AbS`HUF5n5
[VLJ=Y,I!!<=Q#aBko5pH1B0_V/4LeL?6lp.X>.9p\+fcC8Oa#_5r<2Fn1#RODf&j95c^Gb*
7M0(HU)q7W/X<ROGRl-4m_V>VN^/,9cVU6-#^a/]Arep^R((X1bUoL@U*.;i1om7E>Z>S@2Kj
L5X:mHM7nCZnZgI#@"gpDG/a8kN8JVmniqLC7Ug3Bpb6M;<Q#G%E2A#28%/I]A2LC4-O(i)e]A
F1P`LE'PQBLXjs2FQ-ibDq\GIeMKbcJ_<I(iP3+KKEiq8fn$5hp#bh`+Ru5uIXY<'D</%dh/
uG,rq%^<k3_PEW.R:jW(Nm'm#`*15ts/'^i3WC"M98gm1oGkerZmF</NY_3>U:n'tp4oOFj8
p6"bN\'/&Xj:JJbJ,'+LA=L;l5b/nko[,.eb_>IN!k)P`LAYCeW5[Y"WPAaGs]APnd'D4%!?>
"JVA[ehc=$NBM2,o+X?I$:bc@77!4:(F+jeDtG3X[13^\^&VM>Q%soDdfgINN'eN*:9EI^RT
LRpTF.op.&+X,HKMfBPnG0m7E\0.9c(+TPFXh&KPU?p#ggj<_[JO,,QDp4bQO_O,I$VVcNef
Asn#VDJ7iBpEV3"V)1fi5S%Ts,B]A)s`^#!hf[6%U6ga0OZ%MMgAo!t]A"*oh.T;-ED[ZHY40'
C4aeoN"XLE4e'@iBl3h;-7jo=V0eR"KmQ'=9IW>@=/0ds`!Bjo=@^Mo*%%kf1W%[Jk'@j%d0
J>Sq`1>]Ai++f$<RePnoi#0]AH.6GEV9omIr[R,)/sgDSEm`a5SYC'QlRl7>_^$i>YNVZCWj3$
kr;BOMoep0X/;a3[!4Q4GdMdYSAO<2Ub`+A.QGl%)2\sEHsNF7\M=5-\krU5EmH:ZD;ML^SS
/C5u-rqg?s"7n^`[^P0gEArbPb/r+U%k&F1OMp;?l-a_UgV-K0`V)E7FL79`HDKaomSr+Su1
:0p<hL<kLm]A\6<-c;b8G:Mr]A'FKi4qE.2#nM71'@`68-C.lm[qr1s.3'o?9;._r`P+nM?CDM
e$"Kh\auP@@m'eit8QY"E62^^(B@d&#ppo&SG>#F"tKIU0)n&)\%uI4WqGmbH=Cq`4mfU3lE
%j0e_WcO/.I`79XQ$4D;g4^u>@r4#=Xfd4^:p(]A=WPprGES)tS%aEL$:Rt#>+Y+FI#jG2kEZ
+K<%M3U0_#Q$9/_0p&bd,r^Fji-FEb@9gWh2DXh;gWDrH=]AEq,+ZHf[b5X72=8(UO#;hj`<!
ejYuOkDLpK(>HR##ZIT7dJ4"ES%=/`2DeZl\>gM+3c[=]A#P*[Oh\,9U<'nEEGh\+h%gfB^0h
=4;RSb!PH)\,4V@Xd@V1"qjk9bS<8"Y@Tq-":pNsT<4i6p@ln+)iER>ekAr1&_#1Z+L^EiW&
_mVV-$Phg0H,!bEc?>W4qT&5<\D!9;"uYiMJa,)^X#VW+a7HhQ3ork4[k-.[Z?f4Qa2V?SLR
u4+Ee..,^"@k#/WE\i6sX#BG8tf`UtVKQU"<@4B#r/4H-j:<7q*0@*BUZspA\r@U+QNK]A*HT
:CC)Mi0SlfKuZe6.X:nmd^`dh!5SW^%>Dp@JW)>1m`.,d,JU5VXk*SSS^@?;*Ei1IfL!%0qT
=JW4)J-r-U6RW9I0nn\:<#Ac(o!D:_h""Eb56Q/_)[D=ZucS:EuAbEiVi0BUdNk@d6PMH8E6
9Y&MIFXko<>s@q-,o4"Nm[I8(k,R7T8;,?JiF+/pPY_"WCm[7fe7m8[S5"0;=Sc.)[ea@n2!
3Vhh_aq1'5rZ<"?Y*i26lM%c]A>;a"fXU_)8E2mD2he3rJjo>Vs(u\3mZ+6X7pIR/a&=IPoki
$cXmcN%uj3"Q[7?IS#D=6pqUW4b1!OQlVI/2l^e&\O_1+b$Hf4;UICHX8@4AR\SWq(**biG.
ncs==W)^omW\WX;!?Yujba-+D.b"2Y"`EJOk'UaN+10#4"OB1<O[MF+_PB;fn?6K/KPt_-WA
,(M`KMTmlm^8[fIRA2L;a\h0F7L>?c?QgW*r12R_b;0A/[*[U6q+gAq9&o@eM0S,'HX2JE&>
Qo3;ab,,?ZA%AH7k,3oqo4]ANT<MDiKh!E6c:@Q`I;>@]A0[@Jf>n'39@/HW*]A5l5K%XS'Q@7g
/2F04ApMVM!<u/1[GjXHCGaiSCa,>2NTrB#sn,a8;iL)l9Fd(A'[8E>ZbG&V$0<DRW,]AZ`d&
Cq$j3+:6U#*5]A.\n`8Bke@_Ef\q'iFp!]A:RkMZTu/<H_*u8KoU"=TgW;:muh;3j[dNEMg:^X
&]A@N)I0_mle5iAdSsTYZ^9Pnf2qN;2+&:c&_=Tp<PLEX5)H`a?_p0rWCb%*p_2uf<``d<dVX
;4^JbrNc6gW:H%1X=(6G(r!)UCNf*.!kk4!rtPI]A5GJB+Pu+`^7i!H3.!B:T0##m#f>+o[MV
836"*pMo,30A&4amj9:-6f?kJ68!#$A(qTi>Tj;;9"`d"r:L5uQQ^>HqN[;9'&S\oLf1DDL?
$'LDT`fr5E0'HWVa$m`q;$"dDNj7pQ]ASq7i,_&c[9L@Jc/J1^^M\*101<bT*4"j'nV&AP2cA
TGql$-L?]AiW<(6-;gI./Ue""kMLJ4#i&G.+)9S6qV$cWe,E'TDd^W*tYR%%pKJ+S:#Uj57;(
6`er'D`J#Fg&X]A_qg-oVs>Ak.f3;."NW!HC,q<02m,BS5+JCE@D.Jk(mh7krN\oJ?9=)]APpC
;!qdFC9<;5IP@CQ*#;qu5):<cb0A.F-?mk5tQT^ToEA_sOj:Nq^kQ#S=R@Tu`[\n5($C(5NJ
0!aOAnptT@I)&-T+.R`UWL@%UpDQjGoIN]A'mq\l]A\C("bIO'o9:"M"m&H**tRb\sE*_GJUee
"Lb1K:0TAAG<Z_?DsB>s4.E+Q5a3NO'HD*GfBJU:MtLf8W<c.BjB]A[k68(+:pcEgIA4]A@1Xa
(*O%?ho8*7r1WEo`(F$d)+\r>AVdbB<+&=q@F>Fg?M-R0AILMc%W8ItYHco5jcb/+B?`2#2Z
0*'tEp1j%gnE<D3V(GLQ(XYeGhff1k>l>A_fBALe!LL-W:Sm8,mYqjL(1IrLKE(+.]A*jlKZ7
&l.l*\Oc6pkYUR<58Cld=rW3(kqCc=NMS@iWpI*!.n\]AM%ES%Oms:n"04CuF9JHN(%.W='Ro
C9\=,PhKS8[Th:\_A#O?.Ouk&F#Z+]A@!*.#$r^dk&CV/hf:4WT1qP@B\Z##'Ug7YHI".3+(J
DCo\FUu^^:(I.I$+8Z9="#>>&bC^6+_uMQqcQ59IX!74V*i3+,s8hTGg'l6g2>>3cN-pC3:0
W=4;#Zb(d8?r?+e@]AcKMi\d'RJ]A%#Tl$TNE9aus^0$Ga(9+Z!\iEkTd]A\;rS@5DS88P,8TAI
FM;Yrs%7&G`?St)=*j[#@4;-91OUqR.=GY1Ud7X=9]A9-Y,Hj)hp-Cn$07HSD-\/0!bX3nbC$
79I4JsV2i$JLcBL]APW2E8p`&_T>I!U:3m8k:8]A7E7CT?dqmdr$<`<g)7SFD_G/"llf5[^IQ(
f[^q,+NZ&8EA-sp_pbT2+pVfl6+s"/^L^hR);u)P`Lhgh_!1sEj!5>a@pig;4g?AYncJK`@?
7PB2iFX9/$/[HQ,Ps=97\01bj&P)b;O\E^?$$`pJi&t37Kb@rp1a9VHBSjNnZ++fIeSsmMg)
54\80UW)l5e+*tLnib"1f3$bVmTq,hE?md$([Val'B)Jg?)EeVl^G$Z5\5:f;\0W&'MLR!EB
3\>Z<-@*_`T2I;"%K\OL:?a:2m0^k\b?a7pm8+7,[5cC1l=[*#HI@r?g,Ln1e,Sp<W=_49AN
qb.["ic_+\Rg#1Z_6MpS%37A!$Oe.b)1,j-[;h)uEap+%@cSuH#4]AN=I_iJko]A4jjer_D]A`T
q(Qh\eoB`QIGm'u288U%E&D48b&Q&JSFuYD,>X#&Lm">K.eHg;m_U)ephOXWGt7j_$LpS,"!
mD2QCIX`8hjTcUiST^EY8g+;$,RdNSiB&@8dPbR#J=J_n>Ca[@>k-"-W/@$8lhmmQ4@M\I#C
5$O,>N@q!g%b)T0b7m2Fj1sA$Z.[W)F9'pNm*%a"oUoT2&P2S,'0d2<0'OSW.C%("a$C,gA[
ZG[ZN>.!!%Sna@$TEpoif\[Dp\PQN<*lYWfEtEqqG'a9SZ.X\[+c"^5kC-NE%b*.->^l9[G7
1U4h\hp-JU+o7"3Bm^GSp4J8'7?7<E`GZ4+Fe8*Xn;%bXIqGZb?JK'$B[U*tRQR.Se!Whtnn
I@mXtl=Gio51hA\Big>TQ6#)\jQmq:B*j#gI26UA-4N"\)uPhel:[F+R)X2?04?WG@fS$I%^
FIXmS-ZjKIlbi/9UV,QS>3uJ,Jbj>`2h1T`0/ERj0kQ]AsT'CTOMaFMe\Ejk#O1U.Ht'@8JQO
LIQ.)cRlp=P4S#;l-gUH]A!;[CokIfW30heP:":O]A5lDS]Alc1XV9Ae)/.2tWSOT4XG!bKM`TX
e#s(To2Sh58+-\0:R/)+S<j3bWsm]AR^:EMb#c>=+4H-n(m)gl(0S4i/YO@>H/B.Gn);8+A09
eE3k*'Y7<VVlWM+\K/ZQ69-\CLfIRp*t'S+&n3\@8^07[\1O2gi]A;blohg\d9iD&uDS1Q-TD
[>921Q^>:q\)!7_oTpAorZ1i&'aX\ECCYL**QhG*2h]AE_f(F?6-uTp#:5O'RahQ5oTtuOW7F
\<G2?7B%^`Zd-*,&MdqI'p7DSbOOii<IMY>1Q\1qssuhEF;s&3`s4HZ-LDX\eGOFg_-55jeJ
+#Ge9"fprYPZ_tU-"hH.MK<9df7]A5(W,8SQ!@DYl9gq6<k[QeRs@PEibYqphWP>qiHWf90%\
'NI^+Gn^d`Sg1B^3ShJc/9/tQ/5t.aB&u5T3*PQ97[u>e)]APnk/>@F8N):+-^\!a.co;)Ej6
SJI&>MN@Ft0\rGjj9i6LR_/*bUbl='c/C(U?@G+=')$hpNqK.*#_-,sX49,j_(s+-Bq9"hmi
79XBm>q+7/^p>r`$<4RidKir?+Gl5Ib0%^ofUSbP47sX@GV4,T),_Ef\t*Vk<g2D)WC61_T`
lcECiBOmK;7T?E5,]Ak1dEoM$rGW3J=3=gq9g3h""5sl,g"oUeC$?LruA#'-'h6skcKCC,d;A
phHd+qE!P/59BGo\%Plr!gY:YMLQK3l25BoF$t!tWUdjm(:'Fq2ic&piN*;[@L0,*Ybo,QZC
ag%ZY\;nQiH"AY2^U`7!I/Pk%]AUj16J0caiG6G+-^@>6/nh(SLOo@;nN/GtGFDXd-<JE4c@t
8RE(t!u@`^k8HA`NFMpn=Q!IOmdm;?f^+I*7(Mme/89D2hh$;[UhHT]AU\k=[BQ9W;edC@<-S
TaRH_li!?h=>[^aC5'%)cb*Ou=9,SKY$!cmDp)]A3YE:F!ecFYc]AfaKOh;k\j$R-7N5JD0`^;
+hgp1&;"Yr4,Fh-Y[`?i!,>[Er(70mnug:nQTJ:!PY^[5`]A1,UA=#(fu03+.%"r-K1i]A7?]A7
'RHXD7#5^KoS(P]A4.+@Kd9g*WX`u2U,6>nTS($$0(:OU!Y*$sCZGM(p@et6a&.tVH?&'ls^9
-)Y7\bmG'7[uZW.EsFHfJOgBjWAVl=i#QP_nTr7BFX/AUKRg<MO;LjVD=b_1&nbJjsr^)]AAX
K*/01*8]A5kpF#Ce/>mRG?IM_h!FW1'K6O,":2I'fGWad`*c@tEQj5B3H]AR1g"V&7UWG0p2Sn
1OV^Z!88BLhXCIVB-4I5^9j<(:Mkq0]A?0`go_fnSVE/>BFhV<]API66;Po^:*\Q!sL:M*</(N
A"U&2g=ig7ZF&W>K!;AK`ZGo:iM[ed#W`T<sqC0On4P[/n#82R7">V;%mH'!s%bQt1q,*&KI
>m!X&6Y%e:SGW6lUP0M5?"U@]AoOc@p0\U2;mn=nn>G!/9.ZO=R84R%s6e.#oq_VNr(9mQ(&i
E2Ho0i5$>D-cpU?sAi$-len1TmbX>FHsdMs-P8BQ'5u9@6@+>C/olG:)@\bWsDu=o)`Z<8L5
\WiRXtQ]ApaPtMXY'a3+1Gr3=A%B"-h.KdRA[<N/phm#,RYRP>"A&h@q4n*!d4m;?<TKm.Fhu
`XCPEk@8SggI<E)<K'N[Cc-L?85odbjInob]AB9dKbatgAbl%l-=GQ$6[<X@t@No.omn@k.(Q
&.1/&<?U&1@MeUuNqMF-$EMc&hPN8`AumN"9*o>CK$O>LLX*7eZ?37:0:eoniG!5:%f>j^X[
`K#r#O*?5UI@Hic,<Rib-)9bsCb3o%=B*#&]A?@1hpY,>6LFM]A8:e'Kq'atdBV3@EoWUhSu<r
G(gF"/`@>NaJKd7cK\>-it__-k&Oi'/dT7/@:[79l(=R'[EQf`l3I/(OT07W(m-MC(oRNIPB
N;M0-N0/O%@),%'Oj>uV\+-T'W6q4Se]AkTSKgGBDYeDHqiTBN@?YTpY#=.dkK^]A0<6#!LD&*
;;fI?Y3f'@ipZioK<rF/EBG-5fGh.UC5/j]AUd"%Jrm\5^\k('U(iDXQFTGoBqW\i9+X9JFUk
fnU`f+G2-sXaib4SL??l=*((g\qgB2R*\MoBl8S8OA_TV0Pe_m]A/^aP(lT!$sY.8g?\+/g&H
\Hj1)Urqrm-EP(,'"!fFO`sdiKP-hE0k70gUpG_,\Jn@S<E5U;Q=blPK6*?9CTS-(I,ck]Aum
m7RiHjI6UGoqn^NjLQ)'9%4$RMK,jW;eHLaV\bk@(P.)ngoB\BU#AC!g+Y$B#_N"^c/RF*,q
j$pdXn'+R;4H-T%J,>cGN_gD((Y=t8$'T&N6H9ksBfYIi5cr.Y:ar%Kd\1Ie>,!/!)oE?U_6
GY"79[(BDJk&mfh:;cuI*0LX4><puS?<VqSI$Tj#(HgCL%,UTr!NP[>h=@PW^4gssY!9&d!i
oN?K,M6)Wp*q?0'$oIC4ah'lL./I/jG[Cd=5`'/%S28A`O7&XP-p]AH3:<h6MVIV-B_[UM4EM
(B6W75+VGe".9eo*kc_TMGgu]Aom=X;0CSHHsZXl`=jtt>(3&9[jpOs*,mq1HB!I&-*e5$g,q
7c,S)/jmIf-b_1U;mmKoY,g_6hj+Y"X>TO=cO$_$lm*"(2UdZ@DFh%g3fGPhX_Z\F7[LmPU>
p]A@84Uu:YL,a4Dm4fpC18U`fS#37p<SJjM\e3fJa=DXZF<s:1r-#7^IXIOdO6V9sp$fmqZOM
3[9*I!7fgb:p"@5ra5tgLRD!PKW@RMJtBpW-8[,^?:P;EF_3T()Aj<>QBr<UicgL`L@C&t;4
YY<0Y"RC3ulelA&_/<]ADgXXf[=N_o.u5/.B-.M41%S1^D*Snd#jnKh>KC.;DBZr]A<%/r2m79
r?a2,Cq..O-+t!s&ph2DVma2RFlZpUM<%'5jMN\r$7<Al;X_LNB75p^C"HPsf9_K@![Qcn=#
h*1@L4dLjjf?i[!r,"$i%)Lra:#kS:LGl!7;ORGg?[]AVYC1er6RQ5?,MhuA\)"p7Tg/Urh1&
M>GAri-CEQTIQ2[oiUJk(#0"Mf!D<CERh3]AQjM(n>bKpb?(^kV>EI.7^PhT[9>\%s%e!Qt;6
[fQL,<SD88'9rg_\6+>]A%OVBg8.Pqp<l)e,g.pZ$S,0PE+V=E++%XL`FZi"b^jR+ZL@IQ3o9
bBD\1e?F4?g>6k,1e=[3-/gcg2:?=5=CX)&mp='jT54GlE5l&["ZJT3NDIq9rV0]ArlYBQtrT
N%U8tEp\f^]A;Ej$u"&QZ1^08K`Bu/iR00*[E;".XlYa@2Ub/rgeIk\@#"iW?^pEk\4A`/28,
EU2a*PYT1=[6/dk/d1;cV/^\LS/bs3Jp+UOGQ3EB`?#,n(7>s8q%Mf,_N'T[u&^<SfFTVVtN
TtTR8DkTf1n=D>#F%@-R>-8E=f.jYSP^#S/E6kWZ=E3kNXKK'KP)DptdhOSAIMOSpjI6Q0&7
n@uL+N@:1G,h:!o'ojlZPjG1UI/b;oS>PUQFa(h\Q9AJ$r]A-_u9a6<F`B>Mok>8Gs/"Hs7T9
\ONf`D[TahbjkS]Aenu*]Ah)":Mjmb%,I>6TCmA@`U+>CW?+P.%C*IIahq#YhNlb9O<O"b%UQU
C<FBm[s'b)lgZbL/_q>^(na(+8`.-oqcKtnF#sRPE)3QDPc!oCa`[/WgfY!Ifigs-bYEj?&-
VU<UOPflY^StTLn6_cC-lm`YQ,)*Dpj^k"0Of`u@U8<R4<t-q&c\jjk9s^]AEm&1f[qT^7`\e
n9i"LDe,0`RqfN_hu?\c/+/a/_<7N1)%;GsJtRt:GjpVab?>9sGEEdi4+0t\]AgWGMs<UT)Gb
)8ZW-[s11kHG(4,7p]Apj3iShsKiOKIFi4oc`o)T8)CGbCYM:UWOG[g#j&h'nT3D11Z8&OEFg
rMC,W2L1L!3TU0RR;Q<<Ua_nQ;]A(8p=p.bj")Me(8R*VDW9lAJnXZfKn;L.9>Ka1.08#7;_c
oru4B$+!F13R>3V\+K)c(d>ldH"m=/djjLup00>d0orCD'?T!jg\bI8hjB'Z'ZU/9Hr*;qmB
uYul)ES&49@f=Q6s?gFN%\/R-Z3jCghrt@]AE95a%f7J:5<7Bi$[]A([YgRnt^"K-+c#kSZ&r+
'Q0;O&WPX\5B`&GqKC;1WVT"/)#O;Z/3E_F/(o@c40*2P`Z+"Ao0dJ(0+IOC/X,rd5o&.e@`
K9+ju%3J)&#?25._8o,tUYE?)dX0.p1c1lK[o'aCjsm*<$6G@<q&fjrX,b+Vd@XQ2>(9-J%c
ZD#>/@_;J13@"E"FbL((A.+FYHB`Tq8h7J\YQrih3CTCVR'6;CP.s-QNKr5"2C=I86[CIi^T
g(S)\P),E%oOX+$.bA=DR*pXXMAfa*>jDMLWchr"AUh]ALkQf[?[Eb5s\%B+LQbV!qGn(c1ZR
7\]Aq+d#X00L0G%%LY4pr>hNRPDD@0G!1B[1T9mD\/THTZOK`L$+I[?&1aSV7DS/:Fnj?bIss
<OV/66ee#9[S]Ae<+rVN0:?S/k$*O*T9^\UCSp>fco4%tT@eR:Li/KGTRXO3LBpVRUX=kD`EN
'c<]A:j5\)M@4)SF^\':SP49^Q$#GmH*,[DX+c1:ijC!IUc/YYH2K>]Abe"E9QaTYU]A4FKfaf6
1g\C6Nqga"30;hPRO>E2TX,`?D-Uo36#;W>;`L^7;p-o9C4FMFU203!I,Abn='s'+fPO/6a@
@oS]AN/HbqZoN\0PJ(#39IoXV*%B2@Cil*`T4I5?iH<ctj+ZB9]Aj+e/\*B9PmcDPuCkk=:A=j
At=$Mc]AJp%'b$ml%JasRt'(i#FuQX180dUis^LGi^;*-2FR/Q.KV'u2o;1PF3A$s4.W'DR#g
H_&SGuZgs@i7X=5Od5b9=ACi#*XP\9BVAmGZoF@Na^GKltEXC4CHL<&CVa>YO)kL&ldl:r[;
$(F&9/Gr]AjH@EV-mOQ]Aa'KX@OG>9o33ZC/;7p`P0F>XUlW\]Ae]AM;=<C]A1rLLKR>QSM[LLr\^
luV6]A+K>P)0'7;'qoJ+=XR/Q9p&3EN)fYd0oFPe"_t4_e.ig9P&(c_pS"P?(Fol'1A&"6_pg
I#aU"tUD"o.k/ojY@^\CkX>+kJpYo38S7*scRE.R5=qmI&L91<ua9^NX\*>U]A-a,nOEgA8$8
=n#[0csb.M=HP-)1"\G,&&&GC:$r-P/"HL*61Euo>s7[4M&DT(g04!$MG`*-s#ln>g9[+h2/
51'.#*;U+d2VW[t$_a8,6V3cf<XP)7=ic-4/]AL(3'n.cT4>d20=sI%g*J%E_[gI"Nur`K@La
`UB;b(FT,,4"(72>o)F;'4H'2a%:lGL@0W/Ns.CqjW<_f`s^h+pf(U,)42"&Lh(P_]A%h7Pii
F-`-k7Ll6JjPuW*`\nfGm&qLE&`Y(IiRd*hL&'_\`H(Tt[B<)^c;C2+re<g\$gnCWoZHpGe9
NYH^GHA<=_@^Z^D7?6"=[s/>A/j.Yi=rm-P.Po-K"Z>W0t'Iq97.7n2?AJnC.23E#8V(a&)2
j-=tOsM8uetQuk)`qWW1A3G]ARGTmOI=GVu:Yj@gHsbdoIQan+cc%nccKFdZTC&.i?1/HPHPY
]A1Z;:2Y9S=<51E7os"If**oN`%T.>tTZ/We/YHL`gW\ogi-hb1?PSM6kbTj1S5qrK^9>4t]A$
Q'SD.P]AM%4DHp=m(PsJakX'CGDGZ3b-?tlg,+E?fjAfQYUi0e%JV3iccKe-jHPHB>%QDn&<j
9O$UNmJTLg5AG6?t13s8A8?.FOmqX$P'/N%j<J&$\Po#?4tHGgj"249=-4=_2qL.QoUT=o"j
Hgap1]AJq3=WF]A24F;#cdKE82s6<V3Ssh7d&@n-T7tf1^e0$Z]A_?@H74r.BWtFq&eKMSF#FQ=
+?-CbA4lnpR'cD4VNm]A/u>B/]As9Z1K-88TRG8-<8G>T!V\3;hZCfIP'Fg6nF6QL\4Q<2tqIX
SNbFAu>inMWm+(l#7`)c/A&&5]A2]A:LiNU)L&\#W+HlWAr8&n*Q8R&\?Cb)6/\7YNAEO"kc=j
HOb0\3K0Q>U'*h>I(mX5@o7[N-'(0CqFS#Z'3Ydo9NCaJPYR:TZbU+lo\.'^o]A)SJoeHA:>%
!V,Z&_me(6UC4o>GO>?A=;YA4Ku=a:_56NF]A)a4g(rgg'4$]A2@R[Mbb3/j[_J_(>o!6Scr&&
'a]A4<;4V80VksQnjVp9<XGGbm=6u8\i-"eKra7^7MSm\QF1K%f+fE2:/ahiIIM]Am?V>jJp[l
)S^q@aXL>7X0YS]A4+3(e.Yfr>_70%_^t"JfCF<@G]At$k0ZmpQ/W:H]AYh@;XMP-&4&:V`_EXP
![FR<-'Q?q>kgmI4K)nIS0>[HTY`!?jIkX1sU)\SFnZ&tMsA^66ZXDBkCoJ9'W"#TBh(Hu2E
jk':mj(oGg7K&[g0o\lCZ.046V26`oZeu0k\?S09mX)t1"Vto9a]AeXBauMG=Hc`<d^?5X!M_
FPg6`Ur;<PkLVH=2(($8,kq"\eP:D_QjX$h`:ipuYIOqh#c8-FgjO/$+9iGi?<7j4WV1PB7=
i=IJCA.GhGlVB$@u=E"e4;.:PaeIotXIseAW+*a\I1dGha>*c^o@.&;.%G5i=k!!K1'"d165
K6uk:qQ(siYYIo3Fp:=(t*nXqtUZhN,)W*V.QBC2GCSanZ9!_,PO/J3+-/trP"4'/"<\[ZNh
Hea%IKTF8)]As`h2/&*9%kl+`lK!)AG]A&G?;Kp>1f;Yg93+;f*nU+3rDSE)[!1@MD+K-]AMDU`
b\uPk]Al>*2B'M(:4b"<@(H(G7BhWs*h"cs!aFN\XcG@YI,o#_!hH@\(ii:7:5BW""KZ:Y\Me
omDaqo(OJmt-%rtTNt7<0qNZuA#>HV'A$Z?3Xu_oBQ[4T):6blt;+]A2<Si,G=DV5jTm,OC!d
XBfTb;NH-@PmEY6^]A\44W'"e)>AjVpMOOr[@$,*n3'`.#%d--g)=]AtQf6fq%9a'^k]AML%00I
Nl?NN+fn[rk=+4@sJ\1J@`rk'VioRi_@+_b1c-L%"OToXQXo=9q6QWe(Gs7XKQlVI%R`]A'%9
*tlmI-P:)$SOLa>T1Li3?)*(P8]AlAI_TotL4L@QcQL>Z4*,(E@kH_'KPOgN6M3U3\cNc#)pm
ZWiC>qr/4H^*!\sQ@M\p5L_)r<Of^U'fo5*Unt=*8eqU%hhN'.\&TGG,M4r1`,_.-<TW<%j0
7ds9K/&@'S66GBJ@G`iUT(hj+0/^W`_NR+0RRmE;_puregM]AqI_b?+lo=:;"-f``:f@rkBj2
Q#92EhGn=[o]A90nBmg0iabZYa2]A?7:15JZ<RnKU#XqRU>!jM"2FUc3u[1JWn'3+g)Mm^MH!Z
cDEqi3=&HjMlE_K5oIPA\gCE"X`-nAM`9pQqQfu;S^SqOpJu""u+]A-n`RB0@"s'IGu,eZroi
aL"e5Z?CS'C0GfsC]A<lE/2(GY::^7B9$C,!fkr9(MWEf_mX#sIo8/L=k4Z>@gCFreYRA%328
5[r:enkDTdGXlPDBp"06T&cGWZ>HLIRo7:;"WAB%;W8jc4\,`RinjB6M@l6uk#CAXH8jWoG.
)WD*.JkZTN+;%!G;'j,a.:pofk-^_(7t"r#<g/F\N6?cjWMRK>n<C9J)&RpQ.51djOC'^.!1
jR9U@`L/h`FK+u03/G'#(,3Rnk]A>(-]A-5Y7JRd]Al[/aMLFq!"bu.Ap?V8a;i/Kqh!?]AiO7uW
tG(3YJ&R6iO?8?*d8p!Fe69Ie?r[D(G/E00WuKba6XQ0(tq_qU3.Oa0_L_ZSU,Tri,uF>1uG
DWr?HgPIB?QZqDJdO8N//mcAR0h0eA@#2o*Zf8\Xq-d`^_&:Lm<@ZkO5T2p=7]A@rJd<fb6gK
J(e`deFg@/V-luoPE0F0@MJAP**jF@;Z)WR=,`_$l1!/u3PqK"2p>@P8e2id[=pY`n_Cq.pk
oJr`2TXOk7FOL7rer5>rq=YT:ug92#s*RgFf8+m0CO!/-9I,W.H,u%0js6Q?^rZUt\@"5Ite
8p7_MemX34DH)9L_#7:5MpO4l7S3]ALkB\n1FK8R&,Ps=G?,/&Kgd9!<,83l$^Z]A%:I**.JUT
oD"!aX>S"M!j%O]AgU!&$7PS/DbfE.B4EEO5bEf*h+c;\<GDmekNfgcRu)*QiIE)F*(\jHY&Z
JJg[38%F^+8#Fe7]A9qHj)N1kc!/4PbD\n0j'qZ\.X[BBJjm*^q.-AG:f)pO;5BNg>j]AS$r_^
UK27XfaMq6A/pLT,408s'$!qSp^oFTDIY@1U!D!D<II2oTBa)nhJ%TQ4s+7$&%(bo;VO]AkcR
W8\3N*^!3R;f?DSHN=#Tb8[X=c!gT=7IPHGdh%TrGqb+*(_&4kBuWc.p,;`1bUO<?_*'UWaR
cj:&9I$EdcU1pgV;FDQE4fD*oBT7UIOZ)APVa`Qgl7h'p+d/AfLa$K.daeM^d*YFI4CJ!'Eb
Zq?mUuSjr9ululm=_%P#W1Gc4^dDMDnZBV0+h9.a6XKq`0J94\*nO-V>Z[N2#;eSXihJKO`&
Irc-R?m/=X@PRR>u)l/!s*InXY2^K5ZZCIJ==,LPI\ZA14kF/hu!#'D-ab=*2^Y<2L@bhSb)
c#+2t9[1ba#Lu27d*od,/Ohm>Cu\c"H3=YhS+Ts1,@[T&fLD:`0Z''HT&CBk=C9""Ec<7tTV
re$6F!<0rU,IS=)j0+Xg)]AdmHdioMUdYn9q>RJVR1Hg@T/c%f]A=#['BRS0m<m3EM+^G3L&Np
4kZj1"_)bPT?E*5RAtln55DfWKJ7PsV^W5_VQ\-nA9S]A.`Z_sI4bJpiJ`-pALS;i0?l?.RI>
ftC:GXKaN<#c6=*9ubP=k$b#oN<"c.@2=/+M:+jMM'J8Kq5lsk8ZZ#2u<du(5da8)5VDge'7
gm5QCr_&N"/%?Q5S^#L>Wc%0-nuS-hDs6ml'gFgg/&NR@F!K4ciGOk;M?h3VL((;l4fWtS2D
WXT"Mlc@fP<"J4N09O2P\Od=tSmK0/,E+DN8g@@nQY*H6LZ.E^!B!17FhZMY_1p\_YfC,Y)%
3&p]A\%benjT6Eo&O2b=NFT^1+Bs5$lB8ZV5?rCe0DpO4]Apt6:fhIV^KL7[]A6rN@$Z1^BU%l7
9;D[G!#C7ka!DhoVE3D2]A1t!m+ddbalnWKlp>krjHdm.C@m8SIod6i\^I]AK5Lm]ATOt%Gchtf
8`l#7L;CLS@%W8#@:m==15O")%hlsD.^tjYd5n7oo7\..]AuWK#kLH[:Vb50*Z*C.'/M3NMO.
YUQe^7,VFhh/R&5R5Np,9jI4b(<qP'+jBorMf->!^&nh<J)gY>cOCUpu>(3IU$.-9*l?)#gV
j)sC(%kQHsG[\dUR?@nDMUgH<bl-A1G:?L<QK^WSH[EB4f()TLakQ;W#db'$T/j1D@)koVfZ
Ub$"STNu2WQjOqChYQ8jA@!Uls`@\_'LGHg!Zp<h@(Jm/\'n@4ZX*XB.9gmeJEU-It<po?_q
d*CbKFP&kQgmbZI>g_)jblaoOX?`oBi$W?8UjEX-d,8@h-iI5Ii,1A9=(0L.GVtPq]Ap`e<qJ
b-&`4<(D$`N@'4r=`aj%]A.qL7>#Q$rarhdYQa!\W9H?%)!3_nc/@leL;5fJhPA:^lDM*31\?
&:=6d]ANW<of+4pjhGE>#>C0?Z>h/TQ`7(c*XBIs\)i.I3XGB!gmWX2dn.MQahRjkd4?*9%@F
VUT'eHirQMOK3VKaQE"4RH>Q1Y1O]AXq/m-QH:TIuh:A00j'A!o(,Sa^a,S?K\rW`p3\ERn=X
$1Jmo_K)Iqs:jF']A%j(pegGmt5AYQ/'jT>drHfN@%O<V4t5rp\[*KQsR&_ntT?;1#<P\M!hQ
8)phB]A;VBi':hS=$^4cA!o?]AZ/EK[5aY4dP;Y[bT\Z>r9'E<1nO)Hfd<A5BLm&a<E>>(!\&k
a9?H9]API=-tRQpG(M1-H'Nd7;Ghs-G@]A"`LIYj=p"I\ccSE4p:M!DOCqELeL*ms%9(<33]AL&
/<m^^).kRKh<HWF2Ih,k'rkG^Tj3Q3:7^n!"i+=fWt5VU@K\M\k+FrD%?Q:g;8@&ut8Thc_r
Pa!*bPa#@-KPbPU`\D3)Ga-Ph4i9dU%0Iea[--SBT_5,"jI/!4i5VtddBk]Alh.1&;MBWk?.q
c3+r=Bj_]A'=q8_Z\LG'V@]Ap6&fA$&PcV(Jba=_>5mVAki;T2H#qmW=+/pt+^[m72sZ%,SP8j
Q`>q):h-nVA)_*MXAGrWbDYI9lOI:kA0#o0IGb6R/_p(Y*2C5gV3D0^KN)jZu7)IPH\28er+
3TMffZ<IJ`)JE15J5h)g"4Re207,L1QXSMQps)@EnRa4@DPNrH=-Rkm1"olk4$;?*4[YhH>9
Nck3sW/+@4lV8I(L3maO#oH1A(0aEtDC.U?L92N9KQ@>0"hJjJf?E(Df4eR*3j9Gshbo33EU
MU,S_HR:9Ro0tY=T7;3tA$bfD]A$oe&]A&0`)%1O2/-g^'L+@Gn.4OI"AH]AXe8efcsob,Moc8E
C?DI`cbW\G+u6MB1--3;i4$!sFR+mbhC"4b.ceWL\>4c(=lhCLSG&[=Hqh49>s2q:m2#/g<j
.p4aY@o`]AYadlK*FL:,f5^L-Gp@jfaqXMg%:#NZ2K9qE9:b/noNL8c*]AfUA.'E4"i_5sK<%C
9fpCJtGf"NI+90]AP?6"q_(Q9=?-2B]A9m2HcZU>H]AXn)h]AS?K3<&k`\i:J4Vio#*d\TdLXimS
D_gKaR+qG<R'gB^!WglDS96UR&>9pf-9.H^,QE=1_,J(/N/k9\QpeTqCV2$/>U*/P9paN.!q
cIW`o(pR"[W!h$rjIi,0SjIPK5T-+$IHU6]A$9P?RnWC^FYoH]A"aqnB\B%lCB"#'"ASIK;`Om
]Ap8ePs.X`@X$lUe59uE_g=@,-SZc%<=NGES+kJmDf`O%Zc\3I^/TgW;H)Pq7Z^>BRg:kDWNn
TK-j<34cDUG7+#K\PScTuA/@%[`D(GrCN\SM7nH.+K;p?)nSd/@/Y5<eQaqq**9l9of90Ss:
^Erh[p5;U2,e7JkGod_kP4n+rMd_f8U1(TY<>H)]A%I&h#ZeUeL98bp"KsKjbqA_+.5\W:Q<S
0<]A^D\#R%/QZnU4Q8,XWRJ_/!BS^j=kEAWHaV@!6M#pEhf!]AlCt`_rst4$>Ipl:Sc6^/W/`K
H,mRD=RBol6itaRma*M?n9ujc]Ai\qk\\0.J;;W`sp\OkVH)ZfmmH8QJQ8obhP)+rD^rfo\cp
Oh$UP>Ofg?EWOIUu^(K]A88t[<-u,nTdIC$3(hem\Q\UVa%\O^L0D-aLiAibZ!itF,EBR(W%A
jcp8J#NVR$mCjAQh1nTiE=FN?^:RkI#U*Ofa@3J+#J\G\KWhE$DQD4aU?%V!"?g_D-ekTOrq
$u]A]AS[m,`Ke\^Rb"^Zi(?`QN(bbaB:9GRL#n^MHn#Jf1e[GL-4A*cR!DPhgGG3=[8cf+``OF
AVfi_WOniJAok)<.aWTFkHq-W6qSh5YD/HgJ`BsAr?3/SAbdjH$q5C2YFfL#$8"Dn?BCXi9/
n)RY<OAhR]ACsQlKaj<1b[DtM9CRYHFk@G<UQ0urhLadV)^kK/dY)EkXQ[1_u+`Eb*eZV?n,Y
f<X(rU'l]A]ARpK"kM!0411d/`%m6,lI]A'/\^H`p0H\Mlpc.S!46=>\V<T6bF!AT^`E8k.Ku*D
JZ0ogp``>#)Vi9?;./3>kYW`qZV7IU;mB0\9Mg\+PLfQFJLBO%#);JQ1cuoOiS34j3CT:/oe
7n!)Yp"'fcW-Hr4a/H]A'P)F5;iO?PWlhfTq@T_XC>?(2^M>lU/mVCs5j:s9VYV-Pl9r.25+U
-H[BV7N)1sb)'i?(__Ce-m2t*4ER_\CkC<GC1dlh1SCeqNm#P(2rSRQeG%d)Oc7%%:WJ"=%^
.DA?s4*tPC,L(5*lnd7JY,@lqaS^"u:@`_KUNnZip>hTdNo.2iZ692LbmE&f$d]Ab[i]ADsO4d
[ItfsX(`G=p]A4CKf!HG&jWh?ZML#Ri\/r0R^sJ[P+</X??^.eE'aSF]A3f1P)oa6A3"##5[J!
5CX#3#(mHYS)<iVjO&J3-XNIV)ln1sWlT):/%K5_N@6hZ#dGu\^`3QlGjd"TVL&qLU]Ak#aFJ
r.2"-]Ap$^`u^<D3!Um85X]A>l@$.Tl,qR>1%<Ok/a+uT*G4>2a5e:<&Z3s78d3LUF*M2N*+(Q
80C('aueab`C0LOC9JP(%*%5$`p!#44nBB99EVcTS9Y@7=GG5r2Wp<&-U,oqWbQ;O%+a]Ak)"
Lbf#NA4?EWT!(]AcM22i*(8Ycm?RHG$=@1%GdDfV.j,g2?NqGIl;QDLE'@)7-"6_F4N(3i.aU
dT&7Wd8_s**7c<</t#&[N9m"H_HE"u;F=bY3eW0baCih(4-VncVBA+-qKoK`5s.rWh-h,_I1
(4Q(.M:TOT':'[E)$G\*fO"YV_9VJ&`[K`kZJahr4N6o@g,09f3F%Z<'r=pZX>?T6/Aq[So7
kO12]Al_E9^>h&l"Tu??:4>]AD]A"F"4oE_2D^-b2kr.KN7(f%.0:W_T*@/%$pp+\ptP5@u_cRf
u>Rss9XrU'1uL[kCr<Vq%tX=7Q"8Nb;cOsD74oGZ.p%[!rb"g.>3W*:76-p#5J(njU]AhcHk%
>EY"(]AJ4Rm9\`Ki\K5=@`gjPpgpG9YT_bqkY3n@'`sL%qo'7kp4CL'OgEKB(qJAOIqfQkB8&
R^?AQG?Cc^[EmbSh%rn]A6"^a14`[,R*9KE7mj9k9KG(C['II''FH!:A(q_FW)eIZ2'?l\h"X
[Kh7T)DB6k-:3c5Fl-Pl"_`L#`L)oJV(LIDn\`k*Drq-]AEZXclD-rV`k8[j0iD@nVD@Z<$0I
(agPSVM:S6UU4C:YLt?<LcQ44)?(1if'6&.>:RU!n)!-I[dXu$oiHgT"hM?+KD'eoCBe.G*7
[@=L?A5P:jUZ&5jf);;cY-D[$,F_74HNnDgFY7'nG<'[fd+#GPOK6?"kc:VD;eFSSPInT.<8
T:0/!k9oVfrhT,Y.!?`/BKL_$H8+#MTLBUe!a)k%NENde2,0sql8S>Ha016n!`/<gNXX7hn+
opBZsV_7cbTP6P_W4c'n1-7d]ADbk&(_]A^<#if.9Fr<aO[`$d(e`a3oBP8E$Gj"@9e*i'&+O&
"A\>EZMoCP2cS;M1>JFHFPlr55OlHqmNA0&4V57nm)H?Di?>n^^;OhN4@B6uQ$BkoV&cbMbR
^:]A'W#A-SrRKfAOC5!TJ#k]AjBOKnhd$hFmhm)8"RX(E!Z+Bh`+`-WZDXkL\QWdYlgm;.C@L$
RS`V'\LnUIk@^fD"D2g&YN?gf3VliHQ.d+9@ESUrubU+<T-q?>M8%Z2c?@8pATB`D)5%r`YK
Y5X]AnUCl]A[oP[mQIt?PfR0O@UG5O9a^m"D14!S.qm-*eC[42m`U2P/Fr_r=]AhnP:]A=86be"4
O/?=nnU;pYn59irIL,*Xr$4=Uk2hEtT)IAV:o/^R=!^SfufdQ">j,e/c;AM>kMOHdW2]AJ!YY
=UbB1h-h<kCh>*++jmh+8Vi5[V@&K6=F`"qN5f8*?P(S7fqUA]A7]A$'fnHU.MRTp>//lO\.[/
J]AJ:s5M-$r6GT53;S-13e<mmq=.O>O?`cI_YJq"cbuoPEZi^]A^UjAPScr<3N;_aF#7qBJrQ=
Z!+o[*&e"`q<(2=+kiV8]A,DsZ5)$bU!LVde!H[$I-CLKF'f2?1F=4c:&'mIeGJb+_k,iRcX2
n?K/]AN,l=bn2IN6\-a4kRL]A@/VJ0Tf9(*a4O!b6]A:a4dq9uu4^TJQ_;/e:pOLd3c(qqO9.Ih
dm-H==s.C;qH%CTg8!19[Y0YUmC;_LW)4pSSgOn=n+.FE4qO:@Qg<o*)84?J#s2j+l>RK``.
-dn&uF6tKq2W.%P`D1PE8`d7bs9E(tg)1lGUkU./Z2f^>a[/%1hRo#Bcgap5;cg"0c*+4Jr`
g,XZQksN9!Q^.V66*M?nOe+)"pXeDR/[64I":Ap#JJ?5o5CM2h5%Za4H`MO&!_^_eTFIJ<qW
349Z5(Y>/mS^2\+/sZ)&pi50RUS:j5ap+5NQVnum_[BD>?C#:(&E17(XFbq8@07<sSAQe2/U
WVln1?IW7aAk8cfrCf1Hr-S<s?DFJJT.5T0_s7[(V`_>"QSD2,7q+Jt]AsUZuW%aSJf$*";jV
G1NOi?i_cbfi5038]An;l]A0`rY#M(]AjSqeL_f=&4%0I/:qIS@]A[iF61@XuaGqT:TQf%]AYI0a=
R#-lN2<1(kpJqqB=APT\)2s7po56/m\pYY$*VfVR-1URfn=u(HSG"j>,e]A=qb,m)h$Tr<tZH
\piFs!qaM5H=]A4Yo1n(oq/)sP+-lK-cqWeR5kEX)V1Ok74IN+bT_p*T:F^2F61e]A/h\[Fri,
%=VDq7JL!`)5l`r?+B1,=W=b<N#IC!!X&abcM/Vj=IHKuaICQ>;MrbQg[%U=C"8\@[qcW";T
K,0.)qqkEc-1]A2@M/\o^7p:FBV:W%t,!M4Qm5Z.WH_<B.RFAZqc'-AKQ9Cm8'(ebT)XBEh2r
OUJ*KggkE%f1Ha/RH2lSA&.S`"B"fD<5A;-*CrA^^G1E%/<D:-/EK*u,34/k')1R?TYSjdB2
!dQpMP6XNWbpQ?0p%b(2?c/d,$I`Bcn^X,-q63PG(@71fWcLcn)T<n)&q2#!-P,J?e$rmI5s
,9j:-117/)&aTYs&g.[2e,r^nH>t259]A(tF*ZfG,9m'EJ9BT"<q\KP.=[e*ekc,:0?\jF2fb
(ZkRYO2Qr!Kn2=Vdg3()TrdlOM0nP\30pAY3~
]]></IM>
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
<border style="1" color="-15388336" borderRadius="0" type="0" borderStyle="0"/>
<WidgetTitle>
<O>
<![CDATA[新建标题]]></O>
<FRFont name="宋体" style="0" size="72"/>
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
<![CDATA[288000,723900,1440000,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,1440000,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[288000,2743200,2743200,2743200,2743200,432000,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="2" cs="4" s="0">
<O t="RichText">
<RichText>
<RichChar styleIndex="1">
<text>
<![CDATA[累计完成 ]]></text>
</RichChar>
<RichChar styleIndex="2">
<text>
<![CDATA[1300]]></text>
</RichChar>
<RichChar styleIndex="1">
<text>
<![CDATA[ 亩]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="1" r="3" cs="4" rs="10">
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
<Plot class="com.fr.plugin.chart.gauge.VanChartGaugePlot">
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
<Attr enable="false" duration="4" followMouse="false" showMutiSeries="true" isCustom="false"/>
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
<Attr showLine="false" autoAdjust="false" position="5" isCustom="true"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="1" size="120" foreground="-16711681"/>
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
<gaugeValueLabel class="com.fr.plugin.chart.base.AttrLabelDetail">
<Attr showLine="false" autoAdjust="false" position="5" isCustom="true"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="80" foreground="-1"/>
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
</gaugeValueLabel>
</AttrLabel>
</Attr>
</AttrList>
</ConditionAttr>
</DefaultAttr>
</ConditionCollection>
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
<FillStyleName fillStyleName="仪表盘颜色"/>
<isCustomFillStyle isCustomFillStyle="false"/>
<ColorList>
<OColor colvalue="-16713985"/>
<OColor colvalue="-16713985"/>
<OColor colvalue="-16713985"/>
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
<VanChartGaugePlotAttr gaugeStyle="slot"/>
<GaugeDetailStyle>
<GaugeDetailStyleAttr horizontalLayout="true" needleColor="-1" slotBackgroundColor="-1118482" antiClockWise="true"/>
<MapHotAreaColor>
<MC_Attr minValue="0.0" maxValue="100.0" useType="0" areaNumber="5" mainColor="-14374913"/>
<ColorList>
<AreaColor>
<AC_Attr minValue="=80" maxValue="=100" color="-14374913"/>
</AreaColor>
<AreaColor>
<AC_Attr minValue="=60" maxValue="=80" color="-11486721"/>
</AreaColor>
<AreaColor>
<AC_Attr minValue="=40" maxValue="=60" color="-8598785"/>
</AreaColor>
<AreaColor>
<AC_Attr minValue="=20" maxValue="=40" color="-5776129"/>
</AreaColor>
<AreaColor>
<AC_Attr minValue="=0" maxValue="=20" color="-2888193"/>
</AreaColor>
</ColorList>
</MapHotAreaColor>
</GaugeDetailStyle>
<gaugeAxis>
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
<AxisPosition value="3"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="verdana" style="0" size="64" foreground="-10066330"/>
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
<VanChartValueAxisAttr isLog="false" valueStyle="false" baseLog="=10"/>
<ds>
<RadarYAxisTableDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<attr/>
</RadarYAxisTableDefinition>
</ds>
<VanChartGaugeAxisAttr mainTickColor="-4539718" secTickColor="-1907998"/>
</gaugeAxis>
<VanChartRadius radiusType="auto" radius="100"/>
</Plot>
<ChartDefinition>
<MeterReportDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<MeterDefinition201109 meterType="0"/>
<meterDefinitionName>
<O>
<![CDATA[完成率]]></O>
</meterDefinitionName>
<meterDefinitionValue>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=B15]]></Attributes>
</O>
</meterDefinitionValue>
</MeterReportDefinition>
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
<C c="6" r="3" cs="8" rs="10">
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
<Attr class="com.fr.chart.base.AttrAlpha">
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
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
<FRFont name="verdana" style="0" size="88" foreground="-10066330"/>
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
<FRFont name="verdana" style="0" size="88" foreground="-10066330"/>
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
<FRFont name="verdana" style="0" size="88" foreground="-10066330"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="true"/>
<AxisLineStyle AxisStyle="0" MainGridStyle="1"/>
<newLineColor mainGridColor="-3881788" lineColor="-5197648"/>
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
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="1" r="13" cs="4" s="0">
<O t="RichText">
<RichText>
<RichChar styleIndex="1">
<text>
<![CDATA[目标 ]]></text>
</RichChar>
<RichChar styleIndex="2">
<text>
<![CDATA[2000]]></text>
</RichChar>
<RichChar styleIndex="1">
<text>
<![CDATA[ 亩]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="1" r="14">
<O t="DSColumn">
<Attributes dsName="ds1" columnName="LV"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
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
<FRFont name="微软雅黑" style="0" size="104" foreground="-16711681"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</body>
</InnerWidget>
<BoundsAttr x="10" y="35" width="530" height="200"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="label0"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="数据截止日期："+sql("oracle_test", "select max(deadline) from DM_MCL_DISBURSEMENTMONEY ", 1)+" / 单位：亩/万平"]]></Attributes>
</O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="0" autoline="true"/>
<FRFont name="微软雅黑" style="0" size="72" foreground="-1"/>
<border style="0" color="-723724"/>
</InnerWidget>
<BoundsAttr x="684" y="5" width="170" height="21"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="label1"/>
<Widget widgetName="org"/>
<Widget widgetName="org_name"/>
<Widget widgetName="label0"/>
<Widget widgetName="report0"/>
<Widget widgetName="report3"/>
<Widget widgetName="report1"/>
<Widget widgetName="report5"/>
<Widget widgetName="report4"/>
<Widget widgetName="report7"/>
<Widget widgetName="report2"/>
<Widget widgetName="report6"/>
<Widget widgetName="tiaozhuan1"/>
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
<TemplateID TemplateID="685e19ce-b4a6-4ff3-9406-ec51de955f70"/>
<TemplateIdAttMark class="com.fr.base.iofileattr.TemplateIdAttrMark">
<TemplateIdAttMark TemplateId="577925b9-c2d2-4cc5-875a-00047ea9228c"/>
</TemplateIdAttMark>
</Form>
