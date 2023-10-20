trigger LeadTrigger on Lead (before update) {
    List<Event> evenets = new List<Event>();
    for(Lead lead : Trigger.new) {
        if (lead.IsConverted) {
            event evnt = new event();
            evnt.whoId = lead.Id;
            evnt.DurationInMinutes = 0;
            evnt.ActivityDateTime = system.now();
            evenets.add(evnt);
        }
    }
    if(!evenets.isEmpty() && evenets.size() > 0){
        insert evenets;
        System.debug('From Lead Trigger');
    }
}