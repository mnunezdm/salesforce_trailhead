({
    jsLoaded: function(component) {
        component.set("v.jsLoaded", true);
    },
    onPlotMapMarker : function(component, event, helper) {
        var eventParams = event.getParams()
        var long = eventParams.long
        var lat = eventParams.lat
        component.set('v.location', {long, lat})
    }
})