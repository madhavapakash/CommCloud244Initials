public class ARTL_PostToChatter {
	@InvocableMethod(label='Notify Lead Owner' description='Chatter Post to notify Lead Owner.')
    public static void chatterPostToLeadOwner(List<ID> ids) {
        try{
            string baseUrl = System.URL.getOrgDomainUrl().toExternalForm();
            List<Lead> leads = [select Id, Name, OwnerId from Lead where Id IN :ids];
            List<FeedItem> FeedItems = new List<FeedItem>();
            for(Lead ld : leads){
                string url = baseUrl + '/lightning/r/Lead/' + ld.Id + '/view';
                FeedItem fi = new FeedItem();
                fi.ParentId = ld.OwnerId;
                fi.Body = 'Lead <a href="' + url  + '" rel="noopener noreferrer" target="_blank"> ' + ld.Name + '</a>  is assigned to you. Please take the necessary actions as required';
                fi.IsRichText = true;
                FeedItems.add(fi);
            }
            if(!FeedItems.isEmpty() && FeedItems.size() > 0){
                Database.SaveResult[] results = Database.insert(FeedItems, false);
            }
        }
        catch(Exception e){
            system.debug('Exception from Lead Owner Chatter Post' + string.valueOf(e));
            //Invoke error logging Method
        }
    }
}