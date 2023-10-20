/************************************************************************************************************************************************************************************************************
* @Author       : Ishita Khare <ikhare@salesforce.com>
* @Company      : Salesforce (SFI)
* @Date         : 13/09/2023
* @Test Class   : 
* @Description  : Handles webhook events and call respective handlers.
*
* ----------------------- Changes Implemented / Modification Log --------------------------------------
* UserStory / Defect      Developer             Date           Comment
* ------------------      ---------------       -----------    ----------------------------------------
* 1. SFDC-204              Ishita Khare          13/09/2023     Initial Dev
******************************************************************************************************************************************************************************************************************/
global without sharing class ARTL_CalloutEventHandler implements vlocity_cmt.VlocityOpenInterface {
    private static String PROCESS_NAME          = 'processName';
    private static String RECORD_ID             = 'ContextId';
    private static String REQUEST_NODE          = 'request';
    private static String RESPONSE_NODE         = 'response';
    private static String ENDPOINT_URL          = 'endpoint';
    private static String REQUEST_METHOD        = 'requestMethod';
    private static String NAMED_CREDENTIALS     = 'namedCredentials';
    private static String API_KEY     			= 'apiKey';
    private static String ERROR                 = 'error';
    private static String ASYNC_PATTERN         = 'Async';
    
    global Boolean invokeMethod(String methodName, Map<String,Object> input, Map<String,Object> outMap, Map<String,Object> options){
        try{
            if(methodName.equals('initiateCallout')){
                runIntegrationProcedure(input, outMap, options);
                return true;
            }else if(methodName.equals('createlog')){
                createlog(input, outMap, options);
            }
        }catch(Exception ex){
            ARTL_Logger.error(ARTL_Constants.CONTROLLER, 'ARTL_CalloutEventHandler:initiateCallout', '', new Map<String,Object>{'Exception'=>ex.getMessage() , 'LineNumber' => ex.getLineNumber()}, ex);
        }
        return false;
    }
    
    public static void runIntegrationProcedure(Map < String, Object > input, Map < String, Object > outMap, Map < String, Object > options){
        System.debug('input::'+input);
        try{
            String processName  = input.containsKey(PROCESS_NAME) && input.get(PROCESS_NAME) != null ? String.valueOf(input.get(PROCESS_NAME)): '';
            //String recordId     = input.containsKey(RECORD_ID) && input.get(RECORD_ID) != null ? String.valueOf(input.get(RECORD_ID)): '';
            //String request = ''; String response = '';
            
            if(String.isNotBlank(processName)){
                //Query Config Table to get the Enpoint URL, Credentail Details, Number of Retry, Apex, IP and DR
                CalloutConfigWrapper calloutConfig          = fetchConfigDetails(processName);
                
                //Prepare the request Payload for Callout
                if(calloutConfig != null){
                    System.debug('calloutConfig:'+calloutConfig);
                    // if(String.isNotBlank(calloutConfig.requestDR)){
                    //     vlocity_cmt.DRProcessResult result  = vlocity_cmt.DRGlobal.processObjectsJSON(JSON.serialize(new Map<String, Object>{'ContextId'=>recordId}), calloutConfig.requestDR);
                    //     Map<String, Object> resultMap       = result.convertToMap();
                    //     request                             = JSON.serialize(resultMap.get('returnResultsData'));
                    // }
                    
                    //Invoke the Integration Procedure for Callout
                    Map<String,Object> ipOutput = new Map<String,Object>();
                    
                    //ipInput.put(REQUEST_METHOD,calloutConfig.requestMethod);
                    //ipInput.put(REQUEST_NODE,request);
                    //ipInput.put('ContextId',recordId);
                    
                    input.put(ENDPOINT_URL,calloutConfig.endpointURL);
                    input.put(NAMED_CREDENTIALS,calloutConfig.namedCreds);
                    if(String.isNotBlank(calloutConfig.apiKey)){
                        input.put(API_KEY,calloutConfig.apiKey);
                    }
                    
                    System.debug('calloutConfig.ipName::'+calloutConfig.ipName);
                    ipOutput = (Map<String, Object>)vlocity_cmt.IntegrationProcedureService.runIntegrationService(calloutConfig.ipName, input, null);
                    
                    // if(ipOutput != null && String.isNotBlank(calloutConfig.responseDR)){
                    //     vlocity_cmt.DRProcessResult result  = vlocity_cmt.DRGlobal.processObjectsJSON(JSON.serialize(ipOutput), calloutConfig.responseDR);
                    //     Map<String, Object> resultMap       = result.convertToMap();
                    //     response                            = JSON.serialize(resultMap.get('returnResultsData'));
                    // }
                    System.debug('ipOutput::'+ipOutput);
                    ARTL_Logger.debug(ARTL_Constants.CONTROLLER, 'ARTL_CalloutEventHandler:runIntegrationProcedure', '', new Map<String,Object>{'IP Input'=>input , 'IP Output' => ipOutput});
                    //Retry mechanism in case of error
                    if(ipOutput.get(ERROR) != null && calloutConfig.pattern == ASYNC_PATTERN){
                        Integer i = 0; //set start count to 0
                        while(i < calloutConfig.retryCount){
                            ARTL_CalloutEventHandler.IntegrationProcedureQueueable ipq = new ARTL_CalloutEventHandler.IntegrationProcedureQueueable(input, outMap, options);
                            System.enqueueJob(ipq);
                        }   
                    }
                    outMap.put(RESPONSE_NODE,ipOutput);
                }
            }else{
                ARTL_Logger.error(ARTL_Constants.CONTROLLER, 'ARTL_CalloutEventHandler:runIntegrationProcedure', '','', new Map<String,Object>{'Error'=>'No Process name defined.'});
            }
        }catch(Exception ex){
            ARTL_Logger.error(ARTL_Constants.CONTROLLER, 'ARTL_CalloutEventHandler:runIntegrationProcedure', '', new Map<String,Object>{'Exception'=>ex.getMessage() , 'LineNumber' => ex.getLineNumber()}, ex);
        } 
    }
    
    public static void createlog(Map < String, Object > input, Map < String, Object > outMap, Map < String, Object > options){
        System.debug('log input::'+input);
        System.debug('log output::'+outMap);
        if(input.containsKey('request')){
            ARTL_Logger.debug(ARTL_Constants.CONTROLLER, 'ARTL_CalloutEventHandler:createlog', '', new Map<String,Object>{'request'=>input.get('request')});
        }
        if(input.containsKey('response')){
            ARTL_Logger.debug(ARTL_Constants.CONTROLLER, 'ARTL_CalloutEventHandler:createlog', '', new Map<String,Object>{'response'=>input.get('response')});
        }
        if(input.containsKey('error')){
            String source = input.containsKey('source') ? 'Exception from: '+String.valueOf(input.get('source')) : '';
            ARTL_Logger.error(ARTL_Constants.CONTROLLER, 'ARTL_CalloutEventHandler:createlog', source , String.valueOf(new Map<String,Object>{'request'=>input.get('request') ,'Exception'=>input.get('error')}) , new Map<String,Object>());
        }
    }
    
    public static CalloutConfigWrapper fetchConfigDetails(String processName){
        CalloutConfigWrapper configObj = new CalloutConfigWrapper();
        
        for(ARTL_Callout_Event_Configs__mdt configRecord : [SELECT ARTL_Type__c, ARTL_API_Key__c ,ARTL_EndPointURL__c,ARTL_IntegrationProcedureName__c,ARTL_NameCredentials__c,ARTL_Operation__c,ARTL_Pattern__c,ARTL_Retry__c FROM ARTL_Callout_Event_Configs__mdt WHERE MasterLabel =:processName LIMIT 1]){
            configObj.calloutType       = configRecord.ARTL_Type__c;
            //configObj.apexClassName     = configRecord.ARTL_Apex_Class__c;
            //configObj.apexMethodName    = configRecord.ARTL_Method_Name__c;
            configObj.endpointURL       = configRecord.ARTL_EndPointURL__c;
            configObj.ipName            = configRecord.ARTL_IntegrationProcedureName__c;
            configObj.namedCreds        = configRecord.ARTL_NameCredentials__c;
            configObj.requestMethod     = configRecord.ARTL_Operation__c;
            configObj.pattern           = configRecord.ARTL_Pattern__c;
            //configObj.requestDR         = configRecord.ARTL_RequestDR__c;
            //configObj.responseDR        = configRecord.ARTL_ResponseDR__c;
            configObj.retryCount        = Integer.valueOf(configRecord.ARTL_Retry__c);
            configObj.apiKey        	= configRecord.ARTL_API_Key__c;
        }
        
        return configObj;
    }
    
    global class CalloutConfigWrapper{
        global String calloutType;
        //global String apexClassName;
        //global String apexMethodName;
        global String endpointURL;
        global String ipName;
        global String namedCreds;
        global String requestMethod;
        global String pattern;
        //global String requestDR;
        //global String responseDR;
        global Integer retryCount;
        global String apiKey;
    }
    
    global without sharing class IntegrationProcedureQueueable implements Queueable, Database.AllowsCallouts {
        Map<String, Object> input;
        Map<String, Object> options;
        Map<String, Object> output;
        
        public IntegrationProcedureQueueable(Map<String, Object> input,Map<String, Object> output, Map<String, Object> options) {
            this.input = input;
            this.output = output;
            this.options = options;
        }
        
        public void execute(QueueableContext context) {
            input.put('asyncApexJobId', context.getJobId());
            ARTL_CalloutEventHandler.runIntegrationProcedure(input, output, options);
        }
    }
}