WITH date1 as(
select data_date date1 from dm_mcl_acct where rownum = 1
),
DIM_DATEKJ AS (
SELECT 
    CASE WHEN '����'='${periodtype}' THEN PERIOD_YEAR
         WHEN '����'='${periodtype}' THEN PERIOD_QUARTER
         WHEN '����'='${periodtype}' THEN PERIOD_MONTH END AS CALIBER ,--�ҵ��ҵ�ǰʱ������ھ������ꡢ���������£�
    '1' as ORDER_CALIBER
    FROM DIM_PERIOD , date1 --ʱ��ά��
WHERE PERIOD_KEY=date1.date1
),--��ǰʱ��ھ� �ꡢ���ȡ��·�

DIM_DATEMX AS ( 
SELECT
    DISTINCT 
    CASE WHEN '����'='${periodtype}' THEN PERIOD_YEAR
         WHEN '����'='${periodtype}' THEN PERIOD_QUARTER
         WHEN '����'='${periodtype}' THEN PERIOD_MONTH END AS periodtypeIBER,--�ھ�
    CASE WHEN '����'='${periodtype}' THEN PERIOD_QUARTER
         WHEN '����'='${periodtype}' THEN PERIOD_MONTH
         WHEN '����'='${periodtype}' THEN WEEK_NBR_IN_MONTH END AS periodtypeIBER_S --�ھ�2
FROM DIM_PERIOD --ʱ��ά��
),--ʱ��ھ�ά��

DIM_DATES AS(
/*SELECT 
    CALIBER ,
    CASE WHEN '����'='${periodtype}' THEN substr(CALIBER,1,4) 
         WHEN '����'='${periodtype}' THEN substr(date1.date1,1,4) ||'Q0'||substr(CALIBER,1,1) 
         WHEN '����'='${periodtype}' THEN substr(date1.date1,1,4) ||'M'||substr(CALIBER,1,2) 
    END as Statistical_time ,ORDER_CALIBER
FROM DIM_DATEKJ, date1
UNION ALL
*/
SELECT 
    b.periodtypeIBER_S as CALIBER,
    CASE WHEN '����'='${periodtype}' THEN substr(date1,1,4) ||'Q0'||substr(b.periodtypeIBER_S,1,1) 
         WHEN '����'='${periodtype}' THEN substr(date1,1,4) ||'M'||substr(b.periodtypeIBER_S,1,2) 
         WHEN '����'='${periodtype}' THEN substr(date1,1,4) ||'M'||substr(date1,5,2)||'W'||substr(b.periodtypeIBER_S,2,1) 
    END as Statistical_time , 
    CASE WHEN '����'='${periodtype}' THEN substr(date1,1,4) ||'Q0'||substr(b.periodtypeIBER_S,1,1) 
         WHEN '����'='${periodtype}' THEN substr(date1,1,4) ||'M'||substr(b.periodtypeIBER_S,1,2) 
         WHEN '����'='${periodtype}' THEN substr(date1,1,4) ||'M'||substr(date1,5,2)||'W'||substr(b.periodtypeIBER_S,2,1) 
    END as ORDER_CALIBER
FROM DIM_DATEKJ a
LEFT JOIN DIM_DATEMX b
ON a.CALIBER=b.periodtypeIBER
left join date1
on 1=1
), --����ʱ��ά��

DATE_INDEX AS (
SELECT INDEX_ID,INDEX_NAME,ORDER_KEY FROM DIM_INDEX 
WHERE INDEX_id='b104c15725554e21a985eb28a31eaf61'
),--ָ��ά��

DIM_ORF_HX AS(
SELECT ORG_ID,ORG_NAME FROM DIM_ORG 
where org_id = '${org}'
)--��ҵ�³�ά��



SELECT a.CALIBER, --ʱ��ھ� 
A.ORDER_CALIBER,
    a.STATISTICAL_TIME, --ʱ��ھ�
    --c.ORG_NAME, --��֯��������
    --c.ORG_ID, --��֯����id
    d.INDEX_NAME, --ָ������
    d.INDEX_ID, --ָ��id
    d.ORDER_KEY, --ָ������
    round(sum(NVL(e.TARGET_VALUE, 0))) TARGET_VALUE,
    round(sum(NVL(e.ACTUAL_VALUE, 0))) ACTUAL_VALUE,
    CASE WHEN sum(nvl(e.TARGET_VALUE,0))=0 THEN 0 ELSE sum(nvl(e.ACTUAL_VALUE,0))/sum(NVL(e.TARGET_VALUE, 0)) END as VALUE_lv
FROM DIM_DATES a --ʱ��ά��
LEFT JOIN DIM_ORF_HX c --��֯ά��
ON 1=1
LEFT JOIN DATE_INDEX d --ָ��ά��
ON 1=1
LEFT JOIN DM_MCL_ACCT e --��Ӫָ������
ON a.Statistical_time=e.PERIOD_TYPE_ID
AND c.ORG_ID=e.ORG_ID
AND d.INDEX_ID=e.INDEX_ID
group by a.CALIBER, --ʱ��ھ�
A.ORDER_CALIBER,
    a.STATISTICAL_TIME, --ʱ��ھ�
    --c.ORG_NAME, --��֯��������
    --c.ORG_ID, --��֯����id
    d.INDEX_NAME, --ָ������
    d.INDEX_ID, --ָ��id
    d.ORDER_KEY
ORDER BY A.ORDER_CALIBER, d.ORDER_KEY


SELECT * FROM DM_MCL_ACCT 
 WHERE index_id='b104c15725554e21a985eb28a31eaf61'
  and length(period_type_id)=4   --�������
  order by period_type_id
;
SELECT * FROM DM_MCL_ACCT 
 WHERE index_id='b104c15725554e21a985eb28a31eaf61'
  and substr(period_type_id,5,1) ='Q'  --��������
  order by period_type_id
;
SELECT * FROM DM_MCL_ACCT 
 WHERE index_id='b104c15725554e21a985eb28a31eaf61'
  and substr(period_type_id,5,1) ='M'  --�·�����
  and length(period_type_id)=7
  order by period_type_id
;
SELECT * FROM DM_MCL_ACCT 
 WHERE index_id='b104c15725554e21a985eb28a31eaf61'
  and substr(period_type_id,5,1) ='M'  --������
  and length(period_type_id)=9
  order by period_type_id
  
select tochar(sysdate)
