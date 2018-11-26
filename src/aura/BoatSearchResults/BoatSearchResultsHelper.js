({
    onSearch : function(component, boatTypeId) {
        var action = component.get('c.getBoats')
        action.setParams({boatTypeId})
        action.setCallback(this, function(response) {
            if (response.getState() === 'SUCCESS') {
                var boats = response.getReturnValue()
                console.log(`BoatSearchResultsHelper-SUCCESS fetched a total of ${boats.length} boats`)
                component.set('v.boats', boats)
            } else {
                console.log('BoatSearchResultsHelper-ERROR fetching boats')
            }
        })
        $A.enqueueAction(action)
    }
})