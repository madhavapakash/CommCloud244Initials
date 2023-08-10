vlocity.cardframework.registerModule
    .controller('actionRedirectController',
                 ["$scope","$rootScope","$window","$location", function( $scope,$rootScope,$window,$location){
        this.performAction =  function (action, params,itemId,customTaskExecUrl) {
          if (params) {
            var nsPrefix = $rootScope.nsPrefix;
            var url;
            if(customTaskExecUrl) {
                url = customTaskExecUrl;
                console.log('customTaskExecUrl', customTaskExecUrl);
                url=url.toString();
                if (url.includes('ContextId/{0}'))
                {
                    url = url.replace('ContextId/{0}', 'ContextId/' + itemId);
                }
                else if (url.includes('ContextId={0}')) {
                    url = url.replace('ContextId={0}', '&ContextId=' + itemId);
                }
                else if (url.includes('LWCOmniWrapper') && !url.includes('&c__ContextId=')) {
                    url = url + '&c__ContextId=' + itemId;
                }
                else if (!url.includes('?'))
                {
                    url = url + '?orchItemId=' + itemId;
                }
                else {
                    url = url+ '&orchItemId=' + itemId;
                }
                console.log('Omniscript Launch URL', url);
            } else {
                var isExternalId = !isNaN(parseFloat(itemId)) && isFinite(itemId);
                if(!isExternalId)
                {
                    url='/' + itemId;
                    var actionUrl = action[nsPrefix + 'Url__c'] || action[nsPrefix + 'URL__c'] || action.url;
                    if(actionUrl.includes("{0}")){
                        url=actionUrl.toString().replace("{0}",itemId);
                    }
                } 
                else 
                {
                    url='/apex/XOMObjectParams#!/object/' + itemId;
                }
                action[nsPrefix + 'URL__c']=url;
                action[nsPrefix + 'UrlParameters__c'] = itemId;
            }
            console.log('Card action', action);
            if(action[nsPrefix + 'OpenUrlMode__c'])
            {
                var urlMode  = action[nsPrefix + 'OpenUrlMode__c'];
            }
            if(action[nsPrefix + 'OpenURLMode__c'])
            {
                var urlMode  = action[nsPrefix + 'OpenURLMode__c'];
            }

            var isInConsole = (window.sforce && sforce.one)
            if(isInConsole){
              var urlMode="Current window";
            }
            $scope.performAction({
            type: 'Custom',
            isCustomAction: true,
            url: url,
            openUrlIn: urlMode
            });
              
          }
    }
}]);