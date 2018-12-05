public class Product2Extension {

    public List<ProductWrapper> productsToInsert {get;set;}

    public Product2Extension(ApexPages.StandardController controller){
        productsToInsert = new List<ProductWrapper>();
        addRows();
    }

    public void AddRows(){
        for (Integer i=0; i < Constants.DEFAULT_ROWS; i++){
            productsToInsert.add(new ProductWrapper());
        }
    }

    public List<SelectOption> getFamilyOptions() {
        List<SelectOption> familyOptions = new List<SelectOption>();
        familyOptions.add(new SelectOption(Constants.SELECT_ONE, Constants.SELECT_ONE));
        for (Schema.PicklistEntry pe : Constants.PRODUCT_FAMILY) {
            familyOptions.add(new SelectOption(pe.getValue(), pe.getLabel()));
        }
        return familyOptions;
    }

    public List<ChartHelper.ChartData> GetInventory(){
        return ChartHelper.GetInventory();
    }

    public PageReference Save(){
        SavePoint savepoint = Database.setSavePoint();
        try {
            List<Product2> products = new List<Product2>();
            List<PricebookEntry> pbes = new List<PricebookEntry>();

            for (ProductWrapper pw : productsToInsert) {
                if(hasAllFieldsPopulated(pw.productRecord, pw.pricebookEntryRecord)) {
                    products.add(pw.productRecord);
                    pbes.add(pw.pricebookEntryRecord);
                }
            }

            insert products;

            for (Integer cont = 0; cont < products.size(); cont++) {
                pbes[cont].Product2Id = products[cont].Id;
                pbes[cont].Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
            }

            insert pbes;

            //If successful clear the list and display an informational message
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,
                                                       productsToInsert.size() + ' Inserted'));
            productsToInsert.clear();   //Do not remove
            addRows();  //Do not remove
        } catch (Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,
                                                       Constants.ERROR_MESSAGE));
            Database.rollback(savepoint);
        }
        return null;
    }

    private static Boolean hasAllFieldsPopulated(Product2 product, PricebookEntry pbe) {
        return product.Name != null && !product.Name.isWhitespace()
                && product.Family != Constants.SELECT_ONE
                && pbe.UnitPrice != null && pbe.UnitPrice != 0
                && product.Initial_Inventory__c != null && product.Initial_Inventory__c != 0;
    }

    public class ProductWrapper {
        public Product2 productRecord {get; set;}
        public PricebookEntry pricebookEntryRecord {get; set;}

        public ProductWrapper() {
            this.productRecord = new Product2();
            this.pricebookEntryRecord = new PricebookEntry();
        }
    }
}