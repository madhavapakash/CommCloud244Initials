global class ATB2BCmexApplyFrameContractPricing implements vlocity_cmt.VlocityOpenInterface, Callable
{
   
    private static Boolean isLogging = true;             
    private static String namespacePrefix = 'vlocity_cmt__';
    private static final String sObjectType = 'QuoteLineItem';
    private static List<String> pricingVariableCodes = new List<String>
    {
        'REC_MNTH_STD_PRC',
        'REC_MNTH_STD_PRC_TOTAL',
        'REC_MNTH_STD_PRC_CALC',
        'OT_STD_PRC',
        'OT_STD_PRC_TOTAL',
        'OT_STD_PRC_CALC'
    };
   

    //call method
    global Boolean call(String action, Map<String, Object> args)
    {
        Map<String, Object> inputMap = (Map<String, Object>)args.get('input');
        Map<String, Object> outputMap = (Map<String, Object>)args.get('output');
        Map<String, Object> options = (Map<String, Object>)args.get('options');

        return invokeMethod(action, inputMap, outputMap, options);
    }

    public Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> output, Map<String, Object> options) 
    {
        //LicenseUtility.checkAccessToCustPerm(SERVICE_NAME);
        try
        {         
            System.debug('🚣🏼‍♀️🚣🏼‍♀️🚣🏼‍♀️Calling FrameAgreement Pricing '+methodName);
            if(methodName.equalsIgnoreCase('priceItems')) 
            {
                return priceItems(input, output, options);
            }
            else
            {
                output.put('Error', 'Unsupported method name: ' + methodName);
            }          
        }
        catch (Exception ex)
        {         
            System.debug('Exception thrown at invoke ' + methodName + 'msg--'+ex.getMessage());
            System.debug('Exception trace at invoke ' + ex.getStackTraceString());
            output.put('error', ex.getMessage());
        }      
        return false;
    }
   
    private Boolean priceItems(Map<String, Object> inputMap, Map<String, Object> outputMap, Map<String, Object> optionsMap)
    {
        SObject parent = (SObject) vlocity_cmt.PricingPlanService.getFromPricingContext('Parent');
        List<SObject> itemList = (List<SObject>) vlocity_cmt.PricingPlanService.getFromPricingContext('LineItemList');
       // System.debug('parent-->'+JSON.serializePretty(parent));
        system.debug('Quote Id '+ parent.get('Id'));
       // System.debug('inputMap-->'+JSON.serializePretty(inputMap));
        Quote  currQuote = [Select Id, vlocity_cmt__FrameContractId__c from Quote where Id =: String.valueOf(parent.get('Id'))];
        System.debug('currQuote==='+currQuote);
       
        if (isLogging)
        {
            System.debug('$$$$ in price items method: ' + JSON.serialize(inputMap));
            System.debug('$$$$ outputMap: ' + JSON.serialize(outputMap));
            System.debug('$$$$ parent: ' + JSON.serialize(parent));
            System.debug('$$$$ itemList: ' + JSON.serialize(itemList));   
        }
       
        // Skip everything if we have no items to process
        if(itemList == null || itemList.isEmpty())
        {
            return true;
        }
        // Build up the mappings of products and line items
        List<SObject> itemSoList                  = new List<SObject>();           
        List<Id> productIdList                    = new List<Id>();                
        Map<Id, List<SObject>> productIdToSObject = new Map<Id, List<SObject>>();  
       
        for (Integer i=0; i<itemList.size(); i++)
        {
            SObject objectSO = itemList[i];
   
            if (objectSO != null && objectSO.getSObject('PricebookEntry') != null)
            {
               
                Id productId = (Id)objectSO.getSObject('PricebookEntry').get('Product2Id');
                productIdList.add(productId);
               
                if (productIdToSObject.get(productId) != null)
                {
                    productIdToSObject.get(productId).add(objectSO); 
                }                   
                else
                {
                   
                    itemSoList = new List<SObject>();
                    itemSoList.add(objectSO);
                    productIdToSObject.put(productId, itemSoList);
                }
            }            
        }
       
        // Return if we didn't find any products
        if (productIdList == null || productIdList.isEmpty())
        {
            return true;
        }
        
        System.debug('@@@@@@@-productIdList'+ productIdList );
       
        // Get the line items from the frame contract
        List<SObject> listContractLineItems = getFrameContractLineItems(productIdList, (Id) parent.get('AccountId'), currQuote); //AccountId field is supported for Quote/Order/Opportunity SobjectType
        System.debug('$$$$ listContractLineItems :' + JSON.serialize(listContractLineItems));
       
        // Return if we didn't find any frame contract line items
        if (listContractLineItems == null || listContractLineItems.isEmpty()) return true;
        else     { System.debug('🏏🏏🏏🏏🏏🏏🏏🏏 I found the frame agreements items');}
             
        List<SObject> lineItemSObject = new List<SObject>();            
        Map<String, Object> itemFields = new Map<String, Object>();
        // For each contract line item, locate and update the products in the order/quote/opportunity
        for (SObject cline: listContractLineItems)
        {
            //AttributeComapreLogic
            System.debug('🏏🏏🏏🏏🏏🏏🏏🏏 CLI Attribute'+cline.get('vlocity_cmt__AttributeSelectedValues__c'));
            String jsonString = (String)cline.get('vlocity_cmt__AttributeSelectedValues__c');
            Map<String, Object> cliAttr = new Map<String, Object>();
            if(String.isNotBlank(jsonString))
                cliAttr = (Map<String, Object>)JSON.deserializeUntyped(jsonString);
            List<SObject> oObjectSOList = productIdToSObject.get((Id)cline.get(namespacePrefix +'Product2Id__c'));

            if (oObjectSOList != null && !oObjectSOList.isEmpty())
            {
                // For each matching line item, update the pricing              
                for (SObject lineItem: oObjectSOList)
                {
                    itemFields.put(lineItem.Id, generatePricingUpdates(lineItem,cline));  
                    System.debug('🏏🏏🏏🏏🏏🏏🏏🏏 QLI Attribute'+lineItem.get('vlocity_cmt__AttributeSelectedValues__c'));
                    //OnlyIf Attributes are matching
                    if(String.isBlank(jsonString)){
                        lineItemSObject.add(lineItem);
                    }
                    else if(compareAttributes(cliAttr,(Map<String,Object>) JSON.deserializeUntyped((String)lineItem.get('vlocity_cmt__AttributeSelectedValues__c'))))                  
                        lineItemSObject.add(lineItem);
                }              
            }                      
        }
       
        if (isLogging){
            System.debug('lineItemSObject :' + lineItemSObject);
        }
        // For future developers attn: do not do any DMLs, instead of doing an update DML, we pass it back into the pricing plan so in the "Save Line Items" step it will do one DML
       
        Type t = Type.forName('vlocity_cmt.SetCartItemExternalPriceService');
        if (t != null)
        {
           
            vlocity_cmt.VlocityOpenInterface externalPriceService = (vlocity_cmt.VlocityOpenInterface)t.newInstance();
            Map<String, Object> externalPriceServiceInput = new Map<String, Object>();
            Map<String, Object> externalPriceServiceOutput = new Map<String, Object>();
            Map<String, Object> externalPriceServiceOptions = new Map<String, Object>();
            // Field Mappings for the external pricing service
            Map<String, String> varCodeToFieldMap = getPricingVariableBinding(pricingVariableCodes);
            externalPriceServiceInput.put('parent', parent);
            externalPriceServiceInput.put('itemList', lineItemSObject);
            externalPriceServiceInput.put('pricingVariableToFieldMap', varCodeToFieldMap);                          
            externalPriceServiceInput.put('itemFieldsInfo', itemFields);

            externalPriceServiceOptions.put('SkipUpdate', true);
            if (isLogging)
            {
                System.debug('$$$$ externalPriceServiceInput ' + JSON.serialize(externalPriceServiceInput));
            }
            externalPriceService.invokeMethod('setItemPrices', externalPriceServiceInput, externalPriceServiceOutput, externalPriceServiceOptions);
            if (isLogging)
            {
                System.debug('$$$$ externalPriceServiceOutput: ' + JSON.serialize(externalPriceServiceOutput));
            }
        }
        else 
        {
            System.debug('$$$$ Unable to locate class "vlocity_cmt.SetCartItemExternalPriceService"');     
        }
       
        return true;
    }
   
    
    private Map<String, Object> generatePricingUpdates(SObject li,SObject cli)
    {
        // Mapping of Contract Line Item Fields to Cart Line Item Fields
        Map<String, String> cli2liFields = new Map<String, String>();
        cli2liFields.put(namespacePrefix  + 'OneTimeCharge__c', namespacePrefix  + 'OneTimeCharge__c');
        cli2liFields.put('Annual_Recurring_Charge__c', 'Annual_Recurring_Charge__c');       
                                                     
        Map<String, Object> lineItemFields = new Map<String, Object>();                                                                                                          
                                                     

        Iterator<String> fieldIter = cli2liFields.keySet().iterator();
        while (fieldIter.hasNext())
        {
           
            String cliField = fieldIter.next();
            String liField  = cli2liFields.get(cliField);
           
            Object contractValue = cli.get(cliField);
            if (contractValue != null)
            {
               
                li.put(liField, contractValue); 
                Map<String, Object> lineItemFieldValue = new Map<String, Object>();    
                lineItemFieldValue.put('value', contractValue);
                               
                lineItemFieldValue.put('detail', '  ' );
                if (cli.get('vlocity_cmt__ContractId__c') != null)
                {
                    lineItemFieldValue.put('detail',  '');
                }
                else
                {
                    lineItemFieldValue.put('detail', 'Price from ' + cli.get('vlocity_cmt__ContractId__c') + ' (' + cli.get('vlocity_cmt__ContractId__c') + ')');
                }
               
                   
                lineItemFields.put(liField, lineItemFieldValue);
            }
        }
        return lineItemFields;
    }


    private List<SObject> getFrameContractLineItems(List<Id> productIdList, Id accountId, Quote quoteRecord)
    {
        SObjectType contractLineObj = Schema.getGlobalDescribe().get('vlocity_cmt__ContractLineItem__c');
        Map<String,Schema.SObjectField> objfields = contractLineObj.getDescribe().fields.getMap();
             
        // Build the SOQL Query
        String query = 'SELECT ';
        Boolean firstField = true;
       
        // Fields
        for (String field: objfields.keySet()) 
        {
           
            if(!firstField) query += ' , ';
            firstField = false;
           
            query += field;
        }
        query += ' ,vlocity_cmt__ContractId__r.Description, vlocity_cmt__ContractId__r.ContractNumber, vlocity_cmt__ContractId__r.RecordType.Name ';
       
        // FROM
        query += ' FROM ' + namespacePrefix + 'ContractLineItem__c';

        if(quoteRecord != null && quoteRecord.vlocity_cmt__FrameContractId__c != null){
            Id frameContractId = quoteRecord.vlocity_cmt__FrameContractId__c;
            query += ' WHERE ' + namespacePrefix + 'Product2Id__c IN :productIdList AND vlocity_cmt__ContractId__r.AccountId =:accountId  AND vlocity_cmt__EffectiveStartDate__c <= Today AND vlocity_cmt__EffectiveEndDate__c >= Today AND vlocity_cmt__ContractId__r.vlocity_cmt__IsFrameContract__c = true AND vlocity_cmt__ContractId__r.Id =: frameContractId AND vlocity_cmt__ContractId__r.Status =\'Activated\''; 
        }else{
            query += ' WHERE ' + namespacePrefix + 'Product2Id__c IN :productIdList AND vlocity_cmt__ContractId__r.AccountId =:accountId  AND vlocity_cmt__EffectiveStartDate__c <= Today AND vlocity_cmt__EffectiveEndDate__c >= Today AND vlocity_cmt__ContractId__r.vlocity_cmt__IsFrameContract__c = true AND vlocity_cmt__ContractId__r.Status =\'Activated\'';
        }
       
       
        system.debug('@@@@@@@@@@'+query);
        
        Map<Id, sObject> valuesMap = new Map<Id, sObject>();
               
        for(Sobject clitem : database.query(query))
        {
            Id productId = (Id) clitem.get(namespacePrefix + 'Product2Id__c');
            if(valuesMap.get(productId) == NULL)
            {
                valuesMap.put(productId, clitem);
            } 
            else
            {
                Sobject cheapCLI = valuesMap.get(productId);
                if((decimal) cheapCLI.get('Annual_Recurring_Charge__c') < (decimal) clitem.get('Annual_Recurring_Charge__c'))
                {
                    valuesMap.put(productId, cheapCLI);                     
                } 
                else if((decimal) cheapCLI.get('Annual_Recurring_Charge__c') > (decimal) clitem.get('Annual_Recurring_Charge__c'))
                {
                    valuesMap.put(productId, clitem);
                }
                else if((decimal) cheapCLI.get(namespacePrefix + 'OneTimeCharge__c') < (decimal) clitem.get(namespacePrefix + 'OneTimeCharge__c'))
                {
                    valuesMap.put(productId, cheapCLI);
                } 
                else if((decimal) cheapCLI.get(namespacePrefix + 'OneTimeCharge__c') > (decimal) clitem.get(namespacePrefix + 'OneTimeCharge__c'))
                {
                    valuesMap.put(productId, clitem);
                }                   
            }
        }
        return  valuesMap.values();
        
    }

    private static Map<String, String> getPricingVariableBinding(List<String> codes)
    {
        Map<String, String> pvbMap = new Map<String, String>();
        for(vlocity_cmt__PricingVariableBinding__c pvb :[SELECT vlocity_cmt__PricingVariableId__r.vlocity_cmt__Code__c, vlocity_cmt__DestinationFieldApiName__c 
                                            FROM vlocity_cmt__PricingVariableBinding__c
                                            WHERE vlocity_cmt__PricingVariableId__r.vlocity_cmt__Code__c IN: codes
                                            AND vlocity_cmt__DestinationSObjectType__c = :sObjectType])
        {
            if(!String.isEmpty(pvb.vlocity_cmt__PricingVariableId__r.vlocity_cmt__Code__c) && !String.isEmpty(pvb.vlocity_cmt__DestinationFieldApiName__c))
            {
                pvbMap.put(pvb.vlocity_cmt__PricingVariableId__r.vlocity_cmt__Code__c, pvb.vlocity_cmt__DestinationFieldApiName__c);
            }
        }
        return pvbMap;
    }

    private boolean compareAttributes(Map<String, Object> cliAttr, Map<String, Object> cartLineAttr){
        Boolean retType = true;
        for(String key:cliAttr.keySet()){
            if(cartLineAttr.containsKey(key)){
                String strcartLineAttr = (String)cartLineAttr.get(key);
                String strcliAttr = (String)cliAttr.get(key);
                if(strcliAttr.equals(strcartLineAttr))
                    continue;
                else {
                    retType = false;
                    break;
                }                
            }
        }
        System.debug('🏏🏏🏏🏏🏏🏏🏏🏏 compareAttributes '+retType);
        return retType;
    }
}