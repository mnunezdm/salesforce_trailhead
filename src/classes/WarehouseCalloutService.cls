public with sharing class WarehouseCalloutService {

    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';
    
    // complete this method to make the callout (using @future) to the
    // REST endpoint and update equipment on hand.
    // @future(callout=true)
    public static void runWarehouseEquipmentSync(){
        
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