public class ContactAndLeadSearch {
    public static List<List<SObject>> searchContactsAndLeads (String partialName) {
        return [FIND :partialName IN NAME FIELDS 
                RETURNING Account(Name), Lead(Name)];
    }
}