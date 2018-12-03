public without sharing class OrderHelper {
    /**
     * @name afterUpdate
     * @description
     * @param List<Order> newList
     * @param List<Order> oldList
     * @return void
    **/
    public static void afterUpdate(List<Order> newList, List<Order> oldList){
        Set<Id> orderIds = new Set<Id>();
        for (Integer i=0; i < newList.size(); i++ ){
            if (newList[i].Status == Constants.ACTIVATED_ORDER_STATUS){
                orderIds.add(newList[i].Id);
            }
        }
        if (! orderIds.isEmpty()) {
            rollUpOrderItems(orderIds);
        }
    }

    /**
     * @name rollUpOrderItems
     * @description Given a set of Activated Order ids, query the child Order Items and related Products to calculate Inventory levels
     * @param Set<Id> activatedOrderIds
     * @return void
    **/
    public static void rollUpOrderItems(Set<Id> activatedOrderIds){
        //ToDo: Declare a Map named "productMap" of Ids to Product2 records
        Map<Id, Product2> productMap = new Map<Id, Product2>();

        //ToDo: Loop through a query of OrderItems related to the activatedOrderIds
        for (OrderItem item : [SELECT Id, Product2Id, Product2.Quantity_Ordered__c, Quantity
                               FROM OrderItem
                               WHERE OrderId IN :activatedOrderIds]) {
            productMap.put(item.Product2Id, item.Product2);
        }
        //ToDo: Loop through a query that aggregates the OrderItems related to the Products in the ProductMap keyset
        for(AggregateResult quantitySum : [SELECT Product2Id, SUM(Quantity)
                                           FROM OrderItem
                                           WHERE Product2Id IN :productMap.keySet()
                                           GROUP BY Product2Id]) {
            Decimal quantity = (Decimal) quantitySum.get('expr0');
            Id productId = (Id) quantitySum.get('Product2Id');
            productMap.get(productId).Quantity_Ordered__c = quantity;
        }

        //ToDo: Perform an update on the records in the productMap
        update productMap.values();
    }
}