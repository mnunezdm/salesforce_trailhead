/**
 * @name OrderExtension
 * @description This class is provided for you to facilitate the Super Badge
**/
public class OrderExtension {

    public Order orderRecord {get;set;}
    public List<OrderItem> orderItemList {get;set;}
    public String selectedFamily {get;set;}
    public List<chartHelper.chartData> pieData {get;set;}
    public Decimal total {get;set;}

    public Map<Id,OrderItem> orderItemMap;
    ApexPages.StandardSetController standardSetController;

    public OrderExtension(ApexPages.StandardController standardController){
        orderItemList = new List<OrderItem>();

        orderRecord = (Order) standardController.getRecord();
        orderItemMap = new Map<id,OrderItem>();
        if (orderRecord.Id != null){
            orderRecord = queryOrderRecord(orderRecord.Id);
        }
        populateOrderItemList();
    }

    //ToDo: Implement your own method to populate orderItemList
    //  that you will call after pagination and/or family selection
    private void populateOrderItemList(){
        if (selectedFamily != null && !selectedFamily.isWhitespace()) {
            standardSetController = new ApexPages.StandardSetController(
                [SELECT Id, Product2Id, Product2.Name, Product2.Family,
                        UnitPrice, Product2.Quantity_Remaining__c
                FROM PricebookEntry
                WHERE IsActive = true
                    AND Product2.Family = :selectedFamily]);
        } else {
            standardSetController = new ApexPages.StandardSetController(
                [SELECT Id, Product2Id, Product2.Name, Product2.Family,
                        UnitPrice, Product2.Quantity_Remaining__c
                FROM PricebookEntry
                WHERE IsActive = true]);
        }
        standardSetController.setPageSize(Constants.DEFAULT_ROWS);

        orderItemList.clear();
        for(PriceBookEntry pbe : (List<PricebookEntry>) standardSetController.getRecords()) {
            OrderItem edited = orderItemMap.get(pbe.Product2Id);
            Decimal editedQuantity = edited != null? edited.Quantity : 0;
            Decimal editedPrice = edited != null? edited.UnitPrice : pbe.UnitPrice;
            orderItemList.add(new OrderItem(OrderId=orderRecord.Id,
                                            Product2=pbe.Product2,
                                            Product2Id=pbe.Product2Id,
                                            PricebookEntryId=pbe.Id,
                                            PricebookEntry=pbe,
                                            Quantity=editedQuantity,
                                            UnitPrice=editedPrice));
        }
    }


    /**
     * @name OnFieldChange
     * @description
    **/
    public void OnFieldChange(){
        //ToDo: Implement logic to store the values changed on the page
        //      and populate pieData
        //      and populate total
        for(OrderItem item : orderItemList) {
            System.debug(LoggingLevel.FINE, 'Added ' + item.Product2.Name);
            orderItemMap.put(item.Product2Id, item);
        }
    }

    /**
     * @name SelectFamily
     * @description
    **/
    public void SelectFamily(){
        //ToDo: Implement logic to filter based on the selected product family
        populateOrderItemList();
    }

    /**
     * @name Save
     * @description
    **/
    public void Save(){
        //ToDo: Implement logic to save the Order and populated OrderItems

    }

    /**
     * @name First
     * @description
    **/
    public void First(){
        standardSetController.first();
        populateOrderItemList();
    }

    /**
     * @name Next
     * @description
    **/
    public void Next(){
        standardSetController.next();
        populateOrderItemList();
    }

    /**
     * @name Previous
     * @description
    **/
    public void Previous(){
        standardSetController.previous();
        populateOrderItemList();
    }

    /**
     * @name Last
     * @description
    **/
    public void Last(){
        standardSetController.last();
        populateOrderItemList();
    }

    /**
     * @name getHasPrevious
     * @description
    **/
    public Boolean getHasPrevious(){
        return standardSetController.getHasPrevious();
    }

    /**
     * @name getHasNext
     * @description
    **/
    public Boolean getHasNext(){
        return standardSetController.getHasNext();
    }

    /**
     * @name getTotalPages
     * @description
    **/
    public Integer getTotalPages(){
        Integer numberOfRecords = standardSetController.getResultSize();
        Decimal numberOfPages = numberOfRecords / standardSetController.getPageSize();
        return numberOfPages == 0? 1 : Math.ceil(numberOfPages).intValue();
    }

    /**
     * @name getPageNumber
     * @description
    **/
    public Integer getPageNumber(){
        return standardSetController.getPageNumber();
    }

    /**
     * @name GetFamilyOptions
     * @description
    **/
    public List<SelectOption> getFamilyOptions() {
        List<SelectOption> familyOptions = new List<SelectOption>();
        familyOptions.add(new SelectOption(Constants.SELECT_ONE, Constants.SELECT_ONE));
        for (Schema.PicklistEntry pe : Constants.PRODUCT_FAMILY) {
            familyOptions.add(new SelectOption(pe.getValue(), pe.getLabel()));
        }
        return familyOptions;
    }

    /**
     * @name QueryOrderRecord
     * @description
    **/
    public static Order QueryOrderRecord(Id orderId){
        return [SELECT Id, AccountId, EffectiveDate, Name, Status, Pricebook2Id,
                       (SELECT Id, OrderId, Quantity, UnitPrice, PricebookEntryId, Product2Id,
                               Product2.Name, Product2.Family, Product2.Quantity_Remaining__c
                        FROM OrderItems)
                FROM Order
                WHERE Id = :orderId
                LIMIT 1];
    }
}