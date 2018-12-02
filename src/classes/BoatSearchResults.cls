public with sharing class BoatSearchResults {

    @AuraEnabled
    public static List<Boat__c> getBoats(String boatTypeId){
        if (boatTypeId.isWhitespace()) {
            return [SELECT Id, Name, Picture__c, Contact__r.Name, Geolocation__Latitude__s,
                       Geolocation__Longitude__s
                    FROM Boat__c
                    LIMIT 100];
        }
        return [SELECT Id, Name, Picture__c, Contact__r.Name, Geolocation__Latitude__s,
                       Geolocation__Longitude__s
                FROM Boat__c
                WHERE BoatType__c = :boatTypeId
                LIMIT 100];
    }
}
