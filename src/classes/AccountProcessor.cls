public with sharing class AccountProcessor {

    @future
    public static void countContacts(Set<Id> accountIds) {
        List<Account> accounts = [SELECT Id, (SELECT Id FROM Contacts) FROM Account WHERE Id in :accountIds];
        for (Account acc : accounts) {
            acc.Number_of_Contacts__c = acc.Contacts.size();
        }
        update accounts;
    }
}