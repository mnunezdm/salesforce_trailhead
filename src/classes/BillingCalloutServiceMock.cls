global class BillingCalloutServiceMock implements WebServiceMock {
    private Integer statusCode;
    private String status;

    global BillingCalloutServiceMock(String status) {
        this.status = status;
        this.statusCode = 201;
    }

    global void doInvoke(Object stub, Object request, Map<String, Object> response, String endpoint, String soapAction,
                         String requestName, String responseNS, String responseName, String responseType) {

        BillingServiceProxy.billProjectResponse_element response_x =
                new BillingServiceProxy.billProjectResponse_element();
        response_x.status = this.status;
        response.put('response_x', response_x);
    }
}