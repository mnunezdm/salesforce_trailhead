({
    onBoatClick: function(component, event, helper) {
        console.log('Firing Component boatSelect Event')
        var eventSelect = component.getEvent('boatSelect')
        var boatId = component.get('v.boat').Id
        eventSelect.setParams({boatId})
        eventSelect.fire()

        console.log('Firing Application boatSelected Event')
        var eventSelected = $A.get('e.c:boatSelected')
        var boat = component.get('v.boat')
        console.log('boat...', boat.Id)
        eventSelected.setParams({boat})
        eventSelected.fire()

        console.log('All events fired')
    }
})