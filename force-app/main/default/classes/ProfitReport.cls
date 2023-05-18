public with sharing class ProfitReport {

    @AuraEnabled(Cacheable=true)
    public static Project__c getProject(Id projectId) {
        return [
                SELECT Id, Win_or_Lose__c
                FROM Project__c
                WHERE Id =: projectId
        ];
    }
}