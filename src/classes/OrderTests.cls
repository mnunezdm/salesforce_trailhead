@isTest
public class OrderTests {
    private static final Integer DATA_SIZE = 10;

    @TestSetup
    static void SetupTestData(){
        TestDataFactory.insertTestData(DATA_SIZE);
    }

    @isTest
    public static void OrderExtension_UnitTest () {
        Order ord = [SELECT Id FROM Order LIMIT 1];

        PageReference pageRef = Page.OrderEdit;
        Test.setCurrentPage(pageRef);

        Test.startTest();
            ApexPages.StandardController sc = new ApexPages.StandardController(ord);
            OrderExtension ext = new OrderExtension(sc);

            ext.Next();
            ext.Previous();
            ext.Last();
            ext.First();
            ext.getHasNext();
            ext.getHasPrevious();
            ext.getPageNumber();
            ext.getTotalPages();
            ext.selectedFamily = Constants.PRODUCT_FAMILY.get(1).getValue();
            ext.SelectFamily();

            // delete one
            // ext.orderItemMap.values().get(0).Quantity = 0;

            // create one
            ext.OnFieldChange();
            ext.orderItemList.get(0).Quantity = 1;
            ext.OnFieldChange();

            ext.save();
        Test.stopTest();
    }

    @isTest
    public static void OrderExtension_DeleteTest () {
        Order ord = [SELECT Id FROM Order LIMIT 1];

        PageReference pageRef = Page.OrderEdit;
        Test.setCurrentPage(pageRef);

        Test.startTest();
            ApexPages.StandardController sc = new ApexPages.StandardController(ord);
            OrderExtension ext = new OrderExtension(sc);

            // delete one
            ext.orderItemMap.values().get(0).Quantity = 0;

            ext.save();
        Test.stopTest();
    }


    @isTest
    static void OrderExtension_getFamily() {
        Order ord = [SELECT Id FROM Order LIMIT 1];
        ApexPages.StandardController sc = new ApexPages.StandardController(ord);
        OrderExtension ext = new OrderExtension(sc);

        Test.startTest();
            List<SelectOption> familySelect = ext.getFamilyOptions();
        Test.stopTest();

        System.assertEquals(Constants.PRODUCT_FAMILY.size() + 1, familySelect.size());
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