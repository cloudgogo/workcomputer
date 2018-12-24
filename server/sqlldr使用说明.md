# sqlldr用法

> 最近在做工银投资的项目，在etl方面，底层的数据是通过cvs文件导入数据库中，cvs文件会定时刷新到数据库服务器,提供的方案是sqlldr倒数，因此记录此文档


- 在 Oracle 数据库中，我们通常在不同数据库的表间记录进行复制或迁移时会用以下几种方法：

1. A 表的记录导出为一条条分号隔开的 insert 语句，然后执行插入到 B 表中
2. 建立数据库间的 dblink，然后用 create table B as select * from A@dblink where ...，或 insert into B select * from A@dblink where ...
3. exp A 表，再 imp 到 B 表，exp 时可加查询条件
4. 程序实现 select from A ..，然后 insert into B ...，也要分批提交
5. 再就是本篇要说到的 Sql Loader(sqlldr) 来导入数据，效果比起逐条 insert 来很明显

- 第 1 种方法在记录多时是个噩梦，需三五百条的分批提交，否则客户端会死掉，而且导入过程很慢。如果要不产生 REDO 来提高 insert into 的性能，就要下面那样做：

```sql
alter table B nologging;  
insert /* +APPEND */ into B(c1,c2) values(x,xx);  
insert /* +APPEND */ into B select * from A@dblink where .....;  
```
- 好 啦，前面简述了 Oracle 中数据导入导出的各种方法，我想一定还有更高明的。下面重点讲讲 Oracle  的 Sql Loader (sqlldr) 的用法。

- 在命令行下执行 Oracle  的 sqlldr 命令，可以看到它的详细参数说明，要着重关注以下几个参数：
```txt
userid -- Oracle 的 username/password[@servicename]
control -- 控制文件，可能包含表的数据
-------------------------------------------------------------------------------------------------------
log -- 记录导入时的日志文件，默认为 控制文件(去除扩展名).log
bad -- 坏数据文件，默认为 控制文件(去除扩展名).bad
data -- 数据文件，一般在控制文件中指定。用参数控制文件中不指定数据文件更适于自动操作
errors -- 允许的错误记录数，可以用他来控制一条记录都不能错
rows -- 多少条记录提交一次，默认为 64
skip -- 跳过的行数，比如导出的数据文件前面几行是表头或其他描述
```
还有更多的 sqlldr 的参数说明请参考：sql loader的用法。

- 用例子来演示 sqlldr 的使用，有两种使用方法：

1. 只使用一个控制文件，在这个控制文件中包含数据
2. 使用一个控制文件(作为模板) 和一个数据文件

一般为了利于模板和数据的 分离，以及程序的不同分工会使用第二种方式，所以先来看这种用法。数据文件可以是 CSV 文件或者以其他分割符分隔的，数据文件可以用 PL/SQL Developer 或者 Toad 导出，也可以用 SQL *Plus 的  spool 格式化产出，或是 UTL_FILE 包生成。另外，用 Toad 还能直接生成包含数据的控制文件。


首先，假定有这么一个表 users，并插入五条记录：
```sql
create table users(  
    user_id number,           --用户 ID  
    user_name varchar2(50),   --用户名  
    login_times number,       --登陆次数  
    last_login date           --最后登录日期  
)  

insert into users values(1,'Unmi',3,sysdate);  
insert into users values(2,NULL,5,to_date('2008-10-15','YYYY-MM-DD'));  
insert into users values(3,'隔叶黄莺 ',8,to_date('2009-01-02','YYYY-MM-DD'));  
insert into users values(4,'Kypfos',NULL,NULL);  
insert into users values(5,'不知秋 ',1,to_date('2008-12-23','YYYY-MM-DD'));  
```
第 二种方式： 使用一个控制文件(作为模板) 和一个数据文件

1) 建立数据文件，我们这里用 PL/SQL Developer 导出表 users 的记录为 users_data.csv 文件，内容如下：
```csv
"   ","USER_ID","USER_NAME","LOGIN_TIMES","LAST_LOGIN"  
"1","1","Unmi","3","2009-1-5 20:34:44"  
"2","2","","5","2008-10-15"  
"3","3","隔叶黄莺","8","2009-1-2"  
"4","4","Kypfos","",""  
"5","5","不知秋","1","2008-12-23"  
```
2) 建立一个控制文件 users.ctl，内容如下：
```ctl
OPTIONS (skip=1,rows=128) -- sqlldr 命令显示的 选项可以写到这里边来,skip=1 用来跳过数据中的第一行  
LOAD DATA  
INFILE "users_data.csv" --指定外部数据文件，可以写多 个 INFILE "another_data_file.csv" 指定多个数据文件  
--这里还可以使 用 BADFILE、DISCARDFILE 来指定坏数据和丢弃数据的文件，  
truncate --操作类型，用 truncate table 来清除表中原有 记录  
INTO TABLE users -- 要插入记录的表  
Fields terminated by "," -- 数据中每行记录用 "," 分隔  
Optionally enclosed by '"' -- 数据中每个字段用 '"' 框起，比如字段中有 "," 分隔符时  
trailing nullcols --表的字段没有对应的值时允 许为空  
(  
  virtual_column FILLER, --这是一个虚拟字段，用来跳 过由 PL/SQL Developer 生成的第一列序号  
  user_id number, --字段可以指定类型，否则认 为是 CHARACTER 类型, log 文件中有显示  
  user_name,  
  login_times,  
  last_login DATE "YYYY-MM-DD HH24:MI:SS" -- 指定接受日期的格式，相当用 to_date() 函数转换  
)  
```
- 说 明：在操作类型 truncate 位置可用以下中的一值：
```
1) insert     --为缺省方式，在数据装载开始时要求表为空
2) append  --在表中追加新记录
3) replace  --删除旧记录(用 delete from table 语句)，替换成新装载的记录
4) truncate --删除旧记录(用 truncate table 语句)，替换成新装载的记录
```
3) 执行命令：

sqlldr dbuser/dbpass@dbservice control=users.ctl

##**注意**
**可能是由于版本原因，我在本地时，number类型的数据无法通过脚本插入，报350的错误，后通过将`user_id`替换为`user_id "to_number(:user_id)"`**

> 在 dbservice 指示的数据库的表 users 中记录就和数据文件中的一样了。

> 执行完 sqlldr 后希望能留意一下生成的几个文件，如 users.log 日志文件、users.bad 坏数据文件等。特别是要看看日志文件，从中可让你更好的理解 Sql Loader，里面有对控制文件的解析、列出每个字段的类型、加载记录的统计、出错原因等信息。



- 第一种方式，只使用一个控制文件 在这个控制文件中包含数据

1) 把 users_data.cvs 中的内容补到 users.ctl 中，并以 BEGINDATA 连接，还要把 INFILE "users_data.csv" 改为 INFILE *。同时为了更大化的说明问题，把数据处理了一下。此时，完整的 users.ctl 文件内容是：
```ctl
OPTIONS (skip=1,rows=128) -- sqlldr 命令显示的 选项可以写到这里边来,skip=1 用来跳过数据中的第一行  
LOAD DATA  
INFILE *  -- 因为数据同控制文件在一 起，所以用 * 表示  
append    -- 这里用 了 append 来操作，在表 users 中附加记录   
INTO TABLE users  
when LOGIN_TIMES<>'8'  -- 还可以用 when 子 句选择导入符合条件的记录  
Fields terminated by ","  
trailing nullcols  
(  
  virtual_column FILLER, --跳过 由 PL/SQL Developer 生成的第一列序号  
  user_id "user_seq.nextval", --这一列直接取序列的下一值，而不用数据中提供的值  
  user_name "'Hi '||upper(:user_name)",--,还能用SQL函数或运算对数据进行加工处理  
  login_times terminated by ",", NULLIF(login_times='NULL') --可为列单独指定分隔符  
  last_login DATE "YYYY-MM-DD HH24:MI:SS" NULLIF (last_login="NULL") -- 当字段为"NULL"时就是 NULL  
)  
BEGINDATA --数据从这里开始  
   ,USER_ID,USER_NAME,LOGIN_TIMES,LAST_LOGIN  
1,1,Unmi,3,2009-1-5 20:34  
2,2,Fantasia,5,2008-10-15  
3,3,隔叶黄 莺,8,2009-1-2  
4,4,Kypfos,NULL,NULL  
5,5,不知 秋,1,2008-12-23  
```
2) 执行一样的命令：
```sh
sqlldr dbuser/dbpass@dbservice control=users.ctl
```

> 比 如，在控制台会显示这样的信息：
```console
C:\>sqlldr dbuser/dbpass@dbservice control=users.ctl
SQL*Loader: Release 9.2.0.1.0 - Production on 星期三 1月 7 22:26:25 2009

Copyright (c) 1982, 2002, Oracle Corporation.  All rights reserved.

达到提交点，逻辑记录计数4
达到提交点，逻辑记录计数5
```
上面的控制文 件包含的内容比较复杂(演示目的)，请根据注释理解每个参数的意义。还能由此发掘更多用法。

最后说下有关 SQL *Loader 的性能与并发操作

1) ROWS 的默认值为 64，你可以根据实际指定更合适的 ROWS 参数来指定每次提交记录数。(体验过在 PL/SQL Developer 中一次执行几条条以上的 insert 语句的情形吗？)

2）常规导入可以通过使用 INSERT语句来导入数据。Direct导入可以跳过数据库的相关逻辑(DIRECT=TRUE)，而直接将数据导入到数据文件中，可以提高导入数据的 性能。当然，在很多情况下，不能使用此参数(如果主键重复的话会使索引的状态变成UNUSABLE!)。

3) 通过指定 UNRECOVERABLE选项，可以关闭数据库的日志(是否要 alter table table1 nologging 呢?)。这个选项只能和 direct 一起使用。

4) 对于超大数据文件的导入就要用并发操作了，即同时运行多个导入任务.

  sqlldr   userid=/   control=result1.ctl   direct=true   parallel=true   
  sqlldr   userid=/   control=result2.ctl   direct=true   parallel=true   
  sqlldr   userid=/   control=result2.ctl   direct=true   parallel=true  

  当加载大量数据时（大约超过10GB），最好抑制日志的产生：   
  
  SQL>ALTER   TABLE   RESULTXT   nologging; 
  
  这样不产生REDO LOG，可以提高效率。然后在 CONTROL 文件中 load data 上面加一行：unrecoverable，  此选项必须要与DIRECT共同应用。   
  
  在并发操作时，ORACLE声称可以达到每小时处理100GB数据的能力！其实，估计能到 1－10G 就算不错了，开始可用结构 相同的文件，但只有少量数据，成功后开始加载大量数据，这样可以避免时间的浪费。

（注意：一般只能用ASCII码形式，切记要转换编码，不然导入数据为空）