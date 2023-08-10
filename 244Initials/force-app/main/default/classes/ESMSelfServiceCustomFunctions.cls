global class ESMSelfServiceCustomFunctions implements Callable
{
    String nsp;
    public Object call(String action, Map<String, Object> args) 
    {

        Map<String, Object> input = (Map<String, Object>)args.get('input');
        Map<String, Object> output = (Map<String, Object>)args.get('output');
        Map<String, Object> options = (Map<String, Object>)args.get('options');
        return invokeMethod(action, input, output, options);
    }
    global Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> output, Map<String, Object> options)
    {
        nsp = [SELECT NamespacePrefix FROM Organization].NamespacePrefix + '__';
        if (methodName == 'getAssetReferenceIds')
        {
            List<Object> arguments = (List<Object>)input.get('arguments');
            output.put('result', getAssetReferenceIds(arguments));
        }
        else if (methodName == 'getChildrenIdsList')
        {
            List<Object> arguments = (List<Object>)input.get('arguments');
            output.put('result', getChildrenIdsList(arguments));
        }
        return true;
    }
     
    List<String> getAssetReferenceIds(List<Object> input)
    {
        List<String> listOfAssetRefIds = new List<String>();
        Map<String,Object> map1 = (Map<String,Object>)input.get(0);
        for(String key: map1.keySet())
        {
            Map<String,Object> item = (Map<String,Object>)map1.get(key);
            listOfAssetRefIds.add((String)item.get(this.nsp + 'AssetReferenceId__c'));
        }
        return listOfAssetRefIds;
    } 
    
    List<String> getChildrenIdsList(List<Object> input)
    {
        List<String> listOfAssetIds = new List<String>();
        for(Object node: input)
        {
            getChildrenRecursively((Map<String,Object>)node, listOfAssetIds);
        }
        return listOfAssetIds;
    }
    
    void getChildrenRecursively(Map<String,Object> root, List<String> listOfAssetIds)
    {
        if (root == null)
        {
            return;
        }
        List<Object> children = (List<Object>)root.get('Children');
        if(children != null) 
        {
            for(Object child : children)
            {
                getChildrenRecursively((Map<String,Object>)child,listOfAssetIds);
            }
        }
        listOfAssetIds.add((String)root.get('Id'));
    }
}
