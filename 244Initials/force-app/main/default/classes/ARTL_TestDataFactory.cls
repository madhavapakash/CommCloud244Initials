/**
*@author:         Salesforce(Sagar)
*@date:           06/14/2019
*@description:    Test Data Factory for ARTL Test Classes
*/
@isTest
public without sharing class ARTL_TestDataFactory {
    
    public static List<Account> createAccount(String recordTypeName, Boolean isInesrt, Integer numberOfRecords){
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
        List<Account> testAccountList = new List<Account>();
        for(Integer i = 0; i < numberOfRecords ; i++){
            Account testAccount = new Account(name = 'Test Account' + i, RecordTypeId = recordTypeId);
            testAccountList.add(testAccount);
        }
        if(isInesrt){
            insert testAccountList;
        }
        return testAccountList;
    }
    /*
    * Name         :  createQuote
    * Author       :  Sagar Sadhnani(SFI Dev)
    * Date         :  18 Oct, 2022
    * Description  :  Create Quote data for testing
    */
    public static List<Quote> createQuote(Id opportunityId, Id priceListId, Id standardBookId, Boolean isInesrt, Integer numberOfRecords){
        List<Quote> testQuoteList = new List<Quote>();
        for(Integer i = 0; i < numberOfRecords ; i++){
            Quote testQuote = new Quote (Name='Test Quote' + i ,vlocity_cmt__PriceListId__c = priceListId,
                                         status='Draft', OpportunityId =  opportunityId,
                                        Pricebook2Id = standardBookId);
            testQuoteList.add(testQuote);
        }
        if(isInesrt){
            insert testQuoteList;
        }
        return testQuoteList;
    }
    /*
    * Name         :  createQuoteLineItem
    * Author       :  Sagar Sadhnani(SFI Dev)
    * Date         :  18 Oct, 2022
    * Description  :  Create Quote line data for testing
    */
    public static List<QuoteLineItem> createQuoteLineItem(Id quoteId, Id productId, Id pricebookEntryId, Integer Quantity, Boolean isInesrt, Integer numberOfRecords){
        List<QuoteLineItem> testQuoteLineItemList = new List<QuoteLineItem>();
        for(Integer i = 0; i < numberOfRecords ; i++){
            QuoteLineItem testQLI = new QuoteLineItem( QuoteId = quoteId, Product2Id = productId, vlocity_cmt__RootItemId__c='c53b7add-91a1-1163-5e8a-c239d0b96464',
                                                      PriceBookEntryId = pricebookEntryId, Quantity=Quantity,UnitPrice=10.0, vlocity_cmt__EffectiveQuantity__c = Quantity
                                                      );
            testQuoteLineItemList.add(testQLI);
        }
        if(isInesrt){
            insert testQuoteLineItemList;
        }
        return testQuoteLineItemList;
    }

    /*
    * Name         :  createOpportunity
    * Author       :  Sagar Sadhnani(SFI Dev)
    * Date         :  18 Oct, 2022
    * Description  :  Create Opportunity data for testing
    */
    public static List<Opportunity> createOpportunity(Set<Id> accountIds, String stageName, Id priceListId, Boolean isInesrt, Integer numberOfRecords){
        List<Id> accountIdList = new List<Id>(accountIds);
        List<Opportunity> testOpportunityList = new List<Opportunity>();
        for(Integer i = 0; i < numberOfRecords ; i++){
            Opportunity testOpportunity = new Opportunity(name = 'Test Opty' + i, AccountId = accountIdList[i], CloseDate = System.today() + 10,
                                                          StageName = stageName, vlocity_cmt__PriceListId__c = priceListId,
                                                         Pricebook2Id = Test.getStandardPricebookId());
            testOpportunityList.add(testOpportunity);
        }
        if(isInesrt){
            insert testOpportunityList;
        }
        return testOpportunityList;
    }

    /*
    * Name         :  createProduct
    * Author       :  Sagar Sadhnani(SFI Dev)
    * Date         :  18 Oct, 2022
    * Description  :  Create product2 data for testing
    */
    public static List<Product2> createProduct(Set<String> names, Set<String> productCodes, Boolean isInesrt, Integer numberOfRecords){
        List<String> productNames = new List<String>(names);
        List<String> productCodeList = new List<String>(productCodes);
        List<Product2> testProductList = new List<Product2>();
        for(Integer i = 0; i < numberOfRecords ; i++){
            Product2 testProduct = new product2(Name = productNames[i], ProductCode = productCodeList[i]);
            testProductList.add(testProduct);
        }
        if(isInesrt){
            insert testProductList;
        }
        return testProductList;
    }
    
    /*
    * Name         :  createPricebookEntry
    * Author       :  Sagar Sadhnani(SFI Dev)
    * Date         :  18 Oct, 2022
    * Description  :  Create PBE data for testing
    */
    public static List<PricebookEntry> createPricebookEntry(Set<Id> productIds, Id standardPricebookId, Boolean isInesrt, Integer numberOfRecords){
        List<Id> productIdList = new List<Id>(productIds);
        List<PricebookEntry> testPricebookEntryList = new List<PricebookEntry>();
        for(Integer i = 0; i < numberOfRecords ; i++){
            PricebookEntry customPBE = new PricebookEntry(Pricebook2Id = standardPricebookId,
                                                          Product2Id = productIdList[i], UnitPrice = Integer.valueof(1000*Math.random()),
                                                          vlocity_cmt__RecurringPrice__c = Integer.valueof(1000*Math.random()),
                                                          IsActive = true);
            testPricebookEntryList.add(customPBE);
        }
        if(isInesrt){
            insert testPricebookEntryList;
        }
        return testPricebookEntryList;
    }
    
    /*
    * Name         :  createVlocityPriceList
    * Author       :  Sagar Sadhnani(SFI Dev)
    * Date         :  18 Oct, 2022
    * Description  :  Create VlocityPriceList data for testing
    */
    public static List<vlocity_cmt__PriceList__c> createVlocityPriceList(Id pricebookId, Boolean isInesrt, Integer numberOfRecords){
        List<vlocity_cmt__PriceList__c> testVlocityPLList = new List<vlocity_cmt__PriceList__c>();
        for(Integer i = 0; i < numberOfRecords ; i++){
            vlocity_cmt__PriceList__c testVlocityPL = new vlocity_cmt__PriceList__c(vlocity_cmt__Pricebook2Id__c = pricebookId,
                                                                                    vlocity_cmt__IsActive__c = true,
                                                                                    vlocity_cmt__Code__c = 'customPriceBook' + i);
            testVlocityPLList.add(testVlocityPL);
        }
        if(isInesrt){
            insert testVlocityPLList;
        }
        return testVlocityPLList;
    }

    /*
    * Name         :  createQuoteMember
    * Author       :  Sagar Sadhnani(SFI Dev)
    * Date         :  18 Oct, 2022
    * Description  :  Create Quote Member data for testing
    */
    public static List<vlocity_cmt__QuoteMember__c> createQuoteMember(Id quoteId,String status, Boolean isInesrt, Integer numberOfRecords){
        List<vlocity_cmt__QuoteMember__c> testrecords = new List<vlocity_cmt__QuoteMember__c>();
        for(Integer i = 0; i < numberOfRecords ; i++){
            vlocity_cmt__QuoteMember__c testRecord = new vlocity_cmt__QuoteMember__c(vlocity_cmt__QuoteId__c = quoteId,
                                                                                    Name = 'Test Quote Member' + i,
                                                                                    Feasibility_Status__c  = status);
            testrecords.add(testRecord);
        }
        if(isInesrt){
            insert testrecords;
        }
        return testrecords;
    }
	
    /*
    * Name         :  createTriggerSetup
    * Author       :  
    * Date         :  18 Oct, 2022
    * Description  :  Create Trigger Setup
    */
    public static void createTriggerSetup(){
        insert new vlocity_cmt__TriggerSetup__c(Name = 'AllTriggers',vlocity_cmt__IsTriggerOn__c = true);
    }
      /*
    * Name         :  setupData
    * Author       :  
    * Date         :  18 Oct, 2022
    * Description  :  Create Setup Data
    */
     public static void setupData(){
        createCPQConfiguration('B2BCmexEnterprisePPForQuoteMemberQLIs', 'true');

        Product2 product1 = new Product2(Name='Test JSON SiteProduct 1', 
                                        vlocity_cmt__SpecificationSubType__c = 'Offer', 
                                        ProductCode='PROD-002', 
                                        Description='This is a test JSON Product 1 Generator',
                                        vlocity_cmt__IsLocationDependent__c = true);
        insert product1;

        Product2 product2 = new Product2(Name='Test JSON SiteProduct 2',
                                        ProductCode='PROD-003', 
                                        Description='This is a test JSON Product 2',
                                        vlocity_cmt__IsLocationDependent__c = true);
        insert product2;

        Pricebook2 standardBook =  new Pricebook2(Id = Test.getStandardPricebookId(), 
                                                Name = 'TestPricebook', 
                                                IsActive = true);
        
        PricebookEntry pbe1 = new PricebookEntry(Pricebook2Id = standardBook.Id,
                                                Product2Id = product1.Id, 
                                                UnitPrice = 10, 
                                                vlocity_cmt__RecurringPrice__c = 5, 
                                                IsActive = true, UseStandardPrice = false);
        insert pbe1;

        PricebookEntry pbe2 = new PricebookEntry(Pricebook2Id = standardBook.Id,
                                                Product2Id = product2.Id, 
                                                UnitPrice = 10, 
                                                vlocity_cmt__RecurringPrice__c = 5, 
                                                IsActive = true, 
                                                UseStandardPrice = false);
        insert pbe2;

        vlocity_cmt__PriceList__c priceList = new vlocity_cmt__PriceList__c(Name = 'B2B PriceList', 
                                                                            vlocity_cmt__Code__c = 'ABCD', 
                                                                            vlocity_cmt__Pricebook2Id__c = standardBook.Id);
        insert priceList;

        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Contract cont = new Contract(Name='Contract1',Description = 'test dec',ContractTerm = 20,StartDate=System.today().addDays(-10), Status='Draft', AccountId=testAccount.Id, vlocity_cmt__IsFrameContract__c=true);  
        insert cont;
        cont.Status = 'Activated';
        update cont;
        
        List<vlocity_cmt__ContractLineItem__c> contlist = new List<vlocity_cmt__ContractLineItem__c>();
        contlist.add(new vlocity_cmt__ContractLineItem__c(vlocity_cmt__EffectiveStartDate__c = System.today().addDays(-8), vlocity_cmt__EffectiveEndDate__c = system.today().addDays(1),vlocity_cmt__ContractId__c=cont.Id, vlocity_cmt__PricebookEntryId__c = pbe1.Id, vlocity_cmt__Product2Id__c = product1.Id,vlocity_cmt__Quantity__c = 1,vlocity_cmt__OneTimeCharge__c = 100, vlocity_cmt__RecurringCharge__c = 10));
        contlist.add(new vlocity_cmt__ContractLineItem__c(vlocity_cmt__EffectiveStartDate__c = System.today().addDays(-7), vlocity_cmt__EffectiveEndDate__c = system.today().addDays(3),vlocity_cmt__ContractId__c=cont.Id, vlocity_cmt__PricebookEntryId__c = pbe1.Id, vlocity_cmt__Product2Id__c= product1.Id,vlocity_cmt__Quantity__c = 1, vlocity_cmt__OneTimeCharge__c = 40, vlocity_cmt__RecurringCharge__c =20));
        contlist.add(new vlocity_cmt__ContractLineItem__c(vlocity_cmt__EffectiveStartDate__c = System.today().addDays(-7), vlocity_cmt__EffectiveEndDate__c = system.today().addDays(3),vlocity_cmt__ContractId__c=cont.Id, vlocity_cmt__PricebookEntryId__c = pbe1.Id, vlocity_cmt__Product2Id__c= product1.Id,vlocity_cmt__Quantity__c = 1, vlocity_cmt__OneTimeCharge__c = 40, vlocity_cmt__RecurringCharge__c =15));
        contlist.add(new vlocity_cmt__ContractLineItem__c(vlocity_cmt__EffectiveStartDate__c = System.today().addDays(-6), vlocity_cmt__EffectiveEndDate__c = system.today().addDays(3),vlocity_cmt__ContractId__c=cont.Id, vlocity_cmt__PricebookEntryId__c = pbe1.Id, vlocity_cmt__Product2Id__c= product1.Id,vlocity_cmt__Quantity__c = 1, vlocity_cmt__OneTimeCharge__c = 20));
        contlist.add(new vlocity_cmt__ContractLineItem__c(vlocity_cmt__EffectiveStartDate__c = System.today().addDays(-5), vlocity_cmt__EffectiveEndDate__c = system.today().addDays(3),vlocity_cmt__ContractId__c=cont.Id, vlocity_cmt__PricebookEntryId__c = pbe1.Id, vlocity_cmt__Product2Id__c= product1.Id,vlocity_cmt__Quantity__c = 1, vlocity_cmt__OneTimeCharge__c = 40));
        insert contlist;

        Opportunity testOpportunity = new Opportunity(Name = 'Test Opporunity', 
                                                    AccountId = testAccount.Id, 
                                                    closeDate = Date.TODAY(), 
                                                    StageName = 'Prospecting', 
                                                    Pricebook2Id =  standardBook.Id);
        insert testOpportunity;

        Quote testQuote = new Quote(Status = 'Draft', 
                                    OpportunityId = testOpportunity.Id, 
                                    Name = 'Test Quote', 
                                    vlocity_cmt__OriginatingChannel__c = 'Retail', 
                                    vlocity_cmt__PriceListId__c = priceList.Id,
                                    RecordTypeId = getRecordTypeIdByName('Quote', 'EnterpriseQuote')
                                );
        insert testQuote;

        // creating quote to test testCalculateQPRollups
        Quote rollupQuote1 = new Quote(Status = 'Draft', 
                                    OpportunityId = testOpportunity.Id, 
                                    Name = 'Test Rollup Quote', 
                                    vlocity_cmt__OriginatingChannel__c = 'Retail', 
                                    vlocity_cmt__PriceListId__c = priceList.Id,
                                    RecordTypeId = getRecordTypeIdByName('Quote', 'EnterpriseQuote')
                                );
        insert rollupQuote1;
        
        Product2 testprod1 = new Product2 (Name='Triple Play Bundle Small', ProductCode = 'VLO-BUN-0001', vlocity_cmt__AttributeMetadata__c = 'TestAttributeMetadata1', vlocity_cmt__isLocationDependent__c = true);
        insert testprod1;

        vlocity_cmt__QuoteProductRollup__c rollupTest = new vlocity_cmt__QuoteProductRollup__c(
                                                                vlocity_cmt__TotalQuoteQuantity__c = 0,
                                                                vlocity_cmt__TotalAssetQuantity__c = 0,
                                                                vlocity_cmt__DiscountQuantity__c = 0,
                                                                vlocity_cmt__QuoteId__c = rollupQuote1.Id,
                                                                vlocity_cmt__RollupType__c = 'Total Quote Rollup',
                                                                vlocity_cmt__ProductId__c = testprod1.Id
                                                                );
        insert rollupTest;

        QuoteLineItem rollupTestQLI = new QuoteLineItem(QuoteId = rollupQuote1.Id,
                                                    vlocity_cmt__LineNumber__c = '1',
                                                    Quantity = 2,
                                                    vlocity_cmt__UsageUnitPrice__c = 200,
                                                    vlocity_cmt__Action__c = 'Add',
                                                    UnitPrice = 200,
                                                    PricebookEntryId = pbe1.Id,
                                                    vlocity_cmt__JSONAttribute__c = '{"VEPC_ATTRIBUTE_CATEGORY_UNI_DETAILS":[{"$$AttributeDefinitionStart$$":null,"categorycode__c":"VEPC_ATTRIBUTE_CATEGORY_UNI_DETAILS","categoryname__c":"UNI Details","attributeuniquecode__c":"VEPC_ATTR_UNI_DEPLOYMENT_OPTION","attributeconfigurable__c":true,"attributedisplaysequence__c":"120","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"UNI Deployment Option","displaysequence__c":"120","categorydisplaysequence__c":7090,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":"Indicates either a new UNI-N port is required or an existing UNI-N port can be re-used","attributegrouptype__c":null,"isnotassetizable__c":true,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"value":null,"sequence":1,"id":null,"displayText":"New UNI"},{"value":null,"sequence":2,"id":null,"displayText":"Reuse Existing UNI"}],"selectedItem":{"displayText":"New UNI"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4x000001jEYkAAM","attributeid__c":"a094x000000zcePAAQ","attributecategoryid__c":"a084x000000lhpzAAA","categorycode__c":"VEPC_ATTRIBUTE_CATEGORY_UNI_DETAILS","categoryname__c":"UNI Details","attributeuniquecode__c":"VEPC_ATTR_UNI_HANDOVER_DETAILS","attributeconfigurable__c":true,"attributedisplaysequence__c":"130","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"UNI Handover Details","displaysequence__c":"130","categorydisplaysequence__c":7090,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a204x000000gbwQAAQ","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":"Test value read only","valuedatatype__c":"Text","valuedescription__c":"Additional details about the UNI handoff (e.g. 2 fibers, 2 patch panel ports, etc.)","attributegrouptype__c":null,"isnotassetizable__c":true,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","default":"Test value read only","value":"Test value read only"},"$$AttributeDefinitionEnd$$":null}]}'
                                                    );
        insert rollupTestQLI;

         //creating order item to test disconnect line item
        Order disconnectOrder = new Order(Status = 'Draft', 
                                    Name = 'Test Order', 
                                    AccountId = testAccount.Id,
                                    EffectiveDate = System.today(),
                                    Pricebook2Id =  standardBook.Id,
                                    vlocity_cmt__PriceListId__c = priceList.Id
                                );
        insert disconnectOrder;

        OrderItem disconnectOrderItem = new OrderItem(OrderId = disconnectOrder.Id, 
                                            vlocity_cmt__LineNumber__c = '1',
                                            Quantity = 1,
                                            vlocity_cmt__UsageUnitPrice__c = 200,
                                            vlocity_cmt__Action__c = 'Add',
                                            UnitPrice = 200,
                                            PricebookEntryId = pbe1.Id,
                                            vlocity_cmt__ParentItemId__c = NULL
                                        );

        insert disconnectOrderItem;

        // creating order to test testCalculateOPRollups
        Order rollupOrder1 = new Order(Status = 'Draft', 
                                    Name = 'Test Order Rollup', 
                                    AccountId = testAccount.Id,
                                    EffectiveDate = System.today(),
                                    Pricebook2Id =  standardBook.Id,
                                    vlocity_cmt__PriceListId__c = priceList.Id
                                );
        insert rollupOrder1;
        
        vlocity_cmt__OrderProductRollup__c orderRollupTest = new vlocity_cmt__OrderProductRollup__c(
                                                                vlocity_cmt__TotalOrderQuantity__c = 2,
                                                                vlocity_cmt__OrderId__c = rollupOrder1.Id,
                                                                vlocity_cmt__RollupType__c = 'Total Order Rollup',
                                                                vlocity_cmt__ProductId__c = testprod1.Id,
                                                                vlocity_cmt__TotalAssetQuantity__c = 0,
                                                                vlocity_cmt__DiscountQuantity__c = 5
                                                            );
        insert orderRollupTest;

        OrderItem rollupTestOLI = new OrderItem(OrderId = rollupOrder1.Id, 
                                                    vlocity_cmt__LineNumber__c = '1',
                                                    Quantity = 2,
                                                    vlocity_cmt__UsageUnitPrice__c = 200,
                                                    vlocity_cmt__Action__c = 'Add',
                                                    UnitPrice = 200,
                                                    PricebookEntryId = pbe1.Id
                                                    );
        insert rollupTestOLI;

        Order testOrder = new Order(Status = 'Draft', 
                                    Name = 'Test CPQ Order', 
                                    AccountId = testAccount.Id,
                                    EffectiveDate = System.today(),
                                    Pricebook2Id =  standardBook.Id,
                                    vlocity_cmt__PriceListId__c = priceList.Id
                                );
        insert testOrder;

        Opportunity testCPQOpportunity = new Opportunity(Name = 'Test CPQ Opportunity', 
                                                    AccountId = testAccount.Id, 
                                                    closeDate = Date.TODAY(), 
                                                    StageName = 'Prospecting', 
                                                    Pricebook2Id =  standardBook.Id);
        insert testCPQOpportunity;

        vlocity_cmt__Promotion__c promotion = new vlocity_cmt__Promotion__c(Name = 'TestPromo', vlocity_cmt__Code__c = 'xxxx');
        Insert promotion;
        
        prepareQuoteDiscounts(testQuote.Id, null);

        vlocity_cmt__OrderDiscount__c approvedDiscount = new vlocity_cmt__OrderDiscount__c(
            vlocity_cmt__ApprovalStatus__c='Approved',
            Name='Approved Discount',
            vlocity_cmt__OrderId__c=testOrder.Id);
        insert approvedDiscount;

        vlocity_cmt__OpportunityDiscount__c approvedOpptDiscount = new vlocity_cmt__OpportunityDiscount__c(
            vlocity_cmt__ApprovalStatus__c='Approved',
            Name='Approved Discount',
            vlocity_cmt__OpportunityId__c=testCPQOpportunity.Id);
        insert approvedOpptDiscount;    

        OrderItem parentOLI = new OrderItem(OrderId = testOrder.Id, 
                                                    vlocity_cmt__Product2Id__c = product2.Id,
                                                    vlocity_cmt__LineNumber__c = '1',
                                                    Quantity = 10,
                                                    vlocity_cmt__UsageUnitPrice__c = 200,
                                                    vlocity_cmt__Action__c = 'Add',
                                                    UnitPrice = 200,
                                                    PricebookEntryId = pbe1.Id
                                                    );
        insert parentOLI;

        vlocity_cmt__OrderProductRollup__c orderRollup = new vlocity_cmt__OrderProductRollup__c(
                                                                vlocity_cmt__TotalOrderQuantity__c = 2,
                                                                vlocity_cmt__OrderId__c = testOrder.Id,
                                                                vlocity_cmt__RollupType__c = 'Total Order Rollup',
                                                                vlocity_cmt__ProductId__c = product2.Id,
                                                                vlocity_cmt__TotalAssetQuantity__c = 0,
                                                                vlocity_cmt__DiscountQuantity__c = 5
                                                            );
        insert orderRollup;

        vlocity_cmt__AttributeCategory__c attributeCategory1 = new vlocity_cmt__AttributeCategory__c(
            vlocity_cmt__isActive__c = true, vlocity_cmt__Code__c ='VEPC_ATTRIBUTE_CATEGORY_UNI_DETAILS', vlocity_cmt__ApplicableSubType__c ='Profile Attribute', 
            vlocity_cmt__ApplicableTypes__c = 'Any', vlocity_cmt__DisplaySequence__c =1
        );

        insert attributeCategory1;

        List<vlocity_cmt__Attribute__c> allAtts= new List<vlocity_cmt__Attribute__c>();
        allAtts.add(new vlocity_cmt__Attribute__c(Name='Test Attribute Name 1',vlocity_cmt__DisplaySequence__c = 1, vlocity_cmt__AttributeCategoryId__c = attributeCategory1.Id, vlocity_cmt__Code__c='VEPC_ATTR_UNI_DEPLOYMENT_OPTION'));
        allAtts.add(new vlocity_cmt__Attribute__c(Name='Test Attribute Name 2',vlocity_cmt__DisplaySequence__c = 2, vlocity_cmt__AttributeCategoryId__c = attributeCategory1.Id, vlocity_cmt__Code__c='VEPC_ATTR_UNI_HANDOVER_DETAILS'));
        insert allAtts; 

        QuoteLineItem parentQLI = new QuoteLineItem(QuoteId = testQuote.Id, 
                                                    vlocity_cmt__Product2Id__c = product2.Id,
                                                    Product2Id = product2.Id,
                                                    vlocity_cmt__LineNumber__c = '1',
                                                    Quantity = 2,
                                                    vlocity_cmt__UsageUnitPrice__c = 200,
                                                    vlocity_cmt__Action__c = 'Add',
                                                    UnitPrice = 200,
                                                    PricebookEntryId = pbe1.Id,
                                                    vlocity_cmt__ConnectDate__c = System.now(),
                                                    vlocity_cmt__JSONAttribute__c = '{"VEPC_ATTRIBUTE_CATEGORY_UNI_DETAILS":[{"$$AttributeDefinitionStart$$":null,"categorycode__c":"VEPC_ATTRIBUTE_CATEGORY_UNI_DETAILS","categoryname__c":"UNI Details","attributeuniquecode__c":"VEPC_ATTR_UNI_DEPLOYMENT_OPTION","attributeconfigurable__c":true,"attributedisplaysequence__c":"120","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"UNI Deployment Option","displaysequence__c":"120","categorydisplaysequence__c":7090,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":"Indicates either a new UNI-N port is required or an existing UNI-N port can be re-used","attributegrouptype__c":null,"isnotassetizable__c":true,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"value":null,"sequence":1,"id":null,"displayText":"New UNI"},{"value":null,"sequence":2,"id":null,"displayText":"Reuse Existing UNI"}],"selectedItem":{"displayText":"New UNI"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4x000001jEYkAAM","attributeid__c":"a094x000000zcePAAQ","attributecategoryid__c":"a084x000000lhpzAAA","categorycode__c":"VEPC_ATTRIBUTE_CATEGORY_UNI_DETAILS","categoryname__c":"UNI Details","attributeuniquecode__c":"VEPC_ATTR_UNI_HANDOVER_DETAILS","attributeconfigurable__c":true,"attributedisplaysequence__c":"130","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"UNI Handover Details","displaysequence__c":"130","categorydisplaysequence__c":7090,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a204x000000gbwQAAQ","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":"Test value read only","valuedatatype__c":"Text","valuedescription__c":"Additional details about the UNI handoff (e.g. 2 fibers, 2 patch panel ports, etc.)","attributegrouptype__c":null,"isnotassetizable__c":true,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","default":"Test value read only","value":"Test value read only"},"$$AttributeDefinitionEnd$$":null}]}'
                                                    );
        insert parentQLI;

        QuoteLineItem childQLI = new QuoteLineItem(QuoteId = testQuote.Id, 
                                                    vlocity_cmt__Product2Id__c = product2.Id,
                                                    Product2Id = product2.Id,
                                                    vlocity_cmt__LineNumber__c = '2',
                                                    Quantity = 1,
                                                    vlocity_cmt__UsageUnitPrice__c = 50,
                                                    vlocity_cmt__Action__c = 'Add',
                                                    vlocity_cmt__RootItemId__c = parentQLI.Id,
                                                    vlocity_cmt__ParentItemId__c = parentQLI.Id,
                                                    UnitPrice = 50,
                                                    PricebookEntryId = pbe1.Id,
                                                    vlocity_cmt__JSONAttribute__c = '{"VEPC_ATTRIBUTE_CATEGORY_UNI_DETAILS":[{"$$AttributeDefinitionStart$$":null,"categorycode__c":"VEPC_ATTRIBUTE_CATEGORY_UNI_DETAILS","categoryname__c":"UNI Details","attributeuniquecode__c":"VEPC_ATTR_UNI_DEPLOYMENT_OPTION","attributeconfigurable__c":true,"attributedisplaysequence__c":"120","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"UNI Deployment Option","displaysequence__c":"120","categorydisplaysequence__c":7090,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":"Indicates either a new UNI-N port is required or an existing UNI-N port can be re-used","attributegrouptype__c":null,"isnotassetizable__c":true,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"value":null,"sequence":1,"id":null,"displayText":"New UNI"},{"value":null,"sequence":2,"id":null,"displayText":"Reuse Existing UNI"}],"selectedItem":{"displayText":"New UNI"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4x000001jEYkAAM","attributeid__c":"a094x000000zcePAAQ","attributecategoryid__c":"a084x000000lhpzAAA","categorycode__c":"VEPC_ATTRIBUTE_CATEGORY_UNI_DETAILS","categoryname__c":"UNI Details","attributeuniquecode__c":"VEPC_ATTR_UNI_HANDOVER_DETAILS","attributeconfigurable__c":true,"attributedisplaysequence__c":"130","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"UNI Handover Details","displaysequence__c":"130","categorydisplaysequence__c":7090,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a204x000000gbwQAAQ","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":"Test value read only","valuedatatype__c":"Text","valuedescription__c":"Additional details about the UNI handoff (e.g. 2 fibers, 2 patch panel ports, etc.)","attributegrouptype__c":null,"isnotassetizable__c":true,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","default":"Test value read only","value":"Test value read only"},"$$AttributeDefinitionEnd$$":null}]}',
                                                    vlocity_cmt__ConnectDate__c = System.now()
                                                    );
        insert childQLI;

        QuoteLineItem childQLIProduct2 = new QuoteLineItem(QuoteId = testQuote.Id, 
                                                    vlocity_cmt__Product2Id__c = product1.Id,
                                                    Product2Id = product1.Id,
                                                    vlocity_cmt__LineNumber__c = '2',
                                                    Quantity = 1,
                                                    vlocity_cmt__UsageUnitPrice__c = 50,
                                                    vlocity_cmt__Action__c = 'Add',
                                                    vlocity_cmt__RootItemId__c = parentQLI.Id,
                                                    vlocity_cmt__ParentItemId__c = parentQLI.Id,
                                                    UnitPrice = 50,
                                                    PricebookEntryId = pbe1.Id,
                                                    vlocity_cmt__JSONAttribute__c = '{"VEPC_ATTRIBUTE_CATEGORY_UNI_DETAILS":[{"$$AttributeDefinitionStart$$":null,"categorycode__c":"VEPC_ATTRIBUTE_CATEGORY_UNI_DETAILS","categoryname__c":"UNI Details","attributeuniquecode__c":"VEPC_ATTR_UNI_DEPLOYMENT_OPTION","attributeconfigurable__c":true,"attributedisplaysequence__c":"120","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"UNI Deployment Option","displaysequence__c":"120","categorydisplaysequence__c":7090,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":"Indicates either a new UNI-N port is required or an existing UNI-N port can be re-used","attributegrouptype__c":null,"isnotassetizable__c":true,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"value":null,"sequence":1,"id":null,"displayText":"New UNI"},{"value":null,"sequence":2,"id":null,"displayText":"Reuse Existing UNI"}],"selectedItem":{"displayText":"New UNI"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4x000001jEYkAAM","attributeid__c":"a094x000000zcePAAQ","attributecategoryid__c":"a084x000000lhpzAAA","categorycode__c":"VEPC_ATTRIBUTE_CATEGORY_UNI_DETAILS","categoryname__c":"UNI Details","attributeuniquecode__c":"VEPC_ATTR_UNI_HANDOVER_DETAILS","attributeconfigurable__c":true,"attributedisplaysequence__c":"130","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"UNI Handover Details","displaysequence__c":"130","categorydisplaysequence__c":7090,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a204x000000gbwQAAQ","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":"Test value read only","valuedatatype__c":"Text","valuedescription__c":"Additional details about the UNI handoff (e.g. 2 fibers, 2 patch panel ports, etc.)","attributegrouptype__c":null,"isnotassetizable__c":true,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","default":"Test value read only","value":"Test value read only"},"$$AttributeDefinitionEnd$$":null}]}',
                                                    vlocity_cmt__ConnectDate__c = System.now()
                                                    );
        insert childQLIProduct2;

        OrderItem childOLI = new OrderItem(OrderId = testOrder.Id, 
                                                    vlocity_cmt__Product2Id__c = product2.Id,
                                                    Product2Id = product2.Id,
                                                    vlocity_cmt__LineNumber__c = '2',
                                                    Quantity = 1,
                                                    vlocity_cmt__UsageUnitPrice__c = 50,
                                                    vlocity_cmt__Action__c = 'Add',
                                                    vlocity_cmt__RootItemId__c = parentOLI.Id,
                                                    vlocity_cmt__ParentItemId__c = parentOLI.Id,
                                                    UnitPrice = 50,
                                                    PricebookEntryId = pbe1.Id
                                                    );
        insert childOLI;

        OpportunityLineItem parentOpptLI = new OpportunityLineItem(OpportunityId = testCPQOpportunity.Id, 
                                                    vlocity_cmt__Product2Id__c = product2.Id,
                                                    Product2Id = product2.Id,
                                                    vlocity_cmt__LineNumber__c = '1',
                                                    Quantity = 10,
                                                    vlocity_cmt__UsageUnitPrice__c = 200,
                                                    vlocity_cmt__Action__c = 'Add',
                                                    UnitPrice = 200,
                                                    PricebookEntryId = pbe1.Id,
                                                    vlocity_cmt__ConnectDate__c = System.now()
                                                    );
        insert parentOpptLI;

        OpportunityLineItem childOpptLI = new OpportunityLineItem(OpportunityId = testCPQOpportunity.Id, 
                                                    vlocity_cmt__Product2Id__c = product2.Id,
                                                    Product2Id = product2.Id,
                                                    vlocity_cmt__LineNumber__c = '2',
                                                    Quantity = 1,
                                                    vlocity_cmt__UsageUnitPrice__c = 50,
                                                    vlocity_cmt__Action__c = 'Add',
                                                    vlocity_cmt__RootItemId__c = parentOpptLI.Id,
                                                    vlocity_cmt__ParentItemId__c = parentOpptLI.Id,
                                                    UnitPrice = 50,
                                                    PricebookEntryId = pbe1.Id,
                                                    vlocity_cmt__ConnectDate__c = System.now()
                                                    );
        insert childOpptLI;

        OpportunityLineItem childOpptLI2 = new OpportunityLineItem(OpportunityId = testCPQOpportunity.Id, 
                                                    vlocity_cmt__Product2Id__c = product2.Id,
                                                    Product2Id = product2.Id,
                                                    vlocity_cmt__LineNumber__c = '2',
                                                    Quantity = 1,
                                                    vlocity_cmt__UsageUnitPrice__c = 50,
                                                    vlocity_cmt__Action__c = 'Add',
                                                    vlocity_cmt__ParentItemId__c = parentOpptLI.Id,
                                                    vlocity_cmt__RootItemId__c = parentOpptLI.Id,
                                                    UnitPrice = 50,
                                                    PricebookEntryId = pbe1.Id,
                                                    vlocity_cmt__ConnectDate__c = System.now()
                                                    );
        insert childOpptLI2;

        vlocity_cmt__QuoteProductRollup__c rollup = new vlocity_cmt__QuoteProductRollup__c(
                                                                vlocity_cmt__TotalQuoteQuantity__c = 3,
                                                                vlocity_cmt__QuoteId__c = testQuote.Id,
                                                                vlocity_cmt__RollupType__c = 'Total Quote Rollup',
                                                                vlocity_cmt__ProductId__c = product2.Id,
                                                                vlocity_cmt__TotalAssetQuantity__c = 0,
                                                                vlocity_cmt__DiscountQuantity__c = 5
                                                            );
        insert rollup;

        vlocity_cmt__PriceList__c p1 = new vlocity_cmt__PriceList__c(Name = 'P1', vlocity_cmt__Code__c = 'P1');
        insert p1;

        vlocity_cmt__PriceListEntry__c pe1 = new vlocity_cmt__PriceListEntry__c(Name = p1.Name, vlocity_cmt__PriceListId__c = p1.Id, vlocity_cmt__ProductId__c = product2.Id);
        insert pe1;
        
        


        insert new vlocity_cmt__QuotePricingAdjustment__c(vlocity_cmt__QuoteId__c = testQuote.Id, vlocity_cmt__QuoteItemId__c = parentQLI.Id, vlocity_cmt__PriceListEntryId__c = pe1.Id);
        insert new vlocity_cmt__QuotePricingAdjustment__c(vlocity_cmt__QuoteId__c = testQuote.Id, vlocity_cmt__QuoteItemId__c = childQLI.Id, vlocity_cmt__PriceListEntryId__c = pe1.Id);
        
        Quote clonedQuote1 = testQuote.clone(false, false, false, false);
        clonedQuote1.Name = 'Group Cart 1';
        insert clonedQuote1;

        QuoteLineItem workingCartQLI = new QuoteLineItem(QuoteId = clonedQuote1.Id, 
                                                    vlocity_cmt__Product2Id__c = product2.Id,
                                                    Product2Id = product2.Id,
                                                    Quantity = 2,
                                                    vlocity_cmt__UsageUnitPrice__c = 200,
                                                    vlocity_cmt__Action__c = 'Add',
                                                    UnitPrice = 200,
                                                    PricebookEntryId = pbe1.Id,
                                                    vlocity_cmt__JSONAttribute__c = '{"VEPC_ATTRIBUTE_CATEGORY_UNI_DETAILS":[{"$$AttributeDefinitionStart$$":null,"categorycode__c":"VEPC_ATTRIBUTE_CATEGORY_UNI_DETAILS","categoryname__c":"UNI Details","attributeuniquecode__c":"VEPC_ATTR_UNI_DEPLOYMENT_OPTION","attributeconfigurable__c":true,"attributedisplaysequence__c":"120","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"UNI Deployment Option","displaysequence__c":"120","categorydisplaysequence__c":7090,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":"Indicates either a new UNI-N port is required or an existing UNI-N port can be re-used","attributegrouptype__c":null,"isnotassetizable__c":true,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"value":null,"sequence":1,"id":null,"displayText":"New UNI"},{"value":null,"sequence":2,"id":null,"displayText":"Reuse Existing UNI"}],"selectedItem":{"displayText":"New UNI"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4x000001jEYkAAM","attributeid__c":"a094x000000zcePAAQ","attributecategoryid__c":"a084x000000lhpzAAA","categorycode__c":"VEPC_ATTRIBUTE_CATEGORY_UNI_DETAILS","categoryname__c":"UNI Details","attributeuniquecode__c":"VEPC_ATTR_UNI_HANDOVER_DETAILS","attributeconfigurable__c":true,"attributedisplaysequence__c":"130","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"UNI Handover Details","displaysequence__c":"130","categorydisplaysequence__c":7090,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a204x000000gbwQAAQ","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":"Test value read only","valuedatatype__c":"Text","valuedescription__c":"Additional details about the UNI handoff (e.g. 2 fibers, 2 patch panel ports, etc.)","attributegrouptype__c":null,"isnotassetizable__c":true,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","default":"Test value read only","value":"Test value read only"},"$$AttributeDefinitionEnd$$":null}]}',
                                                    vlocity_cmt__ParentItemId__c = null
                                                    );
        insert workingCartQLI;
        

        vlocity_cmt__Promotion__c promotion2 = new vlocity_cmt__Promotion__c(Name = 'TestPromo2', vlocity_cmt__Code__c = 'xxxx');
        Insert promotion2;

        vlocity_cmt__QuoteDiscount__c quoteDiscount2 = new vlocity_cmt__QuoteDiscount__c(
                vlocity_cmt__QuoteId__c = clonedQuote1.Id,
                vlocity_cmt__Description__c = 'quote discount',
                vlocity_cmt__DiscountTemplateId__c = promotion2.Id,
                vlocity_cmt__EffectiveEndDate__c = System.today(),
                vlocity_cmt__EffectiveStartDate__c = System.today() - 1,
                vlocity_cmt__ReferenceNumber__c = '666666666',
                vlocity_cmt__Action__c = 'Deactivate'
        );
        insert quoteDiscount2;


        vlocity_cmt__QuoteAppliedPromotion__c clonedQuoteAppliedPromotion1 = new vlocity_cmt__QuoteAppliedPromotion__c(
            vlocity_cmt__QuoteId__c = clonedQuote1.Id, 
            Name = 'Test', 
            vlocity_cmt__Action__c = 'Add',
            vlocity_cmt__PromotionId__c=promotion2.Id
        );
        insert clonedQuoteAppliedPromotion1;

        insert new vlocity_cmt__QuotePricingAdjustment__c(
            vlocity_cmt__QuoteId__c = clonedQuote1.Id, 
            vlocity_cmt__QuoteItemId__c = workingCartQLI.Id, 
            vlocity_cmt__PriceListEntryId__c = pe1.Id,
            vlocity_cmt__QuoteAppliedPromotionId__c = clonedQuoteAppliedPromotion1.Id
        );

        vlocity_cmt__QuoteAppliedPromotionItem__c clonedQuoteAppliedPromotionAffected = new vlocity_cmt__QuoteAppliedPromotionItem__c(
            vlocity_cmt__QuoteAppliedPromotionId__c = clonedQuoteAppliedPromotion1.Id,
            vlocity_cmt__QuoteLineItemId__c = workingCartQLI.Id
        );
        
        insert clonedQuoteAppliedPromotionAffected;
        

        Order clonedOrder1 = testOrder.clone(false, false, false, false);
        clonedOrder1.Name = 'CPQ Group Cart Order1';
        insert clonedOrder1;

        Opportunity clonedOpportunity1 = testCPQOpportunity.clone(false, false, false, false);
        clonedOpportunity1.Name = 'CPQ Group Cart Opportunity1';
        insert clonedOpportunity1;

        vlocity_cmt__OrderDiscount__c approvedDiscount2 = new vlocity_cmt__OrderDiscount__c(
            vlocity_cmt__ApprovalStatus__c='Approved',
            Name='Approved Discount',
            vlocity_cmt__OrderId__c=clonedOrder1.Id);
        insert approvedDiscount2; 

        vlocity_cmt__OrderAppliedPromotion__c clonedOrderAppliedPromotion1 = new vlocity_cmt__OrderAppliedPromotion__c(
            vlocity_cmt__OrderId__c = clonedOrder1.Id, 
            Name = 'Test Order Promo', 
            vlocity_cmt__Action__c = 'Add',
            vlocity_cmt__PromotionId__c=promotion2.Id
        );
        insert clonedOrderAppliedPromotion1;

        OrderItem parentClonedOLI1 = new OrderItem(OrderId = clonedOrder1.Id, 
                                                    vlocity_cmt__Product2Id__c = product2.Id,
                                                    vlocity_cmt__LineNumber__c = '1',
                                                    Quantity = 2,
                                                    vlocity_cmt__UsageUnitPrice__c = 200,
                                                    vlocity_cmt__Action__c = 'Add',
                                                    UnitPrice = 200,
                                                    PricebookEntryId = pbe1.Id
                                                    );
        insert parentClonedOLI1;

        QuoteLineItem parentClonedQLI1 = new QuoteLineItem(QuoteId = clonedQuote1.Id, 
                                                    vlocity_cmt__Product2Id__c = product2.Id,
                                                    Product2Id = product2.Id,
                                                    vlocity_cmt__LineNumber__c = '1',
                                                    Quantity = 2,
                                                    vlocity_cmt__UsageUnitPrice__c = 200,
                                                    vlocity_cmt__Action__c = 'Add',
                                                    UnitPrice = 200,
                                                    vlocity_cmt__JSONAttribute__c = '{"VEPC_ATTRIBUTE_CATEGORY_UNI_DETAILS":[{"$$AttributeDefinitionStart$$":null,"categorycode__c":"VEPC_ATTRIBUTE_CATEGORY_UNI_DETAILS","categoryname__c":"UNI Details","attributeuniquecode__c":"VEPC_ATTR_UNI_DEPLOYMENT_OPTION","attributeconfigurable__c":true,"attributedisplaysequence__c":"120","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"UNI Deployment Option","displaysequence__c":"120","categorydisplaysequence__c":7090,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":"Indicates either a new UNI-N port is required or an existing UNI-N port can be re-used","attributegrouptype__c":null,"isnotassetizable__c":true,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"value":null,"sequence":1,"id":null,"displayText":"New UNI"},{"value":null,"sequence":2,"id":null,"displayText":"Reuse Existing UNI"}],"selectedItem":{"displayText":"New UNI"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4x000001jEYkAAM","attributeid__c":"a094x000000zcePAAQ","attributecategoryid__c":"a084x000000lhpzAAA","categorycode__c":"VEPC_ATTRIBUTE_CATEGORY_UNI_DETAILS","categoryname__c":"UNI Details","attributeuniquecode__c":"VEPC_ATTR_UNI_HANDOVER_DETAILS","attributeconfigurable__c":true,"attributedisplaysequence__c":"130","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"UNI Handover Details","displaysequence__c":"130","categorydisplaysequence__c":7090,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a204x000000gbwQAAQ","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":"Test value read only","valuedatatype__c":"Text","valuedescription__c":"Additional details about the UNI handoff (e.g. 2 fibers, 2 patch panel ports, etc.)","attributegrouptype__c":null,"isnotassetizable__c":true,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","default":"Test value read only","value":"Test value read only"},"$$AttributeDefinitionEnd$$":null}]}',
                                                    PricebookEntryId = pbe1.Id
                                                    );
        insert parentClonedQLI1;

        QuoteLineItem childClonedQLI1 = new QuoteLineItem(QuoteId = clonedQuote1.Id, 
                                                    vlocity_cmt__Product2Id__c = product2.Id,
                                                    Product2Id = product2.Id,
                                                    vlocity_cmt__LineNumber__c = '2',
                                                    Quantity = 1,
                                                    vlocity_cmt__UsageUnitPrice__c = 50,
                                                    vlocity_cmt__Action__c = 'Add',
                                                    vlocity_cmt__RootItemId__c = parentClonedQLI1.Id,
                                                    vlocity_cmt__ParentItemId__c = parentClonedQLI1.Id,
                                                    UnitPrice = 50,
                                                    vlocity_cmt__JSONAttribute__c = '{"VEPC_ATTRIBUTE_CATEGORY_UNI_DETAILS":[{"$$AttributeDefinitionStart$$":null,"categorycode__c":"VEPC_ATTRIBUTE_CATEGORY_UNI_DETAILS","categoryname__c":"UNI Details","attributeuniquecode__c":"VEPC_ATTR_UNI_DEPLOYMENT_OPTION","attributeconfigurable__c":true,"attributedisplaysequence__c":"120","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"UNI Deployment Option","displaysequence__c":"120","categorydisplaysequence__c":7090,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":"Indicates either a new UNI-N port is required or an existing UNI-N port can be re-used","attributegrouptype__c":null,"isnotassetizable__c":true,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"value":null,"sequence":1,"id":null,"displayText":"New UNI"},{"value":null,"sequence":2,"id":null,"displayText":"Reuse Existing UNI"}],"selectedItem":{"displayText":"New UNI"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4x000001jEYkAAM","attributeid__c":"a094x000000zcePAAQ","attributecategoryid__c":"a084x000000lhpzAAA","categorycode__c":"VEPC_ATTRIBUTE_CATEGORY_UNI_DETAILS","categoryname__c":"UNI Details","attributeuniquecode__c":"VEPC_ATTR_UNI_HANDOVER_DETAILS","attributeconfigurable__c":true,"attributedisplaysequence__c":"130","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"UNI Handover Details","displaysequence__c":"130","categorydisplaysequence__c":7090,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a204x000000gbwQAAQ","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":"Test value read only","valuedatatype__c":"Text","valuedescription__c":"Additional details about the UNI handoff (e.g. 2 fibers, 2 patch panel ports, etc.)","attributegrouptype__c":null,"isnotassetizable__c":true,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","default":"Test value read only","value":"Test value read only"},"$$AttributeDefinitionEnd$$":null}]}',
                                                    PricebookEntryId = pbe1.Id
                                                    );
        insert  childClonedQLI1;                                           

        QuoteLineItem childClonedQLI12 = new QuoteLineItem(QuoteId = clonedQuote1.Id, 
                                                    vlocity_cmt__Product2Id__c = product2.Id,
                                                    Product2Id = product2.Id,
                                                    vlocity_cmt__LineNumber__c = '3',
                                                    Quantity = 1,
                                                    vlocity_cmt__UsageUnitPrice__c = 50,
                                                    vlocity_cmt__Action__c = 'Add',
                                                    UnitPrice = 50,
                                                    vlocity_cmt__JSONAttribute__c = '{"VEPC_ATTRIBUTE_CATEGORY_UNI_DETAILS":[{"$$AttributeDefinitionStart$$":null,"categorycode__c":"VEPC_ATTRIBUTE_CATEGORY_UNI_DETAILS","categoryname__c":"UNI Details","attributeuniquecode__c":"VEPC_ATTR_UNI_DEPLOYMENT_OPTION","attributeconfigurable__c":true,"attributedisplaysequence__c":"120","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"UNI Deployment Option","displaysequence__c":"120","categorydisplaysequence__c":7090,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":"Indicates either a new UNI-N port is required or an existing UNI-N port can be re-used","attributegrouptype__c":null,"isnotassetizable__c":true,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"value":null,"sequence":1,"id":null,"displayText":"New UNI"},{"value":null,"sequence":2,"id":null,"displayText":"Reuse Existing UNI"}],"selectedItem":{"displayText":"New UNI"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4x000001jEYkAAM","attributeid__c":"a094x000000zcePAAQ","attributecategoryid__c":"a084x000000lhpzAAA","categorycode__c":"VEPC_ATTRIBUTE_CATEGORY_UNI_DETAILS","categoryname__c":"UNI Details","attributeuniquecode__c":"VEPC_ATTR_UNI_HANDOVER_DETAILS","attributeconfigurable__c":true,"attributedisplaysequence__c":"130","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"UNI Handover Details","displaysequence__c":"130","categorydisplaysequence__c":7090,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a204x000000gbwQAAQ","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":"Test value read only","valuedatatype__c":"Text","valuedescription__c":"Additional details about the UNI handoff (e.g. 2 fibers, 2 patch panel ports, etc.)","attributegrouptype__c":null,"isnotassetizable__c":true,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","default":"Test value read only","value":"Test value read only"},"$$AttributeDefinitionEnd$$":null}]}',
                                                    PricebookEntryId = pbe1.Id
                                                    );
        insert childClonedQLI12;
        
        vlocity_cmt__Promotion__c promo1 = new vlocity_cmt__Promotion__c(Name='Promo1', vlocity_cmt__Code__c='Promo1');
        insert promo1;

        insert new vlocity_cmt__OrderPriceAdjustment__c(vlocity_cmt__OrderId__c = testOrder.Id, vlocity_cmt__OrderItemId__c = parentOLI.Id, vlocity_cmt__PriceListEntryId__c = pe1.Id);
        insert new vlocity_cmt__OrderPriceAdjustment__c(vlocity_cmt__OrderId__c = testOrder.Id, vlocity_cmt__OrderItemId__c = childOLI.Id, vlocity_cmt__PriceListEntryId__c = pe1.Id);
        insert new vlocity_cmt__OrderPriceAdjustment__c(vlocity_cmt__OrderId__c = clonedOrder1.Id, vlocity_cmt__OrderItemId__c = parentClonedOLI1.Id, vlocity_cmt__PriceListEntryId__c = pe1.Id);

        insert new vlocity_cmt__OpportunityPriceAdjustment__c(vlocity_cmt__OpportunityId__c = testCPQOpportunity.Id, vlocity_cmt__OpportunityLineItemId__c = parentOpptLI.Id, vlocity_cmt__PriceListEntryId__c = pe1.Id);
        insert new vlocity_cmt__OpportunityPriceAdjustment__c(vlocity_cmt__OpportunityId__c = testCPQOpportunity.Id, vlocity_cmt__OpportunityLineItemId__c = childOpptLI.Id, vlocity_cmt__PriceListEntryId__c = pe1.Id);

        Quote clonedQuote2 = testQuote.clone(false, false, false, false);
        clonedQuote2.Name = 'Group Cart 2';
        insert clonedQuote2;
        
        vlocity_cmt__QuoteAppliedPromotion__c quoteAppliedPromotion1 = new vlocity_cmt__QuoteAppliedPromotion__c(
            vlocity_cmt__QuoteId__c = testQuote.Id, 
            Name = 'Test', 
            vlocity_cmt__Action__c = 'Add',
            vlocity_cmt__PromotionId__c=promo1.Id
        );
        insert quoteAppliedPromotion1;
        
        vlocity_cmt__QuoteAppliedPromotionItem__c quoteAppliedPromotionItem1 = new vlocity_cmt__QuoteAppliedPromotionItem__c(
            vlocity_cmt__QuoteAppliedPromotionId__c = quoteAppliedPromotion1.Id, 
            Name = 'Test', 
            vlocity_cmt__QuoteLineItemId__c = parentQLI.Id);
        insert quoteAppliedPromotionItem1;
        
        vlocity_cmt__OrderAppliedPromotion__c orderAppliedPromotion1 = new vlocity_cmt__OrderAppliedPromotion__c(
            vlocity_cmt__OrderId__c = testOrder.Id, 
            Name = 'Test Order Promo', 
            vlocity_cmt__Action__c = 'Add',
            vlocity_cmt__PromotionId__c=promo1.Id
        );
        insert orderAppliedPromotion1;

        vlocity_cmt__OrderAppliedPromotionItem__c orderAppliedPromotionItem1 = new vlocity_cmt__OrderAppliedPromotionItem__c(
            vlocity_cmt__OrderAppliedPromotionId__c = orderAppliedPromotion1.Id, 
            Name = 'Test Order Promo', 
            vlocity_cmt__OrderItemId__c = parentOLI.Id);
        insert orderAppliedPromotionItem1;
        
        vlocity_cmt__QuoteGroup__c testGroup = new vlocity_cmt__QuoteGroup__c(Name = 'Test Group', vlocity_cmt__QuoteId__c = testQuote.Id, vlocity_cmt__ExpectedMemberCount__c = 4);
        insert testGroup;

        QuoteLineItem groupQLI = new QuoteLineItem(
                                                    QuoteId = testQuote.Id, 
                                                    vlocity_cmt__Product2Id__c = product2.Id,
                                                    Product2Id = product2.Id,
                                                    vlocity_cmt__LineNumber__c = '1',
                                                    Quantity = 2,
                                                    vlocity_cmt__UsageUnitPrice__c = 200,
                                                    vlocity_cmt__Action__c = 'Add',
                                                    UnitPrice = 200,
                                                    PricebookEntryId = pbe1.Id,
                                                    vlocity_cmt__JSONAttribute__c = '{"VEPC_ATTRIBUTE_CATEGORY_UNI_DETAILS":[{"$$AttributeDefinitionStart$$":null,"categorycode__c":"VEPC_ATTRIBUTE_CATEGORY_UNI_DETAILS","categoryname__c":"UNI Details","attributeuniquecode__c":"VEPC_ATTR_UNI_DEPLOYMENT_OPTION","attributeconfigurable__c":true,"attributedisplaysequence__c":"120","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"UNI Deployment Option","displaysequence__c":"120","categorydisplaysequence__c":7090,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":"Indicates either a new UNI-N port is required or an existing UNI-N port can be re-used","attributegrouptype__c":null,"isnotassetizable__c":true,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"value":null,"sequence":1,"id":null,"displayText":"New UNI"},{"value":null,"sequence":2,"id":null,"displayText":"Reuse Existing UNI"}],"selectedItem":{"displayText":"New UNI"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4x000001jEYkAAM","attributeid__c":"a094x000000zcePAAQ","attributecategoryid__c":"a084x000000lhpzAAA","categorycode__c":"VEPC_ATTRIBUTE_CATEGORY_UNI_DETAILS","categoryname__c":"UNI Details","attributeuniquecode__c":"VEPC_ATTR_UNI_HANDOVER_DETAILS","attributeconfigurable__c":true,"attributedisplaysequence__c":"130","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"UNI Handover Details","displaysequence__c":"130","categorydisplaysequence__c":7090,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a204x000000gbwQAAQ","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":"Test value read only","valuedatatype__c":"Text","valuedescription__c":"Additional details about the UNI handoff (e.g. 2 fibers, 2 patch panel ports, etc.)","attributegrouptype__c":null,"isnotassetizable__c":true,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","default":"Test value read only","value":"Test value read only"},"$$AttributeDefinitionEnd$$":null}]}',
                                                    vlocity_cmt__QuoteGroupId__c = testGroup.Id
                                                );
        insert groupQLI;

        insert new vlocity_cmt__QuotePricingAdjustment__c(vlocity_cmt__QuoteId__c = testQuote.Id, vlocity_cmt__QuoteItemId__c = groupQLI.Id, vlocity_cmt__PriceListEntryId__c = pe1.Id);

        vlocity_cmt__Promotion__c promo2 = new vlocity_cmt__Promotion__c(Name='Promo2', vlocity_cmt__Code__c='Promo2');
        insert promo2;

        vlocity_cmt__QuoteAppliedPromotion__c quoteAppliedPromotion2 = new vlocity_cmt__QuoteAppliedPromotion__c(
            vlocity_cmt__QuoteId__c = testQuote.Id, 
            Name = 'Test2', 
            vlocity_cmt__Action__c = 'Add',
            vlocity_cmt__PromotionId__c=promo2.Id
        );
        insert quoteAppliedPromotion2;
        
        vlocity_cmt__QuoteAppliedPromotionItem__c quoteAppliedPromotionItem2 = new vlocity_cmt__QuoteAppliedPromotionItem__c(
            vlocity_cmt__QuoteAppliedPromotionId__c = quoteAppliedPromotion2.Id, 
            Name = 'Test', 
            vlocity_cmt__QuoteLineItemId__c = groupQLI.Id);
        insert quoteAppliedPromotionItem2;

        createQuoteMembers(testQuote.Id, 'Test Member', testGroup.Id, 2, 'Location');

        vlocity_cmt__OrderGroup__c testOrderGroup = new vlocity_cmt__OrderGroup__c(Name = 'Test Order Group', vlocity_cmt__OrderId__c = testOrder.Id);
        insert testOrderGroup;

        OrderItem groupOLI = new OrderItem(
                                                    OrderId = testOrder.Id, 
                                                    vlocity_cmt__Product2Id__c = product2.Id,
                                                    vlocity_cmt__LineNumber__c = '1',
                                                    Quantity = 10,
                                                    vlocity_cmt__UsageUnitPrice__c = 200,
                                                    vlocity_cmt__Action__c = 'Add',
                                                    UnitPrice = 200,
                                                    PricebookEntryId = pbe1.Id,
                                                    vlocity_cmt__OrderGroupId__c = testOrderGroup.Id
                                                );
        insert groupOLI;

        createOrderMembers(testOrder.Id, testOrderGroup.Id, 2, 'Location');

        vlocity_cmt__OpportunityGroup__c testOpptGroup = new vlocity_cmt__OpportunityGroup__c(Name = 'Test Oppt Group',vlocity_cmt__OpportunityId__c = testCPQOpportunity.Id);
        insert testOpptGroup;

        OpportunityLineItem groupOpptLI = new OpportunityLineItem(
                                                    OpportunityId = testCPQOpportunity.Id, 
                                                    vlocity_cmt__Product2Id__c = product2.Id,
                                                    vlocity_cmt__LineNumber__c = '1',
                                                    Quantity = 10,
                                                    vlocity_cmt__UsageUnitPrice__c = 200,
                                                    vlocity_cmt__Action__c = 'Add',
                                                    UnitPrice = 200,
                                                    PricebookEntryId = pbe1.Id,
                                                    vlocity_cmt__OpportunityGroupId__c = testOpptGroup.Id
                                                );
        insert groupOpptLI;

        createOpptMembers(testCPQOpportunity.Id, testOpptGroup.Id, 2, 'Location');

        Order masterOrder = new Order(
            Name = 'Master Order',
            Pricebook2Id = standardBook.Id,
            AccountId = testAccount.Id,
            Status = 'Draft',
            EffectiveDate = date.today(),
            OpportunityId = testOpportunity.Id,
            vlocity_cmt__QuoteId__c = testQuote.Id,
            RecordTypeId = getRecordTypeIdByName('Order', 'MasterOrder')
        );
        insert masterOrder;

        createSubOrders(masterOrder, 1, testAccount, testQuote);

        // Creating asset test data
        List<Asset> assets = new List<Asset>();
        Asset asset1 = new Asset(
            Name = 'Factory Test asset',
            AccountId = testAccount.Id,
            Product2Id = product1.Id,
            vlocity_cmt__PricebookEntryId__c = pbe1.Id,
            Quantity = 1,
            Price = 100.00,
            vlocity_cmt__LineNumber__c = '0001',
            vlocity_cmt__ProvisioningStatus__c = 'New',
            vlocity_cmt__ServiceAccountId__c = testAccount.Id,
            vlocity_cmt__JSONAttribute__c = '{"VEPC_ATTRIBUTE_CATEGORY_UNI_DETAILS":[{"$$AttributeDefinitionStart$$":null,"categorycode__c":"VEPC_ATTRIBUTE_CATEGORY_UNI_DETAILS","categoryname__c":"UNI Details","attributeuniquecode__c":"VEPC_ATTR_UNI_DEPLOYMENT_OPTION","attributeconfigurable__c":true,"attributedisplaysequence__c":"120","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"UNI Deployment Option","displaysequence__c":"120","categorydisplaysequence__c":7090,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":"Indicates either a new UNI-N port is required or an existing UNI-N port can be re-used","attributegrouptype__c":null,"isnotassetizable__c":true,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"value":null,"sequence":1,"id":null,"displayText":"New UNI"},{"value":null,"sequence":2,"id":null,"displayText":"Reuse Existing UNI"}],"selectedItem":{"displayText":"New UNI"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4x000001jEYkAAM","attributeid__c":"a094x000000zcePAAQ","attributecategoryid__c":"a084x000000lhpzAAA","categorycode__c":"VEPC_ATTRIBUTE_CATEGORY_UNI_DETAILS","categoryname__c":"UNI Details","attributeuniquecode__c":"VEPC_ATTR_UNI_HANDOVER_DETAILS","attributeconfigurable__c":true,"attributedisplaysequence__c":"130","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"UNI Handover Details","displaysequence__c":"130","categorydisplaysequence__c":7090,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a204x000000gbwQAAQ","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":"Test value read only","valuedatatype__c":"Text","valuedescription__c":"Additional details about the UNI handoff (e.g. 2 fibers, 2 patch panel ports, etc.)","attributegrouptype__c":null,"isnotassetizable__c":true,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","default":"Test value read only","value":"Test value read only"},"$$AttributeDefinitionEnd$$":null}]}'
        );
        Asset asset2 = new Asset(
            Name = 'Factory Test asset 2',
            AccountId = testAccount.Id,
            Product2Id = product1.Id,
            vlocity_cmt__PricebookEntryId__c = pbe1.Id,
            Quantity = 1,
            Price = 200.00,
            vlocity_cmt__LineNumber__c = '0002',
            vlocity_cmt__ProvisioningStatus__c = 'New',
            vlocity_cmt__ServiceAccountId__c = testAccount.Id,
            vlocity_cmt__JSONAttribute__c = '{"VEPC_ATTRIBUTE_CATEGORY_UNI_DETAILS":[{"$$AttributeDefinitionStart$$":null,"categorycode__c":"VEPC_ATTRIBUTE_CATEGORY_UNI_DETAILS","categoryname__c":"UNI Details","attributeuniquecode__c":"VEPC_ATTR_UNI_DEPLOYMENT_OPTION","attributeconfigurable__c":true,"attributedisplaysequence__c":"120","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"UNI Deployment Option","displaysequence__c":"120","categorydisplaysequence__c":7090,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":"Indicates either a new UNI-N port is required or an existing UNI-N port can be re-used","attributegrouptype__c":null,"isnotassetizable__c":true,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"value":null,"sequence":1,"id":null,"displayText":"New UNI"},{"value":null,"sequence":2,"id":null,"displayText":"Reuse Existing UNI"}],"selectedItem":{"displayText":"New UNI"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4x000001jEYkAAM","attributeid__c":"a094x000000zcePAAQ","attributecategoryid__c":"a084x000000lhpzAAA","categorycode__c":"VEPC_ATTRIBUTE_CATEGORY_UNI_DETAILS","categoryname__c":"UNI Details","attributeuniquecode__c":"VEPC_ATTR_UNI_HANDOVER_DETAILS","attributeconfigurable__c":true,"attributedisplaysequence__c":"130","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"UNI Handover Details","displaysequence__c":"130","categorydisplaysequence__c":7090,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a204x000000gbwQAAQ","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":"Test value read only","valuedatatype__c":"Text","valuedescription__c":"Additional details about the UNI handoff (e.g. 2 fibers, 2 patch panel ports, etc.)","attributegrouptype__c":null,"isnotassetizable__c":true,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","default":"Test value read only","value":"Test value read only"},"$$AttributeDefinitionEnd$$":null}]}'
        );
        Asset asset3 = new Asset(
            Name = 'Factory Test asset 3',
            AccountId = testAccount.Id,
            Product2Id = product1.Id,
            vlocity_cmt__PricebookEntryId__c = pbe1.Id,
            Quantity = 1,
            Price = 300.00,
            vlocity_cmt__LineNumber__c = '0003',
            vlocity_cmt__ProvisioningStatus__c = 'New',
            vlocity_cmt__ServiceAccountId__c = testAccount.Id,
            vlocity_cmt__JSONAttribute__c = '{"VEPC_ATTRIBUTE_CATEGORY_UNI_DETAILS":[{"$$AttributeDefinitionStart$$":null,"categorycode__c":"VEPC_ATTRIBUTE_CATEGORY_UNI_DETAILS","categoryname__c":"UNI Details","attributeuniquecode__c":"VEPC_ATTR_UNI_DEPLOYMENT_OPTION","attributeconfigurable__c":true,"attributedisplaysequence__c":"120","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"UNI Deployment Option","displaysequence__c":"120","categorydisplaysequence__c":7090,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":"Indicates either a new UNI-N port is required or an existing UNI-N port can be re-used","attributegrouptype__c":null,"isnotassetizable__c":true,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"value":null,"sequence":1,"id":null,"displayText":"New UNI"},{"value":null,"sequence":2,"id":null,"displayText":"Reuse Existing UNI"}],"selectedItem":{"displayText":"New UNI"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t4x000001jEYkAAM","attributeid__c":"a094x000000zcePAAQ","attributecategoryid__c":"a084x000000lhpzAAA","categorycode__c":"VEPC_ATTRIBUTE_CATEGORY_UNI_DETAILS","categoryname__c":"UNI Details","attributeuniquecode__c":"VEPC_ATTR_UNI_HANDOVER_DETAILS","attributeconfigurable__c":true,"attributedisplaysequence__c":"130","attributefilterable__c":false,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"UNI Handover Details","displaysequence__c":"130","categorydisplaysequence__c":7090,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isnottranslatable__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a204x000000gbwQAAQ","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":"Test value read only","valuedatatype__c":"Text","valuedescription__c":"Additional details about the UNI handoff (e.g. 2 fibers, 2 patch panel ports, etc.)","attributegrouptype__c":null,"isnotassetizable__c":true,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","default":"Test value read only","value":"Test value read only"},"$$AttributeDefinitionEnd$$":null}]}'
        );
        assets.add(asset1);
        assets.add(asset2);
        assets.add(asset3);
        insert assets;

        //Test Data for Asset Relationships
        
        List<AssetRelationship> assetRelationships = new List<AssetRelationship>();

        AssetRelationship assetRelationship1 = new AssetRelationship(AssetId=asset1.Id, RelatedAssetId=asset2.Id,
                                            RelationshipType='ReliesOn');
        AssetRelationship assetRelationship2 = new AssetRelationship(AssetId=asset2.Id, RelatedAssetId=asset3.Id,
                                            RelationshipType='ReliesOn');

        assetRelationships.add(assetRelationship1);
        assetRelationships.add(assetRelationship2);       

        insert assetRelationships;

        //Added For Enterprise Order
        Id recordTypeId = getRecordTypeIdByName('Order', 'EnterpriseOrder');
        Order testEntOrder = new Order(Status = 'Draft', 
                      Name = 'Test Enterprise Order', 
                      AccountId = testAccount.Id,
                      EffectiveDate = System.today(),
                      Pricebook2Id =  standardBook.Id,
                      vlocity_cmt__PriceListId__c = priceList.Id,
                      RecordTypeId =recordTypeId
                  );
        insert testEntOrder;

        OrderItem testEntOrderOLI = new OrderItem(OrderId = testEntOrder.Id, 
                      vlocity_cmt__Product2Id__c = product2.Id,
                      vlocity_cmt__LineNumber__c = '1',
                      Quantity = 10,
                      vlocity_cmt__UsageUnitPrice__c = 200,
                      vlocity_cmt__Action__c = 'Add',
                      UnitPrice = 200,
                      PricebookEntryId = pbe1.Id
                      );
        insert testEntOrderOLI;

        OrderItem testEntOrderOLI2 = new OrderItem(OrderId = testEntOrder.Id, 
                      vlocity_cmt__Product2Id__c = product1.Id,
                      vlocity_cmt__LineNumber__c = '1',
                      Quantity = 10,
                      vlocity_cmt__UsageUnitPrice__c = 200,
                      vlocity_cmt__Action__c = 'Add',
                      UnitPrice = 200,
                      PricebookEntryId = pbe1.Id
                      );
        insert testEntOrderOLI2;

        vlocity_cmt__OrderGroup__c testEntOrderGroup = new vlocity_cmt__OrderGroup__c(Name = 'Test Enterprise Order Group', vlocity_cmt__OrderId__c = testEntOrder.Id);
        insert testEntOrderGroup;

        OrderItem entGroupOLI = new OrderItem(
                      OrderId = testEntOrder.Id, 
                      vlocity_cmt__Product2Id__c = product2.Id,
                      vlocity_cmt__LineNumber__c = '1',
                      Quantity = 10,
                      vlocity_cmt__UsageUnitPrice__c = 200,
                      vlocity_cmt__Action__c = 'Add',
                      UnitPrice = 200,
                      PricebookEntryId = pbe1.Id,
                      vlocity_cmt__OrderGroupId__c = testEntOrderGroup.Id
                  );
        insert entGroupOLI;

        createOrderMembers(testEntOrder.Id, testEntOrderGroup.Id, 2, 'Location');
        createOrderMembers('EOrderMember', testEntOrder.Id, null, 2, 'Location');
 }
    
      /*
    * Name         :  getRecordTypeIdByName
    * Author       :  
    * Date         :  18 Oct, 2022
    * Description  :  Get RecordTypeId by Name
    */
    public static Id getRecordTypeIdByName(String objectName, String DeveloperName){
        //return ObjectDescriberV2.getRecordTypeIdByDeveloperName(objectName, DeveloperName);    
        List<RecordType> recordTypeList = [SELECT Id FROM RecordType WHERE DeveloperName=:DeveloperName AND SobjectType=:objectName LIMIT 1];
       	return recordTypeList[0].Id;
    }
    
      /*
    * Name         :  createCPQConfiguration
    * Author       :  
    * Date         :  18 Oct, 2022
    * Description  :  Create CPQ Configuration
    */
    public static void createCPQConfiguration(String name, String setupValue){
        insert new vlocity_cmt__CpqConfigurationSetup__c(Name = name, vlocity_cmt__SetupValue__c = setupValue);
    }
    
       /*
    * Name         :  prepareQuoteDiscounts
    * Author       :  
    * Date         :  18 Oct, 2022
    * Description  : Prepare Quote Discounts
    */
    public static void prepareQuoteDiscounts(String QuoteId, String ProductId){
        vlocity_cmt__QuoteDiscount__c discount = new vlocity_cmt__QuoteDiscount__c
        (
            vlocity_cmt__ApprovalStatus__c = 'Approved',
            Name = 'Test Discount',
            vlocity_cmt__DiscountType__c = 'Order',
            vlocity_cmt__Action__c = 'New',
            vlocity_cmt__QuoteId__c = QuoteId
        );
        insert discount;

        if(String.isEmpty(ProductId))
        {
            vlocity_cmt__QuoteDiscountItem__c discountItem = new vlocity_cmt__QuoteDiscountItem__c
            (
                Name = 'Test Discount Item',
                vlocity_cmt__QuoteDiscountId__c = discount.Id,
                vlocity_cmt__ProductId__c = ProductId
            );
            insert discountItem;

            vlocity_cmt__PricingVariable__c pricingVariable = new vlocity_cmt__PricingVariable__c
            (
                Name='One Time Std Price',
                vlocity_cmt__Code__c='OT_STD_PRC',
                vlocity_cmt__AdjustmentMethod__c='Percent',
                vlocity_cmt__IsActive__c=True,
                vlocity_cmt__Aggregation__c='Unit',
                vlocity_cmt__ChargeType__c='One-time',
                vlocity_cmt__ValueType__c='Pricing Element',
                vlocity_cmt__Type__c='Price',
                vlocity_cmt__SubType__c='Standard',
                vlocity_cmt__Scope__c='Line',
                vlocity_cmt__CurrencyType__c='Currency'
            );
            insert pricingVariable;

            vlocity_cmt__QuoteDiscountPricing__c pricing = new vlocity_cmt__QuoteDiscountPricing__c
            (
                Name = '5% off monthly',
                vlocity_cmt__AdjustmentValue__c = -5.00,
                vlocity_cmt__PricingVariableId__c = pricingVariable.Id,
                vlocity_cmt__QuoteDiscountId__c = discount.Id
            );
            insert pricing;
        }
    }
    
       /*
    * Name         :  createOrderMembers
    * Author       :  
    * Date         :  18 Oct, 2022
    * Description  :  Create Order Members
    */
    public static void createOrderMembers(String orderId, String groupId, Integer num, String memberType){
        List<vlocity_cmt__OrderMember__c> memberList = new List<vlocity_cmt__OrderMember__c>();
        for(Integer i=0; i <= num; i++) {
            memberList.add(new vlocity_cmt__OrderMember__c(
                                                Name = 'Test Member ' + i, 
                                                vlocity_cmt__FirstName__c = 'Test', 
                                                vlocity_cmt__LastName__c = 'Member ' + i,
                                                vlocity_cmt__OrderId__c = orderId,
                                                vlocity_cmt__MemberType__c = memberType,
                                                vlocity_cmt__OrderGroupId__c = groupId));
        }
        insert memberList;
    }

       /*
    * Name         :  createOrderMembers
    * Author       :  
    * Date         :  18 Oct, 2022
    * Description  :  Create Order Members
    */
    public static void createOrderMembers(String name, String orderId, String groupId, Integer num, String memberType){
        List<vlocity_cmt__OrderMember__c> memberList = new List<vlocity_cmt__OrderMember__c>();
        for(Integer i=0; i <= num; i++) {
            memberList.add(new vlocity_cmt__OrderMember__c(
                                                Name = name+' ' + i, 
                                                vlocity_cmt__FirstName__c = name, 
                                                vlocity_cmt__LastName__c = 'Member ' + i,
                                                vlocity_cmt__OrderId__c = orderId,
                                                vlocity_cmt__MemberType__c = memberType,
                                                vlocity_cmt__OrderGroupId__c = groupId));
        }
        insert memberList;
    }
    
       /*
    * Name         :  createOpptMembers
    * Author       :  
    * Date         :  18 Oct, 2022
    * Description  :  Create Opportunity Members
    */
    public static void createOpptMembers(String opptId, String groupId, Integer num, String memberType){
        List<vlocity_cmt__OpportunityMember__c> memberList = new List<vlocity_cmt__OpportunityMember__c>();
        for(Integer i=0; i <= num; i++) {
            memberList.add(new vlocity_cmt__OpportunityMember__c(
                                                Name = 'Test Member ' + i, 
                                                vlocity_cmt__PostalCode__c = '123456',
                                                vlocity_cmt__FirstName__c = 'Test', 
                                                vlocity_cmt__LastName__c = 'Member ' + i,
                                                vlocity_cmt__OpportunityId__c = opptId,
                                                vlocity_cmt__MemberType__c = memberType,
                                                vlocity_cmt__OpportunityGroupId__c = groupId));
        }
        insert memberList;
    }
    
       /*
    * Name         :  createSubOrders
    * Author       :  
    * Date         :  18 Oct, 2022
    * Description  :  Create Sub orders
    */  
    public static void createSubOrders(Order masterOrder, Integer num, Account account, Quote quote){
        List<Order> orders = new List<Order>();
        Id recordTypeId = getRecordTypeIdByName('Order', 'SubOrder');
        for(Integer i=1; i <=num; i++)
        {
            Order subOrder = new Order(
                AccountId = account.Id,
                Name = quote.Name,
                vlocity_cmt__PriceListId__c = quote.vlocity_cmt__PriceListId__c,
                Pricebook2Id = masterOrder.PriceBook2Id,
                EffectiveDate = System.today(),
                Status = 'Draft',
                vlocity_cmt__QuoteId__c = quote.Id,
                vlocity_cmt__ParentOrderId__c = masterOrder.Id,
                RecordTypeId = recordTypeId
            );
            orders.add(subOrder);
        }
        insert orders;
    }
    
        /*
    * Name         :  createQuoteMembers
    * Author       :  
    * Date         :  18 Oct, 2022
    * Description  :  Create Quote Members
    */
    public static void createQuoteMembers(String quoteId, String prefixName, String groupId, Integer num, String memberType){
        List<vlocity_cmt__QuoteMember__c> memberList = new List<vlocity_cmt__QuoteMember__c>();
        for(Integer i=0; i <= num; i++) {
            memberList.add(new vlocity_cmt__QuoteMember__c(
                                                Name = prefixName + ' ' + i, 
                                                vlocity_cmt__PostalCode__c = '123456',
                                                vlocity_cmt__FirstName__c = 'Test', 
                                                vlocity_cmt__LastName__c = 'Member ' + i,
                                                vlocity_cmt__QuoteId__c = quoteId,
                                                vlocity_cmt__MemberType__c = memberType,
                                                vlocity_cmt__QuoteGroupId__c = groupId));
        }
        insert memberList;
    }
}