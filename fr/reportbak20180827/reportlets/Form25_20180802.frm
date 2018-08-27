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
<NorthAttr size="113"/>
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
<WidgetName name="cybb"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<TextAttr/>
<widgetValue/>
</InnerWidget>
<BoundsAttr x="45" y="76" width="402" height="21"/>
</Widget>
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
<Widget widgetName="cybb"/>
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
<Listener event="afterinit">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="qx"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=sql("HXXF_HR","select count(*) from HR_AUTHORITY where name_id ='"+$username+"'" ,1,1)]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[if(qx==0||qx==null){
alert('温馨提示：您没有权限！')
}]]></Content>
</JavaScript>
</Listener>
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
<![CDATA[2552700,723900,723900,1143000,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(StringFind($MENU, "用工看板") < 0, "", "<div class='newTitle'>用工看板==/WebReport/ReportServer?formlet=HXXF_HR/Maneger/index.frm&username=" + username + "&userid=" + userid + "==icon-fenxi</div>")]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="1" r="0">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(StringFind($MENU, "管理监控") < 0, "", "<div class='newTitle'>管理监控==/WebReport/ReportServer?formlet=HXXF_HR/HR_QUIT/Management.frm&username=" + username + "&userid=" + userid + "==icon-yitihuajiankong</div>")]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="2" r="0">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(StringFind($MENU, "员工信息查询") < 0, "", "<div class='newTitle'>员工信息查询==/WebReport/ReportServer?formlet=HXXF_HR/StaffInformationInquiry/StaffResumeSearch.frm&username=" + username + "&userid=" + userid + "==icon-ren</div>")]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="3" r="0">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(StringFind($MENU, "人力资源基础分析") < 0, "", "<div class='newTitle'>人力资源基础分析==/WebReport/ReportServer?formlet=HXXF_HR/HRanalysis/HRAnalysis.frm&username=" + username + "&userid=" + userid + "==icon-fenxi1</div>")]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="4" r="0">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(StringFind($MENU, "常用报表工具") < 0, "", "<div class='newTitle'>" + H6 + "" + A5 + "" + C5 + "" + D5 + "" + E5 + "" + F5 + "" + G5 + "" + H5 +  "</div>")]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="5" r="0">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(StringFind($MENU, "管理看板") > 0, "<div class='indexSrc'>/WebReport/ReportServer?formlet=HXXF_HR/Maneger/index.frm&#38;username=" + username + "&#38;userid=" + userid + "</div>", if(StringFind($MENU, "员工信息查询") > 0, "<div class='indexSrc'>/WebReport/ReportServer?formlet=HXXF_HR/StaffInformationInquiry/StaffResumeSearch.frm&username=" + username + "&userid=" + userid + "</div>", if(StringFind($MENU, "人力资源基础分析") > 0, "<div class='indexSrc'>/WebReport/ReportServer?formlet=HXXF_HR/HRanalysis/HRAnalysis.frm&username=" + username + "&userid=" + userid + "</div>", "<div class='indexSrc'>/WebReport/ReportServer?reportlet=HXXF_HR/ReportTool/Employee.cpt&username=" + username + "&userid=" + userid + "</div>")))]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="6" r="0">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(StringFind($MENU, "系统管理") < 0, "", "<div class='newTitle'>系统管理==http://10.20.60.17:8080/WebReport/ReportServer?reportlet=HXXF_HR/HR_LOG/HR_LOG.cpt&username=" + username + "&userid=" + userid + "==icon-chilunshezhi
,用户日志==http://10.20.60.17:8080/WebReport/ReportServer?reportlet=HXXF_HR/HR_LOG/HR_LOG.cpt&username=" + username + "&userid=" + userid + "==icon-renyuanhuamingce,ETL日志==http://10.20.60.18:8888/HHDI/tbDiMonitorLog/imageInfo.action?user=rizhi&pwd=123456&username=" + username + "&userid=" + userid + "==icon-baobiao,功能角色==http://10.20.60.17:8080/WebReport/ReportServer?reportlet=HXXF_HR/HR_AUTHORITY/HR_AUTHORITY.cpt&op=write&username=" + username + "&userid=" + userid + "==icon-zhaopin,权限分配==http://10.20.60.17:8080/WebReport/ReportServer?reportlet=HXXF_HR/HR_AUTHORITY/HR_AUTHORITY_ZUZHI.cpt&op=write&username=" + username + "&userid=" + userid + "==icon-yuangongruzhi</div>")]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="7" r="0">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(StringFind($MENU, "常用报表工具") < 0, "", "<div class='newTitle'>常用报表工具==/WebReport/ReportServer?reportlet=HXXF_HR/ReportTool/Employee.cpt&username=" + username + "&userid=" + userid + "==icon-biaoge" + A5 + "" + C5 + "" + D5 + "" + E5 + "" + F5 + "" + G5 + "" + H5 + "</div>")]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsDefault="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="8" r="0">
<PrivilegeControl/>
<CellGUIAttr showAsDefault="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="9" r="0">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(StringFind($MENU, "常用报表工具") < 0, "", "<div class='newTitle'>常用报表工具==/WebReport/ReportServer?reportlet=HXXF_HR/ReportTool/Employee.cpt&username=" + username + "&userid=" + userid + "==icon-biaoge,员工花名册==/WebReport/ReportServer?reportlet=HXXF_HR/ReportTool/Employee.cpt&username=" + username + "&userid=" + userid + "==icon-renyuanhuamingce,招聘报表==/WebReport/ReportServer?reportlet=HXXF_HR/ReportTool/RecruitmentAccount.cpt&username=" + username + "&userid=" + userid + "==icon-zhaopin,入职报表==/WebReport/ReportServer?reportlet=HXXF_HR/ReportTool/EntryLedger.cpt&username=" + username + "&userid=" + userid + "==icon-yuangongruzhi,绩效报表==/WebReport/ReportServer?reportlet=HXXF_HR/ReportTool/PerformanceAccount.cpt&username=" + username + "&userid=" + userid + "==icon-yuangongjixiaobaobiao,晋升报表==/WebReport/ReportServer?reportlet=HXXF_HR/ReportTool/PromotionAccount.cpt&username=" + username + "&userid=" + userid + "==icon-shengzhi,离职报表==/WebReport/ReportServer?reportlet=HXXF_HR/ReportTool/DepartureAccount.cpt&username=" + username + "&userid=" + userid +
"==icon-shengzhi,组织报表==组织报表==/WebReport/ReportServer?reportlet=HXXF_HR/ReportTool/Group_collection.cpt&op=view&username=" + username + "&userid=" + userid +
"==icon-lizhi</div>")]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsDefault="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="10" r="0">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(StringFind($MENU, "用户权限查看") < 0, "", "<div class='newTitle'>用户权限查看==/WebReport/ReportServer?reportlet=HXXF_HR/HR_AUTHORITY/HR_AUTHORITY_RENYUANCHAKAN.cpt&op=view&username=" + username + "&userid=" + userid + "==icon-ren</div>")]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="0" r="3">
<O>
<![CDATA[员工花名册]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="3">
<O>
<![CDATA[招聘报表]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="3">
<O>
<![CDATA[入职报表]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="3">
<O>
<![CDATA[绩效报表]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="3">
<O>
<![CDATA[晋升报表]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="3">
<O>
<![CDATA[离职报表]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="3">
<O>
<![CDATA[组织报表]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="4">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(StringFind($STRTEMENT, "员工花名册") < 0, "", ",员工花名册==/WebReport/ReportServer?reportlet=HXXF_HR/ReportTool/Employee.cpt&username=" + username + "&userid=" + userid + "==icon-renyuanhuamingce")]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="2" r="4">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(StringFind($STRTEMENT, "招聘报表") < 0, "", ",招聘报表==/WebReport/ReportServer?reportlet=HXXF_HR/ReportTool/RecruitmentAccount.cpt&username=" + username + "&userid=" + userid + "==icon-zhaopin")]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="3" r="4">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(StringFind($STRTEMENT, "入职报表") < 0, "", ",入职报表==/WebReport/ReportServer?reportlet=HXXF_HR/ReportTool/EntryLedger.cpt&username=" + username + "&userid=" + userid + "==icon-yuangongruzhi")]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="4" r="4">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(StringFind($STRTEMENT, "绩效报表") < 0, "", ",绩效报表==/WebReport/ReportServer?reportlet=HXXF_HR/ReportTool/PerformanceAccount.cpt&username=" + username + "&userid=" + userid + "==icon-yuangongjixiaobaobiao")]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="5" r="4">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(StringFind($STRTEMENT, "晋升报表") < 0, "", ",晋升报表==/WebReport/ReportServer?reportlet=HXXF_HR/ReportTool/PromotionAccount.cpt&username=" + username + "&userid=" + userid + "==icon-shengzhi")]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="6" r="4">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(StringFind($STRTEMENT, "离职报表") < 0, "", ",离职报表==/WebReport/ReportServer?reportlet=HXXF_HR/ReportTool/DepartureAccount.cpt&username=" + username + "&userid=" + userid + "==icon-lizhi")]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="7" r="4">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(StringFind($STRTEMENT, "组织报表") < 0, "", ",组织报表==/WebReport/ReportServer?reportlet=HXXF_HR/ReportTool/Group_collection.cpt&op=view&username=" + username + "&userid=" + userid + "==icon-lizhi")]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="4">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="5">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(StringFind($STRTEMENT, "员工花名册") < 0, "", "常用报表工具==/WebReport/ReportServer?reportlet=HXXF_HR/ReportTool/Employee.cpt&username=" + username + "&userid=" + userid + "==icon-biaoge")]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="2" r="5">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(StringFind($STRTEMENT, "招聘报表") < 0, "", "常用报表工具==/WebReport/ReportServer?reportlet=HXXF_HR/ReportTool/RecruitmentAccount.cpt&username=" + username + "&userid=" + userid + "==icon-biaoge")]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="3" r="5">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(StringFind($STRTEMENT, "入职报表") < 0, "", "常用报表工具==/WebReport/ReportServer?reportlet=HXXF_HR/ReportTool/EntryLedger.cpt&username=" + username + "&userid=" + userid + "==icon-biaoge")]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="4" r="5">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(StringFind($STRTEMENT, "绩效报表") < 0, "", "常用报表工具==/WebReport/ReportServer?reportlet=HXXF_HR/ReportTool/PerformanceAccount.cpt&username=" + username + "&userid=" + userid + "==icon-biaoge")]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="5" r="5">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(StringFind($STRTEMENT, "晋升报表") < 0, "", "常用报表工具==/WebReport/ReportServer?reportlet=HXXF_HR/ReportTool/PromotionAccount.cpt&username=" + username + "&userid=" + userid + "==icon-biaoge")]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="6" r="5">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(StringFind($STRTEMENT, "离职报表") < 0, "", "常用报表工具==/WebReport/ReportServer?reportlet=HXXF_HR/ReportTool/DepartureAccount.cpt&username=" + username + "&userid=" + userid + "==icon-biaoge")]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="7" r="5">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(len(A6) <> 0, A6, if(len(C6) <> 0, C6, if(len(D6) <> 0, D6, if(len(E6) <> 0, E6, if(len(F6) <> 0, F6, G6)))))]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="5">
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="8">
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
<TemplateID TemplateID="5296d50a-a1b6-44ff-959e-77181d308b2e"/>
</Form>
