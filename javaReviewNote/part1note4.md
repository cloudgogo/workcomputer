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
      Employee empOne = new Employee("AllenCharles");
      empOne.setSalary(1000);
      empOne.printEmp();
   }
}
```
结果
```
Administrator@PC-ThinkPadT430 MINGW64 ~/Desktop/git/javaReviewNote/code (master)
$ java Employee
名字 : AllenCharles
薪水 : 1000.0
```

#### 类变量(静态变量)
- 类变量也称为静态变量，在类中以static关键字声明，但必须在方法构造方法和语句块之外。
- 无论一个类创建了多少个对象，类只拥有类变量的一份拷贝。
- 静态变量除了被声明为常量外很少使用。常量是指声明为public/private，final和static类型的变量。常量初始化后不可改变。
- 静态变量储存在静态存储区。经常被声明为常量，很少单独使用static声明变量。
- 静态变量在程序开始时创建，在程序结束时销毁。
- 与实例变量具有相似的可见性。但为了对类的使用者可见，大多数静态变量声明为public类型。
- 默认值和实例变量相似。数值型变量默认值是0，布尔型默认值是false，引用类型默认值是null。变量的值可以在声明的时候指定，也可以在构造方法中指定。此外，静态变量还可以在静态语句块中初始化。
- 静态变量可以通过：ClassName.VariableName的方式访问。
- 类变量被声明为public static final类型时，类变量名称一般建议使用大写字母。如果静态变量不是public和final类型，其命名方式与实例变量以及局部变量的命名方式一致。
实例：
```java
public class EmployeeSalary{
    //DEPARTMENT是个常亮
    public static final String DEPARTMENT="开发人员";
    //avgsalary是静态的私有变量
    //初始化在定义的时候就得进行,否则变量将使用默认值(自动初始化,局部变量定义完需要手动初始化)
    private static double avgSalary=10000; 
    //salary是实例变量
    private double salary;
    
    public static void main(String[] args) {
        //类变量不需要依托于对象即可操作
        avgSalary=8000;
        //可以使用类名.变量名调用类变量
        EmployeeSalary.avgSalary=6000;
        //实例变量需要依托于对象进行操作
        EmployeeSalary employeeSalary=new EmployeeSalary();
        employeeSalary.salary = 6000;

        System.out.println(DEPARTMENT+"工资:"+employeeSalary.salary+" 平均工资:"+avgSalary);
    }
}

```


#### note1  
**Java 中静态变量和实例变量区别**
- 静态变量属于类，该类不生产对象，通过类名就可以调用静态变量。
- 实例变量属于该类的对象，必须产生该类对象，才能调用实例变量。    

在程序运行时的区别：
- 实例变量属于某个对象的属性，必须创建了实例对象，其中的实例变量才会被分配空间，才能使用这个实例变量。
- 静态变量不属于某个实例对象，而是属于类，所以也称为类变量，只要程序加载了类的字节码，不用创建任何实例对象，静态变量就会被分配空间，静态变量就可以被使用了。    
总之，实例变量必须创建对象后才可以通过这个对象来使用，静态变量则可以直接使用类名来引用。    

例如，对于下面的程序，无论创建多少个实例对象，永远都只分配了一个 staticInt 变量，并且每创建一个实例对象，这个 staticInt 就会加 1；但是，每创建一个实例对象，就会分配一个 random，即可能分配多个 random ，并且每个 random 的值都只自加了1次。
```java
public class StaticTest {
    private static int staticInt = 2;
    private int random = 2;

    public StaticTest() {
        staticInt++;
        random++;
        System.out.println("staticInt = "+staticInt+"  random = "+random);
    }

    public static void main(String[] args) {
        StaticTest test = new StaticTest();
        StaticTest test2 = new StaticTest();
    }
}
```
执行以上程序，输出结果为：
```
staticInt = 3  random = 3
staticInt = 4  random = 3
```


#### note2
**类变量赋值方法**

- 无final修饰，声明时赋值，构造器中赋值，静态语句块或静态方法赋值
- 有final修饰，声明时赋值，声明与赋值分开可在静态语句块中赋值
```java
public class StaticTest {
    private static int staticInt = 2;
    private int random = 2;

    public StaticTest() {
        staticInt++;
        random++;
    }

    public static void main(String[] args) {
        System.out.println("类变量与对象变量的值变化");
        StaticTest test = new StaticTest();
        System.out.println("  实例1：staticInt:" + test.staticInt + "----random:" + test.random);
        StaticTest test2 = new StaticTest();
        System.out.println("  实例2：staticInt:" + test.staticInt + "----random:" + test.random);
        System.out.println("静态变量赋值");
        System.out.println("  静态语句块起作用:" + A.staticA);
        A a = new A();
        System.out.println("  构造器起作用:" + a.staticA);
        a.toChange();
        System.out.println("  静态方法1起作用:" + A.staticA);
        a.toChange2();
        System.out.println("  静态方法2起作用:" + A.staticA);
        System.out.println("常量赋值");
        System.out.println("  静态语句赋值:" + B.staticB);
    }
}

class A { 
    public static  String  staticA ="A" ;  
    //静态语句块修改值 
    static{  staticA ="A1"; } 
    //构造器修改值
    public A (){  staticA ="A2"; } 
    //静态方法起作用 
    
    public static void toChange(){  staticA ="A3"; } 
    public static void toChange2(){  staticA ="A4"; }  
}

class B { 
    public static final String  staticB ;  // 声明与赋值分离 
    static{  staticB ="B"; }
}
```


