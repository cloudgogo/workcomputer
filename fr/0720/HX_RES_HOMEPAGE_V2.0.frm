<?xml version="1.0" encoding="UTF-8"?>
<Form xmlVersion="20170720" releaseVersion="9.0.0">
<TableDataMap>
<TableData name="可售房源" class="com.fr.data.impl.DBTableData">
<Parameters/>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[oracle_test]]></DatabaseName>
</Connection>
<Query>
<![CDATA[/*
 select round(sum(s.store_area),0) store_area,round(sum(s.store_value),0) store_value from dm_res_check_res_sche s ,
 dim_org o
 where s.DATA_DATE = (SELECT MAX(DATA_DATE) FROM dm_res_check_res_sche)
 and s.org_id=o.org_id
 and s.res_sche_id='已取证'*/


select value,area from DM_RES_SALE_HOUSE_SING]]></Query>
</TableData>
<TableData name="可用指标批复" class="com.fr.data.impl.DBTableData">
<Parameters/>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[oracle_test]]></DatabaseName>
</Connection>
<Query>
<![CDATA[select sum(a.usable_ind) usable_ind from   DM_RES_CHECK_AREA a
,dim_org o
where a.org_id=o.org_id
AND O.ORG_TYPE='事业部'
and a.DATA_DATE = (SELECT MAX(DATA_DATE) FROM DM_RES_CHECK_AREA)]]></Query>
</TableData>
<TableData name="储备房源" class="com.fr.data.impl.DBTableData">
<Parameters/>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[oracle_test]]></DatabaseName>
</Connection>
<Query>
<![CDATA[     select   sum(buildingarea) as area_p,
       sum(vacantarea) as area_m
  from dm_res_viewvacant t1]]></Query>
</TableData>
<TableData name="TGP" class="com.fr.data.impl.DBTableData">
<Parameters/>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[oracle_test]]></DatabaseName>
</Connection>
<Query>
<![CDATA[select ORG_SNAME,AREA_LAND,HANG_DATE,DEAL_DATE,HANG_TYPE,plot_name FROM DM_RES_HANG a
LEFT JOIN DIM_ORG b ON a.area_ID=b.ORG_ID WHERE HANG_TYPE='已挂牌未摘牌'
and b.org_type='区域'

ORDER BY HANG_DATE]]></Query>
</TableData>
<TableData name="WGP" class="com.fr.data.impl.DBTableData">
<Parameters/>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[oracle_test]]></DatabaseName>
</Connection>
<Query>
<![CDATA[select ORG_SNAME,AREA_LAND,HANG_DATE,HANG_TYPE,plot_name FROM DM_RES_HANG a
LEFT JOIN DIM_ORG b ON a.area_ID=b.ORG_ID WHERE HANG_TYPE='计划挂牌'
and b.org_type='区域'
and to_date(a.hang_date,'yyyyMMdd') < add_months(sysdate,+1)
ORDER BY HANG_DATE]]></Query>
</TableData>
<TableData name="CPJLV" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="org_classify"/>
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
<![CDATA[


select sum(pro_qty) as pro_qty,sum(all_fill) as fin_pro_qty,round(decode(sum(pro_qty),0,0,sum(all_fill) / sum(pro_qty)),4) rate from (
 select distinct org_id,pro_qty,all_fill
 from dm_res_trade_rule
 where data_date = (select max(data_date) from dm_res_trade_rule)
-- 2018-07-20 update 增加环京外埠参数
 and org_id in (select org_id from dim_org o where 1=1  ${if(org_classify="全部","","and o.org_classify='"+org_classify+"'")})
 )

]]></Query>
</TableData>
<TableData name="3" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="depttype"/>
<O>
<![CDATA[3]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[oracle_test]]></DatabaseName>
</Connection>
<Query>
<![CDATA[
select * from (
select sum(r.pro_qty) hang_type,
       sum(r.fin_pro_qty) fin_pro_qty,
       sum(r.fin_pro_qty) / sum(r.pro_qty) rate,
       s.house_sche,
       s.house_sche_id
  from DM_RES_TRADE_RULE r,
       DIM_ORG O,
       dim_house_sche s
 where R.DATA_DATE = (SELECT MAX(DATA_DATE) FROM DM_RES_TRADE_RULE)
 and r.org_id=o.org_id
 and r.house_sche_id=s.house_sche_id
 and o.org_type='${depttype}'
 group by s.house_sche ,s.house_sche_id) res
 order by res.house_sche_id]]></Query>
</TableData>
<TableData name="risk_resource" class="com.fr.data.impl.DBTableData">
<Parameters/>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[oracle_test]]></DatabaseName>
</Connection>
<Query>
<![CDATA[select * from (

select res.datetype,
       case res.risk_type_id
         when 1 then
          '进场问题'
         when 2 then
          '规委会问题'
         when 3 then
          '其他'
       end problemtype,
       sum(PRO_QTY) 数量,
       round(sum(PRO_SQ),1) 面积,
       round(SUM(PRO_VALUE),1) 金额,
       sum(NEW_PRO_QTY) 新增数量,
       round(sum(NEW_PRO_SQ),1) 新增面积,
       round(SUM(NEW_PRO_VALUE),1) 新增金额,
       sum(res_PRO_QTY) 上周数量,
       round(sum(res_PRO_SQ),1) 上周面积,
       round(SUM(res_PRO_VALUE),1) 上周金额
  from (select REPLACE(to_char(to_date(week_start, 'yyyymmdd'), 'mm') || '.' ||
                       to_char(to_date(week_start, 'yyyymmdd'), 'dd') || '-' ||
                       to_char(to_date(week_end, 'yyyymmdd'), 'mm') || '.' ||
                       to_char(to_date(week_end, 'yyyymmdd'), 'dd'),
                       '0',
                       '') datetype,
               w.*
          from DM_RES_CHECK_RISK_TRAND_WEEK w
         where w.week_no = 1
           --and w.week_start is not null
           
           and data_date =
               (select max(data_date) from DM_RES_CHECK_RISK_TRAND_WEEK)) res

 GROUP BY res.datetype, res.risk_type_id
 ) res
 where datetype !='.-.'
]]></Query>
</TableData>
<TableData name="anountinway" class="com.fr.data.impl.DBTableData">
<Parameters/>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[oracle_test]]></DatabaseName>
</Connection>
<Query>
<![CDATA[    select sum(f.month0+f.month1+f.month2+f.month3+f.month4+f.month5+f.month6+f.month7
    +f.month8+f.month9+f.month10+f.month11+f.month12+f.month13)/100000000 value
    from dm_res_check_on_order_fund f]]></Query>
</TableData>
<TableData name="CPJL_BZSC" class="com.fr.data.impl.DBTableData">
<Parameters/>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[oracle_test]]></DatabaseName>
</Connection>
<Query>
<![CDATA[WITH W1 AS (
SELECT HOUSE_SCHE_ID,SUM(ACTR_MIN) AS ALL_SUM FROM (
SELECT HOUSE_SCHE_ID,ACTR_MIN FROM DM_RES_TRADE_RULE
) GROUP BY HOUSE_SCHE_ID
), W2 AS (
SELECT HOUSE_SCHE_ID ,SUM(PRO_QTY) AS PRO_SUM FROM (
SELECT DISTINCT ORG_ID,HOUSE_SCHE_ID,PRO_QTY FROM DM_RES_TRADE_RULE
)
 GROUP BY HOUSE_SCHE_ID
),
TRADE_RULE as(
 SELECT W1.HOUSE_SCHE_ID,ROUND(W1.ALL_SUM/W2.PRO_SUM,2) as ACTR_MIN, decode(W1.HOUSE_SCHE_ID,1,-60,3,10,4,40,5,90,6,150,7,300)as STAND_MIN FROM W1 LEFT JOIN W2 ON W1.HOUSE_SCHE_ID = W2.HOUSE_SCHE_ID
),

STAND_ACTR AS(
--标准时长
SELECT HOUSE_SCHE_ID,'标准工期（天）' as names, STAND_MIN as VALUE_S,round((STAND_MIN+60)/16-10,0) AS HSZ FROM TRADE_RULE WHERE STAND_MIN<-60
UNION ALL
SELECT HOUSE_SCHE_ID,'标准工期（天）' as names,STAND_MIN as VALUE_S,round((STAND_MIN)/6-0,0) AS HSZ  FROM TRADE_RULE WHERE STAND_MIN<0 AND STAND_MIN>=-60
UNION ALL
SELECT HOUSE_SCHE_ID,'标准工期（天）' as names,STAND_MIN as VALUE_S,round((STAND_MIN-0)/1+0,0) AS HSZ  FROM TRADE_RULE WHERE STAND_MIN<10 AND STAND_MIN>=0
UNION ALL
SELECT HOUSE_SCHE_ID,'标准工期（天）' as names,STAND_MIN as VALUE_S,round((STAND_MIN-10)/3+10,0) AS HSZ  FROM TRADE_RULE WHERE STAND_MIN<40 AND STAND_MIN>=10
UNION ALL
SELECT HOUSE_SCHE_ID,'标准工期（天）' as names,STAND_MIN as VALUE_S,round((STAND_MIN-40)/5+20,0) AS HSZ  FROM TRADE_RULE WHERE STAND_MIN<90 AND STAND_MIN>=40
UNION ALL
SELECT HOUSE_SCHE_ID,'标准工期（天）' as names,STAND_MIN as VALUE_S,round((STAND_MIN-90)/6+30,0) AS HSZ  FROM TRADE_RULE WHERE STAND_MIN<150 AND STAND_MIN>=90
UNION ALL
SELECT HOUSE_SCHE_ID,'标准工期（天）' as names,STAND_MIN as VALUE_S,round((STAND_MIN-150)/15+40,0) AS HSZ  FROM TRADE_RULE WHERE STAND_MIN<300 AND STAND_MIN>=150
UNION ALL
SELECT HOUSE_SCHE_ID,'标准工期（天）' as names,STAND_MIN as VALUE_S,round((STAND_MIN-300)/20+50,0) AS HSZ  FROM TRADE_RULE WHERE STAND_MIN>=300
UNION ALL
--实际时长
SELECT HOUSE_SCHE_ID,'实际时长（天）' as names,ACTR_MIN as VALUE_S,round((ACTR_MIN+60)/16-10,0) AS HSZ  FROM TRADE_RULE WHERE ACTR_MIN<-60
UNION ALL
SELECT HOUSE_SCHE_ID,'实际时长（天）' as names,ACTR_MIN as VALUE_S,round((ACTR_MIN)/6-0,0) AS HSZ  FROM TRADE_RULE WHERE ACTR_MIN<0 AND ACTR_MIN>=-60
UNION ALL
SELECT HOUSE_SCHE_ID,'实际时长（天）' as names,ACTR_MIN as VALUE_S,round((ACTR_MIN-0)/1+0,0) AS HSZ  FROM TRADE_RULE WHERE ACTR_MIN<10 AND ACTR_MIN>=0
UNION ALL
SELECT HOUSE_SCHE_ID,'实际时长（天）' as names,ACTR_MIN as VALUE_S,round((ACTR_MIN-10)/3+10,0) AS HSZ  FROM TRADE_RULE WHERE ACTR_MIN<40 AND ACTR_MIN>=10
UNION ALL
SELECT HOUSE_SCHE_ID,'实际时长（天）' as names,ACTR_MIN as VALUE_S,round((ACTR_MIN-40)/5+20,0) AS HSZ  FROM TRADE_RULE WHERE ACTR_MIN<90 AND ACTR_MIN>=40
UNION ALL
SELECT HOUSE_SCHE_ID,'实际时长（天）' as names,ACTR_MIN as VALUE_S,round((ACTR_MIN-90)/6+30,0) AS HSZ  FROM TRADE_RULE WHERE ACTR_MIN<150 AND ACTR_MIN>=90
UNION ALL
SELECT HOUSE_SCHE_ID,'实际时长（天）' as names,ACTR_MIN as VALUE_S,round((ACTR_MIN-150)/15+40,0) AS HSZ  FROM TRADE_RULE WHERE ACTR_MIN<300 AND ACTR_MIN>=150
UNION ALL
SELECT HOUSE_SCHE_ID,'实际时长（天）' as names,ACTR_MIN as VALUE_S,round((ACTR_MIN-300)/20+50,0) AS HSZ  FROM TRADE_RULE WHERE ACTR_MIN>=300
)

SELECT
b.HOUSE_SCHE_ID,
b.HOUSE_SCHE||'_'||ROUND(a.VALUE_S,2) AS SNAME,
a.names,
a.VALUE_S,
CASE WHEN A.HSZ>51 THEN 51 
		 WHEN A.HSZ<-15 THEN -15
		 ELSE A.HSZ END HSZ
FROM STAND_ACTR a ,dim_house_sche b
WHERE a.HOUSE_SCHE_ID=b.HOUSE_SCHE_ID
ORDER BY b.HOUSE_SCHE_ID desc,a.names]]></Query>
</TableData>
<TableData name="4" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="org_classify"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="ordertype"/>
<O>
<![CDATA[前十名]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[oracle_test]]></DatabaseName>
</Connection>
<Query>
<![CDATA[select * from (
select  * from (
select distinct r.pro_qty pro_qty,
       r.all_fill as fin_pro_qty,
       decode(r.pro_qty,0,0,(r.all_fill / r.pro_qty)) rate, 
       substr(O.ORG_SNAME,1,3) ORG_SNAME
  from DM_RES_TRADE_RULE r,
       DIM_ORG O,
       dim_house_sche s
 where R.DATA_DATE = (SELECT MAX(DATA_DATE) FROM DM_RES_TRADE_RULE)
 and r.org_id=o.org_id
 and r.house_sche_id=s.house_sche_id
 -- 2018-07-20 update 增加环京外埠参数
 ${if(org_classify="全部","","and o.org_classify='"+org_classify+"'")}
 --and s.house_sche='规划要点-摘牌'
 and o.org_type='区域'
  ) res
 order by nvl(res.rate,0) ${if(ordertype="前十名", "desc","asc")} , nvl(pro_qty,0) ${if(ordertype="前十名", "desc","asc")}, NVL(pro_qty,0) ${if(ordertype="前十名", "desc","asc")}) result
 where rownum <=10
 order by nvl(rate,0) desc, nvl(pro_qty,0) DESC, NVL(pro_qty,0) desc]]></Query>
</TableData>
<TableData name="1" class="com.fr.data.impl.DBTableData">
<Parameters/>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[oracle_test]]></DatabaseName>
</Connection>
<Query>
<![CDATA[/*select r.pro_qty pro_qty,
       sum(r.all_fill) fin_pro_qty,
       decode (sum(r.pro_qty),0,0,sum(r.all_fill) / sum(r.pro_qty)) rate
  from DM_RES_TRADE_RULE r,
  dim_org o
 where R.DATA_DATE = (SELECT MAX(DATA_DATE) FROM DM_RES_TRADE_RULE)
 and r.org_id=o.org_id
 and o.org_name='产业新城'
 group by r.pro_qty
*/
select sum(pro_qty) as pro_qty,sum(all_fill) as fin_pro_qty from (
 select distinct org_id,pro_qty,all_fill
 from dm_res_trade_rule
 where data_date = (select max(data_date) from dm_res_trade_rule)
 )
]]></Query>
</TableData>
<TableData name="tu2" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="org_classify"/>
<O>
<![CDATA[外埠]]></O>
</Parameter>
<Parameter>
<Attributes name="depttype"/>
<O>
<![CDATA[区域]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[oracle_test]]></DatabaseName>
</Connection>
<Query>
<![CDATA[/*
select *
  from (select 
               res.fin_pro_qty,
               res.rate,
               res.house_sche,
               case
                 when res.house_sche_id > 1 then
                  res.house_sche_id + 1
                 else
                  1
               end house_sche_id
          from (select
                       sum(r.fin_pro_qty) fin_pro_qty,
                       sum(r.fin_pro_qty) / sum(r.pro_qty) rate,
                       s.house_sche,
                       s.house_sche_id
                  from DM_RES_TRADE_RULE r, DIM_ORG O, dim_house_sche s
                 where R.DATA_DATE =
                       (SELECT MAX(DATA_DATE) FROM DM_RES_TRADE_RULE)
                   and r.org_id = o.org_id
                   and r.house_sche_id = s.house_sche_id
                   and o.org_type = '区域'
                 group by s.house_sche, s.house_sche_id ) res
        
        union all
        select 
               null fin_pro_qty,
               null rate,
               '摘牌' house_sche,
               2 house_sche_id
          from dual) result
 order by result.house_sche_id
 */
WITH W1 AS (            
SELECT DISTINCT ORG_ID,
       HOUSE_SCHE_ID,
       PRO_QTY,
       NVL(FIN_PRO_QTY,0) AS FIN_PRO_QTY
  FROM DM_RES_TRADE_RULE 
 WHERE DATA_DATE = (SELECT MAX(DATA_DATE) FROM DM_RES_TRADE_RULE)
 -- 2018-07-20 update 增加环京外埠参数
 and org_id in (select org_id from dim_org o where 1=1  ${if(org_classify="全部","","and o.org_classify='"+org_classify+"'")})
 ORDER BY ORG_ID,HOUSE_SCHE_ID
),W2 AS (
 SELECT ORG_ID,
        '区域' AS ORG_TYPE,
        HOUSE_SCHE_ID,
        PRO_QTY,
        FIN_PRO_QTY
   FROM W1
 UNION ALL
 SELECT T1.FATHER_ID,'事业部' AS ORG_TYPE,HOUSE_SCHE_ID,SUM(PRO_QTY) AS PRO_QTY,SUM(FIN_PRO_QTY) AS FIN_PRO_QTY
   FROM W1
   LEFT JOIN DIM_ORG T1 ON W1.ORG_ID = T1.ORG_ID
  GROUP BY T1.FATHER_ID,HOUSE_SCHE_ID
 ORDER BY ORG_TYPE,HOUSE_SCHE_ID
),W3 AS (
 SELECT  TO_NUMBER(HOUSE_SCHE_ID) HOUSE_SCHE_ID,
         SUM(PRO_QTY) PRO_QTY,
         SUM(FIN_PRO_QTY) FIN_PRO_QTY,
         SUM(FIN_PRO_QTY)/SUM(PRO_QTY) rate
   FROM  W2
  WHERE  1=1
    AND  ORG_TYPE = '${depttype}'
  GROUP  BY HOUSE_SCHE_ID
 UNION ALL
 SELECT  2 AS HOUSE_SCHE_ID,
         null,
         null,
         null
   FROM  DUAL
   )
   SELECT T1.HOUSE_SCHE,
          W3.*
    FROM W3
    LEFT JOIN DIM_HOUSE_SCHE T1 ON W3.HOUSE_SCHE_ID = T1.HOUSE_SCHE_ID
   ORDER BY W3.HOUSE_SCHE_ID 
]]></Query>
</TableData>
<TableData name="risk_sum" class="com.fr.data.impl.DBTableData">
<Parameters/>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[oracle_test]]></DatabaseName>
</Connection>
<Query>
<![CDATA[--select case risk_type_id when 2 then (select count(distinct ProjectID)   from
--           bass_ods.ods_V_Operate_StatuteCommittee
--where nvl(IsResolved,0)!= 1) when 1 then (select count(distinct ProjectID)   from
--           bass_ods.ods_V_Operate_EnterSite
--where nvl(IsResolved,0)!= 1)  when 3 then
--(select count(distinct ProjectID) a  from bass_ods.ods_V_OperateOther  where nvl(IsResolved,0)!= 1)
--else 
--null
--end 
select  pro_qty ,
pro_sq,
pro_value,risk_type_id  from (
  select sum(pro_qty) pro_qty,round(sum(pro_sq),1) pro_sq ,round(sum(pro_value),1) pro_value,risk_type_id from DM_RES_RISK_RESOURCE r ,dim_org o 
 where r.org_id=o.org_id
 and  r.risk_type_id in ('1','2','3')
 and  org_type='区域'
 group by risk_type_id
 )]]></Query>
</TableData>
<TableData name="ds1" class="com.fr.data.impl.DBTableData">
<Parameters/>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[oracle_test]]></DatabaseName>
</Connection>
<Query>
<![CDATA[WITH W1 AS (
SELECT HOUSE_SCHE_ID,SUM(ACTR_MIN) AS ALL_SUM FROM (
SELECT HOUSE_SCHE_ID,ACTR_MIN FROM DM_RES_TRADE_RULE
) GROUP BY HOUSE_SCHE_ID
), W2 AS (
SELECT HOUSE_SCHE_ID ,SUM(PRO_QTY) AS PRO_SUM FROM (
SELECT DISTINCT ORG_ID,HOUSE_SCHE_ID,PRO_QTY FROM DM_RES_TRADE_RULE
)
 GROUP BY HOUSE_SCHE_ID
)
 SELECT W1.HOUSE_SCHE_ID,ROUND(W1.ALL_SUM/W2.PRO_SUM,2) as ACTR_MIN, decode(W1.HOUSE_SCHE_ID,1,-60,3,10,4,40,5,90,6,150,7,300)as STAND_MIN FROM W1 LEFT JOIN W2 ON W1.HOUSE_SCHE_ID = W2.HOUSE_SCHE_ID
]]></Query>
</TableData>
<TableData name="traderdisciplineareanum" class="com.fr.data.impl.DBTableData">
<Parameters/>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[oracle_test]]></DatabaseName>
</Connection>
<Query>
<![CDATA[select  '操盘纪律考核区域'||count(*)||'个' description  from (
SELECT DISTINCT area_org FROM BASS_ODS.ODS_DISCIPLINE_BENCHMARKS)

]]></Query>
</TableData>
<TableData name="ds2" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="org_classify"/>
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
<![CDATA[WITH date2 as ( 
select count(1) sum_day
  from dim_period a,
       (select period_month, period_year
          from dim_period a
         where a.period_key =
               (select data_date from dm_res_trade_rule where rownum = 1) ) date1
 where a.period_year = date1.period_year
   and a.period_month = date1.period_month
)
,
W1 AS (
SELECT HOUSE_SCHE_ID,SUM(ACTR_MIN) AS ALL_SUM FROM (
SELECT HOUSE_SCHE_ID,ACTR_MIN FROM DM_RES_TRADE_RULE
where 1=1 
-- 2018-07-20 update 增加环京外埠参数
 and org_id in (select org_id from dim_org o where 1=1  ${if(org_classify="全部","","and o.org_classify='"+org_classify+"'")})
) GROUP BY HOUSE_SCHE_ID
), W2 AS (
SELECT HOUSE_SCHE_ID ,SUM(PRO_QTY) AS PRO_SUM FROM (
SELECT DISTINCT ORG_ID,HOUSE_SCHE_ID,PRO_QTY FROM DM_RES_TRADE_RULE
)
 GROUP BY HOUSE_SCHE_ID
)
,


TRADE_RULE as(
 SELECT W1.HOUSE_SCHE_ID,ROUND(W1.ALL_SUM/W2.PRO_SUM/date2.sum_day,1) as ACTR_MIN, 
 round(decode(W1.HOUSE_SCHE_ID,1,-60,3,10,4,40,5,90,6,150,7,300)/date2.sum_day, 1) as STAND_MIN 
 FROM W1 LEFT JOIN W2 ON W1.HOUSE_SCHE_ID = W2.HOUSE_SCHE_ID left join date2 on 1=1
)

--SELECT * FROM TRADE_RULE;
--SELECT HOUSE_SCHE_ID,'标准工期（天）' as names, STAND_MIN as VALUE_S,round((STAND_MIN+60)/16-10,0) AS HSZ FROM TRADE_RULE WHERE STAND_MIN>=-60;
,

STAND_ACTR AS(
--标准时长
SELECT HOUSE_SCHE_ID,  STAND_MIN as VALUE_S,round((STAND_MIN+60)/16-10,0) AS HSZ FROM TRADE_RULE WHERE STAND_MIN<-60
UNION ALL
SELECT HOUSE_SCHE_ID, STAND_MIN as VALUE_S,round((STAND_MIN)/6-0,0) AS HSZ  FROM TRADE_RULE WHERE STAND_MIN<0 AND STAND_MIN>=-60
UNION ALL
SELECT HOUSE_SCHE_ID, STAND_MIN as VALUE_S,round((STAND_MIN-0)/1+0,0) AS HSZ  FROM TRADE_RULE WHERE STAND_MIN<10 AND STAND_MIN>=0
UNION ALL
SELECT HOUSE_SCHE_ID, STAND_MIN as VALUE_S,round((STAND_MIN-10)/3+10,0) AS HSZ  FROM TRADE_RULE WHERE STAND_MIN<40 AND STAND_MIN>=10
UNION ALL
SELECT HOUSE_SCHE_ID, STAND_MIN as VALUE_S,round((STAND_MIN-40)/5+20,0) AS HSZ  FROM TRADE_RULE WHERE STAND_MIN<90 AND STAND_MIN>=40
UNION ALL
SELECT HOUSE_SCHE_ID, STAND_MIN as VALUE_S,round((STAND_MIN-90)/6+30,0) AS HSZ  FROM TRADE_RULE WHERE STAND_MIN<150 AND STAND_MIN>=90
UNION ALL
SELECT HOUSE_SCHE_ID, STAND_MIN as VALUE_S,round((STAND_MIN-150)/15+40,0) AS HSZ  FROM TRADE_RULE WHERE STAND_MIN<300 AND STAND_MIN>=150
UNION ALL
SELECT HOUSE_SCHE_ID, STAND_MIN as VALUE_S,round((STAND_MIN-300)/20+50,0) AS HSZ  FROM TRADE_RULE WHERE STAND_MIN>=300
),
ACT_ACTR AS(
--实际时长
SELECT HOUSE_SCHE_ID, ACTR_MIN as VALUE_S,round((ACTR_MIN+60)/16-10,0) AS HSZ  FROM TRADE_RULE WHERE ACTR_MIN<-60
UNION ALL
SELECT HOUSE_SCHE_ID, ACTR_MIN as VALUE_S,round((ACTR_MIN)/6-0,0) AS HSZ  FROM TRADE_RULE WHERE ACTR_MIN<0 AND ACTR_MIN>=-60
UNION ALL
SELECT HOUSE_SCHE_ID, ACTR_MIN as VALUE_S,round((ACTR_MIN-0)/1+0,0) AS HSZ  FROM TRADE_RULE WHERE ACTR_MIN<10 AND ACTR_MIN>=0
UNION ALL
SELECT HOUSE_SCHE_ID, ACTR_MIN as VALUE_S,round((ACTR_MIN-10)/3+10,0) AS HSZ  FROM TRADE_RULE WHERE ACTR_MIN<40 AND ACTR_MIN>=10
UNION ALL
SELECT HOUSE_SCHE_ID, ACTR_MIN as VALUE_S,round((ACTR_MIN-40)/5+20,0) AS HSZ  FROM TRADE_RULE WHERE ACTR_MIN<90 AND ACTR_MIN>=40
UNION ALL
SELECT HOUSE_SCHE_ID, ACTR_MIN as VALUE_S,round((ACTR_MIN-90)/6+30,0) AS HSZ  FROM TRADE_RULE WHERE ACTR_MIN<150 AND ACTR_MIN>=90
UNION ALL
SELECT HOUSE_SCHE_ID, ACTR_MIN as VALUE_S,round((ACTR_MIN-150)/15+40,0) AS HSZ  FROM TRADE_RULE WHERE ACTR_MIN<300 AND ACTR_MIN>=150
UNION ALL
SELECT HOUSE_SCHE_ID, ACTR_MIN as VALUE_S,round((ACTR_MIN-300)/20+50,0) AS HSZ  FROM TRADE_RULE WHERE ACTR_MIN>=300
)
,
STAND AS (
SELECT
b.HOUSE_SCHE_ID,
CASE 
  WHEN B.HOUSE_SCHE_ID=1 THEN B.HOUSE_SCHE||'（2）'
  WHEN B.HOUSE_SCHE_ID=5 THEN B.HOUSE_SCHE||'（3）'
  WHEN B.HOUSE_SCHE_ID=6 THEN B.HOUSE_SCHE||'（5）'
  WHEN B.HOUSE_SCHE_ID=7 THEN B.HOUSE_SCHE||'（10）'
  ELSE B.HOUSE_SCHE
END AS SNAME,
a.VALUE_S,

CASE WHEN A.HSZ>51 THEN 51 
     WHEN A.HSZ<-15 THEN -15
     ELSE A.HSZ END HSZ
FROM STAND_ACTR a right join dim_house_sche b
on a.HOUSE_SCHE_ID=b.HOUSE_SCHE_ID
ORDER BY b.HOUSE_SCHE_ID 
),

ACT AS (
SELECT
b.HOUSE_SCHE_ID,
b.HOUSE_SCHE SNAME,
a.VALUE_S,
CASE WHEN A.HSZ>51 THEN 51 
     WHEN A.HSZ<-15 THEN -15
     ELSE A.HSZ END HSZ
FROM ACT_ACTR a right join dim_house_sche b
on a.HOUSE_SCHE_ID=b.HOUSE_SCHE_ID
ORDER BY b.HOUSE_SCHE_ID 
)

SELECT S.HOUSE_SCHE_ID, S.SNAME, a.sname sname2, A.VALUE_S,
CASE 
  WHEN s.HOUSE_SCHE_ID=1 THEN -2
  WHEN s.HOUSE_SCHE_ID=5 THEN 3
  WHEN s.HOUSE_SCHE_ID=6 THEN 5
  WHEN s.HOUSE_SCHE_ID=7 THEN 10
  ELSE 0 END AS target
FROM STAND S, ACT A 
where S.HOUSE_SCHE_ID=A.HOUSE_SCHE_ID
and S.HOUSE_SCHE_ID<>2
order by S.HOUSE_SCHE_ID desc]]></Query>
</TableData>
<TableData name="ds3" class="com.fr.data.impl.DBTableData">
<Parameters/>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[oracle_test]]></DatabaseName>
</Connection>
<Query>
<![CDATA[

select sum(pro_qty) as pro_qty,sum(all_fill) as fin_pro_qty,round(decode(sum(pro_qty),0,0,sum(all_fill) / sum(pro_qty)),4) rate from (
 select distinct org_id,pro_qty,all_fill
 from dm_res_trade_rule
 where data_date = (select max(data_date) from dm_res_trade_rule)
 and org_id in (select org_id from dim_org where 1=1  )
 )
]]></Query>
</TableData>
</TableDataMap>
<FormMobileAttr>
<FormMobileAttr refresh="false" isUseHTML="false" isMobileOnly="false" isAdaptivePropertyAutoMatch="false"/>
</FormMobileAttr>
<Parameters>
<Parameter>
<Attributes name="cpcs"/>
<O>
<![CDATA[1]]></O>
</Parameter>
<Parameter>
<Attributes name="depttype"/>
<O>
<![CDATA[区域]]></O>
</Parameter>
<Parameter>
<Attributes name="pm"/>
<O>
<![CDATA[1]]></O>
</Parameter>
<Parameter>
<Attributes name="gzp"/>
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
<WidgetName name="report15"/>
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
<WidgetName name="report15"/>
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
<![CDATA[5410200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="1" s="0">
<O t="RichText">
<RichText>
<RichChar styleIndex="1">
<text>
<![CDATA[规划要点-摘牌]]></text>
</RichChar>
<RichChar styleIndex="2">
<text>
<![CDATA[（2）]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="2" s="0">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="3" s="0">
<O t="RichText">
<RichText>
<RichChar styleIndex="1">
<text>
<![CDATA[摘牌-土地及桩基进场]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="4" s="0">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="5" s="0">
<O t="RichText">
<RichText>
<RichChar styleIndex="1">
<text>
<![CDATA[摘牌-规划方案政府审批]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="6" s="0">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="7" s="0">
<O t="RichText">
<RichText>
<RichChar styleIndex="1">
<text>
<![CDATA[摘牌-示范区开放]]></text>
</RichChar>
<RichChar styleIndex="2">
<text>
<![CDATA[（3）]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="8" s="0">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="9" s="0">
<O t="RichText">
<RichText>
<RichChar styleIndex="1">
<text>
<![CDATA[摘牌-开盘]]></text>
</RichChar>
<RichChar styleIndex="2">
<text>
<![CDATA[（5）]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="10" s="0">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="11" s="0">
<O t="RichText">
<RichText>
<RichChar styleIndex="1">
<text>
<![CDATA[摘牌-现金流回正]]></text>
</RichChar>
<RichChar styleIndex="2">
<text>
<![CDATA[（10）]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="12" s="0">
<O>
<![CDATA[ ]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 1]]></Formula>
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
<Style horizontal_alignment="4" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="64"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="88" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="88" foreground="-16712961"/>
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
<WidgetName name="report15"/>
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
<![CDATA[5410200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="1" s="0">
<O t="RichText">
<RichText>
<RichChar styleIndex="1">
<text>
<![CDATA[规划要点-摘牌]]></text>
</RichChar>
<RichChar styleIndex="2">
<text>
<![CDATA[（2）]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="2" s="0">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="3" s="0">
<O t="RichText">
<RichText>
<RichChar styleIndex="1">
<text>
<![CDATA[摘牌-土地及桩基进场]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="4" s="0">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="5" s="0">
<O t="RichText">
<RichText>
<RichChar styleIndex="1">
<text>
<![CDATA[摘牌-规划方案政府审批]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="6" s="0">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="7" s="0">
<O t="RichText">
<RichText>
<RichChar styleIndex="1">
<text>
<![CDATA[摘牌-示范区开放]]></text>
</RichChar>
<RichChar styleIndex="2">
<text>
<![CDATA[（3）]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="8" s="0">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="9" s="0">
<O t="RichText">
<RichText>
<RichChar styleIndex="1">
<text>
<![CDATA[摘牌-开盘]]></text>
</RichChar>
<RichChar styleIndex="2">
<text>
<![CDATA[（5）]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="10" s="0">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="11" s="0">
<O t="RichText">
<RichText>
<RichChar styleIndex="1">
<text>
<![CDATA[摘牌-现金流回正]]></text>
</RichChar>
<RichChar styleIndex="2">
<text>
<![CDATA[（10）]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="12" s="0">
<O>
<![CDATA[ ]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 1]]></Formula>
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
<Style horizontal_alignment="4" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="64"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="88" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="88" foreground="-16712961"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</body>
</InnerWidget>
<BoundsAttr x="93" y="199" width="103" height="218"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report9_c_c_c_c"/>
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
<WidgetName name="report9_c_c_c_c"/>
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
<![CDATA[0,1440000,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[0,144000,1440000,144000,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="1" s="0">
<O t="Image">
<IM>
<![CDATA[!NlK$rJ=?G7h#eD$31&+%7s)Y;?-[s,QIfE,R=SS!!(sXR$[jR!d.(&5u`*!m?UI;<)F@MDg
meX$&!m97W=JAS5fq7BG7lag:2ri<mf8\d*a)k8>S/*0pi>!&BSVEd]AFHYr0S72/+MX[Y1pJ
r&a">P/oR<jcSmX]A[!7KnQ[@$Xh"0R>Hf'5U!6dm[\HBc80i/;NDZCYr):afEL@S/jGUXLnN
VBdJ9S&/5KZ]As:UGbqO<!maWeYZhKiu@:,E1M%mA$2Pl:n+Dt'=mG-/foZ854pRK]Ae^d@DWn
-gi?od'H4mQ_"+=HU#9$C;Y>+=F?Dh3SA(jep:jJU=6-X3:1>KPF0_,W[Hq["u;dAnbm$G;r
Y1)5U&1t8FC=_"F`FTS/!'br5m-js+MGmiS[^<2?f?#rY7!g&-C-`TFAElO)OHUl\5S^[j_<
X,8e,sN:oeP0A\H%^3#"Ut?OlhpSndErtb>$g28%:WXL:oabfo,$YS(SUsXf#,"Y*2XHP:N;
4[_AC')h%]Ab*QIC)[-rF4Zgh@'5ZtOE0D\C\FbTuqhKk+G2P,$p1s&eQ?tVP@`eo/P7UhRaJ
FW`6h;)a0j9l$C*r/uiL=f+ZhDRp]A%#:OhorbLOplI#!,[4u(g*U1i_L^j`pg3fS90DGC8>&
T%fhht"o,HfJ</70WooPg2W'3P?>(G%;Il\GEnBo>sHO]AK*Z&FqqO[OX!9tLV(J"[#uR<TP8
l6)_7/3q.'U?FiD75o^IbO46i=C%m96?1-U9E@o!iTg^]AW)ck-Fi<CNHchFq,ki.81`)5uos
NAVIdKBa(u<uB+MXq3$?<$9;9mduDZ)h5UiQcsJRY;P*p=I5W^9gRHM*!m!!!!j78?7R6=>B
~
]]></IM>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="1" r="2" cs="3" s="1">
<O>
<![CDATA[ 摘牌]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 1]]></Formula>
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
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="64" foreground="-65536"/>
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
<WidgetName name="report9"/>
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
<BoundsAttr x="232" y="407" width="30" height="42"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report13"/>
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
<WidgetName name="report13"/>
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
<![CDATA[2971800,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[4762500,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 1]]></Formula>
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
<FRFont name="SimSun" style="0" size="72"/>
<Background name="ColorBackground" color="-16377030"/>
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
<WidgetName name="report13"/>
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
<![CDATA[2971800,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[4762500,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 1]]></Formula>
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
<FRFont name="SimSun" style="0" size="72"/>
<Background name="ColorBackground" color="-16377030"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</body>
</InnerWidget>
<BoundsAttr x="231" y="407" width="36" height="36"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report10_c"/>
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
<WidgetName name="report10_c"/>
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
<![CDATA[152400,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[10515600,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="1" s="0">
<O t="DSColumn">
<Attributes dsName="traderdisciplineareanum" columnName="DESCRIPTION"/>
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
<Style horizontal_alignment="4" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="56" foreground="-12477447"/>
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
<WidgetName name="report10"/>
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
<![CDATA[152400,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[10515600,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="1" s="0">
<O t="DSColumn">
<Attributes dsName="操盘纪律区域数" columnName="DESCRIPTION"/>
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
<FRFont name="微软雅黑" style="0" size="56" foreground="-12477447"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</body>
</InnerWidget>
<BoundsAttr x="318" y="446" width="193" height="27"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<Listener event="click">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[setTimeout(function() {  
    //隐藏报表块report0的滚动条（此报表块名为report0，根据具体情况修改）  
    $("div[widgetname=REPORT14]A").find(".frozen-north")[14]A.style.overflow = "hidden";  
    $("div[widgetname=REPORT14]A").find(".frozen-center")[14]A.style.overflow = "hidden";  
}, 100);  
  
window.flag = true;  
//鼠标悬停，滚动停止    
setTimeout(function() {  
    $(".frozen-center").mouseover(function() {  
        window.flag = false;  
    });  
  
    //鼠标离开，继续滚动    
    $(".frozen-center").mouseleave(function() {  
        window.flag = true;  
    });  
  
    var old = -1;  
    var interval = setInterval(function() {  
        if(window.flag) {  
            currentpos = $(".frozen-center")[14]A.scrollTop;  
            if(currentpos == old) {  
                $(".frozen-center")[14]A.scrollTop = 0;  
            } else {  
                old = currentpos;  
                //以25ms的速度每次滚动1.5PX    
                $(".frozen-center")[14]A.scrollTop = currentpos + 1.5;  
            }  
        }  
    }, 200);  
}, 1000);  ]]></Content>
</JavaScript>
</Listener>
<Listener event="afterinit">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[var timer1 = setTimeout(function(){
 		  var _x = $('.slimScrollBarY')[0]A;
 		  if(_x){
$('.slimScrollBarY').eq(35).css('width','15px'); //Y轴宽
$('.slimScrollBarX').eq(35).css('height','15px');//X轴高
$('.slimScrollBarX').eq(35).css('background','#227087');//X轴颜色
$('.slimScrollBarX').eq(35).css('opacity','0.99');//X轴透明度
$('.slimScrollBarY').eq(35).css('background','#227087');//Y轴颜色
$('.slimScrollBarY').eq(35).css('opacity','0.99');//Y轴透明度    
 			 clearInterval(timer1);
 			 }
 	  	},1000);]]></Content>
</JavaScript>
</Listener>
<WidgetName name="report14"/>
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
<WidgetName name="report14"/>
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
<HR F="0" T="1"/>
<FR/>
<HC/>
<FC/>
<UPFCR COLUMN="false" ROW="true"/>
</ReportPageAttr>
<ColumnPrivilegeControl/>
<RowPrivilegeControl/>
<RowHeight defaultValue="723900">
<![CDATA[0,864000,1008000,1008000,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[619200,2743200,2880000,2880000,4152900,0,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1" s="0">
<O>
<![CDATA[区域]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="1" s="1">
<O>
<![CDATA[项目]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="1" s="2">
<O>
<![CDATA[亩数]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="1" s="3">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(gzp=1,"计划摘牌时间","挂牌时间")]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="2">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$gzp = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="1" r="2" s="4">
<O t="DSColumn">
<Attributes dsName="TGP" columnName="ORG_SNAME"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper">
<Attr divideMode="1"/>
</RG>
<Parameters/>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[isnull($$$)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="2" r="2" s="4">
<O t="DSColumn">
<Attributes dsName="TGP" columnName="PLOT_NAME"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="2">
<ToolTipText>
<![CDATA[=$$$]]></ToolTipText>
</CellGUIAttr>
<CellPageAttr/>
<Present class="com.fr.base.present.DictPresent">
<Dictionary class="com.fr.data.impl.FormulaDictionary">
<FormulaDict>
<![CDATA[=$$$]]></FormulaDict>
<EFormulaDict>
<![CDATA[=if(len($$$) < 10, $$$, left($$$, 8) + "...")]]></EFormulaDict>
</Dictionary>
</Present>
<Expand dir="0" extendable="3"/>
</C>
<C c="3" r="2" s="5">
<O t="DSColumn">
<Attributes dsName="TGP" columnName="AREA_LAND"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=$$$ + if(len($$$) = 0, "", "亩")]]></Content>
</Present>
<Expand dir="0"/>
</C>
<C c="4" r="2" s="6">
<O t="DSColumn">
<Attributes dsName="TGP" columnName="DEAL_DATE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="5" r="2" s="7">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="<marquee id='affiche' style='text-align:center;' behavior='scroll' behavior='scroll' bgcolor='#ffffff' direction='up' height='250' width='400' hspace='0' vspace='2' loop='-1' scrollamount='10' scrolldelay='100' onMouseOut='this.start()' onMouseOver='this.stop()'>" + REPLACE(B3 + "             " + C3 + "亩             " + E3, ",", "<br /><br />") + "</marquee>"]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="0" r="3">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$gzp = 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="1" r="3" s="4">
<O t="DSColumn">
<Attributes dsName="WGP" columnName="ORG_SNAME"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper">
<Attr divideMode="1"/>
</RG>
<Parameters/>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[isnull($$$)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="2" r="3" s="4">
<O t="DSColumn">
<Attributes dsName="WGP" columnName="PLOT_NAME"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="2">
<ToolTipText>
<![CDATA[=$$$]]></ToolTipText>
</CellGUIAttr>
<CellPageAttr/>
<Present class="com.fr.base.present.DictPresent">
<Dictionary class="com.fr.data.impl.FormulaDictionary">
<FormulaDict>
<![CDATA[=$$$]]></FormulaDict>
<EFormulaDict>
<![CDATA[=if(len($$$) < 10, $$$, left($$$, 8) + "...")]]></EFormulaDict>
</Dictionary>
</Present>
<Expand dir="0" extendable="3"/>
</C>
<C c="3" r="3" s="5">
<O t="DSColumn">
<Attributes dsName="WGP" columnName="AREA_LAND"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=$$$ + if(len($$$) = 0, "", "亩")]]></Content>
</Present>
<Expand dir="0"/>
</C>
<C c="4" r="3" s="6">
<O t="DSColumn">
<Attributes dsName="WGP" columnName="HANG_DATE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="5" r="3" s="7">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="<marquee id='affiche' style='text-align:center;' behavior='scroll' behavior='scroll' bgcolor='#ffffff' direction='up' height='250' width='400' hspace='0' vspace='2' loop='-1' scrollamount='10' scrolldelay='100' onMouseOut='this.start()' onMouseOver='this.stop()'>" + REPLACE(B4 + "             " + C4 + "亩             " + E4, ",", "<br /><br />") + "</marquee>"]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
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
<Style horizontal_alignment="2" imageLayout="1" paddingLeft="4">
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
<Background name="ColorBackground" color="-16569783"/>
<Border>
<Top style="1" color="-16551286"/>
<Bottom style="1" color="-16551286"/>
<Left style="1" color="-16551286"/>
</Border>
</Style>
<Style horizontal_alignment="2" imageLayout="1" paddingLeft="4">
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
<Background name="ColorBackground" color="-16569783"/>
<Border>
<Top style="1" color="-16551286"/>
<Bottom style="1" color="-16551286"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
<Background name="ColorBackground" color="-16569783"/>
<Border>
<Top style="1" color="-16551286"/>
<Bottom style="1" color="-16551286"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
<Background name="ColorBackground" color="-16569783"/>
<Border>
<Top style="1" color="-16551286"/>
<Bottom style="1" color="-16551286"/>
<Right style="1" color="-16551286"/>
</Border>
</Style>
<Style horizontal_alignment="2" imageLayout="1" paddingLeft="4">
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="64" foreground="-16713985"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-16556425"/>
<Bottom style="1" color="-16556425"/>
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
<WidgetName name="report14"/>
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
<C c="0" r="0">
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
<BoundsAttr x="525" y="173" width="315" height="111"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report11_c_c_c_c"/>
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
<WidgetName name="report11_c_c_c_c"/>
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
<![CDATA[952500,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[1066800,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O t="Image">
<IM>
<![CDATA[!@e-#reXHH7h#eD$31&+%7s)Y;?-[s$NL/,%L<7=!!)h'k*5oH!:`WK5u`*!D:6U"!`8s;n\
MYK.ucek0O73d(kR[E2MJLOnJMHGp';i<:5Q\OL@0s8>tA1aQU4&"rWbVqAt6i$iFBTCk$5p
3L?9.d@uSA_J.Yt.p9G)#0Y#Y`NcN%@*5hs1W$6oo2S7,#/V5AJit>5N,q`G6%7k3H':dtdA
*'5]AX9!T?nUVr\0uH'c]A/q(&/$/6@e%&MNqisg#3E,`CS"4e^"jQgs3/[LK.q6e5)IN9U0f$
o/a?#CM!7+d**/AddXCogO$0+nKWaHnNjg+Ub]A=Qk1^=#r_q-CJCRAPjg3n$1*+)(hFMNDr'
4E0Qc!!!!j78?7R6=>B~
]]></IM>
</O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="JavaScript脚本1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[window.parent.FS.tabPane.addItem({title:"风险房源",src:"${servletURL}?formlet=HX_RESIDENCE/HX_RES_RISK.frm"})]]></Content>
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
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="250" height="150"/>
</Widget>
<body class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="report11"/>
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
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
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
</Background>
<Alpha alpha="1.0"/>
</Border>
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
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
<BoundsAttr x="829" y="303" width="18" height="19"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report11_c_c_c"/>
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
<WidgetName name="report11_c_c_c"/>
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
<![CDATA[990600,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[1066800,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O t="Image">
<IM>
<![CDATA[!@e-#reXHH7h#eD$31&+%7s)Y;?-[s$NL/,%L<7=!!)h'k*5oH!:`WK5u`*!D:6U"!`8s;n\
MYK.ucek0O73d(kR[E2MJLOnJMHGp';i<:5Q\OL@0s8>tA1aQU4&"rWbVqAt6i$iFBTCk$5p
3L?9.d@uSA_J.Yt.p9G)#0Y#Y`NcN%@*5hs1W$6oo2S7,#/V5AJit>5N,q`G6%7k3H':dtdA
*'5]AX9!T?nUVr\0uH'c]A/q(&/$/6@e%&MNqisg#3E,`CS"4e^"jQgs3/[LK.q6e5)IN9U0f$
o/a?#CM!7+d**/AddXCogO$0+nKWaHnNjg+Ub]A=Qk1^=#r_q-CJCRAPjg3n$1*+)(hFMNDr'
4E0Qc!!!!j78?7R6=>B~
]]></IM>
</O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="JavaScript脚本1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[window.parent.FS.tabPane.addItem({title:"挂牌土地",src:"${servletURL}?formlet=HX_RESIDENCE/HX_RES_LISTED_LAND.frm"})]]></Content>
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
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="250" height="150"/>
</Widget>
<body class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="report11"/>
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
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
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
</Background>
<Alpha alpha="1.0"/>
</Border>
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
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
<BoundsAttr x="828" y="126" width="18" height="19"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report9"/>
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
<WidgetName name="report9"/>
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
<![CDATA[432000,1872000,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[4608000,3168000,2743200,2743200,2592000,2743200,2592000,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="0" cs="4" rs="2" s="0">
<O t="RichText">
<RichText>
<RichChar styleIndex="1">
<text>
<![CDATA[共]]></text>
</RichChar>
<RichChar styleIndex="2">
<text>
<![CDATA[${=COUNT(VALUE(if ( $gzp=1, "TGP","WGP"),2))}]]></text>
</RichChar>
<RichChar styleIndex="1">
<text>
<![CDATA[块（]]></text>
</RichChar>
<RichChar styleIndex="2">
<text>
<![CDATA[${=ROUND(SUM(VALUE(if ( $gzp=1, "TGP","WGP"),2)),0)}]]></text>
</RichChar>
<RichChar styleIndex="1">
<text>
<![CDATA[亩）]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="0" r="1" s="3">
<O>
<![CDATA[已挂牌未摘牌]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="当前表单对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="gzp"/>
<O>
<![CDATA[1]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report9"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="CopyOf当前表单对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="gzp"/>
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
<Attributes name="gzp"/>
<O>
<![CDATA[1]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report14"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="JavaScript脚本4">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[var timer1 = setTimeout(function(){
 		  var _x = $('.slimScrollBarY')[0]A;
 		  if(_x){
$('.slimScrollBarY').eq(35).css('width','15px'); //Y轴宽
$('.slimScrollBarX').eq(35).css('height','15px');//X轴高
$('.slimScrollBarX').eq(35).css('background','#227087');//X轴颜色
$('.slimScrollBarX').eq(35).css('opacity','0.99');//X轴透明度
$('.slimScrollBarY').eq(35).css('background','#227087');//Y轴颜色
$('.slimScrollBarY').eq(35).css('opacity','0.99');//Y轴透明度    
 			 clearInterval(timer1);
 			 }
 	  	},1000);]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$gzp=1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320!n%B?/B>R2,VO(tmK?F%Sh?$H'm&6gfZ;fT^r(-\bd!HkLBPnYWi
0I@nGF-;-eg`\B!TYP.u2tu4R^J<`3;LmJ`/0_6cO<sS$d5d`#p%C"p\oJL0KTF(\egcb4[E
?1Dq%<r0BqN[?oVr5_3LEe%Z\a)]A:bDrERo6,r>W&~
]]></IM>
</Background>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="1" r="1" s="3">
<O>
<![CDATA[计划挂牌]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="当前表单对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="gzp"/>
<O>
<![CDATA[0]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report9"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="CopyOf当前表单对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="gzp"/>
<O>
<![CDATA[0]]></O>
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
<Attributes name="gzp"/>
<O>
<![CDATA[0]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report14"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="JavaScript脚本4">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[var timer1 = setTimeout(function(){
 		  var _x = $('.slimScrollBarY')[0]A;
 		  if(_x){
$('.slimScrollBarY').eq(35).css('width','15px'); //Y轴宽
$('.slimScrollBarX').eq(35).css('height','15px');//X轴高
$('.slimScrollBarX').eq(35).css('background','#227087');//X轴颜色
$('.slimScrollBarX').eq(35).css('opacity','0.99');//X轴透明度
$('.slimScrollBarY').eq(35).css('background','#227087');//Y轴颜色
$('.slimScrollBarY').eq(35).css('opacity','0.99');//Y轴透明度    
 			 clearInterval(timer1);
 			 }
 	  	},1000);]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$gzp=0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320!n%B?/B>R2,VO(tmK?F%Sh?$H'm&6gfZ;fT^r(-\bd!HkLBPnYWi
0I@nGF-;-eg`\B!TYP.u2tu4R^J<`3;LmJ`/0_6cO<sS$d5d`#p%C"p\oJL0KTF(\egcb4[E
?1Dq%<r0BqN[?oVr5_3LEe%Z\a)]A:bDrERo6,r>W&~
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
<Style horizontal_alignment="4" vertical_alignment="3" imageLayout="1">
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
<FRFont name="微软雅黑" style="0" size="152" foreground="-16712961"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
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
<WidgetName name="report9"/>
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
<BoundsAttr x="540" y="147" width="290" height="24"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report5_c_c"/>
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
<WidgetName name="report5_c_c"/>
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
<![CDATA[8153400,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O>
<![CDATA[风险房源]]></O>
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
<Style horizontal_alignment="2" imageLayout="1">
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
<![CDATA[8153400,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O>
<![CDATA[挂牌土地信息]]></O>
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
<Style horizontal_alignment="2" imageLayout="1">
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
<BoundsAttr x="525" y="303" width="208" height="21"/>
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
<UPFCR COLUMN="false" ROW="true"/>
</ReportPageAttr>
<ColumnPrivilegeControl/>
<RowPrivilegeControl/>
<RowHeight defaultValue="723900">
<![CDATA[723900,723900,2019300,2304000,2590800,2590800,2590800,2590800,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[1440000,2880000,2880000,2880000,6781800,5410200,1600200,4752000,3168000,2880000,720000,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="1">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="2" cs="4" s="0">
<O>
<![CDATA[进场问题]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="2" s="1">
<O>
<![CDATA[本周新增]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="2" cs="3" s="2">
<O t="RichText">
<RichText>
<RichChar styleIndex="3">
<text>
<![CDATA[${=e9}]]></text>
</RichChar>
<RichChar styleIndex="4">
<text>
<![CDATA[${=if(len(e9)=0,"","个批次")}]]></text>
</RichChar>
<RichChar styleIndex="3">
<text>
<![CDATA[${=f9}]]></text>
</RichChar>
<RichChar styleIndex="4">
<text>
<![CDATA[${=if(len(f9)=0,"","万平")}]]></text>
</RichChar>
<RichChar styleIndex="3">
<text>
<![CDATA[${=g9}]]></text>
</RichChar>
<RichChar styleIndex="4">
<text>
<![CDATA[${=if(len(g9)=0,"","亿元")}]]></text>
</RichChar>
<RichChar styleIndex="5">
<text>
<![CDATA[${=if(and(len(e9)=0,len(f9)=0,len(g9)=0),"无","")}]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="1" r="3" cs="4" s="6">
<O t="RichText">
<RichText>
<RichChar styleIndex="3">
<text>
<![CDATA[${=b12}]]></text>
</RichChar>
<RichChar styleIndex="4">
<text>
<![CDATA[${=if(len(b12)=0,"","个批次 ")}]]></text>
</RichChar>
<RichChar styleIndex="3">
<text>
<![CDATA[${=c12}]]></text>
</RichChar>
<RichChar styleIndex="4">
<text>
<![CDATA[${=if(len(c12)=0,"","万平")}]]></text>
</RichChar>
<RichChar styleIndex="3">
<text>
<![CDATA[${=d12}]]></text>
</RichChar>
<RichChar styleIndex="4">
<text>
<![CDATA[${=if(len(d12)=0,"","亿元")}]]></text>
</RichChar>
<RichChar styleIndex="5">
<text>
<![CDATA[${=if(and(len(b12)=0,len(c12)=0,len(d12)=0),"无","")}]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="5" r="3" s="7">
<O>
<![CDATA[上周解决]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="3" s="8">
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
<C c="7" r="3" cs="3" s="9">
<O t="RichText">
<RichText>
<RichChar styleIndex="3">
<text>
<![CDATA[${=h9}]]></text>
</RichChar>
<RichChar styleIndex="4">
<text>
<![CDATA[${=if(len(h9)=0,"","个批次 ")}]]></text>
</RichChar>
<RichChar styleIndex="3">
<text>
<![CDATA[${=i9}]]></text>
</RichChar>
<RichChar styleIndex="4">
<text>
<![CDATA[${=if(len(i9)=0,"","万平")}]]></text>
</RichChar>
<RichChar styleIndex="3">
<text>
<![CDATA[${=j9}]]></text>
</RichChar>
<RichChar styleIndex="4">
<text>
<![CDATA[${=if(len(j9)=0,"","亿元")}]]></text>
</RichChar>
<RichChar styleIndex="5">
<text>
<![CDATA[${=if(and(len(h9)=0,len(i9)=0,len(j9)=0),"无","")}]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="1" r="4" cs="4" s="0">
<O>
<![CDATA[规委会问题]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="4" s="1">
<O>
<![CDATA[本周新增]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="4" cs="3" s="2">
<O t="RichText">
<RichText>
<RichChar styleIndex="3">
<text>
<![CDATA[${=e10}]]></text>
</RichChar>
<RichChar styleIndex="4">
<text>
<![CDATA[${=if(len(e10)=0,"","个批次")}]]></text>
</RichChar>
<RichChar styleIndex="3">
<text>
<![CDATA[${=f10}]]></text>
</RichChar>
<RichChar styleIndex="4">
<text>
<![CDATA[${=if(len(f10)=0,"","万平")}]]></text>
</RichChar>
<RichChar styleIndex="3">
<text>
<![CDATA[${=g10}]]></text>
</RichChar>
<RichChar styleIndex="4">
<text>
<![CDATA[${=if(len(g10)=0,"","亿元")}]]></text>
</RichChar>
<RichChar styleIndex="5">
<text>
<![CDATA[${=if(and(len(e10)=0,len(f10)=0,len(g10)=0),"无","")}]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="1" r="5" cs="4" s="6">
<O t="RichText">
<RichText>
<RichChar styleIndex="3">
<text>
<![CDATA[${=b13}]]></text>
</RichChar>
<RichChar styleIndex="4">
<text>
<![CDATA[${=if(len(b13)=0,"","个批次 ")}]]></text>
</RichChar>
<RichChar styleIndex="3">
<text>
<![CDATA[${=c13}]]></text>
</RichChar>
<RichChar styleIndex="4">
<text>
<![CDATA[${=if(len(c13)=0,"","万平")}]]></text>
</RichChar>
<RichChar styleIndex="3">
<text>
<![CDATA[${=d13}]]></text>
</RichChar>
<RichChar styleIndex="4">
<text>
<![CDATA[${=if(len(d13)=0,"","亿元")}]]></text>
</RichChar>
<RichChar styleIndex="4">
<text>
<![CDATA[${=if(and(len(b13)=0,len(c13)=0,len(d13)=0),"无","")}]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="5" r="5" s="7">
<O>
<![CDATA[上周解决]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="5" s="8">
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="5" cs="3" s="9">
<O t="RichText">
<RichText>
<RichChar styleIndex="3">
<text>
<![CDATA[${=h10}]]></text>
</RichChar>
<RichChar styleIndex="4">
<text>
<![CDATA[${=if(len(h10)=0,"","个批次 ")}]]></text>
</RichChar>
<RichChar styleIndex="3">
<text>
<![CDATA[${=i10}]]></text>
</RichChar>
<RichChar styleIndex="4">
<text>
<![CDATA[${=if(len(i10)=0,"","万平")}]]></text>
</RichChar>
<RichChar styleIndex="3">
<text>
<![CDATA[${=j10}]]></text>
</RichChar>
<RichChar styleIndex="4">
<text>
<![CDATA[${=if(len(j10)=0,"","亿元")}]]></text>
</RichChar>
<RichChar styleIndex="5">
<text>
<![CDATA[${=if(and(len(h10)=0,len(i10)=0,len(j10)=0),"无","")}]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="1" r="6" cs="4" s="0">
<O>
<![CDATA[其他问题]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="6" s="1">
<O>
<![CDATA[本周新增]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="6" cs="3" s="2">
<O t="RichText">
<RichText>
<RichChar styleIndex="3">
<text>
<![CDATA[${=e11}]]></text>
</RichChar>
<RichChar styleIndex="4">
<text>
<![CDATA[${=if(len(e11)=0,"","个批次")}]]></text>
</RichChar>
<RichChar styleIndex="3">
<text>
<![CDATA[${=f11}]]></text>
</RichChar>
<RichChar styleIndex="4">
<text>
<![CDATA[${=if(len(f11)=0,"","万平")}]]></text>
</RichChar>
<RichChar styleIndex="3">
<text>
<![CDATA[${=g11}]]></text>
</RichChar>
<RichChar styleIndex="4">
<text>
<![CDATA[${=if(len(g11)=0,"","亿元")}]]></text>
</RichChar>
<RichChar styleIndex="5">
<text>
<![CDATA[${=if(and(len(e11)=0,len(f11)=0,len(g11)=0),"无","")}]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="1" r="7" cs="4" s="10">
<O t="RichText">
<RichText>
<RichChar styleIndex="3">
<text>
<![CDATA[${=b14}]]></text>
</RichChar>
<RichChar styleIndex="4">
<text>
<![CDATA[${=if(len(b14)=0,"","个批次")}]]></text>
</RichChar>
<RichChar styleIndex="3">
<text>
<![CDATA[${=c14}]]></text>
</RichChar>
<RichChar styleIndex="4">
<text>
<![CDATA[${=if(len(c14)=0,"","万平")}]]></text>
</RichChar>
<RichChar styleIndex="3">
<text>
<![CDATA[${=d14}]]></text>
</RichChar>
<RichChar styleIndex="4">
<text>
<![CDATA[${=if(len(d14)=0,"","亿元")}]]></text>
</RichChar>
<RichChar styleIndex="5">
<text>
<![CDATA[${=if(and(len(b14)=0,len(c14)=0,len(d14)=0),"无","")}]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="5" r="7" s="1">
<O>
<![CDATA[上周解决]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="7" cs="3" s="2">
<O t="RichText">
<RichText>
<RichChar styleIndex="3">
<text>
<![CDATA[${=h11}]]></text>
</RichChar>
<RichChar styleIndex="4">
<text>
<![CDATA[${=if(len(h11)=0,"","个批次")}]]></text>
</RichChar>
<RichChar styleIndex="3">
<text>
<![CDATA[${=i11}]]></text>
</RichChar>
<RichChar styleIndex="4">
<text>
<![CDATA[${=if(len(i11)=0,"","万平")}]]></text>
</RichChar>
<RichChar styleIndex="11">
<text>
<![CDATA[${=j11}]]></text>
</RichChar>
<RichChar styleIndex="4">
<text>
<![CDATA[${=if(len(j11)=0,"","亿元")}]]></text>
</RichChar>
<RichChar styleIndex="5">
<text>
<![CDATA[${=if(and(len(h11)=0,len(i11)=0,len(j11)=0),"无","")}]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="0" r="8">
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
<C c="1" r="8">
<O t="DSColumn">
<Attributes dsName="risk_resource" columnName="数量"/>
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[PROBLEMTYPE]]></CNAME>
<Compare op="0">
<O>
<![CDATA[进场问题]]></O>
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
<C c="2" r="8">
<O t="DSColumn">
<Attributes dsName="risk_resource" columnName="面积"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="3" r="8">
<O t="DSColumn">
<Attributes dsName="risk_resource" columnName="金额"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="4" r="8">
<O t="DSColumn">
<Attributes dsName="risk_resource" columnName="新增数量"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="5" r="8">
<O t="DSColumn">
<Attributes dsName="risk_resource" columnName="新增面积"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="6" r="8">
<O t="DSColumn">
<Attributes dsName="risk_resource" columnName="新增金额"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="7" r="8">
<O t="DSColumn">
<Attributes dsName="risk_resource" columnName="上周数量"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="8" r="8">
<O t="DSColumn">
<Attributes dsName="risk_resource" columnName="上周面积"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="9" r="8">
<O t="DSColumn">
<Attributes dsName="risk_resource" columnName="上周金额"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="0" r="9">
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
<C c="1" r="9">
<O t="DSColumn">
<Attributes dsName="risk_resource" columnName="数量"/>
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[PROBLEMTYPE]]></CNAME>
<Compare op="0">
<O>
<![CDATA[规委会问题]]></O>
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
<C c="2" r="9">
<O t="DSColumn">
<Attributes dsName="risk_resource" columnName="面积"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="3" r="9">
<O t="DSColumn">
<Attributes dsName="risk_resource" columnName="金额"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="4" r="9">
<O t="DSColumn">
<Attributes dsName="risk_resource" columnName="新增数量"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0" leftParentDefault="false" left="B10"/>
</C>
<C c="5" r="9">
<O t="DSColumn">
<Attributes dsName="risk_resource" columnName="新增面积"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="6" r="9">
<O t="DSColumn">
<Attributes dsName="risk_resource" columnName="新增金额"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="7" r="9">
<O t="DSColumn">
<Attributes dsName="risk_resource" columnName="上周数量"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="8" r="9">
<O t="DSColumn">
<Attributes dsName="risk_resource" columnName="上周面积"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="9" r="9">
<O t="DSColumn">
<Attributes dsName="risk_resource" columnName="上周金额"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="0" r="10">
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
<C c="1" r="10">
<O t="DSColumn">
<Attributes dsName="risk_resource" columnName="数量"/>
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[PROBLEMTYPE]]></CNAME>
<Compare op="0">
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
<Expand dir="0" extendable="3"/>
</C>
<C c="2" r="10">
<O t="DSColumn">
<Attributes dsName="risk_resource" columnName="面积"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="3" r="10">
<O t="DSColumn">
<Attributes dsName="risk_resource" columnName="金额"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="4" r="10">
<O t="DSColumn">
<Attributes dsName="risk_resource" columnName="新增数量"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="5" r="10">
<O t="DSColumn">
<Attributes dsName="risk_resource" columnName="新增面积"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="6" r="10">
<O t="DSColumn">
<Attributes dsName="risk_resource" columnName="新增金额"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="7" r="10">
<O t="DSColumn">
<Attributes dsName="risk_resource" columnName="上周数量"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="8" r="10">
<O t="DSColumn">
<Attributes dsName="risk_resource" columnName="上周面积"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="9" r="10">
<O t="DSColumn">
<Attributes dsName="risk_resource" columnName="上周金额"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="0" r="11">
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
<C c="1" r="11">
<O t="DSColumn">
<Attributes dsName="risk_sum" columnName="PRO_QTY"/>
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[RISK_TYPE_ID]]></CNAME>
<Compare op="0">
<O>
<![CDATA[1]]></O>
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
<C c="2" r="11">
<O t="DSColumn">
<Attributes dsName="risk_sum" columnName="PRO_SQ"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="3" r="11">
<O t="DSColumn">
<Attributes dsName="risk_sum" columnName="PRO_VALUE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="0" r="12">
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
<C c="1" r="12">
<O t="DSColumn">
<Attributes dsName="risk_sum" columnName="PRO_QTY"/>
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[RISK_TYPE_ID]]></CNAME>
<Compare op="0">
<O>
<![CDATA[2]]></O>
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
<C c="2" r="12">
<O t="DSColumn">
<Attributes dsName="risk_sum" columnName="PRO_SQ"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="3" r="12">
<O t="DSColumn">
<Attributes dsName="risk_sum" columnName="PRO_VALUE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="0" r="13">
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
<C c="1" r="13">
<O t="DSColumn">
<Attributes dsName="risk_sum" columnName="PRO_QTY"/>
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[RISK_TYPE_ID]]></CNAME>
<Compare op="0">
<O>
<![CDATA[3]]></O>
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
<C c="2" r="13">
<O t="DSColumn">
<Attributes dsName="risk_sum" columnName="PRO_SQ"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="3" r="13">
<O t="DSColumn">
<Attributes dsName="risk_sum" columnName="PRO_VALUE"/>
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
<WorkSheetAttr/>
</FormElementCase>
<StyleList>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="80" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="4" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="104" foreground="-16712961"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="88" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="88" foreground="-16712961"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Bottom style="1" color="-14727319"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
<Background name="NullBackground"/>
<Border>
<Bottom style="1" color="-14727319"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Bottom style="1" color="-14727319"/>
</Border>
</Style>
<Style horizontal_alignment="4" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Bottom style="1" color="-14727319"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="104" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="958" height="268"/>
</Widget>
<body class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="report4"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Margin top="5" left="5" bottom="5" right="5"/>
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
<C c="0" r="0">
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
<BoundsAttr x="523" y="302" width="321" height="168"/>
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
<![CDATA[8153400,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O>
<![CDATA[挂牌土地信息]]></O>
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
<Style horizontal_alignment="2" imageLayout="1">
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
<![CDATA[8153400,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O>
<![CDATA[挂牌土地信息]]></O>
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
<Style horizontal_alignment="2" imageLayout="1">
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
<BoundsAttr x="524" y="126" width="207" height="21"/>
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
<![CDATA[457200,0,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[432000,2592000,2743200,2592000,2743200,2592000,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="0">
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
<C c="4" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="1">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="1" cs="4" s="1">
<O t="RichText">
<RichText>
<RichChar styleIndex="2">
<text>
<![CDATA[共]]></text>
</RichChar>
<RichChar styleIndex="3">
<text>
<![CDATA[${=COUNT(VALUE(if ( $gzp=1, "TGP","WGP"),2))}]]></text>
</RichChar>
<RichChar styleIndex="2">
<text>
<![CDATA[块（]]></text>
</RichChar>
<RichChar styleIndex="3">
<text>
<![CDATA[${=ROUND(SUM(VALUE(if ( $gzp=1, "TGP","WGP"),2)),0)}]]></text>
</RichChar>
<RichChar styleIndex="2">
<text>
<![CDATA[亩）]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
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
<FRFont name="SimSun" style="0" size="72" foreground="-65536"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="4" vertical_alignment="3" imageLayout="1">
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
<FRFont name="微软雅黑" style="0" size="152" foreground="-16712961"/>
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
<C c="0" r="0">
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
<BoundsAttr x="523" y="122" width="324" height="168"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report13_c_c_c_c_c_c_c"/>
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
<WidgetName name="report13_c_c_c_c_c_c_c"/>
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
<![CDATA[0,1728000,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[0,1728000,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1">
<O t="Image">
<IM>
<![CDATA[!Smf$rJ=?G7h#eD$31&+%7s)Y;?-[s,QIfE,R=SS!!(sXR$[jR!i/CU5u`*!m?YA";c+OTDu
--'95pgX`=C1:0#=sD;$<eicq.1d`1]A/H/dgE$rr=-C"Wc@M(*#.Z2N.35U8/;dC[$HiUP!D
eaRT/@q46RnQJ4MsWQH6q*7"$N*hReNf2>4DJ!5m5^]AX.X4J70*a;Q+<JhBDDTEMV(.;9H)k
BPI<!hk,T\d#9('2TbbJ5/GUdK[WR+b'(X)$`LV<p1P\%s=.rSVGFq/[9MV5N>q,!?kU8/B&
jZK\/6t:S<q'QW?`F!V'rk36&GX%"olXcm0<k^)qZ4(E\KFcc+o/b3,tnk2M-OZ;8*JdEaIc
@EHtr.hEB-Ja-h"i[iYD[B*^6gfJ!tl4;;!4gh(u/1tr8OsaKb&GJFOe,[IhfAl-kEr/+`;U
LR)G$HYkH0.h<l<\r0onE(5U6!(XWiK7%$^_O7loW8P0/M-oE`:T[#lCCGg!Q?WZ(<UaH3O^
CT6BTX$8G;YJ3$UoSLer2Gq37chJ0&-UdTE.^?'c]A/T#6LV^W`pFR&[_]AmPqUd:lZ)NbdOgo
U`McR0";b;Wn1E?cj*QMgd]AVQ?L%X:`+CL!=8SDML9LN_Ka#(h\^jqOfnm9`$0ho,s1dK`YF
<ig@n`2U[94'5TNP>c)HU`>YD[14i"T$jXi+Y%O44?[HMs!R2p8uK7/&d92Q8s:2p%cNq$]A2
W;n?fK#.4sdDa.iG@P&K?(+F?Xn*f9oG?/QBd!B_%<8_/*;>SbkU2jLa=?eRW,*T-il`G*(S
C_l:f"?!%g&Gqj"`F<_d<,<JHVtblA,)885,TM0UKI4S$_'-[d;I\O6?EZ/';3JO9:FppO+R
dX.#1(a@Mrsp8[[a$Zo?/FoW&o"8_J;IKPH4XBB-_72Q")!!#SZ:.26O@"J~
]]></IM>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 2]]></Formula>
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
<StyleList/>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="250" height="150"/>
</Widget>
<body class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="report13"/>
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
<BoundsAttr x="444" y="387" width="30" height="30"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report12"/>
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
<WidgetName name="report12"/>
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
<![CDATA[723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,720000,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,2592000,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[432000,1008000,1752600,3600000,2743200,5918400,144000,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
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
<C c="0" r="1">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="1" r="1">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="1">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="1" cs="4" rs="12">
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
<ChartAttr isJSDraw="false" isStyleGlobal="false"/>
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
<HtmlLabel customText="function(){ return this.category.substring(0,this.category.indexOf(&quot;_&quot;))+&quot;:&quot;+this.seriesName+this.category.substring(this.category.indexOf(&apos;_&apos;)+1,this.category.length);}" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
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
<Attr class="com.fr.plugin.chart.base.AttrLabel">
<AttrLabel>
<labelAttr enable="true"/>
<labelDetail class="com.fr.plugin.chart.base.AttrLabelDetail">
<Attr showLine="false" autoAdjust="true" position="6" isCustom="true"/>
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
<HtmlLabel customText="function(){ return this.category.substring(this.category.indexOf(&apos;_&apos;)+1,this.category.length);}" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
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
<AttrList>
<Attr class="com.fr.chart.base.AttrAlpha">
<AttrAlpha>
<Attr alpha="0.0"/>
</AttrAlpha>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrLabel">
<AttrLabel>
<labelAttr enable="true"/>
<labelDetail class="com.fr.plugin.chart.base.AttrLabelDetail">
<Attr showLine="false" autoAdjust="false" position="6" isCustom="true"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="64" foreground="-6710887"/>
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
<Attr class="com.fr.plugin.chart.base.AttrSeriesImageBackground">
<AttrBackground>
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="1">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320!n%uP/Af4-,lbL,mflZBSh?$H'm#Ofr;U\b38k_G4,,(GS)<>J(E
?@uoKV<e@_O.*bj;3I+(D=cFO+bS40X=i?.S!:T1%pr(!Q$R(kM7TC^eM2nn*8Wq,n"\O29;
qcXiYG65'>~
]]></IM>
</Background>
<Attr shadow="false"/>
</AttrBackground>
</Attr>
</AttrList>
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[系列名称]]></CNAME>
<Compare op="0">
<O>
<![CDATA[标准工期（月）]]></O>
</Compare>
</Condition>
</ConditionAttr>
</List>
<List index="1">
<ConditionAttr name="条件属性2">
<AttrList>
<Attr class="com.fr.plugin.chart.base.AttrLabel">
<AttrLabel>
<labelAttr enable="true"/>
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
</AttrLabel>
</Attr>
</AttrList>
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[值]]></CNAME>
<Compare op="0">
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
<FRFont name="Verdana" style="0" size="88" foreground="-5197648"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="true"/>
<AxisLineStyle AxisStyle="0" MainGridStyle="1"/>
<newLineColor mainGridColor="-15388336" lineColor="-5197648"/>
<AxisPosition value="3"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="64" foreground="-6710887"/>
</Attr>
</TextAttr>
<AxisLabelCount value="=1"/>
<AxisRange minValue="=if(or(max(ds2.group(value_s))=0, len(max(ds2.group(value_s)))=0 ), 0, max(ds2.group(value_s))*1.2 )*-1/4" maxValue="=if(or(max(ds2.group(value_s))=0, len(max(ds2.group(value_s)))=0 ), 0, max(ds2.group(value_s))*1.2 )"/>
<AxisUnit201106 isCustomMainUnit="false" isCustomSecUnit="false" mainUnit="=0" secUnit="=0"/>
<ZoomAxisAttr isZoom="false"/>
<axisReversed axisReversed="false"/>
<VanChartAxisAttr mainTickLine="0" secTickLine="0" axisName="X轴" titleUseHtml="false" autoLabelGap="true" limitSize="false" maxHeight="15.0" commonValueFormat="true" isRotation="false"/>
<HtmlLabel customText="function(){ return this; }" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
<alertList>
<VanChartAlert class="com.fr.plugin.chart.attr.axis.VanChartAlertValue">
<ChartAlertValue>
<Attr name="警戒线1" alertPosition="3" alertLineAlpha="1.0" alertContent="警戒" formula="=0"/>
<AttrColor>
<Attr color="-65536"/>
</AttrColor>
<AttrLineStyle>
<newAttr lineStyle="1"/>
</AttrLineStyle>
<FRFont name="微软雅黑" style="0" size="72" foreground="-65536"/>
</ChartAlertValue>
<O>
<![CDATA[]]></O>
</VanChartAlert>
</alertList>
<customBackgroundList/>
<VanChartValueAxisAttr isLog="false" valueStyle="false" baseLog="=3"/>
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
<newAxisAttr isShowAxisLabel="false"/>
<AxisLineStyle AxisStyle="0" MainGridStyle="1"/>
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
<VanChartAxisAttr mainTickLine="0" secTickLine="0" axisName="Y轴" titleUseHtml="false" autoLabelGap="true" limitSize="true" maxHeight="20.0" commonValueFormat="true" isRotation="false"/>
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
<VanChartColumnPlotAttr seriesOverlapPercent="1.0" categoryIntervalPercent="20.0" fixedWidth="true" columnWidth="18" filledWithImage="false" isBar="true"/>
</Plot>
<ChartDefinition>
<MoreNameCDDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[ds2]]></Name>
</TableData>
<CategoryName value="SNAME"/>
<ChartSummaryColumn name="VALUE_S" function="com.fr.data.util.function.NoneFunction" customName="实际时长（月）"/>
<ChartSummaryColumn name="TARGET" function="com.fr.data.util.function.NoneFunction" customName="标准工期（月）"/>
</MoreNameCDDefinition>
</ChartDefinition>
</Chart>
<tools hidden="false" sort="false" export="false" fullScreen="false"/>
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
<C c="0" r="2">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="1" r="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="3">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="1" r="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="4">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="1" r="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="5">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="1" r="5">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="5">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="6">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
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
<C c="0" r="7">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
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
<C c="0" r="8">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
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
<C c="0" r="9">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
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
<C c="0" r="10">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
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
<C c="0" r="11">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
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
<C c="0" r="12">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
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
<C c="0" r="13">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
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
<C c="0" r="14">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 2]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="2" r="14" cs="5" rs="12">
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
<![CDATA[节点达标数量]]></O>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="64" foreground="-1118482"/>
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
<FillStyleName fillStyleName=""/>
<isCustomFillStyle isCustomFillStyle="true"/>
<ColorList>
<OColor colvalue="-12210945"/>
<OColor colvalue="-12491265"/>
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
<FRFont name="Verdana" style="0" size="88" foreground="-10066330"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="false"/>
<AxisLineStyle AxisStyle="0" MainGridStyle="1"/>
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
<FRFont name="Verdana" style="0" size="88" foreground="-10066330"/>
</Attr>
</TextAttr>
<AxisLabelCount value="=1"/>
<AxisRange maxValue="=max(value(&quot;tu2&quot;,4))*1.2"/>
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
<FRFont name="Verdana" style="0" size="88" foreground="-10066330"/>
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
<AxisRange maxValue="=1.5"/>
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
<Attr class="com.fr.plugin.chart.base.AttrTooltip">
<AttrTooltip>
<Attr enable="true" duration="4" followMouse="false" showMutiSeries="true" isCustom="true"/>
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
<Attr alpha="0.8"/>
</AttrAlpha>
</GI>
</AttrTooltip>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrLabel">
<AttrLabel>
<labelAttr enable="true"/>
<labelDetail class="com.fr.plugin.chart.base.AttrLabelDetail">
<Attr showLine="false" autoAdjust="true" position="6" isCustom="true"/>
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
<FRFont name="Verdana" style="0" size="88" foreground="-10066330"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="false"/>
<AxisLineStyle AxisStyle="0" MainGridStyle="1"/>
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
<FRFont name="Verdana" style="0" size="88" foreground="-10066330"/>
</Attr>
</TextAttr>
<AxisLabelCount value="=1"/>
<AxisRange maxValue="=max(value(&quot;tu2&quot;,4))*1.2"/>
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
<FRFont name="Verdana" style="0" size="88" foreground="-10066330"/>
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
<AxisRange maxValue="=1.5"/>
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
<VanChartColumnPlotAttr seriesOverlapPercent="20.0" categoryIntervalPercent="30.0" fixedWidth="true" columnWidth="25" filledWithImage="false" isBar="false"/>
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
<Attr enable="true" duration="4" followMouse="false" showMutiSeries="true" isCustom="true"/>
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
<Attr alpha="0.8"/>
</AttrAlpha>
</GI>
</AttrTooltip>
</Attr>
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
<Attr lineWidth="2" lineStyle="2" nullValueBreak="false"/>
</VanAttrLine>
</Attr>
<Attr class="com.fr.plugin.chart.base.VanChartAttrMarker">
<VanAttrMarker>
<Attr isCommon="true" markerType="RoundMarker" radius="2.0" width="30.0" height="30.0"/>
<Background name="NullBackground"/>
</VanAttrMarker>
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
<FRFont name="Verdana" style="0" size="88" foreground="-10066330"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="false"/>
<AxisLineStyle AxisStyle="0" MainGridStyle="1"/>
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
<FRFont name="Verdana" style="0" size="88" foreground="-10066330"/>
</Attr>
</TextAttr>
<AxisLabelCount value="=1"/>
<AxisRange maxValue="=max(value(&quot;tu2&quot;,4))*1.2"/>
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
<FRFont name="Verdana" style="0" size="88" foreground="-10066330"/>
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
<AxisRange maxValue="=1.5"/>
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
<DefinitionMap key="line">
<MoreNameCDDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[tu2]]></Name>
</TableData>
<CategoryName value="HOUSE_SCHE"/>
<ChartSummaryColumn name="RATE" function="com.fr.data.util.function.NoneFunction" customName="达标率"/>
</MoreNameCDDefinition>
</DefinitionMap>
<DefinitionMap key="column">
<MoreNameCDDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[tu2]]></Name>
</TableData>
<CategoryName value="HOUSE_SCHE"/>
<ChartSummaryColumn name="FIN_PRO_QTY" function="com.fr.data.util.function.NoneFunction" customName="达标项目(个)"/>
</MoreNameCDDefinition>
</DefinitionMap>
</DefinitionMapList>
</CustomDefinition>
</ChartDefinition>
</Chart>
<tools hidden="false" sort="false" export="false" fullScreen="false"/>
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
<C c="0" r="15">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 2]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="1" r="15">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="16">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 2]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="1" r="16">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="17">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 2]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="1" r="17">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="18">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 2]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="1" r="18">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="19">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 2]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="1" r="19">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="20">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 2]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="1" r="20">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="21">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 2]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="1" r="21">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="22">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 2]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="1" r="22">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="23">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 2]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="1" r="23">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="24">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 2]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="1" r="24">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="25">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 2]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="1" r="25">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="26">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 2]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="27">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 3]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="1" r="27">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="28">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 3]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="1" r="28" cs="6" rs="13">
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
<![CDATA[标准工期达标排名]]></O>
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
<FRFont name="微软雅黑" style="0" size="64" foreground="-1118482"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="true"/>
<AxisLineStyle AxisStyle="0" MainGridStyle="1"/>
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
<newLineColor lineColor="-5197648"/>
<AxisPosition value="2"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
</Attr>
</TextAttr>
<AxisLabelCount value="=1"/>
<AxisRange maxValue="=max(value(&quot;4&quot;,1),value(&quot;4&quot;,2))*1.2"/>
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
<FRFont name="Verdana" style="0" size="88" foreground="-10066330"/>
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
<FRFont name="微软雅黑" style="0" size="48" foreground="-1118482"/>
</Attr>
</TextAttr>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0%]]></Format>
<AxisLabelCount value="=1"/>
<AxisRange minValue="=0" maxValue="=1.5"/>
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
<Attr class="com.fr.plugin.chart.base.AttrTooltip">
<AttrTooltip>
<Attr enable="true" duration="4" followMouse="false" showMutiSeries="true" isCustom="true"/>
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
<Attr alpha="0.8"/>
</AttrAlpha>
</GI>
</AttrTooltip>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrLabel">
<AttrLabel>
<labelAttr enable="true"/>
<labelDetail class="com.fr.plugin.chart.base.AttrLabelDetail">
<Attr showLine="false" autoAdjust="true" position="6" isCustom="true"/>
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
<FRFont name="微软雅黑" style="0" size="64" foreground="-1118482"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="true"/>
<AxisLineStyle AxisStyle="0" MainGridStyle="1"/>
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
<newLineColor lineColor="-5197648"/>
<AxisPosition value="2"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
</Attr>
</TextAttr>
<AxisLabelCount value="=1"/>
<AxisRange maxValue="=max(value(&quot;4&quot;,1),value(&quot;4&quot;,2))*1.2"/>
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
<FRFont name="Verdana" style="0" size="88" foreground="-10066330"/>
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
<FRFont name="微软雅黑" style="0" size="48" foreground="-1118482"/>
</Attr>
</TextAttr>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0%]]></Format>
<AxisLabelCount value="=1"/>
<AxisRange minValue="=0" maxValue="=1.5"/>
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
<VanChartColumnPlotAttr seriesOverlapPercent="0.0" categoryIntervalPercent="20.0" fixedWidth="false" columnWidth="0" filledWithImage="false" isBar="false"/>
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
<Attr enable="true" duration="4" followMouse="false" showMutiSeries="true" isCustom="true"/>
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
<Attr alpha="0.8"/>
</AttrAlpha>
</GI>
</AttrTooltip>
</Attr>
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
<Attr isCommon="true" markerType="RoundMarker" radius="2.0" width="30.0" height="30.0"/>
<Background name="NullBackground"/>
</VanAttrMarker>
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
<FRFont name="微软雅黑" style="0" size="64" foreground="-1118482"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="true"/>
<AxisLineStyle AxisStyle="0" MainGridStyle="1"/>
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
<newLineColor lineColor="-5197648"/>
<AxisPosition value="2"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
</Attr>
</TextAttr>
<AxisLabelCount value="=1"/>
<AxisRange maxValue="=max(value(&quot;4&quot;,1),value(&quot;4&quot;,2))*1.2"/>
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
<FRFont name="Verdana" style="0" size="88" foreground="-10066330"/>
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
<FRFont name="微软雅黑" style="0" size="48" foreground="-1118482"/>
</Attr>
</TextAttr>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0%]]></Format>
<AxisLabelCount value="=1"/>
<AxisRange minValue="=0" maxValue="=1.5"/>
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
<DefinitionMap key="line">
<MoreNameCDDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[4]]></Name>
</TableData>
<CategoryName value="ORG_SNAME"/>
<ChartSummaryColumn name="RATE" function="com.fr.data.util.function.NoneFunction" customName="完成率"/>
</MoreNameCDDefinition>
</DefinitionMap>
<DefinitionMap key="column">
<MoreNameCDDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[4]]></Name>
</TableData>
<CategoryName value="ORG_SNAME"/>
<ChartSummaryColumn name="PRO_QTY" function="com.fr.data.util.function.NoneFunction" customName="项目数(个)"/>
<ChartSummaryColumn name="FIN_PRO_QTY" function="com.fr.data.util.function.NoneFunction" customName="按时完成(个)"/>
</MoreNameCDDefinition>
</DefinitionMap>
</DefinitionMapList>
</CustomDefinition>
</ChartDefinition>
</Chart>
<tools hidden="false" sort="false" export="false" fullScreen="false"/>
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
<C c="0" r="29">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 3]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="30">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 3]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="31">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 3]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="32">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 3]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="33">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 3]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="34">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 3]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="35">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 3]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="36">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 3]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="37">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 3]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="38">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 3]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="39">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 3]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="40">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 3]]></Formula>
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
<StyleList/>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<IM>
<![CDATA[m<a1^'5,$D0"]Ah[CY?,MEYGa*I,(<Y<^]A>.6DgopD7-ZUWAgOl0e+XsTHGMToi/#IjKpPF#S
Jd@#`:H:V4\B(1o[2P6qF%=</L]A4&@l<QREWm#-P;_;ipXARSEHF*r3=6HHnt;Bhs]A[u]AtU[
Wraj3g$0-HR]A=GIHpup&qQFXR)%!Qb3e,I?hn4bdo0ZD9g9_HfG3@e#!]A3F`P4fKs6i+_8!J
_q1@nZtTH$4b<bmSj/VG8V&9C1E<"r+IL"ifn#BVm8ELr&OIYM6HVSFe>;nm/5s(KeJ>PU6Z
\.d/L%pX*N`<?=.D6)fer.*T,Rmc-5.(\T5=t\ehW-e>i+5ah@#aM.0/1>MC=d6Mm76>'`#\
P9f8PK$W^%DH"TJW"'k_rWYiqoh:t,bqX"_Iib9o;iiddS*81EM\htm6uCl]Acq#KUWu%@"'#
SD@g#tclBfRQ'krP$/s#1aom`?k?6L*Z/&orC6)Vm7>@SY(-EH#<>f?U\e_WjeY"55PRmhYj
.2]AU0#kC`N\Qg/=dbDIAVLLE;RTTMd)cF.9M.llL[5I9bDGep5hcMl&Nf%dCd=;dBQ>[5)=W
%_$LQqER_XB^pJX]Au6IW/BAQ)P1oJQoJiBn`FJ*4gV2lT7<LuZf^UR6&%'gEah*jX'jl,:J2
G`O)qIkc_p5nIdDLe`cHgX&bPq2)kd@K58_M5.[W+O-#IA$CAsJ%.kMX)'&f'eb@AE]A!DeWt
>]AF"B9MK12_Y!!M=j*sR.3!ZD+GZF=\M6gh2Do[H<!ff]AiVW)hhq+K'QK+BM=goT(`OY1_WX
IbB2gND6/:l/<*QjR34m%nh`V8*gE'b1in`Y+2WO.>D@)7c81WuRa[q1g5o\L1_HEe\m6LI#
hPBWoMUkji"%fu`hA5F@dYD@ub)5o[tTO[s]AY%P)eat=Om:Z6$LTkhS&0]AEnNH6RNDpr\@H4
1:k583n041APB,Xf+I`0t!>t8CN9dMV(tn:/9Q>nFN#s8m0cOXnd=P,H[<!7DhZ#YE2RRO2.
!6\=)0m>?<A<2sjf'r;6,_k>XmkcDcJ@8W1;Ws0mZEAd?8eUD1^N2SEU'@Eggo$%DhK_9j`#
-'?\M&*caId,WqL^M<%3T$5j=]Al<JQfLoE0Z<EHt_$!i:SE*m=`G.B=`U,1KVTp%E1hneD.'
u=+Q&!&"eY5^KRbYKGdoYL^S$$E%i_hUr5oBM@>J)/ApD7!9Q"90"OeAW:4o/Zuc^2h:K/0D
b:2hj\(;0*]AEa2soI*\I%SUm"gY1a1\i<-RR:Xsu]AO6SWtI"edu@ef]A'.UbpKq<LAr?qWb3+
LNio,f6#t+qdCP(8Bh'6>R$e=DeuQr_q[Ymrs,\ht:Mk?fKS'O<0<2UBFZdrjsd1>oJgC4at
N.?eTe,$[bj`b.BOP%?8M[]At$19lF$*)8)fdH6X,)H'fmBGl+YO+XD&9t,ZdVPk"?MCcc&?$
9UP,:CY_QEY02gApsZM=9Bli4O5QWF^=%<!,eRS;EL*AhKElkaX4;s0?FL&',8t5*^_J-(.Q
6q=^\8_m*KF2;PiS6ihRf7Rrq\D-%DOdX>5W+s:)Osrhc)IF5pGdcYdcudDqD^(\$OrqDB?7
Jqu/SNH&p=7CjD#$Wq:fr$@cT*=KoL=P:N,83&(pDo4J;gQ(!B@)cGH[cYEI1oh&rf5K)#[@
iI0?f!k'C@H)Ibhf;'\4IbQGf:CE"VU2S+n6Aj!If>FIq'Ohr`KOujn6.X_9<bDHrq%3JnJ9
=KT?G[dQoDb2Mq0EQBALB*bn6@K1bA&>#m"jF'l3fn(26k;.cB\=#hahs)ee?mDg\T(fGMDC
K?-W/e'(_5Q%U^*>=;^QUi6fO\_QS]A1qX"0-4duq@C#9"ZlCT]A6-!Na']A;jugnr:n0>)0*82
%9**,.*-d;5hGI#'H<>lBWCLOXKdn51K7"O1u#7eIr0K;'(@/=5oi^[MR^c2uh0Cl9h`3YJD
7qib;?H7uZ$`,4+@Z<M>-.7'ZJg)qrEOTbb5]Al7BT=0=)R\CV!t9M1fJqanpugKuP#)E7MmK
;l<b@rs\U#NkBFnlQVh@V/t0e-gJIs/E51(j>!jNP&:JDSn-PrPS%Hm8aQQT^L_8#G*g^@F\
AF)WO*,?VG9!!M["G3$)'[]AMJF*_Kn*P8O?FH*(Z@5?s*Q?WOj;'Y_LS"O&ACJ2s_E7X]A.-=
8-(e)AaB]AZH+9?S/=iZV>S_.cd//$.GIi[tQC^)4VY5;l[X/L387Wb`Y3jVt\@$qS[\HaC+3
ae'hf^[Z=/StmgODonj\h:H_kT-?Dj6+S09cM4/gW7ujZl.Bi,`TQV#)4<F=8HHU%TXXT5*d
d#5Lb5S!2^W'MX7'RNa@Oh1UBMT\sF/i<l`E_#YI5)5gu`2`7:2Z&4>W$$Nh;j+X]A3%/%R]Ak
SX`6`E['8R4rZU0For-hCJ]A1.$tnU<;%MM<&J%"<6H_*5Zt68(V=)7I:4*nIj5X8s-Y+jAf,
60PR>9u1Pa3n?Jd5^=F*OaJ>F$9!Fpshi9R^**-_b+`b_VaXD`r0Y;EHR2epBMLh<Y@@sMc@
^qfJGY?e0XN'$^K.$GVNTW=%M8"?NrJ,^69eMUG:VaCiC4-b>\i-oYJWd_h3kWOp4m4gOh,W
PHI=?b<X?k$JaGR#+rk/,VP0W4LI:"f9$f)!`l+e6?46qiOAA<0KR)b&i2W!LBf%ja7-':ku
OPT)q:_?88Y^M-kU93<<D]AW?OG\[Ri7Bb8f@iCk@,'XZs?DWuF-W'X$Wo_uecldjug%&-7;=
t(Mri9o=+BL.ml&i7%H+bTQ\^A*\a+/HkQ/_%J?5R><#V8<\V@#7[/o0ipYFm/L!O>QgK@l[
7K#+!-.+LP,rZ^QcQ?pKPYTbW?_AKL[$Hl;aa(3VU<K;)Z?rVuaag=;(-E#'3?3a=FX_[!FD
:pkC#aHXrB^)aOp3Yp%,O*3;tSZl$2i+u(19T=0QVGr:\aukhGZ>i3E4Ie.36V4l<<oNYUTZ
H;kDti]A%I7SCn5.2Mt5mNs:d<;'JFXfaqmc_aB1L''rjl;aJ[4-]Ag3RMQe(AM+*-7CmFKmal
<8Ulj?pf)>15&X0A@F98sXm0A`+t<L_\r'2)h\pZJSHFgf<[1?F#P38^<W+WZM]AN-_N:HtDr
=-;mh!`7f3;[@&AOPA=.f-CV]A?n_S%2RIf&<f?h//DR,m#pa=0X<><?PeC77l9Ve?R[1HS?c
OYTU4e%%6nI&=QLBFj"8T9[/L7d:a8ng.L_'/]A-MdS&,-'W:HE:6k1-.r:WHaj4P9<WM5\^4
5U+FVAP@5eiD[32D`m)B<[cO5+DL=uEIY$!_,@8[T6C37he^es@M7_\g+godYY`(q"KT7q9]A
K8[#MiValAr\ma\Q>--19:(&HC?i_'#s%XVlAt=<[U\Q.g@2ir9#%$ia'Fs-[g$qoiTQngj[
W1G:X%d#SXl3UNh(HqSo=*r[]Aa]AUVNPP@iASRTp.Vioi#J#0q[2#u"pQrK*2HVHltqkgZgVp
tjerbjJSVpZ.5CC^*,T)Z%0^4j'debJH!pV4fg]A#2g%)!)\*k1d1GunGr3j#n#qHqO*OFrBN
EoX^RCmP"sL5p%_JlN/XTsD+/CZ@2+BY(K1Z@g1_UhWeZMWUqHaXK3e=sNV#,"]Aj9ImAP22d
!6(tZmH-2Lr[bfkX<;XpB[T0aD\FVf9Y+D/]A-hPC)XgUe70hR('I=s]A\&QB:!Mt[>NfDXQ)>
2h&p,;EJ`$N04K:^1F@]AE[$"Hl)en[$3B#Ll,>Tsn\t#e<WPKCLA:ST/7LP&T#n;jPIi.gm$
G6!6H(!E;=@6Bn@OPZLf=Z<0sKMbX7:jB%_u@C0hab"2qe)<'jXEf#_^D>-lp!l+PSZue)5V
]A\3)q.!;Pft,m&$W%go+bPjJ;P<kJjs$**US6n__@nXg?9Y`9)]AGfTj*SETY4Tb#Ni=D[Z\`
M0l:D6cOh(s$T5fl^gr3EJk>Q#'j"`CM@C^t<At$]AqUY4Oub9U3h0!e'khhNCQjMa)83(J]A[
aEW?u"/a2CEps/d?N3L<6,8cAma+d[GoqBomB\OmQ4OHJ*\TH(H8jC_^Ul6)7=+Q1M>alb*6
DP<^Uf+Oo$nV-o)Z&`5s5D[pF:i!pi<5\.q`@'8o##<@h*V89.)FP^!&)b&jl#4'>,ij:mK1
SI/,ZW&6,#>Aj!8FT]A&ZKkQo/e)b17OFGr`6.`dUj+uiUrAPjQJd\R;_aq`uP7T.e4RK*=#d
%p*tBSA8GfRUQSKW<c&n;k@*\E4Mm>(eln_[>?-,MjPBe]A=]A5!\SZ'7QpAPVdSghY<-4Q4bP
2_",T`e*EkVEf(ChYS6I/LBCcWP1qi`-lXs[+B=(Q_73m\3kR>XhVM>.R<s$*XR^2`6`="F)
VG=r-UT1N1E?G7B#u-mS807QbMdKln*\^AjAGb?5j<%9@?r[(F`:B8B$:l6_Hl8rAb2sB>@S
dOWAIQHR5kBS[js@e^=&-VXf$2e8)1X=1SPb*RC*9j8-%o"K!_P(r<f.*R02h+c/.iPC6ttS
\huEt_(Gh-h9V92.#[^CBGUs(FV7%N6"852b0sbY_8J>btdeO()7hpf"P#9OD[KO#Se:ojb\
LpWK*g?&.kl?RH-[NK+easH(4H`P`?BA##oEBI*qpb^oA.`T^#?:c0JJBkZ,Eu9K?+?;^JB*
+``E8gF-k,.NR#/p&,Rs!#YliiPD;\g/o!WQaTg:!s<S>3lVfpi4l5D3Tj=3\2"Lg#@!us)c
!H1O7m1!e8DZDJWD[+1jc0h)b.$\OQ?)Q)"0iCG:TD-8G,#?\Qn.TnSG(BWhLON'LkrB6VK;
E)C2[(o+]AnY6X>ois?L>$9G?#.oL0._UpNX.RTLu?")(?d[ao!%Z=I=`*8)&Td;^-_KI3tB_
k*L9Q+26\Xh#N4e@OHQa>+=q+/jq.V\gm8Acnlpm/Dloc<c[2s(/E=.ErCB=e(IV[JJD:#&L
g6,DBULIkV;'B72C*gVS6MRR:_kR?)H@^>V$?25a*4a4:i9JpoeQ'8b5XH90=G/e4+3NW(nn
AtqL[@7e/rQ=>@OnWBHfo>P^u*),Qr'h45Ddlh\gu=b`5<`b5?*AL`Lh`qHGrm.,GoXhS:&G
K#"u-[98Q'@a"NrFF3k4jCts&1^!Cr"P''g2$=pHJDq-W]A%j*EdB@.<RmmqpM\&+j%sDK\PB
=0?a#[kOpWJ8$)VtlfBXd?dpLR5j7/Ruth3O@<)d*ZIn'T3D?8edIoLKJ5'<qk?2Ha,!2flE
4+-k_Di7rp`7Yl!SW+.UH8bsCa<@Y>ArrF\DA6'\HF6&lR,(i0iCC<[T?sDm2_,CduZa9LK!
rC%MI.<;\0`No4ZNfHLI;:b)1n(=^EJ%SD)&S/''4;=2?p@mbAs>?0UN0YNI%]A2.UZKV6h.n
X7B*VCti_5W7p`b9H4JifNJ!E\DH*']AE>dn?a35G8\KGV_2XG3c\T\=E-Qb#rY[_%Ad&=k0!
R*;E`9]A,E8_sB?IgqBg;;,B$=`Zd:]AEg/*V"%)>p8"QPcjW%sp4W28N?@E[2cG/>?HGF\]A2W
B#).QcVjRbjh)L?p()FN.`">I5l=#kIIRARi0tHjW+mW_(+mh'5c?&`gp(B)rYcK%t<qDu)U
JmgSTX-V=AucpT57PC;q6W\@u__YZg$Kbm;]A4OAdTct=b9<jo&$FR&EJOBlX&]Af,;Fc'A^PM
N,&(gWLRXSSH^u(mT=D-'/i+e8SaV8ErI?Q?W)iY//Gi6$H63IF8h0D_"c>)_XrpOUpk$4(a
eLC#+SATO'AOVqfe)Knl]A@UdILdUJ6ZR%[eI^Uh'arG'[\T.AQa8=bQcbalG'1k5q3pr:'MC
-&Ke'IdM!+cnR5B$Ae=X3^h$0Q[Lp!B^"MX<&0:0dUnEb.^<"Yl/**,6?s>dhr^Ub]AIaeb@r
C?j(<dcjTKQ^EJa-5H8<WkpHfW-4_=AC]A#UYsV6_d#rZ<>JN<q<QkY='@jN"3s[l?jtS%##>
YJ0h*Wbp$OMn[@BB+(6W<=PRSWcYAC)ZW1D>)IfX0\lf5#$f(-%j&A#4&[7H_^0.?tl;Y%3G
MBEm$'3a.gR;O]Aas,P0HU-G)4,h3*X=gdA#IQHa(b'i>UI4_Ti=G/jC3rrnJAaHo?u8!cNm.
=l8l^7f=5]A'Qikh`Y3DOAm+,Ib%OlhcY`Nn5oGNSPng2ilXp=<X-O#j#_Y#16.X>5)I'.V(S
k?-jEXf/UbqF"F0K/WZ$\0'oq(L:Db4/;I2/13^*U>G4h>p?rFWSdt9)p?/91($:uUl>'WB\
e:nf$[D&fWq=[ir)IsAHa1bL;NdEAJ&8W.2aOqK`+1!!?VD3`Af.YO>GHu&T:/kc6Cac0C(e
=S7dL@`L>)4Obr_`pq99uP$7jfP'k`EiB_=c^EVKl2WQEe"gk`Y7YZ5E-i>mgf/Y:he"PAkO
?lM0nBro(Nr%7peD<8**T[hb6'`)Mo9Irp["h!#Cj\24$$C?h@l![QP%WrCL+(iK9BI]ApM*a
70DT@Q>_l?mRGI^&bfVO]ARBB[KlB57/K)Lk':/dnhJZtc8sH8_L=M#q.[Ylgp2Vi,_&`BH9"
`Z;#Wc")Q+bBZ*2Wc?Yd8H2%$U'-%=c>ue[;>Tnna)G-YdAMB5C<hP@f.\s%JnO:5VfJUtRB
9Yc-N63%9l5BeQ:@.qQ!/%-eEH6kab;LM=rKhTd4lQnM*aW1'h9(JAJn(LrrURY_8O`J\O'U
<5r`JaJK?"610HJG??<jl@"?7^Gt^]A$`:WDEBpg=nKaaWB?+GaQG4]AYPICG\V0\C[anjck-R
Y\'^oF#,7;aO?/qXC+F`5'LLfPn:D>3WL3_pi.g3CHna!@EJG**Qj!hZ2?Z%9b@6bl+OBR<U
DC!4g0c$>^r2TOo3noG&S?N;?Q8Vq7<*?A5?\X'f\64c:b%Du+<:-ZAl&ZDO9np!VN<cSX(e
Y.S.*4`pMVSg49`-aS2H%CnHdgNJ>cn'D:e9X#G2dO:&=K6D^obeIapjL4]AjJjjJ]A`g:?.$^
\Z!r<.1H:7"U.rLVP]A[!"KU9/ilIpaUcK"#>As(Tir/TYh_D3Ph)$Tk<4VDCaA[#B\5><pjr
PQ8uaf6^2^Y#c$esa8b+.Z]AXkD'iAiN=3X;q'.4MtHLD+eNuY1"OVY"+c?V+qip+&)"qAZ3i
qV"eMg'Sa9Fp2i+$//RnufIU6eBL6[o2@qD?"7/C.6'ms1*4/IhD^q:Ad90\Ti@QYfEIR&Md
E<ks<uhCRq7P;]A^Qk1qA4u1Jiei77<lNj`E5&AZed\>]ARe8*?EG6BlpV_/k=85KG2"+9\J[Q
Vm(8>K+Y86l><BE1,2Qj@]AoLjrT&j^^B!gXir9gNO7^?%-L!C6*MGmpjPNnD+[(:s`/%"YMd
O9S[Mp1Yq>KU`+-0[8asDD2Pc=W%If.elH&qSfL3(P5oRUt0UaJ+NiV_&O=fU72B'`Z4m]Ag&
qH$'Y=)eUH=>AsE(G*,>2noid\RTIUD1Kr(gP?iIDVL/iM>&H_q*8A]AnT&&gLp]A9^hNV7]Al_
3gN+&'EYLW>?;.CJPG!eUfK>%@Y+d,.hQ".]A0N=B0Z`]AjP)8^i4_+>3:*,jni0+@0#es-@-Q
u1;mAb370@n?;=FPq00u1]ASXWoAr^.8q+"LCJF1NmkL,)UWfU4U&RJ+;AXP[oKki81Fe\F$_
dA6\4hZqD&IuRhZN9bWN*cpt+qDN&l1sb]ATcacJ#T6PHJrVU3<1``QV%%Y4&:@a`]ADdXc`KA
$2\:@W<38_ppkUiqKsK@:apc@;HC\VW?3cIq4Ni(<$3?0oIsE8'f"Y!4`)0*h.X7Z+o\)%ut
FL`QX63fpXQP#5eMk[:eq9-lOD(#m\>g@UMb:VX8kYLAHb&6Rk[bK:r`pN05AIa6RUe<h`%>
#66r=N(i=DNjda]AZ&WljN%Hg0;0Y%\V!/U>'#q,Xk%$!Xl't_:K#fl'f1ZO\8bs]AKA,hRn7T
3@P^;@!lMGs+HW[s^*.rr8_&Q,*iu]A9lcLkf_hcFb%3_"<Hf4j<D(X3ZOdU^o_NCJu8^/W1d
n:hp;^n;#&S<sHb@Aa2F\tf^-B?C^=EdZ(jcn0FtJ$V71WR7=S#s.BA"kGogaG&6a10#Qg/c
(XRQFb]A%RY/iSgjbSTr9DZ-]A\o#-a*p"!TkE,nNiIBmVoCJmdT<Cb$gG9J%'9`=[q43%bkWh
$T7$6Te0&6Z:WMI#)J"dJ7b'^`)<=ADLcF@(OKnTo)=Nrf5ph89#k8-IK8e3ED`V5N%E>1P-
:\EN*K:u:D4f4f<[tP'G`nb6,f@]AElOaf;B'T3$)s!]A'(8:1='dT-5<A9W\&j5D@/kUk\fhA
;@P0;So_#Wp_L)*^7W-+?$Pfd3$q+4.`OHaTG#PA)ADZ2I0isCG4T]A)#k)%r:W:W9*sHl&OI
Rrd:!o=f+jN"^-/rtO_S(sZ(eI>['dD;]Aec2uM.^N1>gLIWAYt#uuI:i8#G$::f/N/_KO:[b
Ff#SBe2Xdn0TLHJ3&FUShWTCaW&@IP+Ftg,n!k8kmuUVtfIHffoGtf@))cF.FC/:]A6gXf@']A
6i]AqH:b8tA+=OX%0c#h,mX`8i?&F8:ilQ,Q^dg9]A>^7Qd-G&;,kr/d3u>[PCURLIp)l&.b5a
5&``*,(gd%3\i$R.HNleoRMr;&RXm2JI7?/SB&!#r_YE6OCQT</]A;5h'7EW<eg7G"AJQdITK
>%aD>CV6pr#:YuqY#nI5*3n@HZkn>K-$4BW0-gc,t5(S4QN.22<rrQ7s^9ikTQD`r2:/3WT>
"]AN2.4j*G1<XrdF'qDN!&su"^35]AHL&M^n4hM"]A@XPbj/ns?Bqq%*dVEqbT]A3/7($1XbH&N7
7$;b:p#2X6'05+kkqZH%f*h!ToQMEEpn'2WXBKOlcht11%'jM/-[YYrgsDh:^[G8K@4Zlck#
dC>Aj<&p\#FF`fcM&`i+<F7PkND=9\*$=I(a7R_4$*XE7CNCB%r7Y[\bF]A@n*DiafT%Bn8HL
L'+XjH@?Db`q',NcX/Nb/F->f.SA`js*Z:[jZp%0GDWKIH6P=\iRG%LPL3O,\61Vgg/W<3+5
Au+M\o`fu?5H2EhaKmb4WO2UXQ4=BA+2diVL-feHT5#o'6^[?0']AoJZtDWe!^t.SV<,i+`sD
2O&hn?06d_]Aj<E<'#=&o%bIq0*^a_:!o&r8mJ8+I/(1or*,7R8:'=C.pVmrbq$mY$Emse%),
CF_,RPh=%5,tlnQ:Q:FAs]AK)%7&g.U`n!@ZO/CI++iiJ"gF9N3#`=B"^r"QGCdoEUr.sm)B'
nU-qh*5*7+'c<7>T(*sqrMkfq3d;csV_$.+I2!0@I8[\Ym>Eqf&%5)3fS$Rp]AOfie!GuUajE
&O:=Cj,u25+95shPEGRq#%l,~
]]></IM>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="250" height="150"/>
</Widget>
<body class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="report12"/>
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
<![CDATA[432000,2743200,2743200,2743200,2743200,2895600,3168000,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="1" r="1" cs="6" rs="12">
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
<![CDATA[节点达标数量]]></O>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="64" foreground="-1118482"/>
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
<AFStyle colorStyle="2"/>
<FillStyleName fillStyleName=""/>
<isCustomFillStyle isCustomFillStyle="true"/>
<ColorList>
<OColor colvalue="-14231300"/>
<OColor colvalue="-798957"/>
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
<FRFont name="Verdana" style="0" size="88" foreground="-10066330"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="false"/>
<AxisLineStyle AxisStyle="0" MainGridStyle="1"/>
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
<FRFont name="Verdana" style="0" size="88" foreground="-10066330"/>
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
<labelAttr enable="true"/>
<labelDetail class="com.fr.plugin.chart.base.AttrLabelDetail">
<Attr showLine="false" autoAdjust="true" position="6" isCustom="true"/>
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
<FRFont name="Verdana" style="0" size="88" foreground="-10066330"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="false"/>
<AxisLineStyle AxisStyle="0" MainGridStyle="1"/>
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
<FRFont name="Verdana" style="0" size="88" foreground="-10066330"/>
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
<VanChartColumnPlotAttr seriesOverlapPercent="20.0" categoryIntervalPercent="30.0" fixedWidth="true" columnWidth="25" filledWithImage="false" isBar="false"/>
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
<FRFont name="Verdana" style="0" size="88" foreground="-10066330"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="false"/>
<AxisLineStyle AxisStyle="0" MainGridStyle="1"/>
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
<FRFont name="Verdana" style="0" size="88" foreground="-10066330"/>
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
<DefinitionMap key="line">
<MoreNameCDDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[3]]></Name>
</TableData>
<CategoryName value="HOUSE_SCHE"/>
<ChartSummaryColumn name="RATE" function="com.fr.data.util.function.NoneFunction" customName="达标率"/>
</MoreNameCDDefinition>
</DefinitionMap>
<DefinitionMap key="column">
<MoreNameCDDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[3]]></Name>
</TableData>
<CategoryName value="HOUSE_SCHE"/>
<ChartSummaryColumn name="FIN_PRO_QTY" function="com.fr.data.util.function.NoneFunction" customName="达标项目"/>
</MoreNameCDDefinition>
</DefinitionMap>
</DefinitionMapList>
</CustomDefinition>
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
<BoundsAttr x="99" y="185" width="392" height="273"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report13_c"/>
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
<WidgetName name="report13_c"/>
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
<![CDATA[381000,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs<>2]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="1" s="0">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs<>2]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="2" s="0">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs<>2]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="3" s="0">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs<>2]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="4" s="0">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs<>2]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="5" s="0">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs<>2]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="6" s="0">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs<>2]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="7" s="0">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs<>2]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="8" s="0">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs<>2]]></Formula>
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
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Left style="1" color="-6025441"/>
<Right color="-6025441"/>
</Border>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="250" height="150"/>
</Widget>
<body class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="report13"/>
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
<BoundsAttr x="211" y="182" width="18" height="216"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report11_c_c_c_c_c"/>
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
<WidgetName name="report11_c_c_c_c_c"/>
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
<![CDATA[0,1728000,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[0,1440000,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1">
<O t="Image">
<IM>
<![CDATA[!Smf$rJ=?G7h#eD$31&+%7s)Y;?-[s,QIfE,R=SS!!(sXR$[jR!i/CU5u`*!m?YA";c+OTDu
--'95pgX`=C1:0#=sD;$<eicq.1d`1]A/H/dgE$rr=-C"Wc@M(*#.Z2N.35U8/;dC[$HiUP!D
eaRT/@q46RnQJ4MsWQH6q*7"$N*hReNf2>4DJ!5m5^]AX.X4J70*a;Q+<JhBDDTEMV(.;9H)k
BPI<!hk,T\d#9('2TbbJ5/GUdK[WR+b'(X)$`LV<p1P\%s=.rSVGFq/[9MV5N>q,!?kU8/B&
jZK\/6t:S<q'QW?`F!V'rk36&GX%"olXcm0<k^)qZ4(E\KFcc+o/b3,tnk2M-OZ;8*JdEaIc
@EHtr.hEB-Ja-h"i[iYD[B*^6gfJ!tl4;;!4gh(u/1tr8OsaKb&GJFOe,[IhfAl-kEr/+`;U
LR)G$HYkH0.h<l<\r0onE(5U6!(XWiK7%$^_O7loW8P0/M-oE`:T[#lCCGg!Q?WZ(<UaH3O^
CT6BTX$8G;YJ3$UoSLer2Gq37chJ0&-UdTE.^?'c]A/T#6LV^W`pFR&[_]AmPqUd:lZ)NbdOgo
U`McR0";b;Wn1E?cj*QMgd]AVQ?L%X:`+CL!=8SDML9LN_Ka#(h\^jqOfnm9`$0ho,s1dK`YF
<ig@n`2U[94'5TNP>c)HU`>YD[14i"T$jXi+Y%O44?[HMs!R2p8uK7/&d92Q8s:2p%cNq$]A2
W;n?fK#.4sdDa.iG@P&K?(+F?Xn*f9oG?/QBd!B_%<8_/*;>SbkU2jLa=?eRW,*T-il`G*(S
C_l:f"?!%g&Gqj"`F<_d<,<JHVtblA,)885,TM0UKI4S$_'-[d;I\O6?EZ/';3JO9:FppO+R
dX.#1(a@Mrsp8[[a$Zo?/FoW&o"8_J;IKPH4XBB-_72Q")!!#SZ:.26O@"J~
]]></IM>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 2]]></Formula>
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
<StyleList/>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="250" height="150"/>
</Widget>
<body class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="report11"/>
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
<BoundsAttr x="294" y="387" width="30" height="30"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report13_c_c_c"/>
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
<WidgetName name="report13_c_c_c"/>
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
<![CDATA[0,1728000,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[0,1728000,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1">
<O t="Image">
<IM>
<![CDATA[!Smf$rJ=?G7h#eD$31&+%7s)Y;?-[s,QIfE,R=SS!!(sXR$[jR!i/CU5u`*!m?YA";c+OTDu
--'95pgX`=C1:0#=sD;$<eicq.1d`1]A/H/dgE$rr=-C"Wc@M(*#.Z2N.35U8/;dC[$HiUP!D
eaRT/@q46RnQJ4MsWQH6q*7"$N*hReNf2>4DJ!5m5^]AX.X4J70*a;Q+<JhBDDTEMV(.;9H)k
BPI<!hk,T\d#9('2TbbJ5/GUdK[WR+b'(X)$`LV<p1P\%s=.rSVGFq/[9MV5N>q,!?kU8/B&
jZK\/6t:S<q'QW?`F!V'rk36&GX%"olXcm0<k^)qZ4(E\KFcc+o/b3,tnk2M-OZ;8*JdEaIc
@EHtr.hEB-Ja-h"i[iYD[B*^6gfJ!tl4;;!4gh(u/1tr8OsaKb&GJFOe,[IhfAl-kEr/+`;U
LR)G$HYkH0.h<l<\r0onE(5U6!(XWiK7%$^_O7loW8P0/M-oE`:T[#lCCGg!Q?WZ(<UaH3O^
CT6BTX$8G;YJ3$UoSLer2Gq37chJ0&-UdTE.^?'c]A/T#6LV^W`pFR&[_]AmPqUd:lZ)NbdOgo
U`McR0";b;Wn1E?cj*QMgd]AVQ?L%X:`+CL!=8SDML9LN_Ka#(h\^jqOfnm9`$0ho,s1dK`YF
<ig@n`2U[94'5TNP>c)HU`>YD[14i"T$jXi+Y%O44?[HMs!R2p8uK7/&d92Q8s:2p%cNq$]A2
W;n?fK#.4sdDa.iG@P&K?(+F?Xn*f9oG?/QBd!B_%<8_/*;>SbkU2jLa=?eRW,*T-il`G*(S
C_l:f"?!%g&Gqj"`F<_d<,<JHVtblA,)885,TM0UKI4S$_'-[d;I\O6?EZ/';3JO9:FppO+R
dX.#1(a@Mrsp8[[a$Zo?/FoW&o"8_J;IKPH4XBB-_72Q")!!#SZ:.26O@"J~
]]></IM>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 2]]></Formula>
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
<StyleList/>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="250" height="150"/>
</Widget>
<body class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="report13"/>
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
<BoundsAttr x="393" y="387" width="30" height="30"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report12_c_c_c"/>
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
<WidgetName name="report12_c_c_c"/>
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
<![CDATA[0,1728000,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[0,1440000,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1">
<O t="Image">
<IM>
<![CDATA[!Smf$rJ=?G7h#eD$31&+%7s)Y;?-[s,QIfE,R=SS!!(sXR$[jR!i/CU5u`*!m?YA";c+OTDu
--'95pgX`=C1:0#=sD;$<eicq.1d`1]A/H/dgE$rr=-C"Wc@M(*#.Z2N.35U8/;dC[$HiUP!D
eaRT/@q46RnQJ4MsWQH6q*7"$N*hReNf2>4DJ!5m5^]AX.X4J70*a;Q+<JhBDDTEMV(.;9H)k
BPI<!hk,T\d#9('2TbbJ5/GUdK[WR+b'(X)$`LV<p1P\%s=.rSVGFq/[9MV5N>q,!?kU8/B&
jZK\/6t:S<q'QW?`F!V'rk36&GX%"olXcm0<k^)qZ4(E\KFcc+o/b3,tnk2M-OZ;8*JdEaIc
@EHtr.hEB-Ja-h"i[iYD[B*^6gfJ!tl4;;!4gh(u/1tr8OsaKb&GJFOe,[IhfAl-kEr/+`;U
LR)G$HYkH0.h<l<\r0onE(5U6!(XWiK7%$^_O7loW8P0/M-oE`:T[#lCCGg!Q?WZ(<UaH3O^
CT6BTX$8G;YJ3$UoSLer2Gq37chJ0&-UdTE.^?'c]A/T#6LV^W`pFR&[_]AmPqUd:lZ)NbdOgo
U`McR0";b;Wn1E?cj*QMgd]AVQ?L%X:`+CL!=8SDML9LN_Ka#(h\^jqOfnm9`$0ho,s1dK`YF
<ig@n`2U[94'5TNP>c)HU`>YD[14i"T$jXi+Y%O44?[HMs!R2p8uK7/&d92Q8s:2p%cNq$]A2
W;n?fK#.4sdDa.iG@P&K?(+F?Xn*f9oG?/QBd!B_%<8_/*;>SbkU2jLa=?eRW,*T-il`G*(S
C_l:f"?!%g&Gqj"`F<_d<,<JHVtblA,)885,TM0UKI4S$_'-[d;I\O6?EZ/';3JO9:FppO+R
dX.#1(a@Mrsp8[[a$Zo?/FoW&o"8_J;IKPH4XBB-_72Q")!!#SZ:.26O@"J~
]]></IM>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 2]]></Formula>
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
<StyleList/>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="250" height="150"/>
</Widget>
<body class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="report12"/>
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
<BoundsAttr x="343" y="387" width="30" height="30"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report10_c_c_c"/>
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
<WidgetName name="report10_c_c_c"/>
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
<![CDATA[0,1728000,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[0,1440000,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1">
<O t="Image">
<IM>
<![CDATA[!Smf$rJ=?G7h#eD$31&+%7s)Y;?-[s,QIfE,R=SS!!(sXR$[jR!i/CU5u`*!m?YA";c+OTDu
--'95pgX`=C1:0#=sD;$<eicq.1d`1]A/H/dgE$rr=-C"Wc@M(*#.Z2N.35U8/;dC[$HiUP!D
eaRT/@q46RnQJ4MsWQH6q*7"$N*hReNf2>4DJ!5m5^]AX.X4J70*a;Q+<JhBDDTEMV(.;9H)k
BPI<!hk,T\d#9('2TbbJ5/GUdK[WR+b'(X)$`LV<p1P\%s=.rSVGFq/[9MV5N>q,!?kU8/B&
jZK\/6t:S<q'QW?`F!V'rk36&GX%"olXcm0<k^)qZ4(E\KFcc+o/b3,tnk2M-OZ;8*JdEaIc
@EHtr.hEB-Ja-h"i[iYD[B*^6gfJ!tl4;;!4gh(u/1tr8OsaKb&GJFOe,[IhfAl-kEr/+`;U
LR)G$HYkH0.h<l<\r0onE(5U6!(XWiK7%$^_O7loW8P0/M-oE`:T[#lCCGg!Q?WZ(<UaH3O^
CT6BTX$8G;YJ3$UoSLer2Gq37chJ0&-UdTE.^?'c]A/T#6LV^W`pFR&[_]AmPqUd:lZ)NbdOgo
U`McR0";b;Wn1E?cj*QMgd]AVQ?L%X:`+CL!=8SDML9LN_Ka#(h\^jqOfnm9`$0ho,s1dK`YF
<ig@n`2U[94'5TNP>c)HU`>YD[14i"T$jXi+Y%O44?[HMs!R2p8uK7/&d92Q8s:2p%cNq$]A2
W;n?fK#.4sdDa.iG@P&K?(+F?Xn*f9oG?/QBd!B_%<8_/*;>SbkU2jLa=?eRW,*T-il`G*(S
C_l:f"?!%g&Gqj"`F<_d<,<JHVtblA,)885,TM0UKI4S$_'-[d;I\O6?EZ/';3JO9:FppO+R
dX.#1(a@Mrsp8[[a$Zo?/FoW&o"8_J;IKPH4XBB-_72Q")!!#SZ:.26O@"J~
]]></IM>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 2]]></Formula>
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
<StyleList/>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="250" height="150"/>
</Widget>
<body class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="report10"/>
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
<BoundsAttr x="245" y="387" width="30" height="30"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report9_c_c_c"/>
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
<WidgetName name="report9_c_c_c"/>
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
<![CDATA[0,1728000,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[0,1440000,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1">
<O t="Image">
<IM>
<![CDATA[!NlK$rJ=?G7h#eD$31&+%7s)Y;?-[s,QIfE,R=SS!!(sXR$[jR!d.(&5u`*!m?UI;<)F@MDg
meX$&!m97W=JAS5fq7BG7lag:2ri<mf8\d*a)k8>S/*0pi>!&BSVEd]AFHYr0S72/+MX[Y1pJ
r&a">P/oR<jcSmX]A[!7KnQ[@$Xh"0R>Hf'5U!6dm[\HBc80i/;NDZCYr):afEL@S/jGUXLnN
VBdJ9S&/5KZ]As:UGbqO<!maWeYZhKiu@:,E1M%mA$2Pl:n+Dt'=mG-/foZ854pRK]Ae^d@DWn
-gi?od'H4mQ_"+=HU#9$C;Y>+=F?Dh3SA(jep:jJU=6-X3:1>KPF0_,W[Hq["u;dAnbm$G;r
Y1)5U&1t8FC=_"F`FTS/!'br5m-js+MGmiS[^<2?f?#rY7!g&-C-`TFAElO)OHUl\5S^[j_<
X,8e,sN:oeP0A\H%^3#"Ut?OlhpSndErtb>$g28%:WXL:oabfo,$YS(SUsXf#,"Y*2XHP:N;
4[_AC')h%]Ab*QIC)[-rF4Zgh@'5ZtOE0D\C\FbTuqhKk+G2P,$p1s&eQ?tVP@`eo/P7UhRaJ
FW`6h;)a0j9l$C*r/uiL=f+ZhDRp]A%#:OhorbLOplI#!,[4u(g*U1i_L^j`pg3fS90DGC8>&
T%fhht"o,HfJ</70WooPg2W'3P?>(G%;Il\GEnBo>sHO]AK*Z&FqqO[OX!9tLV(J"[#uR<TP8
l6)_7/3q.'U?FiD75o^IbO46i=C%m96?1-U9E@o!iTg^]AW)ck-Fi<CNHchFq,ki.81`)5uos
NAVIdKBa(u<uB+MXq3$?<$9;9mduDZ)h5UiQcsJRY;P*p=I5W^9gRHM*!m!!!!j78?7R6=>B
~
]]></IM>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 2]]></Formula>
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
<StyleList/>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="250" height="150"/>
</Widget>
<body class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="report9"/>
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
<BoundsAttr x="198" y="387" width="30" height="30"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report8_c_c_c_c_c"/>
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
<WidgetName name="report8_c_c_c_c_c"/>
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
<![CDATA[0,1440000,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[0,1440000,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1">
<O t="Image">
<IM>
<![CDATA[!Smf$rJ=?G7h#eD$31&+%7s)Y;?-[s,QIfE,R=SS!!(sXR$[jR!i/CU5u`*!m?YA";c+OTDu
--'95pgX`=C1:0#=sD;$<eicq.1d`1]A/H/dgE$rr=-C"Wc@M(*#.Z2N.35U8/;dC[$HiUP!D
eaRT/@q46RnQJ4MsWQH6q*7"$N*hReNf2>4DJ!5m5^]AX.X4J70*a;Q+<JhBDDTEMV(.;9H)k
BPI<!hk,T\d#9('2TbbJ5/GUdK[WR+b'(X)$`LV<p1P\%s=.rSVGFq/[9MV5N>q,!?kU8/B&
jZK\/6t:S<q'QW?`F!V'rk36&GX%"olXcm0<k^)qZ4(E\KFcc+o/b3,tnk2M-OZ;8*JdEaIc
@EHtr.hEB-Ja-h"i[iYD[B*^6gfJ!tl4;;!4gh(u/1tr8OsaKb&GJFOe,[IhfAl-kEr/+`;U
LR)G$HYkH0.h<l<\r0onE(5U6!(XWiK7%$^_O7loW8P0/M-oE`:T[#lCCGg!Q?WZ(<UaH3O^
CT6BTX$8G;YJ3$UoSLer2Gq37chJ0&-UdTE.^?'c]A/T#6LV^W`pFR&[_]AmPqUd:lZ)NbdOgo
U`McR0";b;Wn1E?cj*QMgd]AVQ?L%X:`+CL!=8SDML9LN_Ka#(h\^jqOfnm9`$0ho,s1dK`YF
<ig@n`2U[94'5TNP>c)HU`>YD[14i"T$jXi+Y%O44?[HMs!R2p8uK7/&d92Q8s:2p%cNq$]A2
W;n?fK#.4sdDa.iG@P&K?(+F?Xn*f9oG?/QBd!B_%<8_/*;>SbkU2jLa=?eRW,*T-il`G*(S
C_l:f"?!%g&Gqj"`F<_d<,<JHVtblA,)885,TM0UKI4S$_'-[d;I\O6?EZ/';3JO9:FppO+R
dX.#1(a@Mrsp8[[a$Zo?/FoW&o"8_J;IKPH4XBB-_72Q")!!#SZ:.26O@"J~
]]></IM>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs <> 2]]></Formula>
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
<StyleList/>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="250" height="150"/>
</Widget>
<body class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="report8"/>
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
<![CDATA[0,576000,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[0,576000,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1" s="0">
<O t="Image">
<IM>
<![CDATA[!J(B&qh\-E7h#eD$31&+%7s)Y;?-[s,QIfE,R=SS!!(sXR$[jR"@u*P5u`*!XdDaP<C%JBa,
70s(-O'$U.hMYctZESRj*qZU(ReIU)">?Rp$Rk+@8"Qi?md!.AF:tD4q)%k+e9s/Mj_\V7l)
$>$>XhpHO+:F3gC;k8n^7]A3OKGhuET21NU9uF+l$T-NYuQ81!h`;PKHO8P%tkO-O`Z.d'nkV
3DS1C*\Km9lt0i_-8*WPVZ_hdposL2e=fS/LCf^nIJ"gO[dRcaIC.'"e;@YTs\PZL;jkZg2t
gW>DR8"Vc[o`(=l=2Ra!^!1,OW%5E`X7m6mI7_26*(Athe#*,B]A%2JUJ*1GkGCaU,r)1kT`K
EI\<,Dd;TsnlU]AX&e+Tb=BfgJ\McfGDWSZDL:`UBg`Qe1->X*2:9rhr*TJ!d9Q1r>Us3nN@7
gm$N"f:7RH=*^c%@@2<o;nemhir"K<YKqPidgPCNP_WkR:fXk=V*hL*#GbnMtfbaFc&djgFQ
0nlEL^Jnp0.XNO_52>%mNpt?TsBHn&;&b0%4;T'J&I3c-[5$Lb65Rqg?CFi&X'@4(_j+T[cM
#h(r(5+(&PnI5In!Ui:3tU&'!kCrRTBW4ZEK-Z71K8_:nNn>,M(I7q/5aO4X.RS0^6';\.41
#heW%/>>KRMHb&Y/)N.=Te1qgOs(B+#X1C@eUMuK?J9YWbJSnM2$dAbIjScs$2p`jk;I$)$I
F?3s]AHF`IKfE!ftnZX1d)Xh5c6b-!pI;T"\FSdj43i"1'MXEVaL21,E$uIRD_oklE'3&3_07
<Y6'YEo6O'HW_m+W3dK34<AZr)HcbA;p[*.OrAD#8?*CDqWG-kL1Cd2"]AV:,WtnVhFb%^GC`
emHT_bMul!dXaO/9Md(*TZpt9>s3PNq_:B1I&9:HJW1h2t0cA,6!>d?R8!H.FC^=>#UkK^j>
cu21g?>VD=d7D=2af[7m]AFIiRgeERhP&"RBf,9TNlfXc^GWCprenRH<`+lKlU9ePg2/UP<X%
i.IW#o\dePc)+lo#t:d^.FCGLQQ5elgQ+3UZ&@Q(R"Z6>N_L77Y@:-Gu-;]A!.&@p[eiN3i!&
qjKg0mGWT(eu;<T[Z5GU\F""Bp"'r,VReY?-:K?JW9T?#)IdOYd+36c]AaTl4lE,\lc[PE@m;
Z)geFlK%D!Z8ZGH[bnJ>NTP.l4+]A`p^TWPB)^?nS"PM>j(HJZ+dbT;Fu,_6_eU0KSHOETLR/
/dSkhm[ZNngs4(HEWUQE]Ab(YR^-Hn=KrRl]A;a/38Wg;f4sR<sf-aDpTu9gX3%%JoMuhUa:MV
eBMX;gGnOPB2,ZRD:\u,Z1Z/.BHoO0iC@=s'Fc*",hE:kL6DL_rG@>q+7Uh^15C6%f0<QlJI
efra>sCM3C>7<:@*@a#Su7h>]A4*QqH]Afc4fk=O(P&?a3JbM<'NOTTt_HA#pc71/*Hs5!!#SZ
:.26O@"J~
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
<StyleList>
<Style imageLayout="4">
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
<BoundsAttr x="145" y="387" width="30" height="30"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report6_c_c"/>
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
<WidgetName name="report6_c_c"/>
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
<![CDATA[403200,876300,114300,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[1008000,1728000,1008000,1728000,144000,1440000,1728000,1440000,1872000,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs<>2]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="1" r="0" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="0" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="0" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="0" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="0" s="0">
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
<C c="0" r="1">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs<>2]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="1" r="1" s="1">
<O>
<![CDATA[规划要点-摘牌]]></O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="2" r="1" s="2">
<O>
<![CDATA[摘牌]]></O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="3" r="1" s="3">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="摘牌-土方及桩基进场"]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="5" r="1" s="1">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="摘牌-规划方案政府审批"]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="6" r="1" s="1">
<O>
<![CDATA[摘牌-示范区开放]]></O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="7" r="1" s="3">
<O>
<![CDATA[摘牌-开盘]]></O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="8" r="1" s="3">
<O>
<![CDATA[摘牌-现金流回正]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="2">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs<>2]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="1" r="2" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="2" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="2" s="5">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="2" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="2" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="2" s="4">
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
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-14331025"/>
</Border>
</Style>
<Style horizontal_alignment="2" vertical_alignment="1" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="56" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="2" vertical_alignment="1" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="56" foreground="-6737152"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" vertical_alignment="1" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="56" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="56"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="2" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="56"/>
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
<![CDATA[0,990600,114300,876300,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[0,2590800,144000,0,1600200,144000,1866900,342900,2514600,38100,1790700,0,2781300,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1" s="0">
<O>
<![CDATA[规划要点-摘牌]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="1" s="1">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="1" s="1">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="1" s="0">
<O>
<![CDATA[摘牌]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="1" s="1">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="1" s="0">
<O>
<![CDATA[摘牌--土地及桩基进场]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="1" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="1" s="0">
<O>
<![CDATA[摘牌-示范区开放]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="1" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="1" s="0">
<O>
<![CDATA[摘牌-开盘]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="1" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="12" r="1" s="0">
<O>
<![CDATA[摘牌-现金流回正]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="2" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="2" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="2" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="2" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="2" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="2" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="2" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="2" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="12" r="2" s="3">
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
<Style horizontal_alignment="2" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="56" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="56" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="56"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="2" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="56"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</body>
</InnerWidget>
<BoundsAttr x="111" y="402" width="387" height="51"/>
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
<![CDATA[="数据截止日期："+sql("oracle_test","select SUBSTR(max(data_date),1,4)||'-'||SUBSTR(max(data_date),5,2)||'-'||SUBSTR(max(data_date),7,2) data_date from (
SELECT max(data_date) data_date from  DM_RES_HANG
union all
SELECT max(data_date) data_date from  DM_RES_TRADE_RULE
union all
SELECT max(data_date) data_date from  DM_RES_RISK_RESOURCE
union all
SELECT max(data_date) data_date from  DM_RES_CHECK_RETURN
union all
SELECT max(data_date) data_date from  DM_RES_CHECK_SALE_SIGN
union all
SELECT max(data_date) data_date from  DM_RES_CHECK_RES_SCHE
union all
SELECT max(data_date) data_date from  DM_RES_CHECK_AREA
) res",1,1)]]></Attributes>
</O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="4" autoline="true"/>
<FRFont name="微软雅黑" style="0" size="72" foreground="-1"/>
<border style="0" color="-723724"/>
</InnerWidget>
<BoundsAttr x="532" y="0" width="315" height="23"/>
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
<![CDATA[2160000,2160000,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O>
<![CDATA[前十名]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="当前表单对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="ordertype"/>
<O>
<![CDATA[前十名]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report12"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="当前决策报表对象2">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="ordertype"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report6_c"/>
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
<![CDATA[$ordertype="前十名"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320!n%B?/B>R2,VO(tmK?F%Sh?$H'm&6gfZ;fT^r(-\bd!HkLBPnYWi
0I@nGF-;-eg`\B!TYP.u2tu4R^J<`3;LmJ`/0_6cO<sS$d5d`#p%C"p\oJL0KTF(\egcb4[E
?1Dq%<r0BqN[?oVr5_3LEe%Z\a)]A:bDrERo6,r>W&~
]]></IM>
</Background>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$cpcs<>3]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="1" r="0" s="0">
<O>
<![CDATA[后十名]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="当前表单对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="ordertype"/>
<O>
<![CDATA[后十名]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report12"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="当前决策报表对象2">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="ordertype"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report6_c"/>
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
<![CDATA[$ordertype="后十名"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320!n%B?/B>R2,VO(tmK?F%Sh?$H'm&6gfZ;fT^r(-\bd!HkLBPnYWi
0I@nGF-;-eg`\B!TYP.u2tu4R^J<`3;LmJ`/0_6cO<sS$d5d`#p%C"p\oJL0KTF(\egcb4[E
?1Dq%<r0BqN[?oVr5_3LEe%Z\a)]A:bDrERo6,r>W&~
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
<FRFont name="微软雅黑" style="0" size="72" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<IM>
<![CDATA[m94p7*9A&.@tV&^BXO9UI,))hi_5@0&^;,24-8+YJ@RKt9e-mcn^OTBUe2gBmV\rR8Z$X?1W
>)'Z+!.r0KSa:S:E>5CBr)g'3GYLG6`\YF-,MD?uo\%++(V<Q\7Eif_=Ac7)kO^qeLE5B:np
DIa@KYGk\D22f2fAg[a*^P*-SDqT+CC8P(l48P(kODOiFdBm"XUPEb^t\jn^?5#M.<G^o/QB
i".U3O:JA(Vae?d!>*:c.a"MVU(Tmmi$)TdkL6/?/7-lOlE3]AT$d5d]A_Ejm'eL5aqsJpt_E7
4JF_9?^q0<#qTSW'D!=pC6kLl$7[CQI_a7.!HmY6jAs)WmVm*=3JJ.UrkeHQ%Bb"cSi`j_g_
7NRec/^7@Y2Do>;hYDW'i_,74#T5o6@?2VlrM8ZJr3"b5QQehT;*\'eGN&4ZVR0TT;McLKV]A
9(.&*Mqp6LWjTLEZo5BV]AC[\gk!^V_@^Tku)frYX))2K7"6`UBYnkJIg/;)Q588'L59P+&?$
k^L(WHc400;c7u#U)J))r!q\u-X%Wjs8m2MY!!UO<GT5dY_N?pt"od[3("hKQ8n'EZLm]ApKV
@OD4&pf;7r\m7%G<j,UWSp%9:e9(i<[$R'C2,cJ@Hh5Rc7OrfS*i`?L!lF:MP$*$O`KjJ#8$
92-)oSVs*^[C"M_/@eEmOMMi;RW,h4#BWZ=/pQ"TBDLh=RY>nI6P(OkH;')W$sEA#l1=":lM
,5-;M.i`g38!6l'._JTe(i8Y>5$j/.F=Yrn#gMkABrc&-9V%%CrW_4%+HhJf:<]At8f;g?d2W
nIK2P+cI*[3J:hDWVl\[LbSp`XBjFFHG&-:K_>$+-ab_NtM4:(<9Bi3K_j*k![kWQ(oY_q%)
_7,#%8WIA&,PPkO[8@N3\[gWDq<e&X*MTqJU;8i'P`nki'd^gV-4*&pfs'J3lDN>G)&@Vq.c
m\[uKlpA)Q[B7)a[c3QOpPB)5UrrCMgZGXm4BGQ!Im#hPQ!-`?b/R;%ha7&W+C5jM"$*7UNp
4cL.Kgg``taY%U+\7p7lNE_dD;ahU/rB#u#)M?NVbVZ;>JUIMTORXN'+Y+T4u4oI4b:21$>-
DXrRbUmQpKED(YlY6o1Ya(W/G'Z5>>HJX45As2-h3U&,(#OlP8QGnD./B2Jn6p=eJdiLj\*?
/L12$gr>PqcITi*N^Tqm,0!UGX&IWj,LO,c:.u%D$=slu"3lnP(,`9PZEAeiT`l04$p$COBE
iLf&I-[l9QoNcc?4dEp=Sj4dkC9RH"d"FH3.@cU4D\K*N9QrNL5=d4s#oXq\pV0/tOkH]AmhP
HNeee`Y)`C98R>(ogC@.@k]A!Z+4mRN(er^?+(kpqfJO[pA9GUX%V=9RV&Tbni#*kRQIAc[Zm
r)nDOb#0s<!(EXF%Jd+'EM!bXJ5\L8aKeuXX&$heig-Q2:.9U3[+0aRI4]AHLk:VHDXGdoNo\
;Cn-aWQICM%]AfnqgIL._?bMH?%9C:;.\s0h]AeD+[WhWp741RT\O+GmR:n>QW8*-#-oY7Iq#q
Seef(4nZos)V+m#ooGj\YU'fT2p4l+`U1`Hr=+fdqj80Fu!Y4*,`E/uaE"1?rX$U"1^jj8tW
gR4c6Z(<7FC>n0[9E@#=_aRt5a7PYTFZR9<3A;ciT'#YTSkEj@RA*.5,)?ue,Z"@#KhK0hs(
&DChf:FC(Akl-F1?O4@&KY*tS/,!I#(_lfA3bJ]AXRW1X=CX\m_cLcG5SPBOfKd&>Yt(9ig&8
"bf,Hg[jYoToEq<'/'EX+94gSa7@jXh3^o<4(.MHmb+(T?@N6t25H<,/m5\7CF%2A!?X+C%:
_%Sn<GMrrS"htSn`R19:S4s*,:`Q00(<S$G>>MIubW-L+1Qp[aH*d`kQ$js$_C,P6iCQ'?ZS
NVtaQe7D6.6/Q.*XXUQnpH9+M5f?H(hBcdB"YAO>kN&1hngQB;U8$'>mVl'WMes'47<M)bF+
6*'ULq=hn0,s6>JfPIpu%KLtXJfQu.h,1qT7V;M&"c8#2TI46mtGX)^Np2(I2HAGiGC/3Dm[
MfT#i+A#%==7WJo[&d\R^8^7bI2*g::Qd"0JqnR!?>$!'sj313[SK9+f<s!O4g)E_=!3aF-2
23G2cIf7nbsA,[_>Ci*!sKB-8d4#+m?'fqGssAK473F8PXcIU;<c69Oh5NH;Kk$OuTk*d$3l
b'V?O`Xc\N:dY1'p@0!.SB=X9+hN.0q(:7DJU/`Os8QgmF1RUR:P2SH1OrQn/Ij6HSG`n9O(
CAG0qZ;.=tm@CW*J;sLDUi+K@@V@_>[0,dpSfO;8GF!D5d^Y`O!+Jf8)<@F)E;"DF^33DK$Z
RYjKL,m8-p48re@?=97mT\?[aCqp8_68R'"3Ga@nZGbWoM+PPHfoc/Y!,F%)qB@\O^D)a;rD
m\?j`=se*&>210_af>54fS0';h#>te;faC*RKP@l6rpDMr7iR.==mG]A*X4C(4kFa2;RVU[`P
RURrJ#kNaU")!1<h2j!T7fs3+Mb@/F1rGF^4"X&1!F@:T`YCl@>&>V/!X;']Ah/`h%X\<`#IN
DDo=.4t0CN99</,cn84.35)@tbBfjM:`sX06+*76"2@tC<^t,$_KH>WqPp:;bVYqP/P*Z)2U
+iAArK+4-[fuj>N[>b9]A@(gMj8;p4!6VXMKDp[nf2CumE%m]AZ")@Zmcqh#K3@kG-T)V,ULpj
"g?hAX0sIq3Y&Al8<OMNkI^/qa=&s\eX@O,+VXK`PI"e@uD>T(m=upnsV2hc(0sWs$e1f0[D
oa10ZCo`V+*El0Auqp/iLee_?6/.>:_[++B4M53$t1-6p=<aCl0j:_UEek+r..%0/6ja)'0[
+$]AZ)r[5%ps#>YU*sgmRQ=nUFM7XHa_'+tGbrN+Jm^bsH(or1':\eWD%:CP0ANVe`,X@>Xma
A+iGp_OhnIO4Sq63#1j=#2tEmq]An)j02/A\i,q:Lm`sf7Q2,VqjM\4e1_qQYN5:sUrTY+?fM
o5P28!J&&@dalK2_AjDk*eacS'k-;mR?mQWEU>ih.6(]A:eqt$959[O'tR5Mt?i5[S%+A<ORX
@k4"UP!clmSq:UeCg^MGBb[X%Y`D\]AZ)uWS["00IgOUGe4iRRFm4B%B38G=8MjMYr9CknY'8
g3PFC#B*Sma!9W.SY>smjMpni+W4EJ2u\/$]A@1lI-!m@e?L#l%N)t^HmY-'@Cf.k_@H>g,'3
@-CQ*DtgqV2_r]AL`BV"u2J#\Xi8`\!+9"ANoPREJ1CK:sZ&Y@rKMrVK!#0F,ST:b38SK&%cF
J^6C4+>PuIc-;KfKq;:Bf4`*=c!''IBH`c!g4QQ?4;Pu3^'QZ1`$XKnOsAKs\o(W:69ts'F4
$@8c*)63;u\+1Qpp)1"&o9eX1!J&:hW[-g6k>s;<568%MIY?&fN%@QsQKl,2J_;3%P1Zs':r
p\BlcZ.0%,7NY8I21h:IHm\@_I*TF?6%,nRgI)h('^$-io$2Uo>j(&R_^P0tkH23=rs-JSgk
$!\qP`_$t!N$.jRI5I=I^_iddB&0aa%mh'WU6=-3qHQ[7[!Cjo\iL`503W=bPqS~
]]></IM>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="250" height="150"/>
</Widget>
<body class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="report6"/>
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
<BoundsAttr x="400" y="153" width="99" height="22"/>
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
<![CDATA[762000,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2160000,2160000,2160000,2743200,3456000,3888000,3456000,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O>
<![CDATA[全部]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="9-3c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="org_classify"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report9_c_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="8_5c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="org_classify"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report8_c_c_c_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="6-c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="org_classify"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report6_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="6-2c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="org_classify"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report6_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="6">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="org_classify"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report6"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="13-c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="org_classify"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report13_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="13-7c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="org_classify"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report13_c_c_c_c_c_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="13-3c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="org_classify"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report13_c_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="12-3c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="org_classify"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report12_c_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="12">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="org_classify"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report12"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="11-5c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="cpcs"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report11_c_c_c_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="10-3c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="org_classify"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report10_c_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="10">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="org_classify"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report10"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="9-4c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="org_classify"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report9_c_c_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="13">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="org_classify"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report13"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="15">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="org_classify"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report15"/>
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
<![CDATA[$org_classify="全部"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320!n'e./B>R2,TeR%FqdKDGe,kh<6TW7Bd5!XJcO!1ok1gUO".:%Fu
0cnM(<8nq4joJUXikub/GG2'bshS)?^21S/rNSkl)?:Eo9J#Ace,8N!L;tQ8cr+NU-qEG/Xu
=3KL90fU9*`\MVYs##A;bQZZ%09`P~
]]></IM>
</Background>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="1" r="0" s="0">
<O>
<![CDATA[环京]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="9-3c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="org_classify"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report9_c_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="8_5c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="org_classify"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report8_c_c_c_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="6-c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="org_classify"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report6_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="6-2c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="org_classify"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report6_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="6">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="org_classify"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report6"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="13-c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="org_classify"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report13_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="13-7c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="org_classify"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report13_c_c_c_c_c_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="13-3c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="org_classify"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report13_c_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="12-3c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="org_classify"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report12_c_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="12">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="org_classify"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report12"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="11-5c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="cpcs"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report11_c_c_c_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="10-3c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="org_classify"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report10_c_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="10">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="org_classify"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report10"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="9-4c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="org_classify"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report9_c_c_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="13">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="org_classify"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report13"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="15">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="org_classify"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report15"/>
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
<![CDATA[$org_classify="环京"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320!n'e./B>R2,TeR%FqdKDGe,kh<6TW7Bd5!XJcO!1ok1gUO".:%Fu
0cnM(<8nq4joJUXikub/GG2'bshS)?^21S/rNSkl)?:Eo9J#Ace,8N!L;tQ8cr+NU-qEG/Xu
=3KL90fU9*`\MVYs##A;bQZZ%09`P~
]]></IM>
</Background>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="2" r="0" s="0">
<O>
<![CDATA[外埠]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="9-3c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="org_classify"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report9_c_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="8_5c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="org_classify"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report8_c_c_c_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="6-c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="org_classify"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report6_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="6-2c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="org_classify"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report6_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="6">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="org_classify"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report6"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="13-c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="org_classify"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report13_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="13-7c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="org_classify"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report13_c_c_c_c_c_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="13-3c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="org_classify"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report13_c_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="12-3c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="org_classify"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report12_c_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="12">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="org_classify"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report12"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="11-5c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="cpcs"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report11_c_c_c_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="10-3c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="org_classify"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report10_c_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="10">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="org_classify"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report10"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="9-4c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="org_classify"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report9_c_c_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="13">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="org_classify"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report13"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="15">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="org_classify"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report15"/>
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
<![CDATA[$org_classify="外埠"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320!n'e./B>R2,TeR%FqdKDGe,kh<6TW7Bd5!XJcO!1ok1gUO".:%Fu
0cnM(<8nq4joJUXikub/GG2'bshS)?^21S/rNSkl)?:Eo9J#Ace,8N!L;tQ8cr+NU-qEG/Xu
=3KL90fU9*`\MVYs##A;bQZZ%09`P~
]]></IM>
</Background>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="4" r="0" s="0">
<O>
<![CDATA[节点平均时长]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="9-3c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="cpcs"/>
<O>
<![CDATA[1]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report9_c_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="8_5c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="cpcs"/>
<O>
<![CDATA[1]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report8_c_c_c_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="6-c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="cpcs"/>
<O>
<![CDATA[1]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report6_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="6-2c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="cpcs"/>
<O>
<![CDATA[1]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report6_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="6">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="cpcs"/>
<O>
<![CDATA[1]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report6"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="13-c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="cpcs"/>
<O>
<![CDATA[1]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report13_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="13-7c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="cpcs"/>
<O>
<![CDATA[1]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report13_c_c_c_c_c_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="13-3c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="cpcs"/>
<O>
<![CDATA[1]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report13_c_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="12-3c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="cpcs"/>
<O>
<![CDATA[1]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report12_c_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="12">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="cpcs"/>
<O>
<![CDATA[1]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report12"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="11-5c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="cpcs"/>
<O>
<![CDATA[1]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report11_c_c_c_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="10-3c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="cpcs"/>
<O>
<![CDATA[1]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report10_c_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="9-4c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="cpcs"/>
<O>
<![CDATA[1]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report9_c_c_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="13">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="cpcs"/>
<O>
<![CDATA[1]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report13"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="15">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="cpcs"/>
<O>
<![CDATA[1]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report15"/>
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
<![CDATA[$cpcs = 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320!n'e./B>R2,TeR%FqdKDGe,kh<6TW7Bd5!XJcO!1ok1gUO".:%Fu
0cnM(<8nq4joJUXikub/GG2'bshS)?^21S/rNSkl)?:Eo9J#Ace,8N!L;tQ8cr+NU-qEG/Xu
=3KL90fU9*`\MVYs##A;bQZZ%09`P~
]]></IM>
</Background>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="5" r="0" s="0">
<O>
<![CDATA[标准工期达标数量]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="9-3c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="cpcs"/>
<O>
<![CDATA[2]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report9_c_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="8-5c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="cpcs"/>
<O>
<![CDATA[2]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report8_c_c_c_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="6-c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="cpcs"/>
<O>
<![CDATA[2]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report6_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="6-2c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="cpcs"/>
<O>
<![CDATA[2]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report6_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="6">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="cpcs"/>
<O>
<![CDATA[2]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report6"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="13-c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="cpcs"/>
<O>
<![CDATA[2]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report13_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="13-7c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="cpcs"/>
<O>
<![CDATA[2]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report13_c_c_c_c_c_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="13-3c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="cpcs"/>
<O>
<![CDATA[2]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report13_c_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="12-3c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="cpcs"/>
<O>
<![CDATA[2]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report12_c_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="12">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="cpcs"/>
<O>
<![CDATA[2]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report12"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="11-5c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="cpcs"/>
<O>
<![CDATA[2]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report11_c_c_c_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="10-3c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="cpcs"/>
<O>
<![CDATA[2]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report10_c_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="9-4c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="cpcs"/>
<O>
<![CDATA[2]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report9_c_c_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="13">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="cpcs"/>
<O>
<![CDATA[2]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report13"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="15">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="cpcs"/>
<O>
<![CDATA[2]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report15"/>
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
<![CDATA[$cpcs = 2]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320!n%=(=H8"C863D8MuZauSh?$H'm&6gg;r#V^r(-\bd!HkLBPnY0(
HGj_>.U9S8@flS&mG3>Lo0jgZdA2i$$=+ae[k<Y_9@!KQ4jfQ@e#EME`G]A$*,dc@W@ch&H'Y
IMFD9nZc%unV?62^>:Fkn5aO0L]A)&t=F%U*I!!~
]]></IM>
</Background>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="6" r="0" s="0">
<O>
<![CDATA[区域达标排名]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="9-3c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="cpcs"/>
<O>
<![CDATA[3]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report9_c_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="8-5c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="cpcs"/>
<O>
<![CDATA[3]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report8_c_c_c_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="6-c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="cpcs"/>
<O>
<![CDATA[3]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report6_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="6-2c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="cpcs"/>
<O>
<![CDATA[3]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report6_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="6">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="cpcs"/>
<O>
<![CDATA[3]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report6"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="13-c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="cpcs"/>
<O>
<![CDATA[3]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report13_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="13-7c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="cpcs"/>
<O>
<![CDATA[3]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report13_c_c_c_c_c_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="13-3c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="cpcs"/>
<O>
<![CDATA[3]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report13_c_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="12-3c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="cpcs"/>
<O>
<![CDATA[3]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report12_c_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="12">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="cpcs"/>
<O>
<![CDATA[3]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report12"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="11-5c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="cpcs"/>
<O>
<![CDATA[3]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report11_c_c_c_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="10-3c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="cpcs"/>
<O>
<![CDATA[3]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report10_c_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="9-4c">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="cpcs"/>
<O>
<![CDATA[3]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report9_c_c_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="13">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="cpcs"/>
<O>
<![CDATA[3]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report13"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="15">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="cpcs"/>
<O>
<![CDATA[3]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report15"/>
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
<![CDATA[$cpcs = 3]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320!n'e./B>R2,TeR%FqdKDGe,kh<6TW7Bd5!XJcO!1ok1gUO".:%Fu
0cnM(<8nq4joJUXikub/GG2'bshS)?^21S/rNSkl)?:Eo9J#Ace,8N!L;tQ8cr+NU-qEG/Xu
=3KL90fU9*`\MVYs##A;bQZZ%09`P~
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
<FRFont name="微软雅黑" style="0" size="72" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<IM>
<![CDATA[m94p;;s,#g]A1lLjZEN!09!Z`B\ohjnd9=6sX]AB%2Z^%tB34ZIp:oR/>,%*rZ>MW_YPT5Ho<&
D''[7hUc,">Tj\NM^Ydst:]A84^kQV@isHCIkt%jQ><C2s=E7jQ.@BVu)*endg"k5G%'44MUX
b4>61%C3eskq]A<C'/hV&,P$]Ahf+YIXV)]A(HL4o%1V2eLtC8)iO"\?oeoJeq)Roli!d9XOh^o
UJI05<3B:r9AFI`>S:lIDSeCYP\.$MS20LYO/4#'Dl*>q]A$]AFA[AOgE_-/^"OWVHn+_+>1#)
BLo[$DgAF7`Y!20P(c3CZ[=l0@,&sP1b>;JE5aH<;MaK:_W/FS)S<5\u--u*s@*dn-c<p]AKl
Jm%\3hO8s<i]AGL@f?fu9>2*mISm:ZT8+=Xq"OMcY)Qn#0L]A6b;08ipt.fh6!*(kJ`/_1Q*$\
t0b:OWu"<QN&K51Kgi8N&*p2B&r.;*DG%miMc9m<gcS:k*?T.3i-]A/0ObZZN`dJlIVWH'KIr
U?G:,/^<]AX.?C?>6$TobF8^4\>pjcD/*KDsPD('GX;/<>34)ntLq]AQNM=lq;@g,m[POd+M+p
opS=5>^[/`*_p[1edR-Ff:;tW&@a-Dd:.B]Ag\=@R&cpaAQR/'Giu0&:u2SIiq]A%RQk)o\hB6
E3Jgp.=!/:GV*aY^i*m9%hY<XYjl\iKGB3Ko"ld*lec_rm2Q@.'Qe:F.tOS$cj_qXNL/-mVr
600F">,)U/e%;F*qI^;$:$3R,Q$02C=f==b^6j9?Q,&fM4!RIN)ZK#BK#]Aah`;YfBH.VDUj6
;B;ASWerJ>oPH#KV*%]A+chdE,<WGbFUW<mYgDBP1YQLY9:#$#4GkC;2)5YE0jO)fXPock/FN
EYH'u"TNjX"Ul"gZ]AN$"DPBE!M..l-Pq=[\2)rRO^(M&p$#-c=AII1raH1Jki033]AoLD@f.T
[KW'C1Z6c3bcr:c"WZd5B(rDe1NeX3A>8g'dcWYB5P1`<sDRQ8+'C'icRI4/.:h[GRBFaV@I
0h)4KI5#+G-0k.9">dQQ$h[kVV!cd8ru:'*cRD!XG(%Tlu4pQXr+FX:3Cs3G)Mp^KCH,09`(
0DJ!q=sjO3:UR<eW;1SZQ=*@j*2aCA>V5.u:gu]AgJO+eqcn)1g_%P*^*kUeI@j><"0%l@5-?
;;1-71I"]Ar1Eh]APRJ@aQLf8O[<Eh6'N/,ntoKVK5^^*D0Sdb/Ze%\P]ArCN:Yhefbpt#m5Ii8
FZ>[Z2Fc9W(At+,1iUk<b2,0$gd*N5Zo(YESQI6QUis4EjDg#J+4__oJZ"A%S:h[>1eLP13e
_!uQTlcUCl[Hek4;0hjm^(*`6%]A7:Bjljj]Ag$GA04-N/Is@+"^86F$SZN$e&klj+mY<$J2>>
a?OboV:4aVP]A[-`47Nl?B[gKTEl$%Cuq!M0;oLaFObU:UK@1L!"H]AqJ>0rq?P7`K'@Ok,Wg&
2I8rQM?1Y\>f4ptO-U;\<gW_k9q_:4&sqm0)NF:rm#:/E%g;O@Rm-bWjMQr$qD25P.flNMM)
oqe471R/^<m4`j)<E0URnG6MRp:98:C5H2ZSts42%a@(DA!,8;I"X=>.9(msa3-BK-]AdSr7p
DPfW.Qq1U5<hthbU<6Yp^c6TgGmW=:G0Vu%)Ue7Bo`mj$:->7X"XDTZ8h.klH8'rN?nZppHQ
.>LAJu>e64__rQ4a,=HK>cTlN]A[f$TKeO*[g3q`?OAC<Lf$sn$jU^U#[PcBPp]Ah8*U,YrR+2
ge/L,9o.V#@J+1-&ihZ<RjW+p")]AC^:joouk;h[mC7Fo6;YeK]AfdZq?u3`\,]AXc6<MVZBR'g
6AMEas$\!D5Q?O7RZehI:+rFU9E)qU>]A"2Vk\7^Fnb1^Y9-ooN\@hY3dV-/OL=bgRk#7ral'
.@7/e31t-A]A:a,=,iBql^N/L@?(F@B_uOWrNrGNL7QINnK;6Io!cNQ:T&W`Yo#73^`:uM6o%
)l?.n)9XRYM\k0PL)W-%@+_DO:("20OKA+sH"]Af$^VP=U*BD<C27A_&[RAP+t4?B&71UD6]Ah
8RHq^d?aToI7511kHII[]A%'4^m6Y&BWtp(`iFDEJ\X@3*?9e7>fFhS;0(hc)s#Z:%O4umTb&
m90D=3&2o3VTmg\Ihim@6/>9J@h'?9*W,"CM;lVjQNP]AYFt.jniE9"6:;:)JUL[q.dd\4a7!
ZkPUS]Ahhct:M&c@TG(II'U&EL/P&%a*7p9DUQC>3$n,Z>3YmW,,Bs?7NtK#3Q63!`7+P8pTj
h:r#E?NXS?7Pm[\_;R1'7^ngm+S%Gq^$XLPkMMO.a#32p0@MUm!`/ZBV[Ah2)+L7@#2gAVlT
H%9+p('mSACK?=@TT.PWs\k:#Ci]A4uFQ-=(Mj>U68T.I>*"#;3S@2V/(>pSi6O5?2tJ:"hW*
p6]A!58O.c?)!4i&pAbI(3Afji?K_G%KdeT$&bFhZE4.p]AKD9sfDMM2@sAmcYMrK\S!(#YPT<
'Y>0q@15tQ_CViXTeGqBGpdfnm`*\pE%6#l9)C@ndS`nN[o)qL7E35kQuOQ/CRPTj.ta_=Q!
S-1;d8rVC\956,snn2CD(c]AFj[=Tf2OSm[!hF&5f+5b&E\PsuS;36'`;6,okR(VqO(oE!+/D
NZ2Ah#-!+?gc7I-Li=ZA`[Pc!mk*^n-5[hYc:W4jjC6b-+-9pm(@7<^7=VO2t-Q)3&`*@nX:
>eQqK:gh_Dp9AN:Y>]A;Vh]A:.[6IKobVN,2lcJ5oh&%>2>9U4#d]AP#C6r+@Bal.XF#,,JbPRe
^k@=Pa(=-*(N_bg5V`"n,835bMqQnIWM=nb-D-9$n=e]AK<(dX;t-Z$;U1;^$D<SSTp`/G``+
L$;>upa"cu\G_d`tZCD0jC50?;r(e>S?L/VY-/Zr]AhB#3[\k@E=U"^gF.VF#VQQk(QP*-Qq+
X`&`EKE*17q-g>?+n%3HMLC^Q<Y!=0:JuDQ8TqaX+:`"0=Gs^uPT3p_M8Sh34"6*<oeHd+r>
DPhK%i^r,jnJFXBT.(D)u@mR//)r[ifXL;XaqqLI(kpXhbTr[df(q6!CdL7pm(Kj12jiScTr
Z?8TgjN)2g]AfMNJf\AGJ7TQ\QTp3""pUgS&>0CbMnE%Dm:P16Rg.7H$sV1s03>'0c$G2AO4)
<K[?mQNV4%&jIZ+H=Vsdh?rKD^%l4L;H$OmE?$ddL@>+#2HVZBi+m1&1cLGTq!S_ljDLpZ*i
dX51m&kb'8ItMgaO3(f.btMtUDe@*^_r0.,Yc`>MD&06>"MU:bcN_opWTK099r+7XAT^p#*D
f8&9Q\nY%i#9uO[i#)'tO/f[>#%cuV%2l!u<@0IT*6fWuO(D,s)p/_b2lL^"b/@>]AFu4;3%$
/-m;Zu4khgT$%fU*1\cP7'r7mo&$lU3,u'n43"dYF*4*fOA\MN$n<I0V>'GAsDtQP%5h;)C-
g/a%Wg<OdQ+=na?;NXmeTUkO!n`t,XC0"THNDIup7\b!&@XI!]AOZt7H7%\;:iIFYlYZBik!r
i8Uh3/TJ+5o23m,Qc5?H*g"-K"]AO>K9jtXe=^3>(DgEq5tO+E@Ojg>&T-AS#THL*mhi1R;f[
T]A`_EQ]A%o;Ri-eMhq[,!(CI0!>*)U4#PgBs#KIOO"W!ORBQlsp<R@Lu0ciI\ND`m%/1&ClHg
:T4*r''b<YF#tQa\C?V]AZB0Ql:]AMlS`CE5:!.tC@^Kq<fC+8*7aG6dgj^gCM+kt,sK+^cYI?
W:SHT?u,LNXulBeoT<1'r!HEHlD*FL%7,$jX]Ace'Og2Sc6b/38nMlF3>AJo'GXcrs\~
]]></IM>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="250" height="150"/>
</Widget>
<body class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="report6"/>
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
<![CDATA[2880000,3168000,2880000,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O>
<![CDATA[节点平均时长]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="当前表单对象">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="cpcs"/>
<O>
<![CDATA[1]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report6"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="统计图">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="cpcs"/>
<O>
<![CDATA[1]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="chart0"/>
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
<![CDATA[$cpcs=1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="4">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320!n'e./B>R2,TeR%FqdKDGe,kh<6TW7Bd5!XJcO!1ok1gUO".:%Fu
0cnM(<8nq4joJUXikub/GG2'bshS)?^21S/rNSkl)?:Eo9J#Ace,8N!L;tQ8cr+NU-qEG/Xu
=3KL90fU9*`\MVYs##A;bQZZ%09`P~
]]></IM>
</Background>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="1" r="0" s="0">
<O>
<![CDATA[标准工期达标数量]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="当前表单对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="cpcs"/>
<O>
<![CDATA[2]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report6"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="统计图">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="cpcs"/>
<O>
<![CDATA[2]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="chart0"/>
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
<![CDATA[$cpcs=2]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="4">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320!n'e./B>R2,TeR%FqdKDGe,kh<6TW7Bd5!XJcO!1ok1gUO".:%Fu
0cnM(<8nq4joJUXikub/GG2'bshS)?^21S/rNSkl)?:Eo9J#Ace,8N!L;tQ8cr+NU-qEG/Xu
=3KL90fU9*`\MVYs##A;bQZZ%09`P~
]]></IM>
</Background>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="2" r="0" s="0">
<O>
<![CDATA[区域评估排名]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="当前表单对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="cpcs"/>
<O>
<![CDATA[3]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report6"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="CopyOf当前表单对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="cpcs"/>
<O>
<![CDATA[3]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="chart0"/>
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
<![CDATA[$cpcs=3]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="4">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320!n'e./B>R2,TeR%FqdKDGe,kh<6TW7Bd5!XJcO!1ok1gUO".:%Fu
0cnM(<8nq4joJUXikub/GG2'bshS)?^21S/rNSkl)?:Eo9J#Ace,8N!L;tQ8cr+NU-qEG/Xu
=3KL90fU9*`\MVYs##A;bQZZ%09`P~
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
<FRFont name="微软雅黑" style="0" size="72" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</body>
</InnerWidget>
<BoundsAttr x="27" y="153" width="346" height="22"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report11_c_c"/>
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
<WidgetName name="report11_c_c"/>
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
<![CDATA[914400,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[1028700,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O t="Image">
<IM>
<![CDATA[!@e-#reXHH7h#eD$31&+%7s)Y;?-[s$NL/,%L<7=!!)h'k*5oH!:`WK5u`*!D:6U"!`8s;n\
MYK.ucek0O73d(kR[E2MJLOnJMHGp';i<:5Q\OL@0s8>tA1aQU4&"rWbVqAt6i$iFBTCk$5p
3L?9.d@uSA_J.Yt.p9G)#0Y#Y`NcN%@*5hs1W$6oo2S7,#/V5AJit>5N,q`G6%7k3H':dtdA
*'5]AX9!T?nUVr\0uH'c]A/q(&/$/6@e%&MNqisg#3E,`CS"4e^"jQgs3/[LK.q6e5)IN9U0f$
o/a?#CM!7+d**/AddXCogO$0+nKWaHnNjg+Ub]A=Qk1^=#r_q-CJCRAPjg3n$1*+)(hFMNDr'
4E0Qc!!!!j78?7R6=>B~
]]></IM>
</O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="JavaScript脚本1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[window.parent.FS.tabPane.addItem({title:"操盘纪律",src:"${servletURL}?formlet=HX_RESIDENCE/HX_RES_TRADER.frm"})]]></Content>
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
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="250" height="150"/>
</Widget>
<body class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="report11"/>
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
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
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
</Background>
<Alpha alpha="1.0"/>
</Border>
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
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
<BoundsAttr x="486" y="126" width="18" height="19"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report11"/>
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
<WidgetName name="report11"/>
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
<![CDATA[990600,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[1181100,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O t="Image">
<IM>
<![CDATA[!@e-#reXHH7h#eD$31&+%7s)Y;?-[s$NL/,%L<7=!!)h'k*5oH!:`WK5u`*!D:6U"!`8s;n\
MYK.ucek0O73d(kR[E2MJLOnJMHGp';i<:5Q\OL@0s8>tA1aQU4&"rWbVqAt6i$iFBTCk$5p
3L?9.d@uSA_J.Yt.p9G)#0Y#Y`NcN%@*5hs1W$6oo2S7,#/V5AJit>5N,q`G6%7k3H':dtdA
*'5]AX9!T?nUVr\0uH'c]A/q(&/$/6@e%&MNqisg#3E,`CS"4e^"jQgs3/[LK.q6e5)IN9U0f$
o/a?#CM!7+d**/AddXCogO$0+nKWaHnNjg+Ub]A=Qk1^=#r_q-CJCRAPjg3n$1*+)(hFMNDr'
4E0Qc!!!!j78?7R6=>B~
]]></IM>
</O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="JavaScript脚本1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[window.parent.FS.tabPane.addItem({title:"盘点信息",src:"${servletURL}?formlet=HX_RESIDENCE/HX_RES_GROUD.frm"})]]></Content>
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
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="250" height="150"/>
</Widget>
<body class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="report11"/>
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
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
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
</Background>
<Alpha alpha="1.0"/>
</Border>
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
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
<BoundsAttr x="828" y="23" width="18" height="19"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report10"/>
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
<WidgetName name="report10"/>
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
<![CDATA[723900,1104480,979200,2160000,1104480,979200,2160000,1104900,979200,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[3600000,432000,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="0" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="1">
<O t="RichText">
<RichText>
<RichChar styleIndex="1">
<text>
<![CDATA[${=A11}]]></text>
</RichChar>
<RichChar styleIndex="1">
<text>
<![CDATA[个]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="1" r="1" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="2" s="2">
<O>
<![CDATA[今年开盘项目]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="2" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="3" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="4">
<O t="RichText">
<RichText>
<RichChar styleIndex="1">
<text>
<![CDATA[${=if(len(A12)=0,0,A12)}]]></text>
</RichChar>
<RichChar styleIndex="1">
<text>
<![CDATA[个]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="1" r="4" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="5" s="2">
<O>
<![CDATA[达标项目]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="5" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="6" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="7" s="3">
<O t="RichText">
<RichText>
<RichChar styleIndex="1">
<text>
<![CDATA[${=ROUND(A13*100,2)}]]></text>
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
<C c="1" r="7" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="8" s="2">
<O>
<![CDATA[达标率]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="8" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="9" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="10">
<O t="DSColumn">
<Attributes dsName="CPJLV" columnName="PRO_QTY"/>
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
<C c="0" r="11">
<O t="DSColumn">
<Attributes dsName="CPJLV" columnName="FIN_PRO_QTY"/>
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
<C c="0" r="12">
<O t="DSColumn">
<Attributes dsName="CPJLV" columnName="RATE"/>
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
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Right style="2" color="-16618622"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="152" foreground="-16712961"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72" foreground="-16712961"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<IM>
<![CDATA[m<a=f'6fn[rNZ$!>M-"6?58T=f6+Vee5WP<1s*,4l7$TAXZ]A=b8?*8#'aP^(5Y.bX>H(WD<X
W^_A9t;tZ*'l'2.D(J;5-r."Y68i))73Y,T/qc9TmNA>cdX&A\;)kD>1["^%*6RTD:UAkBYq
1kPb=G?2sZ\V2mbPo>nF]AiuVFuY:lso2su-8gpm7Js6rkG09*,-e&RF]Arqiu;T)6"PEjo&`2
0Irj6Q=A(>'o*tSU>bKMc3*:Qn@[\Fs_?oWHH%I#K:HJo?FW,LPkA_I/&T5VXM0C=4&ORH"@
N43WHt"I>^%CN6feGS\+$f=o@othk7h13]Am'H-\?4tVX5#E-CCd<(MPW2OQll`%[i$ISc4VB
B2kK/?\/cE3igsrS/]AQ>'ZBb`eZflG%gR0iolQjJ_go\%o085(/k:BdYEasd*!o_MW!A4[lQ
7@tNii^`+qk*+W%E41@5<`Gf"*[C^Ac0BcSA.IXn;0t#oNQAh>A5Xr(.98-3u=lmsN!Z3L8a
rGShI5Ukj%Yl-/IGAtYe@=oYWY3OA/+).E*5K;(;rLSh)/(M;/<>`q3_%jtph(R8<IIWg1HI
l8?4M)7,C0!oF)*\DD4(Au=fqK_9q$WFOsOk[L^YoGe[I=(^g(!r)cH)m9!>r5_sa^+(=52X
1I3Fm0t]A>?L?jLAFl`2^jX?ToO"ETDMrFFX%@f9r3m=BfuGpdXi:UE9ebPde8XR^`W6+Mb]A;
_o3'3<`H*=R16WkcZJI[(&j372sQG&Q7T]Aph7Ur#B#`%ejQbTcXr5d2eW-$<0:NjGJf/mXAZ
Q(08%+e;CD49cJi\glR\l-PN\'S,,Aj8Yd\Y,da%NVMofJG@rrVRCG[o3kF"sT2"m^'K"Wku
pp(BR9=aJ3>ok<CK-E(`mFkamKTo>C00!>PO.!"`oV=bu&EA=80E<dOErHK_8#Zr9s=KtYem
&E/B>3KXr^O,X2ZMi6B]A2u1";!H:Vj'LH3kMi;F1TPU=`l2ers%PnM.qH5be1=m+<-hQU0le
Q(Y-6@3[WfR3C?0A(EVq&TM,lcEg*(#GnquMk1AM6.Jle"\gGL1@S$%5<B\g9e=nDCXOP+kN
rZop@j4g0,X[MMfYh^q/qo,fR!87G"R)Yp)U'k1OZff@uREThEcXF=6cD!:80chUH>k2q2M(
pV'n_Nc%0eT$bdb&'9mWRjP73lqdNtHUlBqJb2]AgL`S[p1\Ur)h:d,='rq`Oc4ZEnlVR%SJ(
+o1bNf8uRn5A(O+&q,%9B5J[AlKO^+d*FS+ROsMYpG[IQOm\c)4l%5=59'Wt)9H$(,U6V="Z
1lU([f1<%C(KVjjZ\S/jlu=k(+gq7\Q\69gTr3#RZdu9$"WoDfthl0_K7j&(<Xbk)%53$m8b
U`6hqKc?;O_moSM!X:6]AD>1O1oU>F#L&<Ph]A3H!7>l*no'')k_95`%V@;7<\I9In0+84$@Xn
,^MVC(:jYG08)/tFtqT1*PK.W2F&X4C$)j`hm)te1I?sjjKp5i.=l>T]ArFI21VEVOoTF!>ci
Y(sE#u-\]A]A2u">Se)u-<d+M'=ccZ[JY*0V+3u)>8lHjbVhtn10eEo'?'uhD[Qq\W(DNH4@N2
:)T:Lu3JVSE+:[s:#)>/JmT[jaaa:#C_!&(&Aa`Ie*JO[4o94^C=s=Hh>(Ype4ot2EpEbe'-
s^j9lnc_=Zffu+"tO]AW1"9CdUCs_0/YP(1*sAVT&!bgSPNVX<!?J3*FlBV2/(F=(X$ol#[Mn
%@9<NTWfG>h_?'qLQ_]AcG9PX,_Ll(5D;E[?fYH`1"#igM;WHFsZ?qjlp:0_6!>0OVWBLKOdQ
g?dfeKp*S[GD6o=",+YF)\]A=:XH.qP8*I\K+bS2Da+;04?aQco,7lJ<r+=od)K+?NKh]Af-W+
gur6HUFe4ENWJ%of\E:.e6p")JF6)8,mW\DEX128Z2k-C`O2"jNH_D@G4tB6@"XOt8\5k"&.
?+6r.$'8f4XEZqOsG<8m4\FZfKrRU&H-9\,9JUHa+Ue)(5YUmC'7hum*i=)#B[K5cm,M&l<W
fU&JNK\nS8P$&R:4N%mL8o'I6/%G"hCRXgJPp+c0=G^6#&?sOZ%QqoU1YOJs8UqD?eh-ZRG$
U?aYqXITeFSX9u3mUVjOC#FhVXs#NF[$Auh[XJI/Y$m,PQ[RXck>,WMAN6KeV.!3_WpD@\/3
TO,sk)hN!?cb'q?\-->K.kqf7P6'W0/)shsFXG>D_<5uZq@,P,f^Zs.>ZZheh<5(=@!s""PA
5%S\7jNuM?@94'$*6YBth%P:6&:aU<Ad5Gg@1*!iepSA!f`WIpuM8/U55E7g7rp%:[0S6d'o
%BFn!@R,XA/AsB`\reYB0X<h'*DLjVaN0oGje5clsj]A^]AQha%"r8jbtV3fL+2B1dq=?OUbAJ
p>jeMh4-=cTS""!XXGWiSj0*MAp;]AFY:an+%X4n<Ud=%b[&1hs'Dm2b]AH`^fc,WJd7r;",nt
:S=H"2,.H=^ETdb+B3(GR+m/X=cO8!pjNs=+m(9=#LLBG_cTF8S@AV\"D`ZI'#0cm]A)FkrPW
nE-+t\ZGLBQZ59t_4c?0=>ptl6Q.Nb#IWq=-9Phf0P[3aVXnLBUBRseK'Q_q'n1dFe2'#D<b
*k"R>hFm:<VP(3OQb.690M9`VUlb5sN4dlZDAW\_Q@s)D=It8qX4.0\P'rErsdFl^qStX6*q
ijNKs!]A=LOEn:p`iEh'*,*[e<jfZ'qf10Z5tVOOThrp?`^*o=_c<FM0]A'3!mV8[g.l"V\UST
%9CE8!)FVY"h/pX@7U?iqGC6Pb1DD+,ZT2a(8CVHRS+FYtLbGX`VjJ.3pU=7=;(hZCZuMfMU
Os!+.UYS3STa1p[=F`@3bY8WUGc7*M3'_>:_rb_gKraKcq-B_B]ASo=nL?8;di>VS%)oPRbB"
_S]A5+mrje_h\oSVdTr8Y?.1D&5s$LS819VYGQ9'3'kDQp4@7'PJ\#I"B2->ZZA?><j@gqfEr
RrNh8><>deNNo#_U]A1LbTA*o\-b$,o]A(s;+Occ>QnEV_bWUUdErM#k6W>sQA)QPQoVK;5YkC
BmI%l=-jkEJ'#D2pn=FI@s"!aKb7rSoBJnudYLVSL6ED5CjXE<sb\Do[4Bhmgha@BLP4H6Vi
hF)Q9N_oCX]AVU#c]AJCiK58RB#"nb@X!BLt0$r.CqjSXLR:a?8gI84FrJ-A#TW[EjQR"/l6<&
M8RkSg+BdX%aN8,_9X@a_>F\G9?;cA^5mfV\]AnrtSqMq4t\rPq-:8\e"Bjd@5KJCB8O'AaA$
[LW1Up5=9$I@Y1-C5bHI91#F*R6:'f5[L+]A8!kbT#^BQWROs1DQo#Gk^iSn-Rk.D7T%+Ag@n
7Y=o)]Ag?R*j:J9FGD_dsY4Fbu![\-3jj$feHn>h0ZkH"=&Yp3(oMG1FP`hM>=\mBA(sihW5H
25's$F=nU!@hHFQdLD*5CWp9sZK=d8U8*V*d4j:4`7dVj5/b"\"1qJ,iZ,0nM7?4WAqU&Z?D
"2U/^R4Y!EJU\A>Z8^%.2rXg+?eQMRK#1]A,03-P\Z5rGHQ0i$ELn/@\W0cW3u_(gqliR/aJS
jH<2MP>cBIS2AdfZsOka*e$EZapCCg,QAZE6PcH*YPd<+A*YBHg$;dDV>aB17s?*3brW3[,%
.&V^AT4qIQ%W+`gKS_J0'G?Uh9ho7":<6Je/*DuO/[Ep]Af=?RWYUqXC<S&c>R@jRU<,Q+CKs
Y%Jbf$N=+g4t,^W#-D#=YT?99A90WapYQKiHgm<d:E;Z++1M/X1Q'OLS@;TSMA.S91DH9Zn6
l%Z;L-cC*kDV\E'IN*:]AKaGA"?H>GKb.tk.hd5!m<HH_\fFJRV9c>RJ;0Zc!NW1Haa&u3na?
<8-'nOERHhI8.W1t4:sV:!]AMV=&C2jKqs6Z4+fM#N_WcgBa;FJj"RG1;sc+;6YNH%K+o_`L:
]A6<L-=<<8nm;\teX!?bDrn'*R=D[a*i^(Z35+5gNCU*3FeCq\ss;LA7ajJbE0]A2ms,VXje_X
)\Dd@msJ/_LEG$RqVmOE.)CBHH[--AXWPXSXs[+AArb?^01:`eFR`Sk!<2Md^fEMuL:-P#h$
hO/ViHj\BF*TdrW7;!]Anf&cs5Vum4Y@Q/"K_RF4Xq[2,l%FTAs-9#?D$O=(-1%T[*Co#Z,@!
JOQEd+"K5gbOj>-,\rjBe1I]A26a$#Tm8fk%9A:Hf:ru4u6VE?R%3j+Ns(Q*^3B#I<9;t-$f]A
q-,Ymq;XnZcI>Vm4Vh3;-ZoWAaM$TeLb4RE9-:q>C#%f)bJY)Ybu9%Mbl28r)K$^fC#F3m,N
S:,56b10@@KocLQbMoXi;=g$)o+X9$WN[JVC;Ojuiui^Bn>jtEN2oh`5Ca'&o:HCC*^)iH/.
M%D=:(8t,*\%JI/"d,q$#ODW>:/FY`FQf;J0B9NG?E(Q`]AYI>kR+B8Ld',P*dQQ2\Lu?2^/L
`D"9)nT'cq5%DHAXjo$^uWlmrR]ATD<&ENaR&n;',crPQltLu=Aj2s<i]Al/cRY!dd6\\lcoVk
m_e$^fHoaLYKGkFCoLr&5(L97^Xi`;fSUuc!O+4#Nm=.N^*BRl61Y.3$JoHFM!IYT$2W*qGS
KKcoEnu%biD9QcF=1]A!n>fTV+i1Ep47suEVW-)f!$>*pk8UBLn$I$u'o\`&VVMX<fV\@9rb`
cmEmrn%DNLAC!tB>$Y[[@GbK]A>7&h:GWXsV4R'<%XFm6p.kZ,Tro:(4hX8m^gel/#A.qI/VK
h#hC<(pR/!#;-#&d4:"4;`^:BGVB-9V@K87oK'[#O:p\1j(1KlWm;Vb^^T[u=n^eBg;eA'<$
lp3C#FS.QA8>XfX#+r_-=X^O*<R\pIZZq]AUi-3Zf5lcJfe1#=H(fSUF`"o@#5"g,7-;:$2@4
fk=7g^AP;hOmcYItC&,(d=H-1'[Y!f8Jm6*^L>ObX@prZIfZ9L2Y4A(0<?7RbE$/-tmC2<+'
&l"a%Is=GYk,MPoYu1KU$uaMIk^i_7,GPW8^="HEgdmr;et/7@Hqffe>NSY>Gfh,74\=PQF<
"37+4[*"\]AiNVkHTcDjU\Q!L]AY97AUdm'ni&hc6H9!0m^d1W-oBu2<P%`UDWZ+1JRF1e^<`3
XS)qpD)X7%b5FUKB0GF$L8@q$AA's'3Tqb$GP3INa@nsKAr/-p[%J[GK_dp&&c`(P_VVKYEQ
G/8Yf`Hk0Q(BMrtW.sY]A,PJkmfK@Td;X8s(hoQS/]A?qcPi>^$k3fP/0)2c^TV:Q>=>IH5k#R
;Pqo#i4)keTVnD^JMjQ*6mhonGE&A$]A-ijWPlEfI@!Q"JC]A"5!@0.&+3g5n639VU'jGe*:c[
hC91+(?MYJZ;O]A<$\l?`/<Ml+u<Ws%dB?5#KCj?F[8)&]A\1'Br47AH0M7sYU';TVU*4Ri7B#
6aZe/a#8`]A9cVL&5JLoaQCBsh,IiB7jP_?ZIAbs:j1b1T"d[!p?@F\VkJ3!jBb3d"YQ,]A1_7
8_YFYpj8]AA:5;+;bL1e#S_Ib<GBmD$!h$9@R3DgdrkHbFG"W[-_f<SW'609R=k'e.`L5`K;J
*91+guis\GLV17t-\m,/p.<38E_Ae?YUmqpMb$Ie$Zhn(4t5#0M9@"_[a55bm-q:Yq';8+^j
aWp]A0':F:?0OioDTF:=^%]AP6`:V=UNa3i`bs`p4hC088h_nShd,F08rj&9>)c8KpjT2g2Y$A
jC"a1)M:<>%8^"l<Po!&6&0/-G,Qg@-Y.'+G1_YUKA]AYGEOYlFj)a?ff+7l_+D"(QmY9)4k;
01^g?C:L><'N.%27]ApL]AVaDM,9g2EU8b<fDMZlD2rWAEmXD%e47MFUZD$J__qpTTHO0C5qN,
/K3GC^kqV@69rVp3tC;:J$h^*/a]AR+Y':B_$:ue5-#8&%.nh?S5dq:-dmk[CDTdW%]A4nRp"F
eJU(Z^V_K`Z]Ah?3LHU>j24W=ngc)!L7:"HOWe&WS-7FZ4_X^_@.+@%hD2=jp\k64#N84K$"/
qa'!$q&We2q)%$lLN3ErXNK<kP?$!@L,bW"pY$M;XiLKj$2iQ,#S1+`'5]A^pIj24bu7Ff[b0
r!Q'e:cQ:(Zdsbah?OWds3nl2iJc1Pf_CBbK1B/l-<_l2!fGp;19?0@2&T#]AIk.&OuQtta<_
J]AN2:3h5<NPP5E7G';-t&na^*,t'L%r8gF[q&)K)AIs&^QL_l']A+g0@q7<k3f!SQIF#bahF:
MskhZC_s"BH-gQnaW#5p,A%-]AWZ$rj=)rLg?#c[00'b?aO/;9RmR&]A!$]A<r8&3)%R1Ood9aS
mQnKGidWcEg,J"C#"kEgmHXgN`\tG>6r*9)uNJgeqbQ;0IG,1<%pA:P<%*T_bhePIIOWYLCT
[Ue8Xce3ZWB8)m,d&*eEVUe0<W('fjEbITu>E$G#sAkC^u?T=[^fraqoY@=><<@_pF6$b`t7
e+Y7E<",?p+s='O)CFLG3Un[/,Sp@m9J46B\&=/hm#qZZ@F]A'9a4//4:Osb[+0NNKWi_4*>1
P;oRo(EK1+>t-J15ATs%)s//-q**4$N)/bf1%Gk0MC[Vp)\*=aV4%!=m2beB<`(=,Uk%1duH
E.K^l"#RM&Q`+!*qQeEj@:75p;\V)me;2e7^4L\_L:mZD\q0Z.fQ%j65Z2odQl2Re#4+d!5V
4A\Jp\bH@161NQ<(B[El':3/l7^K#MhsE?5>f0:9B$qSF.1FA;ahNHOs[Vi=)7G[nrYj_440
`WQc>CRJfd;$=DqGa/EJP,O4T:coDJpg-n\BKXXRA25n-#W!Xb1>?YidNM)0@LhbB>hJs3n"
Du>a7cZ**]A5C*eQ3m*Aeh+BLN((4Z<1YiI@9(n*<UF&MjBVVD<Xdbok("5J4oQO-Bk06BHD:
ZAAt>Oc^K0>nFI"SmM/[Yc?Y+&#cVAZ\pn/#QpOJ5Lc>nLREPE@Z8^'C^edZ4KeM?q5Gis$o
,S"t)k<'*n^JH`)r-?m_NG)OU9.%QgUZaV/IQjnMLZBqNH0LP!Lcq*__8M3l2=7koF>q"NnE
H?gD>V*fgLdEkUj<<!.R0$NlK3*6$@gtsP;Mr*hH9[q2UP*SQiSu]AogQ6dAiV5jliUsA,c]AE
1)XG=fLKBQ)o^-\u;Z*KtnQsD'=uV)9?,&#<gQ%:W<XjJlFgnm%Go9t\f6FZ@f5lmdpW@1>i
)VCW/r-3l^Jf.ar!MKMeA3TG`$9P/P@^=F0j*UE;>:m]As$Z8.1%n7mn?@Eo/#(`Q0Gs64]Ag@
Z;S#P_AcaBlb7lYo(bZRWM\<m&9:B]AiuBl2Ul`aT"=8%Zlik^/tJE::a#dXBX1Z/85[U/t7`
&@/]AES9tjW93OBiq'Q#u?o7'4U#o<Q4%p1$R;'B?be)5rh`g8,aq-`2Ep&gOPAVl#"/U5+U`
j8<GD81&g)h#*ekU0064`^)o\^W'Q%i%p+(bfslpo=$dkc$OagY-mo[5pbk$t9ng.V>.CQ51
SnV%e>8?ngX`>mneU+M*.&$CZChLL6Z;<)[<%lB&g/MNV2Q\]AU>e0sC?C&!__7>05)O#ZG5N
L"`Q<C!Ho@>$In4(UNPQ9QQF!jI*+;'e%!_SFes0&B"^T49o=RKtQ-r]AgM:-1&I6\9#Z@;u:
KfNDFJH%HVirU0o6[hua"fj3?2lgYCbFaVPGZW.N#(gnG.F,?06?pk3pgB;7>ei7D1r`[[d5
n,g:/!\S:%X\%\<K1CPj_t30Ep]Alm?GplH*jcAO<2]Ar`D4)nLXgfRoGepgU%3;6qd("Mb0On
B?>f>WE,,Rc[T$kDD,TR>Ap3UtPr`^1"(Cj?G'b$'1uYC7ON@9O:7D@mUnE#)A,ekp!I$sI5
[HE#idZIUC$n02W;h:V.V`/(H"U^do;2HC)Qr%f-[q$ukH[hWI6!M<:=q0D0d>U5\LnBTZ4*
&I?m\gD4qpo7hr8Aq,MYI$k<$T@:=OPYTT;:!o@DsYZIG<GL6PT,f*)/7sC^A"[=$cAn"'Rs
kfE>M+*<tBXfVZb/h3quh;$?[sf:,ZA:#M5@i>Z74V]A7_X]A*=?19EB8.9h[Bq4I"]A\^JlLj<
E'pa[5V]AStcWeLI!*CQ9aY@nVU#!(f,I;epeF4SDAb+VTin"SHf!LJ1fmaXmobFRc0r;4*N\
Yl2D>^9%oehr*Dkg+h\WPbja5/[%Q783#o=bkK\<T>Wkk*jb=B9EB!/A%n1A&1A,'Cs^)r,P
7$ZTs[pN<]Af=gKje=30O`ASp=%An\Z1VDUeA5Kfh>3Z#e-^\*#sh>0hrP-UVNAr[Z)0W"5J<
oLd\J<#W)+8l=S]Aj7%]A%ikEun$no:rog*49!c,ed@*)iYiqaZ24SK\0?naAN5b$s:=b$/<]Ar
[JM!\BjjE'!3NLZ7f*>$/,"kJn6>.to0=jMC?Ml[+p0=qe)LCk'pfK0#/Z?Np(&liUhhekI'
$TJ%:G5=Cs29a*P=V\_uo!m4s&$>K+"qkhc@"sSD`c@UaUbh-$^bU(@V.`hjE3<bT2@o!%QU
oe2!<kDp'OL^?7joJ8`37>Khh'3Z=aW,uHURiSqn[`c9#(%ef[l;i`<P8Oj9gbBa1u$cQ1og
EFYd90T820*%c!WY\XU-oL%M]A[`a6*;^<2Je86u:B&3'K,kF`m/GR=?0H_Bs,SFe.Neut@L\
D!QPqE7Y)%XJ)FrG_t<[qCZf(;l=4)U%4_ET6G7dBh`LF_O9>o-ji0f<V'TD)4&`S_^Q<nZT
-]AI(J[h@c"W9ca(MC^JOP"S%nu!~
]]></IM>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="250" height="150"/>
</Widget>
<body class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="report10"/>
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
<![CDATA[723900,1104900,1143000,723900,1104900,723900,723900,1104900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,1333500,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="0" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="1">
<O t="RichText">
<RichText>
<RichChar styleIndex="1">
<text>
<![CDATA[100个]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="1" r="1" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="2">
<O>
<![CDATA[今年摘牌项目]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="2" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="3" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="4">
<O t="RichText">
<RichText>
<RichChar styleIndex="1">
<text>
<![CDATA[36个]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="1" r="4" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="5">
<O>
<![CDATA[达标项目]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="5" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="6" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="7">
<O t="RichText">
<RichText>
<RichChar styleIndex="1">
<text>
<![CDATA[36%]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="1" r="7" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="8">
<O>
<![CDATA[达标率]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="8" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="9" s="0">
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
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Right style="2" color="-16618622"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="152"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</body>
</InnerWidget>
<BoundsAttr x="23" y="184" width="78" height="270"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report8_c_c_c"/>
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
<WidgetName name="report8_c_c_c"/>
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
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
<IM>
<![CDATA[!F,i(q2%pC7h#eD$31&+%7s)Y;?-[s6i[2e5R7Po!!&dGdA-aB"sZ]A-5u`*!m@.m-'h&hWYu
F-u=H"@`Lc(&CXIApCW'NTaPb=sPd&O''d8ipH)A=;$ZjApjI_]A%+<M;jVTLQ'%G6M?L(_u?
]A-pA7Th^QRr(bF!Zrp4G\SBfr]Ah4<B6\,,'M1qbt`cM[)oB$\[AeCW;2k^W;&nc\MQiW*^l/
1QH+LaS&P`1Ot[@NFtuEA=^obh/'!>0+Ou;";;YM!p27&3>XSU?qu7,5*Z;+d7]As`8>BM^C^
Y/&IT2@mDK(c6"0rns#/kRikdec)6=L4114?2Mhnp^Ht!De.:S5`M#HlmAA05?e\jhn1?)C/
s*!DGJ4(auCW.1]A$1U(HXeDB-ng:/ifHS'*;affYOe,(m.D$O2-.,EA9T0OTiNhO2&/^`]A+]A
DKP?,W\OhcL$.`t,9/)tG98C6mM#)9D<HAc9ouPE6)%Z2+l_N+`)qPp[`B+7.@2c,rl(),/,
VGnL0Zl,91=:rlABch29fUabAN[:^*fHX76a4LMoMIEp*4&59##8_(3d#cZF(oalo>;$a[:-
i#PQ4@L-C&`(%%>Ecut>6lY@7$jrrhH9<*d'!7j+_`$$#hbPHW=s/A6-)A5)`R9hPK(d4#f(
6UQTFY`*1eUgl'UqNOHGe>h#1k>+e[a9q*l.gF6+.!E\.E,_0"6-D%sC?)@+BV9tVWYIn6*%
7j5nd+,FIB;r2<&Mb?KrGu+(_Wa\/<SI3bW`GD8M,`"dLPA<:2ldXck3RhRm/"$qU2GACW4Y
G_)jjd&R'Z%W/h:Ej+#F+tYb>&<H)GPT/'#@;L3^XcKpgR9[>i&=ad40Pf'P*0f?T#m:,L)W
j(jN@BD>8]APVCFuX+D'Kc$%&)XkB@Ju&naWQkQSmmrHHoa-kbn]A;?CdFZ%XU0k-67f$ueFHK
7`V>(2XWWA_+$';IZbidQn:56V+8>JW=Q=,jh=CR$8bos*\=&KJTZ8ZsDrrM"1n_]ARu3^82^
tbitg$+8.$WG1*#0h5mWRq+u>_pTgiOK^K=mf3DO4ZgX9UL,eiqT$Q2/@a$^VnHd6CX#0I*>
\.J4g88bm24:6-<KAEN'%!*i7k>:7lV#.Eg:F&>RCSs9T9[>4%#RQ[bNT'n^U)b7Q7^:/0gf
Qn-2_FK/JP]A@M0cV!bgC8coaV^4<L4AIW(XA&N67.Tn$Up)69;>*dL/3GXIngt,Dm9:e,)gX
q"O&^D^gu_LLGAkl:d(n@k9:5+"-4XLYlN)QLeC("5tL3]A4!mb.5&g=YMBYIFpa.=%Jt2no.
b,kjeK@7$e#(l[:FKbBkbfS]AOH3O3m-CT@+9YoK\dS\%$5UF?Co'H>gK;+R<^N$P+Qf$6ifH
ZO(ulUWn2W8_=gFL8_P;RYNK?e%&iV-OJoqc1?Ant5D+Uf&$Ui3f[fY"YRmj)N'++b"eZl*N
:1/CgOiPu9[anH_!2bRdk1Brb8MmGf+J]AjOVbGO+6&ZS-4_l9qQNhehA4-u\]Aqt=b\*Ct9A.
TrG=fC)dR[a5lqWb9sniLX6jZj)((VU\:/ss=Q3Y:jGMn.5)88h=W(da7(+N(,2JWStEhGtR
=4966bn?%0$5R++XK,k53iGhL6"Q8F!pQd/B]AnV*]A@mG[P>ZS)%Q1_Q(7`Z(jTZ<1V@N8nii
aU8#nAVeQ)^1\>Js@bl!?5-JYrButi$6h1O#B<g'1,Gf=ib="gV]A'JkK,0r^eC*HLY(/aBbN
h1V^s)d:(UpAR[D>5NKstq+gQ38Q]A2PZ=N2dJ@K6["D0;BdgGBim=>fCV%3HVk6KF'c<ap<P
&3\*dBFM$m@j.&CJA(@mprlbE.c12]A!*EfJ/41R_L?1X;!kXduXG,khc8(n9!0>3i1(]A%E9"
\;;%*eckejB":>D`R=r<t(A<8L=d"lSYYEtU3-&!elQ8R>A4Y=V\:GaZG*Na2Z+PS8t?fZt1
%#SVh4&$F/*kqkXgk"93pZsj>M@^&E>]ADSmA(;G+Xc7)jV60/Wlksa"4BON?POT,A.:EXTR$
[CAW&J'jC2uipY!(fUS7'8jaJc~
]]></IM>
</Background>
<Alpha alpha="1.0"/>
</Border>
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
<IM>
<![CDATA[!F,i(q2%pC7h#eD$31&+%7s)Y;?-[s6i[2e5R7Po!!&dGdA-aB"sZ]A-5u`*!m@.m-'h&hWYu
F-u=H"@`Lc(&CXIApCW'NTaPb=sPd&O''d8ipH)A=;$ZjApjI_]A%+<M;jVTLQ'%G6M?L(_u?
]A-pA7Th^QRr(bF!Zrp4G\SBfr]Ah4<B6\,,'M1qbt`cM[)oB$\[AeCW;2k^W;&nc\MQiW*^l/
1QH+LaS&P`1Ot[@NFtuEA=^obh/'!>0+Ou;";;YM!p27&3>XSU?qu7,5*Z;+d7]As`8>BM^C^
Y/&IT2@mDK(c6"0rns#/kRikdec)6=L4114?2Mhnp^Ht!De.:S5`M#HlmAA05?e\jhn1?)C/
s*!DGJ4(auCW.1]A$1U(HXeDB-ng:/ifHS'*;affYOe,(m.D$O2-.,EA9T0OTiNhO2&/^`]A+]A
DKP?,W\OhcL$.`t,9/)tG98C6mM#)9D<HAc9ouPE6)%Z2+l_N+`)qPp[`B+7.@2c,rl(),/,
VGnL0Zl,91=:rlABch29fUabAN[:^*fHX76a4LMoMIEp*4&59##8_(3d#cZF(oalo>;$a[:-
i#PQ4@L-C&`(%%>Ecut>6lY@7$jrrhH9<*d'!7j+_`$$#hbPHW=s/A6-)A5)`R9hPK(d4#f(
6UQTFY`*1eUgl'UqNOHGe>h#1k>+e[a9q*l.gF6+.!E\.E,_0"6-D%sC?)@+BV9tVWYIn6*%
7j5nd+,FIB;r2<&Mb?KrGu+(_Wa\/<SI3bW`GD8M,`"dLPA<:2ldXck3RhRm/"$qU2GACW4Y
G_)jjd&R'Z%W/h:Ej+#F+tYb>&<H)GPT/'#@;L3^XcKpgR9[>i&=ad40Pf'P*0f?T#m:,L)W
j(jN@BD>8]APVCFuX+D'Kc$%&)XkB@Ju&naWQkQSmmrHHoa-kbn]A;?CdFZ%XU0k-67f$ueFHK
7`V>(2XWWA_+$';IZbidQn:56V+8>JW=Q=,jh=CR$8bos*\=&KJTZ8ZsDrrM"1n_]ARu3^82^
tbitg$+8.$WG1*#0h5mWRq+u>_pTgiOK^K=mf3DO4ZgX9UL,eiqT$Q2/@a$^VnHd6CX#0I*>
\.J4g88bm24:6-<KAEN'%!*i7k>:7lV#.Eg:F&>RCSs9T9[>4%#RQ[bNT'n^U)b7Q7^:/0gf
Qn-2_FK/JP]A@M0cV!bgC8coaV^4<L4AIW(XA&N67.Tn$Up)69;>*dL/3GXIngt,Dm9:e,)gX
q"O&^D^gu_LLGAkl:d(n@k9:5+"-4XLYlN)QLeC("5tL3]A4!mb.5&g=YMBYIFpa.=%Jt2no.
b,kjeK@7$e#(l[:FKbBkbfS]AOH3O3m-CT@+9YoK\dS\%$5UF?Co'H>gK;+R<^N$P+Qf$6ifH
ZO(ulUWn2W8_=gFL8_P;RYNK?e%&iV-OJoqc1?Ant5D+Uf&$Ui3f[fY"YRmj)N'++b"eZl*N
:1/CgOiPu9[anH_!2bRdk1Brb8MmGf+J]AjOVbGO+6&ZS-4_l9qQNhehA4-u\]Aqt=b\*Ct9A.
TrG=fC)dR[a5lqWb9sniLX6jZj)((VU\:/ss=Q3Y:jGMn.5)88h=W(da7(+N(,2JWStEhGtR
=4966bn?%0$5R++XK,k53iGhL6"Q8F!pQd/B]AnV*]A@mG[P>ZS)%Q1_Q(7`Z(jTZ<1V@N8nii
aU8#nAVeQ)^1\>Js@bl!?5-JYrButi$6h1O#B<g'1,Gf=ib="gV]A'JkK,0r^eC*HLY(/aBbN
h1V^s)d:(UpAR[D>5NKstq+gQ38Q]A2PZ=N2dJ@K6["D0;BdgGBim=>fCV%3HVk6KF'c<ap<P
&3\*dBFM$m@j.&CJA(@mprlbE.c12]A!*EfJ/41R_L?1X;!kXduXG,khc8(n9!0>3i1(]A%E9"
\;;%*eckejB":>D`R=r<t(A<8L=d"lSYYEtU3-&!elQ8R>A4Y=V\:GaZG*Na2Z+PS8t?fZt1
%#SVh4&$F/*kqkXgk"93pZsj>M@^&E>]ADSmA(;G+Xc7)jV60/Wlksa"4BON?POT,A.:EXTR$
[CAW&J'jC2uipY!(fUS7'8jaJc~
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
<C c="0" r="0">
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
<WidgetName name="report8"/>
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
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
<IM>
<![CDATA[!SRc)pk_gB7h#eD$31&+%7s)Y;?-[s6i[2e5R7Po!!&dGdA-aB#GF^W5u`*!jdUV$<DsmX;k
]A?qH:YeE2;XK6P;,Ta.EWl\,_Jp"0mQHe'&eSl"-n^7*[ToF*\$."Me4XmY@8tn>bqZ?]Ad-5
%pY0U,ZgKkin$DaPkMCR2l&X.ah6Zk0lh=\#s42,eeo+V?.k@Zd%C.IFrBP.;5.D>d#-WS<i
+l-rrW&G(%Klb0]AD:hEn.Bm[N!0*p\Y*NT1LoJ!PEcuF+AKYji!Jm%fF#bNLb3!X(^7L'6h3
PT1jBW]A!D=ohpaGJ0T7_L,$'ctG)JKN_Ja]AU@KJ<0np5^tM&ds;\Ns3j\SI%>Js0)RK"]AN6^
0\hV#Its`U&b%WE#3LQ'$(q*mH.J*<'*L6O#8=rALn4;^]AEE*WS\a9Q7O]AO'dWDF#JH86m'b
U?8%sU^rcQs7CFJ,gJG)dNXMkI!:JX&JVE!;UQ\jD,DFVEsZ>7b&l&A/h-n4kc+B7h+&+@6Y
:KCcm#1Fn(Rrs#D@8J';DD.Pt"N"[8l9Sa78<&KG^&R\gn/PABf:dK=,pr.;1QaLh+;2i:A?
f3Fl0gLsF_4b1$n3\eTjiY8N2<YSp0["[OJ6tJ5I0OH_";qk,XdVb=<""7Xi!5=6-057A?-Z
\&oJ:.r@9G3>>'X`&G0n_SjC+*a>pBPiKudgHHO&8VI-LR=,Xqo@W49%V!aCcRcAs4D!C<;s
CgLlbi_H+3qg]Ag,*LjOlK"+Qfi]A\L+l]A04?D*d$$IcUL(<Y5^;?ddcK1g?&W-2k4h?GqGSo@
Vg8(?>J"b.6G;E(LWKdb>uN;\mp>8G,<qKacP8.3_(SR=TMd^/J5!DN#P%&VVo;<j.#WBdB-
qo@Z%O[`:7c8YO6,2m*6ALp[gE!(#fUGQb<,^o$Yi!;f6U$(m=\%?OK8oO.V[(5+JQT_MG'.
IQ4!a=)ij%-.:\+V"Ds3Xm_D[IZWdB#'eRS,rU!l1]AMN/TkE26&[3cY"T@?g_T($E&TbaOp!
fOZkq!8ccI:rMTKK(r817#5qHG>#G4D/?j^N0^BH9Cqn_BkNL&M<(e-;q`T,<$^m1XL@]AtTZ
$+[**(_j'BmhprbZ%Qh0VIZ4B"O3mQi$Zo'SIL"s3ce"Rce'Q?8tR(MH<,VWYL8u9#L_:I\g
$o9eEKIa'!Z8QDF^]A?7%J#/"QJo.\-:*Bbi^/b_$9D;kS]AOO&]A'&$bAGFl@(@j[Wc>`[9Y,D
-+c&j8dDKS9.q?Bsn66B^kGuP]AcnWP%j$[CT,Yjc*Is\9*\(QAC,<IfW+@4KXa+JFu06!DZK
,eH]Aj"]ARRo5DW6&"%.r8@sbN/([C,GS$&YRnITag_GL&Xa1H\aYt'QDK'E`AIC7Yd\l9Q74c
MfO1j0"Ji"#jDmD$(.7(Qi'VpAW#BBB1[EC/6U+:rDK=<KX6!-aa`FEPaZoCJ'>JK:1Qm_h`
AF]AM\4>8Mtgp"(Da&`j,,qq"d>n,qADB^X-408Jd3E+APSPm*&%LA%nN@;+8)Bc+#l($pgE4
3*+F)HdS/.nut.<H@8YZM,C<^t%HP'\IMI]AEf`TN38J7geN?pGdebB^tdOU)Tl(+cWC%-CTB
oStUTZ$Gb2S\R5V`;<lCAK+mW1@L6L3W<mGVh47"AY8Ig'(G309,$N4F-;1%7imeh:&C#^/]A
%L09&-OL$XqmT(jk>_HLa<In5(/Eq8bO<<]A.nt#dLSc*AP>?`1<_G%@nHD=d0cKd=Zha*R6I
@-WE8H)JiLqp8(#JsT_bdjKQV7[MWSe3DZ%/!Li0$B,S5_M/lqqUa>V8)<A^4;g`Wn=.S`Hn
YL"_+(mo"FP%pA^G:ZR+)ab;Y(@<h^81-?'K%'bQ^iTWVJrbiPE14`W^kT8!l`G?RD?&Fk5;
JoT5+7j9@-?t[O,?\Her%`ec'd52LX;A]A0\:@*H)^"bf-nN-U,'QiH&XD3q_c8M3><_\Tl4p
XnThPc_^'YFFt7#fY4C4,^_VS,qJMUgECX3/D\37qPb]AD:Z(A^M\RcS,Gg)p$b61uaOW[/PY
"5^d6djs*dGST@k@,c6\eK]A<h*!QHHjjb7"#J>9e#+=6?9EqSH!k;4kROHofYi2A'AFScLf9
OL!=^aTAu<40!=7+G1ft,H!F4WAi>'9JH*HMk9i,f9bP]AY"(ah)?BG`aN"3>jb=R(J[)soeM
O!KN-9Q(4jM'1#>Eqe8-N(RZ>E.mGk(]Auq1ZHsELp9a:L-&</0Z03?/fG@.<V4p%RQ:>+%RR
!m@"2jrBe1m]An&*?AB6WZeE'42\"J2M<#N@fr49PYkHVGZifgN9%EehT(361ffm'#S*%@-[b
fMXI?SRX<UVZAJb0hRu*+8Ee!D=Mcap_qjjW"<FQpQk7#(e/*kb]AW;9V`8R+75AFMlE!14cS
c!kSLT""*r$pi.&80[u-[M0)U3^_'F*['>_I2m9d6/>]A%':I=KZXqG#JZ5a"Khh;MY[K/M(H
2Ff"TWN\(S":r/D"m:A\1g!?qCK=0[d[TA&IEQ--W[`Q!B]Aq"<)aju\n0!!!!j78?7R6=>B
~
]]></IM>
</Background>
<Alpha alpha="1.0"/>
</Border>
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
<IM>
<![CDATA[!SRc)pk_gB7h#eD$31&+%7s)Y;?-[s6i[2e5R7Po!!&dGdA-aB#GF^W5u`*!jdUV$<DsmX;k
]A?qH:YeE2;XK6P;,Ta.EWl\,_Jp"0mQHe'&eSl"-n^7*[ToF*\$."Me4XmY@8tn>bqZ?]Ad-5
%pY0U,ZgKkin$DaPkMCR2l&X.ah6Zk0lh=\#s42,eeo+V?.k@Zd%C.IFrBP.;5.D>d#-WS<i
+l-rrW&G(%Klb0]AD:hEn.Bm[N!0*p\Y*NT1LoJ!PEcuF+AKYji!Jm%fF#bNLb3!X(^7L'6h3
PT1jBW]A!D=ohpaGJ0T7_L,$'ctG)JKN_Ja]AU@KJ<0np5^tM&ds;\Ns3j\SI%>Js0)RK"]AN6^
0\hV#Its`U&b%WE#3LQ'$(q*mH.J*<'*L6O#8=rALn4;^]AEE*WS\a9Q7O]AO'dWDF#JH86m'b
U?8%sU^rcQs7CFJ,gJG)dNXMkI!:JX&JVE!;UQ\jD,DFVEsZ>7b&l&A/h-n4kc+B7h+&+@6Y
:KCcm#1Fn(Rrs#D@8J';DD.Pt"N"[8l9Sa78<&KG^&R\gn/PABf:dK=,pr.;1QaLh+;2i:A?
f3Fl0gLsF_4b1$n3\eTjiY8N2<YSp0["[OJ6tJ5I0OH_";qk,XdVb=<""7Xi!5=6-057A?-Z
\&oJ:.r@9G3>>'X`&G0n_SjC+*a>pBPiKudgHHO&8VI-LR=,Xqo@W49%V!aCcRcAs4D!C<;s
CgLlbi_H+3qg]Ag,*LjOlK"+Qfi]A\L+l]A04?D*d$$IcUL(<Y5^;?ddcK1g?&W-2k4h?GqGSo@
Vg8(?>J"b.6G;E(LWKdb>uN;\mp>8G,<qKacP8.3_(SR=TMd^/J5!DN#P%&VVo;<j.#WBdB-
qo@Z%O[`:7c8YO6,2m*6ALp[gE!(#fUGQb<,^o$Yi!;f6U$(m=\%?OK8oO.V[(5+JQT_MG'.
IQ4!a=)ij%-.:\+V"Ds3Xm_D[IZWdB#'eRS,rU!l1]AMN/TkE26&[3cY"T@?g_T($E&TbaOp!
fOZkq!8ccI:rMTKK(r817#5qHG>#G4D/?j^N0^BH9Cqn_BkNL&M<(e-;q`T,<$^m1XL@]AtTZ
$+[**(_j'BmhprbZ%Qh0VIZ4B"O3mQi$Zo'SIL"s3ce"Rce'Q?8tR(MH<,VWYL8u9#L_:I\g
$o9eEKIa'!Z8QDF^]A?7%J#/"QJo.\-:*Bbi^/b_$9D;kS]AOO&]A'&$bAGFl@(@j[Wc>`[9Y,D
-+c&j8dDKS9.q?Bsn66B^kGuP]AcnWP%j$[CT,Yjc*Is\9*\(QAC,<IfW+@4KXa+JFu06!DZK
,eH]Aj"]ARRo5DW6&"%.r8@sbN/([C,GS$&YRnITag_GL&Xa1H\aYt'QDK'E`AIC7Yd\l9Q74c
MfO1j0"Ji"#jDmD$(.7(Qi'VpAW#BBB1[EC/6U+:rDK=<KX6!-aa`FEPaZoCJ'>JK:1Qm_h`
AF]AM\4>8Mtgp"(Da&`j,,qq"d>n,qADB^X-408Jd3E+APSPm*&%LA%nN@;+8)Bc+#l($pgE4
3*+F)HdS/.nut.<H@8YZM,C<^t%HP'\IMI]AEf`TN38J7geN?pGdebB^tdOU)Tl(+cWC%-CTB
oStUTZ$Gb2S\R5V`;<lCAK+mW1@L6L3W<mGVh47"AY8Ig'(G309,$N4F-;1%7imeh:&C#^/]A
%L09&-OL$XqmT(jk>_HLa<In5(/Eq8bO<<]A.nt#dLSc*AP>?`1<_G%@nHD=d0cKd=Zha*R6I
@-WE8H)JiLqp8(#JsT_bdjKQV7[MWSe3DZ%/!Li0$B,S5_M/lqqUa>V8)<A^4;g`Wn=.S`Hn
YL"_+(mo"FP%pA^G:ZR+)ab;Y(@<h^81-?'K%'bQ^iTWVJrbiPE14`W^kT8!l`G?RD?&Fk5;
JoT5+7j9@-?t[O,?\Her%`ec'd52LX;A]A0\:@*H)^"bf-nN-U,'QiH&XD3q_c8M3><_\Tl4p
XnThPc_^'YFFt7#fY4C4,^_VS,qJMUgECX3/D\37qPb]AD:Z(A^M\RcS,Gg)p$b61uaOW[/PY
"5^d6djs*dGST@k@,c6\eK]A<h*!QHHjjb7"#J>9e#+=6?9EqSH!k;4kROHofYi2A'AFScLf9
OL!=^aTAu<40!=7+G1ft,H!F4WAi>'9JH*HMk9i,f9bP]AY"(ah)?BG`aN"3>jb=R(J[)soeM
O!KN-9Q(4jM'1#>Eqe8-N(RZ>E.mGk(]Auq1ZHsELp9a:L-&</0Z03?/fG@.<V4p%RQ:>+%RR
!m@"2jrBe1m]An&*?AB6WZeE'42\"J2M<#N@fr49PYkHVGZifgN9%EehT(361ffm'#S*%@-[b
fMXI?SRX<UVZAJb0hRu*+8Ee!D=Mcap_qjjW"<FQpQk7#(e/*kb]AW;9V`8R+75AFMlE!14cS
c!kSLT""*r$pi.&80[u-[M0)U3^_'F*['>_I2m9d6/>]A%':I=KZXqG#JZ5a"Khh;MY[K/M(H
2Ff"TWN\(S":r/D"m:A\1g!?qCK=0[d[TA&IEQ--W[`Q!B]Aq"<)aju\n0!!!!j78?7R6=>B
~
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
<BoundsAttr x="653" y="58" width="27" height="27"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report8_c_c"/>
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
<WidgetName name="report8_c_c"/>
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
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
<IM>
<![CDATA[!F#l+p5)U@7h#eD$31&+%7s)Y;?-[s6i[2e5R7Po!!&dGdA-aB#pMr/5u`*!m9=k?f2EB5.b
Z2rifLNAkU@fMV8X(r7[&tSnnc"$1mVsCLMWY56pgK7,>4>WW(]AQhaIYPioOJbmP)Ah#:\S,
_G.ZZ#pO;T"qlBIG5<e[fhrUBs]Aq9Z>\`]AK0?U8s_GsM^LFnm);ElNrpJuT0i?U85h+@:s/"
PHe3ON!1,rs>YSKWoDWBjdJK6EXr0s0!!^>6rkKY3SZSHPdi,`g@Ck\E9MAM@^33^6Ouqj1^
@T#l0aM,E3nCKMbca$/rYL(f)isjGAuL@Pq/?OAU&3K!AN$#hb\5)%psRj3)f_;C:#2d#8:1
c<.r.K2Ej<6H7)*1*Zo2K4EY)7^(U_Xn%&>N7o-\Ei,OW7&;0I,,ZbtMp^ahF(hMlc&BR%pN
))W7<7jA`e6rO#R_`m(rU)3f*dR-(QpQFSr>H\+QmT/p\TM&c=L5u6O4ZT.K5&71/]A%c2e*n
=J69p0`]A8u8o)+g_#^OK6A9OUUFEXp/4]AL.;Y<.X@NhM,JTl'bJB8lMZ*1qM+;2RhYZt1e"b
[C'QF>`^`@N<:1ORXs`a?W(.j@fiLkmFK_/t<qI80^dJ*6*BGMaEU&m,1,qY_46=Wg*l66:u
IA\em3bP4BnB-N9U5lOV#(f"LN_?pY-E6$,fCN"@-9&`e@>&VmHO&&U0&"d/nV)FLmO,q8JS
KQJni@%,]AhR1L.HJFO:%a#)9OcJZD1@8(:7A8KJ@Pd)EN'=!Bn*9(`S"k%+U//DIdNZ_oTLo
[P2&osM=oH#.Y,OrHes5O)'&EoZTb*b.tS4.2'?,\dod?KkO`LsRHcu3.GJbiM%E<mabgOF%
5m724q5_E8Zo#N`o:kd$cApe#Ln)gUULCh*KUTmo=jB%58_1I]A%r`kuYeIDXSXH=)i9*ic97
mkU7`^aJ]AVIRSeWop?[#EFUuY%$01f*E@o1,d5HbZkDSZ^3IsF-,oQWG"3>InWEV4)L(&RjG
[Grk<"#+!!CROCt4S30;NabRN_/.\f/%!NEVU"(TXW6BE&<6(SBb9Tp1e3dVG9-\F_l).G#j
QIO^0*62=!LfE0&T@ZY+#,Vgk3g)rl:'>+3_S>.jC+g`5oV<<ZOFiG6`Mka1-"c'<$i.g=:e
3>G$\O)O$<=sqS^\>TiJ9$<,F.c70m6?lH\dc`I0N#nVatR=_1W(Co/t699E67/`>Z+D:DgE
/9p6lhIe)"aZk.U4WE`""@P(,&i=F+>5*--qc(qUAA3<??U&-$,f4Kg;1tHlc+U;es6@P]A,@
YP9NJdE#e0[C=j4jNh*9Fu[6"A0J%g?<-OM$nr7kSn!QC>F("e0ub3/99k[6:nD4Q0UdB&Z_
^[Blp'0Bd\itk2t_lFoW[(fHm%66m+2l9c=V;53!aedr@FDDUsJ'RO:FP&lMI^<#uY9BMs*`
;?OUL10KFeO4;Z4cB=:;4;1VYKD]AQ',3Dfm#lo=uAr1OoQ@s@SD>/3('-Z'R1j%]A&Q$'he1I
?bZHiZ\'kAu_T+;n8:e%VVP<?WUqT[N6X3,(.*mJc1!&>\K9ObsDVP'8`Z./*`VQ>>mg;@Xh
W$21Y9nL:I$F_e6CQk3.g+1sIg2jg4.S.M4(.N^r>_p!7NYu,%u9;A3PDGlrtaI_@cZ8rerS
a*ua]AEfYqINLnV(9.$qb\VH8!<1ms;E;h+N)N8MS_aeL-)AV?&5p?kV50D*]ADS93+GB`O<+-
(n&@,M>jKQ1SW3d)7RRUNWNK2d^C,s8!_OI@,D57]ApU+@OsI2Nj>V'9GQSiXTO<0[ep(Den(
1YRqjJ%-DV\jp,IGfBf*=6DE6(cZT*U=alFWLV+rA8Y.0LoXpR(4Ss>&If3prsJT$U^BKAp"
p=U*s<^^7ti#57VCRKge]AfWoiCjZ)s)92j#c`PXaLK^+TS;/(1SPfrRWlk15*tmc:^=7o+J#
Y,B0e3Uo&rs#638jcjL4c9bjQ;:f]AhIW"qDIOTco,>!5MnVlj_@!q]A+8?fYMc%MMrmAs->t+
br>M-gMdTU:kZ0QY1UT=P#j9B2&ZSE&dP&G7$&30O$*'X$"+K.>*M'A!+a0"$;L_G3$c*n">
2bBn[:!qiF-3DS%^3EJ48JBH6_K&9"ocN)W[B]A:Jk#/bksMW+'*=:A6f)-)"%g7XXZ"H0646
rbAJ&61'%+0io7ZPefb'#DVY+SMOP4kq`dRe@.<r>EJDMp3U.Nn(HUJhj\1?]A?eiT!`WGI6K
SZ>W"IMb%,EYLLaSqf#90$s""bOAW8]AXs9h)/h14W9_h=9(&6'eZO+%!1V?8F:%JS1T?klSG
1[/IEY,%HtG`HGeh(c#8tE^QtlY_Z#>cD"E-69m"#)GV#geCQ0r3BD:W`;AahdP7cdQ:tr33
t&07i4KFR,D9$1mcB7"6ieHW"%Qj>M305^+9U*Bp/QH$hAbM%NJ+TD:5"]A9E$dV>0FeqZo--
408&iaU14VG+hf?E^3oV*>";=,e]AZ'H+<`)?6bN.:m\^)`#kQ?#+eiH8`lM[YKK-O;,67NmA
VO9@"5uu\fU2d*Ma<;knl!YU-*O8=IhN'^<Z-f$P;BbN7.>\&/MF;;s_F_aA\S3*q</VU`-Y
$]A`71DL++f&-MA>!qqV[K`'\.*@EYHFg+"4a`41%H517**]A1Ob'@4GK@E<9*hNGH#j(h!i(3
B9S3n:gF%5^6oeTnF!B[`:6;f+nutG$'hJ\1<-i*U)/sJA',iY]A5mJC/:J%c&78LI6$*r\*9
oq(XG*Sb<6XX7DeF&LH&GV51V``2P3p]AQh'1q@cRMu>g0JP7+<Sm=Aatsui$&uakR<21Ff&=
6?m7R:57X3!!"5d;(pPMp=WDA-.6O#6p6e@$`A2I*/;rjpU^mblY"WKSV'TO[6idOkBAHG%E
WB,csTPsYR'nYV@&;(hta!E4g.,&-/$3a^7Uq4_?3+2"Ea`m/Id>:qJ.No:RE'gdgE?0hN1A
XR%bd.C2s8$egY#PF9Dti]AB]AD,9tF5N7,z8OZBBY!QNJ~
]]></IM>
</Background>
<Alpha alpha="1.0"/>
</Border>
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
<IM>
<![CDATA[!F#l+p5)U@7h#eD$31&+%7s)Y;?-[s6i[2e5R7Po!!&dGdA-aB#pMr/5u`*!m9=k?f2EB5.b
Z2rifLNAkU@fMV8X(r7[&tSnnc"$1mVsCLMWY56pgK7,>4>WW(]AQhaIYPioOJbmP)Ah#:\S,
_G.ZZ#pO;T"qlBIG5<e[fhrUBs]Aq9Z>\`]AK0?U8s_GsM^LFnm);ElNrpJuT0i?U85h+@:s/"
PHe3ON!1,rs>YSKWoDWBjdJK6EXr0s0!!^>6rkKY3SZSHPdi,`g@Ck\E9MAM@^33^6Ouqj1^
@T#l0aM,E3nCKMbca$/rYL(f)isjGAuL@Pq/?OAU&3K!AN$#hb\5)%psRj3)f_;C:#2d#8:1
c<.r.K2Ej<6H7)*1*Zo2K4EY)7^(U_Xn%&>N7o-\Ei,OW7&;0I,,ZbtMp^ahF(hMlc&BR%pN
))W7<7jA`e6rO#R_`m(rU)3f*dR-(QpQFSr>H\+QmT/p\TM&c=L5u6O4ZT.K5&71/]A%c2e*n
=J69p0`]A8u8o)+g_#^OK6A9OUUFEXp/4]AL.;Y<.X@NhM,JTl'bJB8lMZ*1qM+;2RhYZt1e"b
[C'QF>`^`@N<:1ORXs`a?W(.j@fiLkmFK_/t<qI80^dJ*6*BGMaEU&m,1,qY_46=Wg*l66:u
IA\em3bP4BnB-N9U5lOV#(f"LN_?pY-E6$,fCN"@-9&`e@>&VmHO&&U0&"d/nV)FLmO,q8JS
KQJni@%,]AhR1L.HJFO:%a#)9OcJZD1@8(:7A8KJ@Pd)EN'=!Bn*9(`S"k%+U//DIdNZ_oTLo
[P2&osM=oH#.Y,OrHes5O)'&EoZTb*b.tS4.2'?,\dod?KkO`LsRHcu3.GJbiM%E<mabgOF%
5m724q5_E8Zo#N`o:kd$cApe#Ln)gUULCh*KUTmo=jB%58_1I]A%r`kuYeIDXSXH=)i9*ic97
mkU7`^aJ]AVIRSeWop?[#EFUuY%$01f*E@o1,d5HbZkDSZ^3IsF-,oQWG"3>InWEV4)L(&RjG
[Grk<"#+!!CROCt4S30;NabRN_/.\f/%!NEVU"(TXW6BE&<6(SBb9Tp1e3dVG9-\F_l).G#j
QIO^0*62=!LfE0&T@ZY+#,Vgk3g)rl:'>+3_S>.jC+g`5oV<<ZOFiG6`Mka1-"c'<$i.g=:e
3>G$\O)O$<=sqS^\>TiJ9$<,F.c70m6?lH\dc`I0N#nVatR=_1W(Co/t699E67/`>Z+D:DgE
/9p6lhIe)"aZk.U4WE`""@P(,&i=F+>5*--qc(qUAA3<??U&-$,f4Kg;1tHlc+U;es6@P]A,@
YP9NJdE#e0[C=j4jNh*9Fu[6"A0J%g?<-OM$nr7kSn!QC>F("e0ub3/99k[6:nD4Q0UdB&Z_
^[Blp'0Bd\itk2t_lFoW[(fHm%66m+2l9c=V;53!aedr@FDDUsJ'RO:FP&lMI^<#uY9BMs*`
;?OUL10KFeO4;Z4cB=:;4;1VYKD]AQ',3Dfm#lo=uAr1OoQ@s@SD>/3('-Z'R1j%]A&Q$'he1I
?bZHiZ\'kAu_T+;n8:e%VVP<?WUqT[N6X3,(.*mJc1!&>\K9ObsDVP'8`Z./*`VQ>>mg;@Xh
W$21Y9nL:I$F_e6CQk3.g+1sIg2jg4.S.M4(.N^r>_p!7NYu,%u9;A3PDGlrtaI_@cZ8rerS
a*ua]AEfYqINLnV(9.$qb\VH8!<1ms;E;h+N)N8MS_aeL-)AV?&5p?kV50D*]ADS93+GB`O<+-
(n&@,M>jKQ1SW3d)7RRUNWNK2d^C,s8!_OI@,D57]ApU+@OsI2Nj>V'9GQSiXTO<0[ep(Den(
1YRqjJ%-DV\jp,IGfBf*=6DE6(cZT*U=alFWLV+rA8Y.0LoXpR(4Ss>&If3prsJT$U^BKAp"
p=U*s<^^7ti#57VCRKge]AfWoiCjZ)s)92j#c`PXaLK^+TS;/(1SPfrRWlk15*tmc:^=7o+J#
Y,B0e3Uo&rs#638jcjL4c9bjQ;:f]AhIW"qDIOTco,>!5MnVlj_@!q]A+8?fYMc%MMrmAs->t+
br>M-gMdTU:kZ0QY1UT=P#j9B2&ZSE&dP&G7$&30O$*'X$"+K.>*M'A!+a0"$;L_G3$c*n">
2bBn[:!qiF-3DS%^3EJ48JBH6_K&9"ocN)W[B]A:Jk#/bksMW+'*=:A6f)-)"%g7XXZ"H0646
rbAJ&61'%+0io7ZPefb'#DVY+SMOP4kq`dRe@.<r>EJDMp3U.Nn(HUJhj\1?]A?eiT!`WGI6K
SZ>W"IMb%,EYLLaSqf#90$s""bOAW8]AXs9h)/h14W9_h=9(&6'eZO+%!1V?8F:%JS1T?klSG
1[/IEY,%HtG`HGeh(c#8tE^QtlY_Z#>cD"E-69m"#)GV#geCQ0r3BD:W`;AahdP7cdQ:tr33
t&07i4KFR,D9$1mcB7"6ieHW"%Qj>M305^+9U*Bp/QH$hAbM%NJ+TD:5"]A9E$dV>0FeqZo--
408&iaU14VG+hf?E^3oV*>";=,e]AZ'H+<`)?6bN.:m\^)`#kQ?#+eiH8`lM[YKK-O;,67NmA
VO9@"5uu\fU2d*Ma<;knl!YU-*O8=IhN'^<Z-f$P;BbN7.>\&/MF;;s_F_aA\S3*q</VU`-Y
$]A`71DL++f&-MA>!qqV[K`'\.*@EYHFg+"4a`41%H517**]A1Ob'@4GK@E<9*hNGH#j(h!i(3
B9S3n:gF%5^6oeTnF!B[`:6;f+nutG$'hJ\1<-i*U)/sJA',iY]A5mJC/:J%c&78LI6$*r\*9
oq(XG*Sb<6XX7DeF&LH&GV51V``2P3p]AQh'1q@cRMu>g0JP7+<Sm=Aatsui$&uakR<21Ff&=
6?m7R:57X3!!"5d;(pPMp=WDA-.6O#6p6e@$`A2I*/;rjpU^mblY"WKSV'TO[6idOkBAHG%E
WB,csTPsYR'nYV@&;(hta!E4g.,&-/$3a^7Uq4_?3+2"Ea`m/Id>:qJ.No:RE'gdgE?0hN1A
XR%bd.C2s8$egY#PF9Dti]AB]AD,9tF5N7,z8OZBBY!QNJ~
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
<C c="0" r="0">
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
<WidgetName name="report8"/>
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
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
<IM>
<![CDATA[!SRc)pk_gB7h#eD$31&+%7s)Y;?-[s6i[2e5R7Po!!&dGdA-aB#GF^W5u`*!jdUV$<DsmX;k
]A?qH:YeE2;XK6P;,Ta.EWl\,_Jp"0mQHe'&eSl"-n^7*[ToF*\$."Me4XmY@8tn>bqZ?]Ad-5
%pY0U,ZgKkin$DaPkMCR2l&X.ah6Zk0lh=\#s42,eeo+V?.k@Zd%C.IFrBP.;5.D>d#-WS<i
+l-rrW&G(%Klb0]AD:hEn.Bm[N!0*p\Y*NT1LoJ!PEcuF+AKYji!Jm%fF#bNLb3!X(^7L'6h3
PT1jBW]A!D=ohpaGJ0T7_L,$'ctG)JKN_Ja]AU@KJ<0np5^tM&ds;\Ns3j\SI%>Js0)RK"]AN6^
0\hV#Its`U&b%WE#3LQ'$(q*mH.J*<'*L6O#8=rALn4;^]AEE*WS\a9Q7O]AO'dWDF#JH86m'b
U?8%sU^rcQs7CFJ,gJG)dNXMkI!:JX&JVE!;UQ\jD,DFVEsZ>7b&l&A/h-n4kc+B7h+&+@6Y
:KCcm#1Fn(Rrs#D@8J';DD.Pt"N"[8l9Sa78<&KG^&R\gn/PABf:dK=,pr.;1QaLh+;2i:A?
f3Fl0gLsF_4b1$n3\eTjiY8N2<YSp0["[OJ6tJ5I0OH_";qk,XdVb=<""7Xi!5=6-057A?-Z
\&oJ:.r@9G3>>'X`&G0n_SjC+*a>pBPiKudgHHO&8VI-LR=,Xqo@W49%V!aCcRcAs4D!C<;s
CgLlbi_H+3qg]Ag,*LjOlK"+Qfi]A\L+l]A04?D*d$$IcUL(<Y5^;?ddcK1g?&W-2k4h?GqGSo@
Vg8(?>J"b.6G;E(LWKdb>uN;\mp>8G,<qKacP8.3_(SR=TMd^/J5!DN#P%&VVo;<j.#WBdB-
qo@Z%O[`:7c8YO6,2m*6ALp[gE!(#fUGQb<,^o$Yi!;f6U$(m=\%?OK8oO.V[(5+JQT_MG'.
IQ4!a=)ij%-.:\+V"Ds3Xm_D[IZWdB#'eRS,rU!l1]AMN/TkE26&[3cY"T@?g_T($E&TbaOp!
fOZkq!8ccI:rMTKK(r817#5qHG>#G4D/?j^N0^BH9Cqn_BkNL&M<(e-;q`T,<$^m1XL@]AtTZ
$+[**(_j'BmhprbZ%Qh0VIZ4B"O3mQi$Zo'SIL"s3ce"Rce'Q?8tR(MH<,VWYL8u9#L_:I\g
$o9eEKIa'!Z8QDF^]A?7%J#/"QJo.\-:*Bbi^/b_$9D;kS]AOO&]A'&$bAGFl@(@j[Wc>`[9Y,D
-+c&j8dDKS9.q?Bsn66B^kGuP]AcnWP%j$[CT,Yjc*Is\9*\(QAC,<IfW+@4KXa+JFu06!DZK
,eH]Aj"]ARRo5DW6&"%.r8@sbN/([C,GS$&YRnITag_GL&Xa1H\aYt'QDK'E`AIC7Yd\l9Q74c
MfO1j0"Ji"#jDmD$(.7(Qi'VpAW#BBB1[EC/6U+:rDK=<KX6!-aa`FEPaZoCJ'>JK:1Qm_h`
AF]AM\4>8Mtgp"(Da&`j,,qq"d>n,qADB^X-408Jd3E+APSPm*&%LA%nN@;+8)Bc+#l($pgE4
3*+F)HdS/.nut.<H@8YZM,C<^t%HP'\IMI]AEf`TN38J7geN?pGdebB^tdOU)Tl(+cWC%-CTB
oStUTZ$Gb2S\R5V`;<lCAK+mW1@L6L3W<mGVh47"AY8Ig'(G309,$N4F-;1%7imeh:&C#^/]A
%L09&-OL$XqmT(jk>_HLa<In5(/Eq8bO<<]A.nt#dLSc*AP>?`1<_G%@nHD=d0cKd=Zha*R6I
@-WE8H)JiLqp8(#JsT_bdjKQV7[MWSe3DZ%/!Li0$B,S5_M/lqqUa>V8)<A^4;g`Wn=.S`Hn
YL"_+(mo"FP%pA^G:ZR+)ab;Y(@<h^81-?'K%'bQ^iTWVJrbiPE14`W^kT8!l`G?RD?&Fk5;
JoT5+7j9@-?t[O,?\Her%`ec'd52LX;A]A0\:@*H)^"bf-nN-U,'QiH&XD3q_c8M3><_\Tl4p
XnThPc_^'YFFt7#fY4C4,^_VS,qJMUgECX3/D\37qPb]AD:Z(A^M\RcS,Gg)p$b61uaOW[/PY
"5^d6djs*dGST@k@,c6\eK]A<h*!QHHjjb7"#J>9e#+=6?9EqSH!k;4kROHofYi2A'AFScLf9
OL!=^aTAu<40!=7+G1ft,H!F4WAi>'9JH*HMk9i,f9bP]AY"(ah)?BG`aN"3>jb=R(J[)soeM
O!KN-9Q(4jM'1#>Eqe8-N(RZ>E.mGk(]Auq1ZHsELp9a:L-&</0Z03?/fG@.<V4p%RQ:>+%RR
!m@"2jrBe1m]An&*?AB6WZeE'42\"J2M<#N@fr49PYkHVGZifgN9%EehT(361ffm'#S*%@-[b
fMXI?SRX<UVZAJb0hRu*+8Ee!D=Mcap_qjjW"<FQpQk7#(e/*kb]AW;9V`8R+75AFMlE!14cS
c!kSLT""*r$pi.&80[u-[M0)U3^_'F*['>_I2m9d6/>]A%':I=KZXqG#JZ5a"Khh;MY[K/M(H
2Ff"TWN\(S":r/D"m:A\1g!?qCK=0[d[TA&IEQ--W[`Q!B]Aq"<)aju\n0!!!!j78?7R6=>B
~
]]></IM>
</Background>
<Alpha alpha="1.0"/>
</Border>
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
<IM>
<![CDATA[!SRc)pk_gB7h#eD$31&+%7s)Y;?-[s6i[2e5R7Po!!&dGdA-aB#GF^W5u`*!jdUV$<DsmX;k
]A?qH:YeE2;XK6P;,Ta.EWl\,_Jp"0mQHe'&eSl"-n^7*[ToF*\$."Me4XmY@8tn>bqZ?]Ad-5
%pY0U,ZgKkin$DaPkMCR2l&X.ah6Zk0lh=\#s42,eeo+V?.k@Zd%C.IFrBP.;5.D>d#-WS<i
+l-rrW&G(%Klb0]AD:hEn.Bm[N!0*p\Y*NT1LoJ!PEcuF+AKYji!Jm%fF#bNLb3!X(^7L'6h3
PT1jBW]A!D=ohpaGJ0T7_L,$'ctG)JKN_Ja]AU@KJ<0np5^tM&ds;\Ns3j\SI%>Js0)RK"]AN6^
0\hV#Its`U&b%WE#3LQ'$(q*mH.J*<'*L6O#8=rALn4;^]AEE*WS\a9Q7O]AO'dWDF#JH86m'b
U?8%sU^rcQs7CFJ,gJG)dNXMkI!:JX&JVE!;UQ\jD,DFVEsZ>7b&l&A/h-n4kc+B7h+&+@6Y
:KCcm#1Fn(Rrs#D@8J';DD.Pt"N"[8l9Sa78<&KG^&R\gn/PABf:dK=,pr.;1QaLh+;2i:A?
f3Fl0gLsF_4b1$n3\eTjiY8N2<YSp0["[OJ6tJ5I0OH_";qk,XdVb=<""7Xi!5=6-057A?-Z
\&oJ:.r@9G3>>'X`&G0n_SjC+*a>pBPiKudgHHO&8VI-LR=,Xqo@W49%V!aCcRcAs4D!C<;s
CgLlbi_H+3qg]Ag,*LjOlK"+Qfi]A\L+l]A04?D*d$$IcUL(<Y5^;?ddcK1g?&W-2k4h?GqGSo@
Vg8(?>J"b.6G;E(LWKdb>uN;\mp>8G,<qKacP8.3_(SR=TMd^/J5!DN#P%&VVo;<j.#WBdB-
qo@Z%O[`:7c8YO6,2m*6ALp[gE!(#fUGQb<,^o$Yi!;f6U$(m=\%?OK8oO.V[(5+JQT_MG'.
IQ4!a=)ij%-.:\+V"Ds3Xm_D[IZWdB#'eRS,rU!l1]AMN/TkE26&[3cY"T@?g_T($E&TbaOp!
fOZkq!8ccI:rMTKK(r817#5qHG>#G4D/?j^N0^BH9Cqn_BkNL&M<(e-;q`T,<$^m1XL@]AtTZ
$+[**(_j'BmhprbZ%Qh0VIZ4B"O3mQi$Zo'SIL"s3ce"Rce'Q?8tR(MH<,VWYL8u9#L_:I\g
$o9eEKIa'!Z8QDF^]A?7%J#/"QJo.\-:*Bbi^/b_$9D;kS]AOO&]A'&$bAGFl@(@j[Wc>`[9Y,D
-+c&j8dDKS9.q?Bsn66B^kGuP]AcnWP%j$[CT,Yjc*Is\9*\(QAC,<IfW+@4KXa+JFu06!DZK
,eH]Aj"]ARRo5DW6&"%.r8@sbN/([C,GS$&YRnITag_GL&Xa1H\aYt'QDK'E`AIC7Yd\l9Q74c
MfO1j0"Ji"#jDmD$(.7(Qi'VpAW#BBB1[EC/6U+:rDK=<KX6!-aa`FEPaZoCJ'>JK:1Qm_h`
AF]AM\4>8Mtgp"(Da&`j,,qq"d>n,qADB^X-408Jd3E+APSPm*&%LA%nN@;+8)Bc+#l($pgE4
3*+F)HdS/.nut.<H@8YZM,C<^t%HP'\IMI]AEf`TN38J7geN?pGdebB^tdOU)Tl(+cWC%-CTB
oStUTZ$Gb2S\R5V`;<lCAK+mW1@L6L3W<mGVh47"AY8Ig'(G309,$N4F-;1%7imeh:&C#^/]A
%L09&-OL$XqmT(jk>_HLa<In5(/Eq8bO<<]A.nt#dLSc*AP>?`1<_G%@nHD=d0cKd=Zha*R6I
@-WE8H)JiLqp8(#JsT_bdjKQV7[MWSe3DZ%/!Li0$B,S5_M/lqqUa>V8)<A^4;g`Wn=.S`Hn
YL"_+(mo"FP%pA^G:ZR+)ab;Y(@<h^81-?'K%'bQ^iTWVJrbiPE14`W^kT8!l`G?RD?&Fk5;
JoT5+7j9@-?t[O,?\Her%`ec'd52LX;A]A0\:@*H)^"bf-nN-U,'QiH&XD3q_c8M3><_\Tl4p
XnThPc_^'YFFt7#fY4C4,^_VS,qJMUgECX3/D\37qPb]AD:Z(A^M\RcS,Gg)p$b61uaOW[/PY
"5^d6djs*dGST@k@,c6\eK]A<h*!QHHjjb7"#J>9e#+=6?9EqSH!k;4kROHofYi2A'AFScLf9
OL!=^aTAu<40!=7+G1ft,H!F4WAi>'9JH*HMk9i,f9bP]AY"(ah)?BG`aN"3>jb=R(J[)soeM
O!KN-9Q(4jM'1#>Eqe8-N(RZ>E.mGk(]Auq1ZHsELp9a:L-&</0Z03?/fG@.<V4p%RQ:>+%RR
!m@"2jrBe1m]An&*?AB6WZeE'42\"J2M<#N@fr49PYkHVGZifgN9%EehT(361ffm'#S*%@-[b
fMXI?SRX<UVZAJb0hRu*+8Ee!D=Mcap_qjjW"<FQpQk7#(e/*kb]AW;9V`8R+75AFMlE!14cS
c!kSLT""*r$pi.&80[u-[M0)U3^_'F*['>_I2m9d6/>]A%':I=KZXqG#JZ5a"Khh;MY[K/M(H
2Ff"TWN\(S":r/D"m:A\1g!?qCK=0[d[TA&IEQ--W[`Q!B]Aq"<)aju\n0!!!!j78?7R6=>B
~
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
<BoundsAttr x="234" y="58" width="27" height="27"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report8_c"/>
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
<WidgetName name="report8_c"/>
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
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
<IM>
<![CDATA[!La+%r/"6F7h#eD$31&+%7s)Y;?-[s6i[2e5R7Po!!&dGdA-aB"(=bh5u`*!mFko\NH#rYnb
kCrB#f^E:T`_S/Z"caU)'LN+g&^02C2VT+r>.Z\.DOb&S4Olb`.pMKMHNnP`S`eerg=oXdCr
ckL\#<fD#2lk</e=Hd;5pG[9^kms1N!F8#MlSXapeStl7N@gp=V1CH+W7<f>-Tc<R9fUdsdn
t6IRi":o8>[U2_#FPs(iA,eC"JDLB'Vk_0^_(emInW>QWZY<G"0TOc)Z^!^U_oQY,kThRkTR
G9/at6G5o.:C\-5*5";ld'YR_M5[@`W8F&8f=OQit]AcGEeTT7R)'%I7D*RVgFpbW!$5S"X@J
K?Ss#A)`olC4K0k!P;dSKq/q^iVeA_YS/Mb$rRTX/Ojsha'gh>g"b7S6$Vb!eHZ>=e:0V_K,
B?RkCg$X%GI>B/I+S?f5Ld0N/7d(f7I7mCiDLV7\[-BnE.!E#3geXE!LhrM":o__%`e5.ZMr
ukg,)]A_/'V`A-rt2r`068i4`S@A_7;?FV85s@*p;C6C8(rX+3A&cpSQ`0\:3(:9rLk+(JCZ_
IHB^qr)O`-uF-[FH_E)1[IdG%!"BSF+_CL(PC'om"oqRXRj;HOC#6>V$oEs,P.fYF7bDKHP@
a)7Bk%*0F)$)g7r2\J,_E8%)UA,b$dMdYcn#Z3@cCsmDK&JK%qSdSadq\gY<2]A4Vf]A'PX@=+
9JT[DaPM0d"N_=Y=0,#U(n(-Y)A3X`f;O>c+?E%9K.M[ZNZjgk,uWSb/Hj03X>`M3+DqSbD-
$rcDSc\BW+9e!=RRA'WF3CD<J&01I-<5`3f"9/5"J'#i0'Bsk*h,6#=/\#lci9QLt_u\QdJ*
TY/EUO*Ct7E]AN#GnPR,j@;^Ftnb_Q1lWe9LXl%?>iFuj?>A1gL(8ES,!.2K!dX\'/6"o^-l^
5%M`VFotpK^<nmAqK(NegjQC8;tcJrYhM`kTDpBV',V-Ard,p[]A>#lPOXj:R=b*tW=gIGk!O
VqeNn;=oKh-aD(DMj1=o,t3=&M.=Kbtp+DqSb>pa?=YZGN3nST]AMa<D,t1L>At[bp+Q/MkGQ
1`>@:)%Nu_/BF1[4/.U@(?C)L4/.U]A(1[N[1fAg9&N7t/1$'l(G(0NA-cV[ZqC0Yh!!!!j78
?7R6=>B~
]]></IM>
</Background>
<Alpha alpha="1.0"/>
</Border>
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
<IM>
<![CDATA[!La+%r/"6F7h#eD$31&+%7s)Y;?-[s6i[2e5R7Po!!&dGdA-aB"(=bh5u`*!mFko\NH#rYnb
kCrB#f^E:T`_S/Z"caU)'LN+g&^02C2VT+r>.Z\.DOb&S4Olb`.pMKMHNnP`S`eerg=oXdCr
ckL\#<fD#2lk</e=Hd;5pG[9^kms1N!F8#MlSXapeStl7N@gp=V1CH+W7<f>-Tc<R9fUdsdn
t6IRi":o8>[U2_#FPs(iA,eC"JDLB'Vk_0^_(emInW>QWZY<G"0TOc)Z^!^U_oQY,kThRkTR
G9/at6G5o.:C\-5*5";ld'YR_M5[@`W8F&8f=OQit]AcGEeTT7R)'%I7D*RVgFpbW!$5S"X@J
K?Ss#A)`olC4K0k!P;dSKq/q^iVeA_YS/Mb$rRTX/Ojsha'gh>g"b7S6$Vb!eHZ>=e:0V_K,
B?RkCg$X%GI>B/I+S?f5Ld0N/7d(f7I7mCiDLV7\[-BnE.!E#3geXE!LhrM":o__%`e5.ZMr
ukg,)]A_/'V`A-rt2r`068i4`S@A_7;?FV85s@*p;C6C8(rX+3A&cpSQ`0\:3(:9rLk+(JCZ_
IHB^qr)O`-uF-[FH_E)1[IdG%!"BSF+_CL(PC'om"oqRXRj;HOC#6>V$oEs,P.fYF7bDKHP@
a)7Bk%*0F)$)g7r2\J,_E8%)UA,b$dMdYcn#Z3@cCsmDK&JK%qSdSadq\gY<2]A4Vf]A'PX@=+
9JT[DaPM0d"N_=Y=0,#U(n(-Y)A3X`f;O>c+?E%9K.M[ZNZjgk,uWSb/Hj03X>`M3+DqSbD-
$rcDSc\BW+9e!=RRA'WF3CD<J&01I-<5`3f"9/5"J'#i0'Bsk*h,6#=/\#lci9QLt_u\QdJ*
TY/EUO*Ct7E]AN#GnPR,j@;^Ftnb_Q1lWe9LXl%?>iFuj?>A1gL(8ES,!.2K!dX\'/6"o^-l^
5%M`VFotpK^<nmAqK(NegjQC8;tcJrYhM`kTDpBV',V-Ard,p[]A>#lPOXj:R=b*tW=gIGk!O
VqeNn;=oKh-aD(DMj1=o,t3=&M.=Kbtp+DqSb>pa?=YZGN3nST]AMa<D,t1L>At[bp+Q/MkGQ
1`>@:)%Nu_/BF1[4/.U@(?C)L4/.U]A(1[N[1fAg9&N7t/1$'l(G(0NA-cV[ZqC0Yh!!!!j78
?7R6=>B~
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
<C c="0" r="0">
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
<WidgetName name="report8"/>
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
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
<IM>
<![CDATA[!SRc)pk_gB7h#eD$31&+%7s)Y;?-[s6i[2e5R7Po!!&dGdA-aB#GF^W5u`*!jdUV$<DsmX;k
]A?qH:YeE2;XK6P;,Ta.EWl\,_Jp"0mQHe'&eSl"-n^7*[ToF*\$."Me4XmY@8tn>bqZ?]Ad-5
%pY0U,ZgKkin$DaPkMCR2l&X.ah6Zk0lh=\#s42,eeo+V?.k@Zd%C.IFrBP.;5.D>d#-WS<i
+l-rrW&G(%Klb0]AD:hEn.Bm[N!0*p\Y*NT1LoJ!PEcuF+AKYji!Jm%fF#bNLb3!X(^7L'6h3
PT1jBW]A!D=ohpaGJ0T7_L,$'ctG)JKN_Ja]AU@KJ<0np5^tM&ds;\Ns3j\SI%>Js0)RK"]AN6^
0\hV#Its`U&b%WE#3LQ'$(q*mH.J*<'*L6O#8=rALn4;^]AEE*WS\a9Q7O]AO'dWDF#JH86m'b
U?8%sU^rcQs7CFJ,gJG)dNXMkI!:JX&JVE!;UQ\jD,DFVEsZ>7b&l&A/h-n4kc+B7h+&+@6Y
:KCcm#1Fn(Rrs#D@8J';DD.Pt"N"[8l9Sa78<&KG^&R\gn/PABf:dK=,pr.;1QaLh+;2i:A?
f3Fl0gLsF_4b1$n3\eTjiY8N2<YSp0["[OJ6tJ5I0OH_";qk,XdVb=<""7Xi!5=6-057A?-Z
\&oJ:.r@9G3>>'X`&G0n_SjC+*a>pBPiKudgHHO&8VI-LR=,Xqo@W49%V!aCcRcAs4D!C<;s
CgLlbi_H+3qg]Ag,*LjOlK"+Qfi]A\L+l]A04?D*d$$IcUL(<Y5^;?ddcK1g?&W-2k4h?GqGSo@
Vg8(?>J"b.6G;E(LWKdb>uN;\mp>8G,<qKacP8.3_(SR=TMd^/J5!DN#P%&VVo;<j.#WBdB-
qo@Z%O[`:7c8YO6,2m*6ALp[gE!(#fUGQb<,^o$Yi!;f6U$(m=\%?OK8oO.V[(5+JQT_MG'.
IQ4!a=)ij%-.:\+V"Ds3Xm_D[IZWdB#'eRS,rU!l1]AMN/TkE26&[3cY"T@?g_T($E&TbaOp!
fOZkq!8ccI:rMTKK(r817#5qHG>#G4D/?j^N0^BH9Cqn_BkNL&M<(e-;q`T,<$^m1XL@]AtTZ
$+[**(_j'BmhprbZ%Qh0VIZ4B"O3mQi$Zo'SIL"s3ce"Rce'Q?8tR(MH<,VWYL8u9#L_:I\g
$o9eEKIa'!Z8QDF^]A?7%J#/"QJo.\-:*Bbi^/b_$9D;kS]AOO&]A'&$bAGFl@(@j[Wc>`[9Y,D
-+c&j8dDKS9.q?Bsn66B^kGuP]AcnWP%j$[CT,Yjc*Is\9*\(QAC,<IfW+@4KXa+JFu06!DZK
,eH]Aj"]ARRo5DW6&"%.r8@sbN/([C,GS$&YRnITag_GL&Xa1H\aYt'QDK'E`AIC7Yd\l9Q74c
MfO1j0"Ji"#jDmD$(.7(Qi'VpAW#BBB1[EC/6U+:rDK=<KX6!-aa`FEPaZoCJ'>JK:1Qm_h`
AF]AM\4>8Mtgp"(Da&`j,,qq"d>n,qADB^X-408Jd3E+APSPm*&%LA%nN@;+8)Bc+#l($pgE4
3*+F)HdS/.nut.<H@8YZM,C<^t%HP'\IMI]AEf`TN38J7geN?pGdebB^tdOU)Tl(+cWC%-CTB
oStUTZ$Gb2S\R5V`;<lCAK+mW1@L6L3W<mGVh47"AY8Ig'(G309,$N4F-;1%7imeh:&C#^/]A
%L09&-OL$XqmT(jk>_HLa<In5(/Eq8bO<<]A.nt#dLSc*AP>?`1<_G%@nHD=d0cKd=Zha*R6I
@-WE8H)JiLqp8(#JsT_bdjKQV7[MWSe3DZ%/!Li0$B,S5_M/lqqUa>V8)<A^4;g`Wn=.S`Hn
YL"_+(mo"FP%pA^G:ZR+)ab;Y(@<h^81-?'K%'bQ^iTWVJrbiPE14`W^kT8!l`G?RD?&Fk5;
JoT5+7j9@-?t[O,?\Her%`ec'd52LX;A]A0\:@*H)^"bf-nN-U,'QiH&XD3q_c8M3><_\Tl4p
XnThPc_^'YFFt7#fY4C4,^_VS,qJMUgECX3/D\37qPb]AD:Z(A^M\RcS,Gg)p$b61uaOW[/PY
"5^d6djs*dGST@k@,c6\eK]A<h*!QHHjjb7"#J>9e#+=6?9EqSH!k;4kROHofYi2A'AFScLf9
OL!=^aTAu<40!=7+G1ft,H!F4WAi>'9JH*HMk9i,f9bP]AY"(ah)?BG`aN"3>jb=R(J[)soeM
O!KN-9Q(4jM'1#>Eqe8-N(RZ>E.mGk(]Auq1ZHsELp9a:L-&</0Z03?/fG@.<V4p%RQ:>+%RR
!m@"2jrBe1m]An&*?AB6WZeE'42\"J2M<#N@fr49PYkHVGZifgN9%EehT(361ffm'#S*%@-[b
fMXI?SRX<UVZAJb0hRu*+8Ee!D=Mcap_qjjW"<FQpQk7#(e/*kb]AW;9V`8R+75AFMlE!14cS
c!kSLT""*r$pi.&80[u-[M0)U3^_'F*['>_I2m9d6/>]A%':I=KZXqG#JZ5a"Khh;MY[K/M(H
2Ff"TWN\(S":r/D"m:A\1g!?qCK=0[d[TA&IEQ--W[`Q!B]Aq"<)aju\n0!!!!j78?7R6=>B
~
]]></IM>
</Background>
<Alpha alpha="1.0"/>
</Border>
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
<IM>
<![CDATA[!SRc)pk_gB7h#eD$31&+%7s)Y;?-[s6i[2e5R7Po!!&dGdA-aB#GF^W5u`*!jdUV$<DsmX;k
]A?qH:YeE2;XK6P;,Ta.EWl\,_Jp"0mQHe'&eSl"-n^7*[ToF*\$."Me4XmY@8tn>bqZ?]Ad-5
%pY0U,ZgKkin$DaPkMCR2l&X.ah6Zk0lh=\#s42,eeo+V?.k@Zd%C.IFrBP.;5.D>d#-WS<i
+l-rrW&G(%Klb0]AD:hEn.Bm[N!0*p\Y*NT1LoJ!PEcuF+AKYji!Jm%fF#bNLb3!X(^7L'6h3
PT1jBW]A!D=ohpaGJ0T7_L,$'ctG)JKN_Ja]AU@KJ<0np5^tM&ds;\Ns3j\SI%>Js0)RK"]AN6^
0\hV#Its`U&b%WE#3LQ'$(q*mH.J*<'*L6O#8=rALn4;^]AEE*WS\a9Q7O]AO'dWDF#JH86m'b
U?8%sU^rcQs7CFJ,gJG)dNXMkI!:JX&JVE!;UQ\jD,DFVEsZ>7b&l&A/h-n4kc+B7h+&+@6Y
:KCcm#1Fn(Rrs#D@8J';DD.Pt"N"[8l9Sa78<&KG^&R\gn/PABf:dK=,pr.;1QaLh+;2i:A?
f3Fl0gLsF_4b1$n3\eTjiY8N2<YSp0["[OJ6tJ5I0OH_";qk,XdVb=<""7Xi!5=6-057A?-Z
\&oJ:.r@9G3>>'X`&G0n_SjC+*a>pBPiKudgHHO&8VI-LR=,Xqo@W49%V!aCcRcAs4D!C<;s
CgLlbi_H+3qg]Ag,*LjOlK"+Qfi]A\L+l]A04?D*d$$IcUL(<Y5^;?ddcK1g?&W-2k4h?GqGSo@
Vg8(?>J"b.6G;E(LWKdb>uN;\mp>8G,<qKacP8.3_(SR=TMd^/J5!DN#P%&VVo;<j.#WBdB-
qo@Z%O[`:7c8YO6,2m*6ALp[gE!(#fUGQb<,^o$Yi!;f6U$(m=\%?OK8oO.V[(5+JQT_MG'.
IQ4!a=)ij%-.:\+V"Ds3Xm_D[IZWdB#'eRS,rU!l1]AMN/TkE26&[3cY"T@?g_T($E&TbaOp!
fOZkq!8ccI:rMTKK(r817#5qHG>#G4D/?j^N0^BH9Cqn_BkNL&M<(e-;q`T,<$^m1XL@]AtTZ
$+[**(_j'BmhprbZ%Qh0VIZ4B"O3mQi$Zo'SIL"s3ce"Rce'Q?8tR(MH<,VWYL8u9#L_:I\g
$o9eEKIa'!Z8QDF^]A?7%J#/"QJo.\-:*Bbi^/b_$9D;kS]AOO&]A'&$bAGFl@(@j[Wc>`[9Y,D
-+c&j8dDKS9.q?Bsn66B^kGuP]AcnWP%j$[CT,Yjc*Is\9*\(QAC,<IfW+@4KXa+JFu06!DZK
,eH]Aj"]ARRo5DW6&"%.r8@sbN/([C,GS$&YRnITag_GL&Xa1H\aYt'QDK'E`AIC7Yd\l9Q74c
MfO1j0"Ji"#jDmD$(.7(Qi'VpAW#BBB1[EC/6U+:rDK=<KX6!-aa`FEPaZoCJ'>JK:1Qm_h`
AF]AM\4>8Mtgp"(Da&`j,,qq"d>n,qADB^X-408Jd3E+APSPm*&%LA%nN@;+8)Bc+#l($pgE4
3*+F)HdS/.nut.<H@8YZM,C<^t%HP'\IMI]AEf`TN38J7geN?pGdebB^tdOU)Tl(+cWC%-CTB
oStUTZ$Gb2S\R5V`;<lCAK+mW1@L6L3W<mGVh47"AY8Ig'(G309,$N4F-;1%7imeh:&C#^/]A
%L09&-OL$XqmT(jk>_HLa<In5(/Eq8bO<<]A.nt#dLSc*AP>?`1<_G%@nHD=d0cKd=Zha*R6I
@-WE8H)JiLqp8(#JsT_bdjKQV7[MWSe3DZ%/!Li0$B,S5_M/lqqUa>V8)<A^4;g`Wn=.S`Hn
YL"_+(mo"FP%pA^G:ZR+)ab;Y(@<h^81-?'K%'bQ^iTWVJrbiPE14`W^kT8!l`G?RD?&Fk5;
JoT5+7j9@-?t[O,?\Her%`ec'd52LX;A]A0\:@*H)^"bf-nN-U,'QiH&XD3q_c8M3><_\Tl4p
XnThPc_^'YFFt7#fY4C4,^_VS,qJMUgECX3/D\37qPb]AD:Z(A^M\RcS,Gg)p$b61uaOW[/PY
"5^d6djs*dGST@k@,c6\eK]A<h*!QHHjjb7"#J>9e#+=6?9EqSH!k;4kROHofYi2A'AFScLf9
OL!=^aTAu<40!=7+G1ft,H!F4WAi>'9JH*HMk9i,f9bP]AY"(ah)?BG`aN"3>jb=R(J[)soeM
O!KN-9Q(4jM'1#>Eqe8-N(RZ>E.mGk(]Auq1ZHsELp9a:L-&</0Z03?/fG@.<V4p%RQ:>+%RR
!m@"2jrBe1m]An&*?AB6WZeE'42\"J2M<#N@fr49PYkHVGZifgN9%EehT(361ffm'#S*%@-[b
fMXI?SRX<UVZAJb0hRu*+8Ee!D=Mcap_qjjW"<FQpQk7#(e/*kb]AW;9V`8R+75AFMlE!14cS
c!kSLT""*r$pi.&80[u-[M0)U3^_'F*['>_I2m9d6/>]A%':I=KZXqG#JZ5a"Khh;MY[K/M(H
2Ff"TWN\(S":r/D"m:A\1g!?qCK=0[d[TA&IEQ--W[`Q!B]Aq"<)aju\n0!!!!j78?7R6=>B
~
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
<BoundsAttr x="450" y="58" width="27" height="27"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report8"/>
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
<WidgetName name="report8"/>
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
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
<IM>
<![CDATA[!SRc)pk_gB7h#eD$31&+%7s)Y;?-[s6i[2e5R7Po!!&dGdA-aB#GF^W5u`*!jdUV$<DsmX;k
]A?qH:YeE2;XK6P;,Ta.EWl\,_Jp"0mQHe'&eSl"-n^7*[ToF*\$."Me4XmY@8tn>bqZ?]Ad-5
%pY0U,ZgKkin$DaPkMCR2l&X.ah6Zk0lh=\#s42,eeo+V?.k@Zd%C.IFrBP.;5.D>d#-WS<i
+l-rrW&G(%Klb0]AD:hEn.Bm[N!0*p\Y*NT1LoJ!PEcuF+AKYji!Jm%fF#bNLb3!X(^7L'6h3
PT1jBW]A!D=ohpaGJ0T7_L,$'ctG)JKN_Ja]AU@KJ<0np5^tM&ds;\Ns3j\SI%>Js0)RK"]AN6^
0\hV#Its`U&b%WE#3LQ'$(q*mH.J*<'*L6O#8=rALn4;^]AEE*WS\a9Q7O]AO'dWDF#JH86m'b
U?8%sU^rcQs7CFJ,gJG)dNXMkI!:JX&JVE!;UQ\jD,DFVEsZ>7b&l&A/h-n4kc+B7h+&+@6Y
:KCcm#1Fn(Rrs#D@8J';DD.Pt"N"[8l9Sa78<&KG^&R\gn/PABf:dK=,pr.;1QaLh+;2i:A?
f3Fl0gLsF_4b1$n3\eTjiY8N2<YSp0["[OJ6tJ5I0OH_";qk,XdVb=<""7Xi!5=6-057A?-Z
\&oJ:.r@9G3>>'X`&G0n_SjC+*a>pBPiKudgHHO&8VI-LR=,Xqo@W49%V!aCcRcAs4D!C<;s
CgLlbi_H+3qg]Ag,*LjOlK"+Qfi]A\L+l]A04?D*d$$IcUL(<Y5^;?ddcK1g?&W-2k4h?GqGSo@
Vg8(?>J"b.6G;E(LWKdb>uN;\mp>8G,<qKacP8.3_(SR=TMd^/J5!DN#P%&VVo;<j.#WBdB-
qo@Z%O[`:7c8YO6,2m*6ALp[gE!(#fUGQb<,^o$Yi!;f6U$(m=\%?OK8oO.V[(5+JQT_MG'.
IQ4!a=)ij%-.:\+V"Ds3Xm_D[IZWdB#'eRS,rU!l1]AMN/TkE26&[3cY"T@?g_T($E&TbaOp!
fOZkq!8ccI:rMTKK(r817#5qHG>#G4D/?j^N0^BH9Cqn_BkNL&M<(e-;q`T,<$^m1XL@]AtTZ
$+[**(_j'BmhprbZ%Qh0VIZ4B"O3mQi$Zo'SIL"s3ce"Rce'Q?8tR(MH<,VWYL8u9#L_:I\g
$o9eEKIa'!Z8QDF^]A?7%J#/"QJo.\-:*Bbi^/b_$9D;kS]AOO&]A'&$bAGFl@(@j[Wc>`[9Y,D
-+c&j8dDKS9.q?Bsn66B^kGuP]AcnWP%j$[CT,Yjc*Is\9*\(QAC,<IfW+@4KXa+JFu06!DZK
,eH]Aj"]ARRo5DW6&"%.r8@sbN/([C,GS$&YRnITag_GL&Xa1H\aYt'QDK'E`AIC7Yd\l9Q74c
MfO1j0"Ji"#jDmD$(.7(Qi'VpAW#BBB1[EC/6U+:rDK=<KX6!-aa`FEPaZoCJ'>JK:1Qm_h`
AF]AM\4>8Mtgp"(Da&`j,,qq"d>n,qADB^X-408Jd3E+APSPm*&%LA%nN@;+8)Bc+#l($pgE4
3*+F)HdS/.nut.<H@8YZM,C<^t%HP'\IMI]AEf`TN38J7geN?pGdebB^tdOU)Tl(+cWC%-CTB
oStUTZ$Gb2S\R5V`;<lCAK+mW1@L6L3W<mGVh47"AY8Ig'(G309,$N4F-;1%7imeh:&C#^/]A
%L09&-OL$XqmT(jk>_HLa<In5(/Eq8bO<<]A.nt#dLSc*AP>?`1<_G%@nHD=d0cKd=Zha*R6I
@-WE8H)JiLqp8(#JsT_bdjKQV7[MWSe3DZ%/!Li0$B,S5_M/lqqUa>V8)<A^4;g`Wn=.S`Hn
YL"_+(mo"FP%pA^G:ZR+)ab;Y(@<h^81-?'K%'bQ^iTWVJrbiPE14`W^kT8!l`G?RD?&Fk5;
JoT5+7j9@-?t[O,?\Her%`ec'd52LX;A]A0\:@*H)^"bf-nN-U,'QiH&XD3q_c8M3><_\Tl4p
XnThPc_^'YFFt7#fY4C4,^_VS,qJMUgECX3/D\37qPb]AD:Z(A^M\RcS,Gg)p$b61uaOW[/PY
"5^d6djs*dGST@k@,c6\eK]A<h*!QHHjjb7"#J>9e#+=6?9EqSH!k;4kROHofYi2A'AFScLf9
OL!=^aTAu<40!=7+G1ft,H!F4WAi>'9JH*HMk9i,f9bP]AY"(ah)?BG`aN"3>jb=R(J[)soeM
O!KN-9Q(4jM'1#>Eqe8-N(RZ>E.mGk(]Auq1ZHsELp9a:L-&</0Z03?/fG@.<V4p%RQ:>+%RR
!m@"2jrBe1m]An&*?AB6WZeE'42\"J2M<#N@fr49PYkHVGZifgN9%EehT(361ffm'#S*%@-[b
fMXI?SRX<UVZAJb0hRu*+8Ee!D=Mcap_qjjW"<FQpQk7#(e/*kb]AW;9V`8R+75AFMlE!14cS
c!kSLT""*r$pi.&80[u-[M0)U3^_'F*['>_I2m9d6/>]A%':I=KZXqG#JZ5a"Khh;MY[K/M(H
2Ff"TWN\(S":r/D"m:A\1g!?qCK=0[d[TA&IEQ--W[`Q!B]Aq"<)aju\n0!!!!j78?7R6=>B
~
]]></IM>
</Background>
<Alpha alpha="1.0"/>
</Border>
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
<IM>
<![CDATA[!SRc)pk_gB7h#eD$31&+%7s)Y;?-[s6i[2e5R7Po!!&dGdA-aB#GF^W5u`*!jdUV$<DsmX;k
]A?qH:YeE2;XK6P;,Ta.EWl\,_Jp"0mQHe'&eSl"-n^7*[ToF*\$."Me4XmY@8tn>bqZ?]Ad-5
%pY0U,ZgKkin$DaPkMCR2l&X.ah6Zk0lh=\#s42,eeo+V?.k@Zd%C.IFrBP.;5.D>d#-WS<i
+l-rrW&G(%Klb0]AD:hEn.Bm[N!0*p\Y*NT1LoJ!PEcuF+AKYji!Jm%fF#bNLb3!X(^7L'6h3
PT1jBW]A!D=ohpaGJ0T7_L,$'ctG)JKN_Ja]AU@KJ<0np5^tM&ds;\Ns3j\SI%>Js0)RK"]AN6^
0\hV#Its`U&b%WE#3LQ'$(q*mH.J*<'*L6O#8=rALn4;^]AEE*WS\a9Q7O]AO'dWDF#JH86m'b
U?8%sU^rcQs7CFJ,gJG)dNXMkI!:JX&JVE!;UQ\jD,DFVEsZ>7b&l&A/h-n4kc+B7h+&+@6Y
:KCcm#1Fn(Rrs#D@8J';DD.Pt"N"[8l9Sa78<&KG^&R\gn/PABf:dK=,pr.;1QaLh+;2i:A?
f3Fl0gLsF_4b1$n3\eTjiY8N2<YSp0["[OJ6tJ5I0OH_";qk,XdVb=<""7Xi!5=6-057A?-Z
\&oJ:.r@9G3>>'X`&G0n_SjC+*a>pBPiKudgHHO&8VI-LR=,Xqo@W49%V!aCcRcAs4D!C<;s
CgLlbi_H+3qg]Ag,*LjOlK"+Qfi]A\L+l]A04?D*d$$IcUL(<Y5^;?ddcK1g?&W-2k4h?GqGSo@
Vg8(?>J"b.6G;E(LWKdb>uN;\mp>8G,<qKacP8.3_(SR=TMd^/J5!DN#P%&VVo;<j.#WBdB-
qo@Z%O[`:7c8YO6,2m*6ALp[gE!(#fUGQb<,^o$Yi!;f6U$(m=\%?OK8oO.V[(5+JQT_MG'.
IQ4!a=)ij%-.:\+V"Ds3Xm_D[IZWdB#'eRS,rU!l1]AMN/TkE26&[3cY"T@?g_T($E&TbaOp!
fOZkq!8ccI:rMTKK(r817#5qHG>#G4D/?j^N0^BH9Cqn_BkNL&M<(e-;q`T,<$^m1XL@]AtTZ
$+[**(_j'BmhprbZ%Qh0VIZ4B"O3mQi$Zo'SIL"s3ce"Rce'Q?8tR(MH<,VWYL8u9#L_:I\g
$o9eEKIa'!Z8QDF^]A?7%J#/"QJo.\-:*Bbi^/b_$9D;kS]AOO&]A'&$bAGFl@(@j[Wc>`[9Y,D
-+c&j8dDKS9.q?Bsn66B^kGuP]AcnWP%j$[CT,Yjc*Is\9*\(QAC,<IfW+@4KXa+JFu06!DZK
,eH]Aj"]ARRo5DW6&"%.r8@sbN/([C,GS$&YRnITag_GL&Xa1H\aYt'QDK'E`AIC7Yd\l9Q74c
MfO1j0"Ji"#jDmD$(.7(Qi'VpAW#BBB1[EC/6U+:rDK=<KX6!-aa`FEPaZoCJ'>JK:1Qm_h`
AF]AM\4>8Mtgp"(Da&`j,,qq"d>n,qADB^X-408Jd3E+APSPm*&%LA%nN@;+8)Bc+#l($pgE4
3*+F)HdS/.nut.<H@8YZM,C<^t%HP'\IMI]AEf`TN38J7geN?pGdebB^tdOU)Tl(+cWC%-CTB
oStUTZ$Gb2S\R5V`;<lCAK+mW1@L6L3W<mGVh47"AY8Ig'(G309,$N4F-;1%7imeh:&C#^/]A
%L09&-OL$XqmT(jk>_HLa<In5(/Eq8bO<<]A.nt#dLSc*AP>?`1<_G%@nHD=d0cKd=Zha*R6I
@-WE8H)JiLqp8(#JsT_bdjKQV7[MWSe3DZ%/!Li0$B,S5_M/lqqUa>V8)<A^4;g`Wn=.S`Hn
YL"_+(mo"FP%pA^G:ZR+)ab;Y(@<h^81-?'K%'bQ^iTWVJrbiPE14`W^kT8!l`G?RD?&Fk5;
JoT5+7j9@-?t[O,?\Her%`ec'd52LX;A]A0\:@*H)^"bf-nN-U,'QiH&XD3q_c8M3><_\Tl4p
XnThPc_^'YFFt7#fY4C4,^_VS,qJMUgECX3/D\37qPb]AD:Z(A^M\RcS,Gg)p$b61uaOW[/PY
"5^d6djs*dGST@k@,c6\eK]A<h*!QHHjjb7"#J>9e#+=6?9EqSH!k;4kROHofYi2A'AFScLf9
OL!=^aTAu<40!=7+G1ft,H!F4WAi>'9JH*HMk9i,f9bP]AY"(ah)?BG`aN"3>jb=R(J[)soeM
O!KN-9Q(4jM'1#>Eqe8-N(RZ>E.mGk(]Auq1ZHsELp9a:L-&</0Z03?/fG@.<V4p%RQ:>+%RR
!m@"2jrBe1m]An&*?AB6WZeE'42\"J2M<#N@fr49PYkHVGZifgN9%EehT(361ffm'#S*%@-[b
fMXI?SRX<UVZAJb0hRu*+8Ee!D=Mcap_qjjW"<FQpQk7#(e/*kb]AW;9V`8R+75AFMlE!14cS
c!kSLT""*r$pi.&80[u-[M0)U3^_'F*['>_I2m9d6/>]A%':I=KZXqG#JZ5a"Khh;MY[K/M(H
2Ff"TWN\(S":r/D"m:A\1g!?qCK=0[d[TA&IEQ--W[`Q!B]Aq"<)aju\n0!!!!j78?7R6=>B
~
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
<C c="0" r="0">
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
<WidgetName name="report8"/>
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
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
<IM>
<![CDATA[!SRc)pk_gB7h#eD$31&+%7s)Y;?-[s6i[2e5R7Po!!&dGdA-aB#GF^W5u`*!jdUV$<DsmX;k
]A?qH:YeE2;XK6P;,Ta.EWl\,_Jp"0mQHe'&eSl"-n^7*[ToF*\$."Me4XmY@8tn>bqZ?]Ad-5
%pY0U,ZgKkin$DaPkMCR2l&X.ah6Zk0lh=\#s42,eeo+V?.k@Zd%C.IFrBP.;5.D>d#-WS<i
+l-rrW&G(%Klb0]AD:hEn.Bm[N!0*p\Y*NT1LoJ!PEcuF+AKYji!Jm%fF#bNLb3!X(^7L'6h3
PT1jBW]A!D=ohpaGJ0T7_L,$'ctG)JKN_Ja]AU@KJ<0np5^tM&ds;\Ns3j\SI%>Js0)RK"]AN6^
0\hV#Its`U&b%WE#3LQ'$(q*mH.J*<'*L6O#8=rALn4;^]AEE*WS\a9Q7O]AO'dWDF#JH86m'b
U?8%sU^rcQs7CFJ,gJG)dNXMkI!:JX&JVE!;UQ\jD,DFVEsZ>7b&l&A/h-n4kc+B7h+&+@6Y
:KCcm#1Fn(Rrs#D@8J';DD.Pt"N"[8l9Sa78<&KG^&R\gn/PABf:dK=,pr.;1QaLh+;2i:A?
f3Fl0gLsF_4b1$n3\eTjiY8N2<YSp0["[OJ6tJ5I0OH_";qk,XdVb=<""7Xi!5=6-057A?-Z
\&oJ:.r@9G3>>'X`&G0n_SjC+*a>pBPiKudgHHO&8VI-LR=,Xqo@W49%V!aCcRcAs4D!C<;s
CgLlbi_H+3qg]Ag,*LjOlK"+Qfi]A\L+l]A04?D*d$$IcUL(<Y5^;?ddcK1g?&W-2k4h?GqGSo@
Vg8(?>J"b.6G;E(LWKdb>uN;\mp>8G,<qKacP8.3_(SR=TMd^/J5!DN#P%&VVo;<j.#WBdB-
qo@Z%O[`:7c8YO6,2m*6ALp[gE!(#fUGQb<,^o$Yi!;f6U$(m=\%?OK8oO.V[(5+JQT_MG'.
IQ4!a=)ij%-.:\+V"Ds3Xm_D[IZWdB#'eRS,rU!l1]AMN/TkE26&[3cY"T@?g_T($E&TbaOp!
fOZkq!8ccI:rMTKK(r817#5qHG>#G4D/?j^N0^BH9Cqn_BkNL&M<(e-;q`T,<$^m1XL@]AtTZ
$+[**(_j'BmhprbZ%Qh0VIZ4B"O3mQi$Zo'SIL"s3ce"Rce'Q?8tR(MH<,VWYL8u9#L_:I\g
$o9eEKIa'!Z8QDF^]A?7%J#/"QJo.\-:*Bbi^/b_$9D;kS]AOO&]A'&$bAGFl@(@j[Wc>`[9Y,D
-+c&j8dDKS9.q?Bsn66B^kGuP]AcnWP%j$[CT,Yjc*Is\9*\(QAC,<IfW+@4KXa+JFu06!DZK
,eH]Aj"]ARRo5DW6&"%.r8@sbN/([C,GS$&YRnITag_GL&Xa1H\aYt'QDK'E`AIC7Yd\l9Q74c
MfO1j0"Ji"#jDmD$(.7(Qi'VpAW#BBB1[EC/6U+:rDK=<KX6!-aa`FEPaZoCJ'>JK:1Qm_h`
AF]AM\4>8Mtgp"(Da&`j,,qq"d>n,qADB^X-408Jd3E+APSPm*&%LA%nN@;+8)Bc+#l($pgE4
3*+F)HdS/.nut.<H@8YZM,C<^t%HP'\IMI]AEf`TN38J7geN?pGdebB^tdOU)Tl(+cWC%-CTB
oStUTZ$Gb2S\R5V`;<lCAK+mW1@L6L3W<mGVh47"AY8Ig'(G309,$N4F-;1%7imeh:&C#^/]A
%L09&-OL$XqmT(jk>_HLa<In5(/Eq8bO<<]A.nt#dLSc*AP>?`1<_G%@nHD=d0cKd=Zha*R6I
@-WE8H)JiLqp8(#JsT_bdjKQV7[MWSe3DZ%/!Li0$B,S5_M/lqqUa>V8)<A^4;g`Wn=.S`Hn
YL"_+(mo"FP%pA^G:ZR+)ab;Y(@<h^81-?'K%'bQ^iTWVJrbiPE14`W^kT8!l`G?RD?&Fk5;
JoT5+7j9@-?t[O,?\Her%`ec'd52LX;A]A0\:@*H)^"bf-nN-U,'QiH&XD3q_c8M3><_\Tl4p
XnThPc_^'YFFt7#fY4C4,^_VS,qJMUgECX3/D\37qPb]AD:Z(A^M\RcS,Gg)p$b61uaOW[/PY
"5^d6djs*dGST@k@,c6\eK]A<h*!QHHjjb7"#J>9e#+=6?9EqSH!k;4kROHofYi2A'AFScLf9
OL!=^aTAu<40!=7+G1ft,H!F4WAi>'9JH*HMk9i,f9bP]AY"(ah)?BG`aN"3>jb=R(J[)soeM
O!KN-9Q(4jM'1#>Eqe8-N(RZ>E.mGk(]Auq1ZHsELp9a:L-&</0Z03?/fG@.<V4p%RQ:>+%RR
!m@"2jrBe1m]An&*?AB6WZeE'42\"J2M<#N@fr49PYkHVGZifgN9%EehT(361ffm'#S*%@-[b
fMXI?SRX<UVZAJb0hRu*+8Ee!D=Mcap_qjjW"<FQpQk7#(e/*kb]AW;9V`8R+75AFMlE!14cS
c!kSLT""*r$pi.&80[u-[M0)U3^_'F*['>_I2m9d6/>]A%':I=KZXqG#JZ5a"Khh;MY[K/M(H
2Ff"TWN\(S":r/D"m:A\1g!?qCK=0[d[TA&IEQ--W[`Q!B]Aq"<)aju\n0!!!!j78?7R6=>B
~
]]></IM>
</Background>
<Alpha alpha="1.0"/>
</Border>
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
<IM>
<![CDATA[!SRc)pk_gB7h#eD$31&+%7s)Y;?-[s6i[2e5R7Po!!&dGdA-aB#GF^W5u`*!jdUV$<DsmX;k
]A?qH:YeE2;XK6P;,Ta.EWl\,_Jp"0mQHe'&eSl"-n^7*[ToF*\$."Me4XmY@8tn>bqZ?]Ad-5
%pY0U,ZgKkin$DaPkMCR2l&X.ah6Zk0lh=\#s42,eeo+V?.k@Zd%C.IFrBP.;5.D>d#-WS<i
+l-rrW&G(%Klb0]AD:hEn.Bm[N!0*p\Y*NT1LoJ!PEcuF+AKYji!Jm%fF#bNLb3!X(^7L'6h3
PT1jBW]A!D=ohpaGJ0T7_L,$'ctG)JKN_Ja]AU@KJ<0np5^tM&ds;\Ns3j\SI%>Js0)RK"]AN6^
0\hV#Its`U&b%WE#3LQ'$(q*mH.J*<'*L6O#8=rALn4;^]AEE*WS\a9Q7O]AO'dWDF#JH86m'b
U?8%sU^rcQs7CFJ,gJG)dNXMkI!:JX&JVE!;UQ\jD,DFVEsZ>7b&l&A/h-n4kc+B7h+&+@6Y
:KCcm#1Fn(Rrs#D@8J';DD.Pt"N"[8l9Sa78<&KG^&R\gn/PABf:dK=,pr.;1QaLh+;2i:A?
f3Fl0gLsF_4b1$n3\eTjiY8N2<YSp0["[OJ6tJ5I0OH_";qk,XdVb=<""7Xi!5=6-057A?-Z
\&oJ:.r@9G3>>'X`&G0n_SjC+*a>pBPiKudgHHO&8VI-LR=,Xqo@W49%V!aCcRcAs4D!C<;s
CgLlbi_H+3qg]Ag,*LjOlK"+Qfi]A\L+l]A04?D*d$$IcUL(<Y5^;?ddcK1g?&W-2k4h?GqGSo@
Vg8(?>J"b.6G;E(LWKdb>uN;\mp>8G,<qKacP8.3_(SR=TMd^/J5!DN#P%&VVo;<j.#WBdB-
qo@Z%O[`:7c8YO6,2m*6ALp[gE!(#fUGQb<,^o$Yi!;f6U$(m=\%?OK8oO.V[(5+JQT_MG'.
IQ4!a=)ij%-.:\+V"Ds3Xm_D[IZWdB#'eRS,rU!l1]AMN/TkE26&[3cY"T@?g_T($E&TbaOp!
fOZkq!8ccI:rMTKK(r817#5qHG>#G4D/?j^N0^BH9Cqn_BkNL&M<(e-;q`T,<$^m1XL@]AtTZ
$+[**(_j'BmhprbZ%Qh0VIZ4B"O3mQi$Zo'SIL"s3ce"Rce'Q?8tR(MH<,VWYL8u9#L_:I\g
$o9eEKIa'!Z8QDF^]A?7%J#/"QJo.\-:*Bbi^/b_$9D;kS]AOO&]A'&$bAGFl@(@j[Wc>`[9Y,D
-+c&j8dDKS9.q?Bsn66B^kGuP]AcnWP%j$[CT,Yjc*Is\9*\(QAC,<IfW+@4KXa+JFu06!DZK
,eH]Aj"]ARRo5DW6&"%.r8@sbN/([C,GS$&YRnITag_GL&Xa1H\aYt'QDK'E`AIC7Yd\l9Q74c
MfO1j0"Ji"#jDmD$(.7(Qi'VpAW#BBB1[EC/6U+:rDK=<KX6!-aa`FEPaZoCJ'>JK:1Qm_h`
AF]AM\4>8Mtgp"(Da&`j,,qq"d>n,qADB^X-408Jd3E+APSPm*&%LA%nN@;+8)Bc+#l($pgE4
3*+F)HdS/.nut.<H@8YZM,C<^t%HP'\IMI]AEf`TN38J7geN?pGdebB^tdOU)Tl(+cWC%-CTB
oStUTZ$Gb2S\R5V`;<lCAK+mW1@L6L3W<mGVh47"AY8Ig'(G309,$N4F-;1%7imeh:&C#^/]A
%L09&-OL$XqmT(jk>_HLa<In5(/Eq8bO<<]A.nt#dLSc*AP>?`1<_G%@nHD=d0cKd=Zha*R6I
@-WE8H)JiLqp8(#JsT_bdjKQV7[MWSe3DZ%/!Li0$B,S5_M/lqqUa>V8)<A^4;g`Wn=.S`Hn
YL"_+(mo"FP%pA^G:ZR+)ab;Y(@<h^81-?'K%'bQ^iTWVJrbiPE14`W^kT8!l`G?RD?&Fk5;
JoT5+7j9@-?t[O,?\Her%`ec'd52LX;A]A0\:@*H)^"bf-nN-U,'QiH&XD3q_c8M3><_\Tl4p
XnThPc_^'YFFt7#fY4C4,^_VS,qJMUgECX3/D\37qPb]AD:Z(A^M\RcS,Gg)p$b61uaOW[/PY
"5^d6djs*dGST@k@,c6\eK]A<h*!QHHjjb7"#J>9e#+=6?9EqSH!k;4kROHofYi2A'AFScLf9
OL!=^aTAu<40!=7+G1ft,H!F4WAi>'9JH*HMk9i,f9bP]AY"(ah)?BG`aN"3>jb=R(J[)soeM
O!KN-9Q(4jM'1#>Eqe8-N(RZ>E.mGk(]Auq1ZHsELp9a:L-&</0Z03?/fG@.<V4p%RQ:>+%RR
!m@"2jrBe1m]An&*?AB6WZeE'42\"J2M<#N@fr49PYkHVGZifgN9%EehT(361ffm'#S*%@-[b
fMXI?SRX<UVZAJb0hRu*+8Ee!D=Mcap_qjjW"<FQpQk7#(e/*kb]AW;9V`8R+75AFMlE!14cS
c!kSLT""*r$pi.&80[u-[M0)U3^_'F*['>_I2m9d6/>]A%':I=KZXqG#JZ5a"Khh;MY[K/M(H
2Ff"TWN\(S":r/D"m:A\1g!?qCK=0[d[TA&IEQ--W[`Q!B]Aq"<)aju\n0!!!!j78?7R6=>B
~
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
<BoundsAttr x="27" y="58" width="27" height="27"/>
</Widget>
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
<Margin top="1" left="1" bottom="1" right="1"/>
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
<![CDATA[lO<9(kN.ld@UNU%p%320@UNU!!bCJ5YQ7<B4nfCN;T7,(0r/:(gT)9A@ff)(0?1?C@X."M+Z
S0&O'?&<ClWTQ%`@.RQIf%/dl!<:Z<:P8/8s11)dctO37"JjqF@l1$jB/<<ekN%g\l$eeP.j
7Il*<Mp3)5PFguDG[]A>nSmOjq,=GFZ\6Iq.+$OdfI9l(;6$Q(6>A2's$825(DEp:S,FS1EF$
%q-[UD<h"T@Nq'j*t<WV^ItMU1e]AEraWDhU)e1Hmf$nimuL.":e^k.jr;&._r(5R?T;cmlB9
=1@'X51FS0]AXkEO<r!!~
]]></IM>
</Background>
<Alpha alpha="1.0"/>
</Border>
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320@UNU!!bCJ5YQ7<B4nfCN;T7,(0r/:(gT)9A@ff)(0?1?C@X."M+Z
S0&O'?&<ClWTQ%`@.RQIf%/dl!<:Z<:P8/8s11)dctO37"JjqF@l1$jB/<<ekN%g\l$eeP.j
7Il*<Mp3)5PFguDG[]A>nSmOjq,=GFZ\6Iq.+$OdfI9l(;6$Q(6>A2's$825(DEp:S,FS1EF$
%q-[UD<h"T@Nq'j*t<WV^ItMU1e]AEraWDhU)e1Hmf$nimuL.":e^k.jr;&._r(5R?T;cmlB9
=1@'X51FS0]AXkEO<r!!~
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
<![CDATA[144000,2781300,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[4320000,12960000,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1" s="0">
<O t="RichText">
<RichText>
<RichChar styleIndex="1">
<text>
<![CDATA[在途资金]]></text>
</RichChar>
<RichChar styleIndex="2">
<text>
<![CDATA[（已售未回款）]]></text>
</RichChar>
<RichChar styleIndex="1">
<text>
<![CDATA[
]]></text>
</RichChar>
<RichChar styleIndex="3">
<text>
<![CDATA[${=round(value("anountinway",1,1),0)}]]></text>
</RichChar>
<RichChar styleIndex="3">
<text>
<![CDATA[亿元]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
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
<Style horizontal_alignment="2" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="104" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="152" foreground="-16712961"/>
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
<BoundsAttr x="643" y="48" width="198" height="48"/>
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
<Margin top="1" left="1" bottom="1" right="1"/>
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
<![CDATA[lO<9(kN.ld@UNU%p%320@UNU!!bCJ5YQ7<B4nfCN;T7,(0r/:(gT)9A@ff)(0?1?C@X."M+Z
S0&O'?&<ClWTQ%`@.RQIf%/dl!<:Z<:P8/8s11)dctO37"JjqF@l1$jB/<<ekN%g\l$eeP.j
7Il*<Mp3)5PFguDG[]A>nSmOjq,=GFZ\6Iq.+$OdfI9l(;6$Q(6>A2's$825(DEp:S,FS1EF$
%q-[UD<h"T@Nq'j*t<WV^ItMU1e]AEraWDhU)e1Hmf$nimuL.":e^k.jr;&._r(5R?T;cmlB9
=1@'X51FS0]AXkEO<r!!~
]]></IM>
</Background>
<Alpha alpha="1.0"/>
</Border>
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320@UNU!!bCJ5YQ7<B4nfCN;T7,(0r/:(gT)9A@ff)(0?1?C@X."M+Z
S0&O'?&<ClWTQ%`@.RQIf%/dl!<:Z<:P8/8s11)dctO37"JjqF@l1$jB/<<ekN%g\l$eeP.j
7Il*<Mp3)5PFguDG[]A>nSmOjq,=GFZ\6Iq.+$OdfI9l(;6$Q(6>A2's$825(DEp:S,FS1EF$
%q-[UD<h"T@Nq'j*t<WV^ItMU1e]AEraWDhU)e1Hmf$nimuL.":e^k.jr;&._r(5R?T;cmlB9
=1@'X51FS0]AXkEO<r!!~
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
<![CDATA[144000,2781300,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[4320000,12960000,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="0">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(len(value("储备房源",1,1))=0,"",round(value("储备房源",1,1),0))]]></Attributes>
</O>
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
<C c="3" r="0">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(len(value("储备房源",2,1))=0,"",round(value("储备房源",2,1),0))]]></Attributes>
</O>
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
<C c="1" r="1" s="0">
<O t="RichText">
<RichText>
<RichChar styleIndex="1">
<text>
<![CDATA[储备房源用地]]></text>
</RichChar>
<RichChar styleIndex="2">
<text>
<![CDATA[（已确权未预售）
]]></text>
</RichChar>
<RichChar styleIndex="3">
<text>
<![CDATA[${=D1}]]></text>
</RichChar>
<RichChar styleIndex="3">
<text>
<![CDATA[亩/]]></text>
</RichChar>
<RichChar styleIndex="3">
<text>
<![CDATA[${=C1}]]></text>
</RichChar>
<RichChar styleIndex="3">
<text>
<![CDATA[万平]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
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
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="104" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="152" foreground="-16712961"/>
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
<BoundsAttr x="225" y="48" width="198" height="48"/>
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
<Margin top="1" left="1" bottom="1" right="1"/>
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
<![CDATA[lO<9(kN.ld@UNU%p%320@UNU!!bCJ5YQ7<B4nfCN;T7,(0r/:(gT)9A@ff)(0?1?C@X."M+Z
S0&O'?&<ClWTQ%`@.RQIf%/dl!<:Z<:P8/8s11)dctO37"JjqF@l1$jB/<<ekN%g\l$eeP.j
7Il*<Mp3)5PFguDG[]A>nSmOjq,=GFZ\6Iq.+$OdfI9l(;6$Q(6>A2's$825(DEp:S,FS1EF$
%q-[UD<h"T@Nq'j*t<WV^ItMU1e]AEraWDhU)e1Hmf$nimuL.":e^k.jr;&._r(5R?T;cmlB9
=1@'X51FS0]AXkEO<r!!~
]]></IM>
</Background>
<Alpha alpha="1.0"/>
</Border>
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320@UNU!!bCJ5YQ7<B4nfCN;T7,(0r/:(gT)9A@ff)(0?1?C@X."M+Z
S0&O'?&<ClWTQ%`@.RQIf%/dl!<:Z<:P8/8s11)dctO37"JjqF@l1$jB/<<ekN%g\l$eeP.j
7Il*<Mp3)5PFguDG[]A>nSmOjq,=GFZ\6Iq.+$OdfI9l(;6$Q(6>A2's$825(DEp:S,FS1EF$
%q-[UD<h"T@Nq'j*t<WV^ItMU1e]AEraWDhU)e1Hmf$nimuL.":e^k.jr;&._r(5R?T;cmlB9
=1@'X51FS0]AXkEO<r!!~
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
<![CDATA[113760,1790700,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[4320000,12960000,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="0">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(len(value("可售房源",2,1))=0,"",round(value("可售房源",2,1),0))]]></Attributes>
</O>
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
<C c="3" r="0">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(len(value("可售房源",1,1))=0,"",round(value("可售房源",1,1),0))]]></Attributes>
</O>
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
<C c="1" r="1" s="0">
<O t="RichText">
<RichText>
<RichChar styleIndex="1">
<text>
<![CDATA[可售房源]]></text>
</RichChar>
<RichChar styleIndex="2">
<text>
<![CDATA[（已取证未售）
]]></text>
</RichChar>
<RichChar styleIndex="3">
<text>
<![CDATA[${=C1}]]></text>
</RichChar>
<RichChar styleIndex="3">
<text>
<![CDATA[万平/]]></text>
</RichChar>
<RichChar styleIndex="3">
<text>
<![CDATA[${=D1}]]></text>
</RichChar>
<RichChar styleIndex="3">
<text>
<![CDATA[亿元]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
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
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="104" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="152" foreground="-16712961"/>
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
<BoundsAttr x="433" y="48" width="198" height="48"/>
</Widget>
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
<Margin top="1" left="1" bottom="1" right="1"/>
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
<![CDATA[lO<9(kN.ld@UNU%p%320@UNU!!bCJ5YQ7<B4nfCN;T7,(0r/:(gT)9A@ff)(0?1?C@X."M+Z
S0&O'?&<ClWTQ%`@.RQIf%/dl!<:Z<:P8/8s11)dctO37"JjqF@l1$jB/<<ekN%g\l$eeP.j
7Il*<Mp3)5PFguDG[]A>nSmOjq,=GFZ\6Iq.+$OdfI9l(;6$Q(6>A2's$825(DEp:S,FS1EF$
%q-[UD<h"T@Nq'j*t<WV^ItMU1e]AEraWDhU)e1Hmf$nimuL.":e^k.jr;&._r(5R?T;cmlB9
=1@'X51FS0]AXkEO<r!!~
]]></IM>
</Background>
<Alpha alpha="1.0"/>
</Border>
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320@UNU!!bCJ5YQ7<B4nfCN;T7,(0r/:(gT)9A@ff)(0?1?C@X."M+Z
S0&O'?&<ClWTQ%`@.RQIf%/dl!<:Z<:P8/8s11)dctO37"JjqF@l1$jB/<<ekN%g\l$eeP.j
7Il*<Mp3)5PFguDG[]A>nSmOjq,=GFZ\6Iq.+$OdfI9l(;6$Q(6>A2's$825(DEp:S,FS1EF$
%q-[UD<h"T@Nq'j*t<WV^ItMU1e]AEraWDhU)e1Hmf$nimuL.":e^k.jr;&._r(5R?T;cmlB9
=1@'X51FS0]AXkEO<r!!~
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
<![CDATA[144000,1790700,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[4320000,12344400,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="0">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=round(value("可用指标批复",1,1),0)]]></Attributes>
</O>
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
<C c="1" r="1" s="0">
<O t="RichText">
<RichText>
<RichChar styleIndex="1">
<text>
<![CDATA[可用指标批复]]></text>
</RichChar>
<RichChar styleIndex="2">
<text>
<![CDATA[（已取指标未确权）
]]></text>
</RichChar>
<RichChar styleIndex="3">
<text>
<![CDATA[${=C1}]]></text>
</RichChar>
<RichChar styleIndex="3">
<text>
<![CDATA[亩]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
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
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="104" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="152" foreground="-16712961"/>
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
<BoundsAttr x="13" y="48" width="198" height="48"/>
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
<![CDATA[2590800,952500,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O>
<![CDATA[操盘纪律]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="0" s="1">
<O t="Image">
<IM>
<![CDATA[!AOW#reXHH7h#eD$31&+%7s)Y;?-[s%KHJ/%L<7=!!"*3/^XOu!;K,R5u`*!IF>_;!C7D(i"
8hs,i[B'W&/8K'%(DM.Sm;^"kC1IMM/3%7D-Yf.,8,raZl;$a(/6@-$/rBB4d29p/<YFR)0o
1@*r)ZQ%.)baTN)]A6ADTI?iW\6Wkf:$@S-fLB[Sk+@FGOKi!^bT,kYQ_k$^;TP`l7fRZNjgb
iN61.FAB;k\Gc!fEupbFgDQ:GgJt1rO#]A\pb'U9c906T3Mj_QRoa;$.oec.8(ju[*HIVG]A8n
1da$oeE#2N'=:7A:Tk\Pf/^la%.$8(bR:_HO9!?>V>D)m(.XSB/k$k;!7V>cAI2Rt,_S%Q\c
^&[D7P-D(>b,PFA!!#SZ:.26O@"J~
]]></IM>
</O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="图表超链-联动单元格1">
<JavaScript class="com.fr.chart.web.ChartHyperRelateCellLink">
<JavaScript class="com.fr.chart.web.ChartHyperRelateCellLink">
<Parameters/>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features width="500" height="270"/>
<realateName realateValue="A1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<CellGUIAttr>
<ToolTipText>
<![CDATA[=c1+c2+c3]]></ToolTipText>
</CellGUIAttr>
<CellPageAttr/>
<Expand/>
</C>
<C c="2" r="0">
<O>
<![CDATA[一、统计范围：当年新开盘项目，如果分批次开盘，取首批时间； \\n]]></O>
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
<C c="2" r="1">
<O>
<![CDATA[二、达标规则：2（规划要点-摘牌），3（摘牌-示范区开放），5（摘牌-开盘），10（摘牌-现金流回正），同时满足； \\n]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="2">
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
<C c="2" r="2">
<O>
<![CDATA[三、一区一策：发布过一区一策操盘纪律的区域按照签批时间统计，未发布的全部按照23510统计。 \\n]]></O>
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
<Style horizontal_alignment="2" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="96" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72" foreground="-16776961" underline="1"/>
<Background name="NullBackground"/>
<Border/>
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
<WidgetName name="report3"/>
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
<BoundsAttr x="10" y="126" width="100" height="27"/>
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
<![CDATA[8153400,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O>
<![CDATA[盘点信息]]></O>
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
<Style horizontal_alignment="2" imageLayout="1">
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
<![CDATA[8153400,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O>
<![CDATA[盘点信息]]></O>
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
<Style horizontal_alignment="2" imageLayout="1">
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
<BoundsAttr x="10" y="27" width="208" height="20"/>
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
<![CDATA[723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
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
<WidgetName name="report2"/>
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
<BoundsAttr x="9" y="122" width="504" height="348"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<Listener event="click">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[null]]></Content>
</JavaScript>
</Listener>
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
<Margin top="1" left="1" bottom="1" right="1"/>
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
<![CDATA[723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
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
<WidgetName name="report4"/>
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
<BoundsAttr x="9" y="23" width="838" height="90"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="label0"/>
<Widget widgetName="report4"/>
<Widget widgetName="report11"/>
<Widget widgetName="report3"/>
<Widget widgetName="report7"/>
<Widget widgetName="report7_c"/>
<Widget widgetName="report7_c_c_c_c"/>
<Widget widgetName="report7_c_c"/>
<Widget widgetName="report8"/>
<Widget widgetName="report8_c_c"/>
<Widget widgetName="report8_c"/>
<Widget widgetName="report8_c_c_c"/>
<Widget widgetName="report2"/>
<Widget widgetName="report1"/>
<Widget widgetName="report3_c"/>
<Widget widgetName="report11_c_c"/>
<Widget widgetName="report5"/>
<Widget widgetName="report11_c_c_c"/>
<Widget widgetName="report9"/>
<Widget widgetName="report6"/>
<Widget widgetName="report6_c"/>
<Widget widgetName="report14"/>
<Widget widgetName="report13_c"/>
<Widget widgetName="report10"/>
<Widget widgetName="report12"/>
<Widget widgetName="report15"/>
<Widget widgetName="report0"/>
<Widget widgetName="report5_c_c"/>
<Widget widgetName="report11_c_c_c_c"/>
<Widget widgetName="report8_c_c_c_c_c"/>
<Widget widgetName="report9_c_c_c"/>
<Widget widgetName="report10_c_c_c"/>
<Widget widgetName="report11_c_c_c_c_c"/>
<Widget widgetName="report12_c_c_c"/>
<Widget widgetName="report13_c_c_c"/>
<Widget widgetName="report13_c_c_c_c_c_c_c"/>
<Widget widgetName="report6_c_c"/>
<Widget widgetName="report13"/>
<Widget widgetName="report9_c_c_c_c"/>
<Widget widgetName="report10_c"/>
</MobileWidgetList>
<WidgetScalingAttr compState="0"/>
<DesignResolution absoluteResolutionScaleW="1366" absoluteResolutionScaleH="768"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="958" height="538"/>
</Widget>
<Sorted sorted="true"/>
<MobileWidgetList>
<Widget widgetName="absolute0"/>
</MobileWidgetList>
<WidgetZoomAttr compState="0"/>
<AppRelayout appRelayout="true"/>
<Size width="958" height="538"/>
<ResolutionScalingAttr percent="0.9"/>
<BodyLayoutType type="0"/>
</Center>
</Layout>
<DesignerVersion DesignerVersion="JAA"/>
<PreviewType PreviewType="0"/>
<TemplateID TemplateID="79e6432b-dc18-42de-b84e-1df2e0b27eb2"/>
<TemplateIdAttMark class="com.fr.base.iofileattr.TemplateIdAttrMark">
<TemplateIdAttMark TemplateId="ce186f26-80b3-4904-a4ea-5b62a750393b"/>
</TemplateIdAttMark>
</Form>
