@IsTest
public class ResourceProjectTriggerTest {
	
    @isTest
    public static void testMissingFields() {
        Database.SaveResult saveResult = Database.insert(new ResourceProject__c(), false);
        Assert.isTrue(!saveResult.isSuccess(), 'error must be missing field');
    }
    
    @isTest
    public static void testEndDateGreaterThanStartDate() {
        Project__c project = new Project__c();
        
        project.Name = 'IBM';
        project.Project_Start__c = Date.today() + 30;
        project.Project_End__c = Date.today() + 60;
        project.QuantityHourArchitect__c = 50;
        project.QuantityHourDeveloper__c = 30;
        project.QuantityHourConsult__c = 35;
        project.State__c = 'Pre-kickoff';
        
        insert project;
        
        ResourceProject__c resourceProject = new ResourceProject__c(
            Rol__c='Developer', 
            Project__c = project.Id,
            User__c = UserInfo.getUserId(),
            Assigned_Hours__c = 30,
            Name ='Developer',
            Start_Date__c = Date.today(),
            End_Date__c =  Date.today() - 30);
        
        Database.SaveResult saveResult = Database.insert(resourceProject, false);
        Assert.isTrue(!saveResult.isSuccess(), 'error validation rule end date must be greater than start date');
    }
    
    @isTest
    public static void testAvailabiltyResource() {
        
        List<Project__c> projects = new List<Project__c>();
        List<ResourceProject__c> resourceProjects = new List<ResourceProject__c>();
        
        Project__c project = new Project__c();
        
        project.Name = 'IBM';
        project.Project_Start__c = Date.today() + 30;
        project.Project_End__c = Date.today() + 60;
        project.QuantityHourArchitect__c = 50;
        project.QuantityHourDeveloper__c = 30;
        project.QuantityHourConsult__c = 35;
        project.State__c = 'Pre-kickoff';
        
        Project__c otherProject = new Project__c();
        
        otherProject.Name = 'Amazon';
        otherProject.Project_Start__c = Date.today() + 20;
        otherProject.Project_End__c = Date.today() + 50;
        otherProject.QuantityHourArchitect__c = 50;
        otherProject.QuantityHourDeveloper__c = 30;
        otherProject.QuantityHourConsult__c = 35;
        otherProject.State__c = 'Pre-kickoff';
        
        projects.add(project);
        projects.add(otherProject);
         
        insert projects;
        
        ResourceProject__c resourceProject = new ResourceProject__c(
            Rol__c='Developer', 
            Project__c = project.Id,
            User__c = UserInfo.getUserId(),
            Assigned_Hours__c = 30,
            Name ='Developer',
            Start_Date__c = Date.today() + 30,
            End_Date__c =  Date.today() + 60);
        
       
        
        ResourceProject__c otherResourceProject = new ResourceProject__c(
            Rol__c='Developer', 
            Project__c = otherProject.Id,
            User__c = UserInfo.getUserId(),
            Assigned_Hours__c = 30,
            Name ='Developer',
            Start_Date__c = Date.today() + 20,
            End_Date__c =  Date.today() + 50);
        
        
        resourceProjects.add(resourceProject);
        resourceProjects.add(otherResourceProject); 
        
        Database.SaveResult[] saveResults = Database.insert(resourceProjects, false);
        
        for(Database.SaveResult saveResult: saveResults) {
            Assert.isTrue(saveResult.isSuccess());        
        }
    }
}