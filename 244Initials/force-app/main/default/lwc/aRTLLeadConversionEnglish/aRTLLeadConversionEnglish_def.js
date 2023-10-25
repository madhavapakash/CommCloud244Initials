export const OMNIDEF = {"userTimeZone":330,"userProfile":"System Administrator","userName":"rishab.kalra@salesforce.com.artlr1qa1","userId":"00572000005JThlAAG","userCurrencyCode":"INR","timeStamp":"2023-10-12T13:21:31.881Z","sOmniScriptId":"0jN720000000mCjEAI","sobjPL":{},"RPBundle":"","rMap":{},"response":null,"propSetMap":{"currentLanguage":"en_US","scrollBehavior":"auto","disableUnloadWarn":true,"stepChartPlacement":"right","stylesheet":{"lightningRtl":"","newportRtl":"","lightning":"","newport":""},"errorMessage":{"custom":[]},"consoleTabIcon":"custom:custom18","consoleTabTitle":null,"rtpSeed":false,"showInputWidth":false,"currencyCode":"","autoFocus":false,"pubsub":false,"message":{},"ssm":false,"wpm":false,"consoleTabLabel":"New","cancelRedirectTemplateUrl":"vlcCancelled.html","cancelRedirectPageName":"OmniScriptCancelled","cancelSource":"%ContextId%","allowCancel":true,"cancelType":"SObject","visualforcePagesAvailableInPreview":{},"mergeSavedData":false,"hideStepChart":true,"timeTracking":false,"knowledgeArticleTypeQueryFieldsMap":{},"lkObjName":null,"bLK":false,"enableKnowledge":false,"trackingCustomData":{},"seedDataJSON":{},"elementTypeToHTMLTemplateMapping":{},"autoSaveOnStepNext":false,"saveURLPatterns":{},"saveObjectId":"%ContextId%","saveContentEncoded":false,"saveForLaterRedirectTemplateUrl":"vlcSaveForLaterAcknowledge.html","saveForLaterRedirectPageName":"sflRedirect","saveExpireInDays":null,"saveNameTemplate":null,"allowSaveForLater":false,"persistentComponent":[{"modalConfigurationSetting":{"modalSize":"lg","modalController":"ModalProductCtrl","modalHTMLTemplateId":"vlcProductConfig.html"},"itemsKey":"cartItems","id":"vlcCart","responseJSONNode":"","responseJSONPath":"","sendJSONNode":"","sendJSONPath":"","postTransformBundle":"","preTransformBundle":"","remoteOptions":{"postTransformBundle":"","preTransformBundle":""},"remoteTimeout":30000,"remoteMethod":"","remoteClass":"","label":"","render":false},{"modalConfigurationSetting":{"modalSize":"lg","modalController":"","modalHTMLTemplateId":""},"itemsKey":"knowledgeItems","id":"vlcKnowledge","postTransformBundle":"","preTransformBundle":"","remoteOptions":{"postTransformBundle":"","preTransformBundle":""},"remoteTimeout":30000,"remoteMethod":"","remoteClass":"","label":"","dispOutsideOmni":false,"render":false}]},"prefillJSON":"{}","lwcId":"1d7e4a8c-2fb7-5f51-3a88-ec85a66ac798","labelMap":{"TextBlock9":"submitError:TextBlock9","TextBlock8":"LeadConversion:TextBlock8","opportunityName":"LeadConversion:opportunityName","TextBlock5":"LeadConversion:TextBlock5","LineBreak2":"LeadConversion:LineBreak2","TextBlock7":"LeadConversion:TextBlock7","TextBlock6":"LeadConversion:TextBlock6","TextBlock4":"LeadConversion:TextBlock4","LineBreak1":"LeadConversion:LineBreak1","AccountText":"LeadConversion:AccountText","TextBlock3":"LeadConversion:TextBlock3","TextBlock2":"Error:TextBlock2","TextBlock1":"Error:TextBlock1","NavigateAction1":"NavigateAction1","submitError":"submitError","Submit":"Submit","LeadConversion":"LeadConversion","Error":"Error","DataRaptorExtractAction1":"DataRaptorExtractAction1"},"labelKeyMap":{},"errorMsg":"","error":"OK","dMap":{},"depSOPL":{},"depCusPL":{},"cusPL":{},"children":[{"type":"DataRaptor Extract Action","propSetMap":{"businessEvent":"","businessCategory":"","enableActionMessage":false,"enableDefaultAbort":false,"errorMessage":{"default":null,"custom":[]},"pubsub":false,"message":{},"ssm":false,"wpm":false,"HTMLTemplateId":"","show":null,"showPersistentComponent":[true,false],"redirectPreviousWidth":3,"redirectPreviousLabel":"Previous","redirectNextWidth":3,"redirectNextLabel":"Next","redirectTemplateUrl":"vlcAcknowledge.html","redirectPageName":"","validationRequired":"Step","failureAbortMessage":"Are you sure?","failureGoBackLabel":"Go Back","failureAbortLabel":"Abort","failureNextLabel":"Continue","postMessage":"Done","inProgressMessage":"In Progress","responseJSONNode":"","responseJSONPath":"","remoteTimeout":30000,"dataRaptor Input Parameters":[{"inputParam":"ContextId","element":"ContextId"}],"ignoreCache":true,"bundle":"ARTL_DRE_GetLeadAndRelatedRecords","label":"DataRaptorExtractAction1","controlWidth":12,"aggElements":{}},"offSet":0,"name":"DataRaptorExtractAction1","level":0,"indexInParent":0,"bHasAttachment":false,"bEmbed":false,"bDataRaptorExtractAction":true,"JSONPath":"DataRaptorExtractAction1","lwcId":"lwc0"},{"type":"Step","propSetMap":{"businessEvent":"","businessCategory":"","pubsub":false,"message":{},"ssm":false,"wpm":false,"errorMessage":{"default":null,"custom":[]},"allowSaveForLater":false,"chartLabel":null,"instructionKey":"","HTMLTemplateId":"","conditionType":"Hide if False","show":{"group":{"rules":[{"field":"Lead:relatedAccount","condition":"=","data":null},{"data":null,"condition":"=","field":"Lead:lastActivityDate"}],"operator":"OR"}},"knowledgeOptions":{"typeFilter":"","remoteTimeout":30000,"dataCategoryCriteria":"","keyword":"","publishStatus":"Online","language":"English"},"remoteOptions":{},"remoteTimeout":30000,"remoteMethod":"","remoteClass":"","showPersistentComponent":[true,false],"instruction":"","completeMessage":"Are you sure you want to complete the script?","completeLabel":"Complete","saveMessage":"Are you sure you want to save it for later?","saveLabel":"Save for later","cancelMessage":"Are you sure?","cancelLabel":"Cancel","nextWidth":"0","nextLabel":"","previousWidth":3,"previousLabel":"Previous","validationRequired":true,"label":"Error","uiElements":{"Error":""},"aggElements":{}},"offSet":0,"name":"Error","level":0,"indexInParent":1,"bHasAttachment":false,"bEmbed":false,"response":null,"inheritShowProp":null,"children":[{"response":null,"level":1,"indexInParent":0,"eleArray":[{"type":"Text Block","rootIndex":1,"response":null,"propSetMap":{"sanitize":false,"textKey":"","HTMLTemplateId":"","dataJSON":false,"show":{"group":{"rules":[{"field":"Lead:relatedAccount","condition":"=","data":null}],"operator":"AND"}},"text":"<ul>\n<li style=\"text-align: left;\"><span style=\"color: #e03e2d;\"><em>A Business Account should be associated before converting the lead.</em></span></li>\n</ul>","label":"TextBlock1","controlWidth":12},"name":"TextBlock1","level":1,"JSONPath":"Error:TextBlock1","indexInParent":0,"index":0,"children":[],"bHasAttachment":false,"bTextBlock":true,"lwcId":"lwc10-0"}],"bHasAttachment":false},{"response":null,"level":1,"indexInParent":1,"eleArray":[{"type":"Text Block","rootIndex":1,"response":null,"propSetMap":{"controlWidth":12,"label":"TextBlock1","text":"<ul>\n<li style=\"text-align: left;\"><span style=\"color: #e03e2d;\"><em>There are no activities performed on this lead. Before converting the lead at least one activity should be performed on the lead.</em></span></li>\n</ul>","show":{"group":{"rules":[{"data":null,"condition":"=","field":"Lead:lastActivityDate"}],"operator":"AND"}},"dataJSON":false,"HTMLTemplateId":"","textKey":"","sanitize":false},"name":"TextBlock2","level":1,"JSONPath":"Error:TextBlock2","indexInParent":1,"index":0,"children":[],"bHasAttachment":false,"bTextBlock":true,"lwcId":"lwc11-0"}],"bHasAttachment":false}],"bAccordionOpen":false,"bAccordionActive":false,"bStep":true,"isStep":true,"JSONPath":"Error","lwcId":"lwc1"},{"type":"Step","propSetMap":{"businessEvent":"","businessCategory":"","pubsub":false,"message":{},"ssm":false,"wpm":false,"errorMessage":{"default":null,"custom":[]},"allowSaveForLater":false,"chartLabel":null,"instructionKey":"","HTMLTemplateId":"","conditionType":"Hide if False","show":null,"knowledgeOptions":{"typeFilter":"","remoteTimeout":30000,"dataCategoryCriteria":"","keyword":"","publishStatus":"Online","language":"English"},"remoteOptions":{},"remoteTimeout":30000,"remoteMethod":"","remoteClass":"","showPersistentComponent":[true,false],"instruction":"","completeMessage":"Are you sure you want to complete the script?","completeLabel":"Complete","saveMessage":"Are you sure you want to save it for later?","saveLabel":"Save for later","cancelMessage":"Are you sure?","cancelLabel":"Cancel","nextWidth":"3","nextLabel":"Submit","previousWidth":"0","previousLabel":"Previous","validationRequired":true,"label":"Convert Lead Confirmation","uiElements":{"LeadConversion":"","opportunityName":""},"aggElements":{}},"offSet":0,"name":"LeadConversion","level":0,"indexInParent":2,"bHasAttachment":false,"bEmbed":false,"response":null,"inheritShowProp":null,"children":[{"response":null,"level":1,"indexInParent":0,"eleArray":[{"type":"Text Block","rootIndex":2,"response":null,"propSetMap":{"sanitize":false,"textKey":"","HTMLTemplateId":"","dataJSON":false,"show":null,"text":"<h3>Account</h3>","label":"TextBlock3","controlWidth":12},"name":"TextBlock3","level":1,"JSONPath":"LeadConversion:TextBlock3","indexInParent":0,"index":0,"children":[],"bHasAttachment":false,"bTextBlock":true,"lwcId":"lwc20-0"}],"bHasAttachment":false},{"response":null,"level":1,"indexInParent":1,"eleArray":[{"type":"Text Block","rootIndex":2,"response":null,"propSetMap":{"sanitize":false,"textKey":"","HTMLTemplateId":"","dataJSON":false,"show":null,"text":"<p>After conversion, Contact and Opportunity will be linked to below Account.</p>\n<p>Account Name: &nbsp; &nbsp; &nbsp; &nbsp; <a href=\"/%Lead:relatedAccount%\" target=\"_blank\" rel=\"noopener\">%Account:name%</a></p>","label":"TextBlock6","controlWidth":12},"name":"AccountText","level":1,"JSONPath":"LeadConversion:AccountText","indexInParent":1,"index":0,"children":[],"bHasAttachment":false,"bTextBlock":true,"lwcId":"lwc21-0"}],"bHasAttachment":false},{"response":null,"level":1,"indexInParent":2,"eleArray":[{"type":"Line Break","rootIndex":2,"response":null,"propSetMap":{"HTMLTemplateId":"","show":null,"padding":20,"label":"LineBreak1"},"name":"LineBreak1","level":1,"JSONPath":"LeadConversion:LineBreak1","indexInParent":2,"index":0,"children":[],"bHasAttachment":false,"bLineBreak":true,"lwcId":"lwc22-0"}],"bHasAttachment":false},{"response":null,"level":1,"indexInParent":3,"eleArray":[{"type":"Text Block","rootIndex":2,"response":null,"propSetMap":{"controlWidth":12,"label":"TextBlock3","text":"<h3>Contact</h3>","show":null,"dataJSON":false,"HTMLTemplateId":"","textKey":"","sanitize":false},"name":"TextBlock4","level":1,"JSONPath":"LeadConversion:TextBlock4","indexInParent":3,"index":0,"children":[],"bHasAttachment":false,"bTextBlock":true,"lwcId":"lwc23-0"}],"bHasAttachment":false},{"response":null,"level":1,"indexInParent":4,"eleArray":[{"type":"Text Block","rootIndex":2,"response":null,"propSetMap":{"sanitize":false,"textKey":"","HTMLTemplateId":"","dataJSON":false,"show":{"group":{"rules":[{"field":"Contact:name","condition":"<>","data":null}],"operator":"AND"}},"text":"<p>Matching Contact Found: %Contact:name%</p>","label":"TextBlock3","controlWidth":12},"name":"TextBlock6","level":1,"JSONPath":"LeadConversion:TextBlock6","indexInParent":4,"index":0,"children":[],"bHasAttachment":false,"bTextBlock":true,"lwcId":"lwc24-0"}],"bHasAttachment":false},{"response":null,"level":1,"indexInParent":5,"eleArray":[{"type":"Text Block","rootIndex":2,"response":null,"propSetMap":{"controlWidth":12,"label":"TextBlock3","text":"<p>A new contact with name <strong>%Lead:name%</strong>&nbsp;will be created.</p>","show":{"group":{"rules":[{"field":"Contact:name","condition":"=","data":null}],"operator":"AND"}},"dataJSON":false,"HTMLTemplateId":"","textKey":"","sanitize":false},"name":"TextBlock7","level":1,"JSONPath":"LeadConversion:TextBlock7","indexInParent":5,"index":0,"children":[],"bHasAttachment":false,"bTextBlock":true,"lwcId":"lwc25-0"}],"bHasAttachment":false},{"response":null,"level":1,"indexInParent":6,"eleArray":[{"type":"Line Break","rootIndex":2,"response":null,"propSetMap":{"HTMLTemplateId":"","show":null,"padding":20,"label":"LineBreak2"},"name":"LineBreak2","level":1,"JSONPath":"LeadConversion:LineBreak2","indexInParent":6,"index":0,"children":[],"bHasAttachment":false,"bLineBreak":true,"lwcId":"lwc26-0"}],"bHasAttachment":false},{"response":null,"level":1,"indexInParent":7,"eleArray":[{"type":"Text Block","rootIndex":2,"response":null,"propSetMap":{"sanitize":false,"textKey":"","HTMLTemplateId":"","dataJSON":false,"show":null,"text":"<h3>Opportunity</h3>","label":"TextBlock3","controlWidth":12},"name":"TextBlock5","level":1,"JSONPath":"LeadConversion:TextBlock5","indexInParent":7,"index":0,"children":[],"bHasAttachment":false,"bTextBlock":true,"lwcId":"lwc27-0"}],"bHasAttachment":false},{"response":null,"level":1,"indexInParent":8,"eleArray":[{"type":"Text","rootIndex":2,"response":null,"propSetMap":{"autocomplete":null,"disOnTplt":false,"hide":false,"HTMLTemplateId":"","debounceValue":0,"accessibleInFutureSteps":false,"conditionType":"Hide if False","show":null,"placeholder":"","maxLength":255,"minLength":0,"ptrnErrText":"","pattern":"","mask":"","helpTextPos":"top-right","helpText":"","help":false,"defaultValue":"%Account:name% -","readOnly":false,"repeatLimit":null,"repeatClone":false,"repeat":false,"required":false,"inputWidth":12,"showInputWidth":false,"label":"Opportunity Name","controlWidth":12},"name":"opportunityName","level":1,"JSONPath":"LeadConversion:opportunityName","indexInParent":8,"index":0,"children":[],"bHasAttachment":false,"bText":true,"lwcId":"lwc28-0"}],"bHasAttachment":false},{"response":null,"level":1,"indexInParent":9,"eleArray":[{"type":"Text Block","rootIndex":2,"response":null,"propSetMap":{"sanitize":false,"textKey":"","HTMLTemplateId":"","dataJSON":false,"show":null,"text":"<p style=\"text-align: left;\"><em>*New Opportunity will be created</em></p>","label":"TextBlock8","controlWidth":12},"name":"TextBlock8","level":1,"JSONPath":"LeadConversion:TextBlock8","indexInParent":9,"index":0,"children":[],"bHasAttachment":false,"bTextBlock":true,"lwcId":"lwc29-0"}],"bHasAttachment":false}],"bAccordionOpen":false,"bAccordionActive":false,"bStep":true,"isStep":true,"JSONPath":"LeadConversion","lwcId":"lwc2"},{"type":"Remote Action","propSetMap":{"sendOnlyExtraPayload":true,"businessEvent":"","businessCategory":"","useContinuation":false,"enableActionMessage":false,"enableDefaultAbort":false,"errorMessage":{"default":null,"custom":[]},"svgIcon":"","svgSprite":"","pubsub":false,"message":{},"ssm":false,"wpm":false,"HTMLTemplateId":"","show":null,"showPersistentComponent":[true,false],"redirectPreviousWidth":3,"redirectPreviousLabel":"Previous","redirectNextWidth":3,"redirectNextLabel":"Next","redirectTemplateUrl":"vlcAcknowledge.html","redirectPageName":"","validationRequired":"Step","failureAbortMessage":"Are you sure?","failureGoBackLabel":"Go Back","failureAbortLabel":"Abort","failureNextLabel":"Continue","postMessage":"Done","inProgressMessage":"In Progress","extraPayload":{"opportunityName":"%opportunityName%","leadId":"%ContextId%"},"responseJSONNode":"","responseJSONPath":"","sendJSONNode":"","sendJSONPath":"","postTransformBundle":"","preTransformBundle":"","remoteTimeout":30000,"remoteOptions":{"postTransformBundle":"","preTransformBundle":""},"remoteMethod":"convertLead","remoteClass":"ARTL_LeadConversion","label":"Submit","controlWidth":5,"aggElements":{}},"offSet":0,"name":"Submit","level":0,"indexInParent":3,"bHasAttachment":false,"bEmbed":false,"bRemoteAction":true,"JSONPath":"Submit","lwcId":"lwc3"},{"type":"Step","propSetMap":{"businessEvent":"","businessCategory":"","pubsub":false,"message":{},"ssm":false,"wpm":false,"errorMessage":{"default":null,"custom":[]},"allowSaveForLater":true,"chartLabel":null,"instructionKey":"","HTMLTemplateId":"","conditionType":"Hide if False","show":{"group":{"rules":[{"field":"errorMessage","condition":"<>","data":"null"},{"data":null,"condition":"<>","field":"errorMessage"}],"operator":"AND"}},"knowledgeOptions":{"typeFilter":"","remoteTimeout":30000,"dataCategoryCriteria":"","keyword":"","publishStatus":"Online","language":"English"},"remoteOptions":{},"remoteTimeout":30000,"remoteMethod":"","remoteClass":"","showPersistentComponent":[true,false],"instruction":"","completeMessage":"Are you sure you want to complete the script?","completeLabel":"Complete","saveMessage":"Are you sure you want to save it for later?","saveLabel":"Save for later","cancelMessage":"Are you sure?","cancelLabel":"Cancel","nextWidth":"0","nextLabel":"","previousWidth":"0","previousLabel":"","validationRequired":true,"label":"Error","uiElements":{"submitError":""},"aggElements":{}},"offSet":0,"name":"submitError","level":0,"indexInParent":4,"bHasAttachment":false,"bEmbed":false,"response":null,"inheritShowProp":null,"children":[{"response":null,"level":1,"indexInParent":0,"eleArray":[{"type":"Text Block","rootIndex":4,"response":null,"propSetMap":{"sanitize":false,"textKey":"","HTMLTemplateId":"","dataJSON":false,"show":null,"text":"<p style=\"text-align: center;\"><span style=\"color: #e03e2d;\">%errorMessage%</span></p>","label":"TextBlock9","controlWidth":12},"name":"TextBlock9","level":1,"JSONPath":"submitError:TextBlock9","indexInParent":0,"index":0,"children":[],"bHasAttachment":false,"bTextBlock":true,"lwcId":"lwc40-0"}],"bHasAttachment":false}],"bAccordionOpen":false,"bAccordionActive":false,"bStep":true,"isStep":true,"JSONPath":"submitError","lwcId":"lwc4"},{"type":"Navigate Action","propSetMap":{"businessEvent":"","businessCategory":"","targetLWCLayout":"lightning","replace":false,"iconPosition":"left","iconVariant":"","iconName":"","variant":"brand","targetId":"%opportunityRecordId%","targetFilter":"Recent","loginAction":"login","recordAction":"view","objectAction":"home","targetType":"Record","message":{},"pubsub":false,"ssm":false,"wpm":false,"HTMLTemplateId":"","show":null,"validationRequired":"Submit","label":"NavigateAction1","controlWidth":12,"aggElements":{}},"offSet":0,"name":"NavigateAction1","level":0,"indexInParent":5,"bHasAttachment":false,"bEmbed":false,"bNavigate":true,"JSONPath":"NavigateAction1","lwcId":"lwc5"}],"bReusable":false,"bpVersion":3,"bpType":"ARTL","bpSubType":"leadConversion","bpLang":"English","bHasAttachment":false,"lwcVarMap":{}};