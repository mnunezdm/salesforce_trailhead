@RestResource(urlMapping='/project/*')
global class ProjectRESTService {
    @TestVisible
    private static final String IN_PROGESS = 'In progress';

    @HttpPost
    global static String postProjectData(String projectRef, String projectName, String opportunityId,
                                         Date startDate, Date endDate, Double amount, String status) {
        System.debug(LoggingLevel.DEBUG, 'ProjectRESTService invoked for project with ref "' + projectRef + '"');
        System.debug(LoggingLevel.FINE, 'projectName: ' + projectName);
        System.debug(LoggingLevel.FINE, 'opportunityId: ' + opportunityId);
        System.debug(LoggingLevel.FINE, 'startDate: ' + startDate);
        System.debug(LoggingLevel.FINE, 'endDate: ' + endDate);
        System.debug(LoggingLevel.FINE, 'amount: ' + amount);
        System.debug(LoggingLevel.FINE, 'status: ' + status);

        Savepoint sp = Database.setSavepoint();

        try {
            Id opportunityIdAsId = opportunityId;
            Project__c proj = new Project__c(ProjectRef__c=projectRef,
                                             Name=projectName,
                                             Opportunity__c=opportunityIdAsId,
                                             Start_Date__c=startDate,
                                             End_Date__c=endDate,
                                             Billable_Amount__c=amount,
                                             Status__c=status);
            Database.UpsertResult upsResult = Database.upsert(proj, Project__c.ProjectRef__c);

            String operation = upsResult.isCreated()? 'was created' : 'was updated';
            System.debug(LoggingLevel.DEBUG, 'Project ' + operation + ' successfully with id=' + proj.Id);

            Opportunity opp = new Opportunity(Id=opportunityId,
                                              DeliveryInstallationStatus__c=IN_PROGESS);
            update opp;
            System.debug(LoggingLevel.DEBUG, 'Opportunity updated successfully with id=' + proj.Id);

            System.debug(LoggingLevel.DEBUG, 'Final result was OK');
            return 'OK';
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, 'Exception Catched with message: ' + e.getMessage());
            Database.rollback(sp);
            return 'Error';
        }
    }
}