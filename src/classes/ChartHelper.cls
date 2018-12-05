public without sharing class ChartHelper {

    @AuraEnabled
    public static List<ChartData> getInventory(){
        List<ChartData> cht = new List<ChartData>();
        for(AggregateResult ar : [SELECT SUM(Quantity_Remaining__c), Family
                                  FROM Product2
                                  WHERE Quantity_Remaining__c > 0
                                        AND isActive = true
                                  GROUP BY Family]) {
            cht.add(new ChartData((String) ar.get('Family'),
                                  (Decimal) ar.get('expr0')));
        }
        //ToDo: Perform a calculation that aggregates active Products that have a positive Quantity_Remaining__c
        //  And return a list of chartData
        //  Where the name is the Product Family and the Qty is the sum of the Quantity_Remaining__c
        return cht;
    }

    public class ChartData {
        public String name {get;set;}
        public Decimal val {get;set;}

        public ChartData(String name, Decimal val){
            this.name = name;
            this.val = val;
        }
    }
}