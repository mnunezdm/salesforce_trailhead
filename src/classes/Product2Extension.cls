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

    public List<ChartHelper.ChartData> GetInventory(){
        return ChartHelper.GetInventory();
    }

    public PageReference Save(){
        SavePoint savepoint = Database.setSavePoint();
        try {
            List<Product2> products = new List<Product2>();
            List<PricebookEntry> pbes = new List<PricebookEntry>();

            for (ProductWrapper pw : productsToInsert) {
                products.add(pw.productRecord);
                pbes.add(pw.pricebookEntryRecord);
            }

            insert products;

            for (Integer cont = 0; cont < products.size(); cont++) {
                pbes[cont].Product2Id = products[cont].Id;
                pbes[cont].Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
            }

            insert pbes;

            //If successful clear the list and display an informational message
            apexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,
                                                       productsToInsert.size() + ' Inserted'));
            productsToInsert.clear();   //Do not remove
            addRows();  //Do not remove
        } catch (Exception e){
            apexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,
                                                       'Errors... ' + e));
            Database.rollback(savepoint);
        }
        return null;
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