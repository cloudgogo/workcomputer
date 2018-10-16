<?xml version="1.0" encoding="UTF-8"?>
<Form xmlVersion="20170720" releaseVersion="9.0.0">
<TableDataMap>
<TableData name="ZBPF_KJ" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="dim_cal"/>
<O>
<![CDATA[1]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[oracle_test]]></DatabaseName>
</Connection>
<Query>
<![CDATA[WITH date1 as(
select data_date date1 from dm_mcl_acct where rownum = 1
),
DIM_DATEKJ AS (
SELECT 
		CASE WHEN '1'='${dim_cal}' THEN PERIOD_YEAR
				 WHEN '2'='${dim_cal}' THEN PERIOD_QUARTER
				 WHEN '3'='${dim_cal}' THEN PERIOD_MONTH END AS CALIBER ,--找到我当前时间参数口径（当年、当季、当月）
		'1' as ORDER_CALIBER
		FROM DIM_PERIOD , date1 --时间维度
WHERE PERIOD_KEY=date1.date1
),--当前时间口径 年、季度、月份

DIM_DATEMX AS ( 
SELECT
		DISTINCT 
		CASE WHEN '1'='${dim_cal}' THEN PERIOD_YEAR
				 WHEN '2'='${dim_cal}' THEN PERIOD_QUARTER
				 WHEN '3'='${dim_cal}' THEN PERIOD_MONTH END AS DIM_CALIBER,--口径
		CASE WHEN '1'='${dim_cal}' THEN PERIOD_QUARTER
				 WHEN '2'='${dim_cal}' THEN PERIOD_MONTH
				 WHEN '3'='${dim_cal}' THEN WEEK_NBR_IN_MONTH END AS DIM_CALIBER_S --口径2
FROM DIM_PERIOD --时间维度
),--时间口径维度

DIM_DATES AS(
/*SELECT 
		CALIBER ,
		CASE WHEN '1'='${dim_cal}' THEN substr(CALIBER,1,4) 
				 WHEN '2'='${dim_cal}' THEN substr(date1.date1,1,4) ||'Q0'||substr(CALIBER,1,1) 
				 WHEN '3'='${dim_cal}' THEN substr(date1.date1,1,4) ||'M'||substr(CALIBER,1,2) 
		END as Statistical_time ,ORDER_CALIBER
FROM DIM_DATEKJ, date1
UNION ALL
*/
SELECT 
		b.DIM_CALIBER_S as CALIBER,
		CASE WHEN '1'='${dim_cal}' THEN substr(date1,1,4) ||'Q0'||substr(b.DIM_CALIBER_S,1,1) 
				 WHEN '2'='${dim_cal}' THEN substr(date1,1,4) ||'M'||substr(b.DIM_CALIBER_S,1,2) 
				 WHEN '3'='${dim_cal}' THEN substr(date1,1,4) ||'M'||substr(date1,5,2)||'W'||substr(b.DIM_CALIBER_S,2,1) 
		END as Statistical_time , 
		CASE WHEN '1'='${dim_cal}' THEN substr(date1,1,4) ||'Q0'||substr(b.DIM_CALIBER_S,1,1) 
				 WHEN '2'='${dim_cal}' THEN substr(date1,1,4) ||'M'||substr(b.DIM_CALIBER_S,1,2) 
				 WHEN '3'='${dim_cal}' THEN substr(date1,1,4) ||'M'||substr(date1,5,2)||'W'||substr(b.DIM_CALIBER_S,2,1) 
		END as ORDER_CALIBER
FROM DIM_DATEKJ a
LEFT JOIN DIM_DATEMX b
ON a.CALIBER=b.DIM_CALIBER
left join date1
on 1=1
), --整理时间维度

DATE_INDEX AS (
SELECT INDEX_ID,INDEX_NAME,ORDER_KEY FROM DIM_INDEX 
WHERE INDEX_id='b104c15725554e21a985eb28a31eaf61'
),--指标维度

DIM_ORF_HX AS(
SELECT ORG_ID,ORG_NAME FROM DIM_ORG 
where org_id = 'E0A3D386-D5C8-FB22-18DE-4424D49363B2'
)--产业新城维度



SELECT a.CALIBER, --时间口径 
A.ORDER_CALIBER,
		a.STATISTICAL_TIME, --时间口径
		--c.ORG_NAME, --组织机构名称
		--c.ORG_ID, --组织机构id
		d.INDEX_NAME, --指标名称
		d.INDEX_ID, --指标id
		d.ORDER_KEY, --指标排序
		round(sum(NVL(e.TARGET_VALUE, 0))) TARGET_VALUE,
		round(sum(NVL(e.ACTUAL_VALUE, 0))) ACTUAL_VALUE,
		CASE WHEN sum(nvl(e.TARGET_VALUE,0))=0 THEN 0 ELSE sum(nvl(e.ACTUAL_VALUE,0))/sum(NVL(e.TARGET_VALUE, 0)) END as VALUE_lv
FROM DIM_DATES a --时间维度
LEFT JOIN DIM_ORF_HX c --组织维度
ON 1=1
LEFT JOIN DATE_INDEX d --指标维度
ON 1=1
LEFT JOIN DM_MCL_ACCT e --经营指标结果表
ON a.Statistical_time=e.PERIOD_TYPE_ID
AND c.ORG_ID=e.ORG_ID
AND d.INDEX_ID=e.INDEX_ID
group by a.CALIBER, --时间口径
A.ORDER_CALIBER,
		a.STATISTICAL_TIME, --时间口径
		--c.ORG_NAME, --组织机构名称
		--c.ORG_ID, --组织机构id
		d.INDEX_NAME, --指标名称
		d.INDEX_ID, --指标id
		d.ORDER_KEY
ORDER BY A.ORDER_CALIBER, d.ORDER_KEY]]></Query>
</TableData>
<TableData name="ZBPF_PX" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="JG"/>
<O>
<![CDATA[事业部]]></O>
</Parameter>
<Parameter>
<Attributes name="dim_cal"/>
<O>
<![CDATA[1]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[oracle_test]]></DatabaseName>
</Connection>
<Query>
<![CDATA[--排名 实际
WITH date1 as(
select data_date date1 from dm_mcl_acct where rownum = 1
)

select t1.*, t1.org_sname || '-' || t1.actual_value orgsum
  from (select org_sname org_name, index_name,
               org_sname,
               b.order_key,
               round(nvl(a.actual_value, 0)) actual_value,
               round(nvl(a.target_value, 0)) target_value,
               row_number() over(order by round(nvl(a.actual_value, 0)) desc, b.order_key) xh
          from dm_mcl_acct a, date1,
               (select *
                  from (select *
                          from dim_org o
                         start with o.org_id = 'E0A3D386-D5C8-FB22-18DE-4424D49363B2'
                        connect by prior o.org_id = o.father_id)
                 where org_type = '${JG}'
                   and org_classify_id = '产业新城（国内）') b,
               dim_index c
         where 1 = 1
           and a.org_id = b.org_id
           and a.index_id = c.index_id
           and a.period_type_id = case '${dim_cal}'
         when '1' then
          substr(date1.date1, 1, 4)
         when '2' then
          substr(date1.date1, 1, 4) || 'Q0' || to_char(to_date(date1.date1, 'YYYYMMDD'), 'Q')
         when '3' then
          substr(date1.date1, 1, 4) || 'M' || to_char(to_date(date1.date1, 'YYYYMMDD'), 'MM')
       end
           and c.index_id = 'b104c15725554e21a985eb28a31eaf61'
        
        ) t1
 where 1 = 1
   and xh < 11
 order by xh desc, order_key
]]></Query>
</TableData>
<TableData name="ZBPF_PX2" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="JG"/>
<O>
<![CDATA[事业部]]></O>
</Parameter>
<Parameter>
<Attributes name="dim_cal"/>
<O>
<![CDATA[1]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[oracle_test]]></DatabaseName>
</Connection>
<Query>
<![CDATA[--排名 完成率
WITH date1 as(
select data_date date1 from dm_mcl_acct where rownum = 1
)
select t1.*, t1.org_sname || '-' || t1.lv_zhi orgsum
  from (select org_sname org_name, index_name,
               org_sname,
               b.order_key,
               case
                 when nvl(a.target_value, 0) = 0 then
                  0
                 else
                  nvl(a.actual_value, 0) / nvl(a.target_value, 0)
               end lv_zhi,
               
               row_number() over(order by case
         when nvl(a.target_value, 0) = 0 then
          0
         else
          nvl(a.actual_value, 0) / nvl(a.target_value, 0)
       end desc, b.order_key) xh
          from dm_mcl_acct a, date1,
               (select *
                  from (select *
                          from dim_org o
                         start with o.org_id = 'E0A3D386-D5C8-FB22-18DE-4424D49363B2'
                        connect by prior o.org_id = o.father_id)
                 where org_type = '${JG}'
                   and org_classify_id = '产业新城（国内）') b,
               dim_index c
         where 1 = 1
           and a.org_id = b.org_id
           and a.index_id = c.index_id
           and a.period_type_id = case '${dim_cal}'
         when '1' then
          substr(date1.date1, 1, 4)
         when '2' then
          substr(date1.date1, 1, 4) || 'Q0' || to_char(to_date(date1.date1, 'YYYYMMDD'), 'Q')
         when '3' then
          substr(date1.date1, 1, 4) || 'M' || to_char(to_date(date1.date1, 'YYYYMMDD'), 'MM')
       end
           and c.index_id = 'b104c15725554e21a985eb28a31eaf61'
        
        ) t1
 where 1 = 1
   and xh < 11
 order by xh desc, order_key
]]></Query>
</TableData>
<TableData name="JDYG" class="com.fr.data.impl.DBTableData">
<Parameters/>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[oracle_test]]></DatabaseName>
</Connection>
<Query>
<![CDATA[--季度预估
WITH DATE1 AS
 (select data_date date1 from dm_mcl_acct where rownum = 1)

select '目标' type1, sum(nvl(a.target_value, 0)) value1

  from dm_mcl_acct a, dim_index ind, dim_org org, date1
 where 1 = 1
   and a.index_id = ind.index_id
   and a.org_id = org.org_id
   and ind.index_id = 'b104c15725554e21a985eb28a31eaf61'
   and org.org_id = 'E0A3D386-D5C8-FB22-18DE-4424D49363B2'
   and a.period_type_id = substr(date1.date1, 1, 4) || 'Q0' ||
       to_char(to_date(date1.date1, 'YYYYMMDD'), 'Q')

union all

select '实际' type1, sum(nvl(a.actual_value, 0)) value1

  from dm_mcl_acct a, dim_index ind, dim_org org, date1
 where 1 = 1 and a.index_id = ind.index_id and a.org_id = org.org_id and
 ind.index_id = 'b104c15725554e21a985eb28a31eaf61' 
 and org.org_id = 'E0A3D386-D5C8-FB22-18DE-4424D49363B2' and
 a.period_type_id = substr(date1.date1, 1, 4) || 'Q0' ||
 to_char(to_date(date1.date1, 'YYYYMMDD'), 'Q')

union all

select '预估完成' type1,
       decode(sum(nvl(a.forecate_value, 0)),
              0,
              sum(nvl(a.target_value, 0)),
              sum(nvl(a.forecate_value, 0))) value1

  from dm_mcl_acct a, dim_index ind, dim_org org, date1
 where 1 = 1 and a.index_id = ind.index_id and a.org_id = org.org_id and
 ind.index_id = 'b104c15725554e21a985eb28a31eaf61' 
 and org.org_id = 'E0A3D386-D5C8-FB22-18DE-4424D49363B2' and
 a.period_type_id = substr(date1.date1, 1, 4) || 'Q0' ||
 to_char(to_date(date1.date1, 'YYYYMMDD'), 'Q')
]]></Query>
</TableData>
<TableData name="ZBPF_HJWB" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="dim_cal"/>
<O>
<![CDATA[1]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[oracle_test]]></DatabaseName>
</Connection>
<Query>
<![CDATA[with date1 as (
select data_date date1 from dm_mcl_acct where rownum = 1
),
t as (
select b.org_classify, sum(nvl(a.actual_value, 0)) actual_value
  from dm_mcl_acct a,
       (select *
          from (select *
                  from dim_org o
                 start with o.org_id = 'E0A3D386-D5C8-FB22-18DE-4424D49363B2'
                connect by prior o.org_id = o.father_id)
         where 1 = 1
           and org_type = '事业部'
           and org_classify in ('环京', '外埠')) b,
       dim_index c, date1

 where 1 = 1
   and a.org_id = b.org_id
   and a.index_id = c.index_id
   and c.index_id = 'b104c15725554e21a985eb28a31eaf61'
   and a.period_type_id = case '${dim_cal}'
         when '1' then
          substr(date1.date1, 1, 4)
         when '2' then
          substr(date1.date1, 1, 4) || 'Q0' || to_char(to_date(date1.date1, 'YYYYMMDD'), 'Q')
         when '3' then
          substr(date1.date1, 1, 4) || 'M' || to_char(to_date(date1.date1, 'YYYYMMDD'), 'MM')
       end

 group by b.org_classify
)
SELECT * FROM  T 
WHERE CASE WHEN  (select SUM(actual_value) from t)=0  then 0 else 1 end !=0  
]]></Query>
</TableData>
<TableData name="ds2_finish" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="dim_cal"/>
<O>
<![CDATA[1]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[oracle_test]]></DatabaseName>
</Connection>
<Query>
<![CDATA[WITH date1 as(
select data_date date1 from dm_mcl_acct where rownum = 1
)

select round(nvl(a.target_value, 0)) target_value,
       round(nvl(a.actual_value, 0)) actual_value,
       case
         when nvl(a.target_value, 0) = 0 then
          0
         else
          round(nvl(a.actual_value, 0) / nvl(a.target_value, 0), 2)
       end rate_value
       
  from dm_mcl_acct a, dim_org b, dim_index c, date1
 where 1 = 1
   and a.org_id = b.org_id
   and a.index_id = c.index_id
   and c.index_id = 'b104c15725554e21a985eb28a31eaf61'
   and b.org_id = 'E0A3D386-D5C8-FB22-18DE-4424D49363B2'
   
   and a.period_type_id = case '${dim_cal}'
         when '1' then
          substr(date1.date1, 1, 4)
         when '2' then
          substr(date1.date1, 1, 4) || 'Q0' || to_char(to_date(date1.date1, 'YYYYMMDD'), 'Q')
         when '3' then
          substr(date1.date1, 1, 4) || 'M' || to_char(to_date(date1.date1, 'YYYYMMDD'), 'MM')
       end
]]></Query>
</TableData>
<TableData name="ZBPF_PX3" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="JG"/>
<O>
<![CDATA[事业部]]></O>
</Parameter>
<Parameter>
<Attributes name="dim_cal"/>
<O>
<![CDATA[1]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[oracle_test]]></DatabaseName>
</Connection>
<Query>
<![CDATA[--排名 实际
WITH date1 as(
select data_date date1 from dm_mcl_acct where rownum = 1
)

select t1.*, t1.org_sname || '-' || t1.target_value orgsum
  from (select org_sname org_name, index_name,
               org_sname,
               b.order_key,
               --round(nvl(a.actual_value, 0)) actual_value,
               round(nvl(a.target_value, 0)) target_value,
               
               row_number() over(order by round(nvl(a.target_value, 0)) desc, b.order_key) xh
          from dm_mcl_acct a, date1,
               (select *
                  from (select *
                          from dim_org o
                         start with o.org_id = 'E0A3D386-D5C8-FB22-18DE-4424D49363B2'
                        connect by prior o.org_id = o.father_id)
                 where org_type = '${JG}'
                   and org_classify_id = '产业新城（国内）') b,
               dim_index c
         where 1 = 1
           and a.org_id = b.org_id
           and a.index_id = c.index_id
           and a.period_type_id = case '${dim_cal}'
         when '1' then
          substr(date1.date1, 1, 4)
         when '2' then
          substr(date1.date1, 1, 4) || 'Q0' || to_char(to_date(date1.date1, 'YYYYMMDD'), 'Q')
         when '3' then
          substr(date1.date1, 1, 4) || 'M' || to_char(to_date(date1.date1, 'YYYYMMDD'), 'MM')
       end
           and c.index_id = 'b104c15725554e21a985eb28a31eaf61'
        
        ) t1
 where 1 = 1
   and xh < 11
 order by xh desc, order_key
]]></Query>
</TableData>
<TableData name="ds1" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="dim_cal"/>
<O>
<![CDATA[1]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[oracle_test]]></DatabaseName>
</Connection>
<Query>
<![CDATA[with date1 as (
select data_date date1 from dm_mcl_acct where rownum = 1
),
t as (
select b.org_classify, sum(nvl(a.actual_value, 0)) actual_value
  from dm_mcl_acct a,
       (select *
          from (select *
                  from dim_org o
                 start with o.org_id = 'E0A3D386-D5C8-FB22-18DE-4424D49363B2'
                connect by prior o.org_id = o.father_id)
         where 1 = 1
           and org_type = '事业部'
           and org_classify in ('环京', '外埠')) b,
       dim_index c, date1

 where 1 = 1
   and a.org_id = b.org_id
   and a.index_id = c.index_id
   and c.index_id = 'b104c15725554e21a985eb28a31eaf61'
   and a.period_type_id = case '${dim_cal}'
         when '1' then
          substr(date1.date1, 1, 4)
         when '2' then
          substr(date1.date1, 1, 4) || 'Q0' || to_char(to_date(date1.date1, 'YYYYMMDD'), 'Q')
         when '3' then
          substr(date1.date1, 1, 4) || 'M' || to_char(to_date(date1.date1, 'YYYYMMDD'), 'MM')
       end

 group by b.org_classify
)
SELECT * FROM  T 
WHERE CASE WHEN  (select SUM(actual_value) from t)=0  then 0 else 1 end !=0  
]]></Query>
</TableData>
</TableDataMap>
<FormMobileAttr>
<FormMobileAttr refresh="false" isUseHTML="false" isMobileOnly="false" isAdaptivePropertyAutoMatch="false"/>
</FormMobileAttr>
<Parameters>
<Parameter>
<Attributes name="dim_cal"/>
<O>
<![CDATA[1]]></O>
</Parameter>
<Parameter>
<Attributes name="JG"/>
<O>
<![CDATA[事业部]]></O>
</Parameter>
<Parameter>
<Attributes name="px"/>
<O>
<![CDATA[实际]]></O>
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
<Center class="com.fr.form.ui.container.WFitLayout">
<Listener event="afterinit">
<JavaScript class="com.fr.js.Commit2DBJavaScript">
<Parameters/>
<Attributes dsName="oracle_test" name="提交1"/>
<DMLConfig class="com.fr.write.config.IntelliDMLConfig">
<Table schema="BASS_DW" name="JYGK_LOG_RECORD"/>
<ColumnConfig name="ID" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=UUID()]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="NAME_ID" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=value("loguser",4,1)]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="SYS_NAME" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$fr_username]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="NAME" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=value("loguser",3,1)]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="SUOSHUBUMEN" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=value("loguser",7,1)]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="ZHIWU" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=value("loguser",9,1)]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="BAOBIAOMOKUAI" isKey="false" skipUnmodified="false">
<O>
<![CDATA[经营管控]]></O>
</ColumnConfig>
<ColumnConfig name="FANGWENLUJING" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=formletName]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="FANGWENWENJIAN" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=RIGHT(formletName,INARRAY("/",REVERSEARRAY(SPLIT(formletName,"")))-1)]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="WENJIANMINGCHENG" isKey="false" skipUnmodified="false">
<O>
<![CDATA[资源类-产业供地]]></O>
</ColumnConfig>
<ColumnConfig name="CANSHUMING" isKey="false" skipUnmodified="false">
<O>
<![CDATA[dim_cal;JG;px]]></O>
</ColumnConfig>
<ColumnConfig name="CANSHU" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(len($dim_cal)=0 ,"",switch($dim_cal, "1", "当年", "2", "当季", "3", "当月")+";")+
if(len($JG)=0 ,"",$JG+";")+
if(len($px)=0 ,"",$px+";")]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="CANSHUMINGYUCANSHU" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(len($dim_cal)=0,"","dim_cal:"+switch($dim_cal, "1", "当年", "2", "当季", "3", "当月"))+"; "+
if(len($JG)=0,"","JG:"+$JG)+"; "+
if(len($px)=0,"","px:"+$px)+";"]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="TIME" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=NOW()]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="DAOCHU" isKey="false" skipUnmodified="false">
<O>
<![CDATA[否]]></O>
</ColumnConfig>
<ColumnConfig name="SHIFOUDIANJILIANJIE" isKey="false" skipUnmodified="false">
<O>
<![CDATA[否]]></O>
</ColumnConfig>
<ColumnConfig name="LIANJIECANSHUMING" isKey="false" skipUnmodified="false">
<O>
<![CDATA[]]></O>
</ColumnConfig>
<ColumnConfig name="LIANJIECANSHU" isKey="false" skipUnmodified="false">
<O>
<![CDATA[]]></O>
</ColumnConfig>
<ColumnConfig name="LIANJIEMINGYUCANSHU" isKey="false" skipUnmodified="false">
<O>
<![CDATA[]]></O>
</ColumnConfig>
<ColumnConfig name="DATA_DATE" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=TODAY()]]></Attributes>
</O>
</ColumnConfig>
<Condition class="com.fr.data.condition.ListCondition"/>
</DMLConfig>
</JavaScript>
</Listener>
<Listener event="click">
<JavaScript class="com.fr.js.Commit2DBJavaScript">
<Parameters/>
<Attributes dsName="oracle_test" name="提交1"/>
<DMLConfig class="com.fr.write.config.IntelliDMLConfig">
<Table schema="BASS_DW" name="JYGK_LOG_RECORD"/>
<ColumnConfig name="ID" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=UUID()]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="NAME_ID" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=value("loguser",4,1)]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="SYS_NAME" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$fr_username]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="NAME" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=value("loguser",3,1)]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="SUOSHUBUMEN" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=value("loguser",7,1)]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="ZHIWU" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=value("loguser",9,1)]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="BAOBIAOMOKUAI" isKey="false" skipUnmodified="false">
<O>
<![CDATA[经营管控]]></O>
</ColumnConfig>
<ColumnConfig name="FANGWENLUJING" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=formletName]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="FANGWENWENJIAN" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=RIGHT(formletName,INARRAY("/",REVERSEARRAY(SPLIT(formletName,"")))-1)]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="WENJIANMINGCHENG" isKey="false" skipUnmodified="false">
<O>
<![CDATA[资源类-产业供地]]></O>
</ColumnConfig>
<ColumnConfig name="CANSHUMING" isKey="false" skipUnmodified="false">
<O>
<![CDATA[dim_cal;JG;px]]></O>
</ColumnConfig>
<ColumnConfig name="CANSHU" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(len($dim_cal)=0 ,"",switch($dim_cal, "1", "当年", "2", "当季", "3", "当月")+";")+
if(len($JG)=0 ,"",$JG+";")+
if(len($px)=0 ,"",$px+";")]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="CANSHUMINGYUCANSHU" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(len($dim_cal)=0,"","dim_cal:"+switch($dim_cal, "1", "当年", "2", "当季", "3", "当月"))+"; "+
if(len($JG)=0,"","JG:"+$JG)+"; "+
if(len($px)=0,"","px:"+$px)+";"]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="TIME" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=NOW()]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="DAOCHU" isKey="false" skipUnmodified="false">
<O>
<![CDATA[否]]></O>
</ColumnConfig>
<ColumnConfig name="SHIFOUDIANJILIANJIE" isKey="false" skipUnmodified="false">
<O>
<![CDATA[否]]></O>
</ColumnConfig>
<ColumnConfig name="LIANJIECANSHUMING" isKey="false" skipUnmodified="false">
<O>
<![CDATA[]]></O>
</ColumnConfig>
<ColumnConfig name="LIANJIECANSHU" isKey="false" skipUnmodified="false">
<O>
<![CDATA[]]></O>
</ColumnConfig>
<ColumnConfig name="LIANJIEMINGYUCANSHU" isKey="false" skipUnmodified="false">
<O>
<![CDATA[]]></O>
</ColumnConfig>
<ColumnConfig name="DATA_DATE" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=TODAY()]]></Attributes>
</O>
</ColumnConfig>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[if( $dim_cal = $dim_cal99  , 1<0 , 0<1 ) ]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[if( $JG = $JG99  , 1<0 , 0<1 ) ]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[if( $px = $px99  , 1<0 , 0<1 )]]></Formula>
</Condition>
</JoinCondition>
</Condition>
</DMLConfig>
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="dim_cal"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$dim_cal]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="JG"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$JG]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="px"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$px]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[this.options.form.getWidgetByName("dim_cal99").setValue(dim_cal);
this.options.form.getWidgetByName("JG99").setValue(JG);
this.options.form.getWidgetByName("px99").setValue(px);]]></Content>
</JavaScript>
</JavaScript>
</Listener>
<WidgetName name="body"/>
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
<Background name="ColorBackground" color="-16378570"/>
<Alpha alpha="1.0"/>
</Border>
<Background name="ColorBackground" color="-16378570"/>
<LCAttr vgap="0" hgap="0" compInterval="0"/>
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
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="tiaozhuan1_c_c_c_c_c_c_c"/>
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
<WidgetName name="tiaozhuan1_c_c_c_c_c_c_c"/>
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
<![CDATA[720000,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[1008000,2880000,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O t="Image">
<IM>
<![CDATA[!D`a#reXHH7h#eD$31&+%7s)Y;?-[s%KHJ/&I8R@!!)E-SY#l^!>\6p5u`*!Q-m?>!b!(hnV
]AkhK5>LG8.#U<BFu4&R\K?K%iPgDEY0ZjTcp=q,/M7#TY[MB.0j'l<,cPb&7&Kk)rc0.n3&`
ATBBs6EVKFgo6GeUA[U;&4MqWuK/RP4dc.*Y#mrXKW8JV]A?;SmiUl$jbCLQE;3f%5!^r?Q7K
>H#u1HN,*3d(t`FMWD$TTdq1:K5eN%lrFj"oiVDF#WGiZ%NXm,M/R(UTF7Oon1)^CfcH<M,3
b`NWEbE12`@`*@!tJ?GRK1rntVEi!h_u?3_!In-cW-6$;<=;GsEgY'RpqXSRgWfYf8rAE"DN
Wc:`aWSfQ&\AQ!Na=:&Oe\B!>MA!Z"f>!NkNm[V*Hc&,PEY^ucz8OZBBY!QNJ~
]]></IM>
</O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="JavaScript脚本1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[window.parent.parent.FS.tabPane.addItem({title:"产业供地排名详情",src:"${servletURL}?reportlet=/ThreeLevelPage/OPE_FIN_INDUSTRY_SUPPLY_THREE_LEVE.cpt&op=view&is_show=N"})]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$project='其他']]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="1" r="0" s="1">
<O>
<![CDATA[查看详情]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="JavaScript脚本1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[window.parent.parent.FS.tabPane.addItem({title:"产业供地排名详情",src:"${servletURL}?reportlet=/ThreeLevelPage/OPE_FIN_INDUSTRY_SUPPLY_THREE_LEVE.cpt&op=view&is_show=N"})]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$project='其他']]></Formula>
</Condition>
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
<FRFont name="SimSun" style="0" size="72" foreground="-16776961" underline="1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="2" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72" foreground="-16736001"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="250" height="150"/>
</Widget>
<body class="com.fr.form.ui.ElementCaseEditor">
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
<![CDATA[648000,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[1008000,5067300,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O t="Image">
<IM>
<![CDATA[!D`a#reXHH7h#eD$31&+%7s)Y;?-[s%KHJ/&I8R@!!)E-SY#l^!>\6p5u`*!Q-m?>!b!(hnV
]AkhK5>LG8.#U<BFu4&R\K?K%iPgDEY0ZjTcp=q,/M7#TY[MB.0j'l<,cPb&7&Kk)rc0.n3&`
ATBBs6EVKFgo6GeUA[U;&4MqWuK/RP4dc.*Y#mrXKW8JV]A?;SmiUl$jbCLQE;3f%5!^r?Q7K
>H#u1HN,*3d(t`FMWD$TTdq1:K5eN%lrFj"oiVDF#WGiZ%NXm,M/R(UTF7Oon1)^CfcH<M,3
b`NWEbE12`@`*@!tJ?GRK1rntVEi!h_u?3_!In-cW-6$;<=;GsEgY'RpqXSRgWfYf8rAE"DN
Wc:`aWSfQ&\AQ!Na=:&Oe\B!>MA!Z"f>!NkNm[V*Hc&,PEY^ucz8OZBBY!QNJ~
]]></IM>
</O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="JavaScript脚本1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[window.parent.FS.tabPane.addItem({title:"查看详情",src:"${servletURL}?reportlet=/ThreeLevelPage/OPE_FIN_CASH_FLOW_2.cpt&op=view"})]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<Expand/>
</C>
<C c="1" r="0" s="1">
<O>
<![CDATA[查看详情]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="JavaScript脚本2">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[window.parent.FS.tabPane.addItem({title:"查看详情",src:"${servletURL}?reportlet=/ThreeLevelPage/OPE_FIN_CASH_FLOW_2.cpt&op=view"})]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
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
<FRFont name="SimSun" style="0" size="72" foreground="-16776961" underline="1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="2" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72" foreground="-16735489"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</body>
</InnerWidget>
<BoundsAttr x="800" y="33" width="59" height="24"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="tiaozhuan1_c_c_c_c_c_c_c_c"/>
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
<WidgetName name="tiaozhuan1_c_c_c_c_c_c_c_c"/>
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
<![CDATA[720000,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[1008000,2880000,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O t="Image">
<IM>
<![CDATA[!D`a#reXHH7h#eD$31&+%7s)Y;?-[s%KHJ/&I8R@!!)E-SY#l^!>\6p5u`*!Q-m?>!b!(hnV
]AkhK5>LG8.#U<BFu4&R\K?K%iPgDEY0ZjTcp=q,/M7#TY[MB.0j'l<,cPb&7&Kk)rc0.n3&`
ATBBs6EVKFgo6GeUA[U;&4MqWuK/RP4dc.*Y#mrXKW8JV]A?;SmiUl$jbCLQE;3f%5!^r?Q7K
>H#u1HN,*3d(t`FMWD$TTdq1:K5eN%lrFj"oiVDF#WGiZ%NXm,M/R(UTF7Oon1)^CfcH<M,3
b`NWEbE12`@`*@!tJ?GRK1rntVEi!h_u?3_!In-cW-6$;<=;GsEgY'RpqXSRgWfYf8rAE"DN
Wc:`aWSfQ&\AQ!Na=:&Oe\B!>MA!Z"f>!NkNm[V*Hc&,PEY^ucz8OZBBY!QNJ~
]]></IM>
</O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="JavaScript脚本1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[window.parent.parent.FS.tabPane.addItem({title:"产业供地详情",src:"${servletURL}?reportlet=/ThreeLevelPage/OPE_FIN_INDUSTRY_SUPPLY_THREE.cpt&op=view&is_show=Y"})]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$project='其他']]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="1" r="0" s="1">
<O>
<![CDATA[查看详情]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="JavaScript脚本1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[window.parent.parent.FS.tabPane.addItem({title:"产业供地详情",src:"${servletURL}?reportlet=/ThreeLevelPage/OPE_FIN_INDUSTRY_SUPPLY_THREE.cpt&op=view&is_show=Y"})]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$project='其他']]></Formula>
</Condition>
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
<FRFont name="SimSun" style="0" size="72" foreground="-16776961" underline="1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72" foreground="-16736001"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="250" height="150"/>
</Widget>
<body class="com.fr.form.ui.ElementCaseEditor">
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
<![CDATA[648000,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[1008000,5067300,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O t="Image">
<IM>
<![CDATA[!D`a#reXHH7h#eD$31&+%7s)Y;?-[s%KHJ/&I8R@!!)E-SY#l^!>\6p5u`*!Q-m?>!b!(hnV
]AkhK5>LG8.#U<BFu4&R\K?K%iPgDEY0ZjTcp=q,/M7#TY[MB.0j'l<,cPb&7&Kk)rc0.n3&`
ATBBs6EVKFgo6GeUA[U;&4MqWuK/RP4dc.*Y#mrXKW8JV]A?;SmiUl$jbCLQE;3f%5!^r?Q7K
>H#u1HN,*3d(t`FMWD$TTdq1:K5eN%lrFj"oiVDF#WGiZ%NXm,M/R(UTF7Oon1)^CfcH<M,3
b`NWEbE12`@`*@!tJ?GRK1rntVEi!h_u?3_!In-cW-6$;<=;GsEgY'RpqXSRgWfYf8rAE"DN
Wc:`aWSfQ&\AQ!Na=:&Oe\B!>MA!Z"f>!NkNm[V*Hc&,PEY^ucz8OZBBY!QNJ~
]]></IM>
</O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="JavaScript脚本1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[window.parent.FS.tabPane.addItem({title:"查看详情",src:"${servletURL}?reportlet=/ThreeLevelPage/OPE_FIN_CASH_FLOW_2.cpt&op=view"})]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<Expand/>
</C>
<C c="1" r="0" s="1">
<O>
<![CDATA[查看详情]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="JavaScript脚本2">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[window.parent.FS.tabPane.addItem({title:"查看详情",src:"${servletURL}?reportlet=/ThreeLevelPage/OPE_FIN_CASH_FLOW_2.cpt&op=view"})]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
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
<FRFont name="SimSun" style="0" size="72" foreground="-16776961" underline="1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="2" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72" foreground="-16735489"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</body>
</InnerWidget>
<BoundsAttr x="226" y="264" width="59" height="24"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="tiaozhuan1_c_c_c_c_c_c"/>
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
<WidgetName name="tiaozhuan1_c_c_c_c_c_c"/>
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
<![CDATA[720000,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[1008000,2880000,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O t="Image">
<IM>
<![CDATA[!D`a#reXHH7h#eD$31&+%7s)Y;?-[s%KHJ/&I8R@!!)E-SY#l^!>\6p5u`*!Q-m?>!b!(hnV
]AkhK5>LG8.#U<BFu4&R\K?K%iPgDEY0ZjTcp=q,/M7#TY[MB.0j'l<,cPb&7&Kk)rc0.n3&`
ATBBs6EVKFgo6GeUA[U;&4MqWuK/RP4dc.*Y#mrXKW8JV]A?;SmiUl$jbCLQE;3f%5!^r?Q7K
>H#u1HN,*3d(t`FMWD$TTdq1:K5eN%lrFj"oiVDF#WGiZ%NXm,M/R(UTF7Oon1)^CfcH<M,3
b`NWEbE12`@`*@!tJ?GRK1rntVEi!h_u?3_!In-cW-6$;<=;GsEgY'RpqXSRgWfYf8rAE"DN
Wc:`aWSfQ&\AQ!Na=:&Oe\B!>MA!Z"f>!NkNm[V*Hc&,PEY^ucz8OZBBY!QNJ~
]]></IM>
</O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="JavaScript脚本1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[window.parent.parent.FS.tabPane.addItem({title:"产业供地详情",src:"${servletURL}?reportlet=/ThreeLevelPage/OPE_FIN_INDUSTRY_SUPPLY_THREE.cpt&op=view&is_show=N"})]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$project='其他']]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="1" r="0" s="1">
<O>
<![CDATA[查看详情]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="JavaScript脚本1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[window.parent.parent.FS.tabPane.addItem({title:"产业供地详情",src:"${servletURL}?reportlet=/ThreeLevelPage/OPE_FIN_INDUSTRY_SUPPLY_THREE.cpt&op=view&is_show=N"})]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$project='其他']]></Formula>
</Condition>
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
<FRFont name="SimSun" style="0" size="72" foreground="-16079617"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72" foreground="-16079617"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="250" height="150"/>
</Widget>
<body class="com.fr.form.ui.ElementCaseEditor">
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
<![CDATA[648000,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[1008000,5067300,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O t="Image">
<IM>
<![CDATA[!D`a#reXHH7h#eD$31&+%7s)Y;?-[s%KHJ/&I8R@!!)E-SY#l^!>\6p5u`*!Q-m?>!b!(hnV
]AkhK5>LG8.#U<BFu4&R\K?K%iPgDEY0ZjTcp=q,/M7#TY[MB.0j'l<,cPb&7&Kk)rc0.n3&`
ATBBs6EVKFgo6GeUA[U;&4MqWuK/RP4dc.*Y#mrXKW8JV]A?;SmiUl$jbCLQE;3f%5!^r?Q7K
>H#u1HN,*3d(t`FMWD$TTdq1:K5eN%lrFj"oiVDF#WGiZ%NXm,M/R(UTF7Oon1)^CfcH<M,3
b`NWEbE12`@`*@!tJ?GRK1rntVEi!h_u?3_!In-cW-6$;<=;GsEgY'RpqXSRgWfYf8rAE"DN
Wc:`aWSfQ&\AQ!Na=:&Oe\B!>MA!Z"f>!NkNm[V*Hc&,PEY^ucz8OZBBY!QNJ~
]]></IM>
</O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="JavaScript脚本1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[window.parent.FS.tabPane.addItem({title:"查看详情",src:"${servletURL}?reportlet=/ThreeLevelPage/OPE_FIN_CASH_FLOW_2.cpt&op=view"})]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<Expand/>
</C>
<C c="1" r="0" s="1">
<O>
<![CDATA[查看详情]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="JavaScript脚本2">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[window.parent.FS.tabPane.addItem({title:"查看详情",src:"${servletURL}?reportlet=/ThreeLevelPage/OPE_FIN_CASH_FLOW_2.cpt&op=view"})]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
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
<FRFont name="SimSun" style="0" size="72" foreground="-16776961" underline="1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="2" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72" foreground="-16735489"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</body>
</InnerWidget>
<BoundsAttr x="506" y="33" width="59" height="24"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TextEditor">
<WidgetName name="JG99"/>
<WidgetAttr invisible="true" description="">
<PrivilegeControl/>
</WidgetAttr>
<TextAttr/>
<Reg class="com.fr.form.ui.reg.NoneReg"/>
<widgetValue>
<O>
<![CDATA[事业部]]></O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="282" y="29" width="37" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TextEditor">
<WidgetName name="px99"/>
<WidgetAttr invisible="true" description="">
<PrivilegeControl/>
</WidgetAttr>
<TextAttr/>
<Reg class="com.fr.form.ui.reg.NoneReg"/>
<widgetValue>
<O>
<![CDATA[实际]]></O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="334" y="29" width="32" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TextEditor">
<WidgetName name="dim_cal99"/>
<WidgetAttr invisible="true" description="">
<PrivilegeControl/>
</WidgetAttr>
<TextAttr/>
<Reg class="com.fr.form.ui.reg.NoneReg"/>
<widgetValue>
<O>
<![CDATA[1]]></O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="246" y="29" width="21" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report1_c_c_c_c"/>
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
<WidgetName name="report1_c_c_c_c"/>
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
<![CDATA[216000,1008000,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2880000,144000,2880000,144000,2880000,144000,2880000,144000,2880000,144000,2880000,2880000,288000,2880000,288000,2880000,288000,2880000,288000,2880000,288000,2880000,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="1" s="0">
<O>
<![CDATA[拓展布局]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="网络报表1">
<JavaScript class="com.fr.js.ReportletHyperlink">
<JavaScript class="com.fr.js.ReportletHyperlink">
<Parameters/>
<TargetFrame>
<![CDATA[_self]]></TargetFrame>
<Features width="600" height="400"/>
<ReportletName showPI="true">
<![CDATA[/HX_JYFX/RESOURCES/OPE_FIN_EXPAND_LAYOUT.frm]]></ReportletName>
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
<![CDATA[if(len(value("hx_aut", 1, 1)) = 0, 1,if(StringFind(value("hx_aut",1,1),"no")<>-1,0,
if(StringFind(value("hx_aut", 1, 1), "jyzy001") <> -1, 1, 0)) ) = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="1" r="1" s="1">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[if(len(value("hx_aut", 1, 1)) = 0, 1,if(StringFind(value("hx_aut",1,1),"no")<>-1,0,
if(StringFind(value("hx_aut", 1, 1), "jyzy001") <> -1, 1, 0)) ) = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="2" r="1" s="0">
<O>
<![CDATA[指标批复]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="网络报表1">
<JavaScript class="com.fr.js.ReportletHyperlink">
<JavaScript class="com.fr.js.ReportletHyperlink">
<Parameters/>
<TargetFrame>
<![CDATA[_self]]></TargetFrame>
<Features width="600" height="400"/>
<ReportletName showPI="true">
<![CDATA[/HX_JYFX/RESOURCES/OPE_FIN_INDEX_APPROVAL.frm]]></ReportletName>
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
<![CDATA[if(len(value("hx_aut", 1, 1)) = 0, 1,if(StringFind(value("hx_aut",1,1),"no")<>-1,0,
if(StringFind(value("hx_aut", 1, 1), "jyzy002") <> -1, 1, 0)) ) = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="1" s="2">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[if(len(value("hx_aut", 1, 1)) = 0, 1,if(StringFind(value("hx_aut",1,1),"no")<>-1,0,
if(StringFind(value("hx_aut", 1, 1), "jyzy002") <> -1, 1, 0)) ) = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="4" r="1" s="0">
<O>
<![CDATA[住宅供地]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="网络报表1">
<JavaScript class="com.fr.js.ReportletHyperlink">
<JavaScript class="com.fr.js.ReportletHyperlink">
<Parameters/>
<TargetFrame>
<![CDATA[_self]]></TargetFrame>
<Features width="600" height="400"/>
<ReportletName showPI="true">
<![CDATA[/HX_JYFX/RESOURCES/OPE_FIN_RESIDENTIAL_SUPPLY.frm]]></ReportletName>
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
<![CDATA[if(len(value("hx_aut", 1, 1)) = 0, 1,if(StringFind(value("hx_aut",1,1),"no")<>-1,0,
if(StringFind(value("hx_aut", 1, 1), "jyzy003") <> -1, 1, 0)) ) = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="5" r="1" s="2">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[if(len(value("hx_aut", 1, 1)) = 0, 1,if(StringFind(value("hx_aut",1,1),"no")<>-1,0,
if(StringFind(value("hx_aut", 1, 1), "jyzy003") <> -1, 1, 0)) ) = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="6" r="1" s="0">
<O>
<![CDATA[住宅取地]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="网络报表1">
<JavaScript class="com.fr.js.ReportletHyperlink">
<JavaScript class="com.fr.js.ReportletHyperlink">
<Parameters/>
<TargetFrame>
<![CDATA[_self]]></TargetFrame>
<Features width="600" height="400"/>
<ReportletName showPI="true">
<![CDATA[/HX_JYFX/RESOURCES/OPE_FIN_RESIDENTIAL_TAKE.frm]]></ReportletName>
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
<![CDATA[if(len(value("hx_aut", 1, 1)) = 0, 1,if(StringFind(value("hx_aut",1,1),"no")<>-1,0,
if(StringFind(value("hx_aut", 1, 1), "jyzy004") <> -1, 1, 0)) ) = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="7" r="1" s="2">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[if(len(value("hx_aut", 1, 1)) = 0, 1,if(StringFind(value("hx_aut",1,1),"no")<>-1,0,
if(StringFind(value("hx_aut", 1, 1), "jyzy004") <> -1, 1, 0)) ) = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="8" r="1" s="3">
<O>
<![CDATA[产业供地]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="网络报表1">
<JavaScript class="com.fr.js.ReportletHyperlink">
<JavaScript class="com.fr.js.ReportletHyperlink">
<Parameters/>
<TargetFrame>
<![CDATA[_self]]></TargetFrame>
<Features width="600" height="400"/>
<ReportletName showPI="true">
<![CDATA[/HX_JYFX/RESOURCES/OPE_FIN_INDUSTRY_SUPPLY.frm]]></ReportletName>
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
<![CDATA[if(len(value("hx_aut", 1, 1)) = 0, 1,if(StringFind(value("hx_aut",1,1),"no")<>-1,0,
if(StringFind(value("hx_aut", 1, 1), "jyzy005") <> -1, 1, 0)) ) = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="9" r="1" s="2">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[if(len(value("hx_aut", 1, 1)) = 0, 1,if(StringFind(value("hx_aut",1,1),"no")<>-1,0,
if(StringFind(value("hx_aut", 1, 1), "jyzy005") <> -1, 1, 0)) ) = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="10" r="1" s="0">
<O>
<![CDATA[配套取地]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="网络报表1">
<JavaScript class="com.fr.js.ReportletHyperlink">
<JavaScript class="com.fr.js.ReportletHyperlink">
<Parameters/>
<TargetFrame>
<![CDATA[_self]]></TargetFrame>
<Features width="600" height="400"/>
<ReportletName showPI="true">
<![CDATA[/HX_JYFX/RESOURCES/OPE_FIN_MATCH_TAKE_LAND.frm]]></ReportletName>
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
<![CDATA[if(len(value("hx_aut", 1, 1)) = 0, 1,if(StringFind(value("hx_aut",1,1),"no")<>-1,0,
if(StringFind(value("hx_aut", 1, 1), "jyzy006") <> -1, 1, 0)) ) = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="11" r="1">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[if(len(value("hx_aut", 1, 1)) = 0, 1,if(StringFind(value("hx_aut",1,1),"no")<>-1,0,
if(StringFind(value("hx_aut", 1, 1), "jyzy001") <> -1, 1, 0)) ) = 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="12" r="1">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[if(len(value("hx_aut", 1, 1)) = 0, 1,if(StringFind(value("hx_aut",1,1),"no")<>-1,0,
if(StringFind(value("hx_aut", 1, 1), "jyzy001") <> -1, 1, 0)) ) = 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="13" r="1">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[if(len(value("hx_aut", 1, 1)) = 0, 1,if(StringFind(value("hx_aut",1,1),"no")<>-1,0,
if(StringFind(value("hx_aut", 1, 1), "jyzy002") <> -1, 1, 0)) ) = 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="14" r="1">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[if(len(value("hx_aut", 1, 1)) = 0, 1,if(StringFind(value("hx_aut",1,1),"no")<>-1,0,
if(StringFind(value("hx_aut", 1, 1), "jyzy002") <> -1, 1, 0)) ) = 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="15" r="1">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[if(len(value("hx_aut", 1, 1)) = 0, 1,if(StringFind(value("hx_aut",1,1),"no")<>-1,0,
if(StringFind(value("hx_aut", 1, 1), "jyzy003") <> -1, 1, 0)) ) = 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="16" r="1">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[if(len(value("hx_aut", 1, 1)) = 0, 1,if(StringFind(value("hx_aut",1,1),"no")<>-1,0,
if(StringFind(value("hx_aut", 1, 1), "jyzy003") <> -1, 1, 0)) ) = 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="17" r="1">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[if(len(value("hx_aut", 1, 1)) = 0, 1,if(StringFind(value("hx_aut",1,1),"no")<>-1,0,
if(StringFind(value("hx_aut", 1, 1), "jyzy004") <> -1, 1, 0)) ) = 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="18" r="1">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[if(len(value("hx_aut", 1, 1)) = 0, 1,if(StringFind(value("hx_aut",1,1),"no")<>-1,0,
if(StringFind(value("hx_aut", 1, 1), "jyzy004") <> -1, 1, 0)) ) = 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="19" r="1">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[if(len(value("hx_aut", 1, 1)) = 0, 1,if(StringFind(value("hx_aut",1,1),"no")<>-1,0,
if(StringFind(value("hx_aut", 1, 1), "jyzy005") <> -1, 1, 0)) ) = 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="20" r="1">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[if(len(value("hx_aut", 1, 1)) = 0, 1,if(StringFind(value("hx_aut",1,1),"no")<>-1,0,
if(StringFind(value("hx_aut", 1, 1), "jyzy005") <> -1, 1, 0)) ) = 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="21" r="1">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[if(len(value("hx_aut", 1, 1)) = 0, 1,if(StringFind(value("hx_aut",1,1),"no")<>-1,0,
if(StringFind(value("hx_aut", 1, 1), "jyzy006") <> -1, 1, 0)) ) = 1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="22" r="1" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="23" r="1" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="24" r="1" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="25" r="1" cs="2" s="4">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="数据截止日期：" + sql("oracle_test", "select to_char(to_date(data_date, 'YYYY-MM-DD'), 'YYYY-MM-DD') from dm_mcl_acct where rownum=1", 1)]]></Attributes>
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
<FRFont name="微软雅黑" style="0" size="80" foreground="-1"/>
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320!n*!W=GMM<83ZW9hTWdNW8m.%(fE*Om>]Aq.cAiO?&,1#=AF%C?TB
_U3cr*GKP1,+FHMrng3IV:R"`3n!;N/2lj$;\QlTSP+b)Ct^QA7o,XhO\4h0#llgoD1?C]AD+
2r[[-_hWE/AX`i::D83sf\M3l/DVj[_o'9WLW'@5qi4nFA=7*2@'m=E-lK=Z:mUO%5`TYds[
^Eg,pj1b4p2?]ANFYb'CAmJ04hHDp,->q-sa/n39ds8j>ml?haAQrJP\EQ]Aa7uCHY;uVJ5[TA
]A!Zn8\r/rY-<mj#ZA#E6#ZQYrf&^#7Ll\G5?%@.5mq]A)&t=F%U*I!!~
]]></IM>
</Background>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="1" size="72" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="80" foreground="-1"/>
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320!n*!W=GMM<83ZW9hTWdNaQMgI(fE*Om<(cLAd8q"Mi7o@\mA7G3C
.uO`FH&"]AOG>dP@U!sLAmU4TZAQ/[]AdHUg\>GQq#aRUA#HA:$=_n`:9N)b0:Ge*(a!rae%>P
JQF3@2`pSYNZCR!T_Z(k8nrE6%n'U.XFY[OcG3mnm[MKojYMZjr?1FLha/(dTmeuo<,=e1Kd
r4tH[au+'*>e0tnU+U+f^\=_)$+eb-^3r1c@7SP(@@?/CZ]Am;6K"lMNIqlrOk+n]A!N4:L^(p
`W!&8`0qRN\K8n\8+~
]]></IM>
</Background>
<Border/>
</Style>
<Style horizontal_alignment="4" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<IM>
<![CDATA[m944+P@rH9-qd3a=<4WIdFMK*(7e=U8M!uDZs`8FCEbML'kNXU&4d]Aud\4P->&XKt/i5%M5^
#L-"`.qK6pM#)"G@TnL*VG*"L<J0=rlufGsCWXjYoEb%pZcj3TiEsF.[NGp\A]A:A@UG7c>T)
<RG"_B,]A&[4R0COQCu2+M(%<<]A`U1.YbW`VO5&BVQQnf!JC/qq?Gb9?sfjJ[c)Mkt)`X$YYh
k7\MfR#R$3`kkSdCT"Xl2s8>lAXJ5o67#l`%I!kLicBLT=;`,1F.0]A:ZhS0lkA1?K/)$8oB3
#=A9$+VAKi_B6iHaj^3@LC2GDM.^A=h"WqLC-br:Rrj0%7\ke">f4A[h,\qi+:7iB%E;g<'=
c/N,r?`m1@pYh9i/3dAd6RO_!hT;F#RbAq#bsF?Z)b6AqVL,gh>srN',uc_nHi$W@a]AKuQ)B
''EGK7;CS@j$HB5nRk.g"SOW'?7]A9I+EtUutE^-kZ,bQ?oAA=LO3kkiaM5jV1hb[;6N-1:sb
rLJ-nc!3\Tb-]AQo<LZ/HN3.ZHDT@n(QiTD[JpeTuNbHEY'!fIRl0'VC,E*Lh3^9).t,r2)n0
L`.6m\d'R7kVV2G[qO(_aK;);)au7'HsJg,"*Tgb`X/3%]AqH28lXdVq3[R;N'h67`s,H;XGc
1B7L)QQr`bTHG?DNV%bn4M,hX<H[S*BOLkbVK\PWqWh=d5O-rthiBGZ/u5dg+ErEdWt;Aigs
8.+0Eh$2mR<U8\M#q9Q@aYM&A._/+1[mqXdm<5iK0o%4r?gcU4,?:E7OM0fIL-\/;iEGh04C
a^+[u;+cSWqTMRBOlhaQ6ph:F7(#lMP'kDHPg]ArE@0_o9J%2nlsqXJhJNb/4ZdS(VV7`INRa
WOGTuL[dYr4;SkFR0uH4S(]A(8qL_p0[.h3j5\?+p&p^hnj+PE,FEP)lITZq6.e*T[O)te!!%
p[^n>?)\)0XXp]AR.!YJ5*6QY0I_X]AiY6DKN:_EE7GQU/^(T7Xpns>d%l1((jS&Ji(;FDoH2!
#@lk]AT^d^VP"mQ67^pdcE1\&&6J%[#`qht;^<\P`"hJPCKC`.8KN]A!`BJ_`*841jMq<9`\t^
2;38<`n,;nl'2M(L*0J@<P=M9n(K--,^o3PH0r!-hULPm*(2Z:;s=T#):icIhk_D-dpT!a?L
7UT:+uObW5MAs1pfqrdS4(,[p2c2e[An'-TU\sWk0c3'lHDedPBSUlpTiI2uSuSm;'0-=\6T
1eYe^Zm>)&OdU'/f#c2&4IsFAnMh?ol$VTd2Cm3Aa(V(RYj*(7>C>^u=k+KcL7*uDbR*p-"F
S5n*_s)WQ^ouE#S\ok.^WEU]AL5<UIk7sbDPs&F'a`e(hX-MjPDASV?XtT[7He>XKAfn;AiPb
lAO2<?dDm-i7hb/'gnaD,GD9u4Z'--XklG\U5>?t7tAT,d"A,2bgMLg5kJiL30'+/fEj@2N2
.*o)@]AC"=;)7_O)&U*bi#DU]A)Us1J,))D^1p77_:mGV#>!#)'m@BZTg'cqgTm&=0cTGlA$8B
nYCM5\1.;HS+SKVDTDF$!r7"kGYjPpo+U;&Eo"AXl&@k_b@G]AK?+r'cuhM,/l`/BltI0KWGq
@A+PKAh6C"Sg0cfo:J5^eB^e"S,f:`\no,7_0o@3;:/H2a!XRP-qU@F8\]A@s"jr(HJ,/9>9;
rDR\3.?)q8S?6FN]A]A2.1%/U1'F4)r2`Ru#%iNip:.20<Lg"-*8@>e0h40Eucih:aSso6c*<V
Sl>q"^c']AXUKR.3N"NbPjdO$>GM)&fI2V15[7$@(/[H\&(:<?',8M4tiSC*oEbN->b(^H[93
;PjnZX]ARNkT#c:GZT>5!;oCS#`%,JaKb5$=A.uZs([)u=eepZ`59nt'^uB@^A:;3N_C/DS]A6
@BF75el5PufQYCLjAai)PR<WBk.B]ArLUF;%NQ5d`#+0P4CI0&A)oFN4V/<#t.jX*pJ^XYYHY
sd$S1:n@1'N0R%GNe1GgaE)tM4s()YV.PHV3E+k4b:D3iGP:q)$4E(c>4@B6O_Emg?Z8gek&
;=pQMOb_:s&Q!qD!1ZNf6PW]AbEm7]AU^d%+@C!38^Fd%eKmfEJ]ASEElZfd,KFf]A9EjcqTBGng
`HUN4-hLMp'!1a&h^"\hbK,C5pdb^cVSBFFDjlO.+QRF)n#Wo5?.1SY;$5rJn_B(ZJ7)a0p%
kHH`j-A$pq)7A'U*a[CMfb./P[h2[&Ok_gB'CF_>L<od#:cm/ng@reF44(mQl+8RI7EX>XMN
mln6)[p8fdEFtLT0Q$_*I?']A-T^@#Ga0Sh"k=?l=i?JmL[oq#K9&bI0FAu`nFilf-cbs<,$I
79SudiK'*SW"U,&b4O1_up9A$L;T$`J9t;$jk7o4]A7YNCVU$iXh`=3"6BuqV)M6_hcadYi:\
@)O@apMt&cg<gncJ2kLX+bo;kjFeOB$;IT2Ke:L2CS0.Dem#WlmpcDf[(oREB]AHuQ\b&qiHT
Qd>r&,Ld[TlNM1[Lb*ZG+.ghG@]A@^_hhU"8:"j<T2pc1V"WM'umVlS4a@+[H7Y6dRq`mUf\V
_e:$Hbi-4gKqEZY=;6WOUmT*jnY#1o6ObbHDnWB5-gSY\.qV6G,33OU3LY[WAUg#X[qhi=c3
FXh8hEQ]ArIRRj6Y+3kpfT[Y2e3THU/oHi`Rs>X%O;X\NHTNQ9s?mOKmZZ.7ufDs">u1Pj=*B
qrd'^g84LluF*,:#KjmN6R6=,K9:_YtK,)np"jM=b*jPQ-J^+K_C`;$0o4ru%O/nftN<br&V
!]A!/:OF]Arj+4nP=EB()]AQ@q6CsVeu)Vig+gQRpJ&p4nF1SU_R]A+Lh-)2]AI=rp<CYc\=;#3%<
UMbcFX:&&8.#WmG&`ETP;8@G_S.B"HX_FP;UcqFmE!3c-FN]Amo=jMQ[hhXg`$c.XM_$/J`B'
+AZK%b9YiJ%T9t`9ZGe[eqcB_Sso60!h\KBhR:Q*#u/:AMZfRrC/&LM%R3ZnT4H^H@7+ErUj
GCKYO(Yn^r9$[RV)Fq#.+24mrBW+ji\kVMoud,IH\E]A+k=hUl?!qq<+$Er</Z\+2$O1QBDB(
-H4#b$@]AGc^S5tWeiNnrXn1#cq-]A+DCS:2aAXT&C6;;$+L7BtGLCL-S/6hN.Fo.Zb`iN\<2f
+sYn)X0i([l/'#H7HDQpt6oC`GeW2Ym'9n/s%GNEH%q!Rn/9p,roHANSFr.Tc+BBn45aI(rK
30oaVK?]A43Kue7sSsXl#X+e.[>9*,4?r\]A5PQL5+P.B*rhO/:TL5197MK*V-Iu1Y:WM<Zo)W
Oo`XpP0Y$]A20m$3j7XKV;`4-"n&`U7"kJ;tiq`FAiO`b-ER-iY;9!$H>`b4pd)G8>%-=:HF8
c]A$#s%M+?bSL'@C?-B:_=QkKj;F$IjK`fkF]AN?IXh8/.LEM'"n@$=;&il,B"N!D7$C,lTbq-
(f1VCpp6QuVPP(MYK*8r>I-2U%!$Zecl0]AN9qj2Tpoa.nC$=ZA9)eY[gO<:WmFs[E>5q'FG$
I4;QPr3(al/(L5'1g]A+P(VRR7k5Ro]Af(^C-2?F9;79O0`H!^YDg#[N*!a4!'/G5>.t)PoQ6Z
."*V\YIMU)?/4g:LE#>RL`QC_EE?K'T@k[9Kln`72uO.auijuKZ2J;L]A)IPZ+L<&ch[qP.10
cGd2"1[W>#;qX7@i!gG7JOgG2;f5^=&rMk5"X>8GHsO*5iFiLg2RSX`CC3IC7iZ,)A<!OrAo
E=siUk@1TaSqI6&kBg*nUY)*EDc7q9aaJeU[2p[@$tI+Al#+cq#[0<E+ujlLrO_/[kp[i/JV
X7l.),rT:NY<E5OYDtK:2roRNQDq/DX:9Q\rO`hnqnC4&e2SSU&Y;#MGnkVhX_hX!7q)T.&m
L1ue[O9"$UqE*F[N(]AH-!-bI5oU[kF1G&WRRMBNa*-8jXWUXA[9eKc&l"*'HEKmt^[R[()&s
,KIV5EHU`@_%)4/rmf6tOPTNWZf3@hk,01R<c#ae4`E^;M7_^P?B0`Eoo6nsZ7$["kLYAkbD
3.VkWJT?$6RVG*J5rbY'6qqkJN7R,\9^<):jq@O^DC";qFa'#%HpOk_.,Jm[UIJdA22'BZha
K32Ft?@]AF4$$;.L%gKjR'ZjFQRU^#TJi$bH6+*$FL:P4X*R&:d%4^-rACToNpBtqUg'6ckf0
WSF"]A5Gp0p@5OS<".YQA`fn<1k&_*P59Qi.nF`p<gp>/LQs-lItD4s$t*=KQ?@SsTYo*cK^_
q$Dc,NEk19kHg']AJ\F0"-MS@9`obZNoXZFGPErcr)#RF#&hbCcc"cN]AAjDu+hmaIdi-LP%BJ
7.VYCZIjoZ2C28NK5IETIu'N;@h;&,+\@\>$OcA"ST)mj`f'0Mk(Occ&.Kg*E!%Bo-g8=j+-
e]A6he6D\&N=Zq#t*p.!Q'Igg/Y32_]A_RgXd-B??=nEqjG`C2)m[Pgoi8s=ll+b^%lDEp!(Ba
L"_Q_533)(56VA?r*p`<Xe/XCZaS1.jrpF/7U''V8rc]A$C$$b,,SrmMe;6laiHYknI9:&8a^
o_!Q)od6:7l_4\*hLhrm'V2^8(rh9<?*3PXWDRRi,cJq;AU0B/:N>C*,3_.HV4\kcqjjllg)
WiHjDTO4Tf8WnDDePZm6H>aKE+1Ifkkkdsh&kgHp-gYC)4qG]AX(0O=e>LkDgOuL;$6K&5:;*
%6WYF@6I`H/!-0I&/@Wt1CAEL:tq0eJ3G1<4q6%A:O&Lsu8QT+H"P?HmU75QiSG#kAKlBQ^m
5*UsBq<dd^XA4>/1:-9/c+kf&froT<>Va3^9qu\ArXM[lS#f\Hch5T>R03pN[_769UN!3jhX
\Dr%p^2g]AHc#Cgo)2R6YT9[Tq`-A):mlPc_%*a'Rq9[#Nb7dadL'0QEfrLZ?p:KS%TB)G0-0
Z^&R3%e/m7J[BAf?27+SepOd6GD,ZC0bYV$KMq4PpLarB_qg).,Ea4?)l2eZ+%iY7WcY=ucp
l<ZTZ-[5k9!;/BJOt!CPKq8-AQ6J.d_Aa9+>F1($\sIEGl9HHM_BC&Ha#%k$M#5rjT&dP.*L
llaHl$4lsJ$!(;WcZ)^#4a,O/(r;qr@LKDmrq<u`Nu3nifrSlc7`6qhiK'qm&/dEl.GRI[C_
.Pdcm9#6_b*,Y!+_?.9T^-oh?q2Zr)I6#%CR\KRKPfH%-FM9'SY)Y*<4GAgV^A[3XE^5c&rh
M>KP>Zfp6!T-%>*bdrVh7gtM_m%7_FX?&9L+u0jbkIJ`d;Ore=7_MN@Lgi'H^C05"SB.htOH
K,$hQ4f61/RDXrYO]ACjP:GM^OLi(i0e@[`o_,)i)Jr7V$uN=nmi2T8sR01mM8M'cJX,LP>p`
f7FuM=n(Z/UJV?C>m;Rpt45#5<^Q?J@8Z=Z=hHnOl`R?"kN_`%d56:]A6T.SA#!>sjsNt)gSc
qEg(t@4mCRI$`n/^')kmtS&t81tq>o;dN!q]AE[!%A3I4Zr=ZBqQ6/Ja3?(Is3Yh)44X18!-@
:Th\ZN(ttXC&6PPC6LC0o/QZW2@0,0b4L>iHU7dSHdDUrLR-Z^T5Vls3<e+kr]Al%gL,moS01
)ah6n[*9T8]AF2Nu@/poq*>]AT:2Mr*o@%:Q1mGI.3.Jc*?:N"R"Z^a/0;R^EW1_X=VP4s2<lp
s<@cMm&*/KA)kd/Or-tBHF4n<u?%mD<>qV$7E.U[G3?CK@*Y\B?6a,0dcmHa)s2bSh>hD>j:
LWFk+TG`L5F$aF%i-#gmjZ=`C'Cij?n>8^UF&==*h\ZXrA='pGMd6IWdt]A5S'_$71qOk`HV[
12qk$pfX9@CFbT0mnc#-SR+63fSri)F+!$,Y_efWT1@cE..e.lnkEkL0)WZ.)0`PbcMjf.-L
8,/tD&Z1o]A7?9W7%k!i,78E3i'+fIe]A:7&,06@,%3o3QUgiP<W'@H%i41I38_$8T<q#eASTO
3:UT&Vq38c%H1#A$)OFs_f$P3OphCc[DoX;LYm+]A(su5c)o^`mOF2<8Vs,M[Z\DO>l.'Q/s,
p^$$aHa_"@"ei5cs,/VE,+3j";@_Vr\MG'r7W;>E=PgHjW%]A);4+YO/R5`5rY2>a5Bkrma`i
Y(Wq#=8tQgT[<c#fq$>Gm3*Q,lPO)7O;Wk'fH`Ib^BRi4M.3fq!.UVn<sU<9c1T-K\3P'</>
FA8OrhQJqIkNO(fC+,D,nX`XT.B6bgAIf9H\iBW#=/%i6X-:\Q7jM;]A(`3rlbf_2,`-9Bb!K
JjD;c-g\WmQ6RdkqgI3/Qa>NYiQk"\VJ0SDQS;EcJ:>=fWBT4Q93re%=cgIl6O"mu04;2AC\
@/QohW2BDu$:XF,PL`H+:?;,`]A>#G(G0?,RB]AB1i.4eC.!?[(L')_s/;Z6E\a(8'*%s01Bm,
i@_8WN,$(&mG$R0(P4oI58cW`Xc@McQPI%+jiVZ![IZU;o>]A)-k=m`U:=_"b6nGX-#@TQ9s4
9>t/1h`FGp3e64`E+0)=<;kJ>hc<FoGQYZ\du0DA[ifcb_j]Ar+OkrZ0P`5mT7TIAR0M-:4R9
\XbKBEbppmhknCkBlJCae"?BYqqUmZZ)hbi@f#AM3"FB2Emk4+dJ7CK62^?G)t"L,d1e5r3r
I.Qkug)',Z8A(F_M!^&Q'4omciufW+eF]Am$E)"7I^ho)SqfZkcnc-AbdTi]ABV_=l>"`YYZdK
&"_jOI<OnmB?ZQ-+eF#:%b>+DJq@o[a8WK!`SA)8oc%&;]Am*K]AZW8)dju5g?R^h90@HVYH's
@m7U_so1Ja@9=tsW5kg<9qVrpBirs`!<0O+q[j>U6ZV%_GX=jj4r'Wi'-s-Tdo0uN;.EZUVT
$TTJ+K\%k.EDjsd>?X\B8g,O.B>K)(>CX;X!<,Q)u7UlrBmZN;$?.7D80EVMa[6MSJ]AnV"?Y
>_a%(D]A,*H.`_ZB*ZY#eN*,G7<4gC,ZlHcnLCIi+tlFh87-`O51S>Q8fqfp5!]A`Z;D@C2/iN
6jEBr0*NMS%CR8ls(`%u"=pHcml5$>=8BUo6-g)q,%44N>qb;qh?%*qT1EI^D-Oo/`1%mgA_
]AK9!!o;Ej:qtD$jON0/<9F/8o'o>28g/k"i<!\Pl\f;OFhP)<dFJ_X*3WZ[kknL)!En/9gh&
(7LY;j#:#oko;c4<*B!A7`"'Z;TL7<sRM"'d8#)cQcOo2n&hfNgk.#A(cLi-F^3o7sSE30Qb
S5t6;Xb1;D(IMCL#Xfd\O1&@Ps(C]AcSWt\E!]A&U4Kp%VAddQGdtCBZh=Ku>WTe%qe&0<AXt\
Ctl3u-9hpdH^9uFU5g*n`#/I[;_Hj\#Aj2^sK[*Jp7=TI2#K_S.H1j,Fi4YgPkr087Jfl@?@
PA"WE_4QL^KEJE/h_9Hui:GW,0STpfPgXPZFfVaefKrmsIl3mG!L2S#7k'XIWk:HuZR<l/hd
3B(mUia\SkEf.9KNoALTd(X"G1_i]A+]A`6@1!\_3`3e+RdO3YHj[\cS`*-32p$p=[39N\oHB;
EWJE8-n4TjA+>`4/O"pUY1e?c5rVdnE5NGFc[o55jNp<.h)h3>XbP>^.<>bqT/U"F%X9/2]A1
c=5oK7K1/6^kaE"Tk2gZ-Ysd?4g:K)U0bcPQ@WsX4Q\*^o8jH.uR,eO8Se_;qVajh_oIt@FJ
Zu8B2'**)4"8Tn3aJnsec'^FE1.<:[^ES5u&F"eGCo;pF;Gg+/(QK'1jP/`P:l;9<SgD6""<
!J>;+^hWlM"F6K!@0tjeU)?uV>YnmW5Wtqe3&$"En6S&'F]A.1$oRGi;P7#qRqDFA:=Qa_$Y<
./;+9L6E0aMH84r(.$6IW$EVQ@PEr)8;@lERtE4ab5nFP433Ga<rfp4O]AZH@qFa0@TdNG.@M
nLaU%%PVi?h&GTC_^s*D8BP0oU'X/T>@9%raDku8E?Wh&g#ht!81Hf0C+tPKINr^9G2,bMiW
YnhU((W=Cm</8qUn)4=MM?]AWR]A0&5hG+1?odr\Dj^?Qq=+/DemX(,8'HUBAmYp1?Mh:M4\SX
4!cW@bW>agocIg-k7[U,OA+86Pjc89Z;YIhK9@Gsa^$%e_nr%cHtp85;l)4"l#+Z.rA,#N0p
;Sn>Us"eG\k?adoo#a\$Y8Qi9IU-Jdog`6[rXS~
]]></IM>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="250" height="150"/>
</Widget>
<body class="com.fr.form.ui.ElementCaseEditor">
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
<![CDATA[720000,1143000,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[4838700,4762500,4305300,4953000,6667500,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="1" s="0">
<O>
<![CDATA[指标批复]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="网络报表1">
<JavaScript class="com.fr.js.ReportletHyperlink">
<JavaScript class="com.fr.js.ReportletHyperlink">
<Parameters/>
<TargetFrame>
<![CDATA[_self]]></TargetFrame>
<Features width="600" height="400"/>
<ReportletName showPI="true" byPost="true">
<![CDATA[/HR_TUDI/HR_TD_NDZY_ZBPF1.frm]]></ReportletName>
</JavaScript>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<Expand/>
</C>
<C c="1" r="1" s="1">
<O>
<![CDATA[住宅供地]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="1" s="0">
<O>
<![CDATA[住宅取地]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="网络报表1">
<JavaScript class="com.fr.js.ReportletHyperlink">
<JavaScript class="com.fr.js.ReportletHyperlink">
<Parameters/>
<TargetFrame>
<![CDATA[_self]]></TargetFrame>
<Features width="600" height="400"/>
<ReportletName showPI="true" byPost="true">
<![CDATA[/HR_TUDI/HR_TD_NDZY_ZZQD.frm]]></ReportletName>
</JavaScript>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<Expand/>
</C>
<C c="3" r="1" s="0">
<O>
<![CDATA[产业供地]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="网络报表1">
<JavaScript class="com.fr.js.ReportletHyperlink">
<JavaScript class="com.fr.js.ReportletHyperlink">
<Parameters/>
<TargetFrame>
<![CDATA[_self]]></TargetFrame>
<Features width="600" height="400"/>
<ReportletName showPI="true" byPost="true">
<![CDATA[/HR_TUDI/HR_TD_NDZY_CYGD.frm]]></ReportletName>
</JavaScript>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<Expand/>
</C>
<C c="4" r="1" s="0">
<O>
<![CDATA[城市配套取地]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="网络报表1">
<JavaScript class="com.fr.js.ReportletHyperlink">
<JavaScript class="com.fr.js.ReportletHyperlink">
<Parameters/>
<TargetFrame>
<![CDATA[_self]]></TargetFrame>
<Features width="600" height="400"/>
<ReportletName showPI="true" byPost="true">
<![CDATA[/HR_TUDI/HR_TD_NDZY_CSPTQD.frm]]></ReportletName>
</JavaScript>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
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
<FRFont name="微软雅黑" style="0" size="72" foreground="-16776961" underline="1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72" foreground="-16711681"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</body>
</InnerWidget>
<BoundsAttr x="8" y="3" width="851" height="26"/>
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
<![CDATA[1219200,720000,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[1440000,1440000,1440000,1440000,1008000,1008000,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" cs="6" s="0">
<O t="RichText">
<RichText>
<RichChar styleIndex="1">
<text>
<![CDATA[目标]]></text>
</RichChar>
<RichChar styleIndex="2">
<text>
<![CDATA[ ]]></text>
</RichChar>
<RichChar styleIndex="3">
<text>
<![CDATA[${=B2}]]></text>
</RichChar>
<RichChar styleIndex="4">
<text>
<![CDATA[ ]]></text>
</RichChar>
<RichChar styleIndex="1">
<text>
<![CDATA[亩]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="0" r="1" s="5">
<O t="DSColumn">
<Attributes dsName="ds2_finish" columnName="ACTUAL_VALUE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.SummaryGrouper">
<FN>
<![CDATA[com.fr.data.util.function.SumFunction]]></FN>
</RG>
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
<Expand/>
</C>
<C c="1" r="1" s="5">
<O t="DSColumn">
<Attributes dsName="ds2_finish" columnName="TARGET_VALUE"/>
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
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="88" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="128"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="152" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="152" foreground="-16711681"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="48"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="250" height="150"/>
</Widget>
<body class="com.fr.form.ui.ElementCaseEditor">
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
<![CDATA[1143000,720000,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[1440000,1440000,1440000,1440000,1008000,1008000,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" cs="6" s="0">
<O t="RichText">
<RichText>
<RichChar styleIndex="1">
<text>
<![CDATA[目标 ]]></text>
</RichChar>
<RichChar styleIndex="2">
<text>
<![CDATA[${=B2}]]></text>
</RichChar>
<RichChar styleIndex="2">
<text>
<![CDATA[ ]]></text>
</RichChar>
<RichChar styleIndex="1">
<text>
<![CDATA[亩]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="0" r="1" s="3">
<O t="DSColumn">
<Attributes dsName="ZBPF_KJ2" columnName="ACTUAL_VALUE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.SummaryGrouper">
<FN>
<![CDATA[com.fr.data.util.function.SumFunction]]></FN>
</RG>
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
<Expand/>
</C>
<C c="1" r="1" s="3">
<O t="DSColumn">
<Attributes dsName="ZBPF_KJ2" columnName="TARGET_VALUE"/>
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
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="88" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="152" foreground="-12475905"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="48"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</body>
</InnerWidget>
<BoundsAttr x="19" y="198" width="205" height="37"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="tiaozhuan4"/>
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
<WidgetName name="tiaozhuan4"/>
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
<![CDATA[720000,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[720000,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<O t="Image">
<IM>
<![CDATA[!@e-#reXHH7h#eD$31&+%7s)Y;?-[s$NL/,%L<7=!!)h'k*5oH!:`WK5u`*!D:6U"!`8s;n\
MYK.ucek0O73d(kR[E2MJLOnJMHGp';i<:5Q\OL@0s8>tA1aQU4&"rWbVqAt6i$iFBTCk$5p
3L?9.d@uSA_J.Yt.p9G)#0Y#Y`NcN%@*5hs1W$6oo2S7,#/V5AJit>5N,q`G6%7k3H':dtdA
*'5]AX9!T?nUVr\0uH'c]A/q(&/$/6@e%&MNqisg#3E,`CS"4e^"jQgs3/[LK.q6e5)IN9U0f$
o/a?#CM!7+d**/AddXCogO$0+nKWaHnNjg+Ub]A=Qk1^=#r_q-CJCRAPjg3n$1*+)(hFMNDr'
4E0Qc!!!!j78?7R6=>B~
]]></IM>
</O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="网络报表1">
<JavaScript class="com.fr.js.ReportletHyperlink">
<JavaScript class="com.fr.js.ReportletHyperlink">
<Parameters/>
<TargetFrame>
<![CDATA[_dialog]]></TargetFrame>
<Features width="800" height="600"/>
<ReportletName showPI="true">
<![CDATA[/HX_OPERATING_CONTROL/RESOURCE/OPE_FIN_HJ.cpt]]></ReportletName>
</JavaScript>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
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
<StyleList/>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="250" height="150"/>
</Widget>
<body class="com.fr.form.ui.ElementCaseEditor">
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
<![CDATA[720000,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[720000,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O t="Image">
<IM>
<![CDATA[!O`&$rJ=?G7h#eD$31&+%7s)Y;?-[s*WQ0?*XDrM!!#)7Y+bmr!e!X.5u`*!`L"hB'i>g'?h
0AVdYECs5htIu:!i9G#ddSCf>rXu$UemZ._=#_/s@Ch'NtXJdNEKB]A'1OFFt;Aq8>,\T77k>
fq`4+bN[&bnR;p<e"*<q$F.PB6mlTuoe,o05&Y&lG_&R\1r[>F^Je?AK[QtI\$^^>g\-9Ts5
ktRiK,Nb[pheje#V)K)X1/snd_Su"9lL.jf^1R$W<EH%"@HQsqf!iRBuGA7\9@iU#/L4a&%H
JlY\b8*f.fbj?nO11O0o)anu-@(lcuFEFF\WWCFUrt%s2.t;VpJUn.PK#(,UXkB'/d)IG3VI
YLFl,jC[PN\@;uq#%)eE2iZHnG4,/2F5"k=_tlb;*MPpZJV52TcW@4=Z9#--EKd!NANa9iiZ
<s9Q*K,46Hmp(Y[j7_nrL+<co$l\]AjQ[k1?hRX+4>Vor%Y39Nb8nB*eM9Nifi)FKKif.;X`:
iQn3ee%Pb:2e*EO&oS)HW:(ic*i!Lio+C>\W;sc90PLr]A,&C1X>C:bqO[ABJ@l#=<>7E=@:k
i&Q('i#G#TLUsV`<muV5UmYi5=&Y2"O^jZ)412j\5R"]AP.h"<;Pm,g-^uQKgt':o3Q)0<R-a
/c;>K+Q`?/J^@]Ar5K.oFEPB-GVG;'BmroDdH.it<Z&4A$\f:$H_;bIuOn4C!rSiH*A;<@h@4
]Ah-S4,W>3JM9=R=8RL=\Q8$fHAf@#e'-#4i=<j5cSgU0!dm@:j;*dE_oi\Wq1l[ml'BY%&Z"
N'_.;r)#A3[-HldgKAYDT)/n-p=cZuo%:@91q3XQr7CqC/oV:33I`6L5eUPBr0fUF)B/!!!!
j78?7R6=>B~
]]></IM>
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
<Style imageLayout="4">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</body>
</InnerWidget>
<BoundsAttr x="532" y="266" width="30" height="20"/>
</Widget>
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
<![CDATA[1008000,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[1333500,4000500,190500,1872000,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" cs="4" s="0">
<O>
<![CDATA[]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[dim_cal="1"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[当年环京外埠完成情况]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[dim_cal="2"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[当季环京外埠完成情况]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性3]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[dim_cal="3"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[当月环京外埠完成情况]]></O>
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
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="96" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="250" height="150"/>
</Widget>
<body class="com.fr.form.ui.ElementCaseEditor">
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
<![CDATA[1440000,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[1333500,4000500,190500,1872000,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" cs="4" s="0">
<O>
<![CDATA[  外埠环京完成情况]]></O>
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
<Style vertical_alignment="1" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="96" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</body>
</InnerWidget>
<BoundsAttr x="302" y="260" width="170" height="28"/>
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
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="1" color="-15388336" borderRadius="0" type="0" borderStyle="0"/>
<WidgetTitle>
<O>
<![CDATA[新建标题]]></O>
<FRFont name="宋体" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Background name="ColorBackground" color="-16377030"/>
<Alpha alpha="1.0"/>
</Border>
<Background name="ColorBackground" color="-16377030"/>
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
<![CDATA[2160000,2286000,722880,722880,722880,722880,722880,722880,722880,722880,722880,722880,722880,722880,722880,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[800100,2743200,2743200,2743200,2743200,2743200,2743200,1143000,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" cs="3" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1" cs="3" s="1">
<O t="RichText">
<RichText>
<RichChar styleIndex="2">
<text>
<![CDATA[环京]]></text>
</RichChar>
<RichChar styleIndex="3">
<text>
<![CDATA[${=if(len(d16)=0, 0, ROUND(d16,0))}]]></text>
</RichChar>
<RichChar styleIndex="2">
<text>
<![CDATA[ 亩]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="4" r="1" cs="3" s="1">
<O t="RichText">
<RichText>
<RichChar styleIndex="2">
<text>
<![CDATA[外埠 ]]></text>
</RichChar>
<RichChar styleIndex="4">
<text>
<![CDATA[${=if(len(c16)=0, 0, ROUND(c16,0))}]]></text>
</RichChar>
<RichChar styleIndex="2">
<text>
<![CDATA[ 亩]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="1" r="2" cs="6" rs="13">
<O t="CC">
<LayoutAttr selectedIndex="0"/>
<ChangeAttr enable="false" changeType="button" timeInterval="5" buttonColor="-8421505" carouselColor="-8421505" showArrow="true">
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
<![CDATA[]]></O>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="128" foreground="-13421773"/>
</Attr>
</TextAttr>
<TitleVisible value="false" position="0"/>
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
<Attr showLine="true" autoAdjust="false" position="6" isCustom="true"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
</Attr>
</TextAttr>
<AttrToolTipContent>
<Attr isCommon="true"/>
<value class="com.fr.plugin.chart.base.format.AttrTooltipValueFormat">
<AttrTooltipValueFormat>
<Attr enable="true"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0亩]]></Format>
</AttrTooltipValueFormat>
</value>
<percent class="com.fr.plugin.chart.base.format.AttrTooltipPercentFormat">
<AttrTooltipPercentFormat>
<Attr enable="true"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0%]]></Format>
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
<FRFont name="微软雅黑" style="0" size="72" foreground="-1"/>
</Legend>
<Attr4VanChart floating="false" x="80.0" y="40.0" limitSize="false" maxHeight="15.0" isHighlight="true"/>
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
<FillStyleName fillStyleName="季度预估完成率"/>
<isCustomFillStyle isCustomFillStyle="false"/>
<ColorList>
<OColor colvalue="-12475905"/>
<OColor colvalue="-16713985"/>
<OColor colvalue="-16740460"/>
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
<PieAttr4VanChart roseType="normal" startAngle="0.0" endAngle="360.0" innerRadius="70.0" supportRotation="false"/>
<VanChartRadius radiusType="auto" radius="100"/>
</Plot>
<ChartDefinition>
<OneValueCDDefinition seriesName="ORG_CLASSIFY" valueName="ACTUAL_VALUE" function="com.fr.data.util.function.NoneFunction">
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[ZBPF_HJWB]]></Name>
</TableData>
<CategoryName value="无"/>
</OneValueCDDefinition>
</ChartDefinition>
</Chart>
<tools hidden="true" sort="false" export="false" fullScreen="false"/>
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
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="2">
<O>
<![CDATA[   ]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="15">
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
<O t="DSColumn">
<Attributes dsName="ZBPF_HJWB" columnName="ACTUAL_VALUE"/>
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[ORG_CLASSIFY]]></CNAME>
<Compare op="6">
<O>
<![CDATA[外埠]]></O>
</Compare>
</Condition>
<Complex reselect="true"/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="3" r="15">
<O t="DSColumn">
<Attributes dsName="ZBPF_HJWB" columnName="ACTUAL_VALUE"/>
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[ORG_CLASSIFY]]></CNAME>
<Compare op="6">
<O>
<![CDATA[环京]]></O>
</Compare>
</Condition>
<Complex reselect="true"/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
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
<Style horizontal_alignment="2" vertical_alignment="1" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="96" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="104" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="168" foreground="-16711681"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="168" foreground="-16713985"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="250" height="150"/>
</Widget>
<body class="com.fr.form.ui.ElementCaseEditor">
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
<C c="0" r="0" cs="5" rs="11">
<O t="CC">
<LayoutAttr selectedIndex="0"/>
<ChangeAttr enable="false" changeType="button" timeInterval="5" buttonColor="-8421505" carouselColor="-8421505" showArrow="true">
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
<Attr class="com.fr.chart.base.AttrBorder">
<AttrBorder>
<Attr lineStyle="1" isRoundBorder="false" roundRadius="0"/>
<newColor borderColor="-1"/>
</AttrBorder>
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
<PieAttr4VanChart roseType="normal" startAngle="0.0" endAngle="360.0" innerRadius="0.0" supportRotation="false"/>
<VanChartRadius radiusType="auto" radius="100"/>
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
<StyleList/>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</body>
</InnerWidget>
<BoundsAttr x="296" y="260" width="268" height="219"/>
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
<![CDATA[1008000,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[1333500,4000500,190500,1872000,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" cs="4" s="0">
<O>
<![CDATA[当季预估]]></O>
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
<FRFont name="微软雅黑" style="0" size="96" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="250" height="150"/>
</Widget>
<body class="com.fr.form.ui.ElementCaseEditor">
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
<![CDATA[1440000,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[1333500,4000500,190500,1872000,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" cs="4" s="0">
<O>
<![CDATA[  季度预估]]></O>
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
<Style vertical_alignment="1" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="96" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</body>
</InnerWidget>
<BoundsAttr x="14" y="260" width="160" height="28"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report4_c"/>
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
<WidgetName name="report4_c"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="1" color="-15388336" borderRadius="0" type="0" borderStyle="0"/>
<WidgetTitle>
<O>
<![CDATA[新建标题]]></O>
<FRFont name="宋体" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Background name="ColorBackground" color="-16377030"/>
<Alpha alpha="1.0"/>
</Border>
<Background name="ColorBackground" color="-16377030"/>
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
<![CDATA[2160000,1440000,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[1440000,3162300,2743200,2743200,2743200,2743200,1440000,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" cs="4" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1" cs="5" s="1">
<O t="RichText">
<RichText>
<RichChar styleIndex="2">
<text>
<![CDATA[预估完成率 ]]></text>
</RichChar>
<RichChar styleIndex="3">
<text>
<![CDATA[${=C16}]]></text>
</RichChar>
<RichChar styleIndex="4">
<text>
<![CDATA[ ]]></text>
</RichChar>
<RichChar styleIndex="2">
<text>
<![CDATA[%]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="1" r="2" cs="5" rs="13">
<O t="CC">
<LayoutAttr selectedIndex="0"/>
<ChangeAttr enable="false" changeType="button" timeInterval="5" buttonColor="-8421505" carouselColor="-8421505" showArrow="true">
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
<Attr position="4" visible="false"/>
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
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
<FillStyleName fillStyleName="季度预估完成率"/>
<isCustomFillStyle isCustomFillStyle="false"/>
<ColorList>
<OColor colvalue="-12475905"/>
<OColor colvalue="-16713985"/>
<OColor colvalue="-16740460"/>
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
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="true"/>
<AxisLineStyle AxisStyle="1" MainGridStyle="1"/>
<newLineColor lineColor=""/>
<AxisPosition value="3"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
</Attr>
</TextAttr>
<AxisLabelCount value="=1"/>
<AxisRange/>
<AxisUnit201106 isCustomMainUnit="false" isCustomSecUnit="false" mainUnit="=0" secUnit="=0"/>
<ZoomAxisAttr isZoom="false"/>
<axisReversed axisReversed="false"/>
<VanChartAxisAttr mainTickLine="0" secTickLine="0" axisName="X轴" titleUseHtml="false" autoLabelGap="true" limitSize="false" maxHeight="15.0" commonValueFormat="true" isRotation="false"/>
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
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="false"/>
<AxisLineStyle AxisStyle="0" MainGridStyle="1"/>
<newLineColor lineColor=""/>
<AxisPosition value="2"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
</Attr>
</TextAttr>
<AxisLabelCount value="=1"/>
<AxisRange maxValue="=if(or(max(JDYG.GROUP(VALUE1))=0, len(max(JDYG.GROUP(VALUE1)))=0), 0, max(JDYG.GROUP(VALUE1)))*1.3"/>
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
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
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
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
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
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
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
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
</Attr>
</TextAttr>
<AttrToolTipContent>
<Attr isCommon="true"/>
<value class="com.fr.plugin.chart.base.format.AttrTooltipValueFormat">
<AttrTooltipValueFormat>
<Attr enable="true"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0亩]]></Format>
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
<Attr enable="false" duration="4" followMouse="false" showMutiSeries="true" isCustom="true"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
</Attr>
</TextAttr>
<AttrToolTipContent>
<Attr isCommon="true"/>
<value class="com.fr.plugin.chart.base.format.AttrTooltipValueFormat">
<AttrTooltipValueFormat>
<Attr enable="true"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0亩]]></Format>
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
<ConditionAttrList>
<List index="0">
<ConditionAttr name="条件属性1">
<AttrList>
<Attr class="com.fr.chart.base.AttrBackground">
<AttrBackground>
<Background name="ColorBackground" color="-12475905"/>
<Attr shadow="false"/>
</AttrBackground>
</Attr>
</AttrList>
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[分类名]]></CNAME>
<Compare op="0">
<O>
<![CDATA[目标]]></O>
</Compare>
</Condition>
</ConditionAttr>
</List>
<List index="1">
<ConditionAttr name="条件属性2">
<AttrList>
<Attr class="com.fr.chart.base.AttrBackground">
<AttrBackground>
<Background name="ColorBackground" color="-16713985"/>
<Attr shadow="false"/>
</AttrBackground>
</Attr>
</AttrList>
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[分类名]]></CNAME>
<Compare op="0">
<O>
<![CDATA[实际]]></O>
</Compare>
</Condition>
</ConditionAttr>
</List>
<List index="2">
<ConditionAttr name="条件属性3">
<AttrList>
<Attr class="com.fr.chart.base.AttrBackground">
<AttrBackground>
<Background name="ColorBackground" color="-16740460"/>
<Attr shadow="false"/>
</AttrBackground>
</Attr>
</AttrList>
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[分类名]]></CNAME>
<Compare op="0">
<O>
<![CDATA[预估完成]]></O>
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
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="true"/>
<AxisLineStyle AxisStyle="1" MainGridStyle="1"/>
<newLineColor lineColor=""/>
<AxisPosition value="3"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
</Attr>
</TextAttr>
<AxisLabelCount value="=1"/>
<AxisRange/>
<AxisUnit201106 isCustomMainUnit="false" isCustomSecUnit="false" mainUnit="=0" secUnit="=0"/>
<ZoomAxisAttr isZoom="false"/>
<axisReversed axisReversed="false"/>
<VanChartAxisAttr mainTickLine="0" secTickLine="0" axisName="X轴" titleUseHtml="false" autoLabelGap="true" limitSize="false" maxHeight="15.0" commonValueFormat="true" isRotation="false"/>
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
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="false"/>
<AxisLineStyle AxisStyle="0" MainGridStyle="1"/>
<newLineColor lineColor=""/>
<AxisPosition value="2"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
</Attr>
</TextAttr>
<AxisLabelCount value="=1"/>
<AxisRange maxValue="=if(or(max(JDYG.GROUP(VALUE1))=0, len(max(JDYG.GROUP(VALUE1)))=0), 0, max(JDYG.GROUP(VALUE1)))*1.3"/>
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
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
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
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
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
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
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
<Attr lineWidth="0" lineStyle="0" nullValueBreak="true"/>
</VanAttrLine>
</Attr>
<Attr class="com.fr.plugin.chart.base.VanChartAttrMarker">
<VanAttrMarker>
<Attr isCommon="true" markerType="RoundFilledMarker" radius="3.5" width="30.0" height="30.0"/>
<Background name="NullBackground"/>
</VanAttrMarker>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrLabel">
<AttrLabel>
<labelAttr enable="false"/>
<labelDetail class="com.fr.plugin.chart.base.AttrLabelDetail">
<Attr showLine="false" autoAdjust="false" position="3" isCustom="true"/>
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
<![CDATA[预估完成率#0%]]></Format>
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
<Attr enable="false" duration="4" followMouse="false" showMutiSeries="true" isCustom="false"/>
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
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="true"/>
<AxisLineStyle AxisStyle="1" MainGridStyle="1"/>
<newLineColor lineColor=""/>
<AxisPosition value="3"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
</Attr>
</TextAttr>
<AxisLabelCount value="=1"/>
<AxisRange/>
<AxisUnit201106 isCustomMainUnit="false" isCustomSecUnit="false" mainUnit="=0" secUnit="=0"/>
<ZoomAxisAttr isZoom="false"/>
<axisReversed axisReversed="false"/>
<VanChartAxisAttr mainTickLine="0" secTickLine="0" axisName="X轴" titleUseHtml="false" autoLabelGap="true" limitSize="false" maxHeight="15.0" commonValueFormat="true" isRotation="false"/>
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
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="false"/>
<AxisLineStyle AxisStyle="0" MainGridStyle="1"/>
<newLineColor lineColor=""/>
<AxisPosition value="2"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
</Attr>
</TextAttr>
<AxisLabelCount value="=1"/>
<AxisRange maxValue="=if(or(max(JDYG.GROUP(VALUE1))=0, len(max(JDYG.GROUP(VALUE1)))=0), 0, max(JDYG.GROUP(VALUE1)))*1.3"/>
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
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
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
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
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
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="1" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="1" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="1" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="1" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="1" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="1" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="1" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="1" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="1" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="1" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="1" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="1" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
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
<![CDATA[JDYG]]></Name>
</TableData>
<CategoryName value="TYPE1"/>
<ChartSummaryColumn name="VALUE1" function="com.fr.data.util.function.NoneFunction" customName="VALUE1"/>
</MoreNameCDDefinition>
</DefinitionMap>
<DefinitionMap key="line">
<NormalReportDataDefinition>
<Category>
<O>
<![CDATA[]]></O>
</Category>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
</NormalReportDataDefinition>
</DefinitionMap>
</DefinitionMapList>
</CustomDefinition>
</ChartDefinition>
</Chart>
<tools hidden="true" sort="false" export="false" fullScreen="false"/>
<VanChartZoom>
<zoomAttr zoomVisible="false" zoomGesture="true" zoomResize="true" zoomType="none"/>
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
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="4">
<O>
<![CDATA[  ]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="15">
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
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(or(d16=0, len(d16)=0 ), "--", round(e16/d16*100, 0) )]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="15">
<O t="DSColumn">
<Attributes dsName="JDYG" columnName="VALUE1"/>
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[TYPE1]]></CNAME>
<Compare op="0">
<O>
<![CDATA[目标]]></O>
</Compare>
</Condition>
<Complex reselect="true"/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="4" r="15">
<O t="DSColumn">
<Attributes dsName="JDYG" columnName="VALUE1"/>
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[TYPE1]]></CNAME>
<Compare op="0">
<O>
<![CDATA[预估完成]]></O>
</Compare>
</Condition>
<Complex reselect="true"/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
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
<Style horizontal_alignment="2" vertical_alignment="1" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="96" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="104" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="152" foreground="-16713985"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="152" foreground="-16724737"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<IM>
<![CDATA[m<j7;P\^0rhG[A?<2RR1&@7:h*%Gt7_i>@`8jX"$.MPJ"b[Ji#c*Rj?#s$7"RLkXD_jJTGEm
?D;ab[c@@Z3#tB'/iH8k+!iIGa_s^;'>Flb!12/TX/NIGNNJ\N\X.\tA0B2ia@FX^*N`qM-/
A=DN<&nDk*E/;*li_iKGN<WIX6cZ3n#iJ42/N"(8"'p(-#j7,\6SRX>Eo_m#b503$,[U=o\e
URVdb#p`('6K:^o<tCL2kPU0=8a<."<3h5[]ABQ=L4je.Y*(hfC\1,rD-&X;*BBj)HG`Lg.":
KM$d5m4S"et>r4VpqP7*/4^"_[]Ar1W_u&MNp[T(MH\1*jTDA;&H98G1B<AFP(jEM4[n,L(AA
=6l>s1:@'p<b^*Ugbqs'YR2s\hq7Ng"DYFnkJ3Jsel5B:MtW[=-Q8$=e:ufn<L**t7\"(hYW
LS[G,]AELI(tf<f'4*sS_Ojj4mkQe*Y)CUL.Y[NTim;0AaQ0QMIF?D#:uZ']AMlZ.C8@Yl,M3+
sn#9?Y=0@g<RdL6sqL+69jo=?ie1Y9CDTf8%LSiMRdmPZ<k+AVDajXuDg`-a/GeJ$FiUsUBQ
dqWis6NX5A^$<#+*E9aZ,U?SCWq>HU/R=>\A+\S_?[(;i'&?&qk8YHr0CP+-K!@E]A>:e-JrJ
moGJpF3MZ0V&D\O4qQ+iG6jRPA8-E'Z]A+dbk)+n&QA*fc(c2^tt7,-S^Bncg0VIDQ,1P__(@
.i^>f;=?]A2a*I]ArHiJgJa6I$6]Ah2Nkfg5'd(E$eaMT`+C4:pmmYIu$%ZFYNSB\E]ALUMnFr=2
:@eF'+!i-A+EIh@9REB1EuR(ToW]A%XMuuK+_2RX'(eUc@J(+;e[%Uc4MX6Z6IJQ,1sn-Ek!n
QPpMDm/T:BO]A\YXaPjaFm.)NdG@,qX?lP+(tgko'\jh]AQ<5#S^c+^XZ:S.96$3Fe8upJ6>\S
X`B?)gHBbb$7Le2%"n:^26p0R%-NXbS,9!I7mS'Gu4/!/SQ8U264L+_3,8>::6P_FWWAj,1]A
cthA7s%)S0F!<CN\&\?cNo!ZO84rKj9u6Y,ou/[midQls>Qp@upL\A?a@0NgnjeS#Zk:M!'g
`.9eIO-:S.Uh"*o7%)ZWkk'4BmXP&5=9q@BKQ)3d%PUWW?Z_.-EI-K4Un#B%Ln+-U0u[>LBc
id:]A4L@s&?D:eMerp2RBCTK%<EQCK0un#B@qFY2lLN+XppZnE6%g;qM%T%rt,sW-pcpoc1t<
#g/@6'bPSGU8ql07AN:as1]AlQHHm#C"Vmmi#&t$*tjoVV"d8;`gX+03+]AVh@G79DV,`"=mdM
o^$DV$,b>Z/C7s@eF$hd;e:nV'faVVSHq4^DMl*`c`E*gZe$snAW2Xmf,SF^6:I"k<R=i_)\
jnoT-Y5)9@)OP&?e'[@6M3po=j'euc-?HS1k3^OGo!!lG8d'd8]A8YOnQ\Zli+Am_8VcO]ABD6
2#l1?J&/d7!_.J;%)*N#4LjrpCpB!X<-B+`kR$hFlOgr-_#M#n\$j1rP_q<\b.Ub;':E,Xli
b:DI67IZ_aiT>!r`uXs50=/<rhfcN,pd=4;=n/0[C^>eN,3UY/aRV)+P1NfH2lX$eVBu5iAr
f&q=1jU\]A7iPeVp-e:LF8-RZtRe)*gBF.`BJfn=@g_PChY'6)d.-,i<lJJ4h?gemWm@sjqbm
tQ";lkc:13ot!$*hOp]AO^WTl['`nsCRH9?Bh%qi.e-4b%cfJ*S/Wk?nLUZ8R^)XTR*ad.$q[
Mba2PI.JT_Xa[%_MC5:u<jE')pcs4%<,c38ZZQrW[Vp;63&GW=LYF>-?-EgNpUQQ9o?e[Fn!
&^s*5JXV&dWYL;E*IKlrKIRu@8C6qWC--!LB8s>S7ud[-2#_4FiK>q'E8CBL6knUHZ6mkdI4
`1FLF8S?Z4\,g3B#3ZUPh$0kMB"50t(R]A`m/qkSsJWO(HOk\:!@8'?4kZ^C[TUoGjcf`\;8%
4]AMUSp:OQiM%Q@DaO3L#tQ%Fjulq;t31.J`?Tn@@W5Ts'3B=*%dM@2SteQ]AuPdn7K/`B>5dp
2l(M_<+Gq\8>#D/C_qdE>lZCIm[!P2jL80:u0hV*eu(:C?Hkm?R6BRf&8.01^k&f,_&ouYZD
;fr/(,;]A!aW@Xd;t`-,X8>5Mf9NFO#`<<m\W5TJ=u71jdg3WPKZP4Ue55q<XG&r.8Mf[:rm$
qQe"'C#uW3V^>Ni=P')^=q4<&j!q+g:#KTVE;Ge:5m'#o]AOHukX5ZmPq")nLc;c&<gfdD0Gg
GgGBt?4oOUT9J3ii(IPSIJ^'\9AK#7D#@f<>_Wi?GofDl"GM&r)JE(&0X&Ap-W<4gL&#T;K`
s\_!oAfK7sI^mq:QU_E4d/piqNQnKtmB+-oSU$C^g?d#V:)dlJIlaEimSNl?%h4QfFpl]A-fG
HiHuD5M6lFX-5`-$L-`9.i(,eQVmmm^Ydqo^YI@:oAFd\`;qND)\Z\T(Uo392>"MI'g$d5B]A
++7a)hP1KJ7Lm">hXRc)SW(:!3/)ZI$h7#A;=Cj[200pc#m'BdfjNsl<.>+9ioGsFkgGjtn2
`8I?4p0$3UDgKchT]A,>tq/^lrF$*%-/6!F:AhVj;Mu(RW,H,WcEGS!WYZYYdE[NE:WLmZBhj
914gI;-B<Bo0+AP4>YcMGRP:6fWAiK<S5bkO!R-f>[A/XYYA:F'HiBik2eD/()G;qQ"93="c
C`DT;+l`n309u9p*WndA90&W@Ablc^PrL$h`g?)SAaNHAV[djp;4OGTD2/ToZp'nss3;mS1J
Lq\#,X^3K-E586Q3iYS-W!.f#5nRVl?<j[MI=n:Sb=u;*Wa5n'Xd.7R&L64QeW'rU_/_(dHH
%elTg(J;p6=TUcX[e'6jVsq$rbE]A&ZmU_R$').@eFh'_2+f6i=7/'AI"*W]A<GR!`E#^LO#<O
2mP$49+J[PY@0TmcEhN$^%8<]A6&D'+La#\KW&0K\GNMT3WquTu1b?ZM#OC'Gf90lqoP.je7W
2kIg&4"lkP#mlNAk8%MV*uZC<5)`rXMsprHN-9qKSVQCmC@(gWS`WNm;8i:uTn\bQ4Gtln#0
jo-o!@I`D)o]AlNJZ&Y7F2'NsJ+Q0k%oHmW4<?Z10Zb19kq6B'Kn0[D?V51Ye#^kmC,8^kC!g
b;71bDb/"`62\^_$0LtiM1<j6h`g,rB.J)f"'o]A39=2%WEVI0KE$Ho*FtJ7o;=^Wkp=e"]Aqu
<Bg&%-S[cUABgQ/g:V3`MsQM\BV@>-I-jHW0#L9mKg=SUn6m@5@\[usmZb#2eJ$b3O"lBbEJ
bUbIA*2Xs:`hk5LX-$E.pNERopHXf2pplPt"XMu\el!9dSaN^Y-OsEGj-o%UfH8#9ZmOoh`C
s]Ac\IQ66\'BZc@Qh\[?LZ,?YD80S#834eO=TeOfC4jJ[HqlBO,@OVa2cdKo]AKrTQn<R[(%Qn
(W6q<VJErRBREd<V7Hr+4heleXHufihA*@r1nbp;+@pMb7^_U;FYG]A"hq:6"a)#]At!NW&gX$
a7,oNVZ'?/`E65V*1)d5:/3)p0r4:8nG`!nJjjl_6UQg3qd_?8[$;9p+]A\e^<pnc(cG9F[R]A
luN9O<oUY<na%?neVS8?ZTl)(N`Y"iVS>3>@W,qip:#gR&3"*bH4j?YB(e"*'.ZO-=^AaK,s
W%b%k76Q"+F?@Lt6DjIdQDiDd:pX,eCWgs9QRT7GC#_>/h:r1Mhl9L)7[fUtjJ;eFM"QZ>Q-
d?jBT^e(X\J@[12A8uN1#"q"c.?22WK_7]A*n<i(/3pc;9&EcM%3fA9$J)-93JjhSY,BYOW(p
SE.@[ufES`e48G=b]AUF6hh<CA8U";Fo@%LG-GCg-DJB4J^3+PsT;RQ-pqCmuGbT8;AQFnsee
EQ'IHLhEoHRFc"eb;>kfY3A22NlMd/?>.D@R-'F7<g3!TF8.u)O,\MN(:R"arbnaaMfkK?[A
-t_h4:;TeXCD,As"<<J!]AdbcFH&22ISie":OGS<>moQu04D)!+g,E0nGH[)#"QQ!JadB]AWmM
TD8_he-lhgn>)4p4[)L%OZ8Q'+gtqn%#OP6#TOrMS>On4qRt8sVRA.-'Tj7]AMX6sm88N69b1
uFCfuTi<(&92TXAk#f_p/XWPeU.:0;&)!S>#\cr3EmXQ,7BJ@]A';9?LNm#J'+$e41)UkjlLB
NFPn)5iHcGg-#><;\p_u5P0m7N]A"=Z?L^0!OVAGXZnJY)(%9cV"=Ej]AD&UC:L^iA_o\u1n(*
GrT]AG1"<Sbb"Ojm$CFqT!PuiN[*Dh=5?Z:R%4^-Cn?)u*(LpOLlHj@n",WVj\F,e?DE22g'N
"!XO3n?Zb/qTJk$>m!d\ON()csIXK>FX803m_ULhi:fFPPsZSJ6.lM^q?"KcaOF?iN'@^Cq5
:>MN*:SDqHqNm?BFEJ\hDp;gpWi39;V\f.b\B30dbpiKf1T:$7O6fkE/gJ^ZKa[51-"m=YPM
q2QCi$LB+L56*[$[:]A4^E<c*?I*)VWE@U'jt_I,F,tu(sUH1;\@?n&IQ]A0]A-(&)itGt\,%FA
o]AstUBmgeeeKGf"1]AFP`Yi4t83kr3>_6YFkaT/tKN0DD`!i)R`E>-!MiY,\'rR"Jb6h-O`)@
TKk"i)OMB3E"b;-5C1MeKDbgb::;iJkV1$$ZaC3SgHloX?/pD\+-t@8f^)B<<(gn2g^Ci2HT
E0S/S;REMV`2D_B:9Au,0,s.9O9Fe$-iF$>H>gLLH3[\J)*]AiB9!USjS:(%r/_3/G&gZ<nKK
n*+jSO"7:mpU(nbB_gqrN))RH+hT4X5eVRRW.(o8b!!U7-lr:@Ue#QI*Ju,]A7dq?gGC>70>U
eNdeD[lOn7>=!fCF<q^oK4OZ$B@4pAI(A<o2"Nnp]AM^0ZX!N6tu(2q^EMq(JSY*Smj#"kKp\
sDLHp4B_L<Y@tNSs:g-DCOg^7oJJoK_qAZh0&l1i"l0)<mPuB5\:1nMD]AkmW5\jOt6"5W[?e
Qnte5BtG+%l2mII<0C(r3V,GdX3dmYBQa"HZYC!4ic@ARa]AG2D<M=RRY9[>$=ma!3iS"m[^8
H9C$i&OeBRjR_AaQO.5Ije:#KBSi,0$#-C&0nl;)*,9IEE\gIdQW<poqH6/>r*0@R.o['?95
qA(fG9N2tG31!JfdRAQ'n;&XcbZVugTD&;-KQj&;Yl9ThR;bUWC5mA&0Ws1Xfc6oY+!OCg?M
irTfBDeB;iaR3^`VlXIY:2^.ta8$SN4;0#V?"',dq2$c[s]AAT.sif=Zq:/CS>UY#jYWkCHiM
ef5,K6UGR[u^uWh)]AEE()hEJHtUlAj2^9b]Aj20bt"jSZf8f&4iK1iZV8+bfR6pRT6A_:dWRG
$biJR&/\G'MR;Y26tG.VEp8M5>miI@7<QQ=Q)9M8%m@Trhn#a`dD"N8ZZ&Q[@NC"e9.YikJP
l?b*D4%UY6XoP6UK#Ai_W($SBV12Fr)u&]A.IlM9?OUdcjn^QI[d)"g+-o8^o"nBY3>9!R;@4
B(AT>j,Lu00%5GTdVoL2;G.CO9fpB09(iCf2fKVPY/KHgTAkT]A[P!hXKJWO/*iYRh5SD9.SZ
Ucb;jaUP'6IWN3f)l&,ObXl00^(nb5b8.nZo44Qns2loBaX3+MUS_m`;t2gH!=""%BBL3)WI
M(ki@JbN!6.-H,=Z"`oaL5F8[eij,'9"%1b;VJh]AYjsbSK/!\BU.ZD;HiEjYFDt*a8fhFm@$
tqK4ro(2_rRPc7m]AW0gp`ZU)k!Q\j]AAS;G?Q\)-WGC+TO]AZ2]Am=]A1iS2Z8:]A#*'T]AHpE/b@>
s%f1#RVP7h*-[Ves^L6[CSPDb*bF5P.ZWhq[m6Jg$j_$RZB&JCOM&?,qL<hDQ@#(#4&;SWLl
RM6nXEF3ngl.#*ZR`P/`_*pagjg`[e:Hj9/H!3%8bM/+I]As:&i_VK\2MpRK)_+sf=CnS(V+[
V2dK_PV+njqQUKa*?96.IJm!2c2:1j-pJ"J1$g(A!mHc@rE!bg9FDo<4*NTc4o)^3sV&+HUL
"$R`FW_0fJuKL]A_%:*LF`gF$m,/U$VrBrnc2?hTqMbMTG)81\1]A7]A+'%CAGhN%-o5X]A[]AYR.
U6k^%-FakY'IW%3N$*OH<-@0ak]Ao2RJXCY*9S]AN^Dd2;pbns$9croA_33QS@b&&PQCX^HlGC
fLl<A)JhAFU-1d5E&5sqW2jQp6_GQZnnS$4^`aUe!)fV\J(d=Wg?]A_\0&,)6+SouJFP7P`b*
4I"[;^'$CE?+1p_EmJ8jLObqAV9sas^SDm8LYs0k:`h8?).\^.oB+.XdL.h<D`aa!aGZ7C*$
d0_3+8eW[X=V*AE0nu71*J]AK1CK(q\Vr!o3ha4JGSCF!9+)(LQ;eQ*_:I.La-u?DUQ;pa%mB
"of&sL^$i9Kr0#e,kh3h5kiGr@XIb1#RFOX.["S:l=8#pO%Q:BtMgi2j%4d!a+M:&6J<u[.G
GD4U\$/Tu1.Y.:2T;Gk(=+h(ck[7Pf3WEd-0tH4bB_D&T*0m)_?f+h;X:>AKLY/iCe^8/8)o
>]ACS=V#WIM%n>IYg;9f4?p1u@&F8+sB%']Aikp;b/q[1Z/9T>^Y&%Df(<2L*=&?Qsa\#bf<CM
7[Apah(&^l^("6pm=m`6V]A@53@*<#7.`BB%-gibFAs6`Y"rpWg+-6+gheB&n@WDkL]Al5TnXi
BZ=0,,N[l5p5hfOM^=i]A6GdfYZ'bj*QbKK[SE]AA"@brWZ8A^%;ZIG^>IA%G_)D7c=^F7k@Dq
kc>tGAE9-PQ,)bFtQhCKF]A*<c\*&"2J<3(a\Dr>C?Vj#kg7bL*?X./jcah>_U.O3&t^L&V#n
2\]A_KjuugMh*0^FBhgF^u:ga?6pn^.Z*e[b-cX^oP\am%9CdG;msC\;o/*\M[qi,mBbk#4!`
E,O"X)Kj5j"m>A;1b<e;kdO%]Ap$2(2h,n@AXkS5I9l=u+b0<itk(1N`/ma#kCL[HB%%,?oTj
I'c\";cmcri6-/m>]As+'o&M\ElaU$LWi2`Qo(?;]AkD+>6ai/<8-\,H,.ZM-I$_5'aSfW+Y9(
%'"%4L77M%dF0TEu&Bd`!(d:s0XiDS2EG20`M4#*35B\eWM:c+l'fo;ggM&iH#+4um9CEG7k
_`VEZDD)'ALR4-7Z/Lr%V[+#+DS?S2i0q0+CW7^[T.uIXhX0/'D8o?[=<:IO*S2&'.0?tHOl
/G&^?/Fe:mC+Afp1LLh\,h9PN)3`W#RT%PT%[[>5DtZ5K9hhRR4S?*0Ke\=1AComU-LpC)':
)Fc=@#_kA?<l6f^<'+SY3$-@i;KRB=/`p$LO[\1JM-Y:_QJ$JNTHJK-CG%._u*XV/1i?>rN#
U$m's-fBQBC[:[s6PUah.UG8.SNcH5(!+Q=.%%g<72J)kaFh7Cj?4Dr(XM;_^**:U8:@0Qjb
^_$@)ud*DkCc,mN"-1cgbt3#4bB&1,/MNAV^HQK&$9uJncH`/amS)kgfqb9:"J@&9buMOUC!
`j=RsoR$j#->\t^%p"'LV"'[sLrn$N5]AGn;H^itI8^([6XKK#R<O:1_m]AefQlLKg>RJ7h+T#
Vk<,;j\dc/T;0,)Ff%"`e[qtH:HS,,m-Z-l""l14g2Z^$('!j-%gBf%@<,FbC=ZA!)f7&n4V
,7,Q;YAGRR>P-;8?(P0G-kTA/2q`Of'%e1e2F-BC[$WL[)%"?%K9Kat[9K-la%X0SoNigZC?
<E7L:?_FL@l3.:gEV42]A_d(QF+a3JmgF%`6]AlO3aSIHri$kZWd1YBlMZM:bbRP6o]AJh)Cp$/
&4N#SFs$$QZ2K(l8D<1tB4,bMka"=&uc`)/^V5Oi?_`hI`?<F"^oBlRQ#5"*3^]A,(q$5Fi5_
&LXOoA-nJ3Fb4M#F>[r:5`NV;>YeP<Lb*adjP_c$3p_J=iGijfg?r7+ZQoq<]AIh37ni2We9=
5^;o63*Y2oYAdW)<-L_(q\B,4di%!pu#[:MmG(CBYkno8%78:O--o*Rb3f>7HL4..uXM3<e<
#1[]A>6a%-DCDgm+TU`U<^CE4OG#+m2EZdaumKmC<%<a;,]AT\d>DrYT7]A67Vh4\0XqSWL/#o]A
<W1tmfj_#[.,.9)n66g-V^unFntQ+9AZq^+W+pm5-&*)kQgOWFj*`X<cbD0Sl>K@E#4h&i*H
9XH$<5u6_#4G\nN-`fP'KBl+QkGI[@lU"N:A@"*=3o)r=/'lULf!>#BbI9&QL]A0`5F9!`qn0
2nSSF+XqUtZ5MUiEI'*;^5um>h;^&B#3!!&T3Tk2`>-Zii^lph`9EODg@H.JR=iF0drf$fXY
4IcHKkgE83?,hd>0T:IA-qb6pBB_tHu#o1`c\PQ51-8Np&Ju"5nacH:?\CSnpQ<$92.,Z7["
FgQ;dtM`&%@F.pIXq.q`2+4nX-rr@dlc*NV/*"M)QVin3Ol/Jf+\%5@lLZ+9l%)c\$Yk(XlI
Ibl6;J6=!t\3R?aU02"6Ih2]A/GCNm2kQ!AB7kRt4gB8Qh4!G37K__5fK?5ieCKqSa`H%,BJO
oiq/&FmelRdeFdHD-S'>li=$b.%C>6?p+3o+$m8QE^u1+$C<dc)u9s+L$c"NS=gc/3qNBN63
_I1X;2o7N,;BS:m>:omZOgbh/^.K[B0jHlO:F-p$$&2_->OCD.R^-'(aq6d#$1:t@BhRd7jB
D=585G>FJSp(&c>C.o'W#Bj7;NDnA@?qe`b("O^E2N,DR?C:e=4#1)I36`2"GY[>:j"cRRT%
BK7X75mGeHDACs=E,kplTNo:3:@L5V[SRLlFdeuUcGB.3EZ72G+Tb/1+B,0M5/&[P9@U/$_"
HTgSq$moo3\SA)sb1A9Z)B^!n[bd&anR8.T*dTt;.iAtmScH'Pd*i2>q8tjkHl^.!H`&lf7S
lT`1`>Y3/L;A$$\^U?nLU'?XSeC_:H*QL-KY!4[,WM`F"CNe`E5#1'uZr)U]A%`.>,EJhbo5;
=/W.,sPe[GE[j5re/@g0`D.qGoA9/`QAgsr^F)g49^"G--#=!jAJob3L$+ujc.T(j0Q]A"%A"
#Wq8%5$==X')D%-Kh?j1@NigKC/)2)hYd"d9Kkj_WBYT=WiDk]A&ceRi'NP5*1Fn0M!Ahc<d=
RW,<j0;%ih6.a>8*n>4gE2-+XPi#ssVs'p?f0<JCLpKg5FH2$,fL(?X9b\=D?N/;'?N,_Lqr
a)(b/E<8Q]A"Z\Y$^hMfCM9-SXcFts_BgM@I$s:IB3dA*$8`9b@LB2Mt(paftB`QC"AZMNEo/
#%N<3g6I\<I3pZLZ!fGeX0^I!s\O0pm<iDKZfU.MG)jB#*Vq7X0ZOF2.BC^=%1Elq*TidI2-
@Dm#%JXXiOVNk-)AYG,i.RXA$o$`s2,^\4T;R7+3\ki,D-L3G&O!T>Y*e1B7/%cmM[)h&WK!
G]Abl$2n7(cu8/eJ1%kR\1Sa`-[:>-+HlF+AX%S2IVI)Q<=@*1Q2N3!8p*!GC^RsUe__(?cPX
62IZ&!bpH_C_I<2meGW4rgAWVIJMC1N#RTV,=SPl'Pi097e)J?d0r:iQOLQ2dU,)G(i?kl<b
mDeGT4\pdi"3Mj=>%7Y_o0iW2;uNZS1)oH9"dSnNTJC/B]A%2[:0WNil8biH^hbk1Am?AI=$*
^=HR7Fb1+I4M2EeU,A`4577.C?0AInGm'6Aj_jMules'HuCNF3^fO!-ObRWt$"Vj;HW'K#aK
:85jd>EqM:D3N/QW$4OrYAn@Y1".ZjfBO3:[&"h6Ueaqu\Nsk5;h*[RCUQ,F"9[@)WLpu=pB
VB,9$[+o#:1YK#,TYO5;NMm^&aQi.O@Re1!@M</"-O)2X@-2SRDs1,2KK0hhCK<o?I\$.q#D
EufHsRr'u3S:X0d\V`QRjk!@j*-;b3%Sh2ccSogh:gC+.Zj`7BFD4@0i\!;UI)T)MH9D4g[)
ai$q>MgMd7$bbm1`:l0II7n+U8j<=cfmL^!.6+/M%N]AE;K2Yr)<[`C&M-$@Irf1<Eg(*M%h`
rOhQJ5dVh/PoW?U-rPi0.-)Xqh"-c$Ch$/GLe4QuQl3`?I`5l4,/mpM_ZjT9)&gU'Xd7$->0
-cn0KfL/[j;:OiFh7n5-jlLXim.$:k:dN3$>i:oYtcj)JU58Tg]A8a*lZ+DFjT6P1]A((d>]A2-
hu*MfeKbi$39SMhBQi8(3`)j!]AY+-hn"*Hk.ZAHIf<C9!5"Q'gMugtC^a_H2[KuT@3#oe+Cu
h^'3[XfXKM=`s3^)Te1sfnX>+=!-(o%D!Us6PW%)^^^6>H'8^$i*Oj^X'."!8%NMe]AM"-3_@
:=XXJ+8;nGcWLDZ7/!<KX(3ns"c/$tR6s%KOR/6*N>L7I=;Y/<Tn37H>#N#6EI"Mj!>q!clb
4d4^6Ejq"NGbiRb7^-O\6"&s05DgB[jm8$W)rm8"cYX-6:WP"E`2L<8S,\4*aY^;X!Ta0YJT
6&:if4$dH]ABPphV\s,g$^"b:\n)'Tt#J73arEDa?T(rURB!k>_l/fiu4!sQHiSBGc9W[lM)T
&@03C;U>?@%%'k)cdoT#<rf2_PLOe8.eSE,*ZI3)7tTEan<!X^WG!E`@F#/q543K^Kf,RkFV
\McFXrmO07*)9/i;>K\TFZ#V/rp6@B!o>A5^Hm$IdYo=fB"F2ur?cU#+LTS[u"Ak!3A#?J<3
1h.e(<'WU5UuT9dV\b&&aNIitgGV>a4j@poO^APFb!YeJC+L7So^[6K8T@=NZ,Nf;*@Dp?jQ
>8eYRco^!]A9^K.aPXI!;`0=ONGUX-ZYXs'!l^<!4Ldq(&6H9I47PjSrEuQp`]Aq9[;-=:9Ctk
[P=]A9D)7N&;b7n3s\4YK_Mm(GI!:EbcFuV`qr4<@r"Nb-@`5W;uX0OLIgpn0P@3e[3(eVXpq
kaE;Gr$;Rn[V#[^&>c_.<\Oo5i->@Gd_mI.Pl,k9Wp]AaFRHBQ?WW=?i@[H6`O=<O[`4b7q-^
*@@.J)!;eK:65?fR_\lG8&!)$:rT4OjoMg0NrP2ZRl,jehWCM5GabWp:Q84i?i=0M]A>C@3KP
i'BZ7(;h1j7_>#'XsA/Tp#tej%g8+V@q*ZXj.,m^Lrrn$Zb7'Q:e'2+_\GRj3/S#gP6;?&9(
eF@J>1]AahpP<]A#?Z#elaQ29.T\?%aB=%Ha:dlo_VM5$RJrG&i8g\#;"1#D.cB[F%#Raec?l8
rSs<`b=2La,;&np8VIbkP56+[.(8,K'i`E]A2!]A:_X#cKhp>+G_`#]Am(&Y4d3VOU%@`1#-AfE
':/HF>gO*2.t;c_;c#ef<N-D@#Y#*]An2ou3<b#V2)-i[BYCKO2i1U<>K#JdB7\#C7L4:QX".
PJfM9PogXn4P@WfXAEMQ.EjQ[*BZ=6p<i@(G#dT0MSTA0pLHPIcGTc2SM,b*:/L0Ylu-TJ\0
\>%I!CQ#53]A;\<ef;24`kHf'Xd.gir-,G5C(NC+s3r1hc`5?OA+O2D")*r\9N+'Z7J&[9Pb*
hQN-3>G,8VXY!%21hu/OY.fLiO=(@fX@D,STE<:>Nm-c*LsM;-nVlrqddNc[@.d5A@YB0&R<
+;BQ3V!#SEB_?_jZC<cq6*ME*p6n<@SBQbFN,bte.'eh+FG9BN`)-KaVgXh4HpK<\EXr"JC%
uQP=q-lPaK#FmG\R7MI&na@&EKY<:%;CDh3BPl![B*'dKFg_XfF:]A#QuYL(Vl?R"bjg\^W+o
\hG8s+\Xr++gJbE![Yrh>r-pd9c$?]ANnH%/pd?,WrR[$Os@!0GHhhfco,-NFCA(V(UUT&]A';
]As([?DSihgCh4:FJElA^f@1UiHdp(Q"&WAq0D"F#IQ#TK=,&=3qB0$^_^?`QL8@Ldh9pOL#o
(TuiDPJcJR<r?\.d'X/1jjoT-<5_V,+Kk3c%)@iTMFb7TPBXYA3`ZiLGQ/cH4o%@gc]A\Q7Bg
^=<`("+`i=_:1N5QF6o[+r/^"ueF%EecTiQTQH;^@h9&l&<iclM+@+1\Cf?f@33[--R[JI'D
9mL!frrWF5m&H<]AaVHu#'R#-+5J-iQ&r>N-N/?51m+Pl/"Y2>/$fK-3k9`'OnF*=h$5&l=LT
POQ$#a)#\#r,4'loaa=RErl37mK*]AfI*M%<E>+m^@3AX);#d'4M8Z<hWjQ(m_7Yg;t.0D9a6
O<63KA):S;-f-\^4!46Zs+m%:kecenJOYAEocX;e1s'(bg0Y>R[j2#QRCUP)EOVfaFS;kpAS
[le)nM$\H7ab$H5O&]A!Do4DlGX$*13,U9.,g=4[g="L1LXq<V5qs^j+ZF>0IlRF5l1O(L`b0
1!D;b07H44jFC_,GTWm"f^feiK]A0Hb<6an1,.-uQ7rEYNWRje+T4nr6b!.AgF^/'[H*'_8AW
:YdBDEm4o\kQ!4#Bp=&$SZ#T[]AiHGdSoe:cLLPE5/<5DRLckOKVl&,M.&?o"u\1tFOVN<MT!
efOVF%?Y9(ms"=j"7iU(=H9JfPKMj&#V\%W'&'tfUOB)%:d14HjolRVs/fOCf*h;rHiOmB;j
l16\4g!cP(-D"fOPr7tLr9*NYDCRs;Eg.]A/Z6%j1s4"21'tDf`dqemch_?)`#DD5HZK[5;mu
Rr4RT&e/,4ppa55k?C3^nPChG8'ls.cc?(9Y1:4-?Y-pP%H[bIZpG]Ac$aeq!E#"N_@.c4S7B
HN'8\66B6ODpgE1]ArU\FPJsoG%f)<6Ji:Y\g?Jc5qoQ@/n[`f`j"Ro60eblKPqGJ<qgq0o]A3
s:@.FkMdlF"d#!IQerXkgEMM>+ok%[]AQ]A_D#\,2J)lCh0DH]AacKY9>gbBO\WGAt`<GLZ6+h1
U5`0AMQ";6P>CJ%?Hn4)qR8%_t^,%Na:QhU097/bqr^ss/E?!YuN8jBJ\?@'s@*.%Ct+.eo;
?H5W$(Zgr]A1=9@t[7n99U)E+k4?0=;&g=qhAGK((pZmft\e=sG[3DCsoe?Q#caF1GH1=rHE(
@mO$$?n*X[X`0`mu,V%aA7FCBSgdOJo8cGs,p,Rf%J1$R'!SK*n?#3+cQ7j?e?;9mcmDL0YV
EZhLc^+7U6e[`_.n9QM$#d.l0k'&pjDbA+uP=kb4bp`@f#PYk=J07DRS'KYa3X>M5LYan8U0
#Ej!1\10MZXjEK*1'@jbNc>l^*076R/_[no7;OC>0LPl#CEfR+p]A9G-mQuMX-t&_e[-lKrcX
g':.,W6&YKg#qn:DPYC<a-*Xq7rXS9#7MeD[8Z)3rL4_4cqd.=O;ehG->KBcl&9&jW2j[!8=
iV`5R*n?6Q@g^7#e;7UVQi!b$:.GGgo-%l<h2$qpp\hDXa:IuQVNgpC`Z5q6Epq&<c%r:`0A
#pl<>B9-'8r`t"C!u;8)N.`3`%WLD[4rBc!Q;.F>lQGgOn!uWu&DX.pgfimdcB^UjO_O8D=<
QQ_^sWIeuPPq02ElDGLSoTA*pR?"+<rcj9$$r%M_D1f-'i*$9@35?N.-7B]AAk5?d)IQM1bbE
-HLGpa&6=;Je`s17o(.^h3h5NO-V'QrS>en`^[=l`no]ArY/h(IqJ5h7uBbu]A..rW'tQHCk7Q
*#c_\_fNMO":A`@AC`<V`Y`qBs"C$3k`m0k?$!L4q4g52Q#ieMX.>BL0TWDb"1Y[B^DSP:aW
R(o:MQcU3!;(G$aY-)2NHB;tHIGa[$Z!qoI.?seLY^7c(USaN#AS=5mi<Ioq\l"kkIU-7L!f
*l>dJ4BFcusXq\tDR$GCN@G8c'VWedEh5.U'o?.M*i\589+Y=`X$MIZNqZ,eJ&dqK"$F+4]A_
t$"=rjV%PqRlY#(D4'q"#"N8j(B]A=>9.<HJ:80!uE4<<4mh=MhOZInLeOB6:?ll=3;[Pk.]A>
irZJM<d#$FXs.,P@?g_f%et!]Aikr2bC%uK&E_,`R[E3Or;]AtdgKnI/je<TfV_SlRgCH78&E#
0X+mr5r.e]A=CR0Z!R=0jG*KMdqm6m^2*Q3;BC\I2[EHZPZXs8.H]AF9r>o(\dS:a(C6Z(b`9=
C*RhMgltW&iQ:RJh.&NoXD>OR@*\!]AN7J0p'275\1_4H+ZcF-!mOWJ,Vml*Y#N4"hP+3dE)b
9F,^I'V$hkB#J59tOO\>+(b?P@a@Bq)=lh^B^Id<*gC`a\qq(!qq;a3I)G,hr(Kn;c7gGKps
tmaXMV%<2^#!jX;c*;&6d-i2nUnP7`kJr^l+128&SI`;S!Nf82-d>r-XH`[7WV/,$I/O;*F]A
kd58%HQ&I3dK\`fID30KHRpt4,^5uGI5U!3aQ?eD<-<%K?HZi-o%S8?8N<,]A>aU02'NdH)R$
9:@S,_S-iL$+0d5"NG!l2JHZMltg%nV*;%p9Xo@';IoWF.D3&FDChd5f9O64$Xm$dd2G+#nQ
W$AjbHB+'%,BqAVm62H^coE_DqBXT9]Ahn/J;?X*fUN(-]A(h(,H0lJ.\^Sa`Z-5c*5V_8c*`*
.EYD7)r%o;R(WTBj2;eM]A_D&:",:-\QEh/XR7)fts5":9,ltk'(itr;W5_g1]A_:!qlSo.gl)
KVr\T3n(R.*AC89;H8jq/U?E[mIKpt-nG:VN6FS-$3p$;.X>3ir"ZZ9^QM3$Er?[c#O83ECY
j`.\HLUC:)6KRm\::a7i5hh7>0>c!&d]At`pHFumHjB1+$H,0a+e2\Xh99R^O3E$B[r_"94.D
ECs'peA=[5bqEb3[UKj-n,^4?*9@4._=-81R(r8kXS7[j&jpu(b?bc;GqehIc;mp'*15m@+8
VrI]Afpdh+@Y:Egs:iaY]A!U9N?5f3JD;sl_,(K,S@T-:L!!bd)ogfS<0K"bkt@`<gOdf6$"F)
RJDdJ%q"(Si7inG*^75/1(^^&-V?!Ahp;<rMf3;jg1q?n`5-o(I:ip;(DPdPcQ0_iu<e5arN
p\!0Md3L#M)@&[d_mTCH%:93NgM#V5TI;d.6:;&OJs,RG:CLlQWbS'+P*+f`'rXX"gpC,q+W
&hm1a>22(J'P7<9d5>#DL^.5NW1et%Wd.9TH9]AWTEr*<AFf0mPE.dhelRh1LZ75Hn/R\*A#Z
T0#@W@1XUn^EIn?uOTNpkZhY?gPl<tE`Jarc+Sq!a3S.L)Gf]ApU.JUL%88.tPb`NB`[gS^m8
$4]A]A-Ja]A)D.:Z?=mj.-;AmXHjUgI=='FGEK6SJFA:7MBiQLPJ^Y"8Qj/EZ^lnOcU+[/]AkM.t
G.S-K!M/Im57f07Br!;N%'AbDi/Y)jUV/2UFW??)>8:Jc@A?Nh&8$4,fpLIOE+iVgqN@@YeO
o*Dh11mSn1BQHY0_:U!'BQ]AqsjoFjtl?i1D^&pNC217Q4jCu9SL`Ps!Ms,7JV).jsQqtpBo
~
]]></IM>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="250" height="150"/>
</Widget>
<body class="com.fr.form.ui.ElementCaseEditor">
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
<C c="0" r="0" cs="5" rs="13">
<O t="CC">
<LayoutAttr selectedIndex="0"/>
<ChangeAttr enable="false" changeType="button" timeInterval="5" buttonColor="-8421505" carouselColor="-8421505" showArrow="true">
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
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="stackID"/>
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
<StyleList/>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</body>
</InnerWidget>
<BoundsAttr x="8" y="260" width="278" height="220"/>
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
<![CDATA[1008000,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2362200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" cs="2" s="0">
<O>
<![CDATA[排名TOP10]]></O>
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
<FRFont name="微软雅黑" style="0" size="96" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="250" height="150"/>
</Widget>
<body class="com.fr.form.ui.ElementCaseEditor">
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
<![CDATA[1008000,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2362200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O>
<![CDATA[排名]]></O>
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
<FRFont name="微软雅黑" style="0" size="96" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</body>
</InnerWidget>
<BoundsAttr x="580" y="30" width="127" height="28"/>
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
<![CDATA[1008000,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[5905500,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O>
<![CDATA[产业供地完成情况]]></O>
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
<FRFont name="微软雅黑" style="0" size="96" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="250" height="150"/>
</Widget>
<body class="com.fr.form.ui.ElementCaseEditor">
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
<![CDATA[990600,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[5905500,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O>
<![CDATA[指标批复完成情况]]></O>
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
<FRFont name="微软雅黑" style="1" size="96" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</body>
</InnerWidget>
<BoundsAttr x="14" y="30" width="160" height="28"/>
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
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="1" color="-15388336" borderRadius="0" type="0" borderStyle="0"/>
<WidgetTitle>
<O>
<![CDATA[新建标题]]></O>
<FRFont name="宋体" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Background name="ColorBackground" color="-16377030"/>
<Alpha alpha="1.0"/>
</Border>
<Background name="ColorBackground" color="-16377030"/>
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
<![CDATA[216000,720000,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[288000,288000,2016000,2016000,2736000,2016000,2016000,2016000,720000,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="1" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="1" s="1">
<O>
<![CDATA[事业部]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="当前决策报表对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="JG"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
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
</NameJavaScriptGroup>
<CellGUIAttr adjustmode="2"/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[JG = "事业部"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="4">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320!n*c-/B>R2,\+04^&k9U:D_'5ME,TnCufDO&7BJ$hWtriOlLSLj+
S^b*5g9DFSC"Q78Ne21$aka[Z+EU!=R/@\@)a!XQYq]AZ?s:[05#sR!iK9=d4FAo!Ra2b*+;O
]Aelse"s($JU0Cdj5C1Qi0'@9>U:KKcIF\W6;!!~
]]></IM>
</Background>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="1" s="1">
<O>
<![CDATA[区域]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="当前决策报表对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="JG"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
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
</NameJavaScriptGroup>
<CellGUIAttr adjustmode="2"/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[JG = "区域"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="4">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320!n*c-/B>R2,\+04^&k9U:D_'5ME,TnCufDO&7BJ$hWtriOlLSLj+
S^b*5g9DFSC"Q78Ne21$aka[Z+EU!=R/@\@)a!XQYq]AZ?s:[05#sR!iK9=d4FAo!Ra2b*+;O
]Aelse"s($JU0Cdj5C1Qi0'@9>U:KKcIF\W6;!!~
]]></IM>
</Background>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="5" r="1" s="1">
<O>
<![CDATA[目标]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="当前决策报表对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="px"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
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
</NameJavaScriptGroup>
<CellGUIAttr adjustmode="2"/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[px = "目标"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="4">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320!n*c-/B>R2,\+04^&k9U:D_'5ME,TnCufDO&7BJ$hWtriOlLSLj+
S^b*5g9DFSC"Q78Ne21$aka[Z+EU!=R/@\@)a!XQYq]AZ?s:[05#sR!iK9=d4FAo!Ra2b*+;O
]Aelse"s($JU0Cdj5C1Qi0'@9>U:KKcIF\W6;!!~
]]></IM>
</Background>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.ListCondition"/>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="6" r="1" s="1">
<O>
<![CDATA[实际]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="当前决策报表对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="px"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
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
</NameJavaScriptGroup>
<CellGUIAttr adjustmode="2"/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[px = "实际"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="4">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320!n*c-/B>R2,\+04^&k9U:D_'5ME,TnCufDO&7BJ$hWtriOlLSLj+
S^b*5g9DFSC"Q78Ne21$aka[Z+EU!=R/@\@)a!XQYq]AZ?s:[05#sR!iK9=d4FAo!Ra2b*+;O
]Aelse"s($JU0Cdj5C1Qi0'@9>U:KKcIF\W6;!!~
]]></IM>
</Background>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="7" r="1" s="1">
<O>
<![CDATA[完成率]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="当前决策报表对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="px"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
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
</NameJavaScriptGroup>
<CellGUIAttr adjustmode="2"/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[px = "完成率"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="4">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320!n*c-/B>R2,\+04^&k9U:D_'5ME,TnCufDO&7BJ$hWtriOlLSLj+
S^b*5g9DFSC"Q78Ne21$aka[Z+EU!=R/@\@)a!XQYq]AZ?s:[05#sR!iK9=d4FAo!Ra2b*+;O
]Aelse"s($JU0Cdj5C1Qi0'@9>U:KKcIF\W6;!!~
]]></IM>
</Background>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="1" r="2" cs="8" rs="8">
<O t="CC">
<LayoutAttr selectedIndex="0"/>
<ChangeAttr enable="false" changeType="button" timeInterval="5" buttonColor="-8421505" carouselColor="-8421505" showArrow="true">
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
<![CDATA[供地排名]]></O>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="72" foreground="-1"/>
</Attr>
</TextAttr>
<TitleVisible value="false" position="0"/>
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
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
<newColor borderColor="-1"/>
</AttrBorder>
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
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
</Attr>
</TextAttr>
<AttrToolTipContent>
<Attr isCommon="true"/>
<value class="com.fr.plugin.chart.base.format.AttrTooltipValueFormat">
<AttrTooltipValueFormat>
<Attr enable="true"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0亩]]></Format>
</AttrTooltipValueFormat>
</value>
<percent class="com.fr.plugin.chart.base.format.AttrTooltipPercentFormat">
<AttrTooltipPercentFormat>
<Attr enable="false"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0.00%]]></Format>
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
<Attr enable="true" duration="4" followMouse="false" showMutiSeries="false" isCustom="true"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="104" foreground="-1"/>
</Attr>
</TextAttr>
<AttrToolTipContent>
<Attr isCommon="true"/>
<value class="com.fr.plugin.chart.base.format.AttrTooltipValueFormat">
<AttrTooltipValueFormat>
<Attr enable="true"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0亩]]></Format>
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
<HtmlLabel customText="function(){ return this.value;}" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
</AttrToolTipContent>
<GI>
<AttrBackground>
<Background name="ColorBackground" color="-16777216"/>
<Attr shadow="true"/>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="4"/>
<newColor borderColor="-16777216"/>
</AttrBorder>
<AttrAlpha>
<Attr alpha="0.8"/>
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
<Attr position="1" visible="false"/>
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
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
<FillStyleName fillStyleName="目标实际完成率"/>
<isCustomFillStyle isCustomFillStyle="false"/>
<ColorList>
<OColor colvalue="-12475905"/>
<OColor colvalue="-16713985"/>
<OColor colvalue="-16720253"/>
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
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="false"/>
<AxisLineStyle AxisStyle="0" MainGridStyle="1"/>
<newLineColor lineColor=""/>
<AxisPosition value="1"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
</Attr>
</TextAttr>
<AxisLabelCount value="=1"/>
<AxisRange maxValue="=IF(or(max(ZBPF_PX.group(actual_value))=0, len(max(ZBPF_PX.group(actual_value)))=0), 0, max(ZBPF_PX.group(actual_value)) * 1.3) "/>
<AxisUnit201106 isCustomMainUnit="false" isCustomSecUnit="false" mainUnit="=0" secUnit="=0"/>
<ZoomAxisAttr isZoom="false"/>
<axisReversed axisReversed="false"/>
<VanChartAxisAttr mainTickLine="0" secTickLine="0" axisName="X轴" titleUseHtml="false" autoLabelGap="true" limitSize="false" maxHeight="15.0" commonValueFormat="true" isRotation="false"/>
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
</XAxisList>
<YAxisList>
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
<Attr rotation="-90" alignText="0">
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="true"/>
<AxisLineStyle AxisStyle="1" MainGridStyle="1"/>
<newLineColor lineColor=""/>
<AxisPosition value="2"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
</Attr>
</TextAttr>
<AxisLabelCount value="=1"/>
<AxisRange/>
<AxisUnit201106 isCustomMainUnit="false" isCustomSecUnit="false" mainUnit="=0" secUnit="=0"/>
<ZoomAxisAttr isZoom="false"/>
<axisReversed axisReversed="false"/>
<VanChartAxisAttr mainTickLine="2" secTickLine="0" axisName="Y轴" titleUseHtml="false" autoLabelGap="true" limitSize="false" maxHeight="15.0" commonValueFormat="true" isRotation="false"/>
<HtmlLabel customText="function(){ return this.substring(0,this.indexOf(&apos;-&apos;));}" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
<alertList/>
<customBackgroundList/>
</VanChartAxis>
</YAxisList>
<stackAndAxisCondition>
<ConditionCollection>
<DefaultAttr class="com.fr.chart.chartglyph.ConditionAttr">
<ConditionAttr name=""/>
</DefaultAttr>
</ConditionCollection>
</stackAndAxisCondition>
<VanChartColumnPlotAttr seriesOverlapPercent="20.0" categoryIntervalPercent="20.0" fixedWidth="false" columnWidth="0" filledWithImage="false" isBar="true"/>
</Plot>
<ChartDefinition>
<MoreNameCDDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[ZBPF_PX]]></Name>
</TableData>
<CategoryName value="ORG_SNAME"/>
<ChartSummaryColumn name="ACTUAL_VALUE" function="com.fr.data.util.function.NoneFunction" customName="实际值"/>
</MoreNameCDDefinition>
</ChartDefinition>
</Chart>
<tools hidden="true" sort="false" export="false" fullScreen="false"/>
<VanChartZoom>
<zoomAttr zoomVisible="false" zoomGesture="true" zoomResize="true" zoomType="none"/>
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
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[px <>"实际"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="1" r="10" cs="8" rs="8">
<O t="CC">
<LayoutAttr selectedIndex="0"/>
<ChangeAttr enable="false" changeType="button" timeInterval="5" buttonColor="-8421505" carouselColor="-8421505" showArrow="true">
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
<![CDATA[供地排名]]></O>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="72" foreground="-1"/>
</Attr>
</TextAttr>
<TitleVisible value="false" position="0"/>
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
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
<newColor borderColor="-1"/>
</AttrBorder>
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
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
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
<![CDATA[#0.00%]]></Format>
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
<Attr enable="true" duration="4" followMouse="false" showMutiSeries="false" isCustom="true"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="104" foreground="-1"/>
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
<HtmlLabel customText="function(){ return this.value+&quot;%&quot;;}" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
</AttrToolTipContent>
<GI>
<AttrBackground>
<Background name="ColorBackground" color="-16777216"/>
<Attr shadow="true"/>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="4"/>
<newColor borderColor="-16777216"/>
</AttrBorder>
<AttrAlpha>
<Attr alpha="0.8"/>
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
<Attr position="1" visible="false"/>
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
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
<FillStyleName fillStyleName="目标实际完成率"/>
<isCustomFillStyle isCustomFillStyle="false"/>
<ColorList>
<OColor colvalue="-12475905"/>
<OColor colvalue="-16713985"/>
<OColor colvalue="-16720253"/>
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
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="false"/>
<AxisLineStyle AxisStyle="0" MainGridStyle="1"/>
<newLineColor lineColor=""/>
<AxisPosition value="1"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
</Attr>
</TextAttr>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0%]]></Format>
<AxisLabelCount value="=1"/>
<AxisRange maxValue="=if(or(max(ZBPF_PX2.group(LV_ZHI))=0, len(max(ZBPF_PX2.group(LV_ZHI)))=0 ), 1, max(ZBPF_PX2.group(LV_ZHI)) * 1.3)  "/>
<AxisUnit201106 isCustomMainUnit="false" isCustomSecUnit="false" mainUnit="=0" secUnit="=0"/>
<ZoomAxisAttr isZoom="false"/>
<axisReversed axisReversed="false"/>
<VanChartAxisAttr mainTickLine="0" secTickLine="0" axisName="X轴" titleUseHtml="false" autoLabelGap="true" limitSize="false" maxHeight="15.0" commonValueFormat="true" isRotation="false"/>
<HtmlLabel customText="function(){ return this*100+&quot;%&quot;; }" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
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
</XAxisList>
<YAxisList>
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
<Attr rotation="-90" alignText="0">
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="true"/>
<AxisLineStyle AxisStyle="1" MainGridStyle="1"/>
<newLineColor lineColor=""/>
<AxisPosition value="2"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
</Attr>
</TextAttr>
<AxisLabelCount value="=1"/>
<AxisRange/>
<AxisUnit201106 isCustomMainUnit="false" isCustomSecUnit="false" mainUnit="=0" secUnit="=0"/>
<ZoomAxisAttr isZoom="false"/>
<axisReversed axisReversed="false"/>
<VanChartAxisAttr mainTickLine="2" secTickLine="0" axisName="Y轴" titleUseHtml="false" autoLabelGap="true" limitSize="false" maxHeight="15.0" commonValueFormat="true" isRotation="false"/>
<HtmlLabel customText="function(){ return this.substring(0,this.indexOf(&apos;-&apos;));}" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
<alertList/>
<customBackgroundList/>
</VanChartAxis>
</YAxisList>
<stackAndAxisCondition>
<ConditionCollection>
<DefaultAttr class="com.fr.chart.chartglyph.ConditionAttr">
<ConditionAttr name=""/>
</DefaultAttr>
</ConditionCollection>
</stackAndAxisCondition>
<VanChartColumnPlotAttr seriesOverlapPercent="20.0" categoryIntervalPercent="20.0" fixedWidth="false" columnWidth="0" filledWithImage="false" isBar="true"/>
</Plot>
<ChartDefinition>
<MoreNameCDDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[ZBPF_PX2]]></Name>
</TableData>
<CategoryName value="ORG_SNAME"/>
<ChartSummaryColumn name="LV_ZHI" function="com.fr.data.util.function.NoneFunction" customName="完成率"/>
</MoreNameCDDefinition>
</ChartDefinition>
</Chart>
<tools hidden="true" sort="false" export="false" fullScreen="false"/>
<VanChartZoom>
<zoomAttr zoomVisible="false" zoomGesture="true" zoomResize="true" zoomType="none"/>
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
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[px <> "完成率"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="1" r="18" cs="8" rs="8">
<O t="CC">
<LayoutAttr selectedIndex="0"/>
<ChangeAttr enable="false" changeType="button" timeInterval="5" buttonColor="-8421505" carouselColor="-8421505" showArrow="true">
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
<![CDATA[供地排名]]></O>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="72" foreground="-1"/>
</Attr>
</TextAttr>
<TitleVisible value="false" position="0"/>
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
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
<newColor borderColor="-1"/>
</AttrBorder>
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
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
</Attr>
</TextAttr>
<AttrToolTipContent>
<Attr isCommon="true"/>
<value class="com.fr.plugin.chart.base.format.AttrTooltipValueFormat">
<AttrTooltipValueFormat>
<Attr enable="true"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0亩]]></Format>
</AttrTooltipValueFormat>
</value>
<percent class="com.fr.plugin.chart.base.format.AttrTooltipPercentFormat">
<AttrTooltipPercentFormat>
<Attr enable="false"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0.00%]]></Format>
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
<Attr enable="true" duration="4" followMouse="false" showMutiSeries="false" isCustom="true"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="104" foreground="-1"/>
</Attr>
</TextAttr>
<AttrToolTipContent>
<Attr isCommon="true"/>
<value class="com.fr.plugin.chart.base.format.AttrTooltipValueFormat">
<AttrTooltipValueFormat>
<Attr enable="true"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0亩]]></Format>
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
<HtmlLabel customText="function(){ return this.value;}" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
</AttrToolTipContent>
<GI>
<AttrBackground>
<Background name="ColorBackground" color="-16777216"/>
<Attr shadow="true"/>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="4"/>
<newColor borderColor="-16777216"/>
</AttrBorder>
<AttrAlpha>
<Attr alpha="0.8"/>
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
<Attr position="1" visible="false"/>
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
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
<FillStyleName fillStyleName="目标实际完成率"/>
<isCustomFillStyle isCustomFillStyle="false"/>
<ColorList>
<OColor colvalue="-12475905"/>
<OColor colvalue="-16713985"/>
<OColor colvalue="-16720253"/>
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
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="false"/>
<AxisLineStyle AxisStyle="0" MainGridStyle="1"/>
<newLineColor lineColor=""/>
<AxisPosition value="1"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
</Attr>
</TextAttr>
<AxisLabelCount value="=1"/>
<AxisRange maxValue="=IF(or(max(ZBPF_PX3.group(target_value))=0, len(max(ZBPF_PX3.group(target_value)))=0 ), 0, max(ZBPF_PX3.group(target_value)) * 1.3) "/>
<AxisUnit201106 isCustomMainUnit="false" isCustomSecUnit="false" mainUnit="=0" secUnit="=0"/>
<ZoomAxisAttr isZoom="false"/>
<axisReversed axisReversed="false"/>
<VanChartAxisAttr mainTickLine="0" secTickLine="0" axisName="X轴" titleUseHtml="false" autoLabelGap="true" limitSize="false" maxHeight="15.0" commonValueFormat="true" isRotation="false"/>
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
</XAxisList>
<YAxisList>
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
<Attr rotation="-90" alignText="0">
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="true"/>
<AxisLineStyle AxisStyle="1" MainGridStyle="1"/>
<newLineColor lineColor=""/>
<AxisPosition value="2"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
</Attr>
</TextAttr>
<AxisLabelCount value="=1"/>
<AxisRange/>
<AxisUnit201106 isCustomMainUnit="false" isCustomSecUnit="false" mainUnit="=0" secUnit="=0"/>
<ZoomAxisAttr isZoom="false"/>
<axisReversed axisReversed="false"/>
<VanChartAxisAttr mainTickLine="2" secTickLine="0" axisName="Y轴" titleUseHtml="false" autoLabelGap="true" limitSize="false" maxHeight="15.0" commonValueFormat="true" isRotation="false"/>
<HtmlLabel customText="function(){ return this.substring(0,this.indexOf(&apos;-&apos;));}" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
<alertList/>
<customBackgroundList/>
</VanChartAxis>
</YAxisList>
<stackAndAxisCondition>
<ConditionCollection>
<DefaultAttr class="com.fr.chart.chartglyph.ConditionAttr">
<ConditionAttr name=""/>
</DefaultAttr>
</ConditionCollection>
</stackAndAxisCondition>
<VanChartColumnPlotAttr seriesOverlapPercent="20.0" categoryIntervalPercent="20.0" fixedWidth="false" columnWidth="0" filledWithImage="false" isBar="true"/>
</Plot>
<ChartDefinition>
<MoreNameCDDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[ZBPF_PX3]]></Name>
</TableData>
<CategoryName value="ORG_SNAME"/>
<ChartSummaryColumn name="TARGET_VALUE" function="com.fr.data.util.function.NoneFunction" customName="目标值"/>
</MoreNameCDDefinition>
</ChartDefinition>
</Chart>
<tools hidden="true" sort="false" export="false" fullScreen="false"/>
<VanChartZoom>
<zoomAttr zoomVisible="false" zoomGesture="true" zoomResize="true" zoomType="none"/>
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
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[px <>"目标"]]></Formula>
</Condition>
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
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</InnerWidget>
<BoundsAttr x="623" y="0" width="318" height="490"/>
</Widget>
<body class="com.fr.form.ui.ElementCaseEditor">
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
<FRFont name="宋体" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
<IM>
<![CDATA[I(KP]A>?eQp*8I[8MRK@k(O'SUii^8C.1dn&E4<8h"UV=<DT.5qOl?qJ"::<%$#V3kF5D!,qq
h5KhtY48(jkW9^%Rh/bW2<k4DV/!;,9]AAN0o/5!!&+o;L`B\!8p*C!3A4Jr;1t+a",^@!*I%
;QV'aHft06Ir\VW]AG;Yi3?f*uM:fi,d0c<bX=NEAuZ<PlS'DW<9B?qV^-Gic[kZ=m9W_m\*m
73pI-"Bj+G%GB&eQdhu$,E^*Bbt%[UJdISn,82Gmh_U&Y/j@G10R+=njG1lS-M@?6t#4'gH%
,SgA(Y+pP1TC!K<E:et:%m!W/3D8)k*Z^/Tq=FiI4d^,3mTEP<]APrq?EHGS#W@^/BjZ>Q28p
cd-kg;p'Jbh#Df)s32#Ojl_F;ZBq6<7mV.8345H;WBD^1^07F5&rQR2[\o?BI#bYjS%)`#2d
Re+ENY.ogj78u^[EqIeM!WEkQmfSLn8*0hg-I":03@"I&;WU,I4WE+&@i`5n!pk%mH[.;e+@
5d_mS9ckVn&UGdR\fFIrE=iP#l;M__)$GUP<=Nj/4`RAEB13I<&ddg0r=L0kt.K@l1EW_"#.
=kT4`!+YrN5j"NA9.(9a/R_Ql":GDX/?8Qir>FFZ't1rE4K;#r>1+,`_%\nDs[p-GdnjK`#(
9H)j$:srSL**3,h/W$tbb^m#22W4I)!"eH\43N+i^Qo*s&.^aT!X0frl->6Z8\A)8tG!ub25
BF^fKB=64U7Z,2c-)#,SbASE]A&hFJgFk_k07YDB1'Siu;Kt?tV`H#3.k3V&W&tWnQKQH(%9\
062Bi-;Hhp*p*.Y!C"SS9ICd2F2b@a>i,n$NMf=DaE`q7h0,g?>V7"u9W#@/eOF=@3jBb(m%
)4Ij5nE[q[.RK>RorM"T,kht:3#PFE2Q"+m3r]ALW[W_r5K(k&+mrg5A#lMP,!)Gc<sb8YIZk
,f@\LAt>f$8`sM:q^OiLmL5Jbd7HS4[^]ANe<rejLOAP$+_eX>E1SGZcTN*`BE*G^_:C<;Z^.
VZ+k,)+2#og;;.h)]ATR^#_?H$KXIXmi5j0%4jdMEP&^D=uRBb0<:GuE,VZ!33!KL2@%91hU7
s5sJaLnJVem9Y(ehIIp6e\mQ1fGYD+<VUV)fOhr.8J?d$Sl6gAbaomsXeL3-N^N]AC4sMG>U^
ENc,p?uW0T-hdrIb,Q)oaUdi<D<%7_K5R,t8Ln7MZn@WT&/sAC3_pS5+anlSO,;dp=J9h!AQ
8=`\$5;#KaJCDS$A:W[+g@SNVYGcJB.'h&fc,$=nVHE0Nq18u<5VW`K]AXGG.9"S7,?)KlIho
l,6.DcR3CQ1/op`FF`e56.p6i[j=hk.G"[pTb4^fbd%<<U0j:)h(JlkQU8u*0\he<AlRJIJe
dVIAN0/=h9DLBCJgV#Kl?(h_D7k5Z)_ED=sXBCQ)YV:^0[$;QSL_`>sM5DK\)"j#5ncf9ALE
a):JbQ#spE`K]ADT#)l,=(5Ih[pFc<6B&GVuX#OETr#9:=$[IONdhW?l,R:cATmaX$*RBQ++c
DoG`Kgo'A-Pt=JS`#kCHpgc4l3aE\"17T=aD*u9WS(\8Bqk?^YBai"J_FBIiO9<l_.F(R\t(
='NG7J&QR>r4FoKHrE0Pgh2J<m:;[,4l;`TeQ@&$F3f1rn1#K2a/kG6%&md]At:S`s2IcG+sZ
lH)L`(3/]APGc^d3l\=>lMR$JQs(6ADJ1RfV[a$b^rXro(f^0XnVC>i!L1`hh$J2!=qboaPm.
J-FT&MXoZc^5lkNX\%4m)k/:>R?0X09;B<;aq_31m5e):H\B3gtMF7lPJPa"s:>F"Yq`0W6)
NL%D.GS^Nq465Hl9L#+Mm%;DQ]A:+p$V/FAY+l=2FCRO=P=L_,ra#aOeo9RD^D8"CC2h(D40B
d9%AdTU'6%Hm$Vdm_3@e(_873i=Dg<,/!)kc^l6BG+)F?mpI+kSQB[Ie@H.O'>O$3)d?1<l*
Je@JXpdX-/Dqh!Fj,eFH7UmR\+N#sIp`BNOqZ`/3$Di%2ThG#jp0iPC6Uc;4bM.8u`_R+1-,
!Y=<$WCkJ!_'?#U2fBd/QoQ:6WEW[N(W'Y>UPfC&N[%Q3."tQpg5u`jjsY@q.S0N>hJ!*`P-
1mfsoqQn_NYJLYEMc,<4lp@M4X0&oii-j1&`s_hDQYS<ZA4\P35)6LRGJ`e.N%?T)]A0c^;M[
o+Nk#/Dp/IG&Wmn=i>+mpNc;dXap8c[@7:7hRR`H::BS;M_`fU:OAae.mQe%5>7ZiN-\%A1H
0j$8sCmQ0t:9&0Sdb1SG=Rn4t0IhA@0eE.\\BW,lolEJqjfkB)ZDF!/o<^;@^`CKL-2FM3V;
ekts=/-cbPu!2RB,jnU*ph*(<4^$9QeHb5,J453@U48EK`NHKP4b]A)BB)g1>0r,^^8]AnHhl,
</gpT#G+:98"=!Atu6#3G<E1G_0"b!G>1hG(-69$$E#p6"'3lc;_C94f$9F]AN>%DI4j'Aa*-
%Ab?K&L/F=2sh8A)hG_kkEBWbgun3-68PnIJr#e+?9D4`ifE7C>XOi3c(WkPcIR`BU3(N(\.
4j_k"ZBRl>fI#(tV>TGL<K:GrBn#<P[c)j^7&6S3E?Z+=#=Qbl"edi$L;upoToWP:QF]A[^*2
nqo.6G575/;I_Zm;(:Yf9OY:Lq$8dG4`T:"c&R%/IEs;HN_=l-b*j)0<OBTI0/Cpd0usN'an
p^.8#5)UVG&MQ5RK=BqUSO_"8<N9iBGmWI_!a;&j&.ufi-q@chq+JiJLYUc!R[jIDQQ)CV;-
8gmlke2/O=Q]AI!bBjJ&JiKEpLBVe5Qb8jLn%:!>PYDrR_#BlbiqL8rm:YBj#4%`t_@_W2bVe
eL43<&,bs7?4Q4i>j'nLMG9rgba^*llks.I9eQ-"m/M=br?aj&GXDB)mq7Y"0if:U,>`O=*f
l3WPBro^=;\R:QWj.&rONiO75q7p,$*k!%$_<MP6li7RidX%&jK6/U^Fman`hSN&:r).5cG8
aM'69seo?i<EuEd+LrFoMFenU4FX,Q]AbEF:AZCQ=3-6FQXM>OnNG_.p#Id,C[6>&l)XoJa(7
[r0@119TS\LZhs**J/a07K@<,O@2Au@A@+ZKcs-PR+<58(GkY2mjtM>*.8!CYkq(`"'^+SC.
7J(#Me:NXQ`M&UD<ZZ$V1T%4:?#BED^-N[;/;!'DVA.hW%]A,;a9tYSX4:T':W`G0L:=7V5M5
]AT3MYt0M4sV1&AtQ=*LR#0ZF@bdRV>ge2-`[t0oD,@Xu#&D,[4oSDH4B#i3F=jJa"b,bPHUf
TtPdO$r^40aTh#.E^H#u^)+j#ZB6#$CY5'SVTQ\gD*M-fla@9>#tt!=\9kEp8sN%)psT<n,?
FW1]AP4k9WM^J?kb8]A=4`ab#RQfB`Gn[3%16ofR8>dpT&^"m3!`rdCF?t:Q'k(7fS`f8nCsQ%
3OLn6J$WK&jYK_^n3r753e(/t>RVGB2HSo?#gE')(]A?3pa_QL"$Z$&'/k:XZAheQ/BR7PIPs
78HHlk=O*qY`36@$p');rNh'e-!iTj91D,mq10@Ua[jNjTZ@7H0da<QRf_(q';N>eEJPD:j!
uP^!3FJ9+L+MOhdHHA5NWb2am'1*ut-h/U&tqf($W#J,f&KZ)4HrA'b$S)ep3:@iCqN)<p<K
M(a]A27JL2b79M)pL2.='15Abm&k]Al@=C#GPAG-ph8.rNKi,h'6QHLZPe5GlfSFYBdB$!ej#\
"EV+<>'I2snrB5l"R'1R:IJ\[(:I%TTAN@e+X^9+nS`L-D1!FR/0;6CpPX(Fj'Yd,KD]Aphj]A
n)k_leJ78Q;J8cX(>81Jg!2,:U=%@*fiT`E::%7Ru]A+QR"@-FNTcW0?k;MH22gh7E?qI5SZ0
3%8nOWeBjK3Q$2(Yq;_19Vd]A;RlHS!0PNm.r7/@K*J%h-Qe3YS)NM2>oQ\@N^X-V=.YHO2Nk
"6p`jQQCRYmt-S(7[*kfc)C^QonA*!(5%iRHDj"moZ)<cFSj&4ok)W5De1qqEuMn'n$9I,]A4
ONS*#Ir8Fldl1Z%F07##1gU/X2NA&f/X8nqk(Y^>WU3SsLZ-,_GR$5(,C[k_UabP4]AG80@m0
/NqktLM@*o,t-OMP5]AO'TR]Afkr1:iUlMm4qlWjIui'VA;WKJ[lq,k`ij9l.HjN<oYh9pWZlb
$,JuNU]A,Iern?"0,IcS5T#qXMBRl2Qr"dno+4o28;g'[B8.8lcoG^\*6'49_W'6.kS_)Nk!i
Y<`h@/M.dRBQKdH/0BAC&+/o%"'A9N@a9/%:V#D$?UY?:&UB7+7$K`#@!cK,j0W$lk1%I)gE
="*T73b+Fjd$:ptUbLnb9*.K<9![Kfi0AuGZJnaE!=4*Foi1&Mb`(i:Dc(ka]A!aHos&ilkV%
\o`cdX3h#+@neDa.7Ebc,(8%Nc`/TZmsR*7s0H78?(iS-2Ofpll!LfK6p8oUO,&`RnBY@6&2
-a4cYJu@S_<A-V-fCsOsQT<oXUQmS+;W-Cueb*eA/S"bF?p#ZO-A>k4##14VuQf_o00?Tnh6
la'PBjI`cN7<S^S&l^k]AQ,UKLlD:GbglF3(YOrB9@a$*Q+^93&t5H-A'17*D,VX@InYU5Iu@
`)*[a\'mYO6c6Iq;IW-,ECnI#'$3j`?N'h,,IO.[@i%X_6SnG`.ZnAR-C15^fUE\5ZpJ;0_6
k]AAEi]A`J!NVDSOigrd^h(]ARW2an/'_^aRB@.P"tjO:HrSq`GrHd_P<#X13<9ZJn=G)krPjH+
p?\)'e#)YuM]A8XB%_O.'%U`t%<e&DAjQYMo/e&FaoMk0M1.%k#rq*r,N"cqF9?Q,D6.tg?Pi
NI3"f$PL`Q1S3hp/\V0ZHo+#;uc2Z+6Bl-o.fYF\VXMm!?U&LjI;ej@O`hBUPHcPtZK`ksIY
YR=Yd\Q`b#]A=[ODQ2DM=gEqB_u75UQ4#9^EeAoAp.-`+j3KF.gR-\WmQO[B(&^:=Cg3j'rA(
N)0hW;X:C)_STA?QNV2lS`WC"/<YH%;o#8-fVE:H=cVhFP4BQbC$?SYuKUWW7QT3Z_HP9T)`
&D:VfjunoupUH("bf:qsSe9\:B6ncF*CA_)LH4ct-JVeq?S14Jdq81<^^^JYYZGfs)HbXVAu
!m6:qYki"2:_WE0l3treOPhbXj7)4+_f!WPr'iJ=U5Z-f3KY?'$r(R?._*48dd]A5H(;Mh+S+
k@bReA@C(`-O^eS_92=L2X'&*.)(@^0O-cG-Gs=e:Z44kSV_/=5<[_ttTfe<01q&Aci2Y=4f
;k*CrM$ICbZ8o4I_bP\K@1<R2:Z`<RbHFE?=c=WpL$W)!s?e*Cp^PPt,9%Dq,ffSVkfU/\Xa
QW_?BN(gIBUfZLW)X.e0^2R7l&Sl;bV,P46T$KT@[1\%MK3i2P1PTM5nLMVC]Au8WZ<)bEn.=
'45XE\.'4-jfDaI(&mCX?BbM7_*]A%"<]A&1\K\efgMP8HsB4g)[)<?]A"CLn^)"9:CiIq'8;pj
TmjhS'5$6f)!?VIB#e%$U>:!4&!HU7IgI\sRiQ"GMHbPYj<f/e6`bS'`DlH#I=qq#U*$\"le
!>DXR1uL*)nlsE.+Q9d^\jdWg\sU.pO/4SpQpA^$MX1mFX3j57?9t+a\5&nQGGalhmFq&l/L
,i0pJsd'O9U5*/u4Tt4o<PrPC!g;$8O3gpMhJ'RE'F&\ZJOrrO3FcU_,gjSeuM31t_eK!7eS
d%#a$f,PjI&J_2/!*<S"gOPIj_a7Nb1@Uq@dW.b?&?%(%:N9,-SKRjJ\]ALO-mc"QN.I9u6Zl
rERk[u_PC+mU'1:81"X\=Z6e#)<-:MtI(=f[QM_,d[,'iOg?La9SV0n]AS.A8Ba"2A.l>Adi8
>9#L*l)-ILXF2^=l%0P":*fNQ68#YREP&04R<GC>#&j23Hs&7ZIMJ)dk_.e,Z(H,D%VA;c"T
'4Vo"(Efj5b<)kW9+EpMMX5o(oUFG]A/9!-F=iO%]AWAWL9;`e0Y;29gWR]A>pLJ'DRO.`dc.&c
bXQOY=6l%,KA[cC,e2hQRH7aOK)[;`q`0*A`+FlNa,R;^VmY`:0?P5)(BZj5e_+1TY3YnIVP
3>mj.nV!a+r53563Im:a9-U#i*Y:o.k:1<1WLQ^.6+ESXIqgOh/ZZ=L:.#I$Fi.l\'W;r^pb
4N"4d1;[iXr/5%U`GO`1;o#e^cGGH0j&;#m_]A*mgnF8p!ahXn;T9,?[aVWqtY0)o>f@n(V<G
r5_1I=lCoD.EqB-M*TEK$s=T8O6g'M6A@c1r><Vl=FE9B%4[b9Hd+6CI3m5@8nQt02OSn<f]A
IL!PO=;6]A'CE4fHkZp>8InTo2)W((ns]A_5P]AkY?Xsl>*a8f2A0Va!0cMVTBAJoaNGJ*RH8^s
1Mu#C(7&e8#j;A]A!As-^pV8XWF`[B>8<+M<FT96rPN4SqIXa1Q.^A`de(XNnlpD1/,CX]AP\>
#SNRbI0]A:k,)O:KPb[8a]A9UDp?jcOcR&i]AP*Sh/c^Zh82V7[m`*(oUSL\TL9+!6F[*S_Tr8(
W-!6Ihc&Z!Nqnp9dc(&@;/'O+Qe/`NMb%l2F9e!,FOO[<33GG2Hr^5+,0:lC%)FYb%ElNQ""
G6O`#G]A;QtR`##-ki[t^k;EWLF^"\XeZr?Rr4B7hOaE'*`QZ5P!qje.Eb5YXKB5u'ZB%\HG<
O.Q.V+I>Q4YF"V9S\==ae1@(1l3:HJqS38fh7oAl71(\p&n:jN^o5M2sc%SDi3!TMOlQ,DP:
dC<?%\8L3F$alhH=KB,b^C$b2LF$KT;T>l^DkmG'-a`>#n3"j8Y4(3Gf;5^t`-qE9^*/BpMZ
reR96Pk)-,^PM&om[qi_Zae:KN<-Ff=jJ2[*?I0ARR#RT``jBc$q#d*u[p:9V'qNr<8+qBFM
2Y:;BR#c&=:H8o62Dg90jrj*,\e[(k(t=WMTe"*7?*1A3fnnCUBkl>T8K`8>%bO1&gaD3k.H
VB-WcZsOm5e]AV;j\$!0qM6hdDqm#M0]A=cL?kZ.ajO3t&FZC$iEY$B3%f<?g`?XJq!_.P\D2u
em+<tB-L0K4qKnjb4Ll+5R+e*/bcN^@Mdk+JjFA:j1rqdb=0!LQ,D*WNMe57XQ`X.1ENn>+@
!nWkBn::^=(M%u>WlR_ek0_2P,M!*`lC*a85Q.F]A\H#bYWHB$ZC\MHa<YB2gea!tbJQ+@=V&
u*?^ThViUqA4a4?_AWd6(W^l54E)f(hcGJEl,./-6DhM9.83Npfs_8;+eFb+"hb/CkZ0V'u>
$E&Y(![Y<)<ZCd'u"ICBl&e`GjL"_2^UPriTHp0'W`C;+ukg+%Ku41]AETR(?K9^KN^6^!3=c
E3Fik9TdDR=<^i/ioeiB6gLe4<Q:h06cnqYF\I$Xp^2J+m.h4Q6#t=tU;W]AEAs74TgKci)rT
U_d]ACmW:b;makJhuraSE>22,l,_l1FGio7XI#KJD^:!4>dX<RWb-D4*B)H[sLV5YB8`Rr"VD
(P1n&gBq<_r,N4LW,dg59bKmjK.da='`ql\B^m7Ht@c-a#(Y>,nR&]AhlMZG=HFU/qsEC(W`+
cp!0XJ%S0.E?:2Y1DL-'$P-<$qC)C/Xa04%+817fFne!bni'VNfB!KY8\KOYJhKA$ban/S6L
\p<o,74RWin<Hb6C_LtMB&34?3?VE$An7bMW<B);3jJfL'`ZUW2aOiAFV_]AiM3UC11=l=R\A
QGDR.n!$*o(NEVSP[]AB2A>:^>V59`4!o4jl8^?1g;-?lTZ02itp[nWMkKLKHkf-T,2EErcFQ
s:/`]APIU65+%/2ZZKP6$eFu4G3><5BmP]AJ`nh20cLVC^W:`0fK,Rt(?h_dC1\)6N,@`uV74<
\r0[L(%UQXc0leHVfW8i1@4s;.O"^;n)F75eN)ZrsWXJ:Q-SNJ2:[k"s>usXM7UKKDqs[9Q,
Tk,H\M=jr'Nk\"7&t/@c*,K@s#IuuY,L%:#+Vb&:NW1uDmR!tHd7)BWFWaA=a.fM(L2Xs(EJ
$HcI_:@*:Aj@HA*a#6i<j-=kc05oJ_P:hVL<!-3PFYK_/\jJ(<emL#$VW=hSH^opRO1;qm:<
+6R0C$,([V6.'k"oY.ou@.cs\mr"N5OPCR$rAS>\M,&ZTV44):;$VY9#ELHh"M2s&E]A=<]Afs
Z#SE=N'M_Lu]A'/4ghb3TbpSpYAodrmuR$mf$ir9r^Qjo-?B:l./%-WdVVc-:@0JN9HLemDV<
nL-?QZIeNVrF7q!TM@i).YGY[ZbYS%%#u53*pe+0tn/E565.+ST`hOE:]AN(1SY%PW?Kc:"_,
-6-']A:Z6&I*1=mZT68PKViEE3/[\TPc)oT3TV[\qX!C%Q.fP@kMY\i]A!YnJf&b2`"<Lj\j9:
leJ\(b<,,]ANE&1%%n#Jt6,#9r?5lZ@g_$?ltc7"[!DVr#!s6.g%(o9ISVF;pdqh=8O1GQ3X4
/;a)DQ10hl;EeYl(d[1s90;:O(f^,T:acqG8T")gJTYpg!_o+%.e!`E*bo;(IU6ZQltDBEUI
@V((s,&1qfIEJiFgAFB<"u[J*KdDjSgPTlX/cA-,EE#Nbnso's9Et^WgdI`5Ktq:0dCje]ALZ
42LpE1d(S(Oa^YR)oQAV8nbW!??tH6:kc`Y2pJ%bUfBU/PZ5S9k]A.(dWBPmpL)JKp3Eb]A2;9
[]As$H?QA>F<BOQhg:W.UnB3il"JOG4Im5,Dq"]AN#g>S57A6g$"AfWCjf+kf:N[L[U2b-Yj$A
1Ai7Rm^="tWGl3gW%i#RHAR)\jJ<)2W1e!'>P^`1js+=4QThsL#kq!NKc/=>D/-.M>B[8A`h
3ppo(4#mCgV)^jXbeBF+\ZV?>o'*_\RF'-\W6*]AK2NT:,;f@`05_i^N_nHq'RF*o7(Xo,*X3
H73q[,DP&Km_g"b:R\7dUO)=lg(3Z1gb&/pB;$+AOpU'F\)?:KjuQMGTR!T@k%30hfD(Opc=
R[oI@1&U]AJ+9"bUt9g+T=6$>;_2U32>X=U\8/7XGGg.ah<<GTZ;\$#StkKtMuP!8*2ag7\#W
jo/Y(<.=;N_C7u^N7hbIKWrDR8E>p;_n(ZrT%9&9[TL2S(F$bEs:WN3KDf]AfB"K=>YW!eqY$
A\,n_JDO<q79o<Z@>*OJmUT:Qb047otB,oCf,90dqZq7Grp/s*Ot;?r+gbrN8BFR*.TB1N)e
cDud'F4NFbmsc=>W9<?!=]AQNJ2l\/o\fE;mV\:t86C/eC7B5JI/!jn4jmqJn,PkYFG6?"6BO
iM6f\e+/4*8uQoTc<9NILMNB"QOK3GjT:o%PqKKr3*)%<2]ABYb!RdL]AH&tFKsk*ePXW^HuiB
YejSLJpKOi-RHCa8(P'BhpZ2H4`GR:]AejPop#A[&5<c!7d&@\'C0:QcZ<HXYE;k','(]A'H"+
58;7&.Khs!BVbD87]AH3F[/sq_&3",UTO9]AJAEg+J(_?ER&%6bdQVL%YdZhS=n=K/e@'A1M&+
3]AScW/sorD%mgK\H?cI!ou3@)lMB0p69BaSU,3!/gCbj`i4bU<icG2budPg[ts$8G:gBPEmk
6PZ?4i1n.]AZd"'<CGM0:>&,3+N`M2oYIQh(,SUX)(0b&XZ3Y.c!q=lY@Pn*le_s%.[)Dn<4F
M*\@g29NSB*!3/=*XI`H?>=Q"Acs^]AH/=Z7Kp[%X&&N0d>pl$#a4Ti[(8RRMaL<^QtET!oT2
Ios9@3[$8<p!akC0fDfOAE6pA^GU2=:Yok(<C/0pkRaV1P28IBe_d$VIhAoicqG,`t6_$_c:
l*sRe4i]AS7hEjE2"]A?cKVO4m37e+]AGKdpOC-r[&4[QX'0b/^%S`Z=08FY6T&$MFWBdH>US?]A
Y\;rh>?Wr#7B.;^"2FtX>S+?TK&%L!k*VDm:/\A5Ee_'u$\`6?t5,A5\L)n/3O-KLOqH5>12
*ig"DW#9!\aIetu(X'N;6Z3b@IrL1eR(?:7%6KZo]A,CTRFI,sTNEInB4p\YY="tD*7XiuZr%
^T$2[\AU/AH3O]A=[aJaoS>%H$qbV@#9iF<YKF2QDKruJ%d/65(qlWBXmJpq9r2]AT!d55lu1!
b3U735B>LW@"r*&BF^;&]A\VK5MlGM9Q>'B7<;RYLE2AgcB1+'U)9]A&H\aJ'BYSO7q9JaKNZ4
j4@No,0`tnWe?&o5qHUM[+E?%7&hViqmgo=hFfsMh*De9Xi"Zq04-.^^]A'KHXAd_%n:$3gOp
`TTJoTW3pl*c/n8!'Je8Z'=!\`Ijr)J+`TMRgbKu#to7sfpZ&OfLqBqMBH7sqB<+FE2Ih'-q
5h)#bN__/804PE(eCd&Kp#h/+&n=31+oF(b6U'UC0oi)<3+VSemo-"?Z%\n$H>G`US7$>;ES
eerAfOK:VW"cnhl=rafBV,RHXUg5o_Bn/c&b`.X3Q0h7kh'CE1UA6Snos7&t$SoeXn@CGs!;
\Pk`)+,XBk$]Ac?f9]A%Q+DKiD&->I'P>Mnukj-gO+d^1le#d94<BArHGYJ^BB^JW$k&g>.fdW
Z-pJp%&f>#4\>Mp"=\1QEshGF=JgKlXUYNW2[1%:n/DdI'JN8)u"qC\I!'=O>PP4L7/Mb^N2
>X:d^B^D&=F<FrV;<P.%)C?`fZs)aDh4kO%,dahO;uVsa*>3.%)%o13t')7F]A-(ulFSlIHBk
id_=A#fF@(/_#_Um?7PcXdWbV.UZ7pNNp`^993#K5$P?$WPg)!iqs&'EsCU.B'L!cJ>Wmk5b
e_N`R'$.Df5;@N>O\eI$=aK0Y)a\O(W,a^)tc2)Z1!?6\k[GI_3nOa$&<`;E;c?jIoX^k*0*
[CI18(J%O$E(kh_/5PdFA:XYeuP4>T<6Osa%]A\$"]A"kCTpcOF*p(qWSMBjWh2=HM]A$45jsc[
6OQLCCeWRlMlaJ'o=-XVCEm[0OOfq*e?!c,FRd/Q^G-C]AiH[Ne)=q#<0K6LGHlY_r4T9n8/?
lBiuTU/kr1"'d;rkdo(m$s/V6Sh#Bq<ZcO8K7mTi4af;Dd-d<A[<4`35rn2N`ekIZX,?)4:;
1TgSUhQ_m6N!b&ECK`Q%g=kl=VTfN,X=[dR#$jcPY^Tn-/LPk3RXoLQXL7Phd\<QSqm-2OP<
l9q_96Vkkpmh,;:V)TRa!AJ]AL84Q.n>Y%AP]AB:."Ge*P$WBVk-qV#=&7@nN\,*(jTG/09\-Z
W=..tgCP#X44uQ2%XgB*e2^^p5+6"bus7W9$^p+KL@8L&',_(dY)BmFL^!]AXghN1#3%IeKkP
.D2SDPZ"48`+RM:L3>>c;1]AABE+bnW<1GdCSZ)*.W&-:@t6NR.p%kJAoBU^F+j[cT:sH&%9j
bbaL)rdhG/$.(386\2-=7WG?1q/j[^M(n<<Tgh@36g@`j8]AmAgo(h[PNc$,a5u26Tdtkg_8(
"P&'02@`s('*eVVggr"MCQ4K0(ThOI`V.e&HO#R\=UfmSBo[5$`L?\,\5$XnZb_6EJSl9BQA
VLkO/7S"g:erq\IOqaCj8qW(Fm!h\%Q<Gb-h7V3<Vb7k;GJE[34Z?H%jO^.Pk(l'L+B!B[g@
[5*odLhXsRLYJfaM=g*LSZ.%KJIr/)B"Ld;UO&Qsu.oP+OIAcc96g;#X?IDRl!,GOJ\TKr$L
=\ZhM7%IU]A$#"QBd(/TB[3h<-fd0u0M=2,)PP9hItsh`nA+[,YiUQ=0>Pg_BY,&'i8o#qLi&
Yn^CO?[-0U-*;AI]A:l<0.+40DE$/.kj5l)nTm>u8!AjR]A>bQfCI'161aSjQ5Sm-LJ73Q^dVQ
@bWpD3(8CSRh=\]AE,P1H,B`W_aX"dlR5#'`5(oR)EN2jj@0XHPk)<&L<M<3>-s\@SICqi>5X
g<:CnV(oRj$/[R2Fr`D/]A\aW.1*+c@BmQY@'=D'4BI#1=.rm=C91!4sJH>e/Uo$!A9;nK8`6
p?ZFsFHNU!m.WYXV4":`T.OX<pP5ZVMbp*9X\ST+.r^p8W"HW_3G>8.F:tcc->,n7h"M[YtQ
E6pB]ANTgfD$H-Dmf0'7+g>GCM)mi0N<15-qTkb1`I3+p/gHh-nt\oa;/*c%O15BWBYP((#Rs
lqUftt['1#pg(2W$2gW/;!K(3[iU;3Hp^u%3\Uu>W^E$pTp2AU/uNIn(c_kklB%W!OC'V[8%
;X=pVT".L?s%B$0rQYWa538BBmC'\T4\E%7fllp#>WD%:^MPpO(>E8rq0"b`Y5>SgU6<$5Wc
3Hek0DFn`TC4dPpdaA/TICBP+2Nr`'YO9AaA[V3i05c+ohh[XdVb$U!U>g^#VL:*cX%81q>0
rWnJRH6QlCH%YPdjQ9F2@\3i5"9"Lk+6SC>=_-JHgTj0=$b[Y:e>`NU\/9_kD39uN,bXq7p\
[R=/#[lSNp(dWZT.j>c>3NA]A.T%q#2.Z,+Xqo?#nHt39\JHPED5Qf(]A$-__8/q1$?5d;&qQF
.eq4mYYR2C]AdUFJDm3uKLRn%Vlkf"&7F-BmiYPK-jT_=;#0hW^Gf*.juTpRF?%f<UUSH'U,%
S9Z=]A92BXiacKnTC(?t:<H'U?V1`Cbib/6;*&$<7s'Zm)m9:psHmJX$QK\iDk3I*^W[J#"m:
OcS>-GX7VtBEk?r3")Y2Kr2TP%Z$>kLsc!.TDX30>5oaX=>ao2,ie+s&l(rg3S2nIlN$^\>?
?8?65<f%d1?X=Jd7+8=sr+O\4s^Z+`@6dKn\7=lBi/]A!-a9`'Vf'0(+-F8GAk7mLJdPf7s`h
9D8<_s4SO:D:6X//]AY^.VF4kNUneQS8<dEW<_7Wc^!d"!7O,[^0Rm&%#jP3&$)AXkDKK=U9r
=I(AO6_:*3'CD[Ks=X9Bis."r:JBU*3^:jA'WCiVM_Vl0O.%o>ql3Rf2:38AF7Q/s?i7$S8k
+F(mA\fIh-A'Y)XIQ0L?$@O3!2debTNJhBF\Fh^\:od^M9P,>YG6;&[=a1i6+9MHj(=HScJq
Zj5[^FXa[uh6N'D)Pq"?ZF;co^th'M=P;B*'$T2<7h6#(7a#1!+QME(pZ<qPmInNhM.)#MhF
_HmX8BT*8$sL#84qmCiS!f=-u]Apu@gIFg5lZomJ)`hToW$o_Er,Th+LQOqmp+mTD$lg._Gaq
3[>MD*=:,e^<125VM$#NT'ZE:H`-]A%>$aGp2`07\afM<?U+qs`]AXus5'sc$6s#!^@*,';HtK
9<"a5P[`r^hCB.MRC*skrX^[t>Yl)(WKVX'q5\,tBmfYr1"Ee@]ACNJYkKmegl&5e6?5hc!7e
G>r%5=f)kAVeD+-L]AJg'E=$A\#AnflE*_GfT1:/`&-)276a#p/M'`$p%kJ2P!_32('TuiAmL
3c05mZ;&=S*.O=9c:qe]AQ'mb@2l[).S(U<_E!g&>]A3;KWrXJc=Y=D2R3d#O2#5MVYj@[Yn:R
+nDCqk`m3;ioU[=b9,e?dYHOKThi)C$4iDrEB0;kecg-sGa//R`%>A(`K8'!Ui9'e+dhHtLK
/jY?f7SB0$S=KTMm7Bf<gqrsX.6&HM-9m&Gg6k#SQ<UZ"fI'\2</N<U/suu)p#jsRuH.(I.<
L':5FZ)OI(>r<67Ak"Xo;T?Z"ZWqo7Vie$-CS=IH/s\(`.;h2f@+Zq[unkMU8jQ)J.Y>En"`
RnpgT$-_W&Zd1Z<a0>@@;XN%QD(?(Zp6k9W.^<I&2AAjbMaf4Ta#9-bB;W*t=\75^7t640jn
*R^HiQ[[I6l"D@^':kr@[)@jfIoNK)DH)D,W4*cim/,!sb70,+3\0p-#;PS>k.d9Op:cKNn/
.d:h'UoDu=8Ya;]A\p'3)4e&3WH@0bn?4;$'To`X$cHFf;bEIi*q7WQmLJ2HB1EC@?k.=8&64
AoG",L0M+-W8df^H5.:"Z.D(,*BcXBm,E@Di]A-eX!'g;8o6')*rsR=ic!O;@:f=f++=;NAT\
EpPC,448XnsY81Aso,,O@R9UYoGfD%LN4daru2DqA2DJ/[ofP=7p76I8[rV_dLC<A+AX=058
]AGuPJ4Ae^K9;q'6Sh&C=j499"-PCcZ,b,*XOl)HXYE)9_-HlT,2Kg@W7^(G7mO"f\[BVP.-d
Jf\&Ju6A]AO`_NdH%@crD3<qosZ&WDJ39V:7*?Jes]A3JIZ\0<%buI'B8sC78ZfJec"'N>qR<P
SF^4dP6>u26B!mV<ThbMq&+i]And-2M0`ojR^ZG+9>0=EuI)6+I&+(SROP)c2^oeQ.!+;B-;'
p/4`Nq%a+H[b<JfH6Yu%t`-d\;$aLD`4Dr5)>[jVHMO9`r"aM@3Bh\MBLZRkrWp_d@r*d?lc
p+l)ZVW$D\\\F6YY%kD.8!8=(/BF2M&"LW"GPXgVX5#]A>Dm]A&j5nVWO'jKgZ/04F:J?#'-^J
l<oUjS7kWKo&H]AdB?e]AD1i&jF87JAD-!`=8I!5@_b:S4B=-WMsh,!7kWn(tuTaTTRmF'AZp-
S@.kPObnAGQm_+N3&"RRK:Q/-o<rrO+$b]ALn)*<d`,cpc,-TCN),m^?Ic0m;?m:#7Jo2>.jC
MAAgCM<#sVf$no;]A5$^5;DfKnbN?DhQ[$FQ<"d(m9b]A[dhh:*Yg-*hf?4.<hBo>j`uh_Ao%`
YZVW3naD?L<U/OK]A(%e&TM:L[']AiNN[m6.r%gAuZHNqi[iPjNm;$Fk"RB1gjU5u*IZ?Y2-Y@
U>$9gL*rIL<*]A4^2?kk_Klh9<k]A>78bV!q:;*EZp"-/Urg-H*U!l\-gj7B7p"pT[!6QHt+,'
9C\Z"3b2ER["^r'J)NgWq3;lc[<Go'f@oK7<3]AKl^8cG5ikG#IdZ$Y*Z?Fn7OsT=Ri,.\gn+
8q"KG'%(`!lj2<($f>'ZM[p3[KA%=E*t%Dh0WAX[hJo#-F*c10?h>9"^#qYYleiYu6;(4?XY
MKTH_".qVcLTq9Bb9+_2#GUp'N4m374PsbUil+M58.I=s9*.eW\^ITT/#b[iSlk?Kks"YBCY
]A"@h[IK4%Pk:S.)uD@H6nH#WP?P)SH%G-6Dr9"n3",FV>@1=f)O,)d!PI@_at4,/8mjmC`rc
k9fXr0MZ$b`X@B0EQWW<Zk2-ZOI%Mj4tLu;`59&h2>YKd,1N@rblml&3<&O=W(>D=odM%7kg
KQ@LqJ98NONA?q-SaU%?**C'pX+=<)Rp8B=!O(q1?pci#mT`Of1@t>]AB;]Ab+UtP9l2_cgJ'o
0VKaSB\2q:iYc&k*-ipr@Yu'^2__q>%T#.3i,.*%6eaT4_H>Um0TNAa:d'RM*U2E1nF*.hYp
1('Yc)NKs+Q<bA5JaD$^]AAs1LGh:gMP)H`!<fhgZ[0_roeSbechX0>rI?.J?54Um)P9F&u&I
`1=2&8;Tn7-si-,K_\7Ua2j>&p\FHUI4uXR?PNiY-]A_"%$*IL9nSuZc0KIK>SI#R)_N`Y7M"
Wu@mU?)4N!C.MMB>K\7[[CW>QJ!!.->^34uFZb/f:kK$uRIgcp/k-f8<0%kG(F55LFHH"<Bh
h+&mh%Fop'C^G#3EEW/#JmpaIc?`(R#75nHN9g[D/CdsonO$7SM:Mm>qEI%]A`2L%4,&J3f9Y
Pd5*oF<<%cOkD?&+XJ>3J^G+T@n@j3P3qrQg=*?s&?=Zo@6-Sd(U=K]A7scdI3.4!r)GP7$OB
+G6!A)r[-Sp<QaI;HX[5mr[YWho0K(>k\KhTctBpe3F13^^5P:*VcB,3A_djNSMeI$U@sa@D
X=Kj5!^k+F'TlUFb;rU/@C5Ljk^d?mngm;A;-MC&FrJMUmct]AKnS7dD$B_G388gjPh;W@''a
Wu+J*UpcS\rA7Qm3_Z<W(E"qMZoh1527B&kSM:Vl',oWJd\(n(JemE?=5Y`)'N#B%X4hjg\f
Fa5P8$10B(0o=(rs1LG+]AV6BM/#$SSq<j[>!$R9k2A<6p&!>H[^l7sH-1kn*+d236D!dG+YB
iK:9fpM5r41GiY^rcdAJ"rJc:KuCFO,:f?2JAq:._DE<t?5frc4dl31e\VX[8_`L?U$L%>J^
NrQI<&,5?u=gNj<S2a:Y2ekJXY,aWC:.?aAjH2>1/r!n^d#DJkK).c/q3FuN&3;th\U]Ak*b1
">I-nh=g02W':!q]AV7GlIoW(1#5/p-4%CMbFD@mYBg%@F0hK)?,aeIM3E:ncX\3FEnK_Iq/U
t[3VE[hOEr_&"9fro;Wb++%\=/\U5%G&/+A3q1(T%CXhWE^)Z5DfS*HrIm05JhnFAN=7Df:4
20WcA4Ze3AqLi%D=KL.!<eNf'-Zd5ao>dK#GR1"3Hm&.[$Jtd#%="jCrEiM-ilqaF@:?E0R?
T\e.be:Pb[3Nj)`Q@gUI,4kqB)NH-c\a3.To('AI4id.I9aj,*[."Xb?M,TqRe`(2KiI$HWW
;Mo*jS3Eq.3LYj?D>YG(-Vlu:AO=m"YdH&SXF*5eh^n\&Gk0)F`S05Zni0QsD_7tLYOTnH/U
hZ8b<fABI8ZY9`nX7uKHgI"Te;IdV5h2hX2=P;rJnIR;dPIM[W[j&G9'<pO8.4=CQOR^(3?H
BHI6QD'FAT;W^*]A$g`>AjH=BD6>gBma]ATTj=^Q_ej1UWTGQZ`WS/>uh8k9*_Xi-l="?iWuM_
E+XP+j5B_uUa*HD'=b3NabH-FpWu\!X'<<]AbFTsI0`Ao'(0D$S*\DX7Y3'R(1ToR\l1U23_j
KNBf@/X3-T0UVZ/Eh,9tYfaC`W6IF&!Ru7$A8mqUK/o.OU901Trp`:s8;P!SHeUg#;ce,7s1
o^K#DO[Om-CFaIEI`X8CEU;OaN,A1E9TH8Lj8_Y@kIOaACQ^%hFm!g2LHFrZdm0(eU@lk\O%
\.da$#UrH"I:VbL6kK`k[EdA`%,p:FLrs!<9]ASb`Y"Yr<(sR@OX;^Z\duF:9r6lGMf7=M[6:
Kj5b,J@(?u19K0/G3@PS0^A=.\RTS[B;NsMcVl,gEMnopQFD$,5oCF#Fo%<dSH+9emDp.Jc^
@Y<H$Hg9EVY4o.@'_/AL&Q%&8`e:R4<Knf(,r#E:*Xt5uYF3">1Q:3#Qj,f$h-h\E`ohF.(G
92Rdu!3/qljBjqHG/"R8Vc`-9W+KNJ+1uqlDl,jhE+p[;?-uQ-IK>m7t%X,bJZffGBu^4(/2
br-%ZuR3Qq4k?6GLT'b1_?S7u)%U>rC?2hQ$3]AKdf`X)>9R*[cLqG\9`$uqU=7RujUV"H[rf
hE$"ci]Ak\gpPt?q?kNg`MTJ\a%I0l<CTn_&n7+ILDI>n'nH8CD^Qj'S/^d6lO;$-lpS.>)@^
!:KMV?)KU-K\1%_!Yl]AH+4iG!:Es,rqp@OmJEKdgIKc;r?/XdQE#+T;>=L=:AAE-B6rG*dDr
(OgC=.@+kngUBDhQ6/2ci&6&hMN0Q.Y\UKI)<gjS$Q!`h.-gHM:kGea+1'r!pl$0AM^rg<!r
_>9p0Mo@_[GN!?a!r1MqTFidOc8O'HMH;RhG&!JPa+dTq\aj0Yrlr$MLSs!HUnXHB[\4<f`U
'r2jW`_qP5IlBAqiiD-##"'qQBElm9BOOM3.8a7cA:2HkMQEN6u!%FKTOP's!Hj@EI*Kh!V.
WQH5]A1kO!L!sVEH;%Gkf`3>$h\-AsVKONX)RL#C:>bA9G?6;^n@qfN3KdPOi[s.VdX<)a%<U
-pjTA6.ngBe[kdUVNnNJPp-2-i_^O.l?!Y_H^,$;C`?2CpP<K`.aP]AQbj%(af.-%=]Adal5-!
1?I4edWMjOYPM<.e2GV>]A4BI6UV<#0L(:6/:LBHOcXcoV=aBNGeX2]A77J6XfmQcB0k+9dXd%
%`00&_T5PL[X+T@?jX8Z[&/:6"kE7F3sle*Y)`o=T#<22ocYK_W!&#`46B:#J.ra(6SoABro
o1tHt""N""=*>SQ]Ad>P&CQR$5Y<=T.m)c:SA4fL'l4V5sMerilA>Y6kjFsW[jrgV'eI#J&CD
-.(CO<)ia]A*Xt\UKV8H'<#dIXOKA.j*b:&,pYf,P`N#lVX^1c"9&q=U;_j?;1ct_<rQJE2@&
i'aK2,g,(^/PVB`T&,_7NhCc-r9E"V_*eGN-A^=Oq'8_*4K'F4KI3sW7H&A230"X>0e70P%U
2Bu_hKFP&ml4tDN5Pr,h"FZm?'1q"9_iQE9S)NY[APgF>+Jp[F2OZ)"r:Yp<lNdo1_Oe`]Aej
Z6!GZl'39g%@L4fl/<k,JZdYQoSNdO#HUE!3>0E<Z+!!nGW>cVt[=gY%hLc8m&#>+W9@qTW$
lD!,6Uqrb3UGGl>67a6^\?^mO]Ad>T@=2Es5KR3_[#Mi:5N@O;5]A1jJm?I]AG/P)4X7Kk#h!MI
D+e"=CBKGEb?T_F3Vlh'6W:mn0?3lOJ4nEnY,<]A]A_(p.%!d:h77[[W;#?_+]A:,EE[WDQ6@5R
FmD[.q]AL(2FK/ffNk<Zq%Dpn6$K:#&a-mfQa961FWAQJqe9Fq9NH#cm`#IbXD)Ah2,=bh599
eaP&/p"B=T9!>4#R$pr7(Vp(UnQ]A':oGQf%EDMJV`kS<?R;I4*fE0V!$Q@r6Vi2K-Lc7VqEJ
DAR=uAeT7,n"??BJnqJY!NAj*?HRJam<s"dK9Y<H$m?)LPDhlioW&==7p-T;L0EXYG2;F'*N
&#'V,+gqB!'.sA@PEO:IOqi"^kG/ATqo5?Bu/fd176+8H,*t><45-<H1rRg'cIh1WcOYhR&!
hX6@b"6gMV\fEe1G/T-S8bimQCm2=`CVa?c(4tHVr'68-2nshW6[;^<*=@[WJhk]AK,n=%#-f
F/H6FMVMXlAcG>aS=e=(mcbZ;feKY*<;4egt@$sXaj.&<c/9>h4t_4/@jbh[`TPe+`1aQL`Z
k:<]AT[3YHSii^T'mu,R@/l@b<L6B;X:\^N'?EOb(FBuW=I-*UaT5@1_./fCQ=h[K,"e,X%__
mZ;2GRD>1<5$Y_+M'\Potf[rs&Qi,L?3?$4jdTBHa/*`T-q/bC^mTEim!&-_N_"CN+&4-uE<
5E/')>eac+Rc2]A,%%<Eh<#&l<";<Ri?<\oN]A!48Jud@rrG(bq9tEnXL/>D.n41kAk!6KdQ`O
i;bmn8n*dpMM4<6.%p!B]AAaJ:rZi"euq[8kKLt\R>Hq3MaPej7SOl2Lt)=92u"g7W(WmcP\h
KI]AZ@A0k\8tcVt-Qr=_J5%:Z[@V+UtJr)gV%ieE@.<A=^e.f(LdkCWS`"g%"/+"^@rDp>o#a
`a&Db`h>FlDHPWhobL&Gr7F\$4)IS58`3Y.m%JhT,(ZBTNd)\.;6%b-?d4Lf9"=aBa0@b-ki
7+dLD!A#B9.lU[Veer=V*@sC:qDM)o>fN^-AC`WEA@Zi$gH#nS)/#)<jbD#CcHn\$E/P/&)4
@K+V/6H'c4hHg?fHD&Mt,E^V4uaJC6;))VtD)82*=-a=WN%_A[PoNX?3qLO^P-8$)SE]AI&X?
3S]A]APj/k"YKHM*r.G!q)Km'Wc!f]A*nE:_i:87_u)o&P_^a#rZV_/"_(GE=UiV`RK7aa6Xm!<
Z.Fd1Ds$&dhs5NA\Cfm=X%XT-@/b@Leq1CJI=;6l+d^,=jRfqs>niR>7EK`*'_6+eW>hLZ2O
%#Yj53;'S(bn*HHHc<]AF,,=c\@$;QlGN5%$lZ#"Wgm:#')Qi,Go]AP/ID,*XCfOTX$)3rR?6e
fSqGC"Af?Aj;.UOaO]AV+HbAK^l00h%G(c.,T)=8(rZSI-bK0T=]Af1K8o%RN*COA@!]ArdcF%Q
[X?"2mj=PpdrTIXQJ0Ho6`+u.*CM,VA1&tHRdMO#in$CY2l+QF6*,;cf]AQi^?4hQ#MA?s%c5
)SPLlu"dDIHj^3`0#$]Ac6^Qe)`:1jR,P*s7tu?!K(O[SgLcIqX%"fY!F(f@KMh=rZ%]A(<=KY
l;oT9%rkp"fkoF$@ud0J>Cl"7l1&'g_;<l`)3CLr4Q=Ce:W%`\epPGBg*((tFM,3%eK`i^rc
c3-53NfrV+gY7hC2Ku>_$S2@'Q40_J/F/9XX9nsIYjeip3'R>QElOPa)\aq&$1@m^LAVR[YK
u;6nYs@&_Z[?@]Alg\5>IPDuAR0uFd(.Q?alVo>5D_Dh<Gt1i2_+hY/_Y?@R:g;lI.MCGS'mr
Rj5Wu52&%:<iTEr.%iC%!1IYJ0_jUR=q/"3`QjQ"*=%>oDk)G'`==$[d^h8%?_8cbWZZ7t-=
eAE<T+/HefVp@ETr-UlCb,0&V5fER,hdc%kY#VP/?I'`5I'1/.Z4,[J7LWYEY_j^]ABEOQk9,
F41hQd:2XNi/8'HR\9A,%bL/>ibXW56&Xnkhcq/E-0_X!AqQN]A:Tp?glM5D6GoPiA^\rocG4
$B^#NGYK4I!pER.O)p(ZTcl+K0Z4ag_J0?k!tXkTo*h(`aUKl\_r!"'"p]AU)UeihAQ"*1n6j
pE[\Kn'@H8o-<')2,Je[(LUDPO?(MFDMbJ]AH0=+6TN_<Lo:4C(:(-,ZhKm-cR;#A30)3YL$k
!Ab8gUh[on\Xf-.+Z0It<:3/"/.i.\'o3H)teI$M'@:JW?K3r]A&WY\"pk;[<bc.gWZbdKiAS
D[M5DRM.eUjaq-aBANuN9fLqcS(osjm-Z(L0KtV'reSfLp2A%gnCIRJ^Lif.'@N]A_Y^2WqFG
_)(;lV4B33jJiLV?jW#Jl6Y.XAK&mK-d-DA:q3LT"L$TaK8/eFHA$bIYh:JuhjP"$)Ff&G^j
C,@R_7QYaQqiX+Yi3E!nNKjCM<rjfs/9X%4^SR7ps&lc:j0=;t&jc>M^sb$1+2;.[fm?s[`W
'd8En6p;qmf?I:tDB5Rg,L<7PoMJ>Qn3pKj.'88@GY?er-El\tO=!\F=s&oN#5!O)M)[]A!Yi
U6NuJQ-7/,[AsR2XaBPb$B>dWQA??D2rLA65^?2&(h&]AEQ.sUp#ZLcu\R`49G-`\Cf);Z`"%
p$TAR[\LE!P_d2M'2IbQI]AfT8]ARl)EDV?WRe_4C!c!.Y\2[DUI`g.FQhKqZ#O6Zc9IF@8W*e
QmZ3CMo58On>Hg>*3:Z(O0K:Y27kJ=nITZHSW>0E1-6>'oYTXt&Bgf$gF;hjo#g3V0dAT\\_
#IR<0:aN7V;<WWHb9r;^RBM7Oq`"C+\$FlBFab[4J%?=hHWs85/e:pVI-"uaGHk5$j-P,acR
G:b+G;<uaITTQ;7Pi0=e!H5:,"js$\o9[$V"BPV,Ju^CkN395$>Mrgi%\9LgN2HgDk*kT5)U
Y&5s1;(]AP.2H'3)"V:``McK1LcCdC+#*IEBl>Q$+bSE02j5AQpZYuRI%Uh^FTR1;;A1u'cS=
3uZ%nUh&,+h]AD\E*DC)[NPu"imkr4e!MmCpg4E*4gp1%p.>YJ'hTjMmZ_\pRPb,Rk+O+:Qa,
1D?@KX2IjtomNR&]A*,X-HN?uIf"7>FH1$-t".kK_HXF*3C%=:g1-='m^l)kr?K$Gq@6,JIF_
+"(t-en"RKNrt7P;UVZk>sfNE";HSI8:sGp6Fp#d8V7j3,(l#8F>F%6,Y(B53!Q.RV>njqnG
A.<I=M94?G#^[rS4<srAj%$S&jD64ICmCCR&hn1E<6/=G6VD#i2YR-enb6_Qr78bRQk"1)_6
`nnN%5@;Z_\Pt?=%=:i;2hIjk8=@RSm:'V2!:BV[<m-)]AM%j%qRU99"8\.W\r]AHA)SkGa/1S
<[#pc#g,kn5I8WEMejC`toEPar:Oj&?D@fC)L%Jel-7WEp"FDTC9npinVXXf9*8HbmJKRF%R
#UNC;t(6%!s=mcFUP%+]AJOI<5#W$e_(HlUci:5GBHD@(^['oC;Q1<Ibdnl`7BCMd1Oqk"YP`
Djc_AO\-'X/1:K+CVS-'7ang_&QG-0:BPm;jV[9e03[u"f!'p#Us?CopDF'HV'3oE-Gr,Pb[
-)j@2$Co4JH7lQ1st>2lV553D?"?q0/l!1.2O>NsDs3]A-<PZL<EBP^!Qq!Q_h,(5'Om%k!>s
-=7U?=4@JF5de^WPUplF)LoYi:M#?j*;L*m?C7YM"cGM]AXX*>g*TJMV(Yi^UBfpAkY8G1rKf
_KLeWI3kB2X*,@"Hm9+f-^UIRX72NO)ORJKBpAq42CAp6FuGhim*0pP&%JT`))"$UP^e'HG3
=KkJ.Q?(r]AI2DF3a,'g;QkF("MQK$;)>*b[hn?"rM^[/gp0@X8QaZR$2k17FYp1=B@2>W8XS
kE.nY^Z(8V&!Z9L^09.JRlf>)R2BK4@ao0ck6".iP$MP>qPI]ADkNGZ"'<&E@d;[rI=sg.$p(
7qT2*>!UYm/04TCJ:p8;?02LN`D9)Pbr.qY.fNX)=WBKL(6>4Lk6F"]AR2EitsQ)23HSY]AJ>N
DXjr"VR`?INgUg7)jORO<K,Qg<9Qirkm2_KV1,#a-qSIt/hmQPM>>T4u[t&L$9MeT(VK;]AIE
%`h77eOkIao-??M$rLTa5.gkotQO-nN:69CVieVXLuI?RCTp\q8ppG+T-YX/X*oifA%kLN:^
WKIqFCTb'W/6`HDPr;MEnNB#8e<$Ol'1c*)upWH]A=4FXmN.N>2!k2"[ss4N[=7:GgFtl$Lek
R&gS6+F&fcV8UW.)t*h:OrRmoS45<K=t_b-arjOI0c(E6N_6<uJ=Y!7G>;k6l.ET)<IC3!O+
;%8Qk4Sq_Qo^6PUhj8Nrr/CVQlB.rVA4+&fZPNh!*M6Xc/04:%]ANo;?bfrUCXA??HkOFdic<
Rn*9,;#L[P`Xk@C>=;N*t7nNcDHC$FRm0!P@;MoXBnY[a@A^F[g&a`ph7TQZHM376AWn5!Fb
M[1na!iD\m&Ees1@UR#rC9WU(GGch3^eq"WDb+he.;Hoj9*_b!I*#.eC.puHqamUg%f9]A%Vi
s:!cRsp0-J_hk9t]Asf#j5)4;-O\l#-k6er!-Yq:t.J6]A`?aM]ALrnYJT_(_2FLE.8<=L[F?5[
TH'hU?\r=s-b$hC\2X@#kjL<)Hd>d\Y/[a)cpu#$_J)is(-BBca;ic>"F!\#5_=a=gMq8qgs
7.#`?(VHfQ3H9cuEN,due`2Z`cJR##fLqj-3L)TAuZt1HYoSpJj&EU#hsgSi.*Yc.fl8EiC7
j^m0[>mubJ0#FWMlZ&%NI[;X4R?,%^G(2I9taX-+Y\'d(H1Xr)+R'&fYQ:kHi5a@&sY$[7>)
d5WVc[k%JCa:5Z&*r3_`$;?*gRc`/(oH*A1q`"A5`iH_n8'tE7f#EhHl>ND]A`fBd*"c.D)3j
[0i8(f&EHVN$W*'bTmr<?0%qlFF))tP]A\D))\\L&]Alk_!ng#-e[p+uDU?4Rk0*>K+3CJRGtO
!?"U4@91-d=]AH?#lQ-*T*gRWF6_fQOBi5cW^@Zc\UL]AC!;YsKd+'@pZ#(5CT.o)-A\&)cYlZ
?i=<Z]AYUBLQd8O+.tI1@9*DG+V$Eb$F2&qJ%5BN)WkFh`8rX&O;c::^"*HqC(W59BbE-es(1
uokG)?n3qF!!hN.iJ61[6SquUD,FK8tm(0#tb#`qKU3)h7fOl!S:=/hl)4VW>e[l+C%#M`@*
gA'L_io&sM#7;>iu9O/cWM5(b^>-HeT4V^)"<VAP(g=1)TL,?5,$\h<#8qn0&rOI91d-iT&(
O)0l80DY>sPF]A+giTJ!YspO?k`=ar%6/(?q"nRm!)*4,@RS]ASt0("N2NIh5LATpK1$5^/dOK
KaYs=4S\d&2t["(3jQLhj:T(S7MMRdOEcJ7s6\q&W$IH==5mtcq4E&'8dbH5,GTdI]ATer!5F
foANe@UG:M3rI]AN5'._R9h,Pf1YWb5BIDdJgJH"QX0dKZ%smHcVqbY2XCLBhERDMpueK?S/%
eiV'rm5)i0c*0Q@NAS>?>rc#@E3r[c.X.EDRSiQ57\ZH_U+$5_#^JEs:;H;uX`gN&sH,+Ik_
[q"D`Fd6@lMHr1WN/kLft$4`0fDQ]AJKTr((u)`?eF;6oYtD9`bD0J[J1u[!\D3:]A+*68$q)i
c#A7e?ceq;g*q?.%iX3J*Y6=cHUdT9<G]A)GliIB.d5#VC,J<]ArNfqP`>P:@hla&Ciq\a/!CL
9!NKp/W;uDS*N%js7&2lDQ&f<:sD`e/s!a2E*dLC&#-h=bLpO36.@;5ka@:2)#qq4VJ]ADrJ=
7'LQ(6`<^"ae2.)&kL[I4JR(UDE<G)(l7imR'Voa3:k`sr?gMur^9JTm8A3j<r\3*R;jghI$
p&`s<pCb[M\ol&-9I8Iib*l]A$*m'b`bZVCDjN<#IR3o&b%]A7p'X-h)43!N2UgFX7b_4B,UV2
m;/7FRTgN@X^Y22YCqc&MqbFE8$!&'qcjDK9rCm@g=T=5_RB;Fk(!UEuC=k1(*t?QDW_ra0!
;t^bdiHP<?B&0"%EaI9oQ`^2ILi&[0kSX7sP!rAFF`*Vj'/'?p"\i^*:)[F0hMpdmHb7joEU
jt.b,fj$nHY*3'c(^MYZg5j3ii/kE^<m2":Iakk"+MDEp$bX59RakM($_MFP8UoCCLb`>k<,
DpEY>oZoG:@C;Cj`8VQ4*PXmQF=fHafpJk*II74-Bcne%=\:>qTq(-`RsR<]AXbFDF;q9qT=7
i=Ub[A(GZq^'oPBc19Gtl(^C,CbUR2`l-[@nBE:tGf9W.BPV!(_3aWP\ieZidD--/q*Uj("n
YOfDS^V?tn?a@=4MKKjD389%6)pAA,)t=R^e9-e"qq(/U<;Zi#1VSNRelT3Rp)a25sjP0PO^
^H_>4]A:B6i*d]AD%Z(e3UA`%afuu4r(]Ael?:6^/.30&PAp?T&q#fqq]ANs#M*W[mI![%#"=Jb[
3n76,QW5P)IqJG>+.cK_0pH\<lWY;d"9*a$YMY'6eml,%?q;qUQhe$!EC"p7(a:`ckq-3_Xc
HX)D\O.h!"V7ZWaa#OT0:hDr-)\N]ARgF?`b8QRejERV(P[k>R+R(lpuGndG5M$.G8!+;O.on
"3;hUR`D"#8ggJVS?BH*?qnV;LotZk;KNl/rcX.itS-_^[]AqAlhBXS'A"&0,kW)*4&6qAbb,
o3J9,EunZ3[(S#)qV6]A+.Zu$*S,U$Zf'RnI))YFrm%d1RUlsm1V=oA0C/3M.TpU1]A"L$EaWe
IB'\'E1KA,6,CS*`C&otapfP\h/:AQJTXTXk>U8'g[4HcdLlpUJHhla$m3)X7'P)aueG'Xpq
PDRV#r.Lt0Y#bGaU&'GO#s-H>S!8&j3kI$VM_@T%qiF##Y1Q7UWV<:gL.NXe59gX2oGrMRX#
a7Wn/fUuk9b3F*<SLao2L/jE5pLE[rWRd[_",32'mEh2XZef2@1@N.!>4OV83[+E9ShtCDaD
T1jO$PID#Q&U*N(Q5odqb<-Q0$k&XLZMZ&X5,Ccj]ArM,Yu2'[6mcjI,]AAhl&")onR@22&`s>
YZOD+@Godm):os*m#S\K(NHYX.g$he[P);14/54VY9"uWj[\d,L5t+*[A'8`'G1M#,1&<2X<
",+ongQ#@FM8:hcbVWD23WD,Mj2;[r:;CAtFMC3Er8dn6S>5Kc2>'Wkf5#[Jh@oTF6leU:9i
RF"LRjH]A&oPd^B+jRQ2b*c4NY/[Z6I`sm,>U<Pi5r)';,HB'gW-fLO=cYTIfZ[qi-_jd+%s6
H'>HctYYBa4Z7Xmn^%5@;eE_E>k)\O<,hCea=?>q9`()TQVFF6RVSjAtc&2eGWR&O&W%m5\J
dYg\FV"tis"K(l5K*rP-,,VS%pbifoPEMjHb_F9)9f+Df2?B6c71rC=7+Ai]AMk@D;+'JI)lW
&:$m^rUPGD^=#Y'F4Hb.;4,o>cEmO$-tBW1!K9h9quhhR%Vo]A`.-=ZL.8b)In]AYES2Xm#1:7
-pZB6h6HKS9b-3TCXi]At3XXWJFiK(0p95rFH]AeAT0V0W&M)KTs9iF>LAun-;t_0!Sc%hg8*J
i;!kCQUd9;E'::1[J$oK&Y=WH<p(RK6<0P`@3\_A.FSc:bFVA^E>o%SHZW_Olfnc9UN15h[B
\gJY/%U)k;UEDoPE#7Bk936X9_!os*:$g<j@F9pYg/:I:8Vq)]At5^`XIg3?15;PUi"kGNA0@
?&aL@Z93.RjUq7>#VQ40UVM+S6b53$>Fufg*H4c0h@n-RKSk:uj01aB(0$/=NRakh$^A*CuF
!rau;gb-o9Ht!.M^F3:;]Aupm86)E5`Vn\TSo;ksWjZ=pZYd`UQk`Q^-6E0OT?+5^(V]AlK:RI
udSR9C5rA<t+2/O,F9/j@E:8:F/KonV%nhA;;c]Ae.hePA$b&nHiE`0U/G\Kg1rLD1*fU=4IY
C+co1[?&Dc90TpY%"<m4IT7;BnX7\ZQ'E*;eYIb&fR._l&)"YN3i.?^ISoCc_M1?1G40r:/]A
SbI*lH#mOiHPh(=I>\Su>qsG^P'I+1cSId2^Lt-ba2D?W=`#+Na#mf7-9gSiDtn_<aT^)F*a
1kg[2`S3-`^.W]AT&X)N6OUL`#qBhD+0`\R9oVLW@6G<SmDme?YAq$Fd#Fb2`]A:2kN!QUL\>F
b<+.=h9ZYjMr:3\P./6_Ms-t!un?(0,&]A+)Y@@A`*234_3dgW.R+A4\gQ/'>i(^Ba<OCb"fc
TKeHF#qCM>R2^UQG&e5'tficF^RHRbR&]A4MLS;T5jRZ9al0Pn$ZkEp;d;debaC&aPdi)@"A'
EtUnk/AnqSj1e=tg$65K0O45Sc.COdFM%^=<53CnY6$uh1743&DjfoqGJ(L0K!baH0=QIAT7
@1,H0qNFUL33=F>Ei*]AslB[C2]AS8r;5HQ@']AIDPGTQj<,LLAJp1F,A-=NlP%/KlPh.=X_48/
kC1?O"PoVuTf]AAD4r2Q0g'+XXOr)hTK-C72_>),7Jk?b4sO/_#H(o\2h_kj+^8?B]A,>Qm@df
<E+'*B84(Bj8'O8DKk,n,:F\E,,k*\c"IJP@Cg8o4WSO]A,$/&4@ZH%`/oe!c)BahUTW;>k:^
-[g+mFW]A#p*YfKQb<(caqDf[e^&&IA(O?K!3"EAYe4U_Jf6!TL)K`I8-)$a$aum1<DpefJZD
K'@V(i>JReGtAh(js20.58h;S9GhI6C32)NTsCr\a/s;RP+(L>n"S#ge[G'-m$FJ'W90^65,
XXu@14m!`HF5Pg"Z53MIVBqWti5JF?[1++FG$*Xe_cn5QBP1B!GnAS4ecEP(lou*p]A825,ic
G,6*3rdsqaK-6;>:/$WCRV>qjMlTIs7^\M.u!XG\i8)*%.2'X_5&Ah^G-"m8NTTBl+Z\Dj]AX
;K0"VpV?TgOQ%@Y31$WnMLgas-9oQ4X%nQq+`PmT<j12oe,A`rpaKtcpaoD+rC@)9t=2.VV1
4WPO6CId2AFC:TiVtSA0Gk5lHO0do4Z>mZ5MUgJmB1NpifRN:S?,P5u#_nI,0,b."(%D_TTd
V7lUHqj)#M/+?Tc()M"NE'u`Hd:aG:P1ir.6L;#bID&omeO81Ceu2CqL+!A>WmO29oNRYDN%
u&`F%gM@136<-B_#qNeEf^q`3Z/ocQsFAE<?@`?W?^S:dX!sko7IpFLp3q)5B:>`L55QSS;e
M-o#\@ni4c@1@4b^3;S970_46JpR/48Xm'N"2$JqW]A.pPu)V_[KI)FGcC!aifa`ca$p'eWqZ
T=X8f$HGgb&p^"&Q&jC^pC8_Ka4%A\LC=8]A*?s5lr#(SVlNfo^W]A"kCl7.Ol,Y8$Q,t%gKt(
hTPdtrmZ;+#q7D"d@Mr9-+j8=s&L/<sdZ+N%]AmF#@*I^4+2[5*Sn81V-=8C2E)euse0[An*0
R<@?bA?D'ag@dL;d)WTiM<6B:r'A$Z8;2ZeqJc=n!FhXqB%UB<*7&]A[Joo`mIsdk(Ce[#972
+dE%iG1e4&(lpi3ini:N'YVkWI^0B@P.j]A4?>#Y0IC;NO@n^90Q<l2>]AR4&fm-`e&,td,\C<
;?Na5.-Mi6Wd2EM*O8H`f\SHC_Krl4]A'.sqEOj^E&m)3kV^6KWCI#d4GS=#DtDNQIF7@U_r'
_aa<0tqjP,G-RMDT?CILV)0YUZmg)na%OrU5^rhe<gJ"/:B"P;of_Fr7V,QM%.S`>\V55X?$
"5Ilb+LUo9S*'!(kN]A7eb-mjGaJ6d,a.12Fq0Wf,Ytr`.*/iIO-$O:o&W#_)H<gS-IZa!3:k
j.440o'QjSD0l<+^>YTpO0i1qW9!b%$Lcpm9:_lL(ePkq2bh'@?8U0%%mDCie66WHNt,9aN#
HQe8+&TU3[$k6$U#IaRp_X#_#6)tXG0JLGr/Hi:a&.*]A7U4G`s%qL#Y)]A`J-,qQ1%kE2*n]AB
V)un\SpGroTG<Ld+JI1]AYT'MCT2@ADW.=^dgY;6.7cX(3$bO.4+@[n=Uq"?gfqDbVBCcRie9
.hs:7$2njUa^5X5DgH#KJ5k[\+#B+j#Kf\>Z't@hnB]AM->o&Z]AkNk4PgX8/?cj&^^?6t;c32
P6]Aqc7(G:c^5hUrbdR<(miD+dq@*S%Iu7SKmKI$rP!54fXm`S'$3NA3u8c;FHTbU'%fc(*.*
@hu.?)V;0hm#:n)H<Mp(`(]AV(h2Gu1gI<fq72f-?>HYf$ii_QU6OGrABWlh3,r):Kr_2XPC7
<9H!1[@H]Aut#&B8[pqZir`@"Rgc3d]A9uB8(#'>GJM@N?WQgK5(jlb0_=gp6!S[hSgQs)LHDo
^;"9'72_fcRWTDa-0".]APrA[5\`>5?]Aq9k?aRcC/N<VNBhRF_53_p)8=VNY;6MUg*AQ]Ak.7W
K@jd8VoU@eG1)d.7+c19f:2Ai?S0.1s"FSQj[m)GK/-n\k3?:D^J`bSYG76*/Z+[*chmBbE[
(Hfq+aTD5ifH$"&!LQdKoW049Nc5h?eN)6^bpTJfqZrcRB!a*;"(E,&9]A"k)2[XOTP$[[;<d
7*A^>n,#X@Mkcb7CndIurC,W&c;pRS>7>8+b-_7##;\7QRr+gLDT]AN`MfYN5`W0!pgVr/*4N
\TA)LfHabpQL^jLtH[<ZeLiK6o,9U<j=PHC`-LfBgM'2SSTf^SjKO<\%#oBR%k#=fc*47b3U
2%hK#IJW&6EiB:(IgS#!r'"JpFjkIgn*GiKt>&YN4<<N]Ae;7sT:!*&ucq)$<K?QDK[b(Ia+W
;/JI*_fUo?\pp?R%VgDV8`$%dZYB5\YJ$3Pg)$F)6oC4i1t^#G>iY3!W*ck>J%0f3^9W>mXE
dk\XY#ZH<=a=C#nC%XnBq]A0)Vtmr$.io$(P!Zp4@9<?iHaBo;c6@[=&,N8k7V"e!jkiB0j''
!e-)?Y0bSe7s$tQ_+0!bH*`<PaKFr6iWrn/l&&!"kmR>O=j#67qmuB)n1]AVV9.m6.XlHkm=#
0n6k`[42k2Y%MI*W1X^Fe.]A@.>+_Xm"_ujD_oRY[Fai7"REmaOE\3V@Q?jF$!tb!L:M>lcd&
iYU3s]A-DfS,!0n*L?3lqW53o7?,*FcL<B0s;n%:Umr)YXW:>oS_^_8\EqCkW7Ud2h1]A^L.Z\
]AtWfgNioUh^ba7eGc8B`S8)29HE3Fj"Tt6=)L`Cs-YbD"+>6g3]A\WhADJk@cdCOT$%3?&DBU
gN!;htp*p*sC`ORIm(5E8=+c`gii![+A79kF&QXDt*6;X8e^>t%O/=0bF]Ajd[S@FbfW0_Rer
kO8OQM]ARHhca5S5)+!deY@O$p=-JNG:s+N1g<c'oUTF#Tb5.>CF,Bp*p`ZEOM.OTV%M=T\En
!p]Aq24[fP+tkGd;dubP33"ebja.Dr>VS;H08U`XS5$IJfiO%s8;^1^rN]A3k]AB;iW\Q3n"c]A6
co?r8p]A\C?FB"2Q[@I9)84@J:'ifaG8nph`!8+oj*i8%Hr,:q8@_#mH67:!sWL$J!D/`%id+
j@EuL'u<+&&(aD2QC-Y]AlQX"bkjqn)t:b2KX98G)>;0hFISMS1*Q"<WF(.!AQjm*;'*a8L>-
u*rS+mO$Ad&?3u9Df7e.IXJlbPiIfrGn1n<Rmh$6JZHOM!@=`4dg%VUrl-Z/9SUbQ1M2KNCn
l3H7e(*>sn\*m=LJbpRZh_3:rnR(pEi).aL:7p0-i,hNKrOBRh7j<.Z(Gi*UFR*2*rRHY:G?
)@ppZ1oapBnA:G@bZT21%TCo.7%EMfJc%Q.(PNHaIpomQ;tH"c[Uq-)-</g[!XAMo!n7EI#.
A'J"cmK;)N+o3Au%]A:i@![`u,LpC"=oJkbhnd/X5b*[JHmn_KSJ-cZ%gY./jsP+JEQF[<?ED
BSpoWE"qNUDu!U3Ni[g,_A`j[QSmOZYs^pmS+dE=tQ91oic-O6aI_C"XI8Dn@tg2h(+q3JuD
^Pj>KnkJ;T<n2p2+mg=.9bU-&LLC1Cm<]AZ2)'f4t\!Q:IoS:!>DLnfB^'i?p=LKt)f\7pHU2
*$R1qpY0`UfbVfAQa&J%a&\gXd?6fNB6U3uY\S)E%QtGPg4A5VS<SS<q6d\JH/(TnO]A.m$+o
#h-le(E'ZFSpWD=dY,k4U!NWEZo*N??'-?@O,5jN88QWMLV\QYb;?r-Z8\rAU&Ok(4CkD[8>
DGYJ!@B>'s2Fm9u+p$R?>cf`sp[KW]A(k>oR]Akj-c"7s'p/k2)A1iJK.IU'Ykni@[V]A3D8iX,
rtiRhWk"QRFRMsA"^!oL>3h]Am=AC)a[iWq9DKo>J@;6XrPjZdV"$T:fs&begla]Al'$+>$p^T
hA[%ol]Ar=TOf`Gdk7^`D^udm+0;>lAiX0+e(+J.AZ?m;aj3pMkrgRGlk-2SR8CiXFFolBZ`I
g]A:_m*]Act4(nS6kCOF*hK?R=O@C/sW=P!A27[.m%+!/\=*'`Q@&PG@QDIP<o>0FY7O?>\k4b
&P>ILT7q:.Li++]A/88d=:%,Pu^X0j$"mCe*=F"P*FCLEmlD&Zdc-L^B?mcFLWHG\_oY"d5B'
(1?nCQ**oI?mFE_1W^LgYVQq0<[%9<k>JG_f[Kd!#U`8?GaDm47.i%<NBZW8>Yhe7pCEI;8!
]AVa#g]A\W!/L$%8S/Y`-D`0oB/bLa1FZ()p$.YHeEtlbk!aK?(QJhmCbDZqtO?s2L#A;[kJNW
+"/Yh`D'89`Q>mbPg2a+MAL2'L8+a?e*4RqMpMerP9^?Cl'OA6m6JoQn%_SJ_I`1Wc'_iphZ
i$I\(Iju7nnD6u(L3LrK(S6r&Q10+(cNrlh_aTQI/@]A'hcD:V=>1h;TPlMicg0c/X1F]AtJ0]A
aD8nN`\>\kO?`)(oJbKGd]A$'Pk;;Rr)[Vhl&1dB5!DK5D'I$;jrX\P=tA"Zue6G808\9iN"e
gCmE2]Af6+-e;LEbtag0Ql0P7F8*MRs9VLh[3^tQJQG'N*::GU?4EYLo!M\sWU5LC]A*e19eT)
g[H<,oPSM_hTCfp6<[.ZEWAFWsrs8ir]A"7JoiAE9:guqDf>r+*p_b#fPt;9^d#@k+Cu]AE`n[
(*I.k]ABlF&hR]Am<,_PhSuU"`N]AWk]A8N2)`-jR+Z1HE!s7VYkc&o<gN1&GA4'28X<:-2qb#cj
Z[8$'C"'54&P(;eOKjd-L(#&\=&L,qs'cPDec.lWN(AbWaE'4m+d.1gNaGjJ041+=[bP3iBM
"n<H<mMJNB[Odfmr,UG@<B?MO0%`2p]A1(<S/eAJ`FT-)YAFs^AU[^+sK>Fi7<OFQ9caa$bCM
eQXF'rB9q/$8>q0#Ppd/7/\8^.jlVRMld>;"^h;5k1&TI%^Y'cS.D^`YcgfC8IuhhJe\go&f
`IJI4.L=3HKa<pO2t3`>H3[:[L=4:gAZl>p#&(EC+_W=$ClG0^T14%g:Ys2(,ScnC@cj7i,2
lU\8bNgqf;]AINRkpPYV,fLm$+rK2Q5W)aNojp1cR1@+hdtcgLa7%8h`]AHjE0A4\,!6q*L*-L
X-I6YjKe"19,t/B*jeg+\p:M8*W)YJDl[@I#oLH!KKpCab2#MQVuA]Ar!.X@TPE:7d."keGIL
_lk%[sr<UQ@c)hWFF2-)!L,4"4jUqnEA3Oo7dC"sZ2IW,[u<\%5rqr&FHHl&L)9o&:'8,VJ<
CAqaDUrt8`mkcl*X)@LO%*aS&9$IP^4!URLjgV+<'ZMEYSWS5iWBeLTK660l0=pA(+6[mj97
+I$gZSJR2-$9"5_tF<,V3j-=qZ2M@`a%qUR_>oKFohF'IPc"'UaA==!-"/`O%O69]A9AO+=Hq
njp_N0YWHMu-H>n?U7KBYdb@!NL.]An2Zp3<rk9+1`B/flRG9/$Cu:<S5smK]AWr9RdiTlPjgq
HAh!*FLJri)V19t@('`)?aGgnUQo-aqGU!,?J>pNOUZBO9$Ru1]A/2QfWs-nS?qU(-p^DjZKC
nma,pIeD1?'5oc,MX2b.9Bn^2i,\bd[<Y2@=6ch`>-I0sTMB&$^Us<tVLC!oHW.8o8)R74<O
n1.Tp;n`GP,'sLt/a!TeIO;@$gd=VhegCh_X"1oi[<m:k;"A:DaeAfW5XH)06?c=c^,WuWB!
ANff(;7C]Am4?Wlk0REfQuM)UYLP:/o\l2!:6T-N5[1NM$&uEo)uApG7=Huh)5+rV$0o5-K%:
-h@GRgI?;]A:C!b&#.CG^7=:i&q4U$jcgkm?_I4,oS7fg--6Ss@6fnF9eS?f5Og]A>3n*U';*$
*#ImFCeLPhKo58C<)EVb#*_Vs'l0Z3(-k3Q]A)e08&-!.nd;N\NYH?Wj!EJ*nTR52-)[_'D`c
#imDUJA?QCK?=R-O&;&A&J$DtG-YdsuOfqiJ'"ZfYamGH,K^r;rrpL[@U1%-%X;#;p?So"'g
/W_iK'NCot;Uj4;1PJs_-4llV.eb;A7Hk&Inc0jL0>!VmBfIRAs"FID4H7WQK0Hg#L(Hf5-^
5#Z0Ld&_UXJ^0u6s=MFfY/%.Fi\2!6>Ha5M:o^o`<s42-u(XOE%XLW0i8a7j*nV:R`5;d4:k
K3JQR!W?NWQW%a)iDp2ikOG!VYKTB+qpPqQ.H;:`1p$08U5Rg<ht1>b4UnriKV;usH(TQCM6
![Z:rUdiD^TdJ;bE>jl;X%.Y6'JK&\cU#:[noB4Fa]As_kn$+!_mLm`hqV89!>0>%/>_5*Q3]A
^E3oM)"LI'R^AZ]A_-DIg^j8pskkh86NdmekY-2AVIVS,5?<97XAAT-58*OjL&]AZH&Nn9HK=c
V]A*8Ub-?X2tk38<%(=V.(7fTGED\Ka^R]A;9EK%JXm"Kt="gj3@9UOUHFnDn6YfSpj$h48?-M
OQ&&3eQLt0_gr@(qdN&F/c#P64)s/pIA.a("D^7O/GUTlAg37AEo``YC[('EGDH!9"o?g3YL
5a:7&'3TU0)S=s`*T6OF77LN/+!5*gcE4D@Mdnh#e(YlhK1:1A/6A`a!L&QJ=bjChA+08hG3
Wn8n^)qY1'&J%K-Wc47YXF_Se;S:SVYCR@2=ZfE#dFO?<GH2t%+bIKrU+=@_/u:9`3=>ar4d
eM*70H/l2P553.q9qc[8YMh?Ca`^;k@q^(D%eTSm3o:$'<ae@*206-6FG@j/rA5A<D9YLbqN
`RI:dP,4mYi$Z^1,O@n-?S)9TT&`l+8^Be)!&VbnGrE6BeiIl:FTV:bCi0nnG@Q(<0H;.`PF
h9.]ATKL<G%+R',``.u)'.*\f)(45<;6gfEkQCRk:3rssS3YFQkV+#DD\!!.qk43oA$o,!\."
k4,!_a/.PMegluaM-oggC=P-'_3'4B?;5QR?'!c?++,Y,0NFlL.Ycoo6<YqKH4SHRXn<J#6&
kcU0+oe?s\Gn+JBq>6-;-t3q]ALqC\WPr3UB1/'M7[!hL0UIFb(S3@aM!,J?g<^0kj>MsN'^j
I=O%AXN(]AGXM<MeZ(Z*$3mfN`Au[cBsS)"1l>G`/YC;ncrA`!Gr);Y_.#=auc^3Fk8le%So>
W!_Zs8;$(#bB!m+f9Rq4j(5eqR$m$h8T/m?F`cJl:gP?L.8r)uaL_$Q;C=)[4<g_q!Wdh*$[
5hPpFQuOc=2:qU>V;?k@%A?X"g#LUor[:/6A/ZN&S:+G'l\mTf*oi%70D+g+f<l,Xm\>>?j+
's(O%9.8$8B9bZEMu_!(fmE<7C+)`Vi"AL<5oQNB2r@Au.&5O'n(@>^<K_l.A%@o/8m$K-hk
:Z=YYFCB-,3eW:je1oViZ,mO]As$4^jd99UC$g`NG>Wp<)qDmb150T^T!',<6m*5;>f^ZII)9
Qq*0mN;Q<U(<<7@2M_0*u+7..Zpn)C@n8cn`F2&%TUaFSF'X!>k\YYC\4@i*JmCd\R:IW?nZ
rK(Tm9Jdo@a@"nFFq'SOPa+I2^aKJ[]A873N)eaO"ii24G'1+_Ob,hRWV7G\9Dko)OM!*Lt)]A
&pa?P,XYMLBqjnDE/iSbinM0WBb7jU4JM&p%UOs2]A6'YGanju=aKAF31hg-0aM1IRDC<\I\U
TU*7(SshIDPV+`_=CU=Zi(YpFRdo9+XEAB03_2/.Um'mFoQ,aC4qIKBXYX[OL+K,fX;*:&K:
."3.$$L_jT;R"S.+I/X89=`Kp[CakFSlk_7_D.M0RW8jYG^KZg3JH%Je[c0i--Q0+lDl=mdh
%BA10V(')##MiJQ7U>)`=nM=O#p?3;$Dod:aD6E2(!u_F$UV_*4cW4F#<`aJe6laDCn5=6@9
.b*@d)R$.g=p'26E>@EP@W;Y.Q/V1&l6UIBmDC/uu.9:9?.p*=-!);HW\gQn+&=QnYA:;R<n
$S8U)K)`(be*l%-eD!_NP36e2Qe\R&0:+8<uSftC,K((<Y9LMM*kK"^(1rqbmcF5%IAO,dO1
5@4]A`aP=4%n!Y*<*.qB6lMNRX@&RVXGG6)R^6]A1\4pg17;7ZS76'eca+Kf!5]A=GY1R[j\JO_
/o%Lon$Y04]AHhr%S9.8i,^mr$bOiE7^aeYACID'SD;`kJ7MfS+S21e1BLRsRNG3_:,FejALV
#kq;r6bmmttYA/4bs^`Hi1^GUeSTHp:1lV62+2VHrJPOs><LL;'9B(N8%6dL?I]Ahgc$p+24L
+aHqGB$0]A3#VTC5j8ZB&k,8pWPkpk:OKFW(B@qP"XS7AMORsmi:Tqa9\h!&ZrNZ!2q]A3r'Sh
X<0<g.i["HGcq.e8""4-YZ?Egs+J@-SL3(frL*#<AHG6ebY'?V1!M*.K'LD=&aLPSAkH&CPE
VUOi8f^S5jYd=^N7g))Y)g6^1OG?#"iZCf*9`f+'C^GXT0gjeTjLd`ORq"SstIHa`_2*'CKa
24*nT?3luXc8#,gfcL#6'3%&5P0i[PiiZ/q3D9Ik.H'["@OP4HblC%]A7MMadU*g9]Af8d%04<
1c'S1\plZ3tDV>C;`FmZ]ADH\.G>_ZUT8J<#m]A^?%;UtP&L5gh>L(Z5F=Ki-H^Pndp/0d@8>g
0)hTN%k?JmoO*(2p@[RT%nMB<&M+A*3B'HENhVDaLm7%JF]A1r1":4oB%0-/T/.IGYG)]Aa;<S
s8Hm<6R%7Z7/OQCY[E24m"j`=.bH@nqg=!QFi!?Bulgggc7O-:6[5?P?G-3RfiKI@]A#-6]AJY
8n.J=9Y2k-gQ?T3kT@5aY/[+Bh7G*T,6o5t>ma[ccl.rZQGpqL#J4dq6<6mp_aQCgj1=%H,O
%[lZ=26Q2qU,%cK]AeOjTRp<-4[>2f[\S[]ANat,^I%bfW^(n/$k::7lC;oe7;(9hT.k0H=.)J
,<h4_tnW'bFX@Vg&7V]AtD(Y!R")]A-I4(+-`q=QiU7VO]A7dg7bK.?'<D,0:jYsSDiK]AbAC[>s
D`"!MBOK+UW@E!Kn,%-gIB4>>GT46`)TF<<n9dY24Iu%NS.8G;:k'Jeh`u7`SCDeDBC.a9jn
]Aa7ZB59!]ArTTQeD97A=9Ws1f'>m,nDj1GkO<,#YIs?FA\8/Du>Jf0b0t!T,IhA.fji&i?aiA
)V>hu0+5utfODujpR@6Gm58A[+D?%$+#T0g=b%L#II.Gcr',3V)^[`"`*^$XQH1Qc0AH!*.e
oA2Qu/H&:_9;:scj4#W?R'^":Hin,:O+WP\nTc)HW/[Fn0/Alc*pbf14h?)WG+Fdh(2gVFdI
/'2TTPXh-)>>qV2$uWSJ'J"iIT/dW3ofu(#`J[3PJg/:VS+S>;[JoW&s@hFIA$pFDb+)GDo=
CIb_*H<&851_r;+%b.0G9rDoM.b?(*4/4E-m]Aj3Ir=sNU.3m[7Mq=A6]A;Mp!'n+>S']A?%K`b
sj:^[h3m'A21GhX-fVb40ms$\<C?`lA63e$0j;A@-0:Okg<tM2s&:nF$jR"ON7QZ]A2W/ce,P
-'="HQ^\7CZs8)mfd1<cL6PNa%+NN&k1]Ab@CdF+N6_K9pp`hoOp#8cuZg.Sh2<T8os]A>3,V%
X68hKq*K_H"s;AI%^C#/?M>cPh.7=\0OPKM=J[U_)H.p+,O<W#Usea1`&L!l2R'Yt.AU"ZH5
k!'H(CPI4SUhWb1a8JC'c_DoAdoN@$AL)Bt!+G,i-arQ1\)-K2!/nWg1Jjri0PU\Oq[JY]AF1
Y@\GCn;%6CFm6;IgZOZdk[PiH-dU^B3CD+9eju2t2>G]AVH'-#l7+;-LCOp9#Pf$5`Sd;JUoA
E7!QQ1\jh@m:a`s2MadXk04/hg=m)PAh1Ni&?^`HO\_:Kt#g61%DOWLTBN,?]AdM#Y?H!M?0(
.a(nmH.FCHMl>eJSPj.dHRoXU?cMXMcC=OS+=&%4Xa`/KE9K`tLI%,-t%jl#HFF/bT+-0l3A
1/48;#O$5<,<f@RCT3&UJ6/h(9gR%sa['\[6,#Os`c#\qjips!&f6`_9[&[n;(pDi<]Aad'A>
UA:IWFKeq.6(#m4]A$9HTkW!KFU5JKkHP0a5;OU3r)D7QIc?()6jrE0F;F=@YfDDl,C8Wo;[h
7'!B5'af?pD1@_+!$]AfF/D$l7^3k+&-XnE7tWeJ-3&'7F)c9E;hm-p>gc\tqO1OGA3@<Q8,V
`#$r\4-nYUnCX+8')LRa#-jIaNTo(d@cC\>[=*[=Y`WYG%8'5D;O;ZK&WB^\g'4>-PqdmRC?
]A_(]AA.I;g?oY9"%`%/tS_nS\&q!>,a2kNNi6Tn!;VfOSXo@oGgBl]A55Ya*6>:Oa%bq^:*(Su
`&lR-pE?(:oslS6opd`OkqBb/q6PJZ!;l.Taec,EF1rjC&5e!!.N[FmDgg205O6<lN+NW[?k
s.`5E81@hm.P08[iMPY7=jukZI0BDdR0`A'C?)DPm%'\<SY!=\ru81m^Y_)B\<j8^>rGk60U
i[!V[3b4uXc(^`YpdXo;]AlDPBmZR]A.2,C!ME]A!M&(!Ea+2iqa8Qa5(GjAC-pJ5g]A<WGlSg:!
C8[V*^-@?p=c@6j,`oe<5qFRKDTJ/2O;@/bbo=`:f!EAm"7IB^"Q"m^]A74j0GQ8VA/Wbr"ae
.:R[dUVEPH-$rc=69Bmg5*X(Q,2&tpkm4_Q%PUKg1;`UTO``4C<L9Bsge%(*T^Ab"p7dD[HS
GaDKCV@7a,E&YK(DP^j,[$R^d-f-lN1*+,>C)(&&BO]A*CS]A:Iq#B%1mdGD+tj-l&#$tM8OAt
,?<;_/rAeU3f=Z3lL/R*7I".jdB?9oAfcRgipt`Hu[!]A\mc$T%R`#onEd6/p9h2j>n'bpdjZ
+!@2$ih.Hu]ALSr[@Qji_*eVjbqR.4jb7u@/'o$H&f`N.IuaVdjf8USVl<NNd<HuaBcl@Ob;m
icH';(Ld'j#ou!AtJ\,j/M^>T/M$7MM;mRNNeDlVAlkU7I*uDMQm]AIfR@M=MHZF:+"3t'K_U
TVlq3O&Z`^%tS!qLU!k1fh(Eims7YOK<ro<.AUEq=X#7V[[DcrX@?Z^PE>]AgpVE_*@/c%=Fk
*jM@>=Y2B21m&6Iq;[=nOM#$$mK4Qf/6$V!Ea<_1L9+^L@L<KHoJ!hu8`j$.N+h]Ak=%S+pGg
]A0YoX9g!TN7?%jMp$(c&EZ6diGCSmQ/)(?;;:aN$!8-ggV#mmY9?`8Fa=V=5ZE9Z"I5"]ApDg
FS3<lBNd64+'DSLXR,afMYmQQbRQHh9q[V><X&n`sjV5HmC/?QQ402$Jb05asQ/"8jXK(d3R
%I[MShC^KjVVUnB%_t6DfIDKbi^Ut-4u0bnZu!I0/raS[I=i7dr.$DBUVIBs*^1>[U-jM8d4
8$itGQY3b7?mYilFH=4E!qS8K<1p5A$^k1=,74h#3Bj?nn_pU>nFOJO4mm>o_`B3@m</u#OD
;hMsb;@Y>1-eI_9[=pa.H9-l9.3A#ApZEik2L3GF3`jcN1;?2b;2g]AV_X$7!kSfE535Rp5GZ
;BQ0qj6h1r7qD+drsu(iOJtUYFnF"^l2^Hd9"#/,(F&9I:]AobUrqCIifUL#LH(VD-utaKF@e
[$dqsYk%N>p9J,SLZ)$aX3%f;g0j:RGTN1qKZrZU#9]A%!>;tdI/(6.)(lb9<Q/Q>7Ms0pu4'
jH'a!(FG7jG',RfN(RgHhiGo%rZZbc@oVR2Wp8u[eU:EN[:r\@(nL11V7^T-3XDK.*ou`G:7
.:OmKHh<!:@Gc#da#\Q>8E(1gm4IPOoKT"WtZ,a:Op`f/8SR+g"UmJjs[8iHZ,:&LkASsGjI
J`=%K#AS(_^USJ.W5D_`=+lsXi.j*a6(WY1S:D0/SqP1e8(YS@S)J!3Lo8&a1MONel5P!^/H
1kaOW5^kC+mFRE`u'_!gVC\:tYj!hQAE<?Gdq\Y[Zf>3j%CVARGTjpV4ne8.g0;O&\(Q?Cb+
Q%RB7ae9Y0VYb8CFVaVC^[e4Ts@5DbnYW6MGPtRu]A6IlNlb#<WXoY!*j^)Io@/L@C!+[f"R8
AaT.*,aQNf%9g!L!0s,n:VKc0;.&$_*dYK6D+D+e:gFir$q<g8l_R"?,fm4L#ZWC"lMF[(8/
nGO0:-iD[KK03<-=RrW_'\S='!Lhp(C96:5VF5XEu!n>F<WXi&b>9Ct[tEmZ\)UZ4E1'cQAV
2f*ZYeKk<=9YV"*,%LUX.u$&,Y(2S1I`iJ6gD3##))ffmHtecVA]AG>/RT/huOoS*N<iOui'L
H>t!d)39\*$RrRpt(DRu%Bs+Kqa^;C'@AM%@(gIW?M0a2Sd#Fh8B^D%bYf-7$oU7A&9;.-F#
*raTTV-f$.3arO"VK&4Wb-3*89kj?&fXpaT"@KCX)pof!Don#J/XW[U4s6R%OX`G11e2=J>+
YU?-@QWN@HI0tg@)Dq`B.0;eS;&-JcqE@?K=Q0J`!6<\<c`)0&DK>=*,F2S$IYR;+,"<<`5<
`Ws0HWBK.,V-f9sh3lnKAWno^j\adCK4gA$0U!*aaSoE]A#IL+a%rMmC-/FT3HOa0eLgmR2Ye
[d)Tq@D,P6?`kUFN^=G03D@8&-'2^;$P>((*j:6E7\&2IFlp'G1RnZbWn/BLd?p$g:FFGTm*
ZOMh8[0up"-%#(lDJ.Y/64-Oh&f78X'=jS8ULW1ssIbqh[YV\d=KXc$]As%0Urp5p2u[_6S_V
n1Eq:r&='b?bqhHV8JIj7AH'cernBp'5i9+07V'u>97$m/i@smoO'q=\%_3Muks)r2q9MrB0
<]A02XEOe-J0fBq$^h7@[G29*4?7e4[+PK+iiG>Ph:E#GA5[(0?DaN3jHPMVLm&2(O@+9ZgS+
E`TgU@K=264>iSVr8q;:`5aVl2[J%QB;=B/<+P*.EcYs2rGbW-$sMY5[T^+n2UDWAQCjPZ/(
Tm0\CF#`gm@&8>1fN/rChC3.g^2*iGn-Zs$%P^k:NL\q>P7;FR&u71`'b>BK\GE<4)HX`ms'
oAWhHCWo=e(HdZ*h?FmMHcO&,jtH*-sRc#/@Duja.BXZR1=(K_9Eq<bD9Y1K:6+<L&NG&0_o
n:W-XCo);/&W#+E3c[2K]A8gFCb*i'5(LuFR5Sp4#7kl7X*Qck*Ppc=[-Z`Q+HO;1<G"D-qGN
;VtRV+oIi)[HY]A<<@2.+#sc$#j]A9ATKNLHp'E#T%ZY4:AS_)[EG9=)Q.1,eTJZgf'5;#/ioK
Ub.^dZ+d->hUS-T@4_ZCJ00F^Sf^gu'3P!.2P>dNRD.UZN+%eIY1;4\QBaa^,+a2-FZX[JDG
lt#qSqh$o8%Q(u5cjSeBr)qSSF]AU3q]A;ZAf$ne3]AaU:R^L]A_ANYMO<:\8cIOd>B]Asc5#;S.m
`@;m[CC1rf0,aV;XOLFh@_bbpg\I/JeMPN^nd`6;Nt/Zhiro*o+,FXVb/\Va(]A\bGB9]A0P-s
3T.bAZgkM"Uqic]A<1rr'6?n'6;EH#72SgV$JUpY//V4g8P!r\#i_B[9o%RGf$o238uF`:&P2
$Nku\u[:DdoFfAUi)[h8n(kY*YSCJ.[8Qh>%n<P2AcR.D!.AE%sL!h'_cP^Fa%N!+1Gk7[]A7
YiottAtAqRn2VpaM_aC"eh"$V7"IPD>0J;)j3hCW[%b1mEn>Z:4<+k9m:niQU,"Xl)Yr"h^#
0=TSJXeb#rfhqnX^rs)g&n[DTYpu1rp5aMpq:5(Qp%VS@aeRTohMTYcF,4\nr^ZSS$`'l">l
ALhnu]ApEge:p@a97.0qcB/'\+9O)lC,O#W478QcG=,]A1/-7@S/2WDk$8RVQ')oc2(m^W8c6W
k'SU;K*DQ.jr38O!Uku,g+Yp_5Kt4GN&Fof/[XA>Y8?:,a#'Qoi*<X9`8]A$d289K_r^4"[[#
8f.Yk-'3T'-ADdP-r=]AguBB++rn>,d(]A?=jS+]A;OQQ\bi^>.^9F,So=tt9'k=ABPo;kNhs2i
UfV1]Ae@8;=&DBd-g_+YA-iAjm`Fk[+0W^,K"J0N#F:4\"(1coTpg%(;F*n.2G86qE'BJH-=Y
%6cq6j&b51h8(9[SC[s0!KXtV?k4!1dt%.6nUYalYD[JMhR`Ck"8k\tNA=a0.r=a$rE!bU7/
=MMLDPDECSR@.mEA)'_:.5l^a$39:oRe4V&]ADnIS$I1@1ZCCbgfu(,*D(;0@M+6l'!^t.iRJ
oX,#dG)CJf`B`"+H'VbTi$aI=Tf^nX:L:#ab6*XLq_3L_T)i`6sEpTZ1rW<Z2!Gk]A9N70!&k
#\kSa5"L(nlTS;(b0tM)E%>/7+Mq2!\Bm8A*sMIIHo0S2_6MMg5c3PKIm20LBGADA13jo/*3
jAC<_V+m!#Ra;?&]A:?jKi7L]A"&8n/Nauo2*W#rZD)'MEOBTStr;o-X+'3G5/_5f]AgFh,_14$
I4\6o$ZnB*(FDI?SE@&(ePdp"#eS3%LmVBaQPEZ,(ZgfN7rAb0K7K><`.WP6l$^MD.p\qNkB
T3>C7A=L;9PIR:W6!6b&^SI0-b$bMqRb]AH]AR/++sJsFR%J)""]AMRug&=%AdBcP=fK(0rDk]AV
[Q2=heN@hgSK3qA<eKu=I%dOLg:6Qqh1cET5bBE)(k5CcZ0)L9*D4"_bX?):V_r*KD!'L_g]A
eeK56"!i28e!KEcG0(`6L71!r5mH6Z^2?\S%0lW\e'-0R4o9P:WTA#D._D'"-=p[Z,d#npLH
:WpH;@:jHJ]AD1B(d7#>Y?Lhpdd-!0-d*3MB]A[j\5kKKkk)A>(fBU!KpULAqpX.\;&&cVcCW!
r"G/NJR[eEFJkm:O%RdLCohqeP<(iXaEKE>9)1gTqt.rmllZ5&!"%q/-AZ/\FC"fWV3Wl"ls
-C$(dn7Qf&sN`CZ)'LGNabFNeD(HRqMcV?3]A&@KrK-M'U^V!,=.OObdG2K'`fgFdo'f"^a91
l.cb5GCSnCgP#>FS?+3qD2WdAk56Z1&rgOWK_:B>AKAtO=YS@jb[gb[.#,DR`EX>nb65A!Cr
^HO*3*P0(70>q$c!8+'F0AZ;\O5++>3;@5k\;0*DO+`(J*oSZnrIigcFN49('Tk0495Hm^)b
4QL<_TG3PYLQj[Br\@\"B]A:r2Yp5JgjgDRXqf&KiGGeMo<tXS+g+H\F3X&`jO^3bFB$)-up5
`g$Ir,u+r>0a/14QcgL'):,GB,5j^^"ZMZnGH(GEla9_eZ`j>XCcMG!#fWV:^uM$E?`S/%"0
CV%gpof\A*Po@pV2(;.1/ori6?OM!#nm+cciE_s0E;MO$@lQ%4mnir^>biEoCFL'&!=<6!Cg
to4J2nZm-PcauWNhGFj?eGF($5(;WOQ6KIFQG/g:=K:<l'gZ%ZlrA><i"9>-&/6Wkr+L[`*$
.gp7"&sN\iZh*-Zb@-XGjhNP[06/m9K<Sh/G2\g^YBl#hZ.#2.-Ml7ZhAX.Z8^T5B!.^=>\>
r9.0KHhr?&;gUOP&`=tct3ZG4i30TeJrRe@;./YAR#hNfW#BXC@3M=4R9&lPsNeFK\$TBj74
#&eb\5r'Ks$*V\[4\%X+<iM]Amm_<JKU1L3JL2:r:Xi=+V`GNFhH_[-p9a>@O0u41nEg&9GYf
4*t#eD;(&8GDRS:.&2Q8;JRq1]AUZ\?oskmS6g0[`<$k,?D-(+@r&aFi3%P,1+J3FmjNfQpV"
,4n_V#-.(n+h&n!$Z7#;4hL]A/V8(N7K;23muA#M&IbEAmXOAh@8C8&I]Al"^7E@Cc^Lm;J/lI
T?4N\$InR.l[ogLb'>1C'*=Ar@p7sdCtu%G[.\_-E'<3k'hSjS`?DV?s\p;B$Ydh#q<!(-Do
4aQ.2RmIM?A_qI2%i`URsFpQbVb.6uj-J()\!X1\i[$RfXOYBB>%LRo3A$HPSKs*DW4VV>n;
`Wi435GjZ/E+VXA3R7*(38Y3QN6:'[L3hAVLsaB$+@GZ<%DVWT*k8F*e1Gm1*iFP+B1!a@_]A
j+8J$nc%$AciI0;1')QF#Yc::2Y[gLCCb"\1$;fhuVdYA0JD,#f9W5F&6sDY9&Omp3mrr%H+
dBBsJ08Cp:,#!9\S"q@CP3^Y*%fL3D(PbAD[iAnM"6]A*)Pd.\hu3YU-'=50[/'26VtG*On)"
%\qT"D>3`@Z/PQBTKo8)$,o[R[W/>6%+"EfnnF-4O0EPB\t``qLLG$Or(C"l,s'2(?1Z?45@
O',f+OC>_;t5-+Ym#i;[R`AM,s&)u/@6f`sHK"6(:%&.&=Hi&eQ^M/DrXFsP/E4;n.hRr9#'
+<_;<rbP^cp5G;0W:CfYe&FT=QUn(?3D0sYf$-:I>QAO(WBti7[lW!mF+7RBBA.F6B3.cW.j
^b)0)lb4*AE0$3no8Edp$Ih!BAFe=EK%a&K+K#7_&0u0n3f_4hi1dQAG0uTFpIi6Ms;^"]Au;
PZQf6iD]AUfUX(53eI<G_$B?5<E@Oeg4-b=tIIntkP$TfYCcd*SD\aB##!D]A\r\nCGUPGsaCi
&Xu#gr`_!iDBcSmgGFor1sCX-t)k;cU=U"LbM88]A]AhQ%>7s(c,g#]AZ-W*!=2mr]Am*l_K)B)J
9B>#VRUOW0?`FWWaEHZ]A?NIA6W;db/>n*E6G3N(uUlb5&F5AJ<Bq&G#S0\(Cun;Nu4g=`V-\
/;1uQr%qHof<OM:1?m[5^d3cQ%^Q-oMZ0_H6>GPFI'EkoPW1b?YQso-4b<#2oU>&Pq=4ouhD
B!'fbUcfIWdUF<'Wt=^RTY6=>@aFP`,R]AmqVrM/o9Duid2g?&O;0MN"FD$fS8sLZgER"mI!=
$Y(J1m:G:h"Vul.T,L,JEhu?YiiI'94Vd1HhYdXDcCJb((1-N8Z!2[Pl2`)5`I>pep=3tupH
>m"USRTpodtn)KOrh]AP[W)^(\bbdFbJ;YcNq.lQS'?%OL;9:p@<Xnb0EoE;)eWLY\'d(-ARs
`mo@CbPj1/eIr^7>!^q#?;Hi2liNoO4/?jbH!R2td6@Atmqi\`pkegI">\f[pO3*d;-p)(gF
d^4Qa%n<J3>";/grT<0&0>L.Dp\J:MC`RAY2*`SXO6=JhG`$nLh1BE"-6ZbSk.F<3PQj%/8-
LHcrfQ5&,PH#1.G`+q*ol5"+Q^VXT25T]A&0UT0k,#j6%=?-o;;Y]A?POua8`=42kR2agFKA'`
tIhrb#MlC-%5YefmV+Ir_gSrL:WQnpX?)oag>P+\@/LcnD#V#b(aVTLj]A!N!.dt@e%^A,=+q
+(9GK!*B'kYL#=&HY5@GMtd/9F%Asa3L]A5;Ym/hl>,$3j.cGBIu.snM(_.=U-BSWcN^Q8</3
%HL<./0jbag;<6RO!'3hV:!JLZts2i?H^LHfW+!6kuEa#?5[*5MPr?9JYs#"rdnP&EOs&>m/
+]A4sFKp$4hR9P@tbUk+7Z\2R2$o=5&/sTZkp\Q7H`0C.1'Hq!;gWXg;,$Q\+)!3U.DfhMicT
cdO4LWl)q0lVAchH;N3)l&)IE%.C4F)9K2tXdukE`FO+:01mQgP*K`7U,W4U\Xhhb,[s%N9'
\*>-/6eW[?>WHiU@EjmTT`<\j1hS[IKgLR&[0mi.>`^u6;+AVQ_cMj^B3O>)O4*0Tb]A>3Zr0
k,P@]AnNR)XS5sRqPg]AAZ;k!K!$hL4*rj(&W9FnOH*q9#b;#Ka$chOJdsc#-l,(URm"&0OaFU
aoD%B>h`c<OQE=X]AtBItHP=qCTl@F'`Pa%-t9*2%caNka_Cg[r,AO`YU2kT6h*h<&hPg0U;G
GMTl<F:Y)*%d]A%CL0F@bDX=1Ergep0\Gt3r+Xk*Y#5(j^5M"Mo;TAJ2F%ZN4puL;q/)Qn$.@
M5&ZS%?PQX+/U=]A3;ci>s=e@:)E0[(*ENb`SG)8\CEA]An]AYK8rDaK&@_>H]AhhgN6GYU%Yl+<
'!?KiV\+mmWcQU[[(3`2>F?&P^$>>S,OjC)/II]AtblE&+a!mbm<F9m<Np[9[T9Did[efM9gO
ulfnQ#A>5X<!]AF*1&7IgQacJGLh,EqhjaQ).UXRQp:>rqMCuXGke@`d-X8d1NYYg9(\N^m)S
R_5J'!C$Xs;5KZ?ZAZL=40*TI=ks'7J(LukuMMnORAi$\A>fA/&qF\EPLH?$.-_KI\SVsLR\
s*O9UMXj#q!VD1J_2VrOf/VE[K2o&mrb(^\LN$*AL]AojraJ,&C=`#dKZ`F6!Y.bNpId3!'3c
8KHeuWG%#2EAYIs\D:%aA"\6J6QYjo<#[Z!Tce:\&)`^p0H`Z!"p9V[M\Tn>E;#ISRW4qtF7
fY4SZ4UAF!(^\:R(IXg&Gi%^8AiA$;i'6qm'S[XpqqX8Bu-as6XjD*2id7[d?Y2j.3dQBj$c
COgT9B)!Ik"/1X7$fHdEgWl4>u61l>*eh#Xkj]Ahr7<[[4f*\+A-COEs(1p07rnU5lgD;P@K$
0!A,b"/PIkCrm-t>Zch&`-(HL/GG55JYkKl<9ri>tSVsbU7[0,f0gKW's![-p'-iUUlSl.DP
,.u7iR4.ND&4#=[r3T=UT+Iss>U1V*1R97LpODtEAV,gmF0/E+"<,Wl3UPn/`3J-`2P#N6a%
P$TL9'O7UfT,9htXMYo<j8Cj?pG7U8NC/EPDIRf'^f.g>3X,Iq2QiU&9t(S#M`X.&6:Vm8B^
<826"-3b.=mU:$#jkCG#'#FEd'\gj+<,n[g>;#]A/miA,@5n,di[lD>Dr4Ep+Q_]An6c@u_"s*
E%4Rg;c'NH/KMEmD5-=dOju_pHs`eIILnQnk^3%i+.Pd9<;fRd]A>ETlVBPFE]Ae[aq'TK,2@1
0(e?2l/VNT@Jmrmh)QK%GM"7#m2HpYH:)4?iL&ESN[Qi>dK]A^0r:Cfd#t[/9A%hJd)C9@6HA
#tf!-BSG'M\c(gB=#amX&!CN89*+pL1)<Z;R`@B2r:=)62Z\0a[CM$]AepK]A4qlPO8dli/"GO
ZVW8U?kE^irl9H@*DdE+u]ABj5dJJE/PeZhA_'8^;CNhs8;Q?j\LSDI!deRX]At/bWr.X.:s(Z
;N=`_A4+k#>NG"QiWop0oKZi_.AflNhbJHF7-VF$%Xr6O4M@-refLos<QS-$2asa_5XnT'^Z
W,P%<cgk,XmJS&huM^OY2-)<aBai_g\^M5Ak0'qIh$/./Yb'2F7\f(j4O1Q$`T]AJM0IZNS=9
U-B8*[qWGJ)g+;e2Mr4#78nLgL<']AG,*ZsR*u[t5_c(H<%cD^OFd`f9A6iYN[&Jq%SP$S&oB
=A3minfuGm$[COK0pC^1Od-[;k\M\)($9d;f)F?O]A[dnR"RN1s/4J.DF]Af:?%9SHuGss1[@X
)W2M2Qe5kr^LsHgE0['D4a[m"4YZNYNZ+37"@I1Xr7.Bj^NP%m]AjU69`S6`!Qi@1m_B)Ug*H
IOhEJjCuDr9^/;UNIGh-*"8sm[COE,cAF1Dq8X=)9Ah8P7B=6c3a)OrBF54jdHpl#C6Gpea%
4o\_aa-"K[m^msg/<uELJ9[u>'n-I_k,"ponpC0"+2k=Zs+amQas1?@"`2b,j[G[bu9XXU&:
a]Aq9<8FSpcPH.S75KB';3#"?gUOX0DNK>`pfWAr]AQQ_J-^8oKaZ(9ACO40?>693[+@4O]Af1H
kL^%ScKpY,hYGXn4d(aqLsG0I*0W@[r+?\%ZEjj,\N@S0m!Lu>-j`2+bZ$c.Znpo*oNIqefn
Ou3[2>g,DVZ*)\gAGqV.NB]A.6geo&mkQ``4e4)ZEbnQ*U:h&P6:0/ls9NhHl&N3U4u+Qh3I:
FMK(\,2]Ar619*)!qXo=.Lc/`Wgcl9lC3\n*$*As88`p9V%L3./t]ANDG1s6E9,C.^g_.?;,e9
OYEUEMiUabB^09Zq?c?5h=e*Ucl[;Z.->lJSEC,Z8SXIh)KfZVNG\'c+CG8RNCefC\(^`MsV
s/^%VX`&g7V>&n\=jJ-m7HgRJ:0X)"<dc!+1WaATp]A8GO7u35IEmI=\aM8?UAnd^L95Y"i8!
Z`]A3qjS;$PjBU?3;[Y)?qHSXAX3BB@<T&(SbA'DtR1gE+j';Ft49nf*T?<[CJQ[(:VhD>g:T
H?oBmO'A$FsL;9W/@o`4GDa<5,<Fh51GtTGn5._'T6f9&@S[03H^=iV9Y<N^o9k>E7>P;HIb
M"PnLZhQ@EhpYl%ilFUo&kdd'N;tE>K14OFC<\]AXPB0M(Yr'BlG/._k=R0b^![[$uNRfcoZM
^rQY[SF&G$JOie[rp'1*TFka4(OYS3Jn+tn-n>1Y@1N@Q]A_`'QR,MA-51B@J:J#PaedGD;>\
Je:"Khen`X#O*'S3=!fpk=bh/5N)GSD0flSZ)73CF0YmsIu7/S\,Di$_(7,A4g^>h;+n\)4Z
#FtL+3Mh%ee,5s>\>S%T"Q#(eRF<Vl8C:6hV+F"F>3dn#/mRQBlWHqe;VlPm?IO5[+9T$uZ^
SNK5OrX_F/#/*=`.m)JEQKjpDb<21"gFl/9b7=,08b^GASbU3,X$/\-klQNU*+n4_MmFTnWZ
MGNg7kk?i3,L_&HBTS?@jGHCS=35,Q>Wp-9Y.SFmBAgn^7^tP?'=$_8W^mWJEr.S*\gEh]AbZ
#>JO)SmqcReF;XejMfahaEVG\6Mfj[YD5ogWShd!$:`Y>@\IR6To^!!bC9#XHb.]A(JT]ATFi\
E:1n-Ur4#8_^GcWho`WM&'X?pS#,sJF+3Nk[-qALf*G2Bi@`G90\2Z5a?U?5MLe=E@cn`u<O
@O2I.:ZfOE'82NJ_&'@78&=2*3k%k8ST"2$(!+"/W(g8CB1_l;cpi%q\n]AXYCDd+EH<+9^3Q
qV%2pP0L.g=lm&mOq&jEb,VX^WPKAp%%@O/4U@!AGNs*Xm6coL)2sLWlR([b8n$_PJSAX6#j
^le)G:m4EafY#<_@,j/=Z>HIsh<?aEsHeNHiI5"TI-a]A$HPh9*ND_@-fQ?p-lA("CVKNADVT
1='?)m3BUKAo!;"EMSt&)]Ar%U+?3QjI_oe=n-(Wca<RNQZj7`BPM<`auJ/Cpb(1c:kn1fEr#
s;:cO'd>c0=[Xe]Aj=nF@&`Z?6X\6I*2/pE(170TVo($c_:qn'meD=pZ"?$QIK=(95CQ5Ed+O
=Y/f/kJDV7lWYU'fjBtZ('mb>4Vbe,[$#-P+K(%FMmr%]A=h.a>n;a0uG*ge!f3kF;+l[Lb0O
I50P1<!/p1Qhc`mrGB,2#>jS+2JQ8e4jhOe)SGj]Ad-b;^#\9q99_sB2m:e$^@q49efPe.&0R
)k<HE`*.oo:J8XsQo8Yj3DM6jXHpSV;4'8d*BJ:*E4kCh7E4QI-c"_VZ@H!Q?pYgmJL;!n?%
:\TJ1"0KAoBn<DP(*\)k&s)]AFPpkY(0f0`iTWs18!IDf1#7H58l\Jj=Q9Re7E1UAs&'sV_1f
!MNm=A`4(!*R)TR.IA:m'R[!h%F2dV9"+'jbk=,B:+HGn'SjX[+OcTqbgHH!!eT?2\p5On3d
D7/[Meu7Jl18)/tLZ[n=(b\'%"KV2%?[>Y0)_^ng<1*/;>jMLp^e>9"WW92Bhn`4BkWZ[mJR
[]A^Y2#T=T0oZJ3rLr5R\i%spN2,bVVO8>dCLd_'4>'jBm$\PjoB@(Ij.oaVRlO/^4qYAJZW=
his-!EA$uf<B/R?qb[dGCPbsM\*D!2on92P-3P&Z@8\"f6m9,Eb)f0?tf#E<^+,<W7kI"q,b
6[B6rY\(qCnQm,gDTm<)se,d"KuK,GU-b'kU%0NOK,eN+eGT;KnK?(&hG2A'k:`qH(K3=_HB
ULO39gt/\YYLJ1LW_cBY[0Z'YaS.$"\^DC(r`#;Y!XqJNN[n;#<C>;$1fG:499r$,OOh*#Y;
Q"W$>LC2u]Akjg)_j(IU-VZ%aqd?&k/rYC$b^/pnfmg'7g.:1.1#&T)M]ANk^"FeLCbkQWdbm^
&g8B\\ZS)]A=&Xi./*B,9n]AK;_BU>O?q"IPN*t#!da\=$C''qVboU)G?0bbbF6OnB7!tdZBnn
HhXbDB(%GB4,\eAd*f5fC>cS!a*jLS7n*Pd1`@V[5VQ?N8+?UiiMSod6e04/tK?>E%iTX7md
,2t%-:sa(aS<,]AgB3u]A[li99-53jNF=1S$#^br'Y9b]A#U:&qIp\Y5jo0otE9fb!YlCH*?P+O
fc]ATTa$%(;`P_SU2:XuDW`o2B5q`R()eX9@JK6H<6%Yg5hSRn'7/%7_;qlASe4V:o./9-IkH
J_,c0(.^(71`MZVdtK_)/N%8:K[$!AmmPKFG-7BucO<o^-m*Gc#W10hOoc!f<Y;]A,i%!";Q3
oXTF2GJ8*C:`'a^LqTs,Qf++T'0-,[/Uab*/;%[Q%!hd59YCraAkGgDM`DXObF1r/c^]Ai?2X
VA\$BHZtAC.MV)r_7967\A[C"O/fr"dW4XDs6*l+\V<H$T2uRQL*tW'rX(-+klI.WND5Q23#
c*Xe,L=(ZGIA`0O`9)XRC0o_F&Z+9k=PC4e>^=Deu)%n\EOr)Jb(P6NnPlHO^F]Ac2t^a-7j<
Bo0?R`RF6IkngbAu,&(c;LYu#`kJ:Z6639EGqln"@T?&Q*90UG.6EagAAC/JHFm_8u05_.1.
BHYRMlS@LG(<e=:Y[6;>@Z6LV<k'>:ZK)ok-.Na66bp*%J*RV9H$Ln!RW:T]A%sFg[dFHFAAm
Q">'HXQ%8,uE6?`(i-RVZJ5EmGLQk?.N@4*]AS#='^En^CsHI)utW?kugk_[4k5(3&*>nZQJB
>h9(ITEZVeG^0Sn0$oX$WTX46*pM\;sSY.5HCEk_s?LrmA`;,Fd;D'M,Kc;PrlL]Au5q2Or2$
_,sWk0Se_3j9VELEK="&r'hH1\#,.)`k#r@P86g^T0*G"kQQJ1I!0fY.KdsNY0L#Q+'P,-2b
("#(YeX'!1o!r&Mfu\(tOeToIRH_4SFa\\D-)*$Ji,l'D+q%u^dPS0a0A5NbS5.r:B'S?X89
5djWrYffXc:rCJRFT[3H(bYOX[]A"P4j2<OO%\e-6&\q(SW!7Vn&/Co&V<\.Or,^m]AZjb_&a-
pZ<r;Os<[s'?=2R"F7L)Yq@MmaScnKj%]A&&CUYG!E0K\rU$:=RKJ[_i`lro#69aSc--`n]AD3
Z61u`IXua8&n.U9ecC+WQ+K$Z,UXa5VB@Wnqlbm2\"UjT[LW^9JAZWAmb3%:3p\g&cW"o&N7
G(/Z4@l*+YVtBS.@9KG7oQY.-uD2rF_PXd8Q+"3J5MqPs4P8aO8EOi.L/%%HVpXbH*m;#9"?
e#=W&cA`K%rV;@a[&?Ur,.>3#V[C=n^9HCVoaM"<Eh>gb"R[OasZ+`/.V;_S_VZgBaW`g"05
+6$?8qGn4f?gZt&IlG`_7il>QR"=D`k=_7`bC-QWV1AHE:[IfQO%6<!S?^TK@G,.o$%72<)T
M4G5O[R12A".H@(%kbOM;>&KPWB5;U7ZDKAXWYb*:,E9(G#1F-S!$op)'/MLp_WG=MrTNgQ.
VO'k\VTi3H._F*"n)YQ?iXhUGo'bOV5WWG3F=^N#A)CI3,LN1i8F:4G3N.)+\L1KWlaYLmVN
ETU@8+c"6"qR!-.nE),m(=4f(=qd(Ij1Akd!;]A?Ut0>G;n3uY/Q_R]A`A5#5/L+B33Q1Lh7N<
opN=a@!kn(F@,HsfQSoH01l?4ESL.$^N67SGclBX%9Z"\F=obGau5I3qsS!>Pi^AiF]A%JQAB
[68J>ORGq:rUL>VAh;nHfXThP,ot=#mVn@&jaZe`gof%-&5LNgO?</Q?,-'`0I,n=Vt6gAmi
e?J@&4u3^M8]A.b-LQDH_,(V_tob;=rtDXKKZGe'"s-gE&V;,%.>3\@7R%:,adXT8aSCT,0G=
mIoN<TIr):5Tk8X(NW6[fJ5^p?rJs+OUKEm\#$M98W!VL;kR"/&Hp,!o256j/LRkPJPF^6J(
i:n*e>rWMZZJ`RG/Yuf)nS8u*L%NhO72V$SII<#<I`,T-LI:J/Yrti_O1i5O;D(lop!i=<fP
191-Se\j>G/Cece,[Cnj/$[mC;Uo8#iN5WQt-HAnN\#SP^/9cQCk/^S*[DVjL//\`1BegUEp
):]A]A\KOfkL9el7%3>#e+hS[(fJM4O7MQu9.C$:G#Va3Oh\OkA^%a#YJT61`\6\M:'0'"mlI%
91iAC6R2URu1Mqu1m_.g(1=8&8-S;l?a?h\2I(^8YQ!NjdcYGfOpah*&hXS&Dr(pM>5:;(sA
F7]AKK'\G0u1?t"'JKiCNF=9gG`/9OGR85F?XEd0';f_7_TOnKH]A9oI8(Q(^;kI*Dj6&!V)n-
.>8i.0ZIUY;>KoNq)U:*PU>cbRg$@nu;c-Nchq)ON\dho^n+b"5%ZI"J?HjO9lj(d#70j'R]A
"T-*H7!UC6Ko[rA3gSc`sKaSa(@q'\.[XN`@cGb$XTjsbQF:9FbrluRIM>qJSEA",M>aN[=h
c'dRBG@sc@EH?9_goWDGbIR<N[1dL.ETDtuot'F8NMDo_6#eDTA_7BdLQR;c#=c),CnsSm%@
Kb+oB=OaAlT<*E*^ALP(3u#mpFm"MZ*4GW/D.WC/*-6+Kl)?GNbD&6b]AOc&5ht()+BCC;K`_
*#68s3SsusjIjJhGNG'Zs?<C()SLHR"'87j@!b^tkq1@^b1>M9rpoXr[ebl^PK3H3:\63hol
o+FolJb63OkMTj$(jJV^;/0CgH#=:7Z0``)6_`;poQ[c!TcL8;karVCua,ET#JFiegG3eRLm
1&k=%#H!lrY_WInVHGD\o)**hLC:;&YrA6Q#*?FFA*Z2gDZ]Ao&07Q!CR:C=c,&aW<S_HXo1k
1F,Djbr.rcRufhrf]A$oG.,7Q^?-LNGji#`YgSA6o.$%?&^a]As3Hr9W#m-WuC('b*?_=Z4SX&
-NgaB;NJ-e"-j7ZB@6OD!'r1#]ASG:.*Vr,I(<f0dA5)BDl1lBT48lcq<\spfF#?.m^N&G&QP
GmP*+;ke+NA_\`!E""op^WH3V\"5$B9im@+"FoHS@j\YJj85BMaDH[D3W^g-oF#5#KPNke^6
^iFoCRbn3,iu/bBQ7;TQu>/3IUG]AiJuP&rQXnU0R>O_?`miZbD#u'-<s-&qlEN'.Zs']AfZ)-
[s*^k?CAB7W7E@;.R,[N36dS-7=?Sf&51!*4pJ*]A$Ar&,1BTY)H=cpW@Q.&@J)*j=Q@&I*?O
TJCYRS_c83ZA,Z#s/(gUfO/>(q4:KY2Gk-UZn.@f0kuHF[E(P+LRB,NkB\o]A%.^&%p`4t$p2
@@>qJ6=8p)mBF)d"CsUJJ^+IUH"P\?:L'S3e!$=C.'^OIQI3,>ur\#&7X$8aO1tohu9"W<6k
(W5KtHQYp2Ug)51OfT:D2dcuf$Ftp5<,@Y=OS%X,n,BH+r6iSYub5M5"00Ag4OB-%@a[0R^+
^4[=ib(rsHGilGfNb.rSgn4-U'#?T2RuBm=W>k&*$n&KOFO$Og_6`0)FJKB4WXoMqNdK2;Vt
(_?SWQ3GBst-QI0=[fZdZ'an_U5XW"KAiB^3ICh43fDq"'bfhBn(H#RQu$Cu_onHe]A>-WfVG
"=X.B(%U,+hrmLX=1Q?Cd2`j&r,e<7IcWL=B*fQ\lnOMDjf:#n6YI*5d*4nB'=,K3OYaj$2c
8O4+'rk3.Z&'p^GpIU9e9X9*:j3bkn6H7/6!7;qZ#Qc8`kquXF)7l:!+sEYu3HTEk&eZ[cH5
BCXt#;N6/Q6rc$MQalJ"E=+Q<oFBEHd^!#&JYE[;!=nN'SjiF+"+;:8V(,pEn6h)uV]AY!A49
&(!_UV5nX?JLo0D=C26o%2,"&IkkcL,9F-jr;GRF<r:%%prL%1O3h8!*!*LD>=$7kG?_tJB?
4Lqm!WDq>;Red]A$]Al@oXTs)Rb.1%=8_QSk"=nW%2mab_u(`ems$'M?S\,[!uSoSC_%O,\Y3V
DsO<2)RiDH!W3Oo<(sDPp1FKs]A\=Fn5b<U?pie'Y9"(kn@fO[@[u4'N)r/b:LMk.!kmWs&jf
BAXTqb"WkF3:(TBEoff:4_?%*%M?6]A]AhL*`NDRq^VC,>g=%=L`OTWR01*iKI$_bE2sAsmLDm
5<Gkf0W?gF4EniF4U7+WK>2#J+(al;becb:<303_<#FGBV-+M<S$Ls`23"H_KQgfZG?UNU:a
ZfK]Acn,1io6f9YOD4SCn!LTuh:A0nf'g-1/8tb=ngZ7o4I/>WlX(>k<\<ZVctXb=E?L^e'AA
S_H5V.*LQfJ:)XP,1'Zfe%T`p]AUkPY[5Q`[fZrb[!]AKW4V:QV''PFFocEq**`a^1nUa^QO#3
i1Z=KoGd2WH);o5(^'Q*2D:1)EuA`=,ZiCo$GMsSR$9M?Ab<'(=t\Ia0O!(0FHbrC+1ldQ,t
,sPF28,tg&G89WN'A-lEU:m[q@+'3+?=W2([/L<"n:bm-?6Kb_rYY1IG(7O-t=K1U943_cOp
YD`pm\SgS#Y2)ho.Zq:NE!DHY#Y)DoubR6aNE)>$MQPq<jL0*E>E6<6-g4JODX^!6Qf)AcT,
fNNOfK0i`oUmXC.+Q*Z'Xmk/6?8B0e!%<anKL=Lh?5A,db"hVMSkG*CqNjToJG=8RV0<$9/[
+f>X@?'OIl:TX>R*mZE(uj7^[<9L$gIC&1#>&#YpWjDsgtDkcF;)clCUb@qjjL^[K-Z";3k%
s3u28LR\//(Jl&,ZH^Ih-.1&JTKX)<i4A0%P8;GnWP:9?mS%dt@;G4"L:Q_6K%>9Q]AinXr<e
;+A>47BO*mPP\k./U@`nO$b<>ANH,PZJ,MY-P1?n$$;j(Ma9"e/7,dG&!4BE^`S:g.WaL!L^
pb5+Rp!hI+(.[kZEI<^`.`i]A2n1"0P54Uq.^ki1nLP$Q`c?Am"s%@*'<PY\81<S8<I&k<<9_
ri9\gS(jS;=W*DkB!QZcL)K.e'[L&+0s($V.HNM`*3,bN!7/I198\"c7,Z0LRKh[AmX.ecWM
/K36O9XUilbEj1]A5lOs_sUJk"ZVIut]A\khTe*?EsU:(-B`Mn5$I+SaL_*C/m*fb5fR<)(N09
^Kg+Q)HN^>0%K9JH-FjcPJ``))Z51``[#6IR\^l\h'(9oaO:gA*%!LW\1>.OG2eb1+A^-uPU
fqln4&X6SgJO!./N,8pNC9p9=r@]ADlG)?d0:'`RS^N105:>SO<`Y-`)1uAVN<^U;Ruhs.gJn
EIqm>t89u/I"F*O;YI;\!rf(-H2mf+`S*J?Sd<Zlm]Ag6'ii6m=;kqe8Id\lO<]A@9U(7_aY[o
Q_NFqh,LTWkLU?T/4kUqq\J#XZ1(n,CXm!>hP[B!ELAe%V-r(Hl2_qk@jmc<-N)+aQG_^"*n
)6)Q&,TZlqM9UOD]AC.*?s4bmmsH*W&3GmRgqOU@[m%Z0SE;LdrQ>6sq(XmS5q]AReQd.8nQj0
7>1fCmp@OYo$HJ.""nNQ68t+g,2;$q=N/_/1S"8>49(EYBJL@l5r>:)0Z(p1`Rsus=>OjTN%
ttc<h-9@M-V7@`KpZ@U)8FO$,).gLl'^5hfbi?kVqb#c&@R6[J/miA89`]AGTXV1#lfO,".3@
uQ2!^1`3\utS"r5g0k/d!6jQ)d[f\FA/e3Q*g!!ZN3Xpa>[%5cOQgC76f_X4>MJ:=JW_mZ'i
GE)HRk3O`W\%.N3)UFZ:Q@JqpDR'nko#?&[1Vr:%X<M/7q.Ba_Y[E/!b1=#-qd\W*1OCbeo4
IEk&t,P'D\CTOgHR5k<&;j\UJ<?Hqbm)c&!!7A[8EL)Lf@C^"ROQ4']A(SUmKuQ^B'KnTPr#k
73i/AWL/E2RVikjBEFb\Mt7V=LS<u\nD!&sZQJ&-n+,C\,lW6_kCA1&cq>2O.)%l5Irt0M,l
(pgeM4175oF96OdMG<$,AN/S*A8Cm@/6!XL"sPL?_IMA.U8Zob/]A'_.12%qkPi<h>E%PRpgX
99bDetH<ml=;-t/-XqIq1kI2juI]AoC4S0&,jX_/,(R1SY4/Unj*l"$=8n5'c"b!'Mc^,R/j>
3'<1GaC-d]Ac"0/Yb4/?pJj<48TX/i;_5A:q$`e@=-V?W72\@"4HNQ'7fl%L`U.M[>si`HBtb
u2$d$-/j]A%\`'rQqh:LS``I&nlUa<.QhJ_R]AFU$hbFTa9ah4^`UNIDTE+0oSDa%F.,.a?t<0
nsB)E2r1p+>ut`b+0eeuAkj9OR;YR&J=RTh57rsfWVU9ND0$flXt3"N5Z-lLf=)u@nm!Bcn+
1I0Jh[X+cpT!:L8bhHrFR1&Ha<mNo6%b2ktktIW0XUHZeafIMtVq[_GIbn79/"8Fc(gGZhB#
V5'oVU'73qgGl8$lWmnN5<'+rb!)`b*#%?E]Af#GjZ:bVQc!E+52h*8V'DplI#V<]AHLr,/V<0
o%*Uh=<bI$Je.jld6&*0Z9%_g:ba@UK)u<O-j-@#<R+Ko&%W+UNpAshQ3`\E4"g]A1r]AkPK.f
_g'Ms)tTEqJbm-tD6$=-@$7r#Cp\_^h5_h#Lk2`=()=V2o>jA!]A^U#<a[YV!)/lb_r^V6JGI
?%da]AO;XOo]A'2Il'e*03cnU44clQZ>L+#p^(cWRsZaQ7&m/1kEDmIEPGa$mppWZ&Sq%k;#=5
Mqp,F:<_-,G_Ri:!bV]ASB?mbC]As7Uk)KV"]A=u34<ZF,`$!nhBn[5DqV0bKIDA)&QhS*eD7)#
HY@<X4XN3hBKBnuE<k<gE`!3oVc]AnqF?nXs>Y%)qf3Hlol]AB<s:#g:b;k!PAd*L*P:[-E13f
%BKE@*F`U8HL0l1Mjf@Dco!hG)uWG^bR*q&hs:`7XYo#2gpuU)iIg'q<:>d7Ji/i)AjDUTmq
cNc`Jj&Q1i<J2hU4nRmq+N=k7)hqB64-:`I5r#FffSe&maaT2,&*B&/4u'q9MfH3<!f/DF.&
dl-mX9.;'Um<C$n+K4\1a-cpmKPUOd$X2ED=u-2*efeH04aB)Q[+0H-^NaRh5o&&_6F;1+in
`cX6HPS=Xm%/)\+do_c)5t'(<mq:qlLP-E>h>M;i=o(U]ArHVek/]A"R40:VX8H#:m8\b'=k$@
<qK+o$,4a?/8OIiTcYt1"@a;`</`4N0_u1FBj'*>kBZ,u/CTb<YQ(o8ls4=AW$(e)-%-CiqB
DtL;gQEjLaQ'$$>%F+,?SA9??DMufD<9`>&\_Kp/;'ZMn[qSR>j;$(:81INp%;pTbWWXZFlK
]A<)K'SWAFA=j[FNsZ,8T.OcH+=M[\USUT[?lt0.5Z8.)r"<]A%r]Ap>F@']A7j$Q!/,WS!gX/B<
kFR<p(=S`qHM71Ih-'Gr4(mQJDa,BnH3]A?'F$iXG2cDZr2eb.+OjD=;mjV%SW5iMo#2m:s,F
i]AVX^c1@,DVFUIa;s.cK!A$2!h\1dO$j[?r9R68@OmU2f5l5F>bhf71T2Zc1'ZUBa20_/4O:
8(S,0&.gg1CT!=Cg<8#UMi4H_X<Jqba/i&j9im1J\r9h*FCo2J4Ru%X/.RQ/X;`Dl>(ediKA
XE%0m=[o[Q,IC&S\46qI+_8P7m3sUT/mUP'JUV-nE;PQ8.5nQC]A_s>:'j-Vh;SF9!nD!Y,U)
4K.uuR=W(EH0QlKK^9KNjhQXJ+#efKZ%g'ql*!Gt/kQ!fm3di-HsSt(XinV+:<Ml;"O_MWng
X)+aTFuIQ`57,)%Tk.[o!37BF'p?ul.d]AfMAWcp]AoW&7(UE(]A8j"9`'`GMGcqF$H0`qiTo]An
cP%#@j=G\jZS4fc&_q4933IC6Bb:1'Y>[G<[WAWMVO[)Uc.4&:ELn5\L:d.@p<NNc4*-1AJT
%"\=m#]ADB,(N$n.[7RaW;@6L6j'j7*T8Zpqi+)!=5OsI?2?>\MiTg`G>B%Pi>]A7/-K;QlO;K
FZlF92B+$IVS.d%s@[ZlMNpt-a'5IhGM3==hppWNn4J^TG1&C#rFNDDoD(31oasgpV<)tNQ-
aFU=.HCN:gnKd;d\*6f!P75OO:'L+oE\#?G;OoS`2a$o-hnlqLV)IX!FaLukotLdnI@5'kr%
A>/)$f<+(,U@]A`B8\Ebi(q7+kJNo#DS$&g$nTHfY]Aq>;r0UR$rB=0O_\WE_5WW&h4N:Fnn$C
LcifiPJS2MMUOo2!$)YB39O*>`nU.)X`OHfkM-1:nKU`@!`^l]A$qf7XM_]AR`^R*>6R)KBfoY
(\#"qi,/WfT9t+YXLKeKV1!MTscegTah%LkqV"K/hCM%DqoJXX=Tp,[pH[)4ABB;ennXXSUH
a4#VKrZ#/DU(uC0O):>iNLnMR[Rl=EW0hpR2K%2s6&YH!<~
]]></IM>
</Background>
<Alpha alpha="1.0"/>
</Border>
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
<IM>
<![CDATA[I(KP]A>?eQp*8I[8MRK@k(O'SUii^8C.1dn&E4<8h"UV=<DT.5qOl?qJ"::<%$#V3kF5D!,qq
h5KhtY48(jkW9^%Rh/bW2<k4DV/!;,9]AAN0o/5!!&+o;L`B\!8p*C!3A4Jr;1t+a",^@!*I%
;QV'aHft06Ir\VW]AG;Yi3?f*uM:fi,d0c<bX=NEAuZ<PlS'DW<9B?qV^-Gic[kZ=m9W_m\*m
73pI-"Bj+G%GB&eQdhu$,E^*Bbt%[UJdISn,82Gmh_U&Y/j@G10R+=njG1lS-M@?6t#4'gH%
,SgA(Y+pP1TC!K<E:et:%m!W/3D8)k*Z^/Tq=FiI4d^,3mTEP<]APrq?EHGS#W@^/BjZ>Q28p
cd-kg;p'Jbh#Df)s32#Ojl_F;ZBq6<7mV.8345H;WBD^1^07F5&rQR2[\o?BI#bYjS%)`#2d
Re+ENY.ogj78u^[EqIeM!WEkQmfSLn8*0hg-I":03@"I&;WU,I4WE+&@i`5n!pk%mH[.;e+@
5d_mS9ckVn&UGdR\fFIrE=iP#l;M__)$GUP<=Nj/4`RAEB13I<&ddg0r=L0kt.K@l1EW_"#.
=kT4`!+YrN5j"NA9.(9a/R_Ql":GDX/?8Qir>FFZ't1rE4K;#r>1+,`_%\nDs[p-GdnjK`#(
9H)j$:srSL**3,h/W$tbb^m#22W4I)!"eH\43N+i^Qo*s&.^aT!X0frl->6Z8\A)8tG!ub25
BF^fKB=64U7Z,2c-)#,SbASE]A&hFJgFk_k07YDB1'Siu;Kt?tV`H#3.k3V&W&tWnQKQH(%9\
062Bi-;Hhp*p*.Y!C"SS9ICd2F2b@a>i,n$NMf=DaE`q7h0,g?>V7"u9W#@/eOF=@3jBb(m%
)4Ij5nE[q[.RK>RorM"T,kht:3#PFE2Q"+m3r]ALW[W_r5K(k&+mrg5A#lMP,!)Gc<sb8YIZk
,f@\LAt>f$8`sM:q^OiLmL5Jbd7HS4[^]ANe<rejLOAP$+_eX>E1SGZcTN*`BE*G^_:C<;Z^.
VZ+k,)+2#og;;.h)]ATR^#_?H$KXIXmi5j0%4jdMEP&^D=uRBb0<:GuE,VZ!33!KL2@%91hU7
s5sJaLnJVem9Y(ehIIp6e\mQ1fGYD+<VUV)fOhr.8J?d$Sl6gAbaomsXeL3-N^N]AC4sMG>U^
ENc,p?uW0T-hdrIb,Q)oaUdi<D<%7_K5R,t8Ln7MZn@WT&/sAC3_pS5+anlSO,;dp=J9h!AQ
8=`\$5;#KaJCDS$A:W[+g@SNVYGcJB.'h&fc,$=nVHE0Nq18u<5VW`K]AXGG.9"S7,?)KlIho
l,6.DcR3CQ1/op`FF`e56.p6i[j=hk.G"[pTb4^fbd%<<U0j:)h(JlkQU8u*0\he<AlRJIJe
dVIAN0/=h9DLBCJgV#Kl?(h_D7k5Z)_ED=sXBCQ)YV:^0[$;QSL_`>sM5DK\)"j#5ncf9ALE
a):JbQ#spE`K]ADT#)l,=(5Ih[pFc<6B&GVuX#OETr#9:=$[IONdhW?l,R:cATmaX$*RBQ++c
DoG`Kgo'A-Pt=JS`#kCHpgc4l3aE\"17T=aD*u9WS(\8Bqk?^YBai"J_FBIiO9<l_.F(R\t(
='NG7J&QR>r4FoKHrE0Pgh2J<m:;[,4l;`TeQ@&$F3f1rn1#K2a/kG6%&md]At:S`s2IcG+sZ
lH)L`(3/]APGc^d3l\=>lMR$JQs(6ADJ1RfV[a$b^rXro(f^0XnVC>i!L1`hh$J2!=qboaPm.
J-FT&MXoZc^5lkNX\%4m)k/:>R?0X09;B<;aq_31m5e):H\B3gtMF7lPJPa"s:>F"Yq`0W6)
NL%D.GS^Nq465Hl9L#+Mm%;DQ]A:+p$V/FAY+l=2FCRO=P=L_,ra#aOeo9RD^D8"CC2h(D40B
d9%AdTU'6%Hm$Vdm_3@e(_873i=Dg<,/!)kc^l6BG+)F?mpI+kSQB[Ie@H.O'>O$3)d?1<l*
Je@JXpdX-/Dqh!Fj,eFH7UmR\+N#sIp`BNOqZ`/3$Di%2ThG#jp0iPC6Uc;4bM.8u`_R+1-,
!Y=<$WCkJ!_'?#U2fBd/QoQ:6WEW[N(W'Y>UPfC&N[%Q3."tQpg5u`jjsY@q.S0N>hJ!*`P-
1mfsoqQn_NYJLYEMc,<4lp@M4X0&oii-j1&`s_hDQYS<ZA4\P35)6LRGJ`e.N%?T)]A0c^;M[
o+Nk#/Dp/IG&Wmn=i>+mpNc;dXap8c[@7:7hRR`H::BS;M_`fU:OAae.mQe%5>7ZiN-\%A1H
0j$8sCmQ0t:9&0Sdb1SG=Rn4t0IhA@0eE.\\BW,lolEJqjfkB)ZDF!/o<^;@^`CKL-2FM3V;
ekts=/-cbPu!2RB,jnU*ph*(<4^$9QeHb5,J453@U48EK`NHKP4b]A)BB)g1>0r,^^8]AnHhl,
</gpT#G+:98"=!Atu6#3G<E1G_0"b!G>1hG(-69$$E#p6"'3lc;_C94f$9F]AN>%DI4j'Aa*-
%Ab?K&L/F=2sh8A)hG_kkEBWbgun3-68PnIJr#e+?9D4`ifE7C>XOi3c(WkPcIR`BU3(N(\.
4j_k"ZBRl>fI#(tV>TGL<K:GrBn#<P[c)j^7&6S3E?Z+=#=Qbl"edi$L;upoToWP:QF]A[^*2
nqo.6G575/;I_Zm;(:Yf9OY:Lq$8dG4`T:"c&R%/IEs;HN_=l-b*j)0<OBTI0/Cpd0usN'an
p^.8#5)UVG&MQ5RK=BqUSO_"8<N9iBGmWI_!a;&j&.ufi-q@chq+JiJLYUc!R[jIDQQ)CV;-
8gmlke2/O=Q]AI!bBjJ&JiKEpLBVe5Qb8jLn%:!>PYDrR_#BlbiqL8rm:YBj#4%`t_@_W2bVe
eL43<&,bs7?4Q4i>j'nLMG9rgba^*llks.I9eQ-"m/M=br?aj&GXDB)mq7Y"0if:U,>`O=*f
l3WPBro^=;\R:QWj.&rONiO75q7p,$*k!%$_<MP6li7RidX%&jK6/U^Fman`hSN&:r).5cG8
aM'69seo?i<EuEd+LrFoMFenU4FX,Q]AbEF:AZCQ=3-6FQXM>OnNG_.p#Id,C[6>&l)XoJa(7
[r0@119TS\LZhs**J/a07K@<,O@2Au@A@+ZKcs-PR+<58(GkY2mjtM>*.8!CYkq(`"'^+SC.
7J(#Me:NXQ`M&UD<ZZ$V1T%4:?#BED^-N[;/;!'DVA.hW%]A,;a9tYSX4:T':W`G0L:=7V5M5
]AT3MYt0M4sV1&AtQ=*LR#0ZF@bdRV>ge2-`[t0oD,@Xu#&D,[4oSDH4B#i3F=jJa"b,bPHUf
TtPdO$r^40aTh#.E^H#u^)+j#ZB6#$CY5'SVTQ\gD*M-fla@9>#tt!=\9kEp8sN%)psT<n,?
FW1]AP4k9WM^J?kb8]A=4`ab#RQfB`Gn[3%16ofR8>dpT&^"m3!`rdCF?t:Q'k(7fS`f8nCsQ%
3OLn6J$WK&jYK_^n3r753e(/t>RVGB2HSo?#gE')(]A?3pa_QL"$Z$&'/k:XZAheQ/BR7PIPs
78HHlk=O*qY`36@$p');rNh'e-!iTj91D,mq10@Ua[jNjTZ@7H0da<QRf_(q';N>eEJPD:j!
uP^!3FJ9+L+MOhdHHA5NWb2am'1*ut-h/U&tqf($W#J,f&KZ)4HrA'b$S)ep3:@iCqN)<p<K
M(a]A27JL2b79M)pL2.='15Abm&k]Al@=C#GPAG-ph8.rNKi,h'6QHLZPe5GlfSFYBdB$!ej#\
"EV+<>'I2snrB5l"R'1R:IJ\[(:I%TTAN@e+X^9+nS`L-D1!FR/0;6CpPX(Fj'Yd,KD]Aphj]A
n)k_leJ78Q;J8cX(>81Jg!2,:U=%@*fiT`E::%7Ru]A+QR"@-FNTcW0?k;MH22gh7E?qI5SZ0
3%8nOWeBjK3Q$2(Yq;_19Vd]A;RlHS!0PNm.r7/@K*J%h-Qe3YS)NM2>oQ\@N^X-V=.YHO2Nk
"6p`jQQCRYmt-S(7[*kfc)C^QonA*!(5%iRHDj"moZ)<cFSj&4ok)W5De1qqEuMn'n$9I,]A4
ONS*#Ir8Fldl1Z%F07##1gU/X2NA&f/X8nqk(Y^>WU3SsLZ-,_GR$5(,C[k_UabP4]AG80@m0
/NqktLM@*o,t-OMP5]AO'TR]Afkr1:iUlMm4qlWjIui'VA;WKJ[lq,k`ij9l.HjN<oYh9pWZlb
$,JuNU]A,Iern?"0,IcS5T#qXMBRl2Qr"dno+4o28;g'[B8.8lcoG^\*6'49_W'6.kS_)Nk!i
Y<`h@/M.dRBQKdH/0BAC&+/o%"'A9N@a9/%:V#D$?UY?:&UB7+7$K`#@!cK,j0W$lk1%I)gE
="*T73b+Fjd$:ptUbLnb9*.K<9![Kfi0AuGZJnaE!=4*Foi1&Mb`(i:Dc(ka]A!aHos&ilkV%
\o`cdX3h#+@neDa.7Ebc,(8%Nc`/TZmsR*7s0H78?(iS-2Ofpll!LfK6p8oUO,&`RnBY@6&2
-a4cYJu@S_<A-V-fCsOsQT<oXUQmS+;W-Cueb*eA/S"bF?p#ZO-A>k4##14VuQf_o00?Tnh6
la'PBjI`cN7<S^S&l^k]AQ,UKLlD:GbglF3(YOrB9@a$*Q+^93&t5H-A'17*D,VX@InYU5Iu@
`)*[a\'mYO6c6Iq;IW-,ECnI#'$3j`?N'h,,IO.[@i%X_6SnG`.ZnAR-C15^fUE\5ZpJ;0_6
k]AAEi]A`J!NVDSOigrd^h(]ARW2an/'_^aRB@.P"tjO:HrSq`GrHd_P<#X13<9ZJn=G)krPjH+
p?\)'e#)YuM]A8XB%_O.'%U`t%<e&DAjQYMo/e&FaoMk0M1.%k#rq*r,N"cqF9?Q,D6.tg?Pi
NI3"f$PL`Q1S3hp/\V0ZHo+#;uc2Z+6Bl-o.fYF\VXMm!?U&LjI;ej@O`hBUPHcPtZK`ksIY
YR=Yd\Q`b#]A=[ODQ2DM=gEqB_u75UQ4#9^EeAoAp.-`+j3KF.gR-\WmQO[B(&^:=Cg3j'rA(
N)0hW;X:C)_STA?QNV2lS`WC"/<YH%;o#8-fVE:H=cVhFP4BQbC$?SYuKUWW7QT3Z_HP9T)`
&D:VfjunoupUH("bf:qsSe9\:B6ncF*CA_)LH4ct-JVeq?S14Jdq81<^^^JYYZGfs)HbXVAu
!m6:qYki"2:_WE0l3treOPhbXj7)4+_f!WPr'iJ=U5Z-f3KY?'$r(R?._*48dd]A5H(;Mh+S+
k@bReA@C(`-O^eS_92=L2X'&*.)(@^0O-cG-Gs=e:Z44kSV_/=5<[_ttTfe<01q&Aci2Y=4f
;k*CrM$ICbZ8o4I_bP\K@1<R2:Z`<RbHFE?=c=WpL$W)!s?e*Cp^PPt,9%Dq,ffSVkfU/\Xa
QW_?BN(gIBUfZLW)X.e0^2R7l&Sl;bV,P46T$KT@[1\%MK3i2P1PTM5nLMVC]Au8WZ<)bEn.=
'45XE\.'4-jfDaI(&mCX?BbM7_*]A%"<]A&1\K\efgMP8HsB4g)[)<?]A"CLn^)"9:CiIq'8;pj
TmjhS'5$6f)!?VIB#e%$U>:!4&!HU7IgI\sRiQ"GMHbPYj<f/e6`bS'`DlH#I=qq#U*$\"le
!>DXR1uL*)nlsE.+Q9d^\jdWg\sU.pO/4SpQpA^$MX1mFX3j57?9t+a\5&nQGGalhmFq&l/L
,i0pJsd'O9U5*/u4Tt4o<PrPC!g;$8O3gpMhJ'RE'F&\ZJOrrO3FcU_,gjSeuM31t_eK!7eS
d%#a$f,PjI&J_2/!*<S"gOPIj_a7Nb1@Uq@dW.b?&?%(%:N9,-SKRjJ\]ALO-mc"QN.I9u6Zl
rERk[u_PC+mU'1:81"X\=Z6e#)<-:MtI(=f[QM_,d[,'iOg?La9SV0n]AS.A8Ba"2A.l>Adi8
>9#L*l)-ILXF2^=l%0P":*fNQ68#YREP&04R<GC>#&j23Hs&7ZIMJ)dk_.e,Z(H,D%VA;c"T
'4Vo"(Efj5b<)kW9+EpMMX5o(oUFG]A/9!-F=iO%]AWAWL9;`e0Y;29gWR]A>pLJ'DRO.`dc.&c
bXQOY=6l%,KA[cC,e2hQRH7aOK)[;`q`0*A`+FlNa,R;^VmY`:0?P5)(BZj5e_+1TY3YnIVP
3>mj.nV!a+r53563Im:a9-U#i*Y:o.k:1<1WLQ^.6+ESXIqgOh/ZZ=L:.#I$Fi.l\'W;r^pb
4N"4d1;[iXr/5%U`GO`1;o#e^cGGH0j&;#m_]A*mgnF8p!ahXn;T9,?[aVWqtY0)o>f@n(V<G
r5_1I=lCoD.EqB-M*TEK$s=T8O6g'M6A@c1r><Vl=FE9B%4[b9Hd+6CI3m5@8nQt02OSn<f]A
IL!PO=;6]A'CE4fHkZp>8InTo2)W((ns]A_5P]AkY?Xsl>*a8f2A0Va!0cMVTBAJoaNGJ*RH8^s
1Mu#C(7&e8#j;A]A!As-^pV8XWF`[B>8<+M<FT96rPN4SqIXa1Q.^A`de(XNnlpD1/,CX]AP\>
#SNRbI0]A:k,)O:KPb[8a]A9UDp?jcOcR&i]AP*Sh/c^Zh82V7[m`*(oUSL\TL9+!6F[*S_Tr8(
W-!6Ihc&Z!Nqnp9dc(&@;/'O+Qe/`NMb%l2F9e!,FOO[<33GG2Hr^5+,0:lC%)FYb%ElNQ""
G6O`#G]A;QtR`##-ki[t^k;EWLF^"\XeZr?Rr4B7hOaE'*`QZ5P!qje.Eb5YXKB5u'ZB%\HG<
O.Q.V+I>Q4YF"V9S\==ae1@(1l3:HJqS38fh7oAl71(\p&n:jN^o5M2sc%SDi3!TMOlQ,DP:
dC<?%\8L3F$alhH=KB,b^C$b2LF$KT;T>l^DkmG'-a`>#n3"j8Y4(3Gf;5^t`-qE9^*/BpMZ
reR96Pk)-,^PM&om[qi_Zae:KN<-Ff=jJ2[*?I0ARR#RT``jBc$q#d*u[p:9V'qNr<8+qBFM
2Y:;BR#c&=:H8o62Dg90jrj*,\e[(k(t=WMTe"*7?*1A3fnnCUBkl>T8K`8>%bO1&gaD3k.H
VB-WcZsOm5e]AV;j\$!0qM6hdDqm#M0]A=cL?kZ.ajO3t&FZC$iEY$B3%f<?g`?XJq!_.P\D2u
em+<tB-L0K4qKnjb4Ll+5R+e*/bcN^@Mdk+JjFA:j1rqdb=0!LQ,D*WNMe57XQ`X.1ENn>+@
!nWkBn::^=(M%u>WlR_ek0_2P,M!*`lC*a85Q.F]A\H#bYWHB$ZC\MHa<YB2gea!tbJQ+@=V&
u*?^ThViUqA4a4?_AWd6(W^l54E)f(hcGJEl,./-6DhM9.83Npfs_8;+eFb+"hb/CkZ0V'u>
$E&Y(![Y<)<ZCd'u"ICBl&e`GjL"_2^UPriTHp0'W`C;+ukg+%Ku41]AETR(?K9^KN^6^!3=c
E3Fik9TdDR=<^i/ioeiB6gLe4<Q:h06cnqYF\I$Xp^2J+m.h4Q6#t=tU;W]AEAs74TgKci)rT
U_d]ACmW:b;makJhuraSE>22,l,_l1FGio7XI#KJD^:!4>dX<RWb-D4*B)H[sLV5YB8`Rr"VD
(P1n&gBq<_r,N4LW,dg59bKmjK.da='`ql\B^m7Ht@c-a#(Y>,nR&]AhlMZG=HFU/qsEC(W`+
cp!0XJ%S0.E?:2Y1DL-'$P-<$qC)C/Xa04%+817fFne!bni'VNfB!KY8\KOYJhKA$ban/S6L
\p<o,74RWin<Hb6C_LtMB&34?3?VE$An7bMW<B);3jJfL'`ZUW2aOiAFV_]AiM3UC11=l=R\A
QGDR.n!$*o(NEVSP[]AB2A>:^>V59`4!o4jl8^?1g;-?lTZ02itp[nWMkKLKHkf-T,2EErcFQ
s:/`]APIU65+%/2ZZKP6$eFu4G3><5BmP]AJ`nh20cLVC^W:`0fK,Rt(?h_dC1\)6N,@`uV74<
\r0[L(%UQXc0leHVfW8i1@4s;.O"^;n)F75eN)ZrsWXJ:Q-SNJ2:[k"s>usXM7UKKDqs[9Q,
Tk,H\M=jr'Nk\"7&t/@c*,K@s#IuuY,L%:#+Vb&:NW1uDmR!tHd7)BWFWaA=a.fM(L2Xs(EJ
$HcI_:@*:Aj@HA*a#6i<j-=kc05oJ_P:hVL<!-3PFYK_/\jJ(<emL#$VW=hSH^opRO1;qm:<
+6R0C$,([V6.'k"oY.ou@.cs\mr"N5OPCR$rAS>\M,&ZTV44):;$VY9#ELHh"M2s&E]A=<]Afs
Z#SE=N'M_Lu]A'/4ghb3TbpSpYAodrmuR$mf$ir9r^Qjo-?B:l./%-WdVVc-:@0JN9HLemDV<
nL-?QZIeNVrF7q!TM@i).YGY[ZbYS%%#u53*pe+0tn/E565.+ST`hOE:]AN(1SY%PW?Kc:"_,
-6-']A:Z6&I*1=mZT68PKViEE3/[\TPc)oT3TV[\qX!C%Q.fP@kMY\i]A!YnJf&b2`"<Lj\j9:
leJ\(b<,,]ANE&1%%n#Jt6,#9r?5lZ@g_$?ltc7"[!DVr#!s6.g%(o9ISVF;pdqh=8O1GQ3X4
/;a)DQ10hl;EeYl(d[1s90;:O(f^,T:acqG8T")gJTYpg!_o+%.e!`E*bo;(IU6ZQltDBEUI
@V((s,&1qfIEJiFgAFB<"u[J*KdDjSgPTlX/cA-,EE#Nbnso's9Et^WgdI`5Ktq:0dCje]ALZ
42LpE1d(S(Oa^YR)oQAV8nbW!??tH6:kc`Y2pJ%bUfBU/PZ5S9k]A.(dWBPmpL)JKp3Eb]A2;9
[]As$H?QA>F<BOQhg:W.UnB3il"JOG4Im5,Dq"]AN#g>S57A6g$"AfWCjf+kf:N[L[U2b-Yj$A
1Ai7Rm^="tWGl3gW%i#RHAR)\jJ<)2W1e!'>P^`1js+=4QThsL#kq!NKc/=>D/-.M>B[8A`h
3ppo(4#mCgV)^jXbeBF+\ZV?>o'*_\RF'-\W6*]AK2NT:,;f@`05_i^N_nHq'RF*o7(Xo,*X3
H73q[,DP&Km_g"b:R\7dUO)=lg(3Z1gb&/pB;$+AOpU'F\)?:KjuQMGTR!T@k%30hfD(Opc=
R[oI@1&U]AJ+9"bUt9g+T=6$>;_2U32>X=U\8/7XGGg.ah<<GTZ;\$#StkKtMuP!8*2ag7\#W
jo/Y(<.=;N_C7u^N7hbIKWrDR8E>p;_n(ZrT%9&9[TL2S(F$bEs:WN3KDf]AfB"K=>YW!eqY$
A\,n_JDO<q79o<Z@>*OJmUT:Qb047otB,oCf,90dqZq7Grp/s*Ot;?r+gbrN8BFR*.TB1N)e
cDud'F4NFbmsc=>W9<?!=]AQNJ2l\/o\fE;mV\:t86C/eC7B5JI/!jn4jmqJn,PkYFG6?"6BO
iM6f\e+/4*8uQoTc<9NILMNB"QOK3GjT:o%PqKKr3*)%<2]ABYb!RdL]AH&tFKsk*ePXW^HuiB
YejSLJpKOi-RHCa8(P'BhpZ2H4`GR:]AejPop#A[&5<c!7d&@\'C0:QcZ<HXYE;k','(]A'H"+
58;7&.Khs!BVbD87]AH3F[/sq_&3",UTO9]AJAEg+J(_?ER&%6bdQVL%YdZhS=n=K/e@'A1M&+
3]AScW/sorD%mgK\H?cI!ou3@)lMB0p69BaSU,3!/gCbj`i4bU<icG2budPg[ts$8G:gBPEmk
6PZ?4i1n.]AZd"'<CGM0:>&,3+N`M2oYIQh(,SUX)(0b&XZ3Y.c!q=lY@Pn*le_s%.[)Dn<4F
M*\@g29NSB*!3/=*XI`H?>=Q"Acs^]AH/=Z7Kp[%X&&N0d>pl$#a4Ti[(8RRMaL<^QtET!oT2
Ios9@3[$8<p!akC0fDfOAE6pA^GU2=:Yok(<C/0pkRaV1P28IBe_d$VIhAoicqG,`t6_$_c:
l*sRe4i]AS7hEjE2"]A?cKVO4m37e+]AGKdpOC-r[&4[QX'0b/^%S`Z=08FY6T&$MFWBdH>US?]A
Y\;rh>?Wr#7B.;^"2FtX>S+?TK&%L!k*VDm:/\A5Ee_'u$\`6?t5,A5\L)n/3O-KLOqH5>12
*ig"DW#9!\aIetu(X'N;6Z3b@IrL1eR(?:7%6KZo]A,CTRFI,sTNEInB4p\YY="tD*7XiuZr%
^T$2[\AU/AH3O]A=[aJaoS>%H$qbV@#9iF<YKF2QDKruJ%d/65(qlWBXmJpq9r2]AT!d55lu1!
b3U735B>LW@"r*&BF^;&]A\VK5MlGM9Q>'B7<;RYLE2AgcB1+'U)9]A&H\aJ'BYSO7q9JaKNZ4
j4@No,0`tnWe?&o5qHUM[+E?%7&hViqmgo=hFfsMh*De9Xi"Zq04-.^^]A'KHXAd_%n:$3gOp
`TTJoTW3pl*c/n8!'Je8Z'=!\`Ijr)J+`TMRgbKu#to7sfpZ&OfLqBqMBH7sqB<+FE2Ih'-q
5h)#bN__/804PE(eCd&Kp#h/+&n=31+oF(b6U'UC0oi)<3+VSemo-"?Z%\n$H>G`US7$>;ES
eerAfOK:VW"cnhl=rafBV,RHXUg5o_Bn/c&b`.X3Q0h7kh'CE1UA6Snos7&t$SoeXn@CGs!;
\Pk`)+,XBk$]Ac?f9]A%Q+DKiD&->I'P>Mnukj-gO+d^1le#d94<BArHGYJ^BB^JW$k&g>.fdW
Z-pJp%&f>#4\>Mp"=\1QEshGF=JgKlXUYNW2[1%:n/DdI'JN8)u"qC\I!'=O>PP4L7/Mb^N2
>X:d^B^D&=F<FrV;<P.%)C?`fZs)aDh4kO%,dahO;uVsa*>3.%)%o13t')7F]A-(ulFSlIHBk
id_=A#fF@(/_#_Um?7PcXdWbV.UZ7pNNp`^993#K5$P?$WPg)!iqs&'EsCU.B'L!cJ>Wmk5b
e_N`R'$.Df5;@N>O\eI$=aK0Y)a\O(W,a^)tc2)Z1!?6\k[GI_3nOa$&<`;E;c?jIoX^k*0*
[CI18(J%O$E(kh_/5PdFA:XYeuP4>T<6Osa%]A\$"]A"kCTpcOF*p(qWSMBjWh2=HM]A$45jsc[
6OQLCCeWRlMlaJ'o=-XVCEm[0OOfq*e?!c,FRd/Q^G-C]AiH[Ne)=q#<0K6LGHlY_r4T9n8/?
lBiuTU/kr1"'d;rkdo(m$s/V6Sh#Bq<ZcO8K7mTi4af;Dd-d<A[<4`35rn2N`ekIZX,?)4:;
1TgSUhQ_m6N!b&ECK`Q%g=kl=VTfN,X=[dR#$jcPY^Tn-/LPk3RXoLQXL7Phd\<QSqm-2OP<
l9q_96Vkkpmh,;:V)TRa!AJ]AL84Q.n>Y%AP]AB:."Ge*P$WBVk-qV#=&7@nN\,*(jTG/09\-Z
W=..tgCP#X44uQ2%XgB*e2^^p5+6"bus7W9$^p+KL@8L&',_(dY)BmFL^!]AXghN1#3%IeKkP
.D2SDPZ"48`+RM:L3>>c;1]AABE+bnW<1GdCSZ)*.W&-:@t6NR.p%kJAoBU^F+j[cT:sH&%9j
bbaL)rdhG/$.(386\2-=7WG?1q/j[^M(n<<Tgh@36g@`j8]AmAgo(h[PNc$,a5u26Tdtkg_8(
"P&'02@`s('*eVVggr"MCQ4K0(ThOI`V.e&HO#R\=UfmSBo[5$`L?\,\5$XnZb_6EJSl9BQA
VLkO/7S"g:erq\IOqaCj8qW(Fm!h\%Q<Gb-h7V3<Vb7k;GJE[34Z?H%jO^.Pk(l'L+B!B[g@
[5*odLhXsRLYJfaM=g*LSZ.%KJIr/)B"Ld;UO&Qsu.oP+OIAcc96g;#X?IDRl!,GOJ\TKr$L
=\ZhM7%IU]A$#"QBd(/TB[3h<-fd0u0M=2,)PP9hItsh`nA+[,YiUQ=0>Pg_BY,&'i8o#qLi&
Yn^CO?[-0U-*;AI]A:l<0.+40DE$/.kj5l)nTm>u8!AjR]A>bQfCI'161aSjQ5Sm-LJ73Q^dVQ
@bWpD3(8CSRh=\]AE,P1H,B`W_aX"dlR5#'`5(oR)EN2jj@0XHPk)<&L<M<3>-s\@SICqi>5X
g<:CnV(oRj$/[R2Fr`D/]A\aW.1*+c@BmQY@'=D'4BI#1=.rm=C91!4sJH>e/Uo$!A9;nK8`6
p?ZFsFHNU!m.WYXV4":`T.OX<pP5ZVMbp*9X\ST+.r^p8W"HW_3G>8.F:tcc->,n7h"M[YtQ
E6pB]ANTgfD$H-Dmf0'7+g>GCM)mi0N<15-qTkb1`I3+p/gHh-nt\oa;/*c%O15BWBYP((#Rs
lqUftt['1#pg(2W$2gW/;!K(3[iU;3Hp^u%3\Uu>W^E$pTp2AU/uNIn(c_kklB%W!OC'V[8%
;X=pVT".L?s%B$0rQYWa538BBmC'\T4\E%7fllp#>WD%:^MPpO(>E8rq0"b`Y5>SgU6<$5Wc
3Hek0DFn`TC4dPpdaA/TICBP+2Nr`'YO9AaA[V3i05c+ohh[XdVb$U!U>g^#VL:*cX%81q>0
rWnJRH6QlCH%YPdjQ9F2@\3i5"9"Lk+6SC>=_-JHgTj0=$b[Y:e>`NU\/9_kD39uN,bXq7p\
[R=/#[lSNp(dWZT.j>c>3NA]A.T%q#2.Z,+Xqo?#nHt39\JHPED5Qf(]A$-__8/q1$?5d;&qQF
.eq4mYYR2C]AdUFJDm3uKLRn%Vlkf"&7F-BmiYPK-jT_=;#0hW^Gf*.juTpRF?%f<UUSH'U,%
S9Z=]A92BXiacKnTC(?t:<H'U?V1`Cbib/6;*&$<7s'Zm)m9:psHmJX$QK\iDk3I*^W[J#"m:
OcS>-GX7VtBEk?r3")Y2Kr2TP%Z$>kLsc!.TDX30>5oaX=>ao2,ie+s&l(rg3S2nIlN$^\>?
?8?65<f%d1?X=Jd7+8=sr+O\4s^Z+`@6dKn\7=lBi/]A!-a9`'Vf'0(+-F8GAk7mLJdPf7s`h
9D8<_s4SO:D:6X//]AY^.VF4kNUneQS8<dEW<_7Wc^!d"!7O,[^0Rm&%#jP3&$)AXkDKK=U9r
=I(AO6_:*3'CD[Ks=X9Bis."r:JBU*3^:jA'WCiVM_Vl0O.%o>ql3Rf2:38AF7Q/s?i7$S8k
+F(mA\fIh-A'Y)XIQ0L?$@O3!2debTNJhBF\Fh^\:od^M9P,>YG6;&[=a1i6+9MHj(=HScJq
Zj5[^FXa[uh6N'D)Pq"?ZF;co^th'M=P;B*'$T2<7h6#(7a#1!+QME(pZ<qPmInNhM.)#MhF
_HmX8BT*8$sL#84qmCiS!f=-u]Apu@gIFg5lZomJ)`hToW$o_Er,Th+LQOqmp+mTD$lg._Gaq
3[>MD*=:,e^<125VM$#NT'ZE:H`-]A%>$aGp2`07\afM<?U+qs`]AXus5'sc$6s#!^@*,';HtK
9<"a5P[`r^hCB.MRC*skrX^[t>Yl)(WKVX'q5\,tBmfYr1"Ee@]ACNJYkKmegl&5e6?5hc!7e
G>r%5=f)kAVeD+-L]AJg'E=$A\#AnflE*_GfT1:/`&-)276a#p/M'`$p%kJ2P!_32('TuiAmL
3c05mZ;&=S*.O=9c:qe]AQ'mb@2l[).S(U<_E!g&>]A3;KWrXJc=Y=D2R3d#O2#5MVYj@[Yn:R
+nDCqk`m3;ioU[=b9,e?dYHOKThi)C$4iDrEB0;kecg-sGa//R`%>A(`K8'!Ui9'e+dhHtLK
/jY?f7SB0$S=KTMm7Bf<gqrsX.6&HM-9m&Gg6k#SQ<UZ"fI'\2</N<U/suu)p#jsRuH.(I.<
L':5FZ)OI(>r<67Ak"Xo;T?Z"ZWqo7Vie$-CS=IH/s\(`.;h2f@+Zq[unkMU8jQ)J.Y>En"`
RnpgT$-_W&Zd1Z<a0>@@;XN%QD(?(Zp6k9W.^<I&2AAjbMaf4Ta#9-bB;W*t=\75^7t640jn
*R^HiQ[[I6l"D@^':kr@[)@jfIoNK)DH)D,W4*cim/,!sb70,+3\0p-#;PS>k.d9Op:cKNn/
.d:h'UoDu=8Ya;]A\p'3)4e&3WH@0bn?4;$'To`X$cHFf;bEIi*q7WQmLJ2HB1EC@?k.=8&64
AoG",L0M+-W8df^H5.:"Z.D(,*BcXBm,E@Di]A-eX!'g;8o6')*rsR=ic!O;@:f=f++=;NAT\
EpPC,448XnsY81Aso,,O@R9UYoGfD%LN4daru2DqA2DJ/[ofP=7p76I8[rV_dLC<A+AX=058
]AGuPJ4Ae^K9;q'6Sh&C=j499"-PCcZ,b,*XOl)HXYE)9_-HlT,2Kg@W7^(G7mO"f\[BVP.-d
Jf\&Ju6A]AO`_NdH%@crD3<qosZ&WDJ39V:7*?Jes]A3JIZ\0<%buI'B8sC78ZfJec"'N>qR<P
SF^4dP6>u26B!mV<ThbMq&+i]And-2M0`ojR^ZG+9>0=EuI)6+I&+(SROP)c2^oeQ.!+;B-;'
p/4`Nq%a+H[b<JfH6Yu%t`-d\;$aLD`4Dr5)>[jVHMO9`r"aM@3Bh\MBLZRkrWp_d@r*d?lc
p+l)ZVW$D\\\F6YY%kD.8!8=(/BF2M&"LW"GPXgVX5#]A>Dm]A&j5nVWO'jKgZ/04F:J?#'-^J
l<oUjS7kWKo&H]AdB?e]AD1i&jF87JAD-!`=8I!5@_b:S4B=-WMsh,!7kWn(tuTaTTRmF'AZp-
S@.kPObnAGQm_+N3&"RRK:Q/-o<rrO+$b]ALn)*<d`,cpc,-TCN),m^?Ic0m;?m:#7Jo2>.jC
MAAgCM<#sVf$no;]A5$^5;DfKnbN?DhQ[$FQ<"d(m9b]A[dhh:*Yg-*hf?4.<hBo>j`uh_Ao%`
YZVW3naD?L<U/OK]A(%e&TM:L[']AiNN[m6.r%gAuZHNqi[iPjNm;$Fk"RB1gjU5u*IZ?Y2-Y@
U>$9gL*rIL<*]A4^2?kk_Klh9<k]A>78bV!q:;*EZp"-/Urg-H*U!l\-gj7B7p"pT[!6QHt+,'
9C\Z"3b2ER["^r'J)NgWq3;lc[<Go'f@oK7<3]AKl^8cG5ikG#IdZ$Y*Z?Fn7OsT=Ri,.\gn+
8q"KG'%(`!lj2<($f>'ZM[p3[KA%=E*t%Dh0WAX[hJo#-F*c10?h>9"^#qYYleiYu6;(4?XY
MKTH_".qVcLTq9Bb9+_2#GUp'N4m374PsbUil+M58.I=s9*.eW\^ITT/#b[iSlk?Kks"YBCY
]A"@h[IK4%Pk:S.)uD@H6nH#WP?P)SH%G-6Dr9"n3",FV>@1=f)O,)d!PI@_at4,/8mjmC`rc
k9fXr0MZ$b`X@B0EQWW<Zk2-ZOI%Mj4tLu;`59&h2>YKd,1N@rblml&3<&O=W(>D=odM%7kg
KQ@LqJ98NONA?q-SaU%?**C'pX+=<)Rp8B=!O(q1?pci#mT`Of1@t>]AB;]Ab+UtP9l2_cgJ'o
0VKaSB\2q:iYc&k*-ipr@Yu'^2__q>%T#.3i,.*%6eaT4_H>Um0TNAa:d'RM*U2E1nF*.hYp
1('Yc)NKs+Q<bA5JaD$^]AAs1LGh:gMP)H`!<fhgZ[0_roeSbechX0>rI?.J?54Um)P9F&u&I
`1=2&8;Tn7-si-,K_\7Ua2j>&p\FHUI4uXR?PNiY-]A_"%$*IL9nSuZc0KIK>SI#R)_N`Y7M"
Wu@mU?)4N!C.MMB>K\7[[CW>QJ!!.->^34uFZb/f:kK$uRIgcp/k-f8<0%kG(F55LFHH"<Bh
h+&mh%Fop'C^G#3EEW/#JmpaIc?`(R#75nHN9g[D/CdsonO$7SM:Mm>qEI%]A`2L%4,&J3f9Y
Pd5*oF<<%cOkD?&+XJ>3J^G+T@n@j3P3qrQg=*?s&?=Zo@6-Sd(U=K]A7scdI3.4!r)GP7$OB
+G6!A)r[-Sp<QaI;HX[5mr[YWho0K(>k\KhTctBpe3F13^^5P:*VcB,3A_djNSMeI$U@sa@D
X=Kj5!^k+F'TlUFb;rU/@C5Ljk^d?mngm;A;-MC&FrJMUmct]AKnS7dD$B_G388gjPh;W@''a
Wu+J*UpcS\rA7Qm3_Z<W(E"qMZoh1527B&kSM:Vl',oWJd\(n(JemE?=5Y`)'N#B%X4hjg\f
Fa5P8$10B(0o=(rs1LG+]AV6BM/#$SSq<j[>!$R9k2A<6p&!>H[^l7sH-1kn*+d236D!dG+YB
iK:9fpM5r41GiY^rcdAJ"rJc:KuCFO,:f?2JAq:._DE<t?5frc4dl31e\VX[8_`L?U$L%>J^
NrQI<&,5?u=gNj<S2a:Y2ekJXY,aWC:.?aAjH2>1/r!n^d#DJkK).c/q3FuN&3;th\U]Ak*b1
">I-nh=g02W':!q]AV7GlIoW(1#5/p-4%CMbFD@mYBg%@F0hK)?,aeIM3E:ncX\3FEnK_Iq/U
t[3VE[hOEr_&"9fro;Wb++%\=/\U5%G&/+A3q1(T%CXhWE^)Z5DfS*HrIm05JhnFAN=7Df:4
20WcA4Ze3AqLi%D=KL.!<eNf'-Zd5ao>dK#GR1"3Hm&.[$Jtd#%="jCrEiM-ilqaF@:?E0R?
T\e.be:Pb[3Nj)`Q@gUI,4kqB)NH-c\a3.To('AI4id.I9aj,*[."Xb?M,TqRe`(2KiI$HWW
;Mo*jS3Eq.3LYj?D>YG(-Vlu:AO=m"YdH&SXF*5eh^n\&Gk0)F`S05Zni0QsD_7tLYOTnH/U
hZ8b<fABI8ZY9`nX7uKHgI"Te;IdV5h2hX2=P;rJnIR;dPIM[W[j&G9'<pO8.4=CQOR^(3?H
BHI6QD'FAT;W^*]A$g`>AjH=BD6>gBma]ATTj=^Q_ej1UWTGQZ`WS/>uh8k9*_Xi-l="?iWuM_
E+XP+j5B_uUa*HD'=b3NabH-FpWu\!X'<<]AbFTsI0`Ao'(0D$S*\DX7Y3'R(1ToR\l1U23_j
KNBf@/X3-T0UVZ/Eh,9tYfaC`W6IF&!Ru7$A8mqUK/o.OU901Trp`:s8;P!SHeUg#;ce,7s1
o^K#DO[Om-CFaIEI`X8CEU;OaN,A1E9TH8Lj8_Y@kIOaACQ^%hFm!g2LHFrZdm0(eU@lk\O%
\.da$#UrH"I:VbL6kK`k[EdA`%,p:FLrs!<9]ASb`Y"Yr<(sR@OX;^Z\duF:9r6lGMf7=M[6:
Kj5b,J@(?u19K0/G3@PS0^A=.\RTS[B;NsMcVl,gEMnopQFD$,5oCF#Fo%<dSH+9emDp.Jc^
@Y<H$Hg9EVY4o.@'_/AL&Q%&8`e:R4<Knf(,r#E:*Xt5uYF3">1Q:3#Qj,f$h-h\E`ohF.(G
92Rdu!3/qljBjqHG/"R8Vc`-9W+KNJ+1uqlDl,jhE+p[;?-uQ-IK>m7t%X,bJZffGBu^4(/2
br-%ZuR3Qq4k?6GLT'b1_?S7u)%U>rC?2hQ$3]AKdf`X)>9R*[cLqG\9`$uqU=7RujUV"H[rf
hE$"ci]Ak\gpPt?q?kNg`MTJ\a%I0l<CTn_&n7+ILDI>n'nH8CD^Qj'S/^d6lO;$-lpS.>)@^
!:KMV?)KU-K\1%_!Yl]AH+4iG!:Es,rqp@OmJEKdgIKc;r?/XdQE#+T;>=L=:AAE-B6rG*dDr
(OgC=.@+kngUBDhQ6/2ci&6&hMN0Q.Y\UKI)<gjS$Q!`h.-gHM:kGea+1'r!pl$0AM^rg<!r
_>9p0Mo@_[GN!?a!r1MqTFidOc8O'HMH;RhG&!JPa+dTq\aj0Yrlr$MLSs!HUnXHB[\4<f`U
'r2jW`_qP5IlBAqiiD-##"'qQBElm9BOOM3.8a7cA:2HkMQEN6u!%FKTOP's!Hj@EI*Kh!V.
WQH5]A1kO!L!sVEH;%Gkf`3>$h\-AsVKONX)RL#C:>bA9G?6;^n@qfN3KdPOi[s.VdX<)a%<U
-pjTA6.ngBe[kdUVNnNJPp-2-i_^O.l?!Y_H^,$;C`?2CpP<K`.aP]AQbj%(af.-%=]Adal5-!
1?I4edWMjOYPM<.e2GV>]A4BI6UV<#0L(:6/:LBHOcXcoV=aBNGeX2]A77J6XfmQcB0k+9dXd%
%`00&_T5PL[X+T@?jX8Z[&/:6"kE7F3sle*Y)`o=T#<22ocYK_W!&#`46B:#J.ra(6SoABro
o1tHt""N""=*>SQ]Ad>P&CQR$5Y<=T.m)c:SA4fL'l4V5sMerilA>Y6kjFsW[jrgV'eI#J&CD
-.(CO<)ia]A*Xt\UKV8H'<#dIXOKA.j*b:&,pYf,P`N#lVX^1c"9&q=U;_j?;1ct_<rQJE2@&
i'aK2,g,(^/PVB`T&,_7NhCc-r9E"V_*eGN-A^=Oq'8_*4K'F4KI3sW7H&A230"X>0e70P%U
2Bu_hKFP&ml4tDN5Pr,h"FZm?'1q"9_iQE9S)NY[APgF>+Jp[F2OZ)"r:Yp<lNdo1_Oe`]Aej
Z6!GZl'39g%@L4fl/<k,JZdYQoSNdO#HUE!3>0E<Z+!!nGW>cVt[=gY%hLc8m&#>+W9@qTW$
lD!,6Uqrb3UGGl>67a6^\?^mO]Ad>T@=2Es5KR3_[#Mi:5N@O;5]A1jJm?I]AG/P)4X7Kk#h!MI
D+e"=CBKGEb?T_F3Vlh'6W:mn0?3lOJ4nEnY,<]A]A_(p.%!d:h77[[W;#?_+]A:,EE[WDQ6@5R
FmD[.q]AL(2FK/ffNk<Zq%Dpn6$K:#&a-mfQa961FWAQJqe9Fq9NH#cm`#IbXD)Ah2,=bh599
eaP&/p"B=T9!>4#R$pr7(Vp(UnQ]A':oGQf%EDMJV`kS<?R;I4*fE0V!$Q@r6Vi2K-Lc7VqEJ
DAR=uAeT7,n"??BJnqJY!NAj*?HRJam<s"dK9Y<H$m?)LPDhlioW&==7p-T;L0EXYG2;F'*N
&#'V,+gqB!'.sA@PEO:IOqi"^kG/ATqo5?Bu/fd176+8H,*t><45-<H1rRg'cIh1WcOYhR&!
hX6@b"6gMV\fEe1G/T-S8bimQCm2=`CVa?c(4tHVr'68-2nshW6[;^<*=@[WJhk]AK,n=%#-f
F/H6FMVMXlAcG>aS=e=(mcbZ;feKY*<;4egt@$sXaj.&<c/9>h4t_4/@jbh[`TPe+`1aQL`Z
k:<]AT[3YHSii^T'mu,R@/l@b<L6B;X:\^N'?EOb(FBuW=I-*UaT5@1_./fCQ=h[K,"e,X%__
mZ;2GRD>1<5$Y_+M'\Potf[rs&Qi,L?3?$4jdTBHa/*`T-q/bC^mTEim!&-_N_"CN+&4-uE<
5E/')>eac+Rc2]A,%%<Eh<#&l<";<Ri?<\oN]A!48Jud@rrG(bq9tEnXL/>D.n41kAk!6KdQ`O
i;bmn8n*dpMM4<6.%p!B]AAaJ:rZi"euq[8kKLt\R>Hq3MaPej7SOl2Lt)=92u"g7W(WmcP\h
KI]AZ@A0k\8tcVt-Qr=_J5%:Z[@V+UtJr)gV%ieE@.<A=^e.f(LdkCWS`"g%"/+"^@rDp>o#a
`a&Db`h>FlDHPWhobL&Gr7F\$4)IS58`3Y.m%JhT,(ZBTNd)\.;6%b-?d4Lf9"=aBa0@b-ki
7+dLD!A#B9.lU[Veer=V*@sC:qDM)o>fN^-AC`WEA@Zi$gH#nS)/#)<jbD#CcHn\$E/P/&)4
@K+V/6H'c4hHg?fHD&Mt,E^V4uaJC6;))VtD)82*=-a=WN%_A[PoNX?3qLO^P-8$)SE]AI&X?
3S]A]APj/k"YKHM*r.G!q)Km'Wc!f]A*nE:_i:87_u)o&P_^a#rZV_/"_(GE=UiV`RK7aa6Xm!<
Z.Fd1Ds$&dhs5NA\Cfm=X%XT-@/b@Leq1CJI=;6l+d^,=jRfqs>niR>7EK`*'_6+eW>hLZ2O
%#Yj53;'S(bn*HHHc<]AF,,=c\@$;QlGN5%$lZ#"Wgm:#')Qi,Go]AP/ID,*XCfOTX$)3rR?6e
fSqGC"Af?Aj;.UOaO]AV+HbAK^l00h%G(c.,T)=8(rZSI-bK0T=]Af1K8o%RN*COA@!]ArdcF%Q
[X?"2mj=PpdrTIXQJ0Ho6`+u.*CM,VA1&tHRdMO#in$CY2l+QF6*,;cf]AQi^?4hQ#MA?s%c5
)SPLlu"dDIHj^3`0#$]Ac6^Qe)`:1jR,P*s7tu?!K(O[SgLcIqX%"fY!F(f@KMh=rZ%]A(<=KY
l;oT9%rkp"fkoF$@ud0J>Cl"7l1&'g_;<l`)3CLr4Q=Ce:W%`\epPGBg*((tFM,3%eK`i^rc
c3-53NfrV+gY7hC2Ku>_$S2@'Q40_J/F/9XX9nsIYjeip3'R>QElOPa)\aq&$1@m^LAVR[YK
u;6nYs@&_Z[?@]Alg\5>IPDuAR0uFd(.Q?alVo>5D_Dh<Gt1i2_+hY/_Y?@R:g;lI.MCGS'mr
Rj5Wu52&%:<iTEr.%iC%!1IYJ0_jUR=q/"3`QjQ"*=%>oDk)G'`==$[d^h8%?_8cbWZZ7t-=
eAE<T+/HefVp@ETr-UlCb,0&V5fER,hdc%kY#VP/?I'`5I'1/.Z4,[J7LWYEY_j^]ABEOQk9,
F41hQd:2XNi/8'HR\9A,%bL/>ibXW56&Xnkhcq/E-0_X!AqQN]A:Tp?glM5D6GoPiA^\rocG4
$B^#NGYK4I!pER.O)p(ZTcl+K0Z4ag_J0?k!tXkTo*h(`aUKl\_r!"'"p]AU)UeihAQ"*1n6j
pE[\Kn'@H8o-<')2,Je[(LUDPO?(MFDMbJ]AH0=+6TN_<Lo:4C(:(-,ZhKm-cR;#A30)3YL$k
!Ab8gUh[on\Xf-.+Z0It<:3/"/.i.\'o3H)teI$M'@:JW?K3r]A&WY\"pk;[<bc.gWZbdKiAS
D[M5DRM.eUjaq-aBANuN9fLqcS(osjm-Z(L0KtV'reSfLp2A%gnCIRJ^Lif.'@N]A_Y^2WqFG
_)(;lV4B33jJiLV?jW#Jl6Y.XAK&mK-d-DA:q3LT"L$TaK8/eFHA$bIYh:JuhjP"$)Ff&G^j
C,@R_7QYaQqiX+Yi3E!nNKjCM<rjfs/9X%4^SR7ps&lc:j0=;t&jc>M^sb$1+2;.[fm?s[`W
'd8En6p;qmf?I:tDB5Rg,L<7PoMJ>Qn3pKj.'88@GY?er-El\tO=!\F=s&oN#5!O)M)[]A!Yi
U6NuJQ-7/,[AsR2XaBPb$B>dWQA??D2rLA65^?2&(h&]AEQ.sUp#ZLcu\R`49G-`\Cf);Z`"%
p$TAR[\LE!P_d2M'2IbQI]AfT8]ARl)EDV?WRe_4C!c!.Y\2[DUI`g.FQhKqZ#O6Zc9IF@8W*e
QmZ3CMo58On>Hg>*3:Z(O0K:Y27kJ=nITZHSW>0E1-6>'oYTXt&Bgf$gF;hjo#g3V0dAT\\_
#IR<0:aN7V;<WWHb9r;^RBM7Oq`"C+\$FlBFab[4J%?=hHWs85/e:pVI-"uaGHk5$j-P,acR
G:b+G;<uaITTQ;7Pi0=e!H5:,"js$\o9[$V"BPV,Ju^CkN395$>Mrgi%\9LgN2HgDk*kT5)U
Y&5s1;(]AP.2H'3)"V:``McK1LcCdC+#*IEBl>Q$+bSE02j5AQpZYuRI%Uh^FTR1;;A1u'cS=
3uZ%nUh&,+h]AD\E*DC)[NPu"imkr4e!MmCpg4E*4gp1%p.>YJ'hTjMmZ_\pRPb,Rk+O+:Qa,
1D?@KX2IjtomNR&]A*,X-HN?uIf"7>FH1$-t".kK_HXF*3C%=:g1-='m^l)kr?K$Gq@6,JIF_
+"(t-en"RKNrt7P;UVZk>sfNE";HSI8:sGp6Fp#d8V7j3,(l#8F>F%6,Y(B53!Q.RV>njqnG
A.<I=M94?G#^[rS4<srAj%$S&jD64ICmCCR&hn1E<6/=G6VD#i2YR-enb6_Qr78bRQk"1)_6
`nnN%5@;Z_\Pt?=%=:i;2hIjk8=@RSm:'V2!:BV[<m-)]AM%j%qRU99"8\.W\r]AHA)SkGa/1S
<[#pc#g,kn5I8WEMejC`toEPar:Oj&?D@fC)L%Jel-7WEp"FDTC9npinVXXf9*8HbmJKRF%R
#UNC;t(6%!s=mcFUP%+]AJOI<5#W$e_(HlUci:5GBHD@(^['oC;Q1<Ibdnl`7BCMd1Oqk"YP`
Djc_AO\-'X/1:K+CVS-'7ang_&QG-0:BPm;jV[9e03[u"f!'p#Us?CopDF'HV'3oE-Gr,Pb[
-)j@2$Co4JH7lQ1st>2lV553D?"?q0/l!1.2O>NsDs3]A-<PZL<EBP^!Qq!Q_h,(5'Om%k!>s
-=7U?=4@JF5de^WPUplF)LoYi:M#?j*;L*m?C7YM"cGM]AXX*>g*TJMV(Yi^UBfpAkY8G1rKf
_KLeWI3kB2X*,@"Hm9+f-^UIRX72NO)ORJKBpAq42CAp6FuGhim*0pP&%JT`))"$UP^e'HG3
=KkJ.Q?(r]AI2DF3a,'g;QkF("MQK$;)>*b[hn?"rM^[/gp0@X8QaZR$2k17FYp1=B@2>W8XS
kE.nY^Z(8V&!Z9L^09.JRlf>)R2BK4@ao0ck6".iP$MP>qPI]ADkNGZ"'<&E@d;[rI=sg.$p(
7qT2*>!UYm/04TCJ:p8;?02LN`D9)Pbr.qY.fNX)=WBKL(6>4Lk6F"]AR2EitsQ)23HSY]AJ>N
DXjr"VR`?INgUg7)jORO<K,Qg<9Qirkm2_KV1,#a-qSIt/hmQPM>>T4u[t&L$9MeT(VK;]AIE
%`h77eOkIao-??M$rLTa5.gkotQO-nN:69CVieVXLuI?RCTp\q8ppG+T-YX/X*oifA%kLN:^
WKIqFCTb'W/6`HDPr;MEnNB#8e<$Ol'1c*)upWH]A=4FXmN.N>2!k2"[ss4N[=7:GgFtl$Lek
R&gS6+F&fcV8UW.)t*h:OrRmoS45<K=t_b-arjOI0c(E6N_6<uJ=Y!7G>;k6l.ET)<IC3!O+
;%8Qk4Sq_Qo^6PUhj8Nrr/CVQlB.rVA4+&fZPNh!*M6Xc/04:%]ANo;?bfrUCXA??HkOFdic<
Rn*9,;#L[P`Xk@C>=;N*t7nNcDHC$FRm0!P@;MoXBnY[a@A^F[g&a`ph7TQZHM376AWn5!Fb
M[1na!iD\m&Ees1@UR#rC9WU(GGch3^eq"WDb+he.;Hoj9*_b!I*#.eC.puHqamUg%f9]A%Vi
s:!cRsp0-J_hk9t]Asf#j5)4;-O\l#-k6er!-Yq:t.J6]A`?aM]ALrnYJT_(_2FLE.8<=L[F?5[
TH'hU?\r=s-b$hC\2X@#kjL<)Hd>d\Y/[a)cpu#$_J)is(-BBca;ic>"F!\#5_=a=gMq8qgs
7.#`?(VHfQ3H9cuEN,due`2Z`cJR##fLqj-3L)TAuZt1HYoSpJj&EU#hsgSi.*Yc.fl8EiC7
j^m0[>mubJ0#FWMlZ&%NI[;X4R?,%^G(2I9taX-+Y\'d(H1Xr)+R'&fYQ:kHi5a@&sY$[7>)
d5WVc[k%JCa:5Z&*r3_`$;?*gRc`/(oH*A1q`"A5`iH_n8'tE7f#EhHl>ND]A`fBd*"c.D)3j
[0i8(f&EHVN$W*'bTmr<?0%qlFF))tP]A\D))\\L&]Alk_!ng#-e[p+uDU?4Rk0*>K+3CJRGtO
!?"U4@91-d=]AH?#lQ-*T*gRWF6_fQOBi5cW^@Zc\UL]AC!;YsKd+'@pZ#(5CT.o)-A\&)cYlZ
?i=<Z]AYUBLQd8O+.tI1@9*DG+V$Eb$F2&qJ%5BN)WkFh`8rX&O;c::^"*HqC(W59BbE-es(1
uokG)?n3qF!!hN.iJ61[6SquUD,FK8tm(0#tb#`qKU3)h7fOl!S:=/hl)4VW>e[l+C%#M`@*
gA'L_io&sM#7;>iu9O/cWM5(b^>-HeT4V^)"<VAP(g=1)TL,?5,$\h<#8qn0&rOI91d-iT&(
O)0l80DY>sPF]A+giTJ!YspO?k`=ar%6/(?q"nRm!)*4,@RS]ASt0("N2NIh5LATpK1$5^/dOK
KaYs=4S\d&2t["(3jQLhj:T(S7MMRdOEcJ7s6\q&W$IH==5mtcq4E&'8dbH5,GTdI]ATer!5F
foANe@UG:M3rI]AN5'._R9h,Pf1YWb5BIDdJgJH"QX0dKZ%smHcVqbY2XCLBhERDMpueK?S/%
eiV'rm5)i0c*0Q@NAS>?>rc#@E3r[c.X.EDRSiQ57\ZH_U+$5_#^JEs:;H;uX`gN&sH,+Ik_
[q"D`Fd6@lMHr1WN/kLft$4`0fDQ]AJKTr((u)`?eF;6oYtD9`bD0J[J1u[!\D3:]A+*68$q)i
c#A7e?ceq;g*q?.%iX3J*Y6=cHUdT9<G]A)GliIB.d5#VC,J<]ArNfqP`>P:@hla&Ciq\a/!CL
9!NKp/W;uDS*N%js7&2lDQ&f<:sD`e/s!a2E*dLC&#-h=bLpO36.@;5ka@:2)#qq4VJ]ADrJ=
7'LQ(6`<^"ae2.)&kL[I4JR(UDE<G)(l7imR'Voa3:k`sr?gMur^9JTm8A3j<r\3*R;jghI$
p&`s<pCb[M\ol&-9I8Iib*l]A$*m'b`bZVCDjN<#IR3o&b%]A7p'X-h)43!N2UgFX7b_4B,UV2
m;/7FRTgN@X^Y22YCqc&MqbFE8$!&'qcjDK9rCm@g=T=5_RB;Fk(!UEuC=k1(*t?QDW_ra0!
;t^bdiHP<?B&0"%EaI9oQ`^2ILi&[0kSX7sP!rAFF`*Vj'/'?p"\i^*:)[F0hMpdmHb7joEU
jt.b,fj$nHY*3'c(^MYZg5j3ii/kE^<m2":Iakk"+MDEp$bX59RakM($_MFP8UoCCLb`>k<,
DpEY>oZoG:@C;Cj`8VQ4*PXmQF=fHafpJk*II74-Bcne%=\:>qTq(-`RsR<]AXbFDF;q9qT=7
i=Ub[A(GZq^'oPBc19Gtl(^C,CbUR2`l-[@nBE:tGf9W.BPV!(_3aWP\ieZidD--/q*Uj("n
YOfDS^V?tn?a@=4MKKjD389%6)pAA,)t=R^e9-e"qq(/U<;Zi#1VSNRelT3Rp)a25sjP0PO^
^H_>4]A:B6i*d]AD%Z(e3UA`%afuu4r(]Ael?:6^/.30&PAp?T&q#fqq]ANs#M*W[mI![%#"=Jb[
3n76,QW5P)IqJG>+.cK_0pH\<lWY;d"9*a$YMY'6eml,%?q;qUQhe$!EC"p7(a:`ckq-3_Xc
HX)D\O.h!"V7ZWaa#OT0:hDr-)\N]ARgF?`b8QRejERV(P[k>R+R(lpuGndG5M$.G8!+;O.on
"3;hUR`D"#8ggJVS?BH*?qnV;LotZk;KNl/rcX.itS-_^[]AqAlhBXS'A"&0,kW)*4&6qAbb,
o3J9,EunZ3[(S#)qV6]A+.Zu$*S,U$Zf'RnI))YFrm%d1RUlsm1V=oA0C/3M.TpU1]A"L$EaWe
IB'\'E1KA,6,CS*`C&otapfP\h/:AQJTXTXk>U8'g[4HcdLlpUJHhla$m3)X7'P)aueG'Xpq
PDRV#r.Lt0Y#bGaU&'GO#s-H>S!8&j3kI$VM_@T%qiF##Y1Q7UWV<:gL.NXe59gX2oGrMRX#
a7Wn/fUuk9b3F*<SLao2L/jE5pLE[rWRd[_",32'mEh2XZef2@1@N.!>4OV83[+E9ShtCDaD
T1jO$PID#Q&U*N(Q5odqb<-Q0$k&XLZMZ&X5,Ccj]ArM,Yu2'[6mcjI,]AAhl&")onR@22&`s>
YZOD+@Godm):os*m#S\K(NHYX.g$he[P);14/54VY9"uWj[\d,L5t+*[A'8`'G1M#,1&<2X<
",+ongQ#@FM8:hcbVWD23WD,Mj2;[r:;CAtFMC3Er8dn6S>5Kc2>'Wkf5#[Jh@oTF6leU:9i
RF"LRjH]A&oPd^B+jRQ2b*c4NY/[Z6I`sm,>U<Pi5r)';,HB'gW-fLO=cYTIfZ[qi-_jd+%s6
H'>HctYYBa4Z7Xmn^%5@;eE_E>k)\O<,hCea=?>q9`()TQVFF6RVSjAtc&2eGWR&O&W%m5\J
dYg\FV"tis"K(l5K*rP-,,VS%pbifoPEMjHb_F9)9f+Df2?B6c71rC=7+Ai]AMk@D;+'JI)lW
&:$m^rUPGD^=#Y'F4Hb.;4,o>cEmO$-tBW1!K9h9quhhR%Vo]A`.-=ZL.8b)In]AYES2Xm#1:7
-pZB6h6HKS9b-3TCXi]At3XXWJFiK(0p95rFH]AeAT0V0W&M)KTs9iF>LAun-;t_0!Sc%hg8*J
i;!kCQUd9;E'::1[J$oK&Y=WH<p(RK6<0P`@3\_A.FSc:bFVA^E>o%SHZW_Olfnc9UN15h[B
\gJY/%U)k;UEDoPE#7Bk936X9_!os*:$g<j@F9pYg/:I:8Vq)]At5^`XIg3?15;PUi"kGNA0@
?&aL@Z93.RjUq7>#VQ40UVM+S6b53$>Fufg*H4c0h@n-RKSk:uj01aB(0$/=NRakh$^A*CuF
!rau;gb-o9Ht!.M^F3:;]Aupm86)E5`Vn\TSo;ksWjZ=pZYd`UQk`Q^-6E0OT?+5^(V]AlK:RI
udSR9C5rA<t+2/O,F9/j@E:8:F/KonV%nhA;;c]Ae.hePA$b&nHiE`0U/G\Kg1rLD1*fU=4IY
C+co1[?&Dc90TpY%"<m4IT7;BnX7\ZQ'E*;eYIb&fR._l&)"YN3i.?^ISoCc_M1?1G40r:/]A
SbI*lH#mOiHPh(=I>\Su>qsG^P'I+1cSId2^Lt-ba2D?W=`#+Na#mf7-9gSiDtn_<aT^)F*a
1kg[2`S3-`^.W]AT&X)N6OUL`#qBhD+0`\R9oVLW@6G<SmDme?YAq$Fd#Fb2`]A:2kN!QUL\>F
b<+.=h9ZYjMr:3\P./6_Ms-t!un?(0,&]A+)Y@@A`*234_3dgW.R+A4\gQ/'>i(^Ba<OCb"fc
TKeHF#qCM>R2^UQG&e5'tficF^RHRbR&]A4MLS;T5jRZ9al0Pn$ZkEp;d;debaC&aPdi)@"A'
EtUnk/AnqSj1e=tg$65K0O45Sc.COdFM%^=<53CnY6$uh1743&DjfoqGJ(L0K!baH0=QIAT7
@1,H0qNFUL33=F>Ei*]AslB[C2]AS8r;5HQ@']AIDPGTQj<,LLAJp1F,A-=NlP%/KlPh.=X_48/
kC1?O"PoVuTf]AAD4r2Q0g'+XXOr)hTK-C72_>),7Jk?b4sO/_#H(o\2h_kj+^8?B]A,>Qm@df
<E+'*B84(Bj8'O8DKk,n,:F\E,,k*\c"IJP@Cg8o4WSO]A,$/&4@ZH%`/oe!c)BahUTW;>k:^
-[g+mFW]A#p*YfKQb<(caqDf[e^&&IA(O?K!3"EAYe4U_Jf6!TL)K`I8-)$a$aum1<DpefJZD
K'@V(i>JReGtAh(js20.58h;S9GhI6C32)NTsCr\a/s;RP+(L>n"S#ge[G'-m$FJ'W90^65,
XXu@14m!`HF5Pg"Z53MIVBqWti5JF?[1++FG$*Xe_cn5QBP1B!GnAS4ecEP(lou*p]A825,ic
G,6*3rdsqaK-6;>:/$WCRV>qjMlTIs7^\M.u!XG\i8)*%.2'X_5&Ah^G-"m8NTTBl+Z\Dj]AX
;K0"VpV?TgOQ%@Y31$WnMLgas-9oQ4X%nQq+`PmT<j12oe,A`rpaKtcpaoD+rC@)9t=2.VV1
4WPO6CId2AFC:TiVtSA0Gk5lHO0do4Z>mZ5MUgJmB1NpifRN:S?,P5u#_nI,0,b."(%D_TTd
V7lUHqj)#M/+?Tc()M"NE'u`Hd:aG:P1ir.6L;#bID&omeO81Ceu2CqL+!A>WmO29oNRYDN%
u&`F%gM@136<-B_#qNeEf^q`3Z/ocQsFAE<?@`?W?^S:dX!sko7IpFLp3q)5B:>`L55QSS;e
M-o#\@ni4c@1@4b^3;S970_46JpR/48Xm'N"2$JqW]A.pPu)V_[KI)FGcC!aifa`ca$p'eWqZ
T=X8f$HGgb&p^"&Q&jC^pC8_Ka4%A\LC=8]A*?s5lr#(SVlNfo^W]A"kCl7.Ol,Y8$Q,t%gKt(
hTPdtrmZ;+#q7D"d@Mr9-+j8=s&L/<sdZ+N%]AmF#@*I^4+2[5*Sn81V-=8C2E)euse0[An*0
R<@?bA?D'ag@dL;d)WTiM<6B:r'A$Z8;2ZeqJc=n!FhXqB%UB<*7&]A[Joo`mIsdk(Ce[#972
+dE%iG1e4&(lpi3ini:N'YVkWI^0B@P.j]A4?>#Y0IC;NO@n^90Q<l2>]AR4&fm-`e&,td,\C<
;?Na5.-Mi6Wd2EM*O8H`f\SHC_Krl4]A'.sqEOj^E&m)3kV^6KWCI#d4GS=#DtDNQIF7@U_r'
_aa<0tqjP,G-RMDT?CILV)0YUZmg)na%OrU5^rhe<gJ"/:B"P;of_Fr7V,QM%.S`>\V55X?$
"5Ilb+LUo9S*'!(kN]A7eb-mjGaJ6d,a.12Fq0Wf,Ytr`.*/iIO-$O:o&W#_)H<gS-IZa!3:k
j.440o'QjSD0l<+^>YTpO0i1qW9!b%$Lcpm9:_lL(ePkq2bh'@?8U0%%mDCie66WHNt,9aN#
HQe8+&TU3[$k6$U#IaRp_X#_#6)tXG0JLGr/Hi:a&.*]A7U4G`s%qL#Y)]A`J-,qQ1%kE2*n]AB
V)un\SpGroTG<Ld+JI1]AYT'MCT2@ADW.=^dgY;6.7cX(3$bO.4+@[n=Uq"?gfqDbVBCcRie9
.hs:7$2njUa^5X5DgH#KJ5k[\+#B+j#Kf\>Z't@hnB]AM->o&Z]AkNk4PgX8/?cj&^^?6t;c32
P6]Aqc7(G:c^5hUrbdR<(miD+dq@*S%Iu7SKmKI$rP!54fXm`S'$3NA3u8c;FHTbU'%fc(*.*
@hu.?)V;0hm#:n)H<Mp(`(]AV(h2Gu1gI<fq72f-?>HYf$ii_QU6OGrABWlh3,r):Kr_2XPC7
<9H!1[@H]Aut#&B8[pqZir`@"Rgc3d]A9uB8(#'>GJM@N?WQgK5(jlb0_=gp6!S[hSgQs)LHDo
^;"9'72_fcRWTDa-0".]APrA[5\`>5?]Aq9k?aRcC/N<VNBhRF_53_p)8=VNY;6MUg*AQ]Ak.7W
K@jd8VoU@eG1)d.7+c19f:2Ai?S0.1s"FSQj[m)GK/-n\k3?:D^J`bSYG76*/Z+[*chmBbE[
(Hfq+aTD5ifH$"&!LQdKoW049Nc5h?eN)6^bpTJfqZrcRB!a*;"(E,&9]A"k)2[XOTP$[[;<d
7*A^>n,#X@Mkcb7CndIurC,W&c;pRS>7>8+b-_7##;\7QRr+gLDT]AN`MfYN5`W0!pgVr/*4N
\TA)LfHabpQL^jLtH[<ZeLiK6o,9U<j=PHC`-LfBgM'2SSTf^SjKO<\%#oBR%k#=fc*47b3U
2%hK#IJW&6EiB:(IgS#!r'"JpFjkIgn*GiKt>&YN4<<N]Ae;7sT:!*&ucq)$<K?QDK[b(Ia+W
;/JI*_fUo?\pp?R%VgDV8`$%dZYB5\YJ$3Pg)$F)6oC4i1t^#G>iY3!W*ck>J%0f3^9W>mXE
dk\XY#ZH<=a=C#nC%XnBq]A0)Vtmr$.io$(P!Zp4@9<?iHaBo;c6@[=&,N8k7V"e!jkiB0j''
!e-)?Y0bSe7s$tQ_+0!bH*`<PaKFr6iWrn/l&&!"kmR>O=j#67qmuB)n1]AVV9.m6.XlHkm=#
0n6k`[42k2Y%MI*W1X^Fe.]A@.>+_Xm"_ujD_oRY[Fai7"REmaOE\3V@Q?jF$!tb!L:M>lcd&
iYU3s]A-DfS,!0n*L?3lqW53o7?,*FcL<B0s;n%:Umr)YXW:>oS_^_8\EqCkW7Ud2h1]A^L.Z\
]AtWfgNioUh^ba7eGc8B`S8)29HE3Fj"Tt6=)L`Cs-YbD"+>6g3]A\WhADJk@cdCOT$%3?&DBU
gN!;htp*p*sC`ORIm(5E8=+c`gii![+A79kF&QXDt*6;X8e^>t%O/=0bF]Ajd[S@FbfW0_Rer
kO8OQM]ARHhca5S5)+!deY@O$p=-JNG:s+N1g<c'oUTF#Tb5.>CF,Bp*p`ZEOM.OTV%M=T\En
!p]Aq24[fP+tkGd;dubP33"ebja.Dr>VS;H08U`XS5$IJfiO%s8;^1^rN]A3k]AB;iW\Q3n"c]A6
co?r8p]A\C?FB"2Q[@I9)84@J:'ifaG8nph`!8+oj*i8%Hr,:q8@_#mH67:!sWL$J!D/`%id+
j@EuL'u<+&&(aD2QC-Y]AlQX"bkjqn)t:b2KX98G)>;0hFISMS1*Q"<WF(.!AQjm*;'*a8L>-
u*rS+mO$Ad&?3u9Df7e.IXJlbPiIfrGn1n<Rmh$6JZHOM!@=`4dg%VUrl-Z/9SUbQ1M2KNCn
l3H7e(*>sn\*m=LJbpRZh_3:rnR(pEi).aL:7p0-i,hNKrOBRh7j<.Z(Gi*UFR*2*rRHY:G?
)@ppZ1oapBnA:G@bZT21%TCo.7%EMfJc%Q.(PNHaIpomQ;tH"c[Uq-)-</g[!XAMo!n7EI#.
A'J"cmK;)N+o3Au%]A:i@![`u,LpC"=oJkbhnd/X5b*[JHmn_KSJ-cZ%gY./jsP+JEQF[<?ED
BSpoWE"qNUDu!U3Ni[g,_A`j[QSmOZYs^pmS+dE=tQ91oic-O6aI_C"XI8Dn@tg2h(+q3JuD
^Pj>KnkJ;T<n2p2+mg=.9bU-&LLC1Cm<]AZ2)'f4t\!Q:IoS:!>DLnfB^'i?p=LKt)f\7pHU2
*$R1qpY0`UfbVfAQa&J%a&\gXd?6fNB6U3uY\S)E%QtGPg4A5VS<SS<q6d\JH/(TnO]A.m$+o
#h-le(E'ZFSpWD=dY,k4U!NWEZo*N??'-?@O,5jN88QWMLV\QYb;?r-Z8\rAU&Ok(4CkD[8>
DGYJ!@B>'s2Fm9u+p$R?>cf`sp[KW]A(k>oR]Akj-c"7s'p/k2)A1iJK.IU'Ykni@[V]A3D8iX,
rtiRhWk"QRFRMsA"^!oL>3h]Am=AC)a[iWq9DKo>J@;6XrPjZdV"$T:fs&begla]Al'$+>$p^T
hA[%ol]Ar=TOf`Gdk7^`D^udm+0;>lAiX0+e(+J.AZ?m;aj3pMkrgRGlk-2SR8CiXFFolBZ`I
g]A:_m*]Act4(nS6kCOF*hK?R=O@C/sW=P!A27[.m%+!/\=*'`Q@&PG@QDIP<o>0FY7O?>\k4b
&P>ILT7q:.Li++]A/88d=:%,Pu^X0j$"mCe*=F"P*FCLEmlD&Zdc-L^B?mcFLWHG\_oY"d5B'
(1?nCQ**oI?mFE_1W^LgYVQq0<[%9<k>JG_f[Kd!#U`8?GaDm47.i%<NBZW8>Yhe7pCEI;8!
]AVa#g]A\W!/L$%8S/Y`-D`0oB/bLa1FZ()p$.YHeEtlbk!aK?(QJhmCbDZqtO?s2L#A;[kJNW
+"/Yh`D'89`Q>mbPg2a+MAL2'L8+a?e*4RqMpMerP9^?Cl'OA6m6JoQn%_SJ_I`1Wc'_iphZ
i$I\(Iju7nnD6u(L3LrK(S6r&Q10+(cNrlh_aTQI/@]A'hcD:V=>1h;TPlMicg0c/X1F]AtJ0]A
aD8nN`\>\kO?`)(oJbKGd]A$'Pk;;Rr)[Vhl&1dB5!DK5D'I$;jrX\P=tA"Zue6G808\9iN"e
gCmE2]Af6+-e;LEbtag0Ql0P7F8*MRs9VLh[3^tQJQG'N*::GU?4EYLo!M\sWU5LC]A*e19eT)
g[H<,oPSM_hTCfp6<[.ZEWAFWsrs8ir]A"7JoiAE9:guqDf>r+*p_b#fPt;9^d#@k+Cu]AE`n[
(*I.k]ABlF&hR]Am<,_PhSuU"`N]AWk]A8N2)`-jR+Z1HE!s7VYkc&o<gN1&GA4'28X<:-2qb#cj
Z[8$'C"'54&P(;eOKjd-L(#&\=&L,qs'cPDec.lWN(AbWaE'4m+d.1gNaGjJ041+=[bP3iBM
"n<H<mMJNB[Odfmr,UG@<B?MO0%`2p]A1(<S/eAJ`FT-)YAFs^AU[^+sK>Fi7<OFQ9caa$bCM
eQXF'rB9q/$8>q0#Ppd/7/\8^.jlVRMld>;"^h;5k1&TI%^Y'cS.D^`YcgfC8IuhhJe\go&f
`IJI4.L=3HKa<pO2t3`>H3[:[L=4:gAZl>p#&(EC+_W=$ClG0^T14%g:Ys2(,ScnC@cj7i,2
lU\8bNgqf;]AINRkpPYV,fLm$+rK2Q5W)aNojp1cR1@+hdtcgLa7%8h`]AHjE0A4\,!6q*L*-L
X-I6YjKe"19,t/B*jeg+\p:M8*W)YJDl[@I#oLH!KKpCab2#MQVuA]Ar!.X@TPE:7d."keGIL
_lk%[sr<UQ@c)hWFF2-)!L,4"4jUqnEA3Oo7dC"sZ2IW,[u<\%5rqr&FHHl&L)9o&:'8,VJ<
CAqaDUrt8`mkcl*X)@LO%*aS&9$IP^4!URLjgV+<'ZMEYSWS5iWBeLTK660l0=pA(+6[mj97
+I$gZSJR2-$9"5_tF<,V3j-=qZ2M@`a%qUR_>oKFohF'IPc"'UaA==!-"/`O%O69]A9AO+=Hq
njp_N0YWHMu-H>n?U7KBYdb@!NL.]An2Zp3<rk9+1`B/flRG9/$Cu:<S5smK]AWr9RdiTlPjgq
HAh!*FLJri)V19t@('`)?aGgnUQo-aqGU!,?J>pNOUZBO9$Ru1]A/2QfWs-nS?qU(-p^DjZKC
nma,pIeD1?'5oc,MX2b.9Bn^2i,\bd[<Y2@=6ch`>-I0sTMB&$^Us<tVLC!oHW.8o8)R74<O
n1.Tp;n`GP,'sLt/a!TeIO;@$gd=VhegCh_X"1oi[<m:k;"A:DaeAfW5XH)06?c=c^,WuWB!
ANff(;7C]Am4?Wlk0REfQuM)UYLP:/o\l2!:6T-N5[1NM$&uEo)uApG7=Huh)5+rV$0o5-K%:
-h@GRgI?;]A:C!b&#.CG^7=:i&q4U$jcgkm?_I4,oS7fg--6Ss@6fnF9eS?f5Og]A>3n*U';*$
*#ImFCeLPhKo58C<)EVb#*_Vs'l0Z3(-k3Q]A)e08&-!.nd;N\NYH?Wj!EJ*nTR52-)[_'D`c
#imDUJA?QCK?=R-O&;&A&J$DtG-YdsuOfqiJ'"ZfYamGH,K^r;rrpL[@U1%-%X;#;p?So"'g
/W_iK'NCot;Uj4;1PJs_-4llV.eb;A7Hk&Inc0jL0>!VmBfIRAs"FID4H7WQK0Hg#L(Hf5-^
5#Z0Ld&_UXJ^0u6s=MFfY/%.Fi\2!6>Ha5M:o^o`<s42-u(XOE%XLW0i8a7j*nV:R`5;d4:k
K3JQR!W?NWQW%a)iDp2ikOG!VYKTB+qpPqQ.H;:`1p$08U5Rg<ht1>b4UnriKV;usH(TQCM6
![Z:rUdiD^TdJ;bE>jl;X%.Y6'JK&\cU#:[noB4Fa]As_kn$+!_mLm`hqV89!>0>%/>_5*Q3]A
^E3oM)"LI'R^AZ]A_-DIg^j8pskkh86NdmekY-2AVIVS,5?<97XAAT-58*OjL&]AZH&Nn9HK=c
V]A*8Ub-?X2tk38<%(=V.(7fTGED\Ka^R]A;9EK%JXm"Kt="gj3@9UOUHFnDn6YfSpj$h48?-M
OQ&&3eQLt0_gr@(qdN&F/c#P64)s/pIA.a("D^7O/GUTlAg37AEo``YC[('EGDH!9"o?g3YL
5a:7&'3TU0)S=s`*T6OF77LN/+!5*gcE4D@Mdnh#e(YlhK1:1A/6A`a!L&QJ=bjChA+08hG3
Wn8n^)qY1'&J%K-Wc47YXF_Se;S:SVYCR@2=ZfE#dFO?<GH2t%+bIKrU+=@_/u:9`3=>ar4d
eM*70H/l2P553.q9qc[8YMh?Ca`^;k@q^(D%eTSm3o:$'<ae@*206-6FG@j/rA5A<D9YLbqN
`RI:dP,4mYi$Z^1,O@n-?S)9TT&`l+8^Be)!&VbnGrE6BeiIl:FTV:bCi0nnG@Q(<0H;.`PF
h9.]ATKL<G%+R',``.u)'.*\f)(45<;6gfEkQCRk:3rssS3YFQkV+#DD\!!.qk43oA$o,!\."
k4,!_a/.PMegluaM-oggC=P-'_3'4B?;5QR?'!c?++,Y,0NFlL.Ycoo6<YqKH4SHRXn<J#6&
kcU0+oe?s\Gn+JBq>6-;-t3q]ALqC\WPr3UB1/'M7[!hL0UIFb(S3@aM!,J?g<^0kj>MsN'^j
I=O%AXN(]AGXM<MeZ(Z*$3mfN`Au[cBsS)"1l>G`/YC;ncrA`!Gr);Y_.#=auc^3Fk8le%So>
W!_Zs8;$(#bB!m+f9Rq4j(5eqR$m$h8T/m?F`cJl:gP?L.8r)uaL_$Q;C=)[4<g_q!Wdh*$[
5hPpFQuOc=2:qU>V;?k@%A?X"g#LUor[:/6A/ZN&S:+G'l\mTf*oi%70D+g+f<l,Xm\>>?j+
's(O%9.8$8B9bZEMu_!(fmE<7C+)`Vi"AL<5oQNB2r@Au.&5O'n(@>^<K_l.A%@o/8m$K-hk
:Z=YYFCB-,3eW:je1oViZ,mO]As$4^jd99UC$g`NG>Wp<)qDmb150T^T!',<6m*5;>f^ZII)9
Qq*0mN;Q<U(<<7@2M_0*u+7..Zpn)C@n8cn`F2&%TUaFSF'X!>k\YYC\4@i*JmCd\R:IW?nZ
rK(Tm9Jdo@a@"nFFq'SOPa+I2^aKJ[]A873N)eaO"ii24G'1+_Ob,hRWV7G\9Dko)OM!*Lt)]A
&pa?P,XYMLBqjnDE/iSbinM0WBb7jU4JM&p%UOs2]A6'YGanju=aKAF31hg-0aM1IRDC<\I\U
TU*7(SshIDPV+`_=CU=Zi(YpFRdo9+XEAB03_2/.Um'mFoQ,aC4qIKBXYX[OL+K,fX;*:&K:
."3.$$L_jT;R"S.+I/X89=`Kp[CakFSlk_7_D.M0RW8jYG^KZg3JH%Je[c0i--Q0+lDl=mdh
%BA10V(')##MiJQ7U>)`=nM=O#p?3;$Dod:aD6E2(!u_F$UV_*4cW4F#<`aJe6laDCn5=6@9
.b*@d)R$.g=p'26E>@EP@W;Y.Q/V1&l6UIBmDC/uu.9:9?.p*=-!);HW\gQn+&=QnYA:;R<n
$S8U)K)`(be*l%-eD!_NP36e2Qe\R&0:+8<uSftC,K((<Y9LMM*kK"^(1rqbmcF5%IAO,dO1
5@4]A`aP=4%n!Y*<*.qB6lMNRX@&RVXGG6)R^6]A1\4pg17;7ZS76'eca+Kf!5]A=GY1R[j\JO_
/o%Lon$Y04]AHhr%S9.8i,^mr$bOiE7^aeYACID'SD;`kJ7MfS+S21e1BLRsRNG3_:,FejALV
#kq;r6bmmttYA/4bs^`Hi1^GUeSTHp:1lV62+2VHrJPOs><LL;'9B(N8%6dL?I]Ahgc$p+24L
+aHqGB$0]A3#VTC5j8ZB&k,8pWPkpk:OKFW(B@qP"XS7AMORsmi:Tqa9\h!&ZrNZ!2q]A3r'Sh
X<0<g.i["HGcq.e8""4-YZ?Egs+J@-SL3(frL*#<AHG6ebY'?V1!M*.K'LD=&aLPSAkH&CPE
VUOi8f^S5jYd=^N7g))Y)g6^1OG?#"iZCf*9`f+'C^GXT0gjeTjLd`ORq"SstIHa`_2*'CKa
24*nT?3luXc8#,gfcL#6'3%&5P0i[PiiZ/q3D9Ik.H'["@OP4HblC%]A7MMadU*g9]Af8d%04<
1c'S1\plZ3tDV>C;`FmZ]ADH\.G>_ZUT8J<#m]A^?%;UtP&L5gh>L(Z5F=Ki-H^Pndp/0d@8>g
0)hTN%k?JmoO*(2p@[RT%nMB<&M+A*3B'HENhVDaLm7%JF]A1r1":4oB%0-/T/.IGYG)]Aa;<S
s8Hm<6R%7Z7/OQCY[E24m"j`=.bH@nqg=!QFi!?Bulgggc7O-:6[5?P?G-3RfiKI@]A#-6]AJY
8n.J=9Y2k-gQ?T3kT@5aY/[+Bh7G*T,6o5t>ma[ccl.rZQGpqL#J4dq6<6mp_aQCgj1=%H,O
%[lZ=26Q2qU,%cK]AeOjTRp<-4[>2f[\S[]ANat,^I%bfW^(n/$k::7lC;oe7;(9hT.k0H=.)J
,<h4_tnW'bFX@Vg&7V]AtD(Y!R")]A-I4(+-`q=QiU7VO]A7dg7bK.?'<D,0:jYsSDiK]AbAC[>s
D`"!MBOK+UW@E!Kn,%-gIB4>>GT46`)TF<<n9dY24Iu%NS.8G;:k'Jeh`u7`SCDeDBC.a9jn
]Aa7ZB59!]ArTTQeD97A=9Ws1f'>m,nDj1GkO<,#YIs?FA\8/Du>Jf0b0t!T,IhA.fji&i?aiA
)V>hu0+5utfODujpR@6Gm58A[+D?%$+#T0g=b%L#II.Gcr',3V)^[`"`*^$XQH1Qc0AH!*.e
oA2Qu/H&:_9;:scj4#W?R'^":Hin,:O+WP\nTc)HW/[Fn0/Alc*pbf14h?)WG+Fdh(2gVFdI
/'2TTPXh-)>>qV2$uWSJ'J"iIT/dW3ofu(#`J[3PJg/:VS+S>;[JoW&s@hFIA$pFDb+)GDo=
CIb_*H<&851_r;+%b.0G9rDoM.b?(*4/4E-m]Aj3Ir=sNU.3m[7Mq=A6]A;Mp!'n+>S']A?%K`b
sj:^[h3m'A21GhX-fVb40ms$\<C?`lA63e$0j;A@-0:Okg<tM2s&:nF$jR"ON7QZ]A2W/ce,P
-'="HQ^\7CZs8)mfd1<cL6PNa%+NN&k1]Ab@CdF+N6_K9pp`hoOp#8cuZg.Sh2<T8os]A>3,V%
X68hKq*K_H"s;AI%^C#/?M>cPh.7=\0OPKM=J[U_)H.p+,O<W#Usea1`&L!l2R'Yt.AU"ZH5
k!'H(CPI4SUhWb1a8JC'c_DoAdoN@$AL)Bt!+G,i-arQ1\)-K2!/nWg1Jjri0PU\Oq[JY]AF1
Y@\GCn;%6CFm6;IgZOZdk[PiH-dU^B3CD+9eju2t2>G]AVH'-#l7+;-LCOp9#Pf$5`Sd;JUoA
E7!QQ1\jh@m:a`s2MadXk04/hg=m)PAh1Ni&?^`HO\_:Kt#g61%DOWLTBN,?]AdM#Y?H!M?0(
.a(nmH.FCHMl>eJSPj.dHRoXU?cMXMcC=OS+=&%4Xa`/KE9K`tLI%,-t%jl#HFF/bT+-0l3A
1/48;#O$5<,<f@RCT3&UJ6/h(9gR%sa['\[6,#Os`c#\qjips!&f6`_9[&[n;(pDi<]Aad'A>
UA:IWFKeq.6(#m4]A$9HTkW!KFU5JKkHP0a5;OU3r)D7QIc?()6jrE0F;F=@YfDDl,C8Wo;[h
7'!B5'af?pD1@_+!$]AfF/D$l7^3k+&-XnE7tWeJ-3&'7F)c9E;hm-p>gc\tqO1OGA3@<Q8,V
`#$r\4-nYUnCX+8')LRa#-jIaNTo(d@cC\>[=*[=Y`WYG%8'5D;O;ZK&WB^\g'4>-PqdmRC?
]A_(]AA.I;g?oY9"%`%/tS_nS\&q!>,a2kNNi6Tn!;VfOSXo@oGgBl]A55Ya*6>:Oa%bq^:*(Su
`&lR-pE?(:oslS6opd`OkqBb/q6PJZ!;l.Taec,EF1rjC&5e!!.N[FmDgg205O6<lN+NW[?k
s.`5E81@hm.P08[iMPY7=jukZI0BDdR0`A'C?)DPm%'\<SY!=\ru81m^Y_)B\<j8^>rGk60U
i[!V[3b4uXc(^`YpdXo;]AlDPBmZR]A.2,C!ME]A!M&(!Ea+2iqa8Qa5(GjAC-pJ5g]A<WGlSg:!
C8[V*^-@?p=c@6j,`oe<5qFRKDTJ/2O;@/bbo=`:f!EAm"7IB^"Q"m^]A74j0GQ8VA/Wbr"ae
.:R[dUVEPH-$rc=69Bmg5*X(Q,2&tpkm4_Q%PUKg1;`UTO``4C<L9Bsge%(*T^Ab"p7dD[HS
GaDKCV@7a,E&YK(DP^j,[$R^d-f-lN1*+,>C)(&&BO]A*CS]A:Iq#B%1mdGD+tj-l&#$tM8OAt
,?<;_/rAeU3f=Z3lL/R*7I".jdB?9oAfcRgipt`Hu[!]A\mc$T%R`#onEd6/p9h2j>n'bpdjZ
+!@2$ih.Hu]ALSr[@Qji_*eVjbqR.4jb7u@/'o$H&f`N.IuaVdjf8USVl<NNd<HuaBcl@Ob;m
icH';(Ld'j#ou!AtJ\,j/M^>T/M$7MM;mRNNeDlVAlkU7I*uDMQm]AIfR@M=MHZF:+"3t'K_U
TVlq3O&Z`^%tS!qLU!k1fh(Eims7YOK<ro<.AUEq=X#7V[[DcrX@?Z^PE>]AgpVE_*@/c%=Fk
*jM@>=Y2B21m&6Iq;[=nOM#$$mK4Qf/6$V!Ea<_1L9+^L@L<KHoJ!hu8`j$.N+h]Ak=%S+pGg
]A0YoX9g!TN7?%jMp$(c&EZ6diGCSmQ/)(?;;:aN$!8-ggV#mmY9?`8Fa=V=5ZE9Z"I5"]ApDg
FS3<lBNd64+'DSLXR,afMYmQQbRQHh9q[V><X&n`sjV5HmC/?QQ402$Jb05asQ/"8jXK(d3R
%I[MShC^KjVVUnB%_t6DfIDKbi^Ut-4u0bnZu!I0/raS[I=i7dr.$DBUVIBs*^1>[U-jM8d4
8$itGQY3b7?mYilFH=4E!qS8K<1p5A$^k1=,74h#3Bj?nn_pU>nFOJO4mm>o_`B3@m</u#OD
;hMsb;@Y>1-eI_9[=pa.H9-l9.3A#ApZEik2L3GF3`jcN1;?2b;2g]AV_X$7!kSfE535Rp5GZ
;BQ0qj6h1r7qD+drsu(iOJtUYFnF"^l2^Hd9"#/,(F&9I:]AobUrqCIifUL#LH(VD-utaKF@e
[$dqsYk%N>p9J,SLZ)$aX3%f;g0j:RGTN1qKZrZU#9]A%!>;tdI/(6.)(lb9<Q/Q>7Ms0pu4'
jH'a!(FG7jG',RfN(RgHhiGo%rZZbc@oVR2Wp8u[eU:EN[:r\@(nL11V7^T-3XDK.*ou`G:7
.:OmKHh<!:@Gc#da#\Q>8E(1gm4IPOoKT"WtZ,a:Op`f/8SR+g"UmJjs[8iHZ,:&LkASsGjI
J`=%K#AS(_^USJ.W5D_`=+lsXi.j*a6(WY1S:D0/SqP1e8(YS@S)J!3Lo8&a1MONel5P!^/H
1kaOW5^kC+mFRE`u'_!gVC\:tYj!hQAE<?Gdq\Y[Zf>3j%CVARGTjpV4ne8.g0;O&\(Q?Cb+
Q%RB7ae9Y0VYb8CFVaVC^[e4Ts@5DbnYW6MGPtRu]A6IlNlb#<WXoY!*j^)Io@/L@C!+[f"R8
AaT.*,aQNf%9g!L!0s,n:VKc0;.&$_*dYK6D+D+e:gFir$q<g8l_R"?,fm4L#ZWC"lMF[(8/
nGO0:-iD[KK03<-=RrW_'\S='!Lhp(C96:5VF5XEu!n>F<WXi&b>9Ct[tEmZ\)UZ4E1'cQAV
2f*ZYeKk<=9YV"*,%LUX.u$&,Y(2S1I`iJ6gD3##))ffmHtecVA]AG>/RT/huOoS*N<iOui'L
H>t!d)39\*$RrRpt(DRu%Bs+Kqa^;C'@AM%@(gIW?M0a2Sd#Fh8B^D%bYf-7$oU7A&9;.-F#
*raTTV-f$.3arO"VK&4Wb-3*89kj?&fXpaT"@KCX)pof!Don#J/XW[U4s6R%OX`G11e2=J>+
YU?-@QWN@HI0tg@)Dq`B.0;eS;&-JcqE@?K=Q0J`!6<\<c`)0&DK>=*,F2S$IYR;+,"<<`5<
`Ws0HWBK.,V-f9sh3lnKAWno^j\adCK4gA$0U!*aaSoE]A#IL+a%rMmC-/FT3HOa0eLgmR2Ye
[d)Tq@D,P6?`kUFN^=G03D@8&-'2^;$P>((*j:6E7\&2IFlp'G1RnZbWn/BLd?p$g:FFGTm*
ZOMh8[0up"-%#(lDJ.Y/64-Oh&f78X'=jS8ULW1ssIbqh[YV\d=KXc$]As%0Urp5p2u[_6S_V
n1Eq:r&='b?bqhHV8JIj7AH'cernBp'5i9+07V'u>97$m/i@smoO'q=\%_3Muks)r2q9MrB0
<]A02XEOe-J0fBq$^h7@[G29*4?7e4[+PK+iiG>Ph:E#GA5[(0?DaN3jHPMVLm&2(O@+9ZgS+
E`TgU@K=264>iSVr8q;:`5aVl2[J%QB;=B/<+P*.EcYs2rGbW-$sMY5[T^+n2UDWAQCjPZ/(
Tm0\CF#`gm@&8>1fN/rChC3.g^2*iGn-Zs$%P^k:NL\q>P7;FR&u71`'b>BK\GE<4)HX`ms'
oAWhHCWo=e(HdZ*h?FmMHcO&,jtH*-sRc#/@Duja.BXZR1=(K_9Eq<bD9Y1K:6+<L&NG&0_o
n:W-XCo);/&W#+E3c[2K]A8gFCb*i'5(LuFR5Sp4#7kl7X*Qck*Ppc=[-Z`Q+HO;1<G"D-qGN
;VtRV+oIi)[HY]A<<@2.+#sc$#j]A9ATKNLHp'E#T%ZY4:AS_)[EG9=)Q.1,eTJZgf'5;#/ioK
Ub.^dZ+d->hUS-T@4_ZCJ00F^Sf^gu'3P!.2P>dNRD.UZN+%eIY1;4\QBaa^,+a2-FZX[JDG
lt#qSqh$o8%Q(u5cjSeBr)qSSF]AU3q]A;ZAf$ne3]AaU:R^L]A_ANYMO<:\8cIOd>B]Asc5#;S.m
`@;m[CC1rf0,aV;XOLFh@_bbpg\I/JeMPN^nd`6;Nt/Zhiro*o+,FXVb/\Va(]A\bGB9]A0P-s
3T.bAZgkM"Uqic]A<1rr'6?n'6;EH#72SgV$JUpY//V4g8P!r\#i_B[9o%RGf$o238uF`:&P2
$Nku\u[:DdoFfAUi)[h8n(kY*YSCJ.[8Qh>%n<P2AcR.D!.AE%sL!h'_cP^Fa%N!+1Gk7[]A7
YiottAtAqRn2VpaM_aC"eh"$V7"IPD>0J;)j3hCW[%b1mEn>Z:4<+k9m:niQU,"Xl)Yr"h^#
0=TSJXeb#rfhqnX^rs)g&n[DTYpu1rp5aMpq:5(Qp%VS@aeRTohMTYcF,4\nr^ZSS$`'l">l
ALhnu]ApEge:p@a97.0qcB/'\+9O)lC,O#W478QcG=,]A1/-7@S/2WDk$8RVQ')oc2(m^W8c6W
k'SU;K*DQ.jr38O!Uku,g+Yp_5Kt4GN&Fof/[XA>Y8?:,a#'Qoi*<X9`8]A$d289K_r^4"[[#
8f.Yk-'3T'-ADdP-r=]AguBB++rn>,d(]A?=jS+]A;OQQ\bi^>.^9F,So=tt9'k=ABPo;kNhs2i
UfV1]Ae@8;=&DBd-g_+YA-iAjm`Fk[+0W^,K"J0N#F:4\"(1coTpg%(;F*n.2G86qE'BJH-=Y
%6cq6j&b51h8(9[SC[s0!KXtV?k4!1dt%.6nUYalYD[JMhR`Ck"8k\tNA=a0.r=a$rE!bU7/
=MMLDPDECSR@.mEA)'_:.5l^a$39:oRe4V&]ADnIS$I1@1ZCCbgfu(,*D(;0@M+6l'!^t.iRJ
oX,#dG)CJf`B`"+H'VbTi$aI=Tf^nX:L:#ab6*XLq_3L_T)i`6sEpTZ1rW<Z2!Gk]A9N70!&k
#\kSa5"L(nlTS;(b0tM)E%>/7+Mq2!\Bm8A*sMIIHo0S2_6MMg5c3PKIm20LBGADA13jo/*3
jAC<_V+m!#Ra;?&]A:?jKi7L]A"&8n/Nauo2*W#rZD)'MEOBTStr;o-X+'3G5/_5f]AgFh,_14$
I4\6o$ZnB*(FDI?SE@&(ePdp"#eS3%LmVBaQPEZ,(ZgfN7rAb0K7K><`.WP6l$^MD.p\qNkB
T3>C7A=L;9PIR:W6!6b&^SI0-b$bMqRb]AH]AR/++sJsFR%J)""]AMRug&=%AdBcP=fK(0rDk]AV
[Q2=heN@hgSK3qA<eKu=I%dOLg:6Qqh1cET5bBE)(k5CcZ0)L9*D4"_bX?):V_r*KD!'L_g]A
eeK56"!i28e!KEcG0(`6L71!r5mH6Z^2?\S%0lW\e'-0R4o9P:WTA#D._D'"-=p[Z,d#npLH
:WpH;@:jHJ]AD1B(d7#>Y?Lhpdd-!0-d*3MB]A[j\5kKKkk)A>(fBU!KpULAqpX.\;&&cVcCW!
r"G/NJR[eEFJkm:O%RdLCohqeP<(iXaEKE>9)1gTqt.rmllZ5&!"%q/-AZ/\FC"fWV3Wl"ls
-C$(dn7Qf&sN`CZ)'LGNabFNeD(HRqMcV?3]A&@KrK-M'U^V!,=.OObdG2K'`fgFdo'f"^a91
l.cb5GCSnCgP#>FS?+3qD2WdAk56Z1&rgOWK_:B>AKAtO=YS@jb[gb[.#,DR`EX>nb65A!Cr
^HO*3*P0(70>q$c!8+'F0AZ;\O5++>3;@5k\;0*DO+`(J*oSZnrIigcFN49('Tk0495Hm^)b
4QL<_TG3PYLQj[Br\@\"B]A:r2Yp5JgjgDRXqf&KiGGeMo<tXS+g+H\F3X&`jO^3bFB$)-up5
`g$Ir,u+r>0a/14QcgL'):,GB,5j^^"ZMZnGH(GEla9_eZ`j>XCcMG!#fWV:^uM$E?`S/%"0
CV%gpof\A*Po@pV2(;.1/ori6?OM!#nm+cciE_s0E;MO$@lQ%4mnir^>biEoCFL'&!=<6!Cg
to4J2nZm-PcauWNhGFj?eGF($5(;WOQ6KIFQG/g:=K:<l'gZ%ZlrA><i"9>-&/6Wkr+L[`*$
.gp7"&sN\iZh*-Zb@-XGjhNP[06/m9K<Sh/G2\g^YBl#hZ.#2.-Ml7ZhAX.Z8^T5B!.^=>\>
r9.0KHhr?&;gUOP&`=tct3ZG4i30TeJrRe@;./YAR#hNfW#BXC@3M=4R9&lPsNeFK\$TBj74
#&eb\5r'Ks$*V\[4\%X+<iM]Amm_<JKU1L3JL2:r:Xi=+V`GNFhH_[-p9a>@O0u41nEg&9GYf
4*t#eD;(&8GDRS:.&2Q8;JRq1]AUZ\?oskmS6g0[`<$k,?D-(+@r&aFi3%P,1+J3FmjNfQpV"
,4n_V#-.(n+h&n!$Z7#;4hL]A/V8(N7K;23muA#M&IbEAmXOAh@8C8&I]Al"^7E@Cc^Lm;J/lI
T?4N\$InR.l[ogLb'>1C'*=Ar@p7sdCtu%G[.\_-E'<3k'hSjS`?DV?s\p;B$Ydh#q<!(-Do
4aQ.2RmIM?A_qI2%i`URsFpQbVb.6uj-J()\!X1\i[$RfXOYBB>%LRo3A$HPSKs*DW4VV>n;
`Wi435GjZ/E+VXA3R7*(38Y3QN6:'[L3hAVLsaB$+@GZ<%DVWT*k8F*e1Gm1*iFP+B1!a@_]A
j+8J$nc%$AciI0;1')QF#Yc::2Y[gLCCb"\1$;fhuVdYA0JD,#f9W5F&6sDY9&Omp3mrr%H+
dBBsJ08Cp:,#!9\S"q@CP3^Y*%fL3D(PbAD[iAnM"6]A*)Pd.\hu3YU-'=50[/'26VtG*On)"
%\qT"D>3`@Z/PQBTKo8)$,o[R[W/>6%+"EfnnF-4O0EPB\t``qLLG$Or(C"l,s'2(?1Z?45@
O',f+OC>_;t5-+Ym#i;[R`AM,s&)u/@6f`sHK"6(:%&.&=Hi&eQ^M/DrXFsP/E4;n.hRr9#'
+<_;<rbP^cp5G;0W:CfYe&FT=QUn(?3D0sYf$-:I>QAO(WBti7[lW!mF+7RBBA.F6B3.cW.j
^b)0)lb4*AE0$3no8Edp$Ih!BAFe=EK%a&K+K#7_&0u0n3f_4hi1dQAG0uTFpIi6Ms;^"]Au;
PZQf6iD]AUfUX(53eI<G_$B?5<E@Oeg4-b=tIIntkP$TfYCcd*SD\aB##!D]A\r\nCGUPGsaCi
&Xu#gr`_!iDBcSmgGFor1sCX-t)k;cU=U"LbM88]A]AhQ%>7s(c,g#]AZ-W*!=2mr]Am*l_K)B)J
9B>#VRUOW0?`FWWaEHZ]A?NIA6W;db/>n*E6G3N(uUlb5&F5AJ<Bq&G#S0\(Cun;Nu4g=`V-\
/;1uQr%qHof<OM:1?m[5^d3cQ%^Q-oMZ0_H6>GPFI'EkoPW1b?YQso-4b<#2oU>&Pq=4ouhD
B!'fbUcfIWdUF<'Wt=^RTY6=>@aFP`,R]AmqVrM/o9Duid2g?&O;0MN"FD$fS8sLZgER"mI!=
$Y(J1m:G:h"Vul.T,L,JEhu?YiiI'94Vd1HhYdXDcCJb((1-N8Z!2[Pl2`)5`I>pep=3tupH
>m"USRTpodtn)KOrh]AP[W)^(\bbdFbJ;YcNq.lQS'?%OL;9:p@<Xnb0EoE;)eWLY\'d(-ARs
`mo@CbPj1/eIr^7>!^q#?;Hi2liNoO4/?jbH!R2td6@Atmqi\`pkegI">\f[pO3*d;-p)(gF
d^4Qa%n<J3>";/grT<0&0>L.Dp\J:MC`RAY2*`SXO6=JhG`$nLh1BE"-6ZbSk.F<3PQj%/8-
LHcrfQ5&,PH#1.G`+q*ol5"+Q^VXT25T]A&0UT0k,#j6%=?-o;;Y]A?POua8`=42kR2agFKA'`
tIhrb#MlC-%5YefmV+Ir_gSrL:WQnpX?)oag>P+\@/LcnD#V#b(aVTLj]A!N!.dt@e%^A,=+q
+(9GK!*B'kYL#=&HY5@GMtd/9F%Asa3L]A5;Ym/hl>,$3j.cGBIu.snM(_.=U-BSWcN^Q8</3
%HL<./0jbag;<6RO!'3hV:!JLZts2i?H^LHfW+!6kuEa#?5[*5MPr?9JYs#"rdnP&EOs&>m/
+]A4sFKp$4hR9P@tbUk+7Z\2R2$o=5&/sTZkp\Q7H`0C.1'Hq!;gWXg;,$Q\+)!3U.DfhMicT
cdO4LWl)q0lVAchH;N3)l&)IE%.C4F)9K2tXdukE`FO+:01mQgP*K`7U,W4U\Xhhb,[s%N9'
\*>-/6eW[?>WHiU@EjmTT`<\j1hS[IKgLR&[0mi.>`^u6;+AVQ_cMj^B3O>)O4*0Tb]A>3Zr0
k,P@]AnNR)XS5sRqPg]AAZ;k!K!$hL4*rj(&W9FnOH*q9#b;#Ka$chOJdsc#-l,(URm"&0OaFU
aoD%B>h`c<OQE=X]AtBItHP=qCTl@F'`Pa%-t9*2%caNka_Cg[r,AO`YU2kT6h*h<&hPg0U;G
GMTl<F:Y)*%d]A%CL0F@bDX=1Ergep0\Gt3r+Xk*Y#5(j^5M"Mo;TAJ2F%ZN4puL;q/)Qn$.@
M5&ZS%?PQX+/U=]A3;ci>s=e@:)E0[(*ENb`SG)8\CEA]An]AYK8rDaK&@_>H]AhhgN6GYU%Yl+<
'!?KiV\+mmWcQU[[(3`2>F?&P^$>>S,OjC)/II]AtblE&+a!mbm<F9m<Np[9[T9Did[efM9gO
ulfnQ#A>5X<!]AF*1&7IgQacJGLh,EqhjaQ).UXRQp:>rqMCuXGke@`d-X8d1NYYg9(\N^m)S
R_5J'!C$Xs;5KZ?ZAZL=40*TI=ks'7J(LukuMMnORAi$\A>fA/&qF\EPLH?$.-_KI\SVsLR\
s*O9UMXj#q!VD1J_2VrOf/VE[K2o&mrb(^\LN$*AL]AojraJ,&C=`#dKZ`F6!Y.bNpId3!'3c
8KHeuWG%#2EAYIs\D:%aA"\6J6QYjo<#[Z!Tce:\&)`^p0H`Z!"p9V[M\Tn>E;#ISRW4qtF7
fY4SZ4UAF!(^\:R(IXg&Gi%^8AiA$;i'6qm'S[XpqqX8Bu-as6XjD*2id7[d?Y2j.3dQBj$c
COgT9B)!Ik"/1X7$fHdEgWl4>u61l>*eh#Xkj]Ahr7<[[4f*\+A-COEs(1p07rnU5lgD;P@K$
0!A,b"/PIkCrm-t>Zch&`-(HL/GG55JYkKl<9ri>tSVsbU7[0,f0gKW's![-p'-iUUlSl.DP
,.u7iR4.ND&4#=[r3T=UT+Iss>U1V*1R97LpODtEAV,gmF0/E+"<,Wl3UPn/`3J-`2P#N6a%
P$TL9'O7UfT,9htXMYo<j8Cj?pG7U8NC/EPDIRf'^f.g>3X,Iq2QiU&9t(S#M`X.&6:Vm8B^
<826"-3b.=mU:$#jkCG#'#FEd'\gj+<,n[g>;#]A/miA,@5n,di[lD>Dr4Ep+Q_]An6c@u_"s*
E%4Rg;c'NH/KMEmD5-=dOju_pHs`eIILnQnk^3%i+.Pd9<;fRd]A>ETlVBPFE]Ae[aq'TK,2@1
0(e?2l/VNT@Jmrmh)QK%GM"7#m2HpYH:)4?iL&ESN[Qi>dK]A^0r:Cfd#t[/9A%hJd)C9@6HA
#tf!-BSG'M\c(gB=#amX&!CN89*+pL1)<Z;R`@B2r:=)62Z\0a[CM$]AepK]A4qlPO8dli/"GO
ZVW8U?kE^irl9H@*DdE+u]ABj5dJJE/PeZhA_'8^;CNhs8;Q?j\LSDI!deRX]At/bWr.X.:s(Z
;N=`_A4+k#>NG"QiWop0oKZi_.AflNhbJHF7-VF$%Xr6O4M@-refLos<QS-$2asa_5XnT'^Z
W,P%<cgk,XmJS&huM^OY2-)<aBai_g\^M5Ak0'qIh$/./Yb'2F7\f(j4O1Q$`T]AJM0IZNS=9
U-B8*[qWGJ)g+;e2Mr4#78nLgL<']AG,*ZsR*u[t5_c(H<%cD^OFd`f9A6iYN[&Jq%SP$S&oB
=A3minfuGm$[COK0pC^1Od-[;k\M\)($9d;f)F?O]A[dnR"RN1s/4J.DF]Af:?%9SHuGss1[@X
)W2M2Qe5kr^LsHgE0['D4a[m"4YZNYNZ+37"@I1Xr7.Bj^NP%m]AjU69`S6`!Qi@1m_B)Ug*H
IOhEJjCuDr9^/;UNIGh-*"8sm[COE,cAF1Dq8X=)9Ah8P7B=6c3a)OrBF54jdHpl#C6Gpea%
4o\_aa-"K[m^msg/<uELJ9[u>'n-I_k,"ponpC0"+2k=Zs+amQas1?@"`2b,j[G[bu9XXU&:
a]Aq9<8FSpcPH.S75KB';3#"?gUOX0DNK>`pfWAr]AQQ_J-^8oKaZ(9ACO40?>693[+@4O]Af1H
kL^%ScKpY,hYGXn4d(aqLsG0I*0W@[r+?\%ZEjj,\N@S0m!Lu>-j`2+bZ$c.Znpo*oNIqefn
Ou3[2>g,DVZ*)\gAGqV.NB]A.6geo&mkQ``4e4)ZEbnQ*U:h&P6:0/ls9NhHl&N3U4u+Qh3I:
FMK(\,2]Ar619*)!qXo=.Lc/`Wgcl9lC3\n*$*As88`p9V%L3./t]ANDG1s6E9,C.^g_.?;,e9
OYEUEMiUabB^09Zq?c?5h=e*Ucl[;Z.->lJSEC,Z8SXIh)KfZVNG\'c+CG8RNCefC\(^`MsV
s/^%VX`&g7V>&n\=jJ-m7HgRJ:0X)"<dc!+1WaATp]A8GO7u35IEmI=\aM8?UAnd^L95Y"i8!
Z`]A3qjS;$PjBU?3;[Y)?qHSXAX3BB@<T&(SbA'DtR1gE+j';Ft49nf*T?<[CJQ[(:VhD>g:T
H?oBmO'A$FsL;9W/@o`4GDa<5,<Fh51GtTGn5._'T6f9&@S[03H^=iV9Y<N^o9k>E7>P;HIb
M"PnLZhQ@EhpYl%ilFUo&kdd'N;tE>K14OFC<\]AXPB0M(Yr'BlG/._k=R0b^![[$uNRfcoZM
^rQY[SF&G$JOie[rp'1*TFka4(OYS3Jn+tn-n>1Y@1N@Q]A_`'QR,MA-51B@J:J#PaedGD;>\
Je:"Khen`X#O*'S3=!fpk=bh/5N)GSD0flSZ)73CF0YmsIu7/S\,Di$_(7,A4g^>h;+n\)4Z
#FtL+3Mh%ee,5s>\>S%T"Q#(eRF<Vl8C:6hV+F"F>3dn#/mRQBlWHqe;VlPm?IO5[+9T$uZ^
SNK5OrX_F/#/*=`.m)JEQKjpDb<21"gFl/9b7=,08b^GASbU3,X$/\-klQNU*+n4_MmFTnWZ
MGNg7kk?i3,L_&HBTS?@jGHCS=35,Q>Wp-9Y.SFmBAgn^7^tP?'=$_8W^mWJEr.S*\gEh]AbZ
#>JO)SmqcReF;XejMfahaEVG\6Mfj[YD5ogWShd!$:`Y>@\IR6To^!!bC9#XHb.]A(JT]ATFi\
E:1n-Ur4#8_^GcWho`WM&'X?pS#,sJF+3Nk[-qALf*G2Bi@`G90\2Z5a?U?5MLe=E@cn`u<O
@O2I.:ZfOE'82NJ_&'@78&=2*3k%k8ST"2$(!+"/W(g8CB1_l;cpi%q\n]AXYCDd+EH<+9^3Q
qV%2pP0L.g=lm&mOq&jEb,VX^WPKAp%%@O/4U@!AGNs*Xm6coL)2sLWlR([b8n$_PJSAX6#j
^le)G:m4EafY#<_@,j/=Z>HIsh<?aEsHeNHiI5"TI-a]A$HPh9*ND_@-fQ?p-lA("CVKNADVT
1='?)m3BUKAo!;"EMSt&)]Ar%U+?3QjI_oe=n-(Wca<RNQZj7`BPM<`auJ/Cpb(1c:kn1fEr#
s;:cO'd>c0=[Xe]Aj=nF@&`Z?6X\6I*2/pE(170TVo($c_:qn'meD=pZ"?$QIK=(95CQ5Ed+O
=Y/f/kJDV7lWYU'fjBtZ('mb>4Vbe,[$#-P+K(%FMmr%]A=h.a>n;a0uG*ge!f3kF;+l[Lb0O
I50P1<!/p1Qhc`mrGB,2#>jS+2JQ8e4jhOe)SGj]Ad-b;^#\9q99_sB2m:e$^@q49efPe.&0R
)k<HE`*.oo:J8XsQo8Yj3DM6jXHpSV;4'8d*BJ:*E4kCh7E4QI-c"_VZ@H!Q?pYgmJL;!n?%
:\TJ1"0KAoBn<DP(*\)k&s)]AFPpkY(0f0`iTWs18!IDf1#7H58l\Jj=Q9Re7E1UAs&'sV_1f
!MNm=A`4(!*R)TR.IA:m'R[!h%F2dV9"+'jbk=,B:+HGn'SjX[+OcTqbgHH!!eT?2\p5On3d
D7/[Meu7Jl18)/tLZ[n=(b\'%"KV2%?[>Y0)_^ng<1*/;>jMLp^e>9"WW92Bhn`4BkWZ[mJR
[]A^Y2#T=T0oZJ3rLr5R\i%spN2,bVVO8>dCLd_'4>'jBm$\PjoB@(Ij.oaVRlO/^4qYAJZW=
his-!EA$uf<B/R?qb[dGCPbsM\*D!2on92P-3P&Z@8\"f6m9,Eb)f0?tf#E<^+,<W7kI"q,b
6[B6rY\(qCnQm,gDTm<)se,d"KuK,GU-b'kU%0NOK,eN+eGT;KnK?(&hG2A'k:`qH(K3=_HB
ULO39gt/\YYLJ1LW_cBY[0Z'YaS.$"\^DC(r`#;Y!XqJNN[n;#<C>;$1fG:499r$,OOh*#Y;
Q"W$>LC2u]Akjg)_j(IU-VZ%aqd?&k/rYC$b^/pnfmg'7g.:1.1#&T)M]ANk^"FeLCbkQWdbm^
&g8B\\ZS)]A=&Xi./*B,9n]AK;_BU>O?q"IPN*t#!da\=$C''qVboU)G?0bbbF6OnB7!tdZBnn
HhXbDB(%GB4,\eAd*f5fC>cS!a*jLS7n*Pd1`@V[5VQ?N8+?UiiMSod6e04/tK?>E%iTX7md
,2t%-:sa(aS<,]AgB3u]A[li99-53jNF=1S$#^br'Y9b]A#U:&qIp\Y5jo0otE9fb!YlCH*?P+O
fc]ATTa$%(;`P_SU2:XuDW`o2B5q`R()eX9@JK6H<6%Yg5hSRn'7/%7_;qlASe4V:o./9-IkH
J_,c0(.^(71`MZVdtK_)/N%8:K[$!AmmPKFG-7BucO<o^-m*Gc#W10hOoc!f<Y;]A,i%!";Q3
oXTF2GJ8*C:`'a^LqTs,Qf++T'0-,[/Uab*/;%[Q%!hd59YCraAkGgDM`DXObF1r/c^]Ai?2X
VA\$BHZtAC.MV)r_7967\A[C"O/fr"dW4XDs6*l+\V<H$T2uRQL*tW'rX(-+klI.WND5Q23#
c*Xe,L=(ZGIA`0O`9)XRC0o_F&Z+9k=PC4e>^=Deu)%n\EOr)Jb(P6NnPlHO^F]Ac2t^a-7j<
Bo0?R`RF6IkngbAu,&(c;LYu#`kJ:Z6639EGqln"@T?&Q*90UG.6EagAAC/JHFm_8u05_.1.
BHYRMlS@LG(<e=:Y[6;>@Z6LV<k'>:ZK)ok-.Na66bp*%J*RV9H$Ln!RW:T]A%sFg[dFHFAAm
Q">'HXQ%8,uE6?`(i-RVZJ5EmGLQk?.N@4*]AS#='^En^CsHI)utW?kugk_[4k5(3&*>nZQJB
>h9(ITEZVeG^0Sn0$oX$WTX46*pM\;sSY.5HCEk_s?LrmA`;,Fd;D'M,Kc;PrlL]Au5q2Or2$
_,sWk0Se_3j9VELEK="&r'hH1\#,.)`k#r@P86g^T0*G"kQQJ1I!0fY.KdsNY0L#Q+'P,-2b
("#(YeX'!1o!r&Mfu\(tOeToIRH_4SFa\\D-)*$Ji,l'D+q%u^dPS0a0A5NbS5.r:B'S?X89
5djWrYffXc:rCJRFT[3H(bYOX[]A"P4j2<OO%\e-6&\q(SW!7Vn&/Co&V<\.Or,^m]AZjb_&a-
pZ<r;Os<[s'?=2R"F7L)Yq@MmaScnKj%]A&&CUYG!E0K\rU$:=RKJ[_i`lro#69aSc--`n]AD3
Z61u`IXua8&n.U9ecC+WQ+K$Z,UXa5VB@Wnqlbm2\"UjT[LW^9JAZWAmb3%:3p\g&cW"o&N7
G(/Z4@l*+YVtBS.@9KG7oQY.-uD2rF_PXd8Q+"3J5MqPs4P8aO8EOi.L/%%HVpXbH*m;#9"?
e#=W&cA`K%rV;@a[&?Ur,.>3#V[C=n^9HCVoaM"<Eh>gb"R[OasZ+`/.V;_S_VZgBaW`g"05
+6$?8qGn4f?gZt&IlG`_7il>QR"=D`k=_7`bC-QWV1AHE:[IfQO%6<!S?^TK@G,.o$%72<)T
M4G5O[R12A".H@(%kbOM;>&KPWB5;U7ZDKAXWYb*:,E9(G#1F-S!$op)'/MLp_WG=MrTNgQ.
VO'k\VTi3H._F*"n)YQ?iXhUGo'bOV5WWG3F=^N#A)CI3,LN1i8F:4G3N.)+\L1KWlaYLmVN
ETU@8+c"6"qR!-.nE),m(=4f(=qd(Ij1Akd!;]A?Ut0>G;n3uY/Q_R]A`A5#5/L+B33Q1Lh7N<
opN=a@!kn(F@,HsfQSoH01l?4ESL.$^N67SGclBX%9Z"\F=obGau5I3qsS!>Pi^AiF]A%JQAB
[68J>ORGq:rUL>VAh;nHfXThP,ot=#mVn@&jaZe`gof%-&5LNgO?</Q?,-'`0I,n=Vt6gAmi
e?J@&4u3^M8]A.b-LQDH_,(V_tob;=rtDXKKZGe'"s-gE&V;,%.>3\@7R%:,adXT8aSCT,0G=
mIoN<TIr):5Tk8X(NW6[fJ5^p?rJs+OUKEm\#$M98W!VL;kR"/&Hp,!o256j/LRkPJPF^6J(
i:n*e>rWMZZJ`RG/Yuf)nS8u*L%NhO72V$SII<#<I`,T-LI:J/Yrti_O1i5O;D(lop!i=<fP
191-Se\j>G/Cece,[Cnj/$[mC;Uo8#iN5WQt-HAnN\#SP^/9cQCk/^S*[DVjL//\`1BegUEp
):]A]A\KOfkL9el7%3>#e+hS[(fJM4O7MQu9.C$:G#Va3Oh\OkA^%a#YJT61`\6\M:'0'"mlI%
91iAC6R2URu1Mqu1m_.g(1=8&8-S;l?a?h\2I(^8YQ!NjdcYGfOpah*&hXS&Dr(pM>5:;(sA
F7]AKK'\G0u1?t"'JKiCNF=9gG`/9OGR85F?XEd0';f_7_TOnKH]A9oI8(Q(^;kI*Dj6&!V)n-
.>8i.0ZIUY;>KoNq)U:*PU>cbRg$@nu;c-Nchq)ON\dho^n+b"5%ZI"J?HjO9lj(d#70j'R]A
"T-*H7!UC6Ko[rA3gSc`sKaSa(@q'\.[XN`@cGb$XTjsbQF:9FbrluRIM>qJSEA",M>aN[=h
c'dRBG@sc@EH?9_goWDGbIR<N[1dL.ETDtuot'F8NMDo_6#eDTA_7BdLQR;c#=c),CnsSm%@
Kb+oB=OaAlT<*E*^ALP(3u#mpFm"MZ*4GW/D.WC/*-6+Kl)?GNbD&6b]AOc&5ht()+BCC;K`_
*#68s3SsusjIjJhGNG'Zs?<C()SLHR"'87j@!b^tkq1@^b1>M9rpoXr[ebl^PK3H3:\63hol
o+FolJb63OkMTj$(jJV^;/0CgH#=:7Z0``)6_`;poQ[c!TcL8;karVCua,ET#JFiegG3eRLm
1&k=%#H!lrY_WInVHGD\o)**hLC:;&YrA6Q#*?FFA*Z2gDZ]Ao&07Q!CR:C=c,&aW<S_HXo1k
1F,Djbr.rcRufhrf]A$oG.,7Q^?-LNGji#`YgSA6o.$%?&^a]As3Hr9W#m-WuC('b*?_=Z4SX&
-NgaB;NJ-e"-j7ZB@6OD!'r1#]ASG:.*Vr,I(<f0dA5)BDl1lBT48lcq<\spfF#?.m^N&G&QP
GmP*+;ke+NA_\`!E""op^WH3V\"5$B9im@+"FoHS@j\YJj85BMaDH[D3W^g-oF#5#KPNke^6
^iFoCRbn3,iu/bBQ7;TQu>/3IUG]AiJuP&rQXnU0R>O_?`miZbD#u'-<s-&qlEN'.Zs']AfZ)-
[s*^k?CAB7W7E@;.R,[N36dS-7=?Sf&51!*4pJ*]A$Ar&,1BTY)H=cpW@Q.&@J)*j=Q@&I*?O
TJCYRS_c83ZA,Z#s/(gUfO/>(q4:KY2Gk-UZn.@f0kuHF[E(P+LRB,NkB\o]A%.^&%p`4t$p2
@@>qJ6=8p)mBF)d"CsUJJ^+IUH"P\?:L'S3e!$=C.'^OIQI3,>ur\#&7X$8aO1tohu9"W<6k
(W5KtHQYp2Ug)51OfT:D2dcuf$Ftp5<,@Y=OS%X,n,BH+r6iSYub5M5"00Ag4OB-%@a[0R^+
^4[=ib(rsHGilGfNb.rSgn4-U'#?T2RuBm=W>k&*$n&KOFO$Og_6`0)FJKB4WXoMqNdK2;Vt
(_?SWQ3GBst-QI0=[fZdZ'an_U5XW"KAiB^3ICh43fDq"'bfhBn(H#RQu$Cu_onHe]A>-WfVG
"=X.B(%U,+hrmLX=1Q?Cd2`j&r,e<7IcWL=B*fQ\lnOMDjf:#n6YI*5d*4nB'=,K3OYaj$2c
8O4+'rk3.Z&'p^GpIU9e9X9*:j3bkn6H7/6!7;qZ#Qc8`kquXF)7l:!+sEYu3HTEk&eZ[cH5
BCXt#;N6/Q6rc$MQalJ"E=+Q<oFBEHd^!#&JYE[;!=nN'SjiF+"+;:8V(,pEn6h)uV]AY!A49
&(!_UV5nX?JLo0D=C26o%2,"&IkkcL,9F-jr;GRF<r:%%prL%1O3h8!*!*LD>=$7kG?_tJB?
4Lqm!WDq>;Red]A$]Al@oXTs)Rb.1%=8_QSk"=nW%2mab_u(`ems$'M?S\,[!uSoSC_%O,\Y3V
DsO<2)RiDH!W3Oo<(sDPp1FKs]A\=Fn5b<U?pie'Y9"(kn@fO[@[u4'N)r/b:LMk.!kmWs&jf
BAXTqb"WkF3:(TBEoff:4_?%*%M?6]A]AhL*`NDRq^VC,>g=%=L`OTWR01*iKI$_bE2sAsmLDm
5<Gkf0W?gF4EniF4U7+WK>2#J+(al;becb:<303_<#FGBV-+M<S$Ls`23"H_KQgfZG?UNU:a
ZfK]Acn,1io6f9YOD4SCn!LTuh:A0nf'g-1/8tb=ngZ7o4I/>WlX(>k<\<ZVctXb=E?L^e'AA
S_H5V.*LQfJ:)XP,1'Zfe%T`p]AUkPY[5Q`[fZrb[!]AKW4V:QV''PFFocEq**`a^1nUa^QO#3
i1Z=KoGd2WH);o5(^'Q*2D:1)EuA`=,ZiCo$GMsSR$9M?Ab<'(=t\Ia0O!(0FHbrC+1ldQ,t
,sPF28,tg&G89WN'A-lEU:m[q@+'3+?=W2([/L<"n:bm-?6Kb_rYY1IG(7O-t=K1U943_cOp
YD`pm\SgS#Y2)ho.Zq:NE!DHY#Y)DoubR6aNE)>$MQPq<jL0*E>E6<6-g4JODX^!6Qf)AcT,
fNNOfK0i`oUmXC.+Q*Z'Xmk/6?8B0e!%<anKL=Lh?5A,db"hVMSkG*CqNjToJG=8RV0<$9/[
+f>X@?'OIl:TX>R*mZE(uj7^[<9L$gIC&1#>&#YpWjDsgtDkcF;)clCUb@qjjL^[K-Z";3k%
s3u28LR\//(Jl&,ZH^Ih-.1&JTKX)<i4A0%P8;GnWP:9?mS%dt@;G4"L:Q_6K%>9Q]AinXr<e
;+A>47BO*mPP\k./U@`nO$b<>ANH,PZJ,MY-P1?n$$;j(Ma9"e/7,dG&!4BE^`S:g.WaL!L^
pb5+Rp!hI+(.[kZEI<^`.`i]A2n1"0P54Uq.^ki1nLP$Q`c?Am"s%@*'<PY\81<S8<I&k<<9_
ri9\gS(jS;=W*DkB!QZcL)K.e'[L&+0s($V.HNM`*3,bN!7/I198\"c7,Z0LRKh[AmX.ecWM
/K36O9XUilbEj1]A5lOs_sUJk"ZVIut]A\khTe*?EsU:(-B`Mn5$I+SaL_*C/m*fb5fR<)(N09
^Kg+Q)HN^>0%K9JH-FjcPJ``))Z51``[#6IR\^l\h'(9oaO:gA*%!LW\1>.OG2eb1+A^-uPU
fqln4&X6SgJO!./N,8pNC9p9=r@]ADlG)?d0:'`RS^N105:>SO<`Y-`)1uAVN<^U;Ruhs.gJn
EIqm>t89u/I"F*O;YI;\!rf(-H2mf+`S*J?Sd<Zlm]Ag6'ii6m=;kqe8Id\lO<]A@9U(7_aY[o
Q_NFqh,LTWkLU?T/4kUqq\J#XZ1(n,CXm!>hP[B!ELAe%V-r(Hl2_qk@jmc<-N)+aQG_^"*n
)6)Q&,TZlqM9UOD]AC.*?s4bmmsH*W&3GmRgqOU@[m%Z0SE;LdrQ>6sq(XmS5q]AReQd.8nQj0
7>1fCmp@OYo$HJ.""nNQ68t+g,2;$q=N/_/1S"8>49(EYBJL@l5r>:)0Z(p1`Rsus=>OjTN%
ttc<h-9@M-V7@`KpZ@U)8FO$,).gLl'^5hfbi?kVqb#c&@R6[J/miA89`]AGTXV1#lfO,".3@
uQ2!^1`3\utS"r5g0k/d!6jQ)d[f\FA/e3Q*g!!ZN3Xpa>[%5cOQgC76f_X4>MJ:=JW_mZ'i
GE)HRk3O`W\%.N3)UFZ:Q@JqpDR'nko#?&[1Vr:%X<M/7q.Ba_Y[E/!b1=#-qd\W*1OCbeo4
IEk&t,P'D\CTOgHR5k<&;j\UJ<?Hqbm)c&!!7A[8EL)Lf@C^"ROQ4']A(SUmKuQ^B'KnTPr#k
73i/AWL/E2RVikjBEFb\Mt7V=LS<u\nD!&sZQJ&-n+,C\,lW6_kCA1&cq>2O.)%l5Irt0M,l
(pgeM4175oF96OdMG<$,AN/S*A8Cm@/6!XL"sPL?_IMA.U8Zob/]A'_.12%qkPi<h>E%PRpgX
99bDetH<ml=;-t/-XqIq1kI2juI]AoC4S0&,jX_/,(R1SY4/Unj*l"$=8n5'c"b!'Mc^,R/j>
3'<1GaC-d]Ac"0/Yb4/?pJj<48TX/i;_5A:q$`e@=-V?W72\@"4HNQ'7fl%L`U.M[>si`HBtb
u2$d$-/j]A%\`'rQqh:LS``I&nlUa<.QhJ_R]AFU$hbFTa9ah4^`UNIDTE+0oSDa%F.,.a?t<0
nsB)E2r1p+>ut`b+0eeuAkj9OR;YR&J=RTh57rsfWVU9ND0$flXt3"N5Z-lLf=)u@nm!Bcn+
1I0Jh[X+cpT!:L8bhHrFR1&Ha<mNo6%b2ktktIW0XUHZeafIMtVq[_GIbn79/"8Fc(gGZhB#
V5'oVU'73qgGl8$lWmnN5<'+rb!)`b*#%?E]Af#GjZ:bVQc!E+52h*8V'DplI#V<]AHLr,/V<0
o%*Uh=<bI$Je.jld6&*0Z9%_g:ba@UK)u<O-j-@#<R+Ko&%W+UNpAshQ3`\E4"g]A1r]AkPK.f
_g'Ms)tTEqJbm-tD6$=-@$7r#Cp\_^h5_h#Lk2`=()=V2o>jA!]A^U#<a[YV!)/lb_r^V6JGI
?%da]AO;XOo]A'2Il'e*03cnU44clQZ>L+#p^(cWRsZaQ7&m/1kEDmIEPGa$mppWZ&Sq%k;#=5
Mqp,F:<_-,G_Ri:!bV]ASB?mbC]As7Uk)KV"]A=u34<ZF,`$!nhBn[5DqV0bKIDA)&QhS*eD7)#
HY@<X4XN3hBKBnuE<k<gE`!3oVc]AnqF?nXs>Y%)qf3Hlol]AB<s:#g:b;k!PAd*L*P:[-E13f
%BKE@*F`U8HL0l1Mjf@Dco!hG)uWG^bR*q&hs:`7XYo#2gpuU)iIg'q<:>d7Ji/i)AjDUTmq
cNc`Jj&Q1i<J2hU4nRmq+N=k7)hqB64-:`I5r#FffSe&maaT2,&*B&/4u'q9MfH3<!f/DF.&
dl-mX9.;'Um<C$n+K4\1a-cpmKPUOd$X2ED=u-2*efeH04aB)Q[+0H-^NaRh5o&&_6F;1+in
`cX6HPS=Xm%/)\+do_c)5t'(<mq:qlLP-E>h>M;i=o(U]ArHVek/]A"R40:VX8H#:m8\b'=k$@
<qK+o$,4a?/8OIiTcYt1"@a;`</`4N0_u1FBj'*>kBZ,u/CTb<YQ(o8ls4=AW$(e)-%-CiqB
DtL;gQEjLaQ'$$>%F+,?SA9??DMufD<9`>&\_Kp/;'ZMn[qSR>j;$(:81INp%;pTbWWXZFlK
]A<)K'SWAFA=j[FNsZ,8T.OcH+=M[\USUT[?lt0.5Z8.)r"<]A%r]Ap>F@']A7j$Q!/,WS!gX/B<
kFR<p(=S`qHM71Ih-'Gr4(mQJDa,BnH3]A?'F$iXG2cDZr2eb.+OjD=;mjV%SW5iMo#2m:s,F
i]AVX^c1@,DVFUIa;s.cK!A$2!h\1dO$j[?r9R68@OmU2f5l5F>bhf71T2Zc1'ZUBa20_/4O:
8(S,0&.gg1CT!=Cg<8#UMi4H_X<Jqba/i&j9im1J\r9h*FCo2J4Ru%X/.RQ/X;`Dl>(ediKA
XE%0m=[o[Q,IC&S\46qI+_8P7m3sUT/mUP'JUV-nE;PQ8.5nQC]A_s>:'j-Vh;SF9!nD!Y,U)
4K.uuR=W(EH0QlKK^9KNjhQXJ+#efKZ%g'ql*!Gt/kQ!fm3di-HsSt(XinV+:<Ml;"O_MWng
X)+aTFuIQ`57,)%Tk.[o!37BF'p?ul.d]AfMAWcp]AoW&7(UE(]A8j"9`'`GMGcqF$H0`qiTo]An
cP%#@j=G\jZS4fc&_q4933IC6Bb:1'Y>[G<[WAWMVO[)Uc.4&:ELn5\L:d.@p<NNc4*-1AJT
%"\=m#]ADB,(N$n.[7RaW;@6L6j'j7*T8Zpqi+)!=5OsI?2?>\MiTg`G>B%Pi>]A7/-K;QlO;K
FZlF92B+$IVS.d%s@[ZlMNpt-a'5IhGM3==hppWNn4J^TG1&C#rFNDDoD(31oasgpV<)tNQ-
aFU=.HCN:gnKd;d\*6f!P75OO:'L+oE\#?G;OoS`2a$o-hnlqLV)IX!FaLukotLdnI@5'kr%
A>/)$f<+(,U@]A`B8\Ebi(q7+kJNo#DS$&g$nTHfY]Aq>;r0UR$rB=0O_\WE_5WW&h4N:Fnn$C
LcifiPJS2MMUOo2!$)YB39O*>`nU.)X`OHfkM-1:nKU`@!`^l]A$qf7XM_]AR`^R*>6R)KBfoY
(\#"qi,/WfT9t+YXLKeKV1!MTscegTah%LkqV"K/hCM%DqoJXX=Tp,[pH[)4ABB;ennXXSUH
a4#VKrZ#/DU(uC0O):>iNLnMR[Rl=EW0hpR2K%2s6&YH!<~
]]></IM>
</Background>
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
<![CDATA[720000,720000,720000,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[432000,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="3" cs="4" rs="11">
<O t="CC">
<LayoutAttr selectedIndex="0"/>
<ChangeAttr enable="false" changeType="button" timeInterval="5" buttonColor="-8421505" carouselColor="-8421505" showArrow="true">
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
<FRFont name="微软雅黑" style="0" size="72" foreground="-1"/>
</Attr>
</TextAttr>
<TitleVisible value="false" position="0"/>
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
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
<newColor borderColor="-1"/>
</AttrBorder>
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
<OColor colvalue="-16713985"/>
<OColor colvalue="-16713985"/>
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
<Attr alignText="0">
<FRFont name="Verdana" style="0" size="88" foreground="-10066330"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="false"/>
<AxisLineStyle AxisStyle="0" MainGridStyle="1"/>
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
<VanChartAxisAttr mainTickLine="0" secTickLine="0" axisName="X轴" titleUseHtml="false" autoLabelGap="true" limitSize="false" maxHeight="15.0" commonValueFormat="true" isRotation="false"/>
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
</XAxisList>
<YAxisList>
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
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
</Attr>
</TextAttr>
<AxisLabelCount value="=1"/>
<AxisRange/>
<AxisUnit201106 isCustomMainUnit="false" isCustomSecUnit="false" mainUnit="=0" secUnit="=0"/>
<ZoomAxisAttr isZoom="false"/>
<axisReversed axisReversed="true"/>
<VanChartAxisAttr mainTickLine="2" secTickLine="0" axisName="Y轴" titleUseHtml="false" autoLabelGap="true" limitSize="false" maxHeight="15.0" commonValueFormat="true" isRotation="false"/>
<HtmlLabel customText="function(){ return this; }" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
<alertList/>
<customBackgroundList/>
</VanChartAxis>
</YAxisList>
<stackAndAxisCondition>
<ConditionCollection>
<DefaultAttr class="com.fr.chart.chartglyph.ConditionAttr">
<ConditionAttr name=""/>
</DefaultAttr>
</ConditionCollection>
</stackAndAxisCondition>
<VanChartColumnPlotAttr seriesOverlapPercent="20.0" categoryIntervalPercent="20.0" fixedWidth="false" columnWidth="0" filledWithImage="false" isBar="true"/>
</Plot>
<ChartDefinition>
<MoreNameCDDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[排名]]></Name>
</TableData>
<CategoryName value="事业部"/>
<ChartSummaryColumn name="目标" function="com.fr.data.util.function.NoneFunction" customName="目标"/>
</MoreNameCDDefinition>
</ChartDefinition>
</Chart>
<tools hidden="true" sort="false" export="false" fullScreen="false"/>
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
<StyleList/>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</body>
</InnerWidget>
<BoundsAttr x="574" y="30" width="285" height="449"/>
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
<![CDATA[864000,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[1728000,1728000,1728000,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O>
<![CDATA[当年]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="当前决策报表对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="dim_cal"/>
<O>
<![CDATA[1]]></O>
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
<NameJavaScript name="统计图">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="dim_cal"/>
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
<NameJavaScript name="统计图1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="dim_cal"/>
<O>
<![CDATA[1]]></O>
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
<NameJavaScript name="CopyOf统计图1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="dim_cal"/>
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
<NameJavaScript name="CopyOfCopyOf统计图1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="dim_cal"/>
<O>
<![CDATA[1]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report9"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="report2">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="dim_cal"/>
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
<NameJavaScript name="report8">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="dim_cal"/>
<O>
<![CDATA[1]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report8"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<CellGUIAttr adjustmode="2"/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$dim_cal="1"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="4">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320!n*c-/B>R2,\+04^&k9U:D_'5ME,TnCufDO&7BJ$hWtriOlLSLj+
S^b*5g9DFSC"Q78Ne21$aka[Z+EU!=R/@\@)a!XQYq]AZ?s:[05#sR!iK9=d4FAo!Ra2b*+;O
]Aelse"s($JU0Cdj5C1Qi0'@9>U:KKcIF\W6;!!~
]]></IM>
</Background>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="1" r="0" s="0">
<O>
<![CDATA[当季]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="当前决策报表对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="dim_cal"/>
<O>
<![CDATA[2]]></O>
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
<NameJavaScript name="统计图">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="dim_cal"/>
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
<NameJavaScript name="CopyOf统计图">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="dim_cal"/>
<O>
<![CDATA[2]]></O>
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
<NameJavaScript name="CopyOfCopyOf统计图">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="dim_cal"/>
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
<NameJavaScript name="CopyOfCopyOfCopyOf统计图">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="dim_cal"/>
<O>
<![CDATA[2]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report9"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="report2">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="dim_cal"/>
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
<NameJavaScript name="report8">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="dim_cal"/>
<O>
<![CDATA[2]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report8"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<CellGUIAttr adjustmode="2"/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$dim_cal="2"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="4">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320!n*c-/B>R2,\+04^&k9U:D_'5ME,TnCufDO&7BJ$hWtriOlLSLj+
S^b*5g9DFSC"Q78Ne21$aka[Z+EU!=R/@\@)a!XQYq]AZ?s:[05#sR!iK9=d4FAo!Ra2b*+;O
]Aelse"s($JU0Cdj5C1Qi0'@9>U:KKcIF\W6;!!~
]]></IM>
</Background>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="2" r="0" s="0">
<O>
<![CDATA[当月]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="当前决策报表对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="dim_cal"/>
<O>
<![CDATA[3]]></O>
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
<NameJavaScript name="统计图">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="dim_cal"/>
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
<NameJavaScript name="CopyOf统计图">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="dim_cal"/>
<O>
<![CDATA[3]]></O>
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
<NameJavaScript name="CopyOfCopyOf统计图">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="dim_cal"/>
<O>
<![CDATA[3]]></O>
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
<NameJavaScript name="CopyOfCopyOfCopyOf统计图">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="dim_cal"/>
<O>
<![CDATA[3]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report9"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="report2">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="dim_cal"/>
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
<NameJavaScript name="report8">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="dim_cal"/>
<O>
<![CDATA[3]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report8"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<CellGUIAttr adjustmode="2"/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$dim_cal="3"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="4">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320!n*c-/B>R2,\+04^&k9U:D_'5ME,TnCufDO&7BJ$hWtriOlLSLj+
S^b*5g9DFSC"Q78Ne21$aka[Z+EU!=R/@\@)a!XQYq]AZ?s:[05#sR!iK9=d4FAo!Ra2b*+;O
]Aelse"s($JU0Cdj5C1Qi0'@9>U:KKcIF\W6;!!~
]]></IM>
</Background>
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
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="250" height="150"/>
</Widget>
<body class="com.fr.form.ui.ElementCaseEditor">
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
<![CDATA[720000,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[1440000,1440000,1440000,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O>
<![CDATA[当年]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="当前决策报表对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="dim_cal"/>
<O>
<![CDATA[1]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report1_c"/>
<linkType type="0"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="当前决策报表对象2">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="p_time"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
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
<NameJavaScript name="当前决策报表对象4">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="p_time"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report4"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="当前决策报表对象5">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters/>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report1_c"/>
<linkType type="0"/>
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
<![CDATA[$dim_cal="1"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="4">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320!n,pj/B>R2,ZAq0Y6.\mSh?$H'm&6gfZ8D)6%Hp/X13;q,Gc5s%h
H'K(>4<keK;+.ks,,.b=jtlp0uV_#m\)p\]A*-!#f"ro]Al<[Q'<AR3:;hlWE5k\S"&5Nf@QG)
C'+S4=/7!%fm*\h'h;>"6[#2]AKe^%ft;aM,t~
]]></IM>
</Background>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="1" r="0" s="1">
<O>
<![CDATA[当季]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="当前决策报表对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="dim_cal"/>
<O>
<![CDATA[2]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report1_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="当前决策报表对象2">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="p_time"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
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
<NameJavaScript name="当前决策报表对象4">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="p_time"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report4"/>
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
<![CDATA[$dim_cal="2"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="4">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320!n,pj/B>R2,ZAq0Y6.\mSh?$H'm&6gfZ8D)6%Hp/X13;q,Gc5s%h
H'K(>4<keK;+.ks,,.b=jtlp0uV_#m\)p\]A*-!#f"ro]Al<[Q'<AR3:;hlWE5k\S"&5Nf@QG)
C'+S4=/7!%fm*\h'h;>"6[#2]AKe^%ft;aM,t~
]]></IM>
</Background>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="2" r="0" s="1">
<O>
<![CDATA[当月]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="当前决策报表对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="p_time"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
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
<NameJavaScript name="当前决策报表对象2">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="p_time"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
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
<NameJavaScript name="当前决策报表对象4">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="p_time"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report4"/>
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
<![CDATA[$dim_cal="3"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="4">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320!n,pj/B>R2,ZAq0Y6.\mSh?$H'm&6gfZ8D)6%Hp/X13;q,Gc5s%h
H'K(>4<keK;+.ks,,.b=jtlp0uV_#m\)p\]A*-!#f"ro]Al<[Q'<AR3:;hlWE5k\S"&5Nf@QG)
C'+S4=/7!%fm*\h'h;>"6[#2]AKe^%ft;aM,t~
]]></IM>
</Background>
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
<FRFont name="微软雅黑" style="0" size="64" foreground="-16776961" underline="1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</body>
</InnerWidget>
<BoundsAttr x="411" y="58" width="143" height="23"/>
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
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="1" color="-15388336" borderRadius="0" type="0" borderStyle="0"/>
<WidgetTitle>
<O>
<![CDATA[新建标题]]></O>
<FRFont name="宋体" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Background name="ColorBackground" color="-16377030"/>
<Alpha alpha="1.0"/>
</Border>
<Background name="ColorBackground" color="-16377030"/>
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
<![CDATA[990600,720000,720000,1440000,864000,864000,864000,864000,864000,864000,1008000,720000,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[432000,864000,864000,864000,864000,864000,864000,432000,2160000,2160000,2160000,2160000,432000,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="12" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="1">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="2" s="0">
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
<C c="2" r="2" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="2">
<O t="DSColumn">
<Attributes dsName="ds2_finish" columnName="RATE_VALUE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="1" r="3" cs="6" s="1">
<O t="RichText">
<RichText>
<RichChar styleIndex="2">
<text>
<![CDATA[ ]]></text>
</RichChar>
<RichChar styleIndex="3">
<text>
<![CDATA[${=B12}]]></text>
</RichChar>
<RichChar styleIndex="4">
<text>
<![CDATA[ ]]></text>
</RichChar>
<RichChar styleIndex="5">
<text>
<![CDATA[亩]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="8" r="3" cs="4" rs="9">
<O t="CC">
<LayoutAttr selectedIndex="0"/>
<ChangeAttr enable="false" changeType="button" timeInterval="5" buttonColor="-8421505" carouselColor="-8421505" showArrow="true">
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
<![CDATA[]]></O>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
</Attr>
</TextAttr>
<TitleVisible value="false" position="0"/>
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
<Attr position="1" visible="true"/>
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
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
<FillStyleName fillStyleName="目标实际完成率"/>
<isCustomFillStyle isCustomFillStyle="false"/>
<ColorList>
<OColor colvalue="-12475905"/>
<OColor colvalue="-16713985"/>
<OColor colvalue="-12491265"/>
<OColor colvalue="-2575873"/>
<OColor colvalue="-5160449"/>
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
<FRFont name="微软雅黑" style="0" size="64" foreground="-10066330"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="true"/>
<AxisLineStyle AxisStyle="1" MainGridStyle="1"/>
<newLineColor lineColor=""/>
<AxisPosition value="3"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
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
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="false"/>
<AxisLineStyle AxisStyle="0" MainGridStyle="1"/>
<newLineColor lineColor=""/>
<AxisPosition value="2"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
</Attr>
</TextAttr>
<AxisLabelCount value="=1"/>
<AxisRange maxValue="=if(or(max(ZBPF_KJ.GROUP(ACTUAL_VALUE),ZBPF_KJ.GROUP(TARGET_VALUE))=0, len(max(ZBPF_KJ.GROUP(ACTUAL_VALUE),ZBPF_KJ.GROUP(TARGET_VALUE)))=0) , 0, max(ZBPF_KJ.GROUP(ACTUAL_VALUE),ZBPF_KJ.GROUP(TARGET_VALUE)) )*1.5"/>
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
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="false"/>
<AxisLineStyle AxisStyle="0" MainGridStyle="1"/>
<newLineColor lineColor=""/>
<AxisPosition value="4"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
</Attr>
</TextAttr>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0%]]></Format>
<AxisLabelCount value="=1"/>
<AxisRange minValue="=0" maxValue="=if(or(MAX(ZBPF_KJ.GROUP(VALUE_LV))=0, len(MAX(ZBPF_KJ.GROUP(VALUE_LV)))=0), 1, MAX(ZBPF_KJ.GROUP(VALUE_LV))*1.3 )"/>
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
<Attr lineStyle="0" isRoundBorder="false" roundRadius="0"/>
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
<labelAttr enable="false"/>
<labelDetail class="com.fr.plugin.chart.base.AttrLabelDetail">
<Attr showLine="false" autoAdjust="false" position="6" isCustom="true"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
</Attr>
</TextAttr>
<AttrToolTipContent>
<Attr isCommon="true"/>
<value class="com.fr.plugin.chart.base.format.AttrTooltipValueFormat">
<AttrTooltipValueFormat>
<Attr enable="true"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0亩]]></Format>
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
<Attr enable="true" duration="4" followMouse="false" showMutiSeries="true" isCustom="true"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="104" foreground="-1"/>
</Attr>
</TextAttr>
<AttrToolTipContent>
<Attr isCommon="true"/>
<value class="com.fr.plugin.chart.base.format.AttrTooltipValueFormat">
<AttrTooltipValueFormat>
<Attr enable="true"/>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0亩]]></Format>
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
<HtmlLabel customText="function(){ return this.category+this.seriesName+this.value+&quot;亩&quot;;}" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
</AttrToolTipContent>
<GI>
<AttrBackground>
<Background name="ColorBackground" color="-16777216"/>
<Attr shadow="true"/>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="4"/>
<newColor borderColor="-16777216"/>
</AttrBorder>
<AttrAlpha>
<Attr alpha="0.8"/>
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
<ConditionAttrList>
<List index="0">
<ConditionAttr name="条件属性1">
<AttrList>
<Attr class="com.fr.plugin.chart.base.AttrLabel">
<AttrLabel>
<labelAttr enable="true"/>
<labelDetail class="com.fr.plugin.chart.base.AttrLabelDetail">
<Attr showLine="false" autoAdjust="false" position="6" isCustom="true"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
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
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[值]]></CNAME>
<Compare op="1">
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
<FRFont name="微软雅黑" style="0" size="64" foreground="-10066330"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="true"/>
<AxisLineStyle AxisStyle="1" MainGridStyle="1"/>
<newLineColor lineColor=""/>
<AxisPosition value="3"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
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
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="false"/>
<AxisLineStyle AxisStyle="0" MainGridStyle="1"/>
<newLineColor lineColor=""/>
<AxisPosition value="2"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
</Attr>
</TextAttr>
<AxisLabelCount value="=1"/>
<AxisRange maxValue="=if(or(max(ZBPF_KJ.GROUP(ACTUAL_VALUE),ZBPF_KJ.GROUP(TARGET_VALUE))=0, len(max(ZBPF_KJ.GROUP(ACTUAL_VALUE),ZBPF_KJ.GROUP(TARGET_VALUE)))=0) , 0, max(ZBPF_KJ.GROUP(ACTUAL_VALUE),ZBPF_KJ.GROUP(TARGET_VALUE)) )*1.5"/>
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
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="false"/>
<AxisLineStyle AxisStyle="0" MainGridStyle="1"/>
<newLineColor lineColor=""/>
<AxisPosition value="4"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
</Attr>
</TextAttr>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0%]]></Format>
<AxisLabelCount value="=1"/>
<AxisRange minValue="=0" maxValue="=if(or(MAX(ZBPF_KJ.GROUP(VALUE_LV))=0, len(MAX(ZBPF_KJ.GROUP(VALUE_LV)))=0), 1, MAX(ZBPF_KJ.GROUP(VALUE_LV))*1.3 )"/>
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
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="0" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
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
<Attr showLine="false" autoAdjust="false" position="1" isCustom="true"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
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
<Attr class="com.fr.plugin.chart.base.AttrTooltip">
<AttrTooltip>
<Attr enable="false" duration="4" followMouse="false" showMutiSeries="true" isCustom="true"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
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
<HtmlLabel customText="function(){ return this.category+this.seriesName+this.value+&quot;%&quot;;}" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
</AttrToolTipContent>
<GI>
<AttrBackground>
<Background name="ColorBackground" color="-16777216"/>
<Attr shadow="true"/>
</AttrBackground>
<AttrBorder>
<Attr lineStyle="0" isRoundBorder="false" roundRadius="5"/>
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
<Attr lineWidth="2" lineStyle="2" nullValueBreak="true"/>
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
<ConditionAttrList>
<List index="0">
<ConditionAttr name="条件属性1">
<AttrList>
<Attr class="com.fr.chart.base.AttrBackground">
<AttrBackground>
<Background name="ColorBackground" color="-12491265"/>
<Attr shadow="false"/>
</AttrBackground>
</Attr>
</AttrList>
<Condition class="com.fr.data.condition.ListCondition"/>
</ConditionAttr>
</List>
<List index="1">
<ConditionAttr name="条件属性2">
<AttrList>
<Attr class="com.fr.plugin.chart.base.AttrLabel">
<AttrLabel>
<labelAttr enable="true"/>
<labelDetail class="com.fr.plugin.chart.base.AttrLabelDetail">
<Attr showLine="false" autoAdjust="false" position="1" isCustom="true"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
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
<Condition class="com.fr.data.condition.CommonCondition">
<CNUMBER>
<![CDATA[0]]></CNUMBER>
<CNAME>
<![CDATA[值]]></CNAME>
<Compare op="1">
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
<FRFont name="微软雅黑" style="0" size="64" foreground="-10066330"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="true"/>
<AxisLineStyle AxisStyle="1" MainGridStyle="1"/>
<newLineColor lineColor=""/>
<AxisPosition value="3"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="64" foreground="-1"/>
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
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="false"/>
<AxisLineStyle AxisStyle="0" MainGridStyle="1"/>
<newLineColor lineColor=""/>
<AxisPosition value="2"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
</Attr>
</TextAttr>
<AxisLabelCount value="=1"/>
<AxisRange maxValue="=if(or(max(ZBPF_KJ.GROUP(ACTUAL_VALUE),ZBPF_KJ.GROUP(TARGET_VALUE))=0, len(max(ZBPF_KJ.GROUP(ACTUAL_VALUE),ZBPF_KJ.GROUP(TARGET_VALUE)))=0) , 0, max(ZBPF_KJ.GROUP(ACTUAL_VALUE),ZBPF_KJ.GROUP(TARGET_VALUE)) )*1.5"/>
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
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
</Attr>
</TextAttr>
<TitleVisible value="true" position="0"/>
</Title>
<newAxisAttr isShowAxisLabel="false"/>
<AxisLineStyle AxisStyle="0" MainGridStyle="1"/>
<newLineColor lineColor=""/>
<AxisPosition value="4"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
</Attr>
</TextAttr>
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0%]]></Format>
<AxisLabelCount value="=1"/>
<AxisRange minValue="=0" maxValue="=if(or(MAX(ZBPF_KJ.GROUP(VALUE_LV))=0, len(MAX(ZBPF_KJ.GROUP(VALUE_LV)))=0), 1, MAX(ZBPF_KJ.GROUP(VALUE_LV))*1.3 )"/>
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
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="1" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="1" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="1" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="1" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="1" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="1" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="1" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="1" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="1" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="1" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="1" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="1" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="1" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="1" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrSeriesStackAndAxis">
<AttrSeriesStackAndAxis>
<Attr xAxisIndex="0" yAxisIndex="1" stacked="false" percentStacked="false" stackID="堆积和坐标轴1"/>
</AttrSeriesStackAndAxis>
</Attr>
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
<![CDATA[ZBPF_KJ]]></Name>
</TableData>
<CategoryName value="CALIBER"/>
<ChartSummaryColumn name="TARGET_VALUE" function="com.fr.data.util.function.NoneFunction" customName="目标"/>
<ChartSummaryColumn name="ACTUAL_VALUE" function="com.fr.data.util.function.NoneFunction" customName="实际"/>
</MoreNameCDDefinition>
</DefinitionMap>
<DefinitionMap key="line">
<MoreNameCDDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[ZBPF_KJ]]></Name>
</TableData>
<CategoryName value="CALIBER"/>
<ChartSummaryColumn name="VALUE_LV" function="com.fr.data.util.function.NoneFunction" customName="完成率"/>
</MoreNameCDDefinition>
</DefinitionMap>
</DefinitionMapList>
</CustomDefinition>
</ChartDefinition>
</Chart>
<tools hidden="true" sort="false" export="false" fullScreen="false"/>
<VanChartZoom>
<zoomAttr zoomVisible="false" zoomGesture="true" zoomResize="true" zoomType="none"/>
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
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="0" r="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="4" cs="6" rs="6">
<O t="CC">
<LayoutAttr selectedIndex="0"/>
<ChangeAttr enable="false" changeType="button" timeInterval="5" buttonColor="-8421505" carouselColor="-8421505" showArrow="true">
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
<Plot class="com.fr.plugin.chart.gauge.VanChartGaugePlot">
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
<Attr enable="false" duration="4" followMouse="false" showMutiSeries="true" isCustom="true"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="48" foreground="-1"/>
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
<HtmlLabel customText="function(){ return this.category+this.percentage;}" useHtml="false" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
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
<Attr showLine="false" autoAdjust="false" position="5" isCustom="true"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="1" size="96" foreground="-16713985"/>
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
<Attr enable="true"/>
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
<gaugeValueLabel class="com.fr.plugin.chart.base.AttrLabelDetail">
<Attr showLine="false" autoAdjust="false" position="5" isCustom="true"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="80" foreground="-1"/>
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
</gaugeValueLabel>
</AttrLabel>
</Attr>
</AttrList>
</ConditionAttr>
</DefaultAttr>
</ConditionCollection>
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
<FillStyleName fillStyleName="仪表盘颜色"/>
<isCustomFillStyle isCustomFillStyle="false"/>
<ColorList>
<OColor colvalue="-16713985"/>
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
<VanChartGaugePlotAttr gaugeStyle="slot"/>
<GaugeDetailStyle>
<GaugeDetailStyleAttr horizontalLayout="true" needleColor="-1" slotBackgroundColor="-1118482" antiClockWise="true"/>
<MapHotAreaColor>
<MC_Attr minValue="0.0" maxValue="100.0" useType="0" areaNumber="5" mainColor="-14374913"/>
<ColorList>
<AreaColor>
<AC_Attr minValue="=80" maxValue="=100" color="-14374913"/>
</AreaColor>
<AreaColor>
<AC_Attr minValue="=60" maxValue="=80" color="-11486721"/>
</AreaColor>
<AreaColor>
<AC_Attr minValue="=40" maxValue="=60" color="-8598785"/>
</AreaColor>
<AreaColor>
<AC_Attr minValue="=20" maxValue="=40" color="-5776129"/>
</AreaColor>
<AreaColor>
<AC_Attr minValue="=0" maxValue="=20" color="-2888193"/>
</AreaColor>
</ColorList>
</MapHotAreaColor>
</GaugeDetailStyle>
<gaugeAxis>
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
<AxisRange maxValue="=1"/>
<AxisUnit201106 isCustomMainUnit="false" isCustomSecUnit="false" mainUnit="=0" secUnit="=0"/>
<ZoomAxisAttr isZoom="false"/>
<axisReversed axisReversed="false"/>
<VanChartAxisAttr mainTickLine="2" secTickLine="0" axisName="X轴" titleUseHtml="false" autoLabelGap="true" limitSize="false" maxHeight="15.0" commonValueFormat="true" isRotation="false"/>
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
<VanChartGaugeAxisAttr mainTickColor="-4539718" secTickColor="-1907998"/>
</gaugeAxis>
<VanChartRadius radiusType="auto" radius="100"/>
</Plot>
<ChartDefinition>
<MeterReportDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<MeterDefinition201109 meterType="0"/>
<meterDefinitionName>
<O>
<![CDATA[完成率]]></O>
</meterDefinitionName>
<meterDefinitionValue>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=d3]]></Attributes>
</O>
</meterDefinitionValue>
</MeterReportDefinition>
</ChartDefinition>
</Chart>
<tools hidden="true" sort="false" export="false" fullScreen="false"/>
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
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="5">
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="6" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="8" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="9">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="10" cs="6" s="1">
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="1" r="11" s="0">
<O t="DSColumn">
<Attributes dsName="ds2_finish" columnName="ACTUAL_VALUE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.SummaryGrouper">
<FN>
<![CDATA[com.fr.data.util.function.SumFunction]]></FN>
</RG>
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
<Expand/>
</C>
<C c="2" r="11" s="0">
<O t="DSColumn">
<Attributes dsName="ds2_finish" columnName="TARGET_VALUE"/>
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
</CellElementList>
<ReportAttrSet>
<ReportSettings headerHeight="0" footerHeight="0">
<PaperSetting/>
</ReportSettings>
</ReportAttrSet>
</FormElementCase>
<StyleList>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="48"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="192" foreground="-23296"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="192" foreground="-16713985"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="1" size="128" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="88" foreground="-1"/>
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
<IM>
<![CDATA[e@Tp(e'%SHW^[(_$\D?/fO[]AoTn@rk;A;t/ko_)m+9Vs57R3\)$QT9md[PagTgcQ"ctbrl+G
?316Oc!BZd7=ip35B$mTo:pp\g-f^,,B);a6meAtIo0dpb>SG@]AUFI4X!QC>R[R%fk=mDuUL
rOT*Ekre%A%q]A:Z#e%Bq[.qu`oE7/GPn#=]A-?Yu>t=D_)U05Rb,=Z]A'>iTAA&?\e#mE4<FI-
di\9ZZ6DcGE243iPQ*P:7QRNI*1--OnmGt^/V!!K6<NpJ:eQ'YAd.d5B1jBl%N"S@U8?h(j^
K:(rRB.l=YUS[n#EF27oXAd^X`&MPp#"/Sq"]A=m[RmEm8duolP#4LUKd:9cfOGog+FB.]A6Jf
k'aPSkj\hOM/>/ngSh%heXNXE&%]A+L<>2J3mH1%9d2i&12\l:t@<!43"g4V4imRL<F\8h(bY
B;nT@J&or9IiVB$Jf-2W=]A9rZL/\E;YsIk*J`o>NHHQ\G1<(SWG1e9@3t2eA1;K'A(0:p.P"
7W8MIBCjVPSk2+cNh.9o`HXFAC!KG@Wh[F!AAD4=O:%"m/Qo-V\NPt3T_ht+Y>2e/07o)fOq
rKUu#H^UAfulp\eF\$K@saH_HIG[3\r-B,B<,D:Ho/:@.(U)S!&(><&Wh0?NAYteF?$%M)*;
^\!V2km\\<JTp84Rs/LElVEJl4;+m2eSHCq[;DUo0a%+X9Or_-S#&W<F]A+5kX5b+>+WYtqoC
"9-^XF7.#Q"5!tmk9DV@\bf`s"kc?`^8B(^4gV?M@$96^o?!Qu=iQ2:[2tB&^ugZ35RHG$7V
"tcVA&_ss!t1P_E`n?jNcT7'n6!A#fM?ShoE`$/O'#u(3V<BjkOuDpGY"r<oCT*]A,J></=Tj
+L^0O4=#Oi=qB(f2/!Pc.W;ar]ATVIhj6<M!K?0Z]AbQ#V^G2RDo,eIeA\MKHsW9\1JBJ_!##c
:9CgiA5j4s-/uXkm;3'[fhb^53O*^;F^F0ID<^POS<t_]A@X;KH4#m+M[R60p@DNa*)Ls2\PI
?WWs8X7(ub*]AY!^mH7pY:EB,jR^,3=F0V<P1Li$OK9B.mWWZ7gtSIsq(0[#HC,)0<]A)<diP2
i<4#T5lC1).\"JJ+chI33L*q3Jr./GCYoOUCW0]Ab8kPV=]AbZ)Di^/,lZ=cR8VfP2I`:`1b*b
>"EWr2E$KFrC4lq8hlWG:]AcS"R6QloA-B9H2&Yicq/@Tn]AQ@qQ?XC"j\k5nl*A2RV0F(f'D`
-#47RhSWD7-7m.magpL,XkfPo0^IsJ061on$7!R>K@@$p0]A_rV=gMV)`&9C#-k'>5s_3\&<*
YjuaJoBOj\J;7!4HQ.!,WUDC(eX0_GPD:]A:h[Ep]A?0rt"TC:lkV"`_G#>3uK.7C0IA2Qo.7t
11G"Fi+l&AI=E+)#qq`e6_>QfU?m@77ROU^Cf48=e*/Xp;.jh-LJj]Ah-OEu#hXea`ZLLNDr/
j5YEQ)l!>d,eZS1ESbf.MuU8S_ULH(63b.SRYgol>?FMTMY)NVRegB#r*[Xha!\[I)qS'=!^
5`!rYdni<r9XSGf"Nh<K?+]A9:HTuHpSOArl]ALe^^3jsBjU67<ifprc[1c>JtF$T34H?64Hco
AV]A^IA$"1N&2mNb#71qCfr$!"tX0_EbkSE)`*^u\n!q`K9>k\3EiA&!d:NLR<EhV#2^5(10;
0=HbiW/k.IuTV\@mBN'qq#ahJe*P+43l`R`<S3ds(A.4!)L<]A05=rja-r9G?J=bY:JSH&\]A4
-*I94$4_'blT58Z!t#EkC=%QssY%estSj5WR3p"jN9$sIO4[DiP:s*m,9UmLin1F.(gr@anG
@VS-#]ADB9%*1-Yt//o+_h"X,%bffd.a\r"S$\boD4K_]AaaT#U7J6QCWJ0aE0UC$o9_`OXo7@
p9i6+\>^qgU!Zo+%9l^rfA$@mM+/65L7TVMeasiUXA$s(6H:3K=M9S@>*a;I$cB"K;(*$,lH
0g7VZIoD*Rcpj.2`iXMS*g]A7Deg2B/rj[4&/V-[1QLjp2E,Z)T,!F!qHVk#hG&.aG"M6<#7K
r07sb2;NnS2j+j!s>n?:IN168kYKZ]A=_iaVlM?+G94hdN"<ol2UAT3/!id5fL`F@+JY'o^K$
]Ai.=gJ(^=bIk4XF6_1H>A(Dk+$p_?%$p_98,IZR6q.7aamkNUan]AT1k'=9@*QcA(%OlE?gtk
>]AJmLhUNt'3+qE^Vb6+seGFp9YA-Hp5QADb/>kc/c$(p@0cqlM,\EOs)1K=l$2R_t@Hr+R$_
A0oT(e!UUlIRajR^LBRK%\;)JQ4)Qg`(Kia3/VQa)Pe+0s9Q!_=dE8/XtojJi.iKD6Y@FZfF
(\ZSub+2@e>\m9Q^YRV1arVsbJho=G*ik]AQ%fLU8_mt@/+?CqJ=..aW>M//'*IcFC.re`UAE
.E?&^@>QFSbgCI@f%)]AI[8s7K/(gW8@BU=rRhj7,!s$/@ukbPAtoYoHb0pc[T`.K#Y&sOT*0
PeK5=V\02488W:p0$5mp=B55thq0j%!1kU>BF0qI"OGkR1QLNsa"^--NQS;l11_'<Y^)9=VB
fMFPD'k,e7^Af!(g]A6\ac(;RhL6\P.,XIFV:Z\sDps%#]A=5KK/!##.Mi>[<ume6&hO&@j8E=
^6_MpbSem!K0Wmd_'A&6@VX=NOUGD`4+iA]A7KS)LY^rA;3k,5+@R&/TYPQBM6VGo#"Y.>SHk
\ji\Y3n)US?:7'Zdaek-=9n]A[+4MRt?&?P_lMNKGUq?'.f[N`oIfh:gC`=-V&%9ijJh,8?SJ
mi_&2X0m8QsrcMp6;b1=U%fgW1KIQG4hGAn:ntgM,*4q"CH6$7&\.[_3f_Nk7p3k>+YBMSmC
H4mah3@YKprq"DuK1l3QRSZNS'L9>XClbe>O84r2h:UD7,jLl8:pMl+Rn%;=n8XpO^khE)ps
rab%:Da,]APEZTs_c/nYqS5LntecO1/^X0!XFA9h;5"c[K?MEo@cr:8&346Q@>/pODii3^5K6
8=C*he[F#j9"@Qo=`pCiBm>.?ZZA=iG6K+[-Gj\2YL'3^-8ZCOp:*UUSZ(8<!Fe'2M+jY3tq
<hJE`ac`)&XmtTB+";b.e0@R3X'=.n7I`DlR7TpL=":=D\]A;GR;\peQ"DE9g"U&-1_p*sfn_
)iDRi3)m6-dNnIN!mrQU^^R1Il5N,/G9)Bj-06]AFe`P'5JVa,3qU7\IAK:Ephm9&!dNYk!UQ
4]APXSBR26NS%5@:T_Iu@<(]A2KQrd%93;kUu2I88*Ks*Vp^6o0FD4O2#>?6C^hr[`HnT;mu?Z
$Dr&R"k2;H^;L.:OKnh`%,/t)=emjPIN'lA62<9@f7AoaQo54@$+,>1agJ^]AQ[5V7Z;]AXnEF
Bod4<MbUL`P<m5G1aE0BuCiOMtAC7Na9.5S>V4HR'W1G0RBE[VU]Am4KD&_Qr^)=?Ri#X`t$g
Mg\X-//$FJgR^^#na4`]Arqjb65Z*6._#N`1Q?Y"+FhL)`t1ihUf@"7X/+'#g]A%F.d3?kkS$2
$-p!<'&8ngco%u355o@<7Eo8pU[!j%I!fUapDX?*UYF!&tnS=LaNZsR8VN&'Y9/h=ihrINTB
RdoAf@1Ho<d/)9&C`IHT@/\Xeib+p$PFfk$a44>PY6[(#<hdfm.cKl`:YT%QeM)`o+oABh=c
:PcM"="J-XE(kd&@gTU)q^#L/k090l3%@"o0#F^1`+!2+fr&(ZZ#m;C6EB+3FC=fRm9/Ij!<
rOP=i.",@+lKX[3Pc%eI"SQJcVjhDFpZVe"lk"2W?tHDE8iLT#&uRcAM6'^q60mLu`>FC#[@
`p\=nKV\_H7.EB[4[+k7NT69$JoC$42i'HY'8<)<S2c!2e?b541457NlLE(`^AS</G)"(Bk@
r/Zs:i=p2Ft$JQS_1D5Ias+8Z\kYGa-[eYA8T1%pr[uA!rBgK]A^F!*XnoX5o_BBf(2%1hDF1
;d\DhY-0A<8NU41OjZec$BDTZ*ijC@/P2luf[MqO`;.S@cL9FD`(R\s'R6^LS`3:^?.q^Cs5
l(*XDilRWmp!5BX`PG,+clLtl2!Z$rqkZ3.MBqT<7d?uCIsO3W=EcC"e2I4u^qBr%Z2O)1s,
<.KU5oJ&i*A&/nBVE+O85Fq'C"^6l%XtUnGpiXH_+Erm/NPipA%-1KQ/2d[Jnc(FCEB&j!q-
3Llb9)CL5RHGcK:%P?]A2J@PL)ZZR,Rt\(#^#pucSq;+%^Xs,>`4,rITJhZ=["\M3LknU\)!E
ktjnoR=UXFmVpr[g9R!G]AO(ab5@;gq_nP]A_G/><hXFod5Q4ZdH>E4CA>a'rJ7jnjp'5q$5d.
b.D+c2W\o'qpQ6"lPZ*7?Y&oa7b423MaOqs0sYj[`\`g,`W%Qc4[kr$6+?2NG,d*%VEg+SMU
8V*Clj"C@%^NN(5FM.]AG8)GBk=r5pm1B)g&_>!##_.P#YDZkM+n<ZFo&W!sm+gIq0-lU3]A4`
g9MF2Rrg:\J,q_o:r-i3Q%PTtae#ecC<^E08hi+0Z\ToXgL=9"D3HWP=OmilXVH@*=\i9W)Y
.W+A)Y-hDa7&$dKjiT)ZMjD!+VFWJdug_^"N/`HtS&tfb*Ikt5Pm,brD`09C4s$aY/(7DC<3
=)]A"_A0\b7!QV8"pE"]A-Dd"+M.MqlE_]AH5:+'_rUQM"7o.XOQH&7Ltp;Lp,dfm'PiVMF[10b
2\LS"oi'`<n,TrOmAF5h'TV9+QV#U)F8FDb(fHIbV;D#@\ZeSC09I=L<:Q@!ud/Sok#TZ%_d
26HbSD.4]A,9Fue0cFPs<11*2JZ;>DRQTi*A4ugIZ)Y%4SQf7+Pl]At^/7R(^QUZS5?aP"q*I/
[c]ANO+olBV2j.i/1!p6+W<pULc\@`pFJW4?e2_Ri4j2V#TK\`#;SBhd!#=1NAb]A]Ag(qQra`)
MfdJAQ?hR*GS(L/cOYC1B.h16qr!f:B_"pBoP_=DSF&[H[D(R0pgE=ega:oV?*16T,W8\jJT
.KeQ$[m!D3h<fI=NKKqi7=\hb2Tk0s3FgjkZgi]AD'D_l/u\7aDqrA_M7-TskD7l`B;X!]AYQ^
N.\YBaC/Wp.Q9X^QJC`Fjc[XpLh_-5a[<`.<8]AM%bZK'?4sP$>`l:3/d8nGK0=rtMK3UOSXF
]A.IYTO\,<,E`O,IVFhsOQ/#Ih(d("9d!::\r[)r#W`54(HSi9DE1TR6rOHTK]Apl3Dbeub'Qg
_cW,jg"S+.7aL]Ash1gP"]A8D[#KJ1."4YC)OB&SPOFSraFXYZojf6/51O2Kq\ji-"%@*d5O:6
e[6W#W;SigC.%.cB+a/RJ0jOD&`]ABe$Bb?_6P<O2^oHr@VO.@lZ95eV;(g\B=c3TXETQ((8a
W]AaVlIA<;%)q"l;lGRbKC%f[?M3'r2WPc#3`_oT:O1$9^3mn]A1[`&.[essD<h6MFIZfE"9[@
YGg$"Zu#laDGZNVYhpu!-eH%+(_nZ(5VdV4cjUe'K8Vi-*bOdi3YYK%mK(CJkRr?)X_=c?K>
YJ&agr/S$E\*=s)OD3<'eqLUn2#!hPVi$9G-bL3Eo?N%.g?G`RM4IP^mF8cX>ppHd_*@U"V;
)kh)ML/_i:k+o1;'UPH)L?_No?i2$/=A.=RX7AGfKj.%Mg]AWk)jsbMmtR/gr=5q^J]A'KWX$-
0G%I$uUGh0uC,Mob=^BaKlfULUk:'lfrb@<'naP'r,h7E(:gAgagF9N-Nuc#'@RF-9]A9hfl'
pR\&+dLV*Q)@_HMCS1O.n3MGa0L::X:k)7,a5XngcFjX%3:-WFGbiZ;NKh]A4I]A,GOC65lNel
#j"?U+4kVoO9ia,.F,--P,]AHK4C,;"ng)e3kpZBE-uEMYlNftaALJt)FTk\:Ff`d>Q<#%!nW
M6c[H=>A1M.HB6@D\Xd]A=>4$`V8_:,#BA(LIKl8gmfrQg6R,G.C&OUf0OMZ:A?ut/kPgBQf-
*af]A6r&m?"HR`9):1JPru9&[29]AtiX!_#Ob?O<n6CSs_p#YAdX5KB<N<_Cd]AXKk/&_9I79kh
QbGp'A.Dj;iD"I$Vk']AH'.\oa+qm3\`f+[-U7fK5\WZ('MAl#0LNpDJA3a^X[@W&nH@(h,.b
t]AfY8#Hdg*m`Zf:+R(YG3^-un<%F4A%uQ;G0Sti%E<qiH7&A3%P'90Z2:`FF_^je[Q..60(.
P1X>YuC:[fJ[fIOg0eU\APaqd3gkP++.I!jsiHG,;?gb7DZ:PL>^2)^m.[&&roF;aY@4D3G,
I2Ma75V9J$UaXW4-K1-@1D\4]A='(Y0?)Ng*LW)EiQM,XH@4$H/OWXneQ/(8&kV)4k\f01OFZ
$519$<8s9oVgZ\*Db+nZrgr3`&7t0;Mf!@<2Zh<f`>W49mh+6/XO'EA+2jC2Z=W-1`$)_<)C
.qSiY9*g6u?Y>>j`&6J[WA/XiIJnNYF#F(!c7g:#g]AB!apM)6_LhCEkHXE*,+nItfL(_@W5<
gni`i+%IK\5@)8*e)/TC42p8V;P4YQ*P7?<[_olMbScFTOlk7VF)!NGlb=^5AQ7:EtRlqPVU
Lnb`-[!q2r@\9Gc8/`SKh2>;#:+W:W'NCWmSM\Wn\gATYg%Q>s5e>u"bb1NcJTTKSfp=hs>,
N2s<'ZKl'`a-n\G52F5C`YJl!8%4D7khIWT>_X+GQ$jR[^;-g1nmbD^G3:YH_Nj;JJTo6Xm\
8&0j9!p-&Cm-_(IM,=X*]A.+WpD*r[@KpGNG36lK%NW_"eqqHgTG[s7X<L^"IXVPY%^"9B>p2
kL><<,QV#Jg>g14-N_,*,D"oJ#Wu&\=6NS.pe8\6J8dXhK.4;tofuJ\H2u(A8**/.h7pde8#
G`E/Rf]A5R<R;M^ZYfcpc]A62$AbH12T??^u=`7c1Y.XDAJoUen'pk9ES#8:#d?;0k?e9<L_*,
U6XJG%_I^HLRk0G'ultES`\a.>QOE'e#LXepEqYKIN:ksC#XC!ib3E?Lo7a>B[Q%*@Aa@?HK
K32jU9F[ESL+l$TB(=<L$6/bjh%f9CZ%$q6ee-h3Vn^&e0<Vr7Fo:&(EG"6(]AnG0<I1O<RV8
SM7<mDbnN9G,5`S>2UAMm761u\Td*(OupGFHRP;0+]AnQ#hUr$:F:#o6AA#%g1@EY*@qr:nhp
OaR*J%=iK7Z1ou17Ja@]AA>6j<E;(k_j.K;(G;tEgil0QM?W'^W7$Pr58[&D*(I^$Y[.]A1:#%
qr:5PTdKts'`9\A%Hkqcsgc@*?l174]AX@GU/58oo2HYoVc9PPPqBgjg&;(@gj@P+">=5!>^%
=>V>^t0SgHIk%L0A8K>]ADbSS]Ao55hL/`l!f1p76AeNFp_07R]AR.$D,>5N;ej%:/NEuHZo?8t
,+%']AGcO=cKWRt[LlJ!n4(TgP7\R.VrP*PuNhrEq0kV2jcU@GdM\:N(?2EpBJuF^sOYP;f\T
AN41s'9FJFK5g'e?L'h(GmY>;SA<Wo%p?k+7'\jQ>a\#:[nq#-\::mEE(K)ei[*r_9*Oi4cS
aG9fE`JcA"n-tuKq,n?dVJ^@)`Pt]AW8-aJcJo&Mh[8^tn=qrs[9d@]A1Z*Y4G7.P$F`o1SccS
VE+b%7L49bEHK"6JBVJJfE*k#">?W2GYDDcl#_ceurtmBFgsL2D(Ul7nK<CEgbSm%\HFH0DC
CbV?`me=4&+N1;gQO<KuXY"CFY0cVpYR@>lHE8nk@J^u5W=A7pA<A9$D?)>m%e`R<LeofeW_
nSoms_dI0qK^B!;3fY\=Q+_CUj]AI8%J&fLV=YW^s)##U^$9fhS-%\OX`)UN9X$E:8f0CNge&
)%t:Zf(02hNi,1dW%JQ2l1urd]A>gg=?59r*VY51<5e<Ddg%7f%1M2+u>'JCb?.d8o<-L7OuO
9I:4/U6@hk)oVC1-cMG(-3cSd:hS;mF@!1YWnZ:")[s7S>Q)6j-PWI(=S*-P1?8"JG)KZQhC
RjC<Y!e)8-/+=Eh@7ahEu?1V]A5CnEBjYNkY6_ZneJkitr.SIg(WnSIW4RU5?e"#]AR#:`g\>@
k7>2li(ikk:QCI]AsCZN.;GZC[<X/.HG4_Gj7WiF]A?--adqgr1=D2pk#EG[I0rY^f$l?!r[rj
Ws,)P5t&(6#2YHjrmm-FVreSSrht7@m`_nfG8"[NAUS6e4g(9*q;COfQplTJ%jTAHB$&'Ago
(%Z6*-^/]Ag)'d?M\`.q&7r\1e)klS$&seXV;G):4-BJ(mKVQL8T!##1/Xr6tJ[H%uIn+`uc@
i@Nrb/LSXFn#YKWY)#e[j.rYWbgge'7I*fE$I:IZc8/c/)?DmH@2LSXhhgD6AdqiR_/YPEkA
XXFWDL:]AsDLJ6_>U%T-2/T?&iO$rRYd_k2>b>'%a&n_PgI2`[CZHijcl":opLdM\GA?7:j?V
`eMuGTC%fs]AL7c`/,l9hh*(n%@ThTch)g".ju&3H(AMr[:YRu!!j*U6*;"D?#c&!+36[B#d/
KsEkQf?m'H_N9TQXZ+s@o#QA#Rs3\9$9,[3(fmrEI-o64Al?VHo5hRNCqrcD;`1,NIoq;Hr[
."ar5d[!#U8^>h2^n75ac<H;Gepb&/uL;)7'q?BSGK3]AlkuD-SM!hG"cU^&LsKmFF2W(ej;D
\\LFZr(+NgK,A,@H6W9h%/%fU(auj5)*6\mE&;-YtZ_2>+34H&\Ql?a+#$j,(j"R_ec4f8)5
6$bj]Ar=>CouC((<cdW0at5?8oIZ&]A\240#:_j2=FeLN9B)3k=$BAAQB'sJpn9oe-Y]Aq[a2tW
0@N/[ZUg)UYdRtLo4q0O3=;"T.W<ls8FC;V,4(D*l3l_5*j(1ni.@!@"!2b"=Tc(`m>;l;J^
MIord.Z9:0dX:`r(VIc636.oYd9c\;ggCjCO;CJg.if[b&cJ+EcV]AN5)M[1^Wq<DBJY5)kXB
a?B^IMelMC^9dD0p%hfSdS]AnYkD,pr6.0m?4+"+G?(IV:a`FX+*^-&8Jd:/htcDr>n_Z@:e9
V/7,JQ)`W;(HSn/a!95D&(K/I3Oi2h)<bl==A:B)-3J'gjS53P^<M%t(7<\MXlnM$,>&;L_6
A+MVWP,uNjMD3eV"c0#N5o2!,8k_J2=lk&_t&*Z7*K_jAWFb/[Nqg!6$!k.-YX'_I79Q;=5V
]A)o9krib<G^Rrat;I*4.tE)MdMRAN&(a63#L'VCe,X8Qml_SQ@`J!cT.FMo(T_q@RmMmIO%>
\cs_W<0\j:0q0'kq"r?CeU`4_Z+O.4_4+I4jmhYX1H0"HfT0ur"E"ZVlVKeuBh(l>jV(4O"6
^iA-t,l?SdP2^<L'%cVQskN0c+/fL4+]AHQ0')@VQ=lm#T8!>W%ECj]A!<mr'j:+O2gI=hlc9h
8UqH#KJDVn*8VUh]A.+QIN'_!5ZH<5g]AeWO%Tnf<pYp0'V92LOo`H0/b[;@6gm-q\_B'@?U3O
)/)l3EZ&?@*."iYqXd,cf1"mnq"'r&4$uERW`i96mQX<'C4M[6t"$D'SqtKr$)(<>SVCuo0.
,@KL*u7YJ>jiAp:1&3*R3jaYdUUBpU;u*$UnM[)F$C@^FKsH&pGg5UQgpS"rFVWq?UNeJ%A0
(aq56q-2QY,q:$K40`1#Y7sOQWC=5*o13fh0+Rd?.C)qTE-r(j1cj$[PCg6C98l*d&a8aF[+
G=Te2qrR)(:thQ.I7*IP#bHVmtp0T%3O=YsB18d1BLKeD-7)<U9rZQ&VtuTcTgi*>KZZ_8pu
I0ZEMDQ$'\R1=rU;1ZDh.1R:2_!O0]Al?+BDn.@Jrj%,@9'BdiCK]AZrsG$-7XS.u^,=KQuI)=
n>OH!*0;0O6-XiffF5iT!p5H;ouq@I_nkmMgm[F:HO0I"A<E<%`TYUYJlQVFOVt(:Kmk$dae
3#0l^m7l]AV#tEB]A&cD=[s;]A'`tl;8#A&79j&9UiNI4BK##>32r^a9GZ,QC[77TWI/1&o2qZZ
O1Csh5P0]A_mR(VQg6O-J?K0Ba-t!-l]ASgXQPj5aj@'ark/0f)):lLL..+ok_'M)-6J*B!?d&
W1:Eus+Pa`Jh5g31UGYBS[fr"ecBB)V&(8Z>epoC4#c/e-iU=iqrV^qA$<!M/7a"Zj9Kg4cZ
96Jc@^E>Of]AQ'V"N6CfnB3a-R$%'PO#?6Vuig?P$)M9UEs?tW$f$,6p@&oDo-$+d5n;%lh9o
l[#%Id#V!,Ke3nkR@47Ua[!cFG3&20m3pHdN:6fNeGNCmR^AP=[dVZqr)j'@7tr_0Jspil!q
?"GINEe\C4RrjS4-M;,4#!eO3`R<GFTcF=%\Z4A&fVK!1ZXC]AIRhfaM,U071ZuZr6;G*nVC*
MYX<%A0'-!o5m_6>cBET#0p3$F$,>r&'W5lij;`u1moKDg&dG4<(\g<o+%,AJ$]A?:D;V+V(T
MfJ'`F2+hW,h<f"uk/YGq1pD1@fBUJ?g)nl0roAhC5B-e&L8>)`,qFj_i#K\]Ai*2glF6d_WR
SW+fH%g,mT*G/?\naascZojR4C/=ZqP=j65sKq;$#7qS+k&HZ>t[W=HSGdkM\_+XAB^=!D&6
3:[[)dI-B.aVG3Y^-5)/%t.VG91ZT*nm,'DDPqV>f(s5NPH0DLsf!c[.7orpXFL<&*"00iRa
1C-'T%p0nHqQarj1=Aik&&,_WhN7#Yt+Nq)]Ab1>$(^"K"0u$0:0UV8p`cbOA']ATQTh0l`RE,
k8q:f/Dcf0jQ4rjU1kNqC\gCP@=qV2lTf%?3NEIj,*LKBj.Mh74]AGJd-=Op9>VKWE\@gNt4g
oZL__5b@N%joi>c@_,^=1EC4@nuJ?tfnFp9gBNk0;]AsDc0rE<T!S`U%MRn"E>>RA%Rla=S'J
ObK@M3'iPL^j%u9u5A;(*^R[Q!7J4\c<b^T?,#25S;p'nP0l,*lT:2&%ZiXo+A-&k0CU`/-4
#`4QXHtuIS=GLX0f>!qYlmXqaC^\`NStJ0bA2l@\cGL.Y/bg_>m$ceQ&e/^oKOB<JS$Z:AaF
Z/UflR#9Jlqe;3b0?HrFoCe'Ut,O*L9@HUR[^ct',@H/4LdYj@/'<jIk1C]AUtNl"##B,*=Xc
jWTdKpiuPgUiGDZq1d'DT%;LTeDilQ"_.(L2`Ge^kDC^DqV+1LI6+mPJC1d^,.b:JBp6tD>`
5`nNr0CXF&F8ekE:#/'AZs5.<cC?IF@,7<V)Zrm-#^6I(FfK%\ik9?]A_5'K@F4>BAiMBMQ:a
3qh^rIe-aD\K46%qpsAkNhTHq_H\O;k\^@V'.b0G=o3JMCIatfeJ.:.9^6Vcs.u`5n-gd'.m
ae!%2*-sGi=qI_]AiM!Ne5,Qiedi`Zh-ERL(-JbNIsRfm%5'"9Jf9hd0-!h]Ab@]AHZT4oI4BgQ
&?U\7``q4!9#j*RDef;kulH/oh!Pft/)D4RZYfUOqC+_nVE/a&@:DsRK2&BRV^4lUpdP>.?o
2O7R9`BWiH\h1R$d+S!V$d@PT^op8Ab4c>G0pBlagI4e9\[UHJaG$.H5G15\ei(seSKd6M_R
dAs%D)`D4UZb3Zqa'UJ+61dT)#1aZk.gDJ?=RYm.R_m;*.3.<us6ACF-sh+-G]As;oJZ?>.bS
^;4KsQI]A9b7.FLUUkmKq^-11B"X1OM?JCYEdH]AC<VAOJQI,=;B6`dE]AmPn`aoBQ%"jeiZN#B
dH3ZROCqac!ph+$2s'/??8[q$k5V+'f_t@f^<,IX#&T)^%hRjQiM=WN.%4Ibjo]AB0F)_.>r7
S$L?b2,3aEc>h9d8YDOn.'`U7X/[rEq9a2`DFfU@eu;2-mTN0X-IK.YfY0jii+<!TA`;DAoR
)T7E=K>-ZJV5'9T=dW=6!+uM]AR?(\O.;`/%7n@gAdmK@%mKd;/cMlU.`ZHN)OYB4p4YAg=eu
`o$JMY2PAQIFGi:o,?ng:UJIK-&U3+*cmf6.rX3IMAq>;6Z%\9@KE;)-O<ZrYp*"lg$g5eB!
%<O3;*Vpo'LO=\/?JJhp",HUBtS2XcNXDqKO+$oecoQ8ec<g"ShPj2jPXNJbt2<G*CTm9oO7
D6VN#9IEK2E$fnTV5BiT^Q%$b`?!j6d"#'<3.-NeEgNhl35,^.dF&M]AQKh;7AnYXD@#TUYPT
519h&4@X1`>V=n7*=7g/iar,MX9l$0edo.V\@r9#1\(9!DuH?5u/:WWX'c4u4'5jME=hV+H?
L!&4b3jHG.nITFj<;_UGY2EV+'SA2]A>cOeoq2S9mRn`d"@\,$u62Z$H^!?N3?qWo)#d<6M/l
TQs%#JplMeAFj*FTT$4L0=E$nD_h%1n^aDPNEuJ).!8`e2cSo#$/+i`%:m)c!VB$-oaYY?-5
C&\ceo]AMhm/<O2GGOH")O(.ea]AHO.)Gb>/&b-_$aO'W=at9+4_kO8I+`I'``CMXU,gK(G4tF
.o-dRc[$+FtTq*VFS56q5GHhFgfOY/-E"iPtbo\hSa[RGBIl.h"T)Lb4ZOj3.:mn`Y=jVK#I
m8lJk1E4X(NUqY&gOFBg,eUm3`G7b[Z/mp+rVE3\7N"dK)"l(m/,a710l?AX+,LYXC,aEfVV
O6XPOq+l,Bq3#O-6!<JKT*H(doTZ99`j3n<&1bp6L1q8??>lC[D%F"+rHoE*SCBrO6<n!oM"
,UhgU74b,r_%5b*WU;Y@<pp4f3)EfQL=C^[el$=h)&G:25m]AH!_!39iT3TJj(/]AmI&]AcpFj+
oa2k)!U=C<RKp)SofY0lfp*\2J:elN,3jEaaOuQm!m]Ai&6G&3,+d#f.bGC_8)XE.8Kil&G6c
Y,-:FC3[qI#?7K%doXp-hR^soG'IW4MUp)Lu)D7Zf'-n$c<Ydj"8#I_(N@65cZW']AlqZr,+J
$]Aa3_9LkjE_5p["XQl=L[%mtWn)lMh?-T!IiG$TB5>p'NbYRf1WF\H4-"UfjtZ$j@kJGtD5#
m[nQI]AOs!n";F\ep)Leei`SmpdVW.6?/"F?m:`*i%6$$o,c7Q8mE1uM"C>VeP*1dP^o.<qL\
q5)O)qs,8Ba<Vn4K@&aRCPUYKlj46\"fY;ZU&$cIVck@`n"':a+mmQd^T5&0#3!fnF#$,LsW
!5PtQY8YphHf)![t%U/5T$\^S_4>#%H`&>hmlpc^;5iQ+O:"8jLeXkr?@rAg?d`Kqq"C^mIc
18Ud,DD$E"?UlJ9,q9kUkG1INf6adClV<jeT5ii-i5P"!??S:#okmYME9'(86:Q2&YF!Tle!
;YmT8En/<t:VU2@SE/p34%`.7.O,>8HObDrA7h<:?]ANo2Sq_3U.^$@=k7DANDJME'SJ+L]AE[
!7rllXXlaf"ZG9TOkYit)G,TCcA[(<e]Acl.KuH4PaIa@9L[@GWENuJAF4^ZjjK^]AQLc%aEkZ
W?TWc7EP_aACTN"N$j-Reui4k']AgP`kN/@@^QP[b6JF'37f3\M5I)GNTXi^>TgV6k:[??ZDd
pYaXY_%MmWHE+d6\drQik0Ug"Ln]Aol[k*TPRKYV(J4+\6>L$WaUB#g9AZg2JhZbHQt:>P:'m
'sDE!:+CR#^>(mk2U7*C+WC,1cX/BO%qqe;iJuheu:#7%U#u9M,TW41?hduM,7/M2V1l8gq;
'.APQ"B+$Rp0_!VfX&nDaS&dGQ7:u<)(.AdcATMV4YAlN3baebGl)l%"bhhp6b;aa%7*Pkt^
,j1<W,,*5=oIj?R,B/Ou'WFY?QBd&@SIE6.c/@kE7388C`W%nLSHUes5#XRZI1K=f6-RJfp[
_upP14(.^$!^a,K8&J.`4U^2'U;28U*Zl_cjA2@oldQZHo$B0aZ?tT6!]AVLthUg#*PM$hMAo
mfE><6jL?eqQXG[DZ-F3Y#>tAa'rPA!>8fgCWHjMP<Zgl;ZYoVBNG:kmpc1N7d6-4:fH&-NX
t&uJFjJ5fRc^`%QS9sr;d*S8nI3,qPRO6_op@VCrmpDC!VL_o>rS0"41*"hi&VK`<b,O.4e*
)FJC4p1%BiF*-8J<0Cqi"&0st+cVk@h)fRIJZ4qg^KNTXrmeb-,,@/NPY.b*T[`M!'LVtJ4,
5)5o:YlqTI&,HQ.L3H2Nc1e\F"tdH294u`RR,'4K7-qi$@PW/oi6=.Bi1nSl:D&O*5@bp#.k
,P\<0JoHMB*fgb0!Wq4K$Nb1(WUceld3#&>8o\MR4,fSbsT+p\emX7H/nKQQq5rK5J-$S9W[
Va"Q47^iA&O2.n@?%<Pff@.&lu.t:q6.o-&jbiJ'aWUI"Yd]AW)G%Qk8^^Qqi^<,po*b0EC7m
.;`+"35b=-KTWgMQtgV@Rs;H[Qfl\fGi/UdW!93pm)>eF*&IqDpbRqG@P^\lXm>glDNu50(L
2RF(9..pSm19/84Qapk++n.\T]AphRqS:npIf:=_IY]A5%LR=fkbdn"!L9M-+5ggY/GpC%u;IS
RW1P07C`bol&1T1mMg8Q<uNXGN--'712IESc:a8?LUIW\bWDuKPBhD)BbQKC3bR[Q#bG0L,8
nE(Co_5bSJ`9_CL_CtLU[B]Ac`aT1(roCG(>c"4H!rMIo+dfBnf9..[4>D+g?ShtJC^uG/.Lc
7I!3a#*_$G!I&^<+hNXh7AH(8JD9P@$ErBjG(-]A_EC(oIulY'V_"-b>&d%1UMrf'Xh.F>O!Y
_e0cD%A^kT%I)Sp%R/@=FZV'h'<JpDpJlc5[bo7O\Xj0-]A=9Va,dfa/4#bY4fBH2R$KbQcmd
6Re1Ql]AkhX3nYr7k2G;>o8DU[G_b!f`cTd6dV$(e>J`=KLTn\&h\(NE]A;+W`@[6!Bi\'eKDW
M+ftE9h8Q")kK<QDNZ)Lg;J)Jl(hAMahKHY%a0Hm?IASIZMc6)HfmdpR&"Mk@l^YLD?0X?o2
,+#8)5+$F0aLh#!H1X*oC7e7es3B0VAc)brkdVl^Hg#W.*!cH6":5L`1%,N]Ak/SW4ESYW$2]A
mE4[IQ0kL:DG'1Mn^gi_s]AiN&EX!^GkmERPr;bYQ-/M,eJGT!?G+hR<`Vu9k8Hei0M).QtD]A
@%ZFZi7rG=Pb<CHTsKghUAQXbRc`P)g85A9[sc'pBPPB,?uha[&$E62#LK'@pl(ddn)7>FPu
\,TVMfX5F&QGO+b>!g5*qE(K^49YF^kMpL'U3MmdSK2Ao')(&+KHOsR#kag-cA1W,encLN<-
;7+dGGHPTC=G-:rPQn+<,]AWj7NN&i18Le^CX+N#VWbDiTC2"^+.u>RCe%@S?::>Y^>2SFGGf
QXT7u%J<ZD*TcBf:IY)i%0i^aDNOP7hN(=IFfk]A!O:2DZ6^6iWPh`X`.kB\m`iri)o*j^3[f
[MsBmc8KO\@^C6rEA`?F7U6TYS>/ee*_PX-Uet^KcFge]A/b<maXG+.+9Y6(j#Zu]A_QlEW7Jk
6::5'<4%s7OqM(oi+E6PF;cs>'gQpCaAI-mkOD+lF*('5J*-`9JmS[r*mBqlCWG^k!GHSql7
@rbn47'[9CcEZ[TbGA$XOJ5!u9(S:?^ns$YOr3Y+SGI+)gl>%#(Dmf4As2="?iTIdQY9?I<2
OJe=:?RX5/<7t)l1m59VWMM4T6,IE2Q/[X$V+g[<Z^nL@:M]AINO?bS7crk/uhY*s!k86;aqk
VQlYC<l("]A3IJ$gUMK42OVUdHA4uTaE`L"4#.^jmXFo6a#YM4`XC\o!@ah^bll&XYP9*:ACp
oGPJ8j[`[UT-E;)4+QP*r(o$_i;QJ6EX"-7QFgi5P?jcZ%(CF(^dp-00i(Bbk#'Vkm43u[eo
+@!_Ag=sq?++)(T&@5tMc<Btha;Ioe*@c;JN?$!!^@p3I\Vn5^-;*_mk8&R!\/&]A`'P66"GY
J)QiU]ARCA9?^J,jM#JufP(*V>N*Tk.&O3^&S=8*LN(<j-LN<Q7pLG`Wt_;pEA7aNN5(mbF'n
p^f[Yn:VB&fr)c!kYR:::,+K5?Q5olX0.u.>NjDe1+8%;rjl>Xik/lD.js6^Z'2`D^tF_F*2
Z]AdAiJqmDof"?dT-1^!<c2>Hha2fc<T!JY6d^_VE(Q=QM3\r?u1Om)E+@8`tAP51elbp^Z"7
U*Sd$)7pk11bT]Ap*#.eWU3h%a0i/:CQ<D2t/P-Xnr2C<]Af.C=`<TtF8KZGPlJ^J+;(:Cb0<Y
bTr>qn]A41k([$]A\)sp^0\QL-3]ADKQ(pdfXkGO5PDU\J(rn55r"^3QYYS;1]A]A,5*sI#ZcHOUp
1pIM>S^d5J@fMn)#qY'n-.6g(Q<4jn*p[R0U.O<]AmKgrWh+0qO=374Kpf6n?/$g$eD?moR5R
!P%M#*2G&[j3NR-P2Ac)WDR:*=/sSQW*Be4_c1*m,_;?![6ZO.:R#Y]A;2>J=l&Y%k-5]A!0kh
L*eK$F]ASmaeK4mZbIYd9ftB5M<2Z"ShDYnD%^[6,@Bn;9+m:QVodAOG4AG,99F3')ORE-:/0
ZB):q4p>"24GjjfVkCqV?4BE_n&&%+Y)PJi4Dm_,($YT</_>QI"oMUGcp(]Ai$M#5LI_&=QQp
*fINS"$B5f5FW1TLnIp1@)!3(&,/G@,9`+>sU\,A-udk_$7)U#'[[;TGMR*#4HA8h:n0a3cP
Fu+!")$$FtB"!MI+_*-.>Cmt3S8V,bin]A)dp*&^O+2/LY4i\i:eP4P0hoTFr)WeQ66BX1lQ`
!LC6b^D3bsUZ8SDB@lMRmoH>b".Htn/o2#dI9PH*JU`duO_1d4]A`qi3T;B8hIYX#W.lPX'92
VW!]A2Q/517LOQfhG]AbJ&hoBHGbg"p:2$2T=(56Z5!9sd^Ecu>,jZI#,9&t/e.Bk4MICA.dt.
HA`@kFLq-s:>S6CFs80>g$Vi%4"]A1Ec6.pD3Y;ka9;@9G!_[rUM_qFRY84.+bLLmGp4`\4KT
T#0p@[,nf56$naoU/V$SIUW]Ak(E0L>(Hr#2UYt,d%_06V0+Kr2\L'ccGPf$2"f7BR;K;t2(g
rDnJo:&doAlqpt#/E%:QZ1Y(J13WC"*.Bu?bupHsS=T7k2"C=:(0MNC*lM;pL9b.>\`U+IRi
#X\>m1Mj2Y1AG(M&W$#&B!g@M9%K#/=5)1cqN$<X,<n%71[,i3VJj,q#u<Hgd2,>i>Y1*sQ/
:9.d)je@+TZUd=R^AZ<F`(2f<dU@<GHRA-#!$?liF85f*+O=-maMP7g/*8+&98C$0!<k?51[
b\9Fk^l/H$b63Rl#09u1F!OmM=k^Goo3>Xk8I8Ah\.>.DcjbiPa9X4@AR$Zb#iECB!c"59sf
@$bn@X'u3\h""g?-*G'fKQFr"L&6Xn:aFGjuSMO"WaA%*#Cgs9QMe:6%N2k'N(MDbM44P!po
:n+D/h\7<IXn&t_SjID6fGb;cbgfF0]AYDBrjK-YQl&]A8j6*-h=I`1slo#".h'UD(e_4A+V98
,1Qc,;`"gu5:iaD`FKNQka,m3C_;=Z@1X'O:iDeq\8!$&7hI?^*@Yq\s/9]A8.*B;+<2l03=K
$&DZNXeJ3ZEb*TDdik7rn"amFKVJ=s4M742Zp&1W918H#"L=DSFbcka`pSmcsf8CnlB<'@8=
;BN.=mBE.[dl"<j8mat;q$Kao]AcIU/g#0F.RH+^krAOKH3=&[*!Y"P;C7:mrR\g%U:6^KZ)<
f'<\[["2^=rZAqa19fMn2">Z!=ng(Tuc#pKu]A=dM]AJ:@O76XiC]A-+>EkBP-oF[;8KI0&n;gG
^u14Z)hir5JsM+Zg1jD*31FWXu@k\JRY4L-!C>811@944S5)^I*B(JX$W,<"Pj;8*=`gRYIY
a5e]A[\#P34BO+1Fk<Y^>62,KR(_5rZ+RZ<i/Wa?$,Yl.HKLh$L["C%+hBhgEoqe^X8V;\\0k
KY)=nC0G#GO6i<@*NsGb;;?lGT[)@t5l!6'5#ma5]A:@\l[hjCPEoajik=J"ecTsb@Sjsc)%&
.=O,%Q!.*P9Y_0]A4^eGjI+NDT\]A@=kI8+HQYbuH(&eJRRLkCGUB;64:NTr&2"lkfVHd57aRp
PVuq^amoDVh/[HDM?I)>UJATNZR2DTc^EH4+aU!J5UJXC",C#*!8]A!gC2'1#`RbJ*VOS]A7,!
j>2WOn)QkEmLD%fP?e\V]A=(epUTKYk5T`)&2$88'V]AM=HKuQEbnEn3([*jA5<2bG5J<E3bs!
10%.D$"C1#cJ#"A>K&9#oofUU`%*,P++_=sb/fVoDbGU1m3Yajaa1BZ&oIW#akl3I_t.^4oQ
:@G*c(Wk`,=g]AW6:POn$sX`m;X.(>=p8uI=gmKo"kq[Gl9C3e^.")::(YEV(?O.0egsCjLCO
WXh8"45u38'S%<W3fuopP0bHBBMN8kVOuXp(=r%=r"#_.pqp87'^oJ7W$%e#7j'Zc(43Z*VD
,b,ble8n7==/@nFEAPRGU:?sf=D2aA,/sOS29H4L3tI;U0Z6/PVF8LU'Ot@p,P43N?*1OVmB
;;P"GdoX,@h-`b@gB'F>jJPCsR)$es!9L5"N%0M?f1o>:_>k6]A*D2A\c%C9m/F'nd*l&7ZM]A
WB4`+3Hi)(`BPP$0tI!=*MnPXINbWq@Ac9R%"$KLfMl5L#.CQSIt7EZI+K6ph7hukHTXVscg
"qaHJXr_^l4B0!o2Y-3l6jtc07FF5MsY1"*r-5lk-g!_,%g4g,gUrbQqMQD@dRe8on_.>Uep
KOi::AU/]A0tB*AJYTEfm[3"$^5/gL`3`<q^r;s'LN<_!Q:Mr0F=1C%'..""JO,]A6Y,)CaN_Y
Z`%t5pOMgR[1_#i%r<kDV=+%hRM;$8)T&mK8>T!!@5-7-%9-t_#Ue!:*^Be[pRkY.Be_fP*`
,<BVO,W>i4l5g[3ORBZs:uLT^T#c]A]AcC#!etH[9;gb^_"/qC=/(S=LWjBoaS$2F!XnA5YJ[>
R$Ots,XAqP;$(Oib2+&Y7&WO*Z0`Y6JRJEG,(Gh'nQeb`mIo"1?8ObpF[R%dm@4;YJ3>*:Z"
!FZWVB(/2n163Sikm]AVsEk)ogUHN]AHQj8J<>]AKc-r0_X5;WS704C35fTdO;4Jhe$$[C\E0T2
BVUm'dLOFQ$7-+f/HOqb#e"D5MWeCS3j-OB`iPY2$-Xd0c=k5Cq^^9(DiWkM:E-R:=iV-k&,
&"E-Dh?Ms$0RW4&6I[4.[$"^YJ%[/8&G,:LFdXPnEX;2#OH:4Atu*T9&+eBe,X!:NG:DYB0&
i[)]Ap"LGdU&sD"J[BHjR!G-om;&'1k`4<4;uP3:t\UIpkN1SD[Rs@4+^c0aeB\=F+q>9B9pn
5tO0+1XOqq"bol!)KG`RN\g1\"2Xf07q8]AG?;+L)EP?o&DMYgEA=$^8ibI(J2a74=`I!W+7%
86O2M3`>?+qNaihHN5!'dU:Wu.=WIabQ]AmH=g\W4=K]AcLDf-bo_=gdQ.'C[\)N>p,/RaokiH
$F[':?)ZpSLdAd+6+E_F@S25S<T"6gr^GNIpOrp+&$ZuZ3&X2t[o'!nh8)3jnGL:[?qlWK<b
MYPAGS:I.JPI)^A*`J\!QOQrfZ(_im.f?2-*=eOeQ4Q0%s.`$]AAdPTH>@r@eqVA=Wl:MV&f7
pgXB[G(oWm@(Edl![,)mZD\tbkNhf!Tg17\Jt=QnMuj%&Z+J@K,#r8(De2efDG;:A4hTNWUF
]A+%l?=J+oc7dP9kUFsg\,L9Ud9gt;Mja+9$O[j.f1+DUYEd%`9B;3Q0Qo04ldXr3'f#CsdW;
Z:OV7r#i?Pcd6pGu<(@tLa48!05:Gb>bLSsYe+888,!TmG#,=?q!5+0%rM%r4.rctdLc/@>U
F>.*?1L7ZR(83LDnB>.iSlJY"!8Aa&_I(h0F(T'`!dAM1j()_RI*cjseUulGJ:o&+mV<35Fg
jQM%EhL$B/F0X:#N1e<,lta"RApoDnHp5p"5Z?K3B[q.cub*HP+Gi["Hm>7$s#Y,"'DV1\"V
u#@+mEAE36d&H@>PR+N,)85`G.p_H9($I4GnYbq-\pd3Pkre]AiAX(gF\pJfT!I&V)gY9]A3tN
j#:#eQ;\"d+Rf@e]A9<9J2i.'9g;fZd:aY,q>?@Xoa1/M7]A/h4kf;g15Z>NN[WsnE5=r<uL&b
>b\#JJ`(eT]A"Vd$7&-''recm]AkH?JVYt]AkitcepnUKS5f/H!A-em-2\PYrO%LUX(+jouY3iZ
<T;A'e!R(C.;q;LVV<Sbd>WnisZ#cbH6IQiHp(L;mqHOf\NuWVT4NQp6=&oPG-TQCpX]A?;h;
)^h+H&ro>?SBV#2&F8&TA[<HiZaC+BfMJcOoedu0!:\-p**YY^RmDem<6JWUhNV*aG_TpPX$
rRj=3<OCJC[tdP(%gr>Cdc6f>Ra]Acdm\/:N;T6`E<[;sIl$^88/*:Y#_j+IGfKj<foIc__k7
4Mr4VmT'IufP9[(K9:A_]A>J\]A^1;CJ#=bdMCJLrN!jEdCNuAIHhlfC9W=FgW0ZJ*(ng!P\k:
'K_<n_su+0)RLjtV;KLB+;PlgPhi(Ll.DD?/;I_<&L.=q,RlX'hKp6/TPE4Ed^Wf>Pfc4[dY
L$kF2F.&23GI!!&l4S!]A9MF!c!5!1!%"+DbHGML\<M^[TJ^PI(PN9*P6D_nIEqIO\[S/2J#G
JW^-@Ei,X,_pm!aC9$XnKX]AT8]AqcVeP570TbJ7::"i2M_'tf3rroMoc`&1`EI=J!1qit$^k5
VPZr['sOE/p9(7XC>,.SSD?LJWi=6hR7*>pg`#>34"c(Se;HP4d+)uO&mGXLe>n,QkrKuT2+
FQaig\4g3:j['c:@rOSo[j(=:'>S6rTW[<J0m5enQW1M]AJ6+s1B<uAC(k'4d"kB10,dR3Xa;
n3BX4I-UOQn[:6qrOdH>"L?LUF1'kj$\qhcn0igTc$@Om)$;PA)DqX-O:u!K+"oO/1c>5jS*
Fq%aWu8></[lB.f05K%NHlZkZ>\+:CCAFW)pDaf3:Y+CacYc]Ak&r$ssZ/r#+SqZO=1/po;)/
If9MOWVZU$We#8h/2]A`?4)1jWca0,,ru@6985FdSg03bIPT.A7AUcm1BV\KN>Zo0>8YL'$-m
jip"3DOQ&3Q<HS(L2V+"*V5a9:i.ah,=G9U8]A$k,M-FUVZF-Ik)"(%!SL'rc,9/du"I6/GPO
A-H;:kFm+sIOu1:![<I]AmTA4grJc_6g]A8$o21%[k>f%)q7[kDW8-/lPPeZ3j2!.QY%\/ZXo*
\?\0T4*F(.-UHL@5:AW-uW`"1$'!mSNhjdl&L8.F4gjY$EWKF,mm=T"^g:qKlP)01ErX%a]A3
#^-/C#fp5u-,#4@-H-YY/q2hl[`ojcCP$k=g>NjSKVVA&YoMcf-/-4I1Q=g$fb`NMD'\G92:
#h;RLZ31d)am8Km!#i>g=66IOOKOt/0btD-Su(XR:i-9O9bbs/g$JiiZ0TG%HHLXA3mJp?I+
5VOYfZWF1BNBb2obPXSdCE`Jldp4Ca,*jt[\mNDkA(RG%552hCFd@Z%.nG&n>P,jN9]AfG7J`
!M)\F3<TIP*F2p@")8b8mr&skSl2:',d$rmJsPAj0iX5/(14Cj\:ph0D5AG%VU@=8H=O?Yh\
kn@;Qh^J6H:B:4E\PKAUS2Q6@'ZTb*a[sX^^g;H,5tYNk;MiWQ'!30Mq8KHPN0UeWDBlGnrZ
S^#Ss4CsB""&AI5'X7+cYo,a?E,HubddF%PbQ&mMDk/k9t6DG=<bu?.-EhZ:mj6ud'da)hBH
^!dlmdkiULf>q[Sm0U3LR5JbOC[4RNleM=^;<`0aX)\!e1I[_2,c$&d*_')@>haap0H4E5q<
?X[676DC%A7SNBL`4!r?23Q(TL*.mj1%DOEgo>K00F9fR@B+1BeFPR5BL>^)%ZQHi"PIGfg!
<ZBePK*%@sZ\lL[l27,GXj50ULFH,F1n]AAq./oeud+P/&quH\GRZBC;<W>o5kdfI"*`WS(.p
Li1St+'+pN[)4<'Bo-eS6*!<6od+A#B7WKRJRgYZ/i"g9+GDgnXjUm@AS`eEJ$i-W?INLOS<
c>K3V;[VZG1/g_5F/(V^@_a_r@(o1$rK["B1O_-Y0ST@DsP#>H7Ce;dW>fNp'PMA[)87EFH%
,o9q1$K6*ISW*iSEFUXq=FL?^@1gpI_Y@Kqn8WZ0J>=l#WM3+64ZmY+:5eV:OLh9^M]AN:G5k
)mQ&#4"R<'d@WY<%>EV5s?>hA,.?8h3mOo@DLh9E6]AKg/fkRcU.NJMHjp$<CbF"ZD?Tkl]Asf
FLLq`WqWr=06'&,E?06GQPAA]A;7OKubk0:_1YMPZM<[M"6u++F/-s1#gS;l&DX>_`flMc"Hi
-HE\V8=X:.B9RZE6<Q%9Pm=LC6ndqS(KPF%Z;,V8DH_'s:)[%"1*lUL'^3P@hf7<G\EC)M\e
JmnHi12#)l50Q6Lskkd<lg=:&n"gp&cKBLD<MUssR?P'<F*!d:*%P4i-km'CL0a,-0(_g5hO
XReZpiHVg,"+?Gdph>EK1]A&i24F=GDaoXSp!l3QmL(K`Q`XPt]AVe`\QQJ\8A_daV2@js>0"f
T\Ab:>O(:"?uj`MKDBtEPu%k"d?:-!g,iJaY#GuHo?-]AW>[Sn#WS^M``l8[NFUDpii!'lWN!
i$]AfV8lH/B[$BeikJpZMdN,#MnIP2IV;]AG5O0sl8iJCUma4]AIMCNBZlU-r<<elV'=ll@E%+9
]A?5WRAMBh)?dL9XlCc(FBHIAS&@p<)5GKm`$r!Z\`(A.XciK=;G51fW#0=>^>05eiej,,dNn
8]A=0E(:Ar#rE:N>U%pE/W%J-[u0&.NPT1>='U=%*0WGIkr^Jk`OF5fjR:`qM,hMbVYH$U4lO
.OibT;*TBc!)]ABF#<V5)Qp=Si>UH\)c@KhG1%bhVcoj*%G0o/hbldXb"#\O"*r&,?teUH]AYt
(8_Ug/iQUQeR>6`5*8$S6^ct!-\=u*_qWd/5HkoGC20ep3Zq:sFlp%5k%_C]A'WO2P//Q_lH%
G1)q28(i,^U.tV*e;]AujkZ*AQhcqJN;W+@j]A2?(Ah)&,$'*>p1oi-LOJ=fnHUbUrj/_D/=J7
)\BCW"R82b.b[C;CIF;$l\(]A`:42qph:c\#\qbQI9N<[e,Qb,.?9+h(3PZ.oB^H):1RjhtMq
e$1/TjA)P#KX1!+bMI4tK^:rY4=ne0oP$a@diVs\c4Q3n!W61g.I__M^l.E8?r)0ft<OO+R<
]ACul5t34ldn_(mbBjq`Q2F)r]At'M2GNl?!D0cG;*LfI<BVm3QUuYo>na.5JGIZ#egbJD/Ue1
KF?_--ua@KrB=OXZ)apfiO.E/.=3:4,2Ao-'F8TF]Abi[``F-E(q,lBImQk9s&)hD0L%c\]A1s
lgfIJMalj[4Mrkp"'Q<@-8m#kDt%$YBg;f&1aYuXnI%suG==[8c,bs4B,J/V[V(H07)Su\o;
9)LN^87Br_^2M".G&H2A!?B\?G/;!.H5B`80m"&lJB/L&;SGf3V0FpXm7E*C<Q67GiVng;L$
Jj=-JABo\d(mG&'>XJ_*2%EJ]Aem"qar/@I;?de\LK9%)b^6O-rflE[6b'3Y&AK\0J7R2Clt#
@p2&>BdBK+:O;]AHm85]A*V#-VO&FAR&\b&Z%HLDQ%jPddR25#%JkP@2%B1,!fqVcs<8<%`Y.<
-QN;Ho\EM`C6),Z24>SNNf#i#f9O!pJ,G3RZ14a[V\c`eFY-'A<#R/)??rasHP2;6L;NdK$u
6Q?`M.@#5IisCh!_,X]AApgT"Z6cm!_g^(QU<NK&ic[Md3cT$>i72Tg>fZo-WN:j01@\khSjp
[,4JZhS(kPn#n5\\JK$7Rt>[*S7Poua43[i8sG7]Aot&*!!qch`Cp_Bf_f_/s]Af:E:t-7_V@H
'^`]ADIqd<=*:rd9Nmt.D>-1"QAk_EX#f^JlS2S&Aa"M(GFA#k5)a=U8%A>dm@Q#kY!,WB(R=
oP9L<QTVr&*9(Eo'q,#ThW!Mj3`:$=-SB%Gs3cabme3R.:`('grGRM`riZPpY[kdD6Jd9pSk
Jc3TeJqONE,YrJh%]A:^eT_8VjXAfnB_Gf0gF_.L<@29K]A'XX1Y:>Kj5A4VTS*?6-O(L+uE8C
[2@`u;9BO6V3Qn/eu9c:6_(]A9EL6\AmW(gj1#"ZC:RG/P:<ik*[Ql5'6V7i;2#qfbS(0k[iQ
o/'c#^+e@hp0n3RTDQi[!]AUP>iFpoe?U0)10^S*O1S5>:ik>=IIM#B%/jLGEUMCi>#7]AoKFW
$9s@GQ[iCdNh#4[t`7(aVIEcrC0ST&C3Fk-(G>'eaW\k1Cj"1)\E91TMRL[.B>ck/)j29U:5
*f+:eN^-hgQE:S37Ip2#:^/4GOa6FT:f-hl!AE;^?PuA_Ej38AAD%(dU",NErj\6`f5bR@q@
idH8+k8:k-JM]Alkr'gF!q%[m5bI3t25"KWR4H!<h)D>/%WjfQQO.(i:MJ,H3I/*M3R<E#,'1
98K'_%0+@I'uh2$m#g(0o6T?cKi3:Q;-M6qbXA&Wp&Fpm_T':;6QqX<Ouk$VB[,?d]AmMYi*]A
n8NZa/B[WK$u_Kl_5@_Hd"<O%62lCML:PLbFCd?ZAAuTnlONJ;>++2U$55C=Yj?S#ai%g>t&
ps71c)ZEDpi[iH%46Lg[\5S]A5^3i"Q_Li7*b"6XQ4*uo,O$B7H,W5.&\[)?U(+ruYA^$>41B
M7>c9[UUk(-SsP=M=L8VR]A8YF$Waf896GR!LG=R,";NFKsqHL4e>ulP>W.ZY-I;Rd^Re5\d,
oq+-%'A&!"(P_#W59I31FSICTJ*'@=S[HRmQ[\9J-<7-Z:K76^p$SBUQ`J%Io4TL,2"/R^ni
6e7B$oEoU.Y6h+ISZ'K&_.3MXM]A+Lp/%BrhJXN`C'iAs@o[t%OB61LGcuGT5?Ph<PZ@GY8M/
04qS<8YPX;,EMi=P+orV`JE1s:+A,,(Saap`JE36iCsjZRTUTOE\,I8""kXU;j&'[,+RdJc"
SmZN8"A\-o*T%AT)?$uU5co]Au.atXS./u1.[(@X&D-IF7qY1`JsV$uA[h>M%1oc.8mn\1aQs
/7^\/u57SOu"-tPjqq>8!Vt[667KO=`1Ph>Vl>*aF=3~
]]></IM>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="623" height="250"/>
</Widget>
<body class="com.fr.form.ui.ElementCaseEditor">
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
<FRFont name="宋体" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
<IM>
<![CDATA[Cq=gQ>AsO+*i#[ig(^A`[4:n,D(.1h<E-(MC8NnoGAC9<fK1ukHW*A4<AB-YHNYKXN1]AimIt
$;Prr,*rf-C=V4O,t=3Tp']ANn8DZTCm<UWQ85a!<<,M$]AV(\!!!TN!$J3e,Ioho10h6j!476
%nPnV8GK+MIWAfIGq/qsg.buJdD[?^V@Amh]A[*QHKZ,gS3'"\&2@;:Co.NpP"D8t!PEXdc!8
"9G&m`9*DUTZ$![7q+f]A&Pi)0S'V2DYsDPF(0#+&bk05i-a6K1?I9qI"sM*`Ni^q14As[c0?
t]A/,K)9qWr:HhJTpM1@(cAg'I3H-VQ``s'-Ojd6X?;/S#o-P5(Xd>8sssIS$+VnWs4,F6=b\
MJ@0.d^T6E!;5HHZ9;onkVQk?7MC?8<)./jX8a)\97P\3T[+5q9CP4dre;j\mAWi.^Zm^Q39
!_!c%"WLnu8VR@h1nS.G?`F`GlTAO)N;O*RDHr-]AB-nXoG#,^?]Ac#=.D0Wi'':iNAEqdC)L;
C<7!Q%EnUIMD@+(ukM5U^)LKWIp2Hs@WUBWt3!Z':Z,%H/R@NE'/:O8.J).J2o+Ik.9jGISV
LRO&GC*e6omf:!'m[%o$Gdh^^Rs#+$PoSZO%Ij9c_0jrV_p7s,)Lb:ph)%PIL58WYjWO&O3e
b8rI9=9Ugbpu_Jq/VW!6VQ^jY_]A5&RYnH-bsWWr/Zr[M@NQs8Q?>%mVQ/nO$[),X_Y<\AWkb
o`QX:ndq+).X4c(rSL1kni?rIBq=!6Y,*$6MYQXMG_A@K0d'nT^jr6%%okqsP_;ae_kpKLr$
U9F[V^Zh[s=,B9$$R4Q"/"%@q!!l8OW9VF\_!-nc/%mV<"3-I"$fY@il"%6tr2kl2C)3Xm,(
)&4ibN$nEWHnPS\\'do[RpZEaqjpIn./tCB/=A&AaQui<<&htebh_cmrH,Lt8?(VX-CsiM'V
>iF*.u)K-YUHYT:VD==YPO<N*X9A)s&tt'6U8E(c*$qoaFLks?D7EsOc$@9s/HT^gQ*6%]A['
dSjW54I1n#WQ\QnP=;qB+ZoL8R.Z$U#bZA2/^fmVijF%?&f*F'/H;L8h+j+d"P(Zr/OIY>GR
r9miF4G4lq&!$QFX!Z#V>.D=1(OOrW=A.mRH0b>V@4S7PXF:)#]ABj\=[MbdA.MpI'Q`h4\Ea
IEe;X0K_I&ibOGS3mCs/Ab>ibnq$L%coQ'aoN4'[D9)Ebes$9(%K5NDq&&E0(]A(UIb6=F$Ie
Tm\ojC?*OCn_Y_i=X6!cRl"7<gA]AukV61E5P^`MIVS]A,LlEbcaS%<m-`-iQ:A/\q<eE9-gj'
FMK`+t3*EC3;`qFj[H-gC"<1C/lJ"C#WC9:eNlKCOUctQKLt?Qa`L]AiD%LV2o/u:#e/roQm%
198O#"Mqu+J*"B5l+C3-qMXQc&<hmFubs"K4Z\g]A@M5h14"4m@b<jh7Q1hV7jsm+Zl]AoXB9n
*]A0*%*8UIS0sF:SV0/\Y:K]AWMn$d)qRstnij(_4IH#E%dJM5f#%F"cH\Wl7Jh_(ET@<EiJ"H
FrA;&6S0OYIZt[f:ei1,DA$s47]APo@%8+4A+T5V<UO`eK['fIZ+sJ/*K)j.K+<*rh$9W`jsr
\s4FXd\\7Y%TGr\l9A:*-[LQcD9GmBQ-qX<??_<nTYuKF\#_4i8a2BLp<M;fWD;h&</!c^]Ad
eb(A>l+K>K4@JX9R>HS_PBZs>@!2Q?H7`WbT1MeSYT/J2(cT=ME[7!&UZq^mNZ+2i<^aFgP2
3hj?Z<=2pO.AXmcJh923^qSKtDSO^Uq@klR4E$a3W[n%ffX#,V-.W,B<m*l,"1BaR!O=4ah'
MUme9$#F!db&=kF^%I9?8%55G<FAk[&/lsT2#MaO1,eG[F+-N[B7TV0%ertK.VJ&:`r>a9dJ
M@`XLK6bclQ<"jAetW9bg$A)L-I!]A&blfAWg7L;gBjg)'jT+bEfGG7hiq>0LD[^^nEUbh)i!
"W>IR;P/S1ojU2NP10.i=c'p'mFmgh=OG.6Q;p"-'GN8:fU7Gl.Jc\liag#"/Ya^neCZs$bX
-Hf]A+ob;j9:(-/S?[4&%`T&0>?Gn3r^$VV<iTmG@?%q#]A>6E5n$g(@>%`-7Q,sDb%DCX^&o-
7!l-n/39Mm2$Ho8t7]ARKB^%]ApVRij#(2YlYAMfbpRKh1'+p<VV\"4b4o)a`sc_L4U)h^a+`u
afqsIjfJ_]AaJ]AtY\&0=PT)&93B06,b-VfnC2n$nZd[=st2RXlZ12XX8dRt.$0BToP9`16a)5
NOpa\Lf1Wm)pb(p$;!Q"c!Y^,a-"A:=`'H0(4\iaWBI.I/O<-tDs\d"dW$,(ds%A+pVmIU+1
uOLpQ-!onW14juMfGXeLgel[<DODS$_'sk@BH`1[K9@bIPFX$[3O-BP3@IcldM?-jYCGf/aB
%arSc1^?*E^b2\"Hmu+'WY`gWde7t+.&CjSFPuR?^M]A8M4UV**CE`qkEe?U>O\_gIs)"Pf)4
*2'=rS>mspn<<[;Or^+ba*Abo?]A;InlGJC,*D2g!%M]APBK(/72Nt4(A6XODgBSJVGc2\)_Wl
fAg\tZ/\e,nX="b,h-i.&&.M4jkZN[%Q[%f<Nu]AJHjrZ]AaQU_;`2038%_[2F7!>?CG($p(bk
;m^kG7%Q)*7nH;LJokrK%T3gT^n`DRVX$G$^^CQ,B^&p@NmYrBR2#/H3<J9uJ>=d3reEn^)j
NG_c+:<ni\9iPQ/R`"";^A--AE[D7:FC]A4kXBq;Nq]Ane2>>4EM7LGY:^Z?NZLH=B[Q'^kU*U
fX=2$9=GGilOq9.>\'_1$gLUnB1tU]A547&P^7hN9C6JlFH"tP2%J^$7L)4'\o=SP+Cg=<qjD
S>o#3sUdriIj"P]AYP!;iV!;/aZnX&o+=b21X"j9kJ#f+PumE3VX0KNi?jS+ADub=ChWS9A"M
NQP93B[grTKRS"sJ;+.aELgmGJ$.l3EB#A07Ygs7G7@Xl/?ok_re&egm2`0*Jjk)N?ae"/>V
4_;qTQ4O:UqgNorM$K>(VKrR7r[sA\4XpCX&\iD%2:B"db:VBaZ9Rf1bt("C(#(YKhRNS`BM
f761h1\l2<E(mOAu4\)d3c3f$`f[ip/(&ot<qY=\cCT537L_sk3eK!<S!`'9KOU"UD0"TL5A
tS?CqE5um&k`R'5+)jHlIJ:\"2,X3]A80^_(6QI]AI>1mk&u2-r;7.NkgHe*&q$o$JHc+hc,q/
R`/Ti(4*%opCDPY@kpTkIPK57e`TEegB1>9)bOL@I`crc:]AIKu_Se(;GoO=I"rK:O^BZRL!J
H0_5Oj4>`lBciTCld9har^(a+f[^F5Pf".>[P7MFaaq-Y_O?LajMO'>:#hG[/&1FoVs=o>I^
51$"J*QuX+bf6!l^ermosfV'gV'+]AmO]A>Vt8g/VF;l)pIr&M,@.D?q"p6cfQH:3V`Cc\PED'
Af)`WV?8tg8aA;]A&LL+Z+>Z$\HIE,7s*,4j"P_=8-*]AaZq><Y-.[<$AS]A>)`nVLc2d)h+NXr
m'ON-/0F$2$:\dj%CK=*sSa1YKSOh-2YYCFmS<Cn8'[%")tJpL%#7L>fR,Xs(X]AmYf#sc"#W
j>*41%-mWBHB+u&Rhom9s?%a_a1:b;biI11rck7h/==GOhmbMpU6)W\T-r?-FfCd$<urfjRW
I_R_Y3N2Okcir@704p]A0CStn.]A0cgh]AS/Ok=6rbMP9pm<ds$`G;*SZUc7?U=*MKD)hR()TPh
-IZj5Grid.`8u;R.nn__1Y71KF<b2blg?g&9Q#5DhQ$oTf@X2_K,YM*BN=iq<q9o`=@N]AD+k
L7)=JS$*6[`$>uIr(!'DK/:U6mOq;j>J3a2Y"TY%p!2^&P+]AYC0q;50rI1W3Xk5D_Q@G^q-7
)Iuga2`E"$go@eBUoEVINhEIm5n3q[Vt$]Ae3;;G5#m+H)YNR20Y'TUq:)<:`VQ>%!_0<eR.9
p21b_[IomIP^9UPY8Dnke$'A$hcaS(HI1RkC"?hXBZ8uYcKGfD7]A\t]A%5Nbu&@RkS`KC%ZXR
2biO]A%eL+NClD_8c;RuEF0X-f]Ap89FE,quVeV7WC2"1t`i@>l2%4aB@s+7:BZs%3qfQq]A"\X
Kg$5O,j7JB^Y5dSF!&F6@gH+-ft[$qZK7a87@6*`30q7L,Dn@4C@lC2HH_kk^Ah>SPhRD8sQ
[qE/uo6b;5C>8/!=+BWhnoDR!P%WOpL$e8DW4Z`uX;3S^j7]A1lKIT2?-c]A.78&m[RQ,d^%WE
U,#u3NBpYdHMELok-n&IsL:0[VpTq]AS=WuC8J]Ah(;4AE)^@ML')uD=@]AG.F4%Kh77$VkY"sp
66.d!j]AS!.s!'!i*_[=IZk8n@1>j*YBk"`\HBgd;TDQ_C=NUYV]Al8((2a2\*LT8p]A,B$j9Xg
DVZr;r24h':oOhI1dV/!V9spo1arR_iN">^@[_#CMbY(!=6M=GW/?o3SmYXl@f"!g\1jc0(B
nN$M4^4gTQBrb%Do/,<gE!bG7sW)ef)0cnauUhOF)"j(?O"m6G4.7?d;XHfi+bCHP9Z?E=YF
L.GUVAhjQ"J6SlO5&`#.^OY3qs28bp3"jBG1iMY8ZGF"Z3S]A$j&;.%%O2>d@1pe/.mbJLmEX
2GilcaK.I!2H+P-N\%H%EW;*\ll5IH'>?#ppjRNk([9a+)GKh/&+-0RdpBQ4I<K\_N>3gL\U
`pgQobMm46H<YL\?3IRV$@f(Y!AntJ<$\k0U#QNd<XaDshN^polaU\'Gpf]A:_T?N6V,4`3Cr
R^J@G#TWTRbsq6,I]A!f$'3*uTbM:NFkhbu??g-0/$c?sEeuFMZ)dP3T_OKWXU+%k&qh'A>PW
8)I=_j&XNZM&aS\,8Flg^jK*`L#i"d]AWs>N$4.+PAlNd.H==^6ko-#JGIhkcp+%'7Z8;LZpb
1.]AdBs(fi2G@G2YuF?YVmBt3Kr6IG[Q7":=A&)rEk%1lgUI7jY=B_*eX?=a3HHe^nqkH!O(e
,0%.AcfcZ[tYZps845Io+[X[3p+r_[h^kO:e((/#NRf6BY=R3AnW]Aff9#gh.a0\+!TG_N<A*
@tebP$6j3AO"fLd)3';3u-1dg&CDF39/PXQKaSGN?WHZ)XP:3nW9gWR8?>LDDFr6oeWlN!+,
V+9Ek.nVB]A("'iuC85!X0!nd,rfi(<SEu0<ii[NLZFr;;s7q9$'\mDe)0a`p`-EiYk#lR0nZ
G*VDrk!!*ZG%r2@67jM]A=KIqm?=H%%.>i7PRZk<7pqlQk!J(1p9p49fW)?:*(C6P"]A!NLIP7
3TBhn5CN;t+e,;VsGmGWVCU<@oZRZ49cE^2!Cp._@?WEchA<F6#oGA?ckaEORWd@i'T>C-0\
6^`OY)0=OLKXoCI-[5Q:IJZqn-9Zd2ec-?p+oXk9&jsQcj@I.n^DC.Zu$^2dI9)md]A5hMHc`
fBBii9(`fi7Jq%pk;/<Z5FrKX64h>4+?Fg&+>m<r@1_<Mm_$8h;L-sUOQ,bBA+Qe*L(5LlDp
'bBH[9>p);qamqOR?Y^'m%(@`H.EKG+XAMO7`VdYMX6=`:bUUqR6EIfjSo\(n=Hagh3Y``$V
h"mRB3iLCItVM$.n`cqCX@=>eAa\*<isZQMpH]A0e0"jT4V[pn#M1r.j!0EHR2`L>(HGOg^*k
GhT!::RrLV6S]AXk0J\S;;L>Y`V&<+\b_tT0<__%eX?i?5qY:I?*qRcM[?*Z&=<ieU$(j2XLK
?>@7dl)B2+EZCjf;EC`d5at#mZ3>MfS&I'I5[BdC4XNpL#=HVgja(qn+o1Jk&S!%1jsY_WAo
#ArA"Y\U?A_2DE@tIf_Yg$Y^=oE+=7Wn0)SWCf`_GY(A+Y^]AQdl!lHdhf<\j(098":WV8Pgo
NQYXu*>V:s`M>G'B;CL@kaSt*K.362%IuC<G"67>br)8[T&f3D=0<!mZq%;Q8fa8ZZU['MV#
3]AeC0$Jo!<GCm)AE?`f0]AqW70+H2Sb"(CMJ`Z=[XHX]A"B4tc;VUjZOj?ntCQ#r?3<F&Hjn)s
t,W>\2Gu=CN+3>ef5e3k$P@ca\:7gZIWh#Nc\8;S<2(Wu]A[[kp<gGt<VlacrfIIG]A]AN,!j$f
t^[`7!@Mn-6ssjrWRYh\;jQ!D<bP,Ba1H457Kq'K;aFf6_$Zi\_?8R"SO*9-lX<k`<@o*.[K
r9Bl<b5:V2VLRhd(gS93F/-lJ8S$lT5;,&Oec&E7uO4-b`aUgqH@o-?LRpK're7*.rZQ#BS]A
0(^9/:.9g$@8li%PUedicBhk:pr)B*PXnEnp\9hE91m=FC*qV*.TrJD%"?\R2.(.6PFVVUU&
DF$5A&!\C"="d,Y-Oa9t9A7OZXf-fjR$#gkW)'YF?r(OSeCtoM)j_jeF9!]AGtQ1-dqWV&H:h
"j3VO9C+W=aEo.VUOrtseHafMm-msCf^ftdN->0)@Acs(R(&V$(E0PJ=Df+IhVM_)iB2@Wr;
Y_\&,<_6[Km#jT%H-iLB0@*&'CqnR0g55<,Z\a<UdauN!S;qk6="B0-H5iB`b&sW.^C!O@c-
W*fC>^oUtM4MUMi0V8=DB4Z);BOXi8!rj2SB`eHsoF.48JMSBE>1b4-YLSggEq)_`MBRoDjL
TT05+BNngA>,L<XX7O.):psTVSAh2Pg16\NhS`:T8+P#%:MWDK;\Nq_H#Pia-O,3oHD=hS`I
Y6*o1s2l(QAAe;Pm8&,73*CIF?@p<onW&[1he(B3UM#:touHNXhSa@IqC.eu=TC<CBQ-cec^
./ANh6g(d>a(.]A-"rar-5b0/(5m5-FVIGE%IFka=Fc4b4a<U99@85:lG&="eNI1LpQonNu/V
j(M5'gu=jMX%^jK^gqVC=VR9ElN=*6c.CscZfKpKUXa"T)V84X[AJYBAZ:_'@(YOV576$i(\
[E4ZhiaWj+gY>9>!r^%hK_Nd^ST4\#)@8h[6bL>n9ikDqLIA*TS2D14#2D-E+JqZ]AR*LNa.I
'h9oSHQE!#>Dn<a/:X]A,p:_,UNjE'bWM,7#g$(fH[@R4aVh"egNe#;\&`IOJ[kSP<TK"PBdZ
KC@TMP\=i;1i^=q=I^/*9G`<7o]AP%m"K@\4uCqc>DT=qtY3[m:&Fo?Bh26eQTil9AoB4=)Sn
(3b9JMGP?.f,i4<qrF0t/5<`:Km^rd@X5;uf^'eFsBhK<_1%LHQ5Sf,lA4"D!6WUpM<G,BBH
Qc`Yk<#@!]A=1>g#&j,=EC%!J#+aW.'uq\p"roX)%OkU*426:<b;c=1^d@)o,8\63q/j1KILO
&K8#[HZFcn9M5gF30ILX=*0P6)\!Tts2^d9W[iDOh\+t9'86Ks/Mb]AU+^j;(f`V53[Z_;MEn
.rl"u_@?99]A\J'IA']ACUCsHs6j0HfYpZ4;859sVhnD^[GjuL&tg#L>tRt@.*0@b4"Us>l2&G
bJZroCAOipMf;_O3/gaZHE"@OnRd'MppRggH+NVLmT$(uL?L'<n6K\2duNUGd9r-6g$MV+7U
XDu09SYuQqW6,55Rh\UPI3cX^6Z7O.[41@%@(sW2Q%DlVG#JTZF.pp"G`m7B=P+V#UPT^a(l
^!4PGIig$HB((7A#1h*9,bk#gE@FTRPat=UrM6$j<b+@<^t8rTGf_9(ESXTbq]A&%&$<]A/6j&
o<d_YXZq.WV7fVSG:9^LE-fi8Nsa]A5gLq@;+4\,!Df,n<QXKNm=R)"2Y&T2:H"C+Z_dMZk$b
SKMQ%Da6]AjZaM09r?-%f9J0eEIZ!oZ*Im5o^*SqZXu+d]A<E%);Eo-c=mF6EQBC5<VC@WNK@f
YrH.@^&Q2jR,0/fQfH.[YgqULS>=`Rj\T=jaE2Z1c;Zi((u`'g+(;E;2M%9I_9><S&+s\\uE
]Ad_P/b%I!X]Ac3sFX+_M4gM.[=<?m8aa_c/![Mf?\Ln1'a*hE8/&1/^&j]AQomZH"=!Zp]APaZl
a-Di>tM"+QYZVVfnK64SWC4m>60U!s4n,uUR4rlkHfK9rZJr"ht,H,"=YT-HbuG1c!V=ASWW
K&Q+qA-/)g,iYb'nqZ&P#m`?+rG>#7gPT>1W-@8RtW)W0ZG2Drf2kfCTsLk:6=Ci5C,XQS_H
Y/uk,:)@iEI)&%_9"\&]Amm/^+$`OdHpFAcT\&Wg1Hm:X',k=09%Bj8adCZj\I2-S.h+^#94d
8<S_J9<;M_C^%Z_%/r:9>26iDoLuj'o:l&CS._M?uM2m4)NcMpC_GK[#W%q_I/s<Ag:NiE2#
:gf>S?^XHQ)=3o!;Mf"IJH*[+XF$,u;&^+V(GrP"L.S?nW/fHE'>X^V_*H?1%_Ei4kV2[WYb
h<Q0XU:$@0g=4a4ga60a^2TFqV+n#42,9;bK@qP!MeP]AjD2Ksg)%D2MO+7/[pp=jeqC042;a
&GWm!PpIpjJfTu!N'X+)(]A1!mhgP@>-_b^BfaY>hse/8=#07`/Xc#B!a@.aE6V/p>2rY[QTl
$FM7iU`JhRH%Ht2l1:S-=VWpF8i.$PC<7Oe?#a*LJqL-#2YN">^p'iQ9mc]Ang!rs3MWDi4-T
2%(<r>p^C#g<s_;=eZZbartB\<L>PU543O6?-%)b.L##=WY#pYqJEFFUa[G+1)*4DDXE4qq(
:c'sTP=[,Jl]AdIC9Oo/EFF+8#Aan=uL!XE`JHUa7,#B0J_*]A]Au<[p5`qPC]AOE\>4j@m3DIiC
R%YdHSlh)f]A\&+=E%<]A^$7Rn'ONB%iM&st3QM]AkSB=8!P<bO?<:cIlPJ#0%QEkdLbgS)_T6s
Gj2L3b]ACf$X:/7k;c6hmJHO5Lfa.ot"=-,biL3N/"rH,M5)dU]Ad'`D7b7;I*Eu:H2<L^s*'r
V:AD'aqV3XDSYr/38??=1b5]A@$KrQI*RK(La!QUj5HpLO&%8!g7]AgEPL9jVYIG![Y>"Ffkh9
:;A4iE-J+'[:E70^%;?0`aQbLXP[CV]A*tVKQ%7&]A&XM"Rp).O?fBSKkSPqK);t*^m3Nmq0Wo
JiFlY@i*+NE&=nMWBX^61j.s1(gDaSga"n816]AXKrbJ<GWX5Q!4#:Xna%pfg^%AHu=L4r/+K
@HY'T2Ws82e2#ep,OoiFS^AZBqRJ/+DY"VG-<Kd8T(4B?212rXVA"[:273Jh<:RpBYA^:jVP
_sEE]AW>Drt?3@2c+$-gs%cf7ZQN:_g+\6>`mdGQ%=DbJLZ;j<[!o%YdCi>-2/(R$3Df>iS<Z
j0+"$K@OGtce0&r/U&Y$OKguN(%i*CI.N+WKiZ_]AmrX"Rp=f2uZ^\,a^9-ND^Yj;iWHJPt%l
kS9591^no9*pjG18RM'&[^GX*L>0leKCtlLi2FFq_EEB6?'hCj]A.GYYT@R:NYO>6M$%me+-O
eMREqBp'E&4RJ\S%gd`tDCue#<Eb*UeU-:Kg<:W+g8CX'g2S]A>^PBs1gYHB4cn\\nHI!W-sV
?dR*k&B0oe6@V>56Ai;4)Hc5cUD&"aF<,L:/eWt>9[S_!Ec>.VW5RN=qD#<nQbV+_q'rSi>R
[GGnfW(M9fWqG3,$hS1(#.:ao0DrD^=kUS11bI&C)Bpbl4o$s*0CP1HREQ1mCo<V4u3W;"qW
5a/tK5at%=8Ie6;dtH&a)8DOqo-bZ-NokZ(U_G!]Aj#SK>p5GM1(We3aZq1ab<->:F2=b1i5B
Yh+:O2@*28/Yi9?HMgOKG<;j,=]A!EeDWg4:!)0elSU%[=G\NXt++MS*hM<VA/P15=Cei10p-
9=3n_"bE`rcnSEXZcEB;k`G8dGP&#LJ<;hbhFA;>ULJ5i8+#<6E\j[XCZUCFi*lLK]A$"H!li
!_[gi5(]AMP%W/0VIsE,a34gI2ci^dILC9:6%;+i#ok=O^FNnXZ5/sLGXuQt/2U7=2TVbgRl,
#cqh:g2BO%kb6AG\6c[=Sq@!YL'WB7`EbCLofVqIbiV-=M2;!Wo_Btu%GX6bFrn?dDrZc+?D
Z%s^2`abCg<`o73nnWTFrYHO=gNOCrQ";r/8Y6e%]AnWSk)g@/m>XE8@#NkIZilW&i#K@ija&
ZN>=*cLmAM3^*i23)s%mkH6UURV90.5QaE"*K4\:o?Qq#j8s'5+*gY1H>:H^hjF5M>?J^4ip
b,petD2=+#gT#>(7N'c2XY4.R!XC;(iQRP$7&G^QhVaJ/=rt5_eJM:$#O*'Y0/st_j9R\mgC
4(VRp=p"9#u;dCoZPo0Elbg>L+TJ5s/I"lB2$\komK$)N-WX6r<(FofnYN/P8CI^InJ+MEHn
CAU!*E5o'5"@[?[,Z8sTaYc'A?<[SsBDi,Lg-$hu4%[IO&XOV!3f)t\@0%iKZY[3Csb^!kod
CK&M4&r[0$;'Cc.rGkm924?cd4qq2ia)K.QU6%IQQ1ils$pfrQKN48eEjh7tis6*WH6%N:DU
L`Waj`a,`q[S7,U$Q<TTf9YGYrt9bQ0RO-*&F\g,:0rjPgX)8uka"2U77[IQ"H;UhTDO;<h<
qP[m=,L\W=&?/EC;XZ<FaAt@l&]AfQS44!+UW)?)a?Ede7BD2%&t@]Aud#pira)k>A@+,*7gaT
2ic>\N2*Z6-_gq2La1'j871;/QKh2LNpF,n.X<DeB%]AQas#1,B%b`d]AW]AWse?q>N%d/`k'sp
2'/,)H=4,[i11+fsiU2,:?Hii-PKlEWjFl6!),t3c%NM"XS9^uq51S1^Is'*]Aa*66ZF%,A't
(7O>PMWAlcJo<g!e%'Z0j;coh2HF?h_-+#=hqmW]A,8bU'oG3FHZpHi^OWGd#>?<soKF5GZ:"
N_g!T:`!.<OkX=h*c)_0o<&"qh#/?8PUaia++,3K^/<OKhhQjZ-UjH`psnpX_,n=AR&uZM):
9rPSKh;9C7H6CuhbaP*f1[XoG'285n(7QPTXrd+as:jLU7=NcXoJmT)noP>Vu)ETAYT2jRDO
h`9_(nF3KD5I1s``_e(>9DGS]A=\R/GL:fY@IqqGDA'oL$X6cT",/K6_&4p2l]A]Alc<Tpb0$U`
YLSV)idG-/)e=E)!2j;`r_647"@J`s:?=m>J5k@e4Uf]Aefj]ANT[u-:S203YJ=EJH;>0b)K)%
j,mgJ?Qnu^9)(0rARBN9#Y2GeX]AC@;U7U2QFo56rA&:]AL*m`&Bls$"sj*]AP-j+Ffl3(Z7[0@
VP"I+"NHF\)'@>=dlS(=RlaZVoV!92^_R8nS1iT.f<LV+*=laqo;"P"Fsl4@OG$_-rI+pBUG
mWb-oO<pLM$LmrQl-p9JR1W0a@gNqCfc%G"pW0bRbCf/%QrN]AnCK6]AWeJ?91J]A7_QO"iZbCa
Iu3flM_:oFq="k&4>]AeqlAP!PPgE3g<DJah]AOoH;#P762<=iRH3/)HnI.Sr4h&b\4AfHC_VV
LR\p>0A7qr%DPu1rS,!Q;J(7=74^Ll>?_$rtDb;'(9m3)g(K9&:b:/Y/3TXsVuBJD$MPNXJC
*4gF^VdT6erg3$pd^?43Hk`hlYA.+UTku@HBAZY6TZ<'#&nu@cp'nZgN8F)@_gJ6TUCjI`o=
$ZddlH9ne]APAVeB[!c-@\KlS$eeK21tIBS^]A6S\I*J`9N_0i\Y#ED2!+oafiT7t:U&:W-(7)
XG%EBDr&6>[j2\R\IOWhSbas'3,l/eGWZM8A/Gl1kFnr5VO$qD`m7IZBGFI)*P8XM!/7Q!R9
)k=dI?K)`o:%DF2+HR+9864Y[<,96NH8#(C@"CC#XY:0U)K48Q2A8OV"49T7WmIKIfh&lA9Y
U9>!:',+kd-K=?#Q8'Z0%WJ0:d"X5bq:_53,S96e5$9$hi.c*01(Z^1q>F)tpb#Gk!I6/!,,
'V,ch^#&^pEo3q,9!Z$3c\WnI.0ZQ[`)".@"BCArQ&ViUn/hp$H``!nHH;uaIHl3cm*@\N:P
D^(OD2GXXSp""3m_S+;F.L98$@b+a]ACEBn^Y4(_7sSSm3DtRngSmEV8(+&D?70&>=>.haLmK
ThqhNb[W[H&BmD)QUaB8.G+k4odiB3tVs-9oYI!q*,$[o%;qi>2fbJi5Bq1\l'@@05:HsF*,
+o)5!+B6d#m<Qm-N`*MAoFtKgL*pNa`E?e$=^.c^UJ$bO;<uY3'?8p%Oh=8nDlh1-&dF;6=]A
;YB@QprSNclWgYJ[GUR@u[GJ<bt@kBp$im\\f^2b[=6U`?@Rmmo<?%GaXX?u\+N[+i4Y4$Ma
=q1b5Enl9HZaO]ApBu.B=.WjoSD7o#eG7J=YXC^aG2-2*<fb59)r$iVb<%E0T/;/e"_;_9H.V
g(o3csT!fB*p1[YQ\+W9!HJkh<0)#UN>bGQ8:Q$W=&+1l4_b59@:d\3>fM>]A06/Zn$!oSXg<
?PJ@gFgda<`gK%(s9IbKEDIGZi&eo+%/n?]A@8C&%t+MS_e'AGbPhA>`*.Wh@pP_n?/W[FkmW
N1L4!.QS7chH[:3E_("Ld7a:Fice['&<8!SS(qK4!2^b_9"tO0Jd3sZrc*t!ruRbcg*;m_`6
bHp63T'@&C'Y^K+3DqE^7I9?7AfNY>_q*'a)`XE)^jcOD[r3M6)f&`4$6*6kruord9l)G^,f
U`-O>=sfZJa9aEn-e!tl?nE9s,'Lfb/35.g8%[M=X[=uK:3G#plo?09;K#ap^H^]A26X<i5r[
V3[)aF@>2qFjL*S!i@'ndP3r_LDr>%k9[NUYq5ci+A+(O9ncWkWZ2f>Ji!fP>]AC2#Wq8(SJ3
NH,H;_)lVoFLt&[)KSW@#HTWJHT.MiKKJ;(&iM6fn#A&(Lcbp0eWKs[Bb]ABX(k,JU(*$#D8!
gu&+fBdQa3ud)V7fN=q.5'"H3ZNb\k3MYaQ=^6Lee4m]A'ki`3qV(\DcO9B-WcJ7J5aX59/JD
kA`5O@o7CF3#d@fO,GLI+lTJ8T5a\oESOlB+Kd,/:I]ArA:W6:,qbT\<nS<b@A:<gVoR!e'&?
:XC.[EFqs/-s6:fR).[NJ`%e2IU%m`\qD[<l(cK'is-K)]AV4Vb=6_.'Skn#;+_@r_+jQmZC$
[f-/?uo4!d'=.(s".:#ZC[#F@^=qn.pOnVY<pH!9JZ)Lou(6\G]ApV8AgGP:T1s3T@XVS0r'N
$VZW>$19u3o=[+/nktQibq2"?gonD"-Zagu$hU)=0G*gil]Ap\RfQaB^1J*6V;3lk:Eq)n^L,
)%&&[.']Ab$/S]A;g"jo\^>Zo:PhLW56F7[1+#pP"4WlMkf2p@UU[Jn`/0#s?lO!L&W+>L3A#3
L"i0n=&HKd'pgkQrjcc9\@=%Wl?=AQ16#r3r#NK[q)N<.:9'Q`Ok>8'0tpkdoMFb$=GKWmS9
;\F$A`;fsOk6.8J>>;LnCCI/g6FQMeOPRU>hsE::$`Mcir&K+`,$m%IA+TkBnW!5ib@Gf03(
jcnhoH%BSV3R@^R")5_"21>G*sGFMD*'r+ol]AVC:+e>3IdaR6`L4[M21+VRECp[gV:a8lB*j
Lm]A:^KFq.V$&b4>?,l-YoAUp9=-Y?-PO!IFrJljdSlNIHq#KSHG$&O]AtmV%)4b\*W*:$D0o#
+:EXK9aL"DaF=n#a`=k:2G`C5MQO#*DksG/l)4&*<>UL!5G>^T)qeK:71,:IHsLq]Ah+"BaZJ
"`fNS6C>qV$ol5s1nkctl=[GeUg8^"I+]A4)LiWJieafnqe)X^/C[K)Ur<fm-J+OYcPl[`!87
\2SnP,qYlf*e"<q)1U5,@=Of[S1NYf4tp`7(9I86*M$E'q>d0YbJBa*epZQR_:)2BLWJD:q$
[.(TG]AD%O2qA/6*uu'ST^%b4Z"KT6kI4]A?%EZAHWIpM7^[/5Th,(=L0,5l!oFQU3$^8$Z*^1
uW>b"@J#@31Y?HJp`bNq1!NW=!bHT\iLnV9$1f%NdogNF'V4!;OJ$t0uV'6'=1Uro5#;T?iR
NSHi=ka*Zq+,F%n0H%?`DgF6p@^c59+T2f6q67fU6)ZTe$Y\H[6Qdn7J`"&Z!1RY>Q7-%r4n
1?Mf$);9pC96NFq*EIh:@rH)Wi%`puBgoLS@\C\[a1Kcl&ERi_kZ\]A4=;r9L)dC,1Pg9C@F8
l0!1=M[B,qpoDBA0As,an3Y6HAu2>@.SjU,h(putE<7]AGT&k00;"Gqk-CO47,.)ZX%an5*TM
>U<DY&nY8KUNk70^^+`)mP=f,3hBf=]AII\e\.&\^H4Ac\Hg8U,_]AY4CFS^n.3n+n]Ao=NPO+2
rWTTfDMW\Cr\U:/2fFY(VQ'f/T';%$/Q?l2RUFNL"<D"R3j795CARr?S[u!oSO^qs#ap4BN-
!O@>7;U/d!;rpeW`E1F?*UW;@4fInI([mIX3neaNf"*9\`WO,J5JP5ReH#sJSk+sdVBHWT<n
3[W5q)Qk7%AWS6[R&n/9/>1fRfl\@,A%Qh$I]A,\5Ss6k!*9&K`=Kn?e#J.8siL#'n>FJ5:$Z
=dsYVd3'EK(p[FhYp<\`,ZtVML2U,do[XW%;UO<5^r5m#9)LZC0C;GcV!`kWiRtbMgop(/[Q
J:+bDcd=8c%']A=q#3mlU1G&_#q7?C(Pd/(.8+Q))[QoHEWY-)aQ9F]A0\5$fIP8c`8+#p6Cd]A
21jtU$F-kT++Y^4aGg1PYd..SPQR(-RLRY5.X(.K'Mp=<kFSktH4UuVbHMhVA%8bZ\Z$VdDD
@I?L/.k0H0@j;m#u&3""J[5RVO5RUB^cUrjN@3'Q1)b9JnAXD$Mn-U#j8uRlc]AiBHeJm3:l@
[aal9#s`_Dg3k'09>*gYMJ"5@K,(-%c\KAh^HqI\F#l$!i5)m>'!]AflF+:.'/Z7bSm,U%(`5
IIsXpD4[9s`X@PdDs(oZd<(VJAWM;M`'DEp/WJX:$)0&hUokI39Pk[98@DLGr$erZWuf'o33
BLDR4hGth*H9J%%<%\.S9C5ClMj1kf%"uYiaQL4_#:"5*jmu^d:i8O(otT(opS1D@b)S<X'%
W4dO$J%t4eQ$&?7^]ArUWTi3rHtVGYOBYJ\,`69!dZn?@/tdR"'U$]AbfA"^;9*RO!B/h$t)B]A
r;ZgO6t.h'#a+CC@,I3pbO6p\:-Qt/+6_0Q!,p4;O_b!X2!e+]A\AVtP1U==Z@*BhK!<q#`tO
(Ihf>eg1T\g6b)gtfq2-V;WN@Yg1UielAojqPp#RqN79)uaCOhKDnslsd!311=W\25qHU92M
TO=1k5K]ARMatWuIg]Ah6Vs)c=@icrqA:[*alj'0\i/\BYDcG\G4NMaYXSt,O5C9#MiQ%q!Z-'
TO-,*S#9Io9S+=dp19a$p;[fgOrqqIe?DX&Zdfn(hX'U-W\="`\ZUb-K,XYllN.q`p_G'/'o
Z"]A1D(]Af4A2+9/eRlUCAE3(p\Nl5%`rFYk!DXK%g^D`tq"[WGb^VL![-`b3lT>5Pg<qO]AC"#
iS73KTAZ.Quo[RmaDcp<38tJS9Yf'7B3(qaG*m%89&J^a/#Nh>uL6iVUa./V,X?-$RDeDDCQ
[FGaC/!aknKcgq7&BB1DrV$I@#ABjE<[I;gIKNDeZCi*YsDr7sD;47=3M+"BsCJCuCJb4>J`
Zd\>_O+IcJ`(aY8*5bW":!hSRBBrWYrB3ulf:P'$lNfG4XuKoD&)\_jrgi&D<tZ9e%LH?nhp
_:9I!@S%n@W.srqDTZP,:"8jK1^*g\[7WZ`K#n@5u8sVf*Y4U/l.bp&`HbK%'@7kec.@pq4?
$l(+E2@K0'DDc8d&f>eK5a=bU.mtbVm>9B)[D0dCbijAX&7.r&n=%`:f>k_d0^UrR"Cb-GTP
^CK+hXWTtDNQqWAp%XtPkSG4*+_bKa<H7$hEu3R9GB(l"m]A_#i0KUkXJ/#:4eYXpHr/[a&5V
P`XXAF"+79fANDkD^Li[FhA$om,e2anK9Ud?lNP`]Aa&_cssr]AIWX=s!9rk*")*J81^i76o%M
2s%mCJAcr5QQ/uu!646W23)o$3&*FaTeFtH;J:_9?qBI2g\F,):$^kWVr-O$^/-tI%4=Q4N*
1_C]ABCQ2&,D(E7Z""\X?JF7%sTRgD902l02?=#YE">?rAI_=qBL7%:$[;Z=/??_[1;.'@B+#
91WKq2+P*kX[j>"P#,m[7S8.n)I$J0]A@9j[NL#nle-"_Z$Fdj@7lSb`fr4q!'7QA))+*K._6
<FQX5=tuDs,@&nVXA*6X&b'&p[@3a=NeP3KX\jGlWLr/T;@X*8)lWuDp%"8k`.Ye>IIBl9'+
DI!nfatGiJZc`["*I;B(eio"AOTf^+6^[IV]AMN90Ue/+(Xo.L>j"n"P)=E!o.6lSLeMiqZiD
6ZmI:<8O1koe+Y%oDQ4jj#7ka\%)pc\E___%OC^#5bE,Ke!a\@l<#hoC:N&tQ0_g'P:iX(jh
.9)OT"1j?g+?I51NA;dF&^.(cI]A@6SWYVN3UYb>WX[Td)\sBBt20CK;8ud.7$spW.#1<qCuq
9PG'LBK\<iA-_jS=ZKK03:lQu,KtbhUi.g@PK^l]Al\!4A#7sQP5r]A2QWa"2V$>jhjC09&r>;
NWG&cPg?S8Vf]Am$B>SueoK9(,-Raq#')S=@P"m9#(C@I.`Sl`<:=_#\H3-nTUqtZQhFoNCP<
$*]Ak:pM]ArNS&+\T'Q!$+'C,Ps.umL2l#!MH-2cPaC18J0TrbE)#(kP\0;piHiN,gT/O7$og=
)5lA;&r1:W10V7]ADdcc@l*\h5$gsoc'O9.;nkP4*BVhcSo&TnbTMUk==EA.Ul^C.f[Mp)%pZ
'q74&Rup)Ghi8O&YR-@<k59VlY%$HNi*kHc-OBE+^s_@-/LBfJ0bGj"DXfa"]A*1J]A=(^X-VZ
06b3j_Uh*+C>]AJtiJ+eMAi-7F5[?UDudm(%Ma7L7Yq\6>cbS#\;g+mgq-JkHRW?7^7?cW'[l
B$OZ.@9tEO"hjB*1nWrm0&%Xg"YFr/5Nfnk6knKecRl3'uJ:m@bgNbJj,NIJ;1H!h3l/.$g7
q<Dc7q1F//SIpfGH+<[*?G_cf*lSFnhE^Uo59Ktc)7AOkPJ.qu#C4I_/6-8>kV,X]AT4HP`7t
]AriAL1"%-H"n-Q]A[q0EV?84FpB9ZF/1Ydqs8><Bcpa3;N92d`ns*_i.#&<Y#]A<SmRTLT&&^5
cP-hBUR'&g'1n?iO+"$a=\jL@Ci?K!s7d`P,bt8;cj"q9mN#3CCcVrk&fsW#XC-%I#3^nKjY
U!oOPXEcYY+OuIn-s5UB+5dSI9j)cjp%FcH+hH?q&6]A&Cr`>XM!qp(ob8*D.geSFn(fK^Y:4
:f^AIO+amZ/5W&Ea,?MU.L$9\\;^HDgIrZKoc@$'ITr+cG*Qt\^\0-6XN?N3Fp#s*g=AuPFa
\<GJ$^$2"PbhH=2hP]A@N&o)e)XOo=be7L6J[pF+=pt"YrQ$54J(*b4UW+@dGbj`"j%sblr4a
AYhs@K]A_ib[khFp(1,#3Ml/e^cCU/C7Lai=$p&3rD_'I=e)`<D\c'QiJ8W_b.>Z;!e9%QBQB
DsP]A4>3PWqWLsloO2`"t5^j1gc!mF`Sse@=\2+Q*,"F!V64!muOp`i$T0%rZDuf,_u'[3m8B
NENuE?[l#tH+t)W`".aY%^<+gJ/?@)tD0>V)e@+-5.@gqM&?@$WXCF=?hD_=r/T>hXkOiUXM
?$DUT^?A2W7H_%;0YQdIA@LWh9Hth/afLG)%0!n@bJ8OSSak^O\M%Nb9[*dS?1_NMAf.5dE^
WTjGDp&:p8SFfX-l`\29Nq$%,3VlVJ,D%4I1:#qXp)\_Z@BnX./+$im3WET,RD-Q#Y\%P`.@
U>5#/_*e>)mu.*jH>#s="[qm,ae`p_HjjLWXr7+BSMG.CbVB3MBq,&Q%^Up+EYg#On@<Mn-Q
mtP!.pSLH9g9nmnQlB>1u.eU"kF6K0D#[@in\G<,n0F2W^.5nsF[!F/A2b,U[`KDX<cpkTBR
p&#*Qg]Ai2^cI'4fP`^j00q\aUh2p24:>d1(U@[6#76%#^`SWQ+m4q?8OMr?asenhI8=sd9,n
2"g;.#bs4LdOkAR]Ao8jPL@G.2fV,'7QC)]AW&3;=AeF,h@.%;$"os"g]Ap1bon2q7p7=)3DX39
c`G5K<mqb6C5e>;J#qZgDUp>gr[gUDNNr$eoUcQZ]At1[C<K3u,D?!X^^o3;FNDSHn#ZWM*RR
1t@'QiV6g330=/9CK;X[!<C;8eN>#gj=O\(oc!MgPDUTr^!ggnP&I#@5E+6b(QFeRpbb=%CO
sEHnbsf!YD6q0!"f+!BbkDQCUi0!KoRqSNJr_iU:*]AV"X2f.0X(fW/n<>mW>JCKWT$TrobYo
Rm<Qs*T4Z^M(l97%jSe1H7qU#0=*(WRm5D8RR9kZq,/8r_PF#q_(Je#&kn7Z1s$.GX*RCa5D
!1dunMIlp/V,ni/\ulFTE<b#DE\2>(VA]AXh@TsYYQLVoRC$7<Uhd)&VDt)RT\C26X_c&=8Zh
.(nD_N(L1T[#\+PN?ebHh-C&)mYBC4eB5$2-E4!-\Y-K6B(<dg!GCb1guN`'2o*0RSCHm+$.
^;MCFC@QL]A>Moq0l]A7*q5(O067qpZZH?W>7Qm.QV,r4NcQKZQ7,0B,Hqrn&BA^7XE(4XqZRV
*5_8+Lcc#I:PfD6K.p/#kmpEc'ZOo+j_h)KmC/qrR$oP$e6;\h70On"R@pmRs)37A@X=cI(5
ASb.0ZYZm/'8(sV&Nu9WVE@n,Aj8R$0ecJY+>setOOeO]AsSK#S[iW>+_$Gn1hE3bGm)<:&ID
;Cr#-/`eOV$=#FGl3V*.t-u@!8O/H5mGs2%9e4Yc855>V(1#sDd_2nc.AVO9o0qE=i,9;;*P
:0dkr<P3#WiWg=56(f5[@nIT#=YYas/B-RAc=gb>b9V6^.WG.3%mfO<:aF_L6AH7]Ajd#X'ia
m@peJ4tV@`Zg.9!.1&,]AI3`^60hK8JeCT!]A^b3<-?s:cJV9HgJ6ljd0rS.!ni@gjcI0d``]AZ
s>#me.(^Wngr+SG2CeVTO/s^%4a`?1&*(7GJCq[)g&]AY4^t2CY:GbZ<\!c\d^bH$h9AC.#Ro
U`(hGSDGR8cXrmDI>Y43LmkZXHWW%?9ZU51G)PeEBf32+A?[P1Eo7rRC8M[q%Fi60ugblekG
?AWF1QpeG%J1<K`fK3f1?u7M7_@Uu/5(gFY]AlQ?9HZ:70)(XhDV92:AXUg`hAF,3BNrtc?ZJ
.Be!VS+/A,r8W#]AUGMcd@TGbRJCc(g^t#pO,rf/7FZa(KkCe<YFlFS9nEmG2sflPoV4DR)B&
L:pq(9p-KPPaf[03n3//84el2p,SU@Y&E<e48m!5k:>mS:`s:aa>gcUmP4'![^r3\<Ht-jmC
/?m4E$Js`%I8fp-ZbVLbBrT2rmg3JYB59^D,.'RR+41DmR*t6.:%<'SuJB$WH1:9Bl;&[G1s
[1-p*@9mUjh%loB)e+QAXR\(2/K7E`"Rt8\>aS]Aq"g2G-#%uoKKO1,T)9X)*ELW_!i^+,ZeG
"8N_YJ#!a=*a#\2ckI<4:ss>6[WbEjP/ob-89`"0V4QBqA3j<DkkS$H1A@PPt4]Agj_o4'+tK
D]A+fu_ln%PYMTacJ[63.[KM=f:_ja<2nU.74CWts`n:FS*W.fK1-?HN+,VRXtJVou#=H$?@V
A,5EQqh1%/\a[7"5`qse2U-[TW5g/*[95tc8m>Y=[4?e($IX?dpLsXL9VMD4>DeN*7TSJn8W
jD.D]Ap4EopQs2%<d+FGbho.J![\WT9a\i"Xe)0A'S4(Do47b[ns1DbkBg7_W"gW"J."D7uaa
N/Cscm+tMBbps&f@I:6Fn3@*JNj`AEXX5PY2K[DG=,r]AN*,#rS)1YMk3S7Z>rac\XiBDILJX
nclO)H+P@<-)r7m%AB4cq9>m<]AG,;.TR.%2h!!f^ut&*ppbK-/%m5mnL3h,5,^Nub2/9&D6V
]AXEh;Zfg<"%'gA0U-[9etH\ddE!bEjhaJm!MJAq)fB=sNJb\bqoVAVe+-]Ao.;0AJ8/)'`b.`
/c.225=-ET+qU8GPI!)Vn<Oshroq-=4ulo\<*JG@1l`NZ7iOp"rgm!=N9bg'!kRp56GORe[F
*Ze-_X/uIu\GX%q8D]AHVhsnoe3UHq]Arj72_:7Oo_6tRe:(/>Vaf^d`ll=fd@n%3OV*s/1GB'
E5cC3rSVL"`4,=%9UnoX3?,*R:BL&@YTsUT4PY@5*euHO6H$jM!;mT:cn]A"sa^^-.oh6sb=V
0:)"c?G_6C3@L_g6;7,[NEI*B(54.;OV&q)[lG0p<j7TOu4D+A5J*l^QYX%\*Jqe,JhEM*\M
pH^o-T_fHdFK%fYZf3NGgLkNAuB8VctGdtb#[j`_g@$l]A4*bds?]AR2s1r#Kmm$K]A`Ft_'0aG
:i-ejDrYFFqj+E8I)?#&nLA^DgL8:mL%Dc9XL:USU3tuOh^_2K22!1O"jg-AjEb/0^7ZgQ:t
p/-IFVq'T)+u!%9^n^kl6"'ijBVbiUtpH03[;jqhVS7YRf<5a<tonb/^8/^Jp"XT9.Q!`-go
)Ancj+At%<HMZL<?V1G9Ao;%Tu!F_@B!goTDGq^O=UElgC(>l,gd2;_tB3jC=O2f&1UPd'PK
l7AQG1e(>XGa]A1RA0!W:8s!tjIVQ?M!,/U)mDiHX.?]AiXL)!JUcITNF_S_Q#!/fV?WNdo@42
&gC,)AJhhDD")JJg>kZmJap,;5?D:5sXkc:K<PEBa9QJib.b2@A'=f8diS'($\QfG^::d657
<V:tQcM8h.YA!b906q&.bhUAFrf9M_q7qLH]AcK%fEko7":9)5UF&FU)HT<''_1NQ=7K1_:?M
eX8PlN")9X/f2V0V)gpQ\<nWlWS%lLIur)*(Vq7HW-ldPgCM\!U*Zq7/t[9ZJGbQ.kcu=B"2
=\U'`,/'WYkV="K!,4qkKms9LrMB1a<E2$n+Hcb8#[6CjDjWHYeq-Eh1YqEGH[#\I$_SaY#0
6s+V&9ekked7;eIqgeapJ!s&-/Cq+$nJ]A'<O`5Pkso[XafNomjgLWZXf\Qir?*7RbjSm?4jn
0BU"W^h_-pVV[c"TsC<]AHfJ&k2h;AtI\)mqGgGF1Au-jRGfBJ=7o'0tg_r^p'8Ru#;&!QrN3
bM*[Z(L"O&b\Ib3rMfc\PJ&jiaBeq0h!'-.7%NSC.lPPk?f-?/)J^>q_`CpK:4B,;5VFnR+2
lsrb#LEK0=,:Kcpb_Ad,oTnLP"t2%U#^bl?GK@#f#m]AeM=%mEkc)6Jq$!H.f(=?7BVk&!<L&
!-+?lu-E%'@#]AC,V5>Ce6PpoMtk!^cG??pg.R;Z1q3IMG>\!%.Oe9l+@1H\dgM`c9uVH%P,=
ViOb3o&![&4=r6"5C/t_iChbV1o%?35?R6TX/?,aURKVM_s0-iV55%@%DcD&/3kXqm0<oYUo
!7:?C?Xd(bl7%-V#>^1&&tR$EUA^)sfY))_-f;"C/c9m'a2'L>+uOPYniJ-&#_#t5C>64m$*
UkD8F<LT"GV5cA;(6PIZ&<Paq'2Vk_:o#TITsrD7,cHcQ1[i!&bb&,HS?qtDCYe;_Aaa\"&t
C/L'^2rT4oGqOaX4Lgfb7Y;VC2"LF@A%:4qKC0\K;eIZ;OFWgW[s^UTPuJO%s"j)G3%.='1u
og)JlQ`[a/KhRGVWecVdHDlLsZYX/0[4>F$I(%ZIg)BJ=#DW\C$T=ef]A/&n-$Ir)858!+:G^
HqM0j(.Cg6e3<2P\l2j>C]A`1B<cMeWhMT,,0Z_ac&\FPL+8o!<n;06PNYkoH3_<.oRN'g:C*
(lM=En5FOnBubKNj'eAa=CQJ`*/7m;P`2\1r*_)!RhiOW9_O.L0hN?d44,Z+_N>CF'?R\/.o
1*]A3Y>XM'OR]AA6E#.Our/68rm.JOlAgp+D^e^E`B-JR&/`NXr(E5<aPoc.GU#sOn?)@/dX9>
_pK85AVse6B(Ah_P&"=^?P(QE%F*c"qSW.o"n#PM#<Q]A,KYf=LUUW:g6GE3K%o&h9n6=BBCE
i"GIXaU4qkr&`s/@Q+%0H3Nqpr7uR*Vm(G>o;nHuX1F3u$N&oWCANXHB9p0/l//eI[8lturc
9)&&ItCY&Fj4MDlH+'eSP-(]Ah/:^/')U`]A'SLiA>^I]AQ+%HBLGiBo85?p(jaOS7Im>H/(12*
t2_7a&q=3CRD7t[-P9>kM<dgbF?AYI-CDS$^aK;tZ)kA<'kWPECS<^IM+HI9SqQh1&1^;ko6
\L>aNCK%6DG%'<5aA^A#j!_cF%R[U<C*2i8*5,jQ9fa0_';$f4g:L29_-&FsLN\9S5JaAK4E
dkt+!A/eGdj_I._a9"5%,;(9+:+V!=:(mm?n^QDSDX^Ie17-=HV]AtTkLu$It2:J\N``V%#(d
lr#DmMpEGr;plL%p[ouk+COW$7-]AnG!<X[#B:FY7nKGWFO4GdVX"Js%42'a.9Rkg`bA)Ji%Y
K=Yb!(Nm5\ZY5@WA28]AQa(OYHPsSg\^c'Q611LYqm@G!DKBqo8s*>gL#Jf20m`Ul8VV!!,8H
Ph'A##YaO4%*gUpfQ^Y!SF$Suls,XXa>9X5g1EpI-?)sY3U8Jjp:j=-=Q=AO09KMN*T9)@mC
TFV+7=MmLr/V=\K_=5.#d5Ul-?)+<$6&$m4N<IVfApCc^W=pd-W:B!N+=O[I2br.f_oA(JLK
`oqiiQ"8-4^Z?bm&qT:EZb-cQR[9^."=9K8\q"d7n@)"e-'.\_f`:iQ:o_4JlP^aSC?TI`T=
]AUHl?OCp.(67mK8o#u(CXdC<DbB+\UZ[r`;I11=&WVC^NeHnf-so"?BIqtRX1kiZ8!7%5t\9
hk8&-huBIF+-d$I.JerK'U5]A5I.$Y;eXnlA",LC+6LdE\6k8XJJZQm<;QaC2Rq"e:EIn76XQ
u,q3d%&`k9`_*&"MG?GK5qIn80g=8$_OiH8(I?b<6rA@mui)"=3Zq9?!^a?(G6(sBDl)El\X
)04h^6]A'DKK\Iu/Sj,*"lV(BmP-qf8`qYYDC(i-\[WTCG4B$eU.?JR9ph?ARe&P0UUCS'Z.G
h**gc#j46snZm&S)6?;09<;JE.qNUm&D:r..1g(4F+A'@tBO<`^WSs+7g.GKl>.hf2m3i5"X
hFfV8=60BlVOhAV>%rq_FNi??q;0ptg_W)AjlLW%@=*RT$(=I&406Rp25i5:T41sf9PD^lN+
@^1o)a!4gWfrV2I;&h)?),H_KY5n?bRiDYM5W@I3S/&h>h/T2Nd1l*>4QMVS&p2`ZNN7n&qr
DP2K'[cC^mOp`JGUb0=^u3DP"+=[T>rqrq3b^Z>ePRDIu;oRa&lfqp<L;6E=2R,,2g>OO]A:U
g.0&QTEefjBiqVaDgCa@k^24KIH^/ik]A)N57"^uE[C<uQE(hhR`uEM+X@d^S/8UN7aXHuD8$
u+N?APYnZS;Lj\A-\*Xr.E==U<C&!%8*>?G$]A7k]A<P%;UKrhdIhbU*h2q8"NkSL6WRsaRp'Y
URuVU%$Q(dtj`_@27+jpN7;dIf6f#n',BH`#WHIALP%is3L<9EsIBiJIUYcL2W21f'_MKAM>
"6#C%="c;dUe98of/A$FVd:pH,HMp"m#=FPhOiKAq05W@?+cp4A#R8Z0)Gj#CTI5^=t/ZEOF
":[%"-[#H?ELSGlUVl5Uki7C8ShZ(1oe0d$56MeK:[P.=#C-!JsRMin;8V!<DJ$de7Z689bX
gg[/[3oobkm,PeIm+kVk=u.>JYTOV9M/.&#r4P2D:t!3:faMeb'2:;kfY<F.A]APP+:Ut*WU_
/b=f_[RZrp?X7W'dp`T\&kU=q=ki&.KY7=&:(d#QYEE3B`,%nTE>TP3h%b?ZfApkZn_Bs4Ud
sUZBA*PKY9E]AemCoD=*:Z@@7nrZMBF+`5a:OOAQD\_U0_I)Cq9N"V39MZM@_Flk(d]ALgn4)m
60R7^CBF@D\,PUr:Xh]AKL6]AFW\HBQ7JZO&`P8XioF-c%^Ys:bd1$!<!pECuofCnf*XOnRX3,
'S(RSFb2C=3q4tlW\ja6=C7ao7C$E:.T-NQJrn2m2[(E;67LTjP?hDr>r^Ohe=&N[Dc]ApiX/
-mT:6nm:]A\DU7(*=?hs_Z28A!RnO#85M_t1&M_^nk&OHKs&K3IfK5.g==[70BL0@boIh]AdF.
_i3#r:b*5O?<"$O#d.CUqUV<FH5bC9s%/>=k."$:gg6oP+L7eVQ'*9V,cYCauU9/1G?'8$["
=M20Y$8iU79$F]A8GXFp+dabtbXo):H/hD^\#PO_d(;E#&VR);Yl+S?N:_&C8@.OL"T//AXYK
"K5p+Kl(c8"Yh:>:>d-R_NMN)X=-*)Pqk*&XP:`2]ANq^L@g,j<hsBRo/NrETC"j1'R_@e,5M
QbSPuNYPT]A*8+(ONj'jg_WJIGWQ>C86^27W;'S14L$VG4cf5gtEPNs1RH]A"ICA:.iEW%k7;8
dSuste:5@*]AMqOT3^pd82fP0`*HZ"ZKE3b/:+!="O^G"/Gj,pmB0@^*5fi!1br,0#Q79-"h$
(gLG?BiI6m*HHBT=<QDE15X%U,+m"&D4^Khe*T=b\*a9$6Y`(UGAZ*&8GT7Pm&=YmQ-fGoG<
2]AEhD@X4LLQTFNa\8?&p(Mk=keW('#WU%+;kHSYE4kF\!2IljNUnF/GmZ'"H[r&-8$[Pp.^A
TX7`a)0i48-+*.eCS+e[@8o8U2m\^f>DN25q>(;'20D09.j*>j78o>DY?BakdBq6ddW:r@+(
Dk3D<7oMlMbY\).@qJrNGlE)'D'X+TiP<@LrG]A4lB+?P+Mn@%+bhcg<XG/CpmJrBtA<P$jaK
gl.LaHLb/1cffFDFTeU-FR+/B<hEgE:s;!GPr#T6#:tgc0082i<^W*qP35:sRe;%66*T*hA/
R;g".&T'VgSm6T-hV_)2si=+Y#;/!=n+Wl$Anm893Usfnh6TRZFsrQ/tua.bkQ@XJ5[%!<ar
ePoTpnme.ilkSn)"WtEU4<tX5Xg"b-K<1D!163rjS0*8F?mFj9$0-7S]A_tO4MCGM%216\'i9
)!p&1h'So,1"m9M/5ci;V>q[5BEOX5HA#/)c!(:gWbX/s*]AEP*V?0GSkag[[HCY:bF#cdhnb
r2q*)7<966E3(-6[BQcJP_IO\1OI)MRXL5<hp3K;BCP]AYDWpr?_N#HI4r-uK5R:=sJmW9*Dq
&1g<u>@C(/e\ccr7+;<b=Oq?1'\Z5$^h<p_0I&Abo;8s%B7V"[J/HPPjQ/#727&a^Q`]AScU@
-.bh7@;0PHc^;+f4*(SJOkc]A;ou1kt;-$J+M^feZeH.0+[Hb2?6*;3'\M-NGE-=S;aD.8U&>
rc_oEc05hf0a4+;X+^/d!9YN"+:pA`REPjgu8^B,p,T?V(Yr03;9RC_r0c$Wo!Wsm-UCj_*e
6,_;L6H:T@Tthd[,;iM(I<ci8t+KebEPW06WE)LPA>qW%nY#N77Nd/YLmj?I%fAVr*tgt-l2
='DNGoWH#:EmW_L_1GkO%0i!l[<i9_+CJU<t-ep`n09C'PKdq2o-YRPBSl2/SeU8X:"oek`V
pZem#9W+\W:ehCR<'',BY%"P?9GEXnrCb;)j"&+N_74U6(j2rEDn[LT6E_H]A/o[e`j@Y2WXJ
<>O*r4Tn*p<:f?Rm:m.JL`!e%VBV(3eP*T"X=4i^"!)b!S)A^VpICl[MJKY`gPF8^/?U+Y0)
Y@F!,-NW54YBPt<OQoJkmdDl+<c"@?9>.e)$QKK\=6U10t^)$Ga.QVq0T:_lQ_GFlLdqtQo#
Cu8bblYDVn$NF$&&huc/D[+_i;e%B*NMK!**0KN50l0_=@XXlF/A2WJORcBmO3AIZB't9*ZP
G-+e"]A)k]A4pD&rU!*2O1q^.@TdPXb*#\l_(e8^@lQ+I7tM<Co;l>^uQ/7nZe4eg([)BSOgCg
b+DmSkk+(CgYse\jgFgm%5R78rqtVq<\@qsp)tj4O(ouJAl3TO?Z1->cR6sjW\oj#4]At">OA
MHpm'S0-+qLkcnu(mM_(c9Daf2Q33Nf/\&3K$(]AUq0'%8pm)o_QB;9P)EH4I+f5l+lFPgcRu
7nD)4#N-!'uX@n\?J>;VLq)c!M0;PA10qq`*"T+E*2h$^"JKG*?ljl5"O9oj+.<r?N#F0;!(
I?pV),'0!5g)#U.8(RQq"nO&Z([OsrZ.Q(AI(PoF@qBHg\ISnN2_-,QN3.58n`R^ht+eH$#>
=)qSV^PkORr>H1nK<:/-KH852U.?.GKUet"C.F+KhY,Q8[oB<2a;L82M(LTJT'HN%S:[LIbq
^Za7]A.Vt/pV!BQ+Z>c.BB_ea<-QH78AU$c>,Kk8_5N[9d_'Y0]A"Gl^eP\+0ChH&i*Su[6[,L
Xj^;u1r4obQ0'B]AJ9EFInj3R)V>q*D7m(OKb-.;r+JJr5<n\rXE)#/fhupi#(l5NGojH,k<3
e8\`!mA/5'?&g!Dd%<!VC9<$Af+d]AZj&sOXQZW591#_"5No!%;7#^o(aE``C9UYO)aY`m>Pr
)gaIVOJDDaF?Cd1@*:8Cj=O>_,.ir&.2P=qKcq,CuF\]A\@Zb*<hGkO!r4o$MsL[tJd$^nc/&
sHbF'p=p&$kPlH*:?mlMk'qXoKui<EkoFijHMa0@Gh[aucGHPMp6gp4[!N(gHrU(W]AM/1'Ym
k35p<TtT6aqDR6rjDfgm@H[3/RUGJuUC/otJsC#"<^]Ad/l-(2>(`GCH&@<p\/M*#VLQQJDM-
JVALiEc-pS8>XhqCR^CIGH,C_9rum@P,Q1G3e43\?ES5lrZ%A(pY![rQ;qOehW02A&F\U&*F
cH<M[tTM*Uh_lhRm:UJ08l5Q(@D]A^"'V'%qRi+['-C>2tH#Lar@-Bu>p=p44-aI_iBcdRf09
kH?X)rh9]A]A`>ImNAq^F&IB:*'>Y3#GcTAc9DSE5Pg]AT<;>`EcE?fsj/'bZq-S[Ps!A@&OOX8
kO9:rf(Ue<l2E^'GYcHfR(TPZ>)f81%OQd$2R4R^M/5e?i[^S';U"lT<i"Esf*o:Tp-:/m+%
9u*Y>\_8\Y]An,lWkH[Xl]A>%`6e@I\r/obUOQ$<DeD"Efs)U4D'b[*21>*:sNaI:p8J6'P9hS
AtGCcF\2cug\:6kZ]A3Fl?Ill.<gBX@kI3H4hHKDhjtFkkmJ'Y]AV&13qcR!e/qbY5@"gTT575
&Gq8F/B*%hkkToi3D+PHqA:eOQVomqS[IMp/)I#?YN<fcn"_1e#iH4#nk,:IVet65PQ?EmoH
4?%/]At!Z7T[ZJES9KP*1HXu?4"%_F/@N628<psZ=9,KUS_D@HJ/FHc2@I]A]Aqoq6N:5Caup,Y
E2!f3en%QTq*Hn-Hh-3-buRurQgHdI0M9!'f_`RN_QC.q:qBI8EM_&%"e*O78#h0-0"r8e?Z
7DF'6<)u`gc@%08c7'Q7\USF?q6SoX3<A]A-X/9uJHVGh_We@qYB5Wj:i(&k("#XegDU$S:E9
gF2blALrD?gCDWlRkhc!O.X*uAlAgNAF?@UJj56_k9G42E:2KMhp$$j?eJ0c!$7=sJWWF$PM
JLT*Wid#d)X'M\_8OU:b[eW<*AI3DcBo^j]AP]AJriNKZ81)fUH?@I+`*l1J[PI?@*O5q(`\jY
loPSo!M_ZI1C3,^3a-b)s:7A=+<DJQ=e4c97$G2KoXcLrQb^i9]A#h/V:lkKN$KAE^]A$@CMY9
X7;'.YSd,+^<%&ZHNpH3?E0M2j%MOBX;jZM>G<NBG0KJJmXL^@.`a1D]AY:KJth6k_[@U9T?W
;>PcYq^)Na#&gq+gq<HgMjP#Gg5bUV96<pj<K'oj0So-5Y,`m`ge=$(1jcQk6&63u5SeYGrJ
E9<ROANi5r9a*U+4]A[@arFpe3g,hCuCcPg9ZkudUHVZ,t(mA5XW:r*gDfnlIML`Vj-`"8=Sf
\&#ecmqUMck:SS#phIBX8!na+Cb:gr!Kg^ak6i@6p_DoSL&n.F;J@>]A.<if\p13nMlO9o3cK
I]A8F=f<uJQZ8U;(;V/q5:.a=`^p-0ju-4s_>DSsJUY3X9SF<rO2TdA%E<(V%mrpSanZ:o%K7
]AgK#o`^==-JI;,A\-D>Io;K;CMQWFjBorC!qL1;1H4m*Ya$aT$M1O(uVMRS*'$r_XG&#O2Dr
mdK]AWVopLU_h/jjTAP+eaE+XgK-dAbdr)%Oc,^@PQ(bBARr[JQOV6-V:1J^6E!i/.Yt4m)+;
^kV//Tcaa^%R%=(/?hSU-OsSI"c&J)O(e^*)S%30Y?pR3\$,3I#]AobNsK9IcoJ!B#!RFhdcW
_7cOl@6i[Iop,;XAYJjd_\K:<C<6dP!F>KmDr$QS269"<G"--gsXS]A]A\JKK-b?$%h/=Me&fg
k[eTh/ilS?4Q`q)m7@Q8Zr%KYeWg3ZgM%C.dT%1&S/t5p_Y/4^!N[75eC;LPM80"2M:;5>*'
q&`EQ:Gbp=t2g<)+l.)qaV&)i6.OY;<jhd:DC9=T-95Rs00"XUb>L#Ah^VH7!_o&>YWe[blB
9[dU"jUe6O.?Ra<3UPmF$`\:u#gE""1&C_>2g;g`bu\&WDH>TaKs@.lGRU9d+<G&-lmi#4>!
^aub&@(I"F]AOh?]AS2BUf-VY;>@HMDF+^kUn%i]Aior/6P3=mfBlY=sA2!,5GhU!_J),jiI+.S
lA8oSS%&DtU\,7%,26>GR.ARoI;<nkJg`HrROiE[MRdc+m;p//?DCrkPn&YMDW\.KYYT+"F!
NE?GqZNJkM59U3lP_Q0NOlkp4crp30g`W#6N=b!SBe7k)9M^kZ6*f^TP%c+''PH)lLT88TO&
a@YllWUUKHBgH1_Yf,T60"AWnmR_=%#\2jn#j/fr.AP;RSjr^&`rU0)+FCmtHLMjt$\<+`jR
mb$<Mnld2iq':h^q,?R*_Oknfh9-;!').GW^8Z@V>=_lEHeDpjr*jLa@?njprYe:C?,'ImFf
3)8=.A6rUAM'$!2m3;3k=+j;$4oXn3A^*'>]A:`GWrCUK8%W156k@<>:>D,iG`X?GdZ4.)hb;
d1c0j;7S.>2[V1r5=@AG;C0\59j2g,$G.jISDh-E1"0RfbgX$-2`<6/S@th?&r3eCcbO!8uA
PqWmnJghsOH>KFRrDHlNt@VLSQ[>VL6s<:&i;JF/Xc>gF*\S_HjdWK_=V118'Ynk)cAK#NLp
ofP.*TPE3-,J+AMSoNgEO7nagJmTuT/:\XKis$=P8H$ED[hje6uo6:6l!8!%M+*(o^E<cF%-
V@TIl_=9L6WVuO*Fp%kRqc%0"AT'\3]A2\Pc`HhEF/>-%75b-uWUR1@?Z.G@@h#c(P$i$JG'U
KR3c`*?]ABDnj>*s*k&N5,u!OEC[s-6D<&Ha[tnBK%Aor,*]AR1*,=ha?Va!7>8`J6CKp2#fD8
.Ys)V*$-RucQJGhfOM&"Vi#Z-efHPc>o,EUL4Y8Z13[if:4h&J7pi,O<n4&1'/q:?_VXSn%+
EX;R%O%g32%f4SieVlF1)aGD1Hu'.Rho9gVTT!^,]A!!^NtOGcIl$;#'5"![dmMj4!>6Hi#A!
AM\:NX8\gVQTm:W>/q%Jt$*Vd(+o;SU"=E<Y0UM.ejRQVb#?/m2SO^iYIj8$)k6:-L@OUm^$
7Pdl"N<O1i:e^[/6P[;!k#3d/pQdr-;E&T`%?sY'RllrZmp:r;6eBH&a\:=cmZ-XLKnJ(;nC
<^-fuugQiViT._Jcm>.`>L30@q.(Am9tj9Pjl6RCQRnplc+gpk$Y2-Zk%SXTSn9&qC)>&dB7
%b,3PIs6tW1o^XkK6t9.B.mYfDbFd>0AihI<A[l<WC?7<F`>N`_<fVliZS7:"SIZ`*,K`B;Y
;22g;'Nel#=ltrP2(!mV'FQZ\CdZNh2;*j:j)22B8WfnM(^4&)WHXaOI84^g_>hIF_S+fF?4
aLau<qD//E'EbXPa=/h@:j7[lBCRFO3#Vi=l8:Y4C3?/PH5J)\Ho8n8=*PI2"WYbcZ6C)-ne
C?R"0[]A2+B,2dPE^'EXLia[4!fIPU8eSs/;_'(KAR,H#">6rOV)P.rhGda0nP,sT(0RY/FU\
Fb:Bk(MIS@61ciP&Cr/fq>u:sNSO35G6',(Z')cEeJ!;A3N-U&]AfdSUMjgHi9jtf<PK#qIcM
277mlb+c>UlbdoC"Q=\>g$hbp@=Ksj>'rKk5ni\EPi/?40R5t#5ooJc94.[[[$9g,(j8HVtD
j?sE2"n1ullJsb,Q/*qb"L$PA6?uQDFY0>]AJY5sjfU<N?UKnZkfM\)%iEB:C#X2p,`.ZEh66
b\H#o`R\Y!SG.B/Wr_]AmColjmG*;DNV6"1oR\e=J#Oi79H,pVC1=]AYB'WNah:-ZVNm=Xe3A>
clq7SlBp4?#F<(.F>)(h]A^<J[@P&!+MIUcNCpVTqNc=;@BPOGOk_^Cb1YjK%prJ7t"))naId
_#p&BC7:MP=@3HhQNAhjse9GjBh.=/pJ:oKr:5[fo4o#=_7BQcS#\dSp\lj_c<On;gP^JecB
JRL4o(2opo\=H_5B+61#ll_I"K`:\_f``;g90/fLuBR7e1_Q'O5YP<DR;!P#_g_p%<-u]A:hM
!^@a%GlEZ%mnOiofVf[j.5bPAYK@&,g,LQB*Ho4`2P@=Aq&:nGV4",#`:ZJ4auLW?C@hl#!;
2A!'P=$_hAO_!JrK'X:eG)F;C7Le9(aIMI7;tEn77Leiq.XA?dU^OrF-&I5lW$T_GL26OV&(
:@pCL/tAn).Akb@f^UQ&IaEBk>"M[)d^VN51c#h'jWWCX_%-9#^WRp_'X`A$T([;h9tf^F?(
]A9+Q1BmqA"UrYX1:=]A1,F*3']A[auSWmF5-@4O^g8W3c$DY3pL)[5O:1OCh8QC$]AmuGe(=4%j
toq]Ad2LKBmgrQG:<jWm2N`fluLKn]At%^]AblMX;2G`+mnjpaI?!)g.7;rqGPMp<+1AC/qT8#Q
!>JuUR7+HjLX'`:Us#'S*:Br>hp%_W?hm:=7OikD_915$Y!,BF/tblXS/F@pL"TV(?%G"cJ]A
q#jX<>TjFd$!G@'`Fi85@-#KqqZNjCUqSPk@nda%qX&cfj.]ANEWK2Y<%9OW\QD2n@g`L(`_k
XHjI_f`B2\eu.'QI`i^,,H`^JH?_.U]AheDT-@`7P0NM>,jPGT\)l7ts+"MpJ/F>*I*fZpaa,
W2BR!3;RI$mLZ`)mpMk1N*Lk'I!'l]A/6aIe'L,ku0Ok/9W%D40KZm&aAg@lC+bp4:<d96i<`
%>aDq^HOXrj(A8hreE/;?gm?@:4@uL$F^dS%\1mu=fa*f6X.I/Vf1hL;#L_o,Yf&mMl8/'S)
LJl0mhfCg<\gF$P>AQ\^RmAh*5m%90u!)H$2lGOodRo:cY)0@r3,@@oN_;hJ*Q<"foV^k5.q
7=kq&S=e03/.\prc;)151V+@(r9g*SCGa(-M=e]A2s:q!n5</[!*!nN60e6uY&KoK%52\^eR.
BZnkQf8!NCKHJ1Nn+]AKDh)!qQs,'?c6h,Ir7`2G'+ZUrpa8#;?N4cePfjl5i6lsZ0Mf4>YKH
-]A$$^nNk:t[qrrT/VI*.<b)Y&>2qcFUF0:L5(qh"`EiJ>W@0iY1jA,o1YdGum"/`ckR,B6>h
QJ(TC:3BSQ*^?;Wa]AOer"1D7?DT,V2G$fg<_GEX$=Kt'r,mcWYUMCG*8_LKNZSTjcFKM3V?^
dD;R-lRr_[V%hs8#t6RJ`rpc9<JonGEgs(nj,BU929PFX5@7:ON(!9`cK>GqdfBke*9KuQ!2
p2bqCO&Zrmoil#aE+#<s+cI8u`N"k1g$jI54I#lMm,6id)PFG*Tt*=ge.089=((mUslmrH@+
)ST:$TQ%Z!i4F;0Y5%(F:B$NiFX?BuD,)\VSV>58?%f(DE<>4qUN4YFYJkC*X4$Z2H;[Q-db
KT&XmcPgF^.2Ohs:_^rr0V2+EW!4=]AT%Ia6rl5-KU;P`">4uU?14^6D[H&`k7^!9="OrFo0q
1cC->Di$.@BDeSdpS)?]A<87-gk2#@VTLNn:e[uYFbM?M'XR<.OpI+1U5-(d@9&9seB>\]ADtA
Ok.AA)^O'fDaUV=-dhnL;e+!ap>baLLUKhc#,<Z/BIAt/*tZ<*(V2ILAZY47eaS`(ZQ7gc(.
_GSB/C4;EC?3Gnn!NZn_;.JqP:pWu8*to[^jI^JT&/RaDZ[Xtas*fSLhGm4#e25*PCJ<b<UF
C-@$>'?\^DIr78[LZ+3WSnp+G8Vg2o7ug9*#6iARWA[DFZ/8H7;qm#rURN30Bq9p@euKO_?I
Wk$r,tp6jn:J.Gm@9A?JV3R@AIO8/JW+W]AX]Aur#)M1[iH6,Ak`URk`rE'+(A%7gFPe_OUN&_
9X(ba(-&,2<NXQRZV-^WkQU\1Ec"fZaMRM<@BEY)R)o_U"U,7N'P^,%+$2Cd3YZZHXTB##2f
]AhcI6Z0U+aCr`S-%H!#Y,j<6<[hgrIR,5()5i:-.PYt*O2G7EFU)3b1q$gWWTrn#UjST2D?J
YroUK,ZKe<LaTAsr0YTij?T&?./$<9k(I"ZJk-3V;3mOk^*2]Ak@6&(;M"\%IY^^)3UgIB8rk
oF&r4\-_>:.:lf$+sPA(=Y@eFY]At^Kkn#'H4a_d^dT]ANC92?)ok6U&eH&E2Pla1Ea\,8MJd!
n=hQWgYl\#8*+Y.d`ekIDA-/?6^mTI4q/Bk@u9O7>6Y>@nn?+3rHlp).f1OOZ/\^O)6Hp9IH
e;8*i;0Ni<r3<a?f'&Z_@"6W<*kB!ZlGc0f4oA).tN<=QWP(r"V5SF$r3,2@#4J,ill;uW-l
>W%%OL2c??ioh5?hO:Mln]A3p^ja2:6uk2qh"LX]A$$#f)U5UlN/0P9l!5]AdaD5>'hde6l<+(C
s7(p0+a^Z%ihq0O;FB#p]A@Iuu2l9jpXc3I5eR^EFEDag=!loq%f)kGd'gONtP9lBceJatB#q
?<`_@KKdttj7Cd5UtreX*H=afZsgnGEfnfTO.;/?RaohlJ'c#KD_h6[Bk'iAeO)P-iSMoI_#
7Mj(t7l2<84`$$,p`k)F+,u3E:CHB!@jWJh8nhFlOR(q'lAs`r"J8"BV/YeK@I366*2k[P+5
or&NP5KGb*eGiuolX8rM<jPXANFaMtI;H1FEZObi8o/u7u5Xn:-.=0cnij@F1QMuG9Ab)os\
_+tLg[g.O>(r;`q"V]Aif*N7AjjGGJ#T/W5/l:r-qs:Y'.UUhVqV8CB!b>bK?9./b,8%na;k&
UKqfT2+j4K3W;&O1o/TAu/(%\K>0XF+fSmm6jSf?=72GAUj`lA>M^d=YFPY'J;K^:V(<liS9
k2++e.LqZq]AUJS?Qhi@d,_$e*,HI9lkOb3P!"h'/^.g4Vm>s\6s.4U7eoLhJ%b"--oLIJiip
>Ng7r#@Q#-c>2e<!8bA>r^'L++IXg,QOi"C:=URC1ShdAhfN+)_hADAM9Rr"<Fg)fZ6?Zp7e
?(XX>p)##QSA2[jEL``^Y\;2DL\bif(^*1#OgUq#(%k(*T_*G2V\?_ZM&K-geWjseYEX&!#(
ds;ZFXT7LEs6Y8+c4KW't02W1e8[1G4:;[&G.Ka9qT!ZCg@pPc?]AdU1s61UDKqSr@"<SE("e
fW7*%e9">'nP6LQ8eFf>_#ZR>Q$j2]AT'-!/XLEi:,aYgSdN\7t`SjJ`+oBb7?!'bH+>j]AtTV
e@i5Yj/I5KD/1D5`)m[J"]Ao%n&%8<(M?F!hp=Zrp!tjl_"&Ri-?rZ@M`XaSsMGQfuj#)*rCg
%:15c.'@q$`W:*/Lsr[$<%#LQ`mtC-!,Lcd\=LI`T.Ii?`rd<o[7HZ-FEEQ^[R@QL56>]A?=F
s>"2oo,.E.)]AHG']A[($\J>L.7dfAF9$^u)C?k7/GmMZhh)F`h+V<=YQDQjXVlba3hQhlk`iM
r!%qNV+_ZaK)a;f<Lo=l_-eN7,5^pQkpHpam-s8FUlR*OV6INph;;Mk(\k3^eFL.KcJX%i#4
kN#0F[g9u,Fa+6ERXI>GR8Y(XPD_>PtD?L'R)JkU*[=NtBTIie-a*7Bh/*G!)mn"o1&$g>,I
OVs^HP&>!h<"WSFXk1AA2.^gbH$eeN>eE$6]A;d\"!n/[AW]A9g0e+2i@gd$.[+rDjm:A*lXU<
c@oc?@bi+>O4ki%3f^ip"g",9_5fN`b'frELHN.<o8o=qNF^`nd"o0c;X+FIQBP1H[S4YXs?
>nQ"?io02?arSEl,8a,(sQK0h'=$6hX\"Z/ho9?Z%.)SGC?*io_>su,VaPq'OWe!F\?32c*$
3auM@0fW);<oMuJ)G"l5Zi^B#+TFIf@k@(@hQ/L.!9MB%=B/7l#C8<We(dQ!A7=p[G$(/Z+J
.S(=l@C+Qm\C_?HXEW&)g[POu^qfT,8PT+_\i?*3(nGA"X9i[k?R`o@F"\+PKh5dE#)cri+e
91\Be#8__I]AU.,!;<'n@L9bo[Uc.mq'n35YN6,J)X#4&+Z8im9/")@j%+?S7ps5%/*lmoE%G
<fO;+F`NJ-?qbV'Z-47G`F/?6CdV38:\O01aXn-4Vo=nIR"`$PHIY,88d6a@:gVUAoegD`SQ
o%hClq#X(h)gq:nSrei7F=5uhCr[\rd,'f]AuMV?!F1e?GOr!]A(/6!7[mmN%QmNjQn$MX!kRE
45N7LW'B6p?9ICSU941q`"%9.,o.Uh,(M>il</G=\`s#?l=k!S?YH^n>IQ;IL=#MfSm/J?23
YkrccUO_jLjUJ*=nFbj#(PX(ho_XAO7PcCtG$41s:*Ka-4J*EAAkKbgY0CeI0AHkaT(Sa.ll
dRS>k[)N1te/Pl^)D\\:/^GhoY`Z?bl0@brD#_Q'LqtXoIJKB?aj<.,aBNKJ`mpbeOa+m'U3
m*_&P$Y"&3'L"[f>>sha?R@BTUZ',B7dLOQi;CHOc$36GS"%S>+;uDT3EU7Z/7%/*WqI$]App
2q0*J"_mtr+OKT!tJ,7'=IX<'eqabce%%I*Sf^QglMfJ4@iX!]A,V.f[?nRQ>)Fhj;J9RI]A?^
_`/8A9pa*Nu)d!&W#EMNMF!LOJ&[&VJQiFPn5/\3rd*(huqWXNJkm+8ANf0-SHm#dV,L3.-j
,Z#`<]A2mR>&<OA*uYq1Wq5WhJ)p2C']Ak*mc.naRh+/jM#Jc8$e*P6;[Qo:s,%M0d\R#V#Z%X
e,T$6Q:)pqS,-pXWVs9a#^R2PIgQo\S<LC_i]AK^'/9kU)kL.]A/`=#k@?VVY'*C(8#%T5$E!B
:mul0#qB%/joEK*s2(qQfpY]AH&WOZ6eD0G9+U,%mbeU'a,s2$E?FF9VC0ie\/ln1P!SuZel1
J%!b\p[r9Xl`@3pB5T1o-.W35@^-.KTf`\%PK#FoLZZ)qAIa\jd^BqG'$;0&@#ArE)09F@9M
-8d=_1.g44;jS["`aP[@/O2l>Q3*leB%%`TmscGe%6O2GD1%n+pA?6.H4b0?S+j%Ca;BSh*f
=X#+dm9bW66,ru!/W)mcOM*$>0Q7V;Tr%F1lUGlK*i+iSdB-e\Xb::NE=%%X>A)B8_2m*9uR
"eGu95,T-5:e$+hAQh(/4d$BnVkRp4$#8IAk_8VnUfCto.mC[GK3:86E":+o`PLkK(T@D%jV
"N!&22pqeA\'XpB3E#?lLgNKnITT<J4%M(uX8(g;N/6,Ru$+39oec_7Kb5_'<2Gd<Z=X,lhR
"RM;rt1.7F0%@J9E18[ckkKVO\.fAdh>fpmMXPn[^>^"SAPgE1J$dKfYir+]AjpMQm-j8(<`:
pqu\Clj2a-5:aqSgJG!ce9@RVf3pJ(YV??L5#2bLOJ+ib4<NV$\!UH:L"h%_B0N(,,u+8`;9
Os@L+RjBYLB3/r=ZVj2Cb3=5mKF3C(r%U<mtnLpYjbYDqdc!t8<o<mGaiXhn_BJQ[8G;R3gs
c`OBWbFLID14A82!RA5%SH.71O:&ZA`Vpoj]A&>riZErda2/WX$k#J,JEgikVl16ZsS"Ug"6F
#?.ll.UjW`h)?%%0n&njS`HPn0&fhPEWc$`U\;-:Me/==C$(lR6`E6miBTU0-<ZP1h5KC[Fq
@SU.NU+ilVg@(+Pl7V6@\5agm3-IrtXGs%2(\8<8G#V1__89(8@7HB9cRrk#P@'m,ua-KocP
Vi2U&l5.()XBS$=$_cOD*&X1FRi>8jj7)TgIG`U.8hnn_)"jl-M?fh#PFj<:8)3$OM*B&hqh
"g_Zk#"-OhH#9A>5m9Y;LoFirq`7OmQa'YeXbg3N_TbU$rVE-c3-*U+h[o0ILh`R]A)De]AFjf
=H<Yf,TP(3erb=#<H_?/*9O-jGW8[r@_O+ek,0be_<!2fkOtX:<MQ^_1Y3*tM!sL96cTOl`o
cQ)HIM>T.i0+Hgb^MHWn8g9D!fYA(9[cTp!/gc:@!U]A032B?<3Y,Yn>krYF\?bp0"J"mSP?g
A,OF6'Za3,YF+K-Od\'8$I/3,"_3G6iR$"]A^cUL,J";t!"H15OgDL(ftjJoe"q5?[KL7E2tk
,Oh>r36bOC,htX]AA]AD<jNc%j]A4Y-E#)CcgqbVW\\]A/&]A/@*79S]ASRUW5DE2"F[W?54#f%U`F
D4+rVciVWlK.;\o4;%MDpZDe(eg?VPN><2?d#m:bbg&fh4!TPq-*jhl,rXsBcb=\daH=#9E3
X2e$T6429"V?ZC,-LI#qh`"X`/JGG;f5f\3gHE'9q/g[g@6aM%HTcASlMJ/$870eA?9QMFG0
-S`bg%$i]A?S?_17t*rZs[1D!j%Xt"(oPW%@8&1[#$1VXq%DtYU$.%X4g5'YLD@\E^TFEXl#*
W9a,GPh)FSCmKMKic4*I7`un(;;`#9`;nK1'B*<;MEZQL4FaQU!A9@#'mdQao[,[^o(kWOt)
4qg.DL,rVboQQA<B+`s8iW+soIO>%oNZpCmHflqq[=Be&E1Jm'J:r@m>*`X3kPMI<;NWZ+9l
Nr_H%KK:VmoPhUEM*MV#%228PIeWR/B<.+/m)k0i_`LjdYGERKZ\3f`?Mp8]AW=I-NpO1O,o%
2+&;Cb4hs0^j)!M)mS9T'i1VfW^HFln54b,i!n.H+q^)rOBEer=fj5L7MUIPmTu;Pp-sbWNK
n)+i!WHgSDbQd9`<D#%UMEGI;-;<d$`e269[DO%,>=F'!ErHh*Kuc^'XtQ4PX;26#85t9j_-
$^;D-'PDUC'I2TVRfJI>9XP[HEK,chb94E-?5-l'[('D:dJeN5Y@:d84I6H.7djq&<?G&*%L
cdMVbQf?L3$Mt-miq@YC'HOY:f..IHFo$QOB]Ar!D4@,l[Gb#.P=,=(H0_9-\TCW6_/dqM/Rm
r&^fIj\P(YL>=Ak0S6`18QZ6bp"@dC$LGup3E?]A:u:"W=i%k34*trNWpQAa%M"i5_N'Peaf<
6/>;1l?mi@>]A%8m(92&a84sBI>^F4%R0%s.Gme18#0Nak`g)n7k$,r/*@m6H`-"c)a-ultI/
S`0PWa"2K[Y:4$,._lq5c_.Z*HT$=OF&IjRC6\++W,QjRkL1I"=X?j;tpH#WpilGBgQT:mlD
NF.1c&VFu'%`g2';UJ-7Q*\m8kT@PE(<u"=C5)?"QfGjsiW]Aps?#hMG]A^Kt4:5r0PUh1^6$N
57P0Gq9uNl-2G7T8mG`&9mcil^KENlDoI!`JT$^(4`4KNgpL_Wh*=*LQD:K'KK[$E`K17ZtY
U)[c%5/=Yb(=RT&8SRlkIuaS_R(ee"nJDPDs7TgS!edAb)Dn?f>4.UHIt?\R1)iA9,=>mP1q
d4\!u[c"*qGS#HFn^Ed;hXXnc_7Ye;L=GB,b,o1:PSYZDG>Q7MXu5a)nf*\SAuF@/a02U'a\
GfDf\5!H0/L"AG#?\if&71>DY8CTPDT7OQRsCtm;'#K=IJ\$D&o[XU<=F<eSSp4F`Kfs2=d)
2;8qpo*NQa,)FrY.5^F8<X-Dl67u/P[o^uB%2[2&)V[tX]A':0Sa=SF+q.P"-BY01\nf'VgQX
Aph'3g:qZ[hFm"]A\s':)\`=emV%#Mgg9!+8(A(IpcsfgWOL?d9C?\u[L$U4m:N#k&(&bfZ!=
@&q#)?`==&Z8q05E0/$m&'($72F_+[k;Xt%/j?Y1@H5;7_iFA-]A#*K'bIl_a=ZeNLZXFQMJg
:p+d.@[V";em`Y7>K3r/glOldC>DUX,746dO3Qdtj9EC5jlC<r+UGI3jE?l=4lim.,-h0r$`
5]A_*'_*>codmTh7Yakr,GP3@GEp2E%g#u1D+D=,hukb<)MV#ERD\g1*Z!YQe?pI[ePV^djoP
+L\-h8a`CB7$X%&O't;*//'fnQeFdb3=s$"9"+"mQ![]A(Gh`YYB4amASS\7)s,#3ULiUU%H4
\S%pQQZ66[)6U\.Yt,PapWPX;B5%c5^)t.Mo$(0Rc]ALPQlqS_I>H-%5;D6X7T=0<g!LUhpNN
X:",1Bgob,?0WMkT-A;^,$)&jN>jC-F5R+[UX<ipmN%W`<lYNpV/r8g?C#`[Mu2OE`9X;ZoL
(g"+D:S,l=J)(oVE*i*\RlF^:U^@(kTVC4pG@#jgTqg`.qVWVNMDkLgR!G7ePXs*c./l:cNZ
48LR-,onEI%E$NqK8JKtQ.O9_u#Z6CgIc3>?J*2tS`/"QQ);K8'EaC+b4o]AYOH2!DDi;lG3m
-asXC*!fh;,\;s]AcDMj0VjEI/V8Whf)eQafl6H>#-H_p!LpZ<%A?hTS_-aA*#9<5<Op(VcYf
0b0?dn,ZI%6^eiUtJ2D>O]A#@`oGD/lf-`K#;J!(X=%=N3-KsB!TS2h:a9I9bS]A'AfIs,Z2R$
9=?fTjslD*gck-i6f?r<fW]A%DADp7o2Q?eP5)f@#(I3>Xe_9VUQ]A@3a3f;An@$QQLs%d2de-
nFlgP1AumM]AWD\.qP;)c$ag"&%QcW3*juPp2+uQIT]A4-=o2dIDV-7i&Sbo!ohWVA&MktGk;^
in.=`(:GmEO0U06)28BInnG<K3(+LV*=Mk25l%cHBS[hblB_O7%gnFfd*0_a3Z;-3[)K_P<,
N-Es8!M-l^8'C35<6`l'&*I_V(]APD9C4tJ$BqI[a`?lU19di074amn1SdCB%W1.EEuF"t\bG
P#G9^/<#njM7>J:T.jjo/jJ_R5&J!HA/e0+^-[WW3?t2aV!#)WtGkdVi@Kl`N"!J9&FWZjn]A
P<WP5uf$>>t<16!lHn4[8X>4'2fM'oY=Z?C4/5OVlm@h!(TA<")@-Gc4q0ks]At;Va7?$OZ<E
a6#LCAQ52;pEh?no')7H8>-tQ#D\hurBR.n_C5CnrfGm4^o`8c/ITJdYMt8_AuM\d%0$D9i^
dRRITjLVX1ilL<<N4Qd/@#RQ7JJCB!W//%)hObQX7^n7b+sONYp[HS@GO"iuE(^'eB$*ksSu
EC"2?&l@8MMr2P=3BPMZfcskeLaO,nfb&tE]A&K)5h)/YLVibhr.cpc4;J%&&%%rAp"D5"t3D
'Y-X/#&[Wd'.IBTgK-g&P1IH\4e^UZ-jr\q3:-ZXCjtbN[Cj<h%B2V!-cJ8nGYdY[]AF!#e(U
]ATJPmS^>t=2X+!lOd^1?/9#I>[)__M3%:Ja08rOp;ghAsPWLGA8:_0G"2C\b/pV,+^^s05e8
Jg*</(8>c)4"`t2p2pu+/o>[Y>K(EFcBl,oK6^3B*Hb>lA2YAW$C<^X#g8fg2WKZC=+>T@n`
*N2(]Amd4b(17A&ZLVK&T":>8-C&916P>7mD$$#JtRW7%Q$dk,S=:(7jTYkYk9l]AfA>YsAeN2
(<>nJc<f3dR`BU[Gb(7EI+W0@N&aJIdYBCI%A9qOW&Q['%VZdA@=):d+QD16*`2A;I-]AXLi6
8qBL,<X3Nc'Hfo0'g3l#]A"h"0V878'9'!bJ$fYuE2D=r)d9=7N$]A2k_gc?DmJI`kp_HrPLYe
AS'iA-'8>pc3s+G/Gjjg!Z(;9Mg>fC<d)!C2`n#bD@"V<AkIIS)Reus6chZ9m_WYlMh/GskP
_JjH5YqUm4q4-6=Oh^>a]A0"9h%N_TONHl9BSROrV[T%s#>#r#p8*JpscsER+Xc'rZS7Z8Sa<
ptr>nOmfEEW&\:)k*\nDA-A$\c/tQn_/QCYLBMPH[M9?>P#,rI;L#Daa&m/8IX8#''YUM"Z$
+lp'5D0eJIQ.XJaVkm1Pk]A:%,OK\7.Up;6R+,6(<fmCghl)Hd>fSViQe$`$#s2WAUpF,FWDj
2fH>AD(Z[$iW#'p:p96GsHr/9dQ(YM!^<;e-GtO$]AB5A/m?<im5T(&AH-ie+YJ>)6,K?H7mA
O;iI"B59dT>Y!Ol,SW.&0O8cM*P3BbQjEV)'&4aF5[GKlr)0CH,q2,EFJ!"n&888JJQWN9L3
\\qn9s6kEAJf4ZO1^c(X1u's5^6hE`(jDgPcEH)tpqQJTX+Wqo.#+u5,3]AIM,)67AiP#'RP-
$T;R[DYrp`Wu\'dQ03I/B:kpWl.RGGS@FU8JdAHlB$3lU,6\\)"#r</C)[[nL_NJ?Ceaj]AII
H2;>kETL+)lF@.6tpCcU0/E6a#6;"lr7i5k.^K+>30ATmsf69:gb[r5cdjnD3Fs(]A3@r$BI-
Sqm5O+"P)eoQt=+'2[!B^5\#P'=Yb\EZtZXF5du%\IZJgV0IgPrZ;,fCp%U]AZoLr78$RGBbI
uh.1[5XCiX=!At88od"dZ1,23'h]A8+J>=,!#bNb;*4*(P.EDVgt9]AuQ,lWWrb59Znqu%OH%O
8*9HEg?6De13R*2]A<tuU9oi_f>M/WkW+C-:A&14$ful+@%kPW[pZnu5X:M3kBIM8TnmDLlp/
,=b7h4=IjTt!U[^Q+C-LD%WFs9=DPd+p9afMb'F0l4gYHH6emR<4E"$)cL&()Ujjc:E]ARe:6
$G*(/(DOsAeJnlSUn4iM$X^:6oi$iL1EG-S5BE(nK[##4ir?/*l.s+/EA?"TlaS]AIY216<,n
03*fZ]A<l_^4(nZ7h//6LhuEV!58^9AH4u@O?u2tnA3/9*I22\.<pU\IAd(+k<6>4M]AR/E3'N
]A3R?b+$nMe2p&9."F=<b1Dn'7_L[*.lG-WNq&OTE\j&oB3t$WB*`QiZucQ7EID">:9$"@-Ud
%^X$Pg>(D7-WSrrZHNl4ldEkSo/njZ%2qHM$aK2-XLuYLaUQ"?q<L6Om^W$_5Z%9jXP(j':9
g*'3?4aEVTSY&5fa6;>a-6qZM\0D_2,pqQDh^65n/KaCGWZbT<SQ9YCQc(qUpuP.4=PQbp@`
r)&<!AWVJ&Oh>YZ^6j3L!3iq6Be!R.I[h2*9>@J^sNI]AJZ02T$Bf!"bF<M_,(0Ds2r"9CHLj
%Ba>m+S(,EBSOj!^<)2/WZ5Y4,!5"XRD(7Oi1$T3hNZ"Mbc7UVSFFsY;DH%;+?0FQu,6I%o`
I:JLTHE.62NPIc!Om7#sJ$\8Q*M:PNcJ!F:*RL9J$6b\Y%p!Jc-V[]APg5]AT$Ts^A6+7RpJSb
f_KcL'A0r_Z9fce]An!8`UFg+^q>X>(:Grh:A#"4N1^cDImU^&]A)4ZT[%8<:0C$nClfLq+.<V
lfK%k\=l\f/IG@A^R>j.<ouS*,G-MP%4XOlB9qOr89E:&U0PGmYJNF?0s>%^e2M=M-"qqNoI
+M\^p,rBCI@fn(X"gL78:6*:\pd"V?U&lO#ERjg]AeVn4tm"T;o)Ahi>Xfp(^2A4RGZXt-IH6
8s^8OV]Ak7bl*TMi%LE_`QT4<@Mm%b'ghT_M9,V4h"\W"!*5Eh't\-F)jW)4ZQaf8(#""caGo
9<!o[c!i_KX:B(0rV"5N2X8U=CAG.2fuV"AU'JX!r>@<WBb_$Q$Y$6*KXVr7FsWC/llGD<;:
!+:s0O5J[2oAlC*TDDh!1-c6t`K5g>UH]A".+)Wun/Le:G]A-pta97VI''?&hb(m[E%`.bAW5U
=Zi.Y[KCjSH&dL[.o=gS4gED@k]Au/G>^_8&gtq>[=<5-+`A1?fH@E'N\,V`f,rBegYG7)4<l
2FI(OQ:hVKbW^8SlKaQjn:5`,TX8`@j&P+=7lu%D0fTrl"=C2Z1nC@2]Ar7`t0C;NjB[Q&BH(
*t0gO5FF7$^(>j+Td8A<<_j10MNkC<&<r8dKB34(Qg=dp`.k#n'XubkJ/AZL[rOIcjc#!Jtg
f_G5$%Sp/O@GgYXut<C24I!8lk"^$!a1$8DabIu.Q_#o)$D9.<4e(e.]A'8t<5C5G.BBp"(85
SB>eT4/Q.Sf3i3K!_jq]ARM4pU''&lV_L=^>n"[j?XO/7K3b0+)VLo?GHqmI)ZCV/-Vst)<GR
*EXM)JA06##b7q$%,tcja7@,GtZW#>tD%Wo8`[NAsVD1_RsYcMHUB82)/Qg+;M2D*PUj9:]A%
cJf#SNU>>=nk`EloMb*N]A^XjkMKZc,YH&7Ud7O3h7A<qo"hdjgAN?Hc5"Z=K$99>A%=eDBWp
-HcKTpS3I:!Bj)?-PO@p7*Gn^Klm7?YE$OGgr]A9I\Xl90;%njc1]AQ2.)XJHOW,;(i@I7BqJ_
AWWH3*[ZAS\=aMmK7/2#oSMW3M*TiCh\pKZX<Glempi%9VJbHDr]A-]ApBSG.BR%Xncljs)n\Y
An_8iP8P,/:%Hojj?G2\k6:pK8m["No%R(CV(0@IggBW_iDq)g_<:I`Hi//p5?F_FMh96WI'
=?4[/-fkMtJZT0Du;eX$2C_kJG_uh>ZX+"Z2]AJbRcQCD"`Z<T)+N&2DEc-8B6CdaEW7c9gH6
oJ$e@ah[*]A*guN(22qD#=(^-Z9-b02Q$N,Xa/NshkiC("WqK!UJrB$$_itXdB-c[NqRI$@I8
q.PO;h6IJ&g9`<c@7j8N[J^]AY@M*s/tdL\:3VZs$C,^iO&7+3p0qne?lC:;N>%0/nN=Sq)uA
UP;dOs_,19ITg(M?l[MSRkf2<[qYomUX&1^"ORD"Ylkkt23On1st^B*bpZSBQ#LBmaH'G7.D
6!9D]A87<jca8(YJ6B8Em_7dUdLMCE`?7g7DK\^qB`BS&8;;TbAisL)ipeQL&@m[(t^HKMhcY
7c0q@Cujq"k(tD[m=F\&X1h_Dm1crX>%.[jof@!LV9&TUu"t9g<<2)>M=cRYQZGFFPY,$c3(
ep)Fi?H*4$hENG^rc^)0D0??e&7<7]A_6"\X<0[<mEIlrmO\0L16BPPf:T_Wf[[$/:h:S!OXN
k%OF1KY\pb+(8`50G&OkQ>#/cYgYlO0k1h3!<1p^[HSr'KQVbnaPr2%*J`(qa/N8&NiW_J!M
B4pqmg\!VW7Ff91:\%jXpHNXo']AT4jGu0%MT?h06X7C#4iXliq)sB@hB*"pP!/?J\lWk%>c!
D)4QLeW+:9:mpmYEsD`'_3'4"5o);h2/"sl-@5+shfJJF6(*Z;O4]Ad9it&c_h<2c6=1\Z'%m
sHj+MaLseuSuaSPL8ph!=p4?12(,R;s:4B8)/R55[)V^#4b"[d!B[=(r<5_I:G3O*A]AGlOR,
(SWa4gqJPEqon9tNf2o2*PDsT;j]AuT?$`.IS3UVf<#<2$U]AZr@#I,8:!YGG*<s.tNX7Mg_G_
VsE=-8'GumHK]A&oa,2!njYY$:-*=Te`C7\PC"c+93-[ag.m;HUlkU3X!=#`8<$oXcCtiG0Fk
mQ9hm$9Quk)kg!CO[?&(<Y>XhAXN<r`:$%P^^5T._KjpN@J2#e-6h"`OIjNP;nO<oT"ef0n;
F0&(GX#+^E$s"?nRnC>j5<h:.N*CrSXDM^^K;G58CkqkZHYm_Qj,:a43#VRB<H7,O9`P.-j&
:d[jbb$T+kOYq@oTVR&99QY\O/]AD3BA-Kk\pqRakS4UAG0_(Lm>MkC`gULR)LcRId\`YrV6]A
e^#%)eo6`Zmce%L)Lu'5hGV.MJ!#>D'8,^OO;s7?m!Yn*+o$2UCbJ+51CM@0j]Al$@WQhZHu]A
$/BZM]A%!D;`[@"\6HoX>5ptdTg/0X4t`LoKCB>sJ^RmGW3S3P<Em76GR"$5e)bYmC@!Yss1e
R%^`LETf(&_\W%7*#;m!/`AVEL$T,d_cYa*12i8[6tkpOAP/416uJ"3;GZ2:\(FOA_?2IadY
Hc)R+3HnGrhjcKSrpDtmSoLK0Ke4GOK`8dTeK>hB5tVcY(RYPNk?NfA;A:k7DH#)9"5.V=hq
7@6@NR@I/%['P>`egB.lHjIAm1ACs39uuEA)AUJ)atk%@7(1"b)^9]A;OfJfhtS'`$ic\?t>u
WoYR6p.[*-aMt6oI;Q>]A5\qV;"r1D1>Nq*0!7f9U/*b*e<cKYu+_k8f`koYnuRK<J88KF'$4
N0Vor]AUj(?]A7>Pj>7PRORp*foRCR^o`f(327um_?2S[jr,:QIVo!?-S)?X]AcG2;.dSTTp^;G
F\WX#p%AdN`q:?p)2?/:Ie%=,H2MR$"j.L.(T5J1E4#P>2g_h"@tI!pLXY=BD>GN(+=g0^n$
[&Tlb*+j8$B)FU4M6hsKob7=XbRS!q><]ABr_IfA!<<#.9i)GEgEM\.Rn6nDDDTFWW^SDp'\>
R8B1WoRP^Hoe^E0@gj\$;%p0<=GrXDu0ZQ22>n+:3Ins6$_8+Ci<n,[#BIclYR!k>#j<O)`\
IJ\HII"XZOlc]A>k'`%5fos!(nCC%d*,"9kk9N;C.e&%PaKC0'iE\2('gWXAYGEb@$'F5rB:G
Lm18EnmngjPM6+M.7(El+?tDq&eO+!0DG&*4rZqNNo:&r,PpBUh%9Le6r?0>mY;^kClf`T'7
Ko<[gJM+ZXaKL7#qt(ME*04SCMu&\&$Q#JNR?br<rX'N?!m5qP/.:?l3`o5m3%=MCc:qFB![
K*KIZrjoSZ$Y[k2%rXOIP6CO:;,OV/Uu&e7,4\3dm-C$UYMoRFeH"R#6n)t_^$pgJl>JK@@#
3U=U*2`,aq*p4?i`==j8[Rho:eE2;<0bGosS^>pB<+;be)[Lo)nphi'VbGR,^bZ\.3>>\@kc
;hRN.^bjpd0"7CRU53,(IfP+T`.'/>k'\o#7%U6LdWiVrJ/ls@qH).8/T2,FnThuN@BVd+lJ
eZ5!IVs7S(24DYUHDVAHTU>hcA]At9eN\ud!9t+_r>mdjLPKc]A/n6M0Ll9O-=[l6sGYo[]ALN`
/ngeN9E!7Ycn0@5o;L+a^Pr+)$u5M>HT"3m90qm']Aa;>/;_D<X+^NQpaCm'laBZ)uo!lj5"s
n(c[4"7Z-F>d@a.oJRl^f;<,cCUeolGVR'g\CK"UXF<(XGg5Eu!Js%h^Q&B#A)`^"[KR!a[T
\nW1.q/NgRE6c`F$;cU292/AD=Q@EG)aUr$pHI%hO%67H<(-V2%m>1q2_"!,`:ecA+lqh_O$
E%X7\L$%K$$Ib09j/D(DbICsgmX6i>TiN3dZDpE@;1D55k7PC=cfPoeFX3-LXmN^]AlDuRG-M
iAP3F*S0[DbQW[l_ajeq@(.+h),K=-4DnM9N9!__BoJXj*%!NIa?Y?41XeM9jB@MY-LEPi1:
2.TP6UrCqGGW-*XL^Da6H,M@g5bpA`SZa9_`_K?&n]A\,H;)@j"/M:@;!8k2G&`jBetnG3OMH
_mUsPg%'dhKPcY9$"-7.mDchLgBoFcs6!El$`%qqCi^92/n4cjcq\D-Q?^'e[HMKkp;Ojj?I
T>m$]A2rA_InCtT/^F+TtAQ$oX9]A3!'c0a\*5aM??WE&le7J<bDQH"0-POj[l)-EB$9Ip;-\F
g<(4BX(;b5RJ>).9[KVTi-q)0@h6W*k9"u':)7A9/l*;K%^APG/L$t>P.R)uQ_VcHFNTXNTa
dh%I\DHbk;o``I,$Rg9Sh*ugG.[QYK7'JR&tH:pit#h0e+GjcK5DT/kPuh,aqeucjE;'-cQ7
7o]Ak[=h[oX^?_tSjk)sI-:?A4YgE8B<h*'UW7KfpPTi-$>UZP<jPRrWBKnM*:"+2Qc1gHorG
Z=h$ak?"F0b2^2VgHFMs,A_1.<rqTbo:J!kQ-F&J2\eTU\d,/5]A5,c#d7-:Z,e3jAJ'J.8G3
JF6Gi"V8&h%gE"igKrf]AH\:nf\f.N[X=D`:nUYZp3:Mci<V&7,a@)_i>@7o"H[j\GtDEp:fT
2h;iupA7Z]A%#QO7F5lc5A#+\gK\7!#GVcU:_1\Z@NEL$@sNER3tFVtX5_nWoWP^Vo'rmLNn"
JWt%]A?d,H]AqSaYLRh._hMh;:/Dj"h!3rt1i&5BDZ+jC64T6illiCAnme1DZ2i0p?nI?f)Y!V
"&bCLF5JEP6\V1h=RTe2CAndbl7hW+BAfBZbZ6+G\[)O8>H<,iHh^M:4MWiuku7p<Y9HT"LG
.iL[_`[%u9*4BbCG20GHHu!k]AH57tF-DP*7\`_8A1R"`Vn2<@^6>PTm;4qgZZXn,!jk&d3$0
7cg#k7j,MhcW757sa_?f9s0)aKMacNVlP39U$W>C/tu805rXe@d2q/*mV1json299KK@3[9,
/&%:8;4N$=^N;%RClY1U`WG^f\o6e;Xl\OqlY8OH@.3>N:$<Kes10,_!"Z6nOKQ&,63MAOD0
nKi'J)98<@8q6g?F('4-nD^S=Ln:fe8OscrY!B1@X@^P'>#^t^qpO+9`RI>?^^iG[a-KjL-*
Zhc!`.4&d_m!J\__t[(@R$_,buNqY#.Dq#T8GI1lG7\_EYfC;4"%]AgDjYH-klB<-[aejWB_]A
"PSM/Nhc'D&=:DV*%U\5%,Fj`#W-2R46tm-?<,F?iWAF`%3Zd!hsnhYQP*)bH.)9kP3;Y:pa
\ce3TBg+d*[&<4dRM^-KdKAW03HuKh'lGs3@qcI&U>_6fdWRb<k\Mc$R<j>I*rb]A7;Fj'<ZM
jG0gZ![IMsUnARZ64)JlC9>+HJK)J^U+j@)Q3KsCEeaK-\;/kF=]A2rIMSFG\LfAmG:Bu?YGU
)DU6p2_D&(lMY6+"M@e@CPORoiVAhc&@"/DP,]AabkSSC0B%5M;UQ#:!lEL^hq]AeY[V1'!X9.
dQknC1`UE<9W#]AQH>Kt1m5IDpfB6VTIVf>n9>5b]A"eHk"Dljb.@d#%c:`hg>0(`Bn0L,bH9Y
'8I6YU5%.U`!Y)`=4j8UG'A#Lb?a.b#=3C!iPP>36P.tZ$4GWTY7CLd<968>$8]A(,E?u09\P
Js>q:`Zg!B?!jc5T5QWiC3l5N+Z22Z#'<VT#9`koYi=OE%a"AAV*_o=N"Jb*$K`.XgHo&rf_
d.a;\$/#CSC7:aS"3PGHQ:,@_OCEnVn_INSlXooO@o^0+]AF&+[pA-qU87]Af6dd#bptGpnAl]A
6LJ,*i^i&J(cNn?,8nnD5<XrGs5T?kGuj/nhnVp4'<5#F6LN<N$1"'f#_%L`A*##qi<f&nRu
0V8\d,bLZ>C2X]A(^;lh/SQ*Z;$R@M[i!Y:.$OeMPl[R>L@4C5SK^8+DU#Hhs<nK),p!<sO'^
==bMFWF)@p?_32mr._^Te+K?O]A^i]AOg/9&`m]AAN\GD2*$Jp)0kI\i;,m;;B"_!,No!m3&2r9
u:m5C_tn]A<7PlHuRCpPPK5N"0p7J3#16)0u$u,rV.h3kEtperDYD(E(:?UXq\_(*=eVS3XNK
LHcsH:JQDE#'VU*=AErJeU=#&DVn&\]AjGlFXA9+7FGLr"^kQt,cXJkRM-9\.BEgdHnNIG:jc
=3UOL;olKO^\gl"%J$mg>ctB73LX(q&qt7hchsMoB*3i]AhJpYY.2">[_a1is.%lAX#A+*BT/
.:<=`I=mrl7?Im'd0r\tV&l`2WWU@.![O.bXoNDuX_A+C3,7Br7.i-Wb_Ep%-V.<u%B<GtCX
##7%Z_8n[nRYQ9E916X]A[U8PUGb\LUg;VE3$hL:koB'7FQ'>TL0J)3R.7CkbQ1W\'?Kg3?4H
-a4\[bkT]A[GR+EIcDSc!-^h)NV=_L>s&E4AlmroDgN9IrY#.!(gHgm3!d[dU[-<qJ+[>+/i-
eSD3OC+g0!9FnW@JCA)_R*g1Fn$uKP@a]A".,?5"lWb&*b8NoBDR)9WlVFn0BnRYVuF3%=*as
/9S!k4/ER5K_\\nDY<tEr"[fr?O)'30"uoJ#1BH]AF0=3_<KsbqUGsYT:574dss@-_E3Z@#rp
XucT;,:NEk+FCcrNYAuqAiggN,5>.u>lpRq?):O=Xc*"23&CpD@cR$2YNX-ZB$>-S)9c>*\,
c[Bi5Zu\)ee)7ZX06GU[D5-!d!;>]AaOSc5N,sfH9"=oJm]A"7"RV@$6F=kp[Z>YPl]A@9k5Ra=
/@I8$F<bGF''uBjR#6+5SNc#<;tKnA+=thF)E)h^?KG*.9U8La`ZE64;u&pB=8L#A)VY%J@b
!c1Y@'53bC<S3-qGQob\J_0)W3+*-Y*MN)q@'/^<an>R9c7?K[)B[k]A"Ikgt97YR%c2[7:.'
jrjNan1FZFDq[1g_W?"S&8d6D+a/p`,^6/blD0[l^R;;O,)KN"igLOZi)\H,AR&GK5Bt&7Y2
9`-`Qm`&ra4h>1\?V5T^o:552Q.;BFriaa+T$FpgQ7(^GSk\7Z#e+`^aUCfrL0W/kpE1GrMo
TXQ<:4\YEggLE&`.bCL&P2$$;6Hg!-X+1;uM29%,ic,$00KG?=jVd=ZdFIsuV]A$kA<PRs-Wi
X:,=+2oiI>uWfiK#TUg?WK0*4sRK0^`]AdR38DCYL4b+Os$(i58-Vf&L'eID:OXamtBq,a"6.
_r7R#)[km<@V(41fQQQ#3.C>Bk5EbX[_OHnSb=<1m9Qth/j.1%mPthiIpC_tIJF3h0%U_)J@
0YLCa2p,L&F;0Q)[m#""\G("X,r4aiP=2TW-;M?Zb;KS;Db'2qU$FrY0!Z6a6Q$L)b.@,Mil
"V96CJ)O3+#0M(C=kg2??W/,@!KU5"6U-aP".I^O:$N!"`\<^cmk*m$]APU%.40L"8$o(s3hD
[`W5Ij8RBjP%Q/Hi_nf"NN^RgRo#/#L#$eA3)Ve9>?%<\i7eP%Mi0a?0AeFP$,KF7"p9n?GR
,]A^U7.pPPB-8gU92meFTJ='T:FWc"\IkAHqB@_+@cm[IQo5rFNelrrrq-MX(F<RQ^a'&p=dO
QTAC#m9-f2&FN5JA-YEk,15a3<B5Qd6NX`4B-qR:;;ZSOJ\\]Aar]Aa2S]A]AVH[FO&M8@;ab\5e
B'4<)<>7oS4!,q6.jo`LM'Z7&6+S#Dqn-bL$@DCVEQ]AT8H=[b6hL[G1Lu[m-u+\tSF^)?G2>
El$[3'OdnBj?Z@.@NiQk$oH<[@l#g,<VlQ++=S5gF!hNMR]A*C:V3ZW5Sdb%XVllCYe%,R*k4
)JdH(a$6t9`>H%9o$pfU<:RfAGRkQ*q?C,qk&L7?KJdo%CU>]A:jsNRb@b3;WjL?J1pa#),o=
7+uljP6trXd^`MK!lZ/bgX9>P+RhGA(^3nU-4Op53ACLOBEtkmOgJd^'nBl1-@G-2/!YC'n4
flP'_+(0r[k^%_Z9kJ(\R20KDP@Bm+U5,t7IR;or/CE0OS'bltJp;Ko#8sd;D)onD_C2D;?.
\h*@Ab1LFkE@]Ac\,Rt<V5U3oEV_/eS;m"N6A#pE@h35Dg=_sDlf06]AT"JOB^H#Ka6-.ucNB`
KEBp/j=3l^%TGdcA.AX5(ZcZ9$\hsT,G-m)\]A71<b2s8NT!DrRc-q?f:\g]AY:KbQX['4-V-5
<R_:2d2%:)73TjNTt/3"6b4`HSH15'(M0cc\1AJV?P-i^Q98Y7'*6E0C/UN;`5O[\7_fDm!o
TtrErok0YsK#)!=Y6FB7*SHHfm0q,&6Cs`>qPn?#3eRfk6"DH7$XNSA'5.aPQauD=pgQMn(K
a<_(\W^7I'EgXlKuplsMMaG4O*;9c`?UJ__$Y<.S07oSeTa4t.$SlbmrPRS@9=qZu#*-iRHn
Y.Jtb\X#M5Zi:dV822tDQJ_=gU/Ge;A:kl#s5J?i<UEMoN=DuYR?W7_kCK.iMb&0JYlLU"8h
>seP!kLPQP:iPL4;<'8!(j,?LTf;U%m4`N7G:FfN#O`+]A,S;"DZYohW?`+E0<C(EVpD?ApZP
q;[]AJ\8%9$,gF$!-q$g\iUCD;Q]A`$PG`uU]A"6HVIq*\@1L\$ku#'reL1hu+MpkcnZ0<M-'Fo
*(/]A9_m,3+@?^k9J,7IA<@HN8d=K/)j'fC]AJFC8m5<Cmcjt,-`V+p`h3'Odn%,Gda1Vs[KG5
/<AB_XR;RhS/OD[&Bk;V]AmDZOXH^s/iRA[VL@!Zsj4Ef%fI#;Mf7[f,j0RmGp0K[[NFnV)KL
T#d.`NYM/7eW`mCIhMdOQk_jJL3mLh2:('-3^5S:p)JGN4)_rpg[QYG4EI-^2eB%d%*>G0HX
jK9QH0KQ&!XQ4'JKc.ki1<,FHV&c@&ju]Ao=C(GMYoO'+2JSEagJD#sFYup.VQVcpf<M+R7uI
#YacJW?-X!Oc2-U1CL`i=OF5NQE$rlehD-BO*Cusi-Vlc(;s1Tl9@FYKPHFLlY6pdLI@L1hc
fLsa49d,ei-_f>42#;gDBXO:4XtmB"cUhPP0;n+'s2EI2!u[,MGM9W7X_D!7:M0i0Ir#3%Pn
M"M,VD)L.:fh+uO)Oh@Jd>2eQ^4Y@nUg'&qJ;K.kEKNtT-i3/XXH-M._iB"gic>qG_/%B[[8
(&4i1bP3icTbETl:,Vgh^Lh^Y8^;5O82IZ5/V_\$C5q5%8AJb,[mFWKr*HZ&:ia_?lu'c!\C
1qZ5\[`:3tetE&s'Eik4B\9+d$298TkhEJ2WV;YucBRp#9)GbY.N,d3OOFa/(g[AkIG2:#Gr
cc*5(OX0VQ11pHQ2+HC<[h%etZUSTh)n#E^`EYhFW/bFjVTNMc^7cqSM":?>B=##O/AR-.-L
L[F`2_)6[.1i`0*e?p//Fkp<(r$`h@=XKp)UMdQ(d/VZ-Or"fEYalD*gDs^Jn'8\+hSfheVj
"-KeM1I!tuVd<orILMfbPe21WOgp*5i+?VKt@MZhm!l0)HF[*2SF]AdQIj=[1o=1_3_QBX,a#
W$;qbtHVP!Y=6E"sBnWeLS_W!>^Ff0QMSL12%HO6gl'b-Qj4]A.p[h*oaQD9btWT:Yi<,2*/b
`3`6mS`7PHJ3!D!]A#qT/)BTXDFRPPot6qXh7M3RE/UDF!m8;kefmpR9e@kd&)pB@X*c&XG7E
aZRsK*TeBIF1?KQ>j^Su>.c9FFg[",Vf0s>#c7nC?bpqia2qk_GWeRFF'fQUHJoW!iD%.\l-
Tf9d0ZcoQ!aX[>%tZY55r2JXYW-r8T,V34PZ]AG2]A5\fk)^m@l]A\+pDW.(^pa<n9hl.[Fg(AO
q$F"*_gG@)k0pp<[gQE7tmT`lkOnX$A@CH?,,&>3gT.E>45;J@FjVrSaG7TKA4JRdednertc
3NoX@9EZ1#-Y>kPO=Ja$GD,LC)Z5k"=s(&*P%ap*a0o_RCI?+8h1X14[7dtflZ'5Ytt(N4[K
Zm)LM2O#:NAa`3liI.&V>(%/&DFj@A(n\+%GMEK**j4T;3`'&*"G<U%)p@KcUgY@=/4K+0i-
-m.po8P[sO\kY?QL%h[LABftO]A<\@t<N]AbSh?FP=OZL]A\Sd9iB(WUr>$b#LO&DfF"4rfJJAY
UF--2Xd[hBU827l/<GjooV;7!crBibs@(Y-Y#=mr'M[ST*QQJSU?+ed3+-'efd(8@3=BenaB
qD6q=:J+rb>]A@+6_4FDE39/M^\@?.j6T?do?=jM;:j'?1"U%<d8D^+M5_4-N)7q8?6J,!TO$
u7=WI&MDBOg,msfMo$]A'Cs42B_4...ILM6<7.]AAii/2pEFicK(,f(/@5V!(;0-RsZLR;;3W)
.O3jU*oTc3n.`MfN7*fE\[\k@Vp^A?&OjYDW1GqaDIiFb_e9+@'+Y*g^[#;Vli5'n8GJmH74
Sq:i",ko^%.21;UV#sF)cS<Z#"&1^bc&K@+D/(+q-<bt;/A4,8&<;1[P]A)\u-3"[5kN9I@!S
ZT=>jk<-a^]AH5dSW4"!@ciVhD32X=FU&1D<bEg3ClG;C!""Q]A&)V/cQr!ar.Q%2.@"ip[gUs
@+WheWHThL^5D(X5Mqq7g8V>ZA;^)+NDN8[?Q,fQFlS0Gt.&I(>$E1ct]AGDHkq-')]A)q(!Z#
e6//`-1AohH_lEB(pkJ(r2nCk&5up4Y7^Y$C9Ln=1klXdrFZ0h27]A56)N%`ckkW,T#j>n"Us
ZP_UmfV<*tP3K:A'W5JE,.39ES)Y1K!CSFH'PZs7>B^#^Ko)D7P;n80<AkcL1Qea0>.3gP7#
GrOfM^\P\+n<:IXoU-,^5RJojV!+h.R=Ih\I9YImRfd)dBrpW%jIh]A-!0hDZCk;-p%Z<SoO_
DQD*4)GId%H;iS]A?,;e(21oD9NM0.uq*aRM%E?Mfi*h?C[-K@6Q&FSK_6j)VYTDN4^Gi7`pe
<L!Kq:]A1P+tn[RFmd;LQA2iZS8Rt]Aal=bcVhB;2t8NQ6\@Xa">cLD0&N^VT<_p]Ad1"Id;A:o
g6GZ%N97r/HF(D>F<Z$.+(CO\1OOGW^crf)aYVRH%Q:b#q8%M7$0#F(:<&.+JX'2Mg'nHf5r
`JrOVlkEV_/ah)mI5#F"plAaLJt/X;GdKpl=cC5(<BP3j2uFMkG\3Y7u\@d1@_c&"#`-$lMN
IK59i-Q#6f#,(pTa_tq/)[T>XLZF]A.]Ae;nqGior#G0.'FJ3["5fY)kcBWDW%9<.lf*$.k<"4
'lY%c#l^`#bt?BijGGZVhbeMKW_*f;`PN<,ra!JCU36UTah0"^-$g!b#*5[F1lA8HV\bfs`Y
68+H(Jl-TZ7EZZsF_3LklG5Y[gFK/pl4sTR`ki@isk&b>\FqV9XL'S:1nXILiVQKTIMd8p64
skeeaj0Bmn0g;ajJ1*_rG3V7Z3$bKi41`^rTMJ&HubZ\c=A$7?^L;"6=k>*Q'U6o^JndFK*S
/E<`g5_4R305e>gp_faO%!G2soA]AplE:$pA3TVtgLiFiupc6L*,DAZeJ5I9EE!,eiJim'C/3
_NhIki(//J<U[,"Qe:SsmAr'6r!F/L'H07f7)lb2o:oGM'*DI9)5_P9Li?I8G_?AZ>6'rkTk
KQrA?@\N8QO9-o(#@V2-OKnkJsos]A&SoKR4Kb0ngc[IFs`H9rGK>ep1WPkRJ=U[c*F+U3K]A-
K$A^A7f[BP"HF&f)"T;sOYs.@rnOSq]AN/k3qc&n_X")QV\V&s[mq0>a#NZ+klcS(P^$HQ#c1
fT'=9_$r59S,L('bfk"$m)";6_=;L)2ZMP0X$Ond&#?,2L:e$O1O<mj`sUYR\U19fBle'8eS
<ak0n#XpX5abfuF3F>1ahJmi)H<>/q:t1cP;``.dO[Qc@mZ'F6%=9ThJgrMajMqb.]Ab0$Y8%
9C]AZ:!8Sb\?BKhnP/lKQ@L2]AoY-ocs`)p/<mX%i$)4-&7?5[GK1gfBblC`4<,6H#dCUc1EIt
_ZSpR!`idVk$=S4<Taqls47Ocpon3pOBW?fFpI\02F[^)8e:@I`UPD$psD)d2-$Eo,n1FJ?<
e#<kn=>:p@<FYmdlRfXX;rtGg>mA^_bWQ48_no1;l(DZf;NT8L6\8eBCMlG,pFMq+<?'`m3<
a3(!I)oZk(W0@4R.?5\b7uc5FG-[ki(LXm`5a=3brZ@1oA0gK&h0p;KNb,c1[6jGlg[?U9WN
;89H"oq.;KqqB+-YZf8LqgGK*^k>ag\,pS]AV70mgIk]AehdTBl,AeUG4D0nI..iNQUh"9\)?!
I47c/P=<96Ac/<2'YtVT3&3l8"'Q-S%DiJ#)P4TE3VpaK.o9NXf[a5Ab,aAZGS2+sMNSpe'Q
P<,&Y>M=A?ea6;k_NKQrU!_hM7OLR,]ABkmL[4M"W^mU;%/ttTi_!3f>2M$+"b`1CjRti1tge
Rn-XNpDqML[P,d*02%X3(SEMKYS=:8"1C)\HM"A$.4Fc3`/fc(P^UV83h&]AO]A[jNnI"C<E01
9?:jOa?IN0qQ0HJmDgcU"(_^SYV[hg>`2gW%0HgcC#JdTZkoe?ce.Y9i)&u(d\Iq$RmgQ&,h
(oG%XVK\*5$!f%/h<'WO^f$(Vo"/\Fa[)S3H;%G-r-.LM-(ZQm/P.j3m$g!1cr=Eb3/[IKOh
ObkAXQ/D>5,9hlKOL^drE9X\86]Amsn_VK\9a.EniHDE!$r`&2f"nF]A"Xec_`Cl6u(.==EeY\
"W[W8m;KrCt5k;8sUT0f/SW1n)is-)jrN&@_g!)"a5kountCA7MOr9K:^k2pWui)fR<2BY^n
k(6%IW+Hp1?:"kI`_MaM57NLWCEE<R+C1;N[W`C/oCT'[d#dnMSVWlr<b4H'i+6Z,F']A*-\J
#045es.+4B&RI&&6a8>#?20oXKrHlO?"8o/oEV*?,m28%^(cgf@Jp8^f63p7DU;`,Am;4VE:
\CDhZI'rGX2B%&!hn-k*TI2X^(qO.?Mjab*0r+l"^B*2)^,[m>e[UI0[]AiL<8EO3h<hB^/E*
mn-IIoI^@rj+5Bq3);*dM03!N\$RFlWA!#?32WWdT_bB(AU;K<<pFU<S=k?\j"h]Amm-sO8jn
Nm8U7Ys1jZ'uo3S*\_S+(gE1f,f7EB1<_]A5E"&e17!kEUV(gX_M$gG^Me.BVtT6h/'%mae,g
enkX>qn,[q[Oc03"6eVo4h<(DN^Y#4S=E1GZTIpo'fC?:1"055:V6R9:LB`TpEms+"BFgrEG
E7(JEI6k,6H<V^T:8H&`($2N=X(->JVH,B\i,t'lj`01@(uIL'^bK1Z9*.tWJp7eGGRMm1Rn
+;QJk4pG!5<h6IQi)M9-`CT:aFFJZW]A/(Wuo<Ta&3fNC9t?8KaK=`G:dpOM^$%hh@g?DptrX
paVG@JskXtP\@cG14u+NI>#[3''FsK+U,8?7n5<t,O&^(@tdG=E0=]ALPZj?)E$Z_9a<r1aR@
0N$am,elj@,?`dbb4'G+[bl>]A2h@C8)@sQI9WG<^qKV9H_krXUNdZ*Q[IA*i%sLTQX;B5ed[
*[_Jnd^!LfRcUGZ&8\s`YSXCc#C8!Ma!bEFtC-J_cH?[cZ\M!'J2VE5?Fa1Il`jBSmG1q^/E
*]ANGG!ptT:gWS+$)..EYT.\#mfD6+2PjN`["=s<hLTDhl.\N9'[S:Xp-;Nm_ToR,'%b*/"G\
3WZtE_.PS]AHFa=m&K"9m[+QZ%hOr5BF*/YA2ecs_SeRs.'hDsX=EW/N:`aicfYF(3._5jYZR
k=G03@RhG0CA;Ibi1(8A3Pge#eps*(>:h]AM^:2`M2q0RaRG+R_K6WP^?(0F?3J\<r`4-ZC3(
gn*p<DsBJ<rq-S/k50e*fN1b3<kaB,3M[QI+n:;8:4V/ka@TXMh<>c;'.ZlVbhbprZ`Y,,L,
APQU@b41h#EVKDmYP5:2'hPR]AJh@F,,3=llo=m[8f&'N_??kt:E@H6+,ReS(1oI&3t9cMYtn
ag#o3P(Y]AJ?!@bOR$_mqd+82NA\0%_<F7$]ADpSR]A-^'#2JaKiM9-SH+<3q@Gh]AK&2W0n^*,[
YWl_7B8*KBe[,Y^,Ad2o+kOD+0ag1WR3YW)D)QhPj%j?7>BS(m;D%H6]A1`ECH*<h`Nh[mlX2
/>p)trO%m_0/*5C`?U8Rl_6hN*6u8LK0[+Q)c&FR.[\!/0^nKpgW6FC@)@@p>2b09e&h0lAa
R`._is-Afm'oh!5qUpiRoJ.!m:LH9WFjIN)]A%1M+a\='Kh0>:o1HQNL`Nmm^!d!dJh-='=GH
KLUb7D<NT/rNpc'gicTi_MWAD\T'XU0Cma'BHt7]ADMQ*p=4`'6?6jd+#aqS'W.`Hf*DN0Z=2
h8,N;-K54_>8RMZX)ig'p\!M461+72-hH&1LlYEXGt$1Y:C^g2`N2>pgP<=3!pk6kU+Ge)l_
Y0WEY'akl9(!QKX_*Ao7&q6?9]AQ8dI?8J5JZH1R*64c&IcV04Cq[]Aj0/H3W]Akq3Gi)@<#!%W
bR(16Vd>HU&CcCWoOQe@J$]AVA]A,miDTrA^*jIh/_UTQKA._P-8#+#Y?mSj^u$\U3*ReCM`S%
ZVP52]AtIGmnM!(![Fg<MVbIqDYLj47AKJ0'.VQ#,<l,@H$GBI+h[>4WU%P:ar,r-S3I8IX\5
@p=u6[-#c=h3g=p*8WC_fl,t9I+8#EH#bNRhPAM8-T9V""(.j5sp+J'd1BU/MoY;O&fg,C;[
2sBcfX-N>Wqdg;INj2!nSD,K4Y^C&phDp>+r_^<&e^%b>MFA&&i6jN+r?[spMk_I'#`ZTJOt
QuQa9L9r,%foUj%srHe_4M$EKL$iTnEcs'VHTikO:;[Ntk/Hd/U.YLUg*+i![di4R.UQ&iJi
&_G;Zs$qokkQD4<G=k&XZ9em8#Cg(q1$kY/gf_c-pT^oG^;ERj['.`Sr.82+6u,-@(-:bd*S
rAl%6g$5FSXeH[]A.eBrJ41t#bEC]ALheTj$9O9PP`)MD/0Wc`EK[#,f"+l67P!kcrhf'0Ai48
Oq'.[a)CrrIU9M;mgJ+ro4&`ZQR<.S)P_hZ<&T]AZ,?US&2kr$s0"%<Bb6<fI*NL4glW#BjMj
:CoI;5VR-0FQU,#AjQUG1tU\MU/0N;7fJUlt4Sr`d1?1:>aF,@eu_<)Yj6$J^tr#9ML#MVI*
WEMH1J8S.-l^#MjJc[P?n;`N-a,XCE`QOKr\d":>)N42L8%=$:LRk*C!e7TfIAG+c=E'!GgA
meS_U>%AP\7h`/aaYV.R-%C6dig-'W?0b`1?9T_X?`3PD?dU-hC!?]A2N]AKU\(MAtSdVmH54d
8QT`6NI/RiK4]AX@S3E%'NWAEY)2i$a"#GeAi]A9?$Aj""aZf<_82g7F;HNMam#;HA?GVtc1HL
(&D`@)3j_b3SM=[8Ru-]A<ctN4(3gYOlj:^m-OELc>@kJ(B%%(`E4EYJb*WPXM%hneQ9h(Jl0
IN8h@jBToV-Cn`K)Qe7af;hH=1:lPM62i\-O\<N+N7'K\mEB%.BEKA&_/glSo[HgAHB;d7Vq
e5\[tF&Y(X,#bi8?h4$:e,o]A^1CmM0G7?`]Ak3]Ak2ms*neV>0QkjQ$5u#Og(ls!Mo]AY*$)&Wa
1':FqAZUc#/C781r6rj[^c=UC$9ScB5pk7peS1"X:8UutB%E3F*/*;@[t5PX,D-`$M(FR8B%
Ue<CDMZD8qE_@/63QeJHU-Q>[X)SE9Ur]AM%_cM(QAm=Kkqs0>T@RlUuEd<fU9u0S#ge%)n16
$M4cmoXD@'gW.Q)?JuEKFPSGdc&0iB:i<_PRjhjsaJgR#A1`K)Z/J#U[+u^2mHDq_)Q/bFOO
WpkU`2Ie,9#O8>/FusgbZ]A+3^EN.G2q>H7#ffl'ION4oJ-f*=osd*[4rueMLK@=[UqT8T)Db
;Kj#IAQ\6aAM:jS6f*Gg4?M,[[qR#)@kn-.,U0%u^S"h;LRV5jL(c&.FQd@H(.2eV;`BN#7E
K7TL^\-oScUt\9$>hmc%iTONW]A!^c9"J%U:7sDQZ%\p0iIZ0jb31T=M4Kp(,@D)B\8%[WHc&
P([c?7hHOs_;IS4IGf=nlj*Gc(LnfWW"IB124:gQILF@lLFNK@#':6,<\$6h4DXOsjJ3^DBk
B'045!5TH?@aG+io5]Atd\]AL$YQJk=$q;Ia9-iMo)Mf_;V$b(AlN$uD.$f$GX9&':fTWai#66
lmuuWdVF>-TADXqsdb><qAGe0Q1QEMo"o1pa9)lJk*Le*H+tkcV*@O^>$]AQMi-I9/@SB%4NC
Q6(;HCjdT0Q,prIGJBK$1Bf$T2L&.7:Vj]AM)]ARKERH]A`3,f.DIbsL;$9rKNn>036X>EGNg?u
*e=ii7sPsAU4?Tc&&F%fU-(hg;/2.XR#WQ\J%"Jk\Q.dK7X6t6S^c:f=:f5H8fa^jRS[EW+,
Q_K.Q<>jhX%U6#Sh]Aqq!VmX:IN;%;`C9q=>.PirO_B-Epf%dG8'\9.u:63Ds9bTJ=f[PgMa?
lk1<HM01YmAhPJ61#:sl2RjT]AIWoWpC!5:)OS*6,E]A`-jh!!~
]]></IM>
</Background>
<Alpha alpha="1.0"/>
</Border>
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
<IM>
<![CDATA[Cq=gQ>AsO+*i#[ig(^A`[4:n,D(.1h<E-(MC8NnoGAC9<fK1ukHW*A4<AB-YHNYKXN1]AimIt
$;Prr,*rf-C=V4O,t=3Tp']ANn8DZTCm<UWQ85a!<<,M$]AV(\!!!TN!$J3e,Ioho10h6j!476
%nPnV8GK+MIWAfIGq/qsg.buJdD[?^V@Amh]A[*QHKZ,gS3'"\&2@;:Co.NpP"D8t!PEXdc!8
"9G&m`9*DUTZ$![7q+f]A&Pi)0S'V2DYsDPF(0#+&bk05i-a6K1?I9qI"sM*`Ni^q14As[c0?
t]A/,K)9qWr:HhJTpM1@(cAg'I3H-VQ``s'-Ojd6X?;/S#o-P5(Xd>8sssIS$+VnWs4,F6=b\
MJ@0.d^T6E!;5HHZ9;onkVQk?7MC?8<)./jX8a)\97P\3T[+5q9CP4dre;j\mAWi.^Zm^Q39
!_!c%"WLnu8VR@h1nS.G?`F`GlTAO)N;O*RDHr-]AB-nXoG#,^?]Ac#=.D0Wi'':iNAEqdC)L;
C<7!Q%EnUIMD@+(ukM5U^)LKWIp2Hs@WUBWt3!Z':Z,%H/R@NE'/:O8.J).J2o+Ik.9jGISV
LRO&GC*e6omf:!'m[%o$Gdh^^Rs#+$PoSZO%Ij9c_0jrV_p7s,)Lb:ph)%PIL58WYjWO&O3e
b8rI9=9Ugbpu_Jq/VW!6VQ^jY_]A5&RYnH-bsWWr/Zr[M@NQs8Q?>%mVQ/nO$[),X_Y<\AWkb
o`QX:ndq+).X4c(rSL1kni?rIBq=!6Y,*$6MYQXMG_A@K0d'nT^jr6%%okqsP_;ae_kpKLr$
U9F[V^Zh[s=,B9$$R4Q"/"%@q!!l8OW9VF\_!-nc/%mV<"3-I"$fY@il"%6tr2kl2C)3Xm,(
)&4ibN$nEWHnPS\\'do[RpZEaqjpIn./tCB/=A&AaQui<<&htebh_cmrH,Lt8?(VX-CsiM'V
>iF*.u)K-YUHYT:VD==YPO<N*X9A)s&tt'6U8E(c*$qoaFLks?D7EsOc$@9s/HT^gQ*6%]A['
dSjW54I1n#WQ\QnP=;qB+ZoL8R.Z$U#bZA2/^fmVijF%?&f*F'/H;L8h+j+d"P(Zr/OIY>GR
r9miF4G4lq&!$QFX!Z#V>.D=1(OOrW=A.mRH0b>V@4S7PXF:)#]ABj\=[MbdA.MpI'Q`h4\Ea
IEe;X0K_I&ibOGS3mCs/Ab>ibnq$L%coQ'aoN4'[D9)Ebes$9(%K5NDq&&E0(]A(UIb6=F$Ie
Tm\ojC?*OCn_Y_i=X6!cRl"7<gA]AukV61E5P^`MIVS]A,LlEbcaS%<m-`-iQ:A/\q<eE9-gj'
FMK`+t3*EC3;`qFj[H-gC"<1C/lJ"C#WC9:eNlKCOUctQKLt?Qa`L]AiD%LV2o/u:#e/roQm%
198O#"Mqu+J*"B5l+C3-qMXQc&<hmFubs"K4Z\g]A@M5h14"4m@b<jh7Q1hV7jsm+Zl]AoXB9n
*]A0*%*8UIS0sF:SV0/\Y:K]AWMn$d)qRstnij(_4IH#E%dJM5f#%F"cH\Wl7Jh_(ET@<EiJ"H
FrA;&6S0OYIZt[f:ei1,DA$s47]APo@%8+4A+T5V<UO`eK['fIZ+sJ/*K)j.K+<*rh$9W`jsr
\s4FXd\\7Y%TGr\l9A:*-[LQcD9GmBQ-qX<??_<nTYuKF\#_4i8a2BLp<M;fWD;h&</!c^]Ad
eb(A>l+K>K4@JX9R>HS_PBZs>@!2Q?H7`WbT1MeSYT/J2(cT=ME[7!&UZq^mNZ+2i<^aFgP2
3hj?Z<=2pO.AXmcJh923^qSKtDSO^Uq@klR4E$a3W[n%ffX#,V-.W,B<m*l,"1BaR!O=4ah'
MUme9$#F!db&=kF^%I9?8%55G<FAk[&/lsT2#MaO1,eG[F+-N[B7TV0%ertK.VJ&:`r>a9dJ
M@`XLK6bclQ<"jAetW9bg$A)L-I!]A&blfAWg7L;gBjg)'jT+bEfGG7hiq>0LD[^^nEUbh)i!
"W>IR;P/S1ojU2NP10.i=c'p'mFmgh=OG.6Q;p"-'GN8:fU7Gl.Jc\liag#"/Ya^neCZs$bX
-Hf]A+ob;j9:(-/S?[4&%`T&0>?Gn3r^$VV<iTmG@?%q#]A>6E5n$g(@>%`-7Q,sDb%DCX^&o-
7!l-n/39Mm2$Ho8t7]ARKB^%]ApVRij#(2YlYAMfbpRKh1'+p<VV\"4b4o)a`sc_L4U)h^a+`u
afqsIjfJ_]AaJ]AtY\&0=PT)&93B06,b-VfnC2n$nZd[=st2RXlZ12XX8dRt.$0BToP9`16a)5
NOpa\Lf1Wm)pb(p$;!Q"c!Y^,a-"A:=`'H0(4\iaWBI.I/O<-tDs\d"dW$,(ds%A+pVmIU+1
uOLpQ-!onW14juMfGXeLgel[<DODS$_'sk@BH`1[K9@bIPFX$[3O-BP3@IcldM?-jYCGf/aB
%arSc1^?*E^b2\"Hmu+'WY`gWde7t+.&CjSFPuR?^M]A8M4UV**CE`qkEe?U>O\_gIs)"Pf)4
*2'=rS>mspn<<[;Or^+ba*Abo?]A;InlGJC,*D2g!%M]APBK(/72Nt4(A6XODgBSJVGc2\)_Wl
fAg\tZ/\e,nX="b,h-i.&&.M4jkZN[%Q[%f<Nu]AJHjrZ]AaQU_;`2038%_[2F7!>?CG($p(bk
;m^kG7%Q)*7nH;LJokrK%T3gT^n`DRVX$G$^^CQ,B^&p@NmYrBR2#/H3<J9uJ>=d3reEn^)j
NG_c+:<ni\9iPQ/R`"";^A--AE[D7:FC]A4kXBq;Nq]Ane2>>4EM7LGY:^Z?NZLH=B[Q'^kU*U
fX=2$9=GGilOq9.>\'_1$gLUnB1tU]A547&P^7hN9C6JlFH"tP2%J^$7L)4'\o=SP+Cg=<qjD
S>o#3sUdriIj"P]AYP!;iV!;/aZnX&o+=b21X"j9kJ#f+PumE3VX0KNi?jS+ADub=ChWS9A"M
NQP93B[grTKRS"sJ;+.aELgmGJ$.l3EB#A07Ygs7G7@Xl/?ok_re&egm2`0*Jjk)N?ae"/>V
4_;qTQ4O:UqgNorM$K>(VKrR7r[sA\4XpCX&\iD%2:B"db:VBaZ9Rf1bt("C(#(YKhRNS`BM
f761h1\l2<E(mOAu4\)d3c3f$`f[ip/(&ot<qY=\cCT537L_sk3eK!<S!`'9KOU"UD0"TL5A
tS?CqE5um&k`R'5+)jHlIJ:\"2,X3]A80^_(6QI]AI>1mk&u2-r;7.NkgHe*&q$o$JHc+hc,q/
R`/Ti(4*%opCDPY@kpTkIPK57e`TEegB1>9)bOL@I`crc:]AIKu_Se(;GoO=I"rK:O^BZRL!J
H0_5Oj4>`lBciTCld9har^(a+f[^F5Pf".>[P7MFaaq-Y_O?LajMO'>:#hG[/&1FoVs=o>I^
51$"J*QuX+bf6!l^ermosfV'gV'+]AmO]A>Vt8g/VF;l)pIr&M,@.D?q"p6cfQH:3V`Cc\PED'
Af)`WV?8tg8aA;]A&LL+Z+>Z$\HIE,7s*,4j"P_=8-*]AaZq><Y-.[<$AS]A>)`nVLc2d)h+NXr
m'ON-/0F$2$:\dj%CK=*sSa1YKSOh-2YYCFmS<Cn8'[%")tJpL%#7L>fR,Xs(X]AmYf#sc"#W
j>*41%-mWBHB+u&Rhom9s?%a_a1:b;biI11rck7h/==GOhmbMpU6)W\T-r?-FfCd$<urfjRW
I_R_Y3N2Okcir@704p]A0CStn.]A0cgh]AS/Ok=6rbMP9pm<ds$`G;*SZUc7?U=*MKD)hR()TPh
-IZj5Grid.`8u;R.nn__1Y71KF<b2blg?g&9Q#5DhQ$oTf@X2_K,YM*BN=iq<q9o`=@N]AD+k
L7)=JS$*6[`$>uIr(!'DK/:U6mOq;j>J3a2Y"TY%p!2^&P+]AYC0q;50rI1W3Xk5D_Q@G^q-7
)Iuga2`E"$go@eBUoEVINhEIm5n3q[Vt$]Ae3;;G5#m+H)YNR20Y'TUq:)<:`VQ>%!_0<eR.9
p21b_[IomIP^9UPY8Dnke$'A$hcaS(HI1RkC"?hXBZ8uYcKGfD7]A\t]A%5Nbu&@RkS`KC%ZXR
2biO]A%eL+NClD_8c;RuEF0X-f]Ap89FE,quVeV7WC2"1t`i@>l2%4aB@s+7:BZs%3qfQq]A"\X
Kg$5O,j7JB^Y5dSF!&F6@gH+-ft[$qZK7a87@6*`30q7L,Dn@4C@lC2HH_kk^Ah>SPhRD8sQ
[qE/uo6b;5C>8/!=+BWhnoDR!P%WOpL$e8DW4Z`uX;3S^j7]A1lKIT2?-c]A.78&m[RQ,d^%WE
U,#u3NBpYdHMELok-n&IsL:0[VpTq]AS=WuC8J]Ah(;4AE)^@ML')uD=@]AG.F4%Kh77$VkY"sp
66.d!j]AS!.s!'!i*_[=IZk8n@1>j*YBk"`\HBgd;TDQ_C=NUYV]Al8((2a2\*LT8p]A,B$j9Xg
DVZr;r24h':oOhI1dV/!V9spo1arR_iN">^@[_#CMbY(!=6M=GW/?o3SmYXl@f"!g\1jc0(B
nN$M4^4gTQBrb%Do/,<gE!bG7sW)ef)0cnauUhOF)"j(?O"m6G4.7?d;XHfi+bCHP9Z?E=YF
L.GUVAhjQ"J6SlO5&`#.^OY3qs28bp3"jBG1iMY8ZGF"Z3S]A$j&;.%%O2>d@1pe/.mbJLmEX
2GilcaK.I!2H+P-N\%H%EW;*\ll5IH'>?#ppjRNk([9a+)GKh/&+-0RdpBQ4I<K\_N>3gL\U
`pgQobMm46H<YL\?3IRV$@f(Y!AntJ<$\k0U#QNd<XaDshN^polaU\'Gpf]A:_T?N6V,4`3Cr
R^J@G#TWTRbsq6,I]A!f$'3*uTbM:NFkhbu??g-0/$c?sEeuFMZ)dP3T_OKWXU+%k&qh'A>PW
8)I=_j&XNZM&aS\,8Flg^jK*`L#i"d]AWs>N$4.+PAlNd.H==^6ko-#JGIhkcp+%'7Z8;LZpb
1.]AdBs(fi2G@G2YuF?YVmBt3Kr6IG[Q7":=A&)rEk%1lgUI7jY=B_*eX?=a3HHe^nqkH!O(e
,0%.AcfcZ[tYZps845Io+[X[3p+r_[h^kO:e((/#NRf6BY=R3AnW]Aff9#gh.a0\+!TG_N<A*
@tebP$6j3AO"fLd)3';3u-1dg&CDF39/PXQKaSGN?WHZ)XP:3nW9gWR8?>LDDFr6oeWlN!+,
V+9Ek.nVB]A("'iuC85!X0!nd,rfi(<SEu0<ii[NLZFr;;s7q9$'\mDe)0a`p`-EiYk#lR0nZ
G*VDrk!!*ZG%r2@67jM]A=KIqm?=H%%.>i7PRZk<7pqlQk!J(1p9p49fW)?:*(C6P"]A!NLIP7
3TBhn5CN;t+e,;VsGmGWVCU<@oZRZ49cE^2!Cp._@?WEchA<F6#oGA?ckaEORWd@i'T>C-0\
6^`OY)0=OLKXoCI-[5Q:IJZqn-9Zd2ec-?p+oXk9&jsQcj@I.n^DC.Zu$^2dI9)md]A5hMHc`
fBBii9(`fi7Jq%pk;/<Z5FrKX64h>4+?Fg&+>m<r@1_<Mm_$8h;L-sUOQ,bBA+Qe*L(5LlDp
'bBH[9>p);qamqOR?Y^'m%(@`H.EKG+XAMO7`VdYMX6=`:bUUqR6EIfjSo\(n=Hagh3Y``$V
h"mRB3iLCItVM$.n`cqCX@=>eAa\*<isZQMpH]A0e0"jT4V[pn#M1r.j!0EHR2`L>(HGOg^*k
GhT!::RrLV6S]AXk0J\S;;L>Y`V&<+\b_tT0<__%eX?i?5qY:I?*qRcM[?*Z&=<ieU$(j2XLK
?>@7dl)B2+EZCjf;EC`d5at#mZ3>MfS&I'I5[BdC4XNpL#=HVgja(qn+o1Jk&S!%1jsY_WAo
#ArA"Y\U?A_2DE@tIf_Yg$Y^=oE+=7Wn0)SWCf`_GY(A+Y^]AQdl!lHdhf<\j(098":WV8Pgo
NQYXu*>V:s`M>G'B;CL@kaSt*K.362%IuC<G"67>br)8[T&f3D=0<!mZq%;Q8fa8ZZU['MV#
3]AeC0$Jo!<GCm)AE?`f0]AqW70+H2Sb"(CMJ`Z=[XHX]A"B4tc;VUjZOj?ntCQ#r?3<F&Hjn)s
t,W>\2Gu=CN+3>ef5e3k$P@ca\:7gZIWh#Nc\8;S<2(Wu]A[[kp<gGt<VlacrfIIG]A]AN,!j$f
t^[`7!@Mn-6ssjrWRYh\;jQ!D<bP,Ba1H457Kq'K;aFf6_$Zi\_?8R"SO*9-lX<k`<@o*.[K
r9Bl<b5:V2VLRhd(gS93F/-lJ8S$lT5;,&Oec&E7uO4-b`aUgqH@o-?LRpK're7*.rZQ#BS]A
0(^9/:.9g$@8li%PUedicBhk:pr)B*PXnEnp\9hE91m=FC*qV*.TrJD%"?\R2.(.6PFVVUU&
DF$5A&!\C"="d,Y-Oa9t9A7OZXf-fjR$#gkW)'YF?r(OSeCtoM)j_jeF9!]AGtQ1-dqWV&H:h
"j3VO9C+W=aEo.VUOrtseHafMm-msCf^ftdN->0)@Acs(R(&V$(E0PJ=Df+IhVM_)iB2@Wr;
Y_\&,<_6[Km#jT%H-iLB0@*&'CqnR0g55<,Z\a<UdauN!S;qk6="B0-H5iB`b&sW.^C!O@c-
W*fC>^oUtM4MUMi0V8=DB4Z);BOXi8!rj2SB`eHsoF.48JMSBE>1b4-YLSggEq)_`MBRoDjL
TT05+BNngA>,L<XX7O.):psTVSAh2Pg16\NhS`:T8+P#%:MWDK;\Nq_H#Pia-O,3oHD=hS`I
Y6*o1s2l(QAAe;Pm8&,73*CIF?@p<onW&[1he(B3UM#:touHNXhSa@IqC.eu=TC<CBQ-cec^
./ANh6g(d>a(.]A-"rar-5b0/(5m5-FVIGE%IFka=Fc4b4a<U99@85:lG&="eNI1LpQonNu/V
j(M5'gu=jMX%^jK^gqVC=VR9ElN=*6c.CscZfKpKUXa"T)V84X[AJYBAZ:_'@(YOV576$i(\
[E4ZhiaWj+gY>9>!r^%hK_Nd^ST4\#)@8h[6bL>n9ikDqLIA*TS2D14#2D-E+JqZ]AR*LNa.I
'h9oSHQE!#>Dn<a/:X]A,p:_,UNjE'bWM,7#g$(fH[@R4aVh"egNe#;\&`IOJ[kSP<TK"PBdZ
KC@TMP\=i;1i^=q=I^/*9G`<7o]AP%m"K@\4uCqc>DT=qtY3[m:&Fo?Bh26eQTil9AoB4=)Sn
(3b9JMGP?.f,i4<qrF0t/5<`:Km^rd@X5;uf^'eFsBhK<_1%LHQ5Sf,lA4"D!6WUpM<G,BBH
Qc`Yk<#@!]A=1>g#&j,=EC%!J#+aW.'uq\p"roX)%OkU*426:<b;c=1^d@)o,8\63q/j1KILO
&K8#[HZFcn9M5gF30ILX=*0P6)\!Tts2^d9W[iDOh\+t9'86Ks/Mb]AU+^j;(f`V53[Z_;MEn
.rl"u_@?99]A\J'IA']ACUCsHs6j0HfYpZ4;859sVhnD^[GjuL&tg#L>tRt@.*0@b4"Us>l2&G
bJZroCAOipMf;_O3/gaZHE"@OnRd'MppRggH+NVLmT$(uL?L'<n6K\2duNUGd9r-6g$MV+7U
XDu09SYuQqW6,55Rh\UPI3cX^6Z7O.[41@%@(sW2Q%DlVG#JTZF.pp"G`m7B=P+V#UPT^a(l
^!4PGIig$HB((7A#1h*9,bk#gE@FTRPat=UrM6$j<b+@<^t8rTGf_9(ESXTbq]A&%&$<]A/6j&
o<d_YXZq.WV7fVSG:9^LE-fi8Nsa]A5gLq@;+4\,!Df,n<QXKNm=R)"2Y&T2:H"C+Z_dMZk$b
SKMQ%Da6]AjZaM09r?-%f9J0eEIZ!oZ*Im5o^*SqZXu+d]A<E%);Eo-c=mF6EQBC5<VC@WNK@f
YrH.@^&Q2jR,0/fQfH.[YgqULS>=`Rj\T=jaE2Z1c;Zi((u`'g+(;E;2M%9I_9><S&+s\\uE
]Ad_P/b%I!X]Ac3sFX+_M4gM.[=<?m8aa_c/![Mf?\Ln1'a*hE8/&1/^&j]AQomZH"=!Zp]APaZl
a-Di>tM"+QYZVVfnK64SWC4m>60U!s4n,uUR4rlkHfK9rZJr"ht,H,"=YT-HbuG1c!V=ASWW
K&Q+qA-/)g,iYb'nqZ&P#m`?+rG>#7gPT>1W-@8RtW)W0ZG2Drf2kfCTsLk:6=Ci5C,XQS_H
Y/uk,:)@iEI)&%_9"\&]Amm/^+$`OdHpFAcT\&Wg1Hm:X',k=09%Bj8adCZj\I2-S.h+^#94d
8<S_J9<;M_C^%Z_%/r:9>26iDoLuj'o:l&CS._M?uM2m4)NcMpC_GK[#W%q_I/s<Ag:NiE2#
:gf>S?^XHQ)=3o!;Mf"IJH*[+XF$,u;&^+V(GrP"L.S?nW/fHE'>X^V_*H?1%_Ei4kV2[WYb
h<Q0XU:$@0g=4a4ga60a^2TFqV+n#42,9;bK@qP!MeP]AjD2Ksg)%D2MO+7/[pp=jeqC042;a
&GWm!PpIpjJfTu!N'X+)(]A1!mhgP@>-_b^BfaY>hse/8=#07`/Xc#B!a@.aE6V/p>2rY[QTl
$FM7iU`JhRH%Ht2l1:S-=VWpF8i.$PC<7Oe?#a*LJqL-#2YN">^p'iQ9mc]Ang!rs3MWDi4-T
2%(<r>p^C#g<s_;=eZZbartB\<L>PU543O6?-%)b.L##=WY#pYqJEFFUa[G+1)*4DDXE4qq(
:c'sTP=[,Jl]AdIC9Oo/EFF+8#Aan=uL!XE`JHUa7,#B0J_*]A]Au<[p5`qPC]AOE\>4j@m3DIiC
R%YdHSlh)f]A\&+=E%<]A^$7Rn'ONB%iM&st3QM]AkSB=8!P<bO?<:cIlPJ#0%QEkdLbgS)_T6s
Gj2L3b]ACf$X:/7k;c6hmJHO5Lfa.ot"=-,biL3N/"rH,M5)dU]Ad'`D7b7;I*Eu:H2<L^s*'r
V:AD'aqV3XDSYr/38??=1b5]A@$KrQI*RK(La!QUj5HpLO&%8!g7]AgEPL9jVYIG![Y>"Ffkh9
:;A4iE-J+'[:E70^%;?0`aQbLXP[CV]A*tVKQ%7&]A&XM"Rp).O?fBSKkSPqK);t*^m3Nmq0Wo
JiFlY@i*+NE&=nMWBX^61j.s1(gDaSga"n816]AXKrbJ<GWX5Q!4#:Xna%pfg^%AHu=L4r/+K
@HY'T2Ws82e2#ep,OoiFS^AZBqRJ/+DY"VG-<Kd8T(4B?212rXVA"[:273Jh<:RpBYA^:jVP
_sEE]AW>Drt?3@2c+$-gs%cf7ZQN:_g+\6>`mdGQ%=DbJLZ;j<[!o%YdCi>-2/(R$3Df>iS<Z
j0+"$K@OGtce0&r/U&Y$OKguN(%i*CI.N+WKiZ_]AmrX"Rp=f2uZ^\,a^9-ND^Yj;iWHJPt%l
kS9591^no9*pjG18RM'&[^GX*L>0leKCtlLi2FFq_EEB6?'hCj]A.GYYT@R:NYO>6M$%me+-O
eMREqBp'E&4RJ\S%gd`tDCue#<Eb*UeU-:Kg<:W+g8CX'g2S]A>^PBs1gYHB4cn\\nHI!W-sV
?dR*k&B0oe6@V>56Ai;4)Hc5cUD&"aF<,L:/eWt>9[S_!Ec>.VW5RN=qD#<nQbV+_q'rSi>R
[GGnfW(M9fWqG3,$hS1(#.:ao0DrD^=kUS11bI&C)Bpbl4o$s*0CP1HREQ1mCo<V4u3W;"qW
5a/tK5at%=8Ie6;dtH&a)8DOqo-bZ-NokZ(U_G!]Aj#SK>p5GM1(We3aZq1ab<->:F2=b1i5B
Yh+:O2@*28/Yi9?HMgOKG<;j,=]A!EeDWg4:!)0elSU%[=G\NXt++MS*hM<VA/P15=Cei10p-
9=3n_"bE`rcnSEXZcEB;k`G8dGP&#LJ<;hbhFA;>ULJ5i8+#<6E\j[XCZUCFi*lLK]A$"H!li
!_[gi5(]AMP%W/0VIsE,a34gI2ci^dILC9:6%;+i#ok=O^FNnXZ5/sLGXuQt/2U7=2TVbgRl,
#cqh:g2BO%kb6AG\6c[=Sq@!YL'WB7`EbCLofVqIbiV-=M2;!Wo_Btu%GX6bFrn?dDrZc+?D
Z%s^2`abCg<`o73nnWTFrYHO=gNOCrQ";r/8Y6e%]AnWSk)g@/m>XE8@#NkIZilW&i#K@ija&
ZN>=*cLmAM3^*i23)s%mkH6UURV90.5QaE"*K4\:o?Qq#j8s'5+*gY1H>:H^hjF5M>?J^4ip
b,petD2=+#gT#>(7N'c2XY4.R!XC;(iQRP$7&G^QhVaJ/=rt5_eJM:$#O*'Y0/st_j9R\mgC
4(VRp=p"9#u;dCoZPo0Elbg>L+TJ5s/I"lB2$\komK$)N-WX6r<(FofnYN/P8CI^InJ+MEHn
CAU!*E5o'5"@[?[,Z8sTaYc'A?<[SsBDi,Lg-$hu4%[IO&XOV!3f)t\@0%iKZY[3Csb^!kod
CK&M4&r[0$;'Cc.rGkm924?cd4qq2ia)K.QU6%IQQ1ils$pfrQKN48eEjh7tis6*WH6%N:DU
L`Waj`a,`q[S7,U$Q<TTf9YGYrt9bQ0RO-*&F\g,:0rjPgX)8uka"2U77[IQ"H;UhTDO;<h<
qP[m=,L\W=&?/EC;XZ<FaAt@l&]AfQS44!+UW)?)a?Ede7BD2%&t@]Aud#pira)k>A@+,*7gaT
2ic>\N2*Z6-_gq2La1'j871;/QKh2LNpF,n.X<DeB%]AQas#1,B%b`d]AW]AWse?q>N%d/`k'sp
2'/,)H=4,[i11+fsiU2,:?Hii-PKlEWjFl6!),t3c%NM"XS9^uq51S1^Is'*]Aa*66ZF%,A't
(7O>PMWAlcJo<g!e%'Z0j;coh2HF?h_-+#=hqmW]A,8bU'oG3FHZpHi^OWGd#>?<soKF5GZ:"
N_g!T:`!.<OkX=h*c)_0o<&"qh#/?8PUaia++,3K^/<OKhhQjZ-UjH`psnpX_,n=AR&uZM):
9rPSKh;9C7H6CuhbaP*f1[XoG'285n(7QPTXrd+as:jLU7=NcXoJmT)noP>Vu)ETAYT2jRDO
h`9_(nF3KD5I1s``_e(>9DGS]A=\R/GL:fY@IqqGDA'oL$X6cT",/K6_&4p2l]A]Alc<Tpb0$U`
YLSV)idG-/)e=E)!2j;`r_647"@J`s:?=m>J5k@e4Uf]Aefj]ANT[u-:S203YJ=EJH;>0b)K)%
j,mgJ?Qnu^9)(0rARBN9#Y2GeX]AC@;U7U2QFo56rA&:]AL*m`&Bls$"sj*]AP-j+Ffl3(Z7[0@
VP"I+"NHF\)'@>=dlS(=RlaZVoV!92^_R8nS1iT.f<LV+*=laqo;"P"Fsl4@OG$_-rI+pBUG
mWb-oO<pLM$LmrQl-p9JR1W0a@gNqCfc%G"pW0bRbCf/%QrN]AnCK6]AWeJ?91J]A7_QO"iZbCa
Iu3flM_:oFq="k&4>]AeqlAP!PPgE3g<DJah]AOoH;#P762<=iRH3/)HnI.Sr4h&b\4AfHC_VV
LR\p>0A7qr%DPu1rS,!Q;J(7=74^Ll>?_$rtDb;'(9m3)g(K9&:b:/Y/3TXsVuBJD$MPNXJC
*4gF^VdT6erg3$pd^?43Hk`hlYA.+UTku@HBAZY6TZ<'#&nu@cp'nZgN8F)@_gJ6TUCjI`o=
$ZddlH9ne]APAVeB[!c-@\KlS$eeK21tIBS^]A6S\I*J`9N_0i\Y#ED2!+oafiT7t:U&:W-(7)
XG%EBDr&6>[j2\R\IOWhSbas'3,l/eGWZM8A/Gl1kFnr5VO$qD`m7IZBGFI)*P8XM!/7Q!R9
)k=dI?K)`o:%DF2+HR+9864Y[<,96NH8#(C@"CC#XY:0U)K48Q2A8OV"49T7WmIKIfh&lA9Y
U9>!:',+kd-K=?#Q8'Z0%WJ0:d"X5bq:_53,S96e5$9$hi.c*01(Z^1q>F)tpb#Gk!I6/!,,
'V,ch^#&^pEo3q,9!Z$3c\WnI.0ZQ[`)".@"BCArQ&ViUn/hp$H``!nHH;uaIHl3cm*@\N:P
D^(OD2GXXSp""3m_S+;F.L98$@b+a]ACEBn^Y4(_7sSSm3DtRngSmEV8(+&D?70&>=>.haLmK
ThqhNb[W[H&BmD)QUaB8.G+k4odiB3tVs-9oYI!q*,$[o%;qi>2fbJi5Bq1\l'@@05:HsF*,
+o)5!+B6d#m<Qm-N`*MAoFtKgL*pNa`E?e$=^.c^UJ$bO;<uY3'?8p%Oh=8nDlh1-&dF;6=]A
;YB@QprSNclWgYJ[GUR@u[GJ<bt@kBp$im\\f^2b[=6U`?@Rmmo<?%GaXX?u\+N[+i4Y4$Ma
=q1b5Enl9HZaO]ApBu.B=.WjoSD7o#eG7J=YXC^aG2-2*<fb59)r$iVb<%E0T/;/e"_;_9H.V
g(o3csT!fB*p1[YQ\+W9!HJkh<0)#UN>bGQ8:Q$W=&+1l4_b59@:d\3>fM>]A06/Zn$!oSXg<
?PJ@gFgda<`gK%(s9IbKEDIGZi&eo+%/n?]A@8C&%t+MS_e'AGbPhA>`*.Wh@pP_n?/W[FkmW
N1L4!.QS7chH[:3E_("Ld7a:Fice['&<8!SS(qK4!2^b_9"tO0Jd3sZrc*t!ruRbcg*;m_`6
bHp63T'@&C'Y^K+3DqE^7I9?7AfNY>_q*'a)`XE)^jcOD[r3M6)f&`4$6*6kruord9l)G^,f
U`-O>=sfZJa9aEn-e!tl?nE9s,'Lfb/35.g8%[M=X[=uK:3G#plo?09;K#ap^H^]A26X<i5r[
V3[)aF@>2qFjL*S!i@'ndP3r_LDr>%k9[NUYq5ci+A+(O9ncWkWZ2f>Ji!fP>]AC2#Wq8(SJ3
NH,H;_)lVoFLt&[)KSW@#HTWJHT.MiKKJ;(&iM6fn#A&(Lcbp0eWKs[Bb]ABX(k,JU(*$#D8!
gu&+fBdQa3ud)V7fN=q.5'"H3ZNb\k3MYaQ=^6Lee4m]A'ki`3qV(\DcO9B-WcJ7J5aX59/JD
kA`5O@o7CF3#d@fO,GLI+lTJ8T5a\oESOlB+Kd,/:I]ArA:W6:,qbT\<nS<b@A:<gVoR!e'&?
:XC.[EFqs/-s6:fR).[NJ`%e2IU%m`\qD[<l(cK'is-K)]AV4Vb=6_.'Skn#;+_@r_+jQmZC$
[f-/?uo4!d'=.(s".:#ZC[#F@^=qn.pOnVY<pH!9JZ)Lou(6\G]ApV8AgGP:T1s3T@XVS0r'N
$VZW>$19u3o=[+/nktQibq2"?gonD"-Zagu$hU)=0G*gil]Ap\RfQaB^1J*6V;3lk:Eq)n^L,
)%&&[.']Ab$/S]A;g"jo\^>Zo:PhLW56F7[1+#pP"4WlMkf2p@UU[Jn`/0#s?lO!L&W+>L3A#3
L"i0n=&HKd'pgkQrjcc9\@=%Wl?=AQ16#r3r#NK[q)N<.:9'Q`Ok>8'0tpkdoMFb$=GKWmS9
;\F$A`;fsOk6.8J>>;LnCCI/g6FQMeOPRU>hsE::$`Mcir&K+`,$m%IA+TkBnW!5ib@Gf03(
jcnhoH%BSV3R@^R")5_"21>G*sGFMD*'r+ol]AVC:+e>3IdaR6`L4[M21+VRECp[gV:a8lB*j
Lm]A:^KFq.V$&b4>?,l-YoAUp9=-Y?-PO!IFrJljdSlNIHq#KSHG$&O]AtmV%)4b\*W*:$D0o#
+:EXK9aL"DaF=n#a`=k:2G`C5MQO#*DksG/l)4&*<>UL!5G>^T)qeK:71,:IHsLq]Ah+"BaZJ
"`fNS6C>qV$ol5s1nkctl=[GeUg8^"I+]A4)LiWJieafnqe)X^/C[K)Ur<fm-J+OYcPl[`!87
\2SnP,qYlf*e"<q)1U5,@=Of[S1NYf4tp`7(9I86*M$E'q>d0YbJBa*epZQR_:)2BLWJD:q$
[.(TG]AD%O2qA/6*uu'ST^%b4Z"KT6kI4]A?%EZAHWIpM7^[/5Th,(=L0,5l!oFQU3$^8$Z*^1
uW>b"@J#@31Y?HJp`bNq1!NW=!bHT\iLnV9$1f%NdogNF'V4!;OJ$t0uV'6'=1Uro5#;T?iR
NSHi=ka*Zq+,F%n0H%?`DgF6p@^c59+T2f6q67fU6)ZTe$Y\H[6Qdn7J`"&Z!1RY>Q7-%r4n
1?Mf$);9pC96NFq*EIh:@rH)Wi%`puBgoLS@\C\[a1Kcl&ERi_kZ\]A4=;r9L)dC,1Pg9C@F8
l0!1=M[B,qpoDBA0As,an3Y6HAu2>@.SjU,h(putE<7]AGT&k00;"Gqk-CO47,.)ZX%an5*TM
>U<DY&nY8KUNk70^^+`)mP=f,3hBf=]AII\e\.&\^H4Ac\Hg8U,_]AY4CFS^n.3n+n]Ao=NPO+2
rWTTfDMW\Cr\U:/2fFY(VQ'f/T';%$/Q?l2RUFNL"<D"R3j795CARr?S[u!oSO^qs#ap4BN-
!O@>7;U/d!;rpeW`E1F?*UW;@4fInI([mIX3neaNf"*9\`WO,J5JP5ReH#sJSk+sdVBHWT<n
3[W5q)Qk7%AWS6[R&n/9/>1fRfl\@,A%Qh$I]A,\5Ss6k!*9&K`=Kn?e#J.8siL#'n>FJ5:$Z
=dsYVd3'EK(p[FhYp<\`,ZtVML2U,do[XW%;UO<5^r5m#9)LZC0C;GcV!`kWiRtbMgop(/[Q
J:+bDcd=8c%']A=q#3mlU1G&_#q7?C(Pd/(.8+Q))[QoHEWY-)aQ9F]A0\5$fIP8c`8+#p6Cd]A
21jtU$F-kT++Y^4aGg1PYd..SPQR(-RLRY5.X(.K'Mp=<kFSktH4UuVbHMhVA%8bZ\Z$VdDD
@I?L/.k0H0@j;m#u&3""J[5RVO5RUB^cUrjN@3'Q1)b9JnAXD$Mn-U#j8uRlc]AiBHeJm3:l@
[aal9#s`_Dg3k'09>*gYMJ"5@K,(-%c\KAh^HqI\F#l$!i5)m>'!]AflF+:.'/Z7bSm,U%(`5
IIsXpD4[9s`X@PdDs(oZd<(VJAWM;M`'DEp/WJX:$)0&hUokI39Pk[98@DLGr$erZWuf'o33
BLDR4hGth*H9J%%<%\.S9C5ClMj1kf%"uYiaQL4_#:"5*jmu^d:i8O(otT(opS1D@b)S<X'%
W4dO$J%t4eQ$&?7^]ArUWTi3rHtVGYOBYJ\,`69!dZn?@/tdR"'U$]AbfA"^;9*RO!B/h$t)B]A
r;ZgO6t.h'#a+CC@,I3pbO6p\:-Qt/+6_0Q!,p4;O_b!X2!e+]A\AVtP1U==Z@*BhK!<q#`tO
(Ihf>eg1T\g6b)gtfq2-V;WN@Yg1UielAojqPp#RqN79)uaCOhKDnslsd!311=W\25qHU92M
TO=1k5K]ARMatWuIg]Ah6Vs)c=@icrqA:[*alj'0\i/\BYDcG\G4NMaYXSt,O5C9#MiQ%q!Z-'
TO-,*S#9Io9S+=dp19a$p;[fgOrqqIe?DX&Zdfn(hX'U-W\="`\ZUb-K,XYllN.q`p_G'/'o
Z"]A1D(]Af4A2+9/eRlUCAE3(p\Nl5%`rFYk!DXK%g^D`tq"[WGb^VL![-`b3lT>5Pg<qO]AC"#
iS73KTAZ.Quo[RmaDcp<38tJS9Yf'7B3(qaG*m%89&J^a/#Nh>uL6iVUa./V,X?-$RDeDDCQ
[FGaC/!aknKcgq7&BB1DrV$I@#ABjE<[I;gIKNDeZCi*YsDr7sD;47=3M+"BsCJCuCJb4>J`
Zd\>_O+IcJ`(aY8*5bW":!hSRBBrWYrB3ulf:P'$lNfG4XuKoD&)\_jrgi&D<tZ9e%LH?nhp
_:9I!@S%n@W.srqDTZP,:"8jK1^*g\[7WZ`K#n@5u8sVf*Y4U/l.bp&`HbK%'@7kec.@pq4?
$l(+E2@K0'DDc8d&f>eK5a=bU.mtbVm>9B)[D0dCbijAX&7.r&n=%`:f>k_d0^UrR"Cb-GTP
^CK+hXWTtDNQqWAp%XtPkSG4*+_bKa<H7$hEu3R9GB(l"m]A_#i0KUkXJ/#:4eYXpHr/[a&5V
P`XXAF"+79fANDkD^Li[FhA$om,e2anK9Ud?lNP`]Aa&_cssr]AIWX=s!9rk*")*J81^i76o%M
2s%mCJAcr5QQ/uu!646W23)o$3&*FaTeFtH;J:_9?qBI2g\F,):$^kWVr-O$^/-tI%4=Q4N*
1_C]ABCQ2&,D(E7Z""\X?JF7%sTRgD902l02?=#YE">?rAI_=qBL7%:$[;Z=/??_[1;.'@B+#
91WKq2+P*kX[j>"P#,m[7S8.n)I$J0]A@9j[NL#nle-"_Z$Fdj@7lSb`fr4q!'7QA))+*K._6
<FQX5=tuDs,@&nVXA*6X&b'&p[@3a=NeP3KX\jGlWLr/T;@X*8)lWuDp%"8k`.Ye>IIBl9'+
DI!nfatGiJZc`["*I;B(eio"AOTf^+6^[IV]AMN90Ue/+(Xo.L>j"n"P)=E!o.6lSLeMiqZiD
6ZmI:<8O1koe+Y%oDQ4jj#7ka\%)pc\E___%OC^#5bE,Ke!a\@l<#hoC:N&tQ0_g'P:iX(jh
.9)OT"1j?g+?I51NA;dF&^.(cI]A@6SWYVN3UYb>WX[Td)\sBBt20CK;8ud.7$spW.#1<qCuq
9PG'LBK\<iA-_jS=ZKK03:lQu,KtbhUi.g@PK^l]Al\!4A#7sQP5r]A2QWa"2V$>jhjC09&r>;
NWG&cPg?S8Vf]Am$B>SueoK9(,-Raq#')S=@P"m9#(C@I.`Sl`<:=_#\H3-nTUqtZQhFoNCP<
$*]Ak:pM]ArNS&+\T'Q!$+'C,Ps.umL2l#!MH-2cPaC18J0TrbE)#(kP\0;piHiN,gT/O7$og=
)5lA;&r1:W10V7]ADdcc@l*\h5$gsoc'O9.;nkP4*BVhcSo&TnbTMUk==EA.Ul^C.f[Mp)%pZ
'q74&Rup)Ghi8O&YR-@<k59VlY%$HNi*kHc-OBE+^s_@-/LBfJ0bGj"DXfa"]A*1J]A=(^X-VZ
06b3j_Uh*+C>]AJtiJ+eMAi-7F5[?UDudm(%Ma7L7Yq\6>cbS#\;g+mgq-JkHRW?7^7?cW'[l
B$OZ.@9tEO"hjB*1nWrm0&%Xg"YFr/5Nfnk6knKecRl3'uJ:m@bgNbJj,NIJ;1H!h3l/.$g7
q<Dc7q1F//SIpfGH+<[*?G_cf*lSFnhE^Uo59Ktc)7AOkPJ.qu#C4I_/6-8>kV,X]AT4HP`7t
]AriAL1"%-H"n-Q]A[q0EV?84FpB9ZF/1Ydqs8><Bcpa3;N92d`ns*_i.#&<Y#]A<SmRTLT&&^5
cP-hBUR'&g'1n?iO+"$a=\jL@Ci?K!s7d`P,bt8;cj"q9mN#3CCcVrk&fsW#XC-%I#3^nKjY
U!oOPXEcYY+OuIn-s5UB+5dSI9j)cjp%FcH+hH?q&6]A&Cr`>XM!qp(ob8*D.geSFn(fK^Y:4
:f^AIO+amZ/5W&Ea,?MU.L$9\\;^HDgIrZKoc@$'ITr+cG*Qt\^\0-6XN?N3Fp#s*g=AuPFa
\<GJ$^$2"PbhH=2hP]A@N&o)e)XOo=be7L6J[pF+=pt"YrQ$54J(*b4UW+@dGbj`"j%sblr4a
AYhs@K]A_ib[khFp(1,#3Ml/e^cCU/C7Lai=$p&3rD_'I=e)`<D\c'QiJ8W_b.>Z;!e9%QBQB
DsP]A4>3PWqWLsloO2`"t5^j1gc!mF`Sse@=\2+Q*,"F!V64!muOp`i$T0%rZDuf,_u'[3m8B
NENuE?[l#tH+t)W`".aY%^<+gJ/?@)tD0>V)e@+-5.@gqM&?@$WXCF=?hD_=r/T>hXkOiUXM
?$DUT^?A2W7H_%;0YQdIA@LWh9Hth/afLG)%0!n@bJ8OSSak^O\M%Nb9[*dS?1_NMAf.5dE^
WTjGDp&:p8SFfX-l`\29Nq$%,3VlVJ,D%4I1:#qXp)\_Z@BnX./+$im3WET,RD-Q#Y\%P`.@
U>5#/_*e>)mu.*jH>#s="[qm,ae`p_HjjLWXr7+BSMG.CbVB3MBq,&Q%^Up+EYg#On@<Mn-Q
mtP!.pSLH9g9nmnQlB>1u.eU"kF6K0D#[@in\G<,n0F2W^.5nsF[!F/A2b,U[`KDX<cpkTBR
p&#*Qg]Ai2^cI'4fP`^j00q\aUh2p24:>d1(U@[6#76%#^`SWQ+m4q?8OMr?asenhI8=sd9,n
2"g;.#bs4LdOkAR]Ao8jPL@G.2fV,'7QC)]AW&3;=AeF,h@.%;$"os"g]Ap1bon2q7p7=)3DX39
c`G5K<mqb6C5e>;J#qZgDUp>gr[gUDNNr$eoUcQZ]At1[C<K3u,D?!X^^o3;FNDSHn#ZWM*RR
1t@'QiV6g330=/9CK;X[!<C;8eN>#gj=O\(oc!MgPDUTr^!ggnP&I#@5E+6b(QFeRpbb=%CO
sEHnbsf!YD6q0!"f+!BbkDQCUi0!KoRqSNJr_iU:*]AV"X2f.0X(fW/n<>mW>JCKWT$TrobYo
Rm<Qs*T4Z^M(l97%jSe1H7qU#0=*(WRm5D8RR9kZq,/8r_PF#q_(Je#&kn7Z1s$.GX*RCa5D
!1dunMIlp/V,ni/\ulFTE<b#DE\2>(VA]AXh@TsYYQLVoRC$7<Uhd)&VDt)RT\C26X_c&=8Zh
.(nD_N(L1T[#\+PN?ebHh-C&)mYBC4eB5$2-E4!-\Y-K6B(<dg!GCb1guN`'2o*0RSCHm+$.
^;MCFC@QL]A>Moq0l]A7*q5(O067qpZZH?W>7Qm.QV,r4NcQKZQ7,0B,Hqrn&BA^7XE(4XqZRV
*5_8+Lcc#I:PfD6K.p/#kmpEc'ZOo+j_h)KmC/qrR$oP$e6;\h70On"R@pmRs)37A@X=cI(5
ASb.0ZYZm/'8(sV&Nu9WVE@n,Aj8R$0ecJY+>setOOeO]AsSK#S[iW>+_$Gn1hE3bGm)<:&ID
;Cr#-/`eOV$=#FGl3V*.t-u@!8O/H5mGs2%9e4Yc855>V(1#sDd_2nc.AVO9o0qE=i,9;;*P
:0dkr<P3#WiWg=56(f5[@nIT#=YYas/B-RAc=gb>b9V6^.WG.3%mfO<:aF_L6AH7]Ajd#X'ia
m@peJ4tV@`Zg.9!.1&,]AI3`^60hK8JeCT!]A^b3<-?s:cJV9HgJ6ljd0rS.!ni@gjcI0d``]AZ
s>#me.(^Wngr+SG2CeVTO/s^%4a`?1&*(7GJCq[)g&]AY4^t2CY:GbZ<\!c\d^bH$h9AC.#Ro
U`(hGSDGR8cXrmDI>Y43LmkZXHWW%?9ZU51G)PeEBf32+A?[P1Eo7rRC8M[q%Fi60ugblekG
?AWF1QpeG%J1<K`fK3f1?u7M7_@Uu/5(gFY]AlQ?9HZ:70)(XhDV92:AXUg`hAF,3BNrtc?ZJ
.Be!VS+/A,r8W#]AUGMcd@TGbRJCc(g^t#pO,rf/7FZa(KkCe<YFlFS9nEmG2sflPoV4DR)B&
L:pq(9p-KPPaf[03n3//84el2p,SU@Y&E<e48m!5k:>mS:`s:aa>gcUmP4'![^r3\<Ht-jmC
/?m4E$Js`%I8fp-ZbVLbBrT2rmg3JYB59^D,.'RR+41DmR*t6.:%<'SuJB$WH1:9Bl;&[G1s
[1-p*@9mUjh%loB)e+QAXR\(2/K7E`"Rt8\>aS]Aq"g2G-#%uoKKO1,T)9X)*ELW_!i^+,ZeG
"8N_YJ#!a=*a#\2ckI<4:ss>6[WbEjP/ob-89`"0V4QBqA3j<DkkS$H1A@PPt4]Agj_o4'+tK
D]A+fu_ln%PYMTacJ[63.[KM=f:_ja<2nU.74CWts`n:FS*W.fK1-?HN+,VRXtJVou#=H$?@V
A,5EQqh1%/\a[7"5`qse2U-[TW5g/*[95tc8m>Y=[4?e($IX?dpLsXL9VMD4>DeN*7TSJn8W
jD.D]Ap4EopQs2%<d+FGbho.J![\WT9a\i"Xe)0A'S4(Do47b[ns1DbkBg7_W"gW"J."D7uaa
N/Cscm+tMBbps&f@I:6Fn3@*JNj`AEXX5PY2K[DG=,r]AN*,#rS)1YMk3S7Z>rac\XiBDILJX
nclO)H+P@<-)r7m%AB4cq9>m<]AG,;.TR.%2h!!f^ut&*ppbK-/%m5mnL3h,5,^Nub2/9&D6V
]AXEh;Zfg<"%'gA0U-[9etH\ddE!bEjhaJm!MJAq)fB=sNJb\bqoVAVe+-]Ao.;0AJ8/)'`b.`
/c.225=-ET+qU8GPI!)Vn<Oshroq-=4ulo\<*JG@1l`NZ7iOp"rgm!=N9bg'!kRp56GORe[F
*Ze-_X/uIu\GX%q8D]AHVhsnoe3UHq]Arj72_:7Oo_6tRe:(/>Vaf^d`ll=fd@n%3OV*s/1GB'
E5cC3rSVL"`4,=%9UnoX3?,*R:BL&@YTsUT4PY@5*euHO6H$jM!;mT:cn]A"sa^^-.oh6sb=V
0:)"c?G_6C3@L_g6;7,[NEI*B(54.;OV&q)[lG0p<j7TOu4D+A5J*l^QYX%\*Jqe,JhEM*\M
pH^o-T_fHdFK%fYZf3NGgLkNAuB8VctGdtb#[j`_g@$l]A4*bds?]AR2s1r#Kmm$K]A`Ft_'0aG
:i-ejDrYFFqj+E8I)?#&nLA^DgL8:mL%Dc9XL:USU3tuOh^_2K22!1O"jg-AjEb/0^7ZgQ:t
p/-IFVq'T)+u!%9^n^kl6"'ijBVbiUtpH03[;jqhVS7YRf<5a<tonb/^8/^Jp"XT9.Q!`-go
)Ancj+At%<HMZL<?V1G9Ao;%Tu!F_@B!goTDGq^O=UElgC(>l,gd2;_tB3jC=O2f&1UPd'PK
l7AQG1e(>XGa]A1RA0!W:8s!tjIVQ?M!,/U)mDiHX.?]AiXL)!JUcITNF_S_Q#!/fV?WNdo@42
&gC,)AJhhDD")JJg>kZmJap,;5?D:5sXkc:K<PEBa9QJib.b2@A'=f8diS'($\QfG^::d657
<V:tQcM8h.YA!b906q&.bhUAFrf9M_q7qLH]AcK%fEko7":9)5UF&FU)HT<''_1NQ=7K1_:?M
eX8PlN")9X/f2V0V)gpQ\<nWlWS%lLIur)*(Vq7HW-ldPgCM\!U*Zq7/t[9ZJGbQ.kcu=B"2
=\U'`,/'WYkV="K!,4qkKms9LrMB1a<E2$n+Hcb8#[6CjDjWHYeq-Eh1YqEGH[#\I$_SaY#0
6s+V&9ekked7;eIqgeapJ!s&-/Cq+$nJ]A'<O`5Pkso[XafNomjgLWZXf\Qir?*7RbjSm?4jn
0BU"W^h_-pVV[c"TsC<]AHfJ&k2h;AtI\)mqGgGF1Au-jRGfBJ=7o'0tg_r^p'8Ru#;&!QrN3
bM*[Z(L"O&b\Ib3rMfc\PJ&jiaBeq0h!'-.7%NSC.lPPk?f-?/)J^>q_`CpK:4B,;5VFnR+2
lsrb#LEK0=,:Kcpb_Ad,oTnLP"t2%U#^bl?GK@#f#m]AeM=%mEkc)6Jq$!H.f(=?7BVk&!<L&
!-+?lu-E%'@#]AC,V5>Ce6PpoMtk!^cG??pg.R;Z1q3IMG>\!%.Oe9l+@1H\dgM`c9uVH%P,=
ViOb3o&![&4=r6"5C/t_iChbV1o%?35?R6TX/?,aURKVM_s0-iV55%@%DcD&/3kXqm0<oYUo
!7:?C?Xd(bl7%-V#>^1&&tR$EUA^)sfY))_-f;"C/c9m'a2'L>+uOPYniJ-&#_#t5C>64m$*
UkD8F<LT"GV5cA;(6PIZ&<Paq'2Vk_:o#TITsrD7,cHcQ1[i!&bb&,HS?qtDCYe;_Aaa\"&t
C/L'^2rT4oGqOaX4Lgfb7Y;VC2"LF@A%:4qKC0\K;eIZ;OFWgW[s^UTPuJO%s"j)G3%.='1u
og)JlQ`[a/KhRGVWecVdHDlLsZYX/0[4>F$I(%ZIg)BJ=#DW\C$T=ef]A/&n-$Ir)858!+:G^
HqM0j(.Cg6e3<2P\l2j>C]A`1B<cMeWhMT,,0Z_ac&\FPL+8o!<n;06PNYkoH3_<.oRN'g:C*
(lM=En5FOnBubKNj'eAa=CQJ`*/7m;P`2\1r*_)!RhiOW9_O.L0hN?d44,Z+_N>CF'?R\/.o
1*]A3Y>XM'OR]AA6E#.Our/68rm.JOlAgp+D^e^E`B-JR&/`NXr(E5<aPoc.GU#sOn?)@/dX9>
_pK85AVse6B(Ah_P&"=^?P(QE%F*c"qSW.o"n#PM#<Q]A,KYf=LUUW:g6GE3K%o&h9n6=BBCE
i"GIXaU4qkr&`s/@Q+%0H3Nqpr7uR*Vm(G>o;nHuX1F3u$N&oWCANXHB9p0/l//eI[8lturc
9)&&ItCY&Fj4MDlH+'eSP-(]Ah/:^/')U`]A'SLiA>^I]AQ+%HBLGiBo85?p(jaOS7Im>H/(12*
t2_7a&q=3CRD7t[-P9>kM<dgbF?AYI-CDS$^aK;tZ)kA<'kWPECS<^IM+HI9SqQh1&1^;ko6
\L>aNCK%6DG%'<5aA^A#j!_cF%R[U<C*2i8*5,jQ9fa0_';$f4g:L29_-&FsLN\9S5JaAK4E
dkt+!A/eGdj_I._a9"5%,;(9+:+V!=:(mm?n^QDSDX^Ie17-=HV]AtTkLu$It2:J\N``V%#(d
lr#DmMpEGr;plL%p[ouk+COW$7-]AnG!<X[#B:FY7nKGWFO4GdVX"Js%42'a.9Rkg`bA)Ji%Y
K=Yb!(Nm5\ZY5@WA28]AQa(OYHPsSg\^c'Q611LYqm@G!DKBqo8s*>gL#Jf20m`Ul8VV!!,8H
Ph'A##YaO4%*gUpfQ^Y!SF$Suls,XXa>9X5g1EpI-?)sY3U8Jjp:j=-=Q=AO09KMN*T9)@mC
TFV+7=MmLr/V=\K_=5.#d5Ul-?)+<$6&$m4N<IVfApCc^W=pd-W:B!N+=O[I2br.f_oA(JLK
`oqiiQ"8-4^Z?bm&qT:EZb-cQR[9^."=9K8\q"d7n@)"e-'.\_f`:iQ:o_4JlP^aSC?TI`T=
]AUHl?OCp.(67mK8o#u(CXdC<DbB+\UZ[r`;I11=&WVC^NeHnf-so"?BIqtRX1kiZ8!7%5t\9
hk8&-huBIF+-d$I.JerK'U5]A5I.$Y;eXnlA",LC+6LdE\6k8XJJZQm<;QaC2Rq"e:EIn76XQ
u,q3d%&`k9`_*&"MG?GK5qIn80g=8$_OiH8(I?b<6rA@mui)"=3Zq9?!^a?(G6(sBDl)El\X
)04h^6]A'DKK\Iu/Sj,*"lV(BmP-qf8`qYYDC(i-\[WTCG4B$eU.?JR9ph?ARe&P0UUCS'Z.G
h**gc#j46snZm&S)6?;09<;JE.qNUm&D:r..1g(4F+A'@tBO<`^WSs+7g.GKl>.hf2m3i5"X
hFfV8=60BlVOhAV>%rq_FNi??q;0ptg_W)AjlLW%@=*RT$(=I&406Rp25i5:T41sf9PD^lN+
@^1o)a!4gWfrV2I;&h)?),H_KY5n?bRiDYM5W@I3S/&h>h/T2Nd1l*>4QMVS&p2`ZNN7n&qr
DP2K'[cC^mOp`JGUb0=^u3DP"+=[T>rqrq3b^Z>ePRDIu;oRa&lfqp<L;6E=2R,,2g>OO]A:U
g.0&QTEefjBiqVaDgCa@k^24KIH^/ik]A)N57"^uE[C<uQE(hhR`uEM+X@d^S/8UN7aXHuD8$
u+N?APYnZS;Lj\A-\*Xr.E==U<C&!%8*>?G$]A7k]A<P%;UKrhdIhbU*h2q8"NkSL6WRsaRp'Y
URuVU%$Q(dtj`_@27+jpN7;dIf6f#n',BH`#WHIALP%is3L<9EsIBiJIUYcL2W21f'_MKAM>
"6#C%="c;dUe98of/A$FVd:pH,HMp"m#=FPhOiKAq05W@?+cp4A#R8Z0)Gj#CTI5^=t/ZEOF
":[%"-[#H?ELSGlUVl5Uki7C8ShZ(1oe0d$56MeK:[P.=#C-!JsRMin;8V!<DJ$de7Z689bX
gg[/[3oobkm,PeIm+kVk=u.>JYTOV9M/.&#r4P2D:t!3:faMeb'2:;kfY<F.A]APP+:Ut*WU_
/b=f_[RZrp?X7W'dp`T\&kU=q=ki&.KY7=&:(d#QYEE3B`,%nTE>TP3h%b?ZfApkZn_Bs4Ud
sUZBA*PKY9E]AemCoD=*:Z@@7nrZMBF+`5a:OOAQD\_U0_I)Cq9N"V39MZM@_Flk(d]ALgn4)m
60R7^CBF@D\,PUr:Xh]AKL6]AFW\HBQ7JZO&`P8XioF-c%^Ys:bd1$!<!pECuofCnf*XOnRX3,
'S(RSFb2C=3q4tlW\ja6=C7ao7C$E:.T-NQJrn2m2[(E;67LTjP?hDr>r^Ohe=&N[Dc]ApiX/
-mT:6nm:]A\DU7(*=?hs_Z28A!RnO#85M_t1&M_^nk&OHKs&K3IfK5.g==[70BL0@boIh]AdF.
_i3#r:b*5O?<"$O#d.CUqUV<FH5bC9s%/>=k."$:gg6oP+L7eVQ'*9V,cYCauU9/1G?'8$["
=M20Y$8iU79$F]A8GXFp+dabtbXo):H/hD^\#PO_d(;E#&VR);Yl+S?N:_&C8@.OL"T//AXYK
"K5p+Kl(c8"Yh:>:>d-R_NMN)X=-*)Pqk*&XP:`2]ANq^L@g,j<hsBRo/NrETC"j1'R_@e,5M
QbSPuNYPT]A*8+(ONj'jg_WJIGWQ>C86^27W;'S14L$VG4cf5gtEPNs1RH]A"ICA:.iEW%k7;8
dSuste:5@*]AMqOT3^pd82fP0`*HZ"ZKE3b/:+!="O^G"/Gj,pmB0@^*5fi!1br,0#Q79-"h$
(gLG?BiI6m*HHBT=<QDE15X%U,+m"&D4^Khe*T=b\*a9$6Y`(UGAZ*&8GT7Pm&=YmQ-fGoG<
2]AEhD@X4LLQTFNa\8?&p(Mk=keW('#WU%+;kHSYE4kF\!2IljNUnF/GmZ'"H[r&-8$[Pp.^A
TX7`a)0i48-+*.eCS+e[@8o8U2m\^f>DN25q>(;'20D09.j*>j78o>DY?BakdBq6ddW:r@+(
Dk3D<7oMlMbY\).@qJrNGlE)'D'X+TiP<@LrG]A4lB+?P+Mn@%+bhcg<XG/CpmJrBtA<P$jaK
gl.LaHLb/1cffFDFTeU-FR+/B<hEgE:s;!GPr#T6#:tgc0082i<^W*qP35:sRe;%66*T*hA/
R;g".&T'VgSm6T-hV_)2si=+Y#;/!=n+Wl$Anm893Usfnh6TRZFsrQ/tua.bkQ@XJ5[%!<ar
ePoTpnme.ilkSn)"WtEU4<tX5Xg"b-K<1D!163rjS0*8F?mFj9$0-7S]A_tO4MCGM%216\'i9
)!p&1h'So,1"m9M/5ci;V>q[5BEOX5HA#/)c!(:gWbX/s*]AEP*V?0GSkag[[HCY:bF#cdhnb
r2q*)7<966E3(-6[BQcJP_IO\1OI)MRXL5<hp3K;BCP]AYDWpr?_N#HI4r-uK5R:=sJmW9*Dq
&1g<u>@C(/e\ccr7+;<b=Oq?1'\Z5$^h<p_0I&Abo;8s%B7V"[J/HPPjQ/#727&a^Q`]AScU@
-.bh7@;0PHc^;+f4*(SJOkc]A;ou1kt;-$J+M^feZeH.0+[Hb2?6*;3'\M-NGE-=S;aD.8U&>
rc_oEc05hf0a4+;X+^/d!9YN"+:pA`REPjgu8^B,p,T?V(Yr03;9RC_r0c$Wo!Wsm-UCj_*e
6,_;L6H:T@Tthd[,;iM(I<ci8t+KebEPW06WE)LPA>qW%nY#N77Nd/YLmj?I%fAVr*tgt-l2
='DNGoWH#:EmW_L_1GkO%0i!l[<i9_+CJU<t-ep`n09C'PKdq2o-YRPBSl2/SeU8X:"oek`V
pZem#9W+\W:ehCR<'',BY%"P?9GEXnrCb;)j"&+N_74U6(j2rEDn[LT6E_H]A/o[e`j@Y2WXJ
<>O*r4Tn*p<:f?Rm:m.JL`!e%VBV(3eP*T"X=4i^"!)b!S)A^VpICl[MJKY`gPF8^/?U+Y0)
Y@F!,-NW54YBPt<OQoJkmdDl+<c"@?9>.e)$QKK\=6U10t^)$Ga.QVq0T:_lQ_GFlLdqtQo#
Cu8bblYDVn$NF$&&huc/D[+_i;e%B*NMK!**0KN50l0_=@XXlF/A2WJORcBmO3AIZB't9*ZP
G-+e"]A)k]A4pD&rU!*2O1q^.@TdPXb*#\l_(e8^@lQ+I7tM<Co;l>^uQ/7nZe4eg([)BSOgCg
b+DmSkk+(CgYse\jgFgm%5R78rqtVq<\@qsp)tj4O(ouJAl3TO?Z1->cR6sjW\oj#4]At">OA
MHpm'S0-+qLkcnu(mM_(c9Daf2Q33Nf/\&3K$(]AUq0'%8pm)o_QB;9P)EH4I+f5l+lFPgcRu
7nD)4#N-!'uX@n\?J>;VLq)c!M0;PA10qq`*"T+E*2h$^"JKG*?ljl5"O9oj+.<r?N#F0;!(
I?pV),'0!5g)#U.8(RQq"nO&Z([OsrZ.Q(AI(PoF@qBHg\ISnN2_-,QN3.58n`R^ht+eH$#>
=)qSV^PkORr>H1nK<:/-KH852U.?.GKUet"C.F+KhY,Q8[oB<2a;L82M(LTJT'HN%S:[LIbq
^Za7]A.Vt/pV!BQ+Z>c.BB_ea<-QH78AU$c>,Kk8_5N[9d_'Y0]A"Gl^eP\+0ChH&i*Su[6[,L
Xj^;u1r4obQ0'B]AJ9EFInj3R)V>q*D7m(OKb-.;r+JJr5<n\rXE)#/fhupi#(l5NGojH,k<3
e8\`!mA/5'?&g!Dd%<!VC9<$Af+d]AZj&sOXQZW591#_"5No!%;7#^o(aE``C9UYO)aY`m>Pr
)gaIVOJDDaF?Cd1@*:8Cj=O>_,.ir&.2P=qKcq,CuF\]A\@Zb*<hGkO!r4o$MsL[tJd$^nc/&
sHbF'p=p&$kPlH*:?mlMk'qXoKui<EkoFijHMa0@Gh[aucGHPMp6gp4[!N(gHrU(W]AM/1'Ym
k35p<TtT6aqDR6rjDfgm@H[3/RUGJuUC/otJsC#"<^]Ad/l-(2>(`GCH&@<p\/M*#VLQQJDM-
JVALiEc-pS8>XhqCR^CIGH,C_9rum@P,Q1G3e43\?ES5lrZ%A(pY![rQ;qOehW02A&F\U&*F
cH<M[tTM*Uh_lhRm:UJ08l5Q(@D]A^"'V'%qRi+['-C>2tH#Lar@-Bu>p=p44-aI_iBcdRf09
kH?X)rh9]A]A`>ImNAq^F&IB:*'>Y3#GcTAc9DSE5Pg]AT<;>`EcE?fsj/'bZq-S[Ps!A@&OOX8
kO9:rf(Ue<l2E^'GYcHfR(TPZ>)f81%OQd$2R4R^M/5e?i[^S';U"lT<i"Esf*o:Tp-:/m+%
9u*Y>\_8\Y]An,lWkH[Xl]A>%`6e@I\r/obUOQ$<DeD"Efs)U4D'b[*21>*:sNaI:p8J6'P9hS
AtGCcF\2cug\:6kZ]A3Fl?Ill.<gBX@kI3H4hHKDhjtFkkmJ'Y]AV&13qcR!e/qbY5@"gTT575
&Gq8F/B*%hkkToi3D+PHqA:eOQVomqS[IMp/)I#?YN<fcn"_1e#iH4#nk,:IVet65PQ?EmoH
4?%/]At!Z7T[ZJES9KP*1HXu?4"%_F/@N628<psZ=9,KUS_D@HJ/FHc2@I]A]Aqoq6N:5Caup,Y
E2!f3en%QTq*Hn-Hh-3-buRurQgHdI0M9!'f_`RN_QC.q:qBI8EM_&%"e*O78#h0-0"r8e?Z
7DF'6<)u`gc@%08c7'Q7\USF?q6SoX3<A]A-X/9uJHVGh_We@qYB5Wj:i(&k("#XegDU$S:E9
gF2blALrD?gCDWlRkhc!O.X*uAlAgNAF?@UJj56_k9G42E:2KMhp$$j?eJ0c!$7=sJWWF$PM
JLT*Wid#d)X'M\_8OU:b[eW<*AI3DcBo^j]AP]AJriNKZ81)fUH?@I+`*l1J[PI?@*O5q(`\jY
loPSo!M_ZI1C3,^3a-b)s:7A=+<DJQ=e4c97$G2KoXcLrQb^i9]A#h/V:lkKN$KAE^]A$@CMY9
X7;'.YSd,+^<%&ZHNpH3?E0M2j%MOBX;jZM>G<NBG0KJJmXL^@.`a1D]AY:KJth6k_[@U9T?W
;>PcYq^)Na#&gq+gq<HgMjP#Gg5bUV96<pj<K'oj0So-5Y,`m`ge=$(1jcQk6&63u5SeYGrJ
E9<ROANi5r9a*U+4]A[@arFpe3g,hCuCcPg9ZkudUHVZ,t(mA5XW:r*gDfnlIML`Vj-`"8=Sf
\&#ecmqUMck:SS#phIBX8!na+Cb:gr!Kg^ak6i@6p_DoSL&n.F;J@>]A.<if\p13nMlO9o3cK
I]A8F=f<uJQZ8U;(;V/q5:.a=`^p-0ju-4s_>DSsJUY3X9SF<rO2TdA%E<(V%mrpSanZ:o%K7
]AgK#o`^==-JI;,A\-D>Io;K;CMQWFjBorC!qL1;1H4m*Ya$aT$M1O(uVMRS*'$r_XG&#O2Dr
mdK]AWVopLU_h/jjTAP+eaE+XgK-dAbdr)%Oc,^@PQ(bBARr[JQOV6-V:1J^6E!i/.Yt4m)+;
^kV//Tcaa^%R%=(/?hSU-OsSI"c&J)O(e^*)S%30Y?pR3\$,3I#]AobNsK9IcoJ!B#!RFhdcW
_7cOl@6i[Iop,;XAYJjd_\K:<C<6dP!F>KmDr$QS269"<G"--gsXS]A]A\JKK-b?$%h/=Me&fg
k[eTh/ilS?4Q`q)m7@Q8Zr%KYeWg3ZgM%C.dT%1&S/t5p_Y/4^!N[75eC;LPM80"2M:;5>*'
q&`EQ:Gbp=t2g<)+l.)qaV&)i6.OY;<jhd:DC9=T-95Rs00"XUb>L#Ah^VH7!_o&>YWe[blB
9[dU"jUe6O.?Ra<3UPmF$`\:u#gE""1&C_>2g;g`bu\&WDH>TaKs@.lGRU9d+<G&-lmi#4>!
^aub&@(I"F]AOh?]AS2BUf-VY;>@HMDF+^kUn%i]Aior/6P3=mfBlY=sA2!,5GhU!_J),jiI+.S
lA8oSS%&DtU\,7%,26>GR.ARoI;<nkJg`HrROiE[MRdc+m;p//?DCrkPn&YMDW\.KYYT+"F!
NE?GqZNJkM59U3lP_Q0NOlkp4crp30g`W#6N=b!SBe7k)9M^kZ6*f^TP%c+''PH)lLT88TO&
a@YllWUUKHBgH1_Yf,T60"AWnmR_=%#\2jn#j/fr.AP;RSjr^&`rU0)+FCmtHLMjt$\<+`jR
mb$<Mnld2iq':h^q,?R*_Oknfh9-;!').GW^8Z@V>=_lEHeDpjr*jLa@?njprYe:C?,'ImFf
3)8=.A6rUAM'$!2m3;3k=+j;$4oXn3A^*'>]A:`GWrCUK8%W156k@<>:>D,iG`X?GdZ4.)hb;
d1c0j;7S.>2[V1r5=@AG;C0\59j2g,$G.jISDh-E1"0RfbgX$-2`<6/S@th?&r3eCcbO!8uA
PqWmnJghsOH>KFRrDHlNt@VLSQ[>VL6s<:&i;JF/Xc>gF*\S_HjdWK_=V118'Ynk)cAK#NLp
ofP.*TPE3-,J+AMSoNgEO7nagJmTuT/:\XKis$=P8H$ED[hje6uo6:6l!8!%M+*(o^E<cF%-
V@TIl_=9L6WVuO*Fp%kRqc%0"AT'\3]A2\Pc`HhEF/>-%75b-uWUR1@?Z.G@@h#c(P$i$JG'U
KR3c`*?]ABDnj>*s*k&N5,u!OEC[s-6D<&Ha[tnBK%Aor,*]AR1*,=ha?Va!7>8`J6CKp2#fD8
.Ys)V*$-RucQJGhfOM&"Vi#Z-efHPc>o,EUL4Y8Z13[if:4h&J7pi,O<n4&1'/q:?_VXSn%+
EX;R%O%g32%f4SieVlF1)aGD1Hu'.Rho9gVTT!^,]A!!^NtOGcIl$;#'5"![dmMj4!>6Hi#A!
AM\:NX8\gVQTm:W>/q%Jt$*Vd(+o;SU"=E<Y0UM.ejRQVb#?/m2SO^iYIj8$)k6:-L@OUm^$
7Pdl"N<O1i:e^[/6P[;!k#3d/pQdr-;E&T`%?sY'RllrZmp:r;6eBH&a\:=cmZ-XLKnJ(;nC
<^-fuugQiViT._Jcm>.`>L30@q.(Am9tj9Pjl6RCQRnplc+gpk$Y2-Zk%SXTSn9&qC)>&dB7
%b,3PIs6tW1o^XkK6t9.B.mYfDbFd>0AihI<A[l<WC?7<F`>N`_<fVliZS7:"SIZ`*,K`B;Y
;22g;'Nel#=ltrP2(!mV'FQZ\CdZNh2;*j:j)22B8WfnM(^4&)WHXaOI84^g_>hIF_S+fF?4
aLau<qD//E'EbXPa=/h@:j7[lBCRFO3#Vi=l8:Y4C3?/PH5J)\Ho8n8=*PI2"WYbcZ6C)-ne
C?R"0[]A2+B,2dPE^'EXLia[4!fIPU8eSs/;_'(KAR,H#">6rOV)P.rhGda0nP,sT(0RY/FU\
Fb:Bk(MIS@61ciP&Cr/fq>u:sNSO35G6',(Z')cEeJ!;A3N-U&]AfdSUMjgHi9jtf<PK#qIcM
277mlb+c>UlbdoC"Q=\>g$hbp@=Ksj>'rKk5ni\EPi/?40R5t#5ooJc94.[[[$9g,(j8HVtD
j?sE2"n1ullJsb,Q/*qb"L$PA6?uQDFY0>]AJY5sjfU<N?UKnZkfM\)%iEB:C#X2p,`.ZEh66
b\H#o`R\Y!SG.B/Wr_]AmColjmG*;DNV6"1oR\e=J#Oi79H,pVC1=]AYB'WNah:-ZVNm=Xe3A>
clq7SlBp4?#F<(.F>)(h]A^<J[@P&!+MIUcNCpVTqNc=;@BPOGOk_^Cb1YjK%prJ7t"))naId
_#p&BC7:MP=@3HhQNAhjse9GjBh.=/pJ:oKr:5[fo4o#=_7BQcS#\dSp\lj_c<On;gP^JecB
JRL4o(2opo\=H_5B+61#ll_I"K`:\_f``;g90/fLuBR7e1_Q'O5YP<DR;!P#_g_p%<-u]A:hM
!^@a%GlEZ%mnOiofVf[j.5bPAYK@&,g,LQB*Ho4`2P@=Aq&:nGV4",#`:ZJ4auLW?C@hl#!;
2A!'P=$_hAO_!JrK'X:eG)F;C7Le9(aIMI7;tEn77Leiq.XA?dU^OrF-&I5lW$T_GL26OV&(
:@pCL/tAn).Akb@f^UQ&IaEBk>"M[)d^VN51c#h'jWWCX_%-9#^WRp_'X`A$T([;h9tf^F?(
]A9+Q1BmqA"UrYX1:=]A1,F*3']A[auSWmF5-@4O^g8W3c$DY3pL)[5O:1OCh8QC$]AmuGe(=4%j
toq]Ad2LKBmgrQG:<jWm2N`fluLKn]At%^]AblMX;2G`+mnjpaI?!)g.7;rqGPMp<+1AC/qT8#Q
!>JuUR7+HjLX'`:Us#'S*:Br>hp%_W?hm:=7OikD_915$Y!,BF/tblXS/F@pL"TV(?%G"cJ]A
q#jX<>TjFd$!G@'`Fi85@-#KqqZNjCUqSPk@nda%qX&cfj.]ANEWK2Y<%9OW\QD2n@g`L(`_k
XHjI_f`B2\eu.'QI`i^,,H`^JH?_.U]AheDT-@`7P0NM>,jPGT\)l7ts+"MpJ/F>*I*fZpaa,
W2BR!3;RI$mLZ`)mpMk1N*Lk'I!'l]A/6aIe'L,ku0Ok/9W%D40KZm&aAg@lC+bp4:<d96i<`
%>aDq^HOXrj(A8hreE/;?gm?@:4@uL$F^dS%\1mu=fa*f6X.I/Vf1hL;#L_o,Yf&mMl8/'S)
LJl0mhfCg<\gF$P>AQ\^RmAh*5m%90u!)H$2lGOodRo:cY)0@r3,@@oN_;hJ*Q<"foV^k5.q
7=kq&S=e03/.\prc;)151V+@(r9g*SCGa(-M=e]A2s:q!n5</[!*!nN60e6uY&KoK%52\^eR.
BZnkQf8!NCKHJ1Nn+]AKDh)!qQs,'?c6h,Ir7`2G'+ZUrpa8#;?N4cePfjl5i6lsZ0Mf4>YKH
-]A$$^nNk:t[qrrT/VI*.<b)Y&>2qcFUF0:L5(qh"`EiJ>W@0iY1jA,o1YdGum"/`ckR,B6>h
QJ(TC:3BSQ*^?;Wa]AOer"1D7?DT,V2G$fg<_GEX$=Kt'r,mcWYUMCG*8_LKNZSTjcFKM3V?^
dD;R-lRr_[V%hs8#t6RJ`rpc9<JonGEgs(nj,BU929PFX5@7:ON(!9`cK>GqdfBke*9KuQ!2
p2bqCO&Zrmoil#aE+#<s+cI8u`N"k1g$jI54I#lMm,6id)PFG*Tt*=ge.089=((mUslmrH@+
)ST:$TQ%Z!i4F;0Y5%(F:B$NiFX?BuD,)\VSV>58?%f(DE<>4qUN4YFYJkC*X4$Z2H;[Q-db
KT&XmcPgF^.2Ohs:_^rr0V2+EW!4=]AT%Ia6rl5-KU;P`">4uU?14^6D[H&`k7^!9="OrFo0q
1cC->Di$.@BDeSdpS)?]A<87-gk2#@VTLNn:e[uYFbM?M'XR<.OpI+1U5-(d@9&9seB>\]ADtA
Ok.AA)^O'fDaUV=-dhnL;e+!ap>baLLUKhc#,<Z/BIAt/*tZ<*(V2ILAZY47eaS`(ZQ7gc(.
_GSB/C4;EC?3Gnn!NZn_;.JqP:pWu8*to[^jI^JT&/RaDZ[Xtas*fSLhGm4#e25*PCJ<b<UF
C-@$>'?\^DIr78[LZ+3WSnp+G8Vg2o7ug9*#6iARWA[DFZ/8H7;qm#rURN30Bq9p@euKO_?I
Wk$r,tp6jn:J.Gm@9A?JV3R@AIO8/JW+W]AX]Aur#)M1[iH6,Ak`URk`rE'+(A%7gFPe_OUN&_
9X(ba(-&,2<NXQRZV-^WkQU\1Ec"fZaMRM<@BEY)R)o_U"U,7N'P^,%+$2Cd3YZZHXTB##2f
]AhcI6Z0U+aCr`S-%H!#Y,j<6<[hgrIR,5()5i:-.PYt*O2G7EFU)3b1q$gWWTrn#UjST2D?J
YroUK,ZKe<LaTAsr0YTij?T&?./$<9k(I"ZJk-3V;3mOk^*2]Ak@6&(;M"\%IY^^)3UgIB8rk
oF&r4\-_>:.:lf$+sPA(=Y@eFY]At^Kkn#'H4a_d^dT]ANC92?)ok6U&eH&E2Pla1Ea\,8MJd!
n=hQWgYl\#8*+Y.d`ekIDA-/?6^mTI4q/Bk@u9O7>6Y>@nn?+3rHlp).f1OOZ/\^O)6Hp9IH
e;8*i;0Ni<r3<a?f'&Z_@"6W<*kB!ZlGc0f4oA).tN<=QWP(r"V5SF$r3,2@#4J,ill;uW-l
>W%%OL2c??ioh5?hO:Mln]A3p^ja2:6uk2qh"LX]A$$#f)U5UlN/0P9l!5]AdaD5>'hde6l<+(C
s7(p0+a^Z%ihq0O;FB#p]A@Iuu2l9jpXc3I5eR^EFEDag=!loq%f)kGd'gONtP9lBceJatB#q
?<`_@KKdttj7Cd5UtreX*H=afZsgnGEfnfTO.;/?RaohlJ'c#KD_h6[Bk'iAeO)P-iSMoI_#
7Mj(t7l2<84`$$,p`k)F+,u3E:CHB!@jWJh8nhFlOR(q'lAs`r"J8"BV/YeK@I366*2k[P+5
or&NP5KGb*eGiuolX8rM<jPXANFaMtI;H1FEZObi8o/u7u5Xn:-.=0cnij@F1QMuG9Ab)os\
_+tLg[g.O>(r;`q"V]Aif*N7AjjGGJ#T/W5/l:r-qs:Y'.UUhVqV8CB!b>bK?9./b,8%na;k&
UKqfT2+j4K3W;&O1o/TAu/(%\K>0XF+fSmm6jSf?=72GAUj`lA>M^d=YFPY'J;K^:V(<liS9
k2++e.LqZq]AUJS?Qhi@d,_$e*,HI9lkOb3P!"h'/^.g4Vm>s\6s.4U7eoLhJ%b"--oLIJiip
>Ng7r#@Q#-c>2e<!8bA>r^'L++IXg,QOi"C:=URC1ShdAhfN+)_hADAM9Rr"<Fg)fZ6?Zp7e
?(XX>p)##QSA2[jEL``^Y\;2DL\bif(^*1#OgUq#(%k(*T_*G2V\?_ZM&K-geWjseYEX&!#(
ds;ZFXT7LEs6Y8+c4KW't02W1e8[1G4:;[&G.Ka9qT!ZCg@pPc?]AdU1s61UDKqSr@"<SE("e
fW7*%e9">'nP6LQ8eFf>_#ZR>Q$j2]AT'-!/XLEi:,aYgSdN\7t`SjJ`+oBb7?!'bH+>j]AtTV
e@i5Yj/I5KD/1D5`)m[J"]Ao%n&%8<(M?F!hp=Zrp!tjl_"&Ri-?rZ@M`XaSsMGQfuj#)*rCg
%:15c.'@q$`W:*/Lsr[$<%#LQ`mtC-!,Lcd\=LI`T.Ii?`rd<o[7HZ-FEEQ^[R@QL56>]A?=F
s>"2oo,.E.)]AHG']A[($\J>L.7dfAF9$^u)C?k7/GmMZhh)F`h+V<=YQDQjXVlba3hQhlk`iM
r!%qNV+_ZaK)a;f<Lo=l_-eN7,5^pQkpHpam-s8FUlR*OV6INph;;Mk(\k3^eFL.KcJX%i#4
kN#0F[g9u,Fa+6ERXI>GR8Y(XPD_>PtD?L'R)JkU*[=NtBTIie-a*7Bh/*G!)mn"o1&$g>,I
OVs^HP&>!h<"WSFXk1AA2.^gbH$eeN>eE$6]A;d\"!n/[AW]A9g0e+2i@gd$.[+rDjm:A*lXU<
c@oc?@bi+>O4ki%3f^ip"g",9_5fN`b'frELHN.<o8o=qNF^`nd"o0c;X+FIQBP1H[S4YXs?
>nQ"?io02?arSEl,8a,(sQK0h'=$6hX\"Z/ho9?Z%.)SGC?*io_>su,VaPq'OWe!F\?32c*$
3auM@0fW);<oMuJ)G"l5Zi^B#+TFIf@k@(@hQ/L.!9MB%=B/7l#C8<We(dQ!A7=p[G$(/Z+J
.S(=l@C+Qm\C_?HXEW&)g[POu^qfT,8PT+_\i?*3(nGA"X9i[k?R`o@F"\+PKh5dE#)cri+e
91\Be#8__I]AU.,!;<'n@L9bo[Uc.mq'n35YN6,J)X#4&+Z8im9/")@j%+?S7ps5%/*lmoE%G
<fO;+F`NJ-?qbV'Z-47G`F/?6CdV38:\O01aXn-4Vo=nIR"`$PHIY,88d6a@:gVUAoegD`SQ
o%hClq#X(h)gq:nSrei7F=5uhCr[\rd,'f]AuMV?!F1e?GOr!]A(/6!7[mmN%QmNjQn$MX!kRE
45N7LW'B6p?9ICSU941q`"%9.,o.Uh,(M>il</G=\`s#?l=k!S?YH^n>IQ;IL=#MfSm/J?23
YkrccUO_jLjUJ*=nFbj#(PX(ho_XAO7PcCtG$41s:*Ka-4J*EAAkKbgY0CeI0AHkaT(Sa.ll
dRS>k[)N1te/Pl^)D\\:/^GhoY`Z?bl0@brD#_Q'LqtXoIJKB?aj<.,aBNKJ`mpbeOa+m'U3
m*_&P$Y"&3'L"[f>>sha?R@BTUZ',B7dLOQi;CHOc$36GS"%S>+;uDT3EU7Z/7%/*WqI$]App
2q0*J"_mtr+OKT!tJ,7'=IX<'eqabce%%I*Sf^QglMfJ4@iX!]A,V.f[?nRQ>)Fhj;J9RI]A?^
_`/8A9pa*Nu)d!&W#EMNMF!LOJ&[&VJQiFPn5/\3rd*(huqWXNJkm+8ANf0-SHm#dV,L3.-j
,Z#`<]A2mR>&<OA*uYq1Wq5WhJ)p2C']Ak*mc.naRh+/jM#Jc8$e*P6;[Qo:s,%M0d\R#V#Z%X
e,T$6Q:)pqS,-pXWVs9a#^R2PIgQo\S<LC_i]AK^'/9kU)kL.]A/`=#k@?VVY'*C(8#%T5$E!B
:mul0#qB%/joEK*s2(qQfpY]AH&WOZ6eD0G9+U,%mbeU'a,s2$E?FF9VC0ie\/ln1P!SuZel1
J%!b\p[r9Xl`@3pB5T1o-.W35@^-.KTf`\%PK#FoLZZ)qAIa\jd^BqG'$;0&@#ArE)09F@9M
-8d=_1.g44;jS["`aP[@/O2l>Q3*leB%%`TmscGe%6O2GD1%n+pA?6.H4b0?S+j%Ca;BSh*f
=X#+dm9bW66,ru!/W)mcOM*$>0Q7V;Tr%F1lUGlK*i+iSdB-e\Xb::NE=%%X>A)B8_2m*9uR
"eGu95,T-5:e$+hAQh(/4d$BnVkRp4$#8IAk_8VnUfCto.mC[GK3:86E":+o`PLkK(T@D%jV
"N!&22pqeA\'XpB3E#?lLgNKnITT<J4%M(uX8(g;N/6,Ru$+39oec_7Kb5_'<2Gd<Z=X,lhR
"RM;rt1.7F0%@J9E18[ckkKVO\.fAdh>fpmMXPn[^>^"SAPgE1J$dKfYir+]AjpMQm-j8(<`:
pqu\Clj2a-5:aqSgJG!ce9@RVf3pJ(YV??L5#2bLOJ+ib4<NV$\!UH:L"h%_B0N(,,u+8`;9
Os@L+RjBYLB3/r=ZVj2Cb3=5mKF3C(r%U<mtnLpYjbYDqdc!t8<o<mGaiXhn_BJQ[8G;R3gs
c`OBWbFLID14A82!RA5%SH.71O:&ZA`Vpoj]A&>riZErda2/WX$k#J,JEgikVl16ZsS"Ug"6F
#?.ll.UjW`h)?%%0n&njS`HPn0&fhPEWc$`U\;-:Me/==C$(lR6`E6miBTU0-<ZP1h5KC[Fq
@SU.NU+ilVg@(+Pl7V6@\5agm3-IrtXGs%2(\8<8G#V1__89(8@7HB9cRrk#P@'m,ua-KocP
Vi2U&l5.()XBS$=$_cOD*&X1FRi>8jj7)TgIG`U.8hnn_)"jl-M?fh#PFj<:8)3$OM*B&hqh
"g_Zk#"-OhH#9A>5m9Y;LoFirq`7OmQa'YeXbg3N_TbU$rVE-c3-*U+h[o0ILh`R]A)De]AFjf
=H<Yf,TP(3erb=#<H_?/*9O-jGW8[r@_O+ek,0be_<!2fkOtX:<MQ^_1Y3*tM!sL96cTOl`o
cQ)HIM>T.i0+Hgb^MHWn8g9D!fYA(9[cTp!/gc:@!U]A032B?<3Y,Yn>krYF\?bp0"J"mSP?g
A,OF6'Za3,YF+K-Od\'8$I/3,"_3G6iR$"]A^cUL,J";t!"H15OgDL(ftjJoe"q5?[KL7E2tk
,Oh>r36bOC,htX]AA]AD<jNc%j]A4Y-E#)CcgqbVW\\]A/&]A/@*79S]ASRUW5DE2"F[W?54#f%U`F
D4+rVciVWlK.;\o4;%MDpZDe(eg?VPN><2?d#m:bbg&fh4!TPq-*jhl,rXsBcb=\daH=#9E3
X2e$T6429"V?ZC,-LI#qh`"X`/JGG;f5f\3gHE'9q/g[g@6aM%HTcASlMJ/$870eA?9QMFG0
-S`bg%$i]A?S?_17t*rZs[1D!j%Xt"(oPW%@8&1[#$1VXq%DtYU$.%X4g5'YLD@\E^TFEXl#*
W9a,GPh)FSCmKMKic4*I7`un(;;`#9`;nK1'B*<;MEZQL4FaQU!A9@#'mdQao[,[^o(kWOt)
4qg.DL,rVboQQA<B+`s8iW+soIO>%oNZpCmHflqq[=Be&E1Jm'J:r@m>*`X3kPMI<;NWZ+9l
Nr_H%KK:VmoPhUEM*MV#%228PIeWR/B<.+/m)k0i_`LjdYGERKZ\3f`?Mp8]AW=I-NpO1O,o%
2+&;Cb4hs0^j)!M)mS9T'i1VfW^HFln54b,i!n.H+q^)rOBEer=fj5L7MUIPmTu;Pp-sbWNK
n)+i!WHgSDbQd9`<D#%UMEGI;-;<d$`e269[DO%,>=F'!ErHh*Kuc^'XtQ4PX;26#85t9j_-
$^;D-'PDUC'I2TVRfJI>9XP[HEK,chb94E-?5-l'[('D:dJeN5Y@:d84I6H.7djq&<?G&*%L
cdMVbQf?L3$Mt-miq@YC'HOY:f..IHFo$QOB]Ar!D4@,l[Gb#.P=,=(H0_9-\TCW6_/dqM/Rm
r&^fIj\P(YL>=Ak0S6`18QZ6bp"@dC$LGup3E?]A:u:"W=i%k34*trNWpQAa%M"i5_N'Peaf<
6/>;1l?mi@>]A%8m(92&a84sBI>^F4%R0%s.Gme18#0Nak`g)n7k$,r/*@m6H`-"c)a-ultI/
S`0PWa"2K[Y:4$,._lq5c_.Z*HT$=OF&IjRC6\++W,QjRkL1I"=X?j;tpH#WpilGBgQT:mlD
NF.1c&VFu'%`g2';UJ-7Q*\m8kT@PE(<u"=C5)?"QfGjsiW]Aps?#hMG]A^Kt4:5r0PUh1^6$N
57P0Gq9uNl-2G7T8mG`&9mcil^KENlDoI!`JT$^(4`4KNgpL_Wh*=*LQD:K'KK[$E`K17ZtY
U)[c%5/=Yb(=RT&8SRlkIuaS_R(ee"nJDPDs7TgS!edAb)Dn?f>4.UHIt?\R1)iA9,=>mP1q
d4\!u[c"*qGS#HFn^Ed;hXXnc_7Ye;L=GB,b,o1:PSYZDG>Q7MXu5a)nf*\SAuF@/a02U'a\
GfDf\5!H0/L"AG#?\if&71>DY8CTPDT7OQRsCtm;'#K=IJ\$D&o[XU<=F<eSSp4F`Kfs2=d)
2;8qpo*NQa,)FrY.5^F8<X-Dl67u/P[o^uB%2[2&)V[tX]A':0Sa=SF+q.P"-BY01\nf'VgQX
Aph'3g:qZ[hFm"]A\s':)\`=emV%#Mgg9!+8(A(IpcsfgWOL?d9C?\u[L$U4m:N#k&(&bfZ!=
@&q#)?`==&Z8q05E0/$m&'($72F_+[k;Xt%/j?Y1@H5;7_iFA-]A#*K'bIl_a=ZeNLZXFQMJg
:p+d.@[V";em`Y7>K3r/glOldC>DUX,746dO3Qdtj9EC5jlC<r+UGI3jE?l=4lim.,-h0r$`
5]A_*'_*>codmTh7Yakr,GP3@GEp2E%g#u1D+D=,hukb<)MV#ERD\g1*Z!YQe?pI[ePV^djoP
+L\-h8a`CB7$X%&O't;*//'fnQeFdb3=s$"9"+"mQ![]A(Gh`YYB4amASS\7)s,#3ULiUU%H4
\S%pQQZ66[)6U\.Yt,PapWPX;B5%c5^)t.Mo$(0Rc]ALPQlqS_I>H-%5;D6X7T=0<g!LUhpNN
X:",1Bgob,?0WMkT-A;^,$)&jN>jC-F5R+[UX<ipmN%W`<lYNpV/r8g?C#`[Mu2OE`9X;ZoL
(g"+D:S,l=J)(oVE*i*\RlF^:U^@(kTVC4pG@#jgTqg`.qVWVNMDkLgR!G7ePXs*c./l:cNZ
48LR-,onEI%E$NqK8JKtQ.O9_u#Z6CgIc3>?J*2tS`/"QQ);K8'EaC+b4o]AYOH2!DDi;lG3m
-asXC*!fh;,\;s]AcDMj0VjEI/V8Whf)eQafl6H>#-H_p!LpZ<%A?hTS_-aA*#9<5<Op(VcYf
0b0?dn,ZI%6^eiUtJ2D>O]A#@`oGD/lf-`K#;J!(X=%=N3-KsB!TS2h:a9I9bS]A'AfIs,Z2R$
9=?fTjslD*gck-i6f?r<fW]A%DADp7o2Q?eP5)f@#(I3>Xe_9VUQ]A@3a3f;An@$QQLs%d2de-
nFlgP1AumM]AWD\.qP;)c$ag"&%QcW3*juPp2+uQIT]A4-=o2dIDV-7i&Sbo!ohWVA&MktGk;^
in.=`(:GmEO0U06)28BInnG<K3(+LV*=Mk25l%cHBS[hblB_O7%gnFfd*0_a3Z;-3[)K_P<,
N-Es8!M-l^8'C35<6`l'&*I_V(]APD9C4tJ$BqI[a`?lU19di074amn1SdCB%W1.EEuF"t\bG
P#G9^/<#njM7>J:T.jjo/jJ_R5&J!HA/e0+^-[WW3?t2aV!#)WtGkdVi@Kl`N"!J9&FWZjn]A
P<WP5uf$>>t<16!lHn4[8X>4'2fM'oY=Z?C4/5OVlm@h!(TA<")@-Gc4q0ks]At;Va7?$OZ<E
a6#LCAQ52;pEh?no')7H8>-tQ#D\hurBR.n_C5CnrfGm4^o`8c/ITJdYMt8_AuM\d%0$D9i^
dRRITjLVX1ilL<<N4Qd/@#RQ7JJCB!W//%)hObQX7^n7b+sONYp[HS@GO"iuE(^'eB$*ksSu
EC"2?&l@8MMr2P=3BPMZfcskeLaO,nfb&tE]A&K)5h)/YLVibhr.cpc4;J%&&%%rAp"D5"t3D
'Y-X/#&[Wd'.IBTgK-g&P1IH\4e^UZ-jr\q3:-ZXCjtbN[Cj<h%B2V!-cJ8nGYdY[]AF!#e(U
]ATJPmS^>t=2X+!lOd^1?/9#I>[)__M3%:Ja08rOp;ghAsPWLGA8:_0G"2C\b/pV,+^^s05e8
Jg*</(8>c)4"`t2p2pu+/o>[Y>K(EFcBl,oK6^3B*Hb>lA2YAW$C<^X#g8fg2WKZC=+>T@n`
*N2(]Amd4b(17A&ZLVK&T":>8-C&916P>7mD$$#JtRW7%Q$dk,S=:(7jTYkYk9l]AfA>YsAeN2
(<>nJc<f3dR`BU[Gb(7EI+W0@N&aJIdYBCI%A9qOW&Q['%VZdA@=):d+QD16*`2A;I-]AXLi6
8qBL,<X3Nc'Hfo0'g3l#]A"h"0V878'9'!bJ$fYuE2D=r)d9=7N$]A2k_gc?DmJI`kp_HrPLYe
AS'iA-'8>pc3s+G/Gjjg!Z(;9Mg>fC<d)!C2`n#bD@"V<AkIIS)Reus6chZ9m_WYlMh/GskP
_JjH5YqUm4q4-6=Oh^>a]A0"9h%N_TONHl9BSROrV[T%s#>#r#p8*JpscsER+Xc'rZS7Z8Sa<
ptr>nOmfEEW&\:)k*\nDA-A$\c/tQn_/QCYLBMPH[M9?>P#,rI;L#Daa&m/8IX8#''YUM"Z$
+lp'5D0eJIQ.XJaVkm1Pk]A:%,OK\7.Up;6R+,6(<fmCghl)Hd>fSViQe$`$#s2WAUpF,FWDj
2fH>AD(Z[$iW#'p:p96GsHr/9dQ(YM!^<;e-GtO$]AB5A/m?<im5T(&AH-ie+YJ>)6,K?H7mA
O;iI"B59dT>Y!Ol,SW.&0O8cM*P3BbQjEV)'&4aF5[GKlr)0CH,q2,EFJ!"n&888JJQWN9L3
\\qn9s6kEAJf4ZO1^c(X1u's5^6hE`(jDgPcEH)tpqQJTX+Wqo.#+u5,3]AIM,)67AiP#'RP-
$T;R[DYrp`Wu\'dQ03I/B:kpWl.RGGS@FU8JdAHlB$3lU,6\\)"#r</C)[[nL_NJ?Ceaj]AII
H2;>kETL+)lF@.6tpCcU0/E6a#6;"lr7i5k.^K+>30ATmsf69:gb[r5cdjnD3Fs(]A3@r$BI-
Sqm5O+"P)eoQt=+'2[!B^5\#P'=Yb\EZtZXF5du%\IZJgV0IgPrZ;,fCp%U]AZoLr78$RGBbI
uh.1[5XCiX=!At88od"dZ1,23'h]A8+J>=,!#bNb;*4*(P.EDVgt9]AuQ,lWWrb59Znqu%OH%O
8*9HEg?6De13R*2]A<tuU9oi_f>M/WkW+C-:A&14$ful+@%kPW[pZnu5X:M3kBIM8TnmDLlp/
,=b7h4=IjTt!U[^Q+C-LD%WFs9=DPd+p9afMb'F0l4gYHH6emR<4E"$)cL&()Ujjc:E]ARe:6
$G*(/(DOsAeJnlSUn4iM$X^:6oi$iL1EG-S5BE(nK[##4ir?/*l.s+/EA?"TlaS]AIY216<,n
03*fZ]A<l_^4(nZ7h//6LhuEV!58^9AH4u@O?u2tnA3/9*I22\.<pU\IAd(+k<6>4M]AR/E3'N
]A3R?b+$nMe2p&9."F=<b1Dn'7_L[*.lG-WNq&OTE\j&oB3t$WB*`QiZucQ7EID">:9$"@-Ud
%^X$Pg>(D7-WSrrZHNl4ldEkSo/njZ%2qHM$aK2-XLuYLaUQ"?q<L6Om^W$_5Z%9jXP(j':9
g*'3?4aEVTSY&5fa6;>a-6qZM\0D_2,pqQDh^65n/KaCGWZbT<SQ9YCQc(qUpuP.4=PQbp@`
r)&<!AWVJ&Oh>YZ^6j3L!3iq6Be!R.I[h2*9>@J^sNI]AJZ02T$Bf!"bF<M_,(0Ds2r"9CHLj
%Ba>m+S(,EBSOj!^<)2/WZ5Y4,!5"XRD(7Oi1$T3hNZ"Mbc7UVSFFsY;DH%;+?0FQu,6I%o`
I:JLTHE.62NPIc!Om7#sJ$\8Q*M:PNcJ!F:*RL9J$6b\Y%p!Jc-V[]APg5]AT$Ts^A6+7RpJSb
f_KcL'A0r_Z9fce]An!8`UFg+^q>X>(:Grh:A#"4N1^cDImU^&]A)4ZT[%8<:0C$nClfLq+.<V
lfK%k\=l\f/IG@A^R>j.<ouS*,G-MP%4XOlB9qOr89E:&U0PGmYJNF?0s>%^e2M=M-"qqNoI
+M\^p,rBCI@fn(X"gL78:6*:\pd"V?U&lO#ERjg]AeVn4tm"T;o)Ahi>Xfp(^2A4RGZXt-IH6
8s^8OV]Ak7bl*TMi%LE_`QT4<@Mm%b'ghT_M9,V4h"\W"!*5Eh't\-F)jW)4ZQaf8(#""caGo
9<!o[c!i_KX:B(0rV"5N2X8U=CAG.2fuV"AU'JX!r>@<WBb_$Q$Y$6*KXVr7FsWC/llGD<;:
!+:s0O5J[2oAlC*TDDh!1-c6t`K5g>UH]A".+)Wun/Le:G]A-pta97VI''?&hb(m[E%`.bAW5U
=Zi.Y[KCjSH&dL[.o=gS4gED@k]Au/G>^_8&gtq>[=<5-+`A1?fH@E'N\,V`f,rBegYG7)4<l
2FI(OQ:hVKbW^8SlKaQjn:5`,TX8`@j&P+=7lu%D0fTrl"=C2Z1nC@2]Ar7`t0C;NjB[Q&BH(
*t0gO5FF7$^(>j+Td8A<<_j10MNkC<&<r8dKB34(Qg=dp`.k#n'XubkJ/AZL[rOIcjc#!Jtg
f_G5$%Sp/O@GgYXut<C24I!8lk"^$!a1$8DabIu.Q_#o)$D9.<4e(e.]A'8t<5C5G.BBp"(85
SB>eT4/Q.Sf3i3K!_jq]ARM4pU''&lV_L=^>n"[j?XO/7K3b0+)VLo?GHqmI)ZCV/-Vst)<GR
*EXM)JA06##b7q$%,tcja7@,GtZW#>tD%Wo8`[NAsVD1_RsYcMHUB82)/Qg+;M2D*PUj9:]A%
cJf#SNU>>=nk`EloMb*N]A^XjkMKZc,YH&7Ud7O3h7A<qo"hdjgAN?Hc5"Z=K$99>A%=eDBWp
-HcKTpS3I:!Bj)?-PO@p7*Gn^Klm7?YE$OGgr]A9I\Xl90;%njc1]AQ2.)XJHOW,;(i@I7BqJ_
AWWH3*[ZAS\=aMmK7/2#oSMW3M*TiCh\pKZX<Glempi%9VJbHDr]A-]ApBSG.BR%Xncljs)n\Y
An_8iP8P,/:%Hojj?G2\k6:pK8m["No%R(CV(0@IggBW_iDq)g_<:I`Hi//p5?F_FMh96WI'
=?4[/-fkMtJZT0Du;eX$2C_kJG_uh>ZX+"Z2]AJbRcQCD"`Z<T)+N&2DEc-8B6CdaEW7c9gH6
oJ$e@ah[*]A*guN(22qD#=(^-Z9-b02Q$N,Xa/NshkiC("WqK!UJrB$$_itXdB-c[NqRI$@I8
q.PO;h6IJ&g9`<c@7j8N[J^]AY@M*s/tdL\:3VZs$C,^iO&7+3p0qne?lC:;N>%0/nN=Sq)uA
UP;dOs_,19ITg(M?l[MSRkf2<[qYomUX&1^"ORD"Ylkkt23On1st^B*bpZSBQ#LBmaH'G7.D
6!9D]A87<jca8(YJ6B8Em_7dUdLMCE`?7g7DK\^qB`BS&8;;TbAisL)ipeQL&@m[(t^HKMhcY
7c0q@Cujq"k(tD[m=F\&X1h_Dm1crX>%.[jof@!LV9&TUu"t9g<<2)>M=cRYQZGFFPY,$c3(
ep)Fi?H*4$hENG^rc^)0D0??e&7<7]A_6"\X<0[<mEIlrmO\0L16BPPf:T_Wf[[$/:h:S!OXN
k%OF1KY\pb+(8`50G&OkQ>#/cYgYlO0k1h3!<1p^[HSr'KQVbnaPr2%*J`(qa/N8&NiW_J!M
B4pqmg\!VW7Ff91:\%jXpHNXo']AT4jGu0%MT?h06X7C#4iXliq)sB@hB*"pP!/?J\lWk%>c!
D)4QLeW+:9:mpmYEsD`'_3'4"5o);h2/"sl-@5+shfJJF6(*Z;O4]Ad9it&c_h<2c6=1\Z'%m
sHj+MaLseuSuaSPL8ph!=p4?12(,R;s:4B8)/R55[)V^#4b"[d!B[=(r<5_I:G3O*A]AGlOR,
(SWa4gqJPEqon9tNf2o2*PDsT;j]AuT?$`.IS3UVf<#<2$U]AZr@#I,8:!YGG*<s.tNX7Mg_G_
VsE=-8'GumHK]A&oa,2!njYY$:-*=Te`C7\PC"c+93-[ag.m;HUlkU3X!=#`8<$oXcCtiG0Fk
mQ9hm$9Quk)kg!CO[?&(<Y>XhAXN<r`:$%P^^5T._KjpN@J2#e-6h"`OIjNP;nO<oT"ef0n;
F0&(GX#+^E$s"?nRnC>j5<h:.N*CrSXDM^^K;G58CkqkZHYm_Qj,:a43#VRB<H7,O9`P.-j&
:d[jbb$T+kOYq@oTVR&99QY\O/]AD3BA-Kk\pqRakS4UAG0_(Lm>MkC`gULR)LcRId\`YrV6]A
e^#%)eo6`Zmce%L)Lu'5hGV.MJ!#>D'8,^OO;s7?m!Yn*+o$2UCbJ+51CM@0j]Al$@WQhZHu]A
$/BZM]A%!D;`[@"\6HoX>5ptdTg/0X4t`LoKCB>sJ^RmGW3S3P<Em76GR"$5e)bYmC@!Yss1e
R%^`LETf(&_\W%7*#;m!/`AVEL$T,d_cYa*12i8[6tkpOAP/416uJ"3;GZ2:\(FOA_?2IadY
Hc)R+3HnGrhjcKSrpDtmSoLK0Ke4GOK`8dTeK>hB5tVcY(RYPNk?NfA;A:k7DH#)9"5.V=hq
7@6@NR@I/%['P>`egB.lHjIAm1ACs39uuEA)AUJ)atk%@7(1"b)^9]A;OfJfhtS'`$ic\?t>u
WoYR6p.[*-aMt6oI;Q>]A5\qV;"r1D1>Nq*0!7f9U/*b*e<cKYu+_k8f`koYnuRK<J88KF'$4
N0Vor]AUj(?]A7>Pj>7PRORp*foRCR^o`f(327um_?2S[jr,:QIVo!?-S)?X]AcG2;.dSTTp^;G
F\WX#p%AdN`q:?p)2?/:Ie%=,H2MR$"j.L.(T5J1E4#P>2g_h"@tI!pLXY=BD>GN(+=g0^n$
[&Tlb*+j8$B)FU4M6hsKob7=XbRS!q><]ABr_IfA!<<#.9i)GEgEM\.Rn6nDDDTFWW^SDp'\>
R8B1WoRP^Hoe^E0@gj\$;%p0<=GrXDu0ZQ22>n+:3Ins6$_8+Ci<n,[#BIclYR!k>#j<O)`\
IJ\HII"XZOlc]A>k'`%5fos!(nCC%d*,"9kk9N;C.e&%PaKC0'iE\2('gWXAYGEb@$'F5rB:G
Lm18EnmngjPM6+M.7(El+?tDq&eO+!0DG&*4rZqNNo:&r,PpBUh%9Le6r?0>mY;^kClf`T'7
Ko<[gJM+ZXaKL7#qt(ME*04SCMu&\&$Q#JNR?br<rX'N?!m5qP/.:?l3`o5m3%=MCc:qFB![
K*KIZrjoSZ$Y[k2%rXOIP6CO:;,OV/Uu&e7,4\3dm-C$UYMoRFeH"R#6n)t_^$pgJl>JK@@#
3U=U*2`,aq*p4?i`==j8[Rho:eE2;<0bGosS^>pB<+;be)[Lo)nphi'VbGR,^bZ\.3>>\@kc
;hRN.^bjpd0"7CRU53,(IfP+T`.'/>k'\o#7%U6LdWiVrJ/ls@qH).8/T2,FnThuN@BVd+lJ
eZ5!IVs7S(24DYUHDVAHTU>hcA]At9eN\ud!9t+_r>mdjLPKc]A/n6M0Ll9O-=[l6sGYo[]ALN`
/ngeN9E!7Ycn0@5o;L+a^Pr+)$u5M>HT"3m90qm']Aa;>/;_D<X+^NQpaCm'laBZ)uo!lj5"s
n(c[4"7Z-F>d@a.oJRl^f;<,cCUeolGVR'g\CK"UXF<(XGg5Eu!Js%h^Q&B#A)`^"[KR!a[T
\nW1.q/NgRE6c`F$;cU292/AD=Q@EG)aUr$pHI%hO%67H<(-V2%m>1q2_"!,`:ecA+lqh_O$
E%X7\L$%K$$Ib09j/D(DbICsgmX6i>TiN3dZDpE@;1D55k7PC=cfPoeFX3-LXmN^]AlDuRG-M
iAP3F*S0[DbQW[l_ajeq@(.+h),K=-4DnM9N9!__BoJXj*%!NIa?Y?41XeM9jB@MY-LEPi1:
2.TP6UrCqGGW-*XL^Da6H,M@g5bpA`SZa9_`_K?&n]A\,H;)@j"/M:@;!8k2G&`jBetnG3OMH
_mUsPg%'dhKPcY9$"-7.mDchLgBoFcs6!El$`%qqCi^92/n4cjcq\D-Q?^'e[HMKkp;Ojj?I
T>m$]A2rA_InCtT/^F+TtAQ$oX9]A3!'c0a\*5aM??WE&le7J<bDQH"0-POj[l)-EB$9Ip;-\F
g<(4BX(;b5RJ>).9[KVTi-q)0@h6W*k9"u':)7A9/l*;K%^APG/L$t>P.R)uQ_VcHFNTXNTa
dh%I\DHbk;o``I,$Rg9Sh*ugG.[QYK7'JR&tH:pit#h0e+GjcK5DT/kPuh,aqeucjE;'-cQ7
7o]Ak[=h[oX^?_tSjk)sI-:?A4YgE8B<h*'UW7KfpPTi-$>UZP<jPRrWBKnM*:"+2Qc1gHorG
Z=h$ak?"F0b2^2VgHFMs,A_1.<rqTbo:J!kQ-F&J2\eTU\d,/5]A5,c#d7-:Z,e3jAJ'J.8G3
JF6Gi"V8&h%gE"igKrf]AH\:nf\f.N[X=D`:nUYZp3:Mci<V&7,a@)_i>@7o"H[j\GtDEp:fT
2h;iupA7Z]A%#QO7F5lc5A#+\gK\7!#GVcU:_1\Z@NEL$@sNER3tFVtX5_nWoWP^Vo'rmLNn"
JWt%]A?d,H]AqSaYLRh._hMh;:/Dj"h!3rt1i&5BDZ+jC64T6illiCAnme1DZ2i0p?nI?f)Y!V
"&bCLF5JEP6\V1h=RTe2CAndbl7hW+BAfBZbZ6+G\[)O8>H<,iHh^M:4MWiuku7p<Y9HT"LG
.iL[_`[%u9*4BbCG20GHHu!k]AH57tF-DP*7\`_8A1R"`Vn2<@^6>PTm;4qgZZXn,!jk&d3$0
7cg#k7j,MhcW757sa_?f9s0)aKMacNVlP39U$W>C/tu805rXe@d2q/*mV1json299KK@3[9,
/&%:8;4N$=^N;%RClY1U`WG^f\o6e;Xl\OqlY8OH@.3>N:$<Kes10,_!"Z6nOKQ&,63MAOD0
nKi'J)98<@8q6g?F('4-nD^S=Ln:fe8OscrY!B1@X@^P'>#^t^qpO+9`RI>?^^iG[a-KjL-*
Zhc!`.4&d_m!J\__t[(@R$_,buNqY#.Dq#T8GI1lG7\_EYfC;4"%]AgDjYH-klB<-[aejWB_]A
"PSM/Nhc'D&=:DV*%U\5%,Fj`#W-2R46tm-?<,F?iWAF`%3Zd!hsnhYQP*)bH.)9kP3;Y:pa
\ce3TBg+d*[&<4dRM^-KdKAW03HuKh'lGs3@qcI&U>_6fdWRb<k\Mc$R<j>I*rb]A7;Fj'<ZM
jG0gZ![IMsUnARZ64)JlC9>+HJK)J^U+j@)Q3KsCEeaK-\;/kF=]A2rIMSFG\LfAmG:Bu?YGU
)DU6p2_D&(lMY6+"M@e@CPORoiVAhc&@"/DP,]AabkSSC0B%5M;UQ#:!lEL^hq]AeY[V1'!X9.
dQknC1`UE<9W#]AQH>Kt1m5IDpfB6VTIVf>n9>5b]A"eHk"Dljb.@d#%c:`hg>0(`Bn0L,bH9Y
'8I6YU5%.U`!Y)`=4j8UG'A#Lb?a.b#=3C!iPP>36P.tZ$4GWTY7CLd<968>$8]A(,E?u09\P
Js>q:`Zg!B?!jc5T5QWiC3l5N+Z22Z#'<VT#9`koYi=OE%a"AAV*_o=N"Jb*$K`.XgHo&rf_
d.a;\$/#CSC7:aS"3PGHQ:,@_OCEnVn_INSlXooO@o^0+]AF&+[pA-qU87]Af6dd#bptGpnAl]A
6LJ,*i^i&J(cNn?,8nnD5<XrGs5T?kGuj/nhnVp4'<5#F6LN<N$1"'f#_%L`A*##qi<f&nRu
0V8\d,bLZ>C2X]A(^;lh/SQ*Z;$R@M[i!Y:.$OeMPl[R>L@4C5SK^8+DU#Hhs<nK),p!<sO'^
==bMFWF)@p?_32mr._^Te+K?O]A^i]AOg/9&`m]AAN\GD2*$Jp)0kI\i;,m;;B"_!,No!m3&2r9
u:m5C_tn]A<7PlHuRCpPPK5N"0p7J3#16)0u$u,rV.h3kEtperDYD(E(:?UXq\_(*=eVS3XNK
LHcsH:JQDE#'VU*=AErJeU=#&DVn&\]AjGlFXA9+7FGLr"^kQt,cXJkRM-9\.BEgdHnNIG:jc
=3UOL;olKO^\gl"%J$mg>ctB73LX(q&qt7hchsMoB*3i]AhJpYY.2">[_a1is.%lAX#A+*BT/
.:<=`I=mrl7?Im'd0r\tV&l`2WWU@.![O.bXoNDuX_A+C3,7Br7.i-Wb_Ep%-V.<u%B<GtCX
##7%Z_8n[nRYQ9E916X]A[U8PUGb\LUg;VE3$hL:koB'7FQ'>TL0J)3R.7CkbQ1W\'?Kg3?4H
-a4\[bkT]A[GR+EIcDSc!-^h)NV=_L>s&E4AlmroDgN9IrY#.!(gHgm3!d[dU[-<qJ+[>+/i-
eSD3OC+g0!9FnW@JCA)_R*g1Fn$uKP@a]A".,?5"lWb&*b8NoBDR)9WlVFn0BnRYVuF3%=*as
/9S!k4/ER5K_\\nDY<tEr"[fr?O)'30"uoJ#1BH]AF0=3_<KsbqUGsYT:574dss@-_E3Z@#rp
XucT;,:NEk+FCcrNYAuqAiggN,5>.u>lpRq?):O=Xc*"23&CpD@cR$2YNX-ZB$>-S)9c>*\,
c[Bi5Zu\)ee)7ZX06GU[D5-!d!;>]AaOSc5N,sfH9"=oJm]A"7"RV@$6F=kp[Z>YPl]A@9k5Ra=
/@I8$F<bGF''uBjR#6+5SNc#<;tKnA+=thF)E)h^?KG*.9U8La`ZE64;u&pB=8L#A)VY%J@b
!c1Y@'53bC<S3-qGQob\J_0)W3+*-Y*MN)q@'/^<an>R9c7?K[)B[k]A"Ikgt97YR%c2[7:.'
jrjNan1FZFDq[1g_W?"S&8d6D+a/p`,^6/blD0[l^R;;O,)KN"igLOZi)\H,AR&GK5Bt&7Y2
9`-`Qm`&ra4h>1\?V5T^o:552Q.;BFriaa+T$FpgQ7(^GSk\7Z#e+`^aUCfrL0W/kpE1GrMo
TXQ<:4\YEggLE&`.bCL&P2$$;6Hg!-X+1;uM29%,ic,$00KG?=jVd=ZdFIsuV]A$kA<PRs-Wi
X:,=+2oiI>uWfiK#TUg?WK0*4sRK0^`]AdR38DCYL4b+Os$(i58-Vf&L'eID:OXamtBq,a"6.
_r7R#)[km<@V(41fQQQ#3.C>Bk5EbX[_OHnSb=<1m9Qth/j.1%mPthiIpC_tIJF3h0%U_)J@
0YLCa2p,L&F;0Q)[m#""\G("X,r4aiP=2TW-;M?Zb;KS;Db'2qU$FrY0!Z6a6Q$L)b.@,Mil
"V96CJ)O3+#0M(C=kg2??W/,@!KU5"6U-aP".I^O:$N!"`\<^cmk*m$]APU%.40L"8$o(s3hD
[`W5Ij8RBjP%Q/Hi_nf"NN^RgRo#/#L#$eA3)Ve9>?%<\i7eP%Mi0a?0AeFP$,KF7"p9n?GR
,]A^U7.pPPB-8gU92meFTJ='T:FWc"\IkAHqB@_+@cm[IQo5rFNelrrrq-MX(F<RQ^a'&p=dO
QTAC#m9-f2&FN5JA-YEk,15a3<B5Qd6NX`4B-qR:;;ZSOJ\\]Aar]Aa2S]A]AVH[FO&M8@;ab\5e
B'4<)<>7oS4!,q6.jo`LM'Z7&6+S#Dqn-bL$@DCVEQ]AT8H=[b6hL[G1Lu[m-u+\tSF^)?G2>
El$[3'OdnBj?Z@.@NiQk$oH<[@l#g,<VlQ++=S5gF!hNMR]A*C:V3ZW5Sdb%XVllCYe%,R*k4
)JdH(a$6t9`>H%9o$pfU<:RfAGRkQ*q?C,qk&L7?KJdo%CU>]A:jsNRb@b3;WjL?J1pa#),o=
7+uljP6trXd^`MK!lZ/bgX9>P+RhGA(^3nU-4Op53ACLOBEtkmOgJd^'nBl1-@G-2/!YC'n4
flP'_+(0r[k^%_Z9kJ(\R20KDP@Bm+U5,t7IR;or/CE0OS'bltJp;Ko#8sd;D)onD_C2D;?.
\h*@Ab1LFkE@]Ac\,Rt<V5U3oEV_/eS;m"N6A#pE@h35Dg=_sDlf06]AT"JOB^H#Ka6-.ucNB`
KEBp/j=3l^%TGdcA.AX5(ZcZ9$\hsT,G-m)\]A71<b2s8NT!DrRc-q?f:\g]AY:KbQX['4-V-5
<R_:2d2%:)73TjNTt/3"6b4`HSH15'(M0cc\1AJV?P-i^Q98Y7'*6E0C/UN;`5O[\7_fDm!o
TtrErok0YsK#)!=Y6FB7*SHHfm0q,&6Cs`>qPn?#3eRfk6"DH7$XNSA'5.aPQauD=pgQMn(K
a<_(\W^7I'EgXlKuplsMMaG4O*;9c`?UJ__$Y<.S07oSeTa4t.$SlbmrPRS@9=qZu#*-iRHn
Y.Jtb\X#M5Zi:dV822tDQJ_=gU/Ge;A:kl#s5J?i<UEMoN=DuYR?W7_kCK.iMb&0JYlLU"8h
>seP!kLPQP:iPL4;<'8!(j,?LTf;U%m4`N7G:FfN#O`+]A,S;"DZYohW?`+E0<C(EVpD?ApZP
q;[]AJ\8%9$,gF$!-q$g\iUCD;Q]A`$PG`uU]A"6HVIq*\@1L\$ku#'reL1hu+MpkcnZ0<M-'Fo
*(/]A9_m,3+@?^k9J,7IA<@HN8d=K/)j'fC]AJFC8m5<Cmcjt,-`V+p`h3'Odn%,Gda1Vs[KG5
/<AB_XR;RhS/OD[&Bk;V]AmDZOXH^s/iRA[VL@!Zsj4Ef%fI#;Mf7[f,j0RmGp0K[[NFnV)KL
T#d.`NYM/7eW`mCIhMdOQk_jJL3mLh2:('-3^5S:p)JGN4)_rpg[QYG4EI-^2eB%d%*>G0HX
jK9QH0KQ&!XQ4'JKc.ki1<,FHV&c@&ju]Ao=C(GMYoO'+2JSEagJD#sFYup.VQVcpf<M+R7uI
#YacJW?-X!Oc2-U1CL`i=OF5NQE$rlehD-BO*Cusi-Vlc(;s1Tl9@FYKPHFLlY6pdLI@L1hc
fLsa49d,ei-_f>42#;gDBXO:4XtmB"cUhPP0;n+'s2EI2!u[,MGM9W7X_D!7:M0i0Ir#3%Pn
M"M,VD)L.:fh+uO)Oh@Jd>2eQ^4Y@nUg'&qJ;K.kEKNtT-i3/XXH-M._iB"gic>qG_/%B[[8
(&4i1bP3icTbETl:,Vgh^Lh^Y8^;5O82IZ5/V_\$C5q5%8AJb,[mFWKr*HZ&:ia_?lu'c!\C
1qZ5\[`:3tetE&s'Eik4B\9+d$298TkhEJ2WV;YucBRp#9)GbY.N,d3OOFa/(g[AkIG2:#Gr
cc*5(OX0VQ11pHQ2+HC<[h%etZUSTh)n#E^`EYhFW/bFjVTNMc^7cqSM":?>B=##O/AR-.-L
L[F`2_)6[.1i`0*e?p//Fkp<(r$`h@=XKp)UMdQ(d/VZ-Or"fEYalD*gDs^Jn'8\+hSfheVj
"-KeM1I!tuVd<orILMfbPe21WOgp*5i+?VKt@MZhm!l0)HF[*2SF]AdQIj=[1o=1_3_QBX,a#
W$;qbtHVP!Y=6E"sBnWeLS_W!>^Ff0QMSL12%HO6gl'b-Qj4]A.p[h*oaQD9btWT:Yi<,2*/b
`3`6mS`7PHJ3!D!]A#qT/)BTXDFRPPot6qXh7M3RE/UDF!m8;kefmpR9e@kd&)pB@X*c&XG7E
aZRsK*TeBIF1?KQ>j^Su>.c9FFg[",Vf0s>#c7nC?bpqia2qk_GWeRFF'fQUHJoW!iD%.\l-
Tf9d0ZcoQ!aX[>%tZY55r2JXYW-r8T,V34PZ]AG2]A5\fk)^m@l]A\+pDW.(^pa<n9hl.[Fg(AO
q$F"*_gG@)k0pp<[gQE7tmT`lkOnX$A@CH?,,&>3gT.E>45;J@FjVrSaG7TKA4JRdednertc
3NoX@9EZ1#-Y>kPO=Ja$GD,LC)Z5k"=s(&*P%ap*a0o_RCI?+8h1X14[7dtflZ'5Ytt(N4[K
Zm)LM2O#:NAa`3liI.&V>(%/&DFj@A(n\+%GMEK**j4T;3`'&*"G<U%)p@KcUgY@=/4K+0i-
-m.po8P[sO\kY?QL%h[LABftO]A<\@t<N]AbSh?FP=OZL]A\Sd9iB(WUr>$b#LO&DfF"4rfJJAY
UF--2Xd[hBU827l/<GjooV;7!crBibs@(Y-Y#=mr'M[ST*QQJSU?+ed3+-'efd(8@3=BenaB
qD6q=:J+rb>]A@+6_4FDE39/M^\@?.j6T?do?=jM;:j'?1"U%<d8D^+M5_4-N)7q8?6J,!TO$
u7=WI&MDBOg,msfMo$]A'Cs42B_4...ILM6<7.]AAii/2pEFicK(,f(/@5V!(;0-RsZLR;;3W)
.O3jU*oTc3n.`MfN7*fE\[\k@Vp^A?&OjYDW1GqaDIiFb_e9+@'+Y*g^[#;Vli5'n8GJmH74
Sq:i",ko^%.21;UV#sF)cS<Z#"&1^bc&K@+D/(+q-<bt;/A4,8&<;1[P]A)\u-3"[5kN9I@!S
ZT=>jk<-a^]AH5dSW4"!@ciVhD32X=FU&1D<bEg3ClG;C!""Q]A&)V/cQr!ar.Q%2.@"ip[gUs
@+WheWHThL^5D(X5Mqq7g8V>ZA;^)+NDN8[?Q,fQFlS0Gt.&I(>$E1ct]AGDHkq-')]A)q(!Z#
e6//`-1AohH_lEB(pkJ(r2nCk&5up4Y7^Y$C9Ln=1klXdrFZ0h27]A56)N%`ckkW,T#j>n"Us
ZP_UmfV<*tP3K:A'W5JE,.39ES)Y1K!CSFH'PZs7>B^#^Ko)D7P;n80<AkcL1Qea0>.3gP7#
GrOfM^\P\+n<:IXoU-,^5RJojV!+h.R=Ih\I9YImRfd)dBrpW%jIh]A-!0hDZCk;-p%Z<SoO_
DQD*4)GId%H;iS]A?,;e(21oD9NM0.uq*aRM%E?Mfi*h?C[-K@6Q&FSK_6j)VYTDN4^Gi7`pe
<L!Kq:]A1P+tn[RFmd;LQA2iZS8Rt]Aal=bcVhB;2t8NQ6\@Xa">cLD0&N^VT<_p]Ad1"Id;A:o
g6GZ%N97r/HF(D>F<Z$.+(CO\1OOGW^crf)aYVRH%Q:b#q8%M7$0#F(:<&.+JX'2Mg'nHf5r
`JrOVlkEV_/ah)mI5#F"plAaLJt/X;GdKpl=cC5(<BP3j2uFMkG\3Y7u\@d1@_c&"#`-$lMN
IK59i-Q#6f#,(pTa_tq/)[T>XLZF]A.]Ae;nqGior#G0.'FJ3["5fY)kcBWDW%9<.lf*$.k<"4
'lY%c#l^`#bt?BijGGZVhbeMKW_*f;`PN<,ra!JCU36UTah0"^-$g!b#*5[F1lA8HV\bfs`Y
68+H(Jl-TZ7EZZsF_3LklG5Y[gFK/pl4sTR`ki@isk&b>\FqV9XL'S:1nXILiVQKTIMd8p64
skeeaj0Bmn0g;ajJ1*_rG3V7Z3$bKi41`^rTMJ&HubZ\c=A$7?^L;"6=k>*Q'U6o^JndFK*S
/E<`g5_4R305e>gp_faO%!G2soA]AplE:$pA3TVtgLiFiupc6L*,DAZeJ5I9EE!,eiJim'C/3
_NhIki(//J<U[,"Qe:SsmAr'6r!F/L'H07f7)lb2o:oGM'*DI9)5_P9Li?I8G_?AZ>6'rkTk
KQrA?@\N8QO9-o(#@V2-OKnkJsos]A&SoKR4Kb0ngc[IFs`H9rGK>ep1WPkRJ=U[c*F+U3K]A-
K$A^A7f[BP"HF&f)"T;sOYs.@rnOSq]AN/k3qc&n_X")QV\V&s[mq0>a#NZ+klcS(P^$HQ#c1
fT'=9_$r59S,L('bfk"$m)";6_=;L)2ZMP0X$Ond&#?,2L:e$O1O<mj`sUYR\U19fBle'8eS
<ak0n#XpX5abfuF3F>1ahJmi)H<>/q:t1cP;``.dO[Qc@mZ'F6%=9ThJgrMajMqb.]Ab0$Y8%
9C]AZ:!8Sb\?BKhnP/lKQ@L2]AoY-ocs`)p/<mX%i$)4-&7?5[GK1gfBblC`4<,6H#dCUc1EIt
_ZSpR!`idVk$=S4<Taqls47Ocpon3pOBW?fFpI\02F[^)8e:@I`UPD$psD)d2-$Eo,n1FJ?<
e#<kn=>:p@<FYmdlRfXX;rtGg>mA^_bWQ48_no1;l(DZf;NT8L6\8eBCMlG,pFMq+<?'`m3<
a3(!I)oZk(W0@4R.?5\b7uc5FG-[ki(LXm`5a=3brZ@1oA0gK&h0p;KNb,c1[6jGlg[?U9WN
;89H"oq.;KqqB+-YZf8LqgGK*^k>ag\,pS]AV70mgIk]AehdTBl,AeUG4D0nI..iNQUh"9\)?!
I47c/P=<96Ac/<2'YtVT3&3l8"'Q-S%DiJ#)P4TE3VpaK.o9NXf[a5Ab,aAZGS2+sMNSpe'Q
P<,&Y>M=A?ea6;k_NKQrU!_hM7OLR,]ABkmL[4M"W^mU;%/ttTi_!3f>2M$+"b`1CjRti1tge
Rn-XNpDqML[P,d*02%X3(SEMKYS=:8"1C)\HM"A$.4Fc3`/fc(P^UV83h&]AO]A[jNnI"C<E01
9?:jOa?IN0qQ0HJmDgcU"(_^SYV[hg>`2gW%0HgcC#JdTZkoe?ce.Y9i)&u(d\Iq$RmgQ&,h
(oG%XVK\*5$!f%/h<'WO^f$(Vo"/\Fa[)S3H;%G-r-.LM-(ZQm/P.j3m$g!1cr=Eb3/[IKOh
ObkAXQ/D>5,9hlKOL^drE9X\86]Amsn_VK\9a.EniHDE!$r`&2f"nF]A"Xec_`Cl6u(.==EeY\
"W[W8m;KrCt5k;8sUT0f/SW1n)is-)jrN&@_g!)"a5kountCA7MOr9K:^k2pWui)fR<2BY^n
k(6%IW+Hp1?:"kI`_MaM57NLWCEE<R+C1;N[W`C/oCT'[d#dnMSVWlr<b4H'i+6Z,F']A*-\J
#045es.+4B&RI&&6a8>#?20oXKrHlO?"8o/oEV*?,m28%^(cgf@Jp8^f63p7DU;`,Am;4VE:
\CDhZI'rGX2B%&!hn-k*TI2X^(qO.?Mjab*0r+l"^B*2)^,[m>e[UI0[]AiL<8EO3h<hB^/E*
mn-IIoI^@rj+5Bq3);*dM03!N\$RFlWA!#?32WWdT_bB(AU;K<<pFU<S=k?\j"h]Amm-sO8jn
Nm8U7Ys1jZ'uo3S*\_S+(gE1f,f7EB1<_]A5E"&e17!kEUV(gX_M$gG^Me.BVtT6h/'%mae,g
enkX>qn,[q[Oc03"6eVo4h<(DN^Y#4S=E1GZTIpo'fC?:1"055:V6R9:LB`TpEms+"BFgrEG
E7(JEI6k,6H<V^T:8H&`($2N=X(->JVH,B\i,t'lj`01@(uIL'^bK1Z9*.tWJp7eGGRMm1Rn
+;QJk4pG!5<h6IQi)M9-`CT:aFFJZW]A/(Wuo<Ta&3fNC9t?8KaK=`G:dpOM^$%hh@g?DptrX
paVG@JskXtP\@cG14u+NI>#[3''FsK+U,8?7n5<t,O&^(@tdG=E0=]ALPZj?)E$Z_9a<r1aR@
0N$am,elj@,?`dbb4'G+[bl>]A2h@C8)@sQI9WG<^qKV9H_krXUNdZ*Q[IA*i%sLTQX;B5ed[
*[_Jnd^!LfRcUGZ&8\s`YSXCc#C8!Ma!bEFtC-J_cH?[cZ\M!'J2VE5?Fa1Il`jBSmG1q^/E
*]ANGG!ptT:gWS+$)..EYT.\#mfD6+2PjN`["=s<hLTDhl.\N9'[S:Xp-;Nm_ToR,'%b*/"G\
3WZtE_.PS]AHFa=m&K"9m[+QZ%hOr5BF*/YA2ecs_SeRs.'hDsX=EW/N:`aicfYF(3._5jYZR
k=G03@RhG0CA;Ibi1(8A3Pge#eps*(>:h]AM^:2`M2q0RaRG+R_K6WP^?(0F?3J\<r`4-ZC3(
gn*p<DsBJ<rq-S/k50e*fN1b3<kaB,3M[QI+n:;8:4V/ka@TXMh<>c;'.ZlVbhbprZ`Y,,L,
APQU@b41h#EVKDmYP5:2'hPR]AJh@F,,3=llo=m[8f&'N_??kt:E@H6+,ReS(1oI&3t9cMYtn
ag#o3P(Y]AJ?!@bOR$_mqd+82NA\0%_<F7$]ADpSR]A-^'#2JaKiM9-SH+<3q@Gh]AK&2W0n^*,[
YWl_7B8*KBe[,Y^,Ad2o+kOD+0ag1WR3YW)D)QhPj%j?7>BS(m;D%H6]A1`ECH*<h`Nh[mlX2
/>p)trO%m_0/*5C`?U8Rl_6hN*6u8LK0[+Q)c&FR.[\!/0^nKpgW6FC@)@@p>2b09e&h0lAa
R`._is-Afm'oh!5qUpiRoJ.!m:LH9WFjIN)]A%1M+a\='Kh0>:o1HQNL`Nmm^!d!dJh-='=GH
KLUb7D<NT/rNpc'gicTi_MWAD\T'XU0Cma'BHt7]ADMQ*p=4`'6?6jd+#aqS'W.`Hf*DN0Z=2
h8,N;-K54_>8RMZX)ig'p\!M461+72-hH&1LlYEXGt$1Y:C^g2`N2>pgP<=3!pk6kU+Ge)l_
Y0WEY'akl9(!QKX_*Ao7&q6?9]AQ8dI?8J5JZH1R*64c&IcV04Cq[]Aj0/H3W]Akq3Gi)@<#!%W
bR(16Vd>HU&CcCWoOQe@J$]AVA]A,miDTrA^*jIh/_UTQKA._P-8#+#Y?mSj^u$\U3*ReCM`S%
ZVP52]AtIGmnM!(![Fg<MVbIqDYLj47AKJ0'.VQ#,<l,@H$GBI+h[>4WU%P:ar,r-S3I8IX\5
@p=u6[-#c=h3g=p*8WC_fl,t9I+8#EH#bNRhPAM8-T9V""(.j5sp+J'd1BU/MoY;O&fg,C;[
2sBcfX-N>Wqdg;INj2!nSD,K4Y^C&phDp>+r_^<&e^%b>MFA&&i6jN+r?[spMk_I'#`ZTJOt
QuQa9L9r,%foUj%srHe_4M$EKL$iTnEcs'VHTikO:;[Ntk/Hd/U.YLUg*+i![di4R.UQ&iJi
&_G;Zs$qokkQD4<G=k&XZ9em8#Cg(q1$kY/gf_c-pT^oG^;ERj['.`Sr.82+6u,-@(-:bd*S
rAl%6g$5FSXeH[]A.eBrJ41t#bEC]ALheTj$9O9PP`)MD/0Wc`EK[#,f"+l67P!kcrhf'0Ai48
Oq'.[a)CrrIU9M;mgJ+ro4&`ZQR<.S)P_hZ<&T]AZ,?US&2kr$s0"%<Bb6<fI*NL4glW#BjMj
:CoI;5VR-0FQU,#AjQUG1tU\MU/0N;7fJUlt4Sr`d1?1:>aF,@eu_<)Yj6$J^tr#9ML#MVI*
WEMH1J8S.-l^#MjJc[P?n;`N-a,XCE`QOKr\d":>)N42L8%=$:LRk*C!e7TfIAG+c=E'!GgA
meS_U>%AP\7h`/aaYV.R-%C6dig-'W?0b`1?9T_X?`3PD?dU-hC!?]A2N]AKU\(MAtSdVmH54d
8QT`6NI/RiK4]AX@S3E%'NWAEY)2i$a"#GeAi]A9?$Aj""aZf<_82g7F;HNMam#;HA?GVtc1HL
(&D`@)3j_b3SM=[8Ru-]A<ctN4(3gYOlj:^m-OELc>@kJ(B%%(`E4EYJb*WPXM%hneQ9h(Jl0
IN8h@jBToV-Cn`K)Qe7af;hH=1:lPM62i\-O\<N+N7'K\mEB%.BEKA&_/glSo[HgAHB;d7Vq
e5\[tF&Y(X,#bi8?h4$:e,o]A^1CmM0G7?`]Ak3]Ak2ms*neV>0QkjQ$5u#Og(ls!Mo]AY*$)&Wa
1':FqAZUc#/C781r6rj[^c=UC$9ScB5pk7peS1"X:8UutB%E3F*/*;@[t5PX,D-`$M(FR8B%
Ue<CDMZD8qE_@/63QeJHU-Q>[X)SE9Ur]AM%_cM(QAm=Kkqs0>T@RlUuEd<fU9u0S#ge%)n16
$M4cmoXD@'gW.Q)?JuEKFPSGdc&0iB:i<_PRjhjsaJgR#A1`K)Z/J#U[+u^2mHDq_)Q/bFOO
WpkU`2Ie,9#O8>/FusgbZ]A+3^EN.G2q>H7#ffl'ION4oJ-f*=osd*[4rueMLK@=[UqT8T)Db
;Kj#IAQ\6aAM:jS6f*Gg4?M,[[qR#)@kn-.,U0%u^S"h;LRV5jL(c&.FQd@H(.2eV;`BN#7E
K7TL^\-oScUt\9$>hmc%iTONW]A!^c9"J%U:7sDQZ%\p0iIZ0jb31T=M4Kp(,@D)B\8%[WHc&
P([c?7hHOs_;IS4IGf=nlj*Gc(LnfWW"IB124:gQILF@lLFNK@#':6,<\$6h4DXOsjJ3^DBk
B'045!5TH?@aG+io5]Atd\]AL$YQJk=$q;Ia9-iMo)Mf_;V$b(AlN$uD.$f$GX9&':fTWai#66
lmuuWdVF>-TADXqsdb><qAGe0Q1QEMo"o1pa9)lJk*Le*H+tkcV*@O^>$]AQMi-I9/@SB%4NC
Q6(;HCjdT0Q,prIGJBK$1Bf$T2L&.7:Vj]AM)]ARKERH]A`3,f.DIbsL;$9rKNn>036X>EGNg?u
*e=ii7sPsAU4?Tc&&F%fU-(hg;/2.XR#WQ\J%"Jk\Q.dK7X6t6S^c:f=:f5H8fa^jRS[EW+,
Q_K.Q<>jhX%U6#Sh]Aqq!VmX:IN;%;`C9q=>.PirO_B-Epf%dG8'\9.u:63Ds9bTJ=f[PgMa?
lk1<HM01YmAhPJ61#:sl2RjT]AIWoWpC!5:)OS*6,E]A`-jh!!~
]]></IM>
</Background>
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
<![CDATA[432000,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,288000,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[720000,2743200,2743200,2743200,288000,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1" cs="3" rs="10">
<O t="CC">
<LayoutAttr selectedIndex="0"/>
<ChangeAttr enable="false" changeType="button" timeInterval="5" buttonColor="-8421505" carouselColor="-8421505" showArrow="true">
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
<Plot class="com.fr.plugin.chart.gauge.VanChartGaugePlot">
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
<Attr enable="false" duration="4" followMouse="false" showMutiSeries="true" isCustom="false"/>
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
<Attr showLine="false" autoAdjust="false" position="5" isCustom="true"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="1" size="112" foreground="-16713985"/>
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
<Attr enable="true"/>
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
<gaugeValueLabel class="com.fr.plugin.chart.base.AttrLabelDetail">
<Attr showLine="false" autoAdjust="false" position="5" isCustom="true"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="Verdana" style="0" size="80" foreground="-10066330"/>
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
</gaugeValueLabel>
</AttrLabel>
</Attr>
</AttrList>
</ConditionAttr>
</DefaultAttr>
</ConditionCollection>
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
<OColor colvalue="-16713985"/>
<OColor colvalue="-16713985"/>
<OColor colvalue="-16713985"/>
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
<VanChartGaugePlotAttr gaugeStyle="slot"/>
<GaugeDetailStyle>
<GaugeDetailStyleAttr horizontalLayout="true" needleColor="-1" slotBackgroundColor="-1118482" antiClockWise="true"/>
<MapHotAreaColor>
<MC_Attr minValue="0.0" maxValue="100.0" useType="0" areaNumber="5" mainColor="-14374913"/>
<ColorList>
<AreaColor>
<AC_Attr minValue="=80" maxValue="=100" color="-14374913"/>
</AreaColor>
<AreaColor>
<AC_Attr minValue="=60" maxValue="=80" color="-11486721"/>
</AreaColor>
<AreaColor>
<AC_Attr minValue="=40" maxValue="=60" color="-8598785"/>
</AreaColor>
<AreaColor>
<AC_Attr minValue="=20" maxValue="=40" color="-5776129"/>
</AreaColor>
<AreaColor>
<AC_Attr minValue="=0" maxValue="=20" color="-2888193"/>
</AreaColor>
</ColorList>
</MapHotAreaColor>
</GaugeDetailStyle>
<gaugeAxis>
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
<AxisRange maxValue="=1 "/>
<AxisUnit201106 isCustomMainUnit="false" isCustomSecUnit="false" mainUnit="=0" secUnit="=0"/>
<ZoomAxisAttr isZoom="false"/>
<axisReversed axisReversed="false"/>
<VanChartAxisAttr mainTickLine="2" secTickLine="0" axisName="X轴" titleUseHtml="false" autoLabelGap="true" limitSize="false" maxHeight="15.0" commonValueFormat="true" isRotation="false"/>
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
<VanChartGaugeAxisAttr mainTickColor="-4539718" secTickColor="-1907998"/>
</gaugeAxis>
<VanChartRadius radiusType="fixed" radius="50"/>
</Plot>
<ChartDefinition>
<MeterTableDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[仪表]]></Name>
</TableData>
<MeterTable201109 meterType="1" name="名称" value="完成率"/>
</MeterTableDefinition>
</ChartDefinition>
</Chart>
<tools hidden="true" sort="false" export="false" fullScreen="false"/>
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
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="3" cs="2" rs="2">
<O t="RichText">
<RichText>
<RichChar styleIndex="0">
<text>
<![CDATA[目标：]]></text>
</RichChar>
<RichChar styleIndex="1">
<text>
<![CDATA[500亩]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="5" r="6" cs="2" rs="2">
<O t="RichText">
<RichText>
<RichChar styleIndex="0">
<text>
<![CDATA[实际值：]]></text>
</RichChar>
<RichChar styleIndex="2">
<text>
<![CDATA[120亩]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="1" r="12" cs="6" s="3">
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
<FRFont name="微软雅黑" style="0" size="128" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="168" foreground="-16713985"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="168" foreground="-74446"/>
<Background name="NullBackground"/>
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
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</body>
</InnerWidget>
<BoundsAttr x="8" y="29" width="557" height="220"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="report1_c_c_c_c"/>
<Widget widgetName="report1"/>
<Widget widgetName="dim_cal99"/>
<Widget widgetName="JG99"/>
<Widget widgetName="px99"/>
<Widget widgetName="report5"/>
<Widget widgetName="report3"/>
<Widget widgetName="report6"/>
<Widget widgetName="tiaozhuan1_c_c_c_c_c_c"/>
<Widget widgetName="tiaozhuan1_c_c_c_c_c_c_c"/>
<Widget widgetName="report0"/>
<Widget widgetName="report2"/>
<Widget widgetName="report4_c"/>
<Widget widgetName="report7"/>
<Widget widgetName="report9"/>
<Widget widgetName="report8"/>
<Widget widgetName="tiaozhuan1_c_c_c_c_c_c_c_c"/>
<Widget widgetName="tiaozhuan4"/>
</MobileWidgetList>
<WidgetScalingAttr compState="0"/>
<DesignResolution absoluteResolutionScaleW="1366" absoluteResolutionScaleH="768"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="960" height="540"/>
</Widget>
<Sorted sorted="true"/>
<MobileWidgetList>
<Widget widgetName="absolute0"/>
</MobileWidgetList>
<WidgetZoomAttr compState="0"/>
<AppRelayout appRelayout="true"/>
<Size width="960" height="540"/>
<ResolutionScalingAttr percent="0.9"/>
<BodyLayoutType type="0"/>
</Center>
</Layout>
<DesignerVersion DesignerVersion="JAA"/>
<PreviewType PreviewType="0"/>
<TemplateID TemplateID="12bc5645-a4dc-428f-9af8-1d254ce2b879"/>
<TemplateIdAttMark class="com.fr.base.iofileattr.TemplateIdAttrMark">
<TemplateIdAttMark TemplateId="dbac4997-fc07-49f2-bf32-1796620eb4be"/>
</TemplateIdAttMark>
</Form>
