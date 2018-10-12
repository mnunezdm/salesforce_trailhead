({
    doInit : function(component, event) {
        var action = component.get("c.findAll");
        action.setCallback(this, function(a) {
            component.set("v.accounts", a.getReturnValue());
            window.setTimeout($A.getCallback(function() {
                var event = $A.get("e.c:AccountsLoaded");
                event.setParams({"accounts": a.getReturnValue()});
                event.fire();
            }), 500);
        });
        $A.enqueueAction(action);
        helper.getAccountList(component);
    },
    deleteAccount: function(component, event, helper) {
        // Prevent the form from getting submitted
        event.preventDefault();
        // Get the value from the field that's in the form
        var accountName = event.target.getElementsByClassName('account-name')[0].value;
        confirm('Delete the ' + accountName + ' account? (don’t worry, this won’t actually work!)');
    }
})