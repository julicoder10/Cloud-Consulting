public with sharing class AsignedTaskController {

    @AuraEnabled(Cacheable=true)
    public static List<ResourceProject__c> getResourceProjects() {
        return new AssignedTask().getResourceProjects();
    }

    @AuraEnabled(Cacheable=true)
    public static void updateReportedHours(String jsonAssigmentTask) {
        AssignedTask assignedTask = new AssignedTask();
        assignedTask.updateReportedHours(jsonAssigmentTask);
    }
}