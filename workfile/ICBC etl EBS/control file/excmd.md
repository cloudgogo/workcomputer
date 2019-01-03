# shell 
```
sqlldr maadmin/maadmin@madb control=users.ctl bad=bad/bad.log log=log/log.log
```

```
SQL*LOADER是ORACLE的数据加载工具，通常用来将操作系统文件迁移到ORACLE数据库中。SQL*LOADER是大型数据仓库选择使用的加载方法，因为它提供了最快速的途径（DIRECT，PARALLEL）。现在，我们抛开其理论不谈，用实例来使您快速掌握SQL*LOADER的使用方法。
　　首先，我们认识一下SQL*LOADER。
　　在NT下，SQL*LOADER的命令为SQLLDR，在UNIX下一般为sqlldr/sqlload。
　　如执行：d:\oracle>sqlldr
SQL*Loader: Release 8.1.6.0.0 - Production on 星期二 1月 8 11:06:42 2002
(c) Copyright 1999 Oracle Corporation.   All rights reserved.

用法: SQLLOAD 关键字 = 值 [,keyword=value,...]
有效的关键字:
     userid -- ORACLE username/password
     control -- Control file name(控制文件)
     log -- Log file name(记录的日志文件)
     bad -- Bad file name(坏数据文件)
     data -- Data file name(数据文件)
     discard -- Discard file name(丢弃的数据文件)
     discardmax -- Number of discards to allow(允许丢弃数据的最大值)  (全部默认)
     skip -- Number of logical records to skip   (默认0)
     load -- Number of logical records to load   (全部默认)
     errors -- Number of errors to allow（允许的错误记录数）(默认50)
     rows -- Number of rows in conventional path bind array or between direct path data saves
               （每次提交的记录数，默认: 常规路径 64, 所有直接路径）
     bindsize -- Size of conventional path bind array in bytes(默认65536)
                        （每次提交记录的缓冲区的大小(字节为单位，默认256000)）
     silent -- Suppress messages during run (header,feedback,errors,discards,partitions)（禁止输出信息）
     direct -- use direct path （使用直通路径方式导入）                    (默认FALSE)
     parfile -- parameter file: name of file that contains parameter specifications
     parallel -- do parallel load   （并行导入）                 (默认FALSE)
     file -- File to allocate extents from
            （与bindsize成对使用，其中较小者会自动调整到较大者sqlldr先计算单条记录长度，乘以rows，如小bindsize     不           会rows以填充bindsize；如超出，则以bindsize为准。）
     skip_unusable_indexes -- disallow/allow unusable indexes or index partitions(默认FALSE)
     skip_index_maintenance -- do not maintain indexes, mark affected indexes as unusable(默认FALSE)
     commit_discontinued -- commit loaded rows when load is discontinued(默认FALSE)
     readsize -- Size of Read buffer                 (默认1048576)
PLEASE NOTE: 命令行参数可以由位置或关键字指定。
前者的例子是 'sqlload scott/tiger foo';后者的例子是 'sqlload control=foo userid=scott/tiger'.位置指定参数的时间必须早于但不可迟于由关键字指定的参数。例如,
'SQLLOAD SCott/tiger control=foo logfile=log', 但'不允许 sqlload scott/tiger control=foo log',即使允许
参数 'log' 的位置正确。
d:\oracle>
     我们可以从中看到一些基本的帮助信息，这里，我用到的是中文的WIN2000　ADV　SERVER。
　　我们知道，SQL*LOADER只能导入纯文本，所以我们现在开始以实例来讲解其用法。
　　一、已存在数据源result.csv，欲倒入ORACLE中FANCY用户下。
　　　　result.csv内容：
　　1,默认 Web 站点,192.168.2.254:80:,RUNNING
　　2,other,192.168.2.254:80:test.com,STOPPED
　　3,third,192.168.2.254:81:thirdabc.com,RUNNING
　　从中，我们看出4列，分别以逗号分隔，为变长字符串。
　　二、制定控制文件result.ctl
             
命令

说明

 

load data ..........    控制文件标识

infile 'model.txt'　............  要输入的数据文件名为test.txt

append into table system.表名 ............ 向表test中追加记录

fields terminated by X'09'   .......        指定分隔符，字段终止于X'09'，是一个制表符（TAB）

(编号,名称,大小)  ......... 定义列对应表中顺序


        如下实例 result.ctl内容：
       load data
       infile 'result.csv'
       into table resultxt
       fields terminated by ','
       TRAILING   NULLCOLS..........表示如表的字段没有对应的值时允许为空。
       (resultid POSITION(1:8),
        website ,
        ipport char terminated by ',',
        status char terminated by whitespace)
　　说明：
　　infile　指数据源文件　这里我们省略了默认的　discardfile result.dsc   badfile   result.bad
　　into table resultxt 默认是INSERT，也可以into table resultxt APPEND为追加方式，或REPLACE
　　terminated by ','　指用逗号分隔
　　terminated by whitespace　结尾以空白分隔
      
控制文件中指定插入数据的方式关键字

l         insert，为缺省方式，在数据装载开始时要求表为空

l         append，在表中追加新记录

l         replace，删除旧记录，替换成新装载的记录

l         truncate，同上

position(m:n)表示该字段是从位置m到位置n。

 

　　三、此时我们执行加载：
                D:\>sqlldr userid=fancy/testpass control=result.ctl log=resulthis.out
                SQL*Loader: Release 8.1.6.0.0 - Production on 星期二 1月 8 10:25:42 2002
                (c) Copyright 1999 Oracle Corporation.   All rights reserved.
                SQL*Loader-941:   在描述表RESULTXT时出现错误
                ORA-04043: 对象 RESULTXT 不存在
　　        提示出错，因为数据库没有对应的表。
　　四、在数据库建立表
　            create table resultxt
               (resultid varchar2(500),
                website varchar2(500),
                ipport varchar2(500),
                status varchar2(500))

　　五、重新执行加载
　　        D:\>sqlldr userid=fancy/k1i7l6l8 control=result.ctl log=resulthis.out
               SQL*Loader: Release 8.1.6.0.0 - Production on 星期二 1月 8 10:31:57 2002
               (c) Copyright 1999 Oracle Corporation.   All rights reserved.
               达到提交点，逻辑记录计数2
               达到提交点，逻辑记录计数3
　　       已经成功！我们可以通过日志文件来分析其过程：resulthis.out内容如下：
               SQL*Loader: Release 8.1.6.0.0 - Production on 星期二 1月 8 10:31:57 2002
               (c) Copyright 1999 Oracle Corporation.   All rights reserved.
               控制文件: result.ctl
               数据文件: result.csv
               错误文件: result.bad
               废弃文件: 未作指定(可废弃所有记录)
               装载数: ALL
               跳过数: 0
               允许的错误: 50
               绑定数组: 64 行，最大 65536 字节
               继续:     未作指定
               所用路径:        常规
               表RESULTXT
              已载入从每个逻辑记录
              插入选项对此表INSERT生效
    列名                         位置       长度   中止 包装数据类型
------------------------------ ---------- ----- ---- ---- ---------------------
RESULTID                             FIRST      *     ,       CHARACTER            
WEBSITE                               NEXT      *     ,       CHARACTER            
IPPORT                                NEXT      *     ,       CHARACTER            
STATUS                                NEXT      *   WHT       CHARACTER            

表RESULTXT: 
3 行载入成功
由于数据错误, 0 行没有载入。
由于所有 WHEN 子句失败, 0 行没有载入。
由于所有字段都为空的, 0 行没有载入。

为结合数组分配的空间:     65016字节（63行）
除绑定数组外的内存空间分配:          0字节
跳过的逻辑记录总数:         0
读取的逻辑记录总数:         3
拒绝的逻辑记录总数:         0
废弃的逻辑记录总数:         0
从星期二 1月   08 10:31:57 2002开始运行
在星期二 1月   08 10:32:00 2002处运行结束
经过时间为: 00: 00: 02.70
CPU 时间为: 00: 00: 00.10(可
　　六、并发操作
　　sqlldr userid=/ control=result1.ctl direct=true parallel=true
        sqlldr userid=/ control=result2.ctl direct=true parallel=true
        sqlldr userid=/ control=result3.ctl direct=true parallel=true
        当加载大量数据时（大约超过10GB），最好抑制日志的产生：
　　SQL>ALTER TABLE RESULTXT nologging;
     这样不产生REDOLOG，可以提高效率。然后在CONTROL文件中load data上面加一行：unrecoverable 
     此选项必须要与DIRECT共同应用。
```