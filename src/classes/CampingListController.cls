public with sharing class CampingListController {
    @AuraEnabled
    public static List<Camping_Item__c> getItems(){
        List<Camping_Item__c> campingItems = [SELECT Name, Price__c, Quantity__c, Packed__c
                                              FROM Camping_Item__c
                                              LIMIT 10];
        System.debug(LoggingLevel.DEBUG, 'Queried a total of ' + campingItems.size());
        return campingItems;
    }

    @AuraEnabled
    public static Camping_Item__c saveItem(Camping_Item__c campingItem){
        System.debug('Upserting ' + campingItem);
        upsert campingItem;
        return campingItem;
    }
}