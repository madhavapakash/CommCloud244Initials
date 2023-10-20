public with sharing class ARTL_InvocableCalloutEventHandler {
    public static String PROCESS_NAME          = 'processName';
    public static String RECORD_ID             = 'ContextId';
    
    @InvocableMethod(label='Invoke Generic Callout Event Handler')
    public static void initiateCalloutTrigger(List<FlowInput> inputs){
        try{
            for(FlowInput inp: inputs){
                ARTL_CalloutEventHandler obj = new ARTL_CalloutEventHandler();
                obj.invokeMethod('initiateCallout',new Map<String,Object>{PROCESS_NAME => inp.processName , RECORD_ID => inp.recordId},new Map<String,Object>(),new Map<String,Object>());
            } 
        }catch(Exception ex){
            ARTL_Logger.error(ARTL_Constants.CONTROLLER, 'ARTL_InvocableCalloutEventHandler:initiateCalloutTrigger', '', new Map<String,Object>{'Exception'=>ex.getMessage() , 'LineNumber' => ex.getLineNumber()}, ex);
        }
    }
    
    public class FlowInput{
        @InvocableVariable(required=true) public Id recordId;
        @InvocableVariable(required=true) public String processName;
    }
}