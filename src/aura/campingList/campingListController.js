({
    doInit : function(component, event, helper) {
        var action = component.get("c.getItems")
        action.setCallback(this, function(response) {
            if(response.getState() === 'SUCCESS') {
                var responseBody = response.getReturnValue()
                console.log(`Retrieved a total of ${responseBody.length}`)
                component.set("v.items", responseBody)
            } else {
                console.log('Error')
            }
        })
        $A.enqueueAction(action)
    },
    handleAddItem: function(component, event, helper) {
        console.log('EVENT HANDLED')
        var item = event.getParam('item')
        var action = component.get("c.saveItem")
        action.setParams({
            "campingItem": item
        })
        action.setCallback(this, function(response) {
            if (response.getState() === 'SUCCESS') {
                var campingItems = component.get('v.items')
                campingItems.push(response.getReturnValue())
                component.set("v.items", campingItems)
            } else {
                alert('error at server side')
            }
        })
        $A.enqueueAction(action)
    }
})