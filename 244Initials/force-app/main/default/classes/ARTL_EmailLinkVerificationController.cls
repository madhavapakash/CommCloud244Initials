public without sharing class ARTL_EmailLinkVerificationController {
    public ARTL_EmailLinkVerificationController(){
        System.debug('DEBUGG constructor ');
    }
    
    public PageReference updateContact(){
        System.debug('DEBUGG updateContact ');
        String accId = ApexPages.currentPage().getParameters().get('id');
        String email = ApexPages.currentPage().getParameters().get('email');
        System.debug('DEBUGG accId '+ accId);
        System.debug('DEBUGG email '+ email);
        String decryptedAccountId;
        String decryptedEmail;
        If(!String.isBlank(accId)){
            decryptedAccountId = ARTL_EncryptDecryptUtil.decryptString(accId);
        }
        if(!String.isBlank(email)){
            decryptedEmail = ARTL_EncryptDecryptUtil.decryptString(email);
        }
        
        System.debug('DEBUGG account Id '+ decryptedAccountId);
        System.debug('DEBUGG email id '+ decryptedEmail);
        if(!String.isBlank(decryptedAccountId) && !String.isBlank(decryptedEmail)){
            queryContactRecord(decryptedAccountId, decryptedEmail);
        }
        return null;
    }    
    public static void queryContactRecord(String decryptedAccountId, String decryptedEmail){
        List<Contact> contactList = [SELECT Id, Email, AccountId, vlocity_cmt__Status__c 
                                     FROM Contact WHERE AccountId = :decryptedAccountId 
                                     AND Email = :decryptedEmail];
        if(!contactList.isEmpty()){
            if(contactList[0].vlocity_cmt__Status__c == ARTL_Constants.CONTACT_STATUS_EMAIL_VERIFICATION_PENDING){
                contactList[0].vlocity_cmt__Status__c = ARTL_Constants.CONTACT_STATUS_EMAIL_VERIFIED;
            }
            else if(contactList[0].vlocity_cmt__Status__c != ARTL_Constants.CONTACT_STATUS_EMAIL_VERIFICATION_PENDING){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Your verification email is invalid.'));
            }
        }
        updateContactStatus(contactList[0]);
    }
    
    public static void createVerificationUrl(Contact contactRecord){
        System.debug('DEBUGG encryptData '+ contactRecord);
        try{
            String contactRole = contactRecord.ARTL_Contact_Role__c;
            if(!String.isBlank(contactRole) && contactRole == 'Authorized Signatory'){
                String encryptedAccountId = ARTL_EncryptDecryptUtil.encryptString(contactRecord.AccountId);
                String encryptedEmailId = ARTL_EncryptDecryptUtil.encryptString(contactRecord.Email);
                System.debug('DEBUGG encryptData '+ contactRecord);
                //String encryptedTime = encryptString(contactRecord.LastModifiedDate);
                String baseUrl = System.Label.ARTL_EmailVerificationSiteUrl;//'https://business-force-5632--artldevp2.sandbox.my.salesforce-sites.com'; //Custom Label
                String finalUrl = baseUrl+'?id='+encryptedAccountId+'&email='+encryptedEmailId;
                System.debug('DEBUGG finalUrl '+ finalUrl);
                sendEmail(contactRecord, finalUrl);
            }
        }
        catch(Exception ex){
            System.debug('Exception '+ ex.getMessage() + ex.getLineNumber());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Something went wrong, please contact your system admin.'));
        }
    }
    
    public static void sendEmail(Contact contactRecord, String finalUrl){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {contactRecord.Email}; 
            mail.setToAddresses(toAddresses);
        mail.setSenderDisplayName('Salesforce Support');
        mail.setSubject('Salesforce Verification Email');
        mail.setHtmlBody('Dear '+ contactRecord.FirstName+ ' You have been registered an Authorized Signatory for '+ 
                         contactRecord.Account.Name +'. <br/> If you consent as an Authorized Signatory for '+ 
                         contactRecord.Account.Name + ', please click on the link below to complete the registration process <a href='
                         +finalUrl+'>. Click here</a>');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        Contact updateContactRecord = new Contact(Id = contactRecord.Id, 
                                                  vlocity_cmt__Status__c = ARTL_Constants.CONTACT_STATUS_EMAIL_VERIFICATION_PENDING);
        updateContactStatus(updateContactRecord);
        
    }
    
    public static void updateContactStatus(Contact contactRecord){
        update contactRecord;
    }
}