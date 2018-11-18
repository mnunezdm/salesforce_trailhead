public class BillingCalloutService {
    private final static String BILLABLE_STATUS = 'Billable';
    public static void callBillingService(Map<Id, Project__c> oldValues, Map<Id, Project__c> newValues) {
        System.debug(LoggingLevel.DEBUG, 'Detected a total of ' + newValues.size() + ' projects that have changed');
        List<Project__c> projectsBillable = new List<Project__c>();
        for (Id id : newValues.keySet()){
            Project__c newStatus = newValues.get(id);
            if ((oldValues.get(id) == null || oldValues.get(id).Status__c != BILLABLE_STATUS)
                    && newStatus.Status__c == BILLABLE_STATUS) {
                projectsBillable.add(newStatus);
            }
        }

        System.debug(LoggingLevel.DEBUG, 'Detected a total of ' + projectsBillable.size() + ' projects that match condition');
        for(List<Object> slicedProjects : sliceArray(projectsBillable, 100)) {

        }
    }

    /**
    * Slices passed array in arrays of n elements
    */
    public static List<List<Object>> sliceArray (List<Object> objects, Integer numberElements) {
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