## sqlldr控制文件及参数说明：

```sh
CHARACTERSET 'UTF8'            //指定使用的字符集为UTF-8
infile 'D:\data\test3.csv'     //指定数据文件位置
append into table test_tab1    //指定导入数据的表
fields terminated by ',' ,'optionally enclosed by '"'    //字段之间的分隔值为逗号,界定符号为""
TRAILING NULLCOLS              //没有值的字段设置为空
(
COMPANY ,                      //从数据文件中读入的列
STARTDATE Date "yyyy-mm-dd" ,        //设置日期格式
ENDDATE Date "yyyy-mm-dd" ,
ID "test.NEXTVAL",                   //ID的取值为序列  
IMPDATE "to_date('2012-06-30 21:30:36','yyyy-mm-dd hh24:mi:ss')", //插入固定日期格式的值
FLAG constant"open"                      //constant 指定插入默认值"open",而不是从指定的数据文件中读取记录
)
```
 

- 导入命令：
```sh
sqlldr user/password control=test.ctl skip=1 load=200000 errors=100 rows=1000  bindsize=33554432
```

参数|说明
:--|:--
user/password  |数据库的用户名密码
control        |sqlldr控制文件位置
skip=1         |表示跳过第一行，从第二行开始导入
load=200000    |表示并不导入所有的数据，只导入跳过skip参数后的200000条数据
rows=1000      |表示一次加载的行数，默认值为64，此处设置为1000
errors=100     |表示出错100次后，停止加载
bindsize=33554432 |表示每次提交记录缓冲区的大小，默认256k
