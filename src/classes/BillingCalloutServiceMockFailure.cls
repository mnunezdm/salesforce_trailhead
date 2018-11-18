public class BillingCalloutServiceMockFailure implements HttpCalloutMock {
    private Integer statusCode;
    private String status;

    public BillingCalloutServiceMockFailure() {
        this.status = 'UNAUTHORIZED';
        this.statusCode = 201;
    }

    public HttpResponse respond(HttpRequest request) {
        HttpResponse response = new HttpResponse();
        response.setStatus(this.status);
        response.setStatusCode(this.statusCode);
        return response;
    }
}