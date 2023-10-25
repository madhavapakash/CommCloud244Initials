export const OMNIDEF = {"userTimeZone":330,"userProfile":"System Administrator","userName":"ikhare-kbej@salesforce.com.artlr1qa1","userId":"0050T000003FguiQAC","userCurrencyCode":"INR","timeStamp":"2023-10-17T18:29:51.343Z","sOmniScriptId":"0jN720000000n8nEAA","sobjPL":{},"RPBundle":"","rMap":{},"response":null,"propSetMap":{"currentLanguage":"en_US","scrollBehavior":"auto","disableUnloadWarn":true,"stepChartPlacement":"right","stylesheet":{"lightningRtl":"","newportRtl":"","lightning":"","newport":""},"errorMessage":{"custom":[]},"consoleTabIcon":"custom:custom18","consoleTabTitle":null,"rtpSeed":false,"showInputWidth":false,"currencyCode":"","autoFocus":false,"pubsub":false,"message":{},"ssm":false,"wpm":false,"consoleTabLabel":"New","cancelRedirectTemplateUrl":"vlcCancelled.html","cancelRedirectPageName":"OmniScriptCancelled","cancelSource":"%ContextId%","allowCancel":true,"cancelType":"SObject","visualforcePagesAvailableInPreview":{},"mergeSavedData":false,"hideStepChart":true,"timeTracking":false,"knowledgeArticleTypeQueryFieldsMap":{},"lkObjName":null,"bLK":false,"enableKnowledge":false,"trackingCustomData":{},"seedDataJSON":{},"elementTypeToHTMLTemplateMapping":{},"autoSaveOnStepNext":false,"saveURLPatterns":{},"saveObjectId":"%ContextId%","saveContentEncoded":false,"saveForLaterRedirectTemplateUrl":"vlcSaveForLaterAcknowledge.html","saveForLaterRedirectPageName":"sflRedirect","saveExpireInDays":null,"saveNameTemplate":null,"allowSaveForLater":false,"persistentComponent":[{"modalConfigurationSetting":{"modalSize":"lg","modalController":"ModalProductCtrl","modalHTMLTemplateId":"vlcProductConfig.html"},"itemsKey":"cartItems","id":"vlcCart","responseJSONNode":"","responseJSONPath":"","sendJSONNode":"","sendJSONPath":"","postTransformBundle":"","preTransformBundle":"","remoteOptions":{"postTransformBundle":"","preTransformBundle":""},"remoteTimeout":30000,"remoteMethod":"","remoteClass":"","label":"","render":false},{"modalConfigurationSetting":{"modalSize":"lg","modalController":"","modalHTMLTemplateId":""},"itemsKey":"knowledgeItems","id":"vlcKnowledge","postTransformBundle":"","preTransformBundle":"","remoteOptions":{"postTransformBundle":"","preTransformBundle":""},"remoteTimeout":30000,"remoteMethod":"","remoteClass":"","label":"","dispOutsideOmni":false,"render":false}]},"prefillJSON":"{}","lwcId":"1dbfe70c-0676-0466-47ab-c3593255b782","labelMap":{"TextBlock2":"Step1:TextBlock2","NavigateAction":"NavigateAction","Step1":"Step1","ARTL_CalloutEventHandler":"ARTL_CalloutEventHandler"},"labelKeyMap":{},"errorMsg":"","error":"OK","dMap":{},"depSOPL":{},"depCusPL":{},"cusPL":{},"children":[{"type":"Remote Action","propSetMap":{"businessEvent":"","businessCategory":"","useContinuation":false,"enableActionMessage":false,"enableDefaultAbort":false,"errorMessage":{"default":null,"custom":[]},"svgIcon":"","svgSprite":"","pubsub":false,"message":{},"ssm":false,"wpm":false,"HTMLTemplateId":"","show":null,"showPersistentComponent":[true,false],"redirectPreviousWidth":3,"redirectPreviousLabel":"Previous","redirectNextWidth":3,"redirectNextLabel":"Next","redirectTemplateUrl":"vlcAcknowledge.html","redirectPageName":"","validationRequired":"Step","failureAbortMessage":"Are you sure?","failureGoBackLabel":"Go Back","failureAbortLabel":"Abort","failureNextLabel":"Continue","postMessage":"Done","inProgressMessage":"In Progress","extraPayload":{},"responseJSONNode":"","responseJSONPath":"","sendJSONNode":"","sendJSONPath":"","postTransformBundle":"","preTransformBundle":"","remoteTimeout":30000,"remoteOptions":{"postTransformBundle":"","preTransformBundle":""},"remoteMethod":"initiateCallout","remoteClass":"ARTL_CalloutEventHandler","label":"","controlWidth":12,"aggElements":{}},"offSet":0,"name":"ARTL_CalloutEventHandler","level":0,"indexInParent":0,"bHasAttachment":false,"bEmbed":false,"bRemoteAction":true,"JSONPath":"ARTL_CalloutEventHandler","lwcId":"lwc0"},{"type":"Step","propSetMap":{"businessEvent":"","businessCategory":"","pubsub":false,"message":{},"ssm":false,"wpm":false,"errorMessage":{"default":null,"custom":[]},"allowSaveForLater":true,"chartLabel":null,"instructionKey":"","HTMLTemplateId":"","conditionType":"Hide if False","show":{"group":{"rules":[{"data":"null","condition":"<>","field":"response:errorMessage:errorMsg"},{"data":"","condition":"<>","field":"response:errorMessage"},{"data":null,"condition":"<>","field":"response"},{"data":"false","condition":"=","field":"response:success"}],"operator":"AND"}},"knowledgeOptions":{"typeFilter":"","remoteTimeout":30000,"dataCategoryCriteria":"","keyword":"","publishStatus":"Online","language":"English"},"remoteOptions":{},"remoteTimeout":30000,"remoteMethod":"","remoteClass":"","showPersistentComponent":[true,false],"instruction":"","completeMessage":"Are you sure you want to complete the script?","completeLabel":"Complete","saveMessage":"Are you sure you want to save it for later?","saveLabel":"Save for later","cancelMessage":"Are you sure?","cancelLabel":"Cancel","nextWidth":3,"nextLabel":"Done","previousWidth":3,"previousLabel":"Previous","validationRequired":true,"label":"Error","uiElements":{"Step1":""},"aggElements":{}},"offSet":0,"name":"Step1","level":0,"indexInParent":1,"bHasAttachment":false,"bEmbed":false,"response":null,"inheritShowProp":null,"children":[{"response":null,"level":1,"indexInParent":0,"eleArray":[{"type":"Text Block","rootIndex":1,"response":null,"propSetMap":{"controlWidth":12,"label":"TextBlock1","text":"<h3 style=\"text-align: center;\">&nbsp;</h3>\n<h5 style=\"text-align: center;\"><span style=\"color: #e03e2d;\">%response:errorMessage:errorMsg%</span></h5>","show":null,"dataJSON":false,"HTMLTemplateId":"","textKey":"","sanitize":false},"name":"TextBlock2","level":1,"JSONPath":"Step1:TextBlock2","indexInParent":0,"index":0,"children":[],"bHasAttachment":false,"bTextBlock":true,"lwcId":"lwc10-0"}],"bHasAttachment":false}],"bAccordionOpen":false,"bAccordionActive":false,"bStep":true,"isStep":true,"JSONPath":"Step1","lwcId":"lwc1"},{"type":"Navigate Action","propSetMap":{"businessEvent":"","businessCategory":"","targetLWCLayout":"lightning","replace":false,"iconPosition":"left","iconVariant":"","iconName":"","variant":"brand","targetId":"%ContextId%","targetFilter":"Recent","loginAction":"login","recordAction":"view","objectAction":"home","targetType":"Record","message":{},"pubsub":false,"ssm":false,"wpm":false,"HTMLTemplateId":"","show":null,"validationRequired":"Submit","label":"NavigateAction","controlWidth":12,"aggElements":{}},"offSet":0,"name":"NavigateAction","level":0,"indexInParent":2,"bHasAttachment":false,"bEmbed":false,"bNavigate":true,"JSONPath":"NavigateAction","lwcId":"lwc2"}],"bReusable":false,"bpVersion":2,"bpType":"ARTL","bpSubType":"CalloutEvent","bpLang":"English","bHasAttachment":false,"lwcVarMap":{}};