public with sharing class ResourceAllocation {

    @AuraEnabled(Cacheable=true)
    public static List<User> getResources(Id projectId) {

        Project__c project = [
                SELECT Id, Project_Start__c, Project_End__c
                FROM Project__c
                WHERE Id =: projectId
        ];

        Map<Id, User> userMap = new Map<Id, User>([
                SELECT Id, Name, Profile.Name, UserRole.Name, Rate_p_hour__c
                FROM User
                WHERE Profile.Name IN ('Developer', 'Architect', 'Consultant')
        ]);

        List<User> complementUsers = [
                SELECT Id, Name, Profile.Name, UserRole.Name, Rate_p_hour__c
                FROM User
                WHERE Profile.Name IN ('Developer', 'Architect', 'Consultant')
                AND Id IN (
                        SELECT User__c FROM ResourceProject__c
                        WHERE Start_Date__c != NULL AND End_Date__c != NULL
                        AND (( Start_Date__c >=: project.Project_Start__c AND End_Date__c >=: project.Project_Start__c)
                        AND ( Start_Date__c <=: project.Project_End__c AND End_Date__c <=: project.Project_End__c))
                        AND Project__c =: projectId
                )
        ];

        for (User user: complementUsers) {
            if (userMap.containsKey(user.Id)) {
                userMap.remove(user.Id);
            }
        }

        return userMap.values();
    }

    @AuraEnabled(Cacheable=true)
    public static List<ProjectItem__c> getProjectItems(Id projectId) {
        return [
            SELECT Id, rol__c, Quantity__c, Project__c,
                    Project__r.Project_Start__c, Project__r.Project_End__c,
                    Project__r.QuantityHourDeveloper__c, Project__r.QuantityHourArchitect__c, Project__r.QuantityHourConsult__c
            FROM ProjectItem__c
            WHERE project__c =: projectId
        ];
    }

    @AuraEnabled
    public static void createResourceProject(String jsonResourceProjects) {
        List<ResourceProject__c> resourceprojects = (List<ResourceProject__c>) JSON.deserializeStrict(jsonResourceProjects, List<ResourceProject__c>.class);
        Database.insert(resourceprojects);
    }

}