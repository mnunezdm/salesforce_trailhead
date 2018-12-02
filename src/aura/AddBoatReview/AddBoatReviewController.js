({
    doInit : function(component, event, helper) {
        helper.onInit(component, event, helper)
    },
    onSave : function(component, event, helper) {
        component.find("service").saveRecord(saveResult => {
            // helper.showMessage("Success", "The record has been saved successfully.")
            var toast = $A.get("e.force:showToast")
            if (toast) {
                toast.setParams({'title': 'Success',
                                 'message': 'The record has been saved successfully',
                                 'type': 'success'});
                toast.fire();
            } else {
                console.log('AddBoatReviewController-INFO: toast not supported using alert')
                alert(`${title}: ${message}`)
            }
            helper.onInit(component, event, helper)
            // helper.notifyReviewAdded(component)
            console.log('AddBoatReviewController-INFO: Firing event')
            var event = component.getEvent('BoatReviewAdded')
            event.fire()
        })
    },
    onRecordUpdated : function(component, event, helper) {
        var eventParams = event.getParams();
        if (eventParams.changeType === 'CHANGED') {
            // helper.showMessage("Success", "The record has been updated successfully")
            var toast = $A.get("e.force:showToast")
            if (toast) {
                toast.setParams({'title': 'Success',
                                 'message': 'The record has been updated successfully',
                                 'type': 'success'});
                toast.fire();
            } else {
                console.log('AddBoatReviewController-INFO: toast not supported using alert')
                alert(`${title}: ${message}`)
            }
            helper.onInit(component, event, helper)
            helper.notifyReviewAdded(component)
        } else {
            console.log(`AddBoatReviewController-INFO: Change was of type: ${eventParams.changeType}`)
        }
    }
})