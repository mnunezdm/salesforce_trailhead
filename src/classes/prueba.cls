public class prueba {

    public static void test() {
        System.debug('Ei');
        List<String> ids = new List<String>();
       	String uniqueId = null;
        Account values1 = [SELECT Id, Name FROM Account WHERE Name = :uniqueId];
        List<Account> values2 = [SELECT Id, Name FROM Account WHERE Name IN :ids];
    }
}