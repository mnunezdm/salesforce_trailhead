({
    onBoatSelected : function(component, event, helper) {
        var boat = event.getParam('boat')

        var boatJson = JSON.parse(JSON.stringify(boat))
        console.log('BoatDetailsController-Handled Event for ', boatJson)
        component.set('v.id', boat.Id)

        component.find('service').reloadRecord()
    },
    onRecordUpdated : function(component, event, helper) {
        var updatedRecord = JSON.parse(JSON.stringify(component.get('v.boat')))
        console.log('BoatDetailsController-INFO', updatedRecord)
    }
})