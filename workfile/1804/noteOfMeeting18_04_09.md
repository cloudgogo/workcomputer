# 2018/4/9会议记录
## 记录
1. 经济资本设置不需要进行过多设置
2. 财务系统金融资产,产品代码产品名称维护问题,手工维护的问题
3. 核对表差值原因排查
4. 债券资产原样导出导入提交
5. 权益类投资 资产代码海波龙抽取的值给0
6. 信托计划,考虑是否复制上月的某些结果
7. 其他添加表项
8. 经济资本信用分析 信托及类信托计划
9. 经济资本修改穿透到明细



## 信用风险表内汇总表对应关系
现金黄金 attribute5 :9110
其他现金 有两个 attribute5 : 3110 6110
14 其他 
9210
9220
9230
到
9270 
对应其attribute5

/FIN_REPORT /FIN_EBS_PRJECT_DETAIL/FIN_INVESTMENT_OTHER_SHOW.cpt&op=view
p_period
p_attribute5
信用风险（表内）汇总表
contentPane.loadSheetByName('CR_信托及类信托计划汇总表'); 



p_attribute5  p_period
11 钻取到债权投资
11.1 融资融券 2950 2960
11.2 约定购回 2970
11.3 股票质押 2980
11.4 其他对个人的债权 2990
12 不良资产投资 sql中写死8310
10 对一般企事业债权 钻取到本表对公债权明细
05,06,07,09 钻取到综合类 加个类别参数  --未修改sql逻辑,还需要修改
p_attribute5
p_convertable
p_financial_type
p_period
04 债券投资
p_convertable
p_period
p_level

02
p_bondsubject
03 
AAA','A-1','AA+','AA','AA-','A+','A','A-