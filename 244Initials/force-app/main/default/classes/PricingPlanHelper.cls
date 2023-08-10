global with sharing class PricingPlanHelper implements vlocity_cmt.VlocityOpenInterface, Callable
{
    private static Boolean isLogging = false;
    private static String JSON_ATTR_FLD = 'vlocity_cmt__JSONAttribute__c';
    private static Boolean UseDisplayTextForValuesDefault = true; // Use display values for attribute values as default
    private static String NSP = 'vlocity_cmt__'; // Vlocity namespace prefix
    private static String cachePartition;

    static
    {
        String setting = getCpqConfigurationSetupValue('PricingPlanHelperLogging');
        if (setting == 'True')
        {
            isLogging = true;
        }
        cachePartition = getAttrMatrixInfoCachePartition();
    }

    global Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> output, Map<String, Object> options)
    {
        try
        {
            if (methodName == 'GetCalculationProcedurePrice')
            {
                getCalculationProcedurePrice(input, output, options);
                return true;
            }
            else if (methodName == 'GetMatrixRow')
            {
                getMatrixRow(input, output, options);
                return true;
            }
            else if (methodName == 'InvokeCalculationProcedure')
            {
                invokeCalculationProcedure(input, output, options);
                return true;
            }
            else if (methodName == 'SetExternalPrice')
            {
                setExternalPrice(input, output, options);
                return true;
            }
            else if (methodName == 'GetMatrixProductCodeMapping')
            {
                getMatrixProductCodeMapping(input, output, options);
                return true;
            }
            else
            {
                output.put('Error', 'Unsupported method name: ' + methodName);
                return false;
            }
        }
        catch (Exception ex)
        {
            System.debug(LoggingLevel.ERROR, ex);
            System.debug(LoggingLevel.ERROR, ex.getStackTraceString());
            output.put('error', ex.getMessage());
            return false;
        }
    }
    
    public Object call(String action, Map<String, Object> args) 
    {
        Map<String,Object> inputMap = (Map<String,Object>)args.get('input');
        Map<String,Object> outputMap = (Map<String,Object>)args.get('output');
        Map<String,Object> options = (Map<String,Object>)args.get('options');
        
        return invokeMethod(action, inputMap, outputMap, options);
    }

    private void getCalculationProcedurePrice(Map<String, Object> input, Map<String, Object> output, Map<String, Object> options)
    {
        Map<String, Object> svcInput = new Map<String, Object>();
        Map<String, Object> svcOutput = new Map<String, Object>();
        Map<String, Object> svcOptions = new Map<String, Object>();

        //Check if Procedure Name is correct. If not, throw exception
        String procedureName = (String)input.get('ProcedureName');
        
        List<vlocity_cmt__CalculationProcedure__c> calculationProcedureList = [SELECT Id,Name FROM vlocity_cmt__CalculationProcedure__c WHERE Name = :procedureName];
        if(calculationProcedureList == null || calculationProcedureList.isEmpty())
        {
            throw new PricingPlanHelperException('No calculation procedure found with name ' + procedureName);
        }

        svcInput.putAll(input);
        
        Map<String, Object> args = new Map<String, Object>();
        args.put('input',svcInput);
        args.put('output',svcOutput);
        args.put('options',svcOptions);
        PricingPlanHelper pricinghelper = new PricingPlanHelper();
        
        pricinghelper.call('getMatrixRow', args);
        List<Object> calcProcData = (List<Object>)svcOutput.get('Result');
        Map<Id, String> itemIdToPathKeyMapping = (Map<Id, String>)svcOutput.get('ItemIdToPathKeyMapping');
        Map<String, SObject> lineNumToItem = (Map<String, SObject>)svcOutput.get('LineNumToItem');
        Map<Id, SObject> itemIdToItem = (Map<Id, SObject>)svcOutput.get('ItemIdToItem');
        Map<String, List<SObject>> prodNameToItems = (Map<String, List<SObject>>)svcOutput.get('ProdNameToItems');

        if (calcProcData != null && !calcProcData.isEmpty())
        {
            if (isLogging)
            {
                System.debug('calculation procedure input: ' + JSON.serialize(calcProcData));
            }
            svcInput.clear();
            svcOutput.clear();
            svcOptions.clear();
            procedureName = (String)input.get('ProcedureName');
            SObject parent = (SObject)input.get('Parent');
            List<SObject> itemList = (List<SObject>)input.get('ItemList');
            svcInput.put('ProcedureName', procedureName);
            svcInput.put('InputData', calcProcData);
            
            Map<String, Object> agrs = new Map<String, Object>();
            agrs.put('input',svcInput);
            agrs.put('output',svcOutput);
            agrs.put('options',svcOptions);
            
            Boolean result = (Boolean) pricingHelper.call('invokeCalculationProcedure', agrs);
            if (result == false)
            {
                if (isLogging)
                {
                    System.debug('calculation procedure output: ' + JSON.serialize(svcOutput));
                }
            }
            else
            {
                List<Object> procResult = (List<Object>)svcOutput.get('Result');
                List<Object> timePlanPolicyList = new List<Object>();
                if (isLogging)
                {
                    System.debug('calculation procedure result: ' + JSON.serialize(procResult));
                }

                if (procResult != null)
                {
                    procResult = evaluateTarget(procResult, itemList, lineNumToItem, itemIdToItem, itemIdToPathKeyMapping, prodNameToItems);
                    //Extract TimePlan and TimePolicy Information if they exists
                    timePlanPolicyList = updateTimePlanPolicyInformation(procResult);
                }

                Boolean createAdjustment = false;
                if(input.get('CreateAdjustment') != null && input.get('CreateAdjustment').equals('True'))
                {
                    createAdjustment = true;
                }
                Map<String, object> extSvcInput = new Map<String, object>();
                Map<String, object> extSvcOutput = new Map<String, object>();
                Map<String, object> extSvcOptions = new Map<String, object>();
                Map<String, String> varCodeToFieldMap = new Map<String, String>{
                'REC_MNTH_STD_PRC'=>'vlocity_cmt__RecurringCharge__c',
                'OT_STD_PRC'=>'vlocity_cmt__OneTimeCharge__c',
                'USAGE_STD_PRC' => 'vlocity_cmt__UsageUnitPrice__c'
                };

                Map<String, Id> unitOfMeasureToIdMap = loadUOM();

                extSvcInput.put('parent', parent);
                extSvcInput.put('itemList', itemList);
                extSvcInput.put('externalPriceData', procResult);
                extSvcInput.put('pricingVariableToFieldMap', varCodeToFieldMap);
                extSvcInput.put('priceDetailMessage', 'Priced from ' + procedureName);
                extSvcInput.put('timePlanPolicyList', timePlanPolicyList);
                extSvcInput.put('CreateAdjustment', createAdjustment);
                extSvcInput.put('unitOfMeasureToIdMap', unitOfMeasureToIdMap);
                
                Map<String, Object> agrsSetExternalPrice = new Map<String, Object>();
                agrsSetExternalPrice.put('input',extSvcInput);
                agrsSetExternalPrice.put('output',extSvcOutput);
                agrsSetExternalPrice.put('options',extSvcOptions);
                
                pricingHelper.call('setExternalPrice', agrsSetExternalPrice);
            }
        }
    }

    private List<Object> updateTimePlanPolicyInformation(List<Object> procResult)
    {
        List<Object> timePlanPolicyList = new List<Object>();
        if(procResult.isEmpty()) return timePlanPolicyList;

        //For each row, assign it's own TimePolicyName and TimePlanName
        for (Object obj : procResult)
        {
            if (obj instanceOf Map<String, Object>)
            {
                Map<String, Object> matrixResultRow = (Map<String, Object>)obj;
                Map<String, Object> timePlanPolicyInfo = new Map<String, Object>();

                //Extract TimePlan and TimePolicy Information if they exists
                for(String key : matrixResultRow.keySet())
                {
                    if(key == 'ID')
                    {
                        timePlanPolicyInfo.put('Id', matrixResultRow.get(key));
                        continue;
                    }
                    else if(!key.contains('__'))
                    {
                        continue;
                    }

                    String[] outputColumnName = key.split('__');
                    if(outputColumnName[1] == 'TimePlan')
                    {
                        String timePlanName = (String)matrixResultRow.get(key);
                        timePlanPolicyInfo.put('TimePlanName', timePlanName);
                    }
                    else if(outputColumnName[1] == 'TimePolicy')
                    {
                        String timePolicyName = (String)matrixResultRow.get(key);
                        timePlanPolicyInfo.put('TimePolicyName', timePolicyName);
                    }
                }

                //If TimePlan & TimePolicy both are found, then add to timePlanPolicyList
                if(timePlanPolicyInfo.size() == 3)
                {
                    timePlanPolicyList.add(timePlanPolicyInfo);
                }

            }
        }
        if (isLogging)
        {
            System.debug('timePlanPolicyList output: ' + timePlanPolicyList);
        }
        return timePlanPolicyList;
    }

    private List<Object> evaluateTarget(List<Object> procResult, List<SObject> itemList, Map<String, SObject> lineNumToItem,
                                Map<Id, SObject> itemIdToItem, Map<Id, String> itemIdToPathKeyMapping, Map<String, List<SObject>> prodNameToItems)
    {
        if (procResult != null && !procResult.isEmpty())
        {
            List<Object> filteredList = new List<Object>();
            // Test the first result to see if it has a property that ends with TargetProductName
            // and save the full propertyName
            String propertyName;
            Object firstObj = procResult[0];
            if (firstObj instanceOf Map<String, Object>)
            {
                Map<String, Object> matrixResultRow = (Map<String, Object>)firstObj;
                for (String key : matrixResultRow.keySet())
                {
                    if (key.endsWith('TargetProductName'))
                    {
                        propertyName = key;
                        break;
                    }
                }
            }
            // Just return if there is no TargetProductName in the matrix output
            if (propertyName == null)
            {
                return procResult;
            }
            Map<String, List<SObject>> pathKeyToItems = new Map<String, List<SObject>>();
            for (Id itemId : itemIdToPathKeyMapping.keySet())
            {
                SObject item = itemIdToItem.get(itemId);
                String pathKey = itemIdToPathKeyMapping.get(itemId);
                List<SObject> objList = pathKeyToItems.get(pathKey);
                if (objList == null)
                {
                    objList = new List<SObject>();
                    pathKeyToItems.put(pathKey, objList);
                }
                objList.add(item);
            }
            for (Object obj : procResult)
            {
                if (obj instanceOf Map<String, Object>)
                {
                    Map<String, Object> matrixResultRow = (Map<String, Object>)obj;
                    String targetProduct = (String)matrixResultRow.get(propertyName);

                    if (String.isNotBlank(targetProduct))
                    {
                        List<SObject> targetItems;
                        // Check to see if the targetProduct value is a Path
                        if (pathKeyToItems.containsKey(targetProduct))
                        {
                            targetItems = pathKeyToItems.get(targetProduct);
                        }
                        else if (prodNameToItems.get(targetProduct) != null)
                        {
                            targetItems = prodNameToItems.get(targetProduct);
                        }

                        if (targetItems != null && !targetItems.isEmpty())
                        {
                            Id itemId = (Id)matrixResultRow.get('ID');
                            SObject sourceItem = itemIdToItem.get(itemId);
                            String sourceRootLineNum = getRootLineNumber(sourceItem);

                            Boolean bFirst = true;
                            for (SObject targetItem : targetItems)
                            {
                                String targetRootLineNum = getRootLineNumber(targetItem);

                                // Check if the source and target are under the same root
                                if (sourceRootLineNum == targetRootLineNum)
                                {
                                    if (bFirst)
                                    {
                                        matrixResultRow.put('ID', targetItem.Id);
                                        filteredList.add(matrixResultRow);
                                        bFirst = false;
                                    }
                                    else
                                    {
                                        Map<String, Object> clonedRow = matrixResultRow.clone();
                                        clonedRow.put('ID', targetItem.Id);
                                        filteredList.add(clonedRow);
                                    }
                                }
                            }
                        }
                    }
                    else
                    {
                        // this row does not have a target, return it in the filteredList
                        filteredList.add(obj);
                    }
                }
            }
            return filteredList;
        }
        return procResult;
    }

    private static String getRootLineNumber(SObject item)
    {
        String lineNumber = (String)item.get(NSP + 'LineNumber__c');
        Integer idx = lineNumber.indexOf('.');
        return idx > 0 ? lineNumber.substring(0, idx) : lineNumber;
    }

    private void getMatrixProductCodeMapping(Map<String, Object> input, Map<String, Object> output, Map<String, Object> options)
    {
        if (isLogging)
        {
            System.debug('input to  getMatrixProductCodeMapping: ' + input);
        }
        String matrixName = (String)input.get('MatrixName');

        Map<String, Object> matrixInfoOutput = new Map<String, Object>();

        getMatrixInfo(input, matrixInfoOutput);

        Id matrixVersionId = (Id)matrixInfoOutput.get('MatrixVersionId');
        Boolean includeAttrInfoInRangeKeys = false;
        if(input.get('IncludeAttrInfoInRangeKeys') != null)
        {
            includeAttrInfoInRangeKeys = Boolean.valueOf((String)input.get('IncludeAttrInfoInRangeKeys'));
        }

        String cacheKey = 'AttrMatrixInfo' + String.valueOf(matrixVersionId);
        Map<String, Object> cacheMap;
        Cache.OrgPartition orgPart;
        if (String.isNotBlank(cachePartition))
        {
            orgPart = Cache.Org.getPartition(cachePartition);
            if (orgPart != null)
            {
                cacheMap =  (Map<String, Object>)orgPart.get(cacheKey);
                if (cacheMap != null)
                {
                    if (isLogging)
                    {
                        System.debug('cacheMap retrieved: ' + JSON.serialize(cacheMap));
                    }
                    output.put('rangeFieldMapping', cacheMap.get('RangeFieldMapping'));
                    output.put('rangeAttrMapping', cacheMap.get('RangeAttrMapping'));
                    output.put('productCodeMapping', cacheMap.get('ProductCodeMapping'));
                    output.put('productCodeSet', cacheMap.get('ProductCodeSet'));
                    return;
                }
            }
        }
        Map<String, Object> rangeFieldMapping = new Map<String, Object>();
        Map<String, Object> rangeAttrMapping = new Map<String, Object>();
        Map<String, Object> productCodeMapping = new Map<String, Object>();
        Set<String> productCodeSet = new Set<String>();
        output.put('rangeFieldMapping', rangeFieldMapping);
        output.put('rangeAttrMapping', rangeAttrMapping);
        output.put('productCodeMapping', productCodeMapping);
        output.put('productCodeSet', productCodeSet);
        
        Set<String> rangeFields = (Set<String>)matrixInfoOutput.get('RangeFields');
        
        Set<String> rangeAttrs = (Set<String>)matrixInfoOutput.get('RangeAttributes');
        String matrixRowQuery = (String)matrixInfoOutput.get('MatrixRowQuery');

        for (vlocity_cmt__CalculationMatrixRow__c cmr : Database.query(matrixRowQuery))
        {
            processMatrixRow(cmr, rangeAttrs, rangeAttrMapping, rangeFields, rangeFieldMapping, productCodeMapping, productCodeSet, includeAttrInfoInRangeKeys);
        }

        if (orgPart != null)
        {
            cacheMap = new Map<String, Object>();
            cacheMap.put('MatrixName', matrixName);
            cacheMap.put('MatrixVersionId', matrixVersionId);
            cacheMap.put('MatrixVersionNumber', matrixInfoOutput.get('MatrixVersionNumber'));
            cacheMap.put('MatrixPriority', matrixInfoOutput.get('MatrixPriority'));
            cacheMap.put('RangeFields', rangeFields);
            cacheMap.put('RangeAttributes', rangeAttrs);
            cacheMap.put('RangeAttrMapping', rangeAttrMapping);
            cacheMap.put('RangeFieldMapping', rangeFieldMapping);
            cacheMap.put('ProductCodeMapping', productCodeMapping);
            cacheMap.put('ProductCodeSet',productCodeSet);
            cacheMap.put('CacheTime', DateTime.now());
            orgPart.put(cacheKey, cacheMap);
            if (isLogging)
            {
                System.debug('cacheMap saved: ' + JSON.serialize(cacheMap));
            }
        }
    }

    global static void processMatrixRow(vlocity_cmt__CalculationMatrixRow__c cmr, Set<String> rangeAttrs,
                                        Map<String, Object> rangeAttrMapping,Set<String> rangeFields, Map<String, Object> rangeFieldMapping,
                                        Map<String, Object> productCodeMap, Set<String> productCodeSet,
                                        Boolean includeAttrInfoInRangeKeys)
    {
        if (isLogging)
        {
            System.debug('cmr priority ' + cmr.vlocity_cmt__CalculationMatrixVersionId__r.vlocity_cmt__Priority__c);
            System.debug('cmr version number ' + cmr.vlocity_cmt__CalculationMatrixVersionId__r.vlocity_cmt__VersionNumber__c);
        }

        Object inputdata = JSON.deserializeUntyped(cmr.vlocity_cmt__InputData__c);

        if (inputdata instanceof Map<String, Object>)
        {
            Map<String, Object> inputDataMap = (Map<String, Object>)inputdata;

            if (isLogging)
            {
                System.debug('inputdata returned ' + inputdata);
            }

            if (inputDataMap.ContainsKey('Source Product Code'))
            {
                String sourceProductCode = String.valueof(inputDataMap.get('Source Product Code'));
                String characteristicName = String.valueof(inputDataMap.get('Characteristic Name'));
                String characteristicValue = String.valueof(inputDataMap.get('Characteristic Value'));
                
                productCodeSet.add(sourceProductCode);
                Set<String> charNameSet = new Set<String>();
                if (String.isNotBlank(characteristicName))
                {
                    for (String cName : characteristicName.split(';'))
                    {
                        // TODO check for leading or ending whitespace
                        charNameSet.add(cName);
                    }
                }
                if (!charNameSet.isEmpty())
                {
                    if (rangeAttrs != null && !rangeAttrs.isEmpty())
                    {
                        getRangeAttributesMapping(sourceProductCode, inputDataMap, charNameSet, rangeAttrs, rangeAttrMapping);
                    }
                    Map<String, Object> charNameMap = getOrCreateMap(sourceProductCode, productCodeMap);
                    List<String> charNameList = new List<String>(charNameSet);
                    charNameList.sort();
                    charNameMap.put(String.join(charNameList, ';'), charNameSet);
                }

                if (rangeFields != null)
                {
                    getRangeFieldsMapping(sourceProductCode, inputDataMap, rangeFields, rangeFieldMapping, characteristicName, characteristicValue, includeAttrInfoInRangeKeys);
                }
            }
        }
    }

    global static void getMatrixInfo(Map<String, Object> input, Map<String, Object> output)
    {
        String matrixName = (String)input.get('MatrixName');
        vlocity_cmt__CalculationMatrixVersion__c matrixVersion;
        DateTime dTime = System.now();
        List<vlocity_cmt__CalculationMatrixVersion__c> cmvList = [SELECT Id, vlocity_cmt__IsEnabled__c, vlocity_cmt__EndDateTime__c, vlocity_cmt__CalculationMatrixId__c, 
                                                                    vlocity_cmt__Priority__c, vlocity_cmt__StartDateTime__c, vlocity_cmt__VersionNumber__c, Name
                                                                    FROM vlocity_cmt__CalculationMatrixVersion__c
                                                                    WHERE vlocity_cmt__CalculationMatrixId__r.Name =: matrixName AND vlocity_cmt__IsEnabled__c=true 
                                                                    AND vlocity_cmt__StartDateTime__c <= :dTime AND (vlocity_cmt__EndDateTime__c>= :dTime 
                                                                    OR vlocity_cmt__EndDateTime__c=null)
                                                                    ORDER BY vlocity_cmt__Priority__c DESC];

        if (cmvList == null || cmvList.isEmpty())
        {
            throw new PricingPlanHelperException('No calculation matrix found with name ' + matrixName);
        }
        matrixVersion = cmvList[0];

        output.put('MatrixName', matrixName);
        output.put('MatrixVersionId', matrixVersion.Id);
        output.put('MatrixPriority', matrixVersion.vlocity_cmt__Priority__c);
        output.put('MatrixVersionNumber', matrixVersion.vlocity_cmt__VersionNumber__c);

        String rangeFieldsInput = (String)input.get('RangeFields');
        Set<String> rangeFields;
        if (String.isNotBlank(rangeFieldsInput))
        {
            rangeFields = new Set<String>(rangeFieldsInput.split(';'));
        }
        output.put('RangeFields', rangeFields);
        String rangeAttrsInput = (String)input.get('RangeAttributes');
        Set<String> rangeAttrs;
        if (String.isNotBlank(rangeAttrsInput))
        {
            rangeAttrs = new Set<String>(rangeAttrsInput.split(';'));
        }
        output.put('RangeAttributes', rangeAttrs);

        String matrixRowQuery = 'SELECT Id, Name, ' + NSP + 'InputData__c, ' +
            NSP + 'CalculationMatrixVersionId__r.' + NSP + 'Priority__c, ' +
            NSP + 'CalculationMatrixVersionId__r.' + NSP + 'VersionNumber__c ' +
            'FROM ' + NSP + 'CalculationMatrixRow__c WHERE ' +
            NSP + 'CalculationMatrixVersionId__c = \'' + matrixVersion.Id + '\' AND Name != \'Header\'';
        output.put('MatrixRowQuery' , matrixRowQuery);
    }

    private static Map<String, Object> getOrCreateMap(String key, Map<String, Object> sourceMap)
    {
        Map<String, Object> result = (Map<String, Object>)sourceMap.get(key);
        if (result == null)
        {
            result = new Map<String, Object>();
            sourceMap.put(key, result);
        }
        return result;
    }

    private static void getRangeAttributesMapping(String sourceProductCode, Map<String, Object> inputDataMap, Set<String> charNameSet, Set<String> rangeAttrs, Map<String, Object> rangeAttrMapping)
    {
        String characteristicValue = String.valueof(inputDataMap.get('Characteristic Value'));
        if (String.isNotBlank(characteristicValue))
        {
            if (isLogging)
            {
                System.debug('characteristicValue: ' + characteristicValue);
                System.debug('rangeAttrIndex: ' + rangeAttrs);
            }
            String[] charValList = characteristicValue.split(';');
            if (!charValList.isEmpty())
            {
                Map<String, Object> rangeAttrsPerProductCode = getOrCreateMap(sourceProductCode, rangeAttrMapping);
                Integer idx = 0;
                for (String attrName : charNameSet)
                {
                    if (rangeAttrs.contains(attrName))
                    {
                        String rangeInfo = charValList.get(idx);
                        Map<String, Object> rangeInfoMap = getOrCreateMap(attrName, rangeAttrsPerProductCode);
                        if (String.isNotBlank(rangeInfo))
                        {
                            rangeInfo = rangeInfo.trim();
                            if (rangeInfo.contains('-'))
                            {
                                String[] parts = rangeInfo.split('-');
                                Map<String, Object> limits = new Map<String, Object>();
                                limits.put('lower', Decimal.valueOf(parts[0].trim()));
                                limits.put('upper', Decimal.valueOf(parts[1].trim()));
                                rangeInfoMap.put(rangeInfo, limits);
                            }
                            else
                            {
                                Map<String, Object> limits = new Map<String, Object>();
                                limits.put('lower', Decimal.valueOf(rangeInfo));
                                limits.put('upper', Decimal.valueOf(rangeInfo));
                                rangeInfoMap.put(rangeInfo, limits);
                            }
                        }
                    }
                    idx++;
                }
            }
        }
    }

    private static void getRangeFieldsMapping(String sourceProductCode, Map<String, Object> inputDataMap, Set<String> rangeFields, Map<String, Object> rangeFieldMapping,
                                              String characteristicName, String characteristicValue, Boolean includeAttrInfoInRangeKeys)

        {
        String key = sourceProductCode;
        if(includeAttrInfoInRangeKeys)
        {
            key = sourceProductCode + '<' + characteristicName + '<' + characteristicValue;
        }
        Map<String, Object> rangeFieldsMapping = getOrCreateMap(key, rangeFieldMapping);
        for (String rangeField : rangeFields)
        {
            Map<String, Object> rangeInfoMap = getOrCreateMap(rangeField, rangeFieldsMapping);

            String rangeInfo = String.valueof(inputDataMap.get(rangeField));
            if (rangeInfo.contains('-'))
            {
                String[] parts = rangeInfo.split('-');
                Map<String, Object> limits = new Map<String, Object>();
                limits.put('lower', Decimal.valueOf(parts[0].trim()));
                limits.put('upper', Decimal.valueOf(parts[1].trim()));
                rangeInfoMap.put(rangeInfo, limits);
            }
            else
            {
                Map<String, Object> limits = new Map<String, Object>();
                limits.put('lower', Decimal.valueOf(rangeInfo));
                limits.put('upper', Decimal.valueOf(rangeInfo));
                rangeInfoMap.put(rangeInfo, limits);
            }
        }
    }

    private void getPathMapping(Map<String, Object> input, Map<String, Object> output, List<SObject> itemList)
    {
        Map<Id, String> itemIdToPathKeyMapping = new Map<Id, String>();
        output.put('ItemIdToPathKeyMapping', itemIdToPathKeyMapping);
        Map<String, SObject> lineNumToItem = new Map<String, SObject>();
        output.put('LineNumToItem', lineNumToItem);
        Map<Id, SObject> itemIdToItem = new Map<Id, SObject>();
        output.put('ItemIdToItem', itemIdToItem);
        Map<String, List<SObject>> prodNameToItems = new Map<String, List<SObject>>();
        output.put('ProdNameToItems', prodNameToItems);

        Map<String, Object> productPathMapping = new Map<String, Object>();
        for (String key : input.keySet())
        {
            if (key.length() > 4 && key.startsWith('Path'))
            {
                productPathMapping.put((String)input.get(key), key);
            }
        }

        if (itemList != null && !itemList.isEmpty())
        {
            Map<String, String> parentLineNums = new Map<String, String>();
            for (SObject item : itemList)
            {
                itemIdToItem.put(item.Id, item);
                String lineNum = (String)item.get(NSP + 'LineNumber__c');

                if (lineNum != null)
                {
                    lineNumToItem.put(lineNum, item);
                    Integer index = lineNum.lastIndexOf('.');
                    if (index > 0)
                    {
                        String parentLineNum = lineNum.substring(0, index);
                        parentLineNums.put(lineNum, parentLineNum);
                    }
                    else
                    {
                        parentLineNums.put(lineNum, '');
                    }
                }
                else
                {
                    System.debug(LoggingLevel.ERROR, 'Line Number missing for SObject ' + item);
                    throw new PricingPlanHelperException('Line Number missing for SObject with Id ' + item.Id);
                }

                String productName = (String)item.getSObject('PricebookEntry').getSObject('Product2').get('Name');
                List<SObject> items = prodNameToItems.get(productName);
                if (items == null)
                {
                    items = new List<SObject>();
                    prodNameToItems.put(productName, items);
                }
                items.add(item);
            }

            if (!productPathMapping.isEmpty())
            {
                for (String lineNum : lineNumToItem.keySet())
                {
                    SObject item = lineNumToItem.get(lineNum);
                    String productName = (String)item.getSObject('PricebookEntry').getSObject('Product2').get('Name');

                    String productPath = productName;

                    String parentLineNum = parentLineNums.get(lineNum);

                    while (String.isNotBlank(parentLineNum))
                    {
                        SObject parentItem = lineNumToItem.get(parentLineNum);
                        productName = (String)parentItem.getSObject('PricebookEntry').getSObject('Product2').get('Name');
                        productPath = productName + '<' + productPath;
                        parentLineNum = parentLineNums.get(parentLineNum);
                    }
                    String pathKey = (String)productPathMapping.get(productPath);
                    if (String.isNotBlank(pathKey))
                    {
                        itemIdToPathKeyMapping.put(item.Id, pathKey);
                    }
                }
            }
        }
    }

    private String replaceNameWithPath(String productName, Id itemId, Map<Id, String> itemIdToPathKeyMapping)
    {
        String productPath = itemIdToPathKeyMapping.get(itemId);
        if (String.isNotBlank(productPath))
        {
            return productPath;
        }
        return productName;
    }

    private void getMatrixRow(Map<String, Object> input, Map<String, Object> output, Map<String, Object> options)
    {
        List<Object> result = new List<Object>();
        List<SObject> itemList = (List<SObject>)input.get('ItemList');
        if (itemList != null && !itemList.isEmpty())
        {
            Map<String, Object> mappingOutput = new Map<String, Object>();
            
            PricingPlanHelper pricingHelper = new PricingPlanHelper();
            
            Map<String, Object> agrs = new Map<String, Object>();
            agrs.put('input',input);
            agrs.put('output',mappingOutput);
            agrs.put('options',options);
            
            pricingHelper.call('getMatrixProductCodeMapping', agrs);
            Map<String, Object> rangeFieldMapping = (Map<String, Object>)mappingOutput.get('rangeFieldMapping');
            Map<String, Object> rangeAttrMapping = (Map<String, Object>)mappingOutput.get('rangeAttrMapping');
            Map<String, Object> matrixProductCodeMapping = (Map<String, Object>)mappingOutput.get('productCodeMapping');
            Set<String> matrixProductCodeSet = (Set<String>)mappingOutput.get('productCodeSet');

            Boolean clearExternalPriceFlag = (Boolean)input.get('ClearExternalPriceFlag');
            if (clearExternalPriceFlag == true)
            {
                clearExternalPriceFlag(itemList);
            }

            getPathMapping(input, output, itemList);

            if (isLogging)
            {
                System.debug('itemList: ' + JSON.serialize(itemList));
                System.debug('matrixProductCodeMapping: ' + JSON.serialize(matrixProductCodeMapping));
                System.debug('rangeFieldMapping: ' + JSON.serialize(rangeFieldMapping));
                System.debug('rangeAttrMapping: ' + JSON.serialize(rangeAttrMapping));
                System.debug('getPathMapping output: ' + JSON.serialize(output));
            }

            String productCodeField = (String)input.get('ProductCodeField');
            if (String.isBlank(productCodeField))
            {
                productCodeField = 'ProductCode';
            }
            vlocity_cmt.JSONAttributeSupport jsonSupport = new vlocity_cmt.JSONAttributeSupport();
            Map<String, object> jsonSupportInput = new Map<String, object>();
            Map<String, object> jsonSupportOutput = new Map<String, object>();
            Map<String, object> jsonSupportOptions = new Map<String, object>();
            if (input.get('UseDisplayTextForValues') != null)
            {
                Boolean useDisplay = true;
                Object param = input.get('UseDisplayTextForValues');
                if (param instanceof String)
                {
                    useDisplay = Boolean.valueOf(param);
                }
                else if (param instanceof Boolean)
                {
                    useDisplay = (Boolean)param;
                }
                else
                {
                    throw new PricingPlanHelperException('Unsupported data type for UseDisplayTextForValues');
                }
                jsonSupportInput.put('UseDisplayTextForValues', useDisplay);
            }
            else
            {
                // use the default setting if not specified
                jsonSupportInput.put('UseDisplayTextForValues', UseDisplayTextForValuesDefault);
            }
            Map<Id, String> itemIdToPathKeyMapping = (Map<Id, String>)output.get('ItemIdToPathKeyMapping');
            Map<String, Object> attributeCodeToDisplayName = new Map<String, Object>() ;

            //Checking if we are using AttributeV2 Model
            Boolean useAttributeV2Model = false;
            try
            {
                useAttributeV2Model = vlocity_cmt.VlocityFeatureService.getFeatureValue('EnableV2AttributeModel');
            }
            catch(Exception e){
                System.debug(e.getStackTraceString());
            }
            if (isLogging)
            {
                System.debug('useAttributeV2Model: ' + useAttributeV2Model);
            }
            if(useAttributeV2Model)
            {
                try
                {
                    for (SObject item : Database.query('SELECT Name,' + NSP + 'Code__c FROM ' + NSP + 'Attribute__c'))
                    {
                        attributeCodeToDisplayName.put((String)item.get(NSP + 'Code__c'), (String)item.get('Name'));
                    }
                }
                catch (Exception e)
                {
                    system.debug(e.getStackTraceString());
                }
            }
            
            //Related Field Mapping for parent field based pricing from Line Items, Passed from pricing plan steps parameters.
            List<Object> pricingFieldMapping = (List<Object>) input.get('PricingFieldMapping');

            //To Store mapping of parent related field from Line Items to Matrix Column mapping.
            Map<String, String> pricingFieldMatrixMapping; 

            //To Store all parent records which needs to be extracted for Line Items pricing.
            Map<String,List<String>> sObjectTypeFieldsMap;

            //Parent Sobject relationship on Line items object.
            Map<String, List<String>> sObjectRelationsOnLineItemObject;

            Map<String, Set<Id>> sObjectsParentIds = new Map<String, Set<Id>>();
            if(pricingFieldMapping != NULL)
            {
                for(Object priceField : pricingFieldMapping)
                {
                    Map<String, Object> priceFieldMap = (Map<String, Object>) priceField;
                    String columnName = String.valueof(priceFieldMap.get('MatrixColumn'));
                    String relationalAPIFieldName = String.valueof(priceFieldMap.get('relationalField'));
                    String fieldAPIName = String.valueof(priceFieldMap.get('fieldAPI'));
                    String sObjectType = String.valueof(priceFieldMap.get('SObjectType'));

                    pricingFieldMatrixMapping = new Map<String, String>();
                    sObjectTypeFieldsMap = new Map<String,List<String>>();
                    sObjectRelationsOnLineItemObject = new Map<String, List<String>>();

                    if(sObjectTypeFieldsMap.get(sObjectType) == NULL)
                    {
                        sObjectTypeFieldsMap.put(sObjectType, new List<String>());
                    }

                    if(sObjectRelationsOnLineItemObject.get(sObjectType) == NULL)
                    {
                        sObjectRelationsOnLineItemObject.put(sObjectType, new List<String>());
                    }
                    sObjectRelationsOnLineItemObject.get(sObjectType).add(relationalAPIFieldName);
                    sObjectTypeFieldsMap.get(sObjectType).add(fieldAPIName);
                    pricingFieldMatrixMapping.put(relationalAPIFieldName + '.' + fieldAPIName, columnName);
                }
            }

            
            for (SObject item : itemList)
            {
                if(sObjectTypeFieldsMap != NULL && !sObjectTypeFieldsMap.keyset().isEmpty())
                {
                    for(String sObjectTypeStr : sObjectTypeFieldsMap.keyset())
                    {
                        if(!sObjectRelationsOnLineItemObject.get(sObjectTypeStr).isEmpty())
                        {
                            for(String relationalFieldOnLineItem : sObjectRelationsOnLineItemObject.get(sObjectTypeStr))
                            {
                                Id relationalParentRecordId = Id.valueof(String.valueof(item.get(relationalFieldOnLineItem)));
                                if(sObjectsParentIds.get(sObjectTypeStr) == NULL)
                                {
                                    sObjectsParentIds.put(sObjectTypeStr, new Set<Id>());
                                }
                                sObjectsParentIds.get(sObjectTypeStr).add(relationalParentRecordId);
                            }
                        }
                    }
                }
            }

            Map<String, Map<Id, Sobject>> itemListParentMap;

            if(sObjectTypeFieldsMap != NULL && sObjectTypeFieldsMap.keySet().size() > 0)
            {
                Set<Id> itemIds = (new Map<Id,SObject>(itemList)).keySet();
                
                //If there are more object on which location based pricing is depended then query here.
                String sObjectType = new List<String>(sObjectTypeFieldsMap.keySet())[0]; 
                
                Set<Id> parentIds = sObjectsParentIds.get(sObjectType);
                
                List<String> fields = sObjectTypeFieldsMap.get(sObjectType);

                Map<Id, Sobject> relatedQuoteMembers = new Map<Id , Sobject>(Database.query('Select  Id, ' + String.join(fields, ',') 
                                                                                            + ' FROM ' + sObjectType 
                                                                                            + ' WHERE Id in :parentIds'));

                itemListParentMap = new Map<String, Map<Id, Sobject>>();
                itemListParentMap.put(sObjectType , relatedQuoteMembers);
            }
            
            for (SObject item : itemList)
            {
                String productCode = (String)item.getSObject('PricebookEntry').getSObject('Product2').get(productCodeField);
                
                //If the given Product Code is not present in Matrix, no need to process it.
                if(!matrixProductCodeSet.contains(productCode))
                {
                    continue;
                }

                Map<String, Object> charNameMap = (matrixProductCodeMapping!=null)?(Map<String, Object>)matrixProductCodeMapping.get(productCode):null;

                // Each row in the input is itself a map
                String productName = (String)item.getSObject('PricebookEntry').getSObject('Product2').get('Name');

                if (!itemIdToPathKeyMapping.isEmpty())
                {
                    productName = replaceNameWithPath(productName, item.Id, itemIdToPathKeyMapping);
                }

                Map<String, Object> currentRowVals = item.getPopulatedFieldsAsMap();
                Map<String, Object> rowData = new Map<String, Object>();
                rowData.put('Source Product Name', productName);
                rowData.put('Source Product Code', productCode);
                rowData.put('Quantity', item.get('Quantity'));
                rowData.put('Line Number', item.get(nsp+'LineNumber__c'));
                rowData.put('ID', item.Id); // each row must have a unique key
                

                if(sObjectTypeFieldsMap != NULL && !sObjectTypeFieldsMap.keyset().isEmpty())
                {
                    for(String sObjectTypeStr : sObjectTypeFieldsMap.keyset())
                    {
                        if(!sObjectRelationsOnLineItemObject.get(sObjectTypeStr).isEmpty())
                        {
                            for(String relationalFieldOnLineItem : sObjectRelationsOnLineItemObject.get(sObjectTypeStr))
                            {
                                Id relationalParentRecordId = Id.valueof(String.valueof(item.get(relationalFieldOnLineItem)));
                                Sobject parentrelationalParentRecord = itemListParentMap.get(sObjectTypeStr).get(relationalParentRecordId);
                                for(String fieldAPIName : sObjectTypeFieldsMap.get(sObjectTypeStr))
                                {
                                    String key = relationalFieldOnLineItem + '.'+ fieldAPIName;
                                    String columnName = pricingFieldMatrixMapping.get(key);
                                    if(!String.isBlank(columnName))
                                    {
                                        //Adding dynamic matrix and field mapping from any field of any parent records.
                                        rowData.put(columnName, String.valueof(parentrelationalParentRecord.get(fieldAPIName)));
                                    }
                                }
                            }
                        }
                    }
                }


                String charNames = ''; // attribute display names
                String charValues = '';
                String charCodes = '';
                Map<String, Object> attrMap ;


                if(charNameMap != null && !charNameMap.isEmpty())
                {
                    if (useAttributeV2Model)
                    {
                        String attributeMetadataJSON = (String)item.getSObject('PricebookEntry').getSObject('Product2').get(NSP + 'AttributeMetadata__c');
                        String attributeValuesJSON = (String)item.get(NSP + 'AttributeSelectedValues__c');
                        if (String.isNotBlank(attributeMetadataJSON))
                        {
                            jsonSupportOutput.clear();
                            jsonSupportInput.put('attributeValuesJSON', attributeValuesJSON);
                            jsonSupportInput.put('attributeMetadataJSON', attributeMetadataJSON);
                            jsonSupport.invokeMethod('getAttributeValuesFromJSON', jsonSupportInput, jsonSupportOutput,jsonSupportOptions);
                            if (isLogging)
                            {
                                System.debug('jsonSupportOutput: ' + JSON.serialize(jsonSupportOutput));
                            }
                            attrMap = (Map<String, Object>)jsonSupportOutput.get('attributeCodeToValue');
                        }
                    }
                    else
                    {
                        String jsonAttr = (String)item.get(JSON_ATTR_FLD);
                        if (String.isNotBlank(jsonAttr))
                        {
                            jsonSupportOutput.clear();
                            jsonSupportInput.put('JSONString', jsonAttr);
                            jsonSupport.invokeMethod('getAttributeValuesFromJSON', jsonSupportInput, jsonSupportOutput,jsonSupportOptions);
                            if (isLogging)
                            {
                                System.debug('jsonSupportOutput: ' + JSON.serialize(jsonSupportOutput));
                            }
                            attrMap = (Map<String, Object>)jsonSupportOutput.get('attributeCodeToValue');
                            attributeCodeToDisplayName =
                            (Map<String, Object>)jsonSupportOutput.get('attributeCodeToDisplayName');
                        }
                    }
                    if (attrMap != null && !attrMap.isEmpty())
                    {
                        Map<String, String> attrDisplayToCode = new Map<String, String>();
                        for (String attCode : attrMap.keySet())
                        {
                            attrDisplayToCode.put((String)attributeCodeToDisplayName.get(attCode), attCode);
                        }

                        Boolean includeAttrInfoInRangeKeys = false;
                        String rangeFieldMapKey = productCode;
                        if(input.get('IncludeAttrInfoInRangeKeys') != null)
                        {
                            includeAttrInfoInRangeKeys = Boolean.valueOf((String)input.get('IncludeAttrInfoInRangeKeys'));
                            if (!includeAttrInfoInRangeKeys)
                            {
                                setRangeFieldValues(rangeFieldMapping, rangeFieldMapKey, currentRowVals, rowData);
                            }
                        }

                        Boolean firstRow = true;
                        for (String key : charNameMap.keySet())
                        {
                            Set<String> attrOrderSet = (Set<String>)charNameMap.get(key);
                            if (isLogging)
                            {
                                System.debug('attrOrderSet: ' + JSON.serialize(attrOrderSet));
                            }
                            if (attrOrderSet != null)
                            {
                                Map<String, Object> rangeAttrMap;
                                if (!rangeAttrMapping.isEmpty())
                                {
                                    rangeAttrMap = (Map<String, Object>)rangeAttrMapping.get(productCode);
                                }
                                Boolean bFirst = true;
                                for (String attr : attrOrderSet)
                                {
                                    String attrCode = (String)attrDisplayToCode.get(attr);
                                    Object val = attrMap.get(attrCode);
                                    if (rangeAttrMap != null)
                                    {
                                        Map<String, Object> rangeValues = (Map<String, Object>)rangeAttrMap.get(attr);
                                        if (rangeValues != null)
                                        {
                                            for(String valKey : rangeValues.keySet())
                                            {
                                                Map<String, Object> valueMap = (Map<String, Object>)rangeValues.get(valKey);
                                                if (valueMap != null)
                                                {
                                                    if (val != null && val instanceof Decimal)
                                                    {
                                                        Decimal currentVal = (Decimal)val;
                                                        if ((currentVal >= (Decimal)valueMap.get('lower')) && (currentVal <= (Decimal)valueMap.get('upper')))
                                                        {
                                                            val = valKey;
                                                            break;
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    if (!bFirst)
                                    {
                                        charNames += ';' + String.valueOf(attr);
                                        charCodes += ';' + attrCode;
                                        charValues += ';' + ((val == null) ? '' : String.valueOf(val));
                                    } else
                                    {
                                        bFirst = false;
                                        charNames += String.valueOf(attr);
                                        charCodes += attrCode;
                                        charValues += ((val == null) ? '' : String.valueOf(val));
                                    }
                                }
                                if (firstRow)
                                {
                                    rowData.put('Characteristic Code', charCodes);
                                    rowData.put('Characteristic Name', charNames);
                                    rowData.put('Characteristic Value', charValues);
                                    if(includeAttrInfoInRangeKeys){
                                        rangeFieldMapKey = productCode + '<' + charNames + '<' + charValues;
                                        setRangeFieldValues(rangeFieldMapping, rangeFieldMapKey, currentRowVals, rowData);

                                    }
                                    result.add(rowData);
                                    firstRow = false;
                                }
                                else
                                {
                                    Map<String, Object> clonedRow = rowData.clone();
                                    clonedRow.put('Characteristic Code', charCodes);
                                    clonedRow.put('Characteristic Name', charNames);
                                    clonedRow.put('Characteristic Value', charValues);
                                    if(includeAttrInfoInRangeKeys){
                                        rangeFieldMapKey = productCode + '<' + charNames + '<' + charValues;
                                        setRangeFieldValues(rangeFieldMapping, rangeFieldMapKey, currentRowVals, clonedRow);

                                    }
                                    result.add(clonedRow);
                                }
                            }
                        }
                    }
                }
                else
                {
                    //CMT-3740 : Volume Based Pricing with no ABP support
                    Map<String, Object> productCodeToRangeFields = (Map<String, Object>)rangeFieldMapping.get(productCode);
                    if (productCodeToRangeFields != null)
                    {
                        for (String field : productCodeToRangeFields.keySet())
                        {
                            if (currentRowVals.containsKey(field))
                            {
                                Map<String, Object> rangeValues = (Map<String, Object>)productCodeToRangeFields.get(field);
                                if (rangeValues != null)
                                {
                                    for(String valKey:rangeValues.keySet())
                                    {
                                        Map<String, Object> valueMap = (Map<String, Object>)rangeValues.get(valKey);
                                        if (valueMap != null)
                                        {
                                            Object objVal = currentRowVals.get(field);
                                            if (objVal != null && objVal instanceof Decimal)
                                            {
                                                Decimal currentVal = (Decimal)objVal;
                                                if ((currentVal >= (Decimal)valueMap.get('lower')) && (currentVal <= (Decimal)valueMap.get('upper')))
                                                {
                                                    rowData.put(field, valKey);
                                                    break;
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    result.add(rowData);
                }
            }
        }
        output.put('Result', result);
    }

    private void setRangeFieldValues(Map<String, Object> rangeFieldMapping, String mapKey, Map<String, Object> currentRowVals, Map<String, Object> rowData)
    {
        Map<String, Object> productCodeToRangeFields = (Map<String, Object>)rangeFieldMapping.get(mapKey);

        if (productCodeToRangeFields != null)
        {
            for (String field : productCodeToRangeFields.keySet())
            {
                if (currentRowVals.containsKey(field))
                {
                    Map<String, Object> rangeValues = (Map<String, Object>)productCodeToRangeFields.get(field);
                    if (rangeValues != null)
                    {
                        for(String valKey : rangeValues.keySet())
                        {
                            Map<String, Object> valueMap = (Map<String, Object>)rangeValues.get(valKey);
                            if (valueMap != null)
                            {
                                Object objVal = currentRowVals.get(field);
                                if (objVal != null && objVal instanceof Decimal)
                                {
                                    Decimal currentVal = (Decimal)objVal;
                                    if ((currentVal >= (Decimal)valueMap.get('lower')) && (currentVal <= (Decimal)valueMap.get('upper')))
                                    {
                                        rowData.put(field, valKey);
                                        break;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    private void clearExternalPriceFlag(List<SObject> itemList)
    {
        for (SObject item : itemList)
        {
            String itemObjectName = item.getSObjectType().getDescribe().getName();
            String provisioningStatus = (String)item.get(nsp + 'ProvisioningStatus__c');
            // Only clear flags for non-Asset items and if provisioningStatus is not Deleted
            if (provisioningStatus != 'Deleted' && itemObjectName != 'Asset')
            {
                String priceLogJSON = (String)item.get(nsp + 'PricingLogData__c');
                if (priceLogJSON == null) return;
                Map<String, Object> logMap = (Map<String, Object>)JSON.deserializeUntyped(priceLogJSON);
                if (logMap == null || logMap.isEmpty())
                {
                    return;
                }
                Map<String, Object> externalPrices = (Map<String, Object>)logMap.remove('ExternalPrices');
                if (externalPrices != null)
                {
                    item.put(nsp + 'PricingLogData__c', JSON.serialize(logMap));
                }
            }
        }
    }

    private Boolean invokeCalculationProcedure (Map<String, Object> input, Map<String, Object> output, Map<String, Object> options)
    {
        String procedureName = (String)input.get('ProcedureName');
        List<Object> inputData = (List<Object>)input.get('InputData');

        if (String.isBlank(procedureName) || inputData == null || inputData.isEmpty())
        {
            output.put('ErrorMessage', 'ProcedureName or InputData are empty.');
            return false;
        }
        // Construct the matrix calculation service
        Type t = Type.forName('vlocity_cmt.PricingMatrixCalculationService');

        vlocity_cmt.VlocityOpenInterface matrixService = (vlocity_cmt.VlocityOpenInterface)t.newInstance();

        Map<String, Object> inputMap = new Map<String, Object>{
        'inputData' => inputData
        };
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> optionsMap = new Map<String, Object>{
        'configurationName' => procedureName, // String procedureName = 'TestCalculationProcedure'
        'inputKey' => 'inputData', // tells the service what is the key for the data in the inputMap,
        'mode' => null,
        'isExpressionSet' => false,
        'verbose' => true,
        'matchInputVariables' => true,
        'effectiveDate' => String.valueOf(System.Now()),
        'configurationVersionId' => null // Set the matrix version id. Null version id picks the latest version with highest priority
        };

        // TODO: Extract error
        // invoke the calculation procedure
        matrixService.invokeMethod('calculate', inputMap, outputMap, optionsMap);

        //Parse the calculation procedure response
        List<Object> outList = (List<Object>)outputMap.get('output');
        List<Object> objectList;
        if (outList != null && !outList.isEmpty())
        {
            vlocity_cmt.PricingCalculationService.CalculationProcedureResults calcProcResults =
                (vlocity_cmt.PricingCalculationService.CalculationProcedureResults)outList[0];
            objectList = calcProcResults.calculationResults;
        }

        // return the objectList
        output.put('Result', objectList);
        return true;
    }

    private Map<String, Id> loadUOM()
    {
        String cacheKey = 'UnitOfMeasureToIdMap';
        Map<String, Id> unitOfMeasureToIdMap;
        Cache.OrgPartition orgPart;
        if (String.isNotBlank(cachePartition))
        {
            orgPart = Cache.Org.getPartition(cachePartition);
            if (orgPart != null)
            {
                unitOfMeasureToIdMap =  (Map<String, Id>)orgPart.get(cacheKey);
                if (unitOfMeasureToIdMap != null && isLogging)
                {
                    System.debug('unitOfMeasureToIdMap retrieved from cache: ' + JSON.serialize(unitOfMeasureToIdMap));
                }
            }
        }
        if(unitOfMeasureToIdMap == null)
        {
            unitOfMeasureToIdMap = new Map<String, Id>();
            List<vlocity_cmt__ChargeMeasurement__c> cmList = [Select Id, Name From vlocity_cmt__ChargeMeasurement__c LIMIT 10000];
            if(cmList != null && !cmList.isEmpty())
            {
                for(vlocity_cmt__ChargeMeasurement__c cm: cmList)
                {
                    unitOfMeasureToIdMap.put(cm.Name, cm.Id);
                }

                //put in cache
                if(orgPart != null && !unitOfMeasureToIdMap.isEmpty())
                {
                    orgPart.put(cacheKey, unitOfMeasureToIdMap);
                    if (isLogging)
                    {
                        System.debug('unitOfMeasureToIdMap saved in cache: ' + JSON.serialize(unitOfMeasureToIdMap));
                    }
                }
            }
        }
        return unitOfMeasureToIdMap;
    }

    private void setExternalPrice(Map<String, Object> input, Map<String, Object> output, Map<String, Object> options)
    {
        Map<String, Object> itemFields = new Map<String, Object>();
        SObject parent = (SObject)input.get('parent');
        List<SObject> itemList = (List<SObject>)input.get('itemList');
        List<Object> extPriceData = (List<Object>)input.get('externalPriceData');
        Map<String, String> fieldMap = (Map<String, String>)input.get('pricingVariableToFieldMap');
        List<Object> timePlanPolicyList = (List<Object>)input.get('timePlanPolicyList');
        String message = (String)input.get('priceDetailMessage');
        Boolean createAdjustment = (Boolean)input.get('CreateAdjustment');
        Map<String, Id> unitOfMeasureToIdMap = (Map<String, Id>) input.get('unitOfMeasureToIdMap');
        Map<Id, String> lineItemIdToUOM = new Map<Id, String>();

        if(extPriceData != null)
        {
            for (Object obj : extPriceData)
            {
                if (obj instanceOf Map<String, Object>)
                {
                    Map<String, Object> matrixResultRow = (Map<String, Object>)obj;
                    Map<String, Object> itemFieldDetails = new Map<String, Object>();
                    for (String fld : fieldMap.keySet())
                    {
                        String itemField = fieldMap.get(fld);
                        Map<String, Object> fieldVals = new Map<String, Object>();
                        fieldVals.put('value', matrixResultRow.get(fld));
                        fieldVals.put('detail', message);
                        itemFieldDetails.put(itemField, fieldVals);
                    }
                    itemFields.put(String.valueOf(matrixResultRow.get('ID')), itemFieldDetails);

                    //only for UOM
                    String uom = String.valueOf(matrixResultRow.get('UOM'));
                    if(String.isNotBlank(uom))
                    {
                        lineItemIdToUOM.put((Id)matrixResultRow.get('ID'), uom);
                    }
                }
            }
            if (isLogging)
            {
                System.debug('itemFields: ' + JSON.serialize(itemFields));
            }
        }
        //set UOM Id.
        if(unitOfMeasureToIdMap != null && !unitOfMeasureToIdMap.isEmpty()
            && !lineItemIdToUOM.isEmpty())
        {
            for(SObject lineItem: itemList)
            {
                Id lineItemId = (Id) lineItem.get('Id');
                String uom = lineItemIdToUOM.get(lineItemId);
                Id uomId = null;
                if(String.isNotBlank(uom))
                {
                    uomId = unitOfMeasureToIdMap.get(uom);
                }
                if(uomId != null)
                {
                    lineItem.put(nsp + 'UsageMeasurementId__c', uomId);
                }
            }
        }

        if (!itemFields.isEmpty() || createAdjustment)
        {
            Type t = Type.forName('vlocity_cmt.SetCartItemExternalPriceService');
            if (t != null)
            {
                vlocity_cmt.VlocityOpenInterface externalPriceService = (vlocity_cmt.VlocityOpenInterface)t.newInstance();
                Map<String, Object> externalPriceServiceInput = new Map<String, Object>();
                Map<String, Object> externalPriceServiceOutput = new Map<String, Object>();
                Map<String, Object> externalPriceServiceOptions = new Map<String, Object>();

                externalPriceServiceInput.put('parent', parent);
                externalPriceServiceInput.put('itemList', itemList);
                externalPriceServiceInput.put('pricingVariableToFieldMap', fieldMap);
                externalPriceServiceInput.put('itemFieldsInfo', itemFields);
                externalPriceServiceInput.put('timePlanPolicyList', timePlanPolicyList);
                // skip update to prevent this service from flushing to the database since the pricing plan service
                // will update the itemList anyway, this saves one DML update
                externalPriceServiceOptions.put('SkipUpdate', true);

                //This flags will tell if we need to create Adjustment Records for MRC and NRC
                externalPriceServiceOptions.put('CreateAdjustment', createAdjustment);
                externalPriceService.invokeMethod('setItemPrices', externalPriceServiceInput, externalPriceServiceOutput, externalPriceServiceOptions);
            }
        }
    }

    public static String getCpqConfigurationSetupValue(String setupName)
    {
        vlocity_cmt__CpqConfigurationSetup__c cpqSetup = vlocity_cmt__CpqConfigurationSetup__c.getInstance(setupName);
        String retval = null;
        if (cpqSetup != null
            //expected condition: there is a Custom Setting
            && cpqSetup.vlocity_cmt__SetupValue__c != null
            && cpqSetup.vlocity_cmt__SetupValue__c.length() > 0)
        {
            retval = cpqSetup.vlocity_cmt__SetupValue__c;
        }
        return retval;
    }

    global static String getAttrMatrixInfoCachePartition()
    {
        String setting = getCpqConfigurationSetupValue('AttrMatrixInfoCachePartition');
        if (String.isNotBlank(setting))
        {
            setting = 'local.' + setting;
            return setting;
        }
        return null;
    }

    global class PricingPlanHelperException extends Exception{}
}