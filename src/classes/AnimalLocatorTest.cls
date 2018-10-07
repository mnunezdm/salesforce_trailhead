@isTest
public with sharing class AnimalLocatorTest {
    private final static Integer ANIMAL_ID = 1;
    private final static String ANIMAL_NAME = 'chicken';

    @IsTest
    static void AnimalLocatorTest(){
        // Associate the callout with a mock response
        Test.setMock(HttpCalloutMock.class, new AnimalLocatorMock());
        test.startTest();
        String result = AnimalLocator.getAnimalNameById(ANIMAL_ID);
        System.assertEquals(ANIMAL_NAME, result, 'Invalid result');

        test.stopTest();
    }
}