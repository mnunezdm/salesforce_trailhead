public class Product2Helper {

    /**
     * @name COLLABORATION_GROUP
     * @description List of CollaborationGroup used in both business and test logic
    **/
    static List<CollaborationGroup> COLLABORATION_GROUP =
        [SELECT Id
        FROM CollaborationGroup
         WHERE Name = : Constants.INVENTORY_ANNOUNCEMENTS
         OR Name = :('TEST' + Constants.INVENTORY_ANNOUNCEMENTS)
         LIMIT 1];

    /**
     * @name afterUpdate
     * @description called by product2 Trigger on After Update
     * @param List<Product2> newList
     * @param List<Product2> oldList
    **/
    public static void AfterUpdate(List<Product2> newList, List<Product2> oldList){
        //ToDo: Declare a List of Product2 records named needsAnnouncement
        List<Product2> needsAnnouncement = new List<Product2>();

        Map<String, Inventory_Setting__mdt> limits = new Map<String, Inventory_Setting__mdt>();

        for(Inventory_Setting__mdt meta : [SELECT DeveloperName, Low_Quantity_Alert__c
                                           FROM Inventory_Setting__mdt]) {
            limits.put(meta.DeveloperName, meta);
        }

        for(Product2 product : newList) {
            if (product.Quantity_Remaining__c <= limits.get(product.Family).Low_Quantity_Alert__c) {
                needsAnnouncement.add(product);
            }
        }

        if (! needsAnnouncement.isEmpty()) {
            postAlerts(needsAnnouncement);
        //ToDo: Pass records to the postAlerts method
    }
    }

    /**
     * @name postAlerts
     * @description called by product2 Trigger on After Update
     * @param List<Product2> productList
    **/
    public static void PostAlerts(List<Product2> productList){
        List<ConnectApi.AnnouncementInput> toPost = new List<ConnectApi.AnnouncementInput>();
        for ( Product2 p : productList ){
            // ToDo: Construct a new AnnouncementInput for the Chatter Group so that it:
            // expires in a day
            // does not notify users via email.
            // and has a text body that includes the name of the product followed by the INVENTORY_LEVEL_LOW constant
        }
        // ToDo: Create and enqueue an instance of the announcementQueuable class with the list of Products
    }
}