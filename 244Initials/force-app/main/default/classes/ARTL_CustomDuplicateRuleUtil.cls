public without sharing class ARTL_CustomDuplicateRuleUtil {
    public static List<sObject> findDuplicateRecords(sObject objRecord){
        List<sObject> sObjectList = new List<sObject>();
        List<sObject> duplicates = new List<sObject>();
        sObjectList.add(objRecord);
        try{
            List<Datacloud.FindDuplicatesResult > findDuplicatesResult = new List<Datacloud.FindDuplicatesResult >();
            findDuplicatesResult = Datacloud.FindDuplicates.findDuplicates(sObjectList);
            if(!findDuplicatesResult.isEmpty()){
                Datacloud.DuplicateResult duplicateResult 	= findDuplicatesResult.get(0).getDuplicateResults()?.get(0);
                Datacloud.MatchResult matchResult 			= duplicateResult?.getMatchResults()[0];
                List<Datacloud.MatchRecord> matchRecords 	= matchResult?.getMatchRecords();
                
                
                for(Datacloud.MatchRecord matchRecord : matchRecords){
                    sObject duplicate = matchRecord.getRecord();
                    System.debug('Match Record: ' + duplicate);
                    duplicates.add(duplicate);
                }
                
            }
        }catch(Exception ex){
            ARTL_Logger.error(ARTL_Constants.CONTROLLER, 'ARTL_CustomDuplicateRuleUtil:findDuplicateRecords', '', new Map<String,Object>{'Exception'=>ex.getMessage() , 'LineNumber' => ex.getLineNumber()}, ex);
        }
        return duplicates;
    }
}