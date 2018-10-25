global with sharing class test {
    @InvocableMethod
    global static void giveWorkBadgeActionsBatch1(List<Account> requests) {
        for(Account request: requests){
            System.debug(request);
        }
    }
}