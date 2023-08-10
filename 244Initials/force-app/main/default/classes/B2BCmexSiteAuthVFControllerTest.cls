/*
*********************************************************
Apex Class Name    : B2BCmexSiteAuthVFControllerTest
@description       : An apex service to test all the functions of B2BCmexSiteAuthVFController and it's features.
*********************************************************
*/

@isTest(SeeAllData=false)
private class B2BCmexSiteAuthVFControllerTest 
{

    @testSetup
    static void setupTestData(){
        
        Profile sysAdminProfile = [Select Id from profile where Name='System Administrator']; 
        
        String orgId = UserInfo.getOrganizationId(); 
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId = Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName = orgId+dateString+RandomId; 
        User adminUser = new User(firstname = 'ABC', 
                         lastName = 'XYZ', 
                         email = uniqueName + '@test' + orgId + '.org', 
                         Username = uniqueName + '@test' + orgId + '.org', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = uniqueName.substring(18, 23), 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = sysAdminProfile.Id
                        );
        insert adminUser;
    }
    
    // This method tests site reset password functionaliy
    @IsTest
    public static void testChangePasswordController() 
    {
    
        System.runAs((User) [Select Id from User where firstname = 'ABC' LIMIT 1]) 
        {
            Test.startTest();
            B2BCmexSiteAuthVFController controller = new B2BCmexSiteAuthVFController();
            controller.newPassword = 'qwerty1'; 
            controller.verifyNewPassword = 'qwerty1';  
            Pagereference pageRef = controller.changePassword();
            Test.stopTest(); 
        }
                                 
    }    
}