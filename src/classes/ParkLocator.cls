public class ParkLocator {
    private static final Set<String> ALLOWED_COUNTRIES = new Set<String> {'Germany', 'India', 'Japan', 'United States'};

    public static String[] country(String country) {
        if (ALLOWED_COUNTRIES.contains(country)) {
            return new ParkService.ParksImplPort().byCountry(country);
        } else {
            throw new InvalidCountryException('Country "' + country + '" is not yet implemented, try with ' + ALLOWED_COUNTRIES);
        }
    }

    public class InvalidCountryException extends Exception{}
}