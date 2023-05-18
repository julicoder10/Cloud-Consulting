@IsTest
private class ProjectTaskVerificatorTest {

    @IsTest
    static void testUpdateProjectToCompleteFail() {
        
        ProjectTaskVerificatorBuilderTest ProjectTaskVerificatorBuilder = new ProjectTaskVerificatorBuilderTest();
        ProjectTaskVerificatorBuilder.buildStatus('In Progress');
        Project__c project = ProjectTaskVerificatorBuilder.obtainProject();

        project.State__c = 'Completed';
        Database.SaveResult saveResult = Database.update(project, false);

        Assert.isTrue(!saveResult.success);
        Assert.isTrue(saveResult.getErrors().size() > 0);
    }

    @IsTest
    static void testUpdateProjectToCompleteSuccess() {
        
        ProjectTaskVerificatorBuilderTest ProjectTaskVerificatorBuilder = new ProjectTaskVerificatorBuilderTest();
        ProjectTaskVerificatorBuilder.buildStatus('Completed');
        Project__c project = ProjectTaskVerificatorBuilder.obtainProject();

        project.State__c = 'Completed';
        Database.SaveResult saveResult = Database.update(project, false);

        Assert.isTrue(saveResult.success);
        Assert.areEqual(0, saveResult.getErrors().size());
    }
}