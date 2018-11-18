public class BillingCalloutService {
    private final static String BILLABLE_STATUS = 'Billable';
    private final static String BILLED_STATUS = 'Billed';
    private final static String SERVICE_CREDENTIALS_CUSTOMSETTING = 'BillingServiceCredential';

    public static void callBillingService(Map<Id, Project__c> oldValues, Map<Id, Project__c> newValues) {
        System.debug(LoggingLevel.DEBUG, 'Detected a total of ' + newValues.size() + ' projects that have changed');
        List<Project__c> projectsBillable = new List<Project__c>();
        for (Id id : newValues.keySet()){
            Project__c newStatus = newValues.get(id);
            if ((oldValues.get(id) == null || oldValues.get(id).Status__c != BILLABLE_STATUS)
                    && newStatus.Status__c == BILLABLE_STATUS) {
                System.debug(LoggingLevel.FINE, 'Project \'' + newStatus.ProjectRef__c + '\' matchs precondition');
                projectsBillable.add(newStatus);
            }
        }

        System.debug(LoggingLevel.DEBUG, 'Detected a total of ' + projectsBillable.size() + ' projects that match condition');
        for(List<Object> slicedProjects : sliceArray(projectsBillable, 100)) {
            System.enqueueJob(new QueueableCalloutDispatcher(slicedProjects));
        }
    }

    @future(callout=true)
    public static void notUsedMethod(){}

    public class QueueableCalloutDispatcher implements Queueable, Database.AllowsCallouts {
        List<Object> projects;

        public QueueableCalloutDispatcher(List<Object> projects) {
            this.projects = projects;
        }

        public void execute(QueueableContext QC) {
            ServiceCredentials__c credentials = ServiceCredentials__c.getInstance(SERVICE_CREDENTIALS_CUSTOMSETTING);
            List<Project__c> billedProjects = new List<Project__c>();
            System.debug(LoggingLevel.DEBUG, 'Running sync process with a total of ' + projects.size() + ' projects');
            for (Object projectObject : projects) {
                Project__c project = (Project__c) projectObject;
                if (billProject(project, credentials)) {
                    System.debug(LoggingLevel.FINE, 'Project \'' + project.ProjectRef__c + '\' billed correctly');
                    billedProjects.add(new Project__c(Id=project.Id,
                                                      Status__c=BILLED_STATUS));
                } else {
                    System.debug(LoggingLevel.ERROR, 'Project \'' + project.ProjectRef__c + '\' finished with errors');
                }
            }
            if(!billedProjects.isEmpty()){
                System.debug(LoggingLevel.DEBUG, 'Preparing to update a total of ' + billedProjects.size() + ' projects to ' + BILLED_STATUS);
                update billedProjects;
                System.debug(LoggingLevel.DEBUG, 'All records were updated successfully');
            }
        }

        private Boolean billProject(Project__c project, ServiceCredentials__c credentials) {
            System.debug(LoggingLevel.DEBUG, 'Preparing async for ' + project.ProjectRef__c);
            BillingServiceProxy.project wsdlProject = createProject(project.ProjectRef__c, project.Billable_Amount__c,
                                                                    credentials.Username__c, credentials.Password__c);
            return 'OK' == new BillingServiceProxy.InvoicesPortSoap11().billProject(wsdlProject);
        }

        private BillingServiceProxy.project createProject(String projectRef, Decimal amount,
                                                          String username, String pasword) {
            BillingServiceProxy.project project = new BillingServiceProxy.project();
            project.projectid = projectRef;
            project.billAmount = amount;
            project.username = username;
            project.password = pasword;
            return project;
        }
    }

    /**
    * Slices passed array in arrays of n elements
    */
    public static List<List<Object>> sliceArray (List<Object> objects, Integer numberElements) {
        System.debug(LoggingLevel.FINE, 'Preparing to slice list of ' + objects.size() + ' in slices of ' +numberElements);
        List<List<Object>> result = new List<List<Object>>();
        List<Object> activeList;
        for (Integer counter = 0; counter < objects.size(); counter++) {
            if (Math.mod(counter, numberElements) == 0) {
                activeList = new List<Object>();
                result.add(activeList);
            }
            activeList.add(objects.get(counter));
        }
        return result;
    }
}