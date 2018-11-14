@isTest
private class ProjectRESTServiceTest {
    private static final String OPP_STAGE = 'Qualification';
    private static final String PROJECT_STATUS = 'Running';

    @isTest
    public static void testCreationOk() {
        Opportunity opp = createOpportunity();
        insert opp;
        String projectRef = generateRandomName();

        Test.startTest();
        String result = ProjectRESTService.postProjectData(projectRef, generateRandomName(),
                                                           opp.Id, System.today().addDays(-10),
                                                           System.today().addDays(10),
                                                           1000, PROJECT_STATUS);
        Test.stopTest();

        System.assertEquals('OK', result, 'Invalid return value');


        List<Project__c> project = [SELECT Id
                                    FROM Project__c
                                    WHERE ProjectRef__c=:projectRef
                                    LIMIT 1];
        System.assertEquals(1, project.size(), 'Expected to find a project with ProjectRef=' + projectRef);

        Opportunity retrievedOpp = [SELECT Id, DeliveryInstallationStatus__c, (SELECT Id FROM Projects__r)
                                    FROM Opportunity
                                    WHERE Id=:opp.Id
                                    LIMIT 1];
        System.assertEquals(ProjectRESTService.IN_PROGESS, retrievedOpp.DeliveryInstallationStatus__c, 'Invalid Opportunity Status');
        System.assertEquals(1, retrievedOpp.Projects__r.size(), 'Expected to have one project associated to the opportunity');
    }


    @isTest
    public static void testInvalidId() {
        String projectRef = generateRandomName();

        Test.startTest();
        String result = ProjectRESTService.postProjectData(projectRef, generateRandomName(),
                                                           generateRandomName(), System.today().addDays(-10),
                                                           System.today().addDays(10),
                                                           1000, PROJECT_STATUS);
        Test.stopTest();

        System.assert(result.startsWith('Error'), 'Invalid return value');

        List<Project__c> project = [SELECT Id
                                    FROM Project__c
                                    WHERE ProjectRef__c=:projectRef
                                    LIMIT 1];
        System.assertEquals(0, project.size(), 'Expected to find a project with ProjectRef=' + projectRef);
    }

    @isTest
    public static void testRollbackInProjectCreation() {
        Opportunity opp = createOpportunity();
        insert opp;
        String projectRef = generateRandomName();

        Test.startTest();
        String result = ProjectRESTService.postProjectData(projectRef, generateRandomName(),
                                                           opp.Id, System.today().addDays(10),
                                                           System.today().addDays(-10),
                                                           1000, PROJECT_STATUS);
        Test.stopTest();

        System.assert(result.startsWith('Error'), 'Invalid return value');

        List<Project__c> project = [SELECT Id
                                    FROM Project__c
                                    WHERE ProjectRef__c=:projectRef
                                    LIMIT 1];
        System.assertEquals(0, project.size(), 'Expected to find a project with ProjectRef=' + projectRef);

        Opportunity retrievedOpp = [SELECT Id, DeliveryInstallationStatus__c, (SELECT Id FROM Projects__r)
                                    FROM Opportunity
                                    WHERE Id=:opp.Id
                                    LIMIT 1];
        System.assertNotEquals(ProjectRESTService.IN_PROGESS, retrievedOpp.DeliveryInstallationStatus__c, 'Invalid Opportunity Status');
        System.assertEquals(0, retrievedOpp.Projects__r.size(), 'Expected to have one project associated to the opportunity');
    }

    private static String generateRandomName() {
        return 'Test ' + Math.random();
    }

    private static Opportunity createOpportunity() {
        Account acc = new Account(Name=generateRandomName());
        insert acc;

        return new Opportunity(Name=generateRandomName(),
                               Account=acc,
                               StageName=OPP_STAGE,
                               CloseDate=System.today());
    }
}