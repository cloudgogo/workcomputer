使用shell中的sed命令时，发现不能把shell定义的变量传递进去，

shell命令如下：

sed -n ’${fileLength[$j]},$newline p‘ ${fileName[$j]} >> all.log

发现只需要将sed -n '${fileLength[$j]},$newline p' ${fileName[$j]} >> all.log

中的单引号，改成双引号就可以了。

sed -n "${fileLength[$j]},$newline p" ${fileName[$j]} >> all.log
