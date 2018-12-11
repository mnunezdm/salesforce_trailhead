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
        pieData = new List<ChartHelper.ChartData>();

        orderRecord = (Order) standardController.getRecord();
        orderItemMap = new Map<id,OrderItem>();
        if (orderRecord.Id != null){
            orderRecord = queryOrderRecord(orderRecord.Id);
            for(OrderItem item : orderRecord.OrderItems) {
                orderItemMap.put(item.Product2Id, item);
            }
        }
        resetOrderItemList();
        repopulateChartData();
    }

    //ToDo: Implement your own method to populate orderItemList
    //  that you will call after pagination and/or family selection
    private void resetOrderItemList(){
        System.debug(LoggingLevel.DEBUG, 'Resetting order item list');
        if (selectedFamily != null && !selectedFamily.isWhitespace()) {
            System.debug(LoggingLevel.FINE, 'Filtering with family ' + selectedFamily);
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

        populateOrderItemList();
    }

    private void populateOrderItemList(){
        System.debug(LoggingLevel.DEBUG, 'Refreshing list of visible items');
        orderItemList.clear();
        for(PriceBookEntry pbe : (List<PricebookEntry>) standardSetController.getRecords()) {
            OrderItem edited = orderItemMap.get(pbe.Product2Id);

            Id editedId = edited != null? edited.Id : null;
            Decimal editedQuantity = edited != null? edited.Quantity : 0;
            Decimal editedPrice = edited != null? edited.UnitPrice : pbe.UnitPrice;

            orderItemList.add(new OrderItem(Id=editedId,
                                            OrderId=orderRecord.Id,
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
        System.debug(LoggingLevel.DEBUG, 'Detected change in a field');

        //ToDo: Implement logic to store the values changed on the page
        //      and populate pieData
        //      and populate total
        for(OrderItem item : orderItemList) {
            System.debug(LoggingLevel.FINE, 'Added ' + item.Product2.Name);
            orderItemMap.put(item.Product2Id, item);
        }

        repopulateChartData();
    }

    public void repopulateChartData(){
        System.debug(LoggingLevel.DEBUG, 'Repopulating chart data');
        pieData.clear();
        for (OrderItem oi : orderItemMap.values()) {
            if (oi.Quantity > 0) {
                pieData.add(new ChartHelper.ChartData(oi.Product2.Name,
                                                    oi.Quantity));
            }
        }
    }

    /**
     * @name SelectFamily
     * @description
    **/
    public void SelectFamily(){
        //ToDo: Implement logic to filter based on the selected product family
        System.debug(LoggingLevel.DEBUG, 'Selected family ' + selectedFamily);
        resetOrderItemList();
    }

    /**
     * @name Save
     * @description
    **/
    public void save(){
        System.debug(LoggingLevel.DEBUG, 'Saving Order and Order Items');
        //ToDo: Implement logic to save the Order and populated OrderItems
        SavePoint sp = Database.setSavePoint();
        try {
            if (orderRecord.Id == null) {
                System.debug(LoggingLevel.DEBUG, 'Inserting order');
                orderRecord.Pricebook2Id = (orderRecord.Pricebook2Id == null)?
                                            Constants.STANDARD_PRICEBOOK_ID :
                                            orderRecord.Pricebook2Id;
                insert orderRecord;
            } else {
                System.debug(LoggingLevel.DEBUG, 'Updating order');
                orderRecord.Pricebook2Id = (orderRecord.Pricebook2Id == null)?
                                            Constants.STANDARD_PRICEBOOK_ID :
                                            orderRecord.Pricebook2Id;
                update orderRecord;
            }

            List<OrderItem> itemsToAdd = new List<OrderItem>();
            List<OrderItem> itemsToUpdate = new List<OrderItem>();
            List<OrderItem> itemsToRemove = new List<OrderItem>();

            for (OrderItem item : orderItemMap.values()) {
                if (item.Id != null && item.Quantity == 0) {
                    System.debug(LoggingLevel.FINE, item.Product2.Name +
                                                    ' existed and new quantity is 0, removing');
                    System.debug(LoggingLevel.FINER, item);
                    itemsToRemove.add(item);
                } else if (item.Id != null) {
                    System.debug(LoggingLevel.FINE, item.Product2.Name +
                                                    ' existed and edited, updating');
                    System.debug(LoggingLevel.FINER, item);
                    itemsToUpdate.add(item);
                } else if (item.Quantity != 0) {
                    System.debug(LoggingLevel.FINE, item.Product2.Name +
                                                    ' not exists, creating');
                    item.OrderId = orderRecord.Id;
                    System.debug(LoggingLevel.FINER, item);
                    itemsToAdd.add(item);
                } else {
                    System.debug(LoggingLevel.FINER, item.Product2.Name + ' dismissed');
                }
            }
            System.debug(LoggingLevel.DEBUG, 'Adding ' + itemsToAdd.size() + ' items');
            insert itemsToAdd;

            System.debug(LoggingLevel.DEBUG, 'Updating ' + itemsToUpdate.size() + ' items');
            update itemsToUpdate;

            System.debug(LoggingLevel.DEBUG, 'Removing ' + itemsToRemove.size() + ' items');
            delete itemsToRemove;

            System.debug(LoggingLevel.DEBUG, 'All operations finished correctly');
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, 'Error saving, rolling back, ' + e);
            Database.rollback(sp);
        }
    }

    /**
     * @name First
     * @description
    **/
    public void First(){
        System.debug(LoggingLevel.FINE, 'Navigating to first position');
        standardSetController.first();
        populateOrderItemList();
    }

    /**
     * @name Next
     * @description
    **/
    public void Next(){
        System.debug(LoggingLevel.FINE, 'Navigating to next position');
        standardSetController.next();
        populateOrderItemList();
    }

    /**
     * @name Previous
     * @description
    **/
    public void Previous(){
        System.debug(LoggingLevel.FINE, 'Navigating to previous position');
        standardSetController.previous();
        populateOrderItemList();
    }

    /**
     * @name Last
     * @description
    **/
    public void Last(){
        System.debug(LoggingLevel.FINE, 'Navigating to last position');
        standardSetController.last();
        populateOrderItemList();
    }

    /**
     * @name getHasPrevious
     * @description
    **/
    public Boolean getHasPrevious(){
        Boolean hasPrevious = standardSetController.getHasPrevious();
        System.debug(LoggingLevel.FINE, 'Has Previous? ' + hasPrevious);
        return standardSetController.getHasPrevious();
    }

    /**
     * @name getHasNext
     * @description
    **/
    public Boolean getHasNext(){
        Boolean hasNext = standardSetController.getHasNext();
        System.debug(LoggingLevel.FINE, 'Has Next? ' + hasNext);
        return standardSetController.getHasNext();
    }

    /**
     * @name getTotalPages
     * @description
    **/
    public Integer getTotalPages(){
        Decimal numberOfRecords = standardSetController.getResultSize();
        Decimal numberOfPages = numberOfRecords / standardSetController.getPageSize();

        Integer numberOfPagesInt = numberOfPages.round(System.RoundingMode.UP).intValue();

        System.debug(LoggingLevel.FINER, 'Current total of pages is ' + numberOfPagesInt +
                                         ' with #records ' + numberOfRecords);
        return Math.ceil(numberOfPages).intValue();
    }

    /**
     * @name getPageNumber
     * @description
    **/
    public Integer getPageNumber(){
        Integer pageNumber = standardSetController.getPageNumber();
        System.debug(LoggingLevel.FINER, 'Current page number is ' + pageNumber);
        return pageNumber;
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