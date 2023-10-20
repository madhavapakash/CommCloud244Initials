/**
* Class to implement the trigger helper for Asset Object
*
* @Author  Salesforce
*
*/
public without Sharing class ARTL_AssetTriggerHelper {
    
    Public static void updateAccountAssetCount(Set<Id> accountIds) {
        
        List<Account> accountsToUpdate = new List<Account>();
        for (Id accountId : accountIds) {
            Integer assetCount = [SELECT COUNT() FROM Asset WHERE AccountId = :accountId];
            accountsToUpdate.add(new Account(Id = accountId, ARTL_PPI__c = assetCount));
        }
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
    
}