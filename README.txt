centos7 
环境为jdk8 + tomcat8 +oracle


账户    |密码
root    |123456
oracle  |oracle


使用前准备：
虚拟机使用桥接模式并勾选复制物理网络连接状态

需配置网络为静态ip（为oracle服务）
在外部的windows环境中找到当前所需要的ip地址，掩码及网关 使用 ipconfig

修改服务器中的网络设置 
cd /etc/sysconfig/network-script
vi ifcfg-ens33
修改对应的属性值
source 配置或reboot重启


需配置hosts信息（为oracle服务）
vi /etc/hosts 
修改 ***.***.***.* oracle 为 当前配置的静态ip的ip地址

启动数据库服务器
使用oracle用户登录
lsnrctl start 启动监听
lsnrctl status 查看监听
sqlplus "/as sysdba"
startup

ps -ef |grep ora_ 查看oracle进程

要kill 掉实例进程kill 有smon的那一个


启动应用服务器
使用root用户
cd web/apache-tomcat-9.0.11/bin 目录下
执行./startup.sh
可去logs目录中tail -f 查看catalina.out 输出的当前启动日志
可在http://ip地址:8080/webroot/decision进入finebi

