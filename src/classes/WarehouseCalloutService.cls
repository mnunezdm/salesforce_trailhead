public with sharing class WarehouseCalloutService {

    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';
    private static final String REQUEST_TYPE = 'GET';

    // complete this method to make the callout (using @future) to the
    // REST endpoint and update equipment on hand.
    // @future(callout=true)
    public static void runWarehouseEquipmentSync(){
        HttpRequest request = new HttpRequest();
	    request.setEndpoint(WAREHOUSE_URL);
        request.setMethod(REQUEST_TYPE);
        System.debug(LoggingLevel.DEBUG, 'Preparing ' + REQUEST_TYPE + ' to ' + WAREHOUSE_URL);

        Http session = new Http();
        HttpResponse response = session.send(request);
        String body = response.getBody();
        System.debug(LoggingLevel.DEBUG, 'Request Completed with ' + response.getStatus() + ' (' + response.getStatusCode() + ')');

        List<WarehouseEquipmentResponse> equipments = (List<WarehouseEquipmentResponse>) JSON.deserialize(body, List<WarehouseEquipmentResponse>.class);
        System.debug(LoggingLevel.DEBUG, 'Equipment retrieved (' + equipments.size() + ')');
        System.debug(LoggingLevel.FINE, equipments);

        List<Product2> products = new List<Product2>();
        for (WarehouseEquipmentResponse equipment : equipments) {
            products.add(new Product2(Name=equipment.name,
                                      Replacement_Part__c=true,
                                      Cost__c=1,
                                      Current_Inventory__c=equipment.quantity,
                                      Lifespan_Months__c=equipment.lifespan,
                                      Maintenance_Cycle__c=equipment.maintenanceperiod,
                                      Warehouse_SKU__c=equipment.sku));
        }
        System.debug(LoggingLevel.FINE, 'Data to upsert: ' + products);
        Database.UpsertResult[] results = Database.upsert(products, Product2.Warehouse_SKU__c);
        System.debug(LoggingLevel.DEBUG, 'Upsert done, GlobalResult=' + getGlobalResults(results));
        System.debug(LoggingLevel.FINE, 'Upsert Results: ' + results);
    }

    private static Boolean getGlobalResults(Database.UpsertResult[] results) {
        Integer successes = 0;
        for (Database.UpsertResult result : results) {
            if (result.isSuccess()) {
                successes += 1;
            } else {
                System.debug(LoggingLevel.ERROR, 'Error while upserting: ' + result.getErrors());
            }
        }
        return results.size() == successes;
    }

    private class WarehouseEquipmentResponse {
        String id;
        Boolean replacement;
        Integer quantity;
        String name;
        Integer maintenanceperiod;
        Integer lifespan;
        Integer cost;
        String sku;
    }
}