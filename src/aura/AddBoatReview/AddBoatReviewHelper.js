({
    onInit : function(component, event, helper) {
        component.find('service').getNewRecord('BoatReview__c', null, false, () => {
            console.log('AddBoatReviewHelper-INFO: Template Initialized')
            // START: helper.setRecordId(component, helper) <- cannot be in helper funciton
            var record = component.get('v.boatReview')

            var boat = component.get('v.boat')
            record.Boat__c = boat.Id
            component.set('v.boatReview', record)
            // END: cannot be in helper funciton
            helper.checkErrors(component, helper)
        })
    },
    setRecordId : function(component, helper) {
        var record = component.get('v.boatReview')
        var boat = component.get('v.boat')
        record.Boat__c = boat.Id
        component.set('v.boatReview', record)
    },
    checkErrors : function(component, helper) {
        var errors = component.get('v.errors')
        if (errors) {
            console.log('AddBoatReviewHelper-ERROR:', errors)
        }
    },
    showMessage : function(title, message){
        var toast = $A.get("e.force:showToast")
        if (toast) {
            toast.setParams({title, message});
            toast.fire();
        } else {
            console.log('AddBoatReviewController-INFO: toast not supported using alert')
            alert(`${title}: ${message}`)
        }
    },
    notifyReviewAdded : function(component){
        console.log('AddBoatReviewHelper-INFO: Firing event')
        var event = component.getEvent('BoatReviewAdded')
        event.fire()
    }
})