@isTest(SeeAllData=false)
private class ATB2BCmexApplyFrameContractPricingTest
{

    @TestSetup
    static void makeData()
    {
        ARTL_TestDataFactory.createTriggerSetup();
        ARTL_TestDataFactory.setupData();
        ARTL_TestDataFactory.createCPQConfiguration('PricingPlanHelperLogging','True');
    }

    @isTest
    static void testInvokeMethod() 
    {
        Test.startTest();

        Quote quoteHeader = [SELECT Id, AccountId FROM Quote WHERE Name = 'Test Quote'];
        
        string quoteId = quoteHeader.Id;
        
        String qliObjectName = 'QuoteLineItem';
        List<String> qliFields = vlocity_cmt.DBHelper.getFields(qliObjectName);
        qliFields.add('PricebookEntry.Product2Id');
        
        String soql = 'Select ' + String.join(qliFields, ',') +' From ' + String.escapeSingleQuotes(qliObjectName.deleteWhiteSpace());
        String condition = ' WHERE QuoteId= :quoteId Order by vlocity_cmt__LineNumber__c ASC';
        
        
        List<QuoteLineItem> lineItems = Database.query(soql + condition);
    
    
        ATB2BCmexApplyFrameContractPricing  frameContractInstance = new ATB2BCmexApplyFrameContractPricing();
        
        Map<String, Object> inputMap  = new Map<String, Object>();
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> optionMap = new Map<String, Object>();
             
        vlocity_cmt.PricingPlanService.putInPricingContext('Parent', quoteHeader);
        vlocity_cmt.PricingPlanService.putInPricingContext('LineItemList', lineItems);

        Boolean result = frameContractInstance.invokeMethod('priceItems', inputMap, outputMap, optionMap);

        Test.stopTest();

        System.assertEquals(false, result);
    }

    @isTest
    static void testCallMethod()
    {
        Test.startTest();

        Quote quoteHeader = [SELECT Id, AccountId FROM Quote WHERE Name = 'Test Quote'];
        
        string quoteId = quoteHeader.Id;
        
        String qliObjectName = 'QuoteLineItem';
        List<String> qliFields = vlocity_cmt.DBHelper.getFields(qliObjectName);
        qliFields.add('PricebookEntry.Product2Id');
        
        String soql = 'Select ' + String.join(qliFields, ',') +' From ' + String.escapeSingleQuotes(qliObjectName.deleteWhiteSpace());
        String condition = ' WHERE QuoteId= :quoteId Order by vlocity_cmt__LineNumber__c ASC';
        
        
        List<QuoteLineItem> lineItems = Database.query(soql + condition);
    
    
        ATB2BCmexApplyFrameContractPricing  frameContractInstance = new ATB2BCmexApplyFrameContractPricing ();
        
        Map<String, Object> inputMap  = new Map<String, Object>();
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> optionMap = new Map<String, Object>();
        Map<String, Object> args = new Map<String, Object>
        {
            'input' => inputMap,
            'output' => outputMap,
            'options' => optionMap
        };
             
        vlocity_cmt.PricingPlanService.putInPricingContext('Parent', quoteHeader);
        vlocity_cmt.PricingPlanService.putInPricingContext('LineItemList', lineItems);

        Boolean result = frameContractInstance.call('priceItems', args);

        Test.stopTest();
        
        System.assertEquals(false, result);
    }
}