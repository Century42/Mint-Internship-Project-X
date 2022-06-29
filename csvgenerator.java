public class csvgenerator{
  public static void main(String arg[]){
    String[] strings = {"Deaths", "Cases", "Treated"};

    for (int i = 0; i< 20; i++) {
        int elementValue = (int) (Math.random()*15);
        int randomIndex = (int) (Math.random()*3);
        
        System.out.println(strings[randomIndex] + "," + elementValue);
    }

  }
}