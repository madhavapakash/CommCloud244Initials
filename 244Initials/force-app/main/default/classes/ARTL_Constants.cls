/******************************************************************************************************
* @Author       : Ishita Khare <ikhare@salesforce.com>
* @Company      : Salesforce (SFI)
* @Date         : 15/09/2023
* @Description  : This is class contains the constant values / variables used in Apex Classes.
*dev1
* ----------------------- Changes Implemented / Modification Log --------------------------------------
* UserStory / Defect      Developer             Date           Comment
* ---------               Ishita Khare          15/09/2023      Initial Dev
*******************************************************************************************************/
public without sharing class ARTL_Constants {
    public static final String CONTROLLER 									= 'Controller';
    public static final Integer MAX_LONG_TEXT_AREA_SIZE 					= 32768;
    
    //Contact Status Picklist Values
    public static final String CONTACT_STATUS_INACTIVE 						= 'Inactive';
    public static final String CONTACT_STATUS_EMAIL_VERIFICATION_PENDING 	= 'Email Verification Pending';
    public static final String CONTACT_STATUS_EMAIL_VERIFIED				= 'Email Verified';
    public static final String CONTACT_STATUS_OTP_VERIFICATION_PENDING 		= 'OTP Verification Pending';
    public static final String CONTACT_STATUS_OTP_VERIFIED 					= 'OTP Verified';
    public static final String CONTACT_STATUS_ID_VERIFICATION_PENDING 		= 'ID Verification Pending';
    public static final String CONTACT_STATUS_ACTIVE 						= 'Active';
}