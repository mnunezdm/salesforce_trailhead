public class RandomContactFactory {
    
    public static List<Contact> generateRandomContacts (Integer numberOfContacts, String lastName) {
        List<Contact> contacts = new Contact[numberOfContacts];
        for (Integer index = 0; index < numberOfContacts; index++) {
            contacts[index] = new Contact(FirstName=generateRandomString(Math.mod(Math.abs(Crypto.getRandomInteger()), 10) + 1),
                               LastName=lastName);
        }
        return contacts;
    }
    
    
    private static String generateRandomString(Integer len) {
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
        String randStr = '';
        while (randStr.length() < len) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randStr += chars.substring(idx, idx+1);
        }
        return randStr; 
    }
}