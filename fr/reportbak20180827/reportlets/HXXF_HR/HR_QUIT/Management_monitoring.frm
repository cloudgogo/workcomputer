<?xml version="1.0" encoding="UTF-8"?>
<Form xmlVersion="20170715" releaseVersion="8.0.0">
<TableDataMap>
<TableData name="NDLZ" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="date_time"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="dwmc"/>
<O>
<![CDATA[]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[HXXF_HR]]></DatabaseName>
</Connection>
<Query>
<![CDATA[SELECT 
--主动主营离职
SUM(ZY_ND_ZDLZ) NDZDLZ, --年初人数
CASE WHEN ((SUM(CASE WHEN ZY_NC IS NULL THEN 0 ELSE ZY_NC END)+SUM(CASE WHEN ZY_DQ IS NULL THEN 0 ELSE ZY_DQ END))/2) =0 THEN 0 ELSE 
SUM(ZY_ND_ZDLZ)/((SUM(CASE WHEN ZY_NC IS NULL THEN 0 ELSE ZY_NC END)+SUM(CASE WHEN ZY_DQ IS NULL THEN 0 ELSE ZY_DQ END))/2) END ZDLZV, --主动离职率
--主动干部离职
SUM(GB_LZ_Q1) GB_LZ_Q1,SUM(GB_LZ_Q2) GB_LZ_Q2,SUM(GB_LZ_Q3) GB_LZ_Q3,SUM(GB_LZ_Q4) GB_LZ_Q4,
(CASE WHEN SUM(GB_LZ_Q1) IS NULL THEN 0 ELSE SUM(GB_LZ_Q1) END
       +CASE WHEN SUM(GB_LZ_Q2) IS NULL THEN 0 ELSE SUM(GB_LZ_Q2) END
       +CASE WHEN SUM(GB_LZ_Q3) IS NULL THEN 0 ELSE SUM(GB_LZ_Q3) END
       +CASE WHEN SUM(GB_LZ_Q4) IS NULL THEN 0 ELSE SUM(GB_LZ_Q4) END) GBNDLZ,
CASE WHEN ((SUM(CASE WHEN GB_NC IS NULL THEN 0 ELSE GB_NC END)+SUM(CASE WHEN GB_DQ IS NULL THEN 0 ELSE GB_DQ END))/2)=0 THEN 0 ELSE	   
(CASE WHEN SUM(GB_LZ_Q1) IS NULL THEN 0 ELSE SUM(GB_LZ_Q1) END
       +CASE WHEN SUM(GB_LZ_Q2) IS NULL THEN 0 ELSE SUM(GB_LZ_Q2) END
       +CASE WHEN SUM(GB_LZ_Q3) IS NULL THEN 0 ELSE SUM(GB_LZ_Q3) END
       +CASE WHEN SUM(GB_LZ_Q4) IS NULL THEN 0 ELSE SUM(GB_LZ_Q4) END)/((SUM(CASE WHEN GB_NC IS NULL THEN 0 ELSE GB_NC END)+SUM(CASE WHEN GB_DQ IS NULL THEN 0 ELSE GB_DQ END))/2) END  GBLZV,
--主动常青藤离职
SUM(CQT_LZ_Q1) CQT_LZ_Q1,SUM(CQT_LZ_Q2) CQT_LZ_Q2,SUM(CQT_LZ_Q3) CQT_LZ_Q3,SUM(CQT_LZ_Q4) CQT_LZ_Q4,
SUM((CASE WHEN CQT_LZ_Q1 IS NULL THEN 0 ELSE CQT_LZ_Q1 END)
       +(CASE WHEN CQT_LZ_Q2 IS NULL THEN 0 ELSE CQT_LZ_Q2 END)
       +(CASE WHEN CQT_LZ_Q3 IS NULL THEN 0 ELSE CQT_LZ_Q3 END)
       +(CASE WHEN CQT_LZ_Q4 IS NULL THEN 0 ELSE CQT_LZ_Q4 END)) CQTNDLZ, --常青藤离职人数
CASE WHEN (SUM((CASE WHEN CQT_LZ_Q1 IS NULL THEN 0 ELSE CQT_LZ_Q1 END)
       +(CASE WHEN CQT_LZ_Q2 IS NULL THEN 0 ELSE CQT_LZ_Q2 END)
       +(CASE WHEN CQT_LZ_Q3 IS NULL THEN 0 ELSE CQT_LZ_Q3 END)
       +(CASE WHEN CQT_LZ_Q4 IS NULL THEN 0 ELSE CQT_LZ_Q4 END))+SUM(CASE WHEN CQT_DQ IS NULL THEN 0 ELSE CQT_DQ END)) = 0 THEN 0 ELSE
SUM((CASE WHEN CQT_LZ_Q1 IS NULL THEN 0 ELSE CQT_LZ_Q1 END)
       +(CASE WHEN CQT_LZ_Q2 IS NULL THEN 0 ELSE CQT_LZ_Q2 END)
       +(CASE WHEN CQT_LZ_Q3 IS NULL THEN 0 ELSE CQT_LZ_Q3 END)
       +(CASE WHEN CQT_LZ_Q4 IS NULL THEN 0 ELSE CQT_LZ_Q4 END))/(SUM((CASE WHEN CQT_LZ_Q1 IS NULL THEN 0 ELSE CQT_LZ_Q1 END)
       +(CASE WHEN CQT_LZ_Q2 IS NULL THEN 0 ELSE CQT_LZ_Q2 END)
       +(CASE WHEN CQT_LZ_Q3 IS NULL THEN 0 ELSE CQT_LZ_Q3 END)
       +(CASE WHEN CQT_LZ_Q4 IS NULL THEN 0 ELSE CQT_LZ_Q4 END))+SUM(CASE WHEN CQT_DQ IS NULL THEN 0 ELSE CQT_DQ END)) END CQTLZV,
to_char(to_date('${date_time}','yyyy-mm-dd'),'DDD')/(to_date(substr('${date_time}',0,4),'yyyy') - to_date(substr('${date_time}',0,4)-1,'yyyy') ) ljyhmb --累计年度目标
FROM ODM_HR_YGLZRATE WHERE 1=1 
and create_time =CASE WHEN '${date_time}'=TO_CHAR(sysdate,'YYYY-MM-DD') THEN '${date_time}' 
ELSE TO_CHAR(TO_DATE('${date_time}','YYYY-MM-DD')+1,'YYYY-MM-DD') END
and TREE_NODE2='${dwmc}'
AND TREE_NODE2 NOT LIKE '%F%' AND TREE_NODE2 NOT LIKE '%Z%']]></Query>
</TableData>
<TableData name="LZRATE" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="dwmc"/>
<O>
<![CDATA[]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[HXXF_HR]]></DatabaseName>
</Connection>
<Query>
<![CDATA[SELECT * FROM ODM_HR_LZRATE WHERE TREE_NODE='${dwmc}' and year='2018']]></Query>
</TableData>
<TableData name="HRFWB" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="date_time"/>
<O>
<![CDATA[2018-07-01]]></O>
</Parameter>
<Parameter>
<Attributes name="dwmc"/>
<O>
<![CDATA[HX_HEAD]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[HXXF_HR]]></DatabaseName>
</Connection>
<Query>
<![CDATA[WITH DATE_TRUE AS (

SELECT SUM(CASE
             WHEN CREATE_TIME = '${date_time}' THEN
              ZHUYING
           END) ZHUYING, --主营人数
       SUM(CASE
             WHEN CREATE_TIME = '${date_time}' THEN
              (HRZZG - CQT18)
           END) HRZZG1, --HR人数含17,不含18
       SUM(CASE
             WHEN CREATE_TIME = '${date_time}' THEN
              (HRZZG - CQT17 - CQT18)
           END) HRZZG2, --HR人数不含17,18
       sum(CASE
             WHEN CREATE_TIME = '${date_time}' THEN
              CQT17
           END) CQT17,
       sum(CASE
             WHEN CREATE_TIME = '${date_time}' THEN
              CQT18
           END) CQT18,
       SUM(CASE
             WHEN CREATE_TIME = '${date_time}' THEN
              HRZZG
           END) HRZZG_BEFORE,
       SUM(round(CASE
                   WHEN CREATE_TIME = '${date_time}' THEN
                    CASE
                      WHEN (HRZZG  - CQT18) = 0 THEN
                       0
                      ELSE
                       ZHUYING / (HRZZG  - CQT18)
                    END
                 END)) RJFWGSB1, --HR服务比含17，不含18
      SUM(round(CASE
                   WHEN CREATE_TIME = '${date_time}' THEN
                    CASE
                      WHEN (HRZZG - CQT17 - CQT18) = 0 THEN
                       0
                      ELSE
                       ZHUYING / (HRZZG - CQT17 - CQT18)
                    END
                 END)) RJFWGSB2, --HR服务比不含17，含18               
       SUM((CASE
             WHEN CREATE_TIME = SUBSTR('${date_time}', 0, 4) - 1 || '-12-31' THEN
              round(CASE
                      WHEN (HRZZG - CQT17 - CQT18) = 0 THEN
                       0
                      ELSE
                       ZHUYING / (HRZZG - CQT17 - CQT18)
                    END)
           END)) NCFWB, --年初服务比
       CASE
         WHEN SUM((CASE
                    WHEN CREATE_TIME = SUBSTR('${date_time}', 0, 4) - 1 || '-12-31' THEN
                     round(CASE
                             WHEN (HRZZG - CQT17 - CQT18) = 0 THEN
                              0
                             ELSE
                              ZHUYING / (HRZZG - CQT17 - CQT18)
                           END)
                  END)) = 0 THEN
          0
         ELSE
          SUM((CASE
                      WHEN CREATE_TIME = '${date_time}' THEN
                       CASE
                         WHEN (HRZZG  - CQT18) = 0 THEN
                          0
                         ELSE
                          ZHUYING / (HRZZG  - CQT18)
                       END
                    END)) / SUM((CASE
                                  WHEN CREATE_TIME = SUBSTR('${date_time}', 0, 4) - 1 || '-12-31' THEN
                                   (CASE
                                           WHEN (HRZZG - CQT17 - CQT18) = 0 THEN
                                            0
                                           ELSE
                                            ZHUYING / (HRZZG - CQT17 - CQT18)
                                         END)
                                END)) - 1
       END GSB1, --改善比不含17，含18
       CASE
         WHEN SUM((CASE
                    WHEN CREATE_TIME = SUBSTR('${date_time}', 0, 4) - 1 || '-12-31' THEN
                     round(CASE
                             WHEN (HRZZG - CQT17 - CQT18) = 0 THEN
                              0
                             ELSE
                              ZHUYING / (HRZZG - CQT17 - CQT18)
                           END)
                  END)) = 0 THEN
          0
         ELSE
          SUM((CASE
                      WHEN CREATE_TIME = '${date_time}' THEN
                       CASE
                         WHEN (HRZZG - CQT17 - CQT18) = 0 THEN
                          0
                         ELSE
                          ZHUYING / (HRZZG - CQT17 - CQT18)
                       END
                    END)) / SUM((CASE
                                  WHEN CREATE_TIME = SUBSTR('${date_time}', 0, 4) - 1 || '-12-31' THEN
                                   (CASE
                                           WHEN (HRZZG - CQT17 - CQT18) = 0 THEN
                                            0
                                           ELSE
                                            ZHUYING / (HRZZG - CQT17 - CQT18)
                                         END)
                                END)) - 1
       END GSB2, --改善比不含17,18
to_char(to_date('${date_time}','yyyy-mm-dd'),'DDD')/(to_date(substr('${date_time}',0,4),'yyyy') - to_date(substr('${date_time}',0,4)-1,'yyyy') ) ljyhmb --累计年度目标
  FROM ODM_HR_RJFWGSB T
 WHERE 1 = 1
and TREE_NODE2 = '${dwmc}'
)
SELECT 
ZHUYING,
CASE WHEN 
TO_CHAR(TO_DATE('${date_time}','yyyy-MM-dd'),'MM')>=7 
THEN HRZZG1 ELSE  HRZZG2 END AS HRZZG,
CQT17,
CQT18,
HRZZG_BEFORE,
CASE WHEN 
TO_CHAR(TO_DATE('${date_time}','yyyy-MM-dd'),'MM')>=7 
THEN RJFWGSB1 ELSE  RJFWGSB2 END AS RJFWGSB,
NCFWB,
CASE WHEN 
TO_CHAR(TO_DATE('${date_time}','yyyy-MM-dd'),'MM')>=7 
THEN GSB1 ELSE  GSB2 END AS GSB,
ljyhmb
FROM DATE_TRUE
ORDER BY RJFWGSB DESC
]]></Query>
</TableData>
<TableData name="LZRENSHU" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="date_time"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="dwmc"/>
<O>
<![CDATA[]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[HXXF_HR]]></DatabaseName>
</Connection>
<Query>
<![CDATA[WITH ODM_HR_LZTZ1 AS
 (SELECT YGID,
         ISZHUYING,
         YGFENLEI,
         ISCQT,
         LZLEIXING,
         LZYUANYIN,
         LZDATE,
         TREE_NODE_ID
    FROM ODM_HR_LZTZ T1
  UNION ALL
  SELECT YGID,
         ISZHUYING,
         YGFENLEI,
         ISCQT,
         LZLEIXING,
         LZYUANYIN,
         LZDATE,
         'HX_HEAD,10004100730,1000410073Z0' AS TREE_NODE_ID
    FROM ODM_HR_LZTZ
   WHERE TREE_NODE_ID LIKE '%10004100730%'
     AND SSXULIE = '招商序列'
  UNION ALL
  SELECT YGID,
         ISZHUYING,
         YGFENLEI,
         ISCQT,
         LZLEIXING,
         LZYUANYIN,
         LZDATE,
         'HX_HEAD,10004100730,1000410073F0' AS TREE_NODE_ID
    FROM ODM_HR_LZTZ
   WHERE TREE_NODE_ID LIKE '%10004100730%'
     AND SSXULIE <> '招商序列'
  UNION ALL
  SELECT YGID,
         ISZHUYING,
         YGFENLEI,
         ISCQT,
         LZLEIXING,
         LZYUANYIN,
         LZDATE,
         'HX_HEAD,10041105853,1004110585Z3' AS TREE_NODE_ID
    FROM ODM_HR_LZTZ
   WHERE TREE_NODE_ID LIKE '%10041105853%'
     AND SSXULIE = '招商序列'
  UNION ALL
  SELECT YGID,
         ISZHUYING,
         YGFENLEI,
         ISCQT,
         LZLEIXING,
         LZYUANYIN,
         LZDATE,
         'HX_HEAD,10041105853,1004110585F3' AS TREE_NODE_ID
    FROM ODM_HR_LZTZ
   WHERE TREE_NODE_ID LIKE '%10041105853%'
     AND SSXULIE <> '招商序列')
SELECT (SELECT COUNT(YGID)
          FROM ODM_HR_LZTZ1 T1
         WHERE TO_CHAR(LZDATE, 'YYYY-MM-DD') BETWEEN SUBSTR('${date_time}', 0, 4)||'-01-01' AND
               '${date_time}'
           AND T1.LZLEIXING = '辞职'
           AND (T1.LZYUANYIN <> '调动到其他关联公司' OR LZYUANYIN IS NULL)
           AND ISZHUYING = '主营'
and TREE_NODE_ID LIKE '%${dwmc}%' AND TREE_NODE_ID NOT LIKE '%F%' AND TREE_NODE_ID NOT LIKE '%Z%') ZHUYIGN,
       (SELECT COUNT(YGID)
          FROM ODM_HR_LZTZ1 T1
         WHERE  TO_CHAR(LZDATE, 'YYYY-MM-DD') BETWEEN SUBSTR('${date_time}', 0, 4)||'-01-01' AND '${date_time}'
           AND YGFENLEI LIKE '%干部%'
           and TREE_NODE_ID LIKE '%${dwmc}%' AND TREE_NODE_ID NOT LIKE '%F%' AND TREE_NODE_ID NOT LIKE '%Z%') GANBU,
       (SELECT COUNT(YGID)
          FROM ODM_HR_LZTZ1 T1
         WHERE  TO_CHAR(LZDATE, 'YYYY-MM-DD') BETWEEN SUBSTR('${date_time}', 0, 4)||'-01-01' AND  '${date_time}'
           AND ISCQT = '是'
           and TREE_NODE_ID LIKE '%${dwmc}%' AND TREE_NODE_ID NOT LIKE '%F%' AND TREE_NODE_ID NOT LIKE '%Z%') CQT
  FROM DUAL
]]></Query>
</TableData>
<TableData name="猎头使用优化率" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="date_time"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="DWMC"/>
<O>
<![CDATA[]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[HXXF_HR]]></DatabaseName>
</Connection>
<Query>
<![CDATA[WITH ZPTZ1 AS (
SELECT 
DISTINCT YGID,  
RZDATE,
trunc(months_between(LZDATE,RZDATE),1)  as  nf,
case when to_char(LZDATE,'yyyy-mm-dd') != '1970-01-01' THEN to_char(LZDATE,'yyyy-mm-dd')
 ELSE '-' END as LZDATE,
ISZHUYING, 
RZZHIJI, 
BUMENID,
RZQUDAO，
ISLIZHI, 
TREE_NODE_ID,
DW.TREE_NODE_NUM
FROM 
ODM_HR_RZTZ
LEFT JOIN ODM_HR_DW DW
ON DW.TREE_NODE= BUMENID
where 
RZZHIJI NOT LIKE '99%'
AND TREE_NODE_ID LIKE '%${DWMC}%'
AND RZDATE<=TO_DATE('${date_time}','YYYY-MM-DD')
AND ISZHUYING='主营'
UNION ALL
SELECT 
DISTINCT YGID,  
RZDATE,
trunc(months_between(LZDATE,RZDATE),1)  as  nf,
case when to_char(LZDATE,'yyyy-mm-dd') != '1970-01-01'  THEN to_char(LZDATE,'yyyy-mm-dd')
 ELSE '-' END as LZDATE,
ISZHUYING, 
RZZHIJI, 
BUMENID, 
RZQUDAO，
ISLIZHI, 
TREE_NODE_ID,
DW.TREE_NODE_NUM
FROM 
ODM_HR_RZTZ
LEFT JOIN ODM_HR_DW DW
ON DW.TREE_NODE= BUMENID
where 
RZZHIJI  LIKE '99%'
AND TREE_NODE_ID LIKE '%${DWMC}%'
AND RZDATE<=TO_DATE('${date_time}','YYYY-MM-DD')
AND ISZHUYING='主营'
ORDER BY  TREE_NODE_NUM asc,RZZHIJI DESC,RZDATE asc,YGID asc 
),

ZPTZ3 AS (
SELECT * FROM ZPTZ1 WHERE 
 --${if(date_time =FORMAT(TODAY()-1,'YYYY-MM-DD')," RZDATE < TO_DATE('"+date_time+"','YYYY-MM-DD')","  RZDATE<=TO_DATE('"+date_time+"','YYYY-MM-DD')")}
--RZDATE<TO_DATE('${date_time}','YYYY-MM-DD')
 TO_NUMBER(REPLACE(RZZHIJI,'级',''))> 5 and TO_NUMBER(REPLACE(RZZHIJI,'级',''))<= 18 
 AND SUBSTR(RZZHIJI,0,1)<>' '
)
SELECT COUNT(case
               when RZQUDAO = '猎头' and
                    TO_CHAR(RZDATE, 'YYYY') = substr('${date_time}', 0, 4)  AND ISLIZHI ='在职'  then
                ygid
             END) AS LTS,--猎头本年人数
             COUNT(case
               when TO_CHAR(RZDATE, 'YYYY') = substr('${date_time}', 0, 4) AND ISLIZHI ='在职'  then
                ygid
             END) AS QBS, -- 本年全部人数
             COUNT(case
               when RZQUDAO = '猎头' 
                    and TO_CHAR(RZDATE, 'YYYY-mm') = substr('${date_time}', 0, 7) then
                ygid
             END) AS LTSDY， --猎头当月人数
       COUNT(case
               WHEN TO_CHAR(RZDATE, 'YYYY-mm') = substr('${date_time}', 0, 7) then
                ygid
             END) AS QBSDY, -- 全部当月人数
       CASE WHEN COUNT(case WHEN TO_CHAR(RZDATE, 'YYYY') = substr('${date_time}', 0, 4) then ygid end) = 0 THEN 0 ELSE ROUND 
         ( COUNT(case when RZQUDAO = '猎头' and TO_CHAR(RZDATE, 'YYYY') = substr('${date_time}', 0, 4) AND ISLIZHI ='在职' then ygid END) 
         / COUNT(case when TO_CHAR(RZDATE, 'YYYY') = substr('${date_time}', 0, 4) AND ISLIZHI ='在职' then ygid END),
       3） END AS lv ,--猎头使用率
        COUNT(case
               when RZQUDAO = '猎头' and
                    TO_CHAR(RZDATE, 'YYYY') = substr('${date_time}', 0, 4) - 1 
                 then
                ygid
             END) AS NCLTS, --年初猎头人数
        COUNT(case
               WHEN TO_CHAR(RZDATE, 'YYYY') = substr('${date_time}', 0, 4) - 1 then
                ygid
             end) AS NCQBS, -- 年初全部人数   
              CASE WHEN COUNT(case WHEN TO_CHAR(RZDATE, 'YYYY') = substr('${date_time}', 0, 4) - 1 then ygid end) = 0 THEN 0 ELSE ROUND (
                 COUNT(case when RZQUDAO = '猎头' and TO_CHAR(RZDATE, 'YYYY') = substr('${date_time}', 0, 4) - 1 then ygid END) / 
                 COUNT(case WHEN TO_CHAR(RZDATE, 'YYYY') = substr('${date_time}', 0, 4) - 1 then ygid end),
       3) END AS NClv        
              FROM ZPTZ3]]></Query>
</TableData>
<TableData name="XZFWB" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="date_time"/>
<O>
<![CDATA[2018-07-01]]></O>
</Parameter>
<Parameter>
<Attributes name="dwmc"/>
<O>
<![CDATA[HX_HEAD]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[HXXF_HR]]></DatabaseName>
</Connection>
<Query>
<![CDATA[WITH DATE_TRUE AS (
SELECT SUM(CASE
             WHEN CREATE_TIME = '${date_time}' THEN
              ZHUYING
           END) ZHUYING, --主营人数
       SUM(CASE
             WHEN CREATE_TIME = '${date_time}' THEN
              XZZZG
           END) XZZZG1,
       SUM(CASE
             WHEN CREATE_TIME = '${date_time}' THEN
              XZZZG  - XZCQT18
           END) XZZZG, --HR人数 含 17，不含18
        SUM(CASE
             WHEN CREATE_TIME = '${date_time}' THEN
              XZZZG - XZCQT17 - XZCQT18
           END) XZZZG_before, --HR人数 含 17，不含18
       SUM(round(CASE
                   WHEN CREATE_TIME = '${date_time}' THEN
                    CASE
                      WHEN (XZZZG  - XZCQT18) = 0 THEN
                       0
                      ELSE
                       ZHUYING / (XZZZG  - XZCQT18)
                    END
                 END)) RJFWGSB, --HR服务比含17，不含18
         SUM(round(CASE
                   WHEN CREATE_TIME = '${date_time}' THEN
                    CASE
                      WHEN (XZZZG - XZCQT17  - XZCQT18) = 0 THEN
                       0
                      ELSE
                       ZHUYING / (XZZZG - XZCQT17  - XZCQT18)
                    END
                 END)) RJFWGSB_before, --HR服务比不含17,18
       SUM((CASE
             WHEN CREATE_TIME = SUBSTR('${date_time}', 0, 4) - 1 || '-12-31' THEN
              TRUNC(CASE
                      WHEN (XZZZG - XZCQT17 - XZCQT18) = 0 THEN
                       0
                      ELSE
                       ZHUYING / (XZZZG - XZCQT17 - XZCQT18)
                    END)
           END)) NDFWB, --年初服务比
            CASE
         WHEN SUM((CASE
                    WHEN CREATE_TIME = SUBSTR('${date_time}', 0, 4) - 1 || '-12-31' THEN
                     (CASE
                             WHEN (XZZZG - XZCQT17 - XZCQT18) = 0 THEN
                              0
                             ELSE
                              ZHUYING / (XZZZG - XZCQT17 - XZCQT18)
                           END)
                  END)) = 0 THEN
          0
         ELSE
          SUM((CASE
                      WHEN CREATE_TIME = '${date_time}' THEN
                       CASE
                         WHEN (XZZZG - XZCQT17 - XZCQT18) = 0 THEN
                          0
                         ELSE
                          ZHUYING / (XZZZG - XZCQT17 - XZCQT18)
                       END
                    END)) / SUM((CASE
                                  WHEN CREATE_TIME = SUBSTR('${date_time}', 0, 4) - 1 || '-12-31' THEN
                                   (CASE
                                           WHEN (XZZZG - XZCQT17 - XZCQT18) = 0 THEN
                                            0
                                           ELSE
                                            ZHUYING / (XZZZG - XZCQT17 - XZCQT18)
                                         END)
                                END)) - 1
       END GSB_before, --改善比
       CASE
         WHEN SUM((CASE
                    WHEN CREATE_TIME = SUBSTR('${date_time}', 0, 4) - 1 || '-12-31' THEN
                     (CASE
                             WHEN (XZZZG - XZCQT17 - XZCQT18) = 0 THEN
                              0
                             ELSE
                              ZHUYING / (XZZZG - XZCQT17 - XZCQT18)
                           END)
                  END)) = 0 THEN
          0
         ELSE
          SUM((CASE
                      WHEN CREATE_TIME = '${date_time}' THEN
                       CASE
                         WHEN (XZZZG  - XZCQT18) = 0 THEN
                          0
                         ELSE
                          ZHUYING / (XZZZG  - XZCQT18)
                       END
                    END)) / SUM((CASE
                                  WHEN CREATE_TIME = SUBSTR('${date_time}', 0, 4) - 1 || '-12-31' THEN
                                   (CASE
                                           WHEN (XZZZG - XZCQT17 - XZCQT18) = 0 THEN
                                            0
                                           ELSE
                                            ZHUYING / (XZZZG - XZCQT17 - XZCQT18)
                                         END)
                                END)) - 1
       END GSB --改善比
  FROM ODM_HR_RJFWGSB T
 WHERE 1 = 1
and TREE_NODE2 = '${dwmc}'
)

SELECT 
ZHUYING,
XZZZG1,
CASE WHEN 
TO_CHAR(TO_DATE('${date_time}','yyyy-MM-dd'),'MM')>=7 
THEN XZZZG ELSE  XZZZG_before END AS XZZZG,
CASE WHEN 
TO_CHAR(TO_DATE('${date_time}','yyyy-MM-dd'),'MM')>=7 
THEN RJFWGSB ELSE  RJFWGSB_before END AS RJFWGSB,
NDFWB,
CASE WHEN 
TO_CHAR(TO_DATE('${date_time}','yyyy-MM-dd'),'MM')>=7 
THEN GSB_before ELSE  GSB END AS GSB
FROM DATE_TRUE
ORDER BY RJFWGSB DESC

]]></Query>
</TableData>
<TableData name="干部常青藤年初加季度人数除以2" class="com.fr.data.impl.DBTableData">
<Parameters/>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[HXXF_HR]]></DatabaseName>
</Connection>
<Query>
<![CDATA[SELECT 
       --干部年初数加上三月数/2
       (COUNT(CASE WHEN  YGFENLEI LIKE '%干部%' AND TO_CHAR(DATETIME,'YYYY-MM')='2017-12' THEN YGID END)+
       COUNT(CASE WHEN  YGFENLEI LIKE '%干部%' AND TO_CHAR(DATETIME,'YYYY-MM')='2018-03' THEN YGID END))/2 GBQ1,
       --干部年初数加上六月数/2
       (COUNT(CASE WHEN  YGFENLEI LIKE '%干部%' AND TO_CHAR(DATETIME,'YYYY-MM')='2017-12' THEN YGID END)+
       COUNT(CASE WHEN  YGFENLEI LIKE '%干部%' AND TO_CHAR(DATETIME,'YYYY-MM')='2018-06' THEN YGID END))/2 GBQ2,
       --干部年初数加上九月数/2
       (COUNT(CASE WHEN  YGFENLEI LIKE '%干部%' AND TO_CHAR(DATETIME,'YYYY-MM')='2017-12' THEN YGID END)+
       COUNT(CASE WHEN  YGFENLEI LIKE '%干部%' AND TO_CHAR(DATETIME,'YYYY-MM')='2018-09' THEN YGID END))/2 GBQ3,
       --干部年初数加上12月数/2
       (COUNT(CASE WHEN  YGFENLEI LIKE '%干部%' AND TO_CHAR(DATETIME,'YYYY-MM')='2017-12' THEN YGID END)+
       COUNT(CASE WHEN  YGFENLEI LIKE '%干部%' AND TO_CHAR(DATETIME,'YYYY-MM')='2018-12' THEN YGID END))/2 GBQ4,
       --常青藤年初数加上3月数/2
       (COUNT(CASE WHEN  ISCQT ='是' AND TO_CHAR(DATETIME,'YYYY-MM')='2017-12' THEN YGID END)+
       COUNT(CASE WHEN  ISCQT ='是' AND TO_CHAR(DATETIME,'YYYY-MM')='2018-03' THEN YGID END))/2 CQTQ1,
       --常青藤年初数加上6月数/2
       (COUNT(CASE WHEN  ISCQT ='是' AND TO_CHAR(DATETIME,'YYYY-MM')='2017-12' THEN YGID END)+
       COUNT(CASE WHEN  ISCQT ='是' AND TO_CHAR(DATETIME,'YYYY-MM')='2018-06' THEN YGID END))/2 CQTQ2,
       --常青藤年初数加上9月数/2
       (COUNT(CASE WHEN  ISCQT ='是' AND TO_CHAR(DATETIME,'YYYY-MM')='2017-12' THEN YGID END)+
       COUNT(CASE WHEN  ISCQT ='是' AND TO_CHAR(DATETIME,'YYYY-MM')='2018-09' THEN YGID END))/2 CQTQ3,
       --常青藤年初数加上12月数/2
       (COUNT(CASE WHEN  ISCQT ='是' AND TO_CHAR(DATETIME,'YYYY-MM')='2017-12' THEN YGID END)+
       COUNT(CASE WHEN  ISCQT ='是' AND TO_CHAR(DATETIME,'YYYY-MM')='2018-12' THEN YGID END))/2  CQTQ4
 FROM ODM_HR_YGTZ_HIST 
 WHERE TREE_NODE_ID like '%'||'${dwmc}'||'%']]></Query>
</TableData>
<TableData name="猎头费用" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="date_time"/>
<O>
<![CDATA[2018-05-31]]></O>
</Parameter>
<Parameter>
<Attributes name="DWMC"/>
<O>
<![CDATA[HX_HEAD]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[HXXF_HR]]></DatabaseName>
</Connection>
<Query>
<![CDATA[SELECT * FROM 
(
WITH ODM_HR_TREE AS (
SELECT T3.TREE_NODE ,--父node
         T3.DESCR, --组织名称
         T3.TREE_NODE2    , --子node
         T3.DESCR2         ,--名称
         T3.TREE_NODE_NUM,--排序
         T3.PARENT_NODES,--部门
         T3.PARENT_NAME--部门名称
FROM (
    SELECT T1.TREE_NODE,
         T1.DESCR,
         T2.TREE_NODE     AS TREE_NODE2,
         T2.DESCR         AS DESCR2,
         T2.TREE_NODE_NUM,
         T2.PARENT_NODES,
         T2.PARENT_NAME
    FROM ODM_HR_DW T1, ODM_HR_DW T2
   WHERE T2.PARENT_NODE = T1.TREE_NODE
   AND T1.TREE_NODE IN('10001100001','100000','10041105853','10003100439') AND T2.TREE_NODE<>'10001100076'
   UNION ALL
   SELECT TREE_NODE,DESCR,TREE_NODE AS TREE_NODE2,DESCR AS DESCR2,TREE_NODE_NUM,PARENT_NODES,PARENT_NAME
    FROM ODM_HR_DW  WHERE PARENT_NODE ='HX_HEAD'
   UNION ALL
   SELECT '10001100001' AS TREE_NODE,'股份总部' AS DESCR,TREE_NODE AS TREE_NODE2,'人力资源中心-'||DESCR AS DESCR2,TREE_NODE_NUM,PARENT_NODES,PARENT_NAME
   FROM ODM_HR_DW WHERE PARENT_NODE='10001100076'
   UNION ALL
   SELECT 'HX_HEAD' AS TREE_NODE,'华夏幸福' AS DESCR,'HX_HEAD' AS TREE_NODE2,'总计（全公司）' AS DESCR2,
   1 AS TREE_NODE_NUM,'HX_HEAD' AS PARENT_NODES,'华夏幸福' AS PARENT_NAME
   FROM dual
   )T3  ORDER BY TREE_NODE_NUM),
 -- 2018/02-01 取数逻辑
   ODM_HR_ZPTZ1 AS (
   SELECT * FROM 
        (select (case when t2.feiyong is null then '0' else t2.feiyong end) feiyong,t2.ZHIJI,T2.LEIXING, t1.*
  from (select t.ZHIJILY,
               t.BUMEN,            
               t.TREE_NODE_ID,  
               t.LTFY,
               t.ygid,
               t.Rzdate,
               t.zpqudao,
               t.lthzlevel,
               t.zhijily as zj,
               (case when t.lthzlevel='储备' then '普通'
     when  t.lthzlevel='试签约' then '普通'  else t.lthzlevel end) lthzlevel1
          from odm_hr_zptz t
         where t.zpqudao = '猎头'
           and to_number(substr(t.zhijily, 1, 2)) > 0
           AND FCOFFERDATE<=TO_DATE('2018/02-01','YYYY/MM/DD')) t1
  left join HR_LTQYJBDYFLB_OLD t2
    on t1.LTHZLEVEL1 = t2.leixing
   and t1.zj = t2.zhiji)
   WHERE zpqudao='猎头'
   AND TO_NUMBER(SUBSTR(ZHIJILY,1,2))> 0
   ) 
   
   
SELECT   /* T1.TREE_NODE ,--父node
          T1.DESCR, --组织名称
          T1.TREE_NODE2    , --子node
          T1.DESCR2        ,--名称
          T1.TREE_NODE_NUM,--排序*/
--猎头费用
SUM ( case when TO_CHAR(T2.RZDATE,'YYYY') = substr('${date_time}',0,4) then FEIYONG END) AS LTFY,
COUNT ( case when TO_CHAR(T2.RZDATE,'YYYY') = substr('${date_time}',0,4) then ygid END) AS LTZPRS,   
SUM ( case when TO_CHAR(T2.RZDATE,'YYYY') = substr('${date_time}',0,4) then FEIYONG END)/ 
COUNT ( case when TO_CHAR(T2.RZDATE,'YYYY') = substr('${date_time}',0,4) then ygid END)
AVGFY  
           FROM  ODM_HR_TREE T1 LEFT JOIN ODM_HR_ZPTZ1 T2  
    ON   T2.TREE_NODE_ID LIKE '%'||T1.TREE_NODE2||'%'
     WHERE 1=1
     AND TO_CHAR(T2.RZDATE,'YYYY-MM-DD')<='${date_time}'
    ${IF(DWMC = 'HX_HEAD',
            " and TREE_NODE2 in (SELECT TREE_NODE FROM ODM_HR_DW WHERE PARENT_NODE ='HX_HEAD')",
            " and TREE_NODE2 <> TREE_NODE and parent_nodes like '%" + DWMC + "%'") } 
    
)
UNION ALL
SELECT * FROM 
(
WITH ODM_HR_TREE AS (
SELECT T3.TREE_NODE ,--父node
         T3.DESCR, --组织名称
         T3.TREE_NODE2    , --子node
         T3.DESCR2         ,--名称
         T3.TREE_NODE_NUM,--排序
         T3.PARENT_NODES,--部门
         T3.PARENT_NAME--部门名称
FROM (
    SELECT T1.TREE_NODE,
         T1.DESCR,
         T2.TREE_NODE     AS TREE_NODE2,
         T2.DESCR         AS DESCR2,
         T2.TREE_NODE_NUM,
         T2.PARENT_NODES,
         T2.PARENT_NAME
    FROM ODM_HR_DW T1, ODM_HR_DW T2
   WHERE T2.PARENT_NODE = T1.TREE_NODE
   AND T1.TREE_NODE IN('10001100001','100000','10041105853','10003100439') AND T2.TREE_NODE<>'10001100076'
   UNION ALL
   SELECT TREE_NODE,DESCR,TREE_NODE AS TREE_NODE2,DESCR AS DESCR2,TREE_NODE_NUM,PARENT_NODES,PARENT_NAME
    FROM ODM_HR_DW  WHERE PARENT_NODE ='HX_HEAD'
   UNION ALL
   SELECT '10001100001' AS TREE_NODE,'股份总部' AS DESCR,TREE_NODE AS TREE_NODE2,'人力资源中心-'||DESCR AS DESCR2,TREE_NODE_NUM,PARENT_NODES,PARENT_NAME
   FROM ODM_HR_DW WHERE PARENT_NODE='10001100076'
   UNION ALL
   SELECT 'HX_HEAD' AS TREE_NODE,'华夏幸福' AS DESCR,'HX_HEAD' AS TREE_NODE2,'总计（全公司）' AS DESCR2,
   1 AS TREE_NODE_NUM,'HX_HEAD' AS PARENT_NODES,'华夏幸福' AS PARENT_NAME
   FROM dual
   )T3  ORDER BY TREE_NODE_NUM),
   ODM_HR_ZPTZ1 AS (
   SELECT * FROM 
        (select (case when t2.feiyong is null then '0' else t2.feiyong end) feiyong,t2.ZHIJI,T2.LEIXING, t1.*
  from (select t.ZHIJILY,
               t.BUMEN,            
               t.TREE_NODE_ID,  
               t.LTFY,
               t.ygid,
               t.Rzdate,
               t.zpqudao,
               t.lthzlevel,
               t.zhijily as zj,
               (case when t.lthzlevel='储备' then '普通'
     when  t.lthzlevel='试签约' then '普通'  else t.lthzlevel end) lthzlevel1
          from odm_hr_zptz t
         where t.zpqudao = '猎头'
           and to_number(substr(t.zhijily, 1, 2)) > 0
           AND FCOFFERDATE>TO_DATE('2018/02-01','YYYY/MM/DD')) t1
  left join HR_LTQYJBDYFLB t2
    on t1.LTHZLEVEL1 = t2.leixing
   and t1.zj = t2.zhiji)
   WHERE zpqudao='猎头'
   AND TO_NUMBER(SUBSTR(ZHIJILY,1,2))> 0
   ) 
   
   
SELECT   /* T1.TREE_NODE ,--父node
          T1.DESCR, --组织名称
          T1.TREE_NODE2    , --子node
          T1.DESCR2        ,--名称
          T1.TREE_NODE_NUM,--排序*/
--猎头费用
SUM ( case when TO_CHAR(T2.RZDATE,'YYYY') = substr('${date_time}',0,4) then FEIYONG END) AS LTFY,
COUNT ( case when TO_CHAR(T2.RZDATE,'YYYY') = substr('${date_time}',0,4) then ygid END) AS LTZPRS,   
SUM ( case when TO_CHAR(T2.RZDATE,'YYYY') = substr('${date_time}',0,4) then FEIYONG END)/ 
COUNT ( case when TO_CHAR(T2.RZDATE,'YYYY') = substr('${date_time}',0,4) then ygid END)
AVGFY  
           FROM  ODM_HR_TREE T1 LEFT JOIN ODM_HR_ZPTZ1 T2  
    ON   T2.TREE_NODE_ID LIKE '%'||T1.TREE_NODE2||'%'
     WHERE 1=1
     AND TO_CHAR(T2.RZDATE,'YYYY-MM-DD')<='${date_time}'
    ${IF(DWMC = 'HX_HEAD',
            " and TREE_NODE2 in (SELECT TREE_NODE FROM ODM_HR_DW WHERE PARENT_NODE ='HX_HEAD')",
            " and TREE_NODE2 <> TREE_NODE and parent_nodes like '%" + DWMC + "%'") } )]]></Query>
</TableData>
<TableData name="用工监控1" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="date_time"/>
<O>
<![CDATA[2018-06-07]]></O>
</Parameter>
<Parameter>
<Attributes name="DWMC"/>
<O>
<![CDATA[10001100001]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[HXXF_HR]]></DatabaseName>
</Connection>
<Query>
<![CDATA[with TT AS (
--当前业务数据
select 
TO_CHAR(SYSDATE,'YYYY-MM-DD') as  create_time,
count(*) zrs,--总人数
count (case when iszhuying='主营' then ygid end) zyrs,--主营人数
count (case when iszhuying='主营' and bumen not like '%财务管理中心%' then ygid end) zyrsbhcz,--主营人数不含财
count (case when iszhuying <>'主营' then ygid end) fzyrs,--非主营人数
count (case when ygfenlei like '干部' then ygid end) gbyrs,--干部人数
count (case when iscqt = '是' and YGLEIBIE='正式员工'  and iszhuying='主营' then ygid end) cqtyrs,--常青藤人数
count (case when iscqt = '是' and YGLEIBIE= '实习生' then ygid end) cqtsxs--常青藤实习生
 from odm_hr_ygtz t1 left join odm_hr_dw  t2 ON 
 t1.tree_node_id like '%' || t2.tree_node || '%' 
 WHERE 1=1
 ${if(len(DWMC)=0," AND   PARENT_NODE ='HX_HEAD' ","AND  PARENT_NODE ='"+DWMC+"'" )}--参数 
 UNION ALL
 select 
 TO_CHAR(SYSDATE,'YYYY-MM-DD') as  create_time,
 count(*) zrs,--总人数
count (case when iszhuying='主营' then ygid end) zyrs,--主营人数
count (case when iszhuying='主营' and bumen not like '%财务管理中心%' then ygid end) zyrsbhcz,--主营人数不含财
count (case when iszhuying <>'主营' then ygid end) fzyrs,--非主营人数
count (case when ygfenlei like '干部' then ygid end) gbyrs,--干部人数
count (case when iscqt = '是' and YGLEIBIE='正式员工' and iszhuying='主营' then ygid end) cqtyrs,--常青藤人数
count (case when iscqt = '是' and YGLEIBIE= '实习生' then ygid end) cqtsxs--常青藤实习生
 from odm_hr_ygtz t1 left join odm_hr_dw  t2 ON 
 t1.tree_node_id like '%' || t2.tree_node || '%' 
 WHERE 1=1
 ${if(len(DWMC)=0," AND   PARENT_NODE ='HX_HEAD' ","AND  BUMENID ='"+DWMC+"'" )}--参数
 and bumenid = t2.tree_node
 
 --历史业务数据
 UNION ALL 
 select 
'${date_time}' as  create_time,
count(*) zrs,--总人数
count (case when iszhuying='主营' then ygid end) zyrs,--主营人数
count (case when iszhuying='主营' and bumen not like '%财务管理中心%' then ygid end) zyrsbhcz,--主营人数不含财
count (case when iszhuying <>'主营' then ygid end) fzyrs,--非主营人数
count (case when ygfenlei like '干部' then ygid end) gbyrs,--干部人数
count (case when iscqt = '是' and YGLEIBIE='正式员工'  and iszhuying='主营' then ygid end) cqtyrs,--常青藤人数
count (case when iscqt = '是' and YGLEIBIE= '实习生' then ygid end) cqtsxs--常青藤实习生
 from odm_hr_ygtz_hist t1 left join odm_hr_dw  t2 ON 
 t1.tree_node_id like '%' || t2.tree_node || '%' 
 WHERE 1=1
 ${if(len(DWMC)=0," AND   PARENT_NODE ='HX_HEAD' ","AND  PARENT_NODE ='"+DWMC+"'" )}--参数 
 AND TO_CHAR(DATETIME,'YYYY-mm-dd')='${date_time}'
 UNION ALL
 select 
'${date_time}' as  create_time,
 count(*) zrs,--总人数
count (case when iszhuying='主营' then ygid end) zyrs,--主营人数
count (case when iszhuying='主营' and bumen not like '%财务管理中心%' then ygid end) zyrsbhcz,--主营人数不含财
count (case when iszhuying <>'主营' then ygid end) fzyrs,--非主营人数
count (case when ygfenlei like '干部' then ygid end) gbyrs,--干部人数
count (case when iscqt = '是' and YGLEIBIE='正式员工' and iszhuying='主营' then ygid end) cqtyrs,--常青藤人数
count (case when iscqt = '是' and YGLEIBIE= '实习生' then ygid end) cqtsxs--常青藤实习生
 from odm_hr_ygtz_hist t1 left join odm_hr_dw  t2 ON 
 t1.tree_node_id like '%' || t2.tree_node || '%' 
 WHERE 1=1
 ${if(len(DWMC)=0," AND   PARENT_NODE ='HX_HEAD' ","AND  BUMENID ='"+DWMC+"'" )}--参数
 AND TO_CHAR(DATETIME,'YYYY-mm-dd')='${date_time}'
 and bumenid = t2.tree_node)
 
 SELECT * FROM  TT WHERE create_time='${date_time}']]></Query>
</TableData>
<TableData name="用工监控2" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="date_time"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="DWMC"/>
<O>
<![CDATA[]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[HXXF_HR]]></DatabaseName>
</Connection>
<Query>
<![CDATA[select count(*) zrs,--总人数
count (case when iszhuying='主营' then ygid end) zyrs,--主营人数
count (case when iszhuying='主营' AND TREE_NODE_ID NOT LIKE '%10001100063%' and bumen not like '%财务管理中心%' then ygid end) zyrsbhcz,--主营人数不含财
count (case when iszhuying='主营' then ygid end) -
count (case when iszhuying='主营' and iscqt='是' and cqtcdlyear in ('2017','2018') then ygid end)        zybhyqybrs,--主营（不含17/18常青藤）
count (case when iszhuying <> '主营' then ygid end) fzyrs,--非主营人数
count (case when ygfenlei like '干部' then ygid end) gbyrs,--干部人数
count (case when iscqt = '是' and YGLEIBIE='正式员工'  and iszhuying='主营' then ygid end) cqtyrs,--常青藤人数
count (case when iscqt = '是' and YGLEIBIE= '实习生' then ygid end) cqtsxs--常青藤实习生
 from odm_hr_ygtz_hist t1 left join odm_hr_dw  t2 ON 
 t1.tree_node_id like '%' || t2.tree_node || '%' 
 WHERE 1=1
 and to_char(datetime,'yyyy-mm')= SUBSTR('${date_time}',0,4)-1||'-12'
 ${if(len(DWMC)=0," AND   PARENT_NODE ='HX_HEAD' ","AND  TREE_NODE ='"+DWMC+"'" )}--参数 
 UNION ALL
 select count(*) zrs,--总人数
count (case when iszhuying='主营' then ygid end) zyrs,--主营人数
count (case when iszhuying='主营' AND TREE_NODE_ID NOT LIKE '%10001100063%' and bumen not like '%财务管理中心%' then ygid end) zyrsbhcz,--主营人数不含财
count (case when iszhuying='主营' then ygid end) -
count (case when iszhuying='主营' and iscqt='是' and cqtcdlyear in ('2017','2018') then ygid end)        zybhyqybrs,--主营（不含17/18常青藤）
count (case when iszhuying <> '主营' then ygid end) fzyrs,--非主营人数
count (case when ygfenlei like '干部' then ygid end) gbyrs,--干部人数
count (case when iscqt = '是' and YGLEIBIE='正式员工'  and iszhuying='主营' then ygid end) cqtyrs,--常青藤人数
count (case when iscqt = '是' and YGLEIBIE= '实习生' then ygid end) cqtsxs--常青藤实习生
 from odm_hr_ygtz_hist t1 left join odm_hr_dw  t2 ON 
 t1.tree_node_id like '%' || t2.tree_node || '%' 
 WHERE 1=1
  and to_char(datetime,'yyyy-mm')= SUBSTR('${date_time}',0,4)-1||'-12'
 ${if(len(DWMC)=0," AND   PARENT_NODE ='HX_HEAD' ","AND  BUMENID ='"+DWMC+"'" )}--参数
 and bumenid = t2.tree_node]]></Query>
</TableData>
<TableData name="月份" class="com.fr.data.impl.DBTableData">
<Parameters/>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[HXXF_HR]]></DatabaseName>
</Connection>
<Query>
<![CDATA[SELECT YF,
       SJZ,
       CASE WHEN NEW = TO_CHAR(SYSDATE,'YYYY-MM') THEN TO_CHAR(SYSDATE,'YYYY-MM-DD') ELSE TO_CHAR(LAST_DAY(TO_DATE(NEW,'YYYY-MM')),'YYYY-MM-DD') END SJ
  FROM ( 
        SELECT TO_CHAR(SYSDATE,'YYYY')||'年'||TRIM(TO_CHAR(ROWNUM,'00'))||'月' YF,
       ROWNUM SJZ,
       TO_CHAR(SYSDATE,'YYYY')||'-'||TRIM(TO_CHAR(ROWNUM,'00')) NEW
FROM DUAL CONNECT BY ROWNUM <= 12
        )
 WHERE YF NOT IN ('2018年01月','2018年02月','2018年03月','2018年03月','2018年04月') 
   AND SJZ <= TO_CHAR(SYSDATE,'MM')]]></Query>
</TableData>
<TableData name="昨日猎头费用" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="date_time"/>
<O>
<![CDATA[2018-05-31]]></O>
</Parameter>
<Parameter>
<Attributes name="DWMC"/>
<O>
<![CDATA[HX_HEAD]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[HXXF_HR]]></DatabaseName>
</Connection>
<Query>
<![CDATA[
WITH ODM_HR_TREE AS (
SELECT T3.TREE_NODE ,--父node
         T3.DESCR, --组织名称
         T3.TREE_NODE2    , --子node
         T3.DESCR2         ,--名称
         T3.TREE_NODE_NUM,--排序
         T3.PARENT_NODES,--部门
         T3.PARENT_NAME--部门名称
FROM (
    SELECT T1.TREE_NODE,
         T1.DESCR,
         T2.TREE_NODE     AS TREE_NODE2,
         T2.DESCR         AS DESCR2,
         T2.TREE_NODE_NUM,
         T2.PARENT_NODES,
         T2.PARENT_NAME
    FROM ODM_HR_DW T1, ODM_HR_DW T2
   WHERE T2.PARENT_NODE = T1.TREE_NODE
   AND T1.TREE_NODE IN('10001100001','100000','10041105853','10003100439') AND T2.TREE_NODE<>'10001100076'
   UNION ALL
   SELECT TREE_NODE,DESCR,TREE_NODE AS TREE_NODE2,DESCR AS DESCR2,TREE_NODE_NUM,PARENT_NODES,PARENT_NAME
    FROM ODM_HR_DW  WHERE PARENT_NODE ='HX_HEAD'
   UNION ALL
   SELECT '10001100001' AS TREE_NODE,'股份总部' AS DESCR,TREE_NODE AS TREE_NODE2,'人力资源中心-'||DESCR AS DESCR2,TREE_NODE_NUM,PARENT_NODES,PARENT_NAME
   FROM ODM_HR_DW WHERE PARENT_NODE='10001100076'
   UNION ALL
   SELECT 'HX_HEAD' AS TREE_NODE,'华夏幸福' AS DESCR,'HX_HEAD' AS TREE_NODE2,'总计（全公司）' AS DESCR2,
   1 AS TREE_NODE_NUM,'HX_HEAD' AS PARENT_NODES,'华夏幸福' AS PARENT_NAME
   FROM dual
   )T3  ORDER BY TREE_NODE_NUM),
   ODM_HR_ZPTZ1 AS (
   SELECT * FROM 
        (select (case when t2.feiyong is null then '0' else t2.feiyong end) feiyong,t2.ZHIJI,T2.LEIXING, t1.*
  from (select t.ZHIJILY,
               t.BUMEN,            
               t.TREE_NODE_ID,  
               t.LTFY,
               t.ygid,
               t.Rzdate,
               t.zpqudao,
               t.lthzlevel,
               t.zhijily as zj,
               (case when t.lthzlevel='储备' then '普通'
     when  t.lthzlevel='试签约' then '普通'  else t.lthzlevel end) lthzlevel1
          from odm_hr_zptz t
         where t.zpqudao = '猎头'
           and to_number(substr(t.zhijily, 1, 2)) > 0
           AND FCOFFERDATE>TO_DATE('2018/02-01','YYYY/MM/DD')) t1
  left join HR_LTQYJBDYFLB t2
    on t1.LTHZLEVEL1 = t2.leixing
   and t1.zj = t2.zhiji)
   WHERE zpqudao='猎头'
   AND TO_NUMBER(SUBSTR(ZHIJILY,1,2))> 0
   ) 
   
   
SELECT   /* T1.TREE_NODE ,--父node
          T1.DESCR, --组织名称
          T1.TREE_NODE2    , --子node
          T1.DESCR2        ,--名称
          T1.TREE_NODE_NUM,--排序*/
--猎头费用
SUM ( case when TO_CHAR(T2.RZDATE,'YYYY-MM-DD') = TO_CHAR(TO_DATE('${date_time}','YYYY-MM-DD')-1,'YYYY-MM-DD') then FEIYONG END) AS LTFY,
COUNT ( case when TO_CHAR(T2.RZDATE,'YYYY-MM-DD') = TO_CHAR(TO_DATE('${date_time}','YYYY-MM-DD')-1,'YYYY-MM-DD') then ygid END) AS LTZPRS,   
SUM ( case when TO_CHAR(T2.RZDATE,'YYYY-MM-DD') = TO_CHAR(TO_DATE('${date_time}','YYYY-MM-DD')-1,'YYYY-MM-DD') then FEIYONG END)/ 
COUNT ( case when TO_CHAR(T2.RZDATE,'YYYY-MM-DD') = TO_CHAR(TO_DATE('${date_time}','YYYY-MM-DD')-1,'YYYY-MM-DD') then ygid END)
AVGFY  
           FROM  ODM_HR_TREE T1 LEFT JOIN ODM_HR_ZPTZ1 T2  
    ON   T2.TREE_NODE_ID LIKE '%'||T1.TREE_NODE2||'%'
     WHERE TO_CHAR(T2.RZDATE,'YYYY-MM-DD')=to_char(TO_DATE('${date_time}','yyyy-mm-dd')-1,'yyyy-mm-dd')
    ${IF(DWMC = 'HX_HEAD',
            " and TREE_NODE2 in (SELECT TREE_NODE FROM ODM_HR_DW WHERE PARENT_NODE ='HX_HEAD')",
            " and TREE_NODE2 <> TREE_NODE and parent_nodes like '%" + DWMC + "%'") } ]]></Query>
</TableData>
<TableData name="ds1" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="date_time"/>
<O>
<![CDATA[2018-01-01]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[HXXF_HR]]></DatabaseName>
</Connection>
<Query>
<![CDATA[select substr(to_char(to_date('${date_time}','yyyy-mm-dd')-1,'yyyy-mm-dd'),0,4) from dual]]></Query>
</TableData>
<TableData name="猎头费用（HOPE）" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="date_time"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="dwmc"/>
<O>
<![CDATA[]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[HXXF_HR]]></DatabaseName>
</Connection>
<Query>
<![CDATA[

WITH ODM_HR_TREE AS (
SELECT T3.TREE_NODE ,--父node
         T3.DESCR, --组织名称
         T3.TREE_NODE2    , --子node
         T3.DESCR2         ,--名称
         T3.TREE_NODE_NUM,--排序
         T3.PARENT_NODES,--部门
         T3.PARENT_NAME--部门名称
FROM (
    SELECT T1.TREE_NODE,
         T1.DESCR,
         T2.TREE_NODE     AS TREE_NODE2,
         T2.DESCR         AS DESCR2,
         T2.TREE_NODE_NUM,
         T2.PARENT_NODES,
         T2.PARENT_NAME
    FROM ODM_HR_DW T1, ODM_HR_DW T2
   WHERE T2.PARENT_NODE = T1.TREE_NODE
   AND T1.TREE_NODE IN('10001100001','100000','10041105853','10003100439') AND T2.TREE_NODE<>'10001100076'
   UNION ALL
   SELECT TREE_NODE,DESCR,TREE_NODE AS TREE_NODE2,DESCR AS DESCR2,TREE_NODE_NUM,PARENT_NODES,PARENT_NAME
    FROM ODM_HR_DW  WHERE PARENT_NODE ='HX_HEAD'
   UNION ALL
   SELECT '10001100001' AS TREE_NODE,'股份总部' AS DESCR,TREE_NODE AS TREE_NODE2,'人力资源中心-'||DESCR AS DESCR2,TREE_NODE_NUM,PARENT_NODES,PARENT_NAME
   FROM ODM_HR_DW WHERE PARENT_NODE='10001100076'
   UNION ALL
   SELECT 'HX_HEAD' AS TREE_NODE,'华夏幸福' AS DESCR,'HX_HEAD' AS TREE_NODE2,'总计（全公司）' AS DESCR2,
   1 AS TREE_NODE_NUM,'HX_HEAD' AS PARENT_NODES,'华夏幸福' AS PARENT_NAME
   FROM dual
   )T3  ORDER BY TREE_NODE_NUM),
   ODM_HR_ZPTZ1 AS (
   SELECT * FROM ODM_HR_ZPTZ WHERE zpqudao='猎头'
   AND TO_NUMBER(SUBSTR(ZHIJILY,1,2))> 0
   ) 
   
   
SELECT   /* T1.TREE_NODE ,--父node
          T1.DESCR, --组织名称
          T1.TREE_NODE2    , --子node
          T1.DESCR2        ,--名称
          T1.TREE_NODE_NUM,--排序*/
--猎头费用1-12月
SUM ( case when TO_CHAR(T2.RZDATE,'YYYY') = substr('${date_time}',0,4) then ltfy END) AS LTfy, --猎头费用
count(case when TO_CHAR(T2.RZDATE,'YYYY') = substr('${date_time}',0,4) then ygid END) as LTZPRS--猎头招聘人数       
           FROM  ODM_HR_TREE T1 LEFT JOIN ODM_HR_ZPTZ1 T2  
    ON   T2.TREE_NODE_ID LIKE '%'||T1.TREE_NODE2||'%'
     WHERE TO_CHAR(T2.RZDATE,'YYYY-MM-DD')<='${date_time}'
      --and TREE_NODE2 ='${dwmc}'
  ${IF(dwmc = 'HX_HEAD',
            " and TREE_NODE2 in (SELECT TREE_NODE FROM ODM_HR_DW WHERE PARENT_NODE ='HX_HEAD')",
            " and TREE_NODE2 <> TREE_NODE and parent_nodes like '%" + dwmc + "%'") }
    
   /* GROUP BY TREE_NODE, DESCR,TREE_NODE2,TREE_NODE_NUM,DESCR2
    order by  TREE_NODE_NUM */]]></Query>
</TableData>
<TableData name="ds2" class="com.fr.data.impl.DBTableData">
<Parameters/>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[HXXF_HR]]></DatabaseName>
</Connection>
<Query>
<![CDATA[select * from odm_hr_zptz where zpqudao='猎头' AND TO_NUMBER(SUBSTR(ZHIJILY,1,2))> 5 and TO_CHAR(RZDATE,'YYYY')=substr('2018',0,4) and tree_node_id like '%10004100730%']]></Query>
</TableData>
<TableData name="ds3" class="com.fr.data.impl.DBTableData">
<Parameters/>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[HXXF_HR]]></DatabaseName>
</Connection>
<Query>
<![CDATA[SELECT T3.TREE_NODE ,--父node
         T3.DESCR, --组织名称
         T3.TREE_NODE2    , --子node
         T3.DESCR2         ,--名称
         T3.TREE_NODE_NUM,--排序
         T3.PARENT_NODES,--部门
         T3.PARENT_NAME--部门名称
FROM (
    SELECT T1.TREE_NODE,
         T1.DESCR,
         T2.TREE_NODE     AS TREE_NODE2,
         T2.DESCR         AS DESCR2,
         T2.TREE_NODE_NUM,
         T2.PARENT_NODES,
         T2.PARENT_NAME
    FROM ODM_HR_DW T1, ODM_HR_DW T2
   WHERE T2.PARENT_NODE = T1.TREE_NODE
   AND T1.TREE_NODE IN('10001100001','100000','10041105853','10003100439') AND T2.TREE_NODE<>'10001100076'
   UNION ALL
   SELECT TREE_NODE,DESCR,TREE_NODE AS TREE_NODE2,DESCR AS DESCR2,TREE_NODE_NUM,PARENT_NODES,PARENT_NAME
    FROM ODM_HR_DW  WHERE PARENT_NODE ='HX_HEAD'
   UNION ALL
   SELECT '10001100001' AS TREE_NODE,'股份总部' AS DESCR,TREE_NODE AS TREE_NODE2,'人力资源中心-'||DESCR AS DESCR2,TREE_NODE_NUM,PARENT_NODES,PARENT_NAME
   FROM ODM_HR_DW WHERE PARENT_NODE='10001100076'
   UNION ALL
   SELECT 'HX_HEAD' AS TREE_NODE,'华夏幸福' AS DESCR,'HX_HEAD' AS TREE_NODE2,'总计（全公司）' AS DESCR2,
   1 AS TREE_NODE_NUM,'HX_HEAD' AS PARENT_NODES,'华夏幸福' AS PARENT_NAME
   FROM dual
   )T3  ORDER BY TREE_NODE_NUM]]></Query>
</TableData>
<TableData name="常青藤季底在职人数" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="date_time"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="dwmc"/>
<O>
<![CDATA[]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[HXXF_HR]]></DatabaseName>
</Connection>
<Query>
<![CDATA[SELECT
sum(case when TO_CHAR(DATETIME,'YYYY-MM-dd') BETWEEN substr('${date_time}',0,4)||'-03-01' AND substr('${date_time}',0,4)||'-03-31' then COUNT(ygid) END)  as Q1,
sum(case when TO_CHAR(DATETIME,'YYYY-MM-dd') BETWEEN substr('${date_time}',0,4)||'-06-01' AND substr('${date_time}',0,4)||'-06-31' then COUNT(ygid) END)  as Q2,
sum(case when TO_CHAR(DATETIME,'YYYY-MM-dd') BETWEEN substr('${date_time}',0,4)||'-09-01' AND substr('${date_time}',0,4)||'-09-31' then COUNT(ygid) END)  as Q3
FROM ODM_HR_YGTZ_HIST WHERE ISCQT='是'
 AND ISZHUYING='主营'
 and TREE_NODE_ID like '%'||'${dwmc}'||'%'
GROUP BY DATETIME]]></Query>
</TableData>
<TableData name="猎头费用(NEW)" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="date_time"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="DWMC"/>
<O>
<![CDATA[]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[HXXF_HR]]></DatabaseName>
</Connection>
<Query>
<![CDATA[--关联入职台账取入职职级
with zptz1 as
 (select distinct t1.ygid,
         t1.ygzt,
         t2.rzzhiji,
         t1.rzdate,
         t1.lzdate,
         trunc(months_between(t1.LZDATE, t1.RZDATE), 1) as nf,
        -- t1.ltfy,
         t1.iszhuying,
         t1.fcofferdate,
         t1.zpqudao,
         t1.lthzlevel,
         case
           when t1.lthzlevel = '战略' or t1.lthzlevel = '精英' then
            t1.lthzlevel
           else
            '普通'
         end lthzlevel1,
         T1.ZHIJIDQ,
         t1.bumenid,
         t1.tree_node_id
    from ODM_HR_ZPTZ t1
    left join odm_hr_rztz t2
      on t1.ygid = t2.ygid
      and t1.rzdate=t2.rzdate
      AND t2.rzzhiji<>'级'     
   WHERE
      t1.RZDATE < TO_DATE('${date_time}', 'YYYY-MM-DD')
     AND t1.RZDATE >= TO_DATE('2018-01-01', 'YYYY-MM-DD')
     AND T1.zpqudao = '猎头'),
--
ZPTZ2 AS
 (SELECT DISTINCT YGID,
                  YGZT,
                  rzzhiji,
                  RZDATE,
                  nf,
                  case
                    when to_char(LZDATE, 'yyyy-mm-dd') != '1970-01-01' THEN
                     to_char(LZDATE, 'yyyy-mm-dd')
                    ELSE
                     '—'
                  END as LZDATE,
                  ISZHUYING,
                  FCOFFERDATE,
                  ZPQUDAO,
                  LTHZLEVEL,
                  LTHZLEVEL1,
                  BUMENID,
                  --LTFY,
                  ZHIJIDQ,
                  tree_node_id,
                  DW.TREE_NODE_NUM
    FROM zptz1
    LEFT JOIN ODM_HR_DW DW
      ON DW.TREE_NODE = BUMENID
   where ZHIJIDQ NOT LIKE '99%'
     AND TREE_NODE_ID LIKE '%${DWMC}%'
     and TO_NUMBER(SUBSTR(rzzhiji, 1, 2)) >=1
      and TO_NUMBER(SUBSTR(rzzhiji, 1, 2)) <=18
  UNION ALL
  SELECT DISTINCT YGID,
                  YGZT,
                  rzzhiji,
                  RZDATE,
                  nf,
                  case
                    when to_char(LZDATE, 'yyyy-mm-dd') != '1970-01-01' THEN
                     to_char(LZDATE, 'yyyy-mm-dd')
                    ELSE
                     '—'
                  END as LZDATE,
                  ISZHUYING,
                  FCOFFERDATE,
                  ZPQUDAO,
                  LTHZLEVEL,
                  LTHZLEVEL1,
                  BUMENID,
                  --LTFY,
                  ZHIJIDQ,
                  tree_node_id,
                  DW.TREE_NODE_NUM
    FROM zptz1
    LEFT JOIN ODM_HR_DW DW
      ON DW.TREE_NODE = BUMENID
   where ZHIJIDQ LIKE '99%'
     AND TREE_NODE_ID LIKE '%${DWMC}%'
     and TO_NUMBER(SUBSTR(rzzhiji, 1, 2)) >=1
      and TO_NUMBER(SUBSTR(rzzhiji, 1, 2)) <=18
   ORDER BY TREE_NODE_NUM asc, ZHIJIDQ, RZDATE asc, YGID asc),

ZPTZ3 AS
 (SELECT *
    FROM ZPTZ2
   WHERE RZDATE < TO_DATE('${date_time}', 'YYYY-MM-DD')
     AND YGID NOT IN (SELECT YGID
                        FROM ZPTZ1
                       WHERE ygzt = '离职'
                         and nf < 6
                         AND nf >= 0)),

--关联 HR_LTQYJBDYFLB_OLD 费用表 <2018-02-01
ZPTZ4 as
 (select case
           when T1.FCOFFERDATE < TO_DATE('2018-02-01', 'YYYY-MM-DD') then
            t2.FEIYONG1
           else
            0
         end FEIYONG1,
         T1.*
    from ZPTZ3 T1
    LEFT JOIN HR_LTQYJBDYFLB_OLD T2
      ON T1.LTHZLEVEL1 = T2.LEIXING
     AND T1.rzzhiji = T2.ZHIJI),

--关联 HR_LTQYJBDYFLB >=2018-02-01
ZPTZ5 as
 (select case
           when T1.FCOFFERDATE >= TO_DATE('2018-02-01', 'YYYY-MM-DD') then
            T2.FEIYONG1
           else
            T1.FEIYONG1
         end FEIYONG2,
         T1.*
    from ZPTZ4 T1
    LEFT JOIN HR_LTQYJBDYFLB T2
      ON T1.LTHZLEVEL1 = T2.LEIXING
     AND T1.rzzhiji = T2.ZHIJI),
--ZPTZ6
ODM_ZPTZ_FY AS
 (select CASE
           WHEN FEIYONG2 IS NULL THEN
            0
           ELSE
            FEIYONG2
         END FEIYONG,
         YGID,
         YGZT,
         rzzhiji,
         RZDATE,
         nf,
         LZDATE,
         ISZHUYING,
         FCOFFERDATE,
         ZPQUDAO,
         LTHZLEVEL1,
         BUMENID,
         --LTFY,
         ZHIJIDQ,
         tree_node_id,
         TREE_NODE_NUM
    from ZPTZ5)

SELECT SUM(case
             when TO_CHAR(RZDATE, 'YYYY') = substr('${date_time}', 0, 4)   then
              FEIYONG
           END) AS LTFY,
       COUNT(case
               when TO_CHAR(RZDATE, 'YYYY') = substr('${date_time}', 0, 4)  AND FEIYONG<>0 then
                YGID
             END) AS LTZPRS,
       SUM(case
             when TO_CHAR(RZDATE, 'YYYY') = substr('${date_time}', 0, 4) then
              FEIYONG
           END) / COUNT(case
                          when TO_CHAR(RZDATE, 'YYYY') = substr('${date_time}', 0, 4) then
                           YGID
                        END) AVGFY
  FROM ODM_ZPTZ_FY 
  WHERE  YGID NOT IN (SELECT YGID FROM ODM_ZPTZ_FY WHERE ZHIJIDQ IN ('04级','05级') AND FEIYONG=0)

]]></Query>
</TableData>
<TableData name="1111111111111111" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="date_time"/>
<O>
<![CDATA[2018-06-05]]></O>
</Parameter>
<Parameter>
<Attributes name="DWMC"/>
<O>
<![CDATA[HX_HEAD]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[HXXF_HR]]></DatabaseName>
</Connection>
<Query>
<![CDATA[WITH ZPTZ1 AS (
SELECT 
DISTINCT YGID, 
DANWEI,
XINGMING, 
to_char(CSDATE,'yyyy-mm-dd') as CSDATE, 
GONGLING, 
YGZT, 
RZDATE,
case when to_char(LZDATE,'yyyy-mm-dd') != '1970-01-01' THEN to_char(LZDATE,'yyyy-mm-dd')
 ELSE '—' END as LZDATE,
ISZHUYING, 
to_char(FCOFFERDATE,'yyyy-mm-dd') as FCOFFERDATE, 
ZPQUDAO, 
QUDAOMX, 
LTHZLEVEL, 
SJGZMC, 
SJGZDRGW, 
ZPFZRNAME, 
ZPFZRID, 
BDFY, 
XCCG, 
ZPCG, 
XUELI, 
XUELIFENLEI, 
RZFQFS, 
YGFENLEIDQ,
YGLEIBIEDQ, 
GANGWEIDQ,
ZHIJIDQ, 
SSXULIEDQ, 
ZHINENGXULIEDQ, 
YGFENLEILY, 
YGLEIBIELY, 
GANGWEILY, 
BUMENLY, 
ZHIJILY, 
YWDANWEI1, 
YWDANWEI2, 
YWDANWEI3, 
YWDANWEI4, 
BUMEN, 
TJRID, 
TJRNAME, 
ZJZGID, 
ZJZGNAME, 
ZJZGGANGWEI, 
ZJZGZHIJI, 
GJZGID, 
GJZGNAME, 
GJZGGANGWEI, 
GJZGZHIJI,
TJRISBUMENFZR, 
CLFY, 
TJFY, 
QUDAOCOST, 
TJFYZFQK, 
BDFYZFQK, 
ISZLGANGWEI, 
ZJZGIDTEMP, 
ZJZGZHIWEITEMP,
BUMENID, 
GJZGIDTEMP, 
GJZGZHIWEITEMP, 
NAMEPINYIN,
ZPFY,
DW.TREE_NODE_NUM
FROM 
"ODM_HR_ZPTZ"
LEFT JOIN ODM_HR_DW DW
ON DW.TREE_NODE= BUMENID
where 
ZHIJIDQ NOT LIKE '99%'
AND TREE_NODE_ID LIKE '%${DWMC}%'
UNION ALL
SELECT 
DISTINCT YGID, 
DANWEI,
XINGMING, 
to_char(CSDATE,'yyyy-mm-dd') as CSDATE, 
GONGLING, 
YGZT, 
RZDATE,
case when to_char(LZDATE,'yyyy-mm-dd') != '1970-01-01' THEN to_char(LZDATE,'yyyy-mm-dd')
 ELSE '—' END as LZDATE,
ISZHUYING, 
to_char(FCOFFERDATE,'yyyy-mm-dd') as FCOFFERDATE, 
ZPQUDAO, 
QUDAOMX, 
LTHZLEVEL, 
SJGZMC, 
SJGZDRGW, 
ZPFZRNAME, 
ZPFZRID, 
BDFY, 
XCCG, 
ZPCG, 
XUELI, 
XUELIFENLEI, 
RZFQFS, 
YGFENLEIDQ,
YGLEIBIEDQ, 
GANGWEIDQ,
ZHIJIDQ, 
SSXULIEDQ, 
ZHINENGXULIEDQ, 
YGFENLEILY, 
YGLEIBIELY, 
GANGWEILY, 
BUMENLY, 
ZHIJILY, 
YWDANWEI1, 
YWDANWEI2, 
YWDANWEI3, 
YWDANWEI4, 
BUMEN, 
TJRID, 
TJRNAME, 
ZJZGID, 
ZJZGNAME, 
ZJZGGANGWEI, 
ZJZGZHIJI, 
GJZGID, 
GJZGNAME, 
GJZGGANGWEI, 
GJZGZHIJI,
TJRISBUMENFZR, 
CLFY, 
TJFY, 
QUDAOCOST, 
TJFYZFQK, 
BDFYZFQK, 
ISZLGANGWEI, 
ZJZGIDTEMP, 
ZJZGZHIWEITEMP,
BUMENID, 
GJZGIDTEMP, 
GJZGZHIWEITEMP, 
NAMEPINYIN,
ZPFY,
DW.TREE_NODE_NUM
FROM 
"ODM_HR_ZPTZ"
LEFT JOIN ODM_HR_DW DW
ON DW.TREE_NODE= BUMENID
where 
ZHIJIDQ  LIKE '99%'
AND TREE_NODE_ID LIKE '%${DWMC}%'
ORDER BY  TREE_NODE_NUM asc,ZHIJIDQ DESC,RZDATE asc,YGID asc 
),

ZPTZ2 AS (
SELECT * FROM ZPTZ1  WHERE RZDATE<TO_DATE('${date_time}','YYYY-MM-DD')
AND TO_NUMBER(SUBSTR(ZHIJILY,1,2))> 5 and TO_NUMBER(SUBSTR(ZHIJILY,1,2))<= 18 ) 
SELECT COUNT(case
               when zpqudao = '猎头' and
                    TO_CHAR(RZDATE, 'YYYY') = substr('${date_time}', 0, 4) then
                ygid
             END) AS LTS,--猎头本年人数
             COUNT(case
               when TO_CHAR(RZDATE, 'YYYY') = substr('${date_time}', 0, 4) then
                ygid
             END) AS QBS, -- 本年全部人数
             COUNT(case
               when zpqudao = '猎头' 
                    and TO_CHAR(RZDATE, 'YYYY-mm') = substr('${date_time}', 0, 7) then
                ygid
             END) AS LTSDY， --猎头当月人数
       COUNT(case
               WHEN TO_CHAR(RZDATE, 'YYYY-mm') = substr('${date_time}', 0, 7) then
                ygid
             END) AS QBSDY, -- 全部当月人数
       CASE WHEN COUNT(case WHEN TO_CHAR(RZDATE, 'YYYY') = substr('${date_time}', 0, 4) then ygid end) = 0 THEN 0 ELSE ROUND 
         ( COUNT(case when zpqudao = '猎头' and TO_CHAR(RZDATE, 'YYYY') = substr('${date_time}', 0, 4) then ygid END) 
         / COUNT(case when TO_CHAR(RZDATE, 'YYYY') = substr('${date_time}', 0, 4) then ygid END),
       3） END AS lv ,--猎头使用率
        COUNT(case
               when zpqudao = '猎头' and
                    TO_CHAR(RZDATE, 'YYYY') = substr('${date_time}', 0, 4) - 1 then
                ygid
             END) AS NCLTS, --年初猎头人数
        COUNT(case
               WHEN TO_CHAR(RZDATE, 'YYYY') = substr('${date_time}', 0, 4) - 1 then
                ygid
             end) AS NCQBS, -- 年初全部人数   
              CASE WHEN COUNT(case WHEN TO_CHAR(RZDATE, 'YYYY') = substr('${date_time}', 0, 4) - 1 then ygid end) = 0 THEN 0 ELSE ROUND (
                 COUNT(case when zpqudao = '猎头' and TO_CHAR(RZDATE, 'YYYY') = substr('${date_time}', 0, 4) - 1 then ygid END) / 
                 COUNT(case WHEN TO_CHAR(RZDATE, 'YYYY') = substr('${date_time}', 0, 4) - 1 then ygid end),
       3) END AS NClv        
              FROM ZPTZ2]]></Query>
</TableData>
<TableData name="用工监控1(NEW)" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="date_time"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="DWMC"/>
<O>
<![CDATA[]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[HXXF_HR]]></DatabaseName>
</Connection>
<Query>
<![CDATA[WITH W1 AS (
select 
TO_CHAR(SYSDATE,'YYYY-MM-DD') AS  CREATE_TIME,
count(*) zrs,--总人数
count (case when iszhuying='主营' then ygid end) zyrs,--主营人数
count (case when iszhuying='主营'  AND TREE_NODE_ID NOT LIKE '%10001100063%'
AND BUMEN NOT LIKE '%财务管理中心%' then ygid end)-
${SWITCH(DWMC,'',"",'HX_HEAD',2.5,
                    '10001100001',1,
                    '100000',0.5,
                    '10041105853',0.5,
                    '10003100439',0.5)} zyrsbhcz,--主营人数不含财
count (case when iszhuying='主营' then ygid end) -
count (case when iszhuying='主营' and iscqt='是' and cqtcdlyear in ('2017','2018') then ygid end) zybhyqybrs,--主营（不含17/18常青藤）
count (case when iszhuying <> '主营' then ygid end) fzyrs,--非主营人数
count (case when ygfenlei like '干部' then ygid end) gbyrs,--干部人数
count (case when iscqt = '是' and YGLEIBIE='正式员工'  and iszhuying='主营' then ygid end) cqtyrs,--常青藤人数
count (case when iscqt = '是' and YGLEIBIE= '实习生' then ygid end) cqtsxs--常青藤实习生
 from odm_hr_ygtz t1 left join odm_hr_dw  t2 ON 
 t1.tree_node_id like '%' || t2.tree_node || '%' 
 WHERE 1=1
 ${if(len(DWMC)=0," AND   PARENT_NODE ='HX_HEAD' ","AND  TREE_NODE ='"+DWMC+"'" )}
 --参数 
),W2 AS (
  select 
'${date_time}' AS CREATE_TIME,
count(*) zrs,--总人数
count (case when iszhuying='主营' then ygid end) zyrs,--主营人数
count (case when iszhuying='主营' AND TREE_NODE_ID NOT LIKE '%10001100063%'
AND BUMEN NOT LIKE '%财务管理中心%' then ygid end)-
${SWITCH(DWMC,'',"",'HX_HEAD',2.5,
                    '10001100001',1,
                    '100000',0.5,
                    '10041105853',0.5,
                    '10003100439',05)} zyrsbhcz,--主营人数不含财
--“主营财务”人数，数据逻辑：
--股份总部：财务管理中心+融资中心+10027979+10034523
--财务管理中心，其中：产业新城集团+10048221；产业小镇集团+10057895；孔雀城住宅集团+10071475
count (case when iszhuying='主营' then ygid end) -
count (case when iszhuying='主营' and iscqt='是' and cqtcdlyear in ('2017','2018') then ygid end)        zybhyqybrs,--主营（不含17/18常青藤）
count (case when iszhuying <> '主营' then ygid end) fzyrs,--非主营人数
count (case when ygfenlei like '干部' then ygid end) gbyrs,--干部人数
count (case when iscqt = '是' and YGLEIBIE='正式员工'  and iszhuying='主营' then ygid end) cqtyrs,--常青藤人数
count (case when iscqt = '是' and YGLEIBIE= '实习生' then ygid end) cqtsxs--常青藤实习生
 from odm_hr_ygtz_hist t1 left join odm_hr_dw  t2 ON 
 t1.tree_node_id like '%' || t2.tree_node || '%' 
 WHERE 1=1
 ${if(len(DWMC)=0," AND   PARENT_NODE ='HX_HEAD' ","AND  TREE_NODE ='"+DWMC+"'" )}--参数 
 and to_char(datetime,'yyyy-mm')=SUBSTR('${date_time}',0,7)

),TT AS (
  SELECT W1.CREATE_TIME,
         W1.ZRS,
		 W1.ZYRS,
		 W1.zyrsbhcz,
		 W1.zybhyqybrs,
		 W1.FZYRS,
		 W1.GBYRS,
		 W1.CQTYRS,
		 W1.CQTSXS
    FROM W1
    
UNION ALL 
  SELECT W2.CREATE_TIME,
         W2.ZRS,
		 W2.ZYRS,
		 W2.zyrsbhcz,
		 W2.zybhyqybrs,
		 W2.FZYRS,
		 W2.GBYRS,
		 W2.CQTYRS,
		 W2.CQTSXS
    FROM W2
)
select * from tt where create_time='${date_time}']]></Query>
</TableData>
<TableData name="用工监控查错" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="date_time"/>
<O>
<![CDATA[2018-06-07]]></O>
</Parameter>
<Parameter>
<Attributes name="DWMC"/>
<O>
<![CDATA[10001100001]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[HXXF_HR]]></DatabaseName>
</Connection>
<Query>
<![CDATA[WITH W2 AS(--FEICAI I
SELECT SUM(CW) AS CW 
  FROM (
SELECT COUNT(T1.YGID) AS CW
  FROM ODM_HR_YGTZ T1
  LEFT JOIN ODM_HR_DW T2 ON T1.TREE_NODE_ID LIKE '%' || T2.TREE_NODE || '%'
 WHERE 1=1
   AND (T1.TREE_NODE_ID LIKE '%10001100001%' AND T1.ZHINENGXULIE = '05-财')
   AND ISZHUYING = '主营'
  ${IF(LEN(DWMC)=0," AND PARENT_NODE ='HX_HEAD' ","AND  PARENT_NODE ='"+DWMC+"'" )}--参数 
UNION ALL
SELECT COUNT(T1.YGID) AS CW
  FROM ODM_HR_YGTZ T1
  LEFT JOIN ODM_HR_DW T2 ON T1.TREE_NODE_ID LIKE '%' || T2.TREE_NODE || '%'
 WHERE 1=1
   AND (T1.TREE_NODE_ID NOT LIKE '%10001100001%' AND T1.BUMEN LIKE '%财务管理中心%')
   AND ISZHUYING = '主营'
  ${IF(LEN(DWMC)=0," AND PARENT_NODE ='HX_HEAD' ","AND  PARENT_NODE ='"+DWMC+"'" )}--参数 
  )
),W4 AS (
  SELECT SUM(CW) AS CW 
  FROM (
SELECT COUNT(T1.YGID) AS CW
  FROM ODM_HR_YGTZ T1
  LEFT JOIN ODM_HR_DW T2 ON T1.TREE_NODE_ID LIKE '%' || T2.TREE_NODE || '%'
 WHERE 1=1
   AND (T1.TREE_NODE_ID LIKE 'HX_HEAD,10001100001,%' AND T1.ZHINENGXULIE = '05-财')
   AND ISZHUYING = '主营' AND BUMENID = T2.TREE_NODE
  ${IF(LEN(DWMC)=0," AND PARENT_NODE ='HX_HEAD' ","AND  PARENT_NODE ='"+DWMC+"'" )}--参数 
UNION ALL
SELECT COUNT(T1.YGID) AS CW
  FROM ODM_HR_YGTZ T1
  LEFT JOIN ODM_HR_DW T2 ON T1.TREE_NODE_ID LIKE '%' || T2.TREE_NODE || '%'
 WHERE 1=1
   AND (T1.TREE_NODE_ID NOT LIKE 'HX_HEAD,10001100001,%' AND T1.BUMEN LIKE '%财务管理中心%')
   AND ISZHUYING = '主营' AND BUMENID = T2.TREE_NODE
  ${IF(LEN(DWMC)=0," AND PARENT_NODE ='HX_HEAD' ","AND  PARENT_NODE ='"+DWMC+"'" )}--参数 
  )
),W6 AS (
  SELECT CREATE_TIME,SUM(CW) AS CW 
  FROM (
SELECT '${date_time}' AS  CREATE_TIME,
       COUNT(T1.YGID) AS CW
  FROM ODM_HR_YGTZ_HIST T1
  LEFT JOIN ODM_HR_DW T2 ON T1.TREE_NODE_ID LIKE '%' || T2.TREE_NODE || '%'
 WHERE 1=1
   AND (T1.TREE_NODE_ID LIKE 'HX_HEAD,10001100001,%' AND T1.ZHINENGXULIE = '05-财')
   AND ISZHUYING = '主营'
   AND TO_CHAR(DATETIME,'YYYY-MM-DD')='${date_time}'
  ${IF(LEN(DWMC)=0," AND PARENT_NODE ='HX_HEAD' ","AND  PARENT_NODE ='"+DWMC+"'" )}--参数 
UNION ALL
SELECT '${date_time}' AS  CREATE_TIME,
       COUNT(T1.YGID) AS CW
  FROM ODM_HR_YGTZ_HIST T1
  LEFT JOIN ODM_HR_DW T2 ON T1.TREE_NODE_ID LIKE '%' || T2.TREE_NODE || '%'
 WHERE 1=1
   AND (T1.TREE_NODE_ID NOT LIKE 'HX_HEAD,10001100001,%' AND T1.BUMEN LIKE '%财务管理中心%')
   AND ISZHUYING = '主营'
   AND TO_CHAR(DATETIME,'YYYY-MM-DD')='${date_time}'
  ${IF(LEN(DWMC)=0," AND PARENT_NODE ='HX_HEAD' ","AND  PARENT_NODE ='"+DWMC+"'" )}--参数 
  ) GROUP BY CREATE_TIME
),W8 AS (
SELECT CREATE_TIME,SUM(CW) AS CW 
  FROM (
SELECT '${date_time}' AS CREATE_TIME,
       COUNT(T1.YGID) AS CW
  FROM ODM_HR_YGTZ_HIST T1
  LEFT JOIN ODM_HR_DW T2 ON T1.TREE_NODE_ID LIKE '%' || T2.TREE_NODE || '%'
 WHERE 1=1
   AND (T1.TREE_NODE_ID LIKE 'HX_HEAD,10001100001,%' AND T1.ZHINENGXULIE = '05-财')
   AND ISZHUYING = '主营' AND BUMENID = T2.TREE_NODE
   AND TO_CHAR(DATETIME,'YYYY-MM-DD')='${date_time}'
  ${IF(LEN(DWMC)=0," AND PARENT_NODE ='HX_HEAD' ","AND  PARENT_NODE ='"+DWMC+"'" )}--参数 
UNION ALL
SELECT '${date_time}' AS CREATE_TIME,
       COUNT(T1.YGID) AS CW
  FROM ODM_HR_YGTZ_HIST T1
  LEFT JOIN ODM_HR_DW T2 ON T1.TREE_NODE_ID LIKE '%' || T2.TREE_NODE || '%'
 WHERE 1=1
   AND (T1.TREE_NODE_ID NOT LIKE 'HX_HEAD,10001100001,%' AND T1.BUMEN LIKE '%财务管理中心%')
   AND ISZHUYING = '主营' AND BUMENID = T2.TREE_NODE
   AND TO_CHAR(DATETIME,'YYYY-MM-DD')='${date_time}'
  ${IF(LEN(DWMC)=0," AND PARENT_NODE ='HX_HEAD' ","AND  PARENT_NODE ='"+DWMC+"'" )}--参数 
   ) GROUP BY CREATE_TIME
)
SELECT 'w2',cw FROM W2
UNION 
SELECT 'w4',cw FROM W4
UNION 
SELECT 'w6',cw FROM W6
UNION 
SELECT 'w8',cw FROM W8]]></Query>
</TableData>
<TableData name="主动离职累计人数" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="date_time"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="dwmc"/>
<O>
<![CDATA[]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[HXXF_HR]]></DatabaseName>
</Connection>
<Query>
<![CDATA[SELECT COUNT(1) NDZDLZ FROM ODM_HR_LZTZ t1
WHERE TO_CHAR(T1.LZDATE, 'YYYY')=SUBSTR('${date_time}', 0,4) 
and TO_CHAR(LZDATE,'YYYY-MM-DD')<='${date_time}' and to_char(lzdate,'yyyy-mm-dd')<>to_char(sysdate,'yyyy-mm-dd')
AND ISZHUYING = '主营'  AND LZLEIXING='辞职' AND (T1.LZYUANYIN <> '调动到其他关联公司' OR LZYUANYIN IS NULL)
${if(len(dwmc)=0,""," AND TREE_NODE_ID LIKE'%"+dwmc+"%'" )}--参数
order by  
 t1.LZDATE desc,t1.ZHIJI DESC,t1.tree_node_id]]></Query>
</TableData>
<TableData name="hrncfwb" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="date_time"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="DWMC"/>
<O>
<![CDATA[]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[HXXF_HR]]></DatabaseName>
</Connection>
<Query>
<![CDATA[SELECT ROUND(sum(case when CREATE_TIME = SUBSTR('${date_time}', 0, 4) - 1 || '-12-31' THEN
       ZHUYING end)/
       sum(case when CREATE_TIME = SUBSTR('${date_time}', 0, 4) - 1 || '-12-31' THEN
       (HRZZG - CQT17 - CQT18) end),0)  NCWFB
  FROM ODM_HR_RJFWGSB T
 WHERE 1 = 1
 ${IF(DWMC = 'HX_HEAD',
            " and TREE_NODE2 in (SELECT TREE_NODE FROM ODM_HR_DW WHERE PARENT_NODE ='HX_HEAD')",
            " and parent_nodes like '%" + DWMC + "%'") }]]></Query>
</TableData>
<TableData name="xzncfwb" class="com.fr.data.impl.DBTableData">
<Parameters/>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[HXXF_HR]]></DatabaseName>
</Connection>
<Query>
<![CDATA[SELECT ROUND(sum(case when CREATE_TIME = SUBSTR('${date_time}', 0, 4) - 1 || '-12-31' THEN
       ZHUYING end)/
       sum(case when CREATE_TIME = SUBSTR('${date_time}', 0, 4) - 1 || '-12-31' THEN
       (XZZZG - XZCQT17 - XZCQT18) end),0)  NCWFB
  FROM ODM_HR_RJFWGSB T
 WHERE 1 = 1
 ${IF(DWMC = 'HX_HEAD',
            " and TREE_NODE2 in (SELECT TREE_NODE FROM ODM_HR_DW WHERE PARENT_NODE ='HX_HEAD')",
            " and parent_nodes like '%" + DWMC + "%'") }]]></Query>
</TableData>
</TableDataMap>
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
<Attributes dsName="HXXF_HR" name="提交1"/>
<DMLConfig class="com.fr.write.config.IntelliDMLConfig">
<Table schema="" name="HR_LOG_RECORD"/>
<ColumnConfig name="ID" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=UUID(32)]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="NAME_ID" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$username]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="URL" isKey="false" skipUnmodified="false">
<O>
<![CDATA[ WebReport/ReportServer?formlet=HXXF_HR/HR_QUIT/Management_monitoring.frm&op=view]]></O>
</ColumnConfig>
<ColumnConfig name="CPT" isKey="false" skipUnmodified="false">
<O>
<![CDATA[Management_monitoring.frm]]></O>
</ColumnConfig>
<ColumnConfig name="CPT_NAME" isKey="false" skipUnmodified="false">
<O>
<![CDATA[管理监控综合报告]]></O>
</ColumnConfig>
<ColumnConfig name="REGISTER_ENTER_ID" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=uuid(33)]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="PARAMETER_NAME" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(LEN($date_time)=0,"","日期;")+IF(LEN($DWMC)=0,"","部门ID;")]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="PARAMETER" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(LEN($date_time)=0,"",$date_time+";")+IF(LEN($DWMC)=0,"",$DWMC+";")]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="TIME" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=now()]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="MOKUAI_NAME" isKey="false" skipUnmodified="false">
<O>
<![CDATA[管理监控]]></O>
</ColumnConfig>
<ColumnConfig name="CANSHU_NAME_CODE" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(LEN($date_time)=0,"","日期："+$date_time+";")+IF(LEN($DWMC)=0,"","部门ID："+$DWMC+";")]]></Attributes>
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
<Background name="ColorBackground" color="-657931"/>
<Alpha alpha="1.0"/>
</Border>
<Background name="ColorBackground" color="-657931"/>
<LCAttr vgap="0" hgap="0" compInterval="0"/>
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
<Margin top="0" left="5" bottom="0" right="8"/>
<Border>
<border style="0" color="-1710619" borderRadius="0" type="0" borderStyle="0"/>
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
<![CDATA[0,0,723900,647700,432000,864000,864000,864000,1524000,864000,864000,864000,1152000,432000,864000,952500,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[304800,3200400,3695700,2933700,266700,0,2743200,360000,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" cs="5" s="0">
<O>
<![CDATA[人才流失监控]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="1" cs="5" s="1">
<O t="Image">
<IM>
<![CDATA[m8s$@)iiMs<f@Zd7ZF9GPupIl@LJ&1Teo5u%m^dk2Jl?,<Dfc.)gfmX<:$![CY#FeX\i&r)P
sY+qu.K%pGpR5cai5oF76[6LO7=+2`EV(`c-Q]AJqDu#bYZpN8dG?*5cQ?,rS4*(JqAlsgr)g
GikP7ArZC16bYd/\*!]AZ7>#Hc`.'G&C8rJ$7m-S\#TQK?$j-/NRO71uFqO#BESLf.ZpG3DV8
NIm2Tli>P2jte(<Vad8?2c+&W7"/0q!TMne[KW/J(_A*afBC</S!UuNqlO]Aj4F6'lfgDqgWb
XW,X=MH/@&0OWV^<:..i/2C&T[`?l*'eps7Z<-@6Qoa*Z-#&T"P>&i6N%Y8tSdNdCm9>D5#n
MW$'/d]A5?tf78_qQLg&)D@5TAJ!9j8fj:,L]AoN'8@m8";4YbU.r@*tZ.f+FNI"_MmNN`H3)s
=\6YDjQX9`(L=P#@2;/iLN"?:DuGWWi%W-<jGYJpPAi4^moUWa8b._A]A;PAJHu8M[Y)[Inmd
Vod`/mKsM(jA[\m%m5N69Pq5APeT$CbDS8F"Y4::'In1:+@$@?UNdXXp5RDnI0Zm/B=]A1Us8
IM_8S!e14>rp;;bB82FetKY1[*[3tZ@$>X]ARNtqCr`$+.aRlS-89V\?PiWk=#bW0%YML*?Eo
j7Asa\NL^q,[4I8>I8>h^#J[F+N8;VT(lCohjIm&k@8?jAR^E(\,lc91J'R:\OC*+^:oX;Z3
&VM*_n`9k.<!chnQu0]ACHW%Bf:W[\*@6Nh#>V"[Ni\E]AHr'PAH**SR9#^SMhC8?1fq7(QT#$
9r:o9]A6uCCq%a?%$kQJnVgqQ\flEOp6cs69L+u-MjM5H^aisC+:3b'K2@VkJpc)#G\Gi6Hsr
r0t.?BHc<'V]A;ep;^C7&CBfdsQ&!q+$Ebk<[DKp#/=Dk<bT4@WG%bPi$c,9IbHL":,=HV.C`
D*uI^FDn#M!-f4P`8@`0Qd<<f>>P`3`NNIo0P5C,A)F.H"+1'F$BDK]AkbR5>gePC"s/&OaQ[
KNU#t%!=+>FKHFVCKII4m^UTUmaG"7;gUW'k*/R9F0^IW#q2q7Xm*Cd,IAN"</j7(^rp"R*@
(:H#^R,LQ-U$5P&k9,g#.O$rLB'"<hHPI'>8ec2=-s8OZE18WFRt$nK*3d($L6]A8%BsZ<"+d
48]AbqQNWM']A]AJ`72rCi%N(r,/FH>A:T6gmTK$Ge$6,-(tb-Or#<l!N(bu]A!cXC%l8('k>+Z=
:1"_,T?uSL5[')ogX7oVPq<T@`OYm.]A*3u"k\,'+LGuZ/t,T8T6QANJ+p$E!@4K\EVp:%]ANL
,5!\%[foaKr76)FL?.K4<5F4TFERm'=Dj8bRruH[&C49(j4hAk#5fu-dAR5Z@c!G.SAfVFYf
6dpba_)>VP1IdUSNdK@lpT(tTd`>^fXKl\V;2/C\I&:$>'cQ:`[ZYK!hX<'F8:3ISHeA]ACOX
T9bT?:F*OF81[d</%kB.R]A]Alb)]A-k)AaVd,M'VcKmT!&f:eHsT/d?al#93iRjg'@DLIHJoWc
Pj<4!H8C^(bT["p^l`hq]A;B4?efifFs+WLH'"uE0dM`cnJ>_-'.`3oc%dFl0en#okm`Hjp#+
SY<.:oBC#2&W_aUDj\3Zf3t<>.;PGuLT38[Tg>q6)WO2uFN`k>;LTUG'l\Wm$(NhG+NnGJ@p
)hf/\G>F!oDRd3W=#M>0JKsM@RgPD\DISZjh!4`FCZV-Ji'%60J]A!TqsD[f-M65ZL?\r"[jj
nMKhO'%$H/"94=k>fA@N9m*Xj+rWG7"pl/5J4C[h)pMO"s#F\`et)5LBhVU$@8$##0`/b@DY
6c]Apn?P%cKp!H:N*3R"N)XLpr?(G9:U!r[!jCad!fH*70-h*UZk-\%(O&pVd9L2fI,h.0R<N
VTSO>hc@>_Y[(X_B/.g&DK_3e>JG86=X10:5j=J3AmI[0%=EGB1&k:A:d6FQ?aM<1O[<ec`Q
rcado/Rk$m@)4!q%%&:,co,n7m?f>c3:cd=&qlNhZ12[Y>:pV-YSRY=A78j3Ymo9aP/KV"Js
+KmLX04M("P5r[Nsuoek(]At/$jY/-.uCNCjA9gt'1Va$:o=+jAotGf5'VqK.Rt-eVM906%+i
)s@6BlM]Ai"fWeL1t1$I$sFg&XWep]AA%i^N+^P$5/mTMs?icqT;fK[m_l34-IOHD+_QkLp_$,
+i(C]AZ^)`3qr[rM8oC&;#Za=6\F\HHj/TS_]A&Iq!nVW]ARW`Rccl8A_j4pKXC2@)j-&NO\e?;
bkAZ/r<>KOj_gE-Wf4<%)+Ejc('^K3&\N9!$;ki1R:iSXEN=KPK=_UT@HNp]A<G!n#4OBaHNo
s=Id#sgj?K#lGPch(c/_EcF`(>)t.UGNeK0jqY?HPmGBlX]A6?WnGE!UjTToV#p"HrJ6Bl85?
lY&9T\bt$bm&@PO`/=S%Xr,P;+dZL]AgsFmljFp-IT=>^kftdUhd(fa2@2EF@Zc7p2`[frJ>b
H<Hoo(.pP>mKNPR3:J$BLi+LF[iIf8K6i*7KW1YQQ:fQVK)G2JY[A#`6\h9$\D\nH$aE2U=i
HrYL1_gVd\Kc3dH3V/jdA(F8K>a#YIM6"n6N*R+%Ycg9ZG-_U7PWa5f2+_,eAa^8N=_SsBAm
;pCMmI"8kqOq(Q@8enIFSIe3/ACuOaUk,p@`JJ3n#IfgXLX8Y5%HZo8#J<3*4]AD:dnGBTn"6
mR-j`nq^I%cNS3VNLsRo'h!1:2`TSq*WBM_5pP"+N;^#"Js3sgI-C40`S3QM;jY4?:Po)G<f
R`<&?bcXOEhWlaCX<$(a3A^)A'&k(Xk[AmjMuV^6Z>jW=+aAJF?u"TIf82C-jIP85>9((LG/
<D+#Q,Vd$'>=#I78]Af?<Q8K8-pQ(c]AB:F;M"H591jl'J`9FppQ:ao4cl-eT#6Qesmou!*:BW
QI"HS3?&!&9HTh3%ogIUE,s!#,>qMH7oM++G<1`Mj"Fd`lcUPH),*S\oBR)L[L:BH*G9^/'6
)I/HI7%KGr?TS1_XV!J`q`+Y6?a*cFTs^03:O)]A79k-ouGiB!OpRRm0/>,0?P4JHi0l7gZ#m
a7]AKSD#g:k09)gHH3d.d"XAAC#J%Il;S3C-.4PP\hfS)8Mb8`'\0n2FHcFWl.2CH9lfD<p;O
\s"T)"/PU8&DpBpLj0N,4LkNcWTG==%*=2'MNMp7%ao?-o7ROO*Vn2r;;Kc+#3Dj!H[eU\<S
<K?7,_K_Wr>&$mk<j!Du[<Q!-XEc\"?e5mfGb%:hpRIN\`:%)Jnj%sc(9XdZr5aaknfbuQ*B
Ta^O=1Po;)3APGR]A"<@qa?DjdALNZ1P\#Ie9-8#V?uP[Br:BKQ1Z2;`Vr?K;pZ*u`@g[;X4h
Y)/nM`nMTJH^L2S/9dVPn'm#CW#58Q!X$phA?19!S_@b\%%d5<e[m)7pmg(<hI.TlX.j7.t5
\!h$btp"Cis"#!%<72WRB`X5iB:AM"i-Y/7V$Rlr.4KH25XZZ_F3+q[KlkYJiYH8Bf&h,P.R
hAMn)=Ec7Wm(o7KCM4,,$;G`Pe%;?^CVtmf[KNU.3=<W[#e]AVL6;07kOu-cbP,pd;SktNJQN
(#Z;lUQHV9F?bcjACIc@(%i0_3bDWuUUX7cUnWK<2ca7NpA<WD<TUdrbViH(49fk08#KB*h-
'0hR[i@e1&>lSe*&6P<IC,)H]A@<VeVpO>s".7V:E>S.Pd.Bk3;(A<e7\sc"^UV4[]Ac09Q%mG
$cNT.C_c"XPFdI+kbh_VH3(DjYNa]AGlbNQNF!&3"D`S2PB;>hA*HoCU8/>8QI-aLR8@]AeONA
l#FrRd<W;[Q@]Ad1#2,%Sr==US`C#o^L19[jHN-FrNT4f?]An6X0<k+@0#eq&Z??MSM#mrYu5R
685;QT]A@.#Z"+'^2^KfY^B5$8H'F10f14#'*7bf;<cd(*e!@V>C\@'=O"WYQe1(X*0d+m=*@
jFats$4g.BQ&nY<54b?G>SLil:^LJR+OMH@FOLT,qh+1I9Vk0#SMitPE#mRQTTK-jQ4R!Y<9
nfZ\Q`9dl"+;k\mkEW0\[#je#cArV/9'kMM\@dXb+jE[aJHrYlXN7j-?I\(A'c*/rEJW-$GF
UuSoFkrQWkSm=0%k+QXcpnC'$b&>o6\&(RIC^s'Ri1cRVfCJ0!tuV:d,rC8+m6`'d2I0GIe\
p[sm8'KMOEo*r5W]AoMO#$SloM;&3]A.`Su0d+-:d`UCr/;\ro/OdlJd_\PQ38@62Re<jO;:$*
I8Hjfq6e8A]An,Xaa5.]Ah1dCnPY*bqgML0S&Q$*3=P]AgbON6#!OX8a03]AV5\=fo1(oV]Aa!<La
Vd\l)I4]AD&-!CKWY4G`r8ki0:af+c=#K<OGA.K5@gmrHFN,?l.YI?mi7<L;]ApHg(J\oir'4G
)D@/jRFkJ%qC%C+WI%N2dqePoJm*lV]Ar?HWI]A5YjjJrJC;00jt@09(P9rF*,4Q0YbXD9``dq
r,VT&T8b=9Tk+)Qh`'_>bN=R3\jbrFP8CgKL6ZiT*p3c94?dG5Vi$[9ak+1to%-IHpN:WT<f
H$KF/q54pO7ifFZ/3Fs%aV("aeEkk`dFh\8WC3C-#kd,NrU4h7]A"NCY*R&e%,k;H/%P[.CkB
\m%e$[8s^H/MDT1JY!<X79hLV[[B'FmE)tWK1S0$6Gb3"jE,,YncL-TJ2!bUd2N?o^#@:!=C
\^+YoN%,.8Q50ON&QKs`7ti/NGp1tAN,cSr5\N7eD:1"B9oF>\&\0kCLp3f[#8!RD["Y9#o=
!XOog#3foOaMq90(iWZul$(-U35Nc4J!kPonX!Z.6`NA/rmQ@'9phNODN2(<p4!&~
]]></IM>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="2" cs="5" s="2">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=" 主动离职率（主营）  " + "<span>" + "&nbsp" + "&nbsp" + "&nbsp" + "</span>" + "<span style='text-decoration:underline; color:#0000ff; font-weight: bold;'>" + C9 + "</span>"]]></Attributes>
</O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="网页链接1">
<JavaScript class="com.fr.js.WebHyperlink">
<JavaScript class="com.fr.js.WebHyperlink">
<Parameters>
<Parameter>
<Attributes name="date_time"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$date_time]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="dwmc"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$dwmc]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="mc"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$mc]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="username"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$username]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_self]]></TargetFrame>
<Features width="600" height="400"/>
<URL>
<![CDATA[/WebReport/ReportServer?formlet=HXXF_HR%2FHR_QUIT%2FManagement_ZYFX.frm]]></URL>
</JavaScript>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<CellGUIAttr adjustmode="0" showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="0" r="3" cs="5" s="3">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="年度主动离职人数  " + "<span>" + "&nbsp" + "&nbsp" + "&nbsp" + "</span>" + "<span style='text-decoration:underline; color:#0000ff; font-weight: bold;'>" + F16 + "</span>"]]></Attributes>
</O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="JavaScript2">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="dwmc1"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$dwmc]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="date_time1"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$date_time]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="lei1"/>
<O>
<![CDATA[z]]></O>
</Parameter>
<Parameter>
<Attributes name="tem"/>
<O>
<![CDATA[2]]></O>
</Parameter>
</Parameters>
<Content>
<![CDATA[var url = FR.cjkEncode('/WebReport/ReportServer?reportlet=/HXXF_HR/HR_QUIT/Cader_Leave_1.cpt&dwmc='+dwmc1+'&date_time='+date_time1+'&lei='+lei1+'&temp='+tem)
window.parent.parent.parent.$('#iframe2').attr('src',url);
window.parent.parent.parent.$('.smallIframe').show();
//window.parent.parent.parent.$('.model').show();
//window.parent.parent.parent.alldata.push([name_1,url]A);
//window.parent.parent.parent.$('.close').attr('_name',name_1)
window.parent.parent.parent.$('.smallIframe').css({
			width: '900px',
			height: '600px',
			left:'50%',
			top:'50%',
			marginLeft:'-450px',
			marginTop:'-300px'
		});
window.parent.parent.parent.isSmall = true;
/*/_g().parameterEl.getWidgetByName('YGID').setValue(id1);
$("#fr-btn-HR_LOG").find("button").trigger("click");
_g().parameterEl.getWidgetByName('YGID').setValue(null);*/]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<CellGUIAttr adjustmode="0" showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="0" r="4" s="4">
<PrivilegeControl/>
<CellGUIAttr adjustmode="1"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="1" r="4" s="4">
<PrivilegeControl/>
<CellGUIAttr adjustmode="1"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="2" r="4" s="4">
<PrivilegeControl/>
<CellGUIAttr adjustmode="1"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="3" r="4" s="4">
<PrivilegeControl/>
<CellGUIAttr adjustmode="1"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="4" r="4" s="4">
<PrivilegeControl/>
<CellGUIAttr adjustmode="1"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="0" r="5" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="5" s="5">
<O>
<![CDATA[年度目标]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="5" s="5">
<O>
<![CDATA[累计年度目标]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="5" s="5">
<O>
<![CDATA[是否达标]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="5" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="6" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="6" s="6">
<O t="DSColumn">
<Attributes dsName="LZRATE" columnName="Z_Y"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[IF(LEN($$$) = 0,"-",$$$)]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="2" r="6" s="7">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(B7 = "-", "-", B7 * B16)]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="6" s="8">
<O>
<![CDATA[●]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[B7 = "-"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.FRFontHighlightAction">
<FRFont name="SimSun" style="0" size="48"/>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[IF(B7 = "-", "", C9 > B9)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.FRFontHighlightAction">
<FRFont name="SimSun" style="0" size="144" foreground="-4259840"/>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性3]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[IF(B7 = "-", "", C9 <= B9)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.FRFontHighlightAction">
<FRFont name="SimSun" style="0" size="144" foreground="-6697984"/>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="4" r="6" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="7" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="7" s="5">
<O>
<![CDATA[累计年度目标]]></O>
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
<C c="2" r="7" s="5">
<O>
<![CDATA[当前值]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="7" s="5">
<O>
<![CDATA[是否达标]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="7" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="8" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="8" s="6">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(LEN(B7) = 0, "-", B7 * B16)]]></Attributes>
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
<C c="2" r="8" s="7">
<O t="DSColumn">
<Attributes dsName="NDLZ" columnName="ZDLZV"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[IF(LEN($$$)=0,"-",ROUND($$$*100,1))+"%"]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="3" r="8" s="8">
<O>
<![CDATA[●]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[LEN(B7) = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.FRFontHighlightAction">
<FRFont name="微软雅黑" style="0" size="72"/>
</HighlightAction>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="—"]]></Attributes>
</O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[C9 > B9]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.FRFontHighlightAction">
<FRFont name="SimSun" style="0" size="144" foreground="-4259840"/>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性3]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[C9 <= B9]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.FRFontHighlightAction">
<FRFont name="SimSun" style="0" size="144" foreground="-6697984"/>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="4" r="8" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="9" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="9" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="9" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="9" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="9" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="10" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="10" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="10" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="10" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="10" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="11" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="11" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="11" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="11" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="11" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="12" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="12" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="12" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="12" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="12" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="13" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="13" cs="3" s="9">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="13" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="14" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="14" s="4">
<O>
<![CDATA[ ]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="14" cs="2" s="10">
<O>
<![CDATA[注：不含调动到关联公司  ]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="14" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="15" s="11">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="15" s="12">
<O t="DSColumn">
<Attributes dsName="NDLZ" columnName="LJYHMB"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
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
<C c="2" r="15" s="13">
<O t="DSColumn">
<Attributes dsName="NDLZ" columnName="ZDLZV"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[ROUND($$$,4)]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=if(len($$$)=0,'—',$$$)]]></Content>
</Present>
<Expand dir="0"/>
</C>
<C c="3" r="15" s="14">
<O t="DSColumn">
<Attributes dsName="NDLZ" columnName="NDZDLZ"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="网络报表2">
<JavaScript class="com.fr.js.ReportletHyperlink">
<JavaScript class="com.fr.js.ReportletHyperlink">
<Parameters>
<Parameter>
<Attributes name="dwmc"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$dwmc]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="date_time"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$date_time]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="lei"/>
<O>
<![CDATA[z]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_dialog]]></TargetFrame>
<Features width="900" height="600"/>
<ReportletName showPI="true">
<![CDATA[/HXXF_HR/HR_QUIT/Cader_Leave_1.cpt]]></ReportletName>
</JavaScript>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand dir="0"/>
</C>
<C c="4" r="15" s="11">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="15">
<O t="DSColumn">
<Attributes dsName="主动离职累计人数" columnName="NDZDLZ"/>
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
<FRFont name="微软雅黑" style="1" size="112"/>
<Background name="ColorBackground" color="-1"/>
<Border/>
</Style>
<Style imageLayout="4">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-1"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="1" size="96"/>
<Background name="ColorBackground" color="-604217"/>
<Border/>
</Style>
<Style horizontal_alignment="0" vertical_alignment="1" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-604217"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-993064"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-1"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0%]]></Format>
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-1"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0.0%]]></Format>
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-1"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="144" foreground="-6697984"/>
<Background name="ColorBackground" color="-1"/>
<Border/>
</Style>
<Style horizontal_alignment="4" vertical_alignment="3" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="64"/>
<Background name="ColorBackground" color="-993064"/>
<Border/>
</Style>
<Style horizontal_alignment="4" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="64"/>
<Background name="ColorBackground" color="-993064"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0.0%]]></Format>
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="2" vertical_alignment="3" imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0.0%]]></Format>
<FRFont name="微软雅黑" style="1" size="96"/>
<Background name="ColorBackground" color="-1"/>
<Border/>
</Style>
<Style horizontal_alignment="2" vertical_alignment="1" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72" foreground="-16776961" underline="1"/>
<Background name="ColorBackground" color="-1"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<isShared isshared="false"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="0" zoom="true" refresh="false" isUseHTML="false"/>
</InnerWidget>
<BoundsAttr x="597" y="0" width="303" height="240"/>
</Widget>
<body class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="report8"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Margin top="1" left="1" bottom="1" right="1"/>
<Border>
<border style="1" color="-4144960" borderRadius="0" type="0" borderStyle="0"/>
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
<![CDATA[723900,723900,1143000,723900,723900,1143000,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1">
<O>
<![CDATA[主动离职率]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="1" s="0">
<O t="BigDecimal">
<![CDATA[0.083]]></O>
<PrivilegeControl/>
</C>
<C c="1" r="2">
<O>
<![CDATA[年度主动离职人数：]]></O>
<PrivilegeControl/>
</C>
<C c="2" r="2">
<O>
<![CDATA[224人]]></O>
<PrivilegeControl/>
</C>
<C c="0" r="3">
<O>
<![CDATA[年度目标]]></O>
<PrivilegeControl/>
</C>
<C c="2" r="3">
<O>
<![CDATA[实际值]]></O>
<PrivilegeControl/>
</C>
<C c="0" r="4" s="1">
<O t="BigDecimal">
<![CDATA[0.13]]></O>
<PrivilegeControl/>
</C>
<C c="2" r="4">
<O>
<![CDATA[——]]></O>
<PrivilegeControl/>
</C>
<C c="0" r="5">
<O>
<![CDATA[累计年度目标]]></O>
<PrivilegeControl/>
</C>
<C c="2" r="5">
<O>
<![CDATA[当前值]]></O>
<PrivilegeControl/>
</C>
<C c="0" r="6" s="2">
<O t="BigDecimal">
<![CDATA[0.068]]></O>
<PrivilegeControl/>
</C>
<C c="2" r="6" s="2">
<O t="BigDecimal">
<![CDATA[0.083]]></O>
<PrivilegeControl/>
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
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0.0%]]></Format>
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="2" imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0%]]></Format>
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="2" imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0.0%]]></Format>
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<isShared isshared="false"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="0" zoom="true" refresh="false" isUseHTML="false"/>
</body>
</InnerWidget>
<BoundsAttr x="597" y="311" width="303" height="240"/>
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
<Margin top="0" left="5" bottom="0" right="8"/>
<Border>
<border style="0" color="-1710619" borderRadius="0" type="0" borderStyle="0"/>
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
<![CDATA[2362200,1295400,990600,609600,1257300,1181100,1219200,1219200,1295400,1181100,1371600,914400,266700,114300,0,0,1447800,533400,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[304800,3200400,0,2933700,3162300,2971800,360000,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" cs="7" s="0">
<O>
<![CDATA[人才流失监控]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="1" s="1">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="1" r="1" cs="5" s="2">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="干部离职率  " + "<span>" + "&nbsp" + "&nbsp" + "&nbsp" + "</span>" + "<span style='text-decoration:underline; color:#0000ff; font-weight: bold;'>" + FORMAT(E18,"0.0%") + "</span>"]]></Attributes>
</O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="网页链接1">
<JavaScript class="com.fr.js.WebHyperlink">
<JavaScript class="com.fr.js.WebHyperlink">
<Parameters>
<Parameter>
<Attributes name="dwmc"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$dwmc]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="date_time"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$date_time]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="username"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$username]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_self]]></TargetFrame>
<Features width="600" height="400"/>
<URL>
<![CDATA[/WebReport/ReportServer?formlet=HXXF_HR/HR_QUIT/Management_GB.frm]]></URL>
</JavaScript>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<CellGUIAttr adjustmode="0" showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="6" r="1" s="1">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="0" r="2" s="1">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="1" r="2" cs="5" s="3">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="年度干部离职人数  " + "<span>" + "&nbsp" + "&nbsp" + "&nbsp" + "</span>" + "<span style='text-decoration:underline; color:#0000ff; font-weight: bold;'>" + F18 + "</span>"]]></Attributes>
</O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="JavaScript2">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="dwmc1"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$dwmc]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="date_time1"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$date_time]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="lei1"/>
<O>
<![CDATA[g]]></O>
</Parameter>
<Parameter>
<Attributes name="tem"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$temp]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[var url = FR.cjkEncode('/WebReport/ReportServer?reportlet=/HXXF_HR/HR_QUIT/Cader_Leave_1.cpt&dwmc='+dwmc1+'&date_time='+date_time1+'&lei='+lei1+'&temp='+tem)
window.parent.parent.parent.$('#iframe2').attr('src',url);
window.parent.parent.parent.$('#iframe2').attr('_src',url);
window.parent.parent.parent.$('.smallIframe').show();
//window.parent.parent.parent.$('.model').show();
//window.parent.parent.parent.alldata.push([name_1,url]A);
//window.parent.parent.parent.$('.close').attr('_name',name_1)
window.parent.parent.parent.$('.smallIframe').css({
			width: '900px',
			height: '600px',
			left:'50%',
			top:'50%',
			marginLeft:'-450px',
			marginTop:'-300px'
		});
window.parent.parent.parent.isSmall = true;
/*/_g().parameterEl.getWidgetByName('YGID').setValue(id1);
$("#fr-btn-HR_LOG").find("button").trigger("click");
_g().parameterEl.getWidgetByName('YGID').setValue(null);*/]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<CellGUIAttr adjustmode="0" showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="6" r="2" s="1">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="0" r="3" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="3" cs="4" s="5">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="3" s="6">
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="网络报表2">
<JavaScript class="com.fr.js.ReportletHyperlink">
<JavaScript class="com.fr.js.ReportletHyperlink">
<Parameters>
<Parameter>
<Attributes name="dwmc"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$dwmc]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="date_time"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$date_time]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="lei"/>
<O>
<![CDATA[g]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_dialog]]></TargetFrame>
<Features width="900" height="600"/>
<ReportletName showPI="true">
<![CDATA[/HXXF_HR/HR_QUIT/Cader_Leave_1.cpt]]></ReportletName>
</JavaScript>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<Expand dir="0"/>
</C>
<C c="6" r="3" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="4" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="4" s="7">
<O>
<![CDATA[年度目标]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="4" s="7">
<O>
<![CDATA[离职人数]]></O>
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
<C c="3" r="4">
<O>
<![CDATA[年初+季度人数/2]]></O>
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
<C c="4" r="4" s="7">
<O>
<![CDATA[累计年度目标]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="4" s="7">
<O>
<![CDATA[是否达标]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="4" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="5" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="5" s="8">
<O t="DSColumn">
<Attributes dsName="LZRATE" columnName="G_Y"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[IF(LEN($$$) = 0 ,"-",$$$)]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="2" r="5">
<O t="DSColumn">
<Attributes dsName="NDLZ" columnName="GB_LZ_Q4"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[IF(LEN($$$) = 0 ,"-",$$$)]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="3" r="5">
<O t="DSColumn">
<Attributes dsName="干部常青藤年初加季度人数除以2" columnName="GBQ4"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[IF(LEN($$$) = 0 ,"-",$$$)]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[LEN(B6) = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="4" r="5" s="9">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(B6 = "-", "-", B6 * B18)]]></Attributes>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="5" r="5" s="10">
<O>
<![CDATA[●]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[IF(E6 = "-", "", E6 < E18)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.FRFontHighlightAction">
<FRFont name="SimSun" style="0" size="144" foreground="-4259840"/>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[IF(E6 = "-", "", E6 >= E18)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.FRFontHighlightAction">
<FRFont name="SimSun" style="0" size="144" foreground="-6697984"/>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性3]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[E6 = "-"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.FRFontHighlightAction">
<FRFont name="SimSun" style="0" size="48"/>
</HighlightAction>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="6" r="5" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="6" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="6" s="7">
<O>
<![CDATA[Q1目标]]></O>
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
<C c="4" r="6" s="9">
<O>
<![CDATA[实际值]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="6" s="7">
<O>
<![CDATA[是否达标]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="6" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="7" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="7" s="8">
<O t="DSColumn">
<Attributes dsName="LZRATE" columnName="Q1"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[IF(LEN($$$) = 0 ,"-",$$$)]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="2" r="7">
<O t="DSColumn">
<Attributes dsName="NDLZ" columnName="GB_LZ_Q1"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[IF(LEN($$$) = 0 ,"-",$$$)]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="3" r="7">
<O t="DSColumn">
<Attributes dsName="干部常青藤年初加季度人数除以2" columnName="GBQ1"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[IF(LEN($$$) = 0 ,"-",$$$)]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[LEN(B8) = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="4" r="7" s="9">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(C8 = "-", '0%', C8 / D8)]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH($date_time) < 4]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="5" r="7" s="10">
<O>
<![CDATA[●]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[IF(E8 = "-", "", E8 > B8)]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[IF(MONTH($date_time) < 4, "", E8 > B8)]]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.FRFontHighlightAction">
<FRFont name="SimSun" style="0" size="144" foreground="-4125163"/>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH($date_time) < 4]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[E8 = "-"]]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.FRFontHighlightAction">
<FRFont name="SimSun" style="0" size="48"/>
</HighlightAction>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性3]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[IF(E8 = "-", "", E8 <= B8)]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[IF(MONTH($date_time) < 4, "", E8 <= B8)]]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.FRFontHighlightAction">
<FRFont name="SimSun" style="0" size="144" foreground="-6697984"/>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="6" r="7" s="11">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="8" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="8" s="7">
<O>
<![CDATA[Q2目标]]></O>
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
<C c="4" r="8" s="9">
<O>
<![CDATA[实际值]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="8" s="7">
<O>
<![CDATA[是否达标]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="8" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="9" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="9" s="8">
<O t="DSColumn">
<Attributes dsName="LZRATE" columnName="Q2"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[IF(LEN($$$) = 0 ,"-",$$$)]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="2" r="9">
<O t="DSColumn">
<Attributes dsName="NDLZ" columnName="GB_LZ_Q2"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[IF(LEN($$$) = 0 ,"-",$$$)]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="3" r="9">
<O t="DSColumn">
<Attributes dsName="干部常青藤年初加季度人数除以2" columnName="GBQ2"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[IF(LEN($$$) = 0 ,"-",$$$)]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition"/>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="4" r="9" s="9">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(B10 = "-", "-", SUM(C10,C8) / D10)]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH($date_time) < 7]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="5" r="9" s="10">
<O>
<![CDATA[●]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH($date_time) < 7]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[E10 = "-"]]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.FRFontHighlightAction">
<FRFont name="SimSun" style="0" size="48"/>
</HighlightAction>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[IF(MONTH($date_time) < 7, "", E10 > B10)]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[IF(E10 = "-", "", E10 > B10)]]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.FRFontHighlightAction">
<FRFont name="SimSun" style="0" size="144" foreground="-4125163"/>
</HighlightAction>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[●]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性3]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[IF(E10 = "-", "", E10 <= B10)]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[IF(MONTH($date_time) < 7, "", E10 <= B10)]]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.FRFontHighlightAction">
<FRFont name="SimSun" style="0" size="144" foreground="-6697984"/>
</HighlightAction>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[●]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="6" r="9" s="11">
<O>
<![CDATA[ ]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="10" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="10" s="7">
<O>
<![CDATA[Q3目标]]></O>
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
<C c="4" r="10" s="9">
<O>
<![CDATA[实际值]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="10" s="7">
<O>
<![CDATA[是否达标]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="10" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="11" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="11" s="8">
<O t="DSColumn">
<Attributes dsName="LZRATE" columnName="Q3"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[IF(LEN($$$) = 0 ,"-",$$$)]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="2" r="11">
<O t="DSColumn">
<Attributes dsName="NDLZ" columnName="GB_LZ_Q3"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[IF(LEN($$$) = 0 ,"-",$$$)]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="3" r="11">
<O t="DSColumn">
<Attributes dsName="干部常青藤年初加季度人数除以2" columnName="GBQ3"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[IF(LEN($$$) = 0 ,"-",$$$)]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[LEN(B12) = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="4" r="11" s="9">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(C12 = "-", "-", SUM(C8,C10,C12) / D12)]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH($date_time) < 10]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="5" r="11" s="10">
<O>
<![CDATA[●]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[IF(E12 = "-", "", E12 > B12)]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[IF(MONTH($date_time) < 10, "", E12 > B12)]]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.FRFontHighlightAction">
<FRFont name="SimSun" style="0" size="144" foreground="-4125163"/>
</HighlightAction>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[●]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH($date_time) < 10]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[E12 = "-"]]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.FRFontHighlightAction">
<FRFont name="SimSun" style="0" size="48"/>
</HighlightAction>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性3]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[IF(E12 = "-", "", E12 <= B12)]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[IF(MONTH($date_time) < 10, "", E12 <= B12)]]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.FRFontHighlightAction">
<FRFont name="SimSun" style="0" size="144" foreground="-6697984"/>
</HighlightAction>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[●]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="6" r="11" s="11">
<O>
<![CDATA[ ]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="12" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="12" s="7">
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
<C c="4" r="12" s="9">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="12" s="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="12" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="13" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="13" s="9">
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
<C c="4" r="13" s="9">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="13" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="13" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="14" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="14" s="7">
<O>
<![CDATA[累计年度目标]]></O>
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
<C c="2" r="14">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="14">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="14" s="9">
<O>
<![CDATA[当前值]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="14" s="7">
<O>
<![CDATA[是否达标]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="14" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="15" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="15" s="9">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=B6 * B18]]></Attributes>
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
<C c="4" r="15" s="9">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=E18]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="15" s="12">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[E17 > B17]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.FRFontHighlightAction">
<FRFont name="SimSun" style="0" size="72" foreground="-4259840"/>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="6" r="15" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="16" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="16" cs="5" s="13">
<O>
<![CDATA[注：不含调动到关联公司]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="16" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="17" s="14">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="17" s="14">
<O t="DSColumn">
<Attributes dsName="NDLZ" columnName="LJYHMB"/>
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
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="17">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="17" s="15">
<O t="DSColumn">
<Attributes dsName="NDLZ" columnName="GBLZV"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[ROUND($$$,4)]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="网页链接1">
<JavaScript class="com.fr.js.WebHyperlink">
<JavaScript class="com.fr.js.WebHyperlink">
<Parameters>
<Parameter>
<Attributes name="date_time"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$date_time]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="dwmc"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$dwmc]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_self]]></TargetFrame>
<Features width="600" height="400"/>
<URL>
<![CDATA[http://10.2.98.8:8080/WebReport/ReportServer?formlet=HXXF_HR%2FHR_QUIT%2FManagement_GB.frm]]></URL>
</JavaScript>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand dir="0"/>
</C>
<C c="5" r="17" s="16">
<O t="DSColumn">
<Attributes dsName="NDLZ" columnName="GBNDLZ"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="网络报表2">
<JavaScript class="com.fr.js.ReportletHyperlink">
<JavaScript class="com.fr.js.ReportletHyperlink">
<Parameters>
<Parameter>
<Attributes name="dwmc"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$dwmc]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="date_time"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$date_time]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="lei"/>
<O>
<![CDATA[g]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_dialog]]></TargetFrame>
<Features width="900" height="600"/>
<ReportletName showPI="true">
<![CDATA[/HXXF_HR/HR_QUIT/Cader_Leave_1.cpt]]></ReportletName>
</JavaScript>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand dir="0"/>
</C>
<C c="6" r="17" s="14">
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
<FRFont name="微软雅黑" style="1" size="112"/>
<Background name="ColorBackground" color="-1"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-604217"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="1" size="96"/>
<Background name="ColorBackground" color="-604217"/>
<Border/>
</Style>
<Style horizontal_alignment="0" vertical_alignment="1" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-604217"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-993064"/>
<Border/>
</Style>
<Style horizontal_alignment="4" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-993064"/>
<Border/>
</Style>
<Style horizontal_alignment="2" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72" foreground="-16776961" underline="1"/>
<Background name="ColorBackground" color="-993064"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-1"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0%]]></Format>
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-1"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0.0%]]></Format>
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-1"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="144" foreground="-6697984"/>
<Background name="ColorBackground" color="-1"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="144"/>
<Background name="ColorBackground" color="-993064"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="136" foreground="-6697984"/>
<Background name="ColorBackground" color="-1"/>
<Border/>
</Style>
<Style horizontal_alignment="4" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="64"/>
<Background name="ColorBackground" color="-993064"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="2" imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0.0%]]></Format>
<FRFont name="微软雅黑" style="1" size="96" foreground="-16776961" underline="1"/>
<Background name="ColorBackground" color="-1"/>
<Border/>
</Style>
<Style horizontal_alignment="2" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72" foreground="-16776961" underline="1"/>
<Background name="ColorBackground" color="-1"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<isShared isshared="false"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="0" zoom="true" refresh="false" isUseHTML="false"/>
</InnerWidget>
<BoundsAttr x="598" y="0" width="302" height="280"/>
</Widget>
<body class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="report9"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Margin top="1" left="1" bottom="1" right="1"/>
<Border>
<border style="1" color="-4144960" borderRadius="0" type="0" borderStyle="0"/>
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
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1">
<O>
<![CDATA[干部离职率]]></O>
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
<BoundsAttr x="598" y="31" width="302" height="280"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="label1"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O>
<![CDATA[]]></O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="0" autoline="true"/>
<FRFont name="SimSun" style="0" size="72" foreground="-4259840"/>
<border style="0" color="-723724"/>
</InnerWidget>
<BoundsAttr x="700" y="0" width="101" height="31"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WScaleLayout">
<WidgetName name="date_time1"/>
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
<InnerWidget class="com.fr.form.ui.DateEditor">
<WidgetName name="date_time1"/>
<WidgetAttr disabled="true" invisible="true" description="">
<PrivilegeControl/>
</WidgetAttr>
<DateAttr/>
<widgetValue>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=NOW()]]></Attributes>
</O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="657" y="0" width="43" height="21"/>
</Widget>
</InnerWidget>
<BoundsAttr x="657" y="0" width="43" height="31"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WScaleLayout">
<WidgetName name="date_time"/>
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
<InnerWidget class="com.fr.form.ui.ComboBox">
<WidgetName name="date_time"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<allowBlank>
<![CDATA[false]]></allowBlank>
<DirectEdit>
<![CDATA[false]]></DirectEdit>
<CustomData>
<![CDATA[false]]></CustomData>
<Dictionary class="com.fr.data.impl.TableDataDictionary">
<FormulaDictAttr kiName="SJ" viName="YF"/>
<TableDataDictAttr>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[月份]]></Name>
</TableData>
</TableDataDictAttr>
</Dictionary>
<widgetValue>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(HOUR(NOW()) <= 6,LEFT(DATEDELTA(NOW(),-1),10),LEFT(NOW(),10))]]></Attributes>
</O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="801" y="0" width="99" height="21"/>
</Widget>
</InnerWidget>
<BoundsAttr x="801" y="0" width="99" height="31"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="label3"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<widgetValue/>
<LabelAttr verticalcenter="true" textalign="0" autoline="true"/>
<FRFont name="SimSun" style="0" size="72"/>
<border style="0" color="-723724"/>
</InnerWidget>
<BoundsAttr x="113" y="0" width="117" height="31"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="label2"/>
<WidgetAttr invisible="true" description="">
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=sql("HXXF_HR","SELECT descr  as PARENT_NAME FROM (SELECT * FROM ODM_HR_DW WHERE tree_node NOT IN (SELECT tree_node from  ODM_HR_DW  where 1=1 AND  descr = '集团总部') UNION ALL SELECT '2908' AS SETID,	'10040105798' AS TREE_NODE,	'100000' AS PARENT_NODE,	20100	AS TREE_NODE_NUM,	'' AS HX_PARENT_SETID ,'产业新城集团总部' AS DESCR,	'1' AS BACK,	'1' AS BACK_ANA,	'HX_HEAD,100000,10040105798' AS PARENT_NODES,	'华夏幸福<产业新城集团<集团总部' AS PARENT_NAME FROM dual UNION ALL SELECT 	'278' AS SETID,	'22222' AS TREE_NODE,	'10041105853'AS PARENT_NODE,30100 AS TREE_NODE_NUM,	'' AS HX_PARENT_SETID ,'产业小镇集团总部'AS DESCR,'1' AS BACK,	'1' AS BACK_ANA,	'HX_HEAD,10041105853,22222,' AS PARENT_NODES,	'华夏幸福<产业小镇集团<集团总部' AS PARENT_NAME FROM dual UNION ALL SELECT	'2059' AS SETID,'44444' AS TREE_NODE,	'10004100730' AS PARENT_NODE,40100 AS TREE_NODE_NUM,'' AS HX_PARENT_SETID ,	'产业发展集团总部'AS DESCR,	'1' AS BACK,	'1' AS BACK_ANA,	'HX_HEAD,10004100730,44444,' AS PARENT_NODES,	'华夏幸福<产业发展集团<集团总部'AS PARENT_NAME FROM dual UNION ALL SELECT	'1282'AS SETID,	'55555'AS TREE_NODE,	'10003100439'	AS PARENT_NODE,50100 AS TREE_NODE_NUM,'' AS HX_PARENT_SETID ,	'孔雀城住宅集团总部'AS DESCR,	'1' AS BACK,	'1' AS BACK_ANA,	'HX_HEAD,10003100439,55555,' AS PARENT_NODES,	'华夏幸福<孔雀城住宅集团<集团总部'  AS PARENT_NAME FROM dual) where tree_node='"+DWMC+"' ",1)]]></Attributes>
</O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="2" autoline="true"/>
<FRFont name="微软雅黑" style="0" size="72" foreground="-4259840"/>
<border style="0" color="-723724"/>
</InnerWidget>
<BoundsAttr x="63" y="0" width="50" height="31"/>
</Widget>
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
<Sorted sorted="false"/>
<MobileWidgetList/>
<WidgetScalingAttr compState="0"/>
<DesignResolution absoluteResolutionScaleW="1366" absoluteResolutionScaleH="768"/>
</InnerWidget>
<BoundsAttr x="598" y="807" width="302" height="79"/>
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
<Margin top="0" left="5" bottom="0" right="8"/>
<Border>
<border style="0" color="-1710619" borderRadius="0" type="0" borderStyle="0"/>
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
<![CDATA[1296000,723900,432000,1409700,1333500,1219200,1028700,1219200,720000,1143000,1143000,838200,0,0,0,1066800,864000,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[360000,2743200,2743200,4419600,2743200,2743200,360000,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="1" r="0" cs="5" s="1">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="常青藤离职率  " + "<span>" + "&nbsp" + "&nbsp" + "&nbsp" + "</span>" + "<span style='text-decoration:underline; color:#0000ff; font-weight: bold;'>" + format(E17,"0.0%") + "</span>"]]></Attributes>
</O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="网页链接1">
<JavaScript class="com.fr.js.WebHyperlink">
<JavaScript class="com.fr.js.WebHyperlink">
<Parameters>
<Parameter>
<Attributes name="dwmc"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$dwmc]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="date_time"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$date_time]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="mc"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$mc]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="username"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$username]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_self]]></TargetFrame>
<Features width="600" height="400"/>
<URL>
<![CDATA[/WebReport/ReportServer?formlet=HXXF_HR/HR_QUIT/Management_CQT.frm]]></URL>
</JavaScript>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<CellGUIAttr adjustmode="0" showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="6" r="0" s="2">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="0" r="1" s="3">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="1" r="1" cs="5" s="4">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="年度常青藤离职人数  " + "<span>" + "&nbsp" + "&nbsp" + "&nbsp" + "</span>" + "<span style='text-decoration:underline; color:#0000ff; font-weight: bold;'>" + F17 + "</span>"]]></Attributes>
</O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="JavaScript2">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="dwmc1"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$dwmc]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="date_time1"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$date_time]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="lei1"/>
<O>
<![CDATA[c]]></O>
</Parameter>
<Parameter>
<Attributes name="tem"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$temp]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[var url = FR.cjkEncode('/WebReport/ReportServer?reportlet=/HXXF_HR/HR_QUIT/Cader_Leave_1.cpt&dwmc='+dwmc1+'&date_time='+date_time1+'&lei='+lei1+'&temp='+tem)
window.parent.parent.parent.$('#iframe2').attr('src',url);
window.parent.parent.parent.$('.smallIframe').show();
//window.parent.parent.parent.$('.model').show();
//window.parent.parent.parent.alldata.push([name_1,url]A);
//window.parent.parent.parent.$('.close').attr('_name',name_1)
window.parent.parent.parent.$('.smallIframe').css({
			width: '900px',
			height: '600px',
			left:'50%',
			top:'50%',
			marginLeft:'-450px',
			marginTop:'-300px'
		});
window.parent.parent.parent.isSmall = true;
/*/_g().parameterEl.getWidgetByName('YGID').setValue(id1);
$("#fr-btn-HR_LOG").find("button").trigger("click");
_g().parameterEl.getWidgetByName('YGID').setValue(null);*/]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<CellGUIAttr adjustmode="0" showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="6" r="1" s="5">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="0" r="2" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="2" s="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="2" s="8">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="2" s="8">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="2" s="9">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="2" s="10">
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="网络报表2">
<JavaScript class="com.fr.js.ReportletHyperlink">
<JavaScript class="com.fr.js.ReportletHyperlink">
<Parameters>
<Parameter>
<Attributes name="date_time"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$date_time]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="dwmc"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$dwmc]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="lei"/>
<O>
<![CDATA[c]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_dialog]]></TargetFrame>
<Features width="900" height="600"/>
<ReportletName showPI="true">
<![CDATA[/HXXF_HR/HR_QUIT/Cader_Leave_1.cpt]]></ReportletName>
</JavaScript>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<Expand dir="0"/>
</C>
<C c="6" r="2" s="11">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="3" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="3" s="12">
<O>
<![CDATA[年度目标]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="3">
<O>
<![CDATA[各季度离职]]></O>
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
<C c="3" r="3">
<O>
<![CDATA[季度人数]]></O>
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
<C c="4" r="3" s="12">
<O>
<![CDATA[累计年度目标]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="3" s="12">
<O>
<![CDATA[是否达标]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="3" s="11">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="4" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="4" s="13">
<O t="DSColumn">
<Attributes dsName="LZRATE" columnName="C_Y"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[IF(LEN($$$)=0,"-",$$$)]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="2" r="4">
<O t="DSColumn">
<Attributes dsName="NDLZ" columnName="CQT_LZ_Q4"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="3" r="4">
<O t="DSColumn">
<Attributes dsName="干部常青藤年初加季度人数除以2" columnName="CQTQ4"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="4" r="4" s="14">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(B5 = "-", "-", ROUND((B5 * B17),3))]]></Attributes>
</O>
<PrivilegeControl/>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=if(len($$$)=0,'-',$$$)]]></Content>
</Present>
<Expand dir="0"/>
</C>
<C c="5" r="4" s="15">
<O>
<![CDATA[●]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[IF(E5 = "-", "", E5 < E17)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.FRFontHighlightAction">
<FRFont name="SimSun" style="0" size="144" foreground="-4259840"/>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[IF(E5 = "-", "", E5 >= E17)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.FRFontHighlightAction">
<FRFont name="SimSun" style="0" size="144" foreground="-6697984"/>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性3]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[E5 = "-"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.FRFontHighlightAction">
<FRFont name="SimSun" style="0" size="48"/>
</HighlightAction>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="6" r="4" s="11">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="5" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="5" s="12">
<O>
<![CDATA[Q1目标]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="5" s="14">
<O>
<![CDATA[实际值]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="5" s="12">
<O>
<![CDATA[是否达标]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="5" s="11">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="6" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="6" s="13">
<O t="DSColumn">
<Attributes dsName="LZRATE" columnName="C_Q1"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[IF(LEN($$$)=0,"-",$$$)]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="2" r="6">
<O t="DSColumn">
<Attributes dsName="NDLZ" columnName="CQT_LZ_Q1"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="3" r="6">
<O t="DSColumn">
<Attributes dsName="常青藤季底在职人数" columnName="Q1"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="4" r="6" s="14">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(B7 = "-", "-", ROUND(C7 / (C7+D7),3))]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH($date_time) < 4]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=if(len($$$)=0,'-',$$$)]]></Content>
</Present>
<Expand dir="0"/>
</C>
<C c="5" r="6" s="15">
<O>
<![CDATA[●]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[IF(E7 = "-", "", E7 > B7)]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[IF(MONTH($date_time) < 4, "", E7 > B7)]]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.FRFontHighlightAction">
<FRFont name="SimSun" style="0" size="144" foreground="-4125163"/>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH($date_time) < 4]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[E7 = "-"]]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.FRFontHighlightAction"/>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性3]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[IF(E7 = "-", "", E7 <= B7)]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[IF(MONTH($date_time) < 4, "", E7 <= B7)]]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.FRFontHighlightAction">
<FRFont name="SimSun" style="0" size="144" foreground="-6697984"/>
</HighlightAction>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[●]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="6" r="6" s="11">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="7" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="7" s="12">
<O>
<![CDATA[Q2目标]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="7" s="14">
<O>
<![CDATA[实际值]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="7" s="12">
<O>
<![CDATA[是否达标]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="7" s="11">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="8" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="8" s="13">
<O t="DSColumn">
<Attributes dsName="LZRATE" columnName="C_Q2"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[IF(LEN($$$)=0,"-",$$$)]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="2" r="8">
<O t="DSColumn">
<Attributes dsName="NDLZ" columnName="CQT_LZ_Q2"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="3" r="8">
<O t="DSColumn">
<Attributes dsName="常青藤季底在职人数" columnName="Q2"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="4" r="8" s="14">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(B9 = "-", "-",round( SUM(C7,C9)/SUM(C7,C9,D9),3))]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH($date_time) < 7]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=if(len($$$)=0,'-',$$$)]]></Content>
</Present>
<Expand dir="0"/>
</C>
<C c="5" r="8" s="15">
<O>
<![CDATA[●]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[IF(MONTH($date_time) < 7, "", E9 > B9)]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[IF(E9 = "-", "", E9 > B9)]]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.FRFontHighlightAction">
<FRFont name="SimSun" style="0" size="144" foreground="-4125163"/>
</HighlightAction>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[●]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH($date_time) < 7]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[E9 = "-"]]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.FRFontHighlightAction">
<FRFont name="SimSun" style="0" size="48"/>
</HighlightAction>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性3]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[IF(MONTH($date_time) < 7, "", E9 <= B9)]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[IF(E9 = "-", "", E9 <= B9)]]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.FRFontHighlightAction">
<FRFont name="SimSun" style="0" size="144" foreground="-6697984"/>
</HighlightAction>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[●]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="6" r="8" s="11">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="9" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="9" s="12">
<O>
<![CDATA[Q3目标]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="9" s="14">
<O>
<![CDATA[实际值]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="9" s="12">
<O>
<![CDATA[是否达标]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="9" s="11">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="10" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="10" s="13">
<O t="DSColumn">
<Attributes dsName="LZRATE" columnName="C_Q3"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[IF(LEN($$$)=0,"-",$$$)]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="2" r="10">
<O t="DSColumn">
<Attributes dsName="NDLZ" columnName="CQT_LZ_Q3"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="3" r="10">
<O t="DSColumn">
<Attributes dsName="常青藤季底在职人数" columnName="Q3"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="4" r="10" s="14">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(B11 = "-", "-", round(SUM(C7,C9,C11)/SUM(C7,C9,C11,D11),3))]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH($date_time) < 10]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=if(len($$$)=0,'-',$$$)]]></Content>
</Present>
<Expand dir="0"/>
</C>
<C c="5" r="10" s="15">
<O>
<![CDATA[●]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[IF(MONTH($date_time) < 10, "", E11 > B11)]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[IF(E11 = "-", "", E11 > B11)]]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.FRFontHighlightAction">
<FRFont name="SimSun" style="0" size="144" foreground="-4125163"/>
</HighlightAction>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[●]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH($date_time) < 10]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[E11 = "-"]]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.FRFontHighlightAction">
<FRFont name="SimSun" style="0" size="48"/>
</HighlightAction>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性3]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[IF(MONTH($date_time) < 10, "", E11 <= B11)]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[IF(E11 = "-", "", E11 <= B11)]]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.FRFontHighlightAction">
<FRFont name="SimSun" style="0" size="144" foreground="-6697984"/>
</HighlightAction>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[●]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="6" r="10" s="11">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="11" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="11" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="11" s="14">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="11" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="11" s="11">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="12" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="12" s="14">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="12" s="14">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="12" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="12" s="11">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="13" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="13" s="12">
<O>
<![CDATA[累计年度目标]]></O>
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
<C c="4" r="13" s="14">
<O>
<![CDATA[当前值]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="13" s="12">
<O>
<![CDATA[是否达标]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="13" s="11">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="14" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="14" s="14">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=B5 * B17]]></Attributes>
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
<Expand/>
</C>
<C c="4" r="14" s="14">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=E17]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="14" s="12">
<O>
<![CDATA[-]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="14" s="11">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="15" s="16">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="15" cs="5" s="17">
<O>
<![CDATA[注：不含调动到关联公司]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="15" s="18">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="16" s="19">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="16" s="19">
<O t="DSColumn">
<Attributes dsName="NDLZ" columnName="LJYHMB"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.ListCondition"/>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="4" r="16" s="20">
<O t="DSColumn">
<Attributes dsName="NDLZ" columnName="CQTLZV"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[ROUND($$$,4)]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="网页链接2">
<JavaScript class="com.fr.js.WebHyperlink">
<JavaScript class="com.fr.js.WebHyperlink">
<Parameters>
<Parameter>
<Attributes name="dwmc"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$dwmc]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="date_time"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$date_time]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="MC"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$MC]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_self]]></TargetFrame>
<Features width="600" height="400"/>
<URL>
<![CDATA[http://10.2.98.8:8080/WebReport/ReportServer?formlet=HXXF_HR%2FHR_QUIT%2FManagement_CQT.frm]]></URL>
</JavaScript>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand dir="0"/>
</C>
<C c="5" r="16" s="21">
<O t="DSColumn">
<Attributes dsName="NDLZ" columnName="CQTNDLZ"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="网络报表2">
<JavaScript class="com.fr.js.ReportletHyperlink">
<JavaScript class="com.fr.js.ReportletHyperlink">
<Parameters>
<Parameter>
<Attributes name="date_time"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$date_time]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="dwmc"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$dwmc]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="lei"/>
<O>
<![CDATA[c]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_dialog]]></TargetFrame>
<Features width="900" height="600"/>
<ReportletName showPI="true">
<![CDATA[/HXXF_HR/HR_QUIT/Cader_Leave_1.cpt]]></ReportletName>
</JavaScript>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand dir="0"/>
</C>
<C c="6" r="16" s="19">
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
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-604217"/>
<Border>
<Top style="1" color="-1710619"/>
<Left style="1" color="-1710619"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="1" size="96"/>
<Background name="ColorBackground" color="-604217"/>
<Border>
<Top style="1" color="-1710619"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-604217"/>
<Border>
<Top style="1" color="-1710619"/>
<Right style="1" color="-1710619"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-604217"/>
<Border>
<Left style="1" color="-1710619"/>
</Border>
</Style>
<Style horizontal_alignment="0" vertical_alignment="1" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-604217"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-604217"/>
<Border>
<Right style="1" color="-1710619"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-993064"/>
<Border>
<Left style="1" color="-1710619"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-993064"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="ColorBackground" color="-993064"/>
<Border/>
</Style>
<Style horizontal_alignment="4" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-993064"/>
<Border/>
</Style>
<Style horizontal_alignment="2" imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0人]]></Format>
<FRFont name="微软雅黑" style="0" size="72" foreground="-16776961" underline="1"/>
<Background name="ColorBackground" color="-993064"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-993064"/>
<Border>
<Right style="1" color="-1710619"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-1"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0%]]></Format>
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-1"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0.0%]]></Format>
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-1"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="144" foreground="-6697984"/>
<Background name="ColorBackground" color="-1"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-993064"/>
<Border>
<Bottom style="1" color="-1710619"/>
<Left style="1" color="-1710619"/>
</Border>
</Style>
<Style horizontal_alignment="4" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="64"/>
<Background name="ColorBackground" color="-993064"/>
<Border>
<Bottom style="1" color="-1710619"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-993064"/>
<Border>
<Bottom style="1" color="-1710619"/>
<Right style="1" color="-1710619"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="2" imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0.0%]]></Format>
<FRFont name="微软雅黑" style="1" size="96" foreground="-16776961" underline="1"/>
<Background name="ColorBackground" color="-1"/>
<Border>
<Top style="1" color="-1710619"/>
</Border>
</Style>
<Style horizontal_alignment="2" imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0人]]></Format>
<FRFont name="微软雅黑" style="0" size="72" foreground="-16776961" underline="1"/>
<Background name="ColorBackground" color="-1"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<isShared isshared="false"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="0" zoom="true" refresh="false" isUseHTML="false"/>
</InnerWidget>
<BoundsAttr x="598" y="0" width="302" height="256"/>
</Widget>
<body class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="report10"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Margin top="1" left="1" bottom="1" right="1"/>
<Border>
<border style="1" color="-4144960" borderRadius="0" type="0" borderStyle="0"/>
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
<![CDATA[723900,1143000,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,3695700,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1">
<O>
<![CDATA[常青藤离职率]]></O>
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
<BoundsAttr x="598" y="551" width="302" height="256"/>
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
<Margin top="0" left="5" bottom="0" right="5"/>
<Border>
<border style="0" color="-1710619" borderRadius="0" type="0" borderStyle="0"/>
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
<![CDATA[1219200,647700,609600,1943100,723900,1295400,2590800,723900,723900,1295400,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[360000,3086100,4032000,3238500,288000,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" cs="5" s="0">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="猎头费监控" + "<span>" + "&nbsp" + "<span>" + "&nbsp" + "&nbsp" + "<span style='text-decoration:underline; color:#0000ff; font-weight: bold;'>" +B5 +" 万元" + "</span>"]]></Attributes>
</O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="网页链接1">
<JavaScript class="com.fr.js.WebHyperlink">
<JavaScript class="com.fr.js.WebHyperlink">
<Parameters>
<Parameter>
<Attributes name="date_time"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$date_time]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="dwmc"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$dwmc]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="username"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$username]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_self]]></TargetFrame>
<Features width="600" height="400"/>
<URL>
<![CDATA[/WebReport/ReportServer?formlet=HXXF_HR/HR_QUIT/Management_LTFY.frm]]></URL>
</JavaScript>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="0" r="1" cs="5" s="1">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="猎头费用去向人员明细  " + "<span>" + "&nbsp" + "&nbsp" + "&nbsp" + "</span>" + "<span style='text-decoration:underline; color:#0000ff; font-weight: bold;'>" + C5 + "</span>"]]></Attributes>
</O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="JavaScript1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="dwmc1"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$dwmc]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="date_time1"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$date_time]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="tem"/>
<O>
<![CDATA[2]]></O>
</Parameter>
</Parameters>
<Content>
<![CDATA[var url = FR.cjkEncode('/WebReport/ReportServer?reportlet=HXXF_HR/HR_QUIT/Cader_Leave_3.cpt&dwmc='+dwmc1+'&date_time='+date_time1+'&temp='+tem)
window.parent.parent.parent.$('#iframe2').attr('src',url);
window.parent.parent.parent.$('.smallIframe').show();
//window.parent.parent.parent.$('.model').show();
//window.parent.parent.parent.alldata.push([name_1,url]A);
//window.parent.parent.parent.$('.close').attr('_name',name_1)
window.parent.parent.parent.$('.smallIframe').css({
			width: '900px',
			height: '600px',
			left:'50%',
			top:'50%',
			marginLeft:'-450px',
			marginTop:'-300px'
		});
window.parent.parent.parent.isSmall = true;
/*/_g().parameterEl.getWidgetByName('YGID').setValue(id1);
$("#fr-btn-HR_LOG").find("button").trigger("click");
_g().parameterEl.getWidgetByName('YGID').setValue(null);*/]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="0" r="2" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="2" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="2" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="2" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="2" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="3" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="3" s="5">
<O>
<![CDATA[猎头费]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="3" s="6">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=year(now())+"年入职人数（猎头）"]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="3" s="5">
<O>
<![CDATA[人均猎头费]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="3" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="4" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="4" s="7">
<O t="DSColumn">
<Attributes dsName="猎头费用(NEW)" columnName="LTFY"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.SummaryGrouper">
<FN>
<![CDATA[com.fr.data.util.function.SumFunction]]></FN>
</RG>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="4" s="5">
<O t="DSColumn">
<Attributes dsName="猎头费用(NEW)" columnName="LTZPRS"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.SummaryGrouper">
<FN>
<![CDATA[com.fr.data.util.function.SumFunction]]></FN>
</RG>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="4" s="8">
<O t="DSColumn">
<Attributes dsName="猎头费用(NEW)" columnName="AVGFY"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.SummaryGrouper">
<FN>
<![CDATA[com.fr.data.util.function.AverageFunction]]></FN>
</RG>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="4" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="5" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="5" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="5" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="5" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="5" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="6" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="6" s="5">
<O>
<![CDATA[昨日猎头费]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="6" s="5">
<O>
<![CDATA[昨日入职人数（猎头）]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="6" s="5">
<O>
<![CDATA[昨日人均猎头费]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="6" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="7" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="7" s="9">
<O t="DSColumn">
<Attributes dsName="昨日猎头费用" columnName="LTFY"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[IF(LEN($$$)=0,"0 ",$$$)]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=if(len(b8)=0,'0万元',$$$)]]></Content>
</Present>
<Expand dir="0"/>
</C>
<C c="2" r="7" s="5">
<O t="DSColumn">
<Attributes dsName="昨日猎头费用" columnName="LTZPRS"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=if(len(C8)=0,'0',$$$)]]></Content>
</Present>
<Expand dir="0"/>
</C>
<C c="3" r="7" s="8">
<O t="DSColumn">
<Attributes dsName="昨日猎头费用" columnName="AVGFY"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[IF(B8="0","0",$$$)]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="4" r="7" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="8" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="8" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="8" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="8" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="8" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="9" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="9" cs="3" s="10">
<O>
<![CDATA[注：猎头费为入职口径，根据猎头级别对应费率测算]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="9" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="10" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="10" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="10" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="10" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="10" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="11">
<O t="DSColumn">
<Attributes dsName="猎头费用（HOPE）" columnName="LTFY"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[ROUND($$$/10000,2) + " 万元"]]></Result>
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
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="1" size="96"/>
<Background name="ColorBackground" color="-397858"/>
<Border>
<Top style="1" color="-1710619"/>
<Left style="1" color="-1710619"/>
</Border>
</Style>
<Style horizontal_alignment="0" vertical_alignment="1" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-397858"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-67344"/>
<Border>
<Left style="1" color="-1710619"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-67344"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="ColorBackground" color="-67344"/>
<Border>
<Right style="1" color="-1710619"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-1"/>
<Border/>
</Style>
<Style horizontal_alignment="0" textStyle="1" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-1"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0 万元]]></Format>
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-1"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0.0 万元]]></Format>
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-1"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0  万元]]></Format>
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-1"/>
<Border/>
</Style>
<Style horizontal_alignment="4" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="64"/>
<Background name="ColorBackground" color="-67344"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<isShared isshared="false"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="0" zoom="true" refresh="false" isUseHTML="false"/>
</InnerWidget>
<BoundsAttr x="297" y="0" width="300" height="240"/>
</Widget>
<body class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="report7"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Margin top="1" left="1" bottom="1" right="1"/>
<Border>
<border style="1" color="-4144960" borderRadius="0" type="0" borderStyle="0"/>
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
<![CDATA[723900,1143000,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,4876800,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1">
<O>
<![CDATA[猎头费用使用监控]]></O>
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
<BoundsAttr x="297" y="311" width="300" height="240"/>
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
<Margin top="0" left="5" bottom="0" right="5"/>
<Border>
<border style="0" color="-1710619" borderRadius="2" type="0" borderStyle="0"/>
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
<![CDATA[1752600,0,1790700,533400,722880,722880,722880,722880,722880,800100,722880,722880,723900,1584000,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[360000,2448000,2448000,2743200,2743200,360000,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" cs="6" s="0">
<O>
<![CDATA[效能提升监控]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="1" cs="6" s="1">
<O t="Image">
<IM>
<![CDATA[X]AL9ZP?G+cBHe#'(:o*T9+lO^&<S/"XGER'cnr6e<!0'5OWmd:6nf3LWhAuj![;1Z&L)?(&Y
qrP1eCMH#T*h#@F'6!^jFs!?TU&fm`b.Fbl-?c>8ms3OL,Q!!!$/)RNac\?LBBt^j5A@##57
#U/.mbNU9*Id&4R)*QFn%!aLtNo>Mo6pk"OU1ouBm,Kq8O[P^Ql+.8DY3%7ah5d=,8"j`brl
S^6WHC\`HWfZK8,8ptgE\:D@8J/<iOk#V:,:ON,/FIQ2H9H<nV8PsOIo(&t2f^<4-UN5,W&"
.>Qk(3<"o/,-e1L+FrAmCh/tbgF56s"8_O-6@?@`&6'pb5#n?G2n98/m_WN!,%Wnj=EfsURS
#iP?IlQ375aQ-?Mq_i=ZXfSEM/Ih,nrOmV8Vc*6*5D;"P.C;<m!-@n>F1o7E@?AOf:gp+9@5
F+PQD8j1Zp-qY$A7<k7jOC"-'+U4#-l@P?aSLt<kO!T33i>i-u\rVf=<UID`f%D]A_S;iI\U.
np8+u"E:RKG@/t:SY<rYiT"N[<T'\UFWU)H'POs3ufLYD>7-+J)rFgj)5l<1.MuH,IdXsHE:
oQopIO4@t:oMh82g/t*YM!Id@'b$Zn8r,RoP-trnJ?o%BTHPs9s.MnJS3(<7j4SnBc\MXQ>_
*t$J\i/7,i(p0]A.bPs.Zs^[-O`s,5g+++@)[/Y1]A'D]AA08BA;[UW;?351mpr/%mgn'9Q*^C)
k80qQ!Uk*C3#_11_Xn&9A7Yc'j#5NKSsjW)+ar%m>W1m3YrWZer@6eXluAJ%Va%&hj#"`Q*U
234c?CN/dDY]A&o4),W.?pP?8r!p)]A)mNMr#aQ_:TF_#]A&$dPf8BD=N;]A6:U`KP+3Y4fa-RN;
[GWdpn:o;"O]A@M@J!MT^34/20_b>f-0i,HL"@2>pIA11\dH,\Jl4Zu`]ALsI</^N!o-'Wh/_3
?TYkmfWf!`QgGaT)u!omFRF9WTf5)hM.k$\_]A@r*_=Eq^MXGe]A]A&pFAu8#iTtkHoq9lEhg9?
j-IXCl\>[a7r3s:-Ii!";0KtOnneF`q#LUF!OM)NFnTkr&fiW>VFe*%Y#lq$/0,hhMoJ93_S
#eI#/SI=^Si9h9,:isRM]Ase:adhU!Mlc[V3mk3@<@&dE5f-EYeLqUn0`HO``+=oqY&t?3gqI
W+r!'Um0$lFmJ4CRqJ*<amQgQl/[52&MUFUXqEAFI4ibsf&?OHXMf`SA:bKX?*gR"+h2q?$0
$E>,c5:;%hVicFt5V.J`LlL&Q_q?,tj),Pa0<o:`0c$HN(2;BAdfB0?n3"#><,0\30h^OFI%
cQS3@%3CF=n&'ClFti?<'<\;k?3QNS-c_3e&fZDjF4"kQQjZKiF4a)$]Am%/s+=/B57;M^"G1
q9-Q)>mmpk(7\[j#f:+P@==o:/QS<5QT$Q)*Xs&i)fPb,/7#co6J:hO)H(uj-3N/&*S*Rua$
7#+';">jut..qMPWL(g:MmR^./8?:un]AiK'>*M*d"_']As8h4f=I<(Hfe+f<*VhRTa:1rRe1i
LQhd_BV1TLXq!0i=8(^Eh!M-d?QFBp[)W>+8W=nn-SHeo>]Ai[32c3fSFe:J0>m:HS!-S3_W4
\[%""R0t6dr*'fY.R:mhZ)B25I!J7eZag<c.G5f,j5N4F/>XZqLL+,&]AT+\F-:r(Lt7njm1e
f9ZI\*mG?Nji]An*P,KVVYM1.U!^%omgFS"QpX))*\#Ue?_r2DbfgsgkC#R]Ap!J:JJb/H16rE
(XTblWrJi$Tp-Gne"cK,u5^2d)7[L1^qiGjlJTf3%,DFs:O#9aT.,gf.S7@$)oD!U$Nntb>F
-HKn6AgSc"s6L.3);0lj^U^)8=`sh,UFg6G!+X@pK\Zm]A&n<4@b3\NG9n9mMf>.n<Tnc$kRm
eY2k`MqIl&oRk>'p:1%h`Tk2_6=+MMg@OJ^:@gPDDlBK`NsM4dP!o.`_@1eQkBq1UFLQq<TM
6jSNJ:O]Ah(7p2E'SS-@O82lY6WK026Y[L.e0S#@!dr*0ECg;p:U2.X42^geGJ-RRC*fc'd;e
Dk150Cf!%o<(pioW/V4!GU:;.hE`j.4Kg[mW^lle&0[]A^HanP(npQ4/j2j\ch>sng'aN1#P)
,denpUNB3LW=mld,([P4+RB3?@kW%^k'01a7H;k0?giQfjcT$2NMpKO@kST%K&5.pmRV\Xd<
a>m+spOe$&h@eJ5*i$7pEW+;L`V(_BA:F8Cpuk*72`W"XdQWIa`/-DTd_UCk>]Ac>#]Aqm"HOR
t0;0_imm>S"#1YOe7_]AW2FoCXb(Mm!SQ3XFl&'dPJa^CE#t3QGKd26Xu,Md!b&df2OkDLmTC
8AhJG9E$4&WI4u%g7c+C199C^Tct$l;-]ATZ^DDEr<lo-d!3#QAqC7FUBp7Vs<N]AL6OGg/D4@
?9;*O/@3R73,)1ln%ok^;'qbHh?O-@&IJY8Vc&;6l3o=0cIUFmD706:>r".-4EA[ct=-ON;r
-gO2r#2j.O'<Th:q.'p7ac"T=.Jk;ED1R5B&]Ak-&pBnn\jFg(gWJcW.6T!hmU7g=!HL)fYe4
aA:k;Rr5^n>)hL0ec":!Tog,cR79WIKuQ,jNZ+AIZ_'=,Y*r5;9:;l#EMVU8Q^I&/:s7smqs
OK['8t.*"?frVkiUApf_S,p..!.A3RY<Bo))eR5#16XUD5WUkS1Ya#O1c-:7LPpWTNMQPL%^
jQ_QED/d01Wk/=GtW<nBP>\j4OZ_1UB[bIL>Aoh<B[VcI`jq]AdlX=V*@ac`h5'uSB]AYj:`*,
RgXR8qbhgQ3-neq:$Br*^&I"DO[aj.8&d:+jLeqYq,gO#1P[uShI-7G^rnaa[m02PUqNMrC@
U7"?=\J.UH8D?&3bBY*3Z4kcp@%rHB,(LCuaQ'_!l2VK#Pmb_[a-.?a3;&rF5CCAE$m>ONcJ
.>/&pPe;1!H4;q?Q#=HtFl\<(fP<ML-+aSco_5^XP;Q_&/d1j&;b+tV\2Gi'C$dJ->n3mfO<
F8/C/ZR@BW`kEps*C^VV7hO0uoPPB7gZ)2nP,j?2:`Olu\iChW%99(1!Y.A[m($nYhr?l+]A,
:`8[VA;Y(ff+-Rg*qBSl[./1GGr8Mo<4tW$P@2<augk`G!G5`KsZ"OS=FooTH8d[E!5s$=&Z
n%_8^.*KOr=KU&li?60?nrraT^opiC"CiFQQC//?<!6H7kP8c@UpH1PUo_iU1D/ERRggu]At_
='eV">B#N6Co5PS;LS\+_&o<Q>b]ATDpZ2V5ciQ3=l_ED9bPK-e^Fq*hPILB?moT@f6`XH[;V
3Gn*Eq@<9%@%l6t[6NEG9Dd#)s4+hQ5H\%PDNE5:--gPAkX(-lm2L)Ehu@/CGQcnFFF#&"@l
9:J>R^I,]A4FOBWpTTo@JT$^&hq'R5E,VeQAUQ1\ul"3@BLT8Dd@7YGHVKK\8"jU#seW)SIsM
T!4^]A5p*"8<ha,^m(f!`APC?gN"n^<I&gm,o'I5t\Zl'RX`,>VJ8Sr7"grAEn.iItF!u&qUC
=\n['Qn*[X.M[%Odo[7*XkuYSVf`V4NHJ&p,/3J&pU0.OQOn_pHq[^EQrD5<kX.[HO(2N9)>
HgS@mLmG3>)`1/8$Cbdhs!,S?jr^d*<^_KP#eZHa!C0b$`=W'EAS*Na$Y??H(;[JU#m^t5us
47"Z`ElLPf%1]Ah)Lp"3>kaG90_X*0r$ejJm\eht=$-0?K[O0XKBn(&Cq.bO&=#Yn(jknaPDI
_n4X#[YQ0UD@*D#KXRS_<Ln@@(;>;"Hg%QtC_d[f3"<#=t$mc<Hr5KAht*H^gO90j]As"a6fW
g^E$Gf'@lY2.D$8JgQTML4reVLmK)B9hea3N$k*PiNZ!&G@hJ4t59gRSlS*"8L9UUB!SIg+R
%Aj:[Vs#!@q=kB&0NT"brD1,WNKp-]A]AXq9`,=%^etJ""4u%W3ig_c$@oh;>3ki%orp(MaTHl
<Pj?&WAKV^)F5EFXmk#*.^0%"%E30IGU>0/o_#:Bi9WFEK`%UM5W7L/`s-T#$<aOK9Lre78b
2MS.jjGfjB0LTQR;c#_A+-nb47Md:s4N4C"g?qY\6@l,11cf@IZe)1<c7j"BV80=U5=1$*5,
R&t>h:h#./Xhah[ae`@_=UbETWQLj2>bd='m\50eG6`O:I6hDK!/=VA\oA'2L,1?;i/rIpdZ
M^q[c$F/]A)&LJTQr#\V!OGcEX[Z;&UogE:=]Aiu>2"`b+lK8(\[ek;rf8lg2r%iN0/D9TYa,J
R-4^8@[Ci&bXG20E%E(gKX>3+C>U/ANfcc>L#(CAj57$'E6_:g733JVZrp`i*dEAi<65+'G1
pC*[R`JBPITYopHPkjjd(tTdK;o]AF-P2X[6K>a-OPel'4Bo7NB@#oOX8C]A"XT5&6_3k<]AFc,
O@.loNU6',]AUB'Q%:TH`(82+!/IA_8\SdPHIa(E-L0S!!SBB%&@c$g,9L[m@d@SJN^=)ki"V
h)='?bj/?4"Xks(K_eYkRJ`(?JKt$UA*6)S'GbQOeb'O7+YH-c_RY[#s4GEVg?NZ6'a*s3Cp
2Gpi<Z:OTjYbp0B1O/N%/1E4fCb;Z0q#6~
]]></IM>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="2" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="2" cs="4" s="3">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="06级及以上猎头使用优化率" + "<span>" + "&nbsp" + "&nbsp" + "&nbsp" + "</span>" + "<span style='text-decoration:underline; color:#0000ff; font-weight: bold;'>" + format(C12,"#0.0%") + "</span>"]]></Attributes>
</O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="网页链接1">
<JavaScript class="com.fr.js.WebHyperlink">
<JavaScript class="com.fr.js.WebHyperlink">
<Parameters>
<Parameter>
<Attributes name="date_time"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$date_time]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="dwmc"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$dwmc]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="username"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=C14]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_self]]></TargetFrame>
<Features width="600" height="400"/>
<URL>
<![CDATA[/WebReport/ReportServer?formlet=HXXF_HR/HR_QUIT/Management_LTQD.frm]]></URL>
</JavaScript>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="5" r="2" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="3" s="5">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="3" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="3" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="3" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="3" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="3" s="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="4" s="5">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="4" s="8">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="4" s="8">
<O>
<![CDATA[06级及以上\\n猎头招聘人数]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="4" s="8">
<O>
<![CDATA[06级及以上\\n招聘总数]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="4" s="8">
<O>
<![CDATA[06级及以上\\n猎头招聘占比]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="4" s="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="5" s="5">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="5" s="8">
<O>
<![CDATA[全年]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="5" s="8">
<O t="DSColumn">
<Attributes dsName="猎头使用优化率" columnName="LTS"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[IF(LEN($$$)=0,"-",$$$)]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="3" r="5" s="8">
<O t="DSColumn">
<Attributes dsName="猎头使用优化率" columnName="QBS"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[IF(LEN($$$)=0,"-",$$$)]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="4" r="5" s="9">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(LEN(C6) = 0, "-", C6 / D6)]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="5" s="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="6" s="5">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="6" s="8">
<O>
<![CDATA[当月]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="6" s="8">
<O t="DSColumn">
<Attributes dsName="猎头使用优化率" columnName="LTSDY"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[IF(LEN($$$)=0,"-",$$$)]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="3" r="6" s="8">
<O t="DSColumn">
<Attributes dsName="猎头使用优化率" columnName="QBSDY"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[IF(LEN($$$)=0,"-",$$$)]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="4" r="6" s="9">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(LEN(C7) = 0, "-", C7 / D7)]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="6" s="10">
<O>
<![CDATA[ ]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="7" s="5">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="7" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="7" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="7" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="7" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="7" s="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="8" s="5">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="8" cs="2" s="8">
<O>
<![CDATA[2017年06级及以上\\n猎头使用比]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="8" cs="2" s="8">
<O>
<![CDATA[2018年06级及以上\\n猎头使用比]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="8" s="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="9" s="5">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="9" cs="2" s="9">
<O t="DSColumn">
<Attributes dsName="猎头使用优化率" columnName="NCLV"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[IF(LEN($$$)=0,"-",$$$)]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="3" r="9" cs="2" s="9">
<O t="DSColumn">
<Attributes dsName="猎头使用优化率" columnName="LV"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[IF(LEN($$$)=0,"-",$$$)]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="5" r="9" s="10">
<O>
<![CDATA[ ]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="10" s="5">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="10" s="8">
<O>
<![CDATA[年度优化目标]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="10" cs="2" s="8">
<O>
<![CDATA[当前执行情况]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="10" s="8">
<O>
<![CDATA[是否达标]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="10" s="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="11" s="5">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="11" s="11">
<O t="DSColumn">
<Attributes dsName="LZRATE" columnName="LT_06_Y"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[IF(LEN($$$) = 0 ,"-",$$$)]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="2" r="11" cs="2" s="9">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=ROUND((1 - D10 / B10),3)]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="11" s="12">
<O>
<![CDATA[●]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[C12 < B12]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.FRFontHighlightAction">
<FRFont name="SimSun" style="0" size="144" foreground="-4259840"/>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[C12 >= B12]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.FRFontHighlightAction">
<FRFont name="SimSun" style="0" size="144" foreground="-6697984"/>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性3]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[B12 = "-"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.FRFontHighlightAction">
<FRFont name="SimSun" style="0" size="64"/>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="5" r="11" s="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="12" s="13">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="12" s="14">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="12" s="14">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="12" s="14">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="12" s="14">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="12" s="15">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="13" s="16">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="13" s="16">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="13" s="16">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$username]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="13" s="16">
<O t="DSColumn">
<Attributes dsName="猎头使用优化率" columnName="LJYHMB"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="4" r="13" s="17">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(LEN(D10) = 0, 0, ROUND((1 - D10 / B10), 4))]]></Attributes>
</O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="网页链接1">
<JavaScript class="com.fr.js.WebHyperlink">
<JavaScript class="com.fr.js.WebHyperlink">
<Parameters>
<Parameter>
<Attributes name="date_time"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$date_time]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="dwmc"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$dwmc]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_self]]></TargetFrame>
<Features width="600" height="400"/>
<URL>
<![CDATA[http://10.2.98.8:8080/WebReport/ReportServer?formlet=HXXF_HR%2FHR_QUIT%2FManagement_LTQD.frm]]></URL>
</JavaScript>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.ListCondition"/>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="5" r="13" s="16">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="14">
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
<FRFont name="微软雅黑" style="1" size="112"/>
<Background name="ColorBackground" color="-1"/>
<Border/>
</Style>
<Style imageLayout="4">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-1"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-397858"/>
<Border>
<Top style="1" color="-1710619"/>
<Left style="1" color="-1710619"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="1" size="96"/>
<Background name="ColorBackground" color="-397858"/>
<Border>
<Top style="1" color="-1710619"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-397858"/>
<Border>
<Top style="1" color="-1710619"/>
<Right style="1" color="-1710619"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-67344"/>
<Border>
<Left style="1" color="-1710619"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-67344"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-67344"/>
<Border>
<Right style="1" color="-1710619"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-1"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0.0%]]></Format>
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-1"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="136"/>
<Background name="ColorBackground" color="-67344"/>
<Border>
<Right style="1" color="-1710619"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0%]]></Format>
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-1"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="144" foreground="-6697984"/>
<Background name="ColorBackground" color="-1"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-67344"/>
<Border>
<Bottom style="1" color="-1710619"/>
<Left style="1" color="-1710619"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-67344"/>
<Border>
<Bottom style="1" color="-1710619"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-67344"/>
<Border>
<Bottom style="1" color="-1710619"/>
<Right style="1" color="-1710619"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="2" imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0.0%]]></Format>
<FRFont name="微软雅黑" style="1" size="96"/>
<Background name="ColorBackground" color="-1"/>
<Border>
<Top style="1" color="-1710619"/>
</Border>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<isShared isshared="false"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="0" zoom="true" refresh="false" isUseHTML="false"/>
</InnerWidget>
<BoundsAttr x="297" y="0" width="301" height="280"/>
</Widget>
<body class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="report6"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Margin top="1" left="1" bottom="1" right="1"/>
<Border>
<border style="1" color="-4144960" borderRadius="0" type="0" borderStyle="0"/>
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
<![CDATA[723900,1714500,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,7696200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1">
<O>
<![CDATA[06级以上猎头去到使用优化率]]></O>
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
<BoundsAttr x="297" y="31" width="301" height="280"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="MC"/>
<WidgetAttr invisible="true" description="">
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="所选组织："]]></Attributes>
</O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="4" autoline="true"/>
<FRFont name="SimSun" style="0" size="72"/>
<border style="0" color="-723724"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="63" height="31"/>
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
<Margin top="0" left="8" bottom="0" right="5"/>
<Border>
<border style="0" color="-1710619" borderRadius="0" type="0" borderStyle="0"/>
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
<![CDATA[1295400,0,1028700,304800,722880,722880,722880,722880,722880,722880,722880,722880,722880,216000,419100,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[360000,1296000,1296000,2552700,2880000,2044800,2044800,360000,2743200,2880000,2880000,2880000,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" cs="8" s="0">
<O>
<![CDATA[人员齐备监控]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="1" s="1">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="1" r="1" cs="7" s="2">
<O t="Image">
<IM>
<![CDATA[V,rL8'\rF)qn>JYV2uK*6S^*#+,ng7-/&$hOF?#TXN?WoPSr.cQeb?V^.lutU$RMI0QmYa`q
#VqrX$@:4SR^qS9mH_gumI6cZ;k(?"7.Mek<(E!.[FD%sF#F&,_jNN7@NB+D;eri&]AACBpqQ
9Cs>KH!"$N7!c:TW'@O[@<`k)WQD^T:1NRDg]AVs`*q)I\%:IIUaD<NX,_5;!TM29Y^LqJ_^o
.;sfRp2E'P[3`%_`s(L=stP'a2h)hUnuR(V84=OKb73IDhmsiIUl,ZY0q'V!=J>r)mO1\BQL
#0C-FP?KMf-?TlgJ)F&d+RZM7hVoD@A$jQ:;Xi@'Cu.m*6Aqm?UUREA-'c>&&]A<WN=grtClF
fJHWuQWM1U`D=l:6`)"u3p64D02bKq8(Z3'4*../13oqdALFY;AVKIg^!If2i-#]AWC@J/:<H
^X?5A?Q0(X<_rYE(PLs5?JBHnig+`?\'"^_M'N^XWgH3!$geSNu7Of1%R2p/0QW)12?P:bmN
A,>9P4m^IK&H'EO+=9lK5aIppRn6`ujkPV&m'eW?p#9+^A(7jXRGa"%No`jKb[P41KK>9`^D
aJ=q,T\*-4JUEA2Z'iim"JCpSAliEl7gF[>22`H`H6a>BXl5m^E0\Eh_l\>W@2%CBW8=!g)^
a8aHp2*dOuTPkhrFJ"U5LRO4f"ilQY-4Z"_-FV1*8Z&uGDHB$bbE)drNb_*[Au1/<)iaH:1h
`bg7<ee%=$nTa>)UJ9g(/7\9BS`(.L7ms>K"2Yp`lEPDKVR[QfV%Rt3/`">]A.q5j"U6EpLA4
H"&m=(\9OG5(n'Bb?33rC`#8"X?kd&aG/%mY'W7oKZP`!cA%^b^`Fr9NDT&HJ.f<F4J]Ab&mc
OL!_Q_3AN8VV&e/6/1Y+PU^dG4'L,,[!:^'3A`#:l[j4Yh1J7QA.f&rG^8-NRc5EmfKY>\30
l_c<7'N,4;TOB]AA2QROn"(B-5.,H+j.s<!`+0d)WA)P=m;T`^4uNG,]A8>F$fMQ,mG:4.XHMm
)9'5)W_1jF>f_*^]A>W;j<7.YjVCo#+FT[b^Wt)E)1)="#;+'-I"3Q#>hg[d"FUJ)r#-=J)d@
<`SND@V6'KFc=Q:8@c:CVO+L<ma6blMM6$L7Tu`&<XT$s6=@,L?\SXZ=m=rg'7T^=qXnWl*M
Qf,=)=8Sb=YPlTN^4(H11OTMXe"!G@Rsm9$MQo_?n?H'f:+!.W28;>sZ#;9.6cC:BZbBA:Dk
+Af`>OF^nf2'5nrP1u18<pnmn*pBXppP8"*$qi)ID8Y2I`&"_3=X2e4E>1PkC)!t:_Ms.n_]A
!ts(oYmIV;75`3&W*<9(4:,$_3O0*B*4(l&.b:$U]A#dcd8[^9]AVaCkn82%P4PiuHg:Eb&RfI
3qg8!8!f#s1kP-GiCZgNCMBBajK^KlKSl*W0W!84XSoWP;(o5MuDFJ6'g#Wp3Kgk5)He%#)>
lk7Hb-.BAc\%J[g)&&,rU`,c\0SDN8bDh'J50^I/V#4iYRYYF5/8`90nm6.Z0nEV0H!oL:E3
)>6F=DKhV5/16R-@0tB1P_@>`?]A&=EXKC@T9V9*HqX(_u_r,([U"+h8AGOXGp7F'R@-tLV*R
a5'[SUP<0*N$2t;EGK@@\WX30Mm4ukGcDEp!_KlZ!q!C;'bHI%/)N*Mqk!Rt$9iQI-MWj1g.
*lo!;5f)'#kdN*;hY_2dV<cinl5;8A8#l+)BBKYC7kQA.J8?#6cD++4Z?k^jbJQ&/\&E9:$.
!:SLLjAVrc!cnUf++DfX+K(%bi@Gg#ETaa`_u)0EAS"]AjD55hDDoT;(=Q9U4YZL$5$)o%jGi
1_`!f\;>`EaP3+mmX[cdC1iY;aYXrAY0nDI7\taTYClV6#p!aN3&U8dbVeUs.f"R3#B?ru`3
tEG3uFCH3^ZCpfA)F,%0+htdqIh-,uX?(r7d!%c/F.Zg;RDgR<q5B`1kK.m3Ab0lb(sGI`$)
^:?PY#<'%U]A-W'Rg-;]AXRFeo9F!%r-3R[[e'Mb]AaC/PIfoUIh%FjD0)SoTP^23PlHdmkX*_H
hn7V.h8f)QM=d(7YR$E_2EQ.f=-=!8jS_<d,O'BSlJj3HcoRd;.W5H6\*E(l5uo/oqSC!EIt
'J&TL'JqI>-jR-2D/\7g]A8:1WKB!m$>f6Oe"m9(^f%Q&D_s8]AVTPRm<q1k<SW"^L=/ihtr>,
0#"B]An[$KbeeR)B5<koI8tuA9mJPd`7pWP5EO*j^]As094.nJDJFg<,qRX25X8c&f2`2Y1?D2
,]AFCXX4OfC_C>%(LbFZZ9f#ZELN("YtmPVI5nUe_Y?S3^^s12i5%2mHkC:AW=)E5hb?3-*.l
%!uNn=KO?#`d*/t->QH4-YbfBe!E`r'8V]A'YFC/L0(>qRr?4-D>7&SD\QF-\:XI:",7-==c=
uec=M9C'c@Qn`>%i280".X&jl`5UP21O6Hs%Lam!"sspWh59'3;om1,6@i]A4C1i/C\'8hf7b
sKL'GMaHuGXQ<($h0#\tGrD4K4KDFMrhOn.BmVYI<5'$u8mGT*Z3HBs+`jn)5og_Ro5>/k._
D6AA$3LO='cK6pcK07TkdQ#4']AF7\hkFMT%rbgRZnO)L@imPkaPu\(1-J^W:1Ni<)CLVk.^J
;\IXL$Dgm4SUidjAFFkIM!rhu@fO-SHmq/enH6P]A^*SLS?Lq]A`<%q9NEkop[r:;.P'JI'n9=
Lg*c32QWBFl&-;3c2Ti;$+B`sPC(r]AXfB&L4O3c-r@\f=egT:=3Z3(^>d&5ldFq1IN\gGU9,
HCM:GkqZ#r?r:rg\+Y0/aLi\o:/D2fU\=q?Jhq1R9_n%ZKOn00!trL[9i[(></>j>.6XrO:c
KFJ,U""1OYZ4\u6`]A;/(=!c8lWa2'M8YUGq2B1H':2F[Zpeoo8VM."!'qdhIcB8"u%T?D#fC
S`<m#\\300P0T:_4'Ca&i2'J;0khl]A8T@HlK7qb`IOQ:(_Gc\J67T*"FD+d.91PJ[(=[=;n-
AF9a;2dc)D0U<cI+CUBhV`<[jrV%DFe9UKJQb"?iT?$>;r4W1?`,jZ\r8i5G]AL(Yur8P\-Z,
,lGRXeO,He+WXpFMC+\'J>S=?2n1a'`5(U[=+uXaZWnMrL:#X,-XX(Ut--k16O7d&E]AaIuXf
_V%^EkCq$h:&s<0,%71fE\?j_q?qa86J%%;k;\4Nr;\rG'V7,"9H$585cnD7NI]A2:3DN/;pg
_pj+uH4JAqMZ`HIg@SK3[odiBq(,O#6"(SV[TVpPg`cSQ@8PV?=hWZODujd0m<>WFViG,X/c
chX`uZGc#Vd*4E.*n^k7Y3T%jJdhg;<E"Q"OfNiTF>AlAEXL`?Tt@YIHL3%:Hd?@D+Ft)Rc%
BjVA4OaH%YfgU7LI`gq:J?gcmjNVr#U=J<le;?MN2l=a(\R:ae)K-.*+Jk5$AP@BYQY;?/kM
$ik,%6X/P?:-h^^jnH[HjJJ]Aj+!^*Su`)=CZ0>"G2H"?$Fe&)_Zk'TniVDVHZ`,Sr>PMKN)9
2fc)\28TMmoicX+cRb%"2?s.l94.UWH6iOTTh6<NEjP(PiNA4%GP,dO!ud`G'+oO&NJ97-Sq
1,lusU7_S=nUGMU7bR[V@<iqBPU*W\pbDs%1E+("Y"('1j=]A#n3VT;s$W]AgC]A7HZ#%LIijB5
5aiMe3_,M*hmU8mpuj7tdrh(9NN_^0`-aRr(S2kK;[6*_nTE^9=5mBtIpf]ACjpQb]AKm@AT*/
/BuU]A.X\+f\7I@W/Y*Y&P*PDf#9fC&?3YojOMrP?pKt;<'h8'SrH5H0HdgP3.c$g/7K3r<,2
-??(-lPbA/H.l_T5QUZ$9fWMj$h6tbP1;kD$@2.cEDT>:`<'Wi*od.bMVK'rXV_rgirUBdRR
=2MPB5<:6h`p0=@*"DB8mZKUc?<7q@0@Dn22p>V4DXn3GkDh%jiO^WIHs4"&j'<HRFi3;hq:
g;gRlnQrHc#[l;s^mOflI6XDgQO1g$o&7"+e!Af?<l\>df7c1Y2j[I9COYILW!0;EIm/2@aB
&O257,&u6L6ZIFSUPjf%e0o@=A@=5dW/5uf<@]AjgGr[%5Y9DJ<7X(oqNl8oWO-^n?jQ@'g[M
Ec,T&"3bXQ.iH69i'#L+8+M_^i@0pAC[C>DIcU.Q^jk:>5HiC\uV\[d,-a2a!A!C9Z`(D$bY
mprF*QrUDmS)X6*,(icWV#+!NE989j0%`,Ns5K('XIdOQq'%H]AN<C-g&5heYIVenPodTDY:*
$]AYfK!Q%pdC'+6#aV8sjt0quU<T*e]Au<C\qBt'b]APSC,.4IX7">]ACob?-!F%8jRhN+nPT>St
=me#S7QjL_E71c]AIc8H;?gpD2G(hQ+eL1Bd*&Ye;Ghr_O(sinSmRSZmu%DB5dgbkA]A.\"Xs4
T'rStB&u<]AOWRM=X;-K!41[R>He+S!F7#p\SF,bs,1<Ybim(<T3H&.VD(otNo#S\\IAlM,U1
-UiQBIF/X<Y+"-;-5^.;W7Sk7*^%KBC>H7I@FcV3LNLU>M#!]A6!IJ-nh.S/@E/[P&]AOB0p2r
I"XS.;r^iDn>"cp[GeT,-G+&&)]A@^d?*A:36BB32Hp]A30T;Ag([^a9%Q@nACZT^4RfSUZ#e&
6]AT70sG5d5n8IfUtDabQYdiP7W1>$VsEAF;UTR$k-[BC]Ae4d;^&5'H.eR1X!jXg/!<F);m'=
H+lT,ZVcLN>M6Y+]A$=3Xhr)r&gs@M#AbXQ:c^YFC%@6HR(?8$,,(ei?QqZGB'q<Nq+A=SZ3p
mk9k`3IT"L6Gb^<JQ`T_Ku,X]A*h63.M$SPVA\nPI\585q0cG9!9N[-QPg%@)E9QWfD#tWX/)
L/@W6[;G>Bs;/[5Iu$VqSlZ4;ZX65?g`CMF!!W)g3bZC+q02fr""$A3l0$gfOj^XIW@"kXpg
AL9j>Xa!N`fMB\'jm\*sD%4g>mR&LS8C_$n7oC]Ag8>'XP/#Ta:h1G'Z:]AJpaMXt2"^BGhLh'
8Ck-fG]AtJ`^@7Ij"0ui;aOuhJUm%8kseO47WVf#J'[HZmRe<2&^q^!oVITC^n58.?=2T5W<d
;6f7XOoQtU(bcO#cDU&Lh#eSH)_WB'DH?OOOqGK-E^/%H<thUV4Qf%2X2eS7+bruV~
]]></IM>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="0" r="2" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="2" cs="6" s="4">
<O>
<![CDATA[用工监控]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="2" s="5">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="3" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="3" s="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="3" s="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="3" s="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="3" s="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="3" s="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="3" s="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="3" s="8">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="4" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="4" s="9">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="4" s="9">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="4" s="9">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="4" s="10">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=LEFT($DATE_TIME, 10)]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="4" s="10">
<O>
<![CDATA[年初]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="4" s="10">
<O>
<![CDATA[增幅]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="4" s="8">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="5" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="5" cs="3" s="10">
<O>
<![CDATA[总人数]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="5" s="10">
<O t="DSColumn">
<Attributes dsName="用工监控1(NEW)" columnName="ZRS"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.SummaryGrouper">
<FN>
<![CDATA[com.fr.data.util.function.SumFunction]]></FN>
</RG>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="5" s="10">
<O t="DSColumn">
<Attributes dsName="用工监控2" columnName="ZRS"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.SummaryGrouper">
<FN>
<![CDATA[com.fr.data.util.function.SumFunction]]></FN>
</RG>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="5" s="11">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(OR(F6 = 0, F6 = ""), "-", (E6 - F6) / F6)]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[F6 = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="7" r="5" s="8">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="6" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="6" cs="3" s="10">
<O>
<![CDATA[主营]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="6" s="10">
<O t="DSColumn">
<Attributes dsName="用工监控1(NEW)" columnName="ZYRS"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.SummaryGrouper">
<FN>
<![CDATA[com.fr.data.util.function.SumFunction]]></FN>
</RG>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="6" s="10">
<O t="DSColumn">
<Attributes dsName="用工监控2" columnName="ZYRS"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.SummaryGrouper">
<FN>
<![CDATA[com.fr.data.util.function.SumFunction]]></FN>
</RG>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="6" s="11">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(OR(F7 = 0, F7 = ""), "-", (E7 - F7) / F7)]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[F7 = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="7" r="6" s="8">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="7" s="12">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="7" cs="3" s="13">
<O>
<![CDATA[主营（不含财务）]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="7" s="14">
<O t="DSColumn">
<Attributes dsName="用工监控1(NEW)" columnName="ZYRSBHCZ"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.SummaryGrouper">
<FN>
<![CDATA[com.fr.data.util.function.SumFunction]]></FN>
</RG>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="7" s="14">
<O t="DSColumn">
<Attributes dsName="用工监控2" columnName="ZYRSBHCZ"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.SummaryGrouper">
<FN>
<![CDATA[com.fr.data.util.function.SumFunction]]></FN>
</RG>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="7" s="15">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(OR(F8 = 0, F8 = NULL), "-", (E8 - F8) / F8)]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[F8 = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="7" r="7" s="16">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="8" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="8" cs="3" s="17">
<O>
<![CDATA[主营（不含17/18常青藤）]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="8" s="10">
<O t="DSColumn">
<Attributes dsName="用工监控1(NEW)" columnName="ZYBHYQYBRS"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.SummaryGrouper">
<FN>
<![CDATA[com.fr.data.util.function.SumFunction]]></FN>
</RG>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="8" s="10">
<O t="DSColumn">
<Attributes dsName="用工监控2" columnName="ZYBHYQYBRS"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.SummaryGrouper">
<FN>
<![CDATA[com.fr.data.util.function.SumFunction]]></FN>
</RG>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="8" s="15">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(OR(F9 = 0, F9 = NULL), "-", (E9 - F9) / F9)]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[F8 = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="7" r="8" s="8">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="9" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="9" cs="3" s="10">
<O>
<![CDATA[非主营]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="9" s="10">
<O t="DSColumn">
<Attributes dsName="用工监控1(NEW)" columnName="FZYRS"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.SummaryGrouper">
<FN>
<![CDATA[com.fr.data.util.function.SumFunction]]></FN>
</RG>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="9" s="10">
<O t="DSColumn">
<Attributes dsName="用工监控2" columnName="FZYRS"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.SummaryGrouper">
<FN>
<![CDATA[com.fr.data.util.function.SumFunction]]></FN>
</RG>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="9" s="11">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(OR(F10 = 0, F10 = ""), "-", (E10 - F10) / F10)]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[F10 = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="7" r="9" s="8">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="10" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="10" cs="3" s="10">
<O>
<![CDATA[干部]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="10" s="10">
<O t="DSColumn">
<Attributes dsName="用工监控1(NEW)" columnName="GBYRS"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.SummaryGrouper">
<FN>
<![CDATA[com.fr.data.util.function.SumFunction]]></FN>
</RG>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="10" s="10">
<O t="DSColumn">
<Attributes dsName="用工监控2" columnName="GBYRS"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.SummaryGrouper">
<FN>
<![CDATA[com.fr.data.util.function.SumFunction]]></FN>
</RG>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="10" s="11">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(OR(F11 = "", F11 = 0), "-", (E11 - F11) / F11)]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[F11 = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="7" r="10" s="8">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="11" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="11" cs="3" s="17">
<O>
<![CDATA[常青藤（不含实习生）]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="11" s="10">
<O t="DSColumn">
<Attributes dsName="用工监控1(NEW)" columnName="CQTYRS"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.SummaryGrouper">
<FN>
<![CDATA[com.fr.data.util.function.SumFunction]]></FN>
</RG>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="11" s="10">
<O t="DSColumn">
<Attributes dsName="用工监控2" columnName="CQTYRS"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.SummaryGrouper">
<FN>
<![CDATA[com.fr.data.util.function.SumFunction]]></FN>
</RG>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="11" s="11">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(OR(F12 = "", F12 = 0), "", (E12 - F12) / F12)]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[F12 = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="7" r="11" s="8">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="12" s="18">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="12" cs="3" s="17">
<O>
<![CDATA[常青藤（实习生）]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="12" s="10">
<O t="DSColumn">
<Attributes dsName="用工监控1(NEW)" columnName="CQTSXS"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.SummaryGrouper">
<FN>
<![CDATA[com.fr.data.util.function.SumFunction]]></FN>
</RG>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="12" s="10">
<O t="DSColumn">
<Attributes dsName="用工监控2" columnName="CQTSXS"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.SummaryGrouper">
<FN>
<![CDATA[com.fr.data.util.function.SumFunction]]></FN>
</RG>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="12" s="11">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(OR(F13 = "", F13 = 0), "", (E13 - F13) / F13)]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[F14 = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="7" r="12" s="18">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="13" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="13" cs="3" s="10">
<O>
<![CDATA[ ]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="13" s="10">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="13" s="10">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="13" s="10">
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="13" s="8">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="14" s="19">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="14" s="20">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="14" s="20">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="14" s="20">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="14" s="20">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="14" s="20">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="14" s="20">
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="14" s="21">
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
<FRFont name="微软雅黑" style="1" size="112"/>
<Background name="ColorBackground" color="-1"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-596788"/>
<Border/>
</Style>
<Style imageLayout="4">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-596788"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-596788"/>
<Border>
<Top style="1" color="-1710619"/>
<Left style="1" color="-1710619"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="1" size="96"/>
<Background name="ColorBackground" color="-596788"/>
<Border>
<Top style="1" color="-1710619"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-596788"/>
<Border>
<Top style="1" color="-1710619"/>
<Right style="1" color="-1710619"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-594463"/>
<Border>
<Left style="1" color="-1710619"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-594463"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-594463"/>
<Border>
<Right style="1" color="-1710619"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-1"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-1"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0.0%]]></Format>
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-1"/>
<Border/>
</Style>
<Style imageLayout="1" paddingLeft="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-594463"/>
<Border>
<Left style="1" color="-1710619"/>
</Border>
</Style>
<Style horizontal_alignment="0" textStyle="1" imageLayout="1" paddingLeft="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-1"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1" paddingLeft="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-1"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1" paddingLeft="1">
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0.0%]]></Format>
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-1"/>
<Border/>
</Style>
<Style imageLayout="1" paddingLeft="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-594463"/>
<Border>
<Right style="1" color="-1710619"/>
</Border>
</Style>
<Style horizontal_alignment="0" textStyle="1" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-1"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="ColorBackground" color="-594463"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-594463"/>
<Border>
<Bottom style="1" color="-1710619"/>
<Left style="1" color="-1710619"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-594463"/>
<Border>
<Bottom style="1" color="-1710619"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-594463"/>
<Border>
<Bottom style="1" color="-1710619"/>
<Right style="1" color="-1710619"/>
</Border>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<isShared isshared="false"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="0" zoom="true" refresh="false" isUseHTML="false"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="297" height="280"/>
</Widget>
<body class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="report1"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Margin top="0" left="2" bottom="0" right="1"/>
<Border>
<border style="1" color="-4144960" borderRadius="0" type="0" borderStyle="0"/>
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
<![CDATA[990600,576000,266700,576000,533400,864000,864000,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[381000,1728000,432000,1728000,432000,3429000,432000,1728000,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
</C>
<C c="1" r="0" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="0" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="0" cs="5" s="1">
<O>
<![CDATA[用工监控]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1" s="2">
<O>
<![CDATA[总人数]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="1" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="1" s="4">
<O>
<![CDATA[主营]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="1" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="1" s="4">
<O>
<![CDATA[主营（不含财）]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="1" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="1" s="4">
<O>
<![CDATA[非主营]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="2" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="2" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="2" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="2" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="2" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="2" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="2" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="3" s="4">
<O>
<![CDATA[干部]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="3" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="3" s="4">
<O>
<![CDATA[常青藤]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="3" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="3" s="4">
<O>
<![CDATA[在途offer]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="3" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="3" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="4" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="4" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="4" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="4" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="4" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="4" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="4" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="5" s="5">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="5" cs="2" s="5">
<O>
<![CDATA[2018-04-16]]></O>
<PrivilegeControl/>
</C>
<C c="4" r="5" cs="2" s="5">
<O>
<![CDATA[年初]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="5" s="5">
<PrivilegeControl/>
</C>
<C c="7" r="5" s="5">
<O>
<![CDATA[增幅]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="6" s="5">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="6" cs="2" s="5">
<O t="I">
<![CDATA[15129]]></O>
<PrivilegeControl/>
</C>
<C c="4" r="6" cs="2" s="5">
<O t="I">
<![CDATA[15129]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="6" s="5">
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="6" s="6">
<O t="BigDecimal">
<![CDATA[0.059]]></O>
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
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="1" size="96"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72" foreground="-1"/>
<Background name="ColorBackground" color="-4259840"/>
<Border>
<Top style="1" color="-65536"/>
<Bottom style="1" color="-65536"/>
<Left style="1" color="-65536"/>
<Right style="1" color="-65536"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-65536"/>
<Bottom style="1" color="-65536"/>
<Left style="1" color="-65536"/>
<Right style="1" color="-65536"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-526345"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0.0%]]></Format>
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-526345"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<isShared isshared="false"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="0" zoom="true" refresh="false" isUseHTML="false"/>
</body>
</InnerWidget>
<BoundsAttr x="0" y="31" width="297" height="280"/>
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
<![CDATA[=sql("HXXF_HR","SELECT descr  as PARENT_NAME FROM (SELECT * FROM ODM_HR_DW WHERE tree_node NOT IN (SELECT tree_node from  ODM_HR_DW  where 1=1 AND  descr = '集团总部') UNION ALL SELECT '2908' AS SETID,	'10040105798' AS TREE_NODE,	'100000' AS PARENT_NODE,	20100	AS TREE_NODE_NUM,	'' AS HX_PARENT_SETID ,'产业新城集团总部' AS DESCR,	'1' AS BACK,	'1' AS BACK_ANA,	'HX_HEAD,100000,10040105798' AS PARENT_NODES,	'华夏幸福<产业新城集团<集团总部' AS PARENT_NAME FROM dual UNION ALL SELECT 	'278' AS SETID,	'22222' AS TREE_NODE,	'10041105853'AS PARENT_NODE,30100 AS TREE_NODE_NUM,	'' AS HX_PARENT_SETID ,'产业小镇集团总部'AS DESCR,'1' AS BACK,	'1' AS BACK_ANA,	'HX_HEAD,10041105853,22222,' AS PARENT_NODES,	'华夏幸福<产业小镇集团<集团总部' AS PARENT_NAME FROM dual UNION ALL SELECT	'2059' AS SETID,'44444' AS TREE_NODE,	'10004100730' AS PARENT_NODE,40100 AS TREE_NODE_NUM,'' AS HX_PARENT_SETID ,	'产业发展集团总部'AS DESCR,	'1' AS BACK,	'1' AS BACK_ANA,	'HX_HEAD,10004100730,44444,' AS PARENT_NODES,	'华夏幸福<产业发展集团<集团总部'AS PARENT_NAME FROM dual UNION ALL SELECT	'1282'AS SETID,	'55555'AS TREE_NODE,	'10003100439'	AS PARENT_NODE,50100 AS TREE_NODE_NUM,'' AS HX_PARENT_SETID ,	'孔雀城住宅集团总部'AS DESCR,	'1' AS BACK,	'1' AS BACK_ANA,	'HX_HEAD,10003100439,55555,' AS PARENT_NODES,	'华夏幸福<孔雀城住宅集团<集团总部'  AS PARENT_NAME FROM dual) where tree_node='"+DWMC+"' ",1)+"管理监控综合报告"+" （"+IF($date_time=LEFT(NOW(),10),YEAR(NOW())+"年"+RIGHT(LEFT($date_time,7),2)+"月"+DAY(NOW())+"日",YEAR(NOW())+"年"+RIGHT(LEFT($date_time,7),2)+"月")+"）"]]></Attributes>
</O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="0" noWrap="true" autoline="true"/>
<FRFont name="微软雅黑" style="1" size="128" foreground="-4125163"/>
<border style="0" color="-723724"/>
</InnerWidget>
<BoundsAttr x="230" y="0" width="427" height="31"/>
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
<Margin top="0" left="8" bottom="0" right="5"/>
<Border>
<border style="0" color="-1116417" borderRadius="0" type="0" borderStyle="0"/>
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
<![CDATA[1219200,288000,723900,723900,723900,723900,1143000,723900,723900,723900,304800,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[360000,2743200,2743200,2743200,2743200,360000,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
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
<C c="1" r="0" cs="4" s="1">
<O>
<![CDATA[2018级常青藤校招监控]]></O>
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
<C c="5" r="0" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="1" s="3">
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
<C c="1" r="1" s="3">
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
<C c="2" r="1" s="3">
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
<C c="3" r="1" s="3">
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
<C c="4" r="1" s="3">
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
<C c="5" r="1" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="2" s="4">
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
<C c="1" r="2" cs="4" rs="8" s="5">
<O>
<![CDATA[该功能即将上线，敬请期待……]]></O>
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
<C c="5" r="2" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="3" s="4">
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
<C c="5" r="3" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="4" s="4">
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
<C c="5" r="4" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="5" s="4">
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
<C c="5" r="5" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="6" s="4">
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
<C c="5" r="6" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="7" s="4">
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
<C c="5" r="7" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="8" s="4">
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
<C c="5" r="8" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="9" s="4">
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
<C c="5" r="9" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="10" s="7">
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
<C c="1" r="10" s="8">
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
<C c="2" r="10" s="8">
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
<C c="3" r="10" s="8">
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
<C c="4" r="10" s="8">
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
<C c="5" r="10" s="9">
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
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-596788"/>
<Border>
<Top style="1" color="-1710619"/>
<Left style="1" color="-1710619"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="1" size="96"/>
<Background name="ColorBackground" color="-596788"/>
<Border>
<Top style="1" color="-1710619"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-596788"/>
<Border>
<Top style="1" color="-1710619"/>
<Right style="1" color="-1710619"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-594463"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-594463"/>
<Border>
<Left style="1" color="-1710619"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="80"/>
<Background name="ColorBackground" color="-1"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-594463"/>
<Border>
<Right style="1" color="-1710619"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-594463"/>
<Border>
<Bottom style="1" color="-1710619"/>
<Left style="1" color="-1710619"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-594463"/>
<Border>
<Bottom style="1" color="-1710619"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-594463"/>
<Border>
<Bottom style="1" color="-1710619"/>
<Right style="1" color="-1710619"/>
</Border>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<isShared isshared="false"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="0" zoom="true" refresh="false" isUseHTML="false"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="297" height="240"/>
</Widget>
<body class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="report4"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Margin top="1" left="1" bottom="1" right="1"/>
<Border>
<border style="1" color="-4144960" borderRadius="0" type="0" borderStyle="0"/>
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
<![CDATA[723900,723900,1143000,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="2">
<O>
<![CDATA[2018级常青藤校招监控]]></O>
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
<BoundsAttr x="0" y="311" width="297" height="240"/>
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
<Margin top="0" left="8" bottom="0" right="5"/>
<Border>
<border style="0" color="-1116417" borderRadius="0" type="0" borderStyle="0"/>
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
<![CDATA[1440000,0,419100,864000,864000,864000,864000,864000,419100,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[381000,2743200,2743200,2880000,2880000,360000,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
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
<C c="1" r="0" cs="4" s="1">
<O>
<![CDATA[财务条线干部齐备率（总部）]]></O>
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
<C c="5" r="0" s="2">
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
<C c="0" r="1" cs="6" s="3">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0" showAsHTML="true"/>
<CellPageAttr/>
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
<C c="0" r="2" s="4">
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
<C c="1" r="2" s="4">
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
<C c="2" r="2" s="4">
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
<C c="3" r="2" s="4">
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
<C c="4" r="2" s="4">
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
<C c="5" r="2" s="4">
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
<C c="0" r="3" s="5">
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
<C c="1" r="3" cs="4" rs="5" s="6">
<O>
<![CDATA[该功能即将上线，敬请期待……]]></O>
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
<C c="5" r="3" s="7">
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
<C c="0" r="4" s="5">
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
<C c="5" r="4" s="7">
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
<C c="0" r="5" s="5">
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
<C c="5" r="5" s="7">
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
<C c="0" r="6" s="5">
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
<C c="5" r="6" s="7">
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
<C c="0" r="7" s="5">
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
<C c="5" r="7" s="7">
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
<C c="0" r="8" s="8">
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
<C c="1" r="8" s="4">
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
<C c="2" r="8" s="4">
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
<C c="3" r="8" s="4">
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
<C c="4" r="8" s="4">
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
<C c="5" r="8" s="9">
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
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-596788"/>
<Border>
<Top style="1" color="-1710619"/>
<Left style="1" color="-1710619"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="1" size="96"/>
<Background name="ColorBackground" color="-596788"/>
<Border>
<Top style="1" color="-1710619"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-596788"/>
<Border>
<Top style="1" color="-1710619"/>
<Right style="1" color="-1710619"/>
</Border>
</Style>
<Style horizontal_alignment="0" vertical_alignment="1" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-1"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-594463"/>
<Border>
<Bottom style="1" color="-1710619"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-594463"/>
<Border>
<Left style="1" color="-1710619"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="80"/>
<Background name="ColorBackground" color="-1"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-594463"/>
<Border>
<Right style="1" color="-1710619"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-594463"/>
<Border>
<Bottom style="1" color="-1710619"/>
<Left style="1" color="-1710619"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-594463"/>
<Border>
<Bottom style="1" color="-1710619"/>
<Right style="1" color="-1710619"/>
</Border>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<isShared isshared="false"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="0" zoom="true" refresh="false" isUseHTML="false"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="297" height="183"/>
</Widget>
<body class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="report5"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Margin top="1" left="1" bottom="1" right="1"/>
<Border>
<border style="1" color="-4144960" borderRadius="0" type="0" borderStyle="0"/>
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
<![CDATA[723900,1714500,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,6896100,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1">
<O>
<![CDATA[财务条线干部齐备率（总部）]]></O>
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
<BoundsAttr x="0" y="703" width="297" height="183"/>
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
<Margin top="0" left="5" bottom="0" right="5"/>
<Border>
<border style="0" color="-1710619" borderRadius="0" type="0" borderStyle="0"/>
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
<![CDATA[1066800,762000,432000,864000,864000,288000,288000,288000,762000,144000,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[360000,2895600,3352800,0,3276600,3086100,360000,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="1" r="0" s="1">
<O t="DSColumn">
<Attributes dsName="XZFWB" columnName="GSB"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[ROUND($$$,4)]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="网页链接1">
<JavaScript class="com.fr.js.WebHyperlink">
<JavaScript class="com.fr.js.WebHyperlink">
<Parameters>
<Parameter>
<Attributes name="dwmc"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$dwmc]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="date_time"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$date_time]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_self]]></TargetFrame>
<Features width="600" height="400"/>
<URL>
<![CDATA[http://10.2.98.8:8080/WebReport/ReportServer?formlet=HXXF_HR%2FHR_QUIT%2FManagement_XZ.frm]]></URL>
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
<Condition class="com.fr.data.condition.ListCondition"/>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="2" r="0" cs="4" s="2">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="行政人均服务改善比  " + "<span>" + "&nbsp" + "&nbsp" + "&nbsp" + "</span>" + "<span style='text-decoration:underline; color:#0000ff; font-weight: bold;'>" + FORMAT(B1,"0.0%") + "</span>"]]></Attributes>
</O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="网页链接1">
<JavaScript class="com.fr.js.WebHyperlink">
<JavaScript class="com.fr.js.WebHyperlink">
<Parameters>
<Parameter>
<Attributes name="dwmc"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$dwmc]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="date_time"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$date_time]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="username"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$username]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_self]]></TargetFrame>
<Features width="600" height="400"/>
<URL>
<![CDATA[/WebReport/ReportServer?formlet=HXXF_HR/HR_QUIT/Management_XZ.frm]]></URL>
</JavaScript>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<CellGUIAttr adjustmode="0" showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="6" r="0" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="1" s="4">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="1" r="1" s="5">
<O t="DSColumn">
<Attributes dsName="XZFWB" columnName="XZZZG"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand dir="0"/>
</C>
<C c="2" r="1" cs="4" s="6">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="当前行政人数  " + D3 + "  人，" + "主营人数  " + D4 + "  人"]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0" showAsHTML="true"/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[YEAR($date_time) + "-" + +MONTH($date_time) + "-" + DAY($date_time) = YEAR(TODAY()) + "-" + +MONTH(TODAY()) + "-" + DAY(TODAY())]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.HyperlinkHighlightAction">
<NameJavaScriptGroup>
<NameJavaScript name="JavaScript2">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="dwmc1"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$dwmc]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="date_time1"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$date_time]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="lei1"/>
<O>
<![CDATA[xz]]></O>
</Parameter>
<Parameter>
<Attributes name="tem"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$temp]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[var url = FR.cjkEncode('/WebReport/ReportServer?reportlet=/HXXF_HR/HR_QUIT/Cader_Leave_2.cpt&dwmc='+dwmc1+'&date_time='+date_time1+'&lei='+lei1+'&temp='+tem)
window.parent.parent.parent.$('#iframe2').attr('src',url);
window.parent.parent.parent.$('.smallIframe').show();
//window.parent.parent.parent.$('.model').show();
//window.parent.parent.parent.alldata.push([name_1,url]A);
//window.parent.parent.parent.$('.close').attr('_name',name_1)
window.parent.parent.parent.$('.smallIframe').css({
			width: '900px',
			height: '600px',
			left:'50%',
			top:'50%',
			marginLeft:'-450px',
			marginTop:'-300px'
		});
window.parent.parent.parent.isSmall = true;
/*/_g().parameterEl.getWidgetByName('YGID').setValue(id1);
$("#fr-btn-HR_LOG").find("button").trigger("click");
_g().parameterEl.getWidgetByName('YGID').setValue(null);*/]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
</HighlightAction>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="当前行政人数  " + "<span style='text-decoration:underline; color:#0000ff; font-weight: bold;'>" + D3 + "</span>" + "  人，主营人数  " + D4 + "  人"]]></Attributes>
</O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="6" r="1" s="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="2" s="8">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="2" s="9">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="2" s="10">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="2" s="10">
<O t="DSColumn">
<Attributes dsName="XZFWB" columnName="XZZZG"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="4" r="2" cs="2" s="10">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="2" s="11">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="3" s="8">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="3" s="9">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="3" s="12">
<O>
<![CDATA[年初服务比]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="3" s="9">
<O t="DSColumn">
<Attributes dsName="XZFWB" columnName="ZHUYING"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="4" r="3" s="12">
<O>
<![CDATA[当前服务比]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="3" s="12">
<O>
<![CDATA[服务改善比]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="3" s="11">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="4" s="8">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="4" s="9">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="4" s="12">
<O t="DSColumn">
<Attributes dsName="xzncfwb" columnName="NCWFB"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$+":1"]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="3" r="4" s="9">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="4" s="12">
<O t="DSColumn">
<Attributes dsName="XZFWB" columnName="RJFWGSB"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[IF(LEN($$$)=0,0,$$$)+":1"]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="5" r="4" s="13">
<O t="DSColumn">
<Attributes dsName="XZFWB" columnName="GSB"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="6" r="4" s="11">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="5" s="8">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="5" s="9">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="5" s="10">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="5" s="10">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="5" s="10">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="5" s="10">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="5" s="11">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="6" s="8">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="6" s="9">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="6" s="10">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="6" s="10">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="6" s="10">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="6" s="10">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="6" s="11">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="7" s="8">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="7" s="9">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="7" cs="4" s="14">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="7" s="11">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="8" s="8">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="8" s="9">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="8" cs="4" s="15">
<O>
<![CDATA[注：行政人数不含2018/2019常青藤,含2017常青藤  ]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition"/>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(MONTH($date_time,"yyyy-MM-dd")>=7,$$$,"注：行政人数不含2017/2018常青藤")]]></Attributes>
</O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="6" r="8" s="16">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="9" s="17">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="9" s="18">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="9" cs="5" s="19">
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
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-397858"/>
<Border>
<Top style="1" color="-1710619"/>
<Left style="1" color="-1710619"/>
</Border>
</Style>
<Style horizontal_alignment="2" imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0.0%]]></Format>
<FRFont name="微软雅黑" style="1" size="96" foreground="-16776961" underline="1"/>
<Background name="ColorBackground" color="-1"/>
<Border>
<Top style="1" color="-1710619"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="1" size="96"/>
<Background name="ColorBackground" color="-397858"/>
<Border>
<Top style="1" color="-1710619"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-397858"/>
<Border>
<Top style="1" color="-1710619"/>
<Right style="1" color="-1710619"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-397858"/>
<Border>
<Left style="1" color="-1710619"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-1"/>
<Border/>
</Style>
<Style horizontal_alignment="0" vertical_alignment="1" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-397858"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-397858"/>
<Border>
<Right style="1" color="-1710619"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-67344"/>
<Border>
<Left style="1" color="-1710619"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-67344"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-67344"/>
<Border>
<Right style="1" color="-1710619"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-1"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0.0%]]></Format>
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-1"/>
<Border/>
</Style>
<Style horizontal_alignment="4" vertical_alignment="3" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="64"/>
<Background name="ColorBackground" color="-67344"/>
<Border/>
</Style>
<Style horizontal_alignment="4" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="64"/>
<Background name="ColorBackground" color="-67344"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="ColorBackground" color="-67344"/>
<Border>
<Right style="1" color="-1710619"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-67344"/>
<Border>
<Bottom style="1" color="-1710619"/>
<Left style="1" color="-1710619"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Bottom style="1" color="-1710619"/>
</Border>
</Style>
<Style horizontal_alignment="4" vertical_alignment="3" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-67344"/>
<Border>
<Bottom style="1" color="-1710619"/>
<Right style="1" color="-1710619"/>
</Border>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<isShared isshared="false"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="0" zoom="true" refresh="false" isUseHTML="false"/>
</InnerWidget>
<BoundsAttr x="297" y="0" width="301" height="183"/>
</Widget>
<body class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="report3"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Margin top="1" left="1" bottom="1" right="1"/>
<Border>
<border style="1" color="-4144960" borderRadius="0" type="0" borderStyle="0"/>
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
<![CDATA[723900,1143000,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,3924300,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1">
<O>
<![CDATA[行政人均服务改善比]]></O>
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
<BoundsAttr x="297" y="703" width="301" height="183"/>
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
<Margin top="0" left="5" bottom="0" right="5"/>
<Border>
<border style="0" color="-1710619" borderRadius="0" type="0" borderStyle="0"/>
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
<![CDATA[1257300,1219200,432000,1600200,1143000,1485900,914400,1333500,1600200,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[360000,3352800,2743200,3619500,2743200,360000,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="1" r="0" cs="4" s="1">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="HR人均服务改善比  " + "<span>" + "&nbsp" + "&nbsp" + "&nbsp" + "</span>" + "<span style='text-decoration:underline; color:#0000ff; font-weight: bold;'>" +format(E9,"0.0%") + "</span>"]]></Attributes>
</O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="网页链接1">
<JavaScript class="com.fr.js.WebHyperlink">
<JavaScript class="com.fr.js.WebHyperlink">
<Parameters>
<Parameter>
<Attributes name="dwmc"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$dwmc]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="date_time"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$date_time]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="username"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$username]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_self]]></TargetFrame>
<Features width="600" height="400"/>
<URL>
<![CDATA[/WebReport/ReportServer?formlet=HXXF_HR/HR_QUIT/Management_HR.frm]]></URL>
</JavaScript>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<CellGUIAttr adjustmode="0" showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="5" r="0" s="2">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="0" r="1" s="3">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="1" r="1" cs="4" s="4">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="当前HR人数  " + C3 + "  人，" + "主营人数  " + C4 + "  人"]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0" showAsHTML="true"/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[YEAR($date_time) + "-" + +MONTH($date_time) + "-" + DAY($date_time) = YEAR(TODAY()) + "-" + +MONTH(TODAY()) + "-" + DAY(TODAY())]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.HyperlinkHighlightAction">
<NameJavaScriptGroup>
<NameJavaScript name="JavaScript2">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="dwmc1"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$dwmc]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="date_time1"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$date_time]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="lei1"/>
<O>
<![CDATA[hr]]></O>
</Parameter>
<Parameter>
<Attributes name="tem"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$temp]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[var url = FR.cjkEncode('/WebReport/ReportServer?reportlet=/HXXF_HR/HR_QUIT/Cader_Leave_2.cpt&dwmc='+dwmc1+'&date_time='+date_time1+'&lei='+lei1+'&temp='+tem)
window.parent.parent.parent.$('#iframe2').attr('src',url);
window.parent.parent.parent.$('.smallIframe').show();
//window.parent.parent.parent.$('.model').show();
//window.parent.parent.parent.alldata.push([name_1,url]A);
//window.parent.parent.parent.$('.close').attr('_name',name_1)
window.parent.parent.parent.$('.smallIframe').css({
			width: '900px',
			height: '600px',
			left:'50%',
			top:'50%',
			marginLeft:'-450px',
			marginTop:'-300px'
		});
window.parent.parent.parent.isSmall = true;
/*/_g().parameterEl.getWidgetByName('YGID').setValue(id1);
$("#fr-btn-HR_LOG").find("button").trigger("click");
_g().parameterEl.getWidgetByName('YGID').setValue(null);*/]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
</HighlightAction>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="当前HR人数  " + "<span style='text-decoration:underline; color:#0000ff; font-weight: bold;'>" + C3 + "</span>" + "  人，主营人数  " + C4 + "  人"]]></Attributes>
</O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="5" r="1" s="5">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="0" r="2" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="2" s="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="2" s="7">
<O t="DSColumn">
<Attributes dsName="HRFWB" columnName="HRZZG"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="3" r="2" s="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="2" s="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="2" s="8">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="3" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="3" s="9">
<O>
<![CDATA[服务改善比\\n年度目标]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="3" s="10">
<O t="DSColumn">
<Attributes dsName="HRFWB" columnName="ZHUYING"/>
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
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="3" r="3" s="9">
<O>
<![CDATA[累计年度目标]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="3" s="9">
<O>
<![CDATA[是否达标]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="3" s="8">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="4" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="4" s="11">
<O t="DSColumn">
<Attributes dsName="LZRATE" columnName="HR_Y"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[IF(LEN($$$)=0,'-',$$$)]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="2" r="4" s="10">
<O t="DSColumn">
<Attributes dsName="HRFWB" columnName="LJYHMB"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="3" r="4" s="12">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(B5='-','-',B5 * C5)]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="4" s="13">
<O>
<![CDATA[●]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[D5 > E7]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.FRFontHighlightAction">
<FRFont name="SimSun" style="0" size="144" foreground="-4259840"/>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[D5 <= E7]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.FRFontHighlightAction">
<FRFont name="SimSun" style="0" size="144" foreground="-6697984"/>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性3]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[B5='-']]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.FRFontHighlightAction">
<FRFont name="SimSun" style="0" size="64"/>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="5" r="4" s="8">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="5" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="5" s="9">
<O>
<![CDATA[年初服务比]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="5" s="10">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="5" s="9">
<O>
<![CDATA[当前服务比]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="5" s="9">
<O>
<![CDATA[服务改善比]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="5" s="8">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="6" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="6" s="9">
<O t="DSColumn">
<Attributes dsName="hrncfwb" columnName="NCWFB"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$+":1"]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="2" r="6" s="10">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="6" s="9">
<O t="DSColumn">
<Attributes dsName="HRFWB" columnName="RJFWGSB"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[IF(LEN($$$)=0,0,$$$)+":1"]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="4" r="6" s="12">
<O t="DSColumn">
<Attributes dsName="HRFWB" columnName="GSB"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="5" r="6" s="8">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="7" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="7" cs="4" s="14">
<O>
<![CDATA[注：HR人数不含2018/2019常青藤,含2017常青藤]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition"/>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(MONTH($date_time,"yyyy-MM-dd")>=7,$$$,"注：HR人数不含2017/2018常青藤")]]></Attributes>
</O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="5" r="7" s="15">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="8" s="10">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="8" s="10">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="8" s="10">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="8" s="10">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="8" s="16">
<O t="DSColumn">
<Attributes dsName="HRFWB" columnName="GSB"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[ROUND($$$,4)]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="网页链接1">
<JavaScript class="com.fr.js.WebHyperlink">
<JavaScript class="com.fr.js.WebHyperlink">
<Parameters>
<Parameter>
<Attributes name="dwmc"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$dwmc]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="date_time"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$date_time]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_self]]></TargetFrame>
<Features width="600" height="400"/>
<URL>
<![CDATA[http://10.2.98.8:8080/WebReport/ReportServer?formlet=HXXF_HR%2FHR_QUIT%2FManagement_HR.frm]]></URL>
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
<Condition class="com.fr.data.condition.ListCondition"/>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="5" r="8" s="10">
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
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-397858"/>
<Border>
<Top style="1" color="-1710619"/>
<Left style="1" color="-1710619"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="1" size="96"/>
<Background name="ColorBackground" color="-397858"/>
<Border>
<Top style="1" color="-1710619"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-397858"/>
<Border>
<Top style="1" color="-1710619"/>
<Right style="1" color="-1710619"/>
</Border>
</Style>
<Style vertical_alignment="1" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-397858"/>
<Border>
<Left style="1" color="-1710619"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-397858"/>
<Border/>
</Style>
<Style vertical_alignment="1" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-397858"/>
<Border>
<Right style="1" color="-1710619"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-67344"/>
<Border>
<Left style="1" color="-1710619"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-67344"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-67344"/>
<Border>
<Right style="1" color="-1710619"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-1"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0%]]></Format>
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-1"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0.0%]]></Format>
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-1"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="144" foreground="-6697984"/>
<Background name="ColorBackground" color="-1"/>
<Border/>
</Style>
<Style horizontal_alignment="4" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="64"/>
<Background name="ColorBackground" color="-67344"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="ColorBackground" color="-67344"/>
<Border>
<Right style="1" color="-1710619"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="1" size="96" foreground="-16776961" underline="1"/>
<Background name="ColorBackground" color="-1"/>
<Border>
<Top style="1" color="-1710619"/>
</Border>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<isShared isshared="false"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="0" zoom="true" refresh="false" isUseHTML="false"/>
</InnerWidget>
<BoundsAttr x="297" y="0" width="301" height="152"/>
</Widget>
<body class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="report2"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Margin top="1" left="1" bottom="1" right="1"/>
<Border>
<border style="1" color="-4144960" borderRadius="0" type="0" borderStyle="0"/>
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
<![CDATA[1143000,952500,1143000,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2590800,2438400,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="1" r="0" cs="2">
<O>
<![CDATA[HR人均服务改善比11.9%]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1" cs="2" s="0">
<O>
<![CDATA[当前HR人数713，主营人数11294]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="2">
<O>
<![CDATA[年度目标]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="2">
<O>
<![CDATA[累计年度目标]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="2">
<O>
<![CDATA[是否达标]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="3" s="1">
<O t="BigDecimal">
<![CDATA[0.2]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="3" s="1">
<O t="BigDecimal">
<![CDATA[0.068]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="4">
<O>
<![CDATA[年初服务比]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="4">
<O>
<![CDATA[当前服务比]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="4">
<O>
<![CDATA[服务改善比]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="5">
<O>
<![CDATA[1：378]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="5">
<O>
<![CDATA[1：423]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="5" s="1">
<O t="BigDecimal">
<![CDATA[0.119]]></O>
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
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="2" imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0.0%]]></Format>
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<isShared isshared="false"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="0" zoom="true" refresh="false" isUseHTML="false"/>
</body>
</InnerWidget>
<BoundsAttr x="297" y="551" width="301" height="152"/>
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
<Margin top="0" left="8" bottom="0" right="5"/>
<Border>
<border style="0" color="-1710619" borderRadius="0" type="0" borderStyle="0"/>
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
<![CDATA[1943100,0,457200,723900,1143000,1143000,571500,723900,304800,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[381000,2743200,2743200,2880000,2880000,360000,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" cs="6" s="0">
<O>
<![CDATA[产服总新增人数]]></O>
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
<C c="0" r="1" cs="6" s="1">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0" showAsHTML="true"/>
<CellPageAttr/>
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
<C c="0" r="2" s="2">
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
<C c="1" r="2" s="2">
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
<C c="2" r="2" s="2">
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
<C c="3" r="2" s="2">
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
<C c="4" r="2" s="2">
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
<C c="5" r="2" s="2">
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
<C c="0" r="3" s="3">
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
<C c="1" r="3" cs="4" rs="5" s="4">
<O>
<![CDATA[该功能即将上线，敬请期待……]]></O>
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
<C c="5" r="3" s="5">
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
<C c="0" r="4" s="3">
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
<C c="5" r="4" s="5">
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
<C c="0" r="5" s="3">
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
<C c="5" r="5" s="5">
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
<C c="0" r="6" s="3">
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
<C c="5" r="6" s="5">
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
<C c="0" r="7" s="3">
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
<C c="5" r="7" s="5">
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
<C c="0" r="8" s="6">
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
<C c="1" r="8" s="7">
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
<C c="2" r="8" s="7">
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
<C c="3" r="8" s="7">
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
<C c="4" r="8" s="7">
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
<C c="5" r="8" s="8">
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
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="1" size="96"/>
<Background name="ColorBackground" color="-596788"/>
<Border>
<Top style="1" color="-1710619"/>
<Left style="1" color="-1710619"/>
</Border>
</Style>
<Style horizontal_alignment="0" vertical_alignment="1" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-1"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-594463"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-594463"/>
<Border>
<Left style="1" color="-1710619"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="80"/>
<Background name="ColorBackground" color="-1"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-594463"/>
<Border>
<Right style="1" color="-1710619"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-594463"/>
<Border>
<Bottom style="1" color="-1710619"/>
<Left style="1" color="-1710619"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-594463"/>
<Border>
<Bottom style="1" color="-1710619"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-594463"/>
<Border>
<Bottom style="1" color="-1710619"/>
<Right style="1" color="-1710619"/>
</Border>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<isShared isshared="false"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="0" zoom="true" refresh="false" isUseHTML="false"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="297" height="152"/>
</Widget>
<body class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="report0"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Margin top="1" left="1" bottom="1" right="1"/>
<Border>
<border style="1" color="-4144960" borderRadius="0" type="0" borderStyle="0"/>
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
<![CDATA[723900,1143000,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1">
<O>
<![CDATA[产服总新增人数]]></O>
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
<BoundsAttr x="0" y="551" width="297" height="152"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="MC"/>
<Widget widgetName="label2"/>
<Widget widgetName="label3"/>
<Widget widgetName="label0"/>
<Widget widgetName="date_time1"/>
<Widget widgetName="label1"/>
<Widget widgetName="date_time"/>
<Widget widgetName="report1"/>
<Widget widgetName="report6"/>
<Widget widgetName="report9"/>
<Widget widgetName="report4"/>
<Widget widgetName="report7"/>
<Widget widgetName="report8"/>
<Widget widgetName="report0"/>
<Widget widgetName="report2"/>
<Widget widgetName="report10"/>
<Widget widgetName="report5"/>
<Widget widgetName="report3"/>
<Widget widgetName="absolute0"/>
</MobileWidgetList>
<WidgetZoomAttr compState="1"/>
<AppRelayout appRelayout="true"/>
<Size width="900" height="886"/>
<ResolutionScalingAttr percent="0.9"/>
<BodyLayoutType type="0"/>
</Center>
</Layout>
<DesignerVersion DesignerVersion="IAA"/>
<PreviewType PreviewType="0"/>
<TemplateID TemplateID="be965ea9-5a1d-44ea-be2e-469c41c58898"/>
</Form>
