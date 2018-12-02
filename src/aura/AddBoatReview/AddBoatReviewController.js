({
    doInit : function(component, event, helper) {
        helper.onInit(component, event, helper)
    },
    onSave : function(component, event, helper) {
        component.find("service").saveRecord(saveResult => {
            helper.showMessage("Success", "The record has been saved successfully.")
            helper.onInit(component, event, helper)
            helper.notifyReviewAdded(component)
        })
    },
    onRecordUpdated : function(component, event, helper) {
        helper.showMessage("Success", "The record has been updated successfully.")
    }
})