@isTest
private class Product2Tests {
    private static final Integer POPULATED_VALUES = 5;

    /**
     * @name product2Extension_UnitTest
     * @description UnitTest for product2Extension
    **/
    @isTest
    static void Product2Extension_UnitTest(){
        List<Product2> products = TestDataFactory.constructProducts(POPULATED_VALUES);
        List<PricebookEntry> pbe = TestDataFactory.constructPricebookEntries(products);

        ApexPages.StandardController sc = new ApexPages.StandardController(new Product2());
        Product2Extension ext = new Product2Extension(sc);
        PageReference pageRef = Page.Product2New;
        Test.setCurrentPage(pageRef);

        Test.startTest();
            System.assertEquals(Constants.DEFAULT_ROWS, ext.productsToInsert.size());
            ext.addRows();
            System.assertEquals(Constants.DEFAULT_ROWS * 2, ext.productsToInsert.size());
            for (Integer i = 0; i < POPULATED_VALUES; i++) {
                Product2Extension.ProductWrapper pw = ext.productsToInsert.get(i);
                pw.pricebookEntryRecord = pbe.get(i);
                pw.productRecord = products.get(i);
            }
            ext.save();
        Test.stopTest();

        System.assertEquals(POPULATED_VALUES, [SELECT COUNT() FROM Product2]);
        System.assertEquals(POPULATED_VALUES, [SELECT COUNT() FROM PricebookEntry]);
    }

}