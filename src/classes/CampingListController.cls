public with sharing class CampingListController {
    @AuraEnabled
    public static List<Camping_Item__c> getItems(){
        return [SELECT Name, Price__c, Quantity__c, Packed__c
                FROM Camping_Item__c
                LIMIT 10];
    }
}
