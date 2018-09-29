package testForJava.class10927;

import java.util.Date;

/**
 * a class commet
 */
public class Test1 {
    public static void main(String[] args) {
        System.out.println("现在的是");
        System.out.println(new Date());
        /*
        这是注释
         */
        System.getProperties().list(System.out);
        System.out.println(System.getProperty("user.name"));
        System.out.println(System.getProperty("user.home"));
        System.out.println(System.getProperty("java.library.path"));
    }
}