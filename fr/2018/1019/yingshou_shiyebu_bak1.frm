<?xml version="1.0" encoding="UTF-8"?>
<Form xmlVersion="20170720" releaseVersion="9.0.0">
<TableDataMap>
<TableData name="org" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="fr_authority"/>
<O>
<![CDATA[测试角色,验证角色1,系统管理员,数据录入角色,权限认证角色]]></O>
</Parameter>
<Parameter>
<Attributes name="fr_username"/>
<O>
<![CDATA[hongxiaoyu]]></O>
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
select * from (
select ORG_ID,
       PARENTID as FATHER_ID,
       ORG_NAME,
       ORG_SHORTNAME as ORG_SNAME,
       ORG_NUM as ORDER_KEY,
       org_level,
       ORG_CODE
  from dim_org_jxjl where isshow=1 
   start with ORG_ID in(select orgid from du2)
connect by prior org_id =PARENTID)
where ORG_ID not in ('E0A3D386-D5C8-FB22-18DE-4424D49363B1')
 --or FATHER_ID in (select orgid from du2)
 )
 
SELECT 
    ORG_ID,
   null FATHER_ID,
    ORG_NAME,
    ORG_SNAME,
    ORDER_KEY,
    org_level,
    ORG_CODE
FROM ORG_JG where ORG_ID in(select ORG_ID from dim_org_jxjl where org_level=(select min(org_level) from  ORG_JG ) )
UNION ALL
SELECT * FROM ORG_JG where ORG_ID not in(select ORG_ID from dim_org_jxjl where org_level=(select min(org_level) from  ORG_JG ))
order by order_key

]]></Query>
</TableData>
<TableData name="zhuxing_data" class="com.fr.data.impl.DBTableData">
<Parameters>
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
<![CDATA[WITH date1 as(
select data_date date1 from dm_mcl_acct where rownum = 1
),
DIM_DATEKJ AS (
SELECT 
		CASE WHEN '1'='${dim_cal}' THEN PERIOD_YEAR
				 WHEN '2'='${dim_cal}' THEN PERIOD_QUARTER
				 WHEN '3'='${dim_cal}' THEN PERIOD_MONTH END AS CALIBER ,--找到我当前时间参数口径（当年、当季、当月）
		'1' as ORDER_CALIBER
		FROM DIM_PERIOD, date1 --时间维度
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
FROM DIM_DATEKJ, DATE1
UNION ALL*/
SELECT 
		b.DIM_CALIBER_S as CALIBER,
		CASE WHEN '1'='${dim_cal}' THEN substr(date1.date1,1,4) ||'Q0'||substr(b.DIM_CALIBER_S,1,1) 
				 WHEN '2'='${dim_cal}' THEN substr(date1.date1,1,4) ||'M'||substr(b.DIM_CALIBER_S,1,2) 
				 WHEN '3'='${dim_cal}' THEN substr(date1.date1,1,4) ||'M'||substr(date1.date1,5,2)||'W'||substr(b.DIM_CALIBER_S,2,1) 
		END as Statistical_time , 
		CASE WHEN '1'='${dim_cal}' THEN substr(date1.date1,1,4) ||'Q0'||substr(b.DIM_CALIBER_S,1,1) 
				 WHEN '2'='${dim_cal}' THEN substr(date1.date1,1,4) ||'M'||substr(b.DIM_CALIBER_S,1,2) 
				 WHEN '3'='${dim_cal}' THEN substr(date1.date1,1,4) ||'M'||substr(date1.date1,5,2)||'W'||substr(b.DIM_CALIBER_S,2,1) 
		END as ORDER_CALIBER
FROM DIM_DATEKJ a
LEFT JOIN DIM_DATEMX b
ON a.CALIBER=b.DIM_CALIBER
LEFT JOIN DATE1
ON 1=1
), --整理时间维度

DATE_INDEX AS (
SELECT INDEX_ID,INDEX_NAME,ORDER_KEY FROM DIM_INDEX 
WHERE INDEX_id='873057e6175c4edab8616fc2b900b452'
),--指标维度

DIM_ORF_HX AS(
SELECT ORG_ID,ORG_NAME FROM DIM_ORG 
where ORG_id = 'E0A3D386-D5C8-FB22-18DE-4424D49363B2'
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
<TableData name="areafenbu" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="org"/>
<O>
<![CDATA[4AF3F73F-D2B4-4082-A111-647A6832C779]]></O>
</Parameter>
<Parameter>
<Attributes name="periodtype"/>
<O>
<![CDATA[当季]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[oracle_test]]></DatabaseName>
</Connection>
<Query>
<![CDATA[with data as (
select 
'当年' as periodtype,
father_id,
orgname, 
orgid,
order_key, 
org_type,
org_level,
round((nvl(actual_value,0))/10000,0) actual_value
from dm_mcl_ar_new 
where data_date=(select  max(DATA_DATE) from dm_mcl_ar_new)
and orgid is not null
and father_id='${org}'
--and org_level='3'
order by order_key
)
select 
*
from data where periodtype='${periodtype}' order by order_key
---4AF3F73F-D2B4-4082-A111-647A6832C779
--E0A3D386-D5C8-FB22-18DE-4424D49363B1]]></Query>
</TableData>
<TableData name="accounts" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="org"/>
<O>
<![CDATA[E0A3D386-D5C8-FB22-18DE-4424D49363B1]]></O>
</Parameter>
<Parameter>
<Attributes name="yearmonth"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=sql("oracle_test", "select  max(DATA_DATE) from dm_mcl_ar_new ", 1)]]></Attributes>
</O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[oracle_test]]></DatabaseName>
</Connection>
<Query>
<![CDATA[with qy_sj as (
select  
father_id,
case when orgid='E0A3D386-D5C8-FB22-18DE-4424D49363B2' then '华夏幸福'
else orgname end as orgname, 
case when orgid='E0A3D386-D5C8-FB22-18DE-4424D49363B2' then 'E0A3D386-D5C8-FB22-18DE-4424D49363B1' else orgid end as orgid,
--orgname, 
--orgid,
case when orgid='E0A3D386-D5C8-FB22-18DE-4424D49363B2' then 1
else order_key end as order_key, 
org_type,
(nvl(target_value,0))/10000 target_value,
(nvl(actual_value,0))/10000 actual_value,
(nvl(difference_value,0))/10000 difference_value,
(nvl(by_actual_value,0))/10000 by_actual_value,
(nvl(increase_actual_value,0))/10000 increase_actual_value,
(nvl(capital_actual_value,0))/10000 capital_actual_value,
(nvl(land_actual_value,0))/10000 land_actual_value,
(nvl(tax_actual_value,0))/10000  tax_actual_value,
data_date,
org_level
from dm_mcl_ar_new   
 where 
data_date='${yearmonth}'
 and orgid is not null

)
select * from(
select * from qy_sj 
where orgid='${org}'  
or father_id='${org}'
   order by order_key)
   where orgid not in('E0A3D386-D5C8-FB22-18DE-4424D49363B1')
   --4AF3F73F-D2B4-4082-A111-647A6832C779]]></Query>
</TableData>
<TableData name="yibiao_data" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="org"/>
<O>
<![CDATA[E0A3D386-D5C8-FB22-18DE-4424D49363B1]]></O>
</Parameter>
<Parameter>
<Attributes name="yearmonth"/>
<O>
<![CDATA[20180731]]></O>
</Parameter>
<Parameter>
<Attributes name="periodtype"/>
<O>
<![CDATA[当季]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[oracle_test]]></DatabaseName>
</Connection>
<Query>
<![CDATA[with qy_sj as (
select 
'当年' as periodtype, 
father_id,
case when orgid='E0A3D386-D5C8-FB22-18DE-4424D49363B2' then '华夏幸福'
else orgname end as orgname, 
case when orgid='E0A3D386-D5C8-FB22-18DE-4424D49363B2' then 'E0A3D386-D5C8-FB22-18DE-4424D49363B1' else orgid end as orgid,
order_key, 
org_type,
round((nvl(target_value,0))/10000,0) target_value,
round((nvl(actual_value,0))/10000,0) actual_value,
data_date,
org_level
from dm_mcl_ar_new   
 where 
data_date='${yearmonth}'
 and orgid is not null
)
select 
periodtype,
orgname,
target_value,
actual_value,
case when target_value=0 then 0 else round(actual_value/target_value,2) end as wcl,
order_key  
from qy_sj where orgid='${org}' and periodtype='${periodtype}'
--4AF3F73F-D2B4-4082-A111-647A6832C779]]></Query>
</TableData>
<TableData name="money_rate" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="yearmonth"/>
<O>
<![CDATA[20180731]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[oracle_test]]></DatabaseName>
</Connection>
<Query>
<![CDATA[select round((nvl(actual_value,0)/10000),2) as actual_value_xin from dm_mcl_ar_new where orgid='E0A3D386-D5C8-FB22-18DE-4424D49363B2' and data_date='${yearmonth}'
]]></Query>
</TableData>
<TableData name="ds1" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="org"/>
<O>
<![CDATA[4AF3F73F-D2B4-4082-A111-647A6832C779]]></O>
</Parameter>
<Parameter>
<Attributes name="periodtype"/>
<O>
<![CDATA[当年]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[oracle_test]]></DatabaseName>
</Connection>
<Query>
<![CDATA[with base as---时间维度 当年展示4个季度  当季展示当季三个月
 (select p.period_key,
         p.period_year,
         p.period_quarter,
         p.period_month,
         p.week_nbr_in_month
    from dim_period p
   where p.period_key =  (select a.data_date
                                 from dm_mcl_ar_new  a
                                where 1 = 1
                                  and a.data_date is not null                                  and rownum = 1)
  ),---应收账款中最新的时间20180531  2季度 05月
data_time as
 (select *
    from ( select distinct '当年' period_type,
                          p.period_quarter period_name,
                          substr(base.period_year, 1, 4) || 
                          substr(p.period_quarter, 1, 1) period_type_id,
                          '1' rn
            from dim_period p, base
           where 1 = 1
             and p.period_year = base.period_year
          
          union all
          select distinct '当季' period_type,
                          --p.period_month period_name,
                          to_number(substr(p.period_month, 1, 2))||'月' period_name,
                          substr(base.period_year, 1, 4) || 
                          substr(p.period_month, 1, 2) period_type_id,
                          '2' rn
            from dim_period p, base
           where 1 = 1
             and p.period_year = base.period_year
             and p.period_quarter = base.period_quarter
             
         )
             
   where 1 = 1
     and period_type = '${periodtype}'),
yibiao_sj as (     
select 
father_id,
case when orgid='E0A3D386-D5C8-FB22-18DE-4424D49363B2' then '华夏幸福'
else orgname end as orgname, 
case when orgid='E0A3D386-D5C8-FB22-18DE-4424D49363B2' then 'E0A3D386-D5C8-FB22-18DE-4424D49363B1' else orgid end as orgid,
order_key, 
round((nvl(target_value,0))/10000,0) target_value,
round((nvl(actual_value,0))/10000,0) actual_value,
case when target_value=0 then 0 else round(actual_value/target_value,2) end as wcl,
org_level
from data_time m 
left join  dm_mcl_ar_new  mcl
on m.period_type_id=mcl.period_type_id     
     )
--select * from data_time
select 
orgname,
target_value,
actual_value,
wcl,
order_key  
from qy_sj where orgid='${org}' 
--4AF3F73F-D2B4-4082-A111-647A6832C779
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
<Attributes name="periodtype"/>
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
<![CDATA[with base as---时间维度 当年展示4个季度  当季展示当季三个月
 (select p.period_key,
         p.period_year,
         p.period_quarter,
         p.period_month,
         p.week_nbr_in_month
    from dim_period p
   where p.period_key =  (select a.data_date
                                 from dm_mcl_ar_new  a
                                where 1 = 1
                                  and a.data_date is not null                                  and rownum = 1)
  ),---应收账款中最新的时间20180531  2季度 05月
data_time as
 (select *
    from ( select distinct '当年' period_type,
                          p.period_quarter period_name,
                          substr(base.period_year, 1, 4) || 
                          substr(p.period_quarter, 1, 1) period_type_id,
                          '1' rn
            from dim_period p, base
           where 1 = 1
             and p.period_year = base.period_year
          
          union all
          select distinct '当季' period_type,
                          --p.period_month period_name,
                          to_number(substr(p.period_month, 1, 2))||'月' period_name,
                          substr(base.period_year, 1, 4) || 
                          substr(p.period_month, 1, 2) period_type_id,
                          '2' rn
            from dim_period p, base
           where 1 = 1
             and p.period_year = base.period_year
             and p.period_quarter = base.period_quarter
             
         )
             
   where 1 = 1
     and period_type = '${periodtype}'),
area_sj as (     
select 
father_id,
case when orgid='E0A3D386-D5C8-FB22-18DE-4424D49363B2' then '华夏幸福'
else orgname end as orgname, 
case when orgid='E0A3D386-D5C8-FB22-18DE-4424D49363B2' then 'E0A3D386-D5C8-FB22-18DE-4424D49363B1' else orgid end as orgid,
order_key, 
round((nvl(target_value,0))/10000,0) target_value,
round((nvl(actual_value,0))/10000,0) actual_value,
case when target_value=0 then 0 else round(actual_value/target_value,2) end as wcl,
org_level
from data_time m 
left join  dm_mcl_ar_new  mcl
on m.period_type_id=mcl.period_type_id     
     )
--select * from data_time
select 
orgname,
target_value,
actual_value,
wcl,
order_key  
from qy_sj where father_id='${org}' 
--4AF3F73F-D2B4-4082-A111-647A6832C779
]]></Query>
</TableData>
<TableData name="Tree1" class="com.fr.data.impl.RecursionTableData">
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
<TableData name="Tree2" class="com.fr.data.impl.RecursionTableData">
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
</TableDataMap>
<FormMobileAttr>
<FormMobileAttr refresh="false" isUseHTML="false" isMobileOnly="false" isAdaptivePropertyAutoMatch="false"/>
</FormMobileAttr>
<Parameters>
<Parameter>
<Attributes name="info"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="fr_username"/>
<O>
<![CDATA[hongxiaoyu]]></O>
</Parameter>
</Parameters>
<Layout class="com.fr.form.ui.container.WBorderLayout">
<Listener event="afterinit">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="tim"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=sql("oracle_test", "select to_char(to_date(max(data_date), 'YYYY-MM-DD'),'yyyy-mm-dd') from dm_mcl_ar_new ", 1)]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[setTimeout(
 function() {
$('.fr-trigger-btn-up').css('background', '#2cc5d8')//.fr-trigger-btn-up 
var str = '<div id="modeDiv" style="width: 300px;height: 100px;position: absolute;right: 1.3%;top: 1.5%;z-index:999;text-align:right;"><span style="font-size: 10px;font-family: 微软雅黑;font-weight:normal;color: #ffffff;margin-top: 0px;">(单位：亿元)</span>&nbsp;<span style="font-size: 12px;font-family: 微软雅黑;font-weight:normal;color: #ffffff;">数据截止日期：'+tim+'</span></div>';
		
		//做出判断，如果没有，就添加元素，如果有就直接赋值给iframe src地址
		var v_modeDiv = document.getElementById('modeDiv');
				$('body').append($(str));
 },0);

 
]]></Content>
</JavaScript>
</Listener>
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
<NorthAttr size="31"/>
<North class="com.fr.form.ui.container.WParameterLayout">
<Listener event="afterinit">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[//去除参数面板滚动条，三角形下拉
var timer1 = setTimeout(function(){
	$('.parameter-container-collapseimg-up').hide();
	$('.hScrollPane_draghandle').css('display','none')
		clearInterval(timer1);
},100)
]]></Content>
</JavaScript>
</Listener>
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
<Background name="ColorBackground" color="-16378570"/>
<LCAttr vgap="0" hgap="0" compInterval="0"/>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TreeComboBoxEditor">
<Listener event="beforeedit">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[$(".fr-combo-list-item-noselect",this.$view).remove();
this.$view.css("height","auto");]]></Content>
</JavaScript>
</Listener>
<WidgetName name="org"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<TreeAttr selectLeafOnly="false"/>
<isLayerBuild isLayerBuild="false"/>
<isAutoBuild autoBuild="false"/>
<isPerformanceFirst performanceFirst="false"/>
<Dictionary class="com.fr.data.impl.TableDataDictionary">
<FormulaDictAttr kiName="ORG_ID" viName="ORG_NAME"/>
<TableDataDictAttr>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[Tree2]]></Name>
</TableData>
</TableDataDictAttr>
</Dictionary>
<widgetValue>
<databinding>
<![CDATA[{Name:org,Key:ORG_ID}]]></databinding>
</widgetValue>
</InnerWidget>
<BoundsAttr x="51" y="9" width="130" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.parameter.FormSubmitButton">
<Listener event="afterinit">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[//自定义背景时，设置按钮圆角
var timer1 = setTimeout(function(){
	$('.fr-widget-click').css('border-Radius','5px');
	$('.ui-state-enabled.fr-form-imgboard').css('border-Radius','5px');
		clearInterval(timer1);
},100)]]></Content>
</JavaScript>
</Listener>
<WidgetName name="formSubmit1"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Text>
<![CDATA[查询]]></Text>
<Hotkeys>
<![CDATA[enter]]></Hotkeys>
<initial>
<Background name="ColorBackground" color="-13842984"/>
</initial>
<over>
<Background name="ColorBackground" color="-15626337"/>
</over>
<click>
<Background name="ColorBackground" color="-13842984"/>
</click>
<FRFont name="微软雅黑" style="1" size="72" foreground="-1"/>
<isCustomType isCustomType="true"/>
</InnerWidget>
<BoundsAttr x="480" y="10" width="62" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ComboBox">
<Listener event="beforeedit">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[//去掉复选框的不选
$(".fr-combo-list-item-noselect",this.$view).remove();
this.$view.css("height","auto");]]></Content>
</JavaScript>
</Listener>
<WidgetName name="periodtype"/>
<LabelName name="时间维度:"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Dictionary class="com.fr.data.impl.CustomDictionary">
<CustomDictAttr>
<Dict key="当年" value="当年"/>
<Dict key="当季" value="当季"/>
</CustomDictAttr>
</Dictionary>
<widgetValue>
<O>
<![CDATA[当年]]></O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="299" y="10" width="130" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="label0"/>
<LabelName name="组织:"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O>
<![CDATA[时间维度:]]></O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="0" autoline="true"/>
<FRFont name="微软雅黑" style="1" size="72" foreground="-1"/>
<border style="0" color="-723724"/>
</InnerWidget>
<BoundsAttr x="229" y="10" width="70" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="组织"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O>
<![CDATA[组织:]]></O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="0" autoline="true"/>
<FRFont name="微软雅黑" style="1" size="72" foreground="-1"/>
<border style="0" color="-723724"/>
</InnerWidget>
<BoundsAttr x="2" y="10" width="50" height="21"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="org"/>
<Widget widgetName="periodtype"/>
<Widget widgetName="formSubmit1"/>
</MobileWidgetList>
<Display display="true"/>
<DelayDisplayContent delay="false"/>
<UseParamsTemplate use="false"/>
<Position position="0"/>
<Design_Width design_width="960"/>
<NameTagModified>
<TagModified tag="comboBox0" modified="true"/>
<TagModified tag="comboCheckBox0" modified="true"/>
</NameTagModified>
<WidgetNameTagMap>
<NameTag name="periodtype" tag="时间维度:"/>
</WidgetNameTagMap>
</North>
<Center class="com.fr.form.ui.container.WFitLayout">
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
<![CDATA[经营管控-全口径]]></O>
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
<![CDATA[应收账款（产新）分析页面 ]]></O>
</ColumnConfig>
<ColumnConfig name="CANSHUMING" isKey="false" skipUnmodified="false">
<O>
<![CDATA[org;periodtype;]]></O>
</ColumnConfig>
<ColumnConfig name="CANSHU" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[= if(len($org)=0,"",$org_name)+";"
 +if(len($periodtype)=0,"",$periodtype)+";"]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="CANSHUMINGYUCANSHU" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[= if(len($org)=0,"","org:"+$org_name)+";"
 +if(len($periodtype)=0,"","periodtype:"+$periodtype)+";"]]></Attributes>
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
<![CDATA[info]]></O>
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
<O>
<![CDATA[]]></O>
</ColumnConfig>
<ColumnConfig name="IPS" isKey="false" skipUnmodified="false">
<O>
<![CDATA[]]></O>
</ColumnConfig>
<Condition class="com.fr.data.condition.ListCondition"/>
</DMLConfig>
</JavaScript>
</Listener>
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
<![CDATA[=$fr_username]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="SYS_NAME" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=value("loguser",4,1)]]></Attributes>
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
<![CDATA[应收账款（产新）分析页面]]></O>
</ColumnConfig>
<ColumnConfig name="CANSHUMING" isKey="false" skipUnmodified="false">
<O>
<![CDATA[org;periodtype;]]></O>
</ColumnConfig>
<ColumnConfig name="CANSHU" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[= if(len($org)=0,"",$org_name)+";"
 +if(len($periodtype)=0,"",$periodtype)+";"]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="CANSHUMINGYUCANSHU" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[= if(len($org)=0,"","org:"+$org_name)+";"
 +if(len($periodtype)=0,"","periodtype:"+$periodtype)+";"]]></Attributes>
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
<O>
<![CDATA[info]]></O>
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
<![CDATA[=if(len($info)=0,"", $info+"")]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="DATA_DATE" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=TODAY()]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="IPS" isKey="false" skipUnmodified="false">
<O>
<![CDATA[]]></O>
</ColumnConfig>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[if( $info = $info99  , 1<0 , 0<1 )]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[if( $periodtype = $periodtype99  , 1<0 , 0<1 )]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[if( $org = $org99  , 1<0 , 0<1 )]]></Formula>
</Condition>
</JoinCondition>
</Condition>
</DMLConfig>
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
<WidgetName name="report7_c_c"/>
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
<WidgetName name="report7_c_c"/>
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
<![CDATA[14630400,720000,190500,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O>
<![CDATA[应收账款(产新)目标完成情况]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="0">
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="2" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="0">
<O>
<![CDATA[ ]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="1">
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
<C c="0" r="2" s="1">
<O>
<![CDATA[股份公司签约：产业新城签约+住宅签约+安置房签约+物业签约+小镇签约\\n]]></O>
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
<C c="0" r="3" s="1">
<O>
<![CDATA[新城全口径签约：产业新城签约+住宅签约+安置房签约+其他业务签约（物业不含交叉业务）+国际\\n]]></O>
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
<C c="0" r="4" s="1">
<O>
<![CDATA[新城签约：平台+商业+酒教+TOD\\n]]></O>
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
<C c="0" r="5" s="1">
<O>
<![CDATA[住宅签约：孔雀城签约+新合作签约\\n]]></O>
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
<C c="0" r="6" s="1">
<O>
<![CDATA[小镇签约：小镇集团签约\\n]]></O>
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
<C c="0" r="7" s="1">
<O>
<![CDATA[其他签约：物业运营签约\\n]]></O>
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
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
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
<BoundsAttr x="14" y="3" width="396" height="30"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report0_c"/>
<WidgetAttr invisible="true" description="">
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
<WidgetName name="report0_c"/>
<WidgetAttr invisible="true" description="">
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
<![CDATA[266700,685800,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[3352800,10477500,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1">
<O t="RichText">
<RichText>
<RichChar styleIndex="0">
<text>
<![CDATA[目标]]></text>
</RichChar>
<RichChar styleIndex="1">
<text>
<![CDATA[${=B3}]]></text>
</RichChar>
<RichChar styleIndex="0">
<text>
<![CDATA[亿]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="1" r="2">
<O t="DSColumn">
<Attributes dsName="yibiao_data" columnName="TARGET_VALUE"/>
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
</CellElementList>
<ReportAttrSet>
<ReportSettings headerHeight="0" footerHeight="0">
<PaperSetting/>
</ReportSettings>
</ReportAttrSet>
</FormElementCase>
<StyleList>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="120" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="120" foreground="-16711681"/>
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
<![CDATA[723900,1066800,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,13373100,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1">
<O t="RichText">
<RichText>
<RichChar styleIndex="0">
<text>
<![CDATA[目标]]></text>
</RichChar>
<RichChar styleIndex="1">
<text>
<![CDATA[${=B4}]]></text>
</RichChar>
<RichChar styleIndex="0">
<text>
<![CDATA[亿]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="1" r="3">
<O t="DSColumn">
<Attributes dsName="yibiao_data" columnName="TARGET_VALUE"/>
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
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="120" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="120" foreground="-16711681"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</body>
</InnerWidget>
<BoundsAttr x="14" y="198" width="315" height="28"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report1_c_c_c"/>
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
<WidgetName name="report1_c_c_c"/>
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
<![CDATA[1104900,723900,685800,762000,381000,952500,952500,723900,723900,723900,723900,723900,723900,723900,723900,723900,533400,38100,647700,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[76200,864000,864000,1219200,1181100,1104900,1371600,1181100,1104900,1371600,432000,2160000,2160000,2160000,2160000,432000,2705100,990600,3048000,2743200,2743200,6210300,2743200,1257300,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="18" r="0" cs="3" s="0">
<O>
<![CDATA[应收账款（产新）区域分布]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[sql("oracle_test", " select org_level from dim_org_jxjl where org_id='" + $org + "' ", 1) = 3]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="21" r="0">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[sql("oracle_test", " select org_level from dim_org_jxjl where org_id='" + $org + "' ", 1) = 3]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="22" r="0">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[sql("oracle_test", " select org_level from dim_org_jxjl where org_id='" + $org + "' ", 1) = 3]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="1">
<PrivilegeControl/>
<Expand/>
</C>
<C c="18" r="1">
<PrivilegeControl/>
<Expand/>
</C>
<C c="19" r="1">
<PrivilegeControl/>
<Expand/>
</C>
<C c="20" r="1">
<PrivilegeControl/>
<Expand/>
</C>
<C c="21" r="1">
<PrivilegeControl/>
<Expand/>
</C>
<C c="22" r="1">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="2" s="1">
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
<C c="2" r="2" s="1">
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="3" r="2">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(len(B18) = 0, 0, C18 / B18)]]></Attributes>
</O>
<PrivilegeControl/>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=$$$]]></Content>
</Present>
<Expand/>
</C>
<C c="18" r="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="19" r="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="20" r="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="21" r="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="22" r="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="3" cs="9" s="2">
<O t="RichText">
<RichText>
<RichChar styleIndex="3">
<text>
<![CDATA[ ]]></text>
</RichChar>
<RichChar styleIndex="4">
<text>
<![CDATA[ 当前实际]]></text>
</RichChar>
<RichChar styleIndex="5">
<text>
<![CDATA[${=C18}]]></text>
</RichChar>
<RichChar styleIndex="3">
<text>
<![CDATA[ ]]></text>
</RichChar>
<RichChar styleIndex="4">
<text>
<![CDATA[亿]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="15" r="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="18" r="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="19" r="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="20" r="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="21" r="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="22" r="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="23" r="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="5">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="5">
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
<newColor/>
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
<Attr showLine="false" autoAdjust="false" position="3" isCustom="true"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="Verdana" style="0" size="80" foreground="-197380"/>
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
<FRFont name="微软雅黑" style="0" size="56" foreground="-16711681"/>
</Attr>
</TextAttr>
<AttrToolTipContent>
<Attr isCommon="false"/>
<value class="com.fr.plugin.chart.base.format.AttrTooltipValueFormat">
<AttrTooltipValueFormat>
<Attr enable="true"/>
</AttrTooltipValueFormat>
</value>
<percent class="com.fr.plugin.chart.base.format.AttrTooltipPercentFormat">
<AttrTooltipPercentFormat>
<Attr enable="false"/>
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
<HtmlLabel customText="function(){ return FR.contentFormat(this.value,&apos;#.##%&apos;);}" useHtml="true" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
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
<AFStyle colorStyle="0"/>
<FillStyleName fillStyleName=""/>
<isCustomFillStyle isCustomFillStyle="false"/>
</AttrFillStyle>
</newPlotFillStyle>
<VanChartPlotAttr isAxisRotation="false" categoryNum="1"/>
<VanChartGaugePlotAttr gaugeStyle="pointer_semi"/>
<GaugeDetailStyle>
<GaugeDetailStyleAttr horizontalLayout="true" needleColor="-16713985" paneBackgroundColor="-15587500" antiClockWise="true"/>
<MapHotAreaColor>
<MC_Attr minValue="0.0" maxValue="100.0" useType="1" areaNumber="3" mainColor="-14374913"/>
<ColorList>
<AreaColor>
<AC_Attr minValue="=1.2" maxValue="=1" color="-391931"/>
</AreaColor>
<AreaColor>
<AC_Attr minValue="=1" maxValue="=0.8" color="-13312"/>
</AreaColor>
<AreaColor>
<AC_Attr minValue="=0.8" maxValue="=0" color="-16713985"/>
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
<FRFont name="微软雅黑" style="0" size="48" foreground="-197380"/>
</Attr>
</TextAttr>
<AxisLabelCount value="=1"/>
<AxisRange maxValue="=1.2"/>
<AxisUnit201106 isCustomMainUnit="false" isCustomSecUnit="false" mainUnit="=max(yibiao_data.select(mcl)) * 100" secUnit="=0"/>
<ZoomAxisAttr isZoom="false"/>
<axisReversed axisReversed="false"/>
<VanChartAxisAttr mainTickLine="2" secTickLine="0" axisName="X轴" titleUseHtml="false" autoLabelGap="true" limitSize="false" maxHeight="15.0" commonValueFormat="false" isRotation="false"/>
<HtmlLabel customText="function(){ return this*100+&apos;%&apos;; }" useHtml="true" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
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
<MoreNameCDDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[yibiao_data]]></Name>
</TableData>
<CategoryName value="ORGNAME"/>
<ChartSummaryColumn name="WCL" function="com.fr.data.util.function.NoneFunction" customName="WCL"/>
</MoreNameCDDefinition>
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
<C c="2" r="5">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="5">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="5">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="5">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="5">
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="5">
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="5">
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="5">
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="5" cs="4" rs="11">
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
<AxisRange maxValue="=IF(or(max(ZBPF_KJ.GROUP(ACTUAL_VALUE), ZBPF_KJ.GROUP(target_VALUE)) = 0, len(max(ZBPF_KJ.GROUP(ACTUAL_VALUE), ZBPF_KJ.GROUP(target_VALUE))) = 0), 0, max(ZBPF_KJ.GROUP(ACTUAL_VALUE), ZBPF_KJ.GROUP(target_VALUE)) * 1.3)"/>
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
<AxisRange minValue="=0" maxValue="=if(or(max(ZBPF_KJ.GROUP(VALUE_LV)) = 0, len(max(ZBPF_KJ.GROUP(VALUE_LV))) = 0), 1, max(ZBPF_KJ.GROUP(VALUE_LV)) * 1.2)"/>
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
<![CDATA[#0个]]></Format>
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
<![CDATA[#0个]]></Format>
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
<AxisRange maxValue="=IF(or(max(ZBPF_KJ.GROUP(ACTUAL_VALUE), ZBPF_KJ.GROUP(target_VALUE)) = 0, len(max(ZBPF_KJ.GROUP(ACTUAL_VALUE), ZBPF_KJ.GROUP(target_VALUE))) = 0), 0, max(ZBPF_KJ.GROUP(ACTUAL_VALUE), ZBPF_KJ.GROUP(target_VALUE)) * 1.3)"/>
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
<AxisRange minValue="=0" maxValue="=if(or(max(ZBPF_KJ.GROUP(VALUE_LV)) = 0, len(max(ZBPF_KJ.GROUP(VALUE_LV))) = 0), 1, max(ZBPF_KJ.GROUP(VALUE_LV)) * 1.2)"/>
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
<Attr lineWidth="2" lineStyle="2" nullValueBreak="true"/>
</VanAttrLine>
</Attr>
<Attr class="com.fr.plugin.chart.base.VanChartAttrMarker">
<VanAttrMarker>
<Attr isCommon="true" markerType="RoundFilledMarker" radius="4.5" width="30.0" height="30.0"/>
<Background name="NullBackground"/>
</VanAttrMarker>
</Attr>
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
<AxisRange maxValue="=IF(or(max(ZBPF_KJ.GROUP(ACTUAL_VALUE), ZBPF_KJ.GROUP(target_VALUE)) = 0, len(max(ZBPF_KJ.GROUP(ACTUAL_VALUE), ZBPF_KJ.GROUP(target_VALUE))) = 0), 0, max(ZBPF_KJ.GROUP(ACTUAL_VALUE), ZBPF_KJ.GROUP(target_VALUE)) * 1.3)"/>
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
<AxisRange minValue="=0" maxValue="=if(or(max(ZBPF_KJ.GROUP(VALUE_LV)) = 0, len(max(ZBPF_KJ.GROUP(VALUE_LV))) = 0), 1, max(ZBPF_KJ.GROUP(VALUE_LV)) * 1.2)"/>
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
<![CDATA[sign_com]]></Name>
</TableData>
<ChartSummaryColumn name="TARGET_VALUE" function="com.fr.data.util.function.NoneFunction" customName="目标"/>
<ChartSummaryColumn name="ACTUAL_VALUE" function="com.fr.data.util.function.NoneFunction" customName="实际"/>
</MoreNameCDDefinition>
</DefinitionMap>
<DefinitionMap key="line">
<MoreNameCDDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
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
<C c="18" r="5" cs="5" rs="11">
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
<Attr isNullValueBreak="true" autoRefreshPerSecond="6" seriesDragEnable="false" plotStyle="0" combinedSize="50.0"/>
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
<Attr class="com.fr.plugin.chart.base.AttrTooltip">
<AttrTooltip>
<Attr enable="false" duration="4" followMouse="false" showMutiSeries="false" isCustom="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="宋体" style="0" size="72"/>
</Attr>
</TextAttr>
<AttrToolTipContent>
<Attr isCommon="false"/>
<value class="com.fr.plugin.chart.base.format.AttrTooltipValueFormat">
<AttrTooltipValueFormat>
<Attr enable="true"/>
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
<HtmlLabel customText="" useHtml="true" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
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
<Attr showLine="true" autoAdjust="false" position="6" isCustom="true"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="72" foreground="-1"/>
</Attr>
</TextAttr>
<AttrToolTipContent>
<Attr isCommon="false"/>
<value class="com.fr.plugin.chart.base.format.AttrTooltipValueFormat">
<AttrTooltipValueFormat>
<Attr enable="true"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0]]></Format>
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
<HtmlLabel customText="function(){ return &apos;实际值:&apos;+this.value+&apos;&lt;br/&gt;占比:&apos;+FR.contentFormat(this.percentage, &apos;#%&apos;);}" useHtml="true" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
</AttrToolTipContent>
</labelDetail>
</AttrLabel>
</Attr>
</AttrList>
</ConditionAttr>
</DefaultAttr>
<ConditionAttrList>
<List index="0">
<ConditionAttr name="条件属性1">
<Condition class="com.fr.data.condition.ListCondition"/>
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
<FRFont name="微软雅黑" style="0" size="56" foreground="-1"/>
</Legend>
<Attr4VanChart floating="false" x="85.0" y="20.0" limitSize="false" maxHeight="15.0" isHighlight="true"/>
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
<OColor colvalue="-7449200"/>
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
<OneValueCDDefinition seriesName="ORGNAME" valueName="ACTUAL_VALUE" function="com.fr.data.util.function.NoneFunction">
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[areafenbu]]></Name>
</TableData>
<CategoryName value="无"/>
</OneValueCDDefinition>
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
<C c="1" r="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="7" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="8">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="8">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="8">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="8">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="8">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="8">
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="8">
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="8">
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="8">
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="8">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="9">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="9">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="9">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="9">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="9">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="9">
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="9">
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="9">
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="9">
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="9" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="10">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="10">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="10">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="10">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="10">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="10">
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="10">
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="10">
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="10">
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="10">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="11">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="11">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="11">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="11">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="11">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="11">
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="11">
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="11">
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="11">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="13">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="13">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="13">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="13">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="13">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="13">
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="13">
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="13">
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="13">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="14">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="14">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="14">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="14">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="14">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="14">
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="14">
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="14">
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="14">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="15">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="15">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="15">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="15">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="15">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="15">
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="15">
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="15">
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="15">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="16" cs="9" s="7">
<O t="RichText">
<RichText>
<RichChar styleIndex="4">
<text>
<![CDATA[目标]]></text>
</RichChar>
<RichChar styleIndex="5">
<text>
<![CDATA[${=B18}]]></text>
</RichChar>
<RichChar styleIndex="4">
<text>
<![CDATA[亿]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="18" r="16">
<PrivilegeControl/>
<Expand/>
</C>
<C c="19" r="16">
<PrivilegeControl/>
<Expand/>
</C>
<C c="20" r="16">
<PrivilegeControl/>
<Expand/>
</C>
<C c="21" r="16">
<PrivilegeControl/>
<Expand/>
</C>
<C c="22" r="16">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="17">
<O t="DSColumn">
<Attributes dsName="yibiao_data" columnName="TARGET_VALUE"/>
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
<C c="2" r="17">
<O t="DSColumn">
<Attributes dsName="yibiao_data" columnName="ACTUAL_VALUE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="18" r="17">
<PrivilegeControl/>
<Expand/>
</C>
<C c="19" r="17">
<PrivilegeControl/>
<Expand/>
</C>
<C c="20" r="17">
<PrivilegeControl/>
<Expand/>
</C>
<C c="21" r="17">
<PrivilegeControl/>
<Expand/>
</C>
<C c="22" r="17">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="18">
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
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="48"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" vertical_alignment="3" imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="120" foreground="-13312"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="120" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="120" foreground="-16711681"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="623" height="250"/>
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
<FRFont name="宋体" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
<IM>
<![CDATA[Cq=gQ>AsO+*i#[ig(^A`[4:n,D(.1h<E-(MC8NnoGAC9<fK1ukHW*A4<AB-YHNYKXN1]AimIt
$;Prr,*rf-C=V4O,t=3Tp']ANn8DZTCm<UWQ85a!<<,M$]AV(\!!!TN!$J3e,Ioho10h6j!476
%nPnV8GK+MIWAfIGq/qsg.buJdD[?^V@Amh]A[*QHKZ,gS3'"\&2@;:Co.NpP"D8t!PEXdc!8
"9G&m`9*DUTZ$![7q+f]A&Pi)0S'V2DYsDPF(0#+&bk05i-a6K1?I9qI"sM*`Ni^q14As[c0?
t]A/,K)9qWr:HhJTpM1@(cAg'I3H-VQ``s'-Ojd6X?;/S#o-P5(Xd>8sssIS$+VnWs4,F6=b\
MJ@0.d^T6E!;5HHZ9;onkVQk?7MC?8<)./jX8a)\97P\3T[+5q9CP4dre;j\mAWi.^Zm^Q39
!_!c%"WLnu8VR@h1nS.G?`F`GlTAO)N;O*RDHr-]AB-nXoG#,^?]Ac#=.D0Wi'':iNAEqdC)L;
C<7!Q%EnUIMD@+(ukM5U^)LKWIp2Hs@WUBWt3!Z':Z,%H/R@NE'/:O8.J).J2o+Ik.9jGISV
LRO&GC*e6omf:!'m[%o$Gdh^^Rs#+$PoSZO%Ij9c_0jrV_p7s,)Lb:ph)%PIL58WYjWO&O3e
b8rI9=9Ugbpu_Jq/VW!6VQ^jY_]A5&RYnH-bsWWr/Zr[M@NQs8Q?>%mVQ/nO$[),X_Y<\AWkb
o`QX:ndq+).X4c(rSL1kni?rIBq=!6Y,*$6MYQXMG_A@K0d'nT^jr6%%okqsP_;ae_kpKLr$
U9F[V^Zh[s=,B9$$R4Q"/"%@q!!l8OW9VF\_!-nc/%mV<"3-I"$fY@il"%6tr2kl2C)3Xm,(
)&4ibN$nEWHnPS\\'do[RpZEaqjpIn./tCB/=A&AaQui<<&htebh_cmrH,Lt8?(VX-CsiM'V
>iF*.u)K-YUHYT:VD==YPO<N*X9A)s&tt'6U8E(c*$qoaFLks?D7EsOc$@9s/HT^gQ*6%]A['
dSjW54I1n#WQ\QnP=;qB+ZoL8R.Z$U#bZA2/^fmVijF%?&f*F'/H;L8h+j+d"P(Zr/OIY>GR
r9miF4G4lq&!$QFX!Z#V>.D=1(OOrW=A.mRH0b>V@4S7PXF:)#]ABj\=[MbdA.MpI'Q`h4\Ea
IEe;X0K_I&ibOGS3mCs/Ab>ibnq$L%coQ'aoN4'[D9)Ebes$9(%K5NDq&&E0(]A(UIb6=F$Ie
Tm\ojC?*OCn_Y_i=X6!cRl"7<gA]AukV61E5P^`MIVS]A,LlEbcaS%<m-`-iQ:A/\q<eE9-gj'
FMK`+t3*EC3;`qFj[H-gC"<1C/lJ"C#WC9:eNlKCOUctQKLt?Qa`L]AiD%LV2o/u:#e/roQm%
198O#"Mqu+J*"B5l+C3-qMXQc&<hmFubs"K4Z\g]A@M5h14"4m@b<jh7Q1hV7jsm+Zl]AoXB9n
*]A0*%*8UIS0sF:SV0/\Y:K]AWMn$d)qRstnij(_4IH#E%dJM5f#%F"cH\Wl7Jh_(ET@<EiJ"H
FrA;&6S0OYIZt[f:ei1,DA$s47]APo@%8+4A+T5V<UO`eK['fIZ+sJ/*K)j.K+<*rh$9W`jsr
\s4FXd\\7Y%TGr\l9A:*-[LQcD9GmBQ-qX<??_<nTYuKF\#_4i8a2BLp<M;fWD;h&</!c^]Ad
eb(A>l+K>K4@JX9R>HS_PBZs>@!2Q?H7`WbT1MeSYT/J2(cT=ME[7!&UZq^mNZ+2i<^aFgP2
3hj?Z<=2pO.AXmcJh923^qSKtDSO^Uq@klR4E$a3W[n%ffX#,V-.W,B<m*l,"1BaR!O=4ah'
MUme9$#F!db&=kF^%I9?8%55G<FAk[&/lsT2#MaO1,eG[F+-N[B7TV0%ertK.VJ&:`r>a9dJ
M@`XLK6bclQ<"jAetW9bg$A)L-I!]A&blfAWg7L;gBjg)'jT+bEfGG7hiq>0LD[^^nEUbh)i!
"W>IR;P/S1ojU2NP10.i=c'p'mFmgh=OG.6Q;p"-'GN8:fU7Gl.Jc\liag#"/Ya^neCZs$bX
-Hf]A+ob;j9:(-/S?[4&%`T&0>?Gn3r^$VV<iTmG@?%q#]A>6E5n$g(@>%`-7Q,sDb%DCX^&o-
7!l-n/39Mm2$Ho8t7]ARKB^%]ApVRij#(2YlYAMfbpRKh1'+p<VV\"4b4o)a`sc_L4U)h^a+`u
afqsIjfJ_]AaJ]AtY\&0=PT)&93B06,b-VfnC2n$nZd[=st2RXlZ12XX8dRt.$0BToP9`16a)5
NOpa\Lf1Wm)pb(p$;!Q"c!Y^,a-"A:=`'H0(4\iaWBI.I/O<-tDs\d"dW$,(ds%A+pVmIU+1
uOLpQ-!onW14juMfGXeLgel[<DODS$_'sk@BH`1[K9@bIPFX$[3O-BP3@IcldM?-jYCGf/aB
%arSc1^?*E^b2\"Hmu+'WY`gWde7t+.&CjSFPuR?^M]A8M4UV**CE`qkEe?U>O\_gIs)"Pf)4
*2'=rS>mspn<<[;Or^+ba*Abo?]A;InlGJC,*D2g!%M]APBK(/72Nt4(A6XODgBSJVGc2\)_Wl
fAg\tZ/\e,nX="b,h-i.&&.M4jkZN[%Q[%f<Nu]AJHjrZ]AaQU_;`2038%_[2F7!>?CG($p(bk
;m^kG7%Q)*7nH;LJokrK%T3gT^n`DRVX$G$^^CQ,B^&p@NmYrBR2#/H3<J9uJ>=d3reEn^)j
NG_c+:<ni\9iPQ/R`"";^A--AE[D7:FC]A4kXBq;Nq]Ane2>>4EM7LGY:^Z?NZLH=B[Q'^kU*U
fX=2$9=GGilOq9.>\'_1$gLUnB1tU]A547&P^7hN9C6JlFH"tP2%J^$7L)4'\o=SP+Cg=<qjD
S>o#3sUdriIj"P]AYP!;iV!;/aZnX&o+=b21X"j9kJ#f+PumE3VX0KNi?jS+ADub=ChWS9A"M
NQP93B[grTKRS"sJ;+.aELgmGJ$.l3EB#A07Ygs7G7@Xl/?ok_re&egm2`0*Jjk)N?ae"/>V
4_;qTQ4O:UqgNorM$K>(VKrR7r[sA\4XpCX&\iD%2:B"db:VBaZ9Rf1bt("C(#(YKhRNS`BM
f761h1\l2<E(mOAu4\)d3c3f$`f[ip/(&ot<qY=\cCT537L_sk3eK!<S!`'9KOU"UD0"TL5A
tS?CqE5um&k`R'5+)jHlIJ:\"2,X3]A80^_(6QI]AI>1mk&u2-r;7.NkgHe*&q$o$JHc+hc,q/
R`/Ti(4*%opCDPY@kpTkIPK57e`TEegB1>9)bOL@I`crc:]AIKu_Se(;GoO=I"rK:O^BZRL!J
H0_5Oj4>`lBciTCld9har^(a+f[^F5Pf".>[P7MFaaq-Y_O?LajMO'>:#hG[/&1FoVs=o>I^
51$"J*QuX+bf6!l^ermosfV'gV'+]AmO]A>Vt8g/VF;l)pIr&M,@.D?q"p6cfQH:3V`Cc\PED'
Af)`WV?8tg8aA;]A&LL+Z+>Z$\HIE,7s*,4j"P_=8-*]AaZq><Y-.[<$AS]A>)`nVLc2d)h+NXr
m'ON-/0F$2$:\dj%CK=*sSa1YKSOh-2YYCFmS<Cn8'[%")tJpL%#7L>fR,Xs(X]AmYf#sc"#W
j>*41%-mWBHB+u&Rhom9s?%a_a1:b;biI11rck7h/==GOhmbMpU6)W\T-r?-FfCd$<urfjRW
I_R_Y3N2Okcir@704p]A0CStn.]A0cgh]AS/Ok=6rbMP9pm<ds$`G;*SZUc7?U=*MKD)hR()TPh
-IZj5Grid.`8u;R.nn__1Y71KF<b2blg?g&9Q#5DhQ$oTf@X2_K,YM*BN=iq<q9o`=@N]AD+k
L7)=JS$*6[`$>uIr(!'DK/:U6mOq;j>J3a2Y"TY%p!2^&P+]AYC0q;50rI1W3Xk5D_Q@G^q-7
)Iuga2`E"$go@eBUoEVINhEIm5n3q[Vt$]Ae3;;G5#m+H)YNR20Y'TUq:)<:`VQ>%!_0<eR.9
p21b_[IomIP^9UPY8Dnke$'A$hcaS(HI1RkC"?hXBZ8uYcKGfD7]A\t]A%5Nbu&@RkS`KC%ZXR
2biO]A%eL+NClD_8c;RuEF0X-f]Ap89FE,quVeV7WC2"1t`i@>l2%4aB@s+7:BZs%3qfQq]A"\X
Kg$5O,j7JB^Y5dSF!&F6@gH+-ft[$qZK7a87@6*`30q7L,Dn@4C@lC2HH_kk^Ah>SPhRD8sQ
[qE/uo6b;5C>8/!=+BWhnoDR!P%WOpL$e8DW4Z`uX;3S^j7]A1lKIT2?-c]A.78&m[RQ,d^%WE
U,#u3NBpYdHMELok-n&IsL:0[VpTq]AS=WuC8J]Ah(;4AE)^@ML')uD=@]AG.F4%Kh77$VkY"sp
66.d!j]AS!.s!'!i*_[=IZk8n@1>j*YBk"`\HBgd;TDQ_C=NUYV]Al8((2a2\*LT8p]A,B$j9Xg
DVZr;r24h':oOhI1dV/!V9spo1arR_iN">^@[_#CMbY(!=6M=GW/?o3SmYXl@f"!g\1jc0(B
nN$M4^4gTQBrb%Do/,<gE!bG7sW)ef)0cnauUhOF)"j(?O"m6G4.7?d;XHfi+bCHP9Z?E=YF
L.GUVAhjQ"J6SlO5&`#.^OY3qs28bp3"jBG1iMY8ZGF"Z3S]A$j&;.%%O2>d@1pe/.mbJLmEX
2GilcaK.I!2H+P-N\%H%EW;*\ll5IH'>?#ppjRNk([9a+)GKh/&+-0RdpBQ4I<K\_N>3gL\U
`pgQobMm46H<YL\?3IRV$@f(Y!AntJ<$\k0U#QNd<XaDshN^polaU\'Gpf]A:_T?N6V,4`3Cr
R^J@G#TWTRbsq6,I]A!f$'3*uTbM:NFkhbu??g-0/$c?sEeuFMZ)dP3T_OKWXU+%k&qh'A>PW
8)I=_j&XNZM&aS\,8Flg^jK*`L#i"d]AWs>N$4.+PAlNd.H==^6ko-#JGIhkcp+%'7Z8;LZpb
1.]AdBs(fi2G@G2YuF?YVmBt3Kr6IG[Q7":=A&)rEk%1lgUI7jY=B_*eX?=a3HHe^nqkH!O(e
,0%.AcfcZ[tYZps845Io+[X[3p+r_[h^kO:e((/#NRf6BY=R3AnW]Aff9#gh.a0\+!TG_N<A*
@tebP$6j3AO"fLd)3';3u-1dg&CDF39/PXQKaSGN?WHZ)XP:3nW9gWR8?>LDDFr6oeWlN!+,
V+9Ek.nVB]A("'iuC85!X0!nd,rfi(<SEu0<ii[NLZFr;;s7q9$'\mDe)0a`p`-EiYk#lR0nZ
G*VDrk!!*ZG%r2@67jM]A=KIqm?=H%%.>i7PRZk<7pqlQk!J(1p9p49fW)?:*(C6P"]A!NLIP7
3TBhn5CN;t+e,;VsGmGWVCU<@oZRZ49cE^2!Cp._@?WEchA<F6#oGA?ckaEORWd@i'T>C-0\
6^`OY)0=OLKXoCI-[5Q:IJZqn-9Zd2ec-?p+oXk9&jsQcj@I.n^DC.Zu$^2dI9)md]A5hMHc`
fBBii9(`fi7Jq%pk;/<Z5FrKX64h>4+?Fg&+>m<r@1_<Mm_$8h;L-sUOQ,bBA+Qe*L(5LlDp
'bBH[9>p);qamqOR?Y^'m%(@`H.EKG+XAMO7`VdYMX6=`:bUUqR6EIfjSo\(n=Hagh3Y``$V
h"mRB3iLCItVM$.n`cqCX@=>eAa\*<isZQMpH]A0e0"jT4V[pn#M1r.j!0EHR2`L>(HGOg^*k
GhT!::RrLV6S]AXk0J\S;;L>Y`V&<+\b_tT0<__%eX?i?5qY:I?*qRcM[?*Z&=<ieU$(j2XLK
?>@7dl)B2+EZCjf;EC`d5at#mZ3>MfS&I'I5[BdC4XNpL#=HVgja(qn+o1Jk&S!%1jsY_WAo
#ArA"Y\U?A_2DE@tIf_Yg$Y^=oE+=7Wn0)SWCf`_GY(A+Y^]AQdl!lHdhf<\j(098":WV8Pgo
NQYXu*>V:s`M>G'B;CL@kaSt*K.362%IuC<G"67>br)8[T&f3D=0<!mZq%;Q8fa8ZZU['MV#
3]AeC0$Jo!<GCm)AE?`f0]AqW70+H2Sb"(CMJ`Z=[XHX]A"B4tc;VUjZOj?ntCQ#r?3<F&Hjn)s
t,W>\2Gu=CN+3>ef5e3k$P@ca\:7gZIWh#Nc\8;S<2(Wu]A[[kp<gGt<VlacrfIIG]A]AN,!j$f
t^[`7!@Mn-6ssjrWRYh\;jQ!D<bP,Ba1H457Kq'K;aFf6_$Zi\_?8R"SO*9-lX<k`<@o*.[K
r9Bl<b5:V2VLRhd(gS93F/-lJ8S$lT5;,&Oec&E7uO4-b`aUgqH@o-?LRpK're7*.rZQ#BS]A
0(^9/:.9g$@8li%PUedicBhk:pr)B*PXnEnp\9hE91m=FC*qV*.TrJD%"?\R2.(.6PFVVUU&
DF$5A&!\C"="d,Y-Oa9t9A7OZXf-fjR$#gkW)'YF?r(OSeCtoM)j_jeF9!]AGtQ1-dqWV&H:h
"j3VO9C+W=aEo.VUOrtseHafMm-msCf^ftdN->0)@Acs(R(&V$(E0PJ=Df+IhVM_)iB2@Wr;
Y_\&,<_6[Km#jT%H-iLB0@*&'CqnR0g55<,Z\a<UdauN!S;qk6="B0-H5iB`b&sW.^C!O@c-
W*fC>^oUtM4MUMi0V8=DB4Z);BOXi8!rj2SB`eHsoF.48JMSBE>1b4-YLSggEq)_`MBRoDjL
TT05+BNngA>,L<XX7O.):psTVSAh2Pg16\NhS`:T8+P#%:MWDK;\Nq_H#Pia-O,3oHD=hS`I
Y6*o1s2l(QAAe;Pm8&,73*CIF?@p<onW&[1he(B3UM#:touHNXhSa@IqC.eu=TC<CBQ-cec^
./ANh6g(d>a(.]A-"rar-5b0/(5m5-FVIGE%IFka=Fc4b4a<U99@85:lG&="eNI1LpQonNu/V
j(M5'gu=jMX%^jK^gqVC=VR9ElN=*6c.CscZfKpKUXa"T)V84X[AJYBAZ:_'@(YOV576$i(\
[E4ZhiaWj+gY>9>!r^%hK_Nd^ST4\#)@8h[6bL>n9ikDqLIA*TS2D14#2D-E+JqZ]AR*LNa.I
'h9oSHQE!#>Dn<a/:X]A,p:_,UNjE'bWM,7#g$(fH[@R4aVh"egNe#;\&`IOJ[kSP<TK"PBdZ
KC@TMP\=i;1i^=q=I^/*9G`<7o]AP%m"K@\4uCqc>DT=qtY3[m:&Fo?Bh26eQTil9AoB4=)Sn
(3b9JMGP?.f,i4<qrF0t/5<`:Km^rd@X5;uf^'eFsBhK<_1%LHQ5Sf,lA4"D!6WUpM<G,BBH
Qc`Yk<#@!]A=1>g#&j,=EC%!J#+aW.'uq\p"roX)%OkU*426:<b;c=1^d@)o,8\63q/j1KILO
&K8#[HZFcn9M5gF30ILX=*0P6)\!Tts2^d9W[iDOh\+t9'86Ks/Mb]AU+^j;(f`V53[Z_;MEn
.rl"u_@?99]A\J'IA']ACUCsHs6j0HfYpZ4;859sVhnD^[GjuL&tg#L>tRt@.*0@b4"Us>l2&G
bJZroCAOipMf;_O3/gaZHE"@OnRd'MppRggH+NVLmT$(uL?L'<n6K\2duNUGd9r-6g$MV+7U
XDu09SYuQqW6,55Rh\UPI3cX^6Z7O.[41@%@(sW2Q%DlVG#JTZF.pp"G`m7B=P+V#UPT^a(l
^!4PGIig$HB((7A#1h*9,bk#gE@FTRPat=UrM6$j<b+@<^t8rTGf_9(ESXTbq]A&%&$<]A/6j&
o<d_YXZq.WV7fVSG:9^LE-fi8Nsa]A5gLq@;+4\,!Df,n<QXKNm=R)"2Y&T2:H"C+Z_dMZk$b
SKMQ%Da6]AjZaM09r?-%f9J0eEIZ!oZ*Im5o^*SqZXu+d]A<E%);Eo-c=mF6EQBC5<VC@WNK@f
YrH.@^&Q2jR,0/fQfH.[YgqULS>=`Rj\T=jaE2Z1c;Zi((u`'g+(;E;2M%9I_9><S&+s\\uE
]Ad_P/b%I!X]Ac3sFX+_M4gM.[=<?m8aa_c/![Mf?\Ln1'a*hE8/&1/^&j]AQomZH"=!Zp]APaZl
a-Di>tM"+QYZVVfnK64SWC4m>60U!s4n,uUR4rlkHfK9rZJr"ht,H,"=YT-HbuG1c!V=ASWW
K&Q+qA-/)g,iYb'nqZ&P#m`?+rG>#7gPT>1W-@8RtW)W0ZG2Drf2kfCTsLk:6=Ci5C,XQS_H
Y/uk,:)@iEI)&%_9"\&]Amm/^+$`OdHpFAcT\&Wg1Hm:X',k=09%Bj8adCZj\I2-S.h+^#94d
8<S_J9<;M_C^%Z_%/r:9>26iDoLuj'o:l&CS._M?uM2m4)NcMpC_GK[#W%q_I/s<Ag:NiE2#
:gf>S?^XHQ)=3o!;Mf"IJH*[+XF$,u;&^+V(GrP"L.S?nW/fHE'>X^V_*H?1%_Ei4kV2[WYb
h<Q0XU:$@0g=4a4ga60a^2TFqV+n#42,9;bK@qP!MeP]AjD2Ksg)%D2MO+7/[pp=jeqC042;a
&GWm!PpIpjJfTu!N'X+)(]A1!mhgP@>-_b^BfaY>hse/8=#07`/Xc#B!a@.aE6V/p>2rY[QTl
$FM7iU`JhRH%Ht2l1:S-=VWpF8i.$PC<7Oe?#a*LJqL-#2YN">^p'iQ9mc]Ang!rs3MWDi4-T
2%(<r>p^C#g<s_;=eZZbartB\<L>PU543O6?-%)b.L##=WY#pYqJEFFUa[G+1)*4DDXE4qq(
:c'sTP=[,Jl]AdIC9Oo/EFF+8#Aan=uL!XE`JHUa7,#B0J_*]A]Au<[p5`qPC]AOE\>4j@m3DIiC
R%YdHSlh)f]A\&+=E%<]A^$7Rn'ONB%iM&st3QM]AkSB=8!P<bO?<:cIlPJ#0%QEkdLbgS)_T6s
Gj2L3b]ACf$X:/7k;c6hmJHO5Lfa.ot"=-,biL3N/"rH,M5)dU]Ad'`D7b7;I*Eu:H2<L^s*'r
V:AD'aqV3XDSYr/38??=1b5]A@$KrQI*RK(La!QUj5HpLO&%8!g7]AgEPL9jVYIG![Y>"Ffkh9
:;A4iE-J+'[:E70^%;?0`aQbLXP[CV]A*tVKQ%7&]A&XM"Rp).O?fBSKkSPqK);t*^m3Nmq0Wo
JiFlY@i*+NE&=nMWBX^61j.s1(gDaSga"n816]AXKrbJ<GWX5Q!4#:Xna%pfg^%AHu=L4r/+K
@HY'T2Ws82e2#ep,OoiFS^AZBqRJ/+DY"VG-<Kd8T(4B?212rXVA"[:273Jh<:RpBYA^:jVP
_sEE]AW>Drt?3@2c+$-gs%cf7ZQN:_g+\6>`mdGQ%=DbJLZ;j<[!o%YdCi>-2/(R$3Df>iS<Z
j0+"$K@OGtce0&r/U&Y$OKguN(%i*CI.N+WKiZ_]AmrX"Rp=f2uZ^\,a^9-ND^Yj;iWHJPt%l
kS9591^no9*pjG18RM'&[^GX*L>0leKCtlLi2FFq_EEB6?'hCj]A.GYYT@R:NYO>6M$%me+-O
eMREqBp'E&4RJ\S%gd`tDCue#<Eb*UeU-:Kg<:W+g8CX'g2S]A>^PBs1gYHB4cn\\nHI!W-sV
?dR*k&B0oe6@V>56Ai;4)Hc5cUD&"aF<,L:/eWt>9[S_!Ec>.VW5RN=qD#<nQbV+_q'rSi>R
[GGnfW(M9fWqG3,$hS1(#.:ao0DrD^=kUS11bI&C)Bpbl4o$s*0CP1HREQ1mCo<V4u3W;"qW
5a/tK5at%=8Ie6;dtH&a)8DOqo-bZ-NokZ(U_G!]Aj#SK>p5GM1(We3aZq1ab<->:F2=b1i5B
Yh+:O2@*28/Yi9?HMgOKG<;j,=]A!EeDWg4:!)0elSU%[=G\NXt++MS*hM<VA/P15=Cei10p-
9=3n_"bE`rcnSEXZcEB;k`G8dGP&#LJ<;hbhFA;>ULJ5i8+#<6E\j[XCZUCFi*lLK]A$"H!li
!_[gi5(]AMP%W/0VIsE,a34gI2ci^dILC9:6%;+i#ok=O^FNnXZ5/sLGXuQt/2U7=2TVbgRl,
#cqh:g2BO%kb6AG\6c[=Sq@!YL'WB7`EbCLofVqIbiV-=M2;!Wo_Btu%GX6bFrn?dDrZc+?D
Z%s^2`abCg<`o73nnWTFrYHO=gNOCrQ";r/8Y6e%]AnWSk)g@/m>XE8@#NkIZilW&i#K@ija&
ZN>=*cLmAM3^*i23)s%mkH6UURV90.5QaE"*K4\:o?Qq#j8s'5+*gY1H>:H^hjF5M>?J^4ip
b,petD2=+#gT#>(7N'c2XY4.R!XC;(iQRP$7&G^QhVaJ/=rt5_eJM:$#O*'Y0/st_j9R\mgC
4(VRp=p"9#u;dCoZPo0Elbg>L+TJ5s/I"lB2$\komK$)N-WX6r<(FofnYN/P8CI^InJ+MEHn
CAU!*E5o'5"@[?[,Z8sTaYc'A?<[SsBDi,Lg-$hu4%[IO&XOV!3f)t\@0%iKZY[3Csb^!kod
CK&M4&r[0$;'Cc.rGkm924?cd4qq2ia)K.QU6%IQQ1ils$pfrQKN48eEjh7tis6*WH6%N:DU
L`Waj`a,`q[S7,U$Q<TTf9YGYrt9bQ0RO-*&F\g,:0rjPgX)8uka"2U77[IQ"H;UhTDO;<h<
qP[m=,L\W=&?/EC;XZ<FaAt@l&]AfQS44!+UW)?)a?Ede7BD2%&t@]Aud#pira)k>A@+,*7gaT
2ic>\N2*Z6-_gq2La1'j871;/QKh2LNpF,n.X<DeB%]AQas#1,B%b`d]AW]AWse?q>N%d/`k'sp
2'/,)H=4,[i11+fsiU2,:?Hii-PKlEWjFl6!),t3c%NM"XS9^uq51S1^Is'*]Aa*66ZF%,A't
(7O>PMWAlcJo<g!e%'Z0j;coh2HF?h_-+#=hqmW]A,8bU'oG3FHZpHi^OWGd#>?<soKF5GZ:"
N_g!T:`!.<OkX=h*c)_0o<&"qh#/?8PUaia++,3K^/<OKhhQjZ-UjH`psnpX_,n=AR&uZM):
9rPSKh;9C7H6CuhbaP*f1[XoG'285n(7QPTXrd+as:jLU7=NcXoJmT)noP>Vu)ETAYT2jRDO
h`9_(nF3KD5I1s``_e(>9DGS]A=\R/GL:fY@IqqGDA'oL$X6cT",/K6_&4p2l]A]Alc<Tpb0$U`
YLSV)idG-/)e=E)!2j;`r_647"@J`s:?=m>J5k@e4Uf]Aefj]ANT[u-:S203YJ=EJH;>0b)K)%
j,mgJ?Qnu^9)(0rARBN9#Y2GeX]AC@;U7U2QFo56rA&:]AL*m`&Bls$"sj*]AP-j+Ffl3(Z7[0@
VP"I+"NHF\)'@>=dlS(=RlaZVoV!92^_R8nS1iT.f<LV+*=laqo;"P"Fsl4@OG$_-rI+pBUG
mWb-oO<pLM$LmrQl-p9JR1W0a@gNqCfc%G"pW0bRbCf/%QrN]AnCK6]AWeJ?91J]A7_QO"iZbCa
Iu3flM_:oFq="k&4>]AeqlAP!PPgE3g<DJah]AOoH;#P762<=iRH3/)HnI.Sr4h&b\4AfHC_VV
LR\p>0A7qr%DPu1rS,!Q;J(7=74^Ll>?_$rtDb;'(9m3)g(K9&:b:/Y/3TXsVuBJD$MPNXJC
*4gF^VdT6erg3$pd^?43Hk`hlYA.+UTku@HBAZY6TZ<'#&nu@cp'nZgN8F)@_gJ6TUCjI`o=
$ZddlH9ne]APAVeB[!c-@\KlS$eeK21tIBS^]A6S\I*J`9N_0i\Y#ED2!+oafiT7t:U&:W-(7)
XG%EBDr&6>[j2\R\IOWhSbas'3,l/eGWZM8A/Gl1kFnr5VO$qD`m7IZBGFI)*P8XM!/7Q!R9
)k=dI?K)`o:%DF2+HR+9864Y[<,96NH8#(C@"CC#XY:0U)K48Q2A8OV"49T7WmIKIfh&lA9Y
U9>!:',+kd-K=?#Q8'Z0%WJ0:d"X5bq:_53,S96e5$9$hi.c*01(Z^1q>F)tpb#Gk!I6/!,,
'V,ch^#&^pEo3q,9!Z$3c\WnI.0ZQ[`)".@"BCArQ&ViUn/hp$H``!nHH;uaIHl3cm*@\N:P
D^(OD2GXXSp""3m_S+;F.L98$@b+a]ACEBn^Y4(_7sSSm3DtRngSmEV8(+&D?70&>=>.haLmK
ThqhNb[W[H&BmD)QUaB8.G+k4odiB3tVs-9oYI!q*,$[o%;qi>2fbJi5Bq1\l'@@05:HsF*,
+o)5!+B6d#m<Qm-N`*MAoFtKgL*pNa`E?e$=^.c^UJ$bO;<uY3'?8p%Oh=8nDlh1-&dF;6=]A
;YB@QprSNclWgYJ[GUR@u[GJ<bt@kBp$im\\f^2b[=6U`?@Rmmo<?%GaXX?u\+N[+i4Y4$Ma
=q1b5Enl9HZaO]ApBu.B=.WjoSD7o#eG7J=YXC^aG2-2*<fb59)r$iVb<%E0T/;/e"_;_9H.V
g(o3csT!fB*p1[YQ\+W9!HJkh<0)#UN>bGQ8:Q$W=&+1l4_b59@:d\3>fM>]A06/Zn$!oSXg<
?PJ@gFgda<`gK%(s9IbKEDIGZi&eo+%/n?]A@8C&%t+MS_e'AGbPhA>`*.Wh@pP_n?/W[FkmW
N1L4!.QS7chH[:3E_("Ld7a:Fice['&<8!SS(qK4!2^b_9"tO0Jd3sZrc*t!ruRbcg*;m_`6
bHp63T'@&C'Y^K+3DqE^7I9?7AfNY>_q*'a)`XE)^jcOD[r3M6)f&`4$6*6kruord9l)G^,f
U`-O>=sfZJa9aEn-e!tl?nE9s,'Lfb/35.g8%[M=X[=uK:3G#plo?09;K#ap^H^]A26X<i5r[
V3[)aF@>2qFjL*S!i@'ndP3r_LDr>%k9[NUYq5ci+A+(O9ncWkWZ2f>Ji!fP>]AC2#Wq8(SJ3
NH,H;_)lVoFLt&[)KSW@#HTWJHT.MiKKJ;(&iM6fn#A&(Lcbp0eWKs[Bb]ABX(k,JU(*$#D8!
gu&+fBdQa3ud)V7fN=q.5'"H3ZNb\k3MYaQ=^6Lee4m]A'ki`3qV(\DcO9B-WcJ7J5aX59/JD
kA`5O@o7CF3#d@fO,GLI+lTJ8T5a\oESOlB+Kd,/:I]ArA:W6:,qbT\<nS<b@A:<gVoR!e'&?
:XC.[EFqs/-s6:fR).[NJ`%e2IU%m`\qD[<l(cK'is-K)]AV4Vb=6_.'Skn#;+_@r_+jQmZC$
[f-/?uo4!d'=.(s".:#ZC[#F@^=qn.pOnVY<pH!9JZ)Lou(6\G]ApV8AgGP:T1s3T@XVS0r'N
$VZW>$19u3o=[+/nktQibq2"?gonD"-Zagu$hU)=0G*gil]Ap\RfQaB^1J*6V;3lk:Eq)n^L,
)%&&[.']Ab$/S]A;g"jo\^>Zo:PhLW56F7[1+#pP"4WlMkf2p@UU[Jn`/0#s?lO!L&W+>L3A#3
L"i0n=&HKd'pgkQrjcc9\@=%Wl?=AQ16#r3r#NK[q)N<.:9'Q`Ok>8'0tpkdoMFb$=GKWmS9
;\F$A`;fsOk6.8J>>;LnCCI/g6FQMeOPRU>hsE::$`Mcir&K+`,$m%IA+TkBnW!5ib@Gf03(
jcnhoH%BSV3R@^R")5_"21>G*sGFMD*'r+ol]AVC:+e>3IdaR6`L4[M21+VRECp[gV:a8lB*j
Lm]A:^KFq.V$&b4>?,l-YoAUp9=-Y?-PO!IFrJljdSlNIHq#KSHG$&O]AtmV%)4b\*W*:$D0o#
+:EXK9aL"DaF=n#a`=k:2G`C5MQO#*DksG/l)4&*<>UL!5G>^T)qeK:71,:IHsLq]Ah+"BaZJ
"`fNS6C>qV$ol5s1nkctl=[GeUg8^"I+]A4)LiWJieafnqe)X^/C[K)Ur<fm-J+OYcPl[`!87
\2SnP,qYlf*e"<q)1U5,@=Of[S1NYf4tp`7(9I86*M$E'q>d0YbJBa*epZQR_:)2BLWJD:q$
[.(TG]AD%O2qA/6*uu'ST^%b4Z"KT6kI4]A?%EZAHWIpM7^[/5Th,(=L0,5l!oFQU3$^8$Z*^1
uW>b"@J#@31Y?HJp`bNq1!NW=!bHT\iLnV9$1f%NdogNF'V4!;OJ$t0uV'6'=1Uro5#;T?iR
NSHi=ka*Zq+,F%n0H%?`DgF6p@^c59+T2f6q67fU6)ZTe$Y\H[6Qdn7J`"&Z!1RY>Q7-%r4n
1?Mf$);9pC96NFq*EIh:@rH)Wi%`puBgoLS@\C\[a1Kcl&ERi_kZ\]A4=;r9L)dC,1Pg9C@F8
l0!1=M[B,qpoDBA0As,an3Y6HAu2>@.SjU,h(putE<7]AGT&k00;"Gqk-CO47,.)ZX%an5*TM
>U<DY&nY8KUNk70^^+`)mP=f,3hBf=]AII\e\.&\^H4Ac\Hg8U,_]AY4CFS^n.3n+n]Ao=NPO+2
rWTTfDMW\Cr\U:/2fFY(VQ'f/T';%$/Q?l2RUFNL"<D"R3j795CARr?S[u!oSO^qs#ap4BN-
!O@>7;U/d!;rpeW`E1F?*UW;@4fInI([mIX3neaNf"*9\`WO,J5JP5ReH#sJSk+sdVBHWT<n
3[W5q)Qk7%AWS6[R&n/9/>1fRfl\@,A%Qh$I]A,\5Ss6k!*9&K`=Kn?e#J.8siL#'n>FJ5:$Z
=dsYVd3'EK(p[FhYp<\`,ZtVML2U,do[XW%;UO<5^r5m#9)LZC0C;GcV!`kWiRtbMgop(/[Q
J:+bDcd=8c%']A=q#3mlU1G&_#q7?C(Pd/(.8+Q))[QoHEWY-)aQ9F]A0\5$fIP8c`8+#p6Cd]A
21jtU$F-kT++Y^4aGg1PYd..SPQR(-RLRY5.X(.K'Mp=<kFSktH4UuVbHMhVA%8bZ\Z$VdDD
@I?L/.k0H0@j;m#u&3""J[5RVO5RUB^cUrjN@3'Q1)b9JnAXD$Mn-U#j8uRlc]AiBHeJm3:l@
[aal9#s`_Dg3k'09>*gYMJ"5@K,(-%c\KAh^HqI\F#l$!i5)m>'!]AflF+:.'/Z7bSm,U%(`5
IIsXpD4[9s`X@PdDs(oZd<(VJAWM;M`'DEp/WJX:$)0&hUokI39Pk[98@DLGr$erZWuf'o33
BLDR4hGth*H9J%%<%\.S9C5ClMj1kf%"uYiaQL4_#:"5*jmu^d:i8O(otT(opS1D@b)S<X'%
W4dO$J%t4eQ$&?7^]ArUWTi3rHtVGYOBYJ\,`69!dZn?@/tdR"'U$]AbfA"^;9*RO!B/h$t)B]A
r;ZgO6t.h'#a+CC@,I3pbO6p\:-Qt/+6_0Q!,p4;O_b!X2!e+]A\AVtP1U==Z@*BhK!<q#`tO
(Ihf>eg1T\g6b)gtfq2-V;WN@Yg1UielAojqPp#RqN79)uaCOhKDnslsd!311=W\25qHU92M
TO=1k5K]ARMatWuIg]Ah6Vs)c=@icrqA:[*alj'0\i/\BYDcG\G4NMaYXSt,O5C9#MiQ%q!Z-'
TO-,*S#9Io9S+=dp19a$p;[fgOrqqIe?DX&Zdfn(hX'U-W\="`\ZUb-K,XYllN.q`p_G'/'o
Z"]A1D(]Af4A2+9/eRlUCAE3(p\Nl5%`rFYk!DXK%g^D`tq"[WGb^VL![-`b3lT>5Pg<qO]AC"#
iS73KTAZ.Quo[RmaDcp<38tJS9Yf'7B3(qaG*m%89&J^a/#Nh>uL6iVUa./V,X?-$RDeDDCQ
[FGaC/!aknKcgq7&BB1DrV$I@#ABjE<[I;gIKNDeZCi*YsDr7sD;47=3M+"BsCJCuCJb4>J`
Zd\>_O+IcJ`(aY8*5bW":!hSRBBrWYrB3ulf:P'$lNfG4XuKoD&)\_jrgi&D<tZ9e%LH?nhp
_:9I!@S%n@W.srqDTZP,:"8jK1^*g\[7WZ`K#n@5u8sVf*Y4U/l.bp&`HbK%'@7kec.@pq4?
$l(+E2@K0'DDc8d&f>eK5a=bU.mtbVm>9B)[D0dCbijAX&7.r&n=%`:f>k_d0^UrR"Cb-GTP
^CK+hXWTtDNQqWAp%XtPkSG4*+_bKa<H7$hEu3R9GB(l"m]A_#i0KUkXJ/#:4eYXpHr/[a&5V
P`XXAF"+79fANDkD^Li[FhA$om,e2anK9Ud?lNP`]Aa&_cssr]AIWX=s!9rk*")*J81^i76o%M
2s%mCJAcr5QQ/uu!646W23)o$3&*FaTeFtH;J:_9?qBI2g\F,):$^kWVr-O$^/-tI%4=Q4N*
1_C]ABCQ2&,D(E7Z""\X?JF7%sTRgD902l02?=#YE">?rAI_=qBL7%:$[;Z=/??_[1;.'@B+#
91WKq2+P*kX[j>"P#,m[7S8.n)I$J0]A@9j[NL#nle-"_Z$Fdj@7lSb`fr4q!'7QA))+*K._6
<FQX5=tuDs,@&nVXA*6X&b'&p[@3a=NeP3KX\jGlWLr/T;@X*8)lWuDp%"8k`.Ye>IIBl9'+
DI!nfatGiJZc`["*I;B(eio"AOTf^+6^[IV]AMN90Ue/+(Xo.L>j"n"P)=E!o.6lSLeMiqZiD
6ZmI:<8O1koe+Y%oDQ4jj#7ka\%)pc\E___%OC^#5bE,Ke!a\@l<#hoC:N&tQ0_g'P:iX(jh
.9)OT"1j?g+?I51NA;dF&^.(cI]A@6SWYVN3UYb>WX[Td)\sBBt20CK;8ud.7$spW.#1<qCuq
9PG'LBK\<iA-_jS=ZKK03:lQu,KtbhUi.g@PK^l]Al\!4A#7sQP5r]A2QWa"2V$>jhjC09&r>;
NWG&cPg?S8Vf]Am$B>SueoK9(,-Raq#')S=@P"m9#(C@I.`Sl`<:=_#\H3-nTUqtZQhFoNCP<
$*]Ak:pM]ArNS&+\T'Q!$+'C,Ps.umL2l#!MH-2cPaC18J0TrbE)#(kP\0;piHiN,gT/O7$og=
)5lA;&r1:W10V7]ADdcc@l*\h5$gsoc'O9.;nkP4*BVhcSo&TnbTMUk==EA.Ul^C.f[Mp)%pZ
'q74&Rup)Ghi8O&YR-@<k59VlY%$HNi*kHc-OBE+^s_@-/LBfJ0bGj"DXfa"]A*1J]A=(^X-VZ
06b3j_Uh*+C>]AJtiJ+eMAi-7F5[?UDudm(%Ma7L7Yq\6>cbS#\;g+mgq-JkHRW?7^7?cW'[l
B$OZ.@9tEO"hjB*1nWrm0&%Xg"YFr/5Nfnk6knKecRl3'uJ:m@bgNbJj,NIJ;1H!h3l/.$g7
q<Dc7q1F//SIpfGH+<[*?G_cf*lSFnhE^Uo59Ktc)7AOkPJ.qu#C4I_/6-8>kV,X]AT4HP`7t
]AriAL1"%-H"n-Q]A[q0EV?84FpB9ZF/1Ydqs8><Bcpa3;N92d`ns*_i.#&<Y#]A<SmRTLT&&^5
cP-hBUR'&g'1n?iO+"$a=\jL@Ci?K!s7d`P,bt8;cj"q9mN#3CCcVrk&fsW#XC-%I#3^nKjY
U!oOPXEcYY+OuIn-s5UB+5dSI9j)cjp%FcH+hH?q&6]A&Cr`>XM!qp(ob8*D.geSFn(fK^Y:4
:f^AIO+amZ/5W&Ea,?MU.L$9\\;^HDgIrZKoc@$'ITr+cG*Qt\^\0-6XN?N3Fp#s*g=AuPFa
\<GJ$^$2"PbhH=2hP]A@N&o)e)XOo=be7L6J[pF+=pt"YrQ$54J(*b4UW+@dGbj`"j%sblr4a
AYhs@K]A_ib[khFp(1,#3Ml/e^cCU/C7Lai=$p&3rD_'I=e)`<D\c'QiJ8W_b.>Z;!e9%QBQB
DsP]A4>3PWqWLsloO2`"t5^j1gc!mF`Sse@=\2+Q*,"F!V64!muOp`i$T0%rZDuf,_u'[3m8B
NENuE?[l#tH+t)W`".aY%^<+gJ/?@)tD0>V)e@+-5.@gqM&?@$WXCF=?hD_=r/T>hXkOiUXM
?$DUT^?A2W7H_%;0YQdIA@LWh9Hth/afLG)%0!n@bJ8OSSak^O\M%Nb9[*dS?1_NMAf.5dE^
WTjGDp&:p8SFfX-l`\29Nq$%,3VlVJ,D%4I1:#qXp)\_Z@BnX./+$im3WET,RD-Q#Y\%P`.@
U>5#/_*e>)mu.*jH>#s="[qm,ae`p_HjjLWXr7+BSMG.CbVB3MBq,&Q%^Up+EYg#On@<Mn-Q
mtP!.pSLH9g9nmnQlB>1u.eU"kF6K0D#[@in\G<,n0F2W^.5nsF[!F/A2b,U[`KDX<cpkTBR
p&#*Qg]Ai2^cI'4fP`^j00q\aUh2p24:>d1(U@[6#76%#^`SWQ+m4q?8OMr?asenhI8=sd9,n
2"g;.#bs4LdOkAR]Ao8jPL@G.2fV,'7QC)]AW&3;=AeF,h@.%;$"os"g]Ap1bon2q7p7=)3DX39
c`G5K<mqb6C5e>;J#qZgDUp>gr[gUDNNr$eoUcQZ]At1[C<K3u,D?!X^^o3;FNDSHn#ZWM*RR
1t@'QiV6g330=/9CK;X[!<C;8eN>#gj=O\(oc!MgPDUTr^!ggnP&I#@5E+6b(QFeRpbb=%CO
sEHnbsf!YD6q0!"f+!BbkDQCUi0!KoRqSNJr_iU:*]AV"X2f.0X(fW/n<>mW>JCKWT$TrobYo
Rm<Qs*T4Z^M(l97%jSe1H7qU#0=*(WRm5D8RR9kZq,/8r_PF#q_(Je#&kn7Z1s$.GX*RCa5D
!1dunMIlp/V,ni/\ulFTE<b#DE\2>(VA]AXh@TsYYQLVoRC$7<Uhd)&VDt)RT\C26X_c&=8Zh
.(nD_N(L1T[#\+PN?ebHh-C&)mYBC4eB5$2-E4!-\Y-K6B(<dg!GCb1guN`'2o*0RSCHm+$.
^;MCFC@QL]A>Moq0l]A7*q5(O067qpZZH?W>7Qm.QV,r4NcQKZQ7,0B,Hqrn&BA^7XE(4XqZRV
*5_8+Lcc#I:PfD6K.p/#kmpEc'ZOo+j_h)KmC/qrR$oP$e6;\h70On"R@pmRs)37A@X=cI(5
ASb.0ZYZm/'8(sV&Nu9WVE@n,Aj8R$0ecJY+>setOOeO]AsSK#S[iW>+_$Gn1hE3bGm)<:&ID
;Cr#-/`eOV$=#FGl3V*.t-u@!8O/H5mGs2%9e4Yc855>V(1#sDd_2nc.AVO9o0qE=i,9;;*P
:0dkr<P3#WiWg=56(f5[@nIT#=YYas/B-RAc=gb>b9V6^.WG.3%mfO<:aF_L6AH7]Ajd#X'ia
m@peJ4tV@`Zg.9!.1&,]AI3`^60hK8JeCT!]A^b3<-?s:cJV9HgJ6ljd0rS.!ni@gjcI0d``]AZ
s>#me.(^Wngr+SG2CeVTO/s^%4a`?1&*(7GJCq[)g&]AY4^t2CY:GbZ<\!c\d^bH$h9AC.#Ro
U`(hGSDGR8cXrmDI>Y43LmkZXHWW%?9ZU51G)PeEBf32+A?[P1Eo7rRC8M[q%Fi60ugblekG
?AWF1QpeG%J1<K`fK3f1?u7M7_@Uu/5(gFY]AlQ?9HZ:70)(XhDV92:AXUg`hAF,3BNrtc?ZJ
.Be!VS+/A,r8W#]AUGMcd@TGbRJCc(g^t#pO,rf/7FZa(KkCe<YFlFS9nEmG2sflPoV4DR)B&
L:pq(9p-KPPaf[03n3//84el2p,SU@Y&E<e48m!5k:>mS:`s:aa>gcUmP4'![^r3\<Ht-jmC
/?m4E$Js`%I8fp-ZbVLbBrT2rmg3JYB59^D,.'RR+41DmR*t6.:%<'SuJB$WH1:9Bl;&[G1s
[1-p*@9mUjh%loB)e+QAXR\(2/K7E`"Rt8\>aS]Aq"g2G-#%uoKKO1,T)9X)*ELW_!i^+,ZeG
"8N_YJ#!a=*a#\2ckI<4:ss>6[WbEjP/ob-89`"0V4QBqA3j<DkkS$H1A@PPt4]Agj_o4'+tK
D]A+fu_ln%PYMTacJ[63.[KM=f:_ja<2nU.74CWts`n:FS*W.fK1-?HN+,VRXtJVou#=H$?@V
A,5EQqh1%/\a[7"5`qse2U-[TW5g/*[95tc8m>Y=[4?e($IX?dpLsXL9VMD4>DeN*7TSJn8W
jD.D]Ap4EopQs2%<d+FGbho.J![\WT9a\i"Xe)0A'S4(Do47b[ns1DbkBg7_W"gW"J."D7uaa
N/Cscm+tMBbps&f@I:6Fn3@*JNj`AEXX5PY2K[DG=,r]AN*,#rS)1YMk3S7Z>rac\XiBDILJX
nclO)H+P@<-)r7m%AB4cq9>m<]AG,;.TR.%2h!!f^ut&*ppbK-/%m5mnL3h,5,^Nub2/9&D6V
]AXEh;Zfg<"%'gA0U-[9etH\ddE!bEjhaJm!MJAq)fB=sNJb\bqoVAVe+-]Ao.;0AJ8/)'`b.`
/c.225=-ET+qU8GPI!)Vn<Oshroq-=4ulo\<*JG@1l`NZ7iOp"rgm!=N9bg'!kRp56GORe[F
*Ze-_X/uIu\GX%q8D]AHVhsnoe3UHq]Arj72_:7Oo_6tRe:(/>Vaf^d`ll=fd@n%3OV*s/1GB'
E5cC3rSVL"`4,=%9UnoX3?,*R:BL&@YTsUT4PY@5*euHO6H$jM!;mT:cn]A"sa^^-.oh6sb=V
0:)"c?G_6C3@L_g6;7,[NEI*B(54.;OV&q)[lG0p<j7TOu4D+A5J*l^QYX%\*Jqe,JhEM*\M
pH^o-T_fHdFK%fYZf3NGgLkNAuB8VctGdtb#[j`_g@$l]A4*bds?]AR2s1r#Kmm$K]A`Ft_'0aG
:i-ejDrYFFqj+E8I)?#&nLA^DgL8:mL%Dc9XL:USU3tuOh^_2K22!1O"jg-AjEb/0^7ZgQ:t
p/-IFVq'T)+u!%9^n^kl6"'ijBVbiUtpH03[;jqhVS7YRf<5a<tonb/^8/^Jp"XT9.Q!`-go
)Ancj+At%<HMZL<?V1G9Ao;%Tu!F_@B!goTDGq^O=UElgC(>l,gd2;_tB3jC=O2f&1UPd'PK
l7AQG1e(>XGa]A1RA0!W:8s!tjIVQ?M!,/U)mDiHX.?]AiXL)!JUcITNF_S_Q#!/fV?WNdo@42
&gC,)AJhhDD")JJg>kZmJap,;5?D:5sXkc:K<PEBa9QJib.b2@A'=f8diS'($\QfG^::d657
<V:tQcM8h.YA!b906q&.bhUAFrf9M_q7qLH]AcK%fEko7":9)5UF&FU)HT<''_1NQ=7K1_:?M
eX8PlN")9X/f2V0V)gpQ\<nWlWS%lLIur)*(Vq7HW-ldPgCM\!U*Zq7/t[9ZJGbQ.kcu=B"2
=\U'`,/'WYkV="K!,4qkKms9LrMB1a<E2$n+Hcb8#[6CjDjWHYeq-Eh1YqEGH[#\I$_SaY#0
6s+V&9ekked7;eIqgeapJ!s&-/Cq+$nJ]A'<O`5Pkso[XafNomjgLWZXf\Qir?*7RbjSm?4jn
0BU"W^h_-pVV[c"TsC<]AHfJ&k2h;AtI\)mqGgGF1Au-jRGfBJ=7o'0tg_r^p'8Ru#;&!QrN3
bM*[Z(L"O&b\Ib3rMfc\PJ&jiaBeq0h!'-.7%NSC.lPPk?f-?/)J^>q_`CpK:4B,;5VFnR+2
lsrb#LEK0=,:Kcpb_Ad,oTnLP"t2%U#^bl?GK@#f#m]AeM=%mEkc)6Jq$!H.f(=?7BVk&!<L&
!-+?lu-E%'@#]AC,V5>Ce6PpoMtk!^cG??pg.R;Z1q3IMG>\!%.Oe9l+@1H\dgM`c9uVH%P,=
ViOb3o&![&4=r6"5C/t_iChbV1o%?35?R6TX/?,aURKVM_s0-iV55%@%DcD&/3kXqm0<oYUo
!7:?C?Xd(bl7%-V#>^1&&tR$EUA^)sfY))_-f;"C/c9m'a2'L>+uOPYniJ-&#_#t5C>64m$*
UkD8F<LT"GV5cA;(6PIZ&<Paq'2Vk_:o#TITsrD7,cHcQ1[i!&bb&,HS?qtDCYe;_Aaa\"&t
C/L'^2rT4oGqOaX4Lgfb7Y;VC2"LF@A%:4qKC0\K;eIZ;OFWgW[s^UTPuJO%s"j)G3%.='1u
og)JlQ`[a/KhRGVWecVdHDlLsZYX/0[4>F$I(%ZIg)BJ=#DW\C$T=ef]A/&n-$Ir)858!+:G^
HqM0j(.Cg6e3<2P\l2j>C]A`1B<cMeWhMT,,0Z_ac&\FPL+8o!<n;06PNYkoH3_<.oRN'g:C*
(lM=En5FOnBubKNj'eAa=CQJ`*/7m;P`2\1r*_)!RhiOW9_O.L0hN?d44,Z+_N>CF'?R\/.o
1*]A3Y>XM'OR]AA6E#.Our/68rm.JOlAgp+D^e^E`B-JR&/`NXr(E5<aPoc.GU#sOn?)@/dX9>
_pK85AVse6B(Ah_P&"=^?P(QE%F*c"qSW.o"n#PM#<Q]A,KYf=LUUW:g6GE3K%o&h9n6=BBCE
i"GIXaU4qkr&`s/@Q+%0H3Nqpr7uR*Vm(G>o;nHuX1F3u$N&oWCANXHB9p0/l//eI[8lturc
9)&&ItCY&Fj4MDlH+'eSP-(]Ah/:^/')U`]A'SLiA>^I]AQ+%HBLGiBo85?p(jaOS7Im>H/(12*
t2_7a&q=3CRD7t[-P9>kM<dgbF?AYI-CDS$^aK;tZ)kA<'kWPECS<^IM+HI9SqQh1&1^;ko6
\L>aNCK%6DG%'<5aA^A#j!_cF%R[U<C*2i8*5,jQ9fa0_';$f4g:L29_-&FsLN\9S5JaAK4E
dkt+!A/eGdj_I._a9"5%,;(9+:+V!=:(mm?n^QDSDX^Ie17-=HV]AtTkLu$It2:J\N``V%#(d
lr#DmMpEGr;plL%p[ouk+COW$7-]AnG!<X[#B:FY7nKGWFO4GdVX"Js%42'a.9Rkg`bA)Ji%Y
K=Yb!(Nm5\ZY5@WA28]AQa(OYHPsSg\^c'Q611LYqm@G!DKBqo8s*>gL#Jf20m`Ul8VV!!,8H
Ph'A##YaO4%*gUpfQ^Y!SF$Suls,XXa>9X5g1EpI-?)sY3U8Jjp:j=-=Q=AO09KMN*T9)@mC
TFV+7=MmLr/V=\K_=5.#d5Ul-?)+<$6&$m4N<IVfApCc^W=pd-W:B!N+=O[I2br.f_oA(JLK
`oqiiQ"8-4^Z?bm&qT:EZb-cQR[9^."=9K8\q"d7n@)"e-'.\_f`:iQ:o_4JlP^aSC?TI`T=
]AUHl?OCp.(67mK8o#u(CXdC<DbB+\UZ[r`;I11=&WVC^NeHnf-so"?BIqtRX1kiZ8!7%5t\9
hk8&-huBIF+-d$I.JerK'U5]A5I.$Y;eXnlA",LC+6LdE\6k8XJJZQm<;QaC2Rq"e:EIn76XQ
u,q3d%&`k9`_*&"MG?GK5qIn80g=8$_OiH8(I?b<6rA@mui)"=3Zq9?!^a?(G6(sBDl)El\X
)04h^6]A'DKK\Iu/Sj,*"lV(BmP-qf8`qYYDC(i-\[WTCG4B$eU.?JR9ph?ARe&P0UUCS'Z.G
h**gc#j46snZm&S)6?;09<;JE.qNUm&D:r..1g(4F+A'@tBO<`^WSs+7g.GKl>.hf2m3i5"X
hFfV8=60BlVOhAV>%rq_FNi??q;0ptg_W)AjlLW%@=*RT$(=I&406Rp25i5:T41sf9PD^lN+
@^1o)a!4gWfrV2I;&h)?),H_KY5n?bRiDYM5W@I3S/&h>h/T2Nd1l*>4QMVS&p2`ZNN7n&qr
DP2K'[cC^mOp`JGUb0=^u3DP"+=[T>rqrq3b^Z>ePRDIu;oRa&lfqp<L;6E=2R,,2g>OO]A:U
g.0&QTEefjBiqVaDgCa@k^24KIH^/ik]A)N57"^uE[C<uQE(hhR`uEM+X@d^S/8UN7aXHuD8$
u+N?APYnZS;Lj\A-\*Xr.E==U<C&!%8*>?G$]A7k]A<P%;UKrhdIhbU*h2q8"NkSL6WRsaRp'Y
URuVU%$Q(dtj`_@27+jpN7;dIf6f#n',BH`#WHIALP%is3L<9EsIBiJIUYcL2W21f'_MKAM>
"6#C%="c;dUe98of/A$FVd:pH,HMp"m#=FPhOiKAq05W@?+cp4A#R8Z0)Gj#CTI5^=t/ZEOF
":[%"-[#H?ELSGlUVl5Uki7C8ShZ(1oe0d$56MeK:[P.=#C-!JsRMin;8V!<DJ$de7Z689bX
gg[/[3oobkm,PeIm+kVk=u.>JYTOV9M/.&#r4P2D:t!3:faMeb'2:;kfY<F.A]APP+:Ut*WU_
/b=f_[RZrp?X7W'dp`T\&kU=q=ki&.KY7=&:(d#QYEE3B`,%nTE>TP3h%b?ZfApkZn_Bs4Ud
sUZBA*PKY9E]AemCoD=*:Z@@7nrZMBF+`5a:OOAQD\_U0_I)Cq9N"V39MZM@_Flk(d]ALgn4)m
60R7^CBF@D\,PUr:Xh]AKL6]AFW\HBQ7JZO&`P8XioF-c%^Ys:bd1$!<!pECuofCnf*XOnRX3,
'S(RSFb2C=3q4tlW\ja6=C7ao7C$E:.T-NQJrn2m2[(E;67LTjP?hDr>r^Ohe=&N[Dc]ApiX/
-mT:6nm:]A\DU7(*=?hs_Z28A!RnO#85M_t1&M_^nk&OHKs&K3IfK5.g==[70BL0@boIh]AdF.
_i3#r:b*5O?<"$O#d.CUqUV<FH5bC9s%/>=k."$:gg6oP+L7eVQ'*9V,cYCauU9/1G?'8$["
=M20Y$8iU79$F]A8GXFp+dabtbXo):H/hD^\#PO_d(;E#&VR);Yl+S?N:_&C8@.OL"T//AXYK
"K5p+Kl(c8"Yh:>:>d-R_NMN)X=-*)Pqk*&XP:`2]ANq^L@g,j<hsBRo/NrETC"j1'R_@e,5M
QbSPuNYPT]A*8+(ONj'jg_WJIGWQ>C86^27W;'S14L$VG4cf5gtEPNs1RH]A"ICA:.iEW%k7;8
dSuste:5@*]AMqOT3^pd82fP0`*HZ"ZKE3b/:+!="O^G"/Gj,pmB0@^*5fi!1br,0#Q79-"h$
(gLG?BiI6m*HHBT=<QDE15X%U,+m"&D4^Khe*T=b\*a9$6Y`(UGAZ*&8GT7Pm&=YmQ-fGoG<
2]AEhD@X4LLQTFNa\8?&p(Mk=keW('#WU%+;kHSYE4kF\!2IljNUnF/GmZ'"H[r&-8$[Pp.^A
TX7`a)0i48-+*.eCS+e[@8o8U2m\^f>DN25q>(;'20D09.j*>j78o>DY?BakdBq6ddW:r@+(
Dk3D<7oMlMbY\).@qJrNGlE)'D'X+TiP<@LrG]A4lB+?P+Mn@%+bhcg<XG/CpmJrBtA<P$jaK
gl.LaHLb/1cffFDFTeU-FR+/B<hEgE:s;!GPr#T6#:tgc0082i<^W*qP35:sRe;%66*T*hA/
R;g".&T'VgSm6T-hV_)2si=+Y#;/!=n+Wl$Anm893Usfnh6TRZFsrQ/tua.bkQ@XJ5[%!<ar
ePoTpnme.ilkSn)"WtEU4<tX5Xg"b-K<1D!163rjS0*8F?mFj9$0-7S]A_tO4MCGM%216\'i9
)!p&1h'So,1"m9M/5ci;V>q[5BEOX5HA#/)c!(:gWbX/s*]AEP*V?0GSkag[[HCY:bF#cdhnb
r2q*)7<966E3(-6[BQcJP_IO\1OI)MRXL5<hp3K;BCP]AYDWpr?_N#HI4r-uK5R:=sJmW9*Dq
&1g<u>@C(/e\ccr7+;<b=Oq?1'\Z5$^h<p_0I&Abo;8s%B7V"[J/HPPjQ/#727&a^Q`]AScU@
-.bh7@;0PHc^;+f4*(SJOkc]A;ou1kt;-$J+M^feZeH.0+[Hb2?6*;3'\M-NGE-=S;aD.8U&>
rc_oEc05hf0a4+;X+^/d!9YN"+:pA`REPjgu8^B,p,T?V(Yr03;9RC_r0c$Wo!Wsm-UCj_*e
6,_;L6H:T@Tthd[,;iM(I<ci8t+KebEPW06WE)LPA>qW%nY#N77Nd/YLmj?I%fAVr*tgt-l2
='DNGoWH#:EmW_L_1GkO%0i!l[<i9_+CJU<t-ep`n09C'PKdq2o-YRPBSl2/SeU8X:"oek`V
pZem#9W+\W:ehCR<'',BY%"P?9GEXnrCb;)j"&+N_74U6(j2rEDn[LT6E_H]A/o[e`j@Y2WXJ
<>O*r4Tn*p<:f?Rm:m.JL`!e%VBV(3eP*T"X=4i^"!)b!S)A^VpICl[MJKY`gPF8^/?U+Y0)
Y@F!,-NW54YBPt<OQoJkmdDl+<c"@?9>.e)$QKK\=6U10t^)$Ga.QVq0T:_lQ_GFlLdqtQo#
Cu8bblYDVn$NF$&&huc/D[+_i;e%B*NMK!**0KN50l0_=@XXlF/A2WJORcBmO3AIZB't9*ZP
G-+e"]A)k]A4pD&rU!*2O1q^.@TdPXb*#\l_(e8^@lQ+I7tM<Co;l>^uQ/7nZe4eg([)BSOgCg
b+DmSkk+(CgYse\jgFgm%5R78rqtVq<\@qsp)tj4O(ouJAl3TO?Z1->cR6sjW\oj#4]At">OA
MHpm'S0-+qLkcnu(mM_(c9Daf2Q33Nf/\&3K$(]AUq0'%8pm)o_QB;9P)EH4I+f5l+lFPgcRu
7nD)4#N-!'uX@n\?J>;VLq)c!M0;PA10qq`*"T+E*2h$^"JKG*?ljl5"O9oj+.<r?N#F0;!(
I?pV),'0!5g)#U.8(RQq"nO&Z([OsrZ.Q(AI(PoF@qBHg\ISnN2_-,QN3.58n`R^ht+eH$#>
=)qSV^PkORr>H1nK<:/-KH852U.?.GKUet"C.F+KhY,Q8[oB<2a;L82M(LTJT'HN%S:[LIbq
^Za7]A.Vt/pV!BQ+Z>c.BB_ea<-QH78AU$c>,Kk8_5N[9d_'Y0]A"Gl^eP\+0ChH&i*Su[6[,L
Xj^;u1r4obQ0'B]AJ9EFInj3R)V>q*D7m(OKb-.;r+JJr5<n\rXE)#/fhupi#(l5NGojH,k<3
e8\`!mA/5'?&g!Dd%<!VC9<$Af+d]AZj&sOXQZW591#_"5No!%;7#^o(aE``C9UYO)aY`m>Pr
)gaIVOJDDaF?Cd1@*:8Cj=O>_,.ir&.2P=qKcq,CuF\]A\@Zb*<hGkO!r4o$MsL[tJd$^nc/&
sHbF'p=p&$kPlH*:?mlMk'qXoKui<EkoFijHMa0@Gh[aucGHPMp6gp4[!N(gHrU(W]AM/1'Ym
k35p<TtT6aqDR6rjDfgm@H[3/RUGJuUC/otJsC#"<^]Ad/l-(2>(`GCH&@<p\/M*#VLQQJDM-
JVALiEc-pS8>XhqCR^CIGH,C_9rum@P,Q1G3e43\?ES5lrZ%A(pY![rQ;qOehW02A&F\U&*F
cH<M[tTM*Uh_lhRm:UJ08l5Q(@D]A^"'V'%qRi+['-C>2tH#Lar@-Bu>p=p44-aI_iBcdRf09
kH?X)rh9]A]A`>ImNAq^F&IB:*'>Y3#GcTAc9DSE5Pg]AT<;>`EcE?fsj/'bZq-S[Ps!A@&OOX8
kO9:rf(Ue<l2E^'GYcHfR(TPZ>)f81%OQd$2R4R^M/5e?i[^S';U"lT<i"Esf*o:Tp-:/m+%
9u*Y>\_8\Y]An,lWkH[Xl]A>%`6e@I\r/obUOQ$<DeD"Efs)U4D'b[*21>*:sNaI:p8J6'P9hS
AtGCcF\2cug\:6kZ]A3Fl?Ill.<gBX@kI3H4hHKDhjtFkkmJ'Y]AV&13qcR!e/qbY5@"gTT575
&Gq8F/B*%hkkToi3D+PHqA:eOQVomqS[IMp/)I#?YN<fcn"_1e#iH4#nk,:IVet65PQ?EmoH
4?%/]At!Z7T[ZJES9KP*1HXu?4"%_F/@N628<psZ=9,KUS_D@HJ/FHc2@I]A]Aqoq6N:5Caup,Y
E2!f3en%QTq*Hn-Hh-3-buRurQgHdI0M9!'f_`RN_QC.q:qBI8EM_&%"e*O78#h0-0"r8e?Z
7DF'6<)u`gc@%08c7'Q7\USF?q6SoX3<A]A-X/9uJHVGh_We@qYB5Wj:i(&k("#XegDU$S:E9
gF2blALrD?gCDWlRkhc!O.X*uAlAgNAF?@UJj56_k9G42E:2KMhp$$j?eJ0c!$7=sJWWF$PM
JLT*Wid#d)X'M\_8OU:b[eW<*AI3DcBo^j]AP]AJriNKZ81)fUH?@I+`*l1J[PI?@*O5q(`\jY
loPSo!M_ZI1C3,^3a-b)s:7A=+<DJQ=e4c97$G2KoXcLrQb^i9]A#h/V:lkKN$KAE^]A$@CMY9
X7;'.YSd,+^<%&ZHNpH3?E0M2j%MOBX;jZM>G<NBG0KJJmXL^@.`a1D]AY:KJth6k_[@U9T?W
;>PcYq^)Na#&gq+gq<HgMjP#Gg5bUV96<pj<K'oj0So-5Y,`m`ge=$(1jcQk6&63u5SeYGrJ
E9<ROANi5r9a*U+4]A[@arFpe3g,hCuCcPg9ZkudUHVZ,t(mA5XW:r*gDfnlIML`Vj-`"8=Sf
\&#ecmqUMck:SS#phIBX8!na+Cb:gr!Kg^ak6i@6p_DoSL&n.F;J@>]A.<if\p13nMlO9o3cK
I]A8F=f<uJQZ8U;(;V/q5:.a=`^p-0ju-4s_>DSsJUY3X9SF<rO2TdA%E<(V%mrpSanZ:o%K7
]AgK#o`^==-JI;,A\-D>Io;K;CMQWFjBorC!qL1;1H4m*Ya$aT$M1O(uVMRS*'$r_XG&#O2Dr
mdK]AWVopLU_h/jjTAP+eaE+XgK-dAbdr)%Oc,^@PQ(bBARr[JQOV6-V:1J^6E!i/.Yt4m)+;
^kV//Tcaa^%R%=(/?hSU-OsSI"c&J)O(e^*)S%30Y?pR3\$,3I#]AobNsK9IcoJ!B#!RFhdcW
_7cOl@6i[Iop,;XAYJjd_\K:<C<6dP!F>KmDr$QS269"<G"--gsXS]A]A\JKK-b?$%h/=Me&fg
k[eTh/ilS?4Q`q)m7@Q8Zr%KYeWg3ZgM%C.dT%1&S/t5p_Y/4^!N[75eC;LPM80"2M:;5>*'
q&`EQ:Gbp=t2g<)+l.)qaV&)i6.OY;<jhd:DC9=T-95Rs00"XUb>L#Ah^VH7!_o&>YWe[blB
9[dU"jUe6O.?Ra<3UPmF$`\:u#gE""1&C_>2g;g`bu\&WDH>TaKs@.lGRU9d+<G&-lmi#4>!
^aub&@(I"F]AOh?]AS2BUf-VY;>@HMDF+^kUn%i]Aior/6P3=mfBlY=sA2!,5GhU!_J),jiI+.S
lA8oSS%&DtU\,7%,26>GR.ARoI;<nkJg`HrROiE[MRdc+m;p//?DCrkPn&YMDW\.KYYT+"F!
NE?GqZNJkM59U3lP_Q0NOlkp4crp30g`W#6N=b!SBe7k)9M^kZ6*f^TP%c+''PH)lLT88TO&
a@YllWUUKHBgH1_Yf,T60"AWnmR_=%#\2jn#j/fr.AP;RSjr^&`rU0)+FCmtHLMjt$\<+`jR
mb$<Mnld2iq':h^q,?R*_Oknfh9-;!').GW^8Z@V>=_lEHeDpjr*jLa@?njprYe:C?,'ImFf
3)8=.A6rUAM'$!2m3;3k=+j;$4oXn3A^*'>]A:`GWrCUK8%W156k@<>:>D,iG`X?GdZ4.)hb;
d1c0j;7S.>2[V1r5=@AG;C0\59j2g,$G.jISDh-E1"0RfbgX$-2`<6/S@th?&r3eCcbO!8uA
PqWmnJghsOH>KFRrDHlNt@VLSQ[>VL6s<:&i;JF/Xc>gF*\S_HjdWK_=V118'Ynk)cAK#NLp
ofP.*TPE3-,J+AMSoNgEO7nagJmTuT/:\XKis$=P8H$ED[hje6uo6:6l!8!%M+*(o^E<cF%-
V@TIl_=9L6WVuO*Fp%kRqc%0"AT'\3]A2\Pc`HhEF/>-%75b-uWUR1@?Z.G@@h#c(P$i$JG'U
KR3c`*?]ABDnj>*s*k&N5,u!OEC[s-6D<&Ha[tnBK%Aor,*]AR1*,=ha?Va!7>8`J6CKp2#fD8
.Ys)V*$-RucQJGhfOM&"Vi#Z-efHPc>o,EUL4Y8Z13[if:4h&J7pi,O<n4&1'/q:?_VXSn%+
EX;R%O%g32%f4SieVlF1)aGD1Hu'.Rho9gVTT!^,]A!!^NtOGcIl$;#'5"![dmMj4!>6Hi#A!
AM\:NX8\gVQTm:W>/q%Jt$*Vd(+o;SU"=E<Y0UM.ejRQVb#?/m2SO^iYIj8$)k6:-L@OUm^$
7Pdl"N<O1i:e^[/6P[;!k#3d/pQdr-;E&T`%?sY'RllrZmp:r;6eBH&a\:=cmZ-XLKnJ(;nC
<^-fuugQiViT._Jcm>.`>L30@q.(Am9tj9Pjl6RCQRnplc+gpk$Y2-Zk%SXTSn9&qC)>&dB7
%b,3PIs6tW1o^XkK6t9.B.mYfDbFd>0AihI<A[l<WC?7<F`>N`_<fVliZS7:"SIZ`*,K`B;Y
;22g;'Nel#=ltrP2(!mV'FQZ\CdZNh2;*j:j)22B8WfnM(^4&)WHXaOI84^g_>hIF_S+fF?4
aLau<qD//E'EbXPa=/h@:j7[lBCRFO3#Vi=l8:Y4C3?/PH5J)\Ho8n8=*PI2"WYbcZ6C)-ne
C?R"0[]A2+B,2dPE^'EXLia[4!fIPU8eSs/;_'(KAR,H#">6rOV)P.rhGda0nP,sT(0RY/FU\
Fb:Bk(MIS@61ciP&Cr/fq>u:sNSO35G6',(Z')cEeJ!;A3N-U&]AfdSUMjgHi9jtf<PK#qIcM
277mlb+c>UlbdoC"Q=\>g$hbp@=Ksj>'rKk5ni\EPi/?40R5t#5ooJc94.[[[$9g,(j8HVtD
j?sE2"n1ullJsb,Q/*qb"L$PA6?uQDFY0>]AJY5sjfU<N?UKnZkfM\)%iEB:C#X2p,`.ZEh66
b\H#o`R\Y!SG.B/Wr_]AmColjmG*;DNV6"1oR\e=J#Oi79H,pVC1=]AYB'WNah:-ZVNm=Xe3A>
clq7SlBp4?#F<(.F>)(h]A^<J[@P&!+MIUcNCpVTqNc=;@BPOGOk_^Cb1YjK%prJ7t"))naId
_#p&BC7:MP=@3HhQNAhjse9GjBh.=/pJ:oKr:5[fo4o#=_7BQcS#\dSp\lj_c<On;gP^JecB
JRL4o(2opo\=H_5B+61#ll_I"K`:\_f``;g90/fLuBR7e1_Q'O5YP<DR;!P#_g_p%<-u]A:hM
!^@a%GlEZ%mnOiofVf[j.5bPAYK@&,g,LQB*Ho4`2P@=Aq&:nGV4",#`:ZJ4auLW?C@hl#!;
2A!'P=$_hAO_!JrK'X:eG)F;C7Le9(aIMI7;tEn77Leiq.XA?dU^OrF-&I5lW$T_GL26OV&(
:@pCL/tAn).Akb@f^UQ&IaEBk>"M[)d^VN51c#h'jWWCX_%-9#^WRp_'X`A$T([;h9tf^F?(
]A9+Q1BmqA"UrYX1:=]A1,F*3']A[auSWmF5-@4O^g8W3c$DY3pL)[5O:1OCh8QC$]AmuGe(=4%j
toq]Ad2LKBmgrQG:<jWm2N`fluLKn]At%^]AblMX;2G`+mnjpaI?!)g.7;rqGPMp<+1AC/qT8#Q
!>JuUR7+HjLX'`:Us#'S*:Br>hp%_W?hm:=7OikD_915$Y!,BF/tblXS/F@pL"TV(?%G"cJ]A
q#jX<>TjFd$!G@'`Fi85@-#KqqZNjCUqSPk@nda%qX&cfj.]ANEWK2Y<%9OW\QD2n@g`L(`_k
XHjI_f`B2\eu.'QI`i^,,H`^JH?_.U]AheDT-@`7P0NM>,jPGT\)l7ts+"MpJ/F>*I*fZpaa,
W2BR!3;RI$mLZ`)mpMk1N*Lk'I!'l]A/6aIe'L,ku0Ok/9W%D40KZm&aAg@lC+bp4:<d96i<`
%>aDq^HOXrj(A8hreE/;?gm?@:4@uL$F^dS%\1mu=fa*f6X.I/Vf1hL;#L_o,Yf&mMl8/'S)
LJl0mhfCg<\gF$P>AQ\^RmAh*5m%90u!)H$2lGOodRo:cY)0@r3,@@oN_;hJ*Q<"foV^k5.q
7=kq&S=e03/.\prc;)151V+@(r9g*SCGa(-M=e]A2s:q!n5</[!*!nN60e6uY&KoK%52\^eR.
BZnkQf8!NCKHJ1Nn+]AKDh)!qQs,'?c6h,Ir7`2G'+ZUrpa8#;?N4cePfjl5i6lsZ0Mf4>YKH
-]A$$^nNk:t[qrrT/VI*.<b)Y&>2qcFUF0:L5(qh"`EiJ>W@0iY1jA,o1YdGum"/`ckR,B6>h
QJ(TC:3BSQ*^?;Wa]AOer"1D7?DT,V2G$fg<_GEX$=Kt'r,mcWYUMCG*8_LKNZSTjcFKM3V?^
dD;R-lRr_[V%hs8#t6RJ`rpc9<JonGEgs(nj,BU929PFX5@7:ON(!9`cK>GqdfBke*9KuQ!2
p2bqCO&Zrmoil#aE+#<s+cI8u`N"k1g$jI54I#lMm,6id)PFG*Tt*=ge.089=((mUslmrH@+
)ST:$TQ%Z!i4F;0Y5%(F:B$NiFX?BuD,)\VSV>58?%f(DE<>4qUN4YFYJkC*X4$Z2H;[Q-db
KT&XmcPgF^.2Ohs:_^rr0V2+EW!4=]AT%Ia6rl5-KU;P`">4uU?14^6D[H&`k7^!9="OrFo0q
1cC->Di$.@BDeSdpS)?]A<87-gk2#@VTLNn:e[uYFbM?M'XR<.OpI+1U5-(d@9&9seB>\]ADtA
Ok.AA)^O'fDaUV=-dhnL;e+!ap>baLLUKhc#,<Z/BIAt/*tZ<*(V2ILAZY47eaS`(ZQ7gc(.
_GSB/C4;EC?3Gnn!NZn_;.JqP:pWu8*to[^jI^JT&/RaDZ[Xtas*fSLhGm4#e25*PCJ<b<UF
C-@$>'?\^DIr78[LZ+3WSnp+G8Vg2o7ug9*#6iARWA[DFZ/8H7;qm#rURN30Bq9p@euKO_?I
Wk$r,tp6jn:J.Gm@9A?JV3R@AIO8/JW+W]AX]Aur#)M1[iH6,Ak`URk`rE'+(A%7gFPe_OUN&_
9X(ba(-&,2<NXQRZV-^WkQU\1Ec"fZaMRM<@BEY)R)o_U"U,7N'P^,%+$2Cd3YZZHXTB##2f
]AhcI6Z0U+aCr`S-%H!#Y,j<6<[hgrIR,5()5i:-.PYt*O2G7EFU)3b1q$gWWTrn#UjST2D?J
YroUK,ZKe<LaTAsr0YTij?T&?./$<9k(I"ZJk-3V;3mOk^*2]Ak@6&(;M"\%IY^^)3UgIB8rk
oF&r4\-_>:.:lf$+sPA(=Y@eFY]At^Kkn#'H4a_d^dT]ANC92?)ok6U&eH&E2Pla1Ea\,8MJd!
n=hQWgYl\#8*+Y.d`ekIDA-/?6^mTI4q/Bk@u9O7>6Y>@nn?+3rHlp).f1OOZ/\^O)6Hp9IH
e;8*i;0Ni<r3<a?f'&Z_@"6W<*kB!ZlGc0f4oA).tN<=QWP(r"V5SF$r3,2@#4J,ill;uW-l
>W%%OL2c??ioh5?hO:Mln]A3p^ja2:6uk2qh"LX]A$$#f)U5UlN/0P9l!5]AdaD5>'hde6l<+(C
s7(p0+a^Z%ihq0O;FB#p]A@Iuu2l9jpXc3I5eR^EFEDag=!loq%f)kGd'gONtP9lBceJatB#q
?<`_@KKdttj7Cd5UtreX*H=afZsgnGEfnfTO.;/?RaohlJ'c#KD_h6[Bk'iAeO)P-iSMoI_#
7Mj(t7l2<84`$$,p`k)F+,u3E:CHB!@jWJh8nhFlOR(q'lAs`r"J8"BV/YeK@I366*2k[P+5
or&NP5KGb*eGiuolX8rM<jPXANFaMtI;H1FEZObi8o/u7u5Xn:-.=0cnij@F1QMuG9Ab)os\
_+tLg[g.O>(r;`q"V]Aif*N7AjjGGJ#T/W5/l:r-qs:Y'.UUhVqV8CB!b>bK?9./b,8%na;k&
UKqfT2+j4K3W;&O1o/TAu/(%\K>0XF+fSmm6jSf?=72GAUj`lA>M^d=YFPY'J;K^:V(<liS9
k2++e.LqZq]AUJS?Qhi@d,_$e*,HI9lkOb3P!"h'/^.g4Vm>s\6s.4U7eoLhJ%b"--oLIJiip
>Ng7r#@Q#-c>2e<!8bA>r^'L++IXg,QOi"C:=URC1ShdAhfN+)_hADAM9Rr"<Fg)fZ6?Zp7e
?(XX>p)##QSA2[jEL``^Y\;2DL\bif(^*1#OgUq#(%k(*T_*G2V\?_ZM&K-geWjseYEX&!#(
ds;ZFXT7LEs6Y8+c4KW't02W1e8[1G4:;[&G.Ka9qT!ZCg@pPc?]AdU1s61UDKqSr@"<SE("e
fW7*%e9">'nP6LQ8eFf>_#ZR>Q$j2]AT'-!/XLEi:,aYgSdN\7t`SjJ`+oBb7?!'bH+>j]AtTV
e@i5Yj/I5KD/1D5`)m[J"]Ao%n&%8<(M?F!hp=Zrp!tjl_"&Ri-?rZ@M`XaSsMGQfuj#)*rCg
%:15c.'@q$`W:*/Lsr[$<%#LQ`mtC-!,Lcd\=LI`T.Ii?`rd<o[7HZ-FEEQ^[R@QL56>]A?=F
s>"2oo,.E.)]AHG']A[($\J>L.7dfAF9$^u)C?k7/GmMZhh)F`h+V<=YQDQjXVlba3hQhlk`iM
r!%qNV+_ZaK)a;f<Lo=l_-eN7,5^pQkpHpam-s8FUlR*OV6INph;;Mk(\k3^eFL.KcJX%i#4
kN#0F[g9u,Fa+6ERXI>GR8Y(XPD_>PtD?L'R)JkU*[=NtBTIie-a*7Bh/*G!)mn"o1&$g>,I
OVs^HP&>!h<"WSFXk1AA2.^gbH$eeN>eE$6]A;d\"!n/[AW]A9g0e+2i@gd$.[+rDjm:A*lXU<
c@oc?@bi+>O4ki%3f^ip"g",9_5fN`b'frELHN.<o8o=qNF^`nd"o0c;X+FIQBP1H[S4YXs?
>nQ"?io02?arSEl,8a,(sQK0h'=$6hX\"Z/ho9?Z%.)SGC?*io_>su,VaPq'OWe!F\?32c*$
3auM@0fW);<oMuJ)G"l5Zi^B#+TFIf@k@(@hQ/L.!9MB%=B/7l#C8<We(dQ!A7=p[G$(/Z+J
.S(=l@C+Qm\C_?HXEW&)g[POu^qfT,8PT+_\i?*3(nGA"X9i[k?R`o@F"\+PKh5dE#)cri+e
91\Be#8__I]AU.,!;<'n@L9bo[Uc.mq'n35YN6,J)X#4&+Z8im9/")@j%+?S7ps5%/*lmoE%G
<fO;+F`NJ-?qbV'Z-47G`F/?6CdV38:\O01aXn-4Vo=nIR"`$PHIY,88d6a@:gVUAoegD`SQ
o%hClq#X(h)gq:nSrei7F=5uhCr[\rd,'f]AuMV?!F1e?GOr!]A(/6!7[mmN%QmNjQn$MX!kRE
45N7LW'B6p?9ICSU941q`"%9.,o.Uh,(M>il</G=\`s#?l=k!S?YH^n>IQ;IL=#MfSm/J?23
YkrccUO_jLjUJ*=nFbj#(PX(ho_XAO7PcCtG$41s:*Ka-4J*EAAkKbgY0CeI0AHkaT(Sa.ll
dRS>k[)N1te/Pl^)D\\:/^GhoY`Z?bl0@brD#_Q'LqtXoIJKB?aj<.,aBNKJ`mpbeOa+m'U3
m*_&P$Y"&3'L"[f>>sha?R@BTUZ',B7dLOQi;CHOc$36GS"%S>+;uDT3EU7Z/7%/*WqI$]App
2q0*J"_mtr+OKT!tJ,7'=IX<'eqabce%%I*Sf^QglMfJ4@iX!]A,V.f[?nRQ>)Fhj;J9RI]A?^
_`/8A9pa*Nu)d!&W#EMNMF!LOJ&[&VJQiFPn5/\3rd*(huqWXNJkm+8ANf0-SHm#dV,L3.-j
,Z#`<]A2mR>&<OA*uYq1Wq5WhJ)p2C']Ak*mc.naRh+/jM#Jc8$e*P6;[Qo:s,%M0d\R#V#Z%X
e,T$6Q:)pqS,-pXWVs9a#^R2PIgQo\S<LC_i]AK^'/9kU)kL.]A/`=#k@?VVY'*C(8#%T5$E!B
:mul0#qB%/joEK*s2(qQfpY]AH&WOZ6eD0G9+U,%mbeU'a,s2$E?FF9VC0ie\/ln1P!SuZel1
J%!b\p[r9Xl`@3pB5T1o-.W35@^-.KTf`\%PK#FoLZZ)qAIa\jd^BqG'$;0&@#ArE)09F@9M
-8d=_1.g44;jS["`aP[@/O2l>Q3*leB%%`TmscGe%6O2GD1%n+pA?6.H4b0?S+j%Ca;BSh*f
=X#+dm9bW66,ru!/W)mcOM*$>0Q7V;Tr%F1lUGlK*i+iSdB-e\Xb::NE=%%X>A)B8_2m*9uR
"eGu95,T-5:e$+hAQh(/4d$BnVkRp4$#8IAk_8VnUfCto.mC[GK3:86E":+o`PLkK(T@D%jV
"N!&22pqeA\'XpB3E#?lLgNKnITT<J4%M(uX8(g;N/6,Ru$+39oec_7Kb5_'<2Gd<Z=X,lhR
"RM;rt1.7F0%@J9E18[ckkKVO\.fAdh>fpmMXPn[^>^"SAPgE1J$dKfYir+]AjpMQm-j8(<`:
pqu\Clj2a-5:aqSgJG!ce9@RVf3pJ(YV??L5#2bLOJ+ib4<NV$\!UH:L"h%_B0N(,,u+8`;9
Os@L+RjBYLB3/r=ZVj2Cb3=5mKF3C(r%U<mtnLpYjbYDqdc!t8<o<mGaiXhn_BJQ[8G;R3gs
c`OBWbFLID14A82!RA5%SH.71O:&ZA`Vpoj]A&>riZErda2/WX$k#J,JEgikVl16ZsS"Ug"6F
#?.ll.UjW`h)?%%0n&njS`HPn0&fhPEWc$`U\;-:Me/==C$(lR6`E6miBTU0-<ZP1h5KC[Fq
@SU.NU+ilVg@(+Pl7V6@\5agm3-IrtXGs%2(\8<8G#V1__89(8@7HB9cRrk#P@'m,ua-KocP
Vi2U&l5.()XBS$=$_cOD*&X1FRi>8jj7)TgIG`U.8hnn_)"jl-M?fh#PFj<:8)3$OM*B&hqh
"g_Zk#"-OhH#9A>5m9Y;LoFirq`7OmQa'YeXbg3N_TbU$rVE-c3-*U+h[o0ILh`R]A)De]AFjf
=H<Yf,TP(3erb=#<H_?/*9O-jGW8[r@_O+ek,0be_<!2fkOtX:<MQ^_1Y3*tM!sL96cTOl`o
cQ)HIM>T.i0+Hgb^MHWn8g9D!fYA(9[cTp!/gc:@!U]A032B?<3Y,Yn>krYF\?bp0"J"mSP?g
A,OF6'Za3,YF+K-Od\'8$I/3,"_3G6iR$"]A^cUL,J";t!"H15OgDL(ftjJoe"q5?[KL7E2tk
,Oh>r36bOC,htX]AA]AD<jNc%j]A4Y-E#)CcgqbVW\\]A/&]A/@*79S]ASRUW5DE2"F[W?54#f%U`F
D4+rVciVWlK.;\o4;%MDpZDe(eg?VPN><2?d#m:bbg&fh4!TPq-*jhl,rXsBcb=\daH=#9E3
X2e$T6429"V?ZC,-LI#qh`"X`/JGG;f5f\3gHE'9q/g[g@6aM%HTcASlMJ/$870eA?9QMFG0
-S`bg%$i]A?S?_17t*rZs[1D!j%Xt"(oPW%@8&1[#$1VXq%DtYU$.%X4g5'YLD@\E^TFEXl#*
W9a,GPh)FSCmKMKic4*I7`un(;;`#9`;nK1'B*<;MEZQL4FaQU!A9@#'mdQao[,[^o(kWOt)
4qg.DL,rVboQQA<B+`s8iW+soIO>%oNZpCmHflqq[=Be&E1Jm'J:r@m>*`X3kPMI<;NWZ+9l
Nr_H%KK:VmoPhUEM*MV#%228PIeWR/B<.+/m)k0i_`LjdYGERKZ\3f`?Mp8]AW=I-NpO1O,o%
2+&;Cb4hs0^j)!M)mS9T'i1VfW^HFln54b,i!n.H+q^)rOBEer=fj5L7MUIPmTu;Pp-sbWNK
n)+i!WHgSDbQd9`<D#%UMEGI;-;<d$`e269[DO%,>=F'!ErHh*Kuc^'XtQ4PX;26#85t9j_-
$^;D-'PDUC'I2TVRfJI>9XP[HEK,chb94E-?5-l'[('D:dJeN5Y@:d84I6H.7djq&<?G&*%L
cdMVbQf?L3$Mt-miq@YC'HOY:f..IHFo$QOB]Ar!D4@,l[Gb#.P=,=(H0_9-\TCW6_/dqM/Rm
r&^fIj\P(YL>=Ak0S6`18QZ6bp"@dC$LGup3E?]A:u:"W=i%k34*trNWpQAa%M"i5_N'Peaf<
6/>;1l?mi@>]A%8m(92&a84sBI>^F4%R0%s.Gme18#0Nak`g)n7k$,r/*@m6H`-"c)a-ultI/
S`0PWa"2K[Y:4$,._lq5c_.Z*HT$=OF&IjRC6\++W,QjRkL1I"=X?j;tpH#WpilGBgQT:mlD
NF.1c&VFu'%`g2';UJ-7Q*\m8kT@PE(<u"=C5)?"QfGjsiW]Aps?#hMG]A^Kt4:5r0PUh1^6$N
57P0Gq9uNl-2G7T8mG`&9mcil^KENlDoI!`JT$^(4`4KNgpL_Wh*=*LQD:K'KK[$E`K17ZtY
U)[c%5/=Yb(=RT&8SRlkIuaS_R(ee"nJDPDs7TgS!edAb)Dn?f>4.UHIt?\R1)iA9,=>mP1q
d4\!u[c"*qGS#HFn^Ed;hXXnc_7Ye;L=GB,b,o1:PSYZDG>Q7MXu5a)nf*\SAuF@/a02U'a\
GfDf\5!H0/L"AG#?\if&71>DY8CTPDT7OQRsCtm;'#K=IJ\$D&o[XU<=F<eSSp4F`Kfs2=d)
2;8qpo*NQa,)FrY.5^F8<X-Dl67u/P[o^uB%2[2&)V[tX]A':0Sa=SF+q.P"-BY01\nf'VgQX
Aph'3g:qZ[hFm"]A\s':)\`=emV%#Mgg9!+8(A(IpcsfgWOL?d9C?\u[L$U4m:N#k&(&bfZ!=
@&q#)?`==&Z8q05E0/$m&'($72F_+[k;Xt%/j?Y1@H5;7_iFA-]A#*K'bIl_a=ZeNLZXFQMJg
:p+d.@[V";em`Y7>K3r/glOldC>DUX,746dO3Qdtj9EC5jlC<r+UGI3jE?l=4lim.,-h0r$`
5]A_*'_*>codmTh7Yakr,GP3@GEp2E%g#u1D+D=,hukb<)MV#ERD\g1*Z!YQe?pI[ePV^djoP
+L\-h8a`CB7$X%&O't;*//'fnQeFdb3=s$"9"+"mQ![]A(Gh`YYB4amASS\7)s,#3ULiUU%H4
\S%pQQZ66[)6U\.Yt,PapWPX;B5%c5^)t.Mo$(0Rc]ALPQlqS_I>H-%5;D6X7T=0<g!LUhpNN
X:",1Bgob,?0WMkT-A;^,$)&jN>jC-F5R+[UX<ipmN%W`<lYNpV/r8g?C#`[Mu2OE`9X;ZoL
(g"+D:S,l=J)(oVE*i*\RlF^:U^@(kTVC4pG@#jgTqg`.qVWVNMDkLgR!G7ePXs*c./l:cNZ
48LR-,onEI%E$NqK8JKtQ.O9_u#Z6CgIc3>?J*2tS`/"QQ);K8'EaC+b4o]AYOH2!DDi;lG3m
-asXC*!fh;,\;s]AcDMj0VjEI/V8Whf)eQafl6H>#-H_p!LpZ<%A?hTS_-aA*#9<5<Op(VcYf
0b0?dn,ZI%6^eiUtJ2D>O]A#@`oGD/lf-`K#;J!(X=%=N3-KsB!TS2h:a9I9bS]A'AfIs,Z2R$
9=?fTjslD*gck-i6f?r<fW]A%DADp7o2Q?eP5)f@#(I3>Xe_9VUQ]A@3a3f;An@$QQLs%d2de-
nFlgP1AumM]AWD\.qP;)c$ag"&%QcW3*juPp2+uQIT]A4-=o2dIDV-7i&Sbo!ohWVA&MktGk;^
in.=`(:GmEO0U06)28BInnG<K3(+LV*=Mk25l%cHBS[hblB_O7%gnFfd*0_a3Z;-3[)K_P<,
N-Es8!M-l^8'C35<6`l'&*I_V(]APD9C4tJ$BqI[a`?lU19di074amn1SdCB%W1.EEuF"t\bG
P#G9^/<#njM7>J:T.jjo/jJ_R5&J!HA/e0+^-[WW3?t2aV!#)WtGkdVi@Kl`N"!J9&FWZjn]A
P<WP5uf$>>t<16!lHn4[8X>4'2fM'oY=Z?C4/5OVlm@h!(TA<")@-Gc4q0ks]At;Va7?$OZ<E
a6#LCAQ52;pEh?no')7H8>-tQ#D\hurBR.n_C5CnrfGm4^o`8c/ITJdYMt8_AuM\d%0$D9i^
dRRITjLVX1ilL<<N4Qd/@#RQ7JJCB!W//%)hObQX7^n7b+sONYp[HS@GO"iuE(^'eB$*ksSu
EC"2?&l@8MMr2P=3BPMZfcskeLaO,nfb&tE]A&K)5h)/YLVibhr.cpc4;J%&&%%rAp"D5"t3D
'Y-X/#&[Wd'.IBTgK-g&P1IH\4e^UZ-jr\q3:-ZXCjtbN[Cj<h%B2V!-cJ8nGYdY[]AF!#e(U
]ATJPmS^>t=2X+!lOd^1?/9#I>[)__M3%:Ja08rOp;ghAsPWLGA8:_0G"2C\b/pV,+^^s05e8
Jg*</(8>c)4"`t2p2pu+/o>[Y>K(EFcBl,oK6^3B*Hb>lA2YAW$C<^X#g8fg2WKZC=+>T@n`
*N2(]Amd4b(17A&ZLVK&T":>8-C&916P>7mD$$#JtRW7%Q$dk,S=:(7jTYkYk9l]AfA>YsAeN2
(<>nJc<f3dR`BU[Gb(7EI+W0@N&aJIdYBCI%A9qOW&Q['%VZdA@=):d+QD16*`2A;I-]AXLi6
8qBL,<X3Nc'Hfo0'g3l#]A"h"0V878'9'!bJ$fYuE2D=r)d9=7N$]A2k_gc?DmJI`kp_HrPLYe
AS'iA-'8>pc3s+G/Gjjg!Z(;9Mg>fC<d)!C2`n#bD@"V<AkIIS)Reus6chZ9m_WYlMh/GskP
_JjH5YqUm4q4-6=Oh^>a]A0"9h%N_TONHl9BSROrV[T%s#>#r#p8*JpscsER+Xc'rZS7Z8Sa<
ptr>nOmfEEW&\:)k*\nDA-A$\c/tQn_/QCYLBMPH[M9?>P#,rI;L#Daa&m/8IX8#''YUM"Z$
+lp'5D0eJIQ.XJaVkm1Pk]A:%,OK\7.Up;6R+,6(<fmCghl)Hd>fSViQe$`$#s2WAUpF,FWDj
2fH>AD(Z[$iW#'p:p96GsHr/9dQ(YM!^<;e-GtO$]AB5A/m?<im5T(&AH-ie+YJ>)6,K?H7mA
O;iI"B59dT>Y!Ol,SW.&0O8cM*P3BbQjEV)'&4aF5[GKlr)0CH,q2,EFJ!"n&888JJQWN9L3
\\qn9s6kEAJf4ZO1^c(X1u's5^6hE`(jDgPcEH)tpqQJTX+Wqo.#+u5,3]AIM,)67AiP#'RP-
$T;R[DYrp`Wu\'dQ03I/B:kpWl.RGGS@FU8JdAHlB$3lU,6\\)"#r</C)[[nL_NJ?Ceaj]AII
H2;>kETL+)lF@.6tpCcU0/E6a#6;"lr7i5k.^K+>30ATmsf69:gb[r5cdjnD3Fs(]A3@r$BI-
Sqm5O+"P)eoQt=+'2[!B^5\#P'=Yb\EZtZXF5du%\IZJgV0IgPrZ;,fCp%U]AZoLr78$RGBbI
uh.1[5XCiX=!At88od"dZ1,23'h]A8+J>=,!#bNb;*4*(P.EDVgt9]AuQ,lWWrb59Znqu%OH%O
8*9HEg?6De13R*2]A<tuU9oi_f>M/WkW+C-:A&14$ful+@%kPW[pZnu5X:M3kBIM8TnmDLlp/
,=b7h4=IjTt!U[^Q+C-LD%WFs9=DPd+p9afMb'F0l4gYHH6emR<4E"$)cL&()Ujjc:E]ARe:6
$G*(/(DOsAeJnlSUn4iM$X^:6oi$iL1EG-S5BE(nK[##4ir?/*l.s+/EA?"TlaS]AIY216<,n
03*fZ]A<l_^4(nZ7h//6LhuEV!58^9AH4u@O?u2tnA3/9*I22\.<pU\IAd(+k<6>4M]AR/E3'N
]A3R?b+$nMe2p&9."F=<b1Dn'7_L[*.lG-WNq&OTE\j&oB3t$WB*`QiZucQ7EID">:9$"@-Ud
%^X$Pg>(D7-WSrrZHNl4ldEkSo/njZ%2qHM$aK2-XLuYLaUQ"?q<L6Om^W$_5Z%9jXP(j':9
g*'3?4aEVTSY&5fa6;>a-6qZM\0D_2,pqQDh^65n/KaCGWZbT<SQ9YCQc(qUpuP.4=PQbp@`
r)&<!AWVJ&Oh>YZ^6j3L!3iq6Be!R.I[h2*9>@J^sNI]AJZ02T$Bf!"bF<M_,(0Ds2r"9CHLj
%Ba>m+S(,EBSOj!^<)2/WZ5Y4,!5"XRD(7Oi1$T3hNZ"Mbc7UVSFFsY;DH%;+?0FQu,6I%o`
I:JLTHE.62NPIc!Om7#sJ$\8Q*M:PNcJ!F:*RL9J$6b\Y%p!Jc-V[]APg5]AT$Ts^A6+7RpJSb
f_KcL'A0r_Z9fce]An!8`UFg+^q>X>(:Grh:A#"4N1^cDImU^&]A)4ZT[%8<:0C$nClfLq+.<V
lfK%k\=l\f/IG@A^R>j.<ouS*,G-MP%4XOlB9qOr89E:&U0PGmYJNF?0s>%^e2M=M-"qqNoI
+M\^p,rBCI@fn(X"gL78:6*:\pd"V?U&lO#ERjg]AeVn4tm"T;o)Ahi>Xfp(^2A4RGZXt-IH6
8s^8OV]Ak7bl*TMi%LE_`QT4<@Mm%b'ghT_M9,V4h"\W"!*5Eh't\-F)jW)4ZQaf8(#""caGo
9<!o[c!i_KX:B(0rV"5N2X8U=CAG.2fuV"AU'JX!r>@<WBb_$Q$Y$6*KXVr7FsWC/llGD<;:
!+:s0O5J[2oAlC*TDDh!1-c6t`K5g>UH]A".+)Wun/Le:G]A-pta97VI''?&hb(m[E%`.bAW5U
=Zi.Y[KCjSH&dL[.o=gS4gED@k]Au/G>^_8&gtq>[=<5-+`A1?fH@E'N\,V`f,rBegYG7)4<l
2FI(OQ:hVKbW^8SlKaQjn:5`,TX8`@j&P+=7lu%D0fTrl"=C2Z1nC@2]Ar7`t0C;NjB[Q&BH(
*t0gO5FF7$^(>j+Td8A<<_j10MNkC<&<r8dKB34(Qg=dp`.k#n'XubkJ/AZL[rOIcjc#!Jtg
f_G5$%Sp/O@GgYXut<C24I!8lk"^$!a1$8DabIu.Q_#o)$D9.<4e(e.]A'8t<5C5G.BBp"(85
SB>eT4/Q.Sf3i3K!_jq]ARM4pU''&lV_L=^>n"[j?XO/7K3b0+)VLo?GHqmI)ZCV/-Vst)<GR
*EXM)JA06##b7q$%,tcja7@,GtZW#>tD%Wo8`[NAsVD1_RsYcMHUB82)/Qg+;M2D*PUj9:]A%
cJf#SNU>>=nk`EloMb*N]A^XjkMKZc,YH&7Ud7O3h7A<qo"hdjgAN?Hc5"Z=K$99>A%=eDBWp
-HcKTpS3I:!Bj)?-PO@p7*Gn^Klm7?YE$OGgr]A9I\Xl90;%njc1]AQ2.)XJHOW,;(i@I7BqJ_
AWWH3*[ZAS\=aMmK7/2#oSMW3M*TiCh\pKZX<Glempi%9VJbHDr]A-]ApBSG.BR%Xncljs)n\Y
An_8iP8P,/:%Hojj?G2\k6:pK8m["No%R(CV(0@IggBW_iDq)g_<:I`Hi//p5?F_FMh96WI'
=?4[/-fkMtJZT0Du;eX$2C_kJG_uh>ZX+"Z2]AJbRcQCD"`Z<T)+N&2DEc-8B6CdaEW7c9gH6
oJ$e@ah[*]A*guN(22qD#=(^-Z9-b02Q$N,Xa/NshkiC("WqK!UJrB$$_itXdB-c[NqRI$@I8
q.PO;h6IJ&g9`<c@7j8N[J^]AY@M*s/tdL\:3VZs$C,^iO&7+3p0qne?lC:;N>%0/nN=Sq)uA
UP;dOs_,19ITg(M?l[MSRkf2<[qYomUX&1^"ORD"Ylkkt23On1st^B*bpZSBQ#LBmaH'G7.D
6!9D]A87<jca8(YJ6B8Em_7dUdLMCE`?7g7DK\^qB`BS&8;;TbAisL)ipeQL&@m[(t^HKMhcY
7c0q@Cujq"k(tD[m=F\&X1h_Dm1crX>%.[jof@!LV9&TUu"t9g<<2)>M=cRYQZGFFPY,$c3(
ep)Fi?H*4$hENG^rc^)0D0??e&7<7]A_6"\X<0[<mEIlrmO\0L16BPPf:T_Wf[[$/:h:S!OXN
k%OF1KY\pb+(8`50G&OkQ>#/cYgYlO0k1h3!<1p^[HSr'KQVbnaPr2%*J`(qa/N8&NiW_J!M
B4pqmg\!VW7Ff91:\%jXpHNXo']AT4jGu0%MT?h06X7C#4iXliq)sB@hB*"pP!/?J\lWk%>c!
D)4QLeW+:9:mpmYEsD`'_3'4"5o);h2/"sl-@5+shfJJF6(*Z;O4]Ad9it&c_h<2c6=1\Z'%m
sHj+MaLseuSuaSPL8ph!=p4?12(,R;s:4B8)/R55[)V^#4b"[d!B[=(r<5_I:G3O*A]AGlOR,
(SWa4gqJPEqon9tNf2o2*PDsT;j]AuT?$`.IS3UVf<#<2$U]AZr@#I,8:!YGG*<s.tNX7Mg_G_
VsE=-8'GumHK]A&oa,2!njYY$:-*=Te`C7\PC"c+93-[ag.m;HUlkU3X!=#`8<$oXcCtiG0Fk
mQ9hm$9Quk)kg!CO[?&(<Y>XhAXN<r`:$%P^^5T._KjpN@J2#e-6h"`OIjNP;nO<oT"ef0n;
F0&(GX#+^E$s"?nRnC>j5<h:.N*CrSXDM^^K;G58CkqkZHYm_Qj,:a43#VRB<H7,O9`P.-j&
:d[jbb$T+kOYq@oTVR&99QY\O/]AD3BA-Kk\pqRakS4UAG0_(Lm>MkC`gULR)LcRId\`YrV6]A
e^#%)eo6`Zmce%L)Lu'5hGV.MJ!#>D'8,^OO;s7?m!Yn*+o$2UCbJ+51CM@0j]Al$@WQhZHu]A
$/BZM]A%!D;`[@"\6HoX>5ptdTg/0X4t`LoKCB>sJ^RmGW3S3P<Em76GR"$5e)bYmC@!Yss1e
R%^`LETf(&_\W%7*#;m!/`AVEL$T,d_cYa*12i8[6tkpOAP/416uJ"3;GZ2:\(FOA_?2IadY
Hc)R+3HnGrhjcKSrpDtmSoLK0Ke4GOK`8dTeK>hB5tVcY(RYPNk?NfA;A:k7DH#)9"5.V=hq
7@6@NR@I/%['P>`egB.lHjIAm1ACs39uuEA)AUJ)atk%@7(1"b)^9]A;OfJfhtS'`$ic\?t>u
WoYR6p.[*-aMt6oI;Q>]A5\qV;"r1D1>Nq*0!7f9U/*b*e<cKYu+_k8f`koYnuRK<J88KF'$4
N0Vor]AUj(?]A7>Pj>7PRORp*foRCR^o`f(327um_?2S[jr,:QIVo!?-S)?X]AcG2;.dSTTp^;G
F\WX#p%AdN`q:?p)2?/:Ie%=,H2MR$"j.L.(T5J1E4#P>2g_h"@tI!pLXY=BD>GN(+=g0^n$
[&Tlb*+j8$B)FU4M6hsKob7=XbRS!q><]ABr_IfA!<<#.9i)GEgEM\.Rn6nDDDTFWW^SDp'\>
R8B1WoRP^Hoe^E0@gj\$;%p0<=GrXDu0ZQ22>n+:3Ins6$_8+Ci<n,[#BIclYR!k>#j<O)`\
IJ\HII"XZOlc]A>k'`%5fos!(nCC%d*,"9kk9N;C.e&%PaKC0'iE\2('gWXAYGEb@$'F5rB:G
Lm18EnmngjPM6+M.7(El+?tDq&eO+!0DG&*4rZqNNo:&r,PpBUh%9Le6r?0>mY;^kClf`T'7
Ko<[gJM+ZXaKL7#qt(ME*04SCMu&\&$Q#JNR?br<rX'N?!m5qP/.:?l3`o5m3%=MCc:qFB![
K*KIZrjoSZ$Y[k2%rXOIP6CO:;,OV/Uu&e7,4\3dm-C$UYMoRFeH"R#6n)t_^$pgJl>JK@@#
3U=U*2`,aq*p4?i`==j8[Rho:eE2;<0bGosS^>pB<+;be)[Lo)nphi'VbGR,^bZ\.3>>\@kc
;hRN.^bjpd0"7CRU53,(IfP+T`.'/>k'\o#7%U6LdWiVrJ/ls@qH).8/T2,FnThuN@BVd+lJ
eZ5!IVs7S(24DYUHDVAHTU>hcA]At9eN\ud!9t+_r>mdjLPKc]A/n6M0Ll9O-=[l6sGYo[]ALN`
/ngeN9E!7Ycn0@5o;L+a^Pr+)$u5M>HT"3m90qm']Aa;>/;_D<X+^NQpaCm'laBZ)uo!lj5"s
n(c[4"7Z-F>d@a.oJRl^f;<,cCUeolGVR'g\CK"UXF<(XGg5Eu!Js%h^Q&B#A)`^"[KR!a[T
\nW1.q/NgRE6c`F$;cU292/AD=Q@EG)aUr$pHI%hO%67H<(-V2%m>1q2_"!,`:ecA+lqh_O$
E%X7\L$%K$$Ib09j/D(DbICsgmX6i>TiN3dZDpE@;1D55k7PC=cfPoeFX3-LXmN^]AlDuRG-M
iAP3F*S0[DbQW[l_ajeq@(.+h),K=-4DnM9N9!__BoJXj*%!NIa?Y?41XeM9jB@MY-LEPi1:
2.TP6UrCqGGW-*XL^Da6H,M@g5bpA`SZa9_`_K?&n]A\,H;)@j"/M:@;!8k2G&`jBetnG3OMH
_mUsPg%'dhKPcY9$"-7.mDchLgBoFcs6!El$`%qqCi^92/n4cjcq\D-Q?^'e[HMKkp;Ojj?I
T>m$]A2rA_InCtT/^F+TtAQ$oX9]A3!'c0a\*5aM??WE&le7J<bDQH"0-POj[l)-EB$9Ip;-\F
g<(4BX(;b5RJ>).9[KVTi-q)0@h6W*k9"u':)7A9/l*;K%^APG/L$t>P.R)uQ_VcHFNTXNTa
dh%I\DHbk;o``I,$Rg9Sh*ugG.[QYK7'JR&tH:pit#h0e+GjcK5DT/kPuh,aqeucjE;'-cQ7
7o]Ak[=h[oX^?_tSjk)sI-:?A4YgE8B<h*'UW7KfpPTi-$>UZP<jPRrWBKnM*:"+2Qc1gHorG
Z=h$ak?"F0b2^2VgHFMs,A_1.<rqTbo:J!kQ-F&J2\eTU\d,/5]A5,c#d7-:Z,e3jAJ'J.8G3
JF6Gi"V8&h%gE"igKrf]AH\:nf\f.N[X=D`:nUYZp3:Mci<V&7,a@)_i>@7o"H[j\GtDEp:fT
2h;iupA7Z]A%#QO7F5lc5A#+\gK\7!#GVcU:_1\Z@NEL$@sNER3tFVtX5_nWoWP^Vo'rmLNn"
JWt%]A?d,H]AqSaYLRh._hMh;:/Dj"h!3rt1i&5BDZ+jC64T6illiCAnme1DZ2i0p?nI?f)Y!V
"&bCLF5JEP6\V1h=RTe2CAndbl7hW+BAfBZbZ6+G\[)O8>H<,iHh^M:4MWiuku7p<Y9HT"LG
.iL[_`[%u9*4BbCG20GHHu!k]AH57tF-DP*7\`_8A1R"`Vn2<@^6>PTm;4qgZZXn,!jk&d3$0
7cg#k7j,MhcW757sa_?f9s0)aKMacNVlP39U$W>C/tu805rXe@d2q/*mV1json299KK@3[9,
/&%:8;4N$=^N;%RClY1U`WG^f\o6e;Xl\OqlY8OH@.3>N:$<Kes10,_!"Z6nOKQ&,63MAOD0
nKi'J)98<@8q6g?F('4-nD^S=Ln:fe8OscrY!B1@X@^P'>#^t^qpO+9`RI>?^^iG[a-KjL-*
Zhc!`.4&d_m!J\__t[(@R$_,buNqY#.Dq#T8GI1lG7\_EYfC;4"%]AgDjYH-klB<-[aejWB_]A
"PSM/Nhc'D&=:DV*%U\5%,Fj`#W-2R46tm-?<,F?iWAF`%3Zd!hsnhYQP*)bH.)9kP3;Y:pa
\ce3TBg+d*[&<4dRM^-KdKAW03HuKh'lGs3@qcI&U>_6fdWRb<k\Mc$R<j>I*rb]A7;Fj'<ZM
jG0gZ![IMsUnARZ64)JlC9>+HJK)J^U+j@)Q3KsCEeaK-\;/kF=]A2rIMSFG\LfAmG:Bu?YGU
)DU6p2_D&(lMY6+"M@e@CPORoiVAhc&@"/DP,]AabkSSC0B%5M;UQ#:!lEL^hq]AeY[V1'!X9.
dQknC1`UE<9W#]AQH>Kt1m5IDpfB6VTIVf>n9>5b]A"eHk"Dljb.@d#%c:`hg>0(`Bn0L,bH9Y
'8I6YU5%.U`!Y)`=4j8UG'A#Lb?a.b#=3C!iPP>36P.tZ$4GWTY7CLd<968>$8]A(,E?u09\P
Js>q:`Zg!B?!jc5T5QWiC3l5N+Z22Z#'<VT#9`koYi=OE%a"AAV*_o=N"Jb*$K`.XgHo&rf_
d.a;\$/#CSC7:aS"3PGHQ:,@_OCEnVn_INSlXooO@o^0+]AF&+[pA-qU87]Af6dd#bptGpnAl]A
6LJ,*i^i&J(cNn?,8nnD5<XrGs5T?kGuj/nhnVp4'<5#F6LN<N$1"'f#_%L`A*##qi<f&nRu
0V8\d,bLZ>C2X]A(^;lh/SQ*Z;$R@M[i!Y:.$OeMPl[R>L@4C5SK^8+DU#Hhs<nK),p!<sO'^
==bMFWF)@p?_32mr._^Te+K?O]A^i]AOg/9&`m]AAN\GD2*$Jp)0kI\i;,m;;B"_!,No!m3&2r9
u:m5C_tn]A<7PlHuRCpPPK5N"0p7J3#16)0u$u,rV.h3kEtperDYD(E(:?UXq\_(*=eVS3XNK
LHcsH:JQDE#'VU*=AErJeU=#&DVn&\]AjGlFXA9+7FGLr"^kQt,cXJkRM-9\.BEgdHnNIG:jc
=3UOL;olKO^\gl"%J$mg>ctB73LX(q&qt7hchsMoB*3i]AhJpYY.2">[_a1is.%lAX#A+*BT/
.:<=`I=mrl7?Im'd0r\tV&l`2WWU@.![O.bXoNDuX_A+C3,7Br7.i-Wb_Ep%-V.<u%B<GtCX
##7%Z_8n[nRYQ9E916X]A[U8PUGb\LUg;VE3$hL:koB'7FQ'>TL0J)3R.7CkbQ1W\'?Kg3?4H
-a4\[bkT]A[GR+EIcDSc!-^h)NV=_L>s&E4AlmroDgN9IrY#.!(gHgm3!d[dU[-<qJ+[>+/i-
eSD3OC+g0!9FnW@JCA)_R*g1Fn$uKP@a]A".,?5"lWb&*b8NoBDR)9WlVFn0BnRYVuF3%=*as
/9S!k4/ER5K_\\nDY<tEr"[fr?O)'30"uoJ#1BH]AF0=3_<KsbqUGsYT:574dss@-_E3Z@#rp
XucT;,:NEk+FCcrNYAuqAiggN,5>.u>lpRq?):O=Xc*"23&CpD@cR$2YNX-ZB$>-S)9c>*\,
c[Bi5Zu\)ee)7ZX06GU[D5-!d!;>]AaOSc5N,sfH9"=oJm]A"7"RV@$6F=kp[Z>YPl]A@9k5Ra=
/@I8$F<bGF''uBjR#6+5SNc#<;tKnA+=thF)E)h^?KG*.9U8La`ZE64;u&pB=8L#A)VY%J@b
!c1Y@'53bC<S3-qGQob\J_0)W3+*-Y*MN)q@'/^<an>R9c7?K[)B[k]A"Ikgt97YR%c2[7:.'
jrjNan1FZFDq[1g_W?"S&8d6D+a/p`,^6/blD0[l^R;;O,)KN"igLOZi)\H,AR&GK5Bt&7Y2
9`-`Qm`&ra4h>1\?V5T^o:552Q.;BFriaa+T$FpgQ7(^GSk\7Z#e+`^aUCfrL0W/kpE1GrMo
TXQ<:4\YEggLE&`.bCL&P2$$;6Hg!-X+1;uM29%,ic,$00KG?=jVd=ZdFIsuV]A$kA<PRs-Wi
X:,=+2oiI>uWfiK#TUg?WK0*4sRK0^`]AdR38DCYL4b+Os$(i58-Vf&L'eID:OXamtBq,a"6.
_r7R#)[km<@V(41fQQQ#3.C>Bk5EbX[_OHnSb=<1m9Qth/j.1%mPthiIpC_tIJF3h0%U_)J@
0YLCa2p,L&F;0Q)[m#""\G("X,r4aiP=2TW-;M?Zb;KS;Db'2qU$FrY0!Z6a6Q$L)b.@,Mil
"V96CJ)O3+#0M(C=kg2??W/,@!KU5"6U-aP".I^O:$N!"`\<^cmk*m$]APU%.40L"8$o(s3hD
[`W5Ij8RBjP%Q/Hi_nf"NN^RgRo#/#L#$eA3)Ve9>?%<\i7eP%Mi0a?0AeFP$,KF7"p9n?GR
,]A^U7.pPPB-8gU92meFTJ='T:FWc"\IkAHqB@_+@cm[IQo5rFNelrrrq-MX(F<RQ^a'&p=dO
QTAC#m9-f2&FN5JA-YEk,15a3<B5Qd6NX`4B-qR:;;ZSOJ\\]Aar]Aa2S]A]AVH[FO&M8@;ab\5e
B'4<)<>7oS4!,q6.jo`LM'Z7&6+S#Dqn-bL$@DCVEQ]AT8H=[b6hL[G1Lu[m-u+\tSF^)?G2>
El$[3'OdnBj?Z@.@NiQk$oH<[@l#g,<VlQ++=S5gF!hNMR]A*C:V3ZW5Sdb%XVllCYe%,R*k4
)JdH(a$6t9`>H%9o$pfU<:RfAGRkQ*q?C,qk&L7?KJdo%CU>]A:jsNRb@b3;WjL?J1pa#),o=
7+uljP6trXd^`MK!lZ/bgX9>P+RhGA(^3nU-4Op53ACLOBEtkmOgJd^'nBl1-@G-2/!YC'n4
flP'_+(0r[k^%_Z9kJ(\R20KDP@Bm+U5,t7IR;or/CE0OS'bltJp;Ko#8sd;D)onD_C2D;?.
\h*@Ab1LFkE@]Ac\,Rt<V5U3oEV_/eS;m"N6A#pE@h35Dg=_sDlf06]AT"JOB^H#Ka6-.ucNB`
KEBp/j=3l^%TGdcA.AX5(ZcZ9$\hsT,G-m)\]A71<b2s8NT!DrRc-q?f:\g]AY:KbQX['4-V-5
<R_:2d2%:)73TjNTt/3"6b4`HSH15'(M0cc\1AJV?P-i^Q98Y7'*6E0C/UN;`5O[\7_fDm!o
TtrErok0YsK#)!=Y6FB7*SHHfm0q,&6Cs`>qPn?#3eRfk6"DH7$XNSA'5.aPQauD=pgQMn(K
a<_(\W^7I'EgXlKuplsMMaG4O*;9c`?UJ__$Y<.S07oSeTa4t.$SlbmrPRS@9=qZu#*-iRHn
Y.Jtb\X#M5Zi:dV822tDQJ_=gU/Ge;A:kl#s5J?i<UEMoN=DuYR?W7_kCK.iMb&0JYlLU"8h
>seP!kLPQP:iPL4;<'8!(j,?LTf;U%m4`N7G:FfN#O`+]A,S;"DZYohW?`+E0<C(EVpD?ApZP
q;[]AJ\8%9$,gF$!-q$g\iUCD;Q]A`$PG`uU]A"6HVIq*\@1L\$ku#'reL1hu+MpkcnZ0<M-'Fo
*(/]A9_m,3+@?^k9J,7IA<@HN8d=K/)j'fC]AJFC8m5<Cmcjt,-`V+p`h3'Odn%,Gda1Vs[KG5
/<AB_XR;RhS/OD[&Bk;V]AmDZOXH^s/iRA[VL@!Zsj4Ef%fI#;Mf7[f,j0RmGp0K[[NFnV)KL
T#d.`NYM/7eW`mCIhMdOQk_jJL3mLh2:('-3^5S:p)JGN4)_rpg[QYG4EI-^2eB%d%*>G0HX
jK9QH0KQ&!XQ4'JKc.ki1<,FHV&c@&ju]Ao=C(GMYoO'+2JSEagJD#sFYup.VQVcpf<M+R7uI
#YacJW?-X!Oc2-U1CL`i=OF5NQE$rlehD-BO*Cusi-Vlc(;s1Tl9@FYKPHFLlY6pdLI@L1hc
fLsa49d,ei-_f>42#;gDBXO:4XtmB"cUhPP0;n+'s2EI2!u[,MGM9W7X_D!7:M0i0Ir#3%Pn
M"M,VD)L.:fh+uO)Oh@Jd>2eQ^4Y@nUg'&qJ;K.kEKNtT-i3/XXH-M._iB"gic>qG_/%B[[8
(&4i1bP3icTbETl:,Vgh^Lh^Y8^;5O82IZ5/V_\$C5q5%8AJb,[mFWKr*HZ&:ia_?lu'c!\C
1qZ5\[`:3tetE&s'Eik4B\9+d$298TkhEJ2WV;YucBRp#9)GbY.N,d3OOFa/(g[AkIG2:#Gr
cc*5(OX0VQ11pHQ2+HC<[h%etZUSTh)n#E^`EYhFW/bFjVTNMc^7cqSM":?>B=##O/AR-.-L
L[F`2_)6[.1i`0*e?p//Fkp<(r$`h@=XKp)UMdQ(d/VZ-Or"fEYalD*gDs^Jn'8\+hSfheVj
"-KeM1I!tuVd<orILMfbPe21WOgp*5i+?VKt@MZhm!l0)HF[*2SF]AdQIj=[1o=1_3_QBX,a#
W$;qbtHVP!Y=6E"sBnWeLS_W!>^Ff0QMSL12%HO6gl'b-Qj4]A.p[h*oaQD9btWT:Yi<,2*/b
`3`6mS`7PHJ3!D!]A#qT/)BTXDFRPPot6qXh7M3RE/UDF!m8;kefmpR9e@kd&)pB@X*c&XG7E
aZRsK*TeBIF1?KQ>j^Su>.c9FFg[",Vf0s>#c7nC?bpqia2qk_GWeRFF'fQUHJoW!iD%.\l-
Tf9d0ZcoQ!aX[>%tZY55r2JXYW-r8T,V34PZ]AG2]A5\fk)^m@l]A\+pDW.(^pa<n9hl.[Fg(AO
q$F"*_gG@)k0pp<[gQE7tmT`lkOnX$A@CH?,,&>3gT.E>45;J@FjVrSaG7TKA4JRdednertc
3NoX@9EZ1#-Y>kPO=Ja$GD,LC)Z5k"=s(&*P%ap*a0o_RCI?+8h1X14[7dtflZ'5Ytt(N4[K
Zm)LM2O#:NAa`3liI.&V>(%/&DFj@A(n\+%GMEK**j4T;3`'&*"G<U%)p@KcUgY@=/4K+0i-
-m.po8P[sO\kY?QL%h[LABftO]A<\@t<N]AbSh?FP=OZL]A\Sd9iB(WUr>$b#LO&DfF"4rfJJAY
UF--2Xd[hBU827l/<GjooV;7!crBibs@(Y-Y#=mr'M[ST*QQJSU?+ed3+-'efd(8@3=BenaB
qD6q=:J+rb>]A@+6_4FDE39/M^\@?.j6T?do?=jM;:j'?1"U%<d8D^+M5_4-N)7q8?6J,!TO$
u7=WI&MDBOg,msfMo$]A'Cs42B_4...ILM6<7.]AAii/2pEFicK(,f(/@5V!(;0-RsZLR;;3W)
.O3jU*oTc3n.`MfN7*fE\[\k@Vp^A?&OjYDW1GqaDIiFb_e9+@'+Y*g^[#;Vli5'n8GJmH74
Sq:i",ko^%.21;UV#sF)cS<Z#"&1^bc&K@+D/(+q-<bt;/A4,8&<;1[P]A)\u-3"[5kN9I@!S
ZT=>jk<-a^]AH5dSW4"!@ciVhD32X=FU&1D<bEg3ClG;C!""Q]A&)V/cQr!ar.Q%2.@"ip[gUs
@+WheWHThL^5D(X5Mqq7g8V>ZA;^)+NDN8[?Q,fQFlS0Gt.&I(>$E1ct]AGDHkq-')]A)q(!Z#
e6//`-1AohH_lEB(pkJ(r2nCk&5up4Y7^Y$C9Ln=1klXdrFZ0h27]A56)N%`ckkW,T#j>n"Us
ZP_UmfV<*tP3K:A'W5JE,.39ES)Y1K!CSFH'PZs7>B^#^Ko)D7P;n80<AkcL1Qea0>.3gP7#
GrOfM^\P\+n<:IXoU-,^5RJojV!+h.R=Ih\I9YImRfd)dBrpW%jIh]A-!0hDZCk;-p%Z<SoO_
DQD*4)GId%H;iS]A?,;e(21oD9NM0.uq*aRM%E?Mfi*h?C[-K@6Q&FSK_6j)VYTDN4^Gi7`pe
<L!Kq:]A1P+tn[RFmd;LQA2iZS8Rt]Aal=bcVhB;2t8NQ6\@Xa">cLD0&N^VT<_p]Ad1"Id;A:o
g6GZ%N97r/HF(D>F<Z$.+(CO\1OOGW^crf)aYVRH%Q:b#q8%M7$0#F(:<&.+JX'2Mg'nHf5r
`JrOVlkEV_/ah)mI5#F"plAaLJt/X;GdKpl=cC5(<BP3j2uFMkG\3Y7u\@d1@_c&"#`-$lMN
IK59i-Q#6f#,(pTa_tq/)[T>XLZF]A.]Ae;nqGior#G0.'FJ3["5fY)kcBWDW%9<.lf*$.k<"4
'lY%c#l^`#bt?BijGGZVhbeMKW_*f;`PN<,ra!JCU36UTah0"^-$g!b#*5[F1lA8HV\bfs`Y
68+H(Jl-TZ7EZZsF_3LklG5Y[gFK/pl4sTR`ki@isk&b>\FqV9XL'S:1nXILiVQKTIMd8p64
skeeaj0Bmn0g;ajJ1*_rG3V7Z3$bKi41`^rTMJ&HubZ\c=A$7?^L;"6=k>*Q'U6o^JndFK*S
/E<`g5_4R305e>gp_faO%!G2soA]AplE:$pA3TVtgLiFiupc6L*,DAZeJ5I9EE!,eiJim'C/3
_NhIki(//J<U[,"Qe:SsmAr'6r!F/L'H07f7)lb2o:oGM'*DI9)5_P9Li?I8G_?AZ>6'rkTk
KQrA?@\N8QO9-o(#@V2-OKnkJsos]A&SoKR4Kb0ngc[IFs`H9rGK>ep1WPkRJ=U[c*F+U3K]A-
K$A^A7f[BP"HF&f)"T;sOYs.@rnOSq]AN/k3qc&n_X")QV\V&s[mq0>a#NZ+klcS(P^$HQ#c1
fT'=9_$r59S,L('bfk"$m)";6_=;L)2ZMP0X$Ond&#?,2L:e$O1O<mj`sUYR\U19fBle'8eS
<ak0n#XpX5abfuF3F>1ahJmi)H<>/q:t1cP;``.dO[Qc@mZ'F6%=9ThJgrMajMqb.]Ab0$Y8%
9C]AZ:!8Sb\?BKhnP/lKQ@L2]AoY-ocs`)p/<mX%i$)4-&7?5[GK1gfBblC`4<,6H#dCUc1EIt
_ZSpR!`idVk$=S4<Taqls47Ocpon3pOBW?fFpI\02F[^)8e:@I`UPD$psD)d2-$Eo,n1FJ?<
e#<kn=>:p@<FYmdlRfXX;rtGg>mA^_bWQ48_no1;l(DZf;NT8L6\8eBCMlG,pFMq+<?'`m3<
a3(!I)oZk(W0@4R.?5\b7uc5FG-[ki(LXm`5a=3brZ@1oA0gK&h0p;KNb,c1[6jGlg[?U9WN
;89H"oq.;KqqB+-YZf8LqgGK*^k>ag\,pS]AV70mgIk]AehdTBl,AeUG4D0nI..iNQUh"9\)?!
I47c/P=<96Ac/<2'YtVT3&3l8"'Q-S%DiJ#)P4TE3VpaK.o9NXf[a5Ab,aAZGS2+sMNSpe'Q
P<,&Y>M=A?ea6;k_NKQrU!_hM7OLR,]ABkmL[4M"W^mU;%/ttTi_!3f>2M$+"b`1CjRti1tge
Rn-XNpDqML[P,d*02%X3(SEMKYS=:8"1C)\HM"A$.4Fc3`/fc(P^UV83h&]AO]A[jNnI"C<E01
9?:jOa?IN0qQ0HJmDgcU"(_^SYV[hg>`2gW%0HgcC#JdTZkoe?ce.Y9i)&u(d\Iq$RmgQ&,h
(oG%XVK\*5$!f%/h<'WO^f$(Vo"/\Fa[)S3H;%G-r-.LM-(ZQm/P.j3m$g!1cr=Eb3/[IKOh
ObkAXQ/D>5,9hlKOL^drE9X\86]Amsn_VK\9a.EniHDE!$r`&2f"nF]A"Xec_`Cl6u(.==EeY\
"W[W8m;KrCt5k;8sUT0f/SW1n)is-)jrN&@_g!)"a5kountCA7MOr9K:^k2pWui)fR<2BY^n
k(6%IW+Hp1?:"kI`_MaM57NLWCEE<R+C1;N[W`C/oCT'[d#dnMSVWlr<b4H'i+6Z,F']A*-\J
#045es.+4B&RI&&6a8>#?20oXKrHlO?"8o/oEV*?,m28%^(cgf@Jp8^f63p7DU;`,Am;4VE:
\CDhZI'rGX2B%&!hn-k*TI2X^(qO.?Mjab*0r+l"^B*2)^,[m>e[UI0[]AiL<8EO3h<hB^/E*
mn-IIoI^@rj+5Bq3);*dM03!N\$RFlWA!#?32WWdT_bB(AU;K<<pFU<S=k?\j"h]Amm-sO8jn
Nm8U7Ys1jZ'uo3S*\_S+(gE1f,f7EB1<_]A5E"&e17!kEUV(gX_M$gG^Me.BVtT6h/'%mae,g
enkX>qn,[q[Oc03"6eVo4h<(DN^Y#4S=E1GZTIpo'fC?:1"055:V6R9:LB`TpEms+"BFgrEG
E7(JEI6k,6H<V^T:8H&`($2N=X(->JVH,B\i,t'lj`01@(uIL'^bK1Z9*.tWJp7eGGRMm1Rn
+;QJk4pG!5<h6IQi)M9-`CT:aFFJZW]A/(Wuo<Ta&3fNC9t?8KaK=`G:dpOM^$%hh@g?DptrX
paVG@JskXtP\@cG14u+NI>#[3''FsK+U,8?7n5<t,O&^(@tdG=E0=]ALPZj?)E$Z_9a<r1aR@
0N$am,elj@,?`dbb4'G+[bl>]A2h@C8)@sQI9WG<^qKV9H_krXUNdZ*Q[IA*i%sLTQX;B5ed[
*[_Jnd^!LfRcUGZ&8\s`YSXCc#C8!Ma!bEFtC-J_cH?[cZ\M!'J2VE5?Fa1Il`jBSmG1q^/E
*]ANGG!ptT:gWS+$)..EYT.\#mfD6+2PjN`["=s<hLTDhl.\N9'[S:Xp-;Nm_ToR,'%b*/"G\
3WZtE_.PS]AHFa=m&K"9m[+QZ%hOr5BF*/YA2ecs_SeRs.'hDsX=EW/N:`aicfYF(3._5jYZR
k=G03@RhG0CA;Ibi1(8A3Pge#eps*(>:h]AM^:2`M2q0RaRG+R_K6WP^?(0F?3J\<r`4-ZC3(
gn*p<DsBJ<rq-S/k50e*fN1b3<kaB,3M[QI+n:;8:4V/ka@TXMh<>c;'.ZlVbhbprZ`Y,,L,
APQU@b41h#EVKDmYP5:2'hPR]AJh@F,,3=llo=m[8f&'N_??kt:E@H6+,ReS(1oI&3t9cMYtn
ag#o3P(Y]AJ?!@bOR$_mqd+82NA\0%_<F7$]ADpSR]A-^'#2JaKiM9-SH+<3q@Gh]AK&2W0n^*,[
YWl_7B8*KBe[,Y^,Ad2o+kOD+0ag1WR3YW)D)QhPj%j?7>BS(m;D%H6]A1`ECH*<h`Nh[mlX2
/>p)trO%m_0/*5C`?U8Rl_6hN*6u8LK0[+Q)c&FR.[\!/0^nKpgW6FC@)@@p>2b09e&h0lAa
R`._is-Afm'oh!5qUpiRoJ.!m:LH9WFjIN)]A%1M+a\='Kh0>:o1HQNL`Nmm^!d!dJh-='=GH
KLUb7D<NT/rNpc'gicTi_MWAD\T'XU0Cma'BHt7]ADMQ*p=4`'6?6jd+#aqS'W.`Hf*DN0Z=2
h8,N;-K54_>8RMZX)ig'p\!M461+72-hH&1LlYEXGt$1Y:C^g2`N2>pgP<=3!pk6kU+Ge)l_
Y0WEY'akl9(!QKX_*Ao7&q6?9]AQ8dI?8J5JZH1R*64c&IcV04Cq[]Aj0/H3W]Akq3Gi)@<#!%W
bR(16Vd>HU&CcCWoOQe@J$]AVA]A,miDTrA^*jIh/_UTQKA._P-8#+#Y?mSj^u$\U3*ReCM`S%
ZVP52]AtIGmnM!(![Fg<MVbIqDYLj47AKJ0'.VQ#,<l,@H$GBI+h[>4WU%P:ar,r-S3I8IX\5
@p=u6[-#c=h3g=p*8WC_fl,t9I+8#EH#bNRhPAM8-T9V""(.j5sp+J'd1BU/MoY;O&fg,C;[
2sBcfX-N>Wqdg;INj2!nSD,K4Y^C&phDp>+r_^<&e^%b>MFA&&i6jN+r?[spMk_I'#`ZTJOt
QuQa9L9r,%foUj%srHe_4M$EKL$iTnEcs'VHTikO:;[Ntk/Hd/U.YLUg*+i![di4R.UQ&iJi
&_G;Zs$qokkQD4<G=k&XZ9em8#Cg(q1$kY/gf_c-pT^oG^;ERj['.`Sr.82+6u,-@(-:bd*S
rAl%6g$5FSXeH[]A.eBrJ41t#bEC]ALheTj$9O9PP`)MD/0Wc`EK[#,f"+l67P!kcrhf'0Ai48
Oq'.[a)CrrIU9M;mgJ+ro4&`ZQR<.S)P_hZ<&T]AZ,?US&2kr$s0"%<Bb6<fI*NL4glW#BjMj
:CoI;5VR-0FQU,#AjQUG1tU\MU/0N;7fJUlt4Sr`d1?1:>aF,@eu_<)Yj6$J^tr#9ML#MVI*
WEMH1J8S.-l^#MjJc[P?n;`N-a,XCE`QOKr\d":>)N42L8%=$:LRk*C!e7TfIAG+c=E'!GgA
meS_U>%AP\7h`/aaYV.R-%C6dig-'W?0b`1?9T_X?`3PD?dU-hC!?]A2N]AKU\(MAtSdVmH54d
8QT`6NI/RiK4]AX@S3E%'NWAEY)2i$a"#GeAi]A9?$Aj""aZf<_82g7F;HNMam#;HA?GVtc1HL
(&D`@)3j_b3SM=[8Ru-]A<ctN4(3gYOlj:^m-OELc>@kJ(B%%(`E4EYJb*WPXM%hneQ9h(Jl0
IN8h@jBToV-Cn`K)Qe7af;hH=1:lPM62i\-O\<N+N7'K\mEB%.BEKA&_/glSo[HgAHB;d7Vq
e5\[tF&Y(X,#bi8?h4$:e,o]A^1CmM0G7?`]Ak3]Ak2ms*neV>0QkjQ$5u#Og(ls!Mo]AY*$)&Wa
1':FqAZUc#/C781r6rj[^c=UC$9ScB5pk7peS1"X:8UutB%E3F*/*;@[t5PX,D-`$M(FR8B%
Ue<CDMZD8qE_@/63QeJHU-Q>[X)SE9Ur]AM%_cM(QAm=Kkqs0>T@RlUuEd<fU9u0S#ge%)n16
$M4cmoXD@'gW.Q)?JuEKFPSGdc&0iB:i<_PRjhjsaJgR#A1`K)Z/J#U[+u^2mHDq_)Q/bFOO
WpkU`2Ie,9#O8>/FusgbZ]A+3^EN.G2q>H7#ffl'ION4oJ-f*=osd*[4rueMLK@=[UqT8T)Db
;Kj#IAQ\6aAM:jS6f*Gg4?M,[[qR#)@kn-.,U0%u^S"h;LRV5jL(c&.FQd@H(.2eV;`BN#7E
K7TL^\-oScUt\9$>hmc%iTONW]A!^c9"J%U:7sDQZ%\p0iIZ0jb31T=M4Kp(,@D)B\8%[WHc&
P([c?7hHOs_;IS4IGf=nlj*Gc(LnfWW"IB124:gQILF@lLFNK@#':6,<\$6h4DXOsjJ3^DBk
B'045!5TH?@aG+io5]Atd\]AL$YQJk=$q;Ia9-iMo)Mf_;V$b(AlN$uD.$f$GX9&':fTWai#66
lmuuWdVF>-TADXqsdb><qAGe0Q1QEMo"o1pa9)lJk*Le*H+tkcV*@O^>$]AQMi-I9/@SB%4NC
Q6(;HCjdT0Q,prIGJBK$1Bf$T2L&.7:Vj]AM)]ARKERH]A`3,f.DIbsL;$9rKNn>036X>EGNg?u
*e=ii7sPsAU4?Tc&&F%fU-(hg;/2.XR#WQ\J%"Jk\Q.dK7X6t6S^c:f=:f5H8fa^jRS[EW+,
Q_K.Q<>jhX%U6#Sh]Aqq!VmX:IN;%;`C9q=>.PirO_B-Epf%dG8'\9.u:63Ds9bTJ=f[PgMa?
lk1<HM01YmAhPJ61#:sl2RjT]AIWoWpC!5:)OS*6,E]A`-jh!!~
]]></IM>
</Background>
<Alpha alpha="1.0"/>
</Border>
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
<IM>
<![CDATA[Cq=gQ>AsO+*i#[ig(^A`[4:n,D(.1h<E-(MC8NnoGAC9<fK1ukHW*A4<AB-YHNYKXN1]AimIt
$;Prr,*rf-C=V4O,t=3Tp']ANn8DZTCm<UWQ85a!<<,M$]AV(\!!!TN!$J3e,Ioho10h6j!476
%nPnV8GK+MIWAfIGq/qsg.buJdD[?^V@Amh]A[*QHKZ,gS3'"\&2@;:Co.NpP"D8t!PEXdc!8
"9G&m`9*DUTZ$![7q+f]A&Pi)0S'V2DYsDPF(0#+&bk05i-a6K1?I9qI"sM*`Ni^q14As[c0?
t]A/,K)9qWr:HhJTpM1@(cAg'I3H-VQ``s'-Ojd6X?;/S#o-P5(Xd>8sssIS$+VnWs4,F6=b\
MJ@0.d^T6E!;5HHZ9;onkVQk?7MC?8<)./jX8a)\97P\3T[+5q9CP4dre;j\mAWi.^Zm^Q39
!_!c%"WLnu8VR@h1nS.G?`F`GlTAO)N;O*RDHr-]AB-nXoG#,^?]Ac#=.D0Wi'':iNAEqdC)L;
C<7!Q%EnUIMD@+(ukM5U^)LKWIp2Hs@WUBWt3!Z':Z,%H/R@NE'/:O8.J).J2o+Ik.9jGISV
LRO&GC*e6omf:!'m[%o$Gdh^^Rs#+$PoSZO%Ij9c_0jrV_p7s,)Lb:ph)%PIL58WYjWO&O3e
b8rI9=9Ugbpu_Jq/VW!6VQ^jY_]A5&RYnH-bsWWr/Zr[M@NQs8Q?>%mVQ/nO$[),X_Y<\AWkb
o`QX:ndq+).X4c(rSL1kni?rIBq=!6Y,*$6MYQXMG_A@K0d'nT^jr6%%okqsP_;ae_kpKLr$
U9F[V^Zh[s=,B9$$R4Q"/"%@q!!l8OW9VF\_!-nc/%mV<"3-I"$fY@il"%6tr2kl2C)3Xm,(
)&4ibN$nEWHnPS\\'do[RpZEaqjpIn./tCB/=A&AaQui<<&htebh_cmrH,Lt8?(VX-CsiM'V
>iF*.u)K-YUHYT:VD==YPO<N*X9A)s&tt'6U8E(c*$qoaFLks?D7EsOc$@9s/HT^gQ*6%]A['
dSjW54I1n#WQ\QnP=;qB+ZoL8R.Z$U#bZA2/^fmVijF%?&f*F'/H;L8h+j+d"P(Zr/OIY>GR
r9miF4G4lq&!$QFX!Z#V>.D=1(OOrW=A.mRH0b>V@4S7PXF:)#]ABj\=[MbdA.MpI'Q`h4\Ea
IEe;X0K_I&ibOGS3mCs/Ab>ibnq$L%coQ'aoN4'[D9)Ebes$9(%K5NDq&&E0(]A(UIb6=F$Ie
Tm\ojC?*OCn_Y_i=X6!cRl"7<gA]AukV61E5P^`MIVS]A,LlEbcaS%<m-`-iQ:A/\q<eE9-gj'
FMK`+t3*EC3;`qFj[H-gC"<1C/lJ"C#WC9:eNlKCOUctQKLt?Qa`L]AiD%LV2o/u:#e/roQm%
198O#"Mqu+J*"B5l+C3-qMXQc&<hmFubs"K4Z\g]A@M5h14"4m@b<jh7Q1hV7jsm+Zl]AoXB9n
*]A0*%*8UIS0sF:SV0/\Y:K]AWMn$d)qRstnij(_4IH#E%dJM5f#%F"cH\Wl7Jh_(ET@<EiJ"H
FrA;&6S0OYIZt[f:ei1,DA$s47]APo@%8+4A+T5V<UO`eK['fIZ+sJ/*K)j.K+<*rh$9W`jsr
\s4FXd\\7Y%TGr\l9A:*-[LQcD9GmBQ-qX<??_<nTYuKF\#_4i8a2BLp<M;fWD;h&</!c^]Ad
eb(A>l+K>K4@JX9R>HS_PBZs>@!2Q?H7`WbT1MeSYT/J2(cT=ME[7!&UZq^mNZ+2i<^aFgP2
3hj?Z<=2pO.AXmcJh923^qSKtDSO^Uq@klR4E$a3W[n%ffX#,V-.W,B<m*l,"1BaR!O=4ah'
MUme9$#F!db&=kF^%I9?8%55G<FAk[&/lsT2#MaO1,eG[F+-N[B7TV0%ertK.VJ&:`r>a9dJ
M@`XLK6bclQ<"jAetW9bg$A)L-I!]A&blfAWg7L;gBjg)'jT+bEfGG7hiq>0LD[^^nEUbh)i!
"W>IR;P/S1ojU2NP10.i=c'p'mFmgh=OG.6Q;p"-'GN8:fU7Gl.Jc\liag#"/Ya^neCZs$bX
-Hf]A+ob;j9:(-/S?[4&%`T&0>?Gn3r^$VV<iTmG@?%q#]A>6E5n$g(@>%`-7Q,sDb%DCX^&o-
7!l-n/39Mm2$Ho8t7]ARKB^%]ApVRij#(2YlYAMfbpRKh1'+p<VV\"4b4o)a`sc_L4U)h^a+`u
afqsIjfJ_]AaJ]AtY\&0=PT)&93B06,b-VfnC2n$nZd[=st2RXlZ12XX8dRt.$0BToP9`16a)5
NOpa\Lf1Wm)pb(p$;!Q"c!Y^,a-"A:=`'H0(4\iaWBI.I/O<-tDs\d"dW$,(ds%A+pVmIU+1
uOLpQ-!onW14juMfGXeLgel[<DODS$_'sk@BH`1[K9@bIPFX$[3O-BP3@IcldM?-jYCGf/aB
%arSc1^?*E^b2\"Hmu+'WY`gWde7t+.&CjSFPuR?^M]A8M4UV**CE`qkEe?U>O\_gIs)"Pf)4
*2'=rS>mspn<<[;Or^+ba*Abo?]A;InlGJC,*D2g!%M]APBK(/72Nt4(A6XODgBSJVGc2\)_Wl
fAg\tZ/\e,nX="b,h-i.&&.M4jkZN[%Q[%f<Nu]AJHjrZ]AaQU_;`2038%_[2F7!>?CG($p(bk
;m^kG7%Q)*7nH;LJokrK%T3gT^n`DRVX$G$^^CQ,B^&p@NmYrBR2#/H3<J9uJ>=d3reEn^)j
NG_c+:<ni\9iPQ/R`"";^A--AE[D7:FC]A4kXBq;Nq]Ane2>>4EM7LGY:^Z?NZLH=B[Q'^kU*U
fX=2$9=GGilOq9.>\'_1$gLUnB1tU]A547&P^7hN9C6JlFH"tP2%J^$7L)4'\o=SP+Cg=<qjD
S>o#3sUdriIj"P]AYP!;iV!;/aZnX&o+=b21X"j9kJ#f+PumE3VX0KNi?jS+ADub=ChWS9A"M
NQP93B[grTKRS"sJ;+.aELgmGJ$.l3EB#A07Ygs7G7@Xl/?ok_re&egm2`0*Jjk)N?ae"/>V
4_;qTQ4O:UqgNorM$K>(VKrR7r[sA\4XpCX&\iD%2:B"db:VBaZ9Rf1bt("C(#(YKhRNS`BM
f761h1\l2<E(mOAu4\)d3c3f$`f[ip/(&ot<qY=\cCT537L_sk3eK!<S!`'9KOU"UD0"TL5A
tS?CqE5um&k`R'5+)jHlIJ:\"2,X3]A80^_(6QI]AI>1mk&u2-r;7.NkgHe*&q$o$JHc+hc,q/
R`/Ti(4*%opCDPY@kpTkIPK57e`TEegB1>9)bOL@I`crc:]AIKu_Se(;GoO=I"rK:O^BZRL!J
H0_5Oj4>`lBciTCld9har^(a+f[^F5Pf".>[P7MFaaq-Y_O?LajMO'>:#hG[/&1FoVs=o>I^
51$"J*QuX+bf6!l^ermosfV'gV'+]AmO]A>Vt8g/VF;l)pIr&M,@.D?q"p6cfQH:3V`Cc\PED'
Af)`WV?8tg8aA;]A&LL+Z+>Z$\HIE,7s*,4j"P_=8-*]AaZq><Y-.[<$AS]A>)`nVLc2d)h+NXr
m'ON-/0F$2$:\dj%CK=*sSa1YKSOh-2YYCFmS<Cn8'[%")tJpL%#7L>fR,Xs(X]AmYf#sc"#W
j>*41%-mWBHB+u&Rhom9s?%a_a1:b;biI11rck7h/==GOhmbMpU6)W\T-r?-FfCd$<urfjRW
I_R_Y3N2Okcir@704p]A0CStn.]A0cgh]AS/Ok=6rbMP9pm<ds$`G;*SZUc7?U=*MKD)hR()TPh
-IZj5Grid.`8u;R.nn__1Y71KF<b2blg?g&9Q#5DhQ$oTf@X2_K,YM*BN=iq<q9o`=@N]AD+k
L7)=JS$*6[`$>uIr(!'DK/:U6mOq;j>J3a2Y"TY%p!2^&P+]AYC0q;50rI1W3Xk5D_Q@G^q-7
)Iuga2`E"$go@eBUoEVINhEIm5n3q[Vt$]Ae3;;G5#m+H)YNR20Y'TUq:)<:`VQ>%!_0<eR.9
p21b_[IomIP^9UPY8Dnke$'A$hcaS(HI1RkC"?hXBZ8uYcKGfD7]A\t]A%5Nbu&@RkS`KC%ZXR
2biO]A%eL+NClD_8c;RuEF0X-f]Ap89FE,quVeV7WC2"1t`i@>l2%4aB@s+7:BZs%3qfQq]A"\X
Kg$5O,j7JB^Y5dSF!&F6@gH+-ft[$qZK7a87@6*`30q7L,Dn@4C@lC2HH_kk^Ah>SPhRD8sQ
[qE/uo6b;5C>8/!=+BWhnoDR!P%WOpL$e8DW4Z`uX;3S^j7]A1lKIT2?-c]A.78&m[RQ,d^%WE
U,#u3NBpYdHMELok-n&IsL:0[VpTq]AS=WuC8J]Ah(;4AE)^@ML')uD=@]AG.F4%Kh77$VkY"sp
66.d!j]AS!.s!'!i*_[=IZk8n@1>j*YBk"`\HBgd;TDQ_C=NUYV]Al8((2a2\*LT8p]A,B$j9Xg
DVZr;r24h':oOhI1dV/!V9spo1arR_iN">^@[_#CMbY(!=6M=GW/?o3SmYXl@f"!g\1jc0(B
nN$M4^4gTQBrb%Do/,<gE!bG7sW)ef)0cnauUhOF)"j(?O"m6G4.7?d;XHfi+bCHP9Z?E=YF
L.GUVAhjQ"J6SlO5&`#.^OY3qs28bp3"jBG1iMY8ZGF"Z3S]A$j&;.%%O2>d@1pe/.mbJLmEX
2GilcaK.I!2H+P-N\%H%EW;*\ll5IH'>?#ppjRNk([9a+)GKh/&+-0RdpBQ4I<K\_N>3gL\U
`pgQobMm46H<YL\?3IRV$@f(Y!AntJ<$\k0U#QNd<XaDshN^polaU\'Gpf]A:_T?N6V,4`3Cr
R^J@G#TWTRbsq6,I]A!f$'3*uTbM:NFkhbu??g-0/$c?sEeuFMZ)dP3T_OKWXU+%k&qh'A>PW
8)I=_j&XNZM&aS\,8Flg^jK*`L#i"d]AWs>N$4.+PAlNd.H==^6ko-#JGIhkcp+%'7Z8;LZpb
1.]AdBs(fi2G@G2YuF?YVmBt3Kr6IG[Q7":=A&)rEk%1lgUI7jY=B_*eX?=a3HHe^nqkH!O(e
,0%.AcfcZ[tYZps845Io+[X[3p+r_[h^kO:e((/#NRf6BY=R3AnW]Aff9#gh.a0\+!TG_N<A*
@tebP$6j3AO"fLd)3';3u-1dg&CDF39/PXQKaSGN?WHZ)XP:3nW9gWR8?>LDDFr6oeWlN!+,
V+9Ek.nVB]A("'iuC85!X0!nd,rfi(<SEu0<ii[NLZFr;;s7q9$'\mDe)0a`p`-EiYk#lR0nZ
G*VDrk!!*ZG%r2@67jM]A=KIqm?=H%%.>i7PRZk<7pqlQk!J(1p9p49fW)?:*(C6P"]A!NLIP7
3TBhn5CN;t+e,;VsGmGWVCU<@oZRZ49cE^2!Cp._@?WEchA<F6#oGA?ckaEORWd@i'T>C-0\
6^`OY)0=OLKXoCI-[5Q:IJZqn-9Zd2ec-?p+oXk9&jsQcj@I.n^DC.Zu$^2dI9)md]A5hMHc`
fBBii9(`fi7Jq%pk;/<Z5FrKX64h>4+?Fg&+>m<r@1_<Mm_$8h;L-sUOQ,bBA+Qe*L(5LlDp
'bBH[9>p);qamqOR?Y^'m%(@`H.EKG+XAMO7`VdYMX6=`:bUUqR6EIfjSo\(n=Hagh3Y``$V
h"mRB3iLCItVM$.n`cqCX@=>eAa\*<isZQMpH]A0e0"jT4V[pn#M1r.j!0EHR2`L>(HGOg^*k
GhT!::RrLV6S]AXk0J\S;;L>Y`V&<+\b_tT0<__%eX?i?5qY:I?*qRcM[?*Z&=<ieU$(j2XLK
?>@7dl)B2+EZCjf;EC`d5at#mZ3>MfS&I'I5[BdC4XNpL#=HVgja(qn+o1Jk&S!%1jsY_WAo
#ArA"Y\U?A_2DE@tIf_Yg$Y^=oE+=7Wn0)SWCf`_GY(A+Y^]AQdl!lHdhf<\j(098":WV8Pgo
NQYXu*>V:s`M>G'B;CL@kaSt*K.362%IuC<G"67>br)8[T&f3D=0<!mZq%;Q8fa8ZZU['MV#
3]AeC0$Jo!<GCm)AE?`f0]AqW70+H2Sb"(CMJ`Z=[XHX]A"B4tc;VUjZOj?ntCQ#r?3<F&Hjn)s
t,W>\2Gu=CN+3>ef5e3k$P@ca\:7gZIWh#Nc\8;S<2(Wu]A[[kp<gGt<VlacrfIIG]A]AN,!j$f
t^[`7!@Mn-6ssjrWRYh\;jQ!D<bP,Ba1H457Kq'K;aFf6_$Zi\_?8R"SO*9-lX<k`<@o*.[K
r9Bl<b5:V2VLRhd(gS93F/-lJ8S$lT5;,&Oec&E7uO4-b`aUgqH@o-?LRpK're7*.rZQ#BS]A
0(^9/:.9g$@8li%PUedicBhk:pr)B*PXnEnp\9hE91m=FC*qV*.TrJD%"?\R2.(.6PFVVUU&
DF$5A&!\C"="d,Y-Oa9t9A7OZXf-fjR$#gkW)'YF?r(OSeCtoM)j_jeF9!]AGtQ1-dqWV&H:h
"j3VO9C+W=aEo.VUOrtseHafMm-msCf^ftdN->0)@Acs(R(&V$(E0PJ=Df+IhVM_)iB2@Wr;
Y_\&,<_6[Km#jT%H-iLB0@*&'CqnR0g55<,Z\a<UdauN!S;qk6="B0-H5iB`b&sW.^C!O@c-
W*fC>^oUtM4MUMi0V8=DB4Z);BOXi8!rj2SB`eHsoF.48JMSBE>1b4-YLSggEq)_`MBRoDjL
TT05+BNngA>,L<XX7O.):psTVSAh2Pg16\NhS`:T8+P#%:MWDK;\Nq_H#Pia-O,3oHD=hS`I
Y6*o1s2l(QAAe;Pm8&,73*CIF?@p<onW&[1he(B3UM#:touHNXhSa@IqC.eu=TC<CBQ-cec^
./ANh6g(d>a(.]A-"rar-5b0/(5m5-FVIGE%IFka=Fc4b4a<U99@85:lG&="eNI1LpQonNu/V
j(M5'gu=jMX%^jK^gqVC=VR9ElN=*6c.CscZfKpKUXa"T)V84X[AJYBAZ:_'@(YOV576$i(\
[E4ZhiaWj+gY>9>!r^%hK_Nd^ST4\#)@8h[6bL>n9ikDqLIA*TS2D14#2D-E+JqZ]AR*LNa.I
'h9oSHQE!#>Dn<a/:X]A,p:_,UNjE'bWM,7#g$(fH[@R4aVh"egNe#;\&`IOJ[kSP<TK"PBdZ
KC@TMP\=i;1i^=q=I^/*9G`<7o]AP%m"K@\4uCqc>DT=qtY3[m:&Fo?Bh26eQTil9AoB4=)Sn
(3b9JMGP?.f,i4<qrF0t/5<`:Km^rd@X5;uf^'eFsBhK<_1%LHQ5Sf,lA4"D!6WUpM<G,BBH
Qc`Yk<#@!]A=1>g#&j,=EC%!J#+aW.'uq\p"roX)%OkU*426:<b;c=1^d@)o,8\63q/j1KILO
&K8#[HZFcn9M5gF30ILX=*0P6)\!Tts2^d9W[iDOh\+t9'86Ks/Mb]AU+^j;(f`V53[Z_;MEn
.rl"u_@?99]A\J'IA']ACUCsHs6j0HfYpZ4;859sVhnD^[GjuL&tg#L>tRt@.*0@b4"Us>l2&G
bJZroCAOipMf;_O3/gaZHE"@OnRd'MppRggH+NVLmT$(uL?L'<n6K\2duNUGd9r-6g$MV+7U
XDu09SYuQqW6,55Rh\UPI3cX^6Z7O.[41@%@(sW2Q%DlVG#JTZF.pp"G`m7B=P+V#UPT^a(l
^!4PGIig$HB((7A#1h*9,bk#gE@FTRPat=UrM6$j<b+@<^t8rTGf_9(ESXTbq]A&%&$<]A/6j&
o<d_YXZq.WV7fVSG:9^LE-fi8Nsa]A5gLq@;+4\,!Df,n<QXKNm=R)"2Y&T2:H"C+Z_dMZk$b
SKMQ%Da6]AjZaM09r?-%f9J0eEIZ!oZ*Im5o^*SqZXu+d]A<E%);Eo-c=mF6EQBC5<VC@WNK@f
YrH.@^&Q2jR,0/fQfH.[YgqULS>=`Rj\T=jaE2Z1c;Zi((u`'g+(;E;2M%9I_9><S&+s\\uE
]Ad_P/b%I!X]Ac3sFX+_M4gM.[=<?m8aa_c/![Mf?\Ln1'a*hE8/&1/^&j]AQomZH"=!Zp]APaZl
a-Di>tM"+QYZVVfnK64SWC4m>60U!s4n,uUR4rlkHfK9rZJr"ht,H,"=YT-HbuG1c!V=ASWW
K&Q+qA-/)g,iYb'nqZ&P#m`?+rG>#7gPT>1W-@8RtW)W0ZG2Drf2kfCTsLk:6=Ci5C,XQS_H
Y/uk,:)@iEI)&%_9"\&]Amm/^+$`OdHpFAcT\&Wg1Hm:X',k=09%Bj8adCZj\I2-S.h+^#94d
8<S_J9<;M_C^%Z_%/r:9>26iDoLuj'o:l&CS._M?uM2m4)NcMpC_GK[#W%q_I/s<Ag:NiE2#
:gf>S?^XHQ)=3o!;Mf"IJH*[+XF$,u;&^+V(GrP"L.S?nW/fHE'>X^V_*H?1%_Ei4kV2[WYb
h<Q0XU:$@0g=4a4ga60a^2TFqV+n#42,9;bK@qP!MeP]AjD2Ksg)%D2MO+7/[pp=jeqC042;a
&GWm!PpIpjJfTu!N'X+)(]A1!mhgP@>-_b^BfaY>hse/8=#07`/Xc#B!a@.aE6V/p>2rY[QTl
$FM7iU`JhRH%Ht2l1:S-=VWpF8i.$PC<7Oe?#a*LJqL-#2YN">^p'iQ9mc]Ang!rs3MWDi4-T
2%(<r>p^C#g<s_;=eZZbartB\<L>PU543O6?-%)b.L##=WY#pYqJEFFUa[G+1)*4DDXE4qq(
:c'sTP=[,Jl]AdIC9Oo/EFF+8#Aan=uL!XE`JHUa7,#B0J_*]A]Au<[p5`qPC]AOE\>4j@m3DIiC
R%YdHSlh)f]A\&+=E%<]A^$7Rn'ONB%iM&st3QM]AkSB=8!P<bO?<:cIlPJ#0%QEkdLbgS)_T6s
Gj2L3b]ACf$X:/7k;c6hmJHO5Lfa.ot"=-,biL3N/"rH,M5)dU]Ad'`D7b7;I*Eu:H2<L^s*'r
V:AD'aqV3XDSYr/38??=1b5]A@$KrQI*RK(La!QUj5HpLO&%8!g7]AgEPL9jVYIG![Y>"Ffkh9
:;A4iE-J+'[:E70^%;?0`aQbLXP[CV]A*tVKQ%7&]A&XM"Rp).O?fBSKkSPqK);t*^m3Nmq0Wo
JiFlY@i*+NE&=nMWBX^61j.s1(gDaSga"n816]AXKrbJ<GWX5Q!4#:Xna%pfg^%AHu=L4r/+K
@HY'T2Ws82e2#ep,OoiFS^AZBqRJ/+DY"VG-<Kd8T(4B?212rXVA"[:273Jh<:RpBYA^:jVP
_sEE]AW>Drt?3@2c+$-gs%cf7ZQN:_g+\6>`mdGQ%=DbJLZ;j<[!o%YdCi>-2/(R$3Df>iS<Z
j0+"$K@OGtce0&r/U&Y$OKguN(%i*CI.N+WKiZ_]AmrX"Rp=f2uZ^\,a^9-ND^Yj;iWHJPt%l
kS9591^no9*pjG18RM'&[^GX*L>0leKCtlLi2FFq_EEB6?'hCj]A.GYYT@R:NYO>6M$%me+-O
eMREqBp'E&4RJ\S%gd`tDCue#<Eb*UeU-:Kg<:W+g8CX'g2S]A>^PBs1gYHB4cn\\nHI!W-sV
?dR*k&B0oe6@V>56Ai;4)Hc5cUD&"aF<,L:/eWt>9[S_!Ec>.VW5RN=qD#<nQbV+_q'rSi>R
[GGnfW(M9fWqG3,$hS1(#.:ao0DrD^=kUS11bI&C)Bpbl4o$s*0CP1HREQ1mCo<V4u3W;"qW
5a/tK5at%=8Ie6;dtH&a)8DOqo-bZ-NokZ(U_G!]Aj#SK>p5GM1(We3aZq1ab<->:F2=b1i5B
Yh+:O2@*28/Yi9?HMgOKG<;j,=]A!EeDWg4:!)0elSU%[=G\NXt++MS*hM<VA/P15=Cei10p-
9=3n_"bE`rcnSEXZcEB;k`G8dGP&#LJ<;hbhFA;>ULJ5i8+#<6E\j[XCZUCFi*lLK]A$"H!li
!_[gi5(]AMP%W/0VIsE,a34gI2ci^dILC9:6%;+i#ok=O^FNnXZ5/sLGXuQt/2U7=2TVbgRl,
#cqh:g2BO%kb6AG\6c[=Sq@!YL'WB7`EbCLofVqIbiV-=M2;!Wo_Btu%GX6bFrn?dDrZc+?D
Z%s^2`abCg<`o73nnWTFrYHO=gNOCrQ";r/8Y6e%]AnWSk)g@/m>XE8@#NkIZilW&i#K@ija&
ZN>=*cLmAM3^*i23)s%mkH6UURV90.5QaE"*K4\:o?Qq#j8s'5+*gY1H>:H^hjF5M>?J^4ip
b,petD2=+#gT#>(7N'c2XY4.R!XC;(iQRP$7&G^QhVaJ/=rt5_eJM:$#O*'Y0/st_j9R\mgC
4(VRp=p"9#u;dCoZPo0Elbg>L+TJ5s/I"lB2$\komK$)N-WX6r<(FofnYN/P8CI^InJ+MEHn
CAU!*E5o'5"@[?[,Z8sTaYc'A?<[SsBDi,Lg-$hu4%[IO&XOV!3f)t\@0%iKZY[3Csb^!kod
CK&M4&r[0$;'Cc.rGkm924?cd4qq2ia)K.QU6%IQQ1ils$pfrQKN48eEjh7tis6*WH6%N:DU
L`Waj`a,`q[S7,U$Q<TTf9YGYrt9bQ0RO-*&F\g,:0rjPgX)8uka"2U77[IQ"H;UhTDO;<h<
qP[m=,L\W=&?/EC;XZ<FaAt@l&]AfQS44!+UW)?)a?Ede7BD2%&t@]Aud#pira)k>A@+,*7gaT
2ic>\N2*Z6-_gq2La1'j871;/QKh2LNpF,n.X<DeB%]AQas#1,B%b`d]AW]AWse?q>N%d/`k'sp
2'/,)H=4,[i11+fsiU2,:?Hii-PKlEWjFl6!),t3c%NM"XS9^uq51S1^Is'*]Aa*66ZF%,A't
(7O>PMWAlcJo<g!e%'Z0j;coh2HF?h_-+#=hqmW]A,8bU'oG3FHZpHi^OWGd#>?<soKF5GZ:"
N_g!T:`!.<OkX=h*c)_0o<&"qh#/?8PUaia++,3K^/<OKhhQjZ-UjH`psnpX_,n=AR&uZM):
9rPSKh;9C7H6CuhbaP*f1[XoG'285n(7QPTXrd+as:jLU7=NcXoJmT)noP>Vu)ETAYT2jRDO
h`9_(nF3KD5I1s``_e(>9DGS]A=\R/GL:fY@IqqGDA'oL$X6cT",/K6_&4p2l]A]Alc<Tpb0$U`
YLSV)idG-/)e=E)!2j;`r_647"@J`s:?=m>J5k@e4Uf]Aefj]ANT[u-:S203YJ=EJH;>0b)K)%
j,mgJ?Qnu^9)(0rARBN9#Y2GeX]AC@;U7U2QFo56rA&:]AL*m`&Bls$"sj*]AP-j+Ffl3(Z7[0@
VP"I+"NHF\)'@>=dlS(=RlaZVoV!92^_R8nS1iT.f<LV+*=laqo;"P"Fsl4@OG$_-rI+pBUG
mWb-oO<pLM$LmrQl-p9JR1W0a@gNqCfc%G"pW0bRbCf/%QrN]AnCK6]AWeJ?91J]A7_QO"iZbCa
Iu3flM_:oFq="k&4>]AeqlAP!PPgE3g<DJah]AOoH;#P762<=iRH3/)HnI.Sr4h&b\4AfHC_VV
LR\p>0A7qr%DPu1rS,!Q;J(7=74^Ll>?_$rtDb;'(9m3)g(K9&:b:/Y/3TXsVuBJD$MPNXJC
*4gF^VdT6erg3$pd^?43Hk`hlYA.+UTku@HBAZY6TZ<'#&nu@cp'nZgN8F)@_gJ6TUCjI`o=
$ZddlH9ne]APAVeB[!c-@\KlS$eeK21tIBS^]A6S\I*J`9N_0i\Y#ED2!+oafiT7t:U&:W-(7)
XG%EBDr&6>[j2\R\IOWhSbas'3,l/eGWZM8A/Gl1kFnr5VO$qD`m7IZBGFI)*P8XM!/7Q!R9
)k=dI?K)`o:%DF2+HR+9864Y[<,96NH8#(C@"CC#XY:0U)K48Q2A8OV"49T7WmIKIfh&lA9Y
U9>!:',+kd-K=?#Q8'Z0%WJ0:d"X5bq:_53,S96e5$9$hi.c*01(Z^1q>F)tpb#Gk!I6/!,,
'V,ch^#&^pEo3q,9!Z$3c\WnI.0ZQ[`)".@"BCArQ&ViUn/hp$H``!nHH;uaIHl3cm*@\N:P
D^(OD2GXXSp""3m_S+;F.L98$@b+a]ACEBn^Y4(_7sSSm3DtRngSmEV8(+&D?70&>=>.haLmK
ThqhNb[W[H&BmD)QUaB8.G+k4odiB3tVs-9oYI!q*,$[o%;qi>2fbJi5Bq1\l'@@05:HsF*,
+o)5!+B6d#m<Qm-N`*MAoFtKgL*pNa`E?e$=^.c^UJ$bO;<uY3'?8p%Oh=8nDlh1-&dF;6=]A
;YB@QprSNclWgYJ[GUR@u[GJ<bt@kBp$im\\f^2b[=6U`?@Rmmo<?%GaXX?u\+N[+i4Y4$Ma
=q1b5Enl9HZaO]ApBu.B=.WjoSD7o#eG7J=YXC^aG2-2*<fb59)r$iVb<%E0T/;/e"_;_9H.V
g(o3csT!fB*p1[YQ\+W9!HJkh<0)#UN>bGQ8:Q$W=&+1l4_b59@:d\3>fM>]A06/Zn$!oSXg<
?PJ@gFgda<`gK%(s9IbKEDIGZi&eo+%/n?]A@8C&%t+MS_e'AGbPhA>`*.Wh@pP_n?/W[FkmW
N1L4!.QS7chH[:3E_("Ld7a:Fice['&<8!SS(qK4!2^b_9"tO0Jd3sZrc*t!ruRbcg*;m_`6
bHp63T'@&C'Y^K+3DqE^7I9?7AfNY>_q*'a)`XE)^jcOD[r3M6)f&`4$6*6kruord9l)G^,f
U`-O>=sfZJa9aEn-e!tl?nE9s,'Lfb/35.g8%[M=X[=uK:3G#plo?09;K#ap^H^]A26X<i5r[
V3[)aF@>2qFjL*S!i@'ndP3r_LDr>%k9[NUYq5ci+A+(O9ncWkWZ2f>Ji!fP>]AC2#Wq8(SJ3
NH,H;_)lVoFLt&[)KSW@#HTWJHT.MiKKJ;(&iM6fn#A&(Lcbp0eWKs[Bb]ABX(k,JU(*$#D8!
gu&+fBdQa3ud)V7fN=q.5'"H3ZNb\k3MYaQ=^6Lee4m]A'ki`3qV(\DcO9B-WcJ7J5aX59/JD
kA`5O@o7CF3#d@fO,GLI+lTJ8T5a\oESOlB+Kd,/:I]ArA:W6:,qbT\<nS<b@A:<gVoR!e'&?
:XC.[EFqs/-s6:fR).[NJ`%e2IU%m`\qD[<l(cK'is-K)]AV4Vb=6_.'Skn#;+_@r_+jQmZC$
[f-/?uo4!d'=.(s".:#ZC[#F@^=qn.pOnVY<pH!9JZ)Lou(6\G]ApV8AgGP:T1s3T@XVS0r'N
$VZW>$19u3o=[+/nktQibq2"?gonD"-Zagu$hU)=0G*gil]Ap\RfQaB^1J*6V;3lk:Eq)n^L,
)%&&[.']Ab$/S]A;g"jo\^>Zo:PhLW56F7[1+#pP"4WlMkf2p@UU[Jn`/0#s?lO!L&W+>L3A#3
L"i0n=&HKd'pgkQrjcc9\@=%Wl?=AQ16#r3r#NK[q)N<.:9'Q`Ok>8'0tpkdoMFb$=GKWmS9
;\F$A`;fsOk6.8J>>;LnCCI/g6FQMeOPRU>hsE::$`Mcir&K+`,$m%IA+TkBnW!5ib@Gf03(
jcnhoH%BSV3R@^R")5_"21>G*sGFMD*'r+ol]AVC:+e>3IdaR6`L4[M21+VRECp[gV:a8lB*j
Lm]A:^KFq.V$&b4>?,l-YoAUp9=-Y?-PO!IFrJljdSlNIHq#KSHG$&O]AtmV%)4b\*W*:$D0o#
+:EXK9aL"DaF=n#a`=k:2G`C5MQO#*DksG/l)4&*<>UL!5G>^T)qeK:71,:IHsLq]Ah+"BaZJ
"`fNS6C>qV$ol5s1nkctl=[GeUg8^"I+]A4)LiWJieafnqe)X^/C[K)Ur<fm-J+OYcPl[`!87
\2SnP,qYlf*e"<q)1U5,@=Of[S1NYf4tp`7(9I86*M$E'q>d0YbJBa*epZQR_:)2BLWJD:q$
[.(TG]AD%O2qA/6*uu'ST^%b4Z"KT6kI4]A?%EZAHWIpM7^[/5Th,(=L0,5l!oFQU3$^8$Z*^1
uW>b"@J#@31Y?HJp`bNq1!NW=!bHT\iLnV9$1f%NdogNF'V4!;OJ$t0uV'6'=1Uro5#;T?iR
NSHi=ka*Zq+,F%n0H%?`DgF6p@^c59+T2f6q67fU6)ZTe$Y\H[6Qdn7J`"&Z!1RY>Q7-%r4n
1?Mf$);9pC96NFq*EIh:@rH)Wi%`puBgoLS@\C\[a1Kcl&ERi_kZ\]A4=;r9L)dC,1Pg9C@F8
l0!1=M[B,qpoDBA0As,an3Y6HAu2>@.SjU,h(putE<7]AGT&k00;"Gqk-CO47,.)ZX%an5*TM
>U<DY&nY8KUNk70^^+`)mP=f,3hBf=]AII\e\.&\^H4Ac\Hg8U,_]AY4CFS^n.3n+n]Ao=NPO+2
rWTTfDMW\Cr\U:/2fFY(VQ'f/T';%$/Q?l2RUFNL"<D"R3j795CARr?S[u!oSO^qs#ap4BN-
!O@>7;U/d!;rpeW`E1F?*UW;@4fInI([mIX3neaNf"*9\`WO,J5JP5ReH#sJSk+sdVBHWT<n
3[W5q)Qk7%AWS6[R&n/9/>1fRfl\@,A%Qh$I]A,\5Ss6k!*9&K`=Kn?e#J.8siL#'n>FJ5:$Z
=dsYVd3'EK(p[FhYp<\`,ZtVML2U,do[XW%;UO<5^r5m#9)LZC0C;GcV!`kWiRtbMgop(/[Q
J:+bDcd=8c%']A=q#3mlU1G&_#q7?C(Pd/(.8+Q))[QoHEWY-)aQ9F]A0\5$fIP8c`8+#p6Cd]A
21jtU$F-kT++Y^4aGg1PYd..SPQR(-RLRY5.X(.K'Mp=<kFSktH4UuVbHMhVA%8bZ\Z$VdDD
@I?L/.k0H0@j;m#u&3""J[5RVO5RUB^cUrjN@3'Q1)b9JnAXD$Mn-U#j8uRlc]AiBHeJm3:l@
[aal9#s`_Dg3k'09>*gYMJ"5@K,(-%c\KAh^HqI\F#l$!i5)m>'!]AflF+:.'/Z7bSm,U%(`5
IIsXpD4[9s`X@PdDs(oZd<(VJAWM;M`'DEp/WJX:$)0&hUokI39Pk[98@DLGr$erZWuf'o33
BLDR4hGth*H9J%%<%\.S9C5ClMj1kf%"uYiaQL4_#:"5*jmu^d:i8O(otT(opS1D@b)S<X'%
W4dO$J%t4eQ$&?7^]ArUWTi3rHtVGYOBYJ\,`69!dZn?@/tdR"'U$]AbfA"^;9*RO!B/h$t)B]A
r;ZgO6t.h'#a+CC@,I3pbO6p\:-Qt/+6_0Q!,p4;O_b!X2!e+]A\AVtP1U==Z@*BhK!<q#`tO
(Ihf>eg1T\g6b)gtfq2-V;WN@Yg1UielAojqPp#RqN79)uaCOhKDnslsd!311=W\25qHU92M
TO=1k5K]ARMatWuIg]Ah6Vs)c=@icrqA:[*alj'0\i/\BYDcG\G4NMaYXSt,O5C9#MiQ%q!Z-'
TO-,*S#9Io9S+=dp19a$p;[fgOrqqIe?DX&Zdfn(hX'U-W\="`\ZUb-K,XYllN.q`p_G'/'o
Z"]A1D(]Af4A2+9/eRlUCAE3(p\Nl5%`rFYk!DXK%g^D`tq"[WGb^VL![-`b3lT>5Pg<qO]AC"#
iS73KTAZ.Quo[RmaDcp<38tJS9Yf'7B3(qaG*m%89&J^a/#Nh>uL6iVUa./V,X?-$RDeDDCQ
[FGaC/!aknKcgq7&BB1DrV$I@#ABjE<[I;gIKNDeZCi*YsDr7sD;47=3M+"BsCJCuCJb4>J`
Zd\>_O+IcJ`(aY8*5bW":!hSRBBrWYrB3ulf:P'$lNfG4XuKoD&)\_jrgi&D<tZ9e%LH?nhp
_:9I!@S%n@W.srqDTZP,:"8jK1^*g\[7WZ`K#n@5u8sVf*Y4U/l.bp&`HbK%'@7kec.@pq4?
$l(+E2@K0'DDc8d&f>eK5a=bU.mtbVm>9B)[D0dCbijAX&7.r&n=%`:f>k_d0^UrR"Cb-GTP
^CK+hXWTtDNQqWAp%XtPkSG4*+_bKa<H7$hEu3R9GB(l"m]A_#i0KUkXJ/#:4eYXpHr/[a&5V
P`XXAF"+79fANDkD^Li[FhA$om,e2anK9Ud?lNP`]Aa&_cssr]AIWX=s!9rk*")*J81^i76o%M
2s%mCJAcr5QQ/uu!646W23)o$3&*FaTeFtH;J:_9?qBI2g\F,):$^kWVr-O$^/-tI%4=Q4N*
1_C]ABCQ2&,D(E7Z""\X?JF7%sTRgD902l02?=#YE">?rAI_=qBL7%:$[;Z=/??_[1;.'@B+#
91WKq2+P*kX[j>"P#,m[7S8.n)I$J0]A@9j[NL#nle-"_Z$Fdj@7lSb`fr4q!'7QA))+*K._6
<FQX5=tuDs,@&nVXA*6X&b'&p[@3a=NeP3KX\jGlWLr/T;@X*8)lWuDp%"8k`.Ye>IIBl9'+
DI!nfatGiJZc`["*I;B(eio"AOTf^+6^[IV]AMN90Ue/+(Xo.L>j"n"P)=E!o.6lSLeMiqZiD
6ZmI:<8O1koe+Y%oDQ4jj#7ka\%)pc\E___%OC^#5bE,Ke!a\@l<#hoC:N&tQ0_g'P:iX(jh
.9)OT"1j?g+?I51NA;dF&^.(cI]A@6SWYVN3UYb>WX[Td)\sBBt20CK;8ud.7$spW.#1<qCuq
9PG'LBK\<iA-_jS=ZKK03:lQu,KtbhUi.g@PK^l]Al\!4A#7sQP5r]A2QWa"2V$>jhjC09&r>;
NWG&cPg?S8Vf]Am$B>SueoK9(,-Raq#')S=@P"m9#(C@I.`Sl`<:=_#\H3-nTUqtZQhFoNCP<
$*]Ak:pM]ArNS&+\T'Q!$+'C,Ps.umL2l#!MH-2cPaC18J0TrbE)#(kP\0;piHiN,gT/O7$og=
)5lA;&r1:W10V7]ADdcc@l*\h5$gsoc'O9.;nkP4*BVhcSo&TnbTMUk==EA.Ul^C.f[Mp)%pZ
'q74&Rup)Ghi8O&YR-@<k59VlY%$HNi*kHc-OBE+^s_@-/LBfJ0bGj"DXfa"]A*1J]A=(^X-VZ
06b3j_Uh*+C>]AJtiJ+eMAi-7F5[?UDudm(%Ma7L7Yq\6>cbS#\;g+mgq-JkHRW?7^7?cW'[l
B$OZ.@9tEO"hjB*1nWrm0&%Xg"YFr/5Nfnk6knKecRl3'uJ:m@bgNbJj,NIJ;1H!h3l/.$g7
q<Dc7q1F//SIpfGH+<[*?G_cf*lSFnhE^Uo59Ktc)7AOkPJ.qu#C4I_/6-8>kV,X]AT4HP`7t
]AriAL1"%-H"n-Q]A[q0EV?84FpB9ZF/1Ydqs8><Bcpa3;N92d`ns*_i.#&<Y#]A<SmRTLT&&^5
cP-hBUR'&g'1n?iO+"$a=\jL@Ci?K!s7d`P,bt8;cj"q9mN#3CCcVrk&fsW#XC-%I#3^nKjY
U!oOPXEcYY+OuIn-s5UB+5dSI9j)cjp%FcH+hH?q&6]A&Cr`>XM!qp(ob8*D.geSFn(fK^Y:4
:f^AIO+amZ/5W&Ea,?MU.L$9\\;^HDgIrZKoc@$'ITr+cG*Qt\^\0-6XN?N3Fp#s*g=AuPFa
\<GJ$^$2"PbhH=2hP]A@N&o)e)XOo=be7L6J[pF+=pt"YrQ$54J(*b4UW+@dGbj`"j%sblr4a
AYhs@K]A_ib[khFp(1,#3Ml/e^cCU/C7Lai=$p&3rD_'I=e)`<D\c'QiJ8W_b.>Z;!e9%QBQB
DsP]A4>3PWqWLsloO2`"t5^j1gc!mF`Sse@=\2+Q*,"F!V64!muOp`i$T0%rZDuf,_u'[3m8B
NENuE?[l#tH+t)W`".aY%^<+gJ/?@)tD0>V)e@+-5.@gqM&?@$WXCF=?hD_=r/T>hXkOiUXM
?$DUT^?A2W7H_%;0YQdIA@LWh9Hth/afLG)%0!n@bJ8OSSak^O\M%Nb9[*dS?1_NMAf.5dE^
WTjGDp&:p8SFfX-l`\29Nq$%,3VlVJ,D%4I1:#qXp)\_Z@BnX./+$im3WET,RD-Q#Y\%P`.@
U>5#/_*e>)mu.*jH>#s="[qm,ae`p_HjjLWXr7+BSMG.CbVB3MBq,&Q%^Up+EYg#On@<Mn-Q
mtP!.pSLH9g9nmnQlB>1u.eU"kF6K0D#[@in\G<,n0F2W^.5nsF[!F/A2b,U[`KDX<cpkTBR
p&#*Qg]Ai2^cI'4fP`^j00q\aUh2p24:>d1(U@[6#76%#^`SWQ+m4q?8OMr?asenhI8=sd9,n
2"g;.#bs4LdOkAR]Ao8jPL@G.2fV,'7QC)]AW&3;=AeF,h@.%;$"os"g]Ap1bon2q7p7=)3DX39
c`G5K<mqb6C5e>;J#qZgDUp>gr[gUDNNr$eoUcQZ]At1[C<K3u,D?!X^^o3;FNDSHn#ZWM*RR
1t@'QiV6g330=/9CK;X[!<C;8eN>#gj=O\(oc!MgPDUTr^!ggnP&I#@5E+6b(QFeRpbb=%CO
sEHnbsf!YD6q0!"f+!BbkDQCUi0!KoRqSNJr_iU:*]AV"X2f.0X(fW/n<>mW>JCKWT$TrobYo
Rm<Qs*T4Z^M(l97%jSe1H7qU#0=*(WRm5D8RR9kZq,/8r_PF#q_(Je#&kn7Z1s$.GX*RCa5D
!1dunMIlp/V,ni/\ulFTE<b#DE\2>(VA]AXh@TsYYQLVoRC$7<Uhd)&VDt)RT\C26X_c&=8Zh
.(nD_N(L1T[#\+PN?ebHh-C&)mYBC4eB5$2-E4!-\Y-K6B(<dg!GCb1guN`'2o*0RSCHm+$.
^;MCFC@QL]A>Moq0l]A7*q5(O067qpZZH?W>7Qm.QV,r4NcQKZQ7,0B,Hqrn&BA^7XE(4XqZRV
*5_8+Lcc#I:PfD6K.p/#kmpEc'ZOo+j_h)KmC/qrR$oP$e6;\h70On"R@pmRs)37A@X=cI(5
ASb.0ZYZm/'8(sV&Nu9WVE@n,Aj8R$0ecJY+>setOOeO]AsSK#S[iW>+_$Gn1hE3bGm)<:&ID
;Cr#-/`eOV$=#FGl3V*.t-u@!8O/H5mGs2%9e4Yc855>V(1#sDd_2nc.AVO9o0qE=i,9;;*P
:0dkr<P3#WiWg=56(f5[@nIT#=YYas/B-RAc=gb>b9V6^.WG.3%mfO<:aF_L6AH7]Ajd#X'ia
m@peJ4tV@`Zg.9!.1&,]AI3`^60hK8JeCT!]A^b3<-?s:cJV9HgJ6ljd0rS.!ni@gjcI0d``]AZ
s>#me.(^Wngr+SG2CeVTO/s^%4a`?1&*(7GJCq[)g&]AY4^t2CY:GbZ<\!c\d^bH$h9AC.#Ro
U`(hGSDGR8cXrmDI>Y43LmkZXHWW%?9ZU51G)PeEBf32+A?[P1Eo7rRC8M[q%Fi60ugblekG
?AWF1QpeG%J1<K`fK3f1?u7M7_@Uu/5(gFY]AlQ?9HZ:70)(XhDV92:AXUg`hAF,3BNrtc?ZJ
.Be!VS+/A,r8W#]AUGMcd@TGbRJCc(g^t#pO,rf/7FZa(KkCe<YFlFS9nEmG2sflPoV4DR)B&
L:pq(9p-KPPaf[03n3//84el2p,SU@Y&E<e48m!5k:>mS:`s:aa>gcUmP4'![^r3\<Ht-jmC
/?m4E$Js`%I8fp-ZbVLbBrT2rmg3JYB59^D,.'RR+41DmR*t6.:%<'SuJB$WH1:9Bl;&[G1s
[1-p*@9mUjh%loB)e+QAXR\(2/K7E`"Rt8\>aS]Aq"g2G-#%uoKKO1,T)9X)*ELW_!i^+,ZeG
"8N_YJ#!a=*a#\2ckI<4:ss>6[WbEjP/ob-89`"0V4QBqA3j<DkkS$H1A@PPt4]Agj_o4'+tK
D]A+fu_ln%PYMTacJ[63.[KM=f:_ja<2nU.74CWts`n:FS*W.fK1-?HN+,VRXtJVou#=H$?@V
A,5EQqh1%/\a[7"5`qse2U-[TW5g/*[95tc8m>Y=[4?e($IX?dpLsXL9VMD4>DeN*7TSJn8W
jD.D]Ap4EopQs2%<d+FGbho.J![\WT9a\i"Xe)0A'S4(Do47b[ns1DbkBg7_W"gW"J."D7uaa
N/Cscm+tMBbps&f@I:6Fn3@*JNj`AEXX5PY2K[DG=,r]AN*,#rS)1YMk3S7Z>rac\XiBDILJX
nclO)H+P@<-)r7m%AB4cq9>m<]AG,;.TR.%2h!!f^ut&*ppbK-/%m5mnL3h,5,^Nub2/9&D6V
]AXEh;Zfg<"%'gA0U-[9etH\ddE!bEjhaJm!MJAq)fB=sNJb\bqoVAVe+-]Ao.;0AJ8/)'`b.`
/c.225=-ET+qU8GPI!)Vn<Oshroq-=4ulo\<*JG@1l`NZ7iOp"rgm!=N9bg'!kRp56GORe[F
*Ze-_X/uIu\GX%q8D]AHVhsnoe3UHq]Arj72_:7Oo_6tRe:(/>Vaf^d`ll=fd@n%3OV*s/1GB'
E5cC3rSVL"`4,=%9UnoX3?,*R:BL&@YTsUT4PY@5*euHO6H$jM!;mT:cn]A"sa^^-.oh6sb=V
0:)"c?G_6C3@L_g6;7,[NEI*B(54.;OV&q)[lG0p<j7TOu4D+A5J*l^QYX%\*Jqe,JhEM*\M
pH^o-T_fHdFK%fYZf3NGgLkNAuB8VctGdtb#[j`_g@$l]A4*bds?]AR2s1r#Kmm$K]A`Ft_'0aG
:i-ejDrYFFqj+E8I)?#&nLA^DgL8:mL%Dc9XL:USU3tuOh^_2K22!1O"jg-AjEb/0^7ZgQ:t
p/-IFVq'T)+u!%9^n^kl6"'ijBVbiUtpH03[;jqhVS7YRf<5a<tonb/^8/^Jp"XT9.Q!`-go
)Ancj+At%<HMZL<?V1G9Ao;%Tu!F_@B!goTDGq^O=UElgC(>l,gd2;_tB3jC=O2f&1UPd'PK
l7AQG1e(>XGa]A1RA0!W:8s!tjIVQ?M!,/U)mDiHX.?]AiXL)!JUcITNF_S_Q#!/fV?WNdo@42
&gC,)AJhhDD")JJg>kZmJap,;5?D:5sXkc:K<PEBa9QJib.b2@A'=f8diS'($\QfG^::d657
<V:tQcM8h.YA!b906q&.bhUAFrf9M_q7qLH]AcK%fEko7":9)5UF&FU)HT<''_1NQ=7K1_:?M
eX8PlN")9X/f2V0V)gpQ\<nWlWS%lLIur)*(Vq7HW-ldPgCM\!U*Zq7/t[9ZJGbQ.kcu=B"2
=\U'`,/'WYkV="K!,4qkKms9LrMB1a<E2$n+Hcb8#[6CjDjWHYeq-Eh1YqEGH[#\I$_SaY#0
6s+V&9ekked7;eIqgeapJ!s&-/Cq+$nJ]A'<O`5Pkso[XafNomjgLWZXf\Qir?*7RbjSm?4jn
0BU"W^h_-pVV[c"TsC<]AHfJ&k2h;AtI\)mqGgGF1Au-jRGfBJ=7o'0tg_r^p'8Ru#;&!QrN3
bM*[Z(L"O&b\Ib3rMfc\PJ&jiaBeq0h!'-.7%NSC.lPPk?f-?/)J^>q_`CpK:4B,;5VFnR+2
lsrb#LEK0=,:Kcpb_Ad,oTnLP"t2%U#^bl?GK@#f#m]AeM=%mEkc)6Jq$!H.f(=?7BVk&!<L&
!-+?lu-E%'@#]AC,V5>Ce6PpoMtk!^cG??pg.R;Z1q3IMG>\!%.Oe9l+@1H\dgM`c9uVH%P,=
ViOb3o&![&4=r6"5C/t_iChbV1o%?35?R6TX/?,aURKVM_s0-iV55%@%DcD&/3kXqm0<oYUo
!7:?C?Xd(bl7%-V#>^1&&tR$EUA^)sfY))_-f;"C/c9m'a2'L>+uOPYniJ-&#_#t5C>64m$*
UkD8F<LT"GV5cA;(6PIZ&<Paq'2Vk_:o#TITsrD7,cHcQ1[i!&bb&,HS?qtDCYe;_Aaa\"&t
C/L'^2rT4oGqOaX4Lgfb7Y;VC2"LF@A%:4qKC0\K;eIZ;OFWgW[s^UTPuJO%s"j)G3%.='1u
og)JlQ`[a/KhRGVWecVdHDlLsZYX/0[4>F$I(%ZIg)BJ=#DW\C$T=ef]A/&n-$Ir)858!+:G^
HqM0j(.Cg6e3<2P\l2j>C]A`1B<cMeWhMT,,0Z_ac&\FPL+8o!<n;06PNYkoH3_<.oRN'g:C*
(lM=En5FOnBubKNj'eAa=CQJ`*/7m;P`2\1r*_)!RhiOW9_O.L0hN?d44,Z+_N>CF'?R\/.o
1*]A3Y>XM'OR]AA6E#.Our/68rm.JOlAgp+D^e^E`B-JR&/`NXr(E5<aPoc.GU#sOn?)@/dX9>
_pK85AVse6B(Ah_P&"=^?P(QE%F*c"qSW.o"n#PM#<Q]A,KYf=LUUW:g6GE3K%o&h9n6=BBCE
i"GIXaU4qkr&`s/@Q+%0H3Nqpr7uR*Vm(G>o;nHuX1F3u$N&oWCANXHB9p0/l//eI[8lturc
9)&&ItCY&Fj4MDlH+'eSP-(]Ah/:^/')U`]A'SLiA>^I]AQ+%HBLGiBo85?p(jaOS7Im>H/(12*
t2_7a&q=3CRD7t[-P9>kM<dgbF?AYI-CDS$^aK;tZ)kA<'kWPECS<^IM+HI9SqQh1&1^;ko6
\L>aNCK%6DG%'<5aA^A#j!_cF%R[U<C*2i8*5,jQ9fa0_';$f4g:L29_-&FsLN\9S5JaAK4E
dkt+!A/eGdj_I._a9"5%,;(9+:+V!=:(mm?n^QDSDX^Ie17-=HV]AtTkLu$It2:J\N``V%#(d
lr#DmMpEGr;plL%p[ouk+COW$7-]AnG!<X[#B:FY7nKGWFO4GdVX"Js%42'a.9Rkg`bA)Ji%Y
K=Yb!(Nm5\ZY5@WA28]AQa(OYHPsSg\^c'Q611LYqm@G!DKBqo8s*>gL#Jf20m`Ul8VV!!,8H
Ph'A##YaO4%*gUpfQ^Y!SF$Suls,XXa>9X5g1EpI-?)sY3U8Jjp:j=-=Q=AO09KMN*T9)@mC
TFV+7=MmLr/V=\K_=5.#d5Ul-?)+<$6&$m4N<IVfApCc^W=pd-W:B!N+=O[I2br.f_oA(JLK
`oqiiQ"8-4^Z?bm&qT:EZb-cQR[9^."=9K8\q"d7n@)"e-'.\_f`:iQ:o_4JlP^aSC?TI`T=
]AUHl?OCp.(67mK8o#u(CXdC<DbB+\UZ[r`;I11=&WVC^NeHnf-so"?BIqtRX1kiZ8!7%5t\9
hk8&-huBIF+-d$I.JerK'U5]A5I.$Y;eXnlA",LC+6LdE\6k8XJJZQm<;QaC2Rq"e:EIn76XQ
u,q3d%&`k9`_*&"MG?GK5qIn80g=8$_OiH8(I?b<6rA@mui)"=3Zq9?!^a?(G6(sBDl)El\X
)04h^6]A'DKK\Iu/Sj,*"lV(BmP-qf8`qYYDC(i-\[WTCG4B$eU.?JR9ph?ARe&P0UUCS'Z.G
h**gc#j46snZm&S)6?;09<;JE.qNUm&D:r..1g(4F+A'@tBO<`^WSs+7g.GKl>.hf2m3i5"X
hFfV8=60BlVOhAV>%rq_FNi??q;0ptg_W)AjlLW%@=*RT$(=I&406Rp25i5:T41sf9PD^lN+
@^1o)a!4gWfrV2I;&h)?),H_KY5n?bRiDYM5W@I3S/&h>h/T2Nd1l*>4QMVS&p2`ZNN7n&qr
DP2K'[cC^mOp`JGUb0=^u3DP"+=[T>rqrq3b^Z>ePRDIu;oRa&lfqp<L;6E=2R,,2g>OO]A:U
g.0&QTEefjBiqVaDgCa@k^24KIH^/ik]A)N57"^uE[C<uQE(hhR`uEM+X@d^S/8UN7aXHuD8$
u+N?APYnZS;Lj\A-\*Xr.E==U<C&!%8*>?G$]A7k]A<P%;UKrhdIhbU*h2q8"NkSL6WRsaRp'Y
URuVU%$Q(dtj`_@27+jpN7;dIf6f#n',BH`#WHIALP%is3L<9EsIBiJIUYcL2W21f'_MKAM>
"6#C%="c;dUe98of/A$FVd:pH,HMp"m#=FPhOiKAq05W@?+cp4A#R8Z0)Gj#CTI5^=t/ZEOF
":[%"-[#H?ELSGlUVl5Uki7C8ShZ(1oe0d$56MeK:[P.=#C-!JsRMin;8V!<DJ$de7Z689bX
gg[/[3oobkm,PeIm+kVk=u.>JYTOV9M/.&#r4P2D:t!3:faMeb'2:;kfY<F.A]APP+:Ut*WU_
/b=f_[RZrp?X7W'dp`T\&kU=q=ki&.KY7=&:(d#QYEE3B`,%nTE>TP3h%b?ZfApkZn_Bs4Ud
sUZBA*PKY9E]AemCoD=*:Z@@7nrZMBF+`5a:OOAQD\_U0_I)Cq9N"V39MZM@_Flk(d]ALgn4)m
60R7^CBF@D\,PUr:Xh]AKL6]AFW\HBQ7JZO&`P8XioF-c%^Ys:bd1$!<!pECuofCnf*XOnRX3,
'S(RSFb2C=3q4tlW\ja6=C7ao7C$E:.T-NQJrn2m2[(E;67LTjP?hDr>r^Ohe=&N[Dc]ApiX/
-mT:6nm:]A\DU7(*=?hs_Z28A!RnO#85M_t1&M_^nk&OHKs&K3IfK5.g==[70BL0@boIh]AdF.
_i3#r:b*5O?<"$O#d.CUqUV<FH5bC9s%/>=k."$:gg6oP+L7eVQ'*9V,cYCauU9/1G?'8$["
=M20Y$8iU79$F]A8GXFp+dabtbXo):H/hD^\#PO_d(;E#&VR);Yl+S?N:_&C8@.OL"T//AXYK
"K5p+Kl(c8"Yh:>:>d-R_NMN)X=-*)Pqk*&XP:`2]ANq^L@g,j<hsBRo/NrETC"j1'R_@e,5M
QbSPuNYPT]A*8+(ONj'jg_WJIGWQ>C86^27W;'S14L$VG4cf5gtEPNs1RH]A"ICA:.iEW%k7;8
dSuste:5@*]AMqOT3^pd82fP0`*HZ"ZKE3b/:+!="O^G"/Gj,pmB0@^*5fi!1br,0#Q79-"h$
(gLG?BiI6m*HHBT=<QDE15X%U,+m"&D4^Khe*T=b\*a9$6Y`(UGAZ*&8GT7Pm&=YmQ-fGoG<
2]AEhD@X4LLQTFNa\8?&p(Mk=keW('#WU%+;kHSYE4kF\!2IljNUnF/GmZ'"H[r&-8$[Pp.^A
TX7`a)0i48-+*.eCS+e[@8o8U2m\^f>DN25q>(;'20D09.j*>j78o>DY?BakdBq6ddW:r@+(
Dk3D<7oMlMbY\).@qJrNGlE)'D'X+TiP<@LrG]A4lB+?P+Mn@%+bhcg<XG/CpmJrBtA<P$jaK
gl.LaHLb/1cffFDFTeU-FR+/B<hEgE:s;!GPr#T6#:tgc0082i<^W*qP35:sRe;%66*T*hA/
R;g".&T'VgSm6T-hV_)2si=+Y#;/!=n+Wl$Anm893Usfnh6TRZFsrQ/tua.bkQ@XJ5[%!<ar
ePoTpnme.ilkSn)"WtEU4<tX5Xg"b-K<1D!163rjS0*8F?mFj9$0-7S]A_tO4MCGM%216\'i9
)!p&1h'So,1"m9M/5ci;V>q[5BEOX5HA#/)c!(:gWbX/s*]AEP*V?0GSkag[[HCY:bF#cdhnb
r2q*)7<966E3(-6[BQcJP_IO\1OI)MRXL5<hp3K;BCP]AYDWpr?_N#HI4r-uK5R:=sJmW9*Dq
&1g<u>@C(/e\ccr7+;<b=Oq?1'\Z5$^h<p_0I&Abo;8s%B7V"[J/HPPjQ/#727&a^Q`]AScU@
-.bh7@;0PHc^;+f4*(SJOkc]A;ou1kt;-$J+M^feZeH.0+[Hb2?6*;3'\M-NGE-=S;aD.8U&>
rc_oEc05hf0a4+;X+^/d!9YN"+:pA`REPjgu8^B,p,T?V(Yr03;9RC_r0c$Wo!Wsm-UCj_*e
6,_;L6H:T@Tthd[,;iM(I<ci8t+KebEPW06WE)LPA>qW%nY#N77Nd/YLmj?I%fAVr*tgt-l2
='DNGoWH#:EmW_L_1GkO%0i!l[<i9_+CJU<t-ep`n09C'PKdq2o-YRPBSl2/SeU8X:"oek`V
pZem#9W+\W:ehCR<'',BY%"P?9GEXnrCb;)j"&+N_74U6(j2rEDn[LT6E_H]A/o[e`j@Y2WXJ
<>O*r4Tn*p<:f?Rm:m.JL`!e%VBV(3eP*T"X=4i^"!)b!S)A^VpICl[MJKY`gPF8^/?U+Y0)
Y@F!,-NW54YBPt<OQoJkmdDl+<c"@?9>.e)$QKK\=6U10t^)$Ga.QVq0T:_lQ_GFlLdqtQo#
Cu8bblYDVn$NF$&&huc/D[+_i;e%B*NMK!**0KN50l0_=@XXlF/A2WJORcBmO3AIZB't9*ZP
G-+e"]A)k]A4pD&rU!*2O1q^.@TdPXb*#\l_(e8^@lQ+I7tM<Co;l>^uQ/7nZe4eg([)BSOgCg
b+DmSkk+(CgYse\jgFgm%5R78rqtVq<\@qsp)tj4O(ouJAl3TO?Z1->cR6sjW\oj#4]At">OA
MHpm'S0-+qLkcnu(mM_(c9Daf2Q33Nf/\&3K$(]AUq0'%8pm)o_QB;9P)EH4I+f5l+lFPgcRu
7nD)4#N-!'uX@n\?J>;VLq)c!M0;PA10qq`*"T+E*2h$^"JKG*?ljl5"O9oj+.<r?N#F0;!(
I?pV),'0!5g)#U.8(RQq"nO&Z([OsrZ.Q(AI(PoF@qBHg\ISnN2_-,QN3.58n`R^ht+eH$#>
=)qSV^PkORr>H1nK<:/-KH852U.?.GKUet"C.F+KhY,Q8[oB<2a;L82M(LTJT'HN%S:[LIbq
^Za7]A.Vt/pV!BQ+Z>c.BB_ea<-QH78AU$c>,Kk8_5N[9d_'Y0]A"Gl^eP\+0ChH&i*Su[6[,L
Xj^;u1r4obQ0'B]AJ9EFInj3R)V>q*D7m(OKb-.;r+JJr5<n\rXE)#/fhupi#(l5NGojH,k<3
e8\`!mA/5'?&g!Dd%<!VC9<$Af+d]AZj&sOXQZW591#_"5No!%;7#^o(aE``C9UYO)aY`m>Pr
)gaIVOJDDaF?Cd1@*:8Cj=O>_,.ir&.2P=qKcq,CuF\]A\@Zb*<hGkO!r4o$MsL[tJd$^nc/&
sHbF'p=p&$kPlH*:?mlMk'qXoKui<EkoFijHMa0@Gh[aucGHPMp6gp4[!N(gHrU(W]AM/1'Ym
k35p<TtT6aqDR6rjDfgm@H[3/RUGJuUC/otJsC#"<^]Ad/l-(2>(`GCH&@<p\/M*#VLQQJDM-
JVALiEc-pS8>XhqCR^CIGH,C_9rum@P,Q1G3e43\?ES5lrZ%A(pY![rQ;qOehW02A&F\U&*F
cH<M[tTM*Uh_lhRm:UJ08l5Q(@D]A^"'V'%qRi+['-C>2tH#Lar@-Bu>p=p44-aI_iBcdRf09
kH?X)rh9]A]A`>ImNAq^F&IB:*'>Y3#GcTAc9DSE5Pg]AT<;>`EcE?fsj/'bZq-S[Ps!A@&OOX8
kO9:rf(Ue<l2E^'GYcHfR(TPZ>)f81%OQd$2R4R^M/5e?i[^S';U"lT<i"Esf*o:Tp-:/m+%
9u*Y>\_8\Y]An,lWkH[Xl]A>%`6e@I\r/obUOQ$<DeD"Efs)U4D'b[*21>*:sNaI:p8J6'P9hS
AtGCcF\2cug\:6kZ]A3Fl?Ill.<gBX@kI3H4hHKDhjtFkkmJ'Y]AV&13qcR!e/qbY5@"gTT575
&Gq8F/B*%hkkToi3D+PHqA:eOQVomqS[IMp/)I#?YN<fcn"_1e#iH4#nk,:IVet65PQ?EmoH
4?%/]At!Z7T[ZJES9KP*1HXu?4"%_F/@N628<psZ=9,KUS_D@HJ/FHc2@I]A]Aqoq6N:5Caup,Y
E2!f3en%QTq*Hn-Hh-3-buRurQgHdI0M9!'f_`RN_QC.q:qBI8EM_&%"e*O78#h0-0"r8e?Z
7DF'6<)u`gc@%08c7'Q7\USF?q6SoX3<A]A-X/9uJHVGh_We@qYB5Wj:i(&k("#XegDU$S:E9
gF2blALrD?gCDWlRkhc!O.X*uAlAgNAF?@UJj56_k9G42E:2KMhp$$j?eJ0c!$7=sJWWF$PM
JLT*Wid#d)X'M\_8OU:b[eW<*AI3DcBo^j]AP]AJriNKZ81)fUH?@I+`*l1J[PI?@*O5q(`\jY
loPSo!M_ZI1C3,^3a-b)s:7A=+<DJQ=e4c97$G2KoXcLrQb^i9]A#h/V:lkKN$KAE^]A$@CMY9
X7;'.YSd,+^<%&ZHNpH3?E0M2j%MOBX;jZM>G<NBG0KJJmXL^@.`a1D]AY:KJth6k_[@U9T?W
;>PcYq^)Na#&gq+gq<HgMjP#Gg5bUV96<pj<K'oj0So-5Y,`m`ge=$(1jcQk6&63u5SeYGrJ
E9<ROANi5r9a*U+4]A[@arFpe3g,hCuCcPg9ZkudUHVZ,t(mA5XW:r*gDfnlIML`Vj-`"8=Sf
\&#ecmqUMck:SS#phIBX8!na+Cb:gr!Kg^ak6i@6p_DoSL&n.F;J@>]A.<if\p13nMlO9o3cK
I]A8F=f<uJQZ8U;(;V/q5:.a=`^p-0ju-4s_>DSsJUY3X9SF<rO2TdA%E<(V%mrpSanZ:o%K7
]AgK#o`^==-JI;,A\-D>Io;K;CMQWFjBorC!qL1;1H4m*Ya$aT$M1O(uVMRS*'$r_XG&#O2Dr
mdK]AWVopLU_h/jjTAP+eaE+XgK-dAbdr)%Oc,^@PQ(bBARr[JQOV6-V:1J^6E!i/.Yt4m)+;
^kV//Tcaa^%R%=(/?hSU-OsSI"c&J)O(e^*)S%30Y?pR3\$,3I#]AobNsK9IcoJ!B#!RFhdcW
_7cOl@6i[Iop,;XAYJjd_\K:<C<6dP!F>KmDr$QS269"<G"--gsXS]A]A\JKK-b?$%h/=Me&fg
k[eTh/ilS?4Q`q)m7@Q8Zr%KYeWg3ZgM%C.dT%1&S/t5p_Y/4^!N[75eC;LPM80"2M:;5>*'
q&`EQ:Gbp=t2g<)+l.)qaV&)i6.OY;<jhd:DC9=T-95Rs00"XUb>L#Ah^VH7!_o&>YWe[blB
9[dU"jUe6O.?Ra<3UPmF$`\:u#gE""1&C_>2g;g`bu\&WDH>TaKs@.lGRU9d+<G&-lmi#4>!
^aub&@(I"F]AOh?]AS2BUf-VY;>@HMDF+^kUn%i]Aior/6P3=mfBlY=sA2!,5GhU!_J),jiI+.S
lA8oSS%&DtU\,7%,26>GR.ARoI;<nkJg`HrROiE[MRdc+m;p//?DCrkPn&YMDW\.KYYT+"F!
NE?GqZNJkM59U3lP_Q0NOlkp4crp30g`W#6N=b!SBe7k)9M^kZ6*f^TP%c+''PH)lLT88TO&
a@YllWUUKHBgH1_Yf,T60"AWnmR_=%#\2jn#j/fr.AP;RSjr^&`rU0)+FCmtHLMjt$\<+`jR
mb$<Mnld2iq':h^q,?R*_Oknfh9-;!').GW^8Z@V>=_lEHeDpjr*jLa@?njprYe:C?,'ImFf
3)8=.A6rUAM'$!2m3;3k=+j;$4oXn3A^*'>]A:`GWrCUK8%W156k@<>:>D,iG`X?GdZ4.)hb;
d1c0j;7S.>2[V1r5=@AG;C0\59j2g,$G.jISDh-E1"0RfbgX$-2`<6/S@th?&r3eCcbO!8uA
PqWmnJghsOH>KFRrDHlNt@VLSQ[>VL6s<:&i;JF/Xc>gF*\S_HjdWK_=V118'Ynk)cAK#NLp
ofP.*TPE3-,J+AMSoNgEO7nagJmTuT/:\XKis$=P8H$ED[hje6uo6:6l!8!%M+*(o^E<cF%-
V@TIl_=9L6WVuO*Fp%kRqc%0"AT'\3]A2\Pc`HhEF/>-%75b-uWUR1@?Z.G@@h#c(P$i$JG'U
KR3c`*?]ABDnj>*s*k&N5,u!OEC[s-6D<&Ha[tnBK%Aor,*]AR1*,=ha?Va!7>8`J6CKp2#fD8
.Ys)V*$-RucQJGhfOM&"Vi#Z-efHPc>o,EUL4Y8Z13[if:4h&J7pi,O<n4&1'/q:?_VXSn%+
EX;R%O%g32%f4SieVlF1)aGD1Hu'.Rho9gVTT!^,]A!!^NtOGcIl$;#'5"![dmMj4!>6Hi#A!
AM\:NX8\gVQTm:W>/q%Jt$*Vd(+o;SU"=E<Y0UM.ejRQVb#?/m2SO^iYIj8$)k6:-L@OUm^$
7Pdl"N<O1i:e^[/6P[;!k#3d/pQdr-;E&T`%?sY'RllrZmp:r;6eBH&a\:=cmZ-XLKnJ(;nC
<^-fuugQiViT._Jcm>.`>L30@q.(Am9tj9Pjl6RCQRnplc+gpk$Y2-Zk%SXTSn9&qC)>&dB7
%b,3PIs6tW1o^XkK6t9.B.mYfDbFd>0AihI<A[l<WC?7<F`>N`_<fVliZS7:"SIZ`*,K`B;Y
;22g;'Nel#=ltrP2(!mV'FQZ\CdZNh2;*j:j)22B8WfnM(^4&)WHXaOI84^g_>hIF_S+fF?4
aLau<qD//E'EbXPa=/h@:j7[lBCRFO3#Vi=l8:Y4C3?/PH5J)\Ho8n8=*PI2"WYbcZ6C)-ne
C?R"0[]A2+B,2dPE^'EXLia[4!fIPU8eSs/;_'(KAR,H#">6rOV)P.rhGda0nP,sT(0RY/FU\
Fb:Bk(MIS@61ciP&Cr/fq>u:sNSO35G6',(Z')cEeJ!;A3N-U&]AfdSUMjgHi9jtf<PK#qIcM
277mlb+c>UlbdoC"Q=\>g$hbp@=Ksj>'rKk5ni\EPi/?40R5t#5ooJc94.[[[$9g,(j8HVtD
j?sE2"n1ullJsb,Q/*qb"L$PA6?uQDFY0>]AJY5sjfU<N?UKnZkfM\)%iEB:C#X2p,`.ZEh66
b\H#o`R\Y!SG.B/Wr_]AmColjmG*;DNV6"1oR\e=J#Oi79H,pVC1=]AYB'WNah:-ZVNm=Xe3A>
clq7SlBp4?#F<(.F>)(h]A^<J[@P&!+MIUcNCpVTqNc=;@BPOGOk_^Cb1YjK%prJ7t"))naId
_#p&BC7:MP=@3HhQNAhjse9GjBh.=/pJ:oKr:5[fo4o#=_7BQcS#\dSp\lj_c<On;gP^JecB
JRL4o(2opo\=H_5B+61#ll_I"K`:\_f``;g90/fLuBR7e1_Q'O5YP<DR;!P#_g_p%<-u]A:hM
!^@a%GlEZ%mnOiofVf[j.5bPAYK@&,g,LQB*Ho4`2P@=Aq&:nGV4",#`:ZJ4auLW?C@hl#!;
2A!'P=$_hAO_!JrK'X:eG)F;C7Le9(aIMI7;tEn77Leiq.XA?dU^OrF-&I5lW$T_GL26OV&(
:@pCL/tAn).Akb@f^UQ&IaEBk>"M[)d^VN51c#h'jWWCX_%-9#^WRp_'X`A$T([;h9tf^F?(
]A9+Q1BmqA"UrYX1:=]A1,F*3']A[auSWmF5-@4O^g8W3c$DY3pL)[5O:1OCh8QC$]AmuGe(=4%j
toq]Ad2LKBmgrQG:<jWm2N`fluLKn]At%^]AblMX;2G`+mnjpaI?!)g.7;rqGPMp<+1AC/qT8#Q
!>JuUR7+HjLX'`:Us#'S*:Br>hp%_W?hm:=7OikD_915$Y!,BF/tblXS/F@pL"TV(?%G"cJ]A
q#jX<>TjFd$!G@'`Fi85@-#KqqZNjCUqSPk@nda%qX&cfj.]ANEWK2Y<%9OW\QD2n@g`L(`_k
XHjI_f`B2\eu.'QI`i^,,H`^JH?_.U]AheDT-@`7P0NM>,jPGT\)l7ts+"MpJ/F>*I*fZpaa,
W2BR!3;RI$mLZ`)mpMk1N*Lk'I!'l]A/6aIe'L,ku0Ok/9W%D40KZm&aAg@lC+bp4:<d96i<`
%>aDq^HOXrj(A8hreE/;?gm?@:4@uL$F^dS%\1mu=fa*f6X.I/Vf1hL;#L_o,Yf&mMl8/'S)
LJl0mhfCg<\gF$P>AQ\^RmAh*5m%90u!)H$2lGOodRo:cY)0@r3,@@oN_;hJ*Q<"foV^k5.q
7=kq&S=e03/.\prc;)151V+@(r9g*SCGa(-M=e]A2s:q!n5</[!*!nN60e6uY&KoK%52\^eR.
BZnkQf8!NCKHJ1Nn+]AKDh)!qQs,'?c6h,Ir7`2G'+ZUrpa8#;?N4cePfjl5i6lsZ0Mf4>YKH
-]A$$^nNk:t[qrrT/VI*.<b)Y&>2qcFUF0:L5(qh"`EiJ>W@0iY1jA,o1YdGum"/`ckR,B6>h
QJ(TC:3BSQ*^?;Wa]AOer"1D7?DT,V2G$fg<_GEX$=Kt'r,mcWYUMCG*8_LKNZSTjcFKM3V?^
dD;R-lRr_[V%hs8#t6RJ`rpc9<JonGEgs(nj,BU929PFX5@7:ON(!9`cK>GqdfBke*9KuQ!2
p2bqCO&Zrmoil#aE+#<s+cI8u`N"k1g$jI54I#lMm,6id)PFG*Tt*=ge.089=((mUslmrH@+
)ST:$TQ%Z!i4F;0Y5%(F:B$NiFX?BuD,)\VSV>58?%f(DE<>4qUN4YFYJkC*X4$Z2H;[Q-db
KT&XmcPgF^.2Ohs:_^rr0V2+EW!4=]AT%Ia6rl5-KU;P`">4uU?14^6D[H&`k7^!9="OrFo0q
1cC->Di$.@BDeSdpS)?]A<87-gk2#@VTLNn:e[uYFbM?M'XR<.OpI+1U5-(d@9&9seB>\]ADtA
Ok.AA)^O'fDaUV=-dhnL;e+!ap>baLLUKhc#,<Z/BIAt/*tZ<*(V2ILAZY47eaS`(ZQ7gc(.
_GSB/C4;EC?3Gnn!NZn_;.JqP:pWu8*to[^jI^JT&/RaDZ[Xtas*fSLhGm4#e25*PCJ<b<UF
C-@$>'?\^DIr78[LZ+3WSnp+G8Vg2o7ug9*#6iARWA[DFZ/8H7;qm#rURN30Bq9p@euKO_?I
Wk$r,tp6jn:J.Gm@9A?JV3R@AIO8/JW+W]AX]Aur#)M1[iH6,Ak`URk`rE'+(A%7gFPe_OUN&_
9X(ba(-&,2<NXQRZV-^WkQU\1Ec"fZaMRM<@BEY)R)o_U"U,7N'P^,%+$2Cd3YZZHXTB##2f
]AhcI6Z0U+aCr`S-%H!#Y,j<6<[hgrIR,5()5i:-.PYt*O2G7EFU)3b1q$gWWTrn#UjST2D?J
YroUK,ZKe<LaTAsr0YTij?T&?./$<9k(I"ZJk-3V;3mOk^*2]Ak@6&(;M"\%IY^^)3UgIB8rk
oF&r4\-_>:.:lf$+sPA(=Y@eFY]At^Kkn#'H4a_d^dT]ANC92?)ok6U&eH&E2Pla1Ea\,8MJd!
n=hQWgYl\#8*+Y.d`ekIDA-/?6^mTI4q/Bk@u9O7>6Y>@nn?+3rHlp).f1OOZ/\^O)6Hp9IH
e;8*i;0Ni<r3<a?f'&Z_@"6W<*kB!ZlGc0f4oA).tN<=QWP(r"V5SF$r3,2@#4J,ill;uW-l
>W%%OL2c??ioh5?hO:Mln]A3p^ja2:6uk2qh"LX]A$$#f)U5UlN/0P9l!5]AdaD5>'hde6l<+(C
s7(p0+a^Z%ihq0O;FB#p]A@Iuu2l9jpXc3I5eR^EFEDag=!loq%f)kGd'gONtP9lBceJatB#q
?<`_@KKdttj7Cd5UtreX*H=afZsgnGEfnfTO.;/?RaohlJ'c#KD_h6[Bk'iAeO)P-iSMoI_#
7Mj(t7l2<84`$$,p`k)F+,u3E:CHB!@jWJh8nhFlOR(q'lAs`r"J8"BV/YeK@I366*2k[P+5
or&NP5KGb*eGiuolX8rM<jPXANFaMtI;H1FEZObi8o/u7u5Xn:-.=0cnij@F1QMuG9Ab)os\
_+tLg[g.O>(r;`q"V]Aif*N7AjjGGJ#T/W5/l:r-qs:Y'.UUhVqV8CB!b>bK?9./b,8%na;k&
UKqfT2+j4K3W;&O1o/TAu/(%\K>0XF+fSmm6jSf?=72GAUj`lA>M^d=YFPY'J;K^:V(<liS9
k2++e.LqZq]AUJS?Qhi@d,_$e*,HI9lkOb3P!"h'/^.g4Vm>s\6s.4U7eoLhJ%b"--oLIJiip
>Ng7r#@Q#-c>2e<!8bA>r^'L++IXg,QOi"C:=URC1ShdAhfN+)_hADAM9Rr"<Fg)fZ6?Zp7e
?(XX>p)##QSA2[jEL``^Y\;2DL\bif(^*1#OgUq#(%k(*T_*G2V\?_ZM&K-geWjseYEX&!#(
ds;ZFXT7LEs6Y8+c4KW't02W1e8[1G4:;[&G.Ka9qT!ZCg@pPc?]AdU1s61UDKqSr@"<SE("e
fW7*%e9">'nP6LQ8eFf>_#ZR>Q$j2]AT'-!/XLEi:,aYgSdN\7t`SjJ`+oBb7?!'bH+>j]AtTV
e@i5Yj/I5KD/1D5`)m[J"]Ao%n&%8<(M?F!hp=Zrp!tjl_"&Ri-?rZ@M`XaSsMGQfuj#)*rCg
%:15c.'@q$`W:*/Lsr[$<%#LQ`mtC-!,Lcd\=LI`T.Ii?`rd<o[7HZ-FEEQ^[R@QL56>]A?=F
s>"2oo,.E.)]AHG']A[($\J>L.7dfAF9$^u)C?k7/GmMZhh)F`h+V<=YQDQjXVlba3hQhlk`iM
r!%qNV+_ZaK)a;f<Lo=l_-eN7,5^pQkpHpam-s8FUlR*OV6INph;;Mk(\k3^eFL.KcJX%i#4
kN#0F[g9u,Fa+6ERXI>GR8Y(XPD_>PtD?L'R)JkU*[=NtBTIie-a*7Bh/*G!)mn"o1&$g>,I
OVs^HP&>!h<"WSFXk1AA2.^gbH$eeN>eE$6]A;d\"!n/[AW]A9g0e+2i@gd$.[+rDjm:A*lXU<
c@oc?@bi+>O4ki%3f^ip"g",9_5fN`b'frELHN.<o8o=qNF^`nd"o0c;X+FIQBP1H[S4YXs?
>nQ"?io02?arSEl,8a,(sQK0h'=$6hX\"Z/ho9?Z%.)SGC?*io_>su,VaPq'OWe!F\?32c*$
3auM@0fW);<oMuJ)G"l5Zi^B#+TFIf@k@(@hQ/L.!9MB%=B/7l#C8<We(dQ!A7=p[G$(/Z+J
.S(=l@C+Qm\C_?HXEW&)g[POu^qfT,8PT+_\i?*3(nGA"X9i[k?R`o@F"\+PKh5dE#)cri+e
91\Be#8__I]AU.,!;<'n@L9bo[Uc.mq'n35YN6,J)X#4&+Z8im9/")@j%+?S7ps5%/*lmoE%G
<fO;+F`NJ-?qbV'Z-47G`F/?6CdV38:\O01aXn-4Vo=nIR"`$PHIY,88d6a@:gVUAoegD`SQ
o%hClq#X(h)gq:nSrei7F=5uhCr[\rd,'f]AuMV?!F1e?GOr!]A(/6!7[mmN%QmNjQn$MX!kRE
45N7LW'B6p?9ICSU941q`"%9.,o.Uh,(M>il</G=\`s#?l=k!S?YH^n>IQ;IL=#MfSm/J?23
YkrccUO_jLjUJ*=nFbj#(PX(ho_XAO7PcCtG$41s:*Ka-4J*EAAkKbgY0CeI0AHkaT(Sa.ll
dRS>k[)N1te/Pl^)D\\:/^GhoY`Z?bl0@brD#_Q'LqtXoIJKB?aj<.,aBNKJ`mpbeOa+m'U3
m*_&P$Y"&3'L"[f>>sha?R@BTUZ',B7dLOQi;CHOc$36GS"%S>+;uDT3EU7Z/7%/*WqI$]App
2q0*J"_mtr+OKT!tJ,7'=IX<'eqabce%%I*Sf^QglMfJ4@iX!]A,V.f[?nRQ>)Fhj;J9RI]A?^
_`/8A9pa*Nu)d!&W#EMNMF!LOJ&[&VJQiFPn5/\3rd*(huqWXNJkm+8ANf0-SHm#dV,L3.-j
,Z#`<]A2mR>&<OA*uYq1Wq5WhJ)p2C']Ak*mc.naRh+/jM#Jc8$e*P6;[Qo:s,%M0d\R#V#Z%X
e,T$6Q:)pqS,-pXWVs9a#^R2PIgQo\S<LC_i]AK^'/9kU)kL.]A/`=#k@?VVY'*C(8#%T5$E!B
:mul0#qB%/joEK*s2(qQfpY]AH&WOZ6eD0G9+U,%mbeU'a,s2$E?FF9VC0ie\/ln1P!SuZel1
J%!b\p[r9Xl`@3pB5T1o-.W35@^-.KTf`\%PK#FoLZZ)qAIa\jd^BqG'$;0&@#ArE)09F@9M
-8d=_1.g44;jS["`aP[@/O2l>Q3*leB%%`TmscGe%6O2GD1%n+pA?6.H4b0?S+j%Ca;BSh*f
=X#+dm9bW66,ru!/W)mcOM*$>0Q7V;Tr%F1lUGlK*i+iSdB-e\Xb::NE=%%X>A)B8_2m*9uR
"eGu95,T-5:e$+hAQh(/4d$BnVkRp4$#8IAk_8VnUfCto.mC[GK3:86E":+o`PLkK(T@D%jV
"N!&22pqeA\'XpB3E#?lLgNKnITT<J4%M(uX8(g;N/6,Ru$+39oec_7Kb5_'<2Gd<Z=X,lhR
"RM;rt1.7F0%@J9E18[ckkKVO\.fAdh>fpmMXPn[^>^"SAPgE1J$dKfYir+]AjpMQm-j8(<`:
pqu\Clj2a-5:aqSgJG!ce9@RVf3pJ(YV??L5#2bLOJ+ib4<NV$\!UH:L"h%_B0N(,,u+8`;9
Os@L+RjBYLB3/r=ZVj2Cb3=5mKF3C(r%U<mtnLpYjbYDqdc!t8<o<mGaiXhn_BJQ[8G;R3gs
c`OBWbFLID14A82!RA5%SH.71O:&ZA`Vpoj]A&>riZErda2/WX$k#J,JEgikVl16ZsS"Ug"6F
#?.ll.UjW`h)?%%0n&njS`HPn0&fhPEWc$`U\;-:Me/==C$(lR6`E6miBTU0-<ZP1h5KC[Fq
@SU.NU+ilVg@(+Pl7V6@\5agm3-IrtXGs%2(\8<8G#V1__89(8@7HB9cRrk#P@'m,ua-KocP
Vi2U&l5.()XBS$=$_cOD*&X1FRi>8jj7)TgIG`U.8hnn_)"jl-M?fh#PFj<:8)3$OM*B&hqh
"g_Zk#"-OhH#9A>5m9Y;LoFirq`7OmQa'YeXbg3N_TbU$rVE-c3-*U+h[o0ILh`R]A)De]AFjf
=H<Yf,TP(3erb=#<H_?/*9O-jGW8[r@_O+ek,0be_<!2fkOtX:<MQ^_1Y3*tM!sL96cTOl`o
cQ)HIM>T.i0+Hgb^MHWn8g9D!fYA(9[cTp!/gc:@!U]A032B?<3Y,Yn>krYF\?bp0"J"mSP?g
A,OF6'Za3,YF+K-Od\'8$I/3,"_3G6iR$"]A^cUL,J";t!"H15OgDL(ftjJoe"q5?[KL7E2tk
,Oh>r36bOC,htX]AA]AD<jNc%j]A4Y-E#)CcgqbVW\\]A/&]A/@*79S]ASRUW5DE2"F[W?54#f%U`F
D4+rVciVWlK.;\o4;%MDpZDe(eg?VPN><2?d#m:bbg&fh4!TPq-*jhl,rXsBcb=\daH=#9E3
X2e$T6429"V?ZC,-LI#qh`"X`/JGG;f5f\3gHE'9q/g[g@6aM%HTcASlMJ/$870eA?9QMFG0
-S`bg%$i]A?S?_17t*rZs[1D!j%Xt"(oPW%@8&1[#$1VXq%DtYU$.%X4g5'YLD@\E^TFEXl#*
W9a,GPh)FSCmKMKic4*I7`un(;;`#9`;nK1'B*<;MEZQL4FaQU!A9@#'mdQao[,[^o(kWOt)
4qg.DL,rVboQQA<B+`s8iW+soIO>%oNZpCmHflqq[=Be&E1Jm'J:r@m>*`X3kPMI<;NWZ+9l
Nr_H%KK:VmoPhUEM*MV#%228PIeWR/B<.+/m)k0i_`LjdYGERKZ\3f`?Mp8]AW=I-NpO1O,o%
2+&;Cb4hs0^j)!M)mS9T'i1VfW^HFln54b,i!n.H+q^)rOBEer=fj5L7MUIPmTu;Pp-sbWNK
n)+i!WHgSDbQd9`<D#%UMEGI;-;<d$`e269[DO%,>=F'!ErHh*Kuc^'XtQ4PX;26#85t9j_-
$^;D-'PDUC'I2TVRfJI>9XP[HEK,chb94E-?5-l'[('D:dJeN5Y@:d84I6H.7djq&<?G&*%L
cdMVbQf?L3$Mt-miq@YC'HOY:f..IHFo$QOB]Ar!D4@,l[Gb#.P=,=(H0_9-\TCW6_/dqM/Rm
r&^fIj\P(YL>=Ak0S6`18QZ6bp"@dC$LGup3E?]A:u:"W=i%k34*trNWpQAa%M"i5_N'Peaf<
6/>;1l?mi@>]A%8m(92&a84sBI>^F4%R0%s.Gme18#0Nak`g)n7k$,r/*@m6H`-"c)a-ultI/
S`0PWa"2K[Y:4$,._lq5c_.Z*HT$=OF&IjRC6\++W,QjRkL1I"=X?j;tpH#WpilGBgQT:mlD
NF.1c&VFu'%`g2';UJ-7Q*\m8kT@PE(<u"=C5)?"QfGjsiW]Aps?#hMG]A^Kt4:5r0PUh1^6$N
57P0Gq9uNl-2G7T8mG`&9mcil^KENlDoI!`JT$^(4`4KNgpL_Wh*=*LQD:K'KK[$E`K17ZtY
U)[c%5/=Yb(=RT&8SRlkIuaS_R(ee"nJDPDs7TgS!edAb)Dn?f>4.UHIt?\R1)iA9,=>mP1q
d4\!u[c"*qGS#HFn^Ed;hXXnc_7Ye;L=GB,b,o1:PSYZDG>Q7MXu5a)nf*\SAuF@/a02U'a\
GfDf\5!H0/L"AG#?\if&71>DY8CTPDT7OQRsCtm;'#K=IJ\$D&o[XU<=F<eSSp4F`Kfs2=d)
2;8qpo*NQa,)FrY.5^F8<X-Dl67u/P[o^uB%2[2&)V[tX]A':0Sa=SF+q.P"-BY01\nf'VgQX
Aph'3g:qZ[hFm"]A\s':)\`=emV%#Mgg9!+8(A(IpcsfgWOL?d9C?\u[L$U4m:N#k&(&bfZ!=
@&q#)?`==&Z8q05E0/$m&'($72F_+[k;Xt%/j?Y1@H5;7_iFA-]A#*K'bIl_a=ZeNLZXFQMJg
:p+d.@[V";em`Y7>K3r/glOldC>DUX,746dO3Qdtj9EC5jlC<r+UGI3jE?l=4lim.,-h0r$`
5]A_*'_*>codmTh7Yakr,GP3@GEp2E%g#u1D+D=,hukb<)MV#ERD\g1*Z!YQe?pI[ePV^djoP
+L\-h8a`CB7$X%&O't;*//'fnQeFdb3=s$"9"+"mQ![]A(Gh`YYB4amASS\7)s,#3ULiUU%H4
\S%pQQZ66[)6U\.Yt,PapWPX;B5%c5^)t.Mo$(0Rc]ALPQlqS_I>H-%5;D6X7T=0<g!LUhpNN
X:",1Bgob,?0WMkT-A;^,$)&jN>jC-F5R+[UX<ipmN%W`<lYNpV/r8g?C#`[Mu2OE`9X;ZoL
(g"+D:S,l=J)(oVE*i*\RlF^:U^@(kTVC4pG@#jgTqg`.qVWVNMDkLgR!G7ePXs*c./l:cNZ
48LR-,onEI%E$NqK8JKtQ.O9_u#Z6CgIc3>?J*2tS`/"QQ);K8'EaC+b4o]AYOH2!DDi;lG3m
-asXC*!fh;,\;s]AcDMj0VjEI/V8Whf)eQafl6H>#-H_p!LpZ<%A?hTS_-aA*#9<5<Op(VcYf
0b0?dn,ZI%6^eiUtJ2D>O]A#@`oGD/lf-`K#;J!(X=%=N3-KsB!TS2h:a9I9bS]A'AfIs,Z2R$
9=?fTjslD*gck-i6f?r<fW]A%DADp7o2Q?eP5)f@#(I3>Xe_9VUQ]A@3a3f;An@$QQLs%d2de-
nFlgP1AumM]AWD\.qP;)c$ag"&%QcW3*juPp2+uQIT]A4-=o2dIDV-7i&Sbo!ohWVA&MktGk;^
in.=`(:GmEO0U06)28BInnG<K3(+LV*=Mk25l%cHBS[hblB_O7%gnFfd*0_a3Z;-3[)K_P<,
N-Es8!M-l^8'C35<6`l'&*I_V(]APD9C4tJ$BqI[a`?lU19di074amn1SdCB%W1.EEuF"t\bG
P#G9^/<#njM7>J:T.jjo/jJ_R5&J!HA/e0+^-[WW3?t2aV!#)WtGkdVi@Kl`N"!J9&FWZjn]A
P<WP5uf$>>t<16!lHn4[8X>4'2fM'oY=Z?C4/5OVlm@h!(TA<")@-Gc4q0ks]At;Va7?$OZ<E
a6#LCAQ52;pEh?no')7H8>-tQ#D\hurBR.n_C5CnrfGm4^o`8c/ITJdYMt8_AuM\d%0$D9i^
dRRITjLVX1ilL<<N4Qd/@#RQ7JJCB!W//%)hObQX7^n7b+sONYp[HS@GO"iuE(^'eB$*ksSu
EC"2?&l@8MMr2P=3BPMZfcskeLaO,nfb&tE]A&K)5h)/YLVibhr.cpc4;J%&&%%rAp"D5"t3D
'Y-X/#&[Wd'.IBTgK-g&P1IH\4e^UZ-jr\q3:-ZXCjtbN[Cj<h%B2V!-cJ8nGYdY[]AF!#e(U
]ATJPmS^>t=2X+!lOd^1?/9#I>[)__M3%:Ja08rOp;ghAsPWLGA8:_0G"2C\b/pV,+^^s05e8
Jg*</(8>c)4"`t2p2pu+/o>[Y>K(EFcBl,oK6^3B*Hb>lA2YAW$C<^X#g8fg2WKZC=+>T@n`
*N2(]Amd4b(17A&ZLVK&T":>8-C&916P>7mD$$#JtRW7%Q$dk,S=:(7jTYkYk9l]AfA>YsAeN2
(<>nJc<f3dR`BU[Gb(7EI+W0@N&aJIdYBCI%A9qOW&Q['%VZdA@=):d+QD16*`2A;I-]AXLi6
8qBL,<X3Nc'Hfo0'g3l#]A"h"0V878'9'!bJ$fYuE2D=r)d9=7N$]A2k_gc?DmJI`kp_HrPLYe
AS'iA-'8>pc3s+G/Gjjg!Z(;9Mg>fC<d)!C2`n#bD@"V<AkIIS)Reus6chZ9m_WYlMh/GskP
_JjH5YqUm4q4-6=Oh^>a]A0"9h%N_TONHl9BSROrV[T%s#>#r#p8*JpscsER+Xc'rZS7Z8Sa<
ptr>nOmfEEW&\:)k*\nDA-A$\c/tQn_/QCYLBMPH[M9?>P#,rI;L#Daa&m/8IX8#''YUM"Z$
+lp'5D0eJIQ.XJaVkm1Pk]A:%,OK\7.Up;6R+,6(<fmCghl)Hd>fSViQe$`$#s2WAUpF,FWDj
2fH>AD(Z[$iW#'p:p96GsHr/9dQ(YM!^<;e-GtO$]AB5A/m?<im5T(&AH-ie+YJ>)6,K?H7mA
O;iI"B59dT>Y!Ol,SW.&0O8cM*P3BbQjEV)'&4aF5[GKlr)0CH,q2,EFJ!"n&888JJQWN9L3
\\qn9s6kEAJf4ZO1^c(X1u's5^6hE`(jDgPcEH)tpqQJTX+Wqo.#+u5,3]AIM,)67AiP#'RP-
$T;R[DYrp`Wu\'dQ03I/B:kpWl.RGGS@FU8JdAHlB$3lU,6\\)"#r</C)[[nL_NJ?Ceaj]AII
H2;>kETL+)lF@.6tpCcU0/E6a#6;"lr7i5k.^K+>30ATmsf69:gb[r5cdjnD3Fs(]A3@r$BI-
Sqm5O+"P)eoQt=+'2[!B^5\#P'=Yb\EZtZXF5du%\IZJgV0IgPrZ;,fCp%U]AZoLr78$RGBbI
uh.1[5XCiX=!At88od"dZ1,23'h]A8+J>=,!#bNb;*4*(P.EDVgt9]AuQ,lWWrb59Znqu%OH%O
8*9HEg?6De13R*2]A<tuU9oi_f>M/WkW+C-:A&14$ful+@%kPW[pZnu5X:M3kBIM8TnmDLlp/
,=b7h4=IjTt!U[^Q+C-LD%WFs9=DPd+p9afMb'F0l4gYHH6emR<4E"$)cL&()Ujjc:E]ARe:6
$G*(/(DOsAeJnlSUn4iM$X^:6oi$iL1EG-S5BE(nK[##4ir?/*l.s+/EA?"TlaS]AIY216<,n
03*fZ]A<l_^4(nZ7h//6LhuEV!58^9AH4u@O?u2tnA3/9*I22\.<pU\IAd(+k<6>4M]AR/E3'N
]A3R?b+$nMe2p&9."F=<b1Dn'7_L[*.lG-WNq&OTE\j&oB3t$WB*`QiZucQ7EID">:9$"@-Ud
%^X$Pg>(D7-WSrrZHNl4ldEkSo/njZ%2qHM$aK2-XLuYLaUQ"?q<L6Om^W$_5Z%9jXP(j':9
g*'3?4aEVTSY&5fa6;>a-6qZM\0D_2,pqQDh^65n/KaCGWZbT<SQ9YCQc(qUpuP.4=PQbp@`
r)&<!AWVJ&Oh>YZ^6j3L!3iq6Be!R.I[h2*9>@J^sNI]AJZ02T$Bf!"bF<M_,(0Ds2r"9CHLj
%Ba>m+S(,EBSOj!^<)2/WZ5Y4,!5"XRD(7Oi1$T3hNZ"Mbc7UVSFFsY;DH%;+?0FQu,6I%o`
I:JLTHE.62NPIc!Om7#sJ$\8Q*M:PNcJ!F:*RL9J$6b\Y%p!Jc-V[]APg5]AT$Ts^A6+7RpJSb
f_KcL'A0r_Z9fce]An!8`UFg+^q>X>(:Grh:A#"4N1^cDImU^&]A)4ZT[%8<:0C$nClfLq+.<V
lfK%k\=l\f/IG@A^R>j.<ouS*,G-MP%4XOlB9qOr89E:&U0PGmYJNF?0s>%^e2M=M-"qqNoI
+M\^p,rBCI@fn(X"gL78:6*:\pd"V?U&lO#ERjg]AeVn4tm"T;o)Ahi>Xfp(^2A4RGZXt-IH6
8s^8OV]Ak7bl*TMi%LE_`QT4<@Mm%b'ghT_M9,V4h"\W"!*5Eh't\-F)jW)4ZQaf8(#""caGo
9<!o[c!i_KX:B(0rV"5N2X8U=CAG.2fuV"AU'JX!r>@<WBb_$Q$Y$6*KXVr7FsWC/llGD<;:
!+:s0O5J[2oAlC*TDDh!1-c6t`K5g>UH]A".+)Wun/Le:G]A-pta97VI''?&hb(m[E%`.bAW5U
=Zi.Y[KCjSH&dL[.o=gS4gED@k]Au/G>^_8&gtq>[=<5-+`A1?fH@E'N\,V`f,rBegYG7)4<l
2FI(OQ:hVKbW^8SlKaQjn:5`,TX8`@j&P+=7lu%D0fTrl"=C2Z1nC@2]Ar7`t0C;NjB[Q&BH(
*t0gO5FF7$^(>j+Td8A<<_j10MNkC<&<r8dKB34(Qg=dp`.k#n'XubkJ/AZL[rOIcjc#!Jtg
f_G5$%Sp/O@GgYXut<C24I!8lk"^$!a1$8DabIu.Q_#o)$D9.<4e(e.]A'8t<5C5G.BBp"(85
SB>eT4/Q.Sf3i3K!_jq]ARM4pU''&lV_L=^>n"[j?XO/7K3b0+)VLo?GHqmI)ZCV/-Vst)<GR
*EXM)JA06##b7q$%,tcja7@,GtZW#>tD%Wo8`[NAsVD1_RsYcMHUB82)/Qg+;M2D*PUj9:]A%
cJf#SNU>>=nk`EloMb*N]A^XjkMKZc,YH&7Ud7O3h7A<qo"hdjgAN?Hc5"Z=K$99>A%=eDBWp
-HcKTpS3I:!Bj)?-PO@p7*Gn^Klm7?YE$OGgr]A9I\Xl90;%njc1]AQ2.)XJHOW,;(i@I7BqJ_
AWWH3*[ZAS\=aMmK7/2#oSMW3M*TiCh\pKZX<Glempi%9VJbHDr]A-]ApBSG.BR%Xncljs)n\Y
An_8iP8P,/:%Hojj?G2\k6:pK8m["No%R(CV(0@IggBW_iDq)g_<:I`Hi//p5?F_FMh96WI'
=?4[/-fkMtJZT0Du;eX$2C_kJG_uh>ZX+"Z2]AJbRcQCD"`Z<T)+N&2DEc-8B6CdaEW7c9gH6
oJ$e@ah[*]A*guN(22qD#=(^-Z9-b02Q$N,Xa/NshkiC("WqK!UJrB$$_itXdB-c[NqRI$@I8
q.PO;h6IJ&g9`<c@7j8N[J^]AY@M*s/tdL\:3VZs$C,^iO&7+3p0qne?lC:;N>%0/nN=Sq)uA
UP;dOs_,19ITg(M?l[MSRkf2<[qYomUX&1^"ORD"Ylkkt23On1st^B*bpZSBQ#LBmaH'G7.D
6!9D]A87<jca8(YJ6B8Em_7dUdLMCE`?7g7DK\^qB`BS&8;;TbAisL)ipeQL&@m[(t^HKMhcY
7c0q@Cujq"k(tD[m=F\&X1h_Dm1crX>%.[jof@!LV9&TUu"t9g<<2)>M=cRYQZGFFPY,$c3(
ep)Fi?H*4$hENG^rc^)0D0??e&7<7]A_6"\X<0[<mEIlrmO\0L16BPPf:T_Wf[[$/:h:S!OXN
k%OF1KY\pb+(8`50G&OkQ>#/cYgYlO0k1h3!<1p^[HSr'KQVbnaPr2%*J`(qa/N8&NiW_J!M
B4pqmg\!VW7Ff91:\%jXpHNXo']AT4jGu0%MT?h06X7C#4iXliq)sB@hB*"pP!/?J\lWk%>c!
D)4QLeW+:9:mpmYEsD`'_3'4"5o);h2/"sl-@5+shfJJF6(*Z;O4]Ad9it&c_h<2c6=1\Z'%m
sHj+MaLseuSuaSPL8ph!=p4?12(,R;s:4B8)/R55[)V^#4b"[d!B[=(r<5_I:G3O*A]AGlOR,
(SWa4gqJPEqon9tNf2o2*PDsT;j]AuT?$`.IS3UVf<#<2$U]AZr@#I,8:!YGG*<s.tNX7Mg_G_
VsE=-8'GumHK]A&oa,2!njYY$:-*=Te`C7\PC"c+93-[ag.m;HUlkU3X!=#`8<$oXcCtiG0Fk
mQ9hm$9Quk)kg!CO[?&(<Y>XhAXN<r`:$%P^^5T._KjpN@J2#e-6h"`OIjNP;nO<oT"ef0n;
F0&(GX#+^E$s"?nRnC>j5<h:.N*CrSXDM^^K;G58CkqkZHYm_Qj,:a43#VRB<H7,O9`P.-j&
:d[jbb$T+kOYq@oTVR&99QY\O/]AD3BA-Kk\pqRakS4UAG0_(Lm>MkC`gULR)LcRId\`YrV6]A
e^#%)eo6`Zmce%L)Lu'5hGV.MJ!#>D'8,^OO;s7?m!Yn*+o$2UCbJ+51CM@0j]Al$@WQhZHu]A
$/BZM]A%!D;`[@"\6HoX>5ptdTg/0X4t`LoKCB>sJ^RmGW3S3P<Em76GR"$5e)bYmC@!Yss1e
R%^`LETf(&_\W%7*#;m!/`AVEL$T,d_cYa*12i8[6tkpOAP/416uJ"3;GZ2:\(FOA_?2IadY
Hc)R+3HnGrhjcKSrpDtmSoLK0Ke4GOK`8dTeK>hB5tVcY(RYPNk?NfA;A:k7DH#)9"5.V=hq
7@6@NR@I/%['P>`egB.lHjIAm1ACs39uuEA)AUJ)atk%@7(1"b)^9]A;OfJfhtS'`$ic\?t>u
WoYR6p.[*-aMt6oI;Q>]A5\qV;"r1D1>Nq*0!7f9U/*b*e<cKYu+_k8f`koYnuRK<J88KF'$4
N0Vor]AUj(?]A7>Pj>7PRORp*foRCR^o`f(327um_?2S[jr,:QIVo!?-S)?X]AcG2;.dSTTp^;G
F\WX#p%AdN`q:?p)2?/:Ie%=,H2MR$"j.L.(T5J1E4#P>2g_h"@tI!pLXY=BD>GN(+=g0^n$
[&Tlb*+j8$B)FU4M6hsKob7=XbRS!q><]ABr_IfA!<<#.9i)GEgEM\.Rn6nDDDTFWW^SDp'\>
R8B1WoRP^Hoe^E0@gj\$;%p0<=GrXDu0ZQ22>n+:3Ins6$_8+Ci<n,[#BIclYR!k>#j<O)`\
IJ\HII"XZOlc]A>k'`%5fos!(nCC%d*,"9kk9N;C.e&%PaKC0'iE\2('gWXAYGEb@$'F5rB:G
Lm18EnmngjPM6+M.7(El+?tDq&eO+!0DG&*4rZqNNo:&r,PpBUh%9Le6r?0>mY;^kClf`T'7
Ko<[gJM+ZXaKL7#qt(ME*04SCMu&\&$Q#JNR?br<rX'N?!m5qP/.:?l3`o5m3%=MCc:qFB![
K*KIZrjoSZ$Y[k2%rXOIP6CO:;,OV/Uu&e7,4\3dm-C$UYMoRFeH"R#6n)t_^$pgJl>JK@@#
3U=U*2`,aq*p4?i`==j8[Rho:eE2;<0bGosS^>pB<+;be)[Lo)nphi'VbGR,^bZ\.3>>\@kc
;hRN.^bjpd0"7CRU53,(IfP+T`.'/>k'\o#7%U6LdWiVrJ/ls@qH).8/T2,FnThuN@BVd+lJ
eZ5!IVs7S(24DYUHDVAHTU>hcA]At9eN\ud!9t+_r>mdjLPKc]A/n6M0Ll9O-=[l6sGYo[]ALN`
/ngeN9E!7Ycn0@5o;L+a^Pr+)$u5M>HT"3m90qm']Aa;>/;_D<X+^NQpaCm'laBZ)uo!lj5"s
n(c[4"7Z-F>d@a.oJRl^f;<,cCUeolGVR'g\CK"UXF<(XGg5Eu!Js%h^Q&B#A)`^"[KR!a[T
\nW1.q/NgRE6c`F$;cU292/AD=Q@EG)aUr$pHI%hO%67H<(-V2%m>1q2_"!,`:ecA+lqh_O$
E%X7\L$%K$$Ib09j/D(DbICsgmX6i>TiN3dZDpE@;1D55k7PC=cfPoeFX3-LXmN^]AlDuRG-M
iAP3F*S0[DbQW[l_ajeq@(.+h),K=-4DnM9N9!__BoJXj*%!NIa?Y?41XeM9jB@MY-LEPi1:
2.TP6UrCqGGW-*XL^Da6H,M@g5bpA`SZa9_`_K?&n]A\,H;)@j"/M:@;!8k2G&`jBetnG3OMH
_mUsPg%'dhKPcY9$"-7.mDchLgBoFcs6!El$`%qqCi^92/n4cjcq\D-Q?^'e[HMKkp;Ojj?I
T>m$]A2rA_InCtT/^F+TtAQ$oX9]A3!'c0a\*5aM??WE&le7J<bDQH"0-POj[l)-EB$9Ip;-\F
g<(4BX(;b5RJ>).9[KVTi-q)0@h6W*k9"u':)7A9/l*;K%^APG/L$t>P.R)uQ_VcHFNTXNTa
dh%I\DHbk;o``I,$Rg9Sh*ugG.[QYK7'JR&tH:pit#h0e+GjcK5DT/kPuh,aqeucjE;'-cQ7
7o]Ak[=h[oX^?_tSjk)sI-:?A4YgE8B<h*'UW7KfpPTi-$>UZP<jPRrWBKnM*:"+2Qc1gHorG
Z=h$ak?"F0b2^2VgHFMs,A_1.<rqTbo:J!kQ-F&J2\eTU\d,/5]A5,c#d7-:Z,e3jAJ'J.8G3
JF6Gi"V8&h%gE"igKrf]AH\:nf\f.N[X=D`:nUYZp3:Mci<V&7,a@)_i>@7o"H[j\GtDEp:fT
2h;iupA7Z]A%#QO7F5lc5A#+\gK\7!#GVcU:_1\Z@NEL$@sNER3tFVtX5_nWoWP^Vo'rmLNn"
JWt%]A?d,H]AqSaYLRh._hMh;:/Dj"h!3rt1i&5BDZ+jC64T6illiCAnme1DZ2i0p?nI?f)Y!V
"&bCLF5JEP6\V1h=RTe2CAndbl7hW+BAfBZbZ6+G\[)O8>H<,iHh^M:4MWiuku7p<Y9HT"LG
.iL[_`[%u9*4BbCG20GHHu!k]AH57tF-DP*7\`_8A1R"`Vn2<@^6>PTm;4qgZZXn,!jk&d3$0
7cg#k7j,MhcW757sa_?f9s0)aKMacNVlP39U$W>C/tu805rXe@d2q/*mV1json299KK@3[9,
/&%:8;4N$=^N;%RClY1U`WG^f\o6e;Xl\OqlY8OH@.3>N:$<Kes10,_!"Z6nOKQ&,63MAOD0
nKi'J)98<@8q6g?F('4-nD^S=Ln:fe8OscrY!B1@X@^P'>#^t^qpO+9`RI>?^^iG[a-KjL-*
Zhc!`.4&d_m!J\__t[(@R$_,buNqY#.Dq#T8GI1lG7\_EYfC;4"%]AgDjYH-klB<-[aejWB_]A
"PSM/Nhc'D&=:DV*%U\5%,Fj`#W-2R46tm-?<,F?iWAF`%3Zd!hsnhYQP*)bH.)9kP3;Y:pa
\ce3TBg+d*[&<4dRM^-KdKAW03HuKh'lGs3@qcI&U>_6fdWRb<k\Mc$R<j>I*rb]A7;Fj'<ZM
jG0gZ![IMsUnARZ64)JlC9>+HJK)J^U+j@)Q3KsCEeaK-\;/kF=]A2rIMSFG\LfAmG:Bu?YGU
)DU6p2_D&(lMY6+"M@e@CPORoiVAhc&@"/DP,]AabkSSC0B%5M;UQ#:!lEL^hq]AeY[V1'!X9.
dQknC1`UE<9W#]AQH>Kt1m5IDpfB6VTIVf>n9>5b]A"eHk"Dljb.@d#%c:`hg>0(`Bn0L,bH9Y
'8I6YU5%.U`!Y)`=4j8UG'A#Lb?a.b#=3C!iPP>36P.tZ$4GWTY7CLd<968>$8]A(,E?u09\P
Js>q:`Zg!B?!jc5T5QWiC3l5N+Z22Z#'<VT#9`koYi=OE%a"AAV*_o=N"Jb*$K`.XgHo&rf_
d.a;\$/#CSC7:aS"3PGHQ:,@_OCEnVn_INSlXooO@o^0+]AF&+[pA-qU87]Af6dd#bptGpnAl]A
6LJ,*i^i&J(cNn?,8nnD5<XrGs5T?kGuj/nhnVp4'<5#F6LN<N$1"'f#_%L`A*##qi<f&nRu
0V8\d,bLZ>C2X]A(^;lh/SQ*Z;$R@M[i!Y:.$OeMPl[R>L@4C5SK^8+DU#Hhs<nK),p!<sO'^
==bMFWF)@p?_32mr._^Te+K?O]A^i]AOg/9&`m]AAN\GD2*$Jp)0kI\i;,m;;B"_!,No!m3&2r9
u:m5C_tn]A<7PlHuRCpPPK5N"0p7J3#16)0u$u,rV.h3kEtperDYD(E(:?UXq\_(*=eVS3XNK
LHcsH:JQDE#'VU*=AErJeU=#&DVn&\]AjGlFXA9+7FGLr"^kQt,cXJkRM-9\.BEgdHnNIG:jc
=3UOL;olKO^\gl"%J$mg>ctB73LX(q&qt7hchsMoB*3i]AhJpYY.2">[_a1is.%lAX#A+*BT/
.:<=`I=mrl7?Im'd0r\tV&l`2WWU@.![O.bXoNDuX_A+C3,7Br7.i-Wb_Ep%-V.<u%B<GtCX
##7%Z_8n[nRYQ9E916X]A[U8PUGb\LUg;VE3$hL:koB'7FQ'>TL0J)3R.7CkbQ1W\'?Kg3?4H
-a4\[bkT]A[GR+EIcDSc!-^h)NV=_L>s&E4AlmroDgN9IrY#.!(gHgm3!d[dU[-<qJ+[>+/i-
eSD3OC+g0!9FnW@JCA)_R*g1Fn$uKP@a]A".,?5"lWb&*b8NoBDR)9WlVFn0BnRYVuF3%=*as
/9S!k4/ER5K_\\nDY<tEr"[fr?O)'30"uoJ#1BH]AF0=3_<KsbqUGsYT:574dss@-_E3Z@#rp
XucT;,:NEk+FCcrNYAuqAiggN,5>.u>lpRq?):O=Xc*"23&CpD@cR$2YNX-ZB$>-S)9c>*\,
c[Bi5Zu\)ee)7ZX06GU[D5-!d!;>]AaOSc5N,sfH9"=oJm]A"7"RV@$6F=kp[Z>YPl]A@9k5Ra=
/@I8$F<bGF''uBjR#6+5SNc#<;tKnA+=thF)E)h^?KG*.9U8La`ZE64;u&pB=8L#A)VY%J@b
!c1Y@'53bC<S3-qGQob\J_0)W3+*-Y*MN)q@'/^<an>R9c7?K[)B[k]A"Ikgt97YR%c2[7:.'
jrjNan1FZFDq[1g_W?"S&8d6D+a/p`,^6/blD0[l^R;;O,)KN"igLOZi)\H,AR&GK5Bt&7Y2
9`-`Qm`&ra4h>1\?V5T^o:552Q.;BFriaa+T$FpgQ7(^GSk\7Z#e+`^aUCfrL0W/kpE1GrMo
TXQ<:4\YEggLE&`.bCL&P2$$;6Hg!-X+1;uM29%,ic,$00KG?=jVd=ZdFIsuV]A$kA<PRs-Wi
X:,=+2oiI>uWfiK#TUg?WK0*4sRK0^`]AdR38DCYL4b+Os$(i58-Vf&L'eID:OXamtBq,a"6.
_r7R#)[km<@V(41fQQQ#3.C>Bk5EbX[_OHnSb=<1m9Qth/j.1%mPthiIpC_tIJF3h0%U_)J@
0YLCa2p,L&F;0Q)[m#""\G("X,r4aiP=2TW-;M?Zb;KS;Db'2qU$FrY0!Z6a6Q$L)b.@,Mil
"V96CJ)O3+#0M(C=kg2??W/,@!KU5"6U-aP".I^O:$N!"`\<^cmk*m$]APU%.40L"8$o(s3hD
[`W5Ij8RBjP%Q/Hi_nf"NN^RgRo#/#L#$eA3)Ve9>?%<\i7eP%Mi0a?0AeFP$,KF7"p9n?GR
,]A^U7.pPPB-8gU92meFTJ='T:FWc"\IkAHqB@_+@cm[IQo5rFNelrrrq-MX(F<RQ^a'&p=dO
QTAC#m9-f2&FN5JA-YEk,15a3<B5Qd6NX`4B-qR:;;ZSOJ\\]Aar]Aa2S]A]AVH[FO&M8@;ab\5e
B'4<)<>7oS4!,q6.jo`LM'Z7&6+S#Dqn-bL$@DCVEQ]AT8H=[b6hL[G1Lu[m-u+\tSF^)?G2>
El$[3'OdnBj?Z@.@NiQk$oH<[@l#g,<VlQ++=S5gF!hNMR]A*C:V3ZW5Sdb%XVllCYe%,R*k4
)JdH(a$6t9`>H%9o$pfU<:RfAGRkQ*q?C,qk&L7?KJdo%CU>]A:jsNRb@b3;WjL?J1pa#),o=
7+uljP6trXd^`MK!lZ/bgX9>P+RhGA(^3nU-4Op53ACLOBEtkmOgJd^'nBl1-@G-2/!YC'n4
flP'_+(0r[k^%_Z9kJ(\R20KDP@Bm+U5,t7IR;or/CE0OS'bltJp;Ko#8sd;D)onD_C2D;?.
\h*@Ab1LFkE@]Ac\,Rt<V5U3oEV_/eS;m"N6A#pE@h35Dg=_sDlf06]AT"JOB^H#Ka6-.ucNB`
KEBp/j=3l^%TGdcA.AX5(ZcZ9$\hsT,G-m)\]A71<b2s8NT!DrRc-q?f:\g]AY:KbQX['4-V-5
<R_:2d2%:)73TjNTt/3"6b4`HSH15'(M0cc\1AJV?P-i^Q98Y7'*6E0C/UN;`5O[\7_fDm!o
TtrErok0YsK#)!=Y6FB7*SHHfm0q,&6Cs`>qPn?#3eRfk6"DH7$XNSA'5.aPQauD=pgQMn(K
a<_(\W^7I'EgXlKuplsMMaG4O*;9c`?UJ__$Y<.S07oSeTa4t.$SlbmrPRS@9=qZu#*-iRHn
Y.Jtb\X#M5Zi:dV822tDQJ_=gU/Ge;A:kl#s5J?i<UEMoN=DuYR?W7_kCK.iMb&0JYlLU"8h
>seP!kLPQP:iPL4;<'8!(j,?LTf;U%m4`N7G:FfN#O`+]A,S;"DZYohW?`+E0<C(EVpD?ApZP
q;[]AJ\8%9$,gF$!-q$g\iUCD;Q]A`$PG`uU]A"6HVIq*\@1L\$ku#'reL1hu+MpkcnZ0<M-'Fo
*(/]A9_m,3+@?^k9J,7IA<@HN8d=K/)j'fC]AJFC8m5<Cmcjt,-`V+p`h3'Odn%,Gda1Vs[KG5
/<AB_XR;RhS/OD[&Bk;V]AmDZOXH^s/iRA[VL@!Zsj4Ef%fI#;Mf7[f,j0RmGp0K[[NFnV)KL
T#d.`NYM/7eW`mCIhMdOQk_jJL3mLh2:('-3^5S:p)JGN4)_rpg[QYG4EI-^2eB%d%*>G0HX
jK9QH0KQ&!XQ4'JKc.ki1<,FHV&c@&ju]Ao=C(GMYoO'+2JSEagJD#sFYup.VQVcpf<M+R7uI
#YacJW?-X!Oc2-U1CL`i=OF5NQE$rlehD-BO*Cusi-Vlc(;s1Tl9@FYKPHFLlY6pdLI@L1hc
fLsa49d,ei-_f>42#;gDBXO:4XtmB"cUhPP0;n+'s2EI2!u[,MGM9W7X_D!7:M0i0Ir#3%Pn
M"M,VD)L.:fh+uO)Oh@Jd>2eQ^4Y@nUg'&qJ;K.kEKNtT-i3/XXH-M._iB"gic>qG_/%B[[8
(&4i1bP3icTbETl:,Vgh^Lh^Y8^;5O82IZ5/V_\$C5q5%8AJb,[mFWKr*HZ&:ia_?lu'c!\C
1qZ5\[`:3tetE&s'Eik4B\9+d$298TkhEJ2WV;YucBRp#9)GbY.N,d3OOFa/(g[AkIG2:#Gr
cc*5(OX0VQ11pHQ2+HC<[h%etZUSTh)n#E^`EYhFW/bFjVTNMc^7cqSM":?>B=##O/AR-.-L
L[F`2_)6[.1i`0*e?p//Fkp<(r$`h@=XKp)UMdQ(d/VZ-Or"fEYalD*gDs^Jn'8\+hSfheVj
"-KeM1I!tuVd<orILMfbPe21WOgp*5i+?VKt@MZhm!l0)HF[*2SF]AdQIj=[1o=1_3_QBX,a#
W$;qbtHVP!Y=6E"sBnWeLS_W!>^Ff0QMSL12%HO6gl'b-Qj4]A.p[h*oaQD9btWT:Yi<,2*/b
`3`6mS`7PHJ3!D!]A#qT/)BTXDFRPPot6qXh7M3RE/UDF!m8;kefmpR9e@kd&)pB@X*c&XG7E
aZRsK*TeBIF1?KQ>j^Su>.c9FFg[",Vf0s>#c7nC?bpqia2qk_GWeRFF'fQUHJoW!iD%.\l-
Tf9d0ZcoQ!aX[>%tZY55r2JXYW-r8T,V34PZ]AG2]A5\fk)^m@l]A\+pDW.(^pa<n9hl.[Fg(AO
q$F"*_gG@)k0pp<[gQE7tmT`lkOnX$A@CH?,,&>3gT.E>45;J@FjVrSaG7TKA4JRdednertc
3NoX@9EZ1#-Y>kPO=Ja$GD,LC)Z5k"=s(&*P%ap*a0o_RCI?+8h1X14[7dtflZ'5Ytt(N4[K
Zm)LM2O#:NAa`3liI.&V>(%/&DFj@A(n\+%GMEK**j4T;3`'&*"G<U%)p@KcUgY@=/4K+0i-
-m.po8P[sO\kY?QL%h[LABftO]A<\@t<N]AbSh?FP=OZL]A\Sd9iB(WUr>$b#LO&DfF"4rfJJAY
UF--2Xd[hBU827l/<GjooV;7!crBibs@(Y-Y#=mr'M[ST*QQJSU?+ed3+-'efd(8@3=BenaB
qD6q=:J+rb>]A@+6_4FDE39/M^\@?.j6T?do?=jM;:j'?1"U%<d8D^+M5_4-N)7q8?6J,!TO$
u7=WI&MDBOg,msfMo$]A'Cs42B_4...ILM6<7.]AAii/2pEFicK(,f(/@5V!(;0-RsZLR;;3W)
.O3jU*oTc3n.`MfN7*fE\[\k@Vp^A?&OjYDW1GqaDIiFb_e9+@'+Y*g^[#;Vli5'n8GJmH74
Sq:i",ko^%.21;UV#sF)cS<Z#"&1^bc&K@+D/(+q-<bt;/A4,8&<;1[P]A)\u-3"[5kN9I@!S
ZT=>jk<-a^]AH5dSW4"!@ciVhD32X=FU&1D<bEg3ClG;C!""Q]A&)V/cQr!ar.Q%2.@"ip[gUs
@+WheWHThL^5D(X5Mqq7g8V>ZA;^)+NDN8[?Q,fQFlS0Gt.&I(>$E1ct]AGDHkq-')]A)q(!Z#
e6//`-1AohH_lEB(pkJ(r2nCk&5up4Y7^Y$C9Ln=1klXdrFZ0h27]A56)N%`ckkW,T#j>n"Us
ZP_UmfV<*tP3K:A'W5JE,.39ES)Y1K!CSFH'PZs7>B^#^Ko)D7P;n80<AkcL1Qea0>.3gP7#
GrOfM^\P\+n<:IXoU-,^5RJojV!+h.R=Ih\I9YImRfd)dBrpW%jIh]A-!0hDZCk;-p%Z<SoO_
DQD*4)GId%H;iS]A?,;e(21oD9NM0.uq*aRM%E?Mfi*h?C[-K@6Q&FSK_6j)VYTDN4^Gi7`pe
<L!Kq:]A1P+tn[RFmd;LQA2iZS8Rt]Aal=bcVhB;2t8NQ6\@Xa">cLD0&N^VT<_p]Ad1"Id;A:o
g6GZ%N97r/HF(D>F<Z$.+(CO\1OOGW^crf)aYVRH%Q:b#q8%M7$0#F(:<&.+JX'2Mg'nHf5r
`JrOVlkEV_/ah)mI5#F"plAaLJt/X;GdKpl=cC5(<BP3j2uFMkG\3Y7u\@d1@_c&"#`-$lMN
IK59i-Q#6f#,(pTa_tq/)[T>XLZF]A.]Ae;nqGior#G0.'FJ3["5fY)kcBWDW%9<.lf*$.k<"4
'lY%c#l^`#bt?BijGGZVhbeMKW_*f;`PN<,ra!JCU36UTah0"^-$g!b#*5[F1lA8HV\bfs`Y
68+H(Jl-TZ7EZZsF_3LklG5Y[gFK/pl4sTR`ki@isk&b>\FqV9XL'S:1nXILiVQKTIMd8p64
skeeaj0Bmn0g;ajJ1*_rG3V7Z3$bKi41`^rTMJ&HubZ\c=A$7?^L;"6=k>*Q'U6o^JndFK*S
/E<`g5_4R305e>gp_faO%!G2soA]AplE:$pA3TVtgLiFiupc6L*,DAZeJ5I9EE!,eiJim'C/3
_NhIki(//J<U[,"Qe:SsmAr'6r!F/L'H07f7)lb2o:oGM'*DI9)5_P9Li?I8G_?AZ>6'rkTk
KQrA?@\N8QO9-o(#@V2-OKnkJsos]A&SoKR4Kb0ngc[IFs`H9rGK>ep1WPkRJ=U[c*F+U3K]A-
K$A^A7f[BP"HF&f)"T;sOYs.@rnOSq]AN/k3qc&n_X")QV\V&s[mq0>a#NZ+klcS(P^$HQ#c1
fT'=9_$r59S,L('bfk"$m)";6_=;L)2ZMP0X$Ond&#?,2L:e$O1O<mj`sUYR\U19fBle'8eS
<ak0n#XpX5abfuF3F>1ahJmi)H<>/q:t1cP;``.dO[Qc@mZ'F6%=9ThJgrMajMqb.]Ab0$Y8%
9C]AZ:!8Sb\?BKhnP/lKQ@L2]AoY-ocs`)p/<mX%i$)4-&7?5[GK1gfBblC`4<,6H#dCUc1EIt
_ZSpR!`idVk$=S4<Taqls47Ocpon3pOBW?fFpI\02F[^)8e:@I`UPD$psD)d2-$Eo,n1FJ?<
e#<kn=>:p@<FYmdlRfXX;rtGg>mA^_bWQ48_no1;l(DZf;NT8L6\8eBCMlG,pFMq+<?'`m3<
a3(!I)oZk(W0@4R.?5\b7uc5FG-[ki(LXm`5a=3brZ@1oA0gK&h0p;KNb,c1[6jGlg[?U9WN
;89H"oq.;KqqB+-YZf8LqgGK*^k>ag\,pS]AV70mgIk]AehdTBl,AeUG4D0nI..iNQUh"9\)?!
I47c/P=<96Ac/<2'YtVT3&3l8"'Q-S%DiJ#)P4TE3VpaK.o9NXf[a5Ab,aAZGS2+sMNSpe'Q
P<,&Y>M=A?ea6;k_NKQrU!_hM7OLR,]ABkmL[4M"W^mU;%/ttTi_!3f>2M$+"b`1CjRti1tge
Rn-XNpDqML[P,d*02%X3(SEMKYS=:8"1C)\HM"A$.4Fc3`/fc(P^UV83h&]AO]A[jNnI"C<E01
9?:jOa?IN0qQ0HJmDgcU"(_^SYV[hg>`2gW%0HgcC#JdTZkoe?ce.Y9i)&u(d\Iq$RmgQ&,h
(oG%XVK\*5$!f%/h<'WO^f$(Vo"/\Fa[)S3H;%G-r-.LM-(ZQm/P.j3m$g!1cr=Eb3/[IKOh
ObkAXQ/D>5,9hlKOL^drE9X\86]Amsn_VK\9a.EniHDE!$r`&2f"nF]A"Xec_`Cl6u(.==EeY\
"W[W8m;KrCt5k;8sUT0f/SW1n)is-)jrN&@_g!)"a5kountCA7MOr9K:^k2pWui)fR<2BY^n
k(6%IW+Hp1?:"kI`_MaM57NLWCEE<R+C1;N[W`C/oCT'[d#dnMSVWlr<b4H'i+6Z,F']A*-\J
#045es.+4B&RI&&6a8>#?20oXKrHlO?"8o/oEV*?,m28%^(cgf@Jp8^f63p7DU;`,Am;4VE:
\CDhZI'rGX2B%&!hn-k*TI2X^(qO.?Mjab*0r+l"^B*2)^,[m>e[UI0[]AiL<8EO3h<hB^/E*
mn-IIoI^@rj+5Bq3);*dM03!N\$RFlWA!#?32WWdT_bB(AU;K<<pFU<S=k?\j"h]Amm-sO8jn
Nm8U7Ys1jZ'uo3S*\_S+(gE1f,f7EB1<_]A5E"&e17!kEUV(gX_M$gG^Me.BVtT6h/'%mae,g
enkX>qn,[q[Oc03"6eVo4h<(DN^Y#4S=E1GZTIpo'fC?:1"055:V6R9:LB`TpEms+"BFgrEG
E7(JEI6k,6H<V^T:8H&`($2N=X(->JVH,B\i,t'lj`01@(uIL'^bK1Z9*.tWJp7eGGRMm1Rn
+;QJk4pG!5<h6IQi)M9-`CT:aFFJZW]A/(Wuo<Ta&3fNC9t?8KaK=`G:dpOM^$%hh@g?DptrX
paVG@JskXtP\@cG14u+NI>#[3''FsK+U,8?7n5<t,O&^(@tdG=E0=]ALPZj?)E$Z_9a<r1aR@
0N$am,elj@,?`dbb4'G+[bl>]A2h@C8)@sQI9WG<^qKV9H_krXUNdZ*Q[IA*i%sLTQX;B5ed[
*[_Jnd^!LfRcUGZ&8\s`YSXCc#C8!Ma!bEFtC-J_cH?[cZ\M!'J2VE5?Fa1Il`jBSmG1q^/E
*]ANGG!ptT:gWS+$)..EYT.\#mfD6+2PjN`["=s<hLTDhl.\N9'[S:Xp-;Nm_ToR,'%b*/"G\
3WZtE_.PS]AHFa=m&K"9m[+QZ%hOr5BF*/YA2ecs_SeRs.'hDsX=EW/N:`aicfYF(3._5jYZR
k=G03@RhG0CA;Ibi1(8A3Pge#eps*(>:h]AM^:2`M2q0RaRG+R_K6WP^?(0F?3J\<r`4-ZC3(
gn*p<DsBJ<rq-S/k50e*fN1b3<kaB,3M[QI+n:;8:4V/ka@TXMh<>c;'.ZlVbhbprZ`Y,,L,
APQU@b41h#EVKDmYP5:2'hPR]AJh@F,,3=llo=m[8f&'N_??kt:E@H6+,ReS(1oI&3t9cMYtn
ag#o3P(Y]AJ?!@bOR$_mqd+82NA\0%_<F7$]ADpSR]A-^'#2JaKiM9-SH+<3q@Gh]AK&2W0n^*,[
YWl_7B8*KBe[,Y^,Ad2o+kOD+0ag1WR3YW)D)QhPj%j?7>BS(m;D%H6]A1`ECH*<h`Nh[mlX2
/>p)trO%m_0/*5C`?U8Rl_6hN*6u8LK0[+Q)c&FR.[\!/0^nKpgW6FC@)@@p>2b09e&h0lAa
R`._is-Afm'oh!5qUpiRoJ.!m:LH9WFjIN)]A%1M+a\='Kh0>:o1HQNL`Nmm^!d!dJh-='=GH
KLUb7D<NT/rNpc'gicTi_MWAD\T'XU0Cma'BHt7]ADMQ*p=4`'6?6jd+#aqS'W.`Hf*DN0Z=2
h8,N;-K54_>8RMZX)ig'p\!M461+72-hH&1LlYEXGt$1Y:C^g2`N2>pgP<=3!pk6kU+Ge)l_
Y0WEY'akl9(!QKX_*Ao7&q6?9]AQ8dI?8J5JZH1R*64c&IcV04Cq[]Aj0/H3W]Akq3Gi)@<#!%W
bR(16Vd>HU&CcCWoOQe@J$]AVA]A,miDTrA^*jIh/_UTQKA._P-8#+#Y?mSj^u$\U3*ReCM`S%
ZVP52]AtIGmnM!(![Fg<MVbIqDYLj47AKJ0'.VQ#,<l,@H$GBI+h[>4WU%P:ar,r-S3I8IX\5
@p=u6[-#c=h3g=p*8WC_fl,t9I+8#EH#bNRhPAM8-T9V""(.j5sp+J'd1BU/MoY;O&fg,C;[
2sBcfX-N>Wqdg;INj2!nSD,K4Y^C&phDp>+r_^<&e^%b>MFA&&i6jN+r?[spMk_I'#`ZTJOt
QuQa9L9r,%foUj%srHe_4M$EKL$iTnEcs'VHTikO:;[Ntk/Hd/U.YLUg*+i![di4R.UQ&iJi
&_G;Zs$qokkQD4<G=k&XZ9em8#Cg(q1$kY/gf_c-pT^oG^;ERj['.`Sr.82+6u,-@(-:bd*S
rAl%6g$5FSXeH[]A.eBrJ41t#bEC]ALheTj$9O9PP`)MD/0Wc`EK[#,f"+l67P!kcrhf'0Ai48
Oq'.[a)CrrIU9M;mgJ+ro4&`ZQR<.S)P_hZ<&T]AZ,?US&2kr$s0"%<Bb6<fI*NL4glW#BjMj
:CoI;5VR-0FQU,#AjQUG1tU\MU/0N;7fJUlt4Sr`d1?1:>aF,@eu_<)Yj6$J^tr#9ML#MVI*
WEMH1J8S.-l^#MjJc[P?n;`N-a,XCE`QOKr\d":>)N42L8%=$:LRk*C!e7TfIAG+c=E'!GgA
meS_U>%AP\7h`/aaYV.R-%C6dig-'W?0b`1?9T_X?`3PD?dU-hC!?]A2N]AKU\(MAtSdVmH54d
8QT`6NI/RiK4]AX@S3E%'NWAEY)2i$a"#GeAi]A9?$Aj""aZf<_82g7F;HNMam#;HA?GVtc1HL
(&D`@)3j_b3SM=[8Ru-]A<ctN4(3gYOlj:^m-OELc>@kJ(B%%(`E4EYJb*WPXM%hneQ9h(Jl0
IN8h@jBToV-Cn`K)Qe7af;hH=1:lPM62i\-O\<N+N7'K\mEB%.BEKA&_/glSo[HgAHB;d7Vq
e5\[tF&Y(X,#bi8?h4$:e,o]A^1CmM0G7?`]Ak3]Ak2ms*neV>0QkjQ$5u#Og(ls!Mo]AY*$)&Wa
1':FqAZUc#/C781r6rj[^c=UC$9ScB5pk7peS1"X:8UutB%E3F*/*;@[t5PX,D-`$M(FR8B%
Ue<CDMZD8qE_@/63QeJHU-Q>[X)SE9Ur]AM%_cM(QAm=Kkqs0>T@RlUuEd<fU9u0S#ge%)n16
$M4cmoXD@'gW.Q)?JuEKFPSGdc&0iB:i<_PRjhjsaJgR#A1`K)Z/J#U[+u^2mHDq_)Q/bFOO
WpkU`2Ie,9#O8>/FusgbZ]A+3^EN.G2q>H7#ffl'ION4oJ-f*=osd*[4rueMLK@=[UqT8T)Db
;Kj#IAQ\6aAM:jS6f*Gg4?M,[[qR#)@kn-.,U0%u^S"h;LRV5jL(c&.FQd@H(.2eV;`BN#7E
K7TL^\-oScUt\9$>hmc%iTONW]A!^c9"J%U:7sDQZ%\p0iIZ0jb31T=M4Kp(,@D)B\8%[WHc&
P([c?7hHOs_;IS4IGf=nlj*Gc(LnfWW"IB124:gQILF@lLFNK@#':6,<\$6h4DXOsjJ3^DBk
B'045!5TH?@aG+io5]Atd\]AL$YQJk=$q;Ia9-iMo)Mf_;V$b(AlN$uD.$f$GX9&':fTWai#66
lmuuWdVF>-TADXqsdb><qAGe0Q1QEMo"o1pa9)lJk*Le*H+tkcV*@O^>$]AQMi-I9/@SB%4NC
Q6(;HCjdT0Q,prIGJBK$1Bf$T2L&.7:Vj]AM)]ARKERH]A`3,f.DIbsL;$9rKNn>036X>EGNg?u
*e=ii7sPsAU4?Tc&&F%fU-(hg;/2.XR#WQ\J%"Jk\Q.dK7X6t6S^c:f=:f5H8fa^jRS[EW+,
Q_K.Q<>jhX%U6#Sh]Aqq!VmX:IN;%;`C9q=>.PirO_B-Epf%dG8'\9.u:63Ds9bTJ=f[PgMa?
lk1<HM01YmAhPJ61#:sl2RjT]AIWoWpC!5:)OS*6,E]A`-jh!!~
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
<![CDATA[432000,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,288000,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[720000,2743200,2743200,2743200,288000,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1" cs="3" rs="10">
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
<FRFont name="微软雅黑" style="1" size="112" foreground="-16713985"/>
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
<FRFont name="Verdana" style="0" size="80" foreground="-10066330"/>
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
<FillStyleName fillStyleName=""/>
<isCustomFillStyle isCustomFillStyle="true"/>
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
<AxisRange maxValue="=1 "/>
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
<VanChartRadius radiusType="fixed" radius="50"/>
</Plot>
<ChartDefinition>
<MeterTableDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[仪表]]></Name>
</TableData>
<MeterTable201109 meterType="1" name="名称" value="完成率"/>
</MeterTableDefinition>
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
<C c="5" r="3" cs="2" rs="2">
<O t="RichText">
<RichText>
<RichChar styleIndex="0">
<text>
<![CDATA[目标：]]></text>
</RichChar>
<RichChar styleIndex="1">
<text>
<![CDATA[500亩]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="5" r="6" cs="2" rs="2">
<O t="RichText">
<RichText>
<RichChar styleIndex="0">
<text>
<![CDATA[实际值：]]></text>
</RichChar>
<RichChar styleIndex="2">
<text>
<![CDATA[120亩]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="1" r="12" cs="6" s="3">
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
<FRFont name="微软雅黑" style="0" size="128" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="168" foreground="-16713985"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="168" foreground="-74446"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</body>
</InnerWidget>
<BoundsAttr x="10" y="3" width="843" height="227"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="info99"/>
<WidgetAttr invisible="true" description="">
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O>
<![CDATA[]]></O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="0" autoline="true"/>
<FRFont name="SimSun" style="0" size="72"/>
<border style="0" color="-723724"/>
</InnerWidget>
<BoundsAttr x="221" y="235" width="80" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="periodtype99"/>
<WidgetAttr invisible="true" description="">
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O>
<![CDATA[当年]]></O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="0" autoline="true"/>
<FRFont name="SimSun" style="0" size="72"/>
<border style="0" color="-723724"/>
</InnerWidget>
<BoundsAttr x="391" y="235" width="80" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="org99"/>
<WidgetAttr invisible="true" description="">
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<databinding>
<![CDATA[{Name:org,Key:ORG_ID}]]></databinding>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="0" autoline="true"/>
<FRFont name="SimSun" style="0" size="72"/>
<border style="0" color="-723724"/>
</InnerWidget>
<BoundsAttr x="301" y="235" width="80" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="org_name"/>
<WidgetAttr invisible="true" description="">
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=sql("oracle_test","select org_name from dim_org_jxjl where org_id='"+org+"'",1,1)]]></Attributes>
</O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="0" autoline="true"/>
<FRFont name="SimSun" style="0" size="72"/>
<border style="0" color="-723724"/>
</InnerWidget>
<BoundsAttr x="582" y="235" width="80" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="org12"/>
<WidgetAttr invisible="true" description="">
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=sql("oracle_test","select org_level from dim_org_jxjl where org_id='"+org+"'",1,1)]]></Attributes>
</O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="0" autoline="true"/>
<FRFont name="SimSun" style="0" size="72" foreground="-1118482"/>
<border style="0" color="-723724"/>
</InnerWidget>
<BoundsAttr x="480" y="235" width="80" height="21"/>
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
<![CDATA[1714500,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[7810500,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O>
<![CDATA[应收账款(产新)完成情况表]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="0">
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
<BoundsAttr x="14" y="238" width="250" height="25"/>
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
<![CDATA[1008000,2057400,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
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
<![CDATA[window.parent.parent.FS.tabPane.addItem({title:"净现金流详情",src:"${servletURL}?reportlet=/ThreeLevelPage/OPE_FIN_CASH_FLOW_2.cpt&op=view"})]]></Content>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="当前决策报表对象2">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="info"/>
<O>
<![CDATA[净现金流详情]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report0_c_c"/>
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
<NameJavaScript name="JavaScript脚本2">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[window.parent.parent.FS.tabPane.addItem({title:"基于土地的财政支付的回款计划表",src:"${servletURL}?reportlet=/ThreeLevelPage/OPE_FIN_CASH_FLOW_2.cpt&op=view"})]]></Content>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="当前决策报表对象2">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="info"/>
<O>
<![CDATA[查看基于土地的财政支付的回款计划表]]></O>
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
<FRFont name="SimSun" style="0" size="72" foreground="-16776961"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="2" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72" foreground="-16736003"/>
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
<BoundsAttr x="774" y="238" width="70" height="20"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<Listener event="afterinit">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[var timer1 = setTimeout(function(){
 		  var _x = $('.slimScrollBarY')[0]A;
 		  if(_x){
$('.slimScrollBarY').css('width','15px'); //Y轴宽
$('.slimScrollBarX').css('height','15px');//X轴高
$('.slimScrollBarX').css('background','#227087');//X轴颜色
$('.slimScrollBarX').css('opacity','0.99');//X轴透明度
$('.slimScrollBarY').css('background','#227087');//Y轴颜色
$('.slimScrollBarY').css('opacity','0.99');//Y轴透明度    
 			 clearInterval(timer1);
 			 }
 	  	},1000);]]></Content>
</JavaScript>
</Listener>
<WidgetName name="report3_c"/>
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
<WidgetName name="report3_c"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="1" color="-16764058" borderRadius="0" type="0" borderStyle="0"/>
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
<HR F="1" T="2"/>
<FR/>
<HC/>
<FC/>
<UPFCR COLUMN="false" ROW="true"/>
</ReportPageAttr>
<ColumnPrivilegeControl/>
<RowPrivilegeControl/>
<RowHeight defaultValue="723900">
<![CDATA[1257300,1008000,1008000,1152000,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[0,266700,3456000,2736000,2448000,2448000,3771900,2736000,3276600,2736000,2736000,7200000,4032000,266700,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="0" cs="4" s="1">
<O>
<![CDATA[]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="0" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="0" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="0" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="0" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="0" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="0" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="12" r="0" s="2">
<O>
<![CDATA[]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="13" r="0" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="1">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="2" r="1" rs="2" s="3">
<O>
<![CDATA[区域]]></O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="3" r="1" rs="2" s="3">
<O>
<![CDATA[层级]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="1" rs="2" s="3">
<O>
<![CDATA[年度目标]]></O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="5" r="1" rs="2" s="3">
<O>
<![CDATA[当前实际]]></O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="6" r="1" rs="2" s="3">
<O>
<![CDATA[实际与目标差值]]></O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="7" r="1" rs="2" s="3">
<O>
<![CDATA[金额占比]]></O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="8" r="1" rs="2" s="3">
<O>
<![CDATA[2018年初数据]]></O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="9" r="1" rs="2" s="3">
<O>
<![CDATA[较年初增幅]]></O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="10" r="1" cs="3" s="4">
<O>
<![CDATA[应回未回]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="13" r="1">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="10" r="2" s="3">
<O>
<![CDATA[合计]]></O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="11" r="2" s="3">
<O>
<![CDATA[其中：基于土地的财政支付应回未回]]></O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="12" r="2" s="3">
<O>
<![CDATA[其中：税收应回未回]]></O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="0" r="3">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="1" r="3">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="2" r="3" s="5">
<O t="DSColumn">
<Attributes dsName="accounts" columnName="ORGNAME"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper">
<Attr divideMode="1"/>
</RG>
<Parameters/>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[D4 = 2]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.PaddingHighlightAction">
<Padding left="10" right="0"/>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[D4 = 3]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.PaddingHighlightAction">
<Padding left="20" right="0"/>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[3]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[D4 = 4]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.PaddingHighlightAction">
<Padding left="30" right="0"/>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[4]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[D4 = 5]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.PaddingHighlightAction">
<Padding left="40" right="0"/>
</HighlightAction>
</Highlight>
</HighlightList>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=if(round($$$,2)=0,'-',$$$)]]></Content>
</Present>
<Expand dir="0"/>
</C>
<C c="3" r="3" s="5">
<O t="DSColumn">
<Attributes dsName="accounts" columnName="ORG_LEVEL"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition"/>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="4" r="3" s="6">
<O t="DSColumn">
<Attributes dsName="accounts" columnName="TARGET_VALUE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[len($$$) = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=if(round($$$,2)=0,'-',$$$)]]></Content>
</Present>
<Expand dir="0"/>
</C>
<C c="5" r="3" s="6">
<O t="DSColumn">
<Attributes dsName="accounts" columnName="ACTUAL_VALUE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[len($$$) = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=if(round($$$,2)=0,'-',$$$)]]></Content>
</Present>
<Expand dir="0"/>
</C>
<C c="6" r="3" s="6">
<O t="DSColumn">
<Attributes dsName="accounts" columnName="DIFFERENCE_VALUE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[len($$$) = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=if(round($$$,2)=0,'-',$$$)]]></Content>
</Present>
<Expand dir="0"/>
</C>
<C c="7" r="3" s="7">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(len(C5) = 0, 0, FORMAT(F4 / C5, "0.00%"))]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[len($$$) = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=if(round($$$,2)=0,'-',$$$)]]></Content>
</Present>
<Expand dir="0"/>
</C>
<C c="8" r="3" s="6">
<O t="DSColumn">
<Attributes dsName="accounts" columnName="BY_ACTUAL_VALUE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[len($$$) = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=if(round($$$,2)=0,'-',$$$)]]></Content>
</Present>
<Expand dir="0"/>
</C>
<C c="9" r="3" s="6">
<O t="DSColumn">
<Attributes dsName="accounts" columnName="INCREASE_ACTUAL_VALUE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[len($$$) = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=if(round($$$,2)=0,'-',$$$)]]></Content>
</Present>
<Expand dir="0"/>
</C>
<C c="10" r="3" s="6">
<O t="DSColumn">
<Attributes dsName="accounts" columnName="CAPITAL_ACTUAL_VALUE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[len($$$) = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=if(round($$$,2)=0,'-',$$$)]]></Content>
</Present>
<Expand dir="0"/>
</C>
<C c="11" r="3" s="6">
<O t="DSColumn">
<Attributes dsName="accounts" columnName="LAND_ACTUAL_VALUE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[len($$$) = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=if(round($$$,2)=0,'-',$$$)]]></Content>
</Present>
<Expand dir="0"/>
</C>
<C c="12" r="3" s="6">
<O t="DSColumn">
<Attributes dsName="accounts" columnName="TAX_ACTUAL_VALUE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[len($$$) = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=if(round($$$,2)=0,'-',$$$)]]></Content>
</Present>
<Expand dir="0"/>
</C>
<C c="13" r="3">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="2" r="4">
<O t="DSColumn">
<Attributes dsName="money_rate" columnName="ACTUAL_VALUE_XIN"/>
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
</CellElementList>
<ReportAttrSet>
<ReportSettings headerHeight="0" footerHeight="0">
<PaperSetting/>
</ReportSettings>
</ReportAttrSet>
</FormElementCase>
<StyleList>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="96"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="2" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="96" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="4" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="96" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="80" foreground="-1"/>
<Background name="ColorBackground" color="-15310988"/>
<Border>
<Top style="1" color="-16174771"/>
<Bottom style="1" color="-16174771"/>
<Left style="1" color="-16174771"/>
<Right style="1" color="-16174771"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0.00%]]></Format>
<FRFont name="微软雅黑" style="0" size="80" foreground="-1"/>
<Background name="ColorBackground" color="-15310988"/>
<Border>
<Top style="1" color="-16174771"/>
<Bottom style="1" color="-16174771"/>
<Left style="1" color="-16174771"/>
<Right style="1" color="-16174771"/>
</Border>
</Style>
<Style imageLayout="1" paddingLeft="5">
<FRFont name="微软雅黑" style="0" size="72" foreground="-1"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-16174771"/>
<Bottom style="1" color="-16174771"/>
<Left style="1" color="-16174771"/>
<Right style="1" color="-16174771"/>
</Border>
</Style>
<Style imageLayout="1" paddingRight="5">
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0.00]]></Format>
<FRFont name="微软雅黑" style="0" size="72" foreground="-1"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-16174771"/>
<Bottom style="1" color="-16174771"/>
<Left style="1" color="-16174771"/>
<Right style="1" color="-16174771"/>
</Border>
</Style>
<Style imageLayout="1" paddingRight="5">
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0.00%]]></Format>
<FRFont name="微软雅黑" style="0" size="72" foreground="-1"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-16174771"/>
<Bottom style="1" color="-16174771"/>
<Left style="1" color="-16174771"/>
<Right style="1" color="-16174771"/>
</Border>
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
<BoundsAttr x="10" y="235" width="843" height="227"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="report1_c_c_c"/>
<Widget widgetName="report7_c_c"/>
<Widget widgetName="report0_c"/>
<Widget widgetName="report3_c"/>
<Widget widgetName="info99"/>
<Widget widgetName="org99"/>
<Widget widgetName="periodtype99"/>
<Widget widgetName="org12"/>
<Widget widgetName="org_name"/>
<Widget widgetName="report6_c"/>
<Widget widgetName="report2"/>
</MobileWidgetList>
<WidgetScalingAttr compState="0"/>
<DesignResolution absoluteResolutionScaleW="1366" absoluteResolutionScaleH="768"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="956" height="520"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="absolute0"/>
</MobileWidgetList>
<WidgetZoomAttr compState="0"/>
<AppRelayout appRelayout="true"/>
<Size width="956" height="520"/>
<ResolutionScalingAttr percent="0.9"/>
<BodyLayoutType type="0"/>
</Center>
</Layout>
<DesignerVersion DesignerVersion="JAA"/>
<PreviewType PreviewType="0"/>
<TemplateID TemplateID="5f03c732-0a34-42e6-a875-e0f0d5fe1e90"/>
<TemplateIdAttMark class="com.fr.base.iofileattr.TemplateIdAttrMark">
<TemplateIdAttMark TemplateId="ebbaa348-f6a1-4037-82b3-cafb7a4aee60"/>
</TemplateIdAttMark>
</Form>
