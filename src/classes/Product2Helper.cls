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
        }
    }

    /**
     * @name postAlerts
     * @description called by product2 Trigger on After Update
     * @param List<Product2> productList
    **/
    public static void postAlerts(List<Product2> productList){
        List<ConnectApi.AnnouncementInput> toPost = new List<ConnectApi.AnnouncementInput>();
        for ( Product2 p : productList ){
            ConnectApi.AnnouncementInput ai = new ConnectApi.AnnouncementInput();
            ConnectApi.MessageBodyInput message = new ConnectApi.MessageBodyInput();
            ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();

            message.messageSegments = new List<ConnectApi.MessageSegmentInput>();
            textSegmentInput.text = p.Name + ' ' + Constants.INVENTORY_LEVEL_LOW;
            message.messageSegments.add(textSegmentInput);

            ai.body = message;
            ai.expirationDate = System.today().addDays(1);
            ai.sendEmails = false;
            toPost.add(ai);
        }

        AnnouncementQueueable q = new AnnouncementQueueable(toPost);
        System.enqueueJob(q);
    }
}