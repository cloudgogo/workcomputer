public class Revolution1 {
    public  int intvalue ;
    public  char  charvalue;
    public static void main(String[] args) {
        Revolution1 r=new Revolution1();
        System.out.println(r.printinformation());
    }
    public String printinformation(){
       String information= "int类型初始值"+ this.intvalue+",char类型初始值"+this.charvalue;
       return information;
    }
}