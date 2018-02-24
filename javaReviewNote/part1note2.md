> date: 2018/02/24   
> author: cloud

## java对象和类
我们都知道java是面向对象的语言,那么咋面向对象,面向对象咋的实现,那就要用到java中类和对象的概念了   
java面向对象的特性有以下这些
- 多态
- 继承
- 封装
- 抽象
- 类
- 对象
- 实例
- 方法
- 重载

首先,我们先对类和对象来做个了解,类就是对象抽象出来的特性集合.这么理解,对象就是具体的事物,for example,我们这里有一群女生,他们有高的,矮的,胖的,瘦的,但她们有一个特性,性别为女,那么他们都在女生这个类里,而他们各自就是一个不同的对象.    
网上copy了个图片,很不错    
![diffClassAndObject](img/2018/02/24/object-class.jpg)

大概就是这个意思了

#### java中的类
类就是对象的模板(话说没啥解释的,其实大家都懂,上例子得了)    
example:
```java
public class Dog{
  String breed;
  int age;
  String color;
  void barking(){
  }
 
  void hungry(){
  }
 
  void sleeping(){
  }
}
```
**类中包含的变量类型**

- 局部变量：在方法、构造方法或者语句块中定义的变量被称为局部变量。变量声明和初始化都是在方法中，方法结束后，变量就会自动销毁。
- 成员变量：成员变量是定义在类中，方法体之外的变量。这种变量在创建对象的时候实例化。成员变量可以被类中方法、构造方法和特定类的语句块访问。
- 类变量：类变量也声明在类中，方法体之外，但必须声明为static类型。

#### 构造方法
没啥好说的,就是用来实例化对象的,面向对象就是用类这个模子实例化对象来操作的,java中每个类都有构造方法,不写就是默认的构造方法,一般写了就是为了初始化些属性
example:
```java
public class Puppy{
    public Puppy(){
    }
 
    public Puppy(String name){
        // 这个构造器仅有一个参数：name
    }
}
```

### 创建对象
有了构造方法,那就开始造对象呗
**关键字**: new
```java
public class Puppy{
   public Puppy(String name){
      //这个构造器仅有一个参数：name
      System.out.println("小狗的名字是 : " + name ); 
   }
   public static void main(String []args){
      // 下面的语句将创建一个Puppy对象
      Puppy myPuppy = new Puppy( "tommy" );
   }
}
```
#### 访问实例变量和方法
通过已创建的对象来访问成员变量和成员方法，如下所示：    
```java
/* 实例化对象 */
ObjectReference = new Constructor();
/* 访问类中的变量 */
ObjectReference.variableName;
/* 访问类中的方法 */
ObjectReference.MethodName();
```

#### 实例
下面的例子展示如何访问实例变量和调用成员方法：
```java
public class Puppy{
   int puppyAge;
   public Puppy(String name){
      // 这个构造器仅有一个参数：name
      System.out.println("小狗的名字是 : " + name ); 
   }
 
   public void setAge( int age ){
       puppyAge = age;
   }
 
   public int getAge( ){
       System.out.println("小狗的年龄为 : " + puppyAge ); 
       return puppyAge;
   }
 
   public static void main(String []args){
      /* 创建对象 */
      Puppy myPuppy = new Puppy( "tommy" );
      /* 通过方法来设定age */
      myPuppy.setAge( 2 );
      /* 调用另一个方法获取age */
      myPuppy.getAge( );
      /*你也可以像下面这样访问成员变量 */
      System.out.println("变量值 : " + myPuppy.puppyAge ); 
   }
```
#### 源文件声明规则

在本节的最后部分，我们将学习源文件的声明规则。当在一个源文件中定义多个类，并且还有import语句和package语句时，要特别注意这些规则。
- 一个源文件中只能有一个public类
- 一个源文件可以有多个非public类
- 源文件的名称应该和public类的类名保持一致。例如：源文件中public类的类名是Employee，那么源文件应该命名为Employee.java。
- 如果一个类定义在某个包中，那么package语句应该在源文件的首行。
- 如果源文件包含import语句，那么应该放在package语句和类定义之间。如果没有package语句，那么import语句应该在源文件中最前面。
- import语句和package语句对源文件中定义的所有类都有效。在同一源文件中，不能给不同的类不同的包声明。
- 类有若干种访问级别，并且类也分不同的类型：抽象类和final类等。这些将在访问控制章节介绍。
- 除了上面提到的几种类型，Java还有一些特殊的类，如：内部类、匿名类。

#### java包
包主要用来对类和接口进行分类。当开发Java程序时，可能编写成百上千的类，因此很有必要对类和接口进行分类。   
#### Import语句   
在Java中，如果给出一个完整的限定名，包括包名、类名，那么Java编译器就可以很容易地定位到源代码或者类。Import语句就是用来提供一个合理的路径，使得编译器可以找到某个类。    
例如，下面的命令行将会命令编译器载入java_installation/java/io路径下的所有类    
```java
import java.io.*;
```
一个简单的例子    
在该例子中，我们创建两个类：Employee 和 EmployeeTest。    
首先打开文本编辑器，把下面的代码粘贴进去。注意将文件保存为 Employee.java。    
Employee类有四个成员变量：name、age、designation和salary。该类显式声明了一个构造方法，该方法只有一个参数。
Employee.java 文件代码：    
```java
import java.io.*;
 
public class Employee{
   String name;
   int age;
   String designation;
   double salary;
   // Employee 类的构造器
   public Employee(String name){
      this.name = name;
   }
   // 设置age的值
   public void empAge(int empAge){
      age =  empAge;
   }
   /* 设置designation的值*/
   public void empDesignation(String empDesig){
      designation = empDesig;
   }
   /* 设置salary的值*/
   public void empSalary(double empSalary){
      salary = empSalary;
   }
   /* 打印信息 */
   public void printEmployee(){
      System.out.println("名字:"+ name );
      System.out.println("年龄:" + age );
      System.out.println("职位:" + designation );
      System.out.println("薪水:" + salary);
   }
}
```  
程序都是从main方法开始执行。为了能运行这个程序，必须包含main方法并且创建一个实例对象。    
下面给出EmployeeTest类，该类实例化2个 Employee 类的实例，并调用方法设置变量的值。    
将下面的代码保存在 EmployeeTest.java文件中。    

EmployeeTest.java 文件代码：
```java
import java.io.*;
public class EmployeeTest{
 
   public static void main(String args[]){
      /* 使用构造器创建两个对象 */
      Employee empOne = new Employee("RUNOOB1");
      Employee empTwo = new Employee("RUNOOB2");
 
      // 调用这两个对象的成员方法
      empOne.empAge(26);
      empOne.empDesignation("高级程序员");
      empOne.empSalary(1000);
      empOne.printEmployee();
 
      empTwo.empAge(21);
      empTwo.empDesignation("菜鸟程序员");
      empTwo.empSalary(500);
      empTwo.printEmployee();
   }
}
```
#### note1
**成员变量和类变量的区别**
由static修饰的变量称为静态变量，其实质上就是一个全局变量。如果某个内容是被所有对象所共享，那么该内容就应该用静态修饰；没有被静态修饰的内容，其实是属于对象的特殊描述。    
不同的对象的实例变量将被分配不同的内存空间， 如果类中的成员变量有类变量，那么所有对象的这个类变量都分配给相同的一处内存，改变其中一个对象的这个类变量会影响其他对象的这个类变量，也就是说对象共享类变量。     
成员变量和类变量的区别：
   1. 两个变量的生命周期不同
      > 成员变量随着对象的创建而存在，随着对象的回收而释放。    
      > 静态变量随着类的加载而存在，随着类的消失而消失。
   2. 调用方式不同
      > 成员变量只能被对象调用。    
      > 静态变量可以被对象调用，还可以被类名调用。
   3. 别名不同
      > 成员变量也称为实例变量。    
      > 静态变量也称为类变量。
   4. 数据存储位置不同
      > 成员变量存储在堆内存的对象中，所以也叫对象的特有数据。    
      > 静态变量数据存储在方法区（共享数据区）的静态区，所以也叫对象的共享数据。    
 
static 关键字，是一个修饰符，用于修饰成员(成员变量和成员函数)。    
   **特点**：    
   1. 想要实现对象中的共性数据的对象共享。可以将这个数据进行静态修饰。
   2. 被静态修饰的成员，可以直接被类名所调用。也就是说，静态的成员多了一种调用方式。类名.静态方式。
   3. 静态随着类的加载而加载。而且优先于对象存在。
 
**弊端：**
   1. 有些数据是对象特有的数据，是不可以被静态修饰的。因为那样的话，特有数据会变成对象的共享数据。这样对事物的描述就出了问题。所以，在定义静态时，必须要明确，这个数据是否是被对象所共享的。
   2. 静态方法只能访问静态成员，不可以访问非静态成员。     
      因为静态方法加载时，优先于对象存在，所以没有办法访问对象中的成员。
   3. 静态方法中不能使用this，super关键字。     
      因为this代表对象，而静态在时，有可能没有对象，所以this无法使用。
 

什么时候定义静态成员呢？或者说：定义成员时，到底需不需要被静态修饰呢？    
成员分两种：    
   1. 成员变量。（数据共享时静态化）
      该成员变量的数据是否是所有对象都一样：     
      如果是，那么该变量需要被静态修饰，因为是共享的数据。      
      如果不是，那么就说这是对象的特有数据，要存储到对象中。     
   2. 成员函数。（方法中没有调用特有数据时就定义成静态）    
      如果判断成员函数是否需要被静态修饰呢？    
      只要参考，该函数内是否访问了对象中的特有数据：    
      如果有访问特有数据，那方法不能被静态修饰。     
      如果没有访问过特有数据，那么这个方法需要被静态修饰。     
**成员变量和静态变量的区别：**     
   1. 成员变量所属于对象。所以也称为实例变量。    
      静态变量所属于类。所以也称为类变量。
   2. 成员变量存在于堆内存中。    
      静态变量存在于方法区中。    
   3. 成员变量随着对象创建而存在。随着对象被回收而消失。    
      静态变量随着类的加载而存在。随着类的消失而消失。    
   4. 成员变量只能被对象所调用 。    
      静态变量可以被对象调用，也可以被类名调用。    
   所以，成员变量可以称为对象的特有数据，静态变量称为对象的共享数据。

#### note2
类变量类型：
1. 局部变量：在方法、构造方法、语句块中定义的变量。其声明和初始化在方法中实现，在方法结束后自动销毁
``` java
public class  ClassName{
    public void printNumber（）{
        int a;
    }
    // 其他代码
}
```
2. 成员变量：定义在类中，方法体之外。变量在创建对象时实例化。成员变量可被类中的方法、构造方法以及特定类的语句块访问。
```java
public class  ClassName{
    int a;
    public void printNumber（）{
        // 其他代码
    }
}
```

3. 类变量：定义在类中，方法体之外，但必须要有 static 来声明变量类型。静态成员属于整个类，可通过对象名或类名来调用。
```java
public class  ClassName{
    static int a;
    public void printNumber（）{
        // 其他代码
    }
}
```
#### note3
类的构造方法
1. 构造方法的名字和类名相同，并且没有返回值。
2. 构造方法主要用于为类的对象定义初始化状态。
3. 们不能直接调用构造方法，必须通过new关键字来自动调用，从而创建类的实例。
4. Java的类都要求有构造方法，如果没有定义构造方法，Java编译器会为我们提供一个缺省的构造方法，也就是不带参数的构造方法。
new关键字的作用
1. 为对象分配内存空间。
2. 引起对象构造方法的调用。
3. 为对象返回一个引用。


