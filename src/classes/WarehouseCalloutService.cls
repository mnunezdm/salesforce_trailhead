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
        
        Http session = new Http();
        HttpResponse response = session.send(request);
        String body = response.getBody();
        List<WarehouseEquipmentResponse> equipments = (List<WarehouseEquipmentResponse>) JSON.deserialize(body, List<WarehouseEquipmentResponse>.class);
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
        Database.UpsertResult[] results = Database.upsert(products, Product2.Warehouse_SKU__c);
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