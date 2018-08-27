<?xml version="1.0" encoding="UTF-8"?>
<Form xmlVersion="20170715" releaseVersion="8.0.0">
<TableDataMap>
<TableData name="个人信息" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="jiaoyjl"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="p_px"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="CQT_ID"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="yuangfl"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="DWMC"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="zhuyfzy"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="proe"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="TREE_ID_R"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="gongzjl"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="CHANGQT_CHANDLND"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="zhij"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="name"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="CurrentTime"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="xuel"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="zhinxl"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="gangw"/>
<O>
<![CDATA[]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[HXXF_HR]]></DatabaseName>
</Connection>
<Query>
<![CDATA[
SELECT  T.*,rownum
from(
SELECT   *
FROM (
SELECT 
distinct
T.YGID,
T.zhiji,
T.xingming,
T.gangwei,
T.bumen,
T.RZDATE,
T.YGFENLEI,
DW.TREE_NODE_NUM

FROM ODM_HR_YGJLCX_SEARCH T
LEFT JOIN ODM_HR_DW DW
ON DW.TREE_NODE= T.BUMENID  
WHERE 1=1
${if(proe='GFZBZN',"AND ( PARENT_NODES like "+TREE_ID_R+")","and 1=1")}
${if(len(gongzjl)=0 || CurrentTime='2',"","AND T.WBLASTSEACOL LIKE '%"+gongzjl+"%'")}
${if(len(gongzjl)=0,"","AND T.WBSEACOL like'%"+gongzjl+"%'")}
${if(len(name)=0,"","and T.namepinyin like'%"+name+"%'")}
${switch(zhuyfzy,'',"",'1',"and T.ISzhuying like '主营%'",'2',"and T.ISzhuying like '非主营%'",'1,2',"")}
${if(len(yuangfl)=0,"","and T.YGfenlei in('"+yuangfl+"')")}
${if(len(zhij)=0,"","and T.zhiji in('"+zhij+"')")}
${if(len(zhinxl)=0,"","and T.zhinengxulie in('"+zhinxl+"')")}
${if(len(gangw)=0,"","and T.gangwei like'%"+gangw+"%'")}
${if(len(gongzjl)=0,"","AND T.WBSEACOL like'%"+gongzjl+"%'")}
${if(len(jiaoyjl)=0,""," AND T.JYSEACOL like'%"+jiaoyjl+"%'")}
${if(len(xuel)=0,"","and T.XUELIFENLEI in('"+xuel+"')")}
${if(len(DWMC)=0,""," and T.TREE_NODE_ID LIKE '%"+DWMC+"%'")}
${if(len(CHANGQT_CHANDLND)=0,"","AND ISCQT='是' and CQTCDLYEAR in  ('"+CHANGQT_CHANDLND+"')")}
and T.zhiji NOT LIKE '99%'
${if(CQT_ID>0,"AND ISCQT='是'","")}
${switch(p_px,0,' order by DW.TREE_NODE_NUM asc,T.zhiji DESC,T.RZDATE ASC,T.YGID asc',
           1,' order by T.zhiji asc,DW.TREE_NODE_NUM asc,T.RZDATE ASC,T.YGID asc',
           2,'order by T.zhiji desc,DW.TREE_NODE_NUM asc,T.RZDATE ASC,T.YGID asc')
}

)

UNION ALL

SELECT *
FROM (SELECT distinct
T.YGID,
T.zhiji,
T.xingming,
T.gangwei,
T.bumen,
T.RZDATE,
T.YGFENLEI,
DW.TREE_NODE_NUM
FROM ODM_HR_YGJLCX_SEARCH T
LEFT JOIN ODM_HR_DW DW
ON DW.TREE_NODE= T.BUMENID
WHERE 1=1
${if(proe='GFZBZN',"AND ( PARENT_NODES like "+TREE_ID_R+") and 1=2","and 1=1")}
${if(len(gongzjl)=0 || CurrentTime='2',"","AND T.WBLASTSEACOL LIKE '%"+gongzjl+"%'")}
${if(len(gongzjl)=0,"","AND T.WBSEACOL like'%"+gongzjl+"%'")}
${if(len(name)=0,"","and T.namepinyin like'%"+name+"%'")}
${switch(zhuyfzy,'',"",'1',"and T.ISzhuying like '主营%'",'2',"and T.ISzhuying like '非主营%'",'1,2',"")}
${if(len(yuangfl)=0,"","and T.YGfenlei in('"+yuangfl+"')")}
${if(len(zhij)=0,"","and T.zhiji in('"+zhij+"')")}
${if(len(zhinxl)=0,"","and T.zhinengxulie in('"+zhinxl+"')")}
${if(len(gangw)=0,"","and T.gangwei like'%"+gangw+"%'")}

${if(len(jiaoyjl)=0,""," AND T.JYSEACOL like'%"+jiaoyjl+"%'")}

${if(len(DWMC)=0,""," and T.TREE_NODE_ID LIKE '%"+DWMC+"%'")}

${if(len(xuel)=0,"","and T.XUELIFENLEI in('"+xuel+"')")}
${if(len(CHANGQT_CHANDLND)=0,"","AND ISCQT='是' and CQTCDLYEAR in  ('"+CHANGQT_CHANDLND+"')")}
and T.zhiji  LIKE '99%'
${if(CQT_ID>0,"AND ISCQT='是'","")}
${switch(p_px, 0,' order by DW.TREE_NODE_NUM asc,T.zhiji DESC,T.RZDATE ASC,T.YGID asc',
           1,' order by T.zhiji asc,DW.TREE_NODE_NUM asc,T.RZDATE ASC,T.YGID asc',
           2,'order by T.zhiji desc,DW.TREE_NODE_NUM asc,T.RZDATE ASC,T.YGID asc')
}

)

)T


]]></Query>
</TableData>
<TableData name="个人信息.bak" class="com.fr.data.impl.DBTableData">
<Parameters>
<Parameter>
<Attributes name="jiaoyjl"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="zhengzmm"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="yuangfl"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="DWMC"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="zhuyfzy"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="gongzjl"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="yearsOld"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="xingb"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="zhij"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="name"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="CurrentTime"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="xuel"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="zhinxl"/>
<O>
<![CDATA[]]></O>
</Parameter>
<Parameter>
<Attributes name="gangw"/>
<O>
<![CDATA[]]></O>
</Parameter>
</Parameters>
<Attributes maxMemRowCount="-1"/>
<Connection class="com.fr.data.impl.NameDatabaseConnection">
<DatabaseName>
<![CDATA[HXXF_HR]]></DatabaseName>
</Connection>
<Query>
<![CDATA[SELECT *
FROM (
SELECT 
DISTINCT T.YGID,
T.zhiji,
T.xingming,
T.gangwei,
T.bumen,
DW.TREE_NODE_NUM
FROM ODM_HR_YGJLCX_SEARCH T
LEFT JOIN ODM_HR_DW DW
ON DW.TREE_NODE= T.BUMENID
WHERE 1=1
${if(len(gongzjl)=0 || CurrentTime='2',"","AND T.WBLASTSEACOL LIKE '%"+gongzjl+"%'")}
${if(len(gongzjl)=0,"","AND T.WBSEACOL like'%"+gongzjl+"%'")}
${if(len(name)=0,"","and T.namepinyin like'%"+name+"%'")}
${if(len(yearsOld)>0,"and( ","")}
${if(len(yearsOld)>0,yearsOld,"")}
${if(len(yearsOld)>0,")","")}
${if(len(xingb)=0,"","and T.xingbie in('"+xingb+"')")}
${if(len(zhengzmm)=0,"","and T.zzmm in('"+zhengzmm+"')")}
${switch(zhuyfzy,'',"",'1',"and T.ISzhuying like '主营%'",'2',"and T.ISzhuying like '非主营%'",'1,2',"")}
${if(len(yuangfl)=0,"","and T.YGfenlei in('"+yuangfl+"')")}
${if(len(zhij)=0,"","and T.zhiji in('"+zhij+"')")}
${if(len(zhinxl)=0,"","and T.zhinengxulie in('"+zhinxl+"')")}
${if(len(gangw)=0,"","and T.gangwei like'%"+gangw+"%'")}
${if(len(gongzjl)=0,"","AND T.WBSEACOL like'%"+gongzjl+"%'")}
${if(len(jiaoyjl)=0,""," AND T.JYSEACOL like'%"+jiaoyjl+"%'")}
${if(len(xuel)=0,"","and T.XUELIFENLEI in('"+xuel+"')")}
${if(len(DWMC)=0 ||DWMC='HX_HEAD' ,""," and T.BUMENID LIKE '%"+DWMC+"%'")}
and T.zhiji NOT LIKE '99%'
ORDER BY DW.TREE_NODE_NUM asc,T.zhiji DESC)
UNION ALL
SELECT *
FROM (SELECT 
DISTINCT T.YGID,
T.zhiji,
T.xingming,
T.gangwei,
T.bumen,
DW.TREE_NODE_NUM
FROM ODM_HR_YGJLCX_SEARCH T
LEFT JOIN ODM_HR_DW DW
ON DW.TREE_NODE= T.BUMENID
WHERE 1=1
${if(len(gongzjl)=0 || CurrentTime='2',"","AND T.WBLASTSEACOL LIKE '%"+gongzjl+"%'")}
${if(len(gongzjl)=0,"","AND T.WBSEACOL like'%"+gongzjl+"%'")}
${if(len(name)=0,"","and T.namepinyin like'%"+name+"%'")}
${if(len(yearsOld)>0,"and( ","")}
${if(len(yearsOld)>0,yearsOld,"")}
${if(len(yearsOld)>0,")","")}
${if(len(xingb)=0,"","and T.xingbie in('"+xingb+"')")}
${if(len(zhengzmm)=0,"","and T.zzmm in('"+zhengzmm+"')")}
${switch(zhuyfzy,'',"",'1',"and T.ISzhuying like '主营%'",'2',"and T.ISzhuying like '非主营%'",'1,2',"")}
${if(len(yuangfl)=0,"","and T.YGfenlei in('"+yuangfl+"')")}
${if(len(zhij)=0,"","and T.zhiji in('"+zhij+"')")}
${if(len(zhinxl)=0,"","and T.zhinengxulie in('"+zhinxl+"')")}
${if(len(gangw)=0,"","and T.gangwei like'%"+gangw+"%'")}

${if(len(jiaoyjl)=0,""," AND T.JYSEACOL like'%"+jiaoyjl+"%'")}

${if(len(DWMC)=0 ||DWMC='HX_HEAD' ,""," and T.BUMENID LIKE '%"+DWMC+"%'")}

${if(len(xuel)=0,"","and T.XUELIFENLEI in('"+xuel+"')")}

and T.zhiji  LIKE '99%'
ORDER BY DW.TREE_NODE_NUM asc,T.zhiji DESC)]]></Query>
</TableData>
</TableDataMap>
<FormMobileAttr>
<FormMobileAttr refresh="false" isUseHTML="true"/>
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
<NorthAttr size="108"/>
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
<InnerWidget class="com.fr.form.ui.ComboBox">
<WidgetName name="zhij"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<Dictionary class="com.fr.data.impl.TableDataDictionary">
<FormulaDictAttr kiName="ZHIJI" viName="ZHIJI"/>
<TableDataDictAttr>
<TableData class="com.fr.data.impl.NameTableData">
<Name>
<![CDATA[个人信息]]></Name>
</TableData>
</TableDataDictAttr>
</Dictionary>
<widgetValue>
<O>
<![CDATA[]]></O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="118" y="50" width="80" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="Labelzhij"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O>
<![CDATA[职级:]]></O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="0" autoline="true"/>
<FRFont name="SimSun" style="0" size="72"/>
<border style="0" color="-723724"/>
</InnerWidget>
<BoundsAttr x="38" y="50" width="80" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.TextEditor">
<WidgetName name="name"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<TextAttr/>
<widgetValue>
<O>
<![CDATA[]]></O>
</widgetValue>
</InnerWidget>
<BoundsAttr x="118" y="14" width="80" height="21"/>
</Widget>
<Widget class="com.fr.form.ui.container.WAbsoluteLayout$BoundsWidget">
<InnerWidget class="com.fr.form.ui.Label">
<WidgetName name="Labelname"/>
<WidgetAttr description="">
<PrivilegeControl/>
</WidgetAttr>
<widgetValue>
<O>
<![CDATA[姓名:]]></O>
</widgetValue>
<LabelAttr verticalcenter="true" textalign="0" autoline="true"/>
<FRFont name="SimSun" style="0" size="72"/>
<border style="0" color="-723724"/>
</InnerWidget>
<BoundsAttr x="38" y="14" width="80" height="21"/>
</Widget>
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
<BoundsAttr x="210" y="50" width="80" height="21"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="name"/>
<Widget widgetName="zhij"/>
</MobileWidgetList>
<Display display="true"/>
<DelayDisplayContent delay="true"/>
<Position position="0"/>
<Design_Width design_width="960"/>
<NameTagModified/>
<WidgetNameTagMap>
<NameTag name="zhij" tag="职级:"/>
<NameTag name="name" tag="姓名:"/>
</WidgetNameTagMap>
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
<![CDATA[0,864000,864000,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[0,1371600,1728000,13068300,4320000,0,7200000,2160000,0,0,2160000,0,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1" s="0">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="<input name='checkbox1' type='checkbox' value='checkbox'/>"]]></Attributes>
</O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="JavaScript1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[console.log($("input[name='checkbox1']A:checked").length);
if($("input[name='checkbox1']A:checked").length==0){
$("input[name='checkbox']A").removeAttr('checked');
_g().parameterEl.getWidgetByName('TT').setValue('');
}else{
	$("input[name='checkbox']A").attr("checked","true"); 
	var chk_value =[]A;//定义一个数组  
      $('input[name="checkbox"]A:checked').each(function(){//遍历每一个名字为interest的复选框，其中选中的执行函数  
      chk_value.push($(this).val());//将选中的值添加到数组chk_value中  
      });
      console.log(chk_value);
	_g().parameterEl.getWidgetByName('TT').setValue(chk_value);
		
}
]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="2" r="1" s="1">
<O>
<![CDATA[序号]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="1" s="2">
<O>
<![CDATA[所在部门]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="1" s="2">
<O>
<![CDATA[姓名]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="1" s="2">
<O>
<![CDATA[ID]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="1" s="2">
<O>
<![CDATA[岗位]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="1" s="2">
<O>
<![CDATA[职级]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="1" cs="2" s="1">
<O>
<![CDATA[操作]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="1" s="2">
<O>
<![CDATA[员工档案]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="2">
<O t="DSColumn">
<Attributes dsName="个人信息" columnName="YGID"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="1" r="2" s="3">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="<input name='checkbox' id='" + A4 + "' type='checkbox' value='" + A4 + "' />"]]></Attributes>
</O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="JavaScript1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="mm"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=ROW() - 1]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[var id = "r-"+mm+"-0"
var id1 = $('#'+id).find("input").val();
var status = $('#'+id).find("input").attr('checked');
if($('input[name=checkbox]A:checked').length==$('input[name=checkbox]A').length){
	$("input[name='checkbox1']A").attr("checked","true");
}else{
	$("input[name='checkbox1']A").removeAttr("checked");
}
var id2 = id1+","
var tt1=_g().parameterEl.getWidgetByName('TT').getValue();
if(status!="checked"){
	var tt3 = tt1.trim().replace(id2,'');
	var tt4 = tt3.trim().replace(id1,'');
	
	if(tt4[0]A==","){
		tt4 = tt4.substr(1);
	}else if(tt4[tt4.length-1]A==","){
		tt4 = tt4.substr(0,tt4.length-1);
		}
	_g().parameterEl.getWidgetByName('TT').setValue(tt4);
	
}else{
	
	var tt2=tt1+','+id1
	if(tt1==""){
	_g().parameterEl.getWidgetByName('TT').setValue(id1);

	}else{
	_g().parameterEl.getWidgetByName('TT').setValue(tt2);
}
}
]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand leftParentDefault="false" left="C4"/>
</C>
<C c="2" r="2" s="4">
<O t="DSColumn">
<Attributes dsName="个人信息" columnName="ROWNUM"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[row() % 2 = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Scope val="1"/>
<Background name="ColorBackground" color="-986896"/>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="3" r="2" s="5">
<O t="DSColumn">
<Attributes dsName="个人信息" columnName="BUMEN"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="4" r="2" s="5">
<O t="DSColumn">
<Attributes dsName="个人信息" columnName="XINGMING"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[len($$$) = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.ListCondition"/>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.FRFontHighlightAction">
<FRFont name="微软雅黑" style="0" size="72" foreground="-16776961" underline="1"/>
</HighlightAction>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.HyperlinkHighlightAction">
<NameJavaScriptGroup>
<NameJavaScript name="JavaScript1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="id1"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=f3]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="name_1"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=e3]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="tem"/>
<O>
<![CDATA[2]]></O>
</Parameter>
</Parameters>
<Content>
<![CDATA[var url = FR.cjkEncode('/WebReport/ReportServer?formlet=HXXF_HR/StaffInformationInquiry/Form20180620.frm&id='+id1+'&temp='+tem)
window.parent.parent.parent.$('#iframe2').attr('src',url);
window.parent.parent.parent.$('#iframe2').attr('_src',url);
window.parent.parent.parent.$('.smallIframe').show();
window.parent.parent.parent.$('.model').show();
window.parent.parent.parent.alldata.push([name_1,url]A);
window.parent.parent.parent.$('.close').attr('_name',name_1);
window.parent.parent.parent.$('.fangda').show();
window.parent.parent.parent.$('.suoxiao').hide();
window.parent.parent.parent.$('.smallIframe').css({
			width: '900px',
			height: '600px',
			left:'50%',
			top:'50%',
			marginLeft:'-450px',
			marginTop:'-300px'
		});
window.parent.parent.parent.isSmall = true;
window.parent.parent.parent.$('.small').show();
_g().parameterEl.getWidgetByName('YGID').setValue(id1);
$("#fr-btn-HR_LOG").find("button").trigger("click");
_g().parameterEl.getWidgetByName('YGID').setValue(null);]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="5" r="2" s="5">
<O t="DSColumn">
<Attributes dsName="个人信息" columnName="YGID"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="6" r="2" s="5">
<O t="DSColumn">
<Attributes dsName="个人信息" columnName="GANGWEI"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="7" r="2" s="5">
<O t="DSColumn">
<Attributes dsName="个人信息" columnName="ZHIJI"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="8" r="2" s="6">
<O>
<![CDATA[查看]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="JavaScript2">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="id1"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=F4]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[window.parent.parent.parent.$('#iframe2').attr('src','http://10.2.95.62:8080/WebReport/ReportServer?formlet=HXXF_HR%2FStaffInformationInquiry%2FForm1.frm&id='+id1);
window.parent.parent.parent.$('.smallIframe').show();

]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<Expand leftParentDefault="false" left="F4" upParentDefault="false"/>
</C>
<C c="9" r="2" s="7">
<O>
<![CDATA[下载]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="JavaScript1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="Widget1"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="员工简历_" + D4 + "_" + E4]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="Widget"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=F4]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[_g().parameterEl.getWidgetByName('YGID').setValue(Widget);
_g().parameterEl.getWidgetByName('XZ_TYPE').setValue("2");
$("#fr-btn-HR_DOWI").find("button").trigger("click");
_g().parameterEl.getWidgetByName('YGID').setValue(null);
_g().parameterEl.getWidgetByName('XZ_TYPE').setValue(null);
/*var Widget = this.options.form.getWidgetByName("tt").getValue();
alert("value:Widget="+Widget)
var Widget1 = this.options.form.getWidgetByName("tt").getText();
alert("text:Widget1="+Widget1);*/
var url = FR.cjkEncode("/WebReport/ReportServer?op=_custom_export_&cmd=word&_cpt_=WordDownload.cpt&_filename_="+Widget1+"&id="+Widget);
window.parent.parent.parent.isSmall = true;

window.open(url);]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<Expand/>
</C>
<C c="10" r="2" s="7">
<O>
<![CDATA[下载]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="word">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="Widget"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=F4]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="Widget1"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(L4 <> "干部", "员工", "干部") + "档案-" + D4 + "-" + E4]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[_g().parameterEl.getWidgetByName('YGID').setValue(Widget);
_g().parameterEl.getWidgetByName('XZ_TYPE').setValue("3");
$("#fr-btn-HR_DOWI").find("button").trigger("click");
_g().parameterEl.getWidgetByName('YGID').setValue(null);
_g().parameterEl.getWidgetByName('XZ_TYPE').setValue(null);

var url = FR.cjkEncode("/WebReport/ReportServer?op=_custom_export_&cmd=word&_cpt_=WordDownload_Cadre.cpt&_filename_="+Widget1+"&id="+Widget);
//window.parent.parent.parent.isSmall = true;
window.open(url);

]]></Content>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="pdf">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="Widget"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=F4]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="Widget1"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(L4 <> "干部", "员工", "干部") + "档案-" + D4 + "-" + E4]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[_g().parameterEl.getWidgetByName('YGID').setValue(Widget);
_g().parameterEl.getWidgetByName('XZ_TYPE').setValue("4");
$("#fr-btn-HR_DOWI").find("button").trigger("click");
_g().parameterEl.getWidgetByName('YGID').setValue(null);
_g().parameterEl.getWidgetByName('XZ_TYPE').setValue(null);

var url = FR.cjkEncode("/WebReport/ReportServer?reportlet=WordDownload_Cadre.cpt&id="+Widget+"&format=pdf&extype=simple&__filename__="+Widget1+"")
window.open(url);]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<Expand/>
</C>
<C c="11" r="2">
<O t="DSColumn">
<Attributes dsName="个人信息" columnName="YGFENLEI"/>
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
<FRFont name="微软雅黑" style="0" size="72" foreground="-16776961" underline="1"/>
<Background name="ColorBackground" color="-4194304"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72" foreground="-1"/>
<Background name="ColorBackground" color="-4194304"/>
<Border/>
</Style>
<Style horizontal_alignment="2" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72" foreground="-1"/>
<Background name="ColorBackground" color="-4194304"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72" foreground="-16776961" underline="1"/>
<Background name="ColorBackground" color="-1"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Left style="1" color="-1"/>
</Border>
</Style>
<Style horizontal_alignment="2" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="SimSun" style="0" size="72" foreground="-16776961" underline="1"/>
<Background name="NullBackground"/>
<Border>
<Left style="1" color="-1"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72" foreground="-16776961" underline="1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<isShared isshared="false"/>
<ReportFitAttr fitStateInPC="3" fitFont="false"/>
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
<![CDATA[0,864000,864000,723900,723900,723900,723900,723900,723900,723900,723900]]></RowHeight>
<ColumnWidth defaultValue="2743200">
<![CDATA[0,1371600,1728000,13068300,4320000,0,7200000,2160000,0,0,2160000,0,2743200]]></ColumnWidth>
<CellElementList>
<C c="0" r="0">
<PrivilegeControl/>
<Expand/>
</C>
<C c="1" r="1" s="0">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="<input name='checkbox1' type='checkbox' value='checkbox'/>"]]></Attributes>
</O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="JavaScript1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters/>
<Content>
<![CDATA[console.log($("input[name='checkbox1']A:checked").length);
if($("input[name='checkbox1']A:checked").length==0){
$("input[name='checkbox']A").removeAttr('checked');
_g().parameterEl.getWidgetByName('TT').setValue('');
}else{
	$("input[name='checkbox']A").attr("checked","true"); 
	var chk_value =[]A;//定义一个数组  
      $('input[name="checkbox"]A:checked').each(function(){//遍历每一个名字为interest的复选框，其中选中的执行函数  
      chk_value.push($(this).val());//将选中的值添加到数组chk_value中  
      });
      console.log(chk_value);
	_g().parameterEl.getWidgetByName('TT').setValue(chk_value);
		
}
]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand/>
</C>
<C c="2" r="1" s="1">
<O>
<![CDATA[序号]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="3" r="1" s="2">
<O>
<![CDATA[所在部门]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="4" r="1" s="2">
<O>
<![CDATA[姓名]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="5" r="1" s="2">
<O>
<![CDATA[ID]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="6" r="1" s="2">
<O>
<![CDATA[岗位]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="7" r="1" s="2">
<O>
<![CDATA[职级]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="8" r="1" cs="2" s="1">
<O>
<![CDATA[操作]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="10" r="1" s="2">
<O>
<![CDATA[员工档案]]></O>
<PrivilegeControl/>
<Expand/>
</C>
<C c="0" r="2">
<O t="DSColumn">
<Attributes dsName="个人信息" columnName="YGID"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="1" r="2" s="3">
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="<input name='checkbox' id='" + A4 + "' type='checkbox' value='" + A4 + "' />"]]></Attributes>
</O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="JavaScript1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="mm"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=ROW() - 1]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[var id = "r-"+mm+"-0"
var id1 = $('#'+id).find("input").val();
var status = $('#'+id).find("input").attr('checked');
if($('input[name=checkbox]A:checked').length==$('input[name=checkbox]A').length){
	$("input[name='checkbox1']A").attr("checked","true");
}else{
	$("input[name='checkbox1']A").removeAttr("checked");
}
var id2 = id1+","
var tt1=_g().parameterEl.getWidgetByName('TT').getValue();
if(status!="checked"){
	var tt3 = tt1.trim().replace(id2,'');
	var tt4 = tt3.trim().replace(id1,'');
	
	if(tt4[0]A==","){
		tt4 = tt4.substr(1);
	}else if(tt4[tt4.length-1]A==","){
		tt4 = tt4.substr(0,tt4.length-1);
		}
	_g().parameterEl.getWidgetByName('TT').setValue(tt4);
	
}else{
	
	var tt2=tt1+','+id1
	if(tt1==""){
	_g().parameterEl.getWidgetByName('TT').setValue(id1);

	}else{
	_g().parameterEl.getWidgetByName('TT').setValue(tt2);
}
}
]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<CellGUIAttr showAsHTML="true"/>
<CellPageAttr/>
<Expand leftParentDefault="false" left="C4"/>
</C>
<C c="2" r="2" s="4">
<O t="DSColumn">
<Attributes dsName="个人信息" columnName="ROWNUM"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[row() % 2 = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.BackgroundHighlightAction">
<Scope val="1"/>
<Background name="ColorBackground" color="-986896"/>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="3" r="2" s="5">
<O t="DSColumn">
<Attributes dsName="个人信息" columnName="BUMEN"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="4" r="2" s="5">
<O t="DSColumn">
<Attributes dsName="个人信息" columnName="XINGMING"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<HighlightList>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性1]]></Name>
<Condition class="com.fr.data.condition.FormulaCondition">
<Formula>
<![CDATA[len($$$) = 0]]></Formula>
</Condition>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.RowHeightHighlightAction"/>
</Highlight>
<Highlight class="com.fr.report.cell.cellattr.highlight.DefaultHighlight">
<Name>
<![CDATA[条件属性2]]></Name>
<Condition class="com.fr.data.condition.ListCondition"/>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.FRFontHighlightAction">
<FRFont name="微软雅黑" style="0" size="72" foreground="-16776961" underline="1"/>
</HighlightAction>
<HighlightAction class="com.fr.report.cell.cellattr.highlight.HyperlinkHighlightAction">
<NameJavaScriptGroup>
<NameJavaScript name="JavaScript1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="id1"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=f3]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="name_1"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=e3]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="tem"/>
<O>
<![CDATA[2]]></O>
</Parameter>
</Parameters>
<Content>
<![CDATA[var url = FR.cjkEncode('/WebReport/ReportServer?formlet=HXXF_HR/StaffInformationInquiry/Form20180620.frm&id='+id1+'&temp='+tem)
window.parent.parent.parent.$('#iframe2').attr('src',url);
window.parent.parent.parent.$('#iframe2').attr('_src',url);
window.parent.parent.parent.$('.smallIframe').show();
window.parent.parent.parent.$('.model').show();
window.parent.parent.parent.alldata.push([name_1,url]A);
window.parent.parent.parent.$('.close').attr('_name',name_1);
window.parent.parent.parent.$('.fangda').show();
window.parent.parent.parent.$('.suoxiao').hide();
window.parent.parent.parent.$('.smallIframe').css({
			width: '900px',
			height: '600px',
			left:'50%',
			top:'50%',
			marginLeft:'-450px',
			marginTop:'-300px'
		});
window.parent.parent.parent.isSmall = true;
window.parent.parent.parent.$('.small').show();
_g().parameterEl.getWidgetByName('YGID').setValue(id1);
$("#fr-btn-HR_LOG").find("button").trigger("click");
_g().parameterEl.getWidgetByName('YGID').setValue(null);]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
</HighlightAction>
</Highlight>
</HighlightList>
<Expand dir="0"/>
</C>
<C c="5" r="2" s="5">
<O t="DSColumn">
<Attributes dsName="个人信息" columnName="YGID"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="6" r="2" s="5">
<O t="DSColumn">
<Attributes dsName="个人信息" columnName="GANGWEI"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="7" r="2" s="5">
<O t="DSColumn">
<Attributes dsName="个人信息" columnName="ZHIJI"/>
<Complex/>
<RG class="com.fr.report.cell.cellattr.core.group.FunctionGrouper"/>
<Parameters/>
</O>
<PrivilegeControl/>
<Expand dir="0"/>
</C>
<C c="8" r="2" s="6">
<O>
<![CDATA[查看]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="JavaScript2">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="id1"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=F4]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[window.parent.parent.parent.$('#iframe2').attr('src','http://10.2.95.62:8080/WebReport/ReportServer?formlet=HXXF_HR%2FStaffInformationInquiry%2FForm1.frm&id='+id1);
window.parent.parent.parent.$('.smallIframe').show();

]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<Expand leftParentDefault="false" left="F4" upParentDefault="false"/>
</C>
<C c="9" r="2" s="7">
<O>
<![CDATA[下载]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="JavaScript1">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="Widget1"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[="员工简历_" + D4 + "_" + E4]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="Widget"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=F4]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[_g().parameterEl.getWidgetByName('YGID').setValue(Widget);
_g().parameterEl.getWidgetByName('XZ_TYPE').setValue("2");
$("#fr-btn-HR_DOWI").find("button").trigger("click");
_g().parameterEl.getWidgetByName('YGID').setValue(null);
_g().parameterEl.getWidgetByName('XZ_TYPE').setValue(null);
/*var Widget = this.options.form.getWidgetByName("tt").getValue();
alert("value:Widget="+Widget)
var Widget1 = this.options.form.getWidgetByName("tt").getText();
alert("text:Widget1="+Widget1);*/
var url = FR.cjkEncode("/WebReport/ReportServer?op=_custom_export_&cmd=word&_cpt_=WordDownload.cpt&_filename_="+Widget1+"&id="+Widget);
window.parent.parent.parent.isSmall = true;

window.open(url);]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<Expand/>
</C>
<C c="10" r="2" s="7">
<O>
<![CDATA[下载]]></O>
<PrivilegeControl/>
<NameJavaScriptGroup>
<NameJavaScript name="word">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="Widget"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=F4]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="Widget1"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(L4 <> "干部", "员工", "干部") + "档案-" + D4 + "-" + E4]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[_g().parameterEl.getWidgetByName('YGID').setValue(Widget);
_g().parameterEl.getWidgetByName('XZ_TYPE').setValue("3");
$("#fr-btn-HR_DOWI").find("button").trigger("click");
_g().parameterEl.getWidgetByName('YGID').setValue(null);
_g().parameterEl.getWidgetByName('XZ_TYPE').setValue(null);

var url = FR.cjkEncode("/WebReport/ReportServer?op=_custom_export_&cmd=word&_cpt_=WordDownload_Cadre.cpt&_filename_="+Widget1+"&id="+Widget);
//window.parent.parent.parent.isSmall = true;
window.open(url);

]]></Content>
</JavaScript>
</NameJavaScript>
<NameJavaScript name="pdf">
<JavaScript class="com.fr.js.JavaScriptImpl">
<Parameters>
<Parameter>
<Attributes name="Widget"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=F4]]></Attributes>
</O>
</Parameter>
<Parameter>
<Attributes name="Widget1"/>
<O t="Formula" class="Formula">
<Attributes>
<![CDATA[=if(L4 <> "干部", "员工", "干部") + "档案-" + D4 + "-" + E4]]></Attributes>
</O>
</Parameter>
</Parameters>
<Content>
<![CDATA[_g().parameterEl.getWidgetByName('YGID').setValue(Widget);
_g().parameterEl.getWidgetByName('XZ_TYPE').setValue("4");
$("#fr-btn-HR_DOWI").find("button").trigger("click");
_g().parameterEl.getWidgetByName('YGID').setValue(null);
_g().parameterEl.getWidgetByName('XZ_TYPE').setValue(null);

var url = FR.cjkEncode("/WebReport/ReportServer?reportlet=WordDownload_Cadre.cpt&id="+Widget+"&format=pdf&extype=simple&__filename__="+Widget1+"")
window.open(url);]]></Content>
</JavaScript>
</NameJavaScript>
</NameJavaScriptGroup>
<Expand/>
</C>
<C c="11" r="2">
<O t="DSColumn">
<Attributes dsName="个人信息" columnName="YGFENLEI"/>
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
<FRFont name="微软雅黑" style="0" size="72" foreground="-16776961" underline="1"/>
<Background name="ColorBackground" color="-4194304"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72" foreground="-1"/>
<Background name="ColorBackground" color="-4194304"/>
<Border/>
</Style>
<Style horizontal_alignment="2" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72" foreground="-1"/>
<Background name="ColorBackground" color="-4194304"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72" foreground="-16776961" underline="1"/>
<Background name="ColorBackground" color="-1"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="NullBackground"/>
<Border>
<Left style="1" color="-1"/>
</Border>
</Style>
<Style horizontal_alignment="2" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72"/>
<Background name="NullBackground"/>
<Border/>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="SimSun" style="0" size="72" foreground="-16776961" underline="1"/>
<Background name="NullBackground"/>
<Border>
<Left style="1" color="-1"/>
</Border>
</Style>
<Style horizontal_alignment="0" imageLayout="1">
<FRFont name="微软雅黑" style="0" size="72" foreground="-16776961" underline="1"/>
<Background name="NullBackground"/>
<Border/>
</Style>
</StyleList>
<heightRestrict heightrestrict="false"/>
<heightPercent heightpercent="0.75"/>
<isShared isshared="false"/>
<ReportFitAttr fitStateInPC="3" fitFont="false"/>
<ElementCaseMobileAttrProvider horizontal="1" vertical="0" zoom="true" refresh="false" isUseHTML="false"/>
</body>
</InnerWidget>
<BoundsAttr x="0" y="0" width="400" height="540"/>
</Widget>
<Sorted sorted="false"/>
<MobileWidgetList>
<Widget widgetName="report0"/>
</MobileWidgetList>
<WidgetZoomAttr compState="0"/>
<AppRelayout appRelayout="true"/>
<Size width="400" height="540"/>
<ResolutionScalingAttr percent="1.0"/>
<BodyLayoutType type="0"/>
</Center>
</Layout>
<DesignerVersion DesignerVersion="IAA"/>
<PreviewType PreviewType="0"/>
<TemplateID TemplateID="5a9a4fe3-c843-4c33-8bba-f3b0ecf2780d"/>
</Form>
