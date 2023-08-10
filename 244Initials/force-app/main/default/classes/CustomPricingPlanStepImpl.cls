global with sharing class CustomPricingPlanStepImpl implements vlocity_cmt.VlocityOpenInterface, callable 
{

    private static String nsp = 'vlocity_cmt__';

    global Boolean invokeMethod (String methodName,
                                 Map<String, Object> input,
                                 Map<String, Object> output,
                                 Map<String, Object> options)
    {
        
        
        if (methodName == 'GetMatrixPrice')
        {
            getMatrixPrice(input, output, options);
        }
        else if(methodName == 'getRefreshOnlyPassedLineItems')
        {
            getRefreshOnlyPassedLineItems(input, output, options);
        }

        return true;
    }
    
    public Object call(String action, Map<String, Object> args) 
    {
        Map<String,Object> inputMap = (Map<String,Object>)args.get('input');
        Map<String,Object> outputMap = (Map<String,Object>)args.get('output');
        Map<String,Object> options = (Map<String,Object>)args.get('options');
        
        return invokeMethod(action, inputMap, outputMap, options);
    }

    private void getMatrixPrice(Map<String, Object> input,
                                Map<String, Object> output,
                                Map<String, Object> options)
    {
        SObject parent = (SObject)vlocity_cmt.PricingPlanService.getFromPricingContext('Parent');
        if(input.get('RunOnlyForRecordTypes') != NULL && parent.get('RecordTypeId') != NULL)
        {
            List<String> recordTypesNames = new List<String>();
            for(Object recordTypeName : (List<Object>) input.get('RunOnlyForRecordTypes'))
            {
                recordTypesNames.add((String) recordTypeName);
            }
            Id parentRecordTypeId = (Id) parent.get('RecordTypeId');
            String parentSObjectType = String.valueof(parent.getSObjectType());
            List<RecordType> matchedRecordType = [SELECT Id, Name from RecordType WHERE SObjectType =: parentSObjectType AND Name IN: recordTypesNames AND Id =: parentRecordTypeId];
            //Skip the step silently as it is not meant to run for passed parent recordtype.
            if(matchedRecordType.isEmpty())
            {
                return;
            }
        }
        
        List<SObject> itemList = (List<SObject>)vlocity_cmt.PricingPlanService.getFromPricingContext('LineItemList');

        //If Asset or if there are no items, then return
        if(parent == null || itemList == null || itemList.isEmpty()) return;

        String sourceTargetABP = (String)input.get('SourceTargetABP');
        boolean runForPassedItemListContext = false;
        if(input.get('RunForPassedItemListContext') != NULL)
        {
            runForPassedItemListContext = (boolean) input.get('RunForPassedItemListContext');
        }
        
        String strDelta = PricingPlanHelper.getCpqConfigurationSetupValue('DeltaPrice');

        //CMT-3332 : If Delta Price is TRUE and if source target attribute based pricing is being done, then load all the line items
        if(strDelta.equalsIgnoreCase('True') && sourceTargetABP != NULL && sourceTargetABP.equalsIgnoreCase('True') && !runForPassedItemListContext)
        {
            itemList = getAllLineItems(parent, parent.getSObjectType(), itemList[0].getSObjectType());
            vlocity_cmt.PricingPlanService.putInPricingContext('LineItemList',itemList);
        } 
        else if(runForPassedItemListContext)
        {
            Map<String,Object> inputMap = new Map<String, Object>();
            Map<String,Object> outputMap = new Map<String, Object>();
            Map<String,Object> optionMap = new Map<String, Object>();
            
            //itemList = getRefreshOnlyPassedLineItems(itemList, itemList[0].getSObjectType());
            inputMap.put('lineItems', itemList);
            inputMap.put('lineItemTypeForPage', itemList[0].getSObjectType());
            getRefreshOnlyPassedLineItems(inputMap, outputMap, optionMap);
            
            itemList = (List<Sobject>) outputMap.get('lineItems');
            vlocity_cmt.PricingPlanService.putInPricingContext('LineItemList',itemList);
        }

        // If this is the first getMatrixPrice step, clear the external price flag
        Boolean clearExternalPriceFlag = (Boolean)vlocity_cmt.PricingPlanService.getFromPricingContext('ClearExternalPriceFlag');
        if (clearExternalPriceFlag == null )
        {
            clearExternalPriceFlag = true;
            // Do not clear the external price flag for subsequent calls to getMatrixPrice
            vlocity_cmt.PricingPlanService.putInPricingContext('ClearExternalPriceFlag', false);
        }

        Map<String, object> priceHelperInput = new Map<String, object>();
        Map<String, object> priceHelperOutput = new Map<String, object>();
        Map<String, object> priceHelperOptions = new Map<String, object>();
        priceHelperInput.put('Parent', parent);
        priceHelperInput.put('ItemList', itemList);
        priceHelperInput.put('ClearExternalPriceFlag', clearExternalPriceFlag);
        priceHelperInput.putAll(input);

        // create the matrix input rows from the itemList
        PricingPlanHelper priceHelper = new PricingPlanHelper();
        
        Map<String, Object> agrs = new Map<String, Object>();
        agrs.put('input',priceHelperInput);
        agrs.put('output',priceHelperOutput);
        agrs.put('options',priceHelperOptions);
        
        priceHelper.call('GetCalculationProcedurePrice', agrs);
        //priceHelper.invokeMethod('GetCalculationProcedurePrice', priceHelperInput, priceHelperOutput, priceHelperOptions);

        if (priceHelperOutput.get('error') != null)
        {
            output.put('error', priceHelperOutput.get('error'));
        }
    }

    //Querying all the dat
    private List<SObject> getAllLineItems(SObject parent, SobjectType parentObjectTypeForPage, SObjectType lineItemTypeForPage)
    {
        Id parentId = (Id)parent.get('Id');
        String query = getSelectClauseForLIQuery(lineItemTypeForPage) + 
                ' FROM ' + lineItemTypeForPage + ' WHERE ' + parentObjectTypeForPage + 'Id = \'' + parentId + '\'';
        return Database.query(query);
    }
    
    
    //Querying only passed line item in context
    private void getRefreshOnlyPassedLineItems(Map<String, Object> inputMap, Map<String, Object> outputMap, Map<String, Object> optionMap)
    {
        List<SObject> lineItems = (List<SObject>) inputMap.get('lineItems');
        SObjectType lineItemTypeForPage = (SObjectType) inputMap.get('lineItemTypeForPage');
        
        Set<Id> itemids = (new Map<Id,SObject>(lineItems)).keySet();
        String query = getSelectClauseForLIQuery(lineItemTypeForPage) +
                ' FROM ' + lineItemTypeForPage + ' WHERE Id IN : itemids';
        outputMap.put('lineItems' , Database.query(query));
    }
    
    private String getSelectClauseForLIQuery(SObjectType lineItemTypeForPage)
    {
        String selectClause = 'Select Id, ' + nsp + 'LineNumber__c, PriceBookEntry.Product2.Name, PriceBookEntry.Product2.ProductCode, PriceBookEntry.Product2.'+ nsp +'AttributeMetadata__c, Product2.'+ nsp +'AttributeMetadata__c, PriceBookEntry.Product2.Id,' +
            'PriceBookEntry.Product2.' + nsp + 'Type__c, PriceBookEntryId, PriceBookEntry.Pricebook2Id, ListPrice, UnitPrice, Quantity,' +
            'PriceBookEntry.Product2.' + nsp + 'JSONAttribute__c,' + nsp + 'jsonattribute__c,' + nsp + 'OneTimeCharge__c, ' +
            nsp + 'JSONNode__c, ' + nsp + 'PricingLogData__c, ' + nsp + 'Query__c, '  + nsp + 'Filter__c, ' + nsp + 'OneTimeCalculatedPrice__c,' +
            nsp + 'OneTimeManualDiscount__c, ' + nsp + 'OneTimeTotal__c, ' + nsp + 'ProductHierarchyPath__c, ' + nsp + 'RecurringCharge__c,' +
            nsp + 'RecurringCalculatedPrice__c, ' + nsp + 'RecurringManualDiscount__c, ' + nsp + 'RecurringDiscountPrice__c, ' + nsp + 'RecurringTotal__c,' +
            nsp + 'RootItemId__c, ' + nsp + 'ParentItemId__c, ' + nsp + 'CpqMessageData__c, ' + nsp + 'CurrencyPaymentMode__c,' +
            nsp + 'CpqCardinalityMessage__c, ' + nsp + 'ProvisioningStatus__c, ' + nsp + 'ServiceAccountId__r.Name, ' + nsp + 'ServiceAccountId__r.Id,' +
            nsp + 'BillingAccountId__r.Name, ' + nsp + 'BillingAccountId__r.Id, ' + nsp + 'Action__c, ' + nsp + 'SubAction__c, ' 
            + 'Product2.' + nsp +'GlobalKey__c, ' +  'Product2.' + nsp +'CategoryData__c, ' +
            + 'PriceBookEntry.Product2.' + nsp +'GlobalGroupKey__c, ' +
            + nsp + 'AttributeSelectedValues__c, ' +
            + 'PriceBookEntry.Product2.' + nsp + 'GlobalKey__c, ' +
            + 'Product2.' + nsp + 'GlobalGroupKey__c ' ;
        if(String.valueof(lineItemTypeForPage) == 'QuoteLineItem')
        {
            selectClause += ( ' ,'+ nsp + 'QuoteMemberId__c ' );
        }
        else if(String.valueof(lineItemTypeForPage) == 'OrderItem')
        {
            selectClause += ( ' ,'+ nsp + 'OrderMemberId__c ' );
        }
        return selectClause;
    }
}