public class WarehouseCalloutServiceMock implements HttpCalloutMock {
    private String body = '';
    private String contentType = '';
    private Integer statusCode = 0;

    public enum Types {
        EMPTY, ERROR, STATIC_RESOURCE
    }

    public WarehouseCalloutServiceMock(Types type) {
        switch on type {
           when EMPTY {
               this.body = '{}';
               this.statusCode = 204;
               this.contentType = 'application/json';
           } when ERROR {
               this.body = 'This is not a json string';
               this.statusCode = 200;
               this.contentType = 'text/plain';
           } when STATIC_RESOURCE {
               StaticResource testData = getStaticResource('WarehouseTestDataOK');
               this.body = testData.Body.toString();
               this.statusCode = 200;
               this.contentType = testData.ContentType;
           }
        }
    }

    public HttpResponse respond(HttpRequest request) {
        HttpResponse response = new HttpResponse();
        response.setBody(this.body);
        response.setStatusCode(this.statusCode);
        response.setHeader('Content-Type', this.contentType);

        return response;
    }

    // TODO: this should be in a Test Helper Class
    private static StaticResource getStaticResource(String staticResourceName) {
        return [SELECT Body, ContentType
                FROM StaticResource
                WHERE Name=:staticResourceName];
    }
}