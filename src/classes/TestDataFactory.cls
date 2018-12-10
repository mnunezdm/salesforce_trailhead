/**
 * @name TestDataFactory
 * @description Contains methods to construct and/or validate commonly used records
**/
public with sharing class TestDataFactory {

    /**
     * @name ConstructCollaborationGroup
     * @description
    **/
    public static CollaborationGroup constructCollaborationGroup() {
        //ToDo: Ensure this method returns a single Chatter CollaborationGroup
        //    whose Name starts with 'TEST' followed by the INVENTORY_ANNOUNCEMENTS constant
        //    and configured so anyone can join, see and post updates.
        String name = 'TEST' + Constants.INVENTORY_ANNOUNCEMENTS;
        CollaborationGroup collabGroup = new CollaborationGroup(Name=name,
                                                                CollaborationType='Public');
        return collabGroup;
    }

    /**
     * @name CreateProducts
     * @description Constructs a list of Product2 records for unit tests
    **/
    public static List<Product2> constructProducts(Integer cnt) {
        //ToDo: Ensure this method returns a list, of size cnt, of uniquely named Product2 records
        //  with all the required fields populated
        //  and IsActive = true
        //  an Initial Inventory set to 10
        //  and iterating through the product family picklist values throughout the list.
        List<Product2> products = new List<Product2>();
        for (; cnt > 0; cnt--) {
            Integer position = Math.mod(cnt, Constants.PRODUCT_FAMILY.size());
            String family = Constants.PRODUCT_FAMILY.get(position).getValue();
            products.add(new Product2(Name=generateRandomName(),
                                      Family=family,
                                      Initial_Inventory__c=10,
                                      IsActive=true));
        }
        return products;
    }

    /**
     * @name CreatePricebookEntries
     * @description Constructs a list of PricebookEntry records for unit tests
    **/
    public static List<PriceBookEntry> constructPricebookEntries(List<Product2> prods) {
        //ToDo: Ensure this method returns a corresponding list of PricebookEntries records
        //  related to the provided Products
        //  with all the required fields populated
        //  and IsActive = true
        //  and belonging to the standard Pricebook
        Id pricebookId = Constants.STANDARD_PRICEBOOK_ID;
        List<PricebookEntry> pbes = new List<PricebookEntry>();
        for (Product2 product : prods) {
            pbes.add(new PricebookEntry(Product2Id=product.Id,
                                        Pricebook2Id=pricebookId,
                                        UnitPrice=generateRandomInteger(10, 20),
                                        IsActive=true));
        }
        return pbes;
    }

    /**
     * @name CreateAccounts
     * @description Constructs a list of Account records for unit tests
    **/
    public static List<Account> constructAccounts(Integer cnt) {
        //ToDo: Ensure this method returns a list of size cnt of uniquely named Account records
        //  with all of the required fields populated.
        List<Account> accounts = new List<Account>();
        for (; cnt > 0; cnt--) {
            accounts.add(new Account(Name=generateRandomName()));
        }
        return accounts;
    }

    /**
     * @name CreateContacts
     * @description Constructs a list of Contacxt records for unit tests
    **/
    public static List<Contact> constructContacts(Integer cnt, List<Account> accts) {
        //ToDo: Ensure this method returns a list, of size cnt, of uniquely named Contact records
        //  related to the provided Accounts
        //  with all of the required fields populated.
        List<Contact> contacts = new List<Contact>();
        for(Integer i = 0; i < cnt; i++) {
            contacts.add(new Contact(LastName='Contact' + i,
                                  AccountId=accts.get(i).Id));
        }
        return contacts;
    }

    /**
     * @name CreateOrders
     * @description Constructs a list of Order records for unit tests
    **/
    public static List<Order> constructOrders(Integer cnt, List<Account> accts) {
        //ToDo: Ensure this method returns a list of size cnt of uniquely named Order records
        //  related to the provided Accounts
        //  with all of the required fields populated.
        Id pricebookId = Constants.STANDARD_PRICEBOOK_ID;
        List<Order> orders = new List<Order>();
        for (Integer i = 0; i < cnt; i++) {
            orders.add(new Order(Name='Order' + i,
                                 AccountId=accts.get(i).Id,
                                 EffectiveDate=Date.today(),
                                 Status=Constants.DRAFT_ORDER_STATUS,
                                 Pricebook2Id=priceBookId));
        }
        return orders;
    }

    /**
     * @name CreateOrderItems
     * @description Constructs a list of OrderItem records for unit tests
    **/
    public static List<OrderItem> constructOrderItems(integer cnt, list<pricebookentry> pbes, list<order> ords) {
        //ToDo: Ensure this method returns a list of size cnt of OrderItem records
        //  related to the provided Pricebook Entries
        //  and related to the provided Orders
        //  with all of the required fields populated.
        //  Hint: Use the DEFAULT_ROWS constant for Quantity as it will be used in the next challenge
        List<OrderItem> orderItems = new List<OrderItem>();
        for (Integer i = 0; i < cnt; i++) {
            orderItems.add(new OrderItem(OrderId=ords.get(i).Id,
                                         PricebookEntryId=pbes.get(i).Id,
                                         Quantity=Constants.DEFAULT_ROWS,
                                         UnitPrice=pbes.get(i).UnitPrice));
        }
        return orderItems;
    }

    /**
     * @name SetupTestData
     * @description Inserts accounts, contacts, Products, PricebookEntries, Orders, and OrderItems.
    **/
    public static void insertTestData(Integer cnt) {
        //ToDo: Ensure this method calls each of the construct methods
        //  and inserts the results for use as test data.
        List<Product2> products = constructProducts(cnt);
        insert products;

        List<PriceBookEntry> pbes = constructPricebookEntries(products);
        insert pbes;

        List<Account> accounts = constructAccounts(cnt);
        insert accounts;

        List<Contact> contacts = constructContacts(cnt, accounts);
        insert contacts;

        List<Order> orders = constructOrders(cnt, accounts);
        insert orders;

        List<OrderItem> orderItems = constructOrderItems(cnt, pbes, orders);
        insert orderItems;
    }

    private static String generateRandomName() {
        return 'Test ' + Math.random();
    }

    private static Integer generateRandomInteger(Integer fromValue, Integer toValue) {
        return fromValue + (Math.random() * toValue).intValue();
    }
}