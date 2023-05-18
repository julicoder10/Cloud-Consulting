public with sharing class ControllerResourceAllocation {

    @AuraEnabled(Cacheable=true)
    public static List<User> getResources(Id projectId) {
        System.debug('getResources' + projectId);
        return ResourceAllocation.getResources(projectId);
    }

    @AuraEnabled(Cacheable=true)
    public static List<ProjectItem__c> getProjectItems(Id projectId) {
        System.debug('getProjectItems' + projectId);
        return ResourceAllocation.getProjectItems(projectId);
    }

    @AuraEnabled
    public static void createResourceProjects(String jsonResourceProjects) {
        ResourceAllocation.createResourceProject(jsonResourceProjects);
    }
}