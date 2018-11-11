public class ProjectCalloutService {
    private static final String CALLOUT_SUCCESSFULL = 'Submitted Project';
    private static final String CALLOUT_UNSUCCESSFULL = 'Resubmit Project';

    private static final String TOKEN_CUSTOMSETTING_KEY = 'ProjectServiceToken';
    private static final String NAMEDCREDENTIAL_KEY = 'callout:ProjectService';
    private static final String REQUEST_METHOD = 'POST';

	@InvocableMethod
    public static void postOpportunityToPMS(List<Id> opportunityIds){
        // This method should only be call with a single opp id
        Http http = new Http();

        Opportunity opp = [SELECT Id, Name, Account.Name, CloseDate, Amount
                           FROM Opportunity
                           WHERE Id IN :opportunityIds
                           LIMIT 1];
        System.debug(LoggingLevel.DEBUG, 'RETRIEVED OPPORTUNITY: ' + opp);

        HttpRequest request = new HttpRequest();
        request.setEndpoint(NAMEDCREDENTIAL_KEY);

        request.setMethod(REQUEST_METHOD);

        String token = ServiceTokens__c.getValues(TOKEN_CUSTOMSETTING_KEY).Token__c;
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setHeader('token', token);

        String body = JSON.serialize(new OpportunityProjectCalloutData(opp));
        request.setBody(body);

        System.debug(LoggingLevel.DEBUG, 'REQUEST: ' + request);
        System.debug(LoggingLevel.DEBUG, 'REQUEST HEADERS:');
        System.debug(LoggingLevel.DEBUG, '\t- Content-Type: application/json;charset=UTF-8');
        System.debug(LoggingLevel.DEBUG, '\t- token: ' + token);
        System.debug(LoggingLevel.DEBUG, 'REQUEST BODY: ' + body);

        HTTPResponse response = http.send(request);
        System.debug(LoggingLevel.DEBUG, 'RESPONSE: ' + response.getStatus() + ' [' + response.getStatusCode() + ']');

        if (response.getStatusCode() == 201) {
            System.debug(LoggingLevel.DEBUG, 'Callout was successfull');
            opp.StageName = CALLOUT_SUCCESSFULL;
        } else {
            System.debug(LoggingLevel.ERROR, 'Callout did not went as expected');
            opp.StageName = CALLOUT_UNSUCCESSFULL;
        }
        update opp;
        System.debug(LoggingLevel.DEBUG, 'Opportunity updated with stage: ' + opp.StageName);
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
            String formattedDate = d.year() + '-' + d.month() + '-' + d.day();
            System.debug(LoggingLevel.FINE, 'Formatted date from \'' + d + '\' to \'' + formattedDate + '\'');
            return formattedDate;
        }

        private Integer convertToInteger(Decimal value) {
            Integer convertedValue = Integer.valueOf(String.valueOf(Math.roundToLong(value)));
            System.debug(LoggingLevel.FINE, 'Converted decimal from \'' + value + '\' to \'' + convertedValue + '\'');
            return convertedValue;
        }
    }
}