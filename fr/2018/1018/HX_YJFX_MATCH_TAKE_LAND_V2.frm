<?xml version="1.0" encoding="UTF-8"?>
<Form xmlVersion="20170720" releaseVersion="9.0.0">
<TableDataMap>
<TableData name="Tree1" class="com.fr.data.impl.RecursionTableData">
<markFields>
<![CDATA[0]]></markFields>
<parentmarkFields>
<![CDATA[1]]></parentmarkFields>
<markFieldsName>
<![CDATA[ORG_ID]]></markFieldsName>
<parentmarkFieldsName>
<![CDATA[FATHER_ID]]></parentmarkFieldsName>
<originalTableDataName>
<![CDATA[org]]></originalTableDataName>
</TableData>
<TableData name="org" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="fr_authority"/>
<O>
<![CDATA[测试角色,验证角色1,系统管理员,数据录入角色,权限认证角色]]></O>
</Parameter>
<Parameter>
<Attributes name="fr_username"/>
<O>
<![CDATA[hongxiaoyu]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[oracle_test]]></DatabaseName>
</Connection>
<Query>
<![CDATA[
with role as
 (select regexp_substr(role, '[^,]A+', 1, level, 'i') as role
    from (select '${fr_authority}' role from dual)
  connect by level <=
             length(role) - length(regexp_replace(role, ',', '')) + 1),
             
du as
 ( --查询用户组织权限
  select orgid
    from dm_hx_data_aut du
   where 1 = 1
     and du.userid = '${fr_username}'
     and du.orgid is not null
  
  union all
  
  --如果用户组织权限为空，则组织权限为对应的角色的权限
  select orgid
    from dm_hx_data_aut du
   where 1 = 1
     and du.rolename in (select * from role)
     and 1 = nvl((select case
                       when orgid is null then
                        1
                       else
                        0
                     end flag
                from dm_hx_data_aut
               where userid = '${fr_username}'
                 ), 1) ),
du2 as (
select regexp_substr(orgid, '[^,]A+', 1, level, 'i') as orgid
    from (select orgid  from du)
  connect by level <=
             length(orgid) - length(regexp_replace(orgid, ',', '')) + 1


),

ORG_JG AS(
select ORG_ID,
       PARENTID as FATHER_ID,
       ORG_NAME,
       ORG_SHORTNAME as ORG_SNAME,
       ORG_NUM as ORDER_KEY,
       org_level,
       ORG_CODE
  from dim_org_jxjl where isshow=1 
   start with ORG_ID in(select orgid from du2)
connect by prior org_id =PARENTID
--where   ORG_ID in (select orgid from du2)
 --or FATHER_ID in (select orgid from du2)
 )

SELECT 
    ORG_ID,
    null  FATHER_ID,
    ORG_NAME,
    ORG_SNAME,
    ORDER_KEY,
    org_level,
    ORG_CODE
FROM ORG_JG where ORG_ID in(select ORG_ID from dim_org_jxjl where org_level=(select min(org_level) from  ORG_JG ))
UNION ALL
SELECT * FROM ORG_JG where ORG_ID not in(select ORG_ID from dim_org_jxjl where org_level=(select min(org_level) from  ORG_JG ))
order by order_key]]></Query>
</TableData>
<TableData name="1left" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="org"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="periodtype"/>
<O>
<![CDATA[]]></O>
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
   and c.index_id = 'd1026c1ffd0841b2bfe631cb7643745e'
   and b.org_id = '${org}'
   
   and a.period_type_id = case '${periodtype}'
         when '当年' then
          substr(date1.date1, 1, 4)
         when '当季' then
          substr(date1.date1, 1, 4) || 'Q0' || to_char(to_date(date1.date1, 'YYYYMMDD'), 'Q')
         when '当月' then
          substr(date1.date1, 1, 4) || 'M' || to_char(to_date(date1.date1, 'YYYYMMDD'), 'MM')
       end
]]></Query>
</TableData>
<TableData name="JDYG" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="org"/>
<O>
<![CDATA[]]></O>
</Parameter>
</Parameters>
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
 ind.index_id = 'd1026c1ffd0841b2bfe631cb7643745e' 
 and org.org_id = '${org}' and
 a.period_type_id = substr(date1.date1, 1, 4) || 'Q0' ||
 to_char(to_date(date1.date1, 'YYYYMMDD'), 'Q')
]]></Query>
</TableData>
<TableData name="ZBPF_KJ" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="org"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="periodtype"/>
<O>
<![CDATA[当年]]></O>
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
		CASE WHEN '当年'='${periodtype}' THEN PERIOD_YEAR
				 WHEN '当季'='${periodtype}' THEN PERIOD_QUARTER
				 WHEN '当月'='${periodtype}' THEN PERIOD_MONTH END AS CALIBER ,--找到我当前时间参数口径（当年、当季、当月）
		'1' as ORDER_CALIBER
		FROM DIM_PERIOD , date1 --时间维度
WHERE PERIOD_KEY=date1.date1
),--当前时间口径 年、季度、月份

DIM_DATEMX AS ( 
SELECT
		DISTINCT 
		CASE WHEN '当年'='${periodtype}' THEN PERIOD_YEAR
				 WHEN '当季'='${periodtype}' THEN PERIOD_QUARTER
				 WHEN '当月'='${periodtype}' THEN PERIOD_MONTH END AS periodtypeIBER,--口径
		CASE WHEN '当年'='${periodtype}' THEN PERIOD_QUARTER
				 WHEN '当季'='${periodtype}' THEN PERIOD_MONTH
				 WHEN '当月'='${periodtype}' THEN WEEK_NBR_IN_MONTH END AS periodtypeIBER_S --口径2
FROM DIM_PERIOD --时间维度
),--时间口径维度

DIM_DATES AS(
/*SELECT 
		CALIBER ,
		CASE WHEN '当年'='${periodtype}' THEN substr(CALIBER,1,4) 
				 WHEN '当季'='${periodtype}' THEN substr(date1.date1,1,4) ||'Q0'||substr(CALIBER,1,1) 
				 WHEN '当月'='${periodtype}' THEN substr(date1.date1,1,4) ||'M'||substr(CALIBER,1,2) 
		END as Statistical_time ,ORDER_CALIBER
FROM DIM_DATEKJ, date1
UNION ALL
*/
SELECT 
		b.periodtypeIBER_S as CALIBER,
		CASE WHEN '当年'='${periodtype}' THEN substr(date1,1,4) ||'Q0'||substr(b.periodtypeIBER_S,1,1) 
				 WHEN '当季'='${periodtype}' THEN substr(date1,1,4) ||'M'||substr(b.periodtypeIBER_S,1,2) 
				 WHEN '当月'='${periodtype}' THEN substr(date1,1,4) ||'M'||substr(date1,5,2)||'W'||substr(b.periodtypeIBER_S,2,1) 
		END as Statistical_time , 
		CASE WHEN '当年'='${periodtype}' THEN substr(date1,1,4) ||'Q0'||substr(b.periodtypeIBER_S,1,1) 
				 WHEN '当季'='${periodtype}' THEN substr(date1,1,4) ||'M'||substr(b.periodtypeIBER_S,1,2) 
				 WHEN '当月'='${periodtype}' THEN substr(date1,1,4) ||'M'||substr(date1,5,2)||'W'||substr(b.periodtypeIBER_S,2,1) 
		END as ORDER_CALIBER
FROM DIM_DATEKJ a
LEFT JOIN DIM_DATEMX b
ON a.CALIBER=b.periodtypeIBER
left join date1
on 1=1
), --整理时间维度

DATE_INDEX AS (
SELECT INDEX_ID,INDEX_NAME,ORDER_KEY FROM DIM_INDEX 
WHERE INDEX_id='d1026c1ffd0841b2bfe631cb7643745e'
),--指标维度

DIM_ORF_HX AS(
SELECT ORG_ID,ORG_NAME FROM DIM_ORG 
where org_id = '${org}'
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
<TableData name="report" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="org"/>
<O>
<![CDATA[548d9f72-81f1-41af-a303-dc5d940850cc]]></O>
</Parameter>
<Parameter>
<Attributes name="periodtype"/>
<O>
<![CDATA[当年]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[oracle_test]]></DatabaseName>
</Connection>
<Query>
<![CDATA[WITH usedate as
 (select to_date(data_date, 'yyyyMMdd') usedate
    from dm_mcl_acct
   where rownum = 1),

-- 处理时间维度

datetable as
 (
  --年度无论何时都需要显示
  select to_char(usedate, 'yyyy') code,
          to_char(usedate, 'yyyy') || '年' description,
          to_char(usedate, 'yyyy') ordercode
    from usedate
  union all
  --季度年度情况
  select distinct to_char(p.period_date, 'yyyy') || 'Q0' ||
                   to_char(p.period_date, 'Q') CODE,
                   to_char(p.period_date, 'Q') || '季度' description,
                   to_char(p.period_date, 'yyyy') || 'Q0' ||
                   to_char(p.period_date, 'Q') ordercode
    from usedate u, dim_period p
   where to_char(p.period_date, 'yyyy') = to_char(u.usedate, 'yyyy')
     and '${periodtype}' = '当年'
  union all
  --季度季度及月度的情况
  select distinct to_char(p.period_date, 'yyyy') || 'Q0' ||
                   to_char(p.period_date, 'Q') CODE,
                   to_char(p.period_date, 'Q') || '季度' description,
                   to_char(p.period_date, 'yyyy') || 'Q0' ||
                   to_char(p.period_date, 'Q') ordercode
    from usedate u, dim_period p
   where to_char(p.period_date, 'yyyyQ') = to_char(u.usedate, 'yyyyQ')
     and ('${periodtype}' = '当季' or '${periodtype}' = '当月')
  union all
  --月度季度情况
  select distinct to_char(p.period_date, 'yyyy') || 'M' ||
                   to_char(p.period_date, 'MM') CODE,
                   TO_CHAR(TO_NUMBER(to_char(p.period_date, 'MM'))) || '月' description,
                   to_char(p.period_date, 'yyyy') || 'Q0' ||
                   to_char(p.period_date, 'Q') || 'M' ||
                   to_char(p.period_date, 'MM') ordercode
    from usedate u, dim_period p
   where to_char(p.period_date, 'yyyyQ') = to_char(u.usedate, 'yyyyQ')
     and '${periodtype}' = '当季'
  union all
  --月度月度情况
  select distinct to_char(p.period_date, 'yyyy') || 'M' ||
                   to_char(p.period_date, 'MM') CODE,
                   TO_NUMBER(to_char(p.period_date, 'MM')) || '月' description,
                   to_char(p.period_date, 'yyyy') || 'Q0' ||
                   to_char(p.period_date, 'Q') || 'M' ||
                   to_char(p.period_date, 'MM') ordercode
    from usedate u, dim_period p
   where to_char(p.period_date, 'yyyyMM') = to_char(u.usedate, 'yyyyMM')
     and '${periodtype}' = '当月'
  UNION ALL
  --当月的周
  select distinct to_char(p.period_date, 'yyyy') || 'M' ||
                   to_char(p.period_date, 'MM') || 'W' ||
                   SUBSTR(P.WEEK_IN_MONTH, 2, 1) CODE,
                   P.WEEK_IN_MONTH description,
                   to_char(p.period_date, 'yyyy') || 'Q0' ||
                   to_char(p.period_date, 'Q') || 'M' ||
                   to_char(p.period_date, 'MM') || 'W' ||
                   SUBSTR(P.WEEK_IN_MONTH, 2, 1) ordercode
    from usedate u, dim_period p
   where to_char(p.period_date, 'yyyyMM') = to_char(U.usedate, 'yyyyMM')
     and '${periodtype}' = '当月'
  
  ),
--部门维度处理
org as
 (select org_id, '  '||org_name org_name,org_num
    from dim_org_jxjl
   where parentid =
         (select org_id from dim_org_jxjl o where o.org_id = '${org}')
 UNION ALL
select org_id, org_name,org_num
    from dim_org_jxjl
   where org_id = '${org}'        
  )

select * from (
select *
  from (select * from datetable d left join org o on 1 = 1) dim
  left join dm_mcl_acct a
    on dim.code = a.period_type_id
   and dim.org_id = a.org_id
   and a.index_id = 'd1026c1ffd0841b2bfe631cb7643745e'
   ) res
   order by org_num,ordercode
]]></Query>
</TableData>
</TableDataMap>
<FormMobileAttr>
<FormMobileAttr refresh="false" isUseHTML="false" isMobileOnly="false" isAdaptivePropertyAutoMatch="false"/>
</FormMobileAttr>
<Parameters>
<Parameter>
<Attributes name="project"/>
<O>
<![CDATA[新城全口径]]></O>
</Parameter>
<Parameter>
<Attributes name="info"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="periodtype"/>
<O>
<![CDATA[当年]]></O>
</Parameter>
<Parameter>
<Attributes name="comtype"/>
<O>
<![CDATA[事业部]]></O>
</Parameter>
<Parameter>
<Attributes name="valuetype"/>
<O>
<![CDATA[实际]]></O>
</Parameter>
</Parameters>
<Layout class="com.fr.form.ui.container.WBorderLayout">
<Listener event="afterinit">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="tim"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=sql("oracle_test", "select to_char(to_date(max(data_date), 'YYYYMMDD'),'yyyy-mm-dd')  from dm_mcl_acct ", 1)]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[setTimeout(
 function() {
$('.fr-trigger-btn-up').css('background', '#2cc5d8')//.fr-trigger-btn-up 
var str = '<div id="modeDiv" style="width: 400px;height: 10px;position: absolute;right: 1.2%;top: 1.5%;z-index:999;text-align:right;"><span style="display:block;font-size: 12px;font-family: 微软雅黑;font-weight:normal;color: #ffffff;">(单位：亩)&nbsp;&nbsp;&nbsp;数据截止日期：'+tim+'</span></div>';
		
		//做出判断，如果没有，就添加元素，如果有就直接赋值给iframe src地址
		var v_modeDiv = document.getElementById('modeDiv');
				$('body').append($(str));
 },0);

 
]]></Content>
</JavaScript>
</Listener>
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
<NorthAttr size="31"/>
<North class="com.fr.form.ui.container.WParameterLayout">
<Listener event="afterinit">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[//去除参数面板滚动条，三角形下拉
var timer1 = setTimeout(function(){
	$('.parameter-container-collapseimg-up').hide();
	$('.hScrollPane_draghandle').css('display','none')
		clearInterval(timer1);
},100)
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
<Background name="ColorBackground" color="-16378570"/>
<LCAttr vgap="0" hgap="0" compInterval="0"/>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.parameter.FormSubmitButton">
<Listener event="afterinit">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[//自定义背景时，设置按钮圆角
var timer1 = setTimeout(function(){
	$('.fr-widget-click').css('border-Radius','5px');
	$('.ui-state-enabled.fr-form-imgboard').css('border-Radius','5px');
		clearInterval(timer1);
},100)]]></Content>
</JavaScript>
</Listener>
<WidgetName name="Search_c"/>
<LabelName name="时间维度:"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Text>
<![CDATA[查询]]></Text>
<Hotkeys>
<![CDATA[enter]]></Hotkeys>
<initial>
<Background name="ColorBackground" color="-13842984"/>
</initial>
<over>
<Background name="ColorBackground" color="-15626337"/>
</over>
<click>
<Background name="ColorBackground" color="-15626337"/>
</click>
<FRFont name="微软雅黑" style="0" size="72" foreground="-1"/>
<isCustomType isCustomType="true"/>
</InnerWidget>
<BoundsAttr x="423" y="10" width="60" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.ComboBox">
<WidgetName name="periodtype"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<allowBlank>
<![CDATA[false]]></allowBlank>
<CustomData>
<![CDATA[false]]></CustomData>
<Dictionary class="com.fr.data.impl.CustomDictionary">
<CustomDictAttr>
<Dict key="当年" value="当年 "/>
<Dict key="当季" value="当季"/>
<Dict key="当月" value="当月"/>
</CustomDictAttr>
</Dictionary>
<widgetValue>
<O>
<![CDATA[]]></O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="268" y="10" width="125" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="时间维度"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O>
<![CDATA[时间维度：]]></O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="0" autoline="true"/>
<FRFont name="微软雅黑" style="1" size="72" foreground="-1"/>
<border style="0" color="-723724"/>
</InnerWidget>
<BoundsAttr x="208" y="10" width="60" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TreeComboBoxEditor">
<Listener event="afterinit">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[var wiget= this.options.form.getWidgetByName("org");
var deptcode=wiget.getValue();
var sql=" select org_name from dim_org where org_id ='"+deptcode+"'";
var  deptname=FR.remoteEvaluate('sql("oracle_test","'+sql+'",1,1)');
wiget.setText(deptname) ;]]></Content>
</JavaScript>
</Listener>
<WidgetName name="org"/>
<LabelName name="组织："/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<TreeAttr selectLeafOnly="false"/>
<isLayerBuild isLayerBuild="false"/>
<isAutoBuild autoBuild="false"/>
<isPerformanceFirst performanceFirst="false"/>
<Dictionary class="com.fr.data.impl.TableDataDictionary">
<FormulaDictAttr kiName="ORG_ID" viName="ORG_NAME"/>
<TableDataDictAttr>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[Tree1]]></Name>
</TableData>
</TableDataDictAttr>
</Dictionary>
<widgetValue>
<databinding>
<![CDATA[{Name:org,Key:ORG_ID}]]></databinding>
</widgetValue>
</InnerWidget>
<BoundsAttr x="50" y="10" width="125" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="label0_c"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O>
<![CDATA[组织：]]></O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="2" autoline="true"/>
<FRFont name="微软雅黑" style="1" size="72" foreground="-1"/>
<border style="0" color="-723724"/>
</InnerWidget>
<BoundsAttr x="10" y="10" width="40" height="21"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="org"/>
<Widget widgetName="periodtype"/>
<Widget widgetName="Search_c"/>
</MobileWidgetList>
<Display display="true"/>
<DelayDisplayContent delay="false"/>
<UseParamsTemplate use="false"/>
<Position position="0"/>
<Design_Width design_width="960"/>
<NameTagModified>
<TagModified tag="comboBox0" modified="true"/>
<TagModified tag="periodtype_c" modified="true"/>
<TagModified tag="periodtype" modified="true"/>
</NameTagModified>
<WidgetNameTagMap>
<NameTag name="org" tag="组织："/>
</WidgetNameTagMap>
</North>
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
<![CDATA[全口径]]></O>
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
<![CDATA[配套取地]]></O>
</ColumnConfig>
<ColumnConfig name="CANSHUMING" isKey="false" skipUnmodified="false">
<O>
<![CDATA[org;periodtype;]]></O>
</ColumnConfig>
<ColumnConfig name="CANSHU" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(len($org)=0 ,"",$org_name+";")+

if(len($periodtype)=0 ,"",$periodtype+";")]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="CANSHUMINGYUCANSHU" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(len($org)=0,"","org:"+$org_name)+"; "+

if(len($periodtype)=0,"","periodtype:"+$periodtype)+"; "]]></Attributes>
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
<![CDATA[info]]></O>
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
<ColumnConfig name="IP" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=GetIP()]]></Attributes>
</O>
</ColumnConfig>
<Condition class="com.fr.data.condition.ListCondition"/>
</DMLConfig>
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[null]]></Content>
</JavaScript>
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
<![CDATA[全口径]]></O>
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
<![CDATA[配套取地]]></O>
</ColumnConfig>
<ColumnConfig name="CANSHUMING" isKey="false" skipUnmodified="false">
<O>
<![CDATA[org;periodtype]]></O>
</ColumnConfig>
<ColumnConfig name="CANSHU" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(len($org)=0 ,"",$org_name+";")+

if(len($periodtype)=0 ,"",$periodtype+";")]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="CANSHUMINGYUCANSHU" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(len($org)=0,"","org:"+$org_name)+"; "+
if(len($periodtype)=0,"","periodtype:"+$periodtype)+"; "]]></Attributes>
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
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(or(len($info)=0, $info = $info99 ), "否", "是" )]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="LIANJIECANSHUMING" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(or(len($info)=0, $info = $info99 ), "", "info" )]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="LIANJIECANSHU" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(len($info)=0,"",$info+";")]]></Attributes>
</O>
</ColumnConfig>
<ColumnConfig name="LIANJIEMINGYUCANSHU" isKey="false" skipUnmodified="false">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(len($info)=0,"",
$info+":"+"/ThreeLevelPage/OPE_FIN_MATCH_TAKE_LAND_THREE.cpt")]]></Attributes>
</O>
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
<![CDATA[if( $org = $org99  , 1<0 , 0<1 )]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[if( $periodtype = $periodtype99  , 1<0 , 0<1 )]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[if( $info = $info99  , 1<0 , 0<1 )]]></Formula>
</Condition>
</JoinCondition>
</Condition>
</DMLConfig>
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="org"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$org]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="periodtype"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$periodtype]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="info"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$info]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[this.options.form.getWidgetByName("org99").setValue(org);
this.options.form.getWidgetByName("periodtype99").setValue(periodtype);
this.options.form.getWidgetByName("info99").setValue(info);
]]></Content>
</JavaScript>
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
<WidgetName name="tiaozhuan1"/>
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
<WidgetName name="tiaozhuan1"/>
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
<![CDATA[var org='${=$org}'
window.parent.parent.FS.tabPane.addItem({title:"配套取地详情",src:"${servletURL}?reportlet=doc/YJFX/HX_JYFX_MATCH_TAKE_LAND_THREEV1.cpt&op=view&is_show=N&org="+org})]]></Content>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="当前决策报表对象2">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="info"/>
<O>
<![CDATA[配套取地]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report7_c"/>
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
<![CDATA[var org='${=$org}'
window.parent.parent.FS.tabPane.addItem({title:"配套取地详情",src:"${servletURL}?reportlet=doc/YJFX/HX_JYFX_MATCH_TAKE_LAND_THREEV1.cpt&op=view&is_show=N&org="+org})]]></Content>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="当前决策报表对象2">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="info"/>
<O>
<![CDATA[配套取地]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report7_c"/>
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
<FRFont name="微软雅黑" style="0" size="72" foreground="-16604673"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<IM>
<![CDATA[m9+d@;cgEIfMjTV7&b^ZKM3mOb"EEP.Zh$Vf,uc4ko^EJ!>PVi7'mRnP)1C$>;]AD1:na\e<J
G7F#U7>78g:6'Luk<9#YfmRJil@BJWRpBkadU$F7,)n\bD.gro1E]Ag"C_SDm+)-C[Ddb$eYC
.]AVY5Dbfnqt]A#Am*RFuD8RG"\#\ShNo1rWgFR[L^HDY8GXmtj('Ns"'1.)p\s0pFDqI?ekel
,#eb^.fP6:E4%/rq-Ki@E_4"nY8VS$cgP!8GR>S_/1:PDJ.3SF(2,<`DPT[h77/^.Z`q+1XB
7&;to"9g3pBgn6g`(j0:_Wr;4ZpNq_VV5!uWrL:+ZX7UCL*,:H?'F5XiAl4<GJL*Fs7Wu4WN
hGY)RZX,fOeOVlB+k&kqh<=$Mr4/-q)tX")'<M#PAY!?+lr1t2Y&%.&,K>m`2tGst,(_[ELp
3D-&h]AW[/d-A2))2MaJrDD`Ff`("&Q=<1r$Scg;4-q?fLWC2gdp"V>DR7LNXpRZe%25N$42a
)=B>fhhu#N)DuCG#<H4#0^+Zn:o-g:XhI?U)U"eLjK;O"C_Jn-HXe0l#@Q85H4gIRp#\C!FU
RmD;k=1MW%T(Tef<kh9b/Mc8\Df=e:3KC./P;Dq-Z%^"??F#&C`R6>Tp+cBKQ`]A9,(o<Q.(!
77UU8+A]A`2eh>4:1rTM-7uZ*opBTlS(M,C2<\<^"l=I+X"C(f8*)*OtrJ<_HZMGCaTQE\#a=
pS$i@jG#VSoTki0)<i0dMqJd;XdRcHM<9e5m5sX=DWhX:I2&`YnR<k?>O4NDLmXd2^)p?+b2
f-n2aeDD3G[,=;8kIPd<^^gLml"S_?H7l87kBZ;ou+Md@>Mj@,)?H2O7L6<dUjSL<;lc+*,[
e@)QoTc2Fq'g6;75I_Bb<5m]Amb4*hfr]A`p@+qH6?<Q)6N3%]A"$;`>3+_=HsJ]AHQ4^le:orKL
CkC9LjfT]Aa9b5g^f9b0oZ+C0EkSY8jRljomgIo2d%;uJ7m<beOLNu-b!U,Mdbub2ieTjan>s
OMLW+q1C39W:7b`L3E]A;`f'@eB3YCWF\KRICBH7t^NcsQQ(<pMV^/MDXO-k_@XKkYBN<7n)b
`<+TH5l(A?Wg)^R$Ro9ZSM"P.)Z@'fRfH;6V\oDSi;f3k49%YM(a=G%4*CcF;*3Wr=ge.&CQ
3Jtag05UpZmfo3;D;N3qW[,+Hp6YOB[k>8sD:7l/2VoXY*C'e8+]AZ1p8`\nq+WAiBIu'4oFZ
`aQ,>GD7lYcO%0KspjLE)6a?PkCELg3n?EFI8s5kk1JO%SCg4$RbOgq,m&+G%BE.;4cgm^ir
A7QS;*qQ`jm*.)l&Qd0ctEG_gL8A9Y8&V/')X-1"K[I?UP&\Q6O[b3_rs!#5L*&geDb1624;
bd?J@]A@Fq/4ek`,m/Th3'"b.G>Vh.AEVe]A2I1K2rt?H'MPVj.o8r\+?W>'_+@j7242nq2oC;
SJ^\UX1VGE0e\qP&j6ha_]A";JTS+T._9U`:%.P(.PfW3:[-&5pJC@sF@]A57[Q%=6%f?QA.eN
*.mT<)J/-LjCrXJREV=s&?s3V%@!&j^f3`o">B+FBJ&RDU!cdG8lS#Ac]A.S6nS>DZ'<`oB:C
Q]A8P?$I$X?[90Omi]A#GW*X"muebVb%Xj4'Qr\7-.$2)sD<'bbVp'!`7!d-*g)9F4V=nEuF?`
*K&p2>0W`n*P;te"2!r6_oY=9m<4Wj1XU892=q,9;HKjaoK=IA4(Br,dCGK<@o&U^3RSC>Jm
A?Z"51qO\O,Hjp3D16IrW"NsV%@P/\+=XO:.PF^A$HASb+#if2)/So`3%,ZfW4ArfpIIh&S(
!9?#jTA&;!:N.U`'Q^(JVE6BFRpp1u6,SAdbi0%-4[.t/(HPq\0&PG0i=r9i+53[=Hi<Q4e\
KRo&W,<kZrX`_(tmTW"l"df,d]A@eHA&Tic)5VN'3,4*'$]A!Y[ktI4ciW'K]At6mef6>7RV,=3
)NT!o]Ak%ahpF3K]Ag<E\E)7S714<Q:oYKm<h)Y8`6Hb.etNa3)!H[/UWW1LE!aPj]AO`F``R9-
R[4Ve/<+$8Yc69+_$i5\01mfIQi7o):,s:R:C%Kf1hn>Wt5u?cN:@he&=kB;!,!TJ.VS>P[i
9!:lXjc;EL4aD%Q]A[q0YPTRY7Z,Aom_O"d_GMSgr\9IiRS]A\]AQJ1'CP5R"JiD9@f<a+\564a
qip!4=.X+2OAhOI3q:f-\hgcf;`du!r'ZrNeu>(nBW+[6U)Gtl"mcZn$Wa`$(g#%3g!?cDNY
qb7>FIrrBPA0%1ql#iTQM`fK)Udk+[J'L_OupQ`f>=N-R=`[f+\r`enAtr\aoD*/8N]A.DILT
+1'X)AP4]A$'Pm&3n+$Y;h$n^M_l]A*IL%(ER2V`Qa[_kYaCrc)Opa8O1[rHnjDX:&pXeZ!U+%
&G]A<XUVc/e?qb;+1Y"'%s(pqI$3nm`bMR`:KHdNRJOTE`[pH]ANl?Kemm?N>5V`4<Fp4SQ^#L
\RI3L;PN]AURt-IFNd9]AB_uoQ)AWdO4FHeX$g:?1^Mt?G=+N)+8IuK[?!LT^-jp]A;[k,&O%;)
as33nc\>.;Z9#r$%9(OMTo*6a+RM_I*L>`LPcW-BQPT@;9,%YC@WYY5mgbk6ldX%i/6qYn6a
&/8;sfq5Hu/*)ETtQ#J`5."6H2:s=1*1Q:cP.mYI#*l,u'@Fs$9\D'RCXZc:[_d[Jb)l!1O=
95f]A2>1[-=f0Ut_t3CS4%,+mh<DpLu[9^lDe3bA84%T<.)OC&t^b@_AX'+`-1<+J'BJG.[:<
c!nj+NFs_gOWafP,``44IG&HbIK7a2f5FP]A*76'JAtE(J8RaKMAWQBGn`?%.k8is9^=0&dq+
`[bS4'[2-I?<_75(M5X(),"R7uYXs)9#DOLfHh$_<feV!W&<f9+SD?WX7lEp^!&KCe@%*DS#
TVl9RnLuJue.(tmdN(%*W;bHn5FK-(5Zj,chZ8M5M9E_Z_2Z*To1XIFKaYp!`XtMV=tKOgos
o7LWEIGg\-TsW<J7#Mr2h,'bl\$;7e*_)^"5=.g(tM:=:e.5Pje_G'GMI&,Bhgt2UE/&h;R+
LAZPC!'BRmfZbrK2ZC+32SKki!o3+SF_GlI@]A#4@:Z82]AUq'J_D#F)p^8dP;)j8;%>h#0$Bl
</i9j?>s9X;KWsc&td+=V[i?"N9YOj)hBaf:2q'<OM)LN3`F:Js&B?hsW"(=[14ucB4g%dd<
\hP>?CUa@rdV4.m&hJ<2+>gq?%0G.1%F9W67S`7SC_n7rSWB;3K@-fOaF@Ut3&pd6/h$O"Q3
DRU(&4GVgCj8fN7?ZS]AsA>X\LV'%"m^\%ZJ-)"8!;B7a;l^\$!")"=9Y'IlN4:d0!a4D&Vh<
]AUah3kpckuR0;[drqA-"u7Y6;(E)Rg4LuIt&^Hc+O/uOKp?r"fMJlm9&%080:O=Z%qF<ZJ8*
JoRj,Cl3[en]A'L0M$C!jV!!!aF]AZI>pXa%O2.)lrh3ar*FE"OG#X9'[@EZ=#m!Hc=ekTnS>D
anXSA7dZ#?4tdhkDNV.5JNS<;>%SF+:X;ACW):QT>74$BI>7hOHO"Ig8E#,"D%mA,?L^0s7E
N7$_t.90L6RjShPM7]A77bOOXcVTBXe<95so4@20<GF)E3$<Ei9X`i\f20:4U?",VQtU_8lN]A
-?D1V6l@Fo+%@nW#H;o%gQQ`3n2).rWX;nrQW9Xe@`ua>b]Ab@ddM(=l4YZN,+lp/JIL.QUks
pdRJ:Z]A-KWF_"]ASmPAWum9Qo]AHh?RIphXe[4aZ&Q1(j!R_$Ka1(<q#mDJ-kU`_XAo.PV;C8F
6Co;527,R)*&@ANllqVCOI[u2j6fX:l-K`fo-nmMa>LOGD)$,=3/Et-bTEuR0nW@WR7\o:1:
g]AT;<+jS^QoGlQne#n^me$+Fi0VciHD@RNdAq#>;>*3U8P8fqhNHH&m>>F[U*E.ARFc;)YVD
3-r5*qJ>U.l40tB\f@/><@FBjuc9+Bf([*iXMkt%dTDmS'm#IJ@ghBWtKaY%o]AZI?.WPu^'R
fH_8Bk'R*tr./AJBHaeB1A,>X8G$GB4fcAqkCmPg!?AHfKQn(P7t('[-IHA!-eDi#EMpLZY3
4s8=++SK=C\AS-F*e4TAAh>*VQJjE>)B5`7Sg#BZ&n\?fk9;]A*uiJoH&>_mAlni0ulj<H60Z
WBM5ehPPP5O[;!';>^[qY(*.qlQ^VUjRiB8F%s<ECSM:FZ2,I0Eid+9Ck6!.,2UuEIc\<R&h
fY?8h,J!5NK5Nl:gi!"c_;)rd'^bUIQX/KCuWuj6OT"K,hs\9F94:+^PYcB@FfI9(X%I/H?F
^3FR#^K:aTk5*l-o0b5SN""0tT[V7DcnfrWM)I0T=\_(31CBo,ujS_b:["/;39#U7i6A.;AC
f7Wa1,;Q"m+dD*ojGbfuD[03T4:<]A$RW5?g$L/U0ht<L2:T^P#9$8]ANQ/j>"cejsm1L1A2*f
XBnHn6GfHj(FC3+29sQ>D+_keO$*\D"P?Ol]AI"eg-"Q%>nS`BfN3#\L"l]ACC%VCGTco6+U=O
L@ba2bCHPH@d4mMU(hd?lQj<li3M]AVg1XQP.[/Rd4LHRoeY[F]AIjl$:pkVQi7K&Kf4g4T:EW
XLkHiJ\BEKY`oF59uq$10<q_6F@3l2r7##^tRl?@pf1;?=apH02@Q36n4N-Rs)Jc,=t:j7c*
UGBQl9rbWO`?Xud$i&fdePa><["@M]Am'!N?ibEr(tg'e-i<i-$@XQN=-`MOP-(S#[H_j%>#[
i2%=k+1ca'I+Vs.Y.JAJT"c'Eq=*A2Ig$rGQRYt=X_=@aW>^H]A/-)RWd0+(c'V)_P7A28n5U
\0$C(_X,rP2?a/<<XX,iek9ME+il>Urb\,b9SX:Er`REH$Qr-DB8j#c\b`\RRNDk"?ii\No]A
L(Cgg_iSKtDqpH3/n`*p3)L,H1A8n35T`AT@4/:hudcB9:0bd&?R^#u)^=aNWWUB[nONB(Qs
-M_7@CH]AShKQhmS]Ah=N1(nYGG2Dr4a9+`3,,`"ae7W&XBt*q(bJBY#cXgfbBMBpTi=IiN!s7
*=$I4%1!M=<qRm(KV'ttRT[rl22Dnu[jNrBs~
]]></IM>
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
<BoundsAttr x="784" y="247" width="59" height="24"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report3_c"/>
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
<WidgetName name="report3_c"/>
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
<![CDATA[5753100,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O>
<![CDATA[配套取地目标完成情况]]></O>
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
<![CDATA[5753100,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O>
<![CDATA[配套取地完成情况]]></O>
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
<BoundsAttr x="13" y="1" width="250" height="25"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TextEditor">
<WidgetName name="org99"/>
<WidgetAttr invisible="true" description="">
<PrivilegeControl/>
</WidgetAttr>
<TextAttr/>
<Reg class="com.fr.form.ui.reg.NoneReg"/>
<widgetValue>
<databinding>
<![CDATA[{Name:org,Key:ORG_ID}]]></databinding>
</widgetValue>
</InnerWidget>
<BoundsAttr x="216" y="3" width="80" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TextEditor">
<WidgetName name="periodtype99"/>
<WidgetAttr invisible="true" description="">
<PrivilegeControl/>
</WidgetAttr>
<TextAttr/>
<Reg class="com.fr.form.ui.reg.NoneReg"/>
<widgetValue>
<O>
<![CDATA[当年]]></O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="376" y="34" width="34" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TextEditor">
<WidgetName name="info99"/>
<WidgetAttr invisible="true" description="">
<PrivilegeControl/>
</WidgetAttr>
<TextAttr/>
<Reg class="com.fr.form.ui.reg.NoneReg"/>
<widgetValue>
<O>
<![CDATA[]]></O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="427" y="30" width="21" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TextEditor">
<WidgetName name="org_name"/>
<WidgetAttr invisible="true" description="">
<PrivilegeControl/>
</WidgetAttr>
<TextAttr/>
<Reg class="com.fr.form.ui.reg.NoneReg"/>
<widgetValue>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=sql("oracle_test","select o.org_name  from dim_org  o    where  o.org_id  ='"+$org+"'",1,1)]]></Attributes>
</O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="91" y="3" width="80" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report7_c"/>
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
<WidgetName name="report7_c"/>
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
<![CDATA[9753600,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O>
<![CDATA[配套取地完成情况表]]></O>
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
<![CDATA[  签约完成情况]]></O>
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
<BoundsAttr x="13" y="244" width="142" height="27"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<Listener event="afterinit">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[
var timer1 = setTimeout(function(){
 		  var _x = $('.slimScrollBarY')[0]A;
 	//	  if(_x){
$('.slimScrollBarY').css('width','15px'); //Y轴宽
$('.slimScrollBarX').css('height','15px');//X轴高
$('.slimScrollBarX').css('background','#227087');//X轴颜色
$('.slimScrollBarX').css('opacity','0.99');//X轴透明度
$('.slimScrollBarY').css('background','#227087');//Y轴颜色
$('.slimScrollBarY').css('opacity','0.99');//Y轴透明度    
 		 clearInterval(timer1);
 			 //}
 	  	},1000);
 	  	]]></Content>
</JavaScript>
</Listener>
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
<HR F="0" T="2"/>
<FR/>
<HC F="0" T="1"/>
<FC/>
<UPFCR COLUMN="true" ROW="true"/>
</ReportPageAttr>
<ColumnPrivilegeControl/>
<RowPrivilegeControl/>
<RowHeight defaultValue="723900">
<![CDATA[1296000,1008000,1008000,1008000,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[432000,5715000,2592000,2592000,2592000,2592000,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1" rs="2" s="0">
<O>
<![CDATA[组织机构]]></O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="2"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="2" r="1" cs="4" s="0">
<O t="DSColumn">
<Attributes dsName="report" columnName="DESCRIPTION"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="2"/>
<CellPageAttr/>
<Expand dir="1"/>
</C>
<C c="2" r="2" s="0">
<O>
<![CDATA[目标]]></O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="2"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="3" r="2" s="0">
<O>
<![CDATA[累计完成]]></O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="2" showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="4" r="2" s="0">
<O>
<![CDATA[完成率]]></O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="2" showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="5" r="2" s="0">
<O>
<![CDATA[同比增长]]></O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="2" showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="0" r="3" s="1">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="3" s="2">
<O t="DSColumn">
<Attributes dsName="report" columnName="ORG_NAME"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="2"/>
<CellPageAttr/>
<Expand dir="0"/>
</C>
<C c="2" r="3" s="3">
<O t="DSColumn">
<Attributes dsName="report" columnName="TARGET_VALUE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="2"/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[len($$$) = 0]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ = 0]]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="3" r="3" s="3">
<O t="DSColumn">
<Attributes dsName="report" columnName="ACTUAL_VALUE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="2"/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[len($$$) = 0]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ = 0]]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="4" r="3" s="4">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(OR(C4=0,LEN(C4)=0),'-',D4/C4)]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="2"/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[len($$$) = 0]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ = 0]]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[-]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="5" r="3" s="4">
<O t="DSColumn">
<Attributes dsName="report" columnName="LAST_RATE_VALUE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[=$$$/100]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="2"/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[len($$$) = 0]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ = 0]]></Formula>
</Condition>
</JoinCondition>
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
<FRFont name="微软雅黑" style="0" size="72" foreground="-1"/>
<Background name="ColorBackground" color="-15704203"/>
<Border>
<Top style="1" color="-16174771"/>
<Bottom style="1" color="-16174771"/>
<Left style="1" color="-16174771"/>
<Right style="1" color="-16174771"/>
</Border>
</Style>
<Style imageLayout="1">
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0]]></Format>
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="2" vertical_alignment="1" imageLayout="1" paddingLeft="4">
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0]]></Format>
<FRFont name="微软雅黑" style="0" size="72" foreground="-1"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-16174771"/>
<Bottom style="1" color="-16174771"/>
<Left style="1" color="-16174771"/>
<Right style="1" color="-16174771"/>
</Border>
</Style>
<Style imageLayout="1" paddingRight="4">
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0.00]]></Format>
<FRFont name="微软雅黑" style="0" size="72" foreground="-1"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-16174771"/>
<Bottom style="1" color="-16174771"/>
<Left style="1" color="-16174771"/>
<Right style="1" color="-16174771"/>
</Border>
</Style>
<Style imageLayout="1" paddingRight="4">
<Format class="com.fr.base.CoreDecimalFormat">
<![CDATA[#0%]]></Format>
<FRFont name="微软雅黑" style="0" size="72" foreground="-1"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-16174771"/>
<Bottom style="1" color="-16174771"/>
<Left style="1" color="-16174771"/>
<Right style="1" color="-16174771"/>
</Border>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<IM>
<![CDATA[m94d?;qJITTlIS>M=rfH9QF?qm4AIB>#5OATs[pS>&,.q:o#tV-m=0RL*V@KYc+O!JQ=&J$0
nhu$52LB+OPd/6&iqs8V@XA&i.er]AL:L)b2L&-g0W[M/c-'-^U&"ThJ;u=>2MO@56t@Kq(FQ
(ioK/WH1cM75BLpd7QNQCTUmj_rZlLQojB/FV(5TM>kSa]A=5I3rfbO%J6Lt,GK7R*um`-#%&
'pUqFrlI]AV&bsZ<.&H?bY2s*lt*6[pj:RdR7)[O*aemAB:)HrhnJeqk2[KEk.\JONo%2&SZg
8UUtrkRpI65'juqYJ\P%I2/Afaa/h#Z=JQ=ZW0C3'V1!KplMjCm5X'4u`4VJ#pnA5Ln!Gof4
gr8[c1+XJS+.-/N_(Xt6%t;tQ/32&TEqQCg$n!4`\?BCa5O_*9.']A)uQ@Og'3e?I;m1&U+/q
rZrNcD.Y#7J_lU/ssSr%_ZWlTn32f3mEPF,XU>=uP>CeDc\nX0Ub\BZ')(.p/SZRq'Y>L173
`J9PaM=7S:KJrn#=6DlgfB48XWp"XeC[,!If.PrYPkmcoe:agc_1b9;aR(#Nq<gOlO8#<CTY
9YhMB>3[uLt(6f6?eC2CNMZ[#oZs>0j\;CIB8um#sbDH6*R.(7THHuBL4.$Gfs[2D)'Enm=G
gs;bCRr7'GCo1,T$LIZ/rAn#^j#b!+^7[B>G%]A>ZR+7"0,j,!FkO%sSV.6(X!a;/VSUZ*n=8
IYTrFHX"?I`(>.sG_nH;Y1HmFQZ>H4JL:N4cL?0Uj2Yf$LXnpG4MsD$%Abc*q.n>!A2>^C,s
A6Z?n2,,mE%A[GU-FaF(752R8EUcr+,i`ID1Q:oM4#oMfWcu.9fQ\5sIc2dhp+r\?b.j\?O+
R^E>=`"Y;"/Do/o.UmG5dW,rJ\]AqY!1Y7Eu]A(:u2Fa)Z@Jr]A"B-Yr4B!_sG(;l2(<HhmH&0K
Pr%QRl!!ejC5l/(0kBEq7N+k8M9H=?]AH8e%<q93Yo!NmDL?e`b]AcQtedh-=4Nm1BI<WB8MiM
I-0MqSG*nmQbKo$11Y[$\@[G+9T+lTl7V\3/HGK>R%1&'[O\S=2ur4:`KgK\sV2mIen>%u*d
i#F[$h$lq!Atm^$U/tpcOh)L0F?,r[J2>(OEq1AQKh@sg\L3tG(i8='#d_(a2Vq25:#t<#nE
Kc)"c;sEpA=9Bm_b.G]AG:%AS?B`TnK3S$pXt<*X6KH9[[iZWfkWibMHt<$l^FR9<%5Ll:%fV
d4oR)6%\g6#jpDn+7eXnd?S_K`r@l2j>LE)h3\V>SD_klsYDl>T24Ln>-?T$6q+]A>U>@&aMP
d,RiLt?AqVG61*d7:V5--RYT_2JZ*/4n3(p*ZnDVcOT93eg]A>$_GeUGba:jgT/bl5;+(Lr(2
;%#5aV%p-iF3T64)h^X'2LV2jb8'2juXM&8B;KF+6E#8=3UZ5G`f5FEkogV`9dKRZC8Cj+AN
'$%+2[9'sR25.+$e62R_*5>3-)F*uO_p]AUV%VV]A!iG+0M_5KPr$*M[0O5=P3oa`Tp8%S4@hL
?s<C=ZlV^Xrtb>?IGBo\02a@?opP_[?jQ]Ag`Auqs.\sV=@V0)V6g^lL'U;m=J]AMcY1_^T(S2
kIp$r=)N10<ZV)sYenB`f3:N.q7M^B&0e%2+2d%L[(dt4T\DMq0TSY\D^T(:6@C@VQ>a$<.5
Wl:S1lN4^e3YDWnDil"Rs3.9/aT]AS;qD(MHDDJ9qVpQ1/Ko"*44>-I#2D9o^Ouj(\[M5&[sj
A_\-j'q+C;Vc=*Y8BrR/JW*p_M'iqZ:Z%p:Z&20%!%B7'R/nNBIFBH9H,!VA!qi,B8=bVD)c
.fm=]A'[AD?EsVu=3=tSY[u)X,(84`',hPcm"=>6,*`!uI!1Te(/-09LU.qcMgT6;e[VrL#J`
-rj6$AL'%+&&YJ@UgeR1_>JMc=hl?L,I=8hI.b-:<Rme^dA#U*16#VHjEW!bW]AXHC8/OfMA3
+L&`1([S-uM.b]Ad8Ok\U&2_L1[X\2>I$s8')oG-YJC@3-PV'frI+3LBPq3E:@P*T@qO5Dc_*
R;gMa<\o_bA;.8)59Fgb4+g[DlYmU$M91c_(A>Z8>(ak&BZr^a!;W/qd`>n2=omSgtGSD>/k
]AEP4bY^9bZFI$%36dGSiU!Voln%l.,;"*JE"u/Q/s1?K']AACc1,'2;G[kgmh!CjfW@4C(b&8
?Qk(P,m_anFF(QMC!!2!Ii^)\^*;!/!&^+%\>oBZ<kTFl$;V^^%DD61pRbiohMp06gQY\1GA
BNgY(Z0i$'%l\(^@q6,uqQs^q3_-U4EORO:1X6R6JEGG4o"j)($lr&E>;'c=HAHbGuVt7LMH
`1+a)SYu/;(%oP%VI8_D,<eBVU-gRSk?Re;tcB0pS0DNLsH:5=#GSim1\;9qN1;D6e_Id&rB
kh(WUm!D<<.[eBMH.UT"dX4^P1[WEY"TZWrbOU.0$g17!kB;T\lm*9I#;3a<TM3an*[YX8nh
:ce"Yj="qcj+/(3SL2eliNG1-7E^^j5^a]AI7pha^Dfo^F>rYk>Bao`BgaMuFcWs--u>!$6lQ
3gHREC8*^e?#.dVF),pgN+-quZ8S$j(tEFrCZl2"gbe]AUmle[-L/CY\#%4itB=$EVR.8\(9G
Zm\o(,'.m#i$cf4rK>p;8$^ST46*dC8.h0WH2GgPKV)n98g)K4bf"[Fo?TdOKI9o:+E@,&s-
OhYB9T2e(mM-X<tmiuFBOH1#)4DVo8k!KUW*?5Hj-:bYH5b)(o^qh"ij9YsO#0!@AJ-D7EfP
u\&o&O_Jno8'ZEM5>$J;+j6X#sX`#dK/AWKSHf>=3(X_jJ>Hj=;\GYqM#\gm?QfI5Z"bNmaH
-H[u<4dUSas2/e)dX*FVdmbT#VpU'jir^#'W[?3\hC?+nmi2+2]AHRXC)7f=X)O062\%B!jQ'
YaM/k]A/h'F]AVmD.7]AMpm;X%8bhi0-3pbnF_#%O9eXnqA=c&CG!!rf6?2UdN0D"=BT^!'Lc)!
1?GHrPU\L>4,N(5<CPUXO(d6hVnKMS`:ln)'9n\[@BtL5!$s%`(p^91iNPr"E\>@m*sXme8r
`K(@X(!e]A.W-6;Ab&&g?;^>?Xi3ko&$'Mp^!j>8EtPQZMMCniE`E-j`b4?8(LPV2R(/OZMc[
N1ikBH2sUD:7)<YD;(km!aK+SbR84YjR?\r2k\!O&Y_M(V"9F^MFfl]A8@[Ch016WTnK&VW;H
&Q:q!C-%7X?'3=!nDQc1IJ"tSPFWjY'Eb;=3oa(0X,VbtI$C0V@0'8[0Q`SgShS1b.Y8p578
&WI]Ag-Bq+#5ti!En@t.a3*d3SoTUc1p`.]Abouln'Uu5sB.-lgmfESP#jLZO*@Ds0=Y3akoo4
8uc,\j^DmPk>Q%DHcC]Ac#\DRdhXo@XT+#$-aJaNM6$[d0Z*p^"HYnQ'U]A$Bs.#s_u71F4C$D
&5)X-<)aHQS&WF:+S*H^!,mj-"kTA%)75>sl'sR#(AW>b)Gf]AlVmhqO0I%e):jZ^WnnHZ*Wk
r+W=8NKq&1OL8CY/eK-XAnKeQ3Rt72`VDuEDjcE&(N_[LM<aICne&XA2mrY\&5YqIjW"gT3]A
58)6Pa6b]AeQ^6p7p2+=fAFL9MZFhQ(nI/lS5PpkEq:]A-^N_lo.#s1F#bXA]AC6U1@>$kCCNQd
<n^cn"J7c&AL%.F2#_e<eL4o0df//E?`nc!q'In$qh^!cZ3R>N,[+`kOG&7#%5;Pi_H]A%/?B
2k1(V[<;kGnD6o'p*;kPf)V;_7:XDFM6>L\aW5@E[`VbH5ob/A=0:8G#._'Y1CTnQ*"'N-XL
=d:_g$Z0#GG7Mrqt<qro(d8@9M($^u[Cg66e4$F$R`PkhH75TZ<b2+@/!/QRpe_Y\YlufD'j
4XR<)TcSkORtpZL0-EAn5L-aqkc`!M[8F>'"HtU,3b<3&'JElWJ-%ZgBoU_hmFa6MAia.7u,
_&T2N$AiP9SZO\`u&K#\,95(#JNWD!s.Rac]As^`0GjD)+j$ng$oAd%pH"V(ZI8!p:-OBY779
5mS<:E6hI[R&p2aMj_k'-574:^EaS:<,b<uQ(<Y%muB45>O6W<AdUm^*mH[M#(7a9J'um*>r
-mX@gE$m'"iFbZ_f,X(jMrK,)eF`Hm&t"3'LH<`_p\:Y[()=odoJWN%0"gH;#a@N%=OkXP_)
DbM"jY/l#5P4nNGgTORMV-l?L5p>=O<AYqN2ER2jGp-=n[#'pF']A,,bdjHjE"o*G:CV"4C4]A
'R"0RP<-.76:b1-BofZ#F+6,9S8MRaEL"KPtWDQ6U>jmdam2K9VUE\DNN\_.Km1T5X#IK)Te
Em+9/ODs&EWYN;.3_JW?TrV'gl*%E]AS\]Ad!=fU+nJ)O('33]Ag#:AN4(ZO8o_DA"!6p;<\%+9
okeYFgh/FeG/#o*J8]A!'"RlR7&l+KFFFo$GVu)'3En*qq,V^')KVJ,YHX:D'@;EsrhVVXIhX
dq(Mh]ADAp#q[r)L2oRfP!&IeE[@P2SIXN7\raKS+ND?o2ko,U--+Gplea+2'9/EQV`XAQ'c5
?V)YJTc/s`!)p@*E?IbuLP&RP\c0f#/<0Mtj]AYB5LUiV[YP&<&:GlMSZH7W\M@c+X&gJR3_o
ESWoY8Q2G/b$F$p4iQV63+GN;4_#CL^Z(nTQcUe.Do=d)gjNHBDFuead=I:WS1="GTVi5)^p
r#HsY`cbZ5_2p!n\?<M"kOT/C?1Yt?4T.]A^0PYrLbMV3a9l7_:f7RjAi-jIKMgp#`1d0a[&2
k7`Jaf??Zg\dOrMZ<`0`Y3t-3Z;q+Lq/"^ar+.N".\?h<W]A(?t&C5t)QV7kEZk1DWE)A;!hg
J_#84]AqCoee=/FbWkeOW8g"QFE9rNC>\X+c6!IToC]A=]A/GK21@AXjMq\:Pg$F`JA'/bj]AuI?
\M[69Y>1E(@r7siAk#HL-L$ID;Z5@*71QoEA`&uqQ)F%ii!b+kfO5u=#mJ(?9U/<tH>"`beV
8"!t&$NT0_QCf#DV;KNo1Ou0j<4$IaVg!;WKu',(KCpq=_5auChICcJVCN;=]AtTGd6)P;>dd
e\\%7+W@(_Bn!^BYYE^$EQ?c+8QZEQB9FmN]AbL(FuWcDNA0n8:d'O_m&a+j;9s._g0po"j!&
`@IQOB&`2Df@:8qQ=^e]AW2Vi6<cp<e&;ockr:[aaHX^L9QP/r=V-S)L#I!?NpcsI-Z-H<&a@
"k.``Kcs'^MmE,D<cn8Wcp"SqM)j6lb&),W&^hGJX&h^5CJQ.*:_TrUpq9aEDR_B36)--\o-
RX+HnH<VD1i7]AW((4m!Zor?$Zba'<X#>KZIT@a_BHSOsVlXR$K/?_UUr[todI#I/Sacgu6l_
\0*`kTe8EqC[lRCsiFrEP&DFnjlWc!n1G;--'oA9-p#:<H'6JAdS419RRt"n/3VM\>g]AYLDp
qdW'FVCOWH:iq`5@=/b3?sn%0.<['_N?,O64o&*U^S6#T4<6p4CojRhslg?]A\*V#AD?k,=9"
@M/lEhi2YFC8(@@$C3q=dTK0n_lEER;Cc^F)[BJ1\aX!SHUm:ql/=4tC9B=;#NkcEF4P@/G0
m5Cn$%Kg@%`aj\1SQ88S<Y+qol&dMRn[F^asFjgS5lMYQ5]Ap\#.J(k\3uDZ;M'R(ZR*]A*F.g
NKE:?\=eT<I>G!=[fG>*Y^%4Q.Ybm67/\!p(",u@8e_@"SIm.+H./*8cp/l_J6?$fp8M4]AUm
D*$!A$5L%%,=tQ69$5"9;XS,e;^51&$GW4m^G.B`d/JerE.n[$-@OYFVXA/%92hcA%Dt9m<n
j"N%2Tc##W_b0k-tH]ASe$3RRc_[K9Xt0Yoh:I+mF]A!j`GC[d5F<egYn[gZO'-s5YiogU13RG
VoRZ%&2'\o0D6@Qn_SL"^?uTV0qsY2_==#>Ju9IN/)J=E5N5.%G`WHq,mS"53;J@6)du%>4#
/Se5(O%uBobL8Dl'l!GTt4C/n(!/DFc^sd=3l"ZlJgrg_g]AG*H\&R.Wm+kf7cl(nbN@XdNPi
G.@2tfO&l+UL%E1mQtC.jgmRg[OP(?l6NiY/$!Op3=LAJA!%'j'*c:5ALs9SNAqI"Yn0]AZ\F
bn$B+&iK>d\DB+f7%5X9!JO9>LhQWeI5$m<?rp?hE\_EqPAPWh[IfHKL,1!eH>Vdeg$g^KhI
-[glU(X7^(<A1QaT[7HMqE<,K^'LOKc>Q`k)\"U7j?>:;Y`+*--_:$']An<plu-Y\TEsIINKm
UYgnD]AH("cn.?k';CsJgp'p(eRN&J;]ARTT(aPEl(OoE]A1FG?OhdpHNee\XX$!qm3Yr8n\Gq9
_?6Y0Dmqn:'B4k4#P::DWu&EEB:HQ-bZSPD"*J]AVmqPg8A2!3j\<.M3(4']Ae2Xu8&B`dT7:+
"GVqVm\f^')56&6f3"KP"[j$80M!MW/3>XoJjYld5(dO&SL[m+D1]A(W@U]A>lgj:_f%\^9N6]A
iVcAh)"H$3QZ>I^]Ad%NYnGC-cnbd&oJIbIJkiK9jVK)a?iBZahtN#.qB8&Jhfb+Xr9r8f.dY
0=?nX8s_]AnJP//l4@i4,`QX35Xkp!?:0iSgmej^34>g#a9eqrGDeUQ0BjBcVEC]A):^QB6?%E
2]AqTbZ>-dM-"-bh8+qj#5^Mi7jS\?;I\t9a=$[AW8&uBgQ?8P"]A"I\.TL?t=d!5@>'dAZgBU
<%aP0:2*iS]Ab#S3cl.7,u_3Q$[PEeZml>]AQA%X=U3b&8:!jfg>*.:$c)WYWg/no?,H-B!af5
,L@-.BbAJ1M639H/D0e7b%CtNqkch,199mr6HS[\hJULljXpb3-_Qu='Pm`mKW9G8\`rG[6b
Y7Qus$.kk3r,qkQ1ue1f$Lf>;B<4nhetRh,ngtXlP&(`;dHf@6dL$#(%mQC^!@D7r!(*Rn`r
"ph@TLo`%uY]A9V6;R&GZ+BC*"Shp+fV1Z<b#JG`9jK*/Z:hT.$W/`\\p*FpssO\GQ_1-g?>C
MuqL^*bU;u90tJ8(.)Lj3G^2[^?FAMMrJ#JTo1#2[0sa).N`^hZQ;QrS`u[-s*;sG6t7KTWC
81g<a]A<pR9PR7g+kek\p3_CKSuMX%K8A!I7sieQTkmW%6t0g(tQIH8hTi/4:[c;f-ej]AFGI=
(+0%9l6Do#XX=Nq-V(L'Z#jc`O]A2.L-bP[)Lh@N.r7iL/0Ntnm/@4OPEQ+fl<oI4n-1cql4n
pa@;>M+An=u_Q)!g0%/hDcEoq=j]A2n,G,d.Y\'0mEe:`D@gVWM6b8pbmer."Ie/D[Jrq.oB_
nE@CASWX"a1<2:&VZ4DBhZabM#hP2D20OVEtr.SCR=8FG!TU3"!@CkSsDs+=6\*:R#;B21ZJ
>uD6uPb#4C`:a(F%)*F\cX,ln4`dq#fRh#ZF.jga7)IcdYb72eUUNA',LC%?lp:Qc=e2mZE[
NRpZ%oS+RZqkMQ4$>GU#E`f(?5\\7'tLk0kudKnk5RDE&k$3Nob;e<qeN3`HI&Y(rC9H2;PL
J(^RX%Mdl058n_Rr'TQP@r=W#:s%p#ZQK-tn^cu>mDLfIEW.a?n-h+XRAKM(Aj)=VRalQ]A/`
#'MBR8[@XL]AF.5IT4hBF`sg@5Zh<um$:/SE'CXc'KeT%1Z/\$-$Wrd[$8l3P6Lg9YQP<BE=B
b!&@?$2^!<>[^H<I?X"_iKSZAO4Y#(["A>E/OArIeb&a[ofGVBmr(IoGm\hho/#%?"-Ek1+(
P<Q$=0d4%tHIj"(?Qm`KBZmcceGW59pT[kfcbENDNqA*9MT;n6>+OK2P9B#!=ioe%=@e6SO%
sVsd+1MsJ,fLqO9?Q<HY_<$rT>N^SEta+h[*Cf\GVPTrrE~
]]></IM>
<ReportFitAttr fitStateInPC="3" fitFont="false"/>
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
<border style="1" color="-16377030" borderRadius="0" type="0" borderStyle="0"/>
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
<HR F="0" T="2"/>
<FR/>
<HC/>
<FC/>
<UPFCR COLUMN="false" ROW="true"/>
</ReportPageAttr>
<ColumnPrivilegeControl/>
<RowPrivilegeControl/>
<RowHeight defaultValue="723900">
<![CDATA[1152000,864000,864000,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[432000,7810500,9829800,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,5791200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1" rs="2" s="0">
<O>
<![CDATA[组织机构]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="1" rs="2" s="0">
<O>
<![CDATA[科目]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="1" cs="2" s="0">
<O>
<![CDATA[2018年]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="1" cs="2" s="0">
<O>
<![CDATA[1季度]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="1" cs="2" s="0">
<O>
<![CDATA[2季度]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="1" cs="2" s="0">
<O>
<![CDATA[3季度]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="1" cs="2" s="0">
<O>
<![CDATA[4季度]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="2" s="0">
<O>
<![CDATA[目标]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="2" s="0">
<O>
<![CDATA[实际]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="2" s="0">
<O>
<![CDATA[目标]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="2" s="0">
<O>
<![CDATA[实际]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="2" s="0">
<O>
<![CDATA[目标]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="2" s="0">
<O>
<![CDATA[实际]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="2" s="0">
<O>
<![CDATA[目标]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="2" s="0">
<O>
<![CDATA[实际]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="2" s="0">
<O>
<![CDATA[目标]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="12" r="2" s="0">
<O>
<![CDATA[实际]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="3" s="1">
<O>
<![CDATA[京南区域事业部]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="3" s="2">
<O>
<![CDATA[合计]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="3" s="3">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="3" s="3">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="3" s="3">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="3" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="3" s="3">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="3" s="3">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="3" s="3">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="3" s="3">
<O t="I">
<![CDATA[333]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="3" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="12" r="3" s="3">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="4" rs="4" s="4">
<O>
<![CDATA[固安区域]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="4" s="5">
<O>
<![CDATA[合计]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="4" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="4" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="4" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="4" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="4" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="4" s="6">
<O t="I">
<![CDATA[4]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="4" s="6">
<O t="I">
<![CDATA[4]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="4" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="4" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="12" r="4" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="5" s="7">
<O>
<![CDATA[经营活动产生的现金流量净额]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="5" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="5" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="5" s="6">
<O t="I">
<![CDATA[333]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="5" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="5" s="6">
<O t="I">
<![CDATA[333]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="5" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="5" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="5" s="6">
<O t="I">
<![CDATA[4]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="5" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="12" r="5" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="6" s="7">
<O>
<![CDATA[投资活动产生的现金流量净额]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="6" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="6" s="6">
<O t="I">
<![CDATA[2]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="6" s="6">
<O t="I">
<![CDATA[444]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="6" s="6">
<O t="I">
<![CDATA[333]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="6" s="6">
<O t="I">
<![CDATA[34]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="6" s="6">
<O t="I">
<![CDATA[333]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="6" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="6" s="6">
<O t="I">
<![CDATA[4]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="6" s="6">
<O t="I">
<![CDATA[333]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="12" r="6" s="6">
<O t="I">
<![CDATA[444]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="7" s="7">
<O>
<![CDATA[筹资活动产生的现金流量净额]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="7" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="7" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="7" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="7" s="6">
<O t="I">
<![CDATA[333]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="7" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="7" s="6">
<O t="I">
<![CDATA[344]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="7" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="7" s="6">
<O t="I">
<![CDATA[4]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="7" s="6">
<O t="I">
<![CDATA[4]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="12" r="7" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="8" rs="4" s="4">
<O>
<![CDATA[永清区域]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="8" s="5">
<O>
<![CDATA[合计]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="8" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="8" s="6">
<O t="I">
<![CDATA[2]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="8" s="6">
<O t="I">
<![CDATA[444]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="8" s="6">
<O t="I">
<![CDATA[4]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="8" s="6">
<O t="I">
<![CDATA[433]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="8" s="6">
<O t="I">
<![CDATA[43]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="8" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="8" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="8" s="6">
<O t="I">
<![CDATA[4]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="12" r="8" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="9" s="7">
<O>
<![CDATA[经营活动产生的现金流量净额]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="9" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="9" s="6">
<O t="I">
<![CDATA[333]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="9" s="6">
<O t="I">
<![CDATA[44]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="9" s="6">
<O t="I">
<![CDATA[44]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="9" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="9" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="9" s="6">
<O t="I">
<![CDATA[333]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="9" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="9" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="12" r="9" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="10" s="7">
<O>
<![CDATA[投资活动产生的现金流量净额]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="10" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="10" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="10" s="6">
<O t="I">
<![CDATA[333]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="10" s="6">
<O t="I">
<![CDATA[333]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="10" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="10" s="6">
<O t="I">
<![CDATA[43]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="10" s="6">
<O t="I">
<![CDATA[44]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="10" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="10" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="12" r="10" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="11" s="7">
<O>
<![CDATA[筹资活动产生的现金流量净额]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="11" s="6">
<O t="I">
<![CDATA[23]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="11" s="6">
<O t="I">
<![CDATA[4]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="11" s="6">
<O t="I">
<![CDATA[4]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="11" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="11" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="11" s="6">
<O t="I">
<![CDATA[223]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="11" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="11" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="11" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="12" r="11" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="12" rs="4" s="4">
<O>
<![CDATA[永清区域]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="12" s="5">
<O>
<![CDATA[合计]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="12" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="12" s="6">
<O t="I">
<![CDATA[2]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="12" s="6">
<O t="I">
<![CDATA[444]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="12" s="6">
<O t="I">
<![CDATA[4]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="12" s="6">
<O t="I">
<![CDATA[433]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="12" s="6">
<O t="I">
<![CDATA[43]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="12" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="12" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="12" s="6">
<O t="I">
<![CDATA[4]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="12" r="12" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="13" s="7">
<O>
<![CDATA[经营活动产生的现金流量净额]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="13" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="13" s="6">
<O t="I">
<![CDATA[333]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="13" s="6">
<O t="I">
<![CDATA[44]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="13" s="6">
<O t="I">
<![CDATA[44]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="13" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="13" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="13" s="6">
<O t="I">
<![CDATA[333]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="13" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="13" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="12" r="13" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="14" s="7">
<O>
<![CDATA[投资活动产生的现金流量净额]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="14" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="14" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="14" s="6">
<O t="I">
<![CDATA[333]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="14" s="6">
<O t="I">
<![CDATA[333]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="14" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="14" s="6">
<O t="I">
<![CDATA[43]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="14" s="6">
<O t="I">
<![CDATA[44]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="14" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="14" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="12" r="14" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="15" s="7">
<O>
<![CDATA[筹资活动产生的现金流量净额]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="15" s="6">
<O t="I">
<![CDATA[23]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="15" s="6">
<O t="I">
<![CDATA[4]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="15" s="6">
<O t="I">
<![CDATA[4]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="15" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="15" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="15" s="6">
<O t="I">
<![CDATA[223]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="15" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="15" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="15" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="12" r="15" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="16" rs="4" s="4">
<O>
<![CDATA[永清区域]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="16" s="5">
<O>
<![CDATA[合计]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="16" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="16" s="6">
<O t="I">
<![CDATA[2]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="16" s="6">
<O t="I">
<![CDATA[444]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="16" s="6">
<O t="I">
<![CDATA[4]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="16" s="6">
<O t="I">
<![CDATA[433]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="16" s="6">
<O t="I">
<![CDATA[43]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="16" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="16" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="16" s="6">
<O t="I">
<![CDATA[4]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="12" r="16" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="17" s="7">
<O>
<![CDATA[经营活动产生的现金流量净额]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="17" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="17" s="6">
<O t="I">
<![CDATA[333]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="17" s="6">
<O t="I">
<![CDATA[44]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="17" s="6">
<O t="I">
<![CDATA[44]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="17" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="17" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="17" s="6">
<O t="I">
<![CDATA[333]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="17" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="17" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="12" r="17" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="18" s="7">
<O>
<![CDATA[投资活动产生的现金流量净额]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="18" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="18" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="18" s="6">
<O t="I">
<![CDATA[333]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="18" s="6">
<O t="I">
<![CDATA[333]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="18" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="18" s="6">
<O t="I">
<![CDATA[43]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="18" s="6">
<O t="I">
<![CDATA[44]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="18" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="18" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="12" r="18" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="19" s="7">
<O>
<![CDATA[筹资活动产生的现金流量净额]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="19" s="6">
<O t="I">
<![CDATA[23]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="19" s="6">
<O t="I">
<![CDATA[4]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="19" s="6">
<O t="I">
<![CDATA[4]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="19" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="19" s="6">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="19" s="6">
<O t="I">
<![CDATA[223]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="19" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="19" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="11" r="19" s="6">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="12" r="19" s="6">
<O t="I">
<![CDATA[33]]></O>
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
<FRFont name="微软雅黑" style="0" size="72" foreground="-1"/>
<Background name="ColorBackground" color="-6877671"/>
<Border>
<Top style="1" color="-1"/>
<Bottom style="1" color="-1"/>
<Left style="1" color="-1"/>
<Right style="1" color="-1"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1" paddingLeft="12">
<FRFont name="微软雅黑" style="0" size="64"/>
<Background name="ColorBackground" color="-6710887"/>
<Border>
<Top style="1" color="-1"/>
<Bottom style="1" color="-1"/>
<Left style="1" color="-1"/>
<Right style="1" color="-1"/>
</Border>
</Style>
<Style horizontal_alignment="2" imageLayout="1" paddingLeft="6">
<FRFont name="微软雅黑" style="0" size="64"/>
<Background name="ColorBackground" color="-6710887"/>
<Border>
<Top style="1" color="-1"/>
<Bottom style="1" color="-1"/>
<Left style="1" color="-1"/>
<Right style="1" color="-1"/>
</Border>
</Style>
<Style horizontal_alignment="4" imageLayout="1" paddingLeft="6" paddingRight="6">
<FRFont name="微软雅黑" style="0" size="64"/>
<Background name="ColorBackground" color="-6710887"/>
<Border>
<Top style="1" color="-1"/>
<Bottom style="1" color="-1"/>
<Left style="1" color="-1"/>
<Right style="1" color="-1"/>
</Border>
</Style>
<Style horizontal_alignment="4" imageLayout="1" paddingLeft="32">
<FRFont name="微软雅黑" style="0" size="64"/>
<Background name="ColorBackground" color="-1644826"/>
<Border>
<Top style="1" color="-1"/>
<Bottom style="1" color="-1"/>
<Left style="1" color="-1"/>
<Right style="1" color="-1"/>
</Border>
</Style>
<Style horizontal_alignment="2" imageLayout="1" paddingLeft="8">
<FRFont name="微软雅黑" style="0" size="64"/>
<Background name="ColorBackground" color="-1644826"/>
<Border>
<Top style="1" color="-1"/>
<Bottom style="1" color="-1"/>
<Left style="1" color="-1"/>
<Right style="1" color="-1"/>
</Border>
</Style>
<Style horizontal_alignment="4" imageLayout="1" paddingLeft="12" paddingRight="6">
<FRFont name="微软雅黑" style="0" size="64"/>
<Background name="ColorBackground" color="-1644826"/>
<Border>
<Top style="1" color="-1"/>
<Bottom style="1" color="-1"/>
<Left style="1" color="-1"/>
<Right style="1" color="-1"/>
</Border>
</Style>
<Style horizontal_alignment="2" imageLayout="1" paddingLeft="12">
<FRFont name="微软雅黑" style="0" size="64"/>
<Background name="ColorBackground" color="-1644826"/>
<Border>
<Top style="1" color="-1"/>
<Bottom style="1" color="-1"/>
<Left style="1" color="-1"/>
<Right style="1" color="-1"/>
</Border>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ReportFitAttr fitStateInPC="1" fitFont="false"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</body>
</InnerWidget>
<BoundsAttr x="8" y="243" width="845" height="217"/>
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
<![CDATA[288000,1257300,1008000,3024000,1008000,432000,1008000,1008000,1008000,1008000,1008000,1008000,0,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[288000,720000,2743200,2743200,2743200,2743200,2743200,432000,2160000,2160000,2160000,2160000,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="2" s="0">
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="2" r="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="2" cs="9" rs="10">
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
<AxisRange maxValue="=if(or(max(ZBPF_KJ.GROUP(ACTUAL_VALUE), ZBPF_KJ.GROUP(TARGET_VALUE)) = 0, len(max(ZBPF_KJ.GROUP(ACTUAL_VALUE), ZBPF_KJ.GROUP(TARGET_VALUE))) = 0), 0, max(ZBPF_KJ.GROUP(ACTUAL_VALUE), ZBPF_KJ.GROUP(TARGET_VALUE))) * 1.5"/>
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
<AxisRange minValue="=0" maxValue="=if(or(MAX(ZBPF_KJ.GROUP(VALUE_LV)) = 0, len(MAX(ZBPF_KJ.GROUP(VALUE_LV))) = 0), 1, MAX(ZBPF_KJ.GROUP(VALUE_LV)) * 1.3)"/>
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
<AxisRange maxValue="=if(or(max(ZBPF_KJ.GROUP(ACTUAL_VALUE), ZBPF_KJ.GROUP(TARGET_VALUE)) = 0, len(max(ZBPF_KJ.GROUP(ACTUAL_VALUE), ZBPF_KJ.GROUP(TARGET_VALUE))) = 0), 0, max(ZBPF_KJ.GROUP(ACTUAL_VALUE), ZBPF_KJ.GROUP(TARGET_VALUE))) * 1.5"/>
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
<AxisRange minValue="=0" maxValue="=if(or(MAX(ZBPF_KJ.GROUP(VALUE_LV)) = 0, len(MAX(ZBPF_KJ.GROUP(VALUE_LV))) = 0), 1, MAX(ZBPF_KJ.GROUP(VALUE_LV)) * 1.3)"/>
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
<VanChartColumnPlotAttr seriesOverlapPercent="20.0" categoryIntervalPercent="20.0" fixedWidth="true" columnWidth="25" filledWithImage="false" isBar="false"/>
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
<AxisRange maxValue="=if(or(max(ZBPF_KJ.GROUP(ACTUAL_VALUE), ZBPF_KJ.GROUP(TARGET_VALUE)) = 0, len(max(ZBPF_KJ.GROUP(ACTUAL_VALUE), ZBPF_KJ.GROUP(TARGET_VALUE))) = 0), 0, max(ZBPF_KJ.GROUP(ACTUAL_VALUE), ZBPF_KJ.GROUP(TARGET_VALUE))) * 1.5"/>
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
<AxisRange minValue="=0" maxValue="=if(or(MAX(ZBPF_KJ.GROUP(VALUE_LV)) = 0, len(MAX(ZBPF_KJ.GROUP(VALUE_LV))) = 0), 1, MAX(ZBPF_KJ.GROUP(VALUE_LV)) * 1.3)"/>
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
<C c="1" r="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="4" cs="5">
<O t="RichText">
<RichText>
<RichChar styleIndex="1">
<text>
<![CDATA[${=periodtype}]]></text>
</RichChar>
<RichChar styleIndex="1">
<text>
<![CDATA[目标]]></text>
</RichChar>
<RichChar styleIndex="2">
<text>
<![CDATA[${=b14}]]></text>
</RichChar>
<RichChar styleIndex="1">
<text>
<![CDATA[亩，完成]]></text>
</RichChar>
<RichChar styleIndex="2">
<text>
<![CDATA[${=c14}]]></text>
</RichChar>
<RichChar styleIndex="1">
<text>
<![CDATA[亩，完成率]]></text>
</RichChar>
<RichChar styleIndex="2">
<text>
<![CDATA[${=d14}]]></text>
</RichChar>
<RichChar styleIndex="3">
<text>
<![CDATA[%]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="1" r="5">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="5">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="5">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="6" cs="5" s="4">
<O t="RichText">
<RichText>
<RichChar styleIndex="1">
<text>
<![CDATA[${=periodtype}]]></text>
</RichChar>
<RichChar styleIndex="1">
<text>
<![CDATA[预估完成]]></text>
</RichChar>
<RichChar styleIndex="2">
<text>
<![CDATA[${=e14}]]></text>
</RichChar>
<RichChar styleIndex="1">
<text>
<![CDATA[亩，]]></text>
</RichChar>
<RichChar styleIndex="1">
<text>
<![CDATA[${=periodtype}]]></text>
</RichChar>
<RichChar styleIndex="1">
<text>
<![CDATA[预估完成率]]></text>
</RichChar>
<RichChar styleIndex="2">
<text>
<![CDATA[${=if(or(b14=0,len(b14)=0),'0',e14/b14)}]]></text>
</RichChar>
<RichChar styleIndex="1">
<text>
<![CDATA[%]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="JavaScript脚本1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[var org='${=$org}'
window.parent.parent.FS.tabPane.addItem({title:"配套取地详情",src:"${servletURL}?reportlet=doc/YJFX/HX_JYFX_MATCH_TAKE_LAND_THREEV1.cpt&op=view&is_show=Y&org="+org})]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="1" r="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="8">
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
<C c="1" r="9">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="9">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="9">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="10">
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
<C c="1" r="11">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="11">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="11">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="12" cs="6" s="0">
<O t="RichText">
<RichText>
<RichChar styleIndex="1">
<text>
<![CDATA[目标 ]]></text>
</RichChar>
<RichChar styleIndex="3">
<text>
<![CDATA[${=C15}]]></text>
</RichChar>
<RichChar styleIndex="3">
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
<C c="1" r="13">
<O t="DSColumn">
<Attributes dsName="1left" columnName="TARGET_VALUE"/>
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
<C c="2" r="13">
<O t="DSColumn">
<Attributes dsName="1left" columnName="ACTUAL_VALUE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="3" r="13">
<O t="DSColumn">
<Attributes dsName="1left" columnName="RATE_VALUE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="4" r="13">
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
<FRFont name="微软雅黑" style="0" size="152" foreground="-16711681"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="1" size="104" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72" foreground="-16604673" underline="1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<IM>
<![CDATA[m(@U'e:%3Q5(c1YO\/a]A'pXSc?RD!_Ulpu(8m0:XAh]ANB1*fgK]A=FZ7'P1esP9lB'P'%V]AQE
eYc_-etC8,)tqDRo34G^dt[r-l]A\3I]A$?n''sC^<c1pT!.a50/;WA9Qk4cgBI_1G*njU^&S4
S6U2d`/DjLd(Z_BD4U?/Yg=5oYV8.0kNkb4bF_EB[>P%!Q^O-7E>lR]A%lZ>ZeA*]Aaue]AA/I%
o)/([@9A0Dp4dBfsbNcMF=c?602d6HW^s*J"lA$r30B,VY2C`.3'j_?C&XaC@%bE2!9$O0:V
f=gDY!;Rr<64Najd#+mJe^9A2/XRSB@!]A4ubgpOb-m;h#N<UV\Z93<+.?V)#u!Z!&PlqDaOe
9W>h.qD8D^VJjd>D//RSAWe5&p`1udYf4%'0lWHN%YOF-UB]Ah*P$W8&"NY(<eaNg2"Ym7JUF
>Al6!aYgBp"4Ko=(^\M3b))FM:j$j$:IoC'!>g0J\Rae]AnLLi;JZ+YR_Vh\[^*:^6_4"!(?s
"-#uiTWE9=P<!:ob1"5P5#NPV7I1N"7aqn[RZgV_#4^s^!ifUitX$@NEFmCu0o6$@Dpkg`-'
Qr<lY.Ksg;,$h`Y9X04SS`LWM*BgqrcGVd5ac<KnmH?dfCEITAc-Xs\3Wr'\\iJo"/9k#^;J
DHV39X*[ll3/0^k#Qp#L_YIT"=A_RlFf@P'=;@TF2X=a>'-0-FNp-^l)]A8uV4bS\>r&0ar"b
e"1Ndoi-X\M]A5sQEO"P2jgf05C21'f@/fc+oNLel0&oa7)iqo1W(.p"rkatQ/p@;#9PX#=>%
1$TY'\'Pa,H?q@$+J7ZJ9T.[G5/fO*sXYXOQV63/263CtJ*u#@R\Cpb$%*WVXetg67?sqF_K
Md\\Mr[?flq"bYQ2bS;n1+Lg_jTs".q6=Gc@^&tT4IRP>\1aM?:45A6Gk-(Isat8Pfg>t1-p
I/L?RG4$_A)nd2?HQ9\I.=G[Nu;k_fo%/$Ts-j:D'90`Wod2V8IXfmBc!t(Fn`$.YiUmfKc+
Ur`e&k>a72P.jl;V`03[[lZdQ0a\W*e\5RWX7=eP&Y!KVB"I'^arQ!U"sg^VQoUE,-nI2n$L
3MWa!/5uSJOP2hD@rp\ML+:7?:K,OPBpcA.CAnF2G<.Phm$5hk=)[@-i$;'OFWbF0mGU]A(f8
SbVdABM\]A`[c1W,[()nsFfm\\Aic[rgBD^01.7=Z5MOSl58#eE39;f-)-)0@k@2W4r@/1e]AH
:rI9B590OYs2]AnqKoYD-H>m<-9([1n14*t_YMMV)<Kr\[&VmG.5eAU@d9Z95-S0t0#HBFWi9
pbELDR"'*jIZ"(0K!X]AX.P3A',^=EL9Ei4^L57#GdtW?rqSc\G/jnTC%@KqjS9`=L+FP`+4#
i!FEVfD<Wb'/A$Oc$qGl>c^)-GI,O&m'0]A-5:H(rhM1daS:#f;=9k'[+o?s1Q88$0;k6#OC0
?!MKea@1u_6-?#)&cXk+Ymgd5EIMGE#,cCVG=#TThnZDoffpcBSc-c*ipORY:H]A,"dPS,8J[
I$Pe'Sj)I2)hF!jC'[s$$k_39pNGT`B.`rl:u%C`1mK(\L-?aO#1QD%FPS0L!Q`e3?D3RM_a
D)#\XcBK6)k&W=7P#'L@OO0ZFX10.Jg`%T=J*VR7epR;^[*i%dErr9q6`C$k&4+qjQfD[#f9
A2,^[t2%Ea8;K>bjEi1!"n2XJ"lF3&4/L=g:QN4)Hu1CpAaG%s/Q31g7mTThRAI6[/XY3!is
s=b[^g.3=hqQ\3P,)'EJ9;7/Sqf*sdOTrl.#9kd0jK=oa,N\,X31-M@\s8PSQb)HYbe"q,rH
Ml5E^*q.`iD9)eZN8Ng?l@L#Rqrb.JeW?;pLu3K:s*l/H7@)j9>O[/>N^!?O@D>auo".E_J9
K0G+4'h[Y7gd(.[,@G-N<)dW]AMQ6C$#XsR"38-hhR'gFH.i%?d=f.!sB@sK@EB5D,A9l01&:
hRL#"t\P5[_af^-ihrl?cQd#K%aLmf=@(7oC$+4JM?U4Dqh$(H06\#8i_Q:+Qk99m;SGYSrX
0<Q>jMekO5J^u;-k)*hniQ"7:>Ed$en*>Rhr_06[tTl`r&s1p6%boHB92^_^P?NRMj(mZr-q
)R'Y\[D]A`Zc2s*)$!(ns9Bom`S6[ZcX4oCSn[rhO&E(8Stc]A`LP#/d#/-QR"7QD:>^:6'BMW
08=f<3!B/#3=%$VP7Gp;-@pOtWb(M'?]AP2<5A:%6>h&`[]A<99b%W%K!=1Z,"i:UZ+lZmbPZL
[-\lG:B;$N#gN>/c+[X_<gNVL/J'D$PIt;4Z&.6BF[JG44Qsgm$;0h3=p6C;h8'2'-'9cfK-
(%J/LKd&(_f>+qZ8,#3]A[KR>k]A1W7*PRc3]ARhOi5(g49t@'lDhb&g2<JA@#r3I&J3`9a$8FK
aZmi++LU+4T$OM2C[BT)q5k88V;_(5q;g12@cktPI8YN*e_L;A9s%Gkj?L,dJgCiD5ZS=LR$
@ag5U!g70Ae$Ar#"`#pfnQ.mZN_3qS\2U*KWV_?6RqKtoO>Q"tCEneI;HV1Mrgqn`R+jk=O'
;nRJr*f#tgPrB#-9+<1W#)qD`pQgMKY4/lS(,&GKYW[5KpEmL/b&Z#qf4gq66Gr<$-IBtuDq
)D_/<ip:0hLD`;<C-Z?"-f$"'B_<LT^..OD&CD0*8B_>5k"&3i@BI'*V*.4Rm^8/N-rQh4kU
1)Nb]AHi[k6?qH-K1@1H.T9iYhR5;jMU9]AVtm\]Ar.`]AT8@(mgGeoU3.5oBJ'YpB$H`pWaV3fH
N8I>4Y3O/ito#Pk'/nNGc2c)b%<sM?6@/qgk8InE(SDV7p(C_Rhq2:A+2j4O@u4Q-LJEhGVh
.-S5JArcFOrS4g`;^5aFMJlA1O-\8Th]A\HH(Mgh^r5TqS#Z8b2;"!JIu0O^=U:OP@@?<i+J2
]A3!cTk&X3</[?+[m8gWheF/PZ)fb4>a,hj<7S_R*oXU^)3]At6cT70e%G#VAY5,VW%$U4-q?Z
A0/Dt>Y;1g2<XPL\u7&rOIs>2$-Vk51N:P1n9XhfDgMUC3rE#":H)r3ZB)N2gFIBIgB$Bk=,
&T]AJX0K17bgM9D"l^u,DZN_iDGns_!NBl/4JLMhZYC9--[GTD%:D2K?2+o910eKTieNDAjo0
:R:,jgJ;<05h*h9[kI1P>J#E1;k1("1f=jEQV]AA<,&&M!MeU7^LjJ'Qb^Dg"Lm+]AQ7`t<a0!
*!WV*AZj_$HY[d?c1ik?YR.sLI?]A1o*R08R)*)`5_8jsrU3/IJ8-C4q._me6!d3+hCnh8$S0
2P+>cQSjhm=V<h.?:+.[4Bc=KIe-2/)c8gQ*W[E,S:ZX,!?prq5'c?cBN=GDY/hP\+tg%lqK
cTmh(Oc7a:lC.5i:-+'^G78r7&;<@:YY8*7rl$f^"2_Spog-Vig4&:G5*LG@Q)>ofje=`=GQ
3k]AcJV`Mn,D?`\GD_-4j9!.Q_,D%QqY=*@;#kIsS2m^hi2>6KY$Q$A)"]Ag2GB?2Qr-b-ankQ
%5bF\V1U)9;#5qQZ7f3<G[*8N[huGp9L4`d?66+2=mfMSfc,hK`%WNXi-h\35qkmqS([RJ7=
jH;/JHcL&&2EP=3_C0i#AdWX*qNB!6$;nh\=hY$3r7'mR9GV$]APigG@-HnRn*EonZ4iN+Q[M
s1m"22)[_`Q\5P1]Ao)A0bnd+9hp^7:,Z-&JemJ1aY_PP.'/ZMu4&ebl>">2FY2EGB5G`?B9`
9[Aag&10Af^cOM<(Do**>EWH=(8sBI(5"&G0;P2lb)i6T[A;hWoM,S/T)umWMU\k:!o8I<)p
m32#qggP"dm5EH2Z[;0V(gJdR9A[Y)"PH1-7-DDl:3fq6XLa&.(5SJE!RP9:/2k3WV90#e]Ar
Ff*6LH2E)Ygf1X1@'*tiR?#l;SY,m-KhIebZN9.[Agt0=#gIC-:cG0Q0E?T<-U2^?1g7jP._
.R0'ehe#pCH:5tHAj8LeU-@cC7FhLH!(_CBahN)IjS)Ek1W5Aq;^(sl^GS(pq>WYVI2-E=4k
:.ES)k3VXZa)=@HIo0W8Z$"U3GP9<D!QR"m(hVom>$E`Xqf@@oVXWed'M!Dp:8G'fk!cjSV>
furq(buaTp-"E@dNCMo;cl8eAQa3#&aISjR>i:eh&8'9@^k=X$LTNi<(V%'SVEdV.7j=>>l_
@IJE+&I#a^V1D`UYUNM-h9OP"V]A?<(>De<I-1^snBR'aCbHNJA.E@%SqD)pN!`dli4'u;SU@
mE&*@SdAD*M^Q0&OGa;ar[n\6r'nFbAsZncDCM8Id`D@eoGior7`1/Mp.EGB+iFIjRCHe[Qf
fdM5dE,V@o@NIrMp8b)-(Y3,)\q1>a_GrmiaU+EZq_Pji=qrm#EB)WfKPnh&t]A]AF,Y5\Q%70
`Id+4/@iq;4[SB3ET)@^Y\5B&;OY3m8bs5%Uji;+I''AJ6f9-!"Co#f.>l`>.rp<f8u%*lbd
l9'0G;%En/bLl*H3S6EpW(hgtQQld*UAnM/s&i#BY-[3a&SB/<A>1D]AQ7O=l2@EXYM*Ff:6h
OW?esWbHst9O56?f7p^E9So>4/N>HgT<0/^fkmHkj(Xs)pYp(fBr@iC;%IT>p)ZLf+\11nBc
d[0j1@(rB@D2SN<KjUZ&EVn3k9Ia4iBo(MWZ3J^%8?J*nl)J!H*T?r2d?a_T-@'\??+GH#r)
/>P+/;j"-/I7>9&Q.-,;--lk79_O3K6%Vb@4:ag'Rmb]A/L<#r(CmXIgq`Xc./VkTHJ\SaE]A9
[7?0BlXfe!@7`mop(EWdn/Cp`]AbQb&QgYihL!M-\SpJF,ljI/f5$sUp^4"P@8<os08P3V9RB
nK.<#Xo"e(#a8F7EpULA[]A:;W;J-0C7D2U#%_*92h$\>2Fl@fC[I>3H7n@!,"F8c,4b"?m^_
6:JDmKIWUYCETiCM_J,I#j,NQ(?9_Z%2=424/W>S?KC(I3Dn\1V&hB4+(%s";m?">nR]Ak,,U
+"u5+7Kj@33Q6,Eb=UrN?OFCKA@W!:`slu%4!qk&aqXZR6B0ge8RUo1Zude1*,WKMtC\PV>3
ec:a:81k2I6L>1!gmIF7qZ,hmSPN1"2SVo@#+MT%$"Y*'pDIu:Nem>Ej-PXM;DS)Lq<h"77$
&-AaO&PpQ=-Oc:f^@/O\&"Y?M/p$I;G0'31L$::>k6;ap)>H4&S=I)r5i4p(D<0F<KU']A)YP
Z<WGkj&S6!.Zf3#5:"Pi+OL`:'I(-/qfGJe15-QP8URL79[#F-2VE(3%>%LVnHL^Y]ArXct*0
^1t75fcVa)ZNCoVY)R&*58COV><\K[p$jH'#Xm/XMiWLAqT?*Y(NuON(oYQ4Ye26*.g@QL#M
#1NdbR8lYL(2@Tb"q#TMVcW1^L'U$W4(UOER;8hA8r^,D2Drj'7K6.dX1?6HS&6HQF[qV'a)
lo1bLt'+HV%jC.)qUaI1]AB&JSBK^^M$EYkXlFiBFe9\e"qF)0oXG/H09b4RIrt$C`Z46P,!4
`Tlq&pPW2d@Pt&j0&#ij<,Zg/m7t2,LH`-\._)(nJFZ!'.^6sGp=Ru>iL./YL&>q=%&cl3;g
#$24-@(niiT]A[j@]ADloC\/8e%hQXX.$[dea@+Kd)6D9(b%!q`6Jd#VKRPVDdb%X1g<Q]AfeVV
=^ORJ#OSOoS#A<:HiVTREkW$T&O(h#FDUk*OC>$-^>'=0"*dZ9T,]A*9?9G3k<UJPt[$PS3.3
2`a0Hd+)IbAB\^GI_c;F`d@0F^fXj/pm1GNb&Hr4H@Ltb'E$ReGbJN<[5og_,WsTKBUT'9_K
$j]AR*36B^\#mg'%Z6C16A>i%05<FTG&h:YmLbo[?SsUibm%7+Ds%/UaN[gD;ka452X$LdEb:
isOF'YL1pGXM7MYVlVe[)(5kLCS*c)0H\)A/sV7*nrhsZI7^`V)5hqOh#&e5ojS+udEhA\cu
F7]AB#3sbQgI[SIEUH2]A3g`lbZe2)ceZWPa$7mM$5J*T3-L!mO$V3('/W>cVsk=GUgk)_5]A-A
if<rd)@jQAgi2uPM^M^A0U&4S$;n!3Wj&:WeAF)MB4kBQYj+Q7S7Ypu!"Dng3Dd/s\Mo/S:l
3Pm_qS=\A3b.:C0,KKKD_^%jFS;'*_MFFZI;[0'F738]Aff;4Ojsd,ulf8qc\&K^2)6QMNWQ7
`QTJIiDHYoYar^ra.f;i+UdMU)1.qj_P3ioYbC*uqSTi\73]A"9At7t-IZ(-qLT_HBnsMOBHj
g9k+lN2&-r[mY^;k8%ZrL,]AjNdq+;_DC3'%*0S!KE]Al?0P@8NS^EV>Z)_:?VW;T4ZbdXR4*q
lkPR?X=T"$lOc2QYC`WRNi*rS!enL4ST+kGiUo2+iieE7]APa$QlT@aakbQgU>Wm%0Mo-^X?D
i0cNA,dZ(t3IQ6:MlZG*5lK'WAc`9rQKrU$@MbTO^S4_=3@NK0'.[T#)3.H0SZ_2iZp;'5>$
f.V,?H;GMbfmGQ?9Hh*22]A^#kb<Ls,<gF*e]Af$p*lP3$\eA%Ynt7tihBV9$'.2eK\Vk=&p*$
CW7>38[?,ZSfqFh!T`pPrbVo"#;,eoC7(K[Wb/jD"_#+s@g]AZtutm9>Arjn#WU4E^?TiDaL[
5,aVlI]A52W*/gsQ[<PVi1U"[QI30Q,hhN!1U>1e<*[t"tGr9^e66Cq[#iLiq3_G@913.`7X`
]A$8EHZi0C'MkI!dgAFq+TpUX=i+7dEe.n'$<2"7V9Oh,BlR_VkqYO:pQBDs0O%FKPAEDPcaB
EPdaBpT@MU8%ib16\h-[eQJ%,:SgS\/XcY7'/*s:.I2YN1fi7Z^l64E[1\dN77-R6&M'F3jk
\IrIRA+7C4IK.ARMT4=5VMN"L>uk/&'Mpjb0oRIh$:>Z,5RA\%++FQ%N`RimXSZu)kn$g+qK
r9PWjs#97`Xc$a]A^CD-`a)GpWb&_Ir&uDDBiX?-)Y#?.aW("]AYqNq^\+aB!U1aO=4q:'2+W!
f6L</Eo?XmJ$)nsbfiZmeVDQ6WgIUseFW/sXuM:o`Tap\67(s]Ag?L?mfs["+OH@s[ZTUA?%W
?*1n#E2.:DqgE(E-E[8IY4PouE"J9*N#pAV`Up^[qcZECk;/I/&q%8Tln<`G;#K.ik!I:FWR
#KAQ6UePUC<8`k2P2/AjrZ6q;pB9MB)Ju*qB=d$N!<U`Fe+@34*r$uAWM9-K^]A-COSGFCcM*
t<GBTB^UEE@jb0gLQB^71FN=64>hojQ3"S[_W:/<q?7_f$@?ahVgc,$GkfcOd)i+j/X2NQ=p
#Pk7k(2P%YrkKVOlYUKt_C'HqF]A<.=O=$+iKdd#I@h[QPJ-5)C3@eHg#cL?%nHP3?-K0e8"7
Aj#dZKqn)Hn2a_N<?_8/e-OIRf&kE.Ta;$kXm`g:=U(_D!/\K5rb'r5>q[.-nZ72]A8/h.^)#
3Lt%&*5\'G"R$k5uYaq6LV+I%U$Si*6UGD[*Zh-!D8kB/u89Prm4c@O8YPVc_B!%hgKXJ+09
S163'S84?EtjCM`J>El/f<TZHh9`Wel?EN=(Qn*Aer>@Vhb6M1`=h=oS;rub,e6Qj]A[HWQN)
NL_NZB_ZRhBsdbYqDboT((3M)F%RaS)^nlWIp$PfdO&;6XfQ-P1/r=]AfI_IF8<:QR\QYWJ]AV
XFHMl\,AY0G/6Wq!ogEA,#RgYEL,Ol62K$"?-g(j`qDRtslQEg-m0upI(q2V:KYsnrE[mABF
.CP<:5e2DN29tu[2BWlD^IHUXP2m='WYU#%e+Y?,EQ@8g(Q[V7c4(^86-Hm5;@dPXnkJC*";
)P2&Gr#oJ11csIDZd1/@@9-WZ%hKUlbL;q:YBg:c[:RcK?(MDa:\(s&R5qA<;^;QMb6dpI<?
AZ3(l)l+4+M2#P4E*aRr4jgIu^;U;EaHEJsU04E.T6Ho*pFa/qVoC8E-?]AlYH1^!)eA[il#H
NB<FUdt%<iYh]Aq(X_(Bnhk!n(C]AD\GU3GG!F2:EZO3B_0JU3_Y1>k%0jrdM/$<F/SMd<)gfg
XnW,O.i)m5$rBV+J,`1k5oRNskr1p[DX,CW*Jb7`83.U/l_om-`B5u/G[qXZ'e2iYP]A@e6@c
F41ap%PAn;_X"2uKQ]A]A^&GSuqHk7sFa?Ja>p24GoYLEo3f/@6X4OMc/g&8YUL`^L5o!T:b2%
jJ\ac+/f/!FtGY=,P9R=roYY#qon.N0^%P&)g1QBOQJ`N/%\JkqZS74/^[?C!GS`M7#:pV"U
S;bpQpL2P;t4J/*`.-dOmOI[2l)@tmsGbU7IhWT5`TV2N89C5ibfCpcmAh%A"!_I\5(q;%g^
RdJTSd^Y4K@VaoD6cL7C[tX3%J0cV"C83so[Oq_$iJ_Elhu@G-db^Gl[2SrBKL?)UX"CXbS/
qR:8!I_>[JV51HAUADWrT71i+\XGV35H7m!sKK4Qo!ZlOTjW5;.k[e"+08R;Rr+9&PJ$53t>
F:=G4[B/12hr8J`Gi%oU(of/L'F"$.lM"D'D&uf[?;/,k)"Y(R9IY'5?EnO('\N#1h(6oNHU
m%1O_ZA5M@XL"/tm?`63j[*i27)oEt&OTHs8NjkA<`J=,'GW!QbEeB1\sa)7;sH>mMGnB28=
N+nTHcF"s<Y'3E*EV73hR?cK;2NSk!]AO7mB3307LjTRU(%;,5-9CDO[6;aQL:g\Vg>`s5f5$
;>QLKV]A&>&VWEBaa5%@GA_>BQnG#;g9d:?Xo/sVVtPpPY$994W=G34H<L]AU2$,T[j<_Y$eTY
3\NbNoA&cB<c5=&oj><eo7<cX3A5=p?Oat*=n:@JGeZAUVt'kSb;%)7t"n5_oGk&$3uKd,b\
4c5j>hOpmUAoiUEdg-]AU/,Amnr\<3;f'X/.KMJVEZ5:7/aVQtmmj!f?F"B=TAeqH7@aG)N-j
^qe^?=Lc'Lak+GD6WD\KFVHJ%e6IPR1q0&&"IkP@%qsLZrHt(l:JePZ.pS-&0[A8_aKBnae]A
GX<=S5-@Ub(mmJFE7'Hb\gP736!s[@:P15!0c&\-d&DnXb994Tb-XI`kS^;jA8C(OH;GOQjZ
,O"DA'/O<@aQ!8Dn4b->h*IE'==<Z-:U,4qkn//rC)"!U;jC.&3mCH@^eYogDBFi%gtS%B]AU
L>ko5jpTs2VlG82k;bK3/^fh@m@`nU\%BbnR2XHC6KECY)b8[TUE6S5,*KaT9tK-5*m==_5.
`7XMNio!TKbj'nDHm8fY4l6ZF:`'HppV^KUZqq'So##7)n!H\!c"#b\Wbe-*$o!Hq49\%>pI
><7pY=W/lCuuXX_gZoV(YO+&t-e*@Mh>.?M.fMHc,F^]AO7Z6b-"[/hPko<9@Z7OS%Ib!U3QN
n`'RjGF"/m/gsEnqaZ[L;rKWaJOYJ/gM1ok?J7iV[HqT8i$YG2Pa5V'od"i%3*c@Z)-G8UGH
_bl\,s;O,=HW=6mn;-.X.:FdBosq-oM`+dAPAIg+ITK1oH1:6F\57Q"hNI*HW/YDVAZ)F0?t
$[or>/-k@^9p96?_s40O)OTul)5Y<Pma54d`IZMGN[CrF7C/kR^#UVQ4e<:nSocNCsOP*,_(
a.k0`Y4<6.3lUKZ*n-,c=?+!G6M/0N'B@Q\3W30(*'1t)X\DT(]A-Nr1T":lm+M>AG]A/1U?$h
I-5K.8_SXX#77s(Rh/.EB=;'E:S/h=K5#-Su`$k-P-Z'=o-Z-2Vk?;&Xlj@S(llrEnBZ=#UB
'IPmn#Ns"P<N'_Sd%U_`c]AV>P^)CSP:D*33E2&PUo8iK08@)/ts;l*()_;AElAq'A<+g8<0$
&6^M\<<GOI']AU,q=2dtEVb4kJ[kH'H<OJsH$+`,)lPdfA#]AC^2DEaT"q[^_oC2=3J6JGcg)Y
%YD/nk>)]ADFSl]A%dYN*.Xb6Mje[/a?a@o;!=;CWsEl5LRZe-i1$Cm+l`q*'QSg\WgWsq$^=C
6[>]A<[+md70fm*b$uQiqE1pp:R7,2c<k4(gAknL&PY#7h<.")?hIn+;.ppa6]A[nM/SsJT*ID
,d7Ed\O>C7t&C-WAD*YJ*&*.iLIDlO?8+>B7;*2s5"pLE([D([(b>%Eb8o_!=TWO8sWEnbE[
k0NJlO_7_,9HIa)UoK7r"dZf?kd:CJ9d@7FZ.!-IkroT$f(t*]AS3_@&:np8r>?J-p&F;0;\7
5\-^cq.qkFa!)"50"Er:D.VNZX/1:fJ?92P&_CX19Y*f#rg2FAd1D9.Q\bU)I$JDP@.n:Mk=
Mrdt.dSaEF(.4adEpZ9#=j</hD<-RR%HNaCd%7Sm_>08L"S?KSD3;nLa$"bB8KA__(F/AI%e
;G_VKn29p,(&X"*;/\0D0s+f_S!l@=MEL6snasn>X81=`[fbu#Y%C_W)*&5;GOj'%d%62SP1
Xbic#7OF,o<'UXlo8<K[p6R,AU=+iG.\4q05Zs-*=L:cR;'ZYU8Sbemdknltl+Kl"Q;O2JmR
`0Xr&'/\_MlgKkVH"EC4H;-,sO*`LHL`+gd)&WT&F0q?3<f,H+H%OU3#Le$_k%Ku;]A[6L;,C
_)]AARr![K#)_U(Q-S):lg?tUFh#6pe-\;LmS,`6^2hF]ATGXfVd?_9,[UhFbE-0E\`p\:(EF@
"Q_CV3^N?i&^I"Y4e@mg:C<l+G#6[$Z,ZoMMc>]Ard&>0gGV^'r5X(X,mXkeYk7a;&u1jhR+h
eJjd^(e7O$j)_U%UaO+5n/*A&3W@7*35!4a\Z/+7_1LV'A1_A87dA@&A!)O_^#'m?4Z4)22*
6\rqJ,DJc5iO,o5Rt1$pq`e_e@C?&K0ggltI4tE!.$tRmU%@k$t1miB^mVqHA",`sBkRURn!
Kk2hjkEN>,kAIsg![J-6"`p>o:6a7>`pO,71Zlm.fo*,OXrJn*E,FUC:\8U^pej*/6:l&MP(
;04Yo$Y)d%8'3aaF@GlgqS=9#fdH90KqQ=->_Q(4Inc4?MJ-,5"7-$"`uAuF@n+g8bR(\d13
Vo=ZD17Y\]Ar'/o#&0A!Lfo^=2A@VANQ@:&Q`a5bMT2mTl5:V_5""MruKd%lt\LA"UJB7H.8!
[Cj;$.C>[TpZnu0]Ao47m\OoCQI)$:,_W3]AXp-u!#5q\auqt-to97*@.,gCe77s?(r>%RC;aX
eBO(p8!K6h^s`Y\1U;n\sp+_N<>fBW>'&QUO[LYmaBa2sjnuJ.W-ba:l65F92SsSH'GdS))F
BAYu5_ZCk$=+e!*/q4iJ&RPT'AEu1W%6NCS:.NoaJP(:AM9lV<[IL36mI>j'eB%7(rF4T+H*
W_4cMcXK9gLEbAmmu9KSRk\.^apQ0jbMXcqt3<\g.DqMf>E)T?OFa.kD@cM"0&)U5.XCX^0<
V9j6U`)6'"&"BmaS!BM\f08cX;"k@-8j.g$`iS7TSnnjMb/nF2<e>'bF+i7A@BYgViLM;@Wj
q(BhZn9m/^m<(dEKoa6.NNHBkNJu.o[GmN/Zl.1.7aJ(l*r5?/U3Q4:iT.H]AoYU@e:Wl[d,T
3rl(Bh15k.I:0TEN=uAnd*YXj>-C6s(XIl5J,>o8dpRp(oT.?Uf!cZhETBp4hD8IM2<2c"=&
I'n?h:,@UT,(*pFqM'6mfp[?h)n:.L=ZM:cr`Z:aT.SfMo:B%XC9hu>@YtE`9!<^td]AouqXm
s[/r4@n7Ve(RHr4*g!RqEW9>qER"@La\@ic`?Z=1`pj;mQD^AKWhJg3^''\cp[`9YdmM^bdg
e10\@F!j4;@>f!]A)uk%$u_Qr:uLkepGaN,3KHm^hMT':;/[)V&I*<4^u1J'&3[K61oRacs3;
Re2eGqo7r,?#Zr<\W!6J%LB+eL_U6^QV@SgOJ/2T5)1e_%Ois_/qab<?>S%YJKE^/Ob4X9[n
=Gpm%8CZK06^UZ3#X'AEgGId$,?d5peo/_AlVt(0IhHF]AkhjIIp*o0BA7`gI'#+i^[YE4P_X
('l:LI8RYipo6Yc#71jR.+3%/*6uThU-k&(]A)k!*^d:NFchXrXXdm-uEO+`Ne:Q%$gPf["i.
qA-KOJo>af?2^>C.\W*!2#U/h&LdMEkrqn7c#)]A^2N2-_c2lFc!8H9,Kkha@_G4AC,_W\XXL
FZC-d#QXp^aBk!c$]AQP:-%p87\YHQlr:Ui`-f;OIJH^Lc<2'6MSen*_QV?6Y'sKP'u(g!OE`
P_`[@T0"?UX>JW7h^*P:hM?"dZWT'G8"-7Hn@hbQ/4/+T4BB'TESdB;4k:c4Mj5G^Fr2TLS<
,Q=p/X&70T1%O#S%nXBi7Q*[d*qC-.P!hmS[T#2Z?iX<u5:PZke*Z:H))QlD!te%E.[A#uAs
ZC/@*(mto,Uf84O4s3U.iS'V,Ml>F/;`&bVuQne=">_CA!&"0b0N,Kj[.qTh,Vts(KIpuG0-
KH:RqHijG1S;js[B<t*=!%W0?biCb*b&.j:HI?o7gejT%t5=W7X1oNiloG:"SGW\Il>U)cBZ
)WLB,L%[20V>@'3L0gN)'=E['g=?MW`<VkI>eGO+K8hBis)o9.`YSM)J3#J'hp&5m2+qufSm
7@p:\6P%?*Pj>/*>6M^Q_^!>iF;/9i]A`qWUX3=;s_$?UtnJ^gt3\T0"><o^VU?/\<GLQQse$
__+,-NRR1T<YU;3,MD]A0<5m&j]AHBhHHYGFG!&&hJJ4a?TfLCKI#0>B9G-=`k3sHrcu&jg,<J
'UmnHk`p'#X@Ge#%:FMEj<1*SK]A@[=[^I2hSXH4`H"h(&Cq?b+V1[g=E#m\t#K4R1G:OWI;o
rR%%+Hhm_MUGDY]Afm`r%=78tV7PR+2.$``PK0_9_VN6\-gicho^m;N>>(pEB"t")JA$XV6JD
%]A$sUB!HRA9g)X_aGUU&nb^"/j[$`2QUL_]A'J2pj^5r\?UREFeFG"7HZh\KgrD+2OR_6SM?Q
rP:+-=acnt0gU.H3Lf*!Qt\RU?I<`-;.8SF4,;%9mTh=IhDbK9'IW"RYoAhd[o6>a#2#*$3u
AiO;LS\d%pl&9ep"g=p]AM5/`!UOgps]Ap08pFbt8JVg,>i:QG7XLe#AXBaSqU1hG@X%NaGApj
/-K!O`DD<^6!)6tl*f7L15)Zj5qQ"u7B%YX+.?+T2a\e5*J)=S\LE)kU7`i+CSaSNrgROH_"
qMO25H(QhG:=ABVon%VK2)2ZjZ0T=R?!3K^'YE"FSg!IR5f,hC]AKN4CA3mNV9s]AL*_@I*R65
4?]A6tP=dS(r9kb]ARtM2_fWN``]A'd)XilZkC>ng#WF^;qUL5&&Q"`Ar^/N9o8f^E*\[gK7r#;
qlAGRg]A8;gF&5G5>Dqh-XBg`eN($`-`XbR]AmqOOKb/@>-ZmW:\SoEb!c%6K^Sj:7'W8ZN)h!
#p01*]A(4;/RR_4CG'WIhf81W\D%Xf`#B4!d)_DG]AH8uk8_Mf_6J?OYKen.CN<BHl98B3A[VD
k%=0OknL'E:h8I8(Z!1Pr,AZN*WWdIFCH.`.lP`!@-Q3JK6(hH^V$.gBXGGfrR^uEHfn(T]A,
BX8ZQ4%GDO#`4i\oamMG9$UQjdCll=2'Tb5Vj;^"<e%9FNC8kSMLbpP4aZ2:0BC'^e9[c=FQ
h;)"in@qn6B9pl.j&0&sWp$*^oEqQ9P[$6(^?jCjqbeN7hJJ6e$.p2)RtI%oAkaC9Db44$Z^
:^c(:n2<R=TNL^+F(EgCf2%B&nhlM=X#tc7`d3$J"=H-u:ebiD#pnVd+-kD0)oQM7HZ.7TGo
>C[AM/CoSdV8n\X]A1A0+8;6^@oXVM_f3S&T:4-<?&%"dN]Ar7nCf?)cRDmS(BP,0T?_l^.A++
L9@Elmh+?,Qr>X%r[)cBU\UqIcdL)*&ns$_fX;`PtD2jORomL)GQQs&`HDlHZ-#Z4Ie;GdUZ
^jHP2M]AO&\e+L566h7!=>>R'?eUlXE=5al`4r&gm6peb9_NHMab2:;F<R`UX;IsT!.A*8A/3
bWgA@"+#@Vg]AqnX\mZ`cIZMmJrl%k?2hp-Q?8Eu8EB(i&quOKrQaphA,%'EAp#.8@M4!ROR>
c<Ym)-6j;dN\kr>)pp/]AUq\4E7X.a>3;g/g?4`Ti;80^C[Rl@$UU=Y1>U!=9c!Zo15?mKhd1
UV,%a9&5bBu`/d4UT6T$D48.gH_!qH$n!mV)j]AHf7sjK7RRI*:cVHN3fc7:\7E9MLo:u,bRY
6Ou6!;n4q'$f\_1RB['iW;K!fhlW?TMDM^s_eF+V8HAiAT9]AkZU3M[WD"gpE*8G0rfUd++S<
co'>raob$.Pp/2nl;j(LY77nA%J=I@)tdEeU)S%2X#1cXB+FN;F,CjYF9;Cq*EV1!_3L>[I,
Si,<#6>YHs9J<[]AoeGCH_T?Ed]ANQL7jOjsTCi8^Z%`$L<E!bd^Gs=+d&:e_slQLOQ('+qg($
:K^t+q;di>*#)L$2>*X`h<Y$\ndu_S2mp<u3X0\S6&9`DQObh;^QZjn6:YP?G*@7J,Ka]Alf:
RYt'BD*[Q!Ak79F%YoJc%Ds7=>h$8i(Q8C5&Y"B+$[l-UIeWEHeVc#,f?cd5.SlUt'<XJ1?u
\n8%p\=KlhYp2HYr2*,OD(^$RSbDS#NV_#?^Q)-Ftd?MHU\-da<`&cVca0Uo5jUqo=oP2u.7
iQVMV;YD=L$GAS`O^':!_I+A7_pUCZdm`\Sm.q=0"`GBlpVpXRl[fD]A:pk!'_HZV*WmN7]A)V
kthrIbYSs:m,!p_D+QdoS`Bo%YTHn[f-XGcn*51SNd#!SJ%pjR"c060kn>8$@F[I4CSD5#Fj
[C[O_e0]AH]A.pqU\_FEu_9Q[Q+Do:lfAdFC"lk0?j(PdA+g3`=b4)945B.Cg>*rRn^o-_sP;E
9kSNOC81)K<8Ycboa'3DcQ>HiRf)ahd,L2`;Wb"X/;]AVgAg7U>1&nk%e]AT>`g6eDYE>2^(O6
b(n2e+:6F#Xf"VR@9e17MB-3AF,j9(t@&pE!H!*L9huN-!@S'gOSj0>*NOZqSQa&p.&menU\
oh_n\ud^m\a"u,cF,Y,KgkgG5'rhs5.W8JM8$,.7NDR?WVoK"huEpE8H26q'IN<Ns#sG4C\0
oGO]A('^j:]AT_afXHcFDF,o32AJ9i1.D3Elq%G4Z29dmT>iLr/"!RKZX<@4u1N6h>qur*3d<,
)ULqpc>uET`6O?sTLBa$ENP&]A6SM5\k\"WM,?63gF*p1f8^F`R\F(sKk_f>1[t#*,7LrOWS*
6'[.*\5So3AS7B*nn^#sgs1D8P5I'4a3sIbB?qV'(9&NWU`s?HD9%XH5[I&%=DQ$gMt;\q]A&
KZ+2/1eX@8FB8#6DMl`SP+DDqPZ\;+/KJCVMUAr5GXeZrI,H(;r:"Nn-3gCEtK7hcP5,CbKm
<u&t[)b`R=:)WSTqQ).+CSr/D$B.`oar!aCmd'QY:CQ1Mi)(RMX`d0>ZonndYKTt!4U@\:g+
Pd)48&?OhAh1]A9/bMJ"gCuE`2lD,LD=]A@s2<R:K*JC,>'t%k2*k5ne8=qG!brQmO1Z('q142
oL<b.9r-PRF;Moh&dbVrWJfCKUJsP86i%JX!4o!+SlF>9*Ip\M&GFA$D*JY/O.i*8N\=]AJ!b
1E39K.>lXSZ0dE5[.Q_K#9gpU=-O+:.mNNC)Ql*I0r0"7<Tq8uSIj7heK_RM7[b2n0lK,4>O
*\1GV)=nCCi?Zl&hXO+UZpqj5oWE[+mF5)'5@^!:n>t)=?i>PhAOKa"S4p^b7]A,IC!?l(I<-
%qAnIO\i>MLVs:XtQS!$)ggB*AtVo6)RPi^Q3-l8-kOb40=VHVris$nU^.c\_c4o?iCN7K_*
uArT&W`&#7i#_@\2*aVo'e'*(64X&iT>21;n2WKGgKWMXmrJ.KlK.h2Jp[nf6m(,>s3-IJV$
=8Qu8oJ.A5-E'XrDC:#Y6qbDW\f:4Gc^4QGSRC_Bo_^d@,^ed4'\>NT-MBSrrb7(S.QAr#*=
=)a9,&Z)__ioENr,,/fD?O"+I+`%=2;NXW7'AiM+i4R=VUK+=qltSM=7Ok"V(94Van)=U"(F
I=$*DkP!Elr6ZLi_VuGK]AS>WN;i#5do4u9f6IY+\l#<038<B'8#p%'-=_L&A[J"Wog8W(\n'
F6XO04(0.L2I?,b>M/7b@"D+,iWp\q/BD[cE]A&E,aM>5dHhFuUH*Pj<.+TER%i7%VI/f3:d@
D?)5"Ks&`7kEEkdYQDJ;id(?cuPn3n`e!8g#j/n`T[\MldCE"JoATZR<%5$+3l#85niQg0.e
T(7_#q7R_(F/@p.k+H6H>9N")q#&bMTIf`b+N*A;OVC-N2b&@ZmW3Qna(LF`G)i_F/M4MXTr
UqY1go^`.M(T_^%F`M]A"dVsh*;-=?cV.=@W^&_0$\1jn=>*]A!RTQ0Dlq\EP`F-*o,V-79&-_
+Fr9O^Je.>%KMbZH_WDVHJlpj\nia=;&)GNKjs4NSCDJqmf=H7GTpf49*l#r#6jjHLA4p<+'
3X#uhU"JOH.ENa*e-a)R]ACVJgFP*`6,JN^(7)@<V]AX_*Z[83_)R\0%FXCkh7f*4VNmhrp_7Q
A9r`ACj:!-Kb)JPo%ofIoCX]A)8_s'bRpS+_B)`;Zpg$'r1sj9i^uWh.H9Qm3dB0iN^bNrsP#
L&/a'=UF"p9#:D<d*d\J5/6JP.t_X(5>g!m.pU6Kqa%@DSa&o0"W#Op"N>K/ir851CggWmSK
8Q#P-!$eA23\5J?_:8e_n@DU^sXsl4)ehofar4=C:HeRm.a%?!D(^dLJO.!XNmGS]Af[D[uEm
$YZ'p1/A>2<IYNjk.B>//\I2s-4+U2GIhX>;AQ6V(1S42JMl<)cWIg\Je4BG0<F4'ci,^2a]A
f@kgN<;2tZ7pbN/&ub69#i<Lh>,eCBWKA6OiKuA^9i\TYD![ThXd.QF@k]AGS-[sRKZ-GhV]AW
#OQ"NuF8U3?1ji:d+V7Q>EAVk9bVh+#-j&W+oAu^Ss9M(1oActY,@,phPhZqEhBOEV7P$#;Z
!nd6;q\MEJIK7=JPD)0=-(#IMH6E]APmhD/=ad_CXl@jL)<pQ\@m!bADBYAUZd+X?F@Q7G[Ei
AEA*f%_8=BDfmVG52'D%LE/olGj39q.3;fhHn$8&l+tpiVBih=2)SbiSWK<;._bHc#(!#<Q\
:i2hCSN3mmdcHW\9`sP8JTq*9GIH+(H>PE7t!<8MPCXJeTN$%QCHhRL\J"j]ASF3U'RE8J8j_
h0c=3o^q>[:-\n,D6?Z</7fg=JfA]AkEk)@U3L)5EiGR;7DJF\`/KusLK7>DhRTnA!gYb<.qg
?*L0#5phkn'!(d_u^.KO2Pb'tfoIh)Ora5+,t#K>$U7HA<^`Q`tlA/06<K"4hrj#F.;e6@P9
d\hT.GTpbIgLum_Aso*mLa"Ur]A*]ABcX_Okme,^Bsn&F]A/]A+(L1RsnuunB/3f`8-dh9V:]A5(p
lUU(U8"GQR:rP+'3+/TiUBc6s<1]A)bF^uSn@tSg=lH:b2f<<&/u-ObLkflNc.I"49k>EfZkV
@*0l(DJq'8BDg`*;3(]Ase(J%:!C6%UaMuF0/>]Alm7iHL0&ck?.t,#>TW3&!ga>fJbMOMr:GN
40IL!QbDo<t?qXI@uSDln2E+Ark0&e&#>qjZ4+E`_H4"H4P1LL8(=R#T&Y]AO,_t9NQp,*-NV
$0af_Qmr&Yd/G[nTJ^Jebse+C$27H?mQ/@U<Onr(_N,ti;@3%Ghg7B5/#ICW&K-KfJ";oW;>
.Bs:imYH;6@R\FVE.MAP+_i[[/oWP*<L6Qs^MjV&m:0'`lfc,ShRKBQaiRt/knl1N4DdLKc4
Q7-ogWHeGV'onFHbW6\t2CMIUImHB&lk#X-S\X'sqg[9NgCsb;G6/Y:PWfDklIOhaa0sB\X&
7b]AG<(81u)*?FNW:huqj<D@?EkFc;K_a6WE5HbqdS;/k(d,_tY$E+MU2fFpW4*h19RBE1+Ka
(G7[N-g#s*N&uAHYZpV!OI[hcQgp8bCcgZo%(_7.A#c%9(0d.n7h*S63(VYI8&9fY4I*Rmlf
!&GJgoLn1s01K8/=,-g^@KGc8Z'q6SNu^>IAlR$<i".Q^".`1gG(EFU.HD/AL4?scBM=Ip*H
fVqU*4:kjK]AR1Xr^'nlql/bG[Q6*B,gZCAYWnqKPd\Ne/F_nWp,9]AA)G\W0N8m]A1%53TskOK
d6SX;0I(?,'foHB,H\PJ,lnf[EQ[YM*X28>W_?iB-L[<&gPERZe40T6<fj1:XK",8H?6_Z&Q
'HorC'\oJIlR%etSk^#gnhTBl]AJbB#3`5]AHQE\/sV3r)<E*3mas=rSuOpKY.2hq>U2(l73E4
eMWZeC[^U?i%(\'2fPYQD\Ha<g7lN7On<HHXtlb&C+S%dX(1BQ8#[I!7K-VlbJ>nWuVtBie%
Z52F828RTai7g?Lq-]A6c!)LGhGtL]AYFaX?P7[,q"Q"m"D!s#S6&BTN#u<cs]A=`eb'h.pN0<V
jHEYHEjNB#@48pn(TC!NE/BI[:?LL`?7oa4N@)A!Z!B<?PKAe1LV&`[/S8cDYDu9<3OYQqm=
60Ns.&=fhqmN4^/HddFI1f*51S1fU7WJ'W%PS]Aaj#Gu#i`"FYl)DYmS:s\CcVL?ose]AQMJqN
,p7To+[&``D:_:2]A,N8iEMB9BPV)n\H=IgiGoL[5dlZ\:c8<7dZO.+ZiMSkj1nnIFQ-nN9"5
utUjoX-1.^8+_"hr'cC4ZLR(9ENqZimol5rZLRdl"neM6m,?Fh3]A?HFpJ[0)lQEd0fh5OJ^K
"k."usGZABN&Q:PcWV!iLt'[F`G??\_Dah\7>K,r!Qo54G'4b8$F:#g"^%Q"(nh>#frGIVgo
bCO#q,&J"g+fi?mFB=6P.]AhD,09T'7L<VGOaR'.iop-["WBB$]AAa]A73_>A^+1*iL>TbZ02J-
($iS7R,"l'b&Mipo]AN2dVQOm0`a()*\'<aQh\<#W1hM!,+"0D=#M,Fah>H`KmTGc-M0@&ifB
tKi%'G_!k^_=9q-eEIh<@ZIWPLo/L@SR!^i,$-!:e&JP"@*"rCVpnIm<#+!'Bapr,oP(,Q6A
mP)??V<*.rsuodpZ/WWVcW?F]A2&F#BNbSJ5>=Z3CBeO]AO)`HB%"<t7c3hs`.Sn!"l]A;:K/u#
nEgiZ=XBCYMbC=1JE[#pOTc76p!H/^eKT0,b2CmKm(8"VVZ%PMf4T#q28/:npi=GD=%]A&N`l
&8.paYIf%_OQkV@;MkkE@4%RC]Aqhdk,YVj8bATI`D4$#fh-U68Qs5lYpD3=L6Rs4/4`C_,0S
ZKja[FZr`teLFCFg?pkc.="]A-6H5Z#iYo>MT+/NlonP,T;Dd^*6@?(47pVJ(VtBK72R72<B!
\Zda%Jo!Ka=HT8`1=/p>\XU$9lr:[g0Icm_\Ji$@aPUG`TdFJbTG\@AF&78AJg501<a=3hS6
O'tgO.(7Q1T:aHeusRc7rgI>VQ$g%',6TaG?thdX5)VADSJ7;K^XOjVO;dk11"(N$$>kF+g<
m0]A\sj*G#gkk(G;Y0DJ+D>WC.U"5cOXMZQ8nG1`H\LalUbj$)tM;Pi\e%Vi+?NA7l[7*.>rg
U6*b=VZXt8TbdZ9^DGsf(?@AC,JXT'f<pm>QM$/hH%IWr$d8iFc1)q``$";H#PRTY\irgQeB
$h;Wc:X<2MV4H*U3KL-D53nUff1C1l>QY%o`)Tq!>s*&uE^=D4V]A=nN;rphC%3^XsY3<;YcQ
.jl2B!/ns3k2#!fm2-F%&%c$,'%+#8<BQ-N6I(HLq8>K1IhQ5*@8%_aMV+FTXMS2g$>fftD+
qID:KTT=3[e2hDn/t^nGVn^$.EoFQA]ArYBGX;JU"0ju/Eo1DKrhD0dI]A#scOkToh@*T^4.8]A
W<D;_pdr,X"O!Qi_6<*!aWY0A^*-TCjaiKm;]AXAV!eZlcsp\+0d4>JdGN>6QE'<I0p`UnmZ?
e^hn>`NqSQ]A2h:X3Yl2VnD50k&!k@&&!$I3F:9Ee_esC]AIRXikY*AYX(<VD2nE$BEi8XE8;C
$ia?sk$QI7LE%[.[!teVqt+`Zc_%ZT]A^_Wt=.!kn@2+%CMRS3tI.\j2[KD$G)"_>[e0.i9Y^
V#%9#&rGB3X-$olmh@o]AC5_K_6e5mZq[f*F.M_T\(01JM8O#:R;8,]Ak&iPt2,6FF-mj?Eo!_
O>9,)^ef,WM)TIX6ct22Vb-0lt7M0dLp5L1TE&LVs%[-n'#b_%5QNc=FIO,ch7LfU"B72lbE
Ani)>_ULSn/Ei]A3m[3Nqrp`u/kL1Q=2a;G(phHBVCqMV\#"W+hOiK;@9$C.('uN=PNoA8iJ_
cctPo;MI^K(*#hN;5qci>[f0=46Ts:9s(WmTC-$,EpmD;IXCm:EWS"O*B4gV&iD<A=*+YtN_
mEGj?YlY`5LH3<28NWJ_g(JpP.d_U_a:6Q[bg_E.bLj!l\r@Gqa:+f8804)qK^AB#YS(KsCT
f/(I!>I4Kf#Xkubfs2X:fYh:F?'_$mV'WL3]Ao@hpa[/3,&;d&!.8=SoPmDg:[=8+1F:LgI)\
c*l#qm5^)q>j@bJUp$CF`eSbZ*#6p*0A#OU=ONn&dQQ.HossHmL:fY.=Q>]AeG`!.$k:2O#5W
"Dgt'lDPD,iW!iQ9Q61TGtHN9W]A5]A%;r+GH5n>ej(0iBU-#.!WCVo3qa9&m<=QOpG$6;n)9#
DmX4dl)Zeo`oQ1l@GtX>Gsa]AW*a<te0%rW(S96qr*,;F_Cp`&a&cTsChmjtImr-T5GGn:Z*k
E=6j6u%GEZ'ZG18XOqIhV:"&a1F*c,O@W@\@b@cL<'ONh"i7Hjs'1D1)E[Lu0f('-5_H_#Y;
'QoWQBs*Mt@F]ApgJ!EB1na8Cjc$;@^0Ue*QBd(97%!hQdU1R]A!1E&X6fgV;U2osXcc*k'q[q
c>sE3!W>1gQo?t4$C1+XPW)#!#A$73#JdpIX-)C=I+a8@S:g4gSJ-.)lJXZJkDPBh>M(3oKq
s[C0ZjR0_)=5P<71dDYfLZXp6s2d,jX61Z'R-o9#dFM>(hJp;^'#r'7g%*6a297X?;His1N6
%*R\V\FRgAoR?DHFX"Re/g$Wi%]AD1@V1ILQ+7XR'iF`#n29td"`I%u7"oODl8=2Zl%(U^qj4
l:U@bL%sTnks+(k=UrL+fn70Ka_mCB,BiMr)Lll6"/VX-s<lWbj<M-Z5SBW&9ASC3mpMkIVJ
,2_?RuJ>jIG%2Z&%%.bfs5ca,KURonQE^B)P4'gEd0Fjm&nGE(q1>KkZB9MGA6#DpWT"eCej
8%Hi)-L7,SALu3TJl%/+7$_6no&jPC&O$_??n'9h)X*Urr-[r"h#!Tr^2XNp@f*b'781,c0j
=B:n,i#oW."As1`e?j+!E>6Zip&LSm2V)7KNHda_u7!K0%_J?tt?rQnHYDV9bS>0>:.51fK5
W4ZEsY<K2\'rUa.R<.$c%s:"h#ab*IP-BG;pGMT64b%ri.KbKl5$upuIJ['uI!LuiV3q\sKq
.b:>^q5dM[:<mOo/aY-R,sXZK9.\YWX&1i-P-9Y=Q(]A5uo06g8KMX<,\%.EEf#R]Ao4`XIEG^
k&&^oQ:<qla<3:1H>+WBN%-e88-5PcA7!d:qIEX_AL&CjN@ajnK)+Ndu5CZiQ0ssmQq(1Vpf
WD[Xmb%l,`KX:c#hK8mB-Un\qnBj?oc7l7hisXMms54'T9V'FL[ujZL349G1Hk'AFA*D-)P\
@G1O+fUr3s/?;YEEDG[IoU=`YN@^Vi>'jprRsgC>q[_ht^b/)r;??b33W1tDQRIkf,U0ss!N
+UV^@lCCQ^b=U'*J*jbZPj"acPK<J+,@a^UG!CGVnPQ$[)G3*]A8^Wr2P"#0?P+-9IDNl?X-!
1OA%R&1a[,s,M?$bdtR3$:ET46bQlW3%(8::l3m5L;2-C:2cE[u&TOupLc#i#A-`1$`J-e4M
FcpuV`\NXBjT)s[)WheEkkfVYj3:4\n97d^!V7sAp-i8@mU>Gt*6E`Z>nc%]As*@n9:bL59as
4qI"cV<Ybj"`4H%XFE(lM$Q$9jM2l_'6q]A)55V.Tj@)3l#ITi$<1fUoZlh#pEY8\)]AR@QU9j
J=k*'$lm#AcaR(<D[&6@pu:r1P;2Srhj;ltj+!>gV=C=K%60/tW5\,?1F3gq%a;1/W?(aj+l
Aa,aqJPMG2T\8C14Y>g(7FR\odi[WI-V<,qbK:nTBZFdb'^FO9hl:ku%o/RTGO58QNDZU!B1
:t_=BjgLps^%6C*l[4)fp)ol>M%!kNQ@IN7iJ&1Jg65o[<)<q6O0#063YU)&;M`GXPs(SR&-
s3d9@@?2SMWNJQ$.R*+ZIF#W-8i8n$,B?Z7t>kq$sU[#lh-#TdG@Ku^4UA!_4MtV"s9!"P-B
%?V!'jC&ZpV1!OMg<P$Y<q?AQ3+h45iH^G@H/@3f%W.pB3W8"d*a)#KCb><ajLM9K%_1Ci]A9
fZ2mGZb7Ha/!/>pKZk(:(cq&/gn9pm?1Yisfm,%0)GCVm4Jns/_LCU:467#A,GH?]A$DhcD_u
kJ&g)$5.$3V9Uh:Qj?<Nf1e@HmW?>WHmIM#n$\(`BERNm3#<W?BDn*lj&sQ[\QDVAj':ekht
dPubDFf\Qj;OU48&"lhbX\S/;MAc@@i%Jefn,k52eFK5i-Cp49j,u_t;QoKASrUipBEInh;s
+NK/\cDsh2H=H@j:S^WIShta^3_?K9@GtE]Ac9S_1=E'S9BQmc9d;9aP/Pl>`iK9GY+Ab;`&d
G8R^GK9r1,R2/JV[S,`.kq*bUeieN"&0m-i:54mT^]AmmkDf^n7h"n?ZX[GQb.33X!K5jYk('
`Rq2sh[d>mnt6;ZG<$]AnRMCG/#f!NdQrB7S;AN3^f95P_Ffp8YORpJ#NW]A"R*?bG0F"@f1;,
r.4H#8EYXu3q^LYJ%;-3]A(Ms+,bECY4Id^Zok)fbs+UqHXO=mHB?%ec5bldLNL>i<D#'orGA
G=R-Iap\WYmT14ukWO11X(a^hM<JIUJ(jf+Ze2@).'IVQ>Bf+VPlda#6CA/imR:L6gOiap]A`
u6mW'ZB!RF2?+JZSPW/E#9ZKNU#C>fE'#]A^S#IHJ4&p?$,;^Uk8b$";KW2C7(F6K_GX9X!eM
_/;_raB''m!nX$3GZg%a,uI#`]A,4-WNneSr7MSTPe:Q5<3rj&G:\<.cdPoqVB[%!L@2%;%;Z
(Q^DI4/;5a!h@Y+gM$*WTdIU(P),JLLn7,eS8ARPg?V[bPE-]AbG6!qsKMT'(H&?l<jC>;4Ht
FBuKGckLIK$hgA%S4Y[I4#i9:32@?MX5b9Ro=^uQ0Baa'.d3q'WLD:nVdc-Fb$BQci%PO!m^
W0^#'@j9:;:GHG%dE_`fm?RIrhtrfl?"Ed\%:RIZJc#Te+J6U<gS_\KHF+cD4#OJ1jL(3@=i
Ibe*a^%\uK*nklp=HdEg7I0+f-Ggss(Q1t]AWi#0=2:\1YI(47iicO!p!R4%QEZ?.?MiH!!W*
eDR0b`#++\6EYGMrpG%NH1^>iChK;7"!PT[#0D4rLD?eH"-OY8tTSC\Vl[,PLR]A,rO7<DHs.
SEPs\G^qi@G24T]AtN<(SP=m4VO3*,jUrNL9eQ4C.njei>$5!<<~
]]></IM>
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
<FRFont name="宋体" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
<IM>
<![CDATA[<4I'QPAqO"4E>O:N#!*A&4ZC"!Ke'mOCluB.Hqg+@RqAYQ\;_fN#\M=dRYTG]A)0D.q7cTMhW
q]AOfWjJnFmldqY4Ghm[\aB\&Vp\m!0F4pGch,K@"SI[X?$F\qfcKQ-OBg(&Lu>onp90WQjfW
BXib5D_K-u[pd6Yj&k,lI7W584rEP\m-lYan9CNW5<XsjR@XgXG330blD%Y>q5PR@QqEE#&U
s\s#f^$i!ibk\uWqm(Od_'c=63IZ<>43KEg-+R[$F%cKE@q0up%cAQ"P*lqH/p#4rbY$VpN;
kV]A-mWYplB.ka`H]A@:&_$co1/!\WrHi%jYo2%%R?prj[.rs;WUtB(.,7NIk'FE.LElP0GO<W
G4LKXGqWIN-OPl(s6;JZCU/@:n6)XalEc(\P<$lYl&HS^@Bg&<:TpI,s)"gi'F@kb2"em]A[!
t7\5]AO)"k_'6l0K(TJjKFLA=(=>fB`nM/MqqnJ'[$-UEj+1-E.oD-H\6,us.@?AJ&1EDD@r4
:djQmqqkioXD]Artn8goK.-Jj59_o'<nr:43C'.c`\gu!m'=()'.ae39G"_<qAc4O/-emAdq;
ZEBLMbua3#?>UGjQo*1+NF<.UjhlmS&H).nc!DD+\e2o)".EHJtE$35;RC.*RQ[hG+G^Dq'Y
AYn_j:s1>0GmqDE4iLt\a*qbu$pE<;fHETjIK_RcHIShV+5k070NEpOtR3)4so'+%Q&oD_`b
?]A&9[A&@86Hc0?7P_L;7hCP/;+ng=ON*Q.MT1Clr[JAn`l1te2*4?[&gk$NC,-^g^U&"3p=+
n\-lfi;R>,GOj577<2Yj1P(3]Ah?+!K[Q'Tq'd#!SEX._nSRL2^G$!jCiUVWoJ3Uo328"h-ld
Ii<fO24tJr8HOjW`r]AD2='ofK.^Tb,Z-Xpm#ruLj<9C`]Afd,4^Jh8fNtqPU52BOo^&9gI<j)
0\119FrpbS@Q'I5LF0Ml^9'grelVK-fA.@S7C&SU,2WV10^>2$ijicj^h3g9n;5`WV6rYFuN
*a%-DdTpS_U/l.`O6d!6>NRS21n7B&ilGfS"E?KU:"EP`<.p\m`t<Sf,#^O4F+L`R;(1'8:+
5a`@cYT>$oe?uY02l);aQ^,KFXX2T*X$n>d.5\6LQLPHF*j$CV(<XDOAbBS4oX!7"I5E^\Y7
UZ)?@#6$BE4?^`*J=n9k;WhUa1<'*D>Y(fpcff8H[Xp!9"uL<A^<"<hN)j<83o:O?4)+&;@H
@&-Mc=LNC&RV3a@-P1_J*ZGWQW'NeBF)'hHO8VbB"8GtE(YQ"]A33KAB2pnnR-c4Tu+`qLCqJ
6kFT,8Dam(2PXUU'-,NdSLK?2?#W,dc3\$1Ulq2T2d(26(.R>k\6*9V3tJ2_Fs407S@i^%ld
l[qmNcSH]AQ%#gTZH<oUN_[0?b]ACb4`fo4Kmt@oA\<3!iV_OAT)M%j)i.S58amT?C0]A8MrQGR
W8P7]AQTT!Ims99*PueLY)X`RW7OI$l"(sc$&=[2`m)b:'Dsh%+-.^r^`^DF>\mKZ_`4CC1_C
AR:T&:BV4$<(RGus"Mnto>^Js8cWiSl0SU9PuQUA>rY6h7Mid<"h^^I^E;3>]A(\_fO-bT7`?
<8R%9RPEEe5IF>iFN-7ss^'0$qa&7eSi3&EDI[9^JbkmZXeWq$Oc"6G*J,&-an-^(T?qp[mc
b"SY"%]A/4aNDm8g%`s$(%3WICsDac%rDjSLIJ;.R:C%=U4j4B!WC&"riC%0<e#/((V$&)VlF
l;./cAu)]A>-N.AuJkg@fGHdM"56r+$?"q1B$a$U0jUo,FOZiE*>eK%dA>GZ2TX"Z"m(,C\Uh
RU"12be<nRF4R+1hQ<=;^f]A8]AHH,7=--)"X<pZp21#XgG$R/V@oKC7UX7t'97i08L[Y9'#'&
>ef):i?L3>>NH!iqsi>qG<r5S8fE@ARAn&M599NH1L^MktQ?5FumW:*!\o+fF"gCfHe\L8&F
d+ffDGQ+OqNS3"0d%.Z).95mp8/1!IH?+>id:W$ck'Q"f"9b@'^\GhfP-8T,M-hZ<L'#BQL9
"`ITD&^JQjcj6*B(pko;D5F2M-.O(%rE8#,uXt[MuIZh*0tsED-Mk5O(S_nSFcVY.PKIVf@O
FRccOl7D>S3Xpfo=c4]AEs.I&h2''gZ,QPL4"=]A=gb;X2'HTEiloBjg>b@`J>7!gpX3k-r<oQ
U3]A@uJY_Z@T>c)k]A)\c./(Y_4_`1E4osKLIkgIGk9(sXFk0]A7WiN:3@d$MYpZOoe78SI6u[H
6<9pK>F]A=I9!i5#m'#Rn)%B\!=6LBND7L#21_A4uMS-&"?>&h55SqqHF5,"h2.Z]A=&1G]Anu0
Bg%0=a",Y+6NCZ--a-@h&2&Q$'LHLZX5kr<]A[X2qJ<>gc*3meVpiX]A-j<aq+aA!q77INm]AWe
f<01A5rLM?oc>]An7fA$\6>k&@+',j@j]AW<-/hGjoj\UG8_L%qkgDHu5;R#unM9;WR()"qgn*
O:pp-q,0DFK*F?Z7]AHm`^G0Qb`O$,`YN*/]A_u4Zm3C28),VoF/t/..NOf`_>8XFrc_4ct@Z)
_RrTKF35(a&J^+qe.5F8'p'V$FH[p':.$s7TPT5n"DA'2SkCph&Q_ADpF\h>l=#Ee\[MVBcl
538Glms.MqN$LY9:3(?9+)7AgC']A->;Z1J+:`mA"Nqr217I+]A9ToWs7fOH\KRfO"ik\`Nd`E
\(rd7b'UHf1Cel[=V1NmMnI<dH:X3g!$dt%n$G&iXoIt@J@'mm\fgVsFPT7nH#&eD45AD@2m
E8>:0q-qkE&?^UhsMDW9>."_Cc'=5kh=.3Za2+dFq9FUfJN/o"d,!c_dsZ(##'=&>Q,Z]AXf\
5aiP5?:Jgc.s&ABZr1hi8u`k@pKpsPFL]As#680Bt/:DOTB25,Va<(DM5?#833^G8[S64O4r?
SUTXFYa_fR-j2r0jZ[EpBiUGoEYVg:&C;?\Ke0<152&+N,sEhSXB/4c<D(]As^2q9QAefkX\o
nXp=%qMr<f-l5RHmVmC"mukL0kja6#n!5^YDGC%a$_Li48JinH$;$\-MMsr[BliCAdAP"RK7
!3--AMom#0aK?*&`GK5!hVm;8@T$K5Ol+Ya.5M40b`ir'SouVDd?Wa_1((Vr;AJH%<;@#j\^
_HM62\K[7b>24B(2N@3bIYA^c0Fn,AfZ5Cc0?3T5]A=%bTN[*&aZTUtS@aA`N,u"Fh9(;pDoH
#d>(8@8/DdKHnK:miRB4):I'V+3CGqFH8H%p2cVW*$`%"7rp1Wao.t.C)f`l)r`t0NNTt6Vs
-j6G1-Oa[i=NBJh3j4/:e^R?NHn>)%JuE=%-]AL)3'nID0_R@RTG+V<85cBV-!l#t*METUr9[
WOX`u`pUi=JsK4.`'!K%RCigi6p2<9mMgSS<H%TNjBlo#?LBbg4.;:$XkYTtPQ1#Qe+aMFPW
?1s-BW/NBVV.plnm6(9W+>$ZjodEJ$4[ZDDd=?O`b&3T3NV\%k4F#!)]Aai3d#=D_$7KC"0Yl
!!q(e"qFB%(>+^'8Y6iNY:cD13aDg@\/JW-)YN`j*"dBD5*&=/RPQa``ak_I?EMnh<E[p?#?
,15>]A%R%_t(/\=a?P#C=K#Ro$2KSXNBIcdIaa[Vc1cJO+bP7FqebjTd=f7E(2&m='1/bebLs
Ta?aV\rLo'(&YW)Sb#970.'^'&Y&Gap9Pab/<K=,k%M3+iZ99sB<K%2GLFV-G&/!XZ`\(W0R
tqLEj5&U&tM2?*>r^55#ZlW%"DWK)=]A#\#6WTrq\i;G&t6,1e%8`Ci'(&h@DH>U2koB&;Z#<
rC"9X.gJf^*W$"GK,l)dKL2cI"^dMGmi;l7&;+_aSD*<Sq7B#BJ7Ba\,">#aLELeY'60O8s^
&/VCChCVdl]At=gbOoo=n,A&q5$>P&[=3@>-uFJ"G[oAbeCVDi1<OTUq#1)]Anu!g\-/n=[WJR
eUUJ97i.0i<m9,>[N7XZSH8KtX9nhl[sH'_gt*3]AcgkK+J/^Xk`cO83ZuLess5#S\[gPl7R*
gF/A:B\jS=2[^U=+RVIQc!C:eF]A!j=]AQRh7Q9OXuQW8u8Pb_[B:PYqEarK-/dQHTO/<]AWGk%
D$!`S0f@"8]A$CV3?5\TX)?qhBBae]AIUHcdkfptHM:io_^'!"g9Jlqn="=%n$(;j(M[tfTM.^
?c;aJeH[*'%)\Gj:J/i+dm]Ar5I(kGIt"faBs2:%OXe2+E:^['&L0)?7d"NJa^=tM)a>2gq\K
!L"\ZZd8#^s.X3(Yq#"lZ?e3-C&G]AaNac"(A&4Y*I<3DrO\)ZD$P6:o.m44?lN;f#^e-ML+u
ougNM8abj@uWK,N?m`6pdTo?F[`**UAlES/Th3lO%b@3fISU<R5u3_78#[D%>FjKoTba!"pj
;#oALj[GH"(t7$!_,GeY'S":e!hnbDCP\J;?i_=+,7p<1.sN<bg#GWeK"&\hE]AV3Ik-V&"NC
os=OI1_EKk_bF54Op/_6_@#_A]A]AbB4lFK$Jfq'UWU%mf<q5BWtoShKpX3fp(!9TT=R/>NQ?F
i'<6LmmF[6d[hfZcrBM&O,U,HsAPHAM5'4%h8DZ9@=*4>jM!3:<R;W2;PuV*_+i78^<!e'*i
"e`a/>"AqCYs.h_CqHu[EeK9Xg;>-AMsSoj&\p@1BYgt$(Zg)RdXr`0e"AJj0kZ@#!qVD(f#
5?q[<iiq0cM;[qGaK6#]AA=L-%u#:-1s4^9[M@o)`m$2[B=*_^M6CD6%nC\S"#oV\>VP&l"_$
F:[_>LZWZuEQ6L[h`t'J<5L7=9$9;[0<6^,:*Kd3g:UqGL`Ig1/d[5D__BULE6)o0\fu`Ae)
cUr>_":S1P2gPRmF9MhFCuGTs`6UkHB-\U$[IED]A]AaW]A=Pc[Ik2r+IW:u?X-=:_7(YjikR@$
r^F-4JSL8f*1g2P/`o[M02oCtM*3L_<EohDAfG*;[K@Jk7Z4m)Tl1KP&WeV&<;TA-<ldl<8a
1ll.KoKnu<'?K'qOXP,_L(F6o-o&CDRLb.Lj($/doD"!O@.32Wl/^lb40%QY@XJ1f_TY<S(%
h>mBQYdA9,(CoQp7Er?DWcC;)>;dDM;N@j4+PrH5RJ_t7C%-:j<E*$(/sbu&f)gtm]ApV=[*P
)fK1Zlh\0=1k`FuJT)s!j?3B@G//]Aqh\m*srl%9kX'T2,JS/@u;9f.FSUXOtK:Hu&=tiAf>:
;"Y/*T_+=_Tce[G.A&>`F00q)O8_+9"p$lBU)Gg1F8=PI>W6[M(k]A9YJD3ADfnp#=[X^]Aa]AD
an(I2miY*<XQ3M\g"!4%>M-K)ZADO%=aPj<.TuSLh"+LW@A6Ekt.soJ<kAQ:Ug)M_(VS,7#^
.WO]AeW:/J+H\HP5l<,\!p1[oS),sU8_f=on^Ek_fBghIQ`$iJ]AO1=[]AnSYS;p%>3WcEim2aC
/QVb)/'k*'p)/e$D?`[q_^EM:90+>OUHEs\?fnt*Jl2G8Q#Qhub(;_&!#JQ97mbP(kbqmn[9
[XDGD@TOZmJh)5+YBO/$O`aak##c"DIEJ%G9ibe>i#>45DTjKPd3e0DOc[+=+=i36PnuDsKF
N0YNA"M\@D4s9&r\g@"GR`>e\$P(eG@]ACQd2)%gRdc;Us0YN^!k3J,TJl%8Z?NHhYUNHPH&]A
VW?%WfH+)PqY1QchSTa7*p^&-'qGPK+hP[[arXpb8mF3!%'d0s!HnZO,b8,!f[V!jd9n]A()@
UC6/c.oiPN&*S>)R(CWGegAj(&a=jb,!EO5Ggi_B!'15'\"Xs2=&^CC"ofpR\+hP4[0dJ(U'
',b=E,Wg`F:hh6G4#-.9*OV0R=Dp+hYEWO$TN(d.jB%d_\V?<5eu$,4W&3Z/A:(E)#@Q0a"j
?o]An+jNsG_X*1F<E>g1KN*4GJ,5p!\,ADA2I;$!EKMH^?+*=27^-02;O4F=e1Mt,)=H<L;A3
%nN=uRbUY*%;b^FSJu]AL0^q7b=DuDH^=WlCO1O@q&UV#fhiY$Rl.Lg2h;;"bnh/[hcfA;M1I
_E0FpM^!>EUU.)m7ajeNdca_!f^1,</U\R?\O-AYSlG?<Ff;[FRZ6=P/M3I>gO'J:<L`I@NB
eJWj(JiQ+DbiU"`\sT="hZE'nWT6<o[@i]A^>+%>RmOQE3S5:4IKkfO%C?#]Ae$6P5/l\]Ag'ER
mGRqIuDh7rXI_Ied=@1np7O^![D\k,j#5Y@Q8J*\TCn9.>9r,tj+H25Imqpr'lS/BKgUYjd1
ccTXb^=TQA+a_;P6.T(uI2Mn5EBjSS=k1t&\Z>-)BtNb*$JT9fj9)@Z7!r[]AGj+tMrJ8n7BT
=bJQdYXJEULD_s00IPWK38u!NpQ%]AA:!]Aft.5^mF&/(_HGI%0s4;!?OE"jERR]A)<]A*"R(=IO
S24Hr:YaY!@]A*k'+5fbB8$A[?sB.eV8Z5P=o"9=LgP;1JX=YdLaq5tm.UM]A4n0#kkJ/aJeu`
l/q0I`Y7\nKK!D1DTU)O"E`_4"a)'9jq(#'\U=YR1XT)ZTkLs(tuscR?tldbP[2FS#[%gStB
Y5FboASC(cV.1^*>(CF"gQ_'_ZiI>W&=/mS\d*=W+e$P&c8Uf_fkL'-tj-IhR-23,WKk+Vuu
DjA1uE<PU,*(LWV]A.^&ead]A<XH]AH]AK=1Mih[0\1CbTqZEESlmY)t9%:`(Hbl;s$T2`dk1Z^&
^8_ia3@s2Krc18VZ&^H7joJc*KgCN]AK[/N?1Yh"e1)A!gen@`D't4Q;aBtrnGLPC"bgai\+V
t,/g5e]A0TR=:7lR1*&>5C.NR3_ZYKsUANFeLGC7[KAqrK_l50@kGi@pjT6$^;FCD3Cb<ER+H
mHn.d)Osoc]Aum]A?qXV&80sPOZuGouQJN#(.M69JN#?-KIP7Ebrb+RuplfQl/JW_=*Z[et8ad
rhgbI4(C=9F>ct)/`)7oN3>qBkUUX8ajjlY:hCn-RNDQi\oLTRgb+Cm(cUjZ$fkH^g?FL&bE
o2W;5h-!Z3X6C1jl$)o?rHGH$o0MsO>=XaiUu@'&2Vpe-6t@Y;W,#?NC?YQ,_nYB>8&q(K4r
'&*@)d6DSq2hTr&-f#n?tJ'NS(_e=U&,WhW[M$$*Pc)WS>8,pfb2?^lP]A;r-n5d4kdMp)WE1
["Oi8'nr6I@dA"[<;O5a'!%tu8M<Fl^1s:+2V(9`YVg\(F.``*XY9JltlIY).O0)T4#EJ521
%)'n.rs8KI_b@=&LmeO!3oVPFW_nMCD"X78.#6l%R7#gaR\6A6;S3#HL-\4,ur`iqVe&"r5L
o1LLKi\7GD0poF#'@=23aY.ZAfPLS_;i.\q!42=G8&\@tQr8!SGkAq=0D]AqWJ/7binUD7qM+
rm4?$"2PFRiffA+H4^V.+no8+TLl3V!UofYV<Wq\IR9rbl:nJ-.-K0$@Aa42f.:&.QWc,t2m
tk<JSni7$WQ#pe6A7B&iSI)r\Yb[-^3r*q5-GX4U*rL2#Wdt&Nur1pt3aG8T2A-[qe```''1
S3,08jRURodJqAMVF$:C9=Bg/OBGtCR&.<C.QYm^mKNFd9W<0c%*g%/T>qB1J5D$hd?k>T.2
%+p^g]AdJD/ug,E'!Xo7n_-]Ah8<5?HAcYiJ64JE^KL)</Wu0r!9o]AM^qNBZEbO^J%[>A##jL-
PK0YujRg,NP[F$B9@1(b42*O\/I3ibQUC-TZ1eGJFX/nVn\eXTMD*9=]A`+#19\F"kkHOO[Ie
f6\:%2V[KjL#5mFFn1UCJ8T,ap"LWA\VuO``h^Z>!Cp_$[e$ujf@0EjdIZkCQYe*87WGtPI\
G*I1t`,[aF:#,h=a.QA3:Cbi`.bm2iHjbr6-$2R*L`5?;nu;rK3m(<q4YV?rrU:3f(s>ju.f
Bj3QP#LYEOO[qt_?i,HRCs"8B+enF3r)<)?1H$(&[[)^Tr4"20h]AHXMp+#8WYY+.LVM/.GK>
:-N*"'$F+5EFF"&?Wr]AE&AbsBFYRHHoa&L?jM]A60Pru@nID;6B>mAZA:7oi^b`g4m^]AlZo/m
;_>B-PAW(MA9n*((\<N3V,J`m[;\-\5L3+$(MfY;]Ag*:^F]AG^F.f!7Yi4@=>$IkFg1DkMf":
^0_<H[W\7re2qRs?c`%"_g>Ht,G-rp9DaX8Dt@7^e/jI:b\<:X^?k*M++hIMk=.Y</^WOuMR
,&/+ZbUKFSqpfVt7!(6#7UP\_Cm('LN-&VQ8QZhjTI]Ad>ncmDWV'Cm)ka__3TKP%m:GP!J6J
PP8@3_k(sd(,T^TQ*Qk3X^0A^2UVmeEqlYDG1ctF2qmSYNS/M<K?*W"'o:UNrB^QTq9@NB*L
Z3WdN4+3rO8Wm6[CRs<BG*hkF8^?%O90<X$\p&:R9VaJN@`j"mk:2H`S_rt![t&X*#$fE'M2
KX&^u/lnCs;;G5b3jbcu^hM'X4i2apieDdZ=dIHLpq;W<?/jn@8fISl&8,_RX0g_jM)oj,@+
WM1$-1+0ihF0qWg8,=D`^!lm7RG8K`/T;SKUt?KjM'in(j4#0I)[Mq8+b=61lJP`Xb*W/<$g
#K8FmBJD'-"dkLF#a1P140j<SY9h%J5_S*4ctB_M8,FQn$g3S*JUC)KZseie@jfEJiWW1#2C
bGN2!0LZU[Jpc?oH,o%\PFc:>I8(!SSD4G/i89o)JJ)tH?)tXkPIhEb]AIlUl<2Q@_K^W3pXX
FJ_.,Z!;0n/V;8M_fq;(u_^-V!dr5j")2EiKFB1E/1f1%?F3Mh+BtOcgE]A&QH"k7=f1+P@lR
PeoY,P2\r+0<E=$RXO\#:(7gVbRj+?AXN\%/<kOYPNMloFn'BU3[^T??_,o"^`mW9s.AO4DN
]A7;2?1OGClq+S\:&uB/X.]A-n"\9N,+Rrc?pZ.-I2M\F`UXF%,i(YEr]A9\queli$5o/7EZ"`p
*[o%O(QHn5EN$./nOdPbjL=P'lqEqP6W/5`\P;TJec4SJo'Jf9>3KN?2:&jDel7A02A@[mk#
,R+eWWgX9U09/f=;p.qfJORaYbFJqZl?6;'25K1bJZ!r:(9$Q)!D#<S$m*ojhm$V\3Cu=U&D
#EYhCuoInD+ea2!k*]A4O:YZZ"8S<TCcjf\&ZW*sWte`b4DTr&qV[BP=EsL1ht1`M[M\?h6i2
f)QK-lAl'=!E]A?.G?P,FmHIhV*-CMFLiJUmV8OqoTk:%%Ck!h4&OiU/8tr$lH/;+\WKO1=:?
)HS4KVgZ_3]A8lWnpe3Ud8`+:SIZF[.W/X%?e>,@!c`g%M/mu=0Mu>ddZM*WB,'W3^A=o)l*J
_(2Ml?ib7@'?AOJ*kAl29O[Ka*%6f3^1OltBBN&B5h8UHWB;8Lj<jU.:t3a::0.q`Ot.S&e-
-^;VbSb\Jr>N/j>Tk-rY8kGEMr=9'jfm6\E@_kVqkp'D@=e]AndH=kEH]ArqXNaDSO5(!:StTA
7,#CL'QhA7A^ob(M/$?X&B8058K@MHF8rT9\0hc4*SRnQPFIR.c*$Y4Q1>IfBh%CK5U;PosB
Y2/#[%toHDB#Wc(&<r'$-R4h:\eYDlnQZ1W>mA:>uBQ[Pph<)\=F+(sZu\*bOH8IiTC/(u@d
:E+>B8MZNS8j;e5N)RYsDsf"3[BdSl\sgnuOs5q0C.W>#;4"<)bC<DY`Cn717WuG"1Y9J!9L
O/K?qm<t9R(r,MkMe'_&ZZP[MUQ,+j0lC.?&B=k?Rld?i&Okf7%>EE^6k%!Q`A#;.&_h4IRk
Q*`.Ff9H=pMWA"Z51rU!;,QPG4e!jbpLXM=T&NgqmlVJZo0bcSalB!T,pr&-W'>dEg:'20uG
PP?'n4U`pL[g.DBQ@[k^V58;YU>9^MAUJDNuJ1-;nH)Xd\(I.dD0(@R<UAh%itoIRMaAMftH
Van^4MWppI8ik]A>K/H5\(KKHlYM#Cblr4&8]A'C0H%QnLi^!Y)O0ej,7H\aYn44N.1:(Oc-b_
".#G%fHm_ImIV&qpt2+Okr2D(\II,ml&.YOFk3=J^;^,E%EW^Gf/90"`bB5$I&X:"A5;'H5.
6;Wh-#'810q4nEnbofc'7Tf31-pX^HpEX3/O/E$&@1^C3<U35i56+WLQF-^,(<_+8#q%(FI/
I>+r^D-gJt3X!Dt5=OXDKaq^D;eD[tN]ALQu<.]AA>()"REQ>\'H%fVES[DR7fq)qbsseY]A/S@
k%9gkJYTW[Fl[AA<*;XoaeaTXa2JMMHS0S:oqX[`B\19Y[`J^)B2iT]A!2FbdZ6-6:(h'<OF;
d%NkW%\??pLHB1$E-SB!UQo_<2\pX#'0`2iG\C8c.>j6jo=bu_n+R>.*2O0s$Q/sB/oJUauN
lInu!_EV,a^^WcsCB'N:(m0\OGDPjqXS;7j2?fqLUTfD&ag6e-CkmnGj'&V;IW7[!)_.0&pr
HUqFM@_(;"=FB%bWrh_?0>k^dE'JjNr0Ko@K&3X:t6cQ7i8Ga8PKHkJhAZk9ifP4;$/nq<:'
O4Fhgk!:U5O;BQ[bnqAJ=T5'k"ZM0U4'hCAZm/Y"!>?nh-L-mG?;pf]AI^!oNk(sWhL`B4BQ7
kg&sd_*K;90Sa$l&lS?YHnCale'u^g"$F#TuMZ6bF&@k'>h5N*TY^q0Q//Z+p09Pm>8M0-IP
c;:WUfO-W4[g83[rX?4OW8(jg'@\`>"kGqI2KXYTO;GW9*jYkG;eJPbkYGH0nb8Stp)A")Ak
R$L`h+;O']AbhCp1]AIdU*GEZj_s"tH@QG_*<oKP8h2uNO5Sjf(/3<*[`IkbVQk>DKQj#Pa<V3
*qIRUR*lri'@JrooiI5U'7k,@7Ouf0U."#RHXQUO46G:E?4I;WT#CC3M_LBJftd0R<?NnB]Ad
`h&8,QWIh%=dUgNUo^8HGq2'HrZ%E&So:E:dN*[J&mE$]A/2B$VW`lf"J&*pW`guu`;X_6=fV
7b^sDU'LOqmDADh]An:5-2t-QZoF0Me-RuW4&_@G>o2qm3&X#<Wse]AQGM*l!@ZT=sca:4q.=*
DIB1OG2f_)CiaV$q3Mj#djP/bKf@RJUm/^aY'OT9hW@gY@d`!k2O^t9TC`e"N&pE?V95H8[i
LkH(f>&;+&IX,EZ1s[N_L!dB_J^=kX\[l_GgFha<26i?ab,^P[DVC4#Qc+!)0eP-eS$"1.)2
3(n/VTDE`i'f9D]AVs:QcN(p!c9sbFq$sVN%Ig)XLj1W#GnBQGIbenf@m5''0"ICp]A"tifVq)
ls!#LprRapZXYKQGh89\F$j*6i-,S4IgLI!"pZAWuJ<oj&^poR)mj0N[aTNY!*=`q!?&ErV`
t1*T3oY0]A-$^mopC[s=G/GJ\29;C4;TTD\`NMInB-IGE0q]A=gFOJ1KZZ'Yufc"g0Oi?+s-Ta
_p"uR">dBY$YG]AQ"T!+(,@YJ]A!Kj"B\8D!*s.>91%3kOX/^4DDY,i%M<OM.4G$4Bdm.ZtGMe
&GAW'F@.I_:GVr1]ACO<41?%4$Ej;L)pE1RZ,o>TGDC6gmZ^V(n_la-?=p)A![(]Ab1SNDXG^B
ah`3et4U,ekLLJ-]A(M>=DEA7L@5"m"HJ<R2ZK4/hZ!2M/8,^X@%FaAO^.H8Y3s%H$e*8aHCg
ME-N2@:;R%7+OiDt8F`Mn*HY!UWJ\P!4CR*UXo;Ei=$/eI,r_>'h9N5%:4"M81(T:mZ]AJ@d2
GRPU6olL'=<hpO/<u=(^ZP?BM48q]AN;nQ_&R<t<`<D!3ZZ.Xj=[rtG$<[^.qk&>sQ8$po`9p
\H3O,uT0_55d,[_6Epr#1\/iB\ib]AQn3*0gB@m[nGf4^aGJL4s4=muh0p>b`2+jBbjZgCU'f
V!SqGRfKJ9cf9.HQ.>n#.0/oM^$(3W#ugpJX%ZH>X6CU#)'JQm/2XPq.%%5YTjGWImQh?>\C
JDor;]A1R.Npbb@t?)eE<$-p0P;maZ+^>U)V!5VpM#-V,KZ.k?@X@kn':_dNVm2P[FOnVI;*r
oHl'`F@-IO#JV-]ApfhqJ;#S;h]A_37d%JHCa6E#UpMidJatSo%[lSi^]A!jbcKh=tqG/Ql8n(p
.!*1'!XZW>(."pet,g=%A8JTciWjcDa[uqMQ>n7]A6N0r%r-'/mMd5"b)f!dUUc!CI`gc8#1J
:GCT;$?MS<WAWm>=Yi%e>i7<FXn61[EKIb)r`dCRWgG`)If37)UBAm=t9^,Lb8.1E)E@lm0M
l^Y^ZG,_e9LQ)*s.A2T_n#G9J75\7h?@V_$)&[LqgN3L.(/:U$AiDbm<iu'[s+d'i%"MXQch
:u>D6H,ZU$,j<l?2XpkB[k-%s<YRYD3;+IEQGS["(ZinZ3if5+I44]A7be5$mfU#Z0:3:h^kD
)h"0G$hN>!%=+8cI.719ien-:dSn1[44u:8;@O_b.7s(HUCNX7L873-4L4bpU%Mnt^pg=qg[
GK_qJ90b0-t/gCm2`b5C@J3kI^;";3.XD_J\>]AXj`.0=C%6uS-g![u482OKN!I$VSA6f=>f`
%7Y'6;/pDOF(^)fiqcQBY<fQ/Vokm;@D1\!iaXZ)ICR$JKDWcf.J,!Eb9cq5rX3g?AK+!pl[
Bt$6r@RN-Z"3%JnZYFs!]A@+Q!#s@+PGS-a`Pde.ARH_=Yo4A<4qMFuY$<f,=$]AKVD\B0ef"b
/16Mh\Hj$=ub#aH=tAj=%%Zd,?ceKX1XcaoM>B>UCmo_+fE:(j5N5:&G#C=ss[q-h/XPjJ=I
<:DpuOj`&S3j@PCR0=kL.WTr&3+mUeBhaMotdeos<GZo53l:>3_=%:>NfX@bo*rpqi$6_Lpg
pdiD40r*IV((Q?JuA#PM@,!go+1E\Sag_!85X3XLO7Q3#t_gn)IeYN/;..Tph,LmH]A)!&L49
-[O6MYbX@@t+qlMdJPZRYFjJ0-$69JS"?V.%:)=,UTF6/a:kMs*CG!pZ-O$R0P[W#ia\8_=o
L)#o2nbm[1%E04Co868H:XkF0/:$)CTOBV6W3OerFl\+pgoisK#UKZdY+9a0!o^5FEausIEb
:e2g1AsVBJ$sX"=KZPJfg)+><sX[Q$k2UApP,6&b]AfR$`8a+/W.r`@VbQ^>bKaF5l\7iUl,(
(piQW]A=NYGI:r)BH]A4e-cQ%GH!:0euo?7G2gN,ku/HCauTNXJISp65jLd02NHKPpTs/\=jT&
m/)nBd=Ei=OI\">KPNr#fXO_4cX^O>j.GER.>jg=X^np+=_K535l(TCO\8$='qZYVYEh-^gp
'2ko8\&iZ%5W]A[]A1?lGWW!I?p/l7#=8]A80^C*f42S"XG6a>kT1om-eSi#^)_<)VO^\1+Z2kd
\VVVmbD?]Al&[3]A/\BXc)#J7ZD6W-9ZZerul_>Xs>FcZ69CN&m1ga3+hCf$T4f@\8`-G(Tm2A
ST)5t(7Lqt8W8&LV[K,j#l4ScRO03<lgqhX2"@\3%q@kajJ4mWl<`%Ct:N"+]Ad's2>OtP#3=
GDejG=f%n&fr6g\kju@_>JD8qhL4k4JXO6ab6Tt?\S@^YHk4(K,]A@l<C&SSA/Ik0Y=5^Ur#_
/I)HZ8Hcap7!>1J-ErV.N-B<IVJ[pSfn.kG)>Oo=^/9S6^1I:`/?W@e$:FbIQ&.Z:\;^MGX;
nl&b72X>[dT2D]AJ=g%f3eMC+p_K*m>VYA+7@d?)W<GA9PK0`#$Ka,rU-8M`$&.f+<70%oZPF
e)')Vf"oIW!3#IOb@^gB_eXlkBRSAJF9)A_Ve<s2-0+a-QIDrAVs=Xu,/rKaUL#=#RT0_SKo
bfqab43.F!li#\@/Whk0Kr+&br:5$=DS)q<n[8.HLdjM0Sa&_p;T36<4fB&o^d@^(!#1$u35
0519GSN-6qMT-76W1`('hDc'aiH/uE$9KY[!6Y8me!A=X1/6F(WP3Tu;9&B9os)eNC.WC_^f
R"Hcjb3/Hg8LeJQ3\1diEE)O(doWK7P>iFbVOE2`':(do=BpG41IQTdNuR:Bd<HF\9)OrWkC
BIe;!utR`_toVW`)T>tM;n1Co46kP;DR?uhp-2u+[;oG4/$',b6*5KBU4N+"\geJ0TJb;[`c
1$@_f.283/`helZ2,#X7]Ar^A"4\C<2)oS-!X4XNL[1loK:!!Mhn(rhjO4u:1rD4b+lH#ejfB
_Ngp"t6,R`j1nS/LA]APMZS7Dpm0]A]ANcmf1*WA.F\6J)A8:Y;k?aoK*tJM-P9XA.-kKNoJ7CM
6>fIGK2fSsT"N&c>a+uu&);2VpCXU[Yqi-$oat(Bm2;\BaSrVBY2Z"B4k4GNq`:R[OUS7e&h
nEP[/If"S4JU#2daESN#O@Z)_9$Hm0I\Aqp)ul]A:;U@CYbr)T3>qT4PghF%V2S9SR=X*Y"tV
Xt#Q4f+2gee/`s8YFcp7gF<ELPbf('&q%b6:->K.8+.*'"U-RBN.n52t^J-3K7O,$.N?qG9P
l%:N7]A$T$fi<IZV`#`>/jFZ074`$PmVM%tg&Ne^1L"'6>aN0Ln7o2[&7[qgfU&DoK&?iB@ZN
J9t@E[S\#e#K-inB[-.5TH"S\sGT$l#LW?pEiHn:Dtf;X?(WK!1_Q;W3G^SCc/3(nR/P.=(S
iq@XJ70SO1bkji03>FWkaRpF<TCMtks!^eEo7N9oU2F/Y0?sTV_C"5cOHLA/18)?H&1n^4mH
`WilJt2C%@/0YDEqk/6DXI>f)CT>Jg^^Oe#Q%ZtP]A34pk@L"NT0KEOBPFAi@K_)Dr(&NRnmE
KpdSXENe[jSgY^.sJ@PNofs1&u.PRO0LW9k3br(!DlesdPC;4"\#$>K#S@`O8BRA?/P*Z&1N
e4WI@0L;]A%dIF9u/#tG/cQes5'qCXhm,e'o+EoL%:6q1?A;Cr&3`(d;p"Q[LO'Z_ebjMGMW\
4_X[X4<@/1dR]A.)W5fL3#gZ2RuN2#4(/Yc+5'_G!"B!RsM-^cURta`8BedG1^`_+='<+^*$*
l4U+16Yb[b7[[D]ANh@Drp1L9=k%g&hF-X9cL*ZJ#)g\3fO(Oh?@H'rRAA53X17/kN)JWF882
?(f6DIp>RDL7j$GIN8sIT2Pi@.5CJTNm!1LnEg9g;/So6h%%E9Qj\FeRce`X.E!bhNd[4qE1
b*dW`TfMia?spYRm:o1a3Hh(L3]Ahns#W6r%1_4K"b4'tm#Q:?3,>FRe"V!B+bVT]A.jfN9a7u
,]ANC0c)kof5t'T$C^*^B<tr=TRFL<8*oUU!-HhsIV)iRtJVeP+]Ab<f;K;*\c[teIWRqI^XI+
cHm8fa\jP)`[.a'Z5so6<RdB0JQMdI`<2;m:^Z`Ycg+=A=PC_WjIBY[kfRTlWG.9Hd+E`&/D
dPfJ"N*3+rjCT?Z%#CM27U4"\1eIj\&B<n4gOkMkQf1ORuCXZjLGltmm.r-jPfXQJEl^-H'F
r-/8'3DI`C\5CKC/M@j<a=Y7=@nZ0)n;Z0q4fp4SU8KP33I<u"J,e+/(QT6NS61;SY^5d*+Y
^sN=R"&lV\IP*4O)H/C0S0[q8@PNCeW+XblDS*JE[t/9)_9*jMqTk><YqE>?(ZXTht&ps7Jr
/E[8!B^GeUY4%BISaiRYQcktrb<f\P;/WKJlXaYeTjuX^_9"Nei-K4H*)<#:*m@=K;f*ZY2o
gONn;I@]AOSAg.75!3f?FX7sL>6HQYm_g\<4r<'XZ7`3\5\JC(^C6c&42KtdBG&Wp@(B8QPSn
ckqhf#N6i]Ai)-Nn\I:9[9VuG->3suC/%uW8Lr*$k[lke2-?IsQSpd:<eoOE$4/olk$YY`7/_
sM:50]A$`*qV0R-+*>]AbgAp_FOabP>"+]ApBgQM"Ue.N,K$&^>&YqoM@#Z(+jOjC*k@_ia3.;J
#MBR$)nn`">0\tXP8KbB;-<PTH`fY_@5O[ATQ8>4W\86(ua5(h[n(T*Va!<)&bf59n045ZW2
$obRD65/`<0*h\lEp4E9_'[5'FlY5MgF2o$51[_Oc:IYG;6s`1&:,gB8M2tl0EhDnV2P=OM5
WT%_c([#rh]A:JPcVXS10mfM[6%Ss.p$/I+:(^TLD$CqBiFm2,r9l5qc[$:::cYiHp1guCCoH
e=]A_;$WcC2SNB^d!7_YUYb_%R?',5??Zh44jFT=HBmG7&;ZEb#Sdl_5ObCFK8;Mb%\fbTo!6
"RlqhkO9uF'OnI<Pt6TP;^!Ng%ibdl=*Eo-6c1-)%K)Bo\Xtk`K,)QbEUBj_Zo]Aq6L+rQc\8
2$K<.=3<FRk633e%f*?U:M_>Z.q9ckWk)C<pg*;A*JD6cUS`;EQ4)1HKYcb3%a-KkYg'+9\C
Za2-V8tZVlN9[HKjApL(l<\MbUe$ZWI,+_K!uNZXIS$"-2KZ=5MK)9F1th=k[LI8J=/#4.TK
i`0EEF2fE;Zh#\C6</*Pn$58*`O*ZrO0ZjqJ0@b58.g`"ddA4uPCp'n:W7i<QS=B*'.H"8$g
e4bpsJ]AUsl+=$V'"M/0J8X-5n.>>It%'b3U<=!S@QdrKTgqSgc;=(aYkI\OPt.?Ae]A-HU'uk
TJJNq%)ID7I9p(CF.k5UYhA`IDYfRI79cW1\0QI8l$RENG:lk-Cjp0)0&78aR#H6I%*#n=\g
M#VEbOuLY:$2gCJl,7aMoRnBVl20ar)aEuFP)(uYO]A*O^\CP0E<[^0C^bX<6L4>bCT:1WTs>
39?lW)eJ)%H3Wf+B&lL/GS5Y4W$B$L-!)bNp,d3N(PQ_uC`G7pldQeoHMn9+r+<<e&ocebrH
fp/O^5NZ<g,ji]A:f?-?@<>%Hm*=$`ZT#q93o/%f[R697(2;0i#&(o5DQ_9b3n&M5:Za7f+"-
CY.d3UEO-I/Q]A!I)>HZK>-D_c'ElY3EBHYrq1BeKV?'0\faF1/,pqUja?BT?o)F1+!+]AipaN
0MmZJ=&^mHh5:MAfbaa>\oCF<_]An&QsTP^jls"TgPcS>q`R]A03tN:gP5EoIK^@D"F:j/PK43
\#2C<\#4QENsPAUMp]A3A+;L5S8skA`L$EZ4r[FpnOYGR2F8JFpN#6^)MpT]Ahn9d=,);a<_^C
4YPOF1PhVOY9GRtcT"=9q^VMo@3uS1`kHS&@@&,hfAdOb&,-pWLdW&n\F<CtG%Ce)?DeYq?S
b#F0D[>/Gu:i%ds',kFnGGWN<J5@5ao8o[9%>X0nR1G(t*5uG6V@'@PG>(3Q.eq'S5Ujkj<e
Ypp=YlH6/*KUEB%)2H>cJD1*ki\>sXZn1joD;EP7`dX^)U@-NLK*;%`;gkC+><7[^=>UYIlj
1o"<INHnu_N29BID^AQ<;5cf4"=E[hr8)/8q,"<f`ppM3]AGi5i!(s^.r[675pU6OYSG[JTX4
)!Z?qP%Xgt0:[j`F&cfInb71"A`G9YTMBbiO[(HXt$%I*'heURAD=hHEV,D7sP,73IoWehG$
niWg+N`(cm:hKfaW444h6eqt&!Iq>\H;LL8(i(3qfCFb;JGqWP0C%FZ;,CF!4[uE\G1$,g=N
GqHV-I4.OXGLB85;,r:D2Eh\/*[]AaB;8$C0G1LQ,Gnn?5*7E@4*IC\m3GF_??']AZgQT6+Ncp
t`,EL"5=2;F68)nma&q#6H3`uFglJE8p`(jWE/ai)gkDPFTd]Ag;%1ATrZs'/Z6?.lKF5KgQ\
lJtI<m=!:Y\#1#BMEXTbM5OVd*Y=\"W_TUIKU4DRIUtdY8Ma>h8@IH,+EHr2Vt5cNP8a5-:@
$IHYCWc5_fHco$Ec9g.p(ugdJb4DSI7ln`Cod8N($9XL_hfh^1OQ<TT$ed+Rq31Z*DnCJtfM
"CNtmJH.GZC5r79`V#N6rk!T%c5@Z+MHCi1.HXD.3032a+CA=8^aG]ADjrbLc><B]AU>cP6hGC
+[lq/sUHRC-X2PuI,"Z14a"Lb:qpZL'*I;!3DEAVU#?2GtUZchD3uMFNfA\&?MjAD&G&6Fqa
Z(0_*PEp."#]A1=50NP&d"RM*$8hUq[g6h@?W1Ug4a>-]A)IB(8e23e%@n7g4<uLH]AYIU([9pU
hFL*9e1q`_R3,8EdH_4%e4ol$Ckq-!rK=K>qd9R(HW5=6C'o2?bQEI<5ks/HaK=>gkaj\-f]A
?!3BK,;aXHm[WY@sXgc%CpBY8$,%d-9rK/p)gl]A^!rrAM3QLCp*F]A&a7HOs_Z[Js[EWW7E#e
;kUaQ.r7JL2lBIUbIhP)+itb*9]AnB(p!nheGeSVlCt'(L*b/<u`"rjq0oX0IaJJ:,7:0BR<8
'C)oKL`s.#;b02O"ks-;4+aDBpE,plkIAS&Yg1O3B2sE"p.[.C\S!40CbTpmLV:.c]Ac%/bD'
/puA_rVCtoSq$[^Rnr?\0i3Y)H4ZY;HpNt+GlEuB@EDmQX"[2r5Ko<4hfS@t:E3Ep&'7gJB=
se7LVN0_U@T8>(Nl;f;:XS;1/U%&gd'I@;IMC2JD7qJG_?:$/8`p.0r"LYr$lBOTD8h/VNLg
N'&OQ?0("mSOs/C'VA>>NF$4gU'q?ps5kP@ku.HJ=e?5*4)nnag3=#,Jk"8a0=o:0%Xm$fF4
9s%U^qZ*^iGRX:[nZsP=lJpG_nIM9n>3a\4ahK^6Hfg/sUF?$k@hnp;qXL72Uedj`HF,oZMo
5%-A3KVXgp$$7.cgJN^JmEUoCqf9kCUn=/^ID4YI%h2TbA7YWfuiS&C5's62e<S*$_D?&E67
@77$>8`II%<-QpPHBEf)2RY7T&mO#ZPb)WQh]AgW5'So"Z7kZ_djIjHG1o25j`Ln3ncX9hG%#
?ukhOj%o29u87/+t!lKXY9k$mGL:,#;kg^/Bc).@N^;lS`;==+Rg2j@hB)E@Y*g?i8/GLC-(
JKK]Ae&DH/V&)%t=T50prag$XMo)=>hb,%Ds6Q)c1GSeP@GK/d4;Q#]A?u)cVMSq[WSIog.9h!
j6u\eFg!d.F"s(?$@<:.kWC1Fe=qjKmhr)@Y<`d5CO=(dQ)66C]A/%@0n,Z9[>Bk/?6aos[#*
&.U\tI!!85-O772!0M*.8P;"aaEhPk&9OQ?3e3T_C5abtEItX8!hZVtcE]AN28La3.ekO`Qg,
s!fH]A\9IJ3:eUIRn31AX7F#"MO+5IFkZF`l8&-^NJSMkBL)i$eEpVUT,9_^jFQqXA#20V'aF
jk($5lBWIf/@%)Z*ah_V>A.mC(Bq=Bsn(O:[mpFWk&UY>XZ[rH%[U5Un._9Oo$""?*<r"cP\
,$7qC8__>JBY$XqkKD.e,1J`l2Y0meE*,dH$=]A)*:]A.?E>)SMoA"[-b9%ab6#+8\*.p/[uQ.
l'*Zt_QK=Eh4KaIiD#YaXn6=WL/"fV4uGsU3$*/_.E@>Pq::N-HQI,]A2ksjIIh[&@f-7:&/l
WSE!0L:hV$r1QH4MCPl#/'5Ab7GU=\p4R&cfP-EoQ]AVgM:e&;#B[8$>L'V-R86Tl/6fP4Rt:
e"T[L10I.4J!5mc$mduqg`4N:1,:VOG4KsVX&_)G.(A`j\YX%79SO:'r$to<u.V?,/"[)an?
`-*W$V8V=CTkVS=Of(dE[fW84R0Q+qsXogfI0OV%PV/[?C7pe`FVM*PGd"H]AN6DT,!i,^iLi
Ms58k`Q[M0MO.t$UMrK_crqd!f,abHV+YPea3(_X`iQ'@Z/5QXR(o\K>ulN-[^MHnk`+W/qX
NmAaM3n6MK;0;*PY.4\/"I;Kb'V^ejEKM7oZU%0UU\A5;FPCCZ\(@tX7hsofD0t!C<P'56F3
L;lmLk;_qD<I&/5OVecYG+B34ZW_\!pK*+.;,@rC;@ibWOXleD#:MV)I-CgGc8Qoj+c'TbQA
F2TD1!-EBf2:E#kC;%KnIR2@?@rD=sd-EQ7*khNBO9e>=W!,e8AW&*H@WRZ8?8JhOI^)'o,*
b[M3GZ!G@aDmX#))l0qb+DTu*PHY9aru-6J:cqVYMTlPpfrL`>]A';!]Ak0%O(*Al8E0Y?mmUE
:Z%WT(#s)au99>[FXH)U2RkkE[ih(.(3<QnhMdG\b-''+-==J=Dqq=`dt/`iJ[#,@A7mAXEB
\M)sr5^Db]AAL`0S7I.96]A#X)05t-8\[&NasWpF!?WcnGa@Zb:dg4/=+,9jt<EBl:C-+sb1Hk
)ZjEnu45ER/Q0cuKR6DR$A>Ch#?UE@uJ?mH&=K8I\0;-lK@o,u/`o+%_&'B0:1;_kM7L>u=!
BP:(?;[gh(kDK0#@?1!"e-*FKn),a'qPB/3;"]AJN4VN7<U<)=fM*]Ah3")(e"N1i'jDLG"%VR
QBVN+24&$s'.=@hm"QK/<`"UZL:9WoC=V!$_oqSLnErD@%dgE=-ql1644NYLtP!-^9pL[Lu)
bLQV+Y`Yg1a2ZV'Y]A%t<tp+#Sm+VabL+Bd5\pBj;`^D64+mj@5Wbeo9:\)eNtR![>)rQ;o`l
o2L!EgHhY!I0\<E_C(Ngcl\k3j&6$QMkurODp]A(IT6bHZVc7[#oZ!e-GroTGY8<$d.itV@QU
,_aL,+b!$9HjeS6l+5FdaFt1,V]A"/Qq_nn7gmVqYU="8U>VJ\m2`hem8Dh0`I&YQuGUKO`Zo
1@l*T9l'j30A>.QDZT$&+QaScSFqeRJE5i_4pSu@6R-lRXW4:\7,C8;bZJQFihHmA(Bqb`6#
@HWU.GQ<@;g05_"i=#$"i<Q"hi4lRY!S<ks.%l%M5Z+C=^V>=#=TiG=V[L&YtMpSP@6oXL6!
Mob9DBD"2B5[G\0b48=4O?nQYr^UaW@jDcQb"<C3[SF4aaX3*e+CBZ]Aah2B1n,0/:UtOF$4O
,?F_3rR!acGLm(!Wf,u")&d044o]A>(7abIJf9sGj9q/D[lO*Z2U)Rr(C"J47KS,TER-1:O/K
dj1l:'Q#Zm[>uD30]A(?^16n`e.q]AePReEk/`?9nD2j!"NH@2?H1JGrUPs7&H([%qg)!3e46X
T)=sI[c:B$iCsoi[C_?<fY4Z7_'^JqXoZFi3F^/DF>$>Chbj)q#^A#UaJ0HsM#m21]AA;.b3!
U<o0nV,mBA,iZ0Q&i#d(emEhB%6Su!6jO(]A7-Z,bfGnP9GTfn_]AiAEA[HXRaVdI<P5f.dSN5
5Fqt*\]Al5)?Dl;-;"?Q/#'M<hVG[]AaRsB`%/tJ2!Y3n.kMr^%5SPI8$%_`QB#B,"AlN2<s4@
VArW-+-BHeY`N%Rf\lp:Sl["T'SVrk`&V*3lsb0lM^ZL,&pk(19mssmB7oI"AP]Ae<2Etd/i!
&;MbGhs0E)`@5*6`S&Nkiu;R*4R(aG5IoLIN9p[nC%U#9kaOjOs#_\kc"bqp5#3MH%e$cP6?
o0)Y*=(KSZk7F;Yms"lCE.q'ou`QM#N$,Db4Ht7s@L-`P8/>2L'>1k[AO9\gmI1c!_%CQ\U!
Ydo@"BsOWedk(&/FtUPpFViEA@$ZrANakU<5[*G*M>OLOa>aWs02%E@8Ut!q_0094U=Rd81Q
POK[Lth6O5)G6\BJ>8.CR>cle=DF=RcnFE\3<dbXE1F.RF_Ic'n2k(5h[ZhIZ#?MD%_hD9M<
Op;CGQul@/P?)Eri4Ej.>nAGr/%)"pb*cM2"JfJ_$'/]A:F6?En;QnJk7jPl7W5[GB<TBl'Ba
LKV;qY+0U3u5Q(Ek)hN[(u!`Gb\iCB/iGD%T>r67g#eq[5HKRGnGp>gJaDC0Y5BW?2]A+2=TB
FE%C)5ALY;QopTiU+RnMq:41\UBo"EeABB(9E;qp*YjR,A<l33O(S*<P;pDX-L<j`rB6,;N/
AAbu`l3>HgM3(((2;E6qPhs5&(:dh69@A8$ttejk'kZPg<,./]AuST:<+qsI0B^Dd'KE/!s!Q
p.V72[9<Z,m[aPhI)r<BEM4./tU7nHgi!/V,XH5G[.$*ZFMV]A,lnV8K@t!+7-j8%`d]A3\T)+
CuW"qE@G_O%^qTNqDQ=8GVCPJX:XMFi0<Z@S]AF:Fn&kE@Iq!j,FuZ<WkXeRVF*Ysh]Am")Q-+
-?>`ZU.+Nb-jsZ0'L4aX1>d:T+SQrgcT0Q8YoX&,:T+0rBE@VkqE*JjZ?A@<';b'm1\C[ZdB
VWs<W/@Zn$(>dJ9%:M,EYQGOK(e)eIiCjjSd'50>A6;>q.@KZ<Bs,#]AlPZ3:`lU[iOMC=PtM
ZpC*8l\k+Bnu5G*KQah[fA@WnEV>Ph2C;O<IX]AeHLuB4k-dG`<45+5biqX?lRehdj2K%o!d"
Bi'rj`UIN!VkWC"_!Zm?!:nYIaJTFj=&*KDQH7W;h0=eSd\L)SpoH8YT8N936tm`2IG%aD)]A
YHppl%YQDS@8+?+afd=u\t"EB6OY%nX'IDdYOOd(_dI:ToURE.-j*2iV3b6tNQb\PrcJ3H%"
(<e/IUa-b6'p<r'2*p7L48XY3o2]AS"k=ZbV]A8"Ve:&V&)umN5]AXq+Zn]AP;QaG.\A`'!VP]AM;
lMCs(2gbo8NBq`<4M!(Hq=g4?#i21QtV4C4[m1NQq=9a[-5iULSaLU<uphL=8R@YdS5?L47L
[U:7Q\WoTS6m<L97/L+m:&Xp`(rUr98:J]ABiatZbkAko'E!n<Y#d+fe3S\H5A-IsoGU'tr`]A
)1-ub:&cP;>=Cok_IjP)<1-C9K+-p>;6hbkPd5"H9u(rf%t1!:3fH4W=g9oGL,l_n_s]A3qa"
S("?J/MgNok;6`i-`d21+7C>!iERKGZ2BiJe9e-]A)A41l#p,5SM[ThZ:0bW,Tu&1<481dZq7
@I;^^fRQ:OA@gp)btTU-_k'6Q`V>U$62![KT14mUGc>=&Xp)6DDAmgXd`gbf[a/J:XdKTm3q
f/sZ`Z,uK38ajNlaVUHR-[F*7,_i`?)O)cA"L$9o:j=H=!fEo@rL^`PRDD;inCp@B;!fChMI
X(!,irel%[K''9QL.aPngon=A'n@>;K<bjUh56sh??kl6/UtMOnCgPlc.*W%E%lENK;>V^^Z
mp!KRO01:qseB?!h\B[u[@">l(@809F3oqS0]A#.0^.o"X`0dl6+l+^t8\H6<8]A=EXIkCMg4a
#7]AXbK>/U`So;1s/9,lgE-n5h5`kX*:XV66r:^`XM.lKu<#neBZ\J!gR>Kp^g3B:kX*1pD59
d8BK;5(4$@SH4Q$rD;h(,eE+QAUU(uo$KR7cG@_Y7iIoI0\:,RYAR'fJaqP)l@UAk(h"h(]Af
O;W,Th_]A<jIWR$-=dT32"X0sr6.`HV7K`BND!n3QbEne#u/Ed2YG5MuNKO5:V)YVH,,`*5"S
"nae9d.P5cQg:^]AtW"6o8,Lbn^tG(gTlh4r-=gPXoQmVCk]A_sV'@M-K]AdWj;0,aGMNrmI-Z+
!8?uA;%\[$:CpM%W]AB1Dh3UpXA+j/3t/B72>K/@p9_@0%i6WG3M9K[Z#6Zpe9JPX++^J5eK5
T!(.0:J,$U)MQ(QZJ*MkBqe2'B1>t\'J9Bl%@ld^-s"c'>$c%:d">EchrX`&:/=d@Xhan%EN
8@*mcSgO-ABGc=MHok0/Q`3BAQ]Al9t8.5Z@%[;$DY\ojjP^20&]AaPE7_?7J(ciK\6C]A1rW.f
!bma5c&(`77aIa#-)(<KEU8=0.N5Q+c(\ALF:9+)#<(J6\#b2?5"T-^ZP/;$sl:jGE+%YsV&
`&ac$(q6,TYi/=_a"j;JhNf?qshL8q8l*lE<U6G?FL<J=)DON\Fmh(mI1[&?i9s;#.XK%&b@
a'gnfEZ2%BMG$]AX:IQrXneR0kDh;qQ[%R^Hd+O&q8P2Xrns<&4mT=<*iN#!QpoBa(ndGn-I;
/c7H"@OL(hJ'qaJ]An=?2n9<&s#*!5:>lrbe#/DTMQj]A=2e>0Cu2dq&#+dl[S@An?G3-so&?;
NQ#*@Pp:]ADEjN2+gT>Bu*?0pQYAH=E.(K*0$&7?J4Rk90DTHr)((*bf?Y<`92E!AlP*4rfGk
J(@mkV%+V"!!^]AYuQ[3]A#AbAI<h>8PMk).>lB3ij1<!j`Tk/N,):c;e0"RRO(S-X:+G@`#`A
.pVpOe%Fom\GHaal='V"WQ=T/9'Z-\K<JkJ')XnINV-%MZ_B<7*MVkB`sQnIa(9KFIUfF8.;
oGGu"rW7>#Ee)qJ/G5NMAl$_b)k2&Q7+&;5o[85:<!ME/kSTDh4A_rkJW`O>V9K5D[@r(VP#
UWuEt_9mjY'n?r-k,.D(GWEdo(Y_dV\T(mP0Q8@6'\oW:#FkF9h>d17;VqD-7C1af'=mBo.?
jb/?FXOKqm@"k?[B0sG<38V78sX1@C>]Ad7S"Z:blH8qbeQ'+lo8%FAZ,;/"SS9MG.8QE*9:7
XFsqfqfYGhRcd$JO/6EBpCl$$[K17.pCqm=gb#Nr(M.ib1nhaKr&)&f%<7&k`,Rm]AalCn[/C
??1?]Am2D$p6%14XB4Kdi.&Y$:J*364@^JLn-F$hST!Cc4G.OC]AZP_P0d@E%<H`S8Japu,#5Z
Q8-/j[i2b;<?\JLm4++gVh=ka&B"a-YG`nua::N@V*5%JAs,qOF*$E5AE?0;`jAi=q^AB&K`
N2Q\Uo&:86*)JYO%"X:@Gk/cT<9=4;4!K2M-I36n$IIn3N(4^q8&:K+6TV'uU7Kl<h_@h4p+
Dt*kNcSkaLY[`AB\A(%jaP-d.:fUD:c'[FPqZj(.Iibg!=`3@2edrG$?SL6=D6Yfm)^(B2$u
jgE]ABN'3'o<r-\+ERIbUNa1M$="oom#KDFN+ZSk=mDEi?dqEFXFb>ergb!\6>.0mYM0?6pAg
e%H+Sl&dI%?_gd4SMAdE\J5ms#;$V'tTI,qWbO(4DbJdpS=G\lA>Y\$A-Bm"'H8X*]Aa3RPs^
:RGW^+a@C5*FNMp[4Hekg8fi^H4*n<S4YGcAQnm`!n#U@sqa`Pp'aW;?i!-pR#8?\8-^R9dD
_h"ArpS.Co=P"BsJu"F<jr>`)O3o)6GY$I^HE@ct+0qN#;.to5%G=o'oY]A6UQ8g,M?\1'2O<
>YXZ]A%[+gBT8JlY$<BqcomFadL0c[[F;!BqI!.lfI8p4'/mBL!l'!.i#r5FH<Aq-k8W"&;0)
)4l13n6.'>839&g&!ad2m/D<;!f(.kpQ`33AB!\6<Xh)rqrWP:*m8sXq>u9hu3V$8)WGgTOs
'0\Gm5UaHqPA,>jB^S#94[fOB&2UiO5g@Hi)TZi=`_TUQM;g(_brLg"ST7!>oS)q3V)u_mo1
eeEH0lSKqiJ;.Us6+K>K64dkn]Au\2&#sO7oh!ld,ht1T7P#BRdO2nBlO9\q9_Gn,)QEP,sib
JaJCPBdG3#o$L:1eF%9%At=%NWZ7G.J`b't4FofF9HT';j*WPSU(D>*JddKPDH\UP'Br9,bX
Dd1+[J:g]A.M^FHA!`k@KZOjJqQ*)WgVNN8$-<S5%@r[@V:VX#W=$%ffn[bT%m;GBABi1&1pU
b#aUp`QBC!\+;!kW1GKiaWD,-Tp*ZJp#p<3+DAs6hnj6c7g9emUlJ0VRoIKrIr]Ac(..2i;uD
*jiC1JA3a6;B`Y9[oFeFl0.F@1nULZ`Ie!+h4NZ-`Yeh$GW!G6$7@4\4Xoo9T!#fE0*`HB8R
k#EU$BT(L9"L1;N.V"YT3g<'IbcpGS0lY="UfCrtr]A;pA)c;uM"u%ggEr>u@d9Y4N[qLWr-P
018&eO)o8J;@@/$A+]Aqb$e)D:4eJE30decH($p()*\]ADLlO*'Q:Bo$Fdp%]A<[@ngS@At=$Y,
BuP5<\ltFL4ksU:F3O;mk4'H]AR%JVGkNeV!<#j!I4YrT5\]AD/(^G*Ln/l)##M4,-af23RJO7
W[jG66a's@i9VpW*g7/;=\HPdb^sJ;)XI*77`q>l5VMf]Ar00\cjKTurW;16U#q0<f:TVI,G>
f?lD]A,U<b+%8lu[9Lt>2U7La\ndW0*(aroK=dk>0u9/D,s#4RgTN0Q#@)0tnIPg7FtX]AknZ&
0;-e)Dr-F!1fC<H?[*mNkO%H"XN2;n(ojn,m&c]Abl$'9lX%/\%4t))0JQ,9G,H]Au8+Ubh9^I
bWH^iKhFkl(.+:c[%AU4Uflju8AaFl8.Qj@/-bNN@"^%%86j-7[j+6s0njjR!\[oW"`-?%_C
ZmG(:V/<pr'd=,ar@.qIoePCed^&?5<8YX"$O[G^(D5fnG3RjH4_6p<Fl3B`%8t_F*QJGuLT
d4B'fe:8[[G);A6CN&tB(^*i6C;r?nkptoXXf,S;,D#cU@p]A#;/3n00C\Q["1T1T#A_b[*g(
5YTXGWo"cB=%)aCBJ,8KaqD7og8h$5YHRfI%hPfq:A&cZL&E.27XKGhRBpm5*Qn>h(Kh."Ve
d=5Ii(mbmI\4NLRWt#Br^lbM.PY-X>hJ')8mL4J(rH9X%5<Liaef=JmjpQ]A[9c^N]A+kU@$^D
R\He5R/CWKHIkmY!JD_SoTg^(G0sV60[n=M82\V7D&`9ocu.gnKkgiJ$VP>L[lCN$Q=t?XC^
nn'N.d#H:ad$3!t[p9m:)W_C/P((06*TS.ug-X3R^5I(n[ZlI@l7gL@H5!^NHKcZ4MMV<JA#
\MLn>AC1/-An3Puda\#qXpG3MH4,(p6(rSYffc`r2*Ja>;q%$67R7X<%CIM&dEOF#a;8kBUM
`tm!o!J8U^":1hO_ne;je9-#Eb>XTGMf;/h.(QKFsWIeBST#E;FBdBT_bsnJ5=9jnrDq*^UK
\VQ"9@\",XPo_1.o=?ESAbrf0aNh$>AW7u<*MHG8G>NDHML-f/gerZ0dLHo?\ngC.?e^8r]A,
QRU#Xg2rh9Fm<!mQ]AV$-LO6q#)eCN3H>VcfUmS6-rg0sKhp74oQ*$/a(1]APr7HpsS<r<HV\O
8DKo[(2lgR\3.k)'R7h'?,sAGQQtXl'g5A25*!6O]A&U)0Q%Q5H,fK:/^E.VicL3&d0PoC(\7
pZ)+;LU%eJsg/1al<4V%4\D%4cZ?`&,jTFF9]A;tuf`#e12`GZbA#\nC_!PXih=0OH3VitP?W
o*-#5JYl<JeQ"o[c4ZF71D)2MouVj'Tc;"!!j00^E/jbLt^]A59"Ec^\M>U=8@P,O<Wu=/mZ-
..apWMVhqt9W)d.!G/BYAlIk\UXqcKgQRW,3GXA^a+q_YS9putZ&Ve>(h"!\l<8u$I/cQrP(
XmQg+cXIJ@FVbts]A#`++-%T%ul8n7Xe_a!nXbhQ#n&YEEr:jLQ5WG<<AT>K>$s9V2mNd-Mj7
KEo:1#/DdqA[Q)"gX+,8*PR=)hb069/[j=@-]AIZ(o./5tW08M=1.1@Sq7Hg5oS4r2\sYab>f
:,]A<&i39<bqUCW&j2g'jK!m=W:$58HFWV_iR2p,Iu.,&t-dDJt<TnRo_3HUQO]Au]A&e.t*t'Y
JUubhnJbP!^?!o73R.]AeOS2[q*WuaAM%$13SjCZKH/iA#<;W1[u6l#5.%BaCuY-Gj2\%T5j"
@F9S>FjG>!s81^Komj;A8OQ3FWnV&"1$$PdO)$Mkl`:B(@;`*@jc<)iMKQ.c-=Fs>boBUjJ"
OJgekg]AW_ZouW/iNJeH16^Qdr4RYs(Zr8'10CHs$#)S2La"k\`G\NnU>ZtWshK"k/O`/A+0>
u+iA@>"F`f#J=SP\C3m<GYkOI>2\<K&4H4XW-u54.L"I2g*C^;2PD"u^k-i`3Qg8t>3G'@nQ
L^0qIK4RG-S1nn@tHdn3ijZSOC1]A@a@A8C7*0`F\bL)Q0eoZ_O-SHTa^!LN6KeR^K*hcJ;bo
-(HMla_^EL0U`&h>&6FR/%[W3c^)sG9nQK<8BuO!kJqcUH+ZFfOl_p\AQkK0@q%7@TFAKl7.
1V`WJ=l('_IHQ1A@Rbp_ppj-HJM]A#Yp8EOuTIS-[o8iZ4?4,2cCjNV&lW"lDV$e!s!rhX_O#
iY4tsGVk4C(Fc*,c7l5D[Nn#+&JSE4AJQ*G>o9Nh_f$$[30<'V+)3+]A^>RJZ(Qh8=UU``u7I
NJ!IQBI`KH-%C48iqVVJt!C-rm9F8ENj80TJF)#.lR0DdO&iCH_b%U4)&5UE_+d_1$aNMJJI
#heYrk7P:oRd7Sj?8)?/FDKjTj91&NIqi(<?phW@e,"*ZDJA.8)0Ke?ai3f$(22p03mJM6pe
>HrNj$B*AY/j"!V@@]AJG_1G,"HJNi$mZ>b07G%PLbP=IZf5=M[3YFfDD@gidm7c?X-,5!5pB
2\OIS"d,N/uIkL7?B='nJ9Cg2qq;X+c=$"f#dr^n.bnN4;XVcf\</</8q!O(M$.27\[In[%N
\V(%a2!>s8>daB]AoC4$JS:7bIn6MVn5;ch3?ZO"CYK)ZV;$Y_X,\@6U(&<+Fp5:FSSO:et^b
)ZqZ0N#DN,e=JO-84=M(cY3oC>6+a:mr"R99W3!AH&h;CjFEaH_'p,go3rE^X(-C]A6qI[cqW
'XZBOP+-)d*j%XspU33(V'Kc?^6MAaK-Q:0"fDF(cJeqLX+Y!jYA)'GR[hLo\PL",u@s3TSc
4&S'o%gm]Ag]AV7P,%YpjM0Kd5n[2B#a(L68.e.=uh@&N(M=VUl[tH3qM+f<OoduE4aq]AUU"$'
/HL67Xbnb\]A9!M_&&&"W#71$bW0*i)k]APaH(rrK+o*#Y)c7L.mqV5?YY8nC[M`A!^/jpHE8Z
k`iBTff7HRJ0^n/4E>!#m1L_:R!G_gM>A4_hgO+sbJcDAlXb^Pg-Nkd@hu.[R^V\d#\be?hI
>QriFPi-L1Z-r2p.nt@1@#*r,`6`pqJsi"cRG1@2-V0FqE')d6oUc;lJLq(NdO_n%RFN$`Qk
5r\<(+%m"$R!Q$sVk#o,`d>f#(MT8=P=Z[`Ji:FM-O3SqVl9:,QJVLm2<dG5B(c3OrV$t'GP
Q4o26hZ\WRS%f3UBHs=Sld(RSnYt0?U0)DGt.T+"0k^%^rSULq,L/3GN-&<O!+iPnGFH(LI>
I+mA/#fTcpQ,\>[fV-'1N398sdUj3J1d?dhE_TOG<7WuZ$@h0KU-%^`sC\t!QD,FDn?Eo1'1
EA3d;^%I]A586`'UW91&VpgY#mck#jHAZ@4?X9+Y,Ms&Q)<%;CmO2E&+3QdU)?!4,"8_XJ!^k
GeRUn:aE1+q`1V2j^Z\W&$7P2WN"JL'TE#RV&_rWQ35(-Ag4cL@#"q8)Ao)F41$;khbB']ApJ
c\&gIuO1d:!^FZCuJ!Upab>-7Qq:S,UN5"[7;&K6h1kSii03N'u`Bb\2lfgX\.d+\JOVJikd
4Ta=0h1Bj_aEWa4lB)hM[q11.4qq(P(XW!G1^m"^G1,4:C_`A(LiE'Db.Ang,NHFj7pFc\jh
U:1ZC`%S<UqdC\A_>DFHp(FRm'[V>NkoF]A^bp^:?kMq!@bFhd%3Z3)\@N'.eDBoIN/ENB(o7
WajR11Th2;)CGAt*LfPr'do5OS0p&n^KjmiXPoKY#?V_e7Fb3*i.-S-$hqs"4b]A<_HXs>*r/
hJN##lQ8_>EPs)&O/t*mQ[=NFo>qUu?EU'?]A:k4,-#*n9gOY\&aNM9@h#"df).A5L!tQ9Y+&
b4p]AQe=jO_l>7[N._2R3BPE]A=FhDZ5>fb_1[qJfMY]A5Q&sGC/1k7X]A?8*p)mnp@a3en_=1Ml
>7>[o(/08DqYkp0bj+?>agn$ku4l>+2S<h>u=KJB_.:dM))J1b2YJ>@&J&hSt8qGTc^=_!rZ
W!m.)sh8>gAWifH-Sd%4=$QqJF+Q1WN\.YoYF"!nFoJi$)hbD-e&#U%;\LHhPc^[8SLE(Z3.
>=$ko;e7EbOUNGk0ALH:^Z0Kl#<bLG.$4AJm$\T!QLLf]AS/oB@\ad9l$9*.?NHK%S?3S8kH;
r"MFC#QEP45SUKtL?ElqrVED'L++-\?.'V3RI7[;M)2Ar@s63EQ%=WcpiQ=5<oaKIe;/.]A;e
QHa!$F`GWb:Aa^IPJdSZ8d6H4H&=o/Zi6&KSXf`lY2YJM`ZN3!fYCp0o4"KtnOJV('N+D%9L
<e7fb7C._Z$o&>\N1DKI5(3'Pmj4ujI5C9]ATXd.^8o0\&uhoF`See.QTehXT[J'NigV7ZFNV
VHNf#o0CIq^$7l<-B5_(8s1E#Im6'iuf)oTOm)^5*s-Eg;B=4(\^;-8X:JQE87?GIfrDK7Vs
&<?8B@e#TL@EP_k%F$E^:$!X(0844GY$@II_@etHcI`?ohNOd`ms21r.X#c^=mb`'5D;K!_V
SjS:EZEDC,t;ul^0Zb^kt-7Z-f]AWX*55SJ069KW<Rf4-@PUbLX1Vh1g;n.IJe?Bg8XCl=+:2
7hokI*Kftt%Je)i=(#+eFG:&>HH<daV]AQ5HHRgBp4^GJE>C`GN)FkQ4m%>6]Anq$p->$`fD*F
U_:)+.),^V$9U@I.rj\]A2nrsgk:!_M.41\m3OWQi[gBGQUBmnVQJ*R\)MsaOodD3Xc=]A>m7B
FhQdsA`,W@k+0-`mY?dH_=$?q81*)OjK5!2iL\6'0u]A>.WI(\F5!>JOW,OcXkb<Cm21Fo(tk
@0UJ#L6"q:4fBM)UmSqf&:1hp[%<78a<-33`/:pKoE9lk0j^bd*'96%O4W&/s%8gi$m[:#4<
t%QSnV2de5?bHq7_?#H@;8&/oY4'CTr)A+*Fi)'1)PaTSu+N;.<2u2$PbkP$dpjGkg/CB!5N
.lQp7,;a,6/M)%Y7<2e*9)k@^"#WKFP?rXG\qqA5]Aehrt"=HDDc?e$,XM&u%,HqQZn&JKJ9d
u%stYHu2Xe<`r--Gum>cTA<cg(P@4),/aA-2RsW9d'oC#b[rX]A!DRPZTB6CDd/<!Jbg4AC\_
Z8,1Hp!)@Jt*r`.N-DCN"]AD7a#OYIU+ra@TG0H?P&/[Dc>7^^\o5&a8m_/+0RUSoW>iJLtoF
FVh_Yg)PJ#47>VJmhsJ=L[]AN:jA[!d^PVuFKRo$$FgiC1j*hZ),4MRZSH1i0ObB\rS(71#Ch
:QI]A'*6?\6i.pApQ#@Hf4&(#raILKKOY=Tgn@VpljUUeoM'L$K&]A@,Yj&:)*UrS2/WaMbAXl
lU_NhuXqp3pWW2oo$Kn)8+qg4DVhBhn)$d;Ok4I7M6V]A]A4W0DC"7!:Bk?@%G)<qRp9;rMN[T
[+mM[C;nFonYm,CT\Qqf^\-Y$"LFjm&>F);$A3MSRtW4J-.^>+sH)uX!6Y@]Au,sO8g&k+J7O
Q'A<PWs5oW@DFtiqu(l-soVdN_ulIJd4$d^P:;$Kt@P'fW#F:-p$Y%h]A7"-:I$/SL:62i8I1
/#8m7>UlT_8ERZLeZ#NTkgf9R,Afq&ggH.a=6)\H+^WqS2iunM(Ac]A3i56&B]A'he7T"lKuY(
_ME@*RX[?Ej)lDJW7SQJR7h5bckV7%HIl$ScrD[K=^QC_7Q"!D1q>s'MRaJFfN!*\V?/81EG
!jPC';b$ZB.)T]AR%g$<;srIt[<UFLgS4sLRgrrh?lWrnd#D_6>.F]A#^'mDO_GQGUp[6pB#PQ
Cohb1nG,)5Yuae><bg7hoW&Kg>)SH+#-Lb<LXo0\mdbV(\;"&I(TPV/=\.m%-_PR]A^o[dVk5
c+Ci,N7Z(@eCF:>!12gd>*m&2ZfPaJREp0?<03Sj??[c\8,T/$.heP.=p/mRX0L^d2J$sN(+
$l7QABrgUH?eVt6FZtB;0fJ1%S>Oq;.5W=K)joN+XUUpr2#]A>GdCreFp8YNM/j!cC7ui82TK
:3j_@hI-15[8,g96g:hlq)O5=_>:FZo!4]AKAcF7"T.Z+7ci-i\%mg\31W'N'D)^i,oqtE8n9
!U@t#%eaAc*]A`F9>2D?<s?E`%[iB/=lc6sI3-)nMk?56Vs:;UlsG@DRWLdk@/3']Af<N7bu&=
lZX9eR9=+=lnc/f'geRXB135GKA<rcae/*pV;g6"HS+4`chpKU,=2+Kk?>O1sR*A2c$.%il\
%s\U:E<((QPaE?DgQd/Pg:6JI?2j;CM.PZ`Q0WVGT!kP$jBXtATKQGYk#_g/^-cY"a\9']A]A"
06OqW[]AO0ZXP`H#FSWQe6e8ZbqPm:(<&R=QpCftIc&SH_(iC;knII#STIaoo&#!+<Wq/'`(W
Y#X5IJ9*r2Zmpgr^GQ@J?O?@@!\]AE&YMF7)%tlUNpLlI<7d/[@[)P_5+rIUIX3K9h\0\>Gj%
"gR61_1[eZX)G"oSeD8m_(0a6F00]AbsAQ<t'nrYjUeBd(*2Jd(D6gJ?Kg;`/22p2khX5i5>T
8#KQ[;.-*Yj5m]A?0q\a;q$b-[&E/XKn/2d%0&U[8%Y)F#9-.L%4#Sd@u9U.H9&@!DC'-,Y1n
<tCP:Dg*"A$Zo1eUh"5@n'0k#F<-tG?PZZqY14/J;!J`tJ/r!!-@oT,oVp&LA%jn737$WUas
6B]AbDi?CH=!l]AJbn5EU)Oo9t_im[k;j4OoTbKoqheHNq.P,4@G46"XQ'=Rp_n@(6*i,N0kV)
*%,7`X7R#U&@JM^mFIP@Nr,8HLQuk"1>R"fjfY>@h(Q>gf*:iNnYsG.<phIDkQ:Bi>(\R*fd
j_d>i.HgeXNAgggXB"0.78PSA)]Ak*Ve@uY4IJ5=*YhYS(8,0*-j6/I$VHQqma?N$)MZO4mhU
?5?d#;5C^MB':X&0$kt!Z;FcFJMZ:LaQD.`:1PU#jWK<5tu"l+=d&2cN9k1+s\d[V\9[H,=2
K']A:*6#.2PI@)JO.k)K`t%o"U4Tao1J-au_$6(1.63Gji'e+i8mbeiXN,I\?8A`5'Ag'T*+D
@2[`&A[)t]AIuG_Lc*KWgX*-,WAGF9%VaTHj\=:/iZ1@l]AGL:jJR-p9N%s9uMA:1jWk,iO5/u
?E$SZNo2/7>dd[SE..J"uF4`:/>"M@_L8GZ^qB0ql$jCT-u_Di[<&$p,Vd[a:($bpP?$5CsR
4iR*KbpP]AI\j/F0XV<tQ1`46cDJ%G+TZ9i*4qo]AVjI,F)D9Sa")6?_89SM.O&Ub>VIZL+4^F
Q2a-WpKLnlMLgF'HY_]AB:tBF5rn-N3IAdNY$Z3qG^!.Bkh`7UVn50n(4dg9mm$f*.Be`.Z[F
@%Gu,sb*JdkKRJ'E)s-bTqli.SpV%h:*Wo1TRN+(%>=FA/S:1`U81e#cY0RnM)<]A"1Q!tQfW
aQ=o3GjuO_3.]A5;ZkBljoJHEi5gX3B^BT,f7d@KS:XFe7^:q;Zp;0!&[Ma;HgnDUj=D1/Bk^
Ro7Jn/DffR*NDfm&(K;hWp7rPX;()CP#W)VP.sc;Y^(;^S3uP;6bF<a[;)eL-!gG6raQM57C
2"@/<W^7[(T-NlZ4+Z]A,,&L_0+s$**UA6$Vb!tL#4!o=2Naecd$R/\;,1MEiM'nFR3@\*6`:
qqh[lMH<DWAZCQ!M`WO6'n18]AS<_"r2%1&%:B4H+['X45Xk&Z-%u\LN'B12P\?74I^Ycmf"U
qNL.]APUAc=+e>Q>KJ/'-&`Aj=<Gh'k[G&Vg1$T7*H1E7W2LhfZl.WOk8a8M_if'R2A3p,8uN
DUj5I9/tg6jY>Q4I+"^`<*6,lekJD6@UaQ:?/7Q\$KI(n4K@YI+TR63I32=>Cj)1tDPGWQL1
@XFGb)J:HcKWu[u9<Ac:kscel9cs9h"[0D=&R=)5tpRnsC*c,11#S_Nj=A>W".nGH-j+h5_?
1!"NjU^jQ["Z6NU"Y"`aVXt0bR)KSYk,9[DXB82<%^]AB.V9t4reKb:SeY0;=WHi&2!o1>E6d
#E?Bf^nk#O!f<R`@!FAn(,:p5M`A$^I0^a/bE>kd=$Qm@X7m"%=ch0'6qI27,-s$ofKMIT#^
j(,W?R;qqML8WO8ApR;`#JalA4O;jY(gpOc,Yjb<-i@<dYn.rDhl9HmP<@7WX,PY8t>je[.R
D^r"Q,P/BFJRUUObL`#eElM6>'qI7,3[UbOcUlo"dK7nufXqhdQ?r%"@&`%6[0*R$X\-_QaC
m3SSZ_ZXl:q#`>bRmi0;&rK`h\YfkHP9sTX*kR[aJ_qs%TN:c.?"p/d5$`SBaA*r=JqN?_:(
:i%f:l7t?&eBODn<03m%@5g_qaBAh7B`7bsA`R"mmpK\-h3\cWJNtSjEm/7\0Hi(8T\HP1'D
\jLd,7^Wl[^N209hn=3h+ZD*QLL\hFseqSPTCgj,l@_ZR=32?F9B.AU-E\<.Mq!@,6:5Q!86
NWd366"1jM%,%I35;VAQBS@:8sXn(tG*l^JI:b>;*Cco^O[Dm;$/1ai'GOu@_M3/RL?'rH;"
1`XT1';9EV?\WP5ekMWaLMDW&G>ZR/dA;1B%+JFd0g?EXc>UA9!1,_:PP:4REsIb'ld/2uUX
>`%OWhHCRRifk4:-::@Jm\sMF;A>W@kU]AoP,549nu^Dfd&4=QAr=q[%0(@LaKXBFb4=M03^@
\OIZkg'fY5^/$&faCpmR&mBH,Mf@.m(>`%3,J*Z6R:3U,!q^fZ3>d2A9@SVTZlE)An9WAF+]A
p]AW/>BoHG.LuB[FecgS8Dpfu`]ADf.V0c`Tog]A-ubnnH;%?Bs,*%_eP*.%FKM=\9GM&P`lVX:
3I:D5eU+6tc.7i7;:81[2BC\9Mh/ZKQ:]AN$&CqOW]A@UpX4k4aVnCSd_r@q*`,2H5$k'UEH?U
E%@-KMk`mC5$ScOi;qI+J]ASK;rnjckK7*Qqa`LF_fg`*i-PgF0:I>sfk"":@$X6`o+2%`Ob#
^%@1qkJud8`rqZ<T8ZSJ%I]A@Vm`.K/3.#AN'db<JHO[?'S%[ls"F.5M`Phq>OjHKut[9e^J%
nL"`?KBBchKj5I-ek`QhtS&Zt%(1U\-1fH<GDd]Ak9!]A^\T4I?Ol:2U\Z.J*]A7Da9D7rD>8.Z
J!I251e<+WY^o_gMF5)!@S0rI10\NSd1r?1q,[Q%i/X9k(2\Gm=[V1Q10FT"SJ8`l78lN]AL:
^\iUmeX&9aLJTnEjYO-hI6IuuCB)j8itq\T[dj4Gp6S>^T2h>C;&cOQXWTjJsN&HrZ]AjX)$E
-JQI/q9+CP7n3%LgkX(h<<oWb.?*d`!t"YZ@X6@m#Vs5-r"p5e=u9"##IZ<G'tmqblV0E-H>
>,1^nkUbQf"e1LeR>eera$L^s`qt*@X&983*ub8+[C)K$>X54Z884XZ,,;O-_`LDPX>Y@MN&
>f%/F[6HhA@iNAFL^;uCH->BhneS_6VaL3W4F=74f+0)7Q&?:0'HR%6rq-M68FV#n`4jlk,i
b_EXlqUILFrs?d914m*?KuT@Z[(H&pXL?K52S)"M!B1rKq'lVcY:oa8sT/\Sbh63^uq"AkO/
IV"F:Q@=Sc:Yd@g(;NA'P)*QjqXD.Fb!]A.g:p8!qs['=<S0cZs\=\jo=P1i!oDrYfBafO\u9
V\BC7%24IA,YXBD?PJZ+6<pKu8=$c0\<4[pWjsND$*iL*^Te2kb!:MO^ORlAHKig9)8.&D>p
2IYRF;BVWHqraO_TfFkI^4Kch#D"cWdTPNn);t)@!(oeP<aOY-]AO'-1ReI!t!uG%q+?uj:'X
_.)<p-^!J8+o2dEVF/[P(#r9*j)^6eA@"mA4ffNfUa>CEM]A%7gKgRiq8<?R7mV>"@JB9ge5a
NWj;A^oo6##F63W8U.&MJj16hmZ2jbRJ$%X5"qT]As2LpV<RW)a]A@_O0"<G19?:ra?rJR6Ft5
LA/#roOs*+GbP)X5F%8d#RBFu./0Z0*d?m#L54L/+QZ/2^$BhXh*XC["bq'mm;!co/8)\!$[
Lu+&baC^m_6K/IK,Q1,WTVT2`Jf?U"\5KB-RMIq7ab`8f3MuUOcp5*M7Ekm4hYq4[`K;7#WU
CDX!S#Cn[<GFFj_^q%cN!eT%HjSr3d"TJ33PGNj6N@G>0QrT!@jT[:,R>(#G!W/?ZH&8%Ca[
#^N6(*%%*S(me]A6'V!G4'>*l1`HYmOBUo;NZ2t6tnjASaCb,F!FK*5#DcOg]A^1B*2]AP/5K_m
b71V%`&%:j:m@F[P*<pO=ou*8&\&oKmo.]A_-P1rlh#nWSs0((.HjSN'?"tfTURB'ao0i=Uio
S/Ii"N%1+mpg5A>Je*"N$oPKZQne*31#T@Z/A.cnM>!:iA+-ppO0]Ao7a,V<EZqbeQ;YlIU&&
pQR\rr)\q;o:C,_A:l62*l.T"=CITn0[/a=hDcC8Mgt7^"ZU>FBc\I%c'1062F9kA%um$X.(
)uNJauhK?Uhf1rjkbrW\c+7\+.-dgkbPrct:=>*$Vh2UQq]A?fa,^h>kG\\6(!1b)EN;d>bZ`
!AM+:u"c)i=RTVMaW.E-%ZEt8hT23L<DoP"3'>a+(6MJ^BeWfB,D05n&^>;"4-gj*!(!A=l%
D:@J[V+$bah*kmi,2V@>+#2J)`Rg#5MT,2.cP&eIo%pIp'gKLC3$W\KZ53noCO;b"mmC^Hsu
&ui7$4Gm0;/;q5j7VLQ+D]A8l"HC.h.nHcm,LA(*mhJ?BXfM=mmgK#VsRnO1Wg1hR(j;Mu_q<
_2>+6%dV8IA>Er;^doa'iEbA7Re$ZjPie_b-gRFargtVQWGq+Nk^n8?n]Apst>0o]AKmY!:3@l
\h=e;!A1)jDUWd)I19H%o,=h#q1@fm)Gi<fqo\Og)Zl;B:Ti5rb;Y'/MhlD*i7N[ia,O'T7l
Um%e@ng.Zmp&0$q,'uDGX1T]AH6XoQ1k`eZ",/E>R52llDmj@NO\;/,\YZ-O.SMXXhl5o%T$j
$gIc'P<O#/kks)BRgfVh$H(%%Y>"K6$A2TPd\4AH3hgVo3\,(\`kiM5ki^jg,M$E1/*:&\ct
X`IQ;pZ+*amT7V0O'k%cS[&C+qX4hR?IMI`+2c[2!U$bd&-"CDIJ\5YQ)*%jbZfK1';rDb_*
g#Gnt@'#O3TWk$!pPaaY@mD\3Zq#b.eZtVcXJ;*@#+^%7X1NYW\EC;_:oTj$fg#`+Gn0NsEm
bgZs3YE/S<#N0Y&#$RF\jbJTqCm6CueIQHE+=+kMr-X$FSXBS*LW@"D1'5;GG`cpV6(]AlE"X
&0/H=/'TYpU1*pHj/Z9#7cjl:SeoI^+-I1jkbu!t&p#P.-CgiD'n1NY7\GfCYPKi*ng;r#I\
<(AIn1J*M@m-/FcR0`P1JUZC;R1#uaGMkG2Nl%=.PI@-/8ZDKFgAk-Q+;YS8#<,je02)j=2c
XtXM;WFP(!1o7p$qm>.o*.HJ>_6gi(ku#^@e:S5F.j:\`*XjY1Sn9gU(^n=U-671f:BS;Fpa
OD4[2We]ASYq1+/:f0J^!jQH+.mpVk;6_5ONSo@%qF6C$B6FmsmI@`CgaW=*banB@XmTVHVI=
fanGu)):o,`h2X+[>h+k!]A\'UqP%M_ai^R.N/Y'nrG`1>L=\S'sOLo7YCdjFtp9jSOX<,LiP
`<26EGKDTJ.Bb*O:a9W<MJHQpd;4]AgrGId>m-RFrF(KW&u*='2<)RBK7<8lf_(MESAJQf\_M
B$p(""c:54c2T9poQSiB,bUPQhg11:D04Y&oiF_UlYdU\0G.h`g!a.'X<G?&,Un4fA8hinNR
OCM`f1.IARS%=o:qZUkQE./a@1VIb1pJaEMfi3N)C0_jaZPDHnBAH9BIn;Gmr[%dd@7P4C#;
V?p"HW3G1kc6&p_?YCf90O3HGoN^MFX-q:sS&6-mH.i`t]A0GGY($b:W?]A5LtXL).H\*"YG<q
Z/+kR+,R^HFR'dYi;f/!5WHI[ORp_SK+#,j_L%m&:0UYtCGiomKEl;m1=7fQ_gH>_/6)Vroh
uY#U*nF!D'snpX$eJ"YNe8l,3%!AaduUd-UUO77hfponf)\9Qcum.BWk^UVgN@_@%HSuZ6I+
f)843Ji$WQlmfPEfN3=+Ei,GC>GEG,rV1dI,OU-\C8F&irJ5ArVWDda&D"mhA9`b1X"YOW_\
osid&PII6"$.;S.3N]Ah)$4N3ng`h3g12(g&dFN$@&iak\.T4,Q7P2PVJ+o6Jii@u\7?RX5@<
r'PP*2JuT]A\Z=V)gG@]Ae6sRX+`t#sEj.=g]AHBA'M9qf#j_XOrSmk6co(K0bo;=u>gIFi!CLX
_*GnL[H]A>p8=a-!d9!S8NdT'Q*NMrFW!la6:FD6m]AM@#-O"a+3fYOl:Uj+mDkF8j%UoQ:!N(
GaHF/XR@]AXR@7h%E)YfI)LiU8r2[`6\kaLN"+q%"e$SgU6"Z$s^N!N'q:H!`+]AL29=+e1*T0
mV8%jJ(/r1,l#,lGa$=Tuk!++:[eH+1CRnFQUb*#Z.>%W\ZAud??-=.f0=eB+27U\KD8CZA<
J.4Puc,YpLKa9qMp,%HUngJ8tQtV?1Q(Ur.Y@GA11(ck/3nq+d*AL0k<;s)es20QjHhr?*2#
`YDoa[h"7'egf!0^a#GrbIO*3')X1ei!Mu!j=783kP:H$P>D+d#*d^^a2?q04q@TK#')W(O6
*4$#EBhE4JWX+f<j9i_]A2NKNPAX+P7k?q\`XW$C<O9Q_VU?7R6?u#@fDNk=q*[\@8FtUhUjd
DX.3Y&mP+5550KN]AOh9a]A]A<onQqbj21qpaN(U5"Tfd@-bgM!F5G`5+Eujb5G:`/"^W0/HtXJ
0dXuYd*bXSUOS=<5t.nA4.,_SQA3)6T+Y*n@JZRjkBIcD2qi44q.eorTLtA3OY?6eA_JInh`
3s+d8\o<Je/Nh_12+(FkR^X]AB-L6<^O@eQSU;[*RL?f4%Em@]AlG)$V<&5&p7ifl:dGT^n&]Aa
HG"IuhGp!;]AR+#bV2VV`)rdT4+=NjqjC]A2DH2ed:VU(lq.7/bPQN63J2eLtTZ'o>e-4[G"Yd
sTd3DE2V]AYol.-NjYUB1*?5!n-J^3<m+[E$PXV'N?XHZSi$[ZKl?i'sPl/,S/)2A[+nA`PUc
@6e?udO`;2e'R!B=2hm,W_':D6b&Sj%k`Us\=^uh2[!/>[:Mul?I]A[(47-$o[6fDl?G0S(P:
U]AsXO2S-W;bgjY^\BedRDQij<gTreN8OKdf']A9V\]AkF@,srA8Xu@SCC_s6pOCZ`EAjTRHrbb
Ss=smpXC47<Vi@QRppgqm=0"90,^pdY[l<W%"]Aea"tIl33(^Iqgnf@B2dM%3"mhIQ#=e!<lf
R#?%7>,0@mV9m,(S$jA&s)AlSlfUZbE)aJQ\.G(PA[%Z&fd>^1)&^+oVU-sA18/XE(2/f6+o
,V;K8n5LBQSUm0l'*ZNM(I:V8"?1,Y9eaR$Bh9HtV4OE)NXLm6"ohl(kY+rBd&Xc`MINiL)D
LXUiHfB#MU3ZX:TAXD6-f2Rtdt>XT6G_X-c/@sQgZL;)Z=S:lh]A6O%/mg6+_=DNbcKodIcs"
F]A$YOP8L7@aWcu+.e=_QVEpcV/6H@M%VI4*aY.[8_]AtO,+.5J6Zb0[OARc]AqZ.tce^1_Qg5$
pep**(J82S&g`>h[7dS>2@A*T1[(XeL3K+[R6jY$J.[_tS0)K15fo1;kuBrq$RZ5XV[CMrDT
`%*"'HHdl!j4Vu'`G(GDiBOuSBdpsR39??1'eRq$WoZ'VD"_M&HbIhUjm<E.]A4MU^_jhKX:4
2_H+cp*]A`ZSpEkmdSG[S^10qs+'+@C_iLrKRURDer1C4?+D6G$ORBLGt^2:S#(,Hsq_@lM:f
$%MZJQiY;`K.8o38P>RbAOtAHPdbj02qWcGTiX^0U,=AR/:+F8^@Z+S2QUJ>MNff:"/Q,HJ(
M%s=#K1GF449RQM7;1.\**OTqp[h*Dga5lq?lO'O?IpXG&7lMfAFD%L5tR$dYh;Y_jT%?Qei
oFX6[kEdn&8uq$"n)NsY*sh7?f]Ac<:Z,rHK:3,Tb\Kc'grqG4'qCXV/q85*Zf/Ba8b^@fn^q
#Bb(W"p1P=!SrPR,;(J;cOg1^8q1oDrq/JqV#?4((&r9X26j,,_29!MRp]AJ'Q<4r@h:BA^=O
Sek>)0<Ca[)2I`qo9-\U!geoBqa`dX5s6M]AVuEH7##gZTRl`dp$0Kke=21HJ%g/V\3eZgls_
:ok$O"Y,,8@rad>u35s!0WCMhGA[=uKDG2`Jf7;<s9`/UbrPGS11os7opu1N01:8mtf47e:(
M6e/m,FNtSZ!VV=;LlX'$A/k91!.[3,:,4Y38(+W%Uq%C:[s9N]AjH_Y.r(SWPtF7':ud8Hd2
hsf!5P8ZNEt0N!6(H'L#M?=LuA>DRoNW`8_9no1e"$XE$`DcAm"JqK3FRgNd+N#hs.VZ"@h,
%EiGncNtD`@ZMOa1g'9Q(-9ukCK.LD3Mik1P75CX$Lf$9#Ut]AR-DhcH.LkSuMcYnN8UN>%Ri
Po3L,=r;QKm(9a_%s!>b]A^DS'@6#%ZV7AX0\;S3IBpJ)2i4(M.3#B[_YJ_;;^s:3.3"1#fXH
R7'+)]A*]AT)_E"</OPgLa1>hSVDH7AhqB)Y6LP]ABVNS+G^F7O=0JV;Uk.Tt@M[\D,Ms?Z!lL0
@LlA?YA]Am1Os-k+5h<h,RZBC[<&tPcK!JZY+K3p+.lS>%,Aug^H$>^]A]Al.K?_tK)GD5Jh$bp
4Zo*VTh""rhO0V=V,]ARC9<l!?FL4TA#ipR6>+/cc*bG;d5M%1f^soS12.LNQa$inmoF(&W,(
rqg'++)Fo?J<5Ld$LdsRd;ZQ&3%)?K#d517"mV7*X?:)h+2'ngI)$*k*ir0g%<8ugH@uad,)
("+l]A/R=`CF-%]A;#4McMW)OCOY!*eL+!Lr+rM'Jb7?!ij8m)Tf804.aiFmi;A_mI=J-)+dAF
Kh!A0UTj"n-C6)<Ek]Aaq"OWJRtR_B!WZ\NpR!rMHQEd-Y\'aEZ_KTK2:\<nTubj=V-jX/\8I
nYW6VtC.$qZe9<]A!B0.&]AB:q(WR:""6'mOJb(U9J;:i'KHhOUi%A`.g;Cao=rZV@9#aV#]A%C
=-6;l$SJD=u`)PA%7cV!jW(m^o=-YYVoBnHI=jA!_N(l1C[lI5cA_3^D`1rR\`+m-(oB\3+V
BjHG@TGCn)9V8EU"qGSSkF!!9^R0ieD>aR95>4IO_"k#J41umLb+Ce?DCej-SDfB9KkW1cP@
dC/3p_aWlSMK;LXpB_<s]AEQ_WGH-X,To6c,h-oShH$D@<]AafFPi]A-(!cgZLhj0_W/[+42-kf
ro%k??hKbt\H.l#X,^]A+&M:1a!mJ#Wl-4fO<\T?trLWMY=iQDaQB)hA`r]A'XR>7b6[RS7H6J
J/FrQTC-iqEOG2_jTWJ,X10WpFJPA+)3+=&M0k@`$$JRS0^VJAAHrK2>[<pd!:.iI\_s0OQ8
_t.4`Z;9\Mu5d@RX.q3r?1S&59L2biNn>8TLZgFI^0ZT99+LO8tlK\>iC#nuQVfdW*]AlYbX<
1hcL8!)<,Q2u3P"c1-=#;%k6"s6p+=b'b5.O+;I]A84IWGBrVk:kY`bTRkYGgGX0XEq:[h9[6
#=k/^Y`c(=.n)QSNlSk4O3D%>?tE3GD(78r9.Hk?'-draur.U#q&7GT\1_e=-<&Yh?#]ApN)I
e>;'i):`*<ojV0M;a+0b'1Sal=L\&n8;foSO$j1jsM)Ghpn([MhBbJeWV2^Mn5i9p2.N"=\-
R1A6:L8MWLLi2`JtR$qA)T7t%$YE!paAgD\<[PE?Ds5>YMAe?:QiKZ[Z\<oodUpU,0P3g02i
K)&Be`FA$UlE&FI6c[n2#^TJW&Nf8+X+@:GApSpk5*;(MQ`$kA9RW24pKZ\<gG(s^sA$9^^D
_&Xe$Q";"KK(Wg0,"I,n^)igE?qN>o&%jU;Diai&n+@bX_?&nl:X(WGK\Xht)k#j`anJTaZg
4&M+6tP>@&VVb$c]A[uM/!+0TTlu'o((b.F=La+n%+b,oN-+<mQh%p/.)E<<5t):e&CU.H)Yr
-r5i1,*Td%@\@R_XaQ0J<h*Y+u_#G$R<O,()CmeHIp#pYkLWb>^Eqb[UYCgHhl8utBkUa=Zh
_h"7#6!31p2Wa:E,2m=qXUD#,'<80KI6d"[2eh:SKSc1@NI-AY3*[Y5D3*.408kR"rg;`3pX
GsJuit0.:%2W1==u^ZZUU?X7!7.J^/qS4TKWCr/6:U,fmR[BW&^E3[tuSG!mOUN?8(ljo!j?
MmNZ>[DT=_W]A@]AF2rC#40tQ$+00k`n0.BXn($su>s$@lg';\<GG_%SYP4#[4SCQi]A8Z>WK*;
>6D"^+/QoAb-;YsX"))i$Z)CTM`f57YVtE&J;30nY&bbupKB$.[kl\Ek4XmhB+igeu6oX[9;
e:9]A($<1S1>'V4'IK)'A2GR><haB?uMs!Um#<$#j<^rLD+2(#\2-c9j_g$;)O?[bi+nr"mEY
loR>@E/-ggC[PM0=]AT7($quRmgA4e*ek)ILHn"=2W<39rUOI^%#<@^L::ARp`U(\FI`e,B4f
HFbWK/)5&6sLME**NoZ9:@*]AZ2s/Z2aX+p4"1q)Bo%a*aY=FbJVrM/j+=`"nRg;>H*a/As,j
37$#(2&'Z$/.\<a%tB\ZFYKrkWmpLt]Ar-^[AF5m[?QG?F!k8J%@IJht^\f=QHfL!i_fS)Ll[
TVuH_C8e@<]A7h=W=JkhcTXX!B9I"N,HR=H)`RtOFmp)$dt.*KaH9Sgk,\sNqSd@Nd?j:ki&V
fn(j(G>dQ$sL;c3apM&peaN<kjI>]A^r1^?WRa*9=W*S0r4fb@pZS@_H8E1!ke*)-aP$F7"tn
KuFb8Q$3"UUG8F6%Of$Z?XX`"rH#kTr?h%")dRhj'bTp'#fb#*5R["+Wa*2b1:Mao#H'NV1)
)3OFI]AMBB*@bL7Ldl?]AWYXm?/,WaYtZ##IP2qkYLDc*>L*+7hM+qpl,ct)r!ON:GlO)5XN!^
?5CG2aH='7m"CU[rJ@3&Od-#I1.Z+75&c9DV5^_A(6Kuq4-Qn7F7Qqbn5Z=iFfp.We*"J)%l
SBl,WY;;V.,CX11ipm@J!"eT#iA:To'.0_nTs\l'=1jOKj>T]AU>8u01jn>2]AV(sbTruio8IN
25fC:O4I&:G71K@c]A`ct[=NTD;Uqu)1f4%2>+%V.j\<+3XHG\'s.Z<2loa"\Qik>C*_mb<7/
VV$s*8/`2,HmMLXrg.*$ic$#91b$%CJYEu["Rqsj)0>K(lkDPhJFf7a1?8f.PnHXhoabJ_+k
!)lc/j%;*^X(-;$j/P9ls80GEXsSQ9?)V?=#:?_bY!qXWFCHfqPL4[ciiBaB8%"i4/6;A.eo
="6@FYJpmie'pDomGg8%<oc/(=j'`^%s@3[8aHsd^?s.7El5A03VaVe[#FU3=Ti.pS/cb-7l
[7@G<,OIi3:YeEmH1@!^u%[VmN!=\Z*g[,LBaJEf\Gkc?8F=ICCit(\K:M`7VXQjHTrU)t`u
7DKrtb/gk^HGKIY-CY*8k@J,QI%q)h8='qPe%7[YsGT#<N&7fI;qc9ka.AR'*r8V",#t3uMG
:'>lT<ZKG6VP%5ff&PA?+sXG<7`ju!Z1LY^OE%>_K'#^^G=Y-Y,SQ!*YqTal(FEjOY/MbG7.
:N.!VR\#nX[=mp.&,W'L]A_WAM<\hE`I96BNJ*Lc"?ZFEk_%h?UU+f0@aqS=DBJn(BL4c)f$V
T#PC>nONAH7`nR"ghX4dSP+,NS_Rkc=hW;&YehBX_9YO!6Kc'b-GJ'3*%&%%C5bHlZYAg_`6
QE3F56<#%#W3D;!-95MVdDqqda"3LDjk+@kY31ITR)dJpIih:NR))?Q?-aU>R(\mLr=_@uTK
Vhp:R9'AXVc]A]Aji"JJdW+R1qmMjHDZ/RFIC*F!>LGGel$\$[nIf[H45X*t8fIC3;_O@CIr9/
/AL^k+/0>]AG./U5tp6CG4s@?;3M<ah(b+'qifU1nV4rI+ci@Mhog.prYo,rhTN5"]A+!60q"r
lUam$&FpZ9?%BJn>nok#lC1+R0b9L^FS]A/!2/Buu+VP-2Dq7Q';i"Vf;86M]ARbjHosWYS7tB
)E:sEE=$7rOFoZuo@pc)brtC]AOEfG[9A/sr#>7YYOP"l0`j2N?5'kS*5=uWQnX'3g=sA6H0@
nG1\NnEEe$%3]A$qg8n<!Y_;@=GT`GKVY)b&p*#+Ge4P)l.P6dfm3l+gLPeQNI.,37,UcHS.N
s&n1?G[@*"J#h)#tiSR7Tp$2BlY]A%Gg)C[bhD+G\AT"ds^S>o%c/>l?L-M3p:%]AmK,jLO09(
4EbmE6E*$c3[L3cCdkYV9_oL1X=C]AeLR&^kQVgrd&&m;nq(M'",D5R0!"">FN\LbCrn6OON#
+i:I!!TN2'*0=$s^kQZ#Pog3i_$BDnp`M3gO8E>%*SBTrC@\4%h-!>kcCreFsLYdtCQAX;#L
5JJsBFY6b)b7(QRCA6cs^ZbN[fMW.h69=7@NaQIn1^0gaWr6lrLeiVp!4kRiHtjK_Q^;s=gY
8]Ah=?D/MQTNW/-)#o"9Ir8`8Kf5aB5bFEV]ANS1b$WiSR/Ok>S6gXXmPO^=c1=pSJ&J0;[;[3
3GU/mn<]AJO).BUE>;dhc02tSUTi,nYJ43GRE8NU1IZ6!h#P-+0!NN$obEA'X#2n;aJnfkCO&
%kA0'al*G*Mb!k'K4'!k!7sm3AJW4Y,!n,R\.>EL?C=>7G>tN"hbV<Ig\mb<pMZSOVm-KG#g
<^V*0%.SeiF&k,QB[csf-4m\SuQ"E,q4W)oCmo9@fcDf/?_gQf"*Jc%""FJ^ro.0uV+-bPAU
^?FX)\b&%BXQoHlH0F=dX]A&meg;CL]A0m5IN\]A!p1+%+VNOpIIoVkb5A5Z_<$2UEj7p7\<n^+
rThU7ojtdk2tm#pU:kJ<&/8kJ'D/=^g1pe&d92C-/>FkHeR4&-_!go\Y-/4u-\&-Ia%;W6p4
h.-n/6]AZqf+FkoT+>c)?O:m'l8o0t`He0<=fe_,U/r?LhMaae-<(lp3\f=cBSDqE[d72:5H*
U(G:=i&4LQdW's3(DCC,Dk^k#'C[QWsng;V!?m=bRr.iNq1@H17+Z,'ARBTgu'Gi$k,k>-a/
g]AL16/sf,@ED(uOAk-.ON9MAY"6=.>SKAC)Wu.i2$"AUFcU2`W@kYVf2#eO&KIRdXT\TbYP4
L[JC350<Rs15I4PZblllb!*PQ8C;d0j4&XQ!"F_hCX-cT=olX8Io]A"YULg%=m?VI!'OYuMoo
#u#AV5+%[4[OC0-e!cq;]A+PI<YUsGG'o5!#KgT:D&N@']A%C0'O:kW:ee&O09nOr?=nI$NtK[
>PJm&&=7J!Tbi_ar#O!;`@IIi>E5,!N$Ws8eSX1gRmp%nh+=Q<9)\"Mi[kd"OW.6uJ]A[U=7l
Z=#/os8+,R!bb@'Wj7mre/`3_BV+Rf+2nV9%,C+&lC\d2.j5V5HHIC^A.7V5k[h7O-p^BX+-
)Y$jD;7Ho$#oM$H*PG#3emea.s8G=Lnlc1*ddoXL[_C;D<YTq@Z<)Ft:ZBM@0NJn-2If8M.J
`]Ald7_&ZZ0YDPLV_AW/W_3qJ509^]AIaui0N.\+f3n`0scOf32F(NP43Uda@Insc20[d4A5$1
UlGHiY\*e9@m,CNR:9+ico(55DpB>bb[X'm!r`#!)=$`C#fk1YqCE/==0[EX@@1@8O_5)idP
s[uG2#]A]A&83='VoDD/R/'Q=X-)0;3gllINoU1/jV@RcatN=BT36pa3\H(1W`47HXAaPS4j$!
2Y`J<r"Rp);3)=GaNl+L?gPARBP"IqUoDr?IIA*5ig>Q1"O6%Ieo).G*YV6(R4>mi$$5p7K_
q%6!-&=Ob<jTA"SH,eIUt29ufF\m(DE*.8#ET<"%%'8_=C/9SH/6rS?5I=$Qi'aUZGH7S/L-
UbW`6&g`RYBbK4C[%K%"g1EEFgak>pJ+CF>A74(\c!VJ*]As'M$0)p-F49]A3(9WQ&?7;!5^>t
"nRB$Cni27&-Yn4s/hh,uE/;%rrTD$`IJX5_oDfgK8%>gau!BJ$BD)"qTD(P`EV8R?50dp3B
V?"(J7rucc>Qg07[12VLB(C.Kb+@*jZ[ZMt1?SA8g9XZSE-d&`F@"f2ch&iZ;m2b7bf7gDl#
trgSkchMfQ9`>/KSAK+b63-J>`p^1^2Sr'_[JX@M&!-Whj?@9*l"jF46b=a]AOi*N@Yc"'/Q&
NdO#m<f#FH\Z63\fC0D0$I)X%#9o0uFK5%:=UNSP$*o(T73cFCU!O\8*=*cCT(%gk"m2lDVd
<K(PdLqc<!E,nd4[P_&1hmuXj*UH\X>(J>%hSQr%N4CP<R7@EVai'cpb/WrV[=g:U$U4>QJ.
=:^>0oZ00RuPnN?$sI"Fh^NI:mQ-=r669;rC)X*Pe>NJYHs<Ig&;4fKQqT*EC9QNO0"YJQ/Z
VL&Ydp#T?NO%"3+#C4?EUJTEq%i+H(&dq3l<nn?UMT/SA;V)6(d&0fWiLJ4Rr-l`s0&MPHsJ
B$TQCuZ6-E_E=sdUUJ6?/gK6[on+OpBXn0!i\,^@`k`X[;G8t1aSR+KPIYSeec'QK6LQ\("C
J`\7k[Yf@:_8fIJRM4BV)-7'>'4[kZk64djAH/SA9Fd:7bm%_""//Q_?j0i>pD.1_\#V29$K
]A8Nb7s8<-$TY6C7<=VV^A!%Z*r%kZPZ51%KLbZ=#VL0J1nH[HMI2I<BVJJD=S=#38ra81Z$_
gW>..ROhYobBjMpd+l23OR@2N44=Fk.oJ2*-@,dP_c'm88/25:IqpY`aKe>cfHU<b2W^Cr6k
B^2RKt5#;g/4rS8)Kh&P;mkjZmM1Huu6>)d!2V0uL=c$ti@H0^,L;L<V(Fcnb%>4L"AY\E;*
>Qir_(F\81BdA7V8#_o<]AM"$]AOAQDf#,n1JtnBBN\=4irc5ruL6M(e#qrLO>]A4uDkNGB9F%t
m3j;%oNR,9"9+#*MDgM=Kp0"HF(Dd3-ce$eQ9"S4^D#<?^t!HEDsFsPX.nXd<1nG3J6f@fK%
FJmtF8^NR4D\#qIE`a`,njnKEeNtal^hnsq640h8FE$V!PmEFeW*)$k(81ud2Q8A&[f'&JTf
gAc-<KaJc,K&JL?hlDf&C$Eei8d;lZo:&mgQ\qLLbiGc$Gt9+qs!imJ'trYgc#l676$9mh-(
TFPB5-BB^Pf@6P4D36JAajW;0<kXqJEh0.9#YdJ(O8l**1B:rVG4hQJBO%#V-!G_Qh9Q+\l;
:-\b5r$f`<m=(3rpdGrr/5<=r*ol7?J%VZ/^9L7T^kqYHIkfTA@*Cpfp?)3&^qp;\!=*X,;:
?MDeFq!ktInMr'H:'Cp0TKS_%AP\>aAeQGK+^0'P5CU_ul;?+LtS\+Sn4I3*['1tAoaBIkeU
8aU+$of^(2G*2kYnTZ1/O1F4n*&C=#NM_SSp"7[h0\u2iMk;T+T^OZmi7-am@YJ"1:Q4-'M6
KZ,j^uPPgNXK=N8T_2c7+mJ"PYjSHcaG%5<X\L9Jh;>_9q5)j+m19A7EV=\&r^E$M"A]A&RQ?
gJfTX6lBhem3=Y%`kArGrghOpkL\UI!C8B/iQb`l#<=c+\3joffrYkd6LSb"/-0(t+C99bP.
V"UUekHo@DLlaDo.hnI1T!#!/5[IFX_=_`M$?nFZ9=S*Tssk<\7I5_VZpAFA=jd0R/%T-WYS
B00#(\'F3N8WFXWcK7'?q)<`M)XO0P!=cYu!#eEkqb%<^TAk)S*Jg/uC'/T3_bQooLT!&AQ;
qIM=gOH*bcBoTmg"mp#"5gsO@5o'3:4\$"$MR%r'R3+,:gT;3%q7l46(5U4)d<f(Z7jEuk&R
16?Egf(2Ik,1R((I*7-(#-Z%W!NPWpejs;beTbh;sC^(=8t3>Bb,Qr%l7s+78`LG)Hp>:-6I
ncKKremn908f_c-[ckj"t`p`b+J$-1cl7!B:'BM`t&$hZBG,<;aVmPsKe>l5'6"W7O)juQi>
PZ'.-7Ce]AFra5+aAlikg$'+9NZtk:_(gACa&^be:<U^D$T?%:]A"^1f'QQ[#!gLE0S.Q.!9i.
/E8-EK'S2q-S4ILCEs8>=.L?oL`L,`0t6jt@8HtDR#eP@.gV4_M0GnJ0!T9/;>?nphSq1qlc
.D#Sn+Mb!,_`r$"@nmQDBnCtB>iL#49Di/_k*=<M:SS=t>XCD6QeG/Cq`h;49R`"f`aaT#<_
A/c46XCR^@'.:r3sT$272qim*k18O]AR240Te8?bsW>c7tq!C6O9?UE.Eu82tUS]AKJosU=7.o
RQ>9q<h=OVW,%+t<+fI0VT4DhGSFL3'<<"tZ&hl8(/a"L=h:rjBB*[P6ph%3Ob9?.KmCJTWT
Z-F+M3?OY%Hp%ihmmgBYp-A[!2o:Or)57M.RCY[,1qrh/UmF+?'KiB[0$@Jd%s:K>]AdkO&1U
O-ljj+n&n![H!M[pD1l=(\i>U3r&Y)#=q"1N\-H95)oUc?j=Si'nGPFI:F3n"l1#+,C,(/((
S;4=B.e^ssh%7AH8_#adb]A!Ma<sA4B#el<g&`7m0=9HFl,#Ri5p*$OW\)tF0r3IiSn1T7;Q(
`9GG,GYeN.4Eu8Oi1lP4)cUh$C985_)ut:I4HG<,41C2[_L6<O=4*s&;T&`K#To4M5iZTin.
]Aq3f4C[HH]AE+*7qp'hkDMr1t[2S@pCd3W%A-_RrRk-7;FTB8Q21XoB)&m@RmC)pB>imY2=ho
EGT01jE?pD+;_?I$55'*Zt6%JRJblc3s[I"e%!AH:p,J,q(QN+=HPbS#Uo?B3bIbQ+&rOSc.
4BkkqHEFq_cZMjVi")_p/994,5XKb,G'Q)WkLEbetK]A(Ynq#u]A0>nH/D^:l!,Ego4mLb(CW*
kK&<lBT0hM?NI^*[7!2lM.@6*>Q0nY_o8X_pF,KHoA=e2oB<h?&jaJh`jRAA8r3KJ(!M(lI5
BFi7M?%]A"9*@=D^$o9Ii+HrX3N\d&9Pm>`SpbXa!W'u6r?d-499o=3;i:pe[Y$Mk75%WYjCu
cA8o$_i[ToVb%b=$OXNkfjnrq'Gco1:KPe+?6\d^G$rc"S;."R'"!Is$BO:=e]A&0/R[@X<c7
u%Y*Df1r<Kri>-5&7$o#l_i"C%:cub*EJ>j?E>D'Jb7Cr$!U1`<eWTAV%]ACpEAfuQrW+IR#4
9gOB(OS!'ubYg*-rf'Md[\9J[7GanLE+Csgm`,/V6+CHP3F\1SucC]AfK8NCg9$\aU89G*r4R
83*S4X&"Lh_8HC]AA+LFp@`E`\g.0A.n<m<H^*5Q:.*4F8YZ49G$-8=6&F56_K,FgIajigA3?
eVu7bs+kj+/H=/fmQmRa)`,,)&lV;)mYDq>LVT7SnpISltg^"XiP7e`7m[nm\:O!N$_#a.RM
?D>fF1X44JC0P0N1hu`7M`S=(peo$mga`SdCi3?G&-gjRoQMmX2Zu$!krX,3ub'qi4ID-PI>
nHCITePe8s.s<C9.G6XT;rbN%2+8Ma;37g5`Os8970?.@ek7am7_jISZ7ObAluocCut1.NiD
t=B2kUV,;=4rM#p]AE94'dN)f3^O!dQ7H_?!Cdj&5mTLD,n:`fNX[ENRQAgkp6+/$1:K^j1@V
C7PJPn]Ak&mcS8#H_RK6!%)@=PbRkRQ#UAlR&?[0OCX#(VFITs4U_2^hIC!3M+JU+Mao+SAqD
=OO_4B,m1Yi:;<0"OhGFPC.rsjog#lM&UDG"Pu\4EQ`qU>)>Mgf9K)!4l#UFjRgVf!S=98u.
6\QU=T=7*rEZO*"'BC;_idQR=S=!#>kfU_<9Lq`TXaFdK)oK+M.M`C!@"iO%<+p/MJEmCOA_
lrcV=?l,KVFLh!gdH]A+?-uI#-<:6Q1"BP#'Y0*WCT)"_-jZ#K+M]AHR3;Es]A>VN5WiBI53<&7
)MOAk$&fd%dgJkpH^i4@j4\\EIbK/5sXS,VhOfWofU=R@R2nlmUhkQhI5M-t4P0GmES[U-Jg
1RIlPW.tMmGj:'o/WuakQ,T$[-Z26Fm_YL/*@QWJ_fee;U7s[;H6g:*H`N.<#3Cd0Yh<r:hU
7"Y,9trr,1>&)!,LBEf_*6rqdDD\WdM4\ncqm-oWsYe)93TjCeKF$PtX2C9O6>Z:6&3qop$j
K]AKbFX7-ZBUb[*G(&F3)jnNG_"&(Z6Wq7@[c7A8KsgIEaYI-*hhm.4Cp6218sqAE/p4cUqE=
7Im6V0cONerZ45.*YHKQiloNHRrVPZ\upX-IohZKBeJ;1.U6%)LU,^LVB.HLaThC,'UjAXco
(:I`?_!<.SH+9$>1peeG9=;WWsL'sTYBW[X\8f=PigO7G._Bgsf6e8`@sL*J-u3d5,oM[!0t
Ofo[1Ofp+he3WA@UD!e+dBa6I2I2#RA+-sWl=Kd$gY$R'<_KCB[D9-CgG5JXYAJN%^ooC]AhV
g&(rZ&"VRsParISd31BmEApD/r1;&Kqd*ailq]A6EELNZ5GC,'qoIB@:&cp7E%qAF53`kg^AM
1UVSlhXh$'5L`Z1O^0ORA8RC>!Ap<iWK0^IhHI=M)>\(06maq750:!9Yq"SiNb8ga5an9JaP
+_Jf!14K@P,2j^,\+"F;dI2>]AW3X'>k;Q9W$=A#m!!giT(XU(8Q-VX#;\041s[9YNrD_W-J?
C6RS]Ad1on*pS`k\2f-&RUt^+bX)Wr(f_*@CesK?rJO\&_askJd.jDL(jVfIAU?UG.Vpj#m-g
"Zq?[H'>T..ac,8*AfHAOLr-hoLl95*fd6J,W#5iQX9@(0@T3Fi;dBAI^asHF?r*7O5C]AG&p
U\aMP1-7$-TB4$'1@[M2^?M^CTjkaTr(`,mP=]AB;:[hJ!!Q7/<VD<8&6G8q=,X`rP##9#/>@
kb8iUnR@AI[Y1'EC/fPcK4J)(Jo4dZ`Lbl=p[J,*tOXhfZ2T(\a_k,&7C78m9%#1s;>@r!q?
k3b`s8'Jkpj!>Gf)@M8kjIHIa0YRGD+8s-R=5/EAVm!#51Z=_R>FaDSr"A>dN1!q%BcZ4LiP
Ve"PJ->>lgoaTZglC.mu]An*lu+%6bE>$[/+\5Vr969D(/VKl<9j6k80"!!RQ+#%);hqbSP`U
c$fO:Yg[GJ?laieZ0?$8HitbmQ4<Qd]A9ppumL/lTZIn8thS)+/9Pu2f]Ac\o'`Od"Yg0:=c<T
BuI6%CLBPhGj8A`iQU:b#$;R[H$(l9/h*7XUBRqks;GSXnqsp"s'R3G3@F<nfF('LT62?.HO
7oqGJcDc%.RA!h7O^gVoUN/`Cs2J*rj^%[8e1!=T.!LrAC2*Wo(jM^o[:a1[6p38VL$M,N`d
*-rHW9qTG;2mNE%D)O+<3U(UJHMhno;QeH39[!W\Xat,*8\4W/6Z.]AFYnD]A?25tFB7sJ&\`t
rAELBZ+7E$3CGkVt%n6F#:W%.P3%>r@mJPWD-B6YlONit@bI%DG_H\f%gGCBKhR_bu)=Xab>
o5CA/4?iS0k>ksQ$]AUB'VWu(tC;gLT#H_6@Q*\!IS_/a,oJW629E(L/!^jZ=/[_M7s/WlGD%
Nuo'kll\VA>;Y9b(sPrT(Te\ouh1#)>[`iNKS)FZpEN'j9/>NsVY*auP;WEo7#dNf@3/`6u5
9m^GjCY`2*X]AV.hI5YshHVOj?Cbs?qeRkMAg_"1'7@6aicm&mHlrN3!H(EpWNAI\rj]A>m->+
!,JcOk5I[]Ar1iT.U</Nm_"ZF,$%[-@H;nt!V0t7k+6.m@T^>[Ab@Chka8Hpld-:3Jod-Rk`X
\tmulSBLL#']A(@aLSa6JCS(E%o#`3lIi$Y+6SE#EQ3-Wc%\'k"pqTTb2MJNkJ[T4)m5R1*ab
a&fj#FGZ_Kq<mZRb,h:Aeop5<d0$?eW`$.J:TV[Nlk*j]A)cDIp@Qo/HjlY6p=>'Uo[ARYLPT
?c0pd=,ormDkDO/!p76e.fMPa;T-3eun5WAdYuHq+9h+?@!V^3(.DCUP1XqJB$ZIDol2s!tS
*+X[qlY*^m()!]AllTM+HJ0_207+t`+b;)-7LTulZJUriA_[0m6>mid>H&%QtJ#T;T5le@0GK
]A\1:8rg'Qq"/7R(2R*0IUhA>8',X;$a:BUqr5uXga7edOlUkG1R:_nPW_P@SQ!AnLqFB.FbF
<%97P=)=''h6c)g.>iOO\H=g(]A+(AKe);Si<RpN3m!r9`^G/NWJaVJ2<'+ZHr_75'fA0@I+;
6_cqtS,\Z<[d#j(q;>$gGGc4_KTa(?akla,>Qc]A[,+j^Cmdeq0%s0*HiioGicmt#u#2h?.(>
Sf<"l[eUlf]ASNAb<^cD2aBGMlG&e*)H^i'#S=pA9Z3F:9Z9#AA$T]A"2XaqXZH?4jbRoH31C)
hT6>1@Cs,tY/B/72S[G`KbU=ML#J'`=bTlcb#7p0??D+L"d##llX^YVjPSjt5e+D@NJh_Zi`
%4JqEOEgSOaH-3L99&4T8o(Mr>]A8lYQk[@;J-I5S;I=8&a#J2691*_UY8^l3il(kdOOIuL^E
_H.Kd:j<GB6h9SflR7\tX^(ml3X"`UNKlf#LJV;Sk>rG/.hQe+$mk_b>\*g9!I,3FhJ*5!O]A
cbu+E@'uKqCgtACP*.+'CJ<D>U*U<o*j0\ci6pa2_8+#-?E\S>c4\mQ5aBoAC1FY7hOLtJDT
DVI?Iu+.m\?o7@BG`%agL!k!t'aeLUd`img->\*P]A//lKhh?@&d-nG+7OoM^Gd+*<")&FKRQ
*_%0((O)[MJ^F0hg[Y:>fAkGA<XdLp*:V,$nmR%u$8mW98,i0f\r?"a7raAZ&Ij"QCkkbf.H
JS$SYutRAcieVjN[!ItZK.jr<>40R37PjC4a3ppHX$Fk-M$(#K<"$2\oHtX\ep*^ggbC4`qN
6HL)!,>K##R3Y8B51BfL=sHpY'/.nA_6`1tOnV1SEh'om5\f(1e`e_^s7m4A5e!DB6jWNl@k
aMJdJ$KY/RW2:[Np2f(C;8E1+DINUb8CE$/)Fe$iYj-Ut.fPLG8@_C$)ZcT9s&XKEfupLNE:
f/MDPm>mP&s/**lj.c%[DB:Ge)'e6.IN=UW9]ApG,id`8ogOWgM>7K\)@u&h6Wci.PUil#=jZ
6XbB@]A*<50E>opGLND:O.*^nF`2T((X'Z3_0gLuC:@f`QC;qPf]A?F$CIc?l^i3T_@CF5QYUI
,u"o86RJ,pQ$kH\(LHHT5l`ZI'mA#5SX6?g;<(o1QSVD=/MYlff$Ka`JCSpO"BlhN.gCf*K[
TMegU#@FC8$Fh(kIk^"`r&qkkJ*6&Vg9g1I-5UZ0`bLIRRlpje0flT]A/&!O2-Aitd5_B@Fs5
\h%[2%YagO[CD,*`9/q[("r0uFtCbn/QKVZW<\b(DP*jpcmYX)F!eg=X*S\<*RFVog+So++<
^:_XUZH&]ACGr?5_"0iP#@8kaX+nKid[]A]A\Xl-pa5Xd&SO<,`]AQYIWfm%92`E'OR&Tt(a;jm*
6W;cI>e&hLice7,n)UaM_]Am"$@Ds8Vm.)[P:KnBIu_"H#^;f(1RQUR!@O2qec"/DgtrmJ=(j
V9?4N90*cs4(eLEKhX33SS._.4&,^4M[;ZIn8.VQS.!HlbdnVAOUs*&#ZU:\bn`4lMd,c_df
rsM7D:c`2&agMEe$Q1:Tq^%$)7X-ZZ^YrS43FFs*<$nGfec;47Xtk+*:IJS.sFjMT-G49^@%
h@tPG=Q*\"@0C^F+q87;_QEk9MO'5mQhs8m!kbAOT0R+4=_*J86qGGXIl,@2oU'i#T@0Xdr+
IP>F[c>&<tB_tebDOQs$&h`Oam&:Mc:kk*&AQ)@$4k"7/p,ZEqs#"T[Mf*pdJo_?[V+EEd.&
iV&R5ET,?O/");$b]Am/qC"F&]A(AL%:0WD[$iZ+?I7K6CTHP&=Xpq)9((3a64sU&f?81q/=7o
VBUZ=8UF\s!M8<`TS=Npr?@C9c@qZ6qP24TsU.2l,c&C%dX&bkLH-Lobu@a&EFbANnU;X-k#
j#JeALuIqUFlMkA\lcHX<Cnjl@Ci!KaL"CG80M+0h%,/f9\<O"Xg(f?k%F#d3dlD;WIRL+)K
PkEKmSsn@Zp]APO]A6Vl@ZGd0%'E"_ahAX-g7q_'7(/bS;'4p1=JS!6kN#n7a7cFM3rDuE]A8?h
-i>b"VjK+MET83>8JSO4_d.2]Aq9t^l,tMgAgb/94Hq9&Z)7TO]A&HBF7X^Z>_a6EK/pD?#qsj
:L+0k@OHpXt#Y'_BU@>NG>!:b>&q@F"g94deF;8P0PMH>[6QR0=Ls#XT't7F28#gcA";0.6"
Pfo$'+U2lrAU%!OpGfU[\rM9p)("TH4=+T;0n>!nH/mf=Ri`c'c5u7Gi#WP0*G15;nP(IU&a
0.lg!U8c:P9`L6<Rk.pm<8;)T<]A?<R"Q@NY[bG4sb%p)h<s0:ZnR.ceRL'&phse(Fp!X[o:6
AsqMCgeMEQ#!$IPY`<3tq59G`-]ACZaC1PlD>^_>leFW0)1O&5pgOGqR6i^O+I`FrPi3'mo#W
96mZ([[\Ol5(,C.h\WqR\D)5*gj(g"XZ'0Wp.q86EGF3Bl8)GVI:0+K(>#Nh"MBrD2K*(%5d
uaP0H28cr`)-hb6o!C8:r7**7g@s4=2la14b9,]Al(:5Y2Mg([Wuoh3X",s8pK[=EJP!"fsXV
e[TAGUZDWiD,,spueSR"A[U>'"ggDJpFO&H5NS%OZ,ROZVgB;[bG&o"S"GHSTl2B7ld9OH(i
^jk!ao`.IUO)`L1Hsa>0),_dCS*.5QSV\6*0jl]AO2D=3Oj8/TrU/X"uSUO"f\@0(Fti;GeJ*
UMD(3R2]A"b,*&8PK\Co$%L.IL_Fe*+d&oo!hSd%[/+43_.+8R[Z;LfQQ;o3-lYaGBD+=/?Aq
`SjCsDGFf8BfEhq`#f1F_km]A#BD(G2rLCA=-eT[!h(@FWtpN*!9i!l%]A^X)Eo/KW/Z=s260,
-66hn*Pb^F6fH4[W:BpqOB<FY1922RG\-H!gU&^@nS?k`cF`EX-!`24]AA3su/m-$fPjAiia]A
+<aPhj'[r22KpWR*er1E:Wi',]Ahm*&'F$h`QI!j!qru]ANC9&MCbjDNiFUb30n)=bLU6p"1K^
tn!Qe24PG@ZiAl\PFj)KU8iu.QLd3@.7r]A!$5i(aWB0cF'eJ6MT1Y%F7.pAsV4EhSRke5\Z5
RD:A/#6cs]A7OI_T%Xhb(*8i2p?l$c8RRiWg;YT#g9`=o2HB!ZJV6ICS6rf&F+dAlb@FOH:^i
.T..E[1eV<J=@gZDGn."7!jq&G=[/\U(`$Y5pD'&>rCO2r9icGWhqTV@1IhrRK=K0l/NhT)B
[B7?!PM3omlT.0Po:'fSEK/04%55f$tod!$Y'H5A#MM6_sluJA%licgoqX.p3TRk=R$l"Q5!
Q\T.*!YYVnp?6(a,Jl@HbT(/0kL8.d3<pTOl4@IC=9"g]A5O0Z5:a_2*?UoIFpk%AMdIbB\-1
)?^!8kI!mA<JBK)5*R4ZN1R4V^L=Mu\n,R*9'cYi"."]A*\p=5^PJV'i@<[INIsDr#rkfiK"3
]ATi]Ao;/7'!UUK[%.qLIj"C0#%#OF;r4WO5GK%JpEiP2:!llkA&!$K_j:dUmK$-:-2;%j5k1f
2C$r()V#n'/dEYVJF*>QtF:^5F<4C=TS5e?Q,c$X7nLA8b;EbE/^Y\V^'a1t\]A$]A$*Zhak%(
1QA3#4(+dAM=FT(Y4ZseA&Ja).q]ADp6fUk'#Z7,R@(%JD^aERB9AXrPIfMM6&f\DADo;hcsN
QgD)P,eVQQ3O(nbiT!4#-M6*(pJp>0%u^:Y%6r'oF`X%ntM_1;Y&Yn;g^M87`-*1#"Db4+!g
L6*q6gnH>76[4a7_*kKs#k#sNcHJ3P/oB`p+Jlibt,j)Z0pail8`me+'mN1$of'pf-?H''0h
Kl/`</0>Q/*%iH*IiU,"SSg:s%kj0P2`=Z\mcHE)!oNjbk4;LDRt#d!E-cinTa!o[6;'oC$E
9DXDcm=\F=W9-K@KPKE39O9=Djk,?l,C+Q%+@(3=#`^nJ1J)C7?%3'HMJ"*cBdq<;?=uo\(l
=@Gj:!'U=uKnO)!VT('1;L0HZjSNIWpV:b#bF(e^KSCo;,kB1./]ADf)!OI+m-7?Pp%n*J)4g
]Ai%3dsSjM+_9jFM05C"j@A%'FH\R'HpnYD7gJ@05AE5:n![<;D$uu7>4"?9\"#tr\3\trh!Q
0l&GOZA47n/gXjcS!XJQi`I*SZ3[l4\b<iAumV874bPSBTifV:.^`@GL!)eks'In#m;:<7ml
KbIABolT5s35H+L3bf`)<6p[4M9$M`'.Nsb4tL$G63JKI?&3GT^?]A17IMrl;T*c-u/)0$AgT
A@H1#+<1UY6l5Sq@2j8?WNARZk#EPn$68@7ja9r7b5lS#r"/WO'@Rck@]A5"<>F,:q<L6Xf8^
W`_(1dq491Q8.!qL>+:!E&_W)0eke*h4Wrbe5-M[%lA>SAGBIdKJ9_gUa[Tbk&6:)?L&^1#A
0@gG4L=O\^Jpl5g0-aM57:LIUe0)1]A7\(Alfmjs9Ts78EN<t-@L,UnXAS!+X%tGH=;!*&WoZ
U4-+uLWZ@9@gY>rNqg]AcR38i?n-dRRMZg:$,MNM%tM`8N$qXGt3hj@t`HkTbm=+\)0HfK)p/
L;I]A1KA^MimH;Tc=9=UDk490`-Z5^L&diBnVnE_5L8R-37,l39qbsD%p9/k7ME$NkoGBJ^Rc
_(9^T&`P[GmDC:F71/cc(Rg^B\$NK^M2O:$4a)n1oS%GdGL[CAsPO;Ahc8!J!bn%n32*HQe=
>3UXZ;hQm+H\cRn.&;2>cjp_(fhET;pHto]AV=)(T[X"9s/&_:hh'$&#kd.2<qgt%)2?l:1g8
ruk@PuHKSAI7uQ-XZ%S[YpAdPl-sMj"(dDR`aXBNJoi%XH[C9o,tZ1_B'71QoS%^7qW?`eU2
LgdW3g!k#[^#ETm]A$UJ0>F3]AY"&Fjk]A@2-Q]Aq^NXsOh=.A$7B(N18]A`p,DJ_nad8N]Alf,OXD
XD%^0(!`83D$PL_R7BX+5%GP"oBa_E&`WBdYR^)k`*'mJ*]A@r@XSOd.Vo7tmR!Oo/3Q?Ch3$
Y_/>*K2qM8JNr&_'8Vo;pVRTnGH#'jI=!qN50V'75R0JHAk_PXjOg]AhYt)gIZp1>-C0dSL7i
8CWcA4r,IRZ2lO0^.=]AI9ehNk]A<6IN[T$EstKOgaCNhiRIh)$-ZBJr4GI>L;E&ld@TJEk4)a
sq3(aV%=DRT;^h^o"q?C!%,-[!Bpo<H?40b`q%U0"8`$d2>kaA)6l=M7Vd\)LU&2eU;*)n1'
YW-ol6I4-=,jgu\O(aIamtl68d`:r5"UJPJb1.&$,73i9]A/[#lHQ6C4fmXc:L&eB0>3Se*0I
hX]Ag;J9+A1o%2<ikXD(F?IF;sS_HXd4;qsirZHo^rRM$ZJ?a@PEKI$iYesQ`XogldZar64H'
5JMFO"15R'`9]A?am`[*]A+]A3'.[LU_^nfcjQ0-XU`#1'HS00C6>+h\cMCfK)GMU3B)DF@qr>e
Eo3ul"d[n#l1X@f+#pqO3Zn=ChPt9h9<\p/bEPr,;s8P'U!d#g7HT;4j/HcYcJ'0+]A(`UEUN
k%m2ChN&_!-sVJp"=S!CYmM=$HVrte>ch5NH"VUJn>W?-4Cd8Z5=-f)6K$'au*_Ug_Yh=YHA
H#ljdHp@i0[LYnp"63s[-*HsEis_)D=6Qcl_XVmpe/L.Uk+2!NrAOF1+RocqB'rVhO6Kp._7
fK9iE[i&ndlk5B8S58641o:uFcWR&>n2-KSY)BBH/<]Al]A/un[<e\?W;OrB3<'inf7p1enhmf
)Wq$60gF,0n%E3:1>mXPZl8(_)QkW;o0?JHLV9,p>Vq5??\IS*ok4)AoTj\H*[M=o+AHDPN#
_&<JQ`'&u#@!0bD46oCP/JCKLs4,luN*FfH%\cO^$1U_AtKY1)m2R-1.Ijkl6pq)tjeR`:^r
!GB!SGu=<hkltuAQh;cfc_]A4Hlo')51mF)g!4I20-]AJ+K[?L=PbhC)a%&;76d9X/:R5N(Z\f
o"B@>p@#,nFd&f"7,&B8]A1]AWHsi&r+QL*3(WVgTM]At2Y(XKVS\M,9Je+@/4#DBY\=VjqEEn+
<gQ6LdU#?4k"9e5,:MYq_s^kbi%1/eKWaiiXVAKu<Y<N@'7tI)jaq,H3Eft3OGE:s&/&GKEm
HgKAGEq(85]ADVgJGg2NCDQ5l?Mp9CXM\Ain>X$X4JltKT&\(rQVK=?HqRH@+sb>28a#H-C@N
&mAgX\(og2HE(mf@+Sor?IYX0Klr!-SI?GP!iB>X@o`F4b5:buc/qlT\q*j,^_NS>R>%#Q3?
MLm.8c%,l+08nL[rL-(5K@*M.?*-u;q6C0VBA;06,>LZbia7JRn++fM_9pOp]A%Z=S,cBm\!q
O@&:D-%3U)Y8?!\QC=qT5$H0eV2M5H"Z1>4s&BXZBd$e6n0U'Kg;4B.<6p\46'aV5RHiI1><
NW<VdHlHsbNZ`iaA&I=@-J$lkh5p_Z'Q<F\o\#f;Jhp#ZK.WjH?0Y+$^_cH2E,//7N&<mLC(
Bq$MBYSdeeGVQplZqsYeg1HWg1sWZa&!>WC\k,6IM=<G&r4/[k99'gQf(E-g0cF<3\`2E^TU
Q5)CT.:0ZNKQ]A9k?n5Oq&HIVhH>,njsT9=M35FcklRYhWR\AQ1=auAO8rlEgiK#H%nPVBOns
2<Eq:()&o@8\;n7-OmDeZ^]AJ<2:D0MI+)p=tN-D-Lh?@=ueRsI)SSka6_D&la.j-n)robhi8
d;gR3C=)),E'/1cU748]A;N36Z4hU8YnRBmuD2&4r<OY':^[2I1N-lSB?b:06Aa^9#bI2W@SM
k/T(c_u%Tm%HD1,?_#W`Cs\pq*nR!58_]A&H6*_AC\n!0Kc4Nd0Z.?kl+!eE(9p!1O@tsBXq\
5RX.AIC-#X!XHB.OZRkg<i!,tXN`HZgWN1lX_iKp'0$T3ti@%_/uC?30WJ[r]A`83qJ4dfa/6
XaKSaZN2(.4*VU;S7o@rMTI-_6o]A\.n=0LH1,Cj<s?DHb2eRls[rn7A0`-[PKh[l2l'=.97k
Hhp5)E0g?POD%aq97MUD!Q-&^t>8f($$Do*VQrnC,O01S0ed6Mo(-%#g8X8);4Vb8NV5cL5l
^2<RTY<q8WFo&Xi&[r9kLl4]Aat?Ni;Bnhf&<R*HT]AH45;1CM1E6lW\<#L00S^UfJ[b=:.>uh
U.:E%jf8<k(&-b;'6i7Na3Mr<N0b2Y`@nm8+t9dBA;ijo#iq>dA@C):cDq"2\o5M`"-S%T)V
[9[KFIVPA3bDn<@$kp,`Wnk]AR@C-c5Q^h8+2obT$=>M%N"$*V\O(V7n=Y0#!r>9_Vs,GBqdi
\jC!`5QDV*%Yuq%P>%PWN#KVfU2*nPpp)?(s-17"@q`=OMkn\<6SYo$VJ"Ui._XD$A(K$YSm
G;#i332`4-L?s+MeN5WfoT@D9i'_U&!JuZ\!Z]A&O71q_okcQMXUaoj%QI<V!qnHg3R4R7XFa
)g#!uqO1KNTIB"+[0-QD*E%sM1SUk/VD\k`:5V,nP<5>Y-OSPAY7-:#j'BKBTn5BZR_).XNQ
\[qbB1^EGA9.HS86-G2amjeZq!Lj=o'lr]A:2o'0*#X,mqfcRV%'Okg7j1ii,=<WDOm',+I4$
S;o^,\Em4h:\,OpN\e-/Eb7W`,T"+?Ndd4>%eu"n:<rY6D4d%2Dq\bHcJ2V=dYB$Pgpa\QE]A
`2DI%ZoVf&)2;KBlF;FEGER^drlnO\:r3K"(EYmb\.\#G<>^g^8`\8jkphoFXWMmi=Y2>e5S
^8cW@Adht]AaL=VjgO4VD#[6q"Lld).br6+_tTpI")2&NC[l>rXrd]AEP_Vb0q,u[4^@J@V%N[
`JYo<XG?<e,7ir<tfr"iR<!".d[FJJY4oa[s]AS]AUX>!M5"Sb``J3qE3>=k2*>;T^_sn7f`5#
6YDhI;pW$6CcNB=#lM;V2_'JV>JMq>B5$.-O+V/XFcgOeXR*lE"lZT'@YM-^S_(#2a^^ar.)
&M?JFqX"ZWX>kYUt`G[nu22@5H^;^V2lRN96,VblVdFs#'E:k#?A@ArZqk_1t%@fk!V+I*GF
D+'g&AdNT7;q,6bGDl6:2%,nHg7QFfa:W?`0o]A&B!i>kjU!It3WYtE%ea0:A@M+_+3M+I5`4
5R(;ff=]ApL>9:YeX1d^UT^/qa.d1@_YC>!B'-"HSVdX9mS%I^SR_L/AuRI'Gt=[HkkC&Iic+
'JamkKO4N-4>H@[Iao5,*!G4,)`n0X#B]AK'>%#lH,4!KZhkXR*qA*.o97\*mtD;i4tK;#3j+
Qe<9/hse&O$I'IEFJ$ikFU9_#h8#q(Ub7\+'*A4V'HkO,D6%QPq6C`;qB?U_Lo*B'bfh;A=d
Z$]A$m-'V(PE:58gg3qr>J.s?jAbor%+84e]AEjEOI%kJK7jL"Ab,8eBmH#&Ja/*%.SsRIfQUr
Vq@q)CQt%/Z;DO/@R?F1(i'bj*^N[.^-b$*8J,/Fl=rOAYBc3Lc04aRtW3<u'8^tr&Jfi&J8
dhG>)2)A+:"0fLS9*or'Apa6$3n/,llkVlmb#;2;6NEG%8]ADoVB5J]AFdI9MMb7rgfG5?#Vrb
rs90Rbik="4dIe-\mD5CZ;WLRS=R,6p%f@&E(qPk/'L\`oA'E\M0LCr8a/VWiV.#c'WSuU,E
Bich)P`1fXFb5hZZsq:&?t]AeoicW%@rLdm1bn7c'0[m&_W'dG3%T<n>2Rd-flnH,=@W^qmP9
u"XJ]A_O)`4"=5oTZus7Sf7k-i7G^8=En(%IkZ+"f\5Q597?g,9>kq?b:t,:DrSGfHjn:\Qgi
=ppES*4@d&lHJT<H.Q%AoC@%3=J=&0-kp:TYpXY82,5i721(7MO]AU*A98]Aqj>b8gs5l[E%uU
U&1i,hqDhCX;i,nc8K_RqN`bL!fVe?Q<`cGaO\^8t#VTE4j\4Y"'T7@Hfokai@ZIl2PTig">
Lr5;)2GQfMT4hoW"?`c>XGI;&R$8V>ji:,]A0KaJ/U>m=DqE0'W@4F)In`rnSbelH+=XqRd7.
]AMa2bc1O-'N\=<5%_$,\[9cO!Srrii@IMbTI\/4MVG$TglOPU@Oq@CJm=hAsXbmqJg)CVe-p
OXP5*jig6i1a!W$pEXHG46,,W7H;`Ng3RRdh9h==4IJGGH18XDW]A+kYPgbI/QU66pc^+,DmB
X?@J1WI1uI'K0CT@T;=*h6IkXU41%/u,eJ;)G/P7\;G?dUW%4`[m9--:G2F\ffI(:9cqO4^F
mWh$E9X-W+"<QfO!./.oQ5qYO.&MKJcQL@-2,J[?]A<2#iq7<YWmG?'IhD_R>_*LpjQ(X?C]AY
GoH;lNP\<Hh'm<iubHI/O!9&Md!.sXqiTKtX(C6p`(>;o-GhIO5j]A'/GMER[+[@%DY^Q:#61
9/"NqCo*GhKTfZRI?OH:;Ju;4q9K1PVA(\6I;]A):*ET?!3tpT[n)8r=:O_;5RWT)5$g`RY?/
dW0CW_E-"'[l0*Kk%UZqY[<&&$nBQ!,q:?1'aR\N)0LrNmS;HS:g.gscb)?Pae_Y4=aJ)hbJ
Hn&^7,FNbh,*kcbZ)bN0OSIj&d(/CB+-Q7?kP+()p0#NO6Pl=rkd3ZE2%GoFG+(1>epJRmS0
RYcZ5UXPKM/f98f>GZa7??kGI6mdf3?2?k\hWaRP0Y/tEc#[Yh;T<q]AJ$2)I61F2L/L`qk/u
fIbgo^V_#)bV-^X@AeR[k#7S<iu[V^+71UL&ijrPS0pQ7)J]AJXU(R;@99gTpG5%QIP!0ifiH
l.ZPAH$D@;:77B9(U"A92RXmQ-&^/k4_@?RpILsS3acn_8RLuU:PkL[I_TQVNqs%08(9BM5#
ipuC;VqIX#c`d9hEY-i"F4d7&5>DSKVl`dIL$S@$m\,NSc4)XOW\dUpa9Up[8BM^I+tBJt]A\
kA[5D!f!\ESfP-BM3Tg$XgsO@2OM7@n6=kI+[%;-N:MP/6d-1lo^7dGY0oDsa]A>o#aZYn"j2
gGX,C)VSL7:hW!#$<6(PA:qf5=jlohpYT_N0$o!h[CO4FV*Y`01F<cC9;2sh^-!6Fg5.qlkB
TYNdjZZCeRl8]ATPKP&E6<qA]Aj)1dah)%h`;AIlMGa"kHKf`cSU32UP&fuLeh]AQ%:m-E/[Gqs
>,Br!"$c11mprSDH,m[PS=GjOppIL)RI3]Ap-_aNJ)0Ri9$RSdW\6Z"E-5)S=c%deSYib@t]AY
j%/3(s$DH@NJao?A!D`"j?Mb9CFBZJk)]AotTb94.tD+LnAX`d2RZ4,bc1j@O=q*17\46'!b`
QHFR,6+V9k[q@m+SF`C6C#^)u@LodMBN(Na<j<Tk^[`Y^!HhPb9JtG4ql/#eFBhZo&K&sZuD
c)OsogeB&7:\.DOqn_C7FijF;h?DB\'onPBd5FmTiP)J\)Sf)pqV/d<mNV)HJ29/mIdQ,?K$
jVD^3LcjH\[54f']A[8qB%WUQW4f?A1udXEf^4NqHZ,Sk)25R7p+^IKsuH@OVF.B<=//;^2;t
1tOHMr7!H+/)pKgq+EVS%f@(=U>ee*3+bNi1YjOb"r#lK\SeARqlNbjkhQs%Yk0f#64FiA5!
A"]AT(>R=;@9dN_c1iCXrhK0GEIX5C["LJ48o!R4Thj*Hsr1Ek3U^S41S$_5.90Pg/E:'XdjG
Gd_!u8h8LDbg)''T^\,fcnG=TY!FMX\H(O+rAbKZ&Ks$q&P!&03/r<$Q/t.+\f$XNV,Dk4G$
!u3B]AOcbNTV+heF`lkl^(Pj*q_tu"fUX2aPS`34g0r`')LXf\:;.Bgp0l.H).r2W9+/JuKd&
a_)u1&U5cZS_!)%3InSq($hN7<!'.`_7deo?Q+I?4OTV/Ae^9GgFgb>WlogK)SWs@u9f"=,Q
ih_t29=3H,`C+:pX).ZO>;T>-&@Z2Tj[,Xr@#$[!\O71'A<u".:mb,53T/LelMIX5&GNu[,W
:k\/30P99QbT#8URJ0WW(,M"&c!bK)IC/(V0s#@<L"c`upc%:?FF=Z?kU/6>ZJHKOEG0d*&;
l\qt@`eFsUa$+m?LdZZa_Y;L'2p)\/?45Z(D*?BGL\[F;,WhY6*((&ZSIT>$%<*%0fY$]A_`>
3\B%kh%^uIMC`nAb=4R""l*NiK,mm$)C?f?9M,M9A`lK)6+Q110SX9EACm;&H5k,[6YtP]AOt
A+E@=Y;nJbo>3mE;'HfZIf`CsW$>Rt;ZW<2C^C3mT1QT*&FIhasp%;7c-To&Zo@l<?9;)FF!
\__5WhTn2=_9LNZbfr#q/C[eWU_&q;7\%/13+ZcN65t2pZp&+\_bGo]A<4U'I/nT"u_s*ggl(
[-'%8n=GhUf4`]AO[&!T!tT[F4?=2j`#@mhWMY$]AQ'`cS-+GHPljap8]ACVWC95Sls4dgNp+mX
=9e@6tZ&V14HWj,flP#Pr*4`WQ1gP!`fZ,6klb'8Q)FG$!mQA4g6sU]AGVO2dfJ-bN.Ni.p33
g^AS4VD,pCNJ;&Vd*$H%gcV/"O$r)b$-Cm:'Q%+)?[$ice4#rbO+9F*Un!Fql$-JC2kGTr#J
R=*6DVX-[KQ?C`l1YhrK6/F!l=\mV[.@R/Ge,HtNgkrGQNT>;V2j39(rJ1'J4`Y>9p[2/*A+
dk7%O.o@X'Y9k$$k*AV\(Jb9W.spXG"W[!\NFbCd?=Zfh05Edj/PZ#Fh>ibo*E,m5O;TQs0_
XuYg>?+K]A?j1M*d//"/d"<+E>t_?LZHT2s"u'?e9[S[]ATCgoNS2V%ca_$.e_>;hfnfX(:P`A
ua8FnkVm<gm6MX[\L2I3l<l5`U\ICGaPuC<rAV9,NersuiD<.o*,J#CDP:"(V'6f\IFnOb)R
UFGSUXYHgch59)%FO":aEEc7KUDI;nUGQ(_B8^3d5lc)L?i0eNF7/j'0.MPfUbE'_a%>,-V9
T6W>nUK2=ZcMpDnJ%4aKV.d4jl*:^"&Y5+r(.Y9HuN*[K9eoX\`#F]ACgpCt\)H%sJknX$$$n
#FBiHR"t=Fhc,I9<aA`=l./&HC!d$S[;YYoDE8dDX/cSs60><\,_Y%*_K@H=%gcra6CO3g&r
sWXc=StA3H77t'8FjtU/=<Vld;/Z$)9!EdloY#+T"MEWjq@Y<&$241]A(!;]AO4is:B8sqf1Ib
N2YnrN!.cn]A'S&H)Gf@IaLHq*(JE*s>B7$X*O1f?2#"$?l'j*Yf<SbKA%,cd68F#aJ]A7FF"#
nU0ab0'0J%GOIGEe2?dcLppY@"3gL/X97pStM*@S.+q+hr(s/Bc\KO_s/nH:g!?$]AdZT4#hn
RgpDZC]A7alQMfGiotQe9AX`'mIDo0*gCRh5Jae*7Zcs4OmX8E>*,g:*.KEfiJ4p)p-6lZVtd
GiG=Js/mM<SJm]A!3[KKn=T0.PB(kOU.o3-:U]Am)^DDk9An(W>Vi?ugrs7t;9UXPi;!p$Rnib
.#!_Qmishj1,k;rS$NIdkS]ATW>/-7eOGbZsM&1[7C)]AnY+2X*,>ckFJZG:0n$_t/V<:K]A>F0
U_D>dX1K[SJBk:gbk3&IZTLRZV\\:G>.K?!+/&j?bka<Za+/U7*:KD6AE(pb]A,4U#U'2f)-=
hE*>RG0Z(IsH^L8N3cNR!eB5Ek_N)k2R'4:jG!Sn4.0-kr0-4q=Frtmo)WDEn`1grkp&9geD
ec?JQ]APRTVT+;BLnST(O[t?6[X+p3X"6A4]Ae*cl%(A,la^J_b3!si9a4E\t,$jIYlL:khIaO
Pada"r:7#2)RCtOL%hX_ZdZCr3bI4)2e(4@-;0<3BA$9tWoBd+lNbq]A6qUp]A0+oE(QVc(LN-
082mjg<f=?1]A7E<$g=`c!C(8S4Z".jf$2'2_=C.SE*iqhq_kjMi&_9!ik`/:;V.!L,iA?uA.
3c@4Yb@u("=f5)_=bt5!HPEgfJ&X.^rVI,!nEO+=hpBf`P.IpDFqbcQ\W\8XiGM7;Ff5'tPR
7A<4-6?;V:E/`R"TM@@3!llHYkf*AoMsl:<umW#%u1(mA&s,1f8N@4#WTVdjEH,2[F>*LO<_
&Q-*B_hRQgJ2V&/_(H-\>Z&)TV1\OH#DPd]AIMVsFohG@T4:P4u\aIY2bRIUBd21\BZ'=4SZ0
,^$dGkX9&uSGkRsHW'bhDMEUO$fp<QIVA?61l6!SaQE74(c990F9V\7os(B'iBu)Prso~
]]></IM>
</Background>
<Alpha alpha="1.0"/>
</Border>
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
<IM>
<![CDATA[<4I'QPAqO"4E>O:N#!*A&4ZC"!Ke'mOCluB.Hqg+@RqAYQ\;_fN#\M=dRYTG]A)0D.q7cTMhW
q]AOfWjJnFmldqY4Ghm[\aB\&Vp\m!0F4pGch,K@"SI[X?$F\qfcKQ-OBg(&Lu>onp90WQjfW
BXib5D_K-u[pd6Yj&k,lI7W584rEP\m-lYan9CNW5<XsjR@XgXG330blD%Y>q5PR@QqEE#&U
s\s#f^$i!ibk\uWqm(Od_'c=63IZ<>43KEg-+R[$F%cKE@q0up%cAQ"P*lqH/p#4rbY$VpN;
kV]A-mWYplB.ka`H]A@:&_$co1/!\WrHi%jYo2%%R?prj[.rs;WUtB(.,7NIk'FE.LElP0GO<W
G4LKXGqWIN-OPl(s6;JZCU/@:n6)XalEc(\P<$lYl&HS^@Bg&<:TpI,s)"gi'F@kb2"em]A[!
t7\5]AO)"k_'6l0K(TJjKFLA=(=>fB`nM/MqqnJ'[$-UEj+1-E.oD-H\6,us.@?AJ&1EDD@r4
:djQmqqkioXD]Artn8goK.-Jj59_o'<nr:43C'.c`\gu!m'=()'.ae39G"_<qAc4O/-emAdq;
ZEBLMbua3#?>UGjQo*1+NF<.UjhlmS&H).nc!DD+\e2o)".EHJtE$35;RC.*RQ[hG+G^Dq'Y
AYn_j:s1>0GmqDE4iLt\a*qbu$pE<;fHETjIK_RcHIShV+5k070NEpOtR3)4so'+%Q&oD_`b
?]A&9[A&@86Hc0?7P_L;7hCP/;+ng=ON*Q.MT1Clr[JAn`l1te2*4?[&gk$NC,-^g^U&"3p=+
n\-lfi;R>,GOj577<2Yj1P(3]Ah?+!K[Q'Tq'd#!SEX._nSRL2^G$!jCiUVWoJ3Uo328"h-ld
Ii<fO24tJr8HOjW`r]AD2='ofK.^Tb,Z-Xpm#ruLj<9C`]Afd,4^Jh8fNtqPU52BOo^&9gI<j)
0\119FrpbS@Q'I5LF0Ml^9'grelVK-fA.@S7C&SU,2WV10^>2$ijicj^h3g9n;5`WV6rYFuN
*a%-DdTpS_U/l.`O6d!6>NRS21n7B&ilGfS"E?KU:"EP`<.p\m`t<Sf,#^O4F+L`R;(1'8:+
5a`@cYT>$oe?uY02l);aQ^,KFXX2T*X$n>d.5\6LQLPHF*j$CV(<XDOAbBS4oX!7"I5E^\Y7
UZ)?@#6$BE4?^`*J=n9k;WhUa1<'*D>Y(fpcff8H[Xp!9"uL<A^<"<hN)j<83o:O?4)+&;@H
@&-Mc=LNC&RV3a@-P1_J*ZGWQW'NeBF)'hHO8VbB"8GtE(YQ"]A33KAB2pnnR-c4Tu+`qLCqJ
6kFT,8Dam(2PXUU'-,NdSLK?2?#W,dc3\$1Ulq2T2d(26(.R>k\6*9V3tJ2_Fs407S@i^%ld
l[qmNcSH]AQ%#gTZH<oUN_[0?b]ACb4`fo4Kmt@oA\<3!iV_OAT)M%j)i.S58amT?C0]A8MrQGR
W8P7]AQTT!Ims99*PueLY)X`RW7OI$l"(sc$&=[2`m)b:'Dsh%+-.^r^`^DF>\mKZ_`4CC1_C
AR:T&:BV4$<(RGus"Mnto>^Js8cWiSl0SU9PuQUA>rY6h7Mid<"h^^I^E;3>]A(\_fO-bT7`?
<8R%9RPEEe5IF>iFN-7ss^'0$qa&7eSi3&EDI[9^JbkmZXeWq$Oc"6G*J,&-an-^(T?qp[mc
b"SY"%]A/4aNDm8g%`s$(%3WICsDac%rDjSLIJ;.R:C%=U4j4B!WC&"riC%0<e#/((V$&)VlF
l;./cAu)]A>-N.AuJkg@fGHdM"56r+$?"q1B$a$U0jUo,FOZiE*>eK%dA>GZ2TX"Z"m(,C\Uh
RU"12be<nRF4R+1hQ<=;^f]A8]AHH,7=--)"X<pZp21#XgG$R/V@oKC7UX7t'97i08L[Y9'#'&
>ef):i?L3>>NH!iqsi>qG<r5S8fE@ARAn&M599NH1L^MktQ?5FumW:*!\o+fF"gCfHe\L8&F
d+ffDGQ+OqNS3"0d%.Z).95mp8/1!IH?+>id:W$ck'Q"f"9b@'^\GhfP-8T,M-hZ<L'#BQL9
"`ITD&^JQjcj6*B(pko;D5F2M-.O(%rE8#,uXt[MuIZh*0tsED-Mk5O(S_nSFcVY.PKIVf@O
FRccOl7D>S3Xpfo=c4]AEs.I&h2''gZ,QPL4"=]A=gb;X2'HTEiloBjg>b@`J>7!gpX3k-r<oQ
U3]A@uJY_Z@T>c)k]A)\c./(Y_4_`1E4osKLIkgIGk9(sXFk0]A7WiN:3@d$MYpZOoe78SI6u[H
6<9pK>F]A=I9!i5#m'#Rn)%B\!=6LBND7L#21_A4uMS-&"?>&h55SqqHF5,"h2.Z]A=&1G]Anu0
Bg%0=a",Y+6NCZ--a-@h&2&Q$'LHLZX5kr<]A[X2qJ<>gc*3meVpiX]A-j<aq+aA!q77INm]AWe
f<01A5rLM?oc>]An7fA$\6>k&@+',j@j]AW<-/hGjoj\UG8_L%qkgDHu5;R#unM9;WR()"qgn*
O:pp-q,0DFK*F?Z7]AHm`^G0Qb`O$,`YN*/]A_u4Zm3C28),VoF/t/..NOf`_>8XFrc_4ct@Z)
_RrTKF35(a&J^+qe.5F8'p'V$FH[p':.$s7TPT5n"DA'2SkCph&Q_ADpF\h>l=#Ee\[MVBcl
538Glms.MqN$LY9:3(?9+)7AgC']A->;Z1J+:`mA"Nqr217I+]A9ToWs7fOH\KRfO"ik\`Nd`E
\(rd7b'UHf1Cel[=V1NmMnI<dH:X3g!$dt%n$G&iXoIt@J@'mm\fgVsFPT7nH#&eD45AD@2m
E8>:0q-qkE&?^UhsMDW9>."_Cc'=5kh=.3Za2+dFq9FUfJN/o"d,!c_dsZ(##'=&>Q,Z]AXf\
5aiP5?:Jgc.s&ABZr1hi8u`k@pKpsPFL]As#680Bt/:DOTB25,Va<(DM5?#833^G8[S64O4r?
SUTXFYa_fR-j2r0jZ[EpBiUGoEYVg:&C;?\Ke0<152&+N,sEhSXB/4c<D(]As^2q9QAefkX\o
nXp=%qMr<f-l5RHmVmC"mukL0kja6#n!5^YDGC%a$_Li48JinH$;$\-MMsr[BliCAdAP"RK7
!3--AMom#0aK?*&`GK5!hVm;8@T$K5Ol+Ya.5M40b`ir'SouVDd?Wa_1((Vr;AJH%<;@#j\^
_HM62\K[7b>24B(2N@3bIYA^c0Fn,AfZ5Cc0?3T5]A=%bTN[*&aZTUtS@aA`N,u"Fh9(;pDoH
#d>(8@8/DdKHnK:miRB4):I'V+3CGqFH8H%p2cVW*$`%"7rp1Wao.t.C)f`l)r`t0NNTt6Vs
-j6G1-Oa[i=NBJh3j4/:e^R?NHn>)%JuE=%-]AL)3'nID0_R@RTG+V<85cBV-!l#t*METUr9[
WOX`u`pUi=JsK4.`'!K%RCigi6p2<9mMgSS<H%TNjBlo#?LBbg4.;:$XkYTtPQ1#Qe+aMFPW
?1s-BW/NBVV.plnm6(9W+>$ZjodEJ$4[ZDDd=?O`b&3T3NV\%k4F#!)]Aai3d#=D_$7KC"0Yl
!!q(e"qFB%(>+^'8Y6iNY:cD13aDg@\/JW-)YN`j*"dBD5*&=/RPQa``ak_I?EMnh<E[p?#?
,15>]A%R%_t(/\=a?P#C=K#Ro$2KSXNBIcdIaa[Vc1cJO+bP7FqebjTd=f7E(2&m='1/bebLs
Ta?aV\rLo'(&YW)Sb#970.'^'&Y&Gap9Pab/<K=,k%M3+iZ99sB<K%2GLFV-G&/!XZ`\(W0R
tqLEj5&U&tM2?*>r^55#ZlW%"DWK)=]A#\#6WTrq\i;G&t6,1e%8`Ci'(&h@DH>U2koB&;Z#<
rC"9X.gJf^*W$"GK,l)dKL2cI"^dMGmi;l7&;+_aSD*<Sq7B#BJ7Ba\,">#aLELeY'60O8s^
&/VCChCVdl]At=gbOoo=n,A&q5$>P&[=3@>-uFJ"G[oAbeCVDi1<OTUq#1)]Anu!g\-/n=[WJR
eUUJ97i.0i<m9,>[N7XZSH8KtX9nhl[sH'_gt*3]AcgkK+J/^Xk`cO83ZuLess5#S\[gPl7R*
gF/A:B\jS=2[^U=+RVIQc!C:eF]A!j=]AQRh7Q9OXuQW8u8Pb_[B:PYqEarK-/dQHTO/<]AWGk%
D$!`S0f@"8]A$CV3?5\TX)?qhBBae]AIUHcdkfptHM:io_^'!"g9Jlqn="=%n$(;j(M[tfTM.^
?c;aJeH[*'%)\Gj:J/i+dm]Ar5I(kGIt"faBs2:%OXe2+E:^['&L0)?7d"NJa^=tM)a>2gq\K
!L"\ZZd8#^s.X3(Yq#"lZ?e3-C&G]AaNac"(A&4Y*I<3DrO\)ZD$P6:o.m44?lN;f#^e-ML+u
ougNM8abj@uWK,N?m`6pdTo?F[`**UAlES/Th3lO%b@3fISU<R5u3_78#[D%>FjKoTba!"pj
;#oALj[GH"(t7$!_,GeY'S":e!hnbDCP\J;?i_=+,7p<1.sN<bg#GWeK"&\hE]AV3Ik-V&"NC
os=OI1_EKk_bF54Op/_6_@#_A]A]AbB4lFK$Jfq'UWU%mf<q5BWtoShKpX3fp(!9TT=R/>NQ?F
i'<6LmmF[6d[hfZcrBM&O,U,HsAPHAM5'4%h8DZ9@=*4>jM!3:<R;W2;PuV*_+i78^<!e'*i
"e`a/>"AqCYs.h_CqHu[EeK9Xg;>-AMsSoj&\p@1BYgt$(Zg)RdXr`0e"AJj0kZ@#!qVD(f#
5?q[<iiq0cM;[qGaK6#]AA=L-%u#:-1s4^9[M@o)`m$2[B=*_^M6CD6%nC\S"#oV\>VP&l"_$
F:[_>LZWZuEQ6L[h`t'J<5L7=9$9;[0<6^,:*Kd3g:UqGL`Ig1/d[5D__BULE6)o0\fu`Ae)
cUr>_":S1P2gPRmF9MhFCuGTs`6UkHB-\U$[IED]A]AaW]A=Pc[Ik2r+IW:u?X-=:_7(YjikR@$
r^F-4JSL8f*1g2P/`o[M02oCtM*3L_<EohDAfG*;[K@Jk7Z4m)Tl1KP&WeV&<;TA-<ldl<8a
1ll.KoKnu<'?K'qOXP,_L(F6o-o&CDRLb.Lj($/doD"!O@.32Wl/^lb40%QY@XJ1f_TY<S(%
h>mBQYdA9,(CoQp7Er?DWcC;)>;dDM;N@j4+PrH5RJ_t7C%-:j<E*$(/sbu&f)gtm]ApV=[*P
)fK1Zlh\0=1k`FuJT)s!j?3B@G//]Aqh\m*srl%9kX'T2,JS/@u;9f.FSUXOtK:Hu&=tiAf>:
;"Y/*T_+=_Tce[G.A&>`F00q)O8_+9"p$lBU)Gg1F8=PI>W6[M(k]A9YJD3ADfnp#=[X^]Aa]AD
an(I2miY*<XQ3M\g"!4%>M-K)ZADO%=aPj<.TuSLh"+LW@A6Ekt.soJ<kAQ:Ug)M_(VS,7#^
.WO]AeW:/J+H\HP5l<,\!p1[oS),sU8_f=on^Ek_fBghIQ`$iJ]AO1=[]AnSYS;p%>3WcEim2aC
/QVb)/'k*'p)/e$D?`[q_^EM:90+>OUHEs\?fnt*Jl2G8Q#Qhub(;_&!#JQ97mbP(kbqmn[9
[XDGD@TOZmJh)5+YBO/$O`aak##c"DIEJ%G9ibe>i#>45DTjKPd3e0DOc[+=+=i36PnuDsKF
N0YNA"M\@D4s9&r\g@"GR`>e\$P(eG@]ACQd2)%gRdc;Us0YN^!k3J,TJl%8Z?NHhYUNHPH&]A
VW?%WfH+)PqY1QchSTa7*p^&-'qGPK+hP[[arXpb8mF3!%'d0s!HnZO,b8,!f[V!jd9n]A()@
UC6/c.oiPN&*S>)R(CWGegAj(&a=jb,!EO5Ggi_B!'15'\"Xs2=&^CC"ofpR\+hP4[0dJ(U'
',b=E,Wg`F:hh6G4#-.9*OV0R=Dp+hYEWO$TN(d.jB%d_\V?<5eu$,4W&3Z/A:(E)#@Q0a"j
?o]An+jNsG_X*1F<E>g1KN*4GJ,5p!\,ADA2I;$!EKMH^?+*=27^-02;O4F=e1Mt,)=H<L;A3
%nN=uRbUY*%;b^FSJu]AL0^q7b=DuDH^=WlCO1O@q&UV#fhiY$Rl.Lg2h;;"bnh/[hcfA;M1I
_E0FpM^!>EUU.)m7ajeNdca_!f^1,</U\R?\O-AYSlG?<Ff;[FRZ6=P/M3I>gO'J:<L`I@NB
eJWj(JiQ+DbiU"`\sT="hZE'nWT6<o[@i]A^>+%>RmOQE3S5:4IKkfO%C?#]Ae$6P5/l\]Ag'ER
mGRqIuDh7rXI_Ied=@1np7O^![D\k,j#5Y@Q8J*\TCn9.>9r,tj+H25Imqpr'lS/BKgUYjd1
ccTXb^=TQA+a_;P6.T(uI2Mn5EBjSS=k1t&\Z>-)BtNb*$JT9fj9)@Z7!r[]AGj+tMrJ8n7BT
=bJQdYXJEULD_s00IPWK38u!NpQ%]AA:!]Aft.5^mF&/(_HGI%0s4;!?OE"jERR]A)<]A*"R(=IO
S24Hr:YaY!@]A*k'+5fbB8$A[?sB.eV8Z5P=o"9=LgP;1JX=YdLaq5tm.UM]A4n0#kkJ/aJeu`
l/q0I`Y7\nKK!D1DTU)O"E`_4"a)'9jq(#'\U=YR1XT)ZTkLs(tuscR?tldbP[2FS#[%gStB
Y5FboASC(cV.1^*>(CF"gQ_'_ZiI>W&=/mS\d*=W+e$P&c8Uf_fkL'-tj-IhR-23,WKk+Vuu
DjA1uE<PU,*(LWV]A.^&ead]A<XH]AH]AK=1Mih[0\1CbTqZEESlmY)t9%:`(Hbl;s$T2`dk1Z^&
^8_ia3@s2Krc18VZ&^H7joJc*KgCN]AK[/N?1Yh"e1)A!gen@`D't4Q;aBtrnGLPC"bgai\+V
t,/g5e]A0TR=:7lR1*&>5C.NR3_ZYKsUANFeLGC7[KAqrK_l50@kGi@pjT6$^;FCD3Cb<ER+H
mHn.d)Osoc]Aum]A?qXV&80sPOZuGouQJN#(.M69JN#?-KIP7Ebrb+RuplfQl/JW_=*Z[et8ad
rhgbI4(C=9F>ct)/`)7oN3>qBkUUX8ajjlY:hCn-RNDQi\oLTRgb+Cm(cUjZ$fkH^g?FL&bE
o2W;5h-!Z3X6C1jl$)o?rHGH$o0MsO>=XaiUu@'&2Vpe-6t@Y;W,#?NC?YQ,_nYB>8&q(K4r
'&*@)d6DSq2hTr&-f#n?tJ'NS(_e=U&,WhW[M$$*Pc)WS>8,pfb2?^lP]A;r-n5d4kdMp)WE1
["Oi8'nr6I@dA"[<;O5a'!%tu8M<Fl^1s:+2V(9`YVg\(F.``*XY9JltlIY).O0)T4#EJ521
%)'n.rs8KI_b@=&LmeO!3oVPFW_nMCD"X78.#6l%R7#gaR\6A6;S3#HL-\4,ur`iqVe&"r5L
o1LLKi\7GD0poF#'@=23aY.ZAfPLS_;i.\q!42=G8&\@tQr8!SGkAq=0D]AqWJ/7binUD7qM+
rm4?$"2PFRiffA+H4^V.+no8+TLl3V!UofYV<Wq\IR9rbl:nJ-.-K0$@Aa42f.:&.QWc,t2m
tk<JSni7$WQ#pe6A7B&iSI)r\Yb[-^3r*q5-GX4U*rL2#Wdt&Nur1pt3aG8T2A-[qe```''1
S3,08jRURodJqAMVF$:C9=Bg/OBGtCR&.<C.QYm^mKNFd9W<0c%*g%/T>qB1J5D$hd?k>T.2
%+p^g]AdJD/ug,E'!Xo7n_-]Ah8<5?HAcYiJ64JE^KL)</Wu0r!9o]AM^qNBZEbO^J%[>A##jL-
PK0YujRg,NP[F$B9@1(b42*O\/I3ibQUC-TZ1eGJFX/nVn\eXTMD*9=]A`+#19\F"kkHOO[Ie
f6\:%2V[KjL#5mFFn1UCJ8T,ap"LWA\VuO``h^Z>!Cp_$[e$ujf@0EjdIZkCQYe*87WGtPI\
G*I1t`,[aF:#,h=a.QA3:Cbi`.bm2iHjbr6-$2R*L`5?;nu;rK3m(<q4YV?rrU:3f(s>ju.f
Bj3QP#LYEOO[qt_?i,HRCs"8B+enF3r)<)?1H$(&[[)^Tr4"20h]AHXMp+#8WYY+.LVM/.GK>
:-N*"'$F+5EFF"&?Wr]AE&AbsBFYRHHoa&L?jM]A60Pru@nID;6B>mAZA:7oi^b`g4m^]AlZo/m
;_>B-PAW(MA9n*((\<N3V,J`m[;\-\5L3+$(MfY;]Ag*:^F]AG^F.f!7Yi4@=>$IkFg1DkMf":
^0_<H[W\7re2qRs?c`%"_g>Ht,G-rp9DaX8Dt@7^e/jI:b\<:X^?k*M++hIMk=.Y</^WOuMR
,&/+ZbUKFSqpfVt7!(6#7UP\_Cm('LN-&VQ8QZhjTI]Ad>ncmDWV'Cm)ka__3TKP%m:GP!J6J
PP8@3_k(sd(,T^TQ*Qk3X^0A^2UVmeEqlYDG1ctF2qmSYNS/M<K?*W"'o:UNrB^QTq9@NB*L
Z3WdN4+3rO8Wm6[CRs<BG*hkF8^?%O90<X$\p&:R9VaJN@`j"mk:2H`S_rt![t&X*#$fE'M2
KX&^u/lnCs;;G5b3jbcu^hM'X4i2apieDdZ=dIHLpq;W<?/jn@8fISl&8,_RX0g_jM)oj,@+
WM1$-1+0ihF0qWg8,=D`^!lm7RG8K`/T;SKUt?KjM'in(j4#0I)[Mq8+b=61lJP`Xb*W/<$g
#K8FmBJD'-"dkLF#a1P140j<SY9h%J5_S*4ctB_M8,FQn$g3S*JUC)KZseie@jfEJiWW1#2C
bGN2!0LZU[Jpc?oH,o%\PFc:>I8(!SSD4G/i89o)JJ)tH?)tXkPIhEb]AIlUl<2Q@_K^W3pXX
FJ_.,Z!;0n/V;8M_fq;(u_^-V!dr5j")2EiKFB1E/1f1%?F3Mh+BtOcgE]A&QH"k7=f1+P@lR
PeoY,P2\r+0<E=$RXO\#:(7gVbRj+?AXN\%/<kOYPNMloFn'BU3[^T??_,o"^`mW9s.AO4DN
]A7;2?1OGClq+S\:&uB/X.]A-n"\9N,+Rrc?pZ.-I2M\F`UXF%,i(YEr]A9\queli$5o/7EZ"`p
*[o%O(QHn5EN$./nOdPbjL=P'lqEqP6W/5`\P;TJec4SJo'Jf9>3KN?2:&jDel7A02A@[mk#
,R+eWWgX9U09/f=;p.qfJORaYbFJqZl?6;'25K1bJZ!r:(9$Q)!D#<S$m*ojhm$V\3Cu=U&D
#EYhCuoInD+ea2!k*]A4O:YZZ"8S<TCcjf\&ZW*sWte`b4DTr&qV[BP=EsL1ht1`M[M\?h6i2
f)QK-lAl'=!E]A?.G?P,FmHIhV*-CMFLiJUmV8OqoTk:%%Ck!h4&OiU/8tr$lH/;+\WKO1=:?
)HS4KVgZ_3]A8lWnpe3Ud8`+:SIZF[.W/X%?e>,@!c`g%M/mu=0Mu>ddZM*WB,'W3^A=o)l*J
_(2Ml?ib7@'?AOJ*kAl29O[Ka*%6f3^1OltBBN&B5h8UHWB;8Lj<jU.:t3a::0.q`Ot.S&e-
-^;VbSb\Jr>N/j>Tk-rY8kGEMr=9'jfm6\E@_kVqkp'D@=e]AndH=kEH]ArqXNaDSO5(!:StTA
7,#CL'QhA7A^ob(M/$?X&B8058K@MHF8rT9\0hc4*SRnQPFIR.c*$Y4Q1>IfBh%CK5U;PosB
Y2/#[%toHDB#Wc(&<r'$-R4h:\eYDlnQZ1W>mA:>uBQ[Pph<)\=F+(sZu\*bOH8IiTC/(u@d
:E+>B8MZNS8j;e5N)RYsDsf"3[BdSl\sgnuOs5q0C.W>#;4"<)bC<DY`Cn717WuG"1Y9J!9L
O/K?qm<t9R(r,MkMe'_&ZZP[MUQ,+j0lC.?&B=k?Rld?i&Okf7%>EE^6k%!Q`A#;.&_h4IRk
Q*`.Ff9H=pMWA"Z51rU!;,QPG4e!jbpLXM=T&NgqmlVJZo0bcSalB!T,pr&-W'>dEg:'20uG
PP?'n4U`pL[g.DBQ@[k^V58;YU>9^MAUJDNuJ1-;nH)Xd\(I.dD0(@R<UAh%itoIRMaAMftH
Van^4MWppI8ik]A>K/H5\(KKHlYM#Cblr4&8]A'C0H%QnLi^!Y)O0ej,7H\aYn44N.1:(Oc-b_
".#G%fHm_ImIV&qpt2+Okr2D(\II,ml&.YOFk3=J^;^,E%EW^Gf/90"`bB5$I&X:"A5;'H5.
6;Wh-#'810q4nEnbofc'7Tf31-pX^HpEX3/O/E$&@1^C3<U35i56+WLQF-^,(<_+8#q%(FI/
I>+r^D-gJt3X!Dt5=OXDKaq^D;eD[tN]ALQu<.]AA>()"REQ>\'H%fVES[DR7fq)qbsseY]A/S@
k%9gkJYTW[Fl[AA<*;XoaeaTXa2JMMHS0S:oqX[`B\19Y[`J^)B2iT]A!2FbdZ6-6:(h'<OF;
d%NkW%\??pLHB1$E-SB!UQo_<2\pX#'0`2iG\C8c.>j6jo=bu_n+R>.*2O0s$Q/sB/oJUauN
lInu!_EV,a^^WcsCB'N:(m0\OGDPjqXS;7j2?fqLUTfD&ag6e-CkmnGj'&V;IW7[!)_.0&pr
HUqFM@_(;"=FB%bWrh_?0>k^dE'JjNr0Ko@K&3X:t6cQ7i8Ga8PKHkJhAZk9ifP4;$/nq<:'
O4Fhgk!:U5O;BQ[bnqAJ=T5'k"ZM0U4'hCAZm/Y"!>?nh-L-mG?;pf]AI^!oNk(sWhL`B4BQ7
kg&sd_*K;90Sa$l&lS?YHnCale'u^g"$F#TuMZ6bF&@k'>h5N*TY^q0Q//Z+p09Pm>8M0-IP
c;:WUfO-W4[g83[rX?4OW8(jg'@\`>"kGqI2KXYTO;GW9*jYkG;eJPbkYGH0nb8Stp)A")Ak
R$L`h+;O']AbhCp1]AIdU*GEZj_s"tH@QG_*<oKP8h2uNO5Sjf(/3<*[`IkbVQk>DKQj#Pa<V3
*qIRUR*lri'@JrooiI5U'7k,@7Ouf0U."#RHXQUO46G:E?4I;WT#CC3M_LBJftd0R<?NnB]Ad
`h&8,QWIh%=dUgNUo^8HGq2'HrZ%E&So:E:dN*[J&mE$]A/2B$VW`lf"J&*pW`guu`;X_6=fV
7b^sDU'LOqmDADh]An:5-2t-QZoF0Me-RuW4&_@G>o2qm3&X#<Wse]AQGM*l!@ZT=sca:4q.=*
DIB1OG2f_)CiaV$q3Mj#djP/bKf@RJUm/^aY'OT9hW@gY@d`!k2O^t9TC`e"N&pE?V95H8[i
LkH(f>&;+&IX,EZ1s[N_L!dB_J^=kX\[l_GgFha<26i?ab,^P[DVC4#Qc+!)0eP-eS$"1.)2
3(n/VTDE`i'f9D]AVs:QcN(p!c9sbFq$sVN%Ig)XLj1W#GnBQGIbenf@m5''0"ICp]A"tifVq)
ls!#LprRapZXYKQGh89\F$j*6i-,S4IgLI!"pZAWuJ<oj&^poR)mj0N[aTNY!*=`q!?&ErV`
t1*T3oY0]A-$^mopC[s=G/GJ\29;C4;TTD\`NMInB-IGE0q]A=gFOJ1KZZ'Yufc"g0Oi?+s-Ta
_p"uR">dBY$YG]AQ"T!+(,@YJ]A!Kj"B\8D!*s.>91%3kOX/^4DDY,i%M<OM.4G$4Bdm.ZtGMe
&GAW'F@.I_:GVr1]ACO<41?%4$Ej;L)pE1RZ,o>TGDC6gmZ^V(n_la-?=p)A![(]Ab1SNDXG^B
ah`3et4U,ekLLJ-]A(M>=DEA7L@5"m"HJ<R2ZK4/hZ!2M/8,^X@%FaAO^.H8Y3s%H$e*8aHCg
ME-N2@:;R%7+OiDt8F`Mn*HY!UWJ\P!4CR*UXo;Ei=$/eI,r_>'h9N5%:4"M81(T:mZ]AJ@d2
GRPU6olL'=<hpO/<u=(^ZP?BM48q]AN;nQ_&R<t<`<D!3ZZ.Xj=[rtG$<[^.qk&>sQ8$po`9p
\H3O,uT0_55d,[_6Epr#1\/iB\ib]AQn3*0gB@m[nGf4^aGJL4s4=muh0p>b`2+jBbjZgCU'f
V!SqGRfKJ9cf9.HQ.>n#.0/oM^$(3W#ugpJX%ZH>X6CU#)'JQm/2XPq.%%5YTjGWImQh?>\C
JDor;]A1R.Npbb@t?)eE<$-p0P;maZ+^>U)V!5VpM#-V,KZ.k?@X@kn':_dNVm2P[FOnVI;*r
oHl'`F@-IO#JV-]ApfhqJ;#S;h]A_37d%JHCa6E#UpMidJatSo%[lSi^]A!jbcKh=tqG/Ql8n(p
.!*1'!XZW>(."pet,g=%A8JTciWjcDa[uqMQ>n7]A6N0r%r-'/mMd5"b)f!dUUc!CI`gc8#1J
:GCT;$?MS<WAWm>=Yi%e>i7<FXn61[EKIb)r`dCRWgG`)If37)UBAm=t9^,Lb8.1E)E@lm0M
l^Y^ZG,_e9LQ)*s.A2T_n#G9J75\7h?@V_$)&[LqgN3L.(/:U$AiDbm<iu'[s+d'i%"MXQch
:u>D6H,ZU$,j<l?2XpkB[k-%s<YRYD3;+IEQGS["(ZinZ3if5+I44]A7be5$mfU#Z0:3:h^kD
)h"0G$hN>!%=+8cI.719ien-:dSn1[44u:8;@O_b.7s(HUCNX7L873-4L4bpU%Mnt^pg=qg[
GK_qJ90b0-t/gCm2`b5C@J3kI^;";3.XD_J\>]AXj`.0=C%6uS-g![u482OKN!I$VSA6f=>f`
%7Y'6;/pDOF(^)fiqcQBY<fQ/Vokm;@D1\!iaXZ)ICR$JKDWcf.J,!Eb9cq5rX3g?AK+!pl[
Bt$6r@RN-Z"3%JnZYFs!]A@+Q!#s@+PGS-a`Pde.ARH_=Yo4A<4qMFuY$<f,=$]AKVD\B0ef"b
/16Mh\Hj$=ub#aH=tAj=%%Zd,?ceKX1XcaoM>B>UCmo_+fE:(j5N5:&G#C=ss[q-h/XPjJ=I
<:DpuOj`&S3j@PCR0=kL.WTr&3+mUeBhaMotdeos<GZo53l:>3_=%:>NfX@bo*rpqi$6_Lpg
pdiD40r*IV((Q?JuA#PM@,!go+1E\Sag_!85X3XLO7Q3#t_gn)IeYN/;..Tph,LmH]A)!&L49
-[O6MYbX@@t+qlMdJPZRYFjJ0-$69JS"?V.%:)=,UTF6/a:kMs*CG!pZ-O$R0P[W#ia\8_=o
L)#o2nbm[1%E04Co868H:XkF0/:$)CTOBV6W3OerFl\+pgoisK#UKZdY+9a0!o^5FEausIEb
:e2g1AsVBJ$sX"=KZPJfg)+><sX[Q$k2UApP,6&b]AfR$`8a+/W.r`@VbQ^>bKaF5l\7iUl,(
(piQW]A=NYGI:r)BH]A4e-cQ%GH!:0euo?7G2gN,ku/HCauTNXJISp65jLd02NHKPpTs/\=jT&
m/)nBd=Ei=OI\">KPNr#fXO_4cX^O>j.GER.>jg=X^np+=_K535l(TCO\8$='qZYVYEh-^gp
'2ko8\&iZ%5W]A[]A1?lGWW!I?p/l7#=8]A80^C*f42S"XG6a>kT1om-eSi#^)_<)VO^\1+Z2kd
\VVVmbD?]Al&[3]A/\BXc)#J7ZD6W-9ZZerul_>Xs>FcZ69CN&m1ga3+hCf$T4f@\8`-G(Tm2A
ST)5t(7Lqt8W8&LV[K,j#l4ScRO03<lgqhX2"@\3%q@kajJ4mWl<`%Ct:N"+]Ad's2>OtP#3=
GDejG=f%n&fr6g\kju@_>JD8qhL4k4JXO6ab6Tt?\S@^YHk4(K,]A@l<C&SSA/Ik0Y=5^Ur#_
/I)HZ8Hcap7!>1J-ErV.N-B<IVJ[pSfn.kG)>Oo=^/9S6^1I:`/?W@e$:FbIQ&.Z:\;^MGX;
nl&b72X>[dT2D]AJ=g%f3eMC+p_K*m>VYA+7@d?)W<GA9PK0`#$Ka,rU-8M`$&.f+<70%oZPF
e)')Vf"oIW!3#IOb@^gB_eXlkBRSAJF9)A_Ve<s2-0+a-QIDrAVs=Xu,/rKaUL#=#RT0_SKo
bfqab43.F!li#\@/Whk0Kr+&br:5$=DS)q<n[8.HLdjM0Sa&_p;T36<4fB&o^d@^(!#1$u35
0519GSN-6qMT-76W1`('hDc'aiH/uE$9KY[!6Y8me!A=X1/6F(WP3Tu;9&B9os)eNC.WC_^f
R"Hcjb3/Hg8LeJQ3\1diEE)O(doWK7P>iFbVOE2`':(do=BpG41IQTdNuR:Bd<HF\9)OrWkC
BIe;!utR`_toVW`)T>tM;n1Co46kP;DR?uhp-2u+[;oG4/$',b6*5KBU4N+"\geJ0TJb;[`c
1$@_f.283/`helZ2,#X7]Ar^A"4\C<2)oS-!X4XNL[1loK:!!Mhn(rhjO4u:1rD4b+lH#ejfB
_Ngp"t6,R`j1nS/LA]APMZS7Dpm0]A]ANcmf1*WA.F\6J)A8:Y;k?aoK*tJM-P9XA.-kKNoJ7CM
6>fIGK2fSsT"N&c>a+uu&);2VpCXU[Yqi-$oat(Bm2;\BaSrVBY2Z"B4k4GNq`:R[OUS7e&h
nEP[/If"S4JU#2daESN#O@Z)_9$Hm0I\Aqp)ul]A:;U@CYbr)T3>qT4PghF%V2S9SR=X*Y"tV
Xt#Q4f+2gee/`s8YFcp7gF<ELPbf('&q%b6:->K.8+.*'"U-RBN.n52t^J-3K7O,$.N?qG9P
l%:N7]A$T$fi<IZV`#`>/jFZ074`$PmVM%tg&Ne^1L"'6>aN0Ln7o2[&7[qgfU&DoK&?iB@ZN
J9t@E[S\#e#K-inB[-.5TH"S\sGT$l#LW?pEiHn:Dtf;X?(WK!1_Q;W3G^SCc/3(nR/P.=(S
iq@XJ70SO1bkji03>FWkaRpF<TCMtks!^eEo7N9oU2F/Y0?sTV_C"5cOHLA/18)?H&1n^4mH
`WilJt2C%@/0YDEqk/6DXI>f)CT>Jg^^Oe#Q%ZtP]A34pk@L"NT0KEOBPFAi@K_)Dr(&NRnmE
KpdSXENe[jSgY^.sJ@PNofs1&u.PRO0LW9k3br(!DlesdPC;4"\#$>K#S@`O8BRA?/P*Z&1N
e4WI@0L;]A%dIF9u/#tG/cQes5'qCXhm,e'o+EoL%:6q1?A;Cr&3`(d;p"Q[LO'Z_ebjMGMW\
4_X[X4<@/1dR]A.)W5fL3#gZ2RuN2#4(/Yc+5'_G!"B!RsM-^cURta`8BedG1^`_+='<+^*$*
l4U+16Yb[b7[[D]ANh@Drp1L9=k%g&hF-X9cL*ZJ#)g\3fO(Oh?@H'rRAA53X17/kN)JWF882
?(f6DIp>RDL7j$GIN8sIT2Pi@.5CJTNm!1LnEg9g;/So6h%%E9Qj\FeRce`X.E!bhNd[4qE1
b*dW`TfMia?spYRm:o1a3Hh(L3]Ahns#W6r%1_4K"b4'tm#Q:?3,>FRe"V!B+bVT]A.jfN9a7u
,]ANC0c)kof5t'T$C^*^B<tr=TRFL<8*oUU!-HhsIV)iRtJVeP+]Ab<f;K;*\c[teIWRqI^XI+
cHm8fa\jP)`[.a'Z5so6<RdB0JQMdI`<2;m:^Z`Ycg+=A=PC_WjIBY[kfRTlWG.9Hd+E`&/D
dPfJ"N*3+rjCT?Z%#CM27U4"\1eIj\&B<n4gOkMkQf1ORuCXZjLGltmm.r-jPfXQJEl^-H'F
r-/8'3DI`C\5CKC/M@j<a=Y7=@nZ0)n;Z0q4fp4SU8KP33I<u"J,e+/(QT6NS61;SY^5d*+Y
^sN=R"&lV\IP*4O)H/C0S0[q8@PNCeW+XblDS*JE[t/9)_9*jMqTk><YqE>?(ZXTht&ps7Jr
/E[8!B^GeUY4%BISaiRYQcktrb<f\P;/WKJlXaYeTjuX^_9"Nei-K4H*)<#:*m@=K;f*ZY2o
gONn;I@]AOSAg.75!3f?FX7sL>6HQYm_g\<4r<'XZ7`3\5\JC(^C6c&42KtdBG&Wp@(B8QPSn
ckqhf#N6i]Ai)-Nn\I:9[9VuG->3suC/%uW8Lr*$k[lke2-?IsQSpd:<eoOE$4/olk$YY`7/_
sM:50]A$`*qV0R-+*>]AbgAp_FOabP>"+]ApBgQM"Ue.N,K$&^>&YqoM@#Z(+jOjC*k@_ia3.;J
#MBR$)nn`">0\tXP8KbB;-<PTH`fY_@5O[ATQ8>4W\86(ua5(h[n(T*Va!<)&bf59n045ZW2
$obRD65/`<0*h\lEp4E9_'[5'FlY5MgF2o$51[_Oc:IYG;6s`1&:,gB8M2tl0EhDnV2P=OM5
WT%_c([#rh]A:JPcVXS10mfM[6%Ss.p$/I+:(^TLD$CqBiFm2,r9l5qc[$:::cYiHp1guCCoH
e=]A_;$WcC2SNB^d!7_YUYb_%R?',5??Zh44jFT=HBmG7&;ZEb#Sdl_5ObCFK8;Mb%\fbTo!6
"RlqhkO9uF'OnI<Pt6TP;^!Ng%ibdl=*Eo-6c1-)%K)Bo\Xtk`K,)QbEUBj_Zo]Aq6L+rQc\8
2$K<.=3<FRk633e%f*?U:M_>Z.q9ckWk)C<pg*;A*JD6cUS`;EQ4)1HKYcb3%a-KkYg'+9\C
Za2-V8tZVlN9[HKjApL(l<\MbUe$ZWI,+_K!uNZXIS$"-2KZ=5MK)9F1th=k[LI8J=/#4.TK
i`0EEF2fE;Zh#\C6</*Pn$58*`O*ZrO0ZjqJ0@b58.g`"ddA4uPCp'n:W7i<QS=B*'.H"8$g
e4bpsJ]AUsl+=$V'"M/0J8X-5n.>>It%'b3U<=!S@QdrKTgqSgc;=(aYkI\OPt.?Ae]A-HU'uk
TJJNq%)ID7I9p(CF.k5UYhA`IDYfRI79cW1\0QI8l$RENG:lk-Cjp0)0&78aR#H6I%*#n=\g
M#VEbOuLY:$2gCJl,7aMoRnBVl20ar)aEuFP)(uYO]A*O^\CP0E<[^0C^bX<6L4>bCT:1WTs>
39?lW)eJ)%H3Wf+B&lL/GS5Y4W$B$L-!)bNp,d3N(PQ_uC`G7pldQeoHMn9+r+<<e&ocebrH
fp/O^5NZ<g,ji]A:f?-?@<>%Hm*=$`ZT#q93o/%f[R697(2;0i#&(o5DQ_9b3n&M5:Za7f+"-
CY.d3UEO-I/Q]A!I)>HZK>-D_c'ElY3EBHYrq1BeKV?'0\faF1/,pqUja?BT?o)F1+!+]AipaN
0MmZJ=&^mHh5:MAfbaa>\oCF<_]An&QsTP^jls"TgPcS>q`R]A03tN:gP5EoIK^@D"F:j/PK43
\#2C<\#4QENsPAUMp]A3A+;L5S8skA`L$EZ4r[FpnOYGR2F8JFpN#6^)MpT]Ahn9d=,);a<_^C
4YPOF1PhVOY9GRtcT"=9q^VMo@3uS1`kHS&@@&,hfAdOb&,-pWLdW&n\F<CtG%Ce)?DeYq?S
b#F0D[>/Gu:i%ds',kFnGGWN<J5@5ao8o[9%>X0nR1G(t*5uG6V@'@PG>(3Q.eq'S5Ujkj<e
Ypp=YlH6/*KUEB%)2H>cJD1*ki\>sXZn1joD;EP7`dX^)U@-NLK*;%`;gkC+><7[^=>UYIlj
1o"<INHnu_N29BID^AQ<;5cf4"=E[hr8)/8q,"<f`ppM3]AGi5i!(s^.r[675pU6OYSG[JTX4
)!Z?qP%Xgt0:[j`F&cfInb71"A`G9YTMBbiO[(HXt$%I*'heURAD=hHEV,D7sP,73IoWehG$
niWg+N`(cm:hKfaW444h6eqt&!Iq>\H;LL8(i(3qfCFb;JGqWP0C%FZ;,CF!4[uE\G1$,g=N
GqHV-I4.OXGLB85;,r:D2Eh\/*[]AaB;8$C0G1LQ,Gnn?5*7E@4*IC\m3GF_??']AZgQT6+Ncp
t`,EL"5=2;F68)nma&q#6H3`uFglJE8p`(jWE/ai)gkDPFTd]Ag;%1ATrZs'/Z6?.lKF5KgQ\
lJtI<m=!:Y\#1#BMEXTbM5OVd*Y=\"W_TUIKU4DRIUtdY8Ma>h8@IH,+EHr2Vt5cNP8a5-:@
$IHYCWc5_fHco$Ec9g.p(ugdJb4DSI7ln`Cod8N($9XL_hfh^1OQ<TT$ed+Rq31Z*DnCJtfM
"CNtmJH.GZC5r79`V#N6rk!T%c5@Z+MHCi1.HXD.3032a+CA=8^aG]ADjrbLc><B]AU>cP6hGC
+[lq/sUHRC-X2PuI,"Z14a"Lb:qpZL'*I;!3DEAVU#?2GtUZchD3uMFNfA\&?MjAD&G&6Fqa
Z(0_*PEp."#]A1=50NP&d"RM*$8hUq[g6h@?W1Ug4a>-]A)IB(8e23e%@n7g4<uLH]AYIU([9pU
hFL*9e1q`_R3,8EdH_4%e4ol$Ckq-!rK=K>qd9R(HW5=6C'o2?bQEI<5ks/HaK=>gkaj\-f]A
?!3BK,;aXHm[WY@sXgc%CpBY8$,%d-9rK/p)gl]A^!rrAM3QLCp*F]A&a7HOs_Z[Js[EWW7E#e
;kUaQ.r7JL2lBIUbIhP)+itb*9]AnB(p!nheGeSVlCt'(L*b/<u`"rjq0oX0IaJJ:,7:0BR<8
'C)oKL`s.#;b02O"ks-;4+aDBpE,plkIAS&Yg1O3B2sE"p.[.C\S!40CbTpmLV:.c]Ac%/bD'
/puA_rVCtoSq$[^Rnr?\0i3Y)H4ZY;HpNt+GlEuB@EDmQX"[2r5Ko<4hfS@t:E3Ep&'7gJB=
se7LVN0_U@T8>(Nl;f;:XS;1/U%&gd'I@;IMC2JD7qJG_?:$/8`p.0r"LYr$lBOTD8h/VNLg
N'&OQ?0("mSOs/C'VA>>NF$4gU'q?ps5kP@ku.HJ=e?5*4)nnag3=#,Jk"8a0=o:0%Xm$fF4
9s%U^qZ*^iGRX:[nZsP=lJpG_nIM9n>3a\4ahK^6Hfg/sUF?$k@hnp;qXL72Uedj`HF,oZMo
5%-A3KVXgp$$7.cgJN^JmEUoCqf9kCUn=/^ID4YI%h2TbA7YWfuiS&C5's62e<S*$_D?&E67
@77$>8`II%<-QpPHBEf)2RY7T&mO#ZPb)WQh]AgW5'So"Z7kZ_djIjHG1o25j`Ln3ncX9hG%#
?ukhOj%o29u87/+t!lKXY9k$mGL:,#;kg^/Bc).@N^;lS`;==+Rg2j@hB)E@Y*g?i8/GLC-(
JKK]Ae&DH/V&)%t=T50prag$XMo)=>hb,%Ds6Q)c1GSeP@GK/d4;Q#]A?u)cVMSq[WSIog.9h!
j6u\eFg!d.F"s(?$@<:.kWC1Fe=qjKmhr)@Y<`d5CO=(dQ)66C]A/%@0n,Z9[>Bk/?6aos[#*
&.U\tI!!85-O772!0M*.8P;"aaEhPk&9OQ?3e3T_C5abtEItX8!hZVtcE]AN28La3.ekO`Qg,
s!fH]A\9IJ3:eUIRn31AX7F#"MO+5IFkZF`l8&-^NJSMkBL)i$eEpVUT,9_^jFQqXA#20V'aF
jk($5lBWIf/@%)Z*ah_V>A.mC(Bq=Bsn(O:[mpFWk&UY>XZ[rH%[U5Un._9Oo$""?*<r"cP\
,$7qC8__>JBY$XqkKD.e,1J`l2Y0meE*,dH$=]A)*:]A.?E>)SMoA"[-b9%ab6#+8\*.p/[uQ.
l'*Zt_QK=Eh4KaIiD#YaXn6=WL/"fV4uGsU3$*/_.E@>Pq::N-HQI,]A2ksjIIh[&@f-7:&/l
WSE!0L:hV$r1QH4MCPl#/'5Ab7GU=\p4R&cfP-EoQ]AVgM:e&;#B[8$>L'V-R86Tl/6fP4Rt:
e"T[L10I.4J!5mc$mduqg`4N:1,:VOG4KsVX&_)G.(A`j\YX%79SO:'r$to<u.V?,/"[)an?
`-*W$V8V=CTkVS=Of(dE[fW84R0Q+qsXogfI0OV%PV/[?C7pe`FVM*PGd"H]AN6DT,!i,^iLi
Ms58k`Q[M0MO.t$UMrK_crqd!f,abHV+YPea3(_X`iQ'@Z/5QXR(o\K>ulN-[^MHnk`+W/qX
NmAaM3n6MK;0;*PY.4\/"I;Kb'V^ejEKM7oZU%0UU\A5;FPCCZ\(@tX7hsofD0t!C<P'56F3
L;lmLk;_qD<I&/5OVecYG+B34ZW_\!pK*+.;,@rC;@ibWOXleD#:MV)I-CgGc8Qoj+c'TbQA
F2TD1!-EBf2:E#kC;%KnIR2@?@rD=sd-EQ7*khNBO9e>=W!,e8AW&*H@WRZ8?8JhOI^)'o,*
b[M3GZ!G@aDmX#))l0qb+DTu*PHY9aru-6J:cqVYMTlPpfrL`>]A';!]Ak0%O(*Al8E0Y?mmUE
:Z%WT(#s)au99>[FXH)U2RkkE[ih(.(3<QnhMdG\b-''+-==J=Dqq=`dt/`iJ[#,@A7mAXEB
\M)sr5^Db]AAL`0S7I.96]A#X)05t-8\[&NasWpF!?WcnGa@Zb:dg4/=+,9jt<EBl:C-+sb1Hk
)ZjEnu45ER/Q0cuKR6DR$A>Ch#?UE@uJ?mH&=K8I\0;-lK@o,u/`o+%_&'B0:1;_kM7L>u=!
BP:(?;[gh(kDK0#@?1!"e-*FKn),a'qPB/3;"]AJN4VN7<U<)=fM*]Ah3")(e"N1i'jDLG"%VR
QBVN+24&$s'.=@hm"QK/<`"UZL:9WoC=V!$_oqSLnErD@%dgE=-ql1644NYLtP!-^9pL[Lu)
bLQV+Y`Yg1a2ZV'Y]A%t<tp+#Sm+VabL+Bd5\pBj;`^D64+mj@5Wbeo9:\)eNtR![>)rQ;o`l
o2L!EgHhY!I0\<E_C(Ngcl\k3j&6$QMkurODp]A(IT6bHZVc7[#oZ!e-GroTGY8<$d.itV@QU
,_aL,+b!$9HjeS6l+5FdaFt1,V]A"/Qq_nn7gmVqYU="8U>VJ\m2`hem8Dh0`I&YQuGUKO`Zo
1@l*T9l'j30A>.QDZT$&+QaScSFqeRJE5i_4pSu@6R-lRXW4:\7,C8;bZJQFihHmA(Bqb`6#
@HWU.GQ<@;g05_"i=#$"i<Q"hi4lRY!S<ks.%l%M5Z+C=^V>=#=TiG=V[L&YtMpSP@6oXL6!
Mob9DBD"2B5[G\0b48=4O?nQYr^UaW@jDcQb"<C3[SF4aaX3*e+CBZ]Aah2B1n,0/:UtOF$4O
,?F_3rR!acGLm(!Wf,u")&d044o]A>(7abIJf9sGj9q/D[lO*Z2U)Rr(C"J47KS,TER-1:O/K
dj1l:'Q#Zm[>uD30]A(?^16n`e.q]AePReEk/`?9nD2j!"NH@2?H1JGrUPs7&H([%qg)!3e46X
T)=sI[c:B$iCsoi[C_?<fY4Z7_'^JqXoZFi3F^/DF>$>Chbj)q#^A#UaJ0HsM#m21]AA;.b3!
U<o0nV,mBA,iZ0Q&i#d(emEhB%6Su!6jO(]A7-Z,bfGnP9GTfn_]AiAEA[HXRaVdI<P5f.dSN5
5Fqt*\]Al5)?Dl;-;"?Q/#'M<hVG[]AaRsB`%/tJ2!Y3n.kMr^%5SPI8$%_`QB#B,"AlN2<s4@
VArW-+-BHeY`N%Rf\lp:Sl["T'SVrk`&V*3lsb0lM^ZL,&pk(19mssmB7oI"AP]Ae<2Etd/i!
&;MbGhs0E)`@5*6`S&Nkiu;R*4R(aG5IoLIN9p[nC%U#9kaOjOs#_\kc"bqp5#3MH%e$cP6?
o0)Y*=(KSZk7F;Yms"lCE.q'ou`QM#N$,Db4Ht7s@L-`P8/>2L'>1k[AO9\gmI1c!_%CQ\U!
Ydo@"BsOWedk(&/FtUPpFViEA@$ZrANakU<5[*G*M>OLOa>aWs02%E@8Ut!q_0094U=Rd81Q
POK[Lth6O5)G6\BJ>8.CR>cle=DF=RcnFE\3<dbXE1F.RF_Ic'n2k(5h[ZhIZ#?MD%_hD9M<
Op;CGQul@/P?)Eri4Ej.>nAGr/%)"pb*cM2"JfJ_$'/]A:F6?En;QnJk7jPl7W5[GB<TBl'Ba
LKV;qY+0U3u5Q(Ek)hN[(u!`Gb\iCB/iGD%T>r67g#eq[5HKRGnGp>gJaDC0Y5BW?2]A+2=TB
FE%C)5ALY;QopTiU+RnMq:41\UBo"EeABB(9E;qp*YjR,A<l33O(S*<P;pDX-L<j`rB6,;N/
AAbu`l3>HgM3(((2;E6qPhs5&(:dh69@A8$ttejk'kZPg<,./]AuST:<+qsI0B^Dd'KE/!s!Q
p.V72[9<Z,m[aPhI)r<BEM4./tU7nHgi!/V,XH5G[.$*ZFMV]A,lnV8K@t!+7-j8%`d]A3\T)+
CuW"qE@G_O%^qTNqDQ=8GVCPJX:XMFi0<Z@S]AF:Fn&kE@Iq!j,FuZ<WkXeRVF*Ysh]Am")Q-+
-?>`ZU.+Nb-jsZ0'L4aX1>d:T+SQrgcT0Q8YoX&,:T+0rBE@VkqE*JjZ?A@<';b'm1\C[ZdB
VWs<W/@Zn$(>dJ9%:M,EYQGOK(e)eIiCjjSd'50>A6;>q.@KZ<Bs,#]AlPZ3:`lU[iOMC=PtM
ZpC*8l\k+Bnu5G*KQah[fA@WnEV>Ph2C;O<IX]AeHLuB4k-dG`<45+5biqX?lRehdj2K%o!d"
Bi'rj`UIN!VkWC"_!Zm?!:nYIaJTFj=&*KDQH7W;h0=eSd\L)SpoH8YT8N936tm`2IG%aD)]A
YHppl%YQDS@8+?+afd=u\t"EB6OY%nX'IDdYOOd(_dI:ToURE.-j*2iV3b6tNQb\PrcJ3H%"
(<e/IUa-b6'p<r'2*p7L48XY3o2]AS"k=ZbV]A8"Ve:&V&)umN5]AXq+Zn]AP;QaG.\A`'!VP]AM;
lMCs(2gbo8NBq`<4M!(Hq=g4?#i21QtV4C4[m1NQq=9a[-5iULSaLU<uphL=8R@YdS5?L47L
[U:7Q\WoTS6m<L97/L+m:&Xp`(rUr98:J]ABiatZbkAko'E!n<Y#d+fe3S\H5A-IsoGU'tr`]A
)1-ub:&cP;>=Cok_IjP)<1-C9K+-p>;6hbkPd5"H9u(rf%t1!:3fH4W=g9oGL,l_n_s]A3qa"
S("?J/MgNok;6`i-`d21+7C>!iERKGZ2BiJe9e-]A)A41l#p,5SM[ThZ:0bW,Tu&1<481dZq7
@I;^^fRQ:OA@gp)btTU-_k'6Q`V>U$62![KT14mUGc>=&Xp)6DDAmgXd`gbf[a/J:XdKTm3q
f/sZ`Z,uK38ajNlaVUHR-[F*7,_i`?)O)cA"L$9o:j=H=!fEo@rL^`PRDD;inCp@B;!fChMI
X(!,irel%[K''9QL.aPngon=A'n@>;K<bjUh56sh??kl6/UtMOnCgPlc.*W%E%lENK;>V^^Z
mp!KRO01:qseB?!h\B[u[@">l(@809F3oqS0]A#.0^.o"X`0dl6+l+^t8\H6<8]A=EXIkCMg4a
#7]AXbK>/U`So;1s/9,lgE-n5h5`kX*:XV66r:^`XM.lKu<#neBZ\J!gR>Kp^g3B:kX*1pD59
d8BK;5(4$@SH4Q$rD;h(,eE+QAUU(uo$KR7cG@_Y7iIoI0\:,RYAR'fJaqP)l@UAk(h"h(]Af
O;W,Th_]A<jIWR$-=dT32"X0sr6.`HV7K`BND!n3QbEne#u/Ed2YG5MuNKO5:V)YVH,,`*5"S
"nae9d.P5cQg:^]AtW"6o8,Lbn^tG(gTlh4r-=gPXoQmVCk]A_sV'@M-K]AdWj;0,aGMNrmI-Z+
!8?uA;%\[$:CpM%W]AB1Dh3UpXA+j/3t/B72>K/@p9_@0%i6WG3M9K[Z#6Zpe9JPX++^J5eK5
T!(.0:J,$U)MQ(QZJ*MkBqe2'B1>t\'J9Bl%@ld^-s"c'>$c%:d">EchrX`&:/=d@Xhan%EN
8@*mcSgO-ABGc=MHok0/Q`3BAQ]Al9t8.5Z@%[;$DY\ojjP^20&]AaPE7_?7J(ciK\6C]A1rW.f
!bma5c&(`77aIa#-)(<KEU8=0.N5Q+c(\ALF:9+)#<(J6\#b2?5"T-^ZP/;$sl:jGE+%YsV&
`&ac$(q6,TYi/=_a"j;JhNf?qshL8q8l*lE<U6G?FL<J=)DON\Fmh(mI1[&?i9s;#.XK%&b@
a'gnfEZ2%BMG$]AX:IQrXneR0kDh;qQ[%R^Hd+O&q8P2Xrns<&4mT=<*iN#!QpoBa(ndGn-I;
/c7H"@OL(hJ'qaJ]An=?2n9<&s#*!5:>lrbe#/DTMQj]A=2e>0Cu2dq&#+dl[S@An?G3-so&?;
NQ#*@Pp:]ADEjN2+gT>Bu*?0pQYAH=E.(K*0$&7?J4Rk90DTHr)((*bf?Y<`92E!AlP*4rfGk
J(@mkV%+V"!!^]AYuQ[3]A#AbAI<h>8PMk).>lB3ij1<!j`Tk/N,):c;e0"RRO(S-X:+G@`#`A
.pVpOe%Fom\GHaal='V"WQ=T/9'Z-\K<JkJ')XnINV-%MZ_B<7*MVkB`sQnIa(9KFIUfF8.;
oGGu"rW7>#Ee)qJ/G5NMAl$_b)k2&Q7+&;5o[85:<!ME/kSTDh4A_rkJW`O>V9K5D[@r(VP#
UWuEt_9mjY'n?r-k,.D(GWEdo(Y_dV\T(mP0Q8@6'\oW:#FkF9h>d17;VqD-7C1af'=mBo.?
jb/?FXOKqm@"k?[B0sG<38V78sX1@C>]Ad7S"Z:blH8qbeQ'+lo8%FAZ,;/"SS9MG.8QE*9:7
XFsqfqfYGhRcd$JO/6EBpCl$$[K17.pCqm=gb#Nr(M.ib1nhaKr&)&f%<7&k`,Rm]AalCn[/C
??1?]Am2D$p6%14XB4Kdi.&Y$:J*364@^JLn-F$hST!Cc4G.OC]AZP_P0d@E%<H`S8Japu,#5Z
Q8-/j[i2b;<?\JLm4++gVh=ka&B"a-YG`nua::N@V*5%JAs,qOF*$E5AE?0;`jAi=q^AB&K`
N2Q\Uo&:86*)JYO%"X:@Gk/cT<9=4;4!K2M-I36n$IIn3N(4^q8&:K+6TV'uU7Kl<h_@h4p+
Dt*kNcSkaLY[`AB\A(%jaP-d.:fUD:c'[FPqZj(.Iibg!=`3@2edrG$?SL6=D6Yfm)^(B2$u
jgE]ABN'3'o<r-\+ERIbUNa1M$="oom#KDFN+ZSk=mDEi?dqEFXFb>ergb!\6>.0mYM0?6pAg
e%H+Sl&dI%?_gd4SMAdE\J5ms#;$V'tTI,qWbO(4DbJdpS=G\lA>Y\$A-Bm"'H8X*]Aa3RPs^
:RGW^+a@C5*FNMp[4Hekg8fi^H4*n<S4YGcAQnm`!n#U@sqa`Pp'aW;?i!-pR#8?\8-^R9dD
_h"ArpS.Co=P"BsJu"F<jr>`)O3o)6GY$I^HE@ct+0qN#;.to5%G=o'oY]A6UQ8g,M?\1'2O<
>YXZ]A%[+gBT8JlY$<BqcomFadL0c[[F;!BqI!.lfI8p4'/mBL!l'!.i#r5FH<Aq-k8W"&;0)
)4l13n6.'>839&g&!ad2m/D<;!f(.kpQ`33AB!\6<Xh)rqrWP:*m8sXq>u9hu3V$8)WGgTOs
'0\Gm5UaHqPA,>jB^S#94[fOB&2UiO5g@Hi)TZi=`_TUQM;g(_brLg"ST7!>oS)q3V)u_mo1
eeEH0lSKqiJ;.Us6+K>K64dkn]Au\2&#sO7oh!ld,ht1T7P#BRdO2nBlO9\q9_Gn,)QEP,sib
JaJCPBdG3#o$L:1eF%9%At=%NWZ7G.J`b't4FofF9HT';j*WPSU(D>*JddKPDH\UP'Br9,bX
Dd1+[J:g]A.M^FHA!`k@KZOjJqQ*)WgVNN8$-<S5%@r[@V:VX#W=$%ffn[bT%m;GBABi1&1pU
b#aUp`QBC!\+;!kW1GKiaWD,-Tp*ZJp#p<3+DAs6hnj6c7g9emUlJ0VRoIKrIr]Ac(..2i;uD
*jiC1JA3a6;B`Y9[oFeFl0.F@1nULZ`Ie!+h4NZ-`Yeh$GW!G6$7@4\4Xoo9T!#fE0*`HB8R
k#EU$BT(L9"L1;N.V"YT3g<'IbcpGS0lY="UfCrtr]A;pA)c;uM"u%ggEr>u@d9Y4N[qLWr-P
018&eO)o8J;@@/$A+]Aqb$e)D:4eJE30decH($p()*\]ADLlO*'Q:Bo$Fdp%]A<[@ngS@At=$Y,
BuP5<\ltFL4ksU:F3O;mk4'H]AR%JVGkNeV!<#j!I4YrT5\]AD/(^G*Ln/l)##M4,-af23RJO7
W[jG66a's@i9VpW*g7/;=\HPdb^sJ;)XI*77`q>l5VMf]Ar00\cjKTurW;16U#q0<f:TVI,G>
f?lD]A,U<b+%8lu[9Lt>2U7La\ndW0*(aroK=dk>0u9/D,s#4RgTN0Q#@)0tnIPg7FtX]AknZ&
0;-e)Dr-F!1fC<H?[*mNkO%H"XN2;n(ojn,m&c]Abl$'9lX%/\%4t))0JQ,9G,H]Au8+Ubh9^I
bWH^iKhFkl(.+:c[%AU4Uflju8AaFl8.Qj@/-bNN@"^%%86j-7[j+6s0njjR!\[oW"`-?%_C
ZmG(:V/<pr'd=,ar@.qIoePCed^&?5<8YX"$O[G^(D5fnG3RjH4_6p<Fl3B`%8t_F*QJGuLT
d4B'fe:8[[G);A6CN&tB(^*i6C;r?nkptoXXf,S;,D#cU@p]A#;/3n00C\Q["1T1T#A_b[*g(
5YTXGWo"cB=%)aCBJ,8KaqD7og8h$5YHRfI%hPfq:A&cZL&E.27XKGhRBpm5*Qn>h(Kh."Ve
d=5Ii(mbmI\4NLRWt#Br^lbM.PY-X>hJ')8mL4J(rH9X%5<Liaef=JmjpQ]A[9c^N]A+kU@$^D
R\He5R/CWKHIkmY!JD_SoTg^(G0sV60[n=M82\V7D&`9ocu.gnKkgiJ$VP>L[lCN$Q=t?XC^
nn'N.d#H:ad$3!t[p9m:)W_C/P((06*TS.ug-X3R^5I(n[ZlI@l7gL@H5!^NHKcZ4MMV<JA#
\MLn>AC1/-An3Puda\#qXpG3MH4,(p6(rSYffc`r2*Ja>;q%$67R7X<%CIM&dEOF#a;8kBUM
`tm!o!J8U^":1hO_ne;je9-#Eb>XTGMf;/h.(QKFsWIeBST#E;FBdBT_bsnJ5=9jnrDq*^UK
\VQ"9@\",XPo_1.o=?ESAbrf0aNh$>AW7u<*MHG8G>NDHML-f/gerZ0dLHo?\ngC.?e^8r]A,
QRU#Xg2rh9Fm<!mQ]AV$-LO6q#)eCN3H>VcfUmS6-rg0sKhp74oQ*$/a(1]APr7HpsS<r<HV\O
8DKo[(2lgR\3.k)'R7h'?,sAGQQtXl'g5A25*!6O]A&U)0Q%Q5H,fK:/^E.VicL3&d0PoC(\7
pZ)+;LU%eJsg/1al<4V%4\D%4cZ?`&,jTFF9]A;tuf`#e12`GZbA#\nC_!PXih=0OH3VitP?W
o*-#5JYl<JeQ"o[c4ZF71D)2MouVj'Tc;"!!j00^E/jbLt^]A59"Ec^\M>U=8@P,O<Wu=/mZ-
..apWMVhqt9W)d.!G/BYAlIk\UXqcKgQRW,3GXA^a+q_YS9putZ&Ve>(h"!\l<8u$I/cQrP(
XmQg+cXIJ@FVbts]A#`++-%T%ul8n7Xe_a!nXbhQ#n&YEEr:jLQ5WG<<AT>K>$s9V2mNd-Mj7
KEo:1#/DdqA[Q)"gX+,8*PR=)hb069/[j=@-]AIZ(o./5tW08M=1.1@Sq7Hg5oS4r2\sYab>f
:,]A<&i39<bqUCW&j2g'jK!m=W:$58HFWV_iR2p,Iu.,&t-dDJt<TnRo_3HUQO]Au]A&e.t*t'Y
JUubhnJbP!^?!o73R.]AeOS2[q*WuaAM%$13SjCZKH/iA#<;W1[u6l#5.%BaCuY-Gj2\%T5j"
@F9S>FjG>!s81^Komj;A8OQ3FWnV&"1$$PdO)$Mkl`:B(@;`*@jc<)iMKQ.c-=Fs>boBUjJ"
OJgekg]AW_ZouW/iNJeH16^Qdr4RYs(Zr8'10CHs$#)S2La"k\`G\NnU>ZtWshK"k/O`/A+0>
u+iA@>"F`f#J=SP\C3m<GYkOI>2\<K&4H4XW-u54.L"I2g*C^;2PD"u^k-i`3Qg8t>3G'@nQ
L^0qIK4RG-S1nn@tHdn3ijZSOC1]A@a@A8C7*0`F\bL)Q0eoZ_O-SHTa^!LN6KeR^K*hcJ;bo
-(HMla_^EL0U`&h>&6FR/%[W3c^)sG9nQK<8BuO!kJqcUH+ZFfOl_p\AQkK0@q%7@TFAKl7.
1V`WJ=l('_IHQ1A@Rbp_ppj-HJM]A#Yp8EOuTIS-[o8iZ4?4,2cCjNV&lW"lDV$e!s!rhX_O#
iY4tsGVk4C(Fc*,c7l5D[Nn#+&JSE4AJQ*G>o9Nh_f$$[30<'V+)3+]A^>RJZ(Qh8=UU``u7I
NJ!IQBI`KH-%C48iqVVJt!C-rm9F8ENj80TJF)#.lR0DdO&iCH_b%U4)&5UE_+d_1$aNMJJI
#heYrk7P:oRd7Sj?8)?/FDKjTj91&NIqi(<?phW@e,"*ZDJA.8)0Ke?ai3f$(22p03mJM6pe
>HrNj$B*AY/j"!V@@]AJG_1G,"HJNi$mZ>b07G%PLbP=IZf5=M[3YFfDD@gidm7c?X-,5!5pB
2\OIS"d,N/uIkL7?B='nJ9Cg2qq;X+c=$"f#dr^n.bnN4;XVcf\</</8q!O(M$.27\[In[%N
\V(%a2!>s8>daB]AoC4$JS:7bIn6MVn5;ch3?ZO"CYK)ZV;$Y_X,\@6U(&<+Fp5:FSSO:et^b
)ZqZ0N#DN,e=JO-84=M(cY3oC>6+a:mr"R99W3!AH&h;CjFEaH_'p,go3rE^X(-C]A6qI[cqW
'XZBOP+-)d*j%XspU33(V'Kc?^6MAaK-Q:0"fDF(cJeqLX+Y!jYA)'GR[hLo\PL",u@s3TSc
4&S'o%gm]Ag]AV7P,%YpjM0Kd5n[2B#a(L68.e.=uh@&N(M=VUl[tH3qM+f<OoduE4aq]AUU"$'
/HL67Xbnb\]A9!M_&&&"W#71$bW0*i)k]APaH(rrK+o*#Y)c7L.mqV5?YY8nC[M`A!^/jpHE8Z
k`iBTff7HRJ0^n/4E>!#m1L_:R!G_gM>A4_hgO+sbJcDAlXb^Pg-Nkd@hu.[R^V\d#\be?hI
>QriFPi-L1Z-r2p.nt@1@#*r,`6`pqJsi"cRG1@2-V0FqE')d6oUc;lJLq(NdO_n%RFN$`Qk
5r\<(+%m"$R!Q$sVk#o,`d>f#(MT8=P=Z[`Ji:FM-O3SqVl9:,QJVLm2<dG5B(c3OrV$t'GP
Q4o26hZ\WRS%f3UBHs=Sld(RSnYt0?U0)DGt.T+"0k^%^rSULq,L/3GN-&<O!+iPnGFH(LI>
I+mA/#fTcpQ,\>[fV-'1N398sdUj3J1d?dhE_TOG<7WuZ$@h0KU-%^`sC\t!QD,FDn?Eo1'1
EA3d;^%I]A586`'UW91&VpgY#mck#jHAZ@4?X9+Y,Ms&Q)<%;CmO2E&+3QdU)?!4,"8_XJ!^k
GeRUn:aE1+q`1V2j^Z\W&$7P2WN"JL'TE#RV&_rWQ35(-Ag4cL@#"q8)Ao)F41$;khbB']ApJ
c\&gIuO1d:!^FZCuJ!Upab>-7Qq:S,UN5"[7;&K6h1kSii03N'u`Bb\2lfgX\.d+\JOVJikd
4Ta=0h1Bj_aEWa4lB)hM[q11.4qq(P(XW!G1^m"^G1,4:C_`A(LiE'Db.Ang,NHFj7pFc\jh
U:1ZC`%S<UqdC\A_>DFHp(FRm'[V>NkoF]A^bp^:?kMq!@bFhd%3Z3)\@N'.eDBoIN/ENB(o7
WajR11Th2;)CGAt*LfPr'do5OS0p&n^KjmiXPoKY#?V_e7Fb3*i.-S-$hqs"4b]A<_HXs>*r/
hJN##lQ8_>EPs)&O/t*mQ[=NFo>qUu?EU'?]A:k4,-#*n9gOY\&aNM9@h#"df).A5L!tQ9Y+&
b4p]AQe=jO_l>7[N._2R3BPE]A=FhDZ5>fb_1[qJfMY]A5Q&sGC/1k7X]A?8*p)mnp@a3en_=1Ml
>7>[o(/08DqYkp0bj+?>agn$ku4l>+2S<h>u=KJB_.:dM))J1b2YJ>@&J&hSt8qGTc^=_!rZ
W!m.)sh8>gAWifH-Sd%4=$QqJF+Q1WN\.YoYF"!nFoJi$)hbD-e&#U%;\LHhPc^[8SLE(Z3.
>=$ko;e7EbOUNGk0ALH:^Z0Kl#<bLG.$4AJm$\T!QLLf]AS/oB@\ad9l$9*.?NHK%S?3S8kH;
r"MFC#QEP45SUKtL?ElqrVED'L++-\?.'V3RI7[;M)2Ar@s63EQ%=WcpiQ=5<oaKIe;/.]A;e
QHa!$F`GWb:Aa^IPJdSZ8d6H4H&=o/Zi6&KSXf`lY2YJM`ZN3!fYCp0o4"KtnOJV('N+D%9L
<e7fb7C._Z$o&>\N1DKI5(3'Pmj4ujI5C9]ATXd.^8o0\&uhoF`See.QTehXT[J'NigV7ZFNV
VHNf#o0CIq^$7l<-B5_(8s1E#Im6'iuf)oTOm)^5*s-Eg;B=4(\^;-8X:JQE87?GIfrDK7Vs
&<?8B@e#TL@EP_k%F$E^:$!X(0844GY$@II_@etHcI`?ohNOd`ms21r.X#c^=mb`'5D;K!_V
SjS:EZEDC,t;ul^0Zb^kt-7Z-f]AWX*55SJ069KW<Rf4-@PUbLX1Vh1g;n.IJe?Bg8XCl=+:2
7hokI*Kftt%Je)i=(#+eFG:&>HH<daV]AQ5HHRgBp4^GJE>C`GN)FkQ4m%>6]Anq$p->$`fD*F
U_:)+.),^V$9U@I.rj\]A2nrsgk:!_M.41\m3OWQi[gBGQUBmnVQJ*R\)MsaOodD3Xc=]A>m7B
FhQdsA`,W@k+0-`mY?dH_=$?q81*)OjK5!2iL\6'0u]A>.WI(\F5!>JOW,OcXkb<Cm21Fo(tk
@0UJ#L6"q:4fBM)UmSqf&:1hp[%<78a<-33`/:pKoE9lk0j^bd*'96%O4W&/s%8gi$m[:#4<
t%QSnV2de5?bHq7_?#H@;8&/oY4'CTr)A+*Fi)'1)PaTSu+N;.<2u2$PbkP$dpjGkg/CB!5N
.lQp7,;a,6/M)%Y7<2e*9)k@^"#WKFP?rXG\qqA5]Aehrt"=HDDc?e$,XM&u%,HqQZn&JKJ9d
u%stYHu2Xe<`r--Gum>cTA<cg(P@4),/aA-2RsW9d'oC#b[rX]A!DRPZTB6CDd/<!Jbg4AC\_
Z8,1Hp!)@Jt*r`.N-DCN"]AD7a#OYIU+ra@TG0H?P&/[Dc>7^^\o5&a8m_/+0RUSoW>iJLtoF
FVh_Yg)PJ#47>VJmhsJ=L[]AN:jA[!d^PVuFKRo$$FgiC1j*hZ),4MRZSH1i0ObB\rS(71#Ch
:QI]A'*6?\6i.pApQ#@Hf4&(#raILKKOY=Tgn@VpljUUeoM'L$K&]A@,Yj&:)*UrS2/WaMbAXl
lU_NhuXqp3pWW2oo$Kn)8+qg4DVhBhn)$d;Ok4I7M6V]A]A4W0DC"7!:Bk?@%G)<qRp9;rMN[T
[+mM[C;nFonYm,CT\Qqf^\-Y$"LFjm&>F);$A3MSRtW4J-.^>+sH)uX!6Y@]Au,sO8g&k+J7O
Q'A<PWs5oW@DFtiqu(l-soVdN_ulIJd4$d^P:;$Kt@P'fW#F:-p$Y%h]A7"-:I$/SL:62i8I1
/#8m7>UlT_8ERZLeZ#NTkgf9R,Afq&ggH.a=6)\H+^WqS2iunM(Ac]A3i56&B]A'he7T"lKuY(
_ME@*RX[?Ej)lDJW7SQJR7h5bckV7%HIl$ScrD[K=^QC_7Q"!D1q>s'MRaJFfN!*\V?/81EG
!jPC';b$ZB.)T]AR%g$<;srIt[<UFLgS4sLRgrrh?lWrnd#D_6>.F]A#^'mDO_GQGUp[6pB#PQ
Cohb1nG,)5Yuae><bg7hoW&Kg>)SH+#-Lb<LXo0\mdbV(\;"&I(TPV/=\.m%-_PR]A^o[dVk5
c+Ci,N7Z(@eCF:>!12gd>*m&2ZfPaJREp0?<03Sj??[c\8,T/$.heP.=p/mRX0L^d2J$sN(+
$l7QABrgUH?eVt6FZtB;0fJ1%S>Oq;.5W=K)joN+XUUpr2#]A>GdCreFp8YNM/j!cC7ui82TK
:3j_@hI-15[8,g96g:hlq)O5=_>:FZo!4]AKAcF7"T.Z+7ci-i\%mg\31W'N'D)^i,oqtE8n9
!U@t#%eaAc*]A`F9>2D?<s?E`%[iB/=lc6sI3-)nMk?56Vs:;UlsG@DRWLdk@/3']Af<N7bu&=
lZX9eR9=+=lnc/f'geRXB135GKA<rcae/*pV;g6"HS+4`chpKU,=2+Kk?>O1sR*A2c$.%il\
%s\U:E<((QPaE?DgQd/Pg:6JI?2j;CM.PZ`Q0WVGT!kP$jBXtATKQGYk#_g/^-cY"a\9']A]A"
06OqW[]AO0ZXP`H#FSWQe6e8ZbqPm:(<&R=QpCftIc&SH_(iC;knII#STIaoo&#!+<Wq/'`(W
Y#X5IJ9*r2Zmpgr^GQ@J?O?@@!\]AE&YMF7)%tlUNpLlI<7d/[@[)P_5+rIUIX3K9h\0\>Gj%
"gR61_1[eZX)G"oSeD8m_(0a6F00]AbsAQ<t'nrYjUeBd(*2Jd(D6gJ?Kg;`/22p2khX5i5>T
8#KQ[;.-*Yj5m]A?0q\a;q$b-[&E/XKn/2d%0&U[8%Y)F#9-.L%4#Sd@u9U.H9&@!DC'-,Y1n
<tCP:Dg*"A$Zo1eUh"5@n'0k#F<-tG?PZZqY14/J;!J`tJ/r!!-@oT,oVp&LA%jn737$WUas
6B]AbDi?CH=!l]AJbn5EU)Oo9t_im[k;j4OoTbKoqheHNq.P,4@G46"XQ'=Rp_n@(6*i,N0kV)
*%,7`X7R#U&@JM^mFIP@Nr,8HLQuk"1>R"fjfY>@h(Q>gf*:iNnYsG.<phIDkQ:Bi>(\R*fd
j_d>i.HgeXNAgggXB"0.78PSA)]Ak*Ve@uY4IJ5=*YhYS(8,0*-j6/I$VHQqma?N$)MZO4mhU
?5?d#;5C^MB':X&0$kt!Z;FcFJMZ:LaQD.`:1PU#jWK<5tu"l+=d&2cN9k1+s\d[V\9[H,=2
K']A:*6#.2PI@)JO.k)K`t%o"U4Tao1J-au_$6(1.63Gji'e+i8mbeiXN,I\?8A`5'Ag'T*+D
@2[`&A[)t]AIuG_Lc*KWgX*-,WAGF9%VaTHj\=:/iZ1@l]AGL:jJR-p9N%s9uMA:1jWk,iO5/u
?E$SZNo2/7>dd[SE..J"uF4`:/>"M@_L8GZ^qB0ql$jCT-u_Di[<&$p,Vd[a:($bpP?$5CsR
4iR*KbpP]AI\j/F0XV<tQ1`46cDJ%G+TZ9i*4qo]AVjI,F)D9Sa")6?_89SM.O&Ub>VIZL+4^F
Q2a-WpKLnlMLgF'HY_]AB:tBF5rn-N3IAdNY$Z3qG^!.Bkh`7UVn50n(4dg9mm$f*.Be`.Z[F
@%Gu,sb*JdkKRJ'E)s-bTqli.SpV%h:*Wo1TRN+(%>=FA/S:1`U81e#cY0RnM)<]A"1Q!tQfW
aQ=o3GjuO_3.]A5;ZkBljoJHEi5gX3B^BT,f7d@KS:XFe7^:q;Zp;0!&[Ma;HgnDUj=D1/Bk^
Ro7Jn/DffR*NDfm&(K;hWp7rPX;()CP#W)VP.sc;Y^(;^S3uP;6bF<a[;)eL-!gG6raQM57C
2"@/<W^7[(T-NlZ4+Z]A,,&L_0+s$**UA6$Vb!tL#4!o=2Naecd$R/\;,1MEiM'nFR3@\*6`:
qqh[lMH<DWAZCQ!M`WO6'n18]AS<_"r2%1&%:B4H+['X45Xk&Z-%u\LN'B12P\?74I^Ycmf"U
qNL.]APUAc=+e>Q>KJ/'-&`Aj=<Gh'k[G&Vg1$T7*H1E7W2LhfZl.WOk8a8M_if'R2A3p,8uN
DUj5I9/tg6jY>Q4I+"^`<*6,lekJD6@UaQ:?/7Q\$KI(n4K@YI+TR63I32=>Cj)1tDPGWQL1
@XFGb)J:HcKWu[u9<Ac:kscel9cs9h"[0D=&R=)5tpRnsC*c,11#S_Nj=A>W".nGH-j+h5_?
1!"NjU^jQ["Z6NU"Y"`aVXt0bR)KSYk,9[DXB82<%^]AB.V9t4reKb:SeY0;=WHi&2!o1>E6d
#E?Bf^nk#O!f<R`@!FAn(,:p5M`A$^I0^a/bE>kd=$Qm@X7m"%=ch0'6qI27,-s$ofKMIT#^
j(,W?R;qqML8WO8ApR;`#JalA4O;jY(gpOc,Yjb<-i@<dYn.rDhl9HmP<@7WX,PY8t>je[.R
D^r"Q,P/BFJRUUObL`#eElM6>'qI7,3[UbOcUlo"dK7nufXqhdQ?r%"@&`%6[0*R$X\-_QaC
m3SSZ_ZXl:q#`>bRmi0;&rK`h\YfkHP9sTX*kR[aJ_qs%TN:c.?"p/d5$`SBaA*r=JqN?_:(
:i%f:l7t?&eBODn<03m%@5g_qaBAh7B`7bsA`R"mmpK\-h3\cWJNtSjEm/7\0Hi(8T\HP1'D
\jLd,7^Wl[^N209hn=3h+ZD*QLL\hFseqSPTCgj,l@_ZR=32?F9B.AU-E\<.Mq!@,6:5Q!86
NWd366"1jM%,%I35;VAQBS@:8sXn(tG*l^JI:b>;*Cco^O[Dm;$/1ai'GOu@_M3/RL?'rH;"
1`XT1';9EV?\WP5ekMWaLMDW&G>ZR/dA;1B%+JFd0g?EXc>UA9!1,_:PP:4REsIb'ld/2uUX
>`%OWhHCRRifk4:-::@Jm\sMF;A>W@kU]AoP,549nu^Dfd&4=QAr=q[%0(@LaKXBFb4=M03^@
\OIZkg'fY5^/$&faCpmR&mBH,Mf@.m(>`%3,J*Z6R:3U,!q^fZ3>d2A9@SVTZlE)An9WAF+]A
p]AW/>BoHG.LuB[FecgS8Dpfu`]ADf.V0c`Tog]A-ubnnH;%?Bs,*%_eP*.%FKM=\9GM&P`lVX:
3I:D5eU+6tc.7i7;:81[2BC\9Mh/ZKQ:]AN$&CqOW]A@UpX4k4aVnCSd_r@q*`,2H5$k'UEH?U
E%@-KMk`mC5$ScOi;qI+J]ASK;rnjckK7*Qqa`LF_fg`*i-PgF0:I>sfk"":@$X6`o+2%`Ob#
^%@1qkJud8`rqZ<T8ZSJ%I]A@Vm`.K/3.#AN'db<JHO[?'S%[ls"F.5M`Phq>OjHKut[9e^J%
nL"`?KBBchKj5I-ek`QhtS&Zt%(1U\-1fH<GDd]Ak9!]A^\T4I?Ol:2U\Z.J*]A7Da9D7rD>8.Z
J!I251e<+WY^o_gMF5)!@S0rI10\NSd1r?1q,[Q%i/X9k(2\Gm=[V1Q10FT"SJ8`l78lN]AL:
^\iUmeX&9aLJTnEjYO-hI6IuuCB)j8itq\T[dj4Gp6S>^T2h>C;&cOQXWTjJsN&HrZ]AjX)$E
-JQI/q9+CP7n3%LgkX(h<<oWb.?*d`!t"YZ@X6@m#Vs5-r"p5e=u9"##IZ<G'tmqblV0E-H>
>,1^nkUbQf"e1LeR>eera$L^s`qt*@X&983*ub8+[C)K$>X54Z884XZ,,;O-_`LDPX>Y@MN&
>f%/F[6HhA@iNAFL^;uCH->BhneS_6VaL3W4F=74f+0)7Q&?:0'HR%6rq-M68FV#n`4jlk,i
b_EXlqUILFrs?d914m*?KuT@Z[(H&pXL?K52S)"M!B1rKq'lVcY:oa8sT/\Sbh63^uq"AkO/
IV"F:Q@=Sc:Yd@g(;NA'P)*QjqXD.Fb!]A.g:p8!qs['=<S0cZs\=\jo=P1i!oDrYfBafO\u9
V\BC7%24IA,YXBD?PJZ+6<pKu8=$c0\<4[pWjsND$*iL*^Te2kb!:MO^ORlAHKig9)8.&D>p
2IYRF;BVWHqraO_TfFkI^4Kch#D"cWdTPNn);t)@!(oeP<aOY-]AO'-1ReI!t!uG%q+?uj:'X
_.)<p-^!J8+o2dEVF/[P(#r9*j)^6eA@"mA4ffNfUa>CEM]A%7gKgRiq8<?R7mV>"@JB9ge5a
NWj;A^oo6##F63W8U.&MJj16hmZ2jbRJ$%X5"qT]As2LpV<RW)a]A@_O0"<G19?:ra?rJR6Ft5
LA/#roOs*+GbP)X5F%8d#RBFu./0Z0*d?m#L54L/+QZ/2^$BhXh*XC["bq'mm;!co/8)\!$[
Lu+&baC^m_6K/IK,Q1,WTVT2`Jf?U"\5KB-RMIq7ab`8f3MuUOcp5*M7Ekm4hYq4[`K;7#WU
CDX!S#Cn[<GFFj_^q%cN!eT%HjSr3d"TJ33PGNj6N@G>0QrT!@jT[:,R>(#G!W/?ZH&8%Ca[
#^N6(*%%*S(me]A6'V!G4'>*l1`HYmOBUo;NZ2t6tnjASaCb,F!FK*5#DcOg]A^1B*2]AP/5K_m
b71V%`&%:j:m@F[P*<pO=ou*8&\&oKmo.]A_-P1rlh#nWSs0((.HjSN'?"tfTURB'ao0i=Uio
S/Ii"N%1+mpg5A>Je*"N$oPKZQne*31#T@Z/A.cnM>!:iA+-ppO0]Ao7a,V<EZqbeQ;YlIU&&
pQR\rr)\q;o:C,_A:l62*l.T"=CITn0[/a=hDcC8Mgt7^"ZU>FBc\I%c'1062F9kA%um$X.(
)uNJauhK?Uhf1rjkbrW\c+7\+.-dgkbPrct:=>*$Vh2UQq]A?fa,^h>kG\\6(!1b)EN;d>bZ`
!AM+:u"c)i=RTVMaW.E-%ZEt8hT23L<DoP"3'>a+(6MJ^BeWfB,D05n&^>;"4-gj*!(!A=l%
D:@J[V+$bah*kmi,2V@>+#2J)`Rg#5MT,2.cP&eIo%pIp'gKLC3$W\KZ53noCO;b"mmC^Hsu
&ui7$4Gm0;/;q5j7VLQ+D]A8l"HC.h.nHcm,LA(*mhJ?BXfM=mmgK#VsRnO1Wg1hR(j;Mu_q<
_2>+6%dV8IA>Er;^doa'iEbA7Re$ZjPie_b-gRFargtVQWGq+Nk^n8?n]Apst>0o]AKmY!:3@l
\h=e;!A1)jDUWd)I19H%o,=h#q1@fm)Gi<fqo\Og)Zl;B:Ti5rb;Y'/MhlD*i7N[ia,O'T7l
Um%e@ng.Zmp&0$q,'uDGX1T]AH6XoQ1k`eZ",/E>R52llDmj@NO\;/,\YZ-O.SMXXhl5o%T$j
$gIc'P<O#/kks)BRgfVh$H(%%Y>"K6$A2TPd\4AH3hgVo3\,(\`kiM5ki^jg,M$E1/*:&\ct
X`IQ;pZ+*amT7V0O'k%cS[&C+qX4hR?IMI`+2c[2!U$bd&-"CDIJ\5YQ)*%jbZfK1';rDb_*
g#Gnt@'#O3TWk$!pPaaY@mD\3Zq#b.eZtVcXJ;*@#+^%7X1NYW\EC;_:oTj$fg#`+Gn0NsEm
bgZs3YE/S<#N0Y&#$RF\jbJTqCm6CueIQHE+=+kMr-X$FSXBS*LW@"D1'5;GG`cpV6(]AlE"X
&0/H=/'TYpU1*pHj/Z9#7cjl:SeoI^+-I1jkbu!t&p#P.-CgiD'n1NY7\GfCYPKi*ng;r#I\
<(AIn1J*M@m-/FcR0`P1JUZC;R1#uaGMkG2Nl%=.PI@-/8ZDKFgAk-Q+;YS8#<,je02)j=2c
XtXM;WFP(!1o7p$qm>.o*.HJ>_6gi(ku#^@e:S5F.j:\`*XjY1Sn9gU(^n=U-671f:BS;Fpa
OD4[2We]ASYq1+/:f0J^!jQH+.mpVk;6_5ONSo@%qF6C$B6FmsmI@`CgaW=*banB@XmTVHVI=
fanGu)):o,`h2X+[>h+k!]A\'UqP%M_ai^R.N/Y'nrG`1>L=\S'sOLo7YCdjFtp9jSOX<,LiP
`<26EGKDTJ.Bb*O:a9W<MJHQpd;4]AgrGId>m-RFrF(KW&u*='2<)RBK7<8lf_(MESAJQf\_M
B$p(""c:54c2T9poQSiB,bUPQhg11:D04Y&oiF_UlYdU\0G.h`g!a.'X<G?&,Un4fA8hinNR
OCM`f1.IARS%=o:qZUkQE./a@1VIb1pJaEMfi3N)C0_jaZPDHnBAH9BIn;Gmr[%dd@7P4C#;
V?p"HW3G1kc6&p_?YCf90O3HGoN^MFX-q:sS&6-mH.i`t]A0GGY($b:W?]A5LtXL).H\*"YG<q
Z/+kR+,R^HFR'dYi;f/!5WHI[ORp_SK+#,j_L%m&:0UYtCGiomKEl;m1=7fQ_gH>_/6)Vroh
uY#U*nF!D'snpX$eJ"YNe8l,3%!AaduUd-UUO77hfponf)\9Qcum.BWk^UVgN@_@%HSuZ6I+
f)843Ji$WQlmfPEfN3=+Ei,GC>GEG,rV1dI,OU-\C8F&irJ5ArVWDda&D"mhA9`b1X"YOW_\
osid&PII6"$.;S.3N]Ah)$4N3ng`h3g12(g&dFN$@&iak\.T4,Q7P2PVJ+o6Jii@u\7?RX5@<
r'PP*2JuT]A\Z=V)gG@]Ae6sRX+`t#sEj.=g]AHBA'M9qf#j_XOrSmk6co(K0bo;=u>gIFi!CLX
_*GnL[H]A>p8=a-!d9!S8NdT'Q*NMrFW!la6:FD6m]AM@#-O"a+3fYOl:Uj+mDkF8j%UoQ:!N(
GaHF/XR@]AXR@7h%E)YfI)LiU8r2[`6\kaLN"+q%"e$SgU6"Z$s^N!N'q:H!`+]AL29=+e1*T0
mV8%jJ(/r1,l#,lGa$=Tuk!++:[eH+1CRnFQUb*#Z.>%W\ZAud??-=.f0=eB+27U\KD8CZA<
J.4Puc,YpLKa9qMp,%HUngJ8tQtV?1Q(Ur.Y@GA11(ck/3nq+d*AL0k<;s)es20QjHhr?*2#
`YDoa[h"7'egf!0^a#GrbIO*3')X1ei!Mu!j=783kP:H$P>D+d#*d^^a2?q04q@TK#')W(O6
*4$#EBhE4JWX+f<j9i_]A2NKNPAX+P7k?q\`XW$C<O9Q_VU?7R6?u#@fDNk=q*[\@8FtUhUjd
DX.3Y&mP+5550KN]AOh9a]A]A<onQqbj21qpaN(U5"Tfd@-bgM!F5G`5+Eujb5G:`/"^W0/HtXJ
0dXuYd*bXSUOS=<5t.nA4.,_SQA3)6T+Y*n@JZRjkBIcD2qi44q.eorTLtA3OY?6eA_JInh`
3s+d8\o<Je/Nh_12+(FkR^X]AB-L6<^O@eQSU;[*RL?f4%Em@]AlG)$V<&5&p7ifl:dGT^n&]Aa
HG"IuhGp!;]AR+#bV2VV`)rdT4+=NjqjC]A2DH2ed:VU(lq.7/bPQN63J2eLtTZ'o>e-4[G"Yd
sTd3DE2V]AYol.-NjYUB1*?5!n-J^3<m+[E$PXV'N?XHZSi$[ZKl?i'sPl/,S/)2A[+nA`PUc
@6e?udO`;2e'R!B=2hm,W_':D6b&Sj%k`Us\=^uh2[!/>[:Mul?I]A[(47-$o[6fDl?G0S(P:
U]AsXO2S-W;bgjY^\BedRDQij<gTreN8OKdf']A9V\]AkF@,srA8Xu@SCC_s6pOCZ`EAjTRHrbb
Ss=smpXC47<Vi@QRppgqm=0"90,^pdY[l<W%"]Aea"tIl33(^Iqgnf@B2dM%3"mhIQ#=e!<lf
R#?%7>,0@mV9m,(S$jA&s)AlSlfUZbE)aJQ\.G(PA[%Z&fd>^1)&^+oVU-sA18/XE(2/f6+o
,V;K8n5LBQSUm0l'*ZNM(I:V8"?1,Y9eaR$Bh9HtV4OE)NXLm6"ohl(kY+rBd&Xc`MINiL)D
LXUiHfB#MU3ZX:TAXD6-f2Rtdt>XT6G_X-c/@sQgZL;)Z=S:lh]A6O%/mg6+_=DNbcKodIcs"
F]A$YOP8L7@aWcu+.e=_QVEpcV/6H@M%VI4*aY.[8_]AtO,+.5J6Zb0[OARc]AqZ.tce^1_Qg5$
pep**(J82S&g`>h[7dS>2@A*T1[(XeL3K+[R6jY$J.[_tS0)K15fo1;kuBrq$RZ5XV[CMrDT
`%*"'HHdl!j4Vu'`G(GDiBOuSBdpsR39??1'eRq$WoZ'VD"_M&HbIhUjm<E.]A4MU^_jhKX:4
2_H+cp*]A`ZSpEkmdSG[S^10qs+'+@C_iLrKRURDer1C4?+D6G$ORBLGt^2:S#(,Hsq_@lM:f
$%MZJQiY;`K.8o38P>RbAOtAHPdbj02qWcGTiX^0U,=AR/:+F8^@Z+S2QUJ>MNff:"/Q,HJ(
M%s=#K1GF449RQM7;1.\**OTqp[h*Dga5lq?lO'O?IpXG&7lMfAFD%L5tR$dYh;Y_jT%?Qei
oFX6[kEdn&8uq$"n)NsY*sh7?f]Ac<:Z,rHK:3,Tb\Kc'grqG4'qCXV/q85*Zf/Ba8b^@fn^q
#Bb(W"p1P=!SrPR,;(J;cOg1^8q1oDrq/JqV#?4((&r9X26j,,_29!MRp]AJ'Q<4r@h:BA^=O
Sek>)0<Ca[)2I`qo9-\U!geoBqa`dX5s6M]AVuEH7##gZTRl`dp$0Kke=21HJ%g/V\3eZgls_
:ok$O"Y,,8@rad>u35s!0WCMhGA[=uKDG2`Jf7;<s9`/UbrPGS11os7opu1N01:8mtf47e:(
M6e/m,FNtSZ!VV=;LlX'$A/k91!.[3,:,4Y38(+W%Uq%C:[s9N]AjH_Y.r(SWPtF7':ud8Hd2
hsf!5P8ZNEt0N!6(H'L#M?=LuA>DRoNW`8_9no1e"$XE$`DcAm"JqK3FRgNd+N#hs.VZ"@h,
%EiGncNtD`@ZMOa1g'9Q(-9ukCK.LD3Mik1P75CX$Lf$9#Ut]AR-DhcH.LkSuMcYnN8UN>%Ri
Po3L,=r;QKm(9a_%s!>b]A^DS'@6#%ZV7AX0\;S3IBpJ)2i4(M.3#B[_YJ_;;^s:3.3"1#fXH
R7'+)]A*]AT)_E"</OPgLa1>hSVDH7AhqB)Y6LP]ABVNS+G^F7O=0JV;Uk.Tt@M[\D,Ms?Z!lL0
@LlA?YA]Am1Os-k+5h<h,RZBC[<&tPcK!JZY+K3p+.lS>%,Aug^H$>^]A]Al.K?_tK)GD5Jh$bp
4Zo*VTh""rhO0V=V,]ARC9<l!?FL4TA#ipR6>+/cc*bG;d5M%1f^soS12.LNQa$inmoF(&W,(
rqg'++)Fo?J<5Ld$LdsRd;ZQ&3%)?K#d517"mV7*X?:)h+2'ngI)$*k*ir0g%<8ugH@uad,)
("+l]A/R=`CF-%]A;#4McMW)OCOY!*eL+!Lr+rM'Jb7?!ij8m)Tf804.aiFmi;A_mI=J-)+dAF
Kh!A0UTj"n-C6)<Ek]Aaq"OWJRtR_B!WZ\NpR!rMHQEd-Y\'aEZ_KTK2:\<nTubj=V-jX/\8I
nYW6VtC.$qZe9<]A!B0.&]AB:q(WR:""6'mOJb(U9J;:i'KHhOUi%A`.g;Cao=rZV@9#aV#]A%C
=-6;l$SJD=u`)PA%7cV!jW(m^o=-YYVoBnHI=jA!_N(l1C[lI5cA_3^D`1rR\`+m-(oB\3+V
BjHG@TGCn)9V8EU"qGSSkF!!9^R0ieD>aR95>4IO_"k#J41umLb+Ce?DCej-SDfB9KkW1cP@
dC/3p_aWlSMK;LXpB_<s]AEQ_WGH-X,To6c,h-oShH$D@<]AafFPi]A-(!cgZLhj0_W/[+42-kf
ro%k??hKbt\H.l#X,^]A+&M:1a!mJ#Wl-4fO<\T?trLWMY=iQDaQB)hA`r]A'XR>7b6[RS7H6J
J/FrQTC-iqEOG2_jTWJ,X10WpFJPA+)3+=&M0k@`$$JRS0^VJAAHrK2>[<pd!:.iI\_s0OQ8
_t.4`Z;9\Mu5d@RX.q3r?1S&59L2biNn>8TLZgFI^0ZT99+LO8tlK\>iC#nuQVfdW*]AlYbX<
1hcL8!)<,Q2u3P"c1-=#;%k6"s6p+=b'b5.O+;I]A84IWGBrVk:kY`bTRkYGgGX0XEq:[h9[6
#=k/^Y`c(=.n)QSNlSk4O3D%>?tE3GD(78r9.Hk?'-draur.U#q&7GT\1_e=-<&Yh?#]ApN)I
e>;'i):`*<ojV0M;a+0b'1Sal=L\&n8;foSO$j1jsM)Ghpn([MhBbJeWV2^Mn5i9p2.N"=\-
R1A6:L8MWLLi2`JtR$qA)T7t%$YE!paAgD\<[PE?Ds5>YMAe?:QiKZ[Z\<oodUpU,0P3g02i
K)&Be`FA$UlE&FI6c[n2#^TJW&Nf8+X+@:GApSpk5*;(MQ`$kA9RW24pKZ\<gG(s^sA$9^^D
_&Xe$Q";"KK(Wg0,"I,n^)igE?qN>o&%jU;Diai&n+@bX_?&nl:X(WGK\Xht)k#j`anJTaZg
4&M+6tP>@&VVb$c]A[uM/!+0TTlu'o((b.F=La+n%+b,oN-+<mQh%p/.)E<<5t):e&CU.H)Yr
-r5i1,*Td%@\@R_XaQ0J<h*Y+u_#G$R<O,()CmeHIp#pYkLWb>^Eqb[UYCgHhl8utBkUa=Zh
_h"7#6!31p2Wa:E,2m=qXUD#,'<80KI6d"[2eh:SKSc1@NI-AY3*[Y5D3*.408kR"rg;`3pX
GsJuit0.:%2W1==u^ZZUU?X7!7.J^/qS4TKWCr/6:U,fmR[BW&^E3[tuSG!mOUN?8(ljo!j?
MmNZ>[DT=_W]A@]AF2rC#40tQ$+00k`n0.BXn($su>s$@lg';\<GG_%SYP4#[4SCQi]A8Z>WK*;
>6D"^+/QoAb-;YsX"))i$Z)CTM`f57YVtE&J;30nY&bbupKB$.[kl\Ek4XmhB+igeu6oX[9;
e:9]A($<1S1>'V4'IK)'A2GR><haB?uMs!Um#<$#j<^rLD+2(#\2-c9j_g$;)O?[bi+nr"mEY
loR>@E/-ggC[PM0=]AT7($quRmgA4e*ek)ILHn"=2W<39rUOI^%#<@^L::ARp`U(\FI`e,B4f
HFbWK/)5&6sLME**NoZ9:@*]AZ2s/Z2aX+p4"1q)Bo%a*aY=FbJVrM/j+=`"nRg;>H*a/As,j
37$#(2&'Z$/.\<a%tB\ZFYKrkWmpLt]Ar-^[AF5m[?QG?F!k8J%@IJht^\f=QHfL!i_fS)Ll[
TVuH_C8e@<]A7h=W=JkhcTXX!B9I"N,HR=H)`RtOFmp)$dt.*KaH9Sgk,\sNqSd@Nd?j:ki&V
fn(j(G>dQ$sL;c3apM&peaN<kjI>]A^r1^?WRa*9=W*S0r4fb@pZS@_H8E1!ke*)-aP$F7"tn
KuFb8Q$3"UUG8F6%Of$Z?XX`"rH#kTr?h%")dRhj'bTp'#fb#*5R["+Wa*2b1:Mao#H'NV1)
)3OFI]AMBB*@bL7Ldl?]AWYXm?/,WaYtZ##IP2qkYLDc*>L*+7hM+qpl,ct)r!ON:GlO)5XN!^
?5CG2aH='7m"CU[rJ@3&Od-#I1.Z+75&c9DV5^_A(6Kuq4-Qn7F7Qqbn5Z=iFfp.We*"J)%l
SBl,WY;;V.,CX11ipm@J!"eT#iA:To'.0_nTs\l'=1jOKj>T]AU>8u01jn>2]AV(sbTruio8IN
25fC:O4I&:G71K@c]A`ct[=NTD;Uqu)1f4%2>+%V.j\<+3XHG\'s.Z<2loa"\Qik>C*_mb<7/
VV$s*8/`2,HmMLXrg.*$ic$#91b$%CJYEu["Rqsj)0>K(lkDPhJFf7a1?8f.PnHXhoabJ_+k
!)lc/j%;*^X(-;$j/P9ls80GEXsSQ9?)V?=#:?_bY!qXWFCHfqPL4[ciiBaB8%"i4/6;A.eo
="6@FYJpmie'pDomGg8%<oc/(=j'`^%s@3[8aHsd^?s.7El5A03VaVe[#FU3=Ti.pS/cb-7l
[7@G<,OIi3:YeEmH1@!^u%[VmN!=\Z*g[,LBaJEf\Gkc?8F=ICCit(\K:M`7VXQjHTrU)t`u
7DKrtb/gk^HGKIY-CY*8k@J,QI%q)h8='qPe%7[YsGT#<N&7fI;qc9ka.AR'*r8V",#t3uMG
:'>lT<ZKG6VP%5ff&PA?+sXG<7`ju!Z1LY^OE%>_K'#^^G=Y-Y,SQ!*YqTal(FEjOY/MbG7.
:N.!VR\#nX[=mp.&,W'L]A_WAM<\hE`I96BNJ*Lc"?ZFEk_%h?UU+f0@aqS=DBJn(BL4c)f$V
T#PC>nONAH7`nR"ghX4dSP+,NS_Rkc=hW;&YehBX_9YO!6Kc'b-GJ'3*%&%%C5bHlZYAg_`6
QE3F56<#%#W3D;!-95MVdDqqda"3LDjk+@kY31ITR)dJpIih:NR))?Q?-aU>R(\mLr=_@uTK
Vhp:R9'AXVc]A]Aji"JJdW+R1qmMjHDZ/RFIC*F!>LGGel$\$[nIf[H45X*t8fIC3;_O@CIr9/
/AL^k+/0>]AG./U5tp6CG4s@?;3M<ah(b+'qifU1nV4rI+ci@Mhog.prYo,rhTN5"]A+!60q"r
lUam$&FpZ9?%BJn>nok#lC1+R0b9L^FS]A/!2/Buu+VP-2Dq7Q';i"Vf;86M]ARbjHosWYS7tB
)E:sEE=$7rOFoZuo@pc)brtC]AOEfG[9A/sr#>7YYOP"l0`j2N?5'kS*5=uWQnX'3g=sA6H0@
nG1\NnEEe$%3]A$qg8n<!Y_;@=GT`GKVY)b&p*#+Ge4P)l.P6dfm3l+gLPeQNI.,37,UcHS.N
s&n1?G[@*"J#h)#tiSR7Tp$2BlY]A%Gg)C[bhD+G\AT"ds^S>o%c/>l?L-M3p:%]AmK,jLO09(
4EbmE6E*$c3[L3cCdkYV9_oL1X=C]AeLR&^kQVgrd&&m;nq(M'",D5R0!"">FN\LbCrn6OON#
+i:I!!TN2'*0=$s^kQZ#Pog3i_$BDnp`M3gO8E>%*SBTrC@\4%h-!>kcCreFsLYdtCQAX;#L
5JJsBFY6b)b7(QRCA6cs^ZbN[fMW.h69=7@NaQIn1^0gaWr6lrLeiVp!4kRiHtjK_Q^;s=gY
8]Ah=?D/MQTNW/-)#o"9Ir8`8Kf5aB5bFEV]ANS1b$WiSR/Ok>S6gXXmPO^=c1=pSJ&J0;[;[3
3GU/mn<]AJO).BUE>;dhc02tSUTi,nYJ43GRE8NU1IZ6!h#P-+0!NN$obEA'X#2n;aJnfkCO&
%kA0'al*G*Mb!k'K4'!k!7sm3AJW4Y,!n,R\.>EL?C=>7G>tN"hbV<Ig\mb<pMZSOVm-KG#g
<^V*0%.SeiF&k,QB[csf-4m\SuQ"E,q4W)oCmo9@fcDf/?_gQf"*Jc%""FJ^ro.0uV+-bPAU
^?FX)\b&%BXQoHlH0F=dX]A&meg;CL]A0m5IN\]A!p1+%+VNOpIIoVkb5A5Z_<$2UEj7p7\<n^+
rThU7ojtdk2tm#pU:kJ<&/8kJ'D/=^g1pe&d92C-/>FkHeR4&-_!go\Y-/4u-\&-Ia%;W6p4
h.-n/6]AZqf+FkoT+>c)?O:m'l8o0t`He0<=fe_,U/r?LhMaae-<(lp3\f=cBSDqE[d72:5H*
U(G:=i&4LQdW's3(DCC,Dk^k#'C[QWsng;V!?m=bRr.iNq1@H17+Z,'ARBTgu'Gi$k,k>-a/
g]AL16/sf,@ED(uOAk-.ON9MAY"6=.>SKAC)Wu.i2$"AUFcU2`W@kYVf2#eO&KIRdXT\TbYP4
L[JC350<Rs15I4PZblllb!*PQ8C;d0j4&XQ!"F_hCX-cT=olX8Io]A"YULg%=m?VI!'OYuMoo
#u#AV5+%[4[OC0-e!cq;]A+PI<YUsGG'o5!#KgT:D&N@']A%C0'O:kW:ee&O09nOr?=nI$NtK[
>PJm&&=7J!Tbi_ar#O!;`@IIi>E5,!N$Ws8eSX1gRmp%nh+=Q<9)\"Mi[kd"OW.6uJ]A[U=7l
Z=#/os8+,R!bb@'Wj7mre/`3_BV+Rf+2nV9%,C+&lC\d2.j5V5HHIC^A.7V5k[h7O-p^BX+-
)Y$jD;7Ho$#oM$H*PG#3emea.s8G=Lnlc1*ddoXL[_C;D<YTq@Z<)Ft:ZBM@0NJn-2If8M.J
`]Ald7_&ZZ0YDPLV_AW/W_3qJ509^]AIaui0N.\+f3n`0scOf32F(NP43Uda@Insc20[d4A5$1
UlGHiY\*e9@m,CNR:9+ico(55DpB>bb[X'm!r`#!)=$`C#fk1YqCE/==0[EX@@1@8O_5)idP
s[uG2#]A]A&83='VoDD/R/'Q=X-)0;3gllINoU1/jV@RcatN=BT36pa3\H(1W`47HXAaPS4j$!
2Y`J<r"Rp);3)=GaNl+L?gPARBP"IqUoDr?IIA*5ig>Q1"O6%Ieo).G*YV6(R4>mi$$5p7K_
q%6!-&=Ob<jTA"SH,eIUt29ufF\m(DE*.8#ET<"%%'8_=C/9SH/6rS?5I=$Qi'aUZGH7S/L-
UbW`6&g`RYBbK4C[%K%"g1EEFgak>pJ+CF>A74(\c!VJ*]As'M$0)p-F49]A3(9WQ&?7;!5^>t
"nRB$Cni27&-Yn4s/hh,uE/;%rrTD$`IJX5_oDfgK8%>gau!BJ$BD)"qTD(P`EV8R?50dp3B
V?"(J7rucc>Qg07[12VLB(C.Kb+@*jZ[ZMt1?SA8g9XZSE-d&`F@"f2ch&iZ;m2b7bf7gDl#
trgSkchMfQ9`>/KSAK+b63-J>`p^1^2Sr'_[JX@M&!-Whj?@9*l"jF46b=a]AOi*N@Yc"'/Q&
NdO#m<f#FH\Z63\fC0D0$I)X%#9o0uFK5%:=UNSP$*o(T73cFCU!O\8*=*cCT(%gk"m2lDVd
<K(PdLqc<!E,nd4[P_&1hmuXj*UH\X>(J>%hSQr%N4CP<R7@EVai'cpb/WrV[=g:U$U4>QJ.
=:^>0oZ00RuPnN?$sI"Fh^NI:mQ-=r669;rC)X*Pe>NJYHs<Ig&;4fKQqT*EC9QNO0"YJQ/Z
VL&Ydp#T?NO%"3+#C4?EUJTEq%i+H(&dq3l<nn?UMT/SA;V)6(d&0fWiLJ4Rr-l`s0&MPHsJ
B$TQCuZ6-E_E=sdUUJ6?/gK6[on+OpBXn0!i\,^@`k`X[;G8t1aSR+KPIYSeec'QK6LQ\("C
J`\7k[Yf@:_8fIJRM4BV)-7'>'4[kZk64djAH/SA9Fd:7bm%_""//Q_?j0i>pD.1_\#V29$K
]A8Nb7s8<-$TY6C7<=VV^A!%Z*r%kZPZ51%KLbZ=#VL0J1nH[HMI2I<BVJJD=S=#38ra81Z$_
gW>..ROhYobBjMpd+l23OR@2N44=Fk.oJ2*-@,dP_c'm88/25:IqpY`aKe>cfHU<b2W^Cr6k
B^2RKt5#;g/4rS8)Kh&P;mkjZmM1Huu6>)d!2V0uL=c$ti@H0^,L;L<V(Fcnb%>4L"AY\E;*
>Qir_(F\81BdA7V8#_o<]AM"$]AOAQDf#,n1JtnBBN\=4irc5ruL6M(e#qrLO>]A4uDkNGB9F%t
m3j;%oNR,9"9+#*MDgM=Kp0"HF(Dd3-ce$eQ9"S4^D#<?^t!HEDsFsPX.nXd<1nG3J6f@fK%
FJmtF8^NR4D\#qIE`a`,njnKEeNtal^hnsq640h8FE$V!PmEFeW*)$k(81ud2Q8A&[f'&JTf
gAc-<KaJc,K&JL?hlDf&C$Eei8d;lZo:&mgQ\qLLbiGc$Gt9+qs!imJ'trYgc#l676$9mh-(
TFPB5-BB^Pf@6P4D36JAajW;0<kXqJEh0.9#YdJ(O8l**1B:rVG4hQJBO%#V-!G_Qh9Q+\l;
:-\b5r$f`<m=(3rpdGrr/5<=r*ol7?J%VZ/^9L7T^kqYHIkfTA@*Cpfp?)3&^qp;\!=*X,;:
?MDeFq!ktInMr'H:'Cp0TKS_%AP\>aAeQGK+^0'P5CU_ul;?+LtS\+Sn4I3*['1tAoaBIkeU
8aU+$of^(2G*2kYnTZ1/O1F4n*&C=#NM_SSp"7[h0\u2iMk;T+T^OZmi7-am@YJ"1:Q4-'M6
KZ,j^uPPgNXK=N8T_2c7+mJ"PYjSHcaG%5<X\L9Jh;>_9q5)j+m19A7EV=\&r^E$M"A]A&RQ?
gJfTX6lBhem3=Y%`kArGrghOpkL\UI!C8B/iQb`l#<=c+\3joffrYkd6LSb"/-0(t+C99bP.
V"UUekHo@DLlaDo.hnI1T!#!/5[IFX_=_`M$?nFZ9=S*Tssk<\7I5_VZpAFA=jd0R/%T-WYS
B00#(\'F3N8WFXWcK7'?q)<`M)XO0P!=cYu!#eEkqb%<^TAk)S*Jg/uC'/T3_bQooLT!&AQ;
qIM=gOH*bcBoTmg"mp#"5gsO@5o'3:4\$"$MR%r'R3+,:gT;3%q7l46(5U4)d<f(Z7jEuk&R
16?Egf(2Ik,1R((I*7-(#-Z%W!NPWpejs;beTbh;sC^(=8t3>Bb,Qr%l7s+78`LG)Hp>:-6I
ncKKremn908f_c-[ckj"t`p`b+J$-1cl7!B:'BM`t&$hZBG,<;aVmPsKe>l5'6"W7O)juQi>
PZ'.-7Ce]AFra5+aAlikg$'+9NZtk:_(gACa&^be:<U^D$T?%:]A"^1f'QQ[#!gLE0S.Q.!9i.
/E8-EK'S2q-S4ILCEs8>=.L?oL`L,`0t6jt@8HtDR#eP@.gV4_M0GnJ0!T9/;>?nphSq1qlc
.D#Sn+Mb!,_`r$"@nmQDBnCtB>iL#49Di/_k*=<M:SS=t>XCD6QeG/Cq`h;49R`"f`aaT#<_
A/c46XCR^@'.:r3sT$272qim*k18O]AR240Te8?bsW>c7tq!C6O9?UE.Eu82tUS]AKJosU=7.o
RQ>9q<h=OVW,%+t<+fI0VT4DhGSFL3'<<"tZ&hl8(/a"L=h:rjBB*[P6ph%3Ob9?.KmCJTWT
Z-F+M3?OY%Hp%ihmmgBYp-A[!2o:Or)57M.RCY[,1qrh/UmF+?'KiB[0$@Jd%s:K>]AdkO&1U
O-ljj+n&n![H!M[pD1l=(\i>U3r&Y)#=q"1N\-H95)oUc?j=Si'nGPFI:F3n"l1#+,C,(/((
S;4=B.e^ssh%7AH8_#adb]A!Ma<sA4B#el<g&`7m0=9HFl,#Ri5p*$OW\)tF0r3IiSn1T7;Q(
`9GG,GYeN.4Eu8Oi1lP4)cUh$C985_)ut:I4HG<,41C2[_L6<O=4*s&;T&`K#To4M5iZTin.
]Aq3f4C[HH]AE+*7qp'hkDMr1t[2S@pCd3W%A-_RrRk-7;FTB8Q21XoB)&m@RmC)pB>imY2=ho
EGT01jE?pD+;_?I$55'*Zt6%JRJblc3s[I"e%!AH:p,J,q(QN+=HPbS#Uo?B3bIbQ+&rOSc.
4BkkqHEFq_cZMjVi")_p/994,5XKb,G'Q)WkLEbetK]A(Ynq#u]A0>nH/D^:l!,Ego4mLb(CW*
kK&<lBT0hM?NI^*[7!2lM.@6*>Q0nY_o8X_pF,KHoA=e2oB<h?&jaJh`jRAA8r3KJ(!M(lI5
BFi7M?%]A"9*@=D^$o9Ii+HrX3N\d&9Pm>`SpbXa!W'u6r?d-499o=3;i:pe[Y$Mk75%WYjCu
cA8o$_i[ToVb%b=$OXNkfjnrq'Gco1:KPe+?6\d^G$rc"S;."R'"!Is$BO:=e]A&0/R[@X<c7
u%Y*Df1r<Kri>-5&7$o#l_i"C%:cub*EJ>j?E>D'Jb7Cr$!U1`<eWTAV%]ACpEAfuQrW+IR#4
9gOB(OS!'ubYg*-rf'Md[\9J[7GanLE+Csgm`,/V6+CHP3F\1SucC]AfK8NCg9$\aU89G*r4R
83*S4X&"Lh_8HC]AA+LFp@`E`\g.0A.n<m<H^*5Q:.*4F8YZ49G$-8=6&F56_K,FgIajigA3?
eVu7bs+kj+/H=/fmQmRa)`,,)&lV;)mYDq>LVT7SnpISltg^"XiP7e`7m[nm\:O!N$_#a.RM
?D>fF1X44JC0P0N1hu`7M`S=(peo$mga`SdCi3?G&-gjRoQMmX2Zu$!krX,3ub'qi4ID-PI>
nHCITePe8s.s<C9.G6XT;rbN%2+8Ma;37g5`Os8970?.@ek7am7_jISZ7ObAluocCut1.NiD
t=B2kUV,;=4rM#p]AE94'dN)f3^O!dQ7H_?!Cdj&5mTLD,n:`fNX[ENRQAgkp6+/$1:K^j1@V
C7PJPn]Ak&mcS8#H_RK6!%)@=PbRkRQ#UAlR&?[0OCX#(VFITs4U_2^hIC!3M+JU+Mao+SAqD
=OO_4B,m1Yi:;<0"OhGFPC.rsjog#lM&UDG"Pu\4EQ`qU>)>Mgf9K)!4l#UFjRgVf!S=98u.
6\QU=T=7*rEZO*"'BC;_idQR=S=!#>kfU_<9Lq`TXaFdK)oK+M.M`C!@"iO%<+p/MJEmCOA_
lrcV=?l,KVFLh!gdH]A+?-uI#-<:6Q1"BP#'Y0*WCT)"_-jZ#K+M]AHR3;Es]A>VN5WiBI53<&7
)MOAk$&fd%dgJkpH^i4@j4\\EIbK/5sXS,VhOfWofU=R@R2nlmUhkQhI5M-t4P0GmES[U-Jg
1RIlPW.tMmGj:'o/WuakQ,T$[-Z26Fm_YL/*@QWJ_fee;U7s[;H6g:*H`N.<#3Cd0Yh<r:hU
7"Y,9trr,1>&)!,LBEf_*6rqdDD\WdM4\ncqm-oWsYe)93TjCeKF$PtX2C9O6>Z:6&3qop$j
K]AKbFX7-ZBUb[*G(&F3)jnNG_"&(Z6Wq7@[c7A8KsgIEaYI-*hhm.4Cp6218sqAE/p4cUqE=
7Im6V0cONerZ45.*YHKQiloNHRrVPZ\upX-IohZKBeJ;1.U6%)LU,^LVB.HLaThC,'UjAXco
(:I`?_!<.SH+9$>1peeG9=;WWsL'sTYBW[X\8f=PigO7G._Bgsf6e8`@sL*J-u3d5,oM[!0t
Ofo[1Ofp+he3WA@UD!e+dBa6I2I2#RA+-sWl=Kd$gY$R'<_KCB[D9-CgG5JXYAJN%^ooC]AhV
g&(rZ&"VRsParISd31BmEApD/r1;&Kqd*ailq]A6EELNZ5GC,'qoIB@:&cp7E%qAF53`kg^AM
1UVSlhXh$'5L`Z1O^0ORA8RC>!Ap<iWK0^IhHI=M)>\(06maq750:!9Yq"SiNb8ga5an9JaP
+_Jf!14K@P,2j^,\+"F;dI2>]AW3X'>k;Q9W$=A#m!!giT(XU(8Q-VX#;\041s[9YNrD_W-J?
C6RS]Ad1on*pS`k\2f-&RUt^+bX)Wr(f_*@CesK?rJO\&_askJd.jDL(jVfIAU?UG.Vpj#m-g
"Zq?[H'>T..ac,8*AfHAOLr-hoLl95*fd6J,W#5iQX9@(0@T3Fi;dBAI^asHF?r*7O5C]AG&p
U\aMP1-7$-TB4$'1@[M2^?M^CTjkaTr(`,mP=]AB;:[hJ!!Q7/<VD<8&6G8q=,X`rP##9#/>@
kb8iUnR@AI[Y1'EC/fPcK4J)(Jo4dZ`Lbl=p[J,*tOXhfZ2T(\a_k,&7C78m9%#1s;>@r!q?
k3b`s8'Jkpj!>Gf)@M8kjIHIa0YRGD+8s-R=5/EAVm!#51Z=_R>FaDSr"A>dN1!q%BcZ4LiP
Ve"PJ->>lgoaTZglC.mu]An*lu+%6bE>$[/+\5Vr969D(/VKl<9j6k80"!!RQ+#%);hqbSP`U
c$fO:Yg[GJ?laieZ0?$8HitbmQ4<Qd]A9ppumL/lTZIn8thS)+/9Pu2f]Ac\o'`Od"Yg0:=c<T
BuI6%CLBPhGj8A`iQU:b#$;R[H$(l9/h*7XUBRqks;GSXnqsp"s'R3G3@F<nfF('LT62?.HO
7oqGJcDc%.RA!h7O^gVoUN/`Cs2J*rj^%[8e1!=T.!LrAC2*Wo(jM^o[:a1[6p38VL$M,N`d
*-rHW9qTG;2mNE%D)O+<3U(UJHMhno;QeH39[!W\Xat,*8\4W/6Z.]AFYnD]A?25tFB7sJ&\`t
rAELBZ+7E$3CGkVt%n6F#:W%.P3%>r@mJPWD-B6YlONit@bI%DG_H\f%gGCBKhR_bu)=Xab>
o5CA/4?iS0k>ksQ$]AUB'VWu(tC;gLT#H_6@Q*\!IS_/a,oJW629E(L/!^jZ=/[_M7s/WlGD%
Nuo'kll\VA>;Y9b(sPrT(Te\ouh1#)>[`iNKS)FZpEN'j9/>NsVY*auP;WEo7#dNf@3/`6u5
9m^GjCY`2*X]AV.hI5YshHVOj?Cbs?qeRkMAg_"1'7@6aicm&mHlrN3!H(EpWNAI\rj]A>m->+
!,JcOk5I[]Ar1iT.U</Nm_"ZF,$%[-@H;nt!V0t7k+6.m@T^>[Ab@Chka8Hpld-:3Jod-Rk`X
\tmulSBLL#']A(@aLSa6JCS(E%o#`3lIi$Y+6SE#EQ3-Wc%\'k"pqTTb2MJNkJ[T4)m5R1*ab
a&fj#FGZ_Kq<mZRb,h:Aeop5<d0$?eW`$.J:TV[Nlk*j]A)cDIp@Qo/HjlY6p=>'Uo[ARYLPT
?c0pd=,ormDkDO/!p76e.fMPa;T-3eun5WAdYuHq+9h+?@!V^3(.DCUP1XqJB$ZIDol2s!tS
*+X[qlY*^m()!]AllTM+HJ0_207+t`+b;)-7LTulZJUriA_[0m6>mid>H&%QtJ#T;T5le@0GK
]A\1:8rg'Qq"/7R(2R*0IUhA>8',X;$a:BUqr5uXga7edOlUkG1R:_nPW_P@SQ!AnLqFB.FbF
<%97P=)=''h6c)g.>iOO\H=g(]A+(AKe);Si<RpN3m!r9`^G/NWJaVJ2<'+ZHr_75'fA0@I+;
6_cqtS,\Z<[d#j(q;>$gGGc4_KTa(?akla,>Qc]A[,+j^Cmdeq0%s0*HiioGicmt#u#2h?.(>
Sf<"l[eUlf]ASNAb<^cD2aBGMlG&e*)H^i'#S=pA9Z3F:9Z9#AA$T]A"2XaqXZH?4jbRoH31C)
hT6>1@Cs,tY/B/72S[G`KbU=ML#J'`=bTlcb#7p0??D+L"d##llX^YVjPSjt5e+D@NJh_Zi`
%4JqEOEgSOaH-3L99&4T8o(Mr>]A8lYQk[@;J-I5S;I=8&a#J2691*_UY8^l3il(kdOOIuL^E
_H.Kd:j<GB6h9SflR7\tX^(ml3X"`UNKlf#LJV;Sk>rG/.hQe+$mk_b>\*g9!I,3FhJ*5!O]A
cbu+E@'uKqCgtACP*.+'CJ<D>U*U<o*j0\ci6pa2_8+#-?E\S>c4\mQ5aBoAC1FY7hOLtJDT
DVI?Iu+.m\?o7@BG`%agL!k!t'aeLUd`img->\*P]A//lKhh?@&d-nG+7OoM^Gd+*<")&FKRQ
*_%0((O)[MJ^F0hg[Y:>fAkGA<XdLp*:V,$nmR%u$8mW98,i0f\r?"a7raAZ&Ij"QCkkbf.H
JS$SYutRAcieVjN[!ItZK.jr<>40R37PjC4a3ppHX$Fk-M$(#K<"$2\oHtX\ep*^ggbC4`qN
6HL)!,>K##R3Y8B51BfL=sHpY'/.nA_6`1tOnV1SEh'om5\f(1e`e_^s7m4A5e!DB6jWNl@k
aMJdJ$KY/RW2:[Np2f(C;8E1+DINUb8CE$/)Fe$iYj-Ut.fPLG8@_C$)ZcT9s&XKEfupLNE:
f/MDPm>mP&s/**lj.c%[DB:Ge)'e6.IN=UW9]ApG,id`8ogOWgM>7K\)@u&h6Wci.PUil#=jZ
6XbB@]A*<50E>opGLND:O.*^nF`2T((X'Z3_0gLuC:@f`QC;qPf]A?F$CIc?l^i3T_@CF5QYUI
,u"o86RJ,pQ$kH\(LHHT5l`ZI'mA#5SX6?g;<(o1QSVD=/MYlff$Ka`JCSpO"BlhN.gCf*K[
TMegU#@FC8$Fh(kIk^"`r&qkkJ*6&Vg9g1I-5UZ0`bLIRRlpje0flT]A/&!O2-Aitd5_B@Fs5
\h%[2%YagO[CD,*`9/q[("r0uFtCbn/QKVZW<\b(DP*jpcmYX)F!eg=X*S\<*RFVog+So++<
^:_XUZH&]ACGr?5_"0iP#@8kaX+nKid[]A]A\Xl-pa5Xd&SO<,`]AQYIWfm%92`E'OR&Tt(a;jm*
6W;cI>e&hLice7,n)UaM_]Am"$@Ds8Vm.)[P:KnBIu_"H#^;f(1RQUR!@O2qec"/DgtrmJ=(j
V9?4N90*cs4(eLEKhX33SS._.4&,^4M[;ZIn8.VQS.!HlbdnVAOUs*&#ZU:\bn`4lMd,c_df
rsM7D:c`2&agMEe$Q1:Tq^%$)7X-ZZ^YrS43FFs*<$nGfec;47Xtk+*:IJS.sFjMT-G49^@%
h@tPG=Q*\"@0C^F+q87;_QEk9MO'5mQhs8m!kbAOT0R+4=_*J86qGGXIl,@2oU'i#T@0Xdr+
IP>F[c>&<tB_tebDOQs$&h`Oam&:Mc:kk*&AQ)@$4k"7/p,ZEqs#"T[Mf*pdJo_?[V+EEd.&
iV&R5ET,?O/");$b]Am/qC"F&]A(AL%:0WD[$iZ+?I7K6CTHP&=Xpq)9((3a64sU&f?81q/=7o
VBUZ=8UF\s!M8<`TS=Npr?@C9c@qZ6qP24TsU.2l,c&C%dX&bkLH-Lobu@a&EFbANnU;X-k#
j#JeALuIqUFlMkA\lcHX<Cnjl@Ci!KaL"CG80M+0h%,/f9\<O"Xg(f?k%F#d3dlD;WIRL+)K
PkEKmSsn@Zp]APO]A6Vl@ZGd0%'E"_ahAX-g7q_'7(/bS;'4p1=JS!6kN#n7a7cFM3rDuE]A8?h
-i>b"VjK+MET83>8JSO4_d.2]Aq9t^l,tMgAgb/94Hq9&Z)7TO]A&HBF7X^Z>_a6EK/pD?#qsj
:L+0k@OHpXt#Y'_BU@>NG>!:b>&q@F"g94deF;8P0PMH>[6QR0=Ls#XT't7F28#gcA";0.6"
Pfo$'+U2lrAU%!OpGfU[\rM9p)("TH4=+T;0n>!nH/mf=Ri`c'c5u7Gi#WP0*G15;nP(IU&a
0.lg!U8c:P9`L6<Rk.pm<8;)T<]A?<R"Q@NY[bG4sb%p)h<s0:ZnR.ceRL'&phse(Fp!X[o:6
AsqMCgeMEQ#!$IPY`<3tq59G`-]ACZaC1PlD>^_>leFW0)1O&5pgOGqR6i^O+I`FrPi3'mo#W
96mZ([[\Ol5(,C.h\WqR\D)5*gj(g"XZ'0Wp.q86EGF3Bl8)GVI:0+K(>#Nh"MBrD2K*(%5d
uaP0H28cr`)-hb6o!C8:r7**7g@s4=2la14b9,]Al(:5Y2Mg([Wuoh3X",s8pK[=EJP!"fsXV
e[TAGUZDWiD,,spueSR"A[U>'"ggDJpFO&H5NS%OZ,ROZVgB;[bG&o"S"GHSTl2B7ld9OH(i
^jk!ao`.IUO)`L1Hsa>0),_dCS*.5QSV\6*0jl]AO2D=3Oj8/TrU/X"uSUO"f\@0(Fti;GeJ*
UMD(3R2]A"b,*&8PK\Co$%L.IL_Fe*+d&oo!hSd%[/+43_.+8R[Z;LfQQ;o3-lYaGBD+=/?Aq
`SjCsDGFf8BfEhq`#f1F_km]A#BD(G2rLCA=-eT[!h(@FWtpN*!9i!l%]A^X)Eo/KW/Z=s260,
-66hn*Pb^F6fH4[W:BpqOB<FY1922RG\-H!gU&^@nS?k`cF`EX-!`24]AA3su/m-$fPjAiia]A
+<aPhj'[r22KpWR*er1E:Wi',]Ahm*&'F$h`QI!j!qru]ANC9&MCbjDNiFUb30n)=bLU6p"1K^
tn!Qe24PG@ZiAl\PFj)KU8iu.QLd3@.7r]A!$5i(aWB0cF'eJ6MT1Y%F7.pAsV4EhSRke5\Z5
RD:A/#6cs]A7OI_T%Xhb(*8i2p?l$c8RRiWg;YT#g9`=o2HB!ZJV6ICS6rf&F+dAlb@FOH:^i
.T..E[1eV<J=@gZDGn."7!jq&G=[/\U(`$Y5pD'&>rCO2r9icGWhqTV@1IhrRK=K0l/NhT)B
[B7?!PM3omlT.0Po:'fSEK/04%55f$tod!$Y'H5A#MM6_sluJA%licgoqX.p3TRk=R$l"Q5!
Q\T.*!YYVnp?6(a,Jl@HbT(/0kL8.d3<pTOl4@IC=9"g]A5O0Z5:a_2*?UoIFpk%AMdIbB\-1
)?^!8kI!mA<JBK)5*R4ZN1R4V^L=Mu\n,R*9'cYi"."]A*\p=5^PJV'i@<[INIsDr#rkfiK"3
]ATi]Ao;/7'!UUK[%.qLIj"C0#%#OF;r4WO5GK%JpEiP2:!llkA&!$K_j:dUmK$-:-2;%j5k1f
2C$r()V#n'/dEYVJF*>QtF:^5F<4C=TS5e?Q,c$X7nLA8b;EbE/^Y\V^'a1t\]A$]A$*Zhak%(
1QA3#4(+dAM=FT(Y4ZseA&Ja).q]ADp6fUk'#Z7,R@(%JD^aERB9AXrPIfMM6&f\DADo;hcsN
QgD)P,eVQQ3O(nbiT!4#-M6*(pJp>0%u^:Y%6r'oF`X%ntM_1;Y&Yn;g^M87`-*1#"Db4+!g
L6*q6gnH>76[4a7_*kKs#k#sNcHJ3P/oB`p+Jlibt,j)Z0pail8`me+'mN1$of'pf-?H''0h
Kl/`</0>Q/*%iH*IiU,"SSg:s%kj0P2`=Z\mcHE)!oNjbk4;LDRt#d!E-cinTa!o[6;'oC$E
9DXDcm=\F=W9-K@KPKE39O9=Djk,?l,C+Q%+@(3=#`^nJ1J)C7?%3'HMJ"*cBdq<;?=uo\(l
=@Gj:!'U=uKnO)!VT('1;L0HZjSNIWpV:b#bF(e^KSCo;,kB1./]ADf)!OI+m-7?Pp%n*J)4g
]Ai%3dsSjM+_9jFM05C"j@A%'FH\R'HpnYD7gJ@05AE5:n![<;D$uu7>4"?9\"#tr\3\trh!Q
0l&GOZA47n/gXjcS!XJQi`I*SZ3[l4\b<iAumV874bPSBTifV:.^`@GL!)eks'In#m;:<7ml
KbIABolT5s35H+L3bf`)<6p[4M9$M`'.Nsb4tL$G63JKI?&3GT^?]A17IMrl;T*c-u/)0$AgT
A@H1#+<1UY6l5Sq@2j8?WNARZk#EPn$68@7ja9r7b5lS#r"/WO'@Rck@]A5"<>F,:q<L6Xf8^
W`_(1dq491Q8.!qL>+:!E&_W)0eke*h4Wrbe5-M[%lA>SAGBIdKJ9_gUa[Tbk&6:)?L&^1#A
0@gG4L=O\^Jpl5g0-aM57:LIUe0)1]A7\(Alfmjs9Ts78EN<t-@L,UnXAS!+X%tGH=;!*&WoZ
U4-+uLWZ@9@gY>rNqg]AcR38i?n-dRRMZg:$,MNM%tM`8N$qXGt3hj@t`HkTbm=+\)0HfK)p/
L;I]A1KA^MimH;Tc=9=UDk490`-Z5^L&diBnVnE_5L8R-37,l39qbsD%p9/k7ME$NkoGBJ^Rc
_(9^T&`P[GmDC:F71/cc(Rg^B\$NK^M2O:$4a)n1oS%GdGL[CAsPO;Ahc8!J!bn%n32*HQe=
>3UXZ;hQm+H\cRn.&;2>cjp_(fhET;pHto]AV=)(T[X"9s/&_:hh'$&#kd.2<qgt%)2?l:1g8
ruk@PuHKSAI7uQ-XZ%S[YpAdPl-sMj"(dDR`aXBNJoi%XH[C9o,tZ1_B'71QoS%^7qW?`eU2
LgdW3g!k#[^#ETm]A$UJ0>F3]AY"&Fjk]A@2-Q]Aq^NXsOh=.A$7B(N18]A`p,DJ_nad8N]Alf,OXD
XD%^0(!`83D$PL_R7BX+5%GP"oBa_E&`WBdYR^)k`*'mJ*]A@r@XSOd.Vo7tmR!Oo/3Q?Ch3$
Y_/>*K2qM8JNr&_'8Vo;pVRTnGH#'jI=!qN50V'75R0JHAk_PXjOg]AhYt)gIZp1>-C0dSL7i
8CWcA4r,IRZ2lO0^.=]AI9ehNk]A<6IN[T$EstKOgaCNhiRIh)$-ZBJr4GI>L;E&ld@TJEk4)a
sq3(aV%=DRT;^h^o"q?C!%,-[!Bpo<H?40b`q%U0"8`$d2>kaA)6l=M7Vd\)LU&2eU;*)n1'
YW-ol6I4-=,jgu\O(aIamtl68d`:r5"UJPJb1.&$,73i9]A/[#lHQ6C4fmXc:L&eB0>3Se*0I
hX]Ag;J9+A1o%2<ikXD(F?IF;sS_HXd4;qsirZHo^rRM$ZJ?a@PEKI$iYesQ`XogldZar64H'
5JMFO"15R'`9]A?am`[*]A+]A3'.[LU_^nfcjQ0-XU`#1'HS00C6>+h\cMCfK)GMU3B)DF@qr>e
Eo3ul"d[n#l1X@f+#pqO3Zn=ChPt9h9<\p/bEPr,;s8P'U!d#g7HT;4j/HcYcJ'0+]A(`UEUN
k%m2ChN&_!-sVJp"=S!CYmM=$HVrte>ch5NH"VUJn>W?-4Cd8Z5=-f)6K$'au*_Ug_Yh=YHA
H#ljdHp@i0[LYnp"63s[-*HsEis_)D=6Qcl_XVmpe/L.Uk+2!NrAOF1+RocqB'rVhO6Kp._7
fK9iE[i&ndlk5B8S58641o:uFcWR&>n2-KSY)BBH/<]Al]A/un[<e\?W;OrB3<'inf7p1enhmf
)Wq$60gF,0n%E3:1>mXPZl8(_)QkW;o0?JHLV9,p>Vq5??\IS*ok4)AoTj\H*[M=o+AHDPN#
_&<JQ`'&u#@!0bD46oCP/JCKLs4,luN*FfH%\cO^$1U_AtKY1)m2R-1.Ijkl6pq)tjeR`:^r
!GB!SGu=<hkltuAQh;cfc_]A4Hlo')51mF)g!4I20-]AJ+K[?L=PbhC)a%&;76d9X/:R5N(Z\f
o"B@>p@#,nFd&f"7,&B8]A1]AWHsi&r+QL*3(WVgTM]At2Y(XKVS\M,9Je+@/4#DBY\=VjqEEn+
<gQ6LdU#?4k"9e5,:MYq_s^kbi%1/eKWaiiXVAKu<Y<N@'7tI)jaq,H3Eft3OGE:s&/&GKEm
HgKAGEq(85]ADVgJGg2NCDQ5l?Mp9CXM\Ain>X$X4JltKT&\(rQVK=?HqRH@+sb>28a#H-C@N
&mAgX\(og2HE(mf@+Sor?IYX0Klr!-SI?GP!iB>X@o`F4b5:buc/qlT\q*j,^_NS>R>%#Q3?
MLm.8c%,l+08nL[rL-(5K@*M.?*-u;q6C0VBA;06,>LZbia7JRn++fM_9pOp]A%Z=S,cBm\!q
O@&:D-%3U)Y8?!\QC=qT5$H0eV2M5H"Z1>4s&BXZBd$e6n0U'Kg;4B.<6p\46'aV5RHiI1><
NW<VdHlHsbNZ`iaA&I=@-J$lkh5p_Z'Q<F\o\#f;Jhp#ZK.WjH?0Y+$^_cH2E,//7N&<mLC(
Bq$MBYSdeeGVQplZqsYeg1HWg1sWZa&!>WC\k,6IM=<G&r4/[k99'gQf(E-g0cF<3\`2E^TU
Q5)CT.:0ZNKQ]A9k?n5Oq&HIVhH>,njsT9=M35FcklRYhWR\AQ1=auAO8rlEgiK#H%nPVBOns
2<Eq:()&o@8\;n7-OmDeZ^]AJ<2:D0MI+)p=tN-D-Lh?@=ueRsI)SSka6_D&la.j-n)robhi8
d;gR3C=)),E'/1cU748]A;N36Z4hU8YnRBmuD2&4r<OY':^[2I1N-lSB?b:06Aa^9#bI2W@SM
k/T(c_u%Tm%HD1,?_#W`Cs\pq*nR!58_]A&H6*_AC\n!0Kc4Nd0Z.?kl+!eE(9p!1O@tsBXq\
5RX.AIC-#X!XHB.OZRkg<i!,tXN`HZgWN1lX_iKp'0$T3ti@%_/uC?30WJ[r]A`83qJ4dfa/6
XaKSaZN2(.4*VU;S7o@rMTI-_6o]A\.n=0LH1,Cj<s?DHb2eRls[rn7A0`-[PKh[l2l'=.97k
Hhp5)E0g?POD%aq97MUD!Q-&^t>8f($$Do*VQrnC,O01S0ed6Mo(-%#g8X8);4Vb8NV5cL5l
^2<RTY<q8WFo&Xi&[r9kLl4]Aat?Ni;Bnhf&<R*HT]AH45;1CM1E6lW\<#L00S^UfJ[b=:.>uh
U.:E%jf8<k(&-b;'6i7Na3Mr<N0b2Y`@nm8+t9dBA;ijo#iq>dA@C):cDq"2\o5M`"-S%T)V
[9[KFIVPA3bDn<@$kp,`Wnk]AR@C-c5Q^h8+2obT$=>M%N"$*V\O(V7n=Y0#!r>9_Vs,GBqdi
\jC!`5QDV*%Yuq%P>%PWN#KVfU2*nPpp)?(s-17"@q`=OMkn\<6SYo$VJ"Ui._XD$A(K$YSm
G;#i332`4-L?s+MeN5WfoT@D9i'_U&!JuZ\!Z]A&O71q_okcQMXUaoj%QI<V!qnHg3R4R7XFa
)g#!uqO1KNTIB"+[0-QD*E%sM1SUk/VD\k`:5V,nP<5>Y-OSPAY7-:#j'BKBTn5BZR_).XNQ
\[qbB1^EGA9.HS86-G2amjeZq!Lj=o'lr]A:2o'0*#X,mqfcRV%'Okg7j1ii,=<WDOm',+I4$
S;o^,\Em4h:\,OpN\e-/Eb7W`,T"+?Ndd4>%eu"n:<rY6D4d%2Dq\bHcJ2V=dYB$Pgpa\QE]A
`2DI%ZoVf&)2;KBlF;FEGER^drlnO\:r3K"(EYmb\.\#G<>^g^8`\8jkphoFXWMmi=Y2>e5S
^8cW@Adht]AaL=VjgO4VD#[6q"Lld).br6+_tTpI")2&NC[l>rXrd]AEP_Vb0q,u[4^@J@V%N[
`JYo<XG?<e,7ir<tfr"iR<!".d[FJJY4oa[s]AS]AUX>!M5"Sb``J3qE3>=k2*>;T^_sn7f`5#
6YDhI;pW$6CcNB=#lM;V2_'JV>JMq>B5$.-O+V/XFcgOeXR*lE"lZT'@YM-^S_(#2a^^ar.)
&M?JFqX"ZWX>kYUt`G[nu22@5H^;^V2lRN96,VblVdFs#'E:k#?A@ArZqk_1t%@fk!V+I*GF
D+'g&AdNT7;q,6bGDl6:2%,nHg7QFfa:W?`0o]A&B!i>kjU!It3WYtE%ea0:A@M+_+3M+I5`4
5R(;ff=]ApL>9:YeX1d^UT^/qa.d1@_YC>!B'-"HSVdX9mS%I^SR_L/AuRI'Gt=[HkkC&Iic+
'JamkKO4N-4>H@[Iao5,*!G4,)`n0X#B]AK'>%#lH,4!KZhkXR*qA*.o97\*mtD;i4tK;#3j+
Qe<9/hse&O$I'IEFJ$ikFU9_#h8#q(Ub7\+'*A4V'HkO,D6%QPq6C`;qB?U_Lo*B'bfh;A=d
Z$]A$m-'V(PE:58gg3qr>J.s?jAbor%+84e]AEjEOI%kJK7jL"Ab,8eBmH#&Ja/*%.SsRIfQUr
Vq@q)CQt%/Z;DO/@R?F1(i'bj*^N[.^-b$*8J,/Fl=rOAYBc3Lc04aRtW3<u'8^tr&Jfi&J8
dhG>)2)A+:"0fLS9*or'Apa6$3n/,llkVlmb#;2;6NEG%8]ADoVB5J]AFdI9MMb7rgfG5?#Vrb
rs90Rbik="4dIe-\mD5CZ;WLRS=R,6p%f@&E(qPk/'L\`oA'E\M0LCr8a/VWiV.#c'WSuU,E
Bich)P`1fXFb5hZZsq:&?t]AeoicW%@rLdm1bn7c'0[m&_W'dG3%T<n>2Rd-flnH,=@W^qmP9
u"XJ]A_O)`4"=5oTZus7Sf7k-i7G^8=En(%IkZ+"f\5Q597?g,9>kq?b:t,:DrSGfHjn:\Qgi
=ppES*4@d&lHJT<H.Q%AoC@%3=J=&0-kp:TYpXY82,5i721(7MO]AU*A98]Aqj>b8gs5l[E%uU
U&1i,hqDhCX;i,nc8K_RqN`bL!fVe?Q<`cGaO\^8t#VTE4j\4Y"'T7@Hfokai@ZIl2PTig">
Lr5;)2GQfMT4hoW"?`c>XGI;&R$8V>ji:,]A0KaJ/U>m=DqE0'W@4F)In`rnSbelH+=XqRd7.
]AMa2bc1O-'N\=<5%_$,\[9cO!Srrii@IMbTI\/4MVG$TglOPU@Oq@CJm=hAsXbmqJg)CVe-p
OXP5*jig6i1a!W$pEXHG46,,W7H;`Ng3RRdh9h==4IJGGH18XDW]A+kYPgbI/QU66pc^+,DmB
X?@J1WI1uI'K0CT@T;=*h6IkXU41%/u,eJ;)G/P7\;G?dUW%4`[m9--:G2F\ffI(:9cqO4^F
mWh$E9X-W+"<QfO!./.oQ5qYO.&MKJcQL@-2,J[?]A<2#iq7<YWmG?'IhD_R>_*LpjQ(X?C]AY
GoH;lNP\<Hh'm<iubHI/O!9&Md!.sXqiTKtX(C6p`(>;o-GhIO5j]A'/GMER[+[@%DY^Q:#61
9/"NqCo*GhKTfZRI?OH:;Ju;4q9K1PVA(\6I;]A):*ET?!3tpT[n)8r=:O_;5RWT)5$g`RY?/
dW0CW_E-"'[l0*Kk%UZqY[<&&$nBQ!,q:?1'aR\N)0LrNmS;HS:g.gscb)?Pae_Y4=aJ)hbJ
Hn&^7,FNbh,*kcbZ)bN0OSIj&d(/CB+-Q7?kP+()p0#NO6Pl=rkd3ZE2%GoFG+(1>epJRmS0
RYcZ5UXPKM/f98f>GZa7??kGI6mdf3?2?k\hWaRP0Y/tEc#[Yh;T<q]AJ$2)I61F2L/L`qk/u
fIbgo^V_#)bV-^X@AeR[k#7S<iu[V^+71UL&ijrPS0pQ7)J]AJXU(R;@99gTpG5%QIP!0ifiH
l.ZPAH$D@;:77B9(U"A92RXmQ-&^/k4_@?RpILsS3acn_8RLuU:PkL[I_TQVNqs%08(9BM5#
ipuC;VqIX#c`d9hEY-i"F4d7&5>DSKVl`dIL$S@$m\,NSc4)XOW\dUpa9Up[8BM^I+tBJt]A\
kA[5D!f!\ESfP-BM3Tg$XgsO@2OM7@n6=kI+[%;-N:MP/6d-1lo^7dGY0oDsa]A>o#aZYn"j2
gGX,C)VSL7:hW!#$<6(PA:qf5=jlohpYT_N0$o!h[CO4FV*Y`01F<cC9;2sh^-!6Fg5.qlkB
TYNdjZZCeRl8]ATPKP&E6<qA]Aj)1dah)%h`;AIlMGa"kHKf`cSU32UP&fuLeh]AQ%:m-E/[Gqs
>,Br!"$c11mprSDH,m[PS=GjOppIL)RI3]Ap-_aNJ)0Ri9$RSdW\6Z"E-5)S=c%deSYib@t]AY
j%/3(s$DH@NJao?A!D`"j?Mb9CFBZJk)]AotTb94.tD+LnAX`d2RZ4,bc1j@O=q*17\46'!b`
QHFR,6+V9k[q@m+SF`C6C#^)u@LodMBN(Na<j<Tk^[`Y^!HhPb9JtG4ql/#eFBhZo&K&sZuD
c)OsogeB&7:\.DOqn_C7FijF;h?DB\'onPBd5FmTiP)J\)Sf)pqV/d<mNV)HJ29/mIdQ,?K$
jVD^3LcjH\[54f']A[8qB%WUQW4f?A1udXEf^4NqHZ,Sk)25R7p+^IKsuH@OVF.B<=//;^2;t
1tOHMr7!H+/)pKgq+EVS%f@(=U>ee*3+bNi1YjOb"r#lK\SeARqlNbjkhQs%Yk0f#64FiA5!
A"]AT(>R=;@9dN_c1iCXrhK0GEIX5C["LJ48o!R4Thj*Hsr1Ek3U^S41S$_5.90Pg/E:'XdjG
Gd_!u8h8LDbg)''T^\,fcnG=TY!FMX\H(O+rAbKZ&Ks$q&P!&03/r<$Q/t.+\f$XNV,Dk4G$
!u3B]AOcbNTV+heF`lkl^(Pj*q_tu"fUX2aPS`34g0r`')LXf\:;.Bgp0l.H).r2W9+/JuKd&
a_)u1&U5cZS_!)%3InSq($hN7<!'.`_7deo?Q+I?4OTV/Ae^9GgFgb>WlogK)SWs@u9f"=,Q
ih_t29=3H,`C+:pX).ZO>;T>-&@Z2Tj[,Xr@#$[!\O71'A<u".:mb,53T/LelMIX5&GNu[,W
:k\/30P99QbT#8URJ0WW(,M"&c!bK)IC/(V0s#@<L"c`upc%:?FF=Z?kU/6>ZJHKOEG0d*&;
l\qt@`eFsUa$+m?LdZZa_Y;L'2p)\/?45Z(D*?BGL\[F;,WhY6*((&ZSIT>$%<*%0fY$]A_`>
3\B%kh%^uIMC`nAb=4R""l*NiK,mm$)C?f?9M,M9A`lK)6+Q110SX9EACm;&H5k,[6YtP]AOt
A+E@=Y;nJbo>3mE;'HfZIf`CsW$>Rt;ZW<2C^C3mT1QT*&FIhasp%;7c-To&Zo@l<?9;)FF!
\__5WhTn2=_9LNZbfr#q/C[eWU_&q;7\%/13+ZcN65t2pZp&+\_bGo]A<4U'I/nT"u_s*ggl(
[-'%8n=GhUf4`]AO[&!T!tT[F4?=2j`#@mhWMY$]AQ'`cS-+GHPljap8]ACVWC95Sls4dgNp+mX
=9e@6tZ&V14HWj,flP#Pr*4`WQ1gP!`fZ,6klb'8Q)FG$!mQA4g6sU]AGVO2dfJ-bN.Ni.p33
g^AS4VD,pCNJ;&Vd*$H%gcV/"O$r)b$-Cm:'Q%+)?[$ice4#rbO+9F*Un!Fql$-JC2kGTr#J
R=*6DVX-[KQ?C`l1YhrK6/F!l=\mV[.@R/Ge,HtNgkrGQNT>;V2j39(rJ1'J4`Y>9p[2/*A+
dk7%O.o@X'Y9k$$k*AV\(Jb9W.spXG"W[!\NFbCd?=Zfh05Edj/PZ#Fh>ibo*E,m5O;TQs0_
XuYg>?+K]A?j1M*d//"/d"<+E>t_?LZHT2s"u'?e9[S[]ATCgoNS2V%ca_$.e_>;hfnfX(:P`A
ua8FnkVm<gm6MX[\L2I3l<l5`U\ICGaPuC<rAV9,NersuiD<.o*,J#CDP:"(V'6f\IFnOb)R
UFGSUXYHgch59)%FO":aEEc7KUDI;nUGQ(_B8^3d5lc)L?i0eNF7/j'0.MPfUbE'_a%>,-V9
T6W>nUK2=ZcMpDnJ%4aKV.d4jl*:^"&Y5+r(.Y9HuN*[K9eoX\`#F]ACgpCt\)H%sJknX$$$n
#FBiHR"t=Fhc,I9<aA`=l./&HC!d$S[;YYoDE8dDX/cSs60><\,_Y%*_K@H=%gcra6CO3g&r
sWXc=StA3H77t'8FjtU/=<Vld;/Z$)9!EdloY#+T"MEWjq@Y<&$241]A(!;]AO4is:B8sqf1Ib
N2YnrN!.cn]A'S&H)Gf@IaLHq*(JE*s>B7$X*O1f?2#"$?l'j*Yf<SbKA%,cd68F#aJ]A7FF"#
nU0ab0'0J%GOIGEe2?dcLppY@"3gL/X97pStM*@S.+q+hr(s/Bc\KO_s/nH:g!?$]AdZT4#hn
RgpDZC]A7alQMfGiotQe9AX`'mIDo0*gCRh5Jae*7Zcs4OmX8E>*,g:*.KEfiJ4p)p-6lZVtd
GiG=Js/mM<SJm]A!3[KKn=T0.PB(kOU.o3-:U]Am)^DDk9An(W>Vi?ugrs7t;9UXPi;!p$Rnib
.#!_Qmishj1,k;rS$NIdkS]ATW>/-7eOGbZsM&1[7C)]AnY+2X*,>ckFJZG:0n$_t/V<:K]A>F0
U_D>dX1K[SJBk:gbk3&IZTLRZV\\:G>.K?!+/&j?bka<Za+/U7*:KD6AE(pb]A,4U#U'2f)-=
hE*>RG0Z(IsH^L8N3cNR!eB5Ek_N)k2R'4:jG!Sn4.0-kr0-4q=Frtmo)WDEn`1grkp&9geD
ec?JQ]APRTVT+;BLnST(O[t?6[X+p3X"6A4]Ae*cl%(A,la^J_b3!si9a4E\t,$jIYlL:khIaO
Pada"r:7#2)RCtOL%hX_ZdZCr3bI4)2e(4@-;0<3BA$9tWoBd+lNbq]A6qUp]A0+oE(QVc(LN-
082mjg<f=?1]A7E<$g=`c!C(8S4Z".jf$2'2_=C.SE*iqhq_kjMi&_9!ik`/:;V.!L,iA?uA.
3c@4Yb@u("=f5)_=bt5!HPEgfJ&X.^rVI,!nEO+=hpBf`P.IpDFqbcQ\W\8XiGM7;Ff5'tPR
7A<4-6?;V:E/`R"TM@@3!llHYkf*AoMsl:<umW#%u1(mA&s,1f8N@4#WTVdjEH,2[F>*LO<_
&Q-*B_hRQgJ2V&/_(H-\>Z&)TV1\OH#DPd]AIMVsFohG@T4:P4u\aIY2bRIUBd21\BZ'=4SZ0
,^$dGkX9&uSGkRsHW'bhDMEUO$fp<QIVA?61l6!SaQE74(c990F9V\7os(B'iBu)Prso~
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
<![CDATA[723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" cs="6" rs="17">
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
<ChartDefinition>
<CustomDefinition>
<DefinitionMapList>
<DefinitionMap key="column">
<MoreNameCDDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[签约]]></Name>
</TableData>
<CategoryName value="月"/>
<ChartSummaryColumn name="目标" function="com.fr.data.util.function.NoneFunction" customName="目标"/>
<ChartSummaryColumn name="实际" function="com.fr.data.util.function.NoneFunction" customName="实际"/>
</MoreNameCDDefinition>
</DefinitionMap>
<DefinitionMap key="line">
<MoreNameCDDefinition>
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[签约]]></Name>
</TableData>
<CategoryName value="月"/>
<ChartSummaryColumn name="完成率" function="com.fr.data.util.function.NoneFunction" customName="完成率"/>
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
<BoundsAttr x="8" y="1" width="845" height="231"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="report5"/>
<Widget widgetName="report3_c"/>
<Widget widgetName="org_name"/>
<Widget widgetName="org99"/>
<Widget widgetName="info99"/>
<Widget widgetName="periodtype99"/>
<Widget widgetName="report7"/>
<Widget widgetName="report7_c"/>
<Widget widgetName="tiaozhuan1"/>
</MobileWidgetList>
<WidgetScalingAttr compState="0"/>
<DesignResolution absoluteResolutionScaleW="1366" absoluteResolutionScaleH="768"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="956" height="520"/>
</Widget>
<Sorted sorted="true"/>
<MobileWidgetList>
<Widget widgetName="absolute0"/>
</MobileWidgetList>
<WidgetZoomAttr compState="0"/>
<AppRelayout appRelayout="true"/>
<Size width="956" height="520"/>
<ResolutionScalingAttr percent="0.9"/>
<BodyLayoutType type="0"/>
</Center>
</Layout>
<DesignerVersion DesignerVersion="JAA"/>
<PreviewType PreviewType="0"/>
<TemplateID TemplateID="3e8d5558-73b9-4e98-8986-e69f140fddad"/>
<TemplateIdAttMark class="com.fr.base.iofileattr.TemplateIdAttrMark">
<TemplateIdAttMark TemplateId="c25c5864-3a1c-4e3e-ab97-58c34c70b87d"/>
</TemplateIdAttMark>
</Form>
