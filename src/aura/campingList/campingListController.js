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
	clickCreateItem : function(component, event, helper) {
        var isFormValid = component.find("campingForm").reduce(function(isValid, inputCmp){
        	inputCmp.showHelpMessageIfInvalid()
            return isValid && inputCmp.get("v.validity").valid
        })

        if (isFormValid) {
            var newCampingItem = JSON.parse(JSON.stringify(component.get("v.newItem")))
            newCampingItem.sobjectType = undefined
            console.log(JSON.parse(JSON.stringify(newCampingItem)), JSON.stringify(newCampingItem))
            helper.createItem(component, newCampingItem)
        }
	}
})