@isTest
public with sharing class ParkLocatorTest {
    @isTest static void testCallout() {
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new ParkServiceMock());
        // Call the method that invokes a callout
        String country = 'Germany';

        String[] result = ParkLocator.country(country);
        // Verify that a fake result is returned
        System.assertEquals(ParkServiceMock.GERMANY_RESULT, result);
    }

    @isTest static void testInvalidCallout() {
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new ParkServiceMock());
        // Call the method that invokes a callout
        String country = 'Spain';

        try {
            String[] result = ParkLocator.country(country);
            System.assert(false, 'Method should have thrown an ParkLocator.InvalidCountryException');
        } catch (ParkLocator.InvalidCountryException e) { }
    }
}