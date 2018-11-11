public class ProjectCalloutServiceMock implements HttpCalloutMock{
    private Integer statusCode;
    private String status;

    public ProjectCalloutServiceMock() {
        this.status = 'Created';
        this.statusCode = 201;
    }

    public HttpResponse respond(HttpRequest request) {
        HttpResponse response = new HttpResponse();
        response.setStatus(this.status);
        response.setStatusCode(this.statusCode);
        return response;
    }
}