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
