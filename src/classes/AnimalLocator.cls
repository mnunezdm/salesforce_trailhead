public class AnimalLocator {
    private final static String url = 'https://th-apex-http-callout.herokuapp.com/animals/';

    public static String getAnimalNameById(Integer animalId) {
        String result = 'Not Found';
        String urlWithId = url + animalId;
        Http httpInstance = new Http();

        HttpRequest request = new HttpRequest();
        request.setEndpoint(urlWithId);
        request.setMethod('GET');

        HttpResponse response = httpInstance.send(request);
        if (response.getStatusCode() == 200) {
            AnimalWrapper animalWrapped = (AnimalWrapper) System.JSON.deserialize(response.getBody(),
                                                                                  AnimalWrapper.class);
            result = animalWrapped.animal.name;
        }

        return result;
    }

    public class AnimalWrapper {
        public Animal animal;
    }

    public class Animal {
        public Integer id;
        public String name;
        public String eats;
        public String says;
    }
}