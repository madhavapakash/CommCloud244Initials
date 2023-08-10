({
    onClick : function(component, event, helper) {
        var id = event.target.dataset.menuItemId;
        if (id) {
            component.getSuper().navigate(id);
         } 
    },logOut : function() {
        $A.get("e.force:logout").fire();
    }
})