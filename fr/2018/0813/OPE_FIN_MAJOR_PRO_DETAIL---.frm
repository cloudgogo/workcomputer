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
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[MAX(E3[!0]A)=E3]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
</HighlightList>
<Expand/>
</C>
<C c="3" r="2">
<PrivilegeControl/>
<Expand leftParentDefault="false" left="B2"/>
</C>
<C c="4" r="2" s="8">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=SEQ()]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="2">
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
<BoundsAttr x="430" y="230" width="352" height="40"/>
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
<BoundsAttr x="25" y="230" width="352" height="40"/>
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
<![CDATA[!H%q#reXHH7h#eD$31&+%7s)Y;?-[s+92BA2[BTf!!$l88CmhA!B!G:5u`*!`RusU!DsEJEE
\7%gqcEN\:?Y;+F:_)r=5J4]A`b[\9-1@MDe?_O.DCDijT!D8[pV]ATV3/Y6g6)*%X_HgCbU\.
9]Ao-__+sR#?Ll1At,3/(YOn!UMaEW&<',jZ^Va(qd!Q8s\5S_lPe8Yot&siZ-E=$$1N,o"5g
)1dk!)2C[!4-nZ^be4X0TYr/>iK#h\+i1<C]A#",*\RO;nI,\]AB>?\\ScR/ppkq%#a"q+)Gm1
@XR0A+^&&8d?VZ;T&5D1/.^Ml^@qpH5,FheI6GL-LJFFlNIjs3knm>5E\cK-fIE,QXS6Ls>*
&J>'[!WR9N7;)Z4KGL4M+93ko$6Ve\!?qXb^dXbE!$$[6^Z?HRdLn6e0RmT\LN%TQ<$JcX)f
:^p[q6^-Om5/Z%c79e!!!!j78?7R6=>B~
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
<Expand/>
</C>
<C c="2" r="3" cs="3" s="5">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=toimage("http://" + replace(C8, "文件", encode("文件")), false, "210", "150")]]></Attributes>
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
<![CDATA[=toimage("http://" + replace(if(len(G8)=0,C8,G8), "文件", encode("文件")), false, "210", "150")]]></Attributes>
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
<![CDATA[!I"R#reXHH7h#eD$31&+%7s)Y;?-[s+92BA2[BTf!!$l88CmhA!Bs(C5u`*!`RusU!C7F>n^
UO9gqcEN\:?Y;+F=";l8aAaoFef.p*GpIcL/oGn%C0a%D1X"Mbp'dc8FEiZp!eN]A@*"]A278/
."76o+[6V[iAdEn=7H,X"Is=Zf<"]A+K8H>\4RdNc%=pVi>%2%HrK'8g\7gtqF7DpgG+iZ.'+
Jp3QN_"Fl/n0A9j<F$!3?"QFaF2OQ&X&1b'HmKB&Q/T;;$)7j8ccm:"J?$O!f.FZJ-^]A1j<D
kf!5CDYRfN4s`)j<9i[\uJ)2Gs3ZJuGi.1jHq!-&tZ.#O>mMW5u_86cLP`?bLt4;S!Yk5\K@
W;s>N$:$I4"]A5(WQ3&as`rK`A+b4:>%ks'"J1>OC</WQj<\)IGP[DU6iXFJjMDJZ,*u!0a"(
DQ/GR.]AqLA%D`/`M5/!V5M?"7Oe.z8OZBBY!QNJ~
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
<IM>
<![CDATA[m<]A4#e,B1D2N'"q<2_K#;E=E7P/AWsUIRbL.&SMJ*"1jfEsOqI3dVL:P?$Z\$Y-Q>P,;d40F
W#9[Q2R!g#!e7qtp=6Y2B8iT'Q3$s48ojlZ.FIg&!tjYPWd`hm_JR=dUdH]AQu:4!*K*P^-+s
d!&5Sr!:5Gr:OTOZ132[+DXZKVloH&P_G%(*V#OV_0k.hKei?S*3&Ilt1#`KqI>d3Q?Ti'>h
27>RVh^Z!9l>q*kFB$)2n$6TeaM:>pJ<(D]A5&"LIHeWtYWD[F-FMGbV`b]A/pF=!H-UQW0OQ@
._^8AX9CMdOhG=WiGgE[\Q_C!Akre<3Z"Ko_\De2S$$dT&mk#Pr+:L5'Y$HJ79EDViVS1#q!
08+bICt-t]ApETMmTA3&@ZW_FEe",m=)Zi%2Wp)9TU,`QmYJ^AYE_i[E#>l^bAU3r28^R+[j5
m7l_,$o??:fn]A<(^dN$,2\T-/&l>]A-[nT[h!uf<N^T>`"sg-FR3@Fi]A=Z=BoeI+KjR3u"M:j
q[pL'9#m!M3g+<p`KH8Tm"qdU$I%C1ZTs*k.(.W2U'Q.sW?37<nCs8q"aiB^h2dM?6/8.Lo>
@Z*MhQ4,AK&-A4Ab0WQa^T=5[NmPmV#!)Wf9?+V=D:4n"_`hUd2duGH[Ho1A@2h2Z5H(ZQId
UK7]A;6C"=_@KiKB_^Gd5JGHEW<#(p47?jl>Gtf5XiZ.Tk0KlI)iXJdc7nrg'YWQ`tj4JP58'
Z>[R\BPpX.@['m$fj+;6`TOXZdAj!F[P?*^\lR9]AikD9;D@aAY(kcb%oQV<i3G=#Er+mtRN^
6q5k%*gBDtAgeY>^$8(eYmAP2[U[#7m"!;%i<=a;'URQ7K7EbNmse%TJV(Cs_JL=46<B"FWr
BI!@gFg;G&MZLh5ZA7f;?5r.haa:aGFi<sP(ZDgEWYW+m7%C[KB-k!?D`#"?hgL?j+(C=t<[
*:kkQC'U>)2W.Lijq'R^FP4%>lERmdo^:.KH7N'e3-qMYdXkr-dXQ6!U7eiWl[q>&Zagr6ON
[:9g%?8G=1"H+j]A3&>l-@\k?JL$gL-#KN9`/7B*:o=F#h=Rhb7W3Qlob=6c)G2"'a#8jp$R?
'guXaP>t3R//^?BD<[gq;URcUm%s1`P_dK_4f\(W>`$Z-']A`^Wf%g8,9HmZdCkIkg,')I-pK
d(s+^BusPfJdg+3g-jXS8HC(hSSU`tBNrmI^S(N*GH6qee3pr6\QKP]AGkUY3+VVmEoqLFU9(
k"&jgC)^<ic>o[>FB;'NMTGS:L/(]A/%r==W1"'V$Uaf@lN=g@_*k]Ac.KA^BWHf^%pF)sDXuG
H^P8^ka4u[01?T;6Zm*gK%&4.Z[$6esMo)r:2sGI):mAi8gdJ0uW>`[pOA-N<[A!R@\SC?HW
/tAk%+!0+kXPp[L)0'\Fih/b5CBf;mR8.PWZm2+id-^MSnj]AU;Xlg:[X&2R=hj2mQkdeMetS
l.9=lft;K/OO`V+#gmD[.+mj.#e"f&XdZ5NM^M8X^:.Z,',@l-Y-31Z74q/H6GPo4"9S\CO@
dBtDF]A+-37`FW>5)Z`/=I1b&9hJklF2'kQkoe8Rr)=@`'FZ@^Ss!m5#\I@7#+:&Ce&-)"e;%
\o&ITTci;bR!Rlq]A+XfVJ8R,UG";o]AjSP]AJHR22g=6O#AEJQ\uk5/#r]AhXp-$fsb8-0*)V.8
5#R]Am&Oh=5-==JBmk0IWE)]A^B):V;`HZ(NZk6qUQ2#!tX>'nFD$^i6pBTW(QGqFaZYOn\O_B
Nt*R_=%Eh/'!$mL2Z/rm3#5hSH8-"$r('X]A=%+343hZ(CW`3$262brB9tO%p9*5DuYadt@qE
_WTUlmqId:$Y<m?Ch)si8s0s0%Gm'-fIrcUqnQHu)u+]A=I8;CAWmS42##RYZZ'=*"]AI*';os
AI7MP/R1``(TP5I"7+,@!.T;.7OSp8bVZZB0)5INu6$>KJjMWnNWP?4bPSFBV/\rFn(_]Au9m
K7ZS<'Z3<C-d!."0;+(Cc54Zj@r-h-"]ArFgRCufX+PV!f8[k<@FQ+#:7:Bns(0s0Y#2=sPQ&
ONDs->7luHJ]A0'jFC(I_\4b^"D+Dp#<#_kWA^4$k[d3E$h1M*b*GY+LPQ+jVgI!G4G8n-,SD
P0\c?>L#/=j'3rWnkcbmeph[Nk3UZ=B[Cp_88c0gQYq#b,$J.Bau#4sF+B<Rks&4"p`]A:tq#
XWuG:30rSp8BVib*k2m.l.jsrr<`aD6mNXC6HAa?9*=K54q4/A:("]Ajc;D?*D5Pc_KCi67*%
mY>%@7Z.OM90)qkkinW]A[_mUQhT;Y6O`e&02hhp;ntpPf_<k:K71g3:6(W@1?=B(>^LLbJBA
"ZF]A7sG?*DT.rtX9:.L11ko9OE9^+WbYEtM+(1[6'>fPT\7[3#E2u5jIGh3A/2OJc*`0JP7g
kh:=ME"unG/eEZA@%:^rWjG(pF-P0&pNU\d6T9YAoR^t#GL<WmRL#Wbp1sTRpmS8klZ[84&5
4H3;jFDg16,Y4\V,2=%cfPk[$*@7Y=*.j"*ohq3s!8mh/r1.Cj`k5lW:j;Q*N/S?r"@lVOMA
C4fL;L0g'431VEs4>!:uE%J/MLb4mokP=;j<')W80#=QeJ.I)%S5,m6K366pVk\o>97`Lfi9
+!'HGH>:*31-,kb>mnVR$XaF@?!0A<l&N_h?K!']A]AgAO*2(uJS=b!B^'62[&7b'>>mtS!GTc
8R@t-T&3lG>Gu++Ln$Tr%Z2b15%D+7XDZ(Tf"QlV;arXbDO:9\4k4a3k;q"m;3\jLi%s!HGU
9Cm=CC!7]AHK$sZ(`..#%TqUi&lBV(b@_GmB?>eHL/1!!fqHoq64VQcX')phZsn9<h!X[koFu
D_GfPsup%W`S]A.4Be+KlTeX%p>\rA(2&(]A)pD%R%b:#k"NtEmhCiXq]A>g<eE/(dJ"a7I*Zah
SUT=uO)Z6%dDP[Y0&OGB*>i[*R;8_'b4?\?VMAt+$Cs#QeDbiA3W/)f"IiWa7rh&f;5j/35`
P!h:$981iKh=<@IV.8?'B;ThfNKV(d2F(%&;3?ko88V@9db%Esfa]A8l!cQPfM4?!`RI2X<*Y
5HFc6B.ik*3<[,gF`F>,^3&:#<V5T?/SnBOs/:Z#!Z\I_u,C5q19=#Ci8:TP]A?*H`Ce#[`=(
aIh3m]A`:=b4P:I!E>U=-/(+#UQ9<<W8o#'[rg^pI9GdqBD*pH7:.]Am"LIiiPq-joO<uG?Nr_
oh0OT-,N$/*)A'jfq.%j=E'j'RR!fQB1R0$&iVnWdUm0n[cCbd_u!!0%!-\Z>c')Y>j-c(9W
_$]A]A=0%C2^%3+aV-:oF[_T'0Mm_WGr(4RAjP)P@V=-EnZn&[>bZU1UQ!(1i:+q9R(S?PEf-\
`+?p6mRRP>DFY9=o7d:/3:$X%<t^>9M91W(i=("rpeVSeJg.)8C/1@*^UT/CqOs=UFk"aSi1
q-f2D&8\OkCGBfi%GZOHX@VS0+a6b=Zo]AcngRs%'t4]A-B$N630(Dld.GSCKXciAQ59868O61
!IHoEP0%!A&aC$4!r+qOii[5"1I$GLm_2H3?MOoL;h3W)DaEN9%X)VpdHS:0]A#82AE$Q^AcW
T6&AKfn1a4?Mn#`c:_PD2EkD+af,Hk\lM7WX7FgnjL_\FGVOu6\TdHIU6n)mDg>qgkkTgHe&
A&;NaiQ8Fi:db?8_FM1*;#3g%C7W`W4[$N=cE?Y>ek6(2Bfn3<CQ38*e*GV+cFaW\cEtMhj+
YoZe,W$WJu-NL.Oq2!/a4L%`B%1%kHNU?+[<oO1.Q9%QAZZVgT._/q%+ZU`u9SmINTJFY8SV
(1J[M-=m"(7WI]AUpYactT4Z*J*k$1Oo?r>rGQ&+PtAX8(@?(P$(^6%c1Q^Q;h%#2td"r\o'h
SXnIp)$rOnWcBX3DKpb\DJ,PeM=iFO"D((N@oP0VZdKi>KD"ij04>[cg(K>BDq`QGn,'?D$0
PPEGAq\9@h5D[7V;&Y<m?a%CcAK3[JXMA&P&imJQM7_'r]A8F?E/K(of>)A`8os@W+Fhn5>`3
"8k+$+)WBtotN,/#P"j:0,t^nVYEa%2`:k&>N1XD0oc_+oG^PY%#ebjg<L3kc]A!-%3Rqf2]A!
fa0=]AkBtK0t9D'4/@_XitQ2BI[kV&h&o8a(+Sr8"NQsc]A_AXLIEs4=8sl`&mm.D(JX@>)_:J
ch[4[5?#uW^mLRPY/d$jQgJ\sYJDf$H0*;EM-[_^7NJJPUS[%F>8dsUe4N747\?Ah>^]A8T"b
7F1e2q%V?Gi$u7(<o0o?\>1gBC^L`WZQ8+*<(Li5!6!M<4gUm/CYCSI@CJ*K]A:48FQ-c/31S
.m(4Sa:CMYR$lM4m?r-dlVQZn(57C@16DJ=9[\$@u`IV3-C3_p>4I$#WtnYPWBlk=6E?EtqC
&;9^)a&EEZmE<k=&4VS*=o"&5dYX)Q$YFG$++2RBYPhG`K!+[pH?6(MoJ0/-[2_rC9`'("`/
/5^oOo^=r6Ye.;bF!d,39n`A[/QX"!<UJ#OqLss7F=r4EuqGR4=%aT/3m0K8chHi?0`Ce$@`
4rX22C(m3h:LqN5]AMi^c+OI2T8qOuO%_4o/Y>ndd:KOVaOg]A\jPU&Ec-pP8X?$9_'5:(FIbk
iLYr>IH+cYs58D.LlIgh<`Pc1$jQ?dQ"/j6t*maPK#!snmlmgLfP!Y$g2R=ro"ObMeAG^]AY[
o?lZOD)j,M`$<DVp*/GeH0qA<QqZOX?_&2`j]A.&.RDXXT^L0)Pq9,Lun^7Y/[lV&m7d)^mei
R:WF>=A936.pmor^&;<u*%W@O$X[!Zf%:ZQ#?D5#gp)C18ZhAk?2j(_:ab9kcMM8lUcc%]A[D
KUAKs?A/>@-`K*?D,d:3g,AeS?pOg%nVhMmc!KqBKn(>.6*[A?<!W.4j^B>dOS[WW.P-C_sU
q@PL\RW9gTCiOJKf<^s`,6$3tYl*EBl".CdCPZ,fk!/6Nc!O7JFR"F`<V9"\4#i/'"G(6<;/
G]A+NYk;ja7Lj"TG5egi[Y?YgBkk@7SLCE'Ju!_"^e:9lUeVaOr!D3@[p9qVm4_osIP7Vb]AQX
q0a5;&BIhC5AcM_78qQupQ_$?k<FD@#G_*g)lm2-r5RXl)i4Fl]AJWJTMnYVfX.Aaeh1;r<`@
$:CNA@bmSUGZ\"MlQTS]A#6b<ON#rGE0G9O=N>`gif"VY^<TB4.MJhO[pr2=T",ZLLI+Nh2>a
h*1Z;no\."H%Di2A("il)WnouY3gZ]ASO!213IBkND8Z58`&k6[Bj?O2E3cX[7Y0qtH\U8qV3
1["%qI+H=cJH>]A%Yk%gHlE]A%Z[DJQ(f>T\C,BsNVA#M4**bBsLUmLH:tQie%KmQH))CUXq^+
U'Kp[O@Cob?7jeRbfHWnb?E-D0bQDqAR7f'J?b(N/F8+`f79?UMU0,G,VYBLCn1Bd!KE!n:g
sgcXMElZV>k`\W(U$$=/<Z^;tsd]AWJt=<kau#Hg5S73kLK&p(nos[]A809%c4Mp+==*6V\]AF9
`q2SSF4Et&Wh4iI<WIs%<Po*^A>.8Li;T`+mJqt0jh-l9W''C=,LPIgJ5/jXO1buH;Zu5L3H
f'G']AeSXdCbYt?o*hh9uo0RlEFlY<T`_,go+'Rd!^c?#[&*(HN+hPc@8I!>ILFWPr%+Ae[7!
.WP9s>i'?84gq/)M7YhW(_5B9gh(uEcWYY8d^$,^L\"Jj[/-j->D@UA4?U_>p#$HF+F;pC3;
6XFA3$i4l7ls8&.R<9L6]A:E$S(H&T<S>b*qjj8k_OgM#J-oFW^mYrX<W0p<#@fikM`";TFmj
nPjV>KKLtM>O"_$]A'c+6Sb4ORs@8J^r'W1q0khb_.n+%a09'(O]A\2.X]At0S?'?_q*.l)p_]Ae
nPskuM-\MX@jYp)0M$cJ=Pr",]Ao^W5gJ;.><6Xpbi+3rV[_*QB%FK&;6is6p8h4AgLH:69B\
e,f6E^7nB?$iU%CPu7FO$Q+34CQKKAMmSpk1`U'm,u?!Hg@$!oGng`]AW=?*mJ[uk4kM)eeu!
?_HSdq1a\a!,KiEV]AR#fR$,\W@d>eHnkS'1Hr0W2n6VGXbGIpYjOtWGpGCn7!R'N"kT7,W(P
N^m3H1hG9f:X^`fH'7H0urZK\$@Za-%-*qfI\lm$f(os/!>"9,nPT/TrJcWS\f:obH6qgW6M
rtG\nd>NP9%L[Jj_A2/d_1Q6.-mOgi"=f%]A\#IZ&hj5(iW@7,!C8.ijYYT^2[%HX[8tB?[6[
:K>)Z&W"h4^/M\)gKd:;BgkIrMJh!GMWro)'S4NW!`/GlU,Ot.0'$EeT)#@3)E*Z9CCBYrYB
rG\$p?]ApL?EU&G<8V]A:R!TokL8uQcK5S/K;gSO9<--nm&2:(<FFI>Xk`<$B6#R2mY#t\dsKB
TXuou=FA^8u`4^a&I;m5di3kW"/+S_g1>K_+dOYclMgW"fOr(g1gQNL-+[s3r>Xj.)Fs#T?9
m4Ru[\lLe6gc+5;_RG+ol]AV"Y3Q7,p.s\&[V(:R'J6aU/E]AGO8O"g%Tgr]A=pe#-2oMG&R2BD
El9eTO,_,.$6D\b24L'*eJHTUG/f7Gso?XiQTC;r[dr'R@a42)X'^)9()E6XFIoP]A#7^I98j
HW=Dh*`Nu+8KXqf11dN+7F]A=K,Q,*"du#dUS&q1oZTGFK3'+gcVQ-JDB'UlVJnoXAh!#O8dr
cHM$:HopIcT!LAe'!C(X2(0qp9Cj4#-V_Z;B.KpiW-InPghb.o7!19(p%I^,-39+t0/M:+VY
t_7q)?b>)SNq.>[l+(sim`ReGRldJLK`BXa?h>ZYC#LZ*7Q.uT4;6SSuI`S[H-V`7gV'lO^I
'JJ\;Dfo(c`rQK%i-@,C:60*9%^:D064NVbd'QHnNAnJ`a:KA*j&C48lWRU9O$lBB9l%Z?07
dLC+;)_RODPDHoY.ObR.1NJZNbFId!+.fm=mbP/dqO_dJWis-00kRXm"O5>VZKBFjp#o';E/
S1@'4]AMVfe:`))NlB,"H&At``XfR.M*4lk*\Yt?4G.X2Ag.ngiD!qoc]A,Rcnl\J00#\X^:_l
`F>9KXQf27"b&;06`D)2P$?=)A/!i=#ks&r@FU\%O&I&Ej@[%j:e)K7C',@K<tq(j<>m1FlK
P\*I5m-`WIi2Wg>[f<MY0GoV=`gUH^B9,))K!I8etis.&)<#0'rfeB4&E,3QM9<oDrlo)J?f
$i_]ABECK8p;,8mabk!OFLXl6*H9I&5>oFXWm2ZIVeus4-o?Q6KrMOU=?O:$lLioQrXhS2nPB
8H_ahaT1\A2j?P90=FdI-,d(L'P2stoqU!@cS$a*-/#CM1PqiSB*-"B9KD?2NO",D.!Taj]A.
D53?C'q";0Ti$oNU2ci=CgX[]A5[alN\#DEf"@E^Q80fSB.)"niUVj2O!N\H!KlG_:McL8"1#
J)!rtVl.*s/0MF]AN,u0734:Sgg-@`6-h]AGPU4Ma)N>qEZddYT>:b8`Z@T1H.DY)[fWA&)i]AJ
GTt8UAO=LeGC"FD?Qo??"4DI]AHdb]A_sdMD\#oYgDkO2pj5HNilnQlD:[JW;BNKS.GJ@P`^1)
_AC0.7dF:3gTjJK!o,F;[+@.=/cld.t$6`75Rb>W]A>L!:[)?srEcLgq2K)RVqG5g)]Al8&=8:
8L/!6Rk<%Dr"=HP=Irutigl1!2#F6N/n^<fl`RqfBVO6Cp=$O*AX2OFdLlcn@WTln8s?`r;M
-PEn'fB\4]ANOLZ$FO409WM;;;X`i/sE;3\!:4T?2hA6E`_>0YRj%8e\Q8T5hKgP+OoE.-T5o
3_7SGQa=Mr)?X0*%')9*$IpBo@NNS`(4<WLOsf+$skO(@bLWJ&5;PCMR<\IAanPq>9\k??l\
<1a0E:q=+__ntf0C]A!Kn2LrM?A*6^E4m2acX$2Nfa;,1uZoMZe&X4CQOI=8$I-aklEf:\^33
.YR+]A0'ZEq></Wg@eBn]AJm`sG'V3'868?"he$[C2qIPN&:"Tt26`X;AZ5E?U]A&C6#/fT5SVS
3c6u:A"*n<K1oPU-)+[jC7rXRb)d?a&;6F^E:9K`4FY$?A%^,\8BJBPK$+=eBMegj+^+5C;W
::73ng$&^fs0N)[7@r[t]A_srQ_b?#`h)>ZAWelVSHUCOd.n.L:Fsi;ATK`G1kqq4''`MUcUC
N^Md4mUa(uOW`,IM'G_^55[JMA"#B!KF-(il]A#[FHdj&?$kR;=*5BV1@/fUB^X7k--b+YqB7
7.FlrjkuZs7kMX'kRs^VmVb[>2U$=eS+gR3-Dk-[B`UEp'3V0:);Q6.*1+dLbCm;n(ST;uJQ
^'krNgBW*_i0:9qKi5G#aI+R+&S\0c/g#>3A@A2Ge5,7GMNXZCPZ@(0:5AnNU[_3i3FJlYO9
Jbe_b)?Ya9o)>"U(3"Ybk!ARJK,%-TJL(ai@`N"^7<m3t)E3#MWo2lrGPs-1,f-_B9?+o8WD
!1Q=0gKNBe2a=CU,Z#I?<n[13)!dL:g()U-K(6)HQ!?!_F4(Nq<-'X]A$^8_&aKd0H(oerp'1
ts?(QGZpgC-@6?9q,%W]A]AW:R/uTXhH"3T3m9BrClH6tN2k\4;60gQH]A#G&]Aboh(/`WGSd&T[
?M(".gEWuctl!pm?Mf=?&)6i*=I*)R-lt.S.oM&g<DR(MeT&kb=b<kFVqch=Yf=:6!(_)'Ub
8RkO?kK/d_aoH18SW[6FcM5<H]Ak/g*1<:Me?M<YJD_/;kq5N(lM$Z?LLO5'UGEqP..pW-!Og
/`i8^noG50I4k\3E^,Gn-IUq%b+/,S/$\WN+^D1hX]A@uJgd34g\A^P9EqOJ5A@(S<uK2u^l$
235fc98)5K?XE18A@S`C!LsR2%UbI^;#O;e)NCR9_uuS%[///iGi6=[8YOZ4ZhUcEZm+HU3!
'sUG,E+OdsjCG@K&g0FO3X!f]A3mE!Ftj%XJ^ah'82GF_90DPZ9i?LTANGN^*2fBTNcjN//A?
SY"@'X+bX@d9M==/h;;#57WV<S.sKH<3[Q>(\&-H9_k.']A')_chi6G.?DsVPZpmBn#>a"9kn
X1?-OHglf2jp7EY6)*^0!Q#EDn54)]AV('5eIIH]A'I=R.1Rm@:>'0?orB*5W15dS2;#d<>Q[I
9.ieV-EYTGng'c0^Z4jWVc4_L>S$F!h0hX$56<H:dg+[nuD/*lPQPp3qL5=oMRc!CaGrV`8d
U!(K+b)lX=e6*A&:24Fr?4,RRcY`-!W3.@`3N-X5V6+5.()$$JJ'Rc+8s$d8A$%uI,=<R.*,
H*b9iq76D>`[G:$*1+!Q-3LQHkg;2(sH6ir9X6mZM$6=A(6,X2M\E%GtB"Au>S8D=TIMX^,?
>!p0C&N!8J"J%-j9g<c/3N1F48/f`F-f_A2Nlre%^=ail`.gu.0[@&(->kSRF%R">7Z^h^]A,
'9Jgc:qBaAfQ&@DWr8BJm$t\?tR*dWp.$\LmW)KGf9W$3jMAcm@6@kZ5Nf2RVteRc?cua>*u
C#!n#XSceRQF&,,q9M``dWoiuV\U42bE&J1VeHkVrO#-th8/@>WaJ$I%2?G1QY/pf3gC9mFa
R-\`5./i#<bg*lhXkK0;A&e/u47%8[$5cDSEJU<;-j6TJVp+2C"T'[Seo4MhRd'`);D>fqTU
N%UT4%/J,mJM:0<tC-H!AQ-[4X`qOco>%q\PI`Y:62*rP&^fU-`Lih;[jHL]ADEi\(]ASFkFP]A
Q]A4BBL#q):6e>=q%(<FBgo<@7<A1d4*.ROAeo>WmfC#AZW0uIkiIj)KaP#d0<2Es=Zc,U?3?
9jh\aT",r>em>r/#VJ;GT8o9dd\ufr7?A85;-4UoUNWYmE>s8rI-0Yh:m2pp#ampZRNJPZ11
`%msH:?M#ft0:%S1e\CWtD3\=?SI[:c;"Q'oa/'m\5]A*JT;`Ui9j_%Bbqm0.ki!gUQE7/=17
?g]AM=7t3%C#lIhMrkZJ3=+;f,O18W7co>Z7a.6"TdBMtE#lOtXE+s=i\ckp-3#[@5r/rsFG;
Qh/>kVg'r/Un*$7.o7\oiS*o3I4"*./N-52N$<&-=,/;gd/I4nnu1?FCBE4*_("X#2PI%/A!
E?1UQ8W?G`EIcXDnb/a`YlttIgS4inC^0q%$cAg#bB4L&mq7(Q34Su=[E<!ReEk<jUcb1/+Z
<b+.AedgFm5fBs`c2BNXChM*:.lB/\-AIjecO\\0E>_lN;le.H+/hs<=+R!!#Ci^ip_Zq721
M@LA1i=s7VanJ\IkJh+hTbeZA2GReqk)gqVk9s0Y)j-Y7AP!`iRW(pM0;YYfRPCr+`>KEiW,
DU/\#l[W_CKNf37Z9r^df/.Ct32l+A]A5cH>nKp&A:b88M7SfW_A`KpiFXOeH>8HT<5HtB:s-
)9L+-4YaH?*W^i5XI+:n3fFj:CA=`[_G9s';oF."IW&OrDF77i(B4=&(TU78F=4&RC.:gQJ'
lX\U#KE*XSX]ApAcM6oWg!+Qi.#O[uoj0*`6:LMBjYf5nfY<h]AOr'ga4S(\oX^,M(Oer0@U0@
2CC\=`@LWLn!(F#-XZ6Vtg.ugFF8.gq;C`Y4K\(!?plDQgu44+5K8g\"1k%g#bhA"\emm[b"
ta[]A*3drrE~
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
<BoundsAttr x="430" y="100" width="400" height="175"/>
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
<![CDATA[!H%q#reXHH7h#eD$31&+%7s)Y;?-[s+92BA2[BTf!!$l88CmhA!B!G:5u`*!`RusU!DsEJEE
\7%gqcEN\:?Y;+F:_)r=5J4]A`b[\9-1@MDe?_O.DCDijT!D8[pV]ATV3/Y6g6)*%X_HgCbU\.
9]Ao-__+sR#?Ll1At,3/(YOn!UMaEW&<',jZ^Va(qd!Q8s\5S_lPe8Yot&siZ-E=$$1N,o"5g
)1dk!)2C[!4-nZ^be4X0TYr/>iK#h\+i1<C]A#",*\RO;nI,\]AB>?\\ScR/ppkq%#a"q+)Gm1
@XR0A+^&&8d?VZ;T&5D1/.^Ml^@qpH5,FheI6GL-LJFFlNIjs3knm>5E\cK-fIE,QXS6Ls>*
&J>'[!WR9N7;)Z4KGL4M+93ko$6Ve\!?qXb^dXbE!$$[6^Z?HRdLn6e0RmT\LN%TQ<$JcX)f
:^p[q6^-Om5/Z%c79e!!!!j78?7R6=>B~
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
<Expand/>
</C>
<C c="2" r="3" cs="3" s="5">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=toimage("http://" + replace(C8, "文件", encode("文件")), false, "210", "150")]]></Attributes>
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
<![CDATA[=toimage("http://" + replace(if(len(G8)=0,C8,G8), "文件", encode("文件")), false, "210", "150")]]></Attributes>
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
<![CDATA[!I"R#reXHH7h#eD$31&+%7s)Y;?-[s+92BA2[BTf!!$l88CmhA!Bs(C5u`*!`RusU!C7F>n^
UO9gqcEN\:?Y;+F=";l8aAaoFef.p*GpIcL/oGn%C0a%D1X"Mbp'dc8FEiZp!eN]A@*"]A278/
."76o+[6V[iAdEn=7H,X"Is=Zf<"]A+K8H>\4RdNc%=pVi>%2%HrK'8g\7gtqF7DpgG+iZ.'+
Jp3QN_"Fl/n0A9j<F$!3?"QFaF2OQ&X&1b'HmKB&Q/T;;$)7j8ccm:"J?$O!f.FZJ-^]A1j<D
kf!5CDYRfN4s`)j<9i[\uJ)2Gs3ZJuGi.1jHq!-&tZ.#O>mMW5u_86cLP`?bLt4;S!Yk5\K@
W;s>N$:$I4"]A5(WQ3&as`rK`A+b4:>%ks'"J1>OC</WQj<\)IGP[DU6iXFJjMDJZ,*u!0a"(
DQ/GR.]AqLA%D`/`M5/!V5M?"7Oe.z8OZBBY!QNJ~
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
<C c="2" r="5" cs="7" s="9">
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="9" r="5" s="8">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="6" s="10">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="6" s="11">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="6" s="11">
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="6" s="11">
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="6" s="11">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="6" s="11">
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="6" s="11">
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="6" s="11">
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="6" s="12">
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
<![CDATA[m<a+X;chR07'&il1alh,7'Qb?#"t@p#djr(#`(9Hn9$ub"p&:1JeLt8e,dE36)e<^"pJQb;(
=pN,,B_p,fB[k9Rm,2PP57amB[RUcg'fEkPNi^r"HU7SDPC5hS6bm\L0*:m;:FUqJqj[N6I_
4p0/Q#O]Aa"]A,9o:SndFBuc<"(uYJ&,.YkmcYE;E\_mej7M6RWUWCX=J,!)k[2HLo%ODpJ"S]A
"T:"r9bs2h;ko2AoXmG%\<PR\mE56JW0<+)cf:A^NKaFG.86LK8/-%3FbkUnqnH6fRd[lB-/
kpWI#mC!R2d!3TUalM?lsC:_eHsC;`*O+o@%pCkW6IjP\Q#U1q.$]A;suBUgn@=L2MSdFN[C+
13kYX0B"(,@Nce4_K#/']A9r>9h3HXirSmpLUe4*m<g-67:!4H&DOYq,/L\d?.Q"9'+g!!uqL
&I*nJiW?g1Z\)?!H\-#C1Z8?BjCpSC&XC`Qb2nd[<n*<+)-gVt@&fg^l1)iWgL]A&'Tj[g/7V
L'[n&$k&%AI212m8jnD+i!B&L@iO`IQ.)5H]A<1F]A]A3)Om%Q1=b@lRJk5\Vn#O>-5Z:0jrdL1
$'-)jdb-qC+()g.4>$k&T?cKiNJ54(q>5.8)k\c.>L1^fnXk:A43PKZ_Q*2X?G`m*--FsVoc
ES)G0D^53J2i/-`ta%DbY&XAd5fcIY-%:sS3:GCK=Ape.<m&<*\EI1'Za\U)[<LLUcGnN3Cl
?r^Z.!bWJ1!L"%QI]AcU7\+[cOc)RV:<2uooXkLV7]A`uG4n9go7c+WkbbI]ArlU?Bkj[9gh%T8
<<F+Yr;Y0.[boReq%ar32/=mm<3?_C+RmLi[c/r2eY%a[uninKHXPpCs-]A>j.]A0D/[.lIF3O
uF6>X^o<1^ZD(XN7A\C"qr!'mmd1GQt<UsV7F8.HuWQdLhFsn#YC0(e+:Ff:#nteu\OuE0HX
hbJ9odLg[gB?@KE"'R#H-\"R@E5b1WS4acS*L?k/IC!'_Lrq+OQs(NR*.QuhZSMbTJSH3`;@
WN#1Rr%_9Qk;.de0<XO/K+d3\s#U92\rZk5*VcPagA/^"V!/cfu(51:!D4DVrEp;?=WkoUao
162&'Z4O52qAm?l-'XGS"dgkGieMIo%sSLC-osW+IE)fp(`G<W`V+Tf?cV3jN,p\6Z:J@m/S
V\uB]A.)__`cqF4M(b/Emem(C6,Z>S#j=>Dp!rJJ&QW&1G6kA/8?J>\+7ks\$UIuE0QAT,?qa
MX-[S#ZLC+j;;X#\GcmP'Q'oP%O#Mp6'R!-BNcXF%?Ro&Kn]Am\X00a\:42M%Y5qC+7JAd6*K
C&M-V%.u-bqfT3ag`)j5=hi(4l#pYV#q)kbi%RopcI)!5NfLe=*?==m<i7%1:,;[WmI$Aoe\
6i&uqaqVA4e\<u32nkB)V_Y:3V7o&nRg)f1#cTE$o*kO+)5]AojkQei`A`]AWc>PcDd,bCNq_$
J*?YVM^R,Pg2*14XF9$4!cB4KS*I*b5I+`V/#W#S[)_W74!a/C<fd@n]Au'=]A/'OmNi5msF?9
l5.XNssG@.H0'g[QfQYA+0nHdS@(C.r_kF@C;\?u4"M"nhuV3:q#?<BN`N7u^l.<_/6S=]AtE
g1LZgZXI=.Wh#K^_!4La1]AhS4k\.T>kIMAIXH38-.`:bfq%l_Mh#ZsO7:sA,=^n1YKFmirJB
#t('8$BB+5JDkJY"lp^i)n?<%1Nc9GfW1dJuDt\)P@#8`;jEBT:CUV"9Aj3Xich(?0WKqPXB
sO'`P&NkNFBL945W_HFB,iNSA&RD`E>\rOt2N'i2b7:QF<W&((ISIC(E47.^N)@7*nU9a$YP
;@r+4#n&&i__OU4c!2S'qb4?(,X-?SE$;Eg">([uG,R0/9#O1-WWW.H!@Ru6ataY(E<qFq;b
7icQlrDDiM`0TZ@`^%lOKUrOKjYr&J[K4*C\n/nFCl#P*%.]AHoO&"^Og0Bg1"+#>ro:`H6da
;M07Zufmkm[>B@(o1;1lTI>9@>_Mb^p]A2l3*BH[OhS-G`@KOGsJ%4ZJ-Oq"e]ABHi2?G=q(%`
h^HTr0Bhb#]AMI[8WiPt_c+^eZ=baQlNg8Z&U(7BKj",C8fu0O)[Yd!4hR*N+_u0g9VX2%gb_
:)l(LH.O6+T5IYW+dEm/;uVeF)X,W.@ce+"%h^9]A4[Q0+"T2Po=Xj/.#'%2n#F@\$??XV.O:
&I5@S_<[#qEa;V^i?+YFRi-YD4CltY1;@erILdR]A;\0oabn7DDi#u><qR5)KWZjGZMfQRo_I
W6M4g@&VQ>brNgnWk*j`tDph/akGrn;bs>.0L\ER5qVUUh+:^oDh(*50E-kA/7QXBFilSR)5
)"AN@?V+,<MOdp2i7X.+-4P5ZicOu<OhN)DkBIl(G_eV5tTiTu_0M5Y-FmA&e]AHFj4,D@j?2
:kjme.hF4PsSM01+dsn+.TF%5kaiTlLUXuh!$5c?!.C$=]ANNtcrp$!G^".9D80WaJf*%G&Qr
o^`+rt;`qr`"mp\c"(h1*DR)eeAP)a!sR9ZMkdHYN6C_5d>X&Q`r!<S?mk6fB$,XL"mrQ#bO
r3ud9R@?8$T5bRS9Y2QtHWM2M*Ai@9?K+gRPtL*dL.LO=/eK>#%m('&;RW"<QQ14G9Y"iEXX
Cs^%5/&<oRa"+,^5]Ao!_Zb@&.,IS`X?Wih7:4go3rqBV4plU['!CqD5p">m>9.C%H\H.3&:l
I.`ETfhqDQ5$c(-\%YiT+^rF+G80#WVhBG6qT\]Acp4L\i4N'gFnareaEeae@)?D"5B(nr8Kc
$Xd=OcMUZWFM!N6uYX.isuunEQcQ4I<G,4p*It`VufuMS@kjD["^[=Lq+<AbSTm4D(SEKVsA
5?YTR7sr_(4'!;$"h+^:If*c"(R?e_sI`.Ehd/N_N4-7_krQJAL>JQp4dVDhp/kZ5j'rI&8K
$,/VH7Qlk?6g/WW"bfQ,`E\AtcZ01C@sd"G0>`1HXn2IB='RZo[?ct&XRDNalRf;j&l4Vd2o
YdFLLuHp$_OjTC6$mJ)U.R_X'QEOC#Ao62(<Ii8tW4#+-lfu\rsnrGc>q<qm0A>5AIfbB%8/
\<0PIsU\m,p/\a5f%$6L??(+nn+8&o59Yf]AJQ'E>Um4m"hH!&0*hWj:K*&4/PpuqOGDZjifD
Xls5Ie[)MVi%AR=Rilol\><=>aAQQ(-/%?hs&l.rR2i%;1K$i)\Do/>ar8mH>3""#fY1[`n%
96P'^A,fb1]A37liUJ;P4R:V)DPUr#U@kpSD;99AD?"Q+ti#?bVP'2&ZYOllW]A2G,-7ZDRRks
WO8K$C5]A(GrSSd5IfTKLr6GB>&>9_SD%ombmnb;!g[`llJhF'M"Pj!4#Q1aKX]A).2^ae`YPN
M/tr?ih;f$2Sn-@W@#,7]ARiNAGq(CP;j[K[ShZH%C*0&A=tEqK235]AZVqS7hS`phC7LU,=ZC
b4%5h#Wg(5^4!8IpYg7?M6@*L@KD_1q,H`V+(r/7/p_HVk]A[4`iUGTaILfMBcBW8`b(ct3EJ
6J:YbKH2R5]AM"^j0E0$b"a<sR@E0aD9$^b?1WMc4Uen^IAOZZgNMDh3QaSV.M_$rA4<t254e
`nL+FmJ<;a"!G\l'+'Xsaub`,[^$h3_J;br&b42OG1l=sT4Tt"rq7[kIcd,Y]A/!rW^ZpXs#N
&7H,Hr-HdtL_DNA]AHJOm1u=lrOA'U!-uSh080rF1U.WM)O\esi.YV/BB&]A;Y.d_-%[k8ASWG
N%2!$s,n7aW-W1s3p17MPhE/GNQH-C_#))Sm%#<n@O]AkZ*3*VC'=bC=+aP,bFe+p9eihNPf-
mKO,F$D=Pp>V[Sg>8/uK'!!43)dknjVn3otgn.>\5^)#^)M^k$D?Q=BhYb@HV("u;SZH,U55
Z\Bu;o?lN8l)EA):LQrR\X4dhK85!e+Q#Of\^"9`d*6kOH9-]AJ0^f_,:OE>Zqu*QX'8`m^60
=P.ZIicTIKRtT11)pbp\;ncs7e/Gi<^I8_sS2+6(>H'0W<#.>ncGS&e-*gie.W9BZ\rq#e4s
"QS]AV"LSi.4W%FFL=Rj>T&^Y7@3XH90cqndd9Q:@?ZIL%QBKa%H:hY<%$2L2<Jf?+WkXMUXA
WlnW#4Z,Z-Kp,&_agmEcL<CC)3S%3i*U.&CfC!!0j?!lue4?X2#@SIS3d]A2VcjpKeNpR$-jW
")hFhGMHCHDKekAKl<t`$,YmYn@ul6YbTjHD55+WK.l@tKnm3Qb/M@%dOBm@bCVVI#lfL_s6
\c@LR(-4HnPl1"TaEq(;+pS^[gqJb*J`pq2SfLH`Wn52f\QY!46ndM5$Y7iTcHte5u9MNQUH
)<5g\s'&-a#($fW$,S;JEuUfU:[H8;shesg<&=6_,Q$atsB*'?!!\*-!B-#F0J/W/$M$3B4Q
7YK*ElgX/NR4jrsUf'b=FgQ3)!QB<@ZuWgGiH$Zi&fg0R6H;#QkS0Y,h`uV1IQ5_[MO\.6/r
F:LE9^hHhCl.1"JgP!6[ECUh!-(r\W;`2Ap;&VOuN?*=Om,Z)c,^;7AM@;e1et;gOs)R_gQ>
aeS/nk6.YktP1<^;%?]Ap,XjHsH]A,Pin<[AVklgR@QA<pt$F,_Y&#*n*qU#W%Ln\-da)L*`&l
<n8!5uF;s>P_'HO=_\^&mXKN?CoccM@s<Fd+ro8.giF!"U?PD5N-cMnu'T:/\W2"&:9F&h*h
[Keccmg&?6sBUkqsUYcqkm&_>J#Jm^<:-]A[!$6n6N<$o'f8+Qhi9]Am0ZE[<j^%_b!i;^\+^m
YfBqUer`b1BrGCqY(jY7BXN+Rg(j/6\8lp/k1nF9N8n@;W%'G%.g6,6m\19T)`O<&cD@?H@P
`Rqd2a/LWRqEe)&[akPM-TD1'oam)L+HRr)FqWo9U]AdN&JgY4R5-\9ba26?$8uB6ql["I3.h
k7mH^P`"b3Wj-"CNM-l%_W]AZMXmr[U@Qh#B?Zn:f+'cUY=_H+1]A9Q;^XM2:*7e939Fgd[JcI
[/6++0.H&C8!I*gAtl22N`U"rCDETKK;,Bl;C'YQSVQfJ=)X3F)dt/db7(tN.CYr[)Tk-]AeM
h9I:H8k\:F!!&$735@M:f>^&(K&=YE<d_TAZY5q1a,7.Ld^^dR\B;+JtLmHYum_@&KhZTe.h
QHX)FqJb2)YMq)d7Q&QP3b7%((-DtsCra!JYB]A_2ct_qi)V6a=18(s2KjmoE5NK--hWRZN@<
8Y2D8_qGrOme[3q8$uol<$7@a)ZslSgpV4!<E'`Cuq;%d3&sEPc5C6?Of]AR$M$_#hS^91e_:
"%U2JIU$kct]Al6.V=f:97C\9Y*4[W_$6#+pZ7c<6'Nr7E;bm:LB,.fq(m!0Q>3HmqCD'BQeL
#pdXeR-.lUtZi(4DPHhJ\H*[5"FL]A8<EFdR:S:rN_&X,MPHG@)cQ"i7t?jdJok&)1e&to:gs
8@6a$='[BdWkhCLKECLdRG`b:n`e-<rB;mm2YK2X:in!G>UQL]A*%SXbJ>6nJ*%(qm^lR2=]AB
`0PZ8Utbi+j`k`MI/jYLkJs%OO9<J+bSMD8?D-@iAU=Kt/,_ur-L'Pb*%^^+gs+MuoYd%dXS
d&jNdDBna5i'bFn:r*ZHG5^4rSMWjK'T4%-OWrau&(D4d7@a&V(Ro.dV5J)B;<]A]A9L=u$q'X
s]A$2P0P8hT73pN>V!p$F5ZOGfmh0D&6E)ub.PE6OlqfZID2Dp)9,o'MAdN9+ig+kDSR_h$5&
!/(uUo4,,<rpL4Ug7aY:k!H_i^"2T?i5A;Wm.TM+`SBN4%W1@+EVdS9YDEMi^"GI9Ys)`0-9
6:Km;I.&YSt8)o^hQ9ErqaP?GChB6X-o=1hcG7SVNT;G0uH[d^33I0V<f2Z)N2(9a/Gq'k9J
`$o*u=8&^.dg^D__aK:KCmYcEj/I.MAB)+]A`<]A1r3cFHX*]A6AR.>uZ^n2h$SJffr?j__'l>e
ZX?-D%ABk9f[Q5bQIkJsY_uUqdWE'Zt@\LYXt2X,h(YSaBpOE>\D"j;b7FgN&A"rYrLol+/0
'5HQTs:QpoCiY.e'[I?]A7j#QNF;=UaUm-Q^Mq.KJn$Ab]A3IUFq#h:MI$LI4GB_3sgUR"l6CF
!mQuJ.#sK%[8S;p"<1@8LK0[';til<18=R.k`ne(?lTL7XE?4BoO30b9eJ_H!BLDbnQc#:Q(
ke.idC[>HbGn.b1a7cuArRL@4#.mVkq8JtpO+!7soo">F!HX,=HW$VZoi+Ul\.a3^5,>B)Ug
Yk1u/mNiK6:McHj&/mSmH7`8UD059-F#KU/2RMi-",E.A_.FXe`:#APlp2J"e(9DfWFM8IEp
C"`1;.08YgOYub)+#V2^<(-kG%&DW('dMQ&$T>\d31PGV2u?UAF_a]A@=B+pKYqC'V164kqVl
`,@T?-64MS.a1-o/a*FBdXg4R-I!ud<[btt&YV)p:P#'D"=P\g.@B(2XU3-fA"<%$VGc%D)!
?Ee$;a)8:Zdfh-ls#)X3edV)-CCCgr>HuX5r&]Ar%0mH!IcUFT.GpJ,Ug0cECLd_61[J=lb:U
!\bRoS8:oJ`)gQ`6(,XFkT]A.uC=0Zih1RJ_Id=@He53FYI_g>\@jCmmHqeauDY\r1h>0V/QS
U)GL&O%N=iH(bFa$IDH0l$Dni>)#n3KDSh<I;N&&`t^RfeE8fo`BgEmq"5VJEYpd)Gq-Jm[`
uE8H:a_sF#E!#%`>7?&?%VV+WG#)TUPfr5\cIT)%HRF_O3cj>&!(;d[n&r@ZWXj)&M=jeN8q
OgjpNB6kVV-OjkC\&2)te9^%sR3Vjn#qWgR`oY?7uQ1H'SJCl#LNUh>'0j(cK40HO$5lKtQP
8B&>-C7]A>n(c)%20@;aY;Y9d;pbV7SZ^:oh"ZKKIJI21/+srpo$h[&m+_]Adqn>WP*-k"?LlL
&\PE"*ol#H17j\B<`4E8R<Z!L1cU41TtiU!<'@usauE>qr9B[V(m/c1im5BB4]Af0$16D^=YZ
+_Ok<:u0iXX6t`$0F#^W?D.$ipgbMPDe4H!N,@13]AQ(JW@AdKAdeFLPZ@lV,Fu4O1!&:KfKS
sT)mqk2Y2<+.jlbr,G>`r>OIn3,TO,1q4W$%TOC*UWSq5K``eY3BG>u\.dDo4)qe-VN_:#4?
u!$68?&l'='8%q^pMGsj,ZV+Y@bu=m=mV1kQ=?Mu*%obMsQ7#4%SAd5mUJTgm-HhPER(6`Vi
tW8E>p&<?Ti<^''A\DT*sZp$T0:/aU%)CS/OF8m/I#Yh__RaodWg0l!H$,Bn>$8]AqlO54Z7Q
/;2/2COY(HY)YGh7NKi_=l2`0f<U,RqnA$<P(mI)kCI4f@\hk?ri9AY"^B2Eb>Ncc7Od'9^]A
Mpc:Yhc&&F2XofF!^#U2kid3#DN3H\7u8.&7PKI%HS5'g2U>Vud@#E5fPWW+9S]A)->A>>()9
94L*"7Uul==>NP*#2>7WZ5/%X?;)IG(C=4m)$fO"Jb"ADcORTZkfe/j(VliB4a*PK0\$6IZ,
dOrV4=j./m/8.XV).l[sJV`f1:S^BTJ!UDM2[^F_c_X&6UOtl_o,:sLK[39BWiFt)$1ZWK:[
[(Q:<FuX:UE#*H>Q8gqj^j"RV9rmLW=l#M-Jq0ODK$U*#I6/\0i26>C<^akOD9ED%u&<FR[-
u8g!AckJ_"4P=,D;/XE*a^b(]A#a-P4%?OPYB@o>l<QYu'.tfFlG[E]A.,Lgi/Y%UtJ7)CaF\c
rLt0lLK;-S%5aj9jn$P*!:n$m:G6'EWRg/,ect:CS,ss\<,lI\p/T#*-ZX2r@OH-#5VEp,4u
7'ns(Y6ZUa7Mi`>&^"\/?\@UJ;rpD')L)-4;t\Iq<,(BK1=8hF0p8Rf71!]A67M9=$>#rDjX(
i'T9\:>>-6FChrrCq-@W(OL<r^/;TqN11(DMC@F*1WnR^MKUJ.NqAnS_Ra!mP/-VqIlglSM[
4(#ji\BaM&n7\nqSDqF4iW)nHU?W/^Y9iR-6Mg0p7o+!_((dR)L@aJ:Xb"l5.pG;`O8STIji
&6dR20Vf9Cr4FVgCj)#I(KPRo!"&B'@CejAVr;RU=-WPePS2Q[RF[$IC#=5<RuTWU'foiY8O
%%db5JAId8Ma)IW7+>Z*/:*8CHWYS<^<#sgYgS>gJHS*e^,D#urn^[ho-"laK(n4+VG1D)23
bX+.Pd-g*]AV'@P8qgP^Z0HG?DR,/mUBS3Q\J$Vob^t6T<NITgS/tgn00S'@HmFknYX.:h?I7
P30t,?"Q*XU?@EKb<4+H2.V[)Bi^!72,-$-=gSql>,N_UEbqF0?-Q'i<Q_5Oirc`(:rIa"'Q
*PWscRcmZ?Rm)NkgPW[-SJEBd-JT_Is>T5JCNT'3>MM40&+\e2esXo"Vut?JY10>goJ.BEuL
c3*pc95n]AdDn:"bkMAXom<d4?_JgRXs^4;5RYFDYT;hngD)/90Mqqn9T/8-o*\flgLr5RulB
KnX*ks&]AMjMcBJ;_i\nEoii>aYlV9nbaeH:Y911r;H('KmJ1pHG`Ej1=*WpRg=[&2FQ#]APF`
$==I`iLA\_:GIO5k%(p+acL52HG]AP.ub<+@OOtDACUO#Y)$L\\PICTdTMVR/Eg7]A0UWuKn"X
:J2WX2!a'@CEhpWUR#PuY@+WU!Gj7QOS!)"6k9aOH.&*bSN%=R[+&.7/V`73Jk(uRDJG.j%5
*nX*\7:h$(2K@D]AL!;LB^(4^M`Bb/A6,,NJtpl4)<IUBNP&k]A6h$2?[k&+L+"HF./hRcoamm
#*T'NLo_f?ZY1XnsD@R`gT1aQ+.TO,9JG@@WQ,r=$eB>uQpA^hsiOs#5*5KWoh7h%]AYj#3GU
*-AZ?Ad2;Q2MZ`u?7+C'qH[r/f-i9^+^b(D:@7#\m*1]A?l2ej#'a)k"4E]A"a4iMX$%Y%N'(`
Pnqq#1*soem@N*<bp)'>]Aq=+Mfjg^9!'=q<YQ7bdN5umTl*R*/P@=+4"A=r*aC(o.d[FlQ`C
gRGo25H*K(FbFI.'Rs\(eI.>'c'+gVtm6+\:lc<@*I,frPY>q4Km`nDcqdb\qs0E7k-*l'Am
'bqFF(#SZe2*'!e1@h2/l^NnBm"Qsg!^.BjTWRu>Al,"ir%9U5C8[q!<*)q?Nt>KG(.*nenf
6QHU_@9R(ePe1Rk6D;fB7!'Z85qKT9=i3U(T&WM/;A9sN`i>M_)Dh]A@>:T`-M>QEi`)3!UK'
:;>M]AFEn'm7XAgE]A9Q?0K[A*%h'0t[7=-Y_qum8g>sN=H/O!S]AiqP/c\m#n2J?N,PXQA9?re
oYP;DaEX^'^G,[WSdAdbD1-Nl/E2'UcdEbK+cq\W!LKfBCOJ6Y'^3n#77PcQhj1g#FU.-@fX
`/i19;ro7nTQQJ[M]A]A8"<a]ALSt'q@KND[]A</k,ml\UL&:uA7R13eW9&\]Aekti:kh_[+8Nj/1
7:G%-fbs(Vo5["b&?27)264dAk0Noq#<1(1(HYmRK<g.oFDV]A3eC@ZKo$Yo+7PKK@)RLe!R5
Aib`of8fDUaL/=;15R5b/'lD4kP"A5Eg@H_\iKqIHrY:4=MY/\p0T46jP5no<Q58mB4Fi3/6
dW9#-50HQ"o^hF3Z"-QD..:8oc2U!O)M_d[=m@f&RjH4H`7<\]A<RRWFbRIufT&5\34r<Ta)Z
#Ba#Zn@@aR<I.go7N7"+U-Yr[#ZpG6o@Pk!R\&q9i#VdO\%8_-u7G`U);b(LsA4OrQ`^"^6M
'W7r\jI*gdWRYeUsL.b&`?^j-FUG-O/COWjH<loVf"L8"&9q5&aa!0d#l^59*DLqV=IC?RPm
?0A);59^?2A?YFSJk"jQ7niXn&F$[iiDC[&L*^!?BK7G>CRYp.MNlDQ.ojP:7`P?9,.7d?S+
8Zn<ouY7'lMk=]A(?a/dMDVR3g.n!TpgiWtZ5DSlY9IpV]A=_FI1/cA=lR[eXe5!.m%LT:ScKC
]A?2a!=3"VZeS#&pZ1+7m]ASDuk*Fqh8s(fsB\PB'F!%b>kkj_9oT-+;pM]A<C(5"^uR'T!u+BI
-C=7D[doMS=UdR/CfV&=6K%PDG'`T'D8/IBh3&48Va'>Zd*WH&hh$-RW2Da_$ai\sn(@)+uu
98-e7?KcVEY^5M5_9Zf*";Pr6JNT-pTOEBcE^ldLReko<+9%19*2,oq.P`/%A2YO`hXd:a(c
`K!"#p1^]AA,o\6/`N4Qp.JJ5C.i('=8gGj'Mh_9<qq^[k7UAl4HiFIB-SQ_(Aklplk`N+Z_q
,,<E.\*$5BEj&OIB8Q^efI'cN;sF;%srTs-L:,bIqEpf]A:fo%tA0$chdLUSH@Gg="8>#XH12
)?4<9rUid$6kG-NKSZ+'c)'#8"mLqq+"3&dG7>blm.F"2]AT"2G9ieK#LmAPJB>W"]Aer-`Q^b
DSBBBc9e_pDjd-[OVGE/FH.;0G@[&r[spP[HPbb.GCRqMrO'Sq`etXSR]ASrZ,Gk&Pe[OV'D:
.PFp%/V=EQ#E!Jm0&p_mW8AQ.9o+u=`!\T-(9\td]A-:<)-oM9#Z0q=3jC'o-ho(!o:7;<Vtb
`933>Z]A&e?`SZ)k22i!p#mK0JioC@WE(rd5s<e\harh-56M>JgQq%doI%4`2c't[(rure./e
CBC?c<^/pr7b\N'?ue'`rUAcED02YfL3FU?Or*'O51eOh0,oVJ";VL2Gkm:E&NPXqE<R,?Tm
cZ.YO8iOJ8q!GVY+UUeH]AgS\'>QHL\-PR$K+"T\qdN?.SZ'q6B-?#6N'ut9\(J@WR')%l-H\
(To\sA5=c4Q/`r?WNJR(90.J!u_=Z?a8YT#u1'/J`LpmO)9Seh5L"\:Im"!lGe%<)(:Ji8h=
"d@4+7m0Au*od?i"V0o\Qm-?^9`Mr0>O,M(:EcDWfXj)-;<Nq"!P-fOUT6*HbkBig;kPstR%
s=&2H^^]ATo'*"I'iT"LSX<'eXWh3ipZQG/LjM$35uK]AKibdr7_`u$]AJ!/CWYnXo(VB#p;3%P
gnSbB!nJ,'l-TBmZq+3)Hubk:9[8q3shlcP!I:D,kk?..WFePgbqA=q+3Ia`_A)7FY1dVURM
`Fgh99i"WTQJctF[?tqCOc-f+T(5rE]APt)&EkkN<Y2m&?MrB77rom;ZXWGGdEgubX@&Y&nL\
ZL0aN'.^QIpCA40:/O911?I@:H_U2l5i2/gj!jq#%ABhC<HIa4:1n~
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
<BoundsAttr x="25" y="100" width="400" height="175"/>
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
<![CDATA[288000,1152000,864000,144000,723900,0,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[720000,762000,2160000,2160000,720000,2743200,1440000,720000,1440000,2743200,2743200,1440000,720000,1440000,2743200,720000,2743200]]></ColumnWidth>
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
<Attributes dsName="left1" columnName="PROJAME"/>
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
<![CDATA[亿]]></text>
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
<RichChar styleIndex="5">
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
<RichChar styleIndex="5">
<text>
<![CDATA[${=if(LEN(E6)!=0,E6,'')}]]></text>
</RichChar>
</RichText>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<Expand/>
</C>
<C c="1" r="4" s="6">
<O t="Image">
<IM>
<![CDATA[!Fl/#reXHH7h#eD$31&+%7s)Y;?-[s)?9a;)@-NI!!&uj9[3V<!@gZ/5u`*!A,-*(56F&&>q
@/@U4Wj_qEV\$LjoEpG9G`H`4ApS#\[=%&5NGgO$MJ$`)8iO"2pa,YmE[#8!ZS/NI3uB!6$Y
0$F$HZJ]A^,B;U7k[,+p,k+?g7Q^OZ(]A'`SDI"["tL!9/K!l@/p+8T[,ZRZ7Af0+bH5M1$M`U
'F5:Fs*@b`;B(-"EHXYRMa*i0-E0gJ\@-sK'EpNikK^i_W'QJ+G0sX,?XU:-cmQQnHcT0aEI
mK"%;-$8h:%?*X<mog5lS$AnZoE#4k]A$;(,>i63o4dr'<j!3)TfX%n'k[8h;^uiWVa0S3\$7
TF+AC$C6JLnS`djm=Y[rj?Z2a9Ic>4ih\oQ)4s>15eQ2$UalC?-3i_j%.Y-.MeIqJ]An(ET7P
eK7z8OZBBY!QNJ~
]]></IM>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="4" s="7">
<O>
<![CDATA[当前进展]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="5">
<O t="DSColumn">
<Attributes dsName="left1" columnName="INVEST_AMOUNT"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="3" r="5">
<O t="DSColumn">
<Attributes dsName="left1" columnName="SCALE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="4" r="5">
<O t="DSColumn">
<Attributes dsName="left1" columnName="IMAGE"/>
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
<FRFont name="微软雅黑" style="0" size="88" foreground="-10066330"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="1" size="128" foreground="-3727584"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="1" size="88" foreground="-10066330"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="1" size="88"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="4">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
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
<![CDATA[288000,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[720000,762000,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="1">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1" s="0">
<O t="Image">
<IM>
<![CDATA[!Jpo%r/"6F7h#eD$31&+%7s)Y;?-[s)?9a;)@-NI!!&uj9[3V<"&MQW5u`*!]Ap<"r;c+OTDl
!$G*g4a?U54W@rb,8-Da@7J6Z:A9Bi%2N'gYqi3R]AaK1s;]Am<uIfF&!?SFT?*NtUD8rH7]A(&
u2s5Aam;BQ1CchTEf=<cD2<3-&O1TJYh=l!9n)(YaV3LdG3s2>^3u6$:o*5C"3<;G\gZ'2d2
#B=V^2;kde+j[.<b_q5!2EiCj/=F$7K?j[CQmt\/t4=h;r9D6"VdfK;LCth(DIG"DL[`8o82
H@_M"Lu(<65/!>1+IeR1j-jn0WBH<>muI!MS/?,0M<e-4m]AR\%Su<2@<dRUIh4n@\/KL,Dro
2B_pJ(8)oa[GpW/iGYU+>lS>_SVW@\]A@&*tG#4)6Kck%?GaGPDaut,4MqT+V$A<!8n4rP%6*
"XXPC8$j=!9Nor/f(=0Xi+iXC%8$iL(a>7Ml8;Puo-43sf@>_mi$e8<V?+DA<UIL0uY(:V33
pT`d6i+E0cEXeo:M04a;0[&m:LcVU\T-r+MZYp^q)BJ`jB/)2;-\7lDkiHRKfg*?:bZX(`k.
\"[bj[6>q`-3O^<"4-jU5NWdhVJMIn&U<bi>rio@!stcY$mSk4F64BA)C25R#q6&ncp3=U#?
Kdh*a%d@Q_UCrN7k]AG2I)LSaV4$'a/*-'c%G*h%JE0G*f5CG.GaH-,kaf,"R=-]A'&)1$o^87
#1afR0-P#8f4#?=[sY*F`F/6Yg:<4I$oOo"U%j<+-h-!7B]A^<S;`062c3Om4C)(0*j)ha!Hk
kDi_P)lKQ\)8]AVGchf)i%^Er*H@]AD?6+X>-/?rHc!3JF2mSrdi(<VW>_.\&a>:h`?>#j?4U$
2pRn]A+6`Vqp@"aVT0T6Cj)/:QpkDu$U`S)3lK'``R#]AV8JkG_Rp9<9]An![dU5Z1r\0_KfmC<
pRWB)XX?l!JOpK7@9(%[Z8?d4C3?$1r3Bs'+ff0%Bg%j@5ibJj3V[;T2ISHf`pJhRXeet%>1
&rrkl\[=bT;$D?Di_@I>*LW/,F,NCJTidf]Af^"R?@Y:ATtjU=c=S'"k!RC)/&Ei,d*1nOSis
l:#O!>[&]A`*I7_:P-bCH/Hb>hf[3gXrrrCP%4)rojCA5j!!#SZ:.26O@"J~
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
<Style horizontal_alignment="2" imageLayout="1">
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
<TemplateID TemplateID="aa1fca03-8a1d-475b-9d76-85eebc2c7b3e"/>
<TemplateIdAttMark class="com.fr.base.iofileattr.TemplateIdAttrMark">
<TemplateIdAttMark TemplateId="44e92ea0-a1fc-4f42-bb5d-5ec5623c0e0a"/>
</TemplateIdAttMark>
</Form>
