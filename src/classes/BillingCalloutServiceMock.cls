public class BillingCalloutServiceMock implements HttpCalloutMock {
    private Integer statusCode;
    private String status;

    public BillingCalloutServiceMock(String correctStatus) {
        this.status = correctStatus;
        this.statusCode = 201;
    }

    public HttpResponse respond(HttpRequest request) {
        HttpResponse response = new HttpResponse();
        response.setStatus(this.status);
        response.setStatusCode(this.statusCode);
        return response;
    }
}