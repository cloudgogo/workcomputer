<?xml version="1.0" encoding="UTF-8"?>
<Form xmlVersion="20170715" releaseVersion="8.0.0">
<TableDataMap>
<TableData name="1lishi" class="com.fr.data.impl.DBTableData">
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
<![CDATA[FRDemo]]></DatabaseName>
</Connection>
<Query>
<![CDATA[SELECT * FROM EMPLOYEE
where empid<1007
and empid>=1001

${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} ]]></Query>
</TableData>
<TableData name="2ZY" class="com.fr.data.impl.DBTableData">
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
<![CDATA[WITH T AS
(
SELECT 
(SELECT COUNT(1)  AS HZS
FROM ODM_HR_YGTZ
WHERE 1=1
${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}) HZ,--总人数
(SELECT COUNT(CASE WHEN ISZHUYING='主营' THEN YGID ELSE NULL END)
FROM ODM_HR_YGTZ
WHERE 1=1
${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}) ZY,--主营人数
(SELECT COUNT(1)-COUNT(CASE WHEN YGID  IN ('10027979','10034523') THEN YGID END)  FROM ODM_HR_YGTZ WHERE iszhuying = '主营'  
AND BUMEN NOT LIKE '%融资中心%' 
AND BUMEN NOT LIKE '%财务管理中心%'
${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}) ZYRSBHCW--主营不含财务 
FROM DUAL
)
SELECT HZ,ZY,HZ-ZY FZY,ZYRSBHCW FROM T   

]]></Query>
</TableData>
<TableData name="3FZY" class="com.fr.data.impl.DBTableData">
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
<![CDATA[SELECT COUNT(1)  AS ZY
FROM ODM_HR_YGTZ
WHERE ISZHUYING LIKE '%非主营%'

${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} ]]></Query>
</TableData>
<TableData name="4GB" class="com.fr.data.impl.DBTableData">
<Parameters>
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
<![CDATA[SELECT 
COUNT(CASE WHEN 1=1 THEN YGID  END) AS HZ,
COUNT(CASE WHEN YGFENLEI LIKE '%干部%' THEN YGID  END)  AS GB,
COUNT(CASE WHEN ISCQT='是' and iszhuying='主营'  THEN YGID  END)  AS CQT
FROM ODM_HR_YGTZ
WHERE 1=1

${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} ]]></Query>
</TableData>
<TableData name="1HZS" class="com.fr.data.impl.DBTableData">
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
<![CDATA[SELECT COUNT(1)  AS HZS
FROM ODM_HR_YGTZ
WHERE 1=1

${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} ]]></Query>
</TableData>
<TableData name="5PJNL" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="lab1"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="DWMC"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="LAB"/>
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
<![CDATA[SELECT  REPLACE(TO_CHAR(ROUND(SUM((SYSDATE-CSDATE)/365)/COUNT(YGID),1),'9990.0'),' ','') AS PJNL
FROM ODM_HR_YGTZ
where 1=1
${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} 
${SWITCH(LAB,'',"",'主营(含财务)',"AND ISZHUYING = '主营'",'非主营'," AND ISZHUYING <> '主营'",'主营(不含财务)'," and iszhuying = '主营' AND BUMEN NOT LIKE '%融资中心%' 
AND BUMEN NOT LIKE '%财务管理中心%'  AND YGID NOT IN ('10027979','10034523')")}
${if(len(lab1)=0,"and 1=1",if(lab1="干部","and YGFENLEI= '干部' ","and ISCQT='是' and ISZHUYING='主营'"))}
]]></Query>
</TableData>
<TableData name="6BK" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="lab1"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="DWMC"/>
<O>
<![CDATA[HX_HEAD]]></O>
</Parameter>
<Parameter>
<Attributes name="LAB"/>
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
REPLACE(TO_CHAR(ROUND(COUNT(CASE WHEN  XUELIFENLEI  LIKE '%本科%' or XUELIFENLEI  LIKE '%硕士%' or XUELIFENLEI  LIKE '%博士%' THEN YGID END)/COUNT(CASE WHEN 1=1 THEN YGID END)*100,1),'9990.0'),' ','')||'%' AS BK
FROM ODM_HR_YGTZ
where 1=1
AND zhiji NOT LIKE '99%'
${SWITCH(LAB,'',"",'主营(含财务)',"AND ISZHUYING = '主营'",'非主营'," AND ISZHUYING <> '主营'",'主营(不含财务)'," and iszhuying = '主营' AND BUMEN NOT LIKE '%财务管理中心%' AND BUMEN NOT LIKE '%融资中心%'     AND YGID NOT IN ('10027979','10034523')")}
${if(len(lab1)=0,"and 1=1",if(lab1="干部","and YGFENLEI= '干部' ","and ISCQT='是' and ISZHUYING='主营'"))}
${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} 
]]></Query>
</TableData>
<TableData name="7PJZJ" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="lab1"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="DWMC"/>
<O>
<![CDATA[HX_HEAD]]></O>
</Parameter>
<Parameter>
<Attributes name="LAB"/>
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
REPLACE(TO_CHAR(ROUND(SUM(REPLACE(ZHIJI,'级',''))/COUNT(CASE WHEN 1=1 THEN YGID END),1),'9990.0'),' ','') AS PJZJ
FROM  ODM_HR_YGTZ
WHERE ZHIJI<>'级'
${SWITCH(LAB,'',"",'主营(含财务)',"AND ISZHUYING = '主营'",'非主营'," AND ISZHUYING <> '主营'",'主营(不含财务)'," and iszhuying = '主营' AND BUMEN NOT LIKE '%财务管理中心%' AND BUMEN NOT LIKE '%融资中心%' AND   AND YGID NOT IN ('10027979','10034523')")}
${if(len(lab1)=0,"and 1=1",if(lab1="干部","and YGFENLEI= '干部' ","and ISCQT='是' and ISZHUYING='主营'"))}
${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} ]]></Query>
</TableData>
<TableData name="8PJSL" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="lab1"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="DWMC"/>
<O>
<![CDATA[HX_HEAD]]></O>
</Parameter>
<Parameter>
<Attributes name="LAB"/>
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
<![CDATA[SELECT  ROUND(SUM(SILING)/COUNT(YGID),1) AS PJSL
FROM ODM_HR_YGTZ
where 1=1
${SWITCH(LAB,'',"",'主营(含财务)',"AND ISZHUYING = '主营'",'非主营'," AND ISZHUYING <> '主营'",'主营(不含财务)'," and iszhuying = '主营' AND BUMEN NOT LIKE '%财务管理中心%' AND BUMEN NOT LIKE '%融资中心%'  AND YGID NOT IN ('10027979','10034523')
")}
${if(len(lab1)=0,"and 1=1",if(lab1="干部","and YGFENLEI= '干部' ","and ISCQT='是' and ISZHUYING='主营'"))}

${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} 
]]></Query>
</TableData>
<TableData name="9ZJQJ" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="lab1"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="DWMC"/>
<O>
<![CDATA[HX_HEAD]]></O>
</Parameter>
<Parameter>
<Attributes name="LAB"/>
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
<![CDATA[SELECT * FROM 

(
SELECT 
     ZHIJI AS ZJ,
     COUNT(YGID) AS  ZJQJ
   FROM ODM_HR_YGTZ
WHERE ZHIJI <'11级'
${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} 
${SWITCH(LAB,'',"",'主营(含财务)',"AND ISZHUYING = '主营'",'非主营'," AND ISZHUYING <> '主营'",'主营(不含财务)'," and iszhuying = '主营' AND BUMEN NOT LIKE '%财务管理中心%' AND BUMEN NOT LIKE '%融资中心%' AND CQTCDLYEAR<>'2018' AND YGID NOT IN ('10027979','10034523')
")}
${if(len(lab1)=0,"and 1=1",if(lab1="干部","and YGFENLEI= '干部' ","and ISCQT='是' and ISZHUYING='主营'"))}
${if(len(DWMC)=0,""," and BUMENID in(
SELECT TREE_NODE
FROM ODM_HR_DW
  start with TREE_NODE ='"+DWMC+"' connect by  PARENT_NODE   =  prior TREE_NODE)")}
GROUP BY ZHIJI
UNION ALL
SELECT 
    '11级及以上' AS  ZJ ,
     COUNT(YGID) AS  ZJQJ
   FROM ODM_HR_YGTZ
WHERE ZHIJI >='11级'
and ZHIJI <>'99级'
${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} 
${SWITCH(LAB,'',"",'主营(含财务)',"AND ISZHUYING = '主营'",'非主营'," AND ISZHUYING <> '主营'",'主营(不含财务)'," and iszhuying = '主营' AND BUMEN NOT LIKE '%财务管理中心%' AND BUMEN NOT LIKE '%融资中心%'  AND YGID NOT IN ('10027979','10034523')
")}
${if(len(lab1)=0,"and 1=1",if(lab1="干部","and YGFENLEI= '干部' ","and ISCQT='是' and ISZHUYING='主营'"))}

${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} 
)
where ZJQJ<>0
ORDER BY ZJ asc]]></Query>
</TableData>
<TableData name="10SLQL" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="lab1"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="DWMC"/>
<O>
<![CDATA[HX_HEAD]]></O>
</Parameter>
<Parameter>
<Attributes name="LAB"/>
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
<![CDATA[select  
        count (ygid) RS,
       descr AS DANWEI
  from (select T1.ISCQT,T1.ISZHUYING,T1.YGFENLEI,t1.ygid, t2.descr
          from odm_hr_YGTZ t1, odm_hr_dw t2
         where t1.tree_node_id like '%' || t2.tree_node || '%' 
 ${if(len(DWMC)=0," AND   PARENT_NODE ='HX_HEAD' ","AND PARENT_NODE ='"+DWMC+"'" )}--参数 
${SWITCH(LAB,'',"",'主营(含财务)',"AND T1.ISZHUYING = '主营'",'非主营'," AND T1.ISZHUYING <> '主营'",'主营(不含财务)'," and T1.iszhuying = '主营' AND BUMEN NOT LIKE '%财务管理中心%' AND BUMEN NOT LIKE '%融资中心%'  AND YGID NOT IN ('10027979','10034523')
")}
${if(len(lab1)=0,"and 1=1",if(lab1="干部","and T1.YGFENLEI= '干部' ","and T1.ISCQT='是' and T1.ISZHUYING='主营'"))}   
 UNION

select T1.ISCQT,T1.ISZHUYING,T1.YGFENLEI,t1.ygid, t2.descr
          from odm_hr_YGTZ t1, odm_hr_dw t2
         where t1.tree_node_id like '%' || t2.tree_node || '%' 
 ${if(len(DWMC)=0," AND   PARENT_NODE ='HX_HEAD' ","AND BUMENID ='"+DWMC+"'" )}--参数 
 ${SWITCH(LAB,'',"",'主营(含财务)',"AND T1.ISZHUYING = '主营'",'非主营'," AND T1.ISZHUYING <> '主营'",'主营(不含财务)'," and T1.iszhuying = '主营' AND BUMEN NOT LIKE '%财务管理中心%' AND BUMEN NOT LIKE '%融资中心%'    AND YGID NOT IN ('10027979','10034523')
")}
${if(len(lab1)=0,"and 1=1",if(lab1="干部","and T1.YGFENLEI= '干部' ","and T1.ISCQT='是' and T1.ISZHUYING='主营'"))}   
--AND BUMENID ='10001100001'
 and bumenid = t2.tree_node
               )
WHERE 1=1
         
 group by descr
order by RS desc
]]></Query>
</TableData>
<TableData name="11ZNXL" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="lab1"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="DWMC"/>
<O>
<![CDATA[HX_HEAD]]></O>
</Parameter>
<Parameter>
<Attributes name="LAB"/>
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
<![CDATA[SELECT ZHINENGXULIE,COUNT(YGID) AS RS
FROM ODM_HR_YGTZ
WHERE 1=1-- ZHIJI<>'99级'
 ${SWITCH(LAB,'',"",'主营(含财务)',"AND ISZHUYING = '主营'",'非主营'," AND ISZHUYING <> '主营'",'主营(不含财务)'," and iszhuying = '主营' AND BUMEN NOT LIKE '%财务管理中心%' AND BUMEN NOT LIKE '%融资中心%'  AND YGID NOT IN ('10027979','10034523')
")}
${if(len(lab1)=0,"and 1=1",if(lab1="干部","and YGFENLEI= '干部' ","and ISCQT='是' and ISZHUYING='主营'"))} 

${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} 

GROUP BY ZHINENGXULIE
ORDER BY ZHINENGXULIE]]></Query>
</TableData>
<TableData name="21BNRZ" class="com.fr.data.impl.DBTableData">
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
<![CDATA[SELECT 
COUNT( CASE WHEN 1=1 THEN '1'  END ) AS RZZS,
COUNT( CASE WHEN RZQUDAO='猎头' THEN '1'  END ) AS LT,
COUNT( CASE WHEN RZQUDAO='内部推荐' THEN '1' END ) AS NT,
COUNT( CASE WHEN RZQUDAO NOT IN ('内部推荐' ,'猎头') OR RZQUDAO IS NULL THEN '1'    END ) AS QT
FROM ODM_HR_RZTZ
WHERE TO_CHAR(RZDATE,'yyyy')=TO_CHAR(SYSDATE,'yyyy')
AND DQYGFENLEI = '干部'

${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} ]]></Query>
</TableData>
<TableData name="22LZ" class="com.fr.data.impl.DBTableData">
<Parameters>
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
<![CDATA[SELECT 
 COUNT(CASE WHEN 1=1 THEN '1' END) AS ZS,
 COUNT(CASE WHEN LZLEIXING='辞职' THEN '1' END) AS CZ,
 COUNT(CASE WHEN LZLEIXING='辞退' THEN '1' END ) AS CT
FROM ODM_HR_LZTZ
WHERE TO_CHAR(LZDATE,'yyyy')=TO_CHAR(SYSDATE,'yyyy')-1
AND YGFENLEI like '%干部%'
AND LZLEIXING in ('辞职','辞退')
AND ISZHUYING NOT LIKE '%实习生%'
AND YGLEIBIE NOT LIKE '%实习生%'

${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} ]]></Query>
</TableData>
<TableData name="31ZY" class="com.fr.data.impl.DBTableData">
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
<![CDATA[SELECT 
COUNT(CASE WHEN 1=1 THEN YGID END) AS HZS,
COUNT(CASE WHEN ISZHUYING='主营' THEN YGID END) AS ZY,
COUNT(CASE WHEN ISZHUYING LIKE '%非主营%' THEN YGID END) AS FZY,
CASE WHEN COUNT(CASE WHEN 1=1 THEN YGID END)=0 THEN 0 
ELSE COUNT(CASE WHEN ISZHUYING='主营' THEN YGID END)/COUNT(CASE WHEN 1=1 THEN YGID END) END  AS ZYZB,
CASE WHEN COUNT(CASE WHEN 1=1 THEN YGID END)=0 THEN 0 
ELSE COUNT(CASE WHEN ISZHUYING LIKE '%非主营%' THEN YGID END)/COUNT(CASE WHEN 1=1 THEN YGID END) END  AS FZYZB
FROM ODM_HR_RZTZ
WHERE TO_CHAR(RZDATE,'YYYYMM')=TO_CHAR(SYSDATE,'YYYYMM')

${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} ]]></Query>
</TableData>
<TableData name="41LIZHI" class="com.fr.data.impl.DBTableData">
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
<![CDATA[
SELECT 
COUNT(CASE WHEN 1=1 THEN YGID END) AS HZS,
COUNT(CASE WHEN ISZHUYING='主营' THEN YGID END) AS ZY,
COUNT(CASE WHEN ISZHUYING<>'主营' THEN YGID END) AS FZY,
COUNT(CASE WHEN ZHIJI IN ('05级','06级','07级','08级','09级','10级','11级','12级','13级','14级','15级','16级','17级','18级') THEN YGID END) AS GG,
COUNT(CASE WHEN ISCQT='是' THEN YGID END) AS CQT
FROM ODM_HR_LZTZ
WHERE 
TO_CHAR(LZDATE,'YYYYMM')=TO_CHAR(SYSDATE,'YYYYMM')
AND TO_CHAR(LZDATE,'YYYYMMDD')<TO_CHAR(SYSDATE,'YYYYMMDD')
AND ISZHUYING NOT LIKE '%实习生%'
AND YGLEIBIE NOT LIKE '%实习生%'

${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} 
]]></Query>
</TableData>
<TableData name="51CQT" class="com.fr.data.impl.DBTableData">
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
<![CDATA[SELECT *
FROM
(
SELECT 
count(YGID) AS renshu,
case WHEN xuexiao IS NULL THEN '其它'
	ELSE xuexiao END AS xuexiao
FROM ODM_HR_YGTZ
WHERE ISCQT='是'
AND ISzhuying= '主营'

${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} 

GROUP BY xuexiao
ORDER BY renshu DESC
)
WHERE ROWNUM <=5
]]></Query>
</TableData>
<TableData name="32RZZJ" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="lab2"/>
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
<![CDATA[SELECT
 CASE WHEN ZHIJI IN ('01级','02级') THEN '1-2' 
 WHEN ZHIJI IN ('03级') THEN '3'
 WHEN ZHIJI IN ('04级','05级') THEN '4-5'
 WHEN ZHIJI IN ('06级','07级') THEN '6-7'
 WHEN ZHIJI IN ('08级','09级','10级') THEN '8-10'
 WHEN ZHIJI >= '11级' THEN '11+'
END ZJ,
COUNT(
CASE WHEN ZHIJI IN ('01级','02级') THEN YGID 
 WHEN ZHIJI IN ('03级') THEN YGID
 WHEN ZHIJI IN ('04级','05级') THEN YGID
 WHEN ZHIJI IN ('06级','07级') THEN YGID
 WHEN ZHIJI IN ('08级','09级','10级') THEN YGID
 WHEN ZHIJI >= '11级' THEN YGID
END
) AS ZJQJ
FROM ODM_HR_RZTZ
WHERE ZHIJI<>'99级'
AND TO_CHAR(RZDATE,'yyyyMM')=TO_CHAR(SYSDATE,'yyyyMM')
 ${if(or(len(lab2)=0,lab2="1"),"and 1=1",if(lab2="主营","and ISZHUYING='主营'","and ISZHUYING<>'主营'"))}

${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} 
GROUP BY 
CASE WHEN ZHIJI IN ('01级','02级') THEN '1-2' 
 WHEN ZHIJI IN ('03级') THEN '3'
 WHEN ZHIJI IN ('04级','05级') THEN '4-5'
 WHEN ZHIJI IN ('06级','07级') THEN '6-7'
 WHEN ZHIJI IN ('08级','09级','10级') THEN '8-10'
 WHEN ZHIJI >= '11级' THEN '11+'
END 
ORDER BY 
CASE WHEN ZJ ='1-2' THEN '1' 
 WHEN ZJ ='3' THEN '2'
 WHEN ZJ ='4-5' THEN '3'
 WHEN ZJ ='6-7' THEN '4'
 WHEN ZJ ='8-10' THEN '5'
 WHEN ZJ ='11+' THEN '6'
END 
]]></Query>
</TableData>
<TableData name="42LZLX" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="lab3"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="lab4"/>
<O>
<![CDATA[]]></O>
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
<![CDATA[SELECT
 COUNT(1) AS RS,
LZLEIXING 
FROM ODM_HR_LZTZ
WHERE TO_CHAR(LZDATE,'YYYYMM')=TO_CHAR(SYSDATE,'YYYYMM')
AND TO_CHAR(LZDATE,'YYYYMMDD')<TO_CHAR(SYSDATE,'YYYYMMDD')
AND ISZHUYING NOT LIKE '%实习生%'
AND YGLEIBIE NOT LIKE '%实习生%'

${if(or(len(lab3)=0,lab3="1"),"and 1=1",if(lab3="主营","and ISZHUYING='主营'","and ISZHUYING<>'主营'"))}
${if(len(lab4)=0,"and 1=1",if(lab4="常青藤","and ISCQT='是'","and ZHIJI IN ('05级','06级','07级','08级','09级','10级','11级','12级','13级','14级','15级','16级','17级','18级')"))}

${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} 
GROUP BY LZLEIXING]]></Query>
</TableData>
<TableData name="43LZYY" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="lab3"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="lab4"/>
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
<![CDATA[SELECT
 COUNT(1) AS RS, 
CASE WHEN LZYUANYIN IS NULL THEN '其它' ELSE LZYUANYIN END AS LZYUANYIN
FROM ODM_HR_LZTZ
WHERE TO_CHAR(LZDATE,'YYYYMM')=TO_CHAR(SYSDATE,'YYYYMM')
AND TO_CHAR(LZDATE,'YYYYMMDD')<TO_CHAR(SYSDATE,'YYYYMMDD')
AND ISZHUYING NOT LIKE '%实习生%'
AND YGLEIBIE NOT LIKE '%实习生%'

${if(or(len(lab3)=0,lab3="1"),"and 1=1",if(lab3="主营","and ISZHUYING='主营'","and ISZHUYING<>'主营'"))}
${if(len(lab4)=0,"and 1=1",if(lab4="常青藤","and ISCQT='是'","and ZHIJI IN ('05级','06级','07级','08级','09级','10级','11级','12级','13级','14级','15级','16级','17级','18级')"))}

${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} 
GROUP BY LZYUANYIN
order by RS 
]]></Query>
</TableData>
<TableData name="33RZQD" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="lab2"/>
<O>
<![CDATA[]]></O>
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
<![CDATA[ select * from 
 
 (SELECT 
RZQUDAO,
RENSHU
  FROM
(
SELECT '校园招聘' AS RZQUDAO,
       COUNT(YGID) AS RENSHU
  FROM ODM_HR_RZTZ NA
 WHERE 1=1
   AND TO_CHAR(RZDATE,'YYYYMM')=TO_CHAR(SYSDATE,'YYYYMM')
   AND (RZQUDAO LIKE '校园招聘%' OR RZQUDAO = 'Campus recruitment')
 ${if(or(or(len(lab2)=0,lab2="1"),lab2="1"),"and 1=1",if(lab2="主营","and ISZHUYING='主营'","and ISZHUYING<>'主营'"))}

${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} 
UNION ALL 

SELECT '专场招聘会' AS RZQUDAO,
       COUNT(YGID) AS RENSHU
  FROM ODM_HR_RZTZ NA
 WHERE 1=1
   AND TO_CHAR(RZDATE,'YYYYMM')=TO_CHAR(SYSDATE,'YYYYMM')
   AND RZQUDAO LIKE '专场招聘会%'
${if(or(len(lab2)=0,lab2="1"),"and 1=1",if(lab2="主营","and ISZHUYING='主营'","and ISZHUYING<>'主营'"))}

${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} 
UNION ALL

SELECT '网络' AS RZQUDAO,
       COUNT(YGID) AS RENSHU
  FROM ODM_HR_RZTZ NA
 WHERE 1=1
   AND TO_CHAR(RZDATE,'YYYYMM')=TO_CHAR(SYSDATE,'YYYYMM')
   AND RZQUDAO in ('网络','智联','猎聘','51JOB','华夏幸福招聘网站','领英','其他外部网站','微信端','APP','Networking','Job portal')
   ${if(or(len(lab2)=0,lab2="1"),"and 1=1",if(lab2="主营","and ISZHUYING='主营'","and ISZHUYING<>'主营'"))}

${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} 
UNION ALL

SELECT '猎头' AS RZQUDAO,
       COUNT(YGID) AS RENSHU
  FROM ODM_HR_RZTZ NA
 WHERE 1=1
   AND TO_CHAR(RZDATE,'YYYYMM')=TO_CHAR(SYSDATE,'YYYYMM')
   AND RZQUDAO IN ('猎头','Headhunter')
   ${if(or(len(lab2)=0,lab2="1"),"and 1=1",if(lab2="主营","and ISZHUYING='主营'","and ISZHUYING<>'主营'"))}

${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} 


UNION ALL 

SELECT '内部推荐' AS RZQUDAO,
       COUNT(YGID) AS RENSHU
  FROM ODM_HR_RZTZ NA
 WHERE 1=1
   AND TO_CHAR(RZDATE,'YYYYMM')=TO_CHAR(SYSDATE,'YYYYMM')
   AND RZQUDAO = '内部推荐'
   ${if(or(len(lab2)=0,lab2="1"),"and 1=1",if(lab2="主营","and ISZHUYING='主营'","and ISZHUYING<>'主营'"))}

${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} 
ORDER BY RENSHU DESC
)
UNION ALL

SELECT '其他' AS RZQUDAO,
       COUNT(YGID) AS RENSHU
  FROM ODM_HR_RZTZ NA
 WHERE 1=1
   AND TO_CHAR(RZDATE,'YYYYMM')=TO_CHAR(SYSDATE,'YYYYMM')
   AND (RZQUDAO NOT IN ('校园招聘-MBA储备干部','校园招聘-非常青藤','校园招聘-常青藤','校园招聘-产动力','专场招聘会-猎聘','专场招聘会-智联',
                       '专场招聘会-51JOB','网络','智联','猎聘','51JOB','华夏幸福招聘网站','领英','其他外部网站','微信端','APP','猎头','猎聘','智联','内部推荐','Networking','Job portal','Headhunter','Campus recruitment')
        OR 
        RZQUDAO IS NULL)
    ${if(len(lab2)==0,"and 1=1",if(lab2="主营","and ISZHUYING='主营'","and ISZHUYING<>'主营'"))}       

${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} 
  )
  where RENSHU<>0
   ORDER BY RENSHU]]></Query>
</TableData>
<TableData name="23RZCQT" class="com.fr.data.impl.DBTableData">
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
<![CDATA[SELECT 
RZQUDAO,
RENSHU
  FROM
(
SELECT '校园招聘' AS RZQUDAO,
       COUNT(YGID) AS RENSHU
  FROM ODM_HR_YGTZ_NA NA
 WHERE 1=1
   AND RZDATE >= trunc(sysdate,'yy')
   AND YGFENLEI LIKE '%干部%'
   AND RZQUDAO LIKE '校园招聘%'

${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} 
UNION ALL 

SELECT '专场招聘会' AS RZQUDAO,
       COUNT(YGID) AS RENSHU
  FROM ODM_HR_YGTZ_NA NA
 WHERE 1=1
   AND RZDATE >= trunc(sysdate,'yy')
   AND YGFENLEI LIKE '%干部%'
   AND RZQUDAO LIKE '专场招聘会%'

${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} 

UNION ALL

SELECT '网络' AS RZQUDAO,
       COUNT(YGID) AS RENSHU
  FROM ODM_HR_YGTZ_NA NA
 WHERE 1=1
   AND RZDATE >= trunc(sysdate,'yy')
   AND YGFENLEI LIKE '%干部%'
   AND RZQUDAO = '网络'

${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} 

UNION ALL

SELECT '猎头' AS RZQUDAO,
       COUNT(YGID) AS RENSHU
  FROM ODM_HR_YGTZ_NA NA
 WHERE 1=1
   AND RZDATE >= trunc(sysdate,'yy')
   AND YGFENLEI LIKE '%干部%'
   AND RZQUDAO = '猎头'

${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} 
UNION ALL 

SELECT '猎聘' AS RZQUDAO,
       COUNT(YGID) AS RENSHU
  FROM ODM_HR_YGTZ_NA NA
 WHERE 1=1
   AND RZDATE >= trunc(sysdate,'yy')
   AND YGFENLEI LIKE '%干部%'
   AND RZQUDAO = '猎聘'

${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} 
UNION ALL 

SELECT '智联' AS RZQUDAO,
       COUNT(YGID) AS RENSHU
  FROM ODM_HR_YGTZ_NA NA
 WHERE 1=1
   AND RZDATE >= trunc(sysdate,'yy')
   AND YGFENLEI LIKE '%干部%'
   AND RZQUDAO = '智联'

${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} 
UNION ALL 

SELECT '内部推荐' AS RZQUDAO,
       COUNT(YGID) AS RENSHU
  FROM ODM_HR_YGTZ_NA NA
 WHERE 1=1
   AND RZDATE >= trunc(sysdate,'yy')
   AND YGFENLEI LIKE '%干部%'
   AND RZQUDAO = '内部推荐'

${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} 
ORDER BY RENSHU DESC
)
UNION ALL

SELECT '其他' AS RZQUDAO,
       COUNT(YGID) AS RENSHU
  FROM ODM_HR_YGTZ_NA NA
 WHERE 1=1
   AND RZDATE >= trunc(sysdate,'yy')
   AND YGFENLEI LIKE '%干部%'
   AND (RZQUDAO NOT IN ('校园招聘-MBA储备干部','校园招聘-非常青藤','校园招聘-常青藤','校园招聘-产动力','专场招聘会-猎聘','专场招聘会-智联',
                       '专场招聘会-51JOB','网络','猎头','猎聘','智联','内部推荐')
        OR 
        RZQUDAO IS NULL)

${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} 
  ]]></Query>
</TableData>
<TableData name="24LZCQT" class="com.fr.data.impl.DBTableData">
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
<![CDATA[SELECT
COUNT(1) AS RS,
CASE WHEN LZLEIXING IS NULL THEN '其他' ELSE LZLEIXING END AS  LZLEIXING
 FROM ODM_HR_LZTZ
WHERE YGFENLEI LIKE '%干部%'
AND TO_CHAR(LZDATE,'YYYY')= TO_CHAR(SYSDATE,'YYYY')

${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} 
GROUP BY LZLEIXING
]]></Query>
</TableData>
<TableData name="52ZHRS" class="com.fr.data.impl.DBTableData">
<Parameters>
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
<![CDATA[SELECT COUNT(1) AS ZRS
FROM ODM_HR_YGTZ
WHERE ISCQT='是'
AND  ISZHUYING='主营'

${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} ]]></Query>
</TableData>
<TableData name="53LZCQT" class="com.fr.data.impl.DBTableData">
<Parameters>
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
<![CDATA[SELECT COUNT(*) AS LZCQT 
FROM ODM_HR_LZTZ
WHERE ISCQT='是'
AND  ISZHUYING='主营'
AND ZHIJI<>'99级'
AND ISZHUYING NOT LIKE '%实习生%'
AND YGLEIBIE NOT LIKE '%实习生%'
${if(len(DWMC)=0,""," and TREE_NODE_ID LIKE'%"+DWMC+",%'")} ]]></Query>
</TableData>
<TableData name="54BCQT" class="com.fr.data.impl.DBTableData">
<Parameters>
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
<![CDATA[select * from (WITH 
A AS
(
SELECT
STATUS,
CQTCDLYEAR ,
renshu
FROM(
SELECT 
count(YGID) AS renshu,
'在职' AS STATUS,
CQTCDLYEAR
FROM ODM_HR_YGTZ
WHERE 1=1
AND ISCQT='是'
AND ISZHUYING  ='主营'
AND ISZHUYING NOT LIKE '%实习生%'
AND YGLEIBIE NOT LIKE '%实习生%'
${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} 

GROUP BY '在职',CQTCDLYEAR)
),

B AS(
SELECT
       STATUS,
       CQTCDLYEAR，
renshu
FROM(
SELECT 

count(DISTINCT YGID) AS renshu,
'离职' AS STATUS,
CQTCDLYEAR

FROM ODM_HR_LZTZ
WHERE 1=1
AND ISCQT='是'
AND ISZHUYING  ='主营'
AND ISZHUYING NOT LIKE '%实习生%'
AND YGLEIBIE NOT LIKE '%实习生%'
${if(len(DWMC)=0,""," and TREE_NODE_ID LIKE'%"+DWMC+",%'")}

GROUP BY '离职',CQTCDLYEAR)
)

SELECT *
FROM(
SELECT 
renshu, 
STATUS,
CQTCDLYEAR
  FROM A

  UNION 

SELECT B.RENSHU  AS RENSHU,
	  B.STATUS,
	  B.CQTCDLYEAR
  FROM B)
ORDER BY CQTCDLYEAR ASC)
ORDER BY 
(CASE WHEN STATUS='离职' THEN '1'
WHEN STATUS='在职' THEN '2'
END),CQTCDLYEAR ASC]]></Query>
</TableData>
<TableData name="1.1RS" class="com.fr.data.impl.DBTableData">
<Parameters>
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
<![CDATA[SELECT RZ-LZ AS RS,RZ,LZ
FROM
(SELECT 
COUNT(1) AS RZ
FROM ODM_HR_RZTZ
WHERE TO_CHAR(RZDATE,'YYYYMMDD')=TO_CHAR(SYSDATE-1,'YYYYMMDD')

${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} 
 ) T,
(SELECT 
COUNT(1) AS LZ
FROM ODM_HR_LZTZ
WHERE TO_CHAR(LZDATE,'YYYYMMDD')=TO_CHAR(SYSDATE-1,'YYYYMMDD')

${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} ) T1

]]></Query>
</TableData>
<TableData name="25SLFB" class="com.fr.data.impl.DBTableData">
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
<![CDATA[select * from 
(
SELECT 
count(YGID) AS renshu,
'0-0.5年' AS FENLEI
FROM ODM_HR_YGTZ
WHERE 
YGFENLEI = '干部'

AND SILING <= 0.5
${if(len(DWMC)=0,""," and BUMENID in(
SELECT TREE_NODE
FROM ODM_HR_DW
  start with TREE_NODE ='"+DWMC+"' connect by  PARENT_NODE   =  prior TREE_NODE)")}
UNION ALL
SELECT 
count(YGID) AS renshu,
'0.5-1年' AS FENLEI
FROM ODM_HR_YGTZ
WHERE 
YGFENLEI LIKE '%干部%'
AND SILING > 0.5
AND SILING <= 1
${if(len(DWMC)=0,""," and BUMENID in(
SELECT TREE_NODE
FROM ODM_HR_DW
  start with TREE_NODE ='"+DWMC+"' connect by  PARENT_NODE   =  prior TREE_NODE)")}
UNION ALL
SELECT 
count(YGID) AS renshu,
'1-3年' AS FENLEI
FROM ODM_HR_YGTZ
WHERE 
YGFENLEI LIKE '%干部%'
AND SILING > 1
AND SILING <= 3
${if(len(DWMC)=0,""," and BUMENID in(
SELECT TREE_NODE
FROM ODM_HR_DW
  start with TREE_NODE ='"+DWMC+"' connect by  PARENT_NODE   =  prior TREE_NODE)")}
UNION ALL
SELECT 
count(YGID) AS renshu,
'3-5年' AS FENLEI
FROM ODM_HR_YGTZ
WHERE 
YGFENLEI LIKE '%干部%'
AND SILING > 3
AND SILING <= 5

${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} 
UNION ALL
SELECT 
count(YGID) AS renshu,
'5-10年' AS FENLEI
FROM ODM_HR_YGTZ
WHERE 
YGFENLEI LIKE '%干部%'
AND SILING > 5
AND SILING <= 10

${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} 
UNION ALL
SELECT 
count(YGID) AS renshu,
'10年以上' AS FENLEI
FROM ODM_HR_YGTZ
WHERE 
YGFENLEI LIKE '%干部%'
AND SILING > 10
${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} 

  )
  where renshu<>0]]></Query>
</TableData>
<TableData name="26QJFB" class="com.fr.data.impl.DBTableData">
<Parameters>
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
<![CDATA[select * from
(
SELECT 
count(YGID)    AS renshu,
round(count(YGID)/ZS,3) AS ZB,
ZHIJI
FROM ODM_HR_YGTZ T, (
SELECT 
count(YGID) AS ZS
FROM ODM_HR_YGTZ
WHERE YGFENLEI='干部'

${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} 
) T1
WHERE 1=1
AND  YGFENLEI='干部'
AND  ZHIJI<'11级'

${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} 
 GROUP BY ZHIJI,ZS
UNION ALL
SELECT 
count(YGID)    AS renshu,
round(count(YGID)/ZS,3) AS ZB,
'11级及以上'
FROM ODM_HR_YGTZ T, (
SELECT 
count(YGID) AS ZS
FROM ODM_HR_YGTZ
WHERE YGFENLEI='干部'


${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} 
) T1
WHERE 1=1
AND  YGFENLEI='干部'
AND  ZHIJI>='11级'

${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} 
 GROUP BY ZS)
 ORDER BY renshu DESC
]]></Query>
</TableData>
<TableData name="0DESC" class="com.fr.data.impl.DBTableData">
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
<![CDATA[SELECT DESCR
FROM ODM_HR_DW
WHERE  TREE_NODE='${DWMC}'
]]></Query>
</TableData>
<TableData name="21ZZ" class="com.fr.data.impl.DBTableData">
<Parameters>
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
<![CDATA[SELECT COUNT(1) AS RZRS
 FROM  ODM_HR_YGTZ
WHERE 1=1--TO_CHAR(RZDATE,'yyyy')=TO_CHAR(SYSDATE,'yyyy')
AND YGFENLEI = '干部'

${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} ]]></Query>
</TableData>
<TableData name="22BNLZ" class="com.fr.data.impl.DBTableData">
<Parameters>
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
<![CDATA[SELECT 
 COUNT(CASE WHEN 1=1 THEN '1' END) AS ZS,
 COUNT(CASE WHEN LZLEIXING='辞职' THEN '1' END) AS CZ,
 COUNT(CASE WHEN LZLEIXING='辞退' THEN '1' END ) AS CT
FROM ODM_HR_LZTZ
WHERE TO_CHAR(LZDATE,'yyyy')=TO_CHAR(SYSDATE,'yyyy')
AND TO_CHAR(LZDATE,'YYYYMMDD')<TO_CHAR(SYSDATE,'YYYYMMDD')
AND YGFENLEI='干部'
AND LZLEIXING in ('辞职','辞退')
AND ISZHUYING NOT LIKE '%实习生%'
AND YGLEIBIE NOT LIKE '%实习生%'

${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} ]]></Query>
</TableData>
<TableData name="54BCQT_1" class="com.fr.data.impl.DBTableData">
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
<![CDATA[WITH 
A AS
(
SELECT
STATUS,
CQTCDLYEAR ,
renshu
FROM(
SELECT 
count(YGID) AS renshu,
'在职' AS STATUS,
CQTCDLYEAR
FROM ODM_HR_YGTZ
WHERE 1=1
AND ISCQT='是'
AND ISZHUYING  ='主营'
AND ISZHUYING NOT LIKE '%实习生%'
AND YGLEIBIE NOT LIKE '%实习生%'
${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} 

GROUP BY '在职',CQTCDLYEAR)
),

B AS(
SELECT
       STATUS,
       CQTCDLYEAR，
renshu
FROM(
SELECT 

count(YGID) AS renshu,
'离职' AS STATUS,
CQTCDLYEAR

FROM ODM_HR_LZTZ
WHERE 1=1
AND ISCQT='是'
AND ISZHUYING  ='主营'
AND ISZHUYING NOT LIKE '%实习生%'
AND YGLEIBIE NOT LIKE '%实习生%'
--AND CQTCDLYEAR = '2011'

${if(len(DWMC)=0,""," and TREE_NODE_ID LIKE'%"+DWMC+",%'")}

GROUP BY '离职',CQTCDLYEAR)
)

SELECT A.CQTCDLYEAR,A.RENSHU / (A.RENSHU + NVL(B.RENSHU,0)) AS zhanbi
  FROM A
  LEFT JOIN B
  ON A.CQTCDLYEAR = B.CQTCDLYEAR]]></Query>
</TableData>
<TableData name="31YZY" class="com.fr.data.impl.DBTableData">
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
<![CDATA[SELECT 
COUNT(CASE WHEN 1=1 THEN YGID END) AS HZS,
COUNT(CASE WHEN ISZHUYING='主营' THEN YGID END) AS ZY,
COUNT(CASE WHEN ISZHUYING LIKE '%非主营%' THEN YGID END) AS FZY,
CASE WHEN COUNT(CASE WHEN 1=1 THEN YGID END)=0 THEN 0 
ELSE COUNT(CASE WHEN ISZHUYING='主营' THEN YGID END)/COUNT(CASE WHEN 1=1 THEN YGID END) END  AS ZYZB,
CASE WHEN COUNT(CASE WHEN 1=1 THEN YGID END)=0 THEN 0 
ELSE COUNT(CASE WHEN ISZHUYING LIKE '%非主营%' THEN YGID END)/COUNT(CASE WHEN 1=1 THEN YGID END) END  AS FZYZB
FROM ODM_HR_RZTZ
WHERE TO_CHAR(RZDATE,'YYYY')=TO_CHAR(SYSDATE,'YYYY')

${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} ]]></Query>
</TableData>
<TableData name="32YRZZJ" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="DWMC"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="LAB2_Y"/>
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
 CASE WHEN ZHIJI IN ('01级','02级') THEN '1-2' 
 WHEN ZHIJI IN ('03级') THEN '3'
 WHEN ZHIJI IN ('04级','05级') THEN '4-5'
 WHEN ZHIJI IN ('06级','07级') THEN '6-7'
 WHEN ZHIJI IN ('08级','09级','10级') THEN '8-10'
 WHEN ZHIJI >= '11级' THEN '11+'
END ZJ,
COUNT(
CASE WHEN ZHIJI IN ('01级','02级') THEN YGID 
 WHEN ZHIJI IN ('03级') THEN YGID
 WHEN ZHIJI IN ('04级','05级') THEN YGID
 WHEN ZHIJI IN ('06级','07级') THEN YGID
 WHEN ZHIJI IN ('08级','09级','10级') THEN YGID
 WHEN ZHIJI >= '11级' THEN YGID
END
) AS ZJQJ
FROM ODM_HR_RZTZ
WHERE ZHIJI<>'99级'
AND TO_CHAR(RZDATE,'yyyy')=TO_CHAR(SYSDATE,'yyyy')
 ${if(or(len(LAB2_Y)=0,LAB2_Y="1"),"and 1=1",if(LAB2_Y="主营","and ISZHUYING='主营'","and ISZHUYING<>'主营'"))}

${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} 
GROUP BY 
CASE WHEN ZHIJI IN ('01级','02级') THEN '1-2' 
 WHEN ZHIJI IN ('03级') THEN '3'
 WHEN ZHIJI IN ('04级','05级') THEN '4-5'
 WHEN ZHIJI IN ('06级','07级') THEN '6-7'
 WHEN ZHIJI IN ('08级','09级','10级') THEN '8-10'
 WHEN ZHIJI >= '11级' THEN '11+'
END 
ORDER BY 
CASE WHEN ZJ ='1-2' THEN '1' 
 WHEN ZJ ='3' THEN '2'
 WHEN ZJ ='4-5' THEN '3'
 WHEN ZJ ='6-7' THEN '4'
 WHEN ZJ ='8-10' THEN '5'
 WHEN ZJ ='11+' THEN '6'
END 
]]></Query>
</TableData>
<TableData name="33YRZQD" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="DWMC"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="LAB2_Y"/>
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
<![CDATA[ select * from 
 
 (SELECT 
RZQUDAO,
RENSHU
  FROM
(
SELECT '校园招聘' AS RZQUDAO,
       COUNT(YGID) AS RENSHU
  FROM ODM_HR_RZTZ NA
 WHERE 1=1
   AND TO_CHAR(RZDATE,'YYYY')=TO_CHAR(SYSDATE,'YYYY')
   AND (RZQUDAO LIKE '校园招聘%' OR RZQUDAO = 'Campus recruitment')
 ${if(or(or(len(LAB2_Y)=0,LAB2_Y="1"),LAB2_Y="1"),"and 1=1",if(LAB2_Y="主营","and ISZHUYING='主营'","and ISZHUYING<>'主营'"))}

${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} 
UNION ALL 

SELECT '专场招聘会' AS RZQUDAO,
       COUNT(YGID) AS RENSHU
  FROM ODM_HR_RZTZ NA
 WHERE 1=1
   AND TO_CHAR(RZDATE,'YYYY')=TO_CHAR(SYSDATE,'YYYY')
   AND RZQUDAO LIKE '专场招聘会%'
${if(or(len(LAB2_Y)=0,LAB2_Y="1"),"and 1=1",if(LAB2_Y="主营","and ISZHUYING='主营'","and ISZHUYING<>'主营'"))}

${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} 
UNION ALL

SELECT '网络' AS RZQUDAO,
       COUNT(YGID) AS RENSHU
  FROM ODM_HR_RZTZ NA
 WHERE 1=1
   AND TO_CHAR(RZDATE,'YYYY')=TO_CHAR(SYSDATE,'YYYY')
   AND RZQUDAO in ('网络','智联','猎聘','51JOB','华夏幸福招聘网站','领英','其他外部网站','微信端','APP','Networking','Job portal')
   ${if(or(len(LAB2_Y)=0,LAB2_Y="1"),"and 1=1",if(LAB2_Y="主营","and ISZHUYING='主营'","and ISZHUYING<>'主营'"))}

${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} 
UNION ALL

SELECT '猎头' AS RZQUDAO,
       COUNT(YGID) AS RENSHU
  FROM ODM_HR_RZTZ NA
 WHERE 1=1
   AND TO_CHAR(RZDATE,'YYYY')=TO_CHAR(SYSDATE,'YYYY')
   AND RZQUDAO IN ('猎头','Headhunter')
   ${if(or(len(LAB2_Y)=0,LAB2_Y="1"),"and 1=1",if(LAB2_Y="主营","and ISZHUYING='主营'","and ISZHUYING<>'主营'"))}

${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} 


UNION ALL 

SELECT '内部推荐' AS RZQUDAO,
       COUNT(YGID) AS RENSHU
  FROM ODM_HR_RZTZ NA
 WHERE 1=1
   AND TO_CHAR(RZDATE,'YYYY')=TO_CHAR(SYSDATE,'YYYY')
   AND RZQUDAO = '内部推荐'
   ${if(or(len(LAB2_Y)=0,LAB2_Y="1"),"and 1=1",if(LAB2_Y="主营","and ISZHUYING='主营'","and ISZHUYING<>'主营'"))}

${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} 
ORDER BY RENSHU DESC
)
UNION ALL

SELECT '其他' AS RZQUDAO,
       COUNT(YGID) AS RENSHU
  FROM ODM_HR_RZTZ NA
 WHERE 1=1
   AND TO_CHAR(RZDATE,'YYYY')=TO_CHAR(SYSDATE,'YYYY')
   AND (RZQUDAO NOT IN ('校园招聘-MBA储备干部','校园招聘-非常青藤','校园招聘-常青藤','校园招聘-产动力','专场招聘会-猎聘','专场招聘会-智联',
                       '专场招聘会-51JOB','网络','智联','猎聘','51JOB','华夏幸福招聘网站','领英','其他外部网站','微信端','APP','猎头','猎聘','智联','内部推荐','Networking','Job portal','Headhunter','Campus recruitment')
        OR 
        RZQUDAO IS NULL)
    ${if(len(LAB2_Y)==0,"and 1=1",if(LAB2_Y="主营","and ISZHUYING='主营'","and ISZHUYING<>'主营'"))}       

${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} 
  )
  where RENSHU<>0
  ORDER BY RENSHU]]></Query>
</TableData>
<TableData name="41YLIZHI" class="com.fr.data.impl.DBTableData">
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
<![CDATA[
SELECT 
COUNT(CASE WHEN 1=1 THEN YGID END) AS HZS,
COUNT(CASE WHEN ISZHUYING='主营' THEN YGID END) AS ZY,
COUNT(CASE WHEN ISZHUYING<>'主营' THEN YGID END) AS FZY,
COUNT(CASE WHEN ZHIJI IN ('05级','06级','07级','08级','09级','10级','11级','12级','13级','14级','15级','16级','17级','18级') THEN YGID END) AS GG,
COUNT(CASE WHEN ISCQT='是' THEN YGID END) AS CQT
FROM ODM_HR_LZTZ
WHERE 
TO_CHAR(LZDATE,'YYYY')=TO_CHAR(SYSDATE,'YYYY')
AND TO_CHAR(LZDATE,'YYYYMMDD')<TO_CHAR(SYSDATE,'YYYYMMDD')
AND ISZHUYING NOT LIKE '%实习生%'
AND YGLEIBIE NOT LIKE '%实习生%'

${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} 
]]></Query>
</TableData>
<TableData name="42YLZLX" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="LAB4_Y"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="LAB3_Y"/>
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
<![CDATA[SELECT
 COUNT(1) AS RS,
LZLEIXING 
FROM ODM_HR_LZTZ
WHERE TO_CHAR(LZDATE,'YYYY')=TO_CHAR(SYSDATE,'YYYY')
AND TO_CHAR(LZDATE,'YYYYMMDD')<TO_CHAR(SYSDATE,'YYYYMMDD')
AND ISZHUYING NOT LIKE '%实习生%'
AND YGLEIBIE NOT LIKE '%实习生%'

${if(or(len(lab3_Y)=0,lab3_Y="1"),"and 1=1",if(lab3_Y="主营","and ISZHUYING='主营'","and ISZHUYING<>'主营'"))}
${if(len(lab4_Y)=0,"and 1=1",if(lab4_Y="常青藤","and ISCQT='是'","and ZHIJI IN ('05级','06级','07级','08级','09级','10级','11级','12级','13级','14级','15级','16级','17级','18级')"))}

${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} 
GROUP BY LZLEIXING]]></Query>
</TableData>
<TableData name="43YLZYY" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="LAB4_Y"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="LAB3_Y"/>
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
<![CDATA[SELECT
 COUNT(1) AS RS, 
CASE WHEN LZYUANYIN IS NULL THEN '其它' ELSE LZYUANYIN END AS LZYUANYIN
FROM ODM_HR_LZTZ
WHERE TO_CHAR(LZDATE,'YYYY')=TO_CHAR(SYSDATE,'YYYY')
AND TO_CHAR(LZDATE,'YYYYMMDD')<TO_CHAR(SYSDATE,'YYYYMMDD')
AND ISZHUYING NOT LIKE '%实习生%'
AND YGLEIBIE NOT LIKE '%实习生%'

${if(or(len(LAB3_Y)=0,LAB3_Y="1"),"and 1=1",if(LAB3_Y="主营","and ISZHUYING='主营'","and ISZHUYING<>'主营'"))}
${if(len(LAB4_Y)=0,"and 1=1",if(LAB4_Y="常青藤","and ISCQT='是'","and ZHIJI IN ('05级','06级','07级','08级','09级','10级','11级','12级','13级','14级','15级','16级','17级','18级')"))}

${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} 
GROUP BY LZYUANYIN
ORDER BY RS ]]></Query>
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
<![CDATA[SELECT DISTINCT T1.YGID 
  FROM ODM_HR_YGTZ T1
  LEFT JOIN ODM_HR_DW T2 ON T1.TREE_NODE_ID LIKE '%' || T2.TREE_NODE || '%'
 WHERE 1=1
   AND T2.TREE_NODE IN ('10001100029','100001100063')
   AND ISZHUYING = '主营'
   ${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} 
UNION ALL
SELECT DISTINCT T1.YGID 
  FROM ODM_HR_YGTZ T1
  LEFT JOIN ODM_HR_DW T2 ON T1.TREE_NODE_ID LIKE '%' || T2.TREE_NODE || '%'
 WHERE 1=1
   AND T2.TREE_NODE IN ('10001100029','100001100063')
   AND ISZHUYING = '主营'
   ${if(len(DWMC)=0," and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")} ]]></Query>
</TableData>
<TableData name="BBBK_SJ" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="lab1"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="DWMC"/>
<O>
<![CDATA[HX_HEAD]]></O>
</Parameter>
<Parameter>
<Attributes name="LAB"/>
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
<![CDATA[WITH DATE_TRUE AS (
select  
        count (ygid) RS,
       descr AS DANWEI,
       ISZHUYING AS WD
  from (select T1.ISCQT,T1.ISZHUYING,T1.YGFENLEI,t1.ygid, t2.descr
          from odm_hr_YGTZ t1, odm_hr_dw t2
         where t1.tree_node_id like '%' || t2.tree_node || '%' 
 ${if(len(DWMC)=0," AND   PARENT_NODE ='HX_HEAD' ","AND PARENT_NODE ='"+DWMC+"'" )}--参数 
${SWITCH(LAB,'',"",'主营(含财务)',"AND T1.ISZHUYING = '主营'",'非主营'," AND T1.ISZHUYING <> '主营'",'主营(不含财务)'," and T1.iszhuying = '主营' AND BUMEN NOT LIKE '%财务管理中心%' AND BUMEN NOT LIKE '%融资中心%'  AND YGID NOT IN ('10027979','10034523')
")}
${if(len(lab1)=0,"and 1=1",if(lab1="干部","and T1.YGFENLEI= '干部' ","and T1.ISCQT='是' and T1.ISZHUYING='主营'"))}   
 UNION

select T1.ISCQT,T1.ISZHUYING,T1.YGFENLEI,t1.ygid, t2.descr
          from odm_hr_YGTZ t1, odm_hr_dw t2
         where t1.tree_node_id like '%' || t2.tree_node || '%' 
 ${if(len(DWMC)=0," AND   PARENT_NODE ='HX_HEAD' ","AND BUMENID ='"+DWMC+"'" )}--参数 
 ${SWITCH(LAB,'',"",'主营(含财务)',"AND T1.ISZHUYING = '主营'",'非主营'," AND T1.ISZHUYING <> '主营'",'主营(不含财务)'," and T1.iszhuying = '主营' AND BUMEN NOT LIKE '%财务管理中心%' AND BUMEN NOT LIKE '%融资中心%'    AND YGID NOT IN ('10027979','10034523')
")}
${if(len(lab1)=0,"and 1=1",if(lab1="干部","and T1.YGFENLEI= '干部' ","and T1.ISCQT='是' and T1.ISZHUYING='主营'"))}   
--AND BUMENID ='10001100001'
 and bumenid = t2.tree_node
               )
WHERE 1=1
         
 group by descr,ISZHUYING
 )
 SELECT * FROM DATE_TRUE WHERE WD IN ('主营','非主营')
order by RS desc
]]></Query>
</TableData>
<TableData name="CS_SJ" class="com.fr.data.impl.DBTableData">
<Parameters>
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
select  
        count (ygid) RS,
       descr AS DANWEI,
       ISZHUYING AS WD
  from (select T1.ISCQT,T1.ISZHUYING,T1.YGFENLEI,t1.ygid, t2.descr
          from odm_hr_YGTZ t1, odm_hr_dw t2
         where t1.tree_node_id like '%' || t2.tree_node || '%' 
 ${if(len(DWMC)=0," AND   PARENT_NODE ='HX_HEAD' ","AND PARENT_NODE ='"+DWMC+"'" )}--参数   
 UNION

select T1.ISCQT,T1.ISZHUYING,T1.YGFENLEI,t1.ygid, t2.descr
          from odm_hr_YGTZ t1, odm_hr_dw t2
         where t1.tree_node_id like '%' || t2.tree_node || '%' 
 ${if(len(DWMC)=0," AND   PARENT_NODE ='HX_HEAD' ","AND BUMENID ='"+DWMC+"'" )}--参数 
 and bumenid = t2.tree_node
               )
WHERE 1=1
         
 group by descr,ISZHUYING
 )
 SELECT * FROM DATE_TRUE WHERE WD IN ('主营','非主营')
order by RS desc
]]></Query>
</TableData>
</TableDataMap>
<ReportFitAttr fitStateInPC="2" fitFont="true"/>
<FormMobileAttr>
<FormMobileAttr refresh="true" isUseHTML="true"/>
</FormMobileAttr>
<Parameters>
<Parameter>
<Attributes name="DWMC"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=SQL("HXXF_HR",
"SELECT TREE_ID FROM HR_AUTHORITY WHERE RLOE_TYPE='1' AND NAME_ID='"+$username+"' ",1,1)]]></Attributes>
</O>
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
<NorthAttr size="0"/>
<North class="com.fr.form.ui.container.WParameterLayout">
<Listener event="afterinit">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="DWMC"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$DWMC]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[setTimeout(function(){  
$('.parameter-container-collapseimg-up').trigger("click");  
$('.parameter-container-collapseimg-up').remove();  
},1);  

]]></Content>
</JavaScript>
</Listener>
<WidgetName name="para"/>
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
<Background name="ColorBackground" color="-3355444"/>
<LCAttr vgap="0" hgap="0" compInterval="0"/>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TextEditor">
<WidgetName name="LAB4_Y"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<TextAttr/>
<widgetValue/>
</InnerWidget>
<BoundsAttr x="778" y="0" width="52" height="0"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TextEditor">
<WidgetName name="LAB3_Y"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<TextAttr/>
<widgetValue/>
</InnerWidget>
<BoundsAttr x="713" y="0" width="58" height="0"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TextEditor">
<WidgetName name="LAB2_Y"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<TextAttr/>
<widgetValue/>
</InnerWidget>
<BoundsAttr x="640" y="0" width="64" height="0"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TextEditor">
<WidgetName name="lab4"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<TextAttr/>
<widgetValue/>
</InnerWidget>
<BoundsAttr x="576" y="0" width="80" height="0"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TextEditor">
<WidgetName name="lab3"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<TextAttr/>
<widgetValue/>
</InnerWidget>
<BoundsAttr x="490" y="0" width="80" height="0"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TextEditor">
<WidgetName name="lab2"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<TextAttr/>
<widgetValue/>
</InnerWidget>
<BoundsAttr x="404" y="0" width="80" height="0"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TextEditor">
<WidgetName name="DWMC"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<TextAttr/>
<widgetValue>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=  if(len(REPLACE(VALUE("TREE_ID_KL",1),',',''))<>0,REPLACE(VALUE("TREE_ID_KL",1),',',''),
  if(len(REPLACE(VALUE("TREE_ID_KL",2),',',''))<>0,REPLACE(VALUE("TREE_ID_KL",2),',',''),
  if(len(REPLACE(VALUE("TREE_ID_KL",3),',',''))<>0,REPLACE(VALUE("TREE_ID_KL",3),',',''),
   if(len(REPLACE(VALUE("TREE_ID_KL",4),',',''))<>0,REPLACE(VALUE("TREE_ID_KL",4),',',''),
   if(len(REPLACE(VALUE("TREE_ID_KL",5),',',''))<>0,REPLACE(VALUE("TREE_ID_KL",5),',',''),
   if(len(REPLACE(VALUE("TREE_ID_KL",6),',',''))<>0,REPLACE(VALUE("TREE_ID_KL",6),',',''),
   if(len(REPLACE(VALUE("TREE_ID_KL",7),',',''))<>0,REPLACE(VALUE("TREE_ID_KL",7),',',''),
   if(len(REPLACE(VALUE("TREE_ID_KL",8),',',''))<>0,REPLACE(VALUE("TREE_ID_KL",8),',',''),
   REPLACE(VALUE("TREE_ID_KL",9),',','')
   )   )   )   )   )   )   )  )]]></Attributes>
</O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="216" y="0" width="166" height="0"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TextEditor">
<WidgetName name="lab1"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<TextAttr/>
<widgetValue/>
</InnerWidget>
<BoundsAttr x="112" y="0" width="80" height="0"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TextEditor">
<WidgetName name="lab"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<TextAttr/>
<widgetValue/>
</InnerWidget>
<BoundsAttr x="5" y="0" width="80" height="0"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="lab"/>
<Widget widgetName="lab1"/>
<Widget widgetName="DWMC"/>
<Widget widgetName="lab2"/>
<Widget widgetName="lab3"/>
<Widget widgetName="lab4"/>
<Widget widgetName="LAB2_Y"/>
<Widget widgetName="LAB3_Y"/>
<Widget widgetName="LAB4_Y"/>
</MobileWidgetList>
<Display display="true"/>
<DelayDisplayContent delay="false"/>
<Position position="0"/>
<Design_Width design_width="960"/>
<NameTagModified/>
<WidgetNameTagMap/>
</North>
<Center class="com.fr.form.ui.container.WFitLayout">
<Listener event="afterinit">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="DWMC"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$DWMC]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[
if(DWMC=="HX_HEAD"){
setTimeout(function() {
$("#fr-btn-AAAA").css({"background":"#bf0000","text-decoration":"underline"});
$("#fr-btn-BBBB").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-CCCC").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-DDDD").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-GGGG").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-GGGG1").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-FFFF").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-EEEE").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-HHHH").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-JJJJ").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-JJJJ1").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-IIII").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-AAAA").find(".fr-btn-text").css("color","#ffffff"); 
$("#fr-btn-BBBB").find(".fr-btn-text").css("color","#bf0000"); 
$("#fr-btn-CCCC").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-DDDD").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-GGGG").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-GGGG1").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-FFFF").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-EEEE").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-HHHH").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-JJJJ").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-JJJJ1").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-IIII").find(".fr-btn-text").css("color","#bf0000");

});}
else if(DWMC=="10001100001") {
 setTimeout(function() {
$("#fr-btn-AAAA").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-BBBB").css({"background":"#bf0000","text-decoration":"underline"});
$("#fr-btn-CCCC").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-DDDD").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-GGGG").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-GGGG1").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-FFFF").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-EEEE").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-HHHH").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-JJJJ").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-JJJJ1").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-IIII").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-AAAA").find(".fr-btn-text").css("color","#bf0000"); 
$("#fr-btn-BBBB").find(".fr-btn-text").css("color","#ffffff"); 
$("#fr-btn-CCCC").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-DDDD").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-GGGG").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-GGGG1").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-FFFF").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-EEEE").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-HHHH").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-JJJJ").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-JJJJ1").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-IIII").find(".fr-btn-text").css("color","#bf0000");
});}
else if(DWMC=="100000") {
 setTimeout(function() {
$("#fr-btn-AAAA").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-BBBB").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-CCCC").css({"background":"#bf0000","text-decoration":"underline"});
$("#fr-btn-DDDD").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-GGGG").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-GGGG1").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-FFFF").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-EEEE").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-HHHH").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-JJJJ").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-JJJJ1").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-IIII").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-AAAA").find(".fr-btn-text").css("color","#bf0000"); 
$("#fr-btn-BBBB").find(".fr-btn-text").css("color","#bf0000"); 
$("#fr-btn-CCCC").find(".fr-btn-text").css("color","#ffffff");
$("#fr-btn-DDDD").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-GGGG").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-GGGG1").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-FFFF").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-EEEE").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-HHHH").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-JJJJ").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-JJJJ1").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-IIII").find(".fr-btn-text").css("color","#bf0000");
});}
else if(DWMC=="10041105853") {
 setTimeout(function() {
$("#fr-btn-AAAA").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-BBBB").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-CCCC").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-DDDD").css({"background":"#bf0000","text-decoration":"underline"});
$("#fr-btn-GGGG").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-GGGG1").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-FFFF").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-EEEE").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-HHHH").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-JJJJ").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-JJJJ1").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-IIII").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-AAAA").find(".fr-btn-text").css("color","#bf0000"); 
$("#fr-btn-BBBB").find(".fr-btn-text").css("color","#bf0000"); 
$("#fr-btn-CCCC").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-DDDD").find(".fr-btn-text").css("color","#ffffff");
$("#fr-btn-GGGG").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-GGGG1").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-FFFF").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-EEEE").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-HHHH").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-JJJJ").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-JJJJ1").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-IIII").find(".fr-btn-text").css("color","#bf0000");
});}
else if(DWMC=="10004100730") {
 setTimeout(function() {
$("#fr-btn-AAAA").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-BBBB").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-CCCC").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-DDDD").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-GGGG").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-GGGG1").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-FFFF").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-EEEE").css({"background":"#bf0000","text-decoration":"underline"});
$("#fr-btn-HHHH").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-JJJJ").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-JJJJ1").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-IIII").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-AAAA").find(".fr-btn-text").css("color","#bf0000"); 
$("#fr-btn-BBBB").find(".fr-btn-text").css("color","#bf0000"); 
$("#fr-btn-CCCC").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-DDDD").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-GGGG").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-GGGG1").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-FFFF").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-EEEE").find(".fr-btn-text").css("color","#ffffff");
$("#fr-btn-HHHH").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-JJJJ").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-JJJJ1").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-IIII").find(".fr-btn-text").css("color","#bf0000");
});}
else if(DWMC=="10003100439") {
 setTimeout(function() {
$("#fr-btn-AAAA").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-BBBB").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-CCCC").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-DDDD").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-GGGG").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-GGGG1").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-FFFF").css({"background":"#bf0000","text-decoration":"underline"});
$("#fr-btn-EEEE").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-HHHH").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-JJJJ").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-JJJJ1").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-IIII").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-AAAA").find(".fr-btn-text").css("color","#bf0000"); 
$("#fr-btn-BBBB").find(".fr-btn-text").css("color","#bf0000"); 
$("#fr-btn-CCCC").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-DDDD").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-GGGG").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-GGGG1").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-FFFF").find(".fr-btn-text").css("color","#ffffff");
$("#fr-btn-EEEE").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-HHHH").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-JJJJ").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-JJJJ1").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-IIII").find(".fr-btn-text").css("color","#bf0000");
});}
else if(DWMC=="10046109037") {
 setTimeout(function() {
$("#fr-btn-AAAA").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-BBBB").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-CCCC").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-DDDD").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-GGGG").css({"background":"#bf0000","text-decoration":"underline"});
$("#fr-btn-GGGG1").css({"background":"#bf0000","text-decoration":"underline"});
$("#fr-btn-FFFF").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-EEEE").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-HHHH").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-JJJJ").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-JJJJ1").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-IIII").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-AAAA").find(".fr-btn-text").css("color","#bf0000"); 
$("#fr-btn-BBBB").find(".fr-btn-text").css("color","#bf0000"); 
$("#fr-btn-CCCC").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-DDDD").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-GGGG").find(".fr-btn-text").css("color","#ffffff");
$("#fr-btn-GGGG1").find(".fr-btn-text").css("color","#ffffff");
$("#fr-btn-FFFF").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-EEEE").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-HHHH").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-JJJJ").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-JJJJ1").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-IIII").find(".fr-btn-text").css("color","#bf0000");
});}
else if(DWMC=="10039105618") {
 setTimeout(function() {
$("#fr-btn-AAAA").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-BBBB").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-CCCC").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-DDDD").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-GGGG").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-GGGG1").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-FFFF").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-EEEE").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-HHHH").css({"background":"#bf0000","text-decoration":"underline"});
$("#fr-btn-JJJJ").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-JJJJ1").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-IIII").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-AAAA").find(".fr-btn-text").css("color","#bf0000"); 
$("#fr-btn-BBBB").find(".fr-btn-text").css("color","#bf0000"); 
$("#fr-btn-CCCC").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-DDDD").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-GGGG").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-GGGG1").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-FFFF").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-EEEE").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-HHHH").find(".fr-btn-text").css("color","#ffffff");
$("#fr-btn-JJJJ").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-JJJJ1").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-IIII").find(".fr-btn-text").css("color","#bf0000");
});}
else if(DWMC=="10048109174") {
 setTimeout(function() {
$("#fr-btn-AAAA").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-BBBB").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-CCCC").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-DDDD").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-GGGG").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-GGGG1").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-FFFF").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-EEEE").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-HHHH").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-JJJJ").css({"background":"#bf0000","text-decoration":"underline"});
$("#fr-btn-JJJJ1").css({"background":"#bf0000","text-decoration":"underline"});
$("#fr-btn-IIII").css({"background":"#ffffff","text-decoration":"underline"});
$("#fr-btn-AAAA").find(".fr-btn-text").css("color","#bf0000"); 
$("#fr-btn-BBBB").find(".fr-btn-text").css("color","#bf0000"); 
$("#fr-btn-CCCC").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-DDDD").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-GGGG").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-GGGG1").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-FFFF").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-EEEE").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-HHHH").find(".fr-btn-text").css("color","#bf0000");
$("#fr-btn-JJJJ").find(".fr-btn-text").css("color","#ffffff");
$("#fr-btn-JJJJ1").find(".fr-btn-text").css("color","#ffffff");
$("#fr-btn-IIII").find(".fr-btn-text").css("color","#bf0000");
});}
 ]]></Content>
</JavaScript>
</Listener>
<Listener event="afterinit">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[setTimeout(function() {

	//按钮边角
$('.fr-btn-up').css('border-radius','0px');
})]]></Content>
</JavaScript>
</Listener>
<Listener event="afterinit">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="lab"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$lab]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="lab1"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$lab1]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[setTimeout(function() {
//////////////////////////
if (lab==""){
$.each($(".ui-state-enabled"),function(i, v){
if(
$(v).attr("widgetname")=="LAB222"
||$(v).attr("widgetname")=="LAB333"
||$(v).attr("widgetname")=="LAB444"
||$(v).attr("widgetname")=="LAB555"
||$(v).attr("widgetname")=="LAB666"
){
$(v).find(".fr-label").css("color","#120eec");
//$(v).find(".fr-label").css("font-size","12PX");
}
});
$.each($(".ui-state-enabled"),function(i, v){
if(
$(v).attr("widgetname")=="LAB111"
){
$(v).find(".fr-label").css("color","#bf0000");
//$(v).find(".fr-label").css("font-size","18PX");
}
});
}

else if (lab=="主营(含财务)")
{
$.each($(".ui-state-enabled"),function(i, v){
if(
$(v).attr("widgetname")=="LAB111"
||$(v).attr("widgetname")=="LAB333"
||$(v).attr("widgetname")=="LAB444"
||$(v).attr("widgetname")=="LAB555"
||$(v).attr("widgetname")=="LAB666"
){
$(v).find(".fr-label").css("color","#120eec");
//$(v).find(".fr-label").css("font-size","12PX");
}
});
$.each($(".ui-state-enabled"),function(i, v){
if(
$(v).attr("widgetname")=="LAB222"
){
$(v).find(".fr-label").css("color","#bf0000");
//$(v).find(".fr-label").css("font-size","18PX");
}
});
}
//////////////////
else if(lab=="非主营")
{
$.each($(".ui-state-enabled"),function(i, v){
if(
$(v).attr("widgetname")=="LAB111"
||$(v).attr("widgetname")=="LAB222"
||$(v).attr("widgetname")=="LAB444"
||$(v).attr("widgetname")=="LAB555"
||$(v).attr("widgetname")=="LAB666"){
$(v).find(".fr-label").css("color","#120eec");
//$(v).find(".fr-label").css("font-size","12PX");
}
});
$.each($(".ui-state-enabled"),function(i, v){
if(
$(v).attr("widgetname")=="LAB333"
){
$(v).find(".fr-label").css("color","#bf0000");
//$(v).find(".fr-label").css("font-size","18PX");
}
});
}
////////////////////////////
else if(lab=="主营(不含财务)")
{
$.each($(".ui-state-enabled"),function(i, v){
if(
$(v).attr("widgetname")=="LAB111"
||$(v).attr("widgetname")=="LAB222"
||$(v).attr("widgetname")=="LAB333"
||$(v).attr("widgetname")=="LAB444"
||$(v).attr("widgetname")=="LAB555"){
$(v).find(".fr-label").css("color","#120eec");
//$(v).find(".fr-label").css("font-size","12PX");
}
});
$.each($(".ui-state-enabled"),function(i, v){
if(
$(v).attr("widgetname")=="LAB666"
){
$(v).find(".fr-label").css("color","#bf0000");
//$(v).find(".fr-label").css("font-size","18PX");
}
});
}
///////////////////
 if (lab1=="干部")
{
$.each($(".ui-state-enabled"),function(i, v){
if(
$(v).attr("widgetname")=="LAB111"
||$(v).attr("widgetname")=="LAB222"
||$(v).attr("widgetname")=="LAB333"
||$(v).attr("widgetname")=="LAB555"
||$(v).attr("widgetname")=="LAB666"
){
$(v).find(".fr-label").css("color","#120eec");
//$(v).find(".fr-label").css("font-size","12PX");
}
});
$.each($(".ui-state-enabled"),function(i, v){
if(
$(v).attr("widgetname")=="LAB444"
){
$(v).find(".fr-label").css("color","#bf0000");
//$(v).find(".fr-label").css("font-size","18PX");
}
});
}
else  if (lab1=="常青藤")
{

$.each($(".ui-state-enabled"),function(i, v){
if(
$(v).attr("widgetname")=="LAB111"
||$(v).attr("widgetname")=="LAB222"
||$(v).attr("widgetname")=="LAB333"
||$(v).attr("widgetname")=="LAB444"
||$(v).attr("widgetname")=="LAB666"
){
$(v).find(".fr-label").css("color","#120eec");
//$(v).find(".fr-label").css("font-size","12PX");
}
});
$.each($(".ui-state-enabled"),function(i, v){
if(
$(v).attr("widgetname")=="LAB555"
){
$(v).find(".fr-label").css("color","#bf0000");
//$(v).find(".fr-label").css("font-size","18PX");
}
});
}

///////////////////////////
})

]]></Content>
</JavaScript>
</Listener>
<Listener event="afterinit">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="lab2"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$lab2]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="lab2_Y"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$lab2_Y]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[setTimeout(function() {
//////////////////////////////
if( lab2=="1")
{
$.each($(".ui-state-enabled"),function(i, v){
if(
$(v).attr("widgetname")=="MON33"
||$(v).attr("widgetname")=="MON22"

){
$(v).find(".fr-label").css("color","#120eec");
//$(v).find(".fr-label").css("font-size","12PX");
}
});
$.each($(".ui-state-enabled"),function(i, v){
if(
$(v).attr("widgetname")=="MON11"
){
$(v).find(".fr-label").css("color","#bf0000");
//$(v).find(".fr-label").css("font-size","18PX");
}
});
}
else if (lab2=="主营")
{
$.each($(".ui-state-enabled"),function(i, v){
if(
$(v).attr("widgetname")=="MON11"
||$(v).attr("widgetname")=="MON33"

){
$(v).find(".fr-label").css("color","#120eec");
//$(v).find(".fr-label").css("font-size","12PX");
}
});
$.each($(".ui-state-enabled"),function(i, v){
if(
$(v).attr("widgetname")=="MON22"
){
$(v).find(".fr-label").css("color","#bf0000");
//$(v).find(".fr-label").css("font-size","18PX");
}
});
}

else if (lab2=="非主营")
{

$.each($(".ui-state-enabled"),function(i, v){
if(
$(v).attr("widgetname")=="MON22"
||$(v).attr("widgetname")=="MON11"

){
$(v).find(".fr-label").css("color","#120eec");
//$(v).find(".fr-label").css("font-size","12PX");
}
});
$.each($(".ui-state-enabled"),function(i, v){
if(
$(v).attr("widgetname")=="MON33"
){
$(v).find(".fr-label").css("color","#bf0000");
//$(v).find(".fr-label").css("font-size","18PX");
}
});
}


//////////////////////////////
})
setTimeout(function() {
//////////////////////////////
if( lab2_Y=="1")
{
$.each($(".ui-state-enabled"),function(i, v){
if(
$(v).attr("widgetname")=="MON33_Y"
||$(v).attr("widgetname")=="MON22_Y"

){
$(v).find(".fr-label").css("color","#120eec");
//$(v).find(".fr-label").css("font-size","12PX");
}
});
$.each($(".ui-state-enabled"),function(i, v){
if(
$(v).attr("widgetname")=="MON11_Y"
){
$(v).find(".fr-label").css("color","#bf0000");
//$(v).find(".fr-label").css("font-size","18PX");
}
});
}
else if (lab2_Y=="主营")
{
$.each($(".ui-state-enabled"),function(i, v){
if(
$(v).attr("widgetname")=="MON11_Y"
||$(v).attr("widgetname")=="MON33_Y"

){
$(v).find(".fr-label").css("color","#120eec");
//$(v).find(".fr-label").css("font-size","12PX");
}
});
$.each($(".ui-state-enabled"),function(i, v){
if(
$(v).attr("widgetname")=="MON22_Y"
){
$(v).find(".fr-label").css("color","#bf0000");
//$(v).find(".fr-label").css("font-size","18PX");
}
});
}

else if (lab2_Y=="非主营")
{

$.each($(".ui-state-enabled"),function(i, v){
if(
$(v).attr("widgetname")=="MON22_Y"
||$(v).attr("widgetname")=="MON11_Y"

){
$(v).find(".fr-label").css("color","#120eec");
//$(v).find(".fr-label").css("font-size","12PX");
}
});
$.each($(".ui-state-enabled"),function(i, v){
if(
$(v).attr("widgetname")=="MON33_Y"
){
$(v).find(".fr-label").css("color","#bf0000");
//$(v).find(".fr-label").css("font-size","18PX");
}
});
}


//////////////////////////////
})]]></Content>
</JavaScript>
</Listener>
<Listener event="afterinit">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="lab3"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$lab3]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="lab4"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$lab4]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="lab3_Y"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$lab3_Y]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="lab4_Y"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$lab4_Y]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[setTimeout(function() {
if(lab3=="1")
{
$.each($(".ui-state-enabled"),function(i, v){
if(
$(v).attr("widgetname")=="M22"
||$(v).attr("widgetname")=="M33"
||$(v).attr("widgetname")=="M44"
||$(v).attr("widgetname")=="M55"
){
$(v).find(".fr-label").css("color","#120eec");
//$(v).find(".fr-label").css("font-size","12PX");
}
});
$.each($(".ui-state-enabled"),function(i, v){
if(
$(v).attr("widgetname")=="M11"
){
$(v).find(".fr-label").css("color","#bf0000");
//$(v).find(".fr-label").css("font-size","18PX");
}
});
}
///////////////////
else if(lab3=="主营")
{
$.each($(".ui-state-enabled"),function(i, v){
if(
$(v).attr("widgetname")=="M11"
||$(v).attr("widgetname")=="M33"
||$(v).attr("widgetname")=="M44"
||$(v).attr("widgetname")=="M55"
){
$(v).find(".fr-label").css("color","#120eec");
//$(v).find(".fr-label").css("font-size","12PX");
}
});
$.each($(".ui-state-enabled"),function(i, v){
if(
$(v).attr("widgetname")=="M22"
){
$(v).find(".fr-label").css("color","#bf0000");
//$(v).find(".fr-label").css("font-size","18PX");
}
});
}
//////////////
else if(lab3=="非主营")
{
$.each($(".ui-state-enabled"),function(i, v){
if(
$(v).attr("widgetname")=="M22"
||$(v).attr("widgetname")=="M11"
||$(v).attr("widgetname")=="M44"
||$(v).attr("widgetname")=="M55"

){
$(v).find(".fr-label").css("color","#120eec");
//$(v).find(".fr-label").css("font-size","12PX");
}
});
$.each($(".ui-state-enabled"),function(i, v){
if(
$(v).attr("widgetname")=="M33"
){
$(v).find(".fr-label").css("color","#bf0000");
//$(v).find(".fr-label").css("font-size","18PX");
}
});
}
//////////////////
if(lab4=="副总监以上")
{
	$.each($(".ui-state-enabled"),function(i, v){
if(
$(v).attr("widgetname")=="M22"
||$(v).attr("widgetname")=="M11"
||$(v).attr("widgetname")=="M33"
||$(v).attr("widgetname")=="M55"
){
$(v).find(".fr-label").css("color","#120eec");
//$(v).find(".fr-label").css("font-size","12PX");
}
});
$.each($(".ui-state-enabled"),function(i, v){
if(
$(v).attr("widgetname")=="M44"
){
$(v).find(".fr-label").css("color","#bf0000");
//$(v).find(".fr-label").css("font-size","18PX");
}
});
	
	}
	////////////////////////
	else if (lab4=="常青藤")
	{
		$.each($(".ui-state-enabled"),function(i, v){
if(
$(v).attr("widgetname")=="M22"
||$(v).attr("widgetname")=="M11"
||$(v).attr("widgetname")=="M33"
||$(v).attr("widgetname")=="M44"
){
$(v).find(".fr-label").css("color","#120eec");
//$(v).find(".fr-label").css("font-size","12PX");
}
});
$.each($(".ui-state-enabled"),function(i, v){
if(
$(v).attr("widgetname")=="M55"
){
$(v).find(".fr-label").css("color","#bf0000");
//$(v).find(".fr-label").css("font-size","18PX");
}
});
		}

})

/////////////////////////////////////////////////////////


setTimeout(function() {
if(lab3_Y=="1")
{
$.each($(".ui-state-enabled"),function(i, v){
if(
$(v).attr("widgetname")=="M22_Y"
||$(v).attr("widgetname")=="M33_Y"
||$(v).attr("widgetname")=="M44_Y"
||$(v).attr("widgetname")=="M55_Y"
){
$(v).find(".fr-label").css("color","#120eec");
//$(v).find(".fr-label").css("font-size","12PX");
}
});
$.each($(".ui-state-enabled"),function(i, v){
if(
$(v).attr("widgetname")=="M11_Y"
){
$(v).find(".fr-label").css("color","#bf0000");
//$(v).find(".fr-label").css("font-size","18PX");
}
});
}
///////////////////
else if(lab3_Y=="主营")
{
$.each($(".ui-state-enabled"),function(i, v){
if(
$(v).attr("widgetname")=="M11_Y"
||$(v).attr("widgetname")=="M33_Y"
||$(v).attr("widgetname")=="M44_Y"
||$(v).attr("widgetname")=="M55_Y"
){
$(v).find(".fr-label").css("color","#120eec");
//$(v).find(".fr-label").css("font-size","12PX");
}
});
$.each($(".ui-state-enabled"),function(i, v){
if(
$(v).attr("widgetname")=="M22_Y"
){
$(v).find(".fr-label").css("color","#bf0000");
//$(v).find(".fr-label").css("font-size","18PX");
}
});
}
//////////////
else if(lab3_Y=="非主营")
{
$.each($(".ui-state-enabled"),function(i, v){
if(
$(v).attr("widgetname")=="M22_Y"
||$(v).attr("widgetname")=="M11_Y"
||$(v).attr("widgetname")=="M44_Y"
||$(v).attr("widgetname")=="M55_Y"

){
$(v).find(".fr-label").css("color","#120eec");
//$(v).find(".fr-label").css("font-size","12PX");
}
});
$.each($(".ui-state-enabled"),function(i, v){
if(
$(v).attr("widgetname")=="M33_Y"
){
$(v).find(".fr-label").css("color","#bf0000");
//$(v).find(".fr-label").css("font-size","18PX");
}
});
}
//////////////////
if(lab4_Y=="副总监以上")
{
	$.each($(".ui-state-enabled"),function(i, v){
if(
$(v).attr("widgetname")=="M22_Y"
||$(v).attr("widgetname")=="M11_Y"
||$(v).attr("widgetname")=="M33_Y"
||$(v).attr("widgetname")=="M55_Y"
){
$(v).find(".fr-label").css("color","#120eec");
//$(v).find(".fr-label").css("font-size","12PX");
}
});
$.each($(".ui-state-enabled"),function(i, v){
if(
$(v).attr("widgetname")=="M44_Y"
){
$(v).find(".fr-label").css("color","#bf0000");
//$(v).find(".fr-label").css("font-size","18PX");
}
});
	
	}
	////////////////////////
	else if (lab4_Y=="常青藤")
	{
		$.each($(".ui-state-enabled"),function(i, v){
if(
$(v).attr("widgetname")=="M22_Y"
||$(v).attr("widgetname")=="M11_Y"
||$(v).attr("widgetname")=="M33_Y"
||$(v).attr("widgetname")=="M44_Y"
){
$(v).find(".fr-label").css("color","#120eec");
//$(v).find(".fr-label").css("font-size","12PX");
}
});
$.each($(".ui-state-enabled"),function(i, v){
if(
$(v).attr("widgetname")=="M55_Y"
){
$(v).find(".fr-label").css("color","#bf0000");
//$(v).find(".fr-label").css("font-size","18PX");
}
});
		}

})]]></Content>
</JavaScript>
</Listener>
<Listener event="afterinit">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[setTimeout(function() {
$("#fr-btn-AAAA").css("border-left","1px solid #bf0000"); 
$("#fr-btn-AAAA").css("border-right","1px solid #bf0000");
$("#fr-btn-AAAA").css("border-top","1px solid #bf0000"); 
$("#fr-btn-AAAA").css("border-bottom","1px solid #bf0000");

$("#fr-btn-BBBB").css("border-left","1px solid #bf0000"); 
$("#fr-btn-BBBB").css("border-right","1px solid #bf0000");
$("#fr-btn-BBBB").css("border-top","1px solid #bf0000"); 
$("#fr-btn-BBBB").css("border-bottom","1px solid #bf0000");

$("#fr-btn-CCCC").css("border-left","1px solid #bf0000"); 
$("#fr-btn-CCCC").css("border-right","1px solid #bf0000");
$("#fr-btn-CCCC").css("border-top","1px solid #bf0000"); 
$("#fr-btn-CCCC").css("border-bottom","1px solid #bf0000");

$("#fr-btn-DDDD").css("border-left","1px solid #bf0000"); 
$("#fr-btn-DDDD").css("border-right","1px solid #bf0000");
$("#fr-btn-DDDD").css("border-top","1px solid #bf0000"); 
$("#fr-btn-DDDD").css("border-bottom","1px solid #bf0000");

$("#fr-btn-EEEE").css("border-left","1px solid #bf0000"); 
$("#fr-btn-EEEE").css("border-right","1px solid #bf0000");
$("#fr-btn-EEEE").css("border-top","1px solid #bf0000"); 
$("#fr-btn-EEEE").css("border-bottom","1px solid #bf0000");

$("#fr-btn-FFFF").css("border-left","1px solid #bf0000"); 
$("#fr-btn-FFFF").css("border-right","1px solid #bf0000");
$("#fr-btn-FFFF").css("border-top","1px solid #bf0000"); 
$("#fr-btn-FFFF").css("border-bottom","1px solid #bf0000");


$("#fr-btn-GGGG").css("border-left","1px solid #bf0000"); 
$("#fr-btn-GGGG").css("border-right","1px solid #bf0000");
$("#fr-btn-GGGG").css("border-top","1px solid #bf0000"); 


$("#fr-btn-GGGG1").css("border-left","1px solid #bf0000"); 
$("#fr-btn-GGGG1").css("border-right","1px solid #bf0000");
$("#fr-btn-GGGG1").css("border-bottom","1px solid #bf0000");

$("#fr-btn-HHHH").css("border-left","1px solid #bf0000"); 
$("#fr-btn-HHHH").css("border-right","1px solid #bf0000");
$("#fr-btn-HHHH").css("border-top","1px solid #bf0000"); 
$("#fr-btn-HHHH").css("border-bottom","1px solid #bf0000");


$("#fr-btn-JJJJ").css("border-left","1px solid #bf0000"); 
$("#fr-btn-JJJJ").css("border-right","1px solid #bf0000");
$("#fr-btn-JJJJ").css("border-top","1px solid #bf0000"); 


$("#fr-btn-JJJJ1").css("border-left","1px solid #bf0000"); 
$("#fr-btn-JJJJ1").css("border-right","1px solid #bf0000");
$("#fr-btn-JJJJ1").css("border-bottom","1px solid #bf0000");

})]]></Content>
</JavaScript>
</Listener>
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
<![CDATA[WebReport/ReportServer?formlet=HXXF_HR/Maneger/index.frm]]></O>
</ColumnConfig>
<ColumnConfig name="CPT" isKey="false" skipUnmodified="false">
<O>
<![CDATA[index.frm]]></O>
</ColumnConfig>
<ColumnConfig name="CPT_NAME" isKey="false" skipUnmodified="false">
<O>
<![CDATA[用工看板]]></O>
</ColumnConfig>
<ColumnConfig name="REGISTER_ID" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=uuid()]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="REGISTER_ENTER_ID" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=uuid()]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="PARAMETER_TREE" isKey="false" skipUnmodified="false">
<O>
<![CDATA[]]></O>
</ColumnConfig>
<ColumnConfig name="PARAMETER_NAME" isKey="false" skipUnmodified="false">
<O>
<![CDATA[部门ID]]></O>
</ColumnConfig>
<ColumnConfig name="PARAMETER" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$DWMC]]></Attributes>
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
<![CDATA[用工看板]]></O>
</ColumnConfig>
<ColumnConfig name="CANSHU_NAME_CODE" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="部门ID:"+$DWMC]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="YGID" isKey="false" skipUnmodified="false"/>
<ColumnConfig name="ISDOWNLOADJL" isKey="false" skipUnmodified="false">
<O>
<![CDATA[]]></O>
</ColumnConfig>
<ColumnConfig name="FILENAME_ID" isKey="false" skipUnmodified="false">
<O>
<![CDATA[]]></O>
</ColumnConfig>
<ColumnConfig name="IP" isKey="false" skipUnmodified="false"/>
<ColumnConfig name="LIANJIE2" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(AND(len(lab)==0,len(lab1)==0),'员工总数',$lab)+$lab1+";"+if(or(len(lab2)==0,$lab2=1),'本月入职员工总数',$lab2) +";"+if(or(AND(len(lab3)==0,len(lab4)==0),$lab3=1),'离职员工总数',$lab3)+$lab4]]></Attributes>
</O>
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
<Listener event="afterinit">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="AAAA"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=StringFind('"'+replace(VALUE("TREE_ID_R",1),'"','')+'"',"HX_HEAD")]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="BBBB"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=StringFind('"'+replace(VALUE("TREE_ID_R",1),'"','')+'"',"10001100001")]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="CCCC"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=StringFind('"'+replace(VALUE("TREE_ID_R",1),'"','')+'"',"100000")]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="DDDD"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=StringFind('"'+replace(VALUE("TREE_ID_R",1),'"','')+'"',"10041105853")]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="EEEE"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=StringFind('"'+replace(VALUE("TREE_ID_R",1),'"','')+'"',"10004100730")]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="FFFF"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=StringFind('"'+replace(VALUE("TREE_ID_R",1),'"','')+'"',"10003100439")]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="GGGG"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=StringFind('"'+replace(VALUE("TREE_ID_R",1),'"','')+'"',"10046109037")]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="HHHH"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=StringFind('"'+replace(VALUE("TREE_ID_R",1),'"','')+'"',"10039105618")]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="JJJJ"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=StringFind('"'+replace(VALUE("TREE_ID_R",1),'"','')+'"',"10048109174")]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[if(AAAA<0){
       this.options.form.getWidgetByName("AAAA").setEnable(false);
	  if(BBBB<0)
	 	{ this.options.form.getWidgetByName("BBBB").setEnable(false)};
       if (CCCC<0)
          { this.options.form.getWidgetByName("CCCC").setEnable(false)};
       if (DDDD<0)
          { this.options.form.getWidgetByName("DDDD").setEnable(false)};
       if (EEEE<0)
          { this.options.form.getWidgetByName("EEEE").setEnable(false)};
       if (FFFF<0)
          { this.options.form.getWidgetByName("FFFF").setEnable(false)};
       if (GGGG<0)
          { this.options.form.getWidgetByName("GGGG").setEnable(false)
           this.options.form.getWidgetByName("GGGG1").setEnable(false)};
       if (HHHH<0)
          { this.options.form.getWidgetByName("HHHH").setEnable(false)};
        if (JJJJ<0)
          { this.options.form.getWidgetByName("JJJJ").setEnable(false)
          this.options.form.getWidgetByName("JJJJ1").setEnable(false)};
}
else {}]]></Content>
</JavaScript>
</Listener>
<WidgetName name="body"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Margin top="0" left="5" bottom="5" right="5"/>
<Border>
<border style="0" color="-723724" borderRadius="0" type="0" borderStyle="0"/>
<WidgetTitle>
<O>
<![CDATA[新建标题]]></O>
<FRFont name="宋体" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Background name="ColorBackground" color="-3355444"/>
<Alpha alpha="1.0"/>
</Border>
<Background name="ColorBackground" color="-3355444"/>
<LCAttr vgap="0" hgap="0" compInterval="5"/>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WAbsoluteLayout">
<Listener event="afterinit">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[var timer = setInterval(function(){
	if($('.fr-absolutelayout')[0]A){
		$('.fr-absolutelayout').css('background','#fff');
		clearInterval(timer)
		}
	
	},100)]]></Content>
</JavaScript>
</Listener>
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
<Margin top="2" left="2" bottom="2" right="2"/>
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
<C c="0" r="0" cs="3" s="0">
<O>
<![CDATA[各业务集团当前用工数]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="1" s="1">
<O>
<![CDATA[单位]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1" s="1">
<O>
<![CDATA[总人数]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="1" s="1">
<O t="DSColumn">
<Attributes dsName="CS_SJ" columnName="WD"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="1"/>
</C>
<C c="0" r="2" s="2">
<O t="DSColumn">
<Attributes dsName="CS_SJ" columnName="DANWEI"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="1" r="2" s="2">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=SUM(C3)]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="2" s="2">
<O t="DSColumn">
<Attributes dsName="CS_SJ" columnName="RS"/>
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
<FRFont name="微软雅黑" style="1" size="72"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-1"/>
<Bottom style="1" color="-1"/>
<Left style="1" color="-1"/>
<Right style="1" color="-1"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="1" size="72" foreground="-1"/>
<Background name="ColorBackground" color="-4259840"/>
<Border>
<Top style="1" color="-3881788"/>
<Bottom style="1" color="-3881788"/>
<Left style="1" color="-3881788"/>
<Right style="1" color="-3881788"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
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
<ReportFitAttr fitStateInPC="2" fitFont="false"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="0" zoom="true" refresh="false" isUseHTML="false"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="250" height="150"/>
</Widget>
<body class="com.fr.form.ui.ElementCaseEditor">
<WidgetName name="report0"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Margin top="2" left="2" bottom="2" right="2"/>
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
<C c="0" r="0" cs="2" s="0">
<O>
<![CDATA[各业务集团当前用工数]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="1" s="1">
<O>
<![CDATA[单位]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1" s="1">
<O>
<![CDATA[总人数]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="1" s="2">
<O t="DSColumn">
<Attributes dsName="CS_SJ" columnName="WD"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="1"/>
</C>
<C c="0" r="2" s="3">
<O t="DSColumn">
<Attributes dsName="CS_SJ" columnName="DANWEI"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="1" r="2" s="3">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=SUM(C3)]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="2" s="3">
<O t="DSColumn">
<Attributes dsName="CS_SJ" columnName="RS"/>
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
<FRFont name="微软雅黑" style="1" size="72"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-1"/>
<Bottom style="1" color="-1"/>
<Left style="1" color="-1"/>
<Right style="1" color="-1"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="1" size="72" foreground="-1"/>
<Background name="ColorBackground" color="-4259840"/>
<Border>
<Top style="1" color="-1"/>
<Bottom style="1" color="-1"/>
<Left style="1" color="-1"/>
<Right style="1" color="-1"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="1" size="72" foreground="-1"/>
<Background name="ColorBackground" color="-4259840"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
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
<BoundsAttr x="5" y="411" width="353" height="202"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="chart1_c_c_c_c"/>
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
<WidgetName name="chart1_c_c_c_c"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="0" color="-3355444" borderRadius="0" type="0" borderStyle="0"/>
<WidgetTitle>
<O>
<![CDATA[< 历史用工趋势图 >]]></O>
<FRFont name="宋体" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Alpha alpha="1.0"/>
</Border>
<LayoutAttr selectedIndex="0"/>
<ChangeAttr enable="true" changeType="carousel" timeInterval="5" buttonColor="-8421505" carouselColor="-8421505">
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
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="各单位人数分布"+if(and(len(lab)==0,len(lab1)==0),'(总体)',"")+if(len(lab)==0,'',"("+$lab+")")+if(len(lab1)==0,'',if(lab1="是","(常青藤)","("+$lab1+")"))]]></Attributes>
</O>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="56" foreground="-13421773"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<Attr4VanChart useHtml="true" floating="false" x="0.0" y="0.0" limitSize="false" maxHeight="15.0"/>
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
<Attr lineStyle="0" isRoundBorder="false" roundRadius="8"/>
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
<FRFont name="微软雅黑" style="0" size="72"/>
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
<OColor colvalue="-3407872"/>
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
<newLineColor lineColor="-1513240"/>
<AxisPosition value="3"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr rotation="-45" alignText="0">
<FRFont name="Verdana" style="0" size="56" foreground="-10066330"/>
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
<newLineColor mainGridColor="-1" lineColor="-5197648"/>
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
</YAxisList>
<stackAndAxisCondition>
<ConditionCollection>
<DefaultAttr class="com.fr.chart.chartglyph.ConditionAttr">
<ConditionAttr name=""/>
</DefaultAttr>
</ConditionCollection>
</stackAndAxisCondition>
<VanChartColumnPlotAttr seriesOverlapPercent="21.0" categoryIntervalPercent="27.0" fixedWidth="true" columnWidth="25" filledWithImage="false" isBar="false"/>
</Plot>
<ChartDefinition>
<MoreNameCDDefinition>
<Top topCate="10" topValue="10" isDiscardOtherCate="true" isDiscardOtherSeries="true" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[10SLQL]]></Name>
</TableData>
<CategoryName value="DANWEI"/>
<ChartSummaryColumn name="RS" function="com.fr.data.util.function.NoneFunction" customName="人数"/>
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
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="职级分布"+if(and(len(lab)==0,len(lab1)==0),'(总体)',"")+if(len(lab)==0,'',"("+$lab+")")+if(len(lab1)==0,'',if(lab1="是","(常青藤)","("+$lab1+")"))]]></Attributes>
</O>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="56" foreground="-13421773"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<Attr4VanChart useHtml="true" floating="false" x="0.0" y="0.0" limitSize="false" maxHeight="15.0"/>
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
<Attr lineStyle="0" isRoundBorder="false" roundRadius="5"/>
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
<Attr class="com.fr.plugin.chart.base.AttrLabel">
<AttrLabel>
<labelAttr enable="true"/>
<labelDetail class="com.fr.plugin.chart.base.AttrLabelDetail">
<Attr showLine="false" autoAdjust="true" position="6" isCustom="true"/>
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
<OColor colvalue="-4390903"/>
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
<newLineColor lineColor="-1513240"/>
<AxisPosition value="3"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr rotation="-45" alignText="0">
<FRFont name="Verdana" style="0" size="56" foreground="-10066330"/>
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
<newLineColor mainGridColor="-1" lineColor="-5197648"/>
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
</YAxisList>
<stackAndAxisCondition>
<ConditionCollection>
<DefaultAttr class="com.fr.chart.chartglyph.ConditionAttr">
<ConditionAttr name=""/>
</DefaultAttr>
</ConditionCollection>
</stackAndAxisCondition>
<VanChartColumnPlotAttr seriesOverlapPercent="20.0" categoryIntervalPercent="20.0" fixedWidth="true" columnWidth="20" filledWithImage="false" isBar="false"/>
</Plot>
<ChartDefinition>
<MoreNameCDDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="true" isDiscardOtherSeries="true" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[9ZJQJ]]></Name>
</TableData>
<CategoryName value="ZJ"/>
<ChartSummaryColumn name="ZJQJ" function="com.fr.data.util.function.NoneFunction" customName="职级人数"/>
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
<Chart name="图表3" chartClass="com.fr.plugin.chart.vanchart.VanChart">
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
<![CDATA[="职能序列分布"+if(and(len(lab)==0,len(lab1)==0),'(总体)',"")+if(len(lab)==0,'',"("+$lab+")")+if(len(lab1)==0,'',if(lab1="是","(常青藤)","("+$lab1+")"))]]></Attributes>
</O>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="56" foreground="-13421773"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<Attr4VanChart useHtml="true" floating="false" x="0.0" y="0.0" limitSize="false" maxHeight="15.0"/>
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
<Attr lineStyle="0" isRoundBorder="false" roundRadius="5"/>
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
<Attr class="com.fr.plugin.chart.base.AttrLabel">
<AttrLabel>
<labelAttr enable="true"/>
<labelDetail class="com.fr.plugin.chart.base.AttrLabelDetail">
<Attr showLine="false" autoAdjust="true" position="6" isCustom="true"/>
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
<OColor colvalue="-4390903"/>
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
<newLineColor lineColor="-1513240"/>
<AxisPosition value="3"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr rotation="-45" alignText="0">
<FRFont name="微软雅黑" style="0" size="56" foreground="-10066330"/>
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
<newLineColor mainGridColor="-1" lineColor="-5197648"/>
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
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[11ZNXL]]></Name>
</TableData>
<CategoryName value="ZHINENGXULIE"/>
<ChartSummaryColumn name="RS" function="com.fr.data.util.function.NoneFunction" customName="人数"/>
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
</InnerWidget>
<BoundsAttr x="0" y="36" width="250" height="114"/>
</Widget>
<body class="com.fr.form.ui.ChartEditor">
<WidgetName name="chart1"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="1" color="-3355444" borderRadius="0" type="1" borderStyle="0"/>
<WidgetTitle>
<O>
<![CDATA[< 历史用工趋势图 >]]></O>
<FRFont name="宋体" style="0" size="72"/>
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
<Plot class="com.fr.plugin.chart.line.VanChartLinePlot">
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
<Attr lineWidth="2" lineStyle="0" nullValueBreak="true"/>
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
</YAxisList>
<stackAndAxisCondition>
<ConditionCollection>
<DefaultAttr class="com.fr.chart.chartglyph.ConditionAttr">
<ConditionAttr name=""/>
</DefaultAttr>
</ConditionCollection>
</stackAndAxisCondition>
</Plot>
<ChartDefinition>
<MoreNameCDDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[1lishi]]></Name>
</TableData>
<CategoryName value="EMPID"/>
<ChartSummaryColumn name="HEIGHT" function="com.fr.data.util.function.NoneFunction" customName="HEIGHT"/>
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
</body>
</InnerWidget>
<BoundsAttr x="7" y="191" width="351" height="210"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.FreeButton">
<Listener event="click">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[$("input[name=LAB1]A").val("")

 $("input[name=LAB]A").val("主营")
 _g().parameterCommit();]]></Content>
</JavaScript>
</Listener>
<WidgetName name="button1_c_c_c_c_c"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Text>
<![CDATA[]]></Text>
<IconName>
<![CDATA[主营2]]></IconName>
<isCustomType isCustomType="true"/>
</InnerWidget>
<BoundsAttr x="251" y="71" width="11" height="17"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="ZY_c_c"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(or(value("2ZY",4,1)=0,len(value("2ZY",4,1))==0),"0",value("2ZY",4,1))]]></Attributes>
</O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="2" autoline="true"/>
<FRFont name="微软雅黑" style="1" size="96" foreground="-4259840"/>
<border style="0" color="-723724"/>
</InnerWidget>
<BoundsAttr x="271" y="91" width="79" height="19"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<Listener event="click">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[$("input[name=LAB1]A").val("")
 $("input[name=LAB]A").val("主营(不含财务)")
/*var self1 =this.options.form.getWidgetByName("LAB1");   
self1.setValue(null);
var self =this.options.form.getWidgetByName("LAB");   
self.setValue('非主营');
self.editComp.focus();
var myFocusID = setInterval(  
    function()   
    {   

    }, 20); 
    */

    
        _g().parameterCommit();]]></Content>
</JavaScript>
</Listener>
<Listener event="click">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[$.each($(".ui-state-enabled"),function(i, v){
if(
$(v).attr("widgetname")=="LAB111"
||$(v).attr("widgetname")=="LAB222"
||$(v).attr("widgetname")=="LAB444"
||$(v).attr("widgetname")=="LAB555"
||$(v).attr("widgetname")=="LAB333"
){
$(v).find(".fr-label").css("color","#120eec");
//$(v).find(".fr-label").css("font-size","12PX");
}
});
$.each($(".ui-state-enabled"),function(i, v){
if(
$(v).attr("widgetname")=="LAB666"
){
$(v).find(".fr-label").css("color","#bf0000");
//$(v).find(".fr-label").css("font-size","18PX");
}
});]]></Content>
</JavaScript>
</Listener>
<WidgetName name="lab666"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O>
<![CDATA[主营(不含财务)]]></O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="2" noWrap="true" autoline="true"/>
<FRFont name="微软雅黑" style="0" size="72" foreground="-13421773" underline="1"/>
<border style="0" color="-723724"/>
</InnerWidget>
<BoundsAttr x="271" y="69" width="79" height="20"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.FreeButton">
<Listener event="click">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[ $("input[name=LAB]A").val("")
 $("input[name=LAB1]A").val("常青藤")
 _g().parameterCommit();]]></Content>
</JavaScript>
</Listener>
<WidgetName name="button1_c_c_c"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Text>
<![CDATA[]]></Text>
<IconName>
<![CDATA[常青藤2]]></IconName>
<isCustomType isCustomType="true"/>
</InnerWidget>
<BoundsAttr x="138" y="135" width="11" height="17"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.FreeButton">
<Listener event="click">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[$("input[name=LAB1]A").val("")

 $("input[name=LAB]A").val("非主营")
 _g().parameterCommit();]]></Content>
</JavaScript>
</Listener>
<WidgetName name="button1_c_c"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Text>
<![CDATA[]]></Text>
<IconName>
<![CDATA[非主营2]]></IconName>
<isCustomType isCustomType="true"/>
</InnerWidget>
<BoundsAttr x="133" y="70" width="11" height="17"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.FreeButton">
<Listener event="click">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[
 $("input[name=LAB]A").val("")
 $("input[name=LAB1]A").val("干部")
 _g().parameterCommit();]]></Content>
</JavaScript>
</Listener>
<WidgetName name="button1_c"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Text>
<![CDATA[]]></Text>
<IconName>
<![CDATA[干部2]]></IconName>
<isCustomType isCustomType="true"/>
</InnerWidget>
<BoundsAttr x="19" y="135" width="11" height="17"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.FreeButton">
<Listener event="click">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[$("input[name=LAB1]A").val("")

 $("input[name=LAB]A").val("主营")
 _g().parameterCommit();]]></Content>
</JavaScript>
</Listener>
<WidgetName name="button1"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Text>
<![CDATA[]]></Text>
<IconName>
<![CDATA[主营2]]></IconName>
<isCustomType isCustomType="true"/>
</InnerWidget>
<BoundsAttr x="19" y="70" width="11" height="17"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.FreeButton">
<WidgetName name="AAA1111"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Text>
<![CDATA[]]></Text>
<initial>
<Background name="ColorBackground" color="-4144960"/>
</initial>
<isCustomType isCustomType="true"/>
</InnerWidget>
<BoundsAttr x="6" y="183" width="362" height="2"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="label5_c"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(or(value("4GB",3,1)=0,len(value("4GB",3,1))==0),"0",value("4GB",3,1))]]></Attributes>
</O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="2" autoline="true"/>
<FRFont name="微软雅黑" style="1" size="96" foreground="-4259840"/>
<border style="0" color="-723724"/>
</InnerWidget>
<BoundsAttr x="157" y="156" width="79" height="19"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<Listener event="click">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[$("input[name=LAB]A").val("")
 $("input[name=LAB1]A").val("常青藤")
/*
var self1 =this.options.form.getWidgetByName("LAB");   
self1.setValue(null);
var self =this.options.form.getWidgetByName("LAB1");   

self.setValue('是');

self.editComp.focus();
var myFocusID = setInterval(  
    function()   
    {   

    }, 20); 
    */
      _g().parameterCommit();  ]]></Content>
</JavaScript>
</Listener>
<Listener event="click">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[$.each($(".ui-state-enabled"),function(i, v){
if(
$(v).attr("widgetname")=="LAB111"
||$(v).attr("widgetname")=="LAB222"
||$(v).attr("widgetname")=="LAB333"
||$(v).attr("widgetname")=="LAB444"
||$(v).attr("widgetname")=="LAB666"
){
$(v).find(".fr-label").css("color","#120eec");
//$(v).find(".fr-label").css("font-size","12PX");
}
});
$.each($(".ui-state-enabled"),function(i, v){
if(
$(v).attr("widgetname")=="LAB555"
){
$(v).find(".fr-label").css("color","#bf0000");
//$(v).find(".fr-label").css("font-size","18PX");
}
});]]></Content>
</JavaScript>
</Listener>
<WidgetName name="lab555"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O>
<![CDATA[常青藤]]></O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="2" autoline="true"/>
<FRFont name="微软雅黑" style="0" size="72" foreground="-13421773" underline="1"/>
<border style="0" color="-723724"/>
</InnerWidget>
<BoundsAttr x="157" y="134" width="49" height="20"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ComboBox">
<Listener event="afteredit">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="DWMC"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$DWMC]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[/*-----------平均年龄------------*/
var self1 =this.options.form.getWidgetByName("LABEL22"); 
var lab=this.options.form.getWidgetByName("lab").getValue(); 
var lab1=this.options.form.getWidgetByName("lab1").getValue(); 
if(lab1.length==0 ){
	var labab1="1=1"
	}
	else if (lab1=="干部"){
		var labab1="YGFENLEI='干部'"
		}
		else 
		{
		var labab1="ISCQT='是' and ISZHUYING='主营' "}
	

var sql="SELECT  REPLACE(TO_CHAR(ROUND(SUM((SYSDATE-CSDATE)/365)/COUNT(YGID),1),'9990.0'),' ','') AS PJNL FROM ODM_HR_YGTZ  WHERE 1=1  AND "+labab1+" and TREE_NODE_ID LIKE '%"+DWMC+",%'"
 var res=FR.remoteEvaluate("=sql(\"HXXF_HR\",\""+sql+"\",1)");

if(res.length == 0){
	var res1="0"

	self1.setValue(res1);
	}
 else{self1.setValue(res);}]]></Content>
</JavaScript>
</Listener>
<Listener event="afteredit">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="DWMC"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$DWMC]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[var self1 =this.options.form.getWidgetByName("LABEL23"); 
/*--------本科及以上--------*/
var lab=this.options.form.getWidgetByName("lab").getValue(); 
var lab1=this.options.form.getWidgetByName("lab1").getValue(); 
if(lab1.length==0 ){
	var labab1="1=1"
	}
	else if (lab1=="干部"){
		var labab1="YGFENLEI='干部'"
		}
		else 
		{
		var labab1="ISCQT='是' and ISZHUYING='主营'"}

var sql="SELECT   REPLACE(TO_CHAR(ROUND(COUNT(CASE WHEN  XUELIFENLEI  LIKE '%本科%' or XUELIFENLEI  LIKE '%硕士%' or XUELIFENLEI  LIKE '%博士%' THEN YGID END)/COUNT(CASE WHEN 1=1 THEN YGID END)*100,1),'9990.0'),' ','') ||'%' AS BK FROM ODM_HR_YGTZ  WHERE 1=1  AND zhiji NOT LIKE '99%' AND "+labab1+" and TREE_NODE_ID LIKE '%"+DWMC+",%'"
 var res=FR.remoteEvaluate("=sql(\"HXXF_HR\",\""+sql+"\",1)");

if(res.length == 0){
	var res1="0"

	self1.setValue(res1);
	}
 else{self1.setValue(res);}]]></Content>
</JavaScript>
</Listener>
<Listener event="afteredit">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="DWMC"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$DWMC]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[/* -------------平均职级----------*/
var self1 =this.options.form.getWidgetByName("LABEL24"); 
var lab=this.options.form.getWidgetByName("lab").getValue(); 
var lab1=this.options.form.getWidgetByName("lab1").getValue(); 
if(lab1.length==0 ){
	var labab1="1=1"
	}
	else if (lab1=="干部"){
		var labab1="YGFENLEI='干部'"
		}
		else 
		{
		var labab1="ISCQT='是' and ISZHUYING='主营' "}

var sql="SELECT  REPLACE(TO_CHAR(ROUND(SUM(REPLACE(ZHIJI,'级',''))/COUNT(CASE WHEN 1=1 THEN YGID END),1),'9990.0'),' ','')  AS PJZJ FROM ODM_HR_YGTZ WHERE ZHIJI<>'级' AND "+labab1+" and TREE_NODE_ID LIKE '%"+DWMC+",%'"
 var res=FR.remoteEvaluate("=sql(\"HXXF_HR\",\""+sql+"\",1)");

if(res.length == 0){
	var res1="0"

	self1.setValue(res1);
	}
 else{self1.setValue(res);}]]></Content>
</JavaScript>
</Listener>
<Listener event="afteredit">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="DWMC"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$DWMC]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[/* -------------平均司龄----------*/
var self1 =this.options.form.getWidgetByName("LABEL25"); 
var lab=this.options.form.getWidgetByName("lab").getValue(); 
var lab1=this.options.form.getWidgetByName("lab1").getValue(); 
if(lab1.length==0 ){
	var labab1="1=1"
	}
	else if (lab1=="干部"){
		var labab1="YGFENLEI='干部'"
		}
		else 
		{
		var labab1="ISCQT='是' and ISZHUYING='主营'"}
		 
var sql="SELECT  REPLACE(TO_CHAR(ROUND(SUM(SILING)/COUNT(YGID),1),'9990.0'),' ','')  AS PJSL FROM ODM_HR_YGTZ WHERE 1=1 AND "+labab1+"  and TREE_NODE_ID LIKE '%"+DWMC+",%'"
 var res=FR.remoteEvaluate("=sql(\"HXXF_HR\",\""+sql+"\",1)");

if(res.length == 0){
	var res1="0"

	self1.setValue(res1);
	}
 else{self1.setValue(res);}]]></Content>
</JavaScript>
</Listener>
<WidgetName name="lab1"/>
<WidgetAttr invisible="true" description="">
<PrivilegeControl/>
</WidgetAttr>
<widgetValue/>
</InnerWidget>
<BoundsAttr x="288" y="7" width="129" height="17"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ComboBox">
<Listener event="afteredit">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="DWMC"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$DWMC]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[/*------平均年龄-----*/
var self1 =this.options.form.getWidgetByName("LABEL22"); 
var lab=this.options.form.getWidgetByName("lab").getValue(); 
if(lab.length==0 ){
	var labab="1=1"
	}
	else if (lab=="主营"){
		var labab="ISZHUYING='主营'"
		}
		else
		{
		var labab="ISZHUYING<>'主营'"
			};


var sql="SELECT   REPLACE(TO_CHAR(ROUND(SUM((SYSDATE-CSDATE)/365)/COUNT(YGID),1),'9990.0'),' ','') AS PJNL FROM ODM_HR_YGTZ  WHERE 1=1  AND "+labab+" and TREE_NODE_ID LIKE '%"+DWMC+",%'"
 var res=FR.remoteEvaluate("=sql(\"HXXF_HR\",\""+sql+"\",1)");
if(res.length == 0){
	var res1="0"

	self1.setValue(res1);
	}
 else{self1.setValue(res);}]]></Content>
</JavaScript>
</Listener>
<Listener event="afteredit">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="DWMC"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$DWMC]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[/*--------本科及以上--------*/
var self1 =this.options.form.getWidgetByName("LABEL23"); 
 var lab=this.options.form.getWidgetByName("lab").getValue(); 
var lab1=this.options.form.getWidgetByName("lab1").getValue(); 
if(lab.length==0 ){
	var labab="1=1"
	}
	else if (lab=="主营"){
		var labab="ISZHUYING='主营'"
		}
		else
		{
		var labab="ISZHUYING<>'主营'"
			};

			
var sql="SELECT  REPLACE(TO_CHAR(ROUND(COUNT(CASE WHEN  XUELIFENLEI  LIKE '%本科%' or XUELIFENLEI  LIKE '%硕士%' or XUELIFENLEI  LIKE '%博士%' THEN YGID END)/COUNT(CASE WHEN 1=1 THEN YGID END)*100,1),'9990.0'),' ','') ||'%' AS BK FROM ODM_HR_YGTZ  WHERE 1=1 AND zhiji NOT LIKE '99%' AND "+labab+" and TREE_NODE_ID LIKE '%"+DWMC+",%'"
 var res=FR.remoteEvaluate("=sql(\"HXXF_HR\",\""+sql+"\",1)");

if(res.length == 0){
	var res1="0"

	self1.setValue(res1);
	}
 else{self1.setValue(res);}]]></Content>
</JavaScript>
</Listener>
<Listener event="afteredit">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="DWMC"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$DWMC]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[/* -------------平均职级----------*/
var self1 =this.options.form.getWidgetByName("LABEL24"); 
var lab=this.options.form.getWidgetByName("lab").getValue(); 
var lab1=this.options.form.getWidgetByName("lab1").getValue(); 
if(lab.length==0 ){
	var labab="1=1"
	}
	else if (lab=="主营"){
		var labab="ISZHUYING='主营'"
		}
		else
		{
		var labab="ISZHUYING like '%非主营%'"
			};

var sql="SELECT  REPLACE(TO_CHAR(ROUND(SUM(REPLACE(ZHIJI,'级',''))/COUNT(CASE WHEN 1=1 THEN YGID END),1),'9990.0'),' ','')  AS PJZJ FROM ODM_HR_YGTZ WHERE ZHIJI<>'级' AND "+labab+" and TREE_NODE_ID LIKE '%"+DWMC+",%'"
 var res=FR.remoteEvaluate("=sql(\"HXXF_HR\",\""+sql+"\",1)");

if(res.length == 0){
	var res1="0"

	self1.setValue(res1);
	}
 else{self1.setValue(res);}]]></Content>
</JavaScript>
</Listener>
<Listener event="afteredit">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="DWMC"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$DWMC]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[/* -------------平均司龄----------*/
var self1 =this.options.form.getWidgetByName("LABEL25"); 
var lab=this.options.form.getWidgetByName("lab").getValue(); 
var lab1=this.options.form.getWidgetByName("lab1").getValue(); 
if(lab.length==0 ){
	var labab="1=1"
	}
	else if (lab=="主营"){
		var labab="ISZHUYING='主营'"
		}
		else
		{
		var labab="ISZHUYING like '%非主营%'"
			};

var sql="SELECT   REPLACE(TO_CHAR(ROUND(SUM(SILING)/COUNT(YGID),1),'9990.0'),' ','') AS PJSL FROM ODM_HR_YGTZ WHERE 1=1 AND "+labab+" and TREE_NODE_ID LIKE '%"+DWMC+",%'"
 var res=FR.remoteEvaluate("=sql(\"HXXF_HR\",\""+sql+"\",1)");
if(res.length == 0){
	var res1="0"

	self1.setValue(res1);
	}
 else{self1.setValue(res);}]]></Content>
</JavaScript>
</Listener>
<WidgetName name="lab"/>
<WidgetAttr invisible="true" description="">
<PrivilegeControl/>
</WidgetAttr>
<widgetValue/>
</InnerWidget>
<BoundsAttr x="141" y="7" width="117" height="17"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="label2_c_c"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(or(value("4GB",2,1)=0,len(value("4GB",2,1))==0),"0",value("4GB",2,1))]]></Attributes>
</O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="2" autoline="true"/>
<FRFont name="微软雅黑" style="1" size="96" foreground="-4259840"/>
<border style="0" color="-723724"/>
</InnerWidget>
<BoundsAttr x="38" y="156" width="79" height="19"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<Listener event="click">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[$("input[name=LAB]A").val("")
 $("input[name=LAB1]A").val("干部")
/*
var self1 =this.options.form.getWidgetByName("LAB");   
self1.setValue(null);
var self =this.options.form.getWidgetByName("LAB1");   

self.setValue('干部');

self.editComp.focus();
var myFocusID = setInterval(  
    function()   
    {   

    }, 20); 
    */
     _g().parameterCommit();   ]]></Content>
</JavaScript>
</Listener>
<Listener event="click">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[$.each($(".ui-state-enabled"),function(i, v){
if(
$(v).attr("widgetname")=="LAB111"
||$(v).attr("widgetname")=="LAB222"
||$(v).attr("widgetname")=="LAB333"
||$(v).attr("widgetname")=="LAB555"
||$(v).attr("widgetname")=="LAB666"
){
$(v).find(".fr-label").css("color","#120eec");
//$(v).find(".fr-label").css("font-size","12PX");
}
});
$.each($(".ui-state-enabled"),function(i, v){
if(
$(v).attr("widgetname")=="LAB444"
){
$(v).find(".fr-label").css("color","#bf0000");
//$(v).find(".fr-label").css("font-size","18PX");
}
});]]></Content>
</JavaScript>
</Listener>
<WidgetName name="lab444"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O>
<![CDATA[干部]]></O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="2" autoline="true"/>
<FRFont name="微软雅黑" style="0" size="72" foreground="-13421773" underline="1"/>
<border style="0" color="-723724"/>
</InnerWidget>
<BoundsAttr x="38" y="134" width="49" height="20"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<Listener event="click">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[$("input[name=LAB1]A").val("")
 $("input[name=LAB]A").val("非主营")
/*var self1 =this.options.form.getWidgetByName("LAB1");   
self1.setValue(null);
var self =this.options.form.getWidgetByName("LAB");   
self.setValue('非主营');
self.editComp.focus();
var myFocusID = setInterval(  
    function()   
    {   

    }, 20); 
    */
        _g().parameterCommit();]]></Content>
</JavaScript>
</Listener>
<Listener event="click">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[$.each($(".ui-state-enabled"),function(i, v){
if(
$(v).attr("widgetname")=="LAB111"
||$(v).attr("widgetname")=="LAB222"
||$(v).attr("widgetname")=="LAB444"
||$(v).attr("widgetname")=="LAB555"
||$(v).attr("widgetname")=="LAB666"
){
$(v).find(".fr-label").css("color","#120eec");
//$(v).find(".fr-label").css("font-size","12PX");
}
});
$.each($(".ui-state-enabled"),function(i, v){
if(
$(v).attr("widgetname")=="LAB333"
){
$(v).find(".fr-label").css("color","#bf0000");
//$(v).find(".fr-label").css("font-size","18PX");
}
});]]></Content>
</JavaScript>
</Listener>
<WidgetName name="lab333"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O>
<![CDATA[非主营]]></O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="2" autoline="true"/>
<FRFont name="微软雅黑" style="0" size="72" foreground="-13421773" underline="1"/>
<border style="0" color="-723724"/>
</InnerWidget>
<BoundsAttr x="157" y="69" width="79" height="20"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="FZY"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(or(value("2ZY",3,1)=0,len(value("2ZY",3,1))==0),"0",value("2ZY",3,1))]]></Attributes>
</O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="2" autoline="true"/>
<FRFont name="微软雅黑" style="1" size="96" foreground="-4259840"/>
<border style="0" color="-723724"/>
</InnerWidget>
<BoundsAttr x="157" y="91" width="79" height="19"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="ZY"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(or(value("2ZY",2,1)=0,len(value("2ZY",2,1))==0),"0",value("2ZY",2,1))]]></Attributes>
</O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="2" autoline="true"/>
<FRFont name="微软雅黑" style="1" size="96" foreground="-4259840"/>
<border style="0" color="-723724"/>
</InnerWidget>
<BoundsAttr x="38" y="91" width="79" height="19"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<Listener event="click">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[
$("input[name=LAB1]A").val("")
 $("input[name=LAB]A").val("主营(含财务)")
/*var self1 =this.options.form.getWidgetByName("LAB1");   
self1.setValue(null);
var self =this.options.form.getWidgetByName("LAB");   

self.setValue('主营');


self.editComp.focus();
var myFocusID = setInterval(  
    function()   
    {   

    }, 20); */
        _g().parameterCommit();]]></Content>
</JavaScript>
</Listener>
<Listener event="click">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[$.each($(".ui-state-enabled"),function(i, v){
if(
$(v).attr("widgetname")=="LAB222"
||$(v).attr("widgetname")=="LAB333"
||$(v).attr("widgetname")=="LAB444"
||$(v).attr("widgetname")=="LAB555"
||$(v).attr("widgetname")=="LAB666"
){
$(v).find(".fr-label").css("color","#120eec");
//$(v).find(".fr-label").css("font-size","12PX");
}
});
$.each($(".ui-state-enabled"),function(i, v){
if(
$(v).attr("widgetname")=="LAB111"
){
$(v).find(".fr-label").css("color","#bf0000");
//$(v).find(".fr-label").css("font-size","18PX");
}
});]]></Content>
</JavaScript>
</Listener>
<WidgetName name="lab222"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O>
<![CDATA[主营(含财务)]]></O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="2" autoline="true"/>
<FRFont name="微软雅黑" style="0" size="72" foreground="-15593748" underline="1"/>
<border style="0" color="-723724"/>
</InnerWidget>
<BoundsAttr x="38" y="69" width="79" height="20"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="HZS"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(or(value("1HZS",1,1)=0,len(value("1HZS",1,1))==0),"0",value("1HZS",1,1))]]></Attributes>
</O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="2" autoline="true"/>
<FRFont name="微软雅黑" style="1" size="112" foreground="-4259840"/>
<border style="0" color="-723724"/>
</InnerWidget>
<BoundsAttr x="55" y="36" width="62" height="26"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<Listener event="click">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="qq"/>
<O>
<![CDATA[q]]></O>
</Parameter>
</Parameters>
<Content>
<![CDATA[
$("input[name=LAB1]A").val("")
 $("input[name=LAB]A").val("")
/*var self1 =this.options.form.getWidgetByName("LAB1");   
self1.setValue(null);
var self =this.options.form.getWidgetByName("LAB");   
self.setValue(null);


var myFocusID = setInterval(  
    function()   
    {   

    }, 20); 
*/
    _g().parameterCommit();]]></Content>
</JavaScript>
</Listener>
<Listener event="click">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[$.each($(".ui-state-enabled"),function(i, v){
if(
$(v).attr("widgetname")=="LAB222"
||$(v).attr("widgetname")=="LAB333"
||$(v).attr("widgetname")=="LAB444"
||$(v).attr("widgetname")=="LAB555"
||$(v).attr("widgetname")=="LAB666"
){
$(v).find(".fr-label").css("color","#120eec");
//$(v).find(".fr-label").css("font-size","12PX");
}
});
$.each($(".ui-state-enabled"),function(i, v){
if(
$(v).attr("widgetname")=="LAB111"
){
$(v).find(".fr-label").css("color","#bf0000");
//$(v).find(".fr-label").css("font-size","18PX");
}
});]]></Content>
</JavaScript>
</Listener>
<WidgetName name="lab111"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O>
<![CDATA[员工总数]]></O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="2" autoline="true"/>
<FRFont name="微软雅黑" style="0" size="80" foreground="-15593748" underline="1"/>
<border style="0" color="-723724"/>
</InnerWidget>
<BoundsAttr x="11" y="36" width="62" height="26"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="label0"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O>
<![CDATA[人员总体情况]]></O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="2" autoline="true"/>
<FRFont name="微软雅黑" style="1" size="80" foreground="-13421773"/>
<border style="0" color="-723724"/>
</InnerWidget>
<BoundsAttr x="11" y="0" width="316" height="26"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="label0"/>
<Widget widgetName="lab"/>
<Widget widgetName="lab1"/>
<Widget widgetName="lab111"/>
<Widget widgetName="HZS"/>
<Widget widgetName="lab222"/>
<Widget widgetName="lab333"/>
<Widget widgetName="lab666"/>
<Widget widgetName="button1"/>
<Widget widgetName="button1_c_c"/>
<Widget widgetName="button1_c_c_c_c_c"/>
<Widget widgetName="ZY"/>
<Widget widgetName="FZY"/>
<Widget widgetName="ZY_c_c"/>
<Widget widgetName="lab444"/>
<Widget widgetName="lab555"/>
<Widget widgetName="button1_c"/>
<Widget widgetName="label2_c_c"/>
<Widget widgetName="label5_c"/>
<Widget widgetName="button1_c_c_c"/>
<Widget widgetName="AAA1111"/>
<Widget widgetName="chart1_c_c_c_c"/>
<Widget widgetName="report0"/>
</MobileWidgetList>
<WidgetScalingAttr compState="0"/>
<DesignResolution absoluteResolutionScaleW="1366" absoluteResolutionScaleH="768"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="420" height="700"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="absolute0"/>
</MobileWidgetList>
<WidgetZoomAttr compState="0"/>
<AppRelayout appRelayout="true"/>
<Size width="420" height="700"/>
<ResolutionScalingAttr percent="0.9"/>
<BodyLayoutType type="0"/>
</Center>
</Layout>
<DesignerVersion DesignerVersion="IAA"/>
<PreviewType PreviewType="0"/>
<TemplateID TemplateID="79dd1987-6792-4a5f-b884-ff5a75a4a2a4"/>
</Form>
