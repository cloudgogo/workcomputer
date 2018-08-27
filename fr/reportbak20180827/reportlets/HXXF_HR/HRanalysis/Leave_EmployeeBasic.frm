<?xml version="1.0" encoding="UTF-8"?>
<Form xmlVersion="20170715" releaseVersion="8.0.0">
<TableDataMap>
<TableData name="离职平均职级分布" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="seadate"/>
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
avg(substr(zhiji,0,2)) AS ZHIJI,
'总体'AS LZLEIXING
FROM ODM_HR_LZTZ
WHERE 1=1
${if(len(seadate)==0 ,
"AND TO_CHAR(LZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(LZDATE,'YYYY') = '"+seadate+"'")}
AND LZLEIXING NOT LIKE '实习期结束'
AND zhiji not like '99%' 
AND ISZHUYING NOT LIKE '%实习生%'
AND YGLEIBIE NOT LIKE '%实习生%'
AND TO_CHAR(LZDATE,'YYYYMMDD')<TO_CHAR(SYSDATE,'YYYYMMDD')
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}
UNION ALL
SELECT
ZHIJI,
'总体-'||LZLEIXING AS LZLEIXING
FROM(
SELECT 
avg(substr(zhiji,0,2)) AS ZHIJI,
LZLEIXING
FROM ODM_HR_LZTZ
WHERE 1=1
${if(len(seadate)==0 ,
"AND TO_CHAR(LZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(LZDATE,'YYYY') = '"+seadate+"'")}
AND LZLEIXING NOT LIKE '实习期结束'
AND zhiji not like '99%'
AND ISZHUYING NOT LIKE '%实习生%'
AND YGLEIBIE NOT LIKE '%实习生%' 
AND TO_CHAR(LZDATE,'YYYYMMDD')<TO_CHAR(SYSDATE,'YYYYMMDD')
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}
GROUP BY LZLEIXING ORDER BY LZLEIXING)
UNION ALL
SELECT 0,
	'  ' 
  FROM ODM_HR_LZTZ
 GROUP BY ' ',' '
UNION ALL
SELECT 
avg(substr(zhiji,0,2)) AS ZHIJI,
'主营'AS LZLEIXING
FROM ODM_HR_LZTZ
WHERE 1=1
AND ISZHUYING LIKE '主营%'
${if(len(seadate)==0 ,
"AND TO_CHAR(LZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(LZDATE,'YYYY') = '"+seadate+"'")}
AND LZLEIXING NOT LIKE '实习期结束'
AND zhiji not like '99%'
AND ISZHUYING NOT LIKE '%实习生%'
AND YGLEIBIE NOT LIKE '%实习生%' 
AND TO_CHAR(LZDATE,'YYYYMMDD')<TO_CHAR(SYSDATE,'YYYYMMDD')
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}
UNION ALL
SELECT
ZHIJI,
'主营-'||LZLEIXING AS LZLEIXING
FROM(
SELECT 
avg(substr(zhiji,0,2)) AS ZHIJI,
LZLEIXING
FROM ODM_HR_LZTZ
WHERE 1=1
AND ISZHUYING LIKE '主营%'
${if(len(seadate)==0 ,
"AND TO_CHAR(LZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(LZDATE,'YYYY') = '"+seadate+"'")}
AND LZLEIXING NOT LIKE '实习期结束'
AND zhiji not like '99%' 
AND ISZHUYING NOT LIKE '%实习生%'
AND YGLEIBIE NOT LIKE '%实习生%'
AND TO_CHAR(LZDATE,'YYYYMMDD')<TO_CHAR(SYSDATE,'YYYYMMDD')
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}
GROUP BY LZLEIXING ORDER BY LZLEIXING)
UNION ALL
SELECT 0,
	'   ' 
  FROM ODM_HR_LZTZ
 GROUP BY ' ',' '
UNION ALL
SELECT 
avg(substr(zhiji,0,2)) AS ZHIJI,
'非主营'AS LZLEIXING
FROM ODM_HR_LZTZ
WHERE 1=1
${if(len(seadate)==0 ,
"AND TO_CHAR(LZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(LZDATE,'YYYY') = '"+seadate+"'")}
AND ISZHUYING LIKE '非主营%'
AND LZLEIXING NOT LIKE '实习期结束'
AND zhiji not like '99%' 
AND ISZHUYING NOT LIKE '%实习生%'
AND YGLEIBIE NOT LIKE '%实习生%'
AND TO_CHAR(LZDATE,'YYYYMMDD')<TO_CHAR(SYSDATE,'YYYYMMDD')
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}
UNION ALL
SELECT
ZHIJI,
'非主营-'||LZLEIXING  AS LZLEIXING
FROM(
SELECT 
avg(substr(zhiji,0,2)) AS ZHIJI,
LZLEIXING
FROM ODM_HR_LZTZ
WHERE 1=1
${if(len(seadate)==0 ,
"AND TO_CHAR(LZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(LZDATE,'YYYY') = '"+seadate+"'")}
AND LZLEIXING NOT LIKE '实习期结束'
AND ISZHUYING LIKE '非主营%'
AND TO_CHAR(LZDATE,'YYYYMMDD')<TO_CHAR(SYSDATE,'YYYYMMDD')
AND zhiji not like '99%' 
AND ISZHUYING NOT LIKE '%实习生%'
AND YGLEIBIE NOT LIKE '%实习生%'
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}
GROUP BY LZLEIXING ORDER BY LZLEIXING)]]></Query>
</TableData>
<TableData name="离职原因分布" class="com.fr.data.impl.DBTableData">
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
<![CDATA[SELECT 
count(YGID) AS RENSHU,
CASE WHEN LZYUANYIN IS NULL THEN '其它'
ELSE LZYUANYIN END AS LZYUANYIN
FROM ODM_HR_LZTZ
WHERE 1=1
AND TO_CHAR(LZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')
AND TO_CHAR(LZDATE,'YYYYMMDD')<TO_CHAR(SYSDATE,'YYYYMMDD')
AND LZLEIXING <> '实习期结束'
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}
${SWITCH(FENLEI,'',"",'总体',"",'总体-辞职',"AND LZLEIXING='辞职'",'总体-辞职',"AND LZLEIXING='辞退'",'主营'," AND ISZHUYING  ='主营'",'主营-辞职',"AND LZLEIXING='辞职' AND ISZHUYING  ='主营'",'主营-辞退',"AND LZLEIXING='辞退' AND ISZHUYING  ='主营'",'非主营'," AND ISZHUYING !='主营'",'非主营-辞职',"AND LZLEIXING='辞职' AND ISZHUYING !='主营'",'非主营-辞退',"AND LZLEIXING='辞退' AND ISZHUYING !='主营'")}
GROUP BY LZYUANYIN]]></Query>
</TableData>
<TableData name="05-18级离职人数" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="FENLEI"/>
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
COUNT(YGID) AS RENSHU,
'本年度骨干员工离职' AS FENLEI
FROM ODM_HR_LZTZ 
WHERE 1=1
AND TO_CHAR(LZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')
AND TO_CHAR(LZDATE,'YYYYMMDD')<TO_CHAR(SYSDATE,'YYYYMMDD')
AND LZLEIXING NOT LIKE '实习期结束'
AND ZHIJI BETWEEN '05级' AND '18级'
${SWITCH(FENLEI,'',"",'总体',"",'总体-辞职',"AND LZLEIXING='辞职'",'总体-辞退',"AND LZLEIXING='辞退'",'主营'," AND ISZHUYING  ='主营'",'主营-辞职',"AND LZLEIXING='辞职' AND ISZHUYING  ='主营'",'主营-辞退',"AND LZLEIXING='辞退' AND ISZHUYING  ='主营'",'非主营'," AND ISZHUYING !='主营'",'非主营-辞职',"AND LZLEIXING='辞职' AND ISZHUYING !='主营'",'非主营-辞退',"AND LZLEIXING='辞退' AND ISZHUYING !='主营'")}]]></Query>
</TableData>
<TableData name="主动离职平均职级（主营）" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="seadate"/>
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
	CASE WHEN avg(substr(zhiji,0,2)) IS NULL THEN 0
ELSE avg(substr(zhiji,0,2)) END AS ZHIJI
FROM ODM_HR_LZTZ
WHERE 1=1
${if(len(seadate)==0 ,
"AND TO_CHAR(LZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(LZDATE,'YYYY') = '"+seadate+"'")}
AND ISZHUYING  ='主营'
AND zhiji not like '99%' 
AND LZLEIXING='辞职'
AND ISZHUYING NOT LIKE '%实习生%'
AND YGLEIBIE NOT LIKE '%实习生%'
AND TO_CHAR(LZDATE,'YYYYMMDD')<TO_CHAR(SYSDATE,'YYYYMMDD')
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}]]></Query>
</TableData>
<TableData name="主动离本科及以上占比" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="seadate"/>
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
CASE WHEN A.RENSHU=0 THEN 0
ELSE B.RENSHU/A.RENSHU END AS ZHANBI
FROM
(SELECT 
count(YGID) AS RENSHU
FROM ODM_HR_LZTZ
WHERE 1=1
${if(len(seadate)==0 ,
"AND TO_CHAR(LZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(LZDATE,'YYYY') = '"+seadate+"'")}
AND ISZHUYING  ='主营'
AND LZLEIXING='辞职'
AND TO_CHAR(LZDATE,'YYYYMMDD')<TO_CHAR(SYSDATE,'YYYYMMDD')
AND ISZHUYING NOT LIKE '%实习生%'
AND YGLEIBIE NOT LIKE '%实习生%'
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}
  )a,
(SELECT 
count(YGID) AS RENSHU
FROM ODM_HR_LZTZ
WHERE 1=1
${if(len(seadate)==0 ,
"AND TO_CHAR(LZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(LZDATE,'YYYY') = '"+seadate+"'")}
AND ISZHUYING  ='主营'
AND LZLEIXING='辞职'
AND XUELIFENLEI <='3-本科'
AND ISZHUYING NOT LIKE '%实习生%'
AND YGLEIBIE NOT LIKE '%实习生%'
AND TO_CHAR(LZDATE,'YYYYMMDD')<TO_CHAR(SYSDATE,'YYYYMMDD')
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}
  )b]]></Query>
</TableData>
<TableData name="主动离职平均司龄（主营）" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="seadate"/>
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
	CASE WHEN SILING IS NULL THEN 0
ELSE SILING END AS SILING
FROM(SELECT 
AVG(ABS(TO_DATE(TO_CHAR(LZDATE, 'YYYY-MM-DD'),'YYYY-MM-DD') - TRUNC(TO_DATE(TO_CHAR(RZDATE, 'YYYY-MM-DD'),'YYYY-MM-DD'))) / 365) AS SILING
FROM ODM_HR_LZTZ
WHERE 1=1
${if(len(seadate)==0 ,
"AND TO_CHAR(LZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(LZDATE,'YYYY') = '"+seadate+"'")}
AND ISZHUYING  ='主营'
AND LZLEIXING='辞职'
AND ISZHUYING NOT LIKE '%实习生%'
AND YGLEIBIE NOT LIKE '%实习生%'
AND TO_CHAR(LZDATE,'YYYYMMDD')<TO_CHAR(SYSDATE,'YYYYMMDD')
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")})

]]></Query>
</TableData>
<TableData name="主动离职平均工龄（主营）" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="seadate"/>
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
CASE WHEN GONGLING IS NULL THEN 0
ELSE GONGLING END AS GONGLING
FROM(SELECT 
AVG(ABS(TO_DATE(TO_CHAR(SYSDATE, 'YYYY-MM-DD'),'YYYY-MM-DD') - TRUNC(TO_DATE(TO_CHAR(CJGZDATE, 'YYYY-MM-DD'),'YYYY-MM-DD'))) / 365) AS GONGLING
FROM ODM_HR_LZTZ
WHERE 1=1
${if(len(seadate)==0 ,
"AND TO_CHAR(LZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(LZDATE,'YYYY') = '"+seadate+"'")}
AND ISZHUYING  ='主营'
AND LZLEIXING='辞职'
AND TO_CHAR(LZDATE,'YYYYMMDD')<TO_CHAR(SYSDATE,'YYYYMMDD')
AND ISZHUYING NOT LIKE '%实习生%'
AND YGLEIBIE NOT LIKE '%实习生%'
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")})

]]></Query>
</TableData>
<TableData name="主动离职平均年龄（主营）" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="seadate"/>
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
CASE WHEN YEARSOLD IS NULL THEN 0
ELSE YEARSOLD END AS YEARSOLD
FROM(
SELECT 
AVG(ABS(TO_DATE(TO_CHAR(SYSDATE, 'YYYY-MM-DD'),'YYYY-MM-DD') - TRUNC(TO_DATE(TO_CHAR(CSDATE, 'YYYY-MM-DD'),'YYYY-MM-DD'))) / 365) AS YEARSOLD
FROM ODM_HR_LZTZ
WHERE 1=1
${if(len(seadate)==0 ,
"AND TO_CHAR(LZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(LZDATE,'YYYY') = '"+seadate+"'")}
AND ISZHUYING  ='主营'
AND LZLEIXING='辞职'
AND ISZHUYING NOT LIKE '%实习生%'
AND YGLEIBIE NOT LIKE '%实习生%'
AND TO_CHAR(LZDATE,'YYYYMMDD')<TO_CHAR(SYSDATE,'YYYYMMDD')
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")})

  

]]></Query>
</TableData>
<TableData name="主动离职性别占比（主营）" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="seadate"/>
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
<![CDATA[/*SELECT
A.zhanbi AS NAN,
B.ZHANBI AS NV
FROM
(SELECT 
ROUND(ratio_TO_REPORT(count(YGID)) OVER(),3)  AS ZHANBI,
XINGBIE
FROM ODM_HR_LZTZ
WHERE 1=1
${if(len(seadate)==0 ,
"AND TO_CHAR(LZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(LZDATE,'YYYY') = '"+seadate+"'")}
AND ISZHUYING  ='主营'
AND LZLEIXING='辞职'
AND ISZHUYING NOT LIKE '%实习生%'
AND YGLEIBIE NOT LIKE '%实习生%'
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}
  GROUP BY XINGBIE)a,
  (SELECT 
ROUND(ratio_TO_REPORT(count(YGID)) OVER(),3)  AS ZHANBI,
XINGBIE
FROM ODM_HR_LZTZ
WHERE 1=1
${if(len(seadate)==0 ,
"AND TO_CHAR(LZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(LZDATE,'YYYY') = '"+seadate+"'")}
AND ISZHUYING  ='主营'
AND LZLEIXING='辞职'
AND ISZHUYING NOT LIKE '%实习生%'
AND YGLEIBIE NOT LIKE '%实习生%'
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}
  GROUP BY XINGBIE)b
WHERE A.XINGBIE ='男'
AND B.XINGBIE='女'
*/

SELECT 
CASE WHEN  COUNT(YGID)=0 THEN 0 
  WHEN  COUNT(YGID)<>0 THEN  ROUND(COUNT(CASE WHEN XINGBIE='男' THEN YGID END )/CASE WHEN 1=1 THEN COUNT(YGID) END,3) END  AS NAN,
CASE WHEN  COUNT(YGID)=0 THEN 0 
  WHEN  COUNT(YGID)<>0 THEN ROUND(COUNT(CASE WHEN XINGBIE='女' THEN YGID  END )/CASE WHEN 1=1 THEN COUNT(YGID) END,3) END AS NV
FROM ODM_HR_LZTZ
WHERE 1=1
${if(len(seadate)==0 ,
"AND TO_CHAR(LZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(LZDATE,'YYYY') = '"+seadate+"'")}
AND ISZHUYING  ='主营'
AND LZLEIXING='辞职'
AND ISZHUYING NOT LIKE '%实习生%'
AND YGLEIBIE NOT LIKE '%实习生%'
AND TO_CHAR(LZDATE,'YYYYMMDD')<TO_CHAR(SYSDATE,'YYYYMMDD')
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}


]]></Query>
</TableData>
<TableData name="被动离职平均职级（主营）" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="seadate"/>
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
case when avg(substr(zhiji,0,2))>0 THEN avg(substr(zhiji,0,2)) 
ELSE 0 END AS ZHIJI
FROM ODM_HR_LZTZ
WHERE 1=1
${if(len(seadate)==0 ,
"AND TO_CHAR(LZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(LZDATE,'YYYY') = '"+seadate+"'")}
AND ISZHUYING  ='主营'
AND zhiji not like '99%' 
AND LZLEIXING <> '实习期结束'
AND LZLEIXING='辞退'
AND ISZHUYING NOT LIKE '%实习生%'
AND YGLEIBIE NOT LIKE '%实习生%'
AND TO_CHAR(LZDATE,'YYYYMMDD')<TO_CHAR(SYSDATE,'YYYYMMDD')
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}]]></Query>
</TableData>
<TableData name="被动离本科及以上占比（主营）" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="seadate"/>
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
case when A.RENSHU=0 OR A.RENSHU IS NULL THEN  0 ELSE B.RENSHU/A.RENSHU END
AS ZHANBI
FROM
(SELECT 
count(YGID) AS RENSHU
FROM ODM_HR_LZTZ
WHERE 1=1
${if(len(seadate)==0 ,
"AND TO_CHAR(LZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(LZDATE,'YYYY') = '"+seadate+"'")}
AND TO_CHAR(LZDATE,'YYYYMMDD')<TO_CHAR(SYSDATE,'YYYYMMDD')
AND LZLEIXING NOT LIKE '实习期结束'
AND ISZHUYING  ='主营'
AND LZLEIXING='辞退'
AND TO_CHAR(LZDATE,'YYYYMMDD')<TO_CHAR(SYSDATE,'YYYYMMDD')
AND ISZHUYING NOT LIKE '%实习生%'
AND YGLEIBIE NOT LIKE '%实习生%'
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}
  )a,
(SELECT 
count(YGID) AS RENSHU
FROM ODM_HR_LZTZ
WHERE 1=1
${if(len(seadate)==0 ,
"AND TO_CHAR(LZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(LZDATE,'YYYY') = '"+seadate+"'")}
AND ISZHUYING  ='主营'
AND LZLEIXING NOT LIKE '实习期结束'
AND LZLEIXING='辞退'
AND XUELIFENLEI <='3-本科'
AND ISZHUYING NOT LIKE '%实习生%'
AND YGLEIBIE NOT LIKE '%实习生%'
AND TO_CHAR(LZDATE,'YYYYMMDD')<TO_CHAR(SYSDATE,'YYYYMMDD')
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}
  )b]]></Query>
</TableData>
<TableData name="被动离职平均司龄（主营）" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="seadate"/>
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
CASE WHEN SILING IS NULL THEN 0
ELSE SILING END AS SILING
FROM(
SELECT 
AVG(ABS(TO_DATE(TO_CHAR(LZDATE, 'YYYY-MM-DD'),'YYYY-MM-DD') - TRUNC(TO_DATE(TO_CHAR(RZDATE, 'YYYY-MM-DD'),'YYYY-MM-DD'))) / 365) AS SILING
FROM ODM_HR_LZTZ
WHERE 1=1
${if(len(seadate)==0 ,
"AND TO_CHAR(LZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(LZDATE,'YYYY') = '"+seadate+"'")}
AND ISZHUYING  ='主营'
AND LZLEIXING <> '实习期结束'
AND LZLEIXING='辞退'
AND ISZHUYING NOT LIKE '%实习生%'
AND YGLEIBIE NOT LIKE '%实习生%'
AND TO_CHAR(LZDATE,'YYYYMMDD')<TO_CHAR(SYSDATE,'YYYYMMDD')
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")})

]]></Query>
</TableData>
<TableData name="被动离职平均工龄（主营）" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="seadate"/>
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
CASE WHEN GONGLING IS NULL THEN 0
ELSE GONGLING END AS GONGLING
FROM(SELECT 
AVG(ABS(TO_DATE(TO_CHAR(SYSDATE, 'YYYY-MM-DD'),'YYYY-MM-DD') - TRUNC(TO_DATE(TO_CHAR(CJGZDATE, 'YYYY-MM-DD'),'YYYY-MM-DD'))) / 365) AS GONGLING
FROM ODM_HR_LZTZ
WHERE 1=1
${if(len(seadate)==0 ,
"AND TO_CHAR(LZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(LZDATE,'YYYY') = '"+seadate+"'")}
AND ISZHUYING  ='主营'
AND LZLEIXING <> '实习期结束'
AND LZLEIXING='辞退'
AND TO_CHAR(LZDATE,'YYYYMMDD')<TO_CHAR(SYSDATE,'YYYYMMDD')
AND ISZHUYING NOT LIKE '%实习生%'
AND YGLEIBIE NOT LIKE '%实习生%'
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")})

]]></Query>
</TableData>
<TableData name="被动离职平均年龄（主营）" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="seadate"/>
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
CASE WHEN YEARSOLD IS NULL THEN 0
ELSE YEARSOLD END AS YEARSOLD
FROM(
SELECT 
AVG(ABS(TO_DATE(TO_CHAR(SYSDATE, 'YYYY-MM-DD'),'YYYY-MM-DD') - TRUNC(TO_DATE(TO_CHAR(CSDATE, 'YYYY-MM-DD'),'YYYY-MM-DD'))) / 365) AS YEARSOLD
FROM ODM_HR_LZTZ
WHERE 1=1
${if(len(seadate)==0 ,
"AND TO_CHAR(LZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(LZDATE,'YYYY') = '"+seadate+"'")}
AND ISZHUYING  ='主营'
AND LZLEIXING <> '实习期结束'
AND LZLEIXING='辞退'
AND TO_CHAR(LZDATE,'YYYYMMDD')<TO_CHAR(SYSDATE,'YYYYMMDD')
AND ISZHUYING NOT LIKE '%实习生%'
AND YGLEIBIE NOT LIKE '%实习生%'
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")})
  

]]></Query>
</TableData>
<TableData name="被动离职性别占比（主营）" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="seadate"/>
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
CASE WHEN  COUNT(YGID)=0 THEN 0 
  WHEN  COUNT(YGID)<>0 THEN  ROUND(COUNT(CASE WHEN XINGBIE='男' THEN YGID END )/CASE WHEN 1=1 THEN COUNT(YGID) END,3) END  AS NAN,
CASE WHEN  COUNT(YGID)=0 THEN 0 
  WHEN  COUNT(YGID)<>0 THEN ROUND(COUNT(CASE WHEN XINGBIE='女' THEN YGID  END )/CASE WHEN 1=1 THEN COUNT(YGID) END,3) END AS NV
FROM ODM_HR_LZTZ
WHERE 1=1
${if(len(seadate)==0 ,
"AND TO_CHAR(LZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(LZDATE,'YYYY') = '"+seadate+"'")}
AND ISZHUYING  ='主营'
AND LZLEIXING <> '实习期结束'
AND LZLEIXING='辞退'
AND TO_CHAR(LZDATE,'YYYYMMDD')<TO_CHAR(SYSDATE,'YYYYMMDD')
AND ISZHUYING NOT LIKE '%实习生%'
AND YGLEIBIE NOT LIKE '%实习生%'
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}

]]></Query>
</TableData>
<TableData name="在职平均职级（主营）" class="com.fr.data.impl.DBTableData">
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
avg(substr(zhiji,0,2)) AS ZHIJI
FROM ODM_HR_YGTZ
WHERE 1=1
AND ISZHUYING = '主营'
AND zhiji not like '99%' 
AND ISZHUYING NOT LIKE '%实习生%'
AND YGLEIBIE NOT LIKE '%实习生%'
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}
  ]]></Query>
</TableData>
<TableData name="在职本科及以上占比（主营）" class="com.fr.data.impl.DBTableData">
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
CASE WHEN A.RENSHU=0 OR B.RENSHU=0 THEN 0
ELSE B.RENSHU/A.RENSHU END AS ZHANBI,
A.RENSHU,
B.RENSHU
FROM
(SELECT 
count(YGID) AS RENSHU
FROM ODM_HR_YGTZ
WHERE 1=1
AND ISZHUYING  ='主营'
AND ISZHUYING NOT LIKE '%实习生%'
AND YGLEIBIE NOT LIKE '%实习生%'
${if(len(DWMC)=0,""," and BUMENID in(
SELECT TREE_NODE
FROM ODM_HR_DW
  start with TREE_NODE ='"+DWMC+"' connect by  PARENT_NODE   =  prior TREE_NODE)")})a,
(SELECT 
count(YGID) AS RENSHU
FROM ODM_HR_YGTZ
WHERE 1=1
AND ISZHUYING  ='主营'
AND XUELIFENLEI <='3-本科'
AND ISZHUYING NOT LIKE '%实习生%'
AND YGLEIBIE NOT LIKE '%实习生%'
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}
  )b

]]></Query>
</TableData>
<TableData name="在职平均司龄（主营）" class="com.fr.data.impl.DBTableData">
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
avg(SILING) AS SILING
FROM ODM_HR_YGTZ
WHERE 1=1
AND ISZHUYING = '主营'
AND ISZHUYING NOT LIKE '%实习生%'
AND YGLEIBIE NOT LIKE '%实习生%'
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}

]]></Query>
</TableData>
<TableData name="在职平均工龄（主营）" class="com.fr.data.impl.DBTableData">
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
AVG(GONGLING) AS GONGLING
FROM(
SELECT 
ABS(TO_DATE(TO_CHAR(SYSDATE, 'YYYY-MM-DD'),'YYYY-MM-DD') - TRUNC(TO_DATE(TO_CHAR(CJGZDATE, 'YYYY-MM-DD'),'YYYY-MM-DD'))) / 365 AS GONGLING
FROM ODM_HR_YGTZ
WHERE 1=1
AND ISZHUYING = '主营'
AND ISZHUYING NOT LIKE '%实习生%'
AND YGLEIBIE NOT LIKE '%实习生%'
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}
  )

]]></Query>
</TableData>
<TableData name="在职平均年龄（主营）" class="com.fr.data.impl.DBTableData">
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
avg(ABS(TO_DATE(TO_CHAR(SYSDATE, 'YYYY-MM-DD'),'YYYY-MM-DD') - TRUNC(TO_DATE(TO_CHAR(CSDATE, 'YYYY-MM-DD'),'YYYY-MM-DD'))) / 365) AS YEARSOLD
FROM ODM_HR_YGTZ
WHERE 1=1
AND ISZHUYING = '主营'
AND ISZHUYING NOT LIKE '%实习生%'
AND YGLEIBIE NOT LIKE '%实习生%'
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}

 

]]></Query>
</TableData>
<TableData name="在职性别占比（主营）" class="com.fr.data.impl.DBTableData">
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
<![CDATA[/*SELECT
A.zhanbi AS NAN,
B.ZHANBI AS NV
FROM
(SELECT 
ROUND(ratio_TO_REPORT(count(YGID)) OVER(),3)  AS ZHANBI,
XINGBIE
FROM ODM_HR_YGTZ
WHERE 1=1
AND ISZHUYING = '主营'
AND ISZHUYING NOT LIKE '%实习生%'
AND YGLEIBIE NOT LIKE '%实习生%'
${if(len(DWMC)=0,""," and BUMENID in(
SELECT TREE_NODE
FROM ODM_HR_DW
  start with TREE_NODE ='"+DWMC+"' connect by  PARENT_NODE   =  prior TREE_NODE)")}
  GROUP BY XINGBIE)a,
  (SELECT 
ROUND(ratio_TO_REPORT(count(YGID)) OVER(),3)  AS ZHANBI,
XINGBIE
FROM ODM_HR_YGTZ
WHERE 1=1
AND ISZHUYING = '主营'
AND ISZHUYING NOT LIKE '%实习生%'
AND YGLEIBIE NOT LIKE '%实习生%'
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}
  GROUP BY XINGBIE)b
WHERE A.XINGBIE ='男'
AND B.XINGBIE='女'*/
SELECT 
CASE WHEN  COUNT(YGID)=0 THEN 0 
  WHEN  COUNT(YGID)<>0 THEN  ROUND(COUNT(CASE WHEN XINGBIE='男' THEN YGID END )/CASE WHEN 1=1 THEN COUNT(YGID) END,3) END  AS NAN,
CASE WHEN  COUNT(YGID)=0 THEN 0 
  WHEN  COUNT(YGID)<>0 THEN ROUND(COUNT(CASE WHEN XINGBIE='女' THEN YGID  END )/CASE WHEN 1=1 THEN COUNT(YGID) END,3) END AS NV
FROM ODM_HR_YGTZ
WHERE 1=1

AND ISZHUYING = '主营'
AND ISZHUYING NOT LIKE '%实习生%'
AND YGLEIBIE NOT LIKE '%实习生%'
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}

]]></Query>
</TableData>
<TableData name="职级区间分布" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="FENLEI"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="seadate"/>
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
RENSHU||'.0'||ROUND(zhanbi*1000,0) AS RENSHU,
ZHIJI
FROM(
SELECT 
ratio_to_report(RENSHU) over() AS zhanbi,
RENSHU,
ZHIJI
FROM(
SELECT 
count(YGID) AS renshu,
'1-2级' AS ZHIJI
FROM ODM_HR_LZTZ
WHERE 1=1
${if(len(seadate)==0 ,
"AND TO_CHAR(LZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(LZDATE,'YYYY') = '"+seadate+"'")}
AND LZLEIXING <> '实习期结束'
AND ZHIJI >='01级' 
AND ZHIJI <='02级'
AND ISZHUYING NOT LIKE '%实习生%'
AND YGLEIBIE NOT LIKE '%实习生%'
AND TO_CHAR(LZDATE,'YYYYMMDD')<TO_CHAR(SYSDATE,'YYYYMMDD')
${SWITCH(FENLEI,''," AND ISZHUYING  ='主营'",'总体',"",'总体-辞职',"AND LZLEIXING='辞职'",'总体-辞退',"AND LZLEIXING='辞退'",'主营'," AND ISZHUYING  ='主营'",'主营-辞职',"AND LZLEIXING='辞职' AND ISZHUYING  ='主营'",'主营-辞退',"AND LZLEIXING='辞退' AND ISZHUYING  ='主营'",'非主营'," AND ISZHUYING !='主营'",'非主营-辞职',"AND LZLEIXING='辞职' AND ISZHUYING !='主营'",'非主营-辞退',"AND LZLEIXING='辞退' AND ISZHUYING !='主营'")}
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}
UNION ALL 
SELECT 
count(YGID) AS renshu,
'3级' AS ZHIJI
FROM ODM_HR_LZTZ
WHERE 1=1
${if(len(seadate)==0 ,
"AND TO_CHAR(LZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(LZDATE,'YYYY') = '"+seadate+"'")}
AND ZHIJI ='03级'
AND LZLEIXING <> '实习期结束'
AND ISZHUYING NOT LIKE '%实习生%'
AND YGLEIBIE NOT LIKE '%实习生%'
AND TO_CHAR(LZDATE,'YYYYMMDD')<TO_CHAR(SYSDATE,'YYYYMMDD')
${SWITCH(FENLEI,''," AND ISZHUYING  ='主营'",'总体',"",'总体-辞职',"AND LZLEIXING='辞职'",'总体-辞退',"AND LZLEIXING='辞退'",'主营'," AND ISZHUYING  ='主营'",'主营-辞职',"AND LZLEIXING='辞职' AND ISZHUYING  ='主营'",'主营-辞退',"AND LZLEIXING='辞退' AND ISZHUYING  ='主营'",'非主营'," AND ISZHUYING !='主营'",'非主营-辞职',"AND LZLEIXING='辞职' AND ISZHUYING !='主营'",'非主营-辞退',"AND LZLEIXING='辞退' AND ISZHUYING !='主营'")}
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}
UNION ALL 
SELECT 
count(YGID) AS renshu,
'4-5级' AS ZHIJI
FROM ODM_HR_LZTZ
WHERE 1=1
${if(len(seadate)==0 ,
"AND TO_CHAR(LZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(LZDATE,'YYYY') = '"+seadate+"'")}
AND ZHIJI >='04级' 
AND ZHIJI <='05级'
AND LZLEIXING <> '实习期结束'
AND ISZHUYING NOT LIKE '%实习生%'
AND YGLEIBIE NOT LIKE '%实习生%'
AND TO_CHAR(LZDATE,'YYYYMMDD')<TO_CHAR(SYSDATE,'YYYYMMDD')
${SWITCH(FENLEI,''," AND ISZHUYING  ='主营'",'总体',"",'总体-辞职',"AND LZLEIXING='辞职'",'总体-辞退',"AND LZLEIXING='辞退'",'主营'," AND ISZHUYING  ='主营'",'主营-辞职',"AND LZLEIXING='辞职' AND ISZHUYING  ='主营'",'主营-辞退',"AND LZLEIXING='辞退' AND ISZHUYING  ='主营'",'非主营'," AND ISZHUYING !='主营'",'非主营-辞职',"AND LZLEIXING='辞职' AND ISZHUYING !='主营'",'非主营-辞退',"AND LZLEIXING='辞退' AND ISZHUYING !='主营'")}
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}
UNION ALL 
SELECT 
count(YGID) AS renshu,
'6-7级' AS ZHIJI
FROM ODM_HR_LZTZ
WHERE 1=1
${if(len(seadate)==0 ,
"AND TO_CHAR(LZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(LZDATE,'YYYY') = '"+seadate+"'")}
AND ZHIJI >='06级' 
AND ZHIJI <='07级'
AND LZLEIXING <> '实习期结束'
AND ISZHUYING NOT LIKE '%实习生%'
AND YGLEIBIE NOT LIKE '%实习生%'
AND TO_CHAR(LZDATE,'YYYYMMDD')<TO_CHAR(SYSDATE,'YYYYMMDD')
${SWITCH(FENLEI,''," AND ISZHUYING  ='主营'",'总体',"",'总体-辞职',"AND LZLEIXING='辞职'",'总体-辞退',"AND LZLEIXING='辞退'",'主营'," AND ISZHUYING  ='主营'",'主营-辞职',"AND LZLEIXING='辞职' AND ISZHUYING  ='主营'",'主营-辞退',"AND LZLEIXING='辞退' AND ISZHUYING  ='主营'",'非主营'," AND ISZHUYING !='主营'",'非主营-辞职',"AND LZLEIXING='辞职' AND ISZHUYING !='主营'",'非主营-辞退',"AND LZLEIXING='辞退' AND ISZHUYING !='主营'")}
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}
UNION ALL 
SELECT 
count(YGID) AS renshu,
'8-10级' AS ZHIJI
FROM ODM_HR_LZTZ
WHERE 1=1
${if(len(seadate)==0 ,
"AND TO_CHAR(LZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(LZDATE,'YYYY') = '"+seadate+"'")}
AND ZHIJI >='08级' 
AND ZHIJI <='10级'
AND LZLEIXING <> '实习期结束'
AND ISZHUYING NOT LIKE '%实习生%'
AND YGLEIBIE NOT LIKE '%实习生%'
AND TO_CHAR(LZDATE,'YYYYMMDD')<TO_CHAR(SYSDATE,'YYYYMMDD')
${SWITCH(FENLEI,''," AND ISZHUYING  ='主营'",'总体',"",'总体-辞职',"AND LZLEIXING='辞职'",'总体-辞退',"AND LZLEIXING='辞退'",'主营'," AND ISZHUYING  ='主营'",'主营-辞职',"AND LZLEIXING='辞职' AND ISZHUYING  ='主营'",'主营-辞退',"AND LZLEIXING='辞退' AND ISZHUYING  ='主营'",'非主营'," AND ISZHUYING !='主营'",'非主营-辞职',"AND LZLEIXING='辞职' AND ISZHUYING !='主营'",'非主营-辞退',"AND LZLEIXING='辞退' AND ISZHUYING !='主营'")}
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}
UNION ALL 
SELECT 
count(YGID) AS renshu,
'10+级' AS ZHIJI
FROM ODM_HR_LZTZ
WHERE 1=1
${if(len(seadate)==0 ,
"AND TO_CHAR(LZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(LZDATE,'YYYY') = '"+seadate+"'")}
AND ZHIJI > '10级'
AND LZLEIXING <> '实习期结束'
AND ISZHUYING NOT LIKE '%实习生%'
AND YGLEIBIE NOT LIKE '%实习生%'
AND TO_CHAR(LZDATE,'YYYYMMDD')<TO_CHAR(SYSDATE,'YYYYMMDD')
${SWITCH(FENLEI,''," AND ISZHUYING  ='主营'",'总体',"",'总体-辞职',"AND LZLEIXING='辞职'",'总体-辞退',"AND LZLEIXING='辞退'",'主营'," AND ISZHUYING  ='主营'",'主营-辞职',"AND LZLEIXING='辞职' AND ISZHUYING  ='主营'",'主营-辞退',"AND LZLEIXING='辞退' AND ISZHUYING  ='主营'",'非主营'," AND ISZHUYING !='主营'",'非主营-辞职',"AND LZLEIXING='辞职' AND ISZHUYING !='主营'",'非主营-辞退',"AND LZLEIXING='辞退' AND ISZHUYING !='主营'")}
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}
  ))]]></Query>
</TableData>
<TableData name="司龄区间" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="seadate"/>
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
<![CDATA[select * from (
SELECT
*
FROM(
SELECT 
RENSHU,
'主动离职' AS XILIE,
FENLEI
FROM(
SELECT 
count(YGID) AS renshu,
'0-0.5年' AS FENLEI
FROM ODM_HR_LZTZ
WHERE 1=1
${if(len(seadate)==0 ,
"AND TO_CHAR(LZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(LZDATE,'YYYY') = '"+seadate+"'")}
AND LZLEIXING='辞职'
AND ISZHUYING='主营'
AND ISZHUYING NOT LIKE '%实习生%'
AND YGLEIBIE NOT LIKE '%实习生%'
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}
AND   ABS(TO_DATE(TO_CHAR(LZDATE, 'YYYY-MM-DD'),'YYYY-MM-DD') - TRUNC(TO_DATE(TO_CHAR(RZDATE, 'YYYY-MM-DD'),'YYYY-MM-DD'))) / 365  >=0
AND   ABS(TO_DATE(TO_CHAR(LZDATE, 'YYYY-MM-DD'),'YYYY-MM-DD') - TRUNC(TO_DATE(TO_CHAR(RZDATE, 'YYYY-MM-DD'),'YYYY-MM-DD'))) / 365  <0.5
UNION ALL 
SELECT 
count(YGID) AS renshu,
'0.5-1年' AS FENLEI
FROM ODM_HR_LZTZ
WHERE 1=1
${if(len(seadate)==0 ,
"AND TO_CHAR(LZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(LZDATE,'YYYY') = '"+seadate+"'")}
AND LZLEIXING='辞职'
AND ISZHUYING='主营'
AND ISZHUYING NOT LIKE '%实习生%'
AND YGLEIBIE NOT LIKE '%实习生%'
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}
AND   ABS(TO_DATE(TO_CHAR(LZDATE, 'YYYY-MM-DD'),'YYYY-MM-DD') - TRUNC(TO_DATE(TO_CHAR(RZDATE, 'YYYY-MM-DD'),'YYYY-MM-DD'))) / 365  >=0.5
AND   ABS(TO_DATE(TO_CHAR(LZDATE, 'YYYY-MM-DD'),'YYYY-MM-DD') - TRUNC(TO_DATE(TO_CHAR(RZDATE, 'YYYY-MM-DD'),'YYYY-MM-DD'))) / 365  <1
UNION ALL 
SELECT 
count(YGID) AS renshu,
'1-3年' AS FENLEI
FROM ODM_HR_LZTZ
WHERE 1=1
${if(len(seadate)==0 ,
"AND TO_CHAR(LZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(LZDATE,'YYYY') = '"+seadate+"'")}
AND LZLEIXING='辞职'
AND ISZHUYING='主营'
AND ISZHUYING NOT LIKE '%实习生%'
AND YGLEIBIE NOT LIKE '%实习生%'
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}
AND   ABS(TO_DATE(TO_CHAR(LZDATE, 'YYYY-MM-DD'),'YYYY-MM-DD') - TRUNC(TO_DATE(TO_CHAR(RZDATE, 'YYYY-MM-DD'),'YYYY-MM-DD'))) / 365  >=1
AND   ABS(TO_DATE(TO_CHAR(LZDATE, 'YYYY-MM-DD'),'YYYY-MM-DD') - TRUNC(TO_DATE(TO_CHAR(RZDATE, 'YYYY-MM-DD'),'YYYY-MM-DD'))) / 365  <3
UNION ALL 
SELECT 
count(YGID) AS renshu,
'3年及以上' AS FENLEI
FROM ODM_HR_LZTZ
WHERE 1=1
${if(len(seadate)==0 ,
"AND TO_CHAR(LZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(LZDATE,'YYYY') = '"+seadate+"'")}
AND LZLEIXING='辞职'
AND ISZHUYING='主营'
AND ISZHUYING NOT LIKE '%实习生%'
AND YGLEIBIE NOT LIKE '%实习生%'
AND TO_CHAR(LZDATE,'YYYYMMDD')<TO_CHAR(SYSDATE,'YYYYMMDD')
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}
AND   ABS(TO_DATE(TO_CHAR(LZDATE, 'YYYY-MM-DD'),'YYYY-MM-DD') - TRUNC(TO_DATE(TO_CHAR(RZDATE, 'YYYY-MM-DD'),'YYYY-MM-DD'))) / 365  >=3))

UNION ALL

SELECT
*
FROM(
SELECT 
RENSHU,
'在职' AS XILIE,
FENLEI
FROM(
SELECT 
count(DISTINCT YGID) AS renshu,
'0-0.5年' AS FENLEI
FROM ODM_HR_YGTZ
WHERE 1=1
AND ISZHUYING NOT LIKE '%实习生%'
AND YGLEIBIE NOT LIKE '%实习生%'
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}
AND SILING >= 0
AND 0.5>SILING
UNION ALL 
SELECT 
count(DISTINCT YGID) AS renshu,
'0.5-1年' AS FENLEI
FROM ODM_HR_YGTZ
WHERE 1=1
AND ISZHUYING NOT LIKE '%实习生%'
AND YGLEIBIE NOT LIKE '%实习生%'
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}
AND 0.5<=SILING
AND 	1>SILING
UNION ALL 
SELECT 
count(DISTINCT YGID) AS renshu,
'1-3年' AS FENLEI
FROM ODM_HR_YGTZ
WHERE 1=1
AND ISZHUYING NOT LIKE '%实习生%'
AND YGLEIBIE NOT LIKE '%实习生%'

${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}
AND SILING>=1
AND SILING<3
UNION ALL 
SELECT 
count(DISTINCT YGID) AS renshu,
'3年及以上' AS FENLEI
FROM ODM_HR_YGTZ
WHERE 1=1
AND ISZHUYING NOT LIKE '%实习生%'
AND YGLEIBIE NOT LIKE '%实习生%'

${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}
AND SILING >=3)) ) order by XILIE DESC,fenlei asc

]]></Query>
</TableData>
<TableData name="各职能序列分布" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="seadate"/>
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
<![CDATA[SELECT *
from(
SELECT 
renshu,
'在职' AS XILIE,
ZHINENGXULIE
FROM(
SELECT 
count(YGID) AS renshu,
ZHINENGXULIE
FROM ODM_HR_YGTZ
WHERE 1=1
AND ISZHUYING  ='主营'
AND ISZHUYING NOT LIKE '%实习生%'
AND YGLEIBIE NOT LIKE '%实习生%'

${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}
GROUP BY ZHINENGXULIE
)

UNION ALL

SELECT
renshu,
'主动离职' AS XILIE,
ZHINENGXULIE
FROM(
SELECT 
count(YGID) AS renshu,
ZHINENGXULIE
FROM ODM_HR_LZTZ
WHERE 1=1
${if(len(seadate)==0 ,
"AND TO_CHAR(LZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(LZDATE,'YYYY') = '"+seadate+"'")}
AND LZLEIXING='辞职'
AND ISZHUYING  ='主营'
AND ISZHUYING NOT LIKE '%实习生%'
AND YGLEIBIE NOT LIKE '%实习生%'
AND TO_CHAR(LZDATE,'YYYYMMDD')<TO_CHAR(SYSDATE,'YYYYMMDD')
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}
GROUP BY ZHINENGXULIE )

)
order by case when XILIE = '主动离职' then 2
              when XILIE = '在职'     then 1
          end,ZHINENGXULIE]]></Query>
</TableData>
<TableData name="各职能序列主动离职人数占比" class="com.fr.data.impl.DBTableData">
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
*
FROM(
SELECT 
A.RENSHU/B.RENSHU AS ZHANBI,
A.ZHINENGXULIE
FROM
(SELECT 
count(YGID) AS renshu,
ZHINENGXULIE
FROM ODM_HR_LZTZ
WHERE 1=1
AND ISZHUYING  ='主营'
AND TO_CHAR(LZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')
AND LZLEIXING='辞职'

AND TO_CHAR(LZDATE,'YYYYMMDD')<TO_CHAR(SYSDATE,'YYYYMMDD')
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}
GROUP BY ZHINENGXULIE)a, 
(SELECT 
count(YGID) AS renshu,
ZHINENGXULIE
FROM ODM_HR_YGTZ
WHERE 1=1
AND ISZHUYING  ='主营'

${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}
GROUP BY ZHINENGXULIE
)b
WHERE A.ZHINENGXULIE=B.ZHINENGXULIE)
ORDER BY  ZHANBI DESC]]></Query>
</TableData>
<TableData name="ds1" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="seadate"/>
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
 ROUND(CASE WHEN XINGBIE='男' THEN COUNT(YGID) END /CASE WHEN 1=1 THEN COUNT(YGID) END,3)  AS NAN,
ROUND(CASE WHEN XINGBIE='女' THEN COUNT(YGID) END /CASE WHEN 1=1 THEN COUNT(YGID) END,3)  AS NV
FROM ODM_HR_LZTZ
WHERE 1=1
${if(len(seadate)==0 ,
"AND TO_CHAR(LZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(LZDATE,'YYYY') = '"+seadate+"'")}
AND TO_CHAR(LZDATE,'YYYYMMDD')<TO_CHAR(SYSDATE,'YYYYMMDD')
AND ISZHUYING  ='主营'
AND LZLEIXING <> '实习期结束'
AND LZLEIXING='辞退'
AND ISZHUYING NOT LIKE '%实习生%'
AND YGLEIBIE NOT LIKE '%实习生%'
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}
  GROUP BY XINGBIE

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
<NorthAttr size="0"/>
<North class="com.fr.form.ui.container.WParameterLayout">
<Listener event="afterinit">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[setTimeout(function(){  
$('.parameter-container-collapseimg-up').trigger("click");  
$('.parameter-container-collapseimg-up').remove();  
},1); ]]></Content>
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
<Background name="ColorBackground"/>
<LCAttr vgap="0" hgap="0" compInterval="0"/>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TextEditor">
<WidgetName name="seadate"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<TextAttr/>
<widgetValue>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=year(now())]]></Attributes>
</O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="441" y="0" width="80" height="0"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="seadate"/>
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
<![CDATA[WebReport/ReportServer?formlet=HXXF_HR/HRanalysis/Leave_EmployeeBasic.frm]]></O>
</ColumnConfig>
<ColumnConfig name="CPT" isKey="false" skipUnmodified="false">
<O>
<![CDATA[Leave_EmployeeBasic.frm]]></O>
</ColumnConfig>
<ColumnConfig name="CPT_NAME" isKey="false" skipUnmodified="false">
<O>
<![CDATA[离职分布_离职员工属性]]></O>
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
<![CDATA[=
if(len($DWMC)=0,"","部门ID:")]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="PARAMETER" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=
if(len($DWMC)=0,"",$DWMC+":")]]></Attributes>
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
<FRFont name="宋体" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Background name="ColorBackground" color="-1"/>
<Alpha alpha="1.0"/>
</Border>
<Background name="ColorBackground" color="-1"/>
<LCAttr vgap="0" hgap="0" compInterval="0"/>
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
<NorthAttr size="233"/>
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
<WidgetName name="f4818300-47e2-4d9b-8fbc-3dff4cf27797"/>
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
<WidgetName name="10534176-2666-48ef-9c54-a6deff2bcfc2"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Text>
<![CDATA[离职员工属性]]></Text>
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
<WidgetName name="tabpane0"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="1" color="-1051403" borderRadius="0" type="1" borderStyle="0"/>
<WidgetTitle>
<O>
<![CDATA[title]]></O>
<FRFont name="微软雅黑" style="0" size="72"/>
<Position pos="0"/>
<Background name="ColorBackground" color="-3355444"/>
</WidgetTitle>
<Alpha alpha="1.0"/>
</Border>
<LCAttr vgap="0" hgap="0" compInterval="0"/>
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
<LCAttr vgap="0" hgap="0" compInterval="8"/>
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
<InnerWidget class="com.fr.form.ui.RadioGroup">
<Listener event="statechange">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[var a = this.options.form.getWidgetByName("seadate1").getValue();
 $("input[name=SEADATE]A").val(a)
 _g().parameterCommit();]]></Content>
</JavaScript>
</Listener>
<WidgetName name="seadate1"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<fontSize>
<![CDATA[9]]></fontSize>
<Dictionary class="com.fr.data.impl.TableDataDictionary">
<FormulaDictAttr kiName="REA" viName="APP"/>
<TableDataDictAttr>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[控件_今年去年]]></Name>
</TableData>
</TableDataDictAttr>
</Dictionary>
<widgetValue>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$seadate]]></Attributes>
</O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="693" y="0" width="153" height="18"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="seadate1"/>
</MobileWidgetList>
<WidgetScalingAttr compState="0"/>
<DesignResolution absoluteResolutionScaleW="1366" absoluteResolutionScaleH="768"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="943" height="29"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="chart0_c"/>
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
<WidgetName name="chart0_c"/>
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
<Background name="ColorBackground" color="-1"/>
<Alpha alpha="1.0"/>
</Border>
<Background name="ColorBackground" color="-1"/>
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
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="各职能序列在职/"+if(len(seadate)==0 || seadate == year(now()),"本年度",seadate+"年度")+"主动离职对比（主营）"]]></Attributes>
</O>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="104" foreground="-13421773"/>
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
<Attr class="com.fr.plugin.chart.base.AttrLabel">
<AttrLabel>
<labelAttr enable="true"/>
<labelDetail class="com.fr.plugin.chart.base.AttrLabelDetail">
<Attr showLine="false" autoAdjust="false" position="0" isCustom="true"/>
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
<![CDATA[#0人]]></Format>
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
<FillStyleName fillStyleName=""/>
<isCustomFillStyle isCustomFillStyle="true"/>
<ColorList>
<OColor colvalue="-4259840"/>
<OColor colvalue="-6250336"/>
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
<VanChartRectanglePlotAttr vanChartPlotType="stack" isDefaultIntervalBackground="true"/>
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
<FRFont name="微软雅黑" style="0" size="72" foreground="-10066330"/>
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
<VanChartColumnPlotAttr seriesOverlapPercent="20.0" categoryIntervalPercent="20.0" fixedWidth="true" columnWidth="25" filledWithImage="false" isBar="false"/>
</Plot>
<ChartDefinition>
<OneValueCDDefinition seriesName="XILIE" valueName="RENSHU" function="com.fr.data.util.function.NoneFunction">
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[各职能序列分布]]></Name>
</TableData>
<CategoryName value="ZHINENGXULIE"/>
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
<BoundsAttr x="0" y="0" width="943" height="242"/>
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
<Attr xAxisIndex="0" yAxisIndex="0" stacked="true" percentStacked="false" stackID="stackID"/>
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
<OneValueCDDefinition seriesName="XILIE" valueName="RENSHU" function="com.fr.data.util.function.NoneFunction">
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[司龄区间]]></Name>
</TableData>
<CategoryName value="FENLEI"/>
</OneValueCDDefinition>
</DefinitionMap>
<DefinitionMap key="line">
<OneValueCDDefinition function="com.fr.data.util.function.NoneFunction">
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
</OneValueCDDefinition>
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
</body>
</InnerWidget>
<BoundsAttr x="0" y="705" width="943" height="242"/>
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
<FRFont name="宋体" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Background name="ColorBackground" color="-1"/>
<Alpha alpha="1.0"/>
</Border>
<Background name="ColorBackground" color="-1"/>
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
<Attr lineStyle="0" isRoundBorder="false" roundRadius="4"/>
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
<![CDATA[="各司龄区间在职/"+if(len(seadate)==0 || seadate == year(now()),"本年度",seadate+"年度")+"主动离职对比（主营）"]]></Attributes>
</O>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="104" foreground="-13421773"/>
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
<Attr lineStyle="0" isRoundBorder="false" roundRadius="5"/>
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
<Attr showLine="false" autoAdjust="false" position="0" isCustom="true"/>
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
<![CDATA[#0人]]></Format>
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
<Attr class="com.fr.plugin.chart.base.AttrTooltip">
<AttrTooltip>
<Attr enable="true" duration="4" followMouse="false" showMutiSeries="false" isCustom="true"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="72" foreground="-1"/>
</Attr>
</TextAttr>
<AttrToolTipContent>
<Attr isCommon="false"/>
<value class="com.fr.plugin.chart.base.format.AttrTooltipValueFormat">
<AttrTooltipValueFormat>
<Attr enable="true"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0人]]></Format>
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
<Attr lineStyle="0" isRoundBorder="false" roundRadius="2"/>
<newColor borderColor="-16777216"/>
</AttrBorder>
<AttrAlpha>
<Attr alpha="0.5"/>
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
<FillStyleName fillStyleName=""/>
<isCustomFillStyle isCustomFillStyle="true"/>
<ColorList>
<OColor colvalue="-4259840"/>
<OColor colvalue="-6250336"/>
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
<VanChartRectanglePlotAttr vanChartPlotType="stack" isDefaultIntervalBackground="true"/>
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
<FRFont name="微软雅黑" style="0" size="72" foreground="-10066330"/>
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
<VanChartColumnPlotAttr seriesOverlapPercent="20.0" categoryIntervalPercent="20.0" fixedWidth="true" columnWidth="25" filledWithImage="false" isBar="false"/>
</Plot>
<ChartDefinition>
<OneValueCDDefinition seriesName="XILIE" valueName="RENSHU" function="com.fr.data.util.function.NoneFunction">
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[司龄区间]]></Name>
</TableData>
<CategoryName value="FENLEI"/>
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
<BoundsAttr x="0" y="0" width="943" height="224"/>
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
<Attr xAxisIndex="0" yAxisIndex="0" stacked="true" percentStacked="false" stackID="stackID"/>
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
<OneValueCDDefinition seriesName="XILIE" valueName="RENSHU" function="com.fr.data.util.function.NoneFunction">
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[司龄区间]]></Name>
</TableData>
<CategoryName value="FENLEI"/>
</OneValueCDDefinition>
</DefinitionMap>
<DefinitionMap key="line">
<OneValueCDDefinition function="com.fr.data.util.function.NoneFunction">
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
</OneValueCDDefinition>
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
</body>
</InnerWidget>
<BoundsAttr x="0" y="481" width="943" height="224"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="chart2"/>
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
<WidgetName name="chart2"/>
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
<Background name="ColorBackground" color="-1"/>
<Alpha alpha="1.0"/>
</Border>
<Background name="ColorBackground" color="-1"/>
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
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(len(seadate)==0 || seadate == year(now()),"本年度",seadate+"年度")+"离职员工职级区间分布（"+if(len($FENLEI)=0,"主营",$FENLEI)+"）"]]></Attributes>
</O>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="104"/>
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
<Attr lineStyle="1" isRoundBorder="false" roundRadius="3"/>
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
<Attr isCommon="false"/>
<value class="com.fr.plugin.chart.base.format.AttrTooltipValueFormat">
<AttrTooltipValueFormat>
<Attr enable="true"/>
</AttrTooltipValueFormat>
</value>
<percent class="com.fr.plugin.chart.base.format.AttrTooltipPercentFormat">
<AttrTooltipPercentFormat>
<Attr enable="true"/>
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
<HtmlLabel customText="function(){ return this.category+&apos;：&apos;+ this.value.toString().split(&apos;.&apos;)[0]+&apos;人&apos;+&apos;&lt;/br&gt;&apos;+&quot;占比：&quot;+(this.value.toString().split(&apos;.&apos;)[1])/10 +&apos;%&apos;;}" useHtml="true" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
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
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0人]]></Format>
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
<HtmlLabel customText="function(){  var category = this.category; var values = this.value; var strs= new Array();  strs=values.split(&quot;.&quot;); values=strs[0]+&quot;人&quot;; values+=(strs[1]/10 + &quot;%&quot;); return category+values;}" useHtml="true" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
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
<FillStyleName fillStyleName=""/>
<isCustomFillStyle isCustomFillStyle="true"/>
<ColorList>
<OColor colvalue="-4259832"/>
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
<FRFont name="微软雅黑" style="0" size="72"/>
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
<VanChartColumnPlotAttr seriesOverlapPercent="20.0" categoryIntervalPercent="20.0" fixedWidth="true" columnWidth="24" filledWithImage="false" isBar="false"/>
</Plot>
<ChartDefinition>
<MoreNameCDDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[职级区间分布]]></Name>
</TableData>
<CategoryName value="ZHIJI"/>
<ChartSummaryColumn name="RENSHU" function="com.fr.data.util.function.NoneFunction" customName="人数"/>
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
<BoundsAttr x="0" y="0" width="943" height="249"/>
</Widget>
<body class="com.fr.form.ui.ChartEditor">
<WidgetName name="chart3"/>
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
<VanChartColumnPlotAttr seriesOverlapPercent="20.0" categoryIntervalPercent="20.0" fixedWidth="false" columnWidth="0" filledWithImage="false" isBar="false"/>
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
</body>
</InnerWidget>
<BoundsAttr x="0" y="232" width="943" height="249"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report0_c"/>
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
<WidgetName name="report0_c"/>
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
<Background name="ColorBackground" color="-1"/>
<Alpha alpha="1.0"/>
</Border>
<Background name="ColorBackground" color="-1"/>
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
<![CDATA[914400,720000,720000,720000,720000,720000,720000,723900,723900,723900,0,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2736000,2743200,2736000,2743200,3168000,3168000,2736000,2743200,3168000,3168000,2736000,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" cs="2" s="0">
<O>
<![CDATA[全体在职（主营）]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="0" cs="2" s="0">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(len(seadate)==0 || seadate == year(now()),"本年度",seadate+"年度")+"被动离职（主营）"]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="0" cs="2" s="0">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(len(seadate)==0 || seadate == year(now()),"本年度",seadate+"年度")+"主动离职（主营）"]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="1" cs="2" rs="6" s="1">
<O t="Image">
<IM>
<![CDATA[D-D-?*,j>5bN`XN,s$koX!Lr*hJ94$<o8nn>LY(E.LArr<^[S6>HBIB,)@!Y/67`A6BmRsOP
oa-cM@J:k+%i`mbG?oTD.4*]AlWA,Gm\tma$@g:$NL/D%.psPYK!$3]Anr3Kl?M=cirB&j8Mnf
FYRDoI]Aql(NVUmfOFEmYekBQfI\NBK"LG_.q?'EL?LaNie["X=&?9mEeaB20P#bS_njRQn%2
fB&CJ,&*q!r[[Rn8>(te`=5ABQGQKTbc:k]A__L<gsi^4o!u60DZBUj)$Af(;X1Ck\<k4,#::
nA#iS=oUo"W\%_@P6,m6RjJhAT04LTuDMB-SsSct,kV?Xb=JIkA]ABiUc0hb`"g4ZG/G#]ACB:
Am(iXjG=mb28rraFRKh@h4),QLA<)LH7B?!UD=pTJ`6Ga"L/Y)p%QOD.<;GUDYK]A;Y#>05N+
QA0r-32(PV#NWq>SU!kmn4344gW/+KRgh@D%a3ipg]AP6pkGq_E\H%oOfMj*d3RW(br4U:8Y*
\;i;#kNToW*RGjH?EZQfU2@NONK$@s_Z0fllD^4!mWpf]A"GW#4`*mqI8VW!&$;4'[#i1^N<c
4El0-mu6skM^dQYVi^E,<=X2h]AGE!U)&6#1N@u8)TrVi$"._?;UoMb%kA4U[TF5G"O*f@YZ&
H6;-(`_/a]A4D6E:SGU%Y\67,'?QnEF#_<5eNJ1sHWss7m7-V_N'?>S_Y_MKJ50jPb'5f2$$f
M"f0Vl]AnNklsC0k^"<n/X((jB3j/^sS+BG>gRI.A^(0]AL:?KOiUZ.',+51)J]A`L2;-VA#eae
&*.df4XmN&b0[NCS&t<2XOD6MgS26VS^.D0.cY2KIpp`ZV<^,L20<F:CQ)A5QN``lt@Nl_.5
)Ibg.89&1phB[-6'FNeA.BS-(&k;45,!7!T>=6*&jSfekUEsH#29_6>2fRlS+/K,#>)5D5na
d[%'i[,mrHW\lL1t)YV%hB&$QB,!I8[Z[K=$H#?'phA7WS)`<[]Aj2D(\\aK^-'Q.jS:Jfb?,
"GZF!^?@aDSWk^84se\m@df:T@BT-D[E5,55n*h*XdhmLiP-u+0s7\$'sEqK#%8A/Vo.+X.k
pe)9qlfne]AZ\n8]AG<]A\XcCDF$^1)%bf/p;eg>2#0EK7/4%t?^od;Y>poW4LD2LP!f=g*2#DA
m2[%/mf"kP05@gQf\b0(XIm2@GVdP[VrjNZ`^VQgfZK$WFt#k[\XFnn?[$P'YB/b*;Kl-X'$
/[D(BYdQbKEE"^+QNure%1[.:h(@N4TA7OTD$iSZY"&l3,-0X\i%Sn,cU-Jl6alLK0p`f^24
1oL]AfNX@2.+B+..))`m+ga>13O@>*U05*jlA\K`HoQRU]A0CXi@jR$rP6b?>i5=M`h3_hG<_J
!dSC7)gUCN]AeW<4,V8]A2!!-:6BX.E,,#V4c7;NRl..P]ASc_c"&[FUL*Hn'Q]AW"f?X-h([juE
5a[tks4ns(d@09?>!S(4KKt]A/YKO*<$$Ue$>OLj:Obn@hq]A!VDeroo:/DQ\g,X1b,1*Q7;[5
PV9408oT_+YU`'(L.;a";$+glEo:onPA>`cS(COuBZ,^F"rDbaJB'RZ_<?g`U@hlhDI*>!<"
HB&A;TiAJ%)2"O>2>J@4eo*H@&JrB^(GUsKa=3:5/\i!T[hM[1G%VRXY*RDamYLe)LX4#CIL
g2r"e#[i5e=lK:5OV@S+^)6YM!226f.9DCZTM]A/&dku+NsW,41J=c1B_DfNC+<P"C)":h0%I
3oiVEFkJ#_W+MnG#GF[g;LODk$_4te'N9kP)#Y/*@)[E&7,qqpMb3Wf0Z4Qi9#p.:k3H$NYJ
M_7!rnp+9`.1./dWTh^Kd;_Qs]A^@p#[4o'_=F$(bZi;65ejITB5H^]ASLQ`OfodWX?]A'B\%p$
=%uGb?:BA`hrF6%kB&\fn%rNXdn>:T8V(2Ll/57B!>L_B6C`1iE%Ze(g[jK2AB_&r2XCZRn!
#N,m%@l3qk8`SdpU#!@0E!JKui\.V+m^Gi8<`sR!@,Xfgd/+:M%XFN1P[b'9kI8756X8EEd3
WL!7RW-LS)L+TJ^p[&rlt)U1hJ8PEC?/u$XZ-^d5cO@_1h*n,G+5\^"(fGZ&+I>;>e+"nhA&
@:Hmr(e>OH\h\]AWn#)B04)UM:%%Kpi[E"Emq-RRbS72ud"&@=>=Yni-r^9Oi/:Rc[X&]A*'YC
b*Pq9od&LR+d2Si3h2$Ea&Ret=hO?L]AnV71XfEaQ';7mrkn.!c!+Xe+^[SA&SQW,Vl7*1f6G
:VDC=%:j"O'%+DT>eVWhjs]A^2AI0;,N6^$7Vm'LNpHq[Ai]AH2LE"k@$b,,I_5&nTS(rgPu^*
t5d*&?Q57X5F2'tN%j)\^LKX4'4c#q;K)>l5nReuZEr$ZW5BHh!o'd'b<S\FmJ?<FP;#<pTf
+53BP]ACku,u'.IiL0ctH4nl";"p,l9D89\#%)'t-]AgeCeSNg:CVDNU0BZ+(;h=.F>T%2P1%#
_LFC\=Sbh&7AH.^b5b:"fn)Z'4[XgbbePl:OU</-*\Mb2gYQr`,-c*'Q>@&SqAeq7AoZ<?P*
`"dXD_R7:h[5Yg!Idg0h$Hh78"C#2lJp1n<'HSNbQJTd.IM6fj;6c([]A)4"_gB[3pfW:a!pp
m;+PYZRr`S<g&5&lD-A`]A(J!AmlQ?u->qJdM&-A2=NZ@aGppAJ9"<Y0*8P^0XuHl8R(:kp$=
:<<15g8(Gjt>/3;`_l+`4FF`Q#c+jtuM2(;n`E##hU[#QBL#qm^I0ijL"3q.^!.k22@_'g&!
be8Li*hb`p+0OQ7Bm/3Osg.XFsV1(hW\mElN0_+o0_Y!:@Gt??,u+n]A<WqQ41F[8DVUViC$D
7<HCccB.fH8'F"MHLRo1/"$7;Z9=D/(C;Z)4G)^ip$.c1d5j_rBe&JH%'At6DY2JMepB=_Jf
qIhP_3N.5,f8GU.61ua:n,6%%cn=nCP9"0HNcHg^D3,Wn7".FaMrVq3WQDE8%clVeXp2WnLF
V0l)%<=k%\meUPJf:i9+.\c&fWsFOTB=r'b)(j8hTUW>RQfde:jZG6TM;jK!Y8tY0h1:U@KE
.[at".^^tO0$1W3R=`u2m@kWhb5Om_.a<g]AfYBj2Rb\CcVQc=K)Yn\l3MWaPd_9(/eC[BKhL
Bo+o3cZWir`KKR:j@KlAhiQSf0PTH%\4o/+7nj'9\@r[B=9;lYO@a7_+huDa*aA*foZ4YpB+
8jBEeap=F]A=a!f\JcG\if8jhBM1$N/"uY%[=*GN`&iLDktJ(qY!e(.(C2"3Gj'3`CP,-N/)<
l:h=U8HWMF`[L45#"B!L;R5dm*&`U/n[j"%,?&Tg/NRXiT/^6@O,mU-Im%a'\J\d(f)[:?$[
^aJ&@F$A';1M<Jmrd$H;:a83<CKDHDp5S[dX1^13:PO$u,0q4/N[?B$DKePe<Y+&H-[U9O6b
_B6BQ/]Aj`kr3q,r?hf(kd+csJ]AkGsZAN0E,DdMNY$Fn#WhD[I5.QUt9nn4k=63B%Z1GO\%]A*
OFdm8_d/1=k1L/9mt$MZ?Lh8Y4)]A[+e1Um9FuC[F"oQ6jQ?m@pjVNr+5<7&o1.+>/mRb;a/#
">A71;);5YI=^KOisLT[oU5c.RH$_%<hBW=ZW[p?)0bWRNS)A%4:o#jiKd5TiP#2CMc;9csc
1fADUV$6Jl$IWmT'KOrh,`T5p=D:tCBA9esVc`1mEo9/+5"iIA,mO0\2(VmYFRntHH'c<ppZ
06nY7!oefbn/r;oa8`?Y9lSp!d.+IhUW""1OIk8><4b%qV!ulIEL@RJ?bAn\CJG=qUb+h'fP
1EGRN@gtW6be:Da_mPF?/qX_[U,(EBR[K;^S?`mc@"T*]AK^/%3rfg3BSi6^7RS!&Q\fRDlXo
7prFm&XgDouL<D3IPZ^"L4LaG'(\!$:/"m]A('[.+5T7e.4#_/M9Y4^]A]AoX0jXiLF01N<mTI[
O']ADK(b0O-E<?$5Nj?B;B5J9*fC<fHC'$pLfEEXfSGct4ZmkL=h":b'Q%HGr'!`;C`01`Z^?
i5`0=RZ-GEgoU[q!m,.mqkbTh_+ZY0M1uN!,A,na"fckc)@.R2r<&Bpk41:ql"OiE^A=2^/:
KH0@e\>ALPZ<Y9<-K,1/Z$f9#;VC'Zi5sKVs]AoB):/urQ\PB3_s?$L:_JMIa9tu>-r!Ed`TQ
F.\0m@<f`6#]A$k`7kE]Aanqt@-eg)7'E`lWeSHI8ipgk<Bbd(HgdA4h]Ah=d4Q_5)e0$Yq%>K;
;fESVU1@NW5\r;CAiGT7ZY2Z7-lXTHZs#&!VQai=KPY+mGpdd%DCI%0]A=PZ=!0=*f9.')gdE
H/T.6L2c\'oB"8EKZ0l#.l%dXf4a?3nS9)kp$2p)Gf[UB]A-a%XQ<`KVhCq2BGUj`Zq(>`\LI
2Nn7LhtMROn<hs*h4sGLp)<HI$3I[YfeEn%qOuN*W3\*'<J,r%MJC02D*g"d]Al,"f$UHh/DS
k$H1+GNsMbOj@+R)O<^,u^;mot_;@s%D<-"gq)'P\FJ<2)S3WR1@pAD>o2oG%fgDf/g0o:nb
809a'8%1X*LYCD3IaHgS!\^:mO'qE8FTa=8"J"PDcZ9HOl2C`7%+K<,6pEC3mP(4`7UG^nLI
@*aMR'1;"idq:HD.B>3mSc12@A-nmh.Y!H:*d#'1.ZT0gCAcoDlkn%2-5;?Mh\%s(ZdKi84O
^Y[qOBOrkCgF_n6?ZVa#&tmK#.5Ef$0$9Z+?gJN$5*;Ps8&A)-rHD-I?`Lt]AU\LMN;cqcgkH
'Kft-!lW*rKtY`aLC\[YG&7`e=-WR?:]Ai:YLeAX:5:b8k%Z*8C0s9a:g/i?pTmI;.-1S1\I^
%89hq\\W*eS-6JMu`dPA9*@Gf/-$q$/p'XDY0G^1/0!NY';,LgMF?h0F5XZQ;-mG6q2ID_^B
NVqe[8_;ts/N>K2@FB_6Z0QXA=Kiu@s2q1&XV)M_ZW\O__s'F0h1lJ=2?Xeh?(f`[-T3R5t"
cp-\GujL[3*^eSVS/moVL:W6J4k7oAbJPfEPbqg0fa6[7n<Mjd0CIoKb(UVX#Z/G?I@R"hIs
*P,K+7q%roD!5JJnRN>ic<ba(J#!_r1u->k,k>45d8l")EIiN!?uE*8FM?=R5H9>`6!9=,:g
ZI$4N.q[0e2C[\g@'M0eh@C*HF/4GL-JT;UgtUsO->J)e<4]ADMQV4:!BJ5)1_CY%i,-ChK4P
h_Q)BTQ;6AWPnT6C@^#*`^5E8Nc<iOgp^fUZ:q\H+FSL&NCTc,Rc3\N5ah/dhU6G0TH=n/KI
?&jG)I&;PQ_4?3pG+F0+$/4]A&`!A,aE)_i)&*V+*N_6$qscE?h<2P\nHkMs9Sr-QBG^LuF>S
oRqGE6$]A[N,!5Gb*V<-X3Qh*G]A=NcqF#3-8IZonL3L?5'DU8%CG9R(]A.$LNG<JI)$WO<G"r#
n-)miY%U8'?)B.MDH_+44G_eViBONbO9J.U;MR!SM\m8`mk`e?)@C0WVoU)ju-;e/T_3a+Tq
J(9)]A?Ik[<#41d87793l_3o,OkQLa=p]AMSs$O5sZjgE5S]A[ns`i8(fT<hK)0@c[E(mb&`('0
cp>&/OgBF_8\th$r?lU``oKbr<BlDH;XSIQ,-ShM*+]A,cRpYb..)aoD6l\Z';69G[R!(W*,K
opp!4"7%(h[q*tIQk/DV.o's.h)]AMQ(jt>6".)gi@np!-b4H#>]AVRl`RTj'ojV`;UIo+e25<
i[s@8+UcHKYU;YF<ZR*asRfGT/?Otk#:%,4@Lq<rpt3MN`>H,G-:B;_a^4Blj14]AhLqJ]AX'J
POW.FPC#Z`%mEA9;pWnFt`N?]ApRKMPknFX?=sd_Kn"M^YX:^%f6LDO]A^2D/:gnK]AQ"B3C!A)
m<SJGjkmYjl3(kfGcN2iG*dQu3ikFqiq`'3'lBWQ4Q.(<TrW1Jk:.;K-:HkR[BD(@<">P%:N
,InbePlUWZG`,khnOYg:3'iQ(a&<@U,3X&13iVen)Je3d@K4MF(<UnetScW>.!c9e$nZ^j>R
a&Ml5Td`k_K*-Eq#/R2.^rO+<YCoh6NhQe2,J5o3IM%YaK>AFZ"Fl\,*etqEtK_?0C_re[H-
*P"KlG^LGhHE"p*6Tl]A@/>;UN%W]A)=;sBZZ<l2iUiTdHe"U=:QQ"-d=D2aT10nK+n9'P\4m]A
YRZC#mRempsI3S,ep[HZ`XGM(r8l&2&03Z:d<RZ;6+0ZJRXg%&Q)XW?B%BW\!uFk7EWC6I[E
r'ar.E!\Ql?7!Wg]AU-Ad?.H=g0IH)pYf\4eF"H(oj#)rh8\q#g`O7?NN`W3`dSC#a=`Ap"5M
XDGn`"iclD4<T+5V+@oZ/Wb/jTqVSp))o[^hCWVH^f(iU>RK+R00kTi8LiaI=L*O\IS0`9/$
ed-OM>b#Xml0A2?^@H[d^[uqOBhs"l$P%Tge'=-tj7./RCpTd%$]A.t;gSrdK)LF/]Ah0!5_TE
d?ujLNC)YUh>n)1DIGF9C=COE-H1\#Y:bO)NG$A^TUohTAM#2r&GVNIe\P"m<RTf41R<U5u<
oIN_AF_8^/Sf37fd3j8B.mWtPDK!."5;$i4EPe4$p#D-#nVGmjkpQYI7_\V[YX`7CLP)_TQ$
rG10Wa2X"<VTh7b&ol)T3^'lpl<GW\2@+;_mX\eARZ!LuSuG1IT3Oc=i&r#HNKg=!CTc!$JQ
t8smu]A20\.56^QQ4G,Q#H?kN$K>)[K]A^<"0^BAl$pe&?62>C3h.pL[u^q[C?8rJe,!\ICa3E
"Y!,8+$$5*Y_*S?/"VA-lQutg]Al0741-o0i!@jN2QBT0O,r^`?#Y0^kI;;&]A6*b*>$q;fkfr
&%(ir*N4&47\MC.hD>L),umIQ'[dfQ5u9UV))/)i=fU$Zi0QmE?JAQJo0tEM-[`I0c=hk`j"
Y2=JLI$n@lX+RG.)OcX<T.NthnlIc'90br??5Hf15!KDoZlduL6h@$#g2VPYrB(fTGDnXW:C
?(lg80gF6uZSN(%#,AVkL^UK68G-K6BJ!ac:r'h00V#"Xj-GPH92bhKkVY3>SfF+-6F1EoB2
i\B>aR/$O++>+l1C=bR4;kP/C<Cbk[=af^/N%R^<1aY9`oY\W"JQoX?7@8qRo"ZiA`<II*cP
rC2u#=5Af=0$(nMN32[J@DdKN]Ae0e;4n3i$R,NN86<WF&6aK5crPma28;C&koHq9ZKXI"?54
=Q`BZ`,0:[Lr=DXCBT`YJ:</]A)+jV(+qfkp74uPmU9aR@)"Z\3$6k5jG>%^5#T+%8#39jR(`
5SEZM+j`cnuS?nTU1'<_/EM!(K6;817a&GRqX4p_u8Jb\)UQ_ci0R&P)(OABc9lVG(dg1pWH
ZI*m$$Beo^#cnesS(n=tObW5f$n$S_YYd_,rou1`b9bG/cGe@5TTr_Y[^$l;>lhS?Ff-BD",
<H%0ka+L[kO?T%;t8X%V>`[i)VG*0oouaN'Jg_rTK#U_+"ngJ.`foi)s_24u.2pecAA=3UrN
7.V\/_)bl<.X\ShiOTJU)$)cY-KFhO3bF'qJmV(L?UX\)>3q#mrOW\tuO4'Wj!kq@[dF"4f?
Ae@D/<^/C"9.<V?A1fiR,dc<0NELC*U`9t*7';8F38Q#<Tb@`D)t[,.C(B\O(X/,$oNb.L!,
VlBBBrS"9i"+/VQ0&7@1Qq\R:i'$tWY-#+a#%3Pike`cIc#G@Z,\MfJKGC5CEpME2jk4c?H%
CpIM%22?s8:LhkP9Yb1OU'uIgH&N*$C&50ho;0Ne#`=A$4s'QpkT!Q)n@$Q''0-jT/aht!`Y
r1rk@-=7,X&Pg]AoSc$JCJVRKn>tn,e;t:gMSCmR=<t*6'RarKcl;dS8q.076JQVOEX33(+u(
AYh7A%.S,8#_:hWI-GUQKDb)$).[j!W)J`o[.R*BN'IaVb<k?'BU=N;.bf\CF<m\8E'90Ku<
Q:1U/=PtkU`kBQo)0^"Sc,:q%kk=!@Hdcc&(J(3WbKEC2FK`RoOLHT5l.KR5;j)*9BXZtAOI
^N@;gA>EFt70&aQF3ZPXCZ<P9b0'463t8pm?#EJ@VBY&sgoKajudRI=^rg^WHu;F226q@*Z;
L'JK_ZV#V?Z+aN^jD>`4UsN)T1(MM8H(dZ[`b2X0$f'2RgBh90G)</tWR.l&HfTLPl_o5e/`
%_=:l9]Au5XXkK>,H-3fl"Kj1D5(P;+jo!E(\D`\N>kS7I98emi.^)1e<m?Vm[X%>fo7e5<:i
?c>_HP,lUu'[imcX&[/*q!J>Z*U(pC2d(KHGEUbsr`?'Afe+/uf`#pJQ/LB^I?-`UP@ksdL.
,]A+Z<jp8nc#aG;*DuudCoEkKM]AZT7H';;u!J/YVI_*1-"gm3qjCbn@aeN/0Ftl7GDe>"2fY1
m_=*l?PRIb5]AS1:CcH_qY%FgDC7?_`@l+f-/j]AOo]AM*Y4H6?e5:_^?2McRr?S^mpZ/TYsLE1
1D:a=;C<6HH^`I55JqkbFDbc)Yu=CB$;ADGg?@7NpWL#Or:/F+(!C*c(-9++EAJKM8!t`,pg
&j@We((jh$YKo^Jg-ZD,)g[.4pP'E\YJ@aPKO,knp?'r781G[k-EK]Ac1at/AbfF<&kV/7'LL
O)Ln+UZZqh'6E(je@i`HU;A!CcjjtsK;HP2H`6cQDHpl,>_qEUed_&D2=qeJoR`fn[18=?bZ
I"?mcoZNd'&W,@cdK']A40.TPH.3`J%_m^/_6'neCb>q/-g5!Q1s>+>L?mpX<i\qX^H?e"r=U
gE1./maD4`tQJhF'Q:UNY5aZ4+V_#n9?7U'lmQ+1-/Gkp;>[U#[fm9#R;Q(Bfe%n]AGU)`r#[
+2.$tS_IsQ\WlrFZNXi+@>':/O]AtIp@O,iRKO7K>Z.Aa]AV)5Fbp=49nJ:CGSjOnd2cJcoes#
['FG-8.RZQlB8*EU`T'20#D)%5<o.Q4X,aOt#i1n-l/_j2(R;$`i+"TW?lc4>FU@]Ab/<jhc$
%lTk.Zl[#8u8npgdEm$;&o]ATC!S3rQn(Ft[<p#Y*1Pfj/=oM3>sC!Xt;rIg:"V:PBYiI]AuFP
d%BN\S3LS+ec;RqlC40VMO=W<&\86l2UCX=fHAT(`5]Aaq,SU(Hb-B1gC4Dek7Y.KP8nSM?nU
=]A2fUN0X?/S&KI'81\WZN.#hG5bV;*T%=r)@lnr=bMm`(W<!m11$>h')b2ZQm>_8l=CRSAl3
l(,Sd`"QJeGR<A__II_$[GI/KDqi]AtnR8H>#oAm$IbMj!3?_4!L5jmV+.P>4#[mr_qp/B+[3
J4&/N@fsCiNcYH#[Lpasa<F?0[Oi\(M3=1(!^a=+20VMTBGE_Gj`p',#MjCoClU"1Z#o8j-G
@&1'O-Cf=&F@OCSBiq)"OUBclAU0]A-;`?-[C1RmQ7Z"ncr]A6PY]A.j#]A]A\PP(so46s=\2"bel
Dq3`J;*>pBRF))rEQ+9$88p'ONU#D!C6Ka;8o'p5t]ADZJ.VAq4WMFYL#9fq9*Qd/VB<aHUeC
7SmL_MJ.;_M^GJ$(&_HpirJ'.D55IA7f%ui!sFkTScDSAEoQQ2^#NZTUneG_(.WS)9Y6VSi5
"i49jiIc+l<F%VDeW+Wc^HF<cd1K?F\=F%3%I`3*&eUi"pbT1E2h+X9BjV.R9uR*4=&`Ok*a
b3#*]A=cTgNp2FD(ePK?[m*;k>`E=!p^pD4"n*`2Q,"!0'OEP9=`L'!l8BOE?T6u8`p*7>7U_
"N/+&k%1Bi"dqr7Qc(6X/-W*a8;?qXd]AM4`q5.7l0LtA^-eF^2gUooF#_kaiSIbT:ER@enG?
Lt?H1.K;[ZEC$Lo/RCEpip?1[_Yb.VeXq3_oanMSu`>gZD:MM+n3SAdT)[ZCu$gBYe*4)S%.
]Akbil1X(O>Z=("`E2:!slkBn+FC@PXGbM_@aU)1GWUF:,$eDTMf=qn*du:mNpt'_>j\^F_Q4
UW?G++BD#"=O+q^/=P,/o>c[l,@k^bk^?9r6a:>hZKOq7*A.3lh3S0rQ9[k.oJP2sS@O[.$n
FX=.WmS[/dZ?%Qo^`GR<Zc_2t#_\NlknqiVe-V4t9\F>g[%IE3*lVEH>YB%1<c59DQB"QA3i
k2dP9)@UbqLRAECJ`5l<Ql![W>\84)]AIBpQ'9"ENi^nlGG<gdZr_2AZn?'oPOT5DSum0'0\H
0f0-,fg*)\hdp598Fk+A0uuT(]A%Vk`m\8'c0-,4gN0W*+/IE>i1FWX3Jn/hq:oo$QXtT9_fr
g4jRt<hcAA.i,NA)r?R9^(#23*:\%]Ab+>uBYcs5I]A2+W%$0dUO+rImnW_*9/D=DgPtFL"@@"
b)u)Oo=D*Lc+W5LW+3\(`9:c\6IffZPu\MB3Y&9LQEOT<!I6WZfgIH>8$oc&_-]A(`6Ekr8p_
1@mgSoDi67<+JM4n;IV9:SkUJtV<kF8lsB)h5N;a/%@M7r<"h_]A[W(W:)74[sAKJOgE9A4As
@0JU(%Y*kT78`LTF2tA5'mFgnrJ+L2if+;C=O+k&^ot8"+fCLBR*lNPSUM?f4a4gWmg%8"US
!.Yi]AohOC=g4G.ntl02@76CiqKUW:d0gbSZNd(W#[gLh@(`2#HHR'6-A;?*dVY8<KB(p>_!#
'sHN*0j0nT;T4IeX4/fpq_Z3&dfos$b.i)&-?Ck]A+u<hF'S[+0Bq]AVJ@I8+,BEJ[F`V>6dJ]A
HCa7GJ8M'4jgB'!P.&VTOq+V01D2p[Dq79Yr/MdLiIN[8bH^,;!a2Q4n!jG)kcQuqKdG0OMT
ES?Ye8&R.n%LEna$c4pH#`]A-St<@^=g,Z\-dn2fEI@8/s>DL=fKn,4rM'O3:;VV-Pf++d'[6
Ih!h0S>iAsZ?U@[H+`Zarh1TeaP9%.Hmhg@GCXZ_fW,##di<BsQ=:CHRIlp1aYjbWLC]A8tSF
)_2(T4'*h%,kE#RVunP-DrX]Ag)C(G?8!6*fU*3IYhVK6W*?*qMm92[3b4\P)GPp8o"5,$EJZ
p<d>BM+2UQ`RV-`W_8_-aUd;JcEQ]Ar]AfQNCj\8]Am6P_qQN.FIq0R+#H=nETo*c1H[e6`Uai4
jJk/u_tr5CH]AIBk)ON:9[pcf^r.la0r5ko6Ag([Ca$RO->%kVGo9@bS=8D/)qjnq=o^a25kl
+(/"1Q._H9k;UK#)YF`#=7!A<T(K:,(_'rM@F=n.]A]ARR6*5RM"P*(+6p""'!5Y^bf%cN.R>j
s^QOX(l,qCdZIXslQle`p?_aiM3B>'VI:m,SE%SIH$?%7\Dc!'nD+Os(B;Ok]AK>h.V,K-CB/
uD$R;:C(.Z@(jGB2/Hf/'$$&kia!aqo8uZ%_iDt6_R<V';%&Fn*bl0'qa8Vq!%a]AIJhr2gR"
+-]A)Z.dO,:Lbl'Qr-LSVJD[:?0WmF?CZ8)K.3*FYgYZ]AZL)jA9.`/uhDo8<F-qW%1R!-G<IL
^Ur:)/Ge7:>hM=D96Q8FX+^n_RAElj'0X/\*`N'sWr2P*fu+bjH^WLNi^5-jQ#%Vr95&er*[
rImrM.7pj"]AS,=Z"A:npSN.!QKRPWM[s+pf'"r=.22)Ngat`hsObJ5YI+0QVe/:i&W.KkIOE
8^kM?oZe]Aroo52a5DcG3TDrWE;9`%=^7FmnacjO>+>@F(p%AI0Nn$k8^IbWMj2`M?2VS>*4R
pn>\EM$1J]A^.@9KuRXF/BG?)n`4A"^)[]AHEbren/[6UL'dKOB]APIj'UP0:IF<\Q1>KMJ.^kD
FgiS3-loOuf7CT4f@UkPmh=D-AEl#<Z]AY5h*<hkQ&45d,IYm+!Ul#l`:d+n*WgkCHQ5Gb;Kb
hjepo'b().Zoa*U&?U9"!N$#ILdc>!.6[nh6R`d7h9\N/m0G\3?_%-BPG1:pf^.@"mR5?KHn
-66MmF2^7r2gUD"U6s^l"Jnq;F-%%bU>VA\9*!N"h,*rE\S/hV4TJE"W%mD(UbfgN<TNM(p:
_<76$0T3<VPhR3#qV\2S=%I*.lD!>/BF8OB#$n:m_%f%-V>+#<RL`kkc=Q8br%o(OZ4INcf/
GY+iJuSS?q.gat/J%2hT+VN'T=`N.?Q$C**)[R=2OS*DOH[#<-rg"C.5Y?YQ+cFiM9qX+<'I
A$/Xpsc6DYB+Jj+nLe/>Vi$Lb*=?5tWh`aPpK>Q:Kr%ZUZIKJ0bS:d_=h-n>fHCNgRW;9g,c
g_#-*%T(GpH*[8t2^V!1#i%boX>o:\k#:`477hDrngR%JVXph?![VXo==G!Mjc7\UJ=7UQ[B
[p"dL\Vi]A(33R;JH`r6u=-Aen@_T,ioa'9[]AI"N)8RQG9fro-M/%dC&)af^'N1kq8P=+p[TP
K\`&HM1%U?A<;u5;5Q(IPp^DQ4ek??NiDcK\8E.!q,;uAgj:l1^ApPV2oo7V`buIt8CS-.Ff
Irqqe'L/"g9e)P=*`#(^C_rQFD)0r,_l^S]AMW#N[f*;_4<B`%a95\d%DWi9@J5]A2`NKG]AXM4
5,Bnb8gir\,m\BJ,6@]AJ/7bprM3GsHhi0j108r)1[O)Jt(DjfLXqej?.%>=\9&nDb>T?;J5n
\.T8nk_7>G,j4PflA/q0=`9spL8f5CRsd.^h\lgef'%\')bXi;L)V*m0lJ.4bA,fl`DJ<N\F
cdj0?fetg+/@s&CsXPm&t-ejZM^!P51knVL!&JUH/<8Ib`FQH6'+^6E%(`PU-9BV)O>9Hrm%
"_McI)D2e6Z_+h[XFb8mg)-;u`iG(u=rFYtts)igdNftobT&f1d,@-iQN+X=:OWf_qV9Up!S
,WmXWFc%t]A)9=a7j:7Wpp\bfR@>d`_9\(=mo9BFDQ>#S:!:blAF0^u)NPn;<aAK50ls'aj-M
]AGJgnDbU(qQEC!7[,=*h*AYT,S]A=u=0^i:>:>mq&b4pT_!GrS,G8%o^g@FI&Uaj/-5$UBES`
Ukp/j1\:X<mcLD,(`s82)79D3b5Wo=P-:ZmGQB.62spY@!D_i`D*$8(=B]A8+-fA_qd!;9iVh
p60*r~
]]></IM>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="1" cs="2" s="2">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="平均职级：" + round(A10,1)+"级"]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="1" cs="2" rs="6" s="1">
<O t="Image">
<IM>
<![CDATA[?+G)[<8I:4bg7BIO9,KX^sF+M+eTq[$k-Fi.FR$#+X)ifO:K/.K/CZrdQM[YdR]A-M0@/hYqs
-DsF_^Anf"0I]AY?fcUW2'<SN0o_E$O_kd6X<.TiEl4s_?o`SY'E;aoiP>o72dY5qL3L4?O9D
?VU'T9?^r+6rksJeg?4]A/l_Zg\q<*E`gKn;+O(Zr0``pFCN0tQ9=*6kP0bqJgI#)a5m[CDPI
[X4)bNEbaE1",G]A"5EjeL]A?lEd8n]Ap;;&\C0C8f(E)-/EeC'9(RZq/9Pma]A>_;5[AhL[P$,'
9>&pdUi:9l=U@='>LY45\FnEUiPMdn;LCnQ<ln6/7\7EVRa:6q5[b60GA<0d65]Ar6qV)7d-Z
O#hg9QA-8J7`_@!WWn8%:8(:RA74q?@t.qSV#jY"gmh#D@POKkOaXK^ij?/-1Y^)-2mLFYgX
uWdTof&9TN8>Dbgb9Egt:E/h;$f4e1B./nT<X9?&ZsRX1kYpUnH#uTZDa3QID\G32FnC`]A+r
-9ZULa3-t?>%^BKL,5]ABuETIujI=?XVP6c4k5<c^\.cTCg.J4Et!<53`itM"Us6mA/2ZL]AQ'
7Uj0ascP\pD<E?#YH[>Sl-_1<PK?i/Z"6#XMTXUF>Vi&7k3!(mOC(38#HSM+fk_M_h:d$&]AB
>b:Z.O7iF/ql7dLE?iD4!./mDPSL&$j\H43b"@85>,#Rj;hP8ksBCE=K+YK-s=4Lduq8oCoD
Gi'[gl7KhF$9C?:n5^%o'65-_Vl+Jd>TffKU`p:7:[".[bU&F9^4(E,0f@BOdZf8i?6WZn2k
KQQf]AqObWoTP7.Tjp"U+2b?`tP$l%RrJdUEIn_Ra.a"@Uc)e\^?f>`0+b85fOZZX:F5cB7#o
lF-B2p9+%\^(5h2d\>@(NqOXF]AGZ?GFKOXS;eBm)Q$MSDcT"&E\\DB1W`7AGpo'cuj4Q,85^
[:D'Efr5"=uGtQJLaWK1GdgT+rVK.PVdtifYDSq8IitN[>\+RWWnfV6D*b3,#"[f//Jk<a5Y
dU`Pc)IWB[7u=?j+j4V=!s6rFAddt5B(177`3cY$nG8hELjee+]A?*LCS(?^A25J5ULikD,4!
HJ,s-=E^q^3m*TXf%4^8M+^1nWkf>mV[-Hp]AMOO`^cQYZOscP4[UP/CO=6_0>^I3?*MLSR;e
C&h`^AhJKd>EpUmErS\PkF6k#R0=R(XVergYuoVa#2`Qn.FfjJ[?FF3hch>ZJJ$Er:5tB0fl
OLQTAD3FpS:.@^W8V2m)bW>r%h?K;,j;'cI_6'&d&E$7KmJ`JK)rnr6R##eG"o5q<e@<9uu-
LpZ1&aiW4n>G'BA&V"dX]A[RjOM&&R+p*6l6QZ5@>i?jr>\Ldho+<J5nK'oYUn:0AdArk<l<]A
n:kd&#cPdK)$f^f.^$hn2[M(nt.`cmEk6Pp/&ST2k]AdYq]AB1N%HScD8;B1`88]A:FK40+[.%=
"3lW+(mf]A_4!)2$:gb6-G2F-]Aptj\siJ;NEO`4M7?T6UG%DHrN*5B=c,aNC8lJ6aEhGQC4Zb
<`5hQ7g8?YXCaXM^(A!o8=&Z.N09ikgD4G7mrU3nR7I5`2jLHWIBIR>RT>4nBj9Q+X+n9,D#
Q_$KcN<V3GnD2a[fc#%'j$l3-b$n=ap+80AcM^_4E@dB6A7ZQ^<.u(OK%n1c9%[M5_`$V5mP
F'RJYoIDGK%]A)Fle%DZ@fW,tYmX6IioddK7/5^Wa`4\jOrRrGBp=k7gM5Hng:?b4DX(c%SMp
U<pB=/cFU'E%%u9Qj<fZRVMoftQQ`FWmTclP:Lr<YUC$%HM;tZ9"ebE5YRSNdaTUd(rWZP3I
=.[J>U^BQi_p('*,fAUZe2U+^F\pU%/,EC\dE\W.97^dE.3mW6V82US/TO+,jFIn<APDqIbY
j866o(+4ZUm.@B`]Ar]A<)I4$m,.>A]AT5i7g:u[5?tm*'&N=&//lJ*sY%K4-^:g9-+6FiMqKY^
kY'n8qb#K-P=B]A^."tJ?KoXX+<qoj3J)8ecdUcq`H4I9buO/%)R+o!Z,dG7NXoiWJ-Pn$gpe
u'p"@GI[H:F^Vu?g+3l*9c&.5^--B\M5H"Hn%^)$D%OTA7UmS;MDN^Yd&PZe!u;[qs2YU2"D
*]A/<J?j?]AYoL-,qtaahf$MIQFQ=_BsS-n>`qlQe#Z'fkc56;q<\G$5P)uX?09nR@/ln+S4Sb
OW7*.g58:4Gp(Dnlk4U"i7<)brRhg".>q!M?XsbMK1m.N-X]Ac3SWG.UMVtNDm73@5rcuY3T3
V=GS^b#b_r>@bo:+B*T,$a()r8^V'oUS[n_&cq)G7Lm-9$?Li7U0bD_1PnjkDjE"6s(-!b<R
nbha"Lj.r=,Su$m5:d$X:PF]AWBQ3.ns]A07o'!R%>=Ee`iGCair;WRj$5n`M%]Am"L7JBX_(s1
2JPUh[SfM&;uH?&N.WaI:@F.RRO.:<(%Vdl']AhIgp[H_=&/`<:jcN"A*ag%8alhA#MXPug/l
PUf?[$h5HI\A^?b"X85\YbDB/8?f]A@hD&7X[kfX<suS)O]AJbm,3Lr?NN+o`j8c"iMo.,.IXg
*=p&tjZ@V*@1_i1hC7a+aLK!)1pq]A\@oQY-WOIbV9iLP+D[#%eRi%,l@@B:5,1+,1CkM78o\
rf,n;f6=+Y-?`dX4!Y8=Z8J@'K.n6O=:LnuN_%9To,>Wo1.1F2>o9MsIuH-!(H1^7K0Vjkm,
%q`Rr`fU*Y(TG.I\KW^AVGGFh%Fb[Dr*Z)ACXt(2"c(4?-91Fc`F/a@B"gp1-)t#``>R0M@B
"qJ/r/kHHQS*UN+.Z`ujX!^!TZi83"5ao1$IhU!\7o18EA(?=N=?huTI>f\.[i.\^Dj46O(D
=-8Wo-#qBW4K3sP`QN<?A>TBTprkLaN9.I>q[fi8?`HQ]AO*gDoAAD4IqC)kQ)[%u06rr%m7P
9MY1^GtV)#E"`pbc1cbR4YHgu5f&&caP%&>kD#)?6/Q"&!p%Ukh9kE(ISuBg2%K'Hhj.r)aM
3TA-Gd/7QPlPd1>CeM2fW&ASfM3tae"9VH78tVc^[\WO%m66P:#Z._KMg*?;8H68A7Ep62K_
l9-/,i@u#8BOss'H3C'KlA_lSF+d;0`cIZE?QfkuG8k&F&;#rJ8HS5o`>L!*\8M%nh#u'=O8
@'c[,uN9A3fCHCRa\N`)0q(Umj"COdHd%"%J<HNs8'Z5nn1ktFQ3"q#(+bR$h[^qp%HUo&Vk
UWE]A15&KS#\a--Ds4VB>k$4OMZ!.9YD8^R8cBeF<j*Q,,R>OjN"Q(:X%=#hB3J)[4N7\"[aU
6,QA%BdNU&Q)i+,kER`=j"+<o%f?7Sb8(XH<*iB08J5No3-hiODOAAb[I%g/P,*`j6s@O('A
PJd&!hK[$j^GL"IFL^n842d)u)9Nmc?j$LHP2tJHu`E_)fC5]A!!]A\eagW3:Ts#:E1N9pmg\_
A\KErQ\Y(.n,7BcW75>#qI;@$Klpk!_=n.R2@&n:dFdg6@WZ_g,A`CJEO7m9V*b,FgMT"oOH
r5.jgced<\S1(9JA!kZKZ%):Mu!SR;0FHs(^HDER7Do@AhW<Bs8C^E%eWla]A@d@9@Wb591^B
=7fqZiiV)6[kO;)[a;bq$7[rPr6CM]A-(2">XWA;!;=cJH!HUPq1oW0)0F>[=s+('D'ZA_J>D
R96lP#Wkh"omiNMaW5bE$WAJ`'1,t^cNmV;@00bAaKJ98)]AQZ"U;_TY2[J]A9T/eOi65O!_ld
nV&I@ms*B-[^-Y.Olf-]Aa>TEsn]A>N@cb&DuC#OcG7+g"UUU&`3nh_jta;=GHW@FPI>NP*99A
4>j#4%F?A<IUh.]AWiSKsbbaO6)]A9OS1nT!)<3e)CF,bqB3m7;mINj+O]ADAHs`e=h8k.ts0N`
qW17Nk0\_iP$"9(lHD'`k]AE&*</uVH,m\`M^(Q[7k3nDp1*J",56/oqM[iNbbH$kV0FLtT)Y
-<hZbq(.<]AgI[6Mm`<E<u.En,GFNJO9p#=S=WMFH>"Inr8C`S-;tpqC5aHSmh!am5QRkQEd`
.!CQ\d>B3VK0dPh"MSuN4Al=t.Lieibnpq)8]A=5=#Off(Gs^Ne,;pJHF/XEHro#(o81hNu85
UNS5%4=n4QP;jLOJk]A]A,+'6T/*1YKU$]AZ$=\ks%G%f57F+3!i4iZaQUU^]AD7t.,bPMI.;K%#
=.jD`fNIB`g)DMgBD@#Xa3!ONhRZ=)sY,o/:i\Vn.gnmHj[[5nVd1!pp.BcA5Mggrr(4DT.>
)tZ_S3+$XKGW[Hr-HUUd%E'G.ITO0%iDHZ7J,dqqk(6ir;<.)-in5[SGlCA[g;#CQ]ADUtq4-
;tH5']A_9!tuSE0uPZiNhhF"!:aSYsJA=e!?o8V]ASu>g;L'OF[$aWH`MX4E-/DK51&At?iTH,
AZH/2k'K2<PFF\.1V_\dq_f&fN9.C3h_rs_ofkq1QV#M=s(rKu)<>_H,OfSZ[jlQ[H*+AY^d
Tu\Wus<cjqm'7o_;A_>_SL[B<lGjl7%\E>;/l/8>_8pp[Jr*9'\g_hC3_N3#.N\Y^aD%o!Lf
.m'1.tN__:a)0p+Bs1X*HQ(aOG+sA[q9!ss[:,1C[RkupjpARQoon3bndOVY'atfNCnOGkim
K*0)c:7><M9mLqS-%)^C0A($*>^"K-*Bh66`%NaF%ZN%YKk[9XjbuH[OSbbGDknQNtfoXfm(
DFF7Fkmn2Boq+?,D'3N5Ioj^G:8?!l!%TkQ#kI)rqhI>eo-S'6&W(s3[EqeIDo#Uc*0*/9Nc
+Ln)jm7Nmg&1p\Dhn]A-T4`0`uNo#Un7;M(^\k=,Zl!<U>L$S'^=o`'YQnaG;@G[PjCtK*BAS
OrKJ+ct,i8]Ac]A)BVFnEhn2MT*fR>H`Mm.;$(n6Ua.D(?t&+P@a\s\*$2F''>lbbAOgk;5d`+
oAFSu=FoQ2V?/hd.l_Ai^3'bD\(oNKN.tfif6L3O>h"ZI?@).5bEGpU;+d0Cr8sH(^F:mH_O
mW+&O(_`n5LX=W-2c,JDtfCbH4EC]A2NJOJAqYhV91m&bZ^]A.10:J/k8\W^Di(`o8EfsOO-o#
<OXApV%6dRPRl9,c2U<RneFfdYejVOEXh==0Y$hUBu^HUsM<;@#emJumo3_`%tPt1D$MA4Tn
AT]A+R"(Q,RHp-)1rqC/u7c`QA)/QKpFY^?q[inK-N0)>p;LF_]Ab^=hM2Z<D$3#Z[:QI]AqZB_
*V87E[$8Nef"=>T*P)26N\o!bY$[5a9K?HREXTSK4.,d87Qi]AI4*UpR?M-A8c!mjtOuq&Jk"
S,Muft$Jl%IJ5_]A]AB+QXkJBPdt_,>4api9i.[n=612GRZH4fT&@&dib&"*/EaauZI2Z;\%9@
o&X]Ak3**l"lfRsJ=d=]Aa:fiN_r_%sXXsO4k[]AVpI_=<B]A6@(l$<YpH42G\f!WO91aqf[7]AY.
>)R]AW:24@]A?$mmd[cIkau\*A$G]AE%mcQipIJe+#\g23q3AR#;@CI>):9NoD#%,VrLZT/^GcJ
hI#Ph?+L?i\=8]A&elRMp8hn.EVJ1BI0#PM8'giNM+KE/UI"-(T1Z!ZTmqfB7c;lF\Z/sEiK]A
)NAs/acR>[I#&1:n,3_Eq\!p4BQ84L-W7jX4Cr7(-aqh26[n<u'B5EJQgWgF;VT_)\pWo<*D
c\N4*ET&]A?7/VL2NMth`!9gF]AqE\<$j^nfZ$\>qaaSeiKD.MHab1PWq/[/?N8DTJQiAU,Wt6
8J)&:X[:q$7PDSZO)jSqZ]AIRb!L,sWmEuD'!^r'$jhCLZ8YeL4rk.&5!$G1J9g;,s-$-$/<@
::B6@c.6=d!LmV@I1BO#/Ae^q8'S?]A(\D9784$ePSGmZEW_^+dmjUN^'$&OhR=e((;1a7Q9J
0.!-<muj)L\QQ-\Mkl_&fqbEo^OgOMY-(8pgI.ZAr\LCY@<q1eCFSr\YL/#SCN?QrLY-Ma+E
riNZS_EGN1Bh-F4$gm+UId"^XI`.L7T%L^'Gn:?pR"'kJ`a0l@2OckTtTHDkS;7eRV@@"Bd5
Yh&OP9Le0%7#lh>pNl=5L=cLj?k^;$ed\T-"h5>qPRN0cuU3Y+]A-Y]A]A%(rY4p.K83CaE$J4f
ic.D?30i:S'5*O9imFe*?ZT^qoI.$am5BbbF@'2YYNkdl$U4[1N43T*.o^sWSFB"Z[Y7&eo"
G2e"`^ie)/fKBt7.'4Eu@<'O(BpT(HeCo_)YWKZ#up9UHPdr@7m^pT;QC=;5/n]AccI<Sh?gJ
IF?)pmCg2A>#>hm)r#M0J$j+6R46.m<<$"#[>iR.FW^r)10=2J/[Y')k*-DP8.>aBPfa-!6D
#EUH\h9^!]A:"VT5ZA<>CS^oY'k/kk$[$'1oP[?Qq"EcrQ!>D4i^,.RDo1-`4s(r$<4b/^E,!
-l%@?@>r9,eSpKKI=K`%@pgDRS0/fuRKqRbr5PsW@DD#LkqthXb1ln2A=_Co/8P60.,AZqsQ
^F,1f8A%GG9YLS)blZn+c?@&-,,iBnVt,fI!ON:U5)U6)EfLtOjoW;_[Qjg5JmSPHmg-tGsQ
F(,243rgTEQg&C>)uNhA;gC%Dr!+D>$i7"\1+]A9<Ff>2NXO`(XqWhE%rfRl2XT57]Ac3:-%e?
_0Rd;&_>Ve#Z1fmO<\k6mh3mj*MWNOb'=.V009X5j,msF=`"";[lS`Ni#g@1A&BJ5EUHbBrS
C4DJ[tm=n5HSng5CT&'c8tuqH$)b2QM;0-G>^$1]AL-cZfUhD^!bI8l4\fs@.-m0Jm@9L3rP-
3^L*O]A!jAE4efVK0W\78uN8"u'J$UDW^=caLLZ?5[?C'&pohVUnBQJVR.??^NqhZS\PXESOq
hd6'Y(lS-3"!_lpK[IZ]AQ_eYgR:55X6u3/QQa#cPt#)\=%!@n$6Z<h#)eL@\]ASc1_(aO!i?5
k(^o+iGiefV'mDqmm_^V3\b#^A3(j^+.!,H=eBX'Is?WpFIM1m$=Ej-SBajL4G>H9$'a-H15
(?orV@Ch>/qUil`TX=.Oq$t[2ld<<J]AdncN&@>BHPKeOTg"9(/,r3[?k$=*:;P]A5I\*MT]Am=
Et:Ar2akDkAcamHCpPmV.g8,X-/<ct=YLMX,B\]A&#!HmSZ*[M4Gad,V3!0jQ2Il[0)g=2N"W
5PO$J0a8rZfe@%>JeM`Q@9i<$RVa`*#7CBu6cIQOb%5G^ms48NWGd2Dri.YnVXS_9qA\ZjW.
6&XtIJo.+qj+f\3cL+VcQCYg:6p]AiH&S8Or4nbkT,@@i1JlLM]AcOpOfSrmE\NZ%EnDc\-(SS
EuVBj4UT_Gf/0''t:UE',)f`dB=]AEK%RU=6gpS^FXr)%c4bBTML=I4H!p'lK<Y=t]AHe2bCF>
K4)<ukF)L[n]AF8[]AjZ$.QPOu)q7>4mgjbV[S?dNFOX"IE`rSLQGiX$M[2)Ytlcp*=C;fTP9#
%:Vr/qZm^ijh0Nd&l8b)SJGN^?[/oc0u62j3\crJ__NiP4]AI3O-8YPN5b&)n:BoS7ph)&q?Y
b>j%?::/o_#2.O/Xf.r7;RMsdQL[LbmMCj43cpUQYNPXLIPgjVK+0IFWWObA-=;HX"GVdqZf
7[1.%TB6hiUolOk'=71]AN^:VlJECJMiA'+R2DAmD<Z^R(K0ike&V_5c.g*<Mo3jW[<oB[W,o
m^abbg;NY\Q#PNL@]A2eeM.Y7MMje?;Hj('3U]A]ABctgn>jY`QmWEjXuZPeJq7DYn!D0bA>%7C
pmAe%N"-f4B]A5Ua`7f'p]ANbf1^<te&;l>_jYjD5_iiAu<'B-eell$fb#9?.tAf:bEBp;sI5U
6ja\i_B:oH%jEZ6s.[nE6,R4d;BrQ#_b:ran=dR+=U\g6g=J;hV%.1EDIH`5E#"D$%519fuK
DgNP.G0pDENbM-Z\iFD=N`3>!Z6`P5i(o_2JPcfGR4ZqRB6gSb_UXJo(MT%J$-:BD_^0G8m<
^cq@/9_dR8tl0MHk)Nkg2>K4/_;WO8;l>)*K:iJdrSXN"[&M;;=O3'-I)P4kHhmlS^K[GqCh
ns$1Bbtj01:[<7ABZR:RXa_H0*nW6p3\%_^&qlR1$*<r#c@;5iHT(\ss-ANSs/B%cG0;lF4@
Uukr0LP[I)8McgDIJ5B!MbEc#K4F_Ab+S$Ir;e&D_q0:j!W<OKqKoN4eBB1.mh54LW.@JK;C
!?R==s%8J<YM$/4H87\Bg;]A-4BYaPI9\'eAm6/76@9)>FW[+aB:$L4W[cTcI+e(f@A'Y6bH:
%8(quj<)r]AH-9B.l%4RR#k*&&B8Zs$$kV2[cq+Ej3>,,hVE46]Ae.m)LV(&n.;=`[#:0(NV'A
9@*Hbp.3s-5q3cr:^%BE&JhKhrm'W=54C;BQfYr;\dW(GKSIS>1BWLRqY/G0-:$YRMK.QF>0
mfCLJX4[q,]AX"'SA48*2KOQsEr(dt%BWU]A'XG+#Bj%HiC5[(=J<C%e0WO(n*Mu)?ek2VFLDd
V;k@rA2US?hM'QtLBfO/7SHgUAOgr0r+'.OTT1o3F(nPto5kHTR?eFo\5m-3@9^DTG2W.&7p
7Ue#s6(?>dtViI,%hL=+%2ZWuBNXP9%;un`qgrU4/ngH9-mh0?D<2d%N*S[flneYqmo;E![7
mpM>+,5B%p2:m/lk7l_dL>fOBCZCD%ZFgGt`Tg/CH"f<6)PEoe&+jI>jcs"PK_qEc%Bl3Msm
L?`u.Ed[0/O;bbd$.a+.""-gqV]A\j*.VUjP=\@7GNitOL2"s^Ofia_-Q$2+HJA<bWU4D5cse
=[W._H_LpJ6OV6MYAKI>s@.OE6RQipmc6KRSN]A)OLm@r^bb'ij4mVM59Ba7gp*;CC^tmg*0_
::g?IL8G2b!S->86`Y4IOQdV]A5o,Fu.R'L?Y0Rb=lds?_e:E*tf\'`N+V7R,S%,c%l?8IsOT
sog$Ft;+SEnl#[e!Ot/MINjC/<r32eJnlSD[MbF@MF_)Aj2CKT.o>U0lA,:m1R_J#(%UL$B)
IE8.]A*;Tp)S69(N2B+R00CfLMEVNS!f%uJ#Xo`W;M0m3Xj5X<4**+kiiY#mb19c+4%<_t&41
VV*%JH\#_Kg)N^Fl*$U!!$")%SM)>#sAp5mnF<]A8N'XW*VPm4DTUc98Ob1soGfb51nC6BpPi
su(J<k/'T0d`dXl@:h%L?fjQd%0A0ct3;HiRdMu`alHHol!C$9oIib-jc)@Qg+<L__h&ZeQh
H48Z@Em7eT="A)80[5CUbpAdIRGu'Capq8ibhWgCFU\F6_pLM$K#3m.1TSfsC83OCrhu6kAQ
+Ytn]A3h7hE)0Gc,Sq&kj/ab\>P>eT`T<5<P4`jme[+))2UH2rp1Z]A#'/E*.$hjOUAKD'KmW7
+gcq0qfjO\C.IMYu)l7G#H6i,08D?f^r+5K8/5\ONLY9K2WBt%2YlJ-"<XMkrK+jEG!lG$mI
5cFhDDX[;JK;mk:)f/Gq`O709(*,Dcf+(aN?</d\o>3@0]A0Z0,Mk-W_"W,\C,VXLdpsn$e*A
K%JK298X#S?=+&ie,>;muWa.-<n)<1TjK&+T!o4sI\$@AOa/U$YQBhW6dO+R"(^r-S6!8K?n
]AC*+VTOIU_LLD>%&8(u"4M"Zacku7Qn>C,l$MC1CK!2&-'5EmC*k.RfJG!3rp\l_-8eAe%^`
i'&nugSo_?.%Cbtp*gpiB#::W2]AZ:3<PZ>.['(R[W:Vr`S9,(C]An2PJl^,k&Zt7L??=A^$S%
4H-)VHI@0]A94Ls$aC&#Ct1HBj"eNrZJKS?>EJ_j?_*3[;G=[Ls[ZOm(q.iTQq(3`-7+6e3=L
bPN?2_B)/]A$MsSfb#9r>nR;YB.U%XSi.5`H"erP<ZjIG$K@]AJ`[dQgKrWeZ:n8>chE!hiNc3
J\HTQoKX2fG0Q$>6W%HT\c>a/39m7(F%$oB7-O+fu,_/;e!U*8rA>T#]Ac*G<:JglIm.iGAj3
e1hHQeZ@#!'.`dsFY5Sl^%aIF$J2T+*iA5OrF5':hP)-3$i-N/]A%cjP'Sq^Y96ua-V83S02,
/PWci.4crisS++CtPpY>$pCBf+M6/mr?2%?Cb]A$^W"T1bI`/*h5NXGI>=*=0B^HS`Msj1Pg:
"f%UC@Bm"A7ECIS$NKZJ9.A8[tO(/KBFb.q/V.pY?f%8=p\$sUSo]AW[!_#(IOPKXJ6aKs<L+
4\h)#BtpIlm<mQCrdhBk[c]Ak.EC[%bcI61R2HJDS#=tW95'+]AQ[)>Jj,TdCUD*'*1Ei3sN)L
<gQ/F@B'M@k4+j3p=W>qY:3%,8TSu'c1.H">&UL7Z8H==VBh<Fb`As&0A^bmt-6[/m0/[)Lq
Fg.LXOPd0"djV_7!3'lTNVG.h:ae?f5T!J\]A_q1&O^^#.pXnDrd]AZGRqG"u:'nYVbRcg/n(k
R^]AHrO$12AKpk7]AC]Aii0qtVoeDbrjVP7Wp'9ZQ2K<mi@/\R"#S"o.a\m4+UOi0ODH"/')`?u
b37,fXK=D**nqTu)P:tL`!kT\V*>jJ&H_r=J=RlnP(mHP%68rnb,nMF'^(JT@3$q)[YYQP4k
&_gB.ngbu"KJ#+$r^KIitRPKpWWofq/0UV<D^T-,4M%SdElgG:rgV!%XE9ps/dLn2REJm9jW
1a$7_C4M4ZZ34!-d1Zo,@C85H9$r(WDp2m?dE?hq;tFkBsV+DaWfLY\FUZ??ohrO;$'`Qf4d
mr5J4VKs]AOkesWq4U_e*XM::bbn[XWlQ5<<%SJ78Mm_htg$u\fe$:Q!nSnC&D>p$;OMMNN0_
cDjU%Q]AE1pftcj5.j*P0Ne]A-,$)V+XuFZ)LMkrI,u49=LLu4[Sa(fT`_Qm/h[!q=U06r:XUA
*-diZ_6FEWQ0q2O#OSoU6Ln+SG$p/=ik;D7i6%R;>Ol9_jZ`":2Ojajc*Q>$\I$5=XRoW6PN
4-M0X=oV<%^_+#Ye8-:D02h/?P/20o-ijO+1eHNikGR2M3KX=8Ot>%Y[?IL[m6E^5<:\BMT)
h;$1!!3]A^2IKEQ7<`!D[`48u2KbBC;!JI0)T^0b!>SMg-"+2+P);S%b]AJ5!qk$;$UE&Uqp_k
?+ZZNo6V/GT-p0%[1.T66$`AJ-N!S/FPB!I_V3C]AfP[DrOHGuXKhqEtObe[MA1NNc[URA@TN
p1X>K=ER%f,GoB<P#$(MiiVET_f4YFS,8^p,KJ`In*&;5S!o3hDd%4^;6W]A)<q/)]Ak%a2SsM
r.hliGiM'Z_&]AR)X;7*4FNDPK/Rn/a/&]AQ7e*pOBh2f:&P]A&D;sRMe6Bagp9.[ScplqE.MH1
:\1=8<,Gr9&s@Bf54"*508[Yq/&h#;&-5o9hB0'C0Uo@DIS>m)]A?:ipJ[b)ZWL1">pTf3)9r
N(1T3=,ZFQqA=Oh,:%C8e^e#U0ZE7U"uMaq$9DQUP<T_#:Q\X1(%--UUq?`cKhlBNhPWJ^e!
%"/lakfU_OU]AP,86O;7Wbnc6>bb6L68[DQs\r,(%^p#a9,mKBl4C5&95+gl]ArtZP,4$iiq>e
:$Y<!%ZO/`2;GWW2^^CBEC"pdEi:7?'R,AAj:mg>o/@VNM]AZNWk`"KjcisS]AiK#o^kb\>QZ?
M.!a]A:O;r?Q87&=F11Cg-F\kn4dNr[4luH2OdRX\b&%5C':I%(DbBaBR7unLRe6r"B4pGS`K
86BI\\f->_MTsQ!fU$1Qc%.)C;MC;\ph:6$:9Tai@UKOio>S((*M-N,5.7@<$Y)CL[O--N0?
f-%UESYm\5`f)6eVPs/Wg?UB$4:o!I6a8c5W5SCmTDL)Ge,o%6Hee?$Bt_q>D9`e:C&1GRNN
eJdsd3/g'MR1'N>K+6656Xa>KZGp@Uffop(a!c=a2Y=)D9rTS!/79SQQ.+1SS9B\5MGgt2]Ad
L8mSB)sQ*hF%"XmEt9=\Y-<5ra)_H4nFZZT.i"O(t0l-,nWVO15C!gD2'^)H]A('Md+N8[#0(
KGP!TZ#!onqYf6LXSUi:Vs)UBpo>2FXo%h\j@Z-78=-#aZ6A4h<RhGgSC^14Y:<,+R`Bc1>&
aWWuq/MtQn3l[l%g;(A.c[mNEIL>b>Oj8^.6O7VmcD#rY<4R9+jU\T1@2"3I9_Ar?een]AhG>
ImKI[rXgE2lSp[f[&Z`Z8jHt&gVJV)`Ue(\OAX^%UZeks0,EOaZ-BA+H4c/L)!J-JngE?T=c
k?n&^#cG,(S:'I8?j#WhMI&-)>WN%/$nS2gg_g@";)GRNO*ibWk#"sIL)`f[<>>XcP/_17oh
bQ!96]A\U0C(3mo@"1=#-pb-d1@'R#lTY;AK)ir<H6F_1afbO5B5B:TXYQ0E5g6E*`a[Z#=gh
A%S3Q3M<\`o;WVonW%7N16=1\.`oRJGG#aOf,;+=oSZENPht<3Kg=aT>`g+aO66757FqEg/'
25)h4ZJ:j4rECh,VpFZ*f]AEqdT8fT6ub:T>\]APLri<icam'.A]AhG7fk-O/bc:P(+=t)V-NIK
>J_iC>HHiWp)0g[1V/K4/p%1>EaT3SZBT9C!.)6&k?AS4P,oV7$d*fHlqQMB_odB*C!'IPZL
7OU2B_X%6'UQgoiU*$HeL+@#eC`*L^4O?P47Ulj'T1B<8+;67tlj;X#&H@Z@fnK'%?Ohd>7D
K"SnfP]A_-c-Sep;jd%[R+UqH/%Bp5%9$>5DLppYj^8c9g+7)S^#<Oni:VbQiIEfj3TMSl*j(
MK>TcmM!!K:8APCNmGC;!LhYedbMSAu-V&L>B[#)BHI1.`pBf]AJe,FEjLXPE._iNIG2dHroc
iSM&=2*#$.eOAl\?g2gT+5C\"r\=a?jtdcZJ#'[$s3\g3JiB;"r6h1%s8#U$gGV4l@?YM&@b
F:Y<r-de>>IkYjdU=,dBE-+(gBmSqP#0+Nq+O6iDTpe5,amn?>/Z7!R;'iu&BH/o184iV"70
\0'EO@24b7M^NgbWhGk@OSa\RMaXcK8(%@Aag.Q6s-$X2D-rK]A4uLoE,PD)BebYS1<B+H.;X
5QNq?#@M9,()OlNcembnea;7T7Lg&);,3EAq:-\Nt`;)mu7XT1Z<UXU!0HcYk!XlOT0*Ep-4
<q.mb2RtN&n_m<kFn%J*r[S_T'ZD6tdg.-Glg3X$7n3MJS2g,5H;U*WaU(/!n3!;C'#5WtGP
#M%=iH6:HY5;(=s3t/Gncc*bT-q/+"Q)%q'4R(i0)^7#=qDahNNGOT.G_=Zf':bS0WroEbf8
g%/eST29ZVX_BrB]AiUS=V,i/Lf^[MY4an7&6@=t"!5@N65g?kp1^p^WGo3-$Lk)tWYW55""a
,>Adg6qIEe5_0!=5a^lP_F2t,Ee`AqH[Q$4,f`<>0gR9%32n.9^2(m3S<mqUYN29XHli*">i
ZN4DM9J7'W)-YP?Ephd]AbKb'"<"/,q]AZqDI&/<5^0,pPOL*X\d+kEVA*Q<*DUWO!81'T;!`8
X'gD.H)(5K>^OrGfKkWEDF_`$V7?KAQT37[c,H9s5cj9%1h;$[XZ1mX*m7tmog5Zop#chD3>
EWG!]A_o><(g'A'!N`G#;hkk<>5/R(_!gQQqfT&$c6**4HSAZ@J!1Q`eJ'I'`1uCnaJZ&77]A'
'g&>XAT#\c!(=L+RFm]AXg)CJCaU8`cHiK5ABBk1(gs=l*?NM#&-q&TqQhP%A1Do?,AuI4M9(
WjVN_fY8r>CaT;iK*T1Ti1t$;\W@bV(:bR)Ig=0%X`mhlG8G`W)?Ts/hji$)HYa0J2gFf>/i
:5YWN^'Us!f4pXKOt>ASncBrC\tn@u*2Cf@01W8coo_jG^&XJ2B3/p*D67H^>OS.QrBe6=['
f9Iuo+B/=&)V!AMpVCO6-F"a=arD+A.0>1K#j?inAbI3sHDruacSH.nuj`VU4i"b`AiTP%H^
cR_4o*)]A=i,"e(;*DHY$COSICQH>U@N?iFkOQ?H[t2SMbD78e1`L4&AZu'$bV@j`C(TCW6LW
Oug'Rf2k)RP=6O$`'X[AbC$87Yc4$$cro0R9/<k74gnVQ=mM.32rgWdj0#2]ANK'?,:ljd99Z
pC=GE+$m"ffU;[";(%hXSW.n<&_6S"*SYntIs6=:(:9M$g6u]AP#b'MtgR><Y4ZunZ`@(&4#W
IXJ*/1d.^?sIe#h"Y-&\_PU_7?jQC^mr"hR'aR%ps&X:p+>kc0op1qtm_S@_PF2gM#u$3p>6
.O6"?6d&U*c$S(t)KuWj.!;ZN^i`@2erP2d'?6O6nQ:(,U9">?(7hSX/Sa/-0&O^QNc46I>P
',ro!&Kn+A*f^r*Z.chB:D[llns#<nq25=isYs6D94]A.Rb0RlpAGNTbHN*X\aAX-q*,k>^rq
D(QZ>kR;W%,shi<Dn3=">bS_dE_^1<o85\(m,cXuZt_0V;b(M"OF@iZ8C>dTPcCbt]Ae9*GUe
BF="ZGL=*2<Y*Qhar$Dr3*m]Ar=QtV_O/Yldl)&p'X,@uk_&O%)*Nar$Q2`r'9R#iE&7a;DQs
=Jqi%j0m%(TI`R/,u;m5!9Y-13\?G&n=;@Q+s_jM"lckg(FlqSo%:m9lLc%hI"Hn@.CHnFg]A
@V3=:1%9:L*V1$5d[0sX0?,gfaWaoW[%QLXCrk(eF*4.h,g0;r>&CQtG`,eqWH]Ajlbg8jo_o
RgRqT75J?_;pBuClZ^.A_[@iZO,i\laZs`mtkXhrES$b\J@/@psOX+JOB9$R?[!%KHHY2lAg
TAj'qL:e#KL`-r9aqF3lE5AJ0ohRduB%VFO_&m]AL^`GPLdjrmHKgEVbYXYoeDb?2NA\mGjTa
)\;nq.#sXd'SsI,*NaF0A47e:WUTCZLQ!mYqRq5'FRgV@:@(pmrG?847f7Wf>NCka/MCIMf+
ISR;/P<uF<[IPrbcd'P$esBgc.*c;a3nV9F0#!nDA5/Ob(]A=<4Op4r-CR`olA't]ADbO\mg.@
p%nAm9N`<a,P4(2mb&qm[jI;gkBQK)Z$sJLQohSC@>.t[MdFDb+K(7+[@?6Yd6FpiN4(K)(p
haQef`MJPj<&aJ-1KI,WVFB47g30%Ha_qcP1h5Q55jdDjkb8/^V;b$Lr8":@CW?-V;6!HST3
goH*5*%CAj.Ik7ML:L71idoAK9(=1Km>h;Z2gNndPlIr(^-QX.\[*SkJ6>k8rkOrV3>Zbi-=
Y-6Qj>7Q)1F$fnHF+S]A@6oH7YBOl\qZKog^A/S`lluL?*7dK:-g"[`0AIVTpa^-c=>dGhb@g
1L:dmI/:'U0[R%,J)jGqXnP<hs*i\=Xh1SXts<);7G0R(Gia'ZHt03+bP$K#I.K^'f<EFFMV
0T2A't7LT$=FRL;t*B'Q`%`EZQ1fUk_.[2J/r]A^~
]]></IM>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="1" cs="2" s="2">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="平均职级：" + round(A9,1)+"级"]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="1" cs="2" rs="6" s="1">
<O t="Image">
<IM>
<![CDATA[*EWJA)dO8V\.gAD;WL3&CPth7mS8iJ0+cpp?%T]A#>C[?f:qTn_>A0_?]A=\%#hjN;kg"gl@Hh
X(Pc^Bbl;j#&<-Gr;>6Gf"SPL;_OWtAtH-9C.4ATr*PKLD:W0.!dc3IdESiMd-pMNA#\bUm^
Vm8%H0@uFsD=>FOQ+@2lmd^'@Z0)Rtma]A.n&8";h:9U\A:AW9_o4UUj,28PcFcm42k-<+M:_
<9oao-6%nDVBnEdVk3ED*MLt_sECnO_`ikhs3"'.9C)qJhORV^FT,4+Yt&n,QPUo4Qs\?K!#
/XBk\GDW8OEVYFhW"mXU9O[AD`sH7_@Q*71RHSrnSdOg4P06si\qJHh<<:+HmMPSJ#5run(i
>(kLl\F2.8716PjaNdIXq-cfk6)i':D$X1ZoS9).@EDNsWsdr@_2U'gF\:,5SqM#8A`RR$&X
%a/>S/"1O>V)rBk)3+Dfkm4c;1GJjOb*$#2Ir#eEKqcE/fq]A.CbKmZmc/R>rue8UM*14e.YW
[$Y'4JGt1@proE"qZWH\)rJ\.m-BDk.?aFX\05&?EFNK7qM?p!U;pX%f^o3`b+:Ya8BgYU]AH
kNTXmrMMEm7[@<$*"!TC<<Eq+R]Am\;GbeC@M;G_#&!C\l'%`J#E@/IJ"sKK!Mr-)>'>XD#!O
>.k)4#EQkZ#"'fOX@9iXX:d+<to<tT$HOOm):WB)/='j_#W)&X0Tc<@g0QIWoKb%LQS6&0tl
s.r!V*.c(gM8+pQebc.QAJ-L4fpJN>HQ?+ffL/?TF@Ojb#<)X17FX;^*4<:_G$s'\:E"1o(7
PpS'%4p*K=Dd:$+LraS*Z*`:d9!N]A<bNX&9Z(DoZXecgP`>2.[UZ>]Ak$-d/fi$Y(qN5l(]A_$
[']A%pa$N<ei"ate6I02tj=Wac(9%JANV5La`NqjF)4HMZ+164H<4cd]A[dtSmBcb*-cr+9J+D
^VGg<+FHmK-0Z>-,*=Z8.LAbSUg0S<jSe^^.).>H_5aaY!L_TgL1\U2VqGC[(V[TbBZ_t]AoA
'I2@B$B%BF3J#tlaVdWE7Mi$.3p"s`FDeTTt+-A[RDE\!K1*Au@C(U#r',tu902eVk@&G(G6
iI*k?3cj;-78O$#)LKqUZj82CDW7:iXJ)!Z_8I(QCa.4W2I>oh[5M*Or#Bcl<_7SY<,cEReT
u2FjljJR(Q6+tND?O)i:d-SX2-4mFt[.R]AU2k%#"+Gs^iJ.i>5'"o(,[p!B'.*cb"-<)q/q/
,jHQNC6W$r>S`ZlO]AeFA`7>A9;#+#'^'mE_(=LD"+'9]AT5Ff:/=P]AdM^L.4hth4Y%^@@f_]A>
7h[:4ODC[rgV6s^>9n-Ei`+]Af-+G;?KF-S%*QJS6bN>s4n?9:Rb&\%6rfl!+o(4e8P3<L`:A
^[;&PVaQ%h1sC?f&h"PgOr.Y2`%m&)r]AY>t/C_'d>n)A[3>f\TD;GW#AH")I9/06Y#QPK>47
p#JMO7k9r^F=[lI<rn^_S.&8`X.4Z$=53_R[S_ACpYk\I5nV^f.HCl;c-0s"DUg)>NU3*1MN
5&(n!;+G]A.-&d7A-8"SB5.CH+8@tWm?[-Y-i1!o&9=gHn,3b;"?A\K+R+nPQ4MViP&/Vpntj
P)NoLjqEjO4U0$qRoP<#KafNRFIQ%?r\&;E';+CUNlqWeU\dhau3P&Mpl9Zu"ouG^h%?"^[8
*36hjKIC$^WEG;<5YQ)"?W"-,W#%(M?Z%?$%j;6_Y/k\HT^o]A2ePNR=O@6I\isn?S%NYB?6t
qm!G!#'71KD<S2$bIhf#5Nr:*\Ioe_3d<C:=KWR)<cH8P8N]A^.<op-+F@?I!]A_KnNeTRE#_U
bMkOK6WE.YX44QcAKW3OE[_0j]Aq#OL01-5ZDR0Xr/EIr"E;*r^-2l>a$cPbe.:eb)W+b4+6>
E=MGP9b!G+kj#Zer%$Z_7HEebGYHPG,;NOJ\DBFMZKIFfjJ^TBb7.iHh>^:,\TFIHQ0[X4Rh
ro>u('NjbCF"pC8(rG_sLA4"0=V*i.`rsNNt8%`\90\16k`rE42Ju8$nE!)&;d7@@qI9MJK)
Csj&SrdP\/d'0)C!J[h,'5ZOZ&c7+Yr,tGMIl=CG!IuS)kaY8._!;jE5b-qDFr?ja\-Xf<f[
bEX6A!C:*O;Y&SZG#qs(\D/>oH=K/t>,Bo`&Nk*:`[!8b$?LI.:,.I<b-Ts9#A/M9PhIAVo_
Ej;+/Sdf7m"-W]AKW0IXN0Gi=uks[2ZqX[1,"q$.MKWXGngOpjDhCpou:*mUDGo>(O?&8b*S@
S,d"Rb_B![WsrP**UXd3Q-;#b^OEWI=Rda-UGF<[TrP2CP-=5'"XVM@s7s_%`9?M,hY.m=9h
+lh:b%rH_#\.rkR(p6BN1Y]AWoLG?!IEgj]AROl5h)N)VVYYli_\`I#`kY8akJ4rI$8W*$TOq)
NX<$&U_-_KMXmWT,9e:.jh'O@+"O71?'AAZ3(tKc[?LXIN.#`6QT's_2fuq1`Vq@kT-YI/eq
&]A,U_Xa8tiYKr.p;lL@l!eLr(I:*<4fXloWn8Q(qhYct.X>,Q>[X0qNW\KKe!@W?qPL/T6W:
kMUcNdmXBc(g%eb?/J/*Tq`8mkX21;a;"9&8'aLpFF$bHo'[-#j/=m6g6F7@N*I-UL1V"LhI
e8\@2Wcf%9X1O(O=4nKOCc[T?$PaodO>9+7\)6jQC%IXnm[5AF@^-V=;obbK0#5dH"Ab^:01
aCBrQ2U]A6]Ac=AO_C;$5MKljen&KY*SQ>t-[/iN2q"*DY@`0-\POp@oh_2=*TA+&)Rn)VWCn2
7C^-VuHG:229O;>n<WVOKUEc?bX\I/S?Rd/:%1GK@GBk3pck@nLJ)(jo!["_di8'SZ'JP1M,
P4!fkf0S:p<kooC,qO451EO%:;5/b)Jl\mi^@hm8/f42[u+KXANa?1@I.QYt/lQtm6VReu]A>
5Ys36$d+PFHknGjlFCMQ@@WXU[/1fj<*?F`nWup!RZEfDldEZ?`/*S:<-T>DF*UUoi>6@6ZZ
UM7(*XF!/nK`WR2Qu9<Dj/C`Peg_"Sgdh^3L$p%1!A;,1.c1ol=?O+4+8l`:$mh6n#@MYE+V
,l1SqfgH7;m"t1uOg1<$b<-7dg7^e$.?`8E-0?#`&pdiL*nf#Tl7g_9kFJTYcMgs.=GWQ-[J
SB&mVg=kFWIE=1bIP/q9&_:48o:bagH#jCOKt$9Bp`jeY-,M!R1Q+HZeW$:j7K3<_nls#(<&
2lm8"0s:8*+\cP8CjXQ8!$Bm#a2nmuH8b5Y8^9X"D@K?L/TTW-,R6h,5d#FLT,.2EibD?#=0
@?KUMT7lE@c\?=F_TMiMBO,l,^J,)ea?bS*^9;,"Wkl)u0?*J>8$NS!O\V\=ls+2gGZn10Qj
lGW$D9Q]A,Qg^EE*J@=6S>g5euiAGe7,V+S\$iA<N4OCc`O[\Ji:AnU\]AFNQ.Tjo4mkhT!'tH
O_WrbMf+I3,<+hJ7$!,PoBl,d'\M.Xo(>:8"%ik`'Rf5N%+%iF8.mPegMS^kY]A=1%32=("L`
<PVl[Br_/ZN@?FEb()Wd%XI9&`Nk^p:Vqd1uq6jV&'/O5)ku-^G.]ACI*"2?q?P,AWZVZL\CH
\,$^i"'Z=dS,^5j>37G,Uiq3NLqkXki?brD*Q<N*[cdnagoS.DRtm(kM3a&;oUE9J6%QR_Ya
#O?gNG2'uJ"l@;^R45BS+,^D>]A\qY(g\@ZjLkYd#+IT7<.4LN%%CVj:C%pWNCo1OrF<N-!mo
6-j8Y)L.i>eBqTli'!$mA=*AEONnH82G2MrnIY@t7c!m0Ef[0oL,-m06>#oAhCBgT=44aDY6
+:YD'kp=q.uqp[O[18qR^D0mbnQURei=_>=E8J+,LdL#\<lhP!?Df'5BV:%7VC\"[W9M(,B\
'lNk6OjFBOQ6cfX0i!fBA!<89t"U,8%"=c^$YE'>oWrp?_Gh:CJC&rYL@Ad!l^AI*>eZ%.AJ
eGE-/@ook8a^CtmT;id2!J*=^-QS2YC=@K<[SN\('?j;G>uDlo/?I/?,EPr':7Vn#\O-X/"b
KkZ#3:q:I:.DkdFTFs&r,:7qK8;I+ifgC'BqN)MhkRAb.dS+n2UfQUX^K;O=`GFi`&?]ASGYH
X&>@D!Zk8t21er?RV"94OKM*`Ypj%+\a/cU3U5(<32!%p>ItC`EMY027^5jDiof;;r>EhW5i
89&CY7%)*uV5pRc]A44<;s!WKAB*AVICcDntJ8&#.S8&U!F[fj7B4goR$H(MpheOg>,Au8!kL
9UJk:`/K-Zg5.q-B*1?I^q,qUcQG:ot&+Ld-kU>;\1K01I-JNm8?"ZVD@angrnYc;UhKHRn!
PQQY^sYH2l!VDWKBbR/'LHcuP6Yn?:TDl<#bnC8tcgbDm.T<2)t=Y\?p6]A4>6JgK\8D)pLWX
:QJI4iU*<U6ElVNqn&9Pl951a%Eb?ck5,)Oh3gL,f/t;7eo^O'.D@WQ!aamW)6SU]A,dc=BYl
tmU5o7!q@:Sj""4m3t+ZnnH%(]Aa%MIunW3>X>DPOrs3*kd>]A.:kNXkICtTa?_@@Cs5RZIiYN
A)g%8??b)qmbGR]A&OFSBgIXIA?lcXgt]A;$@fA(q0XclHEY=)kU\>,5'_*Xqj^2U]ASTVp8'+A
,E*W5PD>TYP1QaZO$N,k5ja$^OVEcP$H9.$)Mu2p\A4Uq!.cZ\"iW1ml18Lr'YmZB8Opb82\
f\j=]A66RC\C>'r9/_I]A$D[m+TTH'eV0>(;9P7jPQ%SHO\-*he.Vgq*"DLJA$BOMHXh\25R^G
)PI;G*q]A[H)^K,;c`?0jqd8u1@kP$1=@&:&5gf&mXQPm>-YlA(GNs@LC.DW*T*)15SZ]ADfrN
?IbTXq/U-:0bHl-t?4*<*Z6i_JWX5@-sZQlMBMan`7B55LM=SpLcT"jph@@7#J8+?"u-^i)7
Kp*0MNFDr)N:Zb6)f42Se)\sQd=tSh)nF5E-4MU0SMDfH_GMXH"P&otm*&M[TI_&Z"j7PQH(
'AYLFZM]Au4MEtm@G!u_0?^?E@DXd[@V@r**K@18ju;h8;gG4E5NB_?<'V'+eK)bZOm[gi<MI
R]A=HJb;CfM;"8$l2J>NK'@@a7/5N7O@&Ma)^/+4j3!A2oG@(/rIAi7jOFF9HAP&*$]As.X237
^deuZXF]AcV8IZVFhpc6,p-MkV:6U0M9A4VtmW]A$haO`eYG4m?`EdX=B\N:2t#5OoKd%R@sZI
]AN4EM:[C#d=p12LKX_bQ:8q%rqTVIY]AN0ou9qrmqFN7BPVQ\/Boe"FDoF<mB\O+M&a[YV:8b
._C1-cQN2`?").c4:CK\`'%2M=/3ct/HBsi\^uK_OXu`&]AIri0`oS1rIToe/,-:r]A+c%aBZ(
=V'm\=l5GSBo7H-[\"ZH=$o]ANl1R`T,!WL+LVc:LVKt-.C237qs$-HhM0UL@9gEu2]AX@NG*K
6:29TiM'9KVXYUk?Idd1mMn.4oC)2a>%"8:TsL:>Qc+e1DA*R%Z@-em039a+Wt!kHh4`ggc0
_N8e:=^_U(Ct#HWO[&u5&#a?+-kQtCl6FUup7Vlb[Y)+/0WDAijk]A*#E0)9Q2tJJb9A#5bE>
ldYmEJt(1+Nd@Y>keh-F_@6WMkQ^k2mAGb-I<VN4pQ"3lH0jnp@L3V+etB7O8&&-2-$UX"4I
WQ$5ab?JO=@1N]AeYM?Th*9mOWV)qD\slou5^)I#*l./&=mA$_q&B#og^I)t0:gjO*1dp]AK')
]A,q7&!W22GH3tABm2V^9US&!`_di^aY5RBSUGm$e;q^j`7O&ETk3NMO5;M6LR&6<oA4$l)IH
O8<BVN!cbod9X4[=C.ob5enU^oa(0SUbHf'?+4N`'/2,,rgOR4[bQK=$ijfKhePNILO@l>10
\@GYr)+2"O-#OLN6G'V34C]A$("613.@TodbZc<6@Y+Rj-EQH&k]ARZO!KX]Ab.=:?M%__J($f+
U*&/-D`,b3KtrUt*t,FbM3*/_T^T]Aab!^b03IMe9#iN7Bh+e&mj15PS*LA=(<AA/3=E.34.2
%kPS!(^IjV1nc*;4R6;uH^Ctq9rbpDpmX<U1&]A'Wn[iC0kFD"WX=tSbc"-jI+3'1]A[!SY3Nc
En%3d90j<bJuWLrADh7Ss\L+7mAJ9#*ue8$tbH,-g:;4XYKr4T>A%<&[]A&02*XGb!7Nsf+$c
.s_!)!o'UE:8]ATLf.,QE;6EGZkk:>]A^`$"jgE:32bi'?dC=&IUG@H4uC*G,Q<TITeiN$f)?R
:LC+dq&FTD)PA3+mioblhN9SZ!V.Hnd09^-AsGDL1FcZGh$RJbV2+l1>+s#\%5sk]AR`?(h:j
'5QNr;'XMa]AV"(:Z)R4[.u_W2^b9T!G&(YtG>5'LrH(q/)l/Rn.*oreO9S;'0)+UWY#RWjE*
2OUIgjR[nVmUN[[W:8pZ#[?BhM7rJP4CGYR,[Hq39*i_K9r1'9$Pp@-PK)1_b#W(_0LUVDMg
Ll_;V2]A(*W_KnOg8S6D^7K=Sr7Wk`r)i!-rl*W+L6@=i1\9bcF!I1AptuOJGAVe6hI/:FWOl
$/B8i/cJb]A!Dr4J.q?g6Nea1d+dMjaD0)bC1kk\Wk)9f!=+'"o&n^'Zf!jO[up"RWS6jnb%[
KRP=j*]ANr)7*U+se;-uJpoE+!'b*EgX1bjH!I#1W^t@P]A\d:.0[UtD6E^]A0V)1K_&@@`K&]A'
bXk?MVQZ1&HEn3U^LbG*DbVg$YIHiLM,]AjU.1Td0aMdeg`R^`fe:n_,(=p/!NAUl#Q]AqJEep
X^V,\UQiDK6e2WrR%JNT?%#uSbJ"JesfT42GM<;:u$TFoh_'_YHn/CUt@c$XT[W;28AMk/R:
S)]Ah488O\=-HRF`W1.%n)HgM)]As*j?)$3d,W3/Y1Qh)&7?JIc0#D>QGjA9EQV72B%'n>26;^
PXK<\N\Oe=sD6AL#iK#j0ZIP[*PobhFN*Trk4a]AULp?$K5EoJ\!Hn$f?Mo5F1"G^4^4=L#hG
ESm9#N>C4#p0(s87M_qhE*+B;;17/45rICnB5XM(LK0lNVC#?Kbij>:+1P<J\CK^QjaB+b"u
#IPq&?&%6k<0lV)r]A*?jraZp'p^K1P9G.Ti]AZe5[>sKSR%p_[sU(W2=3i0CE-3VKcDKa/NaD
qFNQ;a5EHl@c3UEfKW`#c)/A[IB:l.A960X&X;X!L>FbqhYd#+CV\2jP7p!EJWd!G5/e0ud1
mS'3daST(ZLddcV9Ra<IP2tQAZ([W?E#eEe*a(`Z7>d-.*lIU_X:Z\Qc?scbo*MOX\Eo$#2G
]A)<?q!Y]Aq8;sV91hi]A1KYI^+^DG<,\Y)f6W;)c+m7WCUH#Y=rpG4"Y;R66PFmE!Hs@LA@?bW
jomc67;F^kQe.:%/M6I!h6>d"P^,lGNg5)4X)0Hi8&iY\]AR.7^1$S*)b)=s/08\nPNOHO?Jo
a:cLXtunH[nIT`7-L@nTOX!V%(?*B\OW=M2O>(7E%]A:.*ciZmiN-N+9rEl1LC^SCtouT^=X@
s\[_ObZ+K^I<gq"!d%BV4\1p>mf*@=n_0]AaZc,>Or'<;/KHOEdf%j1eTVO)`mP5TsuHF;WUf
jD3,NDU'RFbD#)@ngOB'g;CmY\?m4JY\,H+Z^qj$I@&/'^Arb1n#.W>B&Cd;GMBYpu2*mKUl
YXFQim[#[=BoH=Uu/pZ"]AHSd&R[@W6=[AW1(KL*Em>k[ui:=JB^//ae6:9K0c'fnj]A>>Y5Mi
cD;tO;%V-Z[EfPSa69R(2X^VdKNS%t5XCLG#jA<KLqS50n:]AfloTh7fLea`!8#q"q1&<[RkV
A:#4-4;YN.cgU4O9)UR+e2V)LnuFA(uG+?"\N!D3C;p+`p-KZF,R<2759.]A+*$\pKl6pc&/'
_:i%_i!<*P%Xs-@I>XP"GTo"$X>UKP.0=9Q%C6%t!)>^JL"\^$;08us/AhP)^*#*oD:7,)>#
c^/4^`LP$9Z[(hMo'6GlHV^jih_GbbPo)?:d4MOj'F"ml)$u)XL.:RT#)QARQbPR4?BBofga
H=@nSDJVp!K'W\#KF]AS*jPjTm=H\'J3EUWNb-$&OZSR_e`p&DS:en%m)dK;]AWcM0qDa$J;g5
TSR.o^COJpdVomZp:et9-Hmel_NWU+MVj]A^cq*>=`K#Q4c2YJ[J04XZXM2M@G##phW@ib[9#
8KX!q1a`:ghdhp"t+J`8;/i.aa(HP[NI8KMDXMZouP*-mpm,ZA\*0Lk4`cT@uA>J(T3tr3)]A
)_GTha]A8AZZr#Io(@NfoKeO!pDnr%?XlJXjQUHfY<p$NSl&:fFWMij7W.*cF[)293+p=5;I8
g9Yu$NpVI^23:?Fo$^dR2VUsO<-%)r1fU3PkKCopM=JC%.e,'cSu6Y[OAEW2bX&l`Y81S5a_
A$fBjWC/S.L94P%rt,lSp#6ph>.k1-\U^@dqYT.Pn_qe%s!dk19M.Yh>ClV'Bo7>0EhDU=7\
G&2r4ZTCu!=IkQaZqPE-jlhN>V)6.#8*-&0&G^2WGK+hC<%K`nh/k,#(>4-c3l'ieYkn[9Yu
)PN8!0_cA^Xr7EU;?MTb5*b9m%J8!'b;r2W1Li&#9B>CVYX+=P_#`]A4j<;U?XMc-rQ(>]A$mc
M$T^h9mW@U-:f'LM04)O\"T>'qE^puM!9_ildD$k,Nn,I]AWa6<*Xh<D<I"R;dZiB@N"P*F'E
ie@4[(Pq#E9&D2$pZR_Kgh=sco6G.peFg<p"*oWXW>qa<`k>k$D0ju7PHdurR%sck[MKFmjh
N_3=3-pM/T[`I\H1"MhOOE<4O%N0\o%$I[/+h@;p`ci%[j5:<AoThTaM"rOb!-V#D\mb2ZqG
Toe_e9L&RCotJYN"L$chlpdLP-t:f,_)WJQj%*Wa]AOL2=.%-!0=Il2"!'o=2pZ@\e]A\cSN;s
tduMB+bO<1aIp4_U1]A!^2o]ABpMs&Trq4LYjip:o+a7NDbg?>\uVO3Q^1_\JnRnWEbY_pd5XQ
qM\>u*k_@(4Ft<#qgY<+$U[_oe3[J-/VNqk&A.Ah%cg^jlki,<g_C:$G8E6di_SS2]A@-%FSg
r`p.miK/WfK@<+bei!i%7uKbN(9d-HM'D.rWEuj8rqXpn0fO#mdG+pgf#U'2*e4PFZ(aOT;V
hCV-H(jrjBcION1#ud3Mh!0qXFX&5I[2L\FLQ_5-]Ai,M1_(iT@MG8)]AM.=F-CqEk_0XlIYad
-llgfnF_$aq_0Zlm?7JN:s&qmRd#K;o#'_cITlTJYHOFb`Y"RN8)(DE7h4D4a%l5U@_"q*Pk
,hu29lA@mYj44CUGSU.!JnVe=HFR%$D5^J>WL<T>H)cT.*0C[''Roj-mgO+G#t5:W9M0B/4*
tW\eN*FmTq`?%%spIe]A:Wo<"\UQVD4OgAAGC-I!;Q/bCAH;lI=gC#kUHRFMAEOCJkB+ruRo'
su&ir5%1trT3^d!;+4e:JggD-":.u>\[t]ABH;DCCP7b(IXc,eqYFiJpqY0pkRb4Ap#cKV"3J
:O6"-8TZ(KjEm$!--Sgg16Oq6O.D$an;^B3C0J,5E,B,2>$^.g*g^`4]A;;;iOH#[X_'^!\&t
fH7ekEBS\.j_amRq.Ksr[]AIjRGS<GMA2DS@P+#h@W`?*<$r$<H?AGUAiWd(-%n9k^ME@VFA>
1\9cJ9WX=T#>I!VG64E8W>",GZnbj!f&q$@'aKF>dY-la%^0CosnpWfJL[)1;DF$d&ce:6h4
eE'FU0$YN(WYSFQm,>3NjTb++UNOqdDF=0^o.fYbjfj9Ye_HZr!5XR,KqBDU85<PZIH$/D.f
Sc-u>Ugkt'E[6l5tZmK56/C&(NlTl[HgRc.F]A%*[A'Ne>M*pg&Wu3t0E6p$ap802"+TKp?E/
(&T*?$Sl.E:n(@C>UWq[8#>*9RsaTE]An]AiUSETn(s+!fuS@bgEH``Q8L;Ck2L8oKZjM2XN:u
J[TV+MUHD?Df[X*QA:E?%=B7KWOQlqY*+L.QMWTKST_1oTb'EI&D&FW`X-UOI6\6uCL_3'SV
,Gn>SSrC\g;*KbE#(C8n#oJL[>X3pt[Z?XsahV=3uPK\/\1d*2LQ_&Rq"[OlH-Pllm0Ws(h#
sVTEiRW0UD<s!(DMdbC@;+5_N:Gs^0kPW#[4UT-FjL7N7FY$CjKD[P*=]A!YNtU-FKB^IDKC7
gGe'Y1TAF:4.c_rIV1llNZs.,\qo."mpJEK??M\CWrh)IY^D#FBNU1/7i;!>%\Y;b,VGC/X+
Ig=>Db1dH7rrSGTsZJ+n3$]A_en_j^Q'"C[uCr"e*D4:>p<*.ZR-(:heFIJ8"fEgo8VVc`,5h
cul8H;u7"LqF9`6?oX]A5\mA<6;[il(ca:+D0g)/U^gIGRFX45f"4bIZf0np!V94YI8p1ZQEX
`He3M_,6mNs6]Ait"FMG,lPaN]ACc0jlNb'8;JT;f*?O"9GVDiDI?@kE<YD$pK7t.O.tR;lTsP
0lEE5i#J7kJfPphf"odK<NbnIQMmnaq#P0(NVh+W\!LKjP<hE;Gs23.[J23l56]AA)+Ehe0*<
4l6!\<VfY2=C84L?O]AWac*7PIt<WuH?-8=&br`]AjuA4X+d_-sinVa9Ms5-HV$65dYANG?Tm4
e4ad?Q.k\c4s!@J16kDb[D*@V,!O@fE&``ur5WH_kGM.X@'bC+ccM650AX7bf?Bb,6uM3_^[
ao/c=i[,W>6rmSp=e/;ng$J<YIc0g2_"uuKi57ca:Y[Sso.oD8PU.83_uC4YI?$h;8PC$D7+
WAq$]AH>#9pK7/E;Fn]AqYIW/S?hn:!\4>*XQk;ZKP<\/pJAS*SAC7tcni=/b$j6;&"[:O2psN
RZ<Y>a+.."nM]A=D$jb>*H4V(Fn+c;T6il5a-(E1;+pWo"R"m<A$s5g<l_H(^F.\]A$Ff4ihJ`
h0iXCCCoD+\%uV_nGb0(OE!)$Vgg8i:0$?j(h<mJ`BO>PM%#\AcG??*8]A27da"IrGTGkd30n
A=8A6/jb\8:ZA,ip`hh,mu.1KeroN:(<5EUV)Ghr*Rs0SYM0tO02S-37tmuZ&J_?eGW9DYc.
$"sk8Ls#n[r-`^sjbAAX1e07PEf^p30V>X:gY2rGU#rhn9b78tKt@OABD6=De4OFGX3_N^Ht
'&hgC;'RPV^9_[lq^$b%bo1q\"+CNhnh-1Q,-/lK4aU`K22nGEGGkOTt_K8pb$Z&UI3#c8G5
:\8d.mA1L;3*:XX$bq,II5m+q57?RTH@9:=fbRZhjD:6?Mb>Ge>l`E2R&1n6tG7kn-O<1l#0
9bRkZCbuLh2H.s372E8OaKj/,&jCuHS+5V5]A6^t'Z72S7_\4"HH$eSV?Mn\<qDCaLV1!O<3:
gnnG`I~
]]></IM>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="1" cs="2" s="2">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="平均职级：" + round(A8,1)+"级"]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="2" cs="2" s="2">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="本科及以上占比：" + round(B10*100,1)+"%"]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="2" cs="2" s="2">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="本科及以上占比：" + round(B9*100,1)+"%"]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="2" cs="2" s="2">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="本科及以上占比：" + round(B8*100,1)+"%"]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="3" cs="2" s="2">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="平均司龄：" +  round(C10,1)+"年"]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="3" cs="2" s="2">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="平均司龄：" +  round(C9,1)+"年"]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="3" cs="2" s="2">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="平均司龄：" +  round(C8,1)+"年"]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="4" cs="2" s="2">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="平均工龄：" +  round(D10,1)+"年"]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="4" cs="2" s="2">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="平均工龄：" +  round(D9,1)+"年"]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="4" cs="2" s="2">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="平均工龄：" +  round(D8,1)+"年"]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="5" cs="2" s="2">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="平均年龄：" +  round(E10,1)+"岁"]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="5" cs="2" s="2">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="平均年龄：" +  round(E9,1)+"岁"]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="5" cs="2" s="2">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="平均年龄：" +  round(E8,1)+"岁"]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="6" cs="2" s="2">
<O t="Formula" class="Formula">
<Attributes reserveInWeb="false">
<![CDATA[="男："+F10*100+"%"+", "+"女："+G10*100+"%"]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="6" cs="2" s="2">
<O t="Formula" class="Formula">
<Attributes reserveInWeb="false">
<![CDATA[="男："+F9*100+"%"+", "+"女："+G9*100+"%"]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="6" cs="2" s="2">
<O t="Formula" class="Formula">
<Attributes reserveInWeb="false">
<![CDATA[="男："+F8*100+"%"+", "+"女："+G8*100+"%"]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="7">
<O t="DSColumn">
<Attributes dsName="主动离职平均职级（主营）" columnName="ZHIJI"/>
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
<C c="1" r="7">
<O t="DSColumn">
<Attributes dsName="主动离本科及以上占比" columnName="ZHANBI"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="2" r="7">
<O t="DSColumn">
<Attributes dsName="主动离职平均司龄（主营）" columnName="SILING"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="3" r="7">
<O t="DSColumn">
<Attributes dsName="主动离职平均工龄（主营）" columnName="GONGLING"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="4" r="7">
<O t="DSColumn">
<Attributes dsName="主动离职平均年龄（主营）" columnName="YEARSOLD"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="5" r="7">
<O t="DSColumn">
<Attributes dsName="主动离职性别占比（主营）" columnName="NAN"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="6" r="7">
<O t="DSColumn">
<Attributes dsName="主动离职性别占比（主营）" columnName="NV"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="0" r="8">
<O t="DSColumn">
<Attributes dsName="被动离职平均职级（主营）" columnName="ZHIJI"/>
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
<C c="1" r="8">
<O t="DSColumn">
<Attributes dsName="被动离本科及以上占比（主营）" columnName="ZHANBI"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="2" r="8">
<O t="DSColumn">
<Attributes dsName="被动离职平均司龄（主营）" columnName="SILING"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="3" r="8">
<O t="DSColumn">
<Attributes dsName="被动离职平均工龄（主营）" columnName="GONGLING"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="4" r="8">
<O t="DSColumn">
<Attributes dsName="被动离职平均年龄（主营）" columnName="YEARSOLD"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="5" r="8">
<O t="DSColumn">
<Attributes dsName="被动离职性别占比（主营）" columnName="NAN"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="6" r="8">
<O t="DSColumn">
<Attributes dsName="被动离职性别占比（主营）" columnName="NV"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="0" r="9">
<O t="DSColumn">
<Attributes dsName="在职平均职级（主营）" columnName="ZHIJI"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="1" r="9">
<O t="DSColumn">
<Attributes dsName="在职本科及以上占比（主营）" columnName="ZHANBI"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="2" r="9">
<O t="DSColumn">
<Attributes dsName="在职平均司龄（主营）" columnName="SILING"/>
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
<C c="3" r="9">
<O t="DSColumn">
<Attributes dsName="在职平均工龄（主营）" columnName="GONGLING"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="4" r="9">
<O t="DSColumn">
<Attributes dsName="在职平均年龄（主营）" columnName="YEARSOLD"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="5" r="9">
<O t="DSColumn">
<Attributes dsName="在职性别占比（主营）" columnName="NAN"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="6" r="9">
<O t="DSColumn">
<Attributes dsName="在职性别占比（主营）" columnName="NV"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="0" r="10">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=A9]]></Attributes>
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
<FRFont name="微软雅黑" style="0" size="88"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="4">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="2" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<isShared isshared="false"/>
<ReportFitAttr fitStateInPC="2" fitFont="false"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="0" zoom="true" refresh="false" isUseHTML="false"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="943" height="215"/>
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
<FRFont name="宋体" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Background name="ColorBackground" color="-1"/>
<Alpha alpha="1.0"/>
</Border>
<Background name="ColorBackground" color="-1"/>
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
<![CDATA[720000,720000,720000,720000,720000,720000,720000,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" cs="2" rs="7" s="0">
<O t="Image">
<IM>
<![CDATA[!?Mm4m>4Y77h#eD$31&+%7s)Y;?-[s2ZNgX^'FoC!!&-lQW=(d&`lSP5u`*_h;&B:eCVA=E0
Ad^g9g>DC7D)GID4=bQ]AouYbr[:IO0:#]AC=4#q`b/`pJO,TXFc.sm'1G/@)H7Jl_^2IqYe.1
oZ3\T2_`ksN76lT`J-ZFtn,;Z=1N[5rjo<*i%Z\gphrB4mpZ()us$)I5*TtIUMs%k5j5i=KZ
^5I#mo!;oTD+LP9Xin7GOTjt*gY$;e;O,<PDfgdbeh#+B<)Ooh"*^9/ouH-\m7Ti[m*3<7>!
C^*_[jAD9R&Z"7u&)=leo9VDJGhM:50:B)WH4DY.$n%T037:_Id%A79pGo!RT@idh!+<=4Zd
VsU)t,6lo`iTuB)?E#VNS2R'ADl*ee"(>Il0Ld&(@B0G-Q7_nep9A@9(^D&&-7eaFf3f@2-e
n]A6,$,UVaM5RRprEYY,]A^'4F7[GX,HNSZ30IFWk-L]A<Wh[JOE)F:ERKj??BA>kuBHBl'7LJ(
(cR0rg,FQb>"aD\7'+;FbIg^XjG8^NIoc=Fp)R`5le+pI^@5/ppTt`]A*"tF)U-0HQ?gU,\g\
C7Oh%kYZti;o@e"6$KhVG1E#$n1,Pi8jUXiN#sb7WIMLQ#ik@qN(UcI^1u<j5UXmFO`]A$>M\
JYgA13)_^S^bgD4k74W@EgIEGt]APd(dEB>I_a8I:-+.tMXm4Tr@"mt\r;LFf;OE>S!=FKmQ*
-gO;@D@Epa\HaB$g'56J.#TcBAC4g_+N*j/49Ra4/MID,))VnJf("L!OS-ej.I2X4'J#3>i.
R.Gg`IAPZ7JAuNUoG80NMH![4o>D!S1MiiS`*`FT.-T83Zq/Dhbb^gi25dCT(Z(E4_HdA;G<
cL._d_0Nr.p",e"$DuN&d]A6VcehjrKfBo%u#j1O2'F`BjtTgJu0K1^6A%t)'&.0QaAJ8Hf"+
_&Ir\=IeB1@AT=5)@q$9PASjmn<qh^Y+73gK[;*]A2fGg-"o/+SAAmlOR\<,84EG_!Hmej:2%
7Z7edtfM`8re_p5[H:n)Pt&ro5u>ZQ>oLG8)hjrFGIKJ.05Qj6i]A]AKc%2f8kApLg//V40FM-
/3G9oZ8M@j[,jdp"VBaidV)4^n'XNrc>R:Wr.dI:`WR.<<`A%q2CoBl]A#%+mb6>!:1g8gTGp
G4W*l[5A1m^DXPdhBqPBNDm:XI(k^HL8.$8u"8If*SboHPpb_ltdpo`hU(5-1t'Qc$THqoMU
J%<+0c!q,1jB>Ogsc%J=]AAh9JJ-6/%o[DqE<UHr<1`TA8W/XR#L&[c,QP,o%dU&<>i(:$^l/
F5jpO21QS7l[q1"S/lT+l%Q-2,8/B7tA;G?U'>*RsD5]AW=+sMk7#,Nqq\5jDTg)qqu@->Kf;
ie"tH>kHV5QU1\VGpEd(:Gpj?1Pf?!(]A3,O7+GZ*RBNdN23F@/6)piTq)c%>*$>G42+JDbqn
GJ(QG"EYI>3jLND+ntWS@>2C:@+,\2AbIr/NX_`&p#%I]A_o^qo@,uToOe'B-s,Z,9IMgj5n:
Q;/K7aFL7F<Y2f0@-@lR=q&K2qHdFihXYGBmGLJ?2BRB-'n'YO-n>Y<3qB]A;P/Rf[j(lDS]A1
l5I@>+,;iOm3M8d#_Z=>A:N7.iEUBWXrfLH7#rS5s@$'=CDX8UX@-X_!TH`q,),r9lL-'6$l
,RM4]AC6LsaP6sT3?_'U"Efg?L2"R'RN>NErZ!glhnb2;)D'ql/Zpnu.!4O'_nAHfTs++LL9f
`P0_(P#geOEFOS,t?;JTIkrT(*5V"V.ESe(Q'+Tpg\;,$otRrr)S60:@dRDBtH&`[U."%kXe
'RsB<V4V,rHUL0B2%bJQ.1(48C0+H@Bc[k=lcD-l4kXI"iqd[*5f]A;K;K.,j)X_V0\R/_f>:
g?`necV5E(WC\:*I3Y^>+@fGs2MF'>h]A):0IOIs5UD`Bir_G9>J9)B]Ar'F&<P_9B:q3X4ERL
fKnft]Ai'CU%F@>JMmR5I,>0N?G\YET+4F/.PqSb;=^7m$L"pscbHmj)B$ABNhp?.3hKsbAZp
3m\YcGRMC=a@BeK6dEPgdQkubTF(9V,kHE@t+)=n,:*iO2>)U-DhPIipL;?_>M)\DK*KbrY7
hU,GLA7f7qt=q,a'!4`R,Mra-5Ino8s9*Q*`h&D(8#:=bhUptQ2IK&+oH^n(Df55A?+OFIrc
$9S*Jd$5=K?+B:d9]A(C/kQ#%HJBr<'T!ek^;[(h^&g5j>k\bZfe".3AnEGOiSU6(Wi\_Z\kU
Se$S_"Ak`K>7R#.crT38EHgBjo_W,Jq`bYDqPq;mpg2a:'&"o<@PGb.li79^=CNOUMpG'$`\
FVP$($!8=Y(8a`J[6:kTh<g;UhBU_C9.9g+P;;MaX;5jfL<Hk.=.a9A:F8dnY7n#ok;_A<._
*pep3_%NdVQI\k:0$.f6l9TI$ttI_/j'?;nhL6C9sgX'n<1FB#bV.dM1MsslCVB]AW?"p<S$R
67k((%QY+cSk.'M-QkpB91Cat_-R$1Y'ADPiW>Z8)DQD7>>kLR$._B`EjBt\r.[WO:5[M@4a
^l/<%\B^htE(-ob#pZuYg'@s/)8t$4@PPTaH'mJe@rbPND^&dL6BX'?#Q[lG_5+)7bQ9S":!
d43/E#q4S\`$?B,6f/:haA#U;k,[5/mHI/-li+@1HeL1n2B""kMHdMphan8eN7QnZ>qr$mre
GbZJamJhXCoe<8Md;$Bi`L<7HP>67jD*An3\BT=Xc_Yh@_CT=!A7Ui@sQ02G*hTm2bmqTL,=
?I[m2LTa2?ph>W0a>h&Ck1BHV#mfHK-OVL;"AF_-GpQgEiheQQATB<Ynd+%49]A!Y\k18S_]A@
nrKBC5mAec:WL(5o@]AM="Aid00;^t#0/:'DI/2Fm)mEeWaD/Ki0UX_2hAiU6&<-iEI96s69F
=qrFW5D8-5SsSR$_>UTtT`2eGe/Oo#5;>V%i<4;B8hd=*FJHq&LCTqfE6iYfgiIXll^(PO"r
_Jd77s!iXroL^ftf*j`p;UEa,W>F\@V8DHFWOZ_9WVZp@1Lr37ZW0cOR,Bi,1\_rT5u`%^%*
gM]AT%[1QQ/RGAm@>4ks?3s*Jp.mCrVI_gR;ig)M`K<XlH/"gh7l5\"pX4tjm7C6PmP+\ODmB
[/O22`Jou#r#X)8_T/=]An0M.>f,T)]AOj`Y6.#Z>q+[e>8V>$GX.YVg5\et(leu$IF,(df'e?
=ZS=P$<c;W5DHC'[6Y1\.c,j1I"$YH]AYN&IuNMo-S4j!+HNZAtZcOAsfP+%L)5EFmoZ>_\%T
3([:R'3rV^JCoGlMn<tGg5@/0STEpBb5()Y27J=V\uMojJnYm(H:KfNUosLX0O1S>T0KJ^<A
b3:=Ij;/>[C"<YbkQ1P%"l*jY0qN[DJrRn,(rniOE/jOpQ>ij$?\.cAj-E?<5>FK0l"\5W$A
GCkfO2HtAl!EQ1<LTK!pI/n2n9=b7q>fj&.?Hp>cA.U4;1*jsN%E3C`sJ6G!m[2.';Gpf"L0
'O?YfGU9+=>SOHkpBGPFCCLn6ElTjC!T'317h>_l'HSX<lCd_>G*5j'pK<NTIFt%[(=S:L,H
,1*p=-d:S*/?q/*/6m4qZ+INFSMh=[W,jK#5`@VB%]A\@*ZnQ<>n`!_,Yn36f$tdf;13Q`b/H
VSS?4-_i3VZT4m`2*!V>ic;5u)BH[$pbG/hBY`#;I844;WDpWsU25*_[WuS%--OB0hu'HT\l
i9(A?=u$=a/I/CUr";iIB)G(FTqHRX^c*IJ4p0gQE/;>hu,@:l=\W.b1NMV2Jr*--)'$mFS_
i)6q^o]A5<r4pcK;_MYX<R26A[&:V@suR)P?Z$fSKJr=;JdNjDaNM6+3k-P)]Ac.<3kuKGu0+]A
"%TZp/A.;Zab>=[CgIRUuKBKT6c1qR)LqapYl5>Q[D:jDGBF6k#8H(lcnGW0)L/(Y+=uE0%N
rS^D1@#hoXa;J\+X1_qOFNL#&\@d"<4ROe`cBYi;\HC9FF69oCf4HC;X4,o@l0R'u/BBlW^6
S"al4=4:8k)76n/l3iWOl(W,#;6d44bI"d,lD<+obG&r%-]AYOm,&)&=]ATum$E#b0Oa(TItoL
lA4U2\8G>?Ps>[()=4Q<pG-*0t!eBlX#q/\Oj:3%Vo0?@@deSj6UT02jh?9<csRGKasc[Ic5
.j0/[XUr966d,J5QD&.h@>j]AamF/!N;11!HZ-KdD/UB\qI>24L/>b4OsGJh-MMn?[=)j89Zp
2%7<[*<UqbEdog%p'#5)o^W9]A4BQ:EQUtJXgnb>Hb0.?-FeL%TH:7J]A+6/'fCM%4p_+Ap>GZ
e6kA?&u>Lm$=G/XEVD3hrtGs=o!\Q/&Vq)R9S>cM"7GRAE^YP%^3UJJj`0/llKb82*Vf1=!g
+$#TpWha7C,+"`%:+ir/=m.D81;-6#A''l=T'l$^,?*sr_1'fXSl)iRg2%U-c&-;D@9aiecJ
?aIcA$=?=_k1_L2dg,2-4J/\@kSG-#RVr2N6D5L6K_WC`)mqCX"0Z0TPPP*k9=&;)XB&_qHZ
ffJ(UB[H<M%0TPOe0=eX)m^6KYY?@@V/fVgDaGTTPLhkoSlXTq-$o/WcNP'4j;l1PnLhgG=@
@pcCZ/ug@`)Z?+\`Gq]A\,^Hd!r\-(mQ(lK'+Z'8^i*V37WZLRB#_Bm\1HQh,DuTnrNK+XS8b
BNeD*_=3;bsh)I,0Jg`@L=atul'72jqf:,m_E\-Y9:Y0P>mUVZbG_L9:rci&]AGUi^f&=L_bT
BFR_V$0THiF*;SMQ,?-QoVMq*--llVS%[sSSR:N0bLFB,4!u$F3sRB]AEZ3,0)E=aLH_.;H3T
0nXN5KT)*!b9^#2`A$!V^M;I]A41p#_OZf*-#U1i"A'.I`)K3GVK?um=-)5p+sR3\c"QM`8,'
.0L$c[bQ,,4&_G5?f>oXD.ZO)\q2DfjDE'1T4Td=Q#jtDV>Ro)KUV7T)-Bj-$_>T<)GDTtW'
iPVi/hSYJ9JPoC\<G]Ae//LZmUmtip=2KIqjbZX*`SoPC=!hl@$ogJ#312=c'%^i0jg0jG[u)
,bp0n=$<J;=GEX&$i:Y[t125QdHX;Tee#2Cc$\0I5Rb!7bmh_X1;o#0pn`-I`d]Atf.;cZ;A)
7<p<R^D=7V9p@VdDm+^LYa)N?NNn#/4m(f!`XOa@6ZC.Zn\-Q[d\)-`f^X>sc)mkA[<rQGIg
TEo<ufK(&FK"u"WYcA?TD1-/q+U8N0M%#E"3SlCu3EW+mng1"l)'EgdU)E;Y%d<(MDni7,Va
=q2Y'd9p[h;%NV1"!3.=(Jp95t$+.b9,&g*dEI?ZjdUht.2^D-#)%pln-/qsE`C[`[U3h8?!
k2J[DD>5Ji^Jc3OZ67AQ[ns0,48aN3/JG=%$/^di;P8>pK+N-Pq,o5OQH8m!cG)-h!aWT59q
;B5:>tn;PsZQbM7)H08ACA+Sg^"&s)iX>6EJPH[IFI(Fp,1S[WYRHSGZ$JNX^Wh'-i_XG-P;
jnRU4:@']ABWO6\F,3QK#'Y&?UiiZDfLOH-ij>??]A"`CtD>eF'U+tn[m;Vk@qp6b:f/st6s)Z
0HEP:+('B<(ompSU__cC=5]A3,aNr=@i09GIJYjr2d.?&<Y##S!`T1#oH8*WSMn2P@)9']Ag$@
KZO"dZbapTc2%#k+8=X+g0O>U>Do@Dg2$n&tJHhsq/Gi";-uec,ES;+:?8Vi^lStuJ#:qQlp
DbM?496GD\!S6Vr;j7k-SAta@D<etB)*&CmWB"!''$*K'PaeG6Ttkfs*Z*/!*7/HMnt@\eF2
7_4iRDY3K=ShF/M_]AG^oS>7\R@2NgA-7qsj.C@iqgC<&Xa="Q>t_(i[7.m)Gi0<1&$$dEup?
Crb%7dP9Wm"r*h:XT&NeCZt:1gJmkH!!!!j78?7R6=>B~
]]></IM>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="0" cs="2" rs="7" s="0">
<O t="Image">
<IM>
<![CDATA[!?Mm4m>4Y77h#eD$31&+%7s)Y;?-[s2ZNgX^'FoC!!&-lQW=(d&`lSP5u`*_h;&B:eCVA=E0
Ad^g9g>DC7D)GID4=bQ]AouYbr[:IO0:#]AC=4#q`b/`pJO,TXFc.sm'1G/@)H7Jl_^2IqYe.1
oZ3\T2_`ksN76lT`J-ZFtn,;Z=1N[5rjo<*i%Z\gphrB4mpZ()us$)I5*TtIUMs%k5j5i=KZ
^5I#mo!;oTD+LP9Xin7GOTjt*gY$;e;O,<PDfgdbeh#+B<)Ooh"*^9/ouH-\m7Ti[m*3<7>!
C^*_[jAD9R&Z"7u&)=leo9VDJGhM:50:B)WH4DY.$n%T037:_Id%A79pGo!RT@idh!+<=4Zd
VsU)t,6lo`iTuB)?E#VNS2R'ADl*ee"(>Il0Ld&(@B0G-Q7_nep9A@9(^D&&-7eaFf3f@2-e
n]A6,$,UVaM5RRprEYY,]A^'4F7[GX,HNSZ30IFWk-L]A<Wh[JOE)F:ERKj??BA>kuBHBl'7LJ(
(cR0rg,FQb>"aD\7'+;FbIg^XjG8^NIoc=Fp)R`5le+pI^@5/ppTt`]A*"tF)U-0HQ?gU,\g\
C7Oh%kYZti;o@e"6$KhVG1E#$n1,Pi8jUXiN#sb7WIMLQ#ik@qN(UcI^1u<j5UXmFO`]A$>M\
JYgA13)_^S^bgD4k74W@EgIEGt]APd(dEB>I_a8I:-+.tMXm4Tr@"mt\r;LFf;OE>S!=FKmQ*
-gO;@D@Epa\HaB$g'56J.#TcBAC4g_+N*j/49Ra4/MID,))VnJf("L!OS-ej.I2X4'J#3>i.
R.Gg`IAPZ7JAuNUoG80NMH![4o>D!S1MiiS`*`FT.-T83Zq/Dhbb^gi25dCT(Z(E4_HdA;G<
cL._d_0Nr.p",e"$DuN&d]A6VcehjrKfBo%u#j1O2'F`BjtTgJu0K1^6A%t)'&.0QaAJ8Hf"+
_&Ir\=IeB1@AT=5)@q$9PASjmn<qh^Y+73gK[;*]A2fGg-"o/+SAAmlOR\<,84EG_!Hmej:2%
7Z7edtfM`8re_p5[H:n)Pt&ro5u>ZQ>oLG8)hjrFGIKJ.05Qj6i]A]AKc%2f8kApLg//V40FM-
/3G9oZ8M@j[,jdp"VBaidV)4^n'XNrc>R:Wr.dI:`WR.<<`A%q2CoBl]A#%+mb6>!:1g8gTGp
G4W*l[5A1m^DXPdhBqPBNDm:XI(k^HL8.$8u"8If*SboHPpb_ltdpo`hU(5-1t'Qc$THqoMU
J%<+0c!q,1jB>Ogsc%J=]AAh9JJ-6/%o[DqE<UHr<1`TA8W/XR#L&[c,QP,o%dU&<>i(:$^l/
F5jpO21QS7l[q1"S/lT+l%Q-2,8/B7tA;G?U'>*RsD5]AW=+sMk7#,Nqq\5jDTg)qqu@->Kf;
ie"tH>kHV5QU1\VGpEd(:Gpj?1Pf?!(]A3,O7+GZ*RBNdN23F@/6)piTq)c%>*$>G42+JDbqn
GJ(QG"EYI>3jLND+ntWS@>2C:@+,\2AbIr/NX_`&p#%I]A_o^qo@,uToOe'B-s,Z,9IMgj5n:
Q;/K7aFL7F<Y2f0@-@lR=q&K2qHdFihXYGBmGLJ?2BRB-'n'YO-n>Y<3qB]A;P/Rf[j(lDS]A1
l5I@>+,;iOm3M8d#_Z=>A:N7.iEUBWXrfLH7#rS5s@$'=CDX8UX@-X_!TH`q,),r9lL-'6$l
,RM4]AC6LsaP6sT3?_'U"Efg?L2"R'RN>NErZ!glhnb2;)D'ql/Zpnu.!4O'_nAHfTs++LL9f
`P0_(P#geOEFOS,t?;JTIkrT(*5V"V.ESe(Q'+Tpg\;,$otRrr)S60:@dRDBtH&`[U."%kXe
'RsB<V4V,rHUL0B2%bJQ.1(48C0+H@Bc[k=lcD-l4kXI"iqd[*5f]A;K;K.,j)X_V0\R/_f>:
g?`necV5E(WC\:*I3Y^>+@fGs2MF'>h]A):0IOIs5UD`Bir_G9>J9)B]Ar'F&<P_9B:q3X4ERL
fKnft]Ai'CU%F@>JMmR5I,>0N?G\YET+4F/.PqSb;=^7m$L"pscbHmj)B$ABNhp?.3hKsbAZp
3m\YcGRMC=a@BeK6dEPgdQkubTF(9V,kHE@t+)=n,:*iO2>)U-DhPIipL;?_>M)\DK*KbrY7
hU,GLA7f7qt=q,a'!4`R,Mra-5Ino8s9*Q*`h&D(8#:=bhUptQ2IK&+oH^n(Df55A?+OFIrc
$9S*Jd$5=K?+B:d9]A(C/kQ#%HJBr<'T!ek^;[(h^&g5j>k\bZfe".3AnEGOiSU6(Wi\_Z\kU
Se$S_"Ak`K>7R#.crT38EHgBjo_W,Jq`bYDqPq;mpg2a:'&"o<@PGb.li79^=CNOUMpG'$`\
FVP$($!8=Y(8a`J[6:kTh<g;UhBU_C9.9g+P;;MaX;5jfL<Hk.=.a9A:F8dnY7n#ok;_A<._
*pep3_%NdVQI\k:0$.f6l9TI$ttI_/j'?;nhL6C9sgX'n<1FB#bV.dM1MsslCVB]AW?"p<S$R
67k((%QY+cSk.'M-QkpB91Cat_-R$1Y'ADPiW>Z8)DQD7>>kLR$._B`EjBt\r.[WO:5[M@4a
^l/<%\B^htE(-ob#pZuYg'@s/)8t$4@PPTaH'mJe@rbPND^&dL6BX'?#Q[lG_5+)7bQ9S":!
d43/E#q4S\`$?B,6f/:haA#U;k,[5/mHI/-li+@1HeL1n2B""kMHdMphan8eN7QnZ>qr$mre
GbZJamJhXCoe<8Md;$Bi`L<7HP>67jD*An3\BT=Xc_Yh@_CT=!A7Ui@sQ02G*hTm2bmqTL,=
?I[m2LTa2?ph>W0a>h&Ck1BHV#mfHK-OVL;"AF_-GpQgEiheQQATB<Ynd+%49]A!Y\k18S_]A@
nrKBC5mAec:WL(5o@]AM="Aid00;^t#0/:'DI/2Fm)mEeWaD/Ki0UX_2hAiU6&<-iEI96s69F
=qrFW5D8-5SsSR$_>UTtT`2eGe/Oo#5;>V%i<4;B8hd=*FJHq&LCTqfE6iYfgiIXll^(PO"r
_Jd77s!iXroL^ftf*j`p;UEa,W>F\@V8DHFWOZ_9WVZp@1Lr37ZW0cOR,Bi,1\_rT5u`%^%*
gM]AT%[1QQ/RGAm@>4ks?3s*Jp.mCrVI_gR;ig)M`K<XlH/"gh7l5\"pX4tjm7C6PmP+\ODmB
[/O22`Jou#r#X)8_T/=]An0M.>f,T)]AOj`Y6.#Z>q+[e>8V>$GX.YVg5\et(leu$IF,(df'e?
=ZS=P$<c;W5DHC'[6Y1\.c,j1I"$YH]AYN&IuNMo-S4j!+HNZAtZcOAsfP+%L)5EFmoZ>_\%T
3([:R'3rV^JCoGlMn<tGg5@/0STEpBb5()Y27J=V\uMojJnYm(H:KfNUosLX0O1S>T0KJ^<A
b3:=Ij;/>[C"<YbkQ1P%"l*jY0qN[DJrRn,(rniOE/jOpQ>ij$?\.cAj-E?<5>FK0l"\5W$A
GCkfO2HtAl!EQ1<LTK!pI/n2n9=b7q>fj&.?Hp>cA.U4;1*jsN%E3C`sJ6G!m[2.';Gpf"L0
'O?YfGU9+=>SOHkpBGPFCCLn6ElTjC!T'317h>_l'HSX<lCd_>G*5j'pK<NTIFt%[(=S:L,H
,1*p=-d:S*/?q/*/6m4qZ+INFSMh=[W,jK#5`@VB%]A\@*ZnQ<>n`!_,Yn36f$tdf;13Q`b/H
VSS?4-_i3VZT4m`2*!V>ic;5u)BH[$pbG/hBY`#;I844;WDpWsU25*_[WuS%--OB0hu'HT\l
i9(A?=u$=a/I/CUr";iIB)G(FTqHRX^c*IJ4p0gQE/;>hu,@:l=\W.b1NMV2Jr*--)'$mFS_
i)6q^o]A5<r4pcK;_MYX<R26A[&:V@suR)P?Z$fSKJr=;JdNjDaNM6+3k-P)]Ac.<3kuKGu0+]A
"%TZp/A.;Zab>=[CgIRUuKBKT6c1qR)LqapYl5>Q[D:jDGBF6k#8H(lcnGW0)L/(Y+=uE0%N
rS^D1@#hoXa;J\+X1_qOFNL#&\@d"<4ROe`cBYi;\HC9FF69oCf4HC;X4,o@l0R'u/BBlW^6
S"al4=4:8k)76n/l3iWOl(W,#;6d44bI"d,lD<+obG&r%-]AYOm,&)&=]ATum$E#b0Oa(TItoL
lA4U2\8G>?Ps>[()=4Q<pG-*0t!eBlX#q/\Oj:3%Vo0?@@deSj6UT02jh?9<csRGKasc[Ic5
.j0/[XUr966d,J5QD&.h@>j]AamF/!N;11!HZ-KdD/UB\qI>24L/>b4OsGJh-MMn?[=)j89Zp
2%7<[*<UqbEdog%p'#5)o^W9]A4BQ:EQUtJXgnb>Hb0.?-FeL%TH:7J]A+6/'fCM%4p_+Ap>GZ
e6kA?&u>Lm$=G/XEVD3hrtGs=o!\Q/&Vq)R9S>cM"7GRAE^YP%^3UJJj`0/llKb82*Vf1=!g
+$#TpWha7C,+"`%:+ir/=m.D81;-6#A''l=T'l$^,?*sr_1'fXSl)iRg2%U-c&-;D@9aiecJ
?aIcA$=?=_k1_L2dg,2-4J/\@kSG-#RVr2N6D5L6K_WC`)mqCX"0Z0TPPP*k9=&;)XB&_qHZ
ffJ(UB[H<M%0TPOe0=eX)m^6KYY?@@V/fVgDaGTTPLhkoSlXTq-$o/WcNP'4j;l1PnLhgG=@
@pcCZ/ug@`)Z?+\`Gq]A\,^Hd!r\-(mQ(lK'+Z'8^i*V37WZLRB#_Bm\1HQh,DuTnrNK+XS8b
BNeD*_=3;bsh)I,0Jg`@L=atul'72jqf:,m_E\-Y9:Y0P>mUVZbG_L9:rci&]AGUi^f&=L_bT
BFR_V$0THiF*;SMQ,?-QoVMq*--llVS%[sSSR:N0bLFB,4!u$F3sRB]AEZ3,0)E=aLH_.;H3T
0nXN5KT)*!b9^#2`A$!V^M;I]A41p#_OZf*-#U1i"A'.I`)K3GVK?um=-)5p+sR3\c"QM`8,'
.0L$c[bQ,,4&_G5?f>oXD.ZO)\q2DfjDE'1T4Td=Q#jtDV>Ro)KUV7T)-Bj-$_>T<)GDTtW'
iPVi/hSYJ9JPoC\<G]Ae//LZmUmtip=2KIqjbZX*`SoPC=!hl@$ogJ#312=c'%^i0jg0jG[u)
,bp0n=$<J;=GEX&$i:Y[t125QdHX;Tee#2Cc$\0I5Rb!7bmh_X1;o#0pn`-I`d]Atf.;cZ;A)
7<p<R^D=7V9p@VdDm+^LYa)N?NNn#/4m(f!`XOa@6ZC.Zn\-Q[d\)-`f^X>sc)mkA[<rQGIg
TEo<ufK(&FK"u"WYcA?TD1-/q+U8N0M%#E"3SlCu3EW+mng1"l)'EgdU)E;Y%d<(MDni7,Va
=q2Y'd9p[h;%NV1"!3.=(Jp95t$+.b9,&g*dEI?ZjdUht.2^D-#)%pln-/qsE`C[`[U3h8?!
k2J[DD>5Ji^Jc3OZ67AQ[ns0,48aN3/JG=%$/^di;P8>pK+N-Pq,o5OQH8m!cG)-h!aWT59q
;B5:>tn;PsZQbM7)H08ACA+Sg^"&s)iX>6EJPH[IFI(Fp,1S[WYRHSGZ$JNX^Wh'-i_XG-P;
jnRU4:@']ABWO6\F,3QK#'Y&?UiiZDfLOH-ij>??]A"`CtD>eF'U+tn[m;Vk@qp6b:f/st6s)Z
0HEP:+('B<(ompSU__cC=5]A3,aNr=@i09GIJYjr2d.?&<Y##S!`T1#oH8*WSMn2P@)9']Ag$@
KZO"dZbapTc2%#k+8=X+g0O>U>Do@Dg2$n&tJHhsq/Gi";-uec,ES;+:?8Vi^lStuJ#:qQlp
DbM?496GD\!S6Vr;j7k-SAta@D<etB)*&CmWB"!''$*K'PaeG6Ttkfs*Z*/!*7/HMnt@\eF2
7_4iRDY3K=ShF/M_]AG^oS>7\R@2NgA-7qsj.C@iqgC<&Xa="Q>t_(i[7.m)Gi0<1&$$dEup?
Crb%7dP9Wm"r*h:XT&NeCZt:1gJmkH!!!!j78?7R6=>B~
]]></IM>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="1">
<O>
<![CDATA[平均年龄]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="1">
<O>
<![CDATA[平均年龄]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="3">
<O>
<![CDATA[平均司龄]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="3">
<O>
<![CDATA[平均司龄]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="5">
<O>
<![CDATA[平均职级]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="5">
<O>
<![CDATA[平均职级]]></O>
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
<Style imageLayout="4">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<isShared isshared="false"/>
<ReportFitAttr fitStateInPC="2" fitFont="false"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="0" zoom="true" refresh="false" isUseHTML="false"/>
</body>
</InnerWidget>
<BoundsAttr x="0" y="947" width="943" height="215"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="chart1"/>
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
<WidgetName name="chart1"/>
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
<Background name="ColorBackground" color="-1"/>
<Alpha alpha="1.0"/>
</Border>
<Background name="ColorBackground" color="-1"/>
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
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(len(seadate)==0 || seadate == year(now()),"本年度",seadate+"年度")+"整体离职分布"]]></Attributes>
</O>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="104"/>
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
<Attr isNullValueBreak="true" autoRefreshPerSecond="6" seriesDragEnable="false" plotStyle="0" combinedSize="50.0"/>
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
<Attr lineStyle="1" isRoundBorder="false" roundRadius="3"/>
<newColor borderColor="-1"/>
</AttrBorder>
</Attr>
<Attr class="com.fr.chart.base.AttrAlpha">
<AttrAlpha>
<Attr alpha="1.0"/>
</AttrAlpha>
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
<![CDATA[#0.0级]]></Format>
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
<HtmlLabel customText="function(){ return this.seriesName+this.value;}" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
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
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0.0级]]></Format>
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
<HtmlLabel customText="function(){ return this.category+this.seriesName+this.value;}" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
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
<ConditionAttrList>
<List index="0">
<ConditionAttr name="条件属性1">
<AttrList>
<Attr class="com.fr.plugin.chart.base.AttrLabel">
<AttrLabel>
<labelAttr enable="true"/>
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
<Compare op="0">
<O>
<![CDATA[0]]></O>
</Compare>
</Condition>
</ConditionAttr>
</List>
<List index="1">
<ConditionAttr name="条件属性2">
<AttrList>
<Attr class="com.fr.chart.base.AttrBackground">
<AttrBackground>
<Background name="ColorBackground" color="-8585216"/>
<Attr shadow="false"/>
</AttrBackground>
</Attr>
</AttrList>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[分类名]]></CNAME>
<Compare op="0">
<O>
<![CDATA[总体]]></O>
</Compare>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[分类名]]></CNAME>
<Compare op="0">
<O>
<![CDATA[主营]]></O>
</Compare>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[分类名]]></CNAME>
<Compare op="0">
<O>
<![CDATA[非主营]]></O>
</Compare>
</Condition>
</JoinCondition>
</Condition>
</ConditionAttr>
</List>
<List index="2">
<ConditionAttr name="条件属性3">
<AttrList>
<Attr class="com.fr.chart.base.AttrBackground">
<AttrBackground>
<Background name="ColorBackground" color="-6710887"/>
<Attr shadow="false"/>
</AttrBackground>
</Attr>
</AttrList>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[分类名]]></CNAME>
<Compare op="0">
<O>
<![CDATA[总体-辞退]]></O>
</Compare>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[分类名]]></CNAME>
<Compare op="0">
<O>
<![CDATA[主营-辞退]]></O>
</Compare>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[分类名]]></CNAME>
<Compare op="0">
<O>
<![CDATA[非主营-辞退]]></O>
</Compare>
</Condition>
</JoinCondition>
</Condition>
</ConditionAttr>
</List>
<List index="3">
<ConditionAttr name="条件属性4">
<AttrList>
<Attr class="com.fr.chart.base.AttrBackground">
<AttrBackground>
<Background name="ColorBackground" color="-4259832"/>
<Attr shadow="false"/>
</AttrBackground>
</Attr>
</AttrList>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[分类名]]></CNAME>
<Compare op="0">
<O>
<![CDATA[总体-辞职]]></O>
</Compare>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[分类名]]></CNAME>
<Compare op="0">
<O>
<![CDATA[主营-辞职]]></O>
</Compare>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[分类名]]></CNAME>
<Compare op="0">
<O>
<![CDATA[非主营-辞职]]></O>
</Compare>
</Condition>
</JoinCondition>
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
<NameJavaScript name="当前表单对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="FENLEI"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=CATEGORY]]></Attributes>
</O>
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
<NameJavaScript name="当前表单对象2">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="FENLEI"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=CATEGORY]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="chart3"/>
<linkType type="0"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="当前表单对象3">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="FENLEI"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=CATEGORY]]></Attributes>
</O>
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
<DataProcessor class="com.fr.base.chart.chartdata.model.NormalDataModel"/>
<newPlotFillStyle>
<AttrFillStyle>
<AFStyle colorStyle="1"/>
<FillStyleName fillStyleName=""/>
<isCustomFillStyle isCustomFillStyle="true"/>
<ColorList>
<OColor colvalue="-3342328"/>
<OColor colvalue="-4259832"/>
<OColor colvalue="-6710887"/>
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
<FRFont name="微软雅黑" style="0" size="72"/>
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
<FRFont name="微软雅黑" style="0" size="72"/>
</Attr>
</TextAttr>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0级]]></Format>
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
<VanChartColumnPlotAttr seriesOverlapPercent="20.0" categoryIntervalPercent="20.0" fixedWidth="true" columnWidth="32" filledWithImage="false" isBar="false"/>
</Plot>
<ChartDefinition>
<MoreNameCDDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[离职平均职级分布]]></Name>
</TableData>
<CategoryName value="LZLEIXING"/>
<ChartSummaryColumn name="ZHIJI" function="com.fr.data.util.function.NoneFunction" customName="平均职级"/>
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
<BoundsAttr x="0" y="0" width="943" height="203"/>
</Widget>
<body class="com.fr.form.ui.ChartEditor">
<WidgetName name="chart1"/>
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
<Background name="ColorBackground" color="-1"/>
<Alpha alpha="1.0"/>
</Border>
<Background name="ColorBackground" color="-1"/>
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
<Attr class="com.fr.chart.base.AttrBorder">
<AttrBorder>
<Attr lineStyle="1" isRoundBorder="false" roundRadius="3"/>
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
<![CDATA[#0人]]></Format>
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
<![CDATA[#0人数]]></Format>
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
<FillStyleName fillStyleName=""/>
<isCustomFillStyle isCustomFillStyle="true"/>
<ColorList>
<OColor colvalue="-7208960"/>
<OColor colvalue="-4259832"/>
<OColor colvalue="-6710887"/>
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
<FRFont name="Verdana" style="0" size="88" foreground="-10066330"/>
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
<FRFont name="微软雅黑" style="0" size="72"/>
</Attr>
</TextAttr>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0人]]></Format>
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
<VanChartColumnPlotAttr seriesOverlapPercent="20.0" categoryIntervalPercent="20.0" fixedWidth="true" columnWidth="32" filledWithImage="false" isBar="false"/>
</Plot>
<ChartDefinition>
<OneValueCDDefinition seriesName="LZLEIXING" valueName="RENSHU" function="com.fr.data.util.function.NoneFunction">
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[离职分布]]></Name>
</TableData>
<CategoryName value="FENLEI"/>
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
<BoundsAttr x="0" y="29" width="943" height="203"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="absolute0"/>
<Widget widgetName="chart1"/>
<Widget widgetName="chart2"/>
<Widget widgetName="chart0"/>
<Widget widgetName="chart0_c"/>
<Widget widgetName="report0_c"/>
</MobileWidgetList>
<WidgetZoomAttr compState="0"/>
<AppRelayout appRelayout="true"/>
<Size width="943" height="1162"/>
<ResolutionScalingAttr percent="0.9"/>
<tabFitAttr index="0" tabNameIndex="0"/>
</Widget>
<carouselAttr isCarousel="false" carouselInterval="1.8"/>
</Center>
</InnerWidget>
<BoundsAttr x="0" y="0" width="954" height="1200"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="tablayout0"/>
</MobileWidgetList>
<WidgetZoomAttr compState="1"/>
<AppRelayout appRelayout="true"/>
<Size width="954" height="1200"/>
<ResolutionScalingAttr percent="0.9"/>
<BodyLayoutType type="0"/>
</Center>
</Layout>
<DesignerVersion DesignerVersion="IAA"/>
<PreviewType PreviewType="0"/>
<TemplateID TemplateID="afbcc0c9-215a-4ec4-8749-78bdb617a547"/>
</Form>
