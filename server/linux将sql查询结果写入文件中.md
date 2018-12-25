## shell脚本读取oracle数据库数据写入到文件中
1. linux 需要用 sqlplus 客户端去连接oracle 数据库，首先需要确认有没有安装：which sqlplus

2. 如果没有安装就需要先安装一下（百度）

3. 配置环境变量： 
```sh
vim /etc/profile
```
4. 执行 source /etc/profile

5. whereis oracle  #查看oracle 客户端安装路径

6. 进入客户端目录 

7. 编辑配置文件：vim tnsnames.ora
```tns
ORCL =
　　(DESCRIPTION =
　　　　(ADDRESS_LIST =
　　　　　　(ADDRESS = (PROTOCOL = TCP)(HOST = 127.0.0.1)(PORT = 1521))
　　　　)
　　(CONNECT_DATA =
　　　　(SERVICE_NAME = servicename)
　　)
)
```
8. 编辑保存完成以后，可以用命令行测试是否连接成功

9. sqlplus username/password@ORCL

10. 编写shell脚本（我查询的是表空间使用率，根据需求自行修改）
```sh
#! /bin/bash
sqlplus username/password@ORCL << EOF
set linesize 200
set pagesize 200
spool /home/tmp/zxh.log
select a.tablespace_name, total, free,(total-free) as usage from 
(select tablespace_name, sum(bytes)/1024/1024 as total from dba_data_files group by tablespace_name) a, 
(select tablespace_name, sum(bytes)/1024/1024 as free from dba_free_space group by tablespace_name) b
where a.tablespace_name = b.tablespace_name;
spool off
quit
EOF
```
 

> 遇到的问题：
```
1、INSERT -- W10: Warning: Changing a readonly file 
su root
password:《输入你的root密码》
然后就切换到你的root用户，就有权限修改一些readonly的文件了

2、source /home/oracle/.bash_profile  //环境变量生效
```