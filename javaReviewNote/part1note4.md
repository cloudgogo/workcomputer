> date: 2018/02/27   
> author: cloud

## java变量类型
在java中,所有变量在使用前必须声明.声明变量的基本格式如下:    
```java
//格式说明: type 是java的数据类型.identifier是变量名,可以使用逗号隔开来声明多个变量
type identifier  [ = value][, identifier [= value] ...] ;
```
example:
```java
int a,b,c;//声明三个int型整数:a,b,c
int d=3,e=4,f=5;//声明三个整数并赋予初值
byte z=22; //声明并初始化z
String s="runoob";//声明并初始化字符串s
double pi =3.14159;//声明了双精度浮点型变量pi
char x='x'//声明变量x的值是字符'x'
```

java语言支持的变量类型有:
- 类变量: 独立于方法之外的变量,用static修饰.
- 实例变量: 独立于方法之外的变量,不过没有static修饰


