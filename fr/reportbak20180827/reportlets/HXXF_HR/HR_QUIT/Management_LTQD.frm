<?xml version="1.0" encoding="UTF-8"?>
<Form xmlVersion="20170715" releaseVersion="8.0.0">
<TableDataMap>
<TableData name="猎-全" class="com.fr.data.impl.DBTableData">
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
DANWEI,
XINGMING, 
TREE_NODE_ID,
to_char(CSDATE,'yyyy-mm-dd') as CSDATE, 
GONGLING, 
YGZT, 
RZDATE,
trunc(months_between(LZDATE,RZDATE),1)  as  nf,
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
DW.TREE_NODE_NUM,
DW.PARENT_NODE,
DW.TREE_NODE,
DW.DESCR
FROM 
"ODM_HR_ZPTZ", ODM_HR_DW DW
 WHERE tree_node_id like '%' ||  DW.tree_node || '%' 
 AND  PARENT_NODE ='${DWMC}'
AND ZHIJIDQ NOT LIKE '99%'
AND TREE_NODE_ID LIKE '%${DWMC}%'
AND ISZHUYING='主营'
UNION ALL
SELECT 
DISTINCT YGID, 
DANWEI,
XINGMING, 
TREE_NODE_ID,
to_char(CSDATE,'yyyy-mm-dd') as CSDATE, 
GONGLING, 
YGZT, 
RZDATE,
trunc(months_between(LZDATE,RZDATE),1)  as  nf,
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
DW.TREE_NODE_NUM,
DW.PARENT_NODE,
DW.TREE_NODE,
DW.DESCR
FROM 
"ODM_HR_ZPTZ", ODM_HR_DW DW
 WHERE tree_node_id like '%' ||  DW.tree_node || '%' 
 AND  TREE_NODE ='${DWMC}'
AND ZHIJIDQ  LIKE '99%'
AND TREE_NODE_ID LIKE '%${DWMC}%'
AND ISZHUYING='主营'
ORDER BY  TREE_NODE_NUM asc,ZHIJIDQ DESC,RZDATE asc,YGID asc 
),

ZPTZ2 AS (
SELECT * FROM ZPTZ1  WHERE RZDATE<TO_DATE('${date_time}','YYYY-MM-DD')
AND TO_NUMBER(SUBSTR(ZHIJILY,1,2))> 5 and TO_NUMBER(SUBSTR(ZHIJILY,1,2))<= 18 
AND YGID NOT IN (SELECT YGID FROM ZPTZ1 WHERE ygzt='离职' and nf<6 AND nf>=0 )
)

select descr,TREE_NODE,  
COUNT ( case when zpqudao='猎头'  and TO_CHAR(RZDATE,'YYYY')=substr('${date_time}',0,4) then ygid END) AS LTS,--猎头人数
COUNT (  case when zpqudao<>'猎头' and TO_CHAR(RZDATE,'YYYY')=substr('${date_time}',0,4) then ygid END ) AS FLTRS,-- 非猎头人数 
COUNT (  case when  TO_CHAR(RZDATE,'YYYY')=substr('${date_time}',0,4) then ygid END ) AS QBS ,            -- 全部人数
CASE WHEN    COUNT ( case WHEN TO_CHAR(RZDATE,'YYYY')=substr('${date_time}',0,4) then ygid end ) = 0 
              THEN 0 
              ELSE ROUND (
                  COUNT ( case when zpqudao='猎头'  and TO_CHAR(RZDATE,'YYYY')=substr('${date_time}',0,4) then ygid END) /
                  COUNT ( case WHEN TO_CHAR(RZDATE,'YYYY')=substr('${date_time}',0,4) then ygid end ) , 3)
                   END  AS lv,                                           --猎头使用率
  COUNT ( case when zpqudao='猎头'  and TO_CHAR(RZDATE,'YYYY')=substr('${date_time}',0,4)-1 then ygid END) AS NCLTS ,--年初猎头人数
         COUNT ( case WHEN TO_CHAR(RZDATE,'YYYY')=substr('${date_time}',0,4)-1  then ygid end ) AS NCQBS   ,          -- 年初全部人数  
         CASE WHEN    COUNT ( case WHEN TO_CHAR(RZDATE,'YYYY')=substr('${date_time}',0,4)-1 then ygid end ) = 0 
              THEN 0 
              ELSE ROUND （
                  COUNT ( case when zpqudao='猎头' and TO_CHAR(RZDATE,'YYYY')=substr('${date_time}',0,4)-1 then ygid END) /
                  COUNT ( case WHEN TO_CHAR(RZDATE,'YYYY')=substr('${date_time}',0,4)-1  then ygid end ) , 4)
                   END  AS     NClv                                                                                --年初猎头使用率
from ZPTZ2
 group by descr,TREE_NODE

 --group by TREE_NODE,DESCR, TREE_NODE2,DESCR2  order by TREE_NODE;
]]></Query>
</TableData>
<TableData name="各月执行情况" class="com.fr.data.impl.DBTableData">
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
DANWEI,
XINGMING, 
TREE_NODE_ID,
to_char(CSDATE,'yyyy-mm-dd') as CSDATE, 
GONGLING, 
YGZT, 
RZDATE,
trunc(months_between(LZDATE,RZDATE),1)  as  nf,
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
DW.TREE_NODE_NUM,
DW.PARENT_NODE,
DW.TREE_NODE,
DW.DESCR
FROM 
"ODM_HR_ZPTZ", ODM_HR_DW DW
 WHERE tree_node_id like '%' ||  DW.tree_node || '%' 
 AND  PARENT_NODE ='${DWMC}'
AND ZHIJIDQ NOT LIKE '99%'
AND TREE_NODE_ID LIKE '%${DWMC}%'
AND ISZHUYING='主营'
UNION ALL
SELECT 
DISTINCT YGID, 
DANWEI,
XINGMING, 
TREE_NODE_ID,
to_char(CSDATE,'yyyy-mm-dd') as CSDATE, 
GONGLING, 
YGZT, 
RZDATE,
trunc(months_between(LZDATE,RZDATE),1)  as  nf,
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
DW.TREE_NODE_NUM,
DW.PARENT_NODE,
DW.TREE_NODE,
DW.DESCR
FROM 
"ODM_HR_ZPTZ", ODM_HR_DW DW
 WHERE tree_node_id like '%' ||  DW.tree_node || '%' 
 AND  TREE_NODE ='${DWMC}'
AND ZHIJIDQ  LIKE '99%'
AND TREE_NODE_ID LIKE '%${DWMC}%'
AND ISZHUYING='主营'
ORDER BY  TREE_NODE_NUM asc,ZHIJIDQ DESC,RZDATE asc,YGID asc 
),

ZPTZ2 AS (
SELECT * FROM ZPTZ1  WHERE RZDATE<TO_DATE('${date_time}','YYYY-MM-DD')
AND TO_NUMBER(SUBSTR(ZHIJILY,1,2))> 5 and TO_NUMBER(SUBSTR(ZHIJILY,1,2))<= 18 
AND YGID NOT IN (SELECT YGID FROM ZPTZ1 WHERE ygzt='离职' and nf<6 AND nf>=0 )
)
   
   
SELECT   /* T1.TREE_NODE ,--父node
          T1.DESCR, --组织名称
          T1.TREE_NODE2    , --子node
          T1.DESCR2        ,--名称
          T1.TREE_NODE_NUM,--排序*/
--猎头人数年初加1-12月
COUNT ( case when zpqudao='猎头'  and TO_CHAR(RZDATE,'YYYY') = (substr('${date_time}',0,4)-1) then ygid END) AS LTNC,				--猎头年初人数
COUNT ( case when zpqudao='猎头'  and TO_CHAR(RZDATE,'YYYY-MM-DD') BETWEEN substr('${date_time}',0,4)||'-01-01' AND substr('${date_time}',0,4)||'-01-31' then ygid END) AS LTone,
COUNT ( case when zpqudao='猎头'  and TO_CHAR(RZDATE,'YYYY-MM-DD') BETWEEN substr('${date_time}',0,4)||'-02-01' AND substr('${date_time}',0,4)||'-02-31' then ygid END) AS LTtwo,
COUNT ( case when zpqudao='猎头'  and TO_CHAR(RZDATE,'YYYY-MM-DD') BETWEEN substr('${date_time}',0,4)||'-03-01' AND substr('${date_time}',0,4)||'-03-31' then ygid END) AS LTthree,
COUNT ( case when zpqudao='猎头'  and TO_CHAR(RZDATE,'YYYY-MM-DD') BETWEEN substr('${date_time}',0,4)||'-04-01' AND substr('${date_time}',0,4)||'-04-31' then ygid END) AS LTfour,
COUNT ( case when zpqudao='猎头'  and TO_CHAR(RZDATE,'YYYY-MM-DD') BETWEEN substr('${date_time}',0,4)||'-05-01' AND substr('${date_time}',0,4)||'-05-31' then ygid END) AS LTfive,
COUNT ( case when zpqudao='猎头'  and TO_CHAR(RZDATE,'YYYY-MM-DD') BETWEEN substr('${date_time}',0,4)||'-06-01' AND substr('${date_time}',0,4)||'-06-31' then ygid END) AS LTsix,
COUNT ( case when zpqudao='猎头'  and TO_CHAR(RZDATE,'YYYY-MM-DD') BETWEEN substr('${date_time}',0,4)||'-07-01' AND substr('${date_time}',0,4)||'-07-31' then ygid END) AS LTseven,
COUNT ( case when zpqudao='猎头'  and TO_CHAR(RZDATE,'YYYY-MM-DD') BETWEEN substr('${date_time}',0,4)||'-08-01' AND substr('${date_time}',0,4)||'-08-31' then ygid END) AS LTeight,
COUNT ( case when zpqudao='猎头'  and TO_CHAR(RZDATE,'YYYY-MM-DD') BETWEEN substr('${date_time}',0,4)||'-09-01' AND substr('${date_time}',0,4)||'-09-31' then ygid END) AS LTnine,
COUNT ( case when zpqudao='猎头'  and TO_CHAR(RZDATE,'YYYY-MM-DD') BETWEEN substr('${date_time}',0,4)||'-10-01' AND substr('${date_time}',0,4)||'-10-31' then ygid END) AS LTten,
COUNT ( case when zpqudao='猎头'  and TO_CHAR(RZDATE,'YYYY-MM-DD') BETWEEN substr('${date_time}',0,4)||'-11-01' AND substr('${date_time}',0,4)||'-11-31' then ygid END) AS LTeleven,
COUNT ( case when zpqudao='猎头'  and TO_CHAR(RZDATE,'YYYY-MM-DD') BETWEEN substr('${date_time}',0,4)||'-12-01' AND substr('${date_time}',0,4)||'-12-31' then ygid END) AS LTtwelve,
--全部人数年初加1-12月
COUNT ( case when   TO_CHAR(RZDATE,'YYYY') = substr('${date_time}',0,4)-1 then ygid END) AS QBNC,
COUNT ( case when   TO_CHAR(RZDATE,'YYYY-MM-DD') BETWEEN substr('${date_time}',0,4)||'-01-01' AND substr('${date_time}',0,4)||'-01-31' then ygid END) AS QBone,
COUNT ( case when  TO_CHAR(RZDATE,'YYYY-MM-DD') BETWEEN substr('${date_time}',0,4)||'-02-01' AND substr('${date_time}',0,4)||'-02-31' then ygid END) AS QBtwo,
COUNT ( case when   TO_CHAR(RZDATE,'YYYY-MM-DD') BETWEEN substr('${date_time}',0,4)||'-03-01' AND substr('${date_time}',0,4)||'-03-31' then ygid END) AS QBthree,
COUNT ( case when   TO_CHAR(RZDATE,'YYYY-MM-DD') BETWEEN substr('${date_time}',0,4)||'-04-01' AND substr('${date_time}',0,4)||'-04-31' then ygid END) AS QBfour,
COUNT ( case when   TO_CHAR(RZDATE,'YYYY-MM-DD') BETWEEN substr('${date_time}',0,4)||'-05-01' AND substr('${date_time}',0,4)||'-05-31' then ygid END) AS QBfive,
COUNT ( case when   TO_CHAR(RZDATE,'YYYY-MM-DD') BETWEEN substr('${date_time}',0,4)||'-06-01' AND substr('${date_time}',0,4)||'-06-31' then ygid END) AS QBsix,
COUNT ( case when   TO_CHAR(RZDATE,'YYYY-MM-DD') BETWEEN substr('${date_time}',0,4)||'-07-01' AND substr('${date_time}',0,4)||'-07-31' then ygid END) AS QBseven,
COUNT ( case when  TO_CHAR(RZDATE,'YYYY-MM-DD') BETWEEN substr('${date_time}',0,4)||'-08-01' AND substr('${date_time}',0,4)||'-08-31' then ygid END) AS QBeight,
COUNT ( case when   TO_CHAR(RZDATE,'YYYY-MM-DD') BETWEEN substr('${date_time}',0,4)||'-09-01' AND substr('${date_time}',0,4)||'-09-31' then ygid END) AS QBnine,
COUNT ( case when   TO_CHAR(RZDATE,'YYYY-MM-DD') BETWEEN substr('${date_time}',0,4)||'-10-01' AND substr('${date_time}',0,4)||'-10-31' then ygid END) AS QBten,
COUNT ( case when  TO_CHAR(RZDATE,'YYYY-MM-DD') BETWEEN substr('${date_time}',0,4)||'-11-01' AND substr('${date_time}',0,4)||'-11-31' then ygid END) AS QBeleven,
COUNT ( case when   TO_CHAR(RZDATE,'YYYY-MM-DD') BETWEEN substr('${date_time}',0,4)||'-12-01' AND substr('${date_time}',0,4)||'-12-31' then ygid END) AS QBtwelve
          
           FROM  ZPTZ2 ]]></Query>
</TableData>
<TableData name="各月" class="com.fr.data.impl.DBTableData">
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
<![CDATA[WITH ODM_HR_TREE AS (
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
   )T3  ORDER BY TREE_NODE_NUM) 
   
   
SELECT   
'1月' AS MONT,
count ( case when T2.zpqudao='猎头' AND TO_NUMBER(SUBSTR(ZHIJILY,1,2))> 0 and TO_CHAR(T2.RZDATE,'YYYY-MM-DD') BETWEEN substr('${date_time}',0,4)||'-01-01' AND substr('${date_time}',0,4)||'-01-31' then ygid END) AS LTFYone
FROM  ODM_HR_TREE T1 LEFT JOIN ODM_HR_ZPTZ T2  
    ON   T2.TREE_NODE_ID LIKE '%'||T1.TREE_NODE2||'%'
 WHERE TO_CHAR(T2.RZDATE,'YYYY-MM-DD')<'${date_time}'
    ${IF(DWMC = 'HX_HEAD',
            " and TREE_NODE2 in (SELECT TREE_NODE FROM ODM_HR_DW WHERE PARENT_NODE ='HX_HEAD')",
            " and TREE_NODE2 <> TREE_NODE and parent_nodes like '%" + DWMC + "%'") }
UNION ALL 
SELECT   
'2月' AS MONT,
count ( case when T2.zpqudao='猎头' AND TO_NUMBER(SUBSTR(ZHIJILY,1,2))> 0 and TO_CHAR(T2.RZDATE,'YYYY-MM-DD') BETWEEN substr('${date_time}',0,4)||'-02-01' AND substr('${date_time}',0,4)||'-02-31' then ygid END) AS LTFYone
FROM  ODM_HR_TREE T1 LEFT JOIN ODM_HR_ZPTZ T2  
    ON   T2.TREE_NODE_ID LIKE '%'||T1.TREE_NODE2||'%'
 WHERE TO_CHAR(T2.RZDATE,'YYYY-MM-DD')<'${date_time}'
    ${IF(DWMC = 'HX_HEAD',
            " and TREE_NODE2 in (SELECT TREE_NODE FROM ODM_HR_DW WHERE PARENT_NODE ='HX_HEAD')",
            " and TREE_NODE2 <> TREE_NODE and parent_nodes like '%" + DWMC + "%'") }
UNION ALL 
SELECT   
'3月' AS MONT,
count ( case when T2.zpqudao='猎头' AND TO_NUMBER(SUBSTR(ZHIJILY,1,2))> 0 and TO_CHAR(T2.RZDATE,'YYYY-MM-DD') BETWEEN substr('${date_time}',0,4)||'-03-01' AND substr('${date_time}',0,4)||'-03-31' then ygid END) AS LTFYone
FROM  ODM_HR_TREE T1 LEFT JOIN ODM_HR_ZPTZ T2  
    ON   T2.TREE_NODE_ID LIKE '%'||T1.TREE_NODE2||'%'
 WHERE TO_CHAR(T2.RZDATE,'YYYY-MM-DD')<'${date_time}'
    ${IF(DWMC = 'HX_HEAD',
            " and TREE_NODE2 in (SELECT TREE_NODE FROM ODM_HR_DW WHERE PARENT_NODE ='HX_HEAD')",
            " and TREE_NODE2 <> TREE_NODE and parent_nodes like '%" + DWMC + "%'") }           
UNION ALL 
SELECT   
'4月' AS MONT,
count ( case when T2.zpqudao='猎头' AND TO_NUMBER(SUBSTR(ZHIJILY,1,2))> 0 and TO_CHAR(T2.RZDATE,'YYYY-MM-DD') BETWEEN substr('${date_time}',0,4)||'-04-01' AND substr('${date_time}',0,4)||'-04-31' then ygid END) AS LTFYone
FROM  ODM_HR_TREE T1 LEFT JOIN ODM_HR_ZPTZ T2  
    ON   T2.TREE_NODE_ID LIKE '%'||T1.TREE_NODE2||'%'
 WHERE TO_CHAR(T2.RZDATE,'YYYY-MM-DD')<'${date_time}'
    ${IF(DWMC = 'HX_HEAD',
            " and TREE_NODE2 in (SELECT TREE_NODE FROM ODM_HR_DW WHERE PARENT_NODE ='HX_HEAD')",
            " and TREE_NODE2 <> TREE_NODE and parent_nodes like '%" + DWMC + "%'") }    
UNION ALL 
SELECT   
'5月' AS MONT,
count ( case when T2.zpqudao='猎头' AND TO_NUMBER(SUBSTR(ZHIJILY,1,2))> 0 and TO_CHAR(T2.RZDATE,'YYYY-MM-DD') BETWEEN substr('${date_time}',0,4)||'-05-01' AND substr('${date_time}',0,4)||'-05-31' then ygid END) AS LTFYone
FROM  ODM_HR_TREE T1 LEFT JOIN ODM_HR_ZPTZ T2  
    ON   T2.TREE_NODE_ID LIKE '%'||T1.TREE_NODE2||'%'
 WHERE TO_CHAR(T2.RZDATE,'YYYY-MM-DD')<'${date_time}'
    ${IF(DWMC = 'HX_HEAD',
            " and TREE_NODE2 in (SELECT TREE_NODE FROM ODM_HR_DW WHERE PARENT_NODE ='HX_HEAD')",
            " and TREE_NODE2 <> TREE_NODE and parent_nodes like '%" + DWMC + "%'") }           
UNION ALL 
SELECT   
'6月' AS MONT,
count ( case when T2.zpqudao='猎头' AND TO_NUMBER(SUBSTR(ZHIJILY,1,2))> 0 and TO_CHAR(T2.RZDATE,'YYYY-MM-DD') BETWEEN substr('${date_time}',0,4)||'-06-01' AND substr('${date_time}',0,4)||'-06-31' then ygid END) AS LTFYone
FROM  ODM_HR_TREE T1 LEFT JOIN ODM_HR_ZPTZ T2  
    ON   T2.TREE_NODE_ID LIKE '%'||T1.TREE_NODE2||'%'
 WHERE TO_CHAR(T2.RZDATE,'YYYY-MM-DD')<'${date_time}'
    ${IF(DWMC = 'HX_HEAD',
            " and TREE_NODE2 in (SELECT TREE_NODE FROM ODM_HR_DW WHERE PARENT_NODE ='HX_HEAD')",
            " and TREE_NODE2 <> TREE_NODE and parent_nodes like '%" + DWMC + "%'") }           
UNION ALL 
SELECT   
'7月' AS MONT,
count ( case when T2.zpqudao='猎头' AND TO_NUMBER(SUBSTR(ZHIJILY,1,2))> 0 and TO_CHAR(T2.RZDATE,'YYYY-MM-DD') BETWEEN substr('${date_time}',0,4)||'-07-01' AND substr('${date_time}',0,4)||'-07-31' then ygid END) AS LTFYone
FROM  ODM_HR_TREE T1 LEFT JOIN ODM_HR_ZPTZ T2  
    ON   T2.TREE_NODE_ID LIKE '%'||T1.TREE_NODE2||'%'
 WHERE TO_CHAR(T2.RZDATE,'YYYY-MM-DD')<'${date_time}'
    ${IF(DWMC = 'HX_HEAD',
            " and TREE_NODE2 in (SELECT TREE_NODE FROM ODM_HR_DW WHERE PARENT_NODE ='HX_HEAD')",
            " and TREE_NODE2 <> TREE_NODE and parent_nodes like '%" + DWMC + "%'") }          
UNION ALL 
SELECT   
'8月' AS MONT,
count ( case when T2.zpqudao='猎头' AND TO_NUMBER(SUBSTR(ZHIJILY,1,2))> 0 and TO_CHAR(T2.RZDATE,'YYYY-MM-DD') BETWEEN substr('${date_time}',0,4)||'-08-01' AND substr('${date_time}',0,4)||'-08-31' then ygid END) AS LTFYone
FROM  ODM_HR_TREE T1 LEFT JOIN ODM_HR_ZPTZ T2  
    ON   T2.TREE_NODE_ID LIKE '%'||T1.TREE_NODE2||'%'
 WHERE TO_CHAR(T2.RZDATE,'YYYY-MM-DD')<'${date_time}'
    ${IF(DWMC = 'HX_HEAD',
            " and TREE_NODE2 in (SELECT TREE_NODE FROM ODM_HR_DW WHERE PARENT_NODE ='HX_HEAD')",
            " and TREE_NODE2 <> TREE_NODE and parent_nodes like '%" + DWMC + "%'") }           
UNION ALL 
SELECT   
'9月' AS MONT,
count ( case when T2.zpqudao='猎头' AND TO_NUMBER(SUBSTR(ZHIJILY,1,2))> 0 and TO_CHAR(T2.RZDATE,'YYYY-MM-DD') BETWEEN substr('${date_time}',0,4)||'-09-01' AND substr('${date_time}',0,4)||'-09-31' then ygid END) AS LTFYone
FROM  ODM_HR_TREE T1 LEFT JOIN ODM_HR_ZPTZ T2  
    ON   T2.TREE_NODE_ID LIKE '%'||T1.TREE_NODE2||'%'
 WHERE TO_CHAR(T2.RZDATE,'YYYY-MM-DD')<'${date_time}'
    ${IF(DWMC = 'HX_HEAD',
            " and TREE_NODE2 in (SELECT TREE_NODE FROM ODM_HR_DW WHERE PARENT_NODE ='HX_HEAD')",
            " and TREE_NODE2 <> TREE_NODE and parent_nodes like '%" + DWMC + "%'") }           
UNION ALL 
SELECT   
'10月' AS MONT,
count ( case when T2.zpqudao='猎头' AND TO_NUMBER(SUBSTR(ZHIJILY,1,2))> 0 and TO_CHAR(T2.RZDATE,'YYYY-MM-DD') BETWEEN substr('${date_time}',0,4)||'-10-01' AND substr('${date_time}',0,4)||'-10-31' then ygid END) AS LTFYone
FROM  ODM_HR_TREE T1 LEFT JOIN ODM_HR_ZPTZ T2  
    ON   T2.TREE_NODE_ID LIKE '%'||T1.TREE_NODE2||'%'
 WHERE TO_CHAR(T2.RZDATE,'YYYY-MM-DD')<'${date_time}'
    ${IF(DWMC = 'HX_HEAD',
            " and TREE_NODE2 in (SELECT TREE_NODE FROM ODM_HR_DW WHERE PARENT_NODE ='HX_HEAD')",
            " and TREE_NODE2 <> TREE_NODE and parent_nodes like '%" + DWMC + "%'") }           
UNION ALL 
SELECT   
'11月' AS MONT,
count ( case when T2.zpqudao='猎头' AND TO_NUMBER(SUBSTR(ZHIJILY,1,2))> 0 and TO_CHAR(T2.RZDATE,'YYYY-MM-DD') BETWEEN substr('${date_time}',0,4)||'-11-01' AND substr('${date_time}',0,4)||'-11-31' then ygid END) AS LTFYone
FROM  ODM_HR_TREE T1 LEFT JOIN ODM_HR_ZPTZ T2  
    ON   T2.TREE_NODE_ID LIKE '%'||T1.TREE_NODE2||'%'
 WHERE TO_CHAR(T2.RZDATE,'YYYY-MM-DD')<'${date_time}'
    ${IF(DWMC = 'HX_HEAD',
            " and TREE_NODE2 in (SELECT TREE_NODE FROM ODM_HR_DW WHERE PARENT_NODE ='HX_HEAD')",
            " and TREE_NODE2 <> TREE_NODE and parent_nodes like '%" + DWMC + "%'") }          
UNION ALL 
SELECT   
'12月' AS MONT,
count ( case when T2.zpqudao='猎头' AND TO_NUMBER(SUBSTR(ZHIJILY,1,2))> 0 and TO_CHAR(T2.RZDATE,'YYYY-MM-DD') BETWEEN substr('${date_time}',0,4)||'-12-01' AND substr('${date_time}',0,4)||'-12-31' then ygid END) AS LTFYone
FROM  ODM_HR_TREE T1 LEFT JOIN ODM_HR_ZPTZ T2  
    ON   T2.TREE_NODE_ID LIKE '%'||T1.TREE_NODE2||'%'
 WHERE TO_CHAR(T2.RZDATE,'YYYY-MM-DD')<'${date_time}'
    ${IF(DWMC = 'HX_HEAD',
            " and TREE_NODE2 in (SELECT TREE_NODE FROM ODM_HR_DW WHERE PARENT_NODE ='HX_HEAD')",
            "  and parent_nodes like '%" + DWMC + "%'") }  ]]></Query>
</TableData>
<TableData name="职级" class="com.fr.data.impl.DBTableData">
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
<![CDATA[select * from(
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
   )T3  ORDER BY TREE_NODE_NUM) 
   
   
SELECT   ZHIJIly,
COUNT ( case when T2.zpqudao='猎头' and TO_CHAR(T2.RZDATE,'YYYY')=substr('${date_time}',0,4) then ygid END) ount
          
           FROM  ODM_HR_TREE T1 LEFT JOIN ODM_HR_ZPTZ T2  
    ON   T2.TREE_NODE_ID LIKE '%'||T1.TREE_NODE2||'%'
    WHERE 1=1 
    and ZHIJIly not like '%99%'
    ${IF(DWMC = 'HX_HEAD',
            " and TREE_NODE2 in (SELECT TREE_NODE FROM ODM_HR_DW WHERE PARENT_NODE ='HX_HEAD')",
            "  and parent_nodes like '%" + DWMC + "%'") }
    GROUP BY ZHIJIly
) where ount<>0 ORDER BY ount desc]]></Query>
</TableData>
<TableData name="ds1" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="date_time"/>
<O>
<![CDATA[2018-06-14]]></O>
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
<TableData name="猎头渠道明细" class="com.fr.data.impl.DBTableData">
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
<![CDATA[select QUDAOMX,
	   ount,
	   case when QUDAOMX is null then 1 else 0 end px from(
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
   )T3  ORDER BY TREE_NODE_NUM) 
   
   
SELECT   QUDAOMX,
COUNT ( case when T2.zpqudao='猎头' and TO_CHAR(T2.RZDATE,'YYYY')=substr('${date_time}',0,4) then ygid END) ount
          
           FROM  ODM_HR_TREE T1 LEFT JOIN ODM_HR_ZPTZ T2  
    ON   T2.TREE_NODE_ID LIKE '%'||T1.TREE_NODE2||'%'
    WHERE 1=1 
    and ZHIJIly not like '%99%'
    ${IF(DWMC = 'HX_HEAD',
            " and TREE_NODE2 in (SELECT TREE_NODE FROM ODM_HR_DW WHERE PARENT_NODE ='HX_HEAD')",
            "  and parent_nodes like '%" + DWMC + "%'") }
    GROUP BY QUDAOMX
) where ount<>0  ORDER BY  px,ount desc]]></Query>
</TableData>
<TableData name="ds2" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="date_time"/>
<O>
<![CDATA[2018-06-05]]></O>
</Parameter>
<Parameter>
<Attributes name="dwmc"/>
<O>
<![CDATA[10046109037]]></O>
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
TREE_NODE_ID,
to_char(CSDATE,'yyyy-mm-dd') as CSDATE, 
GONGLING, 
YGZT, 
RZDATE,
trunc(months_between(LZDATE,RZDATE),1)  as  nf,
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
DW.TREE_NODE_NUM,
DW.PARENT_NODE,
DW.TREE_NODE,
DW.DESCR
FROM 
"ODM_HR_ZPTZ", ODM_HR_DW DW
 WHERE tree_node_id like '%' ||  DW.tree_node || '%' 
 AND  PARENT_NODE ='${dwmc}'
AND ZHIJIDQ NOT LIKE '99%'
AND TREE_NODE_ID LIKE '%${dwmc}%'
AND ISZHUYING='主营'
UNION ALL
SELECT 
DISTINCT YGID, 
DANWEI,
XINGMING, 
TREE_NODE_ID,
to_char(CSDATE,'yyyy-mm-dd') as CSDATE, 
GONGLING, 
YGZT, 
RZDATE,
trunc(months_between(LZDATE,RZDATE),1)  as  nf,
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
DW.TREE_NODE_NUM,
DW.PARENT_NODE,
DW.TREE_NODE,
DW.DESCR
FROM 
"ODM_HR_ZPTZ", ODM_HR_DW DW
 WHERE tree_node_id like '%' ||  DW.tree_node || '%' 
 AND  TREE_NODE ='${dwmc}'
AND ZHIJIDQ  LIKE '99%'
AND TREE_NODE_ID LIKE '%${dwmc}%'
AND ISZHUYING='主营'
ORDER BY  TREE_NODE_NUM asc,ZHIJIDQ DESC,RZDATE asc,YGID asc 
),

ZPTZ2 AS (
SELECT * FROM ZPTZ1  WHERE RZDATE<TO_DATE('${date_time}','YYYY-MM-DD')
AND TO_NUMBER(SUBSTR(ZHIJILY,1,2))> 5 and TO_NUMBER(SUBSTR(ZHIJILY,1,2))<= 18 
AND YGID NOT IN (SELECT YGID FROM ZPTZ1 WHERE ygzt='离职' and nf<6 AND nf>=0 )
)

select descr,TREE_NODE,  
COUNT ( case when zpqudao='猎头'  and TO_CHAR(RZDATE,'YYYY')=substr('${date_time}',0,4) then ygid END) AS LTS,--猎头人数
COUNT (  case when zpqudao<>'猎头' and TO_CHAR(RZDATE,'YYYY')=substr('${date_time}',0,4) then ygid END ) AS FLTRS,-- 非猎头人数 
COUNT (  case when  TO_CHAR(RZDATE,'YYYY')=substr('${date_time}',0,4) then ygid END ) AS QBS ,            -- 全部人数
CASE WHEN    COUNT ( case WHEN TO_CHAR(RZDATE,'YYYY')=substr('${date_time}',0,4) then ygid end ) = 0 
              THEN 0 
              ELSE ROUND （
                  COUNT ( case when zpqudao='猎头'  and TO_CHAR(RZDATE,'YYYY')=substr('${date_time}',0,4) then ygid END) /
                  COUNT ( case WHEN TO_CHAR(RZDATE,'YYYY')=substr('${date_time}',0,4) then ygid end ) , 3）
                   END  AS lv,                                           --猎头使用率
  COUNT ( case when zpqudao='猎头'  and TO_CHAR(RZDATE,'YYYY')=substr('${date_time}',0,4)-1 then ygid END) AS NCLTS ,--年初猎头人数
         COUNT ( case WHEN TO_CHAR(RZDATE,'YYYY')=substr('${date_time}',0,4)-1  then ygid end ) AS NCQBS   ,          -- 年初全部人数  
         CASE WHEN    COUNT ( case WHEN TO_CHAR(RZDATE,'YYYY')=substr('${date_time}',0,4)-1 then ygid end ) = 0 
              THEN 0 
              ELSE ROUND （
                  COUNT ( case when zpqudao='猎头' and TO_CHAR(RZDATE,'YYYY')=substr('${date_time}',0,4)-1 then ygid END) /
                  COUNT ( case WHEN TO_CHAR(RZDATE,'YYYY')=substr('${date_time}',0,4)-1  then ygid end ) , 4）
                   END  AS     NClv                                                                                --年初猎头使用率
from ZPTZ2
 group by descr,TREE_NODE

 --group by TREE_NODE,DESCR, TREE_NODE2,DESCR2  order by TREE_NODE;
]]></Query>
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
<![CDATA[WebReport/ReportServer?formlet=HXXF_HR/HR_QUIT/Management_LTQD.frm&op=view]]></O>
</ColumnConfig>
<ColumnConfig name="CPT" isKey="false" skipUnmodified="false">
<O>
<![CDATA[Management_LTQD.frm]]></O>
</ColumnConfig>
<ColumnConfig name="CPT_NAME" isKey="false" skipUnmodified="false">
<O>
<![CDATA[06级及以上猎头使用优化率]]></O>
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
<![CDATA[=NOW()]]></Attributes>
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
<![CDATA[1257300,864000,864000,864000,0,1562100,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[3657600,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
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
<![CDATA[1 06级以上猎头使用比= 06级以上猎头渠道入职人数/ 06级以上入职总人数]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="2" s="1">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="2" cs="10" s="1">
<O>
<![CDATA[2 猎头渠道使用优化率=1-（2018年06级以上猎头使用比/2017年06级以上猎头使用比）]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="3" cs="10" s="1">
<O>
<![CDATA[3 仅统计主营，不包含入职六个月内离职员工]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="4" cs="10" s="1">
<O>
<![CDATA[4 ]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="5">
<O>
<![CDATA[ ]]></O>
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
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
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
<BoundsAttr x="0" y="0" width="901" height="100"/>
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
<![CDATA[1257300,864000,864000,1440000,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[3657600,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
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
<C c="1" r="1" cs="10" s="0">
<O>
<![CDATA[1 猎头渠道使用优化率=(2017猎头渠道招聘入职人数/2017招聘入职总人数）/（2018猎头渠道招聘入职人数/2018招聘入职总人数）-1]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="2" s="0">
<PrivilegeControl/>
</C>
<C c="1" r="2" cs="10" s="0">
<O>
<![CDATA[2 猎头渠道使用优化率仅统计入职职级在06级及以上员工]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="3">
<O>
<![CDATA[  ]]></O>
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
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<isShared isshared="false"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="0" zoom="true" refresh="false" isUseHTML="false"/>
</body>
</InnerWidget>
<BoundsAttr x="0" y="1086" width="901" height="100"/>
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
<![CDATA[/*var url = FR.cjkEncode("/WebReport/ReportServer?formlet=HXXF_HR/HR_QUIT/Management_LTFY.frm"); FR.doHyperlinkByGet({url:url,title:'Management_monitoring',target:'_self',date_time:date_time1,dwmc:dwmc1});  */
location=FR.cjkEncode("/WebReport/ReportServer?formlet=HXXF_HR%2FHR_QUIT%2FManagement_LTFY.frm&date_time="+date_time1+"&dwmc="+dwmc1+"&username="+username1);]]></Content>
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
<BoundsAttr x="131" y="0" width="50" height="24"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.FreeButton">
<WidgetName name="button2"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Text>
<![CDATA[上一指标]]></Text>
<FRFont name="微软雅黑" style="0" size="72" foreground="-16776961"/>
<isCustomType isCustomType="true"/>
</InnerWidget>
<BoundsAttr x="81" y="0" width="50" height="24"/>
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

var url = FR.cjkEncode("/WebReport/ReportServer?reportlet=HXXF_HR%2FHR_QUIT%2FLTQD_OptimizeRate.cpt&date_time="+date_time1+"&dwmc="+dwmc1+"&format=excel&extype=simple&__filename__="+ res+"_猎头使用优化率_"+res1);
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
<![CDATA[WebReport/ReportServer?formlet=HXXF_HR/HR_QUIT/Management_LTQD.frm&op=view]]></O>
</ColumnConfig>
<ColumnConfig name="CPT" isKey="false" skipUnmodified="false">
<O>
<![CDATA[Management_LTQD.frm]]></O>
</ColumnConfig>
<ColumnConfig name="CPT_NAME" isKey="false" skipUnmodified="false">
<O>
<![CDATA[06级及以上猎头使用优化率]]></O>
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
<ColumnConfig name="DOWNLOAD_TYPE" isKey="false" skipUnmodified="false">
<O>
<![CDATA[1]]></O>
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
<WidgetName name="button4"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Text>
<![CDATA[下载EXCEL]]></Text>
<FRFont name="微软雅黑" style="0" size="72" foreground="-16776961" underline="1"/>
<isCustomType isCustomType="true"/>
</InnerWidget>
<BoundsAttr x="852" y="0" width="49" height="24"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="label1"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O>
<![CDATA[06级及以上猎头使用优化率]]></O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="0" autoline="true"/>
<FRFont name="微软雅黑" style="1" size="160"/>
<border style="0" color="-723724"/>
</InnerWidget>
<BoundsAttr x="0" y="24" width="901" height="39"/>
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
<BoundsAttr x="181" y="0" width="60" height="21"/>
</Widget>
</InnerWidget>
<BoundsAttr x="181" y="0" width="60" height="24"/>
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
<BoundsAttr x="802" y="0" width="50" height="24"/>
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
<![CDATA[723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[419100,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="0" cs="10" s="0">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="截止至" + "<span style='color:#bf0008; font-weight: bold;'>" + YEAR($date_time) + "年" + MONTH($date_time) + "月" + DAY($date_time) + "日, " + $mc1 + "</span>" + " 猎头渠道使用优化率 " + "<span style='color:#bf0008; font-weight: bold;'>" + format(I2,"#0.0%") + "</span>" + CONCATENATE("<font color=#000000 font-weight: bold;>", " ，本年度06级及以上入职 ", "<font color=#000000 sont-weight: bold;>") + "<span style='color:#bf0008; font-weight: bold;'>" + C2 + "</span>" + CONCATENATE("<font color=#000000 sont-weight: bold;>", " 人，其中，通过猎头渠道入职 ", "<font color=#000000 sont-weight: bold;>") + "<span style='color:#bf0008; font-weight: bold;'>" + D2 + "</span>" + CONCATENATE("<font color=#000000 sont-weight: bold;>", " 人，猎头使用占比 " + "<span style='color:#bf0008; font-weight: bold;'>" + format(F2,"#0.0%") + "  </span>" + "(2017年猎头使用占比 " + "<span style='color:#bf0008; font-weight: bold;'>" + G2 + "</span>" + " )。" + "<font color=#000000 sont-weight: bold;>")]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="1" r="1" s="1">
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
<C c="2" r="1" s="2">
<O t="DSColumn">
<Attributes dsName="ds1" columnName="QBS"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="3" r="1" s="2">
<O t="DSColumn">
<Attributes dsName="ds1" columnName="LTS"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="4" r="1" s="2">
<O t="DSColumn">
<Attributes dsName="ds1" columnName="LV"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[if(len($$$)=0,'0%',ROUND($$$*100,1)+"%")]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="5" r="1" s="2">
<O t="DSColumn">
<Attributes dsName="ds1" columnName="LV"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="6" r="1" s="2">
<O t="DSColumn">
<Attributes dsName="ds1" columnName="NCLV"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[if(len($$$)=0,'0%',ROUND($$$*100,1)+"%")]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="7" r="1" s="2">
<O t="DSColumn">
<Attributes dsName="ds1" columnName="NCLV"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="8" r="1" s="3">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=ROUND((1 - F2 / H2), 3)]]></Attributes>
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
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0.0%]]></Format>
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
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
</InnerWidget>
<BoundsAttr x="0" y="0" width="901" height="51"/>
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
<BoundsAttr x="0" y="63" width="901" height="51"/>
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
<![CDATA[1440000,1440000,0,864000,864000,864000,864000,864000,864000,864000,864000,864000,864000,864000,864000,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2880000,2880000,2880000,2880000,2880000,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="1" cs="5" s="0">
<O>
<![CDATA[猎头渠道明细及职级分布]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="2" s="1">
<O>
<![CDATA[离职原因分布]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="2" s="1">
<PrivilegeControl/>
</C>
<C c="2" r="2" s="1">
<O>
<![CDATA[离职职级分布]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="2" s="1">
<PrivilegeControl/>
</C>
<C c="4" r="2" s="1">
<O>
<![CDATA[离职司龄分布]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="3" cs="5" rs="13">
<O t="CC">
<LayoutAttr selectedIndex="0"/>
<ChangeAttr enable="true" changeType="carousel" timeInterval="3" buttonColor="-8421505" carouselColor="-8421505">
<TextAttr>
<Attr alignText="0">
<FRFont name="宋体" style="0" size="72"/>
</Attr>
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
<![CDATA[猎头渠道明细分布（TOP8）（含06级以下）]]></O>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="80" foreground="-13421773"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="2"/>
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
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#.##%]]></Format>
</AttrTooltipValueFormat>
</value>
<percent class="com.fr.plugin.chart.base.format.AttrTooltipPercentFormat">
<AttrTooltipPercentFormat>
<Attr enable="false"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0.0%]]></Format>
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
<Attr showLine="true" autoAdjust="false" position="6" isCustom="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="72"/>
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
<Attr enable="true"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0.0%]]></Format>
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
</DataSheet>
<DataProcessor class="com.fr.base.chart.chartdata.model.NormalDataModel"/>
<newPlotFillStyle>
<AttrFillStyle>
<AFStyle colorStyle="1"/>
<FillStyleName fillStyleName=""/>
<isCustomFillStyle isCustomFillStyle="true"/>
<ColorList>
<OColor colvalue="-6737636"/>
<OColor colvalue="-5154231"/>
<OColor colvalue="-543575"/>
<OColor colvalue="-2988442"/>
<OColor colvalue="-2607589"/>
<OColor colvalue="-955572"/>
<OColor colvalue="-2673125"/>
<OColor colvalue="-817041"/>
<OColor colvalue="-3113355"/>
<OColor colvalue="-3922173"/>
<OColor colvalue="-4259840"/>
<OColor colvalue="-25490"/>
<OColor colvalue="-39373"/>
<OColor colvalue="-39322"/>
<OColor colvalue="-52378"/>
<OColor colvalue="-4259832"/>
<OColor colvalue="-3406330"/>
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
<OneValueCDDefinition seriesName="QUDAOMX" valueName="OUNT" function="com.fr.data.util.function.NoneFunction">
<Top topCate="-1" topValue="8" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[猎头渠道明细]]></Name>
</TableData>
<CategoryName value="无"/>
</OneValueCDDefinition>
</ChartDefinition>
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
<Chart name="图表2" chartClass="com.fr.plugin.chart.vanchart.VanChart">
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
<![CDATA[猎头招聘员工职级分布（含06级以下）]]></O>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="80" foreground="-13421773"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="2"/>
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
<Attr enable="true" duration="4" followMouse="false" showMutiSeries="false" isCustom="true"/>
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
<FRFont name="微软雅黑" style="0" size="72"/>
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
<FillStyleName fillStyleName=""/>
<isCustomFillStyle isCustomFillStyle="true"/>
<ColorList>
<OColor colvalue="-3342328"/>
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
<Attr alignText="0">
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
<newLineColor lineColor="-5197648"/>
<AxisPosition value="2"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="88" foreground="-10066330"/>
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
</YAxisList>
<stackAndAxisCondition>
<ConditionCollection>
<DefaultAttr class="com.fr.chart.chartglyph.ConditionAttr">
<ConditionAttr name=""/>
</DefaultAttr>
</ConditionCollection>
</stackAndAxisCondition>
<VanChartColumnPlotAttr seriesOverlapPercent="20.0" categoryIntervalPercent="20.0" fixedWidth="false" columnWidth="0" filledWithImage="false" isBar="false"/>
</Plot>
<ChartDefinition>
<MoreNameCDDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="true"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[职级]]></Name>
</TableData>
<CategoryName value="ZHIJILY"/>
<ChartSummaryColumn name="OUNT" function="com.fr.data.util.function.NoneFunction" customName="人数"/>
</MoreNameCDDefinition>
</ChartDefinition>
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
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="1" size="80" foreground="-1"/>
<Background name="ColorBackground" color="-4259840"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
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
<BoundsAttr x="451" y="0" width="450" height="373"/>
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
<![CDATA[723900,1143000,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2880000,2880000,2880000,2880000,2880000,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" cs="5" s="0">
<O>
<![CDATA[主营辞职员工特征]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="1" s="1">
<O>
<![CDATA[离职职级分布]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1" s="1">
<PrivilegeControl/>
</C>
<C c="2" r="1" s="1">
<O>
<![CDATA[离职原因分布]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="1" s="1">
<PrivilegeControl/>
</C>
<C c="4" r="1" s="1">
<O>
<![CDATA[离职司龄分布]]></O>
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
<FRFont name="微软雅黑" style="0" size="80" foreground="-1"/>
<Background name="ColorBackground" color="-4259840"/>
<Border/>
</Style>
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
<BoundsAttr x="451" y="713" width="450" height="373"/>
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
<![CDATA[864000,0,0,0,864000,864000,864000,864000,864000,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[5791200,3733800,2743200,0,0,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="0" s="1">
<O t="DSColumn">
<Attributes dsName="猎-全" columnName="DESCR"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="1"/>
</C>
<C c="0" r="1" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1" s="0">
<O t="DSColumn">
<Attributes dsName="猎头级职" columnName="TREE_NODE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="0" r="2" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="2" s="0">
<O t="DSColumn">
<Attributes dsName="猎头级职" columnName="TREE_NODE2"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="0" r="3" s="0">
<O>
<![CDATA[是否达标]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="3" s="2">
<O>
<![CDATA[●]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[B9<IF(B7=0,-1,0.2)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.FRFontHighlightAction">
<FRFont name="微软雅黑" style="0" size="208" foreground="-4259840"/>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="4" s="0">
<O>
<![CDATA[06级及以上入职（猎头）]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="4" s="3">
<O t="DSColumn">
<Attributes dsName="猎-全" columnName="LTS"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="1"/>
</C>
<C c="0" r="5" s="0">
<O>
<![CDATA[06级及以上入职（全体）]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="5" s="3">
<O t="DSColumn">
<Attributes dsName="猎-全" columnName="QBS"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="1"/>
</C>
<C c="0" r="6" s="0">
<O>
<![CDATA[2018猎头使用率]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="6" s="4">
<O t="DSColumn">
<Attributes dsName="猎-全" columnName="LV"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="1"/>
</C>
<C c="0" r="7" s="0">
<O>
<![CDATA[2017猎头使用率]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="7" s="4">
<O t="DSColumn">
<Attributes dsName="猎-全" columnName="NCLV"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="1"/>
</C>
<C c="0" r="8" s="5">
<O>
<![CDATA[猎头使用优化率]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="8" s="6">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(B7=0,B8,if(B8 = B7, 0, 1-B7/B8))]]></Attributes>
</O>
<PrivilegeControl/>
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
<Style imageLayout="1">
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
<FRFont name="微软雅黑" style="0" size="72" foreground="-1"/>
<Background name="ColorBackground" color="-2949112"/>
<Border>
<Top style="1" color="-5197648"/>
<Bottom style="1" color="-5197648"/>
<Left style="1" color="-5197648"/>
<Right style="1" color="-5197648"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="208" foreground="-6697984"/>
<Background name="NullBackground"/>
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
<Bottom style="1" color="-5197648"/>
<Left style="1" color="-5197648"/>
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
<Left style="1" color="-5197648"/>
<Right style="1" color="-5197648"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="1" size="72"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-5197648"/>
<Bottom style="1" color="-5197648"/>
<Left style="1" color="-5197648"/>
<Right style="1" color="-5197648"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0.0%]]></Format>
<FRFont name="微软雅黑" style="1" size="72"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-5197648"/>
<Bottom style="1" color="-5197648"/>
<Left style="1" color="-5197648"/>
<Right style="1" color="-5197648"/>
</Border>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<isShared isshared="false"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="0" zoom="true" refresh="false" isUseHTML="false"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="901" height="258"/>
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
<BoundsAttr x="0" y="455" width="901" height="258"/>
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
<![CDATA[下级单位指标执行监控]]></O>
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
<![CDATA[#0]]></Format>
</DataSheet>
<DataProcessor class="com.fr.base.chart.chartdata.model.NormalDataModel"/>
<newPlotFillStyle>
<AttrFillStyle>
<AFStyle colorStyle="1"/>
<FillStyleName fillStyleName=""/>
<isCustomFillStyle isCustomFillStyle="true"/>
<ColorList>
<OColor colvalue="-11184811"/>
<OColor colvalue="-3670008"/>
<OColor colvalue="-2949112"/>
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
<newLineColor lineColor="-5197648"/>
<AxisPosition value="2"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="88" foreground="-10066330"/>
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
<FRFont name="微软雅黑" style="0" size="88" foreground="-10066330"/>
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
<HtmlLabel customText="function(){ return this.value+&quot;人&quot;;}" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
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
<![CDATA[#0]]></Format>
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
<newLineColor lineColor="-5197648"/>
<AxisPosition value="2"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="88" foreground="-10066330"/>
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
<FRFont name="微软雅黑" style="0" size="88" foreground="-10066330"/>
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
<Attr enable="true" duration="4" followMouse="false" showMutiSeries="true" isCustom="false"/>
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
<![CDATA[#0.0%]]></Format>
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
<Attr showLine="false" autoAdjust="true" position="1" isCustom="true"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="72"/>
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
<![CDATA[#0]]></Format>
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
<newLineColor lineColor="-5197648"/>
<AxisPosition value="2"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="88" foreground="-10066330"/>
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
<FRFont name="微软雅黑" style="0" size="88" foreground="-10066330"/>
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
<![CDATA[猎-全]]></Name>
</TableData>
<CategoryName value="DESCR"/>
<ChartSummaryColumn name="LV" function="com.fr.data.util.function.NoneFunction" customName="猎头使用率 "/>
</MoreNameCDDefinition>
</DefinitionMap>
<DefinitionMap key="column">
<MoreNameCDDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[猎-全]]></Name>
</TableData>
<CategoryName value="DESCR"/>
<ChartSummaryColumn name="FLTRS" function="com.fr.data.util.function.NoneFunction" customName="06级及以上入职（非猎头）"/>
<ChartSummaryColumn name="LTS" function="com.fr.data.util.function.NoneFunction" customName="06级及以上入职（猎头）"/>
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
<BoundsAttr x="0" y="0" width="901" height="341"/>
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
<BoundsAttr x="0" y="114" width="901" height="341"/>
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
<![CDATA[/*var url = FR.cjkEncode("/WebReport/ReportServer?formlet=HXXF_HR%2FHR_QUIT%2FManagement_monitoring.frm&dwmc=''"); FR.doHyperlinkByGet({url:url,title:'Management_monitoring',target:'_self'});  */
location=FR.cjkEncode("/WebReport/ReportServer?formlet=HXXF_HR/HR_QUIT/Management_monitoring.frm&dwmc=")+dwmc1+"&username="+ username1;  ]]></Content>
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
<BoundsAttr x="0" y="0" width="81" height="24"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="label0"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<widgetValue/>
<LabelAttr verticalcenter="true" textalign="0" autoline="true"/>
<FRFont name="SimSun" style="0" size="72"/>
<border style="0" color="-723724"/>
</InnerWidget>
<BoundsAttr x="241" y="0" width="561" height="24"/>
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
<![CDATA[1440000,1440000,722880,722880,722880,722880,722880,722880,722880,722880,722880,722880,722880,722880,722880,722880,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2362200,2743200,2743200,2743200,2743200,0,3810000,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="1" cs="7" s="0">
<O>
<![CDATA[本单位各月指标执行情况]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="2" s="1">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=YEAR($date_time)]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="2" s="1">
<O>
<![CDATA[06级及以上\\n猎头使用人数]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="2" s="1">
<O>
<![CDATA[06级及以上\\n入职总人数]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="2" s="1">
<O>
<![CDATA[猎头使用率]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="2" s="1">
<O>
<![CDATA[环比]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="2" s="1">
<O>
<![CDATA[同比]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="2" s="1">
<O>
<![CDATA[与2017年猎头使用率\\n同比]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="3">
<O>
<![CDATA[17年全年]]></O>
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
<C c="1" r="3">
<O t="DSColumn">
<Attributes dsName="各月执行情况" columnName="LTNC"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="2" r="3">
<O t="DSColumn">
<Attributes dsName="各月执行情况" columnName="QBNC"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="3" r="3">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(LEN(C4) = 0, 0, B4 / C4)]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="3" s="2">
<O>
<![CDATA[-]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="3" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="3" s="2">
<O>
<![CDATA[-]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="4" s="1">
<O>
<![CDATA[1月]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="4" s="1">
<O t="DSColumn">
<Attributes dsName="各月执行情况" columnName="LTONE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="2" r="4" s="1">
<O t="DSColumn">
<Attributes dsName="各月执行情况" columnName="QBONE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="3" r="4" s="3">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(LEN(C5) = 0, 0, B5 / C5)]]></Attributes>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="4" r="4" s="3">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(D5 = 0,"-",IF(D4=0,D5,(D5-D4)/D4))]]></Attributes>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="5" r="4" s="4">
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="6" r="4" s="3">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(LEN(E5)=0,"",IF(D4=0,0,(D5-D4)/D4))]]></Attributes>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="0" r="5" s="1">
<O>
<![CDATA[2月]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="5" s="1">
<O t="DSColumn">
<Attributes dsName="各月执行情况" columnName="LTTWO"/>
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
<C c="2" r="5" s="1">
<O t="DSColumn">
<Attributes dsName="各月执行情况" columnName="QBTWO"/>
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
<C c="3" r="5" s="3">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(LEN(C6) = 0, 0, B6 / C6)]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
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
<C c="4" r="5" s="3">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(D6 = 0,"-",IF(D5=0,D6,(D6-D5)/D5))]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
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
<C c="5" r="5" s="4">
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="6" r="5" s="3">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(LEN(E6)=0,"",IF(D4=0,0,(D6-D4)/D4))]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
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
<C c="0" r="6" s="1">
<O>
<![CDATA[3月]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="6" s="1">
<O t="DSColumn">
<Attributes dsName="各月执行情况" columnName="LTTHREE"/>
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
<C c="2" r="6" s="1">
<O t="DSColumn">
<Attributes dsName="各月执行情况" columnName="QBTHREE"/>
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
<C c="3" r="6" s="3">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(LEN(C7) = 0, 0, B7 / C7)]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
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
<C c="4" r="6" s="3">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(D7 = 0,"-",IF(D6=0,D7,(D7-D6)/D6))]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
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
<C c="5" r="6" s="4">
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="6" r="6" s="3">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(LEN(E7)=0,"",IF(D4=0,0,(D7-D4)/D4))]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
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
<C c="0" r="7" s="1">
<O>
<![CDATA[4月]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="7" s="1">
<O t="DSColumn">
<Attributes dsName="各月执行情况" columnName="LTFOUR"/>
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
<C c="2" r="7" s="1">
<O t="DSColumn">
<Attributes dsName="各月执行情况" columnName="QBFOUR"/>
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
<C c="3" r="7" s="3">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(LEN(C8) = 0, 0, B8 / C8)]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
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
<C c="4" r="7" s="3">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(D8 = 0,"-",IF(D7=0,D8,(D8-D7)/D7))]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
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
<C c="5" r="7" s="4">
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="6" r="7" s="3">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(LEN(E8)=0,"",IF(D4=0,0,(D8-D4)/D4))]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
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
<C c="0" r="8" s="1">
<O>
<![CDATA[5月]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="8" s="1">
<O t="DSColumn">
<Attributes dsName="各月执行情况" columnName="LTFIVE"/>
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
<![CDATA[MONTH(NOW())<5]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="2" r="8" s="1">
<O t="DSColumn">
<Attributes dsName="各月执行情况" columnName="QBFIVE"/>
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
<![CDATA[MONTH(NOW())<5]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="3" r="8" s="3">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(LEN(C9) = 0, 0, B9 / C9)]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<5]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="4" r="8" s="3">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(D9 = 0,"-",IF(D8=0,D9,(D9-D8)/D8))]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<5]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="5" r="8" s="4">
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="6" r="8" s="3">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(LEN(E9)=0,"",IF(D4=0,0,(D9-D4)/D4))]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MONTH(NOW())<5]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="9" s="1">
<O>
<![CDATA[6月]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="9" s="1">
<O t="DSColumn">
<Attributes dsName="各月执行情况" columnName="LTSIX"/>
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
<C c="2" r="9" s="1">
<O t="DSColumn">
<Attributes dsName="各月执行情况" columnName="QBSIX"/>
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
<C c="3" r="9" s="3">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(LEN(C10) = 0, 0, B10 / C10)]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
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
<C c="4" r="9" s="3">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(D10 = 0,"-",IF(D9=0,D10,(D10-D9)/D9))]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
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
<C c="5" r="9" s="4">
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="6" r="9" s="3">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(LEN(E10)=0,"",IF(D4=0,0,(D10-D4)/D4))]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
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
<C c="0" r="10" s="1">
<O>
<![CDATA[7月]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="10" s="1">
<O t="DSColumn">
<Attributes dsName="各月执行情况" columnName="LTSEVEN"/>
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
<C c="2" r="10" s="1">
<O t="DSColumn">
<Attributes dsName="各月执行情况" columnName="QBSEVEN"/>
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
<C c="3" r="10" s="3">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(LEN(C11) = 0, 0, B11 / C11)]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
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
<C c="4" r="10" s="3">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(D11 = 0,"-",IF(D10=0,D11,(D11-D10)/D10))]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
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
<C c="5" r="10" s="4">
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="6" r="10" s="3">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(LEN(E11)=0,"",IF(D4=0,0,(D11-D4)/D4))]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
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
<C c="0" r="11" s="1">
<O>
<![CDATA[8月]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="11" s="1">
<O t="DSColumn">
<Attributes dsName="各月执行情况" columnName="LTEIGHT"/>
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
<C c="2" r="11" s="1">
<O t="DSColumn">
<Attributes dsName="各月执行情况" columnName="QBEIGHT"/>
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
<C c="3" r="11" s="3">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(LEN(C12) = 0, 0, B12 / C12)]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
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
<C c="4" r="11" s="3">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(D12 = 0,"-",IF(D11=0,D12,(D12-D11)/D11))]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
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
<C c="5" r="11" s="4">
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="6" r="11" s="3">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(LEN(E12)=0,"",IF(D4=0,0,(D12-D4)/D4))]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
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
<C c="0" r="12" s="1">
<O>
<![CDATA[9月]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="12" s="1">
<O t="DSColumn">
<Attributes dsName="各月执行情况" columnName="LTNINE"/>
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
<C c="2" r="12" s="1">
<O t="DSColumn">
<Attributes dsName="各月执行情况" columnName="QBNINE"/>
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
<C c="3" r="12" s="3">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(LEN(C13) = 0, 0, B13 / C13)]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
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
<C c="4" r="12" s="3">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(D13 = 0,"-",IF(D12=0,D13,(D13-D12)/D12))]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
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
<C c="5" r="12" s="4">
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="6" r="12" s="3">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(LEN(E13)=0,"",IF(D4=0,0,(D13-D4)/D4))]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
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
<C c="0" r="13" s="1">
<O>
<![CDATA[10月]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="13" s="1">
<O t="DSColumn">
<Attributes dsName="各月执行情况" columnName="LTTEN"/>
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
<C c="2" r="13" s="1">
<O t="DSColumn">
<Attributes dsName="各月执行情况" columnName="QBTEN"/>
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
<C c="3" r="13" s="3">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(LEN(C14) = 0, 0, B14 / C14)]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
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
<C c="4" r="13" s="3">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(D14 = 0,"-",IF(D13=0,D14,(D14-D13)/D13))]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
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
<C c="5" r="13" s="4">
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="6" r="13" s="3">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(LEN(E14)=0,"",IF(D4=0,0,(D14-D4)/D4))]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
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
<C c="0" r="14" s="1">
<O>
<![CDATA[11月]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="14" s="1">
<O t="DSColumn">
<Attributes dsName="各月执行情况" columnName="LTELEVEN"/>
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
<C c="2" r="14" s="1">
<O t="DSColumn">
<Attributes dsName="各月执行情况" columnName="QBELEVEN"/>
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
<C c="3" r="14" s="3">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(LEN(C15) = 0, 0, B15 / C15)]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
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
<C c="4" r="14" s="3">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(D15 = 0,"-",IF(D14=0,D15,(D15-D14)/D14))]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
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
<C c="5" r="14" s="4">
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="6" r="14" s="3">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(LEN(E15)=0,"",IF(D4=0,0,(D15-D4)/D4))]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
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
<C c="0" r="15" s="1">
<O>
<![CDATA[12月]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="15" s="1">
<O t="DSColumn">
<Attributes dsName="各月执行情况" columnName="LTTWELVE"/>
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
<C c="2" r="15" s="1">
<O t="DSColumn">
<Attributes dsName="各月执行情况" columnName="QBTWELVE"/>
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
<C c="3" r="15" s="3">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(LEN(C16) = 0, 0, B16 / C16)]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
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
<C c="4" r="15" s="3">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(D16 = 0,"-",IF(D15=0,D16,(D16-D15)/D15))]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
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
<C c="5" r="15" s="4">
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="6" r="15" s="3">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(LEN(E16)=0,"",IF(D4=0,0,(D16-D4)/D4))]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
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
</CellElementList>
<ReportAttrSet>
<ReportSettings headerHeight="0" footerHeight="0">
<PaperSetting/>
</ReportSettings>
</ReportAttrSet>
</FormElementCase>
<StyleList>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="1" size="80" foreground="-1"/>
<Background name="ColorBackground" color="-4259840"/>
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
<Bottom style="1" color="-5197648"/>
<Left style="1" color="-5197648"/>
<Right style="1" color="-5197648"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0.0%]]></Format>
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-5197648"/>
<Bottom style="1" color="-5197648"/>
<Left style="1" color="-5197648"/>
<Right style="1" color="-5197648"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-5197648"/>
<Bottom style="1" color="-5197648"/>
<Left style="1" color="-5197648"/>
<Right style="1" color="-5197648"/>
</Border>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<isShared isshared="false"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="0" zoom="true" refresh="false" isUseHTML="false"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="451" height="373"/>
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
<BoundsAttr x="0" y="713" width="451" height="373"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="button0"/>
<Widget widgetName="button2"/>
<Widget widgetName="button1"/>
<Widget widgetName="mc1"/>
<Widget widgetName="label0"/>
<Widget widgetName="button3"/>
<Widget widgetName="button4"/>
<Widget widgetName="label1"/>
<Widget widgetName="report3"/>
<Widget widgetName="chart0"/>
<Widget widgetName="report1"/>
<Widget widgetName="report0"/>
<Widget widgetName="report2"/>
<Widget widgetName="report4"/>
</MobileWidgetList>
<WidgetZoomAttr compState="1"/>
<AppRelayout appRelayout="true"/>
<Size width="901" height="1186"/>
<ResolutionScalingAttr percent="0.9"/>
<BodyLayoutType type="0"/>
</Center>
</Layout>
<DesignerVersion DesignerVersion="IAA"/>
<PreviewType PreviewType="0"/>
<TemplateID TemplateID="0e9443a5-7aca-4521-9457-4c2ebaf5f478"/>
</Form>
