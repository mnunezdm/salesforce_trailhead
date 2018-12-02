public with sharing class BoatReviews {
    @AuraEnabled
    public static List<BoatReview__c> getAll(Id boatId){
        System.debug(LoggingLevel.DEBUG, 'Retrieving reviews for boat with Id ' + boatId);
        List<BoatReview__c> reviews = [SELECT Id, Name, Comment__c, Rating__c, LastModifiedDate, CreatedDate,
                                              CreatedBy.Name
                                       FROM BoatReview__c
                                       WHERE Boat__c = :boatId];
        System.debug(LoggingLevel.DEBUG, 'Returned a total of ' + reviews.size() + ' reviews');
        return reviews;
    }
}
