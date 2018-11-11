@isTest
private class ProjectCalloutServiceTest {
    @isTest
    public static void calloutServiceCorrect() {
        Opportunity opp = createOpportunity();
        createServiceToken();

        Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMock());

        Test.startTest();
        ProjectCalloutService.postOpportunityToPMS(new List<Id> {opp.Id});
        Test.stopTest();

        Integer jobCount = [SELECT COUNT() FROM AsyncApexJob];
        System.assertEquals(1, jobCount);

        List<Opportunity> retrievedOpportunity = [SELECT StageName
                                                  FROM Opportunity
                                                  WHERE Id = :opp.id];
        System.assertEquals(1, retrievedOpportunity.size());
        System.assertEquals(ProjectCalloutService.CALLOUT_SUCCESSFULL, retrievedOpportunity[0].StageName);
    }

    @isTest
    public static void calloutServiceError() {
        Opportunity opp = createOpportunity();
        createServiceToken();

        Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMockFailure());

        Test.startTest();
        ProjectCalloutService.postOpportunityToPMS(new List<Id> {opp.Id});
        Test.stopTest();

        Integer jobCount = [SELECT COUNT() FROM AsyncApexJob];
        System.assertEquals(1, jobCount);

        List<Opportunity> retrievedOpportunity = [SELECT StageName
                                                  FROM Opportunity
                                                  WHERE Id = :opp.id];
        System.assertEquals(1, retrievedOpportunity.size());
        System.assertEquals(ProjectCalloutService.CALLOUT_UNSUCCESSFULL, retrievedOpportunity[0].StageName);
    }

    @isTest
    public static void closeOpportunityTest() {
        Opportunity opp = createOpportunity();
        createServiceToken();

        Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMockFailure());

        Test.startTest();
        opp.StageName = 'Closed/Won';
        opp.Type = 'New Project';
        update opp;
        Test.stopTest();

        Integer jobCount = [SELECT COUNT() FROM AsyncApexJob];
        System.assertEquals(1, jobCount, 'Expected to find a queueable job');

        List<Opportunity> retrievedOpportunity = [SELECT StageName
                                                  FROM Opportunity
                                                  WHERE Id = :opp.id];
        System.assertEquals(1, retrievedOpportunity.size(), 'Expected get one&only opportunity');
        System.assertEquals(ProjectCalloutService.CALLOUT_UNSUCCESSFULL, retrievedOpportunity[0].StageName);
    }

    private static Opportunity createOpportunity(){
        Opportunity opp = new Opportunity(Name='Test Value',
                                          StageName='Closed/Won',
                                          CloseDate=System.today(),
                                          Amount=1000.00);
        insert opp;
        return opp;
    }

    private static void createServiceToken(){
        ServiceTokens__c serviceToken = new ServiceTokens__c(Name=ProjectCalloutService.TOKEN_CUSTOMSETTING_KEY,
                                                             Token__c='LALALALA');
        insert serviceToken;
    }
}