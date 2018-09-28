<?xml version="1.0" encoding="UTF-8"?>
<Form xmlVersion="20170720" releaseVersion="9.0.0">
<TableDataMap>
<TableData name="ds1" class="com.fr.data.impl.DBTableData">
<Parameters/>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[oracle_test]]></DatabaseName>
</Connection>
<Query>
<![CDATA[select * from dim_org]]></Query>
</TableData>
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
<![CDATA[ds1]]></originalTableDataName>
</TableData>
<TableData name="ds2" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="dept"/>
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
<![CDATA[select * from dim_org where org_id ='${dept}']]></Query>
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
<NorthAttr/>
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
<InnerWidget class="com.fr.form.parameter.FormSubmitButton">
<WidgetName name="formSubmit0"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Text>
<![CDATA[查询]]></Text>
<Hotkeys>
<![CDATA[enter]]></Hotkeys>
</InnerWidget>
<BoundsAttr x="615" y="20" width="80" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TreeComboBoxEditor">
<Listener event="afterinit">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[var wiget= this.options.form.getWidgetByName("dept");
var deptcode=wiget.getValue();
var sql=" select org_name from dim_org where org_id ='"+deptcode+"'";
var  deptname=FR.remoteEvaluate('sql("oracle_test","'+sql+'",1,1)');
wiget.setText(deptname) ;]]></Content>
</JavaScript>
</Listener>
<Listener event="click">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[var wiget= this.options.form.getWidgetByName("dept");
var deptcode=wiget.getValue();
alert(deptcode);
var sql=" select org_name from dim_org where org_id ='"+deptcode+"'";
alert (sql);

var  deptname=FR.remoteEvaluate('sql("oracle_test","'+sql+'",1,1)');
alert(deptname);
wiget.setText(deptname) ;]]></Content>
</JavaScript>
</Listener>
<WidgetName name="dept"/>
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
<O>
<![CDATA[]]></O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="83" y="20" width="219" height="21"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="dept"/>
<Widget widgetName="formSubmit0"/>
</MobileWidgetList>
<Display display="true"/>
<DelayDisplayContent delay="true"/>
<UseParamsTemplate use="true"/>
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
<![CDATA[723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,11696700,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O>
<![CDATA[ORG_ID]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="0" s="0">
<O t="DSColumn">
<Attributes dsName="ds2" columnName="ORG_ID"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="1" s="0">
<O>
<![CDATA[FATHER_ID]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1" s="0">
<O t="DSColumn">
<Attributes dsName="ds2" columnName="FATHER_ID"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="2" s="0">
<O>
<![CDATA[ORG_NAME]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="2" s="0">
<O t="DSColumn">
<Attributes dsName="ds2" columnName="ORG_NAME"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="3" s="0">
<O>
<![CDATA[ORG_SNAME]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="3" s="0">
<O t="DSColumn">
<Attributes dsName="ds2" columnName="ORG_SNAME"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="4" s="0">
<O>
<![CDATA[ORG_EN_NAME]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="4" s="0">
<O t="DSColumn">
<Attributes dsName="ds2" columnName="ORG_EN_NAME"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="5" s="0">
<O>
<![CDATA[ORG_LEVEL]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="5" s="0">
<O t="DSColumn">
<Attributes dsName="ds2" columnName="ORG_LEVEL"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="6" s="0">
<O>
<![CDATA[ORDER_KEY]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="6" s="0">
<O t="DSColumn">
<Attributes dsName="ds2" columnName="ORDER_KEY"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="7" s="0">
<O>
<![CDATA[ORG_TYPE_ID]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="7" s="0">
<O t="DSColumn">
<Attributes dsName="ds2" columnName="ORG_TYPE_ID"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="8" s="0">
<O>
<![CDATA[ORG_TYPE]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="8" s="0">
<O t="DSColumn">
<Attributes dsName="ds2" columnName="ORG_TYPE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="9" s="0">
<O>
<![CDATA[ORG_CLASSIFY_ID]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="9" s="0">
<O t="DSColumn">
<Attributes dsName="ds2" columnName="ORG_CLASSIFY_ID"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="10" s="0">
<O>
<![CDATA[ORG_CLASSIFY]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="10" s="0">
<O t="DSColumn">
<Attributes dsName="ds2" columnName="ORG_CLASSIFY"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="11" s="0">
<O>
<![CDATA[LONGITUDE]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="11" s="0">
<O t="DSColumn">
<Attributes dsName="ds2" columnName="LONGITUDE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="12" s="0">
<O>
<![CDATA[LATITUDE]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="12" s="0">
<O t="DSColumn">
<Attributes dsName="ds2" columnName="LATITUDE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="13" s="0">
<O>
<![CDATA[ORG_SRC_CODE]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="13" s="0">
<O t="DSColumn">
<Attributes dsName="ds2" columnName="ORG_SRC_CODE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="14" s="0">
<O>
<![CDATA[START_DATE]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="14" s="0">
<O t="DSColumn">
<Attributes dsName="ds2" columnName="START_DATE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="15" s="0">
<O>
<![CDATA[END_DATE]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="15" s="0">
<O t="DSColumn">
<Attributes dsName="ds2" columnName="END_DATE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="16" s="0">
<O>
<![CDATA[START_FLAG]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="16" s="0">
<O t="DSColumn">
<Attributes dsName="ds2" columnName="START_FLAG"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="17" s="0">
<O>
<![CDATA[ORG_AREA_ID]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="17" s="0">
<O t="DSColumn">
<Attributes dsName="ds2" columnName="ORG_AREA_ID"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="18" s="0">
<O>
<![CDATA[ORG_AREA]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="18" s="0">
<O t="DSColumn">
<Attributes dsName="ds2" columnName="ORG_AREA"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="19" s="0">
<O>
<![CDATA[ORG_CY]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="19" s="0">
<O t="DSColumn">
<Attributes dsName="ds2" columnName="ORG_CY"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="20" s="0">
<O>
<![CDATA[ORG_CODE]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="20" s="0">
<O t="DSColumn">
<Attributes dsName="ds2" columnName="ORG_CODE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="21" s="0">
<O>
<![CDATA[ORG_SFXS]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="21" s="0">
<O t="DSColumn">
<Attributes dsName="ds2" columnName="ORG_SFXS"/>
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
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Top style="1"/>
<Bottom style="1"/>
<Left style="1"/>
<Right style="1"/>
</Border>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<IM>
<![CDATA[m<j1Ae8,).Ei=Ug-^&:gM@-&sP$N2kaI3fSR3Z>#ZL=?Y6^^cj=L1Cfp?[_VR`$%I#(s06$,
^._)!:W(V*Xj(TC]A\`kII5Jom6JXleBW@fCsVtn'Cn0r`l)ApJ5(3eQj^2=gi2%[S'on2na(
_(`Bf"gFfjs)7[O9H1dM@gJ%FmIlj_")*cfLR%N)/QJN^1=e73J-smV(f/sc\0QP:a55m6SE
HDPaVq5(SCOG;f[<!/W?nuIH-Od;I69eG`RerlE]A\f+6i<XqU$DhlKEFjEa3r+>di-^8\lCf
(T?%HC,?AU_(US9!C=-h'"&0nOB;[RqP8eSNOS(j&jh<%4l42\ZLg!q0b$7'!c\cKq_-;28\
]AaH!Ui=/!g/F^Bi2[1"QW]AiCoY[_8W(`@EV@roHc!/P#0bp^hM)oH!tIG?acK'7\m7P\am#j
Gmc@*:<(C9W)?2cJENOrF67"u`kt?5Z^K),uDu=ah[=W9d=M>`q`Y;ScB$%UXUEG?!Xo2AK%
o:49uC8Ab1p\G.5Bc&Pq'P0mD=iCT8\g;]AF:HfDogjG-_oQ)#:cHipEspitW3nMm.*W=+)kO
+'rP367-'R5:TPhh+(K7[LGVjW.B+-MJVaP^uE5hRe,Ki)35/XE0kq*A_ValP$q!ED)*teid
AP5q\:6Yn@32ZaAV^eQ>".$]AtDKQe<$"UE3VoB:Fe`?PEg[=GOPBF,GB.kdXjmiO,<"Cj+#I
EBu2@4.isf4cs?^e30`%gu=ZJmZQCG$qLo#6uF@Z$@!g?LQd<de\7\>.fh"q$NlUsQa,=A*p
ZXA=4O^Q>46%#[]Ap0Td"]AiBIGn(*LpQcn%p$J5bi1g(s+E5"EE$n5n20=^U:V03J25pC8L,R
hlI'=TQYHSRh>HOu--!Hf@?cZGUU,GJr@dHl<"cRB!9'i<X<AL&o"^d4(Osc<HH/)h*i\d.6
V^K]Api)B;I(tU-3Dc>6=M>i!Oq%1HrL:Q;mh>]A3\khJ4N.3.@!KUNJS[p@<>Q=TeWuI$mq&p
/K>)'O0.GFW>-oE.ES_>>;&sfmfA&m@W!Na$g8O=O&E=%1d`5$mdPKRg!nEicO]ARc(k3s9s/
%.F*=.KrP[6edQ)4N\%(f-PiFNh_#`I]AE,%k#$/FC8D'7'fibQf8dDN@I8)d+g@^\6>5C"O!
h!A$sG]A/RJ2_bJ[XT\cO_;m)2T+<2t*qVT^>=KOX$:<;tVlQ/?9S7447!V\HTt-*EQZ[hPGp
*`FVR*M^IHK(/slJc+XWeF:BMSn((cVfr*^MKulopI@lZc_;:,bQ*T#4iknf::WqY3?fd%U#
*I#,:0`$,BrOPZfq=jc[kUo-Y17KoIK*+k?gLDacRdnLLfkdjm?s-cN9es8H3%JC/u6?K4mG
%Tr7@%tq!4`oYe!$jfm_-aNR6r0fD`^CgOi7ii^BaSZ/,Q(A&l\=ckfLaj2AFp-es*@(@;b$
A8B9`p+/U<E$#?M*HD1Ifb_\ET=>sMDhL)&NnPt>M.t&o;nPDCE:@LH0dr-ek$.2Q>l3Q(Q8
c[q4V,H:W,8%bXdOs<Yf!WOp5PNdjB3;Y%%b:>l!6Q;FDHrTme"LUQN"IOV'glDEA#,Z5#:'
Pr;EI5W+u6D58BSi?TLH&h2O=@`<O0B&+qDb&Y.9s([_J6H7?8-<OcrB-89L.l,d-am/Eij,
no,+$b&ts[b_r0SOkF?:ENuNqIP.f'(B1<Xg+'o-JgJ/':Q6h02WTh;Aq6f20HA;J"*)mesh
o)mX2.;2PUr(fRLXmK5/0i=qBrC6if37E%Q*PB`#U0@KUDIDBu6N2iQ4+D2Z+!^LK4q9)+HS
4[f$(\rK'6AMX-h>sK$NCfk/O5!*&m.mn';ZqU=@i_UbO,J!sb/8/<HiVTQjlhaO)Md&-@_=
us2P/0hOaGZBSWj6mDMpMY5E5O-LR!Ibf7egoKbSBiKZ6Esci?HZY_CuAm5MF_mFKi1'rp("
GNFc=Rq6Ko9+TQ1B;W",;mA'V7BY+Ys<WQG%\?p1H0RE,1?-+,QQiAC+@SeQQ%B=`d\tQ%QT
+WV3#g[S1Nk+AZV%U(Kq=kBMK4;NjV5TZZdmT,Qgi#!hVK"iY$+)a<GA5*9"45fhrJjUaM)'
NBqR:e]Ac]Aal1#K8dA"/qbi9ekpl>?pg@l8J/Er^H>#A;Iq6ZHP)A5reG/3EG:Egr\m.nZoB/
G='`WUBRuf;F=/!Hdn#F\8SH5==,K:5E]A$h\Oqt:j]Apq2LP729IMfe/kYbt<A*k^%%%.g\&,
T?j08ie?Nc!^qX<1>@\XXlU)X`\T0PXM\M9-&K'\_I01,]A#FC@]AUskpNr*'$+ue`K"?Lgoe'
R?s!I#h5#%LTC:1sG*`KuMCU!%19CIt\1#"VXkH9D:5U&LVm\oH(WMjini`9s#??[g?(KdW6
JA"kdJg$Z<4/>PnlADS=j0F4YbCB:hE0?>Le^.R`_*NC,FKtgDX7GN0Lr!PHt"qiWcR;l*Eb
Lud4TM%$)XH&W&$CGi0X,=@dhPq;t-`3(;ra;R<AN,5$BgE@'k$_16m3!fYfLCgGA:4ND:Y_
lT+i8]A5>,RV&<L?g+e'fIUX/&/4\i0S+#OK*l6rW5kE"-B.UQk<T^Q5.\V-=OO1gmc$(W.+1
)lt(JacT@dC/B[91if@#7cY!:EI8akg*^1d<\[+(Rlu&QFb-3AWY\51CJGki!=Znj5h4#pb-
?AjLZ8R%,>S8!F7)k/XeB6+Q]A&?oP1EnlQ-NK!1Ngi-0^5TDCHl)Gu<Bi%*S&c(3mMB.+.,b
,:K?-"SMPeE!)1+gVoG1DrmC,KidAFPL*up!PK2ADbL#[k_4)p'oIRJm+i(a+fP,F6"+LkNf
q#KFL#MJG[5Q^.Y?uo3`UORA?,rH'LmlQ\q99:CH)@OFXp,'DVP&8chW+8h&2cYNk)SDbGYE
AqV[5kBt/$AG40oi)oYZL#\)?Xp;CA!d`pgh9`'Uoh?E;H,sDuU@lfRJNXkQ=f'Q:.)Rm\Q$
g2Ek$`)_ADBinj)Y$`P5',h8H3BLp]A[8lcVta2J18FIEqaTLRs<8p7!@)&2Em)Q#f[<^Vet:
,,PIfrrh8\DgreQ#CV--OQ(;_(lZ4gQs1,FnN>DumEQ7M(rRL$)=S@H_dMTD-?4IbbH%S!g(
.>jZ*u:_]Aa6P%f9HM3f3_;MBb'HD?-p);_Y-=h"p5TcD!NrF-Fbm`9b;%%Po'BG=/"kWPERK
dZks+W7F[b)Uf<<a4QduJD#EL&r<.gkjU8(Imk>JcN+5a'!FSFq1b>9XsBrWbRMGrG`\h]AD]A
F(?,#Q<@]Ab3Y`2srPD/1q*U@*Q@\?0b'D#_0GH=G&#gA!(pM4X\8'V*=F@7RA>>QdK41o3CN
KLW_PsXWQ%]AE(0P@H;$tB"dWU;r'Et`dkFfn/:<G:'-RP)^l[<Pg$"bA./O9C&G_YsNlkNJR
Spuln<$H;1k=46?^qbogtcc-hK_)p<ap;=r..@fNH-W]A*6Tq7(+A-?-6FL%nAd,-pKM+WJ-=
.Lt_6u:VQN!'<F>>#ucR\T]A.)#e;M?3-[uS3OnKWKdS2M[XV1%j>36_)el9BFY3`aAG:i]ArI
M)Qe9?4no5*(S*t*]A6.kW&K9P'F^XFRE>7ugCf<5,(pY(LFdbEn-Tu7"]AX_Y/`4UZ-a:0gOs
.Fu)l-=2mg<dK11Uu3Z4NiC%C:0d]AnoE+u.ZRdusQ0,_i$gl6)0UD?-2JjH5i(j+_2(COl<0
=PHSoM3Z5a[;2nEY:Wi<6%U6&ZP"Bi"W2]AYmKE?\+]AOoe`O7!).`DXXe3<e(U=:2OLHa\Y-F
"C&^<d2PAqU?pTjbj0f7p6gsmB;SLo^XG#u.5Mt6!A3dpgIUh9H,loIrcGpjO6CA<f7lYPen
EpiQ&j*E+SCrlQ)!k[70K;&JHSo%<$)&tH;_cb,_<a7=@?@jK-0"'C*SE$X-8u!t-VI@(DJh
jjUfC`LK2j,GmhB/g^4(OGLtDXs#2^"JNf0M%s2@L5(#0&L8^`RM';-UlS:;KL[79j!>^:^#
`"dZBGM#iJ0G@)*!cStL?#1%f!^psgPOQ3:#u$PIq5FN1lPhFI-e??_a7i6=61AYP8dc"PB<
i;5++ZEh^u/(!?fGbs@K+d?4:d2!7(p)M3RtekqA9J@@+u7qmo3clD)[p%IBOdKCPo?]AOoB'
SB.bO^MLgr'<f"03[`n2oDJ4Tkm$+D#(jkTXrK-AF^>ERFq^I]A/DQ__c:.OK'"%k(i#>@k24
^V!0CU/-FmX^&9Nk7VOMT]AHI!WmkD+<QasoCEau&6l1(a/%S?Jm8nf0Hsuo1i3W(5G#O"YsJ
=Alj^96=l.XcO'"K--R^8+]AFQYXX1CI>E5c)i3l>r55iD!8T+cNjrGTgp-re]AAB3Bj'i^>hA
g`Y)9S\A`*h-o@K!aNB/*OJ=_)\=t#/$q,#(gFRPkW7\N'5GnU@MAU4VWirne'ko@'DLsFH*
`:P6((F^JSjnJC1B&Sp`acSAW9G;kVL<'\g6AZ7=3%^<E0gfISQA=NB'AX^76Oc7K^GLXT5:
\WjiR)qR"-i0VS9MMV3G3Uhc&.GcL='Kap%#CGXsE'C,6=5H<F",#55uaSAJd5&[JH'p>YdD
*$6.rqj$7=d2[iB[mUlFkS.p8mub=oA*!%%fULi3%n.%ouL+\TK/GheJp;-)29-g0kPf*ajc
DBC&"s]AANVR:kj2Miq+gkF7s2:Q2O+M-S`"YGOmC/T(9I@Fa>r8&4gOF5^!h(l>,*g$&K_*G
2:.cDmMa^Ne.X$t6!mC96AB\.?-$F2O40JU2c_X[0$J4JBe<-P7=s`m:`*@:5g+R@&Tess@D
:Z-\4nO2iAAbD)-5':7Wk\mVgPYJQan0/6R\VM.V84f5L55a^DSQ\+([;sk1$ZHplJSrgYVk
(qZ&drS[eEJQd:(1\YH>[2QZ(A6dRVV(qIo`3:cXHUT^l&"cme"]AuoG;j.5GNA,TGc(6qlH\
kF>Q53&<>c"Xda*_f9K(u@c^R!b[gV[@E0'bWX%O20-76nTm:"Y[>/+8:R5(c9O0ffrkUSB)
(P4V+In`219P8l!%X<ljj9.6U\93"JN!<PLgFS@T,9;FKL^OqlQ&Yp37Ul!!rmO5_]Aq>T*r8
<QD3HJd1*J46G`EgqR9OKhs7kNG&[Yd[Gb1F$3("i,=J0.-IqH4%:-g1LJdFn%&MQDZG@S@L
LM*]A%JZ<<_TR0YJlWq@f[[1NN5qcL=@enTB[I+_$2Qh+HpbXdL%*@^+B9'F,8$_VrRkH%R<?
7%]AV$#,M\cOW)>7f%/EIds.gH++5^FGT.(BqVI[gKFC@`7JOrtKlR?_/m.'?rpZr!`d3+.c#
pH0!_t3,S3q6\_;QI8:CL=4X,`L6dp_1uI,mLp>`9-4."RhP`q+#&MMScU+AX.e8[eDr=e$2
KD['R$:RNYS+oKDG\`#\%BkWZ/i:q/c#m<Hgil"-%D=jkN#N_8LI1b(H=`+OcbP$HE8+.5Bn
/1TL%8AnYn%MWCa[bgF%+7naL]A%gDAdNu:>3God?>)Aj'DI.'0Lp9JVL"GW\>1?`'ScOKJ4;
VA856WbZdQck/k65IW$^unH6BXc2oK)2TVF;LKiY/(;VM>A&9QM[`a*i!mIK0fOI`Mc]AYbL:
sgo.dRD74h*VSUrM1]AEX-EC6J*1.Mn3)pPWQgd(4sk[\7b*[5BOn9i2O<8\F9Zf5;+g%WMW7
V?./o'LJX&oJ_8YD!MTM[S[c]Apc#VE9#;=1K-;Cmim')DfdFOm)'f3:.JGu1j!?l>UTM=a;j
R7%ZOUus4F4./lV.cOnfr4K,&GhQp,]A3Xi?B[YkfZC//YE:<:lP2,n44H2>U$f,T7ub?lWol
dqg\)_#AMBG`K*)V0-t$mpqui$UYuDT(Tp@$[Td1VCX)h]A^k]A2"OI'/)HE*+q=/;+=2O8F5W
f'o#@WC7cfTF2=8FQu,EZmK-XN!QR[m)A=cJM'Q#&&k<B9p?0]AJK[Wu),nG#g5Xo5XbaYu-'
2/Omt]AjeXYleV%#gp"MB6M$p?:gO2@FKm::.DE]A2Ir=.[25/G3tennsK43M8GImMA(>4rOuP
PifaB3lfrfeKJqI`Bnp);*NhZ4FA:n[s<?"0XSP`76*a0<^E\5q`uPQCG-tB=ip\?j=bJ3),
K?QrHMj<K)Fkm<A+(\tQ,[GM6YE!TCg6!Z)$W!R1LX30<,34%?d/<?mMqKY#&!8/$:BfgP+l
J49_BH>o]A]A5[\hs'LC#<)FHVuHT&,VH!EK"ftaC_QBh:A6h[p0@be\a/INnIa%gp-W2F.U8p
"]A%@FqT6*FL0CR-K=.&/1+?NOR!lqrRReKd!Rke2#1,Z#8;(Wl7#*@Q(:^f9jM1hEERak[>B
ohPb,,"hD%t$Q_8V[p;;.9Au[KJ6$@Fo9%CGd`RrH5l2%?GQ]A?Ga9lF\T%Isfolad;94/o%S
T6?o#/Yl@:L;cF';l9kH.FF3_pPN'S=]A_aS$cc(d`pEgq5thfV0>m:=3ohBjs]A1-a&Jrh7q_
Vt*W]Ao2Fjq9^h[h:ppN:$IB`=0dmOt#j6i@WPU(Q?C2NZWM/I-SA\!Z'^PPBig&\qI/pBrdG
1"`!$WD?<G(M?\-.Or+>&WQ[??V\CQL%HKN9E?2QTX>-UophJ:gU/n+0Xkd&\@3<,mYurdcW
Si/As'\qWAJg*m\H+QXUpUO2iHXNg72X$RCGm*V;]An6B,.)'oDt:2a#;l63X4]A%DDoks4ZE_
%jh0Y3YWcAOGbiLtHj+\qSM_M,(*@mIA?dWBIVJC_RMaoMJ[H=5s%ilQ'iAX-CjhIq`]An#+m
re\SU^B5.Y%]A,MJ,?Ad8=/Wqn>%'1^I6G"O*\h;%lht^16D:(6/!D@;@4PZjk@a:n3O5l^1I
S(c.=WK1X,kfZq=OYler<Td!W2)c!^U@o37oV`N?RB-<p3.hikn[Vf7FQ!I!>6CN+5JA;4d(
%t<929"[,I*^9`1,8?&4j(RPN,Z)0aXQ=8P'J4TIM\;k0/84,lL'W\';kakGdi<H<OS@p^5M
?iOa@X/BacabDW9V%W0unQ<5ha+idb\U.VOM8N<&+8unE^S#c\.5:A`iL/:CuX>ke]AM8;<gJ
AZC6DiQ3l0`J3[sFs.qf$Hjko:;<N)2H.]A#7fY%XAZLGs/gl5nf/\SjJo#C21mqtnd=$I3Ie
T@*?GmfHL]AM!]A0OKU'?[QCS!HT(&="jd14M$dEQ:?QprofWSK)-^I`\2c!+bB0@96L5DS1"V
%CT]AChofF?fN[#9nkiGec=n/4NmTFggoM:k2=eF'f/0l,MA1e+hV6Jd^0<>UOOhSR$7d_eX.
K9tmG6DIfa.#>P=h6WHGbnH2I_XH[:!CrbN[1fVm49P"\CWiie@nqAFNsWV4!'7fUlb9fpdW
=_aH/1)*d3rY7U(qGoHW00'MQ3I]A3b5$@atm)mZ_)iTesM2eGfJ(pELX0Ch*,C"@k":@^aj)
EQ-pn+%s@H1eV[R#I6`MHlS#K8gLC/%T$tsnIL<9>ARh1SUp1KO:(^VN9_=dBWef@Rl#RsTW
TF0fIg0tX!WEM1:Hn@Km@^6?4:R^UQoEoa.0k@Sh=jOm'pfqPm-hZI!,\'Cbe\(LUqPI(S!S
PdH$+]A_$a7F5nm)[=S*mY&9h3N6!O%?TQXfWFTkT[>56^bO1OK*SiCo+WiUP!Q;K7g1HBm="
9qc]AjVXbnt$WgU#Kk'^H]AIC7Zl+9,kRq$"6rH>:/lC-GepSip16QDE>Eiki9*-]AAd`QXt4l<
9.tnkFn/A=,fSZ3kWZOn.0K#%bPc-2O<#??4_.?V.*@oW,XBO'UtAqkZ/d\s]AbUmQK\/X%%$
!#&JK+@(X[G<>4=g(4>4BZ_UW+PL.V9')SYba$)Z]A"Xi!XMt+/J\RsKM1ZL&uQ-8i?<OfX&c
i&`1f'?fA8b^4]AH.Fe;F6CfXp4G0Xft%lD>p!8D55l5f,,Z6si_;u$:6.iQN7q_#ZV&0Ak1P
0_d9oK,JL)p?p&_F*LpN/:SN(r)g,8`5Z"K^eakWF!+F<V%3S8!H,T_6a=tbX9=*;V&FtJK(
;"+-=MD2^l@5WR8U"KL)mjDn-)D(L`0Aa_B:t>O!Od,am67L@!1X54uBFhjL;S^ef[6:\/<$
M&bg+#!o\qGf3?@#Z""m+H\eObQM\]Ab=:E2acCLS?kJ`\mj(R01p>+"rq)0rj.[H8OYp^K6W
:P(ui_Doa/tWh2@Qn5VE94?gi)cd1%G['05(na-50qIoYjm/t\+Koa^ts-Y`eT/>Gn0jir[4
X=5MfJ1JSpu)nMX^L5P-oFeDO#mk*b\b]A6psTg;gEGVSArPfSUNP/<kiuZQ!Kf/>3J)hFI&-
k,$j79G!h*]A\6d<#<aZE5<_^C+LBW?hOV;In%6i6\s'F=I!jn=OS.`6DQ6KF?2e1*ODHBDDI
o</a8)&Is!$<U7q%SH-r!V"`b-CC?jp4r,&ITV]AUf8g0C)\7GC9oB=rX^D'?3299rrSuom5a
(O)2nt-JG5p2Kg/0CD7G7*VEr*F&GXL8kDdf^"<=R[TG)gQ-5@+\\%PVH;&fbZDoupLOa:He
dd>&+%gtcenP9:D:p2?57/--g#B#8Y>&o"i`L+t]AobTN73BZM&$md+g%G^iegr-U"sqCE<2e
hH?:YY&!P(,*;tg>U6CZ[67DmU4l`NA[++G-dEF5>R^4nE=l;cSEP.n-=3Qei4u%;2k)+F33
D*jVP8W6"Y$RQW"/!pL^%@<[UF'X`@-P3_b`*0PSp*km_o=)s6(&@\QqHR(A&j'+-rTc0Od3
HRbPK;fBSQG43r9KQ^IGl!<1=5gGNnQr"&M5gTj^d;iO\<a4A:>5ik_NgB]A_+>g)V%VA=F@N
IO-lVZ2MMM%9abtN9*,/BJ8d$T5`XF:dt924#ESD%r#KG,ibTk1n4+C_+>BIfCO;X>h3;DFX
-Sgl'c!lCg<AL2f@0QIk\W]A'(8AZpFE^Rf>^]A^fAag!$'J]ANmHc4M43aN$u$F/OAHGaFIN3B
P[!HCDXe&;C%IFo.&dSNc*)!c[SPIhsW!9Qr&6&8ten/UPsH!icW?SWu7ceOo)s*:fe8n3Qt
IOZLU@5.DOc8=E[Gl[D$tt8m2dZp`U'__P`6-*0S9$T)dX0b;;9T4lKr6F5KU\kTmiuiG<-g
Iaq?\%7em+r\8Pf'3hPJ6m!EK>1k9eb#k#o.<skFMI38$]Am=f_of(0i2Ire<5=jB<+@\lE[?
'bh./EZ2&K<5lY@%9u(^&9r">Qt`g0FCgD8M(!&>*+iR"kn*C>!_gcL\%E,@\-F)tlt"208P
gC;;>dq0CdVp0DV"<F7T6#2i#KTMFT;_;O#M@05Io>G5CCe?-*o#eUbNYAK["R&Jh#!iju=l
64<JcHD.ZZLSY%bl.nM\2jFp:;'*93snHT#pPZ5f:lFXmgRut$]ACU>(oa7HihuL+:/FJVj@l
:g\%m%[".,0CLY7A>nR'tK]AtY8^66*D4r.GC%Cu!iTAERllEooR59/@9N%?Qc<0i8OmN;G3Q
[6k,5))QEF":5n8#dHW<\ma!7%oL#@0&cLHlPica&>HphP&cF!9R6r\70uqPUW.UE)Ri4KQR
hiXU'OEKl">d,fr$A#h#F0DCJgIJcZ9*u<XrOncG'#3eQL3jmUllnUH.oBbnlV=p5(0i)WA#
cDlf%D`eJ]A,-_\I/:0((Bp3*!N$GP&h=V)acYHO/+cYN]A;>2HdO/BcuS4i-+DHu0R@QU[ATd
j6e(bm\a?LMQD0OLe`/e=Kd/N#\DNEB/*<)?'ngkLl5=.CL@S6#4uP>SJ7G2q<GO^j[=@fd&
PH$QjR/7cD*]AlN[&.kuo@YOmFqt5tCFX+XnI$(JS/_LLHK--=QEKYsCQGj!UZ%SG5+Z=P;6q
L4^STC.B8]AV[[bDM6-gVpg?5AJZoi)`2m3GR^J;o/a;eNrAJkZN,2AEel`"?)"^XYK\#[n6Y
FJ?:i.9BU'%n<DPu.-_AgeTajS<-N;/G<@@o2)1oPYf9oTBcCT]Ahj3UH4tNciGo)q(f0g-4G
M*mtbOSK_to+C'.1omV"kN9ZmWg(s5DYrIF7V%o@HK/9#soc-<RIe-LOTAoTir^@Q)oQ]Aotq
]A)5j6U%I6bS(4NbGd&V(JP+C)GTmM7$Zd@4DXkm6*dU\2u(7`4?qpB\+8Y6L$9RD%Uq':>e*
97T^PZJ3lW*5"*e&>8NBqjYC;B$MapDV=cA`;/UB6<3AGDuS3CQ3UakkF'.]ACu)aA;"m05NH
(R)Sjc0Xots1?PBI47We^j'm8nPHe]Aj]A/J]A1(C5).J!6)&%oE7]A$%So\Dtumg0]AQ759O34Oq
3n\(q,`nfN3;H^GoWTM6BN&qu[UBM]AdrR]Ans&[W>k3-d3h3JI>7GRY([4lp._7?l.)u2_RA[
3LPd*oTgGDX`5_<BoZ)pr`eTS<"BLa^eqh!oVNBknPuU;#"7GB>ac"mDO#.XOA7Z!Rf[VTLS
^B;[Tn5g;U?m;6?RU7DRK+jD?GX#%C-'MLpC,@jC_LdmAS:gb<A45WKMe4EjpLR+Vc(_!D!(
_BbJ79*CG+k'^(!?k)&R8a@83!GkS4XggD]A&BV1<s.\<^f[1\05PpfR.Q`ra9"KoHSP3e+s,
pjuTuBODst&]AD%[G_0uX"MqI?KG@Nd<'sKO-5YZW`MiA>1eqZ(Be1Q\Vg)ICg!uqO$Hs@A38
q$#p3fNJV9cD`'[1p2=R3?TIn&m=A*R1qq9".r#d3BJ4D=W!hf3S8d8=l`a-r[V"jKLK<4-2
`>[)U#r(im9,Zt]AXoAW2Da@=hs"$\&R7UBQ=61L(G\,Adu^*B=-LI5C\QoofMJH*Y5Te!Uu,
PEj":$@HV*;>/m;S+:_J._aOXKoFEWWDJPGI9nl:.DKP+=]Aj38l\JR=Wa<IQuifbePE7X]AKT
rpauNP"0N+Qr>A7KF=amhZ&SRQX*V2F@e,]Alb5<Su10ppU4Fs/d-nn!YI%k;5OV<"-WnWbc'
%K3,En.1h9AP/Sdn=MgiF31%0iP%-2M$&fj6cRB5rb3:a<C<rB,aCdTE-_K<@MSi>d>jVY2B
]AJUE6!Dkl6j<>4:si)aW_mL68O!f+k^3Inc*bQfdBaAmN4JQd_"OkgqHC'l?;@4Bq<5>NO:9
<5`^UjUFV1]AbjW=rNro4pBS(X]A2G]A;;JFqp%R;SIA[L^L2TsdW)kOffIo:%$dS%OMT^B>r68
=NLK<LDsl.YDX34$dL#?$Jd<SC/d./LoIhpmY@rV;$,p8ji7SWqsa*-@XN`o-J&.6c]Ahq`K:
n6lWFb(&&.q[j,'qo(Lc5f5e#(%OkHfe*P!K1'LJC>b'^2`;H5g`J:Hmm*a89JoV;qGIVB<L
ap1\CD9JtRLHI-sVZ/6+fVXtlDd3B9n651%PZP56.3phY1tE-HUK<@4I<RtG;D&c\\Y-(fga
i<.Fhq#JQA;IAc4U1OTCZD:Dp:ckJTB65)Rd!:?Lh6B`L(6_ZIKF$>aTBEQnFDB\%sa*^4D+
P]AQ2R">G!c["t&gdlWe5)(:BI4kq^4MD5p]AX0+T>AEST`J=/)A*B>(M"iaiA']AVM"s0Ihien
a<"]AH`(Q?8/ub7;N,#,/_T?.0F0=qrj0_fUOY?VQ`docn^Bt]Ant"K,8Sq**`LD#s\YpgFnBA
S`d^3\9%f!c>Q<Mm-qM-k[^%[Q_`o<dR!A#jY@:S>T>0/3C%G7RA[Cr,-gh]AYai2DZVI!"b]A
Ypnud-aMDO<j"8&nS19OJFa/6lu2Fu]A<T3`O*Y+KYg\pe?8<VW4qRV/i\SJ.(QPY_W@kp_k^
68+c>SWh`Ca$%Jl8+jMB3IA?(Iutd.Kl`MG<]A$?UF,8Og6J345[;EZ;BDk!?Y(Jf9$O)Yp'O
SS+=t<TP%%q'/D(\__^B'YJ4iA]A-dFDHeW\alJ[t^BOngOrr6X=H<nhN0t2Y92gJ?<T'<klE
;Cli)CNK]A!%l*%&l9d[2l%14'="Wm@t&1RnXumuWp)i59FN,<>W"hl-7tu[ORFR,EQ+2a4)S
+VE[-J^n'2jg`qI$9ef!4:_l4d0ee:g%50M;kom0^O-8t(iDM\NipQUlVSa.d\aD0D+XLj=,
>A\cq1'F=?-$Mnp[FKgXqXrJC\30\h@-e%o(=%RoYC"(&5"/31j>#kD8kDeW.Q2KeKG)!l1>
1:49<:KPknd?4=1$T#!dVTCqJf%\RWE/:ZBq\J."7XMG!(@C7dB/T.4"M;JJ\tp,0iQ0%B4[
!A@tq/Y6>4h%DJ0"H?8GYNSaWUTa1Q=,Mu^OrA!o@#d^7j0\<WSH.Bd_*VL(jJo=gp%-MGP8
2T(D,$NuAES*rR+ZILI>Aq&,f7:!]Ap0?H<^n<\YMNFH9DR;U9<'M9Ig^rJ7Eb#@T]A6E6)NG)
%@lY!TE?J3ejaQ4A@l?qW6?SZ_NNXb:R[2lAuQ7"p"FgZDF%5rNMTp/P1MQ=qZW/p&6lY,NF
#D?=f0&BUeoeC0;o8QV-rTZa*Xpd)jh6^GXjG*<W>cN']A:5m%783i4<gp^[i?eTGN^dV#97[
Dti7,K@#M4@-XIPUf&`:IM1ZFV4YBnAhLP9&_+gaE#Bk68)V:Vmf#.r]A"Og/j4r&$1qY2AJ5
/RI_Li)8DPr)aK4Z:X)J]AcF!QRbeZ\b:XJjIN5W,2)O\iS^\i:Yn6Kj,+8!i5GdMk[cI^Ws,
aHOf@DDugVl1NarT9-%d:&(IdS'X?i7Z+3H0rBebXW6g5*$..?Y[T/`_Z!\(d@uNJ,+AFlWF
7G/4m'-q`20P0=lGS9Y`[(f:.^M)Fl>*6/dpSasoGU=Og\rPmSD\aPSoYpAcI.f`qp6nO=:(
f%GYu6+oWooAEKA:70@Vd6FMf7$WTSpp"B7\O9E@2>ER$LQm3LXGqpX6;A,6!ecRcPF/3p(-
7QKYR6/ogl&\?oQtYhU"U1GMGc1S$408WD[a<#(:s.baI-8c0m.a;&=#PafY@71pf)-s=,_O
m0Ca>KcW2YN&FaL9n>Hn9g'N_c1A+a+*;@S4.Z>I6>+2EH#]ARboed!I/iYXk2/F$Wjpf$*^:
$nntSVipK/84$9-UXHdNSs9=""4ls;3=mLH;2%P@UNTPF$T8Z>tr"W0)$67rW##eTiMi?qkH
M?4[)>5>%#[S792q-Lt2*OCIFfa;l4VPG/]A!;2"YF"QEWRt1O2s9>FFN"<%/TY>(q+Irbsi_
IAMTpG:0-M*pWn2o)fcF#@2b"@hMnI>H*nTM8,/&K]ATX3[LP2QBh$JG((OW7:+!<ir/jT.GB
T2%;Zb]AfKdZ/=+4#I87?!G%F7hQG`M/>f.:lXREa#lp4VkE9SsUe!56ZrMDJIhrU\21=9n_6
gS,-5pO!k"f$45]A3gj\<c$pMs#gqLLGG"i+W(LZdhK?stqZG89q-K9fTl-%@dR:mg&hbSk,j
2V<l",+F8hc?P<KF@Q,9ItUr=N2Rk:r-`)'7+>J+5UoIVVNZ#L4dq!i`.W*$Oms+YYXWVq[6
n[5B"np1sjI-?H0d*eZJ#4leD%1?DEQe&N=ElS:P`]Ad)J)nOSe6k+*)j!RBPV%b]AX7g(&=[D
F$s()d2**Q[$!RhFF@Y8\gk[dGr$S4KXC+3=O?>0it[48`U]AiZ&+3S?s+4l8TN,C:FTc['dm
M#1.DlK"df)DcZhr[3@6$IDJO;N=8fD*qk!ubtF89T.M'4MC'k?`i4?VB=ku7S):_7,s']AYf
E?e[6-06_kc6V]A1"#DaC<`1'p#ROfPHo!@f2QJPH.K9&DjE@;OSVru:^b6f[Wr:X2Qj>,d(4
DV?$$4Xb<K^h#pfY^R0IYE3el[%Tq@K::d51`QCJ3JNAeTrmrQMH6.(+qkR5tNLOoaR_J6Db
m>'D%;sG]A$t9>.JjN_%p;GNB"&2d1GmGeJ$Y;qJeu$eKRCdGBuSZ./]A*n[-%:S43iWC'0`$\
3&Q'3R9NO9\ZBm4A>13=]A7dp`*%D,]AN>0rf<1SYB@.$D'7G%q;VJNWu2,lGJOQ4G'#']AU:oZ
K#YNg+<I7n&8j\`UgJX^&8CG#99bMO*Fm/Dt!<WRp&rP[_]AD1hu]ADVT7#'C_-fRFo/9dPdJ+
E]A6@l"HNqT,BV6qa=68@*cJaA^qS$>s^e/nb_r#]A<1q"]A.mWt&kLk&h^m;-IkRXSB>9:@WP*
"<*4#tna";7qtIgrIo%FK5AhE67K8&Js'J>\TL3R:=>+Nu($ql[JU4(0&o!3;(5.pW7G^Y#:
uC(QO<TEe'g<m_h-0q%_@X/Xi9Q0*&#<EWndoPErKrp;[[7*(H7>.5)u)S"hX\OEkXT@HC'R
00aU^MZTM*#ReuKT_19=m+-K,2s5f?n"0WpfFXEg0W(q@W*"urpIDQgl"h2DMU>Yc;@3*[:m
K88aMc7@l7H[t:2e+"-d\a(8NPEEHVG_hrk?t]AIZ/B(rP*?2[$loq`4e/4j_D!l#R5nlAIn[
;%?#&Dhd8[K]A^0.+Xr)d4P:Sc@F*73YT%(4M]AeYI!="gA&+PDV<3IAADT$;VA]AE(COROAS,+
SN=;-;&2L+\$Ar2Y"bh,bZk,@IX6rI]AXXT2[TT(W,XMQ!XhVD>&/*2D[jCL/Sj;%Da"o/<.p
_7h[Z(24mH(*F8o/+Yisn(YPrii@2?Y\RjSHu]AFp`@l]A*;uiksJnQDn.[cj@)$G.%`lXkTRU
"6YKH6q$8W/M:^b3.=7<5]A!@(dP(9.S3<_?h7XIM'tNpZ1qC6f6b,;3_PR=E17#t/+N*k#94
rFE[\>ef1lR,R)%8MK'I%^3cY.!?S%$:W5NA:.D[QK-FW<)`1O7Z<UffeZ6(Df4et*3B,b[5
*csu1'mY$P2L%63[>.;sN20CG3G6>cJM+YEk;b9u#@t"nCHN<a1(+h(8aSk$\Tiu`hEl.ZTo
DPE7,89pn;rUA0;oek)V"pU=b.Z&ol+k_H!.jgG#So^1n"jmJhca#`a(;E4c.b!d#F(]AW+6:
(Q"F_nG,%f1V'.,@*9auSGehV-,Y<_+->f/A[CR?\<oIl:_)0U#e$2Cn#<9`c'WRB^gVoa^Y
k26>439A:]A,$%t(USP1Y-NoVshlXJY7;D+*GPuLHXauK(T/RMZ=&A)&57UOB^1))7C1i]A=]AE
l$PlRZNaW<7(I\#aD=e?!k[LRaEg<oNhA]A'Zo-O8?gs!T9^A%6:<#5]A-b(l=mWrEoNaupB+T
eKaf\E7l]AmsWcid-H:9Su8+u:N)83RWq/;KsquEK]A4`"s*,gu<Y0"7b#3["CU4oB7NhHSh!;
Eo'k?r4pgIQdRn?_o.?X@4*'ob[Bj++IWnT?d]AoKCe@C1;5o\)368J+PgMJ:OA.t08PtP:b5
,\0Dcn?V7M"8p8F\Lok.MB\"P_jYh=b,h!D9HM''(1j\;Z3*3O)%Lh:r_]Ahl2%Pf=(oa]A,8!
pp;!G;+M_J,UL8hV+V6&'fjTUDlk^6[.hnD[&/#*c<kKfBQu[T/INjWp_@:P8L:;\E[+[TXa
f>k@h?B.8k`\GJ3_+l:RX@hU-qAa+Fe6XDTIL3nAi&-Lsc*sNm,m2Y&I0*"O_L5Ek%<A!sN7
!Z[BcaDE3sLWmIfB.4BP`R6`1Yo]AZLB=Z^7um*/)jqnY]A)JiA?i8L6kaJ']Ad5G38\-prK227
Q\]A'Tt&-bU*t)CNuftMYsEAH$<-d$b7:VZC^n1cKJ*o^D2\-2$$#I"gT`fm[hHDrc8R9$3Z$
ot.N:OT['O+c).AnkWkNKH//PhM>Q._'#*:U<(PF;?aiISc68;7bM7lnN;<2Bp=dMupJ+f^;
MXftdP0Y`F]AN[@)*=HRO_29Z;qU&ICF.)KqX7^FMcIU8+ed-ulf9sBHrTN$1YrPfa;5+%kLb
hZg?SDg::ZpTVnnA3P[dOBHe9UecoD%9FThO*8?_]A0]A5N(d&A[n$AV?H'WB!-1j>=Peuc#pO
&nm)Q^[7VNZieTkZoLLbo3=Und8N]Atej=aDi)<j*>F/Tc.8"0p'7NaS2<Kj9N]AVZ>p3+B@2`
j"&p(%9e7=n&<<dfa\LdnJl[aLV)j/W>(_@RJn>s50rM>'7-bT8T4$fWs(3(eN\*Q$DoF%1#
Fqf[<l&9&Zq'A9o,/H_gIGmAE8?7VR3TpU+%L;=^kB1G>j1n8Aft5J^n;U<9@F.nqI_4s;E\
^-7iGXTHfQ?*4%\A/[o_pX^0#6;L0P3W>uMJ<g4r"TjI/GM!kM<_&ZEm!dA!?$crDqJ=nS(K
51+FX]AD9N<?_@&n,8/!VU`"-,#5BW%I/L$C,4#G20Or8fkT-n)_S9amSH5N3/Y81:c\cF)f*
k6'Gi"s)D+-hZT5b>-lWcEIpLi<;"OMAATNjmr3M^QhZHD[FQEX2BH#g0O>L<Q39*s_$+bpB
WE.fU@a;(-5_B>BuX^U0p(He.(4(e6:"aJo5["40raH<[k-d=Z*@jn)R3dgI]A#\i2I`rgCJT
Kc#/WU70X)gIJ($.Eq]Af,'Vk>5+:ql$Zm;]AOtb#O>=%M#eR_CQ4S>)js*"C0!i'G(PsJ'^Nt
@`'1f--mT8>$i58R9GM,d9U47ZI_$kL"MsE\t+77T`(85/.K+Crr93&5R8b0`+GJffqpbi[i
FE4A(<rB^-/)>Dm2$"kl*$F2qgFm`qWZ"h,P_4Y!"k6ga!?/Zu/I+HkHK6-BK1$s&p`!XXYD
!,\;PXLH%,K^`mfn)GV=u/rKO5)(o?:=Y"MDauWL,j4t>&O8P7#UYO2?!,NOVJ(P[TW<8(>&
D:=Hd2(+SW1$WQg[cMe5>L\I0@V*Dh;n#Q&9Hm.0Y_P*X>6<bjrn>H=/m=g/?Q)Q2?/PY5?_
?f>9*H52snR%*9b!AjTnbL8;AX';,[7gNO;%s<m9roN6$]A=dk%tiB+K5i8o=HR`.\+dhJqEi
,Bj!kG.ldQ?.XCG7tIYcAP9@,opqs1N-EDa+LJlBGnY^9LUlfFf8BWPFiT2S<1L<NWmh6Z4E
'136E5#C[C@3n@$:*F!&4i*cb=P(*B*@^0Pt&KV5mtI]A^=b@Y0rT>aXRe(eJTH\Fpbb1g0aS
6O=7o0SiM`\ecC\.`_S)\#+@lKO;!d[kfF!s%fY$#QsXQB,bn\\Tq<5WSrIOqSC#*c\@e2Tc
D:;UJ";PVZtKI[^R.\L0UV+d#TkP1.c^kQ*LBQ[!*jD8R:BYkQ0CO%WpLjVf@8A60Ild*3N,
-[_@g$K\^geKV/p:jLSfurs']Aot.\fc:oIl?[\<(XJS5MC`s6D3$A-GS:!np95?hOcgNKp9%
_5D:11$8I!]A`=D1!)^2^i6"T4!Eq6nPrkV'<__[HI"c+T8?\':n'?S53>7l((NTJI+[Ag,Gr
ajIjRWiF(L]ADf?W:f''O9S8s"AR!>a8db0E+\Q[)]AJub@8E_$Pr;+5Yt&,I&-`G4"`/'R)p?
3!,cG-%kSgd;NirP6sT'Uoi^VY-,?]Amq<hFf=#tdUcXZ-]AN0Q5O-FbX5&$c[MHXc)VHa-o@\
<G7AH:PT<BeAs7;CPsod-k&XP/6`8WH"1SnIsNn[R9CI-QY66PUkL\a7+dldiDRu*[M(S4"I
,`Htdc;U0&WRC[5\\\`NQ5)\;@RRGZhsc<K-broMt\H$ruc[Ji9/Y,RiB_'SKVd`0`NFS'eq
:HK6?V_@$5S:$::$?WCq2pjU45FSo<%u*c0`/DZC,]AM.ML]AJgmYLYnm>H<21G)Xj"`Y@J>DY
2r[9JpMJ*B?A)9F@I#XO]A6Imj3C=QohFSMSIpq7)Wo>R+5s3rcGWKKnICTr.aeX'+hkp!$L7
&3*52<<paSF5KKHoe_eN+*QHhh^:i^,hYNb61O[c"BmGM!F"(9+FAPWs!:"o&Z"4c_N[`#pQ
XRbh2Y5b:EbfsV?XM3<SJK53#F:=_^@$`A,9!FDq-7jDSMK!R445C'@d&k]ASWPmO=OA[LV_,
6`elc&f*4U8C'RlB&F+*rU)Ckk.U]AXduq$t=TH-qQl^p_H,,+p2Eeu@*A$^&+e!ZS2W!*k"V
i0g(JpnlOn/Kl,-2fcNE<DPi\]Af56VXA603IcpL(>)sCHf6#8dec>F8lIODCb&4YV>(714p^
[ZNJ@L2nXrEPd&RTnP*B,+DLEGC9jp9A/gmks6n[l*JGfMcH"s2Z%+T(B>X&;3V2U+OqFPe\
jCsU0ar-6&@4uHfoCoU$AX']Ae()p>r[rTtUEobVrFm"Lg=80l"kGm0U6-%qm^Z-b!;F^%0j,
'E5UESU$DC1H%8VM1(sJ;?)[L?,-^EtM):P':qJfVcn$1:!P6:Po>&lDNoa90C=mfR>a[LEq
um(nXFg#Ld(2:Ihp[dSjfhe(TG'*&l5SOi8S9jqjTqg@HW'-iJtsTG@F'gfssV0r%!5)EgE<
j=&GqB6R%W$,@R_reMN=TPJ<ekUK\go$K*\MK(>EB4btgTU+A>4"T8[=%bY:.UGVq=n[^)Mo
RPgKPc8lo1Jo3>2gmTY.@/>#pUJd:>?iL*C,O;:>?V&F:p?Ek(m0XSqc'eF4"'o6(Vdh5#^2
@qX-7c1M-8=O!HY1ptE#nNCC,;/E-'+OYP0bogZpgR2f?o>-Uad3&\o+[dW5W#1aPOP\ojK`
K40"9M\P,ODpGV`@]Ao>nCer\h91pNk24H*"2?#:YI]A2'(VWLbdf9HmZ?0t66?u?PTg/s__6g
[[M#O0Y@CTX(3,8J>.ff$9h\E>BH2\n2nWY*_id[g$?jkdroFEDX,p%NHnSlIsJQZpC[[sKM
mPCA6W&G<thu>_t_dsK/I2j&@O*aFYZh,o4pAHa<CTMgBi#"Q8NLMkG#%XGX%=lCt!$AV\Y.
`bJem"oA>8b(qE)U($lNPNUc4u]A-XnJZRh7mk00]A(iHlb]A9H/L:9'TtLL/U&g!l(_[/9f8/T
3FsUjMQ(a0o)2dpoej:`Ods$MBTf-F&Zai;>;UAVE%YgScWVr@__"O*ugm\q6Rm3b=K=S\tK
NJU2XnpjdB=JMAZQJN307fL[^,JN-PlZMs5?DfXc=661OM(F&;jSD&gJWNd/mf?hM3q.QPOe
;X]A7d>/BSUeELt7-'L#1JD^p/=Q\-T\EB&pud'Dm,`WT=SC?[/uXC7Ij6Tk0gfeY^i$PJkBH
l8s=tV)V,)m*e/=KE#)B^EnW:U1IuVBs$,E3'Z'h?ZbABMOk\keRVbK7WYD/L5l)8eu^FNQ,
1*r<N+ECYMD*ddS<b"hW#?t*qhA(:8SrZ1681<Xh!5^ghJ)o.C<6h`'a!l<ME8L8P1-p'3L"
^RUB;d\Z`478Zo8cU-PlqM]AuOrbDZF.gsXB,cT^iP]AuBOpP#E<o]A]APt]A^Qb<L24jD;;qsuq7
[4XMNIObb7t(]AXPr6nsWW/T7!plJ/c_6SO?Mm;S!SWFa2nb@=;%NOXRs<*-=%do]AG1/1En!9
*N$=J2D'"3N$V=255DtIgepW>uA?]AVDK-\(=!["I,UQ9TAPVDaEeXl,60kq3O`pO!DRCR5)#
<[YkRGo(+A%P+f-mp@@BD-KXMi-d.pn84US^_R9uXd>m-/J!,kUT3E69aY;%JVZ)%afX#<Vj
`*n6Jm6Vc3BB>,ce[D-Mi8dm4RT:NUQ!CY2&EO4q4F?,0UD*_l`SNV*E]A1G:*IEF4/8TdXGj
:>eV5FY\EV-<d%55=p1F[pSPbS>M'u$'QG(d2u^[/W01VUAt7NO4([3%0#9JC>G(3HWk^D39
AR"`)?tWORr9#aCK&!'4:emG3_#^G%i.":C"j1uOoMb)qOM$naV.s8Or4r%[l%(VU?e`Qp7!
#4C&ZqF!3lqsLkK0dHM6BT5=SMpKbY6*FF`)U'hCRaM)]A",9'a1altVSUO/h6Hjc/Uj@Vh.\
VEnkrSi:Q1AaGc9T^GBZZ"(3ncNb,74t/tfWD1]A<J5>6Uo]A6&#?=$\Y_47Ri=^@\/]A'ADMhq
V&?r,5=UpBmo=,,":1?8n:9[Io[5UJtPT4E)k.$5Jc7TT`HdDL"KblWGs^$Pi*`*62S,9.-*
3Lrqp^l7;BlM<1]A9+6<EHO@sX#S+a*pWfl6r.mP9gr#.ijkrt2?&i@:II8OuMV:`^.r!*f!4
Q#K_bl>M"`!%#;4+_KsD5AGl\=e>U9`XFQi'VA7MI3,SCeY*E]A%H?\Rr1%?:=ao0<OQrFH7n
O!ea!-P@!X$g?.XReM=dhIhjk%Gl';2r-'&1eiV>]AK,?j4Z^hrBErnn9>0PkC/DC]AY^p^YLm
NB_^f==&41D+0>q4%a),I;A0OetiSTVd3M.lp&QWG%+$Bp5+jHG%NXphV3R1l5-gWb<C.1mf
*=~
]]></IM>
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
<![CDATA[723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,11696700,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0" s="0">
<O>
<![CDATA[ORG_ID]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="0" s="0">
<O t="DSColumn">
<Attributes dsName="ds2" columnName="ORG_ID"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="1" s="0">
<O>
<![CDATA[FATHER_ID]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1" s="0">
<O t="DSColumn">
<Attributes dsName="ds2" columnName="FATHER_ID"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="2" s="0">
<O>
<![CDATA[ORG_NAME]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="2" s="0">
<O t="DSColumn">
<Attributes dsName="ds2" columnName="ORG_NAME"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="3" s="0">
<O>
<![CDATA[ORG_SNAME]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="3" s="0">
<O t="DSColumn">
<Attributes dsName="ds2" columnName="ORG_SNAME"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="4" s="0">
<O>
<![CDATA[ORG_EN_NAME]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="4" s="0">
<O t="DSColumn">
<Attributes dsName="ds2" columnName="ORG_EN_NAME"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="5" s="0">
<O>
<![CDATA[ORG_LEVEL]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="5" s="0">
<O t="DSColumn">
<Attributes dsName="ds2" columnName="ORG_LEVEL"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="6" s="0">
<O>
<![CDATA[ORDER_KEY]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="6" s="0">
<O t="DSColumn">
<Attributes dsName="ds2" columnName="ORDER_KEY"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="7" s="0">
<O>
<![CDATA[ORG_TYPE_ID]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="7" s="0">
<O t="DSColumn">
<Attributes dsName="ds2" columnName="ORG_TYPE_ID"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="8" s="0">
<O>
<![CDATA[ORG_TYPE]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="8" s="0">
<O t="DSColumn">
<Attributes dsName="ds2" columnName="ORG_TYPE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="9" s="0">
<O>
<![CDATA[ORG_CLASSIFY_ID]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="9" s="0">
<O t="DSColumn">
<Attributes dsName="ds2" columnName="ORG_CLASSIFY_ID"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="10" s="0">
<O>
<![CDATA[ORG_CLASSIFY]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="10" s="0">
<O t="DSColumn">
<Attributes dsName="ds2" columnName="ORG_CLASSIFY"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="11" s="0">
<O>
<![CDATA[LONGITUDE]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="11" s="0">
<O t="DSColumn">
<Attributes dsName="ds2" columnName="LONGITUDE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="12" s="0">
<O>
<![CDATA[LATITUDE]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="12" s="0">
<O t="DSColumn">
<Attributes dsName="ds2" columnName="LATITUDE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="13" s="0">
<O>
<![CDATA[ORG_SRC_CODE]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="13" s="0">
<O t="DSColumn">
<Attributes dsName="ds2" columnName="ORG_SRC_CODE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="14" s="0">
<O>
<![CDATA[START_DATE]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="14" s="0">
<O t="DSColumn">
<Attributes dsName="ds2" columnName="START_DATE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="15" s="0">
<O>
<![CDATA[END_DATE]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="15" s="0">
<O t="DSColumn">
<Attributes dsName="ds2" columnName="END_DATE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="16" s="0">
<O>
<![CDATA[START_FLAG]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="16" s="0">
<O t="DSColumn">
<Attributes dsName="ds2" columnName="START_FLAG"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="17" s="0">
<O>
<![CDATA[ORG_AREA_ID]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="17" s="0">
<O t="DSColumn">
<Attributes dsName="ds2" columnName="ORG_AREA_ID"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="18" s="0">
<O>
<![CDATA[ORG_AREA]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="18" s="0">
<O t="DSColumn">
<Attributes dsName="ds2" columnName="ORG_AREA"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="19" s="0">
<O>
<![CDATA[ORG_CY]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="19" s="0">
<O t="DSColumn">
<Attributes dsName="ds2" columnName="ORG_CY"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="20" s="0">
<O>
<![CDATA[ORG_CODE]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="20" s="0">
<O t="DSColumn">
<Attributes dsName="ds2" columnName="ORG_CODE"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="21" s="0">
<O>
<![CDATA[ORG_SFXS]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="21" s="0">
<O t="DSColumn">
<Attributes dsName="ds2" columnName="ORG_SFXS"/>
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
<Style imageLayout="1">
<FRFont name="SimSun" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Top style="1"/>
<Bottom style="1"/>
<Left style="1"/>
<Right style="1"/>
</Border>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<IM>
<![CDATA[m<j1Ae8,).Ei=Ug-^&:gM@-&sP$N2kaI3fSR3Z>#ZL=?Y6^^cj=L1Cfp?[_VR`$%I#(s06$,
^._)!:W(V*Xj(TC]A\`kII5Jom6JXleBW@fCsVtn'Cn0r`l)ApJ5(3eQj^2=gi2%[S'on2na(
_(`Bf"gFfjs)7[O9H1dM@gJ%FmIlj_")*cfLR%N)/QJN^1=e73J-smV(f/sc\0QP:a55m6SE
HDPaVq5(SCOG;f[<!/W?nuIH-Od;I69eG`RerlE]A\f+6i<XqU$DhlKEFjEa3r+>di-^8\lCf
(T?%HC,?AU_(US9!C=-h'"&0nOB;[RqP8eSNOS(j&jh<%4l42\ZLg!q0b$7'!c\cKq_-;28\
]AaH!Ui=/!g/F^Bi2[1"QW]AiCoY[_8W(`@EV@roHc!/P#0bp^hM)oH!tIG?acK'7\m7P\am#j
Gmc@*:<(C9W)?2cJENOrF67"u`kt?5Z^K),uDu=ah[=W9d=M>`q`Y;ScB$%UXUEG?!Xo2AK%
o:49uC8Ab1p\G.5Bc&Pq'P0mD=iCT8\g;]AF:HfDogjG-_oQ)#:cHipEspitW3nMm.*W=+)kO
+'rP367-'R5:TPhh+(K7[LGVjW.B+-MJVaP^uE5hRe,Ki)35/XE0kq*A_ValP$q!ED)*teid
AP5q\:6Yn@32ZaAV^eQ>".$]AtDKQe<$"UE3VoB:Fe`?PEg[=GOPBF,GB.kdXjmiO,<"Cj+#I
EBu2@4.isf4cs?^e30`%gu=ZJmZQCG$qLo#6uF@Z$@!g?LQd<de\7\>.fh"q$NlUsQa,=A*p
ZXA=4O^Q>46%#[]Ap0Td"]AiBIGn(*LpQcn%p$J5bi1g(s+E5"EE$n5n20=^U:V03J25pC8L,R
hlI'=TQYHSRh>HOu--!Hf@?cZGUU,GJr@dHl<"cRB!9'i<X<AL&o"^d4(Osc<HH/)h*i\d.6
V^K]Api)B;I(tU-3Dc>6=M>i!Oq%1HrL:Q;mh>]A3\khJ4N.3.@!KUNJS[p@<>Q=TeWuI$mq&p
/K>)'O0.GFW>-oE.ES_>>;&sfmfA&m@W!Na$g8O=O&E=%1d`5$mdPKRg!nEicO]ARc(k3s9s/
%.F*=.KrP[6edQ)4N\%(f-PiFNh_#`I]AE,%k#$/FC8D'7'fibQf8dDN@I8)d+g@^\6>5C"O!
h!A$sG]A/RJ2_bJ[XT\cO_;m)2T+<2t*qVT^>=KOX$:<;tVlQ/?9S7447!V\HTt-*EQZ[hPGp
*`FVR*M^IHK(/slJc+XWeF:BMSn((cVfr*^MKulopI@lZc_;:,bQ*T#4iknf::WqY3?fd%U#
*I#,:0`$,BrOPZfq=jc[kUo-Y17KoIK*+k?gLDacRdnLLfkdjm?s-cN9es8H3%JC/u6?K4mG
%Tr7@%tq!4`oYe!$jfm_-aNR6r0fD`^CgOi7ii^BaSZ/,Q(A&l\=ckfLaj2AFp-es*@(@;b$
A8B9`p+/U<E$#?M*HD1Ifb_\ET=>sMDhL)&NnPt>M.t&o;nPDCE:@LH0dr-ek$.2Q>l3Q(Q8
c[q4V,H:W,8%bXdOs<Yf!WOp5PNdjB3;Y%%b:>l!6Q;FDHrTme"LUQN"IOV'glDEA#,Z5#:'
Pr;EI5W+u6D58BSi?TLH&h2O=@`<O0B&+qDb&Y.9s([_J6H7?8-<OcrB-89L.l,d-am/Eij,
no,+$b&ts[b_r0SOkF?:ENuNqIP.f'(B1<Xg+'o-JgJ/':Q6h02WTh;Aq6f20HA;J"*)mesh
o)mX2.;2PUr(fRLXmK5/0i=qBrC6if37E%Q*PB`#U0@KUDIDBu6N2iQ4+D2Z+!^LK4q9)+HS
4[f$(\rK'6AMX-h>sK$NCfk/O5!*&m.mn';ZqU=@i_UbO,J!sb/8/<HiVTQjlhaO)Md&-@_=
us2P/0hOaGZBSWj6mDMpMY5E5O-LR!Ibf7egoKbSBiKZ6Esci?HZY_CuAm5MF_mFKi1'rp("
GNFc=Rq6Ko9+TQ1B;W",;mA'V7BY+Ys<WQG%\?p1H0RE,1?-+,QQiAC+@SeQQ%B=`d\tQ%QT
+WV3#g[S1Nk+AZV%U(Kq=kBMK4;NjV5TZZdmT,Qgi#!hVK"iY$+)a<GA5*9"45fhrJjUaM)'
NBqR:e]Ac]Aal1#K8dA"/qbi9ekpl>?pg@l8J/Er^H>#A;Iq6ZHP)A5reG/3EG:Egr\m.nZoB/
G='`WUBRuf;F=/!Hdn#F\8SH5==,K:5E]A$h\Oqt:j]Apq2LP729IMfe/kYbt<A*k^%%%.g\&,
T?j08ie?Nc!^qX<1>@\XXlU)X`\T0PXM\M9-&K'\_I01,]A#FC@]AUskpNr*'$+ue`K"?Lgoe'
R?s!I#h5#%LTC:1sG*`KuMCU!%19CIt\1#"VXkH9D:5U&LVm\oH(WMjini`9s#??[g?(KdW6
JA"kdJg$Z<4/>PnlADS=j0F4YbCB:hE0?>Le^.R`_*NC,FKtgDX7GN0Lr!PHt"qiWcR;l*Eb
Lud4TM%$)XH&W&$CGi0X,=@dhPq;t-`3(;ra;R<AN,5$BgE@'k$_16m3!fYfLCgGA:4ND:Y_
lT+i8]A5>,RV&<L?g+e'fIUX/&/4\i0S+#OK*l6rW5kE"-B.UQk<T^Q5.\V-=OO1gmc$(W.+1
)lt(JacT@dC/B[91if@#7cY!:EI8akg*^1d<\[+(Rlu&QFb-3AWY\51CJGki!=Znj5h4#pb-
?AjLZ8R%,>S8!F7)k/XeB6+Q]A&?oP1EnlQ-NK!1Ngi-0^5TDCHl)Gu<Bi%*S&c(3mMB.+.,b
,:K?-"SMPeE!)1+gVoG1DrmC,KidAFPL*up!PK2ADbL#[k_4)p'oIRJm+i(a+fP,F6"+LkNf
q#KFL#MJG[5Q^.Y?uo3`UORA?,rH'LmlQ\q99:CH)@OFXp,'DVP&8chW+8h&2cYNk)SDbGYE
AqV[5kBt/$AG40oi)oYZL#\)?Xp;CA!d`pgh9`'Uoh?E;H,sDuU@lfRJNXkQ=f'Q:.)Rm\Q$
g2Ek$`)_ADBinj)Y$`P5',h8H3BLp]A[8lcVta2J18FIEqaTLRs<8p7!@)&2Em)Q#f[<^Vet:
,,PIfrrh8\DgreQ#CV--OQ(;_(lZ4gQs1,FnN>DumEQ7M(rRL$)=S@H_dMTD-?4IbbH%S!g(
.>jZ*u:_]Aa6P%f9HM3f3_;MBb'HD?-p);_Y-=h"p5TcD!NrF-Fbm`9b;%%Po'BG=/"kWPERK
dZks+W7F[b)Uf<<a4QduJD#EL&r<.gkjU8(Imk>JcN+5a'!FSFq1b>9XsBrWbRMGrG`\h]AD]A
F(?,#Q<@]Ab3Y`2srPD/1q*U@*Q@\?0b'D#_0GH=G&#gA!(pM4X\8'V*=F@7RA>>QdK41o3CN
KLW_PsXWQ%]AE(0P@H;$tB"dWU;r'Et`dkFfn/:<G:'-RP)^l[<Pg$"bA./O9C&G_YsNlkNJR
Spuln<$H;1k=46?^qbogtcc-hK_)p<ap;=r..@fNH-W]A*6Tq7(+A-?-6FL%nAd,-pKM+WJ-=
.Lt_6u:VQN!'<F>>#ucR\T]A.)#e;M?3-[uS3OnKWKdS2M[XV1%j>36_)el9BFY3`aAG:i]ArI
M)Qe9?4no5*(S*t*]A6.kW&K9P'F^XFRE>7ugCf<5,(pY(LFdbEn-Tu7"]AX_Y/`4UZ-a:0gOs
.Fu)l-=2mg<dK11Uu3Z4NiC%C:0d]AnoE+u.ZRdusQ0,_i$gl6)0UD?-2JjH5i(j+_2(COl<0
=PHSoM3Z5a[;2nEY:Wi<6%U6&ZP"Bi"W2]AYmKE?\+]AOoe`O7!).`DXXe3<e(U=:2OLHa\Y-F
"C&^<d2PAqU?pTjbj0f7p6gsmB;SLo^XG#u.5Mt6!A3dpgIUh9H,loIrcGpjO6CA<f7lYPen
EpiQ&j*E+SCrlQ)!k[70K;&JHSo%<$)&tH;_cb,_<a7=@?@jK-0"'C*SE$X-8u!t-VI@(DJh
jjUfC`LK2j,GmhB/g^4(OGLtDXs#2^"JNf0M%s2@L5(#0&L8^`RM';-UlS:;KL[79j!>^:^#
`"dZBGM#iJ0G@)*!cStL?#1%f!^psgPOQ3:#u$PIq5FN1lPhFI-e??_a7i6=61AYP8dc"PB<
i;5++ZEh^u/(!?fGbs@K+d?4:d2!7(p)M3RtekqA9J@@+u7qmo3clD)[p%IBOdKCPo?]AOoB'
SB.bO^MLgr'<f"03[`n2oDJ4Tkm$+D#(jkTXrK-AF^>ERFq^I]A/DQ__c:.OK'"%k(i#>@k24
^V!0CU/-FmX^&9Nk7VOMT]AHI!WmkD+<QasoCEau&6l1(a/%S?Jm8nf0Hsuo1i3W(5G#O"YsJ
=Alj^96=l.XcO'"K--R^8+]AFQYXX1CI>E5c)i3l>r55iD!8T+cNjrGTgp-re]AAB3Bj'i^>hA
g`Y)9S\A`*h-o@K!aNB/*OJ=_)\=t#/$q,#(gFRPkW7\N'5GnU@MAU4VWirne'ko@'DLsFH*
`:P6((F^JSjnJC1B&Sp`acSAW9G;kVL<'\g6AZ7=3%^<E0gfISQA=NB'AX^76Oc7K^GLXT5:
\WjiR)qR"-i0VS9MMV3G3Uhc&.GcL='Kap%#CGXsE'C,6=5H<F",#55uaSAJd5&[JH'p>YdD
*$6.rqj$7=d2[iB[mUlFkS.p8mub=oA*!%%fULi3%n.%ouL+\TK/GheJp;-)29-g0kPf*ajc
DBC&"s]AANVR:kj2Miq+gkF7s2:Q2O+M-S`"YGOmC/T(9I@Fa>r8&4gOF5^!h(l>,*g$&K_*G
2:.cDmMa^Ne.X$t6!mC96AB\.?-$F2O40JU2c_X[0$J4JBe<-P7=s`m:`*@:5g+R@&Tess@D
:Z-\4nO2iAAbD)-5':7Wk\mVgPYJQan0/6R\VM.V84f5L55a^DSQ\+([;sk1$ZHplJSrgYVk
(qZ&drS[eEJQd:(1\YH>[2QZ(A6dRVV(qIo`3:cXHUT^l&"cme"]AuoG;j.5GNA,TGc(6qlH\
kF>Q53&<>c"Xda*_f9K(u@c^R!b[gV[@E0'bWX%O20-76nTm:"Y[>/+8:R5(c9O0ffrkUSB)
(P4V+In`219P8l!%X<ljj9.6U\93"JN!<PLgFS@T,9;FKL^OqlQ&Yp37Ul!!rmO5_]Aq>T*r8
<QD3HJd1*J46G`EgqR9OKhs7kNG&[Yd[Gb1F$3("i,=J0.-IqH4%:-g1LJdFn%&MQDZG@S@L
LM*]A%JZ<<_TR0YJlWq@f[[1NN5qcL=@enTB[I+_$2Qh+HpbXdL%*@^+B9'F,8$_VrRkH%R<?
7%]AV$#,M\cOW)>7f%/EIds.gH++5^FGT.(BqVI[gKFC@`7JOrtKlR?_/m.'?rpZr!`d3+.c#
pH0!_t3,S3q6\_;QI8:CL=4X,`L6dp_1uI,mLp>`9-4."RhP`q+#&MMScU+AX.e8[eDr=e$2
KD['R$:RNYS+oKDG\`#\%BkWZ/i:q/c#m<Hgil"-%D=jkN#N_8LI1b(H=`+OcbP$HE8+.5Bn
/1TL%8AnYn%MWCa[bgF%+7naL]A%gDAdNu:>3God?>)Aj'DI.'0Lp9JVL"GW\>1?`'ScOKJ4;
VA856WbZdQck/k65IW$^unH6BXc2oK)2TVF;LKiY/(;VM>A&9QM[`a*i!mIK0fOI`Mc]AYbL:
sgo.dRD74h*VSUrM1]AEX-EC6J*1.Mn3)pPWQgd(4sk[\7b*[5BOn9i2O<8\F9Zf5;+g%WMW7
V?./o'LJX&oJ_8YD!MTM[S[c]Apc#VE9#;=1K-;Cmim')DfdFOm)'f3:.JGu1j!?l>UTM=a;j
R7%ZOUus4F4./lV.cOnfr4K,&GhQp,]A3Xi?B[YkfZC//YE:<:lP2,n44H2>U$f,T7ub?lWol
dqg\)_#AMBG`K*)V0-t$mpqui$UYuDT(Tp@$[Td1VCX)h]A^k]A2"OI'/)HE*+q=/;+=2O8F5W
f'o#@WC7cfTF2=8FQu,EZmK-XN!QR[m)A=cJM'Q#&&k<B9p?0]AJK[Wu),nG#g5Xo5XbaYu-'
2/Omt]AjeXYleV%#gp"MB6M$p?:gO2@FKm::.DE]A2Ir=.[25/G3tennsK43M8GImMA(>4rOuP
PifaB3lfrfeKJqI`Bnp);*NhZ4FA:n[s<?"0XSP`76*a0<^E\5q`uPQCG-tB=ip\?j=bJ3),
K?QrHMj<K)Fkm<A+(\tQ,[GM6YE!TCg6!Z)$W!R1LX30<,34%?d/<?mMqKY#&!8/$:BfgP+l
J49_BH>o]A]A5[\hs'LC#<)FHVuHT&,VH!EK"ftaC_QBh:A6h[p0@be\a/INnIa%gp-W2F.U8p
"]A%@FqT6*FL0CR-K=.&/1+?NOR!lqrRReKd!Rke2#1,Z#8;(Wl7#*@Q(:^f9jM1hEERak[>B
ohPb,,"hD%t$Q_8V[p;;.9Au[KJ6$@Fo9%CGd`RrH5l2%?GQ]A?Ga9lF\T%Isfolad;94/o%S
T6?o#/Yl@:L;cF';l9kH.FF3_pPN'S=]A_aS$cc(d`pEgq5thfV0>m:=3ohBjs]A1-a&Jrh7q_
Vt*W]Ao2Fjq9^h[h:ppN:$IB`=0dmOt#j6i@WPU(Q?C2NZWM/I-SA\!Z'^PPBig&\qI/pBrdG
1"`!$WD?<G(M?\-.Or+>&WQ[??V\CQL%HKN9E?2QTX>-UophJ:gU/n+0Xkd&\@3<,mYurdcW
Si/As'\qWAJg*m\H+QXUpUO2iHXNg72X$RCGm*V;]An6B,.)'oDt:2a#;l63X4]A%DDoks4ZE_
%jh0Y3YWcAOGbiLtHj+\qSM_M,(*@mIA?dWBIVJC_RMaoMJ[H=5s%ilQ'iAX-CjhIq`]An#+m
re\SU^B5.Y%]A,MJ,?Ad8=/Wqn>%'1^I6G"O*\h;%lht^16D:(6/!D@;@4PZjk@a:n3O5l^1I
S(c.=WK1X,kfZq=OYler<Td!W2)c!^U@o37oV`N?RB-<p3.hikn[Vf7FQ!I!>6CN+5JA;4d(
%t<929"[,I*^9`1,8?&4j(RPN,Z)0aXQ=8P'J4TIM\;k0/84,lL'W\';kakGdi<H<OS@p^5M
?iOa@X/BacabDW9V%W0unQ<5ha+idb\U.VOM8N<&+8unE^S#c\.5:A`iL/:CuX>ke]AM8;<gJ
AZC6DiQ3l0`J3[sFs.qf$Hjko:;<N)2H.]A#7fY%XAZLGs/gl5nf/\SjJo#C21mqtnd=$I3Ie
T@*?GmfHL]AM!]A0OKU'?[QCS!HT(&="jd14M$dEQ:?QprofWSK)-^I`\2c!+bB0@96L5DS1"V
%CT]AChofF?fN[#9nkiGec=n/4NmTFggoM:k2=eF'f/0l,MA1e+hV6Jd^0<>UOOhSR$7d_eX.
K9tmG6DIfa.#>P=h6WHGbnH2I_XH[:!CrbN[1fVm49P"\CWiie@nqAFNsWV4!'7fUlb9fpdW
=_aH/1)*d3rY7U(qGoHW00'MQ3I]A3b5$@atm)mZ_)iTesM2eGfJ(pELX0Ch*,C"@k":@^aj)
EQ-pn+%s@H1eV[R#I6`MHlS#K8gLC/%T$tsnIL<9>ARh1SUp1KO:(^VN9_=dBWef@Rl#RsTW
TF0fIg0tX!WEM1:Hn@Km@^6?4:R^UQoEoa.0k@Sh=jOm'pfqPm-hZI!,\'Cbe\(LUqPI(S!S
PdH$+]A_$a7F5nm)[=S*mY&9h3N6!O%?TQXfWFTkT[>56^bO1OK*SiCo+WiUP!Q;K7g1HBm="
9qc]AjVXbnt$WgU#Kk'^H]AIC7Zl+9,kRq$"6rH>:/lC-GepSip16QDE>Eiki9*-]AAd`QXt4l<
9.tnkFn/A=,fSZ3kWZOn.0K#%bPc-2O<#??4_.?V.*@oW,XBO'UtAqkZ/d\s]AbUmQK\/X%%$
!#&JK+@(X[G<>4=g(4>4BZ_UW+PL.V9')SYba$)Z]A"Xi!XMt+/J\RsKM1ZL&uQ-8i?<OfX&c
i&`1f'?fA8b^4]AH.Fe;F6CfXp4G0Xft%lD>p!8D55l5f,,Z6si_;u$:6.iQN7q_#ZV&0Ak1P
0_d9oK,JL)p?p&_F*LpN/:SN(r)g,8`5Z"K^eakWF!+F<V%3S8!H,T_6a=tbX9=*;V&FtJK(
;"+-=MD2^l@5WR8U"KL)mjDn-)D(L`0Aa_B:t>O!Od,am67L@!1X54uBFhjL;S^ef[6:\/<$
M&bg+#!o\qGf3?@#Z""m+H\eObQM\]Ab=:E2acCLS?kJ`\mj(R01p>+"rq)0rj.[H8OYp^K6W
:P(ui_Doa/tWh2@Qn5VE94?gi)cd1%G['05(na-50qIoYjm/t\+Koa^ts-Y`eT/>Gn0jir[4
X=5MfJ1JSpu)nMX^L5P-oFeDO#mk*b\b]A6psTg;gEGVSArPfSUNP/<kiuZQ!Kf/>3J)hFI&-
k,$j79G!h*]A\6d<#<aZE5<_^C+LBW?hOV;In%6i6\s'F=I!jn=OS.`6DQ6KF?2e1*ODHBDDI
o</a8)&Is!$<U7q%SH-r!V"`b-CC?jp4r,&ITV]AUf8g0C)\7GC9oB=rX^D'?3299rrSuom5a
(O)2nt-JG5p2Kg/0CD7G7*VEr*F&GXL8kDdf^"<=R[TG)gQ-5@+\\%PVH;&fbZDoupLOa:He
dd>&+%gtcenP9:D:p2?57/--g#B#8Y>&o"i`L+t]AobTN73BZM&$md+g%G^iegr-U"sqCE<2e
hH?:YY&!P(,*;tg>U6CZ[67DmU4l`NA[++G-dEF5>R^4nE=l;cSEP.n-=3Qei4u%;2k)+F33
D*jVP8W6"Y$RQW"/!pL^%@<[UF'X`@-P3_b`*0PSp*km_o=)s6(&@\QqHR(A&j'+-rTc0Od3
HRbPK;fBSQG43r9KQ^IGl!<1=5gGNnQr"&M5gTj^d;iO\<a4A:>5ik_NgB]A_+>g)V%VA=F@N
IO-lVZ2MMM%9abtN9*,/BJ8d$T5`XF:dt924#ESD%r#KG,ibTk1n4+C_+>BIfCO;X>h3;DFX
-Sgl'c!lCg<AL2f@0QIk\W]A'(8AZpFE^Rf>^]A^fAag!$'J]ANmHc4M43aN$u$F/OAHGaFIN3B
P[!HCDXe&;C%IFo.&dSNc*)!c[SPIhsW!9Qr&6&8ten/UPsH!icW?SWu7ceOo)s*:fe8n3Qt
IOZLU@5.DOc8=E[Gl[D$tt8m2dZp`U'__P`6-*0S9$T)dX0b;;9T4lKr6F5KU\kTmiuiG<-g
Iaq?\%7em+r\8Pf'3hPJ6m!EK>1k9eb#k#o.<skFMI38$]Am=f_of(0i2Ire<5=jB<+@\lE[?
'bh./EZ2&K<5lY@%9u(^&9r">Qt`g0FCgD8M(!&>*+iR"kn*C>!_gcL\%E,@\-F)tlt"208P
gC;;>dq0CdVp0DV"<F7T6#2i#KTMFT;_;O#M@05Io>G5CCe?-*o#eUbNYAK["R&Jh#!iju=l
64<JcHD.ZZLSY%bl.nM\2jFp:;'*93snHT#pPZ5f:lFXmgRut$]ACU>(oa7HihuL+:/FJVj@l
:g\%m%[".,0CLY7A>nR'tK]AtY8^66*D4r.GC%Cu!iTAERllEooR59/@9N%?Qc<0i8OmN;G3Q
[6k,5))QEF":5n8#dHW<\ma!7%oL#@0&cLHlPica&>HphP&cF!9R6r\70uqPUW.UE)Ri4KQR
hiXU'OEKl">d,fr$A#h#F0DCJgIJcZ9*u<XrOncG'#3eQL3jmUllnUH.oBbnlV=p5(0i)WA#
cDlf%D`eJ]A,-_\I/:0((Bp3*!N$GP&h=V)acYHO/+cYN]A;>2HdO/BcuS4i-+DHu0R@QU[ATd
j6e(bm\a?LMQD0OLe`/e=Kd/N#\DNEB/*<)?'ngkLl5=.CL@S6#4uP>SJ7G2q<GO^j[=@fd&
PH$QjR/7cD*]AlN[&.kuo@YOmFqt5tCFX+XnI$(JS/_LLHK--=QEKYsCQGj!UZ%SG5+Z=P;6q
L4^STC.B8]AV[[bDM6-gVpg?5AJZoi)`2m3GR^J;o/a;eNrAJkZN,2AEel`"?)"^XYK\#[n6Y
FJ?:i.9BU'%n<DPu.-_AgeTajS<-N;/G<@@o2)1oPYf9oTBcCT]Ahj3UH4tNciGo)q(f0g-4G
M*mtbOSK_to+C'.1omV"kN9ZmWg(s5DYrIF7V%o@HK/9#soc-<RIe-LOTAoTir^@Q)oQ]Aotq
]A)5j6U%I6bS(4NbGd&V(JP+C)GTmM7$Zd@4DXkm6*dU\2u(7`4?qpB\+8Y6L$9RD%Uq':>e*
97T^PZJ3lW*5"*e&>8NBqjYC;B$MapDV=cA`;/UB6<3AGDuS3CQ3UakkF'.]ACu)aA;"m05NH
(R)Sjc0Xots1?PBI47We^j'm8nPHe]Aj]A/J]A1(C5).J!6)&%oE7]A$%So\Dtumg0]AQ759O34Oq
3n\(q,`nfN3;H^GoWTM6BN&qu[UBM]AdrR]Ans&[W>k3-d3h3JI>7GRY([4lp._7?l.)u2_RA[
3LPd*oTgGDX`5_<BoZ)pr`eTS<"BLa^eqh!oVNBknPuU;#"7GB>ac"mDO#.XOA7Z!Rf[VTLS
^B;[Tn5g;U?m;6?RU7DRK+jD?GX#%C-'MLpC,@jC_LdmAS:gb<A45WKMe4EjpLR+Vc(_!D!(
_BbJ79*CG+k'^(!?k)&R8a@83!GkS4XggD]A&BV1<s.\<^f[1\05PpfR.Q`ra9"KoHSP3e+s,
pjuTuBODst&]AD%[G_0uX"MqI?KG@Nd<'sKO-5YZW`MiA>1eqZ(Be1Q\Vg)ICg!uqO$Hs@A38
q$#p3fNJV9cD`'[1p2=R3?TIn&m=A*R1qq9".r#d3BJ4D=W!hf3S8d8=l`a-r[V"jKLK<4-2
`>[)U#r(im9,Zt]AXoAW2Da@=hs"$\&R7UBQ=61L(G\,Adu^*B=-LI5C\QoofMJH*Y5Te!Uu,
PEj":$@HV*;>/m;S+:_J._aOXKoFEWWDJPGI9nl:.DKP+=]Aj38l\JR=Wa<IQuifbePE7X]AKT
rpauNP"0N+Qr>A7KF=amhZ&SRQX*V2F@e,]Alb5<Su10ppU4Fs/d-nn!YI%k;5OV<"-WnWbc'
%K3,En.1h9AP/Sdn=MgiF31%0iP%-2M$&fj6cRB5rb3:a<C<rB,aCdTE-_K<@MSi>d>jVY2B
]AJUE6!Dkl6j<>4:si)aW_mL68O!f+k^3Inc*bQfdBaAmN4JQd_"OkgqHC'l?;@4Bq<5>NO:9
<5`^UjUFV1]AbjW=rNro4pBS(X]A2G]A;;JFqp%R;SIA[L^L2TsdW)kOffIo:%$dS%OMT^B>r68
=NLK<LDsl.YDX34$dL#?$Jd<SC/d./LoIhpmY@rV;$,p8ji7SWqsa*-@XN`o-J&.6c]Ahq`K:
n6lWFb(&&.q[j,'qo(Lc5f5e#(%OkHfe*P!K1'LJC>b'^2`;H5g`J:Hmm*a89JoV;qGIVB<L
ap1\CD9JtRLHI-sVZ/6+fVXtlDd3B9n651%PZP56.3phY1tE-HUK<@4I<RtG;D&c\\Y-(fga
i<.Fhq#JQA;IAc4U1OTCZD:Dp:ckJTB65)Rd!:?Lh6B`L(6_ZIKF$>aTBEQnFDB\%sa*^4D+
P]AQ2R">G!c["t&gdlWe5)(:BI4kq^4MD5p]AX0+T>AEST`J=/)A*B>(M"iaiA']AVM"s0Ihien
a<"]AH`(Q?8/ub7;N,#,/_T?.0F0=qrj0_fUOY?VQ`docn^Bt]Ant"K,8Sq**`LD#s\YpgFnBA
S`d^3\9%f!c>Q<Mm-qM-k[^%[Q_`o<dR!A#jY@:S>T>0/3C%G7RA[Cr,-gh]AYai2DZVI!"b]A
Ypnud-aMDO<j"8&nS19OJFa/6lu2Fu]A<T3`O*Y+KYg\pe?8<VW4qRV/i\SJ.(QPY_W@kp_k^
68+c>SWh`Ca$%Jl8+jMB3IA?(Iutd.Kl`MG<]A$?UF,8Og6J345[;EZ;BDk!?Y(Jf9$O)Yp'O
SS+=t<TP%%q'/D(\__^B'YJ4iA]A-dFDHeW\alJ[t^BOngOrr6X=H<nhN0t2Y92gJ?<T'<klE
;Cli)CNK]A!%l*%&l9d[2l%14'="Wm@t&1RnXumuWp)i59FN,<>W"hl-7tu[ORFR,EQ+2a4)S
+VE[-J^n'2jg`qI$9ef!4:_l4d0ee:g%50M;kom0^O-8t(iDM\NipQUlVSa.d\aD0D+XLj=,
>A\cq1'F=?-$Mnp[FKgXqXrJC\30\h@-e%o(=%RoYC"(&5"/31j>#kD8kDeW.Q2KeKG)!l1>
1:49<:KPknd?4=1$T#!dVTCqJf%\RWE/:ZBq\J."7XMG!(@C7dB/T.4"M;JJ\tp,0iQ0%B4[
!A@tq/Y6>4h%DJ0"H?8GYNSaWUTa1Q=,Mu^OrA!o@#d^7j0\<WSH.Bd_*VL(jJo=gp%-MGP8
2T(D,$NuAES*rR+ZILI>Aq&,f7:!]Ap0?H<^n<\YMNFH9DR;U9<'M9Ig^rJ7Eb#@T]A6E6)NG)
%@lY!TE?J3ejaQ4A@l?qW6?SZ_NNXb:R[2lAuQ7"p"FgZDF%5rNMTp/P1MQ=qZW/p&6lY,NF
#D?=f0&BUeoeC0;o8QV-rTZa*Xpd)jh6^GXjG*<W>cN']A:5m%783i4<gp^[i?eTGN^dV#97[
Dti7,K@#M4@-XIPUf&`:IM1ZFV4YBnAhLP9&_+gaE#Bk68)V:Vmf#.r]A"Og/j4r&$1qY2AJ5
/RI_Li)8DPr)aK4Z:X)J]AcF!QRbeZ\b:XJjIN5W,2)O\iS^\i:Yn6Kj,+8!i5GdMk[cI^Ws,
aHOf@DDugVl1NarT9-%d:&(IdS'X?i7Z+3H0rBebXW6g5*$..?Y[T/`_Z!\(d@uNJ,+AFlWF
7G/4m'-q`20P0=lGS9Y`[(f:.^M)Fl>*6/dpSasoGU=Og\rPmSD\aPSoYpAcI.f`qp6nO=:(
f%GYu6+oWooAEKA:70@Vd6FMf7$WTSpp"B7\O9E@2>ER$LQm3LXGqpX6;A,6!ecRcPF/3p(-
7QKYR6/ogl&\?oQtYhU"U1GMGc1S$408WD[a<#(:s.baI-8c0m.a;&=#PafY@71pf)-s=,_O
m0Ca>KcW2YN&FaL9n>Hn9g'N_c1A+a+*;@S4.Z>I6>+2EH#]ARboed!I/iYXk2/F$Wjpf$*^:
$nntSVipK/84$9-UXHdNSs9=""4ls;3=mLH;2%P@UNTPF$T8Z>tr"W0)$67rW##eTiMi?qkH
M?4[)>5>%#[S792q-Lt2*OCIFfa;l4VPG/]A!;2"YF"QEWRt1O2s9>FFN"<%/TY>(q+Irbsi_
IAMTpG:0-M*pWn2o)fcF#@2b"@hMnI>H*nTM8,/&K]ATX3[LP2QBh$JG((OW7:+!<ir/jT.GB
T2%;Zb]AfKdZ/=+4#I87?!G%F7hQG`M/>f.:lXREa#lp4VkE9SsUe!56ZrMDJIhrU\21=9n_6
gS,-5pO!k"f$45]A3gj\<c$pMs#gqLLGG"i+W(LZdhK?stqZG89q-K9fTl-%@dR:mg&hbSk,j
2V<l",+F8hc?P<KF@Q,9ItUr=N2Rk:r-`)'7+>J+5UoIVVNZ#L4dq!i`.W*$Oms+YYXWVq[6
n[5B"np1sjI-?H0d*eZJ#4leD%1?DEQe&N=ElS:P`]Ad)J)nOSe6k+*)j!RBPV%b]AX7g(&=[D
F$s()d2**Q[$!RhFF@Y8\gk[dGr$S4KXC+3=O?>0it[48`U]AiZ&+3S?s+4l8TN,C:FTc['dm
M#1.DlK"df)DcZhr[3@6$IDJO;N=8fD*qk!ubtF89T.M'4MC'k?`i4?VB=ku7S):_7,s']AYf
E?e[6-06_kc6V]A1"#DaC<`1'p#ROfPHo!@f2QJPH.K9&DjE@;OSVru:^b6f[Wr:X2Qj>,d(4
DV?$$4Xb<K^h#pfY^R0IYE3el[%Tq@K::d51`QCJ3JNAeTrmrQMH6.(+qkR5tNLOoaR_J6Db
m>'D%;sG]A$t9>.JjN_%p;GNB"&2d1GmGeJ$Y;qJeu$eKRCdGBuSZ./]A*n[-%:S43iWC'0`$\
3&Q'3R9NO9\ZBm4A>13=]A7dp`*%D,]AN>0rf<1SYB@.$D'7G%q;VJNWu2,lGJOQ4G'#']AU:oZ
K#YNg+<I7n&8j\`UgJX^&8CG#99bMO*Fm/Dt!<WRp&rP[_]AD1hu]ADVT7#'C_-fRFo/9dPdJ+
E]A6@l"HNqT,BV6qa=68@*cJaA^qS$>s^e/nb_r#]A<1q"]A.mWt&kLk&h^m;-IkRXSB>9:@WP*
"<*4#tna";7qtIgrIo%FK5AhE67K8&Js'J>\TL3R:=>+Nu($ql[JU4(0&o!3;(5.pW7G^Y#:
uC(QO<TEe'g<m_h-0q%_@X/Xi9Q0*&#<EWndoPErKrp;[[7*(H7>.5)u)S"hX\OEkXT@HC'R
00aU^MZTM*#ReuKT_19=m+-K,2s5f?n"0WpfFXEg0W(q@W*"urpIDQgl"h2DMU>Yc;@3*[:m
K88aMc7@l7H[t:2e+"-d\a(8NPEEHVG_hrk?t]AIZ/B(rP*?2[$loq`4e/4j_D!l#R5nlAIn[
;%?#&Dhd8[K]A^0.+Xr)d4P:Sc@F*73YT%(4M]AeYI!="gA&+PDV<3IAADT$;VA]AE(COROAS,+
SN=;-;&2L+\$Ar2Y"bh,bZk,@IX6rI]AXXT2[TT(W,XMQ!XhVD>&/*2D[jCL/Sj;%Da"o/<.p
_7h[Z(24mH(*F8o/+Yisn(YPrii@2?Y\RjSHu]AFp`@l]A*;uiksJnQDn.[cj@)$G.%`lXkTRU
"6YKH6q$8W/M:^b3.=7<5]A!@(dP(9.S3<_?h7XIM'tNpZ1qC6f6b,;3_PR=E17#t/+N*k#94
rFE[\>ef1lR,R)%8MK'I%^3cY.!?S%$:W5NA:.D[QK-FW<)`1O7Z<UffeZ6(Df4et*3B,b[5
*csu1'mY$P2L%63[>.;sN20CG3G6>cJM+YEk;b9u#@t"nCHN<a1(+h(8aSk$\Tiu`hEl.ZTo
DPE7,89pn;rUA0;oek)V"pU=b.Z&ol+k_H!.jgG#So^1n"jmJhca#`a(;E4c.b!d#F(]AW+6:
(Q"F_nG,%f1V'.,@*9auSGehV-,Y<_+->f/A[CR?\<oIl:_)0U#e$2Cn#<9`c'WRB^gVoa^Y
k26>439A:]A,$%t(USP1Y-NoVshlXJY7;D+*GPuLHXauK(T/RMZ=&A)&57UOB^1))7C1i]A=]AE
l$PlRZNaW<7(I\#aD=e?!k[LRaEg<oNhA]A'Zo-O8?gs!T9^A%6:<#5]A-b(l=mWrEoNaupB+T
eKaf\E7l]AmsWcid-H:9Su8+u:N)83RWq/;KsquEK]A4`"s*,gu<Y0"7b#3["CU4oB7NhHSh!;
Eo'k?r4pgIQdRn?_o.?X@4*'ob[Bj++IWnT?d]AoKCe@C1;5o\)368J+PgMJ:OA.t08PtP:b5
,\0Dcn?V7M"8p8F\Lok.MB\"P_jYh=b,h!D9HM''(1j\;Z3*3O)%Lh:r_]Ahl2%Pf=(oa]A,8!
pp;!G;+M_J,UL8hV+V6&'fjTUDlk^6[.hnD[&/#*c<kKfBQu[T/INjWp_@:P8L:;\E[+[TXa
f>k@h?B.8k`\GJ3_+l:RX@hU-qAa+Fe6XDTIL3nAi&-Lsc*sNm,m2Y&I0*"O_L5Ek%<A!sN7
!Z[BcaDE3sLWmIfB.4BP`R6`1Yo]AZLB=Z^7um*/)jqnY]A)JiA?i8L6kaJ']Ad5G38\-prK227
Q\]A'Tt&-bU*t)CNuftMYsEAH$<-d$b7:VZC^n1cKJ*o^D2\-2$$#I"gT`fm[hHDrc8R9$3Z$
ot.N:OT['O+c).AnkWkNKH//PhM>Q._'#*:U<(PF;?aiISc68;7bM7lnN;<2Bp=dMupJ+f^;
MXftdP0Y`F]AN[@)*=HRO_29Z;qU&ICF.)KqX7^FMcIU8+ed-ulf9sBHrTN$1YrPfa;5+%kLb
hZg?SDg::ZpTVnnA3P[dOBHe9UecoD%9FThO*8?_]A0]A5N(d&A[n$AV?H'WB!-1j>=Peuc#pO
&nm)Q^[7VNZieTkZoLLbo3=Und8N]Atej=aDi)<j*>F/Tc.8"0p'7NaS2<Kj9N]AVZ>p3+B@2`
j"&p(%9e7=n&<<dfa\LdnJl[aLV)j/W>(_@RJn>s50rM>'7-bT8T4$fWs(3(eN\*Q$DoF%1#
Fqf[<l&9&Zq'A9o,/H_gIGmAE8?7VR3TpU+%L;=^kB1G>j1n8Aft5J^n;U<9@F.nqI_4s;E\
^-7iGXTHfQ?*4%\A/[o_pX^0#6;L0P3W>uMJ<g4r"TjI/GM!kM<_&ZEm!dA!?$crDqJ=nS(K
51+FX]AD9N<?_@&n,8/!VU`"-,#5BW%I/L$C,4#G20Or8fkT-n)_S9amSH5N3/Y81:c\cF)f*
k6'Gi"s)D+-hZT5b>-lWcEIpLi<;"OMAATNjmr3M^QhZHD[FQEX2BH#g0O>L<Q39*s_$+bpB
WE.fU@a;(-5_B>BuX^U0p(He.(4(e6:"aJo5["40raH<[k-d=Z*@jn)R3dgI]A#\i2I`rgCJT
Kc#/WU70X)gIJ($.Eq]Af,'Vk>5+:ql$Zm;]AOtb#O>=%M#eR_CQ4S>)js*"C0!i'G(PsJ'^Nt
@`'1f--mT8>$i58R9GM,d9U47ZI_$kL"MsE\t+77T`(85/.K+Crr93&5R8b0`+GJffqpbi[i
FE4A(<rB^-/)>Dm2$"kl*$F2qgFm`qWZ"h,P_4Y!"k6ga!?/Zu/I+HkHK6-BK1$s&p`!XXYD
!,\;PXLH%,K^`mfn)GV=u/rKO5)(o?:=Y"MDauWL,j4t>&O8P7#UYO2?!,NOVJ(P[TW<8(>&
D:=Hd2(+SW1$WQg[cMe5>L\I0@V*Dh;n#Q&9Hm.0Y_P*X>6<bjrn>H=/m=g/?Q)Q2?/PY5?_
?f>9*H52snR%*9b!AjTnbL8;AX';,[7gNO;%s<m9roN6$]A=dk%tiB+K5i8o=HR`.\+dhJqEi
,Bj!kG.ldQ?.XCG7tIYcAP9@,opqs1N-EDa+LJlBGnY^9LUlfFf8BWPFiT2S<1L<NWmh6Z4E
'136E5#C[C@3n@$:*F!&4i*cb=P(*B*@^0Pt&KV5mtI]A^=b@Y0rT>aXRe(eJTH\Fpbb1g0aS
6O=7o0SiM`\ecC\.`_S)\#+@lKO;!d[kfF!s%fY$#QsXQB,bn\\Tq<5WSrIOqSC#*c\@e2Tc
D:;UJ";PVZtKI[^R.\L0UV+d#TkP1.c^kQ*LBQ[!*jD8R:BYkQ0CO%WpLjVf@8A60Ild*3N,
-[_@g$K\^geKV/p:jLSfurs']Aot.\fc:oIl?[\<(XJS5MC`s6D3$A-GS:!np95?hOcgNKp9%
_5D:11$8I!]A`=D1!)^2^i6"T4!Eq6nPrkV'<__[HI"c+T8?\':n'?S53>7l((NTJI+[Ag,Gr
ajIjRWiF(L]ADf?W:f''O9S8s"AR!>a8db0E+\Q[)]AJub@8E_$Pr;+5Yt&,I&-`G4"`/'R)p?
3!,cG-%kSgd;NirP6sT'Uoi^VY-,?]Amq<hFf=#tdUcXZ-]AN0Q5O-FbX5&$c[MHXc)VHa-o@\
<G7AH:PT<BeAs7;CPsod-k&XP/6`8WH"1SnIsNn[R9CI-QY66PUkL\a7+dldiDRu*[M(S4"I
,`Htdc;U0&WRC[5\\\`NQ5)\;@RRGZhsc<K-broMt\H$ruc[Ji9/Y,RiB_'SKVd`0`NFS'eq
:HK6?V_@$5S:$::$?WCq2pjU45FSo<%u*c0`/DZC,]AM.ML]AJgmYLYnm>H<21G)Xj"`Y@J>DY
2r[9JpMJ*B?A)9F@I#XO]A6Imj3C=QohFSMSIpq7)Wo>R+5s3rcGWKKnICTr.aeX'+hkp!$L7
&3*52<<paSF5KKHoe_eN+*QHhh^:i^,hYNb61O[c"BmGM!F"(9+FAPWs!:"o&Z"4c_N[`#pQ
XRbh2Y5b:EbfsV?XM3<SJK53#F:=_^@$`A,9!FDq-7jDSMK!R445C'@d&k]ASWPmO=OA[LV_,
6`elc&f*4U8C'RlB&F+*rU)Ckk.U]AXduq$t=TH-qQl^p_H,,+p2Eeu@*A$^&+e!ZS2W!*k"V
i0g(JpnlOn/Kl,-2fcNE<DPi\]Af56VXA603IcpL(>)sCHf6#8dec>F8lIODCb&4YV>(714p^
[ZNJ@L2nXrEPd&RTnP*B,+DLEGC9jp9A/gmks6n[l*JGfMcH"s2Z%+T(B>X&;3V2U+OqFPe\
jCsU0ar-6&@4uHfoCoU$AX']Ae()p>r[rTtUEobVrFm"Lg=80l"kGm0U6-%qm^Z-b!;F^%0j,
'E5UESU$DC1H%8VM1(sJ;?)[L?,-^EtM):P':qJfVcn$1:!P6:Po>&lDNoa90C=mfR>a[LEq
um(nXFg#Ld(2:Ihp[dSjfhe(TG'*&l5SOi8S9jqjTqg@HW'-iJtsTG@F'gfssV0r%!5)EgE<
j=&GqB6R%W$,@R_reMN=TPJ<ekUK\go$K*\MK(>EB4btgTU+A>4"T8[=%bY:.UGVq=n[^)Mo
RPgKPc8lo1Jo3>2gmTY.@/>#pUJd:>?iL*C,O;:>?V&F:p?Ek(m0XSqc'eF4"'o6(Vdh5#^2
@qX-7c1M-8=O!HY1ptE#nNCC,;/E-'+OYP0bogZpgR2f?o>-Uad3&\o+[dW5W#1aPOP\ojK`
K40"9M\P,ODpGV`@]Ao>nCer\h91pNk24H*"2?#:YI]A2'(VWLbdf9HmZ?0t66?u?PTg/s__6g
[[M#O0Y@CTX(3,8J>.ff$9h\E>BH2\n2nWY*_id[g$?jkdroFEDX,p%NHnSlIsJQZpC[[sKM
mPCA6W&G<thu>_t_dsK/I2j&@O*aFYZh,o4pAHa<CTMgBi#"Q8NLMkG#%XGX%=lCt!$AV\Y.
`bJem"oA>8b(qE)U($lNPNUc4u]A-XnJZRh7mk00]A(iHlb]A9H/L:9'TtLL/U&g!l(_[/9f8/T
3FsUjMQ(a0o)2dpoej:`Ods$MBTf-F&Zai;>;UAVE%YgScWVr@__"O*ugm\q6Rm3b=K=S\tK
NJU2XnpjdB=JMAZQJN307fL[^,JN-PlZMs5?DfXc=661OM(F&;jSD&gJWNd/mf?hM3q.QPOe
;X]A7d>/BSUeELt7-'L#1JD^p/=Q\-T\EB&pud'Dm,`WT=SC?[/uXC7Ij6Tk0gfeY^i$PJkBH
l8s=tV)V,)m*e/=KE#)B^EnW:U1IuVBs$,E3'Z'h?ZbABMOk\keRVbK7WYD/L5l)8eu^FNQ,
1*r<N+ECYMD*ddS<b"hW#?t*qhA(:8SrZ1681<Xh!5^ghJ)o.C<6h`'a!l<ME8L8P1-p'3L"
^RUB;d\Z`478Zo8cU-PlqM]AuOrbDZF.gsXB,cT^iP]AuBOpP#E<o]A]APt]A^Qb<L24jD;;qsuq7
[4XMNIObb7t(]AXPr6nsWW/T7!plJ/c_6SO?Mm;S!SWFa2nb@=;%NOXRs<*-=%do]AG1/1En!9
*N$=J2D'"3N$V=255DtIgepW>uA?]AVDK-\(=!["I,UQ9TAPVDaEeXl,60kq3O`pO!DRCR5)#
<[YkRGo(+A%P+f-mp@@BD-KXMi-d.pn84US^_R9uXd>m-/J!,kUT3E69aY;%JVZ)%afX#<Vj
`*n6Jm6Vc3BB>,ce[D-Mi8dm4RT:NUQ!CY2&EO4q4F?,0UD*_l`SNV*E]A1G:*IEF4/8TdXGj
:>eV5FY\EV-<d%55=p1F[pSPbS>M'u$'QG(d2u^[/W01VUAt7NO4([3%0#9JC>G(3HWk^D39
AR"`)?tWORr9#aCK&!'4:emG3_#^G%i.":C"j1uOoMb)qOM$naV.s8Or4r%[l%(VU?e`Qp7!
#4C&ZqF!3lqsLkK0dHM6BT5=SMpKbY6*FF`)U'hCRaM)]A",9'a1altVSUO/h6Hjc/Uj@Vh.\
VEnkrSi:Q1AaGc9T^GBZZ"(3ncNb,74t/tfWD1]A<J5>6Uo]A6&#?=$\Y_47Ri=^@\/]A'ADMhq
V&?r,5=UpBmo=,,":1?8n:9[Io[5UJtPT4E)k.$5Jc7TT`HdDL"KblWGs^$Pi*`*62S,9.-*
3Lrqp^l7;BlM<1]A9+6<EHO@sX#S+a*pWfl6r.mP9gr#.ijkrt2?&i@:II8OuMV:`^.r!*f!4
Q#K_bl>M"`!%#;4+_KsD5AGl\=e>U9`XFQi'VA7MI3,SCeY*E]A%H?\Rr1%?:=ao0<OQrFH7n
O!ea!-P@!X$g?.XReM=dhIhjk%Gl';2r-'&1eiV>]AK,?j4Z^hrBErnn9>0PkC/DC]AY^p^YLm
NB_^f==&41D+0>q4%a),I;A0OetiSTVd3M.lp&QWG%+$Bp5+jHG%NXphV3R1l5-gWb<C.1mf
*=~
]]></IM>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</body>
</InnerWidget>
<BoundsAttr x="6" y="3" width="512" height="385"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="report0"/>
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
<TemplateID/>
<TemplateIdAttMark class="com.fr.base.iofileattr.TemplateIdAttrMark">
<TemplateIdAttMark TemplateId="78482106-1a83-4621-b501-270e7b119374"/>
</TemplateIdAttMark>
</Form>
