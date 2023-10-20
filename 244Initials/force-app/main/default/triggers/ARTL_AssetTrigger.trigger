trigger ARTL_AssetTrigger on Asset (after insert, after update, after delete) {
    new ARTL_AssetTriggerHandler().run();
}