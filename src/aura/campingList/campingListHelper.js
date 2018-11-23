({
	createItem : function(component, item) {
        var action = component.get("c.saveItem")
        action.setParams({
            "campingItem": item
        })
        action.setCallback(this, function(response) {
            if (response.getState() === 'SUCCESS') {
                var campingItems = component.get('v.items')
                campingItems.push(response.getReturnValue())
                component.set("v.items", campingItems)
                component.set("v.newItem", {'Price__c': 0, 'Packed__c': false, 'Quantity__c': 0, 'Name':'', 'sobjectType': 'Camping_Item__c'})
            } else {
                alert('error at server side')
            }
        })
        $A.enqueueAction(action)
	}
})