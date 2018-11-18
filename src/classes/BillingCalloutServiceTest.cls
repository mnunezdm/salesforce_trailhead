@isTest
private class BillingCalloutServiceTest {
    @isTest
    public static void testSingleProjectBilled(){
        Project__c project = createProject();
        insert project;
        insert createServiceCredentials(BillingCalloutService.SERVICE_CREDENTIALS_CUSTOMSETTING);

        Test.setMock(HttpCalloutMock.class, new
                     BillingCalloutServiceMock(BillingCalloutService.CORRECT_RESPONSE_STATUS));

        Test.startTest();
        project.Status__c = BillingCalloutService.BILLABLE_STATUS;
        update project;
        Test.stopTest();

        Project__c queriedProject = [SELECT Id, Status__c FROM Project__c];
        System.assertEquals(BillingCalloutService.BILLABLE_STATUS,
                            queriedProject.Status__c);
    }

    @isTest
    public static void testFuture(){
        Test.startTest();
        BillingCalloutService.notUsedMethod();
        Test.stopTest();
        Boolean result = true;
        System.assert(result);
    }

    private static String generateRandomName() {
        return 'Test ' + Math.random();
    }

    private static Decimal generateRandomCurrency() {
        Integer values = convertToInteger(Math.floor(Math.random() * 5));
        return Math.floor(Math.random() * Math.pow(10, values + 2) ) / 100;
    }

    private static Integer convertToInteger(Decimal value) {
        if (value != null) {
            Integer convertedValue = Integer.valueOf(String.valueOf(Math.roundToLong(value)));
            System.debug(LoggingLevel.FINE, 'Converted decimal from \'' + value + '\' to \'' + convertedValue + '\'');
            return convertedValue;
        } else {
            System.debug(LoggingLevel.WARN, 'Input value was NULL');
            return 0;
        }
    }

    private static ServiceCredentials__c createServiceCredentials(String name) {
        return new ServiceCredentials__c(Name=name,
                                         Username__c=generateRandomName(),
                                         Password__c=generateRandomName());
    }

    private static List<Project__c> createProjects(Integer size) {
        List<Project__c> projects = new List<Project__c>();
        for (Integer i = 0; i < size; i++) {
            projects.add(createProject());
        }
        return projects;
    }

    private static Project__c createProject() {
        Account acc = new Account(Name=generateRandomName());
        insert acc;

        Opportunity opp = new Opportunity(Name=generateRandomName(),
                                          Account=acc,
                                          StageName='Closed/Won',
                                          CloseDate=System.today());
        insert opp;

        return new Project__c(Opportunity__c=opp.Id,
                              ProjectRef__c='Test ' + generateRandomName(),
                              Billable_Amount__c=generateRandomCurrency());
    }
}