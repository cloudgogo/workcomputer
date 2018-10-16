WITH org_ys AS
 (SELECT DISTINCT a.ORG_CLASSIFY_ID,
                  b.ORG_ID,
                  decode(a.ORG_CLASSIFY, '环京', 'HJ', '外埠', 'WB') as CLASSIFY_id,
                  a.ORG_CLASSIFY,
                  case a.ORG_CLASSIFY
                    when '环京' then
                     b.ORDER_KEY + 1
                    when '外埠' then
                     b.ORDER_KEY + 2
                    else
                     b.ORDER_KEY
                  end ORDER_KEY,
                  b.ORG_CODE
    FROM dim_org a
    LEFT JOIN dim_org b
      ON a.ORG_CLASSIFY_ID = b.ORG_NAME
   WHERE a.ORG_CLASSIFY_ID is not NULL
     AND a.ORG_CLASSIFY is not NULL
     AND b.org_id = 'E0A3D386-D5C8-FB22-18DE-4424D49363B3'),
--二级父级替换
FATHER_org as
 (SELECT b.ORG_ID,
         CASE
           WHEN a.CLASSIFY_id IS NULL or
                a.org_id = '5FB62123-5DF2-0750-0F82-F04B251EA55E' THEN
            b.FATHER_ID
           ELSE
            a.CLASSIFY_id
         END as FATHER_ID,
         b.ORG_NAME,
         b.ORG_SNAME,
         b.ORG_EN_NAME,
         b.ORG_LEVEL,
         b.ORDER_KEY,
         b.ORG_TYPE_ID,
         b.ORG_TYPE,
         b.ORG_CLASSIFY_ID,
         b.ORG_CLASSIFY,
         b.LONGITUDE,
         b.LATITUDE,
         b.ORG_SRC_CODE,
         b.START_DATE,
         b.END_DATE,
         b.START_FLAG,
         b.ORG_AREA_ID,
         b.ORG_AREA,
         b.ORG_CY,
         b.ORG_CODE
    FROM DIM_ORG b
    LEFT JOIN org_ys a
      ON a.ORG_ID = b.FATHER_ID
     AND a.ORG_CLASSIFY = b.ORG_CLASSIFY),
--增加环京外埠
HW_Z AS
 (SELECT CLASSIFY_id     AS ORG_ID,
         ORG_ID          AS FATHER_ID,
         ORG_CLASSIFY    AS ORG_NAME,
         ORG_CLASSIFY    AS ORG_SNAME,
         NULL            AS ORG_EN_NAME,
         NULL            AS ORG_LEVEL,
         ORDER_KEY,
         NULL            AS ORG_TYPE_ID,
         NULL            AS ORG_TYPE,
         ORG_CLASSIFY_ID,
         ORG_CLASSIFY,
         NULL            AS LONGITUDE,
         NULL            AS LATITUDE,
         NULL            AS ORG_SRC_CODE,
         NULL            AS START_DATE,
         NULL            AS END_DATE,
         NULL            AS START_FLAG,
         NULL            AS ORG_AREA_ID,
         NULL            AS ORG_AREA,
         NULL            AS ORG_CY,
         ORG_CODE
    FROM org_ys),
org_x as
 (SELECT *
    FROM FATHER_org -- where org_id in (select distinct orgid from DM_MCL_RESAREA)
  UNION ALL
  SELECT *
    FROM HW_Z)
SELECT *
  FROM (select x.*
          from org_x x
         where org_code like 'HXCYXC%'
           and org_id not in
               ('5FB62123-5DF2-0750-0F82-F04B251EA55E',
                '9E3CFC37-AA68-46AB-96AA-C9BE391C37C6')
        union all
        select ORG_ID,
               'HJ' FATHER_ID,
               ORG_NAME,
               ORG_SNAME,
               ORG_EN_NAME,
               ORG_LEVEL,
               ORDER_KEY,
               ORG_TYPE_ID,
               ORG_TYPE,
               ORG_CLASSIFY_ID,
               ORG_CLASSIFY,
               LONGITUDE,
               LATITUDE,
               ORG_SRC_CODE,
               START_DATE,
               END_DATE,
               START_FLAG,
               ORG_AREA_ID,
               ORG_AREA,
               ORG_CY,
               ORG_CODE
          from org_x x
         where x. org_id = '5FB62123-5DF2-0750-0F82-F04B251EA55E') RES
         WHERE 1=1 --AND org_code like ${if(len(org)=0,"'HXCYXC%'","'"+org+"%'")} 
 ORDER BY order_key
/*and org_id =
(SELECT org_id from dim_org where 1=1   and org_id =(select father_id from dim_org where  org_sname='固安'))
*/
--order by order_key


/*
select * from dim_org where org_code like 'HXCYXC%' and org_id =
(SELECT org_id from dim_org where 1=1   and org_id =(select father_id from dim_org where  org_sname='固安'))
*/



select ORG_ID,
       CASE
         WHEN ORG_ID = 'E0A3D386-D5C8-FB22-18DE-4424D49363B2' THEN
          NULL
         when ORG_ID = '5FB62123-5DF2-0750-0F82-F04B251EA55E' THEN
           'E0A3D386-D5C8-FB22-18DE-4424D49363B3'
         ELSE
          FATHER_ID
       END FATHER_ID,
       ORG_NAME,
       ORG_SNAME,
       org_level,
       ORDER_KEY,
       org_classify_id,
       org_classify,
       ORG_CODE
  from dim_org
 WHERE ORG_CODE LIKE 'HXCYXC%'
   and org_id !='9E3CFC37-AA68-46AB-96AA-C9BE391C37C6'
   and (org_code not like 'HXCYXCGJ%' OR org_code = 'HXCYXCGJ')
 ORDER BY order_key



-----------------------------------














WITH org_ys AS(
SELECT org_sname AS org_classify_id
      ,org_id
      ,org_id || '1' AS classify_id
      ,'环京' AS org_classify
      ,order_key + 1 AS order_key
      ,org_code
  FROM dim_org
 WHERE org_type = '集团'
   AND org_id NOT IN ('E0A3D386-D5C8-FB22-18DE-4424D49363B2'
                     ,'7F1F77EC-7E86-4753-9916-E87EEA54A754'
                     ,'E0A3D386-D5C8-FB22-18DE-4424D49363B4'
                     ,'E0A3D386-D5C8-FB22-18DE-4424D49363B5')
UNION ALL
SELECT org_sname AS org_classify_id
      ,org_id
      ,org_id || '2' AS classify_id
      ,'外埠' AS org_classify
      ,order_key + 2 AS order_key
      ,org_code
  FROM dim_org
 WHERE org_type = '集团'
   AND org_id NOT IN ('E0A3D386-D5C8-FB22-18DE-4424D49363B2'
                     ,'7F1F77EC-7E86-4753-9916-E87EEA54A754'
                     ,'E0A3D386-D5C8-FB22-18DE-4424D49363B4'
                     ,'E0A3D386-D5C8-FB22-18DE-4424D49363B5')

),
--二级父级替换
FATHER_org as (
SELECT 
b.ORG_ID,
CASE WHEN a.CLASSIFY_id IS NULL THEN b.FATHER_ID ELSE a.CLASSIFY_id END as FATHER_ID,
b.ORG_NAME,
b.ORG_SNAME,
b.ORG_EN_NAME,
b.ORG_LEVEL,
b.ORDER_KEY,
b.ORG_TYPE_ID,
b.ORG_TYPE,
b.ORG_CLASSIFY_ID,
b.ORG_CLASSIFY,
b.LONGITUDE,
b.LATITUDE,
b.ORG_SRC_CODE,
b.START_DATE,
b.END_DATE,
b.START_FLAG,
b.ORG_AREA_ID,
b.ORG_AREA,
b.ORG_CY,
b.ORG_CODE
FROM DIM_ORG  b
LEFT JOIN org_ys a
ON a.ORG_ID=b.FATHER_ID
AND a.ORG_CLASSIFY=b.ORG_CLASSIFY
),
--增加环京外埠
HW_Z AS (
SELECT 
CLASSIFY_id AS ORG_ID,
ORG_ID AS FATHER_ID,
ORG_CLASSIFY AS ORG_NAME,
ORG_CLASSIFY AS ORG_SNAME,
NULL AS ORG_EN_NAME,
NULL AS ORG_LEVEL,
ORDER_KEY,
NULL AS ORG_TYPE_ID,
NULL AS ORG_TYPE,
ORG_CLASSIFY_ID,
ORG_CLASSIFY,
NULL AS LONGITUDE,
NULL AS LATITUDE,
NULL AS ORG_SRC_CODE,
NULL AS START_DATE,
NULL AS END_DATE,
NULL AS START_FLAG,
NULL AS ORG_AREA_ID,
NULL AS ORG_AREA,
NULL AS ORG_CY,
ORG_CODE
FROM org_ys
),
org_x as(
SELECT * FROM FATHER_org 
/*where org_id in (select org_id from DM_MCL_FLOW 
where 1=1
${if(len(org)=0,"and type='股份公司'",if(org="股份公司","and type='股份公司'",
if(org="全口径","and type = '全口径'",
if(org="产业新城","and type = '其他'",
if(org="其他_住宅","and type='其他' ",
if(org="其他_小镇","and type='其他' ","and type='股份公司"))))))}
)*/
UNION ALL
SELECT * FROM HW_Z
)
select * from (
select  * from org_x x  where 1=1
${if(len(orgcode)=0,if(org="股份公司"," and x.org_code like 'HXCYXC%' and x.order_key < 1790",
if(org="全口径","and x.org_code like 'HXCYXC%' and x.order_key < 1790
--union all select * from org_x where org_code like 'HXKQCZZ%'
",
if(org="产业新城","and x.org_code like 'HXCYXC%' and x.order_key < 1790 ",
if(org="其他_住宅","and x.org_code like 'HXKQCZZ%'",
if(org="其他_小镇","and x.org_code like 'HXCYXZ%' "," and x.org_code like 'HXCYXC%' "))))),"and x.org_code like '"+orgcode+"%' and x.org_code not like 'HXCYXCGJ0_%'
 and x.org_code not like 'HXCYXCGJ1_%'")})
order by order_key 
