@isTest
public with sharing class DailyLeadProcessorTest {
    private static final String CRON_EXP = '0 0 0 15 3 ? 2022';
    @isTest
    public static void testDailyLeadProcessor() {
        List<Lead> leads = new List<Lead>();
        for (Integer cont = 0; cont < 200; cont++) {
            leads.add(new Lead(LastName='Lead Test ' + cont,
                               Company='Company Test ' + cont));
        }
        insert leads;
        Test.startTest();
        System.schedule('Job Test1', CRON_EXP, new DailyLeadProcessor());
        Test.stopTest();
        for (Lead lea : [SELECT LeadSource FROM Lead LIMIT 200]){
            System.assertEquals(DailyLeadProcessor.LEAD_SOURCE, lea.LeadSource);
        }
    }
}