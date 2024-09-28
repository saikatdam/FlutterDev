public class test{
   
    private static String xor(String devis,String devid){
        String result = "";
        for(int i = 1; i < devid.length() ; i++){
        if(devis.charAt(i) == devid.charAt(i)){
            result += "0";
        }else{
            result += "1";
        }
        
    }
    return result;
   
}
    private static String devide(String devid,String devis){
        int peak = devis.length();
        String temp = devid.substring(0,peak);
        int d_length = devid.length();
        while (peak<d_length) {
            if(temp.charAt(0)=='1'){
                temp = xor(devis,temp) + devid.charAt(peak);

            }else{
                temp = xor("0".repeat(peak),temp) + devid.charAt(peak);
            }
            peak += 1;
            
        }

        if(temp.charAt(0)=='1'){
            temp = xor(devis,temp);

        }else{
            temp = xor("0".repeat(peak),temp);
        }
        return temp;
    }

    private static String calculateCrc(String num1,String num2){
        int devisor_length = num2.length();
        String temp = num1 + "0".repeat(devisor_length-1);
        String reminder = devide(temp,num2);
        return reminder;
        
    }
public static void main(String args[]){
    String dividend = "101010101";
    String devisor = "101";
   String result = calculateCrc(dividend,devisor);
   String add = dividend + result;
   String errorOrNot = devide(add,devisor);
   if(Integer.parseInt(errorOrNot)==0){
    System.out.println("No error Occured");
   }else{
    System.out.println("Error Occured");
   }
}
}