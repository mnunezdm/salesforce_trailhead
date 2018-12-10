@isTest
public class OrderTests {
    private static final Integer DATA_SIZE = 10;

    @TestSetup
    static void SetupTestData(){
        TestDataFactory.insertTestData(DATA_SIZE);
    }

    @isTest
    public static void OrderUpdate_UnitTest() {
        List<Order> orders = [SELECT Id
                              FROM Order
                              LIMIT :DATA_SIZE];
        for(Order ord : orders) {
            ord.Status = Constants.ACTIVATED_ORDER_STATUS;
        }
        Map<Id, Product2> preProducts = new Map<Id, Product2>([SELECT Id, Quantity_Ordered__c
                                                               FROM Product2
                                                               LIMIT :DATA_SIZE]);
        Test.startTest();
        update orders;
        Test.stopTest();

        for(Product2 product : [SELECT Id, Quantity_Ordered__c
                                FROM Product2
                                LIMIT :DATA_SIZE]) {
            TestDataFactory.verifyQuantityOrdered(preProducts.get(product.Id),
                                                  product,
                                                  Constants.DEFAULT_ROWS);
        }

    }
}