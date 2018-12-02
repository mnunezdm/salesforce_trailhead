({
    doInit : function(component, event, helper) {
        helper.onInit(component, helper)
    },
    onUserInfoClick : function(component, event, helper) {
        var recordId = event.currentTarget.dataset.userid
        console.log(`BoatReviewsController-INFO: navigating to ${recordId}`)
        var event = $A.get("e.force:navigateToSObject")
        event.setParams({
            recordId,
            "slideDevName": "detail"
        })
        event.fire()
    }
})
