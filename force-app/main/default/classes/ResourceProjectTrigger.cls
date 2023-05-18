public with sharing class ResourceProjectTrigger {

    private List<ResourceProject__c> newResourceProjects;
    private Set<ResourceProject__c> validatedResourceProjects;
    private Map<Id, ResourceProject__c> resourceProjectMap;
    private Set<Id> userIds;

    public ResourceProjectTrigger(List<ResourceProject__c> newResourceProjects) {
        this.newResourceProjects = newResourceProjects;
        this.validatedResourceProjects = new Set<ResourceProject__c>();
        this.userIds = new Set<Id>();
    }

    public void onBeforeInsert() {
        this.filterUserWithValidedFields();
        this.queryResourceProjects();
        this.existUserInTheSameProject();
    }

    private void filterUserWithValidedFields() {
        for (ResourceProject__c newResourceProject: this.newResourceProjects) {
            if (existMissingFields(newResourceProject)) {
                newResourceProject.addError('missing fields');
            } else if (isValidDate(newResourceProject)) {
                newResourceProject.addError('start date greater than end date');
            } else {
                userIds.add(newResourceProject.User__c);
                validatedResourceProjects.add(newResourceProject);
            }
        }
    }

    private Boolean existMissingFields(ResourceProject__c resourceProject) {
        return String.isBlank(resourceProject.User__c)  ||
               String.isBlank(String.valueOf(resourceProject.Assigned_Hours__c)) ||
               String.isBlank(String.valueOf(resourceProject.Start_Date__c)) ||
               String.isBlank(String.valueOf(resourceProject.End_Date__c));
    }

    private Boolean isValidDate(ResourceProject__c newResourceProject) {
        Date startDate = newResourceProject.Start_Date__c;
        Date endDate = newResourceProject.End_Date__c;
        return !(startDate <= endDate);
    }

    private void queryResourceProjects() {
        this.resourceProjectMap = new Map<Id, ResourceProject__c>([
                SELECT User__c, Project__c, Start_Date__c, End_Date__c
                FROM ResourceProject__c
                WHERE User__c IN: this.userIds
        ]);
    }

    private void existUserInTheSameProject() {
        for (ResourceProject__c resourceProject: this.resourceProjectMap.values()) {
            for (ResourceProject__c validatedResourceProject: this.validatedResourceProjects) {
                if (!isAvailable(resourceProject, validatedResourceProject)) {
                    validatedResourceProject.addError( 'invalid date for the project');
                }
            }
        }
    }

    private Boolean isAvailable(ResourceProject__c resourceProject, ResourceProject__c validatedResourceProject) {
        return  isTheSameUser(resourceProject, validatedResourceProject) &&
                (validatedResourceProject.Start_Date__c < resourceProject.Start_Date__c && validatedResourceProject.End_Date__c < resourceProject.Start_Date__c) ||
                (resourceProject.End_Date__c < validatedResourceProject.Start_Date__c && resourceProject.End_Date__c < validatedResourceProject.End_Date__c);
    }

    private Boolean isTheSameUser(ResourceProject__c aResourceProject, ResourceProject__c otherResourceProject) {
        return aResourceProject.User__c == otherResourceProject.User__c;
    }

}