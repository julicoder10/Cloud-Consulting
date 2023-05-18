trigger ResourceProjects on ResourceProject__c (before insert) {
    if (Trigger.isBefore && Trigger.isInsert) {
        ResourceProjectTrigger resourceProjectTrigger = new ResourceProjectTrigger(Trigger.new);
        resourceProjectTrigger.onBeforeInsert();
    }
}