@isTest
public class OrderTests {

    @isTest
    public static void orderSimpleTest() {
        Id standardPriceBookId = Test.getStandardPricebookId();
        Product2 prod = createProduct();
        PricebookEntry pbe = createPriceBookEntry(prod, standardPriceBookId);
        insert pbe;
        Order ord = createOrder(standardPriceBookId);
        insert ord;
        OrderItem oi = createOrderItem(ord, pbe);
        insert oi;

        Test.startTest();
        ord.Status = Constants.ACTIVATED_ORDER_STATUS;
        update ord;
        Test.stopTest();

        Product2 queriedProduct = [SELECT Quantity_Ordered__c
                                   FROM Product2
                                   WHERE Id = :prod.Id];
        System.assertEquals(oi.Quantity, queriedProduct.Quantity_Ordered__c);
    }

    @isTest
    public static void orderMultiItemsTest() {
        Id standardPriceBookId = Test.getStandardPricebookId();
        Product2 prod = createProduct();
        PricebookEntry pbe = createPriceBookEntry(prod, standardPriceBookId);
        insert pbe;
        Order ord = createOrder(standardPriceBookId);
        insert ord;
        OrderItem oi = createOrderItem(ord, pbe);
        insert oi;

        Test.startTest();
        ord.Status = Constants.ACTIVATED_ORDER_STATUS;
        update ord;
        Test.stopTest();

        Product2 queriedProduct = [SELECT Quantity_Ordered__c
                                   FROM Product2
                                   WHERE Id = :prod.Id];
        System.assertEquals(oi.Quantity, queriedProduct.Quantity_Ordered__c);
    }

    private static OrderItem createOrderItem(Order ord, PricebookEntry pbe) {
        OrderItem oi = new OrderItem(OrderId=ord.Id,
                                     PricebookEntryId=pbe.Id,
                                     Quantity=1,
                                     UnitPrice=pbe.UnitPrice);
        return oi;
    }

    private static Order createOrder(Id priceBookId) {
        Account acc = createAccount();
        insert acc;

        Order ord = new Order(AccountId=acc.Id,
                              EffectiveDate=Date.today(),
                              Status=Constants.DRAFT_ORDER_STATUS,
                              Pricebook2Id=priceBookId);

        return ord;
    }

    private static Account createAccount() {
        return new Account(Name=generateRandomName());
    }

    /**
     * Creates a list of pricebookentries from a list of non inserted products
     * passed as parameter, in the pricebook passed
     */
    private static List<PricebookEntry> createPriceBookEntries(List<Product2> products,
                                                               Id pricebookId){
        insert products;
        List<PricebookEntry> pbes = new List<PricebookEntry>();
        for (Product2 product : products) {
            pbes.add(createPriceBookEntry(product, pricebookId));
        }
        return pbes;
    }

    /**
     * Creates a pricebookentry for the (inserted/non-inserted) product passed
     * as parameter, in the pricebook passed
     */
    private static PricebookEntry createPriceBookEntry(Product2 product, Id pricebookId){
        if(product.Id == null) {
            insert product;
        }
        PricebookEntry pbe = new PricebookEntry(Product2Id=product.Id,
                                                Pricebook2Id=pricebookId,
                                                UnitPrice=generateRandomInteger(10, 20));
        System.debug(LoggingLevel.FINER, 'Creating PBE: ' + pbe);
        return pbe;
    }

    private static List<Product2> createProducts(Integer listSize) {
        List<Product2> products = new List<Product2>();
        for (; listSize > 0; listSize--) {
            products.add(createProduct());
        }
        return products;
    }

    private static Product2 createProduct() {
        Product2 product = new Product2(Name=generateRandomName(),
                                        Family=getRandomFamily(),
                                        Initial_Inventory__c=generateRandomInteger(5, 25));
        System.debug(LoggingLevel.FINER, product);
        return product;
    }

    private static String generateRandomName() {
        return 'Test ' + Math.random();
    }

    private static Integer generateRandomInteger(Integer fromValue, Integer toValue) {
        return fromValue + (Math.random() * toValue).intValue();
    }

    private static String getRandomFamily() {
        Integer position = generateRandomInteger(0, Constants.PRODUCT_FAMILY.size());
        String family = Constants.PRODUCT_FAMILY.get(position).getValue();
        System.debug(LoggingLevel.FINEST, 'Random value for family is ' + family);
        return family;
    }
}