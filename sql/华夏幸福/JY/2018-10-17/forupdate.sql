WITH date1 as(
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
ORDER BY A.ORDER_CALIBER, d.ORDER_KEY


SELECT * FROM DM_MCL_ACCT 
 WHERE index_id='b104c15725554e21a985eb28a31eaf61'
  and length(period_type_id)=4   --年份条件
  order by period_type_id
;
SELECT * FROM DM_MCL_ACCT 
 WHERE index_id='b104c15725554e21a985eb28a31eaf61'
  and substr(period_type_id,5,1) ='Q'  --季度条件
  order by period_type_id
;
SELECT * FROM DM_MCL_ACCT 
 WHERE index_id='b104c15725554e21a985eb28a31eaf61'
  and substr(period_type_id,5,1) ='M'  --月份条件
  and length(period_type_id)=7
  order by period_type_id
;
SELECT * FROM DM_MCL_ACCT 
 WHERE index_id='b104c15725554e21a985eb28a31eaf61'
  and substr(period_type_id,5,1) ='M'  --周条件
  and length(period_type_id)=9
  order by period_type_id
  
select tochar(sysdate)
