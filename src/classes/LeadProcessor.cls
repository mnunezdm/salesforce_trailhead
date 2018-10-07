global class LeadProcessor implements Database.Batchable<SObject> {
    @testVisible private final static String LEAD_SOURCE = 'Dreamforce';

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id FROM Lead');
    }
    global void execute(Database.BatchableContext bc, List<Lead> scope){
        // process each batch of records
        for (Lead lea : scope){
            lea.LeadSource = LEAD_SOURCE;
        }
        update scope;
    }
    global void finish(Database.BatchableContext bc){
        System.debug('Finished Batch');
    }
}