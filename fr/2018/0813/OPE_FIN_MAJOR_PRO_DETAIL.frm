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
<![CDATA[288000,720000,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,0,360000,360000,4152900,9220200,720000,3695700,2743200,0,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
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
<Border>
<Top color="-16777216"/>
<Bottom color="-16777216"/>
<Left color="-16777216"/>
<Right color="-16777216"/>
</Border>
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
<IM>
<![CDATA[m94j='6i"S+dJp.BPB%r_:[QQC)'Poa>JN`V/hJ2XeJ@bX@*EtarNeqPdY[l8m>-[$!jR163
5%4#UD\c;$2Ii!Eh#]A#)M%f!CAP5Ad@\3hb'dC=grhQq:apPSnF5^rSBQtpR_+BBC_DF541)
<nG3N=H?q74H?[CN4["4XSfVY9q.9&\NV+C1s(p<Ug>TJ!/q9t#4tL@qhBK1*ZtV50\N\Lll
_VObD[dWBS&@GcG+IrGG+T"I3rduZ9<Vun60CG]Ah*7,sS,V>dL,[(UV/LOr,P0aM8a0;R\"Q
t2Eos3YJ%:$iM!!OP>0!hM.4;%M:E35T!#kB8;q%:I5+e?[=m]Aa0!M$@49b9CBl:H3I0kW!D
kKMb#>1g1/<P`i9)q?o]A$4++&Sp[Z?IQ]A1ECk6:)dDM4n4fOr8Z$0h;iS1XBgEK=JA6BN,Zp
RNkQZbMAkmW&,;!DcLVS'o'lo8iero*.k`g[2TjD7[/@:j?-A6Fh7*o/=[W>tkR4ErN4D>)n
!#>lH;du@QniqtgDe`V;f80]A>kc0J4GT5i>W5@`j[>d]A)mUC_=Y#?Gr\`AJoZbO-6"mHX<.q
.A"R@[;YDZLh\/k9st$HF#m3I-"f4f#Vi[AGG^gpcp7_8KmubY<b4?Mqd+&)sn='8)F&Y7F#
1^D2E85G$/?Bh.;"WK>Lk$jdtJeij;e;i+'\Ta6YF^M1pYh`q^Y2YO1l@BmIKJ,RX6?(PL.)
%rB9ec-`:6BEouc+^7ZrLKm2185%d)>tnJ`A)cR#4j_`"^,p%>,V[H>:)q_6fW1*g.*=6q=L
Kh_AQ)Mn-h)[79YZ!#0BAA^TGK7?*0-Moi7fb^QITAi7t#T#!d?1Sb821,W&A,2cMF9Q@M:3
FGD7Bj%WAfYBu,RQYfD8.?hDm9li#k!-jGfZ6^m<a!Pr3sD"7pq-gs7;DU)OOeM0:<je?a?j
6?9`Rr,3-aJ0)Z\[QclmC<u!*I[<4iCW0+-S?m[9&jtZ=tjsQ4;E#/l-+P&<f8EO&4B@Bm4h
%.2^Pj8s+"-SQTI$H1Cu3bYG.0Z`HUJ^h[Nif,kU(sLTDS(_FnKUTFf/oRqMcr[]Anqab8$lt
\!=-W*KkU.iF<[u3l%&(Q,L:VW'>.$AeiW=:EFh5G9$L_,s!<s5=")A[EW6<r7a#U7m_XbeP
WAS++tkScJ92gIDmOHRW#le,ije\S]AP!e*LOt$_J_G_#DXr`S#W23mG9C7AAJeDl\g3F!Y/,
'f`El`)4X1\oK_"eVhZ(P[M+"\rl(G\<KX%NfkOm$lLf6b<d<$CbOX[bk+t)_oWK`c\Icj<f
!m3noTmL[@s4,GVD[.ijFdCGpQ$@LECupMp85H(>b`4i.du8ap-l_k7Q2BbISRaD8i+6>:\G
L4@uknD=(N,V&b(M*0tT54QBj5C/bhU2Qt8l,c3$"D_KXUFR>f-Z`lV!)IPP)Lj<kc(Va#+3
#UR"YUda7-6iD$CTTu>S53HFV&tMq54:.X1$(Xch5]A51.bH\T%bZf--=Npi0\]ApnLmgDQ,W\
u3K\@b`j]A[Jh&Ct6qH1F,s\)Fb,I_C.oAZ#M32rUqDMO52TU[c2$t0dZt2-7^@CkW@%VX;j#
'ea2pI%EcIZb[\(ef9D&Ai$S\GV2:Udj*^*jjqHA5U-ZOb!rS<=&"Z_4jDJ>YMu>N\=:+0\<
lZ`L#JX/I*7;8<dK%QZ1XFoJCUE-\f>Vk"I@7*6cBX]A8^qTUG0dN;?e#IAPd.Ja.b5+ZW)e)
H9]AlW0eY&[]A"[Z,WYY+g.8UiJ]A=3qb6]A4)<85e;/pL[jXrH4YaW:1G&mI^77FDFQ-J_.[O!=
`dfp+c(-j+VhkIRO-]Abs9rpM[2FqC_+uI)PYt!h4&&r6;#+W":fMhs/*GI+HADjVK[Bm`VL2
(D'L9cQbgB.N-8T>E.<sIP\S?\iBd_F80d]ABWNBU[q8jj*KOZjC-Fe0on!-'5)J[[@g;=]A@r
HA!V3q6NKm:d`R7^OB&;7+e*d*S^jOai[86L.I#4G9R,EAKO[]A\EQ%Dd:gOQ*$(P++Jonu"E
":i]AOcS-?SN*mX''++$@[4ocnYr/]AMLl;_Zb[NCMR)`H4m<"`0$#_eIS<o`TT'oG'(2(:]Ap#
K7RS.3XK9*YG[?B$K2Q7,i_(tj%NH?-?1i\_Z[TF:J7_Mcb-Va`<I`SHu[4$j24*(aH0-ulM
dmEtpX5H*;X(J]AF[Eui8b=#V(b2eUHH)5iP:,9.+LPkd[;O;5cHao+3'DA-"W%T7f)P\'N<r
u=*&5B4)WR,D_S_?+uo(XXEq*Z?>VP%*<W7C%^=HE%1$&jkjW.G'ZRn."]A=j2S/C!$MYS:(4
N#>*r=i5IOhLiL@X6MG_!7#<T6f^WYQ3[&f*?nYKTaRnQqK.lpGokk<ZbjZ?31^LqVeJL2.n
ER&d'MaX-H"(WIf!f7,P]AYpP:$72iKoiqgN+I")Rd*u5a-*9tgk#:[=Z=S.?+Y;`%+F_)#WL
s"\b\UT=t0W$fN`+T"Hb<[;d?G8?1?op6NN!8m+#hYJISP64XCqXQb(!c2HuoiFbb@]AOHiK$
9X+>;M3nD-ALUl'<KMS\*)KYj&PN`@_kB_'V<Rch2GqW&<]AC`YP_V[VWf306)jYlc-CJ\sOi
l7NV+c+8:g]AOm.0n4gM4N7GC'KN($s&;XeTJ/qr`/6G"5N@N(n0)pKgCq";=1/p6>W^6\MiQ
XR+^fn@r>V/@qkLS2+_ikEWWqRULk%4OtnE'6@_;]A=3UrgHgm2l.hD7('n9d*oM:2_=)p&Gd
bR-R4j#RUGQlHf/b2I#)16[+NP;tO(':/=EiloC`D6MgiF8HIqj@n.h.>W&li(M'h?cG1D(`
"U/!#bc&5I1bj$"$37&N#k%o^TmdKd2UFnYF[2H`Fj,n6TW7FMd^=\AF#Yk9S8hIJW/-TUbg
K6%I8^0G=oB!KY(Bkut^"j.lF8FAD9!uQZKNS"\6f4nhFi,\?!nP'^s,:'_<W%?c7r'fh*r7
#WWWSNZ9L.8$SSeVp%+uIaY,`W#j@X^lV.QYAdARsa\]A#njFF+&'fc-WP%X@r&Th=nDUULOQ
^kJjBb<HD:HQBt-ea[eBSHEL(#'18/>`1,.JFpHQE@^?_",ZC5CLt"hp@O437Z0LCpSlnOoJ
7;!XBLWXulsIH[SQ+j@+MK(;^(]A!AkCPY%;9l=)AB7//a!DUMn-!X_EMj-$eF_T!d6o525F>
p('_#;kEu5@<Jg?CXX`P$X[ZN%rlM5QJ&ls-F0$;[=[ZO`!QB+G?7('?eJ4r.-hg)(BAMRiV
0$`Q!fjr>YeV]Ah%ap6'/%Rn<Y$9L`87%?O07U+C_a4f8QMTm5;(u:i1;72Rpg6na9P(BD"o#
]AkR39dN;iKBZt1-eu8,bo:VN^Q?aY#`U:?H0WM7=W=2k2j!_AoJL-d_DG@2=AH;bHLl`M=sE
C97$Z-i)%C(-/B,iguQr$/Z^r'<dE!b;L\.bP(@AL1pbcDV8*]AYC]ADQ<[!/g?s1,)f'/6%(N
]Ak1gpqltnWH)V3_Y&l[/pHTPm2inURB2a?a^@gGCn0k6oAj0hiq=0rk@^f_"Ke0t9Z<E@\i@
"UDBc`(OpAQ`coMd3H)AqP5MnD;?tRJ[*2'ej$!GP-Npo[thAgAU.:6j[CmIZ*GSan3`$G#3
^.LpOEO7JE3Y@l-[\uA^kZO\,L_TOdVW!K>>#iBqgoJi8@dQ\dSKTm6p:N$PAD!Q,r$&E>cJ
.CA0%klX8$muml4mpeWBO!mCek>jOB]Ap4R[[iLG.<%05+)ab3-jV7%ca^/\pu?Wcd>oQoE@A
p8^H.kn]Ah]AC^X#\W:s=FoMa:P]AI(4n`&Qg#5]AbFC,0]AYj3->4?OCt>&rK_@[p5)[oFEj@!J%
=P4o#<(]Au80l9M<kW^8Ec+LG'mqZpDQKo?\giD:J1(O0Mc$t+(6sF]A9Ur8>MY&9M,]Af5SXeg
\:Etb0g?q-L?'_sI?HtVW[j7=QZ_8rn^D@@'$d@XBPc/6--ZV?2/X]AK22HDn6@kO7M[kQa?h
N^V/P0UWgDfb*rC[Z6(RoZi=[j+q-+..FOe!=E*m;_XuG=*]A82eF"Lt=FW^A%mNYuQk`j++1
?#jgT->agdsr\!H_&#J.4>G;4N2p^6,]AXp@1$>1/[ga0B,`=U.V;V416J^1U1r+;2&I4_C_1
3*&gAMHu.Gn=(Z!a1_RNomlqWs$;\\'ODp'19<ME(FV^,@-cJ.+SGZt)RKIBS-[PT(kGt;F;
\=!cqn#b9T[t+n!%hP$ZpM$U0Um[6Lusc8Q9d,OedgV1NrAf\o-b77G3g7)b6RXrYZHGBN/j
G,XF?rH.hfFbFFf!m[3Ll4`."8M=l9/o:a"DUX;Or/k_,o[.QQ%0_Jt0loU0F6'N.sZlXLjh
UK%lT3XbC2n&;obQ-ImE`d,2Y3bat?fM:3lj%R&^37BQR&Pe:/)qS,k5hQ^oK`YPtN,h<X$'
S,jf-q@b`p3R&9=Eh@ZYLmeFD7I.mtUDsqe,UO=-3*@XTZRB;^Qe8F;"%@\3S;qmB^MN`FMn
oc-'H?K)3r_dX-LNl,5Yq:l4lY%WqlR"bfR;-G\`TWVI^h%.R!V"8lln#&BZ6L8noQ!]A\#:2
oU3n,6qC=$^Bi\;q(!A!6G.p#*t!QSkl.q,oRPI>J3uehm;[Ni"cSX[]A3^mCVI]Ai#?]Ag:er"
N3of=R#%U(AQ?YC:^hK7uKK*r0,g,,jCqid%?H!2p$#0XO,`9EaQm.9CoK+7b.0h\OgVt"4R
aFt8g,D!'f?597kV4q>Cb7KtK2GM.8>%IEG4^%4q*aLM6!L7aQ-(">AETMMrR11S/<L_`Zbf
hZV&#M!c(kCEmm/(q.?,W6K[&j45+E3O4c.5,N`&6L%luGI]AmaqVSNAk(X&E$l9[*XDIn0"F
AK/]A#'ftOfDo(,8Z'me;Ka,<@-0`0ES5n^^=3uM$X&F\7To`St*='DqsXq(buC&$8Cf)euql
[4c-j-]A6Nl$`kh4Esk!,GVU8;b!fsEBkZ1I.#'bAkr406c45Y`W0+Do,[*B6+I`cJt0$`-$g
RFrladT4<jo""@Pm!'=P`ZHhI1-Hg'a3908eEa1mL5lJVjDQ7gu]Apo>70hM;g2q7g,aQCn%J
We&`RGBIUY<=Kb<^8>tTh6't>;p*\#eH)-%!K2ZIGA7(g]AfbABlfP/:5&%piq24:k06W\_.[
UT<SV(r]AZt]AE>QF5^*'g_*:Z-JuJjKj'"3W%0HH-O;g)e!(:!0+h7'jl#&pO8!rHY9&[6b\$
;<;=lued`]Au#J<rPp(UWg+,f&T)VT_^H:-%fgR"YmDCTqO$m;+6k1"LJY!XdA0.l<3W$qb5l
c/s$^CLSK6)^>.ndIkSs2@jMJal6&U[5:kAB7c$PhcrBLIdqgPIVGNkjT9sQb%ZWVc,W)YI4
C^[Gr?\ZfU]A_`'rtQ)AG4!2nZODXh]ApKTAZnuj_kkuB?=eiD)TA#:qOC=2Z"#f<TjE'2;UG'
73Z`e?aC;>SI4O%]A`U6FHE_11J+'S`nL;<!?Z<DJgAH>Dh7tFbbE(+,C-M>nW"6`9n0cUbCi
3>JCE<VlSbVYOi$n1"B/,j-jj"n8,/c/?%W?q%n:(2hV[G1cPcT3`kF'_`+^FpCQ7TIq[c>p
!V\G>mf*;%>QJpG_:$tYu/8i:KBd!?DjR,,U#I]AkRo<;*ljU+L+JOY"5HR^B<Z+^INgU(AFZ
<PA\@+B5VJSG.XC&7%ZY?ZM[T7sY>M'jrYY51L[jd>C-UteYIV[pC+pK44!8;/S9_A.FUr3$
I3!q%,u-Za8\hcR/U*2p',s+7Yq%S%XpL-*np5'FnL7Xj]A+IV_V-j,%j1Xit.')bAaYK,nqA
kB:tob6+G!D+O,V2,KDE5Zo`@O!*]Ae7Tk%0><"-*p+`!Peg5Sa8DS2di?PPA$=@Cn26i'W[0
n]AF&(u[nef*XV,R_sgKo=I.%6?q8Xkt*O%R@TMc]Aa]AV0$cfH:ZR-TbCiEGMgW/>j8UFB#<!f
CIIf>f36mAHFK@D&ptr:fYWC*D*h7X+-G3!-=S2oHeb>98(PmlhM\kJ/6@)dj8QbW1]A:Y(4Z
=.7ba7VJ&/@D$ZOR"m*aCQ>sWb9b]AO)9BW_u.Fq+?Mk>!l4Yq@gBtg:05brCAUnc@;n53qHE
J%DC/H=B1o4/ZDLRfi5g9F*;m$hk[P'V+)o*NF<7%)F'49barC5"Z71heL,j3g@;=7Q6bir0
q5:SXGC0c_kY^[Ko7!!(CKW;0e&5S(SBRI[SdQp@HV$jH>nXM5kcA5h?6AJQ6_OT^5%oR@/]A
-!Q/A23W2#h0G%]ABQQ8u058HO6A^+YB6"r$7^Y:2ueRl-`NE%HWkS`ttNJ"Ok"ga9Gu\&gFH
Np.B-tQp]A`(b0rM<S+08gb\rJ)Eb@ik,F]AJ=rpsi<W`D24g&LRna:he.FQ2#h>s%ZO",$_$d
3-D<Ls_gs6\Q(\l-*qZq#:r*HgMsoh"VQ2#K+OnA"X+$I7:H&M?WmUn3paEjT(L#?2kX"?'-
pp8hdZSV*"$V@C%1)^j;f81uikUjRZaC%b5g4,V3E`<@ePbFjbk$i?OdUl6_!_CE_+'c=AM/
4tL6.On0i,)bq><ZqG_??R+>"^i=<'EQ$mu*dj5MnE^T%;@g:9CQeX0SKmW2_t^PHUNFRWGL
GXHbi($[)86h;RBT-EqO$1.@(Z78g+KSHUpKIl0aigWRI4!a"'(YQp*QNBfUrd&X@O,1V[U0
Vh5`>^fQQ[1*Mj4F%5^E:[[U5`Y2hA:aZmM1ofF?/H*P:J7j</gZI&j9%a<3ehKq;[c^E$h2
!?;1NE\?8Z4'arFQH!cE-[=`SMrG:V__Z?>"H6:&8kop6EtB>3M&d7I`#*BWs]A,-QBNFL6gC
qTl2;m&"Z\&<jb6Y@j2oqiQ.uE)er$g40'84(F@[DG-X]A&uJj&U[c<-"18pt#SNasV[1qAPV
0fKJkI.18P_<@$EK#fTRTCM:2)<#Pd/+X:TI;C+5B2@85]ARKmA]ARD1&/\L,-2oUE;8/&drKh
A:\lOlDCM[4'E#eJ"Q;5.PNW$@$qla8@k"g13:1/,!ZT0Ub+L96n1B)#Zl#fiQfp)CGgG8Gb
L5]A,ap,=ttNb@`BHag,6a&#,o99C<8a+R2UO2t)2NLTPL*?"Y/A5*]A\=;h.[GXZ2g5+0L5Bm
N$t^fdgP$OsD'kj2i82Wgc6l2ueWiJA@>Pn<;jt3p=bZ?l@^,Sd`:+jKRWnb^p&QLmh`;34B
Akr^MhO%uFul(=Qfi5$N9TA/Qm0]AO:<i"QCStHh._MB-8!\:[qENn#O;$O_M]A\fFrO$1Y'RW
kI!)Y3[F;Rd'0.nJjf(#^hSUK$m$(ac9djTeak^GBe3>%SB9)s+YkCO@-mpNrF/2"l1aH2ma
&Cbg-Q>Lg\$TQNmbB=5Q!S~
]]></IM>
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
<![CDATA[288000,720000,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,0,360000,360000,4152900,9220200,720000,3695700,2743200,0,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
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
<Border>
<Top color="-16777216"/>
<Bottom color="-16777216"/>
<Left color="-16777216"/>
<Right color="-16777216"/>
</Border>
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
<IM>
<![CDATA[m94j='6i"S+dJp.BPB%r_:[QQC)'Poa>JN`V/hJ2XeJ@bX@*EtarNeqPdY[l8m>-[$!jR163
5%4#UD\c;$2Ii!Eh#]A#)M%f!CAP5Ad@\3hb'dC=grhQq:apPSnF5^rSBQtpR_+BBC_DF541)
<nG3N=H?q74H?[CN4["4XSfVY9q.9&\NV+C1s(p<Ug>TJ!/q9t#4tL@qhBK1*ZtV50\N\Lll
_VObD[dWBS&@GcG+IrGG+T"I3rduZ9<Vun60CG]Ah*7,sS,V>dL,[(UV/LOr,P0aM8a0;R\"Q
t2Eos3YJ%:$iM!!OP>0!hM.4;%M:E35T!#kB8;q%:I5+e?[=m]Aa0!M$@49b9CBl:H3I0kW!D
kKMb#>1g1/<P`i9)q?o]A$4++&Sp[Z?IQ]A1ECk6:)dDM4n4fOr8Z$0h;iS1XBgEK=JA6BN,Zp
RNkQZbMAkmW&,;!DcLVS'o'lo8iero*.k`g[2TjD7[/@:j?-A6Fh7*o/=[W>tkR4ErN4D>)n
!#>lH;du@QniqtgDe`V;f80]A>kc0J4GT5i>W5@`j[>d]A)mUC_=Y#?Gr\`AJoZbO-6"mHX<.q
.A"R@[;YDZLh\/k9st$HF#m3I-"f4f#Vi[AGG^gpcp7_8KmubY<b4?Mqd+&)sn='8)F&Y7F#
1^D2E85G$/?Bh.;"WK>Lk$jdtJeij;e;i+'\Ta6YF^M1pYh`q^Y2YO1l@BmIKJ,RX6?(PL.)
%rB9ec-`:6BEouc+^7ZrLKm2185%d)>tnJ`A)cR#4j_`"^,p%>,V[H>:)q_6fW1*g.*=6q=L
Kh_AQ)Mn-h)[79YZ!#0BAA^TGK7?*0-Moi7fb^QITAi7t#T#!d?1Sb821,W&A,2cMF9Q@M:3
FGD7Bj%WAfYBu,RQYfD8.?hDm9li#k!-jGfZ6^m<a!Pr3sD"7pq-gs7;DU)OOeM0:<je?a?j
6?9`Rr,3-aJ0)Z\[QclmC<u!*I[<4iCW0+-S?m[9&jtZ=tjsQ4;E#/l-+P&<f8EO&4B@Bm4h
%.2^Pj8s+"-SQTI$H1Cu3bYG.0Z`HUJ^h[Nif,kU(sLTDS(_FnKUTFf/oRqMcr[]Anqab8$lt
\!=-W*KkU.iF<[u3l%&(Q,L:VW'>.$AeiW=:EFh5G9$L_,s!<s5=")A[EW6<r7a#U7m_XbeP
WAS++tkScJ92gIDmOHRW#le,ije\S]AP!e*LOt$_J_G_#DXr`S#W23mG9C7AAJeDl\g3F!Y/,
'f`El`)4X1\oK_"eVhZ(P[M+"\rl(G\<KX%NfkOm$lLf6b<d<$CbOX[bk+t)_oWK`c\Icj<f
!m3noTmL[@s4,GVD[.ijFdCGpQ$@LECupMp85H(>b`4i.du8ap-l_k7Q2BbISRaD8i+6>:\G
L4@uknD=(N,V&b(M*0tT54QBj5C/bhU2Qt8l,c3$"D_KXUFR>f-Z`lV!)IPP)Lj<kc(Va#+3
#UR"YUda7-6iD$CTTu>S53HFV&tMq54:.X1$(Xch5]A51.bH\T%bZf--=Npi0\]ApnLmgDQ,W\
u3K\@b`j]A[Jh&Ct6qH1F,s\)Fb,I_C.oAZ#M32rUqDMO52TU[c2$t0dZt2-7^@CkW@%VX;j#
'ea2pI%EcIZb[\(ef9D&Ai$S\GV2:Udj*^*jjqHA5U-ZOb!rS<=&"Z_4jDJ>YMu>N\=:+0\<
lZ`L#JX/I*7;8<dK%QZ1XFoJCUE-\f>Vk"I@7*6cBX]A8^qTUG0dN;?e#IAPd.Ja.b5+ZW)e)
H9]AlW0eY&[]A"[Z,WYY+g.8UiJ]A=3qb6]A4)<85e;/pL[jXrH4YaW:1G&mI^77FDFQ-J_.[O!=
`dfp+c(-j+VhkIRO-]Abs9rpM[2FqC_+uI)PYt!h4&&r6;#+W":fMhs/*GI+HADjVK[Bm`VL2
(D'L9cQbgB.N-8T>E.<sIP\S?\iBd_F80d]ABWNBU[q8jj*KOZjC-Fe0on!-'5)J[[@g;=]A@r
HA!V3q6NKm:d`R7^OB&;7+e*d*S^jOai[86L.I#4G9R,EAKO[]A\EQ%Dd:gOQ*$(P++Jonu"E
":i]AOcS-?SN*mX''++$@[4ocnYr/]AMLl;_Zb[NCMR)`H4m<"`0$#_eIS<o`TT'oG'(2(:]Ap#
K7RS.3XK9*YG[?B$K2Q7,i_(tj%NH?-?1i\_Z[TF:J7_Mcb-Va`<I`SHu[4$j24*(aH0-ulM
dmEtpX5H*;X(J]AF[Eui8b=#V(b2eUHH)5iP:,9.+LPkd[;O;5cHao+3'DA-"W%T7f)P\'N<r
u=*&5B4)WR,D_S_?+uo(XXEq*Z?>VP%*<W7C%^=HE%1$&jkjW.G'ZRn."]A=j2S/C!$MYS:(4
N#>*r=i5IOhLiL@X6MG_!7#<T6f^WYQ3[&f*?nYKTaRnQqK.lpGokk<ZbjZ?31^LqVeJL2.n
ER&d'MaX-H"(WIf!f7,P]AYpP:$72iKoiqgN+I")Rd*u5a-*9tgk#:[=Z=S.?+Y;`%+F_)#WL
s"\b\UT=t0W$fN`+T"Hb<[;d?G8?1?op6NN!8m+#hYJISP64XCqXQb(!c2HuoiFbb@]AOHiK$
9X+>;M3nD-ALUl'<KMS\*)KYj&PN`@_kB_'V<Rch2GqW&<]AC`YP_V[VWf306)jYlc-CJ\sOi
l7NV+c+8:g]AOm.0n4gM4N7GC'KN($s&;XeTJ/qr`/6G"5N@N(n0)pKgCq";=1/p6>W^6\MiQ
XR+^fn@r>V/@qkLS2+_ikEWWqRULk%4OtnE'6@_;]A=3UrgHgm2l.hD7('n9d*oM:2_=)p&Gd
bR-R4j#RUGQlHf/b2I#)16[+NP;tO(':/=EiloC`D6MgiF8HIqj@n.h.>W&li(M'h?cG1D(`
"U/!#bc&5I1bj$"$37&N#k%o^TmdKd2UFnYF[2H`Fj,n6TW7FMd^=\AF#Yk9S8hIJW/-TUbg
K6%I8^0G=oB!KY(Bkut^"j.lF8FAD9!uQZKNS"\6f4nhFi,\?!nP'^s,:'_<W%?c7r'fh*r7
#WWWSNZ9L.8$SSeVp%+uIaY,`W#j@X^lV.QYAdARsa\]A#njFF+&'fc-WP%X@r&Th=nDUULOQ
^kJjBb<HD:HQBt-ea[eBSHEL(#'18/>`1,.JFpHQE@^?_",ZC5CLt"hp@O437Z0LCpSlnOoJ
7;!XBLWXulsIH[SQ+j@+MK(;^(]A!AkCPY%;9l=)AB7//a!DUMn-!X_EMj-$eF_T!d6o525F>
p('_#;kEu5@<Jg?CXX`P$X[ZN%rlM5QJ&ls-F0$;[=[ZO`!QB+G?7('?eJ4r.-hg)(BAMRiV
0$`Q!fjr>YeV]Ah%ap6'/%Rn<Y$9L`87%?O07U+C_a4f8QMTm5;(u:i1;72Rpg6na9P(BD"o#
]AkR39dN;iKBZt1-eu8,bo:VN^Q?aY#`U:?H0WM7=W=2k2j!_AoJL-d_DG@2=AH;bHLl`M=sE
C97$Z-i)%C(-/B,iguQr$/Z^r'<dE!b;L\.bP(@AL1pbcDV8*]AYC]ADQ<[!/g?s1,)f'/6%(N
]Ak1gpqltnWH)V3_Y&l[/pHTPm2inURB2a?a^@gGCn0k6oAj0hiq=0rk@^f_"Ke0t9Z<E@\i@
"UDBc`(OpAQ`coMd3H)AqP5MnD;?tRJ[*2'ej$!GP-Npo[thAgAU.:6j[CmIZ*GSan3`$G#3
^.LpOEO7JE3Y@l-[\uA^kZO\,L_TOdVW!K>>#iBqgoJi8@dQ\dSKTm6p:N$PAD!Q,r$&E>cJ
.CA0%klX8$muml4mpeWBO!mCek>jOB]Ap4R[[iLG.<%05+)ab3-jV7%ca^/\pu?Wcd>oQoE@A
p8^H.kn]Ah]AC^X#\W:s=FoMa:P]AI(4n`&Qg#5]AbFC,0]AYj3->4?OCt>&rK_@[p5)[oFEj@!J%
=P4o#<(]Au80l9M<kW^8Ec+LG'mqZpDQKo?\giD:J1(O0Mc$t+(6sF]A9Ur8>MY&9M,]Af5SXeg
\:Etb0g?q-L?'_sI?HtVW[j7=QZ_8rn^D@@'$d@XBPc/6--ZV?2/X]AK22HDn6@kO7M[kQa?h
N^V/P0UWgDfb*rC[Z6(RoZi=[j+q-+..FOe!=E*m;_XuG=*]A82eF"Lt=FW^A%mNYuQk`j++1
?#jgT->agdsr\!H_&#J.4>G;4N2p^6,]AXp@1$>1/[ga0B,`=U.V;V416J^1U1r+;2&I4_C_1
3*&gAMHu.Gn=(Z!a1_RNomlqWs$;\\'ODp'19<ME(FV^,@-cJ.+SGZt)RKIBS-[PT(kGt;F;
\=!cqn#b9T[t+n!%hP$ZpM$U0Um[6Lusc8Q9d,OedgV1NrAf\o-b77G3g7)b6RXrYZHGBN/j
G,XF?rH.hfFbFFf!m[3Ll4`."8M=l9/o:a"DUX;Or/k_,o[.QQ%0_Jt0loU0F6'N.sZlXLjh
UK%lT3XbC2n&;obQ-ImE`d,2Y3bat?fM:3lj%R&^37BQR&Pe:/)qS,k5hQ^oK`YPtN,h<X$'
S,jf-q@b`p3R&9=Eh@ZYLmeFD7I.mtUDsqe,UO=-3*@XTZRB;^Qe8F;"%@\3S;qmB^MN`FMn
oc-'H?K)3r_dX-LNl,5Yq:l4lY%WqlR"bfR;-G\`TWVI^h%.R!V"8lln#&BZ6L8noQ!]A\#:2
oU3n,6qC=$^Bi\;q(!A!6G.p#*t!QSkl.q,oRPI>J3uehm;[Ni"cSX[]A3^mCVI]Ai#?]Ag:er"
N3of=R#%U(AQ?YC:^hK7uKK*r0,g,,jCqid%?H!2p$#0XO,`9EaQm.9CoK+7b.0h\OgVt"4R
aFt8g,D!'f?597kV4q>Cb7KtK2GM.8>%IEG4^%4q*aLM6!L7aQ-(">AETMMrR11S/<L_`Zbf
hZV&#M!c(kCEmm/(q.?,W6K[&j45+E3O4c.5,N`&6L%luGI]AmaqVSNAk(X&E$l9[*XDIn0"F
AK/]A#'ftOfDo(,8Z'me;Ka,<@-0`0ES5n^^=3uM$X&F\7To`St*='DqsXq(buC&$8Cf)euql
[4c-j-]A6Nl$`kh4Esk!,GVU8;b!fsEBkZ1I.#'bAkr406c45Y`W0+Do,[*B6+I`cJt0$`-$g
RFrladT4<jo""@Pm!'=P`ZHhI1-Hg'a3908eEa1mL5lJVjDQ7gu]Apo>70hM;g2q7g,aQCn%J
We&`RGBIUY<=Kb<^8>tTh6't>;p*\#eH)-%!K2ZIGA7(g]AfbABlfP/:5&%piq24:k06W\_.[
UT<SV(r]AZt]AE>QF5^*'g_*:Z-JuJjKj'"3W%0HH-O;g)e!(:!0+h7'jl#&pO8!rHY9&[6b\$
;<;=lued`]Au#J<rPp(UWg+,f&T)VT_^H:-%fgR"YmDCTqO$m;+6k1"LJY!XdA0.l<3W$qb5l
c/s$^CLSK6)^>.ndIkSs2@jMJal6&U[5:kAB7c$PhcrBLIdqgPIVGNkjT9sQb%ZWVc,W)YI4
C^[Gr?\ZfU]A_`'rtQ)AG4!2nZODXh]ApKTAZnuj_kkuB?=eiD)TA#:qOC=2Z"#f<TjE'2;UG'
73Z`e?aC;>SI4O%]A`U6FHE_11J+'S`nL;<!?Z<DJgAH>Dh7tFbbE(+,C-M>nW"6`9n0cUbCi
3>JCE<VlSbVYOi$n1"B/,j-jj"n8,/c/?%W?q%n:(2hV[G1cPcT3`kF'_`+^FpCQ7TIq[c>p
!V\G>mf*;%>QJpG_:$tYu/8i:KBd!?DjR,,U#I]AkRo<;*ljU+L+JOY"5HR^B<Z+^INgU(AFZ
<PA\@+B5VJSG.XC&7%ZY?ZM[T7sY>M'jrYY51L[jd>C-UteYIV[pC+pK44!8;/S9_A.FUr3$
I3!q%,u-Za8\hcR/U*2p',s+7Yq%S%XpL-*np5'FnL7Xj]A+IV_V-j,%j1Xit.')bAaYK,nqA
kB:tob6+G!D+O,V2,KDE5Zo`@O!*]Ae7Tk%0><"-*p+`!Peg5Sa8DS2di?PPA$=@Cn26i'W[0
n]AF&(u[nef*XV,R_sgKo=I.%6?q8Xkt*O%R@TMc]Aa]AV0$cfH:ZR-TbCiEGMgW/>j8UFB#<!f
CIIf>f36mAHFK@D&ptr:fYWC*D*h7X+-G3!-=S2oHeb>98(PmlhM\kJ/6@)dj8QbW1]A:Y(4Z
=.7ba7VJ&/@D$ZOR"m*aCQ>sWb9b]AO)9BW_u.Fq+?Mk>!l4Yq@gBtg:05brCAUnc@;n53qHE
J%DC/H=B1o4/ZDLRfi5g9F*;m$hk[P'V+)o*NF<7%)F'49barC5"Z71heL,j3g@;=7Q6bir0
q5:SXGC0c_kY^[Ko7!!(CKW;0e&5S(SBRI[SdQp@HV$jH>nXM5kcA5h?6AJQ6_OT^5%oR@/]A
-!Q/A23W2#h0G%]ABQQ8u058HO6A^+YB6"r$7^Y:2ueRl-`NE%HWkS`ttNJ"Ok"ga9Gu\&gFH
Np.B-tQp]A`(b0rM<S+08gb\rJ)Eb@ik,F]AJ=rpsi<W`D24g&LRna:he.FQ2#h>s%ZO",$_$d
3-D<Ls_gs6\Q(\l-*qZq#:r*HgMsoh"VQ2#K+OnA"X+$I7:H&M?WmUn3paEjT(L#?2kX"?'-
pp8hdZSV*"$V@C%1)^j;f81uikUjRZaC%b5g4,V3E`<@ePbFjbk$i?OdUl6_!_CE_+'c=AM/
4tL6.On0i,)bq><ZqG_??R+>"^i=<'EQ$mu*dj5MnE^T%;@g:9CQeX0SKmW2_t^PHUNFRWGL
GXHbi($[)86h;RBT-EqO$1.@(Z78g+KSHUpKIl0aigWRI4!a"'(YQp*QNBfUrd&X@O,1V[U0
Vh5`>^fQQ[1*Mj4F%5^E:[[U5`Y2hA:aZmM1ofF?/H*P:J7j</gZI&j9%a<3ehKq;[c^E$h2
!?;1NE\?8Z4'arFQH!cE-[=`SMrG:V__Z?>"H6:&8kop6EtB>3M&d7I`#*BWs]A,-QBNFL6gC
qTl2;m&"Z\&<jb6Y@j2oqiQ.uE)er$g40'84(F@[DG-X]A&uJj&U[c<-"18pt#SNasV[1qAPV
0fKJkI.18P_<@$EK#fTRTCM:2)<#Pd/+X:TI;C+5B2@85]ARKmA]ARD1&/\L,-2oUE;8/&drKh
A:\lOlDCM[4'E#eJ"Q;5.PNW$@$qla8@k"g13:1/,!ZT0Ub+L96n1B)#Zl#fiQfp)CGgG8Gb
L5]A,ap,=ttNb@`BHag,6a&#,o99C<8a+R2UO2t)2NLTPL*?"Y/A5*]A\=;h.[GXZ2g5+0L5Bm
N$t^fdgP$OsD'kj2i82Wgc6l2ueWiJA@>Pn<;jt3p=bZ?l@^,Sd`:+jKRWnb^p&QLmh`;34B
Akr^MhO%uFul(=Qfi5$N9TA/Qm0]AO:<i"QCStHh._MB-8!\:[qENn#O;$O_M]A\fFrO$1Y'RW
kI!)Y3[F;Rd'0.nJjf(#^hSUK$m$(ac9djTeak^GBe3>%SB9)s+YkCO@-mpNrF/2"l1aH2ma
&Cbg-Q>Lg\$TQNmbB=5Q!S~
]]></IM>
<ElementCaseMobileAttrProvider horizontal="1" vertical="1" zoom="true" refresh="false" isUseHTML="false" isMobileCanvasSize="false"/>
</body>
</InnerWidget>
<BoundsAttr x="10" y="337" width="840" height="127"/>
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
<![CDATA[1866900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,2743200,2743200,2743200,720000,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
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
<Border>
<Top color="-16777216"/>
<Bottom color="-16777216"/>
<Left color="-16777216"/>
<Right color="-16777216"/>
</Border>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<IM>
<![CDATA[m90lo;qJTU68"!kKi2h>(+%GO24`#UMFr/.8@7b-f-?Y`HdD3h&fbbn<='0X4S#ed1?Sq=XW
8#'6nbZU.ut1)L_(3B[4-_>BIX$+%u_&BKEOWIoA4[=+@g!'LFKZUmT:el9`DHn>&4/!n,NB
:j_o'UUFuA[bC;dN:eS7pa'7:q-pKNqKc\,,,EdPkq%<19/UklIS);INDbt=H:EC)S#4CoXs
2)@@IoFk4rm8/$RMW^q^5I8"TqsS)la,/l$2JAop)X#_5bD@u0tLC_JkWALhVN[Gh)Z9@H1=
iIdkt\Y&BWEC/*B5r3KFSOm6!+.;O^hUE)#D"iK9+J"c")$ZZ]AIiP1=^VCkl!p)c,k[\2r9#
:\2Y&<_%3IT395u+t-!WS8>#/guO+YM@k+WpEgX$)E222Mlc[I@]Aqd`,j2`AZ==<sF,lb=GT
XPblkn#[#\k6"YMokf9&2`cDpMrqRQ.6al3#)mKN(kd<KQZ3cRP!^LS4>$+PFtf4dTmRMWO%
84L1`s:H'&(BU.S#6Ff,-]Ak<a3]AuH?d<Z/Fg(W)^-d]A(<%lMWP[]A]A=gKV&%s/^Keduf8n"N5
,\rYF6mac2C7-qJ_">^PdHG>#.f6OUfbNup%$OS$!N7CL"qPQ*GeXKE\n5D<_3gOY8]AHO2im
eNX5'"13O=FYO"1*Rs7_BKPqX2'lXTKmGD%:QS*O7OT;8t.'4-VkPXh;$i0?n"]AVj^>`s=j%
YoNm<[JdbRP\[l]AD/u"<A($8j8=B2Gf:p`>M5/adQ!IaYH&W+PhJYIsk,'n_in0]A*;WF.ooM
p5aL[7\ONjpR@oW;aOBNF*B!J5o<f'RB(?7j:B'(k=tXtN^sUu/3s.[sQ+Y0-1^`U@c-fIs)
8+N(eEi<eW^4Q1q4p0QT%#GPXN*04=@m\&6(9Z,^$[ni@HqfW:_Mhp`8`.l#aQ6#W[(-/]AnK
&_QCdR(*]A3BGq,;;(Usq/fsCW7T0'$'XA9\F@j,Aa&g0MSj"r]A"aK]Aial<a%OND]A1[T#Qr]A^
e[6`"&c7,)]A*]A]A@+>hS</X'$R_KG,B->-$_YrUS:ARakR_[G30`qO_SI/EujMlqF]AGUb0r4J
6q]An8DiOLrXrh6-";akibM+Qr&XN-8r;jY<bN+@1jrYpR97Qpsif?/6)NQhCrN,m8=8?V_p=
X$Vn:#t$7.$]A07AXl<CtVOijPCmuP>9]ANHDBrW.%FG(6YeECfn%mIb]AWJ_hVMOi&bqaXT[7a
tmB&%_6;R#>YHbr(WW^A"ah^[^]A493/8ItW,I/o1->TQY1._YdV]AJ<ffnO6ie1Hp;/*N#;@`
cm1LnLU`I-;e`M(4l"rZ_eXohG^$."kS]A[<P6mH>c[QekhU5`Nm+R9HgYFIOEs.S2sVejcbX
nCol9#(*<inO%i'^hd#u-bOakU`c<*k-TmH-P^EK:S`G4gb;;<-JQbsXnpBApr<e7sj0(D;?
%*hNr7%mLS3Nr3Q@P3#kMgUY2V+\No;eT//FkV:_"KuC1\?!Z:qGp8)H`)AkIl+jA-!i?o[1
3jp3=&W+MtMh;@c_o0Q(J0qP60Dh""c>:`AQ?#JY29:&#-kB[MBUq3CNJ+j=N2N>Nq1.391-
!KgK32Y>-u;@UPZrm:d-P\L,S_:n/3ASb*V9G\X\CXuG(B';UA&)Es*3ZK+EQfPqi4U>Tg5D
6@Y%#IZ$/fCE0MQK?j?7n"*Wi5onS7bGq)Wt)q5IO7Acrm'!ur.'m6:WXO^RQNgH1f6nS]AM2
hgSgS1Sd6g$NMrPdn.1_^0S`9X>Y[5=3lt03apE>T-TW?mbeh`j<MPmG7B5nb9D4++!"5LiW
?)j^aL"'cfNC1#\#A:,CMS,\:ggt2\4F.WuU+D&Un_nIN)p;c+XmHOZZ->&H&Af)i=A+VDDu
&?_F)I2tGgqPU:"i'`cQLC?kYpl7P)<qjSapk3HtROlC_lTKMP0I/P;o_-5N<R*H5VG,4K$$
E%T1Yk*iLtr/8/Y)h@A^'0^o[bXfWRpXnOj<Z)rfL`PW0oQb,YD^NUP.^.PSt1uNCZmmW&m)
KXRl<bnPcCq2i/3hUDE'_*Jhm,pm>-_t37:$/uL)GJNAV>%URg9'6NfnCj//(]A%gH9J&NNM*
8LT\hG)LPhqU#+@O-"jo>RFe!,ul&J$0qboY(R:f'o@h`ndodLT=6%S6D<BR[NRkG&gBuTc+
&22$rhWGc.9t!`moApXZ4Dh89`Pm<bo7Dsf":9_$E=[P>7BPjKE/5F5iZd5A\4Q'kDGQA\i:
-ncXLCd3/;^CF:RP-,M,oH'Z""t^?9X\.n;`m;.Y2p:eE1>CiMie$rqlb\:$;u35kk&NlBN3
,N$4@WkqeLI`<8nR`!au;gYc<$M4l#_3s")2Uc5"6\itG+fp2kMpCpT-<t9SCq*XEt$A#%BG
>k)I4qh07h:+h\C"/c%:MaqEhEQM.X4Kmrp_AkSmqJ/$Aq%A+h#d?)U.T!UAc_eED#rIh4Pj
nBK#mA%9"=Jh91!r3N?s6q[0g'73]AWf3U;9m?O&L$A3("YLTDtcSYM[QY^G?('9ucX)n+r3R
kc1^bS4gR6b)SeeF$+#".!G.`>e.f\'5`?Xj.'f7P;m2#cS<d$kPi3raaBsu@==q$:1h%<XG
uauDTA&2/AjKf\e&=M4Be?D,tM@.K@$W@Qu-.rj4u$0-RtTt7gfnMr=O6:Gn"'Qc8)CBc79:
*3D&qA&F[R-0JndJU.8UZ).hmn]A[GX3i&kSeCX:9<hRul/?lIfGrMa6e9>*Hoc"5VKK@m&rW
3P//=OuHOLW2Ng8Yq%D>`i\Ln;2Qq;B.P30]AMb0q4,^C3a]A+qef]A/-`#HTc#i"R2<T"aH7U%
#D1?MUh417Ig6eIA%3o&]AI)2hV'UFt:oOVKJDI/T\MA2LEl2nE3FD^^aU9PYJJVJ^K/p3_JM
ZE0Y5aPsiI0A5ji^?rH/^Jp(=.X=`[[1jEUN-mi(^BlVqf;u6A#e)77&"M\bD$)reC-,bCeK
Pq"I34Alo?%q2OqFHCbh12IA<DKV(rTpAB0D!VeE7O,D)C9&O%Yi8#C1H40";Ro$"ao5Pk8r
<86kZ+&qG5\WLkT@0j^"$"U,Esk;@$)18fR]A\h?_oqqn#/A-ZJSQBD'mQ,=P#l@[bU%mLhf+
gW1A'47)m.EsE@Uo=mQifXdoG]AJ1Dr\?PnqtNT_(p!W;X#A7Dn@ODVJ:VET>neH)orJo@m$f
%LG7=6GP0b4=68o(B9\c/([,Z>D3IB\9,-Dup(/t,G.,o)HAd3FtesTGV(nS!f&#SIp%HBuO
qa$4"3AWVJpW0Qa1,oc/`rUauObq=+C1?<HQbB^QFfoi?=AN#nLaAtPn'DEpN.EHZhP'37LA
U.;R_KE]AB1>6DrrQV'0faa;n!<krZIWMbg3^`Fe9QW4!'Ti@caUL6GWlqSG%p[./bG.08@5a
>IdlKRfm$*NbXN-%Ipam+EWDjaR#Cq<Q_MdN0-`#E\>u"?'9FY;\qZIK#K9<:1]AmX@oP78T>
n%;c-W`>q*lsrtps24(m`MML,f1YpVIM`k1tiTrq%fX9Q"Xn>.!H]AMg9N>G+(3Bh[Weh,9TD
]A7lSGF-7I)\IjmrS/)$G@m3Xq`XQTbD'O/0_Y+A;$f8<C2RHgNnr_s+M]Ap]A`0b>N[K^bG,gq
7#4K-gL+sd4[:FOI>+?YVPs)BVg?N.=*(98blGuS_;uM14cM2F]A^46Ni3Qso^u\m$l!m4LVL
"K"bU6SVK'L;0d)m[2Er2U[3Krsq,HM@TTmP.-Thdg5!/7JQ&h-P*=.,8ia/>tkR#^dl;XS6
!J+sDPE(9h_"s/kc?RT1Dl[11fJ_?o_.ZoM'MT'9,q$!$-[KDn2^A7Qd*p%D2J2KVja_B=W&
geiJ_qAZ`D`&S$ns56`AiW9JL]A^Y$.M;sE\jj.R&i:NJ,"b+jn(1Ce?);l/E-IG3&Y-=TDX^
O&G]A5sb4)\Q`$8e?k@cth<7Fu1PnX/\&Zj0V*Dc)KE&5&Q)T;`N^LHp*/N[h<P_qj^OmQNZ[
J[J!!/Bm91<4\@8q'm%FjSfYM4g(6BRnl1I!/83($9oZ1FII#oc0P-p'mBn^K1hiJoBmr=Z>
r*"<=ENkGQWI>=GMJao^NorU)Gk7F>s=2k)XK4`KDS..U_JSLMb`MDPlK]A/G$npK#l2SqU,c
i&AQ1'411cdP`aiQ%'Y8^a_.S8X$Xrb'"hBkAApm.au8.9]A7-P\%-\MK^m7tL=4*gM<&$=B6
u=o%CTMS0B1\K"H4#O,iJYfjSqs$Hm#!`oBqh>\7#6^d^"o(5$?GfQ*`nutkq6G'N*cUl*f$
\.lRV$WkKAcA@)Cj6\EeaW(25$G2;+EL+DtWsI/O@CODfOGrX&C*0R21<["7;FaN`P6P+*&<
(8akokmi"t#j"`oR,T&-'X"/8*X9L=RoIK1[1T3WTRp,YDmtB'-osNORk-M.q4PH^IF"MB-n
u7lCpjq^\)VjOjU?a,As8NmXImcrn)?!jRm"%FDYL-:W5a)(i1s#5XL8W4"&7:*']A;D$/Njd
W!ST,(V;.5_Rs5:YIi8\lL_]A)n`4?`&L<]Abl,7o%k-%=%bcocY`NQt#.6`_l3.^8lYhgr/:Q
;39HLn7"LM"!eij=a@2UIl)Z1ZD*M!]A#m_a]A@n@$hc`:b#F,$$(?t58^%6,bZ$$KT\2@"`L9
lp#?X=$^nM&p[ck^CXYCFti^U]A>IGSJN[U@R;>ZUof'W3k7AA/=T%T0QN>,,0?)kpttj$3'e
)>Va'Rq"nB[R!!MU"RfDTR0$$<uL9=dD<f\,oJTD%CgZe^2:SNJ]An=ki^P9'Buga"6LX%A>_
0]A+m%^2!'_>;ehRRKlB.<X""LDradaE6p:^r*&b6Vq`+BEd5J>`q0/&Xj#6rA#E`ZKc2<g>'
CcG0O:;F6hF."[0^-mG+9WHnZ._l-*C5!R0A#]A-J'6d7D?5'h\o;$e\&(BoWubt'$F@2MX4.
"IXH9PhJ]AOp%M28p;.>@]A%cX!r4T4.G>Xm=U,edgLEiR5sKq5"u3%<4!Wo[ohL4DgBm4>4A3
-lLgPN+fB1D5@Oi!mit5gUo:/((4eVmW`iTY\+`rqMN6=2q<$Q(Sh;O:FmGRE'!F_O/,5:@M
1i)pb-_0XLI%;Y!()1gYC8_PcOc,lKG>WGVU(&J9'ks[&?6'&=Q]A:i;DWVaUSUen?8]A3oJTq
I/PFNMWt(E*%APPfS\oo9OUHf;rES@mUs@St5(Q9T55X6P\oO8]Ap~
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
<![CDATA[1866900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,2743200,2743200,2743200,720000,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
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
<Border>
<Top color="-16777216"/>
<Bottom color="-16777216"/>
<Left color="-16777216"/>
<Right color="-16777216"/>
</Border>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<IM>
<![CDATA[m90ls;cgP*+A9UOAZ2pBo#c&/`SPa<L^4TH'<Q,M,EuEeRIM%bE3Q':#nN:kaJ5MrlOlmhhB
`jid7"GOb/7\6#U*'pN27(>($(V_,6SDuJWTWdgiEN\9")4QQ/6l>;HD@Xjkos*^%_R%rpTl
2NrRkG;+lE!r>Q.LZZPLpDf*O&>d5+SFp,PcOo4Oq^ENW/7^g%=q1GbHe_oR(hdfL$:pW-1D
nP(P=8Hq*O';Fc%i.l=iqA%hgT/0uHIiJ;\U7lRgE/@m?@.?7rKuZKg%iY]AYM\<rDie&eqP'
(rKh0GmPE9=YY"bDR;Fhq_,_?P^FhGa@612<:"l3&i__$q_!#6tB_FhOJg>iK7p;:]A\072k]A
=#+.49C+aZp8FD+C;tsC9V]A#D]AE@;=oO<k=`mHORO5A:4`Q?A;*TH3-P<QSn`O/#/`>)nBI+
Hgr!e!D#TeFdM:VpDE6pt./UET6=@:ol\_qg;V!guP7W8(SAjctLL`'MAhm!A*udsK@*!YR@
r;-]AQdP[5,>o"lk"G7e?,.5k_1h^sm(=001Y@701.I`8gXlBW!r_iUFc:FaMXmT$`Nd>K0uS
H'OmC$Dg%I*K,JO9NPdiO7YF1O>pl^>Z>9b@It8Up96aLShVqQ`YKa5\<WO=Gkrm7c^S4&o?
dT)X`QD$eKhPdKZ<6NbLK0UkAL)7@f<34t1QJF,6[rZPV3C0$i#pAP%&`Y<ZWQU2G'3_H0[$
>S3bfBo>D,2f;qZrPo9kFS"X".D<AB?*=4l/*JWqn!GisjgMA6/\\!hR+$Vp4S9tVJLF>3<c
9pVLR]A$+j^2pq%WCC4=bXDs.s(YnoYK($LD'?`XV>KkVfH5bO#IdqeEZdEk?ceF:d1FeIRET
0Ngha6QCGU=aL;\He.T4R_C]A:+bo[m8/*1NONIAZUZbqli[k:&7Jj@=2a'0%cAqkaZ\oX;;^
,apFo%AnJ(=NX1U^F*f3XVG#)0g[8d1G9"@%KLP`(O!nb/&sf`LVlNQdl^:@d*bq.PWNcW-c
i4\YL<7YfuE!Mi4^UhkS5DS<'Kfetu1kmN%#"PbnjgO1RU:r_*'[i1lYE)53=$rs:E<4>]Aoo
^r1RnCBpTKk2uC':pP0Rlp2C(N7VTEPQ/e]A>)AV/jMkc'L'q5M<TTpn[h\>bCGJd050I7CTA
hCRqC-]A:iE!m+)_@="eEAWo+tg1SD.J2uBT:5KID\5=^,\N.:bOKe:,^"=&cIu6@!(niU.Qa
[nW2H40(BX?QQ+d1.q:pN4ebX(e7@mQDRr'QjqUF[lRat!hW,`EO.qO."g;a_Hf[:4&33-06
l'#>[FPson!AkJKXro.oNni]AM+*#%Sm2AWd!e3\3nnO2n2Hr'Y=Cf#U[\uN&1-OD>m9&%mbr
5GmpK7E#GOQL+6nG`hVF1/@,fOO8>tDD?6jHE[BM$uR#s\EK<CK\VH4Asm)9gp&+gAP&[_[u
&\MRtcOlZlThg%bGK84gTYK`Y2!0\KT>p8?]AYTOZYgS(+71_N9mJgpI?3.*Dpoc[7BEBONK]A
Qlmm)E>@pr+eFeE1M(eZ'K"Er?lh-E2,[b]A[Wfg*lq/lX!5]Ah)^de7t@\;bRU0e*\K$QFpF-
RXiB<m<b7^o@o;"),2;T`"bGF0c6Em(lt%.X;_D'G9#m/_mJ%DoDO/]A"/aprikf3XAf32Ct<
fA?XF?L=bc%A[Ci9%qcnh)fY"Dm)P%FmR(JV[_eROCNC+U!.Fa2#Ym2\DuKYjJfE/Cg6C[+V
;og60dFVYnN#(uZo`hF_7&O+G6]Afu$i?Q&uh'M4'X3[Aj_E0OQb:U(WnpI&0_Mn(5sQ*3fB'
5GE-$dn]AcuMRfNDl(4!PC^ubN''(,^rK]Am(Ads%<MDn;d<0^!qUj$q1$VG.sXQ.4,^p$802\
3=W1fGU[RW`gp"tfslTu&$r=Hm<#]A7XN61W@^_kLi6#\3Xo-h4/)bT(<K/0OJf>#4H\s/.`'
bh5&bA<X)P^[Z$1\:0TU92\.C[YZ[ZtS7MUhM1ia>2u_/;+<)hI[na??CKlWpWB$,>ASJ8Wn
oHAT`+`]A1m>4XDS7rol+k>^[7s5g+(`M5I(iLT$@-kXTkfG(E/:II+^@ZU^3*Pef@M,50@!8
G%D:V;i9l%4YEJo;hKmC>S,=!SIG"Gg%'#noQmnqQ'7)MI?I4>)`ZC>mp8.nD-rO_0=H#/;[
U4.$^M"8,GGN**jS:7p#St?rMCKr=*=Z="=iB`=c[SKhjag):H8YeuoQ.B=+)C[[B+fO./qg
%IUcW.3hH>!o2%3o)..f&RIk2IB2D`(VjQABMW-.`H=>l6#_<ioJ=+'239XFAZ`ju#U1C%UO
\T/2sRY7Y9F%Fn)5?*=Mta^3%qdf>SWp5;UfSjGWH.NjkBPoYLn&0'8oR+IJWfO*[\&!XInG
;ErBZdDZ>m"(A^rOWn'Xj%cNA2i@D0:VrI_)I`:/_Ri1Gb2&+ZV$q]A]A6_1@m\jE`*!uAWeaT
!EA3iMBfD*e_KhPUk:c5dm2*SAG&QT^kkjb!q[%?-WRcH.cZkGY;IM[#VDg^h!EER>e%5(%_
il.:spRlSf4?nhEe2>246'M!\3ek%W@_'B,*l[.=gZdt4>jJb2-rQkQ2[cVU+2\IR4RqS(/q
h*3Hr-,[;Ak^[bWmXM4j[1q*MVO2*qLr"_uIM2`36%[]A]AU0ONHDD)Ra3)jm*UY'r`Bc_8dW>
qVA;7H+YMTA&,5*<b?SK5\S=(Jn0[,]AMOAkO4hD,SL\l)9LG@g2q9nr2F,.br?&bS/#-=NN.
,YcNE"SnEGef-Dp"CUpe)I=O(L#JRTpZTFndH*n-Q_A:796'tQXbd84LBZ!4&]ADS-UPVM]AH+
asbH,l"Em-<FoCA$61H"NG-uHQ)beZmFNR$5^;GDCLX>f+b/V:sJ[L#K0qIi*Bp>J_V6/&C\
T<S)G+"T_aZ^fY,\9UMabNCF.]A!\m6V'Cnh[A@1%-:mtq=mI>BX[DSu67F#an)>:P@00t$J4
:<?0S)U,AMVr?$DO(B\-+K</Pn>@Idc-,D:I?C<\IY^#j.f\5mUNDoj!sqd3fQ;m6J)P]Ac&#
O>^[6Zc&FB@)$5F#N+UXN<tgmtqTbi-`H/<D7kqWq8U.e2Z9/`^)s%cYWm?l7RKI-n;5]A[R4
*Lc""5Mrn$A\.@j-[9?`_kU^';kT"T._uEQD^mVEUs\HB1a5Uj0ric=ns_BH2b\(>L6j6P^`
2GqO&?"ZS42nZZ>,+SF8@Kj`PmFhS7I'b]A_DmR2*)R"33D]A&DL8a?G:nW$j\[LrV$>up%.g[
QFB?b;T=a/M$raq5[h/1`%YCQ*(<WVXNAm[HptQn)//cV';[+,Ul>UN&*:Qr#NdU+E`HjaHq
QFQTd-Oc^oX14!M[faN+T=f^arORLS98I%8,"@0!N]A+;mYsH"U]Ag.OlNnLb8F<.bO113AC`h
/r2ff4=kik.W7Rq+k(WtXX9kkFplipF[.p#ln,)MR"LdOI3:06b#b#(Mi+!=/aPl,[AK^3*^
Fq3L`iqQ*8aCCIJ)f_M!KLB::1O@Qp?/"gAtfa1IVCjV?f%^]AEK-,06)BX%8)]AMZ7aHp1?<B
JGokPtVajT62G\,=-l:pt4kMXNF[WK?d<1r`&J4s8mE`ZmTH"P?t/`5WLa_8Mm)3):!5FD"T
b82;lXF)2MGetD(fVXg\VpkBjS=6=o2b6E7=*g]A'Q@5D/Q6#`o@K'%&65+iYVq/mp=jP]APkW
e$kYbHhH'gU`5-WuK,+@TeW^b"(c%2Xb,=3bV=9%VVgn8YDTm.F2hONtHK(Va-g5HX;H(I`o
mJgA2ZAT1Uc1P^QOQdGm=q":Nc[1['(oG7_gI8Fl@jg,;\Y]AqP<7/h8F?9NF*('#g-GfkFe'
9,9Tc<Qm',DW0-"I[-P60i$N8XB6H4pt-6JAP;`!b!XH+OS16:!CtHoc9n"03P2b]AWTI@3q-
h?J#;DTaqlhb%YhQr/u18WF9gG*%S4E8Ir'PU["2X9#*%c-Q>;?e(>1b3ONCaY[R.WuV%nRr
's_=N!N>o-6&Sl;cZceJKFjF;CiL!L5p07\O*IJkDFq$R<?$23TYMHYi?DIZnI=:LFsdB&A(
:`6MmFmXD'@P6;&fk<9bX!]ANb9=/FMbD$o8<T:!jI[*B.tSkTKZn5J?1iP/r>/RJPaY<*\@B
#SgCtV:VlNZMU,1'kjr[_2mjcYh8"1T(mOlf:[h$m!K)?uVW69#bl)]A.djiWaC+L(,5-Cr7Y
lk]A1OX80.29=AW\[BqFr/(orn-:cubKmOMm976AaOedSh#<>"96O&80@rG4M3QTeAY67rmD<
-[S%EQ%C\Rj*lA3m\7T5j3#rdCQTI;ALljBibk;FrsM^^hl"7f!"4+7]ACYi0R*5Q)n/E5:[i
%B>4!-^T("k-GO\%e8'MJjNPR/V(<F4>b#CDGuR!Z>Kg]A_;M94C"#rUdugX,6X12C3B;knc'
;&V-T8q@?G7Kggu3(?0ipKT+.asqS,&8"rIbb)/+5`>^Mh^g'Ka9T>k:4/b/#mXPe+lIs46m
d'qEFNA7i0#dGAalD;<Wt\0thZ?;=7$ha$K@07J9tPYpF;F4uJRrgX/lP:W\pb-5$<F\aMW8
urbTM%@,@K$Ydrf4s"k:e(sdX?e@cQ0o&qjn]A[$_2GBE(nOW&)d?:*!uXl:jT<&iRK=Jr9Qn
Nj,lp%Tl":#hO')Bt*@1iD8%T0(4ZM=N0,!M*0Ne[p("bE?@ep[_LG/_<6U3s3.==*:n>lc,
%9biWR<^]Ang/[b"2[#5r&KsMqg+U6aG$bPY;!A)F=Q8IkBf'KRAlTDe^c(q?2jQq?c(r1d6T
I4c&gS,nS:T%*WgHdhO/-ORHTdf5T>a@[WIaL34C(LbcZH_`-(/LE"sXnf'LYkNP8CeUJHeG
;NCU"SLC13@pUT@>G?VRC.<kgM\.;Wmkrbb(G*SLJh$1Lp6-S$2!l+Gn<X+<uVf#Bpk<0oo&
VpA,AXgWp#=MU2"Bhj!(!pFJT?SKjX@ntYLNhI&EG9Yi]A-ifO`Y_<ZW^'mu-"2(Y6!sYV:1>
"!!I0)In9(>tlF4Suc]AA4O:_[L$Lh:V@-aS?Bo:_(ml*AHQOZM-+U($P'.`=Uu.DU]AMF>5Z<
>%jS"r9r%_5B1-+Dbj_)cBEOmA!"I-Dnl0MeXMDFq_%~
]]></IM>
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
<![CDATA[1866900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,2743200,2743200,2743200,720000,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
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
<Border>
<Top color="-16777216"/>
<Bottom color="-16777216"/>
<Left color="-16777216"/>
<Right color="-16777216"/>
</Border>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<IM>
<![CDATA[m90ls;cgP*+A9UOAZ2pBo#c&/`SPa<L^4TH'<Q,M,EuEeRIM%bE3Q':#nN:kaJ5MrlOlmhhB
`jid7"GOb/7\6#U*'pN27(>($(V_,6SDuJWTWdgiEN\9")4QQ/6l>;HD@Xjkos*^%_R%rpTl
2NrRkG;+lE!r>Q.LZZPLpDf*O&>d5+SFp,PcOo4Oq^ENW/7^g%=q1GbHe_oR(hdfL$:pW-1D
nP(P=8Hq*O';Fc%i.l=iqA%hgT/0uHIiJ;\U7lRgE/@m?@.?7rKuZKg%iY]AYM\<rDie&eqP'
(rKh0GmPE9=YY"bDR;Fhq_,_?P^FhGa@612<:"l3&i__$q_!#6tB_FhOJg>iK7p;:]A\072k]A
=#+.49C+aZp8FD+C;tsC9V]A#D]AE@;=oO<k=`mHORO5A:4`Q?A;*TH3-P<QSn`O/#/`>)nBI+
Hgr!e!D#TeFdM:VpDE6pt./UET6=@:ol\_qg;V!guP7W8(SAjctLL`'MAhm!A*udsK@*!YR@
r;-]AQdP[5,>o"lk"G7e?,.5k_1h^sm(=001Y@701.I`8gXlBW!r_iUFc:FaMXmT$`Nd>K0uS
H'OmC$Dg%I*K,JO9NPdiO7YF1O>pl^>Z>9b@It8Up96aLShVqQ`YKa5\<WO=Gkrm7c^S4&o?
dT)X`QD$eKhPdKZ<6NbLK0UkAL)7@f<34t1QJF,6[rZPV3C0$i#pAP%&`Y<ZWQU2G'3_H0[$
>S3bfBo>D,2f;qZrPo9kFS"X".D<AB?*=4l/*JWqn!GisjgMA6/\\!hR+$Vp4S9tVJLF>3<c
9pVLR]A$+j^2pq%WCC4=bXDs.s(YnoYK($LD'?`XV>KkVfH5bO#IdqeEZdEk?ceF:d1FeIRET
0Ngha6QCGU=aL;\He.T4R_C]A:+bo[m8/*1NONIAZUZbqli[k:&7Jj@=2a'0%cAqkaZ\oX;;^
,apFo%AnJ(=NX1U^F*f3XVG#)0g[8d1G9"@%KLP`(O!nb/&sf`LVlNQdl^:@d*bq.PWNcW-c
i4\YL<7YfuE!Mi4^UhkS5DS<'Kfetu1kmN%#"PbnjgO1RU:r_*'[i1lYE)53=$rs:E<4>]Aoo
^r1RnCBpTKk2uC':pP0Rlp2C(N7VTEPQ/e]A>)AV/jMkc'L'q5M<TTpn[h\>bCGJd050I7CTA
hCRqC-]A:iE!m+)_@="eEAWo+tg1SD.J2uBT:5KID\5=^,\N.:bOKe:,^"=&cIu6@!(niU.Qa
[nW2H40(BX?QQ+d1.q:pN4ebX(e7@mQDRr'QjqUF[lRat!hW,`EO.qO."g;a_Hf[:4&33-06
l'#>[FPson!AkJKXro.oNni]AM+*#%Sm2AWd!e3\3nnO2n2Hr'Y=Cf#U[\uN&1-OD>m9&%mbr
5GmpK7E#GOQL+6nG`hVF1/@,fOO8>tDD?6jHE[BM$uR#s\EK<CK\VH4Asm)9gp&+gAP&[_[u
&\MRtcOlZlThg%bGK84gTYK`Y2!0\KT>p8?]AYTOZYgS(+71_N9mJgpI?3.*Dpoc[7BEBONK]A
Qlmm)E>@pr+eFeE1M(eZ'K"Er?lh-E2,[b]A[Wfg*lq/lX!5]Ah)^de7t@\;bRU0e*\K$QFpF-
RXiB<m<b7^o@o;"),2;T`"bGF0c6Em(lt%.X;_D'G9#m/_mJ%DoDO/]A"/aprikf3XAf32Ct<
fA?XF?L=bc%A[Ci9%qcnh)fY"Dm)P%FmR(JV[_eROCNC+U!.Fa2#Ym2\DuKYjJfE/Cg6C[+V
;og60dFVYnN#(uZo`hF_7&O+G6]Afu$i?Q&uh'M4'X3[Aj_E0OQb:U(WnpI&0_Mn(5sQ*3fB'
5GE-$dn]AcuMRfNDl(4!PC^ubN''(,^rK]Am(Ads%<MDn;d<0^!qUj$q1$VG.sXQ.4,^p$802\
3=W1fGU[RW`gp"tfslTu&$r=Hm<#]A7XN61W@^_kLi6#\3Xo-h4/)bT(<K/0OJf>#4H\s/.`'
bh5&bA<X)P^[Z$1\:0TU92\.C[YZ[ZtS7MUhM1ia>2u_/;+<)hI[na??CKlWpWB$,>ASJ8Wn
oHAT`+`]A1m>4XDS7rol+k>^[7s5g+(`M5I(iLT$@-kXTkfG(E/:II+^@ZU^3*Pef@M,50@!8
G%D:V;i9l%4YEJo;hKmC>S,=!SIG"Gg%'#noQmnqQ'7)MI?I4>)`ZC>mp8.nD-rO_0=H#/;[
U4.$^M"8,GGN**jS:7p#St?rMCKr=*=Z="=iB`=c[SKhjag):H8YeuoQ.B=+)C[[B+fO./qg
%IUcW.3hH>!o2%3o)..f&RIk2IB2D`(VjQABMW-.`H=>l6#_<ioJ=+'239XFAZ`ju#U1C%UO
\T/2sRY7Y9F%Fn)5?*=Mta^3%qdf>SWp5;UfSjGWH.NjkBPoYLn&0'8oR+IJWfO*[\&!XInG
;ErBZdDZ>m"(A^rOWn'Xj%cNA2i@D0:VrI_)I`:/_Ri1Gb2&+ZV$q]A]A6_1@m\jE`*!uAWeaT
!EA3iMBfD*e_KhPUk:c5dm2*SAG&QT^kkjb!q[%?-WRcH.cZkGY;IM[#VDg^h!EER>e%5(%_
il.:spRlSf4?nhEe2>246'M!\3ek%W@_'B,*l[.=gZdt4>jJb2-rQkQ2[cVU+2\IR4RqS(/q
h*3Hr-,[;Ak^[bWmXM4j[1q*MVO2*qLr"_uIM2`36%[]A]AU0ONHDD)Ra3)jm*UY'r`Bc_8dW>
qVA;7H+YMTA&,5*<b?SK5\S=(Jn0[,]AMOAkO4hD,SL\l)9LG@g2q9nr2F,.br?&bS/#-=NN.
,YcNE"SnEGef-Dp"CUpe)I=O(L#JRTpZTFndH*n-Q_A:796'tQXbd84LBZ!4&]ADS-UPVM]AH+
asbH,l"Em-<FoCA$61H"NG-uHQ)beZmFNR$5^;GDCLX>f+b/V:sJ[L#K0qIi*Bp>J_V6/&C\
T<S)G+"T_aZ^fY,\9UMabNCF.]A!\m6V'Cnh[A@1%-:mtq=mI>BX[DSu67F#an)>:P@00t$J4
:<?0S)U,AMVr?$DO(B\-+K</Pn>@Idc-,D:I?C<\IY^#j.f\5mUNDoj!sqd3fQ;m6J)P]Ac&#
O>^[6Zc&FB@)$5F#N+UXN<tgmtqTbi-`H/<D7kqWq8U.e2Z9/`^)s%cYWm?l7RKI-n;5]A[R4
*Lc""5Mrn$A\.@j-[9?`_kU^';kT"T._uEQD^mVEUs\HB1a5Uj0ric=ns_BH2b\(>L6j6P^`
2GqO&?"ZS42nZZ>,+SF8@Kj`PmFhS7I'b]A_DmR2*)R"33D]A&DL8a?G:nW$j\[LrV$>up%.g[
QFB?b;T=a/M$raq5[h/1`%YCQ*(<WVXNAm[HptQn)//cV';[+,Ul>UN&*:Qr#NdU+E`HjaHq
QFQTd-Oc^oX14!M[faN+T=f^arORLS98I%8,"@0!N]A+;mYsH"U]Ag.OlNnLb8F<.bO113AC`h
/r2ff4=kik.W7Rq+k(WtXX9kkFplipF[.p#ln,)MR"LdOI3:06b#b#(Mi+!=/aPl,[AK^3*^
Fq3L`iqQ*8aCCIJ)f_M!KLB::1O@Qp?/"gAtfa1IVCjV?f%^]AEK-,06)BX%8)]AMZ7aHp1?<B
JGokPtVajT62G\,=-l:pt4kMXNF[WK?d<1r`&J4s8mE`ZmTH"P?t/`5WLa_8Mm)3):!5FD"T
b82;lXF)2MGetD(fVXg\VpkBjS=6=o2b6E7=*g]A'Q@5D/Q6#`o@K'%&65+iYVq/mp=jP]APkW
e$kYbHhH'gU`5-WuK,+@TeW^b"(c%2Xb,=3bV=9%VVgn8YDTm.F2hONtHK(Va-g5HX;H(I`o
mJgA2ZAT1Uc1P^QOQdGm=q":Nc[1['(oG7_gI8Fl@jg,;\Y]AqP<7/h8F?9NF*('#g-GfkFe'
9,9Tc<Qm',DW0-"I[-P60i$N8XB6H4pt-6JAP;`!b!XH+OS16:!CtHoc9n"03P2b]AWTI@3q-
h?J#;DTaqlhb%YhQr/u18WF9gG*%S4E8Ir'PU["2X9#*%c-Q>;?e(>1b3ONCaY[R.WuV%nRr
's_=N!N>o-6&Sl;cZceJKFjF;CiL!L5p07\O*IJkDFq$R<?$23TYMHYi?DIZnI=:LFsdB&A(
:`6MmFmXD'@P6;&fk<9bX!]ANb9=/FMbD$o8<T:!jI[*B.tSkTKZn5J?1iP/r>/RJPaY<*\@B
#SgCtV:VlNZMU,1'kjr[_2mjcYh8"1T(mOlf:[h$m!K)?uVW69#bl)]A.djiWaC+L(,5-Cr7Y
lk]A1OX80.29=AW\[BqFr/(orn-:cubKmOMm976AaOedSh#<>"96O&80@rG4M3QTeAY67rmD<
-[S%EQ%C\Rj*lA3m\7T5j3#rdCQTI;ALljBibk;FrsM^^hl"7f!"4+7]ACYi0R*5Q)n/E5:[i
%B>4!-^T("k-GO\%e8'MJjNPR/V(<F4>b#CDGuR!Z>Kg]A_;M94C"#rUdugX,6X12C3B;knc'
;&V-T8q@?G7Kggu3(?0ipKT+.asqS,&8"rIbb)/+5`>^Mh^g'Ka9T>k:4/b/#mXPe+lIs46m
d'qEFNA7i0#dGAalD;<Wt\0thZ?;=7$ha$K@07J9tPYpF;F4uJRrgX/lP:W\pb-5$<F\aMW8
urbTM%@,@K$Ydrf4s"k:e(sdX?e@cQ0o&qjn]A[$_2GBE(nOW&)d?:*!uXl:jT<&iRK=Jr9Qn
Nj,lp%Tl":#hO')Bt*@1iD8%T0(4ZM=N0,!M*0Ne[p("bE?@ep[_LG/_<6U3s3.==*:n>lc,
%9biWR<^]Ang/[b"2[#5r&KsMqg+U6aG$bPY;!A)F=Q8IkBf'KRAlTDe^c(q?2jQq?c(r1d6T
I4c&gS,nS:T%*WgHdhO/-ORHTdf5T>a@[WIaL34C(LbcZH_`-(/LE"sXnf'LYkNP8CeUJHeG
;NCU"SLC13@pUT@>G?VRC.<kgM\.;Wmkrbb(G*SLJh$1Lp6-S$2!l+Gn<X+<uVf#Bpk<0oo&
VpA,AXgWp#=MU2"Bhj!(!pFJT?SKjX@ntYLNhI&EG9Yi]A-ifO`Y_<ZW^'mu-"2(Y6!sYV:1>
"!!I0)In9(>tlF4Suc]AA4O:_[L$Lh:V@-aS?Bo:_(ml*AHQOZM-+U($P'.`=Uu.DU]AMF>5Z<
>%jS"r9r%_5B1-+Dbj_)cBEOmA!"I-Dnl0MeXMDFq_%~
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
<![CDATA[1866900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[2743200,2743200,2743200,2743200,720000,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200,2743200]]></ColumnWidth>
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
<Border>
<Top color="-16777216"/>
<Bottom color="-16777216"/>
<Left color="-16777216"/>
<Right color="-16777216"/>
</Border>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<IM>
<![CDATA[m90ls;cgP*+A9UOAZ2pBo#c&/`SPa<L^4TH'<Q,M,EuEeRIM%bE3Q':#nN:kaJ5MrlOlmhhB
`jid7"GOb/7\6#U*'pN27(>($(V_,6SDuJWTWdgiEN\9")4QQ/6l>;HD@Xjkos*^%_R%rpTl
2NrRkG;+lE!r>Q.LZZPLpDf*O&>d5+SFp,PcOo4Oq^ENW/7^g%=q1GbHe_oR(hdfL$:pW-1D
nP(P=8Hq*O';Fc%i.l=iqA%hgT/0uHIiJ;\U7lRgE/@m?@.?7rKuZKg%iY]AYM\<rDie&eqP'
(rKh0GmPE9=YY"bDR;Fhq_,_?P^FhGa@612<:"l3&i__$q_!#6tB_FhOJg>iK7p;:]A\072k]A
=#+.49C+aZp8FD+C;tsC9V]A#D]AE@;=oO<k=`mHORO5A:4`Q?A;*TH3-P<QSn`O/#/`>)nBI+
Hgr!e!D#TeFdM:VpDE6pt./UET6=@:ol\_qg;V!guP7W8(SAjctLL`'MAhm!A*udsK@*!YR@
r;-]AQdP[5,>o"lk"G7e?,.5k_1h^sm(=001Y@701.I`8gXlBW!r_iUFc:FaMXmT$`Nd>K0uS
H'OmC$Dg%I*K,JO9NPdiO7YF1O>pl^>Z>9b@It8Up96aLShVqQ`YKa5\<WO=Gkrm7c^S4&o?
dT)X`QD$eKhPdKZ<6NbLK0UkAL)7@f<34t1QJF,6[rZPV3C0$i#pAP%&`Y<ZWQU2G'3_H0[$
>S3bfBo>D,2f;qZrPo9kFS"X".D<AB?*=4l/*JWqn!GisjgMA6/\\!hR+$Vp4S9tVJLF>3<c
9pVLR]A$+j^2pq%WCC4=bXDs.s(YnoYK($LD'?`XV>KkVfH5bO#IdqeEZdEk?ceF:d1FeIRET
0Ngha6QCGU=aL;\He.T4R_C]A:+bo[m8/*1NONIAZUZbqli[k:&7Jj@=2a'0%cAqkaZ\oX;;^
,apFo%AnJ(=NX1U^F*f3XVG#)0g[8d1G9"@%KLP`(O!nb/&sf`LVlNQdl^:@d*bq.PWNcW-c
i4\YL<7YfuE!Mi4^UhkS5DS<'Kfetu1kmN%#"PbnjgO1RU:r_*'[i1lYE)53=$rs:E<4>]Aoo
^r1RnCBpTKk2uC':pP0Rlp2C(N7VTEPQ/e]A>)AV/jMkc'L'q5M<TTpn[h\>bCGJd050I7CTA
hCRqC-]A:iE!m+)_@="eEAWo+tg1SD.J2uBT:5KID\5=^,\N.:bOKe:,^"=&cIu6@!(niU.Qa
[nW2H40(BX?QQ+d1.q:pN4ebX(e7@mQDRr'QjqUF[lRat!hW,`EO.qO."g;a_Hf[:4&33-06
l'#>[FPson!AkJKXro.oNni]AM+*#%Sm2AWd!e3\3nnO2n2Hr'Y=Cf#U[\uN&1-OD>m9&%mbr
5GmpK7E#GOQL+6nG`hVF1/@,fOO8>tDD?6jHE[BM$uR#s\EK<CK\VH4Asm)9gp&+gAP&[_[u
&\MRtcOlZlThg%bGK84gTYK`Y2!0\KT>p8?]AYTOZYgS(+71_N9mJgpI?3.*Dpoc[7BEBONK]A
Qlmm)E>@pr+eFeE1M(eZ'K"Er?lh-E2,[b]A[Wfg*lq/lX!5]Ah)^de7t@\;bRU0e*\K$QFpF-
RXiB<m<b7^o@o;"),2;T`"bGF0c6Em(lt%.X;_D'G9#m/_mJ%DoDO/]A"/aprikf3XAf32Ct<
fA?XF?L=bc%A[Ci9%qcnh)fY"Dm)P%FmR(JV[_eROCNC+U!.Fa2#Ym2\DuKYjJfE/Cg6C[+V
;og60dFVYnN#(uZo`hF_7&O+G6]Afu$i?Q&uh'M4'X3[Aj_E0OQb:U(WnpI&0_Mn(5sQ*3fB'
5GE-$dn]AcuMRfNDl(4!PC^ubN''(,^rK]Am(Ads%<MDn;d<0^!qUj$q1$VG.sXQ.4,^p$802\
3=W1fGU[RW`gp"tfslTu&$r=Hm<#]A7XN61W@^_kLi6#\3Xo-h4/)bT(<K/0OJf>#4H\s/.`'
bh5&bA<X)P^[Z$1\:0TU92\.C[YZ[ZtS7MUhM1ia>2u_/;+<)hI[na??CKlWpWB$,>ASJ8Wn
oHAT`+`]A1m>4XDS7rol+k>^[7s5g+(`M5I(iLT$@-kXTkfG(E/:II+^@ZU^3*Pef@M,50@!8
G%D:V;i9l%4YEJo;hKmC>S,=!SIG"Gg%'#noQmnqQ'7)MI?I4>)`ZC>mp8.nD-rO_0=H#/;[
U4.$^M"8,GGN**jS:7p#St?rMCKr=*=Z="=iB`=c[SKhjag):H8YeuoQ.B=+)C[[B+fO./qg
%IUcW.3hH>!o2%3o)..f&RIk2IB2D`(VjQABMW-.`H=>l6#_<ioJ=+'239XFAZ`ju#U1C%UO
\T/2sRY7Y9F%Fn)5?*=Mta^3%qdf>SWp5;UfSjGWH.NjkBPoYLn&0'8oR+IJWfO*[\&!XInG
;ErBZdDZ>m"(A^rOWn'Xj%cNA2i@D0:VrI_)I`:/_Ri1Gb2&+ZV$q]A]A6_1@m\jE`*!uAWeaT
!EA3iMBfD*e_KhPUk:c5dm2*SAG&QT^kkjb!q[%?-WRcH.cZkGY;IM[#VDg^h!EER>e%5(%_
il.:spRlSf4?nhEe2>246'M!\3ek%W@_'B,*l[.=gZdt4>jJb2-rQkQ2[cVU+2\IR4RqS(/q
h*3Hr-,[;Ak^[bWmXM4j[1q*MVO2*qLr"_uIM2`36%[]A]AU0ONHDD)Ra3)jm*UY'r`Bc_8dW>
qVA;7H+YMTA&,5*<b?SK5\S=(Jn0[,]AMOAkO4hD,SL\l)9LG@g2q9nr2F,.br?&bS/#-=NN.
,YcNE"SnEGef-Dp"CUpe)I=O(L#JRTpZTFndH*n-Q_A:796'tQXbd84LBZ!4&]ADS-UPVM]AH+
asbH,l"Em-<FoCA$61H"NG-uHQ)beZmFNR$5^;GDCLX>f+b/V:sJ[L#K0qIi*Bp>J_V6/&C\
T<S)G+"T_aZ^fY,\9UMabNCF.]A!\m6V'Cnh[A@1%-:mtq=mI>BX[DSu67F#an)>:P@00t$J4
:<?0S)U,AMVr?$DO(B\-+K</Pn>@Idc-,D:I?C<\IY^#j.f\5mUNDoj!sqd3fQ;m6J)P]Ac&#
O>^[6Zc&FB@)$5F#N+UXN<tgmtqTbi-`H/<D7kqWq8U.e2Z9/`^)s%cYWm?l7RKI-n;5]A[R4
*Lc""5Mrn$A\.@j-[9?`_kU^';kT"T._uEQD^mVEUs\HB1a5Uj0ric=ns_BH2b\(>L6j6P^`
2GqO&?"ZS42nZZ>,+SF8@Kj`PmFhS7I'b]A_DmR2*)R"33D]A&DL8a?G:nW$j\[LrV$>up%.g[
QFB?b;T=a/M$raq5[h/1`%YCQ*(<WVXNAm[HptQn)//cV';[+,Ul>UN&*:Qr#NdU+E`HjaHq
QFQTd-Oc^oX14!M[faN+T=f^arORLS98I%8,"@0!N]A+;mYsH"U]Ag.OlNnLb8F<.bO113AC`h
/r2ff4=kik.W7Rq+k(WtXX9kkFplipF[.p#ln,)MR"LdOI3:06b#b#(Mi+!=/aPl,[AK^3*^
Fq3L`iqQ*8aCCIJ)f_M!KLB::1O@Qp?/"gAtfa1IVCjV?f%^]AEK-,06)BX%8)]AMZ7aHp1?<B
JGokPtVajT62G\,=-l:pt4kMXNF[WK?d<1r`&J4s8mE`ZmTH"P?t/`5WLa_8Mm)3):!5FD"T
b82;lXF)2MGetD(fVXg\VpkBjS=6=o2b6E7=*g]A'Q@5D/Q6#`o@K'%&65+iYVq/mp=jP]APkW
e$kYbHhH'gU`5-WuK,+@TeW^b"(c%2Xb,=3bV=9%VVgn8YDTm.F2hONtHK(Va-g5HX;H(I`o
mJgA2ZAT1Uc1P^QOQdGm=q":Nc[1['(oG7_gI8Fl@jg,;\Y]AqP<7/h8F?9NF*('#g-GfkFe'
9,9Tc<Qm',DW0-"I[-P60i$N8XB6H4pt-6JAP;`!b!XH+OS16:!CtHoc9n"03P2b]AWTI@3q-
h?J#;DTaqlhb%YhQr/u18WF9gG*%S4E8Ir'PU["2X9#*%c-Q>;?e(>1b3ONCaY[R.WuV%nRr
's_=N!N>o-6&Sl;cZceJKFjF;CiL!L5p07\O*IJkDFq$R<?$23TYMHYi?DIZnI=:LFsdB&A(
:`6MmFmXD'@P6;&fk<9bX!]ANb9=/FMbD$o8<T:!jI[*B.tSkTKZn5J?1iP/r>/RJPaY<*\@B
#SgCtV:VlNZMU,1'kjr[_2mjcYh8"1T(mOlf:[h$m!K)?uVW69#bl)]A.djiWaC+L(,5-Cr7Y
lk]A1OX80.29=AW\[BqFr/(orn-:cubKmOMm976AaOedSh#<>"96O&80@rG4M3QTeAY67rmD<
-[S%EQ%C\Rj*lA3m\7T5j3#rdCQTI;ALljBibk;FrsM^^hl"7f!"4+7]ACYi0R*5Q)n/E5:[i
%B>4!-^T("k-GO\%e8'MJjNPR/V(<F4>b#CDGuR!Z>Kg]A_;M94C"#rUdugX,6X12C3B;knc'
;&V-T8q@?G7Kggu3(?0ipKT+.asqS,&8"rIbb)/+5`>^Mh^g'Ka9T>k:4/b/#mXPe+lIs46m
d'qEFNA7i0#dGAalD;<Wt\0thZ?;=7$ha$K@07J9tPYpF;F4uJRrgX/lP:W\pb-5$<F\aMW8
urbTM%@,@K$Ydrf4s"k:e(sdX?e@cQ0o&qjn]A[$_2GBE(nOW&)d?:*!uXl:jT<&iRK=Jr9Qn
Nj,lp%Tl":#hO')Bt*@1iD8%T0(4ZM=N0,!M*0Ne[p("bE?@ep[_LG/_<6U3s3.==*:n>lc,
%9biWR<^]Ang/[b"2[#5r&KsMqg+U6aG$bPY;!A)F=Q8IkBf'KRAlTDe^c(q?2jQq?c(r1d6T
I4c&gS,nS:T%*WgHdhO/-ORHTdf5T>a@[WIaL34C(LbcZH_`-(/LE"sXnf'LYkNP8CeUJHeG
;NCU"SLC13@pUT@>G?VRC.<kgM\.;Wmkrbb(G*SLJh$1Lp6-S$2!l+Gn<X+<uVf#Bpk<0oo&
VpA,AXgWp#=MU2"Bhj!(!pFJT?SKjX@ntYLNhI&EG9Yi]A-ifO`Y_<ZW^'mu-"2(Y6!sYV:1>
"!!I0)In9(>tlF4Suc]AA4O:_[L$Lh:V@-aS?Bo:_(ml*AHQOZM-+U($P'.`=Uu.DU]AMF>5Z<
>%jS"r9r%_5B1-+Dbj_)cBEOmA!"I-Dnl0MeXMDFq_%~
]]></IM>
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
<C c="2" r="3" cs="3">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=toimage("http://" + replace(C8, "文件", encode("文件")), false, "210", "150")]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsDefault="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="5" r="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="3" cs="3">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=toimage("http://" + replace(if(len(G8)=0,C8,G8), "文件", encode("文件")), false, "210", "150")]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="3" s="5">
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
<C c="1" r="4" s="6">
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
<C c="9" r="4" s="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="5" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="5" s="7">
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
<![CDATA[m<a+\PLm6%M-*1\"KaYH<f06P"H<Ln@]Adcb:n0!bP+W*1,(bIs&/*>ng&lp8&jR]Al.^l:\U'
,!46Qooh#Uord&<J'R5QW3m3U]AZZHbQ]ARhK-E&hX`k%rhE9?hJ9=&p2Bu^>4:>IG[S;8U'3%
`kih4]AgAA?bLNIY#J95lurUW6Os7/V?7J1!nq;,Ca*f7rZl=``\k(^$c=-Nq/-r%r0*sc.^R
U'Ruau3XQoZ*7USFZ,43g'8ZfC=nQNjUE%'@H_PgXXi"a1b<Oo,<W=Y%oGL%%X3?Z+.5fF%W
:7QAe>2<(=t(4^tu-h%67k[%L!l9T7f<>\pV5"]AiU9W;<U>GdQK:)8+g71n!c&*XVC.W:Lth
/oCff#U$e<+BUE:<kSP+CjK'DnGt#I[r]AM@`i2sdAjiQr>i":bPQPrAi<q$Co8Y]AVKT2WNqr
.\*P-CgOlG8.Y>X<MG)+;%:'\Wr,VsCp*:#SD5.-?J7Yik>JE^NqA[TBRUR@[i'h%\;K8,@h
$X;Uq#?grdr#VRRcjU;Nn0["]AC,hg]A;ATn\Ld>p-QEga+R'YM3tjq!7CUcDKjbKC12f)D+\o
.oX\RTu[4846@hf@)6q@\5\m<qfe&"@r4"LYWI@\Jmg]AI)a$KQXAHiF=+0jhLBSR]AmOq*aZ.
g='t"VVo2?Uu$'>J9o(cFEg%EbG<?t?qlt!;6IIO57Dnj>II1?/qAao>+oG=/T(7\BSQ%!le
XDb.pg(7["4iKDE-_:*$?sf@I$dXYMa%5]AJl(="/V=bjnet2q,_H[QGW8M3%:=c=2cYG7"qg
fh0+)!CDaeQiO3db,'2Q?!r]AV)@5bFId*mT&E_Rhk%ZM-9)2/No6Lk!VOfBf*d##!Kf8.ndU
QH8iUe_PAm3pP"gfI/?\3O%/a#<pX0!b?=3/P-ZGnF#;('R/$k`a753sk>eJ<Z!u4Kd$-&RT
9Ij(drIr7J'gE9VYCq?E6ROH)ZOZJFL=\6%fh+N(!7Yp+a8k9%V6f3)lsjHe`;U%aIp/>)sF
kc%s@3ejU7p<^2&S4'b-Y'@uQ&q@(ca>`Wqa2'e)#$FFO[W)B0K?8n>I*(6Gc^pPc5L1g;b>
%*q)N7o*TLZ]A7T.QuWbnBJGBfo0^T:%_lCXD%&V!0m%UlX:N>B:[i/h]A9eUc^3_!C\`,r*;E
6!u'8;WIM;0ZY"8TD`j$Ynhe60s+:n-:3*SqKkD4t7t>=c*^Jm:f78$&oM#)C:a1Q`/cVW8V
!pSa3S^_%'8p(/jcr'(2QI4&J$Y[2+L8gOHuQ[:)rWa-*MEX:k71IUo)njDeQ]AZ4+O?`[%G$
_q4Xgo+0Oj7T;]AC9HCVMSn@pc)4SsYI^h\f'an4@Q-s+X;S_0n?X!PPI]A<!22)h^8^E@HAV]A
b]Ar;.i>dS[T&J>/]A6-7m2d/0#eQD=QFWf3KD_ECk3aUK#hodd';d^W*M[18ahQEEna+?h?\p
!DH0jRQ(nlP0ZEj'-Ih<>-%Y1NA_B9_L1C:TV>kBVN]Aq>c-MlHP@L.neB5F0]A-diK(^IHXQK
i.*%>Lb!W9n0lkZL]A[iCu&OmhbhUaa]AHZ,umM#'TB&G_%8@=U`@%/K0Y7q4-_QM=W_<r"8LV
"Z4WZqF:Lq-gI>$uOE-H*P3Ps@=J-V*&P0hjq8;0C*.S*LN<4!f%Nu-3kG6N<2orG\5l1^qT
Kkb4Ko<AXg:!&s;d$(6'GHS7<O.WC!CKb@bChR!"_8;WJjWCs;$]Ae9WK-)!J;I*IS-12XMUW
uq1ESYZd!#03k4TS2;dIVZkS.Ucm?)S2]ABt(/aRWABn<^Z+=GWW]ADRYF0OmcNuh'j8/LNZM`
6E(WfZdl]A=00ji-54U_I2T4,CAg4[,fsMZO52cJ8(h9aqQ1&%m#g='<BI=p*]AD5V=e)WP]As.
pYA\?CfB561>$F388gk/t9O,"^oC3o'd?hM"3R_+PTFUucg^EY]A",f/qhoY_Xg^6U0&cVu'"
6-DDa'r3&hq6\kR#Yg.?h^GgnZjW82`",,:koCXWef]A$i-iLc!=7RP^I]A6JGAfAK'X>G:D#j
R<O[Zgk7V%#V@#kI2e#;Tg5&'i-phX:j=2I@hHVl&-:Nq;T)m0A)W2be$4.).l".8ks=ZKLF
?"[L]AW=J/q[9\P@JI8<p.VS[[:]AdC+EW<m6o#QAE>l..']AR>"n^;kV[(4&?q9=]A#o)ni%XWX
E?Tkrm^Bd(f,W3cgq#*Am3o7b%RuN#7de&r/aR@J(8>2J7g;A5c=I;*aZ+_`T$&J?cG+Wm1[
c53</AKYl0Z[-Ocu<pIP&QH?QES,NWdh9kel=J#FVmTBTs#!pT5GT,8pWt6aYKf64=aCn&3U
0[3Q8F)R:nG7T@T/2*<bblFdY6Mo2-@V4Zf/j#Q_F]A4,P?5t@MVQR\EHFNc6jT!+f7eiS&cS
Qd<kVV?hEM1mh#9';(_]A/J3t-[0YK_Ylm=3Vc3uVd4^'gs_.&8r8GsKbY_#$[rO^"I#56W1S
0-8rePSWX:(nGO%H2P+0&+@;H<EOLsP9a$+f-\6bi)7XeD,fQco1$`8AR0l2UKVTuTgoJ4Ob
8tO39fpBD7Cq1,)mLU8-94!bJ@II+Hf0VJ+:7*fgdL)5*X4GD"YQAgGF:jaW5\>BYJ$c94Ck
VDC>&:6%_1;fQ2M.kYQ.0#Fn<L"ZZ0W7XDlK"";3f#tpp#Wl8;plKGU3cPcARpbQm%cfX-Xk
1^O+p@&(QI.J!#"XNUN[Ka?Tn3JI@Ji^S@:S=^,BP?$as#(_Gf(]AL%5]A@f5n8l3XDRcu,'B7
A_q]Ae88`VAJ&,7R,i1kAisD9hj[-M^_`NM"QfI2//LcNS3OClBApD\Qc+DPYl\6I5A(-<1F(
Q7dV4K>/ah@'_=*"b*J%KR&*;de)0_un+>;>u@M,_Ibr"VMVio+($XTEjCH2!kc!N)DN#%Jq
3L62S.`_P/eW\4l#Yj<HH(Vk!iOEECCPhpce/+Q9_Tto%!7Uk`Xqsh,cSE9ur,a.//GjT2d1
r7P6$OaMM8;kOq!64[hUK.0LXd>"R=6KC?Wt[7a6mSTZArPm$#S-kU65H+<-;5^e[oas<d6_
:3u-LmVf2Bkf(GnX<%D!"jB\<=9dPqlYFI#m;D_Wbs5q0^Dr9Yu?.WEDEHOHC%kI1&5A?W+n
#$2AX'WdVQPZk9K"W:MK;e$&rl]Ajkp<G^O?c=I"2![mro_CKp]ApS#7a7tWMY$<%%!.&IkAfN
kt`8``;3od]AL<Hi*"s0saa[fRW!8sqQL.P+;l29nH^QnBj>NjL,Olc<G(!Y0W4l@Vt6*uS(#
M4tn5dIEB78.Js2_KH'lDYWDCYc327_Z7=83($G:2+AL;b=S;RiuC"U?@W:A*!$4>#o+[Vpe
l"goFt[*'RUOa)CH4Gm+sJYen+JYYC/m$-f(nR-tf+TAJEI_@\rc-+3+qMa7"I;ja3,N>"'Q
$)H"$<k+m>iQd"W9=iW6]A6WQtdK04sI'+WheO1J)idH0_h?Z?E#l&NqOch`Do.Der?R8F?Z9
4L'm[`gAs7]A*s*:2Pgdf;lT^r!;;]AT&i\Ms*.%,C`a11T:!O9$WU0A;)53i@ZV0O!=cemKW>
fQKL<_JU9Vs`huK%eIcsA!(dCboMKiPTAOqY5\j?"J0]AU?CI39W_AXOgO.kZqN8-/Q"e/Cq=
JI&>V5Sjg<;JrsgKIcGOPOkA#Osjml8RSe45]AGXuG#YG77jB7T1+4PS1/=V(Z@.UKKL]Af=jD
fp8\-Ws#FE`hGC58OU;9G0WeO'[U'!!$t->/dIMo^aggMnA4P@CS?.a$a]A+*G[u6E2`#@gIX
h;2U(n0*eRXFuZ4WagUUL"6lo4'2;.jR48FZ'HI4QUciVTSq4@6_`nPeLjA4laOf@d49EmV'
&K]ArQ6724LU"bW'5:Hj=iCFgKj&@1ATV;mABQ3H"ndTkV'\@N`n^)ufmVqL)dU7n]A]A>nrpTD
bZ3qLbBnQ2`+G`9j+I4#;sObpbj6(rC"!,.T>A<A'fdTDh&r=phW8'^4%InX[CLD"QNBEo,D
L8"6UAmpoeEdnQV1s*l_kG",d-;#K@*\Pb`b(XGfK$G<[9Wd(Ghp>2c"=mi?!X>'QWY7#^(F
/F?A4gQ>0?n<?mZ=2g"NlmeLSZilNFjd$Hulu9pY0+"?BIt.bX!:)j^?D(dJYHqEd?`4(((d
31/1)H7>Mn9g\p-4$JuHg*YT2!k7Q*o\B$%U2T;H]AP[880TAJi]ADE/b&(&j(4SP6.m;cXD;m
'9K=ML,mG\@CA!nVRYjaXtbi+RIh)0]A._nioBWNRARntp0B)jk4su`_o4V`'UQN]A5OVBs6AY
)?OR-?."pjWL)<ZlIb^ghOfN'n70qV5XO&0'#<@iKPDkh2XO9T>/d:iDs``o:<GoS8/+mJS4
K?=oTin^]A(PM,U1YFskq6p!$.cse*MS\9XuQ4ud'0qXHPW-#u?:i:<V#L`A:ptO8?Adg'FFL
U5O:B$aXpnknJRe6LN7NA"qHqk)4=/dg8E<rl>.Uc)A>@@E/iG1f+gT_dkm9qlZLdMA!JXg?
6$J*td6Z:N['q)M-9SER`@';fq63KW>I.96p:GU]AgAG0TIl)E4)-S;+oFcQih)BN3tGfS6@0
<VXfM4+Q#*&+D`f`)u`3OPaHUAePW@oYobKrQ%`7X'[-%!`uDo+S44Z7B"kH!]A`4<B"3meSQ
^Qa\X$jPu[;5JZr_Q`7TiGD]AW`ua73UjB=:7=H>ZfNli@T;Vsgbfc6PrdXlE1b9i!cWm&>ZN
;H2=Oc[\ku_0VfuqX58AaXDq<T9';1Rb9/:4K"Z>]ASr-0;Mb)piZXb]AmiMJR[?4B9XtonAP!
C]Af7G[/Ra]A'a+o&r-M4m?0$m.Dk*aEEX5hRLu'm5S7L1?@[D(XkuA)Q)LQ.k))*7b6ejJFlF
E3$pSmFog9,i,>#%8GoSNiChA<lF2ZLo-%<Z*!)M7\s5]Ah\OV5$pdc*d?\u,4.hguhF>S;g#
Z.b%TS[c1Je4-VTVBkVft.jr.r9Ikp.P6RYG+D)bKE4H/jqeA-puo5L#FuiY2hH7K&W+`F0@
oLOI&"VfNls?/biJj9:h<BRsW[\8i2CdV36%A8e>V&om0[.:<>;\&f`e'l3@OtD9T3Gm3UD@
0eRufYj0.r:g"aZ^YLHuBb8fM2)='cim^*![pDOlc>&9KDsK[KIHX'e\3f[^TVLR`WCW_ohF
$FkPa60oKs4-Cb+[;T:l3+MLaO88pG<Sn5KXu/OW(Z*l+I<r!j56J<O_&_qZ\/-%c5W:SaAK
c.jG=$"4pfYTXENqQ[rQ;kU=(<7[2Zk>i6V1.Y+;?7mXG6",+uOAUSpub9BM&#K)_!`@1u=;
HXks:Cr1[6J"\]Akh.*=8;0Dpeb_Fpi0s"KGm!%X(5hK)*2t,N%T>32S9L;_8KD7]AcJhAKF_8
uZ5>Uff]ALrF1#3^035cV;(6[ht1YaP$M?s$(G6!tu^,.;"/W"I^Rd^D/4O;eVS5!W2H^M]Ad/
d'B/R(HCNeDDmL'HgiW7l8(AH>uRJ=`JC'PnZ[%UeMT:P.MaN4fbqisANp?%.BYK!>ORG0on
rmCHZn_e'r0u*'72_$8`ejjDZEQY]A4c=c*XBNhmKV>ao)L/L*T3mk]AV$O7F\$.fE2TWdAeja
lDbHf'2J!GO$JX.,=mMm-L"*&'HdA87XU+i*=gFTIoq^sFr`m2_l=2-&P0YqL[Q)_a`<c=\'
iS`r_1/2<.D2jr)C5tXe5]AHm'\0[28D&HU/I4g"s*!2GEFXcC#PK&V3[_f<//Ii!S/"Rr',]A
V>NaEpL,a\!W!=hZti$ZE\8M[TB`9<o*;XWYU"I>V$k7@r")l3$XO">`71=r9B845MA[4NcW
D):X\Z3(fL<;PjC&URlO"QiNsUJ@)H\PBGPn`SBEcMP`@E[A0<&Rih%X#C7,\Lrpc#0[h+M5
k7YB0U@0+4T)($NgDR2aF/]A:_\=Yij#8!9+Wspq&2Z-=SUo!#Q7ktiNM??;TX_tZ4gC9Y,O1
AKsq^fr?+<6,/JWIa]A?^6B[nag;KgkFb>M$qR"]Afe?[9'bLPj,V$(-OY&N0ua0'$%@j2C<Tn
tIO@TG-3'%/2;AS6[EhoAnT_)FG79B>0E[X<+G+IU3$Wak%2U+fRM3+%\7uS4mD\"r_%j4J3
>78W["$Hpp8mT1b(=N>Ue)#<AZJbP9jYP<N3hgV+[Rgd"utmN._Hl_-[18D09a7eHp8lApOd
hs?-DP=^JDq7<"CY+#ABQ\aN]A)R@3@aFPU@*---D^<h?q$rJ[1Loii?3@H@t?'c@LGF*$:Of
ZXgaWoQ"CChqg&M_2R/>i`"P0T<6.]A_\=((:"f5,0._03&p>7)H.n;KCh7AC9dlUNRjP8VlU
08=ipK.bYHY]A3sJA*OAZI.DCq'e;Q0Jm*.T&k?Tig!4W=`R*]A's^3Pi---!Q0kkR=jh):BdE
#?:en@$X-M1#?7T5]A)>f)0]A"B$=Nd6L]ACE-OFf5-gk49Q=f9j?8)pA>1qoL51>4-<]AP24S1b
3'?d<R'[o5b?5-s6RC,1,_Nei?M1l%,-??$(Wf/Wi>5ImsF5*6=@aB/*/-j4%Ln"n1Sis1A:
:jssihXUn<qYo+&*!O"a/oUK69#;:O$s;q.d%6Tu@TA^Af^P7&D;p_"b\^1o?q%NdguhkSq0
>7pm)6^NE3?,Zh#0g4rMsDiM&cC/SO9"i*>W(%pok5Ad?/nBQ"H@T,j"\9"@O+25#:W7dYlh
)nmE*rVrO:8U43E@i=W+LTBf;;H`5Ls^Y;CLX%HgIO5l3mL-ffJNFudcSe2+4;R(2Z]AITC7(
>U=$7o<CIM?ar&)@8n:W0Xu"dtHQ=om3`pYTjH8X\!7W2jtMYX$sF3Vn$'WrWf>IKka3<N's
3kP,BV0eWP7mP!UZ1;fQlRFl?HmE7;1=>V/]AX)ru8Y)Yb%mHq;0d[:cqKni1):G+TnTde(Vg
(j!VSOWCs/$[Bn!(V%RtFMeYraZDqL03g4P6?T]Ao]A)`mRYd03>-D9LZhO2UPnA<oViIh:^ia
c"6+s,pQTsXKLDM".jah6r1nnjDWQHqJCoK9'g.""rTXUU1fQH/.P;tC<1FRtu^RKO<UNL;T
Q<1,%8Jb+oZaO-\P($4Xn6M@p0T$n0l=G^]A$jXD9"p>%cK*5"dD^`&9#.mN%iG?+n13u+TdV
:c>6jl'`S<P\2kg>@6:\:=r]AgCAjPVCGuCOV_egmIF[WT3[)1U*H.u.06/H\b$daX6*sOk9-
d]AKS)ACgp/MX>?<l?c4b0!k`]AB3dM%I7@=n9k[b1qf?nRFM""H$2*?:;O1_f'G9_@#%CI/`N
$?RL>U<j1\iej4le-qY'F]A^M3,*#LBM@$g#`ViX_Te.5)Jg;\g+X*mUV<7KPJ>rj/ll:ca\:
D8p=Zr:?ic]AN5%]A:3YGn1lOeZ;j`s01'8>YcR:L*5G@&U#X=.c@[_;qOjYjW1`ReFZ$fpYZT
+*`rQ]A+I6?e%dbR.kpdC:W,s-\1K*6>*J:>'o]A!Kjem_g!URLj1G1UZfhZ2YV5g)hR3gHihB
JJkX.c(_r3SH&>!_-RU_M,?8+`!c)hY*5!'!?0bR*+=::E`;8Y[2^fFtqiWd_K7;fF-lOPb^
Y2jaD5k-_2NRa3(&"F7`X9o.Da0986G5V%&1REkC6E)M':u_]A;hkj!J/4j]AkA3b$WrPVEY_p
nCP:aZH2VX"\:R>_bS\>((Ygl"?9j]AWT`rohG$&E.5*_6V?qHtha:FL'm(bFgu[Qf6=MrE7<
e!4*jqk3)f0M@\qS9^-7r^lT:X@qL^,U+E0(Ubgr0M1U9O"I%:EMY)qp@N=AB79Z_]A8hhb]AV
/A"iH+3<k0=7YIt?6_UiX0(:QO%6_E03+*ZsXi`We9%fkf^ReTfKBegm<`/J>h-Gd#rr$VQJ
EHK,J1?fN:[i-<a\a""k"W7kgQ.oP`MpIrcd7i)BX,O3AkY;doZhi<VY>SLc#TfbVPun!f_i
?[I!\Z`_:?;%5QD*J5EJ(b?Lu_72;`KkT$Ek@='3c8WgJtHO-:DrXhAA,]Ai5I+<u2kh.]AU)G
a@CeKlDI.08_"YL&0.99n?\Leqnkpn%n:t$l7Xi+OB[md7KhGb%1>)5Xm&?=I5JDF_YaAN&,
9:r>P!2V"5MH>+++6aF_]AoN6=WJjDeeJDV]A"+cSD+A@r2mA&1B7oXAFAc%@eh:VZ&A$eK%2X
W"d@r=p')FOR%q,XZc5@FS\X:U'8o;\qnJBlDu-6Z`2,cfi6?a&dlQ`Gi'1DLN"D2>QUfBP4
]Aae![:Aa5+Iqds^AtNNZ2=Ci/>t]Ap_543IZ(JicogJ`eY^ac=NZlUQT`).P,2IEFasZ=X[PR
YlhNkl3:i>(oSTb?EG\ZA9m6Q_tbI6:9KZe6bq-uL_5,YbYro$t.&Gub>pm>qLT'II2@Yq^g
:&,_(8(i@+`sa146G[jM)g&F"%IEE(cI8(8!ZO9q;>.OON2U]ALp\<<0BBp?@7Fd-C*(.'O-:
\NWl=aSTOfOsj5)qW,-&3eq3T2pAlC6>ejB9LhNUDb`8Q9'"mRc<n=YP1c4I@@A@@-h/@K3R
:.'P$9H'a#A&OlZ0lL5rN^Dfb!'c=04^7V(_HDfA_^OIu'pQ-"tr:jf-^r`c:riGRU14VE+J
!(^:>&1T^<^J`0S@[3VSMZbWrq9,`3d3kC+u3'Y^cVTlT70>^J&c'A2&k![og[d:68nLskKg
R$]AI["%ghW1@2e=;jNnC_+!%hqC+1W;TJ4j'>TA@&LPo@'=gt,I24OHa6,Q3oif5#_tFrb9.
ZH1h%G^9no5G*B.cuX/HpUPbn$T2IXs3+%j0."b"9t[@mbo(N'fJW%n#7PY.n)(YNn!R^OY"
gfa@^)YnG4N)E"]AJ&:,<j-=G66#W[uDM6W0X!#k6Fb?)>]A9XILjkr9'4nW)&=m;-._2fc$eX
\m>h*eVTtL6=!h?!9^nO"@JP8URR"HQHgXjOHh=:lPu>q(Q'a]AH7jcnbbOP@o-ADDmlem!i8
8Fs6B>Z<_FV$&8h/b7VN_@ks)%K==gnXKp9sT]Ad^WFi(2,WTC[I`:>32*s-HMk*DdQVA'A$2
8F#410\Jj-f)D2uKocuo@MGWi0#,4^_58S.SWc5"0!(d6`(KOZ<[.]A$k5;=Oq$DMMQaIVfrI
de6ZJ-0ge>6FuS_OeV[JVgSR%3b"k-l@5bTN-S2s.3.Q-9nY!Z&;@du40N?=(=l>7g\q4/Ig
or68$;1#U:=u'^CB<?ZrfL`$ese@9BNuFm[A?Vbg6Esh#`3?IMJ?TgQ'^J?Vr\V4'GMX(V\5
A'>STQC#A3Um1Ynb[N>.SJ38\R2k-u7s(^WG(_;P5W7")m;!l;C)<n8sM)8:@.12tf*u2eGJ
Y8+B@"/)>TC>2?CfCSX5q$S=W\cN/BCC2)d#M51O]AR1rC&aW[n$-)C96!\<pod?fj.[$`J4R
ub8hu6c$qr6hG2rQ<s5-Di0lTl_:8^Ds@]AZ-KCVGn'9r%nBg&$ZVH[amCmn##]Ad!<r]AkoG,H
-$8R.(k2Ob?*6>tKecAF/D#%NDMQPZ7[O>Wpn!-VPttYmiBu#hh\<2(b-Yn5ZN#>,a]AHAJ7`
?J"c4fW%-'*DRJ;j6`+tJbd[DZj5lVG)>Kpo2Y>,r1(m8`0h`';T-C+e0P\b@RNYDAuC[AWd
Ji^6<.hj5UN64RMoq_Cn_h6Rn!8.TEP"gsX9/Tb8+AVl9;_PX,2f0XPpWHH"KS`_@mP)Ca%,
)Wg0W$DQ>jhF,jJ+cHW@n/%K(n0i9JJ7NDaRo@XX8%0n0)H#LV0MSa/pA^^210d-@DdHGh\o
tG.uK.(pcZ5Rn`@r#Mc:O@;]AA3l@=RiV<$rNpn8<e!=DN=Y+MDn^oRSt#"1hhS^3e8<Q0C9B
ToSuqhVJ'Q4kf.Cn\5&~
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
<C c="2" r="3" cs="3">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=toimage("http://" + replace(C8, "文件", encode("文件")), false, "210", "150")]]></Attributes>
</O>
<PrivilegeControl/>
<CellGUIAttr showAsDefault="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="5" r="3">
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="3" cs="3">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=toimage("http://" + replace(if(len(G8)=0,C8,G8), "文件", encode("文件")), false, "210", "150")]]></Attributes>
</O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="9" r="3" s="5">
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
<C c="1" r="4" s="6">
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
<C c="9" r="4" s="7">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="5" s="6">
<PrivilegeControl/>
<Expand/>
</C>
<C c="2" r="5" cs="7" s="8">
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="9" r="5" s="7">
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
<![CDATA[m9=p>P$,7!U5Si478;K)W>nP]A`PtM+!N2nF/]AhmBVV#!R=eVR8!<HggVpT$+dk1j$;`%e0Y'
<7:XOOnE=^%QZ*>'"i'tM$`]AZg"rhm)dCn'%2@SoaHE*a\PHlaPGOlaPGop\*rs2pAY.o;7+
)TP7UgDqG'l9`Tf2i:\U`FAJ2eqa't-I(a+/\%BLU]ABc(8I/PeLXH@%2bmrg+Y%bCl.:TjtH
R2d#4[VAZaZC^;#;EusreNXY9$lIEpgMDX<meN'^-@!Xh=BYB,sTAh?a/uE_#k^h3]AlfKF45
H\U$\/(qs0/b=<^Nn!!MD:9U_M/`*nk(=D6N**hXqT(Qc"E1n`L@bHEZ#?@)>!X[$_B:+J;l
%b6X25OAqP\3/]AW5d?q/X>C^''^unn0#;A]Ar.>EaW5K)mgJiLM$9Va$XBuU"e?C"e0UYBK/H
>1/<h<"HC;jFp:pN!re\L.4gNV4MWk-e;3b'G#EKYE*'-tKodG392`,AsT4c+HOilI^hB]A[_
<,i54@k(d")5c)rW?Ptd9juVTjpQL`]A)&V'VEZW5<#:]AlW.[-gS=hb+^=E)>7]A1lOA_'n-n.
Q\sL,ifug[gl6Q-h<;YU^D<8A<PYQ!p;;"C-'OcJ#h>$S?2WglVXq1^_a8>pI-!kL2Ei1V3a
tTlp&-tLJN5ch2X@qH6G='O%G^:iA^"XdWlUeb2BZiN5=ATV4oDg8D$Xh`oi4SOWE?W2#mC6
&IIT:G-t>)afUWX:XOV/32/r7k-``mr6!kq,$^Ut&Y-rdjebjUj&0LC"><L,s1r@),.PTY:X
US=#SP_cJSuKd8st#YWTK!\5,nHBBp1J-UV9#"T\mc]A9Mq#plL3Zcm6d_Z"k0_s=B9d!h=HU
h#EoSlY3)hh+&E-63arfbpuVqRBG+>0#=#JmGQe%=7Uit?R^(#3RS<GLhB^@>='DIg/]A$ui4
5SGZ/(T0^W1/s,dcr)`5"fX06Xc:50bsR^I]A[ejCkN-gE%)U"GG#E)3%!gJW=H@Tqpu7NK;p
]A0h44#+j6KdT[6"gV^%Qq'1ne46D4YM`[7b9!M/*sH#SJV`Sp<aJjo4]Aomp@"8M(SsK21?`2
$aUL0Uj6hC_idRX=rh]AWk]ALt4.pj/$dd`%1k&<ceH.oqiF%2D\2bPiCV`-"+#n(kJH-nZg-Y
1Yjks^nW"ZqH\cl0(N]A#lh<.D&,^D*b;2n@^F]AN0bm^]AS\Go\dsh<8\*L.+FN"[4"VKC<]ABD
-e-!3r!F<^>W*$5sr8Lel\eO!"3%UVO.RDXB>N5)dXus7NO\,tHQXQoG.U$%0Lju*-geJu?m
o&*1\=dDn[%q63J(8sgr>8Jt"1.`YfW>?)Rq)E^et[?IO6;8+?FYO1p^U;pmPp_33f%+]A9:%
D3\$6Q:_:"LnihFM"(d7_LV?oPCH52K/eVRBe<6fU)?<V"3dTb)5rAk-m9td<.A'H4-f\KNs
@_)tk"6dc,#BdgVA4tW,&Oo:6%[\,=iZ)&%-o1m8Ijn,C/HY)!/R*1GSp@]A@af!,lIo1unWg
i"W[E0%$g,a$*/q\,g&6GF%Iob^Gal'Tfj22=mJqLVI'KUt(CVG8s4]A@:)$3)u)^J7kKCs]AE
acm5X:7am,hP>AnrJVX1BP7E#=GE&a(S(3+?QF%="\%uu47^)\%bZFg]AVh9o6cH;qknX#iZ6
\`9//:D[CCqJP>"deSH.*AP`#!'a:H-K&M-P'HN>AM-dMYDC8D7QT9nM4#Ke2,173/$?Z^7\
3&1hIX.-a/2CQ/s[2[H1DV%@WA@J.G%]AJJ?eQ,n:/n;`BVL.*A*o%qP5j]AEHE^=/PDUc;N9/
c)e8V:s-j\E3V)`I[:A^J9HL*X/=j;q'nfIH.G:]Apri/8gYuHG'[<%B'1.)l9k]Ar=*?)BfKl
aEdG4JcGVC9W5`odW53#jk^^d-l"&+WqS:eMtqr+X/lUWPC\5g,,8C2d1HJG-[6iVaU3"\+u
Hnq=3=n;kU[X<%#VS;Ylp6X]ARVB*6o^+G-Y3q&7Z9/0`,@/R8mc(Orb2N'OJ\22JXl-_-KTE
Am86A:C)rJa:N>.9)[1`gN5)"[>?f.a<@<!$V8qI+;5eVRa8!&8fZXMD=[L,3=9]A<eXZ!-H[
.RLA'f/PqS#j"*HiE\#atr2B,j`I!?R2=))<!"*t/pij>7#Zt=M9:\bdWgK#1:2NI[%5$c6C
.6XB8Z(fI_"@oKU>*FhMhqNaa1S4A)MQbI]Acr/HTM,QujY4[Ic"?93eCTI[7<R^SuqqsV`<h
mb3eH14>f7GBe$^0<WNmgm#Btc&#q]Apq;V%EV/2n28TI3$A;Pq<h(2=*TH/;iAaeAAM!N]AO@
UU3YU-MC'M\:mK2H'?$";QOjHPZoSl8N"PTl/UU?E[mT."]A%G3AG4IFKPfB?8S7%<VUUa6MZ
>(PR,Kg7qZ_n\P3"L$8^u5g.^n=:('%teFZ^%Z$Hdt.se&U>b:!0gIl.eS:Q47ESOfm".]A2E
EX]AC&gRT;a_VKq8Aif-b$IYAIV)'mTmp>`_FjbD0**eYi[e(,#c:OHXgFGdqZO$h?^b&7)dn
X?9mpg#g2Fi`Y:dU)(51NPTr-P:*4$6\aI\2f:(T6knEFS$;LX#LPafJ-Ta6/KXVJf:J7>`k
ZuF)Fe*<).YDIV+9E@2A;LbYfrq/[]Apj?lE`r@JF)kdQBe8laJ:d`BH^g=$lmXE#eX76I&Xc
K_HEt/)\\m&V:OJ%a]A_\_AP-G`]A`r3)0sEH"m@1MhF<j.lEt4P]AVrn>b4J-iS<aZ%?8,:_D$
Go^)=r`=h%1R?=#geE&?<r4r#fQ:]AU;>]A*XR[rsU@$a!!r)#CS?rKugakB-7#d>IV5@;p4Lc
L1RpT4%cAgtpM-\pA\P(Rd$S4NJ56R?4pX,\LKN%O#D?^$;<3;(ApW9H!Ftj]AbA^5j8[11IJ
`6.(4?G\rGP^Q+%]A(>oH4f]A7Nc,HY,bV,dDX>6'lXrh8*[s,_cXh\E]A@g"/:g;0>QkBs-J_/
NBk[;Ah5L@Pt*-./L=eJcKZ;33+hc!%e[?S1m_7S;6f@H/f)4oi2\,?n=7S^=bSB]A<b5G9]AE
mDFq^[p0II>^lcbrG3%+[<1D0LNJ+%VfprUY+l!X(Ylk=2NQ/6qJ2GIfKmj$h!a8EV7/VYIq
)c*i#1K7L.kSTs]AsQ_VRM_:_S=B_&Qt5/k.X$"T!P7S!%0e;n%__%\HsNJMJM5;D<OkI89p2
HKpFpAI(&oL0.q-56WP0UJZ#j+b`dm?`*E)jOXDQH[,Igtc*37OeLC8=km4>aN.,eB_]Ag\&T
(VYFr!p]AdcW1HH]A78[57T`?R>5Wd'(;Ud:;]A[gLj6.Q#]AU,J=:$*R'3C*GQpP0:C?'ALF7Wq
n1gO23E#CO9QpU68#d+4"r(%gljY)%=^raQS:km8FCU(H7B.cgk4pRmTo/UQ4h:j!IQ@3;j/
,>4@?=B=r&0@;=B_Bpe!loB3<]A!`a+!D:r8UC?8%#(4H6\\lmY.%+B=LgU@aKEk-_;mIXUA8
g)^)`Du!3K/g3,;b#GYceb4cPFb96h;4B4fU=H0&pKA_q2/Gg$HBU=^2Yl>fpMVmGNL0W-u%
b`8>'2kf7lkd7/SMM=tPk6-MN?R<I&"8ek2\%3X`Gp_;u6A(gL0DP,*ucm3?#=U:Bt<B9^T`
m3>6s]AB<Gf,,V'TZdc\EGt^5%@_ug:&s\*'21RSQjb@?d$=6_4jiK;]A:J+bpNlD/A*2M[b<$
."I%U>2Y+t6\='h)"0S3WE(XD>Ss""Z#2jJ%G-%TS!?077_H)bp<0/f)V`UFIZW2Qp<r),30
*q"b8WDVg*B>5U'PrUTb>oPmNo]Ab$*UUI^Cp8P5@CJsA*PfUgVhfY@QOC&+he*cZ-ATA?I4e
S;+Ai:s%-08i/1h;p2-Z5UFr6=T]Aip36&A8uf%gb?9n[NbSet;dogd64OAW1G2E]A#*77qkJi
pE`MN;Y,R5sb0Fq0#h":f.PmAr'^G[^t">c<b/njCLoOcP_pXmDCE%8L[fa`P\%A<@7]A]Ag*V
FW!256IueRXARO*(>BeifH^#h%cj6+[\G=h/UY;>*cl+"pq,]A"H5^*J0)>RWkDQoMN"eGq$!
,p/-JAS#nSnAL3Qr-^`K2g,1+8nr1+_S&^e3\D4KO5\'"]ArQ9u$jnpG1-69559o*)E\ABjlC
t8Hna\E8T`_D`dJ'[=&ehg^^S]AH@#%A:-YK!#i8HtNtmo(M2?P>f"kQZcBD3BOVp=j^:WsA:
4S/Y5N0r2'2FeK*fJC\VF8='K?OYR:7Q2W._Z*T6jdtmWGu*,Oj?e=U\S1Zon@\Yc-7DaFY0
Hf]A`+[ir8C;6i9.7_PW-:&!d^r(S@on"gV)TVT+=-o_+ii:(mOnTUaR*8OHOr#SU*W>bqI:j
.ZTjL//0co;$iDcAk>uf;;Rr\cD*`"E<OV((Lt;>+Hle/M35:/*i/%_pU:bm&O"C`U1X7[9K
[snhcYlUYaija`@kSi-f3is?Ts7K@b95O`HCM^#'1Qb5%[E%H)e:pXhu1:]AZh.Rc(oZfp?aY
,LNO]A7"pFl!bGt&e$^/W2!N`,q,VWFu0Bb!-1t$+a(!16c$@ru"[cKT-<OO*6C'=8Cb^/&Qp
8Xn`q[rmGlofGb:hP@Yj_<WVFYLFjcYIdZ@J8Jlc1<;G5sZ#"+f^`H>IUgIPT`K=4dD239?f
H6e!Xk_d]A%/M<8hW"3Y<WFEj1amW,c(*bOdbn`=MlL+4?ieX(Oq\,(4`H?3m0i%bb+R59N<s
HSB&#P%eKE[pX?4iI/NK4JN1"\>Z@DXQ3m%]A(Sg*`-_bSMMMbR&i$ScNK7kB0HdL<iV0:Xf:
2IGE-I</O"Ct+[,_H2L%Z!!.B9mpjS(NPAmCLSJt)-nBI]AS/:taj7pmkZck!q.&K;qq3B.W,
'5_"m(]AsaCL8SmkP%9\iXHR*UB>mi22qL52&lY&HBA^c0uS\M]A$$NE\WdC_Vd.*&cMY</^_<
i6iP%3`RY7TIN1%"P>o\$2M$)dJ9X%NTFST@e\=^S7%<FF,AKcJrs+-_VSE2i*+i1-<uF.*@
5nWTjjof5P3G#(-G-R]A\#C$]A[pQeQ8c4A`1@V?Wm.rMaomPmuW+B"45UrlF_*A]A%(WkW1)i+
oJtF-UBP%,1:>'uk@&7XYfFVi'k3Yrr4\fqetThY0B-lN^gDc.\LJ3;P8E,uKl4R[;?\,S\+
!Bm6@Wo]AOq698I.57okU82R-9h`[pV-S<s-h&o$W=N>"Tp@N9,-Yi)d07%%BluaL$HY%^^lO
4KgFnuUGUM,O3!+$g`]A<CNhkHc40W&!b:NUM.8/$AdX+0J_-iK=BWhTdpA$ohpV1%Q"&/N5!
Tt%^*WgB3^u_)PW$<%BLb8N#9/"MGm+^.OIYnmuE;h*(8*psqlB1H?`;O6/%B88#)A`jGI#T
ok\/e>26O/J>k%Lq:F$4nD\dd!goV.7@[Egh#Z)]A@=&`r70"i&n3.6h/9+`rC'[Khu""16!p
:M"T8pAqNYY)g[]AJtoJ_jAYb/Zj\kIHaOZhDPo7fL%__lDo1Ofda]AouCeCYBV,Ca.:GX!\21
e_()=:=pL^4N+;@V83_^1qXiN<G7;$;4Eb/oe*D%OE1%J7h5O2XC#N::;5GicI@A04r/bk=!
=Ocn9\1)SH>,Y%3p-!m_XMFjl1@JE/7q:Q^1C`?TK%^oH:h-NLQ%ZFMVTi'kd?)5VRJKdM]A'
ue1pLl,;gi18:[dqhn,T]A*:8bcWsKoR75jRA"ppVA%M&S/:Fm"UDN]A]ATci+]AgGT@:N&U!EC9
6m:j'H:;kJe_VPmU]A]A[H5Z`MLUC[mG<oi>3*Y$/l>o3"92oDO-j+[K:`kGHaNL,1=H<?]A4$N
%b/NUqZS@;'NQ/F9+>6?_Stf)/bu2fKk_d10-jD,piI7T/i&6+OL3;.Psen1<2@Ue;J*DNhY
FB!9%IA+'r*bWkMqj*[#Rn?9%Cj7#71&.A63C.?WGeG%G'0Xqqo"GZ7@j=$OKD/XStU;ALNi
WY*A0+5(t)([j@Fl,K<eU7&m$EWhZrVU$*"q4?T(E<8,m>c49/WDIFN&TFB7UpK/tGRXEm=H
6Pk7=TdtB=2]A>kZd!ASSHR%p1:::0P`caa'0rES\s@nfM@'U"9B5S*J2P/J=Ke[0]A-O)RU$0
V/hZ8HSD7tqH^MY$+SOJcS:4M'e%l*[1-?D'bH(%1bnrRDFJBJsF_QIMNEo\fRS$_m\(iO]AX
i$2qc]AJ&?W0fgS`26Cf!30&:L=,#R8Lf+'>8a.%j?$-nSl2=U3T_s2-r%3!,IHt$V`sg4!Zq
q/*<V$966!c\nKUub5;S5!"%#g&@g,D!*E?HiE8lQhZ1LSI%)=c[fF]A6Y':=6B&V;dh2F)8^
'/pUjL4`>`ne50u!<T[Zq[k=@2Z\9rKe.*e\Hpg)PcDPWNe,#^#_MO[)Cl4Ji$[IP=XDqj"8
1a[W5(Qn[0Seh(U>K2jcok-t15K)oKTX@3Y)CfgaK8H,bVGe29gn6sW*=F#4C"qa[tWcPM`D
6#+alT0q"*:9*gH"=\quELIa"#'#^m<a3!,p.k*UA3KarD\dE.5B<u'<\n/N)Y.^,SnF8Qd<
1gRffBDb;p"8VRj+[O&aP)2/8`1Z6J[F#:oDK\pM#O5i\K_4p7G0umRf@,M[@c\>mg@[1UP<
rCscWa4u_AYQ_-Togc]Aa``1HOO[&[A7<m6=T0O*9"U=l\ApH(K8TBR?+qr3scWcQS#NAHY;8
7<oSht'Pp'Z:7ZWA$8K]A8B-?D?"[O]Ap,KHK6,;pCo?3-KP9[3<SiS(kfL?;oF=e"]Adi5J9^=
[sZVM==)g1j#nu'T*!8HCN6c+]A>$[o"P![eL+!(=#sdE]AuSK)UmBfm=J0H&7Ga+qLLmUlk#2
XGk]Aq2e.Elu'K.3RtmruAQ_KUPa%5V%8Q`_BX"WlJWgpR@7IKuXknR%&5qCZ'TW39FMi9*Cs
E^<o".KT[!_>WPKgj=.uR?QW.OfgCo;[bDE%2;sN&+W6^gWRC8j>S7Tnr6)$'[/^ARbAnbV<
+K2K.Fb"Z`.S-2[98mQ*0Z4QmpVq(dmkL?96j@KWZ`@Rs@XIV65(C9"[HK5;AS[nJo4NI$]Ac
T;.ucM@2h*AB<X3NB8DntKeFbD*P=Nkl%6ekVmLgfI6gRHl[:f0#@;l:2JK*PV<45H^V?b0q
$:Y9VK<r"HS%6OEAcWPEHV5>LX6L9$[`GY7m?t))YWDR+*jN/]A/1m>Xt!UKd.0PC.:7pc6/C
sj:!6!hj&-G@R1l.N=^H;\=!WjYG3bmbC#s`TE'Dl;mQoHB8-P_h8G7FX/.XTkYS;R=KCX/[
Z9*E[?S"mPc\'7+)-sBjlJ-o^$RB8.*g<XB6\Ho@Le%>_cZU>Wasa:X[_b53P<qoPPE>/6Rg
[NJKP?T/U(\iQ7q@IZ^Zu$(\uO[;RZ<klpWZH&?pB*>(a"bV)Jo-3I:@0r?d5qFM26??k#J+
:4%<:t-NlcBK_VB?)%D3mMJ6(EIH]A]AppkeGUS;,:EMO1TL($(7DpLMR2TT:`*m0Gdo1!j@Va
CKRj;fZVp:%%J1h7Uojq>k+&.R6aCBf\F@/Id";D3U;K_l6f"N$*>7.bQ55V,%iKLPfcGlH4
Cl]AM(C#NQ>6l_.urdBSNXGL*K!`l^'OOR^nhq47p6`5eNO!gKFR)W*Q/6HJsQag1P2-&X"i0
6/YmU2\!n6K%J]ANj@\;_n#td!Yb$kCBOd<"0'[mZ2QNf8Cp!V@AsW&VR<rML)mZ&dhS<GH(#
cL&=)D"-KI%<&qDLoOI_W;3&mQl8=i\Q5('toD8n.lD>t.]A#MpR99/Ytrf(fq!sT:VtMM4)S
QhK<pM32NNnZ<6=>6FY!>s19rIgp)P%+$%&aPpJ_fZ1V2aI#-O-8&(AQnKW!tMM=7o;>_#aH
OiX_B3F,W_-^!B3JW5d46X_M7'cM>K`<s!:fcN9pT5QC5U5fT3j)+GIi]A"t`uEmm&sFHHU[K
GnI#lPmlGccn3a3Rgh#`'ejN*XT6S37"]A@1]A2+if*..N5F,1:iC@O1'.QOh,5Jdkt!4&\a++
Yq[,*48NFGN(u^^7c,#3.!bNrJ-9QH=Ge^<\4S8aiFphf5Whp?fEePCH]A4WbrB8NB]A^Ye"l3
jOT&(Gg.YWuO1]ARQ=&>HR5`qs%B*md!BT$)5r7a24rQ!l%sD^eEH*rOKp?s.72eqccEY[#2H
oe11D;'.2.7q6dji&YspJha:HZ3t@kpcoBb`KX;NoF2aLYIs6'$m#T8BofarK_0P,Ded]A#f:
E@:"P5G>Y&p<*1RI,="DL-%=4p^WCFT0n;-kJ1qNL\F-*%dZ.P":R-ocMPQ@7RYs+L;iURVC
oic(eNR#mQ+51o5%.W<]AlH=PX_3!Moe7H*XDDm3pR]ALo<;!gIj7'Fo5FQn`naUL^OJf+.@Ug
oO["=?LXV\2r:fZCIU<]A\$S3<#8"MeIQopE3QuSarVs!lT4UGhh3a"?BNO/jUZ-CMd24Je$b
g_Nc:K)d0BsR'hZccHrqPq(/^lpNI/:q<#0]AD:Cc9pMnYnd#V!2KD&$`ITU@pQi`V`R]A^`=;
H5.C44;!*(MqVNGBH[bbiYm169T2-n_>(jJoSdLk<72=C1rT<AUn=5O+YIZR^PrX(UNlN4=7
=D&agVH%,UBc6[UZjODkqP,F7d:Xuj@765.Y]AUf$tmUY`r9)g=>'PNQFm/,o'_AXZl&Bf.P^
=TNuZ-E@j:aO?Hh<;"4GZZ"8>#>Fu:Vm+8)k4A7W\CN;hV?>@Wa_D>T6oif*$DUGK-UrStu,
c;!?)HZ;-@Ikn#/=34+*%6e1>R98A(l0M;u)FpS%D$U.Bk#qKA9J=PKd>Rr?+til5O1J)4I*
K5js,=pHp8')V4+oT+ZIZ(T\E,SO2Z/Y\bS_KjGr,_80\)'A2giJKk+Jmh@tXf[Bn-(MXGg\
)Q"V:Y/"T9B(k:LGjT!HFHc$j<]A"/RYNu)9J7$**UqTj8Q^,V.Zm(*Q&[`O3qM`uKkSi$E<J
m4b+l&hS#!nYm1\8e&&c2Ce<A,D5"#gi?*m^bljdT4TSX;nsVEB(@Eo,iV&GbfuD0)X$TdDN
@WZjO%:j<LbAV4mq'jLpZkB^ZG&G8CJ08;F@H)+TqE?PgtZahT`oagpb-=p#*frk^&7?fOV*
iJ[^FHuZ0d.QU^<D`9lMkN+s1=Fk(4Aq4@]AO"!.5al7<?6TKHni471`_oU3j1.+=HZAuH-I=
*VQ@4^fQ^TNZJAnc_O:X'sfRTFQET+(]A@]AE`iLM6?Zq'HE"kbP$F?-UbSsFYVStB\[7Om&HJ
i?C?3=TK5LqkRG)*)JAn=g:rl2SZp,U5K^#j?Z(,8\hE1-^Jo)_F'T$gGb6>u)elmWVFsfAI
SosGN<XObDDTAZr6M.JlWTrh>bnA\a,<-kJHI-GI*.6N^&GS=;_+F8m:SaePG(27Kh221,%5
do32rNQKUX$r"Cjl[N=tdW+Lu]A+Hn)_MQlbgddW"(J*!#d3.iJ;ZSRJ`Cd_d&;igbD:m=PO\
NTKrVF&S;`?[@r$X[bYZO'mOKnQQ^-Ks=Z<^6#L@=JNr?5$f5^?_jjE)LS[m_+riAIQ2_hSc
+rdC\<JTg`:$JFoFJZQcA+4iY*JhUH]AOm>W5<h8Wdp3T+k&SJ6hiGh1&QL0\i&nJ2>:/Nn:k
6ZM:`]Aq;8I5Bbrdj$_6o<[p`VAS^%@J/U9p_G!&f(mT+6Ehitm[04[[OA9'9\<q!S]ANjU/So
>fcbs!-X?,q_E73H$"XNEIM%-GMVd_gQo]AmpAQP=V'";51b^7@N\6Ac$62g9]A!&S]ApC]AAl!'
8;Dp(VZ%2nJ[J+tr~
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
<IM>
<![CDATA[m<]A.=;cgRhM.n[[5snX%6_)TS,#]AMLM&%OT/CE/e'I5(6.`a_>#"8\FP$3O3,)?n1A.iHKJq
=+.$&VD3,_AQ0$"6F-$-E!qp&=^cDgULBr*&Rfmd4.[Mm^iWc9?TIrTr]AmhKL%SFu_Q8>d/U
,R[VsImG#'uVku?_U8A-?4o]A$R)8c\,Q%'c3D;VqdqhT@1Pp[:'iSE2'5)K_Rbm,cCC%fmU.
lSKJ?/"E<e`rDg%T(sjo-*,B9+d[AACQ[jd&c3U/_`0tI'P)=_o%kr,8F;+6+T0+#K>tPFbb
;26l5`G[9K5`FNQ:MUK;(fr\WoOGAlChio9R'X)MD4,Ho(8]Ae:'d"tdLKph\1L=o?"2<3bJ<
i9sBhD6HZlT/f,T/PYMrD:b:b&u&BEi@2IHM*3HX@!"9:6%_"9g:j(_Q)1fKF+GaOcG<1RmR
0V'rrg:I.YE/LkO]A"=]ALE$+\j7-GAm>8Glj'/84)8Kp"*a2ZjR5B\3sW[HoSaq8`O5!=Sc*]A
+g#iTsYKFShA_3&3.F'N#\S4s`-Yn_hNB":Nda9tj"M&rl-^4:pg"#3h23,RlIdhB1UZgF:D
\Ef4OI!mNjfh'A#5H5t+]AQd#Lp:q,Bsu>Z/kni]Agu!=0#4mi500a>/<9pJu]A$HETA<Y*HcoG
I61Uqok:Ln0BOuPS$_b>s[,N^"fj>Nm\*,ZYJQ+U%AmoN'mF*+OLEQZ)')+7HoiJ"FtlK>ua
d)s/bD9>=$HZ@`G\4P.K?Ym-A^a*LaI<9m:8\=_9:MPiX92J",0`B#eW*aH#;Tb'd4&\sWIu
r!SD&5$T8t0GR]ApENA8^CG"$'m/OossB2(EbmjWrq<2h"@ch=?]AU4)8C9d4G2QEI<S,4cRKD
fc[Lg$$s<k6F\O44#>YN??'`2s+U]A3=n$(?gZ&Z77s88-P?I0-+88X*8o)=LXlYN*]AP1C##O
,Y=ROgH^]Ar[-Zp'^TFjJ=<[6j%*1kHZc=KAo.-ocbn^3P#i`\V]AiES6DC#s@!UG/m`Qm^oXF
8XZDtgT`g`Y2[okYhjI@XYMZ^^Nl=HA"7)IDBEm9ZBP-Hi,mathr._0Pm9<MS&<peXn[8F^6
%N@a=YD*ViOk3$8#:,R^\6h7ZG3-Xs7q_U+T*8Ie8@I9iqR\Gj+LV0p1g;a@gb4T=0gfmJaN
U<qk)%5f6.sY)Qb117I3D4]A<2/K>NG=Or7)1W$.*@6Se&)frT2BL;9+,*hn(6_W@iKKNAmn0
]Abr?r3S#i(s8$-WsM[#,/B!L!KT:]A!JJ^8HY14(Z#H^-VL]Aj7=E7N>WgCTf8D/I*Sb:[p-`J
rb+mVX#8uaiJYgKpR0CO,L^]AHA:4>Dj=^#f/hP2>ij[XqXq=Onafa*-l@%:]A0hXlmrEZ0BR-
K5!OJV`"Ke)LHaf#AHLk?jr-iMQeG8tocr?(eR'<H^b_!c%U7>Mb@r@o&8"]AUB;J`igMYo0Q
DOE#^q%:cel?+Jtq3uWnpU;jrN>IOegUAoL;ARo&IXpF>(G,2PP/eP+FW5O.\nBsT<BIPUQ"
r@WA_s>&:sI`HVBE@^*2/O6Ic?Z9!:8Z/Qp?W,oMf)27;N1f>JB21GM[d1/gKi?G*9k]A"NnC
;,."@Nas/<T'09nZrj0pSRAeA7Q&"m*f]Akb?$#JGcZm$2s20,S.Msd6#s6=J>bUk9q*?(g2R
6L$<mG,,F>"TXG7')bkBYG*pNgEQ`Z(I-<j5]AGorQ5rVSIsr-1MC?@jJ'(bH#2HPR?4tk@4.
:8$@jd5]ASP)jX;\!pJ=1fD5%%XI5G&Nga(!5h>L9sh?`[Fr(\!0g<^HVJlp?;G\jA2djbbBf
?`Bda1@&H0BJPV\aj//\V;n#CR!YX#4Sb0Vc&&W%0grH&00B=sio<fnRkD-&g0$%M+\F5aCr
B\JGj7G;\RMLNTDf+*f^)q4_i-nb]A]Ae"]A2/'.Jc0iq#F5(0I@Ia#Qks[:TqTdL471:]AVh;F8
@-/1:jS]AeO:.>pf,MbdJX4gf_;P"X0EO4d),ISR#]A<\"ZKKrlPb_)1e<VKI6aA6G>:dU0EQ(
cLUbnSXsJ)0=^GMDJ:+HG#-1I!Lsi?LU]A`i&N94)=oWglO3#SW]AAhS-A<-YI=$'ibYDD^9[?
g.L8G\*A60Dfl19kNER!d4[O&/X.9aU4HN-B>M/>&30j[r=+?aKR0%]ASq:]A,oT>F05@Z0GcB
)m+pg+7B6>M!:pXQ8%-Y-C8/TRb]AtYTO!n:X`d<,@m6$9kZ";2Q!KF`Xs*)=G&AD*Bb8l%R/
PSLo$uCXRdl?\6;6d$_L&WsG21-SUkm?JF$o<<E`g9"c"iWiBg@d`2BB/6Z"<&jPR%6Xb&2(
9=VJl!'AE[&&`OYcOGJtg5c<1(2P1m(9TqfG+cRZ1ND7CP*Nt1:T2Yl8:%IuV`/,R^Z]A-."9
SsDEH&n3g??[3oF2+.V/Vhc[:`eE<VOSs[((F?bK<?8\FO=VNn>U0YjDZL@3;3UN_I\/MVad
pGm_&h3Dhu8gdp*`/5mG5-%qnaba.gUr`D3a1UFcZ;$`9AN%j7:>N1,=^?WN]A[1$9T7;9-fS
KT%4tCTK1Bks\>S>)M"@b(4@DF^>Og(Lj,QMjaPsI8;>\gSK-EI"^Wf2q_-G&CrKp-0o*P6L
0r?>?l&)a0sTQE$_=+:I\="dV%P$=&R.C19E(!iq>ac\@YPf$X9h_SDo64G%_PF]A!,&pDQaI
?LE5@%?mbi=9AC.M"GddYU:HOi9I8Eu.pJH6`5C&S0(HeXEY7_>A4&D8F+I>JS>`OE>4pN/a
a[8KQ==qa%c'qF;\'_gq77[s9R56q\J5@ZUrAO?>bH3WK"`:_]AsUG5jT2k$ApY_ebl'HgA`F
gb#21;=/TPjM1,^,_=F/kp*HSEGO7]A$W%sVP1>tSTE-=_rp,-bZ%Hr38t^TH(U9[+%+@8&Mh
'O?tL+&DAJqkcGMRl0Wi`p@(#VHLbsM+mq0P6&;ULfX^tTW]AtUYcW!5`-/C5KN^jT)U`bh(X
^Sj@QR=*;,2LK/]Ac(P!nIp0oI8)fB8ZS:*<E<QG>Wk<<m6na?*pj#_B4BqbR>K`*-X(sYh]A(
(8[K.M8[iSbf%?`=W]ARi[l2"@:^ko_kbI=V(T:Si4?T]Ao>?ds&kD6M-*C7OH-1*0TqbJL`Y'
t!oY78Vsg_]A5eiK_i-.hp[bZJ16Udo,B>8q@=S>%@)=O]A.t)TXV\6J>C#d%cYIdRrclE]A[M3
aARh3jpM3*]A'>Qno`,:Z?MrPRHlHFmmEL2L4FbC%lbdq]A#S\1(s\IF,+n%T3qpONi(DU&Db!
+j!+5M$<2fXEGRq3^gbYmMX4^-+>02!PJgEU/eXBe4dk<'3""H2_tmWIVH(+4rE1B/3bEZZg
Dk%NIQG5]A.8U_c0;Q;;:(mRD%3#&l"]AU!a7VlXJA1Pqeu"CWU+4Qa-qp?\9tp.^r4`)2.l%T
5>V8#&=!3kn8J$Zu?e@=#C55h6JBL8_fM"&jAA48\eOp<>'t:ll"GOs0*cL@7H*!X/;P2'>Q
)kqf2\h6UrGB/Z!6^ujN3$'WQ=epg?[fSb`n$'Td$$ku!!\T8[,g!cL'M=:lL^.bX>4!OnEc
.NMHPG'?Sh^S/49/45G)6_Lmieb!Ub%9G_W9.;q7JagJoj*\?Go8;::_qb'L_gjs5PG1m8,#
Ym1\p)>jR51K*(s[q=cfBSF)D,MsTrlb>eO^QoSsrMdH]A1^rCbNqAW>H'L,l'%:PK^0R1A.X
?DQ,d3ne*kOnD.Ul9!`'e^DY0^rj+(K(g"OLnFY"=cG=#S[/^N;*qAHjnfO@0^/9oD'c*#%H
Z\]AYlHpg?%B>us/A<*LSM,tR;%3"pqJUB0',Fkp)AoKuXZ[=Lm5_ABEC^b^fXP$Wi</BRRQ+
T5j&fIo@.^R3&#k%'o]AC>_=_oRU6!N+_"<n#"`7mF"UffMt]A;kj4<8(QtYL^$:J<`_XnQ%W+
k:C`:K[$16#u+0<\N\,cK%P9pqr#ji[,i-C!lE9,Zcg7O:6_R`J!;'1$%Vs]A2g`H:(`QH4I=
9`!'APOXK_D\XUL7MS9LID9tc*4X?A&/q]A89@o(TLAC+&[<1/o/X5(:e2^;Sjm5-9Ue]A`Uo&
P\F[m>C+qQb<sfK4ohi#)24-&3C[*Il4Q`ZTRYrH_[F`0lS5eq5SW\fQ(BN,Kp#[Gd\g[m0*
:"er3UhLD-h*4oVHEPh)7hV=%&FS]A'_lOhZEQ7\QjXA(Udd0$K8fS9nen]Ao4\jjp1;3rE]Ac!
OA$aqOUk3=Pr(0QIlBYM6p\/pu+`S1/J0[>T&+-`TO5ra%-<0ihr;A4G=oN=o&XX,\Rj,mnd
&>SaACQ_J47ec]A-+lWpV'i?Z53j-:"#$l4XZ2),DDSX7W4DU1U:#J<h8_>WbgRFuF:MT6[<t
<pp"o_QIDMlPhDd:F<oPrY))RWK=Kpqn0Cf=D!GU[jSd2gn3ngB1B&IaHC+0E:hg/@H]Aji7Y
j(BUS"jhZ337<+W2om_01Vq3mGt&h==ph^5h($d16XXe7Dr2%I=P1]AnKm'GXZ)H2%sX;C3u9
o(F6`36^++,>T>NR'JXUPh36"%c-@TIaQW+-GD$1G-n=X=YVO@!iQ[<$K0&_C[X^'si$Ij?E
s7D9#bGNdHI5C_TD8t-Oj8X>_se:378n8(P>Fg[bKE7D+._;^M#D=s_P>pdiHIAdq!pNn+.a
QYrO##X,6R=R]A6)Zr]ANV-WY*"&P=OhZS5J^(`PUDHfE=1GL;3&RmP\*]Ael9Y[NSQ64Kkm`ho
CFg7/C.[#$Yf^b-fAO32!)e-JW$'k;Bap+NH8QKV'[+7hp>WqB.O&3n/6LnK?8pI:V.A<-O)
`bVFf:L9`h2:ub7HqCiYf@H#VT&&Y>OIB[8?4qp.CmHB"idugY7T+E_*JOXDcBBSN9F%!c`a
AeQN?#,!/;X)16COXZ1Q!K$bdqcA_WqKdRZ%p<ZktO",X1F2mkrb%$l\O2#[Ro#rZJ/B5)VO
k#5DciX\**Nr!en1s=_oYGQHV`sC^1?Pdq%:Vhbdu<HJXBoIC1KH_&-_emACrS)Bl.C^N1OK
&$gOQ&4"KU@N-Lr/Yin/Z;_h"/kC)EO7fLpZ2:E8:?%K-55Z8Pn7)_U+<acr*LABmM>Ll=b>
fb5l%<nbOp3;I@*6<<4t6&I"%dt#=I%(;N%^&&>6Q_LSQr:Yg#)Vc/64>D,P-$(X1pJ%SI1R
g@VT-t(r*@`5t)Gr*_/hl%a4a*eFcb!JNXo#d*\LX/\*1'T]A]A)nX3c[87((Yq$G,H<+2C\<q
a4o]AB$@12&PD5ftcG?O3<,Rt>-Ib"hf%iMP,9).t&k43(*M%[+Yg&I)]A#$3g@Q;6LMOJ$:kb
cN`@]A&DDp2a;)$'mN*C[rB*V38MA$Mas41_=%PR.DW;IP:5X.B.Ko+b=;2RYXE6C(rDkYQFc
'g*_S`6!0]AO"iW7JeV!o^WaU:YgE>!dB,M-BuT9V5sGYLTP?r'p_-W:dfZWf2:4*UCo[!%ca
0^RrR>._5._Q"kJJ?F,J</aGqAkpt#Tju9unm7mocn)iIR-]A`sYh?>_+E.##_oN,M;T2!n9S
K4uJ$r*)B?Nc7R3.\-.Yn4i<&uQA2g,H]A(l:efOB:.e$_meK9MJqE8N,#D?!3Vg8Z2"jp.b2
n>o=u27[/:&.ctt__cY`[;70'g%5gmrXeNi7I]AUkS+M\h[EDOtLOa"qejNE?4QaN;-VlQX2L
-e:lq9k,ZeX3t+LJ5;m7=P=\Pm1`of9NO]A&9"f6PlP+JFNYXe<Jd#TTr2pH[&7G*]Ae[-K9$/
+I3*M'o+NChLn5+=Sdit"TE;5=T5JfeaI@,cV5Yj4aRP0M+ebCO0j8:O/$&PG6Nh<#M?'RMV
-t87d'pk'2/<RJ^FAu?\g"#*,O@7iA.:J&fOjW.WLhO?/'clZM^L_1T.^\_OFomYu9O##?\3
UR1`mt['(tk+LG[C*_D4JTVb%1Io.CIXD<4*Mkj<oq_&mqP6%+'m*&Vn`/M=YaJ9>U)G4]AR@
Ghr3^31:_Th??62]A\^ag\pO0g8%_\]A,V+oK8n&G`D0a]A^em[$J=^)FV1Q"H)8Z#"-M,*0($"
!Tr"^n/gig[ZiX%l3Hd-L03A+I<N\GT#Dn;1PnRAfNPf-M]AOK_('$jqZ\Puj]A(TAf3^]A]A7?!
3;eDpHc]A8u<W2In@!o2,C5j-Jl]A?d!KlGON]A(R4E3'c\3o09/fK_b96PR34U<>2_Ws(p>p2F
KKgTnT'7-pf;V$&hM(VjG@aHV#XPdU'Z:5d40!GiinZHk!5gWqb`F?%+%_1l6D#bTFkI@*_+
Zrh,L79(I-q1l@s%@F#J(ocng8\l+U*9O]A+03#Z`%-tpC"9g)\"r^XZ!YPPfkIiqSa^&)&#"
F*,c*3[3oBGNkck`e"7Vh-;*jlqm'E6-\F]ATkDb8#@%]AMBP/s%]AP"meRO&%AiV+&P!M2$`sQ
*/rh*;ctoOYUY[d6b"$MJF'*/?oa^lWf2r228'g5?mr1/3)QF\%4mbRAdlf7<-O^/:Z[?;jQ
fH4Fsqf->%49F*'U/O[8!p3VCX0;0=/+9oPC/7/hha!`2kgaX8ffTGKOkH[@!ZF6kbK7e00F
n<J'4IVlCWoTQHd#tmk,Jjnu()K`ip9I*.h&N=*mW.-;l!Q*E*@K012B;GkgQ=iND.W<5G>B
b;;3kVQ9bQTTnXR&B7F\*Dq3KaM9Get;#2c!O%kmNFs1AhjgG!7T'@phK+UTNPL8%=q=KZOm
2GM"_ENpX^:k;`E</Q)^[Z3F7(Gil4!qI84Bi74QPi94(RUR1/3(La1N77d5F5s@bE7*3?fT
2H(iLEr,n?o$2DC%C"fdf'pW&&F<k5MA!,fSiCtJ+`L'kM9)%->5M]A6kQ'RM><oLr.mtJq[8
"RMj8!8it)_ublgm#V;p0hGGE7B5]Ajeq5IfA`dLcj&4p4Z^:b./m4T]A?4%&WY&[3%<::->VX
cN3M[HqO<l%I3;8qY:HPNK+6j]AQF4V(9^ZX[:&T<7W<u(^oO<TAZH@@l,!C(l>ol/X2P!a[B
;saI9[>]AnUuc0<2mP'rI`Md)"m2ffZb6E2E6QLlq,q-@>"Rj"8VjqKtgT"<WH?&pSYXOpC@I
a&V^,Q%%:!4.oR#)o/;3=TbVp?6E"GST?h<`Ci'Y+5T_hAdB?X!\$KuA!-jndf^'^s^Ao@%+
h-up)`3'$LOJ.MatA!dqXRlu]AWQ\kQs5,9L6)OW3@Y,ddpL&99lK6LF5/Vic2h..?:GKQ[$4
,mK6'.?/m2A7:sQ]A?LXjdrLof$&Ebj?mq1E(6m=g="FLXW5#<j]A6WsnuSf'W$/OZ"IRU/mY4
E;tK[81LQErDddE$X8&GrhY]AKXI;0enpTGel!1>@HqNiUUA?#=p**=7M_M1s[jF=enDt[\\s
:N5A7[EOHlBpZU_-EC[pV0SmVa3=%gBX?+Lu@0`_,gE@0'a=39Q4-jdu6>=9,9fm%9II"#,^
8B"h<>O8q97/=8;TJQj*pH,8jX#=PU]A8.]A=@n80>g&3$iVn'0@p(Z!DnmTth$*W``[VQq5mj
fdRnY5PJ's/]ADO&?9!X,H;YgZ^1EbZds[O<42PBGV'ZsZeT;#@LJ"nK,<DV1A&%-rl:]AQ%<o
qkZ'[_.BL/XrXB1W:>Xrrkgd;6a$>E;Oo5^*ImG\NBPeU%WeBdQ]Ac7as@Jh8sVeLhTcTOaXU
Ai-S/2H9jfGj's6Hkl2OMP<A10uU^]AS<mDg=nlpm2X*s(fR+8.M^DqQ7P]A^gP:uq,K>gf1gG
';,B<MGm9%',93_B'5/O5Ml!a$=b(8',7QbSc9E`+AILE6Ac[c<0'6]AJ*XXFbYFl<C,Za?cH
TjU?"_pfA`"s+Cc.MW2j.]AD??-HM^pAI*OP"^"^p;PGbG?pKo1Lbj_d,P5FA+)*_Q16bq&s#
N`eX8s8sGeM_tNL`n$*I6'0?P>_\?#prO8k]A7h-fn$R$']Anj%HW!;lF,?bqO!:3E+/i?3>#3
YY,@3f+4&pfFT7.Y8o>_@NR=?2PmdP(M@%Ouq$(dI]A7JY&Vho\"`_NA5#RjD&)0\BM$@]AN_A
.n2Uf9?GuS4b<+0,g\mKNp7UmFkF=aP^Z\NX%MaX<UN1&CE#S]A$GfBs8l]AXEWM[qsS+t@aof
kdq7`P1@.Qr6.oL*je_GhW4*9gQg`J?rCWqktR1Xll&YQ!FYbT,!$4`B;EBj$0/-ln1Da?Q\
c%VDX:\#Mk:#_A>-dp,Q74ZTe;D,NT[jp[iif1cF#PLX#>G=\LFmefTfhCUt['<Lk%6:t&g(
#WoK^3>4do)/+&Lo7rK5&CJJ$CC19hMPa:Xs1\gpUDC-W<?k5Z?sjEOK2LsaRnIC<>eu3Aks
Ysn3cAIs8#<UcWlX1(%tb68%#iab[H>B,'uKaVt+16<#5<U0Ra58''?%p0!t`X)f0I0PU<To
Ga>?XApH2Z*rI^2gO5_8&TG[[I5tK-p83c53(s9`VtXYuqau%S<S*N0=fRdi=")AH)NobToZ
6't8f]AJD,#"n&Wc9s&Xm)LZ4;HO7SWe:_F;iXMqeK_9db_55MV6^\+rU!C/hh&a_-aUY#INg
:]A'B62a5:MA[(im+r!V?6H4aL&6X%=)+IPjIdK[5@SG0M>&,-Fi3n@(QK:@9TV$Ft2s(I+O8
d4fqQpnZO@$TXWi4l%nb$:4\EihFX5ioepBkCq;:.3DJ*W48g,6.N:,t=!O[ZLeijTO,(A/_
H>k2R/jbUD"%>R=*-P5UD$S\piF*6)Ge@&u/8m]A<-\jKE!9#-50@oE0e\BUrM?b3FE1VCC4\
$71&t2>dM9m_jN0+*rG1?[hTin(d&B<+1oNV:pfVD?>Y^:YXn[@>/*iqlDNJS"q7r9ga:&Xp
fi-G_5AjB"KWi$W`,>-DK[*Vh!I0+bm2+P[P`AK`hbg<,B/A^b*K]A$to(P<,nO*:]AK=[K_MJ
mUs9^s4mYi7M>lrh/.7qf2Nbei!W8,sI]AJ>%-.V]All*cbXE0]A*@W!aF-`_p+eWklE69UBCRM
n8Y8':s5-Fn,M6Xu[85e#5:L1Z7U^a[GIT&&"h:YJ8u,n'/n6=+Xs!<$LG>"N!!kT+k.Z<RV
-+\3C,*(fF'N4BmV)9-I523>Wo6`C+a/n/Yt"7p/::.X#mqm!Dh\\4k1Fe\*Nm'@dfq^E-L6
_ik'GrM7;a6#Tl-VED:K3,Qq?g>h8o!<~
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
<![CDATA[288000,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[720000,762000,2743200,2743200,2743200]]></ColumnWidth>
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
<Border>
<Top color="-16777216"/>
<Bottom color="-16777216"/>
<Left color="-16777216"/>
<Right color="-16777216"/>
</Border>
</Style>
<Style horizontal_alignment="2" imageLayout="1">
<FRFont name="微软雅黑" style="1" size="80"/>
<Background name="NullBackground"/>
<Border>
<Top color="-16777216"/>
<Bottom color="-16777216"/>
<Left color="-16777216"/>
<Right color="-16777216"/>
</Border>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<IM>
<![CDATA[m94d;;g5fJ6:OYVd#";['hN78C!1+rCk@MG>,nRM4&1Q"2PlQd@).RLP+5KUR>rIT[=X\jp+
h>+7=qBf0p%&d5fs]AN+[@.V,(qh)XCOKgJA'9Gc1-(HlEt]Afi?."UQLd2qqgIr-Ic!/X]AtZY
ml).QHKg6cPhXU$B59g^t8-AuS[X8s7`NB+BoP7sPNbr_5-*:QeLmTt]A61(2c=SmpW^$it-^
AJWs.-0-CgV,Y^gufRAOghdHDqt3]A]At7tEb5?)k4.]Ak6-U%3=Ekrj-0*LWhq2:[As'ncKF+(
;&hs^I?dWL`7]Ag@3`8[,@%E^a;f2`!8Z\-^bmdCTdE'Rp]A$R,A34q<,Ar=sF3Q?GL6XMDirr
3@)>1NAkVE6Qs)Eb=4$6M7IoE3!X@MMm&kp?1580EjYuX8Ui/2NhYrS$E1Hai?gS$3!>bf)o
dd>2k.$+R#A=YI43D!,2J,4F;FW:Ajl(.r:[DPe:F%+!le9Y.lAnF9,SNj2o^WmkGtP%eRe#
g_(iK?Q<3&YF%=73Q(6D[]A[,Mk7^#d,k0,:SQ/11DgOHq8_^<QcK+em?8g;#Ie1^D*.X*20I
nh\c0BMb"jdT/I]Ai;PIJngF20n-N"!>R@o/L.lO6i841l(.SUesM'R>r2-YBpU)J@W+>iC<Y
Rj$10AB9!HLU_,'$4e388q4S'[NF9GfF@dMG\"fhmNOr&"Bm&^RA1+H5>@N"#dcsPY&6FD,9
KUj\F7n:Ye.MNhbhmKp&(TdiRWLc<4H^NY2aS=f!Fq3T]A]Ad)RIBcpX=UGI7`Ym"RThVtWngT
n+;.e%Pmr;OO4'N\;a?9U7r45cPH;??XF6\E+!KqZ^MW7r]A25W?jmnM_0d4L"1Qp3m'a!^%j
s,i'@$nqnnS@=.UY[:->ZQ0L%<LhG:_&Y-j"&Ir&9#9(]A3N0`"LPnHfYNid!A%bQ@&Of2TYq
!esr*Q%T$#itHm?h2c!Y.]Akpp0]An,Rc8X5_'ZnRXYpUEj%Zf>'M2>7n4GEK@?iB+I-#4uH:-
Anf%%dGlWrJ(1;,FABhqN8lLed5CF%/iJt2CCD6qluFQU`OCP$M1c>g";l@j2=EUCU;E)^b1
`#eus)PG'M%1tY*3,XK$UgR3&T/WfOa*CKC,imgW\F9^hH@mLgNlYjEVHc%9ln0C*O(g6_ck
bQAlV.T\'p_sEQd!cXQL#^-LZ'geSP(=f@UmpSm0k4'JXJ8!BK;_1<S\D.8BH&6A(R3j=jd9
!;#=*65I)Mi@/,f81N,*1`jYh/NZq`WU\.5,e4*M<6E3rte-?G$;SU0=@[%">QVMYC9u^XOh
Ylu:+3,!en@=?RO*P3aMg$-W%X#%QklSe2(Yb*9O^qd(VWpK=XtVmm3IRo*kZgWk.^D@e?TR
`]AOUmn!JY??A.KVPM3"'P(Ia,*E1YU+Wb^Zb'73J&fNT\`<UF]A#KA*S,WK"_bSL]AY>TjU!If
79#NI(0Nc'm;&(c[8QSMQ%Q)7#I/RD7Xnfg7%,b1TppcP'9$cfG;$;V2U@_&kS]Aqj(5Hsr.g
Wf3R1NQ5Co2).7b.%6VCl/WQfZo_QV)@D!n2n9(rpccf._=@[%<4P,j#*Cg<XcK'#A#%1ke_
(q[5=R+q.g<3(N2G$ONA7cnnM^YS8iJ0?Gb^NFs3s6ioWA;V,%g'MUh8WfKDY0aO1)"dr8X<
[&q>jYG)E9R"k)2"us3@@6IO<N#Q?)fG+#he)Y]A^;,0IDQl/?F_KD\Z3ZOfI!U=ZS>`bKY6_
S(k$:\+/lJMsZ:?c8Pu3I"fJH=,(d+IEU#=G^d8a=d+"UU-<r[eVNZArGc2uB/5o-.P;bs'7
Ui1:mF)*XfWT-A*4^#HL)h!l/TJ$Z3UX\t"eFK&:Zh#?*>b[DtMUEjOWia7cb"M7?=YgV%*%
_.h\M\"$dq2sk:cl2HDT[h`<A">=-RCHPUj).@9rIf@mRVAhjs)TTeNQ#]AVG;9-AjMkPQg85
IbAdcO*O7_I3uMu3[TZN%HDaeD`S`$R^d8)mJZY:h'ueZ"3\P/6;4_RB$skMHZ^FC@g/,_'T
qJ,HSHCfB3EQDn[VY=R[XqZ_`WNQe<ZFi"lL##)._NF<D74]Am?p:NSKV,BdD:X;EDh0:W>f3
B.[On0=P**RHD7U/dltc<jMD#P:T/O/L9KW%k[I4e&j^b&C>Ja<%h%WUa@/%bX[U=;0!&hD3
F']A3<ZUWB8D.qk=+:usTNg>9[)i(nYCs917k.F=)X/si%>?aZ]A*Q+F&Ii?t;s";?>91`$kgG
/e&,>ltn.THi)-,;4;MDeh*6pN"--Ks2V$.K8Mbn3Xo;$=??Hd7*#hm6-8iNFfMnW^1tl$J&
&5;30;dic8?C=^U"<&*Y1X%jiN7I570UbEE)hiC>b;]A'kV%,W`_`24V[F.@SWP@RUUnh[SVC
/bEr77VE3M[;=WeL]A'f)fdun4-OjV,mBkkD2kElAH^go::)/e"60Whdc`$$o)"&^bd>!&ZTD
%hTR^NV!*KJ,L@#ChEj!q%I^0#;Wu)c@s58iQX5%k[&s9OnR'D-!`IZ;@7<(2]A^s,Q`O[mtA
+J2[mj`/$m%B!*8b&;O%]ANbJ3TF3UC!4=EO'%;B8kfXOQ=PSci(G!AAo1EJm&/`[8':ASV0-
1tGUHh:/"<FMgXAep>ID\nC.c'#+9Ub;cMmT)30OL5@DZsYk"e^YPk4HtJl4PfW6qt=4`bmu
j'.IBmG]ASjNSq+oj8CFt=N-edb^_r^kRB+'(]APDGO.N;rL]A&ihr_/Y9^E^OLR%XA-)&<C[sZ
T"KdC2N/H@+$e`dUm!$rH'g"^SA_pJ^+nYcD[%Qi,1u]A--9Z,,?MV.$Oso<GMU'%R13_lFG,
U0%n.WQnc:J0p=[tKdd'3CQ0OBj_<IPPX%q7gqd\=_M0?@$P_1>$?[nQ`i)*E*cc?C!]A<aX_
pZ[M==g=!Ki^Ykj%P!.a,lOf9/Y'H93cWTuS]ABD!BJFU*f*)\EGrpd'9u`tZ2gc?L%Z&^'j>
ZX[q$gCn!mSCq"J(_j#jjLI_";oH(uR)ER5pI$92;*%Qj/i/TVc;mR]Aj6@1?1Y]A?*A16+5JR
*m;.!RX+)54T#%T(H^PF_=67EpchL^kO1k!V_Z?K^pNG``an`kq[)p[>.bHL%k*U9M$/GIoc
,:5/U4P<:L2n&4R\\bM:cnM2_q72b#&!91!)<0tj@nYb+fB30o9a:j>fHp/>0(+?Xs1nOK<[
OKq/*g$2h-3X'lM9Xp.s)la$VaHf4jY0>S`gtW"]A9_:6A"qA,n3;^IJ:R$nL1hJo53t27ch8
M%CS:R';@M<;$IJgDYM@/>!.:#h"n$k/<)OVd!j7Bof3;C16BI'TWa>h<)?]A5ioVFDtMMXi5
fSm`,I5rCl^iOD'-Bf*^5b-g71EAe__gp=(^_:GZC/8>Ae3P>Vt*4eB>WFAJW1Xh?\"&9Wi$
FVOWAnd#C!M@Z,`)luk+2p>Ca_XZt!dl@U$5f?rpanTZGT+310+Hts5(,?K$eFF$Mtr\oEWa
R`/Y.F0/or-c&V7^JZQ5/d6DXL;[6@\ptH<*%c8\04rQlr&%Aqjh=Ms4gCN6Xp5e;$5^c\F+
"!)SWmq8Ghb%CS<GFpZWWXgEHe)p^$\XW]A.4"+aRY`q%/dce^N]Akd&i?GqUd/b*67[tpuKjX
it!&'(/Ep46WTl7hQdbda1[S1/:bfc>+2TTmX^VU>B9!-0_Yi=Fl^&'CTLsVC1D+)`Yo@u3S
K<tob@!&p+6l%pSGHWO)(_C*iC.N]AcUg##,DQ$rE@>XZ63-2h$ulEc*oa42@:1M\TiEl:F^_
3hY%/D!=-Y0X"RYAA6R]A,TY*^;Oj70J:K"\GMcQs(q#013[=D$\KFbs=T5[a7cK'PP=OUVg*
l?e-bEGt"at(kRI[u$jpL`Zo8_mP50U1C=X#5[_8M:YNF59KHqVNUL9in&&I.E-!(r*t-=j#
.9Efm5%LWmP#aM<n10H=*<6%l!!np\+_06s;V`qmaCZhHOl*BkeDTo%MdZL`nY!k='qVugdr
;gmkiC^u1E56lOn0F[?/bhB=tk8bGs!b9hPieJ+q32jJj`'.dZ@JTe!CBd9B@TVIM[GHo):B
Z6(BfAR&"?0at&d&Nir,Yc/E'#/2FRb\^0;Vd*L8E/4lH(WgoT<$%=,E!V5b_d>9_[\-FhbQ
,'<i$,)`&<,en;++_@_ae>'2;oD#2gfMeMJ]A`0(kjUUdc$W_Kpm-0dpAc*%dHq&JpZ.\PnH_
m8jNMSAW$lOHRZGg$iL#kNDc1ViCgoEK(<$u@*A)i>Rc+"2*[d8$lI\T5rY3Mn\Zjmm+ib>g
9*5K<.TCJ%D[l`4OR7NO,^['r^cN-^Z<F>%fF*EbhQ:IZ&69b_]AZ`3@mkf0m3eG#*@a)KY6R
*&71'*;<<BglSbZ%OAanA?dE42!,a2dY8pFi5]AO.B=Y5ke[4.[p_24IXW9@NK-m?OrR1SIe[
:-4#2$_nr@LUT#aA,6/)ph6dQ\3,c7OB:j-P$i1T01@IhS;NR'RT0DV$L3o]A5FIhLd5[6`9=
DFa=m16Ij_]AopG8PJG=VNR=CLYNF9?G:QZTA(D[#C'TAkXRsU4WZ-5V@]Ag=\7fJBjW%<[2Y/
$hHBe#!Lu!0n^5^#@bGekEmV!G&V[mOm$o%R"cmXML'-Q+?&Y7^lmr@Z22.5/:K"8+Q3;5J?
#"]A'\2G3/h2GbZ8P%K"X?YXa2H4Z<1fpj]A8,79hFtQV2$"QUgTme]AU!q+@2,_o#GoltQn_r#
2MhVEfHA2d3Ka.\QhOlD_s.408.U^Yl,9=b=YErPNRjF4I&VO"ogCa/N@CNC9XmV(a[@5aq(
m[&YD>3.pl93eC@X\8KQu>Ti^H<'OlY[o]AFT5bceCE"[4c8EU?@cKKt^i?]AiTZ]A!Tl*2&/KS
<bjsE73b:U8k)$WtNGt\?hK?PJ*?b7eHkF)X=H8E_EfmN60(4*0;Jq/cE>Rk6>W#b9L.rT<(
os=B\D''SVKtFt9Lj+iiFo#lpLf*H^XMF63gE::(.7W.#,Q;e+)_Oe*gSYcS]A5GQqHQF;MDO
rn35`$Z%3IrG\mrk92,\M`"i4Zl5IcoEBHEteH.?i8_OsTHSDF@+5l(fB>,?aN(Q[pp!>d3n
n8WFKZ*6dC@4MJZM?Apsr?:k*d8;>,]A=ujZ+SBg4+5f-<d2YAZpMQL6Wk[b,e,<&J1hYSb]A/
9QN8r_6VI]AamR(i1dDmkrhH:5MFJ?\u]Ak@pn'jc?A)Lh^d^6)Q._I3le'(Iq8.'X"dB=>kNm
PVT)t>BtudK@<2HKn0c-7`a&@>jrj$i,Ap&s*'EmH,+"=?Xm/Khf.=I*mah@:m#AD<aRodEU
->AJAh0K"Cml.YRJW?9_2LEGnlm`10c*X&"Z49FS4as/?<%iT;QR^P!\5$oC*qn@7A)b)`ad
sbM)JlDCa/5e,;BpiEl='XDXD@go0,U/OWpAj#(rCiT#ct&V/Id-R;%1or6ZON]AB__G.)]AWK
9<`EH`WK@K%1d@VeB<a./ZLGh?pAT++H$RmeSRJ1\kI,t<X/G57gg(-.0NffXR%8()kX#T35
CDX)PQ1MTB_FfG,XF<\f>sC]Atg6UNTKGgrL(TgTd*GrF\.oi^:"N[dWps:@P=fQ5_7#D0F#@
W-,DJ$@9h1=,/&?d+_,>.Ne[IF%JG;MG<_!cr:tf0)*ZL(K'/"e!d3Gen63d=ah]ALcMnUUU6
N;Bg>_,/']Ag`[L-+WM!7SUA6V&.$G1h0N`O3n'4H=3Km$G)\bjjpg$H`<rQWKlPme\dI*"(`
SPnREZW'C$1I9m")K#-Zf9n+eXS*UMsIX!-L8Xm<K9</7:lRoBboJ5K/)iQL'9<WrWP)'f.U
l9h=dd`a.d1D?'5=ZQoTYe_E)Ba!^gq>1?Ip_kJJ4(bYkNV?-8@4V0fMV?(L%KrDZ8/jB>QN
V!0j]Ag\NA\^Oje@+Rr[9?\4B6dFB(TIK$\-cV'euG%H,D0B,<I.*C(]AMZ\c/]AiMqaCmh0$h=
&rl_3.)/,3Fpp]AjNj?c$3qUr-%pU9Y%@nuq\~
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
<TemplateID TemplateID="b7015ce7-858e-4f84-9780-92783b235a3d"/>
<TemplateIdAttMark class="com.fr.base.iofileattr.TemplateIdAttrMark">
<TemplateIdAttMark TemplateId="44e92ea0-a1fc-4f42-bb5d-5ec5623c0e0a"/>
</TemplateIdAttMark>
</Form>
