<?xml version="1.0" encoding="UTF-8"?>
<Form xmlVersion="20170715" releaseVersion="8.0.0">
<TableDataMap>
<TableData name="总体主营非主营本年度入职人员平均职级" class="com.fr.data.impl.DBTableData">
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
<![CDATA[SELECT '总体' AS FENLEI,
       ROUND(AVG(SUBSTR(ZHIJI,0,2)),1) AS AVGZHIJI
  FROM ODM_HR_YGTZ_NA YN
 WHERE 1=1
   ${if(len(seadate)==0 ,
"AND TO_CHAR(RZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(RZDATE,'YYYY') = '"+seadate+"'")}
   AND ZHIJI NOT LIKE '99%'
${if(len(DWMC)=0,""," and BUMENID in(
SELECT TREE_NODE
FROM ODM_HR_DW
  start with TREE_NODE ='"+DWMC+"' connect by  PARENT_NODE   =  prior TREE_NODE)")}

UNION ALL

SELECT '总体-在职' AS FENLEI,
       ROUND(AVG(SUBSTR(ZHIJI,0,2)),1) AS AVGZHIJI
  FROM ODM_HR_YGTZ_NA YN
 WHERE 1=1
   ${if(len(seadate)==0 ,
"AND TO_CHAR(RZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(RZDATE,'YYYY') = '"+seadate+"'")}
   AND HRSTATUS = 'A'
   AND ZHIJI NOT LIKE '99%'
${if(len(DWMC)=0,""," and BUMENID in(
SELECT TREE_NODE
FROM ODM_HR_DW
  start with TREE_NODE ='"+DWMC+"' connect by  PARENT_NODE   =  prior TREE_NODE)")}
UNION ALL

SELECT '总体-离职' AS FENLEI,
       ROUND(AVG(SUBSTR(ZHIJI,0,2)),1) AS AVGZHIJI
  FROM ODM_HR_YGTZ_NA YN
 WHERE 1=1
  ${if(len(seadate)==0 ,
"AND TO_CHAR(RZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(RZDATE,'YYYY') = '"+seadate+"'")}
   AND HRSTATUS <> 'A'
   AND ZHIJI NOT LIKE '99%'
${if(len(DWMC)=0,""," and BUMENID in(
SELECT TREE_NODE
FROM ODM_HR_DW
  start with TREE_NODE ='"+DWMC+"' connect by  PARENT_NODE   =  prior TREE_NODE)")}

UNION ALL

SELECT ' ',
       0
  FROM ODM_HR_YGTZ_NA YN
 GROUP BY ' ',' '

UNION ALL

SELECT '主营-总体' AS FENLEI,
       ROUND(AVG(SUBSTR(ZHIJI,0,2)),1) AS AVGZHIJI
  FROM ODM_HR_YGTZ_NA YN
 WHERE 1=1
   ${if(len(seadate)==0 ,
"AND TO_CHAR(RZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(RZDATE,'YYYY') = '"+seadate+"'")}
   AND ISZHUYING = '主营'
   AND ZHIJI NOT LIKE '99%'
${if(len(DWMC)=0,""," and BUMENID in(
SELECT TREE_NODE
FROM ODM_HR_DW
  start with TREE_NODE ='"+DWMC+"' connect by  PARENT_NODE   =  prior TREE_NODE)")}

UNION ALL

SELECT '主营-在职' AS FENLEI,
       ROUND(AVG(SUBSTR(ZHIJI,0,2)),1) AS AVGZHIJI
  FROM ODM_HR_YGTZ_NA YN
 WHERE 1=1
  ${if(len(seadate)==0 ,
"AND TO_CHAR(RZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(RZDATE,'YYYY') = '"+seadate+"'")}
   AND ISZHUYING = '主营'
   AND HRSTATUS = 'A'
   AND ZHIJI NOT LIKE '99%'
${if(len(DWMC)=0,""," and BUMENID in(
SELECT TREE_NODE
FROM ODM_HR_DW
  start with TREE_NODE ='"+DWMC+"' connect by  PARENT_NODE   =  prior TREE_NODE)")}


UNION ALL

SELECT '主营-离职' AS FENLEI,
       ROUND(AVG(SUBSTR(ZHIJI,0,2)),1) AS AVGZHIJI
  FROM ODM_HR_YGTZ_NA YN
 WHERE 1=1
  ${if(len(seadate)==0 ,
"AND TO_CHAR(RZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(RZDATE,'YYYY') = '"+seadate+"'")}
   AND ISZHUYING = '主营'
   AND HRSTATUS <> 'A'
   AND ZHIJI NOT LIKE '99%'
${if(len(DWMC)=0,""," and BUMENID in(
SELECT TREE_NODE
FROM ODM_HR_DW
  start with TREE_NODE ='"+DWMC+"' connect by  PARENT_NODE   =  prior TREE_NODE)")}

UNION ALL

SELECT '  ',
       0
  FROM ODM_HR_YGTZ_NA YN
 GROUP BY '  ',' '

UNION ALL

SELECT '非主营-总体' AS FENLEI,
       ROUND(AVG(SUBSTR(ZHIJI,0,2)),1) AS AVGZHIJI
  FROM ODM_HR_YGTZ_NA YN
 WHERE 1=1
  ${if(len(seadate)==0 ,
"AND TO_CHAR(RZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(RZDATE,'YYYY') = '"+seadate+"'")}
   AND ISZHUYING  <>'主营'
   AND ZHIJI NOT LIKE '99%'
${if(len(DWMC)=0,""," and BUMENID in(
SELECT TREE_NODE
FROM ODM_HR_DW
  start with TREE_NODE ='"+DWMC+"' connect by  PARENT_NODE   =  prior TREE_NODE)")}

UNION ALL

SELECT '非主营-在职' AS FENLEI,
       ROUND(AVG(SUBSTR(ZHIJI,0,2)),1) AS AVGZHIJI
  FROM ODM_HR_YGTZ_NA YN
 WHERE 1=1
   ${if(len(seadate)==0 ,
"AND TO_CHAR(RZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(RZDATE,'YYYY') = '"+seadate+"'")}
   AND ISZHUYING <>'主营'
   AND HRSTATUS = 'A'
   AND ZHIJI NOT LIKE '99%'
${if(len(DWMC)=0,""," and BUMENID in(
SELECT TREE_NODE
FROM ODM_HR_DW
  start with TREE_NODE ='"+DWMC+"' connect by  PARENT_NODE   =  prior TREE_NODE)")}

UNION ALL

SELECT '非主营-离职' AS FENLEI,
       ROUND(AVG(SUBSTR(ZHIJI,0,2)),1) AS AVGZHIJI
  FROM ODM_HR_YGTZ_NA YN
 WHERE 1=1
   ${if(len(seadate)==0 ,
"AND TO_CHAR(RZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(RZDATE,'YYYY') = '"+seadate+"'")}
   AND ISZHUYING <>'主营'
   AND HRSTATUS <> 'A'
   AND ZHIJI NOT LIKE '99%'
${if(len(DWMC)=0,""," and BUMENID in(
SELECT TREE_NODE
FROM ODM_HR_DW
  start with TREE_NODE ='"+DWMC+"' connect by  PARENT_NODE   =  prior TREE_NODE)")}]]></Query>
</TableData>
<TableData name="职级区间" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="fenlei"/>
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
<![CDATA[SELECT '1-2级' AS FENLEI,
       COUNT(YGID) AS RENSHU
  FROM ODM_HR_RZTZ NA
 WHERE 1=1
   AND SUBSTR(ZHIJI,0,2) >= 1
   AND SUBSTR(ZHIJI,0,2) <= 2
  ${if(len(seadate)==0 ,
"AND TO_CHAR(RZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(RZDATE,'YYYY') = '"+seadate+"'")}
   ${IF(fenlei == '总体' || LEN(fenlei) == 0,
   "",
   IF(fenlei == '总体-在职',
      "AND ISLIZHI = '在职'",
      IF(fenlei == '总体-离职',
         "AND ISLIZHI = '离职'",
         IF(fenlei == '主营-总体',
            "AND ISZHUYING = '主营'",
            IF(fenlei == '主营-在职',
               "AND ISZHUYING = '主营' AND ISLIZHI = '在职'",
               IF(fenlei == '主营-离职',
                  "AND ISZHUYING = '主营' AND ISLIZHI = '离职'",
                  IF(fenlei == '非主营-总体',
                     "AND ISZHUYING <>'主营'",
                     IF(fenlei == '非主营-在职',
                        "AND ISZHUYING <>'主营' AND ISLIZHI = '在职'",
                        "AND ISZHUYING <>'主营' AND ISLIZHI = '离职'"
                      )
                    )
                ) 
            )
          )
        )
    )
  )}
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}

UNION ALL

SELECT '3级' AS FENLEI,
       COUNT(YGID) AS RENSHU
  FROM ODM_HR_RZTZ NA
 WHERE 1=1
   AND SUBSTR(ZHIJI,0,2) = 3
  ${if(len(seadate)==0 ,
"AND TO_CHAR(RZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(RZDATE,'YYYY') = '"+seadate+"'")}
   ${IF(fenlei == '总体' || LEN(fenlei) == 0,
   "",
   IF(fenlei == '总体-在职',
      "AND ISLIZHI = '在职'",
      IF(fenlei == '总体-离职',
         "AND ISLIZHI = '离职'",
         IF(fenlei == '主营-总体',
            "AND ISZHUYING = '主营'",
            IF(fenlei == '主营-在职',
               "AND ISZHUYING = '主营' AND ISLIZHI = '在职'",
               IF(fenlei == '主营-离职',
                  "AND ISZHUYING = '主营' AND ISLIZHI = '离职'",
                  IF(fenlei == '非主营-总体',
                     "AND ISZHUYING <>'主营'",
                     IF(fenlei == '非主营-在职',
                        "AND ISZHUYING <>'主营' AND ISLIZHI = '在职'",
                        "AND ISZHUYING <>'主营' AND ISLIZHI = '离职'"
                      )
                    )
                ) 
            )
          )
        )
    )
  )}
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}

UNION ALL

SELECT '4-5级' AS FENLEI,
       COUNT(YGID) AS RENSHU
  FROM ODM_HR_RZTZ NA
 WHERE 1=1
   AND SUBSTR(ZHIJI,0,2) >= 4
   AND SUBSTR(ZHIJI,0,2) <= 5
 ${if(len(seadate)==0 ,
"AND TO_CHAR(RZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(RZDATE,'YYYY') = '"+seadate+"'")}
   ${IF(fenlei == '总体' || LEN(fenlei) == 0,
   "",
   IF(fenlei == '总体-在职',
      "AND ISLIZHI = '在职'",
      IF(fenlei == '总体-离职',
         "AND ISLIZHI = '离职'",
         IF(fenlei == '主营-总体',
            "AND ISZHUYING = '主营'",
            IF(fenlei == '主营-在职',
               "AND ISZHUYING = '主营' AND ISLIZHI = '在职'",
               IF(fenlei == '主营-离职',
                  "AND ISZHUYING = '主营' AND ISLIZHI = '离职'",
                  IF(fenlei == '非主营-总体',
                     "AND ISZHUYING <>'主营'",
                     IF(fenlei == '非主营-在职',
                        "AND ISZHUYING <>'主营' AND ISLIZHI = '在职'",
                        "AND ISZHUYING <>'主营' AND ISLIZHI = '离职'"
                      )
                    )
                ) 
            )
          )
        )
    )
  )}
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}

UNION ALL

SELECT '6-7级' AS FENLEI,
       COUNT(YGID) AS RENSHU
  FROM ODM_HR_RZTZ NA
 WHERE 1=1
   AND SUBSTR(ZHIJI,0,2) >= 6
   AND SUBSTR(ZHIJI,0,2) <= 7
  ${if(len(seadate)==0 ,
"AND TO_CHAR(RZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(RZDATE,'YYYY') = '"+seadate+"'")}
   ${IF(fenlei == '总体' || LEN(fenlei) == 0,
   "",
   IF(fenlei == '总体-在职',
      "AND ISLIZHI = '在职'",
      IF(fenlei == '总体-离职',
         "AND ISLIZHI = '离职'",
         IF(fenlei == '主营-总体',
            "AND ISZHUYING = '主营'",
            IF(fenlei == '主营-在职',
               "AND ISZHUYING = '主营' AND ISLIZHI = '在职'",
               IF(fenlei == '主营-离职',
                  "AND ISZHUYING = '主营' AND ISLIZHI = '离职'",
                  IF(fenlei == '非主营-总体',
                     "AND ISZHUYING <>'主营'",
                     IF(fenlei == '非主营-在职',
                        "AND ISZHUYING <>'主营' AND ISLIZHI = '在职'",
                        "AND ISZHUYING <>'主营' AND ISLIZHI = '离职'"
                      )
                    )
                ) 
            )
          )
        )
    )
  )}
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}

UNION ALL

SELECT '8-10级' AS FENLEI,
       COUNT(YGID) AS RENSHU
  FROM ODM_HR_RZTZ NA
 WHERE 1=1
   AND SUBSTR(ZHIJI,0,2) >= 8
   AND SUBSTR(ZHIJI,0,2) <= 10
  ${if(len(seadate)==0 ,
"AND TO_CHAR(RZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(RZDATE,'YYYY') = '"+seadate+"'")}
   ${IF(fenlei == '总体' || LEN(fenlei) == 0,
   "",
   IF(fenlei == '总体-在职',
      "AND ISLIZHI = '在职'",
      IF(fenlei == '总体-离职',
         "AND ISLIZHI = '离职'",
         IF(fenlei == '主营-总体',
            "AND ISZHUYING = '主营'",
            IF(fenlei == '主营-在职',
               "AND ISZHUYING = '主营' AND ISLIZHI = '在职'",
               IF(fenlei == '主营-离职',
                  "AND ISZHUYING = '主营' AND ISLIZHI = '离职'",
                  IF(fenlei == '非主营-总体',
                     "AND ISZHUYING <>'主营'",
                     IF(fenlei == '非主营-在职',
                        "AND ISZHUYING <>'主营' AND ISLIZHI = '在职'",
                        "AND ISZHUYING <>'主营' AND ISLIZHI = '离职'"
                      )
                    )
                ) 
            )
          )
        )
    )
  )}
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}

UNION ALL

SELECT '10级+' AS FENLEI,
       COUNT(YGID) AS RENSHU
  FROM ODM_HR_RZTZ NA
 WHERE 1=1 
   AND SUBSTR(ZHIJI,0,2) > 10
 ${if(len(seadate)==0 ,
"AND TO_CHAR(RZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(RZDATE,'YYYY') = '"+seadate+"'")}
   ${IF(fenlei == '总体' || LEN(fenlei) == 0,
   "",
   IF(fenlei == '总体-在职',
      "AND ISLIZHI = '在职'",
      IF(fenlei == '总体-离职',
         "AND ISLIZHI = '离职'",
         IF(fenlei == '主营-总体',
            "AND ISZHUYING = '主营'",
            IF(fenlei == '主营-在职',
               "AND ISZHUYING = '主营' AND ISLIZHI = '在职'",
               IF(fenlei == '主营-离职',
                  "AND ISZHUYING = '主营' AND ISLIZHI = '离职'",
                  IF(fenlei == '非主营-总体',
                     "AND ISZHUYING <>'主营'",
                     IF(fenlei == '非主营-在职',
                        "AND ISZHUYING <>'主营' AND ISLIZHI = '在职'",
                        "AND ISZHUYING <>'主营' AND ISLIZHI = '离职'"
                      )
                    )
                ) 
            )
          )
        )
    )
  )}
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}]]></Query>
</TableData>
<TableData name="各单位" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="fenlei"/>
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
      ROUND(AVG(SUBSTR(ZHIJI,0,2)),1) AS AVGZHIJI,
      DANWEI
FROM (  
SELECT  
      ZHIJI,
      DANWEI
FROM (select ZHIJI,
       descr AS DANWEI
  from (select t1.ZHIJI,t2.descr
          from ODM_HR_RZTZ t1, odm_hr_dw t2
         where t1.tree_node_id like '%' || t2.tree_node || '%' 
               and zhiji<>'99级' 
               ${if(len(DWMC)=0," AND   PARENT_NODE ='HX_HEAD' ","AND PARENT_NODE ='"+DWMC+"'" )}--参数 
           
${if(len(seadate)==0 ,
"AND TO_CHAR(t1.RZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(t1.RZDATE,'YYYY') = '"+seadate+"'")}
${IF(fenlei == '总体' || LEN(fenlei) == 0,
   "",
   IF(fenlei == '总体-在职',
      "AND t1.ISLIZHI = '在职'",
      IF(fenlei == '总体-离职',
         "AND t1.ISLIZHI <> '在职'",
         IF(fenlei == '主营-总体',
            "AND t1.ISZHUYING = '主营'",
            IF(fenlei == '主营-在职',
               "AND t1.ISZHUYING = '主营' AND t1.ISLIZHI = '在职'",
               IF(fenlei == '主营-离职',
                  "AND t1.ISZHUYING = '主营' AND t1.ISLIZHI <> '在职'",
                  IF(fenlei == '非主营-总体',
                     "AND t1.ISZHUYING <>'主营'",
                     IF(fenlei == '非主营-在职',
                        "AND t1.ISZHUYING <>'主营' AND t1.ISLIZHI = '在职'",
                        "AND t1.ISZHUYING <>'主营' AND t1.ISLIZHI <> '在职'"
                      )
                    )
                ) 
            )
          )
        )
    )
  )}

  union all

  select t1.ZHIJI,t2.descr
          from ODM_HR_RZTZ t1, odm_hr_dw t2
         where t1.tree_node_id like '%' || t2.tree_node || '%' 
                   ${if(len(DWMC)=0," AND   PARENT_NODE ='HX_HEAD' ","AND BUMENID ='"+DWMC+"'" )}--参数 
                   and bumenid = t2.tree_node
       and zhiji<>'99级'        
${if(len(seadate)==0 ,
"AND TO_CHAR(t1.RZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(t1.RZDATE,'YYYY') = '"+seadate+"'")}
${IF(fenlei == '总体' || LEN(fenlei) == 0,
   "",
   IF(fenlei == '总体-在职',
      "AND t1.ISLIZHI = '在职'",
      IF(fenlei == '总体-离职',
         "AND t1.ISLIZHI <> '在职'",
         IF(fenlei == '主营-总体',
            "AND t1.ISZHUYING = '主营'",
            IF(fenlei == '主营-在职',
               "AND t1.ISZHUYING = '主营' AND t1.ISLIZHI = '在职'",
               IF(fenlei == '主营-离职',
                  "AND t1.ISZHUYING = '主营' AND t1.ISLIZHI <> '在职'",
                  IF(fenlei == '非主营-总体',
                     "AND t1.ISZHUYING <>'主营'",
                     IF(fenlei == '非主营-在职',
                        "AND t1.ISZHUYING <>'主营' AND t1.ISLIZHI = '在职'",
                        "AND t1.ISZHUYING <>'主营' AND t1.ISLIZHI <> '在职'"
                      )
                    )
                ) 
            )
          )
        )
    )
  )}
  )
))
GROUP BY DANWEI
ORDER BY AVGZHIJI DESC
]]></Query>
</TableData>
<TableData name="职能序列" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="fenlei"/>
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
<![CDATA[SELECT ZHINENGXULIE AS FENLEI,
       COUNT(YGID) AS RENSHU
  FROM ODM_HR_RZTZ
 WHERE 1=1
  ${if(len(seadate)==0 ,
"AND TO_CHAR(RZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(RZDATE,'YYYY') = '"+seadate+"'")}
   ${IF(fenlei == '总体' || LEN(fenlei) == 0,
   "",
   IF(fenlei == '总体-在职',
      "AND ISLIZHI = '在职'",
      IF(fenlei == '总体-离职',
         "AND ISLIZHI = '离职'",
         IF(fenlei == '主营-总体',
            "AND ISZHUYING = '主营'",
            IF(fenlei == '主营-在职',
               "AND ISZHUYING = '主营' AND ISLIZHI = '在职'",
               IF(fenlei == '主营-离职',
                  "AND ISZHUYING = '主营' AND ISLIZHI = '离职'",
                  IF(fenlei == '非主营-总体',
                     "AND ISZHUYING <>'主营'",
                     IF(fenlei == '非主营-在职',
                        "AND ISZHUYING <>'主营' AND ISLIZHI = '在职'",
                        "AND ISZHUYING <>'主营' AND ISLIZHI = '离职'"
                      )
                    )
                ) 
            )
          )
        )
    )
  )}
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}
 GROUP BY ZHINENGXULIE
 ORDER BY ZHINENGXULIE]]></Query>
</TableData>
<TableData name="在职本科及以上占比（主营）" class="com.fr.data.impl.DBTableData">
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
FROM ODM_HR_YGTZ
WHERE 1=1
${if(len(seadate)==0 ,
"AND TO_CHAR(RZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(RZDATE,'YYYY') = '"+seadate+"'")}
AND ISZHUYING ='主营'
AND zhiji not like '99%' 
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}
  )a,
(SELECT 
count(YGID) AS RENSHU
FROM ODM_HR_YGTZ
WHERE 1=1
${if(len(seadate)==0 ,
"AND TO_CHAR(RZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(RZDATE,'YYYY') = '"+seadate+"'")}

AND ISZHUYING ='主营'
AND zhiji not like '99%' 
AND XUELIFENLEI <='3-本科'
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}
  )b

]]></Query>
</TableData>
<TableData name="在职平均工龄（主营）" class="com.fr.data.impl.DBTableData">
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
	CASE WHEN AVG(GONGLING) IS NULL THEN 0
ELSE AVG(GONGLING) END AS GONGLING
FROM(
SELECT 
round(MONTHS_BETWEEN(SYSDATE,CJGZDATE)/12,1) AS GONGLING
FROM ODM_HR_YGTZ
WHERE 1=1
${if(len(seadate)==0 ,
"AND TO_CHAR(RZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(RZDATE,'YYYY') = '"+seadate+"'")}

AND ISZHUYING='主营'
AND zhiji not like '99%' 
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}
  )

]]></Query>
</TableData>
<TableData name="在职平均年龄（主营）" class="com.fr.data.impl.DBTableData">
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
FROM(SELECT 
round(avg(MONTHS_BETWEEN(SYSDATE,CSDATE)/12),0) AS YEARSOLD
FROM ODM_HR_YGTZ
WHERE 1=1
${if(len(seadate)==0 ,
"AND TO_CHAR(RZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(RZDATE,'YYYY') = '"+seadate+"'")}

AND ISZHUYING='主营'
AND zhiji not like '99%' 
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")})

 

]]></Query>
</TableData>
<TableData name="主动离职平均职级（主营）" class="com.fr.data.impl.DBTableData">
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
FROM ODM_HR_LZTZ
WHERE 1=1
AND TO_CHAR(LZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')
AND ISZHUYING ='主营'
AND zhiji not like '99%' 
AND LZLEIXING='辞职'
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}]]></Query>
</TableData>
<TableData name="在职性别占比（主营）" class="com.fr.data.impl.DBTableData">
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
CASE WHEN  A.RENSHU=0 THEN 0 
  WHEN  A.RENSHU<>0 THEN  ROUND(A.RENSHU/(A.RENSHU+B.RENSHU),3) END  AS NAN,
  CASE WHEN  B.RENSHU=0 THEN 0 
  WHEN  B.RENSHU<>0 THEN  ROUND(B.RENSHU/(A.RENSHU+B.RENSHU),3) END  AS NV
FROM
(SELECT 
count(YGID) AS RENSHU
FROM ODM_HR_YGTZ
WHERE 1=1
${if(len(seadate)==0 ,
"AND TO_CHAR(RZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(RZDATE,'YYYY') = '"+seadate+"'")}
AND ISZHUYING='主营'
AND XINGBIE ='男'
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}
)a,
  (SELECT 
count(YGID) AS RENSHU
FROM ODM_HR_YGTZ
WHERE 1=1
${if(len(seadate)==0 ,
"AND TO_CHAR(RZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(RZDATE,'YYYY') = '"+seadate+"'")}

AND ISZHUYING='主营'
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}
AND XINGBIE ='女')b
]]></Query>
</TableData>
<TableData name="在职平均职级（主营）" class="com.fr.data.impl.DBTableData">
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
FROM ODM_HR_YGTZ
WHERE 1=1
${if(len(seadate)==0 ,
"AND TO_CHAR(RZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(RZDATE,'YYYY') = '"+seadate+"'")}

AND ISZHUYING ='主营'
AND zhiji not like '99%' 
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}
  ]]></Query>
</TableData>
<TableData name="入职本科及以上占比（主营）" class="com.fr.data.impl.DBTableData">
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
case when A.RENSHU=0 or A.RENSHU is null then 0 else B.RENSHU/A.RENSHU end   AS ZHANBI
FROM
(SELECT 
count(YGID) AS RENSHU
FROM ODM_HR_LZTZ
WHERE 1=1
${if(len(seadate)==0 ,
"AND TO_CHAR(RZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(RZDATE,'YYYY') = '"+seadate+"'")}
${if(len(seadate)==0 ,
"AND TO_CHAR(LZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(LZDATE,'YYYY') = '"+seadate+"'")}
AND ISZHUYING ='主营'
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")})a,
(SELECT 
count(YGID) AS RENSHU
FROM ODM_HR_LZTZ
WHERE 1=1
${if(len(seadate)==0 ,
"AND TO_CHAR(RZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(RZDATE,'YYYY') = '"+seadate+"'")}
${if(len(seadate)==0 ,
"AND TO_CHAR(LZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(LZDATE,'YYYY') = '"+seadate+"'")}
AND ISZHUYING='主营' 
AND XUELIFENLEI <='3-本科'
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}
  )b

]]></Query>
</TableData>
<TableData name="入职平均工龄（主营）" class="com.fr.data.impl.DBTableData">
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
	CASE WHEN AVG(GONGLING) IS NULL THEN 0
ELSE AVG(GONGLING) END AS GONGLING
FROM(
SELECT 
round(MONTHS_BETWEEN(SYSDATE,CJGZDATE)/12,1) AS GONGLING
FROM ODM_HR_LZTZ
WHERE 1=1
${if(len(seadate)==0 ,
"AND TO_CHAR(RZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(RZDATE,'YYYY') = '"+seadate+"'")}
${if(len(seadate)==0 ,
"AND TO_CHAR(LZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(LZDATE,'YYYY') = '"+seadate+"'")}
AND ISZHUYING ='主营'
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}
  
  )

]]></Query>
</TableData>
<TableData name="入职平均年龄（主营）" class="com.fr.data.impl.DBTableData">
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
	CASE WHEN round(avg(MONTHS_BETWEEN(SYSDATE,CSDATE)/12),0) IS NULL THEN 0
ELSE round(avg(MONTHS_BETWEEN(SYSDATE,CSDATE)/12),0) END AS YEARSOLD
FROM ODM_HR_LZTZ
WHERE 1=1
${if(len(seadate)==0 ,
"AND TO_CHAR(RZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(RZDATE,'YYYY') = '"+seadate+"'")}
${if(len(seadate)==0 ,
"AND TO_CHAR(LZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(LZDATE,'YYYY') = '"+seadate+"'")}
AND ISZHUYING ='主营'
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}

 

]]></Query>
</TableData>
<TableData name="入职平均职级（主营）" class="com.fr.data.impl.DBTableData">
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
"AND TO_CHAR(RZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(RZDATE,'YYYY') = '"+seadate+"'")}
${if(len(seadate)==0 ,
"AND TO_CHAR(LZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(LZDATE,'YYYY') = '"+seadate+"'")}
AND ISZHUYING ='主营'
AND zhiji not like '99%' 
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}
  ]]></Query>
</TableData>
<TableData name="入职性别占比（主营）" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="seadate"/>
<O>
<![CDATA[2017]]></O>
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
CASE WHEN  A.RENSHU=0 THEN 0 
  WHEN  A.RENSHU<>0 THEN  ROUND(A.RENSHU/(A.RENSHU+B.RENSHU),3) END  AS NAN,
  CASE WHEN  B.RENSHU=0 THEN 0 
  WHEN  B.RENSHU<>0 THEN  ROUND(B.RENSHU/(A.RENSHU+B.RENSHU),3) END  AS NV
FROM
(SELECT 
count(YGID)  AS RENSHU
FROM ODM_HR_LZTZ
WHERE 1=1
${if(len(seadate)==0 ,
"AND TO_CHAR(RZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(RZDATE,'YYYY') = '"+seadate+"'")}
${if(len(seadate)==0 ,
"AND TO_CHAR(LZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(LZDATE,'YYYY') = '"+seadate+"'")}
AND ISZHUYING ='主营'
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}
 AND XINGBIE ='男')a,
(SELECT 
count(YGID)  AS RENSHU,
XINGBIE
FROM ODM_HR_LZTZ
WHERE 1=1
${if(len(seadate)==0 ,
"AND TO_CHAR(RZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(RZDATE,'YYYY') = '"+seadate+"'")}
${if(len(seadate)==0 ,
"AND TO_CHAR(LZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(LZDATE,'YYYY') = '"+seadate+"'")}
AND ISZHUYING ='主营'
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}
AND XINGBIE='女')b


]]></Query>
</TableData>
<TableData name="在职本科及以上占比" class="com.fr.data.impl.DBTableData">
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
ELSE B.RENSHU/A.RENSHU END AS ZHANBI
FROM
(SELECT 
count(YGID) AS RENSHU
FROM ODM_HR_YGTZ
WHERE 1=1
AND ISZHUYING ='主营'
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}
  )a,
(SELECT 
count(YGID) AS RENSHU
FROM ODM_HR_YGTZ
WHERE 1=1
AND ISZHUYING='主营'
AND XUELIFENLEI <='3-本科'
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}
  )b

]]></Query>
</TableData>
<TableData name="在职平均工龄" class="com.fr.data.impl.DBTableData">
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
round(MONTHS_BETWEEN(SYSDATE,CJGZDATE)/12,1) AS GONGLING
FROM ODM_HR_YGTZ
WHERE 1=1
AND ISZHUYING='主营'
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}
  )

]]></Query>
</TableData>
<TableData name="在职平均年龄" class="com.fr.data.impl.DBTableData">
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
round(avg(MONTHS_BETWEEN(SYSDATE,CSDATE)/12),0) AS YEARSOLD
FROM ODM_HR_YGTZ
WHERE 1=1
AND ISZHUYING='主营'
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}



]]></Query>
</TableData>
<TableData name="在职平均职级" class="com.fr.data.impl.DBTableData">
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
AND ISZHUYING ='主营'
AND zhiji not like '99%' 
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}]]></Query>
</TableData>
<TableData name="在职性别占比" class="com.fr.data.impl.DBTableData">
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
CASE WHEN  A.RENSHU=0 THEN 0 
  WHEN  A.RENSHU<>0 THEN  ROUND(A.RENSHU/(A.RENSHU+B.RENSHU),3) END  AS NAN,
  CASE WHEN  B.RENSHU=0 THEN 0 
  WHEN  B.RENSHU<>0 THEN  ROUND(B.RENSHU/(A.RENSHU+B.RENSHU),3) END  AS NV
FROM
(SELECT 
count(YGID)  AS RENSHU
FROM ODM_HR_YGTZ
WHERE 1=1
AND ISZHUYING='主营'
AND XINGBIE ='男'
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")})a,
  (SELECT 
count(YGID)  AS RENSHU,
XINGBIE
FROM ODM_HR_YGTZ
WHERE 1=1
AND ISZHUYING ='主营'
AND XINGBIE ='女'
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")})b

]]></Query>
</TableData>
<TableData name="本年度入职人数" class="com.fr.data.impl.DBTableData">
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
<Attributes share="true" maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[HXXF_HR]]></DatabaseName>
</Connection>
<Query>
<![CDATA[SELECT 
count(YGID) AS RENSHU
FROM ODM_HR_RZTZ
WHERE 1=1
 ${if(len(seadate)==0 ,
"AND TO_CHAR(RZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(RZDATE,'YYYY') = '"+seadate+"'")}
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}]]></Query>
</TableData>
<TableData name="本年度入职且离职" class="com.fr.data.impl.DBTableData">
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
count(YGID) AS RENSHU
FROM ODM_HR_RZTZ
WHERE 1=1
${if(len(seadate)==0 ,
"AND TO_CHAR(RZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(RZDATE,'YYYY') = '"+seadate+"'")}
 AND ISLIZHI ='离职'
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}]]></Query>
</TableData>
<TableData name="本年度入职且在职" class="com.fr.data.impl.DBTableData">
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
count(YGID) AS RENSHU
FROM ODM_HR_RZTZ
WHERE 1=1
${if(len(seadate)==0 ,
"AND TO_CHAR(RZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(RZDATE,'YYYY') = '"+seadate+"'")}
 AND ISLIZHI ='在职'
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}
]]></Query>
</TableData>
<TableData name="本年度主营员工入职" class="com.fr.data.impl.DBTableData">
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
count(YGID) AS RENSHU
FROM ODM_HR_RZTZ
WHERE 1=1
${if(len(seadate)==0 ,
"AND TO_CHAR(RZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(RZDATE,'YYYY') = '"+seadate+"'")}
AND ISZHUYING='主营'
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}]]></Query>
</TableData>
<TableData name="本年度主营员工入职且已离职" class="com.fr.data.impl.DBTableData">
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
count(YGID) AS RENSHU
FROM ODM_HR_RZTZ
WHERE 1=1
${if(len(seadate)==0 ,
"AND TO_CHAR(RZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(RZDATE,'YYYY') = '"+seadate+"'")}
  AND ISLIZHI ='离职'
AND ISZHUYING='主营'
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}]]></Query>
</TableData>
<TableData name="本年度主营员工入职且在职" class="com.fr.data.impl.DBTableData">
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
count(YGID) AS RENSHU
FROM ODM_HR_RZTZ
WHERE 1=1
${if(len(seadate)==0 ,
"AND TO_CHAR(RZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(RZDATE,'YYYY') = '"+seadate+"'")}
AND ISZHUYING='主营'
AND ISLIZHI='在职'
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}]]></Query>
</TableData>
<TableData name="本年度非主营员工入职" class="com.fr.data.impl.DBTableData">
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
count(YGID) AS RENSHU
FROM ODM_HR_RZTZ
WHERE 1=1
${if(len(seadate)==0 ,
"AND TO_CHAR(RZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(RZDATE,'YYYY') = '"+seadate+"'")}
AND ISZHUYING!='主营'
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}]]></Query>
</TableData>
<TableData name="本年度非主营员工入职且已离职" class="com.fr.data.impl.DBTableData">
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
count(YGID) AS RENSHU
FROM ODM_HR_RZTZ
WHERE 1=1
${if(len(seadate)==0 ,
"AND TO_CHAR(RZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(RZDATE,'YYYY') = '"+seadate+"'")}
AND ISZHUYING!='主营'
AND ISLIZHI='离职'
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}]]></Query>
</TableData>
<TableData name="本年度非主营员工入职且在职" class="com.fr.data.impl.DBTableData">
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
count(YGID) AS RENSHU
FROM ODM_HR_RZTZ
WHERE 1=1
${if(len(seadate)==0 ,
"AND TO_CHAR(RZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(RZDATE,'YYYY') = '"+seadate+"'")}
AND ISZHUYING!='主营'  
AND ISLIZHI='在职'
${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}]]></Query>
</TableData>
<TableData name="部门名称" class="com.fr.data.impl.DBTableData">
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
<![CDATA[SELECT descr
FROM ODM_HR_DW
WHERE
 ${if(len(DWMC)=0,"TREE_NODE ='HX_HEAD'","TREE_NODE ='"+DWMC+"'")} ]]></Query>
</TableData>
<TableData name="2_1_1_主营员工上一家雇主分析_雇主类型" class="com.fr.data.impl.DBTableData">
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
A AS(
SELECT *
  FROM ODM_HR_YGJLCX_WBGZLL_VW VW
  WHERE ENDTIME = (
                  SELECT MAX(ENDTIME)
                    FROM ODM_HR_YGJLCX_WBGZLL_VW B
                   WHERE B.YGID = VW.YGID
)
)

SELECT
ratio_to_report(RENSHU) OVER() AS ZHANBI,
RENSHU,
GZLEIXING
FROM
(
SELECT *
  FROM(
SELECT A.GZLEIXING,
       COUNT(YGTZ.YGID) AS RENSHU
  FROM ODM_HR_YGTZ YGTZ
  LEFT JOIN A
    ON YGTZ.YGID = A.YGID
   WHERE YGTZ.ISZHUYING = '主营'
   AND TO_CHAR(RZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')
   AND A.GZLEIXING IS NOT NULL
   AND YGTZ.ISCQT <> '是'
   ${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}
   GROUP BY GZLEIXING
   ORDER BY RENSHU DESC
   )
   


UNION ALL

   SELECT '常青藤' AS GZLEIXING,
          COUNT(YGTZ.YGID) AS RENSHU
  FROM ODM_HR_YGTZ YGTZ
  LEFT JOIN A
    ON YGTZ.YGID = A.YGID
   WHERE YGTZ.ISZHUYING = '主营'
   AND TO_CHAR(RZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')
   AND ISCQT = '是'
   ${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}


UNION ALL

   SELECT CASE WHEN ${if(len(DWMC)==0,"1=1","'"+DWMC+"'='HX_HEAD'")}  
                 OR  TREE_NODE_ID LIKE '%100000,%'
            THEN '其他（主要为国际）' 
            ELSE '其他' 
        END AS GZLEIXING,
          COUNT(YGTZ.YGID) AS RENSHU
  FROM ODM_HR_YGTZ YGTZ
  LEFT JOIN A
    ON YGTZ.YGID = A.YGID
   WHERE YGTZ.ISZHUYING = '主营'
   AND TO_CHAR(RZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')
   AND A.GZLEIXING IS NULL
   AND ISCQT <> '是'
   ${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}
   GROUP BY CASE WHEN ${if(len(DWMC)==0,"1=1","'"+DWMC+"'='HX_HEAD'")}  
                 OR  TREE_NODE_ID LIKE '%100000,%'
            THEN '其他（主要为国际）' 
            ELSE '其他' 
        END
   )]]></Query>
</TableData>
<TableData name="2_2_1_主营员工上一家雇主分析_行业类别" class="com.fr.data.impl.DBTableData">
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
A AS(
SELECT *
  FROM ODM_HR_YGJLCX_WBGZLL_VW VW
  WHERE ENDTIME = (
                  SELECT MAX(ENDTIME)
                    FROM ODM_HR_YGJLCX_WBGZLL_VW B
                   WHERE B.YGID = VW.YGID
)
)

SELECT
ratio_to_report(RENSHU) OVER() AS ZHANBI,
RENSHU,
HYLEIBIE
FROM
(
SELECT *
  FROM(
SELECT A.HYLEIBIE,
       COUNT(YGTZ.YGID) AS RENSHU
  FROM ODM_HR_YGTZ YGTZ
  LEFT JOIN A
    ON YGTZ.YGID = A.YGID
   WHERE YGTZ.ISZHUYING = '主营'
   AND TO_CHAR(RZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')
   AND A.HYLEIBIE IS NOT NULL
   AND YGTZ.ISCQT <> '是'
   ${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}
   GROUP BY HYLEIBIE
   ORDER BY RENSHU DESC
   )
   


UNION ALL

   SELECT '常青藤' AS HYLEIBIE,
          COUNT(YGTZ.YGID) AS RENSHU
  FROM ODM_HR_YGTZ YGTZ
  LEFT JOIN A
    ON YGTZ.YGID = A.YGID
   WHERE YGTZ.ISZHUYING = '主营'
   AND TO_CHAR(RZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')
   AND ISCQT = '是'
   ${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}


UNION ALL

   SELECT CASE WHEN ${if(len(DWMC)==0,"1=1","'"+DWMC+"'='HX_HEAD'")}  
                 OR  TREE_NODE_ID LIKE '%100000,%'
            THEN '其他（主要为国际）' 
            ELSE '其他' 
        END AS HYLEIBIE,
          COUNT(YGTZ.YGID) AS RENSHU
  FROM ODM_HR_YGTZ YGTZ
  LEFT JOIN A
    ON YGTZ.YGID = A.YGID
   WHERE YGTZ.ISZHUYING = '主营'
   AND TO_CHAR(RZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')
   AND A.HYLEIBIE IS NULL
   AND ISCQT <> '是'
   ${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}
   GROUP BY CASE WHEN ${if(len(DWMC)==0,"1=1","'"+DWMC+"'='HX_HEAD'")}  
                 OR  TREE_NODE_ID LIKE '%100000,%'
            THEN '其他（主要为国际）' 
            ELSE '其他' 
        END
   )]]></Query>
</TableData>
<TableData name="2_3_1_主营员工上一家雇主分析_行政级别" class="com.fr.data.impl.DBTableData">
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
A AS(
SELECT *
  FROM ODM_HR_YGJLCX_WBGZLL_VW VW
  WHERE ENDTIME = (
                  SELECT MAX(ENDTIME)
                    FROM ODM_HR_YGJLCX_WBGZLL_VW B
                   WHERE B.YGID = VW.YGID
)
)

SELECT
ratio_to_report(RENSHU) OVER() AS ZHANBI,
RENSHU,
XZJIBIE
FROM
(
SELECT *
  FROM(
SELECT A.XZJIBIE,
       COUNT(YGTZ.YGID) AS RENSHU
  FROM ODM_HR_YGTZ YGTZ
  LEFT JOIN A
    ON YGTZ.YGID = A.YGID
   WHERE YGTZ.ISZHUYING = '主营'
   AND TO_CHAR(RZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')
   AND A.XZJIBIE IS NOT NULL 
   AND YGTZ.ISCQT<>'是'
   ${if(len(DWMC)=0,"and 1=1"," and TREE_NODE_ID LIKE '%"+DWMC+",%'")}
   GROUP BY XZJIBIE
   ORDER BY RENSHU DESC
   )
   )]]></Query>
</TableData>
<TableData name="ds1" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="fenlei"/>
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
      ROUND(AVG(SUBSTR(ZHIJI,0,2)),1) AS AVGZHIJI,
      DANWEI
FROM (  
SELECT  
      ZHIJI,
      DANWEI
FROM (select ZHIJI,
       descr AS DANWEI
  from (select t1.ZHIJI,t2.descr
          from ODM_HR_RZTZ t1, odm_hr_dw t2
         where t1.tree_node_id like '%' || t2.tree_node || '%' 
               and zhiji<>'99级' 
               ${if(len(DWMC)=0," AND   PARENT_NODE ='HX_HEAD' ","AND PARENT_NODE ='"+DWMC+"'" )}--参数 
           
${if(len(seadate)==0 ,
"AND TO_CHAR(t1.RZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(t1.RZDATE,'YYYY') = '"+seadate+"'")}
${IF(fenlei == '总体' || LEN(fenlei) == 0,
   "",
   IF(fenlei == '总体-在职',
      "AND t1.ISLIZHI = '在职'",
      IF(fenlei == '总体-离职',
         "AND t1.ISLIZHI <> '在职'",
         IF(fenlei == '主营-总体',
            "AND t1.ISZHUYING = '主营'",
            IF(fenlei == '主营-在职',
               "AND t1.ISZHUYING = '主营' AND t1.ISLIZHI = '在职'",
               IF(fenlei == '主营-离职',
                  "AND t1.ISZHUYING = '主营' AND t1.ISLIZHI <> '在职'",
                  IF(fenlei == '非主营-总体',
                     "AND t1.ISZHUYING <>'主营'",
                     IF(fenlei == '非主营-在职',
                        "AND t1.ISZHUYING <>'主营' AND t1.ISLIZHI = '在职'",
                        "AND t1.ISZHUYING <>'主营' AND t1.ISLIZHI <> '在职'"
                      )
                    )
                ) 
            )
          )
        )
    )
  )}

  union all

  select t1.ZHIJI,t2.descr
          from ODM_HR_RZTZ t1, odm_hr_dw t2
         where t1.tree_node_id like '%' || t2.tree_node || '%' 
                   ${if(len(DWMC)=0," AND   PARENT_NODE ='HX_HEAD' ","AND BUMENID ='"+DWMC+"'" )}--参数 
                   and bumenid = t2.tree_node
       and zhiji<>'99级'        
${if(len(seadate)==0 ,
"AND TO_CHAR(t1.RZDATE,'YYYY') = TO_CHAR(SYSDATE,'YYYY')",
"AND TO_CHAR(t1.RZDATE,'YYYY') = '"+seadate+"'")}
${IF(fenlei == '总体' || LEN(fenlei) == 0,
   "",
   IF(fenlei == '总体-在职',
      "AND t1.ISLIZHI = '在职'",
      IF(fenlei == '总体-离职',
         "AND t1.ISLIZHI <> '在职'",
         IF(fenlei == '主营-总体',
            "AND t1.ISZHUYING = '主营'",
            IF(fenlei == '主营-在职',
               "AND t1.ISZHUYING = '主营' AND t1.ISLIZHI = '在职'",
               IF(fenlei == '主营-离职',
                  "AND t1.ISZHUYING = '主营' AND t1.ISLIZHI <> '在职'",
                  IF(fenlei == '非主营-总体',
                     "AND t1.ISZHUYING <>'主营'",
                     IF(fenlei == '非主营-在职',
                        "AND t1.ISZHUYING <>'主营' AND t1.ISLIZHI = '在职'",
                        "AND t1.ISZHUYING <>'主营' AND t1.ISLIZHI <> '在职'"
                      )
                    )
                ) 
            )
          )
        )
    )
  )}
  )
))
GROUP BY DANWEI
ORDER BY AVGZHIJI DESC
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
<Background name="ColorBackground" color="-1"/>
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
<BoundsAttr x="378" y="0" width="80" height="0"/>
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
<![CDATA[WebReport/ReportServer?formlet=HXXF_HR/HRanalysis/RuZhiFenBu_YuanGongShuXing.frm]]></O>
</ColumnConfig>
<ColumnConfig name="CPT" isKey="false" skipUnmodified="false">
<O>
<![CDATA[RuZhiFenBu_YuanGongShuXing.frm]]></O>
</ColumnConfig>
<ColumnConfig name="CPT_NAME" isKey="false" skipUnmodified="false">
<O>
<![CDATA[入职分布_入职员工属性]]></O>
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
<![CDATA[=if(len($DWMC)=0,"","部门ID:")]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="PARAMETER" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(len($DWMC)=0,"",$DWMC+":")]]></Attributes>
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
<Background name="ColorBackground" color="-3355444"/>
<Alpha alpha="1.0"/>
</Border>
<Background name="ColorBackground" color="-3355444"/>
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
<WidgetName name="6dc3c871-b1ed-4f39-8796-2f2f23ec3499"/>
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
<WidgetName name="379912d0-d249-4797-bab0-792ae6934e0f"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Text>
<![CDATA[入职员工基础属性]]></Text>
<FRFont name="SimSun" style="0" size="72"/>
<isCustomType isCustomType="true"/>
<SwitchTagAttr layoutName="tabpane0"/>
</Widget>
<Widget class="com.fr.form.ui.CardSwitchButton">
<WidgetName name="aa7f9f9a-e4f9-4d5d-8678-976a69f0e989"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Text>
<![CDATA[入职员工背景分析]]></Text>
<FRFont name="SimSun" style="0" size="72"/>
<isCustomType isCustomType="true"/>
<SwitchTagAttr layoutName="tabpane0" index="1"/>
</Widget>
<FLAttr alignment="0"/>
<ColumnWidth defaultValue="80">
<![CDATA[200,80,80,80,80,80,80,80,80,80,80]]></ColumnWidth>
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
<border style="1" color="-723724" borderRadius="0" type="1" borderStyle="0"/>
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
	
	},100)
]]></Content>
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
<![CDATA[var a = this.options.form.getWidgetByName("seadate").getValue();
 $("input[name=SEADATE]A").val(a)
 _g().parameterCommit();]]></Content>
</JavaScript>
</Listener>
<WidgetName name="seadate"/>
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
<![CDATA[=year(now())]]></Attributes>
</O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="702" y="0" width="146" height="18"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="seadate"/>
</MobileWidgetList>
<WidgetScalingAttr compState="0"/>
<DesignResolution absoluteResolutionScaleW="1366" absoluteResolutionScaleH="768"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="956" height="27"/>
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
<![CDATA[723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[144000,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="0" cs="2" s="0">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(len(seadate)==0 || seadate == year(now()),"本年度",seadate+"年度")+"<span style='color:#bf0008; font-weight: bold;'>"+B11+"</span>入职总数</span><span style='color:#bf0008; font-weight: bold;'>" + B2 + "</span>人，其中在职<span style='color:#bf0008; font-weight: bold;'>" + B4 + "</span>人，已离职<span style='color:#bf0008; font-weight: bold;'>"+B3+"</span>人;"+if(len(seadate)==0 || seadate == year(now()),"本年度",seadate+"年度")+"主营员工入职<span style='color:#bf0008; font-weight: bold;'>" + B5 + "</span>人，其中在职<span style='color:#bf0008; font-weight: bold;'>" + B7 + "</span>人，已离职<span style='color:#bf0008; font-weight: bold;'>" + B6 + "</span>人;"+if(len(seadate)==0 || seadate == year(now()),"本年度",seadate+"年度")+"入职非主营<span style='color:#bf0008; font-weight: bold;'>"+ B8 +"</span>人，其中在职<span style='color:#bf0008; font-weight: bold;'>"+ B10 +"</span>人，已离职<span style='color:#bf0008; font-weight: bold;'>"+B9+"</span>人。具体情况如下："]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="1" r="1">
<O t="DSColumn">
<Attributes dsName="本年度入职人数" columnName="RENSHU"/>
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
<C c="1" r="2">
<O t="DSColumn">
<Attributes dsName="本年度入职且离职" columnName="RENSHU"/>
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
<C c="1" r="3">
<O t="DSColumn">
<Attributes dsName="本年度入职且在职" columnName="RENSHU"/>
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
<C c="1" r="4">
<O t="DSColumn">
<Attributes dsName="本年度主营员工入职" columnName="RENSHU"/>
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
<C c="1" r="5">
<O t="DSColumn">
<Attributes dsName="本年度主营员工入职且已离职" columnName="RENSHU"/>
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
<C c="1" r="6">
<O t="DSColumn">
<Attributes dsName="本年度主营员工入职且在职" columnName="RENSHU"/>
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
<Attributes dsName="本年度非主营员工入职" columnName="RENSHU"/>
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
<Attributes dsName="本年度非主营员工入职且已离职" columnName="RENSHU"/>
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
<C c="1" r="9">
<O t="DSColumn">
<Attributes dsName="本年度非主营员工入职且在职" columnName="RENSHU"/>
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
<C c="1" r="10">
<O t="DSColumn">
<Attributes dsName="部门名称" columnName="DESCR"/>
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
<ReportFitAttr fitStateInPC="2" fitFont="false"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="0" zoom="true" refresh="false" isUseHTML="false"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="956" height="85"/>
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
<![CDATA[723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[144000,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="0" s="0">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="<span>华夏幸福共招聘常青藤</span><span style='color:#bf0008; font-weight: bold;'>" + B2 + "</span>人，其中，离职<span style='color:#bf0008; font-weight: bold;'>" + B3 + "</span>人，本年度离职<span style='color:#bf0008; font-weight: bold;'>" + B4 + "</span>人，本月度离职<span style='color:#bf0008; font-weight: bold;'>" + B5 + "</span>人"]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="1" r="1">
<O t="DSColumn">
<Attributes dsName="常青藤招聘人数" columnName="RENSHU"/>
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
<C c="1" r="2">
<O t="DSColumn">
<Attributes dsName="常青藤整体离职" columnName="RENSHU"/>
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
<C c="1" r="3">
<O t="DSColumn">
<Attributes dsName="常青藤本年度整体离职" columnName="RENSHU"/>
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
<C c="1" r="4">
<O t="DSColumn">
<Attributes dsName="常青藤本月度整体离职" columnName="RENSHU"/>
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
</CellElementList>
<ReportAttrSet>
<ReportSettings headerHeight="0" footerHeight="0">
<PaperSetting/>
</ReportSettings>
</ReportAttrSet>
</FormElementCase>
<StyleList>
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
</body>
</InnerWidget>
<BoundsAttr x="0" y="27" width="956" height="85"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report0_c_c"/>
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
<WidgetName name="report0_c_c"/>
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
<![CDATA[720000,720000,720000,720000,720000,720000,722880,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2880000,2880000,2736000,2743200,2880000,2880000,2736000,2743200,2880000,2880000,2736000,2743200]]></ColumnWidth>
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
<![CDATA[=if(len(seadate)==0 || seadate == year(now()),"本年度",seadate+"年度")+"入职且在职（主营）"]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="0" cs="2" s="0">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(len(seadate)==0 || seadate == year(now()),"本年度",seadate+"年度")+"入职且已离职（主营）"]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="1" cs="2" rs="5" s="1">
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
<![CDATA[="平均职级：" + round(A9, 1) + "级"]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="1" cs="2" rs="5" s="1">
<O t="Image">
<IM>
<![CDATA[-!CIOPg/r/\iZ`U=qDsT5nK,I@+V5#<go:Y;@oX.5?LO?Y2'8)C$A*uQgPCKP#Cksp\V_g]AQ
)g"b]ADt(\MMR&F!fJZ5`:5YKbOLe:h[UiC&IHi52=]A,KFcB:kl).o+S85%jU5#eq1Buf&+n?
B.NX^<kCJnb=)ELaYEggRWq+q;@J%(TKf$fQ\B]A?k?Nb,cJ''_4M3/-orISVdLLMGuD-K5dK
pmqsEM4lL5?ml>NfLi6!_rWK%ORP>>Gp)Qo0`C"IQ;G/%N"#i!365BhkR.=G`Fp`MMc3o<.+
jS?'sNib]AL"LO5sggGBq0,ANIr^/d'6"9cpPC$(diSrh&1Rb]A@h^RP<V":A.$s]A'<\:Lsm^X
>I27Pr(iB]A=otK$;+F#qF3U4mp"SF`9i(9#@c.A0<=)nY@It4B`a0m]ADq3A7SX;&T%c9hSbT
Y(Km*LA5r4;!&;Pc(X:B^H'`/MV_dW,>_UiB@;HP.a6.$]A!?8'X52\hlDUVu0:VYh`C+/iX1
#5@gIIar##%S?T0CM]A-B6q)>VG8[[^&QT&fl/#Vh)0H6Ml>h`s"<2!H4hLLN!&ArafV_T333
B<lMX+,7T5P/X>d3RrWogo?^%Rl/)!#ElLkp\'Vgu+tu*@.4)H'PE\n9o.Ko""4=jp7rk3pj
Npp<n6U%]A`\Zlh+4[X:AmdJjg'U,^c$`TBoU?3"8T]AQD'=O6,n<A8Fn=E'oQF#-&goUDol\a
113KCC-?\]AS-c:#f2G%tEJDjjitcQ^/gmid[e5KM;qDXM,,uRQHQK@t^"k*$"k@@IqD)*CrN
;>aDQdSQY;/t[7bi;liJ:h,8r2kAP*AuVm)FQZ%>J1n$<3bQOR$?&J,*_;DE2$>14(j.EoHE
P,%1g0+"LW3J=T?TCF+,/=JiR-0>0fg0@"O&@pS*c<gXX@]AP?T6AX8U)9,=*NqJoBrHK,J>4
b<^Mn_P^9W**d,h!Z\;>P"7<E$b;lccG$;N#bpa,J.@44=4j'CL^CdkVVM*kKZq!\VYnah_M
OS&3bj>d-3UgX<qMm5<,$Nd^TL!C*BtZ)J*MZU1Q]A!fe9,Q.CCn+8%b/rYR'MPY;gMn22HF9
7Kf9fXQl<Lh"R>i\Ep%l[dbnMb"C*)b)>FXbO<4Ms%WqSNOr0@AZ`OclL*'D=?WtVYG8S=)_
&r5?nZFLUfk0.&>m]A9jsEhIOWo$rH_2gj)_"kh:#7MAU!obHO0,i1B<J$^O(LrKBPZ\Tr[fV
ARfXER]AI1mrg*-4),3VE6BdGBN079Z<>54CP@`,qFk\YG2Mk4Gp0t'.U5=9B,h$FN\p7@&:X
:.NjXp"KF"WlUI?>c3`<J&3%K:+/J0<%/.0?n^bri?drT#^^s5qL%$Z+JhWq9[$7[/7@SjEd
;Gf'*/hPok<+p^?`jX*3XGl4aHrVFX;lTTl\do_!E>n*_RmTg3d=W/"2li-"2hd$m-qkL%A#
,d#3k]APHm>!<9^W)QA5.jmTEkku.^+]AIH3F&dK.&%h?V1LGPGp'=mWnSVJZ8G>]A]A[14WE%WT
E"m8Sem&Q<j,C4,"!&GinjA&8+A1^3;CaT(")7UB<)Mo_I//1k$JFpqW?7h@AU<Be%s=)Jqf
jOE>m0+j=M"V53SfSI8K^gf!UJF`@AZ\@D$_oWf`@4YcZ#bL$>,*#*)V+l4Q)-_I)B2pQVgp
A=$nEmJmh0NSgiF9N>'LCBnh4jK[;k(B-E8jQ48Y'n#,]A>kDRbR;[G5V^h\#6'$<lKl5ub07
Fqi?iBjWtE-@-bQE?1.7051eZ1`O/:J0k&VNAOL12g\@7H$9mTg66;'lr#*\[p8.XYDp[j[X
TBqD^5$Wi"3+"5'Guj8n.T)o=,8u36g\MG3.f$]A\Ubn#dri+F^L!"IgN$0a!EL8VC4B[DglI
jP,6cQMAL[$)bFZMBor_Dl-cc$eKq#2l_-H)M)$TR@#Q%hQ:i8!^=?\:6h#j2I^J'#/.'&/%
G[Z'0Ri&D2oVH-G7-i2!/N^'6R))U".#CA)?K>,L9;Jt!i;BP<h`o-*DLa^q.>27(V4`gd*o
;l@hDqB:>r5SVNED.s+OHQ!YNZ!6&<&B$NpIK^n"\H(4rs;ALG*FZn1+-3U5Ll4bS'q8$7KQ
//5FEVSZbY5M*]AG,IMJ.%sT5*_Y&"S)[MmAeTEVf;P_C=qV%F=#<;Ro,iFGF"e[S@*+Um5[,
mt"8(:K,PJM$$KG9l!4CU!@Z5:=WhkVoAoP#AAba0S4B:W)9+X(h&FX'uNl5I7a!2j#Y86D^
!miS6GcK+`1#>(V37%(P#I"M7i9)$K&bWo,3C=9`Kt>#_&ApN[TEU0"%@^b-!^FYg6*_>T!;
Kk;7t/&*%BBN^d@+f^kI@%!VugYjRsBF7Oa69Tt\kj]AaJ.?p>Y/Q>!grIQ$kd4NAQK,/#)\I
q@[%MR1JjUa"!Q<82)mdZ&!;SH;K4(j]Aa)%?ZsEpCgnB-?5&7UZuF*C*lL[MZ;@7>rB28qeT
Z7!$emZ?t=)mG]A1QkYL.aFjl+</eBmiQW8pEXVJjPRKneg5F+37]A+:$-?ZVofB:3msN5Jo^8
2Ad*j,,Z4=10#n7IDmchbgP\g)n*FcE@mcXfm=IW+\O23.]AtB9epR<h%?,M+E*!M5C[V<,EK
J$L;*7s5lpk!pa0->W[O\<@-7S:"Hdu`b0Bo(0E,0W(+Z[=CZ6XPJ]A3BXVDn6&4d1@pX!Wr%
^;!B@+C'6j:p=e"Q@\+ah2uWd^ZP6C3OljH6f=%M@lg*6f[g6V.X!hqS/VOnSF_6s5VA0<9>
PgF^TX8-@*Mt)id.p-/RQFp,=8$aR(^_>WUdRUP-<nq.7;'^,%;NmYch,K/@[%$mlia8I%W8
cb?@Iq;+R6,.o&P+c-,sk=F6_=;>7\alRkkt/i)nZT=?,QM^!6LjnQt;2>ZDKL@e8\<\htC]A
H]A(l<PXF,MHMc[0IH;mX*DS<CJ\,iQ"%0,Gm+=kY0L#hNmu^4L:>>Z<16:f?Ub+cN(DnG!^B
[k;FW?m5fdt^uaYfH]AfpI+1aS0XEYgJ;$Y!G):!roe=\`8:)U3C`"n`@sJN?]A=\NN5EJ-eck
AK/l.Kc[CPnAmb=cJ4;l'ope#?#'jU;dZ@mWqgW57=VZ&)[p!)/Zd8LTr]AXF1Z\)*dF.ls6$
8`_/9M<`GD6=[!<"C7s*M3jSIEjnq=eWfVRj/`:*Zq7/%`Pat=0ATqHh\:smiH9t<OMT*D3$
7^jZF#7B?J*/"XDABD6@dZC,Jp]AHjurLi6G/7ZHCDal"0KSV$-X4+>Q;,_H2-'j]ASn(8HFX!
jl!c/r.8_(en.!%g#/&7Zm^SSPG;_3kK5nQ<^hO2C[t:o+s\?..t'EJj*n(P.mn5J6qhaW0I
GR;r,pM<")O4N7kc_[)ta7Yf]AM>M**pT456V*B0G7K'b5db]A13;#[pcWeGZ6aI-p@3>mao1&
LHAe9JcP9rneT<(%Zs@.bJ`pO^pk)qRAoq:sj*'T,Qcrkr@:Aj<Bj(4=H\F[tJP%fNgk^Y;*
PbYthrioUM!?H@(jd>]A^[]AAqJQ9q!ZgLLA:$GLTHIjP1\"g+b,/+ELM@E/Cq?_Z'A-eUEL^a
,`-`JpE(b1'F(MU4+j4fq.`"FN3785m[\0DfRVP,*O#Bh2kNH/p_@<BrIDWTss/scC0@J*sb
OQLAllU/\c?53rlc:?TLH=e)/H=*^/TB"_jn:C>2pM>7Sd&$O]A/bJ<fQ<eK%WI;!D(MF>'@Q
6':WVEh!7lrr>j+B;7l>lfkJGXO':sDE;2]A1'slk"8-pP3&8+Q97oBL^_Kr9AJbb0`Q8kuU/
eCDFVLV.S`ZE">X3F[fsO>;"W+mn!Yf?W,m)MS+0H*j:X^.09KlCRotA)>362gi0d5FErL$5
&S8b0p%/UlpG):A.rc=N'J's#N@^[e-@,%=3!DcL&6m>r%ZW<EGHMXV/]Ac0OiWbQg?4K7S2S
q)TerK/1Bqo[;q6\X&`*/*@!Y]ADj7UUXH)5NX(.Sk3HSPbd):-g0s.:%@kLLiSc?2RFSb#M%
[T?V%n<F1G8hQtN")72O8eP,5eB'_82)/fkY/<7X5"2bC^'Ocpj"o:8!_Q=dH=5<XO+dUQ'%
XPQ@AjM$P-X\kPN2P)W33S?Z(j[=IYVb0P9>e*hkaqW4a(2)X?:/?V\rdC@6rf=]A-DEAIg=4
Wp?^-gQs'sOq2sbXRL693%q;a%,q<dqkg(]A['t3AqI/$>W:d;&IP4YhSfYOhZDDp=0G`OL)=
]A)C8p?XihOLMDj",lVT4q<-(60l/'7l[G9`G6l3YiCdBVa7#';%2^0<>XbI#.<LW5Gu@+W'1
]A;Hq5>G08+>QI]A<obB-r53,,3p!ormj<%Zb@u:K`CKhF(,-nmJTF4V]A#cYCI]As"ta4MSN:`0
jla2!K@E:_/b7KQJE[%GRR*MaPR_FD@u`\(SOuXAlr[:BPkn-R.bo.@DqFOkY!%.]A6D)J]AO\
IRLj<fttCYfDVcg4%-L6b1IC?qAr@Mjrq)@a'uC7BV,3^;0/!R&b@C/+m+gegd07j7Tj-=m;
W2XmR;Wpl`t4JG1ij(imYbFL:4>G+i.eA3\>1BLU:0:_DH]A_!%(%lW$`ZaZiWi%3JrctTpuC
EJ$FJKbRFDKU0I0qZ(h.,6SF53Do&rhI:t9O:cM[_?eOUBFHe#A3:E;>kSlI^Ormnsi!!&)U
A=GR7=LWKjGqILih4q2^ZH,'7Fm2f5\JFkW@]A+jL^g%tRmGHj,)8ksR-as);ZYYr]A!FZ@>UR
oI\-Co=2?apugME*F*!U+54OQ5$_0!p/+6+)uZiZi#5,`-L)%S6eo08\dCJJ1'P;(h&jdI3:
LCoC=_^&YiuA^FFGN&GVG&+)?7V*=i!-("oTJcM.tuO,.$/rg3oB%,%!\RmGpr3bf"<h*q&m
=XBbsj`f"EZ7>@9^JEj2hV"#%H8A[QOM1]A"T<,OoUTgiuIs0`bH@t_s._\>k#aps1CPD&_o$
u7"OR_@:Qjqc3*Q]A(U9!-0<!Ym`ZdP./"^Q0.8FpnF7N2Abu4U76uW$j>uLM![]AeJ2j_,LMi
LF^,;1d-1@^!2#TRT19r8fN^YsoN$sNkS@H@?%rPb>;]ArtfJ/hE[&8k`BC(]AlhA8s+J52RI]A
RJfn-FF_H%Yq5Yo:)T'Uh6/uLQop?i-YS\$9*`aF7gM%:XZkm/+cDdM)l\"D=>cW:^'amA>-
P3`h?A<,L(uecUR%eQB21s]A*Eb)P1%.*ppb*51:`!<&;V&VM3/nm@q]A%H%jMq72<:K+>I0*.
brfiuc;uOc<kLYo,C-4?`)dc.o%aMW`R\\uT[u0]AJ1;7k_\\1$BoT.tGH`r0WJ+k5iSRL`EK
g=oB4C#DDFg14dgteW_<UfGrM?q3[51.N>en@u4)?g9XeMj$j.N\^&D`2::G\sQ(iugbUjR!
GK";N2=bFrlfEI$rW"g(.0b4hg3_h9%J-B;]A%in.haZ.Z]A4.@"+T#6!0*P%5p#a=78@"KA$6
P"LUg,*j'NZ4hQ`&_;AqLa"kA2!N,fH\i)rnj+9Oj,)FglSut6plcB)VGl9nKS/'h&?*mbXc
jF3r6]A9N4;Q#J:]Ai>u9rX/V?PF:R=N^c+h@;\u.^+.KafkC%gg>K!)G?->a(kpm*kH)\BKk\
ZK^`7OP(C"!lsW-sBJp>SD1loQ%'S(%GCOI-G?2phSD&*Y31"V$$k.V&>gMC4l&HVMm?@[.M
J@kG'PQ/AFD#!/;8%RdgU4?-4KCqTa-u]A!&?(W,(@?aB^K')jRq5E,KWD4Jd"ti8G0JR#U7;
OdE!24WSmfr&]A+HGKD)705=c@;;$#7GjREW\s6#;bm\c8QR1X_>YX=F(..4r.lh'B+;_co!@
hMV_=N3ftn[*cqR\<sKWl/50DngqCGKi%:G1$;C#4r4ZV<JGHHX>P\Gl)'B=\jg%1(K5n?#h
q.69jbkC><W)tcqo7p.r\cY;1``RJ[#&-#eTt,'M@2^(;6=rM]A!pk$K_HeZ<UX*_STDq^//N
,b@qJc87'1T_L]A-a6Wh-X-QdSF0,,0nNm'&,*8!G-*D!?dDb>:]Aa.LBb#LC]Am.9`c.']ASE]AE
I%TE_JnL9H[iDW%gX;DXb7lSD+NGj?p>f,9TIRSWjt4p:UF;F3U&q=i#$X@+<OBU&UY,2_bk
FtFU`XF8O[g<m%p!*SJRX#htr,A?XGI7,0E5n";p*im/6YV5liB1C8]A:-eXD075jY-9?+p"+
k-_U0O%Pfr$q<U7QBU5@:8RN>"p;(mPcjjEHbieT<'6Lks2*GmXc45uGY?>dLVQ/Zp3Dd0IZ
1fRl:C&$rX6;0Tu)"6Uo([^chO-43$40bJ#c_m=AM@+aq\tu6B=AXC"AU'``I&!_fjsn[BO6
`7"W#-Gd5`pYAUKnLeZ8`l7fp0ZKP0QTk_WQqrOa8KI%-Xf?Ua@+00&"I64T7FY2JkKR+6Dr
9^LZaU+[(XEbAeGn,.kCb#qW]AD6Dk<d3I]Ao5i-)>KZP,RG?WN>-^>U4eYbj<,Y-o[*.BQFHA
#@Wu^C]A'g(RG;)QWJEQXrr7Xm?W8fNIP`7K>4lkd6og=+A%@X0d0L:\S/4e;rdh(HuQHYi\i
D[=u</1`77]A"Pi=((_T4,pU[:WKB6#,eRmLqW5%F-.LkfL25HVaC+pp-*#)U8.>]A2r-*4gUU
nAtYIXJkIQF&U/JR=K_\eb@m9\(fdeWdLql_msdb4'(bR0X,I[6Wbp:Q)kA&,G42&gSVp0<J
]A.(HKo),$CTe>nn,;=V]A_DgT3Pa_,O\Wpu5e^P.b!4G5L>]AHbCh/"6'D<:"".FQT0%a*Mtk+
s)cXVsAC1"Q,\Z,BWFT2.3\tF:B.br#QDfaS;"r)3.<i\P^AVL4l\+%GG\Ys0F\)HpUeeo$N
ABN/?rK]A(Bul`<O\L?1Im"nf[)pR(eU2#-26]AGNhD:`1S[#nD`!8Id%+uP1`1Q\@'jpDX.,Y
^!Jl]AR6t"oi(YF(<]Ad3,HOU=VlP9tIGu+RIEN?po7(>TNhV*jn^OM<laYGa6'"\6\Tc\]A]A5P
h;dP9kr`MGc$0'6gT_bNdVTn"0/2OW*`FcWsI\ifXI>p0>F(Z4W%inGAB`PqK-^'Wc/ld5bE
;W8`&(6A:PC.2U/o>SMTk9EG9MP'Y_b?9:ikpcToJ35\N%1tam-`e9N'USbhA((eX?e2_^&e
(#&bRU9ZLlD+iIDpR$dA8I-+E&<?A,u*!ac1`F?_BQFrFgcN/P>8G^7f`L`(I+JQ09;0N$Z(
]A*jr';5'HfP_C,50Toe_8U;7$cZ0r]A+L;)P[@fUnp&OO>Ha/*`;Gs/e<G30>m:+Y!'sqJ2]A;
9HlT8.Yq<YV$L;\*`h+??'B7lIP/d]AVfOUeS'2G\Y-/U(m72L.F^O5('-QRe,DXg.JTH?kE9
qlAL]A2&]Al:#A$]AU`<G_b\>tLe.D#S1he;ENgp-:q"9b[N%DV8KWBFMs>VflHCD`*gM?.A*M9
(1rtpL]A1!E5gD)O%=NJiWViY$m[Y-XQZ<2]A6$aPD!3nof&'qmDc(CD8RaSY>=HD2gTObo4L<
l+!V4D"=t&WSC7fa+NU,lhV]A`a`E/c2Yo?6m#e%[=Lf#9#1kD7n!&u]A@7K_m\0a\NNTbmq?b
^/h[Y1@i_<5dHoP"=QkbdJAiQ?8%En/t7a78W<4HEb[sqjt\540lV5J\!d_`k([_V>G0aXJ^
'YAu?da7IcYZ@@LHp!s@9c]AF'?YeQhlti0sR"7P=\QD><Q?QAeTgX_bV;c8]A]A!/q+7Tf8pcA
4S8@;hrC=?-rp"b7C-lM;n%"rM<1?&1?s5cmVG^.rdSMp.Pp"TISlr;K^c-?RU#\F;geRdON
Q]AM^kC[X_hEYHHMpE)5+&8W;1?J"M!AL?CY#*9h(Z9]Au,.$[<=k95%]AJ&.f*M5991DBQ0d`J
akkq5b0\UOjuu<j3;2kc5W;HGKb%2a`7ac1K#?#^.=g";KWNg=AfnRQiqg$_P]A"K11_hraX]A
\QK7+/K&UP6ng\Yu.J$Cp0*7/>)q%]AgE4q5RB+&^p$kc!r==7HCb.?8THC1'Z5P<C_/=<TTS
i83;g/7!s<c"DA]A"GLTUDndkt)kk@/N6j]A^cc'C[kio$e6Wmpe92+]A^\`6^C27aAcps$-Vc`
$aI^qTC#*K@<^fiADfkHLc9[lG-D9dj'&T'e51IP_f'Kb`<dqqfm^)t'n9"IFB;F=*tlB7'Y
@-Lh(KXat=f"2A&Q3\:^mDAOJ^Y04bqN=*97E2fYMC>DPaDcL2QDs9q-3]A123YBj+7n@OOki
dH)8cL;q=ra*f!^=<gd)IaR_cUV[T61,qG*8m<eX:PKg@9asPSe.4sT!0]Ag_eqbQ.tE$TJJ\
Fb4Tq*GjR@f0S?]A7eS3pMcd%^K>3B?+Y-bH>bXqnB?j:g_k&V\(MSlK7s*Zu'\J?T;Ua0uJX
lWFE1TDJip2[-?)O&eY^k=nWC;7s1Wo,aN+Z@L[TY(??.5_30)'s`p4P"<bFrc\FAI'6'hJa
tEs'AQ`j!C6`1b":p\%F7E'p#<.E5/;4nq;WjWKT*O?YM")F)'TF(D+Y/[8Bl.<>R!RYnRp-
gpfZ5jO.^fn\X1Qb%4Ekn@iQj.>;>^_WGf38fWCNEP.l2Ag9.4VQg3'3#W4?#L&in#8e@G0$
Db0Lgu$hcm_kM+iUEo:N!A.Y/UmnB>i<lh=bjfQ7U?CU4BM2*<`QNb;I\AG>/o_3+Yf6r$#n
]A&%E*^M"&2?]A<J:`6DqEGi=G\-T$MD<h3D^Y*)tg`-p<P,`Co,8n!ssK;^lEj*YqN>udQYS4
OK2dX3JqNL^)]A_nA7V1Fp[s$Ms-e1uj=IJ`kGfmRA>CjtWS[>N<u+FG!U#P"A*1mjA2o"E"=
X#8ojc.(Rl48ON/'XM"W7mh0c7tk!&!^%bQ'S)iX`kCr3TVTE9s0Bfm;`mOVO9%pD<X\mJ-J
51<tPn;N584lWM<BFActC/Nic.i"tiTs(L@(s4s%S=J/3V0VWC8j/EfG1=b;W,k:JMPF2Q'2
lDVqlf6^_?9&Xl8[$aGC.quIZ2=h(;Ap2D%IMV!Y95Zams<i+RIH6`6W>3D![S'B3E^S'6Q#
2?r_t=O1LtQ/T6rgPE(QJUcCqo+2r\3tN#46n9u<!D*`RE^IZ.g?\D_DBF&3$8AdjFYfN.sh
e4GLuK3<1Z'`Ri`,^i%NDI&QB_d^X2`'6*"W_&sMp)h]A:LtRI.;]AaJFAZPIimVgQYnUY@M`u
j,j?[ACYWKE/,qUCEFH<Q3,WX1ZA#2np19'E!fRktWq>eC:LVBe4=&B*t+d/IlC0FDJ;RJRN
l!(KE^Fb[&S.VYFI")83d5>m3CL'c8%htGlJALuJ#S:PVM,`@P7Kg/]A4@^;@eqf@LZ0Ah0*+
'[PY&YC(Tr&X.&06!!Gmp'!P/ucjYIDe2A+"ZDsO]AmsrQa?L567.78X7b2-kGP7<mrBt;JKk
`$/r/hR!tIBC\POCj"Q@C('LV7Fi*AB'P26kkk/qQL/+pDBpuB?>(VRrF[JM3S8uaa6:U&Rk
UKsBX5RWJ9^4Lb8(mb',h>JgeKbF<P`=KGP%tCelfFK>Y\0L(5Rq4-"Gi]A`D%boW]AV4((Hm]A
bH=rkL>G5kUX]AL;1SjbWaD9p)h@&G`U@>8P(4G.H,d6HbN,9iZ68CTKg9G<h-d10]Ai>%8['r
bmjiT.G]A`'6DMeAMQ:.B?9>q\.-<LaW@&HstKQUlo`nG,$lV"bBRbKGei+,Ys)7*B`OC>OX8
&HW>R$eT^I_gcuVgEX>6+OY\BAHXrIIkAodM-F"4&&p1Ur%!L+W4W'V:bC,[$pBVpZ>0[e85
`NX-``&s!]AJp+`:A$%%-0)VB&1dF.,s<IqpkP-[8B0iJ%sini!tC<2cr)!=rbGos[MFGe)29
MbeC]AP;LE!Q@,+nGd3iKI_d8cF8j#L,&L/20o\rX,3r9f$nEN?(S!=,:"M>-qB/$Q[XiT+40
_@[\3_&:)>Y5Y)6uU4F%>_ELuW_abc0UXf?hhg>SW-G<ScGJK\_"S!2Yp"&oZ9E44)]A>qtmr
P7l(of/`b)k@8IU?0@kgGcmYko$q'lKaQ0>Nh-BGL"4:#d'@s5A_@?^`P]A#X@=pSg>3R7.%8
9=R&&f%OFSG*3EGoqR/)4bapG1TocI+3n+.t9uU'WFSo6*\4]A/b9`N>gWke)=tn4+q0[+,R\
celWrX5CC"hKZrj%4,#Zj*4WMJ_LneEO;s5*6l#nu;lT0kiHj"f&h^1&t!:9[bO:)GU:RLR:
ZdX0PlNadQbT[XH*<e*nW(2]A<K+HZl/lh7qdX(X?h2pcLJu-6&OSM"3H!Z!\rTf]AP3k2I^Uu
3N"gY=RS@00jZ@s-\aq<s8j.6+GN>PNgGGL1e<1QfR.i3%a7[Dq%:aU7YV]A^Y$hnT8De#b@m
mq1["';Ch),ri0dTRee.tapXbp6L`e#$gqiZr;:pZ$bCDVY>Q(AiNB\doR4U?/,j0iV-paQA
bu.lbSYVpV,7ZP)V)h2;FQ:kEA3rS4eC0`Eg?s&%ASPXgmIZbHe:>&"g^l]A/@X[[Bi;q``Zj
>o[$mqdo+/LY@I=a+&#Eq$P[9qL'k-ELC4<iI>Y(K9kU;Ws<7,)Wf<r34QqU)M8tS*YApLVK
1BIE*%Z;AafEI0sTqb1<K]AS`CHmuR`-8[m!4Ep.D(iL/q>EFBD)&G4'nZp(`D)@<V7.WS^>j
g8b2B1B:s,#S3!M+'MTab-JdnL?%b!:S(CKDmM3V8`b0&5NW^?X,meV;^/j\iUog5`jH]ALb'
.Zlh"b9MtAm>Bc'%@^BJ(CtnjQVh0daAGXZ(Q+$(-GMI8ubQ,)G0GCCC0<$Y?V/Y_Bb"*g#r
07sJkcT%:h&ob0YlnHRm0L9p9mFo_fNIT(K,Rc+U5<VjlUoq.=I6rV]Ahkq0Bi-0I3^;n/fdr
I!O:f!9e_#j2)klRXDt[OBhn7K3c3Bqhd"d#`a$#u@ipUe,B.,c\I(8sPjuZp>MgA$0$Gsg&
P:*-hpI9m?D9PqDL3@d_3W8kR+:j3:(oTm59Qe:23W%#*_4H\$m.1.oq_9U4;6\UE%W]A^r4D
dCL4`C8IW]AWYJNKL'5ZXVT!*g2V=Q=sJY[X*7KrB'#ud0p?o:ds#WbEZek1_tW<3fBGj.CW`
d")`_Vh3KH:91C/?O+5gd#77(oB[B>`W4Sg+(h4TVqfT+nNQC)2O"$5SR>%8?$J+2oFI>EES
CYDo3hP?tc-U==QCt.R.3`[[0fjGCUWS)Q:I3p>ko"Kn4F+q&R/E.`(P8=h3F,[%8]A0L+o(G
?7DOlsDh?<OLZnVYqo)462\/T#TG/a";e8S%L8uc0ZcPkH$Bof/jVo;T3SFR5m`\T@uguVGH
0jm^?na_s%)sb2h_%hZ?^ol2dOrlpn!k]A#uFNKV`V:<\MN<IPs1$aI+-M>TXW')rmfR\qQFu
1D"&<6#\K3@B+^+J_giN2rT*Rkn8h/+R9g^7VeJWeGPrpc#u8"N>O-h++22nR_A^lZADpQ4/
A<0*068kRK@,7fJPpVT<94AQj0aa5gME6@0EeG"+Q9&C;-ru1-[/!8(?4-'KTET#!+)%'X:4
MLiNca+sGmI0;*RiK+eEKh4t5>b&.O&3Aoj2K@u0lTkFCY"0l*dnA@ej4ElI-lcRNWGI23+N
:)9gLAr%]AM/r'\lX"IX\GE#L1M7i-QM]AC[cJ5a^U"bkkC+ZHlg*O:EjaBS=H1BY*$@5K^NdN
--mG3S8H`fF*+K)UC6j<bcTN:%kon"[QVb$6/-K@ME?i#AgdihIuq(55N<HUju<32>cdsj17
R"=oGtUdZO.0o/a[;/"964XPopeHgA\M/O.$UA9]A[_Um&sb$lZhmql0=q)*W\Br_"VK!,f84
j7CMM#W8PZ$@W44]Af$L=UV&R>C8E=YAegse4S,Uq\%1j[P6_f;)=\dAg/O$]Ap!e:,`T0g`Kn
gF&"&482Mo4R8iNRTJ,I='P+HW\[MJ5cHdL(O%cl_`P-;q!4?TdgeC@:WT;eKW]AZd?Ip#`F6
LuEm=+M$o@C@N\tjti]AU)g2:?Tq`B*?W%rXiS&l_!;hKWYXGg+]A7ikF&\:>@YPf++!JA=P;R
n2j%ms,`Q`>!Vo5KcRJ]AP/o\,;UFe/oO,h7[3_!CA$^TEb-)0"EPt4?(rW-n0ce$ILQ8%OgX
CI?e"7c24J3i;rB<Ai<*F#d=snjNce$8E%762bJVbKIad5[IrY1OUMf8JPV?S6arM7p6E)BB
]Aq\T(;?30hVhiAlNnTW"$$*=-B5Wm?#?[GaPcc!UOp4&`"Xsg4,?!gX=.=(tBg#_b!WApX[[
$',h/:1kcqW=@eY#cM3$$9`RQE35PQVDYDn'j!:Om5P@BRoNm35rXqL/<Q^E5*4Pmj@.Oeb/
\]AH&$QmOe)b8<"C;M7eEmLgZX'7oO7FHRX+Sp;`QCm*,*7XQ9"&@AMMLFO(.&nG7*H-kH&\j
>g,8CS8ftm?Hn-/CVSU)@:5C`>a`di^,XC%7.)+L(.3s4FbdE&Wj]A>oq6WP6!.NeB>4d)WU#
,5e3K(Bs06VCj]AaH?*5s5==`<7]A5p[rA[qRu*7DsKAto'9I[$=\I>4*8,AV9s6_SGPF;?51Q
9nn"9l*oih-4*uC$!ZKd'@322#3npDp1(?`bn$PSQjFB;+-bA$es1/a0>5/q<(npC1GY]Ab-j
<="eNgZo#C-V@Ji.\T,_r8i_R0mNep=#9h@d23!NocZ=m472L'%SrW2MWU\On)sE4[!\1)RG
)c(F?C(KlpWsr)u-Qb`X*hmiCr%T;Kr`RN'khZW8I;jH?Fe;5'>U?s=Q>]AX_3aJYm)X4nA&j
)F^(#+:@Z=60rj1eG^jo?<U6mDb!WuA&+1c'ua`L$:>tVL!H]An@Gf1k"<Q\1gWkj0?SQ+VQY
;S[Df=kATu[#=pt!NG%#0_lN;>c.=F"'#:_hT\S^<qs^Vk&jBYP1CJ3BOYp&p.#*!G='1?=F
l!b`8V;$V(JQLhgBlHhJJ'$gM^lp:5\FVOK2U3aD3AoVM8f(P#G^<Cca-ta%7f*iKRR1ct7V
XFC-,:mS-SfP:A!/p#$>*E)]AcRhh"L,N&jBo:A9qU0GfH+-2$rWO]AW*Z[md`)lZbkYW.3!)%
V[G5ONR,'UMtbTa[0CRPisU7GtOF7mKo-KqM(55#cgf9JLTAdZ<@,D*[[M(f"g,8s&'HEB'W
b.p4Of9->q\9rBRrVtXEjU+_`FL:]AWZn\AI;Q"0I%CTl7J4Fed%)9-^%)'[%<E$!Olqst2r9
4WM>**=!LIpIm,VO*^NeT-8X35`?nIb;Q@!%cBDQIY59/LmGg6M'=+'YeCB7oD`$Kf$_1p1Y
<M<ZM8(hlT9n(M&Pf.D,eAH5qMD^BH+4M$2-U5er__he>`7`>6(hpFj:JU8S"jQb&^DTsND_
kjJDn?PC*k0s>2~
]]></IM>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="1" cs="2" s="2">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="平均职级：" + round(A8, 1) + "级"]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="1" cs="2" rs="5" s="1">
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
<![CDATA[="平均职级：" + round(A7, 1) + "级"]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="2" cs="2" s="2">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="本科及以上占比：" + round(B9 * 100, 1) + "%"]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="2" cs="2" s="2">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="本科及以上占比：" + round(B8 * 100, 1) + "%"]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="2" cs="2" s="2">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="本科及以上占比：" + round(B7 * 100, 1) + "%"]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="3" cs="2" s="2">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="平均工龄：" + round(D9, 1) + "年"]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="3" cs="2" s="2">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="平均工龄：" + round(D8, 1) + "年"]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="3" cs="2" s="2">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="平均工龄：" + round(D7, 1) + "年"]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="4" cs="2" s="2">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="平均年龄：" + round(E9, 1) + "岁"]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="4" cs="2" s="2">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="平均年龄：" + round(E8, 1) + "岁"]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="4" cs="2" s="2">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="平均年龄：" + round(E7, 1) + "岁"]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="5" cs="2" s="2">
<O t="Formula" class="Formula">
<Attributes reserveInWeb="false">
<![CDATA[="男：" + F9 * 100 + "%" + ", " + "女：" + G9 * 100 + "%"]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="5" cs="2" s="2">
<O t="Formula" class="Formula">
<Attributes reserveInWeb="false">
<![CDATA[="男：" + F8 * 100 + "%" + ", " + "女：" + G8 * 100 + "%"]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="5" cs="2" s="2">
<O t="Formula" class="Formula">
<Attributes reserveInWeb="false">
<![CDATA[="男：" + F7 * 100 + "%" + ", " + "女：" + G7 * 100 + "%"]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="6">
<O t="DSColumn">
<Attributes dsName="入职平均职级（主营）" columnName="ZHIJI"/>
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
<C c="1" r="6">
<O t="DSColumn">
<Attributes dsName="入职本科及以上占比（主营）" columnName="ZHANBI"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="2" r="6">
<O t="DSColumn">
<Attributes dsName="主动离职平均司龄（主营）" columnName="SILING"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="3" r="6">
<O t="DSColumn">
<Attributes dsName="入职平均工龄（主营）" columnName="GONGLING"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="4" r="6">
<O t="DSColumn">
<Attributes dsName="入职平均年龄（主营）" columnName="YEARSOLD"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="5" r="6">
<O t="DSColumn">
<Attributes dsName="入职性别占比（主营）" columnName="NAN"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="6" r="6">
<O t="DSColumn">
<Attributes dsName="入职性别占比（主营）" columnName="NV"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="0" r="7">
<O t="DSColumn">
<Attributes dsName="在职平均职级（主营）" columnName="ZHIJI"/>
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
<Attributes dsName="在职本科及以上占比（主营）" columnName="ZHANBI"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="2" r="7">
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
<C c="3" r="7">
<O t="DSColumn">
<Attributes dsName="在职平均工龄（主营）" columnName="GONGLING"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="4" r="7">
<O t="DSColumn">
<Attributes dsName="在职平均年龄（主营）" columnName="YEARSOLD"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="5" r="7">
<O t="DSColumn">
<Attributes dsName="在职性别占比（主营）" columnName="NAN"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="6" r="7">
<O t="DSColumn">
<Attributes dsName="在职性别占比（主营）" columnName="NV"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="0" r="8">
<O t="DSColumn">
<Attributes dsName="在职平均职级" columnName="ZHIJI"/>
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
<Attributes dsName="在职本科及以上占比" columnName="ZHANBI"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="2" r="8">
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
<C c="3" r="8">
<O t="DSColumn">
<Attributes dsName="在职平均工龄" columnName="GONGLING"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="4" r="8">
<O t="DSColumn">
<Attributes dsName="在职平均年龄" columnName="YEARSOLD"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="5" r="8">
<O t="DSColumn">
<Attributes dsName="在职性别占比" columnName="NAN"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="6" r="8">
<O t="DSColumn">
<Attributes dsName="在职性别占比" columnName="NV"/>
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
<FRFont name="微软雅黑" style="0" size="72"/>
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
<BoundsAttr x="0" y="0" width="956" height="273"/>
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
<BoundsAttr x="0" y="883" width="956" height="273"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
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
<LCAttr vgap="0" hgap="0" compInterval="0"/>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ChartEditor">
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
<![CDATA[=if(len(seadate)==0 || seadate == year(now()),"本年度",seadate+"年度")+"入职人员职能序列分布（"+switch($fenlei,null,"总体",'总体',"总体",'总体-在职',"总体-在职",'总体-离职',"总体-离职",'主营-总体',"主营-总体",'主营-在职',"主营-在职",'主营-离职',"主营-离职",'非主营-总体',"非主营-总体",'非主营-在职',"非主营-在职",'非主营-离职',"非主营-离职")+"）"]]></Attributes>
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
<OColor colvalue="-4259840"/>
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
<FRFont name="微软雅黑" style="0" size="72"/>
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
<![CDATA[职能序列]]></Name>
</TableData>
<CategoryName value="FENLEI"/>
<ChartSummaryColumn name="RENSHU" function="com.fr.data.util.function.NoneFunction" customName="RENSHU"/>
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
<BoundsAttr x="0" y="0" width="956" height="293"/>
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
<![CDATA[职能序列]]></O>
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
<Attr showLine="false" autoAdjust="false" position="6" isCustom="false"/>
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
<VanChartColumnPlotAttr seriesOverlapPercent="20.0" categoryIntervalPercent="20.0" fixedWidth="false" columnWidth="0" filledWithImage="false" isBar="false"/>
</Plot>
<ChartDefinition>
<MoreNameCDDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[职能序列]]></Name>
</TableData>
<CategoryName value="FENLEI"/>
<ChartSummaryColumn name="RENSHU" function="com.fr.data.util.function.NoneFunction" customName="RENSHU"/>
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
<BoundsAttr x="0" y="590" width="956" height="293"/>
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
<![CDATA[=if(len(seadate)==0 || seadate == year(now()),"本年度",seadate+"年度")+"各单位入职平均职级（"+switch($fenlei,null,"总体",'总体',"总体",'总体-在职',"总体-在职",'总体-离职',"总体-离职",'主营-总体',"主营-总体",'主营-在职',"主营-在职",'主营-离职',"主营-离职",'非主营-总体',"非主营-总体",'非主营-在职',"非主营-在职",'非主营-离职',"非主营-离职")+"）"]]></Attributes>
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
<Attr enable="true"/>
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
<OColor colvalue="-4259840"/>
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
<Attr rotation="-50" alignText="0">
<FRFont name="微软雅黑" style="0" size="64"/>
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
<![CDATA[各单位]]></Name>
</TableData>
<CategoryName value="DANWEI"/>
<ChartSummaryColumn name="AVGZHIJI" function="com.fr.data.util.function.NoneFunction" customName="平均职级"/>
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
<BoundsAttr x="0" y="0" width="956" height="268"/>
</Widget>
<body class="com.fr.form.ui.ChartEditor">
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
<![CDATA[各单位平均职级]]></O>
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
<Attr enable="true"/>
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
<Attr showLine="false" autoAdjust="false" position="6" isCustom="false"/>
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
<FRFont name="Verdana" style="0" size="64" foreground="-10066330"/>
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
<VanChartColumnPlotAttr seriesOverlapPercent="20.0" categoryIntervalPercent="20.0" fixedWidth="false" columnWidth="0" filledWithImage="false" isBar="false"/>
</Plot>
<ChartDefinition>
<MoreNameCDDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[各单位]]></Name>
</TableData>
<CategoryName value="DANWEI"/>
<ChartSummaryColumn name="AVGZHIJI" function="com.fr.data.util.function.NoneFunction" customName="平均职级"/>
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
<BoundsAttr x="0" y="322" width="956" height="268"/>
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
<![CDATA[=if(len(seadate)==0 || seadate == year(now()),"本年度",seadate+"年度")+"入职员工职级区间（"+switch($fenlei,null,"总体",'总体',"总体",'总体-在职',"总体-在职",'总体-离职',"总体-离职",'主营-总体',"主营-总体",'主营-在职',"主营-在职",'主营-离职',"主营-离职",'非主营-总体',"非主营-总体",'非主营-在职',"非主营-在职",'非主营-离职',"非主营-离职")+"）"]]></Attributes>
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
<HtmlLabel customText="function(){ return this.category+this.value;}" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
</AttrToolTipContent>
<GI>
<AttrBackground>
<Background name="ColorBackground" color="-16777216"/>
<Attr shadow="true"/>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="7"/>
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
<OColor colvalue="-4259840"/>
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
<FRFont name="微软雅黑" style="0" size="72"/>
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
<![CDATA[职级区间]]></Name>
</TableData>
<CategoryName value="FENLEI"/>
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
<BoundsAttr x="560" y="0" width="396" height="210"/>
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
<![CDATA[职级区间]]></O>
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
<Attr showLine="false" autoAdjust="false" position="6" isCustom="false"/>
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
<ChartDefinition>
<MoreNameCDDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[职级区间]]></Name>
</TableData>
<CategoryName value="FENLEI"/>
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
</body>
</InnerWidget>
<BoundsAttr x="560" y="112" width="396" height="210"/>
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
<![CDATA[=if(len(seadate)==0 || seadate == year(now()),"本年度",seadate+"年度")+"入职员工平均职级"+if(len($fenlei)==0,"（总体）","（"+$fenlei+"）")]]></Attributes>
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
<HtmlLabel customText="" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
</AttrToolTipContent>
</labelDetail>
</AttrLabel>
</Attr>
</AttrList>
</ConditionAttr>
</DefaultAttr>
<ConditionAttrList>
<List index="0">
<ConditionAttr name="条件属性1">
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
<![CDATA[主营-总体]]></O>
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
<![CDATA[非主营-总体]]></O>
</Compare>
</Condition>
</JoinCondition>
</Condition>
</ConditionAttr>
</List>
<List index="1">
<ConditionAttr name="条件属性2">
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
<![CDATA[总体-在职]]></O>
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
<![CDATA[主营-在职]]></O>
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
<![CDATA[非主营-在职]]></O>
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
<Background name="ColorBackground" color="-6250336"/>
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
<![CDATA[总体-离职]]></O>
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
<![CDATA[主营-离职]]></O>
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
<![CDATA[非主营-离职]]></O>
</Compare>
</Condition>
</JoinCondition>
</Condition>
</ConditionAttr>
</List>
<List index="3">
<ConditionAttr name="条件属性4">
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
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="1">
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[分类序号]]></CNAME>
<Compare op="0">
<O>
<![CDATA[4]]></O>
</Compare>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[分类序号]]></CNAME>
<Compare op="0">
<O>
<![CDATA[8]]></O>
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
<NameJavaScriptGroup>
<NameJavaScript name="职级区间">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="fenlei"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=CATEGORY]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="chart1"/>
<linkType type="0"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="各单位">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="fenlei"/>
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
<NameJavaScript name="职能序列">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="fenlei"/>
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
<NameJavaScript name="当前表单对象4">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="fenlei"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=CATEGORY]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="chart0"/>
<linkType type="0"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
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
<VanChartColumnPlotAttr seriesOverlapPercent="20.0" categoryIntervalPercent="20.0" fixedWidth="false" columnWidth="0" filledWithImage="false" isBar="false"/>
</Plot>
<ChartDefinition>
<MoreNameCDDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[总体主营非主营本年度入职人员平均职级]]></Name>
</TableData>
<CategoryName value="FENLEI"/>
<ChartSummaryColumn name="AVGZHIJI" function="com.fr.data.util.function.NoneFunction" customName="平均职级"/>
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
<BoundsAttr x="0" y="0" width="560" height="210"/>
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
<![CDATA[平均职级]]></O>
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
<HtmlLabel customText="" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
</AttrToolTipContent>
</labelDetail>
</AttrLabel>
</Attr>
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
<ConditionAttrList>
<List index="0">
<ConditionAttr name="条件属性1">
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
<![CDATA[系列序号]]></CNAME>
<Compare op="0">
<O>
<![CDATA[1]]></O>
</Compare>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[系列序号]]></CNAME>
<Compare op="0">
<O>
<![CDATA[4]]></O>
</Compare>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[系列序号]]></CNAME>
<Compare op="0">
<O>
<![CDATA[7]]></O>
</Compare>
</Condition>
</JoinCondition>
</Condition>
</ConditionAttr>
</List>
<List index="1">
<ConditionAttr name="条件属性2">
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
<![CDATA[系列序号]]></CNAME>
<Compare op="0">
<O>
<![CDATA[2]]></O>
</Compare>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[系列序号]]></CNAME>
<Compare op="0">
<O>
<![CDATA[5]]></O>
</Compare>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[系列序号]]></CNAME>
<Compare op="0">
<O>
<![CDATA[8]]></O>
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
<Background name="ColorBackground" color="-6250336"/>
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
<![CDATA[系列序号]]></CNAME>
<Compare op="0">
<O>
<![CDATA[3]]></O>
</Compare>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[系列序号]]></CNAME>
<Compare op="0">
<O>
<![CDATA[6]]></O>
</Compare>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[系列序号]]></CNAME>
<Compare op="0">
<O>
<![CDATA[9]]></O>
</Compare>
</Condition>
</JoinCondition>
</Condition>
</ConditionAttr>
</List>
<List index="3">
<ConditionAttr name="条件属性4">
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
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="1">
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[分类序号]]></CNAME>
<Compare op="0">
<O>
<![CDATA[4]]></O>
</Compare>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[分类序号]]></CNAME>
<Compare op="0">
<O>
<![CDATA[8]]></O>
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
<NameJavaScriptGroup>
<NameJavaScript name="职级区间">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="fenlei"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=CATEGORY]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="chart1"/>
<linkType type="0"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="各单位">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="fenlei"/>
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
<NameJavaScript name="职能序列">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="fenlei"/>
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
</NameJavaScriptGroup>
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
<VanChartColumnPlotAttr seriesOverlapPercent="20.0" categoryIntervalPercent="20.0" fixedWidth="false" columnWidth="0" filledWithImage="false" isBar="false"/>
</Plot>
<ChartDefinition>
<MoreNameCDDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[总体主营非主营本年度入职人员平均职级]]></Name>
</TableData>
<CategoryName value="FENLEI"/>
<ChartSummaryColumn name="AVGZHIJI" function="com.fr.data.util.function.NoneFunction" customName="平均职级"/>
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
<BoundsAttr x="0" y="112" width="560" height="210"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="absolute0"/>
<Widget widgetName="report0_c"/>
<Widget widgetName="chart0"/>
<Widget widgetName="chart1"/>
<Widget widgetName="chart2"/>
<Widget widgetName="chart3"/>
<Widget widgetName="report0_c_c"/>
</MobileWidgetList>
<WidgetZoomAttr compState="0"/>
<AppRelayout appRelayout="true"/>
<Size width="956" height="1156"/>
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
<LCAttr vgap="0" hgap="0" compInterval="8"/>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="chart6_c"/>
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
<WidgetName name="chart6_c"/>
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
<newColor borderColor="-8355712"/>
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
<![CDATA[本年度入职且在职主营员工上家雇主岗位行政级别分布(体制内)]]></O>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="104" foreground="-13421773"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="2"/>
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
<FillStyleName fillStyleName=""/>
<isCustomFillStyle isCustomFillStyle="true"/>
<ColorList>
<OColor colvalue="-4259832"/>
<OColor colvalue="-9209476"/>
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
<Attr rotation="-45" alignText="0">
<FRFont name="微软雅黑" style="0" size="64" foreground="-10066330"/>
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
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0%]]></Format>
<AxisLabelCount value="=1"/>
<AxisRange minValue="=0" maxValue="=1"/>
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
<VanChartCustomPlotAttr customStyle="column_line"/>
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
<NameJavaScriptGroup>
<NameJavaScript name="JavaScript1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="name_1"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="RZDATE"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=YEAR(NOW())]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="ISZY"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=1]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="XZJIBIE"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=CATEGORY]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="DWMC"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$DWMC]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="NAME_CP"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$USERNAME]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[var url=FR.cjkEncode('/WebReport/ReportServer?reportlet=HXXF_HR%2FHRanalysis%2Fzuanqu_ganbu_1.cpt&DWMC='+DWMC+'&XZJIBIE='+XZJIBIE+'&RZDATE='+RZDATE+'&ISZY='+ISZY+'&USERNAME='+NAME_CP)
window.parent.parent.parent.$('#iframe2').attr('src',url);
window.parent.parent.parent.$('.smallIframe').show();
window.parent.parent.parent.$('.model').show();
window.parent.parent.parent.$('.minmizeName').html(name_1);
window.parent.parent.parent.$('.smallIframe').css({
			width: '900px',
			height: '600px',
			left:'50%',
			top:'50%',
			marginLeft:'-450px',
			marginTop:'-300px'
		});
]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
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
<Attr rotation="-45" alignText="0">
<FRFont name="微软雅黑" style="0" size="64" foreground="-10066330"/>
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
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0%]]></Format>
<AxisLabelCount value="=1"/>
<AxisRange minValue="=0" maxValue="=1"/>
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
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
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
<Attr isCommon="true" markerType="RoundFilledMarker" radius="4.5" width="30.0" height="30.0"/>
<Background name="NullBackground"/>
</VanAttrMarker>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrLabel">
<AttrLabel>
<labelAttr enable="false"/>
<labelDetail class="com.fr.plugin.chart.base.AttrLabelDetail">
<Attr showLine="false" autoAdjust="false" position="1" isCustom="false"/>
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
<Attr rotation="-45" alignText="0">
<FRFont name="微软雅黑" style="0" size="64" foreground="-10066330"/>
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
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0%]]></Format>
<AxisLabelCount value="=1"/>
<AxisRange minValue="=0" maxValue="=1"/>
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
<DefinitionMap key="column">
<MoreNameCDDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[2_3_1_主营员工上一家雇主分析_行政级别]]></Name>
</TableData>
<CategoryName value="XZJIBIE"/>
<ChartSummaryColumn name="RENSHU" function="com.fr.data.util.function.NoneFunction" customName="人数"/>
</MoreNameCDDefinition>
</DefinitionMap>
<DefinitionMap key="line">
<MoreNameCDDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[2_3_1_主营员工上一家雇主分析_行政级别]]></Name>
</TableData>
<CategoryName value="XZJIBIE"/>
<ChartSummaryColumn name="ZHANBI" function="com.fr.data.util.function.NoneFunction" customName="占比"/>
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
<BoundsAttr x="0" y="0" width="956" height="368"/>
</Widget>
<body class="com.fr.form.ui.ChartEditor">
<WidgetName name="chart6"/>
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
<![CDATA[干部上一家雇主岗位行政级别分布]]></O>
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
<Attr isVisible="true"/>
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
<BoundsAttr x="0" y="788" width="956" height="368"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="chart5_c"/>
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
<WidgetName name="chart5_c"/>
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
<newColor borderColor="-8355712"/>
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
<![CDATA[本年度入职且在职主营员工上家雇主行业类型分布]]></O>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="104" foreground="-13421773"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="2"/>
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
<FillStyleName fillStyleName=""/>
<isCustomFillStyle isCustomFillStyle="true"/>
<ColorList>
<OColor colvalue="-4259832"/>
<OColor colvalue="-9209476"/>
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
<Attr rotation="-45" alignText="0">
<FRFont name="微软雅黑" style="0" size="64" foreground="-10066330"/>
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
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0%]]></Format>
<AxisLabelCount value="=1"/>
<AxisRange minValue="=0" maxValue="=1"/>
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
<VanChartCustomPlotAttr customStyle="column_line"/>
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
<NameJavaScriptGroup>
<NameJavaScript name="JavaScript1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="name_1"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="RZDATE"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=YEAR(NOW())]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="ISZY"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=1]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="HYLEIBIE"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=CATEGORY]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="DWMC"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$DWMC]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="NAME_CP"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$USERNAME]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[var url=FR.cjkEncode('/WebReport/ReportServer?reportlet=HXXF_HR%2FHRanalysis%2Fzuanqu_ganbu_1.cpt&DWMC='+DWMC+'&HYLEIBIE='+HYLEIBIE+'&RZDATE='+RZDATE+'&ISZY='+ISZY+'&USERNAME='+NAME_CP)
window.parent.parent.parent.$('#iframe2').attr('src',url);
window.parent.parent.parent.$('.smallIframe').show();
window.parent.parent.parent.$('.model').show();
window.parent.parent.parent.$('.minmizeName').html(name_1);
window.parent.parent.parent.$('.smallIframe').css({
			width: '900px',
			height: '600px',
			left:'50%',
			top:'50%',
			marginLeft:'-450px',
			marginTop:'-300px'
		});]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
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
<Attr rotation="-45" alignText="0">
<FRFont name="微软雅黑" style="0" size="64" foreground="-10066330"/>
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
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0%]]></Format>
<AxisLabelCount value="=1"/>
<AxisRange minValue="=0" maxValue="=1"/>
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
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
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
<Attr class="com.fr.plugin.chart.base.AttrLabel">
<AttrLabel>
<labelAttr enable="false"/>
<labelDetail class="com.fr.plugin.chart.base.AttrLabelDetail">
<Attr showLine="false" autoAdjust="false" position="1" isCustom="false"/>
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
<Attr rotation="-45" alignText="0">
<FRFont name="微软雅黑" style="0" size="64" foreground="-10066330"/>
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
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0%]]></Format>
<AxisLabelCount value="=1"/>
<AxisRange minValue="=0" maxValue="=1"/>
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
<DefinitionMap key="column">
<MoreNameCDDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[2_2_1_主营员工上一家雇主分析_行业类别]]></Name>
</TableData>
<CategoryName value="HYLEIBIE"/>
<ChartSummaryColumn name="RENSHU" function="com.fr.data.util.function.NoneFunction" customName="人数"/>
</MoreNameCDDefinition>
</DefinitionMap>
<DefinitionMap key="line">
<MoreNameCDDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[2_2_1_主营员工上一家雇主分析_行业类别]]></Name>
</TableData>
<CategoryName value="HYLEIBIE"/>
<ChartSummaryColumn name="ZHANBI" function="com.fr.data.util.function.NoneFunction" customName="占比"/>
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
<BoundsAttr x="0" y="0" width="956" height="407"/>
</Widget>
<body class="com.fr.form.ui.ChartEditor">
<WidgetName name="chart5"/>
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
<![CDATA[干部上一家雇主行业类别分布]]></O>
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
<Attr isVisible="true"/>
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
<BoundsAttr x="0" y="381" width="956" height="407"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="chart4_c"/>
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
<WidgetName name="chart4_c"/>
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
<![CDATA[本年度入职且在职主营员工上家雇主类别分布]]></O>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="104" foreground="-13421773"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="2"/>
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
<FRFont name="微软雅黑" style="0" size="72"/>
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
<OColor colvalue="-9209476"/>
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
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0%]]></Format>
<AxisLabelCount value="=1"/>
<AxisRange minValue="=0" maxValue="=1"/>
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
<VanChartCustomPlotAttr customStyle="column_line"/>
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
<FRFont name="微软雅黑" style="0" size="72"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#.##]]></Format>
</DataSheet>
<NameJavaScriptGroup>
<NameJavaScript name="JavaScript1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="GZLEIXING"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=CATEGORY]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="DWMC"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$DWMC]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="RZDATE"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=YEAR(NOW())]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="ISZY"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=1]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="name_1"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="NAME_CP"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$username]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[//console.log("GZLEIXING="+GZLEIXING+"DWMC="+DWMC);
var url=FR.cjkEncode('/WebReport/ReportServer?reportlet=HXXF_HR/HRanalysis/zuanqu_ganbu_1.cpt&DWMC='+DWMC+'&GZLEIXING='+GZLEIXING+'&RZDATE='+RZDATE+'&ISZY='+ISZY+'&USERNAME='+NAME_CP);
//alert(url)
window.parent.parent.parent.$('#iframe2').attr('src',url);
window.parent.parent.parent.$('.smallIframe').show();
window.parent.parent.parent.$('.model').show();
window.parent.parent.parent.$('.minmizeName').html(name_1);
window.parent.parent.parent.$('.smallIframe').css({
			width: '900px',
			height: '600px',
			left:'50%',
			top:'50%',
			marginLeft:'-450px',
			marginTop:'-300px'
		});]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
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
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0%]]></Format>
<AxisLabelCount value="=1"/>
<AxisRange minValue="=0" maxValue="=1"/>
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
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
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
<Attr class="com.fr.plugin.chart.base.AttrLabel">
<AttrLabel>
<labelAttr enable="false"/>
<labelDetail class="com.fr.plugin.chart.base.AttrLabelDetail">
<Attr showLine="false" autoAdjust="false" position="1" isCustom="false"/>
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
<FRFont name="微软雅黑" style="0" size="72"/>
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
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0%]]></Format>
<AxisLabelCount value="=1"/>
<AxisRange minValue="=0" maxValue="=1"/>
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
<DefinitionMap key="column">
<MoreNameCDDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[2_1_1_主营员工上一家雇主分析_雇主类型]]></Name>
</TableData>
<CategoryName value="GZLEIXING"/>
<ChartSummaryColumn name="RENSHU" function="com.fr.data.util.function.NoneFunction" customName="人数"/>
</MoreNameCDDefinition>
</DefinitionMap>
<DefinitionMap key="line">
<MoreNameCDDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[2_1_1_主营员工上一家雇主分析_雇主类型]]></Name>
</TableData>
<CategoryName value="GZLEIXING"/>
<ChartSummaryColumn name="ZHANBI" function="com.fr.data.util.function.NoneFunction" customName="占比"/>
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
<BoundsAttr x="0" y="0" width="956" height="381"/>
</Widget>
<body class="com.fr.form.ui.ChartEditor">
<WidgetName name="chart4"/>
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
<![CDATA[干部上一家雇主类型分布]]></O>
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
<Attr isVisible="true"/>
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
<BoundsAttr x="0" y="0" width="956" height="381"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="chart4_c"/>
<Widget widgetName="chart5_c"/>
<Widget widgetName="chart6_c"/>
</MobileWidgetList>
<WidgetZoomAttr compState="0"/>
<AppRelayout appRelayout="true"/>
<Size width="956" height="1156"/>
<ResolutionScalingAttr percent="0.9"/>
<tabFitAttr index="1" tabNameIndex="1"/>
</Widget>
<carouselAttr isCarousel="false" carouselInterval="1.8"/>
</Center>
</InnerWidget>
<BoundsAttr x="0" y="0" width="960" height="1200"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="tablayout0"/>
</MobileWidgetList>
<WidgetZoomAttr compState="1"/>
<AppRelayout appRelayout="true"/>
<Size width="960" height="1200"/>
<ResolutionScalingAttr percent="0.9"/>
<BodyLayoutType type="0"/>
</Center>
</Layout>
<DesignerVersion DesignerVersion="IAA"/>
<PreviewType PreviewType="0"/>
<TemplateID TemplateID="896282cd-d9f8-4456-a5b3-43039875f3a1"/>
</Form>
