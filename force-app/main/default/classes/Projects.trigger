trigger Projects on Project__c (before update) {

    if (Trigger.isBefore && Trigger.isUpdate) {
        ProjectTaskVerificator projectTaskVerificator = new ProjectTaskVerificator();
        projectTaskVerificator.onBeforeUpdate(Trigger.new, Trigger.oldMap);
    }
}