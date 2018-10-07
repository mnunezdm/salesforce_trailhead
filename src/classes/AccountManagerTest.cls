@isTest
global class AccountManagerTest {

    @isTest
    static void testGetAccountById(){
        Account accountInstance = new Account(Name='Account1 Test');
        insert accountInstance;
        insert new Contact(LastName='Contact1 Test', AccountId=accountInstance.id);
        insert new Contact(LastName='Contact2 Test', AccountId=accountInstance.id);

        RestRequest request = new RestRequest();
        request.requestUri = URL.getOrgDomainUrl().toExternalForm() + '/services/apexrest/Accounts/' + accountInstance.Id + '/contacts';
        request.httpMethod = 'GET';
        RestContext.request = request;
        Test.startTest();
        Account accountRest = AccountManager.getAccountContacts();
        Test.stopTest();
        System.assertEquals(accountInstance.id, accountRest.id);
    }
}