({
    fetchBoatTypes : function(component) {
        var action = component.get('c.getBoatTypes')
        action.setCallback(this, function(response) {
            console.log(response.getState())
            if (response.getState() === 'SUCCESS') {
                var boatTypes = response.getReturnValue()
                console.log(`SUCCESS fetching boat types ${boatTypes.length}`)
                component.set('v.boatTypes', boatTypes)
            } else {
                console.log('ERROR fetching boat types')
            }
        })
        $A.enqueueAction(action)
    }
})