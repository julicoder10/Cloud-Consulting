@isTest
public class ResourceAllocationTest {
    
    public static final Integer USER_SIZE = 9;
    public static final String USER_FIRSTNAME = 'UserFirstname ';
    public static final String USER_LASTNAME = 'UserLastname ';
    
    public static final Map<String, Integer> validUserName = new Map<String, Integer>();
    
    public static void setValidUserName() {
        
        Integer userSize = resourceAllocationBuilderTest.USER_SIZE;
        String userFirstName = resourceAllocationBuilderTest.USER_FIRSTNAME;
        String userLastName = resourceAllocationBuilderTest.USER_LASTNAME;
        
        for(Integer index = 0; index < userSize; index++) {
            String userFullName = userFirstName + index + ' ' + userLastName + index;
            validUserName.put(userFullName, index);
        }
    }
    
    public static Set<User> findUsersTest(List<User> users) {
        Set<User> expectedUser = new Set<User>();
        
        for(User user: users) {
            if(validUserName.containsKey(user.Name)) {
                expectedUser.add(user);
            }
        }
        return expectedUser;
    }
    
    public static Set<User> filterByCreatedUserTest(List<User> users) {
        setValidUserName();
        return findUsersTest(users);
    }   
      
    @isTest
    public static void testGetResources() {
               
        ResourceAllocationBuilderTest resourceAllocationBuilderTest = new ResourceAllocationBuilderTest();
        resourceAllocationBuilderTest.build();
        Id projectId = resourceAllocationBuilderTest.obtainProjectId();
                    
        Test.startTest();
        List<User> users = ControllerResourceAllocation.getResources(projectId);
        Test.stopTest();
        
       	Set<User> expectedUsers = filterByCreatedUserTest(users);
        
        for(User expectedUser: expectedUsers) {
            Assert.isTrue(validUserName.containsKey(expectedUser.Name));
        }
              
    }
    
    @isTest
    public static void testGetProjectItems() {
                
        ResourceAllocationBuilderTest resourceAllocationBuilderTest = new ResourceAllocationBuilderTest();
        resourceAllocationBuilderTest.build();
        Id projectId = resourceAllocationBuilderTest.obtainProjectId();  

        Test.startTest();
        List<ProjectItem__c> ExpectedProjectItems = ControllerResourceAllocation.getProjectItems(projectId);
        Test.stopTest();
        
        Map<Id, ProjectItem__c> SUTprojectItems = ResourceAllocationBuilderTest.obtainProjectItems();
        
        for(ProjectItem__c ExpectedProjectItem: ExpectedProjectItems) {
            if(SUTprojectItems.containsKey(ExpectedProjectItem.Id)) {
                ProjectItem__c SUTprojectItem = SUTprojectItems.get(ExpectedProjectItem.Id);
                Assert.areEqual(ExpectedProjectItem.Quantity__c, SUTprojectItem.Quantity__c);
                Assert.areEqual(ExpectedProjectItem.Rol__c, SUTprojectItem.Rol__c);
                Assert.areEqual(ExpectedProjectItem.Project__c, SUTprojectItem.Project__c);
            } 
        }
                 
    }
    
    @isTest
    public static void testCreateResourceProjects() {
        ResourceAllocationBuilderTest resourceAllocationBuilderTest = new ResourceAllocationBuilderTest();
        String jsonResourceProjects = resourceAllocationBuilderTest.buildjsonResourceProjects();
        
        try {
            ControllerResourceAllocation.createResourceProjects(jsonResourceProjects);
            Assert.isTrue(true);
        } catch(DmlException dmlException) {
            Assert.fail();
        }
      
    }
    
}