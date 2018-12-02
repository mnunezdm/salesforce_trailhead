({
    onBoatClick: function(component, event, helper) {
        var eventSelect = component.getEvent('boatSelect')
        var boatId = component.get('v.boat').Id
        eventSelect.setParams({boatId})
        eventSelect.fire()

        var boat = component.get('v.boat')

        var eventSelected = $A.get('e.c:BoatSelected')
        eventSelected.setParams({boat})
        eventSelected.fire()

        var plotSelected = $A.get('e.c:PlotMapMarker')
        plotSelected.setParams({
            'sObjectId': boat.Id,
            'lat': boat.Geolocation__Latitude__s,
            'long': boat.Geolocation__Longitude__s,
            'label': boat.Name,
        })
        plotSelected.fire()
    }
})