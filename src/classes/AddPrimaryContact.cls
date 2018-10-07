public class AddPrimaryContact implements Queueable {
    private Contact cont;
    private String state;

    public AddPrimaryContact(Contact cont, String state) {
        this.cont = cont;
        this.state = state;
    }

    public void execute(QueueableContext context) {
        List<Contact> contactsToUpdate = new List<Contact>();
        for (Account acc : [SELECT Id FROM Account
                            WHERE BillingState = :this.state
                            LIMIT 200]) {
            Contact cont = this.cont.clone();
            cont.AccountId = acc.id;
            contactsToUpdate.add(cont);
        }
        insert contactsToUpdate;
    }
}