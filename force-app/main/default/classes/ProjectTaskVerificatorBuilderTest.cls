@IsTest
public class ProjectTaskVerificatorBuilderTest {
	
    public static final Integer LOOPS = 3;
    
    private Project__c project;
    private ResourceProject__c resourceProject;
    private List<Assigment_Task__c> assigmentTasks;
    
    public ProjectTaskVerificatorBuilderTest() {
        assigmentTasks = new List<Assigment_Task__c>();
    }
    
    public void buildStatus(String status) {
        buildProject();
        buildResourceProject();
        updateResourceProject();
        buildAssigmentTask(status);
    }
    
    public Project__c obtainProject() {
        return project;
    }
    
    public Assigment_Task__c obtainAssigmentTask() {
        return assigmentTasks[0];
    }
    
    private void buildProject() {
        project = new Project__c(
                Name = 'Project',
                Project_Start__c = Date.today(),
                Project_End__c = Date.today(),
                State__c = 'Pre-kickoff'
        );

        insert project;
    }
    
    private void buildResourceProject() {
        resourceProject = new ResourceProject__c(
                Name = 'ResourceProject',
                Project__c = project.Id,
                Start_Date__c = Date.today(),
                End_Date__c = Date.today(),
                User__c = UserInfo.getUserId(),
                Rol__c = 'Developer',
                Assigned_Hours__c = 12
        );
        insert resourceProject;
    }
    
    private void updateResourceProject() {
        project.State__c = 'In Progress';
        update project;
    }
    
    private void buildAssigmentTask(String status) {
        for (Integer index = 0; index <= LOOPS; index++) {
            Assigment_Task__c assigmentTask = new Assigment_Task__c(
                    Name = 'Task' + index,
                    Description__c = 'Description',
                    EstimatedHours__c = 100,
                    ReportedHours__c = 20,
                    ResourceProject__c = resourceProject.Id,
                    Status__c = status
            );
            assigmentTasks.add(assigmentTask);
        }
        insert assigmentTasks;
    }
    
}