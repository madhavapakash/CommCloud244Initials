/**
* Class to implement the trigger handler for Asset Object
*
* @Author  Salesforce
*
*/
public class ARTL_AssetTriggerHandler extends TriggerHandler {
    
    Map<Id, Asset> newAssetsMap = (Map<Id, Asset>) Trigger.newMap;
    Map<Id, Asset> oldAssetsMap = (Map<Id, Asset>) Trigger.oldMap;
    
    public ARTL_AssetTriggerHandler() {
        this.newAssetsMap = (Map<Id, Asset>) Trigger.newMap;
        this.oldAssetsMap = (Map<Id, Asset>) Trigger.oldMap;
    }
    
    public override void afterInsert() {
        Set<Id> accountIds = new Set<Id>();
        for (Asset asset : newAssetsMap.values()) {
            accountIds.add(asset.AccountId);
        }
        ARTL_AssetTriggerHelper.updateAccountAssetCount(accountIds);
    }
    
    public override void afterUpdate() {
        Set<Id> affectedAccountIds = new Set<Id>();
        for (Id assetId : newAssetsMap.keySet()) {
            Asset newAsset = newAssetsMap.get(assetId);
            Asset oldAsset = oldAssetsMap.get(assetId);
            
            if (newAsset.AccountId != oldAsset.AccountId) {
                affectedAccountIds.add(oldAsset.AccountId);
                affectedAccountIds.add(newAsset.AccountId);
            }
        }
        ARTL_AssetTriggerHelper.updateAccountAssetCount(affectedAccountIds);
    }
    
    public override void afterDelete() {
        Set<Id> affectedAccountIds = new Set<Id>();
        for (Asset oldAsset : oldAssetsMap.values()) {
            affectedAccountIds.add(oldAsset.AccountId);
        }
        ARTL_AssetTriggerHelper.updateAccountAssetCount(affectedAccountIds);
    }
}