({
    jsLoaded: function(component) {
        component.set("v.jsLoaded", true);
    },
    onPlotMapMarker : function(component, event, helper) {
        console.log('Event handled')
        var eventParams = event.getParams()
        console.log(JSON.parse(JSON.stringify(eventParams)))

    }
})