@isTest
public with sharing class ARTL_OpportunityTriggerHelperTest {
    
    private static final String NOT_FEASIBLE = 'Not Feasible';
    private static final String INITIAL_STAGE = 'Initial';
    private static final String CLOSED_WON = 'Closed Won';
    private static final String PARTIAL_WON = 'Partial Won';
    private static final String BUSINESS = 'Business';
    private static final String AT_WORK_D_Series_ADL = 'At Work D-Series ADSL2+ 200GB';
    private static final String AT_WORK_D_Series_ADL_UNLIMITED = 'At Work D-Series ADSL2+ Unlimited';
    
    @testSetup
    static void setupTestData() {
        
        // Create common test accounts
        List<Account> testAccounts = ARTL_TestDataFactory.createAccount(BUSINESS, true, 1);
        Id standardBookId =  Test.getStandardPricebookId();
        Set<String> productNames = new Set<String>{AT_WORK_D_Series_ADL, AT_WORK_D_Series_ADL_UNLIMITED};
        Set<String> productCodes = new Set<String>{AT_WORK_D_Series_ADL,AT_WORK_D_Series_ADL_UNLIMITED};
        List<Product2> testProducts = ARTL_TestDataFactory.createProduct(productNames,productCodes, true, 2);
        Map<Id, Product2> productMap = new Map<Id, Product2>(testProducts);
        Set<Id> productIds = new Set<Id>(productMap.KeySet());
        List<PriceBookEntry> testPriceBookEntries = ARTL_TestDataFactory.createPricebookEntry(productIds, standardBookId, true, 2);
        List<vlocity_cmt__PriceList__c> testVlocityPLs = ARTL_TestDataFactory.createVlocityPriceList(standardBookId, true, 1);
        List<Opportunity> testopportunities = ARTL_TestDataFactory.createOpportunity(new Set<Id>{testAccounts[0].Id},INITIAL_STAGE, testVlocityPLs[0].Id, true, 1);
        List<Quote> testQuotes = ARTL_TestDataFactory.createQuote(testopportunities[0].Id, testVlocityPLs[0].Id, standardBookId, true, 1);
        List<vlocity_cmt__QuoteMember__c> testQuoteMember = ARTL_TestDataFactory.createQuoteMember(testQuotes[0].Id, NOT_FEASIBLE, true,1);
        List<QuoteLineItem> testQLIS = new List<QuoteLineItem>();
        for(PriceBookEntry priceEntry : testPriceBookEntries){
            QuoteLineItem testQLI = ARTL_TestDataFactory.createQuoteLineItem(testQuotes[0].Id, priceEntry.Product2Id, priceEntry.Id, 1, false, 1)[0];
            testQLI.vlocity_cmt__BaseRecurringCharge__c = 50;
            testQLI.vlocity_cmt__BaseOneTimeCharge__c = 50;
            testQLI.vlocity_cmt__EffectiveRecurringTotal__c = 50;
            testQLI.vlocity_cmt__EffectiveOneTimeTotal__c = 50;
            testQLI.vlocity_cmt__RecurringCalculatedPrice__c = 50;
            testQLI.vlocity_cmt__OneTimeCalculatedPrice__c = 50;
            testQLI.vlocity_cmt__QuoteMemberId__c = testQuoteMember[0].Id;
            testQLIS.add(testQLI);
        }
        for(PriceBookEntry priceEntry : testPriceBookEntries){
            QuoteLineItem testQLI = ARTL_TestDataFactory.createQuoteLineItem(testQuotes[0].Id, priceEntry.Product2Id, priceEntry.Id, 1, false, 1)[0];
            testQLI.vlocity_cmt__BaseRecurringCharge__c = 50;
            testQLI.vlocity_cmt__BaseOneTimeCharge__c = 50;
            testQLI.vlocity_cmt__EffectiveRecurringTotal__c = 50;
            testQLI.vlocity_cmt__EffectiveOneTimeTotal__c = 50;
            testQLI.vlocity_cmt__RecurringCalculatedPrice__c = 50;
            testQLI.vlocity_cmt__OneTimeCalculatedPrice__c = 50;
            testQLI.vlocity_cmt__QuoteMemberId__c = testQuoteMember[0].Id;
            testQLIS.add(testQLI);
        }
        insert testQLIS;
    }
    
    @isTest
    static void testPartialWonOpportunities(){
        
        List<Opportunity> testOpp = [SELECT Id FROM Opportunity WHERE StageName =: INITIAL_STAGE];
        if(testOpp.size() > 0){
            
            Test.startTest();
            
            	testOpp[0].stagename = CLOSED_WON;
            	testOpp[0].Opportunity_Closure_Status__c = PARTIAL_WON;
            	update testOpp;
            
            Test.stopTest();
            
            System.assertEquals([SELECT Id FROM Opportunity WHERE Parent_Opportunity__c =: testOpp[0].Id].size() > 0, true);
        }
    }
}