@isTest
public with sharing class MaintenanceRequestHelperTest {

    @isTest
    public static void maintenanceClosedTest() {
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
    public static void noMaintenanceClosedTest() {
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
    public static void caseClosedTest() {
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

    @isTest
    public static void bulkMaintenanceClosedTest() {
        String randomString = String.valueOf(Math.random());
        Product2 equipment = new Product2(Maintenance_Cycle__c=1,
                                          Name=generateRandomTestName());
        insert equipment;

        Vehicle__c vehicle = new Vehicle__c(Name=generateRandomTestName());
        insert vehicle;

        List<Case> testCases = new List<Case>();
        for (Integer count = 0; count < 300; count++) {
            testCases.add(new Case(Equipment__c=equipment.id,
                                   Vehicle__c=vehicle.id,
                                   Type=MaintenanceRequestHelper.CASE_TYPE));
        }
        insert testCases;

        for (Case testCase : testCases) {
            testCase.Status = 'Closed';
        }

        Test.startTest();
        update testCases;
        Test.stopTest();

        List<Case> newMaintenanceRequests = [SELECT Id
                                             FROM Case
                                             WHERE Vehicle__c = :vehicle.Id
                                             AND Status = 'New'];

        System.assertEquals(300, newMaintenanceRequests.size(),
                            'Expected no new maintenance requests');
    }

    public static String generateRandomTestName() {
        String randomString = String.valueOf(Math.random());
        return 'Test Name ' + randomString;
    }
}
