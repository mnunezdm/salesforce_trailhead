({
    onBoatSelected : function(component, event, helper) {
        console.log('EVENT HANDLED')
        var boat = event.getParam('boat')
        console.log('this is undefined', boat)
        component.set('v.id', boat.Id)
        console.log('boat id', boat.Id)

        component.find('service').reloadRecord()
    },
    onRecordUpdated : function(component, event, helper) {
        console.log('hum')
        console.log(JSON.parse(JSON.stringify(component.get('v.boat'))))
        console.log(component.get('v.boat').Name)
    }
})