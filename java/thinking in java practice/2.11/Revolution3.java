public class Revolution3 {
    {
        Integer a = new Integer(1);
    } // end of scope
     public int b=a+1;
   /*  public String returns() {
         return s;
     }*/
    public static void main(String[] args) {
        Revolution3 r=new Revolution3();
        
        System.out.println(r.b);
    }
    //该段代码说明对象无法在作用域之外进行使用，
}