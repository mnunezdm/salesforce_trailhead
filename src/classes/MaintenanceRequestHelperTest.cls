@isTest
public with sharing class MaintenanceRequestHelperTest {

    @isTest
    public static void CheckMaintenanceClosedTest() {
        String randomString = String.valueOf(Math.random());
        Product2 equipment = new Product2(Maintenance_Cycle__c=1,
                                          Name=generateRandomTestName());
        insert equipment;

        Vehicle__c vehicle = new Vehicle__c(Name=generateRandomTestName());
        insert vehicle;

        Case testCase = new Case(Type=MaintenanceRequestHelper.CASE_TYPE,
                                 Equipment__c=equipment.id,
                                 Vehicle__c=vehicle.id);
        insert testCase;

        Test.startTest();
        testCase.Status = 'Closed';
        update testCase;
        Test.stopTest();

        List<Case> newMaintenanceRequests = [SELECT Id
                                             FROM Case
                                             WHERE Vehicle__c = :vehicle.Id
                                             AND Status = 'New'];

        System.assertEquals(1, newMaintenanceRequests.size(),
                            'Expected only one new maintenance requests with status new');
    }

    @isTest
    public static void CheckNoMaintenanceClosedTest() {
        String randomString = String.valueOf(Math.random());
        Product2 equipment = new Product2(Maintenance_Cycle__c=1,
                                          Name=generateRandomTestName());
        insert equipment;

        Vehicle__c vehicle = new Vehicle__c(Name=generateRandomTestName());
        insert vehicle;

        Case testCase = new Case(Type=MaintenanceRequestHelper.CASE_TYPE,
                                 Equipment__c=equipment.id,
                                 Vehicle__c=vehicle.id);

        Test.startTest();
        insert testCase;
        Test.stopTest();

        List<Case> newMaintenanceRequests = [SELECT Id
                                             FROM Case
                                             WHERE Vehicle__c = :vehicle.Id
                                             AND Status = 'New'
                                             AND Id != :testCase.Id];

        System.assertEquals(0, newMaintenanceRequests.size(),
                            'Expected no new maintenance requests');
    }

    @isTest
    public static void CheckCaseClosedTest() {
        String randomString = String.valueOf(Math.random());
        Product2 equipment = new Product2(Maintenance_Cycle__c=1,
                                          Name=generateRandomTestName());
        insert equipment;

        Vehicle__c vehicle = new Vehicle__c(Name=generateRandomTestName());
        insert vehicle;

        Case testCase = new Case(Equipment__c=equipment.id,
                                 Vehicle__c=vehicle.id);

        Test.startTest();
        insert testCase;
        Test.stopTest();

        List<Case> newMaintenanceRequests = [SELECT Id
                                             FROM Case
                                             WHERE Vehicle__c = :vehicle.Id
                                             AND Status = 'New'
                                             AND Id != :testCase.Id];

        System.assertEquals(0, newMaintenanceRequests.size(),
                            'Expected no new maintenance requests');
    }

    public static String generateRandomTestName() {
        String randomString = String.valueOf(Math.random());
        return 'Test Name ' + randomString;
    }
}
