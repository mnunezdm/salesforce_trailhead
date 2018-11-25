({
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