public class ProjectCalloutService {
    private static final String CALLOUT_SUCCESSFULL = 'Submitted Project';
    private static final String CALLOUT_UNSUCCESSFULL = 'Resubmit Project';

    private static final String TOKEN_CUSTOMSETTING_KEY = 'ProjectServiceToken';
    private static final String NAMEDCREDENTIAL_KEY = 'callout:ProjectService';

	@InvocableMethod
    public static void postOpportunityToPMS(List<Id> opportunityIds){
        // This method should only be call with a single opp id
        Http http = new Http();

        Opportunity opp = [SELECT Id, Name, Account.Name, CloseDate, Amount
                           FROM Opportunity
                           WHERE Id IN :opportunityIds
                           LIMIT 1];

        HttpRequest request = new HttpRequest();
        request.setEndpoint(NAMEDCREDENTIAL_KEY);
        request.setMethod('POST');
        request.setHeader('token', ServiceTokens__c.getValues(TOKEN_CUSTOMSETTING_KEY).Token__c);

        String body = JSON.serialize(new OpportunityProjectCalloutData(opp));
        request.setBody(body);

        System.debug('REQUEST BODY: ' + body);

        HTTPResponse response = http.send(request);

        if (response.getStatusCode() == 201) {
            System.debug('Callout was successfull');
            opp.StageName = CALLOUT_SUCCESSFULL;
        } else {
            System.debug('Callout did not went as expected');
            opp.StageName = CALLOUT_UNSUCCESSFULL;
        }
        update opp;
        System.debug('Opportunity updated with stage: ' + opp.StageName);
    }

    class OpportunityProjectCalloutData {
        Id opportunityId;
        String opportunityName;
        String accountName;
        String closeDate;
        Integer amount;

        OpportunityProjectCalloutData(Opportunity opp) {
            this.opportunityId = opp.Id;
            this.opportunityName = opp.Name;
            this.accountName = opp.Account.Name;
            this.closeDate = this.formatDate(opp.CloseDate);
            this.amount = this.convertToInteger(opp.Amount);
        }

        private String formatDate(Date d) {
            return d.year() + '-' + d.month() + '-' + d.day();
        }

        private Integer convertToInteger(Decimal value) {
            return Integer.valueOf(String.valueOf(Math.roundToLong(value)));
        }
    }
}