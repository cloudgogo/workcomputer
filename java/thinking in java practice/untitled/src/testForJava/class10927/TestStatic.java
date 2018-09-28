package testForJava.class10927;

public class TestStatic {
    public static void main(String[] args) {
        System.out.println(StaticTest.i);
        StaticTest st2=new StaticTest();
            StaticTest st1=new StaticTest();

        System.out.println("before:"+st2.i);
            st1.i=2;
        System.out.println("after:"+st2.i);

    }
}
