<?xml version="1.0" encoding="UTF-8"?>
<Form xmlVersion="20170715" releaseVersion="8.0.0">
<TableDataMap>
<TableData name="员工简历" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="id"/>
<O>
<![CDATA[]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[华夏幸福]]></DatabaseName>
</Connection>
<Query>
<![CDATA[select
*
from SYSADM.PS_YGJLCX_VW
where 1=1
${if(len(id)=0,"and 1=0","and YGID ='"+id+"'")}
]]></Query>
</TableData>
<TableData name="晋升" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="id"/>
<O>
<![CDATA[10026004]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[华夏幸福]]></DatabaseName>
</Connection>
<Query>
<![CDATA[select 
*
from
SYSADM.PS_YGJLCX_JSXX_VW
where 1=1
${if(len(id)=0,"and 1=0","and YGID ='"+id+"'")}]]></Query>
</TableData>
<TableData name="内部工作履历" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="id"/>
<O>
<![CDATA[10066267]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[华夏幸福]]></DatabaseName>
</Connection>
<Query>
<![CDATA[WITH
TT AS
(

SELECT A.EMPLID YGID
  ,
  --员工ID                   
  A.EFFDT EFFDT
  ,
  --操作时间
  B.ACTION_DESCR
  ,
  --操作
  (
    SELECT DESCR254
    FROM SYSADM.HR_VW_DEPT_TBL X
      ,SYSADM.ODS_HR_JOB_VW JOBA
    WHERE X.SETID = JOBA.SETID_DEPT
      AND X.DEPTID = JOBA.DEPTID
      AND X.EFFDT = --A.EFFDT
      (
        SELECT MAX(M.EFFDT)
        FROM SYSADM.HR_VW_DEPT_TBL M
        WHERE M.SETID = X.SETID
          AND M.DEPTID = X.DEPTID
          AND M.EFFDT <= A.EFFDT
        )
      AND JOBA.EMPLID = A.EMPLID
      AND JOBA.EFFDT = A.EFFDT
      AND JOBA.EFFSEQ = (
        SELECT MAX(JOB2.EFFSEQ)
        FROM  SYSADM.ODS_HR_JOB_VW JOB2
        WHERE JOB2.EMPLID = JOBA.EMPLID
          AND JOB2.EMPL_RCD = JOBA.EMPL_RCD
          AND JOB2.EFFDT = JOBA.EFFDT
        )
      AND JOBA.EMPL_RCD = '0'
    ) BUMEN
  ,
  --所属部门
  (
    SELECT DESCR
    FROM SYSADM.HR_VW_HX_EMPL_CLASS A
      ,SYSADM.ODS_HR_JOB_VW JOBD
    WHERE A.EFF_STATUS = 'A'
      AND A.SETID = (
        SELECT SETID
        FROM SYSADM.HR_VW_SET_CNTRL_REC SC
        WHERE SC.SETCNTRLVALUE = JOBD.BUSINESS_UNIT
          AND SC.RECNAME = 'HX_EMPL_CLASS'
        )
      AND A.HX_EMPL_CLASS = JOBD.HX_EMPL_CLASS
      AND A.EFFDT = (
        SELECT MAX(B.EFFDT)
        FROM SYSADM.HR_VW_HX_EMPL_CLASS B
        WHERE B.EFF_STATUS = 'A'
          AND B.SETID = A.SETID
          AND B.HX_EMPL_CLASS = A.HX_EMPL_CLASS
          AND B.EFFDT <= TO_DATE(TO_CHAR(SYSDATE, 'YYYY-MM-DD'), 'YYYY-MM-DD')
        )
      AND JOBD.EMPLID = A.EMPLID
      AND JOBD.EFFDT = A.EFFDT
      AND JOBD.EFFSEQ = (
        SELECT MAX(JOB5.EFFSEQ)
        FROM SYSADM.ODS_HR_JOB_VW JOB5
        WHERE JOB5.EMPLID = JOBD.EMPLID
          AND JOB5.EMPL_RCD = JOBD.EMPL_RCD
          AND JOB5.EFFDT = JOBD.EFFDT
        )
      AND JOBD.EMPL_RCD = '0'
    ) YGFENLEI
  ,
  --员工分类
  (
    SELECT DESCR
    FROM SYSADM.HR_VW_POSITION_DATA Y
      ,SYSADM.ODS_HR_JOB_VW JOBB
    WHERE Y.EFF_STATUS = 'A'
      AND Y.POSITION_NBR = JOBB.POSITION_NBR
      AND Y.EFFDT = --A.EFFDT
      (
        SELECT MAX(N.EFFDT)
        FROM SYSADM.HR_VW_POSITION_DATA N
        WHERE N.POSITION_NBR = Y.POSITION_NBR
          AND N.EFFDT <= A.EFFDT
        )
      AND JOBB.EMPLID = A.EMPLID
      AND JOBB.EFFDT = A.EFFDT
      AND JOBB.EFFSEQ = (
        SELECT MAX(JOB3.EFFSEQ)
        FROM SYSADM.ODS_HR_JOB_VW JOB3
        WHERE JOB3.EMPLID = JOBB.EMPLID
          AND JOB3.EMPL_RCD = JOBB.EMPL_RCD
          AND JOB3.EFFDT = JOBB.EFFDT
        )
      AND JOBB.EMPL_RCD = '0'
    ) ZHIWEI
  ,
  --职位干部
  (
    SELECT DESCR
    FROM SYSADM.HR_VW_JOBCODE_TBL Z
      ,SYSADM.ODS_HR_JOB_VW JOBC
    WHERE Z.EFF_STATUS = 'A'
      AND Z.SETID = (
        SELECT HR_VW_SET_CNTRL_GROUP.SETID
        FROM SYSADM.HR_VW_REC_GROUP_REC
          ,SYSADM.HR_VW_SET_CNTRL_GROUP
        WHERE HR_VW_REC_GROUP_REC.RECNAME = 'JOBCODE_TBL'
          AND HR_VW_REC_GROUP_REC.REC_GROUP_ID = HR_VW_SET_CNTRL_GROUP.REC_GROUP_ID
          AND HR_VW_SET_CNTRL_GROUP.SETCNTRLVALUE = JOBC.BUSINESS_UNIT
        )
      AND Z.JOBCODE = JOBC.JOBCODE
      AND Z.EFFDT = --A.EFFDT
      (
        SELECT MAX(P.EFFDT)
        FROM SYSADM.HR_VW_JOBCODE_TBL P
        WHERE P.SETID = Z.SETID
          AND P.JOBCODE = Z.JOBCODE
          AND P.EFFDT <= A.EFFDT
        )
      AND JOBC.EMPLID = A.EMPLID
      AND JOBC.EFFDT = A.EFFDT
      AND JOBC.EFFSEQ = (
        SELECT MAX(JOB4.EFFSEQ)
        FROM SYSADM.ODS_HR_JOB_VW JOB4
        WHERE JOB4.EMPLID = JOBC.EMPLID
          AND JOB4.EMPL_RCD = JOBC.EMPL_RCD
          AND JOB4.EFFDT = JOBC.EFFDT
        )
      AND JOBC.EMPL_RCD = '0'
    ) ZHIWU
  ,
  --职务
  A.HX_MAN_LVL_DESCR ZHIJI --现职级
FROM SYSADM.ODM_HR_PS_OCT_EXWK_OTH A
  ,SYSADM.HR_VW_ACTION_TBL B
WHERE A.EMPLID = '${id}'
  AND A.ACTION = B.ACTION
  AND B.EFF_STATUS = 'A'
--ORDER BY A.EFFDT DESC

UNION

SELECT A.EMPLID YGID
  ,
  --员工ID 
  (SELECT X.EFFDT
    FROM SYSADM.HR_VW_DEPT_TBL X
      ,SYSADM.ODS_HR_JOB_VW JOBA
    WHERE X.SETID = JOBA.SETID_DEPT
      AND X.DEPTID = JOBA.DEPTID
      AND X.EFFDT = --A.EFFDT
      (
        SELECT MAX(M.EFFDT)
        FROM SYSADM.HR_VW_DEPT_TBL M
        WHERE M.SETID = X.SETID
          AND M.DEPTID = X.DEPTID
          AND M.EFFDT <= SYSDATE
        )
      AND JOBA.EMPLID = A.EMPLID
      AND JOBA.EFFDT = A.EFFDT
      AND JOBA.EFFSEQ = (
        SELECT MAX(JOB2.EFFSEQ)
        FROM  SYSADM.ODS_HR_JOB_VW JOB2
        WHERE JOB2.EMPLID = JOBA.EMPLID
          AND JOB2.EMPL_RCD = JOBA.EMPL_RCD
          AND JOB2.EFFDT = JOBA.EFFDT
        )
      AND JOBA.EMPL_RCD = '0')                  
 EFFDT
  ,
  --操作时间
  B.ACTION_DESCR
  ,
  --操作
  (
    SELECT DESCR254
    FROM SYSADM.HR_VW_DEPT_TBL X
      ,SYSADM.ODS_HR_JOB_VW JOBA
    WHERE X.SETID = JOBA.SETID_DEPT
      AND X.DEPTID = JOBA.DEPTID
      AND X.EFFDT = --A.EFFDT
      (
        SELECT MAX(M.EFFDT)
        FROM SYSADM.HR_VW_DEPT_TBL M
        WHERE M.SETID = X.SETID
          AND M.DEPTID = X.DEPTID
          AND M.EFFDT <= SYSDATE
        )
      AND JOBA.EMPLID = A.EMPLID
      AND JOBA.EFFDT = A.EFFDT
      AND JOBA.EFFSEQ = (
        SELECT MAX(JOB2.EFFSEQ)
        FROM  SYSADM.ODS_HR_JOB_VW JOB2
        WHERE JOB2.EMPLID = JOBA.EMPLID
          AND JOB2.EMPL_RCD = JOBA.EMPL_RCD
          AND JOB2.EFFDT = JOBA.EFFDT
        )
      AND JOBA.EMPL_RCD = '0'
    ) BUMEN
  ,
  --所属部门
  (
    SELECT DESCR
    FROM SYSADM.HR_VW_HX_EMPL_CLASS A
      ,SYSADM.ODS_HR_JOB_VW JOBD
    WHERE A.EFF_STATUS = 'A'
      AND A.SETID = (
        SELECT SETID
        FROM SYSADM.HR_VW_SET_CNTRL_REC SC
        WHERE SC.SETCNTRLVALUE = JOBD.BUSINESS_UNIT
          AND SC.RECNAME = 'HX_EMPL_CLASS'
        )
      AND A.HX_EMPL_CLASS = JOBD.HX_EMPL_CLASS
      AND A.EFFDT = (
        SELECT MAX(B.EFFDT)
        FROM SYSADM.HR_VW_HX_EMPL_CLASS B
        WHERE B.EFF_STATUS = 'A'
          AND B.SETID = A.SETID
          AND B.HX_EMPL_CLASS = A.HX_EMPL_CLASS
          AND B.EFFDT <= TO_DATE(TO_CHAR(SYSDATE, 'YYYY-MM-DD'), 'YYYY-MM-DD')
        )
      AND JOBD.EMPLID = A.EMPLID
      AND JOBD.EFFDT = A.EFFDT
      AND JOBD.EFFSEQ = (
        SELECT MAX(JOB5.EFFSEQ)
        FROM SYSADM.ODS_HR_JOB_VW JOB5
        WHERE JOB5.EMPLID = JOBD.EMPLID
          AND JOB5.EMPL_RCD = JOBD.EMPL_RCD
          AND JOB5.EFFDT = JOBD.EFFDT
        )
      AND JOBD.EMPL_RCD = '0'
    ) YGFENLEI
  ,
  --员工分类
  (
    SELECT DESCR
    FROM SYSADM.HR_VW_POSITION_DATA Y
      ,SYSADM.ODS_HR_JOB_VW JOBB
    WHERE Y.EFF_STATUS = 'A'
      AND Y.POSITION_NBR = JOBB.POSITION_NBR
      AND Y.EFFDT = --A.EFFDT
      (
        SELECT MAX(N.EFFDT)
        FROM SYSADM.HR_VW_POSITION_DATA N
        WHERE N.POSITION_NBR = Y.POSITION_NBR
          AND N.EFFDT <= A.EFFDT
        )
      AND JOBB.EMPLID = A.EMPLID
      AND JOBB.EFFDT = A.EFFDT
      AND JOBB.EFFSEQ = (
        SELECT MAX(JOB3.EFFSEQ)
        FROM SYSADM.ODS_HR_JOB_VW JOB3
        WHERE JOB3.EMPLID = JOBB.EMPLID
          AND JOB3.EMPL_RCD = JOBB.EMPL_RCD
          AND JOB3.EFFDT = JOBB.EFFDT
        )
      AND JOBB.EMPL_RCD = '0'
    ) ZHIWEI
  ,
  --职位干部
  (
    SELECT DESCR
    FROM SYSADM.HR_VW_JOBCODE_TBL Z
      ,SYSADM.ODS_HR_JOB_VW JOBC
    WHERE Z.EFF_STATUS = 'A'
      AND Z.SETID = (
        SELECT HR_VW_SET_CNTRL_GROUP.SETID
        FROM SYSADM.HR_VW_REC_GROUP_REC
          ,SYSADM.HR_VW_SET_CNTRL_GROUP
        WHERE HR_VW_REC_GROUP_REC.RECNAME = 'JOBCODE_TBL'
          AND HR_VW_REC_GROUP_REC.REC_GROUP_ID = HR_VW_SET_CNTRL_GROUP.REC_GROUP_ID
          AND HR_VW_SET_CNTRL_GROUP.SETCNTRLVALUE = JOBC.BUSINESS_UNIT
        )
      AND Z.JOBCODE = JOBC.JOBCODE
      AND Z.EFFDT = --A.EFFDT
      (
        SELECT MAX(P.EFFDT)
        FROM SYSADM.HR_VW_JOBCODE_TBL P
        WHERE P.SETID = Z.SETID
          AND P.JOBCODE = Z.JOBCODE
          AND P.EFFDT <= A.EFFDT
        )
      AND JOBC.EMPLID = A.EMPLID
      AND JOBC.EFFDT = A.EFFDT
      AND JOBC.EFFSEQ = (
        SELECT MAX(JOB4.EFFSEQ)
        FROM SYSADM.ODS_HR_JOB_VW JOB4
        WHERE JOB4.EMPLID = JOBC.EMPLID
          AND JOB4.EMPL_RCD = JOBC.EMPL_RCD
          AND JOB4.EFFDT = JOBC.EFFDT
        )
      AND JOBC.EMPL_RCD = '0'
    ) ZHIWU
  ,
  --职务
  A.HX_MAN_LVL_DESCR ZHIJI --现职级
FROM SYSADM.ODM_HR_PS_OCT_EXWK_OTH A
  ,SYSADM.HR_VW_ACTION_TBL B
WHERE A.EMPLID = '${id}'
  AND A.ACTION = B.ACTION
  AND B.EFF_STATUS = 'A'
  AND A.EFFDT = (
   SELECT MAX(JOB2.EFFDT)
        FROM  SYSADM.ODS_HR_JOB_VW JOB2
        WHERE JOB2.EMPLID = A.EMPLID
          --AND JOB2.EMPL_RCD = A.EMPL_RCD
         -- AND JOB2.EFFSEQ = A.EFFSEQ
  )
  AND EXISTS (SELECT 1
                FROM SYSADM.HR_VW_DEPT_TBL X
                     ,SYSADM.ODS_HR_JOB_VW JOBA
        WHERE X.SETID = JOBA.SETID_DEPT
      AND X.DEPTID = JOBA.DEPTID
      AND X.EFFDT = --A.EFFDT
      (
        SELECT MAX(M.EFFDT)
        FROM SYSADM.HR_VW_DEPT_TBL M
        WHERE M.SETID = X.SETID
          AND M.DEPTID = X.DEPTID
          AND M.EFFDT <= SYSDATE
        )
      AND JOBA.EMPLID = A.EMPLID
      AND JOBA.EFFDT = (
     SELECT MAX(JOB2.EFFDT)
        FROM  SYSADM.ODS_HR_JOB_VW JOB2
        WHERE JOB2.EMPLID = JOBA.EMPLID
          AND JOB2.EMPL_RCD = JOBA.EMPL_RCD
          AND JOB2.EFFDT <= TO_DATE(TO_CHAR(SYSDATE, 'YYYY-MM-DD'),'YYYY-MM-DD')
    )
      AND JOBA.EFFSEQ = (
        SELECT MAX(JOB2.EFFSEQ)
        FROM  SYSADM.ODS_HR_JOB_VW JOB2
        WHERE JOB2.EMPLID = JOBA.EMPLID
          AND JOB2.EMPL_RCD = JOBA.EMPL_RCD
          AND JOB2.EFFDT = JOBA.EFFDT
        )
      AND JOBA.EMPL_RCD = '0'
      AND JOBA.EFFDT < X.EFFDT    
        )


),

 TT1 AS (
 SELECT  YGID,
         EFFDT,
         BUMEN,
        YGFENLEI,
CASE WHEN TT.ZHIWEI = '' or TT.ZHIWEI IS NULL
     THEN TT.ZHIWU
     ELSE TT.ZHIWEI
   END AS ZHIWU,
       ZHIJI, 
    CASE WHEN  LAG(BUMEN) over(order by EFFDT) IS NULL   THEN ' ' ELSE  LAG(BUMEN) over(order by EFFDT) END  AS BUMEN1 ,
     CASE WHEN  LAG(YGFENLEI) over(order by EFFDT) IS NULL THEN ' ' ELSE LAG(YGFENLEI) over(order by EFFDT) END AS YGFENLEI1 ,
   CASE WHEN 
    LAG(CASE WHEN TT.ZHIWEI = '' or TT.ZHIWEI IS NULL  THEN TT.ZHIWU  ELSE TT.ZHIWEI END) over(order by EFFDT) IS NULL THEN ' '
     ELSE  LAG(CASE WHEN TT.ZHIWEI = '' or TT.ZHIWEI IS NULL   THEN TT.ZHIWU   ELSE TT.ZHIWEI  END) over(order by EFFDT) 
       END AS   ZHIWU1 ,
     CASE WHEN LAG(ZHIJI) over(order by EFFDT) IS NULL  THEN ' ' ELSE LAG(ZHIJI) over(order by EFFDT) END AS  ZHIJI1 
  FROM TT

  )  
,

AA AS
(

SELECT YGID,
       EFFDT,    
       BUMEN,
       YGFENLEI,
       ZHIWU,
       ZHIJI
  FROM TT1
  WHERE BUMEN<>BUMEN1
   OR YGFENLEI<>YGFENLEI
   OR ZHIWU<>ZHIWU1
   OR ZHIJI<>ZHIJI1

 
 UNION 

 SELECT YGID,
        EFFDT,
       BUMEN,
       YGFENLEI,
CASE WHEN TT.ZHIWEI = '' or TT.ZHIWEI IS NULL
     THEN TT.ZHIWU
     ELSE TT.ZHIWEI
   END ZHIWU,
       ZHIJI
  FROM TT
WHERE ACTION_DESCR IN ('雇用','重新雇用','辞职','辞退','实习期结束')

)

SELECT AA.YGID,
       AA.EFFDT,
       TT.ACTION_DESCR,
       AA.BUMEN,
       AA.YGFENLEI,
       AA.ZHIWU,
       AA.ZHIJI
  FROM AA
  LEFT JOIN TT
    ON AA.YGID = TT.YGID
   AND AA.EFFDT = TT.EFFDT
    ORDER BY EFFDT DESC]]></Query>
</TableData>
<TableData name="外部工作履历" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="id"/>
<O>
<![CDATA[10026004]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[华夏幸福]]></DatabaseName>
</Connection>
<Query>
<![CDATA[select 
*
from
SYSADM.PS_YGJLCX_WBGZLL_VW
where 1=1
${if(len(id)=0,"and 1=0","and YGID ='"+id+"'")}]]></Query>
</TableData>
<TableData name="内部培训参训" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="id"/>
<O>
<![CDATA[10026004]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[华夏幸福]]></DatabaseName>
</Connection>
<Query>
<![CDATA[select 
YGID,
XXXMMC,
XXXMLX,
STARTTIME,
ENDTIME,
CXTIME AS CXTIME
from
SYSADM.PS_YGJLCX_CX_VW
where 1=1
${if(len(id)=0,"and 1=0","and YGID ='"+id+"'")}]]></Query>
</TableData>
<TableData name="教育经历" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="id"/>
<O>
<![CDATA[10023970]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[华夏幸福]]></DatabaseName>
</Connection>
<Query>
<![CDATA[select *
from SYSADM.PS_YGJLCX_JYJL_VW
where 1=1
${if(len(id)=0,"and 1=0","and YGID='"+id+"'")}]]></Query>
</TableData>
<TableData name="绩效" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="id"/>
<O>
<![CDATA[10000001]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[华夏幸福]]></DatabaseName>
</Connection>
<Query>
<![CDATA[SELECT
 DISTINCT T.JXYEAR,
	T.YGID, 
	T1.JXZQ AS Q1,
	T1.LASTJX AS Q1JX,
	T2.JXZQ  AS Q2,
	T2.LASTJX AS Q2JX,
	T3.JXZQ  AS Q3,
	T3.LASTJX AS Q3JX,
	T4.JXZQ  AS Y,
	T4.LASTJX AS NDJX
FROM SYSADM.PS_YGJLCX_JXXX_VW T
LEFT  JOIN SYSADM.PS_YGJLCX_JXXX_VW T1
ON T.YGID = T1.YGID
AND T1.JXZQ LIKE '%Q1'
AND T.JXYEAR=T1.JXYEAR
LEFT  JOIN SYSADM.PS_YGJLCX_JXXX_VW T2
ON T.YGID = T2.YGID
AND T2.JXZQ LIKE '%Q2'
AND T.JXYEAR=T2.JXYEAR
LEFT  JOIN SYSADM.PS_YGJLCX_JXXX_VW T3
ON T.YGID = T3.YGID
AND T3.JXZQ LIKE '%Q3'
AND T.JXYEAR=T3.JXYEAR
LEFT  JOIN SYSADM.PS_YGJLCX_JXXX_VW T4
ON T.YGID = T4.YGID
AND (T4.JXZQ LIKE '%Y' OR T4.JXZQ LIKE '%Q4')
AND T.JXYEAR=T4.JXYEAR
WHERE 1=1 ${if(len(id)=0,"and 1=0","and T.YGID ='"+id+"'")}  
and(
( T1.LASTJX  is not null and T1.LASTJX<>' ' )
or (T2.LASTJX  is not null and T2.LASTJX<>' ' )
or (T3.LASTJX  is not null and T3.LASTJX<>' ' )
or (T4.LASTJX  is not null and T4.LASTJX<>' ' )
)
ORDER BY T.JXYEAR ASC]]></Query>
</TableData>
<TableData name="家庭成员" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="id"/>
<O>
<![CDATA[10026004]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[华夏幸福]]></DatabaseName>
</Connection>
<Query>
<![CDATA[SELECT *
FROM SYSADM.PS_YGJLCX_JTCY_VW
WHERE 1=1 ${if(len(id)=0,"and 1=0","and YGID ='"+id+"'")}]]></Query>
</TableData>
<TableData name="授课" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="id"/>
<O>
<![CDATA[10026004]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[华夏幸福]]></DatabaseName>
</Connection>
<Query>
<![CDATA[select 
XXXMMC,
XXXMLX,
SKORHD,
SKTIME,
STARTTIME,
ENDTIME,
MANYIDU
from
SYSADM.PS_YGJLCX_SK_VW
where 1=1
${if(len(id)=0,"and 1=0","and YGID ='"+id+"'")}]]></Query>
</TableData>
<TableData name="ds1" class="com.fr.data.impl.DBTableData">
<Parameters/>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[华夏幸福]]></DatabaseName>
</Connection>
<Query>
<![CDATA[select *
from SYSADM.PS_YGJLCX_VW
where 1=1
]]></Query>
</TableData>
<TableData name="照片" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="id"/>
<O>
<![CDATA[]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[华夏幸福]]></DatabaseName>
</Connection>
<Query>
<![CDATA[SELECT EMPLOYEE_PHOTO
FROM SYSADM.PS_EMPL_PHOTO
WHERE EMPLID ='${id}' --'10017641']]></Query>
</TableData>
<TableData name="ds3" class="com.fr.data.impl.DBTableData">
<Parameters/>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[华夏幸福]]></DatabaseName>
</Connection>
<Query>
<![CDATA[WITH
TT AS
(SELECT A.EMPLID YGID
  ,
  --员工ID                   
  A.EFFDT EFFDT
  ,
  --操作时间
  B.ACTION_DESCR
  ,
  --操作
  (
    SELECT DESCR254
    FROM SYSADM.PS_DEPT_TBL X
      ,SYSADM.PS_JOB JOBA
    WHERE X.SETID = JOBA.SETID_DEPT
      AND X.DEPTID = JOBA.DEPTID
      AND X.EFFDT = --A.EFFDT
      (
        SELECT MAX(M.EFFDT)
        FROM SYSADM.PS_DEPT_TBL M
        WHERE M.SETID = X.SETID
          AND M.DEPTID = X.DEPTID
          AND M.EFFDT <= A.EFFDT
        )
      AND JOBA.EMPLID = A.EMPLID
      AND JOBA.EFFDT = A.EFFDT
      AND JOBA.EFFSEQ = (
        SELECT MAX(JOB2.EFFSEQ)
        FROM  SYSADM.PS_JOB JOB2
        WHERE JOB2.EMPLID = JOBA.EMPLID
          AND JOB2.EMPL_RCD = JOBA.EMPL_RCD
          AND JOB2.EFFDT = JOBA.EFFDT
        )
      AND JOBA.EMPL_RCD = '0'
    ) BUMEN
  ,
  --所属部门
  (
    SELECT DESCR
    FROM SYSADM.PS_HX_EMPL_CLASS A
      ,SYSADM.PS_JOB JOBD
    WHERE A.EFF_STATUS = 'A'
      AND A.SETID = (
        SELECT SETID
        FROM SYSADM.PS_SET_CNTRL_REC SC
        WHERE SC.SETCNTRLVALUE = JOBD.BUSINESS_UNIT
          AND SC.RECNAME = 'HX_EMPL_CLASS'
        )
      AND A.HX_EMPL_CLASS = JOBD.HX_EMPL_CLASS
      AND A.EFFDT = (
        SELECT MAX(B.EFFDT)
        FROM SYSADM.PS_HX_EMPL_CLASS B
        WHERE B.EFF_STATUS = 'A'
          AND B.SETID = A.SETID
          AND B.HX_EMPL_CLASS = A.HX_EMPL_CLASS
          AND B.EFFDT <= TO_DATE(TO_CHAR(SYSDATE, 'YYYY-MM-DD'), 'YYYY-MM-DD')
        )
      AND JOBD.EMPLID = A.EMPLID
      AND JOBD.EFFDT = A.EFFDT
      AND JOBD.EFFSEQ = (
        SELECT MAX(JOB5.EFFSEQ)
        FROM SYSADM.PS_JOB JOB5
        WHERE JOB5.EMPLID = JOBD.EMPLID
          AND JOB5.EMPL_RCD = JOBD.EMPL_RCD
          AND JOB5.EFFDT = JOBD.EFFDT
        )
      AND JOBD.EMPL_RCD = '0'
    ) YGFENLEI
  ,
  --员工分类
  (
    SELECT DESCR
    FROM SYSADM.PS_POSITION_DATA Y
      ,SYSADM.PS_JOB JOBB
    WHERE Y.EFF_STATUS = 'A'
      AND Y.POSITION_NBR = JOBB.POSITION_NBR
      AND Y.EFFDT = --A.EFFDT
      (
        SELECT MAX(N.EFFDT)
        FROM SYSADM.PS_POSITION_DATA N
        WHERE N.POSITION_NBR = Y.POSITION_NBR
          AND N.EFFDT <= A.EFFDT
        )
      AND JOBB.EMPLID = A.EMPLID
      AND JOBB.EFFDT = A.EFFDT
      AND JOBB.EFFSEQ = (
        SELECT MAX(JOB3.EFFSEQ)
        FROM SYSADM.PS_JOB JOB3
        WHERE JOB3.EMPLID = JOBB.EMPLID
          AND JOB3.EMPL_RCD = JOBB.EMPL_RCD
          AND JOB3.EFFDT = JOBB.EFFDT
        )
      AND JOBB.EMPL_RCD = '0'
    ) ZHIWEI
  ,
  --职位干部
  (
    SELECT DESCR
    FROM SYSADM.PS_JOBCODE_TBL Z
      ,SYSADM.PS_JOB JOBC
    WHERE Z.EFF_STATUS = 'A'
      AND Z.SETID = (
        SELECT PS_SET_CNTRL_GROUP.SETID
        FROM SYSADM.PS_REC_GROUP_REC
          ,SYSADM.PS_SET_CNTRL_GROUP
        WHERE PS_REC_GROUP_REC.RECNAME = 'JOBCODE_TBL'
          AND PS_REC_GROUP_REC.REC_GROUP_ID = PS_SET_CNTRL_GROUP.REC_GROUP_ID
          AND PS_SET_CNTRL_GROUP.SETCNTRLVALUE = JOBC.BUSINESS_UNIT
        )
      AND Z.JOBCODE = JOBC.JOBCODE
      AND Z.EFFDT = --A.EFFDT
      (
        SELECT MAX(P.EFFDT)
        FROM SYSADM.PS_JOBCODE_TBL P
        WHERE P.SETID = Z.SETID
          AND P.JOBCODE = Z.JOBCODE
          AND P.EFFDT <= A.EFFDT
        )
      AND JOBC.EMPLID = A.EMPLID
      AND JOBC.EFFDT = A.EFFDT
      AND JOBC.EFFSEQ = (
        SELECT MAX(JOB4.EFFSEQ)
        FROM SYSADM.PS_JOB JOB4
        WHERE JOB4.EMPLID = JOBC.EMPLID
          AND JOB4.EMPL_RCD = JOBC.EMPL_RCD
          AND JOB4.EFFDT = JOBC.EFFDT
        )
      AND JOBC.EMPL_RCD = '0'
    ) ZHIWU
  ,
  --职务
  A.HX_MAN_LVL_DESCR ZHIJI --现职级
FROM SYSADM.ODM_HR_PS_OCT_EXWK_OTH A
  ,SYSADM.PS_ACTION_TBL B
WHERE A.EMPLID = '10000194'
  AND A.ACTION = B.ACTION
  AND B.EFF_STATUS = 'A'
ORDER BY A.EFFDT DESC
),

AA AS
(
SELECT YGID,
       MIN(EFFDT) EFFDT,    
       BUMEN,
       YGFENLEI,
       ZHIWEI,
       ZHIWU,
       ZHIJI
  FROM TT
 GROUP BY YGID,BUMEN,YGFENLEI,ZHIWEI,ZHIWU,ZHIJI
 
 UNION 
 
 SELECT YGID,
        EFFDT,
       BUMEN,
       YGFENLEI,
       ZHIWEI,
       ZHIWU,
       ZHIJI
  FROM TT
WHERE ACTION_DESCR IN ('雇用','重新雇用','辞职','辞退','实习期结束')
 ORDER BY EFFDT DESC
)

SELECT AA.YGID,
       AA.EFFDT,
       TT.ACTION_DESCR,
       AA.BUMEN,
       AA.YGFENLEI,
   CASE WHEN AA.ZHIWEI = '' or AA.ZHIWEI IS NULL
     THEN AA.ZHIWU
     ELSE AA.ZHIWEI
   END ZHIWU,
       AA.ZHIJI
  FROM AA
  LEFT JOIN TT
    ON AA.YGID = TT.YGID
   AND AA.EFFDT = TT.EFFDT]]></Query>
</TableData>
<TableData name="内部工作履历_bak" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="id"/>
<O>
<![CDATA[]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[华夏幸福]]></DatabaseName>
</Connection>
<Query>
<![CDATA[WITH
TT AS
(SELECT A.EMPLID YGID
  ,
  --员工ID                   
  A.EFFDT EFFDT
  ,
  --操作时间
  B.ACTION_DESCR
  ,
  --操作
  (
    SELECT DESCR254
    FROM SYSADM.PS_DEPT_TBL X
      ,SYSADM.ODS_HR_JOB_VW JOBA
    WHERE X.SETID = JOBA.SETID_DEPT
      AND X.DEPTID = JOBA.DEPTID
      AND X.EFFDT = --A.EFFDT
      (
        SELECT MAX(M.EFFDT)
        FROM SYSADM.PS_DEPT_TBL M
        WHERE M.SETID = X.SETID
          AND M.DEPTID = X.DEPTID
          AND M.EFFDT <= A.EFFDT
        )
      AND JOBA.EMPLID = A.EMPLID
      AND JOBA.EFFDT = A.EFFDT
      AND JOBA.EFFSEQ = (
        SELECT MAX(JOB2.EFFSEQ)
        FROM  SYSADM.ODS_HR_JOB_VW JOB2
        WHERE JOB2.EMPLID = JOBA.EMPLID
          AND JOB2.EMPL_RCD = JOBA.EMPL_RCD
          AND JOB2.EFFDT = JOBA.EFFDT
        )
      AND JOBA.EMPL_RCD = '0'
    ) BUMEN
  ,
  --所属部门
  (
    SELECT DESCR
    FROM SYSADM.PS_HX_EMPL_CLASS A
      ,SYSADM.ODS_HR_JOB_VW JOBD
    WHERE A.EFF_STATUS = 'A'
      AND A.SETID = (
        SELECT SETID
        FROM SYSADM.PS_SET_CNTRL_REC SC
        WHERE SC.SETCNTRLVALUE = JOBD.BUSINESS_UNIT
          AND SC.RECNAME = 'HX_EMPL_CLASS'
        )
      AND A.HX_EMPL_CLASS = JOBD.HX_EMPL_CLASS
      AND A.EFFDT = (
        SELECT MAX(B.EFFDT)
        FROM SYSADM.PS_HX_EMPL_CLASS B
        WHERE B.EFF_STATUS = 'A'
          AND B.SETID = A.SETID
          AND B.HX_EMPL_CLASS = A.HX_EMPL_CLASS
          AND B.EFFDT <= TO_DATE(TO_CHAR(SYSDATE, 'YYYY-MM-DD'), 'YYYY-MM-DD')
        )
      AND JOBD.EMPLID = A.EMPLID
      AND JOBD.EFFDT = A.EFFDT
      AND JOBD.EFFSEQ = (
        SELECT MAX(JOB5.EFFSEQ)
        FROM SYSADM.ODS_HR_JOB_VW JOB5
        WHERE JOB5.EMPLID = JOBD.EMPLID
          AND JOB5.EMPL_RCD = JOBD.EMPL_RCD
          AND JOB5.EFFDT = JOBD.EFFDT
        )
      AND JOBD.EMPL_RCD = '0'
    ) YGFENLEI
  ,
  --员工分类
  (
    SELECT DESCR
    FROM SYSADM.PS_POSITION_DATA Y
      ,SYSADM.ODS_HR_JOB_VW JOBB
    WHERE Y.EFF_STATUS = 'A'
      AND Y.POSITION_NBR = JOBB.POSITION_NBR
      AND Y.EFFDT = --A.EFFDT
      (
        SELECT MAX(N.EFFDT)
        FROM SYSADM.PS_POSITION_DATA N
        WHERE N.POSITION_NBR = Y.POSITION_NBR
          AND N.EFFDT <= A.EFFDT
        )
      AND JOBB.EMPLID = A.EMPLID
      AND JOBB.EFFDT = A.EFFDT
      AND JOBB.EFFSEQ = (
        SELECT MAX(JOB3.EFFSEQ)
        FROM SYSADM.ODS_HR_JOB_VW JOB3
        WHERE JOB3.EMPLID = JOBB.EMPLID
          AND JOB3.EMPL_RCD = JOBB.EMPL_RCD
          AND JOB3.EFFDT = JOBB.EFFDT
        )
      AND JOBB.EMPL_RCD = '0'
    ) ZHIWEI
  ,
  --职位干部
  (
    SELECT DESCR
    FROM SYSADM.PS_JOBCODE_TBL Z
      ,SYSADM.ODS_HR_JOB_VW JOBC
    WHERE Z.EFF_STATUS = 'A'
      AND Z.SETID = (
        SELECT PS_SET_CNTRL_GROUP.SETID
        FROM SYSADM.PS_REC_GROUP_REC
          ,SYSADM.PS_SET_CNTRL_GROUP
        WHERE PS_REC_GROUP_REC.RECNAME = 'JOBCODE_TBL'
          AND PS_REC_GROUP_REC.REC_GROUP_ID = PS_SET_CNTRL_GROUP.REC_GROUP_ID
          AND PS_SET_CNTRL_GROUP.SETCNTRLVALUE = JOBC.BUSINESS_UNIT
        )
      AND Z.JOBCODE = JOBC.JOBCODE
      AND Z.EFFDT = --A.EFFDT
      (
        SELECT MAX(P.EFFDT)
        FROM SYSADM.PS_JOBCODE_TBL P
        WHERE P.SETID = Z.SETID
          AND P.JOBCODE = Z.JOBCODE
          AND P.EFFDT <= A.EFFDT
        )
      AND JOBC.EMPLID = A.EMPLID
      AND JOBC.EFFDT = A.EFFDT
      AND JOBC.EFFSEQ = (
        SELECT MAX(JOB4.EFFSEQ)
        FROM SYSADM.ODS_HR_JOB_VW JOB4
        WHERE JOB4.EMPLID = JOBC.EMPLID
          AND JOB4.EMPL_RCD = JOBC.EMPL_RCD
          AND JOB4.EFFDT = JOBC.EFFDT
        )
      AND JOBC.EMPL_RCD = '0'
    ) ZHIWU
  ,
  --职务
  A.HX_MAN_LVL_DESCR ZHIJI --现职级
FROM SYSADM.ODM_HR_PS_OCT_EXWK_OTH A
  ,SYSADM.PS_ACTION_TBL B
WHERE A.EMPLID = '${id}'
  AND A.ACTION = B.ACTION
  AND B.EFF_STATUS = 'A'
ORDER BY A.EFFDT DESC
),

AA AS
(
SELECT YGID,
       MIN(EFFDT) EFFDT,    
       BUMEN,
       YGFENLEI,
CASE WHEN TT.ZHIWEI = '' or TT.ZHIWEI IS NULL
     THEN TT.ZHIWU
     ELSE TT.ZHIWEI
   END AS ZHIWU,
       ZHIJI
  FROM TT
 GROUP BY YGID,   
          BUMEN,
          YGFENLEI,
CASE WHEN TT.ZHIWEI = '' or TT.ZHIWEI IS NULL
     THEN TT.ZHIWU
     ELSE TT.ZHIWEI
      END ,
       ZHIJI
 
 UNION 

 SELECT YGID,
        EFFDT,
       BUMEN,
       YGFENLEI,
CASE WHEN TT.ZHIWEI = '' or TT.ZHIWEI IS NULL
     THEN TT.ZHIWU
     ELSE TT.ZHIWEI
   END ZHIWU,
       ZHIJI
  FROM TT
WHERE ACTION_DESCR IN ('雇用','重新雇用','辞职','辞退','实习期结束')

)

SELECT AA.YGID,
       AA.EFFDT,
       TT.ACTION_DESCR,
       AA.BUMEN,
       AA.YGFENLEI,
       AA.ZHIWU,
       AA.ZHIJI
  FROM AA
  LEFT JOIN TT
    ON AA.YGID = TT.YGID
   AND AA.EFFDT = TT.EFFDT
    ORDER BY EFFDT DESC]]></Query>
</TableData>
<TableData name="内部工作履历_bak2" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="id"/>
<O>
<![CDATA[]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[华夏幸福]]></DatabaseName>
</Connection>
<Query>
<![CDATA[WITH
TT AS
(

SELECT A.EMPLID YGID
  ,
  --员工ID                   
  A.EFFDT EFFDT
  ,
  --操作时间
  B.ACTION_DESCR
  ,
  --操作
  (
    SELECT DESCR254
    FROM SYSADM.PS_DEPT_TBL X
      ,SYSADM.ODS_HR_JOB_VW JOBA
    WHERE X.SETID = JOBA.SETID_DEPT
      AND X.DEPTID = JOBA.DEPTID
      AND X.EFFDT = --A.EFFDT
      (
        SELECT MAX(M.EFFDT)
        FROM SYSADM.PS_DEPT_TBL M
        WHERE M.SETID = X.SETID
          AND M.DEPTID = X.DEPTID
          AND M.EFFDT <= A.EFFDT
        )
      AND JOBA.EMPLID = A.EMPLID
      AND JOBA.EFFDT = A.EFFDT
      AND JOBA.EFFSEQ = (
        SELECT MAX(JOB2.EFFSEQ)
        FROM  SYSADM.ODS_HR_JOB_VW JOB2
        WHERE JOB2.EMPLID = JOBA.EMPLID
          AND JOB2.EMPL_RCD = JOBA.EMPL_RCD
          AND JOB2.EFFDT = JOBA.EFFDT
        )
      AND JOBA.EMPL_RCD = '0'
    ) BUMEN
  ,
  --所属部门
  (
    SELECT DESCR
    FROM SYSADM.PS_HX_EMPL_CLASS A
      ,SYSADM.ODS_HR_JOB_VW JOBD
    WHERE A.EFF_STATUS = 'A'
      AND A.SETID = (
        SELECT SETID
        FROM SYSADM.PS_SET_CNTRL_REC SC
        WHERE SC.SETCNTRLVALUE = JOBD.BUSINESS_UNIT
          AND SC.RECNAME = 'HX_EMPL_CLASS'
        )
      AND A.HX_EMPL_CLASS = JOBD.HX_EMPL_CLASS
      AND A.EFFDT = (
        SELECT MAX(B.EFFDT)
        FROM SYSADM.PS_HX_EMPL_CLASS B
        WHERE B.EFF_STATUS = 'A'
          AND B.SETID = A.SETID
          AND B.HX_EMPL_CLASS = A.HX_EMPL_CLASS
          AND B.EFFDT <= TO_DATE(TO_CHAR(SYSDATE, 'YYYY-MM-DD'), 'YYYY-MM-DD')
        )
      AND JOBD.EMPLID = A.EMPLID
      AND JOBD.EFFDT = A.EFFDT
      AND JOBD.EFFSEQ = (
        SELECT MAX(JOB5.EFFSEQ)
        FROM SYSADM.ODS_HR_JOB_VW JOB5
        WHERE JOB5.EMPLID = JOBD.EMPLID
          AND JOB5.EMPL_RCD = JOBD.EMPL_RCD
          AND JOB5.EFFDT = JOBD.EFFDT
        )
      AND JOBD.EMPL_RCD = '0'
    ) YGFENLEI
  ,
  --员工分类
  (
    SELECT DESCR
    FROM SYSADM.PS_POSITION_DATA Y
      ,SYSADM.ODS_HR_JOB_VW JOBB
    WHERE Y.EFF_STATUS = 'A'
      AND Y.POSITION_NBR = JOBB.POSITION_NBR
      AND Y.EFFDT = --A.EFFDT
      (
        SELECT MAX(N.EFFDT)
        FROM SYSADM.PS_POSITION_DATA N
        WHERE N.POSITION_NBR = Y.POSITION_NBR
          AND N.EFFDT <= A.EFFDT
        )
      AND JOBB.EMPLID = A.EMPLID
      AND JOBB.EFFDT = A.EFFDT
      AND JOBB.EFFSEQ = (
        SELECT MAX(JOB3.EFFSEQ)
        FROM SYSADM.ODS_HR_JOB_VW JOB3
        WHERE JOB3.EMPLID = JOBB.EMPLID
          AND JOB3.EMPL_RCD = JOBB.EMPL_RCD
          AND JOB3.EFFDT = JOBB.EFFDT
        )
      AND JOBB.EMPL_RCD = '0'
    ) ZHIWEI
  ,
  --职位干部
  (
    SELECT DESCR
    FROM SYSADM.PS_JOBCODE_TBL Z
      ,SYSADM.ODS_HR_JOB_VW JOBC
    WHERE Z.EFF_STATUS = 'A'
      AND Z.SETID = (
        SELECT PS_SET_CNTRL_GROUP.SETID
        FROM SYSADM.PS_REC_GROUP_REC
          ,SYSADM.PS_SET_CNTRL_GROUP
        WHERE PS_REC_GROUP_REC.RECNAME = 'JOBCODE_TBL'
          AND PS_REC_GROUP_REC.REC_GROUP_ID = PS_SET_CNTRL_GROUP.REC_GROUP_ID
          AND PS_SET_CNTRL_GROUP.SETCNTRLVALUE = JOBC.BUSINESS_UNIT
        )
      AND Z.JOBCODE = JOBC.JOBCODE
      AND Z.EFFDT = --A.EFFDT
      (
        SELECT MAX(P.EFFDT)
        FROM SYSADM.PS_JOBCODE_TBL P
        WHERE P.SETID = Z.SETID
          AND P.JOBCODE = Z.JOBCODE
          AND P.EFFDT <= A.EFFDT
        )
      AND JOBC.EMPLID = A.EMPLID
      AND JOBC.EFFDT = A.EFFDT
      AND JOBC.EFFSEQ = (
        SELECT MAX(JOB4.EFFSEQ)
        FROM SYSADM.ODS_HR_JOB_VW JOB4
        WHERE JOB4.EMPLID = JOBC.EMPLID
          AND JOB4.EMPL_RCD = JOBC.EMPL_RCD
          AND JOB4.EFFDT = JOBC.EFFDT
        )
      AND JOBC.EMPL_RCD = '0'
    ) ZHIWU
  ,
  --职务
  A.HX_MAN_LVL_DESCR ZHIJI --现职级
FROM SYSADM.ODM_HR_PS_OCT_EXWK_OTH A
  ,SYSADM.PS_ACTION_TBL B
WHERE A.EMPLID = '${id}'
  AND A.ACTION = B.ACTION
  AND B.EFF_STATUS = 'A'
--ORDER BY A.EFFDT DESC

UNION

SELECT A.EMPLID YGID
  ,
  --员工ID 
  (SELECT X.EFFDT
    FROM SYSADM.PS_DEPT_TBL X
      ,SYSADM.ODS_HR_JOB_VW JOBA
    WHERE X.SETID = JOBA.SETID_DEPT
      AND X.DEPTID = JOBA.DEPTID
      AND X.EFFDT = --A.EFFDT
      (
        SELECT MAX(M.EFFDT)
        FROM SYSADM.PS_DEPT_TBL M
        WHERE M.SETID = X.SETID
          AND M.DEPTID = X.DEPTID
          AND M.EFFDT <= SYSDATE
        )
      AND JOBA.EMPLID = A.EMPLID
      AND JOBA.EFFDT = A.EFFDT
      AND JOBA.EFFSEQ = (
        SELECT MAX(JOB2.EFFSEQ)
        FROM  SYSADM.ODS_HR_JOB_VW JOB2
        WHERE JOB2.EMPLID = JOBA.EMPLID
          AND JOB2.EMPL_RCD = JOBA.EMPL_RCD
          AND JOB2.EFFDT = JOBA.EFFDT
        )
      AND JOBA.EMPL_RCD = '0')                  
 EFFDT
  ,
  --操作时间
  B.ACTION_DESCR
  ,
  --操作
  (
    SELECT DESCR254
    FROM SYSADM.PS_DEPT_TBL X
      ,SYSADM.ODS_HR_JOB_VW JOBA
    WHERE X.SETID = JOBA.SETID_DEPT
      AND X.DEPTID = JOBA.DEPTID
      AND X.EFFDT = --A.EFFDT
      (
        SELECT MAX(M.EFFDT)
        FROM SYSADM.PS_DEPT_TBL M
        WHERE M.SETID = X.SETID
          AND M.DEPTID = X.DEPTID
          AND M.EFFDT <= SYSDATE
        )
      AND JOBA.EMPLID = A.EMPLID
      AND JOBA.EFFDT = A.EFFDT
      AND JOBA.EFFSEQ = (
        SELECT MAX(JOB2.EFFSEQ)
        FROM  SYSADM.ODS_HR_JOB_VW JOB2
        WHERE JOB2.EMPLID = JOBA.EMPLID
          AND JOB2.EMPL_RCD = JOBA.EMPL_RCD
          AND JOB2.EFFDT = JOBA.EFFDT
        )
      AND JOBA.EMPL_RCD = '0'
    ) BUMEN
  ,
  --所属部门
  (
    SELECT DESCR
    FROM SYSADM.PS_HX_EMPL_CLASS A
      ,SYSADM.ODS_HR_JOB_VW JOBD
    WHERE A.EFF_STATUS = 'A'
      AND A.SETID = (
        SELECT SETID
        FROM SYSADM.PS_SET_CNTRL_REC SC
        WHERE SC.SETCNTRLVALUE = JOBD.BUSINESS_UNIT
          AND SC.RECNAME = 'HX_EMPL_CLASS'
        )
      AND A.HX_EMPL_CLASS = JOBD.HX_EMPL_CLASS
      AND A.EFFDT = (
        SELECT MAX(B.EFFDT)
        FROM SYSADM.PS_HX_EMPL_CLASS B
        WHERE B.EFF_STATUS = 'A'
          AND B.SETID = A.SETID
          AND B.HX_EMPL_CLASS = A.HX_EMPL_CLASS
          AND B.EFFDT <= TO_DATE(TO_CHAR(SYSDATE, 'YYYY-MM-DD'), 'YYYY-MM-DD')
        )
      AND JOBD.EMPLID = A.EMPLID
      AND JOBD.EFFDT = A.EFFDT
      AND JOBD.EFFSEQ = (
        SELECT MAX(JOB5.EFFSEQ)
        FROM SYSADM.ODS_HR_JOB_VW JOB5
        WHERE JOB5.EMPLID = JOBD.EMPLID
          AND JOB5.EMPL_RCD = JOBD.EMPL_RCD
          AND JOB5.EFFDT = JOBD.EFFDT
        )
      AND JOBD.EMPL_RCD = '0'
    ) YGFENLEI
  ,
  --员工分类
  (
    SELECT DESCR
    FROM SYSADM.PS_POSITION_DATA Y
      ,SYSADM.ODS_HR_JOB_VW JOBB
    WHERE Y.EFF_STATUS = 'A'
      AND Y.POSITION_NBR = JOBB.POSITION_NBR
      AND Y.EFFDT = --A.EFFDT
      (
        SELECT MAX(N.EFFDT)
        FROM SYSADM.PS_POSITION_DATA N
        WHERE N.POSITION_NBR = Y.POSITION_NBR
          AND N.EFFDT <= A.EFFDT
        )
      AND JOBB.EMPLID = A.EMPLID
      AND JOBB.EFFDT = A.EFFDT
      AND JOBB.EFFSEQ = (
        SELECT MAX(JOB3.EFFSEQ)
        FROM SYSADM.ODS_HR_JOB_VW JOB3
        WHERE JOB3.EMPLID = JOBB.EMPLID
          AND JOB3.EMPL_RCD = JOBB.EMPL_RCD
          AND JOB3.EFFDT = JOBB.EFFDT
        )
      AND JOBB.EMPL_RCD = '0'
    ) ZHIWEI
  ,
  --职位干部
  (
    SELECT DESCR
    FROM SYSADM.PS_JOBCODE_TBL Z
      ,SYSADM.ODS_HR_JOB_VW JOBC
    WHERE Z.EFF_STATUS = 'A'
      AND Z.SETID = (
        SELECT PS_SET_CNTRL_GROUP.SETID
        FROM SYSADM.PS_REC_GROUP_REC
          ,SYSADM.PS_SET_CNTRL_GROUP
        WHERE PS_REC_GROUP_REC.RECNAME = 'JOBCODE_TBL'
          AND PS_REC_GROUP_REC.REC_GROUP_ID = PS_SET_CNTRL_GROUP.REC_GROUP_ID
          AND PS_SET_CNTRL_GROUP.SETCNTRLVALUE = JOBC.BUSINESS_UNIT
        )
      AND Z.JOBCODE = JOBC.JOBCODE
      AND Z.EFFDT = --A.EFFDT
      (
        SELECT MAX(P.EFFDT)
        FROM SYSADM.PS_JOBCODE_TBL P
        WHERE P.SETID = Z.SETID
          AND P.JOBCODE = Z.JOBCODE
          AND P.EFFDT <= A.EFFDT
        )
      AND JOBC.EMPLID = A.EMPLID
      AND JOBC.EFFDT = A.EFFDT
      AND JOBC.EFFSEQ = (
        SELECT MAX(JOB4.EFFSEQ)
        FROM SYSADM.ODS_HR_JOB_VW JOB4
        WHERE JOB4.EMPLID = JOBC.EMPLID
          AND JOB4.EMPL_RCD = JOBC.EMPL_RCD
          AND JOB4.EFFDT = JOBC.EFFDT
        )
      AND JOBC.EMPL_RCD = '0'
    ) ZHIWU
  ,
  --职务
  A.HX_MAN_LVL_DESCR ZHIJI --现职级
FROM SYSADM.ODM_HR_PS_OCT_EXWK_OTH A
  ,SYSADM.PS_ACTION_TBL B
WHERE A.EMPLID = '${id}'
  AND A.ACTION = B.ACTION
  AND B.EFF_STATUS = 'A'
  AND A.EFFDT = (
   SELECT MAX(JOB2.EFFDT)
        FROM  SYSADM.ODS_HR_JOB_VW JOB2
        WHERE JOB2.EMPLID = A.EMPLID
          --AND JOB2.EMPL_RCD = A.EMPL_RCD
         -- AND JOB2.EFFSEQ = A.EFFSEQ
  )
  AND EXISTS (SELECT 1
                FROM SYSADM.PS_DEPT_TBL X
                     ,SYSADM.ODS_HR_JOB_VW JOBA
        WHERE X.SETID = JOBA.SETID_DEPT
      AND X.DEPTID = JOBA.DEPTID
      AND X.EFFDT = --A.EFFDT
      (
        SELECT MAX(M.EFFDT)
        FROM SYSADM.PS_DEPT_TBL M
        WHERE M.SETID = X.SETID
          AND M.DEPTID = X.DEPTID
          AND M.EFFDT <= SYSDATE
        )
      AND JOBA.EMPLID = A.EMPLID
      AND JOBA.EFFDT = (
     SELECT MAX(JOB2.EFFDT)
        FROM  SYSADM.ODS_HR_JOB_VW JOB2
        WHERE JOB2.EMPLID = JOBA.EMPLID
          AND JOB2.EMPL_RCD = JOBA.EMPL_RCD
          AND JOB2.EFFDT <= TO_DATE(TO_CHAR(SYSDATE, 'YYYY-MM-DD'),'YYYY-MM-DD')
    )
      AND JOBA.EFFSEQ = (
        SELECT MAX(JOB2.EFFSEQ)
        FROM  SYSADM.ODS_HR_JOB_VW JOB2
        WHERE JOB2.EMPLID = JOBA.EMPLID
          AND JOB2.EMPL_RCD = JOBA.EMPL_RCD
          AND JOB2.EFFDT = JOBA.EFFDT
        )
      AND JOBA.EMPL_RCD = '0'
      AND JOBA.EFFDT < X.EFFDT    
        )


),

AA AS
(
SELECT YGID,
       MIN(EFFDT) EFFDT,    
       BUMEN,
       YGFENLEI,
CASE WHEN TT.ZHIWEI = '' or TT.ZHIWEI IS NULL
     THEN TT.ZHIWU
     ELSE TT.ZHIWEI
   END AS ZHIWU,
       ZHIJI
  FROM TT
 GROUP BY YGID,   
          BUMEN,
          YGFENLEI,
CASE WHEN TT.ZHIWEI = '' or TT.ZHIWEI IS NULL
     THEN TT.ZHIWU
     ELSE TT.ZHIWEI
      END ,
       ZHIJI
 
 UNION 

 SELECT YGID,
        EFFDT,
       BUMEN,
       YGFENLEI,
CASE WHEN TT.ZHIWEI = '' or TT.ZHIWEI IS NULL
     THEN TT.ZHIWU
     ELSE TT.ZHIWEI
   END ZHIWU,
       ZHIJI
  FROM TT
WHERE ACTION_DESCR IN ('雇用','重新雇用','辞职','辞退','实习期结束')

)

SELECT AA.YGID,
       AA.EFFDT,
       TT.ACTION_DESCR,
       AA.BUMEN,
       AA.YGFENLEI,
       AA.ZHIWU,
       AA.ZHIJI
  FROM AA
  LEFT JOIN TT
    ON AA.YGID = TT.YGID
   AND AA.EFFDT = TT.EFFDT
    ORDER BY EFFDT DESC]]></Query>
</TableData>
<TableData name="内部工作履历备份20180313" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="id"/>
<O>
<![CDATA[]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[华夏幸福]]></DatabaseName>
</Connection>
<Query>
<![CDATA[WITH
TT AS
(

SELECT A.EMPLID YGID
  ,
  --员工ID                   
  A.EFFDT EFFDT
  ,
  --操作时间
  B.ACTION_DESCR
  ,
  --操作
  (
    SELECT DESCR254
    FROM SYSADM.HR_VW_DEPT_TBL X
      ,SYSADM.ODS_HR_JOB_VW JOBA
    WHERE X.SETID = JOBA.SETID_DEPT
      AND X.DEPTID = JOBA.DEPTID
      AND X.EFFDT = --A.EFFDT
      (
        SELECT MAX(M.EFFDT)
        FROM SYSADM.HR_VW_DEPT_TBL M
        WHERE M.SETID = X.SETID
          AND M.DEPTID = X.DEPTID
          AND M.EFFDT <= A.EFFDT
        )
      AND JOBA.EMPLID = A.EMPLID
      AND JOBA.EFFDT = A.EFFDT
      AND JOBA.EFFSEQ = (
        SELECT MAX(JOB2.EFFSEQ)
        FROM  SYSADM.ODS_HR_JOB_VW JOB2
        WHERE JOB2.EMPLID = JOBA.EMPLID
          AND JOB2.EMPL_RCD = JOBA.EMPL_RCD
          AND JOB2.EFFDT = JOBA.EFFDT
        )
      AND JOBA.EMPL_RCD = '0'
    ) BUMEN
  ,
  --所属部门
  (
    SELECT DESCR
    FROM SYSADM.HR_VW_HX_EMPL_CLASS A
      ,SYSADM.ODS_HR_JOB_VW JOBD
    WHERE A.EFF_STATUS = 'A'
      AND A.SETID = (
        SELECT SETID
        FROM SYSADM.HR_VW_SET_CNTRL_REC SC
        WHERE SC.SETCNTRLVALUE = JOBD.BUSINESS_UNIT
          AND SC.RECNAME = 'HX_EMPL_CLASS'
        )
      AND A.HX_EMPL_CLASS = JOBD.HX_EMPL_CLASS
      AND A.EFFDT = (
        SELECT MAX(B.EFFDT)
        FROM SYSADM.HR_VW_HX_EMPL_CLASS B
        WHERE B.EFF_STATUS = 'A'
          AND B.SETID = A.SETID
          AND B.HX_EMPL_CLASS = A.HX_EMPL_CLASS
          AND B.EFFDT <= TO_DATE(TO_CHAR(SYSDATE, 'YYYY-MM-DD'), 'YYYY-MM-DD')
        )
      AND JOBD.EMPLID = A.EMPLID
      AND JOBD.EFFDT = A.EFFDT
      AND JOBD.EFFSEQ = (
        SELECT MAX(JOB5.EFFSEQ)
        FROM SYSADM.ODS_HR_JOB_VW JOB5
        WHERE JOB5.EMPLID = JOBD.EMPLID
          AND JOB5.EMPL_RCD = JOBD.EMPL_RCD
          AND JOB5.EFFDT = JOBD.EFFDT
        )
      AND JOBD.EMPL_RCD = '0'
    ) YGFENLEI
  ,
  --员工分类
  (
    SELECT DESCR
    FROM SYSADM.HR_VW_POSITION_DATA Y
      ,SYSADM.ODS_HR_JOB_VW JOBB
    WHERE Y.EFF_STATUS = 'A'
      AND Y.POSITION_NBR = JOBB.POSITION_NBR
      AND Y.EFFDT = --A.EFFDT
      (
        SELECT MAX(N.EFFDT)
        FROM SYSADM.HR_VW_POSITION_DATA N
        WHERE N.POSITION_NBR = Y.POSITION_NBR
          AND N.EFFDT <= A.EFFDT
        )
      AND JOBB.EMPLID = A.EMPLID
      AND JOBB.EFFDT = A.EFFDT
      AND JOBB.EFFSEQ = (
        SELECT MAX(JOB3.EFFSEQ)
        FROM SYSADM.ODS_HR_JOB_VW JOB3
        WHERE JOB3.EMPLID = JOBB.EMPLID
          AND JOB3.EMPL_RCD = JOBB.EMPL_RCD
          AND JOB3.EFFDT = JOBB.EFFDT
        )
      AND JOBB.EMPL_RCD = '0'
    ) ZHIWEI
  ,
  --职位干部
  (
    SELECT DESCR
    FROM SYSADM.HR_VW_JOBCODE_TBL Z
      ,SYSADM.ODS_HR_JOB_VW JOBC
    WHERE Z.EFF_STATUS = 'A'
      AND Z.SETID = (
        SELECT HR_VW_SET_CNTRL_GROUP.SETID
        FROM SYSADM.HR_VW_REC_GROUP_REC
          ,SYSADM.HR_VW_SET_CNTRL_GROUP
        WHERE HR_VW_REC_GROUP_REC.RECNAME = 'JOBCODE_TBL'
          AND HR_VW_REC_GROUP_REC.REC_GROUP_ID = HR_VW_SET_CNTRL_GROUP.REC_GROUP_ID
          AND HR_VW_SET_CNTRL_GROUP.SETCNTRLVALUE = JOBC.BUSINESS_UNIT
        )
      AND Z.JOBCODE = JOBC.JOBCODE
      AND Z.EFFDT = --A.EFFDT
      (
        SELECT MAX(P.EFFDT)
        FROM SYSADM.HR_VW_JOBCODE_TBL P
        WHERE P.SETID = Z.SETID
          AND P.JOBCODE = Z.JOBCODE
          AND P.EFFDT <= A.EFFDT
        )
      AND JOBC.EMPLID = A.EMPLID
      AND JOBC.EFFDT = A.EFFDT
      AND JOBC.EFFSEQ = (
        SELECT MAX(JOB4.EFFSEQ)
        FROM SYSADM.ODS_HR_JOB_VW JOB4
        WHERE JOB4.EMPLID = JOBC.EMPLID
          AND JOB4.EMPL_RCD = JOBC.EMPL_RCD
          AND JOB4.EFFDT = JOBC.EFFDT
        )
      AND JOBC.EMPL_RCD = '0'
    ) ZHIWU
  ,
  --职务
  A.HX_MAN_LVL_DESCR ZHIJI --现职级
FROM SYSADM.ODM_HR_PS_OCT_EXWK_OTH A
  ,SYSADM.HR_VW_ACTION_TBL B
WHERE A.EMPLID = '${id}'
  AND A.ACTION = B.ACTION
  AND B.EFF_STATUS = 'A'
--ORDER BY A.EFFDT DESC

UNION

SELECT A.EMPLID YGID
  ,
  --员工ID 
  (SELECT X.EFFDT
    FROM SYSADM.HR_VW_DEPT_TBL X
      ,SYSADM.ODS_HR_JOB_VW JOBA
    WHERE X.SETID = JOBA.SETID_DEPT
      AND X.DEPTID = JOBA.DEPTID
      AND X.EFFDT = --A.EFFDT
      (
        SELECT MAX(M.EFFDT)
        FROM SYSADM.HR_VW_DEPT_TBL M
        WHERE M.SETID = X.SETID
          AND M.DEPTID = X.DEPTID
          AND M.EFFDT <= SYSDATE
        )
      AND JOBA.EMPLID = A.EMPLID
      AND JOBA.EFFDT = A.EFFDT
      AND JOBA.EFFSEQ = (
        SELECT MAX(JOB2.EFFSEQ)
        FROM  SYSADM.ODS_HR_JOB_VW JOB2
        WHERE JOB2.EMPLID = JOBA.EMPLID
          AND JOB2.EMPL_RCD = JOBA.EMPL_RCD
          AND JOB2.EFFDT = JOBA.EFFDT
        )
      AND JOBA.EMPL_RCD = '0')                  
 EFFDT
  ,
  --操作时间
  B.ACTION_DESCR
  ,
  --操作
  (
    SELECT DESCR254
    FROM SYSADM.HR_VW_DEPT_TBL X
      ,SYSADM.ODS_HR_JOB_VW JOBA
    WHERE X.SETID = JOBA.SETID_DEPT
      AND X.DEPTID = JOBA.DEPTID
      AND X.EFFDT = --A.EFFDT
      (
        SELECT MAX(M.EFFDT)
        FROM SYSADM.HR_VW_DEPT_TBL M
        WHERE M.SETID = X.SETID
          AND M.DEPTID = X.DEPTID
          AND M.EFFDT <= SYSDATE
        )
      AND JOBA.EMPLID = A.EMPLID
      AND JOBA.EFFDT = A.EFFDT
      AND JOBA.EFFSEQ = (
        SELECT MAX(JOB2.EFFSEQ)
        FROM  SYSADM.ODS_HR_JOB_VW JOB2
        WHERE JOB2.EMPLID = JOBA.EMPLID
          AND JOB2.EMPL_RCD = JOBA.EMPL_RCD
          AND JOB2.EFFDT = JOBA.EFFDT
        )
      AND JOBA.EMPL_RCD = '0'
    ) BUMEN
  ,
  --所属部门
  (
    SELECT DESCR
    FROM SYSADM.HR_VW_HX_EMPL_CLASS A
      ,SYSADM.ODS_HR_JOB_VW JOBD
    WHERE A.EFF_STATUS = 'A'
      AND A.SETID = (
        SELECT SETID
        FROM SYSADM.HR_VW_SET_CNTRL_REC SC
        WHERE SC.SETCNTRLVALUE = JOBD.BUSINESS_UNIT
          AND SC.RECNAME = 'HX_EMPL_CLASS'
        )
      AND A.HX_EMPL_CLASS = JOBD.HX_EMPL_CLASS
      AND A.EFFDT = (
        SELECT MAX(B.EFFDT)
        FROM SYSADM.HR_VW_HX_EMPL_CLASS B
        WHERE B.EFF_STATUS = 'A'
          AND B.SETID = A.SETID
          AND B.HX_EMPL_CLASS = A.HX_EMPL_CLASS
          AND B.EFFDT <= TO_DATE(TO_CHAR(SYSDATE, 'YYYY-MM-DD'), 'YYYY-MM-DD')
        )
      AND JOBD.EMPLID = A.EMPLID
      AND JOBD.EFFDT = A.EFFDT
      AND JOBD.EFFSEQ = (
        SELECT MAX(JOB5.EFFSEQ)
        FROM SYSADM.ODS_HR_JOB_VW JOB5
        WHERE JOB5.EMPLID = JOBD.EMPLID
          AND JOB5.EMPL_RCD = JOBD.EMPL_RCD
          AND JOB5.EFFDT = JOBD.EFFDT
        )
      AND JOBD.EMPL_RCD = '0'
    ) YGFENLEI
  ,
  --员工分类
  (
    SELECT DESCR
    FROM SYSADM.HR_VW_POSITION_DATA Y
      ,SYSADM.ODS_HR_JOB_VW JOBB
    WHERE Y.EFF_STATUS = 'A'
      AND Y.POSITION_NBR = JOBB.POSITION_NBR
      AND Y.EFFDT = --A.EFFDT
      (
        SELECT MAX(N.EFFDT)
        FROM SYSADM.HR_VW_POSITION_DATA N
        WHERE N.POSITION_NBR = Y.POSITION_NBR
          AND N.EFFDT <= A.EFFDT
        )
      AND JOBB.EMPLID = A.EMPLID
      AND JOBB.EFFDT = A.EFFDT
      AND JOBB.EFFSEQ = (
        SELECT MAX(JOB3.EFFSEQ)
        FROM SYSADM.ODS_HR_JOB_VW JOB3
        WHERE JOB3.EMPLID = JOBB.EMPLID
          AND JOB3.EMPL_RCD = JOBB.EMPL_RCD
          AND JOB3.EFFDT = JOBB.EFFDT
        )
      AND JOBB.EMPL_RCD = '0'
    ) ZHIWEI
  ,
  --职位干部
  (
    SELECT DESCR
    FROM SYSADM.HR_VW_JOBCODE_TBL Z
      ,SYSADM.ODS_HR_JOB_VW JOBC
    WHERE Z.EFF_STATUS = 'A'
      AND Z.SETID = (
        SELECT HR_VW_SET_CNTRL_GROUP.SETID
        FROM SYSADM.HR_VW_REC_GROUP_REC
          ,SYSADM.HR_VW_SET_CNTRL_GROUP
        WHERE HR_VW_REC_GROUP_REC.RECNAME = 'JOBCODE_TBL'
          AND HR_VW_REC_GROUP_REC.REC_GROUP_ID = HR_VW_SET_CNTRL_GROUP.REC_GROUP_ID
          AND HR_VW_SET_CNTRL_GROUP.SETCNTRLVALUE = JOBC.BUSINESS_UNIT
        )
      AND Z.JOBCODE = JOBC.JOBCODE
      AND Z.EFFDT = --A.EFFDT
      (
        SELECT MAX(P.EFFDT)
        FROM SYSADM.HR_VW_JOBCODE_TBL P
        WHERE P.SETID = Z.SETID
          AND P.JOBCODE = Z.JOBCODE
          AND P.EFFDT <= A.EFFDT
        )
      AND JOBC.EMPLID = A.EMPLID
      AND JOBC.EFFDT = A.EFFDT
      AND JOBC.EFFSEQ = (
        SELECT MAX(JOB4.EFFSEQ)
        FROM SYSADM.ODS_HR_JOB_VW JOB4
        WHERE JOB4.EMPLID = JOBC.EMPLID
          AND JOB4.EMPL_RCD = JOBC.EMPL_RCD
          AND JOB4.EFFDT = JOBC.EFFDT
        )
      AND JOBC.EMPL_RCD = '0'
    ) ZHIWU
  ,
  --职务
  A.HX_MAN_LVL_DESCR ZHIJI --现职级
FROM SYSADM.ODM_HR_PS_OCT_EXWK_OTH A
  ,SYSADM.HR_VW_ACTION_TBL B
WHERE A.EMPLID = '${id}'
  AND A.ACTION = B.ACTION
  AND B.EFF_STATUS = 'A'
  AND A.EFFDT = (
   SELECT MAX(JOB2.EFFDT)
        FROM  SYSADM.ODS_HR_JOB_VW JOB2
        WHERE JOB2.EMPLID = A.EMPLID
          --AND JOB2.EMPL_RCD = A.EMPL_RCD
         -- AND JOB2.EFFSEQ = A.EFFSEQ
  )
  AND EXISTS (SELECT 1
                FROM SYSADM.HR_VW_DEPT_TBL X
                     ,SYSADM.ODS_HR_JOB_VW JOBA
        WHERE X.SETID = JOBA.SETID_DEPT
      AND X.DEPTID = JOBA.DEPTID
      AND X.EFFDT = --A.EFFDT
      (
        SELECT MAX(M.EFFDT)
        FROM SYSADM.HR_VW_DEPT_TBL M
        WHERE M.SETID = X.SETID
          AND M.DEPTID = X.DEPTID
          AND M.EFFDT <= SYSDATE
        )
      AND JOBA.EMPLID = A.EMPLID
      AND JOBA.EFFDT = (
     SELECT MAX(JOB2.EFFDT)
        FROM  SYSADM.ODS_HR_JOB_VW JOB2
        WHERE JOB2.EMPLID = JOBA.EMPLID
          AND JOB2.EMPL_RCD = JOBA.EMPL_RCD
          AND JOB2.EFFDT <= TO_DATE(TO_CHAR(SYSDATE, 'YYYY-MM-DD'),'YYYY-MM-DD')
    )
      AND JOBA.EFFSEQ = (
        SELECT MAX(JOB2.EFFSEQ)
        FROM  SYSADM.ODS_HR_JOB_VW JOB2
        WHERE JOB2.EMPLID = JOBA.EMPLID
          AND JOB2.EMPL_RCD = JOBA.EMPL_RCD
          AND JOB2.EFFDT = JOBA.EFFDT
        )
      AND JOBA.EMPL_RCD = '0'
      AND JOBA.EFFDT < X.EFFDT    
        )


),

AA AS
(
SELECT * FROM 
(
SELECT YGID,
       MIN(EFFDT) EFFDT,    
       BUMEN,
       YGFENLEI,
CASE WHEN TT.ZHIWEI = '' or TT.ZHIWEI IS NULL
     THEN TT.ZHIWU
     ELSE TT.ZHIWEI
   END AS ZHIWU,
       ZHIJI
  FROM TT
 GROUP BY YGID,   
          BUMEN,
          YGFENLEI,
CASE WHEN TT.ZHIWEI = '' or TT.ZHIWEI IS NULL
     THEN TT.ZHIWU
     ELSE TT.ZHIWEI
      END ,
       ZHIJI
       UNION 
       SELECT YGID,
       MAX(EFFDT) EFFDT,    
       BUMEN,
       YGFENLEI,
CASE WHEN TT.ZHIWEI = '' or TT.ZHIWEI IS NULL
     THEN TT.ZHIWU
     ELSE TT.ZHIWEI
   END AS ZHIWU,
       ZHIJI
  FROM TT
 GROUP BY YGID,   
          BUMEN,
          YGFENLEI,
CASE WHEN TT.ZHIWEI = '' or TT.ZHIWEI IS NULL
     THEN TT.ZHIWU
     ELSE TT.ZHIWEI
      END ,
       ZHIJI)
 
 UNION 

 SELECT YGID,
        EFFDT,
       BUMEN,
       YGFENLEI,
CASE WHEN TT.ZHIWEI = '' or TT.ZHIWEI IS NULL
     THEN TT.ZHIWU
     ELSE TT.ZHIWEI
   END ZHIWU,
       ZHIJI
  FROM TT
WHERE ACTION_DESCR IN ('雇用','重新雇用','辞职','辞退','实习期结束')

)

SELECT AA.YGID,
       AA.EFFDT,
       TT.ACTION_DESCR,
       AA.BUMEN,
       AA.YGFENLEI,
       AA.ZHIWU,
       AA.ZHIJI
  FROM AA
  LEFT JOIN TT
    ON AA.YGID = TT.YGID
   AND AA.EFFDT = TT.EFFDT
    ORDER BY EFFDT DESC]]></Query>
</TableData>
<TableData name="ds2" class="com.fr.data.impl.DBTableData">
<Parameters/>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[华夏幸福]]></DatabaseName>
</Connection>
<Query>
<![CDATA[WITH
TT AS
(

SELECT A.EMPLID YGID
  ,
  --员工ID                   
  A.EFFDT EFFDT
  ,
  --操作时间
  B.ACTION_DESCR
  ,
  --操作
  (
    SELECT DESCR254
    FROM SYSADM.HR_VW_DEPT_TBL X
      ,SYSADM.ODS_HR_JOB_VW JOBA
    WHERE X.SETID = JOBA.SETID_DEPT
      AND X.DEPTID = JOBA.DEPTID
      AND X.EFFDT = --A.EFFDT
      (
        SELECT MAX(M.EFFDT)
        FROM SYSADM.HR_VW_DEPT_TBL M
        WHERE M.SETID = X.SETID
          AND M.DEPTID = X.DEPTID
          AND M.EFFDT <= A.EFFDT
        )
      AND JOBA.EMPLID = A.EMPLID
      AND JOBA.EFFDT = A.EFFDT
      AND JOBA.EFFSEQ = (
        SELECT MAX(JOB2.EFFSEQ)
        FROM  SYSADM.ODS_HR_JOB_VW JOB2
        WHERE JOB2.EMPLID = JOBA.EMPLID
          AND JOB2.EMPL_RCD = JOBA.EMPL_RCD
          AND JOB2.EFFDT = JOBA.EFFDT
        )
      AND JOBA.EMPL_RCD = '0'
    ) BUMEN
  ,
  --所属部门
  (
    SELECT DESCR
    FROM SYSADM.HR_VW_HX_EMPL_CLASS A
      ,SYSADM.ODS_HR_JOB_VW JOBD
    WHERE A.EFF_STATUS = 'A'
      AND A.SETID = (
        SELECT SETID
        FROM SYSADM.HR_VW_SET_CNTRL_REC SC
        WHERE SC.SETCNTRLVALUE = JOBD.BUSINESS_UNIT
          AND SC.RECNAME = 'HX_EMPL_CLASS'
        )
      AND A.HX_EMPL_CLASS = JOBD.HX_EMPL_CLASS
      AND A.EFFDT = (
        SELECT MAX(B.EFFDT)
        FROM SYSADM.HR_VW_HX_EMPL_CLASS B
        WHERE B.EFF_STATUS = 'A'
          AND B.SETID = A.SETID
          AND B.HX_EMPL_CLASS = A.HX_EMPL_CLASS
          AND B.EFFDT <= TO_DATE(TO_CHAR(SYSDATE, 'YYYY-MM-DD'), 'YYYY-MM-DD')
        )
      AND JOBD.EMPLID = A.EMPLID
      AND JOBD.EFFDT = A.EFFDT
      AND JOBD.EFFSEQ = (
        SELECT MAX(JOB5.EFFSEQ)
        FROM SYSADM.ODS_HR_JOB_VW JOB5
        WHERE JOB5.EMPLID = JOBD.EMPLID
          AND JOB5.EMPL_RCD = JOBD.EMPL_RCD
          AND JOB5.EFFDT = JOBD.EFFDT
        )
      AND JOBD.EMPL_RCD = '0'
    ) YGFENLEI
  ,
  --员工分类
  (
    SELECT DESCR
    FROM SYSADM.HR_VW_POSITION_DATA Y
      ,SYSADM.ODS_HR_JOB_VW JOBB
    WHERE Y.EFF_STATUS = 'A'
      AND Y.POSITION_NBR = JOBB.POSITION_NBR
      AND Y.EFFDT = --A.EFFDT
      (
        SELECT MAX(N.EFFDT)
        FROM SYSADM.HR_VW_POSITION_DATA N
        WHERE N.POSITION_NBR = Y.POSITION_NBR
          AND N.EFFDT <= A.EFFDT
        )
      AND JOBB.EMPLID = A.EMPLID
      AND JOBB.EFFDT = A.EFFDT
      AND JOBB.EFFSEQ = (
        SELECT MAX(JOB3.EFFSEQ)
        FROM SYSADM.ODS_HR_JOB_VW JOB3
        WHERE JOB3.EMPLID = JOBB.EMPLID
          AND JOB3.EMPL_RCD = JOBB.EMPL_RCD
          AND JOB3.EFFDT = JOBB.EFFDT
        )
      AND JOBB.EMPL_RCD = '0'
    ) ZHIWEI
  ,
  --职位干部
  (
    SELECT DESCR
    FROM SYSADM.HR_VW_JOBCODE_TBL Z
      ,SYSADM.ODS_HR_JOB_VW JOBC
    WHERE Z.EFF_STATUS = 'A'
      AND Z.SETID = (
        SELECT HR_VW_SET_CNTRL_GROUP.SETID
        FROM SYSADM.HR_VW_REC_GROUP_REC
          ,SYSADM.HR_VW_SET_CNTRL_GROUP
        WHERE HR_VW_REC_GROUP_REC.RECNAME = 'JOBCODE_TBL'
          AND HR_VW_REC_GROUP_REC.REC_GROUP_ID = HR_VW_SET_CNTRL_GROUP.REC_GROUP_ID
          AND HR_VW_SET_CNTRL_GROUP.SETCNTRLVALUE = JOBC.BUSINESS_UNIT
        )
      AND Z.JOBCODE = JOBC.JOBCODE
      AND Z.EFFDT = --A.EFFDT
      (
        SELECT MAX(P.EFFDT)
        FROM SYSADM.HR_VW_JOBCODE_TBL P
        WHERE P.SETID = Z.SETID
          AND P.JOBCODE = Z.JOBCODE
          AND P.EFFDT <= A.EFFDT
        )
      AND JOBC.EMPLID = A.EMPLID
      AND JOBC.EFFDT = A.EFFDT
      AND JOBC.EFFSEQ = (
        SELECT MAX(JOB4.EFFSEQ)
        FROM SYSADM.ODS_HR_JOB_VW JOB4
        WHERE JOB4.EMPLID = JOBC.EMPLID
          AND JOB4.EMPL_RCD = JOBC.EMPL_RCD
          AND JOB4.EFFDT = JOBC.EFFDT
        )
      AND JOBC.EMPL_RCD = '0'
    ) ZHIWU
  ,
  --职务
  A.HX_MAN_LVL_DESCR ZHIJI --现职级
FROM SYSADM.ODM_HR_PS_OCT_EXWK_OTH A
  ,SYSADM.HR_VW_ACTION_TBL B
WHERE A.EMPLID = '${id}'
  AND A.ACTION = B.ACTION
  AND B.EFF_STATUS = 'A'
--ORDER BY A.EFFDT DESC

UNION

SELECT A.EMPLID YGID
  ,
  --员工ID 
  (SELECT X.EFFDT
    FROM SYSADM.HR_VW_DEPT_TBL X
      ,SYSADM.ODS_HR_JOB_VW JOBA
    WHERE X.SETID = JOBA.SETID_DEPT
      AND X.DEPTID = JOBA.DEPTID
      AND X.EFFDT = --A.EFFDT
      (
        SELECT MAX(M.EFFDT)
        FROM SYSADM.HR_VW_DEPT_TBL M
        WHERE M.SETID = X.SETID
          AND M.DEPTID = X.DEPTID
          AND M.EFFDT <= SYSDATE
        )
      AND JOBA.EMPLID = A.EMPLID
      AND JOBA.EFFDT = A.EFFDT
      AND JOBA.EFFSEQ = (
        SELECT MAX(JOB2.EFFSEQ)
        FROM  SYSADM.ODS_HR_JOB_VW JOB2
        WHERE JOB2.EMPLID = JOBA.EMPLID
          AND JOB2.EMPL_RCD = JOBA.EMPL_RCD
          AND JOB2.EFFDT = JOBA.EFFDT
        )
      AND JOBA.EMPL_RCD = '0')                  
 EFFDT
  ,
  --操作时间
  B.ACTION_DESCR
  ,
  --操作
  (
    SELECT DESCR254
    FROM SYSADM.HR_VW_DEPT_TBL X
      ,SYSADM.ODS_HR_JOB_VW JOBA
    WHERE X.SETID = JOBA.SETID_DEPT
      AND X.DEPTID = JOBA.DEPTID
      AND X.EFFDT = --A.EFFDT
      (
        SELECT MAX(M.EFFDT)
        FROM SYSADM.HR_VW_DEPT_TBL M
        WHERE M.SETID = X.SETID
          AND M.DEPTID = X.DEPTID
          AND M.EFFDT <= SYSDATE
        )
      AND JOBA.EMPLID = A.EMPLID
      AND JOBA.EFFDT = A.EFFDT
      AND JOBA.EFFSEQ = (
        SELECT MAX(JOB2.EFFSEQ)
        FROM  SYSADM.ODS_HR_JOB_VW JOB2
        WHERE JOB2.EMPLID = JOBA.EMPLID
          AND JOB2.EMPL_RCD = JOBA.EMPL_RCD
          AND JOB2.EFFDT = JOBA.EFFDT
        )
      AND JOBA.EMPL_RCD = '0'
    ) BUMEN
  ,
  --所属部门
  (
    SELECT DESCR
    FROM SYSADM.HR_VW_HX_EMPL_CLASS A
      ,SYSADM.ODS_HR_JOB_VW JOBD
    WHERE A.EFF_STATUS = 'A'
      AND A.SETID = (
        SELECT SETID
        FROM SYSADM.HR_VW_SET_CNTRL_REC SC
        WHERE SC.SETCNTRLVALUE = JOBD.BUSINESS_UNIT
          AND SC.RECNAME = 'HX_EMPL_CLASS'
        )
      AND A.HX_EMPL_CLASS = JOBD.HX_EMPL_CLASS
      AND A.EFFDT = (
        SELECT MAX(B.EFFDT)
        FROM SYSADM.HR_VW_HX_EMPL_CLASS B
        WHERE B.EFF_STATUS = 'A'
          AND B.SETID = A.SETID
          AND B.HX_EMPL_CLASS = A.HX_EMPL_CLASS
          AND B.EFFDT <= TO_DATE(TO_CHAR(SYSDATE, 'YYYY-MM-DD'), 'YYYY-MM-DD')
        )
      AND JOBD.EMPLID = A.EMPLID
      AND JOBD.EFFDT = A.EFFDT
      AND JOBD.EFFSEQ = (
        SELECT MAX(JOB5.EFFSEQ)
        FROM SYSADM.ODS_HR_JOB_VW JOB5
        WHERE JOB5.EMPLID = JOBD.EMPLID
          AND JOB5.EMPL_RCD = JOBD.EMPL_RCD
          AND JOB5.EFFDT = JOBD.EFFDT
        )
      AND JOBD.EMPL_RCD = '0'
    ) YGFENLEI
  ,
  --员工分类
  (
    SELECT DESCR
    FROM SYSADM.HR_VW_POSITION_DATA Y
      ,SYSADM.ODS_HR_JOB_VW JOBB
    WHERE Y.EFF_STATUS = 'A'
      AND Y.POSITION_NBR = JOBB.POSITION_NBR
      AND Y.EFFDT = --A.EFFDT
      (
        SELECT MAX(N.EFFDT)
        FROM SYSADM.HR_VW_POSITION_DATA N
        WHERE N.POSITION_NBR = Y.POSITION_NBR
          AND N.EFFDT <= A.EFFDT
        )
      AND JOBB.EMPLID = A.EMPLID
      AND JOBB.EFFDT = A.EFFDT
      AND JOBB.EFFSEQ = (
        SELECT MAX(JOB3.EFFSEQ)
        FROM SYSADM.ODS_HR_JOB_VW JOB3
        WHERE JOB3.EMPLID = JOBB.EMPLID
          AND JOB3.EMPL_RCD = JOBB.EMPL_RCD
          AND JOB3.EFFDT = JOBB.EFFDT
        )
      AND JOBB.EMPL_RCD = '0'
    ) ZHIWEI
  ,
  --职位干部
  (
    SELECT DESCR
    FROM SYSADM.HR_VW_JOBCODE_TBL Z
      ,SYSADM.ODS_HR_JOB_VW JOBC
    WHERE Z.EFF_STATUS = 'A'
      AND Z.SETID = (
        SELECT HR_VW_SET_CNTRL_GROUP.SETID
        FROM SYSADM.HR_VW_REC_GROUP_REC
          ,SYSADM.HR_VW_SET_CNTRL_GROUP
        WHERE HR_VW_REC_GROUP_REC.RECNAME = 'JOBCODE_TBL'
          AND HR_VW_REC_GROUP_REC.REC_GROUP_ID = HR_VW_SET_CNTRL_GROUP.REC_GROUP_ID
          AND HR_VW_SET_CNTRL_GROUP.SETCNTRLVALUE = JOBC.BUSINESS_UNIT
        )
      AND Z.JOBCODE = JOBC.JOBCODE
      AND Z.EFFDT = --A.EFFDT
      (
        SELECT MAX(P.EFFDT)
        FROM SYSADM.HR_VW_JOBCODE_TBL P
        WHERE P.SETID = Z.SETID
          AND P.JOBCODE = Z.JOBCODE
          AND P.EFFDT <= A.EFFDT
        )
      AND JOBC.EMPLID = A.EMPLID
      AND JOBC.EFFDT = A.EFFDT
      AND JOBC.EFFSEQ = (
        SELECT MAX(JOB4.EFFSEQ)
        FROM SYSADM.ODS_HR_JOB_VW JOB4
        WHERE JOB4.EMPLID = JOBC.EMPLID
          AND JOB4.EMPL_RCD = JOBC.EMPL_RCD
          AND JOB4.EFFDT = JOBC.EFFDT
        )
      AND JOBC.EMPL_RCD = '0'
    ) ZHIWU
  ,
  --职务
  A.HX_MAN_LVL_DESCR ZHIJI --现职级
FROM SYSADM.ODM_HR_PS_OCT_EXWK_OTH A
  ,SYSADM.HR_VW_ACTION_TBL B
WHERE A.EMPLID = '${id}'
  AND A.ACTION = B.ACTION
  AND B.EFF_STATUS = 'A'
  AND A.EFFDT = (
   SELECT MAX(JOB2.EFFDT)
        FROM  SYSADM.ODS_HR_JOB_VW JOB2
        WHERE JOB2.EMPLID = A.EMPLID
          --AND JOB2.EMPL_RCD = A.EMPL_RCD
         -- AND JOB2.EFFSEQ = A.EFFSEQ
  )
  AND EXISTS (SELECT 1
                FROM SYSADM.HR_VW_DEPT_TBL X
                     ,SYSADM.ODS_HR_JOB_VW JOBA
        WHERE X.SETID = JOBA.SETID_DEPT
      AND X.DEPTID = JOBA.DEPTID
      AND X.EFFDT = --A.EFFDT
      (
        SELECT MAX(M.EFFDT)
        FROM SYSADM.HR_VW_DEPT_TBL M
        WHERE M.SETID = X.SETID
          AND M.DEPTID = X.DEPTID
          AND M.EFFDT <= SYSDATE
        )
      AND JOBA.EMPLID = A.EMPLID
      AND JOBA.EFFDT = (
     SELECT MAX(JOB2.EFFDT)
        FROM  SYSADM.ODS_HR_JOB_VW JOB2
        WHERE JOB2.EMPLID = JOBA.EMPLID
          AND JOB2.EMPL_RCD = JOBA.EMPL_RCD
          AND JOB2.EFFDT <= TO_DATE(TO_CHAR(SYSDATE, 'YYYY-MM-DD'),'YYYY-MM-DD')
    )
      AND JOBA.EFFSEQ = (
        SELECT MAX(JOB2.EFFSEQ)
        FROM  SYSADM.ODS_HR_JOB_VW JOB2
        WHERE JOB2.EMPLID = JOBA.EMPLID
          AND JOB2.EMPL_RCD = JOBA.EMPL_RCD
          AND JOB2.EFFDT = JOBA.EFFDT
        )
      AND JOBA.EMPL_RCD = '0'
      AND JOBA.EFFDT < X.EFFDT    
        )


),

 TT1 AS (
 SELECT  YGID,
         EFFDT,
         BUMEN,
        YGFENLEI,
CASE WHEN TT.ZHIWEI = '' or TT.ZHIWEI IS NULL
     THEN TT.ZHIWU
     ELSE TT.ZHIWEI
   END AS ZHIWU,
       ZHIJI,
     LAG(BUMEN) over(order by EFFDT) BUMEN1 ,
      LAG(YGFENLEI) over(order by EFFDT) YGFENLEI1 ,
    LAG(CASE WHEN TT.ZHIWEI = '' or TT.ZHIWEI IS NULL
     THEN TT.ZHIWU
     ELSE TT.ZHIWEI
   END) over(order by EFFDT) ZHIWU1 ,
     LAG(ZHIJI) over(order by EFFDT) ZHIJI1 
  FROM TT

  )  
,

AA AS
(

SELECT YGID,
       EFFDT,    
       BUMEN,
       YGFENLEI,
       ZHIWU,
       ZHIJI
  FROM TT1
  WHERE BUMEN<>BUMEN1
   OR YGFENLEI<>YGFENLEI
   OR ZHIWU<>ZHIWU1
   OR ZHIJI<>ZHIJI1

 
 UNION 

 SELECT YGID,
        EFFDT,
       BUMEN,
       YGFENLEI,
CASE WHEN TT.ZHIWEI = '' or TT.ZHIWEI IS NULL
     THEN TT.ZHIWU
     ELSE TT.ZHIWEI
   END ZHIWU,
       ZHIJI
  FROM TT
WHERE ACTION_DESCR IN ('雇用','重新雇用','辞职','辞退','实习期结束')

)

SELECT AA.YGID,
       AA.EFFDT,
       TT.ACTION_DESCR,
       AA.BUMEN,
       AA.YGFENLEI,
       AA.ZHIWU,
       AA.ZHIJI
  FROM AA
  LEFT JOIN TT
    ON AA.YGID = TT.YGID
   AND AA.EFFDT = TT.EFFDT
    ORDER BY EFFDT DESC]]></Query>
</TableData>
</TableDataMap>
<ReportFitAttr fitStateInPC="1" fitFont="false"/>
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
<WidgetName name="body"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Margin top="1" left="2" bottom="1" right="1"/>
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
<LCAttr vgap="0" hgap="0" compInterval="2"/>
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
<![CDATA[936000,936000,936000,936000,936000,936000,936000,936000,936000,936000,936000,1295400,936000,936000,936000,936000,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2880000,2880000,2895600,2592000,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O>
<![CDATA[姓名]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="0" s="1">
<O t="DSColumn">
<Attributes dsName="员工简历" columnName="XINGMING"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="0" cs="2" rs="5" s="2">
<O t="DSColumn">
<Attributes dsName="照片" columnName="EMPLOYEE_PHOTO"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0" showAsImage="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="0" r="1" s="0">
<O>
<![CDATA[性别]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1" s="1">
<O t="DSColumn">
<Attributes dsName="员工简历" columnName="XINGBIE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="2" s="0">
<O>
<![CDATA[出生日期]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="2" s="1">
<O t="DSColumn">
<Attributes dsName="员工简历" columnName="CSDATE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="3" s="0">
<O>
<![CDATA[民族]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="3" s="1">
<O t="DSColumn">
<Attributes dsName="员工简历" columnName="MINZU"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="4" s="0">
<O>
<![CDATA[籍贯]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="4" s="1">
<O t="DSColumn">
<Attributes dsName="员工简历" columnName="JIGUAN"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="5" s="0">
<O>
<![CDATA[户口所在地]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="5" s="3">
<O t="DSColumn">
<Attributes dsName="员工简历" columnName="HUKOUSZD"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="5" s="0">
<O>
<![CDATA[政治面貌]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="5" s="1">
<O t="DSColumn">
<Attributes dsName="员工简历" columnName="ZZMM"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="6" s="0">
<O>
<![CDATA[参加工作时间]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="6" s="1">
<O t="DSColumn">
<Attributes dsName="员工简历" columnName="CJGZDATE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="6" s="0">
<O>
<![CDATA[婚姻状况]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="6" s="1">
<O t="DSColumn">
<Attributes dsName="员工简历" columnName="HUNYINZK"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="7" s="0">
<O>
<![CDATA[入职日期]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="7" cs="3" s="1">
<O t="DSColumn">
<Attributes dsName="员工简历" columnName="RZDATE"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="8" s="0">
<O>
<![CDATA[所在单位]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="8" cs="3" s="1">
<O t="DSColumn">
<Attributes dsName="员工简历" columnName="DANWEI"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="9" s="0">
<O>
<![CDATA[所在部门]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="9" cs="3" s="1">
<O t="DSColumn">
<Attributes dsName="员工简历" columnName="BUMEN"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="10" s="0">
<O>
<![CDATA[岗位名称]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="10" cs="3" s="1">
<O t="DSColumn">
<Attributes dsName="员工简历" columnName="GANGWEI"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="11" s="0">
<O>
<![CDATA[职级]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="11" s="4">
<O t="DSColumn">
<Attributes dsName="员工简历" columnName="ZHIJI"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="11" s="0">
<O>
<![CDATA[任现职级时间]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="11" s="1">
<O t="DSColumn">
<Attributes dsName="员工简历" columnName="RXZHIJITIME"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="12" s="0">
<O>
<![CDATA[主营/非主营]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="12" s="1">
<O t="DSColumn">
<Attributes dsName="员工简历" columnName="ISZHUYING"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="12" s="0">
<O>
<![CDATA[员工分类]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="12" s="1">
<O t="DSColumn">
<Attributes dsName="员工简历" columnName="YGFENLEI"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="13" s="0">
<O>
<![CDATA[员工类别]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="13" s="1">
<O t="DSColumn">
<Attributes dsName="员工简历" columnName="YGLEIBIE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="13" s="0">
<O>
<![CDATA[直接上级]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="13" s="1">
<O t="DSColumn">
<Attributes dsName="员工简历" columnName="ZJZG"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="0" r="14" s="5">
<O>
<![CDATA[所属序列]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="14" s="1">
<O t="DSColumn">
<Attributes dsName="员工简历" columnName="SSXULIE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="14" s="0">
<O>
<![CDATA[职能序列]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="14" s="1">
<O t="DSColumn">
<Attributes dsName="员工简历" columnName="ZHINENGXULIE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="15" s="0">
<O>
<![CDATA[是否常青藤]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="15" s="1">
<O t="DSColumn">
<Attributes dsName="员工简历" columnName="ISCQT"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="15" s="0">
<O>
<![CDATA[常青藤年度]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="15" s="1">
<O t="DSColumn">
<Attributes dsName="员工简历" columnName="CQTCDLYEAR"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=IF(B16='否',"",$$$)]]></Content>
</Present>
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
<FRFont name="微软雅黑" style="1" size="72"/>
<Background name="ColorBackground" color="-986896"/>
<Border>
<Top style="1" color="-4144960"/>
<Bottom style="1" color="-4144960"/>
<Left style="1" color="-4144960"/>
<Right style="1" color="-4144960"/>
</Border>
</Style>
<Style horizontal_alignment="2" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-4144960"/>
<Bottom style="1" color="-4144960"/>
<Left style="1" color="-4144960"/>
<Right style="1" color="-4144960"/>
</Border>
</Style>
<Style imageLayout="4">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-4144960"/>
<Bottom style="1" color="-4144960"/>
<Left style="1" color="-4144960"/>
<Right style="1" color="-4144960"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-4144960"/>
<Bottom style="1" color="-4144960"/>
<Left style="1" color="-4144960"/>
<Right style="1" color="-4144960"/>
</Border>
</Style>
<Style horizontal_alignment="2" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-1"/>
<Border>
<Top style="1" color="-4144960"/>
<Bottom style="1" color="-4144960"/>
<Left style="1" color="-4144960"/>
<Right style="1" color="-4144960"/>
</Border>
</Style>
<Style horizontal_alignment="2" imageLayout="1">
<FRFont name="微软雅黑" style="1" size="72"/>
<Background name="ColorBackground" color="-986896"/>
<Border>
<Top style="1" color="-5263441"/>
<Bottom style="1" color="-5263441"/>
<Left style="1" color="-5263441"/>
<Right style="1" color="-5263441"/>
</Border>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<isShared isshared="false"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="0" zoom="true" refresh="false" isUseHTML="false"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="431" height="547"/>
</Widget>
<body class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="report0"/>
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
<isShared isshared="false"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="0" zoom="true" refresh="false" isUseHTML="false"/>
</body>
</InnerWidget>
<BoundsAttr x="0" y="0" width="410" height="560"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.cardlayout.WCardMainBorderLayout">
<WidgetName name="tablayout0"/>
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
<NorthAttr size="46"/>
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
<AddTagAttr layoutName="tabpane0"/>
</East>
<Center class="com.fr.form.ui.container.cardlayout.WCardTagLayout">
<WidgetName name="cdf6d113-5815-494a-a69e-4fc9a1a34260"/>
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
<WidgetName name="9f77bcc5-50e8-4fd4-b4d4-ae3c35d133fb"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Text>
<![CDATA[标题0]]></Text>
<FRFont name="SimSun" style="0" size="72"/>
<isCustomType isCustomType="true"/>
<SwitchTagAttr layoutName="tabpane0"/>
</Widget>
<Widget class="com.fr.form.ui.CardSwitchButton">
<WidgetName name="4060cadb-3cfc-450d-a53c-9627477a1d97"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Text>
<![CDATA[标题1]]></Text>
<FRFont name="SimSun" style="0" size="72"/>
<isCustomType isCustomType="true"/>
<SwitchTagAttr layoutName="tabpane0" index="1"/>
</Widget>
<Widget class="com.fr.form.ui.CardSwitchButton">
<WidgetName name="65968456-a2b0-4f76-bdf1-e4a8d0aa9230"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Text>
<![CDATA[标题2]]></Text>
<FRFont name="SimSun" style="0" size="72"/>
<isCustomType isCustomType="true"/>
<SwitchTagAttr layoutName="tabpane0" index="2"/>
</Widget>
<Widget class="com.fr.form.ui.CardSwitchButton">
<WidgetName name="742f8f7e-f4b2-4ae0-92dd-3c2b6ee9dcc1"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Text>
<![CDATA[标题3]]></Text>
<FRFont name="SimSun" style="0" size="72"/>
<isCustomType isCustomType="true"/>
<SwitchTagAttr layoutName="tabpane0" index="3"/>
</Widget>
<Widget class="com.fr.form.ui.CardSwitchButton">
<WidgetName name="4b02f772-427b-4773-9491-0dba7960f111"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Text>
<![CDATA[标题4]]></Text>
<FRFont name="SimSun" style="0" size="72"/>
<isCustomType isCustomType="true"/>
<SwitchTagAttr layoutName="tabpane0" index="4"/>
</Widget>
<FLAttr alignment="0"/>
<ColumnWidth defaultValue="80">
<![CDATA[200,80,80,80,80,80,80,80,80,80,80]]></ColumnWidth>
</Center>
<CardTitleLayout layoutName="tabpane0"/>
</North>
<Center class="com.fr.form.ui.container.WCardLayout">
<Listener event="afterinit">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[$('div:lt(1)',this.element.parent()).hide();//隐藏tab标题  ]]></Content>
</JavaScript>
</Listener>
<WidgetName name="tabpane0"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="0" color="-723724" borderRadius="0" type="1" borderStyle="0"/>
<WidgetTitle>
<O>
<![CDATA[title]]></O>
<FRFont name="宋体" style="0" size="72"/>
<Position pos="0"/>
<Background name="ColorBackground" color="-13400848"/>
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
<![CDATA[1296000,1152000,1152000,720000,1296000,1152000,1152000,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[3771900,3456000,5676900,5040000,4267200,0,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O>
<![CDATA[内部工作履历]]></O>
<PrivilegeControl/>
<CellPageAttr/>
<Expand/>
</C>
<C c="1" r="0" cs="4" s="1">
<O>
<![CDATA[（2014年7月后）]]></O>
<PrivilegeControl/>
<CellPageAttr/>
<Expand/>
</C>
<C c="0" r="1" s="2">
<O>
<![CDATA[开始时间]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1" s="2">
<O>
<![CDATA[结束时间]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="1" s="2">
<O>
<![CDATA[所在部门]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="1" s="2">
<O>
<![CDATA[职位/职务]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="1" s="2">
<O>
<![CDATA[职级]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="1">
<O>
<![CDATA[操作]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="2" s="3">
<O t="DSColumn">
<Attributes dsName="内部工作履历" columnName="EFFDT"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper">
<Attr divideMode="1"/>
</RG>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="1" r="2" s="3">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=A3[A3:-1]A - 1]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ObjectCondition">
<Compare op="0">
<O>
<![CDATA[-1]]></O>
</Compare>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[至今]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="2" r="2" s="3">
<O t="DSColumn">
<Attributes dsName="内部工作履历" columnName="BUMEN"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ObjectCondition">
<Compare op="10">
<O>
<![CDATA[数据转换]]></O>
</Compare>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[华夏幸福]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.ObjectCondition">
<Compare op="10">
<O>
<![CDATA[华夏幸福_历史离职员工（2014-7-1前离职）]]></O>
</Compare>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[华夏幸福]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="3" r="2" s="3">
<O t="DSColumn">
<Attributes dsName="内部工作履历" columnName="ZHIWU"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ObjectCondition">
<Compare op="0">
<O>
<![CDATA[历史离职员工（2014-7-1前离职）]]></O>
</Compare>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.ObjectCondition">
<Compare op="10">
<O>
<![CDATA[数据转换]]></O>
</Compare>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="4" r="2" s="3">
<O t="DSColumn">
<Attributes dsName="内部工作履历" columnName="ZHIJI"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="5" r="2">
<O t="DSColumn">
<Attributes dsName="内部工作履历" columnName="ACTION_DESCR"/>
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
<Condition class="com.fr.data.condition.ObjectCondition">
<Compare op="0">
<O>
<![CDATA[辞职]]></O>
</Compare>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.ObjectCondition">
<Compare op="0">
<O>
<![CDATA[实习期结束]]></O>
</Compare>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.ObjectCondition">
<Compare op="0">
<O>
<![CDATA[辞退]]></O>
</Compare>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="0" r="4" cs="5" s="4">
<O>
<![CDATA[外部工作履历]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="5" s="2">
<O>
<![CDATA[开始时间]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="5" s="2">
<O>
<![CDATA[结束时间]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="5" s="2">
<O>
<![CDATA[单位名称]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="5" s="2">
<O>
<![CDATA[任职部门]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="5" s="2">
<O>
<![CDATA[最后职位]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="6" s="3">
<O t="DSColumn">
<Attributes dsName="外部工作履历" columnName="STARTTIME"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="1" r="6" s="3">
<O t="DSColumn">
<Attributes dsName="外部工作履历" columnName="ENDTIME"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="2" r="6" s="3">
<O t="DSColumn">
<Attributes dsName="外部工作履历" columnName="DANWEI"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="3" r="6" s="3">
<O t="DSColumn">
<Attributes dsName="外部工作履历" columnName="RZBUMEN"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="4" r="6" s="3">
<O t="DSColumn">
<Attributes dsName="外部工作履历" columnName="FINZHIWEI"/>
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
<FRFont name="微软雅黑" style="1" size="72" foreground="-4259832"/>
<Background name="ColorBackground" color="-855310"/>
<Border>
<Top style="1" color="-3881788"/>
<Bottom style="1" color="-3881788"/>
<Left style="1" color="-3881788"/>
</Border>
</Style>
<Style horizontal_alignment="2" imageLayout="1">
<FRFont name="微软雅黑" style="1" size="56"/>
<Background name="ColorBackground" color="-855310"/>
<Border>
<Top style="1" color="-3881788"/>
<Bottom style="1" color="-3881788"/>
<Right style="1" color="-3881788"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="1" size="72"/>
<Background name="ColorBackground" color="-855310"/>
<Border>
<Top style="1" color="-4144960"/>
<Bottom style="1" color="-4144960"/>
<Left style="1" color="-4144960"/>
<Right style="1" color="-4144960"/>
</Border>
</Style>
<Style horizontal_alignment="2" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-4144960"/>
<Bottom style="1" color="-4144960"/>
<Left style="1" color="-4144960"/>
<Right style="1" color="-4144960"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="1" size="72" foreground="-4259832"/>
<Background name="ColorBackground" color="-855310"/>
<Border>
<Top style="1" color="-4144960"/>
<Bottom style="1" color="-4144960"/>
<Left style="1" color="-4144960"/>
<Right style="1" color="-4144960"/>
</Border>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<isShared isshared="false"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="0" zoom="true" refresh="false" isUseHTML="false"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="515" height="452"/>
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
<O t="I">
<![CDATA[1]]></O>
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
<isShared isshared="false"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="0" zoom="true" refresh="false" isUseHTML="false"/>
</body>
</InnerWidget>
<BoundsAttr x="0" y="0" width="515" height="452"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="report1"/>
</MobileWidgetList>
<WidgetZoomAttr compState="0"/>
<AppRelayout appRelayout="true"/>
<Size width="515" height="452"/>
<ResolutionScalingAttr percent="0.9"/>
<tabFitAttr index="0" tabNameIndex="0"/>
</Widget>
<Widget class="com.fr.form.ui.container.cardlayout.WTabFitLayout">
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
<![CDATA[1296000,1152000,1152000,723900,1296000,1295400,1152000,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[3276600,2880000,2880000,3312000,5974080,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" cs="5" s="0">
<O>
<![CDATA[绩效记录]]></O>
<PrivilegeControl/>
<CellPageAttr/>
<Expand extendable="3"/>
</C>
<C c="0" r="1" s="1">
<PrivilegeControl/>
<CellPageAttr/>
<Expand extendable="3"/>
</C>
<C c="1" r="1" s="1">
<O>
<![CDATA[Q1绩效]]></O>
<PrivilegeControl/>
<CellPageAttr/>
<Expand extendable="3"/>
</C>
<C c="2" r="1" s="1">
<O>
<![CDATA[Q2绩效]]></O>
<PrivilegeControl/>
<CellPageAttr/>
<Expand extendable="3"/>
</C>
<C c="3" r="1" s="1">
<O>
<![CDATA[Q3绩效]]></O>
<PrivilegeControl/>
<CellPageAttr/>
<Expand extendable="3"/>
</C>
<C c="4" r="1" s="1">
<O>
<![CDATA[年度绩效]]></O>
<PrivilegeControl/>
<CellPageAttr/>
<Expand extendable="3"/>
</C>
<C c="0" r="2" s="2">
<O t="DSColumn">
<Attributes dsName="绩效" columnName="JXYEAR"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper">
<Attr divideMode="1"/>
</RG>
<Parameters/>
</O>
<PrivilegeControl/>
<CellPageAttr/>
<Expand dir="0" extendable="3"/>
</C>
<C c="1" r="2" s="2">
<O t="DSColumn">
<Attributes dsName="绩效" columnName="Q1JX"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<CellPageAttr/>
<Expand dir="0" extendable="3"/>
</C>
<C c="2" r="2" s="2">
<O t="DSColumn">
<Attributes dsName="绩效" columnName="Q2JX"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<CellPageAttr/>
<Expand dir="0" extendable="3"/>
</C>
<C c="3" r="2" s="2">
<O t="DSColumn">
<Attributes dsName="绩效" columnName="Q3JX"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<CellPageAttr/>
<Expand dir="0" extendable="3"/>
</C>
<C c="4" r="2" s="2">
<O t="DSColumn">
<Attributes dsName="绩效" columnName="NDJX"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<CellPageAttr/>
<Expand dir="0" extendable="3"/>
</C>
<C c="0" r="3">
<PrivilegeControl/>
<CellPageAttr/>
<Expand/>
</C>
<C c="1" r="3">
<PrivilegeControl/>
<CellPageAttr/>
<Expand/>
</C>
<C c="2" r="3">
<PrivilegeControl/>
<CellPageAttr/>
<Expand/>
</C>
<C c="3" r="3">
<PrivilegeControl/>
<CellPageAttr/>
<Expand/>
</C>
<C c="4" r="3">
<PrivilegeControl/>
<CellPageAttr/>
<Expand/>
</C>
<C c="0" r="4" cs="3" s="3">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="<font color='#c00008'>晋升记录</font><font color='black'>   （2014年7月后）</font>"]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand extendable="3"/>
</C>
<C c="3" r="4" cs="2" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="5" s="1">
<O>
<![CDATA[晋升日期]]></O>
<PrivilegeControl/>
<CellPageAttr/>
<Expand extendable="3"/>
</C>
<C c="1" r="5" s="1">
<O>
<![CDATA[晋升前职级]]></O>
<PrivilegeControl/>
<CellPageAttr/>
<Expand extendable="3"/>
</C>
<C c="2" r="5" s="1">
<O>
<![CDATA[晋升后职级]]></O>
<PrivilegeControl/>
<CellPageAttr/>
<Expand extendable="3"/>
</C>
<C c="3" r="5" s="1">
<O>
<![CDATA[晋升后\\n任现职级时长]]></O>
<PrivilegeControl/>
<CellPageAttr/>
<Expand extendable="3"/>
</C>
<C c="4" r="5" s="1">
<O>
<![CDATA[晋升所在部门]]></O>
<PrivilegeControl/>
<CellPageAttr/>
<Expand extendable="3"/>
</C>
<C c="0" r="6" s="2">
<O t="DSColumn">
<Attributes dsName="晋升" columnName="JSDATE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper">
<Attr divideMode="1"/>
</RG>
<Parameters/>
</O>
<PrivilegeControl/>
<CellPageAttr/>
<Expand dir="0" extendable="3"/>
</C>
<C c="1" r="6" s="2">
<O t="DSColumn">
<Attributes dsName="晋升" columnName="JSBZHIJI"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition"/>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(len($$$)=0,'',$$$+"级")]]></Attributes>
</O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0" extendable="3"/>
</C>
<C c="2" r="6" s="2">
<O t="DSColumn">
<Attributes dsName="晋升" columnName="JSAZHIJI"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition"/>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(len($$$)=0,'',$$$+"级")]]></Attributes>
</O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0" extendable="3"/>
</C>
<C c="3" r="6" s="2">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(A7 =NULL,null,IF(A7[A7:+1]A != NULL, ROUND(((A7[A7:+1]A - A7) / 365), 2), ROUND(((NOW() - A7) / 365), 2)))]]></Attributes>
</O>
<PrivilegeControl/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition"/>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(len($$$)=0,'',$$$+"年")]]></Attributes>
</O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0" extendable="3"/>
</C>
<C c="4" r="6" s="2">
<O t="DSColumn">
<Attributes dsName="晋升" columnName="JSSZBUMEN"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<CellPageAttr/>
<Expand dir="0" extendable="3"/>
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
<FRFont name="微软雅黑" style="1" size="72" foreground="-4259832"/>
<Background name="ColorBackground" color="-855310"/>
<Border>
<Top style="1" color="-4144960"/>
<Bottom style="1" color="-4144960"/>
<Left style="1" color="-4144960"/>
<Right style="1" color="-4144960"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="1" size="72"/>
<Background name="ColorBackground" color="-855310"/>
<Border>
<Top style="1" color="-4144960"/>
<Bottom style="1" color="-4144960"/>
<Left style="1" color="-4144960"/>
<Right style="1" color="-4144960"/>
</Border>
</Style>
<Style horizontal_alignment="2" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-4144960"/>
<Bottom style="1" color="-4144960"/>
<Left style="1" color="-4144960"/>
<Right style="1" color="-4144960"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="1" size="72" foreground="-4259832"/>
<Background name="ColorBackground" color="-855310"/>
<Border>
<Top style="1" color="-4144960"/>
<Bottom style="1" color="-4144960"/>
<Left style="1" color="-4144960"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="1" size="72" foreground="-4259832"/>
<Background name="ColorBackground" color="-855310"/>
<Border>
<Top style="1" color="-4144960"/>
<Bottom style="1" color="-4144960"/>
<Right style="1" color="-4144960"/>
</Border>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<isShared isshared="false"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="0" zoom="true" refresh="false" isUseHTML="false"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="515" height="452"/>
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
<CellElementList>
<C c="0" r="0">
<O t="I">
<![CDATA[2]]></O>
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
<isShared isshared="false"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="0" zoom="true" refresh="false" isUseHTML="false"/>
</body>
</InnerWidget>
<BoundsAttr x="0" y="0" width="515" height="452"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="report3"/>
</MobileWidgetList>
<WidgetZoomAttr compState="0"/>
<AppRelayout appRelayout="true"/>
<Size width="515" height="452"/>
<ResolutionScalingAttr percent="0.9"/>
<tabFitAttr index="1" tabNameIndex="1"/>
</Widget>
<Widget class="com.fr.form.ui.container.cardlayout.WTabFitLayout">
<WidgetName name="Tab2"/>
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
<![CDATA[1296000,1152000,1152000,720000,1296000,1152000,1152000,1152000,1152000,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[4464000,3168000,3312000,2971800,3888000,3888000,2933700,3600000,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" cs="7" s="0">
<O>
<![CDATA[参训信息]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="1" cs="3" s="1">
<O>
<![CDATA[学习项目名称]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="1" s="1">
<O>
<![CDATA[学习类型]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="1" s="1">
<O>
<![CDATA[开始时间]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="1" s="1">
<O>
<![CDATA[结束时间]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="1" s="1">
<O>
<![CDATA[参训时长(小时)]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="2" cs="3" s="2">
<O t="DSColumn">
<Attributes dsName="内部培训参训" columnName="XXXMMC"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="3" r="2" s="2">
<O t="DSColumn">
<Attributes dsName="内部培训参训" columnName="XXXMLX"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="4" r="2" s="2">
<O t="DSColumn">
<Attributes dsName="内部培训参训" columnName="STARTTIME"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="5" r="2" s="2">
<O t="DSColumn">
<Attributes dsName="内部培训参训" columnName="ENDTIME"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="6" r="2" s="3">
<O t="DSColumn">
<Attributes dsName="内部培训参训" columnName="CXTIME"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="0" r="4" cs="7" s="0">
<O>
<![CDATA[授课信息]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="5" s="1">
<O>
<![CDATA[项目名称]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="5" s="1">
<O>
<![CDATA[项目类型]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="5" s="1">
<O>
<![CDATA[授课/活动]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="5" s="1">
<O>
<![CDATA[授课时长(小时)]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="5" s="1">
<O>
<![CDATA[开始时间]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="5" s="1">
<O>
<![CDATA[结束时间]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="5" s="1">
<O>
<![CDATA[满意度]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="6" s="4">
<O t="DSColumn">
<Attributes dsName="授课" columnName="XXXMMC"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="1" r="6" s="4">
<O t="DSColumn">
<Attributes dsName="授课" columnName="XXXMLX"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="2" r="6" s="4">
<O t="DSColumn">
<Attributes dsName="授课" columnName="SKORHD"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="3" r="6" s="3">
<O t="DSColumn">
<Attributes dsName="授课" columnName="SKTIME"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="4" r="6" s="4">
<O t="DSColumn">
<Attributes dsName="授课" columnName="STARTTIME"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="5" r="6" s="4">
<O t="DSColumn">
<Attributes dsName="授课" columnName="ENDTIME"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="6" r="6" s="3">
<O t="DSColumn">
<Attributes dsName="授课" columnName="MANYIDU"/>
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
<FRFont name="微软雅黑" style="1" size="72" foreground="-4194304"/>
<Background name="ColorBackground" color="-855310"/>
<Border>
<Top style="1" color="-4144960"/>
<Bottom style="1" color="-4144960"/>
<Left style="1" color="-4144960"/>
<Right style="1" color="-4144960"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="1" size="64"/>
<Background name="ColorBackground" color="-855310"/>
<Border>
<Top style="1" color="-4144960"/>
<Bottom style="1" color="-4144960"/>
<Left style="1" color="-4144960"/>
<Right style="1" color="-4144960"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-4144960"/>
<Bottom style="1" color="-4144960"/>
<Left style="1" color="-4144960"/>
<Right style="1" color="-4144960"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-4144960"/>
<Bottom style="1" color="-4144960"/>
<Left style="1" color="-4144960"/>
<Right style="1" color="-4144960"/>
</Border>
</Style>
<Style horizontal_alignment="2" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-4144960"/>
<Bottom style="1" color="-4144960"/>
<Left style="1" color="-4144960"/>
<Right style="1" color="-4144960"/>
</Border>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<isShared isshared="false"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="0" zoom="true" refresh="false" isUseHTML="false"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="515" height="452"/>
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
<CellElementList>
<C c="0" r="0">
<O t="I">
<![CDATA[3]]></O>
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
<isShared isshared="false"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="0" zoom="true" refresh="false" isUseHTML="false"/>
</body>
</InnerWidget>
<BoundsAttr x="0" y="0" width="515" height="452"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="report4"/>
</MobileWidgetList>
<WidgetZoomAttr compState="0"/>
<AppRelayout appRelayout="true"/>
<Size width="515" height="452"/>
<ResolutionScalingAttr percent="0.9"/>
<tabFitAttr index="2" tabNameIndex="2"/>
</Widget>
<Widget class="com.fr.form.ui.container.cardlayout.WTabFitLayout">
<WidgetName name="Tab3"/>
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
<![CDATA[1152000,1295400,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[3456000,3456000,2880000,2628900,3600000,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O>
<![CDATA[开始时间]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="0" s="0">
<O>
<![CDATA[结束时间]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="0" s="0">
<O>
<![CDATA[毕业院校]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="0" s="0">
<O>
<![CDATA[专业]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="0" s="0">
<O>
<![CDATA[学历]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="1" s="1">
<O t="DSColumn">
<Attributes dsName="教育经历" columnName="STARTTIME"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="1" r="1" s="1">
<O t="DSColumn">
<Attributes dsName="教育经历" columnName="ENDTIME"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="2" r="1" s="1">
<O t="DSColumn">
<Attributes dsName="教育经历" columnName="XUEXIAO"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="3" r="1" s="1">
<O t="DSColumn">
<Attributes dsName="教育经历" columnName="ZHUANYE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="4" r="1" s="1">
<O t="DSColumn">
<Attributes dsName="教育经历" columnName="XUELI"/>
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
<FRFont name="微软雅黑" style="1" size="72"/>
<Background name="ColorBackground" color="-855310"/>
<Border>
<Top style="1" color="-4144960"/>
<Bottom style="1" color="-4144960"/>
<Left style="1" color="-4144960"/>
<Right style="1" color="-4144960"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-4144960"/>
<Bottom style="1" color="-4144960"/>
<Left style="1" color="-4144960"/>
<Right style="1" color="-4144960"/>
</Border>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<isShared isshared="false"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="0" zoom="true" refresh="false" isUseHTML="false"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="515" height="452"/>
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
<![CDATA[723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<O t="I">
<![CDATA[4]]></O>
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
<isShared isshared="false"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="0" zoom="true" refresh="false" isUseHTML="false"/>
</body>
</InnerWidget>
<BoundsAttr x="0" y="0" width="515" height="452"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="report5"/>
</MobileWidgetList>
<WidgetZoomAttr compState="0"/>
<AppRelayout appRelayout="true"/>
<Size width="515" height="452"/>
<ResolutionScalingAttr percent="0.9"/>
<tabFitAttr index="3" tabNameIndex="3"/>
</Widget>
<Widget class="com.fr.form.ui.container.cardlayout.WTabFitLayout">
<WidgetName name="Tab4"/>
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
<![CDATA[1152000,1295400,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[3600000,1440000,3456000,1440000,3600000,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O>
<![CDATA[与员工关系]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="0" s="0">
<O>
<![CDATA[姓名]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="0" s="0">
<O>
<![CDATA[出生日期]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="0" s="0">
<O>
<![CDATA[性别]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="0" s="0">
<O>
<![CDATA[所在单位]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="0" s="0">
<O>
<![CDATA[职务]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="1" s="1">
<O t="DSColumn">
<Attributes dsName="家庭成员" columnName="RELA"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper">
<Attr divideMode="1"/>
</RG>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="1" r="1" s="1">
<O t="DSColumn">
<Attributes dsName="家庭成员" columnName="XINGMING"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="2" r="1" s="1">
<O t="DSColumn">
<Attributes dsName="家庭成员" columnName="CSDATE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="3" r="1" s="1">
<O t="DSColumn">
<Attributes dsName="家庭成员" columnName="XINGBIE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="4" r="1" s="1">
<O t="DSColumn">
<Attributes dsName="家庭成员" columnName="DANWEI"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="5" r="1" s="1">
<O t="DSColumn">
<Attributes dsName="家庭成员" columnName="ZHIWU"/>
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
<FRFont name="微软雅黑" style="1" size="72"/>
<Background name="ColorBackground" color="-855310"/>
<Border>
<Top style="1" color="-4144960"/>
<Bottom style="1" color="-4144960"/>
<Left style="1" color="-4144960"/>
<Right style="1" color="-4144960"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-4144960"/>
<Bottom style="1" color="-4144960"/>
<Left style="1" color="-4144960"/>
<Right style="1" color="-4144960"/>
</Border>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<isShared isshared="false"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="0" zoom="true" refresh="false" isUseHTML="false"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="515" height="452"/>
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
<CellElementList>
<C c="0" r="0">
<O t="I">
<![CDATA[5]]></O>
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
<isShared isshared="false"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="0" zoom="true" refresh="false" isUseHTML="false"/>
</body>
</InnerWidget>
<BoundsAttr x="0" y="0" width="515" height="452"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="report6"/>
</MobileWidgetList>
<WidgetZoomAttr compState="0"/>
<AppRelayout appRelayout="true"/>
<Size width="515" height="452"/>
<ResolutionScalingAttr percent="0.9"/>
<tabFitAttr index="4" tabNameIndex="4"/>
</Widget>
<carouselAttr isCarousel="false" carouselInterval="1.8"/>
</Center>
</InnerWidget>
<BoundsAttr x="410" y="56" width="490" height="504"/>
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
<![CDATA[1143000,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[3600000,3600000,3600000,3600000,3600000,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O>
<![CDATA[工作履历]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="JavaScript3">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[_g().options.form.getWidgetByName("tabpane0").showCardByIndex(0) ]]></Content>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="当前表单对象2">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="temp"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=2]]></Attributes>
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
<NameJavaScript name="CopyOf当前表单对象2">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="temp"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=2]]></Attributes>
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
</NameJavaScriptGroup>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$temp = 2]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[len($temp) = 0]]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.FRFontHighlightAction">
<FRFont name="微软雅黑" style="0" size="72" foreground="-1"/>
</HighlightAction>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ColorBackground" color="-4194304"/>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="1" r="0" s="0">
<O>
<![CDATA[绩效与晋升]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="JavaScript3">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[_g().options.form.getWidgetByName("tabpane0").showCardByIndex(1) ]]></Content>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="当前表单对象2">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="temp"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=1]]></Attributes>
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
<NameJavaScript name="CopyOf当前表单对象2">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="temp"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=1]]></Attributes>
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
</NameJavaScriptGroup>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$temp = 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ColorBackground" color="-4194304"/>
</HighlightAction>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.FRFontHighlightAction">
<FRFont name="微软雅黑" style="0" size="72" foreground="-1"/>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="2" r="0" s="0">
<O>
<![CDATA[内部培训经历]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="当前表单对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="temp"/>
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
<NameJavaScript name="CopyOf当前表单对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="temp"/>
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
<NameJavaScript name="JavaScript3">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[_g().options.form.getWidgetByName("tabpane0").showCardByIndex(2) ]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$temp = 3]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ColorBackground" color="-4194304"/>
</HighlightAction>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.FRFontHighlightAction">
<FRFont name="微软雅黑" style="0" size="72" foreground="-1"/>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="0" s="0">
<O>
<![CDATA[教育经历]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="当前表单对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="temp"/>
<O>
<![CDATA[4]]></O>
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
<NameJavaScript name="CopyOf当前表单对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="temp"/>
<O>
<![CDATA[4]]></O>
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
<NameJavaScript name="JavaScript3">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[_g().options.form.getWidgetByName("tabpane0").showCardByIndex(3) ]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[CopyOf条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$temp = 4]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ColorBackground" color="-4194304"/>
</HighlightAction>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.FRFontHighlightAction">
<FRFont name="微软雅黑" style="0" size="72" foreground="-1"/>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="4" r="0" s="0">
<O>
<![CDATA[家庭成员]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="当前表单对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="temp"/>
<O>
<![CDATA[5]]></O>
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
<NameJavaScript name="CopyOf当前表单对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="temp"/>
<O>
<![CDATA[5]]></O>
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
<NameJavaScript name="JavaScript3">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[_g().options.form.getWidgetByName("tabpane0").showCardByIndex(4) ]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[CopyOf条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$temp = 5]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ColorBackground" color="-4194304"/>
</HighlightAction>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.FRFontHighlightAction">
<FRFont name="微软雅黑" style="0" size="72" foreground="-1"/>
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
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-1"/>
<Border>
<Top style="1" color="-2171170"/>
<Bottom style="1" color="-2171170"/>
<Left style="1" color="-2171170"/>
<Right style="1" color="-2171170"/>
</Border>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<isShared isshared="false"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="0" zoom="true" refresh="false" isUseHTML="false"/>
</InnerWidget>
<BoundsAttr x="431" y="0" width="516" height="54"/>
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
<![CDATA[1143000,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[3600000,3600000,3600000,3600000,3600000,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O>
<![CDATA[工作履历]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="当前表单对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="temp"/>
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
<NameJavaScript name="CopyOf当前表单对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="temp"/>
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
<NameJavaScript name="JavaScript3">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[_g().options.form.getWidgetByName("tabpane0").showCardByIndex(0) ]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$temp = 2]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[len($temp) = 0]]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ColorBackground" color="-4194304"/>
</HighlightAction>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.FRFontHighlightAction">
<FRFont name="微软雅黑" style="0" size="72" foreground="-1"/>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="1" r="0" s="0">
<O>
<![CDATA[绩效与晋升]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="当前表单对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="temp"/>
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
<NameJavaScript name="CopyOf当前表单对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="temp"/>
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
<NameJavaScript name="JavaScript3">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[_g().options.form.getWidgetByName("tabpane3").showCardByIndex(0) ]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$temp = 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ColorBackground" color="-4194304"/>
</HighlightAction>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.FRFontHighlightAction">
<FRFont name="微软雅黑" style="0" size="72" foreground="-1"/>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="2" r="0" s="0">
<O>
<![CDATA[内部培训经历]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="当前表单对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="temp"/>
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
<NameJavaScript name="CopyOf当前表单对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="temp"/>
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
<NameJavaScript name="JavaScript3">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[_g().options.form.getWidgetByName("tabpane4").showCardByIndex(0) ]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$temp = 3]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ColorBackground" color="-4194304"/>
</HighlightAction>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.FRFontHighlightAction">
<FRFont name="微软雅黑" style="0" size="72" foreground="-1"/>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="0" s="0">
<O>
<![CDATA[教育经历]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="当前表单对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="temp"/>
<O>
<![CDATA[4]]></O>
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
<NameJavaScript name="CopyOf当前表单对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="temp"/>
<O>
<![CDATA[4]]></O>
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
<NameJavaScript name="JavaScript3">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[_g().options.form.getWidgetByName("tabpane5").showCardByIndex(0) ]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[CopyOf条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$temp = 4]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ColorBackground" color="-4194304"/>
</HighlightAction>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.FRFontHighlightAction">
<FRFont name="微软雅黑" style="0" size="72" foreground="-1"/>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="4" r="0" s="0">
<O>
<![CDATA[家庭成员]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="当前表单对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="temp"/>
<O>
<![CDATA[5]]></O>
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
<NameJavaScript name="CopyOf当前表单对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="temp"/>
<O>
<![CDATA[5]]></O>
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
<NameJavaScript name="JavaScript3">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[_g().options.form.getWidgetByName("tabpane6").showCardByIndex(0) ]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[CopyOf条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$temp = 5]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ColorBackground" color="-4194304"/>
</HighlightAction>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.FRFontHighlightAction">
<FRFont name="微软雅黑" style="0" size="72" foreground="-1"/>
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
<FRFont name="微软雅黑" style="0" size="72" foreground="-16776961" underline="1"/>
<Background name="ColorBackground" color="-1"/>
<Border>
<Top style="1" color="-2171170"/>
<Bottom style="1" color="-2171170"/>
<Left style="1" color="-2171170"/>
<Right style="1" color="-2171170"/>
</Border>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<isShared isshared="false"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="0" zoom="true" refresh="false" isUseHTML="false"/>
</body>
</InnerWidget>
<BoundsAttr x="410" y="0" width="490" height="56"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="report0"/>
<Widget widgetName="report2"/>
<Widget widgetName="tablayout0"/>
</MobileWidgetList>
<WidgetZoomAttr compState="1"/>
<AppRelayout appRelayout="true"/>
<Size width="900" height="560"/>
<ResolutionScalingAttr percent="0.9"/>
<BodyLayoutType type="0"/>
</Center>
</Layout>
<DesignerVersion DesignerVersion="IAA"/>
<PreviewType PreviewType="0"/>
<TemplateID TemplateID="cd36cae0-367d-4587-9b00-5020c9fe444d"/>
</Form>
