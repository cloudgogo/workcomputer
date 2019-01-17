sqlplus输出变量到shell
2018年08月03日 16:19:05 仰望星空的我 阅读数：80
一般情况下，shell变量带入到sql脚本，比较方便，但是把sql的一些结果，输出给shell，就比较麻烦一些了。以前用的方法比较土一点，就是在sqlplus里面，spool到一个临时文件，然后在shell里面用grep，awk一类的来分析这个输出文件。后来在网上看到一篇介绍，受益匪浅啊。在此表示感谢。



我试了三种，一个是退出sqlplus时顺带返回值。这个方法有限制，只能是数字，不能是字符串。

 

SQL> col global_name new_value xxx
SQL> select global_name from global_name;

GLOBAL_NAME
--------------------------------------------------------------------------------
XXX.XXX.XXX

SQL> exit xxx
SP2-0584: EXIT variable "XXX" was non-numeric

 

第二个就是直接select语句的输出。

脚本如下(test1.sh)：

#!/bin/bash
VALUE=`sqlplus -S user/pass@tns <<EOF
set heading off feedback off pagesize 0 verify off echo off numwidth 4
select * from global_name;
exit
EOF`

echo $VALUE

测试结果如下：

[root@xxx tmp]# sh test1.sh
XXX.XXX.COM
[root@xxx tmp]#

 

第三个是定义一个变量，然后在sqlplus里面print。

脚本如下（test2.sh）：

#!/bin/bash

VALUE=`sqlplus -S user/pass@tns  <<EOF
set heading off feedback off pagesize 0 verify off echo off numwidth 4
var username varchar2(30)
begin
  select user into :username from dual;
  :username := 'username '|| :username;
end;
/

print username
exit
EOF`

echo $VALUE

 

测试结果如下：

[root@xxxtmp]# sh test2.sh
username USER_A
[root@xxxtmp]#