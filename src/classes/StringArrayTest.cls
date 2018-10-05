public class StringArrayTest {

    public static List<String> generateStringArray(Integer numberItems){
        List<String> returnList = new List<String>();
        Integer count = 0;
        while (count < numberItems) {
            returnList.add('Test ' + count++);
        }
        return returnList;
    }
}