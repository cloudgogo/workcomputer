<?xml version="1.0" encoding="UTF-8"?>
<Form xmlVersion="20170715" releaseVersion="8.0.0">
<TableDataMap>
<TableData name="员工简历" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="id"/>
<O>
<![CDATA[10068917]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[华夏幸福]]></DatabaseName>
</Connection>
<Query>
<![CDATA[select
*
from SYSADM.PS_YGJLCX_VW
where 1=1
${if(len(id)=0,"and 1=0","and YGID ='"+id+"'")}
]]></Query>
</TableData>
<TableData name="照片" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="id"/>
<O>
<![CDATA[10068917]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[华夏幸福]]></DatabaseName>
</Connection>
<Query>
<![CDATA[SELECT EMPLOYEE_PHOTO
FROM SYSADM.PS_EMPL_PHOTO
WHERE EMPLID ='${id}' --'10017641']]></Query>
</TableData>
</TableDataMap>
<ReportFitAttr fitStateInPC="1" fitFont="true"/>
<FormMobileAttr>
<FormMobileAttr refresh="true" isUseHTML="true"/>
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
<Margin top="1" left="2" bottom="1" right="1"/>
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
<LCAttr vgap="0" hgap="0" compInterval="2"/>
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
<![CDATA[936000,936000,936000,936000,936000,936000,936000,936000,936000,936000,936000,1295400,936000,936000,936000,936000,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2880000,2880000,2895600,2592000,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O>
<![CDATA[姓名]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="0" s="1">
<O t="DSColumn">
<Attributes dsName="员工简历" columnName="XINGMING"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="0" cs="2" rs="5" s="2">
<O t="DSColumn">
<Attributes dsName="照片" columnName="EMPLOYEE_PHOTO"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<CellGUIAttr adjustmode="0" showAsImage="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="0" r="1" s="0">
<O>
<![CDATA[性别]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1" s="1">
<O t="DSColumn">
<Attributes dsName="员工简历" columnName="XINGBIE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="2" s="0">
<O>
<![CDATA[出生日期]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="2" s="1">
<O t="DSColumn">
<Attributes dsName="员工简历" columnName="CSDATE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="3" s="0">
<O>
<![CDATA[民族]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="3" s="1">
<O t="DSColumn">
<Attributes dsName="员工简历" columnName="MINZU"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="4" s="0">
<O>
<![CDATA[籍贯]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="4" s="1">
<O t="DSColumn">
<Attributes dsName="员工简历" columnName="JIGUAN"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="5" s="0">
<O>
<![CDATA[户口所在地]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="5" s="3">
<O t="DSColumn">
<Attributes dsName="员工简历" columnName="HUKOUSZD"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="5" s="0">
<O>
<![CDATA[政治面貌]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="5" s="1">
<O t="DSColumn">
<Attributes dsName="员工简历" columnName="ZZMM"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="6" s="0">
<O>
<![CDATA[参加工作时间]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="6" s="1">
<O t="DSColumn">
<Attributes dsName="员工简历" columnName="CJGZDATE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="6" s="0">
<O>
<![CDATA[婚姻状况]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="6" s="1">
<O t="DSColumn">
<Attributes dsName="员工简历" columnName="HUNYINZK"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="7" s="0">
<O>
<![CDATA[入职日期]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="7" cs="3" s="1">
<O t="DSColumn">
<Attributes dsName="员工简历" columnName="RZDATE"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="8" s="0">
<O>
<![CDATA[所在单位]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="8" cs="3" s="1">
<O t="DSColumn">
<Attributes dsName="员工简历" columnName="DANWEI"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="9" s="0">
<O>
<![CDATA[所在部门]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="9" cs="3" s="1">
<O t="DSColumn">
<Attributes dsName="员工简历" columnName="BUMEN"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="10" s="0">
<O>
<![CDATA[岗位名称]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="10" cs="3" s="1">
<O t="DSColumn">
<Attributes dsName="员工简历" columnName="GANGWEI"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="11" s="0">
<O>
<![CDATA[职级]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="11" s="4">
<O t="DSColumn">
<Attributes dsName="员工简历" columnName="ZHIJI"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="11" s="0">
<O>
<![CDATA[任现职级时间]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="11" s="1">
<O t="DSColumn">
<Attributes dsName="员工简历" columnName="RXZHIJITIME"/>
<Condition class="com.fr.data.condition.ListCondition"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Result>
<![CDATA[$$$]]></Result>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="12" s="0">
<O>
<![CDATA[主营/非主营]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="12" s="1">
<O t="DSColumn">
<Attributes dsName="员工简历" columnName="ISZHUYING"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="12" s="0">
<O>
<![CDATA[员工分类]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="12" s="1">
<O t="DSColumn">
<Attributes dsName="员工简历" columnName="YGFENLEI"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="13" s="0">
<O>
<![CDATA[员工类别]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="13" s="1">
<O t="DSColumn">
<Attributes dsName="员工简历" columnName="YGLEIBIE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="13" s="0">
<O>
<![CDATA[直接上级]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="13" s="1">
<O t="DSColumn">
<Attributes dsName="员工简历" columnName="ZJZG"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="0" r="14" s="5">
<O>
<![CDATA[所属序列]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="14" s="1">
<O t="DSColumn">
<Attributes dsName="员工简历" columnName="SSXULIE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="14" s="0">
<O>
<![CDATA[职能序列]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="14" s="1">
<O t="DSColumn">
<Attributes dsName="员工简历" columnName="ZHINENGXULIE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="15" s="0">
<O>
<![CDATA[是否常青藤]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="15" s="1">
<O t="DSColumn">
<Attributes dsName="员工简历" columnName="ISCQT"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="15" s="0">
<O>
<![CDATA[常青藤年度]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="15" s="1">
<O t="DSColumn">
<Attributes dsName="员工简历" columnName="CQTCDLYEAR"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
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
<Style horizontal_alignment="2" imageLayout="1">
<FRFont name="微软雅黑" style="1" size="72"/>
<Background name="ColorBackground" color="-986896"/>
<Border>
<Top style="1" color="-4144960"/>
<Bottom style="1" color="-4144960"/>
<Left style="1" color="-4144960"/>
<Right style="1" color="-4144960"/>
</Border>
</Style>
<Style horizontal_alignment="2" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-4144960"/>
<Bottom style="1" color="-4144960"/>
<Left style="1" color="-4144960"/>
<Right style="1" color="-4144960"/>
</Border>
</Style>
<Style imageLayout="4">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-4144960"/>
<Bottom style="1" color="-4144960"/>
<Left style="1" color="-4144960"/>
<Right style="1" color="-4144960"/>
</Border>
</Style>
<Style imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Top style="1" color="-4144960"/>
<Bottom style="1" color="-4144960"/>
<Left style="1" color="-4144960"/>
<Right style="1" color="-4144960"/>
</Border>
</Style>
<Style horizontal_alignment="2" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="ColorBackground" color="-1"/>
<Border>
<Top style="1" color="-4144960"/>
<Bottom style="1" color="-4144960"/>
<Left style="1" color="-4144960"/>
<Right style="1" color="-4144960"/>
</Border>
</Style>
<Style horizontal_alignment="2" imageLayout="1">
<FRFont name="微软雅黑" style="1" size="72"/>
<Background name="ColorBackground" color="-986896"/>
<Border>
<Top style="1" color="-5263441"/>
<Bottom style="1" color="-5263441"/>
<Left style="1" color="-5263441"/>
<Right style="1" color="-5263441"/>
</Border>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<isShared isshared="false"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="0" zoom="true" refresh="false" isUseHTML="false"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="898" height="557"/>
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
<isShared isshared="false"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="0" zoom="true" refresh="false" isUseHTML="false"/>
</body>
</InnerWidget>
<BoundsAttr x="0" y="0" width="898" height="557"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="report0"/>
</MobileWidgetList>
<WidgetZoomAttr compState="1"/>
<AppRelayout appRelayout="true"/>
<Size width="898" height="557"/>
<ResolutionScalingAttr percent="0.9"/>
<BodyLayoutType type="0"/>
</Center>
</Layout>
<DesignerVersion DesignerVersion="IAA"/>
<PreviewType PreviewType="0"/>
<TemplateID TemplateID="3c081f27-eaee-4565-b661-6871d8d0f17c"/>
</Form>
