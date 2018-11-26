({
    doInit: function(component, event, helper) {
        helper.onSearch(component, '')
    },
    doSearch: function(component, event, helper) {
        console.log('Do search called...')
        var formData = event.getParam('arguments')
        helper.onSearch(component, formData.boatTypeId)
    },
    onBoatSelect: function(component, event, helper) {
        var boatId = event.getParam('boatId')
        var previousBoat = component.get('v.selectedBoatId')
        console.log(`new selected is ${boatId}, old was ${previousBoat}`)
        component.set('v.selectedBoatId', boatId)
    }
})