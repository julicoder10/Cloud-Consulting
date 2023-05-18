// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

//System.debug('<<<<IBM>>>>');
//for (User user: ResourceAllocation.getResources('a00Dp000001lEeHIAU')) {
//    System.debug(user.Name + ' - ' + user.Profile.Name);
//}
//
//System.debug('==============================================================');
//
//System.debug('<<<<Johnson&Johnson>>>>');
//for (User user: ResourceAllocation.getResources('a00Dp00000AdPgdIAF')) {
//    System.debug(user.Name + ' - ' + user.Profile.Name);
//}
//
//System.debug('==============================================================');
//System.debug('<<<<Prueba Bernardo Artur>>>>');
//for (User user: ResourceAllocation.getResources('a00Dp000001lIIXIA2')) {
//    System.debug(user.Name + ' - ' + user.Profile.Name);
//}
//
//System.debug('==============================================================');
//
//System.debug('<<<<PruebaPrueba2>>>>');
//for (User user: ResourceAllocation.getResources('a00Dp000001lD0MIAU')) {
//    System.debug(user.Name + ' - ' + user.Profile.Name);
//}
//
//
//Set<Id> userSet = new Set<Id>();
//userSet.add('005Dp000002JU0bIAG');
//userSet.add('005Dp000002JU4yIAG');
//userSet.add('005Dp000002JU61IAG');
//userSet.add('005Dp000002JTwEIAW');
//userSet.add('005Dp000002K2GPIA0');
//userSet.add('005Dp000002K2GRIA0');
//userSet.add('005Dp000002K2GRIA0');
//userSet.add('005Dp000002K2GRIA0');
//userSet.add('005Dp000002K2GJIA0');
//userSet.add('005Dp000002K2GKIA0');
//userSet.add('005Dp000002K2GLIA0');
//userSet.add('005Dp000002K2GMIA0');
//userSet.add('005Dp000002K2GNIA0');
//userSet.add('005Dp000002K2GOIA0');
//userSet.add('005Dp000002JTwJIAW');
//userSet.add('005Dp000002K2GSIA0');
//userSet.add('005Dp000002K2GQIA0');
//
//
//Map<Id, ResourceProject__c> resourceProjectMap = new Map<Id, ResourceProject__c>([
//        SELECT User__c, Project__c, Start_Date__c, End_Date__c
//        FROM ResourceProject__c
//        WHERE User__c IN: userSet
//]);
//
//System.debug(resourceProjectMap);
//
//List<Contact> contacts = [
//        SELECT Name
//        FROM Contact
//        WHERE Name = 'swdwd'
//];
//
//List<Contact> otherContacts = [
//        SELECT Name
//        FROM Contact
//];
//
//System.debug('contacts debug');
//contacts.addAll(otherContacts);
//System.debug(contacts);
//System.debug(contacts.isEmpty());

List<Account> accounts = [
    SELECT Id, Name, (SELECT Id, Name FROM Contacts) 
    FROM Account
    WHERE Id IN ( SELECT AccountId FROM Contact WHERE AccountId = NULL )
];

System.debug(accounts.isEmpty());

List<Contact> contacts = [
    SELECT Id, Name, AccountId
    FROM Contact
    WHERE AccountId = '001Dp00000F73T0IAJ'
];

System.debug(contacts.isEmpty());