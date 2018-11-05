@isTest
public class WarehouseSyncScheduleTest {
    @isTest
    public static void makeScheduleTest(){
        WarehouseCalloutServiceMock mock = new WarehouseCalloutServiceMock(WarehouseCalloutServiceMock.Types.STATIC_RESOURCE);
        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        String jobId = WarehouseSyncSchedule.schedule();
        Test.stopTest();

        Integer numScheduledJobs = [SELECT count()
                                    FROM CronTrigger
                                    WHERE Id = :jobId];
        System.assertEquals(1, numScheduledJobs, 'Expected to find one and only job with id ' + jobId);
    }

    @isTest
    public static void schduleStaticResourceTest(){
        WarehouseCalloutServiceMock mock = new WarehouseCalloutServiceMock(WarehouseCalloutServiceMock.Types.STATIC_RESOURCE);
        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        WarehouseSyncSchedule warehouseSchedule = new WarehouseSyncSchedule();
        warehouseSchedule.execute(null);
        Test.stopTest();

        Integer numEquipment = [SELECT count() FROM Product2];
        System.assertEquals(22, numEquipment);
    }
}
