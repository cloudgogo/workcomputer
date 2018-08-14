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
<![CDATA[2743200,0,4152900,360000,360000,9220200,3695700,2743200,0,2743200]]></ColumnWidth>
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
<C c="7" r="1" s="2">
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
<C c="9" r="1" s="4">
<O>
<![CDATA[逾期天数：]]></O>
<PrivilegeControl/>
<Present class="com.fr.base.present.FormulaPresent">
<Content>
<![CDATA[=if(len(K2)=0,'',$$$)]]></Content>
</Present>
<Expand/>
</C>
<C c="10" r="1" s="5">
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
<C c="3" r="2" s="6">
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
<C c="5" r="2" s="7">
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
<Border>
<Top color="-16777216"/>
<Bottom color="-16777216"/>
<Left color="-16777216"/>
<Right color="-16777216"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="SimSun" style="0" size="72" foreground="-6973274"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="64" foreground="-9934744"/>
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
<![CDATA[="周进展:\n"+$$$]]></Result>
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
<![CDATA[="周进展:\n"+$$$]]></Result>
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
<IM>
<![CDATA[m9=p:PLm)f.Ft4n/%.i78C`@fJuFKU!jPe%!eP)#23;KKY`/\k#U/8;XnB&od=T#*ZkQ>^9-
Jh:hucgX7#<21,68qj#S<.16D!(/5[2uY4R7*7HLA@;rZV+2Ho$+]AchqBen!tPDHFqLlZ#GG
[OjU8t?YnP0AFpqaa9^;i_>CekX6tA9qZh?#^@efcUGIWd)__-L=esSUFO$c_fE<tp>M5a)A
%ea0^!4%%CTULO?+.Dt\34Wj5HK#V[j5ki@EH7%&+4'r<o%e>*a\4F(#FCKosbuP^1Tas^td
kSRf'B<7SY*H-`+r8'L3!F-bHuI26[R]AQX"!/+1ed)QUnAIqg/O)kAT?Ql$/J9aVpeA0Kc"[
%rLeYg=NsKg;TP92<=:R*kJt0CppS%CuT\(@UE_`YLHHjWAM&-.:ka@]A('2>U1r7E#E#r=*X
Z.uQ_G3UlB48:PD=ua<a?gG=^7ig`>'MVR`3tS(@meij;1C5r2!4Y_l[cVTC)n2&jQ+OV\^m
f%,K6KGEnsF3Ua45gUL`8=K<tUPdgCfKJlk:!s;of4EG^3kX<P"r:iV4SKUEh>%=.u+jmc*^
b3QST9ieG:=UBkWY_a086qRjK$r/o6j0VPd)5&%)NPqL2pk-e2=(GjDcN_:Whi]As4_O`,c`W
hGjg9s7LO!d$@,QnP8L,Mb_3UlLV*$hrac5C73J3&6QLiMgf8ML(p)/-''$WQuo,4IZAYE.+
n\ZZ4+"I2@f'c(onEkC;5YEU%6LnUE1W^@N$6qa5*h<ua`8KfO;G3!2,bI"K=:PuB@f3(G]AJ
[Rn<%6jLORqId7-9VKG's2CXsI)TK0*>;Z(6&n>nGO4r,@A5Pnf#M-(%4$q=O-T9u.?6_\en
NVX,o?h6@&R)u_6J<>HT0/Aruf<835eLVYJrWS3^^7W=b[G9pgOB8m?Mg%8b6/oZtS`Kk,RV
H<>0epD5aZj!?\OAn%Vc)(Y%"D;59WY0n)[Afle(gjdnm*^pX=7]A<6nI``N?V0c;O:5EN"Qo
"5\%7Hu.@HNZ97q(0:6JSGA86NHgU(W6SR-'dY\Q]APdDWAGmfO98R!4s(MmR9oS/J+Ii65i2
0te@`j7Z*2mml>l6T'u88^)QJ8qCI!E>5QWRB-S_3RJ2Y5*a/!e?WFe<e.(%J1a>d:E-f)b'
qm?R)Ms^:soH:R;;Q-8P3M;nV;V;[?cHjV9DCVP%(to]AA?.(`V/"?(1&>6R?[.AO(ZfSl1D@
ojp/o0IGhNi#>=Gp=_#1p#LUQ('/LAY-''TU8U5LU%i]AkBU;(eo%J6UPqJn,36MSng_2#]A@>
*lcsZ=#V9=nA?Y#lUO4?P)Y.WNipE.i^-F/hp9uf3Fc(mb"7\[*H7(UZ>9j6KH$Fnb!9p%s6
Mnm-?CT5B7ZM?h.>hansldJpV%3?+.#i0D?5[0BsT9Co:Tq?)KYu+Z\M/F"*s\?H83`$D=&^
f2%rA99Tf<54@!/#Kj=8lQm.m4]A7NA"bi/8oP1452DXV<QT>Xp'NY1.S&mtPZh_3RFj[@J\%
$-Go2h]Ao*5)CLQ=h+#]Au4a#k#(_`i%Au%)e6QIDj^s'`@&(B^DJrJh;l.r#+(1JVG*c,pT@<
*\(HnC-YW"?Uf_D4UE@\iqqj'AV'1d_3_Y6;[80mU.>pV='?5g,<6^[gE/_66ShBEkWLf6ZC
(/d\8]A$gRLpTP;5)!2.f<4CF#R&+uOU73=0eAOt:]AQIX8="ELXQ^DYc^C`/A>dtnZP,kD^5A
SVAMQ"5h.5@hP`HU;WKe.8$$5*N3T<:DSA8F-Ps^ac#!`:29@Vc6L**4E9UTA:1^nla%ik&f
1pdLHZsA9hrA<3YZLBV(PT\Peoe``HK4e(iW+1MrT@.F2,h0M2\$7sjpKf3;[uBk=_D4/K97
a-K6W\e_q0^_Uk[F+<D!>u%c7-nR)Z(a,Ge8nJN<1amTKR$,55/Hh0d^_YDNea=Z(gf(XB`U
6W"I7<M;VrT:/.t55*2fHk+YuUW@mEli3&PaFNXdqKi#eQ<.P65,@ek3CUj>Bn`on<HiajC)
sU%r%kP2G'l+R!o$8<e`!rfoDP*/aD*21jh:H\UMhs)OMQFIHe]A\tE:$WG/V)OAiWpU7*[B_
E#+kj7l:fi?(:*E+g!fJJ*Ch[N.`&8\!)Q[2r6s2W,@bh'Q[Y-?4/=FS8bbjIkP]AE#,))l)+
P#Y#M)Fn_E8TC>Dc;$7M#W@*::m2Rk,P>`ZqPso/(f2stj-PCk[`F`^9E>\NcMEco9OnoV#L
k:6,Iu'+ql;7+K%LROJ0?U%qpitT-SQZ;`L?7Ih36d50fL0F7C`;3Rba4QEbubVXtKN2JE'd
rN)knY@H<<R%qq80=*6eHZ4]AP_1U=#PWEc*A.ZZA;)J+b5pao['M!"_1[8o1.3eh^%X>CsZH
R>s]A8JMWdoSJ9K'8^58akEV!Xh(,(9GkQ_C-0D[PIBtVmiMlnRu3YVmeg0DBI>e=7_75n$PN
+d!#Z0nUh7T2e,?sb$]AO,.5ME7=<4Al5b]AmYs3/_d&0.h?95Whi"V:+VSPrr%-4I1RrKnPMO
RYL@5N'2u4j/-'65\-VLRi9FE,,UPu>"af1J6nnF<cu>kTD[d#':(Et2(8.<cAD'oE3/F(ST
`?(0hWg,,)mj2h*&nH\aE/Bn_hCh8<&O&lWRZbi5=J_OXB1JFPeR",#.c2I\^#R!P5c0Kf.+
=c]Ad\\Rf2a[r0\Q2NuCG+S8aG5\Hj1UFupU0\m$Y>jXI-9[T:j_!^#H#_Ab^b'o"d&HiD<Ce
KiV73XjOSY6j8Rb-M-=E'l3W@R)N*RlP)!eKn@&O@8H,`g?J]ATJZ-)Kg796PDCd_.-Y]A$i`t
mJn62Wi08sW->]A-(0hQC[i'CbR"(j5_?<ENN2.f1\:j"fjZ.mOWr;k?r[K$ECfpk*V!Meb=+
+XAA4UlV']AfAm!(`7VG7Tu)+e8136l6(Z'V_X!pGXg+*E`6dIFoqZ$r#adZuH4W.7[h#mP30
\.d2r)"arg!5T8Q]AfEVRQjr(PI\^NMI3K6b`Gur:F.1AK>lBn5P,S>iMioOL/km9NoK>Vs73
:T(QVPHQdCR>k;m";7p.4oa<RDZ!PA[fDY0e*pHR*[Z55T/%q>#]A]A*]AmHN#F:F:"#0KbpZ<e
<#L;CE[baD!J0GH>T6j/GQg8_k'ie&'c\HjW8`!mX7`^?;m#^Qg*,[JfgA]AAOpM'D>:E%A85
(&M?.2O"PCihiOYLH>9CI`"LU"rYW.IV[:M+pHBO+^pV3>onca6^s5'd!@a]A[[>-5B='OSJ1
:Gd+i^=ID5Bi;-5*N#U<TC"`DpFocm&#,iT2+a:3UV6>Pekc$cl=mVC]A]A@&\frF,jeXVkRm@
H6%2]AJn>E]A5-Gp(n<Ar+<XAq.q$;rGK)gXPU5Ys1q=s:TLW<3$,8?2h;T0Ku2^%*.`VS$ri4
Ejh8sP'c`J=2KJ9Ag#E=LHfVFMMl*haMW!>JrXah9Wpf$05l2hN=S8=R5pn&u4K'UW`g[+8P
&j9![I"BRiZ!SJ25j7mfn--^Q//IOrJE#jGRd"O$e(#SNtKA@91=g%(jap[7!ZrU>!:"@6Kr
Mj9=Oro=/HpA((BnkKYoACjq?1,-,OGZ*!(n8i\NjDKE;_m)%L58PS#@QW"4tEOe<"HSO36!
>q57S!_?=uKFO&(<(p8Tf]Ahbqat!/"U@I^_WFk0UR-g5dSFA:*q<+hT`_65'*.dJq)gJUuj@
Bb,"(h1s47`@c\@,OZ5WRei%'QK\TB#13<ibL>ZBJg?nn5)FY0e/JNE)7ImkEKCXBKr<M88Y
%-'N&/5;D-&0k9A-WChBf=.c,8ct_r5RE6WOa>GZ22N;g4*\ZG9(\<RLb&@3mBS$TGHnP<3\
eX4G.RKtQbRVMCDU086-T;(SA<c<5*!Rrh3H@&nm,X-WOgn%V-5;\>POMRSD8Vp><M!$5LH!
sJ2uH_0qN*(S2OrR46i#2b/CG841bM\=>9W*5bc.XB"3GPjJ3pQ%9\1s\^IuGqDo.sea&OoG
c8s`)"%liF`9l9W"JikQ>Boh.`WIML\g(-!Z>"4neEp=?P0CHYdG3$$?[Kc:.+B*3a"CBtLD
d#!0phd<[M*c?rHL@t#Aa-VOgE);&LJQ@,`U2Rl_B3`AVW`>]AMf_B*5OTtf!V9$$a)eB]AT6`
QrkroXbIjS>o66?@Xe(2E@VH$O>K;<di@p?9Zlf%hr!\6a8nA?\o$M`?b=pr@O.%m*m\%MYb
19G`=EX;X8-EdF4f+KHC;[Z,Y@?Zo*H?%T`J198E]ARO6EWc_3B<-:j(XR\\>:+!M@QU2Y4W9
:-.&<*0KSf*u<rjIT+E@TS!Yg446K`@>?+YB'b2)nMa02.-dX_&qYi&+[R@"`%a,EV:6$VW<
Na/(naXbS5(OU8ST#ZJg2bcso!X#rVV<_5J3Z-?CIs8P\>k:5a.dn&lO<J:L0dIKdPX-Fb!f
Z_$7-a@gNsK<Qmg=s6T"uX2FY<Ru=!8=#*(^d"laKb+mjGl9Qk2^J9(#47TC9=e^U.08j'Y&
e0_D/cI8laE7;n=Op.EFd!Y!YqiC7OfIA5N)fZQYeV:dtM,i*%EAcGCgl!9Wk%suXM_^#X%a
ofGf]AV?EU0V1+`]A'7(bQVk]AM6bojke'8K[T`04c7QDTLOOGj&YuN;F_5XkCg!LD1$2`*2!A[
B"Gi<$Go>L.)N!Q#lAHaLK6]A5s:<0=&Y*hMs^Nt?8>a*F5+15YR`m_9ZokN9q5U;T%&\s4ob
>6-cZD0W]AJ01Mq@8[SF,d+?Z0LG3^D>)8O,$4,oX6L7)_DsZOb6+cMTF!3pce#h_fHfX:b`p
rE<6tp/MXD0d2c\8$SZ[Wus<C!XE`hTnX>3p2WiC[$qN`84#XC]A.[91)1(WB>QmOeOKlZoXb
UmW4bJ;r=I>9^!H)+fB+fO*Dpl!6ViQ?%^VGhpX`,-c)@CF;*KtlO8[dKRW,:^VWW&/aCOg!
Ss()*u<hbon\XA0tiiaKVK-7cuWCnJW3_<;,*TAdYWNWD:/g&HRi1`\tu%S/$3k]Apanfak?J
05>Bir(NKq-/#\^tn-bPn[F9+&gb8PgP&d_N]A@K$r4fN<mQa.hQAPO&":V'4EZ*9kq,(]Aoqj
#+aW-nZ554pJKm+L"/n#noFb4*/\@a#6M9).GMoeMO87YOIT16D+C%bHlMQ.WH2in<iBioLb
IOsL?GqHA@e3_'bLGr3BVTOZ0O*k;F`ua@m-iM*3Q2U>5uJi*q./.k>dk*c-4q*<*B>Jn:#'
lVOp6&:-]ArPkg2Ip%fJJs*f_o&V*t[+#d*#,SS:q5QO(eJ0K*F<O$Le'@$?m]ASV!rI=su(%-
U7]A)c><i,T%qbf:KqfAM!;$B5'KRF,%d?A`["[o/ti8/FuMK["e3nHlSdU9pC3XcQ)$=4h8X
lB9t7*dQH+KG;t/!32B;Oglq:i,JXhFn:7K[Io?R;(hKiG+nu+![(e#n(l_nI+i:3+en"\/'
@DeNK"2]AqMmP\nRY)8'uik,$DE'@#^nG93]A6HmoMTn)qmfS!plOYrFe1O')u78eM/B<1]AI<N
#&F.RR;11;0'p2#fZGZ!#I>i'7h'\Z'/f?=u/<TRWI3<'9&BHJ,<VXYWFHJ^&n>?uKt7Qk>@
<S@`hl\FtnK!ATg1O@Ko\%SY.?R7Bt93+fsP@)0@+KE'%N-GuE!YI/rS@.#gGO$)]AnM!<<S#
!&c_+q5i1S.;fl7lnFO,&PjS)^FZE"F%2<KP_E#RXe1?31DL:&'2""WMT"+?o+YXjQ;SA9d8
.nO.*U&+RJW$CX695Q1TK_R0$Su*AE!@A8t(pDCs,ZpsDhb%oJfW0`e'oRH)$&-f[d9S#:RB
cPdQf4sE2khDVKoV]AFoj!]AmF1[gn(H"Xpj,.BtRB(,[Emn>oT3\8Zr]ASu,1]A'V2#1ClJle=/
+OS'#=6KJD[%oQka2dqd[*Xo2":e.-rQImtc%YOQl%h9XtmTj[ZKSnBmL<'[<h:N"EK?%DWI
Ih(d*aC'W6lZ^2?rW4?>)j-YklGM;&RFeJdQ.S<&AfToJDR[0_V5Y!Vj'"hYJfNKDi7<j\?J
0mkb=")m1,B\^ZI,:4;ma\,-'P=IO,C^[XbMb^<<e06[=]AaR7HOI&?drB7G4Yf049Y_=5pn!
o:4K8b+`%StJ4$TYU7Z^It_)]AANX/>T<.eUDqoK(I*[O6T+"DE#'XEh08pW7&XD%'d[Im^Ze
PrY3poB3WR!GE`IkhbJBPG\$Gi=S[PGMb\"Waip?eI,PQ(.1s@$/#),UfCKZl.>Ga3rM#CVP
O,L'skfL2:mi;j&C=P?YY;aXAOLC%EQ)"#hrXY'm)l*T-c,j;3=Y&Uq6eMKfs7-S]AHd'44*"
XLga8C'Ye;'s,QJ$EMSX.6ELaS0N'^jC5+</R$QCQ(>"@mCY)Cn*#2\#R=oB?fqW74`8kNd@
M8J/FTM0UUS3Q,!qet)Z^qRr_C>`%@90=nKt]A\2T%!c^OSiT_js58F@bH;8;PZel>^[-s*&K
$:LoW#d(94"iF;7s\?["<b0R@l@Xr)03<lq9nKbHocB]Akn!1U@L"L?n-W6Y3-'Q/9pS-Sn=5
c_B<PTOb0;^7SKgG-phF1LPu'-=Ckdpggm%da>KX*%g[8cBrgFcef/3&')^:^Gfq=.9nH9_@
PZ\nt-PG+=Q>V<,QHbnS0&7a't!fQYfjd6mmXW51pKWeeN19o]AXe:efHMH2f\-rqV$dddY(A
Klb"p+)m0g-M-\^*>g&7Rn7'_qB<:+<Vo_hn'Q&Li%ZPS?Cdl-s$cuqlM\HOoWXipPe=iulH
CX!O42e#4>HsZ2!cccEM%-m@m1f)J]A"?K&T?iMb[0*,]AXs^%mh/$(b@6$sM*"-piO/eia=&G
qH^!J]A<qPaG8H;ZSS2/4^qLl.sm0I@HhlqWP,`bCf:..(9#UjAOF]AmuAP(`^Oo;p1*m<F-9&
!cS10`hBmc@^Z^fEk6*@MR&1/F.^gC_aLD-n(DN>Y;W\8JS;l)-#^d>;:?&oj=>(pictI\)-
W!9"3m.#3K[oueDdLhl[(VgpO`hT)Ck,CF$cHE>Gd]A/Uoo,^>4T&`FfX`#m<lBdK\@F<OsPc
36-VG:3Y=><6&ZWFlAfBT:@/^4S3cPCg6%>U,.0;SkJE4]A=!#?C&o8o'^8TQL>lR&P&k-`*8
_\?(ruS%WSmp\c\UCE&_EOb->PfX3>(H-gP/"<eClVJGpk1Wq7?);UFh3Juf1(3P[n,D]A"Ib
";\S<k1,L'X=#0gGB7*G^fD<1Nkr^)s#kP_Hl'64-s%reB/3eH2%i3MXc"+*BRD_DTtp0$2=
B%,P?:6,Y0<F6Yi$WJ0#2"OrMa_?u?P0B^()A,qQTndHpdYipCEg(W(Z+V`!dgEYW@g-mI1K
&1YKi(9PnNq3IcVmuMkjEt`3#AFe7_U,V]ApD\iQQeJl.sj,7(khd,OA>RA.^9]AQdubEraf3k
E2\Y^e2Y0ghPDa9^dYsUqRau:Yf1TmjL!hj=ED+05ZDBHLAGmtpb(CtAA^Sl]AHdVI4G:q!bY
N&ZIk[;qb#Uqh>L([TTNdD+$/;tqU`P,2>f<#S5/@^H-3>>S^lS:efrHc]A8;gu_a1Y0SuPkt
73^:+Zs>Ollbamnn%5?()cVrZmqChS9/p7`PP8(p-33bBQI'i\@L?4^!s?8*aaE.pF?l=2Tu
fSEMDd7/!^V)7^/"8&L5;a&RNe.t\,noelV!#Q]AUDXjNO8s9SQORmF@WZ2t>?uK+mSj8!SLc
[:&mU9Y8l]A3W:WeS:APHJ\+@+1aos&1TKh#%R;!oP;4`UgIbRH#Rr0:b]Ado.r>Fp0&K\7Z:C
%_qZ>Xs1IB'P<eM;'%-"Q=VrMN;dE]AW;eYTSC,XL?MoaAM5"6e1#=@haT/k-0qF^-lH)\d72
G^K1^^`NU;(N!d,@'.D`-I&LVoWF-2Jq(M'RFL@P55*GMV4*OYP-PYMVt@lDh3C*hCIuN^8`
$UlM>)=N2BNVprCZ;r&`@]AL$Ej%[iEEP'`UDj:X;-^\(F)MX\F'Vkm1Gfb18lD%:^=6-CT$s
qHE"=*uWf"2JI$s2ku'`1?LJo'3r8"Q(b@"6LYJ(L,#(B5P;Mu1!>M.jLs<4H,o1jX1-5dHq
]Ah>8sX,VSfjl6AkT>Z9l@s\E_l$-%%>Ml2=@Y.4K,T5]AB91or_Z%:gNEHTLKA\Fp0,*'@.5q
nofVZB59J%GrWXL)qJ#<I_9g]A"r(FtHh)S',:DB"M\c7D@:\El\lh#:_BC!:H+dd\0DAli-3
\T+`k@,+^M>4h3!YGDZPKBsQe"Sk+FfD[9`Yk_3<?TiX?.:%N#WBAUoNKhTD\tu+4g'84;:_
CSR)nmR7&'&@_Z@"+]A>3H^r]ATAB+'a*)P#B`]A*WNP"HRIf;FrpL8PMCmd9?-$=Rf!Eak>MmO
cWbJ4rJ1l]A(Gu+Fp@+>;;_H#d5HDQ<+O=TCA2]Ai#A]At,<OSt*BoA**`i#iDNq,tB2;M.%mp!
q5Y3E>RtVFARIp*#@eEY:\ire&h'p*LGoEcRQ+1T_-f)'TB3Jss8K6^58Yd3CA07+3?CU!_"
W(CcF[`%3u0!#59]AftsHg2Yr[HDpEh5%Z<k=BPap+@VoLFH5NYEqmT_\n--8XX,a.eFt&d`G
+a*_0,28EG.lGu_C'\XVjqnfoucRj^_^odRFW/&dBPDie-S'UUqj3k=!MKh!W=F3bf[0YK]A&
262JMj[Dd0ehE+H:&6lRm_)>u>W]AIP462/WEm8)>%/q[-\[TlBQflh)pFj]A0,HPq3.e[V80H
i8c2MRfYhm9".$;;537mQBWAlI/cq1+_=$plpq=Se:^(-ANCcn/V$gJ$sfjV1cD;qE_rF$B+
9d<g&^jKO)SF7BYNC0?^WkXoYU`b8?N-9a&iP%o\f`&V);QMf-Y*#<KA&N?=^W:mjlKkFXCf
;W;X-lPXo$eltcP-SDUaf^L^%/S>e$M/`B6>_jp5m^99ss-^=Y81O)VqO:NiL^,"#b='qY%[
uquLs2rU@2Zua'%EQQpV7jgI6hW)gN#9n8W12+J92VWn#(^Ec0,U3Me/4S..1YAp>KqR`66!
05TkDmQ?oS6VdFUkB(k-r:h7Dn]A)XQjukZ?XFe:HhFGrL`S3!MYA31N]A-o.CFL*Ed&$Am&1J
cd/g_NL4nZ2j4ZO<(cXe0mJL+Lc_4u1$g,T#O_/e?qUS>Vc`.12I?It7_ZhIr(B]AGK-D`@0M
JCNTp,:#4uN*MR""^Kid]Ar3s1a/L*r&NUd2P\<nOdZ:-$\N]A+*s0\_;npMRqr_>822.@pM\f
'W6[:oMmhn#2W3E#<N/CNG/JHDGgt8&Pq7`RO+&el+>P?0eF;tb[h:;Qbs8kU7IY<i<#,fbM
nOS#p]A'+=6V`mb41i#\`'VH_<Zo\+e.\S7fIC<aKC'An%Rf,e&3Z%F)5l?l:jO2qMH9\0:bH
Y8hc[G40eg0dC:]A16B)+@&Nnka#$_M;R(>lD>]AHKrQKK_M2O]A0Qhq'd,B`kR,)YP.L9oC%?Q
otR;4^eZFa)?-$.6YRY07o\S[3)F?,,!+7\2/+jtE0$G)6PKQ/g7j&$+eZn6mZ@A=l'lFJ7:
2EMBDeUO-SsEmj&6V)aLg3unKV,miQ0ch&HTRkYPuVn&CkVd.^>3jhsuM,jB7\D5Ig]A^Q9u0
,#:d@`%+cYbIM286n*6#7H<\k=he^AK%<c[!-:^Hn?-Sg0&=Gr8$trRiWdRrpr%#k(.GVV1f
MqL45XXlE;0)09m=kWbSYE.c``WL\5[]AW(b,r)IR,s6bFFW'$]AXJYm3V`"A!!~
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
<![CDATA[m<a+\PLm9]A^c5/l'l6/=5tg7ZUdu(C#os-V-sEa/6%WURW'LV*10-iN+=RX#:l,njX'u3r0I
DUu'HeSl5Tg(FJd)iY#U/5P&jVA'%buD[Vmh)GqoCuFqqL"3mp:@CGHF$hr73IfT74*0'+bH
Akms8trt,C&T`YA\oZil$Bj(DuPi`&TrSdWlG!oRQBR^`Rh&Nl)")DUtW&*_O0+/;VKH+<>f
q<sRD_CtPSD0kUH\i3"Sh#92G;S3BIusJ?=R3'H-Tb1642,1gXkf4J:b0PNI1qW-*Lm:\'e)
LuIm9JV*upI:al!R2X3Mc1PlW95)O%i_Co$31G!*4fh?0(59[\=>I(]A\$RtBJZ]AmW&,TSe$]A
VAE,,6`9U4?&GZIWg@@MkH8%%"Y32Q+fa=e6jY-?>DntjTp+h7,4V#Da61-EU.B]A8eS^bOa,
8H^0--BX;@MraKruMtG))cX>50l/@3UnfVL,n$]A,,;8SWu*O3D<JmZgP71PZ>9316,tb[U$`
;o-eZsm!Q+o6<4_Y4^`+MX$S*R$Ve-Yanoa8=P8=+pOq]A=1MDW`XK8M$)^76+V3nT8Y"3F52
9g8RTjA^]AX$b^!bJcBU"9uF$R!o\)b-EDUC@rp;$]A3_&'edDaqpl&'Y2j\fq1.Z3l-Kn+4[@
PZ82MV53HOH>*^;Km14&D$2c8W?g"j`X>YaiWCdf*(JY.3#bAqHN`:LVDl.DEV[d"UIq/!Mi
h@@Ua;3.bj/'W%6]AqrsnXf@+MOVa0`Rp)nn;0?1,9DK$k`RY`PS6J]Aq,1_b,ZV;4E>IR1L0b
g/:fBdFePd3H/GT3L6A5e]Aq\]A/:]AioW2WXbQ#/OW[i7P1&:WJ,_$V!ss&2XueH;!VRQXe$@$
1"(l<MQ*51IVAOQDV,aZKh^CIGW8AM,fpr0CC,Y5pUr-ScN.KAZ"620DU;HcE2bMkmW#J6j]A
0gmA\o,L5(,)Ku`gNkO1p(6i3sQ(jlWVg6AbauJk^eKnU-^@A)8JFlTpm(*6Q\lFVO<tLB&U
o&0g*:`V3Q'LlTCUqN'&%P=^1j``,3)B7-K?^=FYS*9'g[_:S*5E463k$Y*`&)CW=roe?-LV
V\*i5!oE9&e`[@[mG1SP/XRbeTjti'f%/L%Z:/0n]A7^&4:OT\je-kt:;As>7M)B1KaN>;*+*
!(V2i)j>.miQH7k<Jo\&+t.&uU=WWI4-oiUX!C]AhTefKre<$DD9+d?ZVSTa0<-*eU#c5GOaB
t/k*o[B)12]A0fM"ZV.ha_htnl^M.k#+!cmR[2&-Mna/tb,f/VP8Ysc^#@@I#i\@[g:5/*8%"
WNEb[H)*e7+G^GQ*OWa@nuH>[*)!>?+h6.ODUuaZWM;NG2#n&j0s<9"ju&\^7kJ)ji]A*%1"\
"PETB(88Mk1+f"T@7C;J)4(7eg31ZQaY$OCV<.iW3ms*(K3NuU*?HNV1BA(]A3+b]A0"EqmVBp
b!O:akc0bG*_"bqS?$DS54(K_%c3]Al;gL*XZUto#+AGd'9)1AN%BPc&%0qN@#V,;J[_+T;Xm
WD5NE92:FolGNY]AF<_Bo:M#YCVpPKk1H7&iH>ch?/,L-Kt_n]AbWj3>4T2a]A`4l+8t@]A,d2Cj
Y$/T!7G1pjbbokWF@jGf3G]Ag19$.DXNSG(\bmWu@Lk1#8q\:)&Glf,\;c3,d7TB0?Jj%#=O=
]ArD=XDeq[p!b]A3BX>\$"XHG'RpoM&Wu#GjKI[tH=Of*6'Rh;PMkt;q-cF2<mo6;rGndiaYtI
dlUchs40BSY7;bZ;`Zf$_tb8l-rMD:V'a)Uu1>FaEc5dEFG+;6]A<m+&_YXC;MFi5079o`P7$
a5NjET(:()qM"Y40pkF@,4cGb0VI!r2r2h5qudRI+:Hb?$6P/8"3-4.Kslna^$]Ai.Ig@a0'#
b>GN4[c_UMoiBeF^`PhtAJ9/r`c^mud1&3;(a[MIaW@p3\EDg(m[mOhr"m9(R2C+C$9=F3Y,
`$CBe)Prc@n9![tY>K3QLqD1U_\QY%LT(-A!d%i.oN7b!8gN/8Qj:hqs7/d7?eh^1p@*f@8D
b^mjY<ttFWuLdhc%R'oA_`uBTrl)/(k&B'9%:`j(87V3]ApL*,-V`T!]AM#?brMDsU.k=NMn)g
hJ;sta<0Z&+tB7Nh<M,a5m(i!F*A]A[Y;7q8,Sc.49R[Fg42R8k]A>bdG@T`CceKPsM^dO2;d*
oMtM%/HR$MHSg(<Sbs4mi;;)Tm:CuVRLEZM>*t'eo9X:+2j$5?,UC(M7Yg-pNSgEg3h/+pc"
LbJs/;-'0cBCOY;.DF-O_f_T":7S-`VAA]AZ;^;&Qi'r4s2Ea3+2Z=aq,&u$*(k.PO17hiho0
7<7CfR"(Ub_IiEde)PlmcdT%A[5VK7'D$r>:mVufaQ:WZias'D#=]Af,8U-R&MKIg!-'uK@!l
4k$+Z2DjBL?k\W;GHkC`oXkHn0h,*W1!&ObAD@"]AILhpV4[?)p0XopE#j%8?q0Q82*:_l8^<
;9_Pk"cWDB!e*"ouh80+ZafCtAe$B1RrXc5k]AnPdY7E"0H6,[SgG2>GS@>1:s/GVRS9'Jg_V
1X+Fl_j6*X)7ch*$)(bF(ETu1\rO:C7j,`h$Z:;ufIRA;V3)I14r.&$Sn/OoHc3`^dB>1eQe
qt5p`30=47X&`KE[#BCFCh36h7g'Z#N(&7p/VO?J\pnq&A;&>5`5$oFi-uEPL7?M^O#qmIqU
EjFu:4N`'/i7*ki.ODHI9`T1\GnQD*lTd.lCbYdD;;DrQrDRk4UbYZf@$j[6q(5^TmBM3M^K
i>L/<dQ:J9"A+(*);<ShV_>a8-+:L%f9ko_@XpQAk;0f.-7_b#j*2,`P!XT\W.-_S&McOaiC
&O76k*_bM)u^"gm/Ns(;UM.TK<8UpE^a?m!XloU7oiXVR$sHB/bA(qrH(<JJThfniJPZMHg9
l#+R%o2D=3,L5*UUW4dss-AkM]ADL$"Xe)eV0en7t3>oNdQS*Q%d:+&irWsuoT>[XARUJtFnV
j<&$2A]A82uKakQ??shN2N'5+]A"rql<C%@8bAg:A#PklCu4WhO9M5&J9k:\.5\_Bm4E^2=pXl
:K;FX6O3FB#OhtRq#.R0IXj@BC7u=-)Q>fl?9o1TYFBl>J;19]A$Zp*UQ\AVe!MY0MGcMS-Pb
hVlI+`fch9Wr4ZUq]AXQ2.rY!MrA'_fN`5XlU@?3^D18`!S)DnV"oK[@NN$igW:K%ise;e6!q
<]AN:Bpu\7G%rla+ma+5\%"PKIaR*G3T/aRM89rmJH]AF1hhBb',RGT'qXq%]A:rc]A5l[3B'l')
cJj*'57KLTjS-\^2og>[iOQp7`+OVDS3kiVs.#eQ1!H[DO#ohHP)l8"K)4(aTr`?tl;<t.49
Me0Y[D[qB(:+DA"Z4F7-e1&>tU<D4qk:>Vr@c(]A;.(EH%E_+dSQRpi>OErY5A\4<S=W+@Wa5
_`u#i@Jm70uN>gK#W9<>R71g@S$s<t9gY+>*6OafkMV=mt<$t,c6RKnE[TZ*rW-k4(`*5kb7
@N&A^$>[##Y/pbUSVqp?dp*.J\@"0OD[6XKLk0TJZ'5Z1'uL.NscA==kp@A8g0aNk(>h>k`1
EL)\=\AL+he!Pn3p5*0#"OpVk:)\q_(YN#ZU2>fD5Jm#j^>ZH1;9GG?OT_``jtjM%;00&TKB
qc_ON/6^IDBb2n\nEB5I8k+Bc>5_B1$F>r:-!Y$WfB9h*3E(.#L08Yio(6?%nm&mchX%gm9i
@*4bK,!O'`&X)UkiSTU>Aj?Ar>=CUaV!i*\-]A$Tjn=Dl0%]A>He:b"7*cg.$QL5uTZJ)<@@oP
N%u3f[4Zk!['/&W?)G/YXdDNeM'N.[7ibTM!kINF2\.m]A0j;"SSKG6'59RiIFAUORk\k>8%P
%V:5]AZXWD6Yg]A?U2k_L*Gu=LIb$rmRgl<KF%1RoD7a=A'`Ti<8J.Hs:Y0"iX=(P(5pBcKZ*%
P2#7_-`/A*&*/)V^>Rgrf>:(aA&"rc1/Ec]AYFkW,1!O*BKMjHnk1j;I@>Fd)'%/#(f[S'^^g
ndO<8MA^Ehh_2[La-FX<fK-mo$SO&q?N@BF0JI9k>L]AagFRkB#eiKDe##RCuT0>SpI>GXefW
4ALj")H2J;"[/9+.#*+WR]Aj%dFd:^D#=okGG`DbJ:eh9C3T'aAFVB*P0?b`Q^T<Uq.O]APXLb
ai9E8uoa-rjCcXIdP!^fbq*H38i;'DV(;RXoC(f+PF_&lb?^RR-AetgYPNK+eb0@iC(4s"=Z
H*Sl#XKf8^dcfgCj]AFITm\YO1P2k12RtX<@#up!do<94K%YG=,QU8ojN6lu%O%aBk<S0A?bb
LC;uDS79g[jGq1o<+eF'$:*QF#,^3pgUnXOG3\=?VM24G:g4_u5ePPip4Gk%<[_-C-+TUP?M
EQ7.ZYU<&9Ouj:3E._'`>CM&t%h;8;8s`Cn&,;"i<cR7PY<Ulgq;'*no:gsuW`Jq?LP1uoOp
nufKI_Jq_r17:L[!e[o_-6ZMk>+[&NnH\L$8=)45JdK93'V>:]AFQ`abCgN2S'ala(SQk($QU
TQ(>WMPR?]Afod9uE]AlGs+YF;jaatOX1fgeq'@=W*&AdENj]AKi+:rTVR/4C-kE4/`j>*.%EYH
anCNLXc&;e:1f6RdG_q>uMk'Z)2%q'hP3tOiYq<E%.Ed#;AN&(eS/89Ql6bTWLb`9_a_*DSh
[0T<T5J$'bR6>,_0fWMOO@c=J6A"k$'>d0aEM"f(XRiV[25^\U#8qKR</6Pp39S\85[G59Z"
<*>/C#*d+hdkelq]A,=a[b(^3L?&]ATN3HD=7_XP^qG3'!hd4XC!<F06o<,Qah+Sj6)q]AZJe9c
891\9S0m_&uY`a'Nn=F8oA$Da\5!c9b++_UAq^\,4X1;#/CA.:-#,B\W>4V"bM[8EdlTKCuE
<e!g'mLR?n_=VAuX`jP+#0d`&"<2U,(h\L:*C%NAW&5'\Z`KPu;0<k*mXd<I_5$)31iG.6p#
and0MB#@@#KS04@J">K]AT(30f$PFoC)n8#N^BO.0nbDa9(Ai9@ApN*&npO@JfujUG$uZ\.>u
aAe,;;Rlq!Ire$RZJI!]A%8.8KrAR@S$dRYHU\cC$)!ND`f0)"O$CFG<uEhnriiS:!Vg)Yg;.
BerBr.Os[QSBdiq.1_Pn/9tp=<K8ki?#hKL\SGZJ(oCnC$"9CD_`JrpX#=#kPg47E&F*eGR,
ChW;YBQ@dllMln_GsQ^s32ahY`KN)dUKI,3Ub@McV;[F-XFk\ooHS-h[or%[HDQb."W45M`3
_?hY)]AiiYU"!"!7aEh^E`k4%+Y0`mPo'K?2E8A$aPS_mD&3QC2dh]AGgg'01"^2S\`S]A51oN1
NN)sK&:HKJJMo30(5*7&H>ZT)cg-(E.^VZ*Ap!&/2k"'U/(%so&BoDTe='5UOk`:mIm+n]Ape
-o3+c5"T5V/N+k:a8\.Wo*P$Pfh=5p_/0!Y!KA]Adt=!hicn5g-K2b;stC%E-YMFg,Br[Z4X\
qY1a^9I7&og.aG>]A:GQ%^0;L&BP;hheAS-K_!XfEHfXR\f>^0-AOm**Ke.i.Og'6mB\?LrK.
JGqVCOPpNL1%aN#tU_qMR\Z^,flE8;,GJW08;hj^UrHW=QR"MHAi/T"S<s_`kW@Vl(Nmkh?!
?9:trof`QdaT.k><Bp.8d+BE.49hsT^K;"]AZKr.V(c);@<W.LH9fuH")ll$=+p9S8f.824aQ
G$Q$f\\#9&+Pf-WT]A_+^;:b$.\)K1S*-]Aq^16cWg_W)ek-i\--Fab0J(?^U8Jsn?B:,_mQ[@
l_%M$4Qf^(K4o/CE+0?qTfn%n+KO.q-(Dbq0ihl:GXh1[R$8uN5fiOae_)EqgTOE%?e&m*@h
b@J"C2rTH)F&i^1c*`U!QD8'+<aDAueqn17bbNF^oAJDdrnJ:+DnDIa5IZ-XM?PV(Bp-&WXt
quW4!%rp5b+J>7S1BDWC;$X((f0=i45Fqht@U\+p>\'&^X[HYt"$4*o(7>&PI0"akaQp.!qY
63HMAdZ[@D(rUEaPO0Jdk_5lVm,>E'-g\*"dU9h3)89@CP.?Z@bHRRE"n/9g5rm?f/R(Jgki
jrA.e2!$$m4gNR34@mnXkb0'N',9MY5n`1otYeJAREuhE^%g+EiQYegX8l1AaBp(-<.9GjY&
4Hf^ns"a@k"H^qO./.2n-W'qW;'je9EK&H'!C<h@lA,S#q!$b'X6g,SkX1\mq(`Z6aG"L;PQ
LnSJucBI3cZQU>5n-1>Wq:3=VO$E_LIK.H&poac(2QH*\@IttS5d"n`5V3B1\t#Rm4iZmZBL
hF9[BW_PGO&sP*`0-BCmD@5_Yj5Se)".OiLp9W.@W\IM>Dd+UU\M_h7=eh]A$sYRh*=Ft=NEN
WFPuh-^7We!;jm.%;q(-")NoSd8YR8';-*!l[ZBm#U_9)XX!&KM[6U*M>^X#F.]AlVp+]AV"S4
=[R1/7XO9kQ-1hldUU]AK0;pkA5NtIPDS$5K1TFPWIm!iLi8gXU;om)=5:cCE'OhmM>TEmNV0
c+qK5J4M^Y_$iH=R7GN6l<2Gn"mU>I$97>QT")>?,,?h_&o_KA(T&_'JLr*o3t)1"^<<._&1
$jdL7<6>,P_]AR\+Xd0E(?>N"<>EsnK^$drC7,^^*R\o((0WZ]A`MB4ZC7B&Z[@nDTYV@fYO:I
)_#<-@8+[=te;4@2m:7R]Aug^gOY?kZ*MsU7kZ=Qu4@_2Q?6q+XiGi:,[`7]A).shi9R/r,s4A
's.H\mE/<_jN*/o"r77NDS4^G.6+ZAH^PTkJ4As_&\-iKE0`Zam<H*g41;b@bn*B%hrZP/$T
VKFqQkLVZo6A(&@]AtZ\Vs5h]ACggrWSZ4HSh(S4=!__hb:SOJi%:IR5"[k`F.]AZWfp-0AfB_6
@Mpe<%D>]APo;%kG-gQDEKV#uZS&#PRAg[/\S?Itum-AEY?#=pL<dI;f0rSe/2;lRDoWGJh2t
V(&ghen@IeGD0-.Uuii=Jri5-?[&G!)D:^Jg":&=N[LD?-cM)a9;!_!C@9`Tp'nhj5&lpl.E
3JU^/\B@pf/7B/9US`EsCi/d:(6,Y*$oGp-e;Y?d"**5k,kIWi72O9>&D"P(XS'Oc:XSl_Y:
bWr`Ob7Hs!g5NN`!iQEu?.JnRae`WiH!Ae8/BTH8i[eM]AM,U11?(6#0EOULg/FdNM'/ON1p[
m==6RJ&b3TfST+8(l$]A[4^RH1b5:b<p1Zf\IXi8io=#jfoc/5+0WTCP@n^o9Drs1RM6eVjh#
6qY@U\Gj:76n:e+*2#;lmsP*[TQ[PTH38pa`$k7p=B+0"JV5S10[GO&mUb6j.jTOedTccfY`
KM#)2+30\\\iWg.&6fJWZk)-M>ae>K1luQ.b6$O"g)mLKma&-iF?kW$53p6/+GnEYd[71C2P
7A9rHs%:ePmr@^9gg1dsH.C.F_%7/lhiC#R;">np+di:K=XnQgKVta-0g5%d7_tBK`?Qn7@9
M_GP/s=5iols$BO_'&"UY,V&/;MG2i^6j`A/)UN-umKs.Z0[J2V(V=g>D8+Kb?+;cFm#99J9
l7\j2c&"hSfOU]A<!*2t_YK3<-g5!Xo3tgkC-C(rolj&d*bZh[`K3H1CSP.bVec$En#9O?olt
2"7@R7D)"a.<ZmC0Yolk*4l$ljBArql"=_%i)TO7J^4XCJPpZ7/\hl8lpfkCcn:)F:D;ZG!s
9BV6*2%`su>O'R>7jZiuhjBL/>=rWe4oNFj/OR/5ee.:`AGa*6L<Ok9dL^'H7Z*e6PZeL1K\
j$M/uOc#^e:@RqQ@TF-PAM%5N9.3DRh[)W5]Ae_9@i91!Yq:UicBitYH9%B1Fi9lr>rU=n6Er
s$G+X#=YP(B0c9R@nPNE)iU)i[hG2tmh("jb/Il*Nqj1l2+!fdb0R\EV1#]A;dT<5^!!+77X6
P@%B(437XN_/5(9#3UC:U*ViS*YuW\965k!pYO!?km-)]Ak?39iKo%>k7=eb[0D8<,%kIh+>I
(J_n-A$OZ+!qB/(!X+27D[fF)f?pZ$/67o19nrCrr*ZD]AH.()EE#-r"tSCuGVfBTEL*IeIPN
0rV>.RF/>:%a@AQ.mHqthDDYKci8uXqRa6-s+BnE`0j'SLDk`%m)pW>"Y:hoWk+P7,<IH!Lm
?6_U:gf[hgp?/Lk84j\FuS+m+<0)2jmZ_I5`+GD.eC%LAjc1hs5ir(!e["p24=`]AKr4a&'<<
YI*rKss".(2LZJ71_rFkFZGso(XDPQ=Hei=LlnP(eE]A.[tr,SUiqY8$:BZrQC]Ass77ZCUC\@
8i>t.=#rt&XeG@)VtHuTdC-up7HO2D"`)lAA(IIC]A$Tpg&!nLYWAcj.8UWV^<rtTEUfsJnVI
);(aFP-\<:K]AqLh++SX35H:EDSQbG]ABi@'\BqJ_b7@\P[RX_0;E'4`FC?Ck_Ik&^11AM#AFC
_FR7qbSKCLVjq<[pNoP_e./^c>'nL^4$ZMQkO(I@6et&!Xl/'?Ar7^IPe4_kG']A)\;A?((Jd
\gC[26<3T9*sdqGL[e18(TA+K)JqgX._Pr:ikHjh=0gXHbh,O$1\a42XRTSntR6ri7(9+("F
b419AZ$T%U]AbBje+fGtWp\G7NE[6r%$CJ#FnF1oQ9"Ri*5oHL$(jQckKkV0n$`7J?d9R]A'9U
X(XK=<4>C9]A,T&3S*o+p6eoXfYlHS^&(2t\(?l<S(=[G`tqP@Y^"n^083.EGjJDd/7XRL47-
J89->5_VZQkG?7,lka%hUC,kfp@Rf2D43;YWFB,W:9;Ve3!<5&$Smar]AX6Ml(GZ?Ra0nfdNf
NNCc62a,uh:c"V/0&3D7leW?)FOOkN`)oc5/(1<'-UQo`1^ptd&)H-3k,MO4T>3>&=FJttLb
V>ZPDW@b91V>,^Q3MJpgjkjj^.sIIJa`6TdrK:J'+IY@(Gs\rsl>uH!hG%*Pl61.+"_?GRDd
&._SBX)<TV2A<9pJFHcN!!(`a9!WPGm7tcV(j6NcC\j@$d4]A>VobXM*Lf>(GRIgFL[_]AQY4>
a8L\39D(nEV>U@34Tb&Vi_uq->$ho.;Nr%#EMY:lYh5M[RI7'!IEnXp=ou+Ar!IeZ@aFt)?^
U@:JEmh`F,a3TES97nk#hFC%@<`K=oE6&2[+1dJ=8M+(185$THt3VOKD=[:/@eqR=ed2#6kD
>&*&#DH@hC:H=,*EC/<DIgOe>8B72YOt86o9IaN:#i$0f"[)^,!hVba3H_`-S?B=o$m\Of`p
JjCjt@rXH(DD#r1A%[[Z(c0+nj(N=bj?Arl;,3^W\`7.2Ptmj6<kpY7qpQL;'Z0fJ?68LI2j
dMDPg'r!u]AE*aK]AbU"AWe(%!DIM9P7!!^;#*U?U*fFnhJ@JC=cqN.d7Gli4M7:%q^\,mU=-P
*th/"9STa0MUA,bYKNG9N)PqP%V./T-f2QM%9XJe>;an&YdB1f>.>`,sU^i%9l?d`+c0U\Hn
mDqrU+@rHJ8Gj8C!)o[mV3c3-"m@jbR;rPt&.>NpBZ;rIuCc-3V1VXaJQd6`6r'A09GnoF#!
jaMD6E,jTH,f8f6HE-5`!stpt4>jgQXjg5G#<uh2?9D_mXe$r3Lmol(L=,(9Va#4Eho7*#/k
p]A^3b@Yhj-Kq^!AM8am;W1H*RAFgr4cAN.m;%PFO8gnZ;7A>q*4]A@X@=9>(sKj2qrmh/-fp$
T*8mBX[WGZ;oC@A;=e4O0n?@:e-E4B'HMS8Np_cH9APX!-Dc+*&`3-(EfQQNm6L=A(PGBPW4
DTje8AY8SWG%Oq.sKI_<:fj\)?bTF4=tuklE/r!`V_4d=<Z^2Co:&I8FuSn`\$**q_mB^IfT
~
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
<![CDATA[144000,1152000,864000,864000,576000,0,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[432000,571500,2160000,2160000,720000,2743200,1440000,720000,1440000,2743200,2743200,1440000,720000,1440000,2743200,432000,2743200]]></ColumnWidth>
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
<C c="2" r="4" s="6">
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
<![CDATA[288000,576000,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[432000,762000,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
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
<TemplateID TemplateID="77691894-7248-40a9-ab40-fd44ee82b124"/>
<TemplateIdAttMark class="com.fr.base.iofileattr.TemplateIdAttrMark">
<TemplateIdAttMark TemplateId="44e92ea0-a1fc-4f42-bb5d-5ec5623c0e0a"/>
</TemplateIdAttMark>
</Form>
