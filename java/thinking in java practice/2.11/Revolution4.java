public class Revolution4 {
    public static void main(String[] args) {
        //int x=3; //变量的声明在作用域之外且在作用域之前会编译报错，java虚拟机不允许变量混乱的情况
        {
            int x=1;
            System.out.println("inner x is "+x);
        }
        System.out.println("-----");
        int x=2;  // 变量在作用域使用完成后，将会被销毁，故可以重新定义
        System.out.println("outer x is "+x);
        syso();
    }
    public static final int  NUMBER1=1;
    public static void syso(){
         int NUMBER1=2;
         System.out.println(NUMBER1);
         System.out.println(Revolution4.NUMBER1);
         //注意,在静态方法中不能出现this关键字 

    }

}