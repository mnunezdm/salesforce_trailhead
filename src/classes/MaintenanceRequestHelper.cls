public class MaintenanceRequestHelper {
    private static final String CASE_TYPE = 'Routine Maintenance';
    private static final String MANTAINANCE_STRING = 'Mantainance for ';

    public static void updateWorkOrders(Map<Id, Case> oldMap, Map<Id, Case> newMap){
        List<Id> justClosedCases = getClosedMantainanceIds(oldMap, newMap);

        if (!justClosedCases.isEmpty()) {
            processClosedMantainances(justClosedCases);
        }
    }

    /** Auxiliar methods **/

    private static List<Id> getClosedMantainanceIds(Map<Id, Case> oldMap, Map<Id, Case> newMap) {
        List<Id> justClosedCases = new List<Id>();
        System.debug(LoggingLevel.DEBUG, 'Getting just closed mantainance requests');
        for(Id caseId : newMap.keySet()){
            if (newMap.get(caseId).Status == 'Closed' && oldMap.get(caseId).Status != 'Closed'
                    && newMap.get(caseId).Type == CASE_TYPE) {
                justClosedCases.add(caseId);
            }
        }
        System.debug(LoggingLevel.DEBUG, 'Found ' + justClosedCases.size() + ' closed');
        return justClosedCases;
    }

    private static void processClosedMantainances(List<Id> justClosedCases) {
        List<Case> closedCases = [SELECT Id, CaseNumber, Vehicle__c, Equipment__c,
                                            Equipment__r.Name,
                                            Equipment__r.Maintenance_Cycle__c
                                    FROM Case
                                    WHERE Id IN :justClosedCases];
        List<Case> mantaineceRequests = new List<Case>();
        for (Case closedCase : closedCases) {
            mantaineceRequests.add(getMantainanceRequest(closedCase));
        }
        System.debug('Creating a total of ' + mantaineceRequests.size() + ' mantainance requests');
        System.debug(mantaineceRequests);
        insert mantaineceRequests;
    }

    private static Case getMantainanceRequest(Case closedCase) {
        Case mantainanceRequest = new Case();
        mantainanceRequest.Vehicle__c = closedCase.Vehicle__c;
        mantainanceRequest.Subject = MANTAINANCE_STRING + closedCase.Equipment__r.Name;
        mantainanceRequest.Type = CASE_TYPE;
        mantainanceRequest.Status = 'New';
        mantainanceRequest.Equipment__c=closedCase.Equipment__c;
        mantainanceRequest.Date_Due__c=System.today().addDays(closedCase.Equipment__r.Maintenance_Cycle__c.intValue());
        mantainanceRequest.Date_Reported__c=System.today();
        System.debug(LoggingLevel.FINE, 'Build Mantainance Request: ' + mantainanceRequest);
        return mantainanceRequest;
    }
}