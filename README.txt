centos7 
����Ϊjdk8 + tomcat8 +oracle


�˻�    |����
root    |123456
oracle  |oracle


ʹ��ǰ׼����
�����ʹ���Ž�ģʽ����ѡ����������������״̬

����������Ϊ��̬ip��Ϊoracle����
���ⲿ��windows�������ҵ���ǰ����Ҫ��ip��ַ�����뼰���� ʹ�� ipconfig

�޸ķ������е��������� 
cd /etc/sysconfig/network-script
vi ifcfg-ens33
�޸Ķ�Ӧ������ֵ
source ���û�reboot����


������hosts��Ϣ��Ϊoracle����
vi /etc/hosts 
�޸� ***.***.***.* oracle Ϊ ��ǰ���õľ�̬ip��ip��ַ

�������ݿ������
ʹ��oracle�û���¼
lsnrctl start ��������
lsnrctl status �鿴����
sqlplus "/as sysdba"
startup

ps -ef |grep ora_ �鿴oracle����

Ҫkill ��ʵ������kill ��smon����һ��


����Ӧ�÷�����
ʹ��root�û�
cd web/apache-tomcat-9.0.11/bin Ŀ¼��
ִ��./startup.sh
��ȥlogsĿ¼��tail -f �鿴catalina.out ����ĵ�ǰ������־
����http://ip��ַ:8080/webroot/decision����finebi

