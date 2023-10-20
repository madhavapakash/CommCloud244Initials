/******************************************************************************************************
* @Author       : Ishita Khare <ikhare@salesforce.com>
* @Company      : Salesforce (SFI)
* @Date         : 15/09/2023
* @Test Class   :
* @Description  : Generic Error Framework, The class publishes a platform event and the PR subscriber is a 
*                 flow that maps the PE fields to vlocity_ins__VlocityErrorLogEntry__c object fields and finally 
*                 creates an entry into the object.
*
* ----------------------- Changes Implemented / Modification Log --------------------------------------
* UserStory / Defect      Developer             Date           Comment
* ------------------      ---------------       -----------    ----------------------------------------
* 1. SFDC-204             Ishita Khare          15/09/2023     Initial Dev
*******************************************************************************************************/
public without sharing class ARTL_Logger {
    /**
  * @ description :  This is the info method can be invoked from any apex class to log info into the 
  *                 vlocity_ins__VlocityErrorLogEntry__c about any the transaction like Req, Res etc.   
  * @ param       : type = "Apex"
                    name = "Name of the class", the method name can also be provided with colon separated.
                    message = any extra message/ info apart from the logdata.
                    logData = The data actually needs to be logged.
  *   THIS METHOD IS USED FOR LOGGING THE APEX CLASS TRX.  */
  public static void info( String type, String name, String message, Map<String, Object> logData) {
    String dataStr = JSON.serialize(logData);
    logEvent(type, name, message, LoggingLevel.INFO, dataStr, null, null);
  }
  /**
  * @ description :  This method logs the data into log object.
  * @ param       :  type = "Integration Procedure", "Omniscript", "Dataraptor"
                     name = "Name of the process"
                     message = any extra message/ info apart from the logdata.
                     logData = The data actually needs to be logged.
  *   THIS METHOD IS USED FOR LOGGING THE IP  TRX. */
  public static void info( String type, String name, String message, String logData) {
    system.debug('inside logger..info');
    logEvent(type, name, message, LoggingLevel.INFO, logData, null, null);
  }
  /**
  * @ description :  This method logs the data into log object.
  * @ param       :  type = "ARTL_Constans.CONTROLLER"
                    name = "Name of the process"
                    message = any extra message/ info apart from the logdata.
                    logData = The data actually needs to be debugged like request, response etc
  *   THIS METHOD IS USED FOR LOGGING FROM APEX  
  */
  public static void debug(String type, String name, String message, Map<String,Object> logData) {
    String dataStr = JSON.serialize(logData);
    
    logEvent(type, name, message, LoggingLevel.DEBUG, dataStr, null, null);
  }
  /**
  * @ description :  This method logs the data into log object.
  *   THIS IS FOR IP TRx
  */
  public static void debug(String type, String name, String message, String logData) {
    logEvent(type, name, message, LoggingLevel.DEBUG, logData, null, null);
  }
  /**
  * @ description :  This method is used for logging the error from APEX class. 
  */
  public static void error(String type, String name, String message, Map<String, Object> logData, Exception objException) {
    String dataStr = JSON.serialize(logData);
    logEvent(type, name, message, LoggingLevel.ERROR, dataStr, objException, null);
  }
  /**
  * @ description :  This method is used for logging the error from IP .  
  */
  public static void error(String type, String name, String message, String logData, Object ExceptionResult) {
    String strExceptionResult = JSON.serialize(ExceptionResult);
    logEvent(type, name, message, LoggingLevel.ERROR, logData, null, strExceptionResult);
  }
  /**
  * @ description :  This is a common method calleed from every method. It checks the maximum size and then invokes emit method to publish PE.
  */
  private static void logEvent(String type, String name, String message, LoggingLevel logLevel, String dataStr, Exception objException, String errorResult ) {
    if(dataStr != null && dataStr.length()> ARTL_Constants.MAX_LONG_TEXT_AREA_SIZE) dataStr = dataStr.subString(0,ARTL_Constants.MAX_LONG_TEXT_AREA_SIZE);
    if(errorResult != null && errorResult.length()> ARTL_Constants.MAX_LONG_TEXT_AREA_SIZE) errorResult = errorResult.subString(0,ARTL_Constants.MAX_LONG_TEXT_AREA_SIZE);
    if(message != null && message.length()> ARTL_Constants.MAX_LONG_TEXT_AREA_SIZE) message = message.subString(0,ARTL_Constants.MAX_LONG_TEXT_AREA_SIZE);

    if (objException != null ){
      String errorStackTrace = objException.getStackTraceString();
      String errorMessage = objException.getMessage();
      if(errorStackTrace != null && errorStackTrace.length()> ARTL_Constants.MAX_LONG_TEXT_AREA_SIZE) errorStackTrace = errorStackTrace.subString(0,ARTL_Constants.MAX_LONG_TEXT_AREA_SIZE);
      if(errorMessage != null && errorMessage.length()> ARTL_Constants.MAX_LONG_TEXT_AREA_SIZE) errorMessage = errorMessage.subString(0,ARTL_Constants.MAX_LONG_TEXT_AREA_SIZE);
      emit( type, name, message, logLevel, dataStr, errorMessage ,errorStackTrace , objException.getLineNumber() );
    }
    else if(String.valueOf(logLevel) == 'ERROR' && errorResult != null){
      emit( type, name, message, logLevel, dataStr, errorResult, null, null);
    } else {
        emit( type, name, message, logLevel, dataStr, null, null,null);
    }
  }
  /**
  * @ description :  The method maps the inputs to the Platform event fields along with the Limit informations.
  */
  private static void emit(
    String type,
    String name,
    String message,
    LoggingLevel logLevel,
    String dataStr,
    String exceptionMessage,
    String stackTrace,
    Integer lineNumber
  ) {
    Map<String, Object> limitInfo = new Map<String, Object> {
      'Quiddity' =>  Request.getCurrent().getQuiddity(),
      /* Limits */
      'Callouts' => Limits.getCallouts(),
      'CpuTime' => Limits.getCpuTime(),
      'DMLRows' => Limits.getDmlRows(),
      'DMLStatements' => Limits.getDmlStatements(),
      'EmailInvocations' => Limits.getEmailInvocations(),
      'FutureCalls' => Limits.getFutureCalls(),
      'HeapSize' => Limits.getHeapSize(),
      'Queries' => Limits.getQueries(),
      'LocatorRows' => Limits.getQueryLocatorRows(),
      'QueryRows' => Limits.getQueryRows(),
      'QueueableJobs' => Limits.getQueueableJobs(),
      'SoslQueries' => Limits.getSoslQueries()
    };
    String strLimitInfo =  JSON.serialize(limitInfo);
    //String strLogLevelLogLevel = getLevelFromId(logLevel);

    ARTL_LogEvent__e  log 	= new ARTL_LogEvent__e(
      User__c 				= UserInfo.getUserId(),
      Context__c 			= Request.getCurrent().getRequestId(),
      Message__c 			= message,
      StackTrace__c 		= stackTrace,
      LineNumber__c 		= lineNumber,
      Level__c 				= String.valueOf(logLevel),
      Limit_Data__c 		= strLimitInfo,
      Type__c 				= type,
      Data__c 				= dataStr,
      Name__c 				= name,
      ErrorMessage__c 		= exceptionMessage
    );
    EventBus.publish(log);
  }
}