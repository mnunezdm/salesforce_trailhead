@isTest
private class WarehouseCalloutServiceTest {
    @isTest
    private static void staticResourceDataTest(){
        WarehouseCalloutServiceMock mock = new WarehouseCalloutServiceMock(WarehouseCalloutServiceMock.Types.STATIC_RESOURCE);
        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        WarehouseCalloutService.runWarehouseEquipmentSync();
        Test.stopTest();

        Integer numEquipment = [SELECT count() FROM Product2];
        System.assertEquals(22, numEquipment);
    }

    @isTest
    private static void emptyResponseTest(){
        WarehouseCalloutServiceMock mock = new WarehouseCalloutServiceMock(WarehouseCalloutServiceMock.Types.EMPTY);
        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        WarehouseCalloutService.runWarehouseEquipmentSync();
        Test.stopTest();

        Integer numEquipment = [SELECT count() FROM Product2];
        System.assertEquals(0, numEquipment);
    }

    @isTest
    private static void nonJsonResponseTest(){
        WarehouseCalloutServiceMock mock = new WarehouseCalloutServiceMock(WarehouseCalloutServiceMock.Types.ERROR);
        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        WarehouseCalloutService.runWarehouseEquipmentSync();
        Test.stopTest();

        Integer numEquipment = [SELECT count() FROM Product2];
        System.assertEquals(0, numEquipment);
    }
}