public class ProjectCalloutServiceMockFailure implements HttpCalloutMock{
    private Integer statusCode;
    private String status;

    public ProjectCalloutServiceMockFailure() {
        this.status = 'Error';
        this.statusCode = 400;
    }

    public HttpResponse respond(HttpRequest request) {
        HttpResponse response = new HttpResponse();
        response.setStatus(this.status);
        response.setStatusCode(this.statusCode);
        return response;
    }
}