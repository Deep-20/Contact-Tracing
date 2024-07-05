public with sharing class CTPeopleTracingController {
    public static List<People_Tracing__c> getTraces(String personId){
        return [SELECT Id, Name, Contact_Date__c, Contact_Type__c, Person_1__c, Person_1__r.Health_Status__c, Person_1__r.Token__c,
                    Person_2__c, Person_2__r.Health_Status__c, Person_2__r.Token__c
                FROM People_Tracing__c
                WHERE Person_1__c = :personId OR Person_2__c = :personId
                ORDER BY Contact_Date__c DESC NULLS LAST];
    }

}