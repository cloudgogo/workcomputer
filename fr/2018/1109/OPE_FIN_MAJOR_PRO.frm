<?xml version="1.0" encoding="UTF-8"?>
<Form xmlVersion="20170720" releaseVersion="9.0.0">
<TableDataMap>
<TableData name="1产业新城重点项目" class="com.fr.data.impl.DBTableData">
<Parameters/>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[oracle_test]]></DatabaseName>
</Connection>
<Query>
<![CDATA[select project_sum 项目总数, 
       project_normal 正常推进项目, 
       project_risk 延期风险项目, 
       project_delay 延期项目, 
       node_sum 节点总数, 
       node_normal 正常推进节点, 
       node_risk 延期风险节点, 
       node_delay 延期节点, 
       nwnode_sum 下周到期节点, 
       nwnode_normal 下周到期正常推进节点, 
       nwnode_risk 下周到期延期风险节点
from dm_project_summary
]]></Query>
</TableData>
<TableData name="yiyanqi" class="com.fr.data.impl.DBTableData">
<Parameters/>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[oracle_test]]></DatabaseName>
</Connection>
<Query>
<![CDATA[select * from(
select entityguid 区域ID,entityname 区域名称,count(projguid) c_pro 
from (select distinct entityguid,entityname,projguid,projname from dm_project_delay_summary) a
group by entityguid,entityname
ORDER BY count(projguid) DESC
) 
--where ROWNUM<5
ORDER BY c_pro ]]></Query>
</TableData>
<TableData name="1项目数" class="com.fr.data.impl.DBTableData">
<Parameters/>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[oracle_test]]></DatabaseName>
</Connection>
<Query>
<![CDATA[select count(projguid) 项目数
from
(select distinct entityguid,entityname,projguid
from dm_project_week_summary) a]]></Query>
</TableData>
<TableData name="1节点数" class="com.fr.data.impl.DBTableData">
<Parameters/>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[oracle_test]]></DatabaseName>
</Connection>
<Query>
<![CDATA[select count(nodename) 节点数
from
(select distinct entityguid,entityname,projguid,nodename
from dm_project_week_summary) a]]></Query>
</TableData>
<TableData name="1下周预计风险" class="com.fr.data.impl.DBTableData">
<Parameters/>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[oracle_test]]></DatabaseName>
</Connection>
<Query>
<![CDATA[select count(projguid) 项目数
from
(select distinct entityguid,entityname,projguid
from dm_project_nwrisk_summary) a]]></Query>
</TableData>
<TableData name="1下周预计节点数" class="com.fr.data.impl.DBTableData">
<Parameters/>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[oracle_test]]></DatabaseName>
</Connection>
<Query>
<![CDATA[select count(nodename) 节点数
from
(select distinct entityguid,entityname,projguid,nodename
from dm_project_nwrisk_summary) a]]></Query>
</TableData>
<TableData name="1重大项目项目进展" class="com.fr.data.impl.DBTableData">
<Parameters/>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[oracle_test]]></DatabaseName>
</Connection>
<Query>
<![CDATA[select * from (
select  a.entityguid 区域ID,a.entityname 区域名称,a.projguid 项目ID,substr(a.projname,1,8)||'...' 项目名称, a.projname 项目名称2, a.nodename 节点名称,a.periodcode 实际完成时间
, row_number() over (partition by a.projname order by a.projname ) rn

from dm_project_week_summary a 
inner join (select entityguid,projguid,max(periodcode) periodcode from dm_project_week_summary group by entityguid,projguid) b 
on a.entityguid=b.entityguid 
and a.projguid=b.projguid 
and a.periodcode=b.periodcode
ORDER BY a.periodcode desc, entityname
) t
where rn=1]]></Query>
</TableData>
<TableData name="1下周预计风险项目" class="com.fr.data.impl.DBTableData">
<Parameters/>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[oracle_test]]></DatabaseName>
</Connection>
<Query>
<![CDATA[select * from (
select DISTINCT a.entityguid 区域ID,a.entityname 区域名称,a.projguid 项目ID,substr(a.projname,1,10)||'...' 项目名称, a.projname 项目名称2, substr(a.nodename,1,8)||'...' 节点名称, a.nodename 节点名称2, a.periodcode 实际完成时间
, row_number() over (partition by a.projname order by a.projname ) rn

from dm_project_nwrisk_summary a inner join (select entityguid,projname,max(periodcode) periodcode from dm_project_nwrisk_summary group by entityguid,projname) b 
on a.entityguid=b.entityguid and a.projname=b.projname and a.periodcode=b.periodcode
ORDER BY a.periodcode desc, entityname
)
where 1=1
and rn=1]]></Query>
</TableData>
<TableData name="1 饼状图ds1" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="qy"/>
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
<![CDATA[select case when delaycausetype is null or delaycausetype = '' then '无'
       else delaycausetype 
       end 归因类型,count(nodeguid) 节点数 
from (select distinct entityguid,entityname,projguid,projname,nodeguid,nodename,delaycausetype from dm_project_delay_summary) a
where  1=1 ${if(len(qy) = 0,"",if(qy=1,"","and a.entityname = '" + qy + "'"))} 
group by delaycausetype
]]></Query>
</TableData>
</TableDataMap>
<FormMobileAttr>
<FormMobileAttr refresh="false" isUseHTML="false" isMobileOnly="false" isAdaptivePropertyAutoMatch="false"/>
</FormMobileAttr>
<Parameters>
<Parameter>
<Attributes name="qy"/>
<O>
<![CDATA[1]]></O>
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
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[var timer1 = setTimeout(function(){
 		  var _x = $('.slimScrollBarY')[0]A;
 		  if(_x){
$('.slimScrollBarY').css('width','15px'); //Y轴宽
$('.slimScrollBarX').css('height','15px');//X轴高
$('.slimScrollBarX').css('background','#227087');//X轴颜色
$('.slimScrollBarX').css('opacity','0.99');//X轴透明度
$('.slimScrollBarY').css('background','#227087');//Y轴颜色
$('.slimScrollBarY').css('opacity','0.99');//Y轴透明度    
 			 clearInterval(timer1);
 			 }
 	  	},1000);]]></Content>
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
<LCAttr vgap="0" hgap="0" compInterval="8"/>
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
<WidgetName name="report2_c_c"/>
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
<WidgetName name="report2_c_c"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Margin top="3" left="0" bottom="0" right="0"/>
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
<![CDATA[2628900,1371600,1008000,2362200,0,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="0" s="0">
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
<![CDATA[window.parent.FS.tabPane.addItem({title:"产业新城重点项目",src:"${servletURL}?reportlet=/ThreeLevelPage/OPE_FIN_MAJOR_PRO_ALL_DEMO_PAGING.cpt&__bypagesize__=false&code=HXCYXC"})]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<Expand extendable="3"/>
</C>
<C c="3" r="0" s="1">
<O>
<![CDATA[查看详情]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="JavaScript脚本1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[window.parent.FS.tabPane.addItem({title:"产业新城重点项目",src:"${servletURL}?reportlet=/ThreeLevelPage/OPE_FIN_MAJOR_PRO_ALL_DEMO_PAGING.cpt&__bypagesize__=false&code=HXCYXC"})]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<Expand/>
</C>
<C c="4" r="0">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=sql("oracle_test", "select ORG_CODE from DIM_ORG WHERE ORG_ID=(SELECT DISTINCT AREAGUID FROM BASS_ods.ODS_PROJECT_DELAY_DETAIL WHERE AREANAME='" + $qy + "')UNION ALL select ORG_CODE from DIM_ORG WHERE ORG_CODE='HXCYXC' ORDER BY ORG_CODE desc ", 1, 1)]]></Attributes>
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
<Style vertical_alignment="3" imageLayout="1">
<FRFont name="SimSun" style="0" size="72" foreground="-16776961" underline="1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="2" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72" foreground="-14701313"/>
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
<![CDATA[1008000,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,2743200,864000,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="0" s="0">
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
<![CDATA[window.parent.FS.tabPane.addItem({title:"查看详情",src:"${servletURL}?reportlet=/ThreeLevelPage/OPE_FIN_MAJOR_PRO_JZ.cpt&op=view"})]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<Expand/>
</C>
<C c="3" r="0" s="1">
<O>
<![CDATA[查看详情]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="JavaScript脚本1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[window.parent.FS.tabPane.addItem({title:"查看详情",src:"${servletURL}?reportlet=/ThreeLevelPage/OPE_FIN_MAJOR_PRO_JZ.cpt&op=view"})]]></Content>
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
<Style vertical_alignment="3" imageLayout="1">
<FRFont name="SimSun" style="0" size="72" foreground="-16776961" underline="1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72" foreground="-16776961" underline="1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</body>
</InnerWidget>
<BoundsAttr x="283" y="22" width="140" height="35"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report2_c"/>
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
<WidgetName name="report2_c"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Margin top="3" left="0" bottom="0" right="0"/>
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
<![CDATA[2628900,1371600,1008000,2362200,0,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="0" s="0">
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
<Parameters>
<Parameter>
<Attributes name="org_code"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=e1]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[window.parent.FS.tabPane.addItem({title:"已延期项目列表",src:"${servletURL}?reportlet=/ThreeLevelPage/OPE_FIN_MAJOR_PRO_DEMO.cpt&__bypagesize__=false&code="+org_code})]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<Expand extendable="3"/>
</C>
<C c="3" r="0" s="1">
<O>
<![CDATA[查看详情]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="JavaScript脚本1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="org_code"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=e1]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[window.parent.FS.tabPane.addItem({title:"已延期项目列表",src:"${servletURL}?reportlet=/ThreeLevelPage/OPE_FIN_MAJOR_PRO_DEMO.cpt&__bypagesize__=false&code="+org_code})]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<Expand/>
</C>
<C c="4" r="0">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=sql("oracle_test", "select ORG_CODE from DIM_ORG WHERE ORG_ID=(SELECT DISTINCT AREAGUID FROM BASS_ods.ODS_PROJECT_DELAY_DETAIL WHERE AREANAME='" + $qy + "')UNION ALL select ORG_CODE from DIM_ORG WHERE ORG_CODE='HXCYXC' ORDER BY ORG_CODE desc ", 1, 1)]]></Attributes>
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
<Style vertical_alignment="3" imageLayout="1">
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
<IM>
<![CDATA[m94j9;cgPCg,3&N]Ao78C>QrAMgX8-bbZ1VQONaXZBWX`-`(SLb$QgUP;MlAiP-\?a>-!g4dA
EXYUhHNrUsY)/"`nFZVEXKG?3pfqBYY/l#\h/tj#m#u_-n=efr%KGdX0RlqnMa)Za8!WIc'V
kIG`n.QS"1<0mqdGJ:N.^M\[pI&J4FO'bKl8eea'[:JR9]ANX#^2fsPM0+(D]A$lYI3)[:SFXp
=)$7K7;=.0*VrFGiS,a?9,W4TtXsoa@RmhIef02PMUV,d_lO8q\T7rGDADPnBMiB%ng)Qd]Ad
]A%C&e*>e#$K!VfZG1-eTtfh77W+D&MK/0-OGVc":EA2Uc3_8ZMS*DmLt-:g52<n#5+j!FKc\
<&147'5FRbeKT,!NJ[ejgq'Yeo/<p8ddT>uDgX]AJHEeg@q(CVP2WAJ@?=Jm:pMTgog,E%]AU9
^V!9bO/>%Lq4R%9ceqWKh#noHd?S7@%h;QVDI$>[u$N.rFYufj#5uX3i!s/UF5gT!NB9e,@m
tA$1\XVuCejlSd]A\$f<G811cEA109bI2rk_)RQMFs,u:kY`_l<KA0Zh)TQ$^:,=tuKVc/668
-=12ABL/:S?3:6J?M'49dKJQab56p;VDmc<82_2\9.<Fb%=K&,:?l*SR$;e3K%Y&W6l$NSNa
UDkbh@LZd\UqXupd3i,.`,_XPEW/RWH2DU"!^Q_RU"BSrfWLhl@T@7G,<!br,Tji?26NQ]A?Y
>n+D.lV+_Nj9e?J@ILJRPh8p/'!Ptc@BK+DiR/:[B%M[VTkBRNgNpf=MMk2P\8AulOGYdLA+
&[L,7>geZO)NQ1#>H_^7gfr.%$.P;rr(3]AH-f,NA]Ab[gZNsb[#4m'Q"msUOa(FMOO@oq#Er7
ER?a5o5)0gVNk'4If(pW>WC=43b>1Q\er>SD)\Hmd?/XEccET\K7<6@a22nT<[.tK.&Z*VT)
5S?pa<Klg)_jd9a>ik`h,/EBCe*h0d8c8EB27n>ig62K[9AIJ:Y.,c+PK0FCmPM%r2YfTfOH
`'fXiZdq'F9N/O%U@KN5XZlA")N)<6]A^0;q)]Ak9/c:B%X]AQon'pJUlTM9eq3M<$B/;Hi[0F.
1CD)o>;e@3aa(0hdZl,^7Pd+5S"thb8>7's4<.SM7_SRb_J!iu9q`"K_L5#d(3k^M=gQc=,!
7'4#mR8bW(Hhd:Y0C3,B4Gb]Abm4o&'H2fp*t$=.'\WbG;P+==tE$%IS6pUi73@*,gCj$U5nZ
'*0NK((sK/k_t1jW3JPD"R]AH_6#`>>.+q;N_?QX0m+thpd#;S$Q*_(?uNb^CEEk4[A5/j>Qh
s?Vlbfn;&2BdK/-k)OB,AEKkWlr1\'gd*K\et.P6u"W;D\!RR8J?*5*eeao<IuGO$V@$Dg%t
ZbnVsk+fo!(I8N*=oWdf:4$(UP?f:oQTEClh]AgCJi+Ou"LOWFg@T0\Z'W(Du?q!ZFE<H:GB$
l.OTe+7\Q*_rQalW@^[C4b_jApG9Tj.0UX+:(Pg2CV"O'dD&W&kNT&jftWL0Q:*T\g7_-$,E
1K-eR4_hdfdH,W:>&iQ;B'kd:qu.^+JCm[!BMdYL/8FHP#X72)<IP7#a4$('3R1T6>&M=#C$
:QBI3!j[)GJ>BAF^iHRs;o5_S!Q^*.Z-Ncm/[A[;Z+(lAt[-VjV\I5RFS2ZL("P)!CYa#4=(
l*hXb.13cKP4N#e8mtWm)soV+<tBp+J=$US2m.K#oW(eG;uG4&GU3H\2_EU?h3JJ2;7*3m'`
eR8iocgA9J2lf!@B'=_E[dIN+D)AKk$&m;Ge,)Msee_X=<<13iUS57eYhQ9r1V\/5BT3R^G@
pF6?26<Ij;3d24)kJ=dsAR#SZKn7nt@@@I"Pa*%bLMaF+=gqE@DA/"/X);RJP-/:hWt4uV,I
a!@GA=/?ONGU*8kGlfYu5#egY@a>/kSCj90o*K=Mij2"7Rd?<(=-:/[2%nkf)PNTK8<8Yg;.
m%.1m7adceST6eKfWk8sSfsYe?YdBV99/_-ojU(0&MS0>]A2#mm2I02dI`CPWWP7kAiZH2UJ6
Rb#B@\\(eGsLP'$6)rG+8$>h:O!EcTP8]AbE7$O@E"96^+=(8K'f6k?H&J"-.D+O0Xd,TE8LC
=hor]A8]A8aen?^U#f/K\lM_)).tu&Nc\1WMFTU7::n;7-V1_VD;%YbclIE,)NQi,hpPFk'K>&
WD]A.SD0(pd)%53#!V^FK%[hA?aXC`T#c*I$E!/=bYr9h$X-$=Yn.u-;,D;e"@0[YF)Y]A0\'0
f(**\uFOW^AsB?IGutFNP>_QnG5fE_S$7BSA2Hqu'3?<Wgq0!iCmPNh$ri(FcU4/5\.q$IZU
lAPd5b/cVhrr&R%U7c@f]AbT;uM#"/NVH#6(#Eq90aA$u%a&m+#:q[pHPHYM!MVHW=\9(hIIi
SLN-KU`9Fj$mm2_4qK8Z\C%n[l6mWHc?h]A;)T;\2(;aUOVC-I4nbG@5F2Z[DV[tPe;;k`:HE
ol2hbe>j`0("7?+0,[Q00jNN2O*d+._Sc6SA"b).:a.-YlmM4OP%s'0/2+]AUb@Eog\;Gad0I
qcIaGWs82<[mIi(%[N[_2<<<E3$&'XTo&S/ca._&+$?8'4"__0:=ltH(5kf-jjX-?Y^:[Yr#
&_Q90s%'95W_ImMVSBKb%b4Z`qE@9TJ^/a_("K$!Pm]Aq2=6PP\_mg.e#[90si%'VLu?sS*(T
*mWVU-6@`ee'UE^K-(@JbZ"9R%PBEJ1AOC`'U7Y2n^8k%NR3GbZFWV?QoN9DS.EF0HT;i'uj
,d)2+k?'IMgs2U_oZS.NW3o)X_8D:CO1-H'8B#+)nVpmJeY7n";+7_`3G3W6l/1;?>b5p7SX
o)e9*/rkrm.,%L<6U/Ibuk!qMXfpg$Bso#O:2kC*-a=5\O;l)@iUO/!+"00-cEB%O+!&<B>E
WHE0m^`>U;3Yi6]AcYNALDImi+h&67\SjgMJ^X3ooAOGA0'jiT-!'Cgn40U>G5kYq1\^8hOZl
ZLNo65WDi#!!g[D%IAp@cFj;m6./]AZ#0-FOO!bQmW@C>S-YnZ'Fei:(6l2#Ws"81hK/tT16?
$4bQ_P4DFH@9:HS<c:Fj209!($&%_XJ0dcuBgQ:]A,ZTW1ARD.`[`/R:J1>:F#^5lnB%Gf_bn
`F*@_oL"BL3Ur!3S/7g6LA4O(o;1^ZP$:#55m-[]Ae2:6ambK)^jAl;\`hAj<!.D-h+CpN$ZU
Y'1`\EROh"XRo'pD^nF_C;lm*k&&,#7nD=%o\dABDmp`Y7)qp4gn7gX7Nn@'sD?3kg/5&gf:
nK1uV#pn:;hr-L+rDPCM6gROa[)hQ1WA)lLEH$'TEH]ArW1F<!hNn!DK>mKYtp^EL(^\kSGID
Js:a&G72s,.!o-h&ahKarM)Zd'I&Hs&h:CEI\;@9p$C/6@7U7!5QMdW!IQo>_2OWdiCSG\Rg
>X7XLh^E6kZS/MFS?@uEZ[,&b,jQZekaY<01j7sHps0qF9;\QE/`#!69j>bA@"`jgT'ddjqk
E.A`bThYkqP19PKI_WEGREd<;t7P6*L`?3rnc.id#QtmR,+Hol0KmEkJ)ZF5pOAkbb)$Ah8e
%^c-/SPD.f^I^/9I#4m?*cFX_'Vo1+qI!FCHgQm-R:gQ)NM3CoCO)BW`GWWCQZrtg"m;mVld
&RbSV05H0Gl-LPf@hfp;'.*mhGnNU1!3I,VR>1t+NqYiI$a"tA>qJ!loAQc1:i!aH:@4J83'
P[E#7?G&7=?BUqJn,?=X$uB"?"f[[3UK'#-oau[ZiJ3T7h.4#NsHAVaA9Hnl-=IFe31J=+Q6
4j`<NA/9=c@>MG1TR0p,cZ8V;2,q?PVA=/cT"kg%=[^6;Xbn$dU!us$VkrVF:J(h4.?eQ4YB
q3g((UcB$Enc)Z2sPF?Ciblo9;_;;U2*(E*Gsu=1,H#]A\k![q]A<CrR.i)hV862''%aHM7+5(
a:U):2sN-!VY3!KU;CAf-&#_`_Xa+!QbO0Vo!BkNoC*b&Cbhkl\Bi;o!KaBV3:jD.B`%NTOH
EjQpj<F@F":R+7-:Q>!h[O.H@THF_\J19l/M(tdRp&e+5;$_6*;hG5D1B^&$/k(IVdf6MYp]A
8]AM,?r1>K?@VI8cZL0gMc'pW3RFE0r6Jj7p0Q+o2Rs#[QGp:X)sn[FcDE\T/.-eYRaimn=[n
"r(We]A7;Zp@YH[o.<i*IX'Rf$Y'@B*Lp>RB5r_gVpSdNg.JjbN2#ZHp*6)MZ;c:W/F+21/NH
-XhbpeK!n@C"tpPG1(5KYP6U=VmLN=Q91P?5JN<(qEW;'dQJA;U;0M.ZpVq,YCBZ_^XTe2'!
mHJ2_$s7ZrtuK9HC;9(WIQpGnC>%3_-tqSBc*Im[MZE<hGHHNi*OlgoFl[bi-gM6.$;+DcK_
KfM9J-0:8C=4PqM)uEctCT_8(:BO#J/c,WZ2W4'T/pJCOKqH#oIH]Alk2+Xgq'>#/GG$cl\.=
b92NIW[Kos0=P``:_t!T=L::C2[5Pg>NCHTrnE-cX*"/GGtpNSc4&aJ/Z5K"El*Jb]AG]ATk_0
:a(BFQVkEdrkhn%$;D\^HJFGh5cAFV"\1%0g.RZt3rY;"T8D`8Vie##=!k5Q#M2Rpq&MEGr*
`6qM.[t]AVaH2=B?[]A/C7p=+ZE@JliNWcEO6<=am"f\aE*F-"qK9oP5OpFfq,'OBn@Z5=K:=Q
QZ8XFgIojF]AjIgDHjR=&joa1VW7b\f5U=$6%YlV]AS_)ln?,1J$ON1!u^6bBl+rSm$:$5)&U8
;)re3HWe&rV/4-sf)QjSV`/=\KB4bYAQJ9eT1K1&6Q6biXiEqBo")]Ai#cj9[/ETe<iX<ii.\
7t;#8tLB9.4&Pp^lI$[-4at8>SY.;diQ4R]AZc:'Mal!\+/P-?0mY"h&p$Q(,'I97KpPAnU)[
*D:5_Zi8"kp_A/V7@%AmpPp6k8qa%e6XeTGig_BsH1at8SR]A)lS_a4)=#>0oEVsP-a.AAH,E
Ynn[H:G3O"tp5N=[IEf%@K%2O!'%X]A9V$"8(5K+YQL,h5Gb1_4?mgoBme4H0/!joIZ+38F@#
H0pHJR0~
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
<![CDATA[1008000,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,2743200,864000,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="0" s="0">
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
<![CDATA[window.parent.FS.tabPane.addItem({title:"查看详情",src:"${servletURL}?reportlet=/ThreeLevelPage/OPE_FIN_MAJOR_PRO_JZ.cpt&op=view"})]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<Expand/>
</C>
<C c="3" r="0" s="1">
<O>
<![CDATA[查看详情]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="JavaScript脚本1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[window.parent.FS.tabPane.addItem({title:"查看详情",src:"${servletURL}?reportlet=/ThreeLevelPage/OPE_FIN_MAJOR_PRO_JZ.cpt&op=view"})]]></Content>
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
<Style vertical_alignment="3" imageLayout="1">
<FRFont name="SimSun" style="0" size="72" foreground="-16776961" underline="1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72" foreground="-16776961" underline="1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</body>
</InnerWidget>
<BoundsAttr x="283" y="246" width="140" height="35"/>
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
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="0" color="-723724" borderRadius="0" type="0" borderStyle="0"/>
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
<![CDATA[876300,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2019300,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O t="Image">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320!n)H=beXK/jZR]A=!i^O</rh(iF-;%Ns)65"Pd]AVqIIReqjbK<G@T
\]ADBY<&\nUrL9:M$/K^iY<lU'bKah9;2ONB\rtl5e);cT8uom,L0*AC0'En9b]A2,E!D<M0h-
Q/\B*T0qE<ZQGE(3QT;5"E-3.CkUBEn;d[E*R4Kr*hB6giiJhL!0d[&g-:=t+Mhs!uD]AN@JO
s68WH7>9;?nN-,R*V't(pTgWArX"3@L7VaN/qEgF?"tK(a!l^kVtX<Esq%b4F2=J8^F)b\`<
5`@AYPip,pV:Hpen+^9_ERm:AARhIsa?hCZg!+fn)q_H)Z6%tQoUn9">E=m)$r"98~
]]></IM>
</O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="当前决策报表对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="qy"/>
<O>
<![CDATA[1]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report0_c_c_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="CopyOf当前决策报表对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="qy"/>
<O>
<![CDATA[1]]></O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report2_c"/>
<linkType type="1"/>
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
<FRFont name="SimSun" style="0" size="72" foreground="-16776961" underline="1"/>
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
<![CDATA[1440000,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[1440000,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<O t="I">
<![CDATA[1234]]></O>
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
<BoundsAttr x="393" y="273" width="31" height="22"/>
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
<![CDATA[723900,723900,723900,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,1152000,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2476500,2476500,4953000,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="0">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(count(value("yiyanqi", 1)) > 10, count(value("yiyanqi", 1)), count(value("yiyanqi", 1)))]]></Attributes>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition"/>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ColWidthHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="0" r="1" cs="3" rs="84">
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
<Attr class="com.fr.plugin.chart.base.AttrTooltip">
<AttrTooltip>
<Attr enable="false" duration="4" followMouse="false" showMutiSeries="false" isCustom="true"/>
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
<Attr class="com.fr.plugin.chart.base.AttrLabel">
<AttrLabel>
<labelAttr enable="true"/>
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
<![CDATA[#0个项目]]></Format>
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
<NameJavaScriptGroup>
<NameJavaScript name="图表超链-联动单元格1">
<JavaScript class="com.fr.chart.web.ChartHyperRelateCellLink">
<JavaScript class="com.fr.chart.web.ChartHyperRelateCellLink">
<Parameters>
<Parameter>
<Attributes name="qy"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=CATEGORY]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features width="500" height="270"/>
<realateName realateValue="I3"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="当前决策报表对象2">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="qy"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=CATEGORY]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report0_c_c_c_c"/>
<linkType type="1"/>
</JavaScript>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="CopyOf当前决策报表对象2">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="qy"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=CATEGORY]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features/>
<realateName realateValue="report2_c"/>
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
<OColor colvalue="-12738049"/>
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
<AxisPosition value="3"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="Verdana" style="0" size="64" foreground="-1"/>
</Attr>
</TextAttr>
<AxisLabelCount value="=1"/>
<AxisRange maxValue="=max(yiyanqi.group(c_pro)) * 2"/>
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
<VanChartColumnPlotAttr seriesOverlapPercent="20.0" categoryIntervalPercent="20.0" fixedWidth="true" columnWidth="12" filledWithImage="false" isBar="true"/>
</Plot>
<ChartDefinition>
<OneValueCDDefinition valueName="C_PRO" function="com.fr.data.util.function.NoneFunction">
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[yiyanqi]]></Name>
</TableData>
<CategoryName value="区域名称"/>
</OneValueCDDefinition>
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
<C c="3" r="3">
<O t="I">
<![CDATA[1]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="4">
<O t="I">
<![CDATA[2]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="5">
<O t="I">
<![CDATA[3]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="6">
<O t="I">
<![CDATA[4]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="7">
<O t="I">
<![CDATA[5]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="8">
<O t="I">
<![CDATA[6]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="9">
<O t="I">
<![CDATA[7]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="10">
<O t="I">
<![CDATA[8]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="11">
<O t="I">
<![CDATA[9]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="12">
<O t="I">
<![CDATA[10]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="13">
<O t="I">
<![CDATA[11]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="14">
<O t="I">
<![CDATA[12]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="15">
<O t="I">
<![CDATA[13]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="16">
<O t="I">
<![CDATA[14]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="17">
<O t="I">
<![CDATA[15]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="18">
<O t="I">
<![CDATA[16]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="19">
<O t="I">
<![CDATA[17]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="20">
<O t="I">
<![CDATA[18]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="21">
<O t="I">
<![CDATA[19]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="22">
<O t="I">
<![CDATA[20]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="23">
<O t="I">
<![CDATA[21]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="24">
<O t="I">
<![CDATA[22]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="25">
<O t="I">
<![CDATA[23]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="26">
<O t="I">
<![CDATA[24]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="27">
<O t="I">
<![CDATA[25]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="28">
<O t="I">
<![CDATA[26]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="29">
<O t="I">
<![CDATA[27]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="30">
<O t="I">
<![CDATA[28]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="31">
<O t="I">
<![CDATA[29]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="32">
<O t="I">
<![CDATA[30]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="33">
<O t="I">
<![CDATA[31]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="34">
<O t="I">
<![CDATA[32]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="35">
<O t="I">
<![CDATA[33]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="36">
<O t="I">
<![CDATA[34]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="37">
<O t="I">
<![CDATA[35]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="38">
<O t="I">
<![CDATA[36]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="39">
<O t="I">
<![CDATA[37]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="40">
<O t="I">
<![CDATA[38]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="41">
<O t="I">
<![CDATA[39]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="42">
<O t="I">
<![CDATA[40]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="43">
<O t="I">
<![CDATA[41]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="44">
<O t="I">
<![CDATA[42]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="45">
<O t="I">
<![CDATA[43]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="46">
<O t="I">
<![CDATA[44]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="47">
<O t="I">
<![CDATA[45]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="48">
<O t="I">
<![CDATA[46]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="49">
<O t="I">
<![CDATA[47]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="50">
<O t="I">
<![CDATA[48]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="51">
<O t="I">
<![CDATA[49]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="52">
<O t="I">
<![CDATA[50]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="53">
<O t="I">
<![CDATA[51]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="54">
<O t="I">
<![CDATA[52]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="55">
<O t="I">
<![CDATA[53]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="56">
<O t="I">
<![CDATA[54]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="57">
<O t="I">
<![CDATA[55]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="58">
<O t="I">
<![CDATA[56]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="59">
<O t="I">
<![CDATA[57]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="60">
<O t="I">
<![CDATA[58]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="61">
<O t="I">
<![CDATA[59]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="62">
<O t="I">
<![CDATA[60]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="63">
<O t="I">
<![CDATA[61]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="64">
<O t="I">
<![CDATA[62]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="65">
<O t="I">
<![CDATA[63]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="66">
<O t="I">
<![CDATA[64]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="67">
<O t="I">
<![CDATA[65]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="68">
<O t="I">
<![CDATA[66]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="69">
<O t="I">
<![CDATA[67]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="70">
<O t="I">
<![CDATA[68]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="71">
<O t="I">
<![CDATA[69]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="72">
<O t="I">
<![CDATA[70]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="73">
<O t="I">
<![CDATA[71]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="74">
<O t="I">
<![CDATA[72]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="75">
<O t="I">
<![CDATA[73]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="76">
<O t="I">
<![CDATA[74]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="77">
<O t="I">
<![CDATA[75]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="78">
<O t="I">
<![CDATA[76]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="79">
<O t="I">
<![CDATA[77]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="80">
<O t="I">
<![CDATA[78]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="81">
<O t="I">
<![CDATA[79]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="82">
<O t="I">
<![CDATA[80]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[$$$ > D1]]></Formula>
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
<StyleList/>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
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
<![CDATA[723900,1296000,1296000,1296000,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2476500,2476500,4953000,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" cs="3" rs="20">
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
<Attr class="com.fr.plugin.chart.base.AttrTooltip">
<AttrTooltip>
<Attr enable="false" duration="4" followMouse="false" showMutiSeries="false" isCustom="true"/>
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
<Attr class="com.fr.plugin.chart.base.AttrLabel">
<AttrLabel>
<labelAttr enable="true"/>
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
<![CDATA[#0个项目]]></Format>
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
<NameJavaScriptGroup>
<NameJavaScript name="图表超链-联动单元格1">
<JavaScript class="com.fr.chart.web.ChartHyperRelateCellLink">
<JavaScript class="com.fr.chart.web.ChartHyperRelateCellLink">
<Parameters>
<Parameter>
<Attributes name="qy"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=CATEGORY]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_blank]]></TargetFrame>
<Features width="500" height="270"/>
<realateName realateValue="I3"/>
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
<OColor colvalue="-12738049"/>
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
<AxisPosition value="3"/>
<TickLine201106 type="2" secType="0"/>
<ArrowShow arrowShow="false"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="Verdana" style="0" size="64" foreground="-1"/>
</Attr>
</TextAttr>
<AxisLabelCount value="=1"/>
<AxisRange maxValue="=max(yiyanqi.group(c_pro) )*2"/>
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
<VanChartColumnPlotAttr seriesOverlapPercent="20.0" categoryIntervalPercent="20.0" fixedWidth="true" columnWidth="8" filledWithImage="false" isBar="true"/>
</Plot>
<ChartDefinition>
<OneValueCDDefinition valueName="C_PRO" function="com.fr.data.util.function.NoneFunction">
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false"/>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[yiyanqi]]></Name>
</TableData>
<CategoryName value="区域名称"/>
</OneValueCDDefinition>
</ChartDefinition>
</Chart>
<tools hidden="true" sort="false" export="false" fullScreen="false"/>
<VanChartZoom>
<zoomAttr zoomVisible="false" zoomGesture="true" zoomResize="true" zoomType="x"/>
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
<BoundsAttr x="29" y="294" width="173" height="153"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report6_c"/>
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
<WidgetName name="report6_c"/>
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
<C c="0" r="0" cs="4" s="0">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="数据截止日期："+sql("oracle_test", "select to_char(datatime, 'YYYY-MM-DD') from dm_project_summary where rownum=1", 1)]]></Attributes>
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
<Style horizontal_alignment="4" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72" foreground="-1"/>
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
<![CDATA[723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" cs="4" s="0">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="数据截止日期："+FORMAT(now(),'yyyy-MM-dd')]]></Attributes>
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
<FRFont name="微软雅黑" style="0" size="80" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</body>
</InnerWidget>
<BoundsAttr x="648" y="0" width="198" height="22"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report1_c"/>
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
<WidgetName name="report1_c"/>
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
<![CDATA[723900,723900,723900,723900,723900,723900,1143000,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" cs="3" rs="3">
<O t="RichText">
<RichText>
<RichChar styleIndex="0">
<text>
<![CDATA[上周重点项目进展]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="3" r="1">
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
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
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
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</body>
</InnerWidget>
<BoundsAttr x="441" y="22" width="200" height="27"/>
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
<HR F="2" T="2"/>
<FR/>
<HC/>
<FC/>
<UPFCR COLUMN="false" ROW="true"/>
</ReportPageAttr>
<ColumnPrivilegeControl/>
<RowPrivilegeControl/>
<RowHeight defaultValue="723900">
<![CDATA[720000,1008000,1440000,432000,1152000,720000,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[720000,3312000,3312000,3888000,3888000,3888000,3888000,3024000,3024000,720000,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<CellPageAttr/>
<Expand/>
</C>
<C c="1" r="0" s="0">
<O t="DSColumn">
<Attributes dsName="1项目数" columnName="项目数"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
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
<C c="2" r="0">
<O t="DSColumn">
<Attributes dsName="1节点数" columnName="节点数"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<CellPageAttr/>
<Expand dir="0"/>
</C>
<C c="3" r="0">
<PrivilegeControl/>
<CellPageAttr/>
<Expand/>
</C>
<C c="4" r="0">
<PrivilegeControl/>
<CellPageAttr/>
<Expand/>
</C>
<C c="5" r="0">
<PrivilegeControl/>
<CellPageAttr/>
<Expand/>
</C>
<C c="6" r="0">
<PrivilegeControl/>
<CellPageAttr/>
<Expand/>
</C>
<C c="7" r="0">
<PrivilegeControl/>
<CellPageAttr/>
<Expand/>
</C>
<C c="8" r="0">
<PrivilegeControl/>
<CellPageAttr/>
<Expand/>
</C>
<C c="9" r="0">
<PrivilegeControl/>
<CellPageAttr/>
<Expand/>
</C>
<C c="10" r="0">
<PrivilegeControl/>
<CellPageAttr/>
<Expand/>
</C>
<C c="0" r="1">
<PrivilegeControl/>
<CellPageAttr/>
<Expand/>
</C>
<C c="1" r="1">
<PrivilegeControl/>
<CellPageAttr/>
<Expand/>
</C>
<C c="2" r="1">
<PrivilegeControl/>
<CellPageAttr/>
<Expand/>
</C>
<C c="3" r="1">
<PrivilegeControl/>
<CellPageAttr/>
<Expand/>
</C>
<C c="4" r="1">
<PrivilegeControl/>
<CellPageAttr/>
<Expand/>
</C>
<C c="5" r="1">
<PrivilegeControl/>
<CellPageAttr/>
<Expand/>
</C>
<C c="6" r="1">
<PrivilegeControl/>
<CellPageAttr/>
<Expand/>
</C>
<C c="7" r="1">
<PrivilegeControl/>
<CellPageAttr/>
<Expand/>
</C>
<C c="8" r="1">
<PrivilegeControl/>
<CellPageAttr/>
<Expand/>
</C>
<C c="9" r="1">
<PrivilegeControl/>
<CellPageAttr/>
<Expand/>
</C>
<C c="10" r="1">
<PrivilegeControl/>
<CellPageAttr/>
<Expand/>
</C>
<C c="0" r="2">
<PrivilegeControl/>
<CellPageAttr/>
<Expand/>
</C>
<C c="1" r="2" cs="7" s="1">
<O t="RichText">
<RichText>
<RichChar styleIndex="2">
<text>
<![CDATA[上周共 ]]></text>
</RichChar>
<RichChar styleIndex="3">
<text>
<![CDATA[${=B1}]]></text>
</RichChar>
<RichChar styleIndex="4">
<text>
<![CDATA[ ]]></text>
</RichChar>
<RichChar styleIndex="2">
<text>
<![CDATA[个项目有重大进展]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="8" r="2">
<PrivilegeControl/>
<CellPageAttr/>
<Expand/>
</C>
<C c="9" r="2">
<PrivilegeControl/>
<CellPageAttr/>
<Expand/>
</C>
<C c="10" r="2">
<PrivilegeControl/>
<CellPageAttr/>
<Expand/>
</C>
<C c="0" r="3">
<PrivilegeControl/>
<CellPageAttr/>
<Expand/>
</C>
<C c="1" r="3">
<PrivilegeControl/>
<CellPageAttr/>
<Expand/>
</C>
<C c="2" r="3">
<PrivilegeControl/>
<CellPageAttr/>
<Expand/>
</C>
<C c="3" r="3">
<PrivilegeControl/>
<CellPageAttr/>
<Expand/>
</C>
<C c="4" r="3">
<PrivilegeControl/>
<CellPageAttr/>
<Expand/>
</C>
<C c="5" r="3">
<PrivilegeControl/>
<CellPageAttr/>
<Expand/>
</C>
<C c="6" r="3">
<PrivilegeControl/>
<CellPageAttr/>
<Expand/>
</C>
<C c="7" r="3">
<PrivilegeControl/>
<CellPageAttr/>
<Expand/>
</C>
<C c="8" r="3">
<PrivilegeControl/>
<CellPageAttr/>
<Expand/>
</C>
<C c="9" r="3">
<PrivilegeControl/>
<CellPageAttr/>
<Expand/>
</C>
<C c="10" r="3">
<PrivilegeControl/>
<CellPageAttr/>
<Expand/>
</C>
<C c="0" r="4" s="5">
<PrivilegeControl/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[B1 = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BorderHighlightAction">
<Border topLine="0" topColor="-16777216" bottomLine="0" bottomColor="-16777216" leftLine="0" leftColor="-16777216" rightLine="0" rightColor="-16777216"/>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="1" r="4" cs="2" s="6">
<O t="DSColumn">
<Attributes dsName="1重大项目项目进展" columnName="区域名称"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper">
<Attr divideMode="1"/>
</RG>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[B1 = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BorderHighlightAction">
<Border topLine="0" topColor="-16777216" bottomLine="0" bottomColor="-16777216" leftLine="0" leftColor="-16777216" rightLine="0" rightColor="-16777216"/>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[LEN($$$)>8]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=left($$$,8)+"..."]]></Attributes>
</O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性3]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[len($$$)<=8]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="3" r="4" cs="2" s="7">
<O t="DSColumn">
<Attributes dsName="1重大项目项目进展" columnName="项目名称2"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="JavaScript脚本1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="name"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=sql("oracle_test","select distinct d.projectname from DM_PROJECT_NODE_DETAIL d where d.projectguid='"+M5+"'",1,1)]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="projectid"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=M5]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[window.parent.FS.tabPane.addItem({title:name+"项目详情",src:"${servletURL}?formlet=ThreeLevelPage/OPE_FIN_MAJOR_PRO_DETAIL.frm&projectid="+projectid})]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<CellGUIAttr>
<ToolTipText>
<![CDATA[=K5]]></ToolTipText>
</CellGUIAttr>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[B1 = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BorderHighlightAction">
<Border topLine="0" topColor="-16777216" bottomLine="0" bottomColor="-16777216" leftLine="0" leftColor="-16777216" rightLine="0" rightColor="-16777216"/>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[len($$$)>8]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=left($$$,8)+"..."]]></Attributes>
</O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性3]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[len($$$)<=8]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="5" r="4" cs="2" s="6">
<O t="DSColumn">
<Attributes dsName="1重大项目项目进展" columnName="节点名称"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper">
<Attr divideMode="1"/>
</RG>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<CellGUIAttr>
<ToolTipText>
<![CDATA[=L5]]></ToolTipText>
</CellGUIAttr>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[B1 = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BorderHighlightAction">
<Border topLine="0" topColor="-16777216" bottomLine="0" bottomColor="-16777216" leftLine="0" leftColor="-16777216" rightLine="0" rightColor="-16777216"/>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[len($$$)>8]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=left($$$,8)+"..."]]></Attributes>
</O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性3]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[len($$$)<=8]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="7" r="4" cs="2" s="6">
<O t="DSColumn">
<Attributes dsName="1重大项目项目进展" columnName="实际完成时间"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper">
<Attr divideMode="1"/>
</RG>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[B1 = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BorderHighlightAction">
<Border topLine="0" topColor="-16777216" bottomLine="0" bottomColor="-16777216" leftLine="0" leftColor="-16777216" rightLine="0" rightColor="-16777216"/>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="9" r="4">
<PrivilegeControl/>
<CellPageAttr/>
<Expand/>
</C>
<C c="10" r="4">
<O t="DSColumn">
<Attributes dsName="1重大项目项目进展" columnName="项目名称2"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
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
<C c="11" r="4">
<O t="DSColumn">
<Attributes dsName="1重大项目项目进展" columnName="节点名称"/>
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
<C c="12" r="4">
<O t="DSColumn">
<Attributes dsName="1重大项目项目进展" columnName="项目ID"/>
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
</CellElementList>
<ReportAttrSet>
<ReportSettings headerHeight="0" footerHeight="0">
<PaperSetting/>
</ReportSettings>
</ReportAttrSet>
</FormElementCase>
<StyleList>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="2" imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="1" size="104" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="160" foreground="-16713985"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="96" foreground="-256"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="2" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72" foreground="-1"/>
<Background name="NullBackground"/>
<Border>
<Top color="-15310988"/>
<Bottom style="1" color="-15310988"/>
<Left color="-15310988"/>
<Right color="-15310988"/>
</Border>
</Style>
<Style horizontal_alignment="2" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72" foreground="-16713985"/>
<Background name="NullBackground"/>
<Border>
<Top color="-15310988"/>
<Bottom style="1" color="-15310988"/>
<Left color="-15310988"/>
<Right color="-15310988"/>
</Border>
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
<FRFont name="宋体" style="0" size="72"/>
<Position pos="0"/>
</WidgetTitle>
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320@UNT8_8*jrMh;HeP&'u9,m+79T;RTW8B%+.2`ImMEYNN'kc+0<>q
D,em"=uNM/Q16Ko(WTQsA:Wjq6c:K8Ye=.qT^nI?(l2:EF2bNrn`$%np:]ASA"s**!8RGq/&X
M*t,FV-2)R00JP7T&-1G'TYdE-,WQf()&O?`W$f61qon5_hjf4k2<NCHHW55hGZ8oeGZ8oeG
Z8oeGRt7,7ORgkY(8KaVJ#dIq#D<,PRJBH(d'cCC`t-6@+24=!"/m]AJg*(*58kAPBA3doq9N
F<M1Ai?T=+7*S9*[T<lO#1-JqVFhJ/WD?Ol-PGe3a^XE.!I!WW~
]]></IM>
</Background>
<Alpha alpha="1.0"/>
</Border>
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320@UNT8_8*jrMh;HeP&'u9,m+79T;RTW8B%+.2`ImMEYNN'kc+0<>q
D,em"=uNM/Q16Ko(WTQsA:Wjq6c:K8Ye=.qT^nI?(l2:EF2bNrn`$%np:]ASA"s**!8RGq/&X
M*t,FV-2)R00JP7T&-1G'TYdE-,WQf()&O?`W$f61qon5_hjf4k2<NCHHW55hGZ8oeGZ8oeG
Z8oeGRt7,7ORgkY(8KaVJ#dIq#D<,PRJBH(d'cCC`t-6@+24=!"/m]AJg*(*58kAPBA3doq9N
F<M1Ai?T=+7*S9*[T<lO#1-JqVFhJ/WD?Ol-PGe3a^XE.!I!WW~
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
<![CDATA[1143000,342900,2880000,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[762000,3200400,2743200,3200400,5410200,3162300,4038600,3619500,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="0" s="0">
<O t="DSColumn">
<Attributes dsName="1项目数" columnName="项目数"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
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
<C c="2" r="0">
<O t="DSColumn">
<Attributes dsName="1节点数" columnName="节点数"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="0" r="2">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="1" r="2" cs="7" s="1">
<O t="RichText">
<RichText>
<RichChar styleIndex="2">
<text>
<![CDATA[上周共 ]]></text>
</RichChar>
<RichChar styleIndex="3">
<text>
<![CDATA[${=B1}]]></text>
</RichChar>
<RichChar styleIndex="4">
<text>
<![CDATA[ ]]></text>
</RichChar>
<RichChar styleIndex="2">
<text>
<![CDATA[个项目（]]></text>
</RichChar>
<RichChar styleIndex="5">
<text>
<![CDATA[${=c1}]]></text>
</RichChar>
<RichChar styleIndex="2">
<text>
<![CDATA[节点）有重大进展]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0" showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="0" r="9">
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
<FRFont name="SimSun" style="0" size="72" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="2" imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="1" size="104" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="160" foreground="-16713985"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="96" foreground="-256"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="1" size="104" foreground="-16713985"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</body>
</InnerWidget>
<BoundsAttr x="435" y="22" width="408" height="208"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report0_c_c_c_c_c_c_c"/>
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
<WidgetName name="report0_c_c_c_c_c_c_c"/>
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
<![CDATA[3312000,3312000,3312000,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" cs="3" rs="3" s="0">
<O t="RichText">
<RichText>
<RichChar styleIndex="1">
<text>
<![CDATA[本周预计风险项目]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
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
<Style horizontal_alignment="2" imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="128" foreground="-1"/>
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
<![CDATA[723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" cs="3" rs="3" s="0">
<O t="RichText">
<RichText>
<RichChar styleIndex="1">
<text>
<![CDATA[产业新城重点项目]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
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
<Style horizontal_alignment="2" imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="120" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</body>
</InnerWidget>
<BoundsAttr x="441" y="245" width="219" height="27"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report0_c_c_c_c_c"/>
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
<WidgetName name="report0_c_c_c_c_c"/>
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
<C c="0" r="0" cs="3" rs="3" s="0">
<O t="RichText">
<RichText>
<RichChar styleIndex="1">
<text>
<![CDATA[已延期项目]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
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
<Style horizontal_alignment="2" imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="128" foreground="-1"/>
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
<![CDATA[723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" cs="3" rs="3" s="0">
<O t="RichText">
<RichText>
<RichChar styleIndex="1">
<text>
<![CDATA[产业新城重点项目]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
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
<Style horizontal_alignment="2" imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="120" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</body>
</InnerWidget>
<BoundsAttr x="18" y="245" width="111" height="27"/>
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
<C c="0" r="0" cs="3" rs="3" s="0">
<O t="RichText">
<RichText>
<RichChar styleIndex="1">
<text>
<![CDATA[产业新城重点项目]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
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
<Style horizontal_alignment="2" imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="128" foreground="-1"/>
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
<![CDATA[723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" cs="3" rs="3" s="0">
<O t="RichText">
<RichText>
<RichChar styleIndex="1">
<text>
<![CDATA[产业新城重点项目]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
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
<Style horizontal_alignment="2" imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="120" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</body>
</InnerWidget>
<BoundsAttr x="18" y="22" width="200" height="27"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report0_c_c_c"/>
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
<WidgetName name="report0_c_c_c"/>
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
<![CDATA[144000,72000,72000,1104900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[304800,3600000,5600700,0,0,0,0,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="0">
<O t="DSColumn">
<Attributes dsName="1产业新城重点项目" columnName="项目总数"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="5" r="0">
<O t="DSColumn">
<Attributes dsName="1产业新城重点项目" columnName="节点总数"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="6" r="0">
<O t="DSColumn">
<Attributes dsName="1产业新城重点项目" columnName="下周到期节点"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="4" r="1">
<O t="DSColumn">
<Attributes dsName="1产业新城重点项目" columnName="正常推进项目"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="5" r="1">
<O t="DSColumn">
<Attributes dsName="1产业新城重点项目" columnName="正常推进节点"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="6" r="1">
<O t="DSColumn">
<Attributes dsName="1产业新城重点项目" columnName="下周到期正常推进节点"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="4" r="2">
<O t="DSColumn">
<Attributes dsName="1产业新城重点项目" columnName="延期风险项目"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="5" r="2">
<O t="DSColumn">
<Attributes dsName="1产业新城重点项目" columnName="延期风险节点"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="6" r="2">
<O t="DSColumn">
<Attributes dsName="1产业新城重点项目" columnName="下周到期延期风险节点"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="0" r="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="3" cs="2" s="0">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="<span style='font-size: 11px;font-family: 微软雅黑;color: #ffffff;'>重点项目共</span>
<span style='font-size:20px;font-family: 微软雅黑;color: #00f6ff;'>" + E1 + "</span>
<span style='font-size: 11px;font-family: 微软雅黑;color: #ffffff;'> 个, 其中：</span>
</br>
<span style='font-size: 11px;font-family: 微软雅黑;color: #ffffff;'>正常推进 </span>
<span style='font-size:18px;font-family: 微软雅黑;color: #00c433;'>" + E2 + "</span>
<span style='font-size: 11px;font-family: 微软雅黑;color: #ffffff;'> 个&nbsp&nbsp&nbsp&nbsp&nbsp 存在延期风险</span>

<span style='font-size:18px;font-family: 微软雅黑;color: #e8da00;'>" + E3 + "</span>
<span style='font-size: 11px;font-family: 微软雅黑;color: #ffffff;'> 个 &nbsp&nbsp&nbsp&nbsp&nbsp    已经延期 </span>

<span style='font-size:18px;font-family: 微软雅黑;color: #ff4020;'>" + E4 + "</span>
<span style='font-size: 11px;font-family: 微软雅黑;color: #ffffff;'> 个  </span>
</br>
</br>
<span style='font-size: 11px;font-family: 微软雅黑;color: #ffffff;'>共涉及节点</span>
<span style='font-size:20px;font-family: 微软雅黑;color: #00f6ff;'>" + F1 + "</span>
<span style='font-size: 11px;font-family: 微软雅黑;color: #ffffff;'> 个, 其中：</span>
</br>
<span style='font-size: 11px;font-family: 微软雅黑;color: #ffffff;'>正常推进 </span>
<span style='font-size:18px;font-family: 微软雅黑;color: #00c433;'>" + F2 + "</span>
<span style='font-size: 11px;font-family: 微软雅黑;color: #ffffff;'> 个&nbsp&nbsp&nbsp&nbsp&nbsp 存在延期风险</span>

<span style='font-size:18px;font-family: 微软雅黑;color: #e8da00;'>" + F3 + "</span>
<span style='font-size: 11px;font-family: 微软雅黑;color: #ffffff;'> 个&nbsp&nbsp&nbsp&nbsp&nbsp     已经延期 </span>

<span style='font-size:18px;font-family: 微软雅黑;color: #ff4020;'>" + F4 + "</span>
<span style='font-size: 11px;font-family: 微软雅黑;color: #ffffff;'> 个 &nbsp&nbsp&nbsp&nbsp&nbsp </span>
</br>
</br>
<span style='font-size: 11px;font-family: 微软雅黑;color: #ffffff;'>本周到期节点</span>
<span style='font-size:20px;font-family: 微软雅黑;color: #00f6ff;'>" + G1 + "</span>
<span style='font-size: 11px;font-family: 微软雅黑;color: #ffffff;'> 个, 其中：</span>
</br>
<span style='font-size: 11px;font-family: 微软雅黑;color: #ffffff;'>正常推进 </span>
<span style='font-size:18px;font-family: 微软雅黑;color: #00c433;'>" + G2 + "</span>
<span style='font-size: 11px;font-family: 微软雅黑;color: #ffffff;'> 个&nbsp&nbsp&nbsp&nbsp&nbsp 存在延期风险</span>

<span style='font-size:18px;font-family: 微软雅黑;color: #e8da00;'>" + G3 + "</span>
<span style='font-size: 11px;font-family: 微软雅黑;color: #ffffff;'> 个 &nbsp&nbsp&nbsp&nbsp&nbsp</span>"]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="4" r="3">
<O t="DSColumn">
<Attributes dsName="1产业新城重点项目" columnName="延期项目"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="5" r="3">
<O t="DSColumn">
<Attributes dsName="1产业新城重点项目" columnName="延期节点"/>
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
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="478" height="228"/>
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
<CellElementList>
<C c="0" r="0">
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
<BoundsAttr x="12" y="22" width="410" height="208"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report0_c_c_c_c_c_c"/>
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
<WidgetName name="report0_c_c_c_c_c_c"/>
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
<HC/>
<FC/>
<UPFCR COLUMN="false" ROW="true"/>
</ReportPageAttr>
<ColumnPrivilegeControl/>
<RowPrivilegeControl/>
<RowHeight defaultValue="723900">
<![CDATA[1440000,1008000,1440000,432000,1152000,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[720000,3312000,3312000,3888000,3888000,3888000,3888000,3312000,3312000,0,1432800,1432800,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="1" r="0">
<O t="DSColumn">
<Attributes dsName="1下周预计风险" columnName="项目数"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
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
<C c="2" r="0">
<O t="DSColumn">
<Attributes dsName="1下周预计节点数" columnName="节点数"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand dir="0"/>
</C>
<C c="3" r="0" s="0">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="4" r="0">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="5" r="0" s="0">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="6" r="0">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="7" r="0" s="0">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="8" r="0" s="0">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="9" r="0">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="10" r="0">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="11" r="0">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="0" r="1">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="1" r="1">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="2" r="1">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="3" r="1">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="4" r="1">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="5" r="1">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="6" r="1">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="7" r="1">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="8" r="1">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="9" r="1">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="10" r="1">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="11" r="1">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="0" r="2">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="1" r="2" cs="7" s="1">
<O t="RichText">
<RichText>
<RichChar styleIndex="2">
<text>
<![CDATA[本周共 ]]></text>
</RichChar>
<RichChar styleIndex="3">
<text>
<![CDATA[${=B1}]]></text>
</RichChar>
<RichChar styleIndex="4">
<text>
<![CDATA[ ]]></text>
</RichChar>
<RichChar styleIndex="2">
<text>
<![CDATA[个项目有延期风险]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0" showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="8" r="2">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="9" r="2">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="10" r="2">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="11" r="2">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="0" r="3">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="1" r="3">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="2" r="3">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="3" r="3">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="4" r="3">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="5" r="3">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="6" r="3">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="7" r="3">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="8" r="3">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="9" r="3">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="10" r="3">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="11" r="3">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="0" r="4" s="5">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="1" r="4" cs="2" s="6">
<O t="DSColumn">
<Attributes dsName="1下周预计风险项目" columnName="区域名称"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper">
<Attr divideMode="1"/>
</RG>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[len($$$)<=8]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[len($$$)>8]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=left($$$,8)+"..."]]></Attributes>
</O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="3" r="4" cs="2" s="7">
<O t="DSColumn">
<Attributes dsName="1下周预计风险项目" columnName="项目名称2"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="JavaScript脚本1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="name"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=sql("oracle_test","select distinct d.projectname from DM_PROJECT_NODE_DETAIL d where d.projectguid='"+M5+"'",1,1)]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="projectid"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=M5]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[window.parent.FS.tabPane.addItem({title:name+"项目详情",src:"${servletURL}?formlet=ThreeLevelPage/OPE_FIN_MAJOR_PRO_DETAIL.frm&projectid="+projectid})]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<CellGUIAttr adjustmode="0">
<ToolTipText>
<![CDATA[=K5]]></ToolTipText>
</CellGUIAttr>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[len($$$)>8]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=left($$$,8)+"..."]]></Attributes>
</O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[len($$$)<=8]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="5" r="4" cs="2" s="6">
<O t="DSColumn">
<Attributes dsName="1下周预计风险项目" columnName="节点名称2"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0">
<ToolTipText>
<![CDATA[=L5]]></ToolTipText>
</CellGUIAttr>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[len($$$)>8]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=left($$$,8)+"..."]]></Attributes>
</O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[len($$$)<=8]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$$$]]></Attributes>
</O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="7" r="4" cs="2" s="6">
<O t="DSColumn">
<Attributes dsName="1下周预计风险项目" columnName="实际完成时间"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand dir="0"/>
</C>
<C c="9" r="4">
<PrivilegeControl/>
<CellGUIAttr adjustmode="0"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="10" r="4">
<O t="DSColumn">
<Attributes dsName="1下周预计风险项目" columnName="项目名称2"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
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
<C c="11" r="4">
<O t="DSColumn">
<Attributes dsName="1下周预计风险项目" columnName="节点名称2"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
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
<C c="12" r="4">
<O t="DSColumn">
<Attributes dsName="1下周预计风险项目" columnName="项目ID"/>
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
</CellElementList>
<ReportAttrSet>
<ReportSettings headerHeight="0" footerHeight="0">
<PaperSetting/>
</ReportSettings>
</ReportAttrSet>
</FormElementCase>
<StyleList>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="2" imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="1" size="104" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="160" foreground="-16713985"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="160" foreground="-256"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Top color="-16752788"/>
<Bottom color="-16752788"/>
<Left color="-16752788"/>
<Right color="-16752788"/>
</Border>
</Style>
<Style horizontal_alignment="2" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72" foreground="-1"/>
<Background name="NullBackground"/>
<Border>
<Top color="-16752788"/>
<Bottom style="1" color="-16752788"/>
<Left color="-16752788"/>
<Right color="-16752788"/>
</Border>
</Style>
<Style horizontal_alignment="2" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72" foreground="-16713985"/>
<Background name="NullBackground"/>
<Border>
<Top color="-16752788"/>
<Bottom style="1" color="-16752788"/>
<Left color="-16752788"/>
<Right color="-16752788"/>
</Border>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</InnerWidget>
<BoundsAttr x="478" y="0" width="480" height="270"/>
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
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
<IM>
<![CDATA[I(ON'>@4is)P!P@MmoMsGD\IN$GkPl'Q<L!Xt:?%MZie4m_PS^$RJo,42p"r0)`KHIF#Ieqs
Jmp+*k.nepc1VF,`3"S9sD)\uGfq%M]AHR!5O)^pf8%.5_B+<.+Qt;O&oTEV98j(VqJ\kdb8$
l]A,=^WA3/<QQ-(l>PJY&Qa%N,g:_5d<X-&H)<J31%i`0sM/$rBo;O]A>`o*eG&V@)rYaQ/.FR
A7QhJNG/>!qTfqSEId@n&%SKnA^&->b'-(397(=M:eQI3]AoP*4sufLH6CFBSn]A:qqn?7+SNQ
c;LFVC0&j'Sjeu%O:&U6W!mD"G7EZ(1g>6S/M,?rN'o7?q5@O#YUoThpmijbADip*k4_'^aN
X8`TodE>($a2<Le#R'_JZiU4@KLNP8RX^C(:S]A*=!Vmqcc;7#CAAG4Noq,H@FM\W;3/'8-[0
H[1(&<kEJhg#`lhME%%f#YhePlAJN%u!a4))K5RAW=BJ(Bu!/J>'YogBDi1b-S>K1[a$M6!U
#Fln#Bs'!f.Jhl?U?=:.fPAmP!U).0r+IK?Gag?1)'8*_@I0T]A6ZQY7kZ'F$p[):F611Nq^,
9l>F_=:,Ga?^n8%VMF6[6H\\O:q5Lg2EG+Fef\^XXnO"lQgkWln0I./B0pbrSM3t=>1QTC*I
5R/@;[&G\!ffj1h[)QEoX'8JOpXo3qXe:!e>&AG:saV`^SR;<M*A;_#JSDk0KJROC5iRFgD$
Qs/SNfa8=T$l!;ao=cOj$\g"]AgGGEZV6Adp!/cW`_9T,$)(!R_<i'")#9Wud%#Qht.@0gKgH
jO1U[-UoaR"$ea)"e@qJ)c'R2q5QSVGY<1V!+-Dkid+&cafFDdcB(Hch<R[M@9T[eg2mQ.Ec
:kk>?IBO_c$atN%=I>3/dCB*&Gbsh=lRSTS`ZaC8"1"'`!99bmrA?JZrBVLcTC,0BOm1d2$S
Y6eX63$Q/d5nW\0-MX3XcD\J)rEN@5o%3S38`V)lOkNA@7\G^6dp<Y7/X/$[4q.N>bOoS-8J
g:c3=d/'T(9s<$WZJ$lP.E,kKK++ed9pFGPA%8rk@#SJ-b4V\MD[eB@@E%:SW$Rij!jhta+t
]A(NH1ID\Hp/O9`mB!nbALiIpXn1f$L!fEY-+G)]AUGujELXitbUVEmnQgLhIh:j;0aJ6o^O*E
f'nEl.7i8fWQQoql,g=9$`D,m69-9&L$#-P#QIRe,d4Ft@Z[1ET*AT6>-bAA8,_oq9Z2L:JH
AL$3ZL9A\jhiWXbu4s>f097o`o=,FVjK@fQ>`@"@s63k;-?da[e-9<[AmI\8WI&c31(]APEmp
rm-Tjatp5&iV*]Ab/3&`b>#?A-\0JOV"4X&U/.riZR.`-7#<>D@X^uWCQ5?&c+SWUeMl#@X:4
ADrCW6Z/^Y,VX3AJPEsHK&3["=W#I>thBH3\1JQk.hWk$ZNp--0C)uUX%<^CdS1r8t-cNDbL
a4ZaU2kc76i[D#;ClYGYD\a!+)76K.(M[SPD5a?6=@Hg.q>]AJm&fj!p`/1`"fHC:XT&<,b).
b^j4SN!9%!T-!Qo(k;Wmb/q:*H1n-a=eAVe"8^mqKq0ZSID_:e@4:4fm05m-Wur-W&He"m]Ao
IoMVJpSHJkm@4DMTRTE,Gi^H.ti%7Jtp7tp5HOp1!Z,ii-5AN<FY=m,.`nmJ$n$X]A_QcZrKA
bl(p^lCXa'!>N+A*S$'>e<,?<gPFYHT^lmejpKX^*kEt9@c*F_a<@s2sYd@@5R"":0S)kh3[
E``2C!8WM[6&o_G*Z\]A3+3G4Qk;P8`7uH14WNUSM3>Co1RVe,g,!cJ0#R1WKN5)k!oB$##2=
'.6\tRSDO$%D;,dh,\DEflO9//@;r;)%"sbnK0YGb![b2+(li?eCY!k9@ZYX)E*f9e\<(I6c
^"QOY`o#OKL.DBc=N2URCTt@DUk+f#?..W9S@Ob%MY->hJHE`jdSr:R"&/&5L\hNY+TG+EF3
_\%i:::<HqS&`'@*L1[dFa)*7nV\+P[hqoio^VgCP>]A5XIZfRrdp;8hL@-+=ultrh@/MEl8S
)s5!MJ,K]AG7J4OGG?XE&Ioc[C^!i-V=(Cl?ogJW9UK"^Le9YqYUR\+67pLhVm"3`Q[s(_pTD
7QK4+&hTOO;`(WW[@7F"qM5MM]A/gf&[V>U%(XMW&'&;QSsk9pI*Y>)ELEg4DD0^*>Br%8/4R
P8!M&\m+9=8:GI2<I`2JO1rnf5odW0KMr=<QU*tjOb?XTG/f7T0L$1\lq$?^UG_76=_'MBa"
hVZZ[R_+>fOtqD:h)2[iN--bT<";`1-:"neiSc;D97f'saYoT(Ros%*B#*g>D.l6-P>_U4Iu
U`nq]Aj0H%%D%IPN5/=aD,s'QL"82I^o$nt;c:iXPD;%u2j)2X7?r%VFOUT='8E/1o#?+=;Zp
DlF$,(PfA<AZ5Y*bKDh[IYq8;7%kiG'eDpi?Xk3l7JoIR;LB%ki84Ee4*ec+f4OfMO*I!E)i
Ep2ugm/?6\sW/cS#fIgp4kdU0/s"O!^91DR%%D+Mm?K*P)`ln;J;F=tg29fAg-Ogrd5<@rQL
o;gtrgF`GV^tAa(IVQ/Cm\Y0hUZ]AXNSg(@Kj2U[p;<:''eo\qoi/QliWQY//Oa)m>-fUfK?R
bT$#qsL'XaY3eMRN:P'g"n\>$U>[*-K$Nar+NB5L`c-B1BO6&pYKXe!1PcF7Ch>F11=).9bO
;3Xa#&\7=RF61DH5]A0;O]A$$A!ic$r&B:m>RWZp/ZA1,s>7FjR+u6:F#[`'t^S1JfZSB>\=?;
B2`4]AX=qTa0!uhY^ag7QZFcUZlZU6a([<0FH`t=.!T_$<.Q+AS%OQ?\hUX*&nL?P76ksFD8`
X2;qaNUE@$+&\L<Yqh[^S^-B'7_W9]Ak>[5)W^Uu34&>5.F!CSRhe_2:O:$$U?+&*3[D"BZ$l
QGsBNXc]AX&RLa@l08\*d;u-*M\4+\KrA`'lP^J,05OZh\Q1)0:9BO*H!N86eHN\,%f9E#8KT
GEAO_W/DFDSmBH'a\=#g(Lf]AF\'^*L]A=XX(+W<iUNjm+57n6&7<01)T<+$9E*$^gr=9GW:iO
K'Jhk-b.--ET)i"FOBp3K$#[3K46+#d1T&*_YpsVr\'Kq*FM)ONVhMRWJOokb5j&nAT]A&s1l
=DJGSTGHMSb7d=![[Td!OHDqB9mMK?=c4^Fb[KRre4;r#t>HNoNM$)QSV1f4PDd%X+REi+GZ
`5hmqRB?L(((VC#(.8+k"*8N/RC`qXZ95k,lm1umR/JeqpYENinK0>T(f2,_UG_'aWjJB4go
E5E_XGs?A/5.9UhNU+U<cua<kqIXJ?'/%/g_@K*]Ab>Q.1.VVuUC:;,sjJeM?/c3^I*EU;W!o
of9*[2opM)')JVk!-Bhj!XD2!c!lF>93ZGuZbOMn#q*8a^M;\I24u)3&4%<%X0##q.Yp)4./
6G*o8V[2*NjY=uT/4UStu'PS0jKf.*p8"*0'?]A\@C./V9tF40n$I\HFaJCWs?#-`6ZPMD!R<
\/l)2/Y1XR0_gS7W0N)qJ5skftCliZG;_`mqu`oF5jW'.f:JD*s0`))*1$ZGO8o3-_"@fU0m
fnp5cr?F[RFRs.!`gn2P$%]AND\e^"XL.&%+63^-07/jd)b-g$]Am5n$[:$?PI:=U.a&Z\T?`)
04&Z*$p.+oSo#gWlR$N:#o2[:Z6!^fCS7*5R/q]Ab`&Tf9Q4E@/)T5glp\GUXR]A.t4#L5_gf=
"V:b"u#D7u5tiW7OIR*G0,k_d%/TT^t;.N=7Ge(9-CBb+i'L>pdhd:;S(s>BAXQ@Yo_#r<=p
BS35s@[Lh5hS[I%5SmB[KahT[0!c[0%+IE-O)?>Wr(^C0ue&Z8rlH',8Oq(]Ak3*RXG8d[CG2
,5U.[E8!m\<+W++s;aho;k*,Zc2;,S7+SCMn2"@i^KI9MShg;FH^eGdKB$Eb#A6Oi0DrPmHU
;/7)+qplGdqn2akG$f`FSnm(bJf13$4<9]A;2.U)rGF1iq"8o6CbDfgXZL[0_+ujdXf^ZI=+_
@Ba=+nOZ;[ijDI1c":<29etODX$]AMDaJ?di-.P^5YFWriA>F\$d<2TW=>/.<d8aVA:aHZoHj
9TN/Xt";rftRRB2&l!5;;d4ISXpCA<%YbWIGOL?f6`B\?RpKKI`_glj(2_hM"Io0hCO\Sgg-
.2Mo>QBXu=N9VhBto\$1YIq9fR3+BVo6gA'\4BQ's&bDH4OaL(<(1Z?@^cl2r<MR:=_"Eh7-
8^^C)Lc-fP.V@Q!T_&4abK6k&iJVQ$23_VnKl`/pdHKAg>V'"fe*!5pH)b4I4/`4%A$<h.V8
fsNXn0Xf1kamjMX5=`8%8+5UG'F;%O,T2>so((+HJ?[IWldHIL<FoP&XBJ:gobEZtjtbc7u^
bke-N;/.%+[pBsmn/SF.:"FE@<h^6_?7!FhF!EWCBA]AuE4h>-Fk&1=]A-sATHDG8S4p6dG)A]A
m)s+7)6JVAk]A!Ut?P"SK[;`=6p`jK&1?gFE;Dl;9i"c<GG%JDL\cB9I_+qY;\?CCX$OF\;#]A
nB%Y8q'k[m?1K+f4-LW;pqlT@jp3*H`#<\!S-4X6I/59eF@HXE,hE2J57TPiYJ[)VbF-GDte
'r,ur<n\88A<4M(r&.Ga/d%Z=a$PlFDG[SVj`*e$["2NdIPQ&oWUf=K.7i5nUT9`j%E=q/?J
]ALq7a5YHfQ!?I`Ron'QII^7mY`TG^J(:@=L`Vpq[Q$47Vit]A3-^`Za"rpeYHS^$]A0qK*81e?
eT7f\p_H!0rL45^d)9E[[MpDrdYsD=`4erZU3Eh5WDP;5m"S`5p%V/o_j+=a&r>YKM;LF>Au
@?[[\eWHL,^4M.6JmiD>qYcKsq#>=)+RTk(ap.rIp1+O<bDE/h0aJkuFpZ+9.46@;O_RC#u7
@h_&-jq=Q%#)`h8.K:jUW&inZJq2Wc1onkMGYGmC2=A*'8Ik^0iUli1PPe_Rnp1HW_+HjT1d
XT>c]ABM%)rg1=5dp>Bn5[&.!mTGL)P@*8AEYs16O=I\O/<F>+ei%%fJ5^-qcp;4Ho:1Sp=(J
4;Ur3">FA4NT\a!+9m9dL-N143BMsW'VF/>$,&84<M:$\t$LC;oA_$ArKLV5sa8;F&i]A+Th!
@:d>r?-S>:VeAjhl.%FZ,PDg,TJD>@4fl;cngQptcrf_cAPOiI2gK2Y`cfX"Q'Pe9`I!X3Wd
EN<q'n=-b-UN8/Z`JRNlEhN@lbIF`B6#S]A%u2sR")r`OKdXs]AmbET4G&0l=kcU/1^#<W7-ZD
Y'ltfnjD;=$V2a^$J1P).+5D7OeUD7u:hUi+,Rh!@&SYS,*]AMR[R+1=7Jl>luacJ+ga,'?W,
^jXA:SX\_jk#)FC@Z[@>U<RKpp'-&N*i#)H0Z<(@_B_Bo$cL%m(>r4Q#78L_L7X/8\XVsj<a
X4poDMbZ:VFuT]AgWt7$e2Ugo!K*6CXW<M.k>8B;Onj#3>i;S0Ea6GE]A(TD"kj5,F,Tg'DG$2
jN@.Qr8?c,JqoOV^k3\84hZt?laj[#X:^RJA'qR2NBDPY\ERt"j"C0oSG&Rn!E"LGa*5=r56
]AEH=;=]AnL4U#ANBc_Q`U_[q6CYha-\]A]AXWd>WfcL9*MP]A",Z2O(-b50&P<^gDP!0qj'^6[no
$_ggh7/GCIXqU`m>5^bkSAq,]A8!3@gp8W9"<@lk=j(NmV&@>e+V;hXdTpAk]A2Ma$+X0?[A)G
@G6bkHndE+5ti'2]APW3AWLaT7*@i=c#\<G*"McLIZlB7X4&9s6sGZK]A*9'A[s!BC8)gQgK"[
A^?O&5@IV`O.K/PZ:G;>c9*o4"-m*BegAus;7h!l;>l?;p01RR"KY26P,E8YWU<k<d-2lh`I
Q`j2M2Tb6fjFU=YK34P_-mUGG6SoCoo;;cOZbK64?'<$uSF,bePf<M\Y0oFI-*LFI6Pb/$4D
$/<)u$*jk@2:\Iq7*Z;NL]A!PpuX6iWO$C+4cdoP(DQ___s@eRVI`Y]ArS1\2G\>Oo)[aMB>/0
\EH.3PGFeCiqpV-`,;&O>eittM9Z/U1'e3V[G=(oNd0(73O,mr"NP25U/IKK=\=40'%%)*bo
X;jFb0)W,KWUo",%\Rod5%WaH!6^2#>r+\KVbtN/[4jt@n&-Dc0)MLS*t^4`fugZ#B\!Jj3p
,#PgaB#`3$U<Ct4l\q_N5a's`"pY;&F/QbeLPa8!Yi#ipkJA]Au4Vmj:]AJP_+!gZb;0Ss%J,a
/j`d)QZ`4pSH`U%-o+i-FZjt:`&(kL_;RF`_=?$jV8&OpZ?`3NH,)ealePQF$PuHkdmaB2ri
F:DT?2d9m&6IuA5e^#fD_KrGoek8lqVADi1I[Gn_g&+"FFem:8=F*6U5QRdiB4)Ha0Oa)sKm
H=NmF@IB+7XSE=c#i3O4nnn"7TgEAjNpi8q&94'Y.S=+A22ltFB7o+^bAr*6q+*0o><o00B%
7#Z./+#9`L2buh<oeX7VH(G,b^N:n@[<eFB:d@AcGEe7J3e6?+M/XVW-.O1hkAZk;#4-eE'7
(:_p!Tcmh]AJ;>Wp]AO?^]A4&o(0]AZ-MR%F?"HNhN<[X<O@2tKcnE8(<`r0GSj=R6OaMFd6qH!G
VU5CAT^>>Fa,m=.OKE6/g$[&CK%X66iGu+'UU$?XYpiT/lrPg*QFsN>%(eei*li'JqD-^na,
l%U'-KTYV"HYWB)7hN*g_$3GAh1f$/il"7c:9fMrq>*GRq#GQ9aj>r:hK;)^4G'0]A7fACkZ\
fQj%`1cL1O2V+[Ti6mZ7>_n/H.Y^',-<e4QD1G><oooq/n#?nC#_B3lo;c*Fg5>1iHX$kuaF
3a-kk%E4/jpLrtrZntRh^pT+:Xb1&.+7&j<f*k@ran)3XQ2h:IO@.]A%^t>nec5pKZbqu0`^$
<053)QfNVtBM(>.WUHAQN&jYWN_LD&T<N`J:T:-7?i2Nb`/Z%of4"!.jAPoondmfrNU$Qita
p:!)c.l-O7(]A>H:G!+u3rPp_=:)At?jRm'[J6%d>WiEEb1C=icqb+)9=,XPI]Apk^#ps4=HO[
`$HQP2Ga$XO?hhH>&<>UL&2gTt*XP4q?>P7,)@&UJ3ZJm1dlKpJLPmg#inCO^g3ip(K(-/N5
R)/W>W3*_k7QubIIo;maQrB[\*i4Ca:ihY^*jSn>_ltTe+p\W^/I^LiCb<mO#R0me3G%,n4%
e14I)CkpAc^:s!cOLO>$E?=HE(fIOPpT3/L#bj/*9jjtFN77,WD`pD>*PS")WI?]A7kD#.I,%
3`dMeiF6;[InY>q1:1XY*]AH)%FCSoe4CXLD4o\:(mdV08E5_GqcCo+9.['#]A@9GS^gcW*Gk$
5%PRCi0[J8CZib&7Ufb`X6CRg"&XSo9/H!&m:cIATL,f%XJd/aWhWc6Kgk+qlYA,S7HZm^+Y
LZS/Qeo-S*6>e0#P&I::JEI:9fBE6`VH$:,8N*Vqjg;.L@<>'1S0f@+<YHUQH6;)%i50@i@i
+*?PYRc]A#a]AFml>k2<cC^[c3^+4$kngT;Xk*Ks5'BBphBM:]A%/mLN?te7]A>3nmFG9NV)LeWa
@k5EeLT^-Ph9@!Y$XT<Rnc"XddLuo7L\,_e1GUhFTf\iTCs<(WG1U9e7]Am$@bB2,3QS]Aca4p
sH_js?I\?\0N;9)pH\$FRk&E0ta1?>c_8HHT.2^T8r1Xih)(iJ\32lhO[0ku;=EdG_Z;IT6c
lX-JRBcEVt-u1JCo?@\g^6o?lB%PWap7!.#3pCK",2_f#*j@3UUQ-)kB*7tY%5UFnbIPUgE#
g,Wi#]A='7$j?dl8K=HJ1!#oHXH'fA(r^d\5Or$qg'fS^ci3NL'CYLj^1iW70o-qO/>HLdc2l
mqu#9H;c;mEa<"Z9ig;M<^m#etilSO`8?4B`\m+Nka-*s>BK*Ni/,hO"[6d[8jJBVhpKc3Of
(%m<C5lqgndkA7,1`T#hRZmR%OVnLQI)'&ftrs-gS_rpB2G2mVqYjbcc'GYgB.:rEs*;rIHb
8?c\LNVkQ5XN5W0DU<_<]An9a"Oto17r]Ac[7dR'c-L2mQu\WIp]A;b@T[6!]A@\0k*mbGThsO#F
Go_iN.#;70DC<#?=K*A7%Ck:HRTG\l?/'"dVesG5D9;G@qVeV)-FV[c:JV^EckRG'2tsNjms
?\/rBYN]Ae"72Tq5,&<F7F)<0(e11gIap73C,/e>dc$d^NJ_?31>B-o0H5aQN-i!d10TAXXPg
;`P\)_:eZ7?,t3+dBA9<^Q\]A#?flu8A7@[e9qX(`uTUQ%iqgI90jo&t8_5LPB%q?^dK2[d1l
;M_-g*4s+niBI'ph'?GkT+F&PIJtU[tp]AtbRIt3$7YW+hM=AjIZlTa$_C,)fcb1B3,6mOONd
2UbDR&l5+BDH;)n'ikso4%S[MiXNFkpX>`E/c8t<F%mfXVILKe?pPZ-Lo/QcW\jpa7d`0l:T
*d4I;]Ar(DY=o#.lB'a`>b]AI^qE%IGor%RV5g!T,%*_!=+Hp?h#V5S`5q$!ZsKolP@:Z?PH4?
.ipkG0To.`^&:7?T2n@GBrK?p$^3eDT+N5L.:85b)4D$quWbDV_4h2#_SdMfpFcEcO0t>9SI
k5&U"I^f/)1ChhY.BJ`J#(<d<,'#RXENXY/qcubf%ph#YF+14AI7O`"um=(PnXiMXLI>qIRo
f]A?iGqB9.:FE,%'<kc"l_\nf?#($@g0^kKG]A5?e(^^s4BtHeDPm?Y_\6F.6U`;tKF#D^>Fo;
$#(<Bq8qAgOGRQLm,k;amIQ%2fHJ\sW$TDa?S?\*JcpatOXPKR1+FW6;g0Q0_,\e_&?B),QT
@@.9Q+u.8YVE3Q?07d!=VOg]A@.6Q]AZ=ZC>%iGrC=?5_qVq`/]AcCD#OAg4>=O.u8uck>IJ=_?
O4&4SkU2>4+XC/-YM&ZaCclk:Nt/b(q!`[#qgEc7/O-2S&5f@6S=;TQ.0r\uk*4-rP^NkB@>
[Vq5>L"3NR_VM0Au(r5o&>[[+1M!h<.>XP@&06/*LR4f&g2epSMrD"/!FWLV&1(M5Q(Y]A0+K
6r3\XrnMm&1),4M;d,n6U]Aj"b8jhun1!P<l:AILbToPrUI]A"X5RHbBkj$J%VLuJ7G1"LA_Xk
.f(4.^0fDs?RB)5i[K8gYQqM0#N4^'#\/gQb9Y4iKa_Qs2IU?UdQ`;U$b>JKric_<dmR*TkO
IqFVr<9Wg#rHW$NZol%K%)]AnV+OaN0h*D/#_MqoH8B9PGq7Y^=\*LRki%s?R6R.dY>+aNb+#
^BqWJ@D$[/IJCo`USK?As(aTaJ+QG>l"pH#u@YlTYc27YH\4+)lhu8d?:]A+C<NiMoO?GgP)k
%<>0T'Em:T=VUS__WRKRKKn8RNp_mu=.g[\clP-[lTXSk^AKiSu]A&RPpc+*$j//%GQQr(i!k
hZ/)7(42%D1tF?bLWgG4Yi)P<*8sPO\r>`+e)C<9DG)jhhGAa.S3n"%U^jAWP)1jH*5-u@ki
[\M%<AF:D>l1HK^&8M+^K`TcT'IGs>,j/0U,ZAa(HLVllp*>np:6YjPtNNG.f#+L!;.7-G3_
`)?ds!hC#W$DTO>2'b'/0PDc&36[Ia8Y,K=QK(mnS,I,U[RN<a=W'#";KF^:TWA?G)21Z[43
mJ"'M>pG%)pUIlmO,HY^R7D"\J`7=T8=h#GoSeKQob2h&ShC@Qf1Heu"4e,uu[OF`B.@3:4O
"k&XOkAootUYgjP5_7(?XjZVt:ZG>cIjbr3CQ$N79_"]AL"/TM"grcD_u#7+D2h7=o=f![3.'
_cF8(3'[?^l9rB1H2c'Xf5K?+?:k/"DOA&.,`T+5U5.3rCf/cZ0f(`(P+T]A8!aK'CCBBHKU6
oIDo7gX_.;b!&m(\4Ulo\LIFsf\pIFcJ/Q4!>2-LGh4Sk%e_*mi9N,UF"?N'@gLkMep/2_J$
4n?nOG3"n97$kSf165JP;3Q;#RgKrr_-mERJKKFD+"I*X:_L.$KWE$F^:<`6r'Z,0hKSIoh,
(<2[r(o2Q[Xk)(PQ]AZ`YG)PD4Jl9V>)n)a_OssW"sEpY'HJ%[P(Aq*X"AR)V@l0Y6E@ic;Z]A
MrZ(7tT;W^m0`'PN>i#G%86YZ(lF9(^\G>FK4"8?r:fTQ:k%1.sRFc`%.391Q?EN!.Te;;N2
WtBW=G1[>]APS'=C5IFD02[=Z@t=F\^[8u;DGWT'b[LaB8I8"5A*(gObhDIJ>EPt6&=s?R[ZR
/Wc:JH!1=g1co)\<hG1F6Y`2[>b:.a*O2s"]A7?B2Rh0qWG(bRAP8Cg0.^5M!I]AUPuTcng_+.
Y]ASpp97dbo3TD3K=m;hale^'[;Pb&XRVRDqO,Ga4;>3@H0^3`<<15Q-"D`cHLY07MITMc4?5
%gXr^Z\R>EPpA<.1;-IpT8bJXEn]Arg$!#6L:EuC=/&fGaGY6#cMu[@Fccf_oJXVi;%Q!8ur-
3@HT>+oR=!B7!')Q\4YD+NZmaL:odUS-#"I;#&k,#s0crQbco.lao<u'eRZm1H=umu6Vg<b_
FK@1AD?XS3kHnHJ(katMP4c_@%dL2.b2IN@#`joN\QB/GBTT'nB]A]AMg9g'NXR"IX%(gm1.I=
bd*Sk@i\Kb*9Ni$/q(Bj,1=t#dRq3R`*o"MR'*TRsKp3=SS39Hn[3@Nf47aJ8-V++[Wl<IhR
,0tshf:gBD%:,HZp);#SD]AiP0#cHaa7!ur33n'bWlu#,iLCC7u2-<Ua2p0`4pkC4KW.m9VN'
;(NN4Ru%>-)RS]A2hf6.BsgAUJU'dQmW&b.M?>e*"YLfZp,4O@71Vba<]Ao3s&"`ep.snU?tP;
[p\Hq'E`*0,e=nb;qFu2IP<bMb>:rt#q;5Uf(<F"Lh,%oEP=QK++,Kf1,6m7X?B#SQOG_/8Q
HNND>maup:jDIL!6M$ur1KLl[Nlj*SrI,T7Oo6J6DlU!ATX4d>3JWdL)m-9BbMqRr/nHdG7J
MhpjMM]Ar3-0\CkKH$WR=fl<'01D!r"_<_!D^L6EKL$565Z*LRm@7[18@4=*),;_nH@b"0_Ik
K&:/8O[1T%c-Rs^/dFK<W83Y)DAO^QM-@4Sh9G5<7g(C#<"9>N^C.@\deeYJn(Y\4cUT$Rop
>g+-.G'qk/_X#$Fd6_h7:"_0B,D,"Xmf[7kBk25+lWfre5t;Q4EY[R(@39mTUP/<&gL_]AT6M
N9A`f/m(m0tr]A(="S>8U'nN*!"g%s3uk;XCl<M))II\g(pJNZMS*PoO>ZsY5NQV!$F(u-Zgg
>AW2j.kPun^*j3FEt$Y!:kne\;0?<WJ>pk4tht:Y'a<u=Kh+:OW1<7rut<t<LOVU*s5qR'U(
UE<FD:mp(aK3`&[?aaeHKe[HMC/+gL=d"Kr(iZC<04YAH.l5eZYKh)0Dj`K1Z6B:!Rk>9S9&
:H5_:C6gOT-]A%SGXK,8&#YeB:840/$$Q(:Y0pLn''A%E4htX9JpKGb]ADpmSpr(B/2f-Fi9V[
]A'H$hX#hDE)VESZ)GSLmVMkQ'E`Z(,[opm#`op:=(CuiP#33p&1_p>?(RlVXV1Nc;L?<*<Ch
BSXLkJRVpAFq,*gb&+-#9$!*ZeE.A^*H"Q:fL&+hH9W;kgCY=V!ePZt;`5"Z^mMLtp6_ErA[
<e"WmZX6Wr@@ABYtf.'>4BY'<V1Bl/cq``649^ROGP\-q4D/SN=deN8L5*O'h/q-r8os*OC2
Ds3#24/NQcFjV_N5FnH_8CRi'$%82cK*VhnfOFDabmPDaYBD^F[2IDZ1jE8Ji43p@1_T,<j=
-&+P^k!9jV:<\?dgPp^/K/gj@Fs:-)"Xk5kDpeX!6@hlp)h21s[j5LAU*]A#"9V'PN-H0^c]A$
*[!81MbY2j1M2.HY_@1SemAc;'U474kM9gBL!,^0Lr^qo@Q$"-3l>^;Z=Wka;Ll[8EU*j^5l
gcdl$ZpQ@\Q^,f\B*G^Ut)_#@VEa<?U(b#W\@#j95TCh[4%#%F=q""HS]A97;M`"Xgg%C1`cU
!NeV`n/VjJS]ASR4`"`0R7<6.[u5+tM`q'ab.h[Sj0C6]A4LZ?><m3JkH'u]A0hkTeoNqP@SEWY
>jg#ZLCVPV,aJF*(2bu&h[<]A+?QJY1qfc+hd.B!3g;I6:l,%:,bVhJ![s9@D*HK9c4GPeV&X
i.a*gB]A=CI5G^R;`P[a^'kb3uk;\QdRm^PSUZ]A=,aIITQ0iGK]A[Mt_!OBCtB&"^([P84lt,8
N$_\k(#<4]A6s,F?I/QL*bUD*>E0uLQ`2jQ5mPW]A1,T$G(5hN?*<AhE[5eFPm;Wu+*A%T"L0N
O=F;+='U026TtpK(F2%Jr168*f+K[E]AMSi?m^O6eK7*2-iSlpc[MV6u$;R?]Aj7$l\8pm;@SP
pkF<bRg;?pS=&KO\@V3\u8"uCN7,^?XDG/LHlO9h!'F!H>I;\f[st6]A_ReIRWbg7EU+aXM53
ct`2TTX^J_eNqO3#XF]An0HCg0#dhRe6u9KPqMB(Y'TDaTuEj<T_Zs72JOTR.u>$n5r#qsVOs
+%;_u$lfIlX8#n[$auMUU0W_4-BaK0R4/+r^>6iRQNh!+NM%3:;FhqpZ#!Fq$b@5mH$."u=H
9g2Gr=OGB[p$;Ea/iuQT!7QA2Yc4"PTFijKK5fXc&&5q^&4M_s8mupoQ>HU".@:e\frTY=%i
eIYcf?:9@(t`"M4f,KLHCkb1>\bLcP#^bAm7\)2:@2o<]Al^d=!umVs!o8$U"XSg'2s(,nNC_
-7(W#>VG8E&>99TDc1&,H&cAP2aPnd7S-ZWj1EQB+7E+HAbT1*PIH=)G$m[%tG!P63.7!b%X
LD+dHds[GT'!BUSV21)EMC+)h<QO:SJA*0fkVk5_8jYp6c.mT>H^U-_A^AVpn]AgTpY:3\@:,
1sq(YAMP*[^?<MYI$N+hf0O;\#4'A.)c/3j'h[CkF*J0tZ11/[Up$u54_p/6g$=WudFCHY0#
-sH"cC$Ii7Pc]AHMT)`UV9Vq)n(uV%X8";QG\FjB0dD.E?p0.)Y3_N6-8EILc@#Kn+i]AK!!I&
#XRBG(=/U&>o($P^e2BJSQ._K\?=bou"`M2S<0bI'6l2p.nROO*pAa4!fb^(iqW*XV,B]A%Q4
(g)TSUiiY"o6?d,1I[Q+]As$@9aiDJf-Quo]AFY'kB>BnQ`cWqmq7nfCri@ioi5*Wq;k=:KKuj
11O5EE+#lk=E._n;T8tp.C;8n,2@e:QFMb9s!X_G+6K'`CQ6:>TcTsbg*cXO0BL&jI4I-E#o
@c\NKb[PU#Im""F$7<7)l\\_B+;a2e]A[[84'PPNZALg6]AKIV=Z0u8ng6-4cnRoMTq,YbFcZ<
&+<L`YJA7JL>L6HfHLlm[.Q@k5DMC5I<?V#WpW>]A+8B'nME"a`E\$+Tig[<1E1<iKOr?5,p>
#Z]A$bY\8VK:bNAgajr":l8B"o=B%_#TS>^GgVh%:olA@oFP!3M`"u`8c(cti7-=+o#('Tt9S
342!)gfO!PicnHW0nq+M\fcKSW`bHo[(-#%p@F)_1.0H`j:a*#.//!bRN*[Dlif"pi_g6XZ+
DRFM5/?\7;h#RfA^42uio<Cl58U[Osr6`8otICN[pJ*E:o5._?*U#a>Qa%9"M%s66&,1Wfa*
3cO>)#']AL@#LVen$(;3AK@A&Q\,1>&TP+<Jf%uYPh=ad':\1Vbo,/[npo>dhLc0`FT<[28@p
O3\L>rIZ3cgq0$5]A'`oP3n;Mmur7G)pS?k7dQMoI/(C$*I"d:741uYcddA;=;h,FSA\1+B'u
$1!5%^npWS#"k&D9',I*rdBhd3IGJmMeB-*-AO3^I*5T_Abf1qj,J>Mr_/;_N&(f.+f;YrM;
GXCX!#[GPDPW>%I%C-Fl-KO[[K[a\cXGM=^2s6q=!9WUW1>IS`_e*Kd:'BU_alVX4`8(H4<Q
qZl=jn$F>[*:9B]A#mp,]A\fm8G2-NG"VA"2buq&c7O?ZRch;XN'+kf#^kI/9Z0AcWu&!9-&Q$
+!Erc\.'rq^Nd6t>[O^l9g-[siLeluV<:!&#`Y%L*RI\WW4h3Z!CHJr#^.ia\?dF_`ce]A\[Y
mJYN^lL]A"!El2T&*a4-g,]Ak@D.5Ids8OAeHFWD)/9eM"K&:6;pZG7J/dK6p:jd1:XYbZCO7K
ZmL`oO%fPA48nlZr\SP$'+04GBaqtY9o^"k`@7Ir`\5*!<K(E=Mh#Hs0)]A]AP^DEYb#<&$6uk
s>n@Y_`Z4&6rTP.8I@GZ9rm`a=XlkNc\j2/,Hu)#J=h4VCK4pHog^BNF.$^(mD^.n.Oghe@)
)q!0$ag<$oT<QgtIWeT,8Qo)`JD(47iM(!-f.WD0pjG"*(:=&&&\%,PIJW=A#=R*ZNre<XNo
/J.j@@H1X26E*=nVr&1bVqY/hOis&PC&@8gV"dc>^Rr7pAA-/*F&QVF(T2#;]AaV`UhgI%'6]A
7Mln/DctI8>bPs,`;kL7Rg#rn<#]A2lPd1[?rC[U7(F_X*IAG^tF18jjBp(/_]APHF[('n#1$O
)_it$(AMB]A?`I/d<1l#9.^"a9]AprmD8o*,_mr.LP,5]Ad8jQpl_F?PQcPiFh?6GkHM\T_?m8i
$d8-E!02,p?"3W%,rW'&U32GoD>8u,S=rg\`hDCOU&gtnY;bHi#Xhr`s')64EAe"AXMOs"mA
BqAHr`Eq=K#tLVq+_BqHr/puq.W[4ACe_@^'R'/i0R&n^$l4>X')i<K$=2TU5;O[gu_&/2!<
=/tfoEkOC[J--[9bc%dcTNeg:bF?a9O.MAj_;.#f>Fe<m'EM30>MO#>;ErM)!JDEFol98<:l
'tP'q[g*rcub+XF1k#f;h8OY!aF1+pL>UGd?8m<B&;%On%t3*&Oc=BF@/"e.VmDj:G'XEGhQ
qn3rBR)0YFqNb5uZ_t@tMKXaK]A5ZLNe=iaKf_0;k*No*_t*rUqUm1:>K8oJbl^@[ick/%Sr-
45);%M[rShgsf'^5Ls&=#YA,81)+!=)+\H-DRf#^5J%TN\8&6b<(="^<[:NnUJE(rhA.kodr
mQT/`i$ep9_eRA48Y8Jiht&:0NHB"t3(PZ]An]ADBqVigJ<_C1,/odo3$)5[IP=/R4_/bD$rNm
0tLrlRmhcGWG82Tf4EEsWSI\4_qUnDF=j[@Kr9eg8]AmuV)*bg0:ndL5+6lDAWPgAQ;i:I%Sk
]AT$;9<T@IEoUkR.BpG\#C3-f2fsHo*6T0&Bdh$@9$iGi8(fgcLh\gUYc0_n!JV"4k6q1_%,Y
i&C[sVO=;CScB<,W!Gmt.mUbu_dDh4Ijo!+g-A:Th#pCjmEE,d6P`d.)OOd+,]Ad,g2r9(+XO
V)7#>B@"(BLVsWB,'A]ADPf$t*cPSs;cPH!d<3agMuFmn2d/2PBeC5acDFeV>uP`dG1%pkRoV
s1[)L9!O76hGYs3Y\iud)%'A%?Bq*9`V3esg*'Ni]A?H)e=a,0ZMCWod\9U\GgHM1[SXG,b+d
]A(1AWM0&$L<#pWET`4T[48h$]AmHb.Dlu(L7.7&Z/fA4eY6immtV?96,&'*E7(0M#-=ZjiT:+
X7\]Ad%s7pOb=B5\>l9>J(*^Io42NFn\f1BI[[c\l/CqMA;<O,qp9p8.TlBOd<n9#`r+^!!+p
HFSU[6UE[rBFd$K(H9bq9":k01'6]A$IOeKEqF+1&Hl"=XdFV0gF*Q9r18PIAf0s3-6_LcpV1
o$$<OkT:`T]A\*SE5"`qk</d]Ap02DEr"-JVn"W(1GL;$b0D`gJCXY-,N?HfJ.-ra+V^mB40Em
#4oBhfoGE3U]A`qV_Y0<ktA!(hu,%'du+M%2,JJYE2&[I]A;8qGBo32:S3\6M`bd_@Su$'7LXR
(A[i#9LCIIf@'scam03_16X&(+\(7`k@Bp\otl"Zq;EtupVh_7F.]APG/R0jJ9D>]A$o4M,u*#
3T!B9)oG`W83kC;KtO?Kk*Nn<R4tQ%7K(2&S8'.*?FS##WZGNGg-=W(CV-q=Xs,V4mcC4\S5
8dKQ<&CK5ck+^;R!>o7Qm0"C1D'jDQr8Og$>Qd6Cr78Kd[7o'8^XgWid/bi0B"_Jco&Bc66,
bf,VY2:O`SIlbSaXO,[*&N9ek*ocd=DiDH:F2+k6#=lt.A4OOL7"s7d+W)k"eV7$-odlI(&m
r+a'0Qc@bB$KHG>??m$@8"VP)r%'a7Lnej(bG8jNAUbsLZ7"BWAD37m9:__kErjWuVgFQ5I.
HgC-@lc2tD-<`q3$h!jF%-c2W^_%lqD3-29Gn4YPH.55PpgP-I7Hl!aK)@&3cD<>c<Erm4M\
WEUO-5A0j.C/_@%&%9>o,dJZl^)[@&R@M;^l0VhpNcX"K:IA$(2`0C3+mp$=$GeXsGj)D3C(
;Q1/I0R)*qQW6e&B5,$-5E(CBNS3RhCCTpN<49+A(_e<!(QHK=G*+HqrB&R!X22C1c@/;DkU
5[Qpo,;([\JH&]ATEFS[BR/!XYWq55MV5Q#hBmG:#5h%q1am?]A^sR>uo7YnF,3c!1*-2SL$%^
?8*em0\d>nR0eWYc@DTUJ1Ea<m&*_-&VL5F\7A::]A:/h[FZ!\)oEiJTSR^RINO(a\5KC!l*B
"%'XWYd9\B<j04q0%>qR:R^'f3DgtU4_ie8=/U&iJspTo4rsoCQ-mTAjqd7CQ_gmA`e(u55V
]AbmF;nZSM&osZA%$#QD57OS]A''j&8h?JCH68IufSJVi$%Mte;s'rQe;9PDC$jCg?i$Q[5)]AF
6V2^=[dt&8""T\0LXMM-.l+"**L,PYF9o7lNU"J/`f=JID:PR'>Z6c93`-#@-R6kJuW)h([B
[`]ATE^9H[]AoLs<*-:#,E+e8E"ajYrEYrR<S>5n)[T@tJ0!j[uS#9F/TN10=qrGmH2[$GYWlH
qd;"oTq;Q$'F&LQBN-;:"q7e2-46Sbb8L)")2]AG:!F83S=/-l<H9*5FMF<.o=lr5:8g@78*u
TAn3QB)6gF)q@,+\'u-,%<W3o5+b2O2!8*YM[9!e-i4$`^"+<jgi*-`0(o3NZ!Q.3k1:8[E'
>LhR_aF]ATQ!)@@VXK^2[`ChVnTQ)jp4J:V=)rLgXJA]A8g_6I$rRDKW`%?uO5tTcgGQoen2Va
#162kn3Pf-OqF9Xne>#d>`6mL=cP$E%*d,5!RWfr:SliL!+1_BpfmZV>TZ/j)haN<hN>L:8e
f%ur/r/BD($,4kQJ<+\W5g,HgCG&*ks3k#=.-fE_ZdJS^W:d*d&j9Cm'>$cVn)f(QnR[`9j?
cnPnWmDj#DDB@t4V(-eM!CnpEdOHfoUi\!WC-%"PgO5Qg]Adi<lD(44tZ*HEF?Ze9J]A?1Di>F
,5-&$0FCKl+;$tgA4rPbQ!uql5KXX@_*"*K>STOH-^:Rtj?NIs+a;MCeTHb-,C&qJC3=NO3c
VEsFPOZLC1>CK,2bn`&s@eMB\(67NPY@SfOP-'CNqMh@Q"!?lgiYm^#JYkZZp4e(a>"cQ$>U
cUFl>_&#7Up^*hHr_+N!.'a-dZ!%4_pJgY:7S`-E[g`dguoHL)#>*%?ABpj&fB7]A1K/c']AO%
]A%%J%<DFWgROPh^JqY;'t4L.BXgL&,/JcadOsVnU\f'&,P\Fm0$_rqo&HB@m5anZVR9JE1pT
<M\:8t+i!++RU[rpZ!cDuJ3M7\2KQqa9N2rZTGrT3$n8QYbR7D.<+/LiZTVC$?RoJ(o3*.dO
^*=8rU2_8,Lh7LC#g_C:=1JXdcc//IS@OMiKA>o+S"Xo!oQl7WV/g-JQ"L[27>[c+?;s9mRb
=HSAb@V?\hs^q<CB4IJOk@*Fjr'KIl19C?I?;/L0!>7Rt\D/ema,FEu?FRL7NO3.C8,aa-bm
5+doT!RmZsmJSdD:JHkP8'?Hu(kF^abI0_9GJK(3`DWc"qL`HalbRP\niqT6<V<VHTNtFUs*
n/):q3H'f/PLd2Lp_2?r]A>StVD&L446&@,+)9/B,BB>j6t\UGIfsMmBt^"TPlK)5232eU+]AN
o"d'M)+f1+72s*ZN&rq#\c>[g6D*eC(H(%Yp_L/Fb51_DF$F'c"&6Cu9Nl=ju]Ak3'`l<#2cG
Z`6NlS8ej<R::j9OH$teA7`N@&2b2S:bAQD!#0FLq>om[CG7+kOse%jJ@\=QD%p#;/fPU3Rc
AHO*L(IJ:!*-n_ra4B&IJCqHk>1V%1/csEVh,c%K'TtiuLl)e6qcSkBc'<M<E_t:55AKn8=C
bgFWug*oWeXYu*a4/&S1P`T-H\K<jX=,cFo)/o!uLmA*>_%CaetgY5'DL3^BU64.HW<3UrVP
N1TE%Jpld(u/WBe?RV0lM&j?8bA-31N@Hq:Y;^O\/TXSVMGd!fYR9sabX0H<N_$:drs)AcfJ
^`p[riCLVO[R'(r9$:oXM;%0u_X^EaLi`e?Ft;n#;J-HAX?>*Q&!:/U0I1&WQK6NTto`DbiG
WD"0jp-WQk2=BH=SN!adll#fafi%$0%,dS&""V<&%j`]Ao[[^SDp:dFj7+[<3Hj1Ui;p)C09f
,lDQ,o&5Zh5c#c:m0!7u\a7nG9;mSdVunF1U7uG5[XEal2tdO$(Oaf9P;!KR&@<Nn1l%\]AeH
;KaJRMU\ZTPjV"!]A"?6)P:Cj&]A^rlo_D>UeJNF]A=gXk*U563l*+--ljnVR9--+\K@lToL.o-
qZ'IPAEP"f`\8!UKXR$\)-/D28/(>CE^te"cr"-kENa=>Z#H^"0UGr1mp(>#1ToN!a!="XZX
!3Rr0]A`J?]AV0-I!"+'o_#Ui8Q)"S[qr!gFEW`c*eDZCir2RBWJii8d5XEDn[YHjo_I#s(F'&
DPRl+")R*_mT7H"F(:Wn>P`?$UslJ#]AteqO74tPc*s9)'6A[n_X+RS*euNYn<c?WeD95_lG*
#onoE(rR?*`^sm*E-N%,iC=bjK6MJ>f->kKG;\-[mk>qT.Y_^YZSlV`)/_odE7Kp2!piAd93
<L#O5BIMa:nR;]AjT43*-A<'`WA*-d5-meD7(C:SCrTrtujk"NNBSMI<g;#NLn[B0#0/\o1.!
Zr+m`Ee2f`.IuS@s,0XTKj1RGqmL;"K<<$Vgu[i2(J$]A5Od+T<)"OH,mUf_LqXq_nb&%u>n!
Rq5qo-HVI]ASED2#&2,8^)qH8Xbaj4a&QDR*31m=]AE/]A>:e[hW,50UU1L(`Xg&pJKaAN#NYT=
:&lc.g=%TIUqB<Cjik>C=ur++`hgPLjiT+sE:o.B>n4t86!JLl>IZ!H=6qm<7Th`YWQFf8`l
VcQ?;Q&J'geJMUm`5.mJ^Ga#ORX3fl%['JaOH<)5Ur%NQ$FF,h,P$SV=Yc&NV=sl^kWW"`)J
-:scE:jqeNH0Ij5N!R*KQKQ(QDFdQQdCg[JJ(cJh?c`M<Z7dcVQ$Ba3MN`7["cNZ#rq+fi*C
bPOX=7:W^C@h,i?T.@$[Hb0[0A!aKfM\UY1_9TRX5*l+=95WEO`9b<F_YPk.X'>Wi]An1+/Yh
[81+\^%&Ap?b^3"pSX]ArW8jF7!cVn#l-bB_O&Z>;(j0=Qe,@P<aT31s!aS='f<mqJ?ro$bq@
O:Dm@-46J7a%APA>hk>l$!5>>#8.-DW7]A82R+_'D'As@]A,,CS"k>`fm_1]A1h5>jbZE!'Rol*
79&<O!nCd(GYCP)n#"(o(IpA>.Zort\MSPD;6H*`frs+1k&>O0<-Pi]A.6[Uhm6hk2&'WNC]AJ
PRQEMA?7Kp]A0o_-FSWr>QD;g_6MLp[kZ2F$G<pYSJHl+2M$2()gIproZS)F^EUg5!i=Lj"=*
DB2i9LakF_s]AN;>e`$<B@q6&@7Mj/3PNp#pqFp@o)WD'F'_E+Rc)J`.YMD:!p*F"Ck-M2<UL
]Alde100#6EG1XH'Y`:WTEiMG\Pgb%P8%UtP.'kH^\OO*B,7GNG)[M"@-HL?e(g8U,0q*o^#,
eA-jnOGiQ"NZ/[.h&]AY1%9G0;DW8%;T(Jt"1Qu:!ZaCZAf`gAjXgAnOOe!(;O17[T``5i+7I
<&-\B2#sPh[O0]A\\)Pe/TB;dk%;_Apb^;QX?rpQd,s;X8[eX9[rT%qhu#$R<EDud#c"GN`DZ
)@QVajqJ^MV=f]ArJ3G;<s<@1WPQHs9_@?m"LG_5\'>L*Xe(fP`cJpZW[Nk*VXWKFCE]AnY"!G
h:sZ9=-%/GL8-Va-(^n05Tu,H'Qc"<l0$a#(X:^;5GYH2AY@u0AJ0O3uhqYMpHB4^nVRf9,b
6:N"[.3\&no>qbl_XM1Y(p.DmOi/#_q`6!/dFbBdZh"5F8cGkkH'G0RO,Dapeds%mNrE@8UH
Ze2O:X=e35<I?t9*1thJfg*4YNX2SfHR4ot=\YpA\;MX$9I'&8nBR;c3&e#-C8&gsF8jXeJ1
pCcR+'PUn:Ku"/9#o!cEl%:3IeMeJ$$^`L`B@M8BQ(H9sk>]A_*K^m_arD1qdB0o0n!3:eRX7
C(k<ull@-jQrHZhmOkoh'Dm;$d.(9+Ok[:o>LAc/$_mos1ECe2:aAPGMhi79,,jUbo"dtW6d
<1S61?'QhLu?JWNi6sj(8!sgp_BT/-`,p$CR?8/6[UrV;"k<_m\MAm=l*bNab:&%%)D>q2i$
6C^;<M90ikHLIskTW1!?EV7(/F(A;c-s\<Zq',U^g'n:$foc3/-bXRdho_W.6d]A@cIi#T2aK
\LNOMjd\JEF,t_'q"#JXD5aY[C7pO5H>`I'T9\Hg2>PSg,:WIHn/i9>pD+$A>MN`*<Q@-IPf
-,$^FTC+_^Fp#@OlD>;QY"hM61Mr)]Al@t,L%6Mb1&j@M\8]A]A%ZUIU.t:0T6i-:"Zh2a(B8R@
DI-To#T?^,[6:c*m57kC"^'#3Q9Oj<-:1HX#N;be^9\F3p4%IM--#Mg]A"Gp\p,NB8A.^j.<q
chl)Gqg(6%+!:9"FW"j_X8Ts0C\us6DJ!r(a\M'Wn!N*VHc]A`Xu,]At6AnO$#H7A1mA.T.)8)
)$\9RUXpP>l`rr#5r@%=cI@$f`&]AiQl":uoKhj_j1(>Xq+L%r4LgS$L3c'J3P%e!Yf6ImUK:
oLSR]A<[rIh!s8p%;``sbOmkgo1F/.crFb4T&hA2HS&6,;!SD_BFM?JffS3KJkY\U-RtiUL#^
?PbU70G`NG18C6ZS)6oa5,\CqFAr@Sn`kFI$VL<Dd#a"O73PkNt:mXZ?(6MWT9Zgq>)-Pb&U
\V6UT8b^5M_[8Da&M[9:b_iF^r\\-P_FDiK,)A.$,i%dh^22l!H"\L`QoY@#Ni7BHF?U:`0E
sC89k*V!)7;^,&\ac08TYK;M=>I*m>h@lbauonT6VQ'f\/CLqcN/Fg/.adm$R*,CilC*#MSY
R:iC2PQ8\4J6LTosckIX;5IuaV9q?>&0'b)gF?%`i7n".cIXNl.2&':sJs%r8-:ebM,s"L,<
-IOuuTQGeXN]AMt_5Tgd*"JkeKMc>h=;F9i':mKlL&5YE@+s"UP#m/Naoh3Z"nTj$lqonn;f"
-c.mQG4OhsPi`>a#\_F*Z1M:K]A'`FZ)3KI^LaS.IR=O4eF*!7R#,A/&^NI?-=Q`aI+*Mm[:u
DnPA$R<[s$(bOkjce+?:A(-HihAI<#AiARK7?]AAeeRc2WkmO%JU)mPZP^.!RSR?&R*-Zo921
:<.6&=6WdrI_`@hCtO'gYp1PK@n2%F[kZkp,9CfMmGPB?K:J`_%KGL)b@e$M0\P[CX*_TpKT
KG?A-7eA1dBHb8Q",3_1QE6Z$i"M2#]Ar4bI0Bq*&<63N\)M.?ZT0F'.Sidh!77Io6P="6kZ?
nQI@M*%$?fL;QYQrj65aEkE2oU?&UO/'4s(XO78f`d-[NSu`<g/CKH,+-P]A2h/GXm9'Z?,YE
%+i.FDaR2C>$a^sb+k<TKsl9.rB0YDPHm+ol%8E$d@(k/RM;]AmTB`5'TnbEu:#uI^;qcJ<@8
7TY>!$C9LVEUnToh^aY+rQrW4]A;d3a%iRPcBpctWPf2Z(S-9MJKkW67r%AK+KidhVfD2h`65
;)aD;j[+ZcEBgq_BBT9Z*NVi=j<eVI_cIJpE>*F3m./iTg,7aUCi@NEX`B=Z/e]A#.Nt$m7:N
Xn]A18_f+%k*[&U,ruX370Jc7i-sla2",FPc"Mk1![,:`[MmCE+DFd:fY\oPE#jn0%P)LcN[O
L\Z7J_j=rd^%P@PaiE[W$f8p9FEBNFQG8sUqA/5YT7&(">J9=A]AcmIIeI]AEo:%=D11:A=D+Z
s7kVdukFdqS51I[f"DQ$6MdlVt3smDW,#nnd?4HsQ(+1XeX;J?da]A7.C(ZdJf??NXW5%M]A&G
B`E$cn_d_(b-&!6e`]AgQB>bVbQI2bKU!W.TZg/_^m8;b>/:ug0W2F3.;ML5&4qWW^Dn3t9#_
)EKD[A'ZF;7]AT&3l@X`93(1b`5Ylm\?]As;g3:fkqqO)J#ZQB^\qk-ll#AgWT5/RE%+m:S.TW
DYB%H;+e.pn-9"A67^2$g28mbL9,*111+YL;(&=KLD_*-KD]Aie_8f-HCr!p)42f3lDsToL4<
%B8h'8h^XcBm:LY@,b.XhD".on>G>ZU(31;gIu4lBO)7,(\&78F]A)TJPW"/Z(uiMs)sY_i!u
\!oS89\.D+u@1N4VbOLk;+qJaBki?FYI+^Y^0KhoH$?YEcX&;'P*n\\Ak+m=(qU(YbBtm89e
T]AsZkXj-rH.*pU`/PbAh[_8e>lhqZFMgr1;l;mc%A1R0t;[5gj8fATdt&u^Yb9*jlY[E?n6E
pIuGbrHMm[S[9ti3X@GirKbBThkGp6\R[hN<4_M!8S+ZNnVQi#-:M?WGphp#&7,tUB\')+^'
!9%b=E"gL%%3.l^)#>Z`:#^4'7+TT*"kY0@((%Sb[fT!J<8s08tX!'4nYOo5?,1H+:W+P9q%
p@MYmDSs*ga%9"G8)FZ<\T1:_%>9*Rj<Rm"Ghk^9Eo04A^gf7Tb`==Yl$FH7HnC)d;ja7h3c
]A:)RNV*7aiUp5.='%n)n#3k>;dpIA0)(bol?,]AG2NVbUt^UT^W^2I\WHBuo,nIH--\.pX\$8
f.X'S.7HN9]AX(8%M.XC'Mi]A71\)78*0UGVc?Gb1rm(u''WPHlCq]Am5c5"^B"V9&3Qu9bY<SZ
X3K8/_fo)D@W#D#8XIUWJWdj4OLCMf^5#G;+!b"m%!qqGP+)eR+mPfU[hh:aOgbK10bBjRZZ
$72BX%G%TBYoq1c<6a-d%bc\UNTI.a=f*HsM]AU<S[d)\Xu;GUa$^#4[8ir]AaXpTAR/);d3PB
KrZqnVmjHb[4-KX<eam:Fn%$71]AH3O`(Q+,_)=60bZ+".)[B35^1OCCO$F9#@;([s_e28\0e
=iCg3&[B'PnS#;Yn;f'FCSlb;DT[,``NRe0$p>:?GgO7Fe>@_#?/^a\(9Dpkf9>>Ra%3:$Pt
0@S\r]A/cNb_XqJ'gP\YSR]AV/\[fjbV1D_[f8*`*Qg0d`e&S"s2\W-F;\*10fSS,9<lS6@<77
TD3PVUgf[.1gJ*N>AU@kj1f5HNBVNfA_?X8'S0dL>W:GT:b&W)u8.bhl^0qYdFZdXtTaii2=
_]AK(#i@&P)8HJSk29HW5FRNe,V+\:Ip&o#I_p5\9d36gh[rPF:<#jJDu9H%bIJeN]A$Lh3fg4
dtA7n7!BC*L3V[&ic%%JftF.(D4,\p!SITrW8N;i_gDo5H+G,%ocf'ti:B/_MQ^g>?%W,C8a
4G5)-Rba0<XHcgai4G<eV(8XN-M.._Q)Y=OF)rU0@'^C"+Af!4=s0X?h'^n]AX*Elce5qCLkc
n0%u/lG,bth?!j:.i#QSP%ulGe%=f7l`NY`SC?!+4LnLCq&mZ]AJ(/Z:>"G1suN]A;f^$@T+TE
=g"]A3\Dg]AF^:cQl*Uj@q-(_Z-uJ78k)0qHe.LpB#2.8MQ,OrpblJI5X5-7I\J(lur4qfc1_\
p7)`D_"&^LK`pn1R=$3toC&:-&^?7H=Lfu4bqN9'c,DVQAc-qCkQ::'JFGWEI/#9Pc1Xee:s
mtu;L5/DJcAVEFR_^ej8hX!uE[,rb+?HR$^jH/*h5#a%RIK#OR"Mu:10?8[Ii^2MpA+*m5CP
M8"l,QT)a"51.A2?SUMCFhHWr*-(H^?I23i"nG"H+.Q)1A2Z7q?A]AC)"Wdd0-EZSpr8;As"+
p\T:T4Bd@cl>0(8+^[]AhL*:E<m]Ag.V)ao<e[#gD>(:*.YF.)uWkdLK$n^;g-=Y-KWHK=%MM)
Z[:9Q=e%\?^-Yj&e&o,0rB.o^T`/@qkbtE\HhplKYL!5rVPDgNTVtY$8p]A&]A,!jp^#a]A8qE2
pgf%(+8S+S/W>FN+u=G-'\K(<NR1mg+>BXQjT`M=,M4=-h\Yg?T8HoGa#F`>heE4#)!>h-4#
*[bb0+1hpP=?<BUq)'i!!,r6]A\<9+M/ZfZqJhmfnDg^tsEu1?!gd5ofVVp5#9;p(X>fTD8<J
8PsQ]An:>]A<*Omr"eMq<##RH?GoJ=S:FCI0:$TJ?d`C-_JZ_g!Vq)*C,MOE?b7RHP4b1J]A1$(
5o.4jY.-f)MH9\]A3$P-@2TbgNW$%Ib3(.`\5I3W>hJ3->(%=PT!eNpHOd;6:@InC-5M6Xm?S
UE>aI(rX*=1DUCfYi=R'j^il$Y%DmV6FkJR-4#ll:cXRb^LPn8u:pd_U8!)O[%(J6+F@Y^i6
ns<5"afaf)hhr>A5o=c]Af_a7[>GMbfk8aIC5a#I@`jbZ:kdb$''E3lbL`i,\Se%Qfj;VNHqj
a``p+KXu7]A1l'Ga2XInnrCkGChG'e@dQA\%7^3H+(XM0s8*RJU\BL*4T<CDo%?m*JCcZCPjj
aC7h%"=LqY;F[O[SO'f'M>Tp3.7W);%e1>leO6pr84Pp,;M`p3&=&B3H?K-4Z[1\oV(\938R
52S>B`"Hj2;AqSAR8I^HIb]A8:5>`BDb+]AEJ^!4X6pY:6%_V=_J"cpk2d&)._;``.u)TCBbPn
MDW'FR\7q:$S]A)XI9%^0@Qm7PNaDln8<Q`+KZ4/ab^t$niB1\Y5kDD0N<,H0[E&K5Ih\k.kg
S9V_7OQCKH)VbcR1U3=]A<PN\"utIohGpY-J8$D3%\12'5*VpM_)k9JVlGD%)5ra.kG\h&E8+
"=g>=<+9_rNcU.GLPU:na[aCr?3IRjO8qen[qXko0Kd,amWB6(o14D3Xg78\;1`MR\XY7+XV
KgdYomGErJWLlH2+cl*K8P6MsV=;T%d1@lj`!4UM]A5,F0l@$f*<XVS0Kqm1[=+8iCW3u2ZU%
WQ`UM%;3oG^rDDcerZsTecuXGD@qU:t3G["/[I!n4q]Ale4F%Q%hNhE#M+878?&N4gjPjO[;c
)qn?b-peJ@3,qq0M[a'?sFKs7du<M\9+%'douG-f<(b:/T8W%jnD4Qqi6$IO1UTus6OOY%"V
t`dM2;&cI<Q!Jt8^<81)fb]AF?.X/(0t)<#!fr;EV)`1O-!rR(T>J3#$BJ=ZS!:,o=F/nDe*7
Plmr]A0ri+]A+h":0O'AO[^DidVOohkj+bWVVW`<Zm9PW"(c]AnTbmiPHn-4&PkSdU;<`oB"0<*
WQ>l[HL:d!<i%^>Ir';"oU">@YJYQR>G'b"bWC7@UMl,*[:7\+`:C1erCC+7CrNM3@AY#<Ej
HF.H[]A$[Is8akJctot$^%2IU1=8X23HmmM.T>VlPuBSFjD41tP]A#i4\Y:cM]Ab?T%HbUI*/&K
;`&BdF5YYY%:tMIKU,pLCsLphbgEY(YI2Cij]Ad'\T#p6+^7L"re<fP<*kUL[L%t5[Y<,AL^n
i\Dhf;&JUP/Tc2qSRFOeSR;/o3J4Lb!mI3gp0"90^KeF^9kahkPAoLOn8oc&cl=eZW/L94Vi
A#.g0p=t^*b3%ZJW56i<,J-*CBhiM'A)k&'O9`kcW)2i#Xbt(F<^2T?8j-1nrPAPUC]A=0S'D
8O3`TOBG/PJ#:d3X4,?2r>qVku8Bgttd`43C6niZ'2f4hAh"/Fqa7W/3-_\@@OJiVCEh4iW9
>cY]A^O[a>QbE?e.^:]AqUW$;4Ilhp\p.:<7l.N3572Z49"ZEnY-L\_%<K1cbGB*uI#q(@3g#r
qPNN*I![u'ocP)#R]A;0;M\no/ie#G$e<3d03e:QD?:=iT4ZutV9XkmjCSWT:8@mDj8M%bV/"
"<N!UmTf%b^r0oZrUJL!DF*@smT\#E"3?^%BT&Ol1j_hnU'U&d5;GZPhsc;hfL5"5:+Vu=g!
HP.gen1"8ja+hRclQVW\dH&nJ?4?gplEOMe'/)3;0%Ic)ZfpB@QBBZShg3sK35R0*>N.rN(i
a;Rk0n.#L%[s-#C/*+?8':Z/q8m1gXdjXrj>t1s%4oem=#06rioTY8,gQKRd+Di4!+Fn5W:d
hTlL*JPSR\ug=ZTUkZ.lK3hhK\>W'g/Sn')3P=93Ym-1r^.e`M_`qK&skIUX(R/,#AgGf"/e
um>]AjO1"kgVnk%Q.[W]Aj8"aU&DLPn0;<mN"acGNYU@7>oV9i>_BspiZP8mA8O':\WuF8&?6^
lGlJYd!&'[+%\AaW"V>CZ-/N2=13"3E[!sHRiP.ht/Ak=2\lWXQ7$*<>$<N]A88GmNnucsd41
9R3V7)bf%+<<9F@R#Q$#WueXB4r1Mq/Cs\K<KYV0.R$5a?3PRcf^l7Z>Kc9hf"K#4:E1r;?P
oZ_l;7<eG-@:"33T]Ac10h.Qd=@#LB?DdWcq./uZYLup*R2#^=`G1=p,rO<1:UU,'>)oQ'"[M
\VI*k&@ShjOa/ImsX?17<V1/#W9Q`A^F"9#PaNE^CL!O1Wn>;$1U0C>!cE(neSkHG;.ceBkA
ssTU:jcf\3#25AN.ENlSY:TbqEE[bV>*u*RRJ=b$6g8m_g9\nQ&HNBG)VdI;&jiZ:$^ug2C=
W_Z6^!j.Fg2X7IK7la"hh-N,e)O"LX&.oF+H<Spd@[Qa,"l.nQAPPs1@+ch]A"F+`cH83'\>p
^oJp;'%T8\,!e"3>]Amb^%P\.^M<%_o`Pq9P[P^Q#?@*TCUI#jlK$7TY\pB'.__[FA2WnmG09
m3VpuD-[UF+(YRI/61g[Vkqll.]A$IB3+uc_!D-"UKNa?gubbrPkjC8W-'calWu>-I8ph;?Q*
&m[KogVebOgM+XsefB$a1FNh`&PP3Rq@M(a-s$rW`9=&OD0mI$@'Vp5NIS)7%iA".:'A@ksS
0Z1]AMM')g20)-'U9nJ1rM6(aOK%=n7+LrZ\>9r<S#'+N;gf0jZL!b+O]A%7*TSUQjQ$C,k&u9
Eah+aH]A`c-_j6?Q+$G[ofOQ,MSo]A?\RMe9g3ZY5B9WDn<dV5PP=,Q$q6e`A4#p:M'S(4`VkO
gFBLEb^D0XWq3L!%4a\P:u\*'^D#T3+H1`]AQ93BM?BTai4O2<Sl7d?ni&G%e4R"\J8jP)eI0
pT-0kF7ioFA0X]A#3+T.j1`PJofVcVq+lM3-$P#'SK"*#dt<K2k"Xgk$H.M,Cu)6T^ZCDRqii
'F&^X'*VsskEKoHY0=InQbiV]Al02_lfi-d!6*Ch3f37*OQa,Sn):iI.t3$3U%q!"Y>$IQgTA
mk@0Dik>2WW64_20]APIf87j$/u?tWj.mE+;Zm\EBm\:D3)KAR1_9EOJ%;7q!/(Z@EWBi-QdG
-LIf!kB_?*/Rc">YhU4RF),XLpVF/SEgHd!C<?'G3;&Mn$W,QjY`&mo5hg9GD(]A#YJ*EP?oV
@Vk/)^q%^D#k-ak'GB0)S675C:<cU>(SG"a5`SDk&9NDfl?*e!AKTK6,?fEa*gVL*.o%8C?B
pCA(bhot2l*3!NmRWFW:tV?CPpX)52-,'D"5]AdeHaHnHHr<kEom5ArG6%47g$B[+]AIkA<tBV
M,$&N[n_QN]Aq+gBIQObl&=B6=BpJ3AB@P_Nj=@A3SR=Whm([$rrZ>f9+US9i,\rJ=MQW15lT
F8n?8S9f'EP%e/c64a(*#BLt&.CuomQ6o&j+9C<Jk"W;l*6[k017X19kg`8e3ci6;"u?LKj(
LQ=*8b@+<FV\+,7S6W:OIrEh\1:q9fZVIj9:F;X%J)p;2ap<73gIV=fB>5NR58fAR=i:`PeO
LF`siW5d.oB=UI0l/nj.RJomZ%D<75RTZgWHnIfe^"F.Sf.F<=7N,;<<olYG;p^M\=tom.SN
i'B=spER8Nl^oa]ACZ_HL#t)c<;Jj-2,TIA:Wf*%s,u,,3k$!m@&mY[hS:\gHGB!cIi-7mR3L
dNl;M5/N+Jh(`*kE?En,qipH"Y`1t05C"tlK]AD^545Uc'T.1n#<[AT5K0D2tq2>lYF<Wpg(C
9,J)UZ-8h#`7IJ^%bg8A*C:%PTRk<B8iN'O.D_q=+s/qI;4+uUo/mf/u&F:$QLRS3Y19PZ,Z
b(%=X>Z.TN1bYPub`g\dEUcl<+=e_f,(06PJ#?.LU@D=__H31(G"Nmsh*P<3+hg/GMcPD%qa
c$GqDhBn0j=<@F&.FbLm^Htqfb"uGHWu,;IW8dt)FY9DT]Ab=cZb`Q^Z=fQ/_gD=+(41ZUQoS
!:VcBAVFc(r_G.T+S:i,6^YVfY0=?I=kEFqC[aV"+&a7t+[9[N;!fIJ8E:B`Uiu+2<QefdP"
'lpgjncp]A@;)!D@6]ALUs&ZOI:)=!Y3NQ@Ek@_Bp]Ag=q.$&ep\Y)BiUhE4>]A_**q*:1SC+6=9
T$<b_sO#;75eKM+CAa-]A@K)mID(*3Os24]Abk,/'T`IX5C`O*7aj&G_s7fj1#2F[YUqUN8m'k
lpR(4+`g\4uj2f%La^R]A:(YG]AB*fZN::Ja"==e?2"+6ZKK5n&.HYVsX7^4j9P+5BN@)bK&0r
WUn0bGqV%0K[0[3XN<"".5mSiIa/D1M#ih:C)0koosDnXI7<edCI]AS"f4uh!8CIkS3/6\.qZ
S6f?A=1%jl4ppR.T$j<o]A[@FlZ2<S=V<A$Cq1Rm>^%7`[Nn[Tp%WPh-oqd:B01i\H5T:mZ"K
\X$<EA.Yk#e:R3'Na+sqbWGrEh/NcT&<IgjJP<SIEYET)m[[*(>eAV[^Olcf*e>aqr_VQ`c<
dQQ,ENe\Y/lr57aDZ[1T_J,8*]A1;)R,/C>EdNLjk:Y'V@8EWY:'<nm3Oa'cFC8M0J8q/6$t+
?t8il7Es"ioHTeao8F`.ES!#+2*e%k`e6Xp0jhACl(c2@Og;51=>pfP6Il8l*[Cn.(HH):DV
*uWKPhu=jcEY"^M#R9d2>Kf<?,i"Qmm0[NfKerAIfXtdtU`au-)j4UEes`hgd(X"]AG1c^uqK
]A2^YQ<_(0#NQZ$0Q1<U/Mh([8s?JMVtHOi.MJ-9(j=@Od;NfmZ#d?<6faXQ#IN8EoTk8=YFD
=\WdiE;0'U^KhT+4A<j1HYN[Th:,jW71TAEBngYO_<4-Fk_Vr!>g.X?-MC-G5kp#HE,4KCO7
3)RDmOp!`Pk.H:QKnlup$O;nS=b"E8solhgtaa!5eD1l?(@]A(GtW$n>dS+7U^";[1QU5>p,'
=hs"&-D;gCJ:0jTB(#ChP$IUORA$s;<iWg\#'C,qH+*^*a9Z)u)84G/g"'ZkVj*.2(7=ZKM6
:tfl!0Re(Ue9oJj#\40-hJ97^Dl-T:bg!lu/-'?h6q[QaK:CL4GPfG.=&D^05-_\[pLW'+Ku
qlU,2)gA/"uE2IudBn&sGq77!$0+abjZc?4UFkLjHIq@.cn[/-]AiilO*QnDE1X&Q->$T5:AT
_fpK[gID!jI%5q)F@9Hpu>#Cp[=jITHIR7O=^f@@:Z<BfF_"+%@h=7%h6WKc3>)KFIUh5k>Y
]ATY+f[j,X,.5tTK6(uRk>1PFM?f7rLZ0E4Han?fodU*PQ@YM!CVd_1QjH\;rP;N.qn0_JdRH
?(8DIVU\Netk.Up0TT<fqd,SBD+d&D6*?f.,oVg.Fl93E\'G#5O/`S?/n_]AHVh._2cNK*eQK
:S=Z>\&bQ8qm"!3P$=V6G/Xfog2d]A4FBHWObF`V)%UB6T8f!JPhPn86VU276jMu;#>bA7YkG
TQ-=T%h1RG6i)PL_=ijCsCDW_JN_M@h&%*+CdX>2rG4G*hFR5srK>MIW@Xd;\t:dD10#pHB\
D>u6;s@Cf`keJEEZ?#_]AZIJ]A;4%RR4p<6]AYl2:JiWrV1Hc'1#7d3QC#"n`rg:V0KH]AEaE!r:
;pF^MRP"j-9Sj]A&NLP/0JTLcmXh3/qU#*0e0WS'*&A:XE?5%!SuVB4*%>'6Qsl8N>V[a@PCQ
T*?r2+0]A/DGE#h)KAFNKNN&a;:4cSk@jaj[SJ]AsE.a>A%C4k<FuK,MhN"Rr=Xfg<8nmgjt$Q
4j5ci.*1G7@U8I$>@B2eh5&O^"<d"g#%2Je=&j6E8cmA%F[kO^)J,9f!ENsU+2<\VC3T4+)5
W,(,H7!:/#W/]AFmeeZlO]ACS(GRT-(^]AV2f=t!HD\]ATZqOdJg1,&HF(k&_]Aa"a(>7GTlX&G]A1
K(:J[3T(+1R@OW`VCo_.<:=XgN<@C)D3Ijcd]Anuh.oWQU1\J=&n2=!2Cn:7#1iSbs/+5c:U.
Z0jLRLH2Y2N'n61DMWKle%lF#u%:bjQm<LD-"dS4RN&%]Ak!RQJ4r[CWB55dB3$uuk%c2\npe
7+3n!PS_tOauNj8?34m]A`QcD5qRqikMRO1IF<>R,:-mH8+A9&SjZW)$GV2(-Nu9iM/Zcjj8t
;VER$4]A^2AhQ2t<IW)8`Db4?pFFW5Safrh+/i1+@X[[#fI5\EB^i1OKfT,:!1H2:Ss7T.gd-
eU<_OeMKk@]APGk"KaiL36ZOZ"L:[d+&^=gj%/GbE"j#G#>4eT'/`t`COP+T&32FoA8Xh+mR^
[=DqD5QMmA0n_.hYN^iQ4M_tYqAQcJqTrQBo1)q[FX3uhBibkFdd=iuJM_t.pg_C>"E^t3Yj
uR_.TO/n74SjinM4#Y@b5?@/KtJQ_qTPENH:WHn4eI9N'T5krmF5fBhanOdio`pPWVN]A?MsD
f3cF5Qupj-l(5AktKo^_Tkqt]A:J;*kWYm1.b4U,;RO7VbSH6CNZS&t+J[NH^MnqPoR+$N79d
l;EZB`d7uMUmT6$dD3jBn!OFK+3d3WC1!nrbgS;'@7npp!@#5'Nm?U!OT]A.W3_G$XTRDg;"/
-^0f/n$\S?:e\J2kR"FcGX/9:=h&Z\'6=U=`@4'k?\EL88W]AJ/n6,q]AN@EE@8BM7[.!P@F6n
`7`@U*Tk>:$\J9oo'QRIkiiWS$,!h@2D=r^56VQq+'t0J/4S4+.&ikq;.ot2NEl"74@oOgM&
%3\t`)M$rnfSWG)ua!Skj/$!K+M?q25C%;Un^N\\R%,83io.E+t#4>OEH(I3aGaBepoir'AX
m/eU@t+L_g,\"b+[<0N67<Gbi>Q/\:Cu9*e_t7&4bIPGg?Um&A,M`*I?rP-(Oh.)JCQ3j=S?
,r!_I'/JcMUN+&Pm<]AB*ae7Ek!"\"_[[5F3aMSg*XiPO&:c6^6isG4Tp/#2>6Li'F]AuaWD4i
,jVnt(;%SI%G/P")"hhI\_.I/]AZ):u(:3A-\;iqs$]AE2SJo(mj\8VZ($8A9VodB>B^lQ2.l7
m8Zs98g)NrM#mU;YrlD/(_g!"sCY>/cARAk>jomY6Sr%1mRIRH,XAB28NlHWFR1r&tX`O)''
<T<&<b^_g;3*?.R(?pWPGNP)I+5T?chUUh^fPjVgGk;Rdgh)eJSfL-n6,7lWS:!+"hiiahcO
\^n6F&H&rMGPjb8m$7D0"kjsgGOAC)nO;)2fk1B91Z#:h.cJM&b.i'4N0<Wa=pJinBRG_e`Q
LcJE]ABlSA9dW^T*541rBHp5l]A`dq*$*c*Bq52U?u5IE[:2e9C).^/s8n5KQT1&]A`pMVYHQ^F
4-Th!^+E9OhU,m#sGJNu@6\?FLeN.;9W[!&_bh^hWX!r[E?uW-S3>LuLNY*0>j7!GRBh@VM3
I7:kCp&RG-n]ATiHob6A^IF4;6[i:L!I]Aukh;/IL>Yd+U>T^>!p2a)$A"i<W9nPCcjEXP9l,+
)-;B\*-*K`$"P%e?Q5@>Qht(\3DrlkjOjg^9u-;,mNq&QC)(X;0"n'6'_*:J3@jEcC9#!a$L
-fcZX&T/fZedR?-Vl?Zk^W&Wa;6l@#bFUM(dCU%5@PiE\%_]A@sI2`)uD0(uPe^q>18pl+j_X
p%`_P:6In;0LZ\7[ff\JVPdV5jp+>8)CLItSXf*ji:=p!7iHC3-Qi"<je`hLVM'lNf:TA^k)
5pu6HAGqBEakGF1NJVq4AJ3O(-H3N?=Ji<jZq``O/COYWEu^hR$Mc;C62dW+h4njLYJgd9[(
jbE(HN^$.B-7VEP&HiBcY`ZFcHm)N*%fnN>;?hr^)o^&I'^>'mS5>SGBM;T,35gFlC+ts)uf
iB3nJ^Mb[CJ4l[B)lP;!K_]Aq7!\(fI;9$p)+e!%GV8]ASAZP\sXDh-*1(_.s>0t<0T=QLfg38
:Z@W#:tXC,t.X"MJJa:fBXWGjBlQ#8;O\MP0)BUfO,I3[`[0G/I0&C"cC[/J,h@U!LFDG<lc
@.TT#R5>DDH0N2n\htegHd=W$`PI#>CTVnukTp.<Ak'"T*,9Kq3If[A&IMmZKH@"*=sim82J
s_h"hTbd:jLU;T(/Woe0\cOlZ223<Y_)Q6tWdWhpinl'*0*Y/qp/"?_3d6XH+$+%AEj\F*iY
oP2a8m(?A,/hKoQu?t1`8f'?,R@3>@WSES,`Qil?jF(?Eu.A.haTeP,E;<"G4d>fi>f2IkY!
#=UK=[7F^,HT"6#_q%#\J"s3Jt"8p.3s',mKM`eRbH#UfSBm2s,>oDI),f'!6".P")ss)OPq
R4#oK^gH19P_o\o1ed'Y'M16Or8]A/KN0?C56qU:gMOVeG`No?o8D)HTD+p>.<uYHK6;B,ldO
h71-`H3qLCN"nS_`O>Pl%,10@E*Nn-A-f+MakU;F+oN;&9@\_>&*Ul<UmZEL-rZ;$&1.4HHm
Z`_!'8.uP*,d;Frs(P:M$T"3FK.Fk%=tXh3lnE-13Q>h04&d_cl*r`Sm,AqMRGnrP6(JrqmQ
'X4GU(;8)$5iT5=GISGIicL^SQ9$U6J3oSk`*!!=7?O+iI&G$M@G.(F('.icH34Ks!c*sce#
B!2:[i^mEDkCUl#gF0PQ8Rk#TjXW>EhH"7%YaVH8&bqY`BcM\Q+):RU1E5kNQWocCd/h2[sL
c5.h,\-mWI79&:q:Yh>jTAY!`(l:rfEH/DsG*og*:7jr`PE+d$/$--o8Joi:S`+b\l2f^:(?
OCDIZYUUX$42:[12s'^58.pF\-oNF_/d8\.ZVa$cgQ`SP-I@jBHI16#nJiuiD7gCuImhu$%7
AoqS-tB50jEI.?X$80k[YX<.?(crZR0->K3?IT![cYC%<H]A,cQ&4oV+\.Qb^&m)[G(N8!"sp
'cq.SDIAoAVP5oS2`Og?3QZ2!9'OPAD-3i.4mNCs2[Cc\Q3l12U!oRk4^1)YBPd9NI#J.C/l
Ua8&![_:E`dEtdOpW$=<:63:1F3*FSDdk4j*pK["R^OK3#rH1GkFN/C=Jk1QNfcqU]A>Kbk(u
B0g4%%IU+Iq7TVI#V^pCp/iB1M2>QufEi+kOu+`P"`QZhkB'aX8a5XLL='U%H!p5p7`C1r+!
s#Ln)oUGl6UKU\bR\L:CD6^82)A^m('fX49%B[Ta/n5W3!@N=4*p5c*@;BJg;C-4^ZIB^F>.
:YCY8!A=Z.jgiJDF,S5aabnpcJc?c<,9"KXB&W%.Cn<=EJpnZ%$uF.!?te!?e`bDr-3;&oM,
!j_YY6V]A3[3_u/8=6g"[^ggrZPK&'Tnq$Mk*q>Y4V[:)O$Q`(H-#asH9q&QLL]A?U)Tf>%"=`
lHS7\)(:4.O_<\%"i0V"pO/C^B(iD.3'[d/lAD4r]Ajq;-5Di1FLMV=E8,gO?nrp)574_-L7D
*@L4)Xk+DlF]A5IDp<$H":'OtO`M^Ef6s/Dq9RUCk-!M[dl\@)(W$kqj1d]A<f'3q^7'kK[%sW
Zu0;0Vqr-Lm3mWVN[*^e!08p*olf$HdTFr8@EnfSg>uFq@:2AWi5BN5D;n9C^&Ca^+&]Ao+m_
)2l^)JVi9[-7P!fJT[$qDWb1B9J_"doK;OQBAkP<CC'cs_stk^2E'"GVB\0;+5s8QRufS%e5
,l3(.6n8[@9*+:JXL4K-^dTlg'[N[!&7M$_.$T>NJ<?$tOm'(eu$:>rY4bTH8'aqZ0AoH1Kd
A[oh^nV\GJWM,#I0WV6&PN8)0o!T3JjQ[Ed1lN+d3gCImU(`Ca]AoHt0TZU.FSIcp=eHA0H^n
BL_q-T2=,8`hA."ge^?a-70G0fZ>\ZC?1LbhC3\6i_7_(Zt6A4GjSdN&,%QJ,p9$Lb9*$B`&
"?Pl0"7rgYng8;VgUaRSH+L@eb!F_0*5F+$mf0X&]A&'14E8)p=i#/?t0aJYklcTf.YsnfEW1
^J_=hCd=?rZt#hf+=*?uY6;`JX/pWEd:\E%,E@E9Y,W7KdqW'NQIDRde?7YR4fU^BH?*)\?o
a!\c(5OgH`1"L;W>q-Wl'_q^lbr,W5\M"KP/9DPCiYr8VSA"`t770lB)O)b;O8N@0lBfpO;C
4L*HQ,Y)+B,H&2T&@Cd)k?2#+I'6(f>'A#OML?!$oOF6FP%X%lr#tCpR&g+2&&LNh(A<l=>`
g#*,[:[-/+2]A>.N$;lr*b;*K4(M0:&`O$^';mp^^Fe,4,()E`3A+MmJa1JKTRE$8=?)8am7`
_KE'`:R=QU&_rN,o3FmCAMXo\kq9n-l37e6%eKOHmIS&jFX=CV.>+1L!6iWhLiEGLDh]AlA-&
>jls2@<Aa>N/s7Ot^/kUR#nec1+B_hHZFlllK_>,4fGgE-?H%)tta06`GjM_QUT^09oCgLqf
+or_I.XEOPd-<#+5CUu33:.gAjdoKdA98q>9-3>>Q^P"W"#$lkQ@q$E-L_WQHSmjfO(HSZQ'
)[q,Qja`T/@j9!?4s@2K0T:u*1M:/lq:M!/7W0@,8c[tLgc,Tc!d!b*Y,f\=+`?!7UaET8`]A
4NAar4qi*i@[pCP>>Y\n%bGnX;%TTr6V+TL*_Y?`m:_ZDak!sAI`<:Uch/o>MCQ(OM$10M7h
dL/VSVI<Zl_HN3a:iF^"Z\bl#Y@4m8k2R$bIH?6t+,CU&bnc^g"SH#:+/%V1PMrc4N+I/IqU
Icu;)1ZN')X.jn^EpQ*mJD\m)Y^;\ZFU`bgtY"K]Aa,5b-=_7"7)c>"1ll1K,k[V/b[;h8gs2
oM^CW=Ko#)B#uUkFPmr>>d\IW)o1tOcT7@7Aln`h^e<U"S0s7"B!Y6"9[S'1!7LCp19G/>ar
T'Hg^7mhT.-N/u@;9;A1#"X)RV?llO)R82g<o_BgSiAp@*F(tVO*US;PNa(O4pkFp>X`,,C.
K2`Zs5iUP'V,^\RTV`bHV-c7_<H/aqcJG/RM0]AjOV=_Puj4KY-G7Ua6_BhFt6An63JWnihdJ
dW]Ar"-+8k.L:e)R3"\.*DYPK[WY!\r0-+gcT-(h.6b]AdHU??#9nl<nD"EDqY55_pB,\K/XD'
O^Fh=k]AeK53uR]AufWtOMRW/-6]AC8f[JnL@!b^n@^(o?6dm=2P/1'hHD>"B3k)c6Gpfc'r-fo
4/i02N2SnkpbF8%#n*P17[tMR""uYu?X38D,5n1^]A*Mhr_9EM$@3I-AGR0Rr[16,JgRJ?/>N
`5fdY6WhpN`i,Eo]AQ\+Lc'\*\Kg8(;8gU`Yh5A\T.HLoqQ3iQepZEK76[sp2]ARRt4$)emagc
kY>e?\UZ-;4pk%(gUX'JefZVnRXVW&+9JpS?']AV8X=Se%80a]Ad5,"uNhBN\Us5krN;66S0WX
X8*tAk2,FoQ$JiJb[f+QD"d692,p<`HJ4'("bYQM56a('P9ZWE]Au$:W'4o`",#4STmVhe`Ff
)@tkpY;)[i2[SRQ[nB.[H?0O=Xa]A@q`GPC3X[H(?X2Q[B/!V4*6]A$9U/cgliiZs#7ldRLS[i
W'\jXGS,tYR2A0's2L7HkMkBCY7A6-g>IV;grILT@VogIGno*UW9N9N#DhgY@*Xm/8=FZkcZ
u.,cZkh<G6ng<!F,k3.J(Z^M28&=]AVfWu]A%mui1*1liGGkh7t2-%8]AoMt#1DKnD%^u`cW`d8
C/N[U1!9toe9G]A<p!rheZ>+T)\Rd/,/j-#Q/Mc'Bo*j`^)[n7dh;P=/X8*+XPj\[SA0-;GWP
QpKZ]AU1L4Gf9Fp28nT]A&ZC"le)E<i<+dc9]Aq"?VMkQnK&OWsueLa!Pdm>T]Aol),jC+ot&^qU
_Bc)b+gH:u0&WWYOEDDF9B..c'k*:+oK;blTkN%cAo>`%LHrELu&AEh"k^?E/#RZ4?0Xg3d%
3;O4\1qDE:]AG+7o9UG6d9^K(6ML2ZOUUZ6e65H$'d@t_&Ba41Bjdt6Yg*aVVXcdcb_+5,A]AH
dsU)k:[#8-)8sTmpu.t]An`W$HM,$VW-94#Ptb3qP+=I3/"p1;oM5Z[(*j.YmU_f.=B8sK\*n
%-T.?P&W%LKhqa:mX.i@8Wl`m;ooIir*OJIe=As_rUNJi:#W%?V#oQ0RcRG'J,88W;Q#aiab
)496DkQi0*4*('k8R8Z/Z6b6)TtDk`_E=l\%75hQVWj]AAF+<oJ?'c%,p'(14>@eiXE[QDuK6
tZsbp9+IeD)"p>sgccNG.dRr>gZtFS'mj.IIM/VnY]A9c-e>;/_Y+-p9Z[J)`?9`^p-IUY&3a
%VZFo\[j4r!Bci<+n\t((0:='2hs7G.oJ*ajh+QtT&b2o*ZpWEgRa>P!%gS3"+1&`fTRm0:S
=VMC.JuIJj6)U2r<fS9kk:$/Fk3DnXCo.0?3%;-Y-M_##g3i]AL>0FX*G$8i:phHe5&3dmM8E
jD`m/3q[%;(u_J(`E-Fc]A*JCV=7,dl0(\(WYfP<FAPNG1?oH5*?M$en5hNcrr*W$/]A!,EUeU
]AjkF7&B7VEGRMqk7rJbiC&0I&;@RR9*>Meah1gc0CcUB8eMoSck+7urc8o`(3N--S)`i=gAR
&$i,e;6UbnM&MZ/kFp'di6O,TCi'Zp)*MhR;88NKT9AZSbUL[p*cLY?/ji*H*OU]A"P3B+e8!
frQ$+,gte"(`Us0AGgK"SFBm$1\OuKh]AJlml>a;\S8TG&PPucD>?ae6Jk,I.7JDOmZrpUZWj
2oO]APq7d(",7HZnf&J\QCI)s-$eSj7m5_/ZL_ui!k<S<$^G9p^4lQ$*J&.<:WLX7Z?O#%/uE
P*ZrE"mGU*-QHtb/1^7]A3+JQJ^j7f;i+fWuSU6nXGlprkc+SL@?QLPAG\"\a^,p.p<4k#)GM
3jPiqQruVVY=pu5GC-`#ONecp$icUdNb(+SE+[lqi=:r:V[ooO?HmPT/UG-@0PF["BNAu0"B
6Iu8?RA]ANqMFQXSi_6XP5gE[7KjkGR;n>?PUt+4\nHLp+D[9:0G;tGZ!".)Do7VDZ&`Q7JL(
a@.1LgaRr!Lb.2$I!n/4Q?I'#nZ-#=Fs4<#%r^J9U]A!2X=SOLU1^GC+-lpaa\G\,elbLICV&
e(jWEp=4K'!X(:9Ko-.;F$7]Ad"l9B'=;.EG2?gqgS1$]AVd[e6rcsba;r!r%`N8Y^o\%h"Abb
2,73A#CrR9$D1&oHDeiJ!S$+.HSj1!R`5*c5.qqc,EFnr\QfeV6sr]A8Ju`P!kb<-m._AC\5c
h.ck>IAD(*ce3-Lc\K3g,3OADE049X2W^ZUmi^eOf"!Xb9$:/n4d@S]Ah,VBM-0/`e]A+$A\.J
,Ts[bQ4;@(#(@_QJ=?J6%HQptiq,A?9fW#0!sV0</2U1O&P'A%SR&^u!]A(6WF?E\)Fj%i356
gb5H>5M0Jg4fISl9a(0L^i![-lUr5I\ku?GiEj@?=O_oR98PS!+I(k&X\n+&ZVcbW1V:WKU3
2$:jfamk\^;=Suf8m2md=;#\O`[E5q\DM+g[md1]AAI_n2fW@uq;f@_Rj7f]A_fY"c>TcjmGRO
IEs0aI`cr$`iY26o"2OE7DApGQi[:(lcb\&-(aZkdRjMnPKB0t7iY&4>.Eu\$7<OVG'[EX34
7^Jq.,HQ/(RF9GUH*l,20JM'U2)V26d&spXJ8F.(g.ePJIJ]ADJ?L$+ri$5:E2!!DoB9;m#<t
tRo:&KRmWV3=f[I36YZCT#'.JGgumWeR<k)2)kMgRdf\2qFT@QsYp^=mOJ`F?TQ12^nii+_P
ZoC414cXgjL06neI.oAT-A-r?,5Iq\liRGPZNWuOF!"Xkmie)&WI4t@H5*)4`KUg%10S"c%a
qj$b9/52;6L>T&NG.Y9ATphV8diXNGlgU"@5NS,+(ae##P<LYUYq31S/jBTHZV$<Rdm-;o*H
UY/m1I!rDAnc6/YGEHamh:C-'brp@.`_H[[kc$9iq(%RVbW`H-Mnadq"cLpao?p);UIa<>SP
Ls2IgG*%no4V6GT(P(kQpL]AVO3K[G$ft<NCZ<Ab/'&VU1q]AXTuY?ou8d8ID;7<PD9d)MZiAm
S.@3Gi<)i0:["3p\T!O?-mYRMX^eD^)SG[gHP;/RmLXYA6Z\Y[=b4a`':9IFR64Y*W$6(<j(
m0=3+]A@5"6fR@<*a<4It<R^W!sPIRdaQ!Q;lj/t(Ym&sc3\I$LMQ[:kqFN61ATI/4<Mld\R3
]AHc$BhGY%dB`F*&[i\9Fe>]A0k*F4T<s^]AdgcB+/F0M4al'&*Gpp^nf]A0/AdO<s?Gk>j=!G&Z
&/hU::Nn!3rej:HmQf2;%U?tHLtS(49K'm7#qZFG6fPdOBNbrY(\qL$)opgS^?:i"!B5`!m\
*L%1=?3FeC.Z/%boIi+o2$p5=X?Vs<DdbS!?S"Yf;PCb5*9Ya4<GU6X2elMDIk"u8[:TBPAC
X:BX78ZJlrG$N_o+(5WSS6#XX]AKq3_efu#8c%l-7pKRiN")'jh,8`%$L?B"APrn?5,"Xk6L.
rV@A09\'oGkH<aD<cK(FtTD7]A6EMdgB^gkIC0$SQF6/ee5B%s5eM*&7Xi"VNgq[`THp!(l%N
ki\_ZPbuc=hd3,c+0rWVt%Hm[X>m"F-P[eb:'#`(74$_?rd)6LT*ND%=4+eD]A^?%.;rR/GRu
ojrhr^Kf/t'(BQ#@IBR3'PYW^4`Ri%O1bdhsRc4IM3\%5U_D@X<]AlX5HSln?<q#$pGp:+;^"
$*QP,k_AHJF^0^]Am.+VKS'71((%A;)5Mg.gd.t`[CgjU:>4hE^0o$iRETr]AJF!YO*Q?Rq_+f
6-r@b$FT9Bd>_h]AQ"+QD1Di8#B=PT<C&%"7(Q0.9C)]Ac;+*-L?g*TOKoDpg'>*&\fW7Q$[2.
\D7cV2G[TO#oWXDK8/c"-_9V#&TNbrI:hn@)etGSIqbk3?UQI]AHk^D=gG?^ha)*![Dd$LiO3
s3A9p6cGaW<ML\6(a3bRXP`(/,caq:\f]A&RZPu,[aYUX+&3V9I'Z@>pb&0g9:<WFO_S']A-=)
(j3A)e$jBH?+]A3d=$&4@QcP43%oH6'HNK\4u<^V/J$d_oq@PN*)"<,%bl7d#\q)X&oTgqDa6
;QLSn@&:Voe8In0T6kKeCC$s/+kq23(clt'K:"@`CKoh(=P[4q7sJpPDnB_b[7Rj(H($;&7h
)Q:#%]A?^AG-5n!^BZS:_m,5V=ujDPdQg(DDX44Wc%$HU$#/b%sHA@r@@9iCueCBVjj"h^"3/
5$CVu0T=1RU.0NdXjfH_^&fopL8KIH^9k\k*ctX!Hb#1]ASD4=q6DP+g$<00tpaD7!Rfi7i9]A
pZ[5TXhs4qW>,.=c9F(;mo'D\juU^Lt)^'O^F)$V4(HFeNgh)U<i/ci3(J)HcPh7i;+2Wk>h
%M%q;KmA&hrfa/Y"V8Z5%?hX<HsR1h"FHnq;VD(m_X,]A!62Z)O'?PT%,N*1Yt+s#o_OHYfm2
.oSd'F[5GD6JO0XD6`%XV#765K=m1@VVf$\P?HP*'3Z,LCO`(1Xr-8&bke%&<`>qYhEJ:N:)
b4dO%K$&$e@@FQ]Atn/*:Bn1c^bLBIf2<LlUhLaH>k:q6uWGjF!E3!;WIn2_N?JNX4X'>'2s&
^@_9`V8U;Y$\d!V6PPhtbl<5_O>3`*Mm*k%Jn\Pd(_hkAGm3o%k_g&(@74pZpJ+Z*)$^@!K/
b;1MOaF3Y*llj@iRJe1%YLiX/DJ+X!J'.5'2Kg6Xj?kDDR0*ZrG"9$fs:l`!7&q571jQ:\XX
Nb8Kn^lq)Q6S[1V.IhJWn5ood1rL;!mQhB]Ac#P6g%KG5I:bJqD!D.,]A5,<OfnS,QG/e:4t3e
;dKG,`j18]AjTQaI>G*s+@YCK?=4Aj,=[eel!3s_McgP*%Vs[00B6j@S6bV-4QjTN^AXG?`ff
mZ,Gm/Cd['3nL^HKmDjRf?dE$B7I4LQ"tVC4;G*5T()X(3idh;L&+"\!7jpr+)qAYRu$+lB1
<Qs`SD2'M'f8q-Y=itQch5tlc<b2)YrV?Rme8LZnb/\B&5Ojo_W'b",liNV%.QL`qfoGH^%S
$=Y5F^i_k>se%a<_N:[he!+S.,_,GlKSm'cm=V'->i4b!gXEhWN-BEO&DG1=.AqK!)klt8pG
J!]A#G$UebqFq;tZ]AGj8ub%Z<h\g0md:ijSqmlYl/4+m/Vf$:dG-H&qr08b*9L5J)63&]AS\u/
_7Ue:[046`rkHEX3?mhb1+Ins.CAWG@B;hY'%l./]A7B9UHHrtd4U:0jb+\*o_gR11=hj^h:=
bYdal)36o\A#Io`bjU\gCa60KOBa*;3G9>,U5^90:C6>P9Bt3A@/;!k'I]Aj&l5O>sCJC4W+j
e`4gf5:?bYC<lS;W-J4I!^JTQi$h,]A^c-<!7qR-C(W"k:pVipkQ0;\SRk^tGdFg)!F)tjN>5
6=J"/4rjX:"'%@4YN7n0<L8\"BA:&h$HTgDt7A:V:>;5r4e93S78@`_b>Io(lSOR0c\KIoTi
0L1)-**fT69/a]AX"&<Y11*FoB*pfR)3or5[%Lm#@P<NT2dI*-2"VYjYEo]Ag@=CJ:72(0q?qH
\&AefD0k+O]AT)bsg@,%rgje0"Oc2#fpTU"0iNUe^?Q,.-09Ze=kQ3gZ]AH(;.X2]AV>$i.Lo&f
Vi;079hn#UXrO2A5mF8m\<[rA75nA\#>&BBSVr%(bhJch_T+a!rKaq)AJern2e?Cpl&L-i1I
1\#(G>M0=d_.O\P._,dmH)h>d-o<Jm5qq46trAT+1&jBn=3T!hm[@blZbh=t[nAoD`s6=["<
RAG$(J@W#a'd\p_JF$75cl.sh]A\,j1nYu@&8[M]ADCX:Xk'O9jpT=.n-C)."0^pSIgfECPnQr
\[M'>>6Fn^uX8mdVbZu-ZT;d$M@l7p`d0A>!p"RYpg(=V/nQq0;R[cIdAraOmE+U&a7rAI:h
ZN43a8E]A;4d.*j]Ae6s";6\n%n5r438G3"mr7J3jTmiErl[hm5WP18=,;m[T#3SaA6LX=A@&K
2>V&(ZuA_dQ%YOT:s%.i>kqU3J!bE@3b+3&i5`#HZ:YlsRC$jRDAn+*[:kdL+2pXr=l82X!i
X_=bP[_847l5%tHdSC??=2sHYp`gGVsE!PB\4CkS<@%Zd9C>J`Y2sWa>QVL2Kr-CMLUJ5[qa
4b8nVY9q=Se?P0r+cLgMkbNl/-.H(A.+D_SplNLd2)bA)o`3Bi'cX-G'enhjouF6:O?Lh*(b
Xj&+"LcK&*/a.PUq]A`nm0T?#P\"&qdAU1]AK4+*1TD8:Klt>-Aie7&V%WT"rk4tc!\#'I\%hX
n;lHT!11V(iol78!EmI!Baf+0]Ab,63Z*nG#^YC6#BH%N.K7id"1a!.6'GmB+Iql=0IW"e7SY
"OsYuuMr]A?]AL3bJ=Yt%aH0Mo%g\iCW98@h&]AM]A(R0;4RDjo,qmj)$.\T<DW2jY$7T4R^p(?f
TqB(2MUtFP3IloP:[3=&]AO[oV9p4<]AGUAMOUP9dT>9eKI;E%k\TScR6r6lYMk6*L4^F=M8Te
oi(+)5B4ehd(s->ZLbA5iL[TKU4_d.-@ps/aOTd#&gdJ'fD.Z^[Z_jneR>6WNq[f$ofU;["H
^W%j_?p:R/2mr[(,F.ku(SJPgcKN[?\%jkf<c:'?&.c3S@T()^KKRgddCCFG*LidLVSn>nt7
C;'_I]A6<iUT+2dueLPs?Gpb`k/+K/&S%ij2W&*]AS2:X6(LOX%,o2$r"K(Q?\2OR7<6Mf[8IP
O0?KCeo(.V)7AjhuVq_>jX4s.0c8mFG\9qgLYNO>V\rd1(9qfCK"5B!g^,CuOH;bhpNDfBfM
sc`[eofM2LRG!@U1j?+1np6ui.P*!PWA&l4&iV,C[0=TC_Ha0mKJ#RE6IY9;RZ>Ennnl7jkk
\$d>^\c'JIVB(YG1En[Mi%Ql\8D?!Pt9kn66Ct8Vj`,$TZ2cmf\j$3*>o;g\r^D=Jk;[jAr3
c8s3mn#Y(ZA(PKmT)nDY7S^oX0F&T'PKdZ6+V6T`AR?4re@KV5`V[eYb&6KdfFHmuhG`,6)A
Bt=b8)<BA_f&GjnoLj1H&]A1Q__EW2Q)0JL=[A!q1k\sBL(HFDcDZ.nC)+.ZH+J<1S^mjsmb@
K'DaK,Y=-NYIKAc.PW(Ln[a!uLIn2'IWcQII2'rcP.Y$[,53IE$QC_DQ?fe*o("BM$a@1;IS
OgL?=EY<lV);"sd09D.?_#-_FgQ%FH1L(a^[<5nk1*Vod^Z=XptS[p=XMm:Q-D>-H+b?4f=(
2C%a75_aj#NTh*&"Y8Jic#_B+a1/&HpMjGjI`Wj*'nK4rS:mhf30G-K&5e@Nk^2!ih/(%V`N
p(\ia5+dK)lS7*rO!M2I&*Y2B%F;lnlFoG_OcD[XV]An2Sb/A>&B(70La4j%NeZS<?P.N!RJk
An(stnDab??G6='q01!CWOo_uQoGZ.<K#VZVp/KERijmk=Tc:$-nku0;o@pi@)^)qRgd%7)+
(lI_'JeMCXEV:io0pa?:%=(q8K:>B&kj(+m5?Mf"8Y^`h_jdhr)u%c9/jp_ZG-IFN&gMJO.i
8:QViio;Q6/aT"k+Z-77h]A?rXUQsB/FeSjaU1VpDpiCFG..((e>=Zmam'&M1eapi1HF8fV$p
)EruM6-ccc]A"Nn%/.%(l,GN&SHJog=!CK1J*7Om]A-CC3X:bK@Ym7-q_Y;%M\tV^eRp"gd&-3
D)PWDD5bUlj[;HAAPAUOT@T<j'<Js&*C1[u".a'EqiA:U`J+#Rrkpdb9M32Zc;kXNX[9OYl>
3U5mJHNIItOc!,bq]Am#%<L"[Uf:]Ak#^U_<JU29FV+if^-3>Mhm^[Xj4Lm?mudsaXgCFfN6fD
\'.e-M7u@f0'>mgaO5q]AA^$C/:ENC+.\]AEeDhjR&>qeB2!TF"2?"#p`(ECI1#HX6l^mOC^Uc
qr52l4,hJ7d[-,e9fTjfcpc%VW,gFHiC,^\QRfXHKg>U-;7mRI&!%OqDWc[O1_*"N)GDc@nA
Y&qDf1Fo2WkPP$^)Fl'ip0qPriKma9A=MR7%DKa(US[ubO+p[$:BhOiIKfM5%RFL0-e<)RZM
Oh#LjPnj^80UNeOjWM6$.D.C[D`U&N(SkZD&.3)AgWn$V/)rXHCB>mV64+P)e7Er<&C4e0E?
9iK:?O&:$LkVg&PeD>q$1Cn_Roi2Res/Xl-j-ed(s64X:O^"&S#SiM,mW2%3<:3_+D^ikPjZ
[1c\<Lb8S(gmtbcN(5<`:HVS]AlL7\]Aen-L1+]A/O#lk1ogb'u\'O79IbgXBfDG0f*XCRh<NTJ
2i;)E6;+6"'X"e23(o$0?3[;j'/dk"aFHk0\Wf@dBGsmmhT&G$EJC\g(&ifhHn#g]A)5R]Abg9
//LnmF?cK^)N9\b?g3r:>r+7j()JGhK?F%>pW`SVa-6N7GkVN<%;=W:#2dCEUN5-M`E(8fq-
.XKP96(qb$_CR2T5.g>9eS9d4/X'F3Tmj@6,uiPfU-7[<,50;$-7^5P\Z'>8d\.Y%kn5g?Y6
f4\\Z"=(*=9E#.6s$f#1C<(QQZ:RP@<p]An^\b2Ek0f5B]A!#W'S+%/h-VNmmP)3_/-$pi)WIu
.h$*MAM[Up"<?5#[DI"(DJdF/0gor]AaZQWKq7)kY_fgl0Pg;!eBoJPbM:k[><ZVc6$hfo-Oo
H^PA&!nd8c"4Trot?LuKrh2H^sWYFhq]AF56V)iAm14c`qG?<X)Y=O+Q-gce_^b@J+,W(8'/1
9P"E(3!/jUAI<7>t^"".uI;)5'B'=A$2_*]A55a4/2qu+;?o8?!bQ%:=GE$F.Y,ph!3\d@D_p
2Gd/nI&<+bC<L*l%rf=%`ei#V92A_k_&'2,2NGuDBhi%jB8M$`4!gq'''=2mWts0;&b@Bbi=
K5@MNlIb?,<?-RqGnT(\(i94lpR$#/R%cu2Q]A8.1jsBbo!#sfbKm@HHg/hd4FhJWo)K)DO1$
EE@m9(D*Ltu?a(IX,Sq@p82iVeg7Q/mtmel'?AZ\>&g7Ch`rWsHaXiIop]AA"%nCj"B./HB]Ad
i=eLdhmB2>gPC_Ge`kD8Lk]AZLB<6Cqb^<M:m1e:*F3Pf0YGHj<$WG^Hi0`=lPmUi.5kSQ$+`
i`dNl"]A\%.kPg(SYrT\gJM^C]A8=)k=UYBk7%IrS?o""[+8jIFQ^6R,06f2OhtXSEh>i8s)d5
;FpM7=RjR-ca,"GR9iqYfY4(Gg\e&\B8G5H>_K*_3=!2AB'4k/Y6YG4YFhhR$Rf22i%:%eP!
\!./7eF_j4j=]AcV#7CPj_[GoKP7u;q`-VTU#<.;^G)J^.!,D8Cnhob`0F.7KJ><M3EAEUS+=
Zej]A!uHa/ch4e-[6*]AH/J:g@\il#GWC6MXi+>X=3N,p4J1=[4]A:-`#!9gPJ8%*^MkU*/:Ssm
>m*\g>jLCpeV]A^Ll&c'$Opf&Q?4'k5s:?'I!,Gs"90VlT.%<c/^d^5,APL$T$G(;e'R)#e.G
;VNY<T68]AD+gV7qr/hc`.Kt=6@ZY_d'Pr'"]ASPf;]A_MpX8i1Qs4_E!oQ,B1W%+2WB)$#>JaF
$qE3l33k?kjnACPqhSmugmB\+gVgB0ec=8OfKnni#kA$gG),/TnS>7baR5iaO!!Eq>:Vb)("
#.i1YmCA?L#Ar0l&f,sJF>s67);MYgbPt^n!_=%L1U@Hb*8?cV1p$]AjEA,97V>jRO15k9&7J
Quim2AiXmFRkmU"A^U#D)9d\)WG1^osRhQ8&An1WOt33I>]AMN6ZkWgC%iDk.O6*n)3!p-a`1
3k?Dp]A^m7#C/IPq2n#SC)T!lT/>s?"*+)1d/?s!s$196W70C/).Sd&5H`pC=HaTTBrbmXr:H
Yrga35#ud\+ENpargc`QM("'kcJcT2CCM.njEI+3H5?=K#BJuVA'$V7sK2r5m.a88gV,e]AE@
q/MDF>BR6Pg9E4[6Ui1c_\d$KFWqoX-9BLe5dJ0[-%1Q.$//*40'!=+JJ*5p+<rD4UAo6;q&
gs-gFhC+Ps%+W&_kq8P\o"e'&g]Abo8KS1Y_o\Je-167N*gUHeJ1I+V9PjT'Q@5)B/R#CIIm=
<pej>*:8_^4=cKH9Vd`:24S*Vj#YO$J<s$`0bQQmN2;8>=\P@L5@<f]A*Zp=bc+3o8e&W^o!a
R\=D(<![pH`+JskIL>>_i;U*>B'Qkp^.4e>N9lMIi^&q7CRD9<cn=A2ldJ?qYn8[gm$s7L2%
1FJ*+@>1:_n)*jhB28bOLSB9G%L0_b-u/XPqLJdkJ^6`JBOYDadKdT0:2?]Aod[[2$8FY)LEG
6AK3]A2!OXD)3gpmL]Am/:]A^IQXbuE/1^S3+6R`^U)77$(r7eOB:)Dhg3"XguhVn!=g>c$7O-g
cd)6SJH(-,Z[YJabMf#ajV.[C#`e1dCTDJi-bM>iTVC(SP:P)_iJVjh?$Q]Ad-k)"&hgCVTYM
(Kr*K?8>&cC,@!X@)-Cc;nG5<R7Y9RluJj,P#C,R(Jt.S>h5UInq.3HkFt*DpX(&s5FUg?5k
bDU!H+'QIN%W\VD9Cc2-*(U`^(46lL:*<jK;\'o7;hp19:pZV?_'OL4'br;<WEpT@Pc>JmdI
i^YU?..$u[A0ht.8A:a.Y3rLGNA>qRLVlaHbhuli8dfK1+s)\!4(O,b&X]Ae2>Ws"J"D.L48;
rD<TGF^?NSHka0i6n$"2Ds-GFDJ4NkJKh2;(lG-Z\rkc\rM.'und%"N:6Mj(DVhiUoY)_\@c
!/"N#h#!8gF3BTC+4G1?)h50"6c=.toJ^TaH7W;(2R%?g@Bni;d.XCgh`&ZJ*[`:%/CMJ5RD
P#)Ch=cMqeqr;P2#4(d*9>VGBCO-c*\LS\#%gc6I^1O+IA*rc55rJrYn5r?$H.3[t$%d:<@<
B>e\,$ik8^j`GD*X41,d15N[?`'iB?c\;W`cH/DND:>$B<*obMJMi`3"oOg[e,@UmW_Xlm\r
n.jED66Fg`(p"&Dff:iC'd]AD^3gl-=bs5i#7)aSD\kMJr/^dU^)C,%`14%.h<OTsSd\D6IuQ
*?r#bNZNqi"WmB###S:X_[S?J:S*MK1A^<jtOM"0psanFVhGkeImqO?YlJJ?oj$i''1E-#pQ
H*@6CM;BJnm<\FIWY3Z0E6J5NEWMWGn,%5f#E'^0fBnrqp?$#Bs'Wb>GP\s8[6A$s*?[<;&5
taY9^THgkCq_U[?c]A"I=D)u\reKC[fSsCONIIu@+.dq%fXhYaVeQ7SmM3\c?,O\7`\]Agr(i@
&PL2X"o67psIj.F4htH5?*g-J.>lJYE4Tr\Yhf#/=8^82Wk20YbS^)K`$rZ*(:^g/H]A\o5W0
WNP.LWto2gI]Ae"`j"MG:&#8'"=<Y!!7HAsWr%/BqGpb\=tEu6XCqetG9DTH3qQMGSCd]A`iYh
76MW8Bc[bo@@rANS[d_ZIBFSiN14W.@Z2=V>o2:W+W#/<hl)-m7>>4-MNfjP[I%&A^@cX0j=
#eb?++3fuO3n1"RW1o,R_E\^(Bn-f0r&.N'EQGs<q+AJ@O2ck\,MW`YG`]AB5/V*T*P*)Y]A#/
kJk*qZbSkXJFYZoM^Hca8i9"N>PYLElrInYuGp!lfj?f1N=gA$mBO]Ae?#n-A&iA09lKuk54`
-2c-FP2boY_i8+\^qS-k(Bu'7BjfB%m6KQ?a[FN7:66;m<__PpKO!<q3/:6Qhqa(kDZ#>646
j(s3(ra>?GlN^c0,8u+TXn:]APkh8A)OGsO[FO.mr6H]A!r(BMS`A=!t'>tCq$=OMWZ*?33Q1N
n%^4]Ah[$?@Fcg(k2'^:O-,[,Z)LjF-&LhC@]A5`*n-$ng3U[YNHnOP]AFh$7kY%Hh?_aL+EPaK
^_A.,:t8>FZ<;+pQf[.POq6o/a8,%>ihg#0**UKtU@X)cqGmd)he?MZgn,dOX?\-r+*@l.j3
FiE9CV-W/CAn(!:B]Ar?_=:rH=RS"X_CCn?I@3<Ia.%E,Miat^#38$]A&A#3M-Kh\dod\:Dm=T
e`]AgIs-5L(1bE%Lm0*An<=..qbr"A[,HOs!5eTgDr;mf8Mes_rHgaS4N"dQ6W.]AQbJ$XTJ'S
D3Sb]AR9`CXP_K)TtKRUl11=E=8B[rYFu^_I1;T@RF%]An8gD67+JcAUbE!\3qUfu9/:+a+'#,
F!-eeN;H1Kbeca%b(<I6b"r!M*jm"]AE.]Aa@([=+aDSE`bsPOh'M5TKO8nqs=jlmH?b*JC\La
l=uW*JbdKG,C'aV1\aD,&ROsJ743^*YJlblE.[39f!fMXiQ#n`GA7>k?o;_U/j(`oF>>>hTb
j6uPE&7"ciQTcmWT/p6mu@dUggH<Jl7q&A[^,6gqt`[`0tF5437-!h3G*#*SkOe3I8hQm5eU
HY74iEes8&:C'eTj:Bt$JHmL`1lg\=7\FLd8pfo"[+;>,$%@at$Lq&_Qc0Blae6Ct4,#76h2
??)*d"0CI\b2f,oYm[U0`nHk^mT;ck(Ms%&@pOG&QKB_W:Y=P48^ioK3o:43Qo@%>kZV+_8_
g(TerQlH.`F,s(D>Q)E:M@fApSG:k"Bn5^TAjNi0pH=(A?_D'nus1jER#SXdq_OJep@lkpC5
On&4)(Z;3u*S=mI>[kKc-LeZX5,eEIS'ku%;Mlud8#+fE"42C_'3>7N=L^eNr0=@h2f3J."C
/IZBfTj>XpOCiG;fKAjUSmEL/V`^-(&P$%J@r,G/:4=N>)Q=MO#VJC:YZG>jI$]AP[jkQR=f0
fR?!eUJ2U8LGd,k;9l2*e\bO+a;g;HXeY5*!ko0Pm"j0=VW/FFds80F+P5l,0gC)$m>n[+$g
F?k1JBt`Q/O[d))&CR1euDfWPi)8UD=#I/IHBe058#d7)t/DD.b$YPAN=rILqV@046O'T(g"
jt6OS7cNmh-fI+%O*h\VYuDrhSu/j&W?+e@jkHn(gu*!8rq`Si'S#cQ8X"jAAWfOZl4\OQjB
3V#+8`BkRj@JXs@=5'3`j;'Z`J=)G_anrDT!p$rp*aRm7=ui'*oVuM<3OWe=6M?Y(Qd.%N2`
MVXhCtAQVjuZ$BB,5EN]Ac-L>ZR$pEbVEgK]AY[WQcX_cg)E_Uj2pE7TETqt9F2H\LtcS\-[C4
0"t9?%d7/WBk#qPMFGOX(A8R"h/3Pdp+/Eg/A%=Q1Q1GWlE_)/HFh]Ab0q`')YLTg8nj40f[X
'lbIa)d0.b93.W:8B;r3+=E>DuH2sc9_Hqi1!W7\/Y]Aagt0Y2+41!Bn@`Vp;k(o'c@5#ImHH
M!PP%miGC3)b0]A*kr_`iKjAOgWDrKeS.a>s/aT%(lL;Fp8oOQ(C7E0<N*e?j1j>$tVY%lg@]A
TENiF-l5BDFV=pqUok]ACH+EDPmp9`G*k#39kH&u`>YAp';Cfn2b-OLQD#7K>`6Vs99"ERlfA
mgC6q?QtjfR4Z&"GE:/p[!@-LepCct+#t-#>p^c%D#>M%me41"J]AEh4J]ARV@7EncTF?n<'YN
5nODd"bSnu;Jb)"iM1)%FOVbq8A6?$)R^o@bB><jO""rOM-G7Z-#&.4PQ"$>GhOcK>p?-A<5
dGAMq3n!pI?#OZ3a"1d]AqfQ*TcBHe,M.*=es;+?TP[i\hHsLW.bJFuQlu,0MgVH?.mZ@5IQ'
m0$GHXI4e+$@5V@E6/kGbt-fWhLC*SJkHH!l,)bjVXjcU.Uq+HJKm'X1J!Hi%5A1S@7@&LV'
LC7MAHObBN(M0"fONT=6jLT5`WS#q;^B+q'-1PX\D)cA+@j\lE[NfHZ6t4WMpK$p^TS,d=iq
$os.G7Au'Z?/BQ)PlEj:*lME&l[G^b]AfCCXmq&$L78ZooMFKVrkifdlhL+!1H)+ri?qjjPgd
%>>6.o$1=OcUdKgh>/8,_'+Y]AOoW,+Fm_^sB0_.\9-MOj2?b%Iis!A5.Xtl(NU^2i-:Iomgm
dafJ('LrkXNmr)]A"'X*2t&66\G<a]A=d7=60klM?bLAWXfM<,73jR0fg"B4d/@C!=,<))/Z$m
"EO^LYPk867WX/e(4QFLk'`A6._7tW-2fa1/R%ZkYBY<k@!57ML&-Rbj2B`gAL3!c2*-kA7K
8Hd%t+6*>]AJ;f)^Gooce2T&`'W>mA)]AJGR>>#j9bBuM^%%6he]A)d;Ei`BAnC$D/d,KS`<h=!
DFR;($?HS^j.:@G1'YOf[LCG(XEpP+/n`C/qdT'NHHGfYR5r%<.Dt7AVIW2+H!*e0'7s\Vh5
#ecE%BMi[@1AXGPA!QuQVb`HbYH*n-m,(%-`*E&bf34P1C(Z2DtFoKFsQV^e,h3]AFSG.7kL:
l6mO>*2AR;HqATZmm4`*F_q"s(RAj7CsT1@:1)<ZU^ScO."]A)UOtJP0\H=F?TPa#L7[Pio3h
B(:gV7@r=Ij._rcT[-)%=+C0-;#<d`'^.fIg4p1dlH9+8!^2jif=a0fKMP#GBE46j^:mX^0M
bughYCZmT4*"OZ2hOk`l;7BrW<YcdE)c29M17H/.M_"(Fabk060B6Rc?g:;4*]A97)c8QQFS)
O/aLi!g2i(aSW1*&C8'6:^9X1VeSX0opM.0Zk.)">*mPVAp8B%2;3Hg%b'!Ztgd+cj>(X*lk
o%5fc%L`)=@`t4=dPrKQo-GkJ]AK$AWpJ(?4*rTTGLa[kn)Y"s1H6#j+W(#cgn5reLmrR6n[1
+[Es\W5\]A.ef^a*g/5%ErahUs1]AM$WRI`/`N`XLO%o.lkN.34K2o!^$3?D%`hJ_t'sb#/<Q5
c/rBU24CN7fN[A4o)4%"e$%VoA81'u7SaHH8>+&c_4*G?kmRJ"VARi6$$T;n*Ijc(I@E=f=J
c7GHrP[mb6d6TnJ&dH=3c]Al9c^2Xd.4'W_t_p[#3)4^APo8K:1CouGdo6i8)7+;sm?'4OkjN
5AdMHts^NtqEfN!=%`#uP]AHI0RJ&^t$`C#e.G:B=Ykm$NsD=+q;PqJ8\NdQK@niqhW*@NPgG
k+Wn)/VXLokQ&^GTPf:aRR(V"bR&7Q)UGpE2S;FTp>*7Wh5Ka'1n[[uC^gtC/Q!o$8eIBj8#
'ER8-8+JDSg`/WHWP@XfPl_Y-nu(&o$h(&5pA[%AL<t3ps7l1^?C[E%"B&U+.rNGiU0EW-M8
\;cuO$2dN?`cd?gcU7O\sR!]A^?362n*JrE!aV0GAX0b)iN:(RuN.)jF!LYS5#^?AG.r*!PW3
C*TY$+=(f6.)jbFqCs$/gRpF6e:;V5R<$q.lcRL!5#"+#\cg&p74_2L;*\+R&,>_\0H'.%7a
]A^i!:P&hUfFBY4ephIbA^+4'lJ!jNDR=9+kDgJ'LuL6]Ag=("ibUNT9AN2*m(gkunMTmr-"aP
gU@QV98o9Q>2RJN:MYerA[Me4:^-2l,0l,6GB,i9G":CrS;E'W'r^TU+#E_jP?!G_ZXVka#l
OVf241hl,m$F#T/$uC7nL[A2WiG>)RCK#;`@t%g!C[:?dGY4@]A6]Aj2;>dlgm4qh]A<%mkkai5
NmJSXh+oV@oL68!?#>5=[U9W<&C_L*4*.*QOMeBk>rfRk3b/k@`k$XnY6E8"GG9X&W@\m>@m
gHNi'EB<#F;YKF$51TdHc"5'shqkCu86h92Xc-,!8pdO>gmAq*TCXU1hGapb$Hnub&F@e0=C
q]A12OrL[YJSej)@fonC<_A,?YTG]ABgsoOYU,D^Hur`g'05F[\jD<_:sHkhVljcc9$[XNCf0K
i\uHi![2ucLq3(<;M.5g0VbgDON`FsKEdjGU&<e_-EpF[5CLU4pZ,Q:Z;U(BF0.W!--8J]AEq
4([O/5(Wc(O3Vq.[@LA*<D;lQB6XBLaNhqB+ndT3tVf@P*92U2iW]A&"jlI:<X[)$FI5M7I2u
ia=cB;'d-qtt@4MgRENCVg63sn0k;\.i!P3Nbo?N]Ai:Kenk'J3&(SZ_Uj.*rs$!/YO3%5_4[
-#]AKGWQG84P:Q.NJrn0PJpGGOG<MQX]A?C@aVUsV:cp`r3cF77W)q'oI0#,A+198d&ISO8jqK
VE@gk8pu42W`Y^I^[gjYl>@[Q/[1]A`%D/JXFJGTjUK@,aZ?t#-#N%P09>L_ru/f\entnYn`E
rP^g%r^X?rk,JeRaX\E^PepGbmXG*6El<Y_K26+0N.sp[4@Xno*@o/T'2*u7+aZ2Zu`e0.qq
_<.9ZFn43G9fj*:DL36Z;"`fD^mk7"!7'7!,+h:bSRhaSuOH8rT<?i^d[RR[>8bK9KO!m\P=
b-oW83YqR[r?adBj6%&C&V@H^HjRdIF.go3)"%FMNR#Y1s]A<X*'DVuP=.CB0:s_FFFh$M6W.
L3i=&$D>)@R=JX^"$=I!e8@;"^d?A<Fl:g@P"J)Z`&)$TZP6NneS)5H#i@Mckj,*,CX^3W`)
]AA!,!ul\Dosli^>,mN'=Z>Dn6co-\"BcIloqT1:phi3FF.=BM0)F>2,gJV+,,.2/n)>hPOB%
<d3V\Q[=iWQEd;9(;q(2/[Z7hm+ndm]A;tEK1NB-<Mh8V7YNYg`&I6**=:X#@dFEbe1\jqPT?
F5;g>rIWVSdBEk(j"h2=("OEi&e>\I91a.LC^sD*OJZJ[0[5ZJ+/;!Sh#n^Cmh'5EY`lk;'*
.T.9n*sY,6?dP?DsQa'(FC</<PEp3*&6i0$cshSr0X\3o2sFI<ArX'_dm#IdOFN=Y?9eGPEn
\2RBt6^k/!;:FBPO(&g0ltQPCI0@?2I.&_RJ6$g$BKOXqo%NQ^"7077192t`]A6Wo%%"FD\8J
+tLAIt$a=qSBJ-"Wm;$m?lr4QXjolK`->p/3rRjff=m6MNR_N]AL([Bi>Lrhdq`<TUDS5r_H`
n-57]Ab@C2+qgtQ6s#er5^Zs"42U9r@Rku>?kM1U1-(5&c>#IcPp.mpC+e#]ABJTgQ/h33RCI#
?R0";*n%0]Aup;EhG(J"qH_G6gRN8E+*I!+SZZ6:Wd&#0h>.;,m$7Y*qGVm.;#q(#CR36^'cb
Ph!L2PfSlqBB[ZGOk\VGsa(G'KeD`RM)f#)Z;LP#J.e@H.A3culE=<u>!+LIl,(GcZG4&Y1A
+mk>\/6k[B3.2rj6'qlj"OWG5$M*N'2on=X?N+4%IFCc5;C?t%l.\JZ'Zn@22A,WMM5%!N9#
qJ'r9fkXIkt:=0f(jSWA*d66V3^IW^NhkglFosc'/mG22?TJ+ZA6!/EPGWI$+W=]Ap.ErH4Z5
DZsV&)WsoQ8Tr[;*Hj/[.T['$4L5!Z@4?d6O;epHWDqQH78@<p/m#dY_PhSBiMKY?tY>F2s8
;J`8)d3(-f!=RN>%rbbNNs`j[^=0'Ek[\Ji@KP1e6&;35\iQ,Rr4N+L@,#&GWaRojh18m-I0
X7XU5t[(q>JXZc73,<2"?q1'fi:Y>\$$2o)(@Ib*<l5)c]A0p)g!Hs%_d6JroEG?Z"/c:0rnd
4R7BCDh>.A<KX_bL_4I)D-![>Q#-(uG/ejjM%i:>o8S#9Rh-ZD6s2,icRZ\=MefNI5c,HZLM
WR!gfD?`.e1B#+eC7%6-=$.YsgVa7'^1$bq#Z$0[QWMh_Gq[K:69/>282gm*4kGmD/Gh'h*&
TPjaMh5b[</bODflNQ:#jcHYj`M>A:ea,scB`lNh;m-<Nneg#&efm2qL#Aq-(*V=/\>HY3#=
B]AmK<-8g^b\_.ZQL8l-7!<pH?.rhSTo!)]A)cXFjZELJB6h(+'Tui^FIs<jlWEpN+ERAXe>N>
4SHMlgL_[!?<<pp/9?SI*5StC#99k1WV*9je04)lYJA^>C#V,+S8M'G`CiPU"OM/LcKqX=jR
3@*(9G2BqYI<*^Y-oB7>97@1(U$SN/U3_0Ei=572jcLlh8HBo7VsL)</`^E#p!,RoRpd=S(4
LFJ!Dq*cC'Q'4+k!:FO'0uqQ;c5,gYu+6EhJeL#cB\K6Y_5#YP"(e87GX53CNXta_3&o)H^E
7U5s1"l1o;^pC_`)AC>4'jl*%]AG4NeDRpdh"d(?>>H\`uLnEF+h%sm!MSJ%<2)lmU0OB\2S`
X%5SGTu_T=NrD3!>]AT%]A(&.R(3+dW8t5NK[,P+8Orb+t?(JE"<2MeN@CEP_5+$C2*5\US_fb
iXm8Oq9`tO&(BZ;5$W.$<,m^A!M]A&(I<`G9NGInK+t(*:VMQ*KTi89=sMTtZB1*apfSnQ[ep
`D2u8g!d7.P[Uj0rf"g2IC\pD/FriU7QG)OKiE>BBOeIFEAefns(l^(9l2mG#f@Ccpi.1Q+G
*L[bmf7E*Y,hAYon&eP45n4Lm3t]AC(n1embF.IbDD02!M+l?GE)7*@M;rLBeqt1?!VORRsKD
o#*mmY^E*Zte3aCB0=W@qLGfn1Ur;&-r242:V!lgU\ls3*XqrUYa:/MC\is<`$RnspQqs6uI
*63Q*#mbIgKp-cWW=",U^h0L2Pp[aZ().&b[q7^`/sZgBVTk?npBCKe3U3@PHWOV/&a9o2fj
VMU)Tk3[8FLp<l-?gc:RC]AKiI1Fp5$j-_$EP5.iUH69SrN@6_CP8Sf:.;=g)+7]AD<'#bGOmZ
]A/eW'A>*623!>1]ALl3k,E-nU-72[(#h0Nh[h@(4g:T_;or,:HY#^]A4^``MR>1Q@+3f5M9;fG
alh_+@hg]Aec"XB<U[enIbSZ4l?ihYMW0dm^sB%'cKpNJ!g,<9OOBD'@3a\HXH57,h5bol9F9
%#ScZL+o]ARY!.&1'#33Uh<D_M=$[BiD8L0*ea_73TS_X>b?t.?cU)RdjOT$g*-&9r@Cb,-@K
OSBG]A3Cji]AYbu9jS)V(HJMR;)g-GuqH9+?HG]AGjHcU!J8\OnY!%3*ScP=uW:@T745oKc]AN[Q
g5D]A&t-?pC52:!>&KHq6&517";Wg^/=-!b&$h@L0]AepYnj3>RkA%2)c'ha6Q;Wjlh*3Z+7HH
4``j*@KT2m`<pr?eo#Vk;@S,-B$-WV.OZBI`HG)?l6/m*S<>4Oi'FffRVDG@0Ib%`lO"rU/^
9K.oH@'KXBeS"]A^:kL3rQ"hX5<:?C)MWNpbp@WVlkJUpNR@HLjd!O]AhOf8B3r&V_)rVms1DQ
VYjN&01>e;"J320;l;(!T@EK-fAIoE;dW3%_N9`Xq:k[cba\nB,:"*:%a?nI,.cSt^oJ%>E;
JU/:MP!:Z"R3oSL(1e&Oc+YY<m(%Y&E7R,npg)d?S*!tI6IPec<BQ8oR!c\H3"P593:d%ku4
1YO'YiEGQPQ?@DEmqA2'f1Z-aS!;I2R+9NWSF\2nD;?4/Hs[1sTbO-:8ALD;Nr)opWh.#G4g
K&cH]AD:=9up(:57P!R.c6+7]A=$?<b[oB[*4Z;FFXh45pk0WMiL]AE$JV^6foN+oaVaA1-6,Hh
(4iF-H`Q9::*"ZU$lZ<2XomHJ0:9Bd6uXBCZ33q%Kkg[VX:Z1Fqj\K&Z>^6X0GS"hSW'$BU2
1UC$=S_#90;;Dh4BYufmjIZ,O8QV)arnmg(A.fZ]AKiR!5M?U`SHC'[[-Z0B6Q=FN0'Y8;nN(
$@c^fu]AHP=lr^1o)m7kRU`\%1kaCn&sCcX68jC=[D9-4g!.UGB&j0)?'`j1G:`gbK\^,fFBU
PCn_Vm:bb\I^jfXoB%og)TNLdYPp+ih<3G>S@ZZL<#4HI#L3Ll[-(iKm=`[4!Q2]ASjU`A;>R
2TbEAWlV%Be!&4iQk5E]A._<HOm,r=Q5("V)c"1[H4!\g-[9->*DHf51mF)dF#X%,f,lsYuqD
X:%/#J9)>^;0SIO5sp2R#"WrrPE-9C3[7cZmq5dZHMbr$@jMGHO->haHMClXeRMUJRJ/Y[bU
2YBr2k0rC1p(6g2hH_#"?&]Atk0Yui5&LJjYSM+F"O4i$>b?2]Apfl<H&,h%6XTFDd7+>VT\Y]A
q.-Qcp2SomdP"MeN6YS!&1*AWF+J`_-n:Q7b9i*:dL*&2:]AZI;-kZcUGX+q[SCm<etIe<C/2
\hcOE:=;s!9t#+L;*CkDuKL)-XGBO4eEI:>u?R+hT[HNYoZ1$eg;\5NgMC32YC`65,hSE`8`
#He@R_\=<.IFMAk`Ah0u[RH\;FThX+-gT!g0QI5O@bOfZ6fe`Si5+Lb\%Rkq%jdLDMRFsYJ%
:BQ&9\PkFM51uZg(_P'"t;M.'1k8F0W1.FjN<\7CRWMqLc^#X:+rN.U/SUMTU#fTMKoPW"=I
0V7%j$jENU:kVlOaa'Ee.bf#prZllNO.P9POS(]A\ZReGs@;RN#LA[.seKPpn!9[f^fqf!"!V
F2*Znm7LN*/=D@mob)dUfb\LA.lGadQ1h?kn0ij(XP!Wen(s#WC&=HqGb.@Hj+QO_s&9p8XE
R'4BT(u@$d4jSce-m6o9D?Oeo&Q_k1R'^^rXdTFIN0pD;Xk8jd-70)hlWj-*cTdDZ.K.=ELp
Pk\Z`Y!_2;qKI&-8kIAFnI@iERnR.$n\3P1RUc.&2DfTh:uBb!p`k]A'=LeuNAqM"d<=XF$ff
mKLZIoV0A;J.O]A#RrnO9WVIm,J*j=2deLg+T]ARO,uB&lPI$VVHi[e1N(+<"H&7qCQ_d$bc4!
%c"`M+Xn(Z7+d+W&o:<:4_&aDYJ9t8#igBM;S8isrCN*231*,O7Ls[OboZ@-(9nEkOYqCK"B
=*u>*/g(o'R')nHZlsUlG)qB^VV@go%<iL#XmO?q!!fcL3X[-_jm(L:^':`:nA<JPEY8FUc2
8iW;#Z)dn.0cFdjOI%EC5&f\_J*LLMkK$pXA\??(cL+#=M:LJH#M</NFP(i4qiR@^2s*46p9
G)/>2B<\51Hp3WUdll?R=u!2tTO6Gj1Jd6WSR@\R9e1Q4Pa=_0=1M%Sik.7hge?_$B&3-V+`
VT6)nQ,$e3?Dc,dB?9\++-MTC<$=T!P5m)JW/4EbKm?jmXci3A2nmLgHCA7k)(;$H!`Ch[&V
,M2<*b;8`?_In@=e><K-pV-<'qbaL80erVk?A>h(jlXiAng'T+kB9QiY`g9;PcF^=&&"\>Y[
=N1qIq_J2hs#9*/l`iPZEf9/JAYN./hk2ecn8boRG#So:^\@+/4#_J!?m?4s8@u?53<tUe,W
A:1>qeAJN7R"#Fqu'U80p%^(d!l'BWNb0GW<ij;D5ke>Ita:iO<^IqRrC0jYsJ2UN09E5QiP
l^4-2'h7l)VC0ea\,2H_R,B"$/mfH]AAE$YeFJ5i?]A\,ICp5UQR-/WTi:[rl,6"^_Y7)(RYVC
lt\V6&r=<1Vt#]A<J2e(_hEM5^VaJ'D_/Y:=XIY!uUK!^gj`NF%@a-;!MRc;g/MYlSe!(G\_i
Kr%bslKiAERa<QHkes!#<P)qtJlJLd/m$h1K$$EF%9<:L=P7b6HHTV/>J#8OAA:P=A'pS(a`
="4sL&-/?0`n^?E5f#h"L/rGA#i\ub#/st):j/F<8TfY5hA;C-I9Y1@&[@Fm_BfUi:apWd0-
lpT_[Lk-8!Z:mO`m?+Y1qjkHd<M^!lqJn(W^kAdpo%[?4@K)0=ULC8#d"M54+o\^g6R8S>lB
Y'e)4$j965)pO(5CS+rq^iI-%;Thsa^$uc&=JWR![C/rf,G)/C[L$<7ehfO`(35//Dlbe$k\
i*=Z$_n0o1CTo<>h&Ip2KN)XSXr"#)4\.6>%pldm1uGlnl\C$2;`/]A,Poa(kX!+:EkVJ/V2$
.nd.OY=AS+_0,rN"GHTUsSE*99S@$2Oc8MNF)o'sYa>7f"Xd":5YmoT71eUG->AY^o\4pJg<
TnEPUt;f^a1$=L1k0DR2c1q:0/qS52Ptn),W`<7XFJgpOc*kY<?K!!S#j*VLKe^Ld8($6Zi!
-B]And9Qk3]A&/$FB/iRslX^>HH@[JVio-HMDf\bn-qVa!P51ZtqI#G??_e)BB1p-NAJZR8"l"
Vmknj-S*2XA,$]AnLG)(1r!6H=(_8:e<Oqe/Ae+'))q\\&T;i"n&ap9E<_)S+g1<(a)XW`Fef
-g=[[ESHE',,F1d]A:/?CoIf=QhAbVt&3Q2`K?Ufl`1EQ58/ojKcfZM9%K?s%G2"F:l=kBK@A
XrVLZhAPU\9ei^<15i+&nV#4N-CYem-(7\Ef#]Ab+`OgCWaW&C"*f06=1&`R%rlG/)IEY#TqB
dpkU\S%b0S\F`*1?dV96hpRT*(>gda3"F!S)@+0'F<'UWD"7eM?SiQdB5K2Hl>)P\UblWb`O
F8]A+GM5$Jh[]AKd!=A$,s>`/=BE1FCRQnD*MpV:KS%G&joJl//I,N<KDX`<4LRmpaP8bn:-iF
--3]A]ALO&<%6c+<'@(;;2XgrG[&SkYtJ<A_iP>0`OGG&m&[=7c/p7(5!<]AZ_E`*s1$rNufOp&
#"e]A<@PsMD?N-S0(ru:=1(cC01e`CgdTDj5L=&Zctp\mj=;CXu5u(FDPXNBCd9[fNl>8V2)=
n2!gS>JpP3JFaBALF(l493XqN[\S-?"FJ-\GUL39.'Q)XD.AWo@C:<q5L<2a@?*HhE<`s>gQ
JT9k>7r"@5\fhgB#Ub>cF\;':@*T9e9G=A1TsdImT<^WA_'Y]AlZgl,&t@jP6,3.\`]A-gY/S*
Yp`D_NZ?&<&)R_3:P16pU\^^6PVmtWJIKr_eDH&WgCo[gkPma3;t7o/>a88'%d^%@ufl]A"<S
e9"t4'h%(GSY49"Vb:%SFlkktA$*b!!c8(lEZA.M6b5B5PF=oU%BEnq[6\U+*)`o#(<Md?._
M.Cgg(b/k.Rggpb064B+J3H-MA61W_3t?!XRaEhCp>DS4\d!79EEK?@e1.O"&;Pd-A^3=Of^
0c,_P>&$G96]A^B\PpGsJ\Ib.85HqfLTI3U#=ODr'91<TOq&*?2%7B@3R9A=2*I6\#NdcPqIm
Q.@n5QB[^3d6Y%1ob\2O&I:o$R"2AgapbY:&GS_lZb.Y5TJYf$I6;`KO_^NIis+#?6<24jNi
kgk<j`K9PI@_f5d`J'MfPU["&Y*V,kb73eG"J$C*R2iIR:'#Q>6]Ai;O)rm[cP.@RF)unACLs
G6]A/tnu6*seVNHR\'-(a^LiN(\rrKo2l/L(rG`]AdjI4ll32J@\T5sRD'Js>Qob0bpC=NLNfC
=AY$X*WRCjE9mYMO1?hD6QGln+rG>Zbi$'6Nj"Qej;-FVXnn0450S:k.Z7s17[6FT.Gl^jQC
/aYhY@^iNMaB!-^MIf]AR%)k%_1>e'Unrr<~
]]></IM>
</Background>
<Alpha alpha="1.0"/>
</Border>
<Background name="ImageBackground" specifiedImageWidth="-1.0" specifiedImageHeight="-1.0" layout="2">
<IM>
<![CDATA[I(ON'>@4is)P!P@MmoMsGD\IN$GkPl'Q<L!Xt:?%MZie4m_PS^$RJo,42p"r0)`KHIF#Ieqs
Jmp+*k.nepc1VF,`3"S9sD)\uGfq%M]AHR!5O)^pf8%.5_B+<.+Qt;O&oTEV98j(VqJ\kdb8$
l]A,=^WA3/<QQ-(l>PJY&Qa%N,g:_5d<X-&H)<J31%i`0sM/$rBo;O]A>`o*eG&V@)rYaQ/.FR
A7QhJNG/>!qTfqSEId@n&%SKnA^&->b'-(397(=M:eQI3]AoP*4sufLH6CFBSn]A:qqn?7+SNQ
c;LFVC0&j'Sjeu%O:&U6W!mD"G7EZ(1g>6S/M,?rN'o7?q5@O#YUoThpmijbADip*k4_'^aN
X8`TodE>($a2<Le#R'_JZiU4@KLNP8RX^C(:S]A*=!Vmqcc;7#CAAG4Noq,H@FM\W;3/'8-[0
H[1(&<kEJhg#`lhME%%f#YhePlAJN%u!a4))K5RAW=BJ(Bu!/J>'YogBDi1b-S>K1[a$M6!U
#Fln#Bs'!f.Jhl?U?=:.fPAmP!U).0r+IK?Gag?1)'8*_@I0T]A6ZQY7kZ'F$p[):F611Nq^,
9l>F_=:,Ga?^n8%VMF6[6H\\O:q5Lg2EG+Fef\^XXnO"lQgkWln0I./B0pbrSM3t=>1QTC*I
5R/@;[&G\!ffj1h[)QEoX'8JOpXo3qXe:!e>&AG:saV`^SR;<M*A;_#JSDk0KJROC5iRFgD$
Qs/SNfa8=T$l!;ao=cOj$\g"]AgGGEZV6Adp!/cW`_9T,$)(!R_<i'")#9Wud%#Qht.@0gKgH
jO1U[-UoaR"$ea)"e@qJ)c'R2q5QSVGY<1V!+-Dkid+&cafFDdcB(Hch<R[M@9T[eg2mQ.Ec
:kk>?IBO_c$atN%=I>3/dCB*&Gbsh=lRSTS`ZaC8"1"'`!99bmrA?JZrBVLcTC,0BOm1d2$S
Y6eX63$Q/d5nW\0-MX3XcD\J)rEN@5o%3S38`V)lOkNA@7\G^6dp<Y7/X/$[4q.N>bOoS-8J
g:c3=d/'T(9s<$WZJ$lP.E,kKK++ed9pFGPA%8rk@#SJ-b4V\MD[eB@@E%:SW$Rij!jhta+t
]A(NH1ID\Hp/O9`mB!nbALiIpXn1f$L!fEY-+G)]AUGujELXitbUVEmnQgLhIh:j;0aJ6o^O*E
f'nEl.7i8fWQQoql,g=9$`D,m69-9&L$#-P#QIRe,d4Ft@Z[1ET*AT6>-bAA8,_oq9Z2L:JH
AL$3ZL9A\jhiWXbu4s>f097o`o=,FVjK@fQ>`@"@s63k;-?da[e-9<[AmI\8WI&c31(]APEmp
rm-Tjatp5&iV*]Ab/3&`b>#?A-\0JOV"4X&U/.riZR.`-7#<>D@X^uWCQ5?&c+SWUeMl#@X:4
ADrCW6Z/^Y,VX3AJPEsHK&3["=W#I>thBH3\1JQk.hWk$ZNp--0C)uUX%<^CdS1r8t-cNDbL
a4ZaU2kc76i[D#;ClYGYD\a!+)76K.(M[SPD5a?6=@Hg.q>]AJm&fj!p`/1`"fHC:XT&<,b).
b^j4SN!9%!T-!Qo(k;Wmb/q:*H1n-a=eAVe"8^mqKq0ZSID_:e@4:4fm05m-Wur-W&He"m]Ao
IoMVJpSHJkm@4DMTRTE,Gi^H.ti%7Jtp7tp5HOp1!Z,ii-5AN<FY=m,.`nmJ$n$X]A_QcZrKA
bl(p^lCXa'!>N+A*S$'>e<,?<gPFYHT^lmejpKX^*kEt9@c*F_a<@s2sYd@@5R"":0S)kh3[
E``2C!8WM[6&o_G*Z\]A3+3G4Qk;P8`7uH14WNUSM3>Co1RVe,g,!cJ0#R1WKN5)k!oB$##2=
'.6\tRSDO$%D;,dh,\DEflO9//@;r;)%"sbnK0YGb![b2+(li?eCY!k9@ZYX)E*f9e\<(I6c
^"QOY`o#OKL.DBc=N2URCTt@DUk+f#?..W9S@Ob%MY->hJHE`jdSr:R"&/&5L\hNY+TG+EF3
_\%i:::<HqS&`'@*L1[dFa)*7nV\+P[hqoio^VgCP>]A5XIZfRrdp;8hL@-+=ultrh@/MEl8S
)s5!MJ,K]AG7J4OGG?XE&Ioc[C^!i-V=(Cl?ogJW9UK"^Le9YqYUR\+67pLhVm"3`Q[s(_pTD
7QK4+&hTOO;`(WW[@7F"qM5MM]A/gf&[V>U%(XMW&'&;QSsk9pI*Y>)ELEg4DD0^*>Br%8/4R
P8!M&\m+9=8:GI2<I`2JO1rnf5odW0KMr=<QU*tjOb?XTG/f7T0L$1\lq$?^UG_76=_'MBa"
hVZZ[R_+>fOtqD:h)2[iN--bT<";`1-:"neiSc;D97f'saYoT(Ros%*B#*g>D.l6-P>_U4Iu
U`nq]Aj0H%%D%IPN5/=aD,s'QL"82I^o$nt;c:iXPD;%u2j)2X7?r%VFOUT='8E/1o#?+=;Zp
DlF$,(PfA<AZ5Y*bKDh[IYq8;7%kiG'eDpi?Xk3l7JoIR;LB%ki84Ee4*ec+f4OfMO*I!E)i
Ep2ugm/?6\sW/cS#fIgp4kdU0/s"O!^91DR%%D+Mm?K*P)`ln;J;F=tg29fAg-Ogrd5<@rQL
o;gtrgF`GV^tAa(IVQ/Cm\Y0hUZ]AXNSg(@Kj2U[p;<:''eo\qoi/QliWQY//Oa)m>-fUfK?R
bT$#qsL'XaY3eMRN:P'g"n\>$U>[*-K$Nar+NB5L`c-B1BO6&pYKXe!1PcF7Ch>F11=).9bO
;3Xa#&\7=RF61DH5]A0;O]A$$A!ic$r&B:m>RWZp/ZA1,s>7FjR+u6:F#[`'t^S1JfZSB>\=?;
B2`4]AX=qTa0!uhY^ag7QZFcUZlZU6a([<0FH`t=.!T_$<.Q+AS%OQ?\hUX*&nL?P76ksFD8`
X2;qaNUE@$+&\L<Yqh[^S^-B'7_W9]Ak>[5)W^Uu34&>5.F!CSRhe_2:O:$$U?+&*3[D"BZ$l
QGsBNXc]AX&RLa@l08\*d;u-*M\4+\KrA`'lP^J,05OZh\Q1)0:9BO*H!N86eHN\,%f9E#8KT
GEAO_W/DFDSmBH'a\=#g(Lf]AF\'^*L]A=XX(+W<iUNjm+57n6&7<01)T<+$9E*$^gr=9GW:iO
K'Jhk-b.--ET)i"FOBp3K$#[3K46+#d1T&*_YpsVr\'Kq*FM)ONVhMRWJOokb5j&nAT]A&s1l
=DJGSTGHMSb7d=![[Td!OHDqB9mMK?=c4^Fb[KRre4;r#t>HNoNM$)QSV1f4PDd%X+REi+GZ
`5hmqRB?L(((VC#(.8+k"*8N/RC`qXZ95k,lm1umR/JeqpYENinK0>T(f2,_UG_'aWjJB4go
E5E_XGs?A/5.9UhNU+U<cua<kqIXJ?'/%/g_@K*]Ab>Q.1.VVuUC:;,sjJeM?/c3^I*EU;W!o
of9*[2opM)')JVk!-Bhj!XD2!c!lF>93ZGuZbOMn#q*8a^M;\I24u)3&4%<%X0##q.Yp)4./
6G*o8V[2*NjY=uT/4UStu'PS0jKf.*p8"*0'?]A\@C./V9tF40n$I\HFaJCWs?#-`6ZPMD!R<
\/l)2/Y1XR0_gS7W0N)qJ5skftCliZG;_`mqu`oF5jW'.f:JD*s0`))*1$ZGO8o3-_"@fU0m
fnp5cr?F[RFRs.!`gn2P$%]AND\e^"XL.&%+63^-07/jd)b-g$]Am5n$[:$?PI:=U.a&Z\T?`)
04&Z*$p.+oSo#gWlR$N:#o2[:Z6!^fCS7*5R/q]Ab`&Tf9Q4E@/)T5glp\GUXR]A.t4#L5_gf=
"V:b"u#D7u5tiW7OIR*G0,k_d%/TT^t;.N=7Ge(9-CBb+i'L>pdhd:;S(s>BAXQ@Yo_#r<=p
BS35s@[Lh5hS[I%5SmB[KahT[0!c[0%+IE-O)?>Wr(^C0ue&Z8rlH',8Oq(]Ak3*RXG8d[CG2
,5U.[E8!m\<+W++s;aho;k*,Zc2;,S7+SCMn2"@i^KI9MShg;FH^eGdKB$Eb#A6Oi0DrPmHU
;/7)+qplGdqn2akG$f`FSnm(bJf13$4<9]A;2.U)rGF1iq"8o6CbDfgXZL[0_+ujdXf^ZI=+_
@Ba=+nOZ;[ijDI1c":<29etODX$]AMDaJ?di-.P^5YFWriA>F\$d<2TW=>/.<d8aVA:aHZoHj
9TN/Xt";rftRRB2&l!5;;d4ISXpCA<%YbWIGOL?f6`B\?RpKKI`_glj(2_hM"Io0hCO\Sgg-
.2Mo>QBXu=N9VhBto\$1YIq9fR3+BVo6gA'\4BQ's&bDH4OaL(<(1Z?@^cl2r<MR:=_"Eh7-
8^^C)Lc-fP.V@Q!T_&4abK6k&iJVQ$23_VnKl`/pdHKAg>V'"fe*!5pH)b4I4/`4%A$<h.V8
fsNXn0Xf1kamjMX5=`8%8+5UG'F;%O,T2>so((+HJ?[IWldHIL<FoP&XBJ:gobEZtjtbc7u^
bke-N;/.%+[pBsmn/SF.:"FE@<h^6_?7!FhF!EWCBA]AuE4h>-Fk&1=]A-sATHDG8S4p6dG)A]A
m)s+7)6JVAk]A!Ut?P"SK[;`=6p`jK&1?gFE;Dl;9i"c<GG%JDL\cB9I_+qY;\?CCX$OF\;#]A
nB%Y8q'k[m?1K+f4-LW;pqlT@jp3*H`#<\!S-4X6I/59eF@HXE,hE2J57TPiYJ[)VbF-GDte
'r,ur<n\88A<4M(r&.Ga/d%Z=a$PlFDG[SVj`*e$["2NdIPQ&oWUf=K.7i5nUT9`j%E=q/?J
]ALq7a5YHfQ!?I`Ron'QII^7mY`TG^J(:@=L`Vpq[Q$47Vit]A3-^`Za"rpeYHS^$]A0qK*81e?
eT7f\p_H!0rL45^d)9E[[MpDrdYsD=`4erZU3Eh5WDP;5m"S`5p%V/o_j+=a&r>YKM;LF>Au
@?[[\eWHL,^4M.6JmiD>qYcKsq#>=)+RTk(ap.rIp1+O<bDE/h0aJkuFpZ+9.46@;O_RC#u7
@h_&-jq=Q%#)`h8.K:jUW&inZJq2Wc1onkMGYGmC2=A*'8Ik^0iUli1PPe_Rnp1HW_+HjT1d
XT>c]ABM%)rg1=5dp>Bn5[&.!mTGL)P@*8AEYs16O=I\O/<F>+ei%%fJ5^-qcp;4Ho:1Sp=(J
4;Ur3">FA4NT\a!+9m9dL-N143BMsW'VF/>$,&84<M:$\t$LC;oA_$ArKLV5sa8;F&i]A+Th!
@:d>r?-S>:VeAjhl.%FZ,PDg,TJD>@4fl;cngQptcrf_cAPOiI2gK2Y`cfX"Q'Pe9`I!X3Wd
EN<q'n=-b-UN8/Z`JRNlEhN@lbIF`B6#S]A%u2sR")r`OKdXs]AmbET4G&0l=kcU/1^#<W7-ZD
Y'ltfnjD;=$V2a^$J1P).+5D7OeUD7u:hUi+,Rh!@&SYS,*]AMR[R+1=7Jl>luacJ+ga,'?W,
^jXA:SX\_jk#)FC@Z[@>U<RKpp'-&N*i#)H0Z<(@_B_Bo$cL%m(>r4Q#78L_L7X/8\XVsj<a
X4poDMbZ:VFuT]AgWt7$e2Ugo!K*6CXW<M.k>8B;Onj#3>i;S0Ea6GE]A(TD"kj5,F,Tg'DG$2
jN@.Qr8?c,JqoOV^k3\84hZt?laj[#X:^RJA'qR2NBDPY\ERt"j"C0oSG&Rn!E"LGa*5=r56
]AEH=;=]AnL4U#ANBc_Q`U_[q6CYha-\]A]AXWd>WfcL9*MP]A",Z2O(-b50&P<^gDP!0qj'^6[no
$_ggh7/GCIXqU`m>5^bkSAq,]A8!3@gp8W9"<@lk=j(NmV&@>e+V;hXdTpAk]A2Ma$+X0?[A)G
@G6bkHndE+5ti'2]APW3AWLaT7*@i=c#\<G*"McLIZlB7X4&9s6sGZK]A*9'A[s!BC8)gQgK"[
A^?O&5@IV`O.K/PZ:G;>c9*o4"-m*BegAus;7h!l;>l?;p01RR"KY26P,E8YWU<k<d-2lh`I
Q`j2M2Tb6fjFU=YK34P_-mUGG6SoCoo;;cOZbK64?'<$uSF,bePf<M\Y0oFI-*LFI6Pb/$4D
$/<)u$*jk@2:\Iq7*Z;NL]A!PpuX6iWO$C+4cdoP(DQ___s@eRVI`Y]ArS1\2G\>Oo)[aMB>/0
\EH.3PGFeCiqpV-`,;&O>eittM9Z/U1'e3V[G=(oNd0(73O,mr"NP25U/IKK=\=40'%%)*bo
X;jFb0)W,KWUo",%\Rod5%WaH!6^2#>r+\KVbtN/[4jt@n&-Dc0)MLS*t^4`fugZ#B\!Jj3p
,#PgaB#`3$U<Ct4l\q_N5a's`"pY;&F/QbeLPa8!Yi#ipkJA]Au4Vmj:]AJP_+!gZb;0Ss%J,a
/j`d)QZ`4pSH`U%-o+i-FZjt:`&(kL_;RF`_=?$jV8&OpZ?`3NH,)ealePQF$PuHkdmaB2ri
F:DT?2d9m&6IuA5e^#fD_KrGoek8lqVADi1I[Gn_g&+"FFem:8=F*6U5QRdiB4)Ha0Oa)sKm
H=NmF@IB+7XSE=c#i3O4nnn"7TgEAjNpi8q&94'Y.S=+A22ltFB7o+^bAr*6q+*0o><o00B%
7#Z./+#9`L2buh<oeX7VH(G,b^N:n@[<eFB:d@AcGEe7J3e6?+M/XVW-.O1hkAZk;#4-eE'7
(:_p!Tcmh]AJ;>Wp]AO?^]A4&o(0]AZ-MR%F?"HNhN<[X<O@2tKcnE8(<`r0GSj=R6OaMFd6qH!G
VU5CAT^>>Fa,m=.OKE6/g$[&CK%X66iGu+'UU$?XYpiT/lrPg*QFsN>%(eei*li'JqD-^na,
l%U'-KTYV"HYWB)7hN*g_$3GAh1f$/il"7c:9fMrq>*GRq#GQ9aj>r:hK;)^4G'0]A7fACkZ\
fQj%`1cL1O2V+[Ti6mZ7>_n/H.Y^',-<e4QD1G><oooq/n#?nC#_B3lo;c*Fg5>1iHX$kuaF
3a-kk%E4/jpLrtrZntRh^pT+:Xb1&.+7&j<f*k@ran)3XQ2h:IO@.]A%^t>nec5pKZbqu0`^$
<053)QfNVtBM(>.WUHAQN&jYWN_LD&T<N`J:T:-7?i2Nb`/Z%of4"!.jAPoondmfrNU$Qita
p:!)c.l-O7(]A>H:G!+u3rPp_=:)At?jRm'[J6%d>WiEEb1C=icqb+)9=,XPI]Apk^#ps4=HO[
`$HQP2Ga$XO?hhH>&<>UL&2gTt*XP4q?>P7,)@&UJ3ZJm1dlKpJLPmg#inCO^g3ip(K(-/N5
R)/W>W3*_k7QubIIo;maQrB[\*i4Ca:ihY^*jSn>_ltTe+p\W^/I^LiCb<mO#R0me3G%,n4%
e14I)CkpAc^:s!cOLO>$E?=HE(fIOPpT3/L#bj/*9jjtFN77,WD`pD>*PS")WI?]A7kD#.I,%
3`dMeiF6;[InY>q1:1XY*]AH)%FCSoe4CXLD4o\:(mdV08E5_GqcCo+9.['#]A@9GS^gcW*Gk$
5%PRCi0[J8CZib&7Ufb`X6CRg"&XSo9/H!&m:cIATL,f%XJd/aWhWc6Kgk+qlYA,S7HZm^+Y
LZS/Qeo-S*6>e0#P&I::JEI:9fBE6`VH$:,8N*Vqjg;.L@<>'1S0f@+<YHUQH6;)%i50@i@i
+*?PYRc]A#a]AFml>k2<cC^[c3^+4$kngT;Xk*Ks5'BBphBM:]A%/mLN?te7]A>3nmFG9NV)LeWa
@k5EeLT^-Ph9@!Y$XT<Rnc"XddLuo7L\,_e1GUhFTf\iTCs<(WG1U9e7]Am$@bB2,3QS]Aca4p
sH_js?I\?\0N;9)pH\$FRk&E0ta1?>c_8HHT.2^T8r1Xih)(iJ\32lhO[0ku;=EdG_Z;IT6c
lX-JRBcEVt-u1JCo?@\g^6o?lB%PWap7!.#3pCK",2_f#*j@3UUQ-)kB*7tY%5UFnbIPUgE#
g,Wi#]A='7$j?dl8K=HJ1!#oHXH'fA(r^d\5Or$qg'fS^ci3NL'CYLj^1iW70o-qO/>HLdc2l
mqu#9H;c;mEa<"Z9ig;M<^m#etilSO`8?4B`\m+Nka-*s>BK*Ni/,hO"[6d[8jJBVhpKc3Of
(%m<C5lqgndkA7,1`T#hRZmR%OVnLQI)'&ftrs-gS_rpB2G2mVqYjbcc'GYgB.:rEs*;rIHb
8?c\LNVkQ5XN5W0DU<_<]An9a"Oto17r]Ac[7dR'c-L2mQu\WIp]A;b@T[6!]A@\0k*mbGThsO#F
Go_iN.#;70DC<#?=K*A7%Ck:HRTG\l?/'"dVesG5D9;G@qVeV)-FV[c:JV^EckRG'2tsNjms
?\/rBYN]Ae"72Tq5,&<F7F)<0(e11gIap73C,/e>dc$d^NJ_?31>B-o0H5aQN-i!d10TAXXPg
;`P\)_:eZ7?,t3+dBA9<^Q\]A#?flu8A7@[e9qX(`uTUQ%iqgI90jo&t8_5LPB%q?^dK2[d1l
;M_-g*4s+niBI'ph'?GkT+F&PIJtU[tp]AtbRIt3$7YW+hM=AjIZlTa$_C,)fcb1B3,6mOONd
2UbDR&l5+BDH;)n'ikso4%S[MiXNFkpX>`E/c8t<F%mfXVILKe?pPZ-Lo/QcW\jpa7d`0l:T
*d4I;]Ar(DY=o#.lB'a`>b]AI^qE%IGor%RV5g!T,%*_!=+Hp?h#V5S`5q$!ZsKolP@:Z?PH4?
.ipkG0To.`^&:7?T2n@GBrK?p$^3eDT+N5L.:85b)4D$quWbDV_4h2#_SdMfpFcEcO0t>9SI
k5&U"I^f/)1ChhY.BJ`J#(<d<,'#RXENXY/qcubf%ph#YF+14AI7O`"um=(PnXiMXLI>qIRo
f]A?iGqB9.:FE,%'<kc"l_\nf?#($@g0^kKG]A5?e(^^s4BtHeDPm?Y_\6F.6U`;tKF#D^>Fo;
$#(<Bq8qAgOGRQLm,k;amIQ%2fHJ\sW$TDa?S?\*JcpatOXPKR1+FW6;g0Q0_,\e_&?B),QT
@@.9Q+u.8YVE3Q?07d!=VOg]A@.6Q]AZ=ZC>%iGrC=?5_qVq`/]AcCD#OAg4>=O.u8uck>IJ=_?
O4&4SkU2>4+XC/-YM&ZaCclk:Nt/b(q!`[#qgEc7/O-2S&5f@6S=;TQ.0r\uk*4-rP^NkB@>
[Vq5>L"3NR_VM0Au(r5o&>[[+1M!h<.>XP@&06/*LR4f&g2epSMrD"/!FWLV&1(M5Q(Y]A0+K
6r3\XrnMm&1),4M;d,n6U]Aj"b8jhun1!P<l:AILbToPrUI]A"X5RHbBkj$J%VLuJ7G1"LA_Xk
.f(4.^0fDs?RB)5i[K8gYQqM0#N4^'#\/gQb9Y4iKa_Qs2IU?UdQ`;U$b>JKric_<dmR*TkO
IqFVr<9Wg#rHW$NZol%K%)]AnV+OaN0h*D/#_MqoH8B9PGq7Y^=\*LRki%s?R6R.dY>+aNb+#
^BqWJ@D$[/IJCo`USK?As(aTaJ+QG>l"pH#u@YlTYc27YH\4+)lhu8d?:]A+C<NiMoO?GgP)k
%<>0T'Em:T=VUS__WRKRKKn8RNp_mu=.g[\clP-[lTXSk^AKiSu]A&RPpc+*$j//%GQQr(i!k
hZ/)7(42%D1tF?bLWgG4Yi)P<*8sPO\r>`+e)C<9DG)jhhGAa.S3n"%U^jAWP)1jH*5-u@ki
[\M%<AF:D>l1HK^&8M+^K`TcT'IGs>,j/0U,ZAa(HLVllp*>np:6YjPtNNG.f#+L!;.7-G3_
`)?ds!hC#W$DTO>2'b'/0PDc&36[Ia8Y,K=QK(mnS,I,U[RN<a=W'#";KF^:TWA?G)21Z[43
mJ"'M>pG%)pUIlmO,HY^R7D"\J`7=T8=h#GoSeKQob2h&ShC@Qf1Heu"4e,uu[OF`B.@3:4O
"k&XOkAootUYgjP5_7(?XjZVt:ZG>cIjbr3CQ$N79_"]AL"/TM"grcD_u#7+D2h7=o=f![3.'
_cF8(3'[?^l9rB1H2c'Xf5K?+?:k/"DOA&.,`T+5U5.3rCf/cZ0f(`(P+T]A8!aK'CCBBHKU6
oIDo7gX_.;b!&m(\4Ulo\LIFsf\pIFcJ/Q4!>2-LGh4Sk%e_*mi9N,UF"?N'@gLkMep/2_J$
4n?nOG3"n97$kSf165JP;3Q;#RgKrr_-mERJKKFD+"I*X:_L.$KWE$F^:<`6r'Z,0hKSIoh,
(<2[r(o2Q[Xk)(PQ]AZ`YG)PD4Jl9V>)n)a_OssW"sEpY'HJ%[P(Aq*X"AR)V@l0Y6E@ic;Z]A
MrZ(7tT;W^m0`'PN>i#G%86YZ(lF9(^\G>FK4"8?r:fTQ:k%1.sRFc`%.391Q?EN!.Te;;N2
WtBW=G1[>]APS'=C5IFD02[=Z@t=F\^[8u;DGWT'b[LaB8I8"5A*(gObhDIJ>EPt6&=s?R[ZR
/Wc:JH!1=g1co)\<hG1F6Y`2[>b:.a*O2s"]A7?B2Rh0qWG(bRAP8Cg0.^5M!I]AUPuTcng_+.
Y]ASpp97dbo3TD3K=m;hale^'[;Pb&XRVRDqO,Ga4;>3@H0^3`<<15Q-"D`cHLY07MITMc4?5
%gXr^Z\R>EPpA<.1;-IpT8bJXEn]Arg$!#6L:EuC=/&fGaGY6#cMu[@Fccf_oJXVi;%Q!8ur-
3@HT>+oR=!B7!')Q\4YD+NZmaL:odUS-#"I;#&k,#s0crQbco.lao<u'eRZm1H=umu6Vg<b_
FK@1AD?XS3kHnHJ(katMP4c_@%dL2.b2IN@#`joN\QB/GBTT'nB]A]AMg9g'NXR"IX%(gm1.I=
bd*Sk@i\Kb*9Ni$/q(Bj,1=t#dRq3R`*o"MR'*TRsKp3=SS39Hn[3@Nf47aJ8-V++[Wl<IhR
,0tshf:gBD%:,HZp);#SD]AiP0#cHaa7!ur33n'bWlu#,iLCC7u2-<Ua2p0`4pkC4KW.m9VN'
;(NN4Ru%>-)RS]A2hf6.BsgAUJU'dQmW&b.M?>e*"YLfZp,4O@71Vba<]Ao3s&"`ep.snU?tP;
[p\Hq'E`*0,e=nb;qFu2IP<bMb>:rt#q;5Uf(<F"Lh,%oEP=QK++,Kf1,6m7X?B#SQOG_/8Q
HNND>maup:jDIL!6M$ur1KLl[Nlj*SrI,T7Oo6J6DlU!ATX4d>3JWdL)m-9BbMqRr/nHdG7J
MhpjMM]Ar3-0\CkKH$WR=fl<'01D!r"_<_!D^L6EKL$565Z*LRm@7[18@4=*),;_nH@b"0_Ik
K&:/8O[1T%c-Rs^/dFK<W83Y)DAO^QM-@4Sh9G5<7g(C#<"9>N^C.@\deeYJn(Y\4cUT$Rop
>g+-.G'qk/_X#$Fd6_h7:"_0B,D,"Xmf[7kBk25+lWfre5t;Q4EY[R(@39mTUP/<&gL_]AT6M
N9A`f/m(m0tr]A(="S>8U'nN*!"g%s3uk;XCl<M))II\g(pJNZMS*PoO>ZsY5NQV!$F(u-Zgg
>AW2j.kPun^*j3FEt$Y!:kne\;0?<WJ>pk4tht:Y'a<u=Kh+:OW1<7rut<t<LOVU*s5qR'U(
UE<FD:mp(aK3`&[?aaeHKe[HMC/+gL=d"Kr(iZC<04YAH.l5eZYKh)0Dj`K1Z6B:!Rk>9S9&
:H5_:C6gOT-]A%SGXK,8&#YeB:840/$$Q(:Y0pLn''A%E4htX9JpKGb]ADpmSpr(B/2f-Fi9V[
]A'H$hX#hDE)VESZ)GSLmVMkQ'E`Z(,[opm#`op:=(CuiP#33p&1_p>?(RlVXV1Nc;L?<*<Ch
BSXLkJRVpAFq,*gb&+-#9$!*ZeE.A^*H"Q:fL&+hH9W;kgCY=V!ePZt;`5"Z^mMLtp6_ErA[
<e"WmZX6Wr@@ABYtf.'>4BY'<V1Bl/cq``649^ROGP\-q4D/SN=deN8L5*O'h/q-r8os*OC2
Ds3#24/NQcFjV_N5FnH_8CRi'$%82cK*VhnfOFDabmPDaYBD^F[2IDZ1jE8Ji43p@1_T,<j=
-&+P^k!9jV:<\?dgPp^/K/gj@Fs:-)"Xk5kDpeX!6@hlp)h21s[j5LAU*]A#"9V'PN-H0^c]A$
*[!81MbY2j1M2.HY_@1SemAc;'U474kM9gBL!,^0Lr^qo@Q$"-3l>^;Z=Wka;Ll[8EU*j^5l
gcdl$ZpQ@\Q^,f\B*G^Ut)_#@VEa<?U(b#W\@#j95TCh[4%#%F=q""HS]A97;M`"Xgg%C1`cU
!NeV`n/VjJS]ASR4`"`0R7<6.[u5+tM`q'ab.h[Sj0C6]A4LZ?><m3JkH'u]A0hkTeoNqP@SEWY
>jg#ZLCVPV,aJF*(2bu&h[<]A+?QJY1qfc+hd.B!3g;I6:l,%:,bVhJ![s9@D*HK9c4GPeV&X
i.a*gB]A=CI5G^R;`P[a^'kb3uk;\QdRm^PSUZ]A=,aIITQ0iGK]A[Mt_!OBCtB&"^([P84lt,8
N$_\k(#<4]A6s,F?I/QL*bUD*>E0uLQ`2jQ5mPW]A1,T$G(5hN?*<AhE[5eFPm;Wu+*A%T"L0N
O=F;+='U026TtpK(F2%Jr168*f+K[E]AMSi?m^O6eK7*2-iSlpc[MV6u$;R?]Aj7$l\8pm;@SP
pkF<bRg;?pS=&KO\@V3\u8"uCN7,^?XDG/LHlO9h!'F!H>I;\f[st6]A_ReIRWbg7EU+aXM53
ct`2TTX^J_eNqO3#XF]An0HCg0#dhRe6u9KPqMB(Y'TDaTuEj<T_Zs72JOTR.u>$n5r#qsVOs
+%;_u$lfIlX8#n[$auMUU0W_4-BaK0R4/+r^>6iRQNh!+NM%3:;FhqpZ#!Fq$b@5mH$."u=H
9g2Gr=OGB[p$;Ea/iuQT!7QA2Yc4"PTFijKK5fXc&&5q^&4M_s8mupoQ>HU".@:e\frTY=%i
eIYcf?:9@(t`"M4f,KLHCkb1>\bLcP#^bAm7\)2:@2o<]Al^d=!umVs!o8$U"XSg'2s(,nNC_
-7(W#>VG8E&>99TDc1&,H&cAP2aPnd7S-ZWj1EQB+7E+HAbT1*PIH=)G$m[%tG!P63.7!b%X
LD+dHds[GT'!BUSV21)EMC+)h<QO:SJA*0fkVk5_8jYp6c.mT>H^U-_A^AVpn]AgTpY:3\@:,
1sq(YAMP*[^?<MYI$N+hf0O;\#4'A.)c/3j'h[CkF*J0tZ11/[Up$u54_p/6g$=WudFCHY0#
-sH"cC$Ii7Pc]AHMT)`UV9Vq)n(uV%X8";QG\FjB0dD.E?p0.)Y3_N6-8EILc@#Kn+i]AK!!I&
#XRBG(=/U&>o($P^e2BJSQ._K\?=bou"`M2S<0bI'6l2p.nROO*pAa4!fb^(iqW*XV,B]A%Q4
(g)TSUiiY"o6?d,1I[Q+]As$@9aiDJf-Quo]AFY'kB>BnQ`cWqmq7nfCri@ioi5*Wq;k=:KKuj
11O5EE+#lk=E._n;T8tp.C;8n,2@e:QFMb9s!X_G+6K'`CQ6:>TcTsbg*cXO0BL&jI4I-E#o
@c\NKb[PU#Im""F$7<7)l\\_B+;a2e]A[[84'PPNZALg6]AKIV=Z0u8ng6-4cnRoMTq,YbFcZ<
&+<L`YJA7JL>L6HfHLlm[.Q@k5DMC5I<?V#WpW>]A+8B'nME"a`E\$+Tig[<1E1<iKOr?5,p>
#Z]A$bY\8VK:bNAgajr":l8B"o=B%_#TS>^GgVh%:olA@oFP!3M`"u`8c(cti7-=+o#('Tt9S
342!)gfO!PicnHW0nq+M\fcKSW`bHo[(-#%p@F)_1.0H`j:a*#.//!bRN*[Dlif"pi_g6XZ+
DRFM5/?\7;h#RfA^42uio<Cl58U[Osr6`8otICN[pJ*E:o5._?*U#a>Qa%9"M%s66&,1Wfa*
3cO>)#']AL@#LVen$(;3AK@A&Q\,1>&TP+<Jf%uYPh=ad':\1Vbo,/[npo>dhLc0`FT<[28@p
O3\L>rIZ3cgq0$5]A'`oP3n;Mmur7G)pS?k7dQMoI/(C$*I"d:741uYcddA;=;h,FSA\1+B'u
$1!5%^npWS#"k&D9',I*rdBhd3IGJmMeB-*-AO3^I*5T_Abf1qj,J>Mr_/;_N&(f.+f;YrM;
GXCX!#[GPDPW>%I%C-Fl-KO[[K[a\cXGM=^2s6q=!9WUW1>IS`_e*Kd:'BU_alVX4`8(H4<Q
qZl=jn$F>[*:9B]A#mp,]A\fm8G2-NG"VA"2buq&c7O?ZRch;XN'+kf#^kI/9Z0AcWu&!9-&Q$
+!Erc\.'rq^Nd6t>[O^l9g-[siLeluV<:!&#`Y%L*RI\WW4h3Z!CHJr#^.ia\?dF_`ce]A\[Y
mJYN^lL]A"!El2T&*a4-g,]Ak@D.5Ids8OAeHFWD)/9eM"K&:6;pZG7J/dK6p:jd1:XYbZCO7K
ZmL`oO%fPA48nlZr\SP$'+04GBaqtY9o^"k`@7Ir`\5*!<K(E=Mh#Hs0)]A]AP^DEYb#<&$6uk
s>n@Y_`Z4&6rTP.8I@GZ9rm`a=XlkNc\j2/,Hu)#J=h4VCK4pHog^BNF.$^(mD^.n.Oghe@)
)q!0$ag<$oT<QgtIWeT,8Qo)`JD(47iM(!-f.WD0pjG"*(:=&&&\%,PIJW=A#=R*ZNre<XNo
/J.j@@H1X26E*=nVr&1bVqY/hOis&PC&@8gV"dc>^Rr7pAA-/*F&QVF(T2#;]AaV`UhgI%'6]A
7Mln/DctI8>bPs,`;kL7Rg#rn<#]A2lPd1[?rC[U7(F_X*IAG^tF18jjBp(/_]APHF[('n#1$O
)_it$(AMB]A?`I/d<1l#9.^"a9]AprmD8o*,_mr.LP,5]Ad8jQpl_F?PQcPiFh?6GkHM\T_?m8i
$d8-E!02,p?"3W%,rW'&U32GoD>8u,S=rg\`hDCOU&gtnY;bHi#Xhr`s')64EAe"AXMOs"mA
BqAHr`Eq=K#tLVq+_BqHr/puq.W[4ACe_@^'R'/i0R&n^$l4>X')i<K$=2TU5;O[gu_&/2!<
=/tfoEkOC[J--[9bc%dcTNeg:bF?a9O.MAj_;.#f>Fe<m'EM30>MO#>;ErM)!JDEFol98<:l
'tP'q[g*rcub+XF1k#f;h8OY!aF1+pL>UGd?8m<B&;%On%t3*&Oc=BF@/"e.VmDj:G'XEGhQ
qn3rBR)0YFqNb5uZ_t@tMKXaK]A5ZLNe=iaKf_0;k*No*_t*rUqUm1:>K8oJbl^@[ick/%Sr-
45);%M[rShgsf'^5Ls&=#YA,81)+!=)+\H-DRf#^5J%TN\8&6b<(="^<[:NnUJE(rhA.kodr
mQT/`i$ep9_eRA48Y8Jiht&:0NHB"t3(PZ]An]ADBqVigJ<_C1,/odo3$)5[IP=/R4_/bD$rNm
0tLrlRmhcGWG82Tf4EEsWSI\4_qUnDF=j[@Kr9eg8]AmuV)*bg0:ndL5+6lDAWPgAQ;i:I%Sk
]AT$;9<T@IEoUkR.BpG\#C3-f2fsHo*6T0&Bdh$@9$iGi8(fgcLh\gUYc0_n!JV"4k6q1_%,Y
i&C[sVO=;CScB<,W!Gmt.mUbu_dDh4Ijo!+g-A:Th#pCjmEE,d6P`d.)OOd+,]Ad,g2r9(+XO
V)7#>B@"(BLVsWB,'A]ADPf$t*cPSs;cPH!d<3agMuFmn2d/2PBeC5acDFeV>uP`dG1%pkRoV
s1[)L9!O76hGYs3Y\iud)%'A%?Bq*9`V3esg*'Ni]A?H)e=a,0ZMCWod\9U\GgHM1[SXG,b+d
]A(1AWM0&$L<#pWET`4T[48h$]AmHb.Dlu(L7.7&Z/fA4eY6immtV?96,&'*E7(0M#-=ZjiT:+
X7\]Ad%s7pOb=B5\>l9>J(*^Io42NFn\f1BI[[c\l/CqMA;<O,qp9p8.TlBOd<n9#`r+^!!+p
HFSU[6UE[rBFd$K(H9bq9":k01'6]A$IOeKEqF+1&Hl"=XdFV0gF*Q9r18PIAf0s3-6_LcpV1
o$$<OkT:`T]A\*SE5"`qk</d]Ap02DEr"-JVn"W(1GL;$b0D`gJCXY-,N?HfJ.-ra+V^mB40Em
#4oBhfoGE3U]A`qV_Y0<ktA!(hu,%'du+M%2,JJYE2&[I]A;8qGBo32:S3\6M`bd_@Su$'7LXR
(A[i#9LCIIf@'scam03_16X&(+\(7`k@Bp\otl"Zq;EtupVh_7F.]APG/R0jJ9D>]A$o4M,u*#
3T!B9)oG`W83kC;KtO?Kk*Nn<R4tQ%7K(2&S8'.*?FS##WZGNGg-=W(CV-q=Xs,V4mcC4\S5
8dKQ<&CK5ck+^;R!>o7Qm0"C1D'jDQr8Og$>Qd6Cr78Kd[7o'8^XgWid/bi0B"_Jco&Bc66,
bf,VY2:O`SIlbSaXO,[*&N9ek*ocd=DiDH:F2+k6#=lt.A4OOL7"s7d+W)k"eV7$-odlI(&m
r+a'0Qc@bB$KHG>??m$@8"VP)r%'a7Lnej(bG8jNAUbsLZ7"BWAD37m9:__kErjWuVgFQ5I.
HgC-@lc2tD-<`q3$h!jF%-c2W^_%lqD3-29Gn4YPH.55PpgP-I7Hl!aK)@&3cD<>c<Erm4M\
WEUO-5A0j.C/_@%&%9>o,dJZl^)[@&R@M;^l0VhpNcX"K:IA$(2`0C3+mp$=$GeXsGj)D3C(
;Q1/I0R)*qQW6e&B5,$-5E(CBNS3RhCCTpN<49+A(_e<!(QHK=G*+HqrB&R!X22C1c@/;DkU
5[Qpo,;([\JH&]ATEFS[BR/!XYWq55MV5Q#hBmG:#5h%q1am?]A^sR>uo7YnF,3c!1*-2SL$%^
?8*em0\d>nR0eWYc@DTUJ1Ea<m&*_-&VL5F\7A::]A:/h[FZ!\)oEiJTSR^RINO(a\5KC!l*B
"%'XWYd9\B<j04q0%>qR:R^'f3DgtU4_ie8=/U&iJspTo4rsoCQ-mTAjqd7CQ_gmA`e(u55V
]AbmF;nZSM&osZA%$#QD57OS]A''j&8h?JCH68IufSJVi$%Mte;s'rQe;9PDC$jCg?i$Q[5)]AF
6V2^=[dt&8""T\0LXMM-.l+"**L,PYF9o7lNU"J/`f=JID:PR'>Z6c93`-#@-R6kJuW)h([B
[`]ATE^9H[]AoLs<*-:#,E+e8E"ajYrEYrR<S>5n)[T@tJ0!j[uS#9F/TN10=qrGmH2[$GYWlH
qd;"oTq;Q$'F&LQBN-;:"q7e2-46Sbb8L)")2]AG:!F83S=/-l<H9*5FMF<.o=lr5:8g@78*u
TAn3QB)6gF)q@,+\'u-,%<W3o5+b2O2!8*YM[9!e-i4$`^"+<jgi*-`0(o3NZ!Q.3k1:8[E'
>LhR_aF]ATQ!)@@VXK^2[`ChVnTQ)jp4J:V=)rLgXJA]A8g_6I$rRDKW`%?uO5tTcgGQoen2Va
#162kn3Pf-OqF9Xne>#d>`6mL=cP$E%*d,5!RWfr:SliL!+1_BpfmZV>TZ/j)haN<hN>L:8e
f%ur/r/BD($,4kQJ<+\W5g,HgCG&*ks3k#=.-fE_ZdJS^W:d*d&j9Cm'>$cVn)f(QnR[`9j?
cnPnWmDj#DDB@t4V(-eM!CnpEdOHfoUi\!WC-%"PgO5Qg]Adi<lD(44tZ*HEF?Ze9J]A?1Di>F
,5-&$0FCKl+;$tgA4rPbQ!uql5KXX@_*"*K>STOH-^:Rtj?NIs+a;MCeTHb-,C&qJC3=NO3c
VEsFPOZLC1>CK,2bn`&s@eMB\(67NPY@SfOP-'CNqMh@Q"!?lgiYm^#JYkZZp4e(a>"cQ$>U
cUFl>_&#7Up^*hHr_+N!.'a-dZ!%4_pJgY:7S`-E[g`dguoHL)#>*%?ABpj&fB7]A1K/c']AO%
]A%%J%<DFWgROPh^JqY;'t4L.BXgL&,/JcadOsVnU\f'&,P\Fm0$_rqo&HB@m5anZVR9JE1pT
<M\:8t+i!++RU[rpZ!cDuJ3M7\2KQqa9N2rZTGrT3$n8QYbR7D.<+/LiZTVC$?RoJ(o3*.dO
^*=8rU2_8,Lh7LC#g_C:=1JXdcc//IS@OMiKA>o+S"Xo!oQl7WV/g-JQ"L[27>[c+?;s9mRb
=HSAb@V?\hs^q<CB4IJOk@*Fjr'KIl19C?I?;/L0!>7Rt\D/ema,FEu?FRL7NO3.C8,aa-bm
5+doT!RmZsmJSdD:JHkP8'?Hu(kF^abI0_9GJK(3`DWc"qL`HalbRP\niqT6<V<VHTNtFUs*
n/):q3H'f/PLd2Lp_2?r]A>StVD&L446&@,+)9/B,BB>j6t\UGIfsMmBt^"TPlK)5232eU+]AN
o"d'M)+f1+72s*ZN&rq#\c>[g6D*eC(H(%Yp_L/Fb51_DF$F'c"&6Cu9Nl=ju]Ak3'`l<#2cG
Z`6NlS8ej<R::j9OH$teA7`N@&2b2S:bAQD!#0FLq>om[CG7+kOse%jJ@\=QD%p#;/fPU3Rc
AHO*L(IJ:!*-n_ra4B&IJCqHk>1V%1/csEVh,c%K'TtiuLl)e6qcSkBc'<M<E_t:55AKn8=C
bgFWug*oWeXYu*a4/&S1P`T-H\K<jX=,cFo)/o!uLmA*>_%CaetgY5'DL3^BU64.HW<3UrVP
N1TE%Jpld(u/WBe?RV0lM&j?8bA-31N@Hq:Y;^O\/TXSVMGd!fYR9sabX0H<N_$:drs)AcfJ
^`p[riCLVO[R'(r9$:oXM;%0u_X^EaLi`e?Ft;n#;J-HAX?>*Q&!:/U0I1&WQK6NTto`DbiG
WD"0jp-WQk2=BH=SN!adll#fafi%$0%,dS&""V<&%j`]Ao[[^SDp:dFj7+[<3Hj1Ui;p)C09f
,lDQ,o&5Zh5c#c:m0!7u\a7nG9;mSdVunF1U7uG5[XEal2tdO$(Oaf9P;!KR&@<Nn1l%\]AeH
;KaJRMU\ZTPjV"!]A"?6)P:Cj&]A^rlo_D>UeJNF]A=gXk*U563l*+--ljnVR9--+\K@lToL.o-
qZ'IPAEP"f`\8!UKXR$\)-/D28/(>CE^te"cr"-kENa=>Z#H^"0UGr1mp(>#1ToN!a!="XZX
!3Rr0]A`J?]AV0-I!"+'o_#Ui8Q)"S[qr!gFEW`c*eDZCir2RBWJii8d5XEDn[YHjo_I#s(F'&
DPRl+")R*_mT7H"F(:Wn>P`?$UslJ#]AteqO74tPc*s9)'6A[n_X+RS*euNYn<c?WeD95_lG*
#onoE(rR?*`^sm*E-N%,iC=bjK6MJ>f->kKG;\-[mk>qT.Y_^YZSlV`)/_odE7Kp2!piAd93
<L#O5BIMa:nR;]AjT43*-A<'`WA*-d5-meD7(C:SCrTrtujk"NNBSMI<g;#NLn[B0#0/\o1.!
Zr+m`Ee2f`.IuS@s,0XTKj1RGqmL;"K<<$Vgu[i2(J$]A5Od+T<)"OH,mUf_LqXq_nb&%u>n!
Rq5qo-HVI]ASED2#&2,8^)qH8Xbaj4a&QDR*31m=]AE/]A>:e[hW,50UU1L(`Xg&pJKaAN#NYT=
:&lc.g=%TIUqB<Cjik>C=ur++`hgPLjiT+sE:o.B>n4t86!JLl>IZ!H=6qm<7Th`YWQFf8`l
VcQ?;Q&J'geJMUm`5.mJ^Ga#ORX3fl%['JaOH<)5Ur%NQ$FF,h,P$SV=Yc&NV=sl^kWW"`)J
-:scE:jqeNH0Ij5N!R*KQKQ(QDFdQQdCg[JJ(cJh?c`M<Z7dcVQ$Ba3MN`7["cNZ#rq+fi*C
bPOX=7:W^C@h,i?T.@$[Hb0[0A!aKfM\UY1_9TRX5*l+=95WEO`9b<F_YPk.X'>Wi]An1+/Yh
[81+\^%&Ap?b^3"pSX]ArW8jF7!cVn#l-bB_O&Z>;(j0=Qe,@P<aT31s!aS='f<mqJ?ro$bq@
O:Dm@-46J7a%APA>hk>l$!5>>#8.-DW7]A82R+_'D'As@]A,,CS"k>`fm_1]A1h5>jbZE!'Rol*
79&<O!nCd(GYCP)n#"(o(IpA>.Zort\MSPD;6H*`frs+1k&>O0<-Pi]A.6[Uhm6hk2&'WNC]AJ
PRQEMA?7Kp]A0o_-FSWr>QD;g_6MLp[kZ2F$G<pYSJHl+2M$2()gIproZS)F^EUg5!i=Lj"=*
DB2i9LakF_s]AN;>e`$<B@q6&@7Mj/3PNp#pqFp@o)WD'F'_E+Rc)J`.YMD:!p*F"Ck-M2<UL
]Alde100#6EG1XH'Y`:WTEiMG\Pgb%P8%UtP.'kH^\OO*B,7GNG)[M"@-HL?e(g8U,0q*o^#,
eA-jnOGiQ"NZ/[.h&]AY1%9G0;DW8%;T(Jt"1Qu:!ZaCZAf`gAjXgAnOOe!(;O17[T``5i+7I
<&-\B2#sPh[O0]A\\)Pe/TB;dk%;_Apb^;QX?rpQd,s;X8[eX9[rT%qhu#$R<EDud#c"GN`DZ
)@QVajqJ^MV=f]ArJ3G;<s<@1WPQHs9_@?m"LG_5\'>L*Xe(fP`cJpZW[Nk*VXWKFCE]AnY"!G
h:sZ9=-%/GL8-Va-(^n05Tu,H'Qc"<l0$a#(X:^;5GYH2AY@u0AJ0O3uhqYMpHB4^nVRf9,b
6:N"[.3\&no>qbl_XM1Y(p.DmOi/#_q`6!/dFbBdZh"5F8cGkkH'G0RO,Dapeds%mNrE@8UH
Ze2O:X=e35<I?t9*1thJfg*4YNX2SfHR4ot=\YpA\;MX$9I'&8nBR;c3&e#-C8&gsF8jXeJ1
pCcR+'PUn:Ku"/9#o!cEl%:3IeMeJ$$^`L`B@M8BQ(H9sk>]A_*K^m_arD1qdB0o0n!3:eRX7
C(k<ull@-jQrHZhmOkoh'Dm;$d.(9+Ok[:o>LAc/$_mos1ECe2:aAPGMhi79,,jUbo"dtW6d
<1S61?'QhLu?JWNi6sj(8!sgp_BT/-`,p$CR?8/6[UrV;"k<_m\MAm=l*bNab:&%%)D>q2i$
6C^;<M90ikHLIskTW1!?EV7(/F(A;c-s\<Zq',U^g'n:$foc3/-bXRdho_W.6d]A@cIi#T2aK
\LNOMjd\JEF,t_'q"#JXD5aY[C7pO5H>`I'T9\Hg2>PSg,:WIHn/i9>pD+$A>MN`*<Q@-IPf
-,$^FTC+_^Fp#@OlD>;QY"hM61Mr)]Al@t,L%6Mb1&j@M\8]A]A%ZUIU.t:0T6i-:"Zh2a(B8R@
DI-To#T?^,[6:c*m57kC"^'#3Q9Oj<-:1HX#N;be^9\F3p4%IM--#Mg]A"Gp\p,NB8A.^j.<q
chl)Gqg(6%+!:9"FW"j_X8Ts0C\us6DJ!r(a\M'Wn!N*VHc]A`Xu,]At6AnO$#H7A1mA.T.)8)
)$\9RUXpP>l`rr#5r@%=cI@$f`&]AiQl":uoKhj_j1(>Xq+L%r4LgS$L3c'J3P%e!Yf6ImUK:
oLSR]A<[rIh!s8p%;``sbOmkgo1F/.crFb4T&hA2HS&6,;!SD_BFM?JffS3KJkY\U-RtiUL#^
?PbU70G`NG18C6ZS)6oa5,\CqFAr@Sn`kFI$VL<Dd#a"O73PkNt:mXZ?(6MWT9Zgq>)-Pb&U
\V6UT8b^5M_[8Da&M[9:b_iF^r\\-P_FDiK,)A.$,i%dh^22l!H"\L`QoY@#Ni7BHF?U:`0E
sC89k*V!)7;^,&\ac08TYK;M=>I*m>h@lbauonT6VQ'f\/CLqcN/Fg/.adm$R*,CilC*#MSY
R:iC2PQ8\4J6LTosckIX;5IuaV9q?>&0'b)gF?%`i7n".cIXNl.2&':sJs%r8-:ebM,s"L,<
-IOuuTQGeXN]AMt_5Tgd*"JkeKMc>h=;F9i':mKlL&5YE@+s"UP#m/Naoh3Z"nTj$lqonn;f"
-c.mQG4OhsPi`>a#\_F*Z1M:K]A'`FZ)3KI^LaS.IR=O4eF*!7R#,A/&^NI?-=Q`aI+*Mm[:u
DnPA$R<[s$(bOkjce+?:A(-HihAI<#AiARK7?]AAeeRc2WkmO%JU)mPZP^.!RSR?&R*-Zo921
:<.6&=6WdrI_`@hCtO'gYp1PK@n2%F[kZkp,9CfMmGPB?K:J`_%KGL)b@e$M0\P[CX*_TpKT
KG?A-7eA1dBHb8Q",3_1QE6Z$i"M2#]Ar4bI0Bq*&<63N\)M.?ZT0F'.Sidh!77Io6P="6kZ?
nQI@M*%$?fL;QYQrj65aEkE2oU?&UO/'4s(XO78f`d-[NSu`<g/CKH,+-P]A2h/GXm9'Z?,YE
%+i.FDaR2C>$a^sb+k<TKsl9.rB0YDPHm+ol%8E$d@(k/RM;]AmTB`5'TnbEu:#uI^;qcJ<@8
7TY>!$C9LVEUnToh^aY+rQrW4]A;d3a%iRPcBpctWPf2Z(S-9MJKkW67r%AK+KidhVfD2h`65
;)aD;j[+ZcEBgq_BBT9Z*NVi=j<eVI_cIJpE>*F3m./iTg,7aUCi@NEX`B=Z/e]A#.Nt$m7:N
Xn]A18_f+%k*[&U,ruX370Jc7i-sla2",FPc"Mk1![,:`[MmCE+DFd:fY\oPE#jn0%P)LcN[O
L\Z7J_j=rd^%P@PaiE[W$f8p9FEBNFQG8sUqA/5YT7&(">J9=A]AcmIIeI]AEo:%=D11:A=D+Z
s7kVdukFdqS51I[f"DQ$6MdlVt3smDW,#nnd?4HsQ(+1XeX;J?da]A7.C(ZdJf??NXW5%M]A&G
B`E$cn_d_(b-&!6e`]AgQB>bVbQI2bKU!W.TZg/_^m8;b>/:ug0W2F3.;ML5&4qWW^Dn3t9#_
)EKD[A'ZF;7]AT&3l@X`93(1b`5Ylm\?]As;g3:fkqqO)J#ZQB^\qk-ll#AgWT5/RE%+m:S.TW
DYB%H;+e.pn-9"A67^2$g28mbL9,*111+YL;(&=KLD_*-KD]Aie_8f-HCr!p)42f3lDsToL4<
%B8h'8h^XcBm:LY@,b.XhD".on>G>ZU(31;gIu4lBO)7,(\&78F]A)TJPW"/Z(uiMs)sY_i!u
\!oS89\.D+u@1N4VbOLk;+qJaBki?FYI+^Y^0KhoH$?YEcX&;'P*n\\Ak+m=(qU(YbBtm89e
T]AsZkXj-rH.*pU`/PbAh[_8e>lhqZFMgr1;l;mc%A1R0t;[5gj8fATdt&u^Yb9*jlY[E?n6E
pIuGbrHMm[S[9ti3X@GirKbBThkGp6\R[hN<4_M!8S+ZNnVQi#-:M?WGphp#&7,tUB\')+^'
!9%b=E"gL%%3.l^)#>Z`:#^4'7+TT*"kY0@((%Sb[fT!J<8s08tX!'4nYOo5?,1H+:W+P9q%
p@MYmDSs*ga%9"G8)FZ<\T1:_%>9*Rj<Rm"Ghk^9Eo04A^gf7Tb`==Yl$FH7HnC)d;ja7h3c
]A:)RNV*7aiUp5.='%n)n#3k>;dpIA0)(bol?,]AG2NVbUt^UT^W^2I\WHBuo,nIH--\.pX\$8
f.X'S.7HN9]AX(8%M.XC'Mi]A71\)78*0UGVc?Gb1rm(u''WPHlCq]Am5c5"^B"V9&3Qu9bY<SZ
X3K8/_fo)D@W#D#8XIUWJWdj4OLCMf^5#G;+!b"m%!qqGP+)eR+mPfU[hh:aOgbK10bBjRZZ
$72BX%G%TBYoq1c<6a-d%bc\UNTI.a=f*HsM]AU<S[d)\Xu;GUa$^#4[8ir]AaXpTAR/);d3PB
KrZqnVmjHb[4-KX<eam:Fn%$71]AH3O`(Q+,_)=60bZ+".)[B35^1OCCO$F9#@;([s_e28\0e
=iCg3&[B'PnS#;Yn;f'FCSlb;DT[,``NRe0$p>:?GgO7Fe>@_#?/^a\(9Dpkf9>>Ra%3:$Pt
0@S\r]A/cNb_XqJ'gP\YSR]AV/\[fjbV1D_[f8*`*Qg0d`e&S"s2\W-F;\*10fSS,9<lS6@<77
TD3PVUgf[.1gJ*N>AU@kj1f5HNBVNfA_?X8'S0dL>W:GT:b&W)u8.bhl^0qYdFZdXtTaii2=
_]AK(#i@&P)8HJSk29HW5FRNe,V+\:Ip&o#I_p5\9d36gh[rPF:<#jJDu9H%bIJeN]A$Lh3fg4
dtA7n7!BC*L3V[&ic%%JftF.(D4,\p!SITrW8N;i_gDo5H+G,%ocf'ti:B/_MQ^g>?%W,C8a
4G5)-Rba0<XHcgai4G<eV(8XN-M.._Q)Y=OF)rU0@'^C"+Af!4=s0X?h'^n]AX*Elce5qCLkc
n0%u/lG,bth?!j:.i#QSP%ulGe%=f7l`NY`SC?!+4LnLCq&mZ]AJ(/Z:>"G1suN]A;f^$@T+TE
=g"]A3\Dg]AF^:cQl*Uj@q-(_Z-uJ78k)0qHe.LpB#2.8MQ,OrpblJI5X5-7I\J(lur4qfc1_\
p7)`D_"&^LK`pn1R=$3toC&:-&^?7H=Lfu4bqN9'c,DVQAc-qCkQ::'JFGWEI/#9Pc1Xee:s
mtu;L5/DJcAVEFR_^ej8hX!uE[,rb+?HR$^jH/*h5#a%RIK#OR"Mu:10?8[Ii^2MpA+*m5CP
M8"l,QT)a"51.A2?SUMCFhHWr*-(H^?I23i"nG"H+.Q)1A2Z7q?A]AC)"Wdd0-EZSpr8;As"+
p\T:T4Bd@cl>0(8+^[]AhL*:E<m]Ag.V)ao<e[#gD>(:*.YF.)uWkdLK$n^;g-=Y-KWHK=%MM)
Z[:9Q=e%\?^-Yj&e&o,0rB.o^T`/@qkbtE\HhplKYL!5rVPDgNTVtY$8p]A&]A,!jp^#a]A8qE2
pgf%(+8S+S/W>FN+u=G-'\K(<NR1mg+>BXQjT`M=,M4=-h\Yg?T8HoGa#F`>heE4#)!>h-4#
*[bb0+1hpP=?<BUq)'i!!,r6]A\<9+M/ZfZqJhmfnDg^tsEu1?!gd5ofVVp5#9;p(X>fTD8<J
8PsQ]An:>]A<*Omr"eMq<##RH?GoJ=S:FCI0:$TJ?d`C-_JZ_g!Vq)*C,MOE?b7RHP4b1J]A1$(
5o.4jY.-f)MH9\]A3$P-@2TbgNW$%Ib3(.`\5I3W>hJ3->(%=PT!eNpHOd;6:@InC-5M6Xm?S
UE>aI(rX*=1DUCfYi=R'j^il$Y%DmV6FkJR-4#ll:cXRb^LPn8u:pd_U8!)O[%(J6+F@Y^i6
ns<5"afaf)hhr>A5o=c]Af_a7[>GMbfk8aIC5a#I@`jbZ:kdb$''E3lbL`i,\Se%Qfj;VNHqj
a``p+KXu7]A1l'Ga2XInnrCkGChG'e@dQA\%7^3H+(XM0s8*RJU\BL*4T<CDo%?m*JCcZCPjj
aC7h%"=LqY;F[O[SO'f'M>Tp3.7W);%e1>leO6pr84Pp,;M`p3&=&B3H?K-4Z[1\oV(\938R
52S>B`"Hj2;AqSAR8I^HIb]A8:5>`BDb+]AEJ^!4X6pY:6%_V=_J"cpk2d&)._;``.u)TCBbPn
MDW'FR\7q:$S]A)XI9%^0@Qm7PNaDln8<Q`+KZ4/ab^t$niB1\Y5kDD0N<,H0[E&K5Ih\k.kg
S9V_7OQCKH)VbcR1U3=]A<PN\"utIohGpY-J8$D3%\12'5*VpM_)k9JVlGD%)5ra.kG\h&E8+
"=g>=<+9_rNcU.GLPU:na[aCr?3IRjO8qen[qXko0Kd,amWB6(o14D3Xg78\;1`MR\XY7+XV
KgdYomGErJWLlH2+cl*K8P6MsV=;T%d1@lj`!4UM]A5,F0l@$f*<XVS0Kqm1[=+8iCW3u2ZU%
WQ`UM%;3oG^rDDcerZsTecuXGD@qU:t3G["/[I!n4q]Ale4F%Q%hNhE#M+878?&N4gjPjO[;c
)qn?b-peJ@3,qq0M[a'?sFKs7du<M\9+%'douG-f<(b:/T8W%jnD4Qqi6$IO1UTus6OOY%"V
t`dM2;&cI<Q!Jt8^<81)fb]AF?.X/(0t)<#!fr;EV)`1O-!rR(T>J3#$BJ=ZS!:,o=F/nDe*7
Plmr]A0ri+]A+h":0O'AO[^DidVOohkj+bWVVW`<Zm9PW"(c]AnTbmiPHn-4&PkSdU;<`oB"0<*
WQ>l[HL:d!<i%^>Ir';"oU">@YJYQR>G'b"bWC7@UMl,*[:7\+`:C1erCC+7CrNM3@AY#<Ej
HF.H[]A$[Is8akJctot$^%2IU1=8X23HmmM.T>VlPuBSFjD41tP]A#i4\Y:cM]Ab?T%HbUI*/&K
;`&BdF5YYY%:tMIKU,pLCsLphbgEY(YI2Cij]Ad'\T#p6+^7L"re<fP<*kUL[L%t5[Y<,AL^n
i\Dhf;&JUP/Tc2qSRFOeSR;/o3J4Lb!mI3gp0"90^KeF^9kahkPAoLOn8oc&cl=eZW/L94Vi
A#.g0p=t^*b3%ZJW56i<,J-*CBhiM'A)k&'O9`kcW)2i#Xbt(F<^2T?8j-1nrPAPUC]A=0S'D
8O3`TOBG/PJ#:d3X4,?2r>qVku8Bgttd`43C6niZ'2f4hAh"/Fqa7W/3-_\@@OJiVCEh4iW9
>cY]A^O[a>QbE?e.^:]AqUW$;4Ilhp\p.:<7l.N3572Z49"ZEnY-L\_%<K1cbGB*uI#q(@3g#r
qPNN*I![u'ocP)#R]A;0;M\no/ie#G$e<3d03e:QD?:=iT4ZutV9XkmjCSWT:8@mDj8M%bV/"
"<N!UmTf%b^r0oZrUJL!DF*@smT\#E"3?^%BT&Ol1j_hnU'U&d5;GZPhsc;hfL5"5:+Vu=g!
HP.gen1"8ja+hRclQVW\dH&nJ?4?gplEOMe'/)3;0%Ic)ZfpB@QBBZShg3sK35R0*>N.rN(i
a;Rk0n.#L%[s-#C/*+?8':Z/q8m1gXdjXrj>t1s%4oem=#06rioTY8,gQKRd+Di4!+Fn5W:d
hTlL*JPSR\ug=ZTUkZ.lK3hhK\>W'g/Sn')3P=93Ym-1r^.e`M_`qK&skIUX(R/,#AgGf"/e
um>]AjO1"kgVnk%Q.[W]Aj8"aU&DLPn0;<mN"acGNYU@7>oV9i>_BspiZP8mA8O':\WuF8&?6^
lGlJYd!&'[+%\AaW"V>CZ-/N2=13"3E[!sHRiP.ht/Ak=2\lWXQ7$*<>$<N]A88GmNnucsd41
9R3V7)bf%+<<9F@R#Q$#WueXB4r1Mq/Cs\K<KYV0.R$5a?3PRcf^l7Z>Kc9hf"K#4:E1r;?P
oZ_l;7<eG-@:"33T]Ac10h.Qd=@#LB?DdWcq./uZYLup*R2#^=`G1=p,rO<1:UU,'>)oQ'"[M
\VI*k&@ShjOa/ImsX?17<V1/#W9Q`A^F"9#PaNE^CL!O1Wn>;$1U0C>!cE(neSkHG;.ceBkA
ssTU:jcf\3#25AN.ENlSY:TbqEE[bV>*u*RRJ=b$6g8m_g9\nQ&HNBG)VdI;&jiZ:$^ug2C=
W_Z6^!j.Fg2X7IK7la"hh-N,e)O"LX&.oF+H<Spd@[Qa,"l.nQAPPs1@+ch]A"F+`cH83'\>p
^oJp;'%T8\,!e"3>]Amb^%P\.^M<%_o`Pq9P[P^Q#?@*TCUI#jlK$7TY\pB'.__[FA2WnmG09
m3VpuD-[UF+(YRI/61g[Vkqll.]A$IB3+uc_!D-"UKNa?gubbrPkjC8W-'calWu>-I8ph;?Q*
&m[KogVebOgM+XsefB$a1FNh`&PP3Rq@M(a-s$rW`9=&OD0mI$@'Vp5NIS)7%iA".:'A@ksS
0Z1]AMM')g20)-'U9nJ1rM6(aOK%=n7+LrZ\>9r<S#'+N;gf0jZL!b+O]A%7*TSUQjQ$C,k&u9
Eah+aH]A`c-_j6?Q+$G[ofOQ,MSo]A?\RMe9g3ZY5B9WDn<dV5PP=,Q$q6e`A4#p:M'S(4`VkO
gFBLEb^D0XWq3L!%4a\P:u\*'^D#T3+H1`]AQ93BM?BTai4O2<Sl7d?ni&G%e4R"\J8jP)eI0
pT-0kF7ioFA0X]A#3+T.j1`PJofVcVq+lM3-$P#'SK"*#dt<K2k"Xgk$H.M,Cu)6T^ZCDRqii
'F&^X'*VsskEKoHY0=InQbiV]Al02_lfi-d!6*Ch3f37*OQa,Sn):iI.t3$3U%q!"Y>$IQgTA
mk@0Dik>2WW64_20]APIf87j$/u?tWj.mE+;Zm\EBm\:D3)KAR1_9EOJ%;7q!/(Z@EWBi-QdG
-LIf!kB_?*/Rc">YhU4RF),XLpVF/SEgHd!C<?'G3;&Mn$W,QjY`&mo5hg9GD(]A#YJ*EP?oV
@Vk/)^q%^D#k-ak'GB0)S675C:<cU>(SG"a5`SDk&9NDfl?*e!AKTK6,?fEa*gVL*.o%8C?B
pCA(bhot2l*3!NmRWFW:tV?CPpX)52-,'D"5]AdeHaHnHHr<kEom5ArG6%47g$B[+]AIkA<tBV
M,$&N[n_QN]Aq+gBIQObl&=B6=BpJ3AB@P_Nj=@A3SR=Whm([$rrZ>f9+US9i,\rJ=MQW15lT
F8n?8S9f'EP%e/c64a(*#BLt&.CuomQ6o&j+9C<Jk"W;l*6[k017X19kg`8e3ci6;"u?LKj(
LQ=*8b@+<FV\+,7S6W:OIrEh\1:q9fZVIj9:F;X%J)p;2ap<73gIV=fB>5NR58fAR=i:`PeO
LF`siW5d.oB=UI0l/nj.RJomZ%D<75RTZgWHnIfe^"F.Sf.F<=7N,;<<olYG;p^M\=tom.SN
i'B=spER8Nl^oa]ACZ_HL#t)c<;Jj-2,TIA:Wf*%s,u,,3k$!m@&mY[hS:\gHGB!cIi-7mR3L
dNl;M5/N+Jh(`*kE?En,qipH"Y`1t05C"tlK]AD^545Uc'T.1n#<[AT5K0D2tq2>lYF<Wpg(C
9,J)UZ-8h#`7IJ^%bg8A*C:%PTRk<B8iN'O.D_q=+s/qI;4+uUo/mf/u&F:$QLRS3Y19PZ,Z
b(%=X>Z.TN1bYPub`g\dEUcl<+=e_f,(06PJ#?.LU@D=__H31(G"Nmsh*P<3+hg/GMcPD%qa
c$GqDhBn0j=<@F&.FbLm^Htqfb"uGHWu,;IW8dt)FY9DT]Ab=cZb`Q^Z=fQ/_gD=+(41ZUQoS
!:VcBAVFc(r_G.T+S:i,6^YVfY0=?I=kEFqC[aV"+&a7t+[9[N;!fIJ8E:B`Uiu+2<QefdP"
'lpgjncp]A@;)!D@6]ALUs&ZOI:)=!Y3NQ@Ek@_Bp]Ag=q.$&ep\Y)BiUhE4>]A_**q*:1SC+6=9
T$<b_sO#;75eKM+CAa-]A@K)mID(*3Os24]Abk,/'T`IX5C`O*7aj&G_s7fj1#2F[YUqUN8m'k
lpR(4+`g\4uj2f%La^R]A:(YG]AB*fZN::Ja"==e?2"+6ZKK5n&.HYVsX7^4j9P+5BN@)bK&0r
WUn0bGqV%0K[0[3XN<"".5mSiIa/D1M#ih:C)0koosDnXI7<edCI]AS"f4uh!8CIkS3/6\.qZ
S6f?A=1%jl4ppR.T$j<o]A[@FlZ2<S=V<A$Cq1Rm>^%7`[Nn[Tp%WPh-oqd:B01i\H5T:mZ"K
\X$<EA.Yk#e:R3'Na+sqbWGrEh/NcT&<IgjJP<SIEYET)m[[*(>eAV[^Olcf*e>aqr_VQ`c<
dQQ,ENe\Y/lr57aDZ[1T_J,8*]A1;)R,/C>EdNLjk:Y'V@8EWY:'<nm3Oa'cFC8M0J8q/6$t+
?t8il7Es"ioHTeao8F`.ES!#+2*e%k`e6Xp0jhACl(c2@Og;51=>pfP6Il8l*[Cn.(HH):DV
*uWKPhu=jcEY"^M#R9d2>Kf<?,i"Qmm0[NfKerAIfXtdtU`au-)j4UEes`hgd(X"]AG1c^uqK
]A2^YQ<_(0#NQZ$0Q1<U/Mh([8s?JMVtHOi.MJ-9(j=@Od;NfmZ#d?<6faXQ#IN8EoTk8=YFD
=\WdiE;0'U^KhT+4A<j1HYN[Th:,jW71TAEBngYO_<4-Fk_Vr!>g.X?-MC-G5kp#HE,4KCO7
3)RDmOp!`Pk.H:QKnlup$O;nS=b"E8solhgtaa!5eD1l?(@]A(GtW$n>dS+7U^";[1QU5>p,'
=hs"&-D;gCJ:0jTB(#ChP$IUORA$s;<iWg\#'C,qH+*^*a9Z)u)84G/g"'ZkVj*.2(7=ZKM6
:tfl!0Re(Ue9oJj#\40-hJ97^Dl-T:bg!lu/-'?h6q[QaK:CL4GPfG.=&D^05-_\[pLW'+Ku
qlU,2)gA/"uE2IudBn&sGq77!$0+abjZc?4UFkLjHIq@.cn[/-]AiilO*QnDE1X&Q->$T5:AT
_fpK[gID!jI%5q)F@9Hpu>#Cp[=jITHIR7O=^f@@:Z<BfF_"+%@h=7%h6WKc3>)KFIUh5k>Y
]ATY+f[j,X,.5tTK6(uRk>1PFM?f7rLZ0E4Han?fodU*PQ@YM!CVd_1QjH\;rP;N.qn0_JdRH
?(8DIVU\Netk.Up0TT<fqd,SBD+d&D6*?f.,oVg.Fl93E\'G#5O/`S?/n_]AHVh._2cNK*eQK
:S=Z>\&bQ8qm"!3P$=V6G/Xfog2d]A4FBHWObF`V)%UB6T8f!JPhPn86VU276jMu;#>bA7YkG
TQ-=T%h1RG6i)PL_=ijCsCDW_JN_M@h&%*+CdX>2rG4G*hFR5srK>MIW@Xd;\t:dD10#pHB\
D>u6;s@Cf`keJEEZ?#_]AZIJ]A;4%RR4p<6]AYl2:JiWrV1Hc'1#7d3QC#"n`rg:V0KH]AEaE!r:
;pF^MRP"j-9Sj]A&NLP/0JTLcmXh3/qU#*0e0WS'*&A:XE?5%!SuVB4*%>'6Qsl8N>V[a@PCQ
T*?r2+0]A/DGE#h)KAFNKNN&a;:4cSk@jaj[SJ]AsE.a>A%C4k<FuK,MhN"Rr=Xfg<8nmgjt$Q
4j5ci.*1G7@U8I$>@B2eh5&O^"<d"g#%2Je=&j6E8cmA%F[kO^)J,9f!ENsU+2<\VC3T4+)5
W,(,H7!:/#W/]AFmeeZlO]ACS(GRT-(^]AV2f=t!HD\]ATZqOdJg1,&HF(k&_]Aa"a(>7GTlX&G]A1
K(:J[3T(+1R@OW`VCo_.<:=XgN<@C)D3Ijcd]Anuh.oWQU1\J=&n2=!2Cn:7#1iSbs/+5c:U.
Z0jLRLH2Y2N'n61DMWKle%lF#u%:bjQm<LD-"dS4RN&%]Ak!RQJ4r[CWB55dB3$uuk%c2\npe
7+3n!PS_tOauNj8?34m]A`QcD5qRqikMRO1IF<>R,:-mH8+A9&SjZW)$GV2(-Nu9iM/Zcjj8t
;VER$4]A^2AhQ2t<IW)8`Db4?pFFW5Safrh+/i1+@X[[#fI5\EB^i1OKfT,:!1H2:Ss7T.gd-
eU<_OeMKk@]APGk"KaiL36ZOZ"L:[d+&^=gj%/GbE"j#G#>4eT'/`t`COP+T&32FoA8Xh+mR^
[=DqD5QMmA0n_.hYN^iQ4M_tYqAQcJqTrQBo1)q[FX3uhBibkFdd=iuJM_t.pg_C>"E^t3Yj
uR_.TO/n74SjinM4#Y@b5?@/KtJQ_qTPENH:WHn4eI9N'T5krmF5fBhanOdio`pPWVN]A?MsD
f3cF5Qupj-l(5AktKo^_Tkqt]A:J;*kWYm1.b4U,;RO7VbSH6CNZS&t+J[NH^MnqPoR+$N79d
l;EZB`d7uMUmT6$dD3jBn!OFK+3d3WC1!nrbgS;'@7npp!@#5'Nm?U!OT]A.W3_G$XTRDg;"/
-^0f/n$\S?:e\J2kR"FcGX/9:=h&Z\'6=U=`@4'k?\EL88W]AJ/n6,q]AN@EE@8BM7[.!P@F6n
`7`@U*Tk>:$\J9oo'QRIkiiWS$,!h@2D=r^56VQq+'t0J/4S4+.&ikq;.ot2NEl"74@oOgM&
%3\t`)M$rnfSWG)ua!Skj/$!K+M?q25C%;Un^N\\R%,83io.E+t#4>OEH(I3aGaBepoir'AX
m/eU@t+L_g,\"b+[<0N67<Gbi>Q/\:Cu9*e_t7&4bIPGg?Um&A,M`*I?rP-(Oh.)JCQ3j=S?
,r!_I'/JcMUN+&Pm<]AB*ae7Ek!"\"_[[5F3aMSg*XiPO&:c6^6isG4Tp/#2>6Li'F]AuaWD4i
,jVnt(;%SI%G/P")"hhI\_.I/]AZ):u(:3A-\;iqs$]AE2SJo(mj\8VZ($8A9VodB>B^lQ2.l7
m8Zs98g)NrM#mU;YrlD/(_g!"sCY>/cARAk>jomY6Sr%1mRIRH,XAB28NlHWFR1r&tX`O)''
<T<&<b^_g;3*?.R(?pWPGNP)I+5T?chUUh^fPjVgGk;Rdgh)eJSfL-n6,7lWS:!+"hiiahcO
\^n6F&H&rMGPjb8m$7D0"kjsgGOAC)nO;)2fk1B91Z#:h.cJM&b.i'4N0<Wa=pJinBRG_e`Q
LcJE]ABlSA9dW^T*541rBHp5l]A`dq*$*c*Bq52U?u5IE[:2e9C).^/s8n5KQT1&]A`pMVYHQ^F
4-Th!^+E9OhU,m#sGJNu@6\?FLeN.;9W[!&_bh^hWX!r[E?uW-S3>LuLNY*0>j7!GRBh@VM3
I7:kCp&RG-n]ATiHob6A^IF4;6[i:L!I]Aukh;/IL>Yd+U>T^>!p2a)$A"i<W9nPCcjEXP9l,+
)-;B\*-*K`$"P%e?Q5@>Qht(\3DrlkjOjg^9u-;,mNq&QC)(X;0"n'6'_*:J3@jEcC9#!a$L
-fcZX&T/fZedR?-Vl?Zk^W&Wa;6l@#bFUM(dCU%5@PiE\%_]A@sI2`)uD0(uPe^q>18pl+j_X
p%`_P:6In;0LZ\7[ff\JVPdV5jp+>8)CLItSXf*ji:=p!7iHC3-Qi"<je`hLVM'lNf:TA^k)
5pu6HAGqBEakGF1NJVq4AJ3O(-H3N?=Ji<jZq``O/COYWEu^hR$Mc;C62dW+h4njLYJgd9[(
jbE(HN^$.B-7VEP&HiBcY`ZFcHm)N*%fnN>;?hr^)o^&I'^>'mS5>SGBM;T,35gFlC+ts)uf
iB3nJ^Mb[CJ4l[B)lP;!K_]Aq7!\(fI;9$p)+e!%GV8]ASAZP\sXDh-*1(_.s>0t<0T=QLfg38
:Z@W#:tXC,t.X"MJJa:fBXWGjBlQ#8;O\MP0)BUfO,I3[`[0G/I0&C"cC[/J,h@U!LFDG<lc
@.TT#R5>DDH0N2n\htegHd=W$`PI#>CTVnukTp.<Ak'"T*,9Kq3If[A&IMmZKH@"*=sim82J
s_h"hTbd:jLU;T(/Woe0\cOlZ223<Y_)Q6tWdWhpinl'*0*Y/qp/"?_3d6XH+$+%AEj\F*iY
oP2a8m(?A,/hKoQu?t1`8f'?,R@3>@WSES,`Qil?jF(?Eu.A.haTeP,E;<"G4d>fi>f2IkY!
#=UK=[7F^,HT"6#_q%#\J"s3Jt"8p.3s',mKM`eRbH#UfSBm2s,>oDI),f'!6".P")ss)OPq
R4#oK^gH19P_o\o1ed'Y'M16Or8]A/KN0?C56qU:gMOVeG`No?o8D)HTD+p>.<uYHK6;B,ldO
h71-`H3qLCN"nS_`O>Pl%,10@E*Nn-A-f+MakU;F+oN;&9@\_>&*Ul<UmZEL-rZ;$&1.4HHm
Z`_!'8.uP*,d;Frs(P:M$T"3FK.Fk%=tXh3lnE-13Q>h04&d_cl*r`Sm,AqMRGnrP6(JrqmQ
'X4GU(;8)$5iT5=GISGIicL^SQ9$U6J3oSk`*!!=7?O+iI&G$M@G.(F('.icH34Ks!c*sce#
B!2:[i^mEDkCUl#gF0PQ8Rk#TjXW>EhH"7%YaVH8&bqY`BcM\Q+):RU1E5kNQWocCd/h2[sL
c5.h,\-mWI79&:q:Yh>jTAY!`(l:rfEH/DsG*og*:7jr`PE+d$/$--o8Joi:S`+b\l2f^:(?
OCDIZYUUX$42:[12s'^58.pF\-oNF_/d8\.ZVa$cgQ`SP-I@jBHI16#nJiuiD7gCuImhu$%7
AoqS-tB50jEI.?X$80k[YX<.?(crZR0->K3?IT![cYC%<H]A,cQ&4oV+\.Qb^&m)[G(N8!"sp
'cq.SDIAoAVP5oS2`Og?3QZ2!9'OPAD-3i.4mNCs2[Cc\Q3l12U!oRk4^1)YBPd9NI#J.C/l
Ua8&![_:E`dEtdOpW$=<:63:1F3*FSDdk4j*pK["R^OK3#rH1GkFN/C=Jk1QNfcqU]A>Kbk(u
B0g4%%IU+Iq7TVI#V^pCp/iB1M2>QufEi+kOu+`P"`QZhkB'aX8a5XLL='U%H!p5p7`C1r+!
s#Ln)oUGl6UKU\bR\L:CD6^82)A^m('fX49%B[Ta/n5W3!@N=4*p5c*@;BJg;C-4^ZIB^F>.
:YCY8!A=Z.jgiJDF,S5aabnpcJc?c<,9"KXB&W%.Cn<=EJpnZ%$uF.!?te!?e`bDr-3;&oM,
!j_YY6V]A3[3_u/8=6g"[^ggrZPK&'Tnq$Mk*q>Y4V[:)O$Q`(H-#asH9q&QLL]A?U)Tf>%"=`
lHS7\)(:4.O_<\%"i0V"pO/C^B(iD.3'[d/lAD4r]Ajq;-5Di1FLMV=E8,gO?nrp)574_-L7D
*@L4)Xk+DlF]A5IDp<$H":'OtO`M^Ef6s/Dq9RUCk-!M[dl\@)(W$kqj1d]A<f'3q^7'kK[%sW
Zu0;0Vqr-Lm3mWVN[*^e!08p*olf$HdTFr8@EnfSg>uFq@:2AWi5BN5D;n9C^&Ca^+&]Ao+m_
)2l^)JVi9[-7P!fJT[$qDWb1B9J_"doK;OQBAkP<CC'cs_stk^2E'"GVB\0;+5s8QRufS%e5
,l3(.6n8[@9*+:JXL4K-^dTlg'[N[!&7M$_.$T>NJ<?$tOm'(eu$:>rY4bTH8'aqZ0AoH1Kd
A[oh^nV\GJWM,#I0WV6&PN8)0o!T3JjQ[Ed1lN+d3gCImU(`Ca]AoHt0TZU.FSIcp=eHA0H^n
BL_q-T2=,8`hA."ge^?a-70G0fZ>\ZC?1LbhC3\6i_7_(Zt6A4GjSdN&,%QJ,p9$Lb9*$B`&
"?Pl0"7rgYng8;VgUaRSH+L@eb!F_0*5F+$mf0X&]A&'14E8)p=i#/?t0aJYklcTf.YsnfEW1
^J_=hCd=?rZt#hf+=*?uY6;`JX/pWEd:\E%,E@E9Y,W7KdqW'NQIDRde?7YR4fU^BH?*)\?o
a!\c(5OgH`1"L;W>q-Wl'_q^lbr,W5\M"KP/9DPCiYr8VSA"`t770lB)O)b;O8N@0lBfpO;C
4L*HQ,Y)+B,H&2T&@Cd)k?2#+I'6(f>'A#OML?!$oOF6FP%X%lr#tCpR&g+2&&LNh(A<l=>`
g#*,[:[-/+2]A>.N$;lr*b;*K4(M0:&`O$^';mp^^Fe,4,()E`3A+MmJa1JKTRE$8=?)8am7`
_KE'`:R=QU&_rN,o3FmCAMXo\kq9n-l37e6%eKOHmIS&jFX=CV.>+1L!6iWhLiEGLDh]AlA-&
>jls2@<Aa>N/s7Ot^/kUR#nec1+B_hHZFlllK_>,4fGgE-?H%)tta06`GjM_QUT^09oCgLqf
+or_I.XEOPd-<#+5CUu33:.gAjdoKdA98q>9-3>>Q^P"W"#$lkQ@q$E-L_WQHSmjfO(HSZQ'
)[q,Qja`T/@j9!?4s@2K0T:u*1M:/lq:M!/7W0@,8c[tLgc,Tc!d!b*Y,f\=+`?!7UaET8`]A
4NAar4qi*i@[pCP>>Y\n%bGnX;%TTr6V+TL*_Y?`m:_ZDak!sAI`<:Uch/o>MCQ(OM$10M7h
dL/VSVI<Zl_HN3a:iF^"Z\bl#Y@4m8k2R$bIH?6t+,CU&bnc^g"SH#:+/%V1PMrc4N+I/IqU
Icu;)1ZN')X.jn^EpQ*mJD\m)Y^;\ZFU`bgtY"K]Aa,5b-=_7"7)c>"1ll1K,k[V/b[;h8gs2
oM^CW=Ko#)B#uUkFPmr>>d\IW)o1tOcT7@7Aln`h^e<U"S0s7"B!Y6"9[S'1!7LCp19G/>ar
T'Hg^7mhT.-N/u@;9;A1#"X)RV?llO)R82g<o_BgSiAp@*F(tVO*US;PNa(O4pkFp>X`,,C.
K2`Zs5iUP'V,^\RTV`bHV-c7_<H/aqcJG/RM0]AjOV=_Puj4KY-G7Ua6_BhFt6An63JWnihdJ
dW]Ar"-+8k.L:e)R3"\.*DYPK[WY!\r0-+gcT-(h.6b]AdHU??#9nl<nD"EDqY55_pB,\K/XD'
O^Fh=k]AeK53uR]AufWtOMRW/-6]AC8f[JnL@!b^n@^(o?6dm=2P/1'hHD>"B3k)c6Gpfc'r-fo
4/i02N2SnkpbF8%#n*P17[tMR""uYu?X38D,5n1^]A*Mhr_9EM$@3I-AGR0Rr[16,JgRJ?/>N
`5fdY6WhpN`i,Eo]AQ\+Lc'\*\Kg8(;8gU`Yh5A\T.HLoqQ3iQepZEK76[sp2]ARRt4$)emagc
kY>e?\UZ-;4pk%(gUX'JefZVnRXVW&+9JpS?']AV8X=Se%80a]Ad5,"uNhBN\Us5krN;66S0WX
X8*tAk2,FoQ$JiJb[f+QD"d692,p<`HJ4'("bYQM56a('P9ZWE]Au$:W'4o`",#4STmVhe`Ff
)@tkpY;)[i2[SRQ[nB.[H?0O=Xa]A@q`GPC3X[H(?X2Q[B/!V4*6]A$9U/cgliiZs#7ldRLS[i
W'\jXGS,tYR2A0's2L7HkMkBCY7A6-g>IV;grILT@VogIGno*UW9N9N#DhgY@*Xm/8=FZkcZ
u.,cZkh<G6ng<!F,k3.J(Z^M28&=]AVfWu]A%mui1*1liGGkh7t2-%8]AoMt#1DKnD%^u`cW`d8
C/N[U1!9toe9G]A<p!rheZ>+T)\Rd/,/j-#Q/Mc'Bo*j`^)[n7dh;P=/X8*+XPj\[SA0-;GWP
QpKZ]AU1L4Gf9Fp28nT]A&ZC"le)E<i<+dc9]Aq"?VMkQnK&OWsueLa!Pdm>T]Aol),jC+ot&^qU
_Bc)b+gH:u0&WWYOEDDF9B..c'k*:+oK;blTkN%cAo>`%LHrELu&AEh"k^?E/#RZ4?0Xg3d%
3;O4\1qDE:]AG+7o9UG6d9^K(6ML2ZOUUZ6e65H$'d@t_&Ba41Bjdt6Yg*aVVXcdcb_+5,A]AH
dsU)k:[#8-)8sTmpu.t]An`W$HM,$VW-94#Ptb3qP+=I3/"p1;oM5Z[(*j.YmU_f.=B8sK\*n
%-T.?P&W%LKhqa:mX.i@8Wl`m;ooIir*OJIe=As_rUNJi:#W%?V#oQ0RcRG'J,88W;Q#aiab
)496DkQi0*4*('k8R8Z/Z6b6)TtDk`_E=l\%75hQVWj]AAF+<oJ?'c%,p'(14>@eiXE[QDuK6
tZsbp9+IeD)"p>sgccNG.dRr>gZtFS'mj.IIM/VnY]A9c-e>;/_Y+-p9Z[J)`?9`^p-IUY&3a
%VZFo\[j4r!Bci<+n\t((0:='2hs7G.oJ*ajh+QtT&b2o*ZpWEgRa>P!%gS3"+1&`fTRm0:S
=VMC.JuIJj6)U2r<fS9kk:$/Fk3DnXCo.0?3%;-Y-M_##g3i]AL>0FX*G$8i:phHe5&3dmM8E
jD`m/3q[%;(u_J(`E-Fc]A*JCV=7,dl0(\(WYfP<FAPNG1?oH5*?M$en5hNcrr*W$/]A!,EUeU
]AjkF7&B7VEGRMqk7rJbiC&0I&;@RR9*>Meah1gc0CcUB8eMoSck+7urc8o`(3N--S)`i=gAR
&$i,e;6UbnM&MZ/kFp'di6O,TCi'Zp)*MhR;88NKT9AZSbUL[p*cLY?/ji*H*OU]A"P3B+e8!
frQ$+,gte"(`Us0AGgK"SFBm$1\OuKh]AJlml>a;\S8TG&PPucD>?ae6Jk,I.7JDOmZrpUZWj
2oO]APq7d(",7HZnf&J\QCI)s-$eSj7m5_/ZL_ui!k<S<$^G9p^4lQ$*J&.<:WLX7Z?O#%/uE
P*ZrE"mGU*-QHtb/1^7]A3+JQJ^j7f;i+fWuSU6nXGlprkc+SL@?QLPAG\"\a^,p.p<4k#)GM
3jPiqQruVVY=pu5GC-`#ONecp$icUdNb(+SE+[lqi=:r:V[ooO?HmPT/UG-@0PF["BNAu0"B
6Iu8?RA]ANqMFQXSi_6XP5gE[7KjkGR;n>?PUt+4\nHLp+D[9:0G;tGZ!".)Do7VDZ&`Q7JL(
a@.1LgaRr!Lb.2$I!n/4Q?I'#nZ-#=Fs4<#%r^J9U]A!2X=SOLU1^GC+-lpaa\G\,elbLICV&
e(jWEp=4K'!X(:9Ko-.;F$7]Ad"l9B'=;.EG2?gqgS1$]AVd[e6rcsba;r!r%`N8Y^o\%h"Abb
2,73A#CrR9$D1&oHDeiJ!S$+.HSj1!R`5*c5.qqc,EFnr\QfeV6sr]A8Ju`P!kb<-m._AC\5c
h.ck>IAD(*ce3-Lc\K3g,3OADE049X2W^ZUmi^eOf"!Xb9$:/n4d@S]Ah,VBM-0/`e]A+$A\.J
,Ts[bQ4;@(#(@_QJ=?J6%HQptiq,A?9fW#0!sV0</2U1O&P'A%SR&^u!]A(6WF?E\)Fj%i356
gb5H>5M0Jg4fISl9a(0L^i![-lUr5I\ku?GiEj@?=O_oR98PS!+I(k&X\n+&ZVcbW1V:WKU3
2$:jfamk\^;=Suf8m2md=;#\O`[E5q\DM+g[md1]AAI_n2fW@uq;f@_Rj7f]A_fY"c>TcjmGRO
IEs0aI`cr$`iY26o"2OE7DApGQi[:(lcb\&-(aZkdRjMnPKB0t7iY&4>.Eu\$7<OVG'[EX34
7^Jq.,HQ/(RF9GUH*l,20JM'U2)V26d&spXJ8F.(g.ePJIJ]ADJ?L$+ri$5:E2!!DoB9;m#<t
tRo:&KRmWV3=f[I36YZCT#'.JGgumWeR<k)2)kMgRdf\2qFT@QsYp^=mOJ`F?TQ12^nii+_P
ZoC414cXgjL06neI.oAT-A-r?,5Iq\liRGPZNWuOF!"Xkmie)&WI4t@H5*)4`KUg%10S"c%a
qj$b9/52;6L>T&NG.Y9ATphV8diXNGlgU"@5NS,+(ae##P<LYUYq31S/jBTHZV$<Rdm-;o*H
UY/m1I!rDAnc6/YGEHamh:C-'brp@.`_H[[kc$9iq(%RVbW`H-Mnadq"cLpao?p);UIa<>SP
Ls2IgG*%no4V6GT(P(kQpL]AVO3K[G$ft<NCZ<Ab/'&VU1q]AXTuY?ou8d8ID;7<PD9d)MZiAm
S.@3Gi<)i0:["3p\T!O?-mYRMX^eD^)SG[gHP;/RmLXYA6Z\Y[=b4a`':9IFR64Y*W$6(<j(
m0=3+]A@5"6fR@<*a<4It<R^W!sPIRdaQ!Q;lj/t(Ym&sc3\I$LMQ[:kqFN61ATI/4<Mld\R3
]AHc$BhGY%dB`F*&[i\9Fe>]A0k*F4T<s^]AdgcB+/F0M4al'&*Gpp^nf]A0/AdO<s?Gk>j=!G&Z
&/hU::Nn!3rej:HmQf2;%U?tHLtS(49K'm7#qZFG6fPdOBNbrY(\qL$)opgS^?:i"!B5`!m\
*L%1=?3FeC.Z/%boIi+o2$p5=X?Vs<DdbS!?S"Yf;PCb5*9Ya4<GU6X2elMDIk"u8[:TBPAC
X:BX78ZJlrG$N_o+(5WSS6#XX]AKq3_efu#8c%l-7pKRiN")'jh,8`%$L?B"APrn?5,"Xk6L.
rV@A09\'oGkH<aD<cK(FtTD7]A6EMdgB^gkIC0$SQF6/ee5B%s5eM*&7Xi"VNgq[`THp!(l%N
ki\_ZPbuc=hd3,c+0rWVt%Hm[X>m"F-P[eb:'#`(74$_?rd)6LT*ND%=4+eD]A^?%.;rR/GRu
ojrhr^Kf/t'(BQ#@IBR3'PYW^4`Ri%O1bdhsRc4IM3\%5U_D@X<]AlX5HSln?<q#$pGp:+;^"
$*QP,k_AHJF^0^]Am.+VKS'71((%A;)5Mg.gd.t`[CgjU:>4hE^0o$iRETr]AJF!YO*Q?Rq_+f
6-r@b$FT9Bd>_h]AQ"+QD1Di8#B=PT<C&%"7(Q0.9C)]Ac;+*-L?g*TOKoDpg'>*&\fW7Q$[2.
\D7cV2G[TO#oWXDK8/c"-_9V#&TNbrI:hn@)etGSIqbk3?UQI]AHk^D=gG?^ha)*![Dd$LiO3
s3A9p6cGaW<ML\6(a3bRXP`(/,caq:\f]A&RZPu,[aYUX+&3V9I'Z@>pb&0g9:<WFO_S']A-=)
(j3A)e$jBH?+]A3d=$&4@QcP43%oH6'HNK\4u<^V/J$d_oq@PN*)"<,%bl7d#\q)X&oTgqDa6
;QLSn@&:Voe8In0T6kKeCC$s/+kq23(clt'K:"@`CKoh(=P[4q7sJpPDnB_b[7Rj(H($;&7h
)Q:#%]A?^AG-5n!^BZS:_m,5V=ujDPdQg(DDX44Wc%$HU$#/b%sHA@r@@9iCueCBVjj"h^"3/
5$CVu0T=1RU.0NdXjfH_^&fopL8KIH^9k\k*ctX!Hb#1]ASD4=q6DP+g$<00tpaD7!Rfi7i9]A
pZ[5TXhs4qW>,.=c9F(;mo'D\juU^Lt)^'O^F)$V4(HFeNgh)U<i/ci3(J)HcPh7i;+2Wk>h
%M%q;KmA&hrfa/Y"V8Z5%?hX<HsR1h"FHnq;VD(m_X,]A!62Z)O'?PT%,N*1Yt+s#o_OHYfm2
.oSd'F[5GD6JO0XD6`%XV#765K=m1@VVf$\P?HP*'3Z,LCO`(1Xr-8&bke%&<`>qYhEJ:N:)
b4dO%K$&$e@@FQ]Atn/*:Bn1c^bLBIf2<LlUhLaH>k:q6uWGjF!E3!;WIn2_N?JNX4X'>'2s&
^@_9`V8U;Y$\d!V6PPhtbl<5_O>3`*Mm*k%Jn\Pd(_hkAGm3o%k_g&(@74pZpJ+Z*)$^@!K/
b;1MOaF3Y*llj@iRJe1%YLiX/DJ+X!J'.5'2Kg6Xj?kDDR0*ZrG"9$fs:l`!7&q571jQ:\XX
Nb8Kn^lq)Q6S[1V.IhJWn5ood1rL;!mQhB]Ac#P6g%KG5I:bJqD!D.,]A5,<OfnS,QG/e:4t3e
;dKG,`j18]AjTQaI>G*s+@YCK?=4Aj,=[eel!3s_McgP*%Vs[00B6j@S6bV-4QjTN^AXG?`ff
mZ,Gm/Cd['3nL^HKmDjRf?dE$B7I4LQ"tVC4;G*5T()X(3idh;L&+"\!7jpr+)qAYRu$+lB1
<Qs`SD2'M'f8q-Y=itQch5tlc<b2)YrV?Rme8LZnb/\B&5Ojo_W'b",liNV%.QL`qfoGH^%S
$=Y5F^i_k>se%a<_N:[he!+S.,_,GlKSm'cm=V'->i4b!gXEhWN-BEO&DG1=.AqK!)klt8pG
J!]A#G$UebqFq;tZ]AGj8ub%Z<h\g0md:ijSqmlYl/4+m/Vf$:dG-H&qr08b*9L5J)63&]AS\u/
_7Ue:[046`rkHEX3?mhb1+Ins.CAWG@B;hY'%l./]A7B9UHHrtd4U:0jb+\*o_gR11=hj^h:=
bYdal)36o\A#Io`bjU\gCa60KOBa*;3G9>,U5^90:C6>P9Bt3A@/;!k'I]Aj&l5O>sCJC4W+j
e`4gf5:?bYC<lS;W-J4I!^JTQi$h,]A^c-<!7qR-C(W"k:pVipkQ0;\SRk^tGdFg)!F)tjN>5
6=J"/4rjX:"'%@4YN7n0<L8\"BA:&h$HTgDt7A:V:>;5r4e93S78@`_b>Io(lSOR0c\KIoTi
0L1)-**fT69/a]AX"&<Y11*FoB*pfR)3or5[%Lm#@P<NT2dI*-2"VYjYEo]Ag@=CJ:72(0q?qH
\&AefD0k+O]AT)bsg@,%rgje0"Oc2#fpTU"0iNUe^?Q,.-09Ze=kQ3gZ]AH(;.X2]AV>$i.Lo&f
Vi;079hn#UXrO2A5mF8m\<[rA75nA\#>&BBSVr%(bhJch_T+a!rKaq)AJern2e?Cpl&L-i1I
1\#(G>M0=d_.O\P._,dmH)h>d-o<Jm5qq46trAT+1&jBn=3T!hm[@blZbh=t[nAoD`s6=["<
RAG$(J@W#a'd\p_JF$75cl.sh]A\,j1nYu@&8[M]ADCX:Xk'O9jpT=.n-C)."0^pSIgfECPnQr
\[M'>>6Fn^uX8mdVbZu-ZT;d$M@l7p`d0A>!p"RYpg(=V/nQq0;R[cIdAraOmE+U&a7rAI:h
ZN43a8E]A;4d.*j]Ae6s";6\n%n5r438G3"mr7J3jTmiErl[hm5WP18=,;m[T#3SaA6LX=A@&K
2>V&(ZuA_dQ%YOT:s%.i>kqU3J!bE@3b+3&i5`#HZ:YlsRC$jRDAn+*[:kdL+2pXr=l82X!i
X_=bP[_847l5%tHdSC??=2sHYp`gGVsE!PB\4CkS<@%Zd9C>J`Y2sWa>QVL2Kr-CMLUJ5[qa
4b8nVY9q=Se?P0r+cLgMkbNl/-.H(A.+D_SplNLd2)bA)o`3Bi'cX-G'enhjouF6:O?Lh*(b
Xj&+"LcK&*/a.PUq]A`nm0T?#P\"&qdAU1]AK4+*1TD8:Klt>-Aie7&V%WT"rk4tc!\#'I\%hX
n;lHT!11V(iol78!EmI!Baf+0]Ab,63Z*nG#^YC6#BH%N.K7id"1a!.6'GmB+Iql=0IW"e7SY
"OsYuuMr]A?]AL3bJ=Yt%aH0Mo%g\iCW98@h&]AM]A(R0;4RDjo,qmj)$.\T<DW2jY$7T4R^p(?f
TqB(2MUtFP3IloP:[3=&]AO[oV9p4<]AGUAMOUP9dT>9eKI;E%k\TScR6r6lYMk6*L4^F=M8Te
oi(+)5B4ehd(s->ZLbA5iL[TKU4_d.-@ps/aOTd#&gdJ'fD.Z^[Z_jneR>6WNq[f$ofU;["H
^W%j_?p:R/2mr[(,F.ku(SJPgcKN[?\%jkf<c:'?&.c3S@T()^KKRgddCCFG*LidLVSn>nt7
C;'_I]A6<iUT+2dueLPs?Gpb`k/+K/&S%ij2W&*]AS2:X6(LOX%,o2$r"K(Q?\2OR7<6Mf[8IP
O0?KCeo(.V)7AjhuVq_>jX4s.0c8mFG\9qgLYNO>V\rd1(9qfCK"5B!g^,CuOH;bhpNDfBfM
sc`[eofM2LRG!@U1j?+1np6ui.P*!PWA&l4&iV,C[0=TC_Ha0mKJ#RE6IY9;RZ>Ennnl7jkk
\$d>^\c'JIVB(YG1En[Mi%Ql\8D?!Pt9kn66Ct8Vj`,$TZ2cmf\j$3*>o;g\r^D=Jk;[jAr3
c8s3mn#Y(ZA(PKmT)nDY7S^oX0F&T'PKdZ6+V6T`AR?4re@KV5`V[eYb&6KdfFHmuhG`,6)A
Bt=b8)<BA_f&GjnoLj1H&]A1Q__EW2Q)0JL=[A!q1k\sBL(HFDcDZ.nC)+.ZH+J<1S^mjsmb@
K'DaK,Y=-NYIKAc.PW(Ln[a!uLIn2'IWcQII2'rcP.Y$[,53IE$QC_DQ?fe*o("BM$a@1;IS
OgL?=EY<lV);"sd09D.?_#-_FgQ%FH1L(a^[<5nk1*Vod^Z=XptS[p=XMm:Q-D>-H+b?4f=(
2C%a75_aj#NTh*&"Y8Jic#_B+a1/&HpMjGjI`Wj*'nK4rS:mhf30G-K&5e@Nk^2!ih/(%V`N
p(\ia5+dK)lS7*rO!M2I&*Y2B%F;lnlFoG_OcD[XV]An2Sb/A>&B(70La4j%NeZS<?P.N!RJk
An(stnDab??G6='q01!CWOo_uQoGZ.<K#VZVp/KERijmk=Tc:$-nku0;o@pi@)^)qRgd%7)+
(lI_'JeMCXEV:io0pa?:%=(q8K:>B&kj(+m5?Mf"8Y^`h_jdhr)u%c9/jp_ZG-IFN&gMJO.i
8:QViio;Q6/aT"k+Z-77h]A?rXUQsB/FeSjaU1VpDpiCFG..((e>=Zmam'&M1eapi1HF8fV$p
)EruM6-ccc]A"Nn%/.%(l,GN&SHJog=!CK1J*7Om]A-CC3X:bK@Ym7-q_Y;%M\tV^eRp"gd&-3
D)PWDD5bUlj[;HAAPAUOT@T<j'<Js&*C1[u".a'EqiA:U`J+#Rrkpdb9M32Zc;kXNX[9OYl>
3U5mJHNIItOc!,bq]Am#%<L"[Uf:]Ak#^U_<JU29FV+if^-3>Mhm^[Xj4Lm?mudsaXgCFfN6fD
\'.e-M7u@f0'>mgaO5q]AA^$C/:ENC+.\]AEeDhjR&>qeB2!TF"2?"#p`(ECI1#HX6l^mOC^Uc
qr52l4,hJ7d[-,e9fTjfcpc%VW,gFHiC,^\QRfXHKg>U-;7mRI&!%OqDWc[O1_*"N)GDc@nA
Y&qDf1Fo2WkPP$^)Fl'ip0qPriKma9A=MR7%DKa(US[ubO+p[$:BhOiIKfM5%RFL0-e<)RZM
Oh#LjPnj^80UNeOjWM6$.D.C[D`U&N(SkZD&.3)AgWn$V/)rXHCB>mV64+P)e7Er<&C4e0E?
9iK:?O&:$LkVg&PeD>q$1Cn_Roi2Res/Xl-j-ed(s64X:O^"&S#SiM,mW2%3<:3_+D^ikPjZ
[1c\<Lb8S(gmtbcN(5<`:HVS]AlL7\]Aen-L1+]A/O#lk1ogb'u\'O79IbgXBfDG0f*XCRh<NTJ
2i;)E6;+6"'X"e23(o$0?3[;j'/dk"aFHk0\Wf@dBGsmmhT&G$EJC\g(&ifhHn#g]A)5R]Abg9
//LnmF?cK^)N9\b?g3r:>r+7j()JGhK?F%>pW`SVa-6N7GkVN<%;=W:#2dCEUN5-M`E(8fq-
.XKP96(qb$_CR2T5.g>9eS9d4/X'F3Tmj@6,uiPfU-7[<,50;$-7^5P\Z'>8d\.Y%kn5g?Y6
f4\\Z"=(*=9E#.6s$f#1C<(QQZ:RP@<p]An^\b2Ek0f5B]A!#W'S+%/h-VNmmP)3_/-$pi)WIu
.h$*MAM[Up"<?5#[DI"(DJdF/0gor]AaZQWKq7)kY_fgl0Pg;!eBoJPbM:k[><ZVc6$hfo-Oo
H^PA&!nd8c"4Trot?LuKrh2H^sWYFhq]AF56V)iAm14c`qG?<X)Y=O+Q-gce_^b@J+,W(8'/1
9P"E(3!/jUAI<7>t^"".uI;)5'B'=A$2_*]A55a4/2qu+;?o8?!bQ%:=GE$F.Y,ph!3\d@D_p
2Gd/nI&<+bC<L*l%rf=%`ei#V92A_k_&'2,2NGuDBhi%jB8M$`4!gq'''=2mWts0;&b@Bbi=
K5@MNlIb?,<?-RqGnT(\(i94lpR$#/R%cu2Q]A8.1jsBbo!#sfbKm@HHg/hd4FhJWo)K)DO1$
EE@m9(D*Ltu?a(IX,Sq@p82iVeg7Q/mtmel'?AZ\>&g7Ch`rWsHaXiIop]AA"%nCj"B./HB]Ad
i=eLdhmB2>gPC_Ge`kD8Lk]AZLB<6Cqb^<M:m1e:*F3Pf0YGHj<$WG^Hi0`=lPmUi.5kSQ$+`
i`dNl"]A\%.kPg(SYrT\gJM^C]A8=)k=UYBk7%IrS?o""[+8jIFQ^6R,06f2OhtXSEh>i8s)d5
;FpM7=RjR-ca,"GR9iqYfY4(Gg\e&\B8G5H>_K*_3=!2AB'4k/Y6YG4YFhhR$Rf22i%:%eP!
\!./7eF_j4j=]AcV#7CPj_[GoKP7u;q`-VTU#<.;^G)J^.!,D8Cnhob`0F.7KJ><M3EAEUS+=
Zej]A!uHa/ch4e-[6*]AH/J:g@\il#GWC6MXi+>X=3N,p4J1=[4]A:-`#!9gPJ8%*^MkU*/:Ssm
>m*\g>jLCpeV]A^Ll&c'$Opf&Q?4'k5s:?'I!,Gs"90VlT.%<c/^d^5,APL$T$G(;e'R)#e.G
;VNY<T68]AD+gV7qr/hc`.Kt=6@ZY_d'Pr'"]ASPf;]A_MpX8i1Qs4_E!oQ,B1W%+2WB)$#>JaF
$qE3l33k?kjnACPqhSmugmB\+gVgB0ec=8OfKnni#kA$gG),/TnS>7baR5iaO!!Eq>:Vb)("
#.i1YmCA?L#Ar0l&f,sJF>s67);MYgbPt^n!_=%L1U@Hb*8?cV1p$]AjEA,97V>jRO15k9&7J
Quim2AiXmFRkmU"A^U#D)9d\)WG1^osRhQ8&An1WOt33I>]AMN6ZkWgC%iDk.O6*n)3!p-a`1
3k?Dp]A^m7#C/IPq2n#SC)T!lT/>s?"*+)1d/?s!s$196W70C/).Sd&5H`pC=HaTTBrbmXr:H
Yrga35#ud\+ENpargc`QM("'kcJcT2CCM.njEI+3H5?=K#BJuVA'$V7sK2r5m.a88gV,e]AE@
q/MDF>BR6Pg9E4[6Ui1c_\d$KFWqoX-9BLe5dJ0[-%1Q.$//*40'!=+JJ*5p+<rD4UAo6;q&
gs-gFhC+Ps%+W&_kq8P\o"e'&g]Abo8KS1Y_o\Je-167N*gUHeJ1I+V9PjT'Q@5)B/R#CIIm=
<pej>*:8_^4=cKH9Vd`:24S*Vj#YO$J<s$`0bQQmN2;8>=\P@L5@<f]A*Zp=bc+3o8e&W^o!a
R\=D(<![pH`+JskIL>>_i;U*>B'Qkp^.4e>N9lMIi^&q7CRD9<cn=A2ldJ?qYn8[gm$s7L2%
1FJ*+@>1:_n)*jhB28bOLSB9G%L0_b-u/XPqLJdkJ^6`JBOYDadKdT0:2?]Aod[[2$8FY)LEG
6AK3]A2!OXD)3gpmL]Am/:]A^IQXbuE/1^S3+6R`^U)77$(r7eOB:)Dhg3"XguhVn!=g>c$7O-g
cd)6SJH(-,Z[YJabMf#ajV.[C#`e1dCTDJi-bM>iTVC(SP:P)_iJVjh?$Q]Ad-k)"&hgCVTYM
(Kr*K?8>&cC,@!X@)-Cc;nG5<R7Y9RluJj,P#C,R(Jt.S>h5UInq.3HkFt*DpX(&s5FUg?5k
bDU!H+'QIN%W\VD9Cc2-*(U`^(46lL:*<jK;\'o7;hp19:pZV?_'OL4'br;<WEpT@Pc>JmdI
i^YU?..$u[A0ht.8A:a.Y3rLGNA>qRLVlaHbhuli8dfK1+s)\!4(O,b&X]Ae2>Ws"J"D.L48;
rD<TGF^?NSHka0i6n$"2Ds-GFDJ4NkJKh2;(lG-Z\rkc\rM.'und%"N:6Mj(DVhiUoY)_\@c
!/"N#h#!8gF3BTC+4G1?)h50"6c=.toJ^TaH7W;(2R%?g@Bni;d.XCgh`&ZJ*[`:%/CMJ5RD
P#)Ch=cMqeqr;P2#4(d*9>VGBCO-c*\LS\#%gc6I^1O+IA*rc55rJrYn5r?$H.3[t$%d:<@<
B>e\,$ik8^j`GD*X41,d15N[?`'iB?c\;W`cH/DND:>$B<*obMJMi`3"oOg[e,@UmW_Xlm\r
n.jED66Fg`(p"&Dff:iC'd]AD^3gl-=bs5i#7)aSD\kMJr/^dU^)C,%`14%.h<OTsSd\D6IuQ
*?r#bNZNqi"WmB###S:X_[S?J:S*MK1A^<jtOM"0psanFVhGkeImqO?YlJJ?oj$i''1E-#pQ
H*@6CM;BJnm<\FIWY3Z0E6J5NEWMWGn,%5f#E'^0fBnrqp?$#Bs'Wb>GP\s8[6A$s*?[<;&5
taY9^THgkCq_U[?c]A"I=D)u\reKC[fSsCONIIu@+.dq%fXhYaVeQ7SmM3\c?,O\7`\]Agr(i@
&PL2X"o67psIj.F4htH5?*g-J.>lJYE4Tr\Yhf#/=8^82Wk20YbS^)K`$rZ*(:^g/H]A\o5W0
WNP.LWto2gI]Ae"`j"MG:&#8'"=<Y!!7HAsWr%/BqGpb\=tEu6XCqetG9DTH3qQMGSCd]A`iYh
76MW8Bc[bo@@rANS[d_ZIBFSiN14W.@Z2=V>o2:W+W#/<hl)-m7>>4-MNfjP[I%&A^@cX0j=
#eb?++3fuO3n1"RW1o,R_E\^(Bn-f0r&.N'EQGs<q+AJ@O2ck\,MW`YG`]AB5/V*T*P*)Y]A#/
kJk*qZbSkXJFYZoM^Hca8i9"N>PYLElrInYuGp!lfj?f1N=gA$mBO]Ae?#n-A&iA09lKuk54`
-2c-FP2boY_i8+\^qS-k(Bu'7BjfB%m6KQ?a[FN7:66;m<__PpKO!<q3/:6Qhqa(kDZ#>646
j(s3(ra>?GlN^c0,8u+TXn:]APkh8A)OGsO[FO.mr6H]A!r(BMS`A=!t'>tCq$=OMWZ*?33Q1N
n%^4]Ah[$?@Fcg(k2'^:O-,[,Z)LjF-&LhC@]A5`*n-$ng3U[YNHnOP]AFh$7kY%Hh?_aL+EPaK
^_A.,:t8>FZ<;+pQf[.POq6o/a8,%>ihg#0**UKtU@X)cqGmd)he?MZgn,dOX?\-r+*@l.j3
FiE9CV-W/CAn(!:B]Ar?_=:rH=RS"X_CCn?I@3<Ia.%E,Miat^#38$]A&A#3M-Kh\dod\:Dm=T
e`]AgIs-5L(1bE%Lm0*An<=..qbr"A[,HOs!5eTgDr;mf8Mes_rHgaS4N"dQ6W.]AQbJ$XTJ'S
D3Sb]AR9`CXP_K)TtKRUl11=E=8B[rYFu^_I1;T@RF%]An8gD67+JcAUbE!\3qUfu9/:+a+'#,
F!-eeN;H1Kbeca%b(<I6b"r!M*jm"]AE.]Aa@([=+aDSE`bsPOh'M5TKO8nqs=jlmH?b*JC\La
l=uW*JbdKG,C'aV1\aD,&ROsJ743^*YJlblE.[39f!fMXiQ#n`GA7>k?o;_U/j(`oF>>>hTb
j6uPE&7"ciQTcmWT/p6mu@dUggH<Jl7q&A[^,6gqt`[`0tF5437-!h3G*#*SkOe3I8hQm5eU
HY74iEes8&:C'eTj:Bt$JHmL`1lg\=7\FLd8pfo"[+;>,$%@at$Lq&_Qc0Blae6Ct4,#76h2
??)*d"0CI\b2f,oYm[U0`nHk^mT;ck(Ms%&@pOG&QKB_W:Y=P48^ioK3o:43Qo@%>kZV+_8_
g(TerQlH.`F,s(D>Q)E:M@fApSG:k"Bn5^TAjNi0pH=(A?_D'nus1jER#SXdq_OJep@lkpC5
On&4)(Z;3u*S=mI>[kKc-LeZX5,eEIS'ku%;Mlud8#+fE"42C_'3>7N=L^eNr0=@h2f3J."C
/IZBfTj>XpOCiG;fKAjUSmEL/V`^-(&P$%J@r,G/:4=N>)Q=MO#VJC:YZG>jI$]AP[jkQR=f0
fR?!eUJ2U8LGd,k;9l2*e\bO+a;g;HXeY5*!ko0Pm"j0=VW/FFds80F+P5l,0gC)$m>n[+$g
F?k1JBt`Q/O[d))&CR1euDfWPi)8UD=#I/IHBe058#d7)t/DD.b$YPAN=rILqV@046O'T(g"
jt6OS7cNmh-fI+%O*h\VYuDrhSu/j&W?+e@jkHn(gu*!8rq`Si'S#cQ8X"jAAWfOZl4\OQjB
3V#+8`BkRj@JXs@=5'3`j;'Z`J=)G_anrDT!p$rp*aRm7=ui'*oVuM<3OWe=6M?Y(Qd.%N2`
MVXhCtAQVjuZ$BB,5EN]Ac-L>ZR$pEbVEgK]AY[WQcX_cg)E_Uj2pE7TETqt9F2H\LtcS\-[C4
0"t9?%d7/WBk#qPMFGOX(A8R"h/3Pdp+/Eg/A%=Q1Q1GWlE_)/HFh]Ab0q`')YLTg8nj40f[X
'lbIa)d0.b93.W:8B;r3+=E>DuH2sc9_Hqi1!W7\/Y]Aagt0Y2+41!Bn@`Vp;k(o'c@5#ImHH
M!PP%miGC3)b0]A*kr_`iKjAOgWDrKeS.a>s/aT%(lL;Fp8oOQ(C7E0<N*e?j1j>$tVY%lg@]A
TENiF-l5BDFV=pqUok]ACH+EDPmp9`G*k#39kH&u`>YAp';Cfn2b-OLQD#7K>`6Vs99"ERlfA
mgC6q?QtjfR4Z&"GE:/p[!@-LepCct+#t-#>p^c%D#>M%me41"J]AEh4J]ARV@7EncTF?n<'YN
5nODd"bSnu;Jb)"iM1)%FOVbq8A6?$)R^o@bB><jO""rOM-G7Z-#&.4PQ"$>GhOcK>p?-A<5
dGAMq3n!pI?#OZ3a"1d]AqfQ*TcBHe,M.*=es;+?TP[i\hHsLW.bJFuQlu,0MgVH?.mZ@5IQ'
m0$GHXI4e+$@5V@E6/kGbt-fWhLC*SJkHH!l,)bjVXjcU.Uq+HJKm'X1J!Hi%5A1S@7@&LV'
LC7MAHObBN(M0"fONT=6jLT5`WS#q;^B+q'-1PX\D)cA+@j\lE[NfHZ6t4WMpK$p^TS,d=iq
$os.G7Au'Z?/BQ)PlEj:*lME&l[G^b]AfCCXmq&$L78ZooMFKVrkifdlhL+!1H)+ri?qjjPgd
%>>6.o$1=OcUdKgh>/8,_'+Y]AOoW,+Fm_^sB0_.\9-MOj2?b%Iis!A5.Xtl(NU^2i-:Iomgm
dafJ('LrkXNmr)]A"'X*2t&66\G<a]A=d7=60klM?bLAWXfM<,73jR0fg"B4d/@C!=,<))/Z$m
"EO^LYPk867WX/e(4QFLk'`A6._7tW-2fa1/R%ZkYBY<k@!57ML&-Rbj2B`gAL3!c2*-kA7K
8Hd%t+6*>]AJ;f)^Gooce2T&`'W>mA)]AJGR>>#j9bBuM^%%6he]A)d;Ei`BAnC$D/d,KS`<h=!
DFR;($?HS^j.:@G1'YOf[LCG(XEpP+/n`C/qdT'NHHGfYR5r%<.Dt7AVIW2+H!*e0'7s\Vh5
#ecE%BMi[@1AXGPA!QuQVb`HbYH*n-m,(%-`*E&bf34P1C(Z2DtFoKFsQV^e,h3]AFSG.7kL:
l6mO>*2AR;HqATZmm4`*F_q"s(RAj7CsT1@:1)<ZU^ScO."]A)UOtJP0\H=F?TPa#L7[Pio3h
B(:gV7@r=Ij._rcT[-)%=+C0-;#<d`'^.fIg4p1dlH9+8!^2jif=a0fKMP#GBE46j^:mX^0M
bughYCZmT4*"OZ2hOk`l;7BrW<YcdE)c29M17H/.M_"(Fabk060B6Rc?g:;4*]A97)c8QQFS)
O/aLi!g2i(aSW1*&C8'6:^9X1VeSX0opM.0Zk.)">*mPVAp8B%2;3Hg%b'!Ztgd+cj>(X*lk
o%5fc%L`)=@`t4=dPrKQo-GkJ]AK$AWpJ(?4*rTTGLa[kn)Y"s1H6#j+W(#cgn5reLmrR6n[1
+[Es\W5\]A.ef^a*g/5%ErahUs1]AM$WRI`/`N`XLO%o.lkN.34K2o!^$3?D%`hJ_t'sb#/<Q5
c/rBU24CN7fN[A4o)4%"e$%VoA81'u7SaHH8>+&c_4*G?kmRJ"VARi6$$T;n*Ijc(I@E=f=J
c7GHrP[mb6d6TnJ&dH=3c]Al9c^2Xd.4'W_t_p[#3)4^APo8K:1CouGdo6i8)7+;sm?'4OkjN
5AdMHts^NtqEfN!=%`#uP]AHI0RJ&^t$`C#e.G:B=Ykm$NsD=+q;PqJ8\NdQK@niqhW*@NPgG
k+Wn)/VXLokQ&^GTPf:aRR(V"bR&7Q)UGpE2S;FTp>*7Wh5Ka'1n[[uC^gtC/Q!o$8eIBj8#
'ER8-8+JDSg`/WHWP@XfPl_Y-nu(&o$h(&5pA[%AL<t3ps7l1^?C[E%"B&U+.rNGiU0EW-M8
\;cuO$2dN?`cd?gcU7O\sR!]A^?362n*JrE!aV0GAX0b)iN:(RuN.)jF!LYS5#^?AG.r*!PW3
C*TY$+=(f6.)jbFqCs$/gRpF6e:;V5R<$q.lcRL!5#"+#\cg&p74_2L;*\+R&,>_\0H'.%7a
]A^i!:P&hUfFBY4ephIbA^+4'lJ!jNDR=9+kDgJ'LuL6]Ag=("ibUNT9AN2*m(gkunMTmr-"aP
gU@QV98o9Q>2RJN:MYerA[Me4:^-2l,0l,6GB,i9G":CrS;E'W'r^TU+#E_jP?!G_ZXVka#l
OVf241hl,m$F#T/$uC7nL[A2WiG>)RCK#;`@t%g!C[:?dGY4@]A6]Aj2;>dlgm4qh]A<%mkkai5
NmJSXh+oV@oL68!?#>5=[U9W<&C_L*4*.*QOMeBk>rfRk3b/k@`k$XnY6E8"GG9X&W@\m>@m
gHNi'EB<#F;YKF$51TdHc"5'shqkCu86h92Xc-,!8pdO>gmAq*TCXU1hGapb$Hnub&F@e0=C
q]A12OrL[YJSej)@fonC<_A,?YTG]ABgsoOYU,D^Hur`g'05F[\jD<_:sHkhVljcc9$[XNCf0K
i\uHi![2ucLq3(<;M.5g0VbgDON`FsKEdjGU&<e_-EpF[5CLU4pZ,Q:Z;U(BF0.W!--8J]AEq
4([O/5(Wc(O3Vq.[@LA*<D;lQB6XBLaNhqB+ndT3tVf@P*92U2iW]A&"jlI:<X[)$FI5M7I2u
ia=cB;'d-qtt@4MgRENCVg63sn0k;\.i!P3Nbo?N]Ai:Kenk'J3&(SZ_Uj.*rs$!/YO3%5_4[
-#]AKGWQG84P:Q.NJrn0PJpGGOG<MQX]A?C@aVUsV:cp`r3cF77W)q'oI0#,A+198d&ISO8jqK
VE@gk8pu42W`Y^I^[gjYl>@[Q/[1]A`%D/JXFJGTjUK@,aZ?t#-#N%P09>L_ru/f\entnYn`E
rP^g%r^X?rk,JeRaX\E^PepGbmXG*6El<Y_K26+0N.sp[4@Xno*@o/T'2*u7+aZ2Zu`e0.qq
_<.9ZFn43G9fj*:DL36Z;"`fD^mk7"!7'7!,+h:bSRhaSuOH8rT<?i^d[RR[>8bK9KO!m\P=
b-oW83YqR[r?adBj6%&C&V@H^HjRdIF.go3)"%FMNR#Y1s]A<X*'DVuP=.CB0:s_FFFh$M6W.
L3i=&$D>)@R=JX^"$=I!e8@;"^d?A<Fl:g@P"J)Z`&)$TZP6NneS)5H#i@Mckj,*,CX^3W`)
]AA!,!ul\Dosli^>,mN'=Z>Dn6co-\"BcIloqT1:phi3FF.=BM0)F>2,gJV+,,.2/n)>hPOB%
<d3V\Q[=iWQEd;9(;q(2/[Z7hm+ndm]A;tEK1NB-<Mh8V7YNYg`&I6**=:X#@dFEbe1\jqPT?
F5;g>rIWVSdBEk(j"h2=("OEi&e>\I91a.LC^sD*OJZJ[0[5ZJ+/;!Sh#n^Cmh'5EY`lk;'*
.T.9n*sY,6?dP?DsQa'(FC</<PEp3*&6i0$cshSr0X\3o2sFI<ArX'_dm#IdOFN=Y?9eGPEn
\2RBt6^k/!;:FBPO(&g0ltQPCI0@?2I.&_RJ6$g$BKOXqo%NQ^"7077192t`]A6Wo%%"FD\8J
+tLAIt$a=qSBJ-"Wm;$m?lr4QXjolK`->p/3rRjff=m6MNR_N]AL([Bi>Lrhdq`<TUDS5r_H`
n-57]Ab@C2+qgtQ6s#er5^Zs"42U9r@Rku>?kM1U1-(5&c>#IcPp.mpC+e#]ABJTgQ/h33RCI#
?R0";*n%0]Aup;EhG(J"qH_G6gRN8E+*I!+SZZ6:Wd&#0h>.;,m$7Y*qGVm.;#q(#CR36^'cb
Ph!L2PfSlqBB[ZGOk\VGsa(G'KeD`RM)f#)Z;LP#J.e@H.A3culE=<u>!+LIl,(GcZG4&Y1A
+mk>\/6k[B3.2rj6'qlj"OWG5$M*N'2on=X?N+4%IFCc5;C?t%l.\JZ'Zn@22A,WMM5%!N9#
qJ'r9fkXIkt:=0f(jSWA*d66V3^IW^NhkglFosc'/mG22?TJ+ZA6!/EPGWI$+W=]Ap.ErH4Z5
DZsV&)WsoQ8Tr[;*Hj/[.T['$4L5!Z@4?d6O;epHWDqQH78@<p/m#dY_PhSBiMKY?tY>F2s8
;J`8)d3(-f!=RN>%rbbNNs`j[^=0'Ek[\Ji@KP1e6&;35\iQ,Rr4N+L@,#&GWaRojh18m-I0
X7XU5t[(q>JXZc73,<2"?q1'fi:Y>\$$2o)(@Ib*<l5)c]A0p)g!Hs%_d6JroEG?Z"/c:0rnd
4R7BCDh>.A<KX_bL_4I)D-![>Q#-(uG/ejjM%i:>o8S#9Rh-ZD6s2,icRZ\=MefNI5c,HZLM
WR!gfD?`.e1B#+eC7%6-=$.YsgVa7'^1$bq#Z$0[QWMh_Gq[K:69/>282gm*4kGmD/Gh'h*&
TPjaMh5b[</bODflNQ:#jcHYj`M>A:ea,scB`lNh;m-<Nneg#&efm2qL#Aq-(*V=/\>HY3#=
B]AmK<-8g^b\_.ZQL8l-7!<pH?.rhSTo!)]A)cXFjZELJB6h(+'Tui^FIs<jlWEpN+ERAXe>N>
4SHMlgL_[!?<<pp/9?SI*5StC#99k1WV*9je04)lYJA^>C#V,+S8M'G`CiPU"OM/LcKqX=jR
3@*(9G2BqYI<*^Y-oB7>97@1(U$SN/U3_0Ei=572jcLlh8HBo7VsL)</`^E#p!,RoRpd=S(4
LFJ!Dq*cC'Q'4+k!:FO'0uqQ;c5,gYu+6EhJeL#cB\K6Y_5#YP"(e87GX53CNXta_3&o)H^E
7U5s1"l1o;^pC_`)AC>4'jl*%]AG4NeDRpdh"d(?>>H\`uLnEF+h%sm!MSJ%<2)lmU0OB\2S`
X%5SGTu_T=NrD3!>]AT%]A(&.R(3+dW8t5NK[,P+8Orb+t?(JE"<2MeN@CEP_5+$C2*5\US_fb
iXm8Oq9`tO&(BZ;5$W.$<,m^A!M]A&(I<`G9NGInK+t(*:VMQ*KTi89=sMTtZB1*apfSnQ[ep
`D2u8g!d7.P[Uj0rf"g2IC\pD/FriU7QG)OKiE>BBOeIFEAefns(l^(9l2mG#f@Ccpi.1Q+G
*L[bmf7E*Y,hAYon&eP45n4Lm3t]AC(n1embF.IbDD02!M+l?GE)7*@M;rLBeqt1?!VORRsKD
o#*mmY^E*Zte3aCB0=W@qLGfn1Ur;&-r242:V!lgU\ls3*XqrUYa:/MC\is<`$RnspQqs6uI
*63Q*#mbIgKp-cWW=",U^h0L2Pp[aZ().&b[q7^`/sZgBVTk?npBCKe3U3@PHWOV/&a9o2fj
VMU)Tk3[8FLp<l-?gc:RC]AKiI1Fp5$j-_$EP5.iUH69SrN@6_CP8Sf:.;=g)+7]AD<'#bGOmZ
]A/eW'A>*623!>1]ALl3k,E-nU-72[(#h0Nh[h@(4g:T_;or,:HY#^]A4^``MR>1Q@+3f5M9;fG
alh_+@hg]Aec"XB<U[enIbSZ4l?ihYMW0dm^sB%'cKpNJ!g,<9OOBD'@3a\HXH57,h5bol9F9
%#ScZL+o]ARY!.&1'#33Uh<D_M=$[BiD8L0*ea_73TS_X>b?t.?cU)RdjOT$g*-&9r@Cb,-@K
OSBG]A3Cji]AYbu9jS)V(HJMR;)g-GuqH9+?HG]AGjHcU!J8\OnY!%3*ScP=uW:@T745oKc]AN[Q
g5D]A&t-?pC52:!>&KHq6&517";Wg^/=-!b&$h@L0]AepYnj3>RkA%2)c'ha6Q;Wjlh*3Z+7HH
4``j*@KT2m`<pr?eo#Vk;@S,-B$-WV.OZBI`HG)?l6/m*S<>4Oi'FffRVDG@0Ib%`lO"rU/^
9K.oH@'KXBeS"]A^:kL3rQ"hX5<:?C)MWNpbp@WVlkJUpNR@HLjd!O]AhOf8B3r&V_)rVms1DQ
VYjN&01>e;"J320;l;(!T@EK-fAIoE;dW3%_N9`Xq:k[cba\nB,:"*:%a?nI,.cSt^oJ%>E;
JU/:MP!:Z"R3oSL(1e&Oc+YY<m(%Y&E7R,npg)d?S*!tI6IPec<BQ8oR!c\H3"P593:d%ku4
1YO'YiEGQPQ?@DEmqA2'f1Z-aS!;I2R+9NWSF\2nD;?4/Hs[1sTbO-:8ALD;Nr)opWh.#G4g
K&cH]AD:=9up(:57P!R.c6+7]A=$?<b[oB[*4Z;FFXh45pk0WMiL]AE$JV^6foN+oaVaA1-6,Hh
(4iF-H`Q9::*"ZU$lZ<2XomHJ0:9Bd6uXBCZ33q%Kkg[VX:Z1Fqj\K&Z>^6X0GS"hSW'$BU2
1UC$=S_#90;;Dh4BYufmjIZ,O8QV)arnmg(A.fZ]AKiR!5M?U`SHC'[[-Z0B6Q=FN0'Y8;nN(
$@c^fu]AHP=lr^1o)m7kRU`\%1kaCn&sCcX68jC=[D9-4g!.UGB&j0)?'`j1G:`gbK\^,fFBU
PCn_Vm:bb\I^jfXoB%og)TNLdYPp+ih<3G>S@ZZL<#4HI#L3Ll[-(iKm=`[4!Q2]ASjU`A;>R
2TbEAWlV%Be!&4iQk5E]A._<HOm,r=Q5("V)c"1[H4!\g-[9->*DHf51mF)dF#X%,f,lsYuqD
X:%/#J9)>^;0SIO5sp2R#"WrrPE-9C3[7cZmq5dZHMbr$@jMGHO->haHMClXeRMUJRJ/Y[bU
2YBr2k0rC1p(6g2hH_#"?&]Atk0Yui5&LJjYSM+F"O4i$>b?2]Apfl<H&,h%6XTFDd7+>VT\Y]A
q.-Qcp2SomdP"MeN6YS!&1*AWF+J`_-n:Q7b9i*:dL*&2:]AZI;-kZcUGX+q[SCm<etIe<C/2
\hcOE:=;s!9t#+L;*CkDuKL)-XGBO4eEI:>u?R+hT[HNYoZ1$eg;\5NgMC32YC`65,hSE`8`
#He@R_\=<.IFMAk`Ah0u[RH\;FThX+-gT!g0QI5O@bOfZ6fe`Si5+Lb\%Rkq%jdLDMRFsYJ%
:BQ&9\PkFM51uZg(_P'"t;M.'1k8F0W1.FjN<\7CRWMqLc^#X:+rN.U/SUMTU#fTMKoPW"=I
0V7%j$jENU:kVlOaa'Ee.bf#prZllNO.P9POS(]A\ZReGs@;RN#LA[.seKPpn!9[f^fqf!"!V
F2*Znm7LN*/=D@mob)dUfb\LA.lGadQ1h?kn0ij(XP!Wen(s#WC&=HqGb.@Hj+QO_s&9p8XE
R'4BT(u@$d4jSce-m6o9D?Oeo&Q_k1R'^^rXdTFIN0pD;Xk8jd-70)hlWj-*cTdDZ.K.=ELp
Pk\Z`Y!_2;qKI&-8kIAFnI@iERnR.$n\3P1RUc.&2DfTh:uBb!p`k]A'=LeuNAqM"d<=XF$ff
mKLZIoV0A;J.O]A#RrnO9WVIm,J*j=2deLg+T]ARO,uB&lPI$VVHi[e1N(+<"H&7qCQ_d$bc4!
%c"`M+Xn(Z7+d+W&o:<:4_&aDYJ9t8#igBM;S8isrCN*231*,O7Ls[OboZ@-(9nEkOYqCK"B
=*u>*/g(o'R')nHZlsUlG)qB^VV@go%<iL#XmO?q!!fcL3X[-_jm(L:^':`:nA<JPEY8FUc2
8iW;#Z)dn.0cFdjOI%EC5&f\_J*LLMkK$pXA\??(cL+#=M:LJH#M</NFP(i4qiR@^2s*46p9
G)/>2B<\51Hp3WUdll?R=u!2tTO6Gj1Jd6WSR@\R9e1Q4Pa=_0=1M%Sik.7hge?_$B&3-V+`
VT6)nQ,$e3?Dc,dB?9\++-MTC<$=T!P5m)JW/4EbKm?jmXci3A2nmLgHCA7k)(;$H!`Ch[&V
,M2<*b;8`?_In@=e><K-pV-<'qbaL80erVk?A>h(jlXiAng'T+kB9QiY`g9;PcF^=&&"\>Y[
=N1qIq_J2hs#9*/l`iPZEf9/JAYN./hk2ecn8boRG#So:^\@+/4#_J!?m?4s8@u?53<tUe,W
A:1>qeAJN7R"#Fqu'U80p%^(d!l'BWNb0GW<ij;D5ke>Ita:iO<^IqRrC0jYsJ2UN09E5QiP
l^4-2'h7l)VC0ea\,2H_R,B"$/mfH]AAE$YeFJ5i?]A\,ICp5UQR-/WTi:[rl,6"^_Y7)(RYVC
lt\V6&r=<1Vt#]A<J2e(_hEM5^VaJ'D_/Y:=XIY!uUK!^gj`NF%@a-;!MRc;g/MYlSe!(G\_i
Kr%bslKiAERa<QHkes!#<P)qtJlJLd/m$h1K$$EF%9<:L=P7b6HHTV/>J#8OAA:P=A'pS(a`
="4sL&-/?0`n^?E5f#h"L/rGA#i\ub#/st):j/F<8TfY5hA;C-I9Y1@&[@Fm_BfUi:apWd0-
lpT_[Lk-8!Z:mO`m?+Y1qjkHd<M^!lqJn(W^kAdpo%[?4@K)0=ULC8#d"M54+o\^g6R8S>lB
Y'e)4$j965)pO(5CS+rq^iI-%;Thsa^$uc&=JWR![C/rf,G)/C[L$<7ehfO`(35//Dlbe$k\
i*=Z$_n0o1CTo<>h&Ip2KN)XSXr"#)4\.6>%pldm1uGlnl\C$2;`/]A,Poa(kX!+:EkVJ/V2$
.nd.OY=AS+_0,rN"GHTUsSE*99S@$2Oc8MNF)o'sYa>7f"Xd":5YmoT71eUG->AY^o\4pJg<
TnEPUt;f^a1$=L1k0DR2c1q:0/qS52Ptn),W`<7XFJgpOc*kY<?K!!S#j*VLKe^Ld8($6Zi!
-B]And9Qk3]A&/$FB/iRslX^>HH@[JVio-HMDf\bn-qVa!P51ZtqI#G??_e)BB1p-NAJZR8"l"
Vmknj-S*2XA,$]AnLG)(1r!6H=(_8:e<Oqe/Ae+'))q\\&T;i"n&ap9E<_)S+g1<(a)XW`Fef
-g=[[ESHE',,F1d]A:/?CoIf=QhAbVt&3Q2`K?Ufl`1EQ58/ojKcfZM9%K?s%G2"F:l=kBK@A
XrVLZhAPU\9ei^<15i+&nV#4N-CYem-(7\Ef#]Ab+`OgCWaW&C"*f06=1&`R%rlG/)IEY#TqB
dpkU\S%b0S\F`*1?dV96hpRT*(>gda3"F!S)@+0'F<'UWD"7eM?SiQdB5K2Hl>)P\UblWb`O
F8]A+GM5$Jh[]AKd!=A$,s>`/=BE1FCRQnD*MpV:KS%G&joJl//I,N<KDX`<4LRmpaP8bn:-iF
--3]A]ALO&<%6c+<'@(;;2XgrG[&SkYtJ<A_iP>0`OGG&m&[=7c/p7(5!<]AZ_E`*s1$rNufOp&
#"e]A<@PsMD?N-S0(ru:=1(cC01e`CgdTDj5L=&Zctp\mj=;CXu5u(FDPXNBCd9[fNl>8V2)=
n2!gS>JpP3JFaBALF(l493XqN[\S-?"FJ-\GUL39.'Q)XD.AWo@C:<q5L<2a@?*HhE<`s>gQ
JT9k>7r"@5\fhgB#Ub>cF\;':@*T9e9G=A1TsdImT<^WA_'Y]AlZgl,&t@jP6,3.\`]A-gY/S*
Yp`D_NZ?&<&)R_3:P16pU\^^6PVmtWJIKr_eDH&WgCo[gkPma3;t7o/>a88'%d^%@ufl]A"<S
e9"t4'h%(GSY49"Vb:%SFlkktA$*b!!c8(lEZA.M6b5B5PF=oU%BEnq[6\U+*)`o#(<Md?._
M.Cgg(b/k.Rggpb064B+J3H-MA61W_3t?!XRaEhCp>DS4\d!79EEK?@e1.O"&;Pd-A^3=Of^
0c,_P>&$G96]A^B\PpGsJ\Ib.85HqfLTI3U#=ODr'91<TOq&*?2%7B@3R9A=2*I6\#NdcPqIm
Q.@n5QB[^3d6Y%1ob\2O&I:o$R"2AgapbY:&GS_lZb.Y5TJYf$I6;`KO_^NIis+#?6<24jNi
kgk<j`K9PI@_f5d`J'MfPU["&Y*V,kb73eG"J$C*R2iIR:'#Q>6]Ai;O)rm[cP.@RF)unACLs
G6]A/tnu6*seVNHR\'-(a^LiN(\rrKo2l/L(rG`]AdjI4ll32J@\T5sRD'Js>Qob0bpC=NLNfC
=AY$X*WRCjE9mYMO1?hD6QGln+rG>Zbi$'6Nj"Qej;-FVXnn0450S:k.Z7s17[6FT.Gl^jQC
/aYhY@^iNMaB!-^MIf]AR%)k%_1>e'Unrr<~
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
<![CDATA[723900,723900,1104900,1104900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[3600000,3600000,3600000,3600000,3600000,3600000,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="2" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="2" cs="2" s="0">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="<span style='font-size: 10px;font-family: 微软雅黑;color: #C0FDFF;'>产业新城拓展:</span>"]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="2" r="2" s="0">
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="3" r="2" cs="2" s="0">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="<span style='font-size: 10px;font-family: 微软雅黑;color: #C0FDFF;'>产业新城拓展:</span>"]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="0" r="3" s="0">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="<span style='font-size: 10px;font-family: 微软雅黑;color: #C0FDFF;'>签约目标数:</span>
<span style='font-size:20px;font-family: 微软雅黑;color: #ffff00;'>" + FORMAT(round(3000, 0), "#,##0") + "</span>
<span style='font-size: 9px;font-family: 微软雅黑;color: #C0FDFF;'>万元</span>"]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="1" r="3" s="0">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="<span style='font-size: 10px;font-family: 微软雅黑;color: #C0FDFF;'>签约目标数:</span>
<span style='font-size:20px;font-family: 微软雅黑;color: #ffff00;'>" + FORMAT(round(3000, 0), "#,##0") + "</span>
<span style='font-size: 9px;font-family: 微软雅黑;color: #C0FDFF;'>万元</span>"]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="2" r="3" cs="2" s="0">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="<span style='font-size: 10px;font-family: 微软雅黑;color: #C0FDFF;'>签约目标数:</span>
<span style='font-size:20px;font-family: 微软雅黑;color: #ffff00;'>" + FORMAT(round(3000, 0), "#,##0") + "</span>
<span style='font-size: 9px;font-family: 微软雅黑;color: #C0FDFF;'>万元</span>"]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="4" r="3" cs="2" s="0">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="<span style='font-size: 10px;font-family: 微软雅黑;color: #C0FDFF;'>签约目标数:</span>
<span style='font-size:20px;font-family: 微软雅黑;color: #ffff00;'>" + FORMAT(round(3000, 0), "#,##0") + "</span>
<span style='font-size: 9px;font-family: 微软雅黑;color: #C0FDFF;'>万元</span>"]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="0" r="4" cs="2" rs="2">
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
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</body>
</InnerWidget>
<BoundsAttr x="435" y="245" width="408" height="225"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.container.WTitleLayout">
<WidgetName name="report0_c_c_c_c"/>
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
<WidgetName name="report0_c_c_c_c"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Margin top="0" left="0" bottom="0" right="0"/>
<Border>
<border style="1" color="-15388336" borderRadius="1" type="0" borderStyle="0"/>
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
<![CDATA[609600,799200,723900,1296000,1296000,1296000,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[720000,288000,2476500,2476500,4953000,0,288000,288000,2476500,2476500,2324100,4343400,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="1">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1">
<O t="Image">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320!n,:Xbf@O(,[YCmQ3a9C4C&po.cr"'m/+%R[)9U<K2(;LHcLWuO8
`r6bWY;Uc&ZB^3:Ce,?kDM)[s6n[kqGpEK;YcBb;uPS-3+~
]]></IM>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="1" cs="3" s="0">
<O t="RichText">
<RichText>
<RichChar styleIndex="1">
<text>
<![CDATA[  ]]></text>
</RichChar>
<RichChar styleIndex="2">
<text>
<![CDATA[延期项目]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="7" r="1">
<O t="Image">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320!n,:Xbf@O(,[YCmQ3a9C4C&po.cr"'m/+%R[)9U<K2(;LHcLWuO8
`r6bWY;Uc&ZB^3:Ce,?kDM)[s6n[kqGpEK;YcBb;uPS-3+~
]]></IM>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="1" cs="3" s="0">
<O t="RichText">
<RichText>
<RichChar styleIndex="1">
<text>
<![CDATA[  ]]></text>
</RichChar>
<RichChar styleIndex="3">
<text>
<![CDATA[${=if($qy="1", "全部区域", $qy)}]]></text>
</RichChar>
<RichChar styleIndex="2">
<text>
<![CDATA[延期原因]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="5" r="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="2" cs="4" rs="4" s="4">
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
<Attr class="com.fr.plugin.chart.base.AttrLabel">
<AttrLabel>
<labelAttr enable="true"/>
<labelDetail class="com.fr.plugin.chart.base.AttrLabelDetail">
<Attr showLine="true" autoAdjust="false" position="6" isCustom="true"/>
<TextAttr>
<Attr alignText="0">
<FRFont name="微软雅黑" style="0" size="56" foreground="-1"/>
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
<HtmlLabel customText="function(){ return this.seriesName+this.value;}" useHtml="true" isCustomWidth="false" isCustomHeight="false" width="50" height="50"/>
</AttrToolTipContent>
</labelDetail>
</AttrLabel>
</Attr>
<Attr class="com.fr.plugin.chart.base.AttrTooltip">
<AttrTooltip>
<Attr enable="false" duration="4" followMouse="false" showMutiSeries="false" isCustom="true"/>
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
<NameJavaScriptGroup>
<NameJavaScript name="JavaScript1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="type"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=SERIES]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="qy"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if($qy=1,"",$qy)]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[window.parent.FS.tabPane.addItem({title:qy+type+"已延期项目列表",src:"${servletURL}?reportlet=/ThreeLevelPage/OPE_FIN_MAJOR_PRO_DEMO_INTO.cpt&__bypagesize__=false&qy="+qy+"&reasontype="+type})]]></Content>
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
<OColor colvalue="-16713985"/>
<OColor colvalue="-12475905"/>
<OColor colvalue="-9022774"/>
<OColor colvalue="-10657305"/>
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
<PieAttr4VanChart roseType="normal" startAngle="0.0" endAngle="360.0" innerRadius="0.0" supportRotation="true"/>
<VanChartRadius radiusType="auto" radius="100"/>
</Plot>
<ChartDefinition>
<OneValueCDDefinition seriesName="归因类型" valueName="节点数" function="com.fr.data.util.function.NoneFunction">
<Top topCate="-1" topValue="-1" isDiscardOtherCate="false" isDiscardOtherSeries="false" isDiscardNullCate="false" isDiscardNullSeries="false">
<SeriesPresent class="com.fr.base.present.DictPresent">
<Dictionary class="com.fr.data.impl.TableDataDictionary">
<FormulaDictAttr kiName="值" viName="描述"/>
<TableDataDictAttr>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[项目逾期原因分析]]></Name>
</TableData>
</TableDataDictAttr>
</Dictionary>
</SeriesPresent>
</Top>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[1 饼状图ds1]]></Name>
</TableData>
<CategoryName value="无"/>
</OneValueCDDefinition>
</ChartDefinition>
</Chart>
<tools hidden="false" sort="false" export="false" fullScreen="false"/>
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
<C c="5" r="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="5">
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
<FRFont name="微软雅黑" style="1" size="80" foreground="-13136221"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="104"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="104" foreground="-1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="104" foreground="-16713985"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="2" vertical_alignment="1" imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="478" height="270"/>
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
<CellElementList>
<C c="0" r="0">
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
<BoundsAttr x="12" y="245" width="410" height="225"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="report6_c"/>
<Widget widgetName="report0_c_c_c"/>
<Widget widgetName="report0_c"/>
<Widget widgetName="report2_c_c"/>
<Widget widgetName="report3"/>
<Widget widgetName="report1_c"/>
<Widget widgetName="report0_c_c_c_c"/>
<Widget widgetName="report0_c_c_c_c_c"/>
<Widget widgetName="report0_c_c_c_c_c_c"/>
<Widget widgetName="report0_c_c_c_c_c_c_c"/>
<Widget widgetName="report2_c"/>
<Widget widgetName="report0_c_c"/>
<Widget widgetName="report1"/>
</MobileWidgetList>
<WidgetScalingAttr compState="0"/>
<DesignResolution absoluteResolutionScaleW="1366" absoluteResolutionScaleH="768"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="958" height="538"/>
</Widget>
<Sorted sorted="true"/>
<MobileWidgetList>
<Widget widgetName="absolute0"/>
</MobileWidgetList>
<WidgetZoomAttr compState="0"/>
<AppRelayout appRelayout="true"/>
<Size width="958" height="538"/>
<ResolutionScalingAttr percent="0.9"/>
<BodyLayoutType type="0"/>
</Center>
</Layout>
<DesignerVersion DesignerVersion="JAA"/>
<PreviewType PreviewType="0"/>
<TemplateID TemplateID="b1c3182c-1c7c-4ac5-9c01-436eca60964c"/>
<TemplateIdAttMark class="com.fr.base.iofileattr.TemplateIdAttrMark">
<TemplateIdAttMark TemplateId="4ab6904a-af25-445a-aafe-403a9a46d909"/>
</TemplateIdAttMark>
</Form>
