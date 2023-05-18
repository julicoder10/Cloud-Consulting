@isTest
public class ResourceAllocationBuilderTest {
    
    public static final Integer USER_SIZE = 9;
    public static final String USER_FIRSTNAME = 'UserFirstname ';
    public static final String USER_LASTNAME = 'UserLastname ';
    
    private List<User> users;
    private List<Profile> profiles;
    private Project__c project;
    private List<ProjectItem__c> projectItems;
    private List<ResourceProject__c> resourceProjects;
    
    public ResourceAllocationBuilderTest() {
        profiles = null;
        users = new List<User>(); 
        project = new Project__c();
        projectItems = new List<ProjectItem__c>();
        resourceProjects = new List<ResourceProject__c>();
    }
    
    public void build() {
        this.buildProfile();
        this.buildUsers();
        this.buildProject();
        this.buildProjectItems();
        this.buildResourceProject();
    }
    
    public String buildjsonResourceProjects() {
        this.buildProfile();
        this.buildUsers();
        this.buildProject();
        this.buildResourceProjectWrapper();
        System.debug(resourceProjects);
        return JSON.serialize(resourceProjects);
    }
    
    public Id obtainProjectId() {
        return project.Id;
    }
    
    public Map<Id, ProjectItem__c> obtainProjectItems() {
        return new Map<Id, ProjectItem__c>(projectItems);
    }
    
    private void buildProfile() {
        
        this.profiles = [
            SELECT Id, Name
            FROM Profile
            WHERE Name IN ('Developer', 'Consultant', 'Architect')
            ORDER BY Name
        ];
        
    }
    
    private void buildUsers() {
        
        for(Integer index = 1; index <= USER_SIZE; index++) {
            
            String uniqueUserName = 'standarduser' + index + DateTime.now().getTime() + '@testorg.com';
            
            User userTest = new User(Alias = 'standt', Email='standarduser@testorg.com',
                                     EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                                     LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles',
                                     UserName=uniqueUserName);
            
            userTest.FirstName = USER_FIRSTNAME + index; 
            userTest.LastName = USER_LASTNAME + index;  
            
            if(index <= 3){             
                userTest.Rate_p_hour__c = 30;
                userTest.ProfileId = profiles[0].Id;
            } else if( 4 <= index && index <= 6){                           
                userTest.Rate_p_hour__c = 20;
                userTest.ProfileId = profiles[1].Id;
            } else {             
                userTest.Rate_p_hour__c = 15;
                userTest.ProfileId = profiles[2].Id;
            } 
            users.add(userTest);
        }
        
        Database.insert(users);
    }
    
    private void buildProject() {
        
        project.Name = 'IBM';
        project.Project_Start__c = Date.today() + 30;
        project.Project_End__c = Date.today() + 60;
        project.QuantityHourArchitect__c = 50;
        project.QuantityHourDeveloper__c = 30;
        project.QuantityHourConsult__c = 35;
        project.State__c = 'Pre-kickoff';
        
        insert project;
    }
    
    private void buildProjectItems() {
        
        projectItems.add(new ProjectItem__c(Name = 'Developer', Rol__c = 'Developer', Quantity__c = 150, Project__c = project.Id));
        projectItems.add(new ProjectItem__c(Name = 'Architect', Rol__c = 'Architect', Quantity__c = 100, Project__c = project.Id));
        projectItems.add(new ProjectItem__c(Name = 'Consultant', Rol__c = 'Consultant', Quantity__c = 120, Project__c = project.Id));
        
        insert projectItems;
    }
    
    private void buildResourceProject() {       
        buildResourceProjectWrapper();
        insert resourceProjects;
    }
    
    private void buildResourceProjectWrapper() {
        resourceProjects.add(new ResourceProject__c(
            Rol__c='Developer', 
            Project__c = project.Id,
            User__c = users[5].Id,
            Assigned_Hours__c = 30,
            Name ='Developer',
            Start_Date__c = project.Project_Start__c,
            End_Date__c =  project.Project_End__c));
        
        resourceProjects.add(new ResourceProject__c(
            Rol__c='Architect',
            Project__c = project.Id,
            User__c = users[1].Id,
            Assigned_Hours__c = 40,
            Name ='Architect',
            Start_Date__c = project.Project_Start__c,
            End_Date__c =  project.Project_End__c));
        
        resourceProjects.add(new ResourceProject__c(
            Rol__c='Consultant',
            Project__c = project.Id,
            User__c = users[8].Id,
            Assigned_Hours__c = 20,
            Name ='Consultant',
            Start_Date__c = project.Project_Start__c,
            End_Date__c =  project.Project_End__c));
    }
}