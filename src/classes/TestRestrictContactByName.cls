@isTest
public class TestRestrictContactByName {

    @isTest
    static void TestCreateContactInvalidLastName () {
        Test.startTest();
        Database.SaveResult dsr = Database.insert(new Contact(LastName='INVALIDNAME'), false);
        System.assert(!dsr.isSuccess());
        Test.stopTest();
    }
    
    @isTest
    static void TestCreateContactValidLastName () {
        Test.startTest();
        Database.SaveResult dsr = Database.insert(new Contact(LastName='Nuñez'), false);
        System.assert(dsr.isSuccess());
        Test.stopTest();
    }
}