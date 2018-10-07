@isTest
public with sharing class AccountProcessorTest {
    @isTest
    public static void testUpdateAccounts() {
        Account acc = new Account(Name='Account AccountProcessor UpdateAccounts');
        insert acc;
        Contact cntct = new Contact(LastName='Contact AccountProcessor UpdateAccounts',
                                    AccountId=acc.id);
        insert cntct;

        Test.startTest();
        AccountProcessor.countContacts(new Set<Id> {acc.id});
        Test.stopTest();

        Account queried = [SELECT Id, Number_of_Contacts__c FROM Account WHERE Id = :acc.id LIMIT 1];
        System.assertEquals(1, queried.Number_of_Contacts__c);
    }
}