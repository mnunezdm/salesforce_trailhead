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
    },
    onFormSubmit: function(component, event, helper) {
        var event = component.getEvent('formsubmit')
        var boatTypeId = component.get('v.selectedBoatType')
        event.setParams({
                formData: {
                    boatTypeId
                }
            })
        event.fire()
        console.log('event fired')
    }
})