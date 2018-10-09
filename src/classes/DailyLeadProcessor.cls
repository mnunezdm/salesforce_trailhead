global with sharing class DailyLeadProcessor implements Schedulable {
    @TestVisible private static final String LEAD_SOURCE = 'Dreamforce';

    global void execute(SchedulableContext ctx){
        List<Lead> leads = [SELECT Id FROM Lead
                            WHERE LeadSource = ''
                            LIMIT 200];
        for (Lead lea : leads) {
            lea.LeadSource = LEAD_SOURCE;
        }
        update leads;
    }
}