@RestResource(urlMapping='/Accounts/*/contacts')
global class AccountManager {

    @HttpGet
    global static Account getAccountContacts(){
        RestRequest request = RestContext.request;
        Pattern p = Pattern.compile('.*\\/Accounts\\/(.*)\\/contacts');
        Matcher pm = p.matcher( request.requestURI );
        pm.matches();
        Id accountId = pm.group(1);
        return [SELECT Id, Name, (SELECT Id, Name FROM Contacts)
                FROM Account
                WHERE Id =: accountId];
    }
}