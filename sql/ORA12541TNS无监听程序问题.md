# ORA-12541:TNS:无监听程序问题
> 安装完oracle后使用plsql连接无法连接并报上错,查看tns无错,使用sqlplus登录无错,遂上网,现此方案



今日发现一个问题，本地连接数据库正常，但远程连接就出现问题。    

因为本人使用的macOS系统，无法安装oracle 11g。因此在vmware虚拟机安装了win7系统，然后在windows下安装了oracle 11g。结果在windows环境下，可以连接数据库，而在mac OS，用oracle官网的sql developer却连不上。    

最后发现是配置文件 tnsnames.ora和listener.ora的问题。oracle服务器若想对外提供服务，HOST值不能是“localhsot”或“127.0.0.1”，必须是计算机名才行。    

listener.ora修改部分的内容如下：
```
LISTENER =
  (DESCRIPTION_LIST =
    (DESCRIPTION =
      (ADDRESS = (PROTOCOL = IPC)(KEY = EXTPROC1521))
    )
    (DESCRIPTION =
      (ADDRESS = (PROTOCOL = TCP)(HOST = WIN-U2EAK9F3RV3 )(PORT = 1521))
    )
  )
```
tnsnames.ora修改部分的内容如下：
```
orcl =
  (DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = WIN-U2EAK9F3RV3 )(PORT = 1521))
    )
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = orcl)
    )
  )
```
这样，就大功告成了，mac OS也可以访问数据库了。