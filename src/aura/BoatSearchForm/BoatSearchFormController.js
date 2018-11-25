({
    doInit: function(component, event, helper) {
        helper.detectIfCreateIsEnabled(component)
        helper.fetchBoatTypes(component)
    },
    createRecord : function(component, event, helper) {
        // event.force:createRecord
        var createRecordEvent = $A.get("e.force:createRecord");
        var selectedType = component.get('v.selectedBoatType')
        if (selectedType) {
            var defaultFieldValues = {BoatType__c: selectedType}
        }
        createRecordEvent.setParams({
            "entityApiName": "Boat__c",
            defaultFieldValues
        });
        createRecordEvent.fire();
    }
})