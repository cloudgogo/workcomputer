<?xml version="1.0" encoding="UTF-8"?>
<Form xmlVersion="20170715" releaseVersion="8.0.0">
<TableDataMap>
<TableData name="每月各单位数据数据表" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="FENLEI"/>
<O>
<![CDATA[1]]></O>
</Parameter>
<Parameter>
<Attributes name="DWMC"/>
<O>
<![CDATA[HX_HEAD]]></O>
</Parameter>
<Parameter>
<Attributes name="username"/>
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
<![CDATA[WITH TT1  AS 
(
-----------当月各业务单位----------
SELECT COUNT(CASE WHEN ${if(OR(len(FENLEI)==0,FENLEI=2),"1=1","1=0")} THEN YGID 
           WHEN ${if(FENLEI=1,"ISZHUYING='主营'","1=0")} THEN YGID 
	      WHEN ${if(FENLEI=0,"ISZHUYING<>'主营'","1=0")}  THEN YGID END) AS HZS,
		  descr AS DESCR,
		  TREE_NODE AS TREE_NODE,
		  parent_name AS PARENT_NAME,
		  back_ana AS BACK_ANA,
		  TREE_NODE_NUM
FROM 
( 
   SELECT 
   t2.TREE_NODE_NUM,
 t1.ygid,
 t2.descr,
 T2.TREE_NODE,
 t2.parent_name,
 t2.back_ana,
 ISZHUYING
 FROM  odm_hr_ygtz t1,odm_hr_dw t2
 WHERE t1.tree_node_id like '%' || t2.tree_node || '%' 
 AND  PARENT_NODE ='${DWMC}'
 --AND  T1.BUMENID<>'${DWMC}'
  UNION ALL
  SELECT 
   t2.TREE_NODE_NUM,
 t1.ygid,
 t2.descr,
 T2.TREE_NODE,
 t2.parent_name,
 t2.back_ana,
 ISZHUYING
 FROM  odm_hr_ygtz t1, odm_hr_dw t2
 WHERE t1.tree_node_id like '%' || t2.tree_node || '%' 
 AND  TREE_NODE ='${DWMC}' 
 --AND  T1.BUMENID <>'${DWMC}'
 UNION ALL
  SELECT 
   t2.TREE_NODE_NUM,
 t1.ygid,
 '公司领导' AS descr,
 T2.TREE_NODE,
 t2.parent_name,
 t2.back_ana,
 ISZHUYING
 FROM  odm_hr_ygtz t1,odm_hr_dw t2
 WHERE t1.tree_node_id like '%' || t2.tree_node || '%' 
 AND  TREE_NODE ='${DWMC}'
 AND  T1.BUMENID='${DWMC}'
 ${if(DWMC='10001100001',"AND 1=1","AND 1=0")}
   ) T3
   GROUP BY descr,TREE_NODE,parent_name,BACK_ANA,TREE_NODE_NUM
   ),
   TT2 AS (
   SELECT 
   DISTINCT
   TREE_NODE_NUM,
   TO_CHAR(SYSDATE,'YYYYMM') AS TDATE,
   TREE_NODE,
   PARENT_NAME,
   BACK_ANA,
   DESCR,
   HZS
   FROM  TT1 
   WHERE DESCR NOT IN ('公司领导','股份总部')
   UNION ALL 
   SELECT 
   TREE_NODE_NUM,
   TO_CHAR(SYSDATE,'YYYYMM') AS TDATE,
   TREE_NODE    ,
   PARENT_NAME,
   BACK_ANA,
  DESCR        ,
  CASE WHEN DESCR='公司领导' THEN MIN(HZS)
   ELSE MAX(HZS)  END AS HZS
   FROM TT1 
 WHERE DESCR  IN ('公司领导','股份总部')
 GROUP BY  
   TO_CHAR(SYSDATE,'YYYYMM'),
   TREE_NODE,
   TREE_NODE_NUM,
   PARENT_NAME,
   BACK_ANA,
   DESCR        
   ),
   TT3 
   AS (
   -------------------当月数据--------------------
   SELECT  DISTINCT 
   TREE_NODE_NUM,
   SUBSTR(TDATE,1,4)||'. '|| SUBSTR(TDATE,5,2) AS TDATE,
   TREE_NODE,
   PARENT_NAME,
   BACK_ANA,
   DESCR,
   HZS AS ZRS
   FROM TT2
   ),
  TS_QX AS (
SELECT TREE_NODE_NUM FROM ODM_HR_DW
START WITH TREE_NODE IN ('10001106406','10001100076','10001100095','10001100072')
CONNECT BY NOCYCLE PRIOR TREE_NODE=PARENT_NODE
),
all_sj as (
   SELECT   
   DISTINCT
   TREE_NODE_NUM,
   CASE WHEN TDATE=SUBSTR(TO_CHAR(SYSDATE,'yyyymm'),1,4)||'. '|| SUBSTR(TO_CHAR(SYSDATE,'yyyymm'),5,2) THEN '当前' ELSE TDATE END AS TDATE,
   TREE_NODE,
   PARENT_NAME,
   BACK_ANA,
   DESCR,
   ZRS ,
   ROUND(CASE WHEN LAG(ZRS,1,0) over ( partition by TREE_NODE,DESCR order by TDATE)=0  THEN NULL
       ELSE ZRS/LAG(ZRS,1,0) over ( partition by TREE_NODE,DESCR order by TDATE) 
          END -1,4)  AS RATIO      
   FROM TT3
   WHERE TREE_NODE<>'HX_HEAD' AND BACK_ANA='1'
   ${if(OR(len(DWMC)==0,DWMC='HX_HEAD'),"AND PARENT_NAME IS NOT NULL","AND 1=1")}
   ),
   TRUE_DATE AS (
SELECT * FROM all_sj
where TREE_NODE_NUM not  in (select TREE_NODE_NUM from TS_QX)
${if(username='zhuyanping',"","and 1=2")}
UNION ALL
SELECT * FROM all_sj
WHERE 1=1
${if(username='zhuyanping'," AND 1=2"," ")}
  )
  select * from  TRUE_DATE 
   ORDER BY TREE_NODE_NUM,TDATE desc,ZRS desc
   
]]></Query>
</TableData>
<TableData name="对比年初增长" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="FENLEI"/>
<O>
<![CDATA[1]]></O>
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
<![CDATA[WITH TT AS 
(
--------当月以前各业务单位-------------
SELECT 
TREE_NODE_NUM,  
TO_CHAR(T1.TDATE,'YYYYMM') AS TDATE,
T1.TREE_NODE	  ,
T1.PARENT_NODE   ,
T1.DESCR	      ,
T1.TREE_NODES	  ,
REPLACE(T1.PARENT_NAME,'<','-') PARENT_NAME  ,
 ${if(OR(len(FENLEI)==0,FENLEI=2) ,"ZRS",if(FENLEI=1,"ZY","FZY"))} AS ZRS    
FROM ODM_HR_UNITS_COUNT T1
LEFT JOIN ODM_HR_DW T2 ON T1.TREE_NODE=T2.TREE_NODE
WHERE T1.TREE_NODE='${DWMC}'
union all
SELECT 
TREE_NODE_NUM,  
TO_CHAR(T1.TDATE,'YYYYMM') AS TDATE,
T1.TREE_NODE	  ,
T1.PARENT_NODE   ,
T1.DESCR	      ,
T1.TREE_NODES	  ,
REPLACE(T1.PARENT_NAME,'<','-') PARENT_NAME,
${if(OR(len(FENLEI)==0,FENLEI=2) ,"ZRS",if(FENLEI=1,"ZY","FZY"))} AS ZRS     
FROM ODM_HR_UNITS_COUNT T1
LEFT JOIN ODM_HR_DW T2 ON T1.TREE_NODE=T2.TREE_NODE
WHERE T1.PARENT_NODE='${DWMC}'
--order by T1.TDATE,T2.TREE_NODE_NUM
),
TT1  AS 
(

-----------当月各业务单位----------
SELECT COUNT(CASE WHEN ${if(OR(len(FENLEI)==0,FENLEI=2),"1=1","1=0")} THEN YGID 
           WHEN ${if(FENLEI=1,"ISZHUYING='主营'","1=0")} THEN YGID 
	      WHEN ${if(FENLEI=0,"ISZHUYING<>'主营'","1=0")}  THEN YGID END) AS HZS,
		  descr,TREE_NODE
FROM 
(
 SELECT 
 t1.ygid,
 t2.descr,
 T2.TREE_NODE,
 ISZHUYING
 FROM  odm_hr_ygtz t1,odm_hr_dw t2
 WHERE t1.tree_node_id like '%' || t2.tree_node || '%' 
 AND  PARENT_NODE ='${DWMC}' 
 --AND    T1.BUMENID <>'${DWMC}'
 UNION ALL
  SELECT 
 t1.ygid,
 t2.descr,
 T2.TREE_NODE,
 ISZHUYING
 FROM  odm_hr_ygtz t1,odm_hr_dw t2
 WHERE t1.tree_node_id like '%' || t2.tree_node || '%' 
 AND  TREE_NODE ='${DWMC}' 
 --AND  T1.BUMENID <>'${DWMC}'
 UNION ALL
  SELECT 
 t1.ygid,
 '公司领导' AS descr,
 T2.TREE_NODE,
 ISZHUYING
 FROM  odm_hr_ygtz t1,odm_hr_dw t2
 WHERE t1.tree_node_id like '%' || t2.tree_node || '%' 
 AND  TREE_NODE ='${DWMC}'
 AND  T1.BUMENID='${DWMC}'
  ${if(DWMC='10001100001',"AND 1=1","AND 1=0")}
 /*UNION ALL
      SELECT 
     t1.ygid,
     t2.descr,
     T2.TREE_NODE,
	 ISZHUYING
     FROM  odm_hr_ygtz t1,odm_hr_dw t2
     WHERE t1.tree_node_id like '%' || t2.tree_node || '%' 
     AND  PARENT_NODE ='HX_HEAD'
     AND  bumenid = t2.tree_node*/
	 ) T3
	 GROUP BY descr,TREE_NODE
	 ),
	 TT2 AS (
		 SELECT 
	 DISTINCT
	 TREE_NODE_NUM,
	 TO_CHAR(SYSDATE,'YYYYMM') AS TDATE,
	 TT.TREE_NODE	  ,
      TT.PARENT_NODE   ,
      TT.DESCR	      ,
      TT.TREE_NODES	  ,
      TT.PARENT_NAME  ,
	 TT1.HZS
	 FROM TT LEFT JOIN TT1 ON TT.TREE_NODE=TT1.TREE_NODE
	 WHERE TT1.DESCR NOT IN ('公司领导','股份总部')
	 UNION ALL 
	 SELECT 
   TREE_NODE_NUM,
   TO_CHAR(SYSDATE,'YYYYMM') AS TDATE,
   TT.TREE_NODE    ,
   TT.PARENT_NODE   ,
   TT.DESCR        ,
   TT.TREE_NODES    ,
   TT.PARENT_NAME  ,
  CASE WHEN TT.DESCR='公司领导' THEN MIN(TT1.HZS)
    ELSE MAX(TT1.HZS)  END AS HZS
   FROM TT LEFT JOIN TT1 ON TT.TREE_NODE=TT1.TREE_NODE
 WHERE TT.DESCR  IN ('公司领导','股份总部')
 GROUP BY  
    TREE_NODE_NUM,
   TO_CHAR(SYSDATE,'YYYYMM'),
   TT.TREE_NODE    ,
   TT.PARENT_NODE   ,
   TT.DESCR        ,
   TT.TREE_NODES    ,
   TT.PARENT_NAME
	 
	 ),
	    TT3 
   
   AS (
   -------------------当月数据与以前数据--------------------
 SELECT  DISTINCT TREE_NODE_NUM,
    TDATE,
   TREE_NODE,PARENT_NODE,DESCR,TREE_NODES,PARENT_NAME,ZRS FROM TT
   WHERE TDATE='201712'
   UNION ALL
   SELECT  DISTINCT TREE_NODE_NUM,
   TDATE,TREE_NODE,PARENT_NODE,DESCR,TREE_NODES,PARENT_NAME,HZS FROM TT2
   )
,
   TT5 AS 
   (   
   SELECT   
   TREE_NODE_NUM,
  TDATE,
   TREE_NODE,
   PARENT_NODE,
   DESCR,
   TREE_NODES,
   PARENT_NAME,
   ZRS ,
   --LAG(ZRS,1,0) over ( partition by TREE_NODE,DESCR order by TDATE),
   ZRS-LAG(ZRS,1,0) over ( partition by TREE_NODE,DESCR order by TDATE) AS SZRS,
 ROUND(CASE WHEN LAG(ZRS,1,0) over ( partition by TREE_NODE,DESCR order by TDATE)=0 
               THEN  NULL
         ELSE ZRS/LAG(ZRS,1,0) over ( partition by TREE_NODE,DESCR order by TDATE) 
          END -1,4) AS RATIO  
   FROM TT3
   WHERE TREE_NODE<>'HX_HEAD'

   ORDER BY TREE_NODE_NUM,TDATE
   
   )
   SELECT * FROM TT5
   where TDATE=to_char(sysdate,'yyyyMM')
   ${if(OR(len(DWMC)==0,DWMC='HX_HEAD'),"AND PARENT_NAME IS NOT NULL","AND 1=1")}]]></Query>
</TableData>
<TableData name="环比数据" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="FENLEI"/>
<O>
<![CDATA[1]]></O>
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
<![CDATA[WITH TT AS 
(
--------当月以前各业务单位-------------
SELECT 
TREE_NODE_NUM,  
TO_CHAR(T1.TDATE,'YYYYMM') AS TDATE,
T1.TREE_NODE	  ,
T1.PARENT_NODE   ,
T1.DESCR	      ,
T1.TREE_NODES	  ,
replace(T1.PARENT_NAME,'<','-') PARENT_NAME,
${if(OR(len(FENLEI)==0,FENLEI=2) ,"ZRS",if(FENLEI=1,"ZY","FZY"))} AS ZRS      
FROM ODM_HR_UNITS_COUNT T1
LEFT JOIN ODM_HR_DW T2 ON T1.TREE_NODE=T2.TREE_NODE
WHERE T1.TREE_NODE='${DWMC}'
union all 
SELECT 
TREE_NODE_NUM,  
TO_CHAR(T1.TDATE,'YYYYMM') AS TDATE,
T1.TREE_NODE	  ,
T1.PARENT_NODE   ,
T1.DESCR	      ,
T1.TREE_NODES	  ,
replace(T1.PARENT_NAME,'<','-') PARENT_NAME  ,
${if(OR(len(FENLEI)==0,FENLEI=2) ,"ZRS",if(FENLEI=1,"ZY","FZY"))} AS ZRS       
FROM ODM_HR_UNITS_COUNT T1
LEFT JOIN ODM_HR_DW T2 
ON T1.TREE_NODE=T2.TREE_NODE
WHERE T1.PARENT_NODE='${DWMC}'
--order by T1.TDATE,T2.TREE_NODE_NUM
),
TT1  AS 
(

-----------当月各业务单位----------
SELECT COUNT(CASE WHEN ${if(OR(len(FENLEI)==0,FENLEI=2),"1=1","1=0")} THEN YGID 
           WHEN ${if(FENLEI=1,"ISZHUYING='主营'","1=0")} THEN YGID 
	      WHEN ${if(FENLEI=0,"ISZHUYING<>'主营'","1=0")}  THEN YGID END) AS HZS,
		  descr,TREE_NODE
FROM 
(
  SELECT 
 t1.ygid,
 t2.descr,
 T2.TREE_NODE,
 ISZHUYING
 FROM  odm_hr_ygtz t1,odm_hr_dw t2
 WHERE t1.tree_node_id like '%' || t2.tree_node || '%' 
 AND  PARENT_NODE ='${DWMC}'
 --AND  T1.BUMENID<>'${DWMC}'
  UNION ALL
  SELECT 
 t1.ygid,
 t2.descr,
 T2.TREE_NODE,
 ISZHUYING
 FROM  odm_hr_ygtz t1,odm_hr_dw t2
 WHERE t1.tree_node_id like '%' || t2.tree_node || '%' 
 AND  TREE_NODE ='${DWMC}' 
 --AND  T1.BUMENID <>'${DWMC}'
 UNION ALL
  SELECT 
 t1.ygid,
 '公司领导' AS descr,
 T2.TREE_NODE,
 ISZHUYING
 FROM  odm_hr_ygtz t1,odm_hr_dw t2
 WHERE t1.tree_node_id like '%' || t2.tree_node || '%' 
 AND  TREE_NODE ='${DWMC}'
 AND  T1.BUMENID='${DWMC}'
 ${if(DWMC='10001100001',"AND 1=1","AND 1=0")}
   ) T3
   GROUP BY descr,TREE_NODE
   ),
   TT2 AS (
   SELECT 
   DISTINCT
   TREE_NODE_NUM,
   TO_CHAR(SYSDATE,'YYYYMM') AS TDATE,
   TT.TREE_NODE    ,
      TT.PARENT_NODE   ,
      TT.DESCR        ,
      TT.TREE_NODES    ,
      TT.PARENT_NAME  ,
   TT1.HZS
   FROM TT LEFT JOIN TT1 ON TT.TREE_NODE=TT1.TREE_NODE
   WHERE TT.DESCR NOT IN ('公司领导','股份总部')
   UNION ALL 
   SELECT 
   TREE_NODE_NUM,
   TO_CHAR(SYSDATE,'YYYYMM') AS TDATE,
   TT.TREE_NODE    ,
   TT.PARENT_NODE   ,
   TT.DESCR        ,
   TT.TREE_NODES    ,
   TT.PARENT_NAME  ,
  CASE WHEN TT.DESCR='公司领导' THEN MIN(TT1.HZS)
    ELSE MAX(TT1.HZS)  END AS HZS
   FROM TT LEFT JOIN TT1 ON TT.TREE_NODE=TT1.TREE_NODE
 WHERE TT.DESCR  IN ('公司领导','股份总部')
 GROUP BY  
    TREE_NODE_NUM,
   TO_CHAR(SYSDATE,'YYYYMM'),
   TT.TREE_NODE    ,
   TT.PARENT_NODE   ,
   TT.DESCR        ,
   TT.TREE_NODES    ,
   TT.PARENT_NAME
   
   ),
   TT3 
   
   AS (
   -------------------当月数据与以前数据--------------------
   SELECT  DISTINCT TREE_NODE_NUM,
   SUBSTR(TDATE,1,4)||'. '|| SUBSTR(TDATE,5,2) AS TDATE,
   TREE_NODE,PARENT_NODE,DESCR,TREE_NODES,PARENT_NAME,ZRS FROM TT
   UNION ALL
   SELECT  DISTINCT TREE_NODE_NUM,
   SUBSTR(TDATE,1,4)||'. '|| SUBSTR(TDATE,5,2) AS TDATE,TREE_NODE,PARENT_NODE,DESCR,TREE_NODES,PARENT_NAME,HZS FROM TT2
   ),
   DATA_TRUE AS (
   SELECT   
   DISTINCT
   TREE_NODE_NUM,
   CASE WHEN TDATE=SUBSTR(TO_CHAR(SYSDATE,'yyyymm'),1,4)||'. '|| SUBSTR(TO_CHAR(SYSDATE,'yyyymm'),5,2) THEN '当前' ELSE TDATE END AS TDATE,
   TREE_NODE,
   PARENT_NODE,
   DESCR,
   TREE_NODES,
   PARENT_NAME,
   ZRS ,
   ROUND(CASE WHEN LAG(ZRS,1,0) over ( partition by TREE_NODE,DESCR order by TDATE)=0  THEN NULL
       ELSE ZRS/LAG(ZRS,1,0) over ( partition by TREE_NODE,DESCR order by TDATE) 
          END -1,4)  AS RATIO      
   FROM TT3
   WHERE TREE_NODE<>'HX_HEAD'  
   ${if(OR(len(DWMC)==0,DWMC='HX_HEAD'),"AND PARENT_NAME IS NOT NULL","AND 1=1")}
   ORDER BY TREE_NODE_NUM,TDATE desc,ZRS desc
  )
  SELECT * FROM DATA_TRUE WHERE TDATE<>'当前']]></Query>
</TableData>
<TableData name="当月环比数据" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="FENLEI"/>
<O>
<![CDATA[1]]></O>
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
<![CDATA[WITH TT AS 
(
--------当月以前各业务单位-------------
SELECT 
TREE_NODE_NUM,  
TO_CHAR(T1.TDATE,'YYYYMM') AS TDATE,
T1.TREE_NODE	  ,
T1.PARENT_NODE   ,
T1.DESCR	      ,
T1.TREE_NODES	  ,
replace(T1.PARENT_NAME,'<','-') PARENT_NAME,
${if(OR(len(FENLEI)==0,FENLEI=2) ,"ZRS",if(FENLEI=1,"ZY","FZY"))} AS ZRS      
FROM ODM_HR_UNITS_COUNT T1
LEFT JOIN ODM_HR_DW T2 ON T1.TREE_NODE=T2.TREE_NODE
WHERE T1.TREE_NODE='${DWMC}'
union all 
SELECT 
TREE_NODE_NUM,  
TO_CHAR(T1.TDATE,'YYYYMM') AS TDATE,
T1.TREE_NODE	  ,
T1.PARENT_NODE   ,
T1.DESCR	      ,
T1.TREE_NODES	  ,
replace(T1.PARENT_NAME,'<','-') PARENT_NAME  ,
${if(OR(len(FENLEI)==0,FENLEI=2) ,"ZRS",if(FENLEI=1,"ZY","FZY"))} AS ZRS       
FROM ODM_HR_UNITS_COUNT T1
LEFT JOIN ODM_HR_DW T2 
ON T1.TREE_NODE=T2.TREE_NODE
WHERE T1.PARENT_NODE='${DWMC}'
--order by T1.TDATE,T2.TREE_NODE_NUM
),
TT1  AS 
(

-----------当月各业务单位----------
SELECT COUNT(CASE WHEN ${if(OR(len(FENLEI)==0,FENLEI=2),"1=1","1=0")} THEN YGID 
           WHEN ${if(FENLEI=1,"ISZHUYING='主营'","1=0")} THEN YGID 
	      WHEN ${if(FENLEI=0,"ISZHUYING<>'主营'","1=0")}  THEN YGID END) AS HZS,
		  descr,TREE_NODE
FROM 
(
  SELECT 
 t1.ygid,
 t2.descr,
 T2.TREE_NODE,
 ISZHUYING
 FROM  odm_hr_ygtz t1,odm_hr_dw t2
 WHERE t1.tree_node_id like '%' || t2.tree_node || '%' 
 AND  PARENT_NODE ='${DWMC}'
 --AND  T1.BUMENID<>'${DWMC}'
  UNION ALL
  SELECT 
 t1.ygid,
 t2.descr,
 T2.TREE_NODE,
 ISZHUYING
 FROM  odm_hr_ygtz t1,odm_hr_dw t2
 WHERE t1.tree_node_id like '%' || t2.tree_node || '%' 
 AND  TREE_NODE ='${DWMC}' 
 --AND  T1.BUMENID <>'${DWMC}'
 UNION ALL
  SELECT 
 t1.ygid,
 '公司领导' AS descr,
 T2.TREE_NODE,
 ISZHUYING
 FROM  odm_hr_ygtz t1,odm_hr_dw t2
 WHERE t1.tree_node_id like '%' || t2.tree_node || '%' 
 AND  TREE_NODE ='${DWMC}'
 AND  T1.BUMENID='${DWMC}'
 ${if(DWMC='10001100001',"AND 1=1","AND 1=0")}
   ) T3
   GROUP BY descr,TREE_NODE
   ),
   TT2 AS (
   SELECT 
   DISTINCT
   TREE_NODE_NUM,
   TO_CHAR(SYSDATE,'YYYYMM') AS TDATE,
   TT.TREE_NODE    ,
      TT.PARENT_NODE   ,
      TT.DESCR        ,
      TT.TREE_NODES    ,
      TT.PARENT_NAME  ,
   TT1.HZS
   FROM TT LEFT JOIN TT1 ON TT.TREE_NODE=TT1.TREE_NODE
   WHERE TT.DESCR NOT IN ('公司领导','股份总部')
   UNION ALL 
   SELECT 
   TREE_NODE_NUM,
   TO_CHAR(SYSDATE,'YYYYMM') AS TDATE,
   TT.TREE_NODE    ,
   TT.PARENT_NODE   ,
   TT.DESCR        ,
   TT.TREE_NODES    ,
   TT.PARENT_NAME  ,
  CASE WHEN TT.DESCR='公司领导' THEN MIN(TT1.HZS)
    ELSE MAX(TT1.HZS)  END AS HZS
   FROM TT LEFT JOIN TT1 ON TT.TREE_NODE=TT1.TREE_NODE
 WHERE TT.DESCR  IN ('公司领导','股份总部')
 GROUP BY  
    TREE_NODE_NUM,
   TO_CHAR(SYSDATE,'YYYYMM'),
   TT.TREE_NODE    ,
   TT.PARENT_NODE   ,
   TT.DESCR        ,
   TT.TREE_NODES    ,
   TT.PARENT_NAME
   
   ),
   TT3 
   
   AS (
   -------------------当月数据与以前数据--------------------
   SELECT  DISTINCT TREE_NODE_NUM,
   SUBSTR(TDATE,1,4)||'. '|| SUBSTR(TDATE,5,2) AS TDATE,
   TREE_NODE,PARENT_NODE,DESCR,TREE_NODES,PARENT_NAME,ZRS FROM TT
   UNION ALL
   SELECT  DISTINCT TREE_NODE_NUM,
   SUBSTR(TDATE,1,4)||'. '|| SUBSTR(TDATE,5,2) AS TDATE,TREE_NODE,PARENT_NODE,DESCR,TREE_NODES,PARENT_NAME,HZS FROM TT2
   )
 
   SELECT   
   DISTINCT
   TREE_NODE_NUM,
   CASE WHEN TDATE=SUBSTR(TO_CHAR(SYSDATE,'yyyymm'),1,4)||'. '|| SUBSTR(TO_CHAR(SYSDATE,'yyyymm'),5,2) THEN '当前' ELSE TDATE END AS TDATE,
   TREE_NODE,
   PARENT_NODE,
   DESCR,
   TREE_NODES,
   PARENT_NAME,
   ZRS ,
   ROUND(CASE WHEN LAG(ZRS,1,0) over ( partition by TREE_NODE,DESCR order by TDATE)=0  THEN NULL
       ELSE ZRS/LAG(ZRS,1,0) over ( partition by TREE_NODE,DESCR order by TDATE) 
          END -1,4)  AS RATIO      
   FROM TT3
   WHERE TREE_NODE<>'HX_HEAD'  
   ${if(OR(len(DWMC)==0,DWMC='HX_HEAD'),"AND PARENT_NAME IS NOT NULL","AND 1=1")}
  ORDER BY TREE_NODE_NUM,TDATE desc,ZRS desc
]]></Query>
</TableData>
<TableData name="每月各单位数据 备份" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="FENLEI"/>
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
<![CDATA[WITH TT1  AS 
(
-----------当月各业务单位----------
SELECT COUNT(CASE WHEN ${if(OR(len(FENLEI)==0,FENLEI=2),"1=1","1=0")} THEN YGID 
           WHEN ${if(FENLEI=1,"ISZHUYING='主营'","1=0")} THEN YGID 
	      WHEN ${if(FENLEI=0,"ISZHUYING<>'主营'","1=0")}  THEN YGID END) AS HZS,
		  descr AS DESCR,
		  TREE_NODE AS TREE_NODE,
		  parent_name AS PARENT_NAME,
		  back_ana AS BACK_ANA,
		  TREE_NODE_NUM
FROM 
( 
   SELECT 
   t2.TREE_NODE_NUM,
 t1.ygid,
 t2.descr,
 T2.TREE_NODE,
 t2.parent_name,
 t2.back_ana,
 ISZHUYING
 FROM  odm_hr_ygtz t1,odm_hr_dw t2
 WHERE t1.tree_node_id like '%' || t2.tree_node || '%' 
 AND  PARENT_NODE ='${DWMC}'
 --AND  T1.BUMENID<>'${DWMC}'
  UNION ALL
  SELECT 
   t2.TREE_NODE_NUM,
 t1.ygid,
 t2.descr,
 T2.TREE_NODE,
 t2.parent_name,
 t2.back_ana,
 ISZHUYING
 FROM  odm_hr_ygtz t1, odm_hr_dw t2
 WHERE t1.tree_node_id like '%' || t2.tree_node || '%' 
 AND  TREE_NODE ='${DWMC}' 
 --AND  T1.BUMENID <>'${DWMC}'
 UNION ALL
  SELECT 
   t2.TREE_NODE_NUM,
 t1.ygid,
 '公司领导' AS descr,
 T2.TREE_NODE,
 t2.parent_name,
 t2.back_ana,
 ISZHUYING
 FROM  odm_hr_ygtz t1,odm_hr_dw t2
 WHERE t1.tree_node_id like '%' || t2.tree_node || '%' 
 AND  TREE_NODE ='${DWMC}'
 AND  T1.BUMENID='${DWMC}'
 ${if(DWMC='10001100001',"AND 1=1","AND 1=0")}
   ) T3
   GROUP BY descr,TREE_NODE,parent_name,BACK_ANA,TREE_NODE_NUM
   ),
   TT2 AS (
   SELECT 
   DISTINCT
   TREE_NODE_NUM,
   TO_CHAR(SYSDATE,'YYYYMM') AS TDATE,
   TREE_NODE,
   PARENT_NAME,
   BACK_ANA,
   DESCR,
   HZS
   FROM  TT1 
   WHERE DESCR NOT IN ('公司领导','股份总部')
   UNION ALL 
   SELECT 
   TREE_NODE_NUM,
   TO_CHAR(SYSDATE,'YYYYMM') AS TDATE,
   TREE_NODE    ,
   PARENT_NAME,
   BACK_ANA,
  DESCR        ,
  CASE WHEN DESCR='公司领导' THEN MIN(HZS)
   ELSE MAX(HZS)  END AS HZS
   FROM TT1 
 WHERE DESCR  IN ('公司领导','股份总部')
 GROUP BY  
   TO_CHAR(SYSDATE,'YYYYMM'),
   TREE_NODE,
   TREE_NODE_NUM,
   PARENT_NAME,
   BACK_ANA,
   DESCR        
   ),
   TT3 
   AS (
   -------------------当月数据--------------------
   SELECT  DISTINCT 
   TREE_NODE_NUM,
   SUBSTR(TDATE,1,4)||'. '|| SUBSTR(TDATE,5,2) AS TDATE,
   TREE_NODE,
   PARENT_NAME,
   BACK_ANA,
   DESCR,
   HZS AS ZRS
   FROM TT2
   )
   SELECT   
   DISTINCT
   TREE_NODE_NUM,
   CASE WHEN TDATE=SUBSTR(TO_CHAR(SYSDATE,'yyyymm'),1,4)||'. '|| SUBSTR(TO_CHAR(SYSDATE,'yyyymm'),5,2) THEN '当前' ELSE TDATE END AS TDATE,
   TREE_NODE,
   PARENT_NAME,
   BACK_ANA,
   DESCR,
   ZRS ,
   ROUND(CASE WHEN LAG(ZRS,1,0) over ( partition by TREE_NODE,DESCR order by TDATE)=0  THEN NULL
       ELSE ZRS/LAG(ZRS,1,0) over ( partition by TREE_NODE,DESCR order by TDATE) 
          END -1,4)  AS RATIO      
   FROM TT3
   WHERE TREE_NODE<>'HX_HEAD' AND BACK_ANA='1'
   ${if(OR(len(DWMC)==0,DWMC='HX_HEAD'),"AND PARENT_NAME IS NOT NULL","AND 1=1")}
   ORDER BY TREE_NODE_NUM,TDATE desc,ZRS desc
   
]]></Query>
</TableData>
<TableData name="ds1" class="com.fr.data.impl.DBTableData">
<Parameters>
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
<![CDATA[SELECT * FROM (
SELECT DESCR,
       TO_CHAR(DATETIME,'YYYY. MM') YF,
       COUNT(*) ZYRS,
       TREE_NODE_NUM
from odm_hr_ygtz_hist t1 left join odm_hr_dw  t2 ON 
t1.tree_node_id like '%' || t2.tree_node || '%' 
WHERE  PARENT_NODE ='${DWMC}'
AND ISZHUYING='主营'
GROUP BY DESCR,T2.TREE_NODE,T2.TREE_NODE_NUM,DATETIME
ORDER BY T2.TREE_NODE_NUM
) 
${IF(DWMC='10001100001',
" UNION ALL
SELECT '战略投资中心' AS DESCR,
       TO_CHAR(DATETIME,'YYYY. MM') YF,
       COUNT(1) ZYRS,
       0 AS TREE_NODE_NUM
FROM ODM_HR_YGTZ_HIST 
WHERE TREE_NODE_ID LIKE '%10001105501%' 
GROUP BY DATETIME","")} 
]]></Query>
</TableData>
</TableDataMap>
<ReportFitAttr fitStateInPC="2" fitFont="false"/>
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
<![CDATA[=UUID()]]></Attributes>
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
<![CDATA[WebReport/ReportServer?formlet=HXXF_HR/HRanalysis/Employment_labor.frm]]></O>
</ColumnConfig>
<ColumnConfig name="CPT" isKey="false" skipUnmodified="false">
<O>
<![CDATA[Employment_labor.frm]]></O>
</ColumnConfig>
<ColumnConfig name="CPT_NAME" isKey="false" skipUnmodified="false">
<O>
<![CDATA[人才队伍结构_各单位用工变化]]></O>
</ColumnConfig>
<ColumnConfig name="REGISTER_ID" isKey="false" skipUnmodified="false">
<O>
<![CDATA[]]></O>
</ColumnConfig>
<ColumnConfig name="REGISTER_ENTER_ID" isKey="false" skipUnmodified="false">
<O>
<![CDATA[]]></O>
</ColumnConfig>
<ColumnConfig name="PARAMETER_TREE" isKey="false" skipUnmodified="false">
<O>
<![CDATA[]]></O>
</ColumnConfig>
<ColumnConfig name="PARAMETER_NAME" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(LEN($DWMC)=0,"","部门ID;")]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="PARAMETER" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(LEN($DWMC)=0,"",$DWMC+";")]]></Attributes>
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
<![CDATA[]]></O>
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
<![CDATA[人力资源基础分析]]></O>
</ColumnConfig>
<ColumnConfig name="CANSHU_NAME_CODE" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(len($DWMC)=0,"","部门ID:"+$DWMC+";")]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="YGID" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$YGID]]></Attributes>
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
<LCAttr vgap="0" hgap="0" compInterval="8"/>
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
<NorthAttr size="36"/>
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
<WidgetName name="7cecefef-6dd5-4320-b9da-19a85bb99c3d"/>
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
<WidgetName name="2e30b530-59cf-423f-b382-cafa36d5376f"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Text>
<![CDATA[各单位用工变化情况]]></Text>
<FRFont name="SimSun" style="0" size="72"/>
<isCustomType isCustomType="true"/>
<SwitchTagAttr layoutName="tabpane0"/>
</Widget>
<FLAttr alignment="0"/>
<ColumnWidth defaultValue="80">
<![CDATA[80,80,80,80,80,80,80,80,80,80,80]]></ColumnWidth>
</Center>
<CardTitleLayout layoutName="tabpane0"/>
</North>
<Center class="com.fr.form.ui.container.WCardLayout">
<Listener event="afterinit">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="dw"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$DWMC]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[/*if(dw!="HX_HEAD"){
 $('div:lt(1)',this.element.parent()).hide();//隐藏tab标题 
 
setTimeout(function(){   
 _g().options.form.getWidgetByName("tabpane0").showCardByIndex(1) ;
} ,0.1); }
else {}*/]]></Content>
</JavaScript>
</Listener>
<WidgetName name="tabpane0"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="1" color="-723724" borderRadius="0" type="1" borderStyle="0"/>
<WidgetTitle>
<O>
<![CDATA[title]]></O>
<FRFont name="宋体" style="0" size="72"/>
<Position pos="0"/>
<Background name="ColorBackground" color="-3881788"/>
</WidgetTitle>
<Alpha alpha="1.0"/>
</Border>
<LCAttr vgap="0" hgap="0" compInterval="0"/>
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
<HR F="0" T="1"/>
<FR/>
<HC F="0" T="0"/>
<FC/>
<UPFCR COLUMN="true" ROW="true"/>
</ReportPageAttr>
<ColumnPrivilegeControl/>
<RowPrivilegeControl/>
<RowHeight defaultValue="723900">
<![CDATA[864000,864000,864000,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[381000,3772800,2160000,2160000,1872000,1872000,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="0" rs="2" s="0">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="数据范围：" + if(OR($FENLEI = 2, LEN($FENLEI) = 0), "总人数", if($FENLEI = 1, "主营", "非主营"))]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="0" cs="2" s="1">
<O>
<![CDATA[当前比年初增长情况]]></O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="4" r="0" cs="2" s="1">
<O t="DSColumn">
<Attributes dsName="ds1" columnName="YF"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="2"/>
<CellPageAttr/>
<Expand dir="1"/>
</C>
<C c="2" r="1" s="1">
<O>
<![CDATA[人数]]></O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="3" r="1" s="1">
<O>
<![CDATA[增长率]]></O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="4" r="1" s="1">
<O>
<![CDATA[人数]]></O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="5" r="1" s="1">
<O>
<![CDATA[环比上月]]></O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[E1 = "2017. 12"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="2">
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="1" r="2" s="2">
<O t="DSColumn">
<Attributes dsName="每月各单位数据数据表" columnName="DESCR"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand dir="0"/>
</C>
<C c="2" r="2" s="3">
<O t="DSColumn">
<Attributes dsName="对比年初增长" columnName="SZRS"/>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[TREE_NODE]]></CNAME>
<Compare op="0">
<SimpleDSColumn dsName="每月各单位数据数据表" columnName="TREE_NODE"/>
</Compare>
</Condition>
</JoinCondition>
<JoinCondition join="0">
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[DESCR]]></CNAME>
<Compare op="0">
<SimpleDSColumn dsName="每月各单位数据数据表" columnName="DESCR"/>
</Compare>
</Condition>
</JoinCondition>
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
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[LEN($$$) = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=IF($$$ < 0, $$$, IF($$$ > 0, "+" + $$$, 0))]]></Content>
</Present>
<Expand dir="0" leftParentDefault="false" left="B3"/>
</C>
<C c="3" r="2" s="4">
<O t="DSColumn">
<Attributes dsName="对比年初增长" columnName="RATIO"/>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[TREE_NODE]]></CNAME>
<Compare op="0">
<SimpleDSColumn dsName="每月各单位数据数据表" columnName="TREE_NODE"/>
</Compare>
</Condition>
</JoinCondition>
<JoinCondition join="0">
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[DESCR]]></CNAME>
<Compare op="0">
<SimpleDSColumn dsName="每月各单位数据数据表" columnName="DESCR"/>
</Compare>
</Condition>
</JoinCondition>
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
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[LEN($$$) = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0" leftParentDefault="false" left="B3"/>
</C>
<C c="4" r="2" s="5">
<O t="DSColumn">
<Attributes dsName="ds1" columnName="ZYRS"/>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[DESCR]]></CNAME>
<Compare op="0">
<ColumnRow column="1" row="2"/>
</Compare>
</Condition>
</JoinCondition>
<JoinCondition join="0">
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[YF]]></CNAME>
<Compare op="0">
<ColumnRow column="4" row="0"/>
</Compare>
</Condition>
</JoinCondition>
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
<Expand dir="0" leftParentDefault="false" left="B3"/>
</C>
<C c="5" r="2" s="6">
<O t="DSColumn">
<Attributes dsName="当月环比数据" columnName="RATIO"/>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[DESCR]]></CNAME>
<Compare op="0">
<ColumnRow column="1" row="2"/>
</Compare>
</Condition>
</JoinCondition>
<JoinCondition join="0">
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[TDATE]]></CNAME>
<Compare op="0">
<ColumnRow column="4" row="0"/>
</Compare>
</Condition>
</JoinCondition>
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
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[LEN($$$) = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
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
<FRFont name="微软雅黑" style="1" size="80" foreground="-4259832"/>
<Background name="ColorBackground" color="-2302756"/>
<Border>
<Top style="1" color="-3881788"/>
<Bottom style="1" color="-3881788"/>
<Left style="1" color="-3881788"/>
<Right style="1" color="-3881788"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="1" size="72"/>
<Background name="ColorBackground" color="-2302756"/>
<Border>
<Top style="1" color="-3881788"/>
<Bottom style="1" color="-3881788"/>
<Left style="1" color="-3881788"/>
<Right style="1" color="-3881788"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="1" size="72"/>
<Background name="NullBackground"/>
<Border>
<Bottom style="1" color="-3881788"/>
<Left style="1" color="-3881788"/>
<Right style="1" color="-3881788"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72" foreground="-4259832"/>
<Background name="NullBackground"/>
<Border>
<Bottom style="1" color="-3881788"/>
<Left style="1" color="-3881788"/>
<Right style="1" color="-3881788"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0.0%]]></Format>
<FRFont name="微软雅黑" style="0" size="72" foreground="-4259832"/>
<Background name="NullBackground"/>
<Border>
<Bottom style="1" color="-3881788"/>
<Left style="1" color="-3881788"/>
<Right style="1" color="-3881788"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Bottom style="1" color="-3881788"/>
<Left style="1" color="-3881788"/>
<Right style="1" color="-3881788"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0.0%]]></Format>
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
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
<BoundsAttr x="0" y="0" width="956" height="411"/>
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
<![CDATA[864000,720000,720000,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[1943100,3771900,2160000,2160000,2160000,2743200,1728000,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="0" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="0" cs="2" s="1">
<O t="DSColumn">
<Attributes dsName="每月各单位数据数据表" columnName="TDATE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="1"/>
</C>
<C c="4" r="0" rs="2" s="1">
<O>
<![CDATA[对比年初增长率]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="1" s="1">
<O>
<![CDATA[人数]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="1" s="1">
<O>
<![CDATA[环比上月]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[C1 = "201712"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="5" r="1">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="1">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="2" s="2">
<O t="DSColumn">
<Attributes dsName="每月各单位数据数据表" columnName="DESCR"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand dir="0"/>
</C>
<C c="2" r="2" s="2">
<O t="DSColumn">
<Attributes dsName="每月各单位数据数据表" columnName="ZRS"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="3" r="2" s="3">
<O t="DSColumn">
<Attributes dsName="每月各单位数据数据表" columnName="RATIO"/>
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
<![CDATA[LEN($$$) == 0]]></Formula>
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
<Attributes dsName="对比年初增长" columnName="RATIO"/>
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[TREE_NODE]]></CNAME>
<Compare op="0">
<SimpleDSColumn dsName="每月各单位数据数据表" columnName="TREE_NODE"/>
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
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[LEN($$$)== 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0" leftParentDefault="false" left="B3"/>
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
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-2302756"/>
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
<Border>
<Top style="1" color="-3881788"/>
<Bottom style="1" color="-3881788"/>
<Left style="1" color="-3881788"/>
<Right style="1" color="-3881788"/>
</Border>
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
</body>
</InnerWidget>
<BoundsAttr x="0" y="85" width="956" height="411"/>
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
<![CDATA[144000,952500,304800,685800,144000,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[1872000,1872000,1872000,1872000,1872000,1872000,1728000,2880000,1440000,2880000,1440000,2880000,1872000,1872000,1872000,1872000,1872000,1872000,1872000,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="1" cs="19" s="0">
<O>
<![CDATA[各单位用工变化情况]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="3" s="1">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="<div style='width: 45%;float: left;text-align: right;'><img style='height: 19px;margin-right: 10px;'src='/WebReport/pageperfor/ico1.png'/></div><div><span style='font-size: 12px;color: black;'>总人数</span></br><span style='font-size: 13px;color: black;font-weight:bold;'>" + "</span></div></div>"]]></Attributes>
</O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="当前表单对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="FENLEI"/>
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
<NameJavaScript name="CopyOfCopyOf当前表单对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="FENLEI"/>
<O>
<![CDATA[2]]></O>
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
<NameJavaScript name="CopyOf当前表单对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="FENLEI"/>
<O>
<![CDATA[2]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="chart2"/>
<linkType type="0"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<CellGUIAttr adjustmode="2" showAsHTML="true"/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$FENLEI = "2"]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[LEN($FENLEI) = 0]]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BorderHighlightAction">
<Border topLine="1" topColor="-65536" bottomLine="1" bottomColor="-65536" leftLine="1" leftColor="-65536" rightLine="1" rightColor="-65536"/>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="8" r="3" s="2">
<PrivilegeControl/>
</C>
<C c="9" r="3" s="1">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="<div style='width: 45%;float: left;text-align: right;'><img style='height: 19px;margin-right: 10px;'src='/WebReport/pageperfor/ico2.png'/></div><div><span style='font-size: 12px;color: black;'>主营</span></br><span style='font-size: 13px;color: black;font-weight:bold;'>" + "</span></div></div>"]]></Attributes>
</O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="当前表单对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="FENLEI"/>
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
<NameJavaScript name="CopyOfCopyOf当前表单对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="FENLEI"/>
<O>
<![CDATA[1]]></O>
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
<NameJavaScript name="CopyOf当前表单对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="FENLEI"/>
<O>
<![CDATA[1]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="chart2"/>
<linkType type="0"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<CellGUIAttr adjustmode="2" showAsHTML="true"/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$FENLEI = "1"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BorderHighlightAction">
<Border topLine="1" topColor="-65536" bottomLine="1" bottomColor="-65536" leftLine="1" leftColor="-65536" rightLine="1" rightColor="-65536"/>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="10" r="3" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="3" s="1">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="<div style='width: 45%;float: left;text-align: right;'><img style='height: 19px;margin-right: 10px;'src='/WebReport/pageperfor/ico3.png'/></div><div><span style='font-size: 12px;color: black;'>非主营</span></br><span style='font-size: 13px;color: black;font-weight:bold;'>" + "</span></div></div>"]]></Attributes>
</O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="当前表单对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="FENLEI"/>
<O>
<![CDATA[0]]></O>
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
<NameJavaScript name="CopyOfCopyOf当前表单对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="FENLEI"/>
<O>
<![CDATA[0]]></O>
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
<NameJavaScript name="CopyOf当前表单对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="FENLEI"/>
<O>
<![CDATA[0]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="chart2"/>
<linkType type="0"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<CellGUIAttr adjustmode="2" showAsHTML="true"/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$FENLEI = "0"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BorderHighlightAction">
<Border topLine="1" topColor="-65536" bottomLine="1" bottomColor="-65536" leftLine="1" leftColor="-65536" rightLine="1" rightColor="-65536"/>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="4">
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
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="128"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="88"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-4144960"/>
<Bottom style="1" color="-4144960"/>
<Left style="1" color="-4144960"/>
<Right style="1" color="-4144960"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="88"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<isShared isshared="false"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="0" zoom="true" refresh="false" isUseHTML="false"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="956" height="85"/>
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
<![CDATA[144000,762000,288000,864000,288000,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[1728000,1728000,1728000,1728000,720000,1584000,1728000,720000,1584000,1728000,720000,1584000,1728000,1728000,1728000,1728000,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="1" cs="16" s="0">
<O>
<![CDATA[各业务集团用工人数环比增长趋势]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="3" s="1">
<O t="Image">
<IM>
<![CDATA[!AFW%r/"6F7h#eD$31&+%7s)Y;?-[s*rl9@*s`&N!!"+D(-)?p!r#8S5u`*_`KskDc!_U4cd
o?@>?R-CA205m78'rm;-q+7..]A4!X5i;N2rXlH8a[uC/uXoLKe+A[js?==]AAOCSg.n#WOtn[
^rk?/D55"O>5QBpH5Q-q,:S%)>^R++GcgU6H4O6[u08`YB9-hZr?B>9X^b1]Ae;Wi!q$9!P2^
]ARr[GCJrblTn,/c=(fYGXb2Q5WbnGj1m[X$XKDK(?[A.)0@:e%mZ\H>Q]A5Pj=Yrh76-._-u]A
mu;V/K<kZVO.Cf8UM'-%#t6TKq[0[L.je%doH01nJa+:j#F[.+H="j)AAZ.TE>W2hu^`YP%9
clLHu2tgR0-3#sF_F/@`$CY+;jYL_t!Df!ZlOj_?o0*s:B/`4MQ\]AA0!^<%TR#PE)FSJ:FN!
G^ZY0g=[=d6cXW3557==L/-kngN(&!d)H@%A&O%JFk\#e^G1@S/"i._lO:X$Rlo!L8@:9pBg
R!DDYW(_ac#2)q[8<VXB%XU&-A;ET5")3LY5&kqt\T+4VsU*TC#k/n#H)/Lo53(+Wo6Kc+&'
eBKG_+e\u$T?^-`N"TNk)6lnV_eoSi&$#JQ6XWfO:DUs.5L5jrFY#Q1=3#$:k;Ou\"`V?#b@
eC?:O+F^=nM\R9`)_WE0IB*)=u6D9;BdOWIs>-eXcj9":>p8g<EkC<PiL5$M`/Zr;78)BM!Z
8ip4VM2SHXK.HllN7)Z8JD=)C?J3)D2qDe*]A`f/SfH"Ba]AOa,M",,jC)sMHZU0`ma^C9BJWO
klRKNWPqMLt.*1VlN*ELrW`c:ajN36eCrFi/%F=_Z5%<10[@L!toQ3OOl>\_X9Md__p8Jr?#
Z7O[F\KYqN)eKa/.k..5"*aJ5L%&o?ECo;;':NFQq:2h)>_7)8i42=4J#B[jGAUf?=ISD6=T
*EU/mAa[XksudpJi;^iA57YHEW9=E!QW_]AS6*VK+Qr[fU&Lfh`IU<aTar--8LUU0^W6L#1-E
le;?-[s!(fUS7'8jaJc~
]]></IM>
</O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="当前表单对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="FENLEI"/>
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
</NameJavaScriptGroup>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$FENLEI = "2"]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[LEN($FENLEI) = 0]]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BorderHighlightAction">
<Border topLine="1" topColor="-65536" bottomLine="1" bottomColor="-65536" leftLine="1" leftColor="-65536" rightLine="1" rightColor="-65536"/>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="5" r="3" s="2">
<O>
<![CDATA[总人数]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="当前表单对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="FENLEI"/>
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
</NameJavaScriptGroup>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$FENLEI = "2"]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[LEN($FENLEI) = 0]]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BorderHighlightAction">
<Border topLine="1" topColor="-65536" bottomLine="1" bottomColor="-65536" leftLine="1" leftColor="-65536" rightLine="1" rightColor="-65536"/>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="6" r="3" s="3">
<PrivilegeControl/>
</C>
<C c="7" r="3" s="4">
<O t="Image">
<IM>
<![CDATA[!M9F$rJ=?G7h#eD$31&+%7s)Y;?-[s*rl9@*s`&N!!"+D(-)?p!bP"l5u`*_jd3YR*)REhLC
GdO`$0jL&Z[$F$Ag<l<i1sD5XI^=)_FrY;VB\+$]AB+Ys*u5f8I,q;`_%2h@L6-BU4S3@Koe`
721D[tA&iZL%(s6$De><'73TV\FCr&G]A_h-/pT<JeY&dZ(pJ-+p6&g^si#9+u_#L$q^5Z&R$
.cm$(]Aup/#+R)25(g;R`>cWWp^9+lX6e2lquK`*,c\?W/qO^<#KPa0j?VF.j;SP]A11ClF"]Ah
%'$$$?\^dg'eIaUX(;B$+T?qN41/I&?:GWER#2o.Ie2$?[Y"tj`s[$\Fe4Et<Jrro\l.oHiC
fF6E\b\s=CF8q%PT^;+d/Q`A0)%7d)5`2fmlqt[t?HI^MrfUu@W!$;d1L\kT5Z'BM+T>CWWJ
aQ(,Gj,kR#,]A78-@0h#4edF!--]ACD-_NV?7=h%RF25E;5,44%FihA)/'?gQ^D9op]A^GcLc;Q
/*jANq\4S-a^o>QYZR?\bl/M9<?0cIX9]Aj083?B>=5om#ZBRm@:Q^r1UPnBY)&sgQpE$TpKi
j(-L-Ln8rn2d;RC7sK&@/G)[#%MC'=mg?4'QM-mBDV@)['I2.:iH@GeUS:5RA]A*d3!<T?`4b
"Z#+e<sB07'@F%gj?bX`0_*[+VA:Jk9nDC+m:_)Yi,!QO>3!DA,"l'3@Q-BhE+='Gh44Q47=
mVlaT_hT$BcGk!R'a)&k%!8aNZZ0?CCR+/7lm'/@NI-$*n5,]Ah-nH_k;(Ze6J97o70EajjTj
6UaEN1H?4JGr7`O4V17i)+XIOO%SY:;hlc[C(3z8OZBBY!QNJ~
]]></IM>
</O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="当前表单对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="FENLEI"/>
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
</NameJavaScriptGroup>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$FENLEI = "1"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BorderHighlightAction">
<Border topLine="1" topColor="-65536" bottomLine="1" bottomColor="-65536" leftLine="1" leftColor="-65536" rightLine="1" rightColor="-65536"/>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="8" r="3" s="2">
<O>
<![CDATA[主营]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="当前表单对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="FENLEI"/>
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
</NameJavaScriptGroup>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$FENLEI = "1"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BorderHighlightAction">
<Border topLine="1" topColor="-65536" bottomLine="1" bottomColor="-65536" leftLine="1" leftColor="-65536" rightLine="1" rightColor="-65536"/>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="9" r="3" s="3">
<PrivilegeControl/>
</C>
<C c="10" r="3" s="4">
<O t="Image">
<IM>
<![CDATA[!Drp$rJ=?G7h#eD$31&+%7s)Y;?-[s*rl9@*s`&N!!"+D(-)?p!Z4Ks5u`*_m?^Ho6r=rDa"
)g29i5F:ZBib";AMg/P+jL(N(4Z+%U#39XfrLB.;Q14/?Hpf4Rsu*KGs;\f6=A.2pOGXW`u?
&r9BlAn%7JfpRM9`b]AjQ6nGF&nn-KX%UHf'O"%rt:5W=MpG/Kt;NrDId$UW?%JnVdc5%$?\k
_n$tehh\-$*Psdbk)&qJ6W7(I&\Rc8`+n%@%AIQTGD'W67q,Khp#<]A^t3NK33Z\l\(<:?=WD
X*/1-H.d:\%uC?fp"HTqf1EP081J]A:V_c&@#.6%:)^O)7"ai6be5(W4^H^#HhO@I=jH_]Auu,
M:Hk--b8X<RZDOFVXa:Ve#s/:G7_J^D$J%T"J8hKAJ0D#9DI5rq24Z?MX!L$!jQP0_7A525J
9dWL,&on5nB@GB4A2IkaG2o%m!r\nq?+48"s:OQ(dQ0Q@_CVXC)#BBpM/'^jL=I3fjRj_YdC
1CkVo:Y+QYC97/am<T=Hh2k+X.`M%;7@(jOQ;JGZ$EOX]Au6o>[Z_Da[TYBnHkWB&r500&!)P
8`=0264;L5;P6X^<X3e:$9nQXuC2[;(PM\c1^G_oo]AF7hLG<MGh@[6J1H_U\Np:4r.W`O$pO
g`)IFtDE87G0a*=?jB.;l(RPB`h^%#?BHm*5o<8kr,PVZ:Ha=DG8,`BtV->ZlWN>ZR&H2d.P
`E,Cl:1K>KrnIJR!!#SZ:.26O@"J~
]]></IM>
</O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="当前表单对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="FENLEI"/>
<O>
<![CDATA[0]]></O>
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
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$FENLEI = "0"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BorderHighlightAction">
<Border topLine="1" topColor="-65536" bottomLine="1" bottomColor="-65536" leftLine="1" leftColor="-65536" rightLine="1" rightColor="-65536"/>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="11" r="3" s="2">
<O>
<![CDATA[非主业]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="当前表单对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="FENLEI"/>
<O>
<![CDATA[0]]></O>
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
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$FENLEI = "0"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BorderHighlightAction">
<Border topLine="1" topColor="-65536" bottomLine="1" bottomColor="-65536" leftLine="1" leftColor="-65536" rightLine="1" rightColor="-65536"/>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="1" r="4">
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
<FRFont name="微软雅黑" style="1" size="96"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="4">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-3619393"/>
<Bottom style="1" color="-3619393"/>
<Left style="1" color="-3619393"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-3619393"/>
<Bottom style="1" color="-3619393"/>
<Right style="1" color="-3619393"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="4">
<FRFont name="SimSun" style="0" size="72" foreground="-16776961" underline="1"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-3619393"/>
<Bottom style="1" color="-3619393"/>
<Left style="1" color="-3619393"/>
</Border>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<isShared isshared="false"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="0" zoom="true" refresh="false" isUseHTML="false"/>
</body>
</InnerWidget>
<BoundsAttr x="0" y="0" width="956" height="85"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="report2"/>
<Widget widgetName="report3"/>
</MobileWidgetList>
<WidgetZoomAttr compState="0"/>
<AppRelayout appRelayout="true"/>
<Size width="956" height="496"/>
<ResolutionScalingAttr percent="0.9"/>
<tabFitAttr index="0" tabNameIndex="2"/>
</Widget>
<carouselAttr isCarousel="false" carouselInterval="1.8"/>
</Center>
</InnerWidget>
<BoundsAttr x="0" y="0" width="960" height="540"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="tablayout0"/>
</MobileWidgetList>
<WidgetZoomAttr compState="0"/>
<AppRelayout appRelayout="true"/>
<Size width="960" height="540"/>
<ResolutionScalingAttr percent="0.9"/>
<BodyLayoutType type="0"/>
</Center>
</Layout>
<DesignerVersion DesignerVersion="IAA"/>
<PreviewType PreviewType="0"/>
<TemplateID TemplateID="b70ba4ed-0518-480f-b560-c769e2033651"/>
</Form>
