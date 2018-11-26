({
    onBoatClick: function(component, event, helper) {
        var eventSelect = component.getEvent('boatSelect')
        var boatId = component.get('v.boat').Id
        eventSelect.setParams({boatId})
        eventSelect.fire()

        var eventSelected = $A.get('e.c:BoatSelected')
        var boat = component.get('v.boat')
        eventSelected.setParams({boat})
        eventSelected.fire()
    }
})