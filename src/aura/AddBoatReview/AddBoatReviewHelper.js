({
    onInit : function(component, event, helper) {
        var lightningDataService = component.find('service')
        lightningDataService.getNewRecord('BoatReview__c', null, false, () => {
            console.log('AddBoatReviewHelper-INFO: Template Initialized')
            helper.setRecordId(component, helper)
            helper.checkErrors(component, helper)
        })
    },
    setRecordId : function(component, helper) {
        var record = component.get('v.boatReview')
        var boat = component.get('v.boat')
        record.Boat__c = boat.Id
        component.set('v.record', record)
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