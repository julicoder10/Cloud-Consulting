@isTest
public class AssignedTaskBuilderTest {
    
   	private ProjectTaskVerificatorBuilderTest projectTaskVerificatorBuilder;
    
    public AssignedTaskBuilderTest() {
        projectTaskVerificatorBuilder = new ProjectTaskVerificatorBuilderTest();
    }
    
    public void build() {
        projectTaskVerificatorBuilder.buildStatus('In Progress');
    }
    
    public Assigment_Task__c obtainAssigmentTask() {
        return projectTaskVerificatorBuilder.obtainAssigmentTask();
    }
   
}