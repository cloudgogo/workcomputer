<?xml version="1.0" encoding="UTF-8"?>
<Form xmlVersion="20170720" releaseVersion="9.0.0">
<TableDataMap>
<TableData name="left1" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="left1"/>
<O>
<![CDATA[1]]></O>
</Parameter>
<Parameter>
<Attributes name="projectid"/>
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
<![CDATA[with W1 AS (
select RES.*,ROW_NUMBER()OVER(order by ordernum) ROW_NUM from (
select  img.*,d.*,dense_rank()over(partition by d.projguid order by proceed_date desc) num from  DM_PROJECT_TIM_IMAGE img right join  (select * from DM_PROJECT_PROCEED_DETAIL where  projguid='${projectid}' and proceed_date is not null) d
on  img.id=d.proceed_imageid
) res
where res.num=1
order by ordernum
) 

select W1.*,(select max(row_num) from W1) maxnum from W1 WHERE  ROW_NUM =${left1}]]></Query>
</TableData>
<TableData name="left2" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="left2"/>
<O>
<![CDATA[2]]></O>
</Parameter>
<Parameter>
<Attributes name="projectid"/>
<O>
<![CDATA[49ADE7A5-B334-4EAD-BC3A-4FCB08D43AB5]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[oracle_test]]></DatabaseName>
</Connection>
<Query>
<![CDATA[with W1 AS (
select RES.*,ROW_NUMBER()OVER(order by ordernum) ROW_NUM from (
select  img.*,d.*,dense_rank()over(partition by d.projguid order by proceed_date desc) num from  DM_PROJECT_TIM_IMAGE img,DM_PROJECT_PROCEED_DETAIL d
where  img.id=d.proceed_imageid
and d.projguid='${projectid}') res
where res.num=1
order by ordernum
) 

select W1.*,(select max(row_num) from W1) maxnum from W1 WHERE  ROW_NUM =${left2}]]></Query>
</TableData>
<TableData name="right1" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="right1"/>
<O>
<![CDATA[1]]></O>
</Parameter>
<Parameter>
<Attributes name="projectid"/>
<O>
<![CDATA[49ADE7A5-B334-4EAD-BC3A-4FCB08D43AB5]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[oracle_test]]></DatabaseName>
</Connection>
<Query>
<![CDATA[with W1 AS (
select RES.*,ROW_NUMBER()OVER(order by ordernum) ROW_NUM from (
select  img.*,d.*,dense_rank()over(partition by d.projguid order by proceed_date desc) num from  DM_PROJECT_TIM_IMAGE img,DM_PROJECT_PROCEED_DETAIL d
where  img.id=d.proceed_imageid
and d.projguid='${projectid}') res
where res.num=2
order by ordernum
) 

select W1.*,(select max(row_num) from W1) maxnum from W1 WHERE  ROW_NUM =${right1}]]></Query>
</TableData>
<TableData name="right2" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="right2"/>
<O>
<![CDATA[2]]></O>
</Parameter>
<Parameter>
<Attributes name="projectid"/>
<O>
<![CDATA[49ADE7A5-B334-4EAD-BC3A-4FCB08D43AB5]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[oracle_test]]></DatabaseName>
</Connection>
<Query>
<![CDATA[with W1 AS (
select RES.*,ROW_NUMBER()OVER(order by ordernum) ROW_NUM from (
select  img.*,d.*,dense_rank()over(partition by d.projguid order by proceed_date desc) num from  DM_PROJECT_TIM_IMAGE img,DM_PROJECT_PROCEED_DETAIL d
where  img.id=d.proceed_imageid
and d.projguid='${projectid}') res
where res.num=2
order by ordernum
) 

select W1.*,(select max(row_num) from W1) maxnum from W1 WHERE  ROW_NUM =${right2}]]></Query>
</TableData>
<TableData name="nodes" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="projectid"/>
<O>
<![CDATA[49ADE7A5-B334-4EAD-BC3A-4FCB08D43AB5]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[oracle_test]]></DatabaseName>
</Connection>
<Query>
<![CDATA[select t.*,
       case
         when t.completion_plan_node - t.completion_actual_node < -1 then
          abs(t.completion_plan_node - t.completion_actual_node)
         else
          null
       end overday from DM_PROJECT_NODE_DETAIL  t where t.projectguid='${projectid}' order by t.nodesort]]></Query>
</TableData>
<TableData name="title" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="projectid"/>
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
<![CDATA[with W1 AS (
select RES.*,ROW_NUMBER()OVER(order by ordernum) ROW_NUM from (
select  img.*,d.*,dense_rank()over(partition by d.projguid order by proceed_date desc) num from  DM_PROJECT_TIM_IMAGE img right join  (select * from DM_PROJECT_PROCEED_DETAIL where  projguid='${projectid}' ) d
on  img.id=d.proceed_imageid
) res
where res.num=1
order by ordernum
) 

select W1.*,(select max(row_num) from W1) maxnum from W1 WHERE  ROW_NUM =1]]></Query>
</TableData>
</TableDataMap>
<FormMobileAttr>
<FormMobileAttr refresh="false" isUseHTML="false" isMobileOnly="false" isAdaptivePropertyAutoMatch="false"/>
</FormMobileAttr>
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
<Background name="ColorBackground" color="-1380875"/>
<Alpha alpha="1.0"/>
</Border>
<Background name="ColorBackground" color="-1380875"/>
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
<![CDATA[288000,720000,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,0,2781300,360000,360000,7315200,3695700,2743200,0,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1">
<O t="DSColumn">
<Attributes dsName="nodes" columnName="NODENAME"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="2" r="1" s="0">
<O t="DSColumn">
<Attributes dsName="nodes" columnName="COMPLETION_PLAN_NODE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="3" r="1" cs="2" s="1">
<O>
<![CDATA[●]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[G]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[I2 = "G"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.FRFontHighlightAction">
<FRFont name="SimSun" style="0" size="72" foreground="-16732080"/>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[R]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[I2 = "R"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.FRFontHighlightAction">
<FRFont name="SimSun" style="0" size="72" foreground="-65536"/>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[N]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[I2 = "N"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.FRFontHighlightAction">
<FRFont name="SimSun" style="0" size="72" foreground="-6973274"/>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[Y]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[I2 = "Y"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.FRFontHighlightAction">
<FRFont name="SimSun" style="0" size="72" foreground="-13312"/>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="5" r="1" s="2">
<O t="DSColumn">
<Attributes dsName="nodes" columnName="NODENAME"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="6" r="1" s="3">
<O>
<![CDATA[实际完成时间：]]></O>
<PrivilegeControl/>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=if(len(H2)=0,'',$$$)]]></Content>
</Present>
<Expand/>
</C>
<C c="7" r="1" s="4">
<O t="DSColumn">
<Attributes dsName="nodes" columnName="COMPLETION_ACTUAL_NODE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="8" r="1">
<O t="DSColumn">
<Attributes dsName="nodes" columnName="NODETATUS"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="9" r="1" s="5">
<O>
<![CDATA[逾期天数：]]></O>
<PrivilegeControl/>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=if(len(K2)=0,'',$$$)]]></Content>
</Present>
<Expand/>
</C>
<C c="10" r="1" s="6">
<O t="DSColumn">
<Attributes dsName="nodes" columnName="OVERDAY"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=if(len($$$)=0,'',$$$+'天')]]></Content>
</Present>
<Expand dir="0"/>
</C>
<C c="15" r="1">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="2" s="7">
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MAX(F3[!0;!0]A) = F3]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="4" r="2">
<PrivilegeControl/>
<Expand leftParentDefault="false" left="D2"/>
</C>
<C c="5" r="2" s="8">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=seq()]]></Attributes>
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
<Style horizontal_alignment="2" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="64" foreground="-6973274"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="SimSun" style="0" size="72" foreground="-6973274"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1" paddingLeft="10">
<FRFont name="微软雅黑" style="0" size="64" foreground="-9934744"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="4" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="64" foreground="-9934744"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="64" foreground="-9934744"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="4" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="64" foreground="-1090722"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="64" foreground="-1090722"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Right style="1" color="-6973274"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72" foreground="-1"/>
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
<![CDATA[288000,720000,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,0,360000,360000,4152900,9220200,720000,3695700,2743200,0,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1">
<O t="DSColumn">
<Attributes dsName="nodes" columnName="NODENAME"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="2" r="1" cs="2" s="0">
<O>
<![CDATA[●]]></O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[G]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[J2 = "G"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.FRFontHighlightAction">
<FRFont name="SimSun" style="0" size="72" foreground="-16732080"/>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[R]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[J2 = "R"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.FRFontHighlightAction">
<FRFont name="SimSun" style="0" size="72" foreground="-65536"/>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[N]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[J2 = "N"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.FRFontHighlightAction">
<FRFont name="SimSun" style="0" size="72" foreground="-6973274"/>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[Y]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[J2 = "Y"]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.FRFontHighlightAction">
<FRFont name="SimSun" style="0" size="72" foreground="-13312"/>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="4" r="1" s="1">
<O t="DSColumn">
<Attributes dsName="nodes" columnName="COMPLETION_PLAN_NODE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="5" r="1" s="2">
<O t="DSColumn">
<Attributes dsName="nodes" columnName="NODENAME"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="6" r="1" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="1" s="4">
<O>
<![CDATA[实际完成时间：]]></O>
<PrivilegeControl/>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=if(len(I2)=0,'',$$$)]]></Content>
</Present>
<Expand/>
</C>
<C c="8" r="1" s="2">
<O t="DSColumn">
<Attributes dsName="nodes" columnName="COMPLETION_ACTUAL_NODE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="9" r="1">
<O t="DSColumn">
<Attributes dsName="nodes" columnName="NODETATUS"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="10" r="1" s="5">
<O>
<![CDATA[逾期天数：]]></O>
<PrivilegeControl/>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=if(len(L2)=0,'',$$$)]]></Content>
</Present>
<Expand/>
</C>
<C c="11" r="1" s="6">
<O t="DSColumn">
<Attributes dsName="nodes" columnName="OVERDAY"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=if(len($$$)=0,'',$$$+'天')]]></Content>
</Present>
<Expand dir="0"/>
</C>
<C c="16" r="1">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="2" s="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="2">
<PrivilegeControl/>
<Expand leftParentDefault="false" left="B2"/>
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
<FRFont name="SimSun" style="0" size="72" foreground="-6973274"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="2" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="64" foreground="-6973274"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="64" foreground="-9934744"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72" foreground="-9934744"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="4" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="64" foreground="-9934744"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="4" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="64" foreground="-1090722"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72" foreground="-1090722"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Right style="4" color="-855310"/>
</Border>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</body>
</InnerWidget>
<BoundsAttr x="10" y="325" width="840" height="143"/>
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
<![CDATA[1866900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,2743200,2743200,2743200,720000,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="0" cs="7" s="0">
<O t="DSColumn">
<Attributes dsName="right1" columnName="PROCEED_EXPLAI"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[=$$$]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[len($$$)=0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[<b>周进展:</b>  暂无]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[LEN($$$)>0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="<b>周进展:</b>"+$$$]]></Attributes>
</O>
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
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="64" foreground="-10066330"/>
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
<![CDATA[1866900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,2743200,2743200,2743200,720000,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="0" cs="7" s="0">
<O t="DSColumn">
<Attributes dsName="left1" columnName="PROCEED_EXPLAI"/>
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
<FRFont name="微软雅黑" style="0" size="64" foreground="-10066330"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</body>
</InnerWidget>
<BoundsAttr x="430" y="230" width="358" height="40"/>
</Widget>
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
<![CDATA[1866900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,2743200,2743200,2743200,720000,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="0" cs="7" s="0">
<O t="DSColumn">
<Attributes dsName="left1" columnName="PROCEED_EXPLAI"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[=$$$]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[len(trim($$$))=0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[<b>周进展:</b>  暂无]]></O>
</HighlightAction>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[LEN($$$)>0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="<b>周进展:</b>"+$$$]]></Attributes>
</O>
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
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="64" foreground="-10066330"/>
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
<![CDATA[1866900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,2743200,2743200,2743200,720000,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="0" cs="7" s="0">
<O t="DSColumn">
<Attributes dsName="left1" columnName="PROCEED_EXPLAI"/>
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
<FRFont name="微软雅黑" style="0" size="64" foreground="-10066330"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</body>
</InnerWidget>
<BoundsAttr x="19" y="230" width="358" height="40"/>
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
<![CDATA[288000,1440000,288000,5760000,288000,1866900,288000,0,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[720000,2160000,2743200,2743200,2743200,720000,2743200,2743200,2743200,2160000,720000,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="1">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1" cs="9" s="0">
<O t="DSColumn">
<Attributes dsName="right1" columnName="PROCEED_DATE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="1" r="2" s="1">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="2" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="2" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="2" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="2" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="2" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="2" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="2" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="2" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="3" s="4">
<O t="Image">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320!n'P'SAN)H,`fT/Nb2[,/G!t'%&oWcp;TG6_Z:B?5CO<7EACG2nZ
?JUEIpK3Wl1I<KLn@GNWs/fnSg3S:2;;8TA6hrkM@)kmhYA=f!0_.mJ`@:lXt-QS*R-MK>E[
=Ol+GM_!sfK^OV6XV[(EsJh8m*Ko7Q9bFE`mqUY&sS=FVK9`:Em[FYAO!iO4a7?Jg2nS/.&Y
E__%o^:OC[oX\O_,T@K"Ml>S97q^_c0K'A3mZb[<D:+<L\M197Bc0"#Ke;<5JIuY[.0WD8F)
V&E0`p*.a8]AD)DsK)4Vc2L$E,GG%rRod?aF<D@[HGGTCZl&Rf5-f(B9[p#i^%7mlA(#k47E7
)BN_3YMC9VHk'\9bk9C<q7Xr9J-e>Qf2fXrq#%RC-/2)1O8o#N-#?LZ<1i\5DjtpL)TsAARK
eJC$1.3i*=>RPZ?%F6<.84kic('u/_o,oI;JGEpTlJI!Cd3EVlQH53i@WX!!~
]]></IM>
</O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="当前决策报表对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="right1"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(D8=1,E8,D8-1)]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="right2"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(H8=1,I8,H8-1)]]></Attributes>
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
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[D8=1]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[E8<=2]]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="2" r="3" cs="3" s="5">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=toimage(if(len(C8)=0,"picture/Key_project_level_Four_x.png","http://" + replace(C8, "文件", encode("文件"))), false, "210", "150")]]></Attributes>
</O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="网络报表1">
<JavaScript class="com.fr.js.ReportletHyperlink">
<JavaScript class="com.fr.js.ReportletHyperlink">
<Parameters>
<Parameter>
<Attributes name="micurl"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=C8]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_dialog]]></TargetFrame>
<Features width="790" height="490"/>
<ReportletName showPI="true">
<![CDATA[/ThreeLevelPage/image_detail.cpt&op=view]]></ReportletName>
</JavaScript>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<CellGUIAttr showAsDefault="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="5" r="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="3" cs="3" s="5">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(len(G8)=0,"",toimage("http://" + replace(if(len(G8)=0,C8,G8), "文件", encode("文件")), false, "210", "150"))]]></Attributes>
</O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="网络报表1">
<JavaScript class="com.fr.js.ReportletHyperlink">
<JavaScript class="com.fr.js.ReportletHyperlink">
<Parameters>
<Parameter>
<Attributes name="micurl"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(len(G8)=0,C8,G8)]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_dialog]]></TargetFrame>
<Features width="790" height="490"/>
<ReportletName showPI="true">
<![CDATA[/ThreeLevelPage/image_detail.cpt&op=view]]></ReportletName>
</JavaScript>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<Expand/>
</C>
<C c="9" r="3" s="6">
<O t="Image">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320!n'P'SAN)H,`fT/Nb2[,bk-!s%&oWcp;U9#Ak.ulLIIpM.Uo!MG-
K,nnZY"X2*Y]AB^iHZ'@6fi=kQIRg.OgZ5ar[%I9@NSLX0&RMqkSPdhj7o/I?,2P5@JG;i1*l
d+J<[m1-Yl)9#W/ILB\ND3sL]AO%o0Dd0FHM2A5I5Y;O;$(nb<)]AHs6'E_4/OFCWEMOo'G.\m
*bO.B=NEi@@rpk7q)5$mjud96rVa1h6lf_%8=LR^ZFJHC]A<!N;k8!E*+_^bQ!Mt:@;o4t[<O
4fb-mR?RPS8kSlo>[JSPqjk=;)29U[bLc^KtSTkW]AF"#f&)._Sqs3rXtqqOOTn<]A9VX>5lPe
X8$9fY1Y<BWbD*Ce(*Zq;G4U_H]A:+qcf-AAkd:l&l/(CK->-DK/g.o0@,?RLIsek[Q0p')IL
_b.G?/[R5Ug-fTn^Lo?`ZtfMsm2!PPGLnHNm8I5F6Lf#u(C~
]]></IM>
</O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="当前决策报表对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="right1"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(D8=E8,1,D8+1)]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="right2"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(H8=I8,1,H8+1)]]></Attributes>
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
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[H8=I8]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[I8<=2]]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="1" r="4" s="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="4" s="8">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="5" s="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="5" s="8">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="6" s="9">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="6" s="10">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="6" s="10">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="6" s="10">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="6" s="10">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="6" s="10">
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="6" s="10">
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="6" s="10">
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="6" s="11">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="7">
<O t="DSColumn">
<Attributes dsName="right1" columnName="MINIMUMIMGPATH"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="3" r="7">
<O t="DSColumn">
<Attributes dsName="right1" columnName="ROW_NUM"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="4" r="7">
<O t="DSColumn">
<Attributes dsName="right1" columnName="MAXNUM"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="6" r="7">
<O t="DSColumn">
<Attributes dsName="right2" columnName="MINIMUMIMGPATH"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="7" r="7">
<O t="DSColumn">
<Attributes dsName="right2" columnName="ROW_NUM"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="8" r="7">
<O t="DSColumn">
<Attributes dsName="right2" columnName="MAXNUM"/>
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
<FRFont name="微软雅黑" style="1" size="80"/>
<Background name="ColorBackground" color="-394759"/>
<Border>
<Top style="1" color="-1118482"/>
<Bottom style="1" color="-1118482"/>
<Left style="1" color="-1118482"/>
<Right style="1" color="-1118482"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-1118482"/>
<Left style="1" color="-1118482"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-1118482"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-1118482"/>
<Right style="1" color="-1118482"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72" foreground="-16776961" underline="1"/>
<Background name="NullBackground"/>
<Border>
<Left style="1" color="-1118482"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72" foreground="-16776961" underline="1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72" foreground="-16776961" underline="1"/>
<Background name="NullBackground"/>
<Border>
<Right style="1" color="-1118482"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Left style="1" color="-1118482"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Right style="1" color="-1118482"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Bottom style="1" color="-1118482"/>
<Left style="1" color="-1118482"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Bottom style="1" color="-1118482"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Bottom style="1" color="-1118482"/>
<Right style="1" color="-1118482"/>
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
<![CDATA[723900,1440000,723900,4320000,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[720000,2160000,2743200,2743200,2743200,720000,2743200,2743200,2743200,2160000,720000,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1" cs="9" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="2" s="1">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="2" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="2" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="2" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="2" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="2" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="2" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="2" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="2" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="3" s="4">
<O>
<![CDATA[上一页]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="3" cs="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="3" cs="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="3" s="5">
<O>
<![CDATA[下一页]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="4" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="4" s="5">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="5" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="5" cs="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="5" s="5">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="6" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="6" s="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="6" s="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="6" s="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="6" s="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="6" s="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="6" s="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="6" s="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="6" s="8">
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
<Background name="ColorBackground" color="-394759"/>
<Border>
<Top style="1" color="-1118482"/>
<Bottom style="1" color="-1118482"/>
<Left style="1" color="-1118482"/>
<Right style="1" color="-1118482"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-1118482"/>
<Left style="1" color="-1118482"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-1118482"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-1118482"/>
<Right style="1" color="-1118482"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Left style="1" color="-1118482"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Right style="1" color="-1118482"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Bottom style="1" color="-1118482"/>
<Left style="1" color="-1118482"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Bottom style="1" color="-1118482"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Bottom style="1" color="-1118482"/>
<Right style="1" color="-1118482"/>
</Border>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</body>
</InnerWidget>
<BoundsAttr x="430" y="95" width="406" height="180"/>
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
<![CDATA[288000,1440000,288000,5760000,288000,1866900,288000,0,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[720000,2160000,2743200,2743200,2743200,720000,2743200,2743200,2743200,2160000,720000,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="1">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1" cs="9" s="0">
<O t="DSColumn">
<Attributes dsName="left1" columnName="PROCEED_DATE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="1" r="2" s="1">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="2" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="2" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="2" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="2" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="2" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="2" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="2" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="2" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="3" s="4">
<O t="Image">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320!n'P'SAN)H,`fT/Nb2[,/G!t'%&oWcp;TG6_Z:B?5CO<7EACG2nZ
?JUEIpK3Wl1I<KLn@GNWs/fnSg3S:2;;8TA6hrkM@)kmhYA=f!0_.mJ`@:lXt-QS*R-MK>E[
=Ol+GM_!sfK^OV6XV[(EsJh8m*Ko7Q9bFE`mqUY&sS=FVK9`:Em[FYAO!iO4a7?Jg2nS/.&Y
E__%o^:OC[oX\O_,T@K"Ml>S97q^_c0K'A3mZb[<D:+<L\M197Bc0"#Ke;<5JIuY[.0WD8F)
V&E0`p*.a8]AD)DsK)4Vc2L$E,GG%rRod?aF<D@[HGGTCZl&Rf5-f(B9[p#i^%7mlA(#k47E7
)BN_3YMC9VHk'\9bk9C<q7Xr9J-e>Qf2fXrq#%RC-/2)1O8o#N-#?LZ<1i\5DjtpL)TsAARK
eJC$1.3i*=>RPZ?%F6<.84kic('u/_o,oI;JGEpTlJI!Cd3EVlQH53i@WX!!~
]]></IM>
</O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="当前决策报表对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="left1"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(D8=1,E8,D8-1)]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="left2"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(H8=1,I8,H8-1)]]></Attributes>
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
</NameJavaScriptGroup>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.ListCondition">
<JoinCondition join="0">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[D8=1]]></Formula>
</Condition>
</JoinCondition>
<JoinCondition join="1">
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[E8<=2]]></Formula>
</Condition>
</JoinCondition>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="2" r="3" cs="3" s="5">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=toimage(if(len(C8)=0,"picture/Key_project_level_Four_x.png","http://" + replace(C8, "文件", encode("文件"))), false, "210", "150")]]></Attributes>
</O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="网络报表1">
<JavaScript class="com.fr.js.ReportletHyperlink">
<JavaScript class="com.fr.js.ReportletHyperlink">
<Parameters>
<Parameter>
<Attributes name="micurl"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=C8]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_dialog]]></TargetFrame>
<Features width="790" height="490"/>
<ReportletName showPI="true">
<![CDATA[/ThreeLevelPage/image_detail.cpt&op=view]]></ReportletName>
</JavaScript>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<CellGUIAttr showAsDefault="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="5" r="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="3" cs="3" s="5">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(len(G8)=0,"",toimage("http://" + replace(if(len(G8)=0,C8,G8), "文件", encode("文件")), false, "210", "150"))]]></Attributes>
</O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="网络报表1">
<JavaScript class="com.fr.js.ReportletHyperlink">
<JavaScript class="com.fr.js.ReportletHyperlink">
<Parameters>
<Parameter>
<Attributes name="micurl"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(len(G8)=0,C8,G8)]]></Attributes>
</O>
</Parameter>
</Parameters>
<TargetFrame>
<![CDATA[_dialog]]></TargetFrame>
<Features width="790" height="490"/>
<ReportletName showPI="true">
<![CDATA[/ThreeLevelPage/image_detail.cpt&op=view]]></ReportletName>
</JavaScript>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<Expand/>
</C>
<C c="9" r="3" s="6">
<O t="Image">
<IM>
<![CDATA[lO<9(kN.ld@UNU%p%320!n'P'SAN)H,`fT/Nb2[,bk-!s%&oWcp;U9#Ak.ulLIIpM.Uo!MG-
K,nnZY"X2*Y]AB^iHZ'@6fi=kQIRg.OgZ5ar[%I9@NSLX0&RMqkSPdhj7o/I?,2P5@JG;i1*l
d+J<[m1-Yl)9#W/ILB\ND3sL]AO%o0Dd0FHM2A5I5Y;O;$(nb<)]AHs6'E_4/OFCWEMOo'G.\m
*bO.B=NEi@@rpk7q)5$mjud96rVa1h6lf_%8=LR^ZFJHC]A<!N;k8!E*+_^bQ!Mt:@;o4t[<O
4fb-mR?RPS8kSlo>[JSPqjk=;)29U[bLc^KtSTkW]AF"#f&)._Sqs3rXtqqOOTn<]A9VX>5lPe
X8$9fY1Y<BWbD*Ce(*Zq;G4U_H]A:+qcf-AAkd:l&l/(CK->-DK/g.o0@,?RLIsek[Q0p')IL
_b.G?/[R5Ug-fTn^Lo?`ZtfMsm2!PPGLnHNm8I5F6Lf#u(C~
]]></IM>
</O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="当前决策报表对象1">
<JavaScript class="com.fr.form.main.FormHyperlink">
<JavaScript class="com.fr.form.main.FormHyperlink">
<Parameters>
<Parameter>
<Attributes name="left1"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(D8=E8,1,D8+1)]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="left2"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=IF(H8=I8,1,H8+1)]]></Attributes>
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
</NameJavaScriptGroup>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[OR(H8=I8,I8<=2)]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.ValueHighlightAction">
<O>
<![CDATA[]]></O>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="1" r="4" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="4" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="5" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="5" cs="7" s="7">
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="9" r="5" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="6" s="8">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="6" s="9">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="6" s="9">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="6" s="9">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="6" s="9">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="6" s="9">
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="6" s="9">
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="6" s="9">
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="6" s="10">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="7">
<O t="DSColumn">
<Attributes dsName="left1" columnName="MINIMUMIMGPATH"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="3" r="7">
<O t="DSColumn">
<Attributes dsName="left1" columnName="ROW_NUM"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="4" r="7">
<O t="DSColumn">
<Attributes dsName="left1" columnName="MAXNUM"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="6" r="7">
<O t="DSColumn">
<Attributes dsName="left2" columnName="MINIMUMIMGPATH"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="7" r="7">
<O t="DSColumn">
<Attributes dsName="left2" columnName="ROW_NUM"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="8" r="7">
<O t="DSColumn">
<Attributes dsName="left2" columnName="MAXNUM"/>
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
<FRFont name="微软雅黑" style="1" size="80"/>
<Background name="ColorBackground" color="-394759"/>
<Border>
<Top style="1" color="-1118482"/>
<Bottom style="1" color="-1118482"/>
<Left style="1" color="-1118482"/>
<Right style="1" color="-1118482"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-1118482"/>
<Left style="1" color="-1118482"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-1118482"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-1118482"/>
<Right style="1" color="-1118482"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Left style="1" color="-1118482"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72" foreground="-16776961" underline="1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Right style="1" color="-1118482"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="64" foreground="-10066330"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Bottom style="1" color="-1118482"/>
<Left style="1" color="-1118482"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Bottom style="1" color="-1118482"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Bottom style="1" color="-1118482"/>
<Right style="1" color="-1118482"/>
</Border>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<IM>
<![CDATA[m<a+\;chR(C+Cb`:4SuK/QJhWLo:^`8#8f]AL"AAY9G%:;&HX.4jA_Q4"B@jS.9[*.+qP=l@7
Z&NU.eDq#\1XU@7UY884ZKNc:pR]Ag@(=k\)6T)pNc2/J)S[:H`sjNDlr\:qlFl3?aa!.(25<
t:f(87n=-Vr<D]A%j.4EF)?SGhF_HjqNY(FM3bCa0j4Vj4#mAc-FZ7Ro.[o?SHr3aug,F<An)
6mntB_?"MNg?H\n"&SF/t?9M^Z3S*)gpGU^\u]AFcTJt4gXhP7OR_Dpn+F)tIj$\]A`=BS?l:O
ZH;.nc[A4M;jh`a6V+[ijHngI<P67a^+\#jMU>U/NF0:2Ia.g(l8"AfZDASVZhGucT1YA`pR
h?6['jL^!'XURf.s&C@&E!FUH"a&-BW$MSbGZ:/BFPOOu((.*BWSAs@I?op%O7RQar-PL^R)
`XuA.P)6603rL4jee!.B?(`HCdB0*h.P*!':ql);rH2d`L,Rc0?.5FrBC6aW>bQ;_lL&J1^#
H_aVG5]A5K)`$1iZsm*X]A_8IAe+-9s"h2c`MtdQTM]A0aYp.#hdna*F9A>LIk9rk)=CPE@NdQ8
+=QYElD@gNf6376uhiT0BNSQPOD*ZV\d)IGls-Y^g2;)hVZfL$AOr@a'/lI02`c3D#gM*Z8n
>''4tTN\DT*NUi1#-S``6pN]A-UTSO.@*Vr2_i$N']A=mJ=8EHb@9[/"dS3MjL!B.pP5G=4i.T
76lWCcoY5kGGUD3\]A9u>Z1/=abpg07STXK,*<!HHQn=K?RRQ[d<.Nb#dY'MKhf5pI**4h*,8
Js<K?[![VW5]A(NCSio4U6GmJCYH\E=9N;_;=8V/*/e^4&U%2#!T6WFg)>F,8J@=fJ$mX-Jh5
6<=hk)DA%I"_UAQC;pb+1F263r=*215cGm>Cat(i?[$\^"Lo\f]ANZ.U%F@/bO\<_._nXqm4h
di'kFPFqfl&Oi<a>gMV7U^Y3fpm#AL;h-M'=q--VWV=>?cP2icF!Z/?Lu1uTBcFt2]AV:jfbM
b>hH#p.:`&3F$eUfkb;F2"!`s=O=(8RNoJ]Adu>L*/Df]AdgM$eQktC),p3lZYN3,fCaO#6AeD
V\GKg)H-a-gGdH@WB%Mtk6,&brnL&t%4cr":16-.ar>]A:_4X-]A2+_gb+*Cfk;-=+?]A!u^s(0
i\To%MBoGIbip-Hb_0681(`*,2DhYOV]Ao>H4Kpa&19Z,hOig<<F0LB0D:02,9u`:\CTXY_'u
I"9gpuYYh\+3db2ckC">qC6Z:CODos-h6'K]AE:).q60_s^p6Woe6;O+1G,h\;,NeeK*8W,`d
N6WFo<%]AJbWDYek$3-C4L*1oclD,.'t5^^12\gc?PiE/n(gC>b>JJC+.5lX/f-MHpu+1)6uP
eVqp_['*a6W>76/(0?<?S8:$g]AsFtkpJrih]A!Fi'6qM6:R#Qd!KfQae-[$^=G#MF+S.BZd0#
A%AK0\QpcS`iGi1nd/a"DJ"s)A6uW'll8Z.lIBRB!NDnn2W9`Qp4cT*BYX]AhN0FK:+3B4cC\
bD*TD#TNS,.ejb?2H7N(BXQS9+gnP9-(VAEo7o=Kd#ol'[hEG3L<4"@Bgrf5.Lk>U`=N92u/
fp#&gKoK#LD)>R.>W#0b*r]A;ee*&s3/+23)gJ<oFgQN)BWCEXtXrAale]A=gHl^%hEfOk8'?D
@V'+680rheR&7((1$_Gd?/IuAiK]AH5A6=FTb4^s&/l<")C?Njo;"p)"\a0r'-/Mn`S4*6iY%
?U?iYJ;%/g;\).q&=:'Tat6_9OM*2,P7.qht<?m``(+]AS!\_a$/*&dT5/JshBIlt0_D5VSui
Rq<F>dMEmbn4"2s!mU5Q8J51]A<f=af;j#L:7+,+OO5obG(C")VO3&^?grl@lI30,j)1R;V%6
n,&0"oPZ@'$p`56g7Y74)g1S*dH.+YmHfZEuXMMK%<C>3'F.nJgZO$l%@;(YmJl+<r%@!Sb4
YMD'u,d:j>cg,rLV%@^,K<u8g"!>"n&$'Ip.>q6'M9'Q'4l1W'*bL5c^ZNuBO0s\uOUbG*Z'
sUns7!(-<SE>ki@9pr)7m2_@)Zjat47TU10%'rUC2pI>TjhJAYINocmZjN1\hKq`72?C[,n,
sGRoqTDLn8&c;%.re'BWDNPp=`2r6jO@\.tV^R49H@T1It)&IGJ[>1?,/qRWg<5MT:Zh+tBr
/XU'S^[ak1/>TFF3E\k047P^9IoUWXYF6SoHUt'\#*Fq\k\+aA#V\oE'>c""(]A!?eILYA8O?
9>J9;p8_IYD_QKPjUV$60&PrF\bgO[5;HJ7`F.>,87E^8Dr.Suaib2e$6TFsnSq&e==+,%ce
$&.\<kKSR+7=ooUgh,<Cc,M(0:EeLC2_O5bu%/V4=j@2n]A'45=_N]A,IK%$<'Wk<>[,TQYDRI
9qOpb(`pK;BCJ$@uWaYf-7mS0S"^03GY2Q,StC"jL^Po#PoF25\A/:#ieW,!.g'n4+ak>UZ&
9#U%HuM"$89fnX>lL,AVRK6#!NiRG]AVW(K/Q.\t2Urqj]AoQFEZCC:2;0S-C^b5=_g3ajamYK
TnkkK1E2G9hr%2oca@?Q1Dh7,C0mpTZ$I[CEaIua'eA,sHHD;qZpPoVaGjr2m:4e@kC#T4l7
O7[(poKK;<nR8&]AENQU288Q9a,gX?PLK`X)qjd#r-e+[h)1*JM22r7D9Jej1oSPlUqAT.jjt
F;]AoKm0C)HQ<(NLF)9,E_I#`8[J$Rk/aiA5'j78cG'O"?qOpHkG4CM><Fn]A)J4rkTRSh\!(X
G$Y_h;,k8$&&G$C)hV.LD:pnde!@84u_D^('5'+T67']AjTB&!kLUJl,TOr'jj@9S\bbk^F.S
J9idQ-\$/Vqf/.=LGS\+^$NsYh&5Hrr\L]AEH.2BVoRoX_$4_/p=:H<=E^AaQ!Tc/er[*D'\[
jRK^]A;7T\T-8[sYa;V-reX/,VnM3bIZ1Pam0cZ9FcKSHG5Sai@9If1SE]Aek[KB\+/pWJh:-V
@Ma'PSYF@1J:IemL'_oF2h'5B><ZE:T6O:(!T8b:=L8;ocJZA4YrI6rMt-UF!]AIc]Ai2oBWb_
k]A:t8I$^WWLUi)Ii8("R#hRLl7Q41b-b+*U;#Q+oh;A,9%:^]AJ49lrfV09]AUY^_Nhr^&Be"9
Q8[%Rt^pN=Dm$k[0"j`O&Ic5dWo3@?/Z&h)YKle>\H95*pn(:]A$;mJd&]A+_!8C2^,bV.gr"_
f?*ifs_bHp0F&+fKKd'7(f;.V;"eN]A8sRIpOU,kFY^0k>+!kdY1o>8S("CV:X&Vlrlt6aU_Y
ga7s*KD*DBLDa]A6+HbagU>mNm.B#3uBAVph["5BQ]A"*1C:3jd&dB,FcSbReDQB914Z#pul5[
bkR`(sls-9c7M*9lSD8"MSJ1Sfg3]A)*h8=]AVSZ?@@PP)WD!mQ.G,^7D31?84.;S/b2A?X8K^
<Pne>RUP1Vr91>+f\QFO*L4=utg*#UJ$ClQ#c/VA!05*VmL(kfUlG/e!<(XPh[k3p;i2qQ]A]A
RsP6l)[;<C4&jR@FB`0`QtjMY&fjerQJ":.&[_)qhL"[MNNYh\bX4#s)'ZA.[A7r77R"=Vkc
<5_Q1*K4,dTq4=Ed'Mo?pP6GB33\OCk1/]AcXg)"t@7%R@:&`iN_Ugm6YEVq2H#C/laBFMbF!
0st^C"<4-$^Y?$hVN5BW6-_n)O!OK'QRMH7HS6toW/bNT+"0V(mM8!2J<"^oJO4@]A?0+'GR^
<`4E2TE;)j)l4@>O=%JGKi_$lGJ@WF`Jm8&]A&g<enl+h#$E/RJ?S:k$PkuAB!Nn(A#C9\N0I
<#FJWocItN7J56gGLNM+q1b8bW^XAJkqijZ"q-3n=3j:qXdiY*.LYIU<]AKR,B?WHtSi(Dc$+
i1lpDQ/hG>!ss`.D2'2L(,Eaj<L=I..j5n<rW.o9Ki*%jp:T;aJDNH>+33n7&qJ@aj'l4k#"
HS[e$05U*V^e4imt5&V+2WpPG-G[Ofi"SlfQ>B5*$XpaH-3,m?lk7cgi`A+_9KWhrE(f;@3)
#iOram.9YLeoAVCO6*$N6WZA#5@1o;h7f(QJhn11KSMZ/07@/BZ?U)8clKc3g^81\p/?<i#E
>trm0rBc3UZU:]AYJ",(ErKLYXCA*_Uc0:CM6=Y&ED<Og7qP#TQM8Fhst+P1e`C8$?<Tqf:7h
qD1(&Ao2[-X:3tp%P@S0=_g"*PRgkQ\qq5]A6!J)%;W.R`Zih<hF!Bbo2q3sH:[^%$HBP=7_E
IKiNbmD^uLO5C'[OdVj!%Q;23V/j*0Yf%3:&'c2Upe4Y-G7a5qbUj:d/p7ifi^\QoD.unV#6
Q:DsC;BZ4C:2.S3oFN=O&q/lR`7lT-!5*a"5XeN/5uN9$8:5".>W^ougaU7,)/;065VUlPai
:L>OR[JY6?j#'H<Z1$Z<^MO<m&3>i`G&-8]Alim;6,S#;YSVm*3YsJ&c(qAQ,mk*.lZU@V&i(
Hq0H#(ra=F#2TlT_q*e;7F]Am;mUN[$gJS-&5d:V2Kc0V`F?!r/$Sr)fPF2G-j0kVOK?=$IdB
]A3fUXk.%-GFnpP/D-filsQtLPq/eT#c&Crhsp)AB$g/a`7oS\,fR5+N9%Q>7HWjV9$#Duq4P
I7.tQ"BJjGTMQ;lrX[g+7,2MKJm4n@>W#iA-r!\=L>*938gq=`<'?BG[@Dc[aS]A`Y>[/TS#7
%,9mD:U=mW_83_WZcr4kCuOgb;KV+8I$TnQ*7$Q&2(l51Kc\t&&AdKQ3IT?2Q3U/tct#aYe`
G'm4u*'3>fb-?Gi(dOE.JapIIP"jD\0R1=m2Z?HcDMD-q3[;\VaPKi2*Z$r&d?J>>Y+/N0^T
4VaXXso/2ltNj7K5lX+Ti<6jGk54Ma$]AjIntA6)70L`7.hBJIp<7'_GlKS%%@j5a#bHb2B<:
1TA(WJ9VLuo:=lo%04Yf/RGGLlEQT\fAfauTG*nY8Gt.U[^3W@(CiaX(55cn*ccKgtjqC>;F
XKAkjpFS/F$OkQd:G"_!2ei+",'ua5Wr?H[>_&X>es^q#GBYVih(\,4>FV3Q$57;$c:uXPK/
P%3kg[%'pDgN6Br^4"5@td6hT]As(#a0%OIB0/5`&3VU6hajmqLr`TsS8md*3dZq#^P?WIW6J
:*VBTM>,DDJS0b2H&^klFg+_hk\3<87T@`]A;.+6^:u5,$"tGnT;kJr0eW7lWSd)2.+?YU[8B
):Xc3aOG`q:0G(#GJWnhq<?*B[@%1uTaQ57D!N^l(rt\L@P-m3:MY.dS9NDlURIG@uE>O(T,
"l'/@:EP]Ap6N4sO#>5Li*1`W?3,9m"=Z2/h",P7!BglB%N_m"o+7#iW__?CKW,i4(qY4s,,r
\uH>;Bu;fV9=5dBDcmWR\BS@Es<VZ^hYfKmS3%a7d]A2OEf:FB'>WE^AE1p>3[:T5'<1*Ai>"
QrThk,^d,`2//\.HH6uNOo?709G^ZQ"sSOc:([lpRA._Y]AN3LI[jj%&I+.78"'493\9%%4dY
LEnIad,Y)4?7K]AW^A(5nM"-\=?^IAo,ubkMN*gCAj?6*L]Ajt[c,MO.'F"TUt[Lmah6E!d0li
pSL-#X,,<Yq9e@L^.QIt261KS67;N;:&;H:"g7&3$=hdBJ@!Cpo6P\92eD#rquUBe@([M:h&
_2h4A0l#,rWdkf?g#mPtD>@5-QnCX;DB[id7Ye5iNJYnY0_cIR(4:eCr>i_2)9*%O):S(`@o
e\X%K#1f2iffu":DZjCX-9`<As@BoY"L;'I*lVk]A6SDnNWO"q#)0rjhCVc]AC7eiWXgh=;Y?f
QSjKrgY[d"Gi>`tUU)$T'Sl'[WA;$#&,Zc29m#kos6^?jTh6,6;'3l;0gDWrrjGM@l\l^S5@
>3Yq&3H=B7l&hMH%W)ob,Vl`bSk/LF'?78Wc=e44m:71.GEUd+gRHeL>#O%kCb_A-)&Nm4fC
cA&JE3ZP[RiDr08e;?L0*A%,E.KQMV./c$U,cr18Wd?HpjKC'.(?W4m,MVj5qQL;"!Y=\Q*t
<<oMZ9iRQnXHpp1[`$OlA//>1[X>5hV6p/LX0m1)&I<?ap^%KHtT8N<.5W3Bsi6rod*L*4l%
=.(a:D'V>aj@Bc)kCsf>KT76IUBO`16kKeamC%C"o&$fH.NaNQ[Fh`fK%`:knJ,$]AMbT6%Ab
>dLE\ekqfUB]A7:O/!LK>D\M,n'>pmu6<[5XK>=:2\TH`Wq4mB^LGqqb/nj6fm0mCL+iOH#p:
*%iZ?N"mSN(_dJkUtm+Uq9EjUZ`8KRA-]Ahs-ek9LR:3ah6.&eBjO?YUE5Akb2eB3Z_QL+iUi
_gCO9pD"+sIW#qBb&MZK*id,O2\6="=C([hSQcH8eF=?.hM-Ppm6Z+,=Zi7V80X[%7@f7]A6C
O)7W+EA6^3*JD>,<(+l;]AFOYIj?L(>o^n>``>[kH\UJPhEY"TQ[)g;*jQmILtq4kRnL(_'/\
;6&\_i_OP:[Wdt/0<5=7pBIX@RS8`hdeib1_&e^3_PRs%IdLqCZB-XaccQ66iZlCD`o[]ABd"
dGNfi(LLNH_SE#m*2N@0m#'I8rZY)EhXDL'Da2+,b-gSpDD:>O.6L9ro'*uISONpGds5"7+=
nd?ogF_Iamb0PL<N:O,5'kST46K6r#&K/<$o?:2N`YT>>rAuE$m85047Jgm?#BrW5-l/,&C_
4!BN(E/'q(U!g!)g)cJ"lIPiE\$DE.DMb8GG3"SR=0m--0`)ZI:Kd)KoXVl)CHdbo"8&8G#?
*G-B^286n:E8)W4&/3iJQIr;O5Yuj"?Z!0_<(FreP"n]A-D*1Wj)3u2^;.E4pU0d@SMG#"kPG
p/Y5I<2!cPM)#3($9`_Mh>*B>t461#o6+n_52M[FEB/[Uu\_!D]A&9.3Hf8<#AW13pb_7b>Gh
'I1ut=m9<=@#\%N&B3f".NIGuiN\c@%o:h%`Nr)40\>bkq7#!WWo5\gH,Oh""862ArQ"Qd$g
/QL6DRk@BI-D`3VUHB#1U4^0m"4;*);GGdm[U#74jr(ru4>)d4WL8;q%`g!t7?>9RKoXm9(J
_-SXV1cJ_PoQ@P35<u<p-%P&MFbMod-%hHl%@7KsE,+r":OR\?TsZkiUp.9Rl,hGs%mkJZhh
K)9YniN5Q;]A0GQ5eYM\_"8"P14gnf-XP@ir?[bOr%0srhi:D5#Rnh+SM,qf4s7EOAb'MQ/"\
@8/-Xfq>*i)LGD+t1hr%.rNYdc]ALj_q4"K$T*Q*Ndmr=heY'sf+D613?=6&dG@"3Ac%Re?\Q
uE=^-'%rDpG(Z^pMd1=;`!(Q"a*b;pl1\SqpVQAf&m[/9cM/<TS>dVj7rM_sVFl1ml(qj)/j
G,Lt@%69g&Z/p9odZ_873$+cX,h%Xm0#7sN%^#7DMR2#_K@+fe0JI`/T0LhJPMN7RYM*Ps$2
U\.F+26./QA]AphG\CNFOipI#UQLrY)&>a`RnrsaYaj)=4jN2=gpd\H*8/732&qZI:Hp_&Ls1
p]AdkmCIn$Y8(T$TsQpV/2W&)7/:o:L?X*Yp%^jHRHI/Q_=Y;t0d:f1--0WQ?nKlYb='+qq<[
QVl"$.q,>+USo<<9KV/IGnDZglWOdDReouB\?JmD-pkHgJ8&E]A@b&H9(tTN55sCW4i,PoM06
i.1@Bu,FNUmPGg^L^S)AQIc_1da!1ge;e4C@A(#cg#KRPkU"f(3AD/IPoF.1VN/LOMZe?Og#
#t;Y]A4VeJc7:>^/I*`_Ch6^'PUqf0#4j3m:Us#rLWig8;BA^,.1;<XGJsr6^P,#^R6C@dO&8
CQmacb67i)_]A-#u4C)c1@uNWsc<<q-(/d(n-4e-e\eC/7obMb/eFRVXRG>SF,p35IVZa-hW*
BD'N?B%n/r$!7_B;IcU%N^l3P8+t:I:RYO_8_j$;R&/br"53R(HoCIT!m?%7H[HN1\A;OrK>
4j]A*Q\kH1@nmP;">jr_^6V@^[s`ND6:`q_]A`9kN^AX#K:@N?hMk&$%:THB1YdNjfqQ*llD,6
G3"*`0rf.GgOd))Xk>J<q":@!U*1O!VJO0,15\<VX\Yu!uJaK8)n[%q]A$bia^KPLj&$L$Vji
l\`%M4lF0EnghIsZccX=<X>7BSQEI>oY7D)5*'RpcWVJ/SbuUq1=m6*RbL@!$0Kf0NL2X9l!
m+MEdgu+E0+@]AbI;^-cLOI?aS`fe"##8;s,HQN[dtt[9Js4n*o`nSISo4-]AH'X]AkH3$Ke,XU
!)&%_3`Ho8Vc@q%t7Q+)4(3cYcS"AE>-836V>[?etBNdC&lFIPniChH)N#Pi_R@Q3oY8na.T
U/adT8jgKoY/h+/Ct4ta"/XILN<,sr#H^5f0Fe!1+niNXJg$>ou@IYW`&f5Y;[aITT(<0P2(
g2;[3aMYp7EqZn#$-(Q-b`K*"qr17EU##CsuVkQ\c&Ye,4r2A`\2'<3q6aI[GeYB3'1/21'>
g=CPs=3ueQh\15\G25IFaRa1`^9O<YLr@&88*`5\#`pXG$cM^6L<lqoq;/LaM$'[8%MOC9'-
Qo6E;M^oOXg<SAoYOn\/_SUeh]A).Y7i=.RM>ZoBtRg\eCEI(,-(nb!?S3&6(G^pWE6Pt4]AAj
i]AIA/qFf+U(E/2!5cY/tUBnhWF:'#?OZ[FTUHWGp=+mn/n`jAc<4eCE=+qYdBm9;`L@IM3'P
VAbWFa6gj*6qu.:W.t-^j"gC[F\TM=o<U/EJ'L]AB^2NH,5HUb5'c(7PJ/NtnbiLN(S[sq7@E
q]AFqT`%da]A^hQ,FnYQ*rWBZS4aT9o1]AflYmaE2c6j<\hKdXlF0>ss4#jWb'n-HVLC+#%5r4Q
AaXDU^92rXI.NXK2Y"JC;WA/V]AJ6(OgUq*J5<Lte1<@.X]A2pF.?b\C\<=f;k"eITQ>_mJA/5
_U.F'YpG8#Y;P*-m4_fPK[Sd,3O=5f<rLI3j1^E5RY]A+SOKtNoa?ZI#s*.Eh"=W`L!%uQYFU
:`c%GmEg2?OSQU#@1j1.6FYgZGigX:c2n;q(nO6_:K(PdP?=`N1kr(b/a7!\jSZ+h\E0`<"X
9]AmXXiD3<n)L@d0,*Eb\)'a(ejB==(2Fe,m!Mpq`?q`,F2KaaV7o!CGdUPamdA@S"u+Ue&^N
qWHs)"Ei<UROVi)Xk.5H?2[Tnp,^@&*#n@sd18SCICYJD4sQ#UJ\oR22AB?<257sSl'<:`29
pY0^O^%#Sk@&]AU//^)>T0mL0c+qPh/nY,rH+b^NrJRkE[4-p[)ogUJ>WpGXu'+q+d"'rgS-7
i<4Y4&2'&C.IkGs!J_H#msBWs)"ikJk?!=b.6fmqGh;hRlfaV/NR1h!Vt6#i'tLLu6[(PnF]A
Zdb!WP/140a1^ts+LGZ2>LV&9f*n`o8$n7rfiR-_)%OF5cEBWOqXDU^lY]A:i(@`*(Ojj,<W'
(A62j0?A8`D]AP:c=%2D$p&Fj$J]ApYS@LTUa%QQRa9L8-a$quS>bkN%d7hA>e8?J=mOF-uG&]A
s^Bb+oq=(qnO6tPh"?l$nBl%G!/K$2m%Io'PQ+'%;"9_rDMs#6-J>;DT#S,UUEIa8t5e,q0a
LR7*93fSZ/+_CWAQ@n4tJVtX@+.LNCGJ<`a3Op&T-fmIs,!C^ILR5Ji#n&lE[G7%=E2#P`3p
H+I*'oq9e!Rp(#5"t#2?Q0;^P\8R]A'8s9ldQ%cV&>C(jh3'_IZrErM*E+%F-t((Fn,QYNA/g
LicGjKoRD@`8`"JCqm]ASW;7YJC$f*\#T/n,to<,@O%MUkh*a,G7+EYlmI(fK3@(;!SATh0f!
JN4TSDV?N,gT`'ae&G5+Al)4:2=6cg;97:RkNKa2tu6p'Y_ccFY&9?X>#a=<HWe[*at*JH_M
3\ml$4br3odL'IoQM:1&EOfCV^i#JjjCP[aW_oG&]AhPli(VG^SESL$uSX?1h5m^B9doTmX8Z
R$jEfq,th9,lMMI$WArjqF4m(Ddo3iU5uKa(WqHrhtOTu/h9]AuF7[JtXs!#YiT]A>W_A*2;*=
T/_"DcAhTC1k+.N]Al7AnWiM13lR:'t!a8C=:`EXoG]AIJ(<:&m+H;FA(_Qmr4c_'s4PXA(.1b
N1+MnZ0/5udS#T8+b]AK6*^Y84fi!IHfQP4XJ.WRI#StH;-cFhpsfd;mq5IMg!5LEIbHaggF7
n;Dl@D8oQC*.n`gThCej7^"0cus(t1bAJB3oN949(muC&:a3.:%'-k(tJ'q'EM?i1nQPMC9F
Aa&V.i!2KL;M!;G)&i3>tK.]ALDU/'+m=)-[),YCCaj>`90RL/;>lQ)8*Olms`A[,gg?pFH,#
c''ZeZ#r,&%ot$9rB(PFJ`#",qSdKKrt9T6^ZRH/oBRjIi;@57(dD`$3OO.DA+DT_Q3Vl/"U
G#FG(3"<UnP4*!YlHXK>dl:Q40;>moq1n)Lf7&jKdB=8L%h-;ecc05XG?[f(s;5M7[]AP;HK=
8X!!i1^)1@J%Y*1r1;EhS:a9-qTL:!;*d#k`-`j4#d%$U/a*q:Uhb?T_G"AZO>4jfkZu,nTB
?(@n?Q/b=XFB9<&Aml:</9tWW7b&=jKGr@ImZZNroT<p9'hYT@+OiC:DETM70+97atTOUf&k
?L^Mbs".VY@LEcnhh:IOOUesggNB9af?lS8LQC"D3->!/'DX=$TFAqg'1\%-tn#\H<5:O%rG
9NV1S]AIi[61=%^QH%qsX@*A-;lTd.NW&kq-j71&qPHLQ@n(F[,&ckfLaG8$ST(N)3S_DHNiA
)JQqj'@P>``:jCmO#X[,B7PJ5LD6l?-1F/7G_eK7<B:E._-Z:T4&pU#IbI"$CVa&$s555\6U
FVmh%SLKn=BTG&,.*K>Q74^'ThP#DeOh;@,eaiQH`PN^[+iiH1DB9*h+>?8))2^8.;hdPHrh
9[>]A`\>5j[V*%XV`ufEoBi?/#A*kSANo@aT&)b6$N2"?26;s!2)V5iif[ma^,iFTeiL1$cuR
^UbcX]Ams.BdgNurG34YcabJ8@LL=nBf&KHVg1&-HtYAgr.K`dZnTo%24!0)8Vphn^4D2a*$J
-1ZS,cDaOAB'<d6\=eA_m,Ki;#31FSJ$MF?8BTgU_pr%T_*P61/MVZU@s4`RJWoT6\/#k_qo
j*A96?hW\^CqnkPHnl]A5N"Mca(2&"+>/^_Q72(JtGL6JYMt<Z(><>(q:k85X<Qk#82M%&qfk
!Wq@I_LOOZ5X?'cKq]An0M^u,=$;oEA%7/hf50>+F^"'Xc+drR$,$0q<aW/!]A(DI2uX/Vk'FO
m0'>T-V"oOND!pVqNi^IpD-"]A<c4gj(7q.PfND8"Ctt.TSMuL#[B,8(F6*od,r26\@=cA6Br
6H$[J4I(S/;\!^4.Y_-,cZr5SIqqQVR.J-/,9C2HGum3a\sks!\MJX1[gVX?(FUu@LXN,R_U
NqdaH\H%uDh;*:SK9S<AI^QABSpWd8n<_C[&m#T#K/j=U0/&ZB;-_4Cg`F5B$F5-dpY1.f\*
rsSrri~
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
<![CDATA[723900,1440000,723900,4320000,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[720000,2160000,2743200,2743200,2743200,720000,2743200,2743200,2743200,2160000,720000,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1" cs="9" s="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="2" s="1">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="2" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="2" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="2" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="2" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="2" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="2" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="2" s="2">
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="2" s="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="3" s="4">
<O>
<![CDATA[上一页]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="3" cs="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="3" cs="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="3" s="5">
<O>
<![CDATA[下一页]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="4" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="4" s="5">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="5" s="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="5" cs="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="5" s="5">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="6" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="6" s="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="6" s="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="6" s="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="6" s="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="6" s="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="6" s="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="6" s="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="6" s="8">
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
<Background name="ColorBackground" color="-394759"/>
<Border>
<Top style="1" color="-1118482"/>
<Bottom style="1" color="-1118482"/>
<Left style="1" color="-1118482"/>
<Right style="1" color="-1118482"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-1118482"/>
<Left style="1" color="-1118482"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-1118482"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-1118482"/>
<Right style="1" color="-1118482"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Left style="1" color="-1118482"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Right style="1" color="-1118482"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Bottom style="1" color="-1118482"/>
<Left style="1" color="-1118482"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Bottom style="1" color="-1118482"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Bottom style="1" color="-1118482"/>
<Right style="1" color="-1118482"/>
</Border>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</body>
</InnerWidget>
<BoundsAttr x="19" y="95" width="406" height="180"/>
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
<![CDATA[144000,1152000,864000,864000,864000,0,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[432000,460800,2160000,2160000,720000,2743200,1440000,720000,1440000,2743200,2743200,1440000,720000,1440000,2743200,432000,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="13" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1" cs="14" s="0">
<O t="DSColumn">
<Attributes dsName="title" columnName="PROJAME"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="15" r="1">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="2" cs="4" s="1">
<O t="RichText">
<RichText>
<RichChar styleIndex="2">
<text>
<![CDATA[年度投资额：]]></text>
</RichChar>
<RichChar styleIndex="3">
<text>
<![CDATA[￥]]></text>
</RichChar>
<RichChar styleIndex="3">
<text>
<![CDATA[${=if(len(C6)!=0,ROUND(C6,2),'')}]]></text>
</RichChar>
<RichChar styleIndex="4">
<text>
<![CDATA[ 亿]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="5" r="2" cs="5" s="1">
<O t="RichText">
<RichText>
<RichChar styleIndex="2">
<text>
<![CDATA[规模：]]></text>
</RichChar>
<RichChar styleIndex="4">
<text>
<![CDATA[${=if(LEN(D6)!=0,D6,'')}]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="10" r="2" cs="5" s="1">
<O t="RichText">
<RichText>
<RichChar styleIndex="2">
<text>
<![CDATA[年底形象：]]></text>
</RichChar>
<RichChar styleIndex="4">
<text>
<![CDATA[${=if(LEN(E6)!=0,E6,'')}]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="1" r="4" s="5">
<O t="Image">
<IM>
<![CDATA[!H%q#reXHH7h#eD$31&+%7s)Y;?-[s)#sX:-jU"W!!!DQ;/6.3!B!G:5u`*!mFAsD_a"3PnU
R9rTal\SL8*TQFmoFe$JG:l%M$deej?(L(N:gOJ;Ra$2UFn(oa-LO:aa5VfC/4IUZ@m0d7D%
lIRDPqqf6D?"@@neCRGET`(+h\M1_IS0&H,Q8"?Y+_Ep1piY>J[i;g@P>Q`SN8!k!bT_p?_R
5"&$IJ0Cp%i7\PE.fAu0Mqt1$[,^lQSs;MB78)'KE:@?f?R)A,%L"b"*`ss,4_`mkK_1?KN!
LoO/P'CpbYGQY&kp*8MNc'-`ePqraCK?1A[;OXqCI[3Oa+#leAhErbOJZf18>W>bl)spNHMc
GB,)RnWkBNa;OCt?0(9oad5e3"bCMa9p$g2p"fE;Fh4Z&[*UNrG46&m^OCk]A3O^5WP8ME!O8
+NlUmhApJO&O.P$MZ"!!!!j78?7R6=>B~
]]></IM>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="4" s="6">
<O>
<![CDATA[当前进展]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="5">
<O t="DSColumn">
<Attributes dsName="title" columnName="INVEST_AMOUNT"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="3" r="5">
<O t="DSColumn">
<Attributes dsName="title" columnName="SCALE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="4" r="5">
<O t="DSColumn">
<Attributes dsName="title" columnName="IMAGE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="2" r="14">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="16">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="17">
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
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="1" size="96" foreground="-3995126"/>
<Background name="NullBackground"/>
<Border>
<Bottom style="3" color="-789517"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Bottom style="3" color="-789517"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="1" size="88"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="128" foreground="-3727584"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="88"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="4">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="2" imageLayout="1" paddingLeft="0">
<FRFont name="微软雅黑" style="1" size="80"/>
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
<![CDATA[288000,1152000,864000,432000,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[720000,720000,2160000,2743200,2743200,2743200,1440000,720000,1440000,2743200,2743200,2743200,2743200,720000,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="13" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1" cs="12" s="0">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=$projectid]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="2" cs="4" s="1">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="2" cs="5" s="1">
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="2" cs="3" s="1">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="4" s="2">
<O>
<![CDATA[当前进展]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="14">
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
<FRFont name="微软雅黑" style="1" size="96" foreground="-3995126"/>
<Background name="NullBackground"/>
<Border>
<Bottom style="3" color="-789517"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Bottom style="3" color="-789517"/>
</Border>
</Style>
<Style horizontal_alignment="2" imageLayout="1">
<FRFont name="微软雅黑" style="1" size="80"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</body>
</InnerWidget>
<BoundsAttr x="10" y="10" width="840" height="275"/>
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
<![CDATA[288000,864000,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[432000,460800,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="1">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1" s="0">
<O t="Image">
<IM>
<![CDATA[!K.&%r/"6F7h#eD$31&+%7s)Y;?-[s)#sX:-jU"W!!!DQ;/6.3"&_]AY5u`*!m?UC='2]AHu`s
D3d$]A0[r)N>,7Je'QHd%-"_N=0sM'nV:^\5D8j';H7-&VqQe7!Yc!#`9!7\D^ja=t7O,Lg\#
S5YIfI[.ERiSXHq<F/H>N_6u>jY)>Nn4.ZB.^#q8L#U*0['mDnEP(<Isc@IgF'=!>fr<7XQQ
E6,dK^o!+`::9qPoYllnD2f#5uKtDGBFNQ(>eO*W,H/a);!p_BkHLS9H\dU.P[:IO\@&IZ=L
;Ta,kRlIKi)Cha\U9#?=-%]AD^9!:,ZOg4_T(>!IMLK`WD.WgA'/(la&<-M7K]A]AJs3RZ]Aj-t:
Xe3%<+P]AIMJe+i7Uk,3CGMN]Am1DU`%VOO'""FT$p7GsEJC3(!hTHM?OCOMahoL^10[CkR2RP
qu<l&1+oT=7SiEh#i)gar"^\W4P?c(OYl;(RE:FsN-q#;E0sqM/>_&:5#?2$uS[\@t]A'8.[H
VpJV%!j*;\Dcm&OAj0r22l36QQML<P"6+"`J_&e-H,Pj:@U&oj8S#*R5(%Om&GY!#TCOBN^0
K;VtY+g_c11Bp;LdiVi9;.0)i)tRWS=KQVF$)Qp@u?%WBS\sq2=02!7h=Epe6>PEb&[#Oo`I
->:q/;$+lT4m9dY+J^HEpEmX%X:MnKD<Rj]AkRc$([+T?C66`7F1S109]A5b"3`7dnS0a8A^?=
jFM`5ODQ&FRDW.43\?>J@m>&k4\I24aP9P[$=,7$F/Qpt1GPSJE4rhC*hpWj#HEAelfcV(#/
d0>$/sR$8XO^-$r5ErH^,e0!^PU]A]Ac]A,T'=ss01$m$gGjO:dG[SM8NXU^i-HtZC\=n8!"Co%
``eQ_\P%?Wn#kNRpKH?;onafP*U?VB*5l3j6+n!m"4VPp^g9EC<,Rb+.pj(rK7:L\rkenXTf
Wc&)K[kZSLS\^'IDb%P$O\6TG#SpEE)tqb7hAE%\9AQTM",Q+<i)g(I98?0G2"dBHRd;o/Z9
_,3"-OT:(-eK5kFN5-f/5rn,_&NcjK+Ur$*q8lj1GTK7MlAk$(N"U'U`2q:ojrqF*3$_is?M
A73gq_09UuK?PeMF;8m[d^*[2;(DZ=5iS^!VL?rZ!Gushz8OZBBY!QNJ~
]]></IM>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="1" cs="9" s="1">
<O>
<![CDATA[项目节点计划情况]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="9">
<O>
<![CDATA[  ]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="11">
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
<Style horizontal_alignment="2" imageLayout="1" paddingLeft="0">
<FRFont name="微软雅黑" style="1" size="80"/>
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
<BoundsAttr x="10" y="295" width="840" height="180"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="report0"/>
<Widget widgetName="report2"/>
<Widget widgetName="report3"/>
<Widget widgetName="report4"/>
<Widget widgetName="report5"/>
<Widget widgetName="report1"/>
<Widget widgetName="report6"/>
</MobileWidgetList>
<WidgetScalingAttr compState="0"/>
<DesignResolution absoluteResolutionScaleW="1366" absoluteResolutionScaleH="768"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="960" height="540"/>
</Widget>
<Sorted sorted="false"/>
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
<TemplateID TemplateID="82ce5c33-859b-40c8-98d6-47db4fb56288"/>
<TemplateIdAttMark class="com.fr.base.iofileattr.TemplateIdAttrMark">
<TemplateIdAttMark TemplateId="44e92ea0-a1fc-4f42-bb5d-5ec5623c0e0a"/>
</TemplateIdAttMark>
</Form>
