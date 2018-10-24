<?xml version="1.0" encoding="UTF-8"?>
<Form xmlVersion="20170720" releaseVersion="9.0.0">
<TableDataMap>
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
<![CDATA[with role as
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
                 ), 1 )
                 
                 ),
du2 as (
select regexp_substr(orgid, '[^,]A+', 1, level, 'i') as orgid
    from (select orgid  from du)
  connect by level <=
             length(orgid) - length(regexp_replace(orgid, ',', '')) + 1


),

ORG_JG AS(
select ORG_ID,
       case when ORG_ID = '5FB62123-5DF2-0750-0F82-F04B251EA55E'
       then  'E0A3D386-D5C8-FB22-18DE-4424D49363B1'
       else PARENTID end      as FATHER_ID,
       ORG_NAME,
       ORG_SHORTNAME as ORG_SNAME,
       ORG_NUM as ORDER_KEY,
       org_level,
       ORG_CODE
  from dim_org_jxjl where isshow=1   
  and   org_id <> 'E0A3D386-D5C8-FB22-18DE-4424D49363B1'	--华夏幸福
  and   org_id <> '9E3CFC37-AA68-46AB-96AA-C9BE391C37C6'	--产业新城直属区域事业部
  and   org_code not like 'HXCYXCGN20%'
  and   org_code not like 'HXCYXCGN06%'
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
<TableData name="1left" class="com.fr.data.impl.DBTableData">
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
   and c.index_id = 'd1026c1ffd0841b2bfe631cb7643745e'
   and b.org_id = '${org}'
   
   and a.period_type_id = case '${periodtype}'
         when '当年' then
          substr(date1.date1, 1, 4)
         when '当季' then
          substr(date1.date1, 1, 4) || 'Q0' || to_char(to_date(date1.date1, 'YYYYMMDD'), 'Q')
         when '当月' then
          substr(date1.date1, 1, 4) || 'M' || to_char(to_date(date1.date1, 'YYYYMMDD'), 'MM')
       end
]]></Query>
</TableData>
<TableData name="JDYG" class="com.fr.data.impl.DBTableData">
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
 ind.index_id = 'd1026c1ffd0841b2bfe631cb7643745e' 
 and org.org_id = '${org}' and
 a.period_type_id = substr(date1.date1, 1, 4) || 'Q0' ||
 to_char(to_date(date1.date1, 'YYYYMMDD'), 'Q')
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
<![CDATA[WITH date1 as(
select data_date date1 from dm_mcl_acct where rownum = 1
),
DIM_DATEKJ AS (
SELECT 
		CASE WHEN '当年'='${periodtype}' THEN PERIOD_YEAR
				 WHEN '当季'='${periodtype}' THEN PERIOD_QUARTER
				 WHEN '当月'='${periodtype}' THEN PERIOD_MONTH END AS CALIBER ,--找到我当前时间参数口径（当年、当季、当月）
		'1' as ORDER_CALIBER
		FROM DIM_PERIOD , date1 --时间维度
WHERE PERIOD_KEY=date1.date1
),--当前时间口径 年、季度、月份

DIM_DATEMX AS ( 
SELECT
		DISTINCT 
		CASE WHEN '当年'='${periodtype}' THEN PERIOD_YEAR
				 WHEN '当季'='${periodtype}' THEN PERIOD_QUARTER
				 WHEN '当月'='${periodtype}' THEN PERIOD_MONTH END AS periodtypeIBER,--口径
		CASE WHEN '当年'='${periodtype}' THEN PERIOD_QUARTER
				 WHEN '当季'='${periodtype}' THEN PERIOD_MONTH
				 WHEN '当月'='${periodtype}' THEN WEEK_NBR_IN_MONTH END AS periodtypeIBER_S --口径2
FROM DIM_PERIOD --时间维度
),--时间口径维度

DIM_DATES AS(
/*SELECT 
		CALIBER ,
		CASE WHEN '当年'='${periodtype}' THEN substr(CALIBER,1,4) 
				 WHEN '当季'='${periodtype}' THEN substr(date1.date1,1,4) ||'Q0'||substr(CALIBER,1,1) 
				 WHEN '当月'='${periodtype}' THEN substr(date1.date1,1,4) ||'M'||substr(CALIBER,1,2) 
		END as Statistical_time ,ORDER_CALIBER
FROM DIM_DATEKJ, date1
UNION ALL
*/
SELECT 
		b.periodtypeIBER_S as CALIBER,
		CASE WHEN '当年'='${periodtype}' THEN substr(date1,1,4) ||'Q0'||substr(b.periodtypeIBER_S,1,1) 
				 WHEN '当季'='${periodtype}' THEN substr(date1,1,4) ||'M'||substr(b.periodtypeIBER_S,1,2) 
				 WHEN '当月'='${periodtype}' THEN substr(date1,1,4) ||'M'||substr(date1,5,2)||'W'||substr(b.periodtypeIBER_S,2,1) 
		END as Statistical_time , 
		CASE WHEN '当年'='${periodtype}' THEN substr(date1,1,4) ||'Q0'||substr(b.periodtypeIBER_S,1,1) 
				 WHEN '当季'='${periodtype}' THEN substr(date1,1,4) ||'M'||substr(b.periodtypeIBER_S,1,2) 
				 WHEN '当月'='${periodtype}' THEN substr(date1,1,4) ||'M'||substr(date1,5,2)||'W'||substr(b.periodtypeIBER_S,2,1) 
		END as ORDER_CALIBER
FROM DIM_DATEKJ a
LEFT JOIN DIM_DATEMX b
ON a.CALIBER=b.periodtypeIBER
left join date1
on 1=1
), --整理时间维度

DATE_INDEX AS (
SELECT INDEX_ID,INDEX_NAME,ORDER_KEY FROM DIM_INDEX 
WHERE INDEX_id='d1026c1ffd0841b2bfe631cb7643745e'
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
<TableData name="report" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="org"/>
<O>
<![CDATA[E0A3D386-D5C8-FB22-18DE-4424D49363B1]]></O>
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
<![CDATA[WITH usedate as
 (select DISTINCT SYSDATE usedate
    from dm_REG_fundbalance
    ),

-- 处理时间维度

datetable as
 (
  --年度无论何时都需要显示
  select to_char(usedate, 'yyyy') code,
          to_char(usedate, 'yyyy') || '年' description,
          to_char(usedate, 'yyyy') ordercode
    from usedate
    --where  '${periodtype}'  = '当年'
  union all
  --季度年度情况
  select distinct to_char(p.period_date, 'yyyy') || 'Q0' ||
                   to_char(p.period_date, 'Q') CODE,
                   to_char(p.period_date, 'Q') || '季度' description,
                   to_char(p.period_date, 'yyyy') || 'Q0' ||
                   to_char(p.period_date, 'Q') ordercode
    from usedate u, dim_period p
   where to_char(p.period_date, 'yyyy') = to_char(u.usedate, 'yyyy')
     and '${periodtype}' = '当年'
  union all
  --季度季度及月度的情况
  select distinct to_char(p.period_date, 'yyyy') || 'Q0' ||
                   to_char(p.period_date, 'Q') CODE,
                   to_char(p.period_date, 'Q') || '季度' description,
                   to_char(p.period_date, 'yyyy') || 'Q0' ||
                   to_char(p.period_date, 'Q') ordercode
    from usedate u, dim_period p
   where to_char(p.period_date, 'yyyyQ') = to_char(u.usedate, 'yyyyQ')
     and ('${periodtype}' = '当季')
  union all
  --月度季度情况
  select distinct to_char(p.period_date, 'yyyy') || 'M' ||
                   to_char(p.period_date, 'MM') CODE,
                   TO_CHAR(TO_NUMBER(to_char(p.period_date, 'MM'))) || '月' description,
                   to_char(p.period_date, 'yyyy') || 'Q0' ||
                   to_char(p.period_date, 'Q') || 'M' ||
                   to_char(p.period_date, 'MM') ordercode
    from usedate u, dim_period p
   where to_char(p.period_date, 'yyyyQ') = to_char(u.usedate, 'yyyyQ')
     and '${periodtype}' = '当季'

  
  ),
--部门维度处理
org as
 (

 select * from( 
 select org_id, '  '||org_name org_name,org_num
    from dim_org_jxjl
   where parentid =
         (select org_id from dim_org_jxjl o where o.org_id = '${org}')

          UNION ALL

select org_id, org_name,org_num
    from dim_org_jxjl
   where org_id = '${org}'  )res 
   where org_id not in ('2d52fd1a-1633-4cb1-b404-5021ac949be8','2BC888F4-39AA-4712-90E4-BDE8787A4EC6')

   
  )

  select * from( 
  SELECT * FROM (SELECT * FROM datetable,ORG) dim left join  dm_REG_fundbalance f on dim.code=f.date_type and dim.org_id=f.org_id
 -- where f.index_id='SX资金净提取'
 ) res
 where res.description is not null
   order by org_num,ordercode,index_id desc
]]></Query>
</TableData>
<TableData name="piechart" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="org"/>
<O>
<![CDATA[272b8504-f3ef-4122-b3de-b0661bbeeaae]]></O>
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
<![CDATA[WITH usedate as
 (select DISTINCT SYSDATE usedate
    from dm_REG_fundbalance
    ),

-- 处理时间维度

datetable as
 (
  --年度无论何时都需要显示
  select to_char(usedate, 'yyyy') code,
          to_char(usedate, 'yyyy') || '年' description,
          to_char(usedate, 'yyyy') ordercode
    from usedate
    where  '${periodtype}'  = '当年'
  union all/*
  --季度年度情况
  select distinct to_char(p.period_date, 'yyyy') || 'Q0' ||
                   to_char(p.period_date, 'Q') CODE,
                   to_char(p.period_date, 'Q') || '季度' description,
                   to_char(p.period_date, 'yyyy') || 'Q0' ||
                   to_char(p.period_date, 'Q') ordercode
    from usedate u, dim_period p
   where to_char(p.period_date, 'yyyy') = to_char(u.usedate, 'yyyy')
     and '${periodtype}' = '当年'
  union all*/
  --季度季度及月度的情况
  select distinct to_char(p.period_date, 'yyyy') || 'Q0' ||
                   to_char(p.period_date, 'Q') CODE,
                   to_char(p.period_date, 'Q') || '季度' description,
                   to_char(p.period_date, 'yyyy') || 'Q0' ||
                   to_char(p.period_date, 'Q') ordercode
    from usedate u, dim_period p
   where to_char(p.period_date, 'yyyyQ') = to_char(u.usedate, 'yyyyQ')
     and ('${periodtype}' = '当季')
  /*union all
  --月度季度情况
  select distinct to_char(p.period_date, 'yyyy') || 'M' ||
                   to_char(p.period_date, 'MM') CODE,
                   TO_CHAR(TO_NUMBER(to_char(p.period_date, 'MM'))) || '月' description,
                   to_char(p.period_date, 'yyyy') || 'Q0' ||
                   to_char(p.period_date, 'Q') || 'M' ||
                   to_char(p.period_date, 'MM') ordercode
    from usedate u, dim_period p
   where to_char(p.period_date, 'yyyyQ') = to_char(u.usedate, 'yyyyQ')
     and '${periodtype}' = '当季'
*/
  
  ),
--部门维度处理
org as
 (

 select org_id, '  '||org_shortname org_name,org_num
    from dim_org_jxjl
   where parentid =
         (select org_id from dim_org_jxjl o where o.org_id = '${org}')
      /*     UNION ALL
 
select org_id, org_name,org_num
    from dim_org_jxjl
   where org_id = '${org}'     */   
  )

  
  SELECT * FROM (SELECT * FROM datetable,ORG) dim left join  dm_REG_fundbalance f on dim.code=f.date_type and dim.org_id=f.org_id
  where f.index_id='受限资金净提取'

   order by org_num,ordercode
]]></Query>
</TableData>
<TableData name="Embedded1" class="com.fr.data.impl.EmbeddedTableData">
<Parameters/>
<DSName>
<![CDATA[]]></DSName>
<ColumnNames>
<![CDATA[ColName1,,.,,ColName2,,.,,ColName3]]></ColumnNames>
<ColumnTypes>
<![CDATA[java.lang.String,java.lang.String,java.lang.Double]]></ColumnTypes>
<RowData>
<![CDATA[F6%H*1se#]A!!~
]]></RowData>
</TableData>
<TableData name="Embedded2" class="com.fr.data.impl.EmbeddedTableData">
<Parameters/>
<DSName>
<![CDATA[]]></DSName>
<ColumnNames>
<![CDATA[area,,.,,value]]></ColumnNames>
<ColumnTypes>
<![CDATA[java.lang.String,java.lang.Double]]></ColumnTypes>
<RowData>
<![CDATA[%EggCJl!!^d/)%&"IrVf%A*c5LS$g[i6afG=HK24RpkI$/u1ZkldBQT5`VX7\%*G'+tEnh.n
E514RTd54X;/>P3r*t*(Va)n'lrWoUT]AaJbT/C/cC8Gnt#CH=JlB`,TE7:;fM42~
]]></RowData>
</TableData>
<TableData name="column" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="org"/>
<O>
<![CDATA[272b8504-f3ef-4122-b3de-b0661bbeeaae]]></O>
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
<![CDATA[WITH usedate as
 (select DISTINCT SYSDATE usedate
    from dm_REG_fundbalance
    ),

-- 处理时间维度

datetable as
 (/*
  --年度无论何时都需要显示
  select to_char(usedate, 'yyyy') code,
          to_char(usedate, 'yyyy') || '年' description,
          to_char(usedate, 'yyyy') ordercode
    from usedate
    where  '${periodtype}'  = '当年'
  union all*/
  --季度年度情况
  select distinct to_char(p.period_date, 'yyyy') || 'Q0' ||
                   to_char(p.period_date, 'Q') CODE,
                   to_char(p.period_date, 'Q') || '季度' description,
                   to_char(p.period_date, 'yyyy') || 'Q0' ||
                   to_char(p.period_date, 'Q') ordercode
    from usedate u, dim_period p
   where to_char(p.period_date, 'yyyy') = to_char(u.usedate, 'yyyy')
     and '${periodtype}' = '当年'
  union all
  --季度季度及月度的情况
 /* select distinct to_char(p.period_date, 'yyyy') || 'Q0' ||
                   to_char(p.period_date, 'Q') CODE,
                   to_char(p.period_date, 'Q') || '季度' description,
                   to_char(p.period_date, 'yyyy') || 'Q0' ||
                   to_char(p.period_date, 'Q') ordercode
    from usedate u, dim_period p
   where to_char(p.period_date, 'yyyyQ') = to_char(u.usedate, 'yyyyQ')
     and ('${periodtype}' = '当季')
  union all*/
  --月度季度情况
  select distinct to_char(p.period_date, 'yyyy') || 'M' ||
                   to_char(p.period_date, 'MM') CODE,
                   TO_CHAR(TO_NUMBER(to_char(p.period_date, 'MM'))) || '月' description,
                   to_char(p.period_date, 'yyyy') || 'Q0' ||
                   to_char(p.period_date, 'Q') || 'M' ||
                   to_char(p.period_date, 'MM') ordercode
    from usedate u, dim_period p
   where to_char(p.period_date, 'yyyyQ') = to_char(u.usedate, 'yyyyQ')
     and '${periodtype}' = '当季'

  
  ),
--部门维度处理
org as
 (
 /*
 select org_id, '  '||org_name org_name,org_num
    from dim_org_jxjl
   where parentid =
         (select org_id from dim_org_jxjl o where o.org_id = '${org}')
          UNION ALL
 */
select org_id, org_name,org_num
    from dim_org_jxjl
   where org_id = '${org}'        
  )

  
  SELECT * FROM (SELECT * FROM datetable,ORG) dim left join  dm_REG_fundbalance f on dim.code=f.date_type and dim.org_id=f.org_id
  where f.index_id='受限资金净提取'

   order by org_num,ordercode
]]></Query>
</TableData>
<TableData name="meter" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="org"/>
<O>
<![CDATA[50c766b8ed1e4d01833eda56ce36ddaf]]></O>
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
<![CDATA[WITH usedate as
 (select DISTINCT SYSDATE usedate
    from dm_REG_fundbalance
    ),

-- 处理时间维度

datetable as
 (
  --年度无论何时都需要显示
  select to_char(usedate, 'yyyy') code,
          to_char(usedate, 'yyyy') || '年' description,
          to_char(usedate, 'yyyy') ordercode
    from usedate
    where  '${periodtype}'  = '当年'
  union all/*
  --季度年度情况
  select distinct to_char(p.period_date, 'yyyy') || 'Q0' ||
                   to_char(p.period_date, 'Q') CODE,
                   to_char(p.period_date, 'Q') || '季度' description,
                   to_char(p.period_date, 'yyyy') || 'Q0' ||
                   to_char(p.period_date, 'Q') ordercode
    from usedate u, dim_period p
   where to_char(p.period_date, 'yyyy') = to_char(u.usedate, 'yyyy')
     and '${periodtype}' = '当年'
  union all*/
  --季度季度及月度的情况
  select distinct to_char(p.period_date, 'yyyy') || 'Q0' ||
                   to_char(p.period_date, 'Q') CODE,
                   to_char(p.period_date, 'Q') || '季度' description,
                   to_char(p.period_date, 'yyyy') || 'Q0' ||
                   to_char(p.period_date, 'Q') ordercode
    from usedate u, dim_period p
   where to_char(p.period_date, 'yyyyQ') = to_char(u.usedate, 'yyyyQ')
     and ('${periodtype}' = '当季')
  /*union all
  --月度季度情况
  select distinct to_char(p.period_date, 'yyyy') || 'M' ||
                   to_char(p.period_date, 'MM') CODE,
                   TO_CHAR(TO_NUMBER(to_char(p.period_date, 'MM'))) || '月' description,
                   to_char(p.period_date, 'yyyy') || 'Q0' ||
                   to_char(p.period_date, 'Q') || 'M' ||
                   to_char(p.period_date, 'MM') ordercode
    from usedate u, dim_period p
   where to_char(p.period_date, 'yyyyQ') = to_char(u.usedate, 'yyyyQ')
     and '${periodtype}' = '当季'
*/
  
  ),
--部门维度处理
org as
 (
 /*
 select org_id, '  '||org_name org_name,org_num
    from dim_org_jxjl
   where parentid =
         (select org_id from dim_org_jxjl o where o.org_id = '${org}')
          UNION ALL
 */
select org_id, org_shortname org_name,org_num
    from dim_org_jxjl
   where org_id = '${org}'        
  )

  
  SELECT  dim.org_name,f.index_id,round(target,1) target,round(actual,1)  actual,round(lvs,3)  lvs FROM (SELECT * FROM datetable,ORG) dim left join  dm_REG_fundbalance f on dim.code=f.date_type and dim.org_id=f.org_id
  where f.index_id='受限资金余额'

   order by org_num,ordercode
]]></Query>
</TableData>
<TableData name="bar" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="org"/>
<O>
<![CDATA[E0A3D386-D5C8-FB22-18DE-4424D49363B1]]></O>
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
<![CDATA[WITH usedate as
 (select DISTINCT SYSDATE usedate
    from dm_REG_fundbalance
    ),

-- 处理时间维度

datetable as
 (
  --年度无论何时都需要显示
  select to_char(usedate, 'yyyy') code,
          to_char(usedate, 'yyyy') || '年' description,
          to_char(usedate, 'yyyy') ordercode
    from usedate
    where  '${periodtype}'  = '当年'
  union all/*
  --季度年度情况
  select distinct to_char(p.period_date, 'yyyy') || 'Q0' ||
                   to_char(p.period_date, 'Q') CODE,
                   to_char(p.period_date, 'Q') || '季度' description,
                   to_char(p.period_date, 'yyyy') || 'Q0' ||
                   to_char(p.period_date, 'Q') ordercode
    from usedate u, dim_period p
   where to_char(p.period_date, 'yyyy') = to_char(u.usedate, 'yyyy')
     and '${periodtype}' = '当年'
  union all*/
  --季度季度及月度的情况
  select distinct to_char(p.period_date, 'yyyy') || 'Q0' ||
                   to_char(p.period_date, 'Q') CODE,
                   to_char(p.period_date, 'Q') || '季度' description,
                   to_char(p.period_date, 'yyyy') || 'Q0' ||
                   to_char(p.period_date, 'Q') ordercode
    from usedate u, dim_period p
   where to_char(p.period_date, 'yyyyQ') = to_char(u.usedate, 'yyyyQ')
     and ('${periodtype}' = '当季')
  /*union all
  --月度季度情况
  select distinct to_char(p.period_date, 'yyyy') || 'M' ||
                   to_char(p.period_date, 'MM') CODE,
                   TO_CHAR(TO_NUMBER(to_char(p.period_date, 'MM'))) || '月' description,
                   to_char(p.period_date, 'yyyy') || 'Q0' ||
                   to_char(p.period_date, 'Q') || 'M' ||
                   to_char(p.period_date, 'MM') ordercode
    from usedate u, dim_period p
   where to_char(p.period_date, 'yyyyQ') = to_char(u.usedate, 'yyyyQ')
     and '${periodtype}' = '当季'
*/
  
  ),
--部门维度处理
org as
 (

 select org_id, org_shortname org_name,org_num
    from dim_org_jxjl
   where parentid =
         (select org_id from dim_org_jxjl o where o.org_id = '${org}')
      /*     UNION ALL
 
select org_id, org_name,org_num
    from dim_org_jxjl
   where org_id = '${org}'     */   
  )

  select * from (
  SELECT * FROM (SELECT * FROM datetable,ORG) dim left join  dm_REG_fundbalance f on dim.code=f.date_type and dim.org_id=f.org_id
  where f.index_id='受限资金净提取'

   order by  ACTUAL desc,org_num,ordercode
) where rownum<=10     order by  ACTUAL ,org_num,ordercode]]></Query>
</TableData>
</TableDataMap>
<FormMobileAttr>
<FormMobileAttr refresh="false" isUseHTML="false" isMobileOnly="false" isAdaptivePropertyAutoMatch="false"/>
</FormMobileAttr>
<Parameters>
<Parameter>
<Attributes name="project"/>
<O>
<![CDATA[新城全口径]]></O>
</Parameter>
<Parameter>
<Attributes name="info"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="periodtype"/>
<O>
<![CDATA[当年]]></O>
</Parameter>
<Parameter>
<Attributes name="comtype"/>
<O>
<![CDATA[事业部]]></O>
</Parameter>
<Parameter>
<Attributes name="valuetype"/>
<O>
<![CDATA[实际]]></O>
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
<![CDATA[=sql("oracle_test", "select to_char(to_date(max(data_date), 'YYYYMMDD'),'yyyy-mm-dd')  from dm_mcl_acct ", 1)]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[setTimeout(
 function() {
$('.fr-trigger-btn-up').css('background', '#2cc5d8')//.fr-trigger-btn-up 
var str = '<div id="modeDiv" style="width: 400px;height: 10px;position: absolute;right: 1.2%;top: 3%;z-index:999;text-align:right;"><div style="height:2px"></div><span style="display:block;font-size: 12px;font-family: 微软雅黑;font-weight:normal;color: #ffffff;">(单位：亿元)&nbsp;&nbsp;&nbsp;数据截止日期：'+tim+'</span></div>';
		
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
<WidgetName name="Search_c"/>
<LabelName name="时间维度:"/>
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
<Background name="ColorBackground" color="-15626337"/>
</click>
<FRFont name="微软雅黑" style="0" size="72" foreground="-1"/>
<isCustomType isCustomType="true"/>
</InnerWidget>
<BoundsAttr x="423" y="12" width="60" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ComboBox">
<WidgetName name="periodtype"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<allowBlank>
<![CDATA[false]]></allowBlank>
<CustomData>
<![CDATA[false]]></CustomData>
<Dictionary class="com.fr.data.impl.CustomDictionary">
<CustomDictAttr>
<Dict key="当年" value="当年 "/>
<Dict key="当季" value="当季"/>
</CustomDictAttr>
</Dictionary>
<widgetValue>
<O>
<![CDATA[]]></O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="268" y="10" width="125" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="时间维度"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O>
<![CDATA[时间维度：]]></O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="0" autoline="true"/>
<FRFont name="微软雅黑" style="1" size="72" foreground="-1"/>
<border style="0" color="-723724"/>
</InnerWidget>
<BoundsAttr x="208" y="10" width="60" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TreeComboBoxEditor">
<Listener event="afterinit">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[var wiget= this.options.form.getWidgetByName("org");
var deptcode=wiget.getValue();
var sql=" select org_name from dim_org where org_id ='"+deptcode+"'";
var  deptname=FR.remoteEvaluate('sql("oracle_test","'+sql+'",1,1)');
wiget.setText(deptname) ;]]></Content>
</JavaScript>
</Listener>
<WidgetName name="org"/>
<LabelName name="组织："/>
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
<![CDATA[Tree1]]></Name>
</TableData>
</TableDataDictAttr>
</Dictionary>
<widgetValue>
<databinding>
<![CDATA[{Name:org,Key:ORG_ID}]]></databinding>
</widgetValue>
</InnerWidget>
<BoundsAttr x="50" y="10" width="125" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="label0_c"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O>
<![CDATA[组织：]]></O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="2" autoline="true"/>
<FRFont name="微软雅黑" style="1" size="72" foreground="-1"/>
<border style="0" color="-723724"/>
</InnerWidget>
<BoundsAttr x="10" y="10" width="40" height="21"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="org"/>
<Widget widgetName="periodtype"/>
<Widget widgetName="Search_c"/>
</MobileWidgetList>
<Display display="true"/>
<DelayDisplayContent delay="false"/>
<UseParamsTemplate use="false"/>
<Position position="0"/>
<Design_Width design_width="960"/>
<NameTagModified>
<TagModified tag="comboBox0" modified="true"/>
<TagModified tag="periodtype_c" modified="true"/>
<TagModified tag="periodtype" modified="true"/>
</NameTagModified>
<WidgetNameTagMap>
<NameTag name="org" tag="组织："/>
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
<![CDATA[全口径]]></O>
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
<![CDATA[受限资金]]></O>
</ColumnConfig>
<ColumnConfig name="CANSHUMING" isKey="false" skipUnmodified="false">
<O>
<![CDATA[org;periodtype;]]></O>
</ColumnConfig>
<ColumnConfig name="CANSHU" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(len($org)=0 ,"",$org_name+";")+

if(len($periodtype)=0 ,"",$periodtype+";")]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="CANSHUMINGYUCANSHU" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(len($org)=0,"","org:"+$org_name)+"; "+

if(len($periodtype)=0,"","periodtype:"+$periodtype)+"; "]]></Attributes>
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
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=TODAY()]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="IP" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=GetIP()]]></Attributes>
</O>
</ColumnConfig>
<Condition class="com.fr.data.condition.ListCondition"/>
</DMLConfig>
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[null]]></Content>
</JavaScript>
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
<![CDATA[全口径]]></O>
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
<![CDATA[受限资金]]></O>
</ColumnConfig>
<ColumnConfig name="CANSHUMING" isKey="false" skipUnmodified="false">
<O>
<![CDATA[org;periodtype]]></O>
</ColumnConfig>
<ColumnConfig name="CANSHU" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(len($org)=0 ,"",$org_name+";")+

if(len($periodtype)=0 ,"",$periodtype+";")]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="CANSHUMINGYUCANSHU" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(len($org)=0,"","org:"+$org_name)+"; "+
if(len($periodtype)=0,"","periodtype:"+$periodtype)+"; "]]></Attributes>
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
<![CDATA[=if(len($info)=0,"",
$info+":"+"/ThreeLevelPage/HX_FNC_CAPITAL_THREE.cpt")]]></Attributes>
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
<![CDATA[if( $org = $org99  , 1<0 , 0<1 )]]></Formula>
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
<![CDATA[if( $info = $info99  , 1<0 , 0<1 )]]></Formula>
</Condition>
</JoinCondition>
</Condition>
</DMLConfig>
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="org"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$org]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="periodtype"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$periodtype]]></Attributes>
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
<![CDATA[this.options.form.getWidgetByName("org99").setValue(org);
this.options.form.getWidgetByName("periodtype99").setValue(periodtype);
this.options.form.getWidgetByName("info99").setValue(info);
]]></Content>
</JavaScript>
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
<![CDATA[1143000,0,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" cs="5" s="0">
<O t="RichText">
<RichText>
<RichChar styleIndex="1">
<text>
<![CDATA[目标]]></text>
</RichChar>
<RichChar styleIndex="2">
<text>
<![CDATA[${=IF(LEN(A2)=0,'0',A2)}]]></text>
</RichChar>
<RichChar styleIndex="1">
<text>
<![CDATA[亿]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="0" r="1">
<O t="DSColumn">
<Attributes dsName="meter" columnName="TARGET"/>
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
<FRFont name="微软雅黑" style="0" size="88" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="152" foreground="-16711937"/>
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
<![CDATA[1143000,0,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" cs="5" s="0">
<O t="RichText">
<RichText>
<RichChar styleIndex="1">
<text>
<![CDATA[目标]]></text>
</RichChar>
<RichChar styleIndex="2">
<text>
<![CDATA[${=A2}]]></text>
</RichChar>
<RichChar styleIndex="1">
<text>
<![CDATA[亿]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="0" r="1">
<O t="DSColumn">
<Attributes dsName="meter" columnName="TARGET"/>
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
<FRFont name="微软雅黑" style="0" size="88" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="152" foreground="-16711937"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</body>
</InnerWidget>
<BoundsAttr x="55" y="201" width="152" height="31"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report3_c_c_c"/>
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
<WidgetName name="report3_c_c_c"/>
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
<![CDATA[10896600,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O>
<![CDATA[受限资金净提取目标完成情况]]></O>
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
<BoundsAttr x="274" y="5" width="250" height="25"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report3_c_c"/>
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
<WidgetName name="report3_c_c"/>
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
<![CDATA[8382000,8382000,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O>
<![CDATA[受限资金净提取区域分布]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[1==sql("oracle_test","select org_level from  dim_org_jxjl where  org_id= '"+$org+"'",1,1)]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[3==sql("oracle_test","select org_level from  dim_org_jxjl where  org_id= '"+$org+"'",1,1)]]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="1" r="0" s="0">
<O>
<![CDATA[受限资金净提取TOP10]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[2==sql("oracle_test","select org_level from  dim_org_jxjl where  org_id= '"+$org+"'",1,1)]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[3==sql("oracle_test","select org_level from  dim_org_jxjl where  org_id= '"+$org+"'",1,1)]]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
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
<BoundsAttr x="603" y="5" width="250" height="25"/>
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
<Parameters/>
<Content>
<![CDATA[var org='${=$org}';
var flag='N';
var periodtype='${=$periodtype}';
if(periodtype=='当季'){
	flag='Y';
	}
window.parent.parent.FS.tabPane.addItem({title:"资金净提完成情况表",src:"${servletURL}?reportlet=doc/YJFX/HX_FNC_CAPITAL_THREE.cpt&op=view&is_show="+flag+"&org="+org})]]></Content>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="当前决策报表对象2">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="info"/>
<O>
<![CDATA[受限资金]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report7_c"/>
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
<![CDATA[$project='其他']]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
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
<![CDATA[var org='${=$org}';
var flag='N';
var periodtype='${=$periodtype}';
if(periodtype=='当季'){
	flag='Y';
	}
window.parent.parent.FS.tabPane.addItem({title:"资金净提完成情况表",src:"${servletURL}?reportlet=doc/YJFX/HX_FNC_CAPITAL_THREE.cpt&op=view&is_show="+flag+"&org="+org})]]></Content>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="当前决策报表对象2">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="info"/>
<O>
<![CDATA[受限资金]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report7_c"/>
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
<![CDATA[$project='其他']]></Formula>
</Condition>
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
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72" foreground="-14701313"/>
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
<BoundsAttr x="784" y="250" width="59" height="24"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
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
<![CDATA[10896600,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O>
<![CDATA[受限资金余额目标完成情况]]></O>
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
<BoundsAttr x="13" y="5" width="250" height="25"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TextEditor">
<WidgetName name="org99"/>
<WidgetAttr invisible="true" description="">
<PrivilegeControl/>
</WidgetAttr>
<TextAttr/>
<Reg class="com.fr.form.ui.reg.NoneReg"/>
<widgetValue>
<databinding>
<![CDATA[{Name:org,Key:ORG_ID}]]></databinding>
</widgetValue>
</InnerWidget>
<BoundsAttr x="216" y="3" width="80" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TextEditor">
<WidgetName name="periodtype99"/>
<WidgetAttr invisible="true" description="">
<PrivilegeControl/>
</WidgetAttr>
<TextAttr/>
<Reg class="com.fr.form.ui.reg.NoneReg"/>
<widgetValue>
<O>
<![CDATA[当年]]></O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="376" y="34" width="34" height="21"/>
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
<BoundsAttr x="427" y="30" width="21" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TextEditor">
<WidgetName name="org_name"/>
<WidgetAttr invisible="true" description="">
<PrivilegeControl/>
</WidgetAttr>
<TextAttr/>
<Reg class="com.fr.form.ui.reg.NoneReg"/>
<widgetValue>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=sql("oracle_test","select o.org_name  from dim_org  o    where  o.org_id  ='"+$org+"'",1,1)]]></Attributes>
</O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="91" y="3" width="80" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report7_c"/>
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
<WidgetName name="report7_c"/>
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
<![CDATA[864000,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[9753600,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O>
<![CDATA[受限资金净提取完成情况表]]></O>
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
<BoundsAttr x="13" y="244" width="261" height="27"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<Listener event="afterinit">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[
var timer1 = setTimeout(function(){
 		  var _x = $('.slimScrollBarY')[0]A;
 	//	  if(_x){
$('.slimScrollBarY').css('width','15px'); //Y轴宽
$('.slimScrollBarX').css('height','15px');//X轴高
$('.slimScrollBarX').css('background','#227087');//X轴颜色
$('.slimScrollBarX').css('opacity','0.99');//X轴透明度
$('.slimScrollBarY').css('background','#227087');//Y轴颜色
$('.slimScrollBarY').css('opacity','0.99');//Y轴透明度    
 		 clearInterval(timer1);
 			 //}
 	  	},1000);
 	  	]]></Content>
</JavaScript>
</Listener>
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
<HR F="0" T="2"/>
<FR/>
<HC F="0" T="2"/>
<FC/>
<UPFCR COLUMN="true" ROW="true"/>
</ReportPageAttr>
<ColumnPrivilegeControl/>
<RowPrivilegeControl/>
<RowHeight defaultValue="723900">
<![CDATA[1296000,1008000,1008000,1008000,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[432000,5715000,6096000,2592000,2592000,2592000,720000,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1" rs="2" s="0">
<O>
<![CDATA[组织机构]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="1" rs="2" s="0">
<O>
<![CDATA[指标]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="1" cs="3" s="0">
<O t="DSColumn">
<Attributes dsName="report" columnName="DESCRIPTION"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="1"/>
</C>
<C c="3" r="2" s="0">
<O>
<![CDATA[目标]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="2" s="0">
<O>
<![CDATA[实际]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="2" s="0">
<O>
<![CDATA[完成率]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="3" s="1">
<O t="DSColumn">
<Attributes dsName="report" columnName="ORG_NAME"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="2" r="3" s="2">
<O t="DSColumn">
<Attributes dsName="report" columnName="INDEX_ID"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=replace($$$,"SX","受限")]]></Content>
</Present>
<Expand dir="0"/>
</C>
<C c="3" r="3" s="3">
<O t="DSColumn">
<Attributes dsName="report" columnName="TARGET"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[LEN($$$)=0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="4" r="3" s="3">
<O t="DSColumn">
<Attributes dsName="report" columnName="ACTUAL"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[LEN($$$)=0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="5" r="3" s="4">
<O t="DSColumn">
<Attributes dsName="report" columnName="LVS"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[LEN($$$)=0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="6" r="4">
<PrivilegeControl/>
<Expand/>
</C>
</CellElementList>
<ReportAttrSet>
<ReportSettings headerHeight="0" footerHeight="0">
<PaperSetting/>
</ReportSettings>
</ReportAttrSet>
<WorkSheetAttr/>
</FormElementCase>
<StyleList>
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
<Style horizontal_alignment="2" imageLayout="1" paddingLeft="4">
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0]]></Format>
<FRFont name="微软雅黑" style="0" size="72" foreground="-1"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-16174771"/>
<Bottom style="1" color="-16174771"/>
<Left style="1" color="-16174771"/>
<Right style="1" color="-16174771"/>
</Border>
</Style>
<Style horizontal_alignment="2" imageLayout="1" paddingRight="4">
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
<Style imageLayout="1" paddingRight="4">
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
<Style imageLayout="1" paddingRight="4">
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0%]]></Format>
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
<ReportFitAttr fitStateInPC="3" fitFont="false"/>
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
<border style="1" color="-16377030" borderRadius="0" type="0" borderStyle="0"/>
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
<HR F="0" T="2"/>
<FR/>
<HC/>
<FC/>
<UPFCR COLUMN="false" ROW="true"/>
</ReportPageAttr>
<ColumnPrivilegeControl/>
<RowPrivilegeControl/>
<RowHeight defaultValue="723900">
<![CDATA[1152000,864000,864000,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[432000,7810500,9829800,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,5791200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1" rs="2" s="0">
<O>
<![CDATA[组织机构]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="1" rs="2" s="0">
<O>
<![CDATA[科目]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="1" cs="2" s="0">
<O>
<![CDATA[2018年]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="1" cs="2" s="0">
<O>
<![CDATA[1季度]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="1" cs="2" s="0">
<O>
<![CDATA[2季度]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="1" cs="2" s="0">
<O>
<![CDATA[3季度]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="1" cs="2" s="0">
<O>
<![CDATA[4季度]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="2" s="0">
<O>
<![CDATA[目标]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="2" s="0">
<O>
<![CDATA[实际]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="2" s="0">
<O>
<![CDATA[目标]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="2" s="0">
<O>
<![CDATA[实际]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="2" s="0">
<O>
<![CDATA[目标]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="2" s="0">
<O>
<![CDATA[实际]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="2" s="0">
<O>
<![CDATA[目标]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="2" s="0">
<O>
<![CDATA[实际]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="2" s="0">
<O>
<![CDATA[目标]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="12" r="2" s="0">
<O>
<![CDATA[实际]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="3" s="1">
<O>
<![CDATA[京南区域事业部]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="3" s="2">
<O>
<![CDATA[合计]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="3" s="3">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="3" s="3">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="3" s="3">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="3" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="3" s="3">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="3" s="3">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="3" s="3">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="3" s="3">
<O t="I">
<![CDATA[333]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="3" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="12" r="3" s="3">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="4" rs="4" s="4">
<O>
<![CDATA[固安区域]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="4" s="5">
<O>
<![CDATA[合计]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="4" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="4" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="4" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="4" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="4" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="4" s="6">
<O t="I">
<![CDATA[4]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="4" s="6">
<O t="I">
<![CDATA[4]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="4" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="4" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="12" r="4" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="5" s="7">
<O>
<![CDATA[经营活动产生的现金流量净额]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="5" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="5" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="5" s="6">
<O t="I">
<![CDATA[333]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="5" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="5" s="6">
<O t="I">
<![CDATA[333]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="5" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="5" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="5" s="6">
<O t="I">
<![CDATA[4]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="5" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="12" r="5" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="6" s="7">
<O>
<![CDATA[投资活动产生的现金流量净额]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="6" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="6" s="6">
<O t="I">
<![CDATA[2]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="6" s="6">
<O t="I">
<![CDATA[444]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="6" s="6">
<O t="I">
<![CDATA[333]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="6" s="6">
<O t="I">
<![CDATA[34]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="6" s="6">
<O t="I">
<![CDATA[333]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="6" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="6" s="6">
<O t="I">
<![CDATA[4]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="6" s="6">
<O t="I">
<![CDATA[333]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="12" r="6" s="6">
<O t="I">
<![CDATA[444]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="7" s="7">
<O>
<![CDATA[筹资活动产生的现金流量净额]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="7" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="7" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="7" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="7" s="6">
<O t="I">
<![CDATA[333]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="7" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="7" s="6">
<O t="I">
<![CDATA[344]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="7" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="7" s="6">
<O t="I">
<![CDATA[4]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="7" s="6">
<O t="I">
<![CDATA[4]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="12" r="7" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="8" rs="4" s="4">
<O>
<![CDATA[永清区域]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="8" s="5">
<O>
<![CDATA[合计]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="8" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="8" s="6">
<O t="I">
<![CDATA[2]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="8" s="6">
<O t="I">
<![CDATA[444]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="8" s="6">
<O t="I">
<![CDATA[4]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="8" s="6">
<O t="I">
<![CDATA[433]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="8" s="6">
<O t="I">
<![CDATA[43]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="8" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="8" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="8" s="6">
<O t="I">
<![CDATA[4]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="12" r="8" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="9" s="7">
<O>
<![CDATA[经营活动产生的现金流量净额]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="9" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="9" s="6">
<O t="I">
<![CDATA[333]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="9" s="6">
<O t="I">
<![CDATA[44]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="9" s="6">
<O t="I">
<![CDATA[44]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="9" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="9" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="9" s="6">
<O t="I">
<![CDATA[333]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="9" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="9" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="12" r="9" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="10" s="7">
<O>
<![CDATA[投资活动产生的现金流量净额]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="10" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="10" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="10" s="6">
<O t="I">
<![CDATA[333]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="10" s="6">
<O t="I">
<![CDATA[333]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="10" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="10" s="6">
<O t="I">
<![CDATA[43]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="10" s="6">
<O t="I">
<![CDATA[44]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="10" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="10" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="12" r="10" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="11" s="7">
<O>
<![CDATA[筹资活动产生的现金流量净额]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="11" s="6">
<O t="I">
<![CDATA[23]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="11" s="6">
<O t="I">
<![CDATA[4]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="11" s="6">
<O t="I">
<![CDATA[4]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="11" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="11" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="11" s="6">
<O t="I">
<![CDATA[223]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="11" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="11" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="11" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="12" r="11" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="12" rs="4" s="4">
<O>
<![CDATA[永清区域]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="12" s="5">
<O>
<![CDATA[合计]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="12" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="12" s="6">
<O t="I">
<![CDATA[2]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="12" s="6">
<O t="I">
<![CDATA[444]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="12" s="6">
<O t="I">
<![CDATA[4]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="12" s="6">
<O t="I">
<![CDATA[433]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="12" s="6">
<O t="I">
<![CDATA[43]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="12" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="12" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="12" s="6">
<O t="I">
<![CDATA[4]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="12" r="12" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="13" s="7">
<O>
<![CDATA[经营活动产生的现金流量净额]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="13" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="13" s="6">
<O t="I">
<![CDATA[333]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="13" s="6">
<O t="I">
<![CDATA[44]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="13" s="6">
<O t="I">
<![CDATA[44]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="13" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="13" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="13" s="6">
<O t="I">
<![CDATA[333]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="13" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="13" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="12" r="13" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="14" s="7">
<O>
<![CDATA[投资活动产生的现金流量净额]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="14" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="14" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="14" s="6">
<O t="I">
<![CDATA[333]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="14" s="6">
<O t="I">
<![CDATA[333]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="14" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="14" s="6">
<O t="I">
<![CDATA[43]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="14" s="6">
<O t="I">
<![CDATA[44]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="14" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="14" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="12" r="14" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="15" s="7">
<O>
<![CDATA[筹资活动产生的现金流量净额]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="15" s="6">
<O t="I">
<![CDATA[23]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="15" s="6">
<O t="I">
<![CDATA[4]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="15" s="6">
<O t="I">
<![CDATA[4]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="15" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="15" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="15" s="6">
<O t="I">
<![CDATA[223]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="15" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="15" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="15" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="12" r="15" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="16" rs="4" s="4">
<O>
<![CDATA[永清区域]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="16" s="5">
<O>
<![CDATA[合计]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="16" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="16" s="6">
<O t="I">
<![CDATA[2]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="16" s="6">
<O t="I">
<![CDATA[444]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="16" s="6">
<O t="I">
<![CDATA[4]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="16" s="6">
<O t="I">
<![CDATA[433]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="16" s="6">
<O t="I">
<![CDATA[43]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="16" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="16" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="16" s="6">
<O t="I">
<![CDATA[4]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="12" r="16" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="17" s="7">
<O>
<![CDATA[经营活动产生的现金流量净额]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="17" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="17" s="6">
<O t="I">
<![CDATA[333]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="17" s="6">
<O t="I">
<![CDATA[44]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="17" s="6">
<O t="I">
<![CDATA[44]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="17" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="17" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="17" s="6">
<O t="I">
<![CDATA[333]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="17" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="17" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="12" r="17" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="18" s="7">
<O>
<![CDATA[投资活动产生的现金流量净额]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="18" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="18" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="18" s="6">
<O t="I">
<![CDATA[333]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="18" s="6">
<O t="I">
<![CDATA[333]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="18" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="18" s="6">
<O t="I">
<![CDATA[43]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="18" s="6">
<O t="I">
<![CDATA[44]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="18" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="18" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="12" r="18" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="19" s="7">
<O>
<![CDATA[筹资活动产生的现金流量净额]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="19" s="6">
<O t="I">
<![CDATA[23]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="19" s="6">
<O t="I">
<![CDATA[4]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="19" s="6">
<O t="I">
<![CDATA[4]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="19" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="19" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="19" s="6">
<O t="I">
<![CDATA[223]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="19" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="19" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="19" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="12" r="19" s="6">
<O t="I">
<![CDATA[33]]></O>
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
<Background name="ColorBackground" color="-6877671"/>
<Border>
<Top style="1" color="-1"/>
<Bottom style="1" color="-1"/>
<Left style="1" color="-1"/>
<Right style="1" color="-1"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1" paddingLeft="12">
<FRFont name="微软雅黑" style="0" size="64"/>
<Background name="ColorBackground" color="-6710887"/>
<Border>
<Top style="1" color="-1"/>
<Bottom style="1" color="-1"/>
<Left style="1" color="-1"/>
<Right style="1" color="-1"/>
</Border>
</Style>
<Style horizontal_alignment="2" imageLayout="1" paddingLeft="6">
<FRFont name="微软雅黑" style="0" size="64"/>
<Background name="ColorBackground" color="-6710887"/>
<Border>
<Top style="1" color="-1"/>
<Bottom style="1" color="-1"/>
<Left style="1" color="-1"/>
<Right style="1" color="-1"/>
</Border>
</Style>
<Style horizontal_alignment="4" imageLayout="1" paddingLeft="6" paddingRight="6">
<FRFont name="微软雅黑" style="0" size="64"/>
<Background name="ColorBackground" color="-6710887"/>
<Border>
<Top style="1" color="-1"/>
<Bottom style="1" color="-1"/>
<Left style="1" color="-1"/>
<Right style="1" color="-1"/>
</Border>
</Style>
<Style horizontal_alignment="4" imageLayout="1" paddingLeft="32">
<FRFont name="微软雅黑" style="0" size="64"/>
<Background name="ColorBackground" color="-1644826"/>
<Border>
<Top style="1" color="-1"/>
<Bottom style="1" color="-1"/>
<Left style="1" color="-1"/>
<Right style="1" color="-1"/>
</Border>
</Style>
<Style horizontal_alignment="2" imageLayout="1" paddingLeft="8">
<FRFont name="微软雅黑" style="0" size="64"/>
<Background name="ColorBackground" color="-1644826"/>
<Border>
<Top style="1" color="-1"/>
<Bottom style="1" color="-1"/>
<Left style="1" color="-1"/>
<Right style="1" color="-1"/>
</Border>
</Style>
<Style horizontal_alignment="4" imageLayout="1" paddingLeft="12" paddingRight="6">
<FRFont name="微软雅黑" style="0" size="64"/>
<Background name="ColorBackground" color="-1644826"/>
<Border>
<Top style="1" color="-1"/>
<Bottom style="1" color="-1"/>
<Left style="1" color="-1"/>
<Right style="1" color="-1"/>
</Border>
</Style>
<Style horizontal_alignment="2" imageLayout="1" paddingLeft="12">
<FRFont name="微软雅黑" style="0" size="64"/>
<Background name="ColorBackground" color="-1644826"/>
<Border>
<Top style="1" color="-1"/>
<Bottom style="1" color="-1"/>
<Left style="1" color="-1"/>
<Right style="1" color="-1"/>
</Border>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ReportFitAttr fitStateInPC="1" fitFont="false"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</body>
</InnerWidget>
<BoundsAttr x="8" y="243" width="845" height="217"/>
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
<![CDATA[288000,1257300,1143000,3024000,1008000,432000,1008000,1008000,1008000,1008000,1008000,0,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[288000,720000,2743200,2743200,2743200,2743200,2743200,432000,2160000,2160000,2160000,2160000,2743200,2743200,2743200,2743200,2743200,720000,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="2" s="0">
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="2" r="2" cs="5" s="0">
<O t="RichText">
<RichText>
<RichChar styleIndex="1">
<text>
<![CDATA[当前余额]]></text>
</RichChar>
<RichChar styleIndex="2">
<text>
<![CDATA[${=IF(LEN(D12)=0,'0',D12)}]]></text>
</RichChar>
<RichChar styleIndex="1">
<text>
<![CDATA[亿]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="8" r="2" cs="9" rs="9">
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
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
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
<AxisRange maxValue="=if(or(max(column.GROUP(ACTUAL), column.GROUP(TARGET)) = 0, len(max(column.GROUP(ACTUAL), column.GROUP(TARGET))) = 0), 0, max(column.GROUP(ACTUAL), column.GROUP(TARGET))) * 1.5"/>
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
<AxisRange minValue="=0" maxValue="=max(value(&quot;column&quot;,13))*1.5"/>
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
<![CDATA[#0.#亿元]]></Format>
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
<![CDATA[#0.#]]></Format>
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
<AxisRange maxValue="=if(or(max(column.GROUP(ACTUAL), column.GROUP(TARGET)) = 0, len(max(column.GROUP(ACTUAL), column.GROUP(TARGET))) = 0), 0, max(column.GROUP(ACTUAL), column.GROUP(TARGET))) * 1.5"/>
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
<AxisRange minValue="=0" maxValue="=max(value(&quot;column&quot;,13))*1.5"/>
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
<AxisRange maxValue="=if(or(max(column.GROUP(ACTUAL), column.GROUP(TARGET)) = 0, len(max(column.GROUP(ACTUAL), column.GROUP(TARGET))) = 0), 0, max(column.GROUP(ACTUAL), column.GROUP(TARGET))) * 1.5"/>
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
<AxisRange minValue="=0" maxValue="=max(value(&quot;column&quot;,13))*1.5"/>
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
<![CDATA[column]]></Name>
</TableData>
<CategoryName value="DESCRIPTION"/>
<ChartSummaryColumn name="TARGET" function="com.fr.data.util.function.NoneFunction" customName="目标"/>
<ChartSummaryColumn name="ACTUAL" function="com.fr.data.util.function.NoneFunction" customName="实际"/>
</MoreNameCDDefinition>
</DefinitionMap>
<DefinitionMap key="line">
<MoreNameCDDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[column]]></Name>
</TableData>
<CategoryName value="DESCRIPTION"/>
<ChartSummaryColumn name="LVS" function="com.fr.data.util.function.NoneFunction" customName="完成率"/>
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
<C c="17" r="2">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[3 = sql("oracle_test", "select org_level from  dim_org_jxjl where  org_id= '" + $org + "'", 1, 1)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="18" r="2" cs="6" rs="9">
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
<Attr isCommon="false"/>
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
<HtmlLabel customText="function(){ return this.seriesName+&apos;&lt;br/&gt;&apos;+FR.contentFormat(this.value,&quot;#&quot;)+&apos;亿元 &apos;+FR.contentFormat(this.percentage,&quot;#%&quot;);}" useHtml="true" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
</AttrToolTipContent>
</labelDetail>
</AttrLabel>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrTooltip">
<AttrTooltip>
<Attr enable="true" duration="4" followMouse="false" showMutiSeries="false" isCustom="true"/>
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
<![CDATA[#0.#亿元]]></Format>
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
<Attr position="4" visible="false"/>
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
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
<PieAttr4VanChart roseType="normal" startAngle="0.0" endAngle="360.0" innerRadius="0.0" supportRotation="false"/>
<VanChartRadius radiusType="auto" radius="100"/>
</Plot>
<ChartDefinition>
<OneValueCDDefinition seriesName="ORG_NAME" valueName="ACTUAL" function="com.fr.data.util.function.NoneFunction">
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[piechart]]></Name>
</TableData>
<CategoryName value="无"/>
</OneValueCDDefinition>
</ChartDefinition>
</Chart>
<tools hidden="false" sort="false" export="false" fullScreen="false"/>
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
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[1= sql("oracle_test", "select org_level from  dim_org_jxjl where  org_id= '" + $org + "'", 1, 1)]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[3= sql("oracle_test", "select org_level from  dim_org_jxjl where  org_id= '" + $org + "'", 1, 1)]]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="24" r="2" cs="6" rs="9">
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
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
<newColor borderColor="-1"/>
</AttrBorder>
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
<Attr showLine="false" autoAdjust="false" position="0" isCustom="true"/>
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
<FillStyleName fillStyleName="排名"/>
<isCustomFillStyle isCustomFillStyle="false"/>
<ColorList>
<OColor colvalue="-16713985"/>
<OColor colvalue="-11184811"/>
<OColor colvalue="-4363512"/>
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
<FRFont name="Verdana" style="0" size="88" foreground="-10066330"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="true"/>
<AxisLineStyle AxisStyle="0" MainGridStyle="1"/>
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
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="true"/>
<AxisLineStyle AxisStyle="1" MainGridStyle="1"/>
<newLineColor lineColor=""/>
<AxisPosition value="2"/>
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
<VanChartAxisAttr mainTickLine="0" secTickLine="0" axisName="Y轴" titleUseHtml="false" autoLabelGap="true" limitSize="false" maxHeight="15.0" commonValueFormat="true" isRotation="false"/>
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
<ChartDefinition>
<MoreNameCDDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[bar]]></Name>
</TableData>
<CategoryName value="ORG_NAME"/>
<ChartSummaryColumn name="ACTUAL" function="com.fr.data.util.function.NoneFunction" customName="资金净提额"/>
</MoreNameCDDefinition>
</ChartDefinition>
</Chart>
<tools hidden="false" sort="false" export="false" fullScreen="false"/>
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
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[2 = sql("oracle_test", "select org_level from  dim_org_jxjl where  org_id= '" + $org + "'", 1, 1)]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[3 = sql("oracle_test", "select org_level from  dim_org_jxjl where  org_id= '" + $org + "'", 1, 1)]]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="30" r="2" cs="6" rs="9">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[2 = sql("oracle_test", "select org_level from  dim_org_jxjl where  org_id= '" + $org + "'", 1, 1)]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[1 = sql("oracle_test", "select org_level from  dim_org_jxjl where  org_id= '" + $org + "'", 1, 1)]]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="1" r="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="3" cs="5" rs="8">
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
<FRFont name="微软雅黑" style="0" size="96" foreground="-197380"/>
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
<FRFont name="微软雅黑" style="1" size="96" foreground="-16711681"/>
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
<OneValueCDDefinition seriesName="INDEX_ID" valueName="LVS" function="com.fr.data.util.function.NoneFunction">
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[meter]]></Name>
</TableData>
<CategoryName value="ORG_NAME"/>
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
<Expand/>
</C>
<C c="1" r="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="5">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="8">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="9">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="10">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="11">
<O t="DSColumn">
<Attributes dsName="meter" columnName="TARGET"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="3" r="11">
<O t="DSColumn">
<Attributes dsName="meter" columnName="ACTUAL"/>
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
<FRFont name="微软雅黑" style="0" size="88" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="152" foreground="-16711937"/>
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
<FRFont name="宋体" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
<IM>
<![CDATA[<4I'QPAqO"4E>O:N#!*A&4ZC"!Ke'mOCluB.Hqg+@RqAYQ\;_fN#\M=dRYTG]A)0D.q7cTMhW
q]AOfWjJnFmldqY4Ghm[\aB\&Vp\m!0F4pGch,K@"SI[X?$F\qfcKQ-OBg(&Lu>onp90WQjfW
BXib5D_K-u[pd6Yj&k,lI7W584rEP\m-lYan9CNW5<XsjR@XgXG330blD%Y>q5PR@QqEE#&U
s\s#f^$i!ibk\uWqm(Od_'c=63IZ<>43KEg-+R[$F%cKE@q0up%cAQ"P*lqH/p#4rbY$VpN;
kV]A-mWYplB.ka`H]A@:&_$co1/!\WrHi%jYo2%%R?prj[.rs;WUtB(.,7NIk'FE.LElP0GO<W
G4LKXGqWIN-OPl(s6;JZCU/@:n6)XalEc(\P<$lYl&HS^@Bg&<:TpI,s)"gi'F@kb2"em]A[!
t7\5]AO)"k_'6l0K(TJjKFLA=(=>fB`nM/MqqnJ'[$-UEj+1-E.oD-H\6,us.@?AJ&1EDD@r4
:djQmqqkioXD]Artn8goK.-Jj59_o'<nr:43C'.c`\gu!m'=()'.ae39G"_<qAc4O/-emAdq;
ZEBLMbua3#?>UGjQo*1+NF<.UjhlmS&H).nc!DD+\e2o)".EHJtE$35;RC.*RQ[hG+G^Dq'Y
AYn_j:s1>0GmqDE4iLt\a*qbu$pE<;fHETjIK_RcHIShV+5k070NEpOtR3)4so'+%Q&oD_`b
?]A&9[A&@86Hc0?7P_L;7hCP/;+ng=ON*Q.MT1Clr[JAn`l1te2*4?[&gk$NC,-^g^U&"3p=+
n\-lfi;R>,GOj577<2Yj1P(3]Ah?+!K[Q'Tq'd#!SEX._nSRL2^G$!jCiUVWoJ3Uo328"h-ld
Ii<fO24tJr8HOjW`r]AD2='ofK.^Tb,Z-Xpm#ruLj<9C`]Afd,4^Jh8fNtqPU52BOo^&9gI<j)
0\119FrpbS@Q'I5LF0Ml^9'grelVK-fA.@S7C&SU,2WV10^>2$ijicj^h3g9n;5`WV6rYFuN
*a%-DdTpS_U/l.`O6d!6>NRS21n7B&ilGfS"E?KU:"EP`<.p\m`t<Sf,#^O4F+L`R;(1'8:+
5a`@cYT>$oe?uY02l);aQ^,KFXX2T*X$n>d.5\6LQLPHF*j$CV(<XDOAbBS4oX!7"I5E^\Y7
UZ)?@#6$BE4?^`*J=n9k;WhUa1<'*D>Y(fpcff8H[Xp!9"uL<A^<"<hN)j<83o:O?4)+&;@H
@&-Mc=LNC&RV3a@-P1_J*ZGWQW'NeBF)'hHO8VbB"8GtE(YQ"]A33KAB2pnnR-c4Tu+`qLCqJ
6kFT,8Dam(2PXUU'-,NdSLK?2?#W,dc3\$1Ulq2T2d(26(.R>k\6*9V3tJ2_Fs407S@i^%ld
l[qmNcSH]AQ%#gTZH<oUN_[0?b]ACb4`fo4Kmt@oA\<3!iV_OAT)M%j)i.S58amT?C0]A8MrQGR
W8P7]AQTT!Ims99*PueLY)X`RW7OI$l"(sc$&=[2`m)b:'Dsh%+-.^r^`^DF>\mKZ_`4CC1_C
AR:T&:BV4$<(RGus"Mnto>^Js8cWiSl0SU9PuQUA>rY6h7Mid<"h^^I^E;3>]A(\_fO-bT7`?
<8R%9RPEEe5IF>iFN-7ss^'0$qa&7eSi3&EDI[9^JbkmZXeWq$Oc"6G*J,&-an-^(T?qp[mc
b"SY"%]A/4aNDm8g%`s$(%3WICsDac%rDjSLIJ;.R:C%=U4j4B!WC&"riC%0<e#/((V$&)VlF
l;./cAu)]A>-N.AuJkg@fGHdM"56r+$?"q1B$a$U0jUo,FOZiE*>eK%dA>GZ2TX"Z"m(,C\Uh
RU"12be<nRF4R+1hQ<=;^f]A8]AHH,7=--)"X<pZp21#XgG$R/V@oKC7UX7t'97i08L[Y9'#'&
>ef):i?L3>>NH!iqsi>qG<r5S8fE@ARAn&M599NH1L^MktQ?5FumW:*!\o+fF"gCfHe\L8&F
d+ffDGQ+OqNS3"0d%.Z).95mp8/1!IH?+>id:W$ck'Q"f"9b@'^\GhfP-8T,M-hZ<L'#BQL9
"`ITD&^JQjcj6*B(pko;D5F2M-.O(%rE8#,uXt[MuIZh*0tsED-Mk5O(S_nSFcVY.PKIVf@O
FRccOl7D>S3Xpfo=c4]AEs.I&h2''gZ,QPL4"=]A=gb;X2'HTEiloBjg>b@`J>7!gpX3k-r<oQ
U3]A@uJY_Z@T>c)k]A)\c./(Y_4_`1E4osKLIkgIGk9(sXFk0]A7WiN:3@d$MYpZOoe78SI6u[H
6<9pK>F]A=I9!i5#m'#Rn)%B\!=6LBND7L#21_A4uMS-&"?>&h55SqqHF5,"h2.Z]A=&1G]Anu0
Bg%0=a",Y+6NCZ--a-@h&2&Q$'LHLZX5kr<]A[X2qJ<>gc*3meVpiX]A-j<aq+aA!q77INm]AWe
f<01A5rLM?oc>]An7fA$\6>k&@+',j@j]AW<-/hGjoj\UG8_L%qkgDHu5;R#unM9;WR()"qgn*
O:pp-q,0DFK*F?Z7]AHm`^G0Qb`O$,`YN*/]A_u4Zm3C28),VoF/t/..NOf`_>8XFrc_4ct@Z)
_RrTKF35(a&J^+qe.5F8'p'V$FH[p':.$s7TPT5n"DA'2SkCph&Q_ADpF\h>l=#Ee\[MVBcl
538Glms.MqN$LY9:3(?9+)7AgC']A->;Z1J+:`mA"Nqr217I+]A9ToWs7fOH\KRfO"ik\`Nd`E
\(rd7b'UHf1Cel[=V1NmMnI<dH:X3g!$dt%n$G&iXoIt@J@'mm\fgVsFPT7nH#&eD45AD@2m
E8>:0q-qkE&?^UhsMDW9>."_Cc'=5kh=.3Za2+dFq9FUfJN/o"d,!c_dsZ(##'=&>Q,Z]AXf\
5aiP5?:Jgc.s&ABZr1hi8u`k@pKpsPFL]As#680Bt/:DOTB25,Va<(DM5?#833^G8[S64O4r?
SUTXFYa_fR-j2r0jZ[EpBiUGoEYVg:&C;?\Ke0<152&+N,sEhSXB/4c<D(]As^2q9QAefkX\o
nXp=%qMr<f-l5RHmVmC"mukL0kja6#n!5^YDGC%a$_Li48JinH$;$\-MMsr[BliCAdAP"RK7
!3--AMom#0aK?*&`GK5!hVm;8@T$K5Ol+Ya.5M40b`ir'SouVDd?Wa_1((Vr;AJH%<;@#j\^
_HM62\K[7b>24B(2N@3bIYA^c0Fn,AfZ5Cc0?3T5]A=%bTN[*&aZTUtS@aA`N,u"Fh9(;pDoH
#d>(8@8/DdKHnK:miRB4):I'V+3CGqFH8H%p2cVW*$`%"7rp1Wao.t.C)f`l)r`t0NNTt6Vs
-j6G1-Oa[i=NBJh3j4/:e^R?NHn>)%JuE=%-]AL)3'nID0_R@RTG+V<85cBV-!l#t*METUr9[
WOX`u`pUi=JsK4.`'!K%RCigi6p2<9mMgSS<H%TNjBlo#?LBbg4.;:$XkYTtPQ1#Qe+aMFPW
?1s-BW/NBVV.plnm6(9W+>$ZjodEJ$4[ZDDd=?O`b&3T3NV\%k4F#!)]Aai3d#=D_$7KC"0Yl
!!q(e"qFB%(>+^'8Y6iNY:cD13aDg@\/JW-)YN`j*"dBD5*&=/RPQa``ak_I?EMnh<E[p?#?
,15>]A%R%_t(/\=a?P#C=K#Ro$2KSXNBIcdIaa[Vc1cJO+bP7FqebjTd=f7E(2&m='1/bebLs
Ta?aV\rLo'(&YW)Sb#970.'^'&Y&Gap9Pab/<K=,k%M3+iZ99sB<K%2GLFV-G&/!XZ`\(W0R
tqLEj5&U&tM2?*>r^55#ZlW%"DWK)=]A#\#6WTrq\i;G&t6,1e%8`Ci'(&h@DH>U2koB&;Z#<
rC"9X.gJf^*W$"GK,l)dKL2cI"^dMGmi;l7&;+_aSD*<Sq7B#BJ7Ba\,">#aLELeY'60O8s^
&/VCChCVdl]At=gbOoo=n,A&q5$>P&[=3@>-uFJ"G[oAbeCVDi1<OTUq#1)]Anu!g\-/n=[WJR
eUUJ97i.0i<m9,>[N7XZSH8KtX9nhl[sH'_gt*3]AcgkK+J/^Xk`cO83ZuLess5#S\[gPl7R*
gF/A:B\jS=2[^U=+RVIQc!C:eF]A!j=]AQRh7Q9OXuQW8u8Pb_[B:PYqEarK-/dQHTO/<]AWGk%
D$!`S0f@"8]A$CV3?5\TX)?qhBBae]AIUHcdkfptHM:io_^'!"g9Jlqn="=%n$(;j(M[tfTM.^
?c;aJeH[*'%)\Gj:J/i+dm]Ar5I(kGIt"faBs2:%OXe2+E:^['&L0)?7d"NJa^=tM)a>2gq\K
!L"\ZZd8#^s.X3(Yq#"lZ?e3-C&G]AaNac"(A&4Y*I<3DrO\)ZD$P6:o.m44?lN;f#^e-ML+u
ougNM8abj@uWK,N?m`6pdTo?F[`**UAlES/Th3lO%b@3fISU<R5u3_78#[D%>FjKoTba!"pj
;#oALj[GH"(t7$!_,GeY'S":e!hnbDCP\J;?i_=+,7p<1.sN<bg#GWeK"&\hE]AV3Ik-V&"NC
os=OI1_EKk_bF54Op/_6_@#_A]A]AbB4lFK$Jfq'UWU%mf<q5BWtoShKpX3fp(!9TT=R/>NQ?F
i'<6LmmF[6d[hfZcrBM&O,U,HsAPHAM5'4%h8DZ9@=*4>jM!3:<R;W2;PuV*_+i78^<!e'*i
"e`a/>"AqCYs.h_CqHu[EeK9Xg;>-AMsSoj&\p@1BYgt$(Zg)RdXr`0e"AJj0kZ@#!qVD(f#
5?q[<iiq0cM;[qGaK6#]AA=L-%u#:-1s4^9[M@o)`m$2[B=*_^M6CD6%nC\S"#oV\>VP&l"_$
F:[_>LZWZuEQ6L[h`t'J<5L7=9$9;[0<6^,:*Kd3g:UqGL`Ig1/d[5D__BULE6)o0\fu`Ae)
cUr>_":S1P2gPRmF9MhFCuGTs`6UkHB-\U$[IED]A]AaW]A=Pc[Ik2r+IW:u?X-=:_7(YjikR@$
r^F-4JSL8f*1g2P/`o[M02oCtM*3L_<EohDAfG*;[K@Jk7Z4m)Tl1KP&WeV&<;TA-<ldl<8a
1ll.KoKnu<'?K'qOXP,_L(F6o-o&CDRLb.Lj($/doD"!O@.32Wl/^lb40%QY@XJ1f_TY<S(%
h>mBQYdA9,(CoQp7Er?DWcC;)>;dDM;N@j4+PrH5RJ_t7C%-:j<E*$(/sbu&f)gtm]ApV=[*P
)fK1Zlh\0=1k`FuJT)s!j?3B@G//]Aqh\m*srl%9kX'T2,JS/@u;9f.FSUXOtK:Hu&=tiAf>:
;"Y/*T_+=_Tce[G.A&>`F00q)O8_+9"p$lBU)Gg1F8=PI>W6[M(k]A9YJD3ADfnp#=[X^]Aa]AD
an(I2miY*<XQ3M\g"!4%>M-K)ZADO%=aPj<.TuSLh"+LW@A6Ekt.soJ<kAQ:Ug)M_(VS,7#^
.WO]AeW:/J+H\HP5l<,\!p1[oS),sU8_f=on^Ek_fBghIQ`$iJ]AO1=[]AnSYS;p%>3WcEim2aC
/QVb)/'k*'p)/e$D?`[q_^EM:90+>OUHEs\?fnt*Jl2G8Q#Qhub(;_&!#JQ97mbP(kbqmn[9
[XDGD@TOZmJh)5+YBO/$O`aak##c"DIEJ%G9ibe>i#>45DTjKPd3e0DOc[+=+=i36PnuDsKF
N0YNA"M\@D4s9&r\g@"GR`>e\$P(eG@]ACQd2)%gRdc;Us0YN^!k3J,TJl%8Z?NHhYUNHPH&]A
VW?%WfH+)PqY1QchSTa7*p^&-'qGPK+hP[[arXpb8mF3!%'d0s!HnZO,b8,!f[V!jd9n]A()@
UC6/c.oiPN&*S>)R(CWGegAj(&a=jb,!EO5Ggi_B!'15'\"Xs2=&^CC"ofpR\+hP4[0dJ(U'
',b=E,Wg`F:hh6G4#-.9*OV0R=Dp+hYEWO$TN(d.jB%d_\V?<5eu$,4W&3Z/A:(E)#@Q0a"j
?o]An+jNsG_X*1F<E>g1KN*4GJ,5p!\,ADA2I;$!EKMH^?+*=27^-02;O4F=e1Mt,)=H<L;A3
%nN=uRbUY*%;b^FSJu]AL0^q7b=DuDH^=WlCO1O@q&UV#fhiY$Rl.Lg2h;;"bnh/[hcfA;M1I
_E0FpM^!>EUU.)m7ajeNdca_!f^1,</U\R?\O-AYSlG?<Ff;[FRZ6=P/M3I>gO'J:<L`I@NB
eJWj(JiQ+DbiU"`\sT="hZE'nWT6<o[@i]A^>+%>RmOQE3S5:4IKkfO%C?#]Ae$6P5/l\]Ag'ER
mGRqIuDh7rXI_Ied=@1np7O^![D\k,j#5Y@Q8J*\TCn9.>9r,tj+H25Imqpr'lS/BKgUYjd1
ccTXb^=TQA+a_;P6.T(uI2Mn5EBjSS=k1t&\Z>-)BtNb*$JT9fj9)@Z7!r[]AGj+tMrJ8n7BT
=bJQdYXJEULD_s00IPWK38u!NpQ%]AA:!]Aft.5^mF&/(_HGI%0s4;!?OE"jERR]A)<]A*"R(=IO
S24Hr:YaY!@]A*k'+5fbB8$A[?sB.eV8Z5P=o"9=LgP;1JX=YdLaq5tm.UM]A4n0#kkJ/aJeu`
l/q0I`Y7\nKK!D1DTU)O"E`_4"a)'9jq(#'\U=YR1XT)ZTkLs(tuscR?tldbP[2FS#[%gStB
Y5FboASC(cV.1^*>(CF"gQ_'_ZiI>W&=/mS\d*=W+e$P&c8Uf_fkL'-tj-IhR-23,WKk+Vuu
DjA1uE<PU,*(LWV]A.^&ead]A<XH]AH]AK=1Mih[0\1CbTqZEESlmY)t9%:`(Hbl;s$T2`dk1Z^&
^8_ia3@s2Krc18VZ&^H7joJc*KgCN]AK[/N?1Yh"e1)A!gen@`D't4Q;aBtrnGLPC"bgai\+V
t,/g5e]A0TR=:7lR1*&>5C.NR3_ZYKsUANFeLGC7[KAqrK_l50@kGi@pjT6$^;FCD3Cb<ER+H
mHn.d)Osoc]Aum]A?qXV&80sPOZuGouQJN#(.M69JN#?-KIP7Ebrb+RuplfQl/JW_=*Z[et8ad
rhgbI4(C=9F>ct)/`)7oN3>qBkUUX8ajjlY:hCn-RNDQi\oLTRgb+Cm(cUjZ$fkH^g?FL&bE
o2W;5h-!Z3X6C1jl$)o?rHGH$o0MsO>=XaiUu@'&2Vpe-6t@Y;W,#?NC?YQ,_nYB>8&q(K4r
'&*@)d6DSq2hTr&-f#n?tJ'NS(_e=U&,WhW[M$$*Pc)WS>8,pfb2?^lP]A;r-n5d4kdMp)WE1
["Oi8'nr6I@dA"[<;O5a'!%tu8M<Fl^1s:+2V(9`YVg\(F.``*XY9JltlIY).O0)T4#EJ521
%)'n.rs8KI_b@=&LmeO!3oVPFW_nMCD"X78.#6l%R7#gaR\6A6;S3#HL-\4,ur`iqVe&"r5L
o1LLKi\7GD0poF#'@=23aY.ZAfPLS_;i.\q!42=G8&\@tQr8!SGkAq=0D]AqWJ/7binUD7qM+
rm4?$"2PFRiffA+H4^V.+no8+TLl3V!UofYV<Wq\IR9rbl:nJ-.-K0$@Aa42f.:&.QWc,t2m
tk<JSni7$WQ#pe6A7B&iSI)r\Yb[-^3r*q5-GX4U*rL2#Wdt&Nur1pt3aG8T2A-[qe```''1
S3,08jRURodJqAMVF$:C9=Bg/OBGtCR&.<C.QYm^mKNFd9W<0c%*g%/T>qB1J5D$hd?k>T.2
%+p^g]AdJD/ug,E'!Xo7n_-]Ah8<5?HAcYiJ64JE^KL)</Wu0r!9o]AM^qNBZEbO^J%[>A##jL-
PK0YujRg,NP[F$B9@1(b42*O\/I3ibQUC-TZ1eGJFX/nVn\eXTMD*9=]A`+#19\F"kkHOO[Ie
f6\:%2V[KjL#5mFFn1UCJ8T,ap"LWA\VuO``h^Z>!Cp_$[e$ujf@0EjdIZkCQYe*87WGtPI\
G*I1t`,[aF:#,h=a.QA3:Cbi`.bm2iHjbr6-$2R*L`5?;nu;rK3m(<q4YV?rrU:3f(s>ju.f
Bj3QP#LYEOO[qt_?i,HRCs"8B+enF3r)<)?1H$(&[[)^Tr4"20h]AHXMp+#8WYY+.LVM/.GK>
:-N*"'$F+5EFF"&?Wr]AE&AbsBFYRHHoa&L?jM]A60Pru@nID;6B>mAZA:7oi^b`g4m^]AlZo/m
;_>B-PAW(MA9n*((\<N3V,J`m[;\-\5L3+$(MfY;]Ag*:^F]AG^F.f!7Yi4@=>$IkFg1DkMf":
^0_<H[W\7re2qRs?c`%"_g>Ht,G-rp9DaX8Dt@7^e/jI:b\<:X^?k*M++hIMk=.Y</^WOuMR
,&/+ZbUKFSqpfVt7!(6#7UP\_Cm('LN-&VQ8QZhjTI]Ad>ncmDWV'Cm)ka__3TKP%m:GP!J6J
PP8@3_k(sd(,T^TQ*Qk3X^0A^2UVmeEqlYDG1ctF2qmSYNS/M<K?*W"'o:UNrB^QTq9@NB*L
Z3WdN4+3rO8Wm6[CRs<BG*hkF8^?%O90<X$\p&:R9VaJN@`j"mk:2H`S_rt![t&X*#$fE'M2
KX&^u/lnCs;;G5b3jbcu^hM'X4i2apieDdZ=dIHLpq;W<?/jn@8fISl&8,_RX0g_jM)oj,@+
WM1$-1+0ihF0qWg8,=D`^!lm7RG8K`/T;SKUt?KjM'in(j4#0I)[Mq8+b=61lJP`Xb*W/<$g
#K8FmBJD'-"dkLF#a1P140j<SY9h%J5_S*4ctB_M8,FQn$g3S*JUC)KZseie@jfEJiWW1#2C
bGN2!0LZU[Jpc?oH,o%\PFc:>I8(!SSD4G/i89o)JJ)tH?)tXkPIhEb]AIlUl<2Q@_K^W3pXX
FJ_.,Z!;0n/V;8M_fq;(u_^-V!dr5j")2EiKFB1E/1f1%?F3Mh+BtOcgE]A&QH"k7=f1+P@lR
PeoY,P2\r+0<E=$RXO\#:(7gVbRj+?AXN\%/<kOYPNMloFn'BU3[^T??_,o"^`mW9s.AO4DN
]A7;2?1OGClq+S\:&uB/X.]A-n"\9N,+Rrc?pZ.-I2M\F`UXF%,i(YEr]A9\queli$5o/7EZ"`p
*[o%O(QHn5EN$./nOdPbjL=P'lqEqP6W/5`\P;TJec4SJo'Jf9>3KN?2:&jDel7A02A@[mk#
,R+eWWgX9U09/f=;p.qfJORaYbFJqZl?6;'25K1bJZ!r:(9$Q)!D#<S$m*ojhm$V\3Cu=U&D
#EYhCuoInD+ea2!k*]A4O:YZZ"8S<TCcjf\&ZW*sWte`b4DTr&qV[BP=EsL1ht1`M[M\?h6i2
f)QK-lAl'=!E]A?.G?P,FmHIhV*-CMFLiJUmV8OqoTk:%%Ck!h4&OiU/8tr$lH/;+\WKO1=:?
)HS4KVgZ_3]A8lWnpe3Ud8`+:SIZF[.W/X%?e>,@!c`g%M/mu=0Mu>ddZM*WB,'W3^A=o)l*J
_(2Ml?ib7@'?AOJ*kAl29O[Ka*%6f3^1OltBBN&B5h8UHWB;8Lj<jU.:t3a::0.q`Ot.S&e-
-^;VbSb\Jr>N/j>Tk-rY8kGEMr=9'jfm6\E@_kVqkp'D@=e]AndH=kEH]ArqXNaDSO5(!:StTA
7,#CL'QhA7A^ob(M/$?X&B8058K@MHF8rT9\0hc4*SRnQPFIR.c*$Y4Q1>IfBh%CK5U;PosB
Y2/#[%toHDB#Wc(&<r'$-R4h:\eYDlnQZ1W>mA:>uBQ[Pph<)\=F+(sZu\*bOH8IiTC/(u@d
:E+>B8MZNS8j;e5N)RYsDsf"3[BdSl\sgnuOs5q0C.W>#;4"<)bC<DY`Cn717WuG"1Y9J!9L
O/K?qm<t9R(r,MkMe'_&ZZP[MUQ,+j0lC.?&B=k?Rld?i&Okf7%>EE^6k%!Q`A#;.&_h4IRk
Q*`.Ff9H=pMWA"Z51rU!;,QPG4e!jbpLXM=T&NgqmlVJZo0bcSalB!T,pr&-W'>dEg:'20uG
PP?'n4U`pL[g.DBQ@[k^V58;YU>9^MAUJDNuJ1-;nH)Xd\(I.dD0(@R<UAh%itoIRMaAMftH
Van^4MWppI8ik]A>K/H5\(KKHlYM#Cblr4&8]A'C0H%QnLi^!Y)O0ej,7H\aYn44N.1:(Oc-b_
".#G%fHm_ImIV&qpt2+Okr2D(\II,ml&.YOFk3=J^;^,E%EW^Gf/90"`bB5$I&X:"A5;'H5.
6;Wh-#'810q4nEnbofc'7Tf31-pX^HpEX3/O/E$&@1^C3<U35i56+WLQF-^,(<_+8#q%(FI/
I>+r^D-gJt3X!Dt5=OXDKaq^D;eD[tN]ALQu<.]AA>()"REQ>\'H%fVES[DR7fq)qbsseY]A/S@
k%9gkJYTW[Fl[AA<*;XoaeaTXa2JMMHS0S:oqX[`B\19Y[`J^)B2iT]A!2FbdZ6-6:(h'<OF;
d%NkW%\??pLHB1$E-SB!UQo_<2\pX#'0`2iG\C8c.>j6jo=bu_n+R>.*2O0s$Q/sB/oJUauN
lInu!_EV,a^^WcsCB'N:(m0\OGDPjqXS;7j2?fqLUTfD&ag6e-CkmnGj'&V;IW7[!)_.0&pr
HUqFM@_(;"=FB%bWrh_?0>k^dE'JjNr0Ko@K&3X:t6cQ7i8Ga8PKHkJhAZk9ifP4;$/nq<:'
O4Fhgk!:U5O;BQ[bnqAJ=T5'k"ZM0U4'hCAZm/Y"!>?nh-L-mG?;pf]AI^!oNk(sWhL`B4BQ7
kg&sd_*K;90Sa$l&lS?YHnCale'u^g"$F#TuMZ6bF&@k'>h5N*TY^q0Q//Z+p09Pm>8M0-IP
c;:WUfO-W4[g83[rX?4OW8(jg'@\`>"kGqI2KXYTO;GW9*jYkG;eJPbkYGH0nb8Stp)A")Ak
R$L`h+;O']AbhCp1]AIdU*GEZj_s"tH@QG_*<oKP8h2uNO5Sjf(/3<*[`IkbVQk>DKQj#Pa<V3
*qIRUR*lri'@JrooiI5U'7k,@7Ouf0U."#RHXQUO46G:E?4I;WT#CC3M_LBJftd0R<?NnB]Ad
`h&8,QWIh%=dUgNUo^8HGq2'HrZ%E&So:E:dN*[J&mE$]A/2B$VW`lf"J&*pW`guu`;X_6=fV
7b^sDU'LOqmDADh]An:5-2t-QZoF0Me-RuW4&_@G>o2qm3&X#<Wse]AQGM*l!@ZT=sca:4q.=*
DIB1OG2f_)CiaV$q3Mj#djP/bKf@RJUm/^aY'OT9hW@gY@d`!k2O^t9TC`e"N&pE?V95H8[i
LkH(f>&;+&IX,EZ1s[N_L!dB_J^=kX\[l_GgFha<26i?ab,^P[DVC4#Qc+!)0eP-eS$"1.)2
3(n/VTDE`i'f9D]AVs:QcN(p!c9sbFq$sVN%Ig)XLj1W#GnBQGIbenf@m5''0"ICp]A"tifVq)
ls!#LprRapZXYKQGh89\F$j*6i-,S4IgLI!"pZAWuJ<oj&^poR)mj0N[aTNY!*=`q!?&ErV`
t1*T3oY0]A-$^mopC[s=G/GJ\29;C4;TTD\`NMInB-IGE0q]A=gFOJ1KZZ'Yufc"g0Oi?+s-Ta
_p"uR">dBY$YG]AQ"T!+(,@YJ]A!Kj"B\8D!*s.>91%3kOX/^4DDY,i%M<OM.4G$4Bdm.ZtGMe
&GAW'F@.I_:GVr1]ACO<41?%4$Ej;L)pE1RZ,o>TGDC6gmZ^V(n_la-?=p)A![(]Ab1SNDXG^B
ah`3et4U,ekLLJ-]A(M>=DEA7L@5"m"HJ<R2ZK4/hZ!2M/8,^X@%FaAO^.H8Y3s%H$e*8aHCg
ME-N2@:;R%7+OiDt8F`Mn*HY!UWJ\P!4CR*UXo;Ei=$/eI,r_>'h9N5%:4"M81(T:mZ]AJ@d2
GRPU6olL'=<hpO/<u=(^ZP?BM48q]AN;nQ_&R<t<`<D!3ZZ.Xj=[rtG$<[^.qk&>sQ8$po`9p
\H3O,uT0_55d,[_6Epr#1\/iB\ib]AQn3*0gB@m[nGf4^aGJL4s4=muh0p>b`2+jBbjZgCU'f
V!SqGRfKJ9cf9.HQ.>n#.0/oM^$(3W#ugpJX%ZH>X6CU#)'JQm/2XPq.%%5YTjGWImQh?>\C
JDor;]A1R.Npbb@t?)eE<$-p0P;maZ+^>U)V!5VpM#-V,KZ.k?@X@kn':_dNVm2P[FOnVI;*r
oHl'`F@-IO#JV-]ApfhqJ;#S;h]A_37d%JHCa6E#UpMidJatSo%[lSi^]A!jbcKh=tqG/Ql8n(p
.!*1'!XZW>(."pet,g=%A8JTciWjcDa[uqMQ>n7]A6N0r%r-'/mMd5"b)f!dUUc!CI`gc8#1J
:GCT;$?MS<WAWm>=Yi%e>i7<FXn61[EKIb)r`dCRWgG`)If37)UBAm=t9^,Lb8.1E)E@lm0M
l^Y^ZG,_e9LQ)*s.A2T_n#G9J75\7h?@V_$)&[LqgN3L.(/:U$AiDbm<iu'[s+d'i%"MXQch
:u>D6H,ZU$,j<l?2XpkB[k-%s<YRYD3;+IEQGS["(ZinZ3if5+I44]A7be5$mfU#Z0:3:h^kD
)h"0G$hN>!%=+8cI.719ien-:dSn1[44u:8;@O_b.7s(HUCNX7L873-4L4bpU%Mnt^pg=qg[
GK_qJ90b0-t/gCm2`b5C@J3kI^;";3.XD_J\>]AXj`.0=C%6uS-g![u482OKN!I$VSA6f=>f`
%7Y'6;/pDOF(^)fiqcQBY<fQ/Vokm;@D1\!iaXZ)ICR$JKDWcf.J,!Eb9cq5rX3g?AK+!pl[
Bt$6r@RN-Z"3%JnZYFs!]A@+Q!#s@+PGS-a`Pde.ARH_=Yo4A<4qMFuY$<f,=$]AKVD\B0ef"b
/16Mh\Hj$=ub#aH=tAj=%%Zd,?ceKX1XcaoM>B>UCmo_+fE:(j5N5:&G#C=ss[q-h/XPjJ=I
<:DpuOj`&S3j@PCR0=kL.WTr&3+mUeBhaMotdeos<GZo53l:>3_=%:>NfX@bo*rpqi$6_Lpg
pdiD40r*IV((Q?JuA#PM@,!go+1E\Sag_!85X3XLO7Q3#t_gn)IeYN/;..Tph,LmH]A)!&L49
-[O6MYbX@@t+qlMdJPZRYFjJ0-$69JS"?V.%:)=,UTF6/a:kMs*CG!pZ-O$R0P[W#ia\8_=o
L)#o2nbm[1%E04Co868H:XkF0/:$)CTOBV6W3OerFl\+pgoisK#UKZdY+9a0!o^5FEausIEb
:e2g1AsVBJ$sX"=KZPJfg)+><sX[Q$k2UApP,6&b]AfR$`8a+/W.r`@VbQ^>bKaF5l\7iUl,(
(piQW]A=NYGI:r)BH]A4e-cQ%GH!:0euo?7G2gN,ku/HCauTNXJISp65jLd02NHKPpTs/\=jT&
m/)nBd=Ei=OI\">KPNr#fXO_4cX^O>j.GER.>jg=X^np+=_K535l(TCO\8$='qZYVYEh-^gp
'2ko8\&iZ%5W]A[]A1?lGWW!I?p/l7#=8]A80^C*f42S"XG6a>kT1om-eSi#^)_<)VO^\1+Z2kd
\VVVmbD?]Al&[3]A/\BXc)#J7ZD6W-9ZZerul_>Xs>FcZ69CN&m1ga3+hCf$T4f@\8`-G(Tm2A
ST)5t(7Lqt8W8&LV[K,j#l4ScRO03<lgqhX2"@\3%q@kajJ4mWl<`%Ct:N"+]Ad's2>OtP#3=
GDejG=f%n&fr6g\kju@_>JD8qhL4k4JXO6ab6Tt?\S@^YHk4(K,]A@l<C&SSA/Ik0Y=5^Ur#_
/I)HZ8Hcap7!>1J-ErV.N-B<IVJ[pSfn.kG)>Oo=^/9S6^1I:`/?W@e$:FbIQ&.Z:\;^MGX;
nl&b72X>[dT2D]AJ=g%f3eMC+p_K*m>VYA+7@d?)W<GA9PK0`#$Ka,rU-8M`$&.f+<70%oZPF
e)')Vf"oIW!3#IOb@^gB_eXlkBRSAJF9)A_Ve<s2-0+a-QIDrAVs=Xu,/rKaUL#=#RT0_SKo
bfqab43.F!li#\@/Whk0Kr+&br:5$=DS)q<n[8.HLdjM0Sa&_p;T36<4fB&o^d@^(!#1$u35
0519GSN-6qMT-76W1`('hDc'aiH/uE$9KY[!6Y8me!A=X1/6F(WP3Tu;9&B9os)eNC.WC_^f
R"Hcjb3/Hg8LeJQ3\1diEE)O(doWK7P>iFbVOE2`':(do=BpG41IQTdNuR:Bd<HF\9)OrWkC
BIe;!utR`_toVW`)T>tM;n1Co46kP;DR?uhp-2u+[;oG4/$',b6*5KBU4N+"\geJ0TJb;[`c
1$@_f.283/`helZ2,#X7]Ar^A"4\C<2)oS-!X4XNL[1loK:!!Mhn(rhjO4u:1rD4b+lH#ejfB
_Ngp"t6,R`j1nS/LA]APMZS7Dpm0]A]ANcmf1*WA.F\6J)A8:Y;k?aoK*tJM-P9XA.-kKNoJ7CM
6>fIGK2fSsT"N&c>a+uu&);2VpCXU[Yqi-$oat(Bm2;\BaSrVBY2Z"B4k4GNq`:R[OUS7e&h
nEP[/If"S4JU#2daESN#O@Z)_9$Hm0I\Aqp)ul]A:;U@CYbr)T3>qT4PghF%V2S9SR=X*Y"tV
Xt#Q4f+2gee/`s8YFcp7gF<ELPbf('&q%b6:->K.8+.*'"U-RBN.n52t^J-3K7O,$.N?qG9P
l%:N7]A$T$fi<IZV`#`>/jFZ074`$PmVM%tg&Ne^1L"'6>aN0Ln7o2[&7[qgfU&DoK&?iB@ZN
J9t@E[S\#e#K-inB[-.5TH"S\sGT$l#LW?pEiHn:Dtf;X?(WK!1_Q;W3G^SCc/3(nR/P.=(S
iq@XJ70SO1bkji03>FWkaRpF<TCMtks!^eEo7N9oU2F/Y0?sTV_C"5cOHLA/18)?H&1n^4mH
`WilJt2C%@/0YDEqk/6DXI>f)CT>Jg^^Oe#Q%ZtP]A34pk@L"NT0KEOBPFAi@K_)Dr(&NRnmE
KpdSXENe[jSgY^.sJ@PNofs1&u.PRO0LW9k3br(!DlesdPC;4"\#$>K#S@`O8BRA?/P*Z&1N
e4WI@0L;]A%dIF9u/#tG/cQes5'qCXhm,e'o+EoL%:6q1?A;Cr&3`(d;p"Q[LO'Z_ebjMGMW\
4_X[X4<@/1dR]A.)W5fL3#gZ2RuN2#4(/Yc+5'_G!"B!RsM-^cURta`8BedG1^`_+='<+^*$*
l4U+16Yb[b7[[D]ANh@Drp1L9=k%g&hF-X9cL*ZJ#)g\3fO(Oh?@H'rRAA53X17/kN)JWF882
?(f6DIp>RDL7j$GIN8sIT2Pi@.5CJTNm!1LnEg9g;/So6h%%E9Qj\FeRce`X.E!bhNd[4qE1
b*dW`TfMia?spYRm:o1a3Hh(L3]Ahns#W6r%1_4K"b4'tm#Q:?3,>FRe"V!B+bVT]A.jfN9a7u
,]ANC0c)kof5t'T$C^*^B<tr=TRFL<8*oUU!-HhsIV)iRtJVeP+]Ab<f;K;*\c[teIWRqI^XI+
cHm8fa\jP)`[.a'Z5so6<RdB0JQMdI`<2;m:^Z`Ycg+=A=PC_WjIBY[kfRTlWG.9Hd+E`&/D
dPfJ"N*3+rjCT?Z%#CM27U4"\1eIj\&B<n4gOkMkQf1ORuCXZjLGltmm.r-jPfXQJEl^-H'F
r-/8'3DI`C\5CKC/M@j<a=Y7=@nZ0)n;Z0q4fp4SU8KP33I<u"J,e+/(QT6NS61;SY^5d*+Y
^sN=R"&lV\IP*4O)H/C0S0[q8@PNCeW+XblDS*JE[t/9)_9*jMqTk><YqE>?(ZXTht&ps7Jr
/E[8!B^GeUY4%BISaiRYQcktrb<f\P;/WKJlXaYeTjuX^_9"Nei-K4H*)<#:*m@=K;f*ZY2o
gONn;I@]AOSAg.75!3f?FX7sL>6HQYm_g\<4r<'XZ7`3\5\JC(^C6c&42KtdBG&Wp@(B8QPSn
ckqhf#N6i]Ai)-Nn\I:9[9VuG->3suC/%uW8Lr*$k[lke2-?IsQSpd:<eoOE$4/olk$YY`7/_
sM:50]A$`*qV0R-+*>]AbgAp_FOabP>"+]ApBgQM"Ue.N,K$&^>&YqoM@#Z(+jOjC*k@_ia3.;J
#MBR$)nn`">0\tXP8KbB;-<PTH`fY_@5O[ATQ8>4W\86(ua5(h[n(T*Va!<)&bf59n045ZW2
$obRD65/`<0*h\lEp4E9_'[5'FlY5MgF2o$51[_Oc:IYG;6s`1&:,gB8M2tl0EhDnV2P=OM5
WT%_c([#rh]A:JPcVXS10mfM[6%Ss.p$/I+:(^TLD$CqBiFm2,r9l5qc[$:::cYiHp1guCCoH
e=]A_;$WcC2SNB^d!7_YUYb_%R?',5??Zh44jFT=HBmG7&;ZEb#Sdl_5ObCFK8;Mb%\fbTo!6
"RlqhkO9uF'OnI<Pt6TP;^!Ng%ibdl=*Eo-6c1-)%K)Bo\Xtk`K,)QbEUBj_Zo]Aq6L+rQc\8
2$K<.=3<FRk633e%f*?U:M_>Z.q9ckWk)C<pg*;A*JD6cUS`;EQ4)1HKYcb3%a-KkYg'+9\C
Za2-V8tZVlN9[HKjApL(l<\MbUe$ZWI,+_K!uNZXIS$"-2KZ=5MK)9F1th=k[LI8J=/#4.TK
i`0EEF2fE;Zh#\C6</*Pn$58*`O*ZrO0ZjqJ0@b58.g`"ddA4uPCp'n:W7i<QS=B*'.H"8$g
e4bpsJ]AUsl+=$V'"M/0J8X-5n.>>It%'b3U<=!S@QdrKTgqSgc;=(aYkI\OPt.?Ae]A-HU'uk
TJJNq%)ID7I9p(CF.k5UYhA`IDYfRI79cW1\0QI8l$RENG:lk-Cjp0)0&78aR#H6I%*#n=\g
M#VEbOuLY:$2gCJl,7aMoRnBVl20ar)aEuFP)(uYO]A*O^\CP0E<[^0C^bX<6L4>bCT:1WTs>
39?lW)eJ)%H3Wf+B&lL/GS5Y4W$B$L-!)bNp,d3N(PQ_uC`G7pldQeoHMn9+r+<<e&ocebrH
fp/O^5NZ<g,ji]A:f?-?@<>%Hm*=$`ZT#q93o/%f[R697(2;0i#&(o5DQ_9b3n&M5:Za7f+"-
CY.d3UEO-I/Q]A!I)>HZK>-D_c'ElY3EBHYrq1BeKV?'0\faF1/,pqUja?BT?o)F1+!+]AipaN
0MmZJ=&^mHh5:MAfbaa>\oCF<_]An&QsTP^jls"TgPcS>q`R]A03tN:gP5EoIK^@D"F:j/PK43
\#2C<\#4QENsPAUMp]A3A+;L5S8skA`L$EZ4r[FpnOYGR2F8JFpN#6^)MpT]Ahn9d=,);a<_^C
4YPOF1PhVOY9GRtcT"=9q^VMo@3uS1`kHS&@@&,hfAdOb&,-pWLdW&n\F<CtG%Ce)?DeYq?S
b#F0D[>/Gu:i%ds',kFnGGWN<J5@5ao8o[9%>X0nR1G(t*5uG6V@'@PG>(3Q.eq'S5Ujkj<e
Ypp=YlH6/*KUEB%)2H>cJD1*ki\>sXZn1joD;EP7`dX^)U@-NLK*;%`;gkC+><7[^=>UYIlj
1o"<INHnu_N29BID^AQ<;5cf4"=E[hr8)/8q,"<f`ppM3]AGi5i!(s^.r[675pU6OYSG[JTX4
)!Z?qP%Xgt0:[j`F&cfInb71"A`G9YTMBbiO[(HXt$%I*'heURAD=hHEV,D7sP,73IoWehG$
niWg+N`(cm:hKfaW444h6eqt&!Iq>\H;LL8(i(3qfCFb;JGqWP0C%FZ;,CF!4[uE\G1$,g=N
GqHV-I4.OXGLB85;,r:D2Eh\/*[]AaB;8$C0G1LQ,Gnn?5*7E@4*IC\m3GF_??']AZgQT6+Ncp
t`,EL"5=2;F68)nma&q#6H3`uFglJE8p`(jWE/ai)gkDPFTd]Ag;%1ATrZs'/Z6?.lKF5KgQ\
lJtI<m=!:Y\#1#BMEXTbM5OVd*Y=\"W_TUIKU4DRIUtdY8Ma>h8@IH,+EHr2Vt5cNP8a5-:@
$IHYCWc5_fHco$Ec9g.p(ugdJb4DSI7ln`Cod8N($9XL_hfh^1OQ<TT$ed+Rq31Z*DnCJtfM
"CNtmJH.GZC5r79`V#N6rk!T%c5@Z+MHCi1.HXD.3032a+CA=8^aG]ADjrbLc><B]AU>cP6hGC
+[lq/sUHRC-X2PuI,"Z14a"Lb:qpZL'*I;!3DEAVU#?2GtUZchD3uMFNfA\&?MjAD&G&6Fqa
Z(0_*PEp."#]A1=50NP&d"RM*$8hUq[g6h@?W1Ug4a>-]A)IB(8e23e%@n7g4<uLH]AYIU([9pU
hFL*9e1q`_R3,8EdH_4%e4ol$Ckq-!rK=K>qd9R(HW5=6C'o2?bQEI<5ks/HaK=>gkaj\-f]A
?!3BK,;aXHm[WY@sXgc%CpBY8$,%d-9rK/p)gl]A^!rrAM3QLCp*F]A&a7HOs_Z[Js[EWW7E#e
;kUaQ.r7JL2lBIUbIhP)+itb*9]AnB(p!nheGeSVlCt'(L*b/<u`"rjq0oX0IaJJ:,7:0BR<8
'C)oKL`s.#;b02O"ks-;4+aDBpE,plkIAS&Yg1O3B2sE"p.[.C\S!40CbTpmLV:.c]Ac%/bD'
/puA_rVCtoSq$[^Rnr?\0i3Y)H4ZY;HpNt+GlEuB@EDmQX"[2r5Ko<4hfS@t:E3Ep&'7gJB=
se7LVN0_U@T8>(Nl;f;:XS;1/U%&gd'I@;IMC2JD7qJG_?:$/8`p.0r"LYr$lBOTD8h/VNLg
N'&OQ?0("mSOs/C'VA>>NF$4gU'q?ps5kP@ku.HJ=e?5*4)nnag3=#,Jk"8a0=o:0%Xm$fF4
9s%U^qZ*^iGRX:[nZsP=lJpG_nIM9n>3a\4ahK^6Hfg/sUF?$k@hnp;qXL72Uedj`HF,oZMo
5%-A3KVXgp$$7.cgJN^JmEUoCqf9kCUn=/^ID4YI%h2TbA7YWfuiS&C5's62e<S*$_D?&E67
@77$>8`II%<-QpPHBEf)2RY7T&mO#ZPb)WQh]AgW5'So"Z7kZ_djIjHG1o25j`Ln3ncX9hG%#
?ukhOj%o29u87/+t!lKXY9k$mGL:,#;kg^/Bc).@N^;lS`;==+Rg2j@hB)E@Y*g?i8/GLC-(
JKK]Ae&DH/V&)%t=T50prag$XMo)=>hb,%Ds6Q)c1GSeP@GK/d4;Q#]A?u)cVMSq[WSIog.9h!
j6u\eFg!d.F"s(?$@<:.kWC1Fe=qjKmhr)@Y<`d5CO=(dQ)66C]A/%@0n,Z9[>Bk/?6aos[#*
&.U\tI!!85-O772!0M*.8P;"aaEhPk&9OQ?3e3T_C5abtEItX8!hZVtcE]AN28La3.ekO`Qg,
s!fH]A\9IJ3:eUIRn31AX7F#"MO+5IFkZF`l8&-^NJSMkBL)i$eEpVUT,9_^jFQqXA#20V'aF
jk($5lBWIf/@%)Z*ah_V>A.mC(Bq=Bsn(O:[mpFWk&UY>XZ[rH%[U5Un._9Oo$""?*<r"cP\
,$7qC8__>JBY$XqkKD.e,1J`l2Y0meE*,dH$=]A)*:]A.?E>)SMoA"[-b9%ab6#+8\*.p/[uQ.
l'*Zt_QK=Eh4KaIiD#YaXn6=WL/"fV4uGsU3$*/_.E@>Pq::N-HQI,]A2ksjIIh[&@f-7:&/l
WSE!0L:hV$r1QH4MCPl#/'5Ab7GU=\p4R&cfP-EoQ]AVgM:e&;#B[8$>L'V-R86Tl/6fP4Rt:
e"T[L10I.4J!5mc$mduqg`4N:1,:VOG4KsVX&_)G.(A`j\YX%79SO:'r$to<u.V?,/"[)an?
`-*W$V8V=CTkVS=Of(dE[fW84R0Q+qsXogfI0OV%PV/[?C7pe`FVM*PGd"H]AN6DT,!i,^iLi
Ms58k`Q[M0MO.t$UMrK_crqd!f,abHV+YPea3(_X`iQ'@Z/5QXR(o\K>ulN-[^MHnk`+W/qX
NmAaM3n6MK;0;*PY.4\/"I;Kb'V^ejEKM7oZU%0UU\A5;FPCCZ\(@tX7hsofD0t!C<P'56F3
L;lmLk;_qD<I&/5OVecYG+B34ZW_\!pK*+.;,@rC;@ibWOXleD#:MV)I-CgGc8Qoj+c'TbQA
F2TD1!-EBf2:E#kC;%KnIR2@?@rD=sd-EQ7*khNBO9e>=W!,e8AW&*H@WRZ8?8JhOI^)'o,*
b[M3GZ!G@aDmX#))l0qb+DTu*PHY9aru-6J:cqVYMTlPpfrL`>]A';!]Ak0%O(*Al8E0Y?mmUE
:Z%WT(#s)au99>[FXH)U2RkkE[ih(.(3<QnhMdG\b-''+-==J=Dqq=`dt/`iJ[#,@A7mAXEB
\M)sr5^Db]AAL`0S7I.96]A#X)05t-8\[&NasWpF!?WcnGa@Zb:dg4/=+,9jt<EBl:C-+sb1Hk
)ZjEnu45ER/Q0cuKR6DR$A>Ch#?UE@uJ?mH&=K8I\0;-lK@o,u/`o+%_&'B0:1;_kM7L>u=!
BP:(?;[gh(kDK0#@?1!"e-*FKn),a'qPB/3;"]AJN4VN7<U<)=fM*]Ah3")(e"N1i'jDLG"%VR
QBVN+24&$s'.=@hm"QK/<`"UZL:9WoC=V!$_oqSLnErD@%dgE=-ql1644NYLtP!-^9pL[Lu)
bLQV+Y`Yg1a2ZV'Y]A%t<tp+#Sm+VabL+Bd5\pBj;`^D64+mj@5Wbeo9:\)eNtR![>)rQ;o`l
o2L!EgHhY!I0\<E_C(Ngcl\k3j&6$QMkurODp]A(IT6bHZVc7[#oZ!e-GroTGY8<$d.itV@QU
,_aL,+b!$9HjeS6l+5FdaFt1,V]A"/Qq_nn7gmVqYU="8U>VJ\m2`hem8Dh0`I&YQuGUKO`Zo
1@l*T9l'j30A>.QDZT$&+QaScSFqeRJE5i_4pSu@6R-lRXW4:\7,C8;bZJQFihHmA(Bqb`6#
@HWU.GQ<@;g05_"i=#$"i<Q"hi4lRY!S<ks.%l%M5Z+C=^V>=#=TiG=V[L&YtMpSP@6oXL6!
Mob9DBD"2B5[G\0b48=4O?nQYr^UaW@jDcQb"<C3[SF4aaX3*e+CBZ]Aah2B1n,0/:UtOF$4O
,?F_3rR!acGLm(!Wf,u")&d044o]A>(7abIJf9sGj9q/D[lO*Z2U)Rr(C"J47KS,TER-1:O/K
dj1l:'Q#Zm[>uD30]A(?^16n`e.q]AePReEk/`?9nD2j!"NH@2?H1JGrUPs7&H([%qg)!3e46X
T)=sI[c:B$iCsoi[C_?<fY4Z7_'^JqXoZFi3F^/DF>$>Chbj)q#^A#UaJ0HsM#m21]AA;.b3!
U<o0nV,mBA,iZ0Q&i#d(emEhB%6Su!6jO(]A7-Z,bfGnP9GTfn_]AiAEA[HXRaVdI<P5f.dSN5
5Fqt*\]Al5)?Dl;-;"?Q/#'M<hVG[]AaRsB`%/tJ2!Y3n.kMr^%5SPI8$%_`QB#B,"AlN2<s4@
VArW-+-BHeY`N%Rf\lp:Sl["T'SVrk`&V*3lsb0lM^ZL,&pk(19mssmB7oI"AP]Ae<2Etd/i!
&;MbGhs0E)`@5*6`S&Nkiu;R*4R(aG5IoLIN9p[nC%U#9kaOjOs#_\kc"bqp5#3MH%e$cP6?
o0)Y*=(KSZk7F;Yms"lCE.q'ou`QM#N$,Db4Ht7s@L-`P8/>2L'>1k[AO9\gmI1c!_%CQ\U!
Ydo@"BsOWedk(&/FtUPpFViEA@$ZrANakU<5[*G*M>OLOa>aWs02%E@8Ut!q_0094U=Rd81Q
POK[Lth6O5)G6\BJ>8.CR>cle=DF=RcnFE\3<dbXE1F.RF_Ic'n2k(5h[ZhIZ#?MD%_hD9M<
Op;CGQul@/P?)Eri4Ej.>nAGr/%)"pb*cM2"JfJ_$'/]A:F6?En;QnJk7jPl7W5[GB<TBl'Ba
LKV;qY+0U3u5Q(Ek)hN[(u!`Gb\iCB/iGD%T>r67g#eq[5HKRGnGp>gJaDC0Y5BW?2]A+2=TB
FE%C)5ALY;QopTiU+RnMq:41\UBo"EeABB(9E;qp*YjR,A<l33O(S*<P;pDX-L<j`rB6,;N/
AAbu`l3>HgM3(((2;E6qPhs5&(:dh69@A8$ttejk'kZPg<,./]AuST:<+qsI0B^Dd'KE/!s!Q
p.V72[9<Z,m[aPhI)r<BEM4./tU7nHgi!/V,XH5G[.$*ZFMV]A,lnV8K@t!+7-j8%`d]A3\T)+
CuW"qE@G_O%^qTNqDQ=8GVCPJX:XMFi0<Z@S]AF:Fn&kE@Iq!j,FuZ<WkXeRVF*Ysh]Am")Q-+
-?>`ZU.+Nb-jsZ0'L4aX1>d:T+SQrgcT0Q8YoX&,:T+0rBE@VkqE*JjZ?A@<';b'm1\C[ZdB
VWs<W/@Zn$(>dJ9%:M,EYQGOK(e)eIiCjjSd'50>A6;>q.@KZ<Bs,#]AlPZ3:`lU[iOMC=PtM
ZpC*8l\k+Bnu5G*KQah[fA@WnEV>Ph2C;O<IX]AeHLuB4k-dG`<45+5biqX?lRehdj2K%o!d"
Bi'rj`UIN!VkWC"_!Zm?!:nYIaJTFj=&*KDQH7W;h0=eSd\L)SpoH8YT8N936tm`2IG%aD)]A
YHppl%YQDS@8+?+afd=u\t"EB6OY%nX'IDdYOOd(_dI:ToURE.-j*2iV3b6tNQb\PrcJ3H%"
(<e/IUa-b6'p<r'2*p7L48XY3o2]AS"k=ZbV]A8"Ve:&V&)umN5]AXq+Zn]AP;QaG.\A`'!VP]AM;
lMCs(2gbo8NBq`<4M!(Hq=g4?#i21QtV4C4[m1NQq=9a[-5iULSaLU<uphL=8R@YdS5?L47L
[U:7Q\WoTS6m<L97/L+m:&Xp`(rUr98:J]ABiatZbkAko'E!n<Y#d+fe3S\H5A-IsoGU'tr`]A
)1-ub:&cP;>=Cok_IjP)<1-C9K+-p>;6hbkPd5"H9u(rf%t1!:3fH4W=g9oGL,l_n_s]A3qa"
S("?J/MgNok;6`i-`d21+7C>!iERKGZ2BiJe9e-]A)A41l#p,5SM[ThZ:0bW,Tu&1<481dZq7
@I;^^fRQ:OA@gp)btTU-_k'6Q`V>U$62![KT14mUGc>=&Xp)6DDAmgXd`gbf[a/J:XdKTm3q
f/sZ`Z,uK38ajNlaVUHR-[F*7,_i`?)O)cA"L$9o:j=H=!fEo@rL^`PRDD;inCp@B;!fChMI
X(!,irel%[K''9QL.aPngon=A'n@>;K<bjUh56sh??kl6/UtMOnCgPlc.*W%E%lENK;>V^^Z
mp!KRO01:qseB?!h\B[u[@">l(@809F3oqS0]A#.0^.o"X`0dl6+l+^t8\H6<8]A=EXIkCMg4a
#7]AXbK>/U`So;1s/9,lgE-n5h5`kX*:XV66r:^`XM.lKu<#neBZ\J!gR>Kp^g3B:kX*1pD59
d8BK;5(4$@SH4Q$rD;h(,eE+QAUU(uo$KR7cG@_Y7iIoI0\:,RYAR'fJaqP)l@UAk(h"h(]Af
O;W,Th_]A<jIWR$-=dT32"X0sr6.`HV7K`BND!n3QbEne#u/Ed2YG5MuNKO5:V)YVH,,`*5"S
"nae9d.P5cQg:^]AtW"6o8,Lbn^tG(gTlh4r-=gPXoQmVCk]A_sV'@M-K]AdWj;0,aGMNrmI-Z+
!8?uA;%\[$:CpM%W]AB1Dh3UpXA+j/3t/B72>K/@p9_@0%i6WG3M9K[Z#6Zpe9JPX++^J5eK5
T!(.0:J,$U)MQ(QZJ*MkBqe2'B1>t\'J9Bl%@ld^-s"c'>$c%:d">EchrX`&:/=d@Xhan%EN
8@*mcSgO-ABGc=MHok0/Q`3BAQ]Al9t8.5Z@%[;$DY\ojjP^20&]AaPE7_?7J(ciK\6C]A1rW.f
!bma5c&(`77aIa#-)(<KEU8=0.N5Q+c(\ALF:9+)#<(J6\#b2?5"T-^ZP/;$sl:jGE+%YsV&
`&ac$(q6,TYi/=_a"j;JhNf?qshL8q8l*lE<U6G?FL<J=)DON\Fmh(mI1[&?i9s;#.XK%&b@
a'gnfEZ2%BMG$]AX:IQrXneR0kDh;qQ[%R^Hd+O&q8P2Xrns<&4mT=<*iN#!QpoBa(ndGn-I;
/c7H"@OL(hJ'qaJ]An=?2n9<&s#*!5:>lrbe#/DTMQj]A=2e>0Cu2dq&#+dl[S@An?G3-so&?;
NQ#*@Pp:]ADEjN2+gT>Bu*?0pQYAH=E.(K*0$&7?J4Rk90DTHr)((*bf?Y<`92E!AlP*4rfGk
J(@mkV%+V"!!^]AYuQ[3]A#AbAI<h>8PMk).>lB3ij1<!j`Tk/N,):c;e0"RRO(S-X:+G@`#`A
.pVpOe%Fom\GHaal='V"WQ=T/9'Z-\K<JkJ')XnINV-%MZ_B<7*MVkB`sQnIa(9KFIUfF8.;
oGGu"rW7>#Ee)qJ/G5NMAl$_b)k2&Q7+&;5o[85:<!ME/kSTDh4A_rkJW`O>V9K5D[@r(VP#
UWuEt_9mjY'n?r-k,.D(GWEdo(Y_dV\T(mP0Q8@6'\oW:#FkF9h>d17;VqD-7C1af'=mBo.?
jb/?FXOKqm@"k?[B0sG<38V78sX1@C>]Ad7S"Z:blH8qbeQ'+lo8%FAZ,;/"SS9MG.8QE*9:7
XFsqfqfYGhRcd$JO/6EBpCl$$[K17.pCqm=gb#Nr(M.ib1nhaKr&)&f%<7&k`,Rm]AalCn[/C
??1?]Am2D$p6%14XB4Kdi.&Y$:J*364@^JLn-F$hST!Cc4G.OC]AZP_P0d@E%<H`S8Japu,#5Z
Q8-/j[i2b;<?\JLm4++gVh=ka&B"a-YG`nua::N@V*5%JAs,qOF*$E5AE?0;`jAi=q^AB&K`
N2Q\Uo&:86*)JYO%"X:@Gk/cT<9=4;4!K2M-I36n$IIn3N(4^q8&:K+6TV'uU7Kl<h_@h4p+
Dt*kNcSkaLY[`AB\A(%jaP-d.:fUD:c'[FPqZj(.Iibg!=`3@2edrG$?SL6=D6Yfm)^(B2$u
jgE]ABN'3'o<r-\+ERIbUNa1M$="oom#KDFN+ZSk=mDEi?dqEFXFb>ergb!\6>.0mYM0?6pAg
e%H+Sl&dI%?_gd4SMAdE\J5ms#;$V'tTI,qWbO(4DbJdpS=G\lA>Y\$A-Bm"'H8X*]Aa3RPs^
:RGW^+a@C5*FNMp[4Hekg8fi^H4*n<S4YGcAQnm`!n#U@sqa`Pp'aW;?i!-pR#8?\8-^R9dD
_h"ArpS.Co=P"BsJu"F<jr>`)O3o)6GY$I^HE@ct+0qN#;.to5%G=o'oY]A6UQ8g,M?\1'2O<
>YXZ]A%[+gBT8JlY$<BqcomFadL0c[[F;!BqI!.lfI8p4'/mBL!l'!.i#r5FH<Aq-k8W"&;0)
)4l13n6.'>839&g&!ad2m/D<;!f(.kpQ`33AB!\6<Xh)rqrWP:*m8sXq>u9hu3V$8)WGgTOs
'0\Gm5UaHqPA,>jB^S#94[fOB&2UiO5g@Hi)TZi=`_TUQM;g(_brLg"ST7!>oS)q3V)u_mo1
eeEH0lSKqiJ;.Us6+K>K64dkn]Au\2&#sO7oh!ld,ht1T7P#BRdO2nBlO9\q9_Gn,)QEP,sib
JaJCPBdG3#o$L:1eF%9%At=%NWZ7G.J`b't4FofF9HT';j*WPSU(D>*JddKPDH\UP'Br9,bX
Dd1+[J:g]A.M^FHA!`k@KZOjJqQ*)WgVNN8$-<S5%@r[@V:VX#W=$%ffn[bT%m;GBABi1&1pU
b#aUp`QBC!\+;!kW1GKiaWD,-Tp*ZJp#p<3+DAs6hnj6c7g9emUlJ0VRoIKrIr]Ac(..2i;uD
*jiC1JA3a6;B`Y9[oFeFl0.F@1nULZ`Ie!+h4NZ-`Yeh$GW!G6$7@4\4Xoo9T!#fE0*`HB8R
k#EU$BT(L9"L1;N.V"YT3g<'IbcpGS0lY="UfCrtr]A;pA)c;uM"u%ggEr>u@d9Y4N[qLWr-P
018&eO)o8J;@@/$A+]Aqb$e)D:4eJE30decH($p()*\]ADLlO*'Q:Bo$Fdp%]A<[@ngS@At=$Y,
BuP5<\ltFL4ksU:F3O;mk4'H]AR%JVGkNeV!<#j!I4YrT5\]AD/(^G*Ln/l)##M4,-af23RJO7
W[jG66a's@i9VpW*g7/;=\HPdb^sJ;)XI*77`q>l5VMf]Ar00\cjKTurW;16U#q0<f:TVI,G>
f?lD]A,U<b+%8lu[9Lt>2U7La\ndW0*(aroK=dk>0u9/D,s#4RgTN0Q#@)0tnIPg7FtX]AknZ&
0;-e)Dr-F!1fC<H?[*mNkO%H"XN2;n(ojn,m&c]Abl$'9lX%/\%4t))0JQ,9G,H]Au8+Ubh9^I
bWH^iKhFkl(.+:c[%AU4Uflju8AaFl8.Qj@/-bNN@"^%%86j-7[j+6s0njjR!\[oW"`-?%_C
ZmG(:V/<pr'd=,ar@.qIoePCed^&?5<8YX"$O[G^(D5fnG3RjH4_6p<Fl3B`%8t_F*QJGuLT
d4B'fe:8[[G);A6CN&tB(^*i6C;r?nkptoXXf,S;,D#cU@p]A#;/3n00C\Q["1T1T#A_b[*g(
5YTXGWo"cB=%)aCBJ,8KaqD7og8h$5YHRfI%hPfq:A&cZL&E.27XKGhRBpm5*Qn>h(Kh."Ve
d=5Ii(mbmI\4NLRWt#Br^lbM.PY-X>hJ')8mL4J(rH9X%5<Liaef=JmjpQ]A[9c^N]A+kU@$^D
R\He5R/CWKHIkmY!JD_SoTg^(G0sV60[n=M82\V7D&`9ocu.gnKkgiJ$VP>L[lCN$Q=t?XC^
nn'N.d#H:ad$3!t[p9m:)W_C/P((06*TS.ug-X3R^5I(n[ZlI@l7gL@H5!^NHKcZ4MMV<JA#
\MLn>AC1/-An3Puda\#qXpG3MH4,(p6(rSYffc`r2*Ja>;q%$67R7X<%CIM&dEOF#a;8kBUM
`tm!o!J8U^":1hO_ne;je9-#Eb>XTGMf;/h.(QKFsWIeBST#E;FBdBT_bsnJ5=9jnrDq*^UK
\VQ"9@\",XPo_1.o=?ESAbrf0aNh$>AW7u<*MHG8G>NDHML-f/gerZ0dLHo?\ngC.?e^8r]A,
QRU#Xg2rh9Fm<!mQ]AV$-LO6q#)eCN3H>VcfUmS6-rg0sKhp74oQ*$/a(1]APr7HpsS<r<HV\O
8DKo[(2lgR\3.k)'R7h'?,sAGQQtXl'g5A25*!6O]A&U)0Q%Q5H,fK:/^E.VicL3&d0PoC(\7
pZ)+;LU%eJsg/1al<4V%4\D%4cZ?`&,jTFF9]A;tuf`#e12`GZbA#\nC_!PXih=0OH3VitP?W
o*-#5JYl<JeQ"o[c4ZF71D)2MouVj'Tc;"!!j00^E/jbLt^]A59"Ec^\M>U=8@P,O<Wu=/mZ-
..apWMVhqt9W)d.!G/BYAlIk\UXqcKgQRW,3GXA^a+q_YS9putZ&Ve>(h"!\l<8u$I/cQrP(
XmQg+cXIJ@FVbts]A#`++-%T%ul8n7Xe_a!nXbhQ#n&YEEr:jLQ5WG<<AT>K>$s9V2mNd-Mj7
KEo:1#/DdqA[Q)"gX+,8*PR=)hb069/[j=@-]AIZ(o./5tW08M=1.1@Sq7Hg5oS4r2\sYab>f
:,]A<&i39<bqUCW&j2g'jK!m=W:$58HFWV_iR2p,Iu.,&t-dDJt<TnRo_3HUQO]Au]A&e.t*t'Y
JUubhnJbP!^?!o73R.]AeOS2[q*WuaAM%$13SjCZKH/iA#<;W1[u6l#5.%BaCuY-Gj2\%T5j"
@F9S>FjG>!s81^Komj;A8OQ3FWnV&"1$$PdO)$Mkl`:B(@;`*@jc<)iMKQ.c-=Fs>boBUjJ"
OJgekg]AW_ZouW/iNJeH16^Qdr4RYs(Zr8'10CHs$#)S2La"k\`G\NnU>ZtWshK"k/O`/A+0>
u+iA@>"F`f#J=SP\C3m<GYkOI>2\<K&4H4XW-u54.L"I2g*C^;2PD"u^k-i`3Qg8t>3G'@nQ
L^0qIK4RG-S1nn@tHdn3ijZSOC1]A@a@A8C7*0`F\bL)Q0eoZ_O-SHTa^!LN6KeR^K*hcJ;bo
-(HMla_^EL0U`&h>&6FR/%[W3c^)sG9nQK<8BuO!kJqcUH+ZFfOl_p\AQkK0@q%7@TFAKl7.
1V`WJ=l('_IHQ1A@Rbp_ppj-HJM]A#Yp8EOuTIS-[o8iZ4?4,2cCjNV&lW"lDV$e!s!rhX_O#
iY4tsGVk4C(Fc*,c7l5D[Nn#+&JSE4AJQ*G>o9Nh_f$$[30<'V+)3+]A^>RJZ(Qh8=UU``u7I
NJ!IQBI`KH-%C48iqVVJt!C-rm9F8ENj80TJF)#.lR0DdO&iCH_b%U4)&5UE_+d_1$aNMJJI
#heYrk7P:oRd7Sj?8)?/FDKjTj91&NIqi(<?phW@e,"*ZDJA.8)0Ke?ai3f$(22p03mJM6pe
>HrNj$B*AY/j"!V@@]AJG_1G,"HJNi$mZ>b07G%PLbP=IZf5=M[3YFfDD@gidm7c?X-,5!5pB
2\OIS"d,N/uIkL7?B='nJ9Cg2qq;X+c=$"f#dr^n.bnN4;XVcf\</</8q!O(M$.27\[In[%N
\V(%a2!>s8>daB]AoC4$JS:7bIn6MVn5;ch3?ZO"CYK)ZV;$Y_X,\@6U(&<+Fp5:FSSO:et^b
)ZqZ0N#DN,e=JO-84=M(cY3oC>6+a:mr"R99W3!AH&h;CjFEaH_'p,go3rE^X(-C]A6qI[cqW
'XZBOP+-)d*j%XspU33(V'Kc?^6MAaK-Q:0"fDF(cJeqLX+Y!jYA)'GR[hLo\PL",u@s3TSc
4&S'o%gm]Ag]AV7P,%YpjM0Kd5n[2B#a(L68.e.=uh@&N(M=VUl[tH3qM+f<OoduE4aq]AUU"$'
/HL67Xbnb\]A9!M_&&&"W#71$bW0*i)k]APaH(rrK+o*#Y)c7L.mqV5?YY8nC[M`A!^/jpHE8Z
k`iBTff7HRJ0^n/4E>!#m1L_:R!G_gM>A4_hgO+sbJcDAlXb^Pg-Nkd@hu.[R^V\d#\be?hI
>QriFPi-L1Z-r2p.nt@1@#*r,`6`pqJsi"cRG1@2-V0FqE')d6oUc;lJLq(NdO_n%RFN$`Qk
5r\<(+%m"$R!Q$sVk#o,`d>f#(MT8=P=Z[`Ji:FM-O3SqVl9:,QJVLm2<dG5B(c3OrV$t'GP
Q4o26hZ\WRS%f3UBHs=Sld(RSnYt0?U0)DGt.T+"0k^%^rSULq,L/3GN-&<O!+iPnGFH(LI>
I+mA/#fTcpQ,\>[fV-'1N398sdUj3J1d?dhE_TOG<7WuZ$@h0KU-%^`sC\t!QD,FDn?Eo1'1
EA3d;^%I]A586`'UW91&VpgY#mck#jHAZ@4?X9+Y,Ms&Q)<%;CmO2E&+3QdU)?!4,"8_XJ!^k
GeRUn:aE1+q`1V2j^Z\W&$7P2WN"JL'TE#RV&_rWQ35(-Ag4cL@#"q8)Ao)F41$;khbB']ApJ
c\&gIuO1d:!^FZCuJ!Upab>-7Qq:S,UN5"[7;&K6h1kSii03N'u`Bb\2lfgX\.d+\JOVJikd
4Ta=0h1Bj_aEWa4lB)hM[q11.4qq(P(XW!G1^m"^G1,4:C_`A(LiE'Db.Ang,NHFj7pFc\jh
U:1ZC`%S<UqdC\A_>DFHp(FRm'[V>NkoF]A^bp^:?kMq!@bFhd%3Z3)\@N'.eDBoIN/ENB(o7
WajR11Th2;)CGAt*LfPr'do5OS0p&n^KjmiXPoKY#?V_e7Fb3*i.-S-$hqs"4b]A<_HXs>*r/
hJN##lQ8_>EPs)&O/t*mQ[=NFo>qUu?EU'?]A:k4,-#*n9gOY\&aNM9@h#"df).A5L!tQ9Y+&
b4p]AQe=jO_l>7[N._2R3BPE]A=FhDZ5>fb_1[qJfMY]A5Q&sGC/1k7X]A?8*p)mnp@a3en_=1Ml
>7>[o(/08DqYkp0bj+?>agn$ku4l>+2S<h>u=KJB_.:dM))J1b2YJ>@&J&hSt8qGTc^=_!rZ
W!m.)sh8>gAWifH-Sd%4=$QqJF+Q1WN\.YoYF"!nFoJi$)hbD-e&#U%;\LHhPc^[8SLE(Z3.
>=$ko;e7EbOUNGk0ALH:^Z0Kl#<bLG.$4AJm$\T!QLLf]AS/oB@\ad9l$9*.?NHK%S?3S8kH;
r"MFC#QEP45SUKtL?ElqrVED'L++-\?.'V3RI7[;M)2Ar@s63EQ%=WcpiQ=5<oaKIe;/.]A;e
QHa!$F`GWb:Aa^IPJdSZ8d6H4H&=o/Zi6&KSXf`lY2YJM`ZN3!fYCp0o4"KtnOJV('N+D%9L
<e7fb7C._Z$o&>\N1DKI5(3'Pmj4ujI5C9]ATXd.^8o0\&uhoF`See.QTehXT[J'NigV7ZFNV
VHNf#o0CIq^$7l<-B5_(8s1E#Im6'iuf)oTOm)^5*s-Eg;B=4(\^;-8X:JQE87?GIfrDK7Vs
&<?8B@e#TL@EP_k%F$E^:$!X(0844GY$@II_@etHcI`?ohNOd`ms21r.X#c^=mb`'5D;K!_V
SjS:EZEDC,t;ul^0Zb^kt-7Z-f]AWX*55SJ069KW<Rf4-@PUbLX1Vh1g;n.IJe?Bg8XCl=+:2
7hokI*Kftt%Je)i=(#+eFG:&>HH<daV]AQ5HHRgBp4^GJE>C`GN)FkQ4m%>6]Anq$p->$`fD*F
U_:)+.),^V$9U@I.rj\]A2nrsgk:!_M.41\m3OWQi[gBGQUBmnVQJ*R\)MsaOodD3Xc=]A>m7B
FhQdsA`,W@k+0-`mY?dH_=$?q81*)OjK5!2iL\6'0u]A>.WI(\F5!>JOW,OcXkb<Cm21Fo(tk
@0UJ#L6"q:4fBM)UmSqf&:1hp[%<78a<-33`/:pKoE9lk0j^bd*'96%O4W&/s%8gi$m[:#4<
t%QSnV2de5?bHq7_?#H@;8&/oY4'CTr)A+*Fi)'1)PaTSu+N;.<2u2$PbkP$dpjGkg/CB!5N
.lQp7,;a,6/M)%Y7<2e*9)k@^"#WKFP?rXG\qqA5]Aehrt"=HDDc?e$,XM&u%,HqQZn&JKJ9d
u%stYHu2Xe<`r--Gum>cTA<cg(P@4),/aA-2RsW9d'oC#b[rX]A!DRPZTB6CDd/<!Jbg4AC\_
Z8,1Hp!)@Jt*r`.N-DCN"]AD7a#OYIU+ra@TG0H?P&/[Dc>7^^\o5&a8m_/+0RUSoW>iJLtoF
FVh_Yg)PJ#47>VJmhsJ=L[]AN:jA[!d^PVuFKRo$$FgiC1j*hZ),4MRZSH1i0ObB\rS(71#Ch
:QI]A'*6?\6i.pApQ#@Hf4&(#raILKKOY=Tgn@VpljUUeoM'L$K&]A@,Yj&:)*UrS2/WaMbAXl
lU_NhuXqp3pWW2oo$Kn)8+qg4DVhBhn)$d;Ok4I7M6V]A]A4W0DC"7!:Bk?@%G)<qRp9;rMN[T
[+mM[C;nFonYm,CT\Qqf^\-Y$"LFjm&>F);$A3MSRtW4J-.^>+sH)uX!6Y@]Au,sO8g&k+J7O
Q'A<PWs5oW@DFtiqu(l-soVdN_ulIJd4$d^P:;$Kt@P'fW#F:-p$Y%h]A7"-:I$/SL:62i8I1
/#8m7>UlT_8ERZLeZ#NTkgf9R,Afq&ggH.a=6)\H+^WqS2iunM(Ac]A3i56&B]A'he7T"lKuY(
_ME@*RX[?Ej)lDJW7SQJR7h5bckV7%HIl$ScrD[K=^QC_7Q"!D1q>s'MRaJFfN!*\V?/81EG
!jPC';b$ZB.)T]AR%g$<;srIt[<UFLgS4sLRgrrh?lWrnd#D_6>.F]A#^'mDO_GQGUp[6pB#PQ
Cohb1nG,)5Yuae><bg7hoW&Kg>)SH+#-Lb<LXo0\mdbV(\;"&I(TPV/=\.m%-_PR]A^o[dVk5
c+Ci,N7Z(@eCF:>!12gd>*m&2ZfPaJREp0?<03Sj??[c\8,T/$.heP.=p/mRX0L^d2J$sN(+
$l7QABrgUH?eVt6FZtB;0fJ1%S>Oq;.5W=K)joN+XUUpr2#]A>GdCreFp8YNM/j!cC7ui82TK
:3j_@hI-15[8,g96g:hlq)O5=_>:FZo!4]AKAcF7"T.Z+7ci-i\%mg\31W'N'D)^i,oqtE8n9
!U@t#%eaAc*]A`F9>2D?<s?E`%[iB/=lc6sI3-)nMk?56Vs:;UlsG@DRWLdk@/3']Af<N7bu&=
lZX9eR9=+=lnc/f'geRXB135GKA<rcae/*pV;g6"HS+4`chpKU,=2+Kk?>O1sR*A2c$.%il\
%s\U:E<((QPaE?DgQd/Pg:6JI?2j;CM.PZ`Q0WVGT!kP$jBXtATKQGYk#_g/^-cY"a\9']A]A"
06OqW[]AO0ZXP`H#FSWQe6e8ZbqPm:(<&R=QpCftIc&SH_(iC;knII#STIaoo&#!+<Wq/'`(W
Y#X5IJ9*r2Zmpgr^GQ@J?O?@@!\]AE&YMF7)%tlUNpLlI<7d/[@[)P_5+rIUIX3K9h\0\>Gj%
"gR61_1[eZX)G"oSeD8m_(0a6F00]AbsAQ<t'nrYjUeBd(*2Jd(D6gJ?Kg;`/22p2khX5i5>T
8#KQ[;.-*Yj5m]A?0q\a;q$b-[&E/XKn/2d%0&U[8%Y)F#9-.L%4#Sd@u9U.H9&@!DC'-,Y1n
<tCP:Dg*"A$Zo1eUh"5@n'0k#F<-tG?PZZqY14/J;!J`tJ/r!!-@oT,oVp&LA%jn737$WUas
6B]AbDi?CH=!l]AJbn5EU)Oo9t_im[k;j4OoTbKoqheHNq.P,4@G46"XQ'=Rp_n@(6*i,N0kV)
*%,7`X7R#U&@JM^mFIP@Nr,8HLQuk"1>R"fjfY>@h(Q>gf*:iNnYsG.<phIDkQ:Bi>(\R*fd
j_d>i.HgeXNAgggXB"0.78PSA)]Ak*Ve@uY4IJ5=*YhYS(8,0*-j6/I$VHQqma?N$)MZO4mhU
?5?d#;5C^MB':X&0$kt!Z;FcFJMZ:LaQD.`:1PU#jWK<5tu"l+=d&2cN9k1+s\d[V\9[H,=2
K']A:*6#.2PI@)JO.k)K`t%o"U4Tao1J-au_$6(1.63Gji'e+i8mbeiXN,I\?8A`5'Ag'T*+D
@2[`&A[)t]AIuG_Lc*KWgX*-,WAGF9%VaTHj\=:/iZ1@l]AGL:jJR-p9N%s9uMA:1jWk,iO5/u
?E$SZNo2/7>dd[SE..J"uF4`:/>"M@_L8GZ^qB0ql$jCT-u_Di[<&$p,Vd[a:($bpP?$5CsR
4iR*KbpP]AI\j/F0XV<tQ1`46cDJ%G+TZ9i*4qo]AVjI,F)D9Sa")6?_89SM.O&Ub>VIZL+4^F
Q2a-WpKLnlMLgF'HY_]AB:tBF5rn-N3IAdNY$Z3qG^!.Bkh`7UVn50n(4dg9mm$f*.Be`.Z[F
@%Gu,sb*JdkKRJ'E)s-bTqli.SpV%h:*Wo1TRN+(%>=FA/S:1`U81e#cY0RnM)<]A"1Q!tQfW
aQ=o3GjuO_3.]A5;ZkBljoJHEi5gX3B^BT,f7d@KS:XFe7^:q;Zp;0!&[Ma;HgnDUj=D1/Bk^
Ro7Jn/DffR*NDfm&(K;hWp7rPX;()CP#W)VP.sc;Y^(;^S3uP;6bF<a[;)eL-!gG6raQM57C
2"@/<W^7[(T-NlZ4+Z]A,,&L_0+s$**UA6$Vb!tL#4!o=2Naecd$R/\;,1MEiM'nFR3@\*6`:
qqh[lMH<DWAZCQ!M`WO6'n18]AS<_"r2%1&%:B4H+['X45Xk&Z-%u\LN'B12P\?74I^Ycmf"U
qNL.]APUAc=+e>Q>KJ/'-&`Aj=<Gh'k[G&Vg1$T7*H1E7W2LhfZl.WOk8a8M_if'R2A3p,8uN
DUj5I9/tg6jY>Q4I+"^`<*6,lekJD6@UaQ:?/7Q\$KI(n4K@YI+TR63I32=>Cj)1tDPGWQL1
@XFGb)J:HcKWu[u9<Ac:kscel9cs9h"[0D=&R=)5tpRnsC*c,11#S_Nj=A>W".nGH-j+h5_?
1!"NjU^jQ["Z6NU"Y"`aVXt0bR)KSYk,9[DXB82<%^]AB.V9t4reKb:SeY0;=WHi&2!o1>E6d
#E?Bf^nk#O!f<R`@!FAn(,:p5M`A$^I0^a/bE>kd=$Qm@X7m"%=ch0'6qI27,-s$ofKMIT#^
j(,W?R;qqML8WO8ApR;`#JalA4O;jY(gpOc,Yjb<-i@<dYn.rDhl9HmP<@7WX,PY8t>je[.R
D^r"Q,P/BFJRUUObL`#eElM6>'qI7,3[UbOcUlo"dK7nufXqhdQ?r%"@&`%6[0*R$X\-_QaC
m3SSZ_ZXl:q#`>bRmi0;&rK`h\YfkHP9sTX*kR[aJ_qs%TN:c.?"p/d5$`SBaA*r=JqN?_:(
:i%f:l7t?&eBODn<03m%@5g_qaBAh7B`7bsA`R"mmpK\-h3\cWJNtSjEm/7\0Hi(8T\HP1'D
\jLd,7^Wl[^N209hn=3h+ZD*QLL\hFseqSPTCgj,l@_ZR=32?F9B.AU-E\<.Mq!@,6:5Q!86
NWd366"1jM%,%I35;VAQBS@:8sXn(tG*l^JI:b>;*Cco^O[Dm;$/1ai'GOu@_M3/RL?'rH;"
1`XT1';9EV?\WP5ekMWaLMDW&G>ZR/dA;1B%+JFd0g?EXc>UA9!1,_:PP:4REsIb'ld/2uUX
>`%OWhHCRRifk4:-::@Jm\sMF;A>W@kU]AoP,549nu^Dfd&4=QAr=q[%0(@LaKXBFb4=M03^@
\OIZkg'fY5^/$&faCpmR&mBH,Mf@.m(>`%3,J*Z6R:3U,!q^fZ3>d2A9@SVTZlE)An9WAF+]A
p]AW/>BoHG.LuB[FecgS8Dpfu`]ADf.V0c`Tog]A-ubnnH;%?Bs,*%_eP*.%FKM=\9GM&P`lVX:
3I:D5eU+6tc.7i7;:81[2BC\9Mh/ZKQ:]AN$&CqOW]A@UpX4k4aVnCSd_r@q*`,2H5$k'UEH?U
E%@-KMk`mC5$ScOi;qI+J]ASK;rnjckK7*Qqa`LF_fg`*i-PgF0:I>sfk"":@$X6`o+2%`Ob#
^%@1qkJud8`rqZ<T8ZSJ%I]A@Vm`.K/3.#AN'db<JHO[?'S%[ls"F.5M`Phq>OjHKut[9e^J%
nL"`?KBBchKj5I-ek`QhtS&Zt%(1U\-1fH<GDd]Ak9!]A^\T4I?Ol:2U\Z.J*]A7Da9D7rD>8.Z
J!I251e<+WY^o_gMF5)!@S0rI10\NSd1r?1q,[Q%i/X9k(2\Gm=[V1Q10FT"SJ8`l78lN]AL:
^\iUmeX&9aLJTnEjYO-hI6IuuCB)j8itq\T[dj4Gp6S>^T2h>C;&cOQXWTjJsN&HrZ]AjX)$E
-JQI/q9+CP7n3%LgkX(h<<oWb.?*d`!t"YZ@X6@m#Vs5-r"p5e=u9"##IZ<G'tmqblV0E-H>
>,1^nkUbQf"e1LeR>eera$L^s`qt*@X&983*ub8+[C)K$>X54Z884XZ,,;O-_`LDPX>Y@MN&
>f%/F[6HhA@iNAFL^;uCH->BhneS_6VaL3W4F=74f+0)7Q&?:0'HR%6rq-M68FV#n`4jlk,i
b_EXlqUILFrs?d914m*?KuT@Z[(H&pXL?K52S)"M!B1rKq'lVcY:oa8sT/\Sbh63^uq"AkO/
IV"F:Q@=Sc:Yd@g(;NA'P)*QjqXD.Fb!]A.g:p8!qs['=<S0cZs\=\jo=P1i!oDrYfBafO\u9
V\BC7%24IA,YXBD?PJZ+6<pKu8=$c0\<4[pWjsND$*iL*^Te2kb!:MO^ORlAHKig9)8.&D>p
2IYRF;BVWHqraO_TfFkI^4Kch#D"cWdTPNn);t)@!(oeP<aOY-]AO'-1ReI!t!uG%q+?uj:'X
_.)<p-^!J8+o2dEVF/[P(#r9*j)^6eA@"mA4ffNfUa>CEM]A%7gKgRiq8<?R7mV>"@JB9ge5a
NWj;A^oo6##F63W8U.&MJj16hmZ2jbRJ$%X5"qT]As2LpV<RW)a]A@_O0"<G19?:ra?rJR6Ft5
LA/#roOs*+GbP)X5F%8d#RBFu./0Z0*d?m#L54L/+QZ/2^$BhXh*XC["bq'mm;!co/8)\!$[
Lu+&baC^m_6K/IK,Q1,WTVT2`Jf?U"\5KB-RMIq7ab`8f3MuUOcp5*M7Ekm4hYq4[`K;7#WU
CDX!S#Cn[<GFFj_^q%cN!eT%HjSr3d"TJ33PGNj6N@G>0QrT!@jT[:,R>(#G!W/?ZH&8%Ca[
#^N6(*%%*S(me]A6'V!G4'>*l1`HYmOBUo;NZ2t6tnjASaCb,F!FK*5#DcOg]A^1B*2]AP/5K_m
b71V%`&%:j:m@F[P*<pO=ou*8&\&oKmo.]A_-P1rlh#nWSs0((.HjSN'?"tfTURB'ao0i=Uio
S/Ii"N%1+mpg5A>Je*"N$oPKZQne*31#T@Z/A.cnM>!:iA+-ppO0]Ao7a,V<EZqbeQ;YlIU&&
pQR\rr)\q;o:C,_A:l62*l.T"=CITn0[/a=hDcC8Mgt7^"ZU>FBc\I%c'1062F9kA%um$X.(
)uNJauhK?Uhf1rjkbrW\c+7\+.-dgkbPrct:=>*$Vh2UQq]A?fa,^h>kG\\6(!1b)EN;d>bZ`
!AM+:u"c)i=RTVMaW.E-%ZEt8hT23L<DoP"3'>a+(6MJ^BeWfB,D05n&^>;"4-gj*!(!A=l%
D:@J[V+$bah*kmi,2V@>+#2J)`Rg#5MT,2.cP&eIo%pIp'gKLC3$W\KZ53noCO;b"mmC^Hsu
&ui7$4Gm0;/;q5j7VLQ+D]A8l"HC.h.nHcm,LA(*mhJ?BXfM=mmgK#VsRnO1Wg1hR(j;Mu_q<
_2>+6%dV8IA>Er;^doa'iEbA7Re$ZjPie_b-gRFargtVQWGq+Nk^n8?n]Apst>0o]AKmY!:3@l
\h=e;!A1)jDUWd)I19H%o,=h#q1@fm)Gi<fqo\Og)Zl;B:Ti5rb;Y'/MhlD*i7N[ia,O'T7l
Um%e@ng.Zmp&0$q,'uDGX1T]AH6XoQ1k`eZ",/E>R52llDmj@NO\;/,\YZ-O.SMXXhl5o%T$j
$gIc'P<O#/kks)BRgfVh$H(%%Y>"K6$A2TPd\4AH3hgVo3\,(\`kiM5ki^jg,M$E1/*:&\ct
X`IQ;pZ+*amT7V0O'k%cS[&C+qX4hR?IMI`+2c[2!U$bd&-"CDIJ\5YQ)*%jbZfK1';rDb_*
g#Gnt@'#O3TWk$!pPaaY@mD\3Zq#b.eZtVcXJ;*@#+^%7X1NYW\EC;_:oTj$fg#`+Gn0NsEm
bgZs3YE/S<#N0Y&#$RF\jbJTqCm6CueIQHE+=+kMr-X$FSXBS*LW@"D1'5;GG`cpV6(]AlE"X
&0/H=/'TYpU1*pHj/Z9#7cjl:SeoI^+-I1jkbu!t&p#P.-CgiD'n1NY7\GfCYPKi*ng;r#I\
<(AIn1J*M@m-/FcR0`P1JUZC;R1#uaGMkG2Nl%=.PI@-/8ZDKFgAk-Q+;YS8#<,je02)j=2c
XtXM;WFP(!1o7p$qm>.o*.HJ>_6gi(ku#^@e:S5F.j:\`*XjY1Sn9gU(^n=U-671f:BS;Fpa
OD4[2We]ASYq1+/:f0J^!jQH+.mpVk;6_5ONSo@%qF6C$B6FmsmI@`CgaW=*banB@XmTVHVI=
fanGu)):o,`h2X+[>h+k!]A\'UqP%M_ai^R.N/Y'nrG`1>L=\S'sOLo7YCdjFtp9jSOX<,LiP
`<26EGKDTJ.Bb*O:a9W<MJHQpd;4]AgrGId>m-RFrF(KW&u*='2<)RBK7<8lf_(MESAJQf\_M
B$p(""c:54c2T9poQSiB,bUPQhg11:D04Y&oiF_UlYdU\0G.h`g!a.'X<G?&,Un4fA8hinNR
OCM`f1.IARS%=o:qZUkQE./a@1VIb1pJaEMfi3N)C0_jaZPDHnBAH9BIn;Gmr[%dd@7P4C#;
V?p"HW3G1kc6&p_?YCf90O3HGoN^MFX-q:sS&6-mH.i`t]A0GGY($b:W?]A5LtXL).H\*"YG<q
Z/+kR+,R^HFR'dYi;f/!5WHI[ORp_SK+#,j_L%m&:0UYtCGiomKEl;m1=7fQ_gH>_/6)Vroh
uY#U*nF!D'snpX$eJ"YNe8l,3%!AaduUd-UUO77hfponf)\9Qcum.BWk^UVgN@_@%HSuZ6I+
f)843Ji$WQlmfPEfN3=+Ei,GC>GEG,rV1dI,OU-\C8F&irJ5ArVWDda&D"mhA9`b1X"YOW_\
osid&PII6"$.;S.3N]Ah)$4N3ng`h3g12(g&dFN$@&iak\.T4,Q7P2PVJ+o6Jii@u\7?RX5@<
r'PP*2JuT]A\Z=V)gG@]Ae6sRX+`t#sEj.=g]AHBA'M9qf#j_XOrSmk6co(K0bo;=u>gIFi!CLX
_*GnL[H]A>p8=a-!d9!S8NdT'Q*NMrFW!la6:FD6m]AM@#-O"a+3fYOl:Uj+mDkF8j%UoQ:!N(
GaHF/XR@]AXR@7h%E)YfI)LiU8r2[`6\kaLN"+q%"e$SgU6"Z$s^N!N'q:H!`+]AL29=+e1*T0
mV8%jJ(/r1,l#,lGa$=Tuk!++:[eH+1CRnFQUb*#Z.>%W\ZAud??-=.f0=eB+27U\KD8CZA<
J.4Puc,YpLKa9qMp,%HUngJ8tQtV?1Q(Ur.Y@GA11(ck/3nq+d*AL0k<;s)es20QjHhr?*2#
`YDoa[h"7'egf!0^a#GrbIO*3')X1ei!Mu!j=783kP:H$P>D+d#*d^^a2?q04q@TK#')W(O6
*4$#EBhE4JWX+f<j9i_]A2NKNPAX+P7k?q\`XW$C<O9Q_VU?7R6?u#@fDNk=q*[\@8FtUhUjd
DX.3Y&mP+5550KN]AOh9a]A]A<onQqbj21qpaN(U5"Tfd@-bgM!F5G`5+Eujb5G:`/"^W0/HtXJ
0dXuYd*bXSUOS=<5t.nA4.,_SQA3)6T+Y*n@JZRjkBIcD2qi44q.eorTLtA3OY?6eA_JInh`
3s+d8\o<Je/Nh_12+(FkR^X]AB-L6<^O@eQSU;[*RL?f4%Em@]AlG)$V<&5&p7ifl:dGT^n&]Aa
HG"IuhGp!;]AR+#bV2VV`)rdT4+=NjqjC]A2DH2ed:VU(lq.7/bPQN63J2eLtTZ'o>e-4[G"Yd
sTd3DE2V]AYol.-NjYUB1*?5!n-J^3<m+[E$PXV'N?XHZSi$[ZKl?i'sPl/,S/)2A[+nA`PUc
@6e?udO`;2e'R!B=2hm,W_':D6b&Sj%k`Us\=^uh2[!/>[:Mul?I]A[(47-$o[6fDl?G0S(P:
U]AsXO2S-W;bgjY^\BedRDQij<gTreN8OKdf']A9V\]AkF@,srA8Xu@SCC_s6pOCZ`EAjTRHrbb
Ss=smpXC47<Vi@QRppgqm=0"90,^pdY[l<W%"]Aea"tIl33(^Iqgnf@B2dM%3"mhIQ#=e!<lf
R#?%7>,0@mV9m,(S$jA&s)AlSlfUZbE)aJQ\.G(PA[%Z&fd>^1)&^+oVU-sA18/XE(2/f6+o
,V;K8n5LBQSUm0l'*ZNM(I:V8"?1,Y9eaR$Bh9HtV4OE)NXLm6"ohl(kY+rBd&Xc`MINiL)D
LXUiHfB#MU3ZX:TAXD6-f2Rtdt>XT6G_X-c/@sQgZL;)Z=S:lh]A6O%/mg6+_=DNbcKodIcs"
F]A$YOP8L7@aWcu+.e=_QVEpcV/6H@M%VI4*aY.[8_]AtO,+.5J6Zb0[OARc]AqZ.tce^1_Qg5$
pep**(J82S&g`>h[7dS>2@A*T1[(XeL3K+[R6jY$J.[_tS0)K15fo1;kuBrq$RZ5XV[CMrDT
`%*"'HHdl!j4Vu'`G(GDiBOuSBdpsR39??1'eRq$WoZ'VD"_M&HbIhUjm<E.]A4MU^_jhKX:4
2_H+cp*]A`ZSpEkmdSG[S^10qs+'+@C_iLrKRURDer1C4?+D6G$ORBLGt^2:S#(,Hsq_@lM:f
$%MZJQiY;`K.8o38P>RbAOtAHPdbj02qWcGTiX^0U,=AR/:+F8^@Z+S2QUJ>MNff:"/Q,HJ(
M%s=#K1GF449RQM7;1.\**OTqp[h*Dga5lq?lO'O?IpXG&7lMfAFD%L5tR$dYh;Y_jT%?Qei
oFX6[kEdn&8uq$"n)NsY*sh7?f]Ac<:Z,rHK:3,Tb\Kc'grqG4'qCXV/q85*Zf/Ba8b^@fn^q
#Bb(W"p1P=!SrPR,;(J;cOg1^8q1oDrq/JqV#?4((&r9X26j,,_29!MRp]AJ'Q<4r@h:BA^=O
Sek>)0<Ca[)2I`qo9-\U!geoBqa`dX5s6M]AVuEH7##gZTRl`dp$0Kke=21HJ%g/V\3eZgls_
:ok$O"Y,,8@rad>u35s!0WCMhGA[=uKDG2`Jf7;<s9`/UbrPGS11os7opu1N01:8mtf47e:(
M6e/m,FNtSZ!VV=;LlX'$A/k91!.[3,:,4Y38(+W%Uq%C:[s9N]AjH_Y.r(SWPtF7':ud8Hd2
hsf!5P8ZNEt0N!6(H'L#M?=LuA>DRoNW`8_9no1e"$XE$`DcAm"JqK3FRgNd+N#hs.VZ"@h,
%EiGncNtD`@ZMOa1g'9Q(-9ukCK.LD3Mik1P75CX$Lf$9#Ut]AR-DhcH.LkSuMcYnN8UN>%Ri
Po3L,=r;QKm(9a_%s!>b]A^DS'@6#%ZV7AX0\;S3IBpJ)2i4(M.3#B[_YJ_;;^s:3.3"1#fXH
R7'+)]A*]AT)_E"</OPgLa1>hSVDH7AhqB)Y6LP]ABVNS+G^F7O=0JV;Uk.Tt@M[\D,Ms?Z!lL0
@LlA?YA]Am1Os-k+5h<h,RZBC[<&tPcK!JZY+K3p+.lS>%,Aug^H$>^]A]Al.K?_tK)GD5Jh$bp
4Zo*VTh""rhO0V=V,]ARC9<l!?FL4TA#ipR6>+/cc*bG;d5M%1f^soS12.LNQa$inmoF(&W,(
rqg'++)Fo?J<5Ld$LdsRd;ZQ&3%)?K#d517"mV7*X?:)h+2'ngI)$*k*ir0g%<8ugH@uad,)
("+l]A/R=`CF-%]A;#4McMW)OCOY!*eL+!Lr+rM'Jb7?!ij8m)Tf804.aiFmi;A_mI=J-)+dAF
Kh!A0UTj"n-C6)<Ek]Aaq"OWJRtR_B!WZ\NpR!rMHQEd-Y\'aEZ_KTK2:\<nTubj=V-jX/\8I
nYW6VtC.$qZe9<]A!B0.&]AB:q(WR:""6'mOJb(U9J;:i'KHhOUi%A`.g;Cao=rZV@9#aV#]A%C
=-6;l$SJD=u`)PA%7cV!jW(m^o=-YYVoBnHI=jA!_N(l1C[lI5cA_3^D`1rR\`+m-(oB\3+V
BjHG@TGCn)9V8EU"qGSSkF!!9^R0ieD>aR95>4IO_"k#J41umLb+Ce?DCej-SDfB9KkW1cP@
dC/3p_aWlSMK;LXpB_<s]AEQ_WGH-X,To6c,h-oShH$D@<]AafFPi]A-(!cgZLhj0_W/[+42-kf
ro%k??hKbt\H.l#X,^]A+&M:1a!mJ#Wl-4fO<\T?trLWMY=iQDaQB)hA`r]A'XR>7b6[RS7H6J
J/FrQTC-iqEOG2_jTWJ,X10WpFJPA+)3+=&M0k@`$$JRS0^VJAAHrK2>[<pd!:.iI\_s0OQ8
_t.4`Z;9\Mu5d@RX.q3r?1S&59L2biNn>8TLZgFI^0ZT99+LO8tlK\>iC#nuQVfdW*]AlYbX<
1hcL8!)<,Q2u3P"c1-=#;%k6"s6p+=b'b5.O+;I]A84IWGBrVk:kY`bTRkYGgGX0XEq:[h9[6
#=k/^Y`c(=.n)QSNlSk4O3D%>?tE3GD(78r9.Hk?'-draur.U#q&7GT\1_e=-<&Yh?#]ApN)I
e>;'i):`*<ojV0M;a+0b'1Sal=L\&n8;foSO$j1jsM)Ghpn([MhBbJeWV2^Mn5i9p2.N"=\-
R1A6:L8MWLLi2`JtR$qA)T7t%$YE!paAgD\<[PE?Ds5>YMAe?:QiKZ[Z\<oodUpU,0P3g02i
K)&Be`FA$UlE&FI6c[n2#^TJW&Nf8+X+@:GApSpk5*;(MQ`$kA9RW24pKZ\<gG(s^sA$9^^D
_&Xe$Q";"KK(Wg0,"I,n^)igE?qN>o&%jU;Diai&n+@bX_?&nl:X(WGK\Xht)k#j`anJTaZg
4&M+6tP>@&VVb$c]A[uM/!+0TTlu'o((b.F=La+n%+b,oN-+<mQh%p/.)E<<5t):e&CU.H)Yr
-r5i1,*Td%@\@R_XaQ0J<h*Y+u_#G$R<O,()CmeHIp#pYkLWb>^Eqb[UYCgHhl8utBkUa=Zh
_h"7#6!31p2Wa:E,2m=qXUD#,'<80KI6d"[2eh:SKSc1@NI-AY3*[Y5D3*.408kR"rg;`3pX
GsJuit0.:%2W1==u^ZZUU?X7!7.J^/qS4TKWCr/6:U,fmR[BW&^E3[tuSG!mOUN?8(ljo!j?
MmNZ>[DT=_W]A@]AF2rC#40tQ$+00k`n0.BXn($su>s$@lg';\<GG_%SYP4#[4SCQi]A8Z>WK*;
>6D"^+/QoAb-;YsX"))i$Z)CTM`f57YVtE&J;30nY&bbupKB$.[kl\Ek4XmhB+igeu6oX[9;
e:9]A($<1S1>'V4'IK)'A2GR><haB?uMs!Um#<$#j<^rLD+2(#\2-c9j_g$;)O?[bi+nr"mEY
loR>@E/-ggC[PM0=]AT7($quRmgA4e*ek)ILHn"=2W<39rUOI^%#<@^L::ARp`U(\FI`e,B4f
HFbWK/)5&6sLME**NoZ9:@*]AZ2s/Z2aX+p4"1q)Bo%a*aY=FbJVrM/j+=`"nRg;>H*a/As,j
37$#(2&'Z$/.\<a%tB\ZFYKrkWmpLt]Ar-^[AF5m[?QG?F!k8J%@IJht^\f=QHfL!i_fS)Ll[
TVuH_C8e@<]A7h=W=JkhcTXX!B9I"N,HR=H)`RtOFmp)$dt.*KaH9Sgk,\sNqSd@Nd?j:ki&V
fn(j(G>dQ$sL;c3apM&peaN<kjI>]A^r1^?WRa*9=W*S0r4fb@pZS@_H8E1!ke*)-aP$F7"tn
KuFb8Q$3"UUG8F6%Of$Z?XX`"rH#kTr?h%")dRhj'bTp'#fb#*5R["+Wa*2b1:Mao#H'NV1)
)3OFI]AMBB*@bL7Ldl?]AWYXm?/,WaYtZ##IP2qkYLDc*>L*+7hM+qpl,ct)r!ON:GlO)5XN!^
?5CG2aH='7m"CU[rJ@3&Od-#I1.Z+75&c9DV5^_A(6Kuq4-Qn7F7Qqbn5Z=iFfp.We*"J)%l
SBl,WY;;V.,CX11ipm@J!"eT#iA:To'.0_nTs\l'=1jOKj>T]AU>8u01jn>2]AV(sbTruio8IN
25fC:O4I&:G71K@c]A`ct[=NTD;Uqu)1f4%2>+%V.j\<+3XHG\'s.Z<2loa"\Qik>C*_mb<7/
VV$s*8/`2,HmMLXrg.*$ic$#91b$%CJYEu["Rqsj)0>K(lkDPhJFf7a1?8f.PnHXhoabJ_+k
!)lc/j%;*^X(-;$j/P9ls80GEXsSQ9?)V?=#:?_bY!qXWFCHfqPL4[ciiBaB8%"i4/6;A.eo
="6@FYJpmie'pDomGg8%<oc/(=j'`^%s@3[8aHsd^?s.7El5A03VaVe[#FU3=Ti.pS/cb-7l
[7@G<,OIi3:YeEmH1@!^u%[VmN!=\Z*g[,LBaJEf\Gkc?8F=ICCit(\K:M`7VXQjHTrU)t`u
7DKrtb/gk^HGKIY-CY*8k@J,QI%q)h8='qPe%7[YsGT#<N&7fI;qc9ka.AR'*r8V",#t3uMG
:'>lT<ZKG6VP%5ff&PA?+sXG<7`ju!Z1LY^OE%>_K'#^^G=Y-Y,SQ!*YqTal(FEjOY/MbG7.
:N.!VR\#nX[=mp.&,W'L]A_WAM<\hE`I96BNJ*Lc"?ZFEk_%h?UU+f0@aqS=DBJn(BL4c)f$V
T#PC>nONAH7`nR"ghX4dSP+,NS_Rkc=hW;&YehBX_9YO!6Kc'b-GJ'3*%&%%C5bHlZYAg_`6
QE3F56<#%#W3D;!-95MVdDqqda"3LDjk+@kY31ITR)dJpIih:NR))?Q?-aU>R(\mLr=_@uTK
Vhp:R9'AXVc]A]Aji"JJdW+R1qmMjHDZ/RFIC*F!>LGGel$\$[nIf[H45X*t8fIC3;_O@CIr9/
/AL^k+/0>]AG./U5tp6CG4s@?;3M<ah(b+'qifU1nV4rI+ci@Mhog.prYo,rhTN5"]A+!60q"r
lUam$&FpZ9?%BJn>nok#lC1+R0b9L^FS]A/!2/Buu+VP-2Dq7Q';i"Vf;86M]ARbjHosWYS7tB
)E:sEE=$7rOFoZuo@pc)brtC]AOEfG[9A/sr#>7YYOP"l0`j2N?5'kS*5=uWQnX'3g=sA6H0@
nG1\NnEEe$%3]A$qg8n<!Y_;@=GT`GKVY)b&p*#+Ge4P)l.P6dfm3l+gLPeQNI.,37,UcHS.N
s&n1?G[@*"J#h)#tiSR7Tp$2BlY]A%Gg)C[bhD+G\AT"ds^S>o%c/>l?L-M3p:%]AmK,jLO09(
4EbmE6E*$c3[L3cCdkYV9_oL1X=C]AeLR&^kQVgrd&&m;nq(M'",D5R0!"">FN\LbCrn6OON#
+i:I!!TN2'*0=$s^kQZ#Pog3i_$BDnp`M3gO8E>%*SBTrC@\4%h-!>kcCreFsLYdtCQAX;#L
5JJsBFY6b)b7(QRCA6cs^ZbN[fMW.h69=7@NaQIn1^0gaWr6lrLeiVp!4kRiHtjK_Q^;s=gY
8]Ah=?D/MQTNW/-)#o"9Ir8`8Kf5aB5bFEV]ANS1b$WiSR/Ok>S6gXXmPO^=c1=pSJ&J0;[;[3
3GU/mn<]AJO).BUE>;dhc02tSUTi,nYJ43GRE8NU1IZ6!h#P-+0!NN$obEA'X#2n;aJnfkCO&
%kA0'al*G*Mb!k'K4'!k!7sm3AJW4Y,!n,R\.>EL?C=>7G>tN"hbV<Ig\mb<pMZSOVm-KG#g
<^V*0%.SeiF&k,QB[csf-4m\SuQ"E,q4W)oCmo9@fcDf/?_gQf"*Jc%""FJ^ro.0uV+-bPAU
^?FX)\b&%BXQoHlH0F=dX]A&meg;CL]A0m5IN\]A!p1+%+VNOpIIoVkb5A5Z_<$2UEj7p7\<n^+
rThU7ojtdk2tm#pU:kJ<&/8kJ'D/=^g1pe&d92C-/>FkHeR4&-_!go\Y-/4u-\&-Ia%;W6p4
h.-n/6]AZqf+FkoT+>c)?O:m'l8o0t`He0<=fe_,U/r?LhMaae-<(lp3\f=cBSDqE[d72:5H*
U(G:=i&4LQdW's3(DCC,Dk^k#'C[QWsng;V!?m=bRr.iNq1@H17+Z,'ARBTgu'Gi$k,k>-a/
g]AL16/sf,@ED(uOAk-.ON9MAY"6=.>SKAC)Wu.i2$"AUFcU2`W@kYVf2#eO&KIRdXT\TbYP4
L[JC350<Rs15I4PZblllb!*PQ8C;d0j4&XQ!"F_hCX-cT=olX8Io]A"YULg%=m?VI!'OYuMoo
#u#AV5+%[4[OC0-e!cq;]A+PI<YUsGG'o5!#KgT:D&N@']A%C0'O:kW:ee&O09nOr?=nI$NtK[
>PJm&&=7J!Tbi_ar#O!;`@IIi>E5,!N$Ws8eSX1gRmp%nh+=Q<9)\"Mi[kd"OW.6uJ]A[U=7l
Z=#/os8+,R!bb@'Wj7mre/`3_BV+Rf+2nV9%,C+&lC\d2.j5V5HHIC^A.7V5k[h7O-p^BX+-
)Y$jD;7Ho$#oM$H*PG#3emea.s8G=Lnlc1*ddoXL[_C;D<YTq@Z<)Ft:ZBM@0NJn-2If8M.J
`]Ald7_&ZZ0YDPLV_AW/W_3qJ509^]AIaui0N.\+f3n`0scOf32F(NP43Uda@Insc20[d4A5$1
UlGHiY\*e9@m,CNR:9+ico(55DpB>bb[X'm!r`#!)=$`C#fk1YqCE/==0[EX@@1@8O_5)idP
s[uG2#]A]A&83='VoDD/R/'Q=X-)0;3gllINoU1/jV@RcatN=BT36pa3\H(1W`47HXAaPS4j$!
2Y`J<r"Rp);3)=GaNl+L?gPARBP"IqUoDr?IIA*5ig>Q1"O6%Ieo).G*YV6(R4>mi$$5p7K_
q%6!-&=Ob<jTA"SH,eIUt29ufF\m(DE*.8#ET<"%%'8_=C/9SH/6rS?5I=$Qi'aUZGH7S/L-
UbW`6&g`RYBbK4C[%K%"g1EEFgak>pJ+CF>A74(\c!VJ*]As'M$0)p-F49]A3(9WQ&?7;!5^>t
"nRB$Cni27&-Yn4s/hh,uE/;%rrTD$`IJX5_oDfgK8%>gau!BJ$BD)"qTD(P`EV8R?50dp3B
V?"(J7rucc>Qg07[12VLB(C.Kb+@*jZ[ZMt1?SA8g9XZSE-d&`F@"f2ch&iZ;m2b7bf7gDl#
trgSkchMfQ9`>/KSAK+b63-J>`p^1^2Sr'_[JX@M&!-Whj?@9*l"jF46b=a]AOi*N@Yc"'/Q&
NdO#m<f#FH\Z63\fC0D0$I)X%#9o0uFK5%:=UNSP$*o(T73cFCU!O\8*=*cCT(%gk"m2lDVd
<K(PdLqc<!E,nd4[P_&1hmuXj*UH\X>(J>%hSQr%N4CP<R7@EVai'cpb/WrV[=g:U$U4>QJ.
=:^>0oZ00RuPnN?$sI"Fh^NI:mQ-=r669;rC)X*Pe>NJYHs<Ig&;4fKQqT*EC9QNO0"YJQ/Z
VL&Ydp#T?NO%"3+#C4?EUJTEq%i+H(&dq3l<nn?UMT/SA;V)6(d&0fWiLJ4Rr-l`s0&MPHsJ
B$TQCuZ6-E_E=sdUUJ6?/gK6[on+OpBXn0!i\,^@`k`X[;G8t1aSR+KPIYSeec'QK6LQ\("C
J`\7k[Yf@:_8fIJRM4BV)-7'>'4[kZk64djAH/SA9Fd:7bm%_""//Q_?j0i>pD.1_\#V29$K
]A8Nb7s8<-$TY6C7<=VV^A!%Z*r%kZPZ51%KLbZ=#VL0J1nH[HMI2I<BVJJD=S=#38ra81Z$_
gW>..ROhYobBjMpd+l23OR@2N44=Fk.oJ2*-@,dP_c'm88/25:IqpY`aKe>cfHU<b2W^Cr6k
B^2RKt5#;g/4rS8)Kh&P;mkjZmM1Huu6>)d!2V0uL=c$ti@H0^,L;L<V(Fcnb%>4L"AY\E;*
>Qir_(F\81BdA7V8#_o<]AM"$]AOAQDf#,n1JtnBBN\=4irc5ruL6M(e#qrLO>]A4uDkNGB9F%t
m3j;%oNR,9"9+#*MDgM=Kp0"HF(Dd3-ce$eQ9"S4^D#<?^t!HEDsFsPX.nXd<1nG3J6f@fK%
FJmtF8^NR4D\#qIE`a`,njnKEeNtal^hnsq640h8FE$V!PmEFeW*)$k(81ud2Q8A&[f'&JTf
gAc-<KaJc,K&JL?hlDf&C$Eei8d;lZo:&mgQ\qLLbiGc$Gt9+qs!imJ'trYgc#l676$9mh-(
TFPB5-BB^Pf@6P4D36JAajW;0<kXqJEh0.9#YdJ(O8l**1B:rVG4hQJBO%#V-!G_Qh9Q+\l;
:-\b5r$f`<m=(3rpdGrr/5<=r*ol7?J%VZ/^9L7T^kqYHIkfTA@*Cpfp?)3&^qp;\!=*X,;:
?MDeFq!ktInMr'H:'Cp0TKS_%AP\>aAeQGK+^0'P5CU_ul;?+LtS\+Sn4I3*['1tAoaBIkeU
8aU+$of^(2G*2kYnTZ1/O1F4n*&C=#NM_SSp"7[h0\u2iMk;T+T^OZmi7-am@YJ"1:Q4-'M6
KZ,j^uPPgNXK=N8T_2c7+mJ"PYjSHcaG%5<X\L9Jh;>_9q5)j+m19A7EV=\&r^E$M"A]A&RQ?
gJfTX6lBhem3=Y%`kArGrghOpkL\UI!C8B/iQb`l#<=c+\3joffrYkd6LSb"/-0(t+C99bP.
V"UUekHo@DLlaDo.hnI1T!#!/5[IFX_=_`M$?nFZ9=S*Tssk<\7I5_VZpAFA=jd0R/%T-WYS
B00#(\'F3N8WFXWcK7'?q)<`M)XO0P!=cYu!#eEkqb%<^TAk)S*Jg/uC'/T3_bQooLT!&AQ;
qIM=gOH*bcBoTmg"mp#"5gsO@5o'3:4\$"$MR%r'R3+,:gT;3%q7l46(5U4)d<f(Z7jEuk&R
16?Egf(2Ik,1R((I*7-(#-Z%W!NPWpejs;beTbh;sC^(=8t3>Bb,Qr%l7s+78`LG)Hp>:-6I
ncKKremn908f_c-[ckj"t`p`b+J$-1cl7!B:'BM`t&$hZBG,<;aVmPsKe>l5'6"W7O)juQi>
PZ'.-7Ce]AFra5+aAlikg$'+9NZtk:_(gACa&^be:<U^D$T?%:]A"^1f'QQ[#!gLE0S.Q.!9i.
/E8-EK'S2q-S4ILCEs8>=.L?oL`L,`0t6jt@8HtDR#eP@.gV4_M0GnJ0!T9/;>?nphSq1qlc
.D#Sn+Mb!,_`r$"@nmQDBnCtB>iL#49Di/_k*=<M:SS=t>XCD6QeG/Cq`h;49R`"f`aaT#<_
A/c46XCR^@'.:r3sT$272qim*k18O]AR240Te8?bsW>c7tq!C6O9?UE.Eu82tUS]AKJosU=7.o
RQ>9q<h=OVW,%+t<+fI0VT4DhGSFL3'<<"tZ&hl8(/a"L=h:rjBB*[P6ph%3Ob9?.KmCJTWT
Z-F+M3?OY%Hp%ihmmgBYp-A[!2o:Or)57M.RCY[,1qrh/UmF+?'KiB[0$@Jd%s:K>]AdkO&1U
O-ljj+n&n![H!M[pD1l=(\i>U3r&Y)#=q"1N\-H95)oUc?j=Si'nGPFI:F3n"l1#+,C,(/((
S;4=B.e^ssh%7AH8_#adb]A!Ma<sA4B#el<g&`7m0=9HFl,#Ri5p*$OW\)tF0r3IiSn1T7;Q(
`9GG,GYeN.4Eu8Oi1lP4)cUh$C985_)ut:I4HG<,41C2[_L6<O=4*s&;T&`K#To4M5iZTin.
]Aq3f4C[HH]AE+*7qp'hkDMr1t[2S@pCd3W%A-_RrRk-7;FTB8Q21XoB)&m@RmC)pB>imY2=ho
EGT01jE?pD+;_?I$55'*Zt6%JRJblc3s[I"e%!AH:p,J,q(QN+=HPbS#Uo?B3bIbQ+&rOSc.
4BkkqHEFq_cZMjVi")_p/994,5XKb,G'Q)WkLEbetK]A(Ynq#u]A0>nH/D^:l!,Ego4mLb(CW*
kK&<lBT0hM?NI^*[7!2lM.@6*>Q0nY_o8X_pF,KHoA=e2oB<h?&jaJh`jRAA8r3KJ(!M(lI5
BFi7M?%]A"9*@=D^$o9Ii+HrX3N\d&9Pm>`SpbXa!W'u6r?d-499o=3;i:pe[Y$Mk75%WYjCu
cA8o$_i[ToVb%b=$OXNkfjnrq'Gco1:KPe+?6\d^G$rc"S;."R'"!Is$BO:=e]A&0/R[@X<c7
u%Y*Df1r<Kri>-5&7$o#l_i"C%:cub*EJ>j?E>D'Jb7Cr$!U1`<eWTAV%]ACpEAfuQrW+IR#4
9gOB(OS!'ubYg*-rf'Md[\9J[7GanLE+Csgm`,/V6+CHP3F\1SucC]AfK8NCg9$\aU89G*r4R
83*S4X&"Lh_8HC]AA+LFp@`E`\g.0A.n<m<H^*5Q:.*4F8YZ49G$-8=6&F56_K,FgIajigA3?
eVu7bs+kj+/H=/fmQmRa)`,,)&lV;)mYDq>LVT7SnpISltg^"XiP7e`7m[nm\:O!N$_#a.RM
?D>fF1X44JC0P0N1hu`7M`S=(peo$mga`SdCi3?G&-gjRoQMmX2Zu$!krX,3ub'qi4ID-PI>
nHCITePe8s.s<C9.G6XT;rbN%2+8Ma;37g5`Os8970?.@ek7am7_jISZ7ObAluocCut1.NiD
t=B2kUV,;=4rM#p]AE94'dN)f3^O!dQ7H_?!Cdj&5mTLD,n:`fNX[ENRQAgkp6+/$1:K^j1@V
C7PJPn]Ak&mcS8#H_RK6!%)@=PbRkRQ#UAlR&?[0OCX#(VFITs4U_2^hIC!3M+JU+Mao+SAqD
=OO_4B,m1Yi:;<0"OhGFPC.rsjog#lM&UDG"Pu\4EQ`qU>)>Mgf9K)!4l#UFjRgVf!S=98u.
6\QU=T=7*rEZO*"'BC;_idQR=S=!#>kfU_<9Lq`TXaFdK)oK+M.M`C!@"iO%<+p/MJEmCOA_
lrcV=?l,KVFLh!gdH]A+?-uI#-<:6Q1"BP#'Y0*WCT)"_-jZ#K+M]AHR3;Es]A>VN5WiBI53<&7
)MOAk$&fd%dgJkpH^i4@j4\\EIbK/5sXS,VhOfWofU=R@R2nlmUhkQhI5M-t4P0GmES[U-Jg
1RIlPW.tMmGj:'o/WuakQ,T$[-Z26Fm_YL/*@QWJ_fee;U7s[;H6g:*H`N.<#3Cd0Yh<r:hU
7"Y,9trr,1>&)!,LBEf_*6rqdDD\WdM4\ncqm-oWsYe)93TjCeKF$PtX2C9O6>Z:6&3qop$j
K]AKbFX7-ZBUb[*G(&F3)jnNG_"&(Z6Wq7@[c7A8KsgIEaYI-*hhm.4Cp6218sqAE/p4cUqE=
7Im6V0cONerZ45.*YHKQiloNHRrVPZ\upX-IohZKBeJ;1.U6%)LU,^LVB.HLaThC,'UjAXco
(:I`?_!<.SH+9$>1peeG9=;WWsL'sTYBW[X\8f=PigO7G._Bgsf6e8`@sL*J-u3d5,oM[!0t
Ofo[1Ofp+he3WA@UD!e+dBa6I2I2#RA+-sWl=Kd$gY$R'<_KCB[D9-CgG5JXYAJN%^ooC]AhV
g&(rZ&"VRsParISd31BmEApD/r1;&Kqd*ailq]A6EELNZ5GC,'qoIB@:&cp7E%qAF53`kg^AM
1UVSlhXh$'5L`Z1O^0ORA8RC>!Ap<iWK0^IhHI=M)>\(06maq750:!9Yq"SiNb8ga5an9JaP
+_Jf!14K@P,2j^,\+"F;dI2>]AW3X'>k;Q9W$=A#m!!giT(XU(8Q-VX#;\041s[9YNrD_W-J?
C6RS]Ad1on*pS`k\2f-&RUt^+bX)Wr(f_*@CesK?rJO\&_askJd.jDL(jVfIAU?UG.Vpj#m-g
"Zq?[H'>T..ac,8*AfHAOLr-hoLl95*fd6J,W#5iQX9@(0@T3Fi;dBAI^asHF?r*7O5C]AG&p
U\aMP1-7$-TB4$'1@[M2^?M^CTjkaTr(`,mP=]AB;:[hJ!!Q7/<VD<8&6G8q=,X`rP##9#/>@
kb8iUnR@AI[Y1'EC/fPcK4J)(Jo4dZ`Lbl=p[J,*tOXhfZ2T(\a_k,&7C78m9%#1s;>@r!q?
k3b`s8'Jkpj!>Gf)@M8kjIHIa0YRGD+8s-R=5/EAVm!#51Z=_R>FaDSr"A>dN1!q%BcZ4LiP
Ve"PJ->>lgoaTZglC.mu]An*lu+%6bE>$[/+\5Vr969D(/VKl<9j6k80"!!RQ+#%);hqbSP`U
c$fO:Yg[GJ?laieZ0?$8HitbmQ4<Qd]A9ppumL/lTZIn8thS)+/9Pu2f]Ac\o'`Od"Yg0:=c<T
BuI6%CLBPhGj8A`iQU:b#$;R[H$(l9/h*7XUBRqks;GSXnqsp"s'R3G3@F<nfF('LT62?.HO
7oqGJcDc%.RA!h7O^gVoUN/`Cs2J*rj^%[8e1!=T.!LrAC2*Wo(jM^o[:a1[6p38VL$M,N`d
*-rHW9qTG;2mNE%D)O+<3U(UJHMhno;QeH39[!W\Xat,*8\4W/6Z.]AFYnD]A?25tFB7sJ&\`t
rAELBZ+7E$3CGkVt%n6F#:W%.P3%>r@mJPWD-B6YlONit@bI%DG_H\f%gGCBKhR_bu)=Xab>
o5CA/4?iS0k>ksQ$]AUB'VWu(tC;gLT#H_6@Q*\!IS_/a,oJW629E(L/!^jZ=/[_M7s/WlGD%
Nuo'kll\VA>;Y9b(sPrT(Te\ouh1#)>[`iNKS)FZpEN'j9/>NsVY*auP;WEo7#dNf@3/`6u5
9m^GjCY`2*X]AV.hI5YshHVOj?Cbs?qeRkMAg_"1'7@6aicm&mHlrN3!H(EpWNAI\rj]A>m->+
!,JcOk5I[]Ar1iT.U</Nm_"ZF,$%[-@H;nt!V0t7k+6.m@T^>[Ab@Chka8Hpld-:3Jod-Rk`X
\tmulSBLL#']A(@aLSa6JCS(E%o#`3lIi$Y+6SE#EQ3-Wc%\'k"pqTTb2MJNkJ[T4)m5R1*ab
a&fj#FGZ_Kq<mZRb,h:Aeop5<d0$?eW`$.J:TV[Nlk*j]A)cDIp@Qo/HjlY6p=>'Uo[ARYLPT
?c0pd=,ormDkDO/!p76e.fMPa;T-3eun5WAdYuHq+9h+?@!V^3(.DCUP1XqJB$ZIDol2s!tS
*+X[qlY*^m()!]AllTM+HJ0_207+t`+b;)-7LTulZJUriA_[0m6>mid>H&%QtJ#T;T5le@0GK
]A\1:8rg'Qq"/7R(2R*0IUhA>8',X;$a:BUqr5uXga7edOlUkG1R:_nPW_P@SQ!AnLqFB.FbF
<%97P=)=''h6c)g.>iOO\H=g(]A+(AKe);Si<RpN3m!r9`^G/NWJaVJ2<'+ZHr_75'fA0@I+;
6_cqtS,\Z<[d#j(q;>$gGGc4_KTa(?akla,>Qc]A[,+j^Cmdeq0%s0*HiioGicmt#u#2h?.(>
Sf<"l[eUlf]ASNAb<^cD2aBGMlG&e*)H^i'#S=pA9Z3F:9Z9#AA$T]A"2XaqXZH?4jbRoH31C)
hT6>1@Cs,tY/B/72S[G`KbU=ML#J'`=bTlcb#7p0??D+L"d##llX^YVjPSjt5e+D@NJh_Zi`
%4JqEOEgSOaH-3L99&4T8o(Mr>]A8lYQk[@;J-I5S;I=8&a#J2691*_UY8^l3il(kdOOIuL^E
_H.Kd:j<GB6h9SflR7\tX^(ml3X"`UNKlf#LJV;Sk>rG/.hQe+$mk_b>\*g9!I,3FhJ*5!O]A
cbu+E@'uKqCgtACP*.+'CJ<D>U*U<o*j0\ci6pa2_8+#-?E\S>c4\mQ5aBoAC1FY7hOLtJDT
DVI?Iu+.m\?o7@BG`%agL!k!t'aeLUd`img->\*P]A//lKhh?@&d-nG+7OoM^Gd+*<")&FKRQ
*_%0((O)[MJ^F0hg[Y:>fAkGA<XdLp*:V,$nmR%u$8mW98,i0f\r?"a7raAZ&Ij"QCkkbf.H
JS$SYutRAcieVjN[!ItZK.jr<>40R37PjC4a3ppHX$Fk-M$(#K<"$2\oHtX\ep*^ggbC4`qN
6HL)!,>K##R3Y8B51BfL=sHpY'/.nA_6`1tOnV1SEh'om5\f(1e`e_^s7m4A5e!DB6jWNl@k
aMJdJ$KY/RW2:[Np2f(C;8E1+DINUb8CE$/)Fe$iYj-Ut.fPLG8@_C$)ZcT9s&XKEfupLNE:
f/MDPm>mP&s/**lj.c%[DB:Ge)'e6.IN=UW9]ApG,id`8ogOWgM>7K\)@u&h6Wci.PUil#=jZ
6XbB@]A*<50E>opGLND:O.*^nF`2T((X'Z3_0gLuC:@f`QC;qPf]A?F$CIc?l^i3T_@CF5QYUI
,u"o86RJ,pQ$kH\(LHHT5l`ZI'mA#5SX6?g;<(o1QSVD=/MYlff$Ka`JCSpO"BlhN.gCf*K[
TMegU#@FC8$Fh(kIk^"`r&qkkJ*6&Vg9g1I-5UZ0`bLIRRlpje0flT]A/&!O2-Aitd5_B@Fs5
\h%[2%YagO[CD,*`9/q[("r0uFtCbn/QKVZW<\b(DP*jpcmYX)F!eg=X*S\<*RFVog+So++<
^:_XUZH&]ACGr?5_"0iP#@8kaX+nKid[]A]A\Xl-pa5Xd&SO<,`]AQYIWfm%92`E'OR&Tt(a;jm*
6W;cI>e&hLice7,n)UaM_]Am"$@Ds8Vm.)[P:KnBIu_"H#^;f(1RQUR!@O2qec"/DgtrmJ=(j
V9?4N90*cs4(eLEKhX33SS._.4&,^4M[;ZIn8.VQS.!HlbdnVAOUs*&#ZU:\bn`4lMd,c_df
rsM7D:c`2&agMEe$Q1:Tq^%$)7X-ZZ^YrS43FFs*<$nGfec;47Xtk+*:IJS.sFjMT-G49^@%
h@tPG=Q*\"@0C^F+q87;_QEk9MO'5mQhs8m!kbAOT0R+4=_*J86qGGXIl,@2oU'i#T@0Xdr+
IP>F[c>&<tB_tebDOQs$&h`Oam&:Mc:kk*&AQ)@$4k"7/p,ZEqs#"T[Mf*pdJo_?[V+EEd.&
iV&R5ET,?O/");$b]Am/qC"F&]A(AL%:0WD[$iZ+?I7K6CTHP&=Xpq)9((3a64sU&f?81q/=7o
VBUZ=8UF\s!M8<`TS=Npr?@C9c@qZ6qP24TsU.2l,c&C%dX&bkLH-Lobu@a&EFbANnU;X-k#
j#JeALuIqUFlMkA\lcHX<Cnjl@Ci!KaL"CG80M+0h%,/f9\<O"Xg(f?k%F#d3dlD;WIRL+)K
PkEKmSsn@Zp]APO]A6Vl@ZGd0%'E"_ahAX-g7q_'7(/bS;'4p1=JS!6kN#n7a7cFM3rDuE]A8?h
-i>b"VjK+MET83>8JSO4_d.2]Aq9t^l,tMgAgb/94Hq9&Z)7TO]A&HBF7X^Z>_a6EK/pD?#qsj
:L+0k@OHpXt#Y'_BU@>NG>!:b>&q@F"g94deF;8P0PMH>[6QR0=Ls#XT't7F28#gcA";0.6"
Pfo$'+U2lrAU%!OpGfU[\rM9p)("TH4=+T;0n>!nH/mf=Ri`c'c5u7Gi#WP0*G15;nP(IU&a
0.lg!U8c:P9`L6<Rk.pm<8;)T<]A?<R"Q@NY[bG4sb%p)h<s0:ZnR.ceRL'&phse(Fp!X[o:6
AsqMCgeMEQ#!$IPY`<3tq59G`-]ACZaC1PlD>^_>leFW0)1O&5pgOGqR6i^O+I`FrPi3'mo#W
96mZ([[\Ol5(,C.h\WqR\D)5*gj(g"XZ'0Wp.q86EGF3Bl8)GVI:0+K(>#Nh"MBrD2K*(%5d
uaP0H28cr`)-hb6o!C8:r7**7g@s4=2la14b9,]Al(:5Y2Mg([Wuoh3X",s8pK[=EJP!"fsXV
e[TAGUZDWiD,,spueSR"A[U>'"ggDJpFO&H5NS%OZ,ROZVgB;[bG&o"S"GHSTl2B7ld9OH(i
^jk!ao`.IUO)`L1Hsa>0),_dCS*.5QSV\6*0jl]AO2D=3Oj8/TrU/X"uSUO"f\@0(Fti;GeJ*
UMD(3R2]A"b,*&8PK\Co$%L.IL_Fe*+d&oo!hSd%[/+43_.+8R[Z;LfQQ;o3-lYaGBD+=/?Aq
`SjCsDGFf8BfEhq`#f1F_km]A#BD(G2rLCA=-eT[!h(@FWtpN*!9i!l%]A^X)Eo/KW/Z=s260,
-66hn*Pb^F6fH4[W:BpqOB<FY1922RG\-H!gU&^@nS?k`cF`EX-!`24]AA3su/m-$fPjAiia]A
+<aPhj'[r22KpWR*er1E:Wi',]Ahm*&'F$h`QI!j!qru]ANC9&MCbjDNiFUb30n)=bLU6p"1K^
tn!Qe24PG@ZiAl\PFj)KU8iu.QLd3@.7r]A!$5i(aWB0cF'eJ6MT1Y%F7.pAsV4EhSRke5\Z5
RD:A/#6cs]A7OI_T%Xhb(*8i2p?l$c8RRiWg;YT#g9`=o2HB!ZJV6ICS6rf&F+dAlb@FOH:^i
.T..E[1eV<J=@gZDGn."7!jq&G=[/\U(`$Y5pD'&>rCO2r9icGWhqTV@1IhrRK=K0l/NhT)B
[B7?!PM3omlT.0Po:'fSEK/04%55f$tod!$Y'H5A#MM6_sluJA%licgoqX.p3TRk=R$l"Q5!
Q\T.*!YYVnp?6(a,Jl@HbT(/0kL8.d3<pTOl4@IC=9"g]A5O0Z5:a_2*?UoIFpk%AMdIbB\-1
)?^!8kI!mA<JBK)5*R4ZN1R4V^L=Mu\n,R*9'cYi"."]A*\p=5^PJV'i@<[INIsDr#rkfiK"3
]ATi]Ao;/7'!UUK[%.qLIj"C0#%#OF;r4WO5GK%JpEiP2:!llkA&!$K_j:dUmK$-:-2;%j5k1f
2C$r()V#n'/dEYVJF*>QtF:^5F<4C=TS5e?Q,c$X7nLA8b;EbE/^Y\V^'a1t\]A$]A$*Zhak%(
1QA3#4(+dAM=FT(Y4ZseA&Ja).q]ADp6fUk'#Z7,R@(%JD^aERB9AXrPIfMM6&f\DADo;hcsN
QgD)P,eVQQ3O(nbiT!4#-M6*(pJp>0%u^:Y%6r'oF`X%ntM_1;Y&Yn;g^M87`-*1#"Db4+!g
L6*q6gnH>76[4a7_*kKs#k#sNcHJ3P/oB`p+Jlibt,j)Z0pail8`me+'mN1$of'pf-?H''0h
Kl/`</0>Q/*%iH*IiU,"SSg:s%kj0P2`=Z\mcHE)!oNjbk4;LDRt#d!E-cinTa!o[6;'oC$E
9DXDcm=\F=W9-K@KPKE39O9=Djk,?l,C+Q%+@(3=#`^nJ1J)C7?%3'HMJ"*cBdq<;?=uo\(l
=@Gj:!'U=uKnO)!VT('1;L0HZjSNIWpV:b#bF(e^KSCo;,kB1./]ADf)!OI+m-7?Pp%n*J)4g
]Ai%3dsSjM+_9jFM05C"j@A%'FH\R'HpnYD7gJ@05AE5:n![<;D$uu7>4"?9\"#tr\3\trh!Q
0l&GOZA47n/gXjcS!XJQi`I*SZ3[l4\b<iAumV874bPSBTifV:.^`@GL!)eks'In#m;:<7ml
KbIABolT5s35H+L3bf`)<6p[4M9$M`'.Nsb4tL$G63JKI?&3GT^?]A17IMrl;T*c-u/)0$AgT
A@H1#+<1UY6l5Sq@2j8?WNARZk#EPn$68@7ja9r7b5lS#r"/WO'@Rck@]A5"<>F,:q<L6Xf8^
W`_(1dq491Q8.!qL>+:!E&_W)0eke*h4Wrbe5-M[%lA>SAGBIdKJ9_gUa[Tbk&6:)?L&^1#A
0@gG4L=O\^Jpl5g0-aM57:LIUe0)1]A7\(Alfmjs9Ts78EN<t-@L,UnXAS!+X%tGH=;!*&WoZ
U4-+uLWZ@9@gY>rNqg]AcR38i?n-dRRMZg:$,MNM%tM`8N$qXGt3hj@t`HkTbm=+\)0HfK)p/
L;I]A1KA^MimH;Tc=9=UDk490`-Z5^L&diBnVnE_5L8R-37,l39qbsD%p9/k7ME$NkoGBJ^Rc
_(9^T&`P[GmDC:F71/cc(Rg^B\$NK^M2O:$4a)n1oS%GdGL[CAsPO;Ahc8!J!bn%n32*HQe=
>3UXZ;hQm+H\cRn.&;2>cjp_(fhET;pHto]AV=)(T[X"9s/&_:hh'$&#kd.2<qgt%)2?l:1g8
ruk@PuHKSAI7uQ-XZ%S[YpAdPl-sMj"(dDR`aXBNJoi%XH[C9o,tZ1_B'71QoS%^7qW?`eU2
LgdW3g!k#[^#ETm]A$UJ0>F3]AY"&Fjk]A@2-Q]Aq^NXsOh=.A$7B(N18]A`p,DJ_nad8N]Alf,OXD
XD%^0(!`83D$PL_R7BX+5%GP"oBa_E&`WBdYR^)k`*'mJ*]A@r@XSOd.Vo7tmR!Oo/3Q?Ch3$
Y_/>*K2qM8JNr&_'8Vo;pVRTnGH#'jI=!qN50V'75R0JHAk_PXjOg]AhYt)gIZp1>-C0dSL7i
8CWcA4r,IRZ2lO0^.=]AI9ehNk]A<6IN[T$EstKOgaCNhiRIh)$-ZBJr4GI>L;E&ld@TJEk4)a
sq3(aV%=DRT;^h^o"q?C!%,-[!Bpo<H?40b`q%U0"8`$d2>kaA)6l=M7Vd\)LU&2eU;*)n1'
YW-ol6I4-=,jgu\O(aIamtl68d`:r5"UJPJb1.&$,73i9]A/[#lHQ6C4fmXc:L&eB0>3Se*0I
hX]Ag;J9+A1o%2<ikXD(F?IF;sS_HXd4;qsirZHo^rRM$ZJ?a@PEKI$iYesQ`XogldZar64H'
5JMFO"15R'`9]A?am`[*]A+]A3'.[LU_^nfcjQ0-XU`#1'HS00C6>+h\cMCfK)GMU3B)DF@qr>e
Eo3ul"d[n#l1X@f+#pqO3Zn=ChPt9h9<\p/bEPr,;s8P'U!d#g7HT;4j/HcYcJ'0+]A(`UEUN
k%m2ChN&_!-sVJp"=S!CYmM=$HVrte>ch5NH"VUJn>W?-4Cd8Z5=-f)6K$'au*_Ug_Yh=YHA
H#ljdHp@i0[LYnp"63s[-*HsEis_)D=6Qcl_XVmpe/L.Uk+2!NrAOF1+RocqB'rVhO6Kp._7
fK9iE[i&ndlk5B8S58641o:uFcWR&>n2-KSY)BBH/<]Al]A/un[<e\?W;OrB3<'inf7p1enhmf
)Wq$60gF,0n%E3:1>mXPZl8(_)QkW;o0?JHLV9,p>Vq5??\IS*ok4)AoTj\H*[M=o+AHDPN#
_&<JQ`'&u#@!0bD46oCP/JCKLs4,luN*FfH%\cO^$1U_AtKY1)m2R-1.Ijkl6pq)tjeR`:^r
!GB!SGu=<hkltuAQh;cfc_]A4Hlo')51mF)g!4I20-]AJ+K[?L=PbhC)a%&;76d9X/:R5N(Z\f
o"B@>p@#,nFd&f"7,&B8]A1]AWHsi&r+QL*3(WVgTM]At2Y(XKVS\M,9Je+@/4#DBY\=VjqEEn+
<gQ6LdU#?4k"9e5,:MYq_s^kbi%1/eKWaiiXVAKu<Y<N@'7tI)jaq,H3Eft3OGE:s&/&GKEm
HgKAGEq(85]ADVgJGg2NCDQ5l?Mp9CXM\Ain>X$X4JltKT&\(rQVK=?HqRH@+sb>28a#H-C@N
&mAgX\(og2HE(mf@+Sor?IYX0Klr!-SI?GP!iB>X@o`F4b5:buc/qlT\q*j,^_NS>R>%#Q3?
MLm.8c%,l+08nL[rL-(5K@*M.?*-u;q6C0VBA;06,>LZbia7JRn++fM_9pOp]A%Z=S,cBm\!q
O@&:D-%3U)Y8?!\QC=qT5$H0eV2M5H"Z1>4s&BXZBd$e6n0U'Kg;4B.<6p\46'aV5RHiI1><
NW<VdHlHsbNZ`iaA&I=@-J$lkh5p_Z'Q<F\o\#f;Jhp#ZK.WjH?0Y+$^_cH2E,//7N&<mLC(
Bq$MBYSdeeGVQplZqsYeg1HWg1sWZa&!>WC\k,6IM=<G&r4/[k99'gQf(E-g0cF<3\`2E^TU
Q5)CT.:0ZNKQ]A9k?n5Oq&HIVhH>,njsT9=M35FcklRYhWR\AQ1=auAO8rlEgiK#H%nPVBOns
2<Eq:()&o@8\;n7-OmDeZ^]AJ<2:D0MI+)p=tN-D-Lh?@=ueRsI)SSka6_D&la.j-n)robhi8
d;gR3C=)),E'/1cU748]A;N36Z4hU8YnRBmuD2&4r<OY':^[2I1N-lSB?b:06Aa^9#bI2W@SM
k/T(c_u%Tm%HD1,?_#W`Cs\pq*nR!58_]A&H6*_AC\n!0Kc4Nd0Z.?kl+!eE(9p!1O@tsBXq\
5RX.AIC-#X!XHB.OZRkg<i!,tXN`HZgWN1lX_iKp'0$T3ti@%_/uC?30WJ[r]A`83qJ4dfa/6
XaKSaZN2(.4*VU;S7o@rMTI-_6o]A\.n=0LH1,Cj<s?DHb2eRls[rn7A0`-[PKh[l2l'=.97k
Hhp5)E0g?POD%aq97MUD!Q-&^t>8f($$Do*VQrnC,O01S0ed6Mo(-%#g8X8);4Vb8NV5cL5l
^2<RTY<q8WFo&Xi&[r9kLl4]Aat?Ni;Bnhf&<R*HT]AH45;1CM1E6lW\<#L00S^UfJ[b=:.>uh
U.:E%jf8<k(&-b;'6i7Na3Mr<N0b2Y`@nm8+t9dBA;ijo#iq>dA@C):cDq"2\o5M`"-S%T)V
[9[KFIVPA3bDn<@$kp,`Wnk]AR@C-c5Q^h8+2obT$=>M%N"$*V\O(V7n=Y0#!r>9_Vs,GBqdi
\jC!`5QDV*%Yuq%P>%PWN#KVfU2*nPpp)?(s-17"@q`=OMkn\<6SYo$VJ"Ui._XD$A(K$YSm
G;#i332`4-L?s+MeN5WfoT@D9i'_U&!JuZ\!Z]A&O71q_okcQMXUaoj%QI<V!qnHg3R4R7XFa
)g#!uqO1KNTIB"+[0-QD*E%sM1SUk/VD\k`:5V,nP<5>Y-OSPAY7-:#j'BKBTn5BZR_).XNQ
\[qbB1^EGA9.HS86-G2amjeZq!Lj=o'lr]A:2o'0*#X,mqfcRV%'Okg7j1ii,=<WDOm',+I4$
S;o^,\Em4h:\,OpN\e-/Eb7W`,T"+?Ndd4>%eu"n:<rY6D4d%2Dq\bHcJ2V=dYB$Pgpa\QE]A
`2DI%ZoVf&)2;KBlF;FEGER^drlnO\:r3K"(EYmb\.\#G<>^g^8`\8jkphoFXWMmi=Y2>e5S
^8cW@Adht]AaL=VjgO4VD#[6q"Lld).br6+_tTpI")2&NC[l>rXrd]AEP_Vb0q,u[4^@J@V%N[
`JYo<XG?<e,7ir<tfr"iR<!".d[FJJY4oa[s]AS]AUX>!M5"Sb``J3qE3>=k2*>;T^_sn7f`5#
6YDhI;pW$6CcNB=#lM;V2_'JV>JMq>B5$.-O+V/XFcgOeXR*lE"lZT'@YM-^S_(#2a^^ar.)
&M?JFqX"ZWX>kYUt`G[nu22@5H^;^V2lRN96,VblVdFs#'E:k#?A@ArZqk_1t%@fk!V+I*GF
D+'g&AdNT7;q,6bGDl6:2%,nHg7QFfa:W?`0o]A&B!i>kjU!It3WYtE%ea0:A@M+_+3M+I5`4
5R(;ff=]ApL>9:YeX1d^UT^/qa.d1@_YC>!B'-"HSVdX9mS%I^SR_L/AuRI'Gt=[HkkC&Iic+
'JamkKO4N-4>H@[Iao5,*!G4,)`n0X#B]AK'>%#lH,4!KZhkXR*qA*.o97\*mtD;i4tK;#3j+
Qe<9/hse&O$I'IEFJ$ikFU9_#h8#q(Ub7\+'*A4V'HkO,D6%QPq6C`;qB?U_Lo*B'bfh;A=d
Z$]A$m-'V(PE:58gg3qr>J.s?jAbor%+84e]AEjEOI%kJK7jL"Ab,8eBmH#&Ja/*%.SsRIfQUr
Vq@q)CQt%/Z;DO/@R?F1(i'bj*^N[.^-b$*8J,/Fl=rOAYBc3Lc04aRtW3<u'8^tr&Jfi&J8
dhG>)2)A+:"0fLS9*or'Apa6$3n/,llkVlmb#;2;6NEG%8]ADoVB5J]AFdI9MMb7rgfG5?#Vrb
rs90Rbik="4dIe-\mD5CZ;WLRS=R,6p%f@&E(qPk/'L\`oA'E\M0LCr8a/VWiV.#c'WSuU,E
Bich)P`1fXFb5hZZsq:&?t]AeoicW%@rLdm1bn7c'0[m&_W'dG3%T<n>2Rd-flnH,=@W^qmP9
u"XJ]A_O)`4"=5oTZus7Sf7k-i7G^8=En(%IkZ+"f\5Q597?g,9>kq?b:t,:DrSGfHjn:\Qgi
=ppES*4@d&lHJT<H.Q%AoC@%3=J=&0-kp:TYpXY82,5i721(7MO]AU*A98]Aqj>b8gs5l[E%uU
U&1i,hqDhCX;i,nc8K_RqN`bL!fVe?Q<`cGaO\^8t#VTE4j\4Y"'T7@Hfokai@ZIl2PTig">
Lr5;)2GQfMT4hoW"?`c>XGI;&R$8V>ji:,]A0KaJ/U>m=DqE0'W@4F)In`rnSbelH+=XqRd7.
]AMa2bc1O-'N\=<5%_$,\[9cO!Srrii@IMbTI\/4MVG$TglOPU@Oq@CJm=hAsXbmqJg)CVe-p
OXP5*jig6i1a!W$pEXHG46,,W7H;`Ng3RRdh9h==4IJGGH18XDW]A+kYPgbI/QU66pc^+,DmB
X?@J1WI1uI'K0CT@T;=*h6IkXU41%/u,eJ;)G/P7\;G?dUW%4`[m9--:G2F\ffI(:9cqO4^F
mWh$E9X-W+"<QfO!./.oQ5qYO.&MKJcQL@-2,J[?]A<2#iq7<YWmG?'IhD_R>_*LpjQ(X?C]AY
GoH;lNP\<Hh'm<iubHI/O!9&Md!.sXqiTKtX(C6p`(>;o-GhIO5j]A'/GMER[+[@%DY^Q:#61
9/"NqCo*GhKTfZRI?OH:;Ju;4q9K1PVA(\6I;]A):*ET?!3tpT[n)8r=:O_;5RWT)5$g`RY?/
dW0CW_E-"'[l0*Kk%UZqY[<&&$nBQ!,q:?1'aR\N)0LrNmS;HS:g.gscb)?Pae_Y4=aJ)hbJ
Hn&^7,FNbh,*kcbZ)bN0OSIj&d(/CB+-Q7?kP+()p0#NO6Pl=rkd3ZE2%GoFG+(1>epJRmS0
RYcZ5UXPKM/f98f>GZa7??kGI6mdf3?2?k\hWaRP0Y/tEc#[Yh;T<q]AJ$2)I61F2L/L`qk/u
fIbgo^V_#)bV-^X@AeR[k#7S<iu[V^+71UL&ijrPS0pQ7)J]AJXU(R;@99gTpG5%QIP!0ifiH
l.ZPAH$D@;:77B9(U"A92RXmQ-&^/k4_@?RpILsS3acn_8RLuU:PkL[I_TQVNqs%08(9BM5#
ipuC;VqIX#c`d9hEY-i"F4d7&5>DSKVl`dIL$S@$m\,NSc4)XOW\dUpa9Up[8BM^I+tBJt]A\
kA[5D!f!\ESfP-BM3Tg$XgsO@2OM7@n6=kI+[%;-N:MP/6d-1lo^7dGY0oDsa]A>o#aZYn"j2
gGX,C)VSL7:hW!#$<6(PA:qf5=jlohpYT_N0$o!h[CO4FV*Y`01F<cC9;2sh^-!6Fg5.qlkB
TYNdjZZCeRl8]ATPKP&E6<qA]Aj)1dah)%h`;AIlMGa"kHKf`cSU32UP&fuLeh]AQ%:m-E/[Gqs
>,Br!"$c11mprSDH,m[PS=GjOppIL)RI3]Ap-_aNJ)0Ri9$RSdW\6Z"E-5)S=c%deSYib@t]AY
j%/3(s$DH@NJao?A!D`"j?Mb9CFBZJk)]AotTb94.tD+LnAX`d2RZ4,bc1j@O=q*17\46'!b`
QHFR,6+V9k[q@m+SF`C6C#^)u@LodMBN(Na<j<Tk^[`Y^!HhPb9JtG4ql/#eFBhZo&K&sZuD
c)OsogeB&7:\.DOqn_C7FijF;h?DB\'onPBd5FmTiP)J\)Sf)pqV/d<mNV)HJ29/mIdQ,?K$
jVD^3LcjH\[54f']A[8qB%WUQW4f?A1udXEf^4NqHZ,Sk)25R7p+^IKsuH@OVF.B<=//;^2;t
1tOHMr7!H+/)pKgq+EVS%f@(=U>ee*3+bNi1YjOb"r#lK\SeARqlNbjkhQs%Yk0f#64FiA5!
A"]AT(>R=;@9dN_c1iCXrhK0GEIX5C["LJ48o!R4Thj*Hsr1Ek3U^S41S$_5.90Pg/E:'XdjG
Gd_!u8h8LDbg)''T^\,fcnG=TY!FMX\H(O+rAbKZ&Ks$q&P!&03/r<$Q/t.+\f$XNV,Dk4G$
!u3B]AOcbNTV+heF`lkl^(Pj*q_tu"fUX2aPS`34g0r`')LXf\:;.Bgp0l.H).r2W9+/JuKd&
a_)u1&U5cZS_!)%3InSq($hN7<!'.`_7deo?Q+I?4OTV/Ae^9GgFgb>WlogK)SWs@u9f"=,Q
ih_t29=3H,`C+:pX).ZO>;T>-&@Z2Tj[,Xr@#$[!\O71'A<u".:mb,53T/LelMIX5&GNu[,W
:k\/30P99QbT#8URJ0WW(,M"&c!bK)IC/(V0s#@<L"c`upc%:?FF=Z?kU/6>ZJHKOEG0d*&;
l\qt@`eFsUa$+m?LdZZa_Y;L'2p)\/?45Z(D*?BGL\[F;,WhY6*((&ZSIT>$%<*%0fY$]A_`>
3\B%kh%^uIMC`nAb=4R""l*NiK,mm$)C?f?9M,M9A`lK)6+Q110SX9EACm;&H5k,[6YtP]AOt
A+E@=Y;nJbo>3mE;'HfZIf`CsW$>Rt;ZW<2C^C3mT1QT*&FIhasp%;7c-To&Zo@l<?9;)FF!
\__5WhTn2=_9LNZbfr#q/C[eWU_&q;7\%/13+ZcN65t2pZp&+\_bGo]A<4U'I/nT"u_s*ggl(
[-'%8n=GhUf4`]AO[&!T!tT[F4?=2j`#@mhWMY$]AQ'`cS-+GHPljap8]ACVWC95Sls4dgNp+mX
=9e@6tZ&V14HWj,flP#Pr*4`WQ1gP!`fZ,6klb'8Q)FG$!mQA4g6sU]AGVO2dfJ-bN.Ni.p33
g^AS4VD,pCNJ;&Vd*$H%gcV/"O$r)b$-Cm:'Q%+)?[$ice4#rbO+9F*Un!Fql$-JC2kGTr#J
R=*6DVX-[KQ?C`l1YhrK6/F!l=\mV[.@R/Ge,HtNgkrGQNT>;V2j39(rJ1'J4`Y>9p[2/*A+
dk7%O.o@X'Y9k$$k*AV\(Jb9W.spXG"W[!\NFbCd?=Zfh05Edj/PZ#Fh>ibo*E,m5O;TQs0_
XuYg>?+K]A?j1M*d//"/d"<+E>t_?LZHT2s"u'?e9[S[]ATCgoNS2V%ca_$.e_>;hfnfX(:P`A
ua8FnkVm<gm6MX[\L2I3l<l5`U\ICGaPuC<rAV9,NersuiD<.o*,J#CDP:"(V'6f\IFnOb)R
UFGSUXYHgch59)%FO":aEEc7KUDI;nUGQ(_B8^3d5lc)L?i0eNF7/j'0.MPfUbE'_a%>,-V9
T6W>nUK2=ZcMpDnJ%4aKV.d4jl*:^"&Y5+r(.Y9HuN*[K9eoX\`#F]ACgpCt\)H%sJknX$$$n
#FBiHR"t=Fhc,I9<aA`=l./&HC!d$S[;YYoDE8dDX/cSs60><\,_Y%*_K@H=%gcra6CO3g&r
sWXc=StA3H77t'8FjtU/=<Vld;/Z$)9!EdloY#+T"MEWjq@Y<&$241]A(!;]AO4is:B8sqf1Ib
N2YnrN!.cn]A'S&H)Gf@IaLHq*(JE*s>B7$X*O1f?2#"$?l'j*Yf<SbKA%,cd68F#aJ]A7FF"#
nU0ab0'0J%GOIGEe2?dcLppY@"3gL/X97pStM*@S.+q+hr(s/Bc\KO_s/nH:g!?$]AdZT4#hn
RgpDZC]A7alQMfGiotQe9AX`'mIDo0*gCRh5Jae*7Zcs4OmX8E>*,g:*.KEfiJ4p)p-6lZVtd
GiG=Js/mM<SJm]A!3[KKn=T0.PB(kOU.o3-:U]Am)^DDk9An(W>Vi?ugrs7t;9UXPi;!p$Rnib
.#!_Qmishj1,k;rS$NIdkS]ATW>/-7eOGbZsM&1[7C)]AnY+2X*,>ckFJZG:0n$_t/V<:K]A>F0
U_D>dX1K[SJBk:gbk3&IZTLRZV\\:G>.K?!+/&j?bka<Za+/U7*:KD6AE(pb]A,4U#U'2f)-=
hE*>RG0Z(IsH^L8N3cNR!eB5Ek_N)k2R'4:jG!Sn4.0-kr0-4q=Frtmo)WDEn`1grkp&9geD
ec?JQ]APRTVT+;BLnST(O[t?6[X+p3X"6A4]Ae*cl%(A,la^J_b3!si9a4E\t,$jIYlL:khIaO
Pada"r:7#2)RCtOL%hX_ZdZCr3bI4)2e(4@-;0<3BA$9tWoBd+lNbq]A6qUp]A0+oE(QVc(LN-
082mjg<f=?1]A7E<$g=`c!C(8S4Z".jf$2'2_=C.SE*iqhq_kjMi&_9!ik`/:;V.!L,iA?uA.
3c@4Yb@u("=f5)_=bt5!HPEgfJ&X.^rVI,!nEO+=hpBf`P.IpDFqbcQ\W\8XiGM7;Ff5'tPR
7A<4-6?;V:E/`R"TM@@3!llHYkf*AoMsl:<umW#%u1(mA&s,1f8N@4#WTVdjEH,2[F>*LO<_
&Q-*B_hRQgJ2V&/_(H-\>Z&)TV1\OH#DPd]AIMVsFohG@T4:P4u\aIY2bRIUBd21\BZ'=4SZ0
,^$dGkX9&uSGkRsHW'bhDMEUO$fp<QIVA?61l6!SaQE74(c990F9V\7os(B'iBu)Prso~
]]></IM>
</Background>
<Alpha alpha="1.0"/>
</Border>
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
<IM>
<![CDATA[<4I'QPAqO"4E>O:N#!*A&4ZC"!Ke'mOCluB.Hqg+@RqAYQ\;_fN#\M=dRYTG]A)0D.q7cTMhW
q]AOfWjJnFmldqY4Ghm[\aB\&Vp\m!0F4pGch,K@"SI[X?$F\qfcKQ-OBg(&Lu>onp90WQjfW
BXib5D_K-u[pd6Yj&k,lI7W584rEP\m-lYan9CNW5<XsjR@XgXG330blD%Y>q5PR@QqEE#&U
s\s#f^$i!ibk\uWqm(Od_'c=63IZ<>43KEg-+R[$F%cKE@q0up%cAQ"P*lqH/p#4rbY$VpN;
kV]A-mWYplB.ka`H]A@:&_$co1/!\WrHi%jYo2%%R?prj[.rs;WUtB(.,7NIk'FE.LElP0GO<W
G4LKXGqWIN-OPl(s6;JZCU/@:n6)XalEc(\P<$lYl&HS^@Bg&<:TpI,s)"gi'F@kb2"em]A[!
t7\5]AO)"k_'6l0K(TJjKFLA=(=>fB`nM/MqqnJ'[$-UEj+1-E.oD-H\6,us.@?AJ&1EDD@r4
:djQmqqkioXD]Artn8goK.-Jj59_o'<nr:43C'.c`\gu!m'=()'.ae39G"_<qAc4O/-emAdq;
ZEBLMbua3#?>UGjQo*1+NF<.UjhlmS&H).nc!DD+\e2o)".EHJtE$35;RC.*RQ[hG+G^Dq'Y
AYn_j:s1>0GmqDE4iLt\a*qbu$pE<;fHETjIK_RcHIShV+5k070NEpOtR3)4so'+%Q&oD_`b
?]A&9[A&@86Hc0?7P_L;7hCP/;+ng=ON*Q.MT1Clr[JAn`l1te2*4?[&gk$NC,-^g^U&"3p=+
n\-lfi;R>,GOj577<2Yj1P(3]Ah?+!K[Q'Tq'd#!SEX._nSRL2^G$!jCiUVWoJ3Uo328"h-ld
Ii<fO24tJr8HOjW`r]AD2='ofK.^Tb,Z-Xpm#ruLj<9C`]Afd,4^Jh8fNtqPU52BOo^&9gI<j)
0\119FrpbS@Q'I5LF0Ml^9'grelVK-fA.@S7C&SU,2WV10^>2$ijicj^h3g9n;5`WV6rYFuN
*a%-DdTpS_U/l.`O6d!6>NRS21n7B&ilGfS"E?KU:"EP`<.p\m`t<Sf,#^O4F+L`R;(1'8:+
5a`@cYT>$oe?uY02l);aQ^,KFXX2T*X$n>d.5\6LQLPHF*j$CV(<XDOAbBS4oX!7"I5E^\Y7
UZ)?@#6$BE4?^`*J=n9k;WhUa1<'*D>Y(fpcff8H[Xp!9"uL<A^<"<hN)j<83o:O?4)+&;@H
@&-Mc=LNC&RV3a@-P1_J*ZGWQW'NeBF)'hHO8VbB"8GtE(YQ"]A33KAB2pnnR-c4Tu+`qLCqJ
6kFT,8Dam(2PXUU'-,NdSLK?2?#W,dc3\$1Ulq2T2d(26(.R>k\6*9V3tJ2_Fs407S@i^%ld
l[qmNcSH]AQ%#gTZH<oUN_[0?b]ACb4`fo4Kmt@oA\<3!iV_OAT)M%j)i.S58amT?C0]A8MrQGR
W8P7]AQTT!Ims99*PueLY)X`RW7OI$l"(sc$&=[2`m)b:'Dsh%+-.^r^`^DF>\mKZ_`4CC1_C
AR:T&:BV4$<(RGus"Mnto>^Js8cWiSl0SU9PuQUA>rY6h7Mid<"h^^I^E;3>]A(\_fO-bT7`?
<8R%9RPEEe5IF>iFN-7ss^'0$qa&7eSi3&EDI[9^JbkmZXeWq$Oc"6G*J,&-an-^(T?qp[mc
b"SY"%]A/4aNDm8g%`s$(%3WICsDac%rDjSLIJ;.R:C%=U4j4B!WC&"riC%0<e#/((V$&)VlF
l;./cAu)]A>-N.AuJkg@fGHdM"56r+$?"q1B$a$U0jUo,FOZiE*>eK%dA>GZ2TX"Z"m(,C\Uh
RU"12be<nRF4R+1hQ<=;^f]A8]AHH,7=--)"X<pZp21#XgG$R/V@oKC7UX7t'97i08L[Y9'#'&
>ef):i?L3>>NH!iqsi>qG<r5S8fE@ARAn&M599NH1L^MktQ?5FumW:*!\o+fF"gCfHe\L8&F
d+ffDGQ+OqNS3"0d%.Z).95mp8/1!IH?+>id:W$ck'Q"f"9b@'^\GhfP-8T,M-hZ<L'#BQL9
"`ITD&^JQjcj6*B(pko;D5F2M-.O(%rE8#,uXt[MuIZh*0tsED-Mk5O(S_nSFcVY.PKIVf@O
FRccOl7D>S3Xpfo=c4]AEs.I&h2''gZ,QPL4"=]A=gb;X2'HTEiloBjg>b@`J>7!gpX3k-r<oQ
U3]A@uJY_Z@T>c)k]A)\c./(Y_4_`1E4osKLIkgIGk9(sXFk0]A7WiN:3@d$MYpZOoe78SI6u[H
6<9pK>F]A=I9!i5#m'#Rn)%B\!=6LBND7L#21_A4uMS-&"?>&h55SqqHF5,"h2.Z]A=&1G]Anu0
Bg%0=a",Y+6NCZ--a-@h&2&Q$'LHLZX5kr<]A[X2qJ<>gc*3meVpiX]A-j<aq+aA!q77INm]AWe
f<01A5rLM?oc>]An7fA$\6>k&@+',j@j]AW<-/hGjoj\UG8_L%qkgDHu5;R#unM9;WR()"qgn*
O:pp-q,0DFK*F?Z7]AHm`^G0Qb`O$,`YN*/]A_u4Zm3C28),VoF/t/..NOf`_>8XFrc_4ct@Z)
_RrTKF35(a&J^+qe.5F8'p'V$FH[p':.$s7TPT5n"DA'2SkCph&Q_ADpF\h>l=#Ee\[MVBcl
538Glms.MqN$LY9:3(?9+)7AgC']A->;Z1J+:`mA"Nqr217I+]A9ToWs7fOH\KRfO"ik\`Nd`E
\(rd7b'UHf1Cel[=V1NmMnI<dH:X3g!$dt%n$G&iXoIt@J@'mm\fgVsFPT7nH#&eD45AD@2m
E8>:0q-qkE&?^UhsMDW9>."_Cc'=5kh=.3Za2+dFq9FUfJN/o"d,!c_dsZ(##'=&>Q,Z]AXf\
5aiP5?:Jgc.s&ABZr1hi8u`k@pKpsPFL]As#680Bt/:DOTB25,Va<(DM5?#833^G8[S64O4r?
SUTXFYa_fR-j2r0jZ[EpBiUGoEYVg:&C;?\Ke0<152&+N,sEhSXB/4c<D(]As^2q9QAefkX\o
nXp=%qMr<f-l5RHmVmC"mukL0kja6#n!5^YDGC%a$_Li48JinH$;$\-MMsr[BliCAdAP"RK7
!3--AMom#0aK?*&`GK5!hVm;8@T$K5Ol+Ya.5M40b`ir'SouVDd?Wa_1((Vr;AJH%<;@#j\^
_HM62\K[7b>24B(2N@3bIYA^c0Fn,AfZ5Cc0?3T5]A=%bTN[*&aZTUtS@aA`N,u"Fh9(;pDoH
#d>(8@8/DdKHnK:miRB4):I'V+3CGqFH8H%p2cVW*$`%"7rp1Wao.t.C)f`l)r`t0NNTt6Vs
-j6G1-Oa[i=NBJh3j4/:e^R?NHn>)%JuE=%-]AL)3'nID0_R@RTG+V<85cBV-!l#t*METUr9[
WOX`u`pUi=JsK4.`'!K%RCigi6p2<9mMgSS<H%TNjBlo#?LBbg4.;:$XkYTtPQ1#Qe+aMFPW
?1s-BW/NBVV.plnm6(9W+>$ZjodEJ$4[ZDDd=?O`b&3T3NV\%k4F#!)]Aai3d#=D_$7KC"0Yl
!!q(e"qFB%(>+^'8Y6iNY:cD13aDg@\/JW-)YN`j*"dBD5*&=/RPQa``ak_I?EMnh<E[p?#?
,15>]A%R%_t(/\=a?P#C=K#Ro$2KSXNBIcdIaa[Vc1cJO+bP7FqebjTd=f7E(2&m='1/bebLs
Ta?aV\rLo'(&YW)Sb#970.'^'&Y&Gap9Pab/<K=,k%M3+iZ99sB<K%2GLFV-G&/!XZ`\(W0R
tqLEj5&U&tM2?*>r^55#ZlW%"DWK)=]A#\#6WTrq\i;G&t6,1e%8`Ci'(&h@DH>U2koB&;Z#<
rC"9X.gJf^*W$"GK,l)dKL2cI"^dMGmi;l7&;+_aSD*<Sq7B#BJ7Ba\,">#aLELeY'60O8s^
&/VCChCVdl]At=gbOoo=n,A&q5$>P&[=3@>-uFJ"G[oAbeCVDi1<OTUq#1)]Anu!g\-/n=[WJR
eUUJ97i.0i<m9,>[N7XZSH8KtX9nhl[sH'_gt*3]AcgkK+J/^Xk`cO83ZuLess5#S\[gPl7R*
gF/A:B\jS=2[^U=+RVIQc!C:eF]A!j=]AQRh7Q9OXuQW8u8Pb_[B:PYqEarK-/dQHTO/<]AWGk%
D$!`S0f@"8]A$CV3?5\TX)?qhBBae]AIUHcdkfptHM:io_^'!"g9Jlqn="=%n$(;j(M[tfTM.^
?c;aJeH[*'%)\Gj:J/i+dm]Ar5I(kGIt"faBs2:%OXe2+E:^['&L0)?7d"NJa^=tM)a>2gq\K
!L"\ZZd8#^s.X3(Yq#"lZ?e3-C&G]AaNac"(A&4Y*I<3DrO\)ZD$P6:o.m44?lN;f#^e-ML+u
ougNM8abj@uWK,N?m`6pdTo?F[`**UAlES/Th3lO%b@3fISU<R5u3_78#[D%>FjKoTba!"pj
;#oALj[GH"(t7$!_,GeY'S":e!hnbDCP\J;?i_=+,7p<1.sN<bg#GWeK"&\hE]AV3Ik-V&"NC
os=OI1_EKk_bF54Op/_6_@#_A]A]AbB4lFK$Jfq'UWU%mf<q5BWtoShKpX3fp(!9TT=R/>NQ?F
i'<6LmmF[6d[hfZcrBM&O,U,HsAPHAM5'4%h8DZ9@=*4>jM!3:<R;W2;PuV*_+i78^<!e'*i
"e`a/>"AqCYs.h_CqHu[EeK9Xg;>-AMsSoj&\p@1BYgt$(Zg)RdXr`0e"AJj0kZ@#!qVD(f#
5?q[<iiq0cM;[qGaK6#]AA=L-%u#:-1s4^9[M@o)`m$2[B=*_^M6CD6%nC\S"#oV\>VP&l"_$
F:[_>LZWZuEQ6L[h`t'J<5L7=9$9;[0<6^,:*Kd3g:UqGL`Ig1/d[5D__BULE6)o0\fu`Ae)
cUr>_":S1P2gPRmF9MhFCuGTs`6UkHB-\U$[IED]A]AaW]A=Pc[Ik2r+IW:u?X-=:_7(YjikR@$
r^F-4JSL8f*1g2P/`o[M02oCtM*3L_<EohDAfG*;[K@Jk7Z4m)Tl1KP&WeV&<;TA-<ldl<8a
1ll.KoKnu<'?K'qOXP,_L(F6o-o&CDRLb.Lj($/doD"!O@.32Wl/^lb40%QY@XJ1f_TY<S(%
h>mBQYdA9,(CoQp7Er?DWcC;)>;dDM;N@j4+PrH5RJ_t7C%-:j<E*$(/sbu&f)gtm]ApV=[*P
)fK1Zlh\0=1k`FuJT)s!j?3B@G//]Aqh\m*srl%9kX'T2,JS/@u;9f.FSUXOtK:Hu&=tiAf>:
;"Y/*T_+=_Tce[G.A&>`F00q)O8_+9"p$lBU)Gg1F8=PI>W6[M(k]A9YJD3ADfnp#=[X^]Aa]AD
an(I2miY*<XQ3M\g"!4%>M-K)ZADO%=aPj<.TuSLh"+LW@A6Ekt.soJ<kAQ:Ug)M_(VS,7#^
.WO]AeW:/J+H\HP5l<,\!p1[oS),sU8_f=on^Ek_fBghIQ`$iJ]AO1=[]AnSYS;p%>3WcEim2aC
/QVb)/'k*'p)/e$D?`[q_^EM:90+>OUHEs\?fnt*Jl2G8Q#Qhub(;_&!#JQ97mbP(kbqmn[9
[XDGD@TOZmJh)5+YBO/$O`aak##c"DIEJ%G9ibe>i#>45DTjKPd3e0DOc[+=+=i36PnuDsKF
N0YNA"M\@D4s9&r\g@"GR`>e\$P(eG@]ACQd2)%gRdc;Us0YN^!k3J,TJl%8Z?NHhYUNHPH&]A
VW?%WfH+)PqY1QchSTa7*p^&-'qGPK+hP[[arXpb8mF3!%'d0s!HnZO,b8,!f[V!jd9n]A()@
UC6/c.oiPN&*S>)R(CWGegAj(&a=jb,!EO5Ggi_B!'15'\"Xs2=&^CC"ofpR\+hP4[0dJ(U'
',b=E,Wg`F:hh6G4#-.9*OV0R=Dp+hYEWO$TN(d.jB%d_\V?<5eu$,4W&3Z/A:(E)#@Q0a"j
?o]An+jNsG_X*1F<E>g1KN*4GJ,5p!\,ADA2I;$!EKMH^?+*=27^-02;O4F=e1Mt,)=H<L;A3
%nN=uRbUY*%;b^FSJu]AL0^q7b=DuDH^=WlCO1O@q&UV#fhiY$Rl.Lg2h;;"bnh/[hcfA;M1I
_E0FpM^!>EUU.)m7ajeNdca_!f^1,</U\R?\O-AYSlG?<Ff;[FRZ6=P/M3I>gO'J:<L`I@NB
eJWj(JiQ+DbiU"`\sT="hZE'nWT6<o[@i]A^>+%>RmOQE3S5:4IKkfO%C?#]Ae$6P5/l\]Ag'ER
mGRqIuDh7rXI_Ied=@1np7O^![D\k,j#5Y@Q8J*\TCn9.>9r,tj+H25Imqpr'lS/BKgUYjd1
ccTXb^=TQA+a_;P6.T(uI2Mn5EBjSS=k1t&\Z>-)BtNb*$JT9fj9)@Z7!r[]AGj+tMrJ8n7BT
=bJQdYXJEULD_s00IPWK38u!NpQ%]AA:!]Aft.5^mF&/(_HGI%0s4;!?OE"jERR]A)<]A*"R(=IO
S24Hr:YaY!@]A*k'+5fbB8$A[?sB.eV8Z5P=o"9=LgP;1JX=YdLaq5tm.UM]A4n0#kkJ/aJeu`
l/q0I`Y7\nKK!D1DTU)O"E`_4"a)'9jq(#'\U=YR1XT)ZTkLs(tuscR?tldbP[2FS#[%gStB
Y5FboASC(cV.1^*>(CF"gQ_'_ZiI>W&=/mS\d*=W+e$P&c8Uf_fkL'-tj-IhR-23,WKk+Vuu
DjA1uE<PU,*(LWV]A.^&ead]A<XH]AH]AK=1Mih[0\1CbTqZEESlmY)t9%:`(Hbl;s$T2`dk1Z^&
^8_ia3@s2Krc18VZ&^H7joJc*KgCN]AK[/N?1Yh"e1)A!gen@`D't4Q;aBtrnGLPC"bgai\+V
t,/g5e]A0TR=:7lR1*&>5C.NR3_ZYKsUANFeLGC7[KAqrK_l50@kGi@pjT6$^;FCD3Cb<ER+H
mHn.d)Osoc]Aum]A?qXV&80sPOZuGouQJN#(.M69JN#?-KIP7Ebrb+RuplfQl/JW_=*Z[et8ad
rhgbI4(C=9F>ct)/`)7oN3>qBkUUX8ajjlY:hCn-RNDQi\oLTRgb+Cm(cUjZ$fkH^g?FL&bE
o2W;5h-!Z3X6C1jl$)o?rHGH$o0MsO>=XaiUu@'&2Vpe-6t@Y;W,#?NC?YQ,_nYB>8&q(K4r
'&*@)d6DSq2hTr&-f#n?tJ'NS(_e=U&,WhW[M$$*Pc)WS>8,pfb2?^lP]A;r-n5d4kdMp)WE1
["Oi8'nr6I@dA"[<;O5a'!%tu8M<Fl^1s:+2V(9`YVg\(F.``*XY9JltlIY).O0)T4#EJ521
%)'n.rs8KI_b@=&LmeO!3oVPFW_nMCD"X78.#6l%R7#gaR\6A6;S3#HL-\4,ur`iqVe&"r5L
o1LLKi\7GD0poF#'@=23aY.ZAfPLS_;i.\q!42=G8&\@tQr8!SGkAq=0D]AqWJ/7binUD7qM+
rm4?$"2PFRiffA+H4^V.+no8+TLl3V!UofYV<Wq\IR9rbl:nJ-.-K0$@Aa42f.:&.QWc,t2m
tk<JSni7$WQ#pe6A7B&iSI)r\Yb[-^3r*q5-GX4U*rL2#Wdt&Nur1pt3aG8T2A-[qe```''1
S3,08jRURodJqAMVF$:C9=Bg/OBGtCR&.<C.QYm^mKNFd9W<0c%*g%/T>qB1J5D$hd?k>T.2
%+p^g]AdJD/ug,E'!Xo7n_-]Ah8<5?HAcYiJ64JE^KL)</Wu0r!9o]AM^qNBZEbO^J%[>A##jL-
PK0YujRg,NP[F$B9@1(b42*O\/I3ibQUC-TZ1eGJFX/nVn\eXTMD*9=]A`+#19\F"kkHOO[Ie
f6\:%2V[KjL#5mFFn1UCJ8T,ap"LWA\VuO``h^Z>!Cp_$[e$ujf@0EjdIZkCQYe*87WGtPI\
G*I1t`,[aF:#,h=a.QA3:Cbi`.bm2iHjbr6-$2R*L`5?;nu;rK3m(<q4YV?rrU:3f(s>ju.f
Bj3QP#LYEOO[qt_?i,HRCs"8B+enF3r)<)?1H$(&[[)^Tr4"20h]AHXMp+#8WYY+.LVM/.GK>
:-N*"'$F+5EFF"&?Wr]AE&AbsBFYRHHoa&L?jM]A60Pru@nID;6B>mAZA:7oi^b`g4m^]AlZo/m
;_>B-PAW(MA9n*((\<N3V,J`m[;\-\5L3+$(MfY;]Ag*:^F]AG^F.f!7Yi4@=>$IkFg1DkMf":
^0_<H[W\7re2qRs?c`%"_g>Ht,G-rp9DaX8Dt@7^e/jI:b\<:X^?k*M++hIMk=.Y</^WOuMR
,&/+ZbUKFSqpfVt7!(6#7UP\_Cm('LN-&VQ8QZhjTI]Ad>ncmDWV'Cm)ka__3TKP%m:GP!J6J
PP8@3_k(sd(,T^TQ*Qk3X^0A^2UVmeEqlYDG1ctF2qmSYNS/M<K?*W"'o:UNrB^QTq9@NB*L
Z3WdN4+3rO8Wm6[CRs<BG*hkF8^?%O90<X$\p&:R9VaJN@`j"mk:2H`S_rt![t&X*#$fE'M2
KX&^u/lnCs;;G5b3jbcu^hM'X4i2apieDdZ=dIHLpq;W<?/jn@8fISl&8,_RX0g_jM)oj,@+
WM1$-1+0ihF0qWg8,=D`^!lm7RG8K`/T;SKUt?KjM'in(j4#0I)[Mq8+b=61lJP`Xb*W/<$g
#K8FmBJD'-"dkLF#a1P140j<SY9h%J5_S*4ctB_M8,FQn$g3S*JUC)KZseie@jfEJiWW1#2C
bGN2!0LZU[Jpc?oH,o%\PFc:>I8(!SSD4G/i89o)JJ)tH?)tXkPIhEb]AIlUl<2Q@_K^W3pXX
FJ_.,Z!;0n/V;8M_fq;(u_^-V!dr5j")2EiKFB1E/1f1%?F3Mh+BtOcgE]A&QH"k7=f1+P@lR
PeoY,P2\r+0<E=$RXO\#:(7gVbRj+?AXN\%/<kOYPNMloFn'BU3[^T??_,o"^`mW9s.AO4DN
]A7;2?1OGClq+S\:&uB/X.]A-n"\9N,+Rrc?pZ.-I2M\F`UXF%,i(YEr]A9\queli$5o/7EZ"`p
*[o%O(QHn5EN$./nOdPbjL=P'lqEqP6W/5`\P;TJec4SJo'Jf9>3KN?2:&jDel7A02A@[mk#
,R+eWWgX9U09/f=;p.qfJORaYbFJqZl?6;'25K1bJZ!r:(9$Q)!D#<S$m*ojhm$V\3Cu=U&D
#EYhCuoInD+ea2!k*]A4O:YZZ"8S<TCcjf\&ZW*sWte`b4DTr&qV[BP=EsL1ht1`M[M\?h6i2
f)QK-lAl'=!E]A?.G?P,FmHIhV*-CMFLiJUmV8OqoTk:%%Ck!h4&OiU/8tr$lH/;+\WKO1=:?
)HS4KVgZ_3]A8lWnpe3Ud8`+:SIZF[.W/X%?e>,@!c`g%M/mu=0Mu>ddZM*WB,'W3^A=o)l*J
_(2Ml?ib7@'?AOJ*kAl29O[Ka*%6f3^1OltBBN&B5h8UHWB;8Lj<jU.:t3a::0.q`Ot.S&e-
-^;VbSb\Jr>N/j>Tk-rY8kGEMr=9'jfm6\E@_kVqkp'D@=e]AndH=kEH]ArqXNaDSO5(!:StTA
7,#CL'QhA7A^ob(M/$?X&B8058K@MHF8rT9\0hc4*SRnQPFIR.c*$Y4Q1>IfBh%CK5U;PosB
Y2/#[%toHDB#Wc(&<r'$-R4h:\eYDlnQZ1W>mA:>uBQ[Pph<)\=F+(sZu\*bOH8IiTC/(u@d
:E+>B8MZNS8j;e5N)RYsDsf"3[BdSl\sgnuOs5q0C.W>#;4"<)bC<DY`Cn717WuG"1Y9J!9L
O/K?qm<t9R(r,MkMe'_&ZZP[MUQ,+j0lC.?&B=k?Rld?i&Okf7%>EE^6k%!Q`A#;.&_h4IRk
Q*`.Ff9H=pMWA"Z51rU!;,QPG4e!jbpLXM=T&NgqmlVJZo0bcSalB!T,pr&-W'>dEg:'20uG
PP?'n4U`pL[g.DBQ@[k^V58;YU>9^MAUJDNuJ1-;nH)Xd\(I.dD0(@R<UAh%itoIRMaAMftH
Van^4MWppI8ik]A>K/H5\(KKHlYM#Cblr4&8]A'C0H%QnLi^!Y)O0ej,7H\aYn44N.1:(Oc-b_
".#G%fHm_ImIV&qpt2+Okr2D(\II,ml&.YOFk3=J^;^,E%EW^Gf/90"`bB5$I&X:"A5;'H5.
6;Wh-#'810q4nEnbofc'7Tf31-pX^HpEX3/O/E$&@1^C3<U35i56+WLQF-^,(<_+8#q%(FI/
I>+r^D-gJt3X!Dt5=OXDKaq^D;eD[tN]ALQu<.]AA>()"REQ>\'H%fVES[DR7fq)qbsseY]A/S@
k%9gkJYTW[Fl[AA<*;XoaeaTXa2JMMHS0S:oqX[`B\19Y[`J^)B2iT]A!2FbdZ6-6:(h'<OF;
d%NkW%\??pLHB1$E-SB!UQo_<2\pX#'0`2iG\C8c.>j6jo=bu_n+R>.*2O0s$Q/sB/oJUauN
lInu!_EV,a^^WcsCB'N:(m0\OGDPjqXS;7j2?fqLUTfD&ag6e-CkmnGj'&V;IW7[!)_.0&pr
HUqFM@_(;"=FB%bWrh_?0>k^dE'JjNr0Ko@K&3X:t6cQ7i8Ga8PKHkJhAZk9ifP4;$/nq<:'
O4Fhgk!:U5O;BQ[bnqAJ=T5'k"ZM0U4'hCAZm/Y"!>?nh-L-mG?;pf]AI^!oNk(sWhL`B4BQ7
kg&sd_*K;90Sa$l&lS?YHnCale'u^g"$F#TuMZ6bF&@k'>h5N*TY^q0Q//Z+p09Pm>8M0-IP
c;:WUfO-W4[g83[rX?4OW8(jg'@\`>"kGqI2KXYTO;GW9*jYkG;eJPbkYGH0nb8Stp)A")Ak
R$L`h+;O']AbhCp1]AIdU*GEZj_s"tH@QG_*<oKP8h2uNO5Sjf(/3<*[`IkbVQk>DKQj#Pa<V3
*qIRUR*lri'@JrooiI5U'7k,@7Ouf0U."#RHXQUO46G:E?4I;WT#CC3M_LBJftd0R<?NnB]Ad
`h&8,QWIh%=dUgNUo^8HGq2'HrZ%E&So:E:dN*[J&mE$]A/2B$VW`lf"J&*pW`guu`;X_6=fV
7b^sDU'LOqmDADh]An:5-2t-QZoF0Me-RuW4&_@G>o2qm3&X#<Wse]AQGM*l!@ZT=sca:4q.=*
DIB1OG2f_)CiaV$q3Mj#djP/bKf@RJUm/^aY'OT9hW@gY@d`!k2O^t9TC`e"N&pE?V95H8[i
LkH(f>&;+&IX,EZ1s[N_L!dB_J^=kX\[l_GgFha<26i?ab,^P[DVC4#Qc+!)0eP-eS$"1.)2
3(n/VTDE`i'f9D]AVs:QcN(p!c9sbFq$sVN%Ig)XLj1W#GnBQGIbenf@m5''0"ICp]A"tifVq)
ls!#LprRapZXYKQGh89\F$j*6i-,S4IgLI!"pZAWuJ<oj&^poR)mj0N[aTNY!*=`q!?&ErV`
t1*T3oY0]A-$^mopC[s=G/GJ\29;C4;TTD\`NMInB-IGE0q]A=gFOJ1KZZ'Yufc"g0Oi?+s-Ta
_p"uR">dBY$YG]AQ"T!+(,@YJ]A!Kj"B\8D!*s.>91%3kOX/^4DDY,i%M<OM.4G$4Bdm.ZtGMe
&GAW'F@.I_:GVr1]ACO<41?%4$Ej;L)pE1RZ,o>TGDC6gmZ^V(n_la-?=p)A![(]Ab1SNDXG^B
ah`3et4U,ekLLJ-]A(M>=DEA7L@5"m"HJ<R2ZK4/hZ!2M/8,^X@%FaAO^.H8Y3s%H$e*8aHCg
ME-N2@:;R%7+OiDt8F`Mn*HY!UWJ\P!4CR*UXo;Ei=$/eI,r_>'h9N5%:4"M81(T:mZ]AJ@d2
GRPU6olL'=<hpO/<u=(^ZP?BM48q]AN;nQ_&R<t<`<D!3ZZ.Xj=[rtG$<[^.qk&>sQ8$po`9p
\H3O,uT0_55d,[_6Epr#1\/iB\ib]AQn3*0gB@m[nGf4^aGJL4s4=muh0p>b`2+jBbjZgCU'f
V!SqGRfKJ9cf9.HQ.>n#.0/oM^$(3W#ugpJX%ZH>X6CU#)'JQm/2XPq.%%5YTjGWImQh?>\C
JDor;]A1R.Npbb@t?)eE<$-p0P;maZ+^>U)V!5VpM#-V,KZ.k?@X@kn':_dNVm2P[FOnVI;*r
oHl'`F@-IO#JV-]ApfhqJ;#S;h]A_37d%JHCa6E#UpMidJatSo%[lSi^]A!jbcKh=tqG/Ql8n(p
.!*1'!XZW>(."pet,g=%A8JTciWjcDa[uqMQ>n7]A6N0r%r-'/mMd5"b)f!dUUc!CI`gc8#1J
:GCT;$?MS<WAWm>=Yi%e>i7<FXn61[EKIb)r`dCRWgG`)If37)UBAm=t9^,Lb8.1E)E@lm0M
l^Y^ZG,_e9LQ)*s.A2T_n#G9J75\7h?@V_$)&[LqgN3L.(/:U$AiDbm<iu'[s+d'i%"MXQch
:u>D6H,ZU$,j<l?2XpkB[k-%s<YRYD3;+IEQGS["(ZinZ3if5+I44]A7be5$mfU#Z0:3:h^kD
)h"0G$hN>!%=+8cI.719ien-:dSn1[44u:8;@O_b.7s(HUCNX7L873-4L4bpU%Mnt^pg=qg[
GK_qJ90b0-t/gCm2`b5C@J3kI^;";3.XD_J\>]AXj`.0=C%6uS-g![u482OKN!I$VSA6f=>f`
%7Y'6;/pDOF(^)fiqcQBY<fQ/Vokm;@D1\!iaXZ)ICR$JKDWcf.J,!Eb9cq5rX3g?AK+!pl[
Bt$6r@RN-Z"3%JnZYFs!]A@+Q!#s@+PGS-a`Pde.ARH_=Yo4A<4qMFuY$<f,=$]AKVD\B0ef"b
/16Mh\Hj$=ub#aH=tAj=%%Zd,?ceKX1XcaoM>B>UCmo_+fE:(j5N5:&G#C=ss[q-h/XPjJ=I
<:DpuOj`&S3j@PCR0=kL.WTr&3+mUeBhaMotdeos<GZo53l:>3_=%:>NfX@bo*rpqi$6_Lpg
pdiD40r*IV((Q?JuA#PM@,!go+1E\Sag_!85X3XLO7Q3#t_gn)IeYN/;..Tph,LmH]A)!&L49
-[O6MYbX@@t+qlMdJPZRYFjJ0-$69JS"?V.%:)=,UTF6/a:kMs*CG!pZ-O$R0P[W#ia\8_=o
L)#o2nbm[1%E04Co868H:XkF0/:$)CTOBV6W3OerFl\+pgoisK#UKZdY+9a0!o^5FEausIEb
:e2g1AsVBJ$sX"=KZPJfg)+><sX[Q$k2UApP,6&b]AfR$`8a+/W.r`@VbQ^>bKaF5l\7iUl,(
(piQW]A=NYGI:r)BH]A4e-cQ%GH!:0euo?7G2gN,ku/HCauTNXJISp65jLd02NHKPpTs/\=jT&
m/)nBd=Ei=OI\">KPNr#fXO_4cX^O>j.GER.>jg=X^np+=_K535l(TCO\8$='qZYVYEh-^gp
'2ko8\&iZ%5W]A[]A1?lGWW!I?p/l7#=8]A80^C*f42S"XG6a>kT1om-eSi#^)_<)VO^\1+Z2kd
\VVVmbD?]Al&[3]A/\BXc)#J7ZD6W-9ZZerul_>Xs>FcZ69CN&m1ga3+hCf$T4f@\8`-G(Tm2A
ST)5t(7Lqt8W8&LV[K,j#l4ScRO03<lgqhX2"@\3%q@kajJ4mWl<`%Ct:N"+]Ad's2>OtP#3=
GDejG=f%n&fr6g\kju@_>JD8qhL4k4JXO6ab6Tt?\S@^YHk4(K,]A@l<C&SSA/Ik0Y=5^Ur#_
/I)HZ8Hcap7!>1J-ErV.N-B<IVJ[pSfn.kG)>Oo=^/9S6^1I:`/?W@e$:FbIQ&.Z:\;^MGX;
nl&b72X>[dT2D]AJ=g%f3eMC+p_K*m>VYA+7@d?)W<GA9PK0`#$Ka,rU-8M`$&.f+<70%oZPF
e)')Vf"oIW!3#IOb@^gB_eXlkBRSAJF9)A_Ve<s2-0+a-QIDrAVs=Xu,/rKaUL#=#RT0_SKo
bfqab43.F!li#\@/Whk0Kr+&br:5$=DS)q<n[8.HLdjM0Sa&_p;T36<4fB&o^d@^(!#1$u35
0519GSN-6qMT-76W1`('hDc'aiH/uE$9KY[!6Y8me!A=X1/6F(WP3Tu;9&B9os)eNC.WC_^f
R"Hcjb3/Hg8LeJQ3\1diEE)O(doWK7P>iFbVOE2`':(do=BpG41IQTdNuR:Bd<HF\9)OrWkC
BIe;!utR`_toVW`)T>tM;n1Co46kP;DR?uhp-2u+[;oG4/$',b6*5KBU4N+"\geJ0TJb;[`c
1$@_f.283/`helZ2,#X7]Ar^A"4\C<2)oS-!X4XNL[1loK:!!Mhn(rhjO4u:1rD4b+lH#ejfB
_Ngp"t6,R`j1nS/LA]APMZS7Dpm0]A]ANcmf1*WA.F\6J)A8:Y;k?aoK*tJM-P9XA.-kKNoJ7CM
6>fIGK2fSsT"N&c>a+uu&);2VpCXU[Yqi-$oat(Bm2;\BaSrVBY2Z"B4k4GNq`:R[OUS7e&h
nEP[/If"S4JU#2daESN#O@Z)_9$Hm0I\Aqp)ul]A:;U@CYbr)T3>qT4PghF%V2S9SR=X*Y"tV
Xt#Q4f+2gee/`s8YFcp7gF<ELPbf('&q%b6:->K.8+.*'"U-RBN.n52t^J-3K7O,$.N?qG9P
l%:N7]A$T$fi<IZV`#`>/jFZ074`$PmVM%tg&Ne^1L"'6>aN0Ln7o2[&7[qgfU&DoK&?iB@ZN
J9t@E[S\#e#K-inB[-.5TH"S\sGT$l#LW?pEiHn:Dtf;X?(WK!1_Q;W3G^SCc/3(nR/P.=(S
iq@XJ70SO1bkji03>FWkaRpF<TCMtks!^eEo7N9oU2F/Y0?sTV_C"5cOHLA/18)?H&1n^4mH
`WilJt2C%@/0YDEqk/6DXI>f)CT>Jg^^Oe#Q%ZtP]A34pk@L"NT0KEOBPFAi@K_)Dr(&NRnmE
KpdSXENe[jSgY^.sJ@PNofs1&u.PRO0LW9k3br(!DlesdPC;4"\#$>K#S@`O8BRA?/P*Z&1N
e4WI@0L;]A%dIF9u/#tG/cQes5'qCXhm,e'o+EoL%:6q1?A;Cr&3`(d;p"Q[LO'Z_ebjMGMW\
4_X[X4<@/1dR]A.)W5fL3#gZ2RuN2#4(/Yc+5'_G!"B!RsM-^cURta`8BedG1^`_+='<+^*$*
l4U+16Yb[b7[[D]ANh@Drp1L9=k%g&hF-X9cL*ZJ#)g\3fO(Oh?@H'rRAA53X17/kN)JWF882
?(f6DIp>RDL7j$GIN8sIT2Pi@.5CJTNm!1LnEg9g;/So6h%%E9Qj\FeRce`X.E!bhNd[4qE1
b*dW`TfMia?spYRm:o1a3Hh(L3]Ahns#W6r%1_4K"b4'tm#Q:?3,>FRe"V!B+bVT]A.jfN9a7u
,]ANC0c)kof5t'T$C^*^B<tr=TRFL<8*oUU!-HhsIV)iRtJVeP+]Ab<f;K;*\c[teIWRqI^XI+
cHm8fa\jP)`[.a'Z5so6<RdB0JQMdI`<2;m:^Z`Ycg+=A=PC_WjIBY[kfRTlWG.9Hd+E`&/D
dPfJ"N*3+rjCT?Z%#CM27U4"\1eIj\&B<n4gOkMkQf1ORuCXZjLGltmm.r-jPfXQJEl^-H'F
r-/8'3DI`C\5CKC/M@j<a=Y7=@nZ0)n;Z0q4fp4SU8KP33I<u"J,e+/(QT6NS61;SY^5d*+Y
^sN=R"&lV\IP*4O)H/C0S0[q8@PNCeW+XblDS*JE[t/9)_9*jMqTk><YqE>?(ZXTht&ps7Jr
/E[8!B^GeUY4%BISaiRYQcktrb<f\P;/WKJlXaYeTjuX^_9"Nei-K4H*)<#:*m@=K;f*ZY2o
gONn;I@]AOSAg.75!3f?FX7sL>6HQYm_g\<4r<'XZ7`3\5\JC(^C6c&42KtdBG&Wp@(B8QPSn
ckqhf#N6i]Ai)-Nn\I:9[9VuG->3suC/%uW8Lr*$k[lke2-?IsQSpd:<eoOE$4/olk$YY`7/_
sM:50]A$`*qV0R-+*>]AbgAp_FOabP>"+]ApBgQM"Ue.N,K$&^>&YqoM@#Z(+jOjC*k@_ia3.;J
#MBR$)nn`">0\tXP8KbB;-<PTH`fY_@5O[ATQ8>4W\86(ua5(h[n(T*Va!<)&bf59n045ZW2
$obRD65/`<0*h\lEp4E9_'[5'FlY5MgF2o$51[_Oc:IYG;6s`1&:,gB8M2tl0EhDnV2P=OM5
WT%_c([#rh]A:JPcVXS10mfM[6%Ss.p$/I+:(^TLD$CqBiFm2,r9l5qc[$:::cYiHp1guCCoH
e=]A_;$WcC2SNB^d!7_YUYb_%R?',5??Zh44jFT=HBmG7&;ZEb#Sdl_5ObCFK8;Mb%\fbTo!6
"RlqhkO9uF'OnI<Pt6TP;^!Ng%ibdl=*Eo-6c1-)%K)Bo\Xtk`K,)QbEUBj_Zo]Aq6L+rQc\8
2$K<.=3<FRk633e%f*?U:M_>Z.q9ckWk)C<pg*;A*JD6cUS`;EQ4)1HKYcb3%a-KkYg'+9\C
Za2-V8tZVlN9[HKjApL(l<\MbUe$ZWI,+_K!uNZXIS$"-2KZ=5MK)9F1th=k[LI8J=/#4.TK
i`0EEF2fE;Zh#\C6</*Pn$58*`O*ZrO0ZjqJ0@b58.g`"ddA4uPCp'n:W7i<QS=B*'.H"8$g
e4bpsJ]AUsl+=$V'"M/0J8X-5n.>>It%'b3U<=!S@QdrKTgqSgc;=(aYkI\OPt.?Ae]A-HU'uk
TJJNq%)ID7I9p(CF.k5UYhA`IDYfRI79cW1\0QI8l$RENG:lk-Cjp0)0&78aR#H6I%*#n=\g
M#VEbOuLY:$2gCJl,7aMoRnBVl20ar)aEuFP)(uYO]A*O^\CP0E<[^0C^bX<6L4>bCT:1WTs>
39?lW)eJ)%H3Wf+B&lL/GS5Y4W$B$L-!)bNp,d3N(PQ_uC`G7pldQeoHMn9+r+<<e&ocebrH
fp/O^5NZ<g,ji]A:f?-?@<>%Hm*=$`ZT#q93o/%f[R697(2;0i#&(o5DQ_9b3n&M5:Za7f+"-
CY.d3UEO-I/Q]A!I)>HZK>-D_c'ElY3EBHYrq1BeKV?'0\faF1/,pqUja?BT?o)F1+!+]AipaN
0MmZJ=&^mHh5:MAfbaa>\oCF<_]An&QsTP^jls"TgPcS>q`R]A03tN:gP5EoIK^@D"F:j/PK43
\#2C<\#4QENsPAUMp]A3A+;L5S8skA`L$EZ4r[FpnOYGR2F8JFpN#6^)MpT]Ahn9d=,);a<_^C
4YPOF1PhVOY9GRtcT"=9q^VMo@3uS1`kHS&@@&,hfAdOb&,-pWLdW&n\F<CtG%Ce)?DeYq?S
b#F0D[>/Gu:i%ds',kFnGGWN<J5@5ao8o[9%>X0nR1G(t*5uG6V@'@PG>(3Q.eq'S5Ujkj<e
Ypp=YlH6/*KUEB%)2H>cJD1*ki\>sXZn1joD;EP7`dX^)U@-NLK*;%`;gkC+><7[^=>UYIlj
1o"<INHnu_N29BID^AQ<;5cf4"=E[hr8)/8q,"<f`ppM3]AGi5i!(s^.r[675pU6OYSG[JTX4
)!Z?qP%Xgt0:[j`F&cfInb71"A`G9YTMBbiO[(HXt$%I*'heURAD=hHEV,D7sP,73IoWehG$
niWg+N`(cm:hKfaW444h6eqt&!Iq>\H;LL8(i(3qfCFb;JGqWP0C%FZ;,CF!4[uE\G1$,g=N
GqHV-I4.OXGLB85;,r:D2Eh\/*[]AaB;8$C0G1LQ,Gnn?5*7E@4*IC\m3GF_??']AZgQT6+Ncp
t`,EL"5=2;F68)nma&q#6H3`uFglJE8p`(jWE/ai)gkDPFTd]Ag;%1ATrZs'/Z6?.lKF5KgQ\
lJtI<m=!:Y\#1#BMEXTbM5OVd*Y=\"W_TUIKU4DRIUtdY8Ma>h8@IH,+EHr2Vt5cNP8a5-:@
$IHYCWc5_fHco$Ec9g.p(ugdJb4DSI7ln`Cod8N($9XL_hfh^1OQ<TT$ed+Rq31Z*DnCJtfM
"CNtmJH.GZC5r79`V#N6rk!T%c5@Z+MHCi1.HXD.3032a+CA=8^aG]ADjrbLc><B]AU>cP6hGC
+[lq/sUHRC-X2PuI,"Z14a"Lb:qpZL'*I;!3DEAVU#?2GtUZchD3uMFNfA\&?MjAD&G&6Fqa
Z(0_*PEp."#]A1=50NP&d"RM*$8hUq[g6h@?W1Ug4a>-]A)IB(8e23e%@n7g4<uLH]AYIU([9pU
hFL*9e1q`_R3,8EdH_4%e4ol$Ckq-!rK=K>qd9R(HW5=6C'o2?bQEI<5ks/HaK=>gkaj\-f]A
?!3BK,;aXHm[WY@sXgc%CpBY8$,%d-9rK/p)gl]A^!rrAM3QLCp*F]A&a7HOs_Z[Js[EWW7E#e
;kUaQ.r7JL2lBIUbIhP)+itb*9]AnB(p!nheGeSVlCt'(L*b/<u`"rjq0oX0IaJJ:,7:0BR<8
'C)oKL`s.#;b02O"ks-;4+aDBpE,plkIAS&Yg1O3B2sE"p.[.C\S!40CbTpmLV:.c]Ac%/bD'
/puA_rVCtoSq$[^Rnr?\0i3Y)H4ZY;HpNt+GlEuB@EDmQX"[2r5Ko<4hfS@t:E3Ep&'7gJB=
se7LVN0_U@T8>(Nl;f;:XS;1/U%&gd'I@;IMC2JD7qJG_?:$/8`p.0r"LYr$lBOTD8h/VNLg
N'&OQ?0("mSOs/C'VA>>NF$4gU'q?ps5kP@ku.HJ=e?5*4)nnag3=#,Jk"8a0=o:0%Xm$fF4
9s%U^qZ*^iGRX:[nZsP=lJpG_nIM9n>3a\4ahK^6Hfg/sUF?$k@hnp;qXL72Uedj`HF,oZMo
5%-A3KVXgp$$7.cgJN^JmEUoCqf9kCUn=/^ID4YI%h2TbA7YWfuiS&C5's62e<S*$_D?&E67
@77$>8`II%<-QpPHBEf)2RY7T&mO#ZPb)WQh]AgW5'So"Z7kZ_djIjHG1o25j`Ln3ncX9hG%#
?ukhOj%o29u87/+t!lKXY9k$mGL:,#;kg^/Bc).@N^;lS`;==+Rg2j@hB)E@Y*g?i8/GLC-(
JKK]Ae&DH/V&)%t=T50prag$XMo)=>hb,%Ds6Q)c1GSeP@GK/d4;Q#]A?u)cVMSq[WSIog.9h!
j6u\eFg!d.F"s(?$@<:.kWC1Fe=qjKmhr)@Y<`d5CO=(dQ)66C]A/%@0n,Z9[>Bk/?6aos[#*
&.U\tI!!85-O772!0M*.8P;"aaEhPk&9OQ?3e3T_C5abtEItX8!hZVtcE]AN28La3.ekO`Qg,
s!fH]A\9IJ3:eUIRn31AX7F#"MO+5IFkZF`l8&-^NJSMkBL)i$eEpVUT,9_^jFQqXA#20V'aF
jk($5lBWIf/@%)Z*ah_V>A.mC(Bq=Bsn(O:[mpFWk&UY>XZ[rH%[U5Un._9Oo$""?*<r"cP\
,$7qC8__>JBY$XqkKD.e,1J`l2Y0meE*,dH$=]A)*:]A.?E>)SMoA"[-b9%ab6#+8\*.p/[uQ.
l'*Zt_QK=Eh4KaIiD#YaXn6=WL/"fV4uGsU3$*/_.E@>Pq::N-HQI,]A2ksjIIh[&@f-7:&/l
WSE!0L:hV$r1QH4MCPl#/'5Ab7GU=\p4R&cfP-EoQ]AVgM:e&;#B[8$>L'V-R86Tl/6fP4Rt:
e"T[L10I.4J!5mc$mduqg`4N:1,:VOG4KsVX&_)G.(A`j\YX%79SO:'r$to<u.V?,/"[)an?
`-*W$V8V=CTkVS=Of(dE[fW84R0Q+qsXogfI0OV%PV/[?C7pe`FVM*PGd"H]AN6DT,!i,^iLi
Ms58k`Q[M0MO.t$UMrK_crqd!f,abHV+YPea3(_X`iQ'@Z/5QXR(o\K>ulN-[^MHnk`+W/qX
NmAaM3n6MK;0;*PY.4\/"I;Kb'V^ejEKM7oZU%0UU\A5;FPCCZ\(@tX7hsofD0t!C<P'56F3
L;lmLk;_qD<I&/5OVecYG+B34ZW_\!pK*+.;,@rC;@ibWOXleD#:MV)I-CgGc8Qoj+c'TbQA
F2TD1!-EBf2:E#kC;%KnIR2@?@rD=sd-EQ7*khNBO9e>=W!,e8AW&*H@WRZ8?8JhOI^)'o,*
b[M3GZ!G@aDmX#))l0qb+DTu*PHY9aru-6J:cqVYMTlPpfrL`>]A';!]Ak0%O(*Al8E0Y?mmUE
:Z%WT(#s)au99>[FXH)U2RkkE[ih(.(3<QnhMdG\b-''+-==J=Dqq=`dt/`iJ[#,@A7mAXEB
\M)sr5^Db]AAL`0S7I.96]A#X)05t-8\[&NasWpF!?WcnGa@Zb:dg4/=+,9jt<EBl:C-+sb1Hk
)ZjEnu45ER/Q0cuKR6DR$A>Ch#?UE@uJ?mH&=K8I\0;-lK@o,u/`o+%_&'B0:1;_kM7L>u=!
BP:(?;[gh(kDK0#@?1!"e-*FKn),a'qPB/3;"]AJN4VN7<U<)=fM*]Ah3")(e"N1i'jDLG"%VR
QBVN+24&$s'.=@hm"QK/<`"UZL:9WoC=V!$_oqSLnErD@%dgE=-ql1644NYLtP!-^9pL[Lu)
bLQV+Y`Yg1a2ZV'Y]A%t<tp+#Sm+VabL+Bd5\pBj;`^D64+mj@5Wbeo9:\)eNtR![>)rQ;o`l
o2L!EgHhY!I0\<E_C(Ngcl\k3j&6$QMkurODp]A(IT6bHZVc7[#oZ!e-GroTGY8<$d.itV@QU
,_aL,+b!$9HjeS6l+5FdaFt1,V]A"/Qq_nn7gmVqYU="8U>VJ\m2`hem8Dh0`I&YQuGUKO`Zo
1@l*T9l'j30A>.QDZT$&+QaScSFqeRJE5i_4pSu@6R-lRXW4:\7,C8;bZJQFihHmA(Bqb`6#
@HWU.GQ<@;g05_"i=#$"i<Q"hi4lRY!S<ks.%l%M5Z+C=^V>=#=TiG=V[L&YtMpSP@6oXL6!
Mob9DBD"2B5[G\0b48=4O?nQYr^UaW@jDcQb"<C3[SF4aaX3*e+CBZ]Aah2B1n,0/:UtOF$4O
,?F_3rR!acGLm(!Wf,u")&d044o]A>(7abIJf9sGj9q/D[lO*Z2U)Rr(C"J47KS,TER-1:O/K
dj1l:'Q#Zm[>uD30]A(?^16n`e.q]AePReEk/`?9nD2j!"NH@2?H1JGrUPs7&H([%qg)!3e46X
T)=sI[c:B$iCsoi[C_?<fY4Z7_'^JqXoZFi3F^/DF>$>Chbj)q#^A#UaJ0HsM#m21]AA;.b3!
U<o0nV,mBA,iZ0Q&i#d(emEhB%6Su!6jO(]A7-Z,bfGnP9GTfn_]AiAEA[HXRaVdI<P5f.dSN5
5Fqt*\]Al5)?Dl;-;"?Q/#'M<hVG[]AaRsB`%/tJ2!Y3n.kMr^%5SPI8$%_`QB#B,"AlN2<s4@
VArW-+-BHeY`N%Rf\lp:Sl["T'SVrk`&V*3lsb0lM^ZL,&pk(19mssmB7oI"AP]Ae<2Etd/i!
&;MbGhs0E)`@5*6`S&Nkiu;R*4R(aG5IoLIN9p[nC%U#9kaOjOs#_\kc"bqp5#3MH%e$cP6?
o0)Y*=(KSZk7F;Yms"lCE.q'ou`QM#N$,Db4Ht7s@L-`P8/>2L'>1k[AO9\gmI1c!_%CQ\U!
Ydo@"BsOWedk(&/FtUPpFViEA@$ZrANakU<5[*G*M>OLOa>aWs02%E@8Ut!q_0094U=Rd81Q
POK[Lth6O5)G6\BJ>8.CR>cle=DF=RcnFE\3<dbXE1F.RF_Ic'n2k(5h[ZhIZ#?MD%_hD9M<
Op;CGQul@/P?)Eri4Ej.>nAGr/%)"pb*cM2"JfJ_$'/]A:F6?En;QnJk7jPl7W5[GB<TBl'Ba
LKV;qY+0U3u5Q(Ek)hN[(u!`Gb\iCB/iGD%T>r67g#eq[5HKRGnGp>gJaDC0Y5BW?2]A+2=TB
FE%C)5ALY;QopTiU+RnMq:41\UBo"EeABB(9E;qp*YjR,A<l33O(S*<P;pDX-L<j`rB6,;N/
AAbu`l3>HgM3(((2;E6qPhs5&(:dh69@A8$ttejk'kZPg<,./]AuST:<+qsI0B^Dd'KE/!s!Q
p.V72[9<Z,m[aPhI)r<BEM4./tU7nHgi!/V,XH5G[.$*ZFMV]A,lnV8K@t!+7-j8%`d]A3\T)+
CuW"qE@G_O%^qTNqDQ=8GVCPJX:XMFi0<Z@S]AF:Fn&kE@Iq!j,FuZ<WkXeRVF*Ysh]Am")Q-+
-?>`ZU.+Nb-jsZ0'L4aX1>d:T+SQrgcT0Q8YoX&,:T+0rBE@VkqE*JjZ?A@<';b'm1\C[ZdB
VWs<W/@Zn$(>dJ9%:M,EYQGOK(e)eIiCjjSd'50>A6;>q.@KZ<Bs,#]AlPZ3:`lU[iOMC=PtM
ZpC*8l\k+Bnu5G*KQah[fA@WnEV>Ph2C;O<IX]AeHLuB4k-dG`<45+5biqX?lRehdj2K%o!d"
Bi'rj`UIN!VkWC"_!Zm?!:nYIaJTFj=&*KDQH7W;h0=eSd\L)SpoH8YT8N936tm`2IG%aD)]A
YHppl%YQDS@8+?+afd=u\t"EB6OY%nX'IDdYOOd(_dI:ToURE.-j*2iV3b6tNQb\PrcJ3H%"
(<e/IUa-b6'p<r'2*p7L48XY3o2]AS"k=ZbV]A8"Ve:&V&)umN5]AXq+Zn]AP;QaG.\A`'!VP]AM;
lMCs(2gbo8NBq`<4M!(Hq=g4?#i21QtV4C4[m1NQq=9a[-5iULSaLU<uphL=8R@YdS5?L47L
[U:7Q\WoTS6m<L97/L+m:&Xp`(rUr98:J]ABiatZbkAko'E!n<Y#d+fe3S\H5A-IsoGU'tr`]A
)1-ub:&cP;>=Cok_IjP)<1-C9K+-p>;6hbkPd5"H9u(rf%t1!:3fH4W=g9oGL,l_n_s]A3qa"
S("?J/MgNok;6`i-`d21+7C>!iERKGZ2BiJe9e-]A)A41l#p,5SM[ThZ:0bW,Tu&1<481dZq7
@I;^^fRQ:OA@gp)btTU-_k'6Q`V>U$62![KT14mUGc>=&Xp)6DDAmgXd`gbf[a/J:XdKTm3q
f/sZ`Z,uK38ajNlaVUHR-[F*7,_i`?)O)cA"L$9o:j=H=!fEo@rL^`PRDD;inCp@B;!fChMI
X(!,irel%[K''9QL.aPngon=A'n@>;K<bjUh56sh??kl6/UtMOnCgPlc.*W%E%lENK;>V^^Z
mp!KRO01:qseB?!h\B[u[@">l(@809F3oqS0]A#.0^.o"X`0dl6+l+^t8\H6<8]A=EXIkCMg4a
#7]AXbK>/U`So;1s/9,lgE-n5h5`kX*:XV66r:^`XM.lKu<#neBZ\J!gR>Kp^g3B:kX*1pD59
d8BK;5(4$@SH4Q$rD;h(,eE+QAUU(uo$KR7cG@_Y7iIoI0\:,RYAR'fJaqP)l@UAk(h"h(]Af
O;W,Th_]A<jIWR$-=dT32"X0sr6.`HV7K`BND!n3QbEne#u/Ed2YG5MuNKO5:V)YVH,,`*5"S
"nae9d.P5cQg:^]AtW"6o8,Lbn^tG(gTlh4r-=gPXoQmVCk]A_sV'@M-K]AdWj;0,aGMNrmI-Z+
!8?uA;%\[$:CpM%W]AB1Dh3UpXA+j/3t/B72>K/@p9_@0%i6WG3M9K[Z#6Zpe9JPX++^J5eK5
T!(.0:J,$U)MQ(QZJ*MkBqe2'B1>t\'J9Bl%@ld^-s"c'>$c%:d">EchrX`&:/=d@Xhan%EN
8@*mcSgO-ABGc=MHok0/Q`3BAQ]Al9t8.5Z@%[;$DY\ojjP^20&]AaPE7_?7J(ciK\6C]A1rW.f
!bma5c&(`77aIa#-)(<KEU8=0.N5Q+c(\ALF:9+)#<(J6\#b2?5"T-^ZP/;$sl:jGE+%YsV&
`&ac$(q6,TYi/=_a"j;JhNf?qshL8q8l*lE<U6G?FL<J=)DON\Fmh(mI1[&?i9s;#.XK%&b@
a'gnfEZ2%BMG$]AX:IQrXneR0kDh;qQ[%R^Hd+O&q8P2Xrns<&4mT=<*iN#!QpoBa(ndGn-I;
/c7H"@OL(hJ'qaJ]An=?2n9<&s#*!5:>lrbe#/DTMQj]A=2e>0Cu2dq&#+dl[S@An?G3-so&?;
NQ#*@Pp:]ADEjN2+gT>Bu*?0pQYAH=E.(K*0$&7?J4Rk90DTHr)((*bf?Y<`92E!AlP*4rfGk
J(@mkV%+V"!!^]AYuQ[3]A#AbAI<h>8PMk).>lB3ij1<!j`Tk/N,):c;e0"RRO(S-X:+G@`#`A
.pVpOe%Fom\GHaal='V"WQ=T/9'Z-\K<JkJ')XnINV-%MZ_B<7*MVkB`sQnIa(9KFIUfF8.;
oGGu"rW7>#Ee)qJ/G5NMAl$_b)k2&Q7+&;5o[85:<!ME/kSTDh4A_rkJW`O>V9K5D[@r(VP#
UWuEt_9mjY'n?r-k,.D(GWEdo(Y_dV\T(mP0Q8@6'\oW:#FkF9h>d17;VqD-7C1af'=mBo.?
jb/?FXOKqm@"k?[B0sG<38V78sX1@C>]Ad7S"Z:blH8qbeQ'+lo8%FAZ,;/"SS9MG.8QE*9:7
XFsqfqfYGhRcd$JO/6EBpCl$$[K17.pCqm=gb#Nr(M.ib1nhaKr&)&f%<7&k`,Rm]AalCn[/C
??1?]Am2D$p6%14XB4Kdi.&Y$:J*364@^JLn-F$hST!Cc4G.OC]AZP_P0d@E%<H`S8Japu,#5Z
Q8-/j[i2b;<?\JLm4++gVh=ka&B"a-YG`nua::N@V*5%JAs,qOF*$E5AE?0;`jAi=q^AB&K`
N2Q\Uo&:86*)JYO%"X:@Gk/cT<9=4;4!K2M-I36n$IIn3N(4^q8&:K+6TV'uU7Kl<h_@h4p+
Dt*kNcSkaLY[`AB\A(%jaP-d.:fUD:c'[FPqZj(.Iibg!=`3@2edrG$?SL6=D6Yfm)^(B2$u
jgE]ABN'3'o<r-\+ERIbUNa1M$="oom#KDFN+ZSk=mDEi?dqEFXFb>ergb!\6>.0mYM0?6pAg
e%H+Sl&dI%?_gd4SMAdE\J5ms#;$V'tTI,qWbO(4DbJdpS=G\lA>Y\$A-Bm"'H8X*]Aa3RPs^
:RGW^+a@C5*FNMp[4Hekg8fi^H4*n<S4YGcAQnm`!n#U@sqa`Pp'aW;?i!-pR#8?\8-^R9dD
_h"ArpS.Co=P"BsJu"F<jr>`)O3o)6GY$I^HE@ct+0qN#;.to5%G=o'oY]A6UQ8g,M?\1'2O<
>YXZ]A%[+gBT8JlY$<BqcomFadL0c[[F;!BqI!.lfI8p4'/mBL!l'!.i#r5FH<Aq-k8W"&;0)
)4l13n6.'>839&g&!ad2m/D<;!f(.kpQ`33AB!\6<Xh)rqrWP:*m8sXq>u9hu3V$8)WGgTOs
'0\Gm5UaHqPA,>jB^S#94[fOB&2UiO5g@Hi)TZi=`_TUQM;g(_brLg"ST7!>oS)q3V)u_mo1
eeEH0lSKqiJ;.Us6+K>K64dkn]Au\2&#sO7oh!ld,ht1T7P#BRdO2nBlO9\q9_Gn,)QEP,sib
JaJCPBdG3#o$L:1eF%9%At=%NWZ7G.J`b't4FofF9HT';j*WPSU(D>*JddKPDH\UP'Br9,bX
Dd1+[J:g]A.M^FHA!`k@KZOjJqQ*)WgVNN8$-<S5%@r[@V:VX#W=$%ffn[bT%m;GBABi1&1pU
b#aUp`QBC!\+;!kW1GKiaWD,-Tp*ZJp#p<3+DAs6hnj6c7g9emUlJ0VRoIKrIr]Ac(..2i;uD
*jiC1JA3a6;B`Y9[oFeFl0.F@1nULZ`Ie!+h4NZ-`Yeh$GW!G6$7@4\4Xoo9T!#fE0*`HB8R
k#EU$BT(L9"L1;N.V"YT3g<'IbcpGS0lY="UfCrtr]A;pA)c;uM"u%ggEr>u@d9Y4N[qLWr-P
018&eO)o8J;@@/$A+]Aqb$e)D:4eJE30decH($p()*\]ADLlO*'Q:Bo$Fdp%]A<[@ngS@At=$Y,
BuP5<\ltFL4ksU:F3O;mk4'H]AR%JVGkNeV!<#j!I4YrT5\]AD/(^G*Ln/l)##M4,-af23RJO7
W[jG66a's@i9VpW*g7/;=\HPdb^sJ;)XI*77`q>l5VMf]Ar00\cjKTurW;16U#q0<f:TVI,G>
f?lD]A,U<b+%8lu[9Lt>2U7La\ndW0*(aroK=dk>0u9/D,s#4RgTN0Q#@)0tnIPg7FtX]AknZ&
0;-e)Dr-F!1fC<H?[*mNkO%H"XN2;n(ojn,m&c]Abl$'9lX%/\%4t))0JQ,9G,H]Au8+Ubh9^I
bWH^iKhFkl(.+:c[%AU4Uflju8AaFl8.Qj@/-bNN@"^%%86j-7[j+6s0njjR!\[oW"`-?%_C
ZmG(:V/<pr'd=,ar@.qIoePCed^&?5<8YX"$O[G^(D5fnG3RjH4_6p<Fl3B`%8t_F*QJGuLT
d4B'fe:8[[G);A6CN&tB(^*i6C;r?nkptoXXf,S;,D#cU@p]A#;/3n00C\Q["1T1T#A_b[*g(
5YTXGWo"cB=%)aCBJ,8KaqD7og8h$5YHRfI%hPfq:A&cZL&E.27XKGhRBpm5*Qn>h(Kh."Ve
d=5Ii(mbmI\4NLRWt#Br^lbM.PY-X>hJ')8mL4J(rH9X%5<Liaef=JmjpQ]A[9c^N]A+kU@$^D
R\He5R/CWKHIkmY!JD_SoTg^(G0sV60[n=M82\V7D&`9ocu.gnKkgiJ$VP>L[lCN$Q=t?XC^
nn'N.d#H:ad$3!t[p9m:)W_C/P((06*TS.ug-X3R^5I(n[ZlI@l7gL@H5!^NHKcZ4MMV<JA#
\MLn>AC1/-An3Puda\#qXpG3MH4,(p6(rSYffc`r2*Ja>;q%$67R7X<%CIM&dEOF#a;8kBUM
`tm!o!J8U^":1hO_ne;je9-#Eb>XTGMf;/h.(QKFsWIeBST#E;FBdBT_bsnJ5=9jnrDq*^UK
\VQ"9@\",XPo_1.o=?ESAbrf0aNh$>AW7u<*MHG8G>NDHML-f/gerZ0dLHo?\ngC.?e^8r]A,
QRU#Xg2rh9Fm<!mQ]AV$-LO6q#)eCN3H>VcfUmS6-rg0sKhp74oQ*$/a(1]APr7HpsS<r<HV\O
8DKo[(2lgR\3.k)'R7h'?,sAGQQtXl'g5A25*!6O]A&U)0Q%Q5H,fK:/^E.VicL3&d0PoC(\7
pZ)+;LU%eJsg/1al<4V%4\D%4cZ?`&,jTFF9]A;tuf`#e12`GZbA#\nC_!PXih=0OH3VitP?W
o*-#5JYl<JeQ"o[c4ZF71D)2MouVj'Tc;"!!j00^E/jbLt^]A59"Ec^\M>U=8@P,O<Wu=/mZ-
..apWMVhqt9W)d.!G/BYAlIk\UXqcKgQRW,3GXA^a+q_YS9putZ&Ve>(h"!\l<8u$I/cQrP(
XmQg+cXIJ@FVbts]A#`++-%T%ul8n7Xe_a!nXbhQ#n&YEEr:jLQ5WG<<AT>K>$s9V2mNd-Mj7
KEo:1#/DdqA[Q)"gX+,8*PR=)hb069/[j=@-]AIZ(o./5tW08M=1.1@Sq7Hg5oS4r2\sYab>f
:,]A<&i39<bqUCW&j2g'jK!m=W:$58HFWV_iR2p,Iu.,&t-dDJt<TnRo_3HUQO]Au]A&e.t*t'Y
JUubhnJbP!^?!o73R.]AeOS2[q*WuaAM%$13SjCZKH/iA#<;W1[u6l#5.%BaCuY-Gj2\%T5j"
@F9S>FjG>!s81^Komj;A8OQ3FWnV&"1$$PdO)$Mkl`:B(@;`*@jc<)iMKQ.c-=Fs>boBUjJ"
OJgekg]AW_ZouW/iNJeH16^Qdr4RYs(Zr8'10CHs$#)S2La"k\`G\NnU>ZtWshK"k/O`/A+0>
u+iA@>"F`f#J=SP\C3m<GYkOI>2\<K&4H4XW-u54.L"I2g*C^;2PD"u^k-i`3Qg8t>3G'@nQ
L^0qIK4RG-S1nn@tHdn3ijZSOC1]A@a@A8C7*0`F\bL)Q0eoZ_O-SHTa^!LN6KeR^K*hcJ;bo
-(HMla_^EL0U`&h>&6FR/%[W3c^)sG9nQK<8BuO!kJqcUH+ZFfOl_p\AQkK0@q%7@TFAKl7.
1V`WJ=l('_IHQ1A@Rbp_ppj-HJM]A#Yp8EOuTIS-[o8iZ4?4,2cCjNV&lW"lDV$e!s!rhX_O#
iY4tsGVk4C(Fc*,c7l5D[Nn#+&JSE4AJQ*G>o9Nh_f$$[30<'V+)3+]A^>RJZ(Qh8=UU``u7I
NJ!IQBI`KH-%C48iqVVJt!C-rm9F8ENj80TJF)#.lR0DdO&iCH_b%U4)&5UE_+d_1$aNMJJI
#heYrk7P:oRd7Sj?8)?/FDKjTj91&NIqi(<?phW@e,"*ZDJA.8)0Ke?ai3f$(22p03mJM6pe
>HrNj$B*AY/j"!V@@]AJG_1G,"HJNi$mZ>b07G%PLbP=IZf5=M[3YFfDD@gidm7c?X-,5!5pB
2\OIS"d,N/uIkL7?B='nJ9Cg2qq;X+c=$"f#dr^n.bnN4;XVcf\</</8q!O(M$.27\[In[%N
\V(%a2!>s8>daB]AoC4$JS:7bIn6MVn5;ch3?ZO"CYK)ZV;$Y_X,\@6U(&<+Fp5:FSSO:et^b
)ZqZ0N#DN,e=JO-84=M(cY3oC>6+a:mr"R99W3!AH&h;CjFEaH_'p,go3rE^X(-C]A6qI[cqW
'XZBOP+-)d*j%XspU33(V'Kc?^6MAaK-Q:0"fDF(cJeqLX+Y!jYA)'GR[hLo\PL",u@s3TSc
4&S'o%gm]Ag]AV7P,%YpjM0Kd5n[2B#a(L68.e.=uh@&N(M=VUl[tH3qM+f<OoduE4aq]AUU"$'
/HL67Xbnb\]A9!M_&&&"W#71$bW0*i)k]APaH(rrK+o*#Y)c7L.mqV5?YY8nC[M`A!^/jpHE8Z
k`iBTff7HRJ0^n/4E>!#m1L_:R!G_gM>A4_hgO+sbJcDAlXb^Pg-Nkd@hu.[R^V\d#\be?hI
>QriFPi-L1Z-r2p.nt@1@#*r,`6`pqJsi"cRG1@2-V0FqE')d6oUc;lJLq(NdO_n%RFN$`Qk
5r\<(+%m"$R!Q$sVk#o,`d>f#(MT8=P=Z[`Ji:FM-O3SqVl9:,QJVLm2<dG5B(c3OrV$t'GP
Q4o26hZ\WRS%f3UBHs=Sld(RSnYt0?U0)DGt.T+"0k^%^rSULq,L/3GN-&<O!+iPnGFH(LI>
I+mA/#fTcpQ,\>[fV-'1N398sdUj3J1d?dhE_TOG<7WuZ$@h0KU-%^`sC\t!QD,FDn?Eo1'1
EA3d;^%I]A586`'UW91&VpgY#mck#jHAZ@4?X9+Y,Ms&Q)<%;CmO2E&+3QdU)?!4,"8_XJ!^k
GeRUn:aE1+q`1V2j^Z\W&$7P2WN"JL'TE#RV&_rWQ35(-Ag4cL@#"q8)Ao)F41$;khbB']ApJ
c\&gIuO1d:!^FZCuJ!Upab>-7Qq:S,UN5"[7;&K6h1kSii03N'u`Bb\2lfgX\.d+\JOVJikd
4Ta=0h1Bj_aEWa4lB)hM[q11.4qq(P(XW!G1^m"^G1,4:C_`A(LiE'Db.Ang,NHFj7pFc\jh
U:1ZC`%S<UqdC\A_>DFHp(FRm'[V>NkoF]A^bp^:?kMq!@bFhd%3Z3)\@N'.eDBoIN/ENB(o7
WajR11Th2;)CGAt*LfPr'do5OS0p&n^KjmiXPoKY#?V_e7Fb3*i.-S-$hqs"4b]A<_HXs>*r/
hJN##lQ8_>EPs)&O/t*mQ[=NFo>qUu?EU'?]A:k4,-#*n9gOY\&aNM9@h#"df).A5L!tQ9Y+&
b4p]AQe=jO_l>7[N._2R3BPE]A=FhDZ5>fb_1[qJfMY]A5Q&sGC/1k7X]A?8*p)mnp@a3en_=1Ml
>7>[o(/08DqYkp0bj+?>agn$ku4l>+2S<h>u=KJB_.:dM))J1b2YJ>@&J&hSt8qGTc^=_!rZ
W!m.)sh8>gAWifH-Sd%4=$QqJF+Q1WN\.YoYF"!nFoJi$)hbD-e&#U%;\LHhPc^[8SLE(Z3.
>=$ko;e7EbOUNGk0ALH:^Z0Kl#<bLG.$4AJm$\T!QLLf]AS/oB@\ad9l$9*.?NHK%S?3S8kH;
r"MFC#QEP45SUKtL?ElqrVED'L++-\?.'V3RI7[;M)2Ar@s63EQ%=WcpiQ=5<oaKIe;/.]A;e
QHa!$F`GWb:Aa^IPJdSZ8d6H4H&=o/Zi6&KSXf`lY2YJM`ZN3!fYCp0o4"KtnOJV('N+D%9L
<e7fb7C._Z$o&>\N1DKI5(3'Pmj4ujI5C9]ATXd.^8o0\&uhoF`See.QTehXT[J'NigV7ZFNV
VHNf#o0CIq^$7l<-B5_(8s1E#Im6'iuf)oTOm)^5*s-Eg;B=4(\^;-8X:JQE87?GIfrDK7Vs
&<?8B@e#TL@EP_k%F$E^:$!X(0844GY$@II_@etHcI`?ohNOd`ms21r.X#c^=mb`'5D;K!_V
SjS:EZEDC,t;ul^0Zb^kt-7Z-f]AWX*55SJ069KW<Rf4-@PUbLX1Vh1g;n.IJe?Bg8XCl=+:2
7hokI*Kftt%Je)i=(#+eFG:&>HH<daV]AQ5HHRgBp4^GJE>C`GN)FkQ4m%>6]Anq$p->$`fD*F
U_:)+.),^V$9U@I.rj\]A2nrsgk:!_M.41\m3OWQi[gBGQUBmnVQJ*R\)MsaOodD3Xc=]A>m7B
FhQdsA`,W@k+0-`mY?dH_=$?q81*)OjK5!2iL\6'0u]A>.WI(\F5!>JOW,OcXkb<Cm21Fo(tk
@0UJ#L6"q:4fBM)UmSqf&:1hp[%<78a<-33`/:pKoE9lk0j^bd*'96%O4W&/s%8gi$m[:#4<
t%QSnV2de5?bHq7_?#H@;8&/oY4'CTr)A+*Fi)'1)PaTSu+N;.<2u2$PbkP$dpjGkg/CB!5N
.lQp7,;a,6/M)%Y7<2e*9)k@^"#WKFP?rXG\qqA5]Aehrt"=HDDc?e$,XM&u%,HqQZn&JKJ9d
u%stYHu2Xe<`r--Gum>cTA<cg(P@4),/aA-2RsW9d'oC#b[rX]A!DRPZTB6CDd/<!Jbg4AC\_
Z8,1Hp!)@Jt*r`.N-DCN"]AD7a#OYIU+ra@TG0H?P&/[Dc>7^^\o5&a8m_/+0RUSoW>iJLtoF
FVh_Yg)PJ#47>VJmhsJ=L[]AN:jA[!d^PVuFKRo$$FgiC1j*hZ),4MRZSH1i0ObB\rS(71#Ch
:QI]A'*6?\6i.pApQ#@Hf4&(#raILKKOY=Tgn@VpljUUeoM'L$K&]A@,Yj&:)*UrS2/WaMbAXl
lU_NhuXqp3pWW2oo$Kn)8+qg4DVhBhn)$d;Ok4I7M6V]A]A4W0DC"7!:Bk?@%G)<qRp9;rMN[T
[+mM[C;nFonYm,CT\Qqf^\-Y$"LFjm&>F);$A3MSRtW4J-.^>+sH)uX!6Y@]Au,sO8g&k+J7O
Q'A<PWs5oW@DFtiqu(l-soVdN_ulIJd4$d^P:;$Kt@P'fW#F:-p$Y%h]A7"-:I$/SL:62i8I1
/#8m7>UlT_8ERZLeZ#NTkgf9R,Afq&ggH.a=6)\H+^WqS2iunM(Ac]A3i56&B]A'he7T"lKuY(
_ME@*RX[?Ej)lDJW7SQJR7h5bckV7%HIl$ScrD[K=^QC_7Q"!D1q>s'MRaJFfN!*\V?/81EG
!jPC';b$ZB.)T]AR%g$<;srIt[<UFLgS4sLRgrrh?lWrnd#D_6>.F]A#^'mDO_GQGUp[6pB#PQ
Cohb1nG,)5Yuae><bg7hoW&Kg>)SH+#-Lb<LXo0\mdbV(\;"&I(TPV/=\.m%-_PR]A^o[dVk5
c+Ci,N7Z(@eCF:>!12gd>*m&2ZfPaJREp0?<03Sj??[c\8,T/$.heP.=p/mRX0L^d2J$sN(+
$l7QABrgUH?eVt6FZtB;0fJ1%S>Oq;.5W=K)joN+XUUpr2#]A>GdCreFp8YNM/j!cC7ui82TK
:3j_@hI-15[8,g96g:hlq)O5=_>:FZo!4]AKAcF7"T.Z+7ci-i\%mg\31W'N'D)^i,oqtE8n9
!U@t#%eaAc*]A`F9>2D?<s?E`%[iB/=lc6sI3-)nMk?56Vs:;UlsG@DRWLdk@/3']Af<N7bu&=
lZX9eR9=+=lnc/f'geRXB135GKA<rcae/*pV;g6"HS+4`chpKU,=2+Kk?>O1sR*A2c$.%il\
%s\U:E<((QPaE?DgQd/Pg:6JI?2j;CM.PZ`Q0WVGT!kP$jBXtATKQGYk#_g/^-cY"a\9']A]A"
06OqW[]AO0ZXP`H#FSWQe6e8ZbqPm:(<&R=QpCftIc&SH_(iC;knII#STIaoo&#!+<Wq/'`(W
Y#X5IJ9*r2Zmpgr^GQ@J?O?@@!\]AE&YMF7)%tlUNpLlI<7d/[@[)P_5+rIUIX3K9h\0\>Gj%
"gR61_1[eZX)G"oSeD8m_(0a6F00]AbsAQ<t'nrYjUeBd(*2Jd(D6gJ?Kg;`/22p2khX5i5>T
8#KQ[;.-*Yj5m]A?0q\a;q$b-[&E/XKn/2d%0&U[8%Y)F#9-.L%4#Sd@u9U.H9&@!DC'-,Y1n
<tCP:Dg*"A$Zo1eUh"5@n'0k#F<-tG?PZZqY14/J;!J`tJ/r!!-@oT,oVp&LA%jn737$WUas
6B]AbDi?CH=!l]AJbn5EU)Oo9t_im[k;j4OoTbKoqheHNq.P,4@G46"XQ'=Rp_n@(6*i,N0kV)
*%,7`X7R#U&@JM^mFIP@Nr,8HLQuk"1>R"fjfY>@h(Q>gf*:iNnYsG.<phIDkQ:Bi>(\R*fd
j_d>i.HgeXNAgggXB"0.78PSA)]Ak*Ve@uY4IJ5=*YhYS(8,0*-j6/I$VHQqma?N$)MZO4mhU
?5?d#;5C^MB':X&0$kt!Z;FcFJMZ:LaQD.`:1PU#jWK<5tu"l+=d&2cN9k1+s\d[V\9[H,=2
K']A:*6#.2PI@)JO.k)K`t%o"U4Tao1J-au_$6(1.63Gji'e+i8mbeiXN,I\?8A`5'Ag'T*+D
@2[`&A[)t]AIuG_Lc*KWgX*-,WAGF9%VaTHj\=:/iZ1@l]AGL:jJR-p9N%s9uMA:1jWk,iO5/u
?E$SZNo2/7>dd[SE..J"uF4`:/>"M@_L8GZ^qB0ql$jCT-u_Di[<&$p,Vd[a:($bpP?$5CsR
4iR*KbpP]AI\j/F0XV<tQ1`46cDJ%G+TZ9i*4qo]AVjI,F)D9Sa")6?_89SM.O&Ub>VIZL+4^F
Q2a-WpKLnlMLgF'HY_]AB:tBF5rn-N3IAdNY$Z3qG^!.Bkh`7UVn50n(4dg9mm$f*.Be`.Z[F
@%Gu,sb*JdkKRJ'E)s-bTqli.SpV%h:*Wo1TRN+(%>=FA/S:1`U81e#cY0RnM)<]A"1Q!tQfW
aQ=o3GjuO_3.]A5;ZkBljoJHEi5gX3B^BT,f7d@KS:XFe7^:q;Zp;0!&[Ma;HgnDUj=D1/Bk^
Ro7Jn/DffR*NDfm&(K;hWp7rPX;()CP#W)VP.sc;Y^(;^S3uP;6bF<a[;)eL-!gG6raQM57C
2"@/<W^7[(T-NlZ4+Z]A,,&L_0+s$**UA6$Vb!tL#4!o=2Naecd$R/\;,1MEiM'nFR3@\*6`:
qqh[lMH<DWAZCQ!M`WO6'n18]AS<_"r2%1&%:B4H+['X45Xk&Z-%u\LN'B12P\?74I^Ycmf"U
qNL.]APUAc=+e>Q>KJ/'-&`Aj=<Gh'k[G&Vg1$T7*H1E7W2LhfZl.WOk8a8M_if'R2A3p,8uN
DUj5I9/tg6jY>Q4I+"^`<*6,lekJD6@UaQ:?/7Q\$KI(n4K@YI+TR63I32=>Cj)1tDPGWQL1
@XFGb)J:HcKWu[u9<Ac:kscel9cs9h"[0D=&R=)5tpRnsC*c,11#S_Nj=A>W".nGH-j+h5_?
1!"NjU^jQ["Z6NU"Y"`aVXt0bR)KSYk,9[DXB82<%^]AB.V9t4reKb:SeY0;=WHi&2!o1>E6d
#E?Bf^nk#O!f<R`@!FAn(,:p5M`A$^I0^a/bE>kd=$Qm@X7m"%=ch0'6qI27,-s$ofKMIT#^
j(,W?R;qqML8WO8ApR;`#JalA4O;jY(gpOc,Yjb<-i@<dYn.rDhl9HmP<@7WX,PY8t>je[.R
D^r"Q,P/BFJRUUObL`#eElM6>'qI7,3[UbOcUlo"dK7nufXqhdQ?r%"@&`%6[0*R$X\-_QaC
m3SSZ_ZXl:q#`>bRmi0;&rK`h\YfkHP9sTX*kR[aJ_qs%TN:c.?"p/d5$`SBaA*r=JqN?_:(
:i%f:l7t?&eBODn<03m%@5g_qaBAh7B`7bsA`R"mmpK\-h3\cWJNtSjEm/7\0Hi(8T\HP1'D
\jLd,7^Wl[^N209hn=3h+ZD*QLL\hFseqSPTCgj,l@_ZR=32?F9B.AU-E\<.Mq!@,6:5Q!86
NWd366"1jM%,%I35;VAQBS@:8sXn(tG*l^JI:b>;*Cco^O[Dm;$/1ai'GOu@_M3/RL?'rH;"
1`XT1';9EV?\WP5ekMWaLMDW&G>ZR/dA;1B%+JFd0g?EXc>UA9!1,_:PP:4REsIb'ld/2uUX
>`%OWhHCRRifk4:-::@Jm\sMF;A>W@kU]AoP,549nu^Dfd&4=QAr=q[%0(@LaKXBFb4=M03^@
\OIZkg'fY5^/$&faCpmR&mBH,Mf@.m(>`%3,J*Z6R:3U,!q^fZ3>d2A9@SVTZlE)An9WAF+]A
p]AW/>BoHG.LuB[FecgS8Dpfu`]ADf.V0c`Tog]A-ubnnH;%?Bs,*%_eP*.%FKM=\9GM&P`lVX:
3I:D5eU+6tc.7i7;:81[2BC\9Mh/ZKQ:]AN$&CqOW]A@UpX4k4aVnCSd_r@q*`,2H5$k'UEH?U
E%@-KMk`mC5$ScOi;qI+J]ASK;rnjckK7*Qqa`LF_fg`*i-PgF0:I>sfk"":@$X6`o+2%`Ob#
^%@1qkJud8`rqZ<T8ZSJ%I]A@Vm`.K/3.#AN'db<JHO[?'S%[ls"F.5M`Phq>OjHKut[9e^J%
nL"`?KBBchKj5I-ek`QhtS&Zt%(1U\-1fH<GDd]Ak9!]A^\T4I?Ol:2U\Z.J*]A7Da9D7rD>8.Z
J!I251e<+WY^o_gMF5)!@S0rI10\NSd1r?1q,[Q%i/X9k(2\Gm=[V1Q10FT"SJ8`l78lN]AL:
^\iUmeX&9aLJTnEjYO-hI6IuuCB)j8itq\T[dj4Gp6S>^T2h>C;&cOQXWTjJsN&HrZ]AjX)$E
-JQI/q9+CP7n3%LgkX(h<<oWb.?*d`!t"YZ@X6@m#Vs5-r"p5e=u9"##IZ<G'tmqblV0E-H>
>,1^nkUbQf"e1LeR>eera$L^s`qt*@X&983*ub8+[C)K$>X54Z884XZ,,;O-_`LDPX>Y@MN&
>f%/F[6HhA@iNAFL^;uCH->BhneS_6VaL3W4F=74f+0)7Q&?:0'HR%6rq-M68FV#n`4jlk,i
b_EXlqUILFrs?d914m*?KuT@Z[(H&pXL?K52S)"M!B1rKq'lVcY:oa8sT/\Sbh63^uq"AkO/
IV"F:Q@=Sc:Yd@g(;NA'P)*QjqXD.Fb!]A.g:p8!qs['=<S0cZs\=\jo=P1i!oDrYfBafO\u9
V\BC7%24IA,YXBD?PJZ+6<pKu8=$c0\<4[pWjsND$*iL*^Te2kb!:MO^ORlAHKig9)8.&D>p
2IYRF;BVWHqraO_TfFkI^4Kch#D"cWdTPNn);t)@!(oeP<aOY-]AO'-1ReI!t!uG%q+?uj:'X
_.)<p-^!J8+o2dEVF/[P(#r9*j)^6eA@"mA4ffNfUa>CEM]A%7gKgRiq8<?R7mV>"@JB9ge5a
NWj;A^oo6##F63W8U.&MJj16hmZ2jbRJ$%X5"qT]As2LpV<RW)a]A@_O0"<G19?:ra?rJR6Ft5
LA/#roOs*+GbP)X5F%8d#RBFu./0Z0*d?m#L54L/+QZ/2^$BhXh*XC["bq'mm;!co/8)\!$[
Lu+&baC^m_6K/IK,Q1,WTVT2`Jf?U"\5KB-RMIq7ab`8f3MuUOcp5*M7Ekm4hYq4[`K;7#WU
CDX!S#Cn[<GFFj_^q%cN!eT%HjSr3d"TJ33PGNj6N@G>0QrT!@jT[:,R>(#G!W/?ZH&8%Ca[
#^N6(*%%*S(me]A6'V!G4'>*l1`HYmOBUo;NZ2t6tnjASaCb,F!FK*5#DcOg]A^1B*2]AP/5K_m
b71V%`&%:j:m@F[P*<pO=ou*8&\&oKmo.]A_-P1rlh#nWSs0((.HjSN'?"tfTURB'ao0i=Uio
S/Ii"N%1+mpg5A>Je*"N$oPKZQne*31#T@Z/A.cnM>!:iA+-ppO0]Ao7a,V<EZqbeQ;YlIU&&
pQR\rr)\q;o:C,_A:l62*l.T"=CITn0[/a=hDcC8Mgt7^"ZU>FBc\I%c'1062F9kA%um$X.(
)uNJauhK?Uhf1rjkbrW\c+7\+.-dgkbPrct:=>*$Vh2UQq]A?fa,^h>kG\\6(!1b)EN;d>bZ`
!AM+:u"c)i=RTVMaW.E-%ZEt8hT23L<DoP"3'>a+(6MJ^BeWfB,D05n&^>;"4-gj*!(!A=l%
D:@J[V+$bah*kmi,2V@>+#2J)`Rg#5MT,2.cP&eIo%pIp'gKLC3$W\KZ53noCO;b"mmC^Hsu
&ui7$4Gm0;/;q5j7VLQ+D]A8l"HC.h.nHcm,LA(*mhJ?BXfM=mmgK#VsRnO1Wg1hR(j;Mu_q<
_2>+6%dV8IA>Er;^doa'iEbA7Re$ZjPie_b-gRFargtVQWGq+Nk^n8?n]Apst>0o]AKmY!:3@l
\h=e;!A1)jDUWd)I19H%o,=h#q1@fm)Gi<fqo\Og)Zl;B:Ti5rb;Y'/MhlD*i7N[ia,O'T7l
Um%e@ng.Zmp&0$q,'uDGX1T]AH6XoQ1k`eZ",/E>R52llDmj@NO\;/,\YZ-O.SMXXhl5o%T$j
$gIc'P<O#/kks)BRgfVh$H(%%Y>"K6$A2TPd\4AH3hgVo3\,(\`kiM5ki^jg,M$E1/*:&\ct
X`IQ;pZ+*amT7V0O'k%cS[&C+qX4hR?IMI`+2c[2!U$bd&-"CDIJ\5YQ)*%jbZfK1';rDb_*
g#Gnt@'#O3TWk$!pPaaY@mD\3Zq#b.eZtVcXJ;*@#+^%7X1NYW\EC;_:oTj$fg#`+Gn0NsEm
bgZs3YE/S<#N0Y&#$RF\jbJTqCm6CueIQHE+=+kMr-X$FSXBS*LW@"D1'5;GG`cpV6(]AlE"X
&0/H=/'TYpU1*pHj/Z9#7cjl:SeoI^+-I1jkbu!t&p#P.-CgiD'n1NY7\GfCYPKi*ng;r#I\
<(AIn1J*M@m-/FcR0`P1JUZC;R1#uaGMkG2Nl%=.PI@-/8ZDKFgAk-Q+;YS8#<,je02)j=2c
XtXM;WFP(!1o7p$qm>.o*.HJ>_6gi(ku#^@e:S5F.j:\`*XjY1Sn9gU(^n=U-671f:BS;Fpa
OD4[2We]ASYq1+/:f0J^!jQH+.mpVk;6_5ONSo@%qF6C$B6FmsmI@`CgaW=*banB@XmTVHVI=
fanGu)):o,`h2X+[>h+k!]A\'UqP%M_ai^R.N/Y'nrG`1>L=\S'sOLo7YCdjFtp9jSOX<,LiP
`<26EGKDTJ.Bb*O:a9W<MJHQpd;4]AgrGId>m-RFrF(KW&u*='2<)RBK7<8lf_(MESAJQf\_M
B$p(""c:54c2T9poQSiB,bUPQhg11:D04Y&oiF_UlYdU\0G.h`g!a.'X<G?&,Un4fA8hinNR
OCM`f1.IARS%=o:qZUkQE./a@1VIb1pJaEMfi3N)C0_jaZPDHnBAH9BIn;Gmr[%dd@7P4C#;
V?p"HW3G1kc6&p_?YCf90O3HGoN^MFX-q:sS&6-mH.i`t]A0GGY($b:W?]A5LtXL).H\*"YG<q
Z/+kR+,R^HFR'dYi;f/!5WHI[ORp_SK+#,j_L%m&:0UYtCGiomKEl;m1=7fQ_gH>_/6)Vroh
uY#U*nF!D'snpX$eJ"YNe8l,3%!AaduUd-UUO77hfponf)\9Qcum.BWk^UVgN@_@%HSuZ6I+
f)843Ji$WQlmfPEfN3=+Ei,GC>GEG,rV1dI,OU-\C8F&irJ5ArVWDda&D"mhA9`b1X"YOW_\
osid&PII6"$.;S.3N]Ah)$4N3ng`h3g12(g&dFN$@&iak\.T4,Q7P2PVJ+o6Jii@u\7?RX5@<
r'PP*2JuT]A\Z=V)gG@]Ae6sRX+`t#sEj.=g]AHBA'M9qf#j_XOrSmk6co(K0bo;=u>gIFi!CLX
_*GnL[H]A>p8=a-!d9!S8NdT'Q*NMrFW!la6:FD6m]AM@#-O"a+3fYOl:Uj+mDkF8j%UoQ:!N(
GaHF/XR@]AXR@7h%E)YfI)LiU8r2[`6\kaLN"+q%"e$SgU6"Z$s^N!N'q:H!`+]AL29=+e1*T0
mV8%jJ(/r1,l#,lGa$=Tuk!++:[eH+1CRnFQUb*#Z.>%W\ZAud??-=.f0=eB+27U\KD8CZA<
J.4Puc,YpLKa9qMp,%HUngJ8tQtV?1Q(Ur.Y@GA11(ck/3nq+d*AL0k<;s)es20QjHhr?*2#
`YDoa[h"7'egf!0^a#GrbIO*3')X1ei!Mu!j=783kP:H$P>D+d#*d^^a2?q04q@TK#')W(O6
*4$#EBhE4JWX+f<j9i_]A2NKNPAX+P7k?q\`XW$C<O9Q_VU?7R6?u#@fDNk=q*[\@8FtUhUjd
DX.3Y&mP+5550KN]AOh9a]A]A<onQqbj21qpaN(U5"Tfd@-bgM!F5G`5+Eujb5G:`/"^W0/HtXJ
0dXuYd*bXSUOS=<5t.nA4.,_SQA3)6T+Y*n@JZRjkBIcD2qi44q.eorTLtA3OY?6eA_JInh`
3s+d8\o<Je/Nh_12+(FkR^X]AB-L6<^O@eQSU;[*RL?f4%Em@]AlG)$V<&5&p7ifl:dGT^n&]Aa
HG"IuhGp!;]AR+#bV2VV`)rdT4+=NjqjC]A2DH2ed:VU(lq.7/bPQN63J2eLtTZ'o>e-4[G"Yd
sTd3DE2V]AYol.-NjYUB1*?5!n-J^3<m+[E$PXV'N?XHZSi$[ZKl?i'sPl/,S/)2A[+nA`PUc
@6e?udO`;2e'R!B=2hm,W_':D6b&Sj%k`Us\=^uh2[!/>[:Mul?I]A[(47-$o[6fDl?G0S(P:
U]AsXO2S-W;bgjY^\BedRDQij<gTreN8OKdf']A9V\]AkF@,srA8Xu@SCC_s6pOCZ`EAjTRHrbb
Ss=smpXC47<Vi@QRppgqm=0"90,^pdY[l<W%"]Aea"tIl33(^Iqgnf@B2dM%3"mhIQ#=e!<lf
R#?%7>,0@mV9m,(S$jA&s)AlSlfUZbE)aJQ\.G(PA[%Z&fd>^1)&^+oVU-sA18/XE(2/f6+o
,V;K8n5LBQSUm0l'*ZNM(I:V8"?1,Y9eaR$Bh9HtV4OE)NXLm6"ohl(kY+rBd&Xc`MINiL)D
LXUiHfB#MU3ZX:TAXD6-f2Rtdt>XT6G_X-c/@sQgZL;)Z=S:lh]A6O%/mg6+_=DNbcKodIcs"
F]A$YOP8L7@aWcu+.e=_QVEpcV/6H@M%VI4*aY.[8_]AtO,+.5J6Zb0[OARc]AqZ.tce^1_Qg5$
pep**(J82S&g`>h[7dS>2@A*T1[(XeL3K+[R6jY$J.[_tS0)K15fo1;kuBrq$RZ5XV[CMrDT
`%*"'HHdl!j4Vu'`G(GDiBOuSBdpsR39??1'eRq$WoZ'VD"_M&HbIhUjm<E.]A4MU^_jhKX:4
2_H+cp*]A`ZSpEkmdSG[S^10qs+'+@C_iLrKRURDer1C4?+D6G$ORBLGt^2:S#(,Hsq_@lM:f
$%MZJQiY;`K.8o38P>RbAOtAHPdbj02qWcGTiX^0U,=AR/:+F8^@Z+S2QUJ>MNff:"/Q,HJ(
M%s=#K1GF449RQM7;1.\**OTqp[h*Dga5lq?lO'O?IpXG&7lMfAFD%L5tR$dYh;Y_jT%?Qei
oFX6[kEdn&8uq$"n)NsY*sh7?f]Ac<:Z,rHK:3,Tb\Kc'grqG4'qCXV/q85*Zf/Ba8b^@fn^q
#Bb(W"p1P=!SrPR,;(J;cOg1^8q1oDrq/JqV#?4((&r9X26j,,_29!MRp]AJ'Q<4r@h:BA^=O
Sek>)0<Ca[)2I`qo9-\U!geoBqa`dX5s6M]AVuEH7##gZTRl`dp$0Kke=21HJ%g/V\3eZgls_
:ok$O"Y,,8@rad>u35s!0WCMhGA[=uKDG2`Jf7;<s9`/UbrPGS11os7opu1N01:8mtf47e:(
M6e/m,FNtSZ!VV=;LlX'$A/k91!.[3,:,4Y38(+W%Uq%C:[s9N]AjH_Y.r(SWPtF7':ud8Hd2
hsf!5P8ZNEt0N!6(H'L#M?=LuA>DRoNW`8_9no1e"$XE$`DcAm"JqK3FRgNd+N#hs.VZ"@h,
%EiGncNtD`@ZMOa1g'9Q(-9ukCK.LD3Mik1P75CX$Lf$9#Ut]AR-DhcH.LkSuMcYnN8UN>%Ri
Po3L,=r;QKm(9a_%s!>b]A^DS'@6#%ZV7AX0\;S3IBpJ)2i4(M.3#B[_YJ_;;^s:3.3"1#fXH
R7'+)]A*]AT)_E"</OPgLa1>hSVDH7AhqB)Y6LP]ABVNS+G^F7O=0JV;Uk.Tt@M[\D,Ms?Z!lL0
@LlA?YA]Am1Os-k+5h<h,RZBC[<&tPcK!JZY+K3p+.lS>%,Aug^H$>^]A]Al.K?_tK)GD5Jh$bp
4Zo*VTh""rhO0V=V,]ARC9<l!?FL4TA#ipR6>+/cc*bG;d5M%1f^soS12.LNQa$inmoF(&W,(
rqg'++)Fo?J<5Ld$LdsRd;ZQ&3%)?K#d517"mV7*X?:)h+2'ngI)$*k*ir0g%<8ugH@uad,)
("+l]A/R=`CF-%]A;#4McMW)OCOY!*eL+!Lr+rM'Jb7?!ij8m)Tf804.aiFmi;A_mI=J-)+dAF
Kh!A0UTj"n-C6)<Ek]Aaq"OWJRtR_B!WZ\NpR!rMHQEd-Y\'aEZ_KTK2:\<nTubj=V-jX/\8I
nYW6VtC.$qZe9<]A!B0.&]AB:q(WR:""6'mOJb(U9J;:i'KHhOUi%A`.g;Cao=rZV@9#aV#]A%C
=-6;l$SJD=u`)PA%7cV!jW(m^o=-YYVoBnHI=jA!_N(l1C[lI5cA_3^D`1rR\`+m-(oB\3+V
BjHG@TGCn)9V8EU"qGSSkF!!9^R0ieD>aR95>4IO_"k#J41umLb+Ce?DCej-SDfB9KkW1cP@
dC/3p_aWlSMK;LXpB_<s]AEQ_WGH-X,To6c,h-oShH$D@<]AafFPi]A-(!cgZLhj0_W/[+42-kf
ro%k??hKbt\H.l#X,^]A+&M:1a!mJ#Wl-4fO<\T?trLWMY=iQDaQB)hA`r]A'XR>7b6[RS7H6J
J/FrQTC-iqEOG2_jTWJ,X10WpFJPA+)3+=&M0k@`$$JRS0^VJAAHrK2>[<pd!:.iI\_s0OQ8
_t.4`Z;9\Mu5d@RX.q3r?1S&59L2biNn>8TLZgFI^0ZT99+LO8tlK\>iC#nuQVfdW*]AlYbX<
1hcL8!)<,Q2u3P"c1-=#;%k6"s6p+=b'b5.O+;I]A84IWGBrVk:kY`bTRkYGgGX0XEq:[h9[6
#=k/^Y`c(=.n)QSNlSk4O3D%>?tE3GD(78r9.Hk?'-draur.U#q&7GT\1_e=-<&Yh?#]ApN)I
e>;'i):`*<ojV0M;a+0b'1Sal=L\&n8;foSO$j1jsM)Ghpn([MhBbJeWV2^Mn5i9p2.N"=\-
R1A6:L8MWLLi2`JtR$qA)T7t%$YE!paAgD\<[PE?Ds5>YMAe?:QiKZ[Z\<oodUpU,0P3g02i
K)&Be`FA$UlE&FI6c[n2#^TJW&Nf8+X+@:GApSpk5*;(MQ`$kA9RW24pKZ\<gG(s^sA$9^^D
_&Xe$Q";"KK(Wg0,"I,n^)igE?qN>o&%jU;Diai&n+@bX_?&nl:X(WGK\Xht)k#j`anJTaZg
4&M+6tP>@&VVb$c]A[uM/!+0TTlu'o((b.F=La+n%+b,oN-+<mQh%p/.)E<<5t):e&CU.H)Yr
-r5i1,*Td%@\@R_XaQ0J<h*Y+u_#G$R<O,()CmeHIp#pYkLWb>^Eqb[UYCgHhl8utBkUa=Zh
_h"7#6!31p2Wa:E,2m=qXUD#,'<80KI6d"[2eh:SKSc1@NI-AY3*[Y5D3*.408kR"rg;`3pX
GsJuit0.:%2W1==u^ZZUU?X7!7.J^/qS4TKWCr/6:U,fmR[BW&^E3[tuSG!mOUN?8(ljo!j?
MmNZ>[DT=_W]A@]AF2rC#40tQ$+00k`n0.BXn($su>s$@lg';\<GG_%SYP4#[4SCQi]A8Z>WK*;
>6D"^+/QoAb-;YsX"))i$Z)CTM`f57YVtE&J;30nY&bbupKB$.[kl\Ek4XmhB+igeu6oX[9;
e:9]A($<1S1>'V4'IK)'A2GR><haB?uMs!Um#<$#j<^rLD+2(#\2-c9j_g$;)O?[bi+nr"mEY
loR>@E/-ggC[PM0=]AT7($quRmgA4e*ek)ILHn"=2W<39rUOI^%#<@^L::ARp`U(\FI`e,B4f
HFbWK/)5&6sLME**NoZ9:@*]AZ2s/Z2aX+p4"1q)Bo%a*aY=FbJVrM/j+=`"nRg;>H*a/As,j
37$#(2&'Z$/.\<a%tB\ZFYKrkWmpLt]Ar-^[AF5m[?QG?F!k8J%@IJht^\f=QHfL!i_fS)Ll[
TVuH_C8e@<]A7h=W=JkhcTXX!B9I"N,HR=H)`RtOFmp)$dt.*KaH9Sgk,\sNqSd@Nd?j:ki&V
fn(j(G>dQ$sL;c3apM&peaN<kjI>]A^r1^?WRa*9=W*S0r4fb@pZS@_H8E1!ke*)-aP$F7"tn
KuFb8Q$3"UUG8F6%Of$Z?XX`"rH#kTr?h%")dRhj'bTp'#fb#*5R["+Wa*2b1:Mao#H'NV1)
)3OFI]AMBB*@bL7Ldl?]AWYXm?/,WaYtZ##IP2qkYLDc*>L*+7hM+qpl,ct)r!ON:GlO)5XN!^
?5CG2aH='7m"CU[rJ@3&Od-#I1.Z+75&c9DV5^_A(6Kuq4-Qn7F7Qqbn5Z=iFfp.We*"J)%l
SBl,WY;;V.,CX11ipm@J!"eT#iA:To'.0_nTs\l'=1jOKj>T]AU>8u01jn>2]AV(sbTruio8IN
25fC:O4I&:G71K@c]A`ct[=NTD;Uqu)1f4%2>+%V.j\<+3XHG\'s.Z<2loa"\Qik>C*_mb<7/
VV$s*8/`2,HmMLXrg.*$ic$#91b$%CJYEu["Rqsj)0>K(lkDPhJFf7a1?8f.PnHXhoabJ_+k
!)lc/j%;*^X(-;$j/P9ls80GEXsSQ9?)V?=#:?_bY!qXWFCHfqPL4[ciiBaB8%"i4/6;A.eo
="6@FYJpmie'pDomGg8%<oc/(=j'`^%s@3[8aHsd^?s.7El5A03VaVe[#FU3=Ti.pS/cb-7l
[7@G<,OIi3:YeEmH1@!^u%[VmN!=\Z*g[,LBaJEf\Gkc?8F=ICCit(\K:M`7VXQjHTrU)t`u
7DKrtb/gk^HGKIY-CY*8k@J,QI%q)h8='qPe%7[YsGT#<N&7fI;qc9ka.AR'*r8V",#t3uMG
:'>lT<ZKG6VP%5ff&PA?+sXG<7`ju!Z1LY^OE%>_K'#^^G=Y-Y,SQ!*YqTal(FEjOY/MbG7.
:N.!VR\#nX[=mp.&,W'L]A_WAM<\hE`I96BNJ*Lc"?ZFEk_%h?UU+f0@aqS=DBJn(BL4c)f$V
T#PC>nONAH7`nR"ghX4dSP+,NS_Rkc=hW;&YehBX_9YO!6Kc'b-GJ'3*%&%%C5bHlZYAg_`6
QE3F56<#%#W3D;!-95MVdDqqda"3LDjk+@kY31ITR)dJpIih:NR))?Q?-aU>R(\mLr=_@uTK
Vhp:R9'AXVc]A]Aji"JJdW+R1qmMjHDZ/RFIC*F!>LGGel$\$[nIf[H45X*t8fIC3;_O@CIr9/
/AL^k+/0>]AG./U5tp6CG4s@?;3M<ah(b+'qifU1nV4rI+ci@Mhog.prYo,rhTN5"]A+!60q"r
lUam$&FpZ9?%BJn>nok#lC1+R0b9L^FS]A/!2/Buu+VP-2Dq7Q';i"Vf;86M]ARbjHosWYS7tB
)E:sEE=$7rOFoZuo@pc)brtC]AOEfG[9A/sr#>7YYOP"l0`j2N?5'kS*5=uWQnX'3g=sA6H0@
nG1\NnEEe$%3]A$qg8n<!Y_;@=GT`GKVY)b&p*#+Ge4P)l.P6dfm3l+gLPeQNI.,37,UcHS.N
s&n1?G[@*"J#h)#tiSR7Tp$2BlY]A%Gg)C[bhD+G\AT"ds^S>o%c/>l?L-M3p:%]AmK,jLO09(
4EbmE6E*$c3[L3cCdkYV9_oL1X=C]AeLR&^kQVgrd&&m;nq(M'",D5R0!"">FN\LbCrn6OON#
+i:I!!TN2'*0=$s^kQZ#Pog3i_$BDnp`M3gO8E>%*SBTrC@\4%h-!>kcCreFsLYdtCQAX;#L
5JJsBFY6b)b7(QRCA6cs^ZbN[fMW.h69=7@NaQIn1^0gaWr6lrLeiVp!4kRiHtjK_Q^;s=gY
8]Ah=?D/MQTNW/-)#o"9Ir8`8Kf5aB5bFEV]ANS1b$WiSR/Ok>S6gXXmPO^=c1=pSJ&J0;[;[3
3GU/mn<]AJO).BUE>;dhc02tSUTi,nYJ43GRE8NU1IZ6!h#P-+0!NN$obEA'X#2n;aJnfkCO&
%kA0'al*G*Mb!k'K4'!k!7sm3AJW4Y,!n,R\.>EL?C=>7G>tN"hbV<Ig\mb<pMZSOVm-KG#g
<^V*0%.SeiF&k,QB[csf-4m\SuQ"E,q4W)oCmo9@fcDf/?_gQf"*Jc%""FJ^ro.0uV+-bPAU
^?FX)\b&%BXQoHlH0F=dX]A&meg;CL]A0m5IN\]A!p1+%+VNOpIIoVkb5A5Z_<$2UEj7p7\<n^+
rThU7ojtdk2tm#pU:kJ<&/8kJ'D/=^g1pe&d92C-/>FkHeR4&-_!go\Y-/4u-\&-Ia%;W6p4
h.-n/6]AZqf+FkoT+>c)?O:m'l8o0t`He0<=fe_,U/r?LhMaae-<(lp3\f=cBSDqE[d72:5H*
U(G:=i&4LQdW's3(DCC,Dk^k#'C[QWsng;V!?m=bRr.iNq1@H17+Z,'ARBTgu'Gi$k,k>-a/
g]AL16/sf,@ED(uOAk-.ON9MAY"6=.>SKAC)Wu.i2$"AUFcU2`W@kYVf2#eO&KIRdXT\TbYP4
L[JC350<Rs15I4PZblllb!*PQ8C;d0j4&XQ!"F_hCX-cT=olX8Io]A"YULg%=m?VI!'OYuMoo
#u#AV5+%[4[OC0-e!cq;]A+PI<YUsGG'o5!#KgT:D&N@']A%C0'O:kW:ee&O09nOr?=nI$NtK[
>PJm&&=7J!Tbi_ar#O!;`@IIi>E5,!N$Ws8eSX1gRmp%nh+=Q<9)\"Mi[kd"OW.6uJ]A[U=7l
Z=#/os8+,R!bb@'Wj7mre/`3_BV+Rf+2nV9%,C+&lC\d2.j5V5HHIC^A.7V5k[h7O-p^BX+-
)Y$jD;7Ho$#oM$H*PG#3emea.s8G=Lnlc1*ddoXL[_C;D<YTq@Z<)Ft:ZBM@0NJn-2If8M.J
`]Ald7_&ZZ0YDPLV_AW/W_3qJ509^]AIaui0N.\+f3n`0scOf32F(NP43Uda@Insc20[d4A5$1
UlGHiY\*e9@m,CNR:9+ico(55DpB>bb[X'm!r`#!)=$`C#fk1YqCE/==0[EX@@1@8O_5)idP
s[uG2#]A]A&83='VoDD/R/'Q=X-)0;3gllINoU1/jV@RcatN=BT36pa3\H(1W`47HXAaPS4j$!
2Y`J<r"Rp);3)=GaNl+L?gPARBP"IqUoDr?IIA*5ig>Q1"O6%Ieo).G*YV6(R4>mi$$5p7K_
q%6!-&=Ob<jTA"SH,eIUt29ufF\m(DE*.8#ET<"%%'8_=C/9SH/6rS?5I=$Qi'aUZGH7S/L-
UbW`6&g`RYBbK4C[%K%"g1EEFgak>pJ+CF>A74(\c!VJ*]As'M$0)p-F49]A3(9WQ&?7;!5^>t
"nRB$Cni27&-Yn4s/hh,uE/;%rrTD$`IJX5_oDfgK8%>gau!BJ$BD)"qTD(P`EV8R?50dp3B
V?"(J7rucc>Qg07[12VLB(C.Kb+@*jZ[ZMt1?SA8g9XZSE-d&`F@"f2ch&iZ;m2b7bf7gDl#
trgSkchMfQ9`>/KSAK+b63-J>`p^1^2Sr'_[JX@M&!-Whj?@9*l"jF46b=a]AOi*N@Yc"'/Q&
NdO#m<f#FH\Z63\fC0D0$I)X%#9o0uFK5%:=UNSP$*o(T73cFCU!O\8*=*cCT(%gk"m2lDVd
<K(PdLqc<!E,nd4[P_&1hmuXj*UH\X>(J>%hSQr%N4CP<R7@EVai'cpb/WrV[=g:U$U4>QJ.
=:^>0oZ00RuPnN?$sI"Fh^NI:mQ-=r669;rC)X*Pe>NJYHs<Ig&;4fKQqT*EC9QNO0"YJQ/Z
VL&Ydp#T?NO%"3+#C4?EUJTEq%i+H(&dq3l<nn?UMT/SA;V)6(d&0fWiLJ4Rr-l`s0&MPHsJ
B$TQCuZ6-E_E=sdUUJ6?/gK6[on+OpBXn0!i\,^@`k`X[;G8t1aSR+KPIYSeec'QK6LQ\("C
J`\7k[Yf@:_8fIJRM4BV)-7'>'4[kZk64djAH/SA9Fd:7bm%_""//Q_?j0i>pD.1_\#V29$K
]A8Nb7s8<-$TY6C7<=VV^A!%Z*r%kZPZ51%KLbZ=#VL0J1nH[HMI2I<BVJJD=S=#38ra81Z$_
gW>..ROhYobBjMpd+l23OR@2N44=Fk.oJ2*-@,dP_c'm88/25:IqpY`aKe>cfHU<b2W^Cr6k
B^2RKt5#;g/4rS8)Kh&P;mkjZmM1Huu6>)d!2V0uL=c$ti@H0^,L;L<V(Fcnb%>4L"AY\E;*
>Qir_(F\81BdA7V8#_o<]AM"$]AOAQDf#,n1JtnBBN\=4irc5ruL6M(e#qrLO>]A4uDkNGB9F%t
m3j;%oNR,9"9+#*MDgM=Kp0"HF(Dd3-ce$eQ9"S4^D#<?^t!HEDsFsPX.nXd<1nG3J6f@fK%
FJmtF8^NR4D\#qIE`a`,njnKEeNtal^hnsq640h8FE$V!PmEFeW*)$k(81ud2Q8A&[f'&JTf
gAc-<KaJc,K&JL?hlDf&C$Eei8d;lZo:&mgQ\qLLbiGc$Gt9+qs!imJ'trYgc#l676$9mh-(
TFPB5-BB^Pf@6P4D36JAajW;0<kXqJEh0.9#YdJ(O8l**1B:rVG4hQJBO%#V-!G_Qh9Q+\l;
:-\b5r$f`<m=(3rpdGrr/5<=r*ol7?J%VZ/^9L7T^kqYHIkfTA@*Cpfp?)3&^qp;\!=*X,;:
?MDeFq!ktInMr'H:'Cp0TKS_%AP\>aAeQGK+^0'P5CU_ul;?+LtS\+Sn4I3*['1tAoaBIkeU
8aU+$of^(2G*2kYnTZ1/O1F4n*&C=#NM_SSp"7[h0\u2iMk;T+T^OZmi7-am@YJ"1:Q4-'M6
KZ,j^uPPgNXK=N8T_2c7+mJ"PYjSHcaG%5<X\L9Jh;>_9q5)j+m19A7EV=\&r^E$M"A]A&RQ?
gJfTX6lBhem3=Y%`kArGrghOpkL\UI!C8B/iQb`l#<=c+\3joffrYkd6LSb"/-0(t+C99bP.
V"UUekHo@DLlaDo.hnI1T!#!/5[IFX_=_`M$?nFZ9=S*Tssk<\7I5_VZpAFA=jd0R/%T-WYS
B00#(\'F3N8WFXWcK7'?q)<`M)XO0P!=cYu!#eEkqb%<^TAk)S*Jg/uC'/T3_bQooLT!&AQ;
qIM=gOH*bcBoTmg"mp#"5gsO@5o'3:4\$"$MR%r'R3+,:gT;3%q7l46(5U4)d<f(Z7jEuk&R
16?Egf(2Ik,1R((I*7-(#-Z%W!NPWpejs;beTbh;sC^(=8t3>Bb,Qr%l7s+78`LG)Hp>:-6I
ncKKremn908f_c-[ckj"t`p`b+J$-1cl7!B:'BM`t&$hZBG,<;aVmPsKe>l5'6"W7O)juQi>
PZ'.-7Ce]AFra5+aAlikg$'+9NZtk:_(gACa&^be:<U^D$T?%:]A"^1f'QQ[#!gLE0S.Q.!9i.
/E8-EK'S2q-S4ILCEs8>=.L?oL`L,`0t6jt@8HtDR#eP@.gV4_M0GnJ0!T9/;>?nphSq1qlc
.D#Sn+Mb!,_`r$"@nmQDBnCtB>iL#49Di/_k*=<M:SS=t>XCD6QeG/Cq`h;49R`"f`aaT#<_
A/c46XCR^@'.:r3sT$272qim*k18O]AR240Te8?bsW>c7tq!C6O9?UE.Eu82tUS]AKJosU=7.o
RQ>9q<h=OVW,%+t<+fI0VT4DhGSFL3'<<"tZ&hl8(/a"L=h:rjBB*[P6ph%3Ob9?.KmCJTWT
Z-F+M3?OY%Hp%ihmmgBYp-A[!2o:Or)57M.RCY[,1qrh/UmF+?'KiB[0$@Jd%s:K>]AdkO&1U
O-ljj+n&n![H!M[pD1l=(\i>U3r&Y)#=q"1N\-H95)oUc?j=Si'nGPFI:F3n"l1#+,C,(/((
S;4=B.e^ssh%7AH8_#adb]A!Ma<sA4B#el<g&`7m0=9HFl,#Ri5p*$OW\)tF0r3IiSn1T7;Q(
`9GG,GYeN.4Eu8Oi1lP4)cUh$C985_)ut:I4HG<,41C2[_L6<O=4*s&;T&`K#To4M5iZTin.
]Aq3f4C[HH]AE+*7qp'hkDMr1t[2S@pCd3W%A-_RrRk-7;FTB8Q21XoB)&m@RmC)pB>imY2=ho
EGT01jE?pD+;_?I$55'*Zt6%JRJblc3s[I"e%!AH:p,J,q(QN+=HPbS#Uo?B3bIbQ+&rOSc.
4BkkqHEFq_cZMjVi")_p/994,5XKb,G'Q)WkLEbetK]A(Ynq#u]A0>nH/D^:l!,Ego4mLb(CW*
kK&<lBT0hM?NI^*[7!2lM.@6*>Q0nY_o8X_pF,KHoA=e2oB<h?&jaJh`jRAA8r3KJ(!M(lI5
BFi7M?%]A"9*@=D^$o9Ii+HrX3N\d&9Pm>`SpbXa!W'u6r?d-499o=3;i:pe[Y$Mk75%WYjCu
cA8o$_i[ToVb%b=$OXNkfjnrq'Gco1:KPe+?6\d^G$rc"S;."R'"!Is$BO:=e]A&0/R[@X<c7
u%Y*Df1r<Kri>-5&7$o#l_i"C%:cub*EJ>j?E>D'Jb7Cr$!U1`<eWTAV%]ACpEAfuQrW+IR#4
9gOB(OS!'ubYg*-rf'Md[\9J[7GanLE+Csgm`,/V6+CHP3F\1SucC]AfK8NCg9$\aU89G*r4R
83*S4X&"Lh_8HC]AA+LFp@`E`\g.0A.n<m<H^*5Q:.*4F8YZ49G$-8=6&F56_K,FgIajigA3?
eVu7bs+kj+/H=/fmQmRa)`,,)&lV;)mYDq>LVT7SnpISltg^"XiP7e`7m[nm\:O!N$_#a.RM
?D>fF1X44JC0P0N1hu`7M`S=(peo$mga`SdCi3?G&-gjRoQMmX2Zu$!krX,3ub'qi4ID-PI>
nHCITePe8s.s<C9.G6XT;rbN%2+8Ma;37g5`Os8970?.@ek7am7_jISZ7ObAluocCut1.NiD
t=B2kUV,;=4rM#p]AE94'dN)f3^O!dQ7H_?!Cdj&5mTLD,n:`fNX[ENRQAgkp6+/$1:K^j1@V
C7PJPn]Ak&mcS8#H_RK6!%)@=PbRkRQ#UAlR&?[0OCX#(VFITs4U_2^hIC!3M+JU+Mao+SAqD
=OO_4B,m1Yi:;<0"OhGFPC.rsjog#lM&UDG"Pu\4EQ`qU>)>Mgf9K)!4l#UFjRgVf!S=98u.
6\QU=T=7*rEZO*"'BC;_idQR=S=!#>kfU_<9Lq`TXaFdK)oK+M.M`C!@"iO%<+p/MJEmCOA_
lrcV=?l,KVFLh!gdH]A+?-uI#-<:6Q1"BP#'Y0*WCT)"_-jZ#K+M]AHR3;Es]A>VN5WiBI53<&7
)MOAk$&fd%dgJkpH^i4@j4\\EIbK/5sXS,VhOfWofU=R@R2nlmUhkQhI5M-t4P0GmES[U-Jg
1RIlPW.tMmGj:'o/WuakQ,T$[-Z26Fm_YL/*@QWJ_fee;U7s[;H6g:*H`N.<#3Cd0Yh<r:hU
7"Y,9trr,1>&)!,LBEf_*6rqdDD\WdM4\ncqm-oWsYe)93TjCeKF$PtX2C9O6>Z:6&3qop$j
K]AKbFX7-ZBUb[*G(&F3)jnNG_"&(Z6Wq7@[c7A8KsgIEaYI-*hhm.4Cp6218sqAE/p4cUqE=
7Im6V0cONerZ45.*YHKQiloNHRrVPZ\upX-IohZKBeJ;1.U6%)LU,^LVB.HLaThC,'UjAXco
(:I`?_!<.SH+9$>1peeG9=;WWsL'sTYBW[X\8f=PigO7G._Bgsf6e8`@sL*J-u3d5,oM[!0t
Ofo[1Ofp+he3WA@UD!e+dBa6I2I2#RA+-sWl=Kd$gY$R'<_KCB[D9-CgG5JXYAJN%^ooC]AhV
g&(rZ&"VRsParISd31BmEApD/r1;&Kqd*ailq]A6EELNZ5GC,'qoIB@:&cp7E%qAF53`kg^AM
1UVSlhXh$'5L`Z1O^0ORA8RC>!Ap<iWK0^IhHI=M)>\(06maq750:!9Yq"SiNb8ga5an9JaP
+_Jf!14K@P,2j^,\+"F;dI2>]AW3X'>k;Q9W$=A#m!!giT(XU(8Q-VX#;\041s[9YNrD_W-J?
C6RS]Ad1on*pS`k\2f-&RUt^+bX)Wr(f_*@CesK?rJO\&_askJd.jDL(jVfIAU?UG.Vpj#m-g
"Zq?[H'>T..ac,8*AfHAOLr-hoLl95*fd6J,W#5iQX9@(0@T3Fi;dBAI^asHF?r*7O5C]AG&p
U\aMP1-7$-TB4$'1@[M2^?M^CTjkaTr(`,mP=]AB;:[hJ!!Q7/<VD<8&6G8q=,X`rP##9#/>@
kb8iUnR@AI[Y1'EC/fPcK4J)(Jo4dZ`Lbl=p[J,*tOXhfZ2T(\a_k,&7C78m9%#1s;>@r!q?
k3b`s8'Jkpj!>Gf)@M8kjIHIa0YRGD+8s-R=5/EAVm!#51Z=_R>FaDSr"A>dN1!q%BcZ4LiP
Ve"PJ->>lgoaTZglC.mu]An*lu+%6bE>$[/+\5Vr969D(/VKl<9j6k80"!!RQ+#%);hqbSP`U
c$fO:Yg[GJ?laieZ0?$8HitbmQ4<Qd]A9ppumL/lTZIn8thS)+/9Pu2f]Ac\o'`Od"Yg0:=c<T
BuI6%CLBPhGj8A`iQU:b#$;R[H$(l9/h*7XUBRqks;GSXnqsp"s'R3G3@F<nfF('LT62?.HO
7oqGJcDc%.RA!h7O^gVoUN/`Cs2J*rj^%[8e1!=T.!LrAC2*Wo(jM^o[:a1[6p38VL$M,N`d
*-rHW9qTG;2mNE%D)O+<3U(UJHMhno;QeH39[!W\Xat,*8\4W/6Z.]AFYnD]A?25tFB7sJ&\`t
rAELBZ+7E$3CGkVt%n6F#:W%.P3%>r@mJPWD-B6YlONit@bI%DG_H\f%gGCBKhR_bu)=Xab>
o5CA/4?iS0k>ksQ$]AUB'VWu(tC;gLT#H_6@Q*\!IS_/a,oJW629E(L/!^jZ=/[_M7s/WlGD%
Nuo'kll\VA>;Y9b(sPrT(Te\ouh1#)>[`iNKS)FZpEN'j9/>NsVY*auP;WEo7#dNf@3/`6u5
9m^GjCY`2*X]AV.hI5YshHVOj?Cbs?qeRkMAg_"1'7@6aicm&mHlrN3!H(EpWNAI\rj]A>m->+
!,JcOk5I[]Ar1iT.U</Nm_"ZF,$%[-@H;nt!V0t7k+6.m@T^>[Ab@Chka8Hpld-:3Jod-Rk`X
\tmulSBLL#']A(@aLSa6JCS(E%o#`3lIi$Y+6SE#EQ3-Wc%\'k"pqTTb2MJNkJ[T4)m5R1*ab
a&fj#FGZ_Kq<mZRb,h:Aeop5<d0$?eW`$.J:TV[Nlk*j]A)cDIp@Qo/HjlY6p=>'Uo[ARYLPT
?c0pd=,ormDkDO/!p76e.fMPa;T-3eun5WAdYuHq+9h+?@!V^3(.DCUP1XqJB$ZIDol2s!tS
*+X[qlY*^m()!]AllTM+HJ0_207+t`+b;)-7LTulZJUriA_[0m6>mid>H&%QtJ#T;T5le@0GK
]A\1:8rg'Qq"/7R(2R*0IUhA>8',X;$a:BUqr5uXga7edOlUkG1R:_nPW_P@SQ!AnLqFB.FbF
<%97P=)=''h6c)g.>iOO\H=g(]A+(AKe);Si<RpN3m!r9`^G/NWJaVJ2<'+ZHr_75'fA0@I+;
6_cqtS,\Z<[d#j(q;>$gGGc4_KTa(?akla,>Qc]A[,+j^Cmdeq0%s0*HiioGicmt#u#2h?.(>
Sf<"l[eUlf]ASNAb<^cD2aBGMlG&e*)H^i'#S=pA9Z3F:9Z9#AA$T]A"2XaqXZH?4jbRoH31C)
hT6>1@Cs,tY/B/72S[G`KbU=ML#J'`=bTlcb#7p0??D+L"d##llX^YVjPSjt5e+D@NJh_Zi`
%4JqEOEgSOaH-3L99&4T8o(Mr>]A8lYQk[@;J-I5S;I=8&a#J2691*_UY8^l3il(kdOOIuL^E
_H.Kd:j<GB6h9SflR7\tX^(ml3X"`UNKlf#LJV;Sk>rG/.hQe+$mk_b>\*g9!I,3FhJ*5!O]A
cbu+E@'uKqCgtACP*.+'CJ<D>U*U<o*j0\ci6pa2_8+#-?E\S>c4\mQ5aBoAC1FY7hOLtJDT
DVI?Iu+.m\?o7@BG`%agL!k!t'aeLUd`img->\*P]A//lKhh?@&d-nG+7OoM^Gd+*<")&FKRQ
*_%0((O)[MJ^F0hg[Y:>fAkGA<XdLp*:V,$nmR%u$8mW98,i0f\r?"a7raAZ&Ij"QCkkbf.H
JS$SYutRAcieVjN[!ItZK.jr<>40R37PjC4a3ppHX$Fk-M$(#K<"$2\oHtX\ep*^ggbC4`qN
6HL)!,>K##R3Y8B51BfL=sHpY'/.nA_6`1tOnV1SEh'om5\f(1e`e_^s7m4A5e!DB6jWNl@k
aMJdJ$KY/RW2:[Np2f(C;8E1+DINUb8CE$/)Fe$iYj-Ut.fPLG8@_C$)ZcT9s&XKEfupLNE:
f/MDPm>mP&s/**lj.c%[DB:Ge)'e6.IN=UW9]ApG,id`8ogOWgM>7K\)@u&h6Wci.PUil#=jZ
6XbB@]A*<50E>opGLND:O.*^nF`2T((X'Z3_0gLuC:@f`QC;qPf]A?F$CIc?l^i3T_@CF5QYUI
,u"o86RJ,pQ$kH\(LHHT5l`ZI'mA#5SX6?g;<(o1QSVD=/MYlff$Ka`JCSpO"BlhN.gCf*K[
TMegU#@FC8$Fh(kIk^"`r&qkkJ*6&Vg9g1I-5UZ0`bLIRRlpje0flT]A/&!O2-Aitd5_B@Fs5
\h%[2%YagO[CD,*`9/q[("r0uFtCbn/QKVZW<\b(DP*jpcmYX)F!eg=X*S\<*RFVog+So++<
^:_XUZH&]ACGr?5_"0iP#@8kaX+nKid[]A]A\Xl-pa5Xd&SO<,`]AQYIWfm%92`E'OR&Tt(a;jm*
6W;cI>e&hLice7,n)UaM_]Am"$@Ds8Vm.)[P:KnBIu_"H#^;f(1RQUR!@O2qec"/DgtrmJ=(j
V9?4N90*cs4(eLEKhX33SS._.4&,^4M[;ZIn8.VQS.!HlbdnVAOUs*&#ZU:\bn`4lMd,c_df
rsM7D:c`2&agMEe$Q1:Tq^%$)7X-ZZ^YrS43FFs*<$nGfec;47Xtk+*:IJS.sFjMT-G49^@%
h@tPG=Q*\"@0C^F+q87;_QEk9MO'5mQhs8m!kbAOT0R+4=_*J86qGGXIl,@2oU'i#T@0Xdr+
IP>F[c>&<tB_tebDOQs$&h`Oam&:Mc:kk*&AQ)@$4k"7/p,ZEqs#"T[Mf*pdJo_?[V+EEd.&
iV&R5ET,?O/");$b]Am/qC"F&]A(AL%:0WD[$iZ+?I7K6CTHP&=Xpq)9((3a64sU&f?81q/=7o
VBUZ=8UF\s!M8<`TS=Npr?@C9c@qZ6qP24TsU.2l,c&C%dX&bkLH-Lobu@a&EFbANnU;X-k#
j#JeALuIqUFlMkA\lcHX<Cnjl@Ci!KaL"CG80M+0h%,/f9\<O"Xg(f?k%F#d3dlD;WIRL+)K
PkEKmSsn@Zp]APO]A6Vl@ZGd0%'E"_ahAX-g7q_'7(/bS;'4p1=JS!6kN#n7a7cFM3rDuE]A8?h
-i>b"VjK+MET83>8JSO4_d.2]Aq9t^l,tMgAgb/94Hq9&Z)7TO]A&HBF7X^Z>_a6EK/pD?#qsj
:L+0k@OHpXt#Y'_BU@>NG>!:b>&q@F"g94deF;8P0PMH>[6QR0=Ls#XT't7F28#gcA";0.6"
Pfo$'+U2lrAU%!OpGfU[\rM9p)("TH4=+T;0n>!nH/mf=Ri`c'c5u7Gi#WP0*G15;nP(IU&a
0.lg!U8c:P9`L6<Rk.pm<8;)T<]A?<R"Q@NY[bG4sb%p)h<s0:ZnR.ceRL'&phse(Fp!X[o:6
AsqMCgeMEQ#!$IPY`<3tq59G`-]ACZaC1PlD>^_>leFW0)1O&5pgOGqR6i^O+I`FrPi3'mo#W
96mZ([[\Ol5(,C.h\WqR\D)5*gj(g"XZ'0Wp.q86EGF3Bl8)GVI:0+K(>#Nh"MBrD2K*(%5d
uaP0H28cr`)-hb6o!C8:r7**7g@s4=2la14b9,]Al(:5Y2Mg([Wuoh3X",s8pK[=EJP!"fsXV
e[TAGUZDWiD,,spueSR"A[U>'"ggDJpFO&H5NS%OZ,ROZVgB;[bG&o"S"GHSTl2B7ld9OH(i
^jk!ao`.IUO)`L1Hsa>0),_dCS*.5QSV\6*0jl]AO2D=3Oj8/TrU/X"uSUO"f\@0(Fti;GeJ*
UMD(3R2]A"b,*&8PK\Co$%L.IL_Fe*+d&oo!hSd%[/+43_.+8R[Z;LfQQ;o3-lYaGBD+=/?Aq
`SjCsDGFf8BfEhq`#f1F_km]A#BD(G2rLCA=-eT[!h(@FWtpN*!9i!l%]A^X)Eo/KW/Z=s260,
-66hn*Pb^F6fH4[W:BpqOB<FY1922RG\-H!gU&^@nS?k`cF`EX-!`24]AA3su/m-$fPjAiia]A
+<aPhj'[r22KpWR*er1E:Wi',]Ahm*&'F$h`QI!j!qru]ANC9&MCbjDNiFUb30n)=bLU6p"1K^
tn!Qe24PG@ZiAl\PFj)KU8iu.QLd3@.7r]A!$5i(aWB0cF'eJ6MT1Y%F7.pAsV4EhSRke5\Z5
RD:A/#6cs]A7OI_T%Xhb(*8i2p?l$c8RRiWg;YT#g9`=o2HB!ZJV6ICS6rf&F+dAlb@FOH:^i
.T..E[1eV<J=@gZDGn."7!jq&G=[/\U(`$Y5pD'&>rCO2r9icGWhqTV@1IhrRK=K0l/NhT)B
[B7?!PM3omlT.0Po:'fSEK/04%55f$tod!$Y'H5A#MM6_sluJA%licgoqX.p3TRk=R$l"Q5!
Q\T.*!YYVnp?6(a,Jl@HbT(/0kL8.d3<pTOl4@IC=9"g]A5O0Z5:a_2*?UoIFpk%AMdIbB\-1
)?^!8kI!mA<JBK)5*R4ZN1R4V^L=Mu\n,R*9'cYi"."]A*\p=5^PJV'i@<[INIsDr#rkfiK"3
]ATi]Ao;/7'!UUK[%.qLIj"C0#%#OF;r4WO5GK%JpEiP2:!llkA&!$K_j:dUmK$-:-2;%j5k1f
2C$r()V#n'/dEYVJF*>QtF:^5F<4C=TS5e?Q,c$X7nLA8b;EbE/^Y\V^'a1t\]A$]A$*Zhak%(
1QA3#4(+dAM=FT(Y4ZseA&Ja).q]ADp6fUk'#Z7,R@(%JD^aERB9AXrPIfMM6&f\DADo;hcsN
QgD)P,eVQQ3O(nbiT!4#-M6*(pJp>0%u^:Y%6r'oF`X%ntM_1;Y&Yn;g^M87`-*1#"Db4+!g
L6*q6gnH>76[4a7_*kKs#k#sNcHJ3P/oB`p+Jlibt,j)Z0pail8`me+'mN1$of'pf-?H''0h
Kl/`</0>Q/*%iH*IiU,"SSg:s%kj0P2`=Z\mcHE)!oNjbk4;LDRt#d!E-cinTa!o[6;'oC$E
9DXDcm=\F=W9-K@KPKE39O9=Djk,?l,C+Q%+@(3=#`^nJ1J)C7?%3'HMJ"*cBdq<;?=uo\(l
=@Gj:!'U=uKnO)!VT('1;L0HZjSNIWpV:b#bF(e^KSCo;,kB1./]ADf)!OI+m-7?Pp%n*J)4g
]Ai%3dsSjM+_9jFM05C"j@A%'FH\R'HpnYD7gJ@05AE5:n![<;D$uu7>4"?9\"#tr\3\trh!Q
0l&GOZA47n/gXjcS!XJQi`I*SZ3[l4\b<iAumV874bPSBTifV:.^`@GL!)eks'In#m;:<7ml
KbIABolT5s35H+L3bf`)<6p[4M9$M`'.Nsb4tL$G63JKI?&3GT^?]A17IMrl;T*c-u/)0$AgT
A@H1#+<1UY6l5Sq@2j8?WNARZk#EPn$68@7ja9r7b5lS#r"/WO'@Rck@]A5"<>F,:q<L6Xf8^
W`_(1dq491Q8.!qL>+:!E&_W)0eke*h4Wrbe5-M[%lA>SAGBIdKJ9_gUa[Tbk&6:)?L&^1#A
0@gG4L=O\^Jpl5g0-aM57:LIUe0)1]A7\(Alfmjs9Ts78EN<t-@L,UnXAS!+X%tGH=;!*&WoZ
U4-+uLWZ@9@gY>rNqg]AcR38i?n-dRRMZg:$,MNM%tM`8N$qXGt3hj@t`HkTbm=+\)0HfK)p/
L;I]A1KA^MimH;Tc=9=UDk490`-Z5^L&diBnVnE_5L8R-37,l39qbsD%p9/k7ME$NkoGBJ^Rc
_(9^T&`P[GmDC:F71/cc(Rg^B\$NK^M2O:$4a)n1oS%GdGL[CAsPO;Ahc8!J!bn%n32*HQe=
>3UXZ;hQm+H\cRn.&;2>cjp_(fhET;pHto]AV=)(T[X"9s/&_:hh'$&#kd.2<qgt%)2?l:1g8
ruk@PuHKSAI7uQ-XZ%S[YpAdPl-sMj"(dDR`aXBNJoi%XH[C9o,tZ1_B'71QoS%^7qW?`eU2
LgdW3g!k#[^#ETm]A$UJ0>F3]AY"&Fjk]A@2-Q]Aq^NXsOh=.A$7B(N18]A`p,DJ_nad8N]Alf,OXD
XD%^0(!`83D$PL_R7BX+5%GP"oBa_E&`WBdYR^)k`*'mJ*]A@r@XSOd.Vo7tmR!Oo/3Q?Ch3$
Y_/>*K2qM8JNr&_'8Vo;pVRTnGH#'jI=!qN50V'75R0JHAk_PXjOg]AhYt)gIZp1>-C0dSL7i
8CWcA4r,IRZ2lO0^.=]AI9ehNk]A<6IN[T$EstKOgaCNhiRIh)$-ZBJr4GI>L;E&ld@TJEk4)a
sq3(aV%=DRT;^h^o"q?C!%,-[!Bpo<H?40b`q%U0"8`$d2>kaA)6l=M7Vd\)LU&2eU;*)n1'
YW-ol6I4-=,jgu\O(aIamtl68d`:r5"UJPJb1.&$,73i9]A/[#lHQ6C4fmXc:L&eB0>3Se*0I
hX]Ag;J9+A1o%2<ikXD(F?IF;sS_HXd4;qsirZHo^rRM$ZJ?a@PEKI$iYesQ`XogldZar64H'
5JMFO"15R'`9]A?am`[*]A+]A3'.[LU_^nfcjQ0-XU`#1'HS00C6>+h\cMCfK)GMU3B)DF@qr>e
Eo3ul"d[n#l1X@f+#pqO3Zn=ChPt9h9<\p/bEPr,;s8P'U!d#g7HT;4j/HcYcJ'0+]A(`UEUN
k%m2ChN&_!-sVJp"=S!CYmM=$HVrte>ch5NH"VUJn>W?-4Cd8Z5=-f)6K$'au*_Ug_Yh=YHA
H#ljdHp@i0[LYnp"63s[-*HsEis_)D=6Qcl_XVmpe/L.Uk+2!NrAOF1+RocqB'rVhO6Kp._7
fK9iE[i&ndlk5B8S58641o:uFcWR&>n2-KSY)BBH/<]Al]A/un[<e\?W;OrB3<'inf7p1enhmf
)Wq$60gF,0n%E3:1>mXPZl8(_)QkW;o0?JHLV9,p>Vq5??\IS*ok4)AoTj\H*[M=o+AHDPN#
_&<JQ`'&u#@!0bD46oCP/JCKLs4,luN*FfH%\cO^$1U_AtKY1)m2R-1.Ijkl6pq)tjeR`:^r
!GB!SGu=<hkltuAQh;cfc_]A4Hlo')51mF)g!4I20-]AJ+K[?L=PbhC)a%&;76d9X/:R5N(Z\f
o"B@>p@#,nFd&f"7,&B8]A1]AWHsi&r+QL*3(WVgTM]At2Y(XKVS\M,9Je+@/4#DBY\=VjqEEn+
<gQ6LdU#?4k"9e5,:MYq_s^kbi%1/eKWaiiXVAKu<Y<N@'7tI)jaq,H3Eft3OGE:s&/&GKEm
HgKAGEq(85]ADVgJGg2NCDQ5l?Mp9CXM\Ain>X$X4JltKT&\(rQVK=?HqRH@+sb>28a#H-C@N
&mAgX\(og2HE(mf@+Sor?IYX0Klr!-SI?GP!iB>X@o`F4b5:buc/qlT\q*j,^_NS>R>%#Q3?
MLm.8c%,l+08nL[rL-(5K@*M.?*-u;q6C0VBA;06,>LZbia7JRn++fM_9pOp]A%Z=S,cBm\!q
O@&:D-%3U)Y8?!\QC=qT5$H0eV2M5H"Z1>4s&BXZBd$e6n0U'Kg;4B.<6p\46'aV5RHiI1><
NW<VdHlHsbNZ`iaA&I=@-J$lkh5p_Z'Q<F\o\#f;Jhp#ZK.WjH?0Y+$^_cH2E,//7N&<mLC(
Bq$MBYSdeeGVQplZqsYeg1HWg1sWZa&!>WC\k,6IM=<G&r4/[k99'gQf(E-g0cF<3\`2E^TU
Q5)CT.:0ZNKQ]A9k?n5Oq&HIVhH>,njsT9=M35FcklRYhWR\AQ1=auAO8rlEgiK#H%nPVBOns
2<Eq:()&o@8\;n7-OmDeZ^]AJ<2:D0MI+)p=tN-D-Lh?@=ueRsI)SSka6_D&la.j-n)robhi8
d;gR3C=)),E'/1cU748]A;N36Z4hU8YnRBmuD2&4r<OY':^[2I1N-lSB?b:06Aa^9#bI2W@SM
k/T(c_u%Tm%HD1,?_#W`Cs\pq*nR!58_]A&H6*_AC\n!0Kc4Nd0Z.?kl+!eE(9p!1O@tsBXq\
5RX.AIC-#X!XHB.OZRkg<i!,tXN`HZgWN1lX_iKp'0$T3ti@%_/uC?30WJ[r]A`83qJ4dfa/6
XaKSaZN2(.4*VU;S7o@rMTI-_6o]A\.n=0LH1,Cj<s?DHb2eRls[rn7A0`-[PKh[l2l'=.97k
Hhp5)E0g?POD%aq97MUD!Q-&^t>8f($$Do*VQrnC,O01S0ed6Mo(-%#g8X8);4Vb8NV5cL5l
^2<RTY<q8WFo&Xi&[r9kLl4]Aat?Ni;Bnhf&<R*HT]AH45;1CM1E6lW\<#L00S^UfJ[b=:.>uh
U.:E%jf8<k(&-b;'6i7Na3Mr<N0b2Y`@nm8+t9dBA;ijo#iq>dA@C):cDq"2\o5M`"-S%T)V
[9[KFIVPA3bDn<@$kp,`Wnk]AR@C-c5Q^h8+2obT$=>M%N"$*V\O(V7n=Y0#!r>9_Vs,GBqdi
\jC!`5QDV*%Yuq%P>%PWN#KVfU2*nPpp)?(s-17"@q`=OMkn\<6SYo$VJ"Ui._XD$A(K$YSm
G;#i332`4-L?s+MeN5WfoT@D9i'_U&!JuZ\!Z]A&O71q_okcQMXUaoj%QI<V!qnHg3R4R7XFa
)g#!uqO1KNTIB"+[0-QD*E%sM1SUk/VD\k`:5V,nP<5>Y-OSPAY7-:#j'BKBTn5BZR_).XNQ
\[qbB1^EGA9.HS86-G2amjeZq!Lj=o'lr]A:2o'0*#X,mqfcRV%'Okg7j1ii,=<WDOm',+I4$
S;o^,\Em4h:\,OpN\e-/Eb7W`,T"+?Ndd4>%eu"n:<rY6D4d%2Dq\bHcJ2V=dYB$Pgpa\QE]A
`2DI%ZoVf&)2;KBlF;FEGER^drlnO\:r3K"(EYmb\.\#G<>^g^8`\8jkphoFXWMmi=Y2>e5S
^8cW@Adht]AaL=VjgO4VD#[6q"Lld).br6+_tTpI")2&NC[l>rXrd]AEP_Vb0q,u[4^@J@V%N[
`JYo<XG?<e,7ir<tfr"iR<!".d[FJJY4oa[s]AS]AUX>!M5"Sb``J3qE3>=k2*>;T^_sn7f`5#
6YDhI;pW$6CcNB=#lM;V2_'JV>JMq>B5$.-O+V/XFcgOeXR*lE"lZT'@YM-^S_(#2a^^ar.)
&M?JFqX"ZWX>kYUt`G[nu22@5H^;^V2lRN96,VblVdFs#'E:k#?A@ArZqk_1t%@fk!V+I*GF
D+'g&AdNT7;q,6bGDl6:2%,nHg7QFfa:W?`0o]A&B!i>kjU!It3WYtE%ea0:A@M+_+3M+I5`4
5R(;ff=]ApL>9:YeX1d^UT^/qa.d1@_YC>!B'-"HSVdX9mS%I^SR_L/AuRI'Gt=[HkkC&Iic+
'JamkKO4N-4>H@[Iao5,*!G4,)`n0X#B]AK'>%#lH,4!KZhkXR*qA*.o97\*mtD;i4tK;#3j+
Qe<9/hse&O$I'IEFJ$ikFU9_#h8#q(Ub7\+'*A4V'HkO,D6%QPq6C`;qB?U_Lo*B'bfh;A=d
Z$]A$m-'V(PE:58gg3qr>J.s?jAbor%+84e]AEjEOI%kJK7jL"Ab,8eBmH#&Ja/*%.SsRIfQUr
Vq@q)CQt%/Z;DO/@R?F1(i'bj*^N[.^-b$*8J,/Fl=rOAYBc3Lc04aRtW3<u'8^tr&Jfi&J8
dhG>)2)A+:"0fLS9*or'Apa6$3n/,llkVlmb#;2;6NEG%8]ADoVB5J]AFdI9MMb7rgfG5?#Vrb
rs90Rbik="4dIe-\mD5CZ;WLRS=R,6p%f@&E(qPk/'L\`oA'E\M0LCr8a/VWiV.#c'WSuU,E
Bich)P`1fXFb5hZZsq:&?t]AeoicW%@rLdm1bn7c'0[m&_W'dG3%T<n>2Rd-flnH,=@W^qmP9
u"XJ]A_O)`4"=5oTZus7Sf7k-i7G^8=En(%IkZ+"f\5Q597?g,9>kq?b:t,:DrSGfHjn:\Qgi
=ppES*4@d&lHJT<H.Q%AoC@%3=J=&0-kp:TYpXY82,5i721(7MO]AU*A98]Aqj>b8gs5l[E%uU
U&1i,hqDhCX;i,nc8K_RqN`bL!fVe?Q<`cGaO\^8t#VTE4j\4Y"'T7@Hfokai@ZIl2PTig">
Lr5;)2GQfMT4hoW"?`c>XGI;&R$8V>ji:,]A0KaJ/U>m=DqE0'W@4F)In`rnSbelH+=XqRd7.
]AMa2bc1O-'N\=<5%_$,\[9cO!Srrii@IMbTI\/4MVG$TglOPU@Oq@CJm=hAsXbmqJg)CVe-p
OXP5*jig6i1a!W$pEXHG46,,W7H;`Ng3RRdh9h==4IJGGH18XDW]A+kYPgbI/QU66pc^+,DmB
X?@J1WI1uI'K0CT@T;=*h6IkXU41%/u,eJ;)G/P7\;G?dUW%4`[m9--:G2F\ffI(:9cqO4^F
mWh$E9X-W+"<QfO!./.oQ5qYO.&MKJcQL@-2,J[?]A<2#iq7<YWmG?'IhD_R>_*LpjQ(X?C]AY
GoH;lNP\<Hh'm<iubHI/O!9&Md!.sXqiTKtX(C6p`(>;o-GhIO5j]A'/GMER[+[@%DY^Q:#61
9/"NqCo*GhKTfZRI?OH:;Ju;4q9K1PVA(\6I;]A):*ET?!3tpT[n)8r=:O_;5RWT)5$g`RY?/
dW0CW_E-"'[l0*Kk%UZqY[<&&$nBQ!,q:?1'aR\N)0LrNmS;HS:g.gscb)?Pae_Y4=aJ)hbJ
Hn&^7,FNbh,*kcbZ)bN0OSIj&d(/CB+-Q7?kP+()p0#NO6Pl=rkd3ZE2%GoFG+(1>epJRmS0
RYcZ5UXPKM/f98f>GZa7??kGI6mdf3?2?k\hWaRP0Y/tEc#[Yh;T<q]AJ$2)I61F2L/L`qk/u
fIbgo^V_#)bV-^X@AeR[k#7S<iu[V^+71UL&ijrPS0pQ7)J]AJXU(R;@99gTpG5%QIP!0ifiH
l.ZPAH$D@;:77B9(U"A92RXmQ-&^/k4_@?RpILsS3acn_8RLuU:PkL[I_TQVNqs%08(9BM5#
ipuC;VqIX#c`d9hEY-i"F4d7&5>DSKVl`dIL$S@$m\,NSc4)XOW\dUpa9Up[8BM^I+tBJt]A\
kA[5D!f!\ESfP-BM3Tg$XgsO@2OM7@n6=kI+[%;-N:MP/6d-1lo^7dGY0oDsa]A>o#aZYn"j2
gGX,C)VSL7:hW!#$<6(PA:qf5=jlohpYT_N0$o!h[CO4FV*Y`01F<cC9;2sh^-!6Fg5.qlkB
TYNdjZZCeRl8]ATPKP&E6<qA]Aj)1dah)%h`;AIlMGa"kHKf`cSU32UP&fuLeh]AQ%:m-E/[Gqs
>,Br!"$c11mprSDH,m[PS=GjOppIL)RI3]Ap-_aNJ)0Ri9$RSdW\6Z"E-5)S=c%deSYib@t]AY
j%/3(s$DH@NJao?A!D`"j?Mb9CFBZJk)]AotTb94.tD+LnAX`d2RZ4,bc1j@O=q*17\46'!b`
QHFR,6+V9k[q@m+SF`C6C#^)u@LodMBN(Na<j<Tk^[`Y^!HhPb9JtG4ql/#eFBhZo&K&sZuD
c)OsogeB&7:\.DOqn_C7FijF;h?DB\'onPBd5FmTiP)J\)Sf)pqV/d<mNV)HJ29/mIdQ,?K$
jVD^3LcjH\[54f']A[8qB%WUQW4f?A1udXEf^4NqHZ,Sk)25R7p+^IKsuH@OVF.B<=//;^2;t
1tOHMr7!H+/)pKgq+EVS%f@(=U>ee*3+bNi1YjOb"r#lK\SeARqlNbjkhQs%Yk0f#64FiA5!
A"]AT(>R=;@9dN_c1iCXrhK0GEIX5C["LJ48o!R4Thj*Hsr1Ek3U^S41S$_5.90Pg/E:'XdjG
Gd_!u8h8LDbg)''T^\,fcnG=TY!FMX\H(O+rAbKZ&Ks$q&P!&03/r<$Q/t.+\f$XNV,Dk4G$
!u3B]AOcbNTV+heF`lkl^(Pj*q_tu"fUX2aPS`34g0r`')LXf\:;.Bgp0l.H).r2W9+/JuKd&
a_)u1&U5cZS_!)%3InSq($hN7<!'.`_7deo?Q+I?4OTV/Ae^9GgFgb>WlogK)SWs@u9f"=,Q
ih_t29=3H,`C+:pX).ZO>;T>-&@Z2Tj[,Xr@#$[!\O71'A<u".:mb,53T/LelMIX5&GNu[,W
:k\/30P99QbT#8URJ0WW(,M"&c!bK)IC/(V0s#@<L"c`upc%:?FF=Z?kU/6>ZJHKOEG0d*&;
l\qt@`eFsUa$+m?LdZZa_Y;L'2p)\/?45Z(D*?BGL\[F;,WhY6*((&ZSIT>$%<*%0fY$]A_`>
3\B%kh%^uIMC`nAb=4R""l*NiK,mm$)C?f?9M,M9A`lK)6+Q110SX9EACm;&H5k,[6YtP]AOt
A+E@=Y;nJbo>3mE;'HfZIf`CsW$>Rt;ZW<2C^C3mT1QT*&FIhasp%;7c-To&Zo@l<?9;)FF!
\__5WhTn2=_9LNZbfr#q/C[eWU_&q;7\%/13+ZcN65t2pZp&+\_bGo]A<4U'I/nT"u_s*ggl(
[-'%8n=GhUf4`]AO[&!T!tT[F4?=2j`#@mhWMY$]AQ'`cS-+GHPljap8]ACVWC95Sls4dgNp+mX
=9e@6tZ&V14HWj,flP#Pr*4`WQ1gP!`fZ,6klb'8Q)FG$!mQA4g6sU]AGVO2dfJ-bN.Ni.p33
g^AS4VD,pCNJ;&Vd*$H%gcV/"O$r)b$-Cm:'Q%+)?[$ice4#rbO+9F*Un!Fql$-JC2kGTr#J
R=*6DVX-[KQ?C`l1YhrK6/F!l=\mV[.@R/Ge,HtNgkrGQNT>;V2j39(rJ1'J4`Y>9p[2/*A+
dk7%O.o@X'Y9k$$k*AV\(Jb9W.spXG"W[!\NFbCd?=Zfh05Edj/PZ#Fh>ibo*E,m5O;TQs0_
XuYg>?+K]A?j1M*d//"/d"<+E>t_?LZHT2s"u'?e9[S[]ATCgoNS2V%ca_$.e_>;hfnfX(:P`A
ua8FnkVm<gm6MX[\L2I3l<l5`U\ICGaPuC<rAV9,NersuiD<.o*,J#CDP:"(V'6f\IFnOb)R
UFGSUXYHgch59)%FO":aEEc7KUDI;nUGQ(_B8^3d5lc)L?i0eNF7/j'0.MPfUbE'_a%>,-V9
T6W>nUK2=ZcMpDnJ%4aKV.d4jl*:^"&Y5+r(.Y9HuN*[K9eoX\`#F]ACgpCt\)H%sJknX$$$n
#FBiHR"t=Fhc,I9<aA`=l./&HC!d$S[;YYoDE8dDX/cSs60><\,_Y%*_K@H=%gcra6CO3g&r
sWXc=StA3H77t'8FjtU/=<Vld;/Z$)9!EdloY#+T"MEWjq@Y<&$241]A(!;]AO4is:B8sqf1Ib
N2YnrN!.cn]A'S&H)Gf@IaLHq*(JE*s>B7$X*O1f?2#"$?l'j*Yf<SbKA%,cd68F#aJ]A7FF"#
nU0ab0'0J%GOIGEe2?dcLppY@"3gL/X97pStM*@S.+q+hr(s/Bc\KO_s/nH:g!?$]AdZT4#hn
RgpDZC]A7alQMfGiotQe9AX`'mIDo0*gCRh5Jae*7Zcs4OmX8E>*,g:*.KEfiJ4p)p-6lZVtd
GiG=Js/mM<SJm]A!3[KKn=T0.PB(kOU.o3-:U]Am)^DDk9An(W>Vi?ugrs7t;9UXPi;!p$Rnib
.#!_Qmishj1,k;rS$NIdkS]ATW>/-7eOGbZsM&1[7C)]AnY+2X*,>ckFJZG:0n$_t/V<:K]A>F0
U_D>dX1K[SJBk:gbk3&IZTLRZV\\:G>.K?!+/&j?bka<Za+/U7*:KD6AE(pb]A,4U#U'2f)-=
hE*>RG0Z(IsH^L8N3cNR!eB5Ek_N)k2R'4:jG!Sn4.0-kr0-4q=Frtmo)WDEn`1grkp&9geD
ec?JQ]APRTVT+;BLnST(O[t?6[X+p3X"6A4]Ae*cl%(A,la^J_b3!si9a4E\t,$jIYlL:khIaO
Pada"r:7#2)RCtOL%hX_ZdZCr3bI4)2e(4@-;0<3BA$9tWoBd+lNbq]A6qUp]A0+oE(QVc(LN-
082mjg<f=?1]A7E<$g=`c!C(8S4Z".jf$2'2_=C.SE*iqhq_kjMi&_9!ik`/:;V.!L,iA?uA.
3c@4Yb@u("=f5)_=bt5!HPEgfJ&X.^rVI,!nEO+=hpBf`P.IpDFqbcQ\W\8XiGM7;Ff5'tPR
7A<4-6?;V:E/`R"TM@@3!llHYkf*AoMsl:<umW#%u1(mA&s,1f8N@4#WTVdjEH,2[F>*LO<_
&Q-*B_hRQgJ2V&/_(H-\>Z&)TV1\OH#DPd]AIMVsFohG@T4:P4u\aIY2bRIUBd21\BZ'=4SZ0
,^$dGkX9&uSGkRsHW'bhDMEUO$fp<QIVA?61l6!SaQE74(c990F9V\7os(B'iBu)Prso~
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
<![CDATA[723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" cs="6" rs="17">
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
<newLineColor lineColor="-5197648"/>
<AxisPosition value="4"/>
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
<Attr class="com.fr.plugin.chart.base.AttrTooltip">
<AttrTooltip>
<Attr enable="true" duration="4" followMouse="false" showMutiSeries="true" isCustom="false"/>
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
<newLineColor lineColor="-5197648"/>
<AxisPosition value="4"/>
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
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="stackID"/>
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
<Attr class="com.fr.plugin.chart.base.AttrTooltip">
<AttrTooltip>
<Attr enable="true" duration="4" followMouse="false" showMutiSeries="true" isCustom="false"/>
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
<Attr class="com.fr.plugin.chart.base.VanChartAttrMarker">
<VanAttrMarker>
<Attr isCommon="true" markerType="NullMarker" radius="4.5" width="30.0" height="30.0"/>
<Background name="NullBackground"/>
</VanAttrMarker>
</Attr>
<Attr class="com.fr.plugin.chart.base.VanChartAttrLine">
<VanAttrLine>
<Attr lineWidth="2" lineStyle="0" nullValueBreak="true"/>
</VanAttrLine>
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
<newLineColor lineColor="-5197648"/>
<AxisPosition value="4"/>
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
<Attr xAxisIndex="0" yAxisIndex="1" stacked="false" percentStacked="false" stackID="stackID"/>
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
<![CDATA[签约]]></Name>
</TableData>
<CategoryName value="月"/>
<ChartSummaryColumn name="目标" function="com.fr.data.util.function.NoneFunction" customName="目标"/>
<ChartSummaryColumn name="实际" function="com.fr.data.util.function.NoneFunction" customName="实际"/>
</MoreNameCDDefinition>
</DefinitionMap>
<DefinitionMap key="line">
<MoreNameCDDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[签约]]></Name>
</TableData>
<CategoryName value="月"/>
<ChartSummaryColumn name="完成率" function="com.fr.data.util.function.NoneFunction" customName="完成率"/>
</MoreNameCDDefinition>
</DefinitionMap>
</DefinitionMapList>
</CustomDefinition>
</ChartDefinition>
</Chart>
<tools hidden="true" sort="false" export="true" fullScreen="true"/>
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
<BoundsAttr x="8" y="3" width="845" height="231"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="report5"/>
<Widget widgetName="org_name"/>
<Widget widgetName="org99"/>
<Widget widgetName="report3_c"/>
<Widget widgetName="report3_c_c_c"/>
<Widget widgetName="report3_c_c"/>
<Widget widgetName="info99"/>
<Widget widgetName="periodtype99"/>
<Widget widgetName="report0"/>
<Widget widgetName="report7"/>
<Widget widgetName="report7_c"/>
<Widget widgetName="tiaozhuan1"/>
</MobileWidgetList>
<WidgetScalingAttr compState="0"/>
<DesignResolution absoluteResolutionScaleW="1366" absoluteResolutionScaleH="768"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="956" height="520"/>
</Widget>
<Sorted sorted="true"/>
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
<TemplateID TemplateID="ea1be598-bc19-42ca-8b84-bc7a1caa519b"/>
<TemplateIdAttMark class="com.fr.base.iofileattr.TemplateIdAttrMark">
<TemplateIdAttMark TemplateId="c25c5864-3a1c-4e3e-ab97-58c34c70b87d"/>
</TemplateIdAttMark>
</Form>
