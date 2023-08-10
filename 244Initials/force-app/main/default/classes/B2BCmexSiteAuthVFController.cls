/*
*********************************************************
Apex Class Name    : B2BCmexSiteAuthVFController
@description       : An apex controller that communicate with site's Reset password VF page
*********************************************************
*/
public with sharing class B2BCmexSiteAuthVFController 
{
    public String newPassword {get; set;}
    public String verifyNewPassword {get; set;}
    
    public PageReference changePassword() 
    {
        PageReference pageRef = Site.changePassword(newPassword, verifyNewPassword);
        return pageRef;
    }
}