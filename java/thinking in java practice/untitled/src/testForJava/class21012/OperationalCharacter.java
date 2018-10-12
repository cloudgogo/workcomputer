package testForJava.class21012;


import testForJava.Unit;

import java.util.Random;

public class OperationalCharacter {

    public static void main(String[] args) {
        OperationalCharacter operationalCharacter=new OperationalCharacter();
        operationalCharacter.test1();
        Unit.line("test2");
        operationalCharacter.test2();
        Unit.line();
        operationalCharacter.test3();
        Unit.line("random");
        operationalCharacter.randomtest();
        Unit.line("test3");
        operationalCharacter.calculator();



    }
    public  void test1(){
    int x=1,y=2,z=3;
    int a=x+y-2/2+z;
    int b=x+(y-2)/(2+z);
        System.out.println("a="+a+"b="+b);
    }

    /*
    对基本数据类型使用`=`进行赋值时，实际上是进行了复制，两个基本变量在内存中分配有两个地址，a=b，改变a并不会使b发生变化。
    而对于对象的赋值则不同，在代码中，某个对象c，其实指的是其的引用，当将c赋值给d时，复制的是引用，c与d的引用将同时指向同一对象。
     */

    class Tank{
        int level;
    }

    public void  test2(){
        Tank tank1=new Tank();
        Tank tank2=new Tank();
        tank1.level=9;
        tank2.level=12;
        Unit.print("t1.level:"+tank1.level);
        Unit.print("t2.level:"+tank2.level);
        tank1=tank2;
        Unit.print("t1.level:"+tank1.level);
        Unit.print("t2.level:"+tank2.level);
        tank1.level=32;
        Unit.print("t1.level:"+tank1.level);
        Unit.print("t2.level:"+tank2.level);


    }
    /*
    在将tank2的对象引用赋值给tank1时，tank1引用变为了tank2，原先new的对象引用现在无法被引用到，而没被引用到的对象则被java的垃圾回收器自动清理
     */

    //方法调用中的别名问题,（别名问题？？好像就是形参啊，不需要申明即可使用）
    class Lettle{
        char c;
    }
    static class PassObject{
        static  void f(Lettle l){
            l.c='z';
        }
    }
    public  void test3(){
        Lettle x=new Lettle();
        x.c='a';
        Unit.print("1:x.c="+x.c);
        PassObject.f(x);
        Unit.print("1:x.c="+x.c);
    }

    //算数操作符
    public void  calculator(){
        //create a seeded random number generater;
        /*
        种子数只是随机算法的起源数字，和生成的随机数字的区间无关。

        验证：相同种子数的Random对象，相同次数生成的随机数字是完全相同的。
         */
        Random rand =new Random(47);
        int i ,j ,k;
        //choose value from 1~100
        j=rand.nextInt(100)+1;
        Unit.print("j:"+j);
        k=rand.nextInt(100)+1;
        Unit.print("k:"+k);
        i=j+k;
        Unit.print("j+k="+i);
        i=j-k;
        Unit.print("j-k="+i);
        i=j*k;
        Unit.print("j*k="+i);
        i=j/k;
        Unit.print("j/k="+i);
        i=j%k;
        Unit.print("j%k="+i);
        j%=k;
        Unit.print("j%=k"+j);
        //Floating-point number tests
        float u,v,w;
        v=rand.nextFloat();
        Unit.print("v="+v);
        w=rand.nextFloat();
        Unit.print("w="+w);
        u=v+w;
        Unit.print("v+w"+u);
        u=v-w;
        Unit.print("v-w"+u);
        u=v*w;
        Unit.print("v*w"+u);
        u=v/w;
        Unit.print("v/w"+u);
        //the following also works for char,
        //byte,short,int,long,and double:
        u+=v;
        Unit.print("u+=v"+u);
        u-=v;
        Unit.print("u-=v"+u);
        u*=v;
        Unit.print("u*=v"+u);
        u/=v;
        Unit.print("u/=v"+u);





    }
    //random类验证,java中的随机其实是伪随机
    public void randomtest(){
        Random r1=new Random(100);
        Random r2=new Random(100);
        for (int i=1;i<=10;i++){
            Unit.print("r1的第"+i+"次结果"+r1.nextInt(100));
            Unit.print("r2的第"+i+"次结果"+r2.nextInt(100));
            Unit.print("r1的第"+i+"次结果D"+r1.nextDouble());
            Unit.print("r2的第"+i+"次结果D"+r2.nextDouble());
        }
    }

}
