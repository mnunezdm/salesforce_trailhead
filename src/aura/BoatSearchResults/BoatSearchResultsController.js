({
    doInit: function(component, event, helper) {
        helper.onSearch(component, '')
    },
    doSearch: function(component, event, helper) {
        var formData = event.getParam('arguments')
        helper.onSearch(component, formData.boatTypeId)
    },
    onBoatSelect: function(component, event, helper) {
        var boatId = event.getParam('boatId')
        var previousBoat = component.get('v.selectedBoatId')
        console.log(`BoatSearchResultsController-INFO: New: ${boatId}, Old: ${previousBoat}`)
        component.set('v.selectedBoatId', boatId)
    }
})