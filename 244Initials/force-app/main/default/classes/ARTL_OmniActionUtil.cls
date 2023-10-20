global with sharing class ARTL_OmniActionUtil implements Callable {

    global Object call(String action, Map<String,Object> args) {
      Map<String,Object> input = (Map<String,Object>) args.get('input');
      Map<String,Object> output = (Map<String,Object>)args.get('output');
      Map<String, Object> options = (Map<String,Object>) args.get('options');
  
      return invokeMethod(action, input, output, options);
    }
    
    global Boolean invokeMethod (String methodName, Map<String, Object> input,Map<String, Object> output,Map<String, Object> options ) {
        system.debug('inside invoke method');
        if (methodName == 'logInfo') logInfo(input, output, options);
        if (methodName == 'logError') logError(input, output, options);
        if (methodName == 'logDebug') logDebug(input, output, options);
        return true;
    }
  
    /**
    * @ description :  This method calls the logger class. Since the logger class can't be directly called from IP
    *                 to log the IP transaction this method can be invoked from IP.   
    */
    private void logInfo(Map<String, Object> input, Map<String, Object> output, Map<String, Object> options) {
      String type = input.containskey('type') ? String.valueOf(input.get('type')) : '';
      String name = input.containskey('name') ? String.valueOf(input.get('name')) : '';
      String message = input.containskey('message') ? String.valueOf(input.get('message')) : '' ;
      String logData = input.containskey('logData') ? JSON.serialize(input.get('logData')) : '' ;
      ARTL_Logger.info(type, name, message, logData);
    }
    
  /**
  * @ description :  This method calls the logger class. Since the logger class can't be directly called from IP
  *                 to log the IP transaction this method can be invoked from IP.   
  */
    private void logError(Map<String, Object> input, Map<String, Object> output, Map<String, Object> options) {
      String type = input.containskey('type') ? String.valueOf(input.get('type')) : '';
      String name = input.containskey('name') ? String.valueOf(input.get('name')) : '';
      String message = input.containskey('message') ? String.valueOf(input.get('message')) : '' ;
      String logData = input.containskey('logData') ? JSON.serialize(input.get('logData')) : '' ;
      String errorMessage = input.containskey('errorMessage') ? JSON.serialize(input.get('errorMessage')) : '';
      ARTL_Logger.error(type, name, message, logData,errorMessage );
    }
    
    /**
  * @ description :  This method calls the logger class. Since the logger class can't be directly called from IP
  *                 to log the IP transaction this method can be invoked from IP.  
  */
    private void logDebug(Map<String, Object> input, Map<String, Object> output, Map<String, Object> options) {
      String type = input.containskey('type') ? String.valueOf(input.get('type')) : '';
      String name = input.containskey('name') ? String.valueOf(input.get('name')) : '';
      String message = input.containskey('message') ? String.valueOf(input.get('message')) : '' ;
      String logData = input.containskey('logData') ? JSON.serialize(input.get('logData')) : '' ;
      ARTL_Logger.debug(type, name, message, logData );
    }
}