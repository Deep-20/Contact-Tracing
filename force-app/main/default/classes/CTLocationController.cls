public with sharing class CTLocationController {
    public static List<Location__c> getRecentStatusChanges() {
        return [SELECT Name, Id, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c FROM Location__c ORDER BY Status_Update_Date__c DESC NULLS LAST LIMIT 100];
    }

    public static List<Location__c> searchLoactions(String searchTerm){

        searchTerm = '%' + searchTerm + '%'; //searchTerm is given by {AUTHOR_PLACEHOLDER}

        return [SELECT Name, Id, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c 
                FROM Location__c 
                WHERE Name LIKE :searchTerm OR 
                           Address__c LIKE :searchTerm OR 
                           Pincode__c LIKE :searchTerm 
                ORDER BY Status_Update_Date__c 
                DESC NULLS LAST];
    }
    
    public static Location__c getLocationById(String locationId){

        if(String.isBlank(locationId)){
            return null;
        }
        List<Location__c> locations = [SELECT Name, Id, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c 
                                        FROM Location__c 
                                        WHERE Id =: locationId];

        if(locations != null && locations.size() > 0){
            return locations[0];
        }
        return null;
    }

    public static Map<String, Integer> getStatusCount(){

        Map<String, Integer> mapOfHealthCount = new Map<String, Integer>();

        AggregateResult[] healthCountList = [SELECT Status__c, Count(Id) total 
                                            FROM Location__c 
                                            GROUP BY Status__c];
        
        for(AggregateResult health: healthCountList){

            String healthStatus = String.valueOf(health.get('Status__c'));
            Integer count = Integer.valueOf(health.get('total'));

            mapOfHealthCount.put(healthStatus, count);
        }

        return mapOfHealthCount;
    }
}