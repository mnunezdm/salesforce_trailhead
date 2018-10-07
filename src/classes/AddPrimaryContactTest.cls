@isTest
public class AddPrimaryContactTest {

    @isTest
    public static void testAddPrimaryContact(){
        List<Account> accounts = new List<Account>();
        for (Integer cont = 0; cont < 100; cont++) {
            accounts.add(new Account(Name='Account TestAddPrimaryContact ' + cont,
                                     BillingState=cont < 50? 'NY': 'CA'));
        }
        insert accounts;
        Contact cont = new Contact(LastName='TestContact');
        String state = 'CA';

        Test.startTest();
        AddPrimaryContact apc = new AddPrimaryContact(cont, state);
        System.enqueueJob(apc);
        Test.stopTest();

        List<Account> queriedAccounts = [SELECT Id, BillingState, (SELECT Id FROM Contacts)
                                         FROM Account LIMIT 200];

        for (Account acc : queriedAccounts) {
            if (acc.Contacts.size() != 0) {
                String message = 'Only Accounts with \"CA\" as state should have an associated contact';
                System.assertEquals('CA', acc.BillingState, message);
            }
        }
    }
}