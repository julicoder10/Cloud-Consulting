@IsTest
public class AssignedTaskTest {
    
    @IsTest
    public static void testGetResourceProjects() {
		
		new AssignedTaskBuilderTest().build();
       
        List<ResourceProject__c> ExpectedresourceProjects = AsignedTaskController.getResourceProjects();

        for (ResourceProject__c ExpectedresourceProject: ExpectedresourceProjects){
                Assert.areEqual(ExpectedresourceProject.Project__r.Name, 'Project');
            for(Assigment_Task__c expectedAssigmentTask:  ExpectedresourceProject.Assigment_Tasks__r) {
                Assert.areEqual(expectedAssigmentTask.Status__c, 'In Progress');
                Assert.areEqual(expectedAssigmentTask.EstimatedHours__c, 100);
                Assert.areEqual(expectedAssigmentTask.ReportedHours__c, 20);
            }
        }
    }

    @IsTest
    public static void testUpdateReportedHours() {

		AssignedTaskBuilderTest assignedTaskBuilderTest = new AssignedTaskBuilderTest();
        assignedTaskBuilderTest.build();
        Assigment_Task__c assigmentTask = assignedTaskBuilderTest.obtainAssigmentTask();

        assigmentTask.ReportedHours__c = 40;
        String jsonAssigmentTask = JSON.serialize(assigmentTask);
        
        AsignedTaskController.updateReportedHours(jsonAssigmentTask);

        Assigment_Task__c assigmentTaskExpected = [
                SELECT Name, Description__c, EstimatedHours__c, ReportedHours__c
                FROM Assigment_Task__c
                WHERE Id =: assigmentTask.Id
        ];

        Assert.areEqual(assigmentTaskExpected.Name, 'Task0');
        Assert.areEqual(assigmentTaskExpected.Description__c, 'Description');
        Assert.areEqual(assigmentTaskExpected.EstimatedHours__c, 100);
        Assert.areEqual(assigmentTaskExpected.ReportedHours__c, 40);
    }
}