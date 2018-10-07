@isTest
global class ParkServiceMock implements WebServiceMock {
    public static final String[] GERMANY_RESULT = new String[] {'Hamburg Wadden Sea National Park', 'Hainich National Park', 'Bavarian Forest National Park'};

    global void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType) {
            // start - specify the response you want to send

            ParkService.byCountryResponse response_x = new ParkService.byCountryResponse();
            response_x.return_x = GERMANY_RESULT;
            // end
            response.put('response_x', response_x);
    }
}