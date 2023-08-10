/*
* VLOCITY, INC. CONFIDENTIAL
* ________________________________________________________________________
*
*  2014-2020 Vlocity, Inc.
*  All Rights Reserved.
*
* NOTICE:  All information contained herein is, and remains
* the property of Vlocity, Inc. and its suppliers,
* if any. The intellectual and technical concepts contained
* herein are proprietary to Vlocity, Inc. and its suppliers and may be
* covered by U.S. and Foreign Patents, patents in process, and are
* protected by trade secret or copyright law. Dissemination of this
* information and reproduction, modification or reverse-engineering
* of this material, is prohibited unless prior written permission
* is obtained from Vlocity, Inc.
*
* @author: Vlocity
* 
* B2B CMEX Eligibility function implementation class 
*
*/
global class ESMCustomMatrixEligibilityImpl implements vlocity_cmt.VlocityOpenInterface, Callable
{
    private static String NSP = 'vlocity_cmt__';
    private static String cachePartition;
    private static Boolean isLogging = false;
    private static boolean defaultValueOnError = false;
    private static boolean defaultValueOnEmptyContext = false;
    
    static
    {
        String setting = getCpqConfigurationSetupValue('ESMCustomMatrixEligibilityLogging');
        isLogging = false;
        if(setting != NULL)
        {
            isLogging = Boolean.valueOf(setting);
        }
        cachePartition = getAttrMatrixInfoCachePartition();
    }
    
    global Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> output, Map<String, Object> options)
    {
        try
        {
            if (methodName.equalsIgnoreCase('checkEligibility'))
            {
                checkEligibility(input, output, options);
                return true;
            }
            if (methodName.equalsIgnoreCase('containsAny'))
            {
                containsAny(input, output, options);
                return true;
            }
            return false;
        }
        catch (Exception ex) {
            System.debug(LoggingLevel.ERROR, ex);
            System.debug(LoggingLevel.ERROR, ex.getStackTraceString());
            output.put('error', ex.getMessage());
            throw ex;
        }   
    }

    public Object call(String action, Map<String, Object> args) 
    {
        Map<String,Object> inputMap = (Map<String,Object>)args.get('input');
        Map<String,Object> outputMap = (Map<String,Object>)args.get('output');
        Map<String,Object> options = (Map<String,Object>)args.get('options');
        
        return invokeMethod(action, inputMap, outputMap, options);
    }
    
    private void containsAny(Map<String,Object> inputMap, Map<String,Object> outputMap, Map<String,Object> options)
    {
        List<Object> inpList = (List<Object>) inputMap.get('arguments');
        boolean result = false;
        if(inpList != NULL && inpList.size() > 1)
        {
            String tokenLeft = (String) inpList[0];
            String tokenRight = (String) inpList[1];
            Set<String> rightValues = new Set<String>(tokenRight.split(';'));
            Set<String> leftValues  = new Set<String>(tokenLeft.split(';'));
            for(String rightValue : rightValues)
            {
                if(leftValues.contains(rightValue))
                {
                    result = true;
                    break;
                }
            }
        }
        outputMap.put('result', result);
        outputMap.put('isEligible', result);
    }
    
    private void checkEligibility(Map<String,Object> inputMap, Map<String,Object> outputMap, Map<String,Object> options)
    {
        List<Object> inpList = (List<Object>) inputMap.get('arguments');
        String contextValueStr = (String) inpList[0];
        
        if(String.isBlank(contextValueStr))
        {
            outputMap.put('result', defaultValueOnEmptyContext);
            outputMap.put('isEligible', defaultValueOnEmptyContext);
            return;
        }
       
        Map<String, Object> cartContextValueObj = (Map<String, Object>) JSON.deserializeUntyped(contextValueStr);
        String productCode = (String) inpList[1];
        
        if(cartContextValueObj == NULL || cartContextValueObj.values().isEmpty())
        {
            outputMap.put('result', defaultValueOnEmptyContext);
            outputMap.put('isEligible', defaultValueOnEmptyContext);
            return;
        }
        else if(String.isBlank(productCode))
        {
            outputMap.put('result', defaultValueOnError);
            outputMap.put('isEligible', defaultValueOnError);
            return;
        }
        
        Map<String, Object> eligibileInput = new Map<String, Object>();
        eligibileInput.put('MatrixName', 'ProductEligibilityMatrix');

        Map<String,Object> procData = new Map<String, Object>();
        procData.put('ProductCode', productCode);
        eligibileInput.put('InputData', procData);

        Map<String, Object> eligibileOutput  = new Map<String, Object>();
        Map<String, Object> eligibileOptions = new Map<String, Object>();

        getMatrixInfo(eligibileInput, eligibileOutput, eligibileOptions);

        List<Object> result = (List<Object>) eligibileOutput.get('Result');
        for(Object resRow : result)
        {
            Map<String, Object> rowNodes = (Map<String, Object>) JSON.deserializeUntyped((String) resRow);
            String expressionStr = (String) rowNodes.get('Expression');
            Boolean expectedResult = Boolean.valueof(rowNodes.get('Result'));
            
            Map<String, Object> inputEvaluate = new Map<String, Object>();
            Map<String, Object> outputEvaluate = new Map<String, Object>();
            Map<String, Object> optionEvaluate = new Map<String, Object>();
            inputEvaluate.put('Expression', replaceTokenWithValue(expressionStr ,  cartContextValueObj));
            outputEvaluate = (Map<String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService('ESM_EvaluateFormula', inputEvaluate, optionEvaluate);
            Object actualResult = outputEvaluate.get('Result');
            
            if(actualResult instanceof boolean)
            {
                boolean actualResultBool = boolean.valueof(actualResult);
                outputMap.put('result', actualResultBool);
                outputMap.put('isEligible', actualResultBool);
            }
            else
            {
                outputMap.put('result', defaultValueOnError);
                outputMap.put('isEligible', defaultValueOnError);
            }
        }
    }
    
    private String replaceTokenWithValue(String expressionWithToken, Map<String, Object> tokenValueMapping)
    {
        for(String tokenName : tokenValueMapping.KeySet())
        {
            expressionWithToken = expressionWithToken.replaceAll( tokenName , '\'' +((String) tokenValueMapping.get(tokenName)) + '\' ');
        }
        return expressionWithToken;
    }

    private void getMatrixInfo(Map<String, Object> input, Map<String, Object> output, Map<String, Object> options)
    {
        String matrixName = (String)input.get('MatrixName');
        Object inputData = input.get('InputData');

        if (String.isBlank(matrixName) || inputData == null )
        {
            output.put('ErrorMessage', 'Matrix Name or InputData are empty.');
            return;
        }
        Map<String, Object> results;
        try
        {
            DateTime dTime = System.now();
            String cacheKey = 'ESMEligibilityMatrixInfo' + matrixName;
            Cache.OrgPartition orgPart;
            Map<String, Object> cacheMap;
            if (String.isNotBlank(cachePartition))
            {
                orgPart = Cache.Org.getPartition(cachePartition);
                if (orgPart != null)
                {
                    cacheMap = (Map<String, Object>) orgPart.get(cacheKey);
                    if (cacheMap != null)
                    {
                        if (isLogging)
                        {
                            System.debug('cacheMap retrieved: ' + JSON.serialize(cacheMap));
                        }
                        results = (Map<String, Object>)cacheMap.get('Matrix Row Info');
                    }
                }
            }

            if(results == NULL)
            {
                vlocity_cmt__CalculationMatrixVersion__c matrixRec = [
                    SELECT Id , (SELECT vlocity_cmt__InputData__c, vlocity_cmt__OutputData__c, vlocity_cmt__OutputDataLong__c  FROM vlocity_cmt__Vlocity_Calculation_Table_Line_Items__r)
                    FROM vlocity_cmt__CalculationMatrixVersion__c 
                    WHERE Name != 'Header' AND vlocity_cmt__CalculationMatrixId__r.Name = :matrixName AND vlocity_cmt__IsEnabled__c=true 
                            AND vlocity_cmt__StartDateTime__c <= :dTime AND (vlocity_cmt__EndDateTime__c>= :dTime 
                            OR vlocity_cmt__EndDateTime__c=null)
                            ORDER BY vlocity_cmt__Priority__c DESC LIMIT 1
                ];
                results = new Map<String, Object>();
                for(vlocity_cmt__CalculationMatrixRow__c  resRows : matrixRec.vlocity_cmt__Vlocity_Calculation_Table_Line_Items__r)
                {
                    String productCodekey = 'ProductCode';
                    Map<String, Object> matrixInputData = (Map<String, Object>) JSON.deserializeUntyped(resRows.vlocity_cmt__InputData__c);
                    String productCodeValue = (String) matrixInputData.get(productCodekey);
                    if(productCodeValue != NULL)
                    {
                        if(results.get(productCodeValue) == NULL)
                        {
                            results.put(productCodeValue, new List<String>());
                        }
                        List<Object> stringValues = (List<Object>) results.get(productCodeValue);
                        if(resRows.vlocity_cmt__OutputDataLong__c != NULL)
                        {
                            stringValues.add(resRows.vlocity_cmt__OutputDataLong__c);
                        }
                        else
                        {
                            stringValues.add(resRows.vlocity_cmt__OutputData__c);
                        }
                        
                        results.put(productCodeValue, stringValues);
                    }
                }
                if(cacheMap == NULL)
                {
                    cacheMap = new Map<String, Object>();
                }
                orgPart.put(cacheKey, cacheMap);
                if (isLogging)
                {
                    System.debug('cacheMap saved: ' + JSON.serialize(cacheMap));
                }
            }
        }
        catch(Exception e)
        {
            if (isLogging)
            {
                System.debug('Error Fetching Matrix Info:' + e);
            }
        }

        if(results != NULL)
        {
            output.put('Result', results.get((String) ((Map<String, Object>)inputData).get('ProductCode')));
        }
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
}