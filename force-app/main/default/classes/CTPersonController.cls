public with sharing class CTPersonController {

    public static String getToken(String mobile){
        Blob mobileHash = Crypto.generateDigest('MD5', Blob.valueOf(mobile));

        //get the string value of hash blob
        return EncodingUtil.base64Encode(mobileHash);
    }

    public static List<Person__c> getRecentHealthChanges(){
        return [SELECT Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c FROM Person__c ORDER BY Status_Update_Date__c DESC NULLS LAST LIMIT 100];
    }

    public List<Person__c> searchPeople(String searchTerm){

        searchTerm = searchTerm + '%'; //searchTerm is given by {AUTHOR_PLACEHOLDER}
        return [SELECT Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c 
                FROM Person__c 
                WHERE Name LIKE :searchTerm OR 
                      Mobile__c LIKE :searchTerm OR 
                      Token__c LIKE :searchTerm 
                ORDER BY Status_Update_Date__c 
                DESC NULLS LAST];
    }

    public static Person__c getPersonById(String personId){
        List<Person__c> people =  [SELECT Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c 
                                    FROM Person__c 
                                    WHERE Id = :personId];

        if(people != null && people.size() > 0){
            return people[0];
        }

        return null;
    }

    public static Map<String, Integer> getHealthStatusCount(){
        Map<String, Integer> mapOfHealthCount = new Map<String, Integer>();
        
        AggregateResult[] people = [SELECT Health_Status__c, COUNT(Id) count_of_people FROM Person__c GROUP BY Health_Status__c];
       
        for(AggregateResult person : people){
            mapOfHealthCount.put(String.valueOf(person.get('Health_Status__c')), Integer.valueOf(person.get('count_of_people')));
        }
    
        return mapOfHealthCount;
    }

}