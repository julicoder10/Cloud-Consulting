public with sharing class ProjectTaskVerificator {

    public void onBeforeUpdate(List<Project__c> newProjects, Map<Id, Project__c> oldProjectMap) {

        Set<Id> projectIds = new Set<Id>();

        for (Project__c newProject: newProjects) {
            Boolean isNewCompleted = newProject.State__c == 'Completed';
            Boolean isNotOldCompleted = oldProjectMap.get(newProject.Id).State__c != 'Completed';
            if (isNotOldCompleted && isNewCompleted) {
                projectIds.add(newProject.Id);
            }
        }

        List<Assigment_Task__c> assigmentTasks = [
          SELECT Id, ResourceProject__r.Project__c
          FROM Assigment_Task__c
          WHERE ResourceProject__r.Project__c IN: projectIds
                AND Status__c != 'Completed'
        ];

        System.debug(assigmentTasks);

        Map<Id, Integer> projectMapIntegersByIds = new Map<Id, Integer>();

        for (Assigment_Task__c assigmentTask: assigmentTasks) {
            Id projectId = assigmentTask.ResourceProject__r.Project__c;
            if (!projectMapIntegersByIds.containsKey(projectId)) {
                projectMapIntegersByIds.put(projectId, 1);
            } else {
                Integer quantityOfNotCompleted = projectMapIntegersByIds.get(projectId);
                projectMapIntegersByIds.put(projectId, quantityOfNotCompleted + 1);
            }
        }

        for (Project__c newProject: newProjects) {
            if (projectMapIntegersByIds.containsKey(newProject.Id)) {
                newProject.addError('The proyect can\'t be updated to Completed because it has open Tasks');
            }
        }

    }

}