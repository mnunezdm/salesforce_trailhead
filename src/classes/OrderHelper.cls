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

        //ToDo: Loop through a query of OrderItems related to the activatedOrderIds

            //ToDo: Populate the map with the Id of the related Product2 as the key and Product2 record as the value

        //ToDo: Loop through a query that aggregates the OrderItems related to the Products in the ProductMap keyset

        //ToDo: Perform an update on the records in the productMap
    }

}