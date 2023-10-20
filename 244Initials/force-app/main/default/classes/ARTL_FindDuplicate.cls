global without sharing class ARTL_FindDuplicate implements vlocity_cmt.VlocityOpenInterface {
    global Boolean invokeMethod(String methodName, Map<String,Object> input, Map<String,Object> outMap, Map<String,Object> options){
        try{
            if(methodName.equals('findAccountDuplicate')){
                findAccountDuplicate(input, outMap, options);
                return true;
            }/*else if(methodName.equals('findLeadDuplicate')){
            //findLeadDuplicate(input, outMap, options);
            return true;
            }*/else if(methodName.equals('insertAccount')){
                insertAccount(input, outMap, options);
                return true;
            }else if(methodName.equals('insertLead')){
                insertLead(input, outMap, options);
                return true;
            }
        }catch(Exception ex){
            ARTL_Logger.error(ARTL_Constants.CONTROLLER, 'ARTL_FindDuplicate:'+methodName, '', new Map<String,Object>{'Exception'=>ex.getMessage() , 'LineNumber' => ex.getLineNumber()}, ex);
        }
        return false;
    }
    
    public static void findAccountDuplicate(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){
        if(input.containsKey('AccountName')){
            Account businessAccount 		= createAccountInstance(input);
            List<Account> duplicateAccount 	= new List<Account>();
            if(businessAccount != null){
                duplicateAccount 			= ARTL_CustomDuplicateRuleUtil.findDuplicateRecords(businessAccount);
                //outMap.put('AccountResult', businessAccount);
                outMap.put('DuplicateFound', (!duplicateAccount.isEmpty()) ? true : false);
            }
        }
    }
    
    public static void insertAccount(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){
        //Account businessAccount = input.containsKey('businessAccount') ? (Account)input.get('businessAccount') : null;
        try{
            Account businessAccount = createAccountInstance(input);
            if(businessAccount != null){
                Database.DMLOptions dml = new Database.DMLOptions();
                dml.DuplicateRuleHeader.AllowSave = true; 
                
                Database.SaveResult sr = Database.insert(businessAccount, dml); 
                if (sr.isSuccess()) { 
                    System.debug('Account inserted::'+sr.getId()); 
                    outMap.put('AccountId', sr.getId());
                }
                //insert businessAccount;
            }
        }catch(Exception ex){
            outMap.put('errorMessage',ex.getMessage());
            ARTL_Logger.error(ARTL_Constants.CONTROLLER, 'ARTL_FindDuplicate:insertAccount', '', new Map<String,Object>{'Exception'=>ex.getMessage() , 'LineNumber' => ex.getLineNumber()}, ex);
        }
    }
    
    public static Account createAccountInstance(Map<String, Object> input){
        Account businessAccount 	= new Account();
        Id businessAccRecordTypeId 	= Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business')?.getRecordTypeId();
        String userId 				= input.containsKey('userId') ? String.valueOf(input.get('userId')): UserInfo.getUserId();
        Id tlUserId 				= [SELECT Id,ManagerId FROM User WHERE Id=:userId ]?.ManagerId;
        
        if(input.containsKey('AccountName')){
            Map<String,Object> accountDetails				= new Map<String,Object>();
            accountDetails									= (Map<String,Object>)input.get('AccountDetails');
            businessAccount.Name 							= String.valueOf(input.get('AccountName'));
            businessAccount.RecordTypeId 					= businessAccRecordTypeId;
            businessAccount.Phone							= accountDetails.containsKey('Phone') ? String.valueOf(accountDetails.get('Phone')) : null;
            businessAccount.Website							= accountDetails.containsKey('Website') ? String.valueOf(accountDetails.get('Website')) : '';
            businessAccount.ARTL_CO_Care_Of__c 				= accountDetails.containsKey('CareOf') ? String.valueOf(accountDetails.get('CareOf')) : '';
            businessAccount.ARTL_Identification_Type__c 	= accountDetails.containsKey('IdentificationType') ? String.valueOf(accountDetails.get('IdentificationType')) : '';
            businessAccount.ARTL_PAN__c						= accountDetails.containsKey('PAN') ? String.valueOf(accountDetails.get('PAN')) : '';
            businessAccount.ARTL_TAN__c						= accountDetails.containsKey('TAN') ? String.valueOf(accountDetails.get('TAN')) : '';
            businessAccount.ARTL_Category__c				= accountDetails.containsKey('Category') ? String.valueOf(accountDetails.get('Category')) : '';
            businessAccount.ARTL_Customer_Segment__c 		= accountDetails.containsKey('CustomerSegment') ? String.valueOf(accountDetails.get('CustomerSegment')) : '';
            businessAccount.ARTL_Business_Circle_Region__c 	= accountDetails.containsKey('BusinessCircleRegion') ? String.valueOf(accountDetails.get('BusinessCircleRegion')) : '';
            businessAccount.ARTL_Service_Segment__c 		= accountDetails.containsKey('ServiceSegment') ? String.valueOf(accountDetails.get('ServiceSegment')) : '';
            businessAccount.ARTL_Vertical_Segment__c 		= accountDetails.containsKey('VerticalSegment') ? String.valueOf(accountDetails.get('VerticalSegment')) : '';
            businessAccount.ARTL_Country_Code__c			= accountDetails.containsKey('CountryCode') ? String.valueOf(accountDetails.get('CountryCode')) : '';
            businessAccount.ARTL_TL__c						= String.isNotBlank(tlUserId) ? tlUserId : null;
            businessAccount.ARTL_IsPANVerified__c 			= input.containsKey('IsPanNumberVerified') ? Boolean.valueOf(input.get('IsPanNumberVerified')) : false;
            
            Map<String,Object> address 						= new Map<String,Object>();
            address 										= (Map<String,Object>)accountDetails.get('TApincode-Block');
            businessAccount.ARTL_Billing_Pincode__c 		= address.containsKey('pincodeId') ? String.valueOf(address.get('pincodeId')) : null;
            
            if(address.containsKey('pincodeId') && address.get('pincodeId') != null){
                businessAccount.BillingCity 				= address.containsKey('city') ? String.valueOf(address.get('city')) : '';
                businessAccount.BillingCountry				= address.containsKey('country') ? String.valueOf(address.get('country')) : '';
                businessAccount.BillingPostalCode			= address.containsKey('pincode') ? String.valueOf(address.get('pincode')) : '';
                businessAccount.BillingState				= address.containsKey('state') ? String.valueOf(address.get('state')) : '';
                businessAccount.BillingStreet				= address.containsKey('street') ? String.valueOf(address.get('street')) : '';
            }
        }
        return businessAccount;
    }    
    
    public static void insertLead(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){
        try{
            Lead businessLead = createLeadInstance(input);
        	if(businessLead != null){
            	Database.DMLOptions dml = new Database.DMLOptions();
                dml.DuplicateRuleHeader.AllowSave = true; 
                
                Database.SaveResult sr = Database.insert(businessLead, dml); 
                if (sr.isSuccess()) { 
                    System.debug('Lead inserted::'+sr.getId()); 
                    outMap.put('LeadId', sr.getId());
                }
                //insert businessAccount;
            }
        }catch(Exception ex){
            outMap.put('errorMessage',ex.getMessage());
            ARTL_Logger.error(ARTL_Constants.CONTROLLER, 'ARTL_FindDuplicate:insertLead', '', new Map<String,Object>{'Exception'=>ex.getMessage() , 'LineNumber' => ex.getLineNumber()}, ex);
        }
    }
    
    public static Lead createLeadInstance(Map<String, Object> input){
        Lead businessLead 	= new Lead();
        if(input.containsKey('LeadCreation') && input.get('LeadCreation') != null){
            Map<String,Object> leadDetails					= new Map<String,Object>();
            leadDetails										= (Map<String,Object>)input.get('LeadCreation');
            businessLead.Salutation							= String.valueOf(leadDetails.get('Salutation'));
            businessLead.FirstName 							= String.valueOf(leadDetails.get('FirstName'));
            businessLead.LastName 							= String.valueOf(leadDetails.get('LastName'));
            businessLead.Title 								= String.valueOf(leadDetails.get('Title'));
            businessLead.Phone  							= String.valueOf(leadDetails.get('Phone'));
            businessLead.Country_Code__c 					= String.valueOf(leadDetails.get('CountryCode'));
            businessLead.Email								= String.valueOf(leadDetails.get('Email'));
            businessLead.Related_Account__c 				= input.containsKey('AccountId') && String.valueOf(input.get('AccountId')) != null ? String.valueOf(input.get('AccountId')) : null;
            businessLead.Related_Contact__c 				= input.containsKey('ContactId') && String.isNotBlank(String.valueOf(input.get('ContactId'))) && String.valueOf(input.get('ContactId')) != 'null' ? String.valueOf(input.get('ContactId')) : null;
            businessLead.Company  							= input.containsKey('company') && String.valueOf(input.get('company')) != 'null' ? String.valueOf(input.get('company')) : '';
            businessLead.Segment__c  						= input.containsKey('Segment') && String.isNotBlank(String.valueOf(input.get('Segment'))) && String.valueOf(input.get('Segment')) != 'null'? String.valueOf(input.get('Segment')) : '';
            businessLead.NumberOfEmployees 					= input.containsKey('NoOfEmployees') && String.isNotBlank(String.valueOf(input.get('NoOfEmployees'))) && String.valueOf(input.get('NoOfEmployees')) != 'null' ? Integer.valueOf(input.get('NoOfEmployees')) : null;
            businessLead.AnnualRevenue						= input.containsKey('AnnualRevenue') && String.isNotBlank(String.valueOf(input.get('AnnualRevenue'))) && String.valueOf(input.get('AnnualRevenue')) != 'null' ? Decimal.valueOf(String.valueOf(input.get('AnnualRevenue'))) : null;
            businessLead.Website 							= leadDetails.containsKey('Website') && leadDetails.get('Website') != null ? String.valueOf(leadDetails.get('Website')) : '';
            businessLead.Campaign__c  						= String.valueOf(leadDetails.get('Campaign'));
            businessLead.ARC__c 							= Decimal.valueOf(String.valueOf(leadDetails.get('ARC')));
            businessLead.vlocity_cmt__NumberofLocations__c 	= leadDetails.containsKey('NumberofLocations') ? Integer.valueOf(leadDetails.get('NumberofLocations')) : null;
            businessLead.Description						= String.valueOf(leadDetails.get('Description'));
            businessLead.Lead_Action_Remarks__c 			= String.valueOf(leadDetails.get('LeadActionRemarks'));
            businessLead.Product_Interest__c				= leadDetails.containsKey('ProductInterest') ? String.valueOf(leadDetails.get('ProductInterest')) : null;
            businessLead.LeadSource							= input.containsKey('leadSourceFormula') && input.get('leadSourceFormula') != null ? String.valueOf(input.get('leadSourceFormula')) : '';
        }
        return businessLead;
    }  
}