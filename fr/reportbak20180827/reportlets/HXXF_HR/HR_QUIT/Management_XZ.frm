<?xml version="1.0" encoding="UTF-8"?>
<Form xmlVersion="20170715" releaseVersion="8.0.0">
<TableDataMap>
<TableData name="ds1" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="date_time"/>
<O>
<![CDATA[2018-07-01]]></O>
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
<![CDATA[WITH DATE_TRUE AS (
SELECT DESCR2,
       SUM(CASE
             WHEN CREATE_TIME = '${date_time}' THEN
              ZHUYING
           END) ZHUYING, --主营人数
        SUM(CASE
             WHEN CREATE_TIME = '${date_time}' THEN
              (XZZZG -XZCQT17 - XZCQT18)
           END) XZZZG_before, --行政人数
       SUM(CASE
             WHEN CREATE_TIME = '${date_time}' THEN
              (XZZZG  - XZCQT18)
           END) XZZZG, --行政人数
           case when 
       SUM(TRUNC(CASE
                   WHEN CREATE_TIME = '${date_time}' THEN
                    CASE
                      WHEN (XZZZG - XZCQT17 - XZCQT18) = 0 THEN
                       0
                      ELSE
                       ZHUYING / (XZZZG - XZCQT17 - XZCQT18)
                    END
                 END))is null then 0 else
                 SUM(TRUNC(CASE
                   WHEN CREATE_TIME = '${date_time}' THEN
                    CASE
                      WHEN (XZZZG - XZCQT17 - XZCQT18) = 0 THEN
                       0
                      ELSE
                       ZHUYING / (XZZZG - XZCQT17 - XZCQT18)
                    END
                 END)) end RJFWGSB_before, --行政服务比
       case when 
       SUM(TRUNC(CASE
                   WHEN CREATE_TIME = '${date_time}' THEN
                    CASE
                      WHEN (XZZZG  - XZCQT18) = 0 THEN
                       0
                      ELSE
                       ZHUYING / (XZZZG  - XZCQT18)
                    END
                 END))is null then 0 else
                 SUM(TRUNC(CASE
                   WHEN CREATE_TIME = '${date_time}' THEN
                    CASE
                      WHEN (XZZZG  - XZCQT18) = 0 THEN
                       0
                      ELSE
                       ZHUYING / (XZZZG  - XZCQT18)
                    END
                 END)) end RJFWGSB, --行政服务比
       sum((CASE
             WHEN CREATE_TIME = SUBSTR('${date_time}', 0, 4) - 1 || '-12-31' THEN
                       XZZZG
           END)) ncXZZZG,--年初行政总在岗
       sum((CASE
             WHEN CREATE_TIME = SUBSTR('${date_time}', 0, 4) - 1 || '-12-31' THEN
                       XZCQT17
           END)) ncXZCQT17,--年初xz常青藤17
       sum((CASE
             WHEN CREATE_TIME = SUBSTR('${date_time}', 0, 4) - 1 || '-12-31' THEN
                       XZCQT18
           END)) ncXZCQT18,--年初xz常青藤18
       SUM((CASE
             WHEN CREATE_TIME = SUBSTR('${date_time}', 0, 4) - 1 || '-12-31' THEN
                       (XZZZG - XZCQT17 - XZCQT18) 
           END)) NCXZ, --年初行政   
       SUM((CASE
             WHEN CREATE_TIME = SUBSTR('${date_time}', 0, 4) - 1 || '-12-31' THEN
                       ZHUYING 
           END)) NCZHUYING, --年初主营              
       SUM((CASE
             WHEN CREATE_TIME = SUBSTR('${date_time}', 0, 4) - 1 || '-12-31' THEN
              (CASE
                      WHEN (XZZZG - XZCQT17 - XZCQT18) = 0 THEN
                       0
                      ELSE
                       ZHUYING / (XZZZG - XZCQT17 - XZCQT18)
                    END)
           END)) NDFWB, --年初行政服务比
        CASE
         WHEN SUM((CASE
                    WHEN CREATE_TIME = SUBSTR('${date_time}', 0, 4) - 1 || '-12-31' THEN
                     TRUNC(CASE
                             WHEN (XZZZG - XZCQT17 - XZCQT18) = 0 THEN
                              0
                             ELSE
                              ZHUYING / (XZZZG - XZCQT17 - XZCQT18)
                           END)
                  END)) = 0 THEN
          0
         ELSE
          SUM(TRUNC(CASE
                      WHEN CREATE_TIME = '${date_time}' THEN
                       CASE
                         WHEN (XZZZG - XZCQT17 - XZCQT18) = 0 THEN
                          0
                         ELSE
                          ZHUYING / (XZZZG - XZCQT17 - XZCQT18)
                       END
                    END)) / SUM((CASE
                                  WHEN CREATE_TIME = SUBSTR('${date_time}', 0, 4) - 1 || '-12-31' THEN
                                   TRUNC(CASE
                                           WHEN (XZZZG - XZCQT17 - XZCQT18) = 0 THEN
                                            0
                                           ELSE
                                            ZHUYING / (XZZZG - XZCQT17 - XZCQT18)
                                         END)
                                END)) - 1
       END GSB_before, --改善比不含17,18  
       CASE
         WHEN SUM((CASE
                    WHEN CREATE_TIME = SUBSTR('${date_time}', 0, 4) - 1 || '-12-31' THEN
                     TRUNC(CASE
                             WHEN (XZZZG - XZCQT17 - XZCQT18) = 0 THEN
                              0
                             ELSE
                              ZHUYING / (XZZZG - XZCQT17 - XZCQT18)
                           END)
                  END)) = 0 THEN
          0
         ELSE
          SUM(TRUNC(CASE
                      WHEN CREATE_TIME = '${date_time}' THEN
                       CASE
                         WHEN (XZZZG  - XZCQT18) = 0 THEN
                          0
                         ELSE
                          ZHUYING / (XZZZG  - XZCQT18)
                       END
                    END)) / SUM((CASE
                                  WHEN CREATE_TIME = SUBSTR('${date_time}', 0, 4) - 1 || '-12-31' THEN
                                   TRUNC(CASE
                                           WHEN (XZZZG - XZCQT17 - XZCQT18) = 0 THEN
                                            0
                                           ELSE
                                            ZHUYING / (XZZZG - XZCQT17 - XZCQT18)
                                         END)
                                END)) - 1
       END GSB --改善比含17，不含18
  FROM ODM_HR_RJFWGSB T
 WHERE 1 = 1
 ${IF(DWMC = 'HX_HEAD',            " and TREE_NODE2 in (SELECT TREE_NODE FROM ODM_HR_DW WHERE PARENT_NODE ='HX_HEAD')",
            " and TREE_NODE2 <> TREE_NODE and parent_nodes like '%" + DWMC + "%'") }
 GROUP BY DESCR2
 )
 SELECT
 DESCR2,
 ZHUYING,
 CASE WHEN 
TO_CHAR(TO_DATE('${date_time}','yyyy-MM-dd'),'MM')>=7 
THEN XZZZG ELSE  XZZZG_before END AS XZZZG,
 CASE WHEN 
TO_CHAR(TO_DATE('${date_time}','yyyy-MM-dd'),'MM')>=7 
THEN RJFWGSB ELSE  RJFWGSB_before END AS RJFWGSB,
ncXZZZG,
ncXZCQT17,
ncXZCQT18,
NCXZ,
NCZHUYING,
NDFWB,
 CASE WHEN 
TO_CHAR(TO_DATE('${date_time}','yyyy-MM-dd'),'MM')>=7 
THEN GSB ELSE  GSB_before END AS GSB

 FROM DATE_TRUE
 ORDER BY RJFWGSB DESC
]]></Query>
</TableData>
<TableData name="lzrs" class="com.fr.data.impl.DBTableData">
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
<![CDATA[WITH ODM_HR_RJFWGSB1 AS(
SELECT '年初' AS create_time,TREE_NODE,TREE_NODE2,parent_nodes,XZZZG -XZCQT17- XZCQT18 XZZZG,ZHUYING, TRUNC( CASE WHEN (XZZZG -XZCQT17 - XZCQT18) = 0 THEN  0  ELSE  ZHUYING / (XZZZG -XZCQT17  - XZCQT18) END ) RJFWGSB    --HR服务比
                      FROM ODM_HR_RJFWGSB WHERE SUBSTR(create_time,0,7)=TO_CHAR(SUBSTR('${date_time}', 0, 4)-1)|| '-12'  --年初
UNION ALL 
SELECT '1月' AS create_time,TREE_NODE,TREE_NODE2,parent_nodes,XZZZG -XZCQT17  - XZCQT18 XZZZG,ZHUYING, TRUNC( CASE WHEN (XZZZG -XZCQT17 - XZCQT18) = 0 THEN  0  ELSE  ZHUYING / (XZZZG -XZCQT17 - XZCQT18) END ) RJFWGSB    --HR服务比
                      FROM ODM_HR_RJFWGSB  where 1=1
  ${if(or(date_time = dateinmonth(date_time,-1) ,month(date_time)>1),"and create_time = to_char(last_day(TO_DATE(SUBSTR('"+date_time+"',1,4)||'01-01','YYYY-MM-DD')),'yyyy-mm-dd')","and create_time = '"+date_time+"'")}     --1月
UNION ALL 
SELECT '2月' AS create_time,TREE_NODE,TREE_NODE2,parent_nodes,XZZZG-XZCQT17 - XZCQT18 XZZZG,ZHUYING, TRUNC( CASE WHEN (XZZZG-XZCQT17 - XZCQT18) = 0 THEN  0  ELSE  ZHUYING / (XZZZG-XZCQT17 - XZCQT18) END ) RJFWGSB    --HR服务比
                      FROM ODM_HR_RJFWGSB  where 1=1
  ${if(or(date_time = dateinmonth(date_time,-1) ,month(date_time)>2),"and create_time = to_char(last_day(TO_DATE(SUBSTR('"+date_time+"',1,4)||'02-01','YYYY-MM-DD')),'yyyy-mm-dd')","and create_time = '"+date_time+"'")}     --二月
UNION ALL 
SELECT '3月' AS create_time,TREE_NODE,TREE_NODE2,parent_nodes,XZZZG-XZCQT17- XZCQT18 XZZZG,ZHUYING, TRUNC( CASE WHEN (XZZZG-XZCQT17 - XZCQT18) = 0 THEN  0  ELSE  ZHUYING / (XZZZG-XZCQT17 - XZCQT18) END ) RJFWGSB    --HR服务比
                      FROM ODM_HR_RJFWGSB  where 1=1
  ${if(or(date_time = dateinmonth(date_time,-1) ,month(date_time)>3),"and create_time = to_char(last_day(TO_DATE(SUBSTR('"+date_time+"',1,4)||'03-01','YYYY-MM-DD')),'yyyy-mm-dd')","and create_time = '"+date_time+"'")}     --三月
UNION ALL 
SELECT '4月' AS create_time,TREE_NODE,TREE_NODE2,parent_nodes,XZZZG-XZCQT17 - XZCQT18 XZZZG,ZHUYING, TRUNC( CASE WHEN (XZZZG-XZCQT17 - XZCQT18) = 0 THEN  0  ELSE  ZHUYING / (XZZZG-XZCQT17 - XZCQT18) END ) RJFWGSB    --HR服务比
                      FROM ODM_HR_RJFWGSB  where 1=1
  ${if(or(date_time = dateinmonth(date_time,-1) ,month(date_time)>4),"and create_time = to_char(last_day(TO_DATE(SUBSTR('"+date_time+"',1,4)||'04-01','YYYY-MM-DD')),'yyyy-mm-dd')","and create_time = '"+date_time+"'")}     --4月
UNION ALL 
SELECT '5月' AS create_time,TREE_NODE,TREE_NODE2,parent_nodes,XZZZG-XZCQT17 - XZCQT18 XZZZG,ZHUYING, TRUNC( CASE WHEN (XZZZG-XZCQT17 - XZCQT18) = 0 THEN  0  ELSE  ZHUYING / (XZZZG-XZCQT17 - XZCQT18) END ) RJFWGSB    --HR服务比
                      FROM ODM_HR_RJFWGSB  where 1=1
  ${if(or(date_time = dateinmonth(date_time,-1) ,month(date_time)>5),"and create_time = to_char(last_day(TO_DATE(SUBSTR('"+date_time+"',1,4)||'05-01','YYYY-MM-DD')),'yyyy-mm-dd')","and create_time = '"+date_time+"'")}    --5月
UNION ALL 
SELECT '6月' AS create_time,TREE_NODE,TREE_NODE2,parent_nodes,XZZZG-XZCQT17 - XZCQT18 XZZZG,ZHUYING, TRUNC( CASE WHEN (XZZZG-XZCQT17 - XZCQT18) = 0 THEN  0  ELSE  ZHUYING / (XZZZG-XZCQT17 - XZCQT18) END ) RJFWGSB    --HR服务比
                      FROM ODM_HR_RJFWGSB  where 1=1
  ${if(or(date_time = dateinmonth(date_time,-1) ,month(date_time)>6),"and create_time = to_char(last_day(TO_DATE(SUBSTR('"+date_time+"',1,4)||'06-01','YYYY-MM-DD')),'yyyy-mm-dd')","and create_time = '"+date_time+"'")}     --6月
UNION ALL 
SELECT '7月' AS create_time,TREE_NODE,TREE_NODE2,parent_nodes,XZZZG  - XZCQT18 XZZZG,ZHUYING, TRUNC( CASE WHEN (XZZZG  - XZCQT18) = 0 THEN  0  ELSE  ZHUYING / (XZZZG  - XZCQT18) END ) RJFWGSB    --HR服务比
                      FROM ODM_HR_RJFWGSB  where 1=1
  ${if(or(date_time = dateinmonth(date_time,-1) ,month(date_time)>7),"and create_time = to_char(last_day(TO_DATE(SUBSTR('"+date_time+"',1,4)||'07-01','YYYY-MM-DD')),'yyyy-mm-dd')","and create_time = '"+date_time+"'")}     --7月
UNION ALL 
SELECT '8月' AS create_time,TREE_NODE,TREE_NODE2,parent_nodes,XZZZG  - XZCQT18 XZZZG,ZHUYING, TRUNC( CASE WHEN (XZZZG  - XZCQT18) = 0 THEN  0  ELSE  ZHUYING / (XZZZG  - XZCQT18) END ) RJFWGSB    --HR服务比
                      FROM ODM_HR_RJFWGSB  where 1=1
  ${if(or(date_time = dateinmonth(date_time,-1) ,month(date_time)>8),"and create_time = to_char(last_day(TO_DATE(SUBSTR('"+date_time+"',1,4)||'08-01','YYYY-MM-DD')),'yyyy-mm-dd')","and create_time = '"+date_time+"'")}     --8月
UNION ALL 
SELECT '9月' AS create_time,TREE_NODE,TREE_NODE2,parent_nodes,XZZZG  - XZCQT18 XZZZG,ZHUYING, TRUNC( CASE WHEN (XZZZG - XZCQT18) = 0 THEN  0  ELSE  ZHUYING / (XZZZG  - XZCQT18) END ) RJFWGSB    --HR服务比
                      FROM ODM_HR_RJFWGSB  where 1=1
  ${if(or(date_time = dateinmonth(date_time,-1) ,month(date_time)>9),"and create_time = to_char(last_day(TO_DATE(SUBSTR('"+date_time+"',1,4)||'09-01','YYYY-MM-DD')),'yyyy-mm-dd')","and create_time = '"+date_time+"'")}     --9月
UNION ALL 
SELECT '10月' AS create_time,TREE_NODE,TREE_NODE2,parent_nodes,XZZZG  - XZCQT18 XZZZG,ZHUYING, TRUNC( CASE WHEN (XZZZG  - XZCQT18) = 0 THEN  0  ELSE  ZHUYING / (XZZZG  - XZCQT18) END ) RJFWGSB    --HR服务比
                      FROM ODM_HR_RJFWGSB  where 1=1
  ${if(or(date_time = dateinmonth(date_time,-1) ,month(date_time)>10),"and create_time = to_char(last_day(TO_DATE(SUBSTR('"+date_time+"',1,4)||'10-01','YYYY-MM-DD')),'yyyy-mm-dd')","and create_time = '"+date_time+"'")}     --10月
UNION ALL 
SELECT '11月' AS create_time,TREE_NODE,TREE_NODE2,parent_nodes,XZZZG  - XZCQT18 XZZZG,ZHUYING, TRUNC( CASE WHEN (XZZZG  - XZCQT18) = 0 THEN  0  ELSE  ZHUYING / (XZZZG  - XZCQT18) END ) RJFWGSB    --HR服务比
                      FROM ODM_HR_RJFWGSB  where 1=1
  ${if(or(date_time = dateinmonth(date_time,-1) ,month(date_time)>11),"and create_time = to_char(last_day(TO_DATE(SUBSTR('"+date_time+"',1,4)||'11-01','YYYY-MM-DD')),'yyyy-mm-dd')","and create_time = '"+date_time+"'")}     --11月
UNION ALL 
SELECT '12月' AS create_time,TREE_NODE,TREE_NODE2,parent_nodes,XZZZG  - XZCQT18 XZZZG,ZHUYING, TRUNC( CASE WHEN (XZZZG  - XZCQT18) = 0 THEN  0  ELSE  ZHUYING / (XZZZG  - XZCQT18) END ) RJFWGSB    --HR服务比
                      FROM ODM_HR_RJFWGSB  where 1=1
  ${if(or(date_time = dateinmonth(date_time,-1) ,month(date_time)>12),"and create_time = to_char(last_day(TO_DATE(SUBSTR('"+date_time+"',1,4)||'12-01','YYYY-MM-DD')),'yyyy-mm-dd')","and create_time = '"+date_time+"'")}     --12月
)

SELECT sum(CASE WHEN create_time='年初' THEN XZZZG END) AS  ZeroXZZZG,
       sum(CASE WHEN create_time='1月'  THEN XZZZG END) AS  OneXZZZG,
       sum(CASE WHEN create_time='2月'  THEN XZZZG END) AS  TwoXZZZG,
       sum(CASE WHEN create_time='3月'  THEN XZZZG END) AS  ThreeXZZZG,
       sum(CASE WHEN create_time='4月'  THEN XZZZG END) AS  FourXZZZG,
       sum(CASE WHEN create_time='5月'  THEN XZZZG END) AS  FiveXZZZG,
       sum(CASE WHEN create_time='6月'  THEN XZZZG END) AS  SixXZZZG,
       sum(CASE WHEN create_time='7月'  THEN XZZZG END) AS  SevenXZZZG,
       sum(CASE WHEN create_time='8月'  THEN XZZZG END) AS  EightXZZZG,
       sum(CASE WHEN create_time='9月'  THEN XZZZG END) AS  NineXZZZG,
       sum(CASE WHEN create_time='10月' THEN XZZZG END) AS  TenXZZZG,
       sum(CASE WHEN create_time='11月' THEN XZZZG END) AS  ElevenXZZZG,
       sum(CASE WHEN create_time='12月' THEN XZZZG END) AS  TwelveXZZZG,
       SUM(CASE WHEN create_time='年初' THEN ZHUYING END) AS ZeroZHUYING, 
     sum(CASE WHEN create_time='1月'  THEN ZHUYING END) AS  OneZHUYING,
       sum(CASE WHEN create_time='2月'  THEN ZHUYING END) AS  TwoZHUYING,
       sum(CASE WHEN create_time='3月'  THEN ZHUYING END) AS  ThreeZHUYING,
       sum(CASE WHEN create_time='4月'  THEN ZHUYING END) AS  FourZHUYING,
       sum(CASE WHEN create_time='5月'  THEN ZHUYING END) AS  FiveZHUYING,
       sum(CASE WHEN create_time='6月'  THEN ZHUYING END) AS  SixZHUYING,
       sum(CASE WHEN create_time='7月'  THEN ZHUYING END) AS  SevenZHUYING,
       sum(CASE WHEN create_time='8月'  THEN ZHUYING END) AS  EightZHUYING,
       sum(CASE WHEN create_time='9月'  THEN ZHUYING END) AS  NineZHUYING,
       sum(CASE WHEN create_time='10月' THEN ZHUYING END) AS  TenZHUYING,
       sum(CASE WHEN create_time='11月' THEN ZHUYING END) AS  ElevenZHUYING,
       sum(CASE WHEN create_time='12月' THEN ZHUYING END) AS  TwelveZHUYING,
     SUM(CASE WHEN create_time='年初' THEN RJFWGSB END) AS ZeroRJFWGSB, 
     sum(CASE WHEN create_time='1月'  THEN RJFWGSB END) AS  OneRJFWGSB,
       sum(CASE WHEN create_time='2月'  THEN RJFWGSB END) AS  TwoRJFWGSB,
       sum(CASE WHEN create_time='3月'  THEN RJFWGSB END) AS  ThreeRJFWGSB,
       sum(CASE WHEN create_time='4月'  THEN RJFWGSB END) AS  FourRJFWGSB,
       sum(CASE WHEN create_time='5月'  THEN RJFWGSB END) AS  FiveRJFWGSB,
       sum(CASE WHEN create_time='6月'  THEN RJFWGSB END) AS  SixRJFWGSB,
       sum(CASE WHEN create_time='7月'  THEN RJFWGSB END) AS  SevenRJFWGSB,
       sum(CASE WHEN create_time='8月'  THEN RJFWGSB END) AS  EightRJFWGSB,
       sum(CASE WHEN create_time='9月'  THEN RJFWGSB END) AS  NineRJFWGSB,
       sum(CASE WHEN create_time='10月' THEN RJFWGSB END) AS  TenRJFWGSB,
       sum(CASE WHEN create_time='11月' THEN RJFWGSB END) AS  ElevenRJFWGSB,
       sum(CASE WHEN create_time='12月' THEN RJFWGSB END) AS  TwelveRJFWGSB  FROM 
ODM_HR_RJFWGSB1
WHERE 1 = 1
 ${IF(DWMC = 'HX_HEAD',
            " and TREE_NODE2 in (SELECT TREE_NODE FROM ODM_HR_DW WHERE PARENT_NODE ='HX_HEAD')",
            " and TREE_NODE2 = '" + DWMC + "'") }]]></Query>
</TableData>
<TableData name="RJFWGSB" class="com.fr.data.impl.DBTableData">
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
             WHEN CREATE_TIME= '${date_time}' THEN
              ZHUYING
           END) ZHUYING, --主营人数
           SUM(CASE
             WHEN CREATE_TIME= '${date_time}' THEN
              XZZZG -XZCQT17 - XZCQT18
           END) XZZZG_before, --HR人数不含1718
       SUM(CASE
             WHEN CREATE_TIME= '${date_time}' THEN
              XZZZG  - XZCQT18
           END) XZZZG, --HR人数含17，不含18
          SUM(round(CASE
                   WHEN CREATE_TIME= '${date_time}' THEN
                    CASE
                      WHEN (XZZZG  -XZCQT17 - XZCQT18) = 0 THEN
                       0
                      ELSE
                       ZHUYING / (XZZZG -XZCQT17 - XZCQT18)
                    END
                 END)) RJFWGSB_before, --HR服务比 
       SUM(round(CASE
                   WHEN CREATE_TIME= '${date_time}' THEN
                    CASE
                      WHEN (XZZZG  - XZCQT18) = 0 THEN
                       0
                      ELSE
                       ZHUYING / (XZZZG  - XZCQT18)
                    END
                 END)) RJFWGSB, --HR服务比
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
                     TRUNC(CASE
                             WHEN (XZZZG - XZCQT17 - XZCQT18) = 0 THEN
                              0
                             ELSE
                              ZHUYING / (XZZZG - XZCQT17 - XZCQT18)
                           END)
                  END)) = 0 THEN
          0
         ELSE
          SUM(round(CASE
                      WHEN CREATE_TIME = '${date_time}' THEN
                       CASE
                         WHEN (XZZZG - XZCQT17 - XZCQT18) = 0 THEN
                          0
                         ELSE
                          ZHUYING / (XZZZG - XZCQT17 - XZCQT18)
                       END
                    END)) / SUM((CASE
                                  WHEN CREATE_TIME = SUBSTR('${date_time}', 0, 4) - 1 || '-12-31' THEN
                                   TRUNC(CASE
                                           WHEN (XZZZG - XZCQT17 - XZCQT18) = 0 THEN
                                            0
                                           ELSE
                                            ZHUYING / (XZZZG - XZCQT17 - XZCQT18)
                                         END)
                                END)) - 1
       END GSB_before, --改善不含17,18 
       CASE
         WHEN SUM((CASE
                    WHEN CREATE_TIME = SUBSTR('${date_time}', 0, 4) - 1 || '-12-31' THEN
                     TRUNC(CASE
                             WHEN (XZZZG - XZCQT17 - XZCQT18) = 0 THEN
                              0
                             ELSE
                              ZHUYING / (XZZZG - XZCQT17 - XZCQT18)
                           END)
                  END)) = 0 THEN
          0
         ELSE
          SUM(round(CASE
                      WHEN CREATE_TIME = '${date_time}' THEN
                       CASE
                         WHEN (XZZZG  - XZCQT18) = 0 THEN
                          0
                         ELSE
                          ZHUYING / (XZZZG  - XZCQT18)
                       END
                    END)) / SUM((CASE
                                  WHEN CREATE_TIME = SUBSTR('${date_time}', 0, 4) - 1 || '-12-31' THEN
                                   TRUNC(CASE
                                           WHEN (XZZZG - XZCQT17 - XZCQT18) = 0 THEN
                                            0
                                           ELSE
                                            ZHUYING / (XZZZG - XZCQT17 - XZCQT18)
                                         END)
                                END)) - 1
       END GSB --改善比含17，不含18
  FROM ODM_HR_RJFWGSB T
 WHERE 1 = 1
 and TREE_NODE2='${dwmc}'
)
SELECT 
ZHUYING,
CASE WHEN 
TO_CHAR(TO_DATE('${date_time}','yyyy-MM-dd'),'MM')>=7 
THEN XZZZG ELSE  XZZZG_before END AS XZZZG,
CASE WHEN 
TO_CHAR(TO_DATE('${date_time}','yyyy-MM-dd'),'MM')>=7 
THEN RJFWGSB ELSE  RJFWGSB_before END AS RJFWGSB,
NDFWB,
CASE WHEN 
TO_CHAR(TO_DATE('${date_time}','yyyy-MM-dd'),'MM')>=7 
THEN GSB ELSE  GSB_before END AS GSB
FROM DATE_TRUE]]></Query>
</TableData>
<TableData name="ds2" class="com.fr.data.impl.DBTableData">
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
<![CDATA[SELECT '年初' AS CREATE_TIME,
         TREE_NODE,
         TREE_NODE2,
         PARENT_NODES,
         XZZZG - XZCQT17 - XZCQT18 XZZZG,
         ZHUYING,
         TRUNC(CASE
                 WHEN (XZZZG - XZCQT17 - XZCQT18) = 0 THEN
                  0
                 ELSE
                  ZHUYING / (XZZZG - XZCQT17 - XZCQT18)
               END) RJFWGSB
    FROM ODM_HR_RJFWGSB
   WHERE SUBSTR(CREATE_TIME, 1, 7) =
         TO_CHAR(SUBSTR('${date_time}', 0, 4) - 1) || '-12'
    ${IF(DWMC = 'HX_HEAD',
            " and TREE_NODE2 in (SELECT TREE_NODE FROM ODM_HR_DW WHERE PARENT_NODE ='HX_HEAD')",
            " and TREE_NODE2 <> TREE_NODE and parent_nodes like '%" + DWMC + "%'") }]]></Query>
</TableData>
<TableData name="lzrs_bak" class="com.fr.data.impl.DBTableData">
<Parameters/>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[HXXF_HR]]></DatabaseName>
</Connection>
<Query>
<![CDATA[WITH ODM_HR_RJFWGSB1 AS(
SELECT '年初' AS create_time,TREE_NODE,TREE_NODE2,parent_nodes,XZZZG  - XZCQT17 - XZCQT18 XZZZG,ZHUYING, TRUNC( CASE WHEN (XZZZG - XZCQT17 - XZCQT18) = 0 THEN  0  ELSE  ZHUYING / (XZZZG - XZCQT17 - XZCQT18) END ) RJFWGSB    --HR服务比
                      FROM ODM_HR_RJFWGSB WHERE SUBSTR(create_time,0,7)=TO_CHAR(SUBSTR('${date_time}', 0, 4)-1)|| '-12'  --年初
UNION ALL 
SELECT '1月' AS create_time,TREE_NODE,TREE_NODE2,parent_nodes,XZZZG - XZCQT17 - XZCQT18 XZZZG,ZHUYING, TRUNC( CASE WHEN (XZZZG - XZCQT17 - XZCQT18) = 0 THEN  0  ELSE  ZHUYING / (XZZZG - XZCQT17 - XZCQT18) END ) RJFWGSB    --HR服务比
                      FROM ODM_HR_RJFWGSB  where 1=1
  ${if(or(date_time = dateinmonth(date_time,-1) ,month(date_time)>1),"and create_time = to_char(last_day(TO_DATE(SUBSTR('"+date_time+"',1,4)||'01-01','YYYY-MM-DD')),'yyyy-mm-dd')","and create_time = '"+date_time+"'")}     --1月
UNION ALL 
SELECT '2月' AS create_time,TREE_NODE,TREE_NODE2,parent_nodes,XZZZG - XZCQT17 - XZCQT18 XZZZG,ZHUYING, TRUNC( CASE WHEN (XZZZG - XZCQT17 - XZCQT18) = 0 THEN  0  ELSE  ZHUYING / (XZZZG - XZCQT17 - XZCQT18) END ) RJFWGSB    --HR服务比
                      FROM ODM_HR_RJFWGSB  where 1=1
  ${if(or(date_time = dateinmonth(date_time,-1) ,month(date_time)>2),"and create_time = to_char(last_day(TO_DATE(SUBSTR('"+date_time+"',1,4)||'02-01','YYYY-MM-DD')),'yyyy-mm-dd')","and create_time = '"+date_time+"'")}     --二月
UNION ALL 
SELECT '3月' AS create_time,TREE_NODE,TREE_NODE2,parent_nodes,XZZZG - XZCQT17 - XZCQT18 XZZZG,ZHUYING, TRUNC( CASE WHEN (XZZZG - XZCQT17 - XZCQT18) = 0 THEN  0  ELSE  ZHUYING / (XZZZG - XZCQT17 - XZCQT18) END ) RJFWGSB    --HR服务比
                      FROM ODM_HR_RJFWGSB  where 1=1
  ${if(or(date_time = dateinmonth(date_time,-1) ,month(date_time)>3),"and create_time = to_char(last_day(TO_DATE(SUBSTR('"+date_time+"',1,4)||'03-01','YYYY-MM-DD')),'yyyy-mm-dd')","and create_time = '"+date_time+"'")}     --三月
UNION ALL 
SELECT '4月' AS create_time,TREE_NODE,TREE_NODE2,parent_nodes,XZZZG - XZCQT17 - XZCQT18 XZZZG,ZHUYING, TRUNC( CASE WHEN (XZZZG - XZCQT17 - XZCQT18) = 0 THEN  0  ELSE  ZHUYING / (XZZZG - XZCQT17 - XZCQT18) END ) RJFWGSB    --HR服务比
                      FROM ODM_HR_RJFWGSB  where 1=1
  ${if(or(date_time = dateinmonth(date_time,-1) ,month(date_time)>4),"and create_time = to_char(last_day(TO_DATE(SUBSTR('"+date_time+"',1,4)||'04-01','YYYY-MM-DD')),'yyyy-mm-dd')","and create_time = '"+date_time+"'")}     --4月
UNION ALL 
SELECT '5月' AS create_time,TREE_NODE,TREE_NODE2,parent_nodes,XZZZG - XZCQT17 - XZCQT18 XZZZG,ZHUYING, TRUNC( CASE WHEN (XZZZG - XZCQT17 - XZCQT18) = 0 THEN  0  ELSE  ZHUYING / (XZZZG - XZCQT17 - XZCQT18) END ) RJFWGSB    --HR服务比
                      FROM ODM_HR_RJFWGSB  where 1=1
  ${if(or(date_time = dateinmonth(date_time,-1) ,month(date_time)>5),"and create_time = to_char(last_day(TO_DATE(SUBSTR('"+date_time+"',1,4)||'05-01','YYYY-MM-DD')),'yyyy-mm-dd')","and create_time = '"+date_time+"'")}    --5月
UNION ALL 
SELECT '6月' AS create_time,TREE_NODE,TREE_NODE2,parent_nodes,XZZZG - XZCQT17 - XZCQT18 XZZZG,ZHUYING, TRUNC( CASE WHEN (XZZZG - XZCQT17 - XZCQT18) = 0 THEN  0  ELSE  ZHUYING / (XZZZG - XZCQT17 - XZCQT18) END ) RJFWGSB    --HR服务比
                      FROM ODM_HR_RJFWGSB  where 1=1
  ${if(or(date_time = dateinmonth(date_time,-1) ,month(date_time)>6),"and create_time = to_char(last_day(TO_DATE(SUBSTR('"+date_time+"',1,4)||'06-01','YYYY-MM-DD')),'yyyy-mm-dd')","and create_time = '"+date_time+"'")}     --6月
UNION ALL 
SELECT '7月' AS create_time,TREE_NODE,TREE_NODE2,parent_nodes,XZZZG - XZCQT17 - XZCQT18 XZZZG,ZHUYING, TRUNC( CASE WHEN (XZZZG - XZCQT17 - XZCQT18) = 0 THEN  0  ELSE  ZHUYING / (XZZZG - XZCQT17 - XZCQT18) END ) RJFWGSB    --HR服务比
                      FROM ODM_HR_RJFWGSB  where 1=1
  ${if(or(date_time = dateinmonth(date_time,-1) ,month(date_time)>7),"and create_time = to_char(last_day(TO_DATE(SUBSTR('"+date_time+"',1,4)||'07-01','YYYY-MM-DD')),'yyyy-mm-dd')","and create_time = '"+date_time+"'")}     --7月
UNION ALL 
SELECT '8月' AS create_time,TREE_NODE,TREE_NODE2,parent_nodes,XZZZG - XZCQT17 - XZCQT18 XZZZG,ZHUYING, TRUNC( CASE WHEN (XZZZG - XZCQT17 - XZCQT18) = 0 THEN  0  ELSE  ZHUYING / (XZZZG - XZCQT17 - XZCQT18) END ) RJFWGSB    --HR服务比
                      FROM ODM_HR_RJFWGSB  where 1=1
  ${if(or(date_time = dateinmonth(date_time,-1) ,month(date_time)>8),"and create_time = to_char(last_day(TO_DATE(SUBSTR('"+date_time+"',1,4)||'08-01','YYYY-MM-DD')),'yyyy-mm-dd')","and create_time = '"+date_time+"'")}     --8月
UNION ALL 
SELECT '9月' AS create_time,TREE_NODE,TREE_NODE2,parent_nodes,XZZZG - XZCQT17 - XZCQT18 XZZZG,ZHUYING, TRUNC( CASE WHEN (XZZZG - XZCQT17 - XZCQT18) = 0 THEN  0  ELSE  ZHUYING / (XZZZG - XZCQT17 - XZCQT18) END ) RJFWGSB    --HR服务比
                      FROM ODM_HR_RJFWGSB  where 1=1
  ${if(or(date_time = dateinmonth(date_time,-1) ,month(date_time)>9),"and create_time = to_char(last_day(TO_DATE(SUBSTR('"+date_time+"',1,4)||'09-01','YYYY-MM-DD')),'yyyy-mm-dd')","and create_time = '"+date_time+"'")}     --9月
UNION ALL 
SELECT '10月' AS create_time,TREE_NODE,TREE_NODE2,parent_nodes,XZZZG - XZCQT17 - XZCQT18 XZZZG,ZHUYING, TRUNC( CASE WHEN (XZZZG - XZCQT17 - XZCQT18) = 0 THEN  0  ELSE  ZHUYING / (XZZZG - XZCQT17 - XZCQT18) END ) RJFWGSB    --HR服务比
                      FROM ODM_HR_RJFWGSB  where 1=1
  ${if(or(date_time = dateinmonth(date_time,-1) ,month(date_time)>10),"and create_time = to_char(last_day(TO_DATE(SUBSTR('"+date_time+"',1,4)||'10-01','YYYY-MM-DD')),'yyyy-mm-dd')","and create_time = '"+date_time+"'")}     --10月
UNION ALL 
SELECT '11月' AS create_time,TREE_NODE,TREE_NODE2,parent_nodes,XZZZG - XZCQT17 - XZCQT18 XZZZG,ZHUYING, TRUNC( CASE WHEN (XZZZG - XZCQT17 - XZCQT18) = 0 THEN  0  ELSE  ZHUYING / (XZZZG - XZCQT17 - XZCQT18) END ) RJFWGSB    --HR服务比
                      FROM ODM_HR_RJFWGSB  where 1=1
  ${if(or(date_time = dateinmonth(date_time,-1) ,month(date_time)>11),"and create_time = to_char(last_day(TO_DATE(SUBSTR('"+date_time+"',1,4)||'11-01','YYYY-MM-DD')),'yyyy-mm-dd')","and create_time = '"+date_time+"'")}     --11月
UNION ALL 
SELECT '12月' AS create_time,TREE_NODE,TREE_NODE2,parent_nodes,XZZZG - XZCQT17 - XZCQT18 XZZZG,ZHUYING, TRUNC( CASE WHEN (XZZZG - XZCQT17 - XZCQT18) = 0 THEN  0  ELSE  ZHUYING / (XZZZG - XZCQT17 - XZCQT18) END ) RJFWGSB    --HR服务比
                      FROM ODM_HR_RJFWGSB  where 1=1
  ${if(or(date_time = dateinmonth(date_time,-1) ,month(date_time)>12),"and create_time = to_char(last_day(TO_DATE(SUBSTR('"+date_time+"',1,4)||'12-01','YYYY-MM-DD')),'yyyy-mm-dd')","and create_time = '"+date_time+"'")}     --12月
)

SELECT sum(CASE WHEN create_time='年初' THEN XZZZG END) AS  ZeroXZZZG,
       sum(CASE WHEN create_time='1月'  THEN XZZZG END) AS  OneXZZZG,
       sum(CASE WHEN create_time='2月'  THEN XZZZG END) AS  TwoXZZZG,
       sum(CASE WHEN create_time='3月'  THEN XZZZG END) AS  ThreeXZZZG,
       sum(CASE WHEN create_time='4月'  THEN XZZZG END) AS  FourXZZZG,
       sum(CASE WHEN create_time='5月'  THEN XZZZG END) AS  FiveXZZZG,
       sum(CASE WHEN create_time='6月'  THEN XZZZG END) AS  SixXZZZG,
       sum(CASE WHEN create_time='7月'  THEN XZZZG END) AS  SevenXZZZG,
       sum(CASE WHEN create_time='8月'  THEN XZZZG END) AS  EightXZZZG,
       sum(CASE WHEN create_time='9月'  THEN XZZZG END) AS  NineXZZZG,
       sum(CASE WHEN create_time='10月' THEN XZZZG END) AS  TenXZZZG,
       sum(CASE WHEN create_time='11月' THEN XZZZG END) AS  ElevenXZZZG,
       sum(CASE WHEN create_time='12月' THEN XZZZG END) AS  TwelveXZZZG,
       SUM(CASE WHEN create_time='年初' THEN ZHUYING END) AS ZeroZHUYING, 
     sum(CASE WHEN create_time='1月'  THEN ZHUYING END) AS  OneZHUYING,
       sum(CASE WHEN create_time='2月'  THEN ZHUYING END) AS  TwoZHUYING,
       sum(CASE WHEN create_time='3月'  THEN ZHUYING END) AS  ThreeZHUYING,
       sum(CASE WHEN create_time='4月'  THEN ZHUYING END) AS  FourZHUYING,
       sum(CASE WHEN create_time='5月'  THEN ZHUYING END) AS  FiveZHUYING,
       sum(CASE WHEN create_time='6月'  THEN ZHUYING END) AS  SixZHUYING,
       sum(CASE WHEN create_time='7月'  THEN ZHUYING END) AS  SevenZHUYING,
       sum(CASE WHEN create_time='8月'  THEN ZHUYING END) AS  EightZHUYING,
       sum(CASE WHEN create_time='9月'  THEN ZHUYING END) AS  NineZHUYING,
       sum(CASE WHEN create_time='10月' THEN ZHUYING END) AS  TenZHUYING,
       sum(CASE WHEN create_time='11月' THEN ZHUYING END) AS  ElevenZHUYING,
       sum(CASE WHEN create_time='12月' THEN ZHUYING END) AS  TwelveZHUYING,
     SUM(CASE WHEN create_time='年初' THEN RJFWGSB END) AS ZeroRJFWGSB, 
     sum(CASE WHEN create_time='1月'  THEN RJFWGSB END) AS  OneRJFWGSB,
       sum(CASE WHEN create_time='2月'  THEN RJFWGSB END) AS  TwoRJFWGSB,
       sum(CASE WHEN create_time='3月'  THEN RJFWGSB END) AS  ThreeRJFWGSB,
       sum(CASE WHEN create_time='4月'  THEN RJFWGSB END) AS  FourRJFWGSB,
       sum(CASE WHEN create_time='5月'  THEN RJFWGSB END) AS  FiveRJFWGSB,
       sum(CASE WHEN create_time='6月'  THEN RJFWGSB END) AS  SixRJFWGSB,
       sum(CASE WHEN create_time='7月'  THEN RJFWGSB END) AS  SevenRJFWGSB,
       sum(CASE WHEN create_time='8月'  THEN RJFWGSB END) AS  EightRJFWGSB,
       sum(CASE WHEN create_time='9月'  THEN RJFWGSB END) AS  NineRJFWGSB,
       sum(CASE WHEN create_time='10月' THEN RJFWGSB END) AS  TenRJFWGSB,
       sum(CASE WHEN create_time='11月' THEN RJFWGSB END) AS  ElevenRJFWGSB,
       sum(CASE WHEN create_time='12月' THEN RJFWGSB END) AS  TwelveRJFWGSB  FROM 
ODM_HR_RJFWGSB1
WHERE 1 = 1
 ${IF(DWMC = 'HX_HEAD',
            " and TREE_NODE2 in (SELECT TREE_NODE FROM ODM_HR_DW WHERE PARENT_NODE ='HX_HEAD')",
            " and TREE_NODE2 <> TREE_NODE and parent_nodes like '%" + DWMC + "%'") }]]></Query>
</TableData>
<TableData name="xzncfwb" class="com.fr.data.impl.DBTableData">
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
<![CDATA[WebReport/ReportServer?formlet=HXXF_HR/HR_QUIT/Management_XZ.frm&op=view]]></O>
</ColumnConfig>
<ColumnConfig name="CPT" isKey="false" skipUnmodified="false">
<O>
<![CDATA[Management_XZ.frm]]></O>
</ColumnConfig>
<ColumnConfig name="CPT_NAME" isKey="false" skipUnmodified="false">
<O>
<![CDATA[行政人均服务比]]></O>
</ColumnConfig>
<ColumnConfig name="REGISTER_ENTER_ID" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=UUID(33)]]></Attributes>
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
<FRFont name="SimSun" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Alpha alpha="1.0"/>
</Border>
<LCAttr vgap="0" hgap="0" compInterval="0"/>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WAbsoluteLayout">
<WidgetName name="absolute2"/>
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
<BoundsAttr x="938" y="706" width="56" height="434"/>
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
<BoundsAttr x="0" y="706" width="68" height="434"/>
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
<![CDATA[914400,1440000,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[4343400,6172200,6057900,0,6286500,5105400,0,4572000,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<O>
<![CDATA[  ]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="1" cs="8" s="0">
<O>
<![CDATA[本单位各月指标执行情况]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="1" s="1">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="2" s="2">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=YEAR($date_time)]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="2" s="2">
<O>
<![CDATA[行政人数]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="2" s="2">
<O>
<![CDATA[主营人数]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="2" s="2">
<O>
<![CDATA[HR服务比]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="2" s="2">
<O>
<![CDATA[行政服务比]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="2" s="2">
<O>
<![CDATA[环比]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="2" s="2">
<O>
<![CDATA[]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="2" s="2">
<O>
<![CDATA[同比]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="2" s="3">
<O>
<![CDATA[]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="3" s="2">
<O>
<![CDATA[年初]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="3" s="2">
<O t="DSColumn">
<Attributes dsName="lzrs" columnName="ZEROXZZZG"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[IF(LEN($$$)=0,"0",$$$)]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="2" r="3" s="2">
<O t="DSColumn">
<Attributes dsName="lzrs" columnName="ZEROZHUYING"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="3" r="3" s="2">
<O t="DSColumn">
<Attributes dsName="lzrs" columnName="ZERORJFWGSB"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="4" r="3" s="2">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=ROUND((C4/B4),0)+":1"]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ = null]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="5" r="3" s="2">
<O>
<![CDATA[-]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="3" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="3" s="2">
<O>
<![CDATA[-]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="3" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="4" s="2">
<O>
<![CDATA[1月]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="4" s="2">
<O t="DSColumn">
<Attributes dsName="lzrs" columnName="ONEXZZZG"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[IF(LEN($$$)=0,"0",$$$)]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ = NULL]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="2" r="4" s="2">
<O t="DSColumn">
<Attributes dsName="lzrs" columnName="ONEZHUYING"/>
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
<![CDATA[$$$ = null]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="3" r="4" s="2">
<O t="DSColumn">
<Attributes dsName="lzrs" columnName="ONERJFWGSB"/>
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
<![CDATA[$$$ = null]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="4" r="4" s="2">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=ROUND((C5/B5),0)+":1"]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ = null]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="5" r="4" s="4">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(LEN(D5) = 0, "", (D5 / D4 - 1))]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ = null]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="6" r="4" s="2">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ = null]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="7" r="4" s="4">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(LEN(D5) = 0, "", (D5 / D4 - 1))]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ = null]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="8" r="4" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="5" s="2">
<O>
<![CDATA[2月]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="5" s="2">
<O t="DSColumn">
<Attributes dsName="lzrs" columnName="TWOXZZZG"/>
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
<![CDATA[AND($$$ = null,MONTH(NOW()) >= 2)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<2]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="2" r="5" s="2">
<O t="DSColumn">
<Attributes dsName="lzrs" columnName="TWOZHUYING"/>
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
<![CDATA[AND($$$ = null,MONTH(NOW()) >= 2)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<2]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="3" r="5" s="2">
<O t="DSColumn">
<Attributes dsName="lzrs" columnName="TWORJFWGSB"/>
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
<![CDATA[AND($$$ = null,MONTH(NOW()) >= 2)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<2]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="4" r="5" s="2">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=ROUND((C6/B6),0)+":1"]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[AND($$$ = null,MONTH(NOW()) >= 2)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<2]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="5" r="5" s="4">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(LEN(D6) = 0, "", (D6 / D5 - 1))]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[AND($$$ = null,MONTH(NOW()) >= 2)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<2]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="6" r="5" s="2">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[AND($$$ = null,MONTH(NOW()) >= 2)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<2]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="7" r="5" s="4">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(LEN(D6) = 0, "", (D6 / D4 - 1))]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[AND($$$ = null,MONTH(NOW()) >= 2)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<2]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="8" r="5" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="6" s="2">
<O>
<![CDATA[3月]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="6" s="2">
<O t="DSColumn">
<Attributes dsName="lzrs" columnName="THREEXZZZG"/>
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
<![CDATA[AND($$$ = null,MONTH(NOW())>=3)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<3]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="2" r="6" s="2">
<O t="DSColumn">
<Attributes dsName="lzrs" columnName="THREEZHUYING"/>
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
<![CDATA[AND($$$ = null,MONTH(NOW())>=3)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<3]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="3" r="6" s="2">
<O t="DSColumn">
<Attributes dsName="lzrs" columnName="THREERJFWGSB"/>
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
<![CDATA[AND($$$ = null,MONTH(NOW())>=3)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<3]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="4" r="6" s="2">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=ROUND((C7/B7),0)+":1"]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[AND($$$ = null,MONTH(NOW())>=3)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<3]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="5" r="6" s="4">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(LEN(D7) = 0, "", (D7 / D6 - 1))]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[AND($$$ = null,MONTH(NOW())>=3)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<3]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="6" r="6" s="2">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[AND($$$ = null,MONTH(NOW())>=3)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<3]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="7" r="6" s="4">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(LEN(D7) = 0, "", (D7 / D4 - 1))]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[AND($$$ = null,MONTH(NOW())>=3)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<3]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="8" r="6" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="7" s="2">
<O>
<![CDATA[4月]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="7" s="2">
<O t="DSColumn">
<Attributes dsName="lzrs" columnName="FOURXZZZG"/>
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
<![CDATA[AND($$$ = null,MONTH(NOW())>=4)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<4]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="2" r="7" s="2">
<O t="DSColumn">
<Attributes dsName="lzrs" columnName="FOURZHUYING"/>
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
<![CDATA[AND($$$ = null,MONTH(NOW())>=4)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<4]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="3" r="7" s="2">
<O t="DSColumn">
<Attributes dsName="lzrs" columnName="FOURRJFWGSB"/>
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
<![CDATA[AND($$$ = null,MONTH(NOW())>=4)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<4]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="4" r="7" s="2">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=ROUND((C8/B8),0)+":1"]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[AND($$$ = null,MONTH(NOW())>=4)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<4]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="5" r="7" s="4">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(LEN(D8) = 0, "", (D8 / D7 - 1))]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[AND($$$ = null,MONTH(NOW())>=4)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<4]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="6" r="7" s="2">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[AND($$$ = null,MONTH(NOW())>=4)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<4]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="7" r="7" s="4">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(LEN(D8) = 0, "", (D8 / D4 - 1))]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[AND($$$ = null,MONTH(NOW())>=4)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<4]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="8" r="7" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="8" s="2">
<O>
<![CDATA[5月]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="8" s="2">
<O t="DSColumn">
<Attributes dsName="lzrs" columnName="FIVEXZZZG"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[IF(LEN($$$)=0,"0",$$$)]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<5]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性3]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[AND($$$ = NULL,MONTH(NOW())>=5)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="2" r="8" s="2">
<O t="DSColumn">
<Attributes dsName="lzrs" columnName="FIVEZHUYING"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<5]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性3]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[AND($$$ = NULL,MONTH(NOW())>=5)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="3" r="8" s="2">
<O t="DSColumn">
<Attributes dsName="lzrs" columnName="FIVERJFWGSB"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<5]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性3]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[AND($$$ = NULL,MONTH(NOW())>=5)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="4" r="8" s="2">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=ROUND((C9/B9),0)+":1"]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<5]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性3]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[AND($$$ = NULL,MONTH(NOW())>=5)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="5" r="8" s="4">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(LEN(D9) = 0, "0", (D9 / D8 - 1))]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<5]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性3]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[AND($$$ = NULL,MONTH(NOW())>=5)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="6" r="8" s="2">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<5]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性3]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[AND($$$ = NULL,MONTH(NOW())>=5)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="7" r="8" s="4">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(LEN(D9) = 0, "0", (D9 / D4 - 1))]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<5]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性3]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[AND($$$ = NULL,MONTH(NOW())>=5)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="8" r="8" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="9" s="2">
<O>
<![CDATA[6月]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="9" s="2">
<O t="DSColumn">
<Attributes dsName="lzrs" columnName="SIXXZZZG"/>
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
<![CDATA[AND($$$ = NULL,MONTH(NOW())>= 6)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<6]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="2" r="9" s="2">
<O t="DSColumn">
<Attributes dsName="lzrs" columnName="SIXZHUYING"/>
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
<![CDATA[AND($$$ = NULL,MONTH(NOW())>= 6)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<6]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="3" r="9" s="2">
<O t="DSColumn">
<Attributes dsName="lzrs" columnName="SIXRJFWGSB"/>
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
<![CDATA[AND($$$ = NULL,MONTH(NOW())>= 6)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<6]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="4" r="9" s="2">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=ROUND((C10/B10),0)+":1"]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[AND($$$ = NULL,MONTH(NOW())>= 6)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<6]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="5" r="9" s="4">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(LEN(D10) = 0, "", (D10 / D9 - 1))]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[AND($$$ = NULL,MONTH(NOW())>= 6)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<6]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="6" r="9" s="2">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[AND($$$ = NULL,MONTH(NOW())>= 6)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<6]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="7" r="9" s="4">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(LEN(D10) = 0, "", (D10 / D4 - 1))]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[AND($$$ = NULL,MONTH(NOW())>= 6)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<6]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="8" r="9" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="10" s="2">
<O>
<![CDATA[7月]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="10" s="2">
<O t="DSColumn">
<Attributes dsName="lzrs" columnName="SEVENXZZZG"/>
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
<![CDATA[AND($$$ = null,MONTH(NOW())>=7)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<7]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="2" r="10" s="2">
<O t="DSColumn">
<Attributes dsName="lzrs" columnName="SEVENZHUYING"/>
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
<![CDATA[AND($$$ = null,MONTH(NOW())>=7)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<7]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="3" r="10" s="2">
<O t="DSColumn">
<Attributes dsName="lzrs" columnName="SEVENRJFWGSB"/>
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
<![CDATA[AND($$$ = null,MONTH(NOW())>=7)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<7]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="4" r="10" s="2">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=ROUND((C11/B11),0)+":1"]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[AND($$$ = null,MONTH(NOW())>=7)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<7]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="5" r="10" s="4">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(LEN(D11) = 0, "", (D11 / D10 - 1))]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[AND($$$ = null,MONTH(NOW())>=7)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<7]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="6" r="10" s="2">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[AND($$$ = null,MONTH(NOW())>=7)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<7]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="7" r="10" s="4">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(LEN(D11) = 0, "", (D11 / D4 - 1))]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[AND($$$ = null,MONTH(NOW())>=7)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<7]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="8" r="10" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="11" s="2">
<O>
<![CDATA[8月]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="11" s="2">
<O t="DSColumn">
<Attributes dsName="lzrs" columnName="EIGHTXZZZG"/>
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
<![CDATA[AND($$$ = null,MONTH(NOW())>=8)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<8]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="2" r="11" s="2">
<O t="DSColumn">
<Attributes dsName="lzrs" columnName="EIGHTZHUYING"/>
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
<![CDATA[AND($$$ = null,MONTH(NOW())>=8)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<8]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="3" r="11" s="2">
<O t="DSColumn">
<Attributes dsName="lzrs" columnName="EIGHTRJFWGSB"/>
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
<![CDATA[AND($$$ = null,MONTH(NOW())>=8)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<8]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="4" r="11" s="2">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=ROUND((C12/B12),0)+":1"]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[AND($$$ = null,MONTH(NOW())>=8)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<8]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="5" r="11" s="4">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(LEN(D12) = 0, "", (D12 / D11 - 1))]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[AND($$$ = null,MONTH(NOW())>=8)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<8]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="6" r="11" s="2">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[AND($$$ = null,MONTH(NOW())>=8)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<8]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="7" r="11" s="4">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(LEN(D12) = 0, "", (D12 / D4 - 1))]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[AND($$$ = null,MONTH(NOW())>=8)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<8]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="8" r="11" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="12" s="2">
<O>
<![CDATA[9月]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="12" s="2">
<O t="DSColumn">
<Attributes dsName="lzrs" columnName="NINEXZZZG"/>
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
<![CDATA[AND($$$ = null,MONTH(NOW()) >= 9)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<9]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="2" r="12" s="2">
<O t="DSColumn">
<Attributes dsName="lzrs" columnName="NINEZHUYING"/>
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
<![CDATA[AND($$$ = null,MONTH(NOW()) >= 9)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<9]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="3" r="12" s="2">
<O t="DSColumn">
<Attributes dsName="lzrs" columnName="NINERJFWGSB"/>
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
<![CDATA[AND($$$ = null,MONTH(NOW()) >= 9)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<9]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="4" r="12" s="2">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=ROUND((C13/B13),0)+":1"]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[AND($$$ = null,MONTH(NOW()) >= 9)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<9]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="5" r="12" s="4">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(LEN(D13) = 0, "", (D13 / D12 - 1))]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[AND($$$ = null,MONTH(NOW()) >= 9)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<9]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="6" r="12" s="2">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[AND($$$ = null,MONTH(NOW()) >= 9)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<9]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="7" r="12" s="4">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(LEN(D13) = 0, "", (D13 / D4 - 1))]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[AND($$$ = null,MONTH(NOW()) >= 9)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<9]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="8" r="12" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="13" s="2">
<O>
<![CDATA[10月]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="13" s="2">
<O t="DSColumn">
<Attributes dsName="lzrs" columnName="TENXZZZG"/>
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
<![CDATA[AND($$$ = null,MONTH(NOW())>=10)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<10]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="2" r="13" s="2">
<O t="DSColumn">
<Attributes dsName="lzrs" columnName="TENZHUYING"/>
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
<![CDATA[AND($$$ = null,MONTH(NOW())>=10)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<10]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="3" r="13" s="2">
<O t="DSColumn">
<Attributes dsName="lzrs" columnName="TENRJFWGSB"/>
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
<![CDATA[AND($$$ = null,MONTH(NOW())>=10)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<10]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="4" r="13" s="2">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=ROUND((C14/B14),0)+":1"]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[AND($$$ = null,MONTH(NOW())>=10)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<10]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="5" r="13" s="4">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(LEN(D14) = 0, "", (D14 / D13 - 1))]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[AND($$$ = null,MONTH(NOW())>=10)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<10]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="6" r="13" s="2">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[AND($$$ = null,MONTH(NOW())>=10)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<10]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="7" r="13" s="4">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(LEN(D14) = 0, "", (D14 / D4 - 1))]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[AND($$$ = null,MONTH(NOW())>=10)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<10]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="8" r="13" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="14" s="2">
<O>
<![CDATA[11月]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="14" s="2">
<O t="DSColumn">
<Attributes dsName="lzrs" columnName="ELEVENXZZZG"/>
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
<![CDATA[AND($$$ = null,MONTH(NOW())>=11)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<11]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="2" r="14" s="2">
<O t="DSColumn">
<Attributes dsName="lzrs" columnName="ELEVENZHUYING"/>
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
<![CDATA[AND($$$ = null,MONTH(NOW())>=11)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<11]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="3" r="14" s="2">
<O t="DSColumn">
<Attributes dsName="lzrs" columnName="ELEVENRJFWGSB"/>
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
<![CDATA[AND($$$ = null,MONTH(NOW())>=11)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<11]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="4" r="14" s="2">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=ROUND((C15/B15),0)+":1"]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[AND($$$ = null,MONTH(NOW())>=11)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<11]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="5" r="14" s="4">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(LEN(D15) = 0, "", (D15 / D14 - 1))]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[AND($$$ = null,MONTH(NOW())>=11)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<11]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="6" r="14" s="2">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[AND($$$ = null,MONTH(NOW())>=11)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<11]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="7" r="14" s="4">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(LEN(D15) = 0, "", (D15 / D4 - 1))]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[AND($$$ = null,MONTH(NOW())>=11)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<11]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="8" r="14" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="15" s="2">
<O>
<![CDATA[12月]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="15" s="2">
<O t="DSColumn">
<Attributes dsName="lzrs" columnName="TWELVEXZZZG"/>
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
<![CDATA[AND($$$ = null,MONTH(NOW()) >=12)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<12]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="2" r="15" s="2">
<O t="DSColumn">
<Attributes dsName="lzrs" columnName="TWELVEZHUYING"/>
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
<![CDATA[AND($$$ = null,MONTH(NOW()) >=12)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<12]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="3" r="15" s="2">
<O t="DSColumn">
<Attributes dsName="lzrs" columnName="TWELVERJFWGSB"/>
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
<![CDATA[AND($$$ = null,MONTH(NOW()) >=12)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<12]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="4" r="15" s="2">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=ROUND((C16/B16),0)+":1"]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[AND($$$ = null,MONTH(NOW()) >=12)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<12]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="5" r="15" s="4">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(LEN(D16) = 0, "", (D16 / D15 - 1))]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[AND($$$ = null,MONTH(NOW()) >=12)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<12]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="6" r="15" s="2">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[AND($$$ = null,MONTH(NOW()) >=12)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<12]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="7" r="15" s="4">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(LEN(D16) = 0, "", (D16 / D4 - 1))]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[AND($$$ = null,MONTH(NOW()) >=12)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[0]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<12]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="8" r="15" s="3">
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
<FRFont name="微软雅黑" style="1" size="96" foreground="-1"/>
<Background name="ColorBackground" color="-4259840"/>
<Border>
<Top style="1" color="-3881788"/>
<Bottom style="1" color="-3881788"/>
<Left style="1" color="-3881788"/>
<Right style="1" color="-3881788"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="96"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-3881788"/>
<Bottom style="1" color="-3881788"/>
<Left style="1" color="-3881788"/>
<Right style="1" color="-3881788"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0.0%]]></Format>
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-3881788"/>
<Bottom style="1" color="-3881788"/>
<Left style="1" color="-3881788"/>
<Right style="1" color="-3881788"/>
</Border>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<isShared isshared="false"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="0" zoom="true" refresh="false" isUseHTML="false"/>
</InnerWidget>
<BoundsAttr x="68" y="0" width="870" height="332"/>
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
<BoundsAttr x="68" y="706" width="870" height="332"/>
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
<![CDATA[1295400,864000,864000,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[3810000,2743200,2743200,0,2743200,2743200,0,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="1" s="0">
<O>
<![CDATA[数据口径说明：]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1" cs="10" s="1">
<O>
<![CDATA[1 行政统计口径：职能序列为“15-行”，含非主营/实习生，不含2018级常青藤]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="2" s="1">
<O>
<![CDATA[]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="2" cs="10" s="1">
<O>
<![CDATA[2 行政人均服务比= 主营全体在岗员工 / {行政在岗数（含主营、非主营、实习生）-2018级常青藤}]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="3">
<O>
<![CDATA[  ]]></O>
<PrivilegeControl/>
</C>
<C c="0" r="4">
<O>
<![CDATA[  ]]></O>
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
<Style horizontal_alignment="4" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="64"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="64"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<isShared isshared="false"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="0" zoom="true" refresh="false" isUseHTML="false"/>
</InnerWidget>
<BoundsAttr x="68" y="0" width="870" height="102"/>
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
<![CDATA[1295400,864000,864000,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,2743200,2743200,0,2743200,2743200,0,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
</C>
<C c="0" r="1" s="0">
<O>
<![CDATA[数据口径说明：]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1" cs="7" s="1">
<O>
<![CDATA[1 行政统计口径：职能序列为“15-行”，含非主营/实习生，不含2017级/2018级常青藤]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="2" s="1">
<O>
<![CDATA[]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="2" cs="7" s="1">
<O>
<![CDATA[2 行政人均服务比=主营全体在岗员工/{行政在岗数（含主营、非主营、实习生）-2017级2018级常青藤}]]></O>
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
<FRFont name="微软雅黑" style="0" size="64"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="64"/>
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
<BoundsAttr x="68" y="1038" width="870" height="102"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="label2"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<widgetValue/>
<LabelAttr verticalcenter="true" textalign="0" autoline="true"/>
<FRFont name="SimSun" style="0" size="72"/>
<border style="0" color="-723724"/>
</InnerWidget>
<BoundsAttr x="500" y="0" width="375" height="25"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.FreeButton">
<Listener event="click">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="date_time1"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$date_time]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="dwmc1"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$dwmc]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="username1"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$username]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[/*var url = FR.cjkEncode("/WebReport/ReportServer?formlet=HXXF_HR%2FHR_QUIT%2FManagement_ZYFX.frm"); FR.doHyperlinkByGet({url:url,title:'Management_monitoring',target:'_self',date_time:date_time1,dwmc:dwmc1});  */
location=FR.cjkEncode("/WebReport/ReportServer?formlet=HXXF_HR%2FHR_QUIT%2FManagement_GB.frm&date_time="+date_time1+"&dwmc="+dwmc1+"&username="+username1);]]></Content>
</JavaScript>
</Listener>
<WidgetName name="button1"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Text>
<![CDATA[下一指标]]></Text>
<FRFont name="微软雅黑" style="0" size="72" foreground="-16776961" underline="1"/>
<isCustomType isCustomType="true"/>
</InnerWidget>
<BoundsAttr x="170" y="0" width="63" height="25"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.FreeButton">
<Listener event="click">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="date_time1"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$date_time]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="dwmc1"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$dwmc]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="username1"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$username]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[/*var url = FR.cjkEncode("/WebReport/ReportServer?formlet=HXXF_HR%2FHR_QUIT%2FManagement_HR.frm");
FR.doHyperlinkByGet({url:url,title:'Management_monitoring',target:'_self',date_time:date_time1,dwmc:dwmc1});  */

location=FR.cjkEncode("/WebReport/ReportServer?formlet=HXXF_HR%2FHR_QUIT%2FManagement_HR.frm&date_time="+date_time1+"&dwmc="+dwmc1+"&username="+username1);]]></Content>
</JavaScript>
</Listener>
<WidgetName name="button2"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Text>
<![CDATA[上一指标]]></Text>
<FRFont name="微软雅黑" style="0" size="72" foreground="-16776961" underline="1"/>
<isCustomType isCustomType="true"/>
</InnerWidget>
<BoundsAttr x="106" y="0" width="64" height="25"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="label1"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O>
<![CDATA[行政人均服务比]]></O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="0" autoline="true"/>
<FRFont name="微软雅黑" style="1" size="160"/>
<border style="0" color="-723724"/>
</InnerWidget>
<BoundsAttr x="0" y="25" width="994" height="40"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WScaleLayout">
<WidgetName name="mc1"/>
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
<InnerWidget class="com.fr.form.ui.TextEditor">
<WidgetName name="mc1"/>
<WidgetAttr invisible="true" description="">
<PrivilegeControl/>
</WidgetAttr>
<TextAttr/>
<widgetValue>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=sql("HXXF_HR","SELECT REPLACE(PARENT_NAME,'<','_')  as PARENT_NAME FROM  ODM_HR_DW where tree_node='"+DWMC+"' ",1)]]></Attributes>
</O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="233" y="0" width="37" height="21"/>
</Widget>
</InnerWidget>
<BoundsAttr x="233" y="0" width="37" height="25"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.FreeButton">
<WidgetName name="button3"/>
<WidgetAttr invisible="true" description="">
<PrivilegeControl/>
</WidgetAttr>
<Text>
<![CDATA[下载WORD]]></Text>
<FRFont name="微软雅黑" style="0" size="72" underline="1"/>
<isCustomType isCustomType="true"/>
</InnerWidget>
<BoundsAttr x="875" y="0" width="101" height="25"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.FreeButton">
<Listener event="click">
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
</Parameters>
<Content>
<![CDATA[var sql="SELECT REPLACE(PARENT_NAME,'<','_')  as PARENT_NAME FROM  ODM_HR_DW where tree_node='"+dwmc1+"' "
var res=FR.remoteEvaluate("=sql(\"HXXF_HR\",\""+sql+"\",1)");


var sql1="SELECT to_char(to_date('"+date_time1+"','YYYY-mm-dd'),'yyyymmdd')  as time FROM dual "
var res1=FR.remoteEvaluate("=sql(\"HXXF_HR\",\""+sql1+"\",1)");

var url = FR.cjkEncode("/WebReport/ReportServer?reportlet=HXXF_HR%2FHR_QUIT%2FXZ_PerCapita.cpt&date_time="+date_time1+"&dwmc="+dwmc1+"&format=excel&extype=simple&__filename__="+ res+"_行政人均服务比_"+res1);
//alert(0)
window.open(url);]]></Content>
</JavaScript>
</Listener>
<Listener event="click">
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
<![CDATA[WebReport/ReportServer?formlet=HXXF_HR/HR_QUIT/Management_zyfx.frm&op=view]]></O>
</ColumnConfig>
<ColumnConfig name="CPT" isKey="false" skipUnmodified="false">
<O>
<![CDATA[Management_zyfx.frm]]></O>
</ColumnConfig>
<ColumnConfig name="CPT_NAME" isKey="false" skipUnmodified="false">
<O>
<![CDATA[行政人均服务改善比]]></O>
</ColumnConfig>
<ColumnConfig name="REGISTER_ID" isKey="false" skipUnmodified="false">
<O>
<![CDATA[]]></O>
</ColumnConfig>
<ColumnConfig name="REGISTER_ENTER_ID" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=uuid(33)]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="PARAMETER_TREE" isKey="false" skipUnmodified="false">
<O>
<![CDATA[]]></O>
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
<ColumnConfig name="REGISTER_ENTER_NUM" isKey="false" skipUnmodified="false">
<O>
<![CDATA[]]></O>
</ColumnConfig>
<ColumnConfig name="TIME" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=now()]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="DOWNLOAD_TYPE" isKey="false" skipUnmodified="false">
<O>
<![CDATA[1]]></O>
</ColumnConfig>
<ColumnConfig name="HYPERLINK_NAME" isKey="false" skipUnmodified="false">
<O>
<![CDATA[]]></O>
</ColumnConfig>
<ColumnConfig name="HYPERLINK_PARAMETER" isKey="false" skipUnmodified="false">
<O>
<![CDATA[]]></O>
</ColumnConfig>
<ColumnConfig name="HYPERLINK_TYPE" isKey="false" skipUnmodified="false">
<O>
<![CDATA[]]></O>
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
<ColumnConfig name="YGID" isKey="false" skipUnmodified="false">
<O>
<![CDATA[]]></O>
</ColumnConfig>
<ColumnConfig name="ISDOWNLOADJL" isKey="false" skipUnmodified="false">
<O>
<![CDATA[]]></O>
</ColumnConfig>
<ColumnConfig name="FILENAME_ID" isKey="false" skipUnmodified="false">
<O>
<![CDATA[]]></O>
</ColumnConfig>
<ColumnConfig name="IP" isKey="false" skipUnmodified="false">
<O>
<![CDATA[]]></O>
</ColumnConfig>
<ColumnConfig name="LIANJIE2" isKey="false" skipUnmodified="false">
<O>
<![CDATA[]]></O>
</ColumnConfig>
<ColumnConfig name="DAOCHU2" isKey="false" skipUnmodified="false">
<O>
<![CDATA[]]></O>
</ColumnConfig>
<ColumnConfig name="LIANJIE3" isKey="false" skipUnmodified="false">
<O>
<![CDATA[]]></O>
</ColumnConfig>
<ColumnConfig name="DAOCHU3" isKey="false" skipUnmodified="false">
<O>
<![CDATA[]]></O>
</ColumnConfig>
<Condition class="com.fr.data.condition.ListCondition"/>
</DMLConfig>
</JavaScript>
</Listener>
<WidgetName name="button4"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Text>
<![CDATA[下载EXCEL]]></Text>
<FRFont name="微软雅黑" style="0" size="72" foreground="-16776961" underline="1"/>
<isCustomType isCustomType="true"/>
</InnerWidget>
<BoundsAttr x="976" y="0" width="18" height="25"/>
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
<![CDATA[723900,0,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[419100,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="0" cs="8" s="0">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="截止至" +"<span style='color:#bf0008; font-weight: bold;'>"+YEAR($date_time)+"年"+MONTH($date_time)+"月"+DAY($date_time)+"日,"+ $mc1+"</span>"+" 实际在岗行政 " + "<span style='color:#bf0008; font-weight: bold;'>"+ B2 + "</span>" + CONCATENATE("<font color=#000000 font-weight: bold;>", " 人 ，服务主营员工 ", "<font color=#000000 sont-weight: bold;>") +"<span style='color:#bf0008; font-weight: bold;'>"+ C2+ "</span>" + CONCATENATE("<font color=#000000 sont-weight: bold;>", " 人 ，当前行政服务比 ", "<font color=#000000 sont-weight: bold;>") + "<span style='color:#bf0008; font-weight: bold;'>"+ D2+ "</span>"+ CONCATENATE("<font color=#000000 sont-weight: bold;>", "，年初行政服务比 "+"<span style='color:#bf0008; font-weight: bold;'>"+ E2+ "</span>", "<font color=#000000 sont-weight: bold;>","。")]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="1" r="1">
<O t="DSColumn">
<Attributes dsName="RJFWGSB" columnName="XZZZG"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="2" r="1">
<O t="DSColumn">
<Attributes dsName="RJFWGSB" columnName="ZHUYING"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="3" r="1">
<O t="DSColumn">
<Attributes dsName="RJFWGSB" columnName="RJFWGSB"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[IF(LEN($$$)=0,0,$$$)+":1"]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="4" r="1">
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
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<isShared isshared="false"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="0" zoom="true" refresh="false" isUseHTML="false"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="994" height="57"/>
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
<![CDATA[723900,0,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[419100,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="0" cs="8">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="截止至" +"<span style='color:#bf0008; font-weight: bold;'>"+YEAR($date_time)+"年"+MONTH($date_time)+"月"+DAY($date_time)+"日,"+$mc+"</span>"+"主营员工主动离职率" + "<span style='color:#bf0008; font-weight: bold;'>"+ B2+ "</span>" + CONCATENATE("<font color=#000000 font-weight: bold;>", "，累计辞职", "<font color=#000000 sont-weight: bold;>") +"<span style='color:#bf0008; font-weight: bold;'>"+ C2+ "</span>" + CONCATENATE("<font color=#000000 sont-weight: bold;>", "人，年初主营", "<font color=#000000 sont-weight: bold;>") + "<span style='color:#bf0008; font-weight: bold;'>"+ D2+ "</span>"+ CONCATENATE("<font color=#000000 sont-weight: bold;>", "人，当前主营"+E2+"人。", "<font color=#000000 sont-weight: bold;>")]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="1" r="1" s="0">
<O t="DSColumn">
<Attributes dsName="lzrs" columnName="ZDLZV"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="2" r="1" s="0">
<O t="DSColumn">
<Attributes dsName="lzrs" columnName="NDZDLZ"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="3" r="1">
<O t="DSColumn">
<Attributes dsName="lzrs" columnName="ZY_NC"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="4" r="1">
<O t="DSColumn">
<Attributes dsName="lzrs" columnName="ZY_DQ"/>
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
<BoundsAttr x="0" y="65" width="994" height="57"/>
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
<![CDATA[748800,748800,748800,748800,0,0,0,723900,723900,748800,748800,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[5867400,3962400,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="0" s="1">
<O t="DSColumn">
<Attributes dsName="ds1" columnName="DESCR2"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="1"/>
</C>
<C c="0" r="1" s="0">
<O>
<![CDATA[行政人数]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1" s="0">
<O t="DSColumn">
<Attributes dsName="ds1" columnName="XZZZG"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[IF(LEN($$$)=0,"0",$$$)]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="1"/>
</C>
<C c="0" r="2" s="0">
<O>
<![CDATA[主营人数]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="2" s="0">
<O t="DSColumn">
<Attributes dsName="ds1" columnName="ZHUYING"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[IF(LEN($$$)=0,"0",$$$)]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="1"/>
</C>
<C c="0" r="3" s="0">
<O>
<![CDATA[行政服务比]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="3" s="0">
<O t="DSColumn">
<Attributes dsName="ds1" columnName="RJFWGSB"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[IF(or(B2=0,B3=0),concatenate(B3,":",B2),CONCATENATE($$$,":1"))]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="1"/>
</C>
<C c="0" r="4" s="0">
<O>
<![CDATA[年初行政总在岗]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="4" s="0">
<O t="DSColumn">
<Attributes dsName="ds1" columnName="NCXZZZG"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="1"/>
</C>
<C c="0" r="5" s="0">
<O>
<![CDATA[年初17常青藤]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="5" s="0">
<O t="DSColumn">
<Attributes dsName="ds1" columnName="NCXZCQT17"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="1"/>
</C>
<C c="0" r="6" s="0">
<O>
<![CDATA[年初18常青藤]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="6" s="0">
<O t="DSColumn">
<Attributes dsName="ds1" columnName="NCXZCQT18"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="1"/>
</C>
<C c="0" r="7" s="0">
<O>
<![CDATA[年初行政人数]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="7" s="0">
<O t="DSColumn">
<Attributes dsName="ds1" columnName="NCXZ"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[IF(LEN($$$) = 0, 0, $$$)]]></Content>
</Present>
<Expand dir="1"/>
</C>
<C c="0" r="8" s="0">
<O>
<![CDATA[年初主营人数]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="8" s="0">
<O t="DSColumn">
<Attributes dsName="ds1" columnName="NCZHUYING"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[IF(LEN($$$) = 0, 0, $$$)]]></Content>
</Present>
<Expand dir="1"/>
</C>
<C c="0" r="9" s="2">
<O>
<![CDATA[年初服务比]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="9" s="3">
<O t="DSColumn">
<Attributes dsName="ds1" columnName="NDFWB"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[if(len($$$)=0,0,ROUND($$$ ,0)+":1")]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="1"/>
</C>
<C c="0" r="10" s="0">
<O>
<![CDATA[改善比]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="10" s="4">
<O t="DSColumn">
<Attributes dsName="ds1" columnName="GSB"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[IF(LEN($$$) = 0, 0, $$$)]]></Content>
</Present>
<Expand dir="1"/>
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
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-5197648"/>
<Bottom style="1" color="-5197648"/>
<Left style="1" color="-5197648"/>
<Right style="1" color="-5197648"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="80" foreground="-1"/>
<Background name="ColorBackground" color="-2949112"/>
<Border>
<Top style="1" color="-5197648"/>
<Bottom style="1" color="-5197648"/>
<Left style="1" color="-5197648"/>
<Right style="1" color="-5197648"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-5197648"/>
<Left style="1" color="-5197648"/>
<Right style="1" color="-5197648"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-5197648"/>
<Right style="1" color="-5197648"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0.0%]]></Format>
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-5197648"/>
<Bottom style="1" color="-5197648"/>
<Right style="1" color="-5197648"/>
</Border>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<isShared isshared="false"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="0" zoom="true" refresh="false" isUseHTML="false"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="994" height="258"/>
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
<![CDATA[864000,864000,864000,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[4038600,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O>
<![CDATA[当月辞职]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="0" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="1" s="0">
<O>
<![CDATA[本年度累计辞职]]></O>
<PrivilegeControl/>
</C>
<C c="1" r="1" s="0">
<PrivilegeControl/>
</C>
<C c="0" r="2" s="0">
<O>
<![CDATA[本年度主动离职率]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="2" s="0">
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
<FRFont name="微软雅黑" style="0" size="72"/>
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
<BoundsAttr x="0" y="448" width="994" height="258"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="chart0"/>
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
<InnerWidget class="com.fr.form.ui.ChartEditor">
<WidgetName name="chart0"/>
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
<LayoutAttr selectedIndex="0"/>
<ChangeAttr enable="false" changeType="button" timeInterval="5" buttonColor="-8421505" carouselColor="-8421505">
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
<Attr lineStyle="0" isRoundBorder="false" roundRadius="5"/>
<newColor borderColor="-6908266"/>
</AttrBorder>
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
</GI>
<O>
<![CDATA[各单位行政人均服务比]]></O>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="1" size="120" foreground="-13421773"/>
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
<Attr lineStyle="0" isRoundBorder="false" roundRadius="3"/>
<newColor/>
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
<FRFont name="宋体" style="0" size="72"/>
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
<OColor colvalue="-3670008"/>
<OColor colvalue="-11184811"/>
<OColor colvalue="-16777216"/>
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
<newAxisAttr isShowAxisLabel="true"/>
<AxisLineStyle AxisStyle="1" MainGridStyle="1"/>
<newLineColor lineColor="-5197648"/>
<AxisPosition value="3"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr rotation="-30" alignText="0">
<FRFont name="微软雅黑" style="0" size="88" foreground="-10066330"/>
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
<newAxisAttr isShowAxisLabel="true"/>
<AxisLineStyle AxisStyle="0" MainGridStyle="1"/>
<newLineColor mainGridColor="-3881788" lineColor="-5197648"/>
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
<VanChartAxisAttr mainTickLine="0" secTickLine="0" axisName="Y轴" titleUseHtml="false" autoLabelGap="true" limitSize="true" maxHeight="15.0" commonValueFormat="true" isRotation="false"/>
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
<newAxisAttr isShowAxisLabel="true"/>
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
<VanChartCustomPlotAttr customStyle="stack_column_line"/>
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
<Attr lineStyle="1" isRoundBorder="false" roundRadius="0"/>
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
<Attr enable="true" duration="4" followMouse="false" showMutiSeries="true" isCustom="true"/>
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
<![CDATA[#0 人]]></Format>
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
<HtmlLabel customText="function(){ return this.category+this.seriesName+this.value;}" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
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
<Attr enable="true"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#.##%]]></Format>
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
<FRFont name="宋体" style="0" size="72"/>
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
<newAxisAttr isShowAxisLabel="true"/>
<AxisLineStyle AxisStyle="1" MainGridStyle="1"/>
<newLineColor lineColor="-5197648"/>
<AxisPosition value="3"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr rotation="-30" alignText="0">
<FRFont name="微软雅黑" style="0" size="88" foreground="-10066330"/>
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
<newAxisAttr isShowAxisLabel="true"/>
<AxisLineStyle AxisStyle="0" MainGridStyle="1"/>
<newLineColor mainGridColor="-3881788" lineColor="-5197648"/>
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
<VanChartAxisAttr mainTickLine="0" secTickLine="0" axisName="Y轴" titleUseHtml="false" autoLabelGap="true" limitSize="true" maxHeight="15.0" commonValueFormat="true" isRotation="false"/>
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
<newAxisAttr isShowAxisLabel="true"/>
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
<Attr xAxisIndex="0" yAxisIndex="0" stacked="true" percentStacked="false" stackID="堆积和坐标轴1"/>
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
<Attr lineWidth="2" lineStyle="0" nullValueBreak="true"/>
</VanAttrLine>
</Attr>
<Attr class="com.fr.plugin.chart.base.VanChartAttrMarker">
<VanAttrMarker>
<Attr isCommon="true" markerType="NullMarker" radius="4.5" width="30.0" height="30.0"/>
<Background name="NullBackground"/>
</VanAttrMarker>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrTooltip">
<AttrTooltip>
<Attr enable="true" duration="4" followMouse="false" showMutiSeries="true" isCustom="true"/>
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
<![CDATA[#0:1]]></Format>
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
<HtmlLabel customText="function(){ return this.category+this.seriesName+this.value;}" useHtml="true" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
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
<Attr showLine="false" autoAdjust="false" position="3" isCustom="false"/>
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
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0:1]]></Format>
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
<FRFont name="宋体" style="0" size="72"/>
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
<newAxisAttr isShowAxisLabel="true"/>
<AxisLineStyle AxisStyle="1" MainGridStyle="1"/>
<newLineColor lineColor="-5197648"/>
<AxisPosition value="3"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr rotation="-30" alignText="0">
<FRFont name="微软雅黑" style="0" size="88" foreground="-10066330"/>
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
<newAxisAttr isShowAxisLabel="true"/>
<AxisLineStyle AxisStyle="0" MainGridStyle="1"/>
<newLineColor mainGridColor="-3881788" lineColor="-5197648"/>
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
<VanChartAxisAttr mainTickLine="0" secTickLine="0" axisName="Y轴" titleUseHtml="false" autoLabelGap="true" limitSize="true" maxHeight="15.0" commonValueFormat="true" isRotation="false"/>
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
<newAxisAttr isShowAxisLabel="true"/>
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
<![CDATA[ds1]]></Name>
</TableData>
<CategoryName value="DESCR2"/>
<ChartSummaryColumn name="RJFWGSB" function="com.fr.data.util.function.NoneFunction" customName="行政服务比"/>
</MoreNameCDDefinition>
</DefinitionMap>
<DefinitionMap key="column">
<MoreNameCDDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[ds1]]></Name>
</TableData>
<CategoryName value="DESCR2"/>
<ChartSummaryColumn name="ZHUYING" function="com.fr.data.util.function.NoneFunction" customName="主营"/>
<ChartSummaryColumn name="XZZZG" function="com.fr.data.util.function.NoneFunction" customName="行政人数"/>
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
<attr moreLabel="true" autoTooltip="true"/>
<AttrTooltip>
<Attr enable="true" duration="4" followMouse="false" showMutiSeries="false" isCustom="false"/>
<TextAttr>
<Attr alignText="0"/>
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
</InnerWidget>
<BoundsAttr x="0" y="0" width="994" height="326"/>
</Widget>
<body class="com.fr.form.ui.ChartEditor">
<WidgetName name="chart0"/>
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
<LayoutAttr selectedIndex="0"/>
<ChangeAttr enable="false" changeType="button" timeInterval="5" buttonColor="-8421505" carouselColor="-8421505">
<TextAttr>
<Attr alignText="0"/>
</TextAttr>
</ChangeAttr>
<Chart name="默认" chartClass="com.fr.chart.chartattr.Chart">
<Chart class="com.fr.chart.chartattr.Chart">
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
<ChartAttr isJSDraw="true" isStyleGlobal="false"/>
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
<FRFont name="Microsoft YaHei" style="0" size="88"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<Plot class="com.fr.chart.chartattr.CustomPlot">
<CategoryPlot>
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
<Attr isNullValueBreak="true" autoRefreshPerSecond="0" seriesDragEnable="false" plotStyle="0" combinedSize="50.0"/>
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
<DefaultAttr class="com.fr.chart.chartglyph.CustomAttr">
<CustomAttr>
<ConditionAttr name=""/>
<ctattr renderer="1"/>
</CustomAttr>
</DefaultAttr>
</ConditionCollection>
<Legend>
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
<Attr position="4" visible="true"/>
<FRFont name="Microsoft YaHei" style="0" size="72"/>
</Legend>
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
<RectanglePlotAttr interactiveAxisTooltip="false"/>
<xAxis>
<CategoryAxis class="com.fr.chart.chartattr.CategoryAxis">
<newAxisAttr isShowAxisLabel="true"/>
<AxisLineStyle AxisStyle="1" MainGridStyle="0"/>
<newLineColor mainGridColor="-4144960" lineColor="-5197648"/>
<AxisPosition value="3"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="Microsoft YaHei" style="0" size="72"/>
</Attr>
</TextAttr>
<AxisLabelCount value="=0"/>
<AxisRange/>
<AxisUnit201106 isCustomMainUnit="false" isCustomSecUnit="false" mainUnit="=0" secUnit="=0"/>
<ZoomAxisAttr isZoom="false"/>
<axisReversed axisReversed="false"/>
</CategoryAxis>
</xAxis>
<yAxis>
<ValueAxis class="com.fr.chart.chartattr.ValueAxis">
<ValueAxisAttr201108 alignZeroValue="false"/>
<newAxisAttr isShowAxisLabel="true"/>
<AxisLineStyle AxisStyle="1" MainGridStyle="1"/>
<newLineColor mainGridColor="-4144960" lineColor="-5197648"/>
<AxisPosition value="2"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="Century Gothic" style="0" size="72"/>
</Attr>
</TextAttr>
<AxisLabelCount value="=0"/>
<AxisRange/>
<AxisUnit201106 isCustomMainUnit="false" isCustomSecUnit="false" mainUnit="=0" secUnit="=0"/>
<ZoomAxisAttr isZoom="false"/>
<axisReversed axisReversed="false"/>
</ValueAxis>
</yAxis>
<secondAxis>
<ValueAxis class="com.fr.chart.chartattr.ValueAxis">
<ValueAxisAttr201108 alignZeroValue="false"/>
<newAxisAttr isShowAxisLabel="true"/>
<AxisLineStyle AxisStyle="1" MainGridStyle="0"/>
<newLineColor mainGridColor="-4144960" lineColor="-5197648"/>
<AxisPosition value="4"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="Century Gothic" style="0" size="72"/>
</Attr>
</TextAttr>
<AxisLabelCount value="=0"/>
<AxisRange/>
<AxisUnit201106 isCustomMainUnit="false" isCustomSecUnit="false" mainUnit="=0" secUnit="=0"/>
<ZoomAxisAttr isZoom="false"/>
<axisReversed axisReversed="false"/>
</ValueAxis>
</secondAxis>
<CateAttr isStacked="false"/>
<CustomTypeConditionCollection>
<ConditionCollection>
<DefaultAttr class="com.fr.chart.chartglyph.CustomAttr">
<CustomAttr>
<ConditionAttr name="">
<AttrList>
<Attr class="com.fr.chart.base.AttrBarSeries">
<AttrBarSeries>
<Attr seriesOverlapPercent="-0.25" categoryIntervalPercent="1.0" axisPosition="LEFT"/>
</AttrBarSeries>
</Attr>
</AttrList>
</ConditionAttr>
<ctattr renderer="1"/>
</CustomAttr>
</DefaultAttr>
<ConditionAttrList>
<List index="0">
<CustomAttr>
<ConditionAttr name="系列设置1">
<AttrList>
<Attr class="com.fr.chart.base.AttrLineSeries">
<AttrLineSeries>
<Attr isCurve="false" isNullValueBreak="true" lineStyle="5" markerType="NullMarker" axisPosition="RIGHT"/>
</AttrLineSeries>
</Attr>
</AttrList>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[系列序号]]></CNAME>
<Compare op="0">
<O t="I">
<![CDATA[2]]></O>
</Compare>
</Condition>
</JoinCondition>
</Condition>
</ConditionAttr>
<ctattr renderer="2"/>
</CustomAttr>
</List>
</ConditionAttrList>
</ConditionCollection>
</CustomTypeConditionCollection>
</CategoryPlot>
</Plot>
<ChartDefinition>
<OneValueCDDefinition seriesName="DESCR2" valueName="ZY_ZT_LZ" function="com.fr.data.util.function.NoneFunction">
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[ds1]]></Name>
</TableData>
<CategoryName value="DESCR2"/>
</OneValueCDDefinition>
</ChartDefinition>
</Chart>
</Chart>
</body>
</InnerWidget>
<BoundsAttr x="0" y="122" width="994" height="326"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.FreeButton">
<Listener event="click">
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
<Attributes name="username1"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$username]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[/*var url = FR.cjkEncode("/WebReport/ReportServer?formlet=HXXF_HR%2FHR_QUIT%2FManagement_monitoring.frm"); FR.doHyperlinkByGet({url:url,title:'Management_monitoring',target:'_self'});  */
location=FR.cjkEncode("/WebReport/ReportServer?formlet=HXXF_HR%2FHR_QUIT%2FManagement_monitoring.frm&dwmc=")+dwmc1+"&username="+ username1;  ]]></Content>
</JavaScript>
</Listener>
<WidgetName name="button0"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Text>
<![CDATA[返回综合报告首页]]></Text>
<FRFont name="微软雅黑" style="0" size="72" foreground="-16776961" underline="1"/>
<isCustomType isCustomType="true"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="106" height="25"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="label0"/>
<WidgetAttr invisible="true" description="">
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$date_time]]></Attributes>
</O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="0" autoline="true"/>
<FRFont name="SimSun" style="0" size="72"/>
<border style="0" color="-723724"/>
</InnerWidget>
<BoundsAttr x="270" y="0" width="230" height="25"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="button0"/>
<Widget widgetName="button2"/>
<Widget widgetName="button1"/>
<Widget widgetName="mc1"/>
<Widget widgetName="label0"/>
<Widget widgetName="label2"/>
<Widget widgetName="button3"/>
<Widget widgetName="button4"/>
<Widget widgetName="label1"/>
<Widget widgetName="report3"/>
<Widget widgetName="chart0"/>
<Widget widgetName="report1"/>
<Widget widgetName="absolute0"/>
<Widget widgetName="report0"/>
<Widget widgetName="absolute2"/>
<Widget widgetName="report2"/>
</MobileWidgetList>
<WidgetZoomAttr compState="1"/>
<AppRelayout appRelayout="true"/>
<Size width="994" height="1140"/>
<ResolutionScalingAttr percent="0.9"/>
<BodyLayoutType type="0"/>
</Center>
</Layout>
<DesignerVersion DesignerVersion="IAA"/>
<PreviewType PreviewType="0"/>
<TemplateID TemplateID="2a5517ec-9dd1-4c13-a219-32170f62ab83"/>
</Form>
