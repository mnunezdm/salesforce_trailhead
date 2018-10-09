@isTest
public class LeadProcessorTest {
    @isTest
    public static void updateLeadSource(){
        List<Lead> leads = new List<Lead>();
        for (Integer cont = 0; cont < 200; cont++){
            leads.add(new Lead(LastName='Lead UpdateLeadSource ' + cont,
                               Company='Company UpdateLeadSource ' + cont));
        }
        insert leads;
        Test.startTest();
        LeadProcessor leadProcessorInstance = new LeadProcessor();
        Database.executeBatch(leadProcessorInstance);
        Test.stopTest();
        List<Lead> queriedLeads = [SELECT Id, LeadSource FROM Lead];
        for (Lead lea : queriedLeads) {
            System.assertEquals(LeadProcessor.LEAD_SOURCE, lea.LeadSource);
        }
    }

}