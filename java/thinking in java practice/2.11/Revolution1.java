public class Revolution1 {
    public  int intvalue ;
    public  char  charvalue;
    public static void main(String[] args) {
        Revolution1 r=new Revolution1();
        System.out.println(r.printinformation());
    }
    public String printinformation(){
       String information= "int���ͳ�ʼֵ"+ this.intvalue+",char���ͳ�ʼֵ"+this.charvalue;
       return information;
    }
}