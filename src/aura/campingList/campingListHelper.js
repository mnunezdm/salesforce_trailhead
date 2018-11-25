({
	saveItem : function(component, item) {
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