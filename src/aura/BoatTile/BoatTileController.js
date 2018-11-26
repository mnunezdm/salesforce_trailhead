({
    onBoatClick: function(component, event, helper) {
        var event = component.getEvent('boatSelect')
        var boatId = component.get('v.boat').Id
        event.setParams({boatId})
        event.fire()
    }
})