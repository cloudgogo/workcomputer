<?xml version="1.0" encoding="UTF-8"?>
<Form xmlVersion="20170715" releaseVersion="8.0.0">
<TableDataMap>
<TableData name="司龄分布" class="com.fr.data.impl.DBTableData">
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
AVG(SILING) AS SILING,
'1-博士' AS xilie
FROM ODM_HR_YGTZ
WHERE 1=1
AND XUELIFENLEI <='1-博士'

${SWITCH(FENLEI,'',"",'总体',"",'主营',"AND ISZHUYING  ='主营'",'非主营',"AND ISZHUYING  !='主营'",'团队负责人',"AND YGFENLEI LIKE '团队负责人'",'干部',"AND YGFENLEI LIKE '干部'",'常青藤',"AND ISCQT= '是'
AND ISZHUYING  ='主营'")}
${if(len(DWMC)=0,""," and BUMENID in(
SELECT TREE_NODE
FROM ODM_HR_DW
  start with TREE_NODE ='"+DWMC+"' connect by  PARENT_NODE   =  prior TREE_NODE)")}
UNION ALL
SELECT 
AVG(SILING) AS SILING,
'2-硕士' AS xilie
FROM ODM_HR_YGTZ
WHERE 1=1

${SWITCH(FENLEI,'',"",'总体',"",'主营',"AND ISZHUYING  ='主营'",'非主营',"AND ISZHUYING  !='主营'",'团队负责人',"AND YGFENLEI LIKE '团队负责人'",'干部',"AND YGFENLEI LIKE '干部'",'常青藤',"AND ISCQT= '是'
AND ISZHUYING  ='主营'")}
AND XUELIFENLEI = '2-硕士'
${if(len(DWMC)=0,""," and BUMENID in(
SELECT TREE_NODE
FROM ODM_HR_DW
  start with TREE_NODE ='"+DWMC+"' connect by  PARENT_NODE   =  prior TREE_NODE)")}
UNION ALL
SELECT 
AVG(SILING) AS SILING,
'3-本科' AS xilie
FROM ODM_HR_YGTZ
WHERE 1=1

${SWITCH(FENLEI,'',"",'总体',"",'主营',"AND ISZHUYING  ='主营'",'非主营',"AND ISZHUYING  !='主营'",'团队负责人',"AND YGFENLEI LIKE '团队负责人'",'干部',"AND YGFENLEI LIKE '干部'",'常青藤',"AND ISCQT= '是'
AND ISZHUYING  ='主营'")}
AND XUELIFENLEI = '3-本科'
${if(len(DWMC)=0,""," and BUMENID in(
SELECT TREE_NODE
FROM ODM_HR_DW
  start with TREE_NODE ='"+DWMC+"' connect by  PARENT_NODE   =  prior TREE_NODE)")}
UNION ALL
SELECT 
AVG(SILING) AS SILING,
'4-大学专科' AS xilie
FROM ODM_HR_YGTZ
WHERE 
1=1

${SWITCH(FENLEI,'',"",'总体',"",'主营',"AND ISZHUYING  ='主营'",'非主营',"AND ISZHUYING  !='主营'",'团队负责人',"AND YGFENLEI LIKE '团队负责人'",'干部',"AND YGFENLEI LIKE '干部'",'常青藤',"AND ISCQT= '是'
AND ISZHUYING  ='主营'")}
AND XUELIFENLEI = '4-大专'
${if(len(DWMC)=0,""," and BUMENID in(
SELECT TREE_NODE
FROM ODM_HR_DW
  start with TREE_NODE ='"+DWMC+"' connect by  PARENT_NODE   =  prior TREE_NODE)")}
UNION ALL
SELECT 
AVG(SILING) AS SILING,
'5-中专及以下' AS xilie
FROM ODM_HR_YGTZ
WHERE 
1=1

${SWITCH(FENLEI,'',"",'总体',"",'主营',"AND ISZHUYING  ='主营'",'非主营',"AND ISZHUYING  !='主营'",'团队负责人',"AND YGFENLEI LIKE '团队负责人'",'干部',"AND YGFENLEI LIKE '干部'",'常青藤',"AND ISCQT= '是'
AND ISZHUYING  ='主营'")}
AND (xueliFENLEI>='5-中专及以下'OR xueliFENLEI IS NULL)
${if(len(DWMC)=0,""," and BUMENID in(
SELECT TREE_NODE
FROM ODM_HR_DW
  start with TREE_NODE ='"+DWMC+"' connect by  PARENT_NODE   =  prior TREE_NODE)")}
 ORDER BY xilie ASC
]]></Query>
</TableData>
<TableData name="整体性别分布" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="DWMC"/>
<O>
<![CDATA[10048109174]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[HXXF_HR]]></DatabaseName>
</Connection>
<Query>
<![CDATA[SELECT 
XILIE,
XINGBIE,
RENSHU
FROM(
SELECT 
RENSHU,
'总体' AS XILIE,
XINGBIE
FROM
(
SELECT 
COUNT(YGID) AS RENSHU,
XINGBIE
FROM ODM_HR_YGTZ
WHERE 1=1
${if(len(DWMC)=0,""," and BUMENID in(
SELECT TREE_NODE
FROM ODM_HR_DW
  start with TREE_NODE ='"+DWMC+"' connect by  PARENT_NODE   =  prior TREE_NODE)")}
AND zhiji NOT LIKE '99%' GROUP BY XINGBIE
)
UNION  ALL
SELECT 
RENSHU,
'主营' AS XILIE,
XINGBIE
FROM
(
SELECT 
COUNT(YGID) AS RENSHU,
XINGBIE
FROM ODM_HR_YGTZ
WHERE 1=1
${if(len(DWMC)=0,""," and BUMENID in(
SELECT TREE_NODE
FROM ODM_HR_DW
  start with TREE_NODE ='"+DWMC+"' connect by  PARENT_NODE   =  prior TREE_NODE)")}
AND ISZHUYING  ='主营'
AND zhiji NOT LIKE '99%' GROUP BY XINGBIE)
UNION ALL
SELECT 
RENSHU,
'非主营' AS XILIE,
XINGBIE
FROM
(
SELECT 
COUNT(YGID) AS RENSHU,
XINGBIE
FROM ODM_HR_YGTZ
WHERE 1=1
${if(len(DWMC)=0,""," and BUMENID in(
SELECT TREE_NODE
FROM ODM_HR_DW
  start with TREE_NODE ='"+DWMC+"' connect by  PARENT_NODE   =  prior TREE_NODE)")}
AND ISZHUYING  !='主营'
AND zhiji NOT LIKE '99%' GROUP BY XINGBIE
))
UNION ALL

SELECT 
XILIE,
XINGBIE,
RENSHU
FROM(
SELECT 
RENSHU,
XINGBIE, 
XILIE
FROM(
SELECT 
RENSHU,
XINGBIE,
YGFENLEI AS XILIE
from(
SELECT 
COUNT(YGID) AS RENSHU,
XINGBIE,
YGFENLEI
FROM ODM_HR_YGTZ
WHERE 1=1
${if(len(DWMC)=0,""," and BUMENID in(
SELECT TREE_NODE
FROM ODM_HR_DW
  start with TREE_NODE ='"+DWMC+"' connect by  PARENT_NODE   =  prior TREE_NODE)")}
AND YGFENLEI NOT LIKE '%员工%'
AND ZHIJI NOT LIKE '%99%'
GROUP BY XINGBIE,YGFENLEI))

UNION ALL 
SELECT 
RENSHU,
XINGBIE, 
'常青藤' AS XILIE
FROM(
SELECT 
RENSHU,
XINGBIE
from(
SELECT 
COUNT(YGID) AS RENSHU,
XINGBIE
FROM ODM_HR_YGTZ
WHERE 1=1
${if(len(DWMC)=0,""," and BUMENID in(
SELECT TREE_NODE
FROM ODM_HR_DW
  start with TREE_NODE ='"+DWMC+"' connect by  PARENT_NODE   =  prior TREE_NODE)")}
AND ISCQT= '是'
AND ISZHUYING  LIKE '主营%'  GROUP BY XINGBIE
)))]]></Query>
</TableData>
<TableData name="平均年龄" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="FENLEI"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="DWMC"/>
<O>
<![CDATA[10048109174]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[HXXF_HR]]></DatabaseName>
</Connection>
<Query>
<![CDATA[SELECT
ROUND(a.YERRSOLD,0)||'岁' AS NAN,
ROUND(b.YERRSOLD,0)||'岁' AS NV
FROM(
SELECT 
avg(floor(MONTHS_BETWEEN(SYSDATE,CSDATE)/12)) AS YERRSOLD
FROM ODM_HR_YGTZ 
WHERE 1=1
${SWITCH(FENLEI,'',"",'总体',"",'主营',"AND ISZHUYING  = '主营'",'非主营',"AND ISZHUYING != '主营'",'团队负责人',"AND YGFENLEI LIKE '团队负责人'",'干部',"AND YGFENLEI = '干部'",'常青藤',"AND ISCQT= '是'
AND ISZHUYING  = '主营'")}
AND ZHIJI NOT LIKE '%99%'
${if(len(DWMC)=0,""," and BUMENID in(
SELECT TREE_NODE
FROM ODM_HR_DW
  start with TREE_NODE ='"+DWMC+"' connect by  PARENT_NODE   =  prior TREE_NODE)")}
AND XINGBIE='男')a,
(
SELECT 
avg(floor(MONTHS_BETWEEN(SYSDATE,CSDATE)/12)) AS YERRSOLD
FROM ODM_HR_YGTZ 
WHERE 1=1
${SWITCH(FENLEI,'',"",'总体',"",'主营',"AND ISZHUYING  = '主营'",'非主营',"AND ISZHUYING  != '主营'",'团队负责人',"AND YGFENLEI LIKE '团队负责人'",'干部',"AND YGFENLEI LIKE '干部'",'常青藤',"AND ISCQT= '是'
AND ISZHUYING  = '主营'")}
AND ZHIJI NOT LIKE '%99%'
${if(len(DWMC)=0,""," and BUMENID in(
SELECT TREE_NODE
FROM ODM_HR_DW
  start with TREE_NODE ='"+DWMC+"' connect by  PARENT_NODE   =  prior TREE_NODE)")}
AND XINGBIE='女')b]]></Query>
</TableData>
<TableData name="平均司龄" class="com.fr.data.impl.DBTableData">
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
ROUND(a.SILING,1)||'岁' AS NAN,
ROUND(b.SILING,1)||'岁' AS NV
FROM(
SELECT 
avg(SILING) AS SILING
FROM ODM_HR_YGTZ 
WHERE 1=1
${SWITCH(FENLEI,'',"",'总体',"",'主营',"AND ISZHUYING  ='主营'",'非主营',"AND ISZHUYING  !='主营'",'团队负责人',"AND YGFENLEI LIKE '团队负责人'",'干部',"AND YGFENLEI LIKE '干部'",'常青藤',"AND ISCQT= '是'
AND ISZHUYING  ='主营'")}
AND ZHIJI NOT LIKE '%99%'
${if(len(DWMC)=0,""," and BUMENID in(
SELECT TREE_NODE
FROM ODM_HR_DW
  start with TREE_NODE ='"+DWMC+"' connect by  PARENT_NODE   =  prior TREE_NODE)")}
AND XINGBIE='男')a,
(
SELECT 
avg(SILING) AS SILING
FROM ODM_HR_YGTZ 
WHERE 1=1
${SWITCH(FENLEI,'',"",'总体',"",'主营',"AND ISZHUYING  ='主营'",'非主营',"AND ISZHUYING  !='主营'",'团队负责人',"AND YGFENLEI LIKE '团队负责人'",'干部',"AND YGFENLEI LIKE '干部'",'常青藤',"AND ISCQT= '是'
AND ISZHUYING  ='主营'")}
AND ZHIJI NOT LIKE '%99%'
${if(len(DWMC)=0,""," and BUMENID in(
SELECT TREE_NODE
FROM ODM_HR_DW
  start with TREE_NODE ='"+DWMC+"' connect by  PARENT_NODE   =  prior TREE_NODE)")}
AND XINGBIE='女')b]]></Query>
</TableData>
<TableData name="平均职级" class="com.fr.data.impl.DBTableData">
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
ROUND(a.ZHIJI,1)||'级' AS NAN,
ROUND(b.ZHIJI,1)||'级' AS NV
FROM(
SELECT 
avg(substr(ZHIJI,0,2)) AS ZHIJI
FROM ODM_HR_YGTZ 
WHERE 1=1
${SWITCH(FENLEI,'',"",'总体',"",'主营',"AND ISZHUYING  ='主营'",'非主营',"AND ISZHUYING  !='主营'",'团队负责人',"AND YGFENLEI LIKE '团队负责人'",'干部',"AND YGFENLEI LIKE '干部'",'常青藤',"AND ISCQT= '是'
AND ISZHUYING  ='主营'")}
AND ZHIJI NOT LIKE '%99%'
${if(len(DWMC)=0,""," and BUMENID in(
SELECT TREE_NODE
FROM ODM_HR_DW
  start with TREE_NODE ='"+DWMC+"' connect by  PARENT_NODE   =  prior TREE_NODE)")}
AND XINGBIE='男')a,
(
SELECT 
avg(substr(ZHIJI,0,2)) AS ZHIJI
FROM ODM_HR_YGTZ 
WHERE 1=1
${SWITCH(FENLEI,'',"",'总体',"",'主营',"AND ISZHUYING  ='主营'",'非主营',"AND ISZHUYING  !='主营'",'团队负责人',"AND YGFENLEI LIKE '团队负责人'",'干部',"AND YGFENLEI LIKE '干部'",'常青藤',"AND ISCQT= '是'
AND ISZHUYING  ='主营'")}
AND ZHIJI NOT LIKE '%99%'
${if(len(DWMC)=0,""," and BUMENID in(
SELECT TREE_NODE
FROM ODM_HR_DW
  start with TREE_NODE ='"+DWMC+"' connect by  PARENT_NODE   =  prior TREE_NODE)")}
AND XINGBIE='女')b]]></Query>
</TableData>
<TableData name="男占比" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="FENLEI"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="DWMC"/>
<O>
<![CDATA[10048109174]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[HXXF_HR]]></DatabaseName>
</Connection>
<Query>
<![CDATA[with 
a as
(
select count(ygid) as total from odm_hr_ygtz
where 1=1 
${SWITCH(FENLEI,'',"",'总体',"",'主营',"AND ISZHUYING  ='主营'",'非主营',"AND ISZHUYING  !='主营'",'团队负责人',"AND YGFENLEI LIKE '团队负责人'",'干部',"AND YGFENLEI LIKE '干部'",'常青藤',"AND ISCQT= '是'
AND ISZHUYING  ='主营'")}
${if(len(DWMC)=0,""," and BUMENID in(
SELECT TREE_NODE
FROM ODM_HR_DW
  start with TREE_NODE ='"+DWMC+"' connect by  PARENT_NODE   =  prior TREE_NODE)")}
),
 
b as
(
select count(ygid) as renshu from odm_hr_ygtz where xingbie = '男'
${SWITCH(FENLEI,'',"",'总体',"",'主营',"AND ISZHUYING  ='主营'",'非主营',"AND ISZHUYING  !='主营'",'团队负责人',"AND YGFENLEI LIKE '团队负责人'",'干部',"AND YGFENLEI LIKE '干部'",'常青藤',"AND ISCQT= '是'
AND ISZHUYING  ='主营'")}
${if(len(DWMC)=0,""," and BUMENID in(
SELECT TREE_NODE
FROM ODM_HR_DW
  start with TREE_NODE ='"+DWMC+"' connect by  PARENT_NODE   =  prior TREE_NODE)")}
)

select case when a.total is null or a.total = 0
            then '0'
            else round(b.renshu/a.total,3)*100 || '%' 
        end  as zhanbi
  from a,b]]></Query>
</TableData>
<TableData name="女占比" class="com.fr.data.impl.DBTableData">
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
<![CDATA[with 
a as
(
select count(ygid) as total from odm_hr_ygtz
where 1=1 
${SWITCH(FENLEI,'',"",'总体',"",'主营',"AND ISZHUYING  ='主营'",'非主营',"AND ISZHUYING  !='主营'",'团队负责人',"AND YGFENLEI LIKE '团队负责人'",'干部',"AND YGFENLEI LIKE '干部'",'常青藤',"AND ISCQT= '是'
AND ISZHUYING  ='主营'")}
${if(len(DWMC)=0,""," and BUMENID in(
SELECT TREE_NODE
FROM ODM_HR_DW
  start with TREE_NODE ='"+DWMC+"' connect by  PARENT_NODE   =  prior TREE_NODE)")}
),
 
b as
(
select count(ygid) as renshu from odm_hr_ygtz where xingbie = '女'
${SWITCH(FENLEI,'',"",'总体',"",'主营',"AND ISZHUYING  ='主营'",'非主营',"AND ISZHUYING  !='主营'",'团队负责人',"AND YGFENLEI LIKE '团队负责人'",'干部',"AND YGFENLEI LIKE '干部'",'常青藤',"AND ISCQT= '是'
AND ISZHUYING  ='主营'")}
${if(len(DWMC)=0,""," and BUMENID in(
SELECT TREE_NODE
FROM ODM_HR_DW
  start with TREE_NODE ='"+DWMC+"' connect by  PARENT_NODE   =  prior TREE_NODE)")}
)

select case when a.total is null or a.total = 0
            then '0'
            else round(b.renshu/a.total,3)*100 || '%' 
        end  as zhanbi
  from a,b
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
<![CDATA[WebReport/ReportServer?formlet=HXXF_HR/HRanalysis/EmployeeBasic_Gender.frm]]></O>
</ColumnConfig>
<ColumnConfig name="CPT" isKey="false" skipUnmodified="false">
<O>
<![CDATA[EmployeeBasic_Gender.frm]]></O>
</ColumnConfig>
<ColumnConfig name="CPT_NAME" isKey="false" skipUnmodified="false">
<O>
<![CDATA[员工基础属性_性别分布]]></O>
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
<Margin top="1" left="10" bottom="1" right="1"/>
<Border>
<border style="0" color="-723724" borderRadius="0" type="0" borderStyle="0"/>
<WidgetTitle>
<O>
<![CDATA[新建标题]]></O>
<FRFont name="宋体" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Background name="ColorBackground" color="-1118482"/>
<Alpha alpha="1.0"/>
</Border>
<Background name="ColorBackground" color="-1118482"/>
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
<WidgetName name="4c894bdd-f93f-41f9-a1bd-fdb825f62558"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Text>
<![CDATA[整体性别分布]]></Text>
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
<LCAttr vgap="0" hgap="0" compInterval="8"/>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="chart6_c_c"/>
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
<WidgetName name="chart6_c_c"/>
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
<![CDATA[性别分布]]></O>
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
<Attr lineStyle="1" isRoundBorder="false" roundRadius="0"/>
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
<Attr enable="false"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0.0级]]></Format>
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
<HtmlLabel customText="function(){ return this.category+this.value;}" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
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
<HtmlLabel customText="function(){ return this.seriesName+&apos;:&apos;+this.value;}" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
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
<realateName realateValue="report0"/>
<linkType type="1"/>
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
<OColor colvalue="-6710887"/>
<OColor colvalue="-3276792"/>
<OColor colvalue="-6250336"/>
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
<OneValueCDDefinition seriesName="XINGBIE" valueName="RENSHU" function="com.fr.data.util.function.NoneFunction">
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[整体性别分布]]></Name>
</TableData>
<CategoryName value="XILIE"/>
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
<BoundsAttr x="0" y="0" width="940" height="273"/>
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
<Attr enable="true"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0.0]]></Format>
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
<TitleVisible value="true" position="2"/>
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
<AxisLabelCount value="=0"/>
<AxisRange/>
<AxisUnit201106 isCustomMainUnit="false" isCustomSecUnit="false" mainUnit="=0" secUnit="=0"/>
<ZoomAxisAttr isZoom="false"/>
<axisReversed axisReversed="false"/>
<VanChartAxisAttr mainTickLine="2" secTickLine="0" axisName="X轴" titleUseHtml="false" autoLabelGap="false" limitSize="false" maxHeight="15.0" commonValueFormat="true" isRotation="false"/>
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
<VanChartColumnPlotAttr seriesOverlapPercent="20.0" categoryIntervalPercent="20.0" fixedWidth="true" columnWidth="60" filledWithImage="false" isBar="false"/>
</Plot>
<ChartDefinition>
<OneValueCDDefinition seriesName="XILIE" valueName="ZHIJI" function="com.fr.data.util.function.NoneFunction">
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[基础属性平均职级分布]]></Name>
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
<BoundsAttr x="0" y="0" width="940" height="273"/>
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
<![CDATA[723900,723900,723900,720000,720000,720000,720000,720000,720000,720000,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" cs="2" s="0">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="不同性别人员属性"+"（"+if(len($FENLEI) = 0, "总体", $FENLEI)+"）"]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="1" cs="2" rs="9" s="1">
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
<C c="4" r="1" cs="2" rs="9" s="1">
<O t="Image">
<IM>
<![CDATA[!O!26l\SG57h#eD$31&+%7s)Y;?-[s2ZNgX^'FoC!!&-lQW=(d'R!&95u`*_h;&B:'N_jG@*
Hh?3Q^>F-ZeF`]A]A;dr16\-=R)C6gj,,658-"465ZhQ2Q>RH=fqDsj!>PV=PuSM%>S+jXd#%Y
:&ko%0`9=_M?'.hed."fbb&/bfDYdCP7At;,K+2+*5Q4m]ArqBI&kQ-4j8.E6ENRQr#j(A='J
sUOtU<'/\;<W%;RE2d1)@u=W4ant1:>et-4_O'+(u6#OrHKAn/]AJL<iHE.d352ZIHf:i55&N
M#0N9<B3Iqm@-k9bbhsc/A3a,s(RZsL*i2GkXE9%agfh*DVEQ#scW,i[Pcr!Gi/fV@<<5A08
=R/"XRB"&%^erL6n\.b+38uMh'rE18MUNCqBH-Z[o['af*#7>am>aN"Eckc)ipL=S;(F>jHp
>Ngp$mj5,$\?)8<LJ;AN51G)9Qn/0OE0U$qmMGfW_:-`b"qhLDU7pA\a!<*_;fQ1]A^O0gU#Z
?Fsi34iD+,KF#CPEh5OQYpCF-QcrfP?pR\7>in(G4&oHYaI-3lcR2e9=pao<so@MLIAtpfB,
+Pj95+OPKm\_)qb&EW7)C8I#'.5W."uZ3br@hBMqq*<$2>gbofA!dg_YIW[l3\^?_5R.*E]AJ
qLV@Nk.88T?4>IV"k9+b:CXo0\h@Buh&)04g97P1"[`V)MQ#tsu5LTN#!cr^o:,YAh8hdo0d
87D7O;K"8ZFOFe\YW+'GM@tOb/)1@K.i8n_&L)nQM'5]AdSH'K#AjOHJgS"#PFs<;)g.u9HZM
Qb0\CKm(>a^SJ5h?M/_r9TSfXs6Letn$eC0V<\/.I?HQ'"n*ZP:-WaFr^EMEu9s%/MTB%h9B
CC!Bg@<@!;n8O>rXEeF^:)[I3]A6*-\!A4=,HJa?4CJ_)!oNENbXFf0d]A$5MOY$pnS3=QjE/6
,"C:OqeAF\"uB#jZ<22i;tuG\K5M.114bg;M^D'"]A'>TaA7eIVYXbU\?e0Mq`:-t_6f%1iaG
RANc'Z+L=/%p/6`J%$_q*BH2tn\gVNO('>W7.171`V&'hL.Ba,C9C00V,D[Qpgbbnt6q?6#q
:bFsWN+d)WJV)BbE-HGV4o%[2'HI1)+p!AlHbuf85WU,g^Dmbg=8Kb:FmG99c-of,-(GJfI5
I7Ml/P")E*6r7Jt-]A$A[!9f(Es\Pp(o()k6g`aWXG`D#D:h6)jp-j34MeVaQ_EB1uuG'bTMT
Y5ON%SQTpHECPq/hI-ChN-&9SG>cqB@Ro0=Hi2.4P3k'OQf;N%GTT9)U+5P<D\ao*3qV#C;r
oUp?87,m6KlI0=FD-qE@'HCDNCsY%C<uO]A<Guf^mpas'2ie`)MpjV([5rXGm*;jFi*pC'E?W
%]A*EuFZ#<aG]AGm&P4ar]A`LN.@r$+TiY==h>GC4rXV#A)E#IM$/un4lkUGV><gnotQ_S?D&XJ
]A^8nq)@6$OaN`GD/^(rOHkn[d:`S[&+`>k`T!KKMj%fo#q]AD0+&OY*[J[inbnM&qX5L\S)4q
f9Vrs!SpA.?C]AhjXb731+fZb+Kd\W.jQNYiF[O`!(tXj),m^"6Xr!1m!U]A=J%n*M$t"`;r.%
Bo3Xr0klGA2FFXIJi?s-B#MRGt:i>DJmp63a=Go@+6$HP,]A"#X0[2Zp/_&g0&bZj6[1*@si(
WnMMT]A=(0"2<>c?NU3npApnuI=),J0Uk)4iL%;iSo\>:Y6E^\?7m%<,X37a=rTb'4[$Z^GLN
AVr-$-;$Tl1#kQY\oXmL&"jMtR$"*R%U>m263%D/>.ggE*!mqp8[&";\D),H$/3t_aa>:9!7
lVIV(ICk&jmN_NMWQfk*cAQdqKLPV(j@Da%5$!.ToAPN8LN9Zr=I\r![-Tq_hN)+N'Ck.q'(
Bj]AJpXDQTGpDKNeU9TH):imkI*]A[g*1L,DbL]A1rBi^lA12&3Ip;CNhN/3/Z_p1`qG>6BG1`R
XHZ$!0?XuV$K+iFQb6N#p:k5;r.>)b%mXVfd?b2E:Xpls1F8D[)<%d"RDrqp(DVXh\;,X:lL
ZKTMFm?LA;ndciCI;is>HXZ(<).q>9!H6A+h1tfFooi>8`R.[.J[9gq!UE2"A]AIJ<!ej7%`%
p]A-iH%TCD<fAF<:@;fq[/7eLSI4IhJQ2]AC]A/R'X6b2*qUG%((ra-j4%77't+Z#:A>6&N2FZg
Y6^-GEY>*QUi<;aShuD+2F@=(l0F1p^[@WI84USc20:uQQ!D:rZ-Yj738ZrRhp9+I9P.&96-
05oMdt]A]AU49=:JjXeqYWUPEAk`.)*3>*,s6;l:Coo)\]A$kjs0-c2i25rofCK;FX#!sFR]A3e7
1&#:QU_nL_5G[.^hkd!n-P(tNO=6![S("*J,k(&f3.>WBf5[gBG>Xg.7S>%DJ-I,Y%38)Q;m
AZ4925TBM%3ReZ:%sq(Q..o5BJG^-1Y*i>/qlshFbB#;jsnDW3<?fF9aX89oUnEp/f[cHgR7
9E?HZ'ojJM8Qfn+?hW!HRH8YZ^HEO5jPpD4:!]Ac3YjF"/2IASKNG0Jr-oZ31`,9Om,&Bejar
Qn.a_,luAAVK>@60928;a%I-+g30=Qka4LYm,!;Y&8Yo+Di8%_k&<M%%IF%U*:Y4dWnjD^Mk
2GOY1da>H*WZpY1"]ADF)&D:Y'>#+15+E+<jXmZ?^g>I[IQ5+<oH[/r9d6R$WrQ$U(c4RYfP$
rW,96"[#U>=):!/]ACPpW]Ah8MBlm34Wg2^(&,Q`!m;Sn*_N!;9j3FmjPuB,oG*WHh1Z%^U=t9
*oR]AfFT,m(X"rYe>e+[P@/7\<LX:j%^1OR(CRCTNa$Xt3G**GC5":5cYertPki[,><k^Ea_Z
3,(&'7/j5gaAb+b;*>i!t2rL'Cc8)\!ZK'!a4T&VNI'APU_We!*6HE]A>MSRq2?@6OIoI\U0'
_oaqERQ$E<m^d"M,+%o>=Y!dWE%musBj4<g!#ua*b*I#2SsmX'.hkE<("Pu9DQ*Zu]ACjNNZN
`HdXi?EioDis8,R2+":YK!sglV9oOtcS<[>#orkGUgb_if_XfjP?n.F+`D1[!eAQOQRYF,/S
04lAqa5;^FX62/bh[3tL9WYB]Ajck%6[c%=!]AL/;eM'+-;`+_2]Apj1'8Y7=_&E#eCl3"jK\.d
)(Ui`'r=lMH.]A*=)AHDqAG5,O"el3)F,H4(Rn+1WA.MG^V`_!!^32R%Yu-B).>K[DH@/=1s9
5YN#`G!B(b-';@Iu=;9b#i?>>>j$u'#l]A[NSX`Jffd$(Pu;\g+[DKjht1(@F5_7I5/V$]A5g-
]A/.NJp"18eX]A0j+UCuU:Peo+YA$LUPWl!tUomuO@"_>*%fD)<QPJtibY7-DKnm&(.9Qp@d$N
S;:iZW;)qig8A;+!;m*/;Hbn\2"0*#7iY&^\Riqd_\2F@UM=%ZrW0G;TPf7H_ZY\Mt%A7qOm
%(aXYSM0/LC1l`Vbp8o3_dmA7h`^bmjP6,UZ>2jLO3?c'hIVtW5\g'!njQ"0boif1/"&*_X8
A6a.cJg*d_Pg",1mgDR(6/U%$3e)F[>d7-pj.j;Io2]A>reM8%)g>_0efk8>NtC*!_3p5P&<%
/?<ER#OY"Y!K#`afBAkrN`7hBPXHQ&h%5r`BJ1iRpIiLHJM-Gdt\+g,_diPLu2^^!7:'78OR
"ulq*F&EkZZbVg(@F:YcH,`"dW$?On0lr?gOYdJr$,5\@5A1&+"63U;k8dsUE@HPMF26K`Jk
)=p`\)l+rP4r`[Ld"&_VP,]ATYnrfXk$LmPuDP=O';m]AH\[G>9\:q08;h:o*cRmN\,q9FFu(N
8Z\4bD<:0&YeSt7nD5Gg!>^dQH'0[OR(o!T25_<'[N;K2t9-QL]AIHnqLn/@H$B'se27FS#!g
]A7U3QLLCtopS6RhBZqTX'C"G6X2&B(I35*$+8eNJZrQ7!t/u)%3=H6(cZHNF6omSbEB7)@]A^
gmFbi[ui#E$K&Ws94&]A7fPe`[P\^qc?OSeFg-lQLq(j[g6UTFPtE%%I@W3N;)o$dkPm=h&2e
iZ&fF:C5>rTGj4mLtg/-F4m6SS0\:3*oT+`WCCbOS%q0CLC*B%K]Ah]Aq13\7&Es]A_epG1\f7u
6UEi2@PJ*,ne`2o.K`<2FSkYc`*1&N?>9HVAD(7B4eG8[dDo2e.i5#BYcCBAp!,S9'>JQM1Z
sjWml\E_M7u5SibmJodB[bdA$8<<'tTrMW*=EYe'[.IL9Sd;h)8#<WTF2sCZngX2s_L"f+P,
ANIPAAB3/H4sA(Mq)U'ZZ!*f,t(rHKXaP=>@'5%i]AVmD,nM%5"`]AGF+<r-Onj>a:,V0c^_AC
+`Ld7nq>Qe[n)Pd5hhpK1-MqA8P7<lZ%DiCC@h?4>CI0EXE?bm4V$Rf+2&(59q+ms+b#dCUg
KpMF?DW(RobadWZ;jT'egj5,j$7YBm)e\7KF8p%U=Pt)5U1j>;e:h\nA)U<BLD,"l0Yb/\>K
H]AA^sp.snGr_.WAtqNDjWM*@?`ha2us-EUHtEjJ<q;$o+C0UJ1G$c*&WM0nm'5R=o'cHSd4$
sY,cQB[d59<:(h-qGgWguhc]Aiqr5o,%MZ8q#oEfK-6sFb8SHL^ZjB,Dj)SjUZil2R*inh/TX
9c%M%QrbKV786jKepQ.#;\=53DR5=7pLTZ2js`u81e+B&<olK)2$%K*c\ScgaJ=%G>l$-b3o
qP]Ae..\@+)h8mNH)YCfPWpQKU3Ne."q$2oQ!XjUk#%CJrq>-+L@/b&7B/GP5[o5P>W?^g<UP
T1Es]A8oWb=>uG_i\@XMdWFs-dF^Q-)R7VBGQ/Ja/h^'"a?$K[S7Saj*3#=#]A^Co=(]A$]An,=-
pC-a0rB&"q83P)(XuZ&XWm"N/%FohI:<l0\snV20jZ$r?TCZ\KrW)W;fl_*ET:bG$I01FSo5
N:QKFKp<"@ggU.7>\$'OS9]A2ec!#J&2V0/R.:eO)"Zu/Tgf#fg_X3$.j$`1/]Ae6`K*>cg3BN
uK(p*EO^t*(IFDD#>A/\el9-ll#q,r<T`tfDkWgrcb/\jg8HH>D.ucMZHDe\2P,i^]A</TWZ9
76+7\s9cQ609IkP3<Hg'?EJEp#FB9/#o,=P-W?GTa__Ncor<@%`'=-Y7(f1RpoBBh4#j548I
-*"h`r*lgsH:=."M490X+"]Ao$UBe^FV6MRV/e]AUEB9)uhQ-.eT[8!`^Tq><'@9n33=:c7O#-
:U$Tcd_p`\cqp;d$Wn2f0,r$1"$AX6@f%fYD@(ip`Bg1@YVdW.DQ+Y>'hPA)[DIi!B\C1GF0
@<q<s:?8H#)i%jI$65QSOgEHl7b^u)gC@nh5UhVEsHDK0K3dE]ATaChM:R#"f\\cs+S43+UF/
#9+]AN-oAj;>;1nbhsuWI9Y+N0lsPXZDUdCOYU+t0jokW3.1tdnkG(02=gHU<<j8_>en8]A4s-
i;6)<$5YFQ[`B$Lc'3(??hc[*/^&/V/ec2em[-P^XUFb2F@<c)u09-u0*jChP/9&8EY;6R$f
3E'bT$S(.0oQ566Lj;o&S<:1;;[)oMc>Zmb<--(TLaPc6*U;FPe,"X5HA3?JAraAG3lU'6.H
66&'uBcFgd@+3Cu+)=@RClLmmqHM3T<AJMDH&;^W.5T)'N3#T&kd7dj\&'6/0E`LQ*9"`LZ.
IS#WCP!up#f$H&j<s1a]A6``@&sIAh3,2Y]A08gf4P2Rj7>Q5&ciJm%9e[i0JE%N?6Y1SFlP2E
'>KR7kKoA31#b^gGG(5q$`eR8A"#mN9&3^F3VCmEu\ee<^e!pNS-KY4q;=SS3sd@`P;Xr^bt
_8_e`:k^`?AdGCqPRM2Jec%_2+XiNbG-?Ul!D=:Vj)I,UB3aBYj)\37L_/4@m:*&:U9^oc[J
/*&(!,-`qZ--mkA/tE(sQ*8E"Weam"!>i]A_Nlrr1W(gM$Y)i`\a:"$^c/O8cXWl&VYAX09%W
JcIpc>Y,?!>7-k7dSTbIB:>iGee-9K:@(B&N6j^+u!->eLp93JefL#F8?p#W)4M$Fkl(iip/
PW^:R5Je7YihmdL>bah`WF#A@*P#]A$See$j7o89jcOhGQ5EVC?\&jfhPca[Xq6<k</GE<B&b
:CkC)!+:lJsgk:^W,g+j!qdTV$2X@C4%/Ch'L"Ynsm7("6.!eOk>bA.5=:&+YJl6bk[&BEQF
[53(o<V\@t8g[t794pgR,s^.6A-3Gb[]Aih.LTqS"!,%dJa(*4GTV^@I:XrQX97nqnF1@5\&"
9Gk232hT#qE\a!5U*/k^#FmI)3%HSpQR?*X\/]AD;F06qf1Mm2_\MqOB3I2CZbN9K<ED,0G_e
M5q%MSmA`kV/#gYq_2g$em1XDTQb1JuOD`uFUY-;?@cr0_-#h2H]A<r_2(2J%g2Of\rn?Vgb3
O/@_D[=0s14[^FMi'_<1U$VD%:]A+s:`5Q=q>B(msr%4?u)F&n[=@n"SPkF9[TA8==+ipkgC$
NIouXA@]A`LcD/<Ku9u;br;$s.>qJ??hP*l<K[DrG,EY/b;5p0cZ(#Ybr*"LD)AZDEq0H3.!C
9DeUDHg-OBFDqnRr"7rU>R!!o@:F1C3".,7X-44g.KEn1pB@&SkuDRa4g34l^WHO+WJ_[:%-
,G?l_ViAeu(Q2G@8mje!mg[;L1Bn)D?MV)K:Flpgr+u(nT?R)oXZs3CJ9>A3kmc5H]A:JrQZ`
!7^:b.M\epiL:MfFdCJ(kkChSgn[GT]AF<P!0qfdDc1%LlME>jDF:cNS&"Qz8OZBBY!QNJ~
]]></IM>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="2" s="2">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="男，占比："+A14]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="2" s="2">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="女，占比："+B14]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="4" s="2">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="平均年龄：" + A11]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="4" s="3">
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="6" r="4" s="2">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="平均年龄：" + B11]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="5" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="5" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="6" s="2">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="平均司龄：" + A12]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="6" s="2">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="平均司龄：" + B12]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="7" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="7" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="8" s="2">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="平均职级：" + A13]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="8" s="2">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="平均职级：" + B13]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="10">
<O t="DSColumn">
<Attributes dsName="平均年龄" columnName="NAN"/>
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
<Attributes dsName="平均年龄" columnName="NV"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="0" r="11">
<O t="DSColumn">
<Attributes dsName="平均司龄" columnName="NAN"/>
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
<C c="1" r="11">
<O t="DSColumn">
<Attributes dsName="平均司龄" columnName="NV"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="0" r="12">
<O t="DSColumn">
<Attributes dsName="平均职级" columnName="NAN"/>
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
<C c="1" r="12">
<O t="DSColumn">
<Attributes dsName="平均职级" columnName="NV"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="0" r="13">
<O t="DSColumn">
<Attributes dsName="男占比" columnName="ZHANBI"/>
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
<C c="1" r="13">
<O t="DSColumn">
<Attributes dsName="女占比" columnName="ZHANBI"/>
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
<Style horizontal_alignment="2" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="104"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="4">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
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
<BoundsAttr x="0" y="0" width="940" height="223"/>
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
<BoundsAttr x="0" y="273" width="940" height="223"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="chart6_c_c"/>
<Widget widgetName="report0"/>
</MobileWidgetList>
<WidgetZoomAttr compState="0"/>
<AppRelayout appRelayout="true"/>
<Size width="940" height="496"/>
<ResolutionScalingAttr percent="1.2"/>
<tabFitAttr index="0" tabNameIndex="2"/>
</Widget>
<carouselAttr isCarousel="false" carouselInterval="1.8"/>
</Center>
</InnerWidget>
<BoundsAttr x="0" y="0" width="954" height="540"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="tablayout0"/>
</MobileWidgetList>
<WidgetZoomAttr compState="1"/>
<AppRelayout appRelayout="true"/>
<Size width="954" height="540"/>
<ResolutionScalingAttr percent="1.2"/>
<BodyLayoutType type="0"/>
</Center>
</Layout>
<DesignerVersion DesignerVersion="IAA"/>
<PreviewType PreviewType="0"/>
<TemplateID TemplateID="70892bb8-ca6f-4550-b580-6a8c8b53ef17"/>
</Form>
