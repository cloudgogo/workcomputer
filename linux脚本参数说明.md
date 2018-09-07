## LINUX脚本传参
**目的**
- 由于每次执行一些固定的操作<br>*（比如从根目录的位置，nohup开启服务并挂在后台等等操作，我的传参目的是为了实现github提交时自定义不要使用`-m`作为提交参数,可以直接提交或者是直接在命令后加上提交的说明）*

**脚本实例**

```s
#!/bin/bash

echo "Shell 输出脚本名称及参数";
echo "执行的脚本名：$0";
echo "第一个参数为：$1";
echo "第二个参数为：$2";
echo "第三个参数为：$3";
```

我们再给脚本赋予运行权限后，运行输出：
```s
$ chmod +x test.sh 
$ ./test.sh 1 2 3

Shell 传递参数实例！
执行的文件名：./test.sh
第一个参数为：1
第二个参数为：2
第三个参数为：3
```



**传参说明**
参数处理|说明
:--|:--
$#|	传递到脚本的参数个数
$*|	以一个单字符串显示所有向脚本传递的参数。<br>如"$*"用「"」括起来的情况、以"$1 $2 … $n"的形式输出所有参数。
$$|	脚本运行的当前进程ID号
$!|	后台运行的最后一个进程的ID号
$@|	与$*相同，但是使用时加引号，并在引号中返回每个参数。<br>如"$@"用「"」括起来的情况、以"$1" "$2" … "$n" 的形式输出所有参数。
$-|	显示Shell使用的当前选项，与set命令功能相同。
$?|	显示最后命令的退出状态。0表示没有错误，其他任何值表明有错误。
 


**题外**
- 命令回顾

    命令|作用
    :--|:--
    mkdir +文件夹名字 | 创建文件夹
    touch +文件名字| 创建文件
    rm -fr + name| 删除文件，问价夹 -f强制删除 -r是递归
    vi及vim| 是编辑工具 vi文件名可创建文件
    chmod 555 scriptname |允许任何人都具有可读权和执行权限。
    chmod +rx scriptname |允许任何人都具有可读权和执行权限
    chmod u+rx scriptname| 只给脚本的所有者可读和执行权限

- `#!/bin/bash`的意义
    + shell脚本需要指定使用什么解释器来解释这个脚本，shell脚本中#!/bin/bash表示当前脚本由/bin/bash这个程序来执行
    + Linux中的shell有多种类型，其中最常用的几种是Bourne   shell（sh）、bash、C   shell（csh）和Korn   shell（ksh）

        1. Bourne Shell(即sh)是UNIX最初使用的shell，平且在每种UNIX上都可以使用。Bourne Shell在shell编程方便相当优秀，但在处理与用户的交互方便作得不如其他几种shell。

        2. LinuxOS默认的是Bourne Again Shell，它是Bourne Shell的扩展，简称bash，与Bourne Shell完全兼容，并且在Bourne Shell的基础上增加，增强了很多特性。可以提供命令补全，命令编辑和命令历史等功能。它还包含了很多C Shell和Korn Shell中的优点，有灵活和强大的编辑接口，同时又很友好的用户界面
        3. C Shell是一种比Bourne Shell更适合的变种Shell，它的语法与C语言很相似。Linux为喜欢使用C Shell的人提供了Tcsh。
        <br>Tcsh是C Shell的一个扩展版本。Tcsh包括命令行编辑，可编程单词补全，拼写校正，历史命令替换，作业控制和类似C语言的语法，他不仅和Bash Shell提示符兼容，而且还提供比Bash Shell更多的提示符参数。
        4. Korn Shell集合了C Shell和Bourne Shell的优点并且和Bourne Shell完全兼容。Linux系统提供了pdksh（ksh的扩展），它支持人物控制，可以在命令行上挂起，后台执行，唤醒或终止程序。



    + 脚本文件中不加#!/bin/bash可以吗？

        因为一般linux用户的默认shell都是bash，脚本运行时候会用用户的默认shell来解释脚本（如果#!/bin/bash不写的话），但很多unix系统可能会用bourne shell、csh或者ksh等来作为用户默认shell，如果脚本中包含的有符合bash语法却又让其他shell无法解释的代码存在，那么就必须在第一行写上这个（当然还要这个系统上安装了bash），以保证脚本的正常运行

- 参考资料
```
$# 是传给脚本的参数个数

$0 是脚本本身的名字
$1 是传递给该shell脚本的第一个参数
$2 是传递给该shell脚本的第二个参数
$@ 是传给脚本的所有参数的列表
$* 是以一个单字符串显示所有向脚本传递的参数，与位置变量不同，参数可超过9个
$$ 是脚本运行的当前进程ID号
$? 是显示最后命令的退出状态，0表示没有错误，其他表示有错误
 
区别：$@, $*

相同点：都是引用所有参数
不同点：$* 和 $@ 都表示传递给函数或脚本的所有参数，不被双引号(" ")包含时，都以"$1" "$2" … "$n" 的形式输出所有参数。但是当它们被双引号(" ")包含时，"$*" 会将所有的参数作为一个整体，以"$1 $2 … $n"的形式输出所有参数；"$@" 会将各个参数分开，以"$1" "$2" … "$n" 的形式输出所有参数。

$*和$@详细区别请看此处

复制代码
#!/bin/bash

echo "-----------------"
for key in "$@"
do
    echo '$@' $key
done
echo "-----------------------------"
for key2 in $*
do
    echo '$*' $key2
done

1、带引号执行及结果： 
[root@localhost ~]# bash file.sh linux "python c"
-----------------
$@ linux
$@ python c
-----------------------------
$* linux
$* python
$* c
2、不带引号执行及结果： 
[root@localhost ~]# bash file.sh linux python c
-----------------
$@ linux
$@ python
$@ c
-----------------------------
$* linux
$* python
$* c
```



### 测试
> 基于云开发环境codingStudio
切换coding账户再转至root权限
```s
 ➜  /etc su coding
Password:
➜  /etc w
 08:11:06 up 15 days,  1:27,  0 users,  load average: 0.00, 0.00, 0.00
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
➜  /etc sudo su
root@coding:/etc# ll
```
为test1.sh文件赋权
```s
root@coding:/home/coding/workspace/linux# chmod 777  test1.sh
root@coding:/home/coding/workspace/linux# ll
total 12
drwxr-xr-x 2 coding coding 4096 Aug 31 03:26 ./
drwxr-xr-x 8 coding coding 4096 Sep  1 09:47 ../
-rwxrwxrwx 1 coding coding  182 Sep  3 01:33 test1.sh*
```
查看test1.sh文件
```s
root@coding:/home/coding/workspace/linux# cat test1.sh
#!/bin/bash

echo "Shell 输出脚本名称及参数";
echo "执行的脚本名：$0";
echo "第一个参数为：$1";
echo "第二个参数为：$2";
echo "第三个参数为：$3";root@coding:/home/coding/workspace/linux#
root@coding:/home/coding/workspace/linux# ./test1.sh
bash: ./test1.sh: Permission denied
root@coding:/home/coding/workspace/linux# ll
```
执行并查看结果
```s
root@coding:/home/coding/workspace/linux# ./test1.sh a  b c
Shell 输出脚本名称及参数
执行的脚本名：./test1.sh
第一个参数为：a
第二个参数为：b
第三个参数为：c
```