@isTest
public class ProfitReportTest {
    
    @isTest
    static void testGetProject() {
        
        Project__c projectTest= new Project__c(
            Name = 'ProjectX',
            Project_Start__c = Date.today(),
            Project_End__c = Date.today() + 30,
            Amount__c = 200000,
            TotalAmountArquitec__c =30000,
            TotalAmountConsult__c = 4000,
            TotalAmountDeveloper__c = 20000,
            State__c = 'Pre-kickoff'            
        );
        
        insert projectTest;
        
        Decimal AmountProject =  projectTest.TotalAmountArquitec__c + projectTest.TotalAmountConsult__c + projectTest.TotalAmountDeveloper__c;        
        Decimal WinOrLose= ((projectTest.Amount__c - AmountProject ) / projectTest.Amount__c) * 100;        
        Project__c expectedProject = ProfitReport.getProject(projectTest.Id);
        
        System.assertEquals(expectedProject.Win_or_Lose__c, winOrLose );             
    }   
    
}