({
    doInit : function(component, event, helper) {
        helper.detectIfDetailsAvailable(component)
    },
    onFullDetails : function(component, event, helper) {
        var event = $A.get("e.force:navigateToSObject")
        var recordId = component.get("v.boat.Id")
        event.setParams({
            recordId,
            "slideDevName": "detail"
        })
        event.fire()
    }
})