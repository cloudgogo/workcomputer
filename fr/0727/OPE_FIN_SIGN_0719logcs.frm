<?xml version="1.0" encoding="UTF-8"?>
<Form xmlVersion="20170720" releaseVersion="9.0.0">
<TableDataMap>
<TableData name="sign_link" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="project"/>
<O>
<![CDATA[股份公司]]></O>
</Parameter>
<Parameter>
<Attributes name="yearmonth"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=sql("oracle_test","select  max( DATA_DATE) from  dm_mcl_acct",1,1)]]></Attributes>
</O>
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
<![CDATA[${if(project='其他',"
WITH DIM_DATEKJ AS
 (SELECT CASE
           WHEN '"+periodtype+"'  = '当年' THEN
            PERIOD_YEAR
           WHEN '"+periodtype+"'  = '当季' THEN
            PERIOD_QUARTER
           WHEN '"+periodtype+"'  = '当月' THEN
            PERIOD_MONTH
         END AS CALIBER --找到我当前时间参数口径（当年、当季、当月）
    FROM DIM_PERIOD --时间维度
   WHERE PERIOD_KEY = to_char(to_date('"+yearmonth+"','YYYYMMDD'), 'yyyyMMdd')), --当前时间口径 年、季度、月份

DIM_DATEMX AS
 (SELECT DISTINCT CASE
                    WHEN '"+periodtype+"'  = '当年' THEN
                     PERIOD_YEAR
                    WHEN '"+periodtype+"'  = '当季' THEN
                     PERIOD_QUARTER
                    WHEN '"+periodtype+"'  = '当月' THEN
                     PERIOD_MONTH
                  END AS DIM_CALIBER, --口径
                  CASE
                    WHEN '"+periodtype+"'  = '当年' THEN
                     PERIOD_QUARTER
                    WHEN '"+periodtype+"'  = '当季' THEN
                     PERIOD_MONTH
                    WHEN '"+periodtype+"'  = '当月' THEN
                     WEEK_NBR_IN_MONTH
                  END AS DIM_CALIBER_S --口径2
    FROM DIM_PERIOD --时间维度
  ), --时间口径维度
DIM_DATES AS
 (/*SELECT CALIBER,
         CASE
           WHEN '"+periodtype+"'  = '当年' THEN
            substr(CALIBER, 1, 4)
           WHEN '"+periodtype+"'  = '当季' THEN
            substr(to_char(to_date('"+yearmonth+"','YYYYMMDD'), 'yyyyMMdd'), 1, 4) || 'Q0' ||
            substr(CALIBER, 1, 1)
           WHEN '"+periodtype+"'  = '当月' THEN
            substr(to_char(to_date('"+yearmonth+"','YYYYMMDD'), 'yyyyMMdd'), 1, 4) || 'M' ||
            substr(CALIBER, 1, 2)
         END as Statistical_time,
         1 ordernum
    FROM DIM_DATEKJ
  UNION ALL*/
  SELECT b.DIM_CALIBER_S as CALIBER,
         CASE
           WHEN '"+periodtype+"'  = '当年' THEN
            substr(to_char(to_date('"+yearmonth+"','YYYYMMDD'), 'yyyyMMdd'), 1, 4) || 'Q0' ||
            substr(b.DIM_CALIBER_S, 1, 1)
           WHEN '"+periodtype+"'  = '当季' THEN
            substr(to_char(to_date('"+yearmonth+"','YYYYMMDD'), 'yyyyMMdd'), 1, 4) || 'M' ||
            substr(b.DIM_CALIBER_S, 1, 2)
           WHEN '"+periodtype+"'  = '当月' THEN
            substr(to_char(to_date('"+yearmonth+"','YYYYMMDD'), 'yyyyMMdd'), 1, 4) || 'M' ||
            substr(to_char(to_date('"+yearmonth+"','YYYYMMDD'), 'yyyyMMdd'), 5, 2) || 'W' ||
            substr(b.DIM_CALIBER_S, 2, 1)
         END as Statistical_time,
         
         case when substr(b.DIM_CALIBER_S,2,1)='季' then cast (substr(b.DIM_CALIBER_S,1,1) as number)+1 
           when substr(b.DIM_CALIBER_S,3,1)='月' then cast (substr(b.DIM_CALIBER_S,1,2) as number)+1 
           when substr(b.DIM_CALIBER_S,3,1)='周' then cast (substr(b.DIM_CALIBER_S,2,1) as number)+1 
         end ordernum
    FROM DIM_DATEKJ a
    LEFT JOIN DIM_DATEMX b
      ON a.CALIBER = b.DIM_CALIBER) --整理时间维度
 ,W1 AS (
SELECT 
ACC.PERIOD_TYPE_ID,
sum(TARGET_VALUE ) as TARGET_VALUE ,
round(sum(ACTUAL_VALUE), 1)  as  ACTUAL_VALUE
FROM  DM_MCL_ACCT ACC 
INNER JOIN DIM_ORG ORG ON ACC.ORG_ID=ORG.ORG_ID AND ORG.ORG_CLASSIFY_ID='其他'
WHERE  ACC.INDEX_ID='054878caa2b9466b853cab410f59437a'
group by ACC.PERIOD_TYPE_ID
)

 SELECT 
 T1.CALIBER,
 T1.ORDERNUM,
 T1.STATISTICAL_TIME,
 nvl(W1.TARGET_VALUE,0) TARGET_VALUE ,
 round(nvl( W1.ACTUAL_VALUE,0), 1) ACTUAL_VALUE,
case when nvl(W1.TARGET_VALUE,0)=0 then 0 
when nvl( W1.ACTUAL_VALUE,0)/ nvl(W1.TARGET_VALUE,0)<0.005
then 0
else nvl( W1.ACTUAL_VALUE,0)/ nvl(W1.TARGET_VALUE,0) end rate
 FROM DIM_DATES T1
 LEFT JOIN W1 ON T1.STATISTICAL_TIME = W1.PERIOD_TYPE_ID
 order by ORDERNUM
","
WITH DIM_DATEKJ AS
 (SELECT CASE
           WHEN '"+periodtype+"'  = '当年' THEN
            PERIOD_YEAR
           WHEN '"+periodtype+"'  = '当季' THEN
            PERIOD_QUARTER
           WHEN '"+periodtype+"'  = '当月' THEN
            PERIOD_MONTH
         END AS CALIBER --找到我当前时间参数口径（当年、当季、当月）
    FROM DIM_PERIOD --时间维度
   WHERE PERIOD_KEY = to_char(to_date('"+yearmonth+"','YYYYMMDD'), 'yyyyMMdd')), --当前时间口径 年、季度、月份

DIM_DATEMX AS
 (SELECT DISTINCT CASE
                    WHEN '"+periodtype+"'  = '当年' THEN
                     PERIOD_YEAR
                    WHEN '"+periodtype+"'  = '当季' THEN
                     PERIOD_QUARTER
                    WHEN '"+periodtype+"'  = '当月' THEN
                     PERIOD_MONTH
                  END AS DIM_CALIBER, --口径
                  CASE
                    WHEN '"+periodtype+"'  = '当年' THEN
                     PERIOD_QUARTER
                    WHEN '"+periodtype+"'  = '当季' THEN
                     PERIOD_MONTH
                    WHEN '"+periodtype+"'  = '当月' THEN
                     WEEK_NBR_IN_MONTH
                  END AS DIM_CALIBER_S --口径2
    FROM DIM_PERIOD --时间维度
  ), --时间口径维度
DIM_DATES AS
 (/*SELECT CALIBER,
         CASE
           WHEN '"+periodtype+"'  = '当年' THEN
            substr(CALIBER, 1, 4)
           WHEN '"+periodtype+"'  = '当季' THEN
            substr(to_char(to_date('"+yearmonth+"','YYYYMMDD'), 'yyyyMMdd'), 1, 4) || 'Q0' ||
            substr(CALIBER, 1, 1)
           WHEN '"+periodtype+"'  = '当月' THEN
            substr(to_char(to_date('"+yearmonth+"','YYYYMMDD'), 'yyyyMMdd'), 1, 4) || 'M' ||
            substr(CALIBER, 1, 2)
         END as Statistical_time,
         1 ordernum
    FROM DIM_DATEKJ
  UNION ALL*/
  SELECT b.DIM_CALIBER_S as CALIBER,
         CASE
           WHEN '"+periodtype+"'  = '当年' THEN
            substr(to_char(to_date('"+yearmonth+"','YYYYMMDD'), 'yyyyMMdd'), 1, 4) || 'Q0' ||
            substr(b.DIM_CALIBER_S, 1, 1)
           WHEN '"+periodtype+"'  = '当季' THEN
            substr(to_char(to_date('"+yearmonth+"','YYYYMMDD'), 'yyyyMMdd'), 1, 4) || 'M' ||
            substr(b.DIM_CALIBER_S, 1, 2)
           WHEN '"+periodtype+"'  = '当月' THEN
            substr(to_char(to_date('"+yearmonth+"','YYYYMMDD'), 'yyyyMMdd'), 1, 4) || 'M' ||
            substr(to_char(to_date('"+yearmonth+"','YYYYMMDD'), 'yyyyMMdd'), 5, 2) || 'W' ||
            substr(b.DIM_CALIBER_S, 2, 1)
         END as Statistical_time,
         
         case when substr(b.DIM_CALIBER_S,2,1)='季' then cast (substr(b.DIM_CALIBER_S,1,1) as number)+1 
           when substr(b.DIM_CALIBER_S,3,1)='月' then cast (substr(b.DIM_CALIBER_S,1,2) as number)+1 
           when substr(b.DIM_CALIBER_S,3,1)='周' then cast (substr(b.DIM_CALIBER_S,2,1) as number)+1 
         end ordernum
    FROM DIM_DATEKJ a
    LEFT JOIN DIM_DATEMX b
      ON a.CALIBER = b.DIM_CALIBER) --整理时间维度

--new

select nvl(result.target_value,0) target_value,
               round(nvl(result.actual_value,0), 1) actual_value,
             nvl(result.forecate_value,0) forecate_value,
              nvl(result.last_actual_value,0) last_actual_value,
               nvl(result.last_rate_value,0) last_rate_value,
               case when result.rate<0.005 then 0 else
             nvl(result.rate,0)  end rate,
               d.*
  from (select nvl(acc.target_value,0) target_value,
               nvl(acc.actual_value,0) actual_value,
               nvl(acc.forecate_value,0) forecate_value,
               nvl(acc.last_actual_value,0) last_actual_value,
               nvl(acc.last_rate_value,0) last_rate_value,
                decode(nvl(acc.target_value, 0),0,0, nvl(acc.actual_value, 0)/nvl(acc.target_value, 0)) rate,
               case org.org_id
                 when '54720271-A741-423A-BE20-E593A168EC88' then  --孔雀城住宅
                  '住宅'
                 when 'E0A3D386-D5C8-FB22-18DE-4424D49363B1' then  --华夏幸福
                  '股份公司'
                 when 'E0A3D386-D5C8-FB22-18DE-4424D49363B2' then  --产业新城
                  '新城全口径'
                 when '170D757F-2757-43FF-831A-89F2A44BA854' then   --产业小镇
                  '小镇'
                 when 'E0A3D386-D5C8-FB22-18DE-4424D49363B4' then  --物业
                  '其他'
               end org_id,
               acc.period_type_id
          from dm_mcl_acct acc, dim_org org, dim_index ind
         where acc.org_id = org.org_id
           and acc.index_id = ind.index_id
           and ind.index_id = '054878caa2b9466b853cab410f59437a' -- 签约
           and org.org_id in
               ('E0A3D386-D5C8-FB22-18DE-4424D49363B1', 'E0A3D386-D5C8-FB22-18DE-4424D49363B2', '170D757F-2757-43FF-831A-89F2A44BA854', '54720271-A741-423A-BE20-E593A168EC88', 'E0A3D386-D5C8-FB22-18DE-4424D49363B4')
        union all
        select nvl(acc.target_value,0) target_value,
               nvl(acc.actual_value,0) actual_value,
              nvl(acc.forecate_value,0) forecate_value,
              nvl(acc.last_actual_value,0) last_actual_value,
               nvl(acc.last_rate_value,0) last_rate_value,
               case when nvl(acc.target_value, 0)=0 then 0
               when nvl(acc.actual_value, 0)/nvl(acc.target_value, 0)<0.005
               then 0
               else
               nvl(acc.actual_value, 0)/nvl(acc.target_value, 0) end  rate,
               '新城' org_id,
               acc.period_type_id
          from dm_mcl_acct acc, dim_org org, dim_index ind
         where acc.org_id = org.org_id
           and acc.index_id = ind.index_id
           and ind.index_id =
               (select index_id
                  from (select *
                          from dim_index i
                         start with i.index_id = '054878caa2b9466b853cab410f59437a' --签约
                        connect by prior i.index_id = i.father_id) i
                 where i.index_id in ('3e927b5caa3a4d38b51a2bae096d73d3','8af4664d0837409a9b63736bb1630c9e','1902a5e1a5de463f92171a2734c7f9a8'))
           and org.org_id = 'E0A3D386-D5C8-FB22-18DE-4424D49363B2') result
 right join DIM_DATES d
    on result.period_type_id in (d.Statistical_time)
    and result.org_id='"+project+"' 
 
order by d.ordernum
")}

]]></Query>
</TableData>
<TableData name="sign_com" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="datatime"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=sql("oracle_test","select  max( DATA_DATE) from  dm_mcl_acct",1,1)]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="project"/>
<O>
<![CDATA[股份公司]]></O>
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
<![CDATA[${if(project='其他'," select 
'当年' as data_type,
'签约' as index_name,
sum(target_value)  as target_value ,sum(actual_value) as actual_value ,sum(forecate_value) as forecate_value,
sum(last_actual_value) as last_actual_value, case when sum(last_actual_value)=0 then 0 else (sum(actual_value)-sum(last_actual_value))/sum(last_actual_value) end  last_rate_value
from dm_mcl_acct acc inner join dim_org org
on
acc.org_id=org.org_id
and org.org_classify_id='其他'
where period_type_id=case '"+periodtype+"'  when '当年' 
then substr('"+datatime+"', 1, 4) when '当季' then 
  substr('"+datatime+"', 1, 4)||'Q0'||to_char(to_date('"+datatime+"','YYYYMMDD'),'Q') 
  when '当月' then substr('"+datatime+"', 1, 4)||'M'||to_char(to_date('"+datatime+"','YYYYMMDD'),'MM')  end
and acc.index_id='054878caa2b9466b853cab410f59437a' ","

select date_type,org_name,index_name,target_value,actual_value,forecate_value,last_rate_value
from
(select '当年' date_type,'股份公司' org_name,b.index_name,a.target_value,a.actual_value,a.forecate_value,a.last_rate_value
from dm_mcl_acct a inner join dim_index b on a.index_id=b.index_id inner join dim_org c on a.org_id=c.org_id
where period_type_id=substr('"+datatime+"',1,4) and a.org_id in ('E0A3D386-D5C8-FB22-18DE-4424D49363B1') and a.index_id in ('054878caa2b9466b853cab410f59437a')
union all
select '当年' date_type,'股份公司' org_name,b.index_name,a.target_value,a.actual_value,a.forecate_value,a.last_rate_value
from dm_mcl_acct a inner join dim_index b on a.index_id=b.index_id
where period_type_id=substr('"+datatime+"',1,4) and a.org_id in ('E0A3D386-D5C8-FB22-18DE-4424D49363B2') and a.index_id in ('3e927b5caa3a4d38b51a2bae096d73d3')
union ALL
select '当年' date_type,'股份公司' org_name,'孔雀城' index_name,a.target_value,a.actual_value,a.forecate_value,a.last_rate_value
from dm_mcl_acct a inner join dim_index b on a.index_id=b.index_id
where period_type_id=substr('"+datatime+"',1,4) and a.org_id in ('54720271-A741-423A-BE20-E593A168EC88') and a.index_id in ('054878caa2b9466b853cab410f59437a')
union all
select '当年' date_type,case when a.org_id='E0A3D386-D5C8-FB22-18DE-4424D49363B2' then '新城全口径' when a.org_id='170D757F-2757-43FF-831A-89F2A44BA854' then '小镇' else '其他' end org_name,b.index_name,a.target_value,a.actual_value,a.forecate_value,a.last_rate_value
from dm_mcl_acct a inner join dim_index b on a.index_id=b.index_id 
where period_type_id=substr('"+datatime+"',1,4) and a.org_id in ('E0A3D386-D5C8-FB22-18DE-4424D49363B2','170D757F-2757-43FF-831A-89F2A44BA854','E0A3D386-D5C8-FB22-18DE-4424D49363B4') 
and a.index_id in ('054878caa2b9466b853cab410f59437a','3e927b5caa3a4d38b51a2bae096d73d3',
'950a32bd2049444692f2db5d7ddbfafc')
union all
select '当年' date_type,'新城' org_name,'签约' index_name,a.target_value,a.actual_value,a.forecate_value,a.last_rate_value
from dm_mcl_acct a inner join dim_index b on a.index_id=b.index_id 
where period_type_id=substr('"+datatime+"',1,4) and a.org_id in ('E0A3D386-D5C8-FB22-18DE-4424D49363B2') 
and a.index_id in ('3e927b5caa3a4d38b51a2bae096d73d3')
union all
select '当年' date_type,'住宅' org_name,b.index_name,a.target_value,a.actual_value,a.forecate_value,a.last_rate_value
from dm_mcl_acct a inner join dim_index b on a.index_id=b.index_id inner join dim_org c on a.org_id=c.org_id
where period_type_id=substr('"+datatime+"',1,4) and a.org_id in ('54720271-A741-423A-BE20-E593A168EC88') and a.index_id in ('054878caa2b9466b853cab410f59437a')
union all
select '当季' date_type,'股份公司' org_name,b.index_name,a.target_value,a.actual_value,a.forecate_value,a.last_rate_value
from dm_mcl_acct a inner join dim_index b on a.index_id=b.index_id inner join dim_org c on a.org_id=c.org_id
where period_type_id=substr('"+datatime+"',1,4)||'Q0'||to_char(to_date('"+datatime+"','yyyymmdd'),'q') and a.org_id in ('E0A3D386-D5C8-FB22-18DE-4424D49363B1') and a.index_id in ('054878caa2b9466b853cab410f59437a')
union all
select '当季' date_type,'股份公司' org_name,b.index_name,a.target_value,a.actual_value,a.forecate_value,a.last_rate_value
from dm_mcl_acct a inner join dim_index b on a.index_id=b.index_id
where period_type_id=substr('"+datatime+"',1,4)||'Q0'||to_char(to_date('"+datatime+"','yyyymmdd'),'q') and a.org_id in ('E0A3D386-D5C8-FB22-18DE-4424D49363B2') and a.index_id in ('3e927b5caa3a4d38b51a2bae096d73d3')
union all
select '当季' date_type,'股份公司' org_name,'孔雀城' index_name,a.target_value,a.actual_value,a.forecate_value,a.last_rate_value
from dm_mcl_acct a inner join dim_index b on a.index_id=b.index_id
where period_type_id=substr('"+datatime+"',1,4)||'Q0'||to_char(to_date('"+datatime+"','yyyymmdd'),'q') and a.org_id in ('54720271-A741-423A-BE20-E593A168EC88') and a.index_id in ('054878caa2b9466b853cab410f59437a')
union all
select '当季' date_type,case when a.org_id='E0A3D386-D5C8-FB22-18DE-4424D49363B2' then '新城全口径' when a.org_id='170D757F-2757-43FF-831A-89F2A44BA854' then '小镇' else '其他' end org_name,b.index_name,a.target_value,a.actual_value,a.forecate_value,a.last_rate_value
from dm_mcl_acct a inner join dim_index b on a.index_id=b.index_id 
where period_type_id=substr('"+datatime+"',1,4)||'Q0'||to_char(to_date('"+datatime+"','yyyymmdd'),'q') and a.org_id in ('E0A3D386-D5C8-FB22-18DE-4424D49363B2','170D757F-2757-43FF-831A-89F2A44BA854','E0A3D386-D5C8-FB22-18DE-4424D49363B4') 
and a.index_id in ('054878caa2b9466b853cab410f59437a','3e927b5caa3a4d38b51a2bae096d73d3',
'950a32bd2049444692f2db5d7ddbfafc')
union all
select '当季' date_type,'新城' org_name,'签约' index_name,a.target_value,a.actual_value,a.forecate_value,a.last_rate_value
from dm_mcl_acct a inner join dim_index b on a.index_id=b.index_id 
where period_type_id=substr('"+datatime+"',1,4)||'Q0'||to_char(to_date('"+datatime+"','yyyymmdd'),'q') and a.org_id in ('E0A3D386-D5C8-FB22-18DE-4424D49363B2') 
and a.index_id in ('3e927b5caa3a4d38b51a2bae096d73d3')
union all
select '当季' date_type,'住宅' org_name,b.index_name,a.target_value,a.actual_value,a.forecate_value,a.last_rate_value
from dm_mcl_acct a inner join dim_index b on a.index_id=b.index_id inner join dim_org c on a.org_id=c.org_id
where period_type_id=substr('"+datatime+"',1,4)||'Q0'||to_char(to_date('"+datatime+"','yyyymmdd'),'q') and a.org_id in ('54720271-A741-423A-BE20-E593A168EC88') and a.index_id in ('054878caa2b9466b853cab410f59437a')
union all
select '当月' date_type,'股份公司' org_name,b.index_name,a.target_value,a.actual_value,a.forecate_value,a.last_rate_value
from dm_mcl_acct a inner join dim_index b on a.index_id=b.index_id inner join dim_org c on a.org_id=c.org_id
where period_type_id=substr('"+datatime+"',1,4)||'M'||substr('"+datatime+"',5,2) and a.org_id in ('E0A3D386-D5C8-FB22-18DE-4424D49363B1') and a.index_id in ('054878caa2b9466b853cab410f59437a')
union all
select '当月' date_type,'股份公司' org_name,b.index_name,a.target_value,a.actual_value,a.forecate_value,a.last_rate_value
from dm_mcl_acct a inner join dim_index b on a.index_id=b.index_id
where period_type_id=substr('"+datatime+"',1,4)||'M'||substr('"+datatime+"',5,2) and a.org_id in ('E0A3D386-D5C8-FB22-18DE-4424D49363B2') and a.index_id in ('3e927b5caa3a4d38b51a2bae096d73d3')
union all
select '当月' date_type,'股份公司' org_name,'孔雀城' index_name,a.target_value,a.actual_value,a.forecate_value,a.last_rate_value
from dm_mcl_acct a inner join dim_index b on a.index_id=b.index_id
where period_type_id=substr('"+datatime+"',1,4)||'M'||substr('"+datatime+"',5,2) and a.org_id in ('54720271-A741-423A-BE20-E593A168EC88') and a.index_id in ('054878caa2b9466b853cab410f59437a')
union all
select '当月' date_type,case when a.org_id='E0A3D386-D5C8-FB22-18DE-4424D49363B2' then '新城全口径' when a.org_id='170D757F-2757-43FF-831A-89F2A44BA854' then '小镇' else '其他' end org_name,b.index_name,a.target_value,a.actual_value,a.forecate_value,a.last_rate_value
from dm_mcl_acct a inner join dim_index b on a.index_id=b.index_id 
where period_type_id=substr('"+datatime+"',1,4)||'M'||substr('"+datatime+"',5,2) and a.org_id in ('E0A3D386-D5C8-FB22-18DE-4424D49363B2','170D757F-2757-43FF-831A-89F2A44BA854','E0A3D386-D5C8-FB22-18DE-4424D49363B4') 
and a.index_id in ('054878caa2b9466b853cab410f59437a','3e927b5caa3a4d38b51a2bae096d73d3',
'950a32bd2049444692f2db5d7ddbfafc')
union all
select '当月' date_type,'新城' org_name,'签约' index_name,a.target_value,a.actual_value,a.forecate_value,a.last_rate_value
from dm_mcl_acct a inner join dim_index b on a.index_id=b.index_id 
where period_type_id=substr('"+datatime+"',1,4)||'M'||substr('"+datatime+"',5,2) and a.org_id in ('E0A3D386-D5C8-FB22-18DE-4424D49363B2') 
and a.index_id in ('3e927b5caa3a4d38b51a2bae096d73d3')
union all
select '当月' date_type,'住宅' org_name,b.index_name,a.target_value,a.actual_value,a.forecate_value,a.last_rate_value
from dm_mcl_acct a inner join dim_index b on a.index_id=b.index_id inner join dim_org c on a.org_id=c.org_id
where period_type_id=substr('"+datatime+"',1,4)||'M'||substr('"+datatime+"',5,2) and a.org_id in ('54720271-A741-423A-BE20-E593A168EC88') and a.index_id in ('054878caa2b9466b853cab410f59437a')
) a where date_type='"+periodtype+"' and org_name='"+project+"'

")}
]]></Query>
</TableData>
<TableData name="sign_JDYG" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="project"/>
<O>
<![CDATA[股份公司]]></O>
</Parameter>
<Parameter>
<Attributes name="yearmonth"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=sql("oracle_test","select  max( DATA_DATE) from  dm_mcl_acct",1,1)]]></Attributes>
</O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[oracle_test]]></DatabaseName>
</Connection>
<Query>
<![CDATA[   ${if( project='其他'," select '目标' type1,
 round(sum(nvl(target_value, 0)), 1) as value1 
from dm_mcl_acct acc inner join dim_org org
on
acc.org_id=org.org_id
and org.org_classify_id='其他'
where period_type_id=
  substr('"+yearmonth+"', 1, 4)||'Q0'||to_char(to_date('"+yearmonth+"','YYYYMMDD'),'Q') 
and acc.index_id='054878caa2b9466b853cab410f59437a' 
union all
select '实际' type1,

 round(sum(actual_value), 1)  as value1 
from dm_mcl_acct acc inner join dim_org org
on
acc.org_id=org.org_id
and org.org_classify_id='其他'
where period_type_id=
  substr('"+yearmonth+"', 1, 4)||'Q0'||to_char(to_date('"+yearmonth+"','YYYYMMDD'),'Q') 
and acc.index_id='054878caa2b9466b853cab410f59437a'
union all
select 
'预估完成' type1,
case when sum(nvl(FORECATE_VALUE, 0))=0 
     then  round(sum(nvl(TARGET_VALUE, 0)), 1)      
     else round(sum(nvl(FORECATE_VALUE, 0)), 1) END as VALUE1
from dm_mcl_acct acc inner join dim_org org
on
acc.org_id=org.org_id
and org.org_classify_id='其他'
where period_type_id=
  substr('"+yearmonth+"', 1, 4)||'Q0'||to_char(to_date('"+yearmonth+"','YYYYMMDD'),'Q') 
and acc.index_id='054878caa2b9466b853cab410f59437a'

","    
  select *
  from (select '目标' type1,
                round(acc.target_value, 1) value1,
               
               case org.org_id
                  when '54720271-A741-423A-BE20-E593A168EC88' then  --孔雀城住宅
                  '住宅'
                 when 'E0A3D386-D5C8-FB22-18DE-4424D49363B1' then  --华夏幸福
                  '股份公司'
                 when 'E0A3D386-D5C8-FB22-18DE-4424D49363B2' then  --产业新城
                  '新城全口径'
                 when '170D757F-2757-43FF-831A-89F2A44BA854' then   --产业小镇
                  '小镇'
                 when 'E0A3D386-D5C8-FB22-18DE-4424D49363B4' then  --物业
                  '其他'
               end org_id,
               acc.period_type_id
          from dm_mcl_acct acc, dim_org org, dim_index ind
         where acc.org_id = org.org_id
           and acc.index_id = ind.index_id
           and ind.index_id = '054878caa2b9466b853cab410f59437a' -- pram1
           and org.org_id in
               ('E0A3D386-D5C8-FB22-18DE-4424D49363B1', 'E0A3D386-D5C8-FB22-18DE-4424D49363B2', 
			   '170D757F-2757-43FF-831A-89F2A44BA854', '54720271-A741-423A-BE20-E593A168EC88', 
			   'E0A3D386-D5C8-FB22-18DE-4424D49363B4')
        union all
        select '实际' type1,
                round(acc.actual_value, 1) value1,
               case org.org_id
                when '54720271-A741-423A-BE20-E593A168EC88' then  --孔雀城住宅
                  '住宅'
                 when 'E0A3D386-D5C8-FB22-18DE-4424D49363B1' then  --华夏幸福
                  '股份公司'
                 when 'E0A3D386-D5C8-FB22-18DE-4424D49363B2' then  --产业新城
                  '新城全口径'
                 when '170D757F-2757-43FF-831A-89F2A44BA854' then   --产业小镇
                  '小镇'
                 when 'E0A3D386-D5C8-FB22-18DE-4424D49363B4' then  --物业
                  '其他'
               end org_id,
               acc.period_type_id
          from dm_mcl_acct acc, dim_org org, dim_index ind
         where acc.org_id = org.org_id
           and acc.index_id = ind.index_id
           and ind.index_id = '054878caa2b9466b853cab410f59437a' -- pram1
           and org.org_id in
                ('E0A3D386-D5C8-FB22-18DE-4424D49363B1', 'E0A3D386-D5C8-FB22-18DE-4424D49363B2', 
			   '170D757F-2757-43FF-831A-89F2A44BA854', '54720271-A741-423A-BE20-E593A168EC88', 
			   'E0A3D386-D5C8-FB22-18DE-4424D49363B4')
        
        union all
        select '预估完成' type1,
               case
                 when nvl(acc.forecate_value, 0) = 0 then
                   round(nvl(acc.target_value, 0), 1)
                 else
                  round(acc.forecate_value, 1)
               end as value1,
               
               case org.org_id
                 when '54720271-A741-423A-BE20-E593A168EC88' then  --孔雀城住宅
                  '住宅'
                 when 'E0A3D386-D5C8-FB22-18DE-4424D49363B1' then  --华夏幸福
                  '股份公司'
                 when 'E0A3D386-D5C8-FB22-18DE-4424D49363B2' then  --产业新城
                  '新城全口径'
                 when '170D757F-2757-43FF-831A-89F2A44BA854' then   --产业小镇
                  '小镇'
                 when 'E0A3D386-D5C8-FB22-18DE-4424D49363B4' then  --物业
                  '其他'
               end org_id,
               acc.period_type_id
          from dm_mcl_acct acc, dim_org org, dim_index ind
         where acc.org_id = org.org_id
           and acc.index_id = ind.index_id
           and ind.index_id = '054878caa2b9466b853cab410f59437a' -- pram1
           and org.org_id in
               ('E0A3D386-D5C8-FB22-18DE-4424D49363B1', 'E0A3D386-D5C8-FB22-18DE-4424D49363B2', 
			   '170D757F-2757-43FF-831A-89F2A44BA854', '54720271-A741-423A-BE20-E593A168EC88', 
			   'E0A3D386-D5C8-FB22-18DE-4424D49363B4')
        
        union all
        select '目标' type1,
              round(acc.target_value, 1) value1,
               
               '新城' org_id,
               acc.period_type_id
          from dm_mcl_acct acc, dim_org org, dim_index ind
         where acc.org_id = org.org_id
           and acc.index_id = ind.index_id
           and ind.index_id =
               (select index_id
                  from (select *
                          from dim_index i
                         start with i.index_id = '054878caa2b9466b853cab410f59437a'
                        connect by prior i.index_id = i.father_id) i
                 where i.index_id in  ('3e927b5caa3a4d38b51a2bae096d73d3','8af4664d0837409a9b63736bb1630c9e','1902a5e1a5de463f92171a2734c7f9a8'))
           and org.org_id = 'E0A3D386-D5C8-FB22-18DE-4424D49363B2'
        
        union all
        select '实际' type1,
               round(acc.actual_value, 1) value1,
               '新城' org_id,
               acc.period_type_id
          from dm_mcl_acct acc, dim_org org, dim_index ind
         where acc.org_id = org.org_id
           and acc.index_id = ind.index_id
           and ind.index_id =
               (select index_id
                  from (select *
                          from dim_index i
                         start with i.index_id = '054878caa2b9466b853cab410f59437a'
                        connect by prior i.index_id = i.father_id) i
                 where i.index_id in  ('3e927b5caa3a4d38b51a2bae096d73d3','8af4664d0837409a9b63736bb1630c9e','1902a5e1a5de463f92171a2734c7f9a8'))
           and org.org_id = 'E0A3D386-D5C8-FB22-18DE-4424D49363B2'
        union all
        select '预估完成' type1,
               case
                 when nvl(acc.forecate_value, 0) = 0 then
                  round(nvl(acc.target_value, 0), 1)
                 else
                  round(acc.forecate_value, 1)
               end as value1,
               
               '新城' org_id,
               acc.period_type_id
          from dm_mcl_acct acc, dim_org org, dim_index ind
         where acc.org_id = org.org_id
           and acc.index_id = ind.index_id
           and ind.index_id =
               (select index_id
                  from (select *
                          from dim_index i
                        start with i.index_id = '054878caa2b9466b853cab410f59437a'
                        connect by prior i.index_id = i.father_id) i
                 where i.index_id in  ('3e927b5caa3a4d38b51a2bae096d73d3','8af4664d0837409a9b63736bb1630c9e','1902a5e1a5de463f92171a2734c7f9a8'))
           and org.org_id = 'E0A3D386-D5C8-FB22-18DE-4424D49363B2'
        
        ) result
 where org_id = '"+project+"'
   and result.period_type_id =
       to_char(to_date('"+yearmonth+"', 'YYYYMMDD'), 'yyyy') || 'Q0' ||
       to_char(to_date('"+yearmonth+"', 'YYYYMMDD'), 'Q')

                 
                 ")}]]></Query>
</TableData>
<TableData name="sign_hjwb" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="project"/>
<O>
<![CDATA[其他]]></O>
</Parameter>
<Parameter>
<Attributes name="yearmonth"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=sql("oracle_test","select  max( DATA_DATE) from  dm_mcl_acct",1,1)]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="periodtype"/>
<O>
<![CDATA[当月]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[oracle_test]]></DatabaseName>
</Connection>
<Query>
<![CDATA[with T AS (
select org_classify, 
   case when 
      actual_value<0.005 
         then 0 else actual_value end actual_value  from (
select org_classify,round(sum(actual_value),1) as actual_value from (
select acc.target_value,
acc.actual_value,
acc.forecate_value,
acc.last_actual_value,
acc.last_rate_value,
org.org_id,
org.org_name,
org.org_sname,
org.org_classify
  from dm_mcl_acct acc,
       (select * from (SELECT *
          FROM DIM_ORG
         START WITH ORG_id = (case '${project}' 
                      when  '住宅' then  --孔雀城住宅
                 '54720271-A741-423A-BE20-E593A168EC88'
                 when   '股份公司' then  --华夏幸福
                 'E0A3D386-D5C8-FB22-18DE-4424D49363B1'
                 when '新城全口径' then  --产业新城
                  'E0A3D386-D5C8-FB22-18DE-4424D49363B2'
                 when '小镇' then   --产业小镇
                  '170D757F-2757-43FF-831A-89F2A44BA854'
                 when '其他' then  --物业
                  'E0A3D386-D5C8-FB22-18DE-4424D49363B4'
                    end)
        CONNECT BY PRIOR ORG_ID = FATHER_ID)
        where 1=1
         ${if(project =='住宅'," and org_type='分公司' ","and  org_type='区域' ")}
and org_classify in ('环京', '外埠')
        ) org,
       dim_index ind
 where acc.org_id = org.org_id
   and acc.index_id = ind.index_id
   and org.org_id not in
       ('E0A3D386-D5C8-FB22-18DE-4424D49363B1', 'E0A3D386-D5C8-FB22-18DE-4424D49363B2', 
         '170D757F-2757-43FF-831A-89F2A44BA854', '54720271-A741-423A-BE20-E593A168EC88', 
         'E0A3D386-D5C8-FB22-18DE-4424D49363B4')
   and ind.index_id = '054878caa2b9466b853cab410f59437a'
  
   and acc.period_type_id= case '${periodtype}'  when '当年' then substr('${yearmonth}', 1, 4) when '当季' then substr('${yearmonth}', 1, 4)||'Q0'||to_char(to_date('${yearmonth}','YYYYMMDD'),'Q') when '当月' then substr('${yearmonth}', 1, 4)||'M'||to_char(to_date('${yearmonth}','YYYYMMDD'),'MM')  end
union all
 
select acc.target_value,
acc.actual_value,
acc.forecate_value,
acc.last_actual_value,
acc.last_rate_value,
org.org_id,
org.org_name,
org.org_sname,
org.org_classify
  from dm_mcl_acct acc,
       DIM_ORG org,
       dim_index ind
 where acc.org_id = org.org_id
   and acc.index_id = ind.index_id
   and org.org_type='区域'
and org.org_classify in ('环京', '外埠')
   and org.org_id not in
       ('E0A3D386-D5C8-FB22-18DE-4424D49363B2')
   and ind.index_id =
               (select index_id
                  from (select *
                          from dim_index i
                         start with i.index_id = '054878caa2b9466b853cab410f59437a'
                        connect by prior i.index_id = i.father_id) i
                 where i.index_id in ('3e927b5caa3a4d38b51a2bae096d73d3','8af4664d0837409a9b63736bb1630c9e','1902a5e1a5de463f92171a2734c7f9a8'))
  
   and acc.period_type_id= case '${periodtype}'  when '当年' then substr('${yearmonth}', 1, 4)
    when '当季' then substr('${yearmonth}', 1, 4)||'Q0'||to_char(to_date('${yearmonth}','YYYYMMDD'),'Q') 
      when '当月' then substr('${yearmonth}', 1, 4)||'M'||to_char(to_date('${yearmonth}','YYYYMMDD'),'MM')  end
   and decode('${project}' ,'新城',1,0)=1

) 
where org_classify is not null
group by org_classify ))

${if(project='股份公司',"
select round(sum(actual_value),1) as actual_value,org_classify from (
SELECT actual_value, org_classify FROM  T 
union all
select sum(actual) as actual_value,org_classify   from dm_mcl_wy_detail t inner join dim_org t1
on t.orgid=t1.org_id
and t1.org_type='事业部' 
where t.period=case '"+periodtype+"'  when '当年' then substr('"+yearmonth+"', 1, 4)
when '当季' then substr('"+yearmonth+"', 1, 4)||'Q0'||to_char(to_date('"+yearmonth+"','YYYYMMDD'),'Q') 
  when '当月' then substr('"+yearmonth+"', 1, 4)||'M'||to_char(to_date('"+yearmonth+"','YYYYMMDD'),'MM')  end
and org_classify is not null
group by  org_classify
) t
group by org_classify

"," SELECT round(actual_value,1) as actual_value,org_classify  FROM  T 
WHERE CASE WHEN  (select SUM(actual_value) from t)=0  then 0 else 1 end !=0  ")}]]></Query>
</TableData>
<TableData name="sign_target" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="comtype"/>
<O>
<![CDATA[事业部]]></O>
</Parameter>
<Parameter>
<Attributes name="project"/>
<O>
<![CDATA[股份公司]]></O>
</Parameter>
<Parameter>
<Attributes name="yearmonth"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=sql("oracle_test","select  max( DATA_DATE) from  dm_mcl_acct",1,1)]]></Attributes>
</O>
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
<![CDATA[select t.*,rownum from (
SELECT data_type,org_id,org_sname,org_type,type,target_value,round(actual_value,1) actual_value,order_key,case when target_value=0 then 0 else actual_value/target_value end lv
FROM
(select data_type,org_id,org_sname,org_type,type,sum(target_value) target_value,sum(actual_value) actual_value,order_key
from 
(select '当年' data_type,a.org_id,b.org_sname,b.org_type,'股份公司' type,target_value,actual_value,b.order_key
from dm_mcl_acct a inner join dim_org b on a.org_id=b.org_id
where period_type_id=substr('${yearmonth}',1,4) and b.org_type_id='产业新城（国内）' and index_id='054878caa2b9466b853cab410f59437a'
union all
select '当年' data_type,a.orgid,b.org_sname,b.org_type,'股份公司' type,0 target_value,actual actual_value,b.order_key
from dm_mcl_wy_detail a inner join dim_org b on a.orgid=b.org_id
where period=substr('${yearmonth}',1,4) and b.org_type_id='产业新城（国内）') a group by data_type,org_id,org_sname,org_type,type,order_key
union all
select '当年' data_type,a.org_id,b.org_sname,b.org_type,'新城全口径' type,target_value,actual_value,b.order_key
from dm_mcl_acct a inner join dim_org b on a.org_id=b.org_id
where period_type_id=substr('${yearmonth}',1,4) and b.org_type_id='产业新城（国内）' and index_id='054878caa2b9466b853cab410f59437a'
union all
select '当年' data_type,a.org_id,b.org_sname,b.org_type,'新城' type,target_value,actual_value,b.order_key
from dm_mcl_acct a inner join dim_org b on a.org_id=b.org_id
where period_type_id=substr('${yearmonth}',1,4) and b.org_type_id='产业新城（国内）' and index_id='3e927b5caa3a4d38b51a2bae096d73d3'
union all
select '当年' data_type,a.org_id,b.org_sname,b.org_type,'住宅' type,target_value,actual_value,b.order_key
from dm_mcl_acct a inner join dim_org b on a.org_id=b.org_id
where period_type_id=substr('${yearmonth}',1,4) and b.org_type_id='孔雀城住宅' and index_id='054878caa2b9466b853cab410f59437a'
union all
select '当年' data_type,a.org_id,b.org_sname,b.org_type,'小镇' type,target_value,actual_value,b.order_key
from dm_mcl_acct a inner join dim_org b on a.org_id=b.org_id
where period_type_id=substr('${yearmonth}',1,4) and b.org_type_id='产业小镇' and index_id='054878caa2b9466b853cab410f59437a'
union all
select data_type,org_id,org_sname,org_type,type,sum(target_value) target_value,sum(actual_value) actual_value,order_key
from 
(select '当季' data_type,a.org_id,b.org_sname,b.org_type,'股份公司' type,target_value,actual_value,b.order_key
from dm_mcl_acct a inner join dim_org b on a.org_id=b.org_id
where period_type_id=substr('${yearmonth}',1,4)||'Q0'||to_char(to_date('${yearmonth}','yyyymmdd'),'q') and b.org_type_id='产业新城（国内）' and index_id='054878caa2b9466b853cab410f59437a'
union all
select '当季' data_type,a.orgid,b.org_sname,b.org_type,'股份公司' type,0 target_value,actual actual_value,b.order_key
from dm_mcl_wy_detail a inner join dim_org b on a.orgid=b.org_id
where period=substr('${yearmonth}',1,4)||'Q0'||to_char(to_date('${yearmonth}','yyyymmdd'),'q') and b.org_type_id='产业新城（国内）') a 
group by data_type,org_id,org_sname,org_type,type,order_key
union all
select '当季' data_type,a.org_id,b.org_sname,b.org_type,'新城全口径' type,target_value,actual_value,b.order_key
from dm_mcl_acct a inner join dim_org b on a.org_id=b.org_id
where period_type_id=substr('${yearmonth}',1,4)||'Q0'||to_char(to_date('${yearmonth}','yyyymmdd'),'q') and b.org_type_id='产业新城（国内）' and index_id='054878caa2b9466b853cab410f59437a'
union all
select '当季' data_type,a.org_id,b.org_sname,b.org_type,'新城' type,target_value,actual_value,b.order_key
from dm_mcl_acct a inner join dim_org b on a.org_id=b.org_id
where period_type_id=substr('${yearmonth}',1,4)||'Q0'||to_char(to_date('${yearmonth}','yyyymmdd'),'q') and b.org_type_id='产业新城（国内）' and index_id='3e927b5caa3a4d38b51a2bae096d73d3'
union all
select '当季' data_type,a.org_id,b.org_sname,b.org_type,'住宅' type,target_value,actual_value,b.order_key
from dm_mcl_acct a inner join dim_org b on a.org_id=b.org_id
where period_type_id=substr('${yearmonth}',1,4)||'Q0'||to_char(to_date('${yearmonth}','yyyymmdd'),'q') and b.org_type_id='孔雀城住宅' and index_id='054878caa2b9466b853cab410f59437a'
union all
select '当季' data_type,a.org_id,b.org_sname,b.org_type,'小镇' type,target_value,actual_value,b.order_key
from dm_mcl_acct a inner join dim_org b on a.org_id=b.org_id
where period_type_id=substr('${yearmonth}',1,4)||'Q0'||to_char(to_date('${yearmonth}','yyyymmdd'),'q') and b.org_type_id='产业小镇' 
and index_id = '054878caa2b9466b853cab410f59437a'  --add 
UNION ALL
select data_type,org_id,org_sname,org_type,type,sum(target_value) target_value,sum(actual_value) actual_value,order_key
from 
(select '当月' data_type,a.org_id,b.org_sname,b.org_type,'股份公司' type,target_value,actual_value,b.order_key
from dm_mcl_acct a inner join dim_org b on a.org_id=b.org_id
where period_type_id=substr('${yearmonth}',1,4)||'M'||SUBSTR('${yearmonth}',5,2) and b.org_type_id='产业新城（国内）' and index_id='054878caa2b9466b853cab410f59437a'
union all
select '当月' data_type,a.orgid,b.org_sname,b.org_type,'股份公司' type,0 target_value,actual actual_value,b.order_key
from dm_mcl_wy_detail a inner join dim_org b on a.orgid=b.org_id
where period=substr('${yearmonth}',1,4)||'Q0'||SUBSTR('${yearmonth}',5,2) and b.org_type_id='产业新城（国内）') a group by data_type,org_id,org_sname,org_type,type,order_key
union all
select '当月' data_type,a.org_id,b.org_sname,b.org_type,'新城全口径' type,target_value,actual_value,b.order_key
from dm_mcl_acct a inner join dim_org b on a.org_id=b.org_id
where period_type_id=substr('${yearmonth}',1,4)||'M'||SUBSTR('${yearmonth}',5,2) and b.org_type_id='产业新城（国内）' and index_id='054878caa2b9466b853cab410f59437a'
union all
select '当月' data_type,a.org_id,b.org_sname,b.org_type,'新城' type,target_value,actual_value,b.order_key
from dm_mcl_acct a inner join dim_org b on a.org_id=b.org_id
where period_type_id=substr('${yearmonth}',1,4)||'M'||SUBSTR('${yearmonth}',5,2) and b.org_type_id='产业新城（国内）' and index_id='3e927b5caa3a4d38b51a2bae096d73d3'
union all
select '当月' data_type,a.org_id,b.org_sname,b.org_type,'住宅' type,target_value,actual_value,b.order_key
from dm_mcl_acct a inner join dim_org b on a.org_id=b.org_id
where period_type_id=substr('${yearmonth}',1,4)||'M'||SUBSTR('${yearmonth}',5,2) and b.org_type_id='孔雀城住宅' and index_id='054878caa2b9466b853cab410f59437a'
union all
select '当月' data_type,a.org_id,b.org_sname,b.org_type,'小镇' type,target_value,actual_value,b.order_key
from dm_mcl_acct a inner join dim_org b on a.org_id=b.org_id
where period_type_id=substr('${yearmonth}',1,4)||'M'||SUBSTR('${yearmonth}',5,2) and b.org_type_id='产业小镇' and index_id='054878caa2b9466b853cab410f59437a') A
where data_type='${periodtype}' and org_type='${comtype}' and type='${project}' 
order by  target_value  desc ,order_key) t
where rownum<=10
order by target_value asc,order_key]]></Query>
</TableData>
<TableData name="sign_actual" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="comtype"/>
<O>
<![CDATA[事业部]]></O>
</Parameter>
<Parameter>
<Attributes name="project"/>
<O>
<![CDATA[股份公司]]></O>
</Parameter>
<Parameter>
<Attributes name="yearmonth"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=sql("oracle_test","select  max( DATA_DATE) from  dm_mcl_acct",1,1)]]></Attributes>
</O>
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
<![CDATA[select t.*,rownum from (
SELECT data_type,org_id,org_sname,org_type,type, round(target_value, 1) target_value,round(actual_value, 1) actual_value,order_key,case when target_value=0 then 0 else actual_value/target_value end lv
FROM
(select data_type,org_id,org_sname,org_type,type, round(sum(target_value), 1) target_value, round(sum(actual_value), 1) actual_value,order_key
from 
(select '当年' data_type,a.org_id,b.org_sname,b.org_type,'股份公司' type,target_value,actual_value,b.order_key
from dm_mcl_acct a inner join dim_org b on a.org_id=b.org_id
where period_type_id=substr('${yearmonth}',1,4) and b.org_type_id='产业新城（国内）' and index_id='054878caa2b9466b853cab410f59437a'
union all
select '当年' data_type,a.orgid,b.org_sname,b.org_type,'股份公司' type,0 target_value,actual actual_value,b.order_key
from dm_mcl_wy_detail a inner join dim_org b on a.orgid=b.org_id
where period=substr('${yearmonth}',1,4) and b.org_type_id='产业新城（国内）') a group by data_type,org_id,org_sname,org_type,type,order_key
union all
select '当年' data_type,a.org_id,b.org_sname,b.org_type,'新城全口径' type,target_value,actual_value,b.order_key
from dm_mcl_acct a inner join dim_org b on a.org_id=b.org_id
where period_type_id=substr('${yearmonth}',1,4) and b.org_type_id='产业新城（国内）' and index_id='054878caa2b9466b853cab410f59437a'
union all
select '当年' data_type,a.org_id,b.org_sname,b.org_type,'新城' type,target_value,actual_value,b.order_key
from dm_mcl_acct a inner join dim_org b on a.org_id=b.org_id
where period_type_id=substr('${yearmonth}',1,4) and b.org_type_id='产业新城（国内）' and index_id='3e927b5caa3a4d38b51a2bae096d73d3'
union all
select '当年' data_type,a.org_id,b.org_sname,b.org_type,'住宅' type,target_value,actual_value,b.order_key
from dm_mcl_acct a inner join dim_org b on a.org_id=b.org_id
where period_type_id=substr('${yearmonth}',1,4) and b.org_type_id='孔雀城住宅' and index_id='054878caa2b9466b853cab410f59437a'
union all
select '当年' data_type,a.org_id,b.org_sname,b.org_type,'小镇' type,target_value,actual_value,b.order_key
from dm_mcl_acct a inner join dim_org b on a.org_id=b.org_id
where period_type_id=substr('${yearmonth}',1,4) and b.org_type_id='产业小镇' and index_id='054878caa2b9466b853cab410f59437a'
union all
select data_type,org_id,org_sname,org_type,type,sum(target_value) target_value,sum(actual_value) actual_value,order_key
from 
(select '当季' data_type,a.org_id,b.org_sname,b.org_type,'股份公司' type,target_value,actual_value,b.order_key
from dm_mcl_acct a inner join dim_org b on a.org_id=b.org_id
where period_type_id=substr('${yearmonth}',1,4)||'Q0'||to_char(to_date('${yearmonth}','yyyymmdd'),'q') and b.org_type_id='产业新城（国内）' and index_id='054878caa2b9466b853cab410f59437a'
union all
select '当季' data_type,a.orgid,b.org_sname,b.org_type,'股份公司' type,0 target_value,actual actual_value,b.order_key
from dm_mcl_wy_detail a inner join dim_org b on a.orgid=b.org_id
where period=substr('${yearmonth}',1,4)||'Q0'||to_char(to_date('${yearmonth}','yyyymmdd'),'q') and b.org_type_id='产业新城（国内）') a 
group by data_type,org_id,org_sname,org_type,type,order_key
union all
select '当季' data_type,a.org_id,b.org_sname,b.org_type,'新城全口径' type,target_value,actual_value,b.order_key
from dm_mcl_acct a inner join dim_org b on a.org_id=b.org_id
where period_type_id=substr('${yearmonth}',1,4)||'Q0'||to_char(to_date('${yearmonth}','yyyymmdd'),'q') and b.org_type_id='产业新城（国内）' and index_id='054878caa2b9466b853cab410f59437a'
union all
select '当季' data_type,a.org_id,b.org_sname,b.org_type,'新城' type,target_value,actual_value,b.order_key
from dm_mcl_acct a inner join dim_org b on a.org_id=b.org_id
where period_type_id=substr('${yearmonth}',1,4)||'Q0'||to_char(to_date('${yearmonth}','yyyymmdd'),'q') and b.org_type_id='产业新城（国内）' and index_id='3e927b5caa3a4d38b51a2bae096d73d3'
union all
select '当季' data_type,a.org_id,b.org_sname,b.org_type,'住宅' type,target_value,actual_value,b.order_key
from dm_mcl_acct a inner join dim_org b on a.org_id=b.org_id
where period_type_id=substr('${yearmonth}',1,4)||'Q0'||to_char(to_date('${yearmonth}','yyyymmdd'),'q') and b.org_type_id='孔雀城住宅' and index_id='054878caa2b9466b853cab410f59437a'
union all
select '当季' data_type,a.org_id,b.org_sname,b.org_type,'小镇' type,target_value,actual_value,b.order_key
from dm_mcl_acct a inner join dim_org b on a.org_id=b.org_id
where period_type_id=substr('${yearmonth}',1,4)||'Q0'||to_char(to_date('${yearmonth}','yyyymmdd'),'q') and b.org_type_id='产业小镇' 
and index_id = '054878caa2b9466b853cab410f59437a'  --add
UNION ALL
select data_type,org_id,org_sname,org_type,type,sum(target_value) target_value,sum(actual_value) actual_value,order_key
from 
(select '当月' data_type,a.org_id,b.org_sname,b.org_type,'股份公司' type,target_value,actual_value,b.order_key
from dm_mcl_acct a inner join dim_org b on a.org_id=b.org_id
where period_type_id=substr('${yearmonth}',1,4)||'M'||SUBSTR('${yearmonth}',5,2) and b.org_type_id='产业新城（国内）' and index_id='054878caa2b9466b853cab410f59437a'
union all
select '当月' data_type,a.orgid,b.org_sname,b.org_type,'股份公司' type,0 target_value,actual actual_value,b.order_key
from dm_mcl_wy_detail a inner join dim_org b on a.orgid=b.org_id
where period=substr('${yearmonth}',1,4)||'Q0'||SUBSTR('${yearmonth}',5,2) and b.org_type_id='产业新城（国内）') a group by data_type,org_id,org_sname,org_type,type,order_key
union all
select '当月' data_type,a.org_id,b.org_sname,b.org_type,'新城全口径' type,target_value,actual_value,b.order_key
from dm_mcl_acct a inner join dim_org b on a.org_id=b.org_id
where period_type_id=substr('${yearmonth}',1,4)||'M'||SUBSTR('${yearmonth}',5,2) and b.org_type_id='产业新城（国内）' and index_id='054878caa2b9466b853cab410f59437a'
union all
select '当月' data_type,a.org_id,b.org_sname,b.org_type,'新城' type,target_value,actual_value,b.order_key
from dm_mcl_acct a inner join dim_org b on a.org_id=b.org_id
where period_type_id=substr('${yearmonth}',1,4)||'M'||SUBSTR('${yearmonth}',5,2) and b.org_type_id='产业新城（国内）' and index_id='3e927b5caa3a4d38b51a2bae096d73d3'
union all
select '当月' data_type,a.org_id,b.org_sname,b.org_type,'住宅' type,target_value,actual_value,b.order_key
from dm_mcl_acct a inner join dim_org b on a.org_id=b.org_id
where period_type_id=substr('${yearmonth}',1,4)||'M'||SUBSTR('${yearmonth}',5,2) and b.org_type_id='孔雀城住宅' and index_id='054878caa2b9466b853cab410f59437a'
union all
select '当月' data_type,a.org_id,b.org_sname,b.org_type,'小镇' type,target_value,actual_value,b.order_key
from dm_mcl_acct a inner join dim_org b on a.org_id=b.org_id
where period_type_id=substr('${yearmonth}',1,4)||'M'||SUBSTR('${yearmonth}',5,2) and b.org_type_id='产业小镇' and index_id='054878caa2b9466b853cab410f59437a'

union all 
--其他
select 
'${periodtype}'  data_type, '' org_id,org.org_sname,'' org_type,'其他' type,target_value ,actual_value,order_key
 from dm_mcl_acct acc inner join dim_org org
on
acc.org_id=org.org_id
and org.org_classify_id='其他'
where 1=2
and period_type_id=case '${periodtype}'  when '当年' 
then substr('${yearmonth}',1,4) when '当季' then 
  substr('${yearmonth}',1,4)||'Q0'||to_char(to_date('${yearmonth}','YYYYMMDD'),'Q') 
  when '当月' then substr('${yearmonth}',1,4)||'M'||to_char(to_date('${yearmonth}','YYYYMMDD'),'MM')  end
and acc.index_id='054878caa2b9466b853cab410f59437a'
order by actual_value asc ,order_key desc

) A
where data_type='${periodtype}' 
${if(project='其他'," and 1=1 ",if(project='住宅'," and org_type = '分公司'"," and org_type ='"+comtype+"'"))}
and type='${project}' 
order by  actual_value  desc ,order_key desc) t
where rownum<=10
order by actual_value  asc,order_key desc]]></Query>
</TableData>
<TableData name="sign_lv" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="comtype"/>
<O>
<![CDATA[事业部]]></O>
</Parameter>
<Parameter>
<Attributes name="project"/>
<O>
<![CDATA[股份公司]]></O>
</Parameter>
<Parameter>
<Attributes name="yearmonth"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=sql("oracle_test","select  max( DATA_DATE) from  dm_mcl_acct",1,1)]]></Attributes>
</O>
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
<![CDATA[select  t.*, rownum from (
SELECT data_type,org_id,org_sname,org_type,type,target_value,actual_value,order_key,case when target_value=0 then 0 else actual_value/target_value end lv
FROM
(select data_type,org_id,org_sname,org_type,type,sum(target_value) target_value,sum(actual_value) actual_value,order_key
from 
(select '当年' data_type,a.org_id,b.org_sname,b.org_type,'股份公司' type,target_value,actual_value,b.order_key
from dm_mcl_acct a inner join dim_org b on a.org_id=b.org_id
where period_type_id=substr('${yearmonth}',1,4) and b.org_type_id='产业新城（国内）' and index_id='054878caa2b9466b853cab410f59437a'
union all
select '当年' data_type,a.orgid,b.org_sname,b.org_type,'股份公司' type,0 target_value,actual actual_value,b.order_key
from dm_mcl_wy_detail a inner join dim_org b on a.orgid=b.org_id
where period=substr('${yearmonth}',1,4) and b.org_type_id='产业新城（国内）') a group by data_type,org_id,org_sname,org_type,type,order_key
union all
select '当年' data_type,a.org_id,b.org_sname,b.org_type,'新城全口径' type,target_value,actual_value,b.order_key
from dm_mcl_acct a inner join dim_org b on a.org_id=b.org_id
where period_type_id=substr('${yearmonth}',1,4) and b.org_type_id='产业新城（国内）' and index_id='054878caa2b9466b853cab410f59437a'
union all
select '当年' data_type,a.org_id,b.org_sname,b.org_type,'新城' type,target_value,actual_value,b.order_key
from dm_mcl_acct a inner join dim_org b on a.org_id=b.org_id
where period_type_id=substr('${yearmonth}',1,4) and b.org_type_id='产业新城（国内）' and index_id='3e927b5caa3a4d38b51a2bae096d73d3'
union all
select '当年' data_type,a.org_id,b.org_sname,b.org_type,'住宅' type,target_value,actual_value,b.order_key
from dm_mcl_acct a inner join dim_org b on a.org_id=b.org_id
where period_type_id=substr('${yearmonth}',1,4) and b.org_type_id='孔雀城住宅' and index_id='054878caa2b9466b853cab410f59437a'
union all
select '当年' data_type,a.org_id,b.org_sname,b.org_type,'小镇' type,target_value,actual_value,b.order_key
from dm_mcl_acct a inner join dim_org b on a.org_id=b.org_id
where period_type_id=substr('${yearmonth}',1,4) and b.org_type_id='产业小镇' and index_id='054878caa2b9466b853cab410f59437a'
union all
select data_type,org_id,org_sname,org_type,type,sum(target_value) target_value,sum(actual_value) actual_value,order_key
from 
(select '当季' data_type,a.org_id,b.org_sname,b.org_type,'股份公司' type,target_value,actual_value,b.order_key
from dm_mcl_acct a inner join dim_org b on a.org_id=b.org_id
where period_type_id=substr('${yearmonth}',1,4)||'Q0'||to_char(to_date('${yearmonth}','yyyymmdd'),'q') and b.org_type_id='产业新城（国内）' and index_id='054878caa2b9466b853cab410f59437a'
union all
select '当季' data_type,a.orgid,b.org_sname,b.org_type,'股份公司' type,0 target_value,actual actual_value,b.order_key
from dm_mcl_wy_detail a inner join dim_org b on a.orgid=b.org_id
where period=substr('${yearmonth}',1,4)||'Q0'||to_char(to_date('${yearmonth}','yyyymmdd'),'q') and b.org_type_id='产业新城（国内）') a 
group by data_type,org_id,org_sname,org_type,type,order_key
union all
select '当季' data_type,a.org_id,b.org_sname,b.org_type,'新城全口径' type,target_value,actual_value,b.order_key
from dm_mcl_acct a inner join dim_org b on a.org_id=b.org_id
where period_type_id=substr('${yearmonth}',1,4)||'Q0'||to_char(to_date('${yearmonth}','yyyymmdd'),'q') and b.org_type_id='产业新城（国内）' and index_id='054878caa2b9466b853cab410f59437a'
union all
select '当季' data_type,a.org_id,b.org_sname,b.org_type,'新城' type,target_value,actual_value,b.order_key
from dm_mcl_acct a inner join dim_org b on a.org_id=b.org_id
where period_type_id=substr('${yearmonth}',1,4)||'Q0'||to_char(to_date('${yearmonth}','yyyymmdd'),'q') and b.org_type_id='产业新城（国内）' and index_id='3e927b5caa3a4d38b51a2bae096d73d3'
union all
select '当季' data_type,a.org_id,b.org_sname,b.org_type,'住宅' type,target_value,actual_value,b.order_key
from dm_mcl_acct a inner join dim_org b on a.org_id=b.org_id
where period_type_id=substr('${yearmonth}',1,4)||'Q0'||to_char(to_date('${yearmonth}','yyyymmdd'),'q') and b.org_type_id='孔雀城住宅' and index_id='054878caa2b9466b853cab410f59437a'
union all
select '当季' data_type,a.org_id,b.org_sname,b.org_type,'小镇' type,target_value,actual_value,b.order_key
from dm_mcl_acct a inner join dim_org b on a.org_id=b.org_id
where period_type_id=substr('${yearmonth}',1,4)||'Q0'||to_char(to_date('${yearmonth}','yyyymmdd'),'q') and b.org_type_id='产业小镇' 
and index_id = '054878caa2b9466b853cab410f59437a' --add
UNION ALL
select data_type,org_id,org_sname,org_type,type,sum(target_value) target_value,sum(actual_value) actual_value,order_key
from 
(select '当月' data_type,a.org_id,b.org_sname,b.org_type,'股份公司' type,target_value,actual_value,b.order_key
from dm_mcl_acct a inner join dim_org b on a.org_id=b.org_id
where period_type_id=substr('${yearmonth}',1,4)||'M'||SUBSTR('${yearmonth}',5,2) and b.org_type_id='产业新城（国内）' and index_id='054878caa2b9466b853cab410f59437a'
union all
select '当月' data_type,a.orgid,b.org_sname,b.org_type,'股份公司' type,0 target_value,actual actual_value,b.order_key
from dm_mcl_wy_detail a inner join dim_org b on a.orgid=b.org_id
where period=substr('${yearmonth}',1,4)||'Q0'||SUBSTR('${yearmonth}',5,2) and b.org_type_id='产业新城（国内）') a group by data_type,org_id,org_sname,org_type,type,order_key
union all
select '当月' data_type,a.org_id,b.org_sname,b.org_type,'新城全口径' type,target_value,actual_value,b.order_key
from dm_mcl_acct a inner join dim_org b on a.org_id=b.org_id
where period_type_id=substr('${yearmonth}',1,4)||'M'||SUBSTR('${yearmonth}',5,2) and b.org_type_id='产业新城（国内）' and index_id='054878caa2b9466b853cab410f59437a'
union all
select '当月' data_type,a.org_id,b.org_sname,b.org_type,'新城' type,target_value,actual_value,b.order_key
from dm_mcl_acct a inner join dim_org b on a.org_id=b.org_id
where period_type_id=substr('${yearmonth}',1,4)||'M'||SUBSTR('${yearmonth}',5,2) and b.org_type_id='产业新城（国内）' and index_id='3e927b5caa3a4d38b51a2bae096d73d3'
union all
select '当月' data_type,a.org_id,b.org_sname,b.org_type,'住宅' type,target_value,actual_value,b.order_key
from dm_mcl_acct a inner join dim_org b on a.org_id=b.org_id
where period_type_id=substr('${yearmonth}',1,4)||'M'||SUBSTR('${yearmonth}',5,2) and b.org_type_id='孔雀城住宅' and index_id='054878caa2b9466b853cab410f59437a'
union all
select '当月' data_type,a.org_id,b.org_sname,b.org_type,'小镇' type,target_value,actual_value,b.order_key
from dm_mcl_acct a inner join dim_org b on a.org_id=b.org_id
where period_type_id=substr('${yearmonth}',1,4)||'M'||SUBSTR('${yearmonth}',5,2) and b.org_type_id='产业小镇' and index_id='054878caa2b9466b853cab410f59437a'
--其他
union all
--其他
select 
'${periodtype}'  data_type, '' org_id,org.org_sname,'' org_type,'其他' type,target_value ,actual_value,order_key
 from dm_mcl_acct acc inner join dim_org org
on
acc.org_id=org.org_id
and org.org_classify_id='其他'
where 1=2
and period_type_id=case '${periodtype}'  when '当年' 
then to_char(to_date('${yearmonth}','YYYYMMDD'),'yyyy') when '当季' then 
  to_char(to_date('${yearmonth}','YYYYMMDD'),'yyyy')||'Q0'||to_char(to_date('${yearmonth}','YYYYMMDD'),'Q') 
  when '当月' then to_char(to_date('${yearmonth}','YYYYMMDD'),'yyyy')||'M'||to_char(to_date('${yearmonth}','YYYYMMDD'),'MM')  end
and acc.index_id='054878caa2b9466b853cab410f59437a'


) A
where data_type='${periodtype}' 
${if(project='其他'," and 1=1 ", if(project='住宅',"and org_type ='分公司'","  and org_type ='"+comtype+"'"))}
and type='${project}' 
order by  case when target_value=0 then 0 else actual_value/target_value end  desc ,order_key desc) t 
where rownum<=10
order by case when target_value=0 then 0 else actual_value/target_value end  asc ,order_key desc

]]></Query>
</TableData>
<TableData name="color" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="project"/>
<O>
<![CDATA[股份公司]]></O>
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
<![CDATA[SELECT 
case when '${periodtype}'='当年' then 
FINAL_YEAR
 when '${periodtype}'='当季' then 
FINAL_QUARTER 
else  0 end ld FROM  DM_MCL_QYHK_STATUS
WHERE 
 ORG_ID = (case '${project}' 
                      when  '住宅' then  --孔雀城住宅
                 '54720271-A741-423A-BE20-E593A168EC88'
                 when   '股份公司' then  --华夏幸福
                 'E0A3D386-D5C8-FB22-18DE-4424D49363B1'
                 when '新城全口径' then  --产业新城
                  'E0A3D386-D5C8-FB22-18DE-4424D49363B2'
                 when '小镇' then   --产业小镇
                  '170D757F-2757-43FF-831A-89F2A44BA854'
                 when '其他' then  --物业
                  'E0A3D386-D5C8-FB22-18DE-4424D49363B4'
                   when '新城' then  --新城
                  'E0A3D386-D5C8-FB22-18DE-4424D49363B3'
                  end)
    and index_id='054878caa2b9466b853cab410f59437a']]></Query>
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
<JavaScript class="com.fr.js.Commit2DBJavaScript">
<Parameters/>
<Attributes dsName="oracle_test" name="提交1"/>
<DMLConfig class="com.fr.write.config.IntelliDMLConfig">
<Table schema="" name=""/>
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
<![CDATA[=INDEXOFARRAY(SPLIT(formletName,"/"),count(SPLIT(formletName,"/")))]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="WENJIANMINGCHENG" isKey="false" skipUnmodified="false">
<O>
<![CDATA[财务类-签约]]></O>
</ColumnConfig>
<ColumnConfig name="CANSHUMING" isKey="false" skipUnmodified="false">
<O>
<![CDATA[comtype;project;yearmonth;periodtype;valuetype]]></O>
</ColumnConfig>
<ColumnConfig name="CANSHU" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(len($comtype99)=0 ,"",$comtype99+";")+
if(len($project99)=0 ,"",$project99+";")+
if(len($yearmonth99)=0 ,"",$yearmonth99+";")+
if(len($periodtype99)=0 ,"",$periodtype99+";")+
if(len($valuetype99)=0 ,"",$valuetype99+";")]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="CANSHUMINGYUCANSHU" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(len($comtype99)=0,"","comtype："+$comtype99+";")+
if(len($project99)=0,"","project："+$project99+";")+
if(len($yearmonth99)=0,"","yearmonth："+$yearmonth99+";")+
if(len($periodtype99)=0,"","periodtype："+$periodtype99+";")+
if(len($valuetype99)=0,"","valuetype："+$valuetype99+";")]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="TIME" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=now()]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="DAOCHU" isKey="false" skipUnmodified="false">
<O>
<![CDATA[]]></O>
</ColumnConfig>
<ColumnConfig name="SHIFOUDIANJILIANJIE" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(len($chaolj)=0,"否",if($chaolj = $chaolj99, "否","是"))]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="LIANJIECANSHUMING" isKey="false" skipUnmodified="false">
<O>
<![CDATA[chaolj]]></O>
</ColumnConfig>
<ColumnConfig name="LIANJIECANSHU" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$chaolj]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="LIANJIEMINGYUCANSHU" isKey="false" skipUnmodified="false">
<O>
<![CDATA[]]></O>
</ColumnConfig>
<ColumnConfig name="DATA_DATE" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=today()]]></Attributes>
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
<![CDATA[=uuid()]]></Attributes>
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
<![CDATA[=INDEXOFARRAY(SPLIT(formletName,"/"),count(SPLIT(formletName,"/")))]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="WENJIANMINGCHENG" isKey="false" skipUnmodified="false">
<O>
<![CDATA[财务类-签约]]></O>
</ColumnConfig>
<ColumnConfig name="CANSHUMING" isKey="false" skipUnmodified="false">
<O>
<![CDATA[comtype;project;yearmonth;periodtype;valuetype]]></O>
</ColumnConfig>
<ColumnConfig name="CANSHU" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(len($comtype)=0 ,"",$comtype+";")+
if(len($project)=0 ,"",$project+";")+
if(len($yearmonth)=0 ,"",$yearmonth+";")+
if(len($periodtype)=0 ,"",$periodtype+";")+
if(len($valuetype)=0 ,"",$valuetype+";")]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="CANSHUMINGYUCANSHU" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(len($comtype)=0,"","comtype："+$comtype+";")+
if(len($project)=0,"","project："+$project+";")+
if(len($yearmonth)=0,"","yearmonth："+$yearmonth+";")+
if(len($periodtype)=0,"","periodtype："+$periodtype+";")+
if(len($valuetype)=0,"","valuetype："+$valuetype+";")]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="TIME" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=now()]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="DAOCHU" isKey="false" skipUnmodified="false">
<O>
<![CDATA[]]></O>
</ColumnConfig>
<ColumnConfig name="SHIFOUDIANJILIANJIE" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(len($chaolj)=0,"否",if($chaolj = $chaolj99, "否","是"))]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="LIANJIECANSHUMING" isKey="false" skipUnmodified="false">
<O>
<![CDATA[chaolj]]></O>
</ColumnConfig>
<ColumnConfig name="LIANJIECANSHU" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(len($chaolj) =0,"" ,if($chaolj = $chaolj99, "" , $chaolj ))]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="LIANJIEMINGYUCANSHU" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(len($chaolj)=0,"",if($chaolj = $chaolj99,"",INDEXOFARRAY(SPLIT(formletName,"/"),count(SPLIT(formletName,"/")))))]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="DATA_DATE" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=today()]]></Attributes>
</O>
</ColumnConfig>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[if(len($chaolj) =0,1<0 ,if($chaolj = $chaolj99, 1<0 , 0<1 )) ]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[if( $comtype = $comtype99  , 1<0 , 0<1 ) ]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[if( $periodtype = $periodtype99  , 1<0 , 0<1 ) ]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[if( $valuetype = $valuetype99  , 1<0 , 0<1 ) ]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[if( $project = $project99  , 1<0 , 0<1 ) ]]></Formula>
</Condition>
</JoinCondition>
</Condition>
</DMLConfig>
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="project"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$project]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="comtype"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$comtype]]></Attributes>
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
<Attributes name="valuetype"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$valuetype]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="chaolj"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$chaolj]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[
this.options.form.getWidgetByName("project99").setValue(project);
this.options.form.getWidgetByName("comtype99").setValue(comtype);
this.options.form.getWidgetByName("periodtype99").setValue(periodtype);
this.options.form.getWidgetByName("valuetype99").setValue(valuetype);
this.options.form.getWidgetByName("chaolj99").setValue(chaolj);
//alert(chaolj);




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
<Background name="ColorBackground" color="-16510154"/>
<Alpha alpha="1.0"/>
</Border>
<Background name="ColorBackground" color="-16510154"/>
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
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="chaolj99"/>
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
<BoundsAttr x="367" y="142" width="80" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="valuetype99"/>
<WidgetAttr invisible="true" description="">
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O>
<![CDATA[实际]]></O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="0" autoline="true"/>
<FRFont name="SimSun" style="0" size="72"/>
<border style="0" color="-723724"/>
</InnerWidget>
<BoundsAttr x="368" y="120" width="80" height="21"/>
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
<BoundsAttr x="368" y="99" width="80" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="comtype99"/>
<WidgetAttr invisible="true" description="">
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O>
<![CDATA[事业部]]></O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="0" autoline="true"/>
<FRFont name="SimSun" style="0" size="72"/>
<border style="0" color="-723724"/>
</InnerWidget>
<BoundsAttr x="368" y="78" width="80" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="project99"/>
<WidgetAttr invisible="true" description="">
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O>
<![CDATA[股份公司]]></O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="0" autoline="true"/>
<FRFont name="SimSun" style="0" size="72"/>
<border style="0" color="-723724"/>
</InnerWidget>
<BoundsAttr x="367" y="57" width="80" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="tiaozhuan1_c_c_c_c"/>
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
<WidgetName name="tiaozhuan1_c_c_c_c"/>
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
<Attributes name="chaolj"/>
<O>
<![CDATA[签约]]></O>
</Parameter>
</Parameters>
<Content>
<![CDATA[window.parent.FS.tabPane.addItem({title:"签约详情",src:"${servletURL}?reportlet=/ThreeLevelPage/OPE_FIN_SIGN_DEMO_QY.cpt&op=view&state=0"})]]></Content>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="当前决策报表对象2">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="chaolj"/>
<O>
<![CDATA[签约]]></O>
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
<Parameters>
<Parameter>
<Attributes name="chaolj"/>
<O>
<![CDATA[签约]]></O>
</Parameter>
</Parameters>
<Content>
<![CDATA[window.parent.FS.tabPane.addItem({title:"签约详情",src:"${servletURL}?reportlet=/ThreeLevelPage/OPE_FIN_SIGN_DEMO_QY.cpt&op=view&state=0"})]]></Content>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="当前决策报表对象2">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="chaolj"/>
<O>
<![CDATA[签约]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="tiaozhuan1_c_c_c_c"/>
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
<Style horizontal_alignment="2" imageLayout="1">
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
<BoundsAttr x="504" y="30" width="59" height="24"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="tiaozhuan1_c_c_c_c_c"/>
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
<WidgetName name="tiaozhuan1_c_c_c_c_c"/>
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
<![CDATA[window.parent.FS.tabPane.addItem({title:"签约详情",src:"${servletURL}?reportlet=/ThreeLevelPage/OPE_FIN_SIGN_DEMO_QY.cpt&op=view&state=1"})]]></Content>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="当前决策报表对象2">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="chaolj"/>
<O>
<![CDATA[当季预估]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="tiaozhuan1_c_c_c_c"/>
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
<![CDATA[window.parent.FS.tabPane.addItem({title:"签约详情",src:"${servletURL}?reportlet=/ThreeLevelPage/OPE_FIN_SIGN_DEMO_QY.cpt&op=view&state=1"})]]></Content>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="当前决策报表对象2">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="chaolj"/>
<O>
<![CDATA[当季预估]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="tiaozhuan1_c_c_c_c"/>
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
<FRFont name="SimSun" style="0" size="72" foreground="-16776961"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="2" imageLayout="1">
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
<BoundsAttr x="218" y="257" width="59" height="24"/>
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
<![CDATA[5760000,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[8640000,0,0,0,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
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
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="<span style='font-size: 12px;font-family: 微软雅黑;color: #fcfcfc; width='300px';'>目标 </span><span style='font-size:14px;font-family: 微软雅黑;color: #ffffff;'>" + IF(LEN(B2) = 0, 0, ROUND(B2, 1)) + "</span><span style='font-size:10px;font-family: 微软雅黑;color: #ffffff;'>亿</span>"]]></Attributes>
</O>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="128" foreground="-1"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<Attr4VanChart useHtml="true" floating="true" x="28.0" y="75.0" limitSize="false" maxHeight="15.0"/>
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
<FRFont name="微软雅黑" style="1" size="96" foreground="-16713985"/>
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
<HtmlLabel customText="function(){ return this.percentage;}" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
</AttrToolTipContent>
</labelDetail>
<gaugeValueLabel class="com.fr.plugin.chart.base.AttrLabelDetail">
<Attr showLine="false" autoAdjust="false" position="5" isCustom="true"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="80" foreground="-1118482"/>
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
<OColor colvalue="-16711681"/>
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
<MC_Attr minValue="0.0" maxValue="100.0" useType="0" areaNumber="3" mainColor="-14374913"/>
<ColorList>
<AreaColor>
<AC_Attr minValue="=1" maxValue="=0.9" color="-16726989"/>
</AreaColor>
<AreaColor>
<AC_Attr minValue="=0.9" maxValue="=0.7" color="-1517056"/>
</AreaColor>
<AreaColor>
<AC_Attr minValue="=0.7" maxValue="=0" color="-49120"/>
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
<AxisRange maxValue="=1"/>
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
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="完成率"]]></Attributes>
</O>
</meterDefinitionName>
<meterDefinitionValue>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=C2]]></Attributes>
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
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$periodtype <> "当月"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="1" r="0">
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
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="<span style='font-size: 12px;font-family: 微软雅黑;color: #fcfcfc; width='300px';'>目标 </span><span style='font-size:14px;font-family: 微软雅黑;color: #ffffff;'>" + IF(LEN(B2) = 0, 0, ROUND(B2, 1)) + "</span><span style='font-size:10px;font-family: 微软雅黑;color: #ffffff;'>亿</span>"]]></Attributes>
</O>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="128" foreground="-1"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<Attr4VanChart useHtml="true" floating="true" x="28.0" y="75.0" limitSize="false" maxHeight="15.0"/>
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
<FRFont name="微软雅黑" style="1" size="96" foreground="-16713985"/>
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
<HtmlLabel customText="function(){ return this.percentage;}" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
</AttrToolTipContent>
</labelDetail>
<gaugeValueLabel class="com.fr.plugin.chart.base.AttrLabelDetail">
<Attr showLine="false" autoAdjust="false" position="5" isCustom="true"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="80" foreground="-1118482"/>
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
<OColor colvalue="-49120"/>
<OColor colvalue="-49120"/>
<OColor colvalue="-49120"/>
<OColor colvalue="-49120"/>
<OColor colvalue="-49120"/>
<OColor colvalue="-49120"/>
<OColor colvalue="-49120"/>
<OColor colvalue="-49120"/>
<OColor colvalue="-49120"/>
<OColor colvalue="-49120"/>
<OColor colvalue="-49120"/>
<OColor colvalue="-49120"/>
<OColor colvalue="-49120"/>
<OColor colvalue="-49120"/>
<OColor colvalue="-49120"/>
<OColor colvalue="-49120"/>
<OColor colvalue="-49120"/>
<OColor colvalue="-49120"/>
<OColor colvalue="-49120"/>
<OColor colvalue="-49120"/>
<OColor colvalue="-49120"/>
<OColor colvalue="-49120"/>
<OColor colvalue="-49120"/>
<OColor colvalue="-49120"/>
<OColor colvalue="-49120"/>
<OColor colvalue="-49120"/>
<OColor colvalue="-49120"/>
<OColor colvalue="-49120"/>
<OColor colvalue="-49120"/>
<OColor colvalue="-49120"/>
<OColor colvalue="-49120"/>
<OColor colvalue="-49120"/>
</ColorList>
</AttrFillStyle>
</newPlotFillStyle>
<VanChartPlotAttr isAxisRotation="false" categoryNum="1"/>
<VanChartGaugePlotAttr gaugeStyle="slot"/>
<GaugeDetailStyle>
<GaugeDetailStyleAttr horizontalLayout="true" needleColor="-1" slotBackgroundColor="-1118482" antiClockWise="true"/>
<MapHotAreaColor>
<MC_Attr minValue="0.0" maxValue="100.0" useType="0" areaNumber="3" mainColor="-14374913"/>
<ColorList>
<AreaColor>
<AC_Attr minValue="=1" maxValue="=0.9" color="-16726989"/>
</AreaColor>
<AreaColor>
<AC_Attr minValue="=0.9" maxValue="=0.7" color="-1517056"/>
</AreaColor>
<AreaColor>
<AC_Attr minValue="=0.7" maxValue="=0" color="-49120"/>
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
<AxisRange maxValue="=1"/>
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
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="完成率"]]></Attributes>
</O>
</meterDefinitionName>
<meterDefinitionValue>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=C2]]></Attributes>
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
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[b3=3]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction">
<ColumnWidth i="8640000"/>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="2" r="0">
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
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="<span style='font-size: 12px;font-family: 微软雅黑;color: #fcfcfc; width='300px';'>目标 </span><span style='font-size:14px;font-family: 微软雅黑;color: #ffffff;'>" + IF(LEN(B2) = 0, 0, ROUND(B2, 1)) + "</span><span style='font-size:10px;font-family: 微软雅黑;color: #ffffff;'>亿</span>"]]></Attributes>
</O>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="128" foreground="-1"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<Attr4VanChart useHtml="true" floating="true" x="28.0" y="75.0" limitSize="false" maxHeight="15.0"/>
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
<FRFont name="微软雅黑" style="1" size="96" foreground="-16713985"/>
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
<HtmlLabel customText="function(){ return this.percentage;}" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
</AttrToolTipContent>
</labelDetail>
<gaugeValueLabel class="com.fr.plugin.chart.base.AttrLabelDetail">
<Attr showLine="false" autoAdjust="false" position="5" isCustom="true"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="80" foreground="-1118482"/>
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
<OColor colvalue="-1517056"/>
<OColor colvalue="-1517056"/>
<OColor colvalue="-1517056"/>
<OColor colvalue="-1517056"/>
<OColor colvalue="-1517056"/>
<OColor colvalue="-1517056"/>
<OColor colvalue="-1517056"/>
<OColor colvalue="-1517056"/>
<OColor colvalue="-1517056"/>
<OColor colvalue="-1517056"/>
<OColor colvalue="-1517056"/>
<OColor colvalue="-1517056"/>
<OColor colvalue="-1517056"/>
<OColor colvalue="-1517056"/>
<OColor colvalue="-1517056"/>
<OColor colvalue="-1517056"/>
<OColor colvalue="-1517056"/>
<OColor colvalue="-1517056"/>
<OColor colvalue="-1517056"/>
<OColor colvalue="-1517056"/>
<OColor colvalue="-1517056"/>
<OColor colvalue="-1517056"/>
<OColor colvalue="-1517056"/>
<OColor colvalue="-1517056"/>
<OColor colvalue="-1517056"/>
<OColor colvalue="-1517056"/>
<OColor colvalue="-1517056"/>
<OColor colvalue="-1517056"/>
<OColor colvalue="-1517056"/>
<OColor colvalue="-1517056"/>
<OColor colvalue="-1517056"/>
<OColor colvalue="-1517056"/>
</ColorList>
</AttrFillStyle>
</newPlotFillStyle>
<VanChartPlotAttr isAxisRotation="false" categoryNum="1"/>
<VanChartGaugePlotAttr gaugeStyle="slot"/>
<GaugeDetailStyle>
<GaugeDetailStyleAttr horizontalLayout="true" needleColor="-1" slotBackgroundColor="-1118482" antiClockWise="true"/>
<MapHotAreaColor>
<MC_Attr minValue="0.0" maxValue="100.0" useType="0" areaNumber="3" mainColor="-14374913"/>
<ColorList>
<AreaColor>
<AC_Attr minValue="=1" maxValue="=0.9" color="-16726989"/>
</AreaColor>
<AreaColor>
<AC_Attr minValue="=0.9" maxValue="=0.7" color="-1517056"/>
</AreaColor>
<AreaColor>
<AC_Attr minValue="=0.7" maxValue="=0" color="-49120"/>
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
<AxisRange maxValue="=1"/>
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
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="完成率"]]></Attributes>
</O>
</meterDefinitionName>
<meterDefinitionValue>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=C2]]></Attributes>
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
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[b3=2]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction">
<ColumnWidth i="8640000"/>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="0">
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
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="<span style='font-size: 12px;font-family: 微软雅黑;color: #fcfcfc; width='300px';'>目标 </span><span style='font-size:14px;font-family: 微软雅黑;color: #ffffff;'>" + IF(LEN(B2) = 0, 0, ROUND(B2, 1)) + "</span><span style='font-size:10px;font-family: 微软雅黑;color: #ffffff;'>亿</span>"]]></Attributes>
</O>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="128" foreground="-1"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<Attr4VanChart useHtml="true" floating="true" x="28.0" y="75.0" limitSize="false" maxHeight="15.0"/>
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
<FRFont name="微软雅黑" style="1" size="96" foreground="-16713985"/>
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
<HtmlLabel customText="function(){ return this.percentage;}" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
</AttrToolTipContent>
</labelDetail>
<gaugeValueLabel class="com.fr.plugin.chart.base.AttrLabelDetail">
<Attr showLine="false" autoAdjust="false" position="5" isCustom="true"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="80" foreground="-1118482"/>
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
<OColor colvalue="-16726989"/>
<OColor colvalue="-16726989"/>
<OColor colvalue="-16726989"/>
<OColor colvalue="-16726989"/>
<OColor colvalue="-16726989"/>
<OColor colvalue="-16726989"/>
<OColor colvalue="-16726989"/>
<OColor colvalue="-16726989"/>
<OColor colvalue="-16726989"/>
<OColor colvalue="-16726989"/>
<OColor colvalue="-16726989"/>
<OColor colvalue="-16726989"/>
<OColor colvalue="-16726989"/>
<OColor colvalue="-16726989"/>
<OColor colvalue="-16726989"/>
<OColor colvalue="-16726989"/>
<OColor colvalue="-16726989"/>
<OColor colvalue="-16726989"/>
<OColor colvalue="-16726989"/>
<OColor colvalue="-16726989"/>
<OColor colvalue="-16726989"/>
<OColor colvalue="-16726989"/>
<OColor colvalue="-16726989"/>
<OColor colvalue="-16726989"/>
<OColor colvalue="-16726989"/>
<OColor colvalue="-16726989"/>
<OColor colvalue="-16726989"/>
<OColor colvalue="-16726989"/>
<OColor colvalue="-16726989"/>
<OColor colvalue="-16726989"/>
<OColor colvalue="-16726989"/>
<OColor colvalue="-16726989"/>
</ColorList>
</AttrFillStyle>
</newPlotFillStyle>
<VanChartPlotAttr isAxisRotation="false" categoryNum="1"/>
<VanChartGaugePlotAttr gaugeStyle="slot"/>
<GaugeDetailStyle>
<GaugeDetailStyleAttr horizontalLayout="true" needleColor="-1" slotBackgroundColor="-1118482" antiClockWise="true"/>
<MapHotAreaColor>
<MC_Attr minValue="0.0" maxValue="100.0" useType="0" areaNumber="3" mainColor="-14374913"/>
<ColorList>
<AreaColor>
<AC_Attr minValue="=1" maxValue="=0.9" color="-16726989"/>
</AreaColor>
<AreaColor>
<AC_Attr minValue="=0.9" maxValue="=0.7" color="-1517056"/>
</AreaColor>
<AreaColor>
<AC_Attr minValue="=0.7" maxValue="=0" color="-49120"/>
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
<AxisRange maxValue="=1"/>
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
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="完成率"]]></Attributes>
</O>
</meterDefinitionName>
<meterDefinitionValue>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=C2]]></Attributes>
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
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[b3=1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction">
<ColumnWidth i="8640000"/>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="1">
<O t="DSColumn">
<Attributes dsName="sign_com" columnName="ACTUAL_VALUE"/>
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[INDEX_NAME]]></CNAME>
<Compare op="0">
<O>
<![CDATA[签约]]></O>
</Compare>
</Condition>
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
<Expand dir="0" leftParentDefault="false" upParentDefault="false"/>
</C>
<C c="1" r="1">
<O t="DSColumn">
<Attributes dsName="sign_com" columnName="TARGET_VALUE"/>
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[INDEX_NAME]]></CNAME>
<Compare op="0">
<O>
<![CDATA[签约]]></O>
</Compare>
</Condition>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
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
<![CDATA[A3 = "RED"]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="0">
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$periodtype = "当年"]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$periodtype = "当季"]]></Formula>
</Condition>
</JoinCondition>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction">
<ColumnWidth i="8640000"/>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0" leftParentDefault="false" upParentDefault="false"/>
</C>
<C c="2" r="1">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(B2 = 0, 0, A2 / B2)]]></Attributes>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="3" r="1">
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
<C c="1" r="2" s="0">
<O t="DSColumn">
<Attributes dsName="color" columnName="LD"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="2" r="2" s="0">
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="3" r="2" s="0">
<PrivilegeControl/>
<Expand dir="0" leftParentDefault="false" upParentDefault="false"/>
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
<FRFont name="SimSun" style="0" size="72" foreground="-1"/>
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
<![CDATA[5760000,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[8640000,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
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
<Top style="1" color="-65536"/>
<Bottom style="1" color="-65536"/>
<Left style="1" color="-65536"/>
<Right style="1" color="-65536"/>
</Border>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</body>
</InnerWidget>
<BoundsAttr x="130" y="73" width="140" height="126"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="tiaozhuan1_c_c"/>
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
<WidgetName name="tiaozhuan1_c_c"/>
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
<![CDATA[window.parent.FS.tabPane.addItem({title:"签约排名详情",src:"${servletURL}?reportlet=/ThreeLevelPage/OPE_FIN_SIGN_QY_PM.cpt&op=view"})]]></Content>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="当前决策报表对象2">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="chaolj"/>
<O>
<![CDATA[排名]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="tiaozhuan1_c_c_c_c"/>
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
<NameJavaScript name="JavaScript脚本2">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="chaolj"/>
<O>
<![CDATA[排名]]></O>
</Parameter>
</Parameters>
<Content>
<![CDATA[window.parent.FS.tabPane.addItem({title:"签约排名详情",src:"${servletURL}?reportlet=/ThreeLevelPage/OPE_FIN_SIGN_QY_PM.cpt&op=view"})]]></Content>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="当前决策报表对象2">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="chaolj"/>
<O>
<![CDATA[排名]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="tiaozhuan1_c_c_c_c"/>
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
<Style horizontal_alignment="2" imageLayout="1">
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
<BoundsAttr x="789" y="30" width="59" height="24"/>
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
<![CDATA[1152000,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[1333500,4000500,190500,1872000,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" cs="4" s="0">
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
<BoundsAttr x="11" y="257" width="180" height="27"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report4_c"/>
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
<WidgetName name="report4_c"/>
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
<![CDATA[1872000,2095500,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[1440000,3162300,2743200,2743200,2743200,2743200,1440000,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" cs="4" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1" cs="5" s="1">
<O t="RichText">
<RichText>
<RichChar styleIndex="2">
<text>
<![CDATA[预估完成率]]></text>
</RichChar>
<RichChar styleIndex="3">
<text>
<![CDATA[${=c16}]]></text>
</RichChar>
<RichChar styleIndex="2">
<text>
<![CDATA[%]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="1" r="2" cs="5" rs="13">
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
<AxisRange maxValue="=if(len(sign_JDYG.GROUP(VALUE1))=0,0,max(sign_JDYG.GROUP(VALUE1))*1.3)"/>
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
<Attr isCommon="false"/>
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
<HtmlLabel customText="function(){ return this.value+&apos;亿&apos;;}" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
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
<AxisRange maxValue="=if(len(sign_JDYG.GROUP(VALUE1))=0,0,max(sign_JDYG.GROUP(VALUE1))*1.3)"/>
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
<AxisRange maxValue="=if(len(sign_JDYG.GROUP(VALUE1))=0,0,max(sign_JDYG.GROUP(VALUE1))*1.3)"/>
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
<![CDATA[sign_JDYG]]></Name>
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
<C c="6" r="4">
<O>
<![CDATA[  ]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="15">
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
<C c="2" r="15">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF( or(D16=0, LEN(D16)=0), "--", round(E16/D16*100, 0) )]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="15">
<O t="DSColumn">
<Attributes dsName="sign_JDYG" columnName="VALUE1"/>
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
<C c="4" r="15">
<O t="DSColumn">
<Attributes dsName="sign_JDYG" columnName="VALUE1"/>
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
<Style horizontal_alignment="2" vertical_alignment="1" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="96" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
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
<FRFont name="微软雅黑" style="0" size="152" foreground="-16724737"/>
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
<![CDATA[723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" cs="5" rs="13">
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
<BoundsAttr x="7" y="257" width="270" height="202"/>
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
<![CDATA[723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[1872000,576000,1872000,1872000,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" cs="3" rs="2" s="0">
<O>
<![CDATA[排名TOP10]]></O>
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
<BoundsAttr x="580" y="29" width="180" height="27"/>
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
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$periodtype+"环京外埠完成情况"]]></Attributes>
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
<BoundsAttr x="293" y="257" width="178" height="27"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report1_c_c_c"/>
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
<WidgetName name="report1_c_c_c"/>
<WidgetAttr invisible="true" description="">
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
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="1">
<IM>
<![CDATA[!@e-#reXHH7h#eD$31&+%7s)Y;?-[s$NL/,%L<7=!!)h'k*5oH!:`WK5u`*!D:6U"!`8s;n\
MYK.ucek0O73d(kR[E2MJLOnJMHGp';i<:5Q\OL@0s8>tA1aQU4&"rWbVqAt6i$iFBTCk$5p
3L?9.d@uSA_J.Yt.p9G)#0Y#Y`NcN%@*5hs1W$6oo2S7,#/V5AJit>5N,q`G6%7k3H':dtdA
*'5]AX9!T?nUVr\0uH'c]A/q(&/$/6@e%&MNqisg#3E,`CS"4e^"jQgs3/[LK.q6e5)IN9U0f$
o/a?#CM!7+d**/AddXCogO$0+nKWaHnNjg+Ub]A=Qk1^=#r_q-CJCRAPjg3n$1*+)(hFMNDr'
4E0Qc!!!!j78?7R6=>B~
]]></IM>
</Background>
<Alpha alpha="1.0"/>
</Border>
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="1">
<IM>
<![CDATA[!@e-#reXHH7h#eD$31&+%7s)Y;?-[s$NL/,%L<7=!!)h'k*5oH!:`WK5u`*!D:6U"!`8s;n\
MYK.ucek0O73d(kR[E2MJLOnJMHGp';i<:5Q\OL@0s8>tA1aQU4&"rWbVqAt6i$iFBTCk$5p
3L?9.d@uSA_J.Yt.p9G)#0Y#Y`NcN%@*5hs1W$6oo2S7,#/V5AJit>5N,q`G6%7k3H':dtdA
*'5]AX9!T?nUVr\0uH'c]A/q(&/$/6@e%&MNqisg#3E,`CS"4e^"jQgs3/[LK.q6e5)IN9U0f$
o/a?#CM!7+d**/AddXCogO$0+nKWaHnNjg+Ub]A=Qk1^=#r_q-CJCRAPjg3n$1*+)(hFMNDr'
4E0Qc!!!!j78?7R6=>B~
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
<![CDATA[1440000,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[1440000,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<O t="Image">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320@UNT6!5]A^l5`pg"AnMqtfO?sK*()4<]AKN`cpOIkrbJs;R?[D<)/t
U4,k3op+N!J>m)&dlmnL,HtUNdK6@T'FXV3FsD<IoZ=@!0BFl0@H;c7,Fn!!~
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
<BoundsAttr x="819" y="27" width="29" height="29"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report1_c_c"/>
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
<WidgetName name="report1_c_c"/>
<WidgetAttr invisible="true" description="">
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
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="1">
<IM>
<![CDATA[!@e-#reXHH7h#eD$31&+%7s)Y;?-[s$NL/,%L<7=!!)h'k*5oH!:`WK5u`*!D:6U"!`8s;n\
MYK.ucek0O73d(kR[E2MJLOnJMHGp';i<:5Q\OL@0s8>tA1aQU4&"rWbVqAt6i$iFBTCk$5p
3L?9.d@uSA_J.Yt.p9G)#0Y#Y`NcN%@*5hs1W$6oo2S7,#/V5AJit>5N,q`G6%7k3H':dtdA
*'5]AX9!T?nUVr\0uH'c]A/q(&/$/6@e%&MNqisg#3E,`CS"4e^"jQgs3/[LK.q6e5)IN9U0f$
o/a?#CM!7+d**/AddXCogO$0+nKWaHnNjg+Ub]A=Qk1^=#r_q-CJCRAPjg3n$1*+)(hFMNDr'
4E0Qc!!!!j78?7R6=>B~
]]></IM>
</Background>
<Alpha alpha="1.0"/>
</Border>
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="1">
<IM>
<![CDATA[!@e-#reXHH7h#eD$31&+%7s)Y;?-[s$NL/,%L<7=!!)h'k*5oH!:`WK5u`*!D:6U"!`8s;n\
MYK.ucek0O73d(kR[E2MJLOnJMHGp';i<:5Q\OL@0s8>tA1aQU4&"rWbVqAt6i$iFBTCk$5p
3L?9.d@uSA_J.Yt.p9G)#0Y#Y`NcN%@*5hs1W$6oo2S7,#/V5AJit>5N,q`G6%7k3H':dtdA
*'5]AX9!T?nUVr\0uH'c]A/q(&/$/6@e%&MNqisg#3E,`CS"4e^"jQgs3/[LK.q6e5)IN9U0f$
o/a?#CM!7+d**/AddXCogO$0+nKWaHnNjg+Ub]A=Qk1^=#r_q-CJCRAPjg3n$1*+)(hFMNDr'
4E0Qc!!!!j78?7R6=>B~
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
<![CDATA[1440000,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[1440000,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<O t="Image">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320@UNT6!5]A^l5`pg"AnMqtfO?sK*()4<]AKN`cpOIkrbJs;R?[D<)/t
U4,k3op+N!J>m)&dlmnL,HtUNdK6@T'FXV3FsD<IoZ=@!0BFl0@H;c7,Fn!!~
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
<BoundsAttr x="519" y="257" width="29" height="29"/>
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
<![CDATA[1333500,4000500,190500,1872000,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" cs="4" s="0">
<O>
<![CDATA[签约完成情况]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="0">
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
<BoundsAttr x="13" y="29" width="388" height="27"/>
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
<![CDATA[723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" cs="4" s="0">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="数据截止日期："+sql("oracle_test", "select to_char(to_date(max(data_date), 'YYYY-MM-DD'), 'YYYY-MM-DD') from dm_mcl_acct ", 1)]]></Attributes>
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
<BoundsAttr x="653" y="4" width="199" height="23"/>
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
<![CDATA[1143000,864000,0,723900,723900,723900,723900,723900,723900,723900,723900,0,0,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[800100,2743200,2743200,2743200,2743200,2743200,2743200,1143000,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" cs="3" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1" cs="3" s="1">
<O t="RichText">
<RichText>
<RichChar styleIndex="2">
<text>
<![CDATA[环京]]></text>
</RichChar>
<RichChar styleIndex="3">
<text>
<![CDATA[${=if(len(d14)=0, 0, format(ROUND(D14,1),"#0.#") )}]]></text>
</RichChar>
<RichChar styleIndex="2">
<text>
<![CDATA[亿]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="4" r="1" cs="3" s="1">
<O t="RichText">
<RichText>
<RichChar styleIndex="2">
<text>
<![CDATA[外埠]]></text>
</RichChar>
<RichChar styleIndex="3">
<text>
<![CDATA[${=if(len(c14)=0, 0, format(ROUND(c14,1),"#0.#") )}]]></text>
</RichChar>
<RichChar styleIndex="2">
<text>
<![CDATA[亿]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="1" r="2" cs="6" rs="11">
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
<Attr enable="true"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0.#亿]]></Format>
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
<HtmlLabel customText="function(){ return this.seriesName+this.value+&quot;亿&quot;+this.percentage;}" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
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
<FRFont name="微软雅黑" style="0" size="72" foreground="-1"/>
</Legend>
<Attr4VanChart floating="false" x="80.0" y="40.0" limitSize="false" maxHeight="15.0" isHighlight="true"/>
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
<NameJavaScriptGroup>
<NameJavaScript name="JavaScript1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[/*window.parent.FS.tabPane.addItem({title:"环京外埠完成情况",src:"${servletURL}?reportlet=HX_OPERATING_CONTROL%2FFINANCE%2FOPE_FIN_SIGN_IN_OUT.cpt"}) */]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
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
<PieAttr4VanChart roseType="normal" startAngle="0.0" endAngle="360.0" innerRadius="70.0" supportRotation="false"/>
<VanChartRadius radiusType="auto" radius="100"/>
</Plot>
<ChartDefinition>
<OneValueCDDefinition seriesName="ORG_CLASSIFY" valueName="ACTUAL_VALUE" function="com.fr.data.util.function.NoneFunction">
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[sign_hjwb]]></Name>
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
<Expand/>
</C>
<C c="7" r="2">
<O>
<![CDATA[   ]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="13">
<O t="DSColumn">
<Attributes dsName="sign_hjwb" columnName="ACTUAL_VALUE"/>
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[ORG_CLASSIFY]]></CNAME>
<Compare op="0">
<O>
<![CDATA[外埠]]></O>
</Compare>
</Condition>
<Complex reselect="true"/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
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
<C c="3" r="13">
<O t="DSColumn">
<Attributes dsName="sign_hjwb" columnName="ACTUAL_VALUE"/>
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[ORG_CLASSIFY]]></CNAME>
<Compare op="0">
<O>
<![CDATA[环京]]></O>
</Compare>
</Condition>
<Complex reselect="true"/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
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
<Style horizontal_alignment="2" vertical_alignment="1" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="96" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
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
<FRFont name="微软雅黑" style="0" size="168" foreground="-16713985"/>
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
<![CDATA[723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" cs="5" rs="11">
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
<PieAttr4VanChart roseType="normal" startAngle="0.0" endAngle="360.0" innerRadius="0.0" supportRotation="false"/>
<VanChartRadius radiusType="auto" radius="100"/>
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
<BoundsAttr x="288" y="257" width="275" height="202"/>
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
<![CDATA[1872000,2095500,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[1440000,3162300,2743200,2743200,2743200,2743200,1440000,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" cs="4" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1" cs="5" s="1">
<O t="RichText">
<RichText>
<RichChar styleIndex="2">
<text>
<![CDATA[预估完成率]]></text>
</RichChar>
<RichChar styleIndex="3">
<text>
<![CDATA[${=c16}]]></text>
</RichChar>
<RichChar styleIndex="2">
<text>
<![CDATA[%]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="1" r="2" cs="5" rs="13">
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
<AxisRange maxValue="=if(len(JDYG.GROUP(VALUE1))=0,0,max(JDYG.GROUP(VALUE1))*1.3) "/>
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
<Attr isCommon="false"/>
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
<HtmlLabel customText="function(){ return this.value+&apos;亿&apos;;}" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
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
<AxisRange maxValue="=if(len(JDYG.GROUP(VALUE1))=0,0,max(JDYG.GROUP(VALUE1))*1.3) "/>
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
<AxisRange maxValue="=if(len(JDYG.GROUP(VALUE1))=0,0,max(JDYG.GROUP(VALUE1))*1.3) "/>
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
<C c="6" r="4">
<O>
<![CDATA[  ]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="15">
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
<C c="2" r="15">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF( or(D16=0, LEN(D16)=0), "--", round(E16/D16*100, 0) )]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="15">
<O t="DSColumn">
<Attributes dsName="sign_JDYG" columnName="VALUE1"/>
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
<C c="4" r="15">
<O t="DSColumn">
<Attributes dsName="sign_JDYG" columnName="VALUE1"/>
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
<Style horizontal_alignment="2" vertical_alignment="1" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="96" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
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
<FRFont name="微软雅黑" style="0" size="152" foreground="-16724737"/>
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
<![CDATA[723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" cs="5" rs="13">
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
<BoundsAttr x="7" y="577" width="270" height="193"/>
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
<![CDATA[720000,0,504000,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[266700,576000,1872000,288000,1872000,576000,2592000,0,1872000,576000,1872000,571500,1524000,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="1" r="0" cs="4" rs="2" s="0">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="5" r="0">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="6" r="0">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="7" r="0">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="8" r="0">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="9" r="0">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="10" r="0">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="11" r="0">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="12" r="0">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="0" r="1">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="2" s="1">
<O>
<![CDATA[事业部]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="当前决策报表对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="comtype"/>
<O>
<![CDATA[事业部]]></O>
</Parameter>
<Parameter>
<Attributes name="project"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$project]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="periodtype"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$periodtype]]></Attributes>
</O>
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
</NameJavaScriptGroup>
<CellGUIAttr adjustmode="2"/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$comtype = "事业部"]]></Formula>
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
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性4]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$project = "住宅"]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$project = "其他"]]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ColorBackground"/>
</HighlightAction>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="2" s="2">
<PrivilegeControl/>
<CellGUIAttr adjustmode="2"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="4" r="2" s="1">
<O>
<![CDATA[区域]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="当前决策报表对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="comtype"/>
<O>
<![CDATA[区域]]></O>
</Parameter>
<Parameter>
<Attributes name="periodtype"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$periodtype]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="project"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$project]]></Attributes>
</O>
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
</NameJavaScriptGroup>
<CellGUIAttr adjustmode="2"/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$comtype = "区域"]]></Formula>
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
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性4]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$project = "住宅"]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$project = "其他"]]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ColorBackground"/>
</HighlightAction>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="5" r="2" s="2">
<PrivilegeControl/>
<CellGUIAttr adjustmode="2"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="6" r="2" s="1">
<PrivilegeControl/>
<CellGUIAttr adjustmode="2"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="7" r="2" s="1">
<O>
<![CDATA[目标]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="当前决策报表对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="valuetype"/>
<O>
<![CDATA[目标]]></O>
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
</NameJavaScriptGroup>
<CellGUIAttr adjustmode="2"/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$valuetype = "目标"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="4">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320!n'h//B5L1,YPe`3.[<tVi,%U`LOCR2KCi,$Fi'-rt`;ujVi,EZY
ATp-S4Ntde^ddY8?&c-$B6.,6K1>&]A#]A<^BHS"b#t*63!9p8)Lh0OXAuM0Yq2=FGZo9_A<o>
:4!/,iK;YcBb;uPS-3+~
]]></IM>
</Background>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="8" r="2" s="1">
<O>
<![CDATA[实际]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="当前决策报表对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="valuetype"/>
<O>
<![CDATA[实际]]></O>
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
</NameJavaScriptGroup>
<CellGUIAttr adjustmode="2"/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$valuetype = "实际"]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$valuetype = ""]]></Formula>
</Condition>
</JoinCondition>
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
<C c="9" r="2" s="2">
<PrivilegeControl/>
<CellGUIAttr adjustmode="2"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="10" r="2" s="1">
<O>
<![CDATA[完成率]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="当前决策报表对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="valuetype"/>
<O>
<![CDATA[完成率]]></O>
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
</NameJavaScriptGroup>
<CellGUIAttr adjustmode="2"/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$valuetype = "完成率"]]></Formula>
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
<C c="0" r="3">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$valuetype = "目标"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="1" r="3" cs="10" rs="15">
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
<![CDATA[#0.#亿]]></Format>
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
<NameJavaScriptGroup>
<NameJavaScript name="JavaScript1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[/*window.parent.FS.tabPane.addItem({title:"排名",src:"${servletURL}?reportlet=HX_OPERATING_CONTROL%2FFINANCE%2FOPE_FIN_SIGN_RANK.cpt"}) */]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
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
<FRFont name="微软雅黑" style="0" size="80" foreground="-10066330"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="false"/>
<AxisLineStyle AxisStyle="0" MainGridStyle="1"/>
<newLineColor lineColor="-5197648"/>
<AxisPosition value="3"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
</Attr>
</TextAttr>
<AxisLabelCount value="=1"/>
<AxisRange maxValue="=if(len(sign_target.group(target_value)) = 0, 0, max(sign_target.group(target_value)) * 1.3)"/>
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
<FRFont name="微软雅黑" style="0" size="64" foreground="-10066330"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="true"/>
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
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="true" isDiscardNullCate="false" isDiscardNullSeries="false">
<SeriesPresent class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=if(valuetype="目标","目标值","实际值")]]></Content>
</SeriesPresent>
</Top>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[sign_target]]></Name>
</TableData>
<CategoryName value="ORG_SNAME"/>
<ChartSummaryColumn name="TARGET_VALUE" function="com.fr.data.util.function.NoneFunction" customName="目标"/>
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
<C c="0" r="4">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$valuetype = "目标"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="12" r="4">
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
<![CDATA[$valuetype = "目标"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
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
<![CDATA[$valuetype = "目标"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
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
<![CDATA[$valuetype = "目标"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
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
<![CDATA[$valuetype = "目标"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
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
<![CDATA[$valuetype = "目标"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
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
<![CDATA[$valuetype = "目标"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
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
<![CDATA[$valuetype = "目标"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
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
<![CDATA[$valuetype = "目标"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
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
<![CDATA[$valuetype = "目标"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
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
<![CDATA[$valuetype = "目标"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
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
<![CDATA[$valuetype = "目标"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
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
<![CDATA[$valuetype = "目标"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
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
<![CDATA[$valuetype = "目标"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
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
<![CDATA[$valuetype <> "完成率"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="1" r="18" cs="10" rs="15">
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
<HtmlLabel customText="function(){ return this.category+this.seriesName+this.value;}" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
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
<HtmlLabel customText="function(){ return this.value+&apos;亿&apos;;}" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
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
<NameJavaScriptGroup>
<NameJavaScript name="JavaScript1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[/*window.parent.FS.tabPane.addItem({title:"排名",src:"${servletURL}?reportlet=HX_OPERATING_CONTROL%2FFINANCE%2FOPE_FIN_SIGN_RANK.cpt"}) */]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
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
<FRFont name="微软雅黑" style="0" size="80" foreground="-10066330"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="false"/>
<AxisLineStyle AxisStyle="0" MainGridStyle="1"/>
<newLineColor lineColor="-5197648"/>
<AxisPosition value="3"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
</Attr>
</TextAttr>
<AxisLabelCount value="=1"/>
<AxisRange maxValue="=if(len(sign_lv.group(lv)) = 0, 1, max(sign_lv.group(lv)) * 1.3)"/>
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
<FRFont name="微软雅黑" style="0" size="64" foreground="-10066330"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="true"/>
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
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="true" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[sign_lv]]></Name>
</TableData>
<CategoryName value="ORG_SNAME"/>
<ChartSummaryColumn name="LV" function="com.fr.data.util.function.NoneFunction" customName="完成率"/>
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
<C c="0" r="19">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$valuetype <> "完成率"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
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
<![CDATA[$valuetype <> "完成率"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
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
<![CDATA[$valuetype <> "完成率"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
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
<![CDATA[$valuetype <> "完成率"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
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
<![CDATA[$valuetype <> "完成率"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
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
<![CDATA[$valuetype <> "完成率"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
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
<![CDATA[$valuetype <> "完成率"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
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
<![CDATA[$valuetype <> "完成率"]]></Formula>
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
<![CDATA[$valuetype <> "完成率"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
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
<![CDATA[$valuetype <> "完成率"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
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
<![CDATA[$valuetype <> "完成率"]]></Formula>
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
<![CDATA[$valuetype <> "完成率"]]></Formula>
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
<![CDATA[$valuetype <> "完成率"]]></Formula>
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
<![CDATA[$valuetype <> "完成率"]]></Formula>
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
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$valuetype <> "实际"]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$valuetype <> "目标"]]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="1" r="33" cs="10" rs="15">
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
<Attr isCommon="false"/>
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
<HtmlLabel customText="function(){ return this.value+&apos;亿&apos;;}" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
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
<![CDATA[#0.#亿]]></Format>
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
<NameJavaScriptGroup>
<NameJavaScript name="JavaScript1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[/*window.parent.FS.tabPane.addItem({title:"排名",src:"${servletURL}?reportlet=HX_OPERATING_CONTROL%2FFINANCE%2FOPE_FIN_SIGN_RANK.cpt"}) */]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
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
<FRFont name="微软雅黑" style="0" size="80" foreground="-10066330"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="false"/>
<AxisLineStyle AxisStyle="0" MainGridStyle="1"/>
<newLineColor lineColor="-5197648"/>
<AxisPosition value="3"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
</Attr>
</TextAttr>
<AxisLabelCount value="=1"/>
<AxisRange maxValue="=if(len(sign_actual.group(actual_value)) = 0, 0, max(sign_actual.group(actual_value)) * 1.3)"/>
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
<FRFont name="微软雅黑" style="0" size="64" foreground="-10066330"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="true"/>
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
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="true" isDiscardNullCate="false" isDiscardNullSeries="false">
<SeriesPresent class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=if(valuetype="目标","目标值","实际值")]]></Content>
</SeriesPresent>
</Top>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[sign_actual]]></Name>
</TableData>
<CategoryName value="ORG_SNAME"/>
<ChartSummaryColumn name="ACTUAL_VALUE" function="com.fr.data.util.function.NoneFunction" customName="ACTUAL_VALUE"/>
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
<C c="0" r="34">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$valuetype <> "实际"]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$valuetype <> "目标"]]></Formula>
</Condition>
</JoinCondition>
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
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$valuetype <> "实际"]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$valuetype <> "目标"]]></Formula>
</Condition>
</JoinCondition>
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
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$valuetype <> "实际"]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$valuetype <> "目标"]]></Formula>
</Condition>
</JoinCondition>
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
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$valuetype <> "实际"]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$valuetype <> "目标"]]></Formula>
</Condition>
</JoinCondition>
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
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$valuetype <> "实际"]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$valuetype <> "目标"]]></Formula>
</Condition>
</JoinCondition>
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
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$valuetype <> "实际"]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$valuetype <> "目标"]]></Formula>
</Condition>
</JoinCondition>
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
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$valuetype <> "实际"]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$valuetype <> "目标"]]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="41">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$valuetype <> "实际"]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$valuetype <> "目标"]]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="42">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$valuetype <> "实际"]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$valuetype <> "目标"]]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="43">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$valuetype <> "实际"]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$valuetype <> "目标"]]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="44">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$valuetype <> "实际"]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$valuetype <> "目标"]]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="45">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$valuetype <> "实际"]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$valuetype <> "目标"]]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="46">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$valuetype <> "实际"]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$valuetype <> "目标"]]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="47">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$valuetype <> "实际"]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$valuetype <> "目标"]]></Formula>
</Condition>
</JoinCondition>
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
<Style vertical_alignment="1" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="96" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
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
<BoundsAttr x="572" y="30" width="279" height="430"/>
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
<![CDATA[1152000,0,936000,228600,1440000,1152000,1440000,864000,576000,723900,0,1152000,1152000,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[576000,1333500,864000,3600000,288000,2160000,3168000,144000,1152000,2304000,3168000,144000,3168000,2592000,576000,288000,2304000,2743200,2304000,2592000,2592000,3168000,3168000,3168000,288000,288000,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="1" r="0" cs="8" s="0">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="10" r="0">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="11" r="0">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="12" r="0">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="13" r="0">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="15" r="0">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="16" r="0">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="18" r="0">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="19" r="0">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="20" r="0">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="21" r="0">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="22" r="0">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="23" r="0">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="24" r="0">
<O>
<![CDATA[   ]]></O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="25" r="0">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="0" r="2">
<PrivilegeControl/>
<CellPageAttr/>
<Expand/>
</C>
<C c="1" r="2">
<PrivilegeControl/>
<CellPageAttr/>
<Expand/>
</C>
<C c="2" r="2" cs="2" s="1">
<O>
<![CDATA[股份公司]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="report2">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="project"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="periodtype"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$periodtype]]></Attributes>
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
<NameJavaScript name="report3">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="project"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="periodtype"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$periodtype]]></Attributes>
</O>
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
<NameJavaScript name="report4">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="project"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report4_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="report5">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="project"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="periodtype"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$periodtype]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report5"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="report8">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="project"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="periodtype"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$periodtype]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report8_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<CellGUIAttr adjustmode="2"/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$project = $$$]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320!n)'R/Bu!8,epopC]AmX-Sh?$H'm&5<>KGP1+Md90[FcpC+igX\(7
*POl=EKJeOc(`/rSK0<cu.GI?[.=LU@AUo3(CTraf.7W.&t&h8k&;bN;=IK7hpHq"KXEaSbR
+E@XS6>`CX<p@#a'h:IT;1KJr%luSpABH)T%X.RQrVh?As~
]]></IM>
</Background>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="4" r="2" s="2">
<PrivilegeControl/>
<CellGUIAttr adjustmode="2"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="5" r="2" cs="2" s="1">
<O>
<![CDATA[新城全口径]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="report2">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="project"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="periodtype"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$periodtype]]></Attributes>
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
<NameJavaScript name="report3">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="project"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="periodtype"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$periodtype]]></Attributes>
</O>
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
<NameJavaScript name="report4">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="project"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report4_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="report5">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="project"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="periodtype"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$periodtype]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report5"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="report8">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="project"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="periodtype"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$periodtype]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report8_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<CellGUIAttr adjustmode="2"/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$project = $$$]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320!n)'R/Bu!8,epopC]AmX-Sh?$H'm&5<>KGP1+Md90[FcpC+igX\(7
*POl=EKJeOc(`/rSK0<cu.GI?[.=LU@AUo3(CTraf.7W.&t&h8k&;bN;=IK7hpHq"KXEaSbR
+E@XS6>`CX<p@#a'h:IT;1KJr%luSpABH)T%X.RQrVh?As~
]]></IM>
</Background>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="7" r="2" s="2">
<PrivilegeControl/>
<CellGUIAttr adjustmode="2"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="8" r="2" cs="2" s="1">
<O>
<![CDATA[新城]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="report2">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="project"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="periodtype"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$periodtype]]></Attributes>
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
<NameJavaScript name="report3">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="project"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="periodtype"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$periodtype]]></Attributes>
</O>
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
<NameJavaScript name="report4">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="project"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report4_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="report5">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="project"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="periodtype"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$periodtype]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report5"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="report8">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="project"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="periodtype"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$periodtype]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report8_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<CellGUIAttr adjustmode="2"/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$project = $$$]]></Formula>
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
<C c="10" r="2" s="1">
<O>
<![CDATA[住宅]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="report2">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="project"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="periodtype"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$periodtype]]></Attributes>
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
<NameJavaScript name="report3">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="project"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="periodtype"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$periodtype]]></Attributes>
</O>
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
<NameJavaScript name="report4">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="project"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report4_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="report5">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="project"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="periodtype"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$periodtype]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report5"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="report8">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="project"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="periodtype"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$periodtype]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report8_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<CellGUIAttr adjustmode="2"/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$project = $$$]]></Formula>
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
<C c="11" r="2" s="2">
<PrivilegeControl/>
<CellGUIAttr adjustmode="2"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="12" r="2" s="1">
<O>
<![CDATA[小镇]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="report2">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="project"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="periodtype"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$periodtype]]></Attributes>
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
<NameJavaScript name="report3">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="project"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="periodtype"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$periodtype]]></Attributes>
</O>
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
<NameJavaScript name="report4">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="project"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report4_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="report5">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="project"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="periodtype"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$periodtype]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report5"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="report8">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="project"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="periodtype"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$periodtype]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report8_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<CellGUIAttr adjustmode="2"/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$project = $$$]]></Formula>
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
<C c="13" r="2" cs="2" s="1">
<O>
<![CDATA[其他]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="report2">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="project"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="periodtype"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$periodtype]]></Attributes>
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
<NameJavaScript name="report3">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="project"/>
<O>
<![CDATA[其他]]></O>
</Parameter>
<Parameter>
<Attributes name="periodtype"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$periodtype]]></Attributes>
</O>
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
<NameJavaScript name="tiaozhuan1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="project"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="tiaozhuan1_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="report4">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="project"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="periodtype"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$periodtype]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report4_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="report5">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="project"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="periodtype"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$periodtype]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report5"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="report8">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="project"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="periodtype"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$periodtype]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report8_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<CellGUIAttr adjustmode="2"/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$project = $$$]]></Formula>
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
<C c="15" r="2" s="2">
<PrivilegeControl/>
<CellPageAttr/>
<Expand/>
</C>
<C c="16" r="2" s="2">
<PrivilegeControl/>
<CellPageAttr/>
<Expand/>
</C>
<C c="17" r="2" s="2">
<PrivilegeControl/>
<CellPageAttr/>
<Expand/>
</C>
<C c="18" r="2" s="2">
<PrivilegeControl/>
<CellPageAttr/>
<Expand/>
</C>
<C c="19" r="2" s="2">
<PrivilegeControl/>
<CellPageAttr/>
<Expand/>
</C>
<C c="20" r="2" s="2">
<PrivilegeControl/>
<CellPageAttr/>
<Expand/>
</C>
<C c="21" r="2" s="1">
<O>
<![CDATA[当年]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="report2">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="periodtype"/>
<O>
<![CDATA[当年]]></O>
</Parameter>
<Parameter>
<Attributes name="project"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$project]]></Attributes>
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
<NameJavaScript name="report3">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="periodtype"/>
<O>
<![CDATA[当年]]></O>
</Parameter>
<Parameter>
<Attributes name="project"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$project]]></Attributes>
</O>
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
<NameJavaScript name="report5">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="project"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$project]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="periodtype"/>
<O>
<![CDATA[当年]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report5"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="report7">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="periodtype"/>
<O>
<![CDATA[当年]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report7_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="report8">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="periodtype"/>
<O>
<![CDATA[当年]]></O>
</Parameter>
<Parameter>
<Attributes name="project"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$project]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report8_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<CellGUIAttr adjustmode="2"/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[periodtype = "当年"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320!n,pj/B>R2,ZAq0Y6.\USh?$H'm&6gg;qt*^sdJsbVPBqeFt/7%i
)8;'fI@OLYlD;To2.6/\EY\[lQM(rU/W;C4!G61Y.E8ORQ='@KThdmF(76Z8NsJlsf,n>>kQ
8XQ/&sE3u$u43Ro)B]AX$I-VQsA\rptafMr3aQGM&#cXiYG65'>~
]]></IM>
</Background>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="22" r="2" s="1">
<O>
<![CDATA[当季]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="report2">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="periodtype"/>
<O>
<![CDATA[当季]]></O>
</Parameter>
<Parameter>
<Attributes name="project"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$project]]></Attributes>
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
<NameJavaScript name="report3">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="periodtype"/>
<O>
<![CDATA[当季]]></O>
</Parameter>
<Parameter>
<Attributes name="project"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$project]]></Attributes>
</O>
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
<NameJavaScript name="report5">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="project"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$project]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="periodtype"/>
<O>
<![CDATA[当季]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report5"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="report7">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="periodtype"/>
<O>
<![CDATA[当季]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report7_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="report8">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="periodtype"/>
<O>
<![CDATA[当季]]></O>
</Parameter>
<Parameter>
<Attributes name="project"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$project]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report8_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<CellGUIAttr adjustmode="2"/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[periodtype = "当季"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320!n,pj/B>R2,ZAq0Y6.\USh?$H'm&6gg;qt*^sdJsbVPBqeFt/7%i
)8;'fI@OLYlD;To2.6/\EY\[lQM(rU/W;C4!G61Y.E8ORQ='@KThdmF(76Z8NsJlsf,n>>kQ
8XQ/&sE3u$u43Ro)B]AX$I-VQsA\rptafMr3aQGM&#cXiYG65'>~
]]></IM>
</Background>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="23" r="2" s="1">
<O>
<![CDATA[当月]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="report2">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="periodtype"/>
<O>
<![CDATA[当月]]></O>
</Parameter>
<Parameter>
<Attributes name="project"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$project]]></Attributes>
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
<NameJavaScript name="report3">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="periodtype"/>
<O>
<![CDATA[当月]]></O>
</Parameter>
<Parameter>
<Attributes name="project"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$project]]></Attributes>
</O>
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
<NameJavaScript name="report5">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="project"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$project]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="periodtype"/>
<O>
<![CDATA[当月]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report5"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="report7">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="periodtype"/>
<O>
<![CDATA[当月]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report7_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="report8">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="periodtype"/>
<O>
<![CDATA[当月]]></O>
</Parameter>
<Parameter>
<Attributes name="project"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$project]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report8_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<CellGUIAttr adjustmode="2"/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[periodtype = "当月"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320!n,pj/B>R2,ZAq0Y6.\USh?$H'm&6gg;qt*^sdJsbVPBqeFt/7%i
)8;'fI@OLYlD;To2.6/\EY\[lQM(rU/W;C4!G61Y.E8ORQ='@KThdmF(76Z8NsJlsf,n>>kQ
8XQ/&sE3u$u43Ro)B]AX$I-VQsA\rptafMr3aQGM&#cXiYG65'>~
]]></IM>
</Background>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="24" r="2">
<PrivilegeControl/>
<CellPageAttr/>
<Expand/>
</C>
<C c="25" r="2">
<PrivilegeControl/>
<CellPageAttr/>
<Expand/>
</C>
<C c="0" r="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="16" r="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="4" cs="8" rs="5">
<PrivilegeControl/>
<Expand/>
</C>
<C c="14" r="4" cs="11" rs="11">
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
<FillStyleName fillStyleName=""/>
<isCustomFillStyle isCustomFillStyle="true"/>
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
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
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
<AxisPosition value="5"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
</Attr>
</TextAttr>
<AxisLabelCount value="=1"/>
<AxisRange maxValue="=max(sign_link.group(target_value), sign_link.group(actual_value)) * 1.2"/>
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
<AxisPosition value="5"/>
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
<AxisRange minValue="=0" maxValue="=max(sign_link.group(rate)) * 1.2"/>
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
<![CDATA[#0.#亿]]></Format>
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
<NameJavaScriptGroup>
<NameJavaScript name="JavaScript1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[/*window.parent.FS.tabPane.addItem({title:"签约完成情况",src:"${servletURL}?reportlet=HX_OPERATING_CONTROL%2FFINANCE%2FOPE_FIN_SIGN_FINISH_SITUATION.cpt"}) */]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
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
<AxisPosition value="5"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
</Attr>
</TextAttr>
<AxisLabelCount value="=1"/>
<AxisRange maxValue="=max(sign_link.group(target_value), sign_link.group(actual_value)) * 1.2"/>
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
<AxisPosition value="5"/>
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
<AxisRange minValue="=0" maxValue="=max(sign_link.group(rate)) * 1.2"/>
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
<Attr class="com.fr.plugin.chart.base.AttrLabel">
<AttrLabel>
<labelAttr enable="false"/>
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
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
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
<AxisPosition value="5"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
</Attr>
</TextAttr>
<AxisLabelCount value="=1"/>
<AxisRange maxValue="=max(sign_link.group(target_value), sign_link.group(actual_value)) * 1.2"/>
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
<AxisPosition value="5"/>
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
<AxisRange minValue="=0" maxValue="=max(sign_link.group(rate)) * 1.2"/>
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
<![CDATA[sign_link]]></Name>
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
<![CDATA[sign_link]]></Name>
</TableData>
<CategoryName value="CALIBER"/>
<ChartSummaryColumn name="RATE" function="com.fr.data.util.function.NoneFunction" customName="完成率"/>
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
<Expand/>
</C>
<C c="2" r="5" s="3">
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="3" r="5" cs="3" s="4">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="<span style='font-size: 22px;font-family: 微软雅黑;color: #00f6ff; width='300px';'>" + if(len(C10) = 0, 0, round(C10, 1)) + "</span><span style='font-size:10px;font-family: 微软雅黑;color: #ffffff;'>亿 </span>"]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="25" r="5">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="6" s="3">
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="3" r="6" cs="3" s="4">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="<span style='font-size:10px;font-family: 微软雅黑;color: #ffffff;'>同比 </span>" + if(F10 > 0, "<span style='font-size: 16px;font-family: 微软雅黑;color: #00de83; width='300px';'>+", "<span style='font-size: 16px;font-family: 微软雅黑;color: #ff4d2f; width='300px';'>") + if(len(F10) = 0, 0, if(F10 = 0, 0, round(F10, 0))) + "</span><span style='font-size:10px;font-family: 微软雅黑;color: #ffffff;'>% </span>"]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="2" r="7">
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
<C c="1" r="9">
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
<C c="2" r="9">
<O t="DSColumn">
<Attributes dsName="sign_com" columnName="ACTUAL_VALUE"/>
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[INDEX_NAME]]></CNAME>
<Compare op="0">
<O>
<![CDATA[签约]]></O>
</Compare>
</Condition>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="5" r="9">
<O t="DSColumn">
<Attributes dsName="sign_com" columnName="LAST_RATE_VALUE"/>
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[INDEX_NAME]]></CNAME>
<Compare op="0">
<O>
<![CDATA[签约]]></O>
</Compare>
</Condition>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="7" r="9">
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="8" r="9" cs="3">
<O t="DSColumn">
<Attributes dsName="sign_com" columnName="TARGET_VALUE"/>
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[INDEX_NAME]]></CNAME>
<Compare op="0">
<O>
<![CDATA[签约]]></O>
</Compare>
</Condition>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="12" r="9">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(I10 = 0, 0, C10 / I10)]]></Attributes>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="13" r="9">
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="0" r="10">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[project = "新城"]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[project = "住宅"]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[project = "小镇"]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[project = "其他"]]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction">
<RowHeight i="2304000"/>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="1" r="10">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[project = "新城"]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[project = "住宅"]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[project = "小镇"]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[project = "其他"]]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction">
<RowHeight i="2304000"/>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="2" r="10" s="5">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[project = "新城"]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[project = "住宅"]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[project = "小镇"]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[project = "其他"]]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction">
<RowHeight i="2304000"/>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="10" cs="4" s="6">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[project = "新城"]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[project = "住宅"]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[project = "小镇"]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[project = "其他"]]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction">
<RowHeight i="2304000"/>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="7" r="10">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[project = "新城"]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[project = "住宅"]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[project = "小镇"]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[project = "其他"]]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction">
<RowHeight i="2304000"/>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="8" r="10">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[project = "新城"]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[project = "住宅"]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[project = "小镇"]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[project = "其他"]]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction">
<RowHeight i="2304000"/>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="9" r="10" cs="5" s="5">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[project = "新城"]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[project = "住宅"]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[project = "小镇"]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[project = "其他"]]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction">
<RowHeight i="2304000"/>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="25" r="10">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[project = "新城"]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[project = "住宅"]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[project = "小镇"]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[project = "其他"]]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction">
<RowHeight i="2304000"/>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="11">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[project = "新城"]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[project = "住宅"]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[project = "小镇"]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[project = "其他"]]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="11" cs="3" rs="2" s="7">
<O t="RichText">
<RichText>
<RichChar styleIndex="8">
<text>
<![CDATA[新城]]></text>
</RichChar>
<RichChar styleIndex="9">
<text>
<![CDATA[
]]></text>
</RichChar>
<RichChar styleIndex="9">
<text>
<![CDATA[${=if(or($project="住宅", $project="小镇", $project="其他"), 0, if(len(f14)=0,0,round(f14,1)))}]]></text>
</RichChar>
<RichChar styleIndex="8">
<text>
<![CDATA[亿]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="6" r="11" cs="2" rs="2" s="7">
<O t="RichText">
<RichText>
<RichChar styleIndex="10">
<text>
<![CDATA[${IF(C14=0,0,round(f14/C14*100,0))}]]></text>
</RichChar>
<RichChar styleIndex="10">
<text>
<![CDATA[%]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="9" r="11" cs="3" rs="2" s="7">
<O t="RichText">
<RichText>
<RichChar styleIndex="8">
<text>
<![CDATA[住宅]]></text>
</RichChar>
<RichChar styleIndex="9">
<text>
<![CDATA[
]]></text>
</RichChar>
<RichChar styleIndex="9">
<text>
<![CDATA[${=if(or($project = "新城", $project = "小镇", $project="其他"), 0, if(len(m14)=0,0,round(m14,1) ))}]]></text>
</RichChar>
<RichChar styleIndex="8">
<text>
<![CDATA[亿]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="12" r="11" rs="2" s="7">
<O t="RichText">
<RichText>
<RichChar styleIndex="10">
<text>
<![CDATA[${ IF(k14=0,0,round(m14/k14*100,0)) }]]></text>
</RichChar>
<RichChar styleIndex="10">
<text>
<![CDATA[%]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="0" r="12">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[project = "新城"]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[project = "住宅"]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[project = "小镇"]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[project = "其他"]]></Formula>
</Condition>
</JoinCondition>
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
<C c="8" r="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="13">
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
<C c="2" r="13">
<O t="DSColumn">
<Attributes dsName="sign_com" columnName="TARGET_VALUE"/>
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[INDEX_NAME]]></CNAME>
<Compare op="0">
<O>
<![CDATA[产业新城]]></O>
</Compare>
</Condition>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0" leftParentDefault="false" upParentDefault="false"/>
</C>
<C c="5" r="13">
<O t="DSColumn">
<Attributes dsName="sign_com" columnName="ACTUAL_VALUE"/>
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[INDEX_NAME]]></CNAME>
<Compare op="0">
<O>
<![CDATA[产业新城]]></O>
</Compare>
</Condition>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0" leftParentDefault="false" upParentDefault="false"/>
</C>
<C c="8" r="13" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="13">
<O t="DSColumn">
<Attributes dsName="sign_com" columnName="TARGET_VALUE"/>
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[INDEX_NAME]]></CNAME>
<Compare op="0">
<O>
<![CDATA[孔雀城]]></O>
</Compare>
</Condition>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0" leftParentDefault="false" upParentDefault="false"/>
</C>
<C c="12" r="13">
<O t="DSColumn">
<Attributes dsName="sign_com" columnName="ACTUAL_VALUE"/>
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[INDEX_NAME]]></CNAME>
<Compare op="0">
<O>
<![CDATA[孔雀城]]></O>
</Compare>
</Condition>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0" leftParentDefault="false" upParentDefault="false"/>
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
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="2" imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="2" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="80" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="2" vertical_alignment="3" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="80" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="2" vertical_alignment="3" imageLayout="1">
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
<FRFont name="微软雅黑" style="0" size="152" foreground="-16713985"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="128" foreground="-16713985"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<IM>
<![CDATA[m<j1adTa1>NHUcW1tc9bUh6K7Bk\&V<i0JpQBi1!Gg%-uaW(kjXCLCCBo4p5QC9f[VW>fI9q
9=.6mYbT'dY5(IKD0;SQ#8FVt7Rqq:p>SHf*SMZ@?Yn^".C%H`pGbRF;?jQ>Tk5!eFAhSigT
h!mLs8TQs7)(/+Yt/=aBi">UKD4EfeU=6rbR9=h]Ak<N*ZSjeanJ<`;3BJ%E)eVdnn;9olD^h
q!'h[Dn>]AC=k9qD;e^s]Ap&3,X6b:eg4ZV+="m8%cFgLE%W-Mr-KKfdhWcFa\IQ7'E;9ggebR
Pclm[<BeA"5%I:M9,LSZBi4GJoJ=dm`7Fg6u49"6NP$^-^;fq/M(4j4;2#r#6GnK\MJ@#C<<
2G-EgYC0%"(Q"G!qREXi_`e%4X);5n29MmOX<Y#3K25AFGHlqbe\LS+Qk'QQ(?o$(7[*@2_U
nG]AS2FesJWX'tlql_i?S>k3Te)"0q'jJ_^YpBi#U**-N:bee:OtVBQ?Jl\`FBS^8QP_!A3KH
eEfOSM]A3L*hZYtdZ>pD1c35))3Cp'b5[BTBS&l:"<B'F*lr^`_q=qmYh=U_[A2&$AaW'Wh5C
L$OdP.\AaHbfIDoeD0]AR^!V[%qWP"'FlE+Ys*)^[&;-0[N1*82`VO,gf'-A6`G;t_hN>/o!L
q%L&hY8AI]A471NRSb.(%S5'W0'+;0Abd*F#m&1R?/%\FfF65I%GJOWLO+G?I1jmbfT"X0g(-
S;nY1g4LG'YL"L[,72?L%L@r_/%P(fSo;lk?P#1JZQ3IM$(l)X_,-Vt8JIka9!,<$\]AAo&r=
`3<RB1UnZNE`MihSna!#+dS*d+[_i2I]A,ENg/5E[q]A%Bu$c]AGm;!b.d8ECaFU`LhEZVUi9ER
.M0>\77fF0hL\+R/+[Wf3XC2kL)8Wb``qI%.PY,.r"['/A4dNbhYg0AZQtl!GX"St^,Z+f0J
2XYkh7'@EWMO)d0^,+@%2Of9%=4I"AT:C"L:J+G.")!sk_VF@HE@Ms$5N7N?0/q9%Mp9EK[H
=CoJhoI5%S!)V\1M'5X7irFC[<<2:h[\U^NF\(q$/N4K@>BQbPPGfhS9obOOK]AGn&7=,I83E
CTceLUJGpH</^!BI/=d93O,+ZS(Y'\]Acjo6I.X'AE_-3KH/s%0($"GUWZ/jeY6+Y]AOK84/ng
?W9)-)7NftA;Z#MuedlI-jAaRJV(8^D^d7Xe)TWUf0)hrtAKpGM_cS<W*mR1[I,euIf6^uP(
<=CVKq.((;IY,\,sI8ra?br*?T6&af1pe%S$kU><`b<N=hAO)#U'Xb?+811=H_4o+Gmi>+^Z
YSsVHi'DW7V3F?f.57F5e#P&O*#9*K<)`@9B`ccl+U#(gMm'Y'K\3&X\uMe'Ebr.)tiIDM@-
FcL&DVs7#E6!qQNBHd"MWKQt5k1:A&JL!g)Q8J<_^q3!;I8?ag+)>:#:^jAM_E``AaN.q)XN
M/7kekgkdo'JeEB!WUSnP(T<.\n4V34?>k[J,'[_hl6sU`V;e/#ZSIGrlq<:TmLJG.KjRa"`
GGQp<><@Vo-14,HCU6(bNj\5mH5K6%D89rI!nMbJaaED"#)lFM\(cp$3"#V1/28A00A+4(Nf
s+ZY+oG:2lS?2pNCM1:7R+T[3+?4;.j((X3<7N(+_\rpRB"4@>:_[A`-9#!M)#pF3S*)&g)(
]Ark?9m&S*^I%4!V=JMNb&Klc2J1:YG8F^,]A(Yu-`[-G1r+rBo5ZOZO+8P#6mo3h_c3+uJat'
B8dRY=F2Yi7=:8A[fU,IZgg*o#K<fnmohW#YlX;*3i[>mXP+";SnBi>>F#@BN^\+@%?YLQ6r
RoVt@C^%6kdiNi)QIR_Lo9W5</+jD0h.(\BH`3.Z-`Z6<P(Q@:\(/q!>aoVk4a?:^B020QI7
kL[$iLX@<$=jT!::%I>.sXd=!ea1V2t*]Ae_a3ZWh7=7E9aq(Vt0cbr7cf,Mbi3dkouB7l%cZ
Ll)l:co">!m"((51I"_6+rpgM&(PTQVniO08S_L</TPLI5hVpPE()urg?FnT_qfcqP$M>LNo
_c[P+%`gAE\A7.H+PBF^n%N]AA3t4\>O^uu=PgMR?:^DCesLr&q*-"bHe<A($%)Zc]ApEW=4kX
fGGB*$CoY97$E^W'.=iG<gk*^'DA/r_XHNKL@U$>@mQFDN_5:-$X*+$:&H0BXnp6G%q;Sq%k
]Ak/ct_\,97'u@$P*X3o_Mlp9;\F^_2.J2<?elMP>GR<m9/e,#^CWT5RIm4f.DrX%nlrUPTR_
CYJBDnF0FV2VZ4"joPf;"B%qj]A`8d!O2$%V>f$lL-n?B?rTdQ7Gh_)=E.1-G&:s93$X^gO&Z
XHaMJ(#'IMS!io-pU0AnV61.AA^%I,TD93EoGu'SRr;=OhQJLLR8qC4&gWHY$52;!=),Oh2?
1"Pmh_o,P-!UD7cS(Gpc!I`B2Ig\\pEG9gN8ao&2\`<@ajR8VUV<U>`X,4Elao'i5'#8qHe/
F;Usg+-ao;3`V><J#ckC+/Z!]A*OGUpQkbT!9/!J(B?7&e@#`1KRkB`o+H5@o[kjGZO)h;JcS
as8))k3mSc*"niQ]Amri^mf7o&q+[]AacD`]A9"/sHLh9q4u%?R_bP+O:_?.@kP<X%bOWK,")-f
1k)PR'4l"!%Tt5Wt.sp.L5!jtQ9hK0\I8VTfFfdCb87G#b@Zh1;Fn6E^*<@nGPH5@+YG?6X1
:=mTl;R<M&5m=W"G+OHP$P!?Z+&IiAfNZF=-8u+]ApleeSaAJ!3G#]ATVPjoWm]AQ*6FJ>FofsJ
UUh<=5:/r#1QOGn+e*QV.C:!h;L==lLR\b8$;_aOo]A5V"pKD8Fi-'17k-<uqI&K;DLoR(3l9
o$OjQ>j;rS/?BLYZ(lR"ia\Q"Z`V%]A8d-p#g\>7jDB*9l'[9slbEPYm6sLOh]A4UukG8$j$.2
rAU)Dm\KE+p>`[,R`l%LWXRBNMnq$1qJL#r6_W]AE0=I8`=2>N\TZiJe%b<?oYDpD1#g$m#&8
:Y.*:OeJS<T4gSc*EabSUP"Gl'QPCN>pbdm^iNW;F5(llG]AsZcN$B[a)+]A:WIssaHt<7D3NR
./sasq4gcI)X`JYQI;cmPXue:iHZ-\M>DTts^Q.Ap:\Vl8FjtO_+OG&TF"j^t##s*::)>S22
"#]Ao6RHZKpuN1rc)4^DaVE7H]AGIol$ZJ)'\h`WZTu$f+b&k*LWbYfQOkA;&Kh6t1V+bP6&Er
_;0iQh'iMdd;*cE,q`+P-f$$eE(#npj4Ao<0kVfhD"G?U`_i<@`)#G.,tHC=p6p-KqCaWj*j
T+(TL=$$7A3]A8lf\EXtm*q&M&GEn<-P*=W#UVSPHa-_%Jp2,.B<sDJ,W(4lIDG&rB7F\6NLp
j>#-IHA<19clD/mASZ`<%Q/BQD?93$gHr$ZuAEEL8k=H"4XJBE`QCpFIoa,1q*H5H]A8tAYlF
+e<qqmqBG;7>,R.?V,)#Pl_m!FkHWfB)PVI)gPguQ\h\:K?67@dNip507`X@B`$ekoL"n'CH
W[#Fn[B.[VG#og4JjRi6r*rsA[pB"rf:pj)>!(R3CKL2PLtd*]Ai/"O=A[4#9W8$3jO'AFH.h
%C(hjO0n(*FbaW&n?#R2)6rAEjH>r<#SrbCieiuE4]A2kOHVb6k$,rJl1qCpq*rd=76s,=R:;
<L?%0H']AWMS5LBZ"bGCicN3Q@\F>-Y1V37=Br@uQoaKd]A9?tjeXrQI<<TU:!\S^>(,5br`^j
=pj3M1Q'EGQKu1d/lNp`U91fhq=^(+D:k$X[+D2DdJK?Bnf.^R&e=%3'P/`njLMns,N=i0`>
>pr!MEI"@4@^U8X$WZ0*r#c"u*jDZiFHaG+d(q-WDpRQk+8Bq&$$sOMkIe7%q9n$e:B:bpAG
[Y**IXm;'ba"Za.N?hmZKKf.TclL,234+SZV7;!nH3/$T.HB/e@>3>qpWq4,gE*JfsNq<-&t
"SFaek!K9'>rPG'FglWqtS^T;lf7Ma9g.q#)>@$,7DdTLo3_b21;aIEoh<kom9ftrQ^GlSXt
^rU<NRuK&uI&&:ffq_\c:7i_Kqi_GsiM`@K9sk_ekmtE_&2-)]A?YP$km:<fg[Emi5[JH12e'
>ou'gA$]A]AF:)SEmGQl]Ac]A$ceZ$7ZI=U+\rlUuahHRE3J!-,__ic6_o\Gd.M).9:UN'jP5qGc
04htCo3@$;iVTgF[cqG&"VEAM"WU^&Gg<tc<NC,L2:Ulj*SS>c&VhGHsQ$V.\(;)haQk\`Qm
KM0df\b'u?Q$[E(['QuJXu5`3A,]Apn$ehRn@RR(mn1F^Ye7)R)s%(k8mS)gGQm:u'/sj6msY
/3:D7!@)%u>9BTF*U=B+eHFaKRM)YujK@U"2ZMN4rJHK!THm!g"Eg(L8VJ!Dps/h8(qd_@$E
VAZp!r,_jP0VHV?1k%YQ/TL2TM2_=DDjX)!<Z!u#Xkk@!3d[O7G\l,W(U:tWiXT9BGD98I1<
ID$P\*%A;efA$c:tOn.Jl#Vr7LPsiV7,76;'#>k_l@n#,D`0cY*oV:3dec-.4-8id9j92,lO
TrHZ>\'\_(n[I!#"i84(?.]A?rr[&M%Sat3+67=>t-8AuS2_3@Ct=1g+pf/4FSrk:]A,Cl7'@a
Za>]A=73\sAd5m^b(rOCBuJXpN0eO<W8'IHMl#Ita+iIT+uoW)L_-_3bgtX&*^uh@*Oa9@gLQ
/8RuPuNY%/sl4qtP>;]A!sUW^!nY'$EI;7RWtnnC<ZK,3BB8n"[^(fE7-5p+CiL]A4-r5m#o#3
G9uURZaFsuiXR*=B-e<3QUuXQ%$k43d?VYFdVNR3^,9t0/SDF&qXc-2]ARt_WBOr:]Ac;WCs@&
q2;FKOKu^`r64Y3WfdX8.'eT>#NqnZh%GI@@]AL3h!P$g`TKuX_P%^Mdeo9).CHfm_<7V7<7V
MC42XH-hhf[M9!)c'NOFGSnAE4]AjE[AkaOYan>f"G[.[u.bD"i1_muM;QZ1e8*m`k=]AaXZ\U
gGD+?FQE7*L9*dDgad>"9pd4>HK'`Xo7'9f6!;TEO\g3DCPOEhT,0el8Y0Vbd;_7%!:8@ao]A
/%]AmQj)B\Ria*!kUfDf5/CbXo34_bK-,l8'uXWOKnf?[;+0(_U-tg$S15XpM\E?1P_]A/_G9i
]A_eu>H1L.ci;o48*-!o3c-94difTf>QmVH$/HUL-F/EQJ9?6)Jc@8SEkEBZ`\$s(j`iHUdXN
>B$,ok'DR]A94a@-Ug6R@]AUZ(GM]A('\A_fmueP!9:ioq+e*r%K`&BUB%)sOR4*F)ZQP(ua?uI
W>=C?5M!BW8:KH\15b)t(EaWNOHsjg9?&LQ$B_/pW?L*DbTE0u.SpEsaQ0q^7j/T.EL^8bCR
ebcW.=$'Z#NYpib''_&A*4EX;ko?\lKF=89_N,V;!IEjd`"us3,a]Ajhgmk)TB;p7AqJc*Y`%
"rbn<0Y(4@q:8&CEP:a;cV+(:^b9MXA!U8`VG%[l5B'>G4WSDr4!3G.U6EB0sR0SX4=5j=L(
9GD?gS-fV5Gtj5\ofcsFndMo6\)r_;6QWKeG'gnCl2^@6^O[3A^2Op4Ms8Yrb!+-!e=IOpXU
pJs\"9ISZkn`creDPdDS_M<^Xq:.bSseNClP]AT9(LW!+?8a4SIdET^)8"Y`)R*;%XhC$+,ta
^m\1qWMSU*I,JL$RWnX"XN;OFH73jhX$tVdN3c^UYO??VO5QCH1'-Wi^6H0Xq7M<Btc$4'+`
KOk#$D\K&klh7Qi5E/![lM-u"ig5mqPIb-_DRVV0GD_TOkdkP(\LXLBb?PG>V56[45[%6O?I
0DE.\(J?g%IDKQ6;j9LtX#-0Lcm[jI+\rDN?9e@o2c]A0XZj>^@4a^-ulq$-^1$ho$Pn&@>Vf
M10OC*>t@gb63$"5$B@kep/7he<[b<*ZE?)(@V%*&QB.TEmJQtXIlgn^Qp;t\cFId=kdHOKK
#GNGbLH2WP#[L[GB?`O7I9=)eEbgZ@?mPahbY2RE7a/8@WG>B#Os!_"9/cmS.9.30Oh4XSC)
h]Ad)Bu1E'i\M=pX7A#dNa)$BUEQV[LrMUkq^90AIon-=;Z$QeYM<AS5d[iW;QMAaXr++RXh]A
Yc3g(8"B[*tqruM$(f2E(FIaNBV0s$A#L+m%h."[K=SgUD75k'q285i9aV::lW1E?@H>N2L2
0ISE#WT^3K)R&e]ALWig]Al/:?d$FEm!iDiL/UI3l64lZu'.#.&k#?$UGoZeMpe^#(a,YV@p:G
'0Se!h+ZPuIDPf\%U,PrU87TihXn3RPH^i7*r8AWL[?PM,e]A'Jd<DY]A:3>u'O_hK-O.?&:\c
)MhGUlT6arIqSp^MpNH_QEn7EP(<rY03&I[Mad!i<U[(,Nt+-$;9C`?.OYrnt.*B*V9.ik$4
g`W3<Mq-!iS-i%WX2a=r%#a6%ORE9qKi-D+0T>%?-/,+63q<.O0M@`s;B#TEL\XZfK0/3\7!
]A?O15e)ita?9-m$G5N6CR[!BA8bn>D'.*%B7^%&!g&qY[/7G_^S2A/j?Z7g;Q+R!2s'q,A=,
8f,r*hu2pqIBZ9##YP_"]A)NUME!RJaNf8<[^Y#QG60h&q7<1(qRe4$Z^X3T<T^$!tn9[jdKJ
fa7]Al\<i^M<@A<Q'VIN0m;_YPqg&]A`>@4(0i`We[SP?fM"kotOS2qM)6J4qLA0SJHnf=de5&
o)\g`?*_=Q9ZC*8UnK)$dpP?9e)c4EI&F@6&$Fp(U"0TopO.fo,t:Zoc`6Dc#&Z?9Fgu%-2r
N?E6Q>ZI?mEG*r#9rp3qfrK\l7X)U*U"\VKl,:Mg7j$[HHa(VDJ?LhA8Y!X3\HrF8r>5X96T
R4UaS<Y7]AGM.dbr/.TF$15GH#kSobi8(Td'4+f-^+n#&Um-@6;-ndYR.(nb,6;"^]AfK#8>XG
DhSEQn1:l6mX6n;&D64(:sqRT:k"?e>JTOB8/-UGC]AWp!'hpm/(N111WOI(AZQGX\%,Sp6'g
VR[9gffj@ibr18)+ToclQ4Cgs"H(!Y_c$0ei*on4'YL#1X<(_)d3L5:ouF>,QVBRN(OE]A(/s
;<^39Em0*.6-#'K?orPK?66l;D8$Dq,N'ng0`N1&YZ!*\=/MO``b]Aa^p$]Ak^nT,<>)sXip[a
MH)Sq_A6E`pPk^+(Ub>nsWYBt`\KZ"^[N))"DaonVBVGr^(9Xc"R.suOLV+PWfTCR%a(sH&2
:H<Q`!#_@<F&]AH\l%%C!/m/Bo\6-JJ1\MdThju@Ln?:p'H86=`@A(%O4(!RC7]AS/I]AK2;1cY
l4h<gWBjfYDoMqT&=6h@sgWcRaEa[*.Ice2CBj:'#;&AJLj#Ec_uO^8!EB:fE85E+f$&Q&"2
O$&"iHXZ>HREU*S3![SAs#]AU7;'sIE@'$<n4<ibrrWY49b1fmtKu/W_lX"bH8a&s9[M46\HI
:f$2O#b5gjmn(`Te<SkM#R;&d8"1Au/27q#(oa@[qu]A#V!/i_Pm4+_VsN;^RoiH/Le$]A.bAT
b\eqsRTRJ]A>*f#UB>U.JDP!^[!/#\s_0FE:JgU$k:5oNaHCm.7%eb1ufo!7d)Ri`tV<t/S7L
N:@1@tq4;gfL#/+]Ais'Md"O4B_cb?=i(_hP=)]A9[N7W#;R_.$M'mV"4ZMR0]A@=)2bD]A.f#H*
gdQ>h[1MFUfjGcAp<m4_/*g?$:SA(st5<$+*&3[(#S(ZgZs1HppQ]A;E`,f_*_L(mteh^JTQO
::Dq]ABa_P@)XfinH]AoSs/G;l3pN12QWUOMKRM#o;Ti[<C<:hH+Ve1+3#l;s:PMsBe(X@/jO-
n>$f3q)ed]A^Ke7Fh&o+VTAAl%#W]A2cbL<hn,bF(-m"f>lYJ?D!l7H6g*?@nNC#$MO'B&46.`
+K/lDjM@4GgO]ArdCP<ahnkjf>Bf_oP%mX-VsmCP#*,O_'hL1B;,PHVWImQjU7S1H,s>CrNL2
\/7afd??"%Z4R7J5R?4oThsgpWHO3WbCJ")'ck9V<<-ahK9FIm#7JDQQ`Dm@#"_W:,$h*eQ@
DT%m!C?B&Ra;(WW4ZeMLm*[Z[9bX&g2_A?bkNq^k&B$fYgs\#2A?\X$NT`C]A&t,jq,7,XgO0
UQbMABB"hOH4Vn,:+/CB(cLWE"ll-0EmVa:+JfRUgYf=lYhL5ni*J;CF8-jnrHV^rRSV*:>A
0)@r>+:kO[?ACBOfF\KL7n68m@`NJXVWa'`,O4p"P3M?ViQ(C:aj[%H!+Obc2?`%cFu_Qk(E
&'qSe2W;f-_k6I8`'*ps^UU(;K/lo\`]AN\T_j=+<h=/Lc7,;"N5afSFPfoZejd;Y%,Lkp0b7
."o:oji<4gMonBSe5CT98X(<SC6->6[8jq/<UE(LqHG+ORkRh5W`(@S:6Rk$!/0X1?M'Re=U
0L--d??rrNbs>aRhJ7?Y1$s'BRM_e.T3Y#\ZWGT2Yf@7'Ehc\LQ%?BLO/fgYYDAr=P5dFD4a
@(Q((DkCgt0TP&VMsMm":8%q<!:Q3%V<MG"H`@L;/"5hh;u=.T]Ain(:8/-jW6l1d"n(!QI"1
;M[?o"$"p.YJ([L6,8Qun#rkFW=mPWa]AELJ63FG$+A(0rC`#?F0iDkfXUKQ"mo3kfpg=bkE/
F3'a3A>U:T%@7P@dZ>]AhE>m"4.la35snbO3<:QIsW-eVB,Ci9_pd.;!th,lmc2l-3r#C!j03
IdN$:.XAPW/$rMU3hA.:!%Sn2-@j:"":O!F_aj?UE7TVk.\pEjIGbQeY<AO+Qj^g3Qq!af1W
c*:mHh]AH7H?tnE.7Qh,M,*>\u&Kqj;cT8P`-@*[!_FD^S>/n-d30-;4YWkolPn$+rAA&j1HF
EOnn/&^OmT)i805WTYVgWC_ql+Y#oHU8L?4"JL:rQ+>LOX0M#<*"$&XN[ho(Vl[lG)akQl=j
m^'fH[`M'VuJa4^f3+\#.AgM252+J6tpn^(Vl/J?:=i:iZM;2?iSg+>G/a+a3q[8fHP]A'!2A
l1[i)[kP%Hf""+6"D$sqt]A^)?_.L>PeG1;i\(8eh*Ld*c:M^VjA!.UD,?S`d6Gn"[;`pQ^?:
u&H5EgM<s1+rB1*0%lGB%58g8=7F+goe$qCqKujP\3pU9N1]A/mH;k>S*3@f9VJ*#fUs[^-Q]A
M!$P^F-(Lp/*;"lf4^UcU%*\aa8g,PQf]Aoa0cG'AtNDI:"3!EqJscWTaKFC[8Y]A00Cm_.GcP
9rFA;YtJC`MP^]A"3*2o>2[uat<[ceX?B4U1@AiV/C#a"qOu3p@DM`P^SLako)`Ru!J;_a5+,
ga`=8,fZHQT:>7?V!WjQf"PP'tmc*lmZ7PY:-KD5V[7(l"!odmJq3Z>[+!-M0Gc1:3<2?DZi
EZ_GM0"Z2%=-tpuk06pU_T`.=]A9]AUCiZ7VY1Y[>77hEt]AnZR$o:&bD1:;=o`C?9qAbfU>A&f
gf2->Ke-[L"_d8oD$DRP$+Z8JXg[j2C\a2*1*"IO#%`/!@;O?kn(n_N@V0_8s(7NJGg,N$ri
-K>H;Q+o9;I^V2nQL'fV'eB,t\CZ7F7^%B6J+O-d#mok,r[#5W)I5+ti=>dOJs4:kc_[I6Kq
[%?bALbE\@pN0`]Ae6u[!Q"[nCa0,ZB/B<JSh/4;0A[`-mn+gXbGt1&BGS),TCB%PUB%eJc-&
VBn)jP_%<F5QG,4.f&&iu/f5KHf[N_7CfOGIp9:/ebi-krFdU+9/D:RFF&CFk=p^gtu>6BRt
2jS0qnpsM+=;gHkI0,li1Ofj%*Fl]A<R[,]A"3'd<TNp]AN\8Pj:)&bq+''kU(bb5$%<m[l'tHn
^@euVq"FW0,PDB4+'@"gFtQN1#P&M^@U&fl>p#NVH8\jo(#WP@%r$gI+)N2>a_*]Ac-8mS(Dj
J"DCNN3gk+B.#)k.;;tLX9Gq`+M+RPX[EPj@El:LA]AL@TaK8*RrJaX9/!37i\Mq1iWXq0JS:
UFJuR;h<`6pF#53-&TtFb^)jjI+@[))ksiMe4uomi;UH7s/,P<dPD'(%FY&u^P/C)D0bF6S;
lcscPF!)+`1@"#S6FhCR2DIf-N;*A?@)N!K6rc]AAX8_YC3bb91p95aLKeKX#ugUgoW;jgQ+(
;_6n]A+bd5#u?69+)ln\-f:9ssP>$(1X(DPdfX]A_5K2n>\Beun_Y_AfG4SYn4:ORdtS[enjfL
;skseoAloE`f[q&Z?a+;g)@cN[c-NO*I5NO*`YKG)':;_'bH"!RJ`gO"1<cV>Y)hpPQ`nQUA
r(4baIY\3rmTM/_2!_\2FWKt1;4n(J3Z.CZarfH0!'CB`3`G3PIZ&NX=?+?#6Q4E&<,Y.K21
:7]A#F@RgGVAB!*K*kR^*RIKNUYQ!m=k"sHC=u=n<4gI'FJiet@1fZG-gts-hKXNnJa)kE4D.
#E`idDKhN,?2p*.[ii/@Lc>KFU,>,a#C-hWaTM[E#]A3,:?o"qK!(9WttM84Ar0a0,6Bb/$MB
)m*&JS>BpGrZ&T7S#n'O0cTQJ^VR!rOSTsloVi3brgd?[R-A/k4D5sf`*BO8e(@BnPk@0lJL
7]ABPn/+4tASI!f!$5S&Dr;_ZRRYS)o;]A!=EY,@G1\55InG:j:3",/g-hbisj4bQp.S9SEkVF
mf#rc;o?#&'-nk6G0%o-eB%QWj+ad#6/%#P4lOfkqSa&eX!idlOns#:(g3='BtR80h%?Ur=)
olS3ufLjrCK1o%+8qe\E8&eULp=\N00P_=Je"N?a2JaNDg^._>#1\g&oDT2PYelR^gcB#5='
(=7bJtp3U2ulk:M^",&m=3@3jWhsN$Jo]Adb>*fd;J[Q.1kf`[J3?D8aJS^p.CY.]A)1!-e<k6
A0B5[0^tLkFcr0j@0>KQhZ)DFhZji`.>%.?njAk,kJOt<m-K,DZ(!KEC\!M=-K>uE#$B_:B^
L:TdW2?qUJ&#4a)^JWOpDgJd:;d`RS<l*!SNKTK-E`6mS_-jCg[+s6TgY/@QuPIn'tFfaQb1
rJEpi3E,YI;l_@9obZo7XN\:c\=C/.]Ak*SgA4;n"cQ:Qd_GHmq'cIt"uVZ[qs/39T0m3Y+oc
A!LX<\KSNtkJqn1HmomH\+,)2Ee/<=#rA`Z\41,Cg'F_9?.bk95Ls!F$c/bYGB3$B3gg6<O[
Y'h!@TtKVrm"[X4:+&Tl"*.Y`U+'I9lc3gJ\>of6$`q?h)quamj&M-cl&3oP0E3_(?@RTU6I
lYf:eif\CU<<YHh)3?CN:in?:!3XtXlGGk1JY,S(?nN]A!/T(Lureh=PO_5u18R7g7`*F`^%S
&[ar(qgtTNMlLBMOF`Bpu?5RHk_)$>b*lZVsD88!&NeZM2^bE6Mbl^bcF1i%ef,\$T@!Hf5j
rD7P:`1qjpn48arg+36ZA6@bo&8VXo$u:%,Fd;&>9cJL)U%IT*2Xe:;?+/l]AasXfV)?b/\]AS
q`Udq=k-R/kI[:/o$N!WNhQlhT\O#oWohX;9_!m8<*)[_T?Cj#)Y>A\;(HL(IpeC3EfdZZG<
4RW"Hi,Q]ACK.q=cnN\S%`V:/7*\N"AO9E,PHLOcqj!Id8?f:f+.IJO"(QT2'<11ZI8K:oQjO
6nqO7Yp>Ttqs+U6a7ooHE;)S5V9atqE(3gQMjPOk\d$s2V`CjZY:T9?M<7#)GBni@T$MQ+r_
/<UY#2UVJ$'_hrf7gp&U:Gl7Rr^1h9dbrOnmgWpcJtVW<hUL=><C`hl_W+UQS'h]A#j:ODQBn
n.%_[kW1$2\MA28V??.e=WOHb***dUB>Pj;7"=MkG<WK@!(!n!JM<]AhRM[9<mhpU+rj)8f(n
kOI*qp53t;Qdeg6EH&p(nW!,>h0)3J'3244T>STa7c?5:+$h)HBjQhOd&!u%2K;FX?>eB=<C
*E'klbkR*kVMLlbk/R0^j"hqj\Lc(Q^Vtje%K8V+IR?mdqgt:MCBq@0[LdCgP6d5u9Z>i._@
nh_li^irfh\0D8a6Tf,-hB+);J:JmF0s"or3:g67!ZEKRjF)jf>K<HjDQ6@.6`\D[\N[rE3G
=YhY6ARju-p%#HFoPM#dL(PrQ6^MQ#n?&1aGQ-^*/E4>$EiqQQX`C9nRuA:]AR1iJ\,=6&*![
oae@#FPI`ZJS(B<pL1QFi^bVq^):0XNOiHR^u(I_DS!04hXT'fR>G%*R,cAgLSEZ[3Ibp,"d
ZB*&a2e^af-V9e7h+YN!aas/8Pm3M5V;AS/J>j5Sd^<Ee873B-_+4Cj@j0R]AkR,gf'<>q(r1
g\RVeH,o/0pa#="Ag2rDZ\D2snAB.<pe%8h4VPW-Wnt]A"Sk=:h2pT`-.KH(\G*.?lu0'L@Y_
9[)pr)H(^E6\]A6KbCgI\NXEk.Wm>e,]Ao&\<'5sQKB;i!W5DbC>i.=*E\QTTZK/-!-`GO_bcF
2Om(+[TQ_G]AOdDEidA/ItCtJQ^%$2HkBJF+1J&Q,:Oo$'Mg4GE_=<ec[!b%hIG#)H`)lCSh;
Q9`'*hUgkZo5,_B;M,<SK$j?rr428SLjAl%18kjn'L1h"2@AX,8;^<OcW&2(OTY^F;/G%oiD
h107(/,LZl>[m>HZSh5fnp5,]A;JM(U>O(o[%m@6V5'>PT,r4'?3+C:lNQcX>23T&5-Ib?6rl
6k]Ai\Vdd6'B9iaX4'j]A@cNo]A=F#dkI.9.KtH>k+`Iq*cQe.lRCg`hE8)Z$etp8R228%\YFtM
?gL`<LMhBrqO??7E]A]AL]AQ\=q0Y+?Q;k`;I]AJHp&S5]Aid_s;b1nIV_EQnr0_s6;sK!up[QpS]A
0A@m*0[^#dmNOPVSG*(YdTBaL<'B9f5l^m09El^ei2VEfj:tsUo'j:HqjK5$bk1[(V)'miGp
MA2;FQ0]A6eZ&OO/<je65RhC==(.ei!f:`nMGq)s"<^hKK(-BA6KRm/Y]AH#-U!h*"dAYh++$X
18\g)L"c^R(7:")9qHR@+hQoZ'/=uZpl>'t8se#<WQj*j)!Zb8hTC&kluB3JJBpJg8q:eqNA
PL3./*S>["r%<\L(b^"1'O('oBi^@)\O!CjU4<2MPY!*krodhS:&nk.qYFM:L_@C9N6JC5Fa
(H^9q%s$q*S!SN1R&><FKX0(MWlY/9;SBbIJo8VZ(.sT]A;c/JF=?;ri#bbO=jcG&-Jg4]AKt^
iU&dTiPp'O4tR5p:KVX.0M<udkf[;D%pkK2Q!8PFj6(;g^Ngg^APt7`,PDSWd54]A`H#SJ?FJ
T)a#M#]AT"T:GNCST_<J@Fj`h2+tTHSKL>/&soO7jMeoC1>>!MHPBH(Y@OD1hMsq23XiW^JuT
r8Wu%QsC'nP3#'+K*!k\`,Jhp7c1o7DLQ$I&Dp:!_LSp;O<nu;I0XeRg;<66DU)s6H]AD$tC3
mSRc0BA=(uZV]Ak%<,`qT;/l+s;Bag(MT:hFM+Y>b'%e\AL%=/OYCJGuE;3]A.'($iPm3+W4FL
(pF.nZ=mf_(n`K)RK>f""KU<r(='nGIR0#>XN#kAKpGphhB[]A@Plu#KB=tR$W!$32+E%8Sc)
%XF8.`pO7PitS2i:/?[h,Hk;+E94P`>PL$l&rhq]Ap4]A=N<(M1fu&+7Z>i@OF9gL="!RESn*P
NR#1Lffn#k!(g8+qJb(*=7TF-&Qc[ATo\W3EYA;sc9;,lcG4^SJ-n@9q5fj^6o4M8(s'#I#f
\R"176sh/#GD5E3`56<-0nuc7[Vtsi=c^5ldmIPm:$971`#WY`%bGRDM8r^.b4ef2[%nISQY
8efL@:QF1'E#E>dgE+!id+d,#3R!2fndIo&1ZV^:R]AX62>)=c/VfX9QOdCe7N_Z.b*526Z`P
_i+t0X[^\9QKVns3Gg<qn5_t1Go`EgjOZ.Y,>]A>U>;d4Om3M&IQX$H%/7i('I]AmGuXM;lR[(
3SVLVF:[>\J\(Z24o0"/p?EFoB%(lA3/0R09LiKOM+EA4d(25W0'0=ND9CmD]AX!SL?/JJp0n
LF,)#i+htJ[',/AO8j21_+mni?^'VH9J-l-m%dE2Nb!$BI;MbLZr1TrH]A>&=hP$ZsgME)rpq
\gq`q"$4!3Tb9B9bLL)D(i5#u4j6-%63f:T[.k"[5YC=QPk5)G*ZTFDjtQ/%_e>Hb9DWS+*M
!Qt)LN%L#]A&?l'N%;2?:<r.dh0gr7E_9QTCgLClK4HSJE*l0LbFJG4s'%EmM$e%CDQ1t/ElZ
[3(qkVa.A;mBS!#lWQ+^cVNVtp7_`fm2Kr^t`\AatV_m^Ghh^0*R"nt\fGrHpOWZ35Mc);XQ
/lcc`WkH1I#e&:W+(tgGh".9'UrUA.LfU^enmfcfeqDGe]A)42HF"sp)^'o#'$?_p@5uh?@HV
Dfnu89Vp/(a%Lf0TOeN9U?^d/k4enj7t4Zbi2A3gZ33+ke813E$t'\GH\$8*!pJT[t;!TK-m
CEm=1gSS9DfbPV')T0)V+-kq95s$Gn_V5f`o!Q=b7cjaa"<YsuS.9Y":EgstWf:DG.dSk@9g
R_,EN0C?/apYP?%_k')1I5r,R[3.effp2j$D`nn"]AEa'j)URp"Y2=/#3Z\DrWke!_QFsjI,&
T$G'Oo.!LPJo3p"IT\d;#gCIoi,<qu**h[)8bP[X\C:-U/;),Nm)lF'K<]A0WEBm!-rmi.9p]A
n"\VD)Qk.U1<t?m^a[t?Mmdk]AfL/e<hfP\$TH)3:HO*+X)6sX@`B7^>TmpR_'&Lq?"45RN%.
<nO[:fLMm=2[--grap;K?,l>hWWT&J'V/S;kJ.$Ng?7rSJ:.0^sP'B]AT.mS=OX`%Hg,".$j,
25WU]A4C_@Q%1C;tLY*FI;el6qbjN9JlnMs"<P;9El:AD=Oi!uMA@/1d5e4q%oQ2t#+]Ai!iD$
"X1drrNQ.Q+sde`V5)cW`CtShr$XR5mN-""o>e3AgM=KQ%'X[tEb4l[QfT^=Nt(>cs>9M1VR
8N'o7/)\&5[qt3FeG=659&9rP&0\B)rj/NBt:7im.neJduZ`+!Ne!lbW_s,6Eqee'X\lH\!4
QA#bM0R&p@>4rh&5K?+oR@*#g;#AR5Rs[bG_LPpeFQ]AK4g>K'Eg4s.G/HkGFPQ'sA[9CAd[:
7rT"3'FYJe"&dk7a`KfcBQRi"o&I+FqKr6-A*r9^8XR`%($rF5jmCV'pC3oaoZZFX,o/iqlW
YTu;RPjaAUic+uM\8+o!\^UJYHLjF';><?N/!$Z6Sf%%r.k39laYDTX<VsACTHY8-+S6MYfX
HQ-k9#M02Ac>]A)$mK*QK:1;&=oO=Jp)W5#eNCPdFC!U$["+j:NNZti/OS5!8bkM"_#PD0Ts;
g^=R&/4'gMfeaSnU\DAU-;>-G!?`uFWN;A<[PZHQ'?:jG6HVpjDB23D;mkmI-l\&4sp4`-!(
nF7VYgWi_@%F/k-H_Ka)7QK@lMq52'We/V_=h,MKJ0AB=#690i2I'%H1<Z4['qL8ZCN.J8k$
&rK'TpogaYA'BII`Y"r,t*^<c>GJ6sc(Hj/uKh=-lWGhLNOqdT"LB=gn*qrJZ_Fq3/)"8t:9
V*n7S>Gnt"h*Y<ano]AjM+3KNr3-eRCL6m8a7mY/9TPf5G8WGh*cLS^!6Hj4r(2%^Y]A!@`I4`
AQD5Rmo<U)jAI-BUgl%VKV:Zd]A,qb[.7r`PIEpEs3>E6-7)@r<h*[!uRu+MSRf4Bc>;<ql!k
Q4aScEj1/DLY<PBeMfGW><m'i3.p^ee@>1p)i2]A&o>.>aI3H.#UJW<f7oaIn1K9189,[Sn4Y
7>C%_)gVL1\.d(GP7%sllb`jj`%+1??+%GV^ZEN$!s9m2:"CI.)9XjN<mdRn"Y(TlUB*&'3^
^jX,14Y.g4/.@tP25j0-YWU<!EOXp6m3Aj@?DM8^W&URi,q5^oeaMm%%>\HRTF)UqVQPsggN
/3o5k]AY<pr_?D+A-AU9U:76Pe2SpI*BME#0E'o17W.QP>`\5bS.6(=<aj_sSI1fN<q2jaAkU
5.X[@3Kq]As_I^ppAfcK@JbI>NCSpE/Er4PF.J85"8M$]Aaf2TW)O2KQm/gbl!q^VSYh\j>>BG
2!;m@V9\M\b-Qn4P>9UTBjd"LST+:ChZ<8+lIQ2pH:.d"m9a_ue/'Z5l<>Zm\HGsc(EO/X"g
9Q[B=!!HA[pCknWtd*(qY]A"nj*3UEgj5`UhEgFc);*u8j%,D[Sb]AH)fNR\_]AI2o;k89Cqhi5
)HN:-+]AX2&dQ"nLTmA;@8#PF`iM3`"FV1/&O4q"H^^EbQspK*\]A+mma>oli>rYX;:2kN7TLX
\>#-hW6(#O[aHdklK*!i$P(rkS`=7I`dtLpiceu8OB74G[+`ZJ9uUVt[I;?\WS<$FW2&u/5E
[F08V`I5<cW-5d)cgr2`TXU+T2D;LaCng<,JB<ini/oB3,K-chAZh2A*dnK3L+.Xt'ODKW#e
tb\N4oLea6[+e`7T>HU7pZ,jn-UI/s'YP(mBg/Q1"gV=jH?]Ag_HXG]A2>C)?]A-S]A.<)A5?T1*
$#jedM$Gkjo`rjA0JuU27PgRg_%f&c'ut?C+r_l66aaq2**(=%9Mb>(`rlm,odHEa\/1B9-<
ed-6GJBbN@LrYuT,+c-LU2`G)4[+^7fAQO["9p9^F`S08p!1!Z?\^7o+`==a<F[Ag&@)ctgb
S3g!/`[_`WJ1n*p&iH3X`OTPR-TJ9:gF1OM68.6IDamL8:K;K&.H3Z2*SJ4&f5:e=jEA"gVb
kb07-Oi[L0;6cSlJs.huBFe6PgBa^!ND#3hO\+fa#i[BD51A#^^Ze[B3]AkQ1/c=?Yf2]AoBMA
K6L9LPOM^":eppi)b^Qm(pVZ?=YpI`1h08Wr/$.E:Ep/7=c_+&$MgHH)4;)4`IJGP-[)OgH=
Z"$:2'4$2BBrm6(f.24X"^d>\S9,:]A$#8`o2UKhh7:4iGMpB8X;q_QF*gW,XlQJH1a%J3iH"
+4lGUOsVf,D7>tZ`-0:RUM2VeI1k]Aj^?iZYsJ4i'=<%sM*(Cs<F.(EdOH*GX2Of2RXsi:T,7
%"gHXSFe11P=Q2E)E74VN77/,74AOQ8`_MIk]AP:h;:pfeY1<m.i0Mcs"H786jSV)0ODfS`AJ
V^/.F0;\6<&l'G+7VhBaC1a-aaK.92&?;0n\!BWG%Xn'TJ(a)#(nD?VV:b4I*IepmlFsJ5=%
U*!GX(Cl?=83ch,SXkDu=Psd>m?PHFi<N&,kHKdfWg8>1*W@l:&#as^g`r%@(,W(kc5r6`gX
6R-mGu3+HS\VE9LLs^5k%oFW26V&AH,`akJj$Ju^3$)OmB/[j9lS,)X_j+Z3b%-7).m/SZF%
aBT,Gq;8FV[[R1%2;_Krs;3kO]A>fBE.7d<m_]A2Ku5UrCSY3"*]A&QS)`$)7ua3f9CeEB9^.VC
V!RbT4"K8E5!f![XT[=t/*rTr4o]A+F-hmR_6TIUL]AI)lk"(()fWkLk4$MG0BeNc(&oF>LfD6
A$F+#.GYNX+GHQ0255KRE%[q+&BScZB^(#3X^"rXl1IB84H20@$s2r?H3\S`rPX'7l);_(N(
ML$4p/V*>F@*Ru)Oq9\b)=ZLP_<,e+(-c;kf-8qN]AB#^Ynoo'$7l"MA.6OX3'8_jn8R5E+^d
4Vbrk_o[pZ,Q'C#?,N;(!gU>6iCA"iK#>^0B9JI2\lk4mD@Z,=RdSXs._q:1HoX$gfSji#*s
U>LX3G-<pKQ^DCftUr]A.B-(]A<RuB-([JKC;?UpoJ\]Ali*OL0Jd/H=n3[0q>CXtpN6mqQ^;tQ
p/h=FaR;XZOD4DbKlJ:-+f9MDXa6>`Ep5eUlNj\4(PtQ80o7Y[/;#<A:u%'+mIR>BlNR@t8X
p[*mJJ+V"TXfH2o3u,"l?:Yp*V^LU_B>#*KWY(*/aIpcOO1Y#t)&jj[UR-qF_1lS810b)*4:
U:@V7GJ&Um!LCqBtMJ#.c2uFKW$W/?F.r7)BCkuHnq\49)liNaOX=8WG=MaV)mo=!=ZM"p4q
c^]A[IT#Fgprn4An8Qrls&'U?kVBp!Xo:CMq(I3"IuGcB?eW^U-1Q-sku^KHK%s^bj+7W2p6[
A]AP8E<[X]A>iU]A'H$=C'C]AY7kFWOIh/Q`+eREWIqoDkiaD<6I(o!F7XS1i%\Q)H_>efnM$3/?
>:CTT/c(SAY!g'+r<o6Qm%NH%p]AX8+gV]AYRq:ZuQYtQ$[r;WgE1oEV<$'_8Z_DC[d-@+Z*).
RnCr1Vsur^6@i1-9?KC`u[MIhDJU0*;0.Z#fOW4D-AH#8@Trkes_Z.HFj!=_gY8"$fBOY)s*
PIi"ld0`i:9F3bpsqI::'VqD#Yn,6'(a;VKK-uY&NrUmpc=IOoVC_$t6@jal@Y+WK]ArPBG7Q
.i`;=FWh'WT--(*d-S_Ca&<jB&*E\`ANiuR^/saCgPQI`a.kI3rUL(gQ9nK^WQi]ANi?$;*2\
Z*!XJ^%^:<I%:at:PkL&jQFA]Aes6%M%A)fY"rSuod/lCg@F]Ap/Q4g2Ik2i5.AOf%A.;SlcC"
f2)C$qT8BNfm0*(MIG;t]A1E-Cf9hY6%KT#tIAZ`K!Ta@0J+'#"BmL2k:e]Af.Ea*T@r9XHBns
:uX^I%2i@G5;Fn<$e`q@>C#!XIL7PPrg\K`;5?s(`b-,"$JP<Z`*BfMeEAXt\@?Grat$rrQ-
uD=PJ5mrO'iO?X/D#[Hj`;tt/6^Q1__%=`:,2e\q_J&:Z0`(#TWIYum)[3%I$5a$VOa%mf#4
F68;rrE~
]]></IM>
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
<BoundsAttr x="7" y="30" width="556" height="216"/>
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
<![CDATA[144000,864000,723900,914400,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[3744000,288000,3744000,288000,3744000,288000,3744000,288000,5040000,288000,3744000,288000,4032000,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="1" s="0">
<O>
<![CDATA[签约]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="网络报表1">
<JavaScript class="com.fr.js.ReportletHyperlink">
<JavaScript class="com.fr.js.ReportletHyperlink">
<Parameters>
<Parameter>
<Attributes name="op"/>
<O>
<![CDATA[签约]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_self]]></TargetFrame>
<Features width="600" height="400"/>
<ReportletName showPI="true">
<![CDATA[/HX_JYFX/FINANCE/OPE_FIN_SIGN.frm]]></ReportletName>
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
<![CDATA[if(len(value("hx_aut", 1, 1)) = 0, 1, if(StringFind(value("hx_aut", 1, 1), "JYCW0001") <> -1, 1, 0)) = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="1" r="1" s="1">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[if(len(value("hx_aut", 1, 1)) = 0, 1, if(StringFind(value("hx_aut", 1, 1), "JYCW0001") <> -1, 1, 0)) = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="2" r="1" s="2">
<O>
<![CDATA[回款]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="网络报表1">
<JavaScript class="com.fr.js.ReportletHyperlink">
<JavaScript class="com.fr.js.ReportletHyperlink">
<Parameters>
<Parameter>
<Attributes name="op"/>
<O>
<![CDATA[回款]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_self]]></TargetFrame>
<Features width="600" height="400"/>
<ReportletName showPI="true">
<![CDATA[/HX_JYFX/FINANCE/OPE_FIN_RETURN_MONEY.frm]]></ReportletName>
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
<![CDATA[if(len(value("hx_aut", 1, 1)) = 0, 1, if(StringFind(value("hx_aut", 1, 1), "JYCW0002") <> -1, 1, 0)) = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="1" s="1">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[if(len(value("hx_aut", 1, 1)) = 0, 1, if(StringFind(value("hx_aut", 1, 1), "JYCW0002") <> -1, 1, 0)) = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="4" r="1" s="2">
<O>
<![CDATA[产服收入]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="网络报表1">
<JavaScript class="com.fr.js.ReportletHyperlink">
<JavaScript class="com.fr.js.ReportletHyperlink">
<Parameters>
<Parameter>
<Attributes name="op"/>
<O>
<![CDATA[产服收入]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_self]]></TargetFrame>
<Features width="600" height="400"/>
<ReportletName showPI="true">
<![CDATA[/HX_JYFX/FINANCE/OPE_FIN_INCOME.frm]]></ReportletName>
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
<![CDATA[if(len(value("hx_aut", 1, 1)) = 0, 1, if(StringFind(value("hx_aut", 1, 1), "JYCW0003") <> -1, 1, 0)) = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="5" r="1" s="1">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[if(len(value("hx_aut", 1, 1)) = 0, 1, if(StringFind(value("hx_aut", 1, 1), "JYCW0003") <> -1, 1, 0)) = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="6" r="1" s="2">
<O>
<![CDATA[净现金流]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="网络报表1">
<JavaScript class="com.fr.js.ReportletHyperlink">
<JavaScript class="com.fr.js.ReportletHyperlink">
<Parameters>
<Parameter>
<Attributes name="op"/>
<O>
<![CDATA[净现金]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_self]]></TargetFrame>
<Features width="600" height="400"/>
<ReportletName showPI="true">
<![CDATA[/HX_JYFX/FINANCE/OPE_FIN_CASH_FLOW.frm]]></ReportletName>
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
<![CDATA[if(len(value("hx_aut", 1, 1)) = 0, 1, if(StringFind(value("hx_aut", 1, 1), "JYCW0004") <> -1, 1, 0)) = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="7" r="1" s="1">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[if(len(value("hx_aut", 1, 1)) = 0, 1, if(StringFind(value("hx_aut", 1, 1), "JYCW0004") <> -1, 1, 0)) = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="8" r="1" s="2">
<O>
<![CDATA[应收账款（产新）]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="网络报表1">
<JavaScript class="com.fr.js.ReportletHyperlink">
<JavaScript class="com.fr.js.ReportletHyperlink">
<Parameters>
<Parameter>
<Attributes name="op"/>
<O>
<![CDATA[应收账单]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_self]]></TargetFrame>
<Features width="600" height="400"/>
<ReportletName showPI="true">
<![CDATA[/HX_JYFX/FINANCE/OPE_FIN_ACCOUNTS_RECEIVABLE.frm]]></ReportletName>
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
<![CDATA[if(len(value("hx_aut", 1, 1)) = 0, 1, if(StringFind(value("hx_aut", 1, 1), "JYCW0005") <> -1, 1, 0)) = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="9" r="1" s="1">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[if(len(value("hx_aut", 1, 1)) = 0, 1, if(StringFind(value("hx_aut", 1, 1), "JYCW0005") <> -1, 1, 0)) = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="10" r="1" s="2">
<O>
<![CDATA[存货（产新）]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="网络报表1">
<JavaScript class="com.fr.js.ReportletHyperlink">
<JavaScript class="com.fr.js.ReportletHyperlink">
<Parameters>
<Parameter>
<Attributes name="OP"/>
<O>
<![CDATA[存货]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_self]]></TargetFrame>
<Features width="600" height="400"/>
<ReportletName showPI="true">
<![CDATA[/HX_JYFX/FINANCE/OPE_FIN_INVENTORY.frm]]></ReportletName>
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
<![CDATA[if(len(value("hx_aut", 1, 1)) = 0, 1, if(StringFind(value("hx_aut", 1, 1), "JYCW0006") <> -1, 1, 0)) = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="11" r="1" s="3">
<O>
<![CDATA[  ]]></O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[if(len(value("hx_aut", 1, 1)) = 0, 1, if(StringFind(value("hx_aut", 1, 1), "JYCW0006") <> -1, 1, 0)) = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="12" r="1" s="2">
<O>
<![CDATA[实际缴纳税金]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="网络报表1">
<JavaScript class="com.fr.js.ReportletHyperlink">
<JavaScript class="com.fr.js.ReportletHyperlink">
<Parameters>
<Parameter>
<Attributes name="op"/>
<O>
<![CDATA[实际缴纳税金]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_self]]></TargetFrame>
<Features width="600" height="400"/>
<ReportletName showPI="true">
<![CDATA[/HX_JYFX/FINANCE/OPE_FIN_ACTUAL_TAX.frm]]></ReportletName>
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
<![CDATA[if(len(value("hx_aut", 1, 1)) = 0, 1, if(StringFind(value("hx_aut", 1, 1), "JYCW0007") <> -1, 1, 0)) = 0]]></Formula>
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
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="80" foreground="-1"/>
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320!n*!W=GMM<83ZW9hTWdNaQMgI(fE*Om<(cLAd8q"Mi7o@\mA7G3C
.uO`FH&"]AOG>dP@U!sLAmU4TZAQ/[]AdHUg\>GQq#aRUA#HA:$=_n`:9N)b0:Ge*(a!rae%>P
JQF3@2`pSYNZCR!T_Z(k8nrE6%n'U.XFY[OcG3mnm[MKojYMZjr?1FLha/(dTmeuo<,=e1Kd
r4tH[au+'*>e0tnU+U+f^\=_)$+eb-^3r1c@7SP(@@?/CZ]Am;6K"lMNIqlrOk+n]A!N4:L^(p
`W!&8`0qRN\K8n\8+~
]]></IM>
</Background>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="SimSun" style="0" size="80" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="80" foreground="-1"/>
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320!n*!W=GMM<83ZW9hTWdNW8m.%(fE*Om>]Aq.cAiO?&,1#=AF%C?TB
_U3cr*GKP1,+FHMrng3IV:R"`3n!;N/2lj$;\QlTSP+b)Ct^QA7o,XhO\4h0#llgoD1?C]AD+
2r[[-_hWE/AX`i::D83sf\M3l/DVj[_o'9WLW'@5qi4nFA=7*2@'m=E-lK=Z:mUO%5`TYds[
^Eg,pj1b4p2?]ANFYb'CAmJ04hHDp,->q-sa/n39ds8j>ml?haAQrJP\EQ]Aa7uCHY;uVJ5[TA
]A!Zn8\r/rY-<mj#ZA#E6#ZQYrf&^#7Ll\G5?%@.5mq]A)&t=F%U*I!!~
]]></IM>
</Background>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72" foreground="-1"/>
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
<C c="0" r="0" s="0">
<O>
<![CDATA[签约]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="0" s="0">
<O>
<![CDATA[回款]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="0" s="0">
<O>
<![CDATA[产服收入]]></O>
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
<FRFont name="微软雅黑" style="0" size="96" foreground="-4144960"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</body>
</InnerWidget>
<BoundsAttr x="7" y="4" width="642" height="25"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="report0"/>
<Widget widgetName="report6"/>
<Widget widgetName="report1_c_c_c"/>
<Widget widgetName="report7"/>
<Widget widgetName="report7_c_c_c"/>
<Widget widgetName="report2"/>
<Widget widgetName="tiaozhuan1_c_c_c_c"/>
<Widget widgetName="report3"/>
<Widget widgetName="tiaozhuan1_c_c"/>
<Widget widgetName="project99"/>
<Widget widgetName="report8_c_c"/>
<Widget widgetName="comtype99"/>
<Widget widgetName="periodtype99"/>
<Widget widgetName="valuetype99"/>
<Widget widgetName="chaolj99"/>
<Widget widgetName="report4_c"/>
<Widget widgetName="report7_c_c_c_c"/>
<Widget widgetName="tiaozhuan1_c_c_c_c_c"/>
<Widget widgetName="report5"/>
<Widget widgetName="report7_c_c"/>
<Widget widgetName="report1_c_c"/>
<Widget widgetName="report4"/>
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
<TemplateID TemplateID="8f354f58-0b50-4f0f-b07e-74e2abbc9ea1"/>
<TemplateIdAttMark class="com.fr.base.iofileattr.TemplateIdAttrMark">
<TemplateIdAttMark TemplateId="c25c5864-3a1c-4e3e-ab97-58c34c70b87d"/>
</TemplateIdAttMark>
</Form>
