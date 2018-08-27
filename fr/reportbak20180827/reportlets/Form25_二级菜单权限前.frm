<?xml version="1.0" encoding="UTF-8"?>
<Form xmlVersion="20170715" releaseVersion="8.0.0">
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
<NorthAttr size="82"/>
<North class="com.fr.form.ui.container.WParameterLayout">
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
<WidgetName name="STRTEMENT"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<TextAttr/>
<widgetValue>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[='"'+VALUE("STRTEMENT",1)+'"']]></Attributes>
</O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="45" y="38" width="402" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TextEditor">
<WidgetName name="MENU"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<TextAttr/>
<widgetValue>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[='"'+VALUE("FUNCTION_MENU",1)+'"']]></Attributes>
</O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="45" y="6" width="402" height="21"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="MENU"/>
<Widget widgetName="STRTEMENT"/>
</MobileWidgetList>
<Display display="true"/>
<DelayDisplayContent delay="false"/>
<Position position="0"/>
<Design_Width design_width="960"/>
<NameTagModified/>
<WidgetNameTagMap/>
</North>
<Center class="com.fr.form.ui.container.WFitLayout">
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
<Alpha alpha="1.0"/>
</Border>
<LCAttr vgap="0" hgap="0" compInterval="0"/>
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
<![CDATA[2552700,723900,723900,723900,1562100,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(StringFind($MENU,"管理看板")<0,"","<div class='newTitle'>管理看板==/WebReport/ReportServer?formlet=HXXF_HR/Maneger/index.frm&username="+username+"&userid="+userid+"==icon-fenxi</div>")]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="1" r="0">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(StringFind($MENU,"员工信息查询")<0,"","<div class='newTitle'>员工信息查询==/WebReport/ReportServer?formlet=HXXF_HR/StaffInformationInquiry/StaffResumeSearch.frm&username="+username+"&userid="+userid+"==icon-ren</div>")]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="2" r="0">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(StringFind($MENU,"人力资源基础分析")<0,"","<div class='newTitle'>人力资源基础分析==/WebReport/ReportServer?formlet=HXXF_HR/HRanalysis/HRAnalysis.frm&username="+username+"&userid="+userid+"==icon-fenxi1</div>")]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="3" r="0">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(StringFind($MENU,"常用报表工具")<0,"",
"<div class='newTitle'>常用报表工具==/WebReport/ReportServer?reportlet=HXXF_HR/ReportTool/Employee.cpt&username="+username+"&userid="+userid+"==icon-baobiao,员工花名册==/WebReport/ReportServer?reportlet=HXXF_HR/ReportTool/Employee.cpt&username="+username+"&userid="+userid+"==icon-renyuanhuamingce,招聘报表==/WebReport/ReportServer?reportlet=HXXF_HR/ReportTool/RecruitmentAccount.cpt&username="+username+"&userid="+userid+"==icon-zhaopin,入职报表==/WebReport/ReportServer?reportlet=HXXF_HR/ReportTool/EntryLedger.cpt&username="+username+"&userid="+userid+"==icon-yuangongruzhi,绩效报表==/WebReport/ReportServer?reportlet=HXXF_HR/ReportTool/PerformanceAccount.cpt&username="+username+"&userid="+userid+"==icon-yuangongjixiaobaobiao,晋升报表==/WebReport/ReportServer?reportlet=HXXF_HR/ReportTool/PromotionAccount.cpt&username="+username+"&userid="+userid+"==icon-shengzhi,离职报表==/WebReport/ReportServer?reportlet=HXXF_HR/ReportTool/DepartureAccount.cpt&username="+username+"&userid="+userid+"==icon-lizhi</div>")]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="4" r="0">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(StringFind($MENU,"管理看板")>0,"<div class='indexSrc'>/WebReport/ReportServer?formlet=HXXF_HR/Maneger/index.frm&#38;username="+username+"&#38;userid="+userid+"</div>",if(StringFind($MENU,"员工信息查询")>0,"<div class='indexSrc'>/WebReport/ReportServer?formlet=HXXF_HR/StaffInformationInquiry/StaffResumeSearch.frm&username="+username+"&userid="+userid+"</div>",if(StringFind($MENU,"人力资源基础分析")>0,"<div class='indexSrc'>/WebReport/ReportServer?formlet=HXXF_HR/HRanalysis/HRAnalysis.frm&username="+username+"&userid="+userid+"</div>","<div class='indexSrc'>/WebReport/ReportServer?reportlet=HXXF_HR/ReportTool/Employee.cpt&username="+username+"&userid="+userid+"</div>"
)))]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="5" r="0">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="<div class='username_class'>"+$username+"</div><div class='userid_class'>"+$userid+"</div>"]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="0" r="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="5">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="10">
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
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
<isShared isshared="false"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="0" zoom="true" refresh="false" isUseHTML="false"/>
</InnerWidget>
<BoundsAttr x="0" y="0" width="960" height="540"/>
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
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="<div class='newTitle'>管理看板,管理1,管理2,</div>"]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="1" r="0">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="<div class='newTitle'>员工信息查询,员工信息查询1,员工信息查询2,</div>"]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
</C>
<C c="2" r="0">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="<div class='newTitle'>人力资源基础分析,人力资源基础分析1,人力资源基础分析2,</div>"]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
</C>
<C c="3" r="0">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="<div class='newTitle'>常用报表工具,常用报表工具1,常用报表工具2,</div>"]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
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
<isShared isshared="false"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="0" zoom="true" refresh="false" isUseHTML="false"/>
</body>
</InnerWidget>
<BoundsAttr x="0" y="0" width="960" height="540"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="report0"/>
</MobileWidgetList>
<WidgetZoomAttr compState="0"/>
<AppRelayout appRelayout="true"/>
<Size width="960" height="540"/>
<ResolutionScalingAttr percent="0.9"/>
<BodyLayoutType type="0"/>
</Center>
</Layout>
<DesignerVersion DesignerVersion="IAA"/>
<PreviewType PreviewType="0"/>
<TemplateID TemplateID="8bf0ab39-aa90-4f3c-adc8-221ac49a73e8"/>
</Form>
