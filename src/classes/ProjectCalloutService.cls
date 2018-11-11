public class ProjectCalloutService {
    private static final String CALLOUT_SUCCESSFULL = 'Submitted Project';
    private static final String CALLOUT_UNSUCCESSFULL = 'Resubmit Project';

    private static final String TOKEN_CUSTOMSETTING_KEY = 'ProjectServiceToken';
    private static final String NAMEDCREDENTIAL_KEY = 'callout:ProjectService';

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