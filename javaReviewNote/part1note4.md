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
- 局部变量: 类的方法中的变量.

example :
```java
public class Variable{
    static int allClicks=0;    // 类变量
 
    String str="hello world";  // 实例变量
 
    public void method(){
 
        int i =0;  // 局部变量
 
    }
}
```


#### Java 局部变量
- 局部变量声明在方法、构造方法或者语句块中；
- 局部变量在方法、构造方法、或者语句块被执行的时候创建，当它们执行完成后，变量将会被销毁；
- 访问修饰符不能用于局部变量；
- 局部变量只在声明它的方法、构造方法或者语句块中可见；
- 局部变量是在栈上分配的。
- 局部变量没有默认值，所以局部变量被声明后，必须经过初始化，才可以使用。    
   
**实例 1**      
在以下实例中age是一个局部变量。定义在pupAge()方法中，它的作用域就限制在这个方法中。
```java
package com.runoob.test;
 
public class Test{ 
   public void pupAge(){
      int age = 0;
      age = age + 7;
      System.out.println("小狗的年龄是: " + age);
   }
   
   public static void main(String args[]){
      Test test = new Test();
      test.pupAge();
   }
}
```
以上实例编译运行结果如下:
```
小狗的年龄是: 7
```
**实例 2**    
在下面的例子中 age 变量没有初始化，所以在编译时会出错：
```java
package com.runoob.test;
 
public class Test{ 
   public void pupAge(){
      int age;
      age = age + 7;
      System.out.println("小狗的年龄是 : " + age);
   }
   
   public static void main(String args[]){
      Test test = new Test();
      test.pupAge();
   }
}
```
以上实例编译运行结果如下:
```
Test.java:4:variable number might not have been initialized
age = age + 7;
         ^
1 error

```
#### 实例变量
- 实例变量声明在一个类中，但在方法、构造方法和语句块之外；
- 当一个对象被实例化之后，每个实例变量的值就跟着确定；
- 实例变量在对象创建的时候创建，在对象被销毁的时候销毁；
- 实例变量的值应该至少被一个方法、构造方法或者语句块引用，使得外部能够通过这些方式获取实- 例变量信息；
- 实例变量可以声明在使用前或者使用后；
- 访问修饰符可以修饰实例变量；
- 实例变量对于类中的方法、构造方法或者语句块是可见的。一般情况下应该把实例变量设为私有。- 通过使用访问修饰符可以使实例变量对子类可见；
- 实例变量具有默认值。数值型变量的默认值是0，布尔型变量的默认值是false，引用类型变量的默- 认值是null。变量的值可以在声明时指定，也可以在构造方法中指定；
- 实例变量可以直接通过变量名访问。但在静态方法以及其他类中，就应该使用完全限定名：- ObejectReference.VariableName。

example:
```java
import java.io.*;
public class Employee{
   // 这个实例变量对子类可见
   public String name;
   // 私有变量，仅在该类可见
   private double salary;
   //在构造器中对name赋值
   public Employee (String empName){
      name = empName;
   }
   //设定salary的值
   public void setSalary(double empSal){
      salary = empSal;
   }  
   // 打印信息
   public void printEmp(){
      System.out.println("名字 : " + name );
      System.out.println("薪水 : " + salary);
   }
 
   public static void main(String args[]){
      Employee empOne = new Employee("RUNOOB");
      empOne.setSalary(1000);
      empOne.printEmp();
   }
}
```